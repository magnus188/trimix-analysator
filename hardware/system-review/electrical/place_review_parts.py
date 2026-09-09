"""Conservative courtyard-box placement of approved source/power changes only."""
from pathlib import Path
import pcbnew as p,json,math
ROOT=Path(__file__).resolve().parents[3];OUT=Path(__file__).resolve().parent
path=ROOT/'hardware/pcb/analyzer/Trimix_Analyzer.kicad_pcb';b=p.LoadBoard(str(path));fps={f.GetReference():f for f in b.GetFootprints()}
def xy(f):return [p.ToMM(f.GetPosition().x),p.ToMM(f.GetPosition().y),f.GetOrientationDegrees()]
def box(f):
 f.BuildCourtyardCaches();pol=f.GetCourtyard(p.F_Cu)
 pts=[pol.COutline(j).CPoint(i) for j in range(pol.OutlineCount()) for i in range(pol.COutline(j).PointCount())]
 if not pts:
  r=f.GetBoundingBox(False,False);return [p.ToMM(r.GetX()),p.ToMM(r.GetY()),p.ToMM(r.GetRight()),p.ToMM(r.GetBottom())]
 return [min(p.ToMM(q.x)for q in pts),min(p.ToMM(q.y)for q in pts),max(p.ToMM(q.x)for q in pts),max(p.ToMM(q.y)for q in pts)]
def overlap(a,c,g=.025):return a[0]<c[2]+g and c[0]<a[2]+g and a[1]<c[3]+g and c[1]<a[3]+g
def inside(q):return q[0]>=.25 and q[2]<=29.75 and q[1]>=25 and q[3]<=98.75 and not(q[0]<6.1 and q[3]>94.5)
targets={
'L101':(13.5,76.5,90),'L201':(13,66,180),'L701':(19.5,51.2,90),
'C102':(8.1,81,90),'C104':(19.6,75.5,0),'C105':(19,80.5,0),'C106':(7.7,84.75,0),'C107':(8,74.5,90),
'C201':(18.2,61,0),'C202':(18.2,64,0),'C204':(7.4,60.1,0),'C205':(7.4,63.5,0),'C206':(7.4,66.9,0),'C701':(15.1,50.5,90),'U701':(19.5,56.3,0),'U703':(13,46.1,0),
'J101':(14.75,97,0),'U302':(12,51.5,0),'C302':(11.5,48.1,0),'C303':(12,49.65,0),
'U110':(25.2,77.4,0),'U111':(25.2,73.8,0),'U112':(25.2,81,0),'U113':(25,85.8,0),'U114':(7.5,90.5,0),'SW101':(3,87.75,0),
'C110':(23.25,77.4,90),'C111':(27.75,73.7,0),'C112':(28,86,90),'C113':(28,81.2,90),
'Q110':(18,89.5,0),'Q111':(20,86,0),'R110':(23,76,90),'R111':(23,79,0),'R112':(23,72,0),
'R113':(27.5,88.25,0),'R114':(24,88.25,0),'R115':(28,84.5,90),'R116':(19,89.5,0),'R117':(21,89.5,0),'R118':(28,88.5,90),
'R104':(6,90,90),'R105':(11,89.75,0),'C801':(9,55,0),'C802':(11,57,0),'C803':(8,58,0),'R703':(21,59.5,90),'TP1005':(15,70.5,0),'C804':(13,58,0),'R202':(8.8,56.8,0),'R201':(8.8,58.5,0),'C203':(11.8,57.95,0),'C702':(21.7,55.2,90),'C703':(21.7,58.8,90),'TP1012':(20,40,0),'R303':(21,70.5,90),'TP1004':(21.5,95,0),'Q101':(20,84.75,0),'R103':(13.25,88.15,90),'R107':(20,84,0),
'C114':(7.5,94,0),'R803':(19.5,70.5,90),'R119':(10.5,92.5,90),'R120':(10,89,0),
}
if 'U115' in fps:
 targets={r:t for r,t in targets.items()if xy(fps[r])[1]>=70}
 targets.update({'U115':(14.5,93.75,0),'Q112':(24.5,90,0),'C114':(8.75,94,0),'C115':(18,94.5,90),'C116':(16.75,93,90),'R121':(10.5,88.5,0),'R122':(12.5,88.5,0),'R123':(15,88,0),'R124':(21.5,90.75,0),'R125':(21.5,92.5,0),'R126':(17,91,90),'R127':(21.5,94.25,0),'R128':(28,92.5,90)})
targets=dict(sorted(targets.items(),key=lambda kv:0 if kv[0] in ['L101','L201','L701','U701','U703','U302','U110','U111','U112','U113','U114','Q101','Q110','Q111','SW101','U115','Q112','J101'] else 1 if kv[0] in ['R201','R202','C203','C701','C302','C303','R103','R119','R113','R114','C110','C111','C112','C113','C114','C702','C703','TP1012','TP1004','TP1005'] else 2 if kv[0].startswith('C') and kv[0] not in ['C110','C111','C112','C113','C114'] else 3))
before={r:xy(f) for r,f in fps.items()};occ={r:box(f)for r,f in fps.items() if r not in targets};receipts=[]
for z in b.Zones():
 if z.GetIsRuleArea() and z.GetDoNotAllowFootprints():
  pol=z.Outline();pts=[pol.COutline(j).CPoint(i)for j in range(pol.OutlineCount())for i in range(pol.COutline(j).PointCount())]
  occ['keepout:'+z.GetZoneName()]=[min(p.ToMM(q.x)for q in pts),min(p.ToMM(q.y)for q in pts),max(p.ToMM(q.x)for q in pts),max(p.ToMM(q.y)for q in pts)]
# Largest and semantically central parts first; resistors fill remaining voids.
for ref,(tx,ty,angle) in targets.items():
 f=fps[ref];candidates=[]
 orientations=[angle,(angle+90)%360] if ref.startswith(('R','C','Q')) else [angle]
 for candidate_angle in orientations:
  f.SetOrientationDegrees(candidate_angle);f.SetPosition(p.VECTOR2I(p.FromMM(tx),p.FromMM(ty)));bb=box(f);rel=[bb[0]-tx,bb[1]-ty,bb[2]-tx,bb[3]-ty]
  for ix in (range(-128,129) if ref.startswith('R') else range(-64,65)):
   for iy in (range(-256,257) if ref.startswith('R') else range(-64,65)):
    x,y=round(tx+ix*.25,4),round(ty+iy*.25,4);q=[rel[0]+x,rel[1]+y,rel[2]+x,rel[3]+y]
    if not inside(q) or any(overlap(q,c)for c in occ.values()):continue
    candidates.append((ix*ix+iy*iy+(0 if candidate_angle==angle else 4),x,y,candidate_angle,q))
 if not candidates:raise RuntimeError('No valid local placement for '+ref)
 _,x,y,chosen_angle,q=min(candidates);f.SetOrientationDegrees(chosen_angle);f.SetPosition(p.VECTOR2I(p.FromMM(x),p.FromMM(y)));occ[ref]=q
 receipts.append({'reference':ref,'before':before[ref],'after':xy(f),'courtyard_bbox':q,'target':[tx,ty,angle]})
assert xy(fps['J401'])==before['J401'] and xy(fps['J402'])==before['J402']
p.SaveBoard(str(path),b)
(OUT/'placement-change.json').write_text(json.dumps({'method':'0.25mm local search, conservative courtyard bounding boxes; intended current-loop topology guides targets','changed':receipts,'oxygen_connector_poses_preserved':True,'native_DRC_pending':True,'mechanical_cable_qualification_pending':True},indent=2)+'\n')
print(json.dumps({r['reference']:r['after']for r in receipts},indent=2))
