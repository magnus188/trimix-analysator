"""Isolated, bounded controller-route proposal; no authoritative board writes."""
from pathlib import Path
import hashlib, json, math, shutil
import pcbnew as p
OUT=Path(__file__).resolve().parent
BASE=OUT/'before.kicad_pcb'; DEST=OUT/'Trimix_Analyzer.kicad_pcb'
EXPECTED='b4e4d0b9f8e41cf1de1cf5215d66de0d0c490becd4c52028119dcc60c4080688'
assert hashlib.sha256(BASE.read_bytes()).hexdigest()==EXPECTED
shutil.copy2(BASE,DEST);shutil.copy2(OUT/'frozen-project.json',OUT/'Trimix_Analyzer.kicad_pro')
b=p.LoadBoard(str(DEST)); added=[];removed=[];poses=[]
NETS={str(k):v.GetNetCode() for k,v in b.GetNetsByName().items()}
removed_objects=[]
def vec(q):return p.VECTOR2I(p.FromMM(q[0]),p.FromMM(q[1]))
def xy(v):return[p.ToMM(v.x),p.ToMM(v.y)]
def track(net,pts,layer=p.F_Cu,width=.15):
 for a,z in zip(pts,pts[1:]):
  if math.dist(a,z)<.000001:continue
  t=p.PCB_TRACK(b);t.SetStart(vec(a));t.SetEnd(vec(z));t.SetWidth(p.FromMM(width));t.SetNetCode(NETS[net]);t.SetLayer(layer);b.Add(t)
  added.append({'uuid':t.m_Uuid.AsString(),'type':'segment','net':net,'start':a,'end':z,'width_mm':width,'layer':b.GetLayerName(layer)})
def via(net,pt,d=.5,h=.25):
 t=p.PCB_VIA(b);t.SetPosition(vec(pt));t.SetWidth(p.FromMM(d));t.SetDrill(p.FromMM(h));t.SetViaType(p.VIATYPE_THROUGH);t.SetLayerPair(p.F_Cu,p.B_Cu);t.SetNetCode(NETS[net]);b.Add(t)
 added.append({'uuid':t.m_Uuid.AsString(),'type':'via','net':net,'at':pt,'diameter_mm':d,'drill_mm':h,'layers':['F.Cu','B.Cu']})
def remove(ids):
 found=set()
 for t in list(b.GetTracks()):
  uid=t.m_Uuid.AsString()
  if uid in ids:removed.append(uid);found.add(uid);removed_objects.append(t);b.Remove(t)
 assert found==set(ids),(found,ids)


fps={f.GetReference():f for f in b.GetFootprints()}
f=fps['R111'];ref_position=f.Reference().GetPosition();ref_angle=f.Reference().GetTextAngle();f.SetPosition(vec((27.5,77.55)));f.SetOrientationDegrees(270);f.Reference().SetPosition(ref_position);f.Reference().SetTextAngle(ref_angle);poses.append({'reference':'R111','before':[27.5,77.75,90],'after':[27.5,77.55,270]})
remove(['0f388e5f-702f-4ffc-bc58-662d7832a33b','4c652a95-4f9f-4829-b8fa-b544aff9cb1a','c575ae01-24ab-46ed-b5f5-03604e58ec11','9699602b-3176-4069-a1ef-a30de57ce1e1'])


def save():
 b.GetDesignSettings().m_TrackMinWidth=p.FromMM(.15)
 p.ZONE_FILLER(b).Fill(b.Zones());p.SaveBoard(str(DEST),b)
 shutil.copy2(OUT/'frozen-project.json',OUT/'Trimix_Analyzer.kicad_pro')
 (OUT/'delta.json').write_text(json.dumps({'before_sha256':EXPECTED,'after_sha256':hashlib.sha256(DEST.read_bytes()).hexdigest(),'added_items':added,'removed_uuids':removed,'changed_poses':poses,'zones_added':0,'existing_zones_refilled':True,'requires_native_DRC':True,'release':False},indent=2)+'\n')
 print('saved',len(added),'added,',len(removed),'removed,',len(poses),'poses',flush=True)

if __name__=='__main__':save()
