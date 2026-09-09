from pathlib import Path
import sys,json
D=Path(__file__).resolve().parent
sys.path.insert(0,str(D.parents[1]/'current-path-review'))
from inventory import *
f=D/'Trimix_Analyzer.kicad_pcb';b=p.LoadBoard(str(f));g=NativeGraph(b,stackup(f.read_text()))
for target in ['U101.7','J301.13']:
 w=g.witness(g.pad_index['Q112.3'][0],g.pad_index[target][0]);(D/('witness-'+target+'.json')).write_text(json.dumps(w,indent=2)+'\n')
 print(target,w['status'])
vias=[u for u,q in g.objects.items()if isinstance(q,p.PCB_VIA) and abs(p.ToMM(q.GetPosition().x)-11.1)<1e-6 and abs(p.ToMM(q.GetPosition().y)-91.1)<1e-6]
assert len(vias)==1
v=g.objects[vias[0]];assert v.GetNetname()=='GND'and v.IsOnLayer(p.In1_Cu)
w=g.witness(g.pad_index['C114.2'][0],vias[0]);assert w['status']=='explicit_native_witness'
(D/'witness-C114-ground.json').write_text(json.dumps({'via_xy_mm':[11.1,91.1],'via_diameter_mm':p.ToMM(v.GetWidth(p.F_Cu)),'via_drill_mm':p.ToMM(v.GetDrillValue()),'direct_In1_barrel':True,'witness':w},indent=2)+'\n')
