"""Retain improved hot loops; route remaining signals and wide outer-layer supplies."""
from pathlib import Path
import sys,json,shutil,re
import pcbnew as p
ROOT=Path(__file__).resolve().parents[4];OUT=Path(__file__).resolve().parent
sys.path.insert(0,str(ROOT/'hardware/tools'));from analyzer_sheet import sx,child,children
src=OUT/'native/Trimix_Analyzer.kicad_pcb';a=sx.loads(src.read_text());netmap={n[1]:n[2]for n in children(a,'net')}
reroute={'POWER_EN','PB_FILTERED_N','Net-(U801-ONT)','HOST_3V3','O2_B_AIN_P'}
for k in['segment','via']:
 for t in list(children(a,k)):
  net=child(t,'net')[1]
  if netmap.get(net,net)in reroute:a.remove(t)
src.write_text(sx.dumps(a));b=p.LoadBoard(str(src))
# Explicit track/via-only edge reserves for the autorouter. Native edge rule
# remains0.5mm. Pads and zones still use their independently checked constraints.
rects=[(0,0,.5,94.8),(29.5,17,30,99),(0,0,8.9,.5),(8.4,0,8.9,17),(8.9,17,30,17.5),(5.8,98.5,30,99),(5.8,94.8,6.3,99),(0,94.3,5.8,94.8)]
for idx,(x0,y0,x1,y1)in enumerate(rects):
 z=p.ZONE(b);z.SetLayerSet(p.LSET.AllCuMask(4));z.SetZoneName('ROUTER_EDGE_RESERVE_'+str(idx));z.SetIsRuleArea(True);z.SetDoNotAllowTracks(True);z.SetDoNotAllowVias(True);z.SetDoNotAllowPads(False);z.SetDoNotAllowFootprints(False);z.SetDoNotAllowZoneFills(False);poly=z.Outline();poly.NewOutline()
 for x,y in[(x0,y0),(x1,y0),(x1,y1),(x0,y1)]:poly.Append(p.VECTOR2I(p.FromMM(x),p.FromMM(y)))
 b.Add(z)
p.ZONE_FILLER(b).Fill(b.Zones());p.SaveBoard(str(src),b);shutil.copy2(src,OUT/'refined-before-routing.kicad_pcb')
assert p.ExportSpecctraDSN(b,str(OUT/'refined.dsn'));s=(OUT/'refined.dsn').read_text()
settings='''(autoroute_settings (fanout on) (autoroute on) (postroute off) (vias on)
(layer_rule F.Cu (active on) (preferred_direction vertical))
(layer_rule In1.Cu (active off) (preferred_direction horizontal))
(layer_rule In2.Cu (active on) (preferred_direction horizontal))
(layer_rule B.Cu (active on) (preferred_direction horizontal)))'''
s=s.replace('    (boundary','    '+settings+'\n    (boundary',1)
i=s.index('    (class kicad_default ');j=s.index('\n  (wiring',i)
names={n.GetNetname()for n in b.GetNetInfo().NetsByNetcode().values()if n.GetNetname()}
held={'Net-(L201-Pad1)','Net-(L201-Pad2)','CO_SW'}|{n for n in names if n.endswith(('/BQ_SW','/BQ_PMID','/BQ_REGN','/BQ_BTST'))}
power={'PACK_P','VSYS','VOUT_5V','HOST_5V','USB_5V','USB_OVP_5V','USB_CHG_5V'}
classes={'power_manual':(held,.5),'power_distribution':(power,1.0),'signal':(names-held-power,.2)}
new=''
for name,(nets,width)in classes.items():
 new+='    (class '+name+' '+' '.join(json.dumps(n)for n in sorted(nets))+'\n      (circuit(use_via "Via[0-3]_600:300_um"))\n      (rule(width '+str(int(width*1000))+')(clearance 200)))\n'
new+='  )\n';s=s[:i]+new+s[j:]
# Lock all reviewed ground returns and converter/output-bank copper; other
# candidate traces may be optimized. No part placement is authorized by DSN.
lines=s.splitlines();protected=held|{'GND','VOUT_5V','VSYS'}
for i,line in enumerate(lines):
 if '(type route)' in line:
  match=re.search(r'\(net ("[^"]*"|[^)]+)\)',line)
  if match:
   net=match[1];net=json.loads(net)if net.startswith('"')else net
   if net in protected:lines[i]=line.replace('(type route)','(type protect)')
(OUT/'refined.dsn').write_text('\n'.join(lines)+'\n')
(OUT/'refined-intent.json').write_text(json.dumps({'rerouted_signal_nets':sorted(reroute),'power_distribution_outer_only':sorted(power),'power_width_mm':1.0,'manual_switch_loop_nets':sorted(held),'edge_keepout_width_mm':.5,'In1_signals_forbidden':True,'candidate_only':True,'order_release':False},indent=2)+'\n');print('Refined DSN ready')
