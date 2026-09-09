"""Bounded residual routing with reviewed local escapes and a reserved ground plane."""
from pathlib import Path
import sys,json,re,shutil,math
import pcbnew as p
ROOT=Path(__file__).resolve().parents[4];OUT=Path(__file__).resolve().parent
src=OUT/'native/Trimix_Analyzer.kicad_pcb';b=p.LoadBoard(str(src));shutil.copy2(src,OUT/'residual-before-routing.kicad_pcb')
assert p.ExportSpecctraDSN(b,str(OUT/'residual.dsn'));s=(OUT/'residual.dsn').read_text()
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
classes={'power_manual':(held,.4,'600:300'),'power_distribution':(power,.4,'600:300'),'signal':(names-held-power,.15,'500:250')}
new=''
for name,(nets,width,vsize)in classes.items():
 new+='    (class '+name+' '+' '.join(json.dumps(n)for n in sorted(nets))+'\n      (circuit(use_via "Via[0-3]_'+vsize+'_um"))\n      (rule(width '+str(int(width*1000))+')(clearance 200)))\n'
s=s[:i]+new+'  )\n'+s[j:]
assert 'padstack "Via[0-3]_500:250_um"' in s
rects=[(9.7,81,17.1,86.9),(23.4,75.7,26.9,79.4),(11.7,86.2,15.95,92.5),(24.7,72.3,28.1,75.85)]
def inside(pt,r):return r[0]<=pt[0]<=r[2]and r[1]<=pt[1]<=r[3]
count=0
for line in re.findall(r'    \((?:wire|via) .*?\(type route\)\)',s[s.index('  (wiring'):],re.S):
 n=re.search(r'\(net (.*?)\)\s*\(type',line).group(1).strip('"')
 protect=n in held
 if '(via 'in line:
  protect |= '450:200' in line
 else:
  m=re.search(r'\(path (\S+) ([\d.]+)\s+([^)]*)\)',line)
  if m:
   nums=list(map(float,m[3].split()));pts=[(nums[k]/1000,-nums[k+1]/1000)for k in range(0,len(nums),2)]
   protect |= float(m[2])<150
   protect |= any(all(inside(pt,r)for pt in pts)for r in rects)
   protect |= n=='VOUT_5V'and float(m[2])>=800
   # The fixed local short power loops remain visible and editable in KiCad.
   protect |= n in power and sum(math.dist(u,v)for u,v in zip(pts,pts[1:]))<=2.5
 if protect:s=s.replace(line,line.replace('(type route)','(type protect)'));count+=1
(OUT/'residual.dsn').write_text(s)
(OUT/'residual-intent.json').write_text(json.dumps({'candidate_only':True,'ordinary_signal_width_mm':.15,'ordinary_via_mm':[.5,.25],'explicit_dense_via_mm':[.45,.2],'local_U111_necks_mm':.125,'routing_clearance_mm':.2,'power_topology_width_mm':.4,'protected_wire_via_records':count,'power_current_qualification':'Widen/review long trunks after routing; not a released current rating.','power_outer_layers_only':sorted(power),'In1_signals_forbidden':True,'held_switch_nets':sorted(held),'order_release':False},indent=2)+'\n')
print('Residual DSN prepared;',count,'protected records')
