"""Draft continuous In1 ground and local ground vias. Native DRC required."""
from pathlib import Path
import pcbnew as p,math,json
ROOT=Path(__file__).resolve().parents[3];OUT=Path(__file__).resolve().parent;PATH=ROOT/'hardware/pcb/analyzer/Trimix_Analyzer.kicad_pcb';b=p.LoadBoard(str(PATH));fps=list(b.GetFootprints());pads=[q for f in fps for q in f.Pads()];tracks=list(b.GetTracks())
def mm(q):return p.ToMM(q.x),p.ToMM(q.y)
def v(q):return p.VECTOR2I(p.FromMM(q[0]),p.FromMM(q[1]))
def box(o):q=o.GetBoundingBox();return [p.ToMM(q.GetX()),p.ToMM(q.GetY()),p.ToMM(q.GetRight()),p.ToMM(q.GetBottom())]
def hit(pt,r,d):return r[0]-d<=pt[0]<=r[2]+d and r[1]-d<=pt[1]<=r[3]+d
def inside(x,y,r):return r<=x<=30-r and r<=y<=99-r and not(y<17+r and x>8.9-r) and not(y>94.8-r and x<5.8+r)
keep=[]
for z in list(b.Zones())+[z for f in fps for z in f.Zones()]:
 if z.GetIsRuleArea()and z.GetDoNotAllowVias():
  q=z.Outline().BBox();keep.append([p.ToMM(q.GetX()),p.ToMM(q.GetY()),p.ToMM(q.GetRight()),p.ToMM(q.GetBottom())])
GND=b.FindNet('GND');added=[];skipped=[];vpos=[]
ALL_PAD_BOX=[box(z)for z in pads];OTHER_PAD_BOX=[box(z)for z in pads if z.GetNetname()!='GND'and z.IsOnLayer(p.F_Cu)];OTHER_TRACK_BOX=[box(t)for t in tracks if t.GetNetname()!='GND'];OTHER_FTRACK_BOX=[box(t)for t in tracks if t.GetNetname()!='GND'and t.IsOnLayer(p.F_Cu)]
for f in fps:
 if f.GetLayer()!=p.F_Cu:continue
 for q in f.Pads():
  if q.GetNetname()!='GND' or q.GetDrillSize().x or q.GetNumber() in ['25','15'] or not q.IsOnLayer(p.F_Cu):continue
  start=mm(q.GetPosition());choices=[]
  for ix in range(-12,13):
   for iy in range(-12,13):
    pt=round(start[0]+ix*.25,5),round(start[1]+iy*.25,5);dist=math.dist(start,pt)
    if not(.8<=dist<=3)or not inside(*pt,.85):continue
    if any(math.dist(pt,r)<.75for r in vpos):continue
    if any(hit(pt,r,.31)for r in keep):continue
    # No new drilled hole overlaps any component copper land, even its own ground.
    if any(hit(pt,r,.52)for r in ALL_PAD_BOX):continue
    if any(hit(pt,r,.52)for r in OTHER_TRACK_BOX):continue
    bad=False
    for i in range(1,31):
     at=start[0]+(pt[0]-start[0])*i/30,start[1]+(pt[1]-start[1])*i/30
     if any(hit(at,r,.35)for r in OTHER_PAD_BOX):bad=True;break
     if any(hit(at,r,.35)for r in OTHER_FTRACK_BOX):bad=True;break
    if not bad:choices.append((dist,pt))
  if not choices:skipped.append(f.GetReference()+'.'+q.GetNumber());continue
  _,pt=min(choices);via=p.PCB_VIA(b);via.SetPosition(v(pt));via.SetWidth(p.FromMM(.6));via.SetDrill(p.FromMM(.3));via.SetViaType(p.VIATYPE_THROUGH);via.SetLayerPair(p.F_Cu,p.B_Cu);via.SetNetCode(GND.GetNetCode());b.Add(via);tracks.append(via);vpos.append(pt)
  t=p.PCB_TRACK(b);t.SetStart(v(start));t.SetEnd(v(pt));t.SetWidth(p.FromMM(.25));t.SetLayer(p.F_Cu);t.SetNetCode(GND.GetNetCode());b.Add(t);tracks.append(t)
  added.append({'pad':f.GetReference()+'.'+q.GetNumber(),'via_position_mm':pt,'via_uuid':via.m_Uuid.AsString(),'trace_uuid':t.m_Uuid.AsString(),'length_mm':math.dist(start,pt)})
# A single uninterrupted inner GND zone; no signal routing on this layer.
z=p.ZONE(b);z.SetLayer(p.In1_Cu);z.SetNetCode(GND.GetNetCode());z.SetZoneName('REVIEW_CONTINUOUS_GND');z.SetLocalClearance(p.FromMM(.2));z.SetMinThickness(p.FromMM(.2));z.SetPadConnection(p.ZONE_CONNECTION_FULL);poly=z.Outline();poly.NewOutline()
for xy in [(0,0),(8.9,0),(8.9,17),(30,17),(30,99),(5.8,99),(5.8,94.8),(0,94.8)]:poly.Append(v(xy))
b.Add(z);p.ZONE_FILLER(b).Fill(b.Zones());p.SaveBoard(str(PATH),b)
(OUT/'ground-routing-draft.json').write_text(json.dumps({'local_returns':added,'manual_ground_returns_remaining':skipped,'continuous_plane':'In1.Cu','zone_uuid':z.m_Uuid.AsString(),'physical_tests':False,'native_DRC_required':True},indent=2)+'\n');print(len(added),'local returns',len(skipped),'need manual routing')
