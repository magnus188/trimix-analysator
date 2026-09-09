from pathlib import Path
import sys,copy,json,uuid,collections
import pcbnew as p
D=Path(__file__).resolve().parent
sys.path[:0]=[str(D.parents[3]/'tools'),str(D.parents[1])]
from analyzer_sheet import sx,child,tag
from apply_review_fixes import top_blocks
raw=(D/'baseline/Trimix_Analyzer.kicad_pcb').read_text();ed=[]
REF=sys.argv[1];net='CO_FB' if REF=='R702' else 'BQ_BTST';libpath=Path('/Applications/KiCad/KiCad.app/Contents/SharedSupport/footprints')/('Resistor_SMD.pretty/R_0402_1005Metric.kicad_mod' if REF=='R702' else 'Capacitor_SMD.pretty/C_0402_1005Metric.kicad_mod')
new=sx.loads(libpath.read_text());removed=[]
for a,z,block in top_blocks(raw):
 if block.startswith(('(segment','(via')):
  q=sx.loads(block)
  if child(q,'net')[1]==net:ed.append((a,z,''));removed.append(child(q,'uuid')[1])
 elif block.startswith('(footprint'):
  fp=sx.loads(block);props={q[1]:q[2]for q in fp if tag(q)=='property'}
  if props.get('Reference')!=REF:continue
  oldpads={q[1]:q for q in fp if tag(q)=='pad'};keep={'fp_line','fp_rect','fp_text','fp_arc','fp_circle','fp_poly','pad','model','descr','tags'}
  fp[1]=('Resistor_SMD:R_0402_1005Metric' if REF=='R702' else 'Capacitor_SMD:C_0402_1005Metric');child(fp,'layer')[1]='F.Cu';child(fp,'at')[3:]=[0]
  fp[:]=[q for q in fp if tag(q)not in keep]
  for q in new:
   if tag(q)not in keep:continue
   q=copy.deepcopy(q)
   if tag(q)=='pad':
    for k in ['net','uuid','pinfunction','pintype']:
     v=child(oldpads[q[1]],k)
     if v:q.append(copy.deepcopy(v))
   elif tag(q).startswith('fp_'):q.append([sx.Symbol('uuid'),str(uuid.uuid4())])
   fp.append(q)
  ed.append((a,z,sx.dumps(fp)))
for a,z,x in reversed(ed):raw=raw[:a]+x+raw[z:]
file=D/(REF+'-0402-scout.kicad_pcb');file.write_text(raw);b=p.LoadBoard(str(file));f=next(f for f in b.GetFootprints()if f.GetReference()==REF)
def vec(q):return p.VECTOR2I(p.FromMM(q[0]),p.FromMM(q[1]))
def xy(q):return[p.ToMM(q.x),p.ToMM(q.y)]
courts=[]
for q in b.GetFootprints():
 if q.GetReference()==REF:continue
 q.BuildCourtyardCaches();shape=q.GetCourtyard(p.F_Cu)
 if shape.OutlineCount():courts.append((q.GetReference(),shape))
objects=[t for t in b.GetTracks()if t.IsOnLayer(p.F_Cu)]+[q for fp in b.GetFootprints()if fp.GetReference()!=REF for q in fp.Pads()if q.IsOnLayer(p.F_Cu)]
shapes=[(q.GetNetname(),q.GetEffectiveShape(p.F_Cu),getattr(q,'GetUuid',lambda:None)())for q in objects]
rules=[z.Outline()for z in list(b.Zones())+[z for fp in b.GetFootprints()for z in fp.Zones()]if z.GetIsRuleArea()and z.GetLayerSet().Contains(p.F_Cu)and z.GetDoNotAllowFootprints()]
rows=[];rejects=collections.Counter();court_ok=[]
xb,yb,xe,ye=(17.25,53.25,20,55.1) if REF=='R702'else(12.5,80,15.4,81.4)
for xi in range(round(xb*20),round(xe*20)+1):
 for yi in range(round(yb*20),round(ye*20)+1):
  x,y=xi/20,yi/20
  for angle in [0,90,180,270]:
   f.SetPosition(vec((x,y)));f.SetOrientationDegrees(angle);f.BuildCourtyardCaches();court=f.GetCourtyard(p.F_Cu)
   hit=next((r for r,q in courts if court.Collide(q,0)),None)
   if hit:rejects['courtyard:'+hit]+=1;continue
   if any(court.Collide(q,0)for q in rules):rejects['rule']+=1;continue
   points=[];good=True;blockers=[]
   for pad in f.Pads():
    shape=pad.GetEffectiveShape(p.F_Cu);net=pad.GetNetname();pt=xy(pad.GetPosition())
    hits=[n for n,q,u in shapes if n!=net and shape.Collide(q,p.FromMM(.2001))]
    if hits:good=False;blockers+=hits
    points.append({'pin':pad.GetNumber(),'net':net,'at':pt})
   court_ok.append(dict(x=x,y=y,angle=angle,blockers=sorted(set(blockers))))
   if not good:rejects['pad']+=1
   if good:rows.append(dict(x=x,y=y,angle=angle,pads=points))
(D/(REF+'-pose-scout.json')).write_text(json.dumps({'candidates':rows,'court_ok':court_ok,'removed':removed,'rejects':dict(rejects),'unaccepted':True},indent=2)+'\n');print(json.dumps(rows[:35],indent=2));print(rejects)
