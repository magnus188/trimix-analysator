from pathlib import Path
import pcbnew as p,json,hashlib,math,collections
D=Path(__file__).resolve().parent;P=D/'before.kicad_pcb';H='609a6241ce50cbe3d40f7a1676c455092db583875895eeb8236083bf2c5f0ef1';assert hashlib.sha256(P.read_bytes()).hexdigest()==H;b=p.LoadBoard(str(P))
def v(q):return p.VECTOR2I(p.FromMM(q[0]),p.FromMM(q[1]))
def xy(q):return[p.ToMM(q.x),p.ToMM(q.y)]
soft={'/01  CHARGING + BATTERY/CHG_CE_N','CHG_INT_N','USB_CC_INT_N','USB_OVP_SET'}
obs=[];hard=[]
for t in list(b.GetTracks())+[d for f in b.GetFootprints()for d in f.Pads()]:
 if t.GetNetname()=='VSYS'or not t.IsOnLayer(p.In2_Cu):continue
 s=t.GetEffectiveShape(p.In2_Cu);obs.append((t,s))
 if isinstance(t,p.PCB_VIA)or isinstance(t,p.PAD)or t.GetNetname()not in soft:hard.append((t,s))
edge=[d.GetEffectiveShape()for d in b.GetDrawings()if d.GetLayer()==p.Edge_Cuts];rules=[z.Outline()for z in list(b.Zones())+[z for f in b.GetFootprints()for z in f.Zones()]if z.GetIsRuleArea()and z.GetLayerSet().Contains(p.In2_Cu)and z.GetDoNotAllowTracks()]
def clear(a,z):
 seg=p.SEG(v(a),v(z));return not any(s.Collide(seg,p.FromMM(.4001))for t,s in hard)and not any(s.Collide(seg,p.FromMM(.7001))for s in edge)and not any(s.Collide(seg,p.FromMM(.2001))for s in rules)
data=json.loads((D.parent/'hypothetical-sys-barriers.json').read_text());rows=data['segments'];pts=[rows[0]['start']]+[r['end']for r in rows]
bad=[(a,z)for a,z in zip(pts,pts[1:])if not clear(a,z)];print('oldhypotheticalhardfail',len(bad),bad[:5]);simple=[pts[0]];i=0
while i<len(pts)-1:
 j=len(pts)-1
 while j>i+1 and not clear(pts[i],pts[j]):j-=1
 simple.append(pts[j]);i=j
hits={}
for a,z in zip(simple,simple[1:]):
 seg=p.SEG(v(a),v(z))
 for t,s in obs:
  if s.Collide(seg,p.FromMM(.4001)):
   key=t.m_Uuid.AsString();hits.setdefault(key,{'uuid':key,'net':t.GetNetname(),'type':type(t).__name__,'start':xy(t.GetStart())if isinstance(t,p.PCB_TRACK)else xy(t.GetPosition()),'end':xy(t.GetEnd())if isinstance(t,p.PCB_TRACK)else None,'power_segments':[]})['power_segments'].append([a,z])
out={'source_sha256':H,'status':'HYPOTHETICAL_ONLY_FOREIGN_CONTROL_TRACKS_IGNORED','track_width_mm':.4,'hypothetical_points_mm':simple,'hard_obstacle_violations':bad,'signal_barriers':list(hits.values()),'release':False};(D/'power-corridor-scout.json').write_text(json.dumps(out,indent=2)+'\n');print('simplified',simple);print('barriers',json.dumps(list(hits.values()),indent=2))
