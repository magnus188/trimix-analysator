"""Isolated, bounded controller-route proposal; no authoritative board writes."""
from pathlib import Path
import hashlib, json, math, shutil
import pcbnew as p
OUT=Path(__file__).resolve().parent
BASE=OUT/'before.kicad_pcb'; DEST=OUT/'Trimix_Analyzer.kicad_pcb'
EXPECTED='43046290dd43fb281ee8711e50924bf6cb4f689afc3f26330c916a1776d2a0c3'
assert hashlib.sha256(BASE.read_bytes()).hexdigest()==EXPECTED
shutil.copy2(BASE,DEST);shutil.copy2(OUT/'frozen-project.json',OUT/'Trimix_Analyzer.kicad_pro')
import sys
sys.path.insert(0,str(Path.cwd()/'hardware/tools'))
from analyzer_sheet import sx,child,children,fmt
removed=['128db68f-3eb7-4dae-bb97-e5de5247c313', '887e0d82-affe-420e-922c-46d43e9b23b7', 'b7bf0299-1b6d-4268-8ff3-32de030c9570', '0c64601f-ff7e-469b-8c83-08a2628848cd', '340b9126-da56-4512-a64c-3e34a344c2c4', '11d88aa9-1e38-4159-8495-b32ddaf6b452', 'ca4f9a0d-eef2-46fd-959a-4d208e45162e', '80031589-b79b-4a68-9621-b90112743846', '50a6dcfb-4832-4bbb-900a-a2092fc2a1f0', '5f1b85f6-441a-4eba-b2bc-9c755030773e', '0e151c90-263c-400f-b818-333c8b55ebae', 'd4ed301b-4835-456c-abd5-f492e2d67644', '34032a4e-3c08-42cd-8ac5-92a37839c75c', '215542a0-07e3-4db7-9d83-f2587e6bd5a0', 'c9e5f9ac-bdcf-4634-838e-318a128dd03c', 'b971c0ed-42c3-4f92-87b3-c999d19c1aa4', 'c31cf5bd-ecb6-4791-9944-a4e95496f81b', 'ce5e761f-6d72-4607-b789-5fbfa6f20440', '142dbe3c-9771-4e40-858a-ae81a26ca9a4']
a=sx.loads(BASE.read_text());found=[]
for q in list(children(a,'segment'))+list(children(a,'via')):
 if child(q,'uuid')[1] in removed:found.append(child(q,'uuid')[1]);assert child(q,'net')[1]in ['CHG_INT_N','I2C_SCL','HOST_3V3'];a.remove(q)
assert set(found)==set(removed)
DEST.write_text(fmt(a)+'\n')
b=p.LoadBoard(str(DEST)); added=[];poses=[]
NETS={str(k):v.GetNetCode() for k,v in b.GetNetsByName().items()}
removed_objects=[]
def vec(q):return p.VECTOR2I(p.FromMM(q[0]),p.FromMM(q[1]))
def xy(v):return[p.ToMM(v.x),p.ToMM(v.y)]
for ref,old,new in [('R107',(3.4,83.5),(23.5,75)),('R302',(23.5,75),(3.4,83.5))]:
 f=next(f for f in b.GetFootprints()if f.GetReference()==ref);assert xy(f.GetPosition())==list(old)
 assert abs(f.GetOrientationDegrees())<.0001
 f.SetPosition(vec(new));angle=180 if ref=='R107'else 0;f.SetOrientationDegrees(angle);poses.append({'reference':ref,'before':old,'before_rotation_deg':0,'after':new,'rotation_deg':angle})
 if ref=='R302':
  f.Reference().SetPosition(vec((2.75,84.3)));f.Reference().SetTextAngle(p.EDA_ANGLE(0,p.DEGREES_T))
# The old SCL via shared R302's SCL net and sat too close to this land after
# the swap makes that land HOST_3V3. Move the real via and its two incident
# tracks; retain ordinary diameter/drill and the same existing UUIDs.
for t in b.GetTracks():
 u=t.m_Uuid.AsString()
 if u=='532da661-1898-4d38-b7fc-5d71fe61ab57':
  assert isinstance(t,p.PCB_VIA)and xy(t.GetPosition())==[25.1,75.15]
  t.SetPosition(vec((25.30,75.125)))
 elif u=='52eaf73f-dc5e-4c41-a23f-97167a4a8415':
  assert xy(t.GetEnd())==[25.1,75.15];t.SetEnd(vec((25.30,75.125)))
 elif u=='c6c21e64-2312-4037-90f2-ff52dff39d1b':
  assert xy(t.GetStart())==[25.1,75.15];t.SetStart(vec((25.30,75.125)))
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


def save():
 b.GetDesignSettings().m_TrackMinWidth=p.FromMM(.15)
 p.ZONE_FILLER(b).Fill(b.Zones());p.SaveBoard(str(DEST),b)
 shutil.copy2(OUT/'frozen-project.json',OUT/'Trimix_Analyzer.kicad_pro')
 (OUT/'delta.json').write_text(json.dumps({'before_sha256':EXPECTED,'after_sha256':hashlib.sha256(DEST.read_bytes()).hexdigest(),'added_items':added,'removed_uuids':removed,'changed_poses':poses,'zones_added':0,'existing_zones_refilled':True,'requires_native_DRC':True,'release':False},indent=2)+'\n')
 print('saved',len(added),'added,',len(removed),'removed,',len(poses),'poses',flush=True)

if __name__=='__main__':save()
