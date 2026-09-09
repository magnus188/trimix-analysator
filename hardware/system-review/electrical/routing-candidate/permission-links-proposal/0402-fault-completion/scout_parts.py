from pathlib import Path
import sys,sexpdata,json,math
sys.path.insert(0,str(Path('hardware/system-review/electrical/main-final-independent').resolve()))
from cam_geometry import *
from shapely.ops import polygonize
D=Path(__file__).resolve().parent
raw=sexpdata.loads((D/'scout-base.kicad_pcb').read_text());n=Native(raw)
edges=[LineString([(sub(q,k)[0],-sub(q,k)[1]) for k in ['start','end']])for q in raw if tag(q)=='gr_line' and sub(q,'layer')==['Edge.Cuts']]
assert not [q for q in raw if tag(q)=='gr_arc' and sub(q,'layer')==['Edge.Cuts']]
board=unary_union(list(polygonize(edges)))
assert board.area>100
def courtyard(fp,side):
 aa=sub(fp,'at');a=aa[2]if len(aa)>2 else 0;chunks=[];lines=[]
 for q in fp:
  if sub(q,'layer',[])!=[side+'.CrtYd']:continue
  t=tag(q)
  if t=='fp_line':lines.append(LineString([(sub(q,k)[0],-sub(q,k)[1])for k in ['start','end']]))
  elif t=='fp_rect':
   x,y=sub(q,'start');xx,yy=sub(q,'end');chunks.append(box(min(x,xx),min(-y,-yy),max(x,xx),max(-y,-yy)))
 chunks+=list(polygonize(lines));return affinity.translate(affinity.rotate(unary_union(chunks),a,origin=(0,0)),aa[0],-aa[1])
fps={next(x[2]for x in subs(f,'property')if x[1]=='Reference'):f for f in subs(raw,'footprint')}
fp=next(q for q in n.fps if q['ref']=='R116');pp=[q for q in n.pads if q['ref']=='R116'];oldcy=courtyard(fps['R116'],'F');results=[]
for side in ['F']:
 L=side+'.Cu';obs=[q for q in n.pads_on(L)if q['ref']not in ['R116','R119','R118']]+[q for q in n.tracks if q['layer']==L]+n.vias
 # Include reserved outside-SMD root UVLO and raw-source via corridors.
 for x,y,r in [(13.6,91,.25),(16.7,87.95,.25),(13,91.65,.30)]:obs.append(dict(net='RESERVED',geo=Point(x,-y).buffer(r)))
 if side=='F':
  for a,b in [((13.6,-91),(15.2,-89.7)),((15.2,-89.7),(16.7,-87.95))]:obs.append(dict(net='RESERVED',geo=LineString([a,b]).buffer(.075)))
 othercy=[courtyard(f,side)for ref,f in fps.items()if ref not in ['R116','R119','R118']];othercy=[q for q in othercy if not q.is_empty]
 for z in subs(raw,'zone'):
  k=next((q for q in z if tag(q)=='keepout'),None)
  if not k or str(sub(k,'footprints',[''])[0])!='not_allowed' or sub(z,'layer')!=[L]:continue
  for poly in subs(z,'polygon'):othercy.append(Polygon([(q[1],-q[2])for q in next(q for q in poly if tag(q)=='pts')[1:]]))
 # Hole-to-pad clearance is checked below; a tented via under body is not a footprint courtyard.
 ct=STRtree(othercy);tr=STRtree([q['geo']for q in obs]);holes=STRtree([h['geo']for h in n.holes])
 for ang in [0,90,180,270]:
  for xi in range(10,441):
   for yi in range(1660,1930):
    at=(xi/20,yi/20)
    def trans(g):return affinity.translate(affinity.rotate(g,ang,origin=(fp['x'],fp['y'])),at[0]-fp['x'],-at[1]-fp['y'])
    g=trans(oldcy)
    if not board.covers(g):continue
    if len(ct.query(g.buffer(-.00001),predicate='intersects')):continue
    pads=[dict(q,geo=trans(q['geo']))for q in pp]
    if any(not board.buffer(-.5001).covers(q['geo'])for q in pads):continue
    if any(any(obs[int(i)]['net']!=p['net']and p['geo'].distance(obs[int(i)]['geo'])<.20001 for i in tr.query(p['geo'].buffer(.20001)))for p in pads):continue
    if any(any(p['geo'].distance(n.holes[int(i)]['geo'])<.25001 for i in holes.query(p['geo'].buffer(.25001)))for p in pads):continue
    results.append(dict(side=side,at=at,angle=ang,score=math.dist(at,(6.15,89.55))))
results.sort(key=lambda q:q['score']);(D/'r116-edge-scout.json').write_text(json.dumps(results,indent=2));print('total',len(results));print(json.dumps(results[:30],indent=2))
