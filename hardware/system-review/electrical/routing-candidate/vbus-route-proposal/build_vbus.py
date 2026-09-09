"""Isolated, bounded controller-route proposal; no authoritative board writes."""
from pathlib import Path
import hashlib, json, math, shutil
import pcbnew as p
OUT=Path(__file__).resolve().parent
BASE=OUT/'before.kicad_pcb'; DEST=OUT/'Trimix_Analyzer.kicad_pcb'
EXPECTED='dedd6db2668e97a1e59e31f35d4b147597c115376029c4f2fe232ec5ede81204'
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

# Move one local ground fanout left to open a sense corridor below U110.
# Preserve both ground pads and use an ordinary 0.50/0.25 mm through via.
remove(['c8809e76-cb10-4fb8-adf9-a50634a6ce08','ce4de007-90c6-40b5-8eab-590faade3e2c'])
track('GND',[(24.6,78.225),(24.6,78.7),(24.2,79.1)])
via('GND',(24.2,79.1))
# The existing HOST back-layer branch detours around that ground via and
# the new sense via; its endpoints and all IC positions remain unchanged.
remove(['4ea9d12b-8057-4a3c-94ca-0c412b9c16a9','94ad5c6d-364e-4e66-9677-212859b58b4f','434c3a86-08e7-40d4-92fe-34f80b6e04e7','4f44f010-8fbb-4bc5-898d-7f1e4c5c44be','5ce6199a-0089-4369-8fd5-5ae72685ce7d'])
track('HOST_3V3',[(23.6287,78.6498),(23.45,78.8285),(23.45,80.3),(25.469,80.3),(25.469,80.3011)],p.B_Cu)
track('USB_VBUS_DET',[(25.0,78.225),(25.0,78.85),(24.9,78.95),(24.9,79.675)])
via('USB_VBUS_DET',(24.9,79.675))

# Replace the upper HOST front-layer branch with a routed bridge. Its
# source endpoint at (21,69.95) must be reconnected before validation.
remove(['79e1733a-774c-41fd-81c7-070afc28d0ab','e29439a7-4cd8-417a-af84-dad9fbb89507','142f3ec8-fc17-416e-ad6a-3210bb426063','2cdab825-3028-4875-a927-133a6095ae53','34694f1c-9ec4-4292-a3be-97b8006affff','5c080f69-848a-4117-a9be-3fb9a9baa85a'])

# Pull the owned SDA bus inward by 0.1711 mm through its upper bend so
# the unchanged D+/D- vias retain clearance to a separate sense route.
remove(['c9e89e0d-50bd-45a7-bdda-769518be72db','f0c362d9-01ce-41c9-9c7e-98d51feecede'])
track('I2C_SDA',[(25.9551,72.9351),(26.96,73.94),(26.96,75.8),(27.1311,75.9711),(27.1311,77.2689)],p.B_Cu)

track('HOST_3V3',[(24.5,78.2157),(24.25,78.4657),(23.8128,78.4657),(23.6287,78.6498)],p.B_Cu)
# Retain the original source branch endpoint; reconnect it above R110.


def save():
 b.GetDesignSettings().m_TrackMinWidth=p.FromMM(.15)
 p.ZONE_FILLER(b).Fill(b.Zones());p.SaveBoard(str(DEST),b)
 shutil.copy2(OUT/'frozen-project.json',OUT/'Trimix_Analyzer.kicad_pro')
 (OUT/'delta.json').write_text(json.dumps({'before_sha256':EXPECTED,'after_sha256':hashlib.sha256(DEST.read_bytes()).hexdigest(),'added_items':added,'removed_uuids':removed,'changed_poses':poses,'zones_added':0,'existing_zones_refilled':True,'requires_native_DRC':True,'release':False},indent=2)+'\n')
 print('saved',len(added),'added,',len(removed),'removed,',len(poses),'poses',flush=True)

if __name__=='__main__':save()
