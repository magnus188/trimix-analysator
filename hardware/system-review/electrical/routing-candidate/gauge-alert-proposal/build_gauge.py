"""Isolated, bounded controller-route proposal; no authoritative board writes."""
from pathlib import Path
import hashlib, json, math, shutil
import pcbnew as p
OUT=Path(__file__).resolve().parent
BASE=OUT/'before.kicad_pcb'; DEST=OUT/'Trimix_Analyzer.kicad_pcb'
EXPECTED='ae51286a3d1f7a6ffcfca5bc9bde7de25bca9cfac3d611ff8d309067b79131a8'
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

# Preserve U301 pin4's direct ground return, taking a shorter route into
# its exposed ground pad and retaining both existing local ground vias.
remove(['8eca5819-5132-4e3a-b97f-cdb1fc156bbc','b9bf8d55-b6bb-410b-806d-643696e48b5b','e5c69ceb-b19c-49cb-a7c8-4aa7becdc1a5'])
track('GND',[(17.0125,70.55),(17.4,70.55),(17.7,70.35),(18.0,69.8)],width=.2)
# Gauge escape; validate it together with all following copper changes.
track('GAUGE_ALERT_N',[(18.9875,70.55),(18.9875,70.975),(17.19,70.975),(17.19,72.035)])
via('GAUGE_ALERT_N',(17.19,72.035))
# Preserve 1.00 mm VSYS copper width, shifting only its local corner
# 0.15 mm right and retaining the original capacitor/end-point connection.
remove(['338627bd-bc11-402c-862d-2758e97949ed','ccd31b8b-9435-488a-82a3-3f399c7840ba'])
track('VSYS',[(17.8084,74.9334),(17.9584,74.7834),(17.9584,72.6666),(18.225,72.25)],width=1.0)
# This 0.40 mm raw-input segment will be replaced by an equal-width
# back-layer detour; its two original endpoints remain fixed.
remove(['886db2fc-5a55-4bdc-bdc0-7375329c5ef4'])
# Move the existing PACK_P through via 0.10 mm left / 0.15 mm down, retaining its
# diameter/drill and 0.40 mm F/B connections to the original endpoints.
remove(['28837037-076d-4d1f-ad2e-ffa0acb7de11','f4b1396d-1074-44ff-853e-eb49fe2a0d01'])
via('PACK_P',(16.0271,72.9014),d=.6,h=.3)
track('PACK_P',[(16.1271,72.7514),(16.0271,72.9014)],width=.4)
track('PACK_P',[(16.0271,72.9014),(16.1271,73.0014),(16.1271,74.422)],p.B_Cu,width=.4)
# Maintain the original PACK_P-to-VSYS gap after the via adjustment:
# the 1.00 mm VSYS horizontal section moves only 0.15 mm downward.
remove(['c2b9f14d-a979-4061-9c24-5df3391a4ff0','52abf20f-f28e-4b35-81d4-3bc07dd2aa61'])
track('VSYS',[(13.5,73.775),(13.65,73.925),(16.65,73.925),(17.8084,74.9334)],width=1.0)
# Fixed gauge-alert via has >0.20 mm actual separation from all SMT copper,
# including its own resistor pad (avoids a same-net solder-wicking gap).
via('GAUGE_ALERT_N',(11.95,71.65))
track('GAUGE_ALERT_N',[(11.95,71.65),(12.775,71.15)])

def save():
 b.GetDesignSettings().m_TrackMinWidth=p.FromMM(.15)
 p.ZONE_FILLER(b).Fill(b.Zones());p.SaveBoard(str(DEST),b)
 shutil.copy2(OUT/'frozen-project.json',OUT/'Trimix_Analyzer.kicad_pro')
 (OUT/'delta.json').write_text(json.dumps({'before_sha256':EXPECTED,'after_sha256':hashlib.sha256(DEST.read_bytes()).hexdigest(),'added_items':added,'removed_uuids':removed,'changed_poses':poses,'zones_added':0,'existing_zones_refilled':True,'requires_native_DRC':True,'release':False},indent=2)+'\n')
 print('saved',len(added),'added,',len(removed),'removed,',len(poses),'poses',flush=True)

if __name__=='__main__':save()
