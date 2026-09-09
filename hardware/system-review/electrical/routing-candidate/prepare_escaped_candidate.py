"""Route only after package-width necks and local placement are natively checked."""
from pathlib import Path
import sys,json,re,shutil
import pcbnew as p
ROOT=Path(__file__).resolve().parents[4];OUT=Path(__file__).resolve().parent
src=OUT/'native/Trimix_Analyzer.kicad_pcb';b=p.LoadBoard(str(src));shutil.copy2(src,OUT/'escaped-before-routing.kicad_pcb')
assert p.ExportSpecctraDSN(b,str(OUT/'escaped.dsn'));s=(OUT/'escaped.dsn').read_text()
settings='''(autoroute_settings (fanout on) (autoroute on) (postroute off) (vias on)
(layer_rule F.Cu (active on) (preferred_direction vertical))
(layer_rule In1.Cu (active off) (preferred_direction horizontal))
(layer_rule In2.Cu (active on) (preferred_direction horizontal))
(layer_rule B.Cu (active on) (preferred_direction horizontal)))'''
s=s.replace('    (boundary','    '+settings+'\n    (boundary',1)
i=s.index('    (class kicad_default ');j=s.index('\n  (wiring',i)
names={n.GetNetname()for n in b.GetNetInfo().NetsByNetcode().values()if n.GetNetname()}
held={'Net-(L201-Pad1)','Net-(L201-Pad2)','CO_SW'}|{n for n in names if n.endswith(('/BQ_SW','/BQ_PMID','/BQ_BTST'))}
power={'PACK_P','VSYS','VOUT_5V','HOST_5V','USB_5V','USB_OVP_5V','USB_CHG_5V'}
classes={'power_manual':(held,.4),'power_distribution':(power,.4),'signal':(names-held-power,.15)}
new=''
for name,(nets,width)in classes.items():
 new+='    (class '+name+' '+' '.join(json.dumps(n)for n in sorted(nets))+'\n      (circuit(use_via "Via[0-3]_600:300_um"))\n      (rule(width '+str(int(width*1000))+')(clearance 200)))\n'
s=s[:i]+new+'  )\n'+s[j:]
# Every existing short escape/hot loop is reviewed individually; it must not
# be removed by automatic rip-up. The unrouted topology remains provisional.
s=s.replace('(type route)','(type protect)')
(OUT/'escaped.dsn').write_text(s)
(OUT/'escaped-intent.json').write_text(json.dumps({'candidate_only':True,'signal_width_mm':.15,'local_U111_necks_mm':.125,'routing_clearance_mm':.2,'power_topology_width_mm':.4,'power_current_qualification':'Widen/review long trunks after routing. Not a released current rating.','power_outer_layers_only':sorted(power),'In1_signals_forbidden':True,'held_switch_nets':sorted(held),'order_release':False},indent=2)+'\n')
print('Escaped DSN prepared')
