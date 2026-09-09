"""Compact source-protection placement inside the CAD-qualified carrier window."""
from pathlib import Path
import pcbnew as p,json,math
ROOT=Path(__file__).resolve().parents[3];OUT=Path(__file__).resolve().parent;PATH=ROOT/'hardware/pcb/analyzer/Trimix_Analyzer.kicad_pcb';b=p.LoadBoard(str(PATH));fps={f.GetReference():f for f in b.GetFootprints()}
def vec(x,y):return p.VECTOR2I(p.FromMM(x),p.FromMM(y))
def bb(f):
 f.BuildCourtyardCaches();q=f.GetCourtyard(f.GetLayer()).BBox();return[p.ToMM(q.GetX()),p.ToMM(q.GetY()),p.ToMM(q.GetRight()),p.ToMM(q.GetBottom())]
def overlap(a,c):return a[0]<c[2] and c[0]<a[2] and a[1]<c[3] and c[1]<a[3]
back={'U115':(14.5,90,0),'C114':(10.5,90,0),'C115':(17,90,90),'C116':(14.5,93,0),'R121':(10.5,85.25,0),'R122':(10.5,86.9,0),'R123':(13.5,85.25,0),'R124':(13.5,86.9,0),'R125':(16.5,87.2,0),'R126':(17.5,92.75,0),'R127':(10.5,93,0),'R128':(18,85.5,90)}
back=dict(sorted(back.items(),key=lambda t:0 if t[0]in['U115','Q112']else 1 if t[0]=='C114'else 2))
# Source-control F.Cu passives recover their short-loop allocation after moving OVP.
front={'Q112':(24.5,96.75,0),'R803':(2,81.5,90),'R107':(8.25,77.75,0),'R115':(11,93.25,0),'R116':(14.5,90.75,0),'R117':(28.2,97.5,0),'R118':(7.75,94.75,0),'R120':(2,92.75,0)}
# Exact courtyard checks use B.Cu geometry after the flip, not mirrored F.Cu assumptions.
for r,(x,y,a)in back.items():
 f=fps[r]
 if f.GetLayer()!=p.B_Cu:f.Flip(f.GetPosition(),False)
 f.SetOrientationDegrees(a);f.SetPosition(vec(x,y))
for r,(x,y,a)in front.items():f=fps[r];f.SetPosition(vec(x,y));f.SetOrientationDegrees(a)
for side,targets,rect in [(p.B_Cu,back,[7.5,84,20,94.5]),(p.F_Cu,front,[.25,25,29.75,98.75])]:
 occ={r:bb(f)for r,f in fps.items()if f.GetLayer()==side and r not in targets}
 for i,z in enumerate(b.Zones()):
  if z.GetIsRuleArea()and z.GetDoNotAllowFootprints()and z.GetLayerSet().Contains(side):
   q=z.Outline().BBox();occ['keepout'+str(i)]=[p.ToMM(q.GetX()),p.ToMM(q.GetY()),p.ToMM(q.GetRight()),p.ToMM(q.GetBottom())]
 if side==p.B_Cu:
  for r,f in fps.items():
   drills=[z for z in f.Pads()if z.GetDrillSize().x]
   if r in ['J101','J102']:occ[r+'-tail-clearance']=bb(f)
   else:
    for i,z in enumerate(drills):
     q=z.GetBoundingBox();occ[r+'-drill-'+str(i)]=[p.ToMM(q.GetX())-.2,p.ToMM(q.GetY())-.2,p.ToMM(q.GetRight())+.2,p.ToMM(q.GetBottom())+.2]
 for r,(tx,ty,a)in targets.items():
  f=fps[r];choices=[]
  for angle in [a,(a+90)%360]if r.startswith(('R','C'))else[a]:
   f.SetOrientationDegrees(angle);f.SetPosition(vec(tx,ty));q=bb(f);rel=[q[0]-tx,q[1]-ty,q[2]-tx,q[3]-ty]
   for ix in (range(-50,51)if side==p.B_Cu else range(-16,17)):
    for iy in (range(-50,51)if side==p.B_Cu else range(-16,17)):
     x,y=tx+ix*.25,ty+iy*.25;z=[rel[0]+x,rel[1]+y,rel[2]+x,rel[3]+y]
     if z[0]<rect[0]or z[1]<rect[1]or z[2]>rect[2]or z[3]>rect[3]or any(overlap(z,c)for c in occ.values()):continue
     choices.append((ix*ix+iy*iy+(0 if a==angle else 4),x,y,angle,z))
  if not choices:
   f.SetPosition(vec(tx,ty));f.SetOrientationDegrees(a);print(r,bb(f),{k:q for k,q in occ.items()if overlap(bb(f),q)});raise RuntimeError('No qualified local position '+r)
  _,x,y,angle,z=min(choices);f.SetPosition(vec(x,y));f.SetOrientationDegrees(angle);occ[r]=z
poses={r:{'xy_mm':[p.ToMM(fps[r].GetPosition().x),p.ToMM(fps[r].GetPosition().y)],'rotation_deg':fps[r].GetOrientationDegrees(),'side':'B.Cu','courtyard':bb(fps[r])}for r in back}
assert all(7.5<=q['courtyard'][0] and q['courtyard'][2]<=20 and 84<=q['courtyard'][1] and q['courtyard'][3]<=94.5for q in poses.values())
p.SaveBoard(str(PATH),b);(OUT/'backside-ovp-placement.json').write_text(json.dumps({'qualified_region_pcb_mm':[7.5,84,20,94.5],'max_extension_below_board_mm':1.95,'carrier_pocket_world_min_Z':18.55,'parts':poses,'root_CAD_pocket_qualification':'localized carrier top opening extension authorized; exact final BRep check pending','native_DRC_required':True},indent=2)+'\n');print(json.dumps(poses,indent=2))
