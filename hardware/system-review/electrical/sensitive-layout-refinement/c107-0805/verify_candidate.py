import sys,json,hashlib,math
from pathlib import Path
sys.path.insert(0,str(Path('hardware/system-review/electrical/current-path-review').resolve()))
from inventory import NativeGraph,stackup,p
D=Path(__file__).resolve().parent;src=D/'candidate/Trimix_Analyzer.kicad_pcb';data=src.read_bytes();b=p.LoadBoard(str(src));g=NativeGraph(b,stackup(data.decode()))
rows=[]
for a,z in [('U101.22','C107.1'),('U101.22','R101.1'),('U101.21','C103.2'),('U101.19','C103.1')]:
 u,v=g.pad_index[a][0],g.pad_index[z][0];rows.append(dict(source=a,target=z,**g.witness(u,v)))
gvia=next(u for u,q in g.items.items()if q['kind']=='via'and q['net']=='GND'and q['at_mm']==[16.05,78.05]);rows.append(dict(source='C107.2',target='GNDvia16.05,78.05',**g.witness(g.pad_index['C107.2'][0],gvia)))
f=next(f for f in b.GetFootprints()if f.GetReference()=='C107');f.BuildCourtyardCaches();bb=f.GetCourtyard(p.B_Cu).BBox();cb=[p.ToMM(bb.GetX()),p.ToMM(bb.GetY()),p.ToMM(bb.GetRight()),p.ToMM(bb.GetBottom())]
v=g.objects[gvia];gap=[]
for fp in b.GetFootprints():
 for q in fp.Pads():
  if q.GetAttribute()!=p.PAD_ATTRIB_SMD:continue
  L=q.GetLayer();s=q.GetEffectiveShape(L);pt=v.GetPosition();lo=0;hi=3
  for _ in range(30):
   m=(lo+hi)/2
   if s.Collide(pt,p.FromMM(m)):hi=m
   else:lo=m
  gap.append({'ref':fp.GetReference(),'pin':q.GetNumber(),'surface_gap_mm':lo-.25,'foreign_net':q.GetNetname()!='GND'})
nearest=sorted(gap,key=lambda r:r['surface_gap_mm'])[:6]
result={'board_sha256':hashlib.sha256(data).hexdigest(),'source_sha256':hashlib.sha256((D/'source.kicad_pcb').read_bytes()).hexdigest(),'witnesses':rows,'new_via_uuid':gvia,'new_via_nearest_SMT_surface_gaps_mm':nearest,'C107_courtyard_bounds_mm':cb,'carrier_requested_opening_mm':[cb[0]-.30,cb[1]-.30,cb[2]+.30,cb[3]+.30],'body_max_mm':[2.2,1.45,1.45],'assembly_clearance_mm':.15,'B_Cu_Fusion_Z_mm':20.5,'body_with_assembly_Fusion_Z_mm':[18.9,20.5],'no_accepted_CAD_modification':True,'limits':['Native witness full item lengths include land overlap; not a clipped physical path or dynamic impedance.','Zones are excluded from these witnesses; separate ground-plane coverage check required.']}
(D/'native-witnesses.json').write_text(json.dumps(result,indent=2)+'\n');print(json.dumps({k:v for k,v in result.items()if k!='witnesses'},indent=2));print([(r['source'],r['target'],r['status'],r.get('layer_summary'),r.get('barrel_transition_count'))for r in rows]);assert data==src.read_bytes()
