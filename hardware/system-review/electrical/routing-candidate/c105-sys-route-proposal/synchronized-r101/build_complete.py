"""Build isolated CE+SET+CHG+SYS candidate with exact frozen inputs."""
from pathlib import Path
import json,hashlib,shutil,uuid,math,pcbnew as p
D=Path(__file__).resolve().parent;O=D/'complete-candidate';O.mkdir(exist_ok=True)
SOURCE=D/'Trimix_Analyzer.kicad_pcb';SHA='3d72a8d43823f29553d900e0c0820aed391bd7e5e336b70a5869bc3f220a1962'
def sha(q):return hashlib.sha256(q.read_bytes()).hexdigest()
assert sha(SOURCE)==SHA
m=json.loads((D/'source-manifest.json').read_text());projectpaths=[]
for rel,h in m['inputs_sha256'].items():
 q=D/rel
 if q.suffix=='.kicad_pcb':continue
 assert sha(q)==h,(rel,sha(q),h)
 t=O/rel;t.parent.mkdir(exist_ok=True,parents=True);shutil.copy2(q,t);projectpaths.append((t,q,h))
b=p.LoadBoard(str(SOURCE));netmap={str(k):v.GetNetCode()for k,v in b.GetNetsByName().items()}
def v(q):return p.VECTOR2I(p.FromMM(q[0]),p.FromMM(q[1]))
def xy(q):return[p.ToMM(q.x),p.ToMM(q.y)]
def sig(t):
 r={'type':type(t).__name__,'net':t.GetNetname(),'start':xy(t.GetStart()),'end':xy(t.GetEnd())}
 if isinstance(t,p.PCB_VIA):r.update(diameter_mm=p.ToMM(t.GetWidth(p.F_Cu)),drill_mm=p.ToMM(t.GetDrillValue()))
 else:r.update(layer=b.GetLayerName(t.GetLayer()),width_mm=p.ToMM(t.GetWidth()))
 return r
old={t.m_Uuid.AsString():sig(t)for t in b.GetTracks()};lookup={t.m_Uuid.AsString():t for t in b.GetTracks()};chg=json.loads((D/'chg-scout/with-set/delta.json').read_text())
for uid in chg['required_preapplied_SET_delta']['removed_uuids']:assert uid not in lookup
for row in chg['required_preapplied_SET_delta']['added']:
 t=lookup[row['uuid']];assert t.GetNetname()==row['net']and xy(t.GetStart())==row['start']and xy(t.GetEnd())==row['end']
for u in chg['removed_CHG_uuids']:assert lookup[u].GetNetname()=='CHG_INT_N';b.Remove(lookup[u])
added=[]
def add(row):
 if row['type']=='via':
  t=p.PCB_VIA(b);t.SetPosition(v(row['at']));t.SetWidth(p.FromMM(row['diameter_mm']));t.SetDrill(p.FromMM(row['drill_mm']));t.SetViaType(p.VIATYPE_THROUGH);t.SetLayerPair(p.F_Cu,p.B_Cu)
 else:t=p.PCB_TRACK(b);t.SetStart(v(row['start']));t.SetEnd(v(row['end']));t.SetLayer(b.GetLayerID(row['layer']));t.SetWidth(p.FromMM(row['width_mm']))
 t.SetNetCode(netmap[row['net']]);t.SetUuid(p.KIID(row['uuid']));b.Add(t);added.append(t)
for r in chg['added']:add(r)
pts=chg['reserved_SYS_points_mm']
for i,(a,z)in enumerate(zip(pts,pts[1:])):add({'type':'segment','net':'VSYS','start':a,'end':z,'layer':'In2.Cu','width_mm':.4,'uuid':str(uuid.uuid5(uuid.NAMESPACE_URL,'trimix-f1c5-SYS-v2-'+str(i)))})
reserved=p.SHAPE_POLY_SET();reserved.NewOutline()
for x,y in[(15.7,89.3),(18.5,89.3),(18.5,91),(15.7,91)]:reserved.Append(p.FromMM(x),p.FromMM(y))
issues=[]
for t in added:
 for L in[p.F_Cu,p.In1_Cu,p.In2_Cu,p.B_Cu]:
  if not t.IsOnLayer(L):continue
  s=t.GetEffectiveShape(L)
  if reserved.Collide(s,p.FromMM(.2)):issues.append([t.m_Uuid.AsString(),'C116_CC_reserved',L])
  for q in list(b.GetTracks())+[a for f in b.GetFootprints()for a in f.Pads()]:
   if not q.IsOnLayer(L)or q.GetNetname()==t.GetNetname():continue
   if q.GetEffectiveShape(L).Collide(s,p.FromMM(.2)):issues.append([t.m_Uuid.AsString(),q.m_Uuid.AsString(),q.GetNetname(),L])
assert not issues,issues
p.ZONE_FILLER(b).Fill(b.Zones());p.SaveBoard(str(O/'Trimix_Analyzer.kicad_pcb'),b)
for t,q,h in projectpaths:shutil.copy2(q,t);assert sha(t)==h
assert sha(SOURCE)==SHA
out={'status':'ISOLATED_COMPLETE_SYS_BUILT_DRC_PENDING','frozen_source_sha256':'f1c5f443cbd6cdf92e39e01fc7db374c30721b6e7945b3cdde3387e8cdff7432','intermediate_CE_SET_sha256':SHA,'candidate_sha256':sha(O/'Trimix_Analyzer.kicad_pcb'),'removed_from_intermediate':chg['removed_CHG_uuids'],'added_to_intermediate':{t.m_Uuid.AsString():sig(t)for t in added},'all_added_foreign_copper_guard_pass':True,'C116_CC_reserved_box_clear':True,'SYS_width_mm':.4,'new_SYS_vias':0,'new_CHG_vias':3,'release':False}
(D/'complete-stage.json').write_text(json.dumps(out,indent=2)+'\n');print('saved',out['candidate_sha256'],len(added),'added',flush=True)
