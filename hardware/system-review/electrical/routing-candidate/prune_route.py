from pathlib import Path
import json,sys,sexpdata as sx,uuid
sys.path.insert(0,'hardware/system-review/electrical/main-final-independent')
from cam_geometry import *
D=Path('hardware/system-review/electrical/routing-candidate');src=Path(sys.argv[1]);base=sx.loads(Path(sys.argv[2]).read_text());net=sys.argv[3];width=float(sys.argv[4]);out=Path(sys.argv[5]);r=sx.loads(src.read_text());n=Native(r)
def uid(x):return sub(x,'uuid',[None])[0]
baseids={uid(x) for x in base if isinstance(x,list)}
new=[x for x in r if tag(x)=='segment' and uid(x)not in baseids];r=[x for x in r if x not in new]
info=json.loads(src.with_suffix('.json').read_text());runs=[]
for s in info['segments']:
 if not runs or runs[-1][0]!=s['layer']:runs.append((s['layer'],[s['start'],s['end']]))
 else:runs[-1][1].append(s['end'])
segs=[];mind=[]
for layer,pts in runs:
 foreign=unary_union([v['geo'] for v in [*n.pads_on(layer),*n.vias,*[t for t in n.tracks if t['layer']==layer]] if v['net']!=net])
 i=0
 while i<len(pts)-1:
  chosen=i+1
  for j in range(len(pts)-1,i,-1):
   line=LineString([(pts[i][0],-pts[i][1]),(pts[j][0],-pts[j][1])]);d=line.distance(foreign)-width/2
   if d>=.2005:chosen=j;break
  node=[sx.Symbol('segment'),[sx.Symbol('start'),*pts[i]],[sx.Symbol('end'),*pts[chosen]],[sx.Symbol('width'),width],[sx.Symbol('layer'),layer],[sx.Symbol('net'),next(sub(t,'net')[0] for t in new)],[sx.Symbol('uuid'),str(uuid.uuid4())]]
  r.append(node);segs.append({'layer':layer,'start':pts[i],'end':pts[chosen]});mind.append(LineString([(pts[i][0],-pts[i][1]),(pts[chosen][0],-pts[chosen][1])]).distance(foreign)-width/2);i=chosen
out.write_text(sx.dumps(r));print('pruned',len(new),'to',len(segs),'min clearance',min(mind));out.with_suffix('.prune.json').write_text(json.dumps({'segments':segs,'minimum_nominal_foreign_gap_mm':min(mind),'native_check_pending':True},indent=2))
