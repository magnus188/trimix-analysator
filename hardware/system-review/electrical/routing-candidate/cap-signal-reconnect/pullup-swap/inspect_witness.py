from pathlib import Path
import sys,json,hashlib
D=Path(__file__).resolve().parent
sys.path.insert(0,str(D.parents[2]/'current-path-review'))
from inventory import *
f=D/'Trimix_Analyzer.kicad_pcb';b=p.LoadBoard(str(f));g=NativeGraph(b,stackup(f.read_text()))
rows=[]
for source,target in [('R107.2','U101.7'),('R107.2','J301.13'),('R107.2','Q112.3'),('R107.1','J301.1'),('R302.1','J301.1'),('R302.2','U101.5')]:
 if source not in g.pad_index or target not in g.pad_index:raise AssertionError((source,target))
 w=g.witness(g.pad_index[source][0],g.pad_index[target][0]);assert w['status']=='explicit_native_witness',(source,target,w)
 rows.append({'source':source,'target':target,'witness':w})
 print(source,target,w['status'])
vias=[u for u,q in g.objects.items()if isinstance(q,p.PCB_VIA) and abs(p.ToMM(q.GetPosition().x)-7.75)<1e-6 and abs(p.ToMM(q.GetPosition().y)-85.525)<1e-6]
assert len(vias)==1
via=g.objects[vias[0]];assert via.GetNetname()=='GND'and via.IsOnLayer(p.In1_Cu)
for source in ['C101.2','C105.2']:
 w=g.witness(g.pad_index[source][0],vias[0]);assert w['status']=='explicit_native_witness',(source,w)
 rows.append({'source':source,'target':vias[0],'via_xy_mm':[7.75,85.525],'via_diameter_mm':p.ToMM(via.GetWidth(p.F_Cu)),'via_drill_mm':p.ToMM(via.GetDrillValue()),'direct_In1_barrel':True,'witness':w})
(D/'native-witnesses.json').write_text(json.dumps({'pcb_sha256':hashlib.sha256(f.read_bytes()).hexdigest(),'witnesses':rows},indent=2)+'\n')
