from pathlib import Path
import sys,sexpdata,json,math
sys.path.insert(0,str(Path('hardware/system-review/electrical/main-final-independent').resolve()))
from cam_geometry import *
from shapely.ops import polygonize
D=Path(__file__).resolve().parent
raw=sexpdata.loads((D/'before.kicad_pcb').read_text());n=Native(raw)
def courtyard(fp):
 aa=sub(fp,'at');a=aa[2]if len(aa)>2 else 0;chunks=[];lines=[]
 for q in fp:
  if sub(q,'layer',[])!=['F.CrtYd']:continue
  t=tag(q)
  if t=='fp_line':lines.append(LineString([(sub(q,k)[0],-sub(q,k)[1])for k in ['start','end']]))
  elif t=='fp_rect':
   x,y=sub(q,'start');xx,yy=sub(q,'end');chunks.append(box(min(x,xx),min(-y,-yy),max(x,xx),max(-y,-yy)))
  elif t=='fp_circle':
   c=sub(q,'center');e=sub(q,'end');chunks.append(Point(c[0],-c[1]).buffer(math.dist(c,e)))
 chunks+=list(polygonize(lines));g=unary_union(chunks)
 return affinity.translate(affinity.rotate(g,a,origin=(0,0)),aa[0],-aa[1])
fps=subs(raw,'footprint');fps={next(x[2]for x in subs(f,'property')if x[1]=='Reference'):f for f in fps}
cy={ref:courtyard(fp)for ref,fp in fps.items()};others=[g for ref,g in cy.items()if ref!='Q110' and not g.is_empty];ct=STRtree(others)
oldpads=[q for q in n.pads if q['ref']=='Q110'];center=(18,-89.5)
# Only a proposal: relocating Q110 necessarily invalidates its direct Q gate
# and ILIM_BRANCH tracks, which are explicitly excluded from this scout.
def ignored(t):return t['net'].endswith('USB_ILIM_BRANCH')or(t['net'].endswith('USB_PERMISSION_Q')and t['layer']=='F.Cu'and any(math.dist(q,(17.0625,-88.55))<.01 for q in[t['a'],t['b']]))
obs={L:[q for q in n.pads_on(L)if q['ref']!='Q110']+[q for q in n.tracks if q['layer']==L and not ignored(q)]+n.vias for L in CU}
trees={L:STRtree([q['geo']for q in v])for L,v in obs.items()}
def collision(g,L,net,clear=.2):return any(obs[L][int(i)]['net']!=net and g.distance(obs[L][int(i)]['geo'])<clear-.00001 for i in trees[L].query(g.buffer(clear)))
def trans(g,ang,dx,dy):return affinity.translate(affinity.rotate(g,ang,origin=center),dx,-dy)
candidates=[];count=0
for ang in [0,90,180,270]:
 for dx in [i*.1 for i in range(-30,21)]:
  for dy in [i*.1 for i in range(-25,21)]:
   g=trans(cy['Q110'],ang,dx,dy)
   if len(ct.query(g.buffer(-.00001),predicate='intersects')):continue
   pp=[dict(q,geo=trans(q['geo'],ang,dx,dy))for q in oldpads]
   if any(collision(p['geo'],'F.Cu',p['net'])for p in pp):continue
   count+=1;series=next(p for p in pp if p['pin']=='2');at=series['geo'].centroid;found=[]
   near=sorted([(round(at.x/.1)*.1+i*.1,round(at.y/.1)*.1+j*.1)for i in range(-18,19)for j in range(-18,19)],key=lambda q:math.dist((at.x,at.y),q))
   for xy in near:
    vg=Point(xy).buffer(.25,quad_segs=16)
    if any(collision(vg,L,series['net'])for L in CU):continue
    if any(vg.distance(p['geo'])<.2 for p in pp):continue
    tr=LineString([(at.x,at.y),xy]).buffer(.075)
    if collision(tr,'F.Cu',series['net']):continue
    if any(p['net']!=series['net']and tr.distance(p['geo'])<.2 for p in pp):continue
    found.append([round(xy[0],4),round(-xy[1],4)]);break
   if found:candidates.append(dict(rotation=ang,at=[round(18+dx,4),round(89.5+dy,4)],displacement=math.hypot(dx,dy),via=found[0],series_pad=[at.x,-at.y]))
candidates.sort(key=lambda c:c['displacement'])
(D/'q110-scout.json').write_text(json.dumps(dict(geometry_clear_candidates=count,with_straight_ordinary_via=candidates,scope='Read-only geometric scout; removed connected Q110 stubs assumed, no native edits or DRC proof, no physical acceptance'),indent=2)+'\n')
print('clearposes',count,'viaposes',len(candidates));print(json.dumps(candidates[:12],indent=2))
