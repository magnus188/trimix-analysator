"""Isolated, reproducible DSN candidate: no authoritative PCB mutation.

In1 is reserved for GND. In2 beneath the B.Cu protection cluster is reserved
for GND. All existing power-loop copper is fixed. Signal detours may optimize.
Published Freerouting2.0.1 DSN settings and CLI are used; this is not acceptance.
"""
from pathlib import Path
import sys,json,hashlib,shutil,re
ROOT=Path(__file__).resolve().parents[4]
sys.path.insert(0,str(ROOT/'hardware/tools'))
from analyzer_sheet import sx,child,children,S,node
import pcbnew as p
OUT=Path(__file__).resolve().parent
src=ROOT/'hardware/pcb/analyzer/Trimix_Analyzer.kicad_pcb'
stage=OUT/'candidate.kicad_pcb'
a=sx.loads(src.read_text());fixed={x['uuid']for x in json.loads((OUT.parent/'power-route-draft.json').read_text())['tracks']}
# Preserve ground returns and power copper. Remove the crude signal detours only
# in this isolated candidate so the multilayer router can shorten them.
removed=0
nets={n[1]:n[2]for n in children(a,'net')}
for k in ('segment','via'):
 for t in list(children(a,k)):
  net=child(t,'net')[1];name=nets.get(net,net)
  if child(t,'uuid')[1]not in fixed and name!='GND':a.remove(t);removed+=1
stage.write_text(sx.dumps(a))
for ext in('.kicad_pro','.kicad_dru'):
 f=src.with_suffix(ext)
 if f.exists():shutil.copy2(f,stage.with_suffix(ext))
b=p.LoadBoard(str(stage));g=b.FindNet('GND')
z=p.ZONE(b);z.SetLayer(p.In2_Cu);z.SetNetCode(g.GetNetCode());z.SetZoneName('OVP_BACKSIDE_GND_REFERENCE');z.SetLocalClearance(p.FromMM(.2));z.SetMinThickness(p.FromMM(.2));z.SetPadConnection(p.ZONE_CONNECTION_FULL)
poly=z.Outline();poly.NewOutline()
for x,y in[(7,83),(21,83),(21,95),(7,95)]:poly.Append(p.VECTOR2I(p.FromMM(x),p.FromMM(y)))
b.Add(z);p.ZONE_FILLER(b).Fill(b.Zones());p.SaveBoard(str(stage),b)
assert p.ExportSpecctraDSN(b,str(OUT/'candidate.dsn'))
s=(OUT/'candidate.dsn').read_text()
settings='''(autoroute_settings (fanout on) (autoroute on) (postroute on) (vias on)
(layer_rule F.Cu (active on) (preferred_direction vertical))
(layer_rule In1.Cu (active off) (preferred_direction horizontal))
(layer_rule In2.Cu (active on) (preferred_direction horizontal))
(layer_rule B.Cu (active on) (preferred_direction horizontal)))'''
s=s.replace('    (boundary','    '+settings+'\n    (boundary',1)
# DSN already contains our In1 and local In2 GND planes. Keep power paths locked,
# and leave their unresolved connections to explicit width/return-path routing.
s=s.replace('(type route)','(type protect)')
i=s.index('    (class kicad_default ');j=s.index('\n  (wiring',i)
old=s[i:j];rule=old[old.index('      (circuit'):]
# Remove final network-closing bracket when using the existing class tail.
rule=rule.rstrip();assert rule.endswith('  )');rule=rule[:-3]
netnames=[n.GetNetname()for n in b.GetNetInfo().NetsByNetcode().values()if n.GetNetname()]
power={'PACK_P','VSYS','VOUT_5V','HOST_5V','USB_5V','USB_OVP_5V','USB_CHG_5V','Net-(L201-Pad1)','Net-(L201-Pad2)','CO_SW'}
power|={n for n in netnames if n.endswith(('/BQ_SW','/BQ_PMID','/BQ_REGN','/BQ_BTST'))}
classes={'power_manual':sorted(power),'signal':sorted(set(netnames)-power)}
new=''
for name,names in classes.items():
 new+='    (class '+name+' '+' '.join(json.dumps(n)for n in names)+'\n'+rule+'\n'
new+='  )\n'
s=s[:i]+new+s[j:]
(OUT/'candidate.dsn').write_text(s)
receipt={'authoritative_source_sha256':hashlib.sha256(src.read_bytes()).hexdigest(),'candidate_only':True,'removed_signal_segments':removed,'fixed_power_items':len(fixed),'In1_signal_routing':False,'In2_GND_reserve_mm':[7,83,21,95],'excluded_net_class':'power_manual','manual_power_nets':sorted(power),'trace_width_mm':.20,'clearance_mm':.20,'via_mm':[.6,.3],'acceptance':'Native DRC, unchanged component geometry and independent power/analogue-return review required; connectivity alone insufficient.'}
(OUT/'candidate-intent.json').write_text(json.dumps(receipt,indent=2)+'\n');print(json.dumps(receipt,indent=2))
