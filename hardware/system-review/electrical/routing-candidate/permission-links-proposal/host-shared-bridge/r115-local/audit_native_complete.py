from pathlib import Path
import sys,json,hashlib,math,collections
import pcbnew as p
sys.path.insert(0,str(Path('hardware/system-review/electrical/current-path-review').resolve()))
from inventory import NativeGraph,stackup
D=Path(__file__).resolve().parent;f=D/'complete-controls-frozen.kicad_pcb';b=p.LoadBoard(str(f));g=NativeGraph(b,stackup(f.read_text()));dd=json.loads((D/'complete-controls-delta.json').read_text());pairs=[]
for a,z in [('R115.1','U113.6'),('R115.2','U113.1'),('U113.1','U112.6'),('R118.1','U112.5'),('R119.1','U114.4'),('R116.1','U114.4'),('R116.2','Q110.3'),('Q110.2','Q111.3'),('Q110.1','U112.5'),('U115.1','R125.1'),('U115.3','U113.3'),('U101.7','R107.2'),('U101.7','J301.13'),('C116.2','R126.2'),('C116.1','U115.7'),('U115.2','R122.2'),('U115.2','R123.1')]:
 if not g.pad_index[a]or not g.pad_index[z]:continue
 w=g.witness(g.pad_index[a][0],g.pad_index[z][0]);pairs.append(dict(source=a,target=z,witness=w));print(a,z,w['status'])
for a,v in [('C116.2','81a50918-f412-49be-81fe-86e8e1ae9c47'),('R126.2','81a50918-f412-49be-81fe-86e8e1ae9c47'),('U115.8','2ba862de-d0a8-4cf0-87a2-0078c6153d03'),('R118.2','71bceb66-738c-4023-9eb7-50d40bb299bb'),('R119.2','f37fff8a-5365-4545-b8ef-52d2339f0750')]:
 if not g.pad_index[a]:continue
 w=g.witness(g.pad_index[a][0],v);pairs.append(dict(source=a,target_via=v,witness=w));print(a,v,w['status'])
(D/'native-conductor-witnesses.json').write_text(json.dumps(dict(source_sha256=hashlib.sha256(f.read_bytes()).hexdigest(),pairs=pairs,method='Native direct physical adjacency; no zone shortcuts or IC internal assumptions.'),indent=2))
viuids={q['uuid']for q in dd['added']if q['kind']=='via'}|{q['uuid']for q in dd['changed']if q['after']['kind']=='via'}
rows=[]
for v in b.GetTracks():
 if not isinstance(v,p.PCB_VIA)or v.m_Uuid.AsString()not in viuids:continue
 pos=[p.ToMM(v.GetPosition().x),p.ToMM(v.GetPosition().y)];special=pos in [[13.6,89.775],[13.6,91.0],[17.95,87.925]];near=[]
 for fp in b.GetFootprints():
  for q in fp.Pads():
   if math.dist(pos,[p.ToMM(q.GetPosition().x),p.ToMM(q.GetPosition().y)])>3:continue
   for L in [p.F_Cu,p.B_Cu]:
    if not q.IsOnLayer(L):continue
    a=v.GetEffectiveShape(L);z=q.GetEffectiveShape(L);lo=0;hi=5
    for i in range(22):
     mid=(lo+hi)/2
     if a.Collide(z,p.FromMM(mid)):hi=mid
     else:lo=mid
    near.append(dict(ref=fp.GetReference(),pad=q.GetNumber(),net=q.GetNetname(),layer=b.GetLayerName(L),same_net=q.GetNetname()==v.GetNetname(),gap_lower_mm=lo))
 near.sort(key=lambda q:q['gap_lower_mm']);fail=[q for q in near if q['gap_lower_mm']<(.0499 if q['same_net']else .1999)]if not special else[]
 rows.append(dict(uuid=v.m_Uuid.AsString(),at_mm=pos,net=v.GetNetname(),diameter_mm=p.ToMM(v.GetWidth(p.F_Cu)),drill_mm=p.ToMM(v.GetDrillValue()),special_filled_capped_interface=special,nearest_pads=near,ordinary_via_failures=fail));print('VIA',pos,'special',special,'fail',fail)
(D/'new-via-interface-audit.json').write_text(json.dumps(dict(source_sha256=hashlib.sha256(f.read_bytes()).hexdigest(),vias=rows,rule='Ordinary surface gap>=.05 same-net / >=.20 foreign-net; exact three filled/capped interfaces excluded from this ordinary rule and need their separate factory/geometry audits. Native fullDRC applies to every via.'),indent=2))
