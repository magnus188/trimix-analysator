"""Isolated, bounded controller-route proposal; no authoritative board writes."""
from pathlib import Path
import hashlib, json, math, shutil
import pcbnew as p
OUT=Path(__file__).resolve().parent
BASE=OUT/'before.kicad_pcb'; DEST=OUT/'Trimix_Analyzer.kicad_pcb'
EXPECTED='02d5c11904035d4482d4fe30a29508557842293e3757523aeac20dc0c95e503a'
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

# Shift the same capacitor 0.125 mm right and 0.6 mm upward, retaining
# its vertical orientation and clearing the protected J301 mated envelope.
f=next(q for q in b.GetFootprints()if q.GetReference()=='C111')
old=xy(f.GetPosition())+[f.GetOrientationDegrees()]
f.SetPosition(vec((29.025,73.1)));f.SetOrientationDegrees(90)
poses.append({'reference':'C111','before':old,'after':[29.025,73.1,90],'reason':'Free supply escape while preserving USB data and J301 mated-cable clearance.'})
remove(['1ae3f4ce-1f3b-4298-b29f-233d1219c261','37bcdf2b-7b75-49b7-844d-507db445e088','dd65a005-f267-42fd-9538-c1b9462259c8','f8027662-c605-4e37-bfbb-3b648e7ad248','09e1ad6e-918e-413b-ae95-07c8737d8913','5316696b-43dc-41e3-ad38-faec083f3dd1'])
track('HOST_3V3',[(29.025,73.875),(29.025,73.075),(27.925,73.075),(27.825,72.975)])
via('HOST_3V3',(27.825,72.975))
track('HOST_3V3',[(27.825,72.975),(27.25,72.4),(27.25,70.8267)],p.In2_Cu)
track('GND',[(29.025,72.325),(28.575,72.325),(28.2,71.95)])
via('GND',(28.2,71.95))
track('HOST_3V3',[(29.0,77.575),(28.1,77.575),(27.5,78.175),(27.5,78.575)])
track('HOST_3V3',[(27.5,78.575),(27.5,79.1),(26.85,79.75),(26.6,79.75)])
track('HOST_3V3',[(26.6,79.75),(27.5,79.75),(27.5,81.7),(27.775,81.975),(28.25,81.975)])

# Use ordinary through vias outside all fine-pitch solder lands. SDA uses
# free central package space; SCL escapes beside its land row.
remove(['bbe0e4d3-1617-4b9e-89e8-547c7b414f14','71121f4c-3ffc-426d-9b38-96338998bb40'])
track('I2C_SCL',[(25.85,74.875),(25.85,75.2)],width=.125)
track('I2C_SCL',[(25.85,75.2),(25.3,75.2),(25.25,75.15),(25.1,75.15)])
via('I2C_SCL',(25.1,75.15))
track('I2C_SDA',[(26.25,74.875),(26.25,74.35)],width=.125)
track('I2C_SDA',[(26.25,74.35),(26.45,74.15),(26.45,74.05)])
via('I2C_SDA',(26.45,74.05))
track('I2C_SCL',[(25.1,75.15),(25.1,74.5326),(25.3563,74.2763)],p.B_Cu)
track('I2C_SDA',[(26.45,74.05),(26.45,73.43)],p.B_Cu)


def save():
 b.GetDesignSettings().m_TrackMinWidth=p.FromMM(.15)
 p.ZONE_FILLER(b).Fill(b.Zones());p.SaveBoard(str(DEST),b)
 shutil.copy2(OUT/'frozen-project.json',OUT/'Trimix_Analyzer.kicad_pro')
 (OUT/'delta.json').write_text(json.dumps({'before_sha256':EXPECTED,'after_sha256':hashlib.sha256(DEST.read_bytes()).hexdigest(),'added_items':added,'removed_uuids':removed,'changed_poses':poses,'zones_added':0,'existing_zones_refilled':True,'requires_native_DRC':True,'release':False},indent=2)+'\n')
 print('saved',len(added),'added,',len(removed),'removed,',len(poses),'poses',flush=True)

if __name__=='__main__':save()
