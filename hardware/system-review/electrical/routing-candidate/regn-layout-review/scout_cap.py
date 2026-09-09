"""Read-only native footprint scout, not a placement or routing approval."""
from pathlib import Path
import json, hashlib, math, collections, sys
import pcbnew as p
D=Path(__file__).resolve().parent
src=D/'before.kicad_pcb'
SHA='609a6241ce50cbe3d40f7a1676c455092db583875895eeb8236083bf2c5f0ef1'
assert hashlib.sha256(src.read_bytes()).hexdigest()==SHA
b=p.LoadBoard(str(src));f=next(q for q in b.GetFootprints() if q.GetReference()=='C107')
package=sys.argv[1] if len(sys.argv)>1 else '1206'
if package in ['0805','0603']:
 old=f;nets={q.GetNumber():q.GetNetCode() for q in old.Pads()}
 f=p.FootprintLoad('/Applications/KiCad/KiCad.app/Contents/SharedSupport/footprints/Capacitor_SMD.pretty','C_'+{'0805':'0805_2012','0603':'0603_1608'}[package]+'Metric')
 f.SetReference('C107');b.Add(f)
 for q in f.Pads():q.SetNetCode(nets[q.GetNumber()])
 b.Remove(old)
def xy(v): return [p.ToMM(v.x),p.ToMM(v.y)]
def vec(x,y):return p.VECTOR2I(p.FromMM(x),p.FromMM(y))
side=sys.argv[2] if len(sys.argv)>2 else 'B'
layer=p.F_Cu if side=='F' else p.B_Cu
if side=='B':f.Flip(f.GetPosition(),False)
assert f.GetLayer()==layer
courts=[]
for q in b.GetFootprints():
 if q.GetReference()=='C107':continue
 q.BuildCourtyardCaches();s=q.GetCourtyard(layer)
 if s.OutlineCount():courts.append((q.GetReference(),s))
objs=[q for q in b.GetTracks() if q.IsOnLayer(layer)]+[q for fp in b.GetFootprints() if fp.GetReference()!='C107' for q in fp.Pads() if q.IsOnLayer(layer)]
shapes=[(q.GetNetname(),q.GetEffectiveShape(layer),q) for q in objs]
vias=[q for q in b.GetTracks() if isinstance(q,p.PCB_VIA)]
drilled_pads=[q for fp in b.GetFootprints() for q in fp.Pads() if q.GetDrillSize().x>0]
edges=[q.GetEffectiveShape() for q in b.GetDrawings() if q.GetLayer()==p.Edge_Cuts]
rules=[z.Outline() for z in list(b.Zones())+[z for fp in b.GetFootprints() for z in fp.Zones()] if z.GetIsRuleArea() and z.GetLayerSet().Contains(layer) and z.GetDoNotAllowFootprints()]
out=[];reject=collections.Counter()
cutscout=len(sys.argv)>3 and sys.argv[3]=='cuts'
for ix in range(90,201):
 for iy in range(760,851):
  x,y=ix/10,iy/10
  for a in [0,90,180,270]:
   f.SetPosition(vec(x,y));f.SetOrientationDegrees(a);f.BuildCourtyardCaches();court=f.GetCourtyard(layer)
   hit=next((r for r,q in courts if court.Collide(q,0)),None)
   if hit:reject['courtyard:'+hit]+=1;continue
   if any(court.Collide(q,0) for q in rules):reject['rule']+=1;continue
   pads=[];good=True;cuts={}
   for pad in f.Pads():
    s=pad.GetEffectiveShape(layer);net=pad.GetNetname()
    collisions=[(n,q) for n,g,q in shapes if n!=net and s.Collide(g,p.FromMM(.2001))]
    if collisions:
     if not cutscout or any(not isinstance(q,p.PCB_TRACK) or isinstance(q,p.PCB_VIA) for n,q in collisions):good=False;reject['copper']+=1;break
     for n,q in collisions:cuts[q.m_Uuid.AsString()]={'net':n,'start':xy(q.GetStart()),'end':xy(q.GetEnd()),'width_mm':p.ToMM(q.GetWidth())}
     if len(cuts)>2:good=False;reject['more_than_two_track_barriers']+=1;break
    if any(s.Collide(e,p.FromMM(.5001)) for e in edges):good=False;reject['edge']+=1;break
    if any(s.Collide(v.GetPosition(),int(v.GetWidth(layer)/2)+p.FromMM(.05)) for v in vias):good=False;reject['via_in_pad_margin']+=1;break
    if any(s.Collide(q.GetEffectiveShape(layer),p.FromMM(.05)) for q in drilled_pads):good=False;reject['plated_pad_overlap_margin']+=1;break
    pads.append({'pin':pad.GetNumber(),'net':net,'at_mm':xy(pad.GetPosition())})
   if good:
    hot=next(q for q in pads if q['pin']=='1');gnd=next(q for q in pads if q['pin']=='2')
    score=math.dist(hot['at_mm'],[12.79,81.15])+min(math.dist(gnd['at_mm'],xy(v.GetPosition())) for v in vias if v.GetNetname()=='GND')
    out.append({'xy_mm':[x,y],'rotation_deg':a,'pads':pads,'endpoint_distance_score_mm':score,'hypothetical_track_barriers':cuts})
out.sort(key=lambda q:(len(q['hypothetical_track_barriers']),q['endpoint_distance_score_mm']))
assert hashlib.sha256(src.read_bytes()).hexdigest()==SHA
(D/('pose-scout-wide-'+package+'-'+side+('-cuts' if cutscout else '')+'.json')).write_text(json.dumps({'status':'hypothetical_native_placement_only','source_sha256':SHA,'package':package,'side':side,'grid_mm':.1,'bounds_mm':[9,76,20,85],'candidates':out,'rejects':dict(reject),'limits':['No saved PCB change','No routed connectivity or full DRC','No carrier cut or enclosure-fit approval','1206 is existing package; 0805/0603 are genuine library land patterns requiring exact part/capacitance qualification, not scaled models','When cuts are present the pose actually collides; no route was removed or connection verified']},indent=2)+'\n')
print(json.dumps({'count':len(out),'first':out[:8],'rejects':dict(reject)},indent=2))
