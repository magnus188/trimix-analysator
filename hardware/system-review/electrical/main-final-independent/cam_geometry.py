"""Independent exported-byte geometry helpers. No KiCad API or netlist connectivity."""
import math
from collections import defaultdict
from gerbonara.utils import MM, approximate_arc
from shapely.geometry import Point, LineString, Polygon, box, GeometryCollection
from shapely.ops import unary_union
from shapely import affinity, make_valid, STRtree

EPS=0.000002
SHAPE_EPS=0.000025
Q=128
CU=['F.Cu','In1.Cu','In2.Cu','B.Cu']
def tag(a): return str(a[0]) if isinstance(a,list) and a else None
def sub(a,key,default=None): return next((b[1:] for b in a if tag(b)==key),default)
def subs(a,key): return [b for b in a if tag(b)==key]
def polys(g):
 if g.is_empty:return []
 if g.geom_type=='Polygon':return [g]
 return [p for a in getattr(g,'geoms',[]) for p in polys(a)]
def cleanpoly(g):return unary_union(polys(make_valid(g)))
def attrs(o):return o.attrs if isinstance(getattr(o,'attrs',None),dict) else {}
def primitive(p):
 n=type(p).__name__
 if n=='Circle':return Point(p.x,p.y).buffer(p.r,quad_segs=Q)
 if n=='Rectangle':return affinity.translate(affinity.rotate(box(-p.w/2,-p.h/2,p.w/2,p.h/2),p.rotation,origin=(0,0),use_radians=True),p.x,p.y)
 if n=='Line':return LineString([(p.x1,p.y1),(p.x2,p.y2)]).buffer(p.width/2,quad_segs=Q)
 if n=='Arc':return LineString(list(approximate_arc(p.cx,p.cy,p.x1,p.y1,p.x2,p.y2,p.clockwise,max_error=.00001))).buffer(p.width/2,quad_segs=Q)
 if n=='ArcPoly':return cleanpoly(Polygon(p.approximate_arcs(max_error=.00001).outline))
 raise ValueError('Unsupported Gerber primitive '+n)
def geometry(o):
 g=GeometryCollection()
 for p in o.to_primitives(unit=MM):
  q=primitive(p);g=g.union(q) if p.polarity_dark else g.difference(q)
 return cleanpoly(g)
def ordinary_shape(shape,w,h,p):
 if shape=='circle':return Point(0,0).buffer(w/2,quad_segs=Q)
 if shape=='oval':
  return (LineString([(-(w-h)/2,0),((w-h)/2,0)]).buffer(h/2,quad_segs=Q) if w>h else
          LineString([(0,-(h-w)/2),(0,(h-w)/2)]).buffer(w/2,quad_segs=Q) if h>w else Point(0,0).buffer(w/2,quad_segs=Q))
 if shape=='rect':return box(-w/2,-h/2,w/2,h/2)
 if shape=='roundrect':
  r=float(sub(p,'roundrect_rratio')[0])*min(w,h)
  return box(-w/2+r,-h/2+r,w/2-r,h/2-r).buffer(r,quad_segs=Q)
 if shape=='custom':
  anchor=sub(next(x for x in p if tag(x)=='options'),'anchor',['rect'])[0]
  chunks=[ordinary_shape(str(anchor),w,h,p)]
  for pr in next(x for x in p if tag(x)=='primitives')[1:]:
   width=float(sub(pr,'width',[0])[0]);fill=str(sub(pr,'fill',['no'])[0])
   if tag(pr)=='gr_poly':
    points=[(v[1],v[2]) for v in next(x for x in pr if tag(x)=='pts')[1:]]
    pg=Polygon(points);chunks.append(pg if fill=='yes' else pg.boundary.buffer(width/2,quad_segs=Q))
    if fill=='yes' and width:chunks.append(pg.boundary.buffer(width/2,quad_segs=Q))
   elif tag(pr)=='gr_rect':
    a,b=sub(pr,'start'),sub(pr,'end');pg=box(min(a[0],b[0]),min(a[1],b[1]),max(a[0],b[0]),max(a[1],b[1]));chunks.append(pg if fill=='yes' else pg.boundary.buffer(width/2,quad_segs=Q))
   elif tag(pr)=='gr_line':chunks.append(LineString([sub(pr,'start'),sub(pr,'end')]).buffer(width/2,quad_segs=Q))
   else:raise ValueError('Unsupported custom primitive '+str(tag(pr)))
  # Native primitive coordinates are y-down, unlike the Gerber coordinate system.
  return affinity.scale(cleanpoly(unary_union(chunks)),xfact=1,yfact=-1,origin=(0,0))
 raise ValueError('Unsupported native pad shape '+shape)

class Native:
 def __init__(self,raw):
  self.raw=raw;self.setup=next(a for a in raw if tag(a)=='setup')
  self.origin=sub(self.setup,'aux_axis_origin',[0,0]);self.fps=[];self.pads=[];self.holes=[];self.tracks=[];self.vias=[];self.zones=[];self.graphics=[]
  self.layers=[x[1] for x in next(a for a in raw if tag(a)=='layers')[1:] if str(x[1]).endswith('.Cu')]
  for fp in subs(raw,'footprint'):
   props={a[1]:a[2] for a in subs(fp,'property')};at=sub(fp,'at');ang=float(at[2] if len(at)>2 else 0)
   cx,cy=self.xy(at);ar=math.radians(ang);side='top' if sub(fp,'layer')==['F.Cu'] else 'bottom'
   row=dict(ref=props['Reference'],value=props['Value'],package=fp[1].split(':')[-1],x=cx,y=cy,rotation=ang,side=side,props=props,attributes=[str(v) for v in sub(fp,'attr',[])])
   self.fps.append(row)
   for idx,p in enumerate(subs(fp,'pad')):
    pa=sub(p,'at',[0,0]);x=cx+pa[0]*math.cos(ar)+pa[1]*math.sin(ar);y=cy+pa[0]*math.sin(ar)-pa[1]*math.cos(ar)
    w,h=map(float,sub(p,'size'));angle=float(pa[2] if len(pa)>2 else ang);shape=str(p[3])
    local=ordinary_shape(shape,w,h,p);geo=affinity.translate(affinity.rotate(local,angle,origin=(0,0)),x,y)
    layers=[str(x) for x in sub(p,'layers')];net=sub(p,'net',[''])[0]
    pd=dict(ref=props['Reference'],pin=str(p[1]),id=f"{props['Reference']}.{p[1]}@{idx}",net=str(net),x=x,y=y,angle=angle,w=w,h=h,layers=layers,shape=shape,geo=geo,raw=p,fp=fp,local=local)
    self.pads.append(pd)
    drill=sub(p,'drill')
    if drill:
     if str(drill[0])=='oval':
      dw,dh=map(float,drill[1:3]);dg=ordinary_shape('oval',dw,dh,p)
     else:dw=dh=float(drill[0]);dg=ordinary_shape('circle',dw,dh,p)
     off=next((v[1:] for v in drill if tag(v)=='offset'),[0,0]);dg=affinity.translate(dg,off[0],-off[1]);dg=affinity.translate(affinity.rotate(dg,angle,origin=(0,0)),x,y)
     self.holes.append(dict(id=pd['id'],geo=dg,plated=str(p[2])=='thru_hole',layers=CU,diameter=min(dw,dh)))
   for pr in fp:
    if tag(pr) not in ['fp_rect','fp_poly']:continue
    layer=sub(pr,'layer',[''])[0]
    if layer not in ['F.Paste','B.Paste','F.Mask','B.Mask',*CU]:continue
    fill=str(sub(pr,'fill',['no'])[0]);stroke=next((s for s in pr if tag(s)=='stroke'),[]);width=sub(stroke,'width',[0])[0]
    if tag(pr)=='fp_rect':
     a,b=sub(pr,'start'),sub(pr,'end');g=box(min(a[0],b[0]),min(-a[1],-b[1]),max(a[0],b[0]),max(-a[1],-b[1]))
    else:g=Polygon([(v[1],-v[2]) for v in next(x for x in pr if tag(x)=='pts')[1:]])
    g=g.buffer(width/2,quad_segs=Q) if fill=='yes' else g.boundary.buffer(width/2,quad_segs=Q)
    g=affinity.translate(affinity.rotate(g,ang,origin=(0,0)),cx,cy)
    self.graphics.append(dict(ref=props['Reference'],layer=layer,geo=g))
  for t in subs(raw,'segment'):
   a,b=self.xy(sub(t,'start')),self.xy(sub(t,'end'));w=float(sub(t,'width')[0]);self.tracks.append(dict(layer=sub(t,'layer')[0],net=str(sub(t,'net')[0]),a=a,b=b,width=w,geo=LineString([a,b]).buffer(w/2,quad_segs=Q)))
  if subs(raw,'arc'):raise ValueError('Native track arcs require explicit handling; do not silently omit')
  for i,v in enumerate(subs(raw,'via')):
   a=self.xy(sub(v,'at'));d=float(sub(v,'drill')[0]);size=float(sub(v,'size')[0]);span=sub(v,'layers')
   if span!=['F.Cu','B.Cu']:raise ValueError('Non-through via needs layer-specific drill parsing')
   self.vias.append(dict(id='via'+str(i),xy=a,drill=d,size=size,layers=CU,net=str(sub(v,'net')[0]),geo=Point(a).buffer(size/2,quad_segs=Q)))
   self.holes.append(dict(id='via'+str(i),geo=Point(a).buffer(d/2,quad_segs=Q),plated=True,layers=CU,diameter=d))
  for zone in subs(raw,'zone'):
   for poly in subs(zone,'filled_polygon'):
    pts=[self.xy(v[1:]) for v in next(a for a in poly if tag(a)=='pts')[1:]]
    self.zones.append(dict(net=str(sub(zone,'net',[''])[0]),layer=sub(poly,'layer')[0],geo=cleanpoly(Polygon(pts))))
 def xy(self,v):return float(v[0])-self.origin[0],self.origin[1]-float(v[1])
 def pads_on(self,layer):
  return [p for p in self.pads if layer in p['layers'] or (layer in CU and '*.Cu' in p['layers']) or (layer.endswith('.Mask') and '*.Mask' in p['layers'])]
 def aperture(self,p,layer):
  if layer.endswith('.Mask'):
   margin=float(sub(p['raw'],'solder_mask_margin',sub(p['fp'],'solder_mask_margin',sub(self.setup,'pad_to_mask_clearance',[0])))[0])
   # KiCad's custom-pad mask macro uses 45-degree straight chords for this
   # 0.07mm expansion. Match that explicit polygon, not a silently widened
   # general tolerance; the ideal-circle deviation is recorded by the audit.
   return p['geo'].buffer(margin,quad_segs=2 if p['shape']=='custom' else Q) if margin else p['geo']
  if layer.endswith('.Paste'):
   margin=float(sub(p['raw'],'solder_paste_margin',sub(p['fp'],'solder_paste_margin',[0]))[0]);ratio=float(sub(p['raw'],'solder_paste_margin_ratio',sub(p['fp'],'solder_paste_ratio',[0]))[0])
   if margin or ratio:raise ValueError('Nonzero paste resize needs shape-specific verified implementation')
  return p['geo']

def physical_nodes(G,holes):
 """Remove drilled-away interiors, split regions, retain X2 only where supplied."""
 hs=[h['geo'] for h in holes];ht=STRtree(hs) if hs else None;nodes=[]
 for layer,objects in G.items():
  for oi,o in enumerate(objects):
   if not o.polarity_dark:raise ValueError('Negative layer polarity needs composite attribution; not silently supported')
   geo=geometry(o)
   if ht is not None:
    hits=ht.query(geo,predicate='intersects')
    if len(hits):geo=geo.difference(unary_union([hs[int(i)] for i in hits]))
   for pi,part in enumerate(polys(geo)):
    nodes.append(dict(layer=layer,object=oi,island=pi,geo=part,attrs=attrs(o),kind=type(o).__name__))
 return nodes

def components_for(parts,holes):
 """STRtree candidate searches. Never join by net/pin labels or IC assumptions."""
 parent=list(range(len(parts)));comparisons=0
 def find(i):
  while parent[i]!=i:parent[i]=parent[parent[i]];i=parent[i]
  return i
 def join(i,j):parent[find(i)]=find(j)
 bylayer=defaultdict(list)
 for i,n in enumerate(parts):bylayer[n['layer']].append(i)
 trees={l:STRtree([parts[i]['geo'] for i in ids]) for l,ids in bylayer.items()}
 for layer,ids in bylayer.items():
  tree=trees[layer]
  for li,i in enumerate(ids):
   for lj in tree.query(parts[i]['geo'].buffer(EPS),predicate='intersects'):
    j=ids[int(lj)]
    if j>=i:continue
    comparisons+=1
    if parts[i]['geo'].distance(parts[j]['geo'])<=EPS:join(i,j)
 # Only copper touching the wall of a plated hole joins through its barrel.
 for h in holes:
  if not h['plated']:continue
  wall=h['geo'].boundary.buffer(EPS);hits=[]
  for layer in h['layers']:
   if layer not in trees:continue
   ids=bylayer[layer]
   hits += [ids[int(j)] for j in trees[layer].query(wall,predicate='intersects')]
  for j in hits[1:]:join(hits[0],j)
 result=defaultdict(list)
 for i,n in enumerate(parts):result[find(i)].append(n)
 return result,comparisons

def summarize_components(groups):
 result=[]
 for ns in groups.values():
  nets=sorted({n['attrs']['.N'][0] for n in ns if n['attrs'].get('.N') and n['attrs']['.N'][0]})
  pins=sorted({'.'.join(n['attrs']['.P'][:2]) for n in ns if n['attrs'].get('.P')})
  result.append(dict(nets=nets,pins=pins,objects=len(ns),layers=sorted({n['layer'] for n in ns})))
 return result
