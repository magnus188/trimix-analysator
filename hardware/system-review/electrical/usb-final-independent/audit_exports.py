#!/usr/bin/env python3
"""Read-only independent USB CAM audit. Run with requirements.lock.txt environment.
Gerbonara parses exported Gerber/Excellon; sexpdata reads native coordinates only.
No KiCad library, renderer, connectivity API or audit generator is imported.
"""
from pathlib import Path
import csv, hashlib, json, math, warnings, sys, platform, xml.etree.ElementTree as ET
from collections import Counter, defaultdict
import sexpdata
from gerbonara import GerberFile, ExcellonFile
from gerbonara.utils import MM, approximate_arc
from shapely.geometry import Point, LineString, Polygon, box, GeometryCollection
from shapely.ops import unary_union, polygonize
from shapely import affinity, make_valid
import cairosvg

ROOT=Path(__file__).resolve().parents[4]
OUT=Path(__file__).resolve().parent
SRC=ROOT/'hardware/system-review/electrical/usb-final'
CAM=SRC/'manufacturing-diagnostic'
BOARD=ROOT/'hardware/pcb/usb-input/Trimix_USB_Input.kicad_pcb'
INPUTS=sorted([*CAM.iterdir(),BOARD,SRC/'usb-netlist.xml',SRC/'usb-drc.json',SRC/'audit.json'])
def receipt(p): return {'path':str(p.relative_to(ROOT)), 'bytes':p.stat().st_size,'sha256':hashlib.sha256(p.read_bytes()).hexdigest()}
BEFORE=[receipt(p) for p in INPUTS if p.is_file()]
checks=[]
def check(label, condition, detail=None):
 checks.append({'check':label,'pass':bool(condition),'detail':detail})
 if not condition: print('FAIL',label,str(detail)[:300])
def tag(a): return str(a[0]) if isinstance(a,list) and a else None
def sub(a,key,default=None): return next((b[1:] for b in a if tag(b)==key),default)
def subs(a,key): return [b for b in a if tag(b)==key]
def polys(g):
 if g.geom_type=='Polygon': return [g]
 return [p for a in getattr(g,'geoms',[]) for p in polys(a)]
def cleanpoly(g): return unary_union(polys(make_valid(g)))
def arcpts(p): return list(approximate_arc(p.cx,p.cy,p.x1,p.y1,p.x2,p.y2,p.clockwise,max_error=0.00001))
def primitive(p):
 n=type(p).__name__
 if n=='Circle': return Point(p.x,p.y).buffer(p.r,quad_segs=96)
 if n=='Rectangle': return affinity.translate(affinity.rotate(box(-p.w/2,-p.h/2,p.w/2,p.h/2),p.rotation,origin=(0,0),use_radians=True),p.x,p.y)
 if n=='Line': return LineString([(p.x1,p.y1),(p.x2,p.y2)]).buffer(p.width/2,quad_segs=96)
 if n=='Arc': return LineString(arcpts(p)).buffer(p.width/2,quad_segs=96)
 if n=='ArcPoly': return cleanpoly(Polygon(p.approximate_arcs(max_error=0.00001).outline))
 raise ValueError(n)
def geometry(o):
 g=GeometryCollection()
 for p in o.to_primitives(unit=MM):
  q=primitive(p)
  g=g.union(q) if p.polarity_dark else g.difference(q)
 return g
G={}; W=[]
with warnings.catch_warnings(record=True) as ww:
 warnings.simplefilter('always')
 for p in sorted(CAM.iterdir()):
  if p.suffix in {'.gtl','.gbl','.gts','.gbs','.gtp','.gbp','.gto','.gbo','.gm1','.drl'}:
   G[p.suffix]= (ExcellonFile if p.suffix=='.drl' else GerberFile).open(p) if p.suffix!='.drl' else None
 # Drill files distinguished by name (including deliberately empty NPTH).
 DR=ExcellonFile.open(CAM/'Trimix_USB_Input-PTH.drl')
 NP=ExcellonFile.open(CAM/'Trimix_USB_Input-NPTH.drl')
 W=[str(w.message) for w in ww]
G.pop('.drl',None)
raw=sexpdata.loads(BOARD.read_text())
origin=sub(next(a for a in raw if tag(a)=='setup'),'aux_axis_origin')
check('Native drill/CPL origin is 100,100 mm',origin==[100,100])
def xy(v): return (float(v[0])-origin[0], origin[1]-float(v[1]))
fps=[]; pads=[]; native_drills=[]
for fp in subs(raw,'footprint'):
 props={a[1]:a[2] for a in subs(fp,'property')}; at=sub(fp,'at'); ang=float(at[2] if len(at)>2 else 0)
 cx,cy=xy(at); ar=math.radians(ang)
 fps.append({'ref':props['Reference'],'value':props['Value'],'package':fp[1].split(':')[-1],'x':cx,'y':cy,'rotation':ang,'side':'top' if sub(fp,'layer')==['F.Cu'] else 'bottom'})
 for p in subs(fp,'pad'):
  pa=sub(p,'at'); x=cx+pa[0]*math.cos(ar)+pa[1]*math.sin(ar); y=cy+pa[0]*math.sin(ar)-pa[1]*math.cos(ar)
  w,h=map(float,sub(p,'size')); shape=str(p[3]); angle=float(pa[2] if len(pa)>2 else ang)
  if shape=='circle': geo=Point(0,0).buffer(w/2,quad_segs=96)
  elif shape=='oval':
   geo=LineString([(-(w-h)/2,0),((w-h)/2,0)]).buffer(h/2,quad_segs=96) if w>=h else LineString([(0,-(h-w)/2),(0,(h-w)/2)]).buffer(w/2,quad_segs=96)
  elif shape=='rect': geo=box(-w/2,-h/2,w/2,h/2)
  elif shape=='roundrect':
   r=float(sub(p,'roundrect_rratio')[0])*min(w,h)
   geo=box(-w/2+r,-h/2+r,w/2-r,h/2-r).buffer(r,quad_segs=96)
  else: raise ValueError(shape)
  geo=affinity.translate(affinity.rotate(geo,angle,origin=(0,0)),x,y)
  row={'ref':props['Reference'],'pin':str(p[1]),'net':str(sub(p,'net',[''])[0]),'x':x,'y':y,'angle':angle,'w':w,'h':h,'layers':sub(p,'layers'),'shape':shape,'geo':geo}
  pads.append(row)
  drill=sub(p,'drill')
  if drill:
   if str(drill[0])=='oval':
    dw,dh=map(float,drill[1:3]); small=min(dw,dh); span=abs(dw-dh)/2
    dgeo=(LineString([(-span,0),(span,0)]) if dw>dh else LineString([(0,-span),(0,span)])).buffer(small/2,quad_segs=96)
   else: dgeo=Point(0,0).buffer(float(drill[0])/2,quad_segs=96)
   dgeo=affinity.translate(affinity.rotate(dgeo,angle,origin=(0,0)),x,y)
   native_drills.append((row['ref']+'.'+row['pin'],dgeo))
for v in subs(raw,'via'):
 x,y=xy(sub(v,'at')); native_drills.append(('via',Point(x,y).buffer(float(sub(v,'drill')[0])/2,quad_segs=96)))

# Flash geometry and X2 ref/pin/net metadata matched independently to native pad geometry.
matched=[]; padfails=[]
for ext,layer in [('.gtl','F.Cu'),('.gbl','B.Cu')]:
 flashes=[o for o in G[ext].objects if type(o).__name__=='Flash' and '.P' in o.attrs]
 expected=[p for p in pads if layer in p['layers'] or '*.Cu' in p['layers']]
 unused=list(flashes)
 for p in expected:
  candidates=[o for o in unused if o.attrs['.P'][:2]==(p['ref'],p['pin']) and math.hypot(o.x-p['x'],o.y-p['y'])<2e-6]
  ok=len(candidates)==1
  if ok:
   o=candidates[0]; unused.remove(o); geom=geometry(o); hd=p['geo'].hausdorff_distance(geom)
   ok=o.attrs.get('.N')==(p['net'],) and hd<0.00002
   matched.append({k:v for k,v in p.items() if k not in ('geo','layers')}|{'layer':layer,'gerber_net':o.attrs.get('.N'),'geometry_max_error_mm':hd})
  if not ok: padfails.append([p['ref'],p['pin'],layer,'missing/net/geometry mismatch'])
 check(layer+' every pad flash matches ref/pin/net/position/shape/rotation',not padfails and not unused,{'expected':len(expected),'exported':len(flashes),'unmatched':len(unused)})
check('All 35 unique schematic pin/net mappings match native and exported pads',
 {(p['ref'],p['pin'],p['net']) for p in pads}=={(n.attrib['ref'],n.attrib['pin'],net.attrib['name']) for net in ET.parse(SRC/'usb-netlist.xml').findall('./nets/net') for n in net.findall('node')}, {'unique':len({(p['ref'],p['pin'],p['net']) for p in pads})})

# Mask and paste apertures are reconciled independently of the copper flashes.
maskpaste=[]
for ext,layer in [('.gts','F.Mask'),('.gbs','B.Mask'),('.gtp','F.Paste')]:
 flashes=[o for o in G[ext].objects if type(o).__name__=='Flash']
 expected=[p for p in pads if layer in p['layers'] or ('*.Mask' in p['layers'] and layer.endswith('Mask'))]
 unused=list(flashes); fail=[]
 for p in expected:
  hits=[o for o in unused if math.hypot(o.x-p['x'],o.y-p['y'])<2e-6 and o.attrs.get('.C')==(p['ref'],) and geometry(o).hausdorff_distance(p['geo'])<0.00002]
  if hits:unused.remove(hits[0])
  else:fail.append(p['ref']+'.'+p['pin'])
 check(layer+' apertures match every native mask/paste land',not fail and not unused,{'native':len(expected),'exported':len(flashes),'missing':fail,'extra':len(unused)})
# U901 central ground paste is a separate filled native fp_rect, not a copper pad.
paste_regions=[o for o in G['.gtp'].objects if type(o).__name__=='Region']
rects=[]
for fp in subs(raw,'footprint'):
 at=sub(fp,'at'); ar=math.radians(float(at[2] if len(at)>2 else 0));cx,cy=xy(at)
 for r in subs(fp,'fp_rect'):
  if sub(r,'layer')!=['F.Paste']:continue
  a,b=sub(r,'start'),sub(r,'end');q=box(a[0],-b[1],b[0],-a[1]);q=affinity.translate(affinity.rotate(q,ar,origin=(0,0),use_radians=True),cx,cy);rects.append(q)
check('U901 central paste region matches native 0.4 x 0.6 mm aperture',len(rects)==len(paste_regions)==1 and geometry(paste_regions[0]).hausdorff_distance(rects[0])<0.000002, {'aperture_area_mm2':geometry(paste_regions[0]).area})
check('Bottom paste and silkscreen exports intentionally empty',not G['.gbp'].objects and not G['.gbo'].objects)

# Native tracks are checked one-for-one for layer, endpoints, width and X2 net.
track_results=[]
for ext,layer in [('.gtl','F.Cu'),('.gbl','B.Cu')]:
 lines=[o for o in G[ext].objects if type(o).__name__=='Line']; unmatched=list(lines)
 for t in [t for t in subs(raw,'segment') if sub(t,'layer')==[layer]]:
  a,b=xy(sub(t,'start')),xy(sub(t,'end')); width=float(sub(t,'width')[0]); net=sub(t,'net')[0]
  hits=[o for o in unmatched if ((math.dist(a,(o.x1,o.y1))<2e-6 and math.dist(b,(o.x2,o.y2))<2e-6) or (math.dist(b,(o.x1,o.y1))<2e-6 and math.dist(a,(o.x2,o.y2))<2e-6)) and abs(o.aperture.equivalent_width(MM)-width)<1e-6 and o.attrs.get('.N')==(net,)]
  if hits: unmatched.remove(hits[0])
  else: track_results.append({'layer':layer,'from':a,'to':b,'hits':len(hits)})
 check(layer+' all native track segments match exported bytes',not unmatched and not track_results,{'exported_segments':len(lines)})
check('Exactly 94 tracks and 14 vias retained',len(subs(raw,'segment'))==94 and len(subs(raw,'via'))==14)
for ext in ['.gtl','.gbl']:
 viafl=[o for o in G[ext].objects if type(o).__name__=='Flash' and dict(o.aperture.attrs or ()).get('.AperFunction')==('ViaPad',)]
 ok=len(viafl)==14
 for v in subs(raw,'via'):
  pt=xy(sub(v,'at')); dia=float(sub(v,'size')[0]); net=sub(v,'net')[0]
  ok &= len([o for o in viafl if math.dist(pt,(o.x,o.y))<2e-6 and abs(o.aperture.diameter-dia)<1e-6 and o.attrs.get('.N')==(net,)])==1
 check(ext+' via copper diameter/position/net',ok,{'vias':len(viafl)})

# Drill/slot shape comparison does not trust the separate textual drill report.
dobjs=[geometry(o) for o in DR.objects]; remaining=list(range(len(dobjs))); dmatch=[]
for ref,g in native_drills:
 hits=[i for i in remaining if dobjs[i].hausdorff_distance(g)<0.00002]
 if len(hits)==1: remaining.remove(hits[0]); dmatch.append(ref)
check('All 26 plated drill/slot shapes match native holes and vias',len(dmatch)==len(native_drills)==26 and not remaining,{'native':len(native_drills),'gerber_round':sum(type(o).__name__=='Flash' for o in DR.objects),'gerber_slots':sum(type(o).__name__=='Line' for o in DR.objects),'matched':len(dmatch),'remaining':remaining})
check('Zero NPTH drill objects',len(NP.objects)==0)
drill_counts=Counter(round(o.aperture.diameter,3) for o in DR.objects)
check('Drill tool quantities match report',drill_counts=={0.2:11,0.3:3,0.5:6,0.8:6},dict(drill_counts))

# Outline uses centre-lines (not the rendered 0.05 mm pen width).
edges=[]; eg=G['.gm1']; unmatched=list(eg.objects); outfail=[]
for e in [a for a in raw if tag(a) in {'gr_line','gr_arc'} and sub(a,'layer')==['Edge.Cuts']]:
 a,b=xy(sub(e,'start')),xy(sub(e,'end'))
 candidates=[o for o in unmatched if ((math.dist(a,(o.x1,o.y1))<2e-6 and math.dist(b,(o.x2,o.y2))<2e-6) or (math.dist(b,(o.x1,o.y1))<2e-6 and math.dist(a,(o.x2,o.y2))<2e-6)) and type(o).__name__==('Line' if tag(e)=='gr_line' else 'Arc')]
 if len(candidates)==1:
  o=candidates[0]; unmatched.remove(o)
  if tag(e)=='gr_arc':
   mid=xy(sub(e,'mid')); c=(o.x1+o.cx,o.y1+o.cy)
   if abs(math.dist(c,mid)-math.dist(c,(o.x1,o.y1)))>3e-6: outfail.append('arc centre mismatch')
 else: outfail.append(str(e))
for o in eg.objects:
 pts=[(o.x1,o.y1),(o.x2,o.y2)] if type(o).__name__=='Line' else [(x.x1,x.y1) for x in o.approximate(max_error=0.00001,unit=MM)]+[(o.x2,o.y2)]
 # 1e-5 mm endpoint grid closes Gerber export's 0.000001 mm quantization discrepancy.
 pts=[(round(x,5),round(y,5)) for x,y in pts];edges.append(LineString(pts))
boundary=unary_union(edges); regions=list(polygonize(boundary)); board=unary_union(regions)
check('18 outline segments/arcs match native and form one closed profile',not outfail and not unmatched and len(eg.objects)==18 and len(regions)==1,{'native_match_failures':outfail,'regions':len(regions),'bounds_mm':list(board.bounds),'area_mm2':board.area,'endpoint_snap_mm':0.00001})

# Geometry connectivity: no component-internal connections are added, even same-number lands.
# Regions may include separate islands: split polygons before constructing contact graph.
nodes=[]
for ext in ['.gtl','.gbl']:
 for oi,o in enumerate(G[ext].objects):
  assert o.polarity_dark, 'Unexpected negative copper polarity requires compositing'
  for shape in polys(geometry(o)):
   nodes.append({'layer':ext,'object':oi,'geo':shape,'attrs':o.attrs if isinstance(o.attrs,dict) else {},'kind':type(o).__name__})
def components_for(parts):
 parent=list(range(len(parts)))
 def find(i):
  while parent[i]!=i:parent[i]=parent[parent[i]];i=parent[i]
  return i
 def join(i,j):parent[find(i)]=find(j)
 for i,a in enumerate(parts):
  for j in range(i):
   b=parts[j]
   if a['layer']==b['layer'] and a['geo'].distance(b['geo'])<0.000002:join(i,j)
 # Plated barrel links actual copper on both sides; holes are not copper islands.
 for d in dobjs:
  hits=[i for i,n in enumerate(parts) if n['geo'].intersects(d)]
  for j in hits[1:]:join(hits[0],j)
 result=defaultdict(list)
 for i,n in enumerate(parts):result[find(i)].append(n)
 return result
components=components_for(nodes)
conn=[]
for ns in components.values():
 nets=sorted({n['attrs']['.N'][0] for n in ns if '.N' in n['attrs']})
 pins=sorted({'.'.join(n['attrs']['.P'][:2]) for n in ns if '.P' in n['attrs']})
 conn.append({'nets':nets,'pins':pins,'objects':len(ns),'layers':sorted({n['layer'] for n in ns})})
check('No copper-connected component mixes different nets',all(len(c['nets'])==1 for c in conn),conn)
netcomponents=Counter(n for c in conn for n in c['nets'])
check('Every signal/GND/VBUS net is one physical copper component; SBU lands isolated',len(conn)==8 and all(v==1 for v in netcomponents.values()),dict(netcomponents))

# Measure actual same-layer net-to-net clearances after deriving region nets from
# physical copper contact. No region metadata is fabricated: Gerbonara drops it.
clearances=[]
for ext in ['.gtl','.gbl']:
 netgeo={}
 for ns in components.values():
  netnames={n['attrs']['.N'][0] for n in ns if '.N' in n['attrs']}
  if len(netnames)==1:netgeo[next(iter(netnames))]=unary_union([n['geo'] for n in ns if n['layer']==ext])
 names=sorted(netgeo)
 for i,a in enumerate(names):
  for b in names[:i]:
   if not netgeo[a].is_empty and not netgeo[b].is_empty:clearances.append({'layer':ext,'nets':[a,b],'mm':netgeo[a].distance(netgeo[b])})
check('All exported same-layer net clearances at least 0.15 mm within 2 um calculation tolerance',all(c['mm']>=0.15-0.000002 for c in clearances),{'minimum_mm':min(c['mm'] for c in clearances)})
check('No exported copper outside closed board outline',all(n['geo'].difference(board.buffer(0.00002)).area<1e-8 for n in nodes))

# Prove the optional NC links are real copper under U901, not synthetic pin unions.
bridges=[]
for a,b in [('1','10'),('2','9'),('4','7'),('5','6')]:
 p=next(p for p in pads if p['ref']=='U901' and p['pin']==a);q=next(p for p in pads if p['ref']=='U901' and p['pin']==b)
 path=LineString([(p['x'],p['y']),(q['x'],q['y'])]).buffer(0.075,quad_segs=96)
 copper=unary_union([n['geo'] for n in nodes if n['layer']=='.gtl' and n['attrs'].get('.N')==(p['net'],)])
 bridges.append({'pads':[a,b],'net':p['net'],'width_mm':0.15,'length_mm':math.hypot(p['x']-q['x'],p['y']-q['y']),'outside_copper_area_mm2':path.difference(copper.buffer(0.000002)).area})
check('All four U901 external 0.15 mm NC-to-protected-pad bridges exported',all(b['outside_copper_area_mm2']<1e-9 for b in bridges),bridges)
# Four failure controls operate on temporary in-memory copper geometry only.
# Removing a bridge must expose two islands; no internal ESD path may hide it.
negative_controls=[]
for b in bridges:
 p=next(p for p in pads if p['ref']=='U901' and p['pin']==b['pads'][0])
 cut=box(p['x']-.15,-6.825,p['x']+.15,-6.775)
 trial=[]
 for n in nodes:
  g=n['geo'].difference(cut) if n['layer']=='.gtl' else n['geo']
  trial.extend(n|{'geo':g} for g in polys(g))
 groups=components_for(trial)
 islands=sum(any(n['attrs'].get('.N')==(b['net'],) for n in ns) for ns in groups.values())
 negative_controls.append({'removed_bridge':b['pads'],'net':b['net'],'resulting_net_islands':islands})
check('Failure controls: removing each ESD bridge exposes a broken net',all(t['resulting_net_islands']==2 for t in negative_controls),negative_controls)

sh=[p for p in pads if p['ref']=='J901' and p['pin']=='SH']
check('Four distinct split SH plated slots all connected to GND',len(sh)==4 and all(p['net']=='GND' for p in sh) and any(c['nets']==['GND'] and 'J901.SH' in c['pins'] for c in conn),{'SH_centres_mm':[[p['x'],p['y']] for p in sh]})
harness={str(i):n for i,n in enumerate(['USB_5V','GND','USB_CC1','USB_CC2','USB_D_P','USB_D_M'],1)}
check('J902 exact 6-wire mapping, 1.8 mm pitch and same numbering contract', {p['pin']:p['net'] for p in pads if p['ref']=='J902'}==harness and all(abs(p['x']-(3.5+1.8*(int(p['pin'])-1)))<1e-6 and abs(p['y']+4.5)<1e-6 for p in pads if p['ref']=='J902'),harness)

# Manufacturing holds evaluated directly from exported copper and outline/drills.
edgeholds=[]
for o in G['.gtl'].objects:
 if type(o).__name__=='Flash' and o.attrs.get('.P',('',))[0]=='J901':
  d=geometry(o).distance(boundary)
  if d<0.20-0.00001:edgeholds.append({'pin':o.attrs['.P'][1],'xy_mm':[o.x,o.y],'edge_clearance_mm':d})
annular=[]
for o in G['.gtl'].objects:
 if type(o).__name__=='Flash' and o.attrs.get('.P') in [('J901','A1'),('J901','B1')] and getattr(o.aperture,'diameter',None)==0.8:
  hole=next(d for d in DR.objects if type(d).__name__=='Flash' and math.dist((d.x,d.y),(o.x,o.y))<1e-6)
  annular.append({'pin':o.attrs['.P'][1],'copper_diameter_mm':o.aperture.diameter,'hole_mm':hole.aperture.diameter,'radial_ring_mm':(o.aperture.diameter-hole.aperture.diameter)/2})
check('GCT original 0.10/0.15 mm copper-edge limits remain in exported geometry',set(round(a['edge_clearance_mm'],3) for a in edgeholds)=={0.1,0.15},edgeholds)
check('Two GCT 0.15 mm annular rings remain; they do not meet 0.18 mm process target',len(annular)==2 and all(abs(a['radial_ring_mm']-0.15)<1e-6 for a in annular),annular)
drc=json.loads((SRC/'usb-drc.json').read_text()); types=Counter(v['type'] for v in drc['violations'])
check('Native DRC retains 22 process findings and zero unrouted/parity',types=={'copper_edge_clearance':20,'annular_width':2} and not drc['unconnected_items'] and not drc['schematic_parity'],dict(types))

# BOM and placement file: all physical assemblies once, no visual-detail purchasing inflation.
cpl=list(csv.DictReader((CAM/'placement-all.csv').open()));bom=list(csv.DictReader((CAM/'purchasing-bom.csv').open()))
poses=[]
for row in cpl:
 f=next((x for x in fps if x['ref']==row['Ref']),None)
 ok=f is not None and f['value']==row['Val'] and f['package']==row['Package'] and f['side']==row['Side'] and all(abs(float(row[k])-f[v])<2e-6 for k,v in [('PosX','x'),('PosY','y'),('Rot','rotation')])
 poses.append({'reference':row['Ref'],'pass':ok,'native':f,'CPL':row})
check('BOM/CPL/native each contain exactly four assemblies once',len(bom)==len(cpl)==len(fps)==4 and {x['ref'] for x in fps}=={b['Reference'] for b in bom}=={c['Ref'] for c in cpl} and all(int(b['Quantity'])==1 for b in bom))
check('All CPL coordinates/rotations/sides/values/packages match native',all(p['pass'] for p in poses),poses)
check('Purchasing BOM separates exact three MPNs from unresolved custom harness', {r['Reference']:r['MPN_or_description'] for r in bom}=={'J901':'USB4720-03-A','U901':'TPD4E05U06DQAR','D901':'TPD1E10B06DYAR','J902':'Custom six-wire harness'} and next(r for r in bom if r['Reference']=='J902')['Category']=='Supplied / unresolved')

# Simple flat SVG, avoiding SVG filter blending unsupported in CairoSVG.
# Layer geometry is Gerbonara's parsed exported bytes, not native coordinates.
colors={'USB_5V':'#cf6c17','GND':'#80918b','USB_CC1':'#ad3ce0','USB_CC2':'#315dde','USB_D_P':'#13a7a1','USB_D_M':'#db4078'}
def svggeom(g,fill,stroke='none',width=0):
 chunks=[]
 for p in polys(g):
  d=' '.join('M '+' L '.join(f'{x:.6f},{-y:.6f}' for x,y in ring.coords)+' Z' for ring in [p.exterior,*p.interiors])
  chunks.append(f'<path d="{d}" fill="{fill}" stroke="{stroke}" stroke-width="{width}" fill-rule="evenodd"/>')
 return ''.join(chunks)
def render(side,detail=False):
 ext='.gtl' if side=='top' else '.gbl'
 viewport=(7.8,5.6,3.6,2.5) if detail else (-0.8,-0.8,17.6,17.32)
 s=[f'<svg xmlns="http://www.w3.org/2000/svg" viewBox="{" ".join(map(str,viewport))}" width="1760" height="1732"><rect x="-1" y="-1" width="18" height="18" fill="#f8fafb"/>',svggeom(board,'#eff1e9','#242e36',.02)]
 for o in G[ext].objects:
  net=(o.attrs if isinstance(o.attrs,dict) else {}).get('.N',('',))[0];s.append(svggeom(geometry(o),colors.get(net,'#8c9194')))
 for d in dobjs:s.append(svggeom(d,'#f8fafb','#222',.012))
 if not detail:
  if side=='top':
   for o in G['.gto'].objects:s.append(svggeom(geometry(o),'#18252c'))
  s.append(svggeom(board,'none','#18252c',.02))
  s.append('<text x=".2" y=".65" font-family="sans-serif" font-size=".32" fill="#18252c">Independent Gerber: '+side+' copper (top coordinate view)</text>')
  for o in G[ext].objects:
   if type(o).__name__=='Flash' and '.P' in o.attrs:
    ref,pin=o.attrs['.P'][:2]
    if ref=='J902':s.append(f'<text x="{o.x}" y="{-o.y+.95}" text-anchor="middle" font-family="sans-serif" font-size=".27" fill="#18252c">{pin}</text>')
 else:
  for o in G[ext].objects:
   if type(o).__name__=='Flash' and o.attrs.get('.P',('',))[0]=='U901':
    pin=o.attrs['.P'][1];s.append(f'<text x="{o.x+.12}" y="{-o.y+.03}" font-family="sans-serif" font-size=".11" fill="#18252c">{pin}</text>')
 s.append('</svg>');svg=''.join(s);name='esd-bridges-detail' if detail else f'gerber-{side}'
 (OUT/(name+'.svg')).write_text(svg);cairosvg.svg2png(bytestring=svg.encode(),write_to=str(OUT/(name+'.png')),output_width=1800,output_height=1250 if detail else 1772)
render('top');render('bottom');render('top',True)
# Also keep parser's own monochrome layer output for direct shape inspection.
for ext,name in [('.gtl','F-Cu'),('.gbl','B-Cu'),('.gts','F-Mask'),('.gbs','B-Mask'),('.gtp','F-Paste'),('.gm1','Edge-Cuts')]:
 svg=str(G[ext].to_svg(margin=.5));(OUT/(name+'.svg')).write_text(svg)
frozen=json.loads((SRC/'audit.json').read_text());frozen_hashes={r['path']:r['sha256'] for k in ['sources','artifacts'] for r in frozen.get(k,[])}
# The native report uses a sources list under source_files in some schema revisions.
for value in frozen.values():
 if isinstance(value,list):
  for r in value:
   if isinstance(r,dict) and 'path' in r and 'sha256' in r:frozen_hashes[r['path']]=r['sha256']
reconciled=[r for r in BEFORE if r['path'] in frozen_hashes]
check('Inputs match original frozen native export receipt',bool(reconciled) and all(r['sha256']==frozen_hashes[r['path']] for r in reconciled),{'files_matched':len(reconciled)})
AFTER=[receipt(p) for p in INPUTS if p.is_file()]
check('All frozen input bytes unchanged during independent audit',BEFORE==AFTER)
report={'schema':1,'purpose':'Independent exported-byte USB CAM validation; NOT fabrication release','duplicate_track_objects':{ext:len([o for o in G[ext].objects if type(o).__name__=='Line'])-len({(tuple(sorted([(o.x1,o.y1),(o.x2,o.y2)])),o.aperture.equivalent_width(MM),o.attrs.get('.N')) for o in G[ext].objects if type(o).__name__=='Line'}) for ext in ['.gtl','.gbl']},'runtime':{'python':sys.version,'platform':platform.platform(),'gerbonara':'1.6.3','shapely':'2.1.2','native_KiCad_API_used':False},'inputs':BEFORE,'checks':checks,'passed':sum(c['pass'] for c in checks),'failed':sum(not c['pass'] for c in checks),'parser_warnings':W,'parser_limitations':['Gerbonara 1.6.3 Region omits X2 attributes; retained as unknown, and its net is derived only from copper contact to attributed flashes/lines. No installed parser patch.'],'pad_flash_comparison':matched,'pad_failures':padfails,'connectivity':conn,'external_esd_bridges':bridges,'bridge_removal_negative_controls':negative_controls,'copper_edge_holds':edgeholds,'annular_holds':annular,'placement':poses,'same_layer_clearances':clearances,'limits':['Polygon circles use 96 segments per quadrant; arc chord error target 0.00001 mm; outline endpoint snap 0.00001 mm, contact tolerance 0.000002 mm. Not a fabrication tolerance.','Geometry proves copper connectivity only; no internal IC/shell connections are assumed. Manufacturer pin/datasheet correctness, CAM preprocessing and physical solder/ESD/fit are separate.','Physical fabrication holds remain: original GCT edge/annular clearances, routed tolerance and fine-USON assembly.','Bottom copper rendering is top coordinate view (not mirrored).']}
(OUT/'audit.json').write_text(json.dumps(report,indent=2)+'\n')
print(json.dumps({'passed':report['passed'],'failed':report['failed'],'copper_components':len(conn),'export_pad_flashes_matched':len(matched),'edge_holds':len(edgeholds)},indent=2))
if report['failed']:sys.exit(1)
