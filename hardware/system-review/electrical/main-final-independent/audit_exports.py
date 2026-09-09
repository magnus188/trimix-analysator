#!/usr/bin/env python3
"""Independent 4-layer main PCB CAM comparison; no KiCad API/connectivity.
Requires the temporary Gerbonara environment documented in requirements.lock.txt.
"""
import argparse,csv,hashlib,json,math,platform,sys,time,warnings
from pathlib import Path
from collections import Counter,defaultdict
import xml.etree.ElementTree as ET
import sexpdata,cairosvg
from gerbonara import GerberFile,ExcellonFile
from gerbonara.graphic_objects import Region
from shapely.ops import polygonize,nearest_points
from cam_geometry import *

def digest(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def receipt(p):return dict(path=str(p.resolve()),bytes=p.stat().st_size,sha256=digest(p))
def main():
 ap=argparse.ArgumentParser();ap.add_argument('--board',type=Path,required=True);ap.add_argument('--netlist',type=Path,required=True);ap.add_argument('--cam',type=Path,required=True);ap.add_argument('--out',type=Path,required=True);ap.add_argument('--bom',type=Path);ap.add_argument('--diagnostic',action='store_true');ap.add_argument('--no-render',action='store_true');args=ap.parse_args()
 args.out.mkdir(parents=True,exist_ok=True);started=time.monotonic()
 inputs=sorted(set([p for p in args.cam.iterdir() if p.is_file()]+[args.board,args.netlist]+([args.bom] if args.bom else [])))
 before=[receipt(p) for p in inputs];checks=[]
 def check(label,condition,detail=None,category='export-equivalence'):
  checks.append(dict(check=label,pass_=bool(condition),category=category,detail=detail))
  if not condition:print('FAIL',category,label,str(detail)[:250],flush=True)
 raw=sexpdata.loads(args.board.read_text());native=Native(raw)
 check('Exactly four native copper layers in stack order',native.layers==CU,native.layers)
 suffix={'F.Cu':'.gtl','In1.Cu':'.g1','In2.Cu':'.g2','B.Cu':'.gbl','F.Mask':'.gts','B.Mask':'.gbs','F.Paste':'.gtp','B.Paste':'.gbp','F.SilkS':'.gto','B.SilkS':'.gbo','Edge.Cuts':'.gm1'}
 G={};warn=[]
 with warnings.catch_warnings(record=True) as ww:
  warnings.simplefilter('always')
  for layer,ext in suffix.items():
   files=[p for p in args.cam.iterdir() if p.suffix==ext]
   if len(files)!=1:raise ValueError(f'{layer}: expected exactly one{ext} export, got{files}')
   G[layer]=GerberFile.open(files[0])
  drillfiles=[p for p in args.cam.iterdir() if p.suffix=='.drl'];DR={p.name:ExcellonFile.open(p) for p in drillfiles}
  warn=[str(w.message) for w in ww]
 geom_cache={id(o):geometry(o) for g in G.values() for o in g.objects}
 geo=lambda o:geom_cache[id(o)]
 pad_results=[];custom_results=[];flash_failure=[]
 for layer in CU:
  expected=[p for p in native.pads_on(layer) if str(p['raw'][2])!='np_thru_hole']
  flashes=[o for o in G[layer].objects if type(o).__name__=='Flash' and (attrs(o).get('.C') or attrs(o).get('.P'))]
  indexed=defaultdict(list)
  for i,o in enumerate(flashes):indexed[attrs(o)['.P'][:2] if attrs(o).get('.P') else (attrs(o)['.C'][0],None)].append(i)
  used=set();fails=[]
  for p in expected:
   candidates=[i for i in indexed[(p['ref'],p['pin'])]+indexed[(p['ref'],None)] if i not in used and math.dist((flashes[i].x,flashes[i].y),(p['x'],p['y']))<EPS]
   distances=[(p['geo'].hausdorff_distance(geo(flashes[i])),i) for i in candidates]
   if distances:
    hd,i=min(distances);o=flashes[i];used.add(i);gn=attrs(o).get('.N',('',))[0]
    ok=hd<SHAPE_EPS and gn==p['net']
   else:hd=None;gn=None;ok=False
   row={k:p[k] for k in ['ref','pin','id','net','x','y','angle','w','h','shape']};row.update(layer=layer,pass_=ok,gerber_net=gn,geometry_max_error_mm=hd,pin_attribute_present=bool(distances and attrs(o).get('.P')));pad_results.append(row)
   if p['shape']=='custom':custom_results.append(row)
   if not ok:fails.append(row)
  extra=[i for i in range(len(flashes)) if i not in used]
  check(layer+' pad identity/position/shape/net parity',not fails and not extra,dict(expected=len(expected),flashes=len(flashes),missing_or_mismatched=fails,extra=extra));flash_failure+=fails
 # Only electrical pins enter schematic parity; paste-only anchors and NPTH have no net.
 actual={(p['ref'],p['pin'],p['net']) for p in native.pads if p['pin'] and p['net']}
 schematic={(n.get('ref'),n.get('pin'),net.get('name')) for net in ET.parse(args.netlist).findall('./nets/net') for n in net.findall('node') if n.get('ref') in {f['ref'] for f in native.fps}}
 # A factory-omitted polarization post deliberately has no physical pad. Require
 # its exact native part code and explicitly unused schematic net before exclusion.
 # The omitted header POST does not require its unused PCB pad/hole to be
 # omitted. Some revisions retain that harmless NC pad. Exempt only a pad
 # genuinely absent from native copper; ordinary equality remains preferred.
 omitted=({('J301','7','unconnected-(J301-Pin_7-Pad7)')}-actual) if any(f['ref']=='J301' and f['props'].get('MPN')=='HTSW-113-07-L-D-007' for f in native.fps) else set()
 check('All physical electrical pin/net mappings match schematic XML',actual==schematic-omitted,dict(native_unique=len(actual),schematic_unique=len(schematic),documented_omitted_NC_polarization=sorted(omitted),native_only=sorted(actual-schematic),schematic_only=sorted(schematic-actual-omitted)))

 apertures=[]
 for layer in ['F.Mask','B.Mask','F.Paste','B.Paste']:
  expected=[(p,native.aperture(p,layer)) for p in native.pads_on(layer)]
  flashes=[o for o in G[layer].objects if type(o).__name__=='Flash'];regions=[o for o in G[layer].objects if type(o).__name__=='Region'];used=set();fails=[]
  for p,shape in expected:
   candidates=[(shape.hausdorff_distance(geo(o)),i) for i,o in enumerate(flashes) if i not in used and attrs(o).get('.C')==(p['ref'],) and math.dist((o.x,o.y),(p['x'],p['y']))<EPS]
   if candidates:hd,i=min(candidates);used.add(i);ok=hd<SHAPE_EPS
   else:hd=None;ok=False
   row=dict(id=p['id'],ref=p['ref'],pin=p['pin'],layer=layer,shape=p['shape'],pass_=ok,max_error_mm=hd,area_mm2=shape.area)
   if p['shape']=='custom' and layer.endswith('.Mask'):
    margin=float(sub(p['raw'],'solder_mask_margin',[0])[0]);row.update(custom_offset_chords_degrees=45,ideal_round_offset_max_chord_deficit_mm=margin*(1-math.cos(math.pi/8)))
   apertures.append(row)
   if not ok:fails.append(row)
  extras=[i for i in range(len(flashes)) if i not in used]
  check(layer+' apertures match native pad-specific geometry and margins',not fails and not extras,dict(expected=len(expected),flashes=len(flashes),mismatches=fails,extra=extras))
  ng=unary_union([g['geo'] for g in native.graphics if g['layer']==layer]);eg=unary_union([geo(o) for o in regions])
  ok=ng.is_empty and eg.is_empty or (not ng.is_empty and not eg.is_empty and ng.hausdorff_distance(eg)<SHAPE_EPS)
  check(layer+' non-pad graphic apertures match native',ok,dict(native_area=ng.area,region_area=eg.area))

 track_results=[];via_results=[];zone_results=[]
 for layer in CU:
  lines=[o for o in G[layer].objects if type(o).__name__=='Line'];used=set();fails=[]
  # Endpoint binning avoids all-tracks squared comparisons.
  key=lambda a,b:tuple(sorted([(round(a[0],5),round(a[1],5)),(round(b[0],5),round(b[1],5))]))
  idx=defaultdict(list)
  for i,o in enumerate(lines):idx[key((o.x1,o.y1),(o.x2,o.y2))].append(i)
  nt=[t for t in native.tracks if t['layer']==layer]
  for t in nt:
   hits=[i for i in idx[key(t['a'],t['b'])] if i not in used and attrs(lines[i]).get('.N')==(t['net'],) and abs(lines[i].aperture.equivalent_width(MM)-t['width'])<EPS]
   if hits:used.add(hits[0])
   else:fails.append({k:v for k,v in t.items() if k!='geo'})
  check(layer+' tracks match native endpoints/width/net',not fails and len(used)==len(lines),dict(native=len(nt),exported=len(lines),mismatches=fails,extra=len(lines)-len(used)));track_results+=fails
  vf=[o for o in G[layer].objects if type(o).__name__=='Flash' and dict(o.aperture.attrs or ()).get('.AperFunction')==('ViaPad',)]
  fails=[];used=set()
  for v in native.vias:
   hits=[i for i,o in enumerate(vf) if i not in used and math.dist((o.x,o.y),v['xy'])<EPS and attrs(o).get('.N')==(v['net'],) and geo(o).hausdorff_distance(v['geo'])<SHAPE_EPS]
   if hits:used.add(hits[0])
   else:fails.append(v['id'])
  check(layer+' via copper size/position/net parity',not fails and len(used)==len(vf),dict(native=len(native.vias),exported=len(vf),missing=fails,extra=len(vf)-len(used)))
  ng=unary_union([z['geo'] for z in native.zones if z['layer']==layer]);eg=unary_union([geo(o) for o in G[layer].objects if type(o).__name__=='Region'])
  hd=None if ng.is_empty or eg.is_empty else ng.hausdorff_distance(eg)
  ok=(ng.is_empty and eg.is_empty) or (hd is not None and hd<SHAPE_EPS and ng.symmetric_difference(eg).area<max(.00001,ng.length*SHAPE_EPS))
  row=dict(layer=layer,native_area_mm2=ng.area,export_area_mm2=eg.area,max_error_mm=hd,native_islands=len(polys(ng)),export_islands=len(polys(eg)))
  check(layer+' filled zone geometry matches native saved fill',ok,row);zone_results.append(row)

 drill_results=[];drill_geometries=[];cam_holes=[]
 # Decimal Excellon MM coordinates export to0.001mm. Per-axis rounding permits
 # sqrt(2)*0.0005mm centre displacement; this is quantization, not fabrication error.
 drill_epsilon=.000710
 for plated in [True,False]:
  names=[name for name in DR if ('NPTH' not in name if plated else 'NPTH' in name)]
  if len(names)!=1:raise ValueError('Require separately identifiable PTH and NPTH drill files')
  objs=DR[names[0]].objects;geos=[geometry(o) for o in objs];drill_geometries+=geos;tree=STRtree(geos);used=set();fails=[]
  exp=[h for h in native.holes if h['plated']==plated]
  for h in exp:
   hits=[int(i) for i in tree.query(h['geo'].buffer(drill_epsilon)) if int(i) not in used and geos[int(i)].hausdorff_distance(h['geo'])<drill_epsilon and abs(objs[int(i)].aperture.diameter-h['diameter'])<EPS]
   if hits:used.add(hits[0]);cam_holes.append(h|{'geo':geos[hits[0]],'native_to_cam_error_mm':geos[hits[0]].hausdorff_distance(h['geo'])})
   else:fails.append(h['id'])
  row=dict(file=names[0],plated=plated,expected=len(exp),exported=len(objs),matched=len(used),missing=fails,extra=len(objs)-len(used),tool_counts=dict(Counter(str(round(o.aperture.diameter,6)) for o in objs)),coordinate_quantization_mm=.001,max_native_to_CAM_shape_error_mm=max((h['native_to_cam_error_mm'] for h in cam_holes if h['plated']==plated),default=0))
  check(('PTH' if plated else 'NPTH')+' all drill/slot geometries match native',not fails and len(used)==len(objs),row);drill_results.append(row)

 # Match outline primitive geometry and polygonize centre-lines, retaining holes.
 edge=G['Edge.Cuts'];native_edges=[e for e in raw if tag(e) in ['gr_line','gr_arc'] and sub(e,'layer')==['Edge.Cuts']];used=set();fails=[];paths=[]
 for e in native_edges:
  a,b=native.xy(sub(e,'start')),native.xy(sub(e,'end'));kind='Line' if tag(e)=='gr_line' else 'Arc'
  hits=[i for i,o in enumerate(edge.objects) if i not in used and type(o).__name__==kind and ((math.dist(a,(o.x1,o.y1))<EPS and math.dist(b,(o.x2,o.y2))<EPS) or (math.dist(b,(o.x1,o.y1))<EPS and math.dist(a,(o.x2,o.y2))<EPS))]
  if len(hits)==1:
   i=hits[0];used.add(i);o=edge.objects[i]
   if kind=='Arc':
    m=native.xy(sub(e,'mid'));c=(o.x1+o.cx,o.y1+o.cy)
    if abs(math.dist(c,m)-math.dist(c,(o.x1,o.y1)))>EPS:fails.append('arc midpoint radius mismatch')
  else:fails.append(str(e)[:250])
 for o in edge.objects:
  pts=[(o.x1,o.y1),(o.x2,o.y2)] if type(o).__name__=='Line' else [(x.x1,x.y1) for x in o.approximate(max_error=.00001,unit=MM)]+[(o.x2,o.y2)]
  paths.append(LineString([(round(x,5),round(y,5)) for x,y in pts]))
 boundary=unary_union(paths);profiles=list(polygonize(boundary));board=unary_union(profiles)
 check('Outline primitives match native and form a closed board profile',not fails and len(used)==len(edge.objects) and len(profiles)==1,dict(native=len(native_edges),exported=len(edge.objects),regions=len(profiles),errors=fails,bounds_mm=board.bounds,area_mm2=board.area))

 print('Building spatial copper graph',flush=True)
 nodes=physical_nodes({l:G[l].objects for l in CU},cam_holes);groups,comparisons=components_for(nodes,cam_holes);conn=summarize_components(groups)
 check('No connected copper component mixes different named nets',all(len(c['nets'])<=1 for c in conn),[c for c in conn if len(c['nets'])>1],'connectivity')
 netgroups=defaultdict(list)
 for i,c in enumerate(conn):
  for n in c['nets']:netgroups[n].append(i)
 opens={n:[conn[i] for i in ids] for n,ids in netgroups.items() if len(ids)>1}
 check('Every named physical copper net forms one connected component',not opens,opens,'connectivity')
 check('No unattributed isolated copper remains',all(c['nets'] for c in conn),[c for c in conn if not c['nets']],'connectivity')
 outside=[dict(layer=n['layer'],object=n['object'],area_mm2=n['geo'].difference(board.buffer(SHAPE_EPS)).area) for n in nodes if n['geo'].difference(board.buffer(SHAPE_EPS)).area>1e-8]
 check('No exported copper lies outside the board profile',not outside,outside,'process-observation')

 # Controlled fixtures exercise graph failures without changing any input bytes.
 fixture=lambda shape,net,pin=None,layer='F.Cu':dict(layer=layer,geo=shape,attrs={'.N':(net,),**({'.P':pin} if pin else {})},kind='fixture')
 left=box(0,0,1,1);right=box(2,0,3,1);bridge=box(.5,.4,2.5,.6)
 fs=[fixture(left,'A',('TEST','1')),fixture(right,'A',('TEST','1')),fixture(bridge,'A')]
 baseline,_=components_for(fs,[]);broken,_=components_for(fs[:2],[])
 shorted,_=components_for(fs+[fixture(box(1,.5,2,2),'B',('OTHER','1'))],[])
 four=[fixture(Point(0,0).buffer(1).difference(Point(0,0).buffer(.2)), 'A',('SAME','1'),l) for l in CU]
 hole=dict(geo=Point(0,0).buffer(.2),plated=True,layers=CU)
 joined,_=components_for(four,[hole]);noplate,_=components_for(four,[hole|{'plated':False}])
 check('Negative control: bridge removal creates an open despite same-pin labels',len(baseline)==1 and len(broken)==2,dict(connected=len(baseline),removed_bridge=len(broken)),'control')
 check('Negative control: added cross-net copper creates a detected short',any(len(c['nets'])>1 for c in summarize_components(shorted)),None,'control')
 check('Four-layer barrel fixture joins all layers; NPTH and labels never join them',len(joined)==1 and len(noplate)==4,dict(plated=len(joined),unplated=len(noplate)),'control')
 region_pts=[(0,0),(1,0),(1,1),(0,1),(0,0),(2,0),(3,0),(3,1),(2,1),(2,0),(0,0)]
 region=Region(outline=region_pts,arc_centers=[None]*len(region_pts),unit=MM)
 split=physical_nodes({'F.Cu':[region]},[]);split_groups,_=components_for(split,[])
 check('One Gerber Region containing disjoint islands remains two disconnected nodes',len(split)==len(split_groups)==2,dict(gerber_regions=1,physical_nodes=len(split),connected_groups=len(split_groups)),'control')
 controls=[]
 # Cut a moat around one real SMD pad belonging to a multi-terminal component.
 for p in native.pads:
  if str(p['raw'][2])!='smd' or not p['net'] or not p['pin'] or p['shape']=='custom':continue
  ids=netgroups.get(p['net'],[])
  if not any(len(conn[i]['pins'])>1 for i in ids):continue
  ring=p['geo'].buffer(.10).difference(p['geo'].buffer(.01));trial=[]
  for n in nodes:
   g=n['geo'].difference(ring) if n['layer'] in p['layers'] else n['geo']
   trial += [n|{'geo':q} for q in polys(g)]
  tg,_=components_for(trial,cam_holes);tc=summarize_components(tg);count=sum(p['net'] in c['nets'] for c in tc)
  if count>len(ids):
   controls.append(dict(kind='actual_pad_moat',pad=p['id'],net=p['net'],before=len(ids),after=count));break
 check('Negative control: removing real exported copper exposes an additional open',bool(controls),controls,'control')
 named=[(ns,next(iter({n['attrs']['.N'][0] for n in ns if n['attrs'].get('.N')}))) for ns in groups.values() if len({n['attrs']['.N'][0] for n in ns if n['attrs'].get('.N')})==1]
 injected=None
 for ns,a in named:
  na=next((n for n in ns if n['layer']=='F.Cu'),None)
  if not na:continue
  other=next(((ms,b) for ms,b in named if b!=a and any(n['layer']=='F.Cu' for n in ms)),None)
  if not other:continue
  ms,b=other;nb=next(n for n in ms if n['layer']=='F.Cu');pa,pb=nearest_points(na['geo'],nb['geo']);extra=fixture(LineString([pa,pb]).buffer(.02),'INJECTED_SHORT')
  sg,_=components_for(nodes+[extra],cam_holes);bad=[c for c in summarize_components(sg) if len(c['nets'])>1]
  injected=dict(nets=[a,b],detected_mixed_groups=len(bad));break
 check('Negative control: injected bridge between actual exported nets is detected',injected is not None and injected['detected_mixed_groups']>0,injected,'control')

 # Same-layer clearances derive nets from physical copper groups, not zone labels.
 clearances=[];layernets=defaultdict(dict)
 for ns in groups.values():
  names={n['attrs']['.N'][0] for n in ns if n['attrs'].get('.N')}
  if len(names)!=1:continue
  name=next(iter(names))
  for layer in CU:
   g=unary_union([n['geo'] for n in ns if n['layer']==layer])
   if not g.is_empty:layernets[layer][name]=layernets[layer].get(name,GeometryCollection()).union(g)
 for layer,ng in layernets.items():
  names=list(ng);tree=STRtree([ng[n] for n in names])
  for i,a in enumerate(names):
   for j in tree.query(ng[a].buffer(.30)):
    j=int(j)
    if j>=i:continue
    b=names[j];d=ng[a].distance(ng[b]);clearances.append(dict(layer=layer,nets=[a,b],mm=d))
 below=[c for c in clearances if c['mm']<.15-EPS];scoped=[];unqualified=[]
 # Exact masked U115.3 cap-extension exception, not a whole-net waiver.
 # Remove only this physical disk and require the remaining complete net pair
 # to meet the ordinary target. The separate process reader verifies the
 # preserved mask/paste and exact filled/capped native manufacturing intent.
 cc_disk=Point(native.xy([13.6,89.775])).buffer(.2,quad_segs=Q)
 cc_vias=[v for v in native.vias if math.dist(v['xy'],native.xy([13.6,89.775]))<EPS and abs(v['size']-.4)<EPS and abs(v['drill']-.2)<EPS and v['net']=='USB_CC_INT_N']
 for c in below:
  other=next((name for name in c['nets']if name!='USB_CC_INT_N'),None)
  exact=c['layer']=='B.Cu'and'USB_CC_INT_N'in c['nets']and other in ['USB_OVP_SET','unconnected-(U115-FLT-Pad4)']and len(cc_vias)==1
  remainder_gap=layernets['B.Cu']['USB_CC_INT_N'].difference(cc_disk.buffer(EPS)).distance(layernets['B.Cu'][other])if exact else None
  if exact and c['mm']>=.12-EPS and remainder_gap>=.15-EPS:scoped.append(c|dict(exact_exception_xy_mm=[13.6,89.775],scope='masked cap extension only',remaining_net_pair_gap_mm=remainder_gap))
  else:unqualified.append(c)
 check('Exported net clearances meet screening target except exact reviewed masked cap',not unqualified,dict(screening_target_mm=.15,minimum_mm=min((c['mm'] for c in clearances),default=None),exact_scoped_exceptions=scoped,unqualified_below_target=unqualified),'process-observation')

 cplfiles=[p for p in args.cam.iterdir() if p.name=='placement-all.csv'];poses=[]
 if len(cplfiles)!=1:raise ValueError('placement-all.csv required for whole-assembly parity')
 cpl=list(csv.DictReader(cplfiles[0].open()));fpby={f['ref']:f for f in native.fps}
 for c in cpl:
  f=fpby.get(c['Ref']);ok=f is not None and all(c[k]==f[v] for k,v in [('Val','value'),('Package','package'),('Side','side')]) and all(abs(float(c[k])-f[v])<EPS for k,v in [('PosX','x'),('PosY','y'),('Rot','rotation')])
  poses.append(dict(reference=c['Ref'],pass_=ok,CPL=c,native={k:v for k,v in f.items() if k!='props'} if f else None))
 position_refs={f['ref'] for f in native.fps if 'exclude_from_pos_files' not in f['attributes']}
 check('Placement references match the native export-inclusion flags exactly once',Counter(c['Ref'] for c in cpl)==Counter(position_refs),dict(native_total=len(fpby),cpl=len(cpl),explicit_native_exclusions=[dict(ref=f['ref'],attributes=f['attributes']) for f in native.fps if f['ref'] not in position_refs]))
 check('All CPL positions, rotations, sides, values and packages match native',all(p['pass_'] for p in poses),[p for p in poses if not p['pass_']])
 if args.bom:
  bom=list(csv.DictReader(args.bom.open()));bomrefs=[];bf=[]
  for b in bom:
   # Explicit accepted schemas. Unknown schemas are a failed coverage gate.
   ref=b.get('Reference',b.get('Reference(s)',b.get('References','')));refparts=[r.strip() for r in ref.replace(';',',').split(',') if r.strip()]
   bomrefs += refparts
   qty=b.get('Quantity',b.get('Qty',''))
   if not refparts or not qty or int(qty)!=len(refparts):bf.append(b)
   for r in refparts:
    f=fpby.get(r)
    if f is None:bf.append(b);continue
    mpn=b.get('MPN',b.get('MPN_or_description',b.get('Manufacturer Part Number','')))
    native_mpn=f['props'].get('MPN','')
    if native_mpn and mpn!=native_mpn:bf.append(dict(ref=r,bom_mpn=mpn,native_mpn=native_mpn))
  bom_expected={f['ref'] for f in native.fps if 'exclude_from_bom' not in f['attributes']}
  # A complete assembly-reference list may include board-only geometry; a
  # purchasing-only list may follow explicit native exclude_from_bom flags.
  mode='complete reference map' if Counter(bomrefs)==Counter(fpby.keys()) else 'purchasing items only'
  check('Purchasing BOM references/quantities/native MPN parity',not bf and (Counter(bomrefs)==Counter(fpby.keys()) or Counter(bomrefs)==Counter(bom_expected)),dict(rows=len(bom),references=len(bomrefs),mode=mode,native_excluded=sorted(set(fpby)-bom_expected),failures=bf))
 else:check('Purchasing BOM supplied for independent parity review',False,'No BOM passed; final review must supply it','coverage')

 if not args.no_render:
  render(args.out,G,geom_cache,board,drill_geometries,native)
 after=[receipt(p) for p in inputs];check('All immutable input bytes unchanged throughout independent review',before==after)
 status='diagnostic snapshot — not final' if args.diagnostic else 'final supplied exports — no fabrication release'
 report=dict(schema=1,status=status,purpose='Independent exported-byte main PCB comparison; not order approval',runtime=dict(python=sys.version,platform=platform.platform(),gerbonara='1.6.3',shapely='2.1.2',native_KiCad_API_used=False,seconds=time.monotonic()-started),inputs=before,checks=checks,passed=sum(c['pass_'] for c in checks),failed=sum(not c['pass_'] for c in checks),counts=dict(footprints=len(native.fps),pads=len(native.pads),tracks=len(native.tracks),vias=len(native.vias),holes=len(native.holes),copper_nodes=len(nodes),physical_components=len(conn),spatial_candidate_comparisons=comparisons,naive_all_pair_comparisons=len(nodes)*(len(nodes)-1)//2),parser_warnings=warn,pad_comparison=pad_results,custom_pad_comparison=custom_results,mask_paste_comparison=apertures,drill_comparison=drill_results,zone_comparison=zone_results,connectivity=conn,open_nets=opens,negative_controls=controls+[injected],clearances=clearances,placement=poses,limitations=['Polygon circles128 segments/quadrant; Gerber arcs chord error target0.00001mm; numeric contact tolerance0.000002mm and shape tolerance0.000025mm are not manufacturing tolerances.','Gerbonara1.6.3 drops Region X2 attributes; separate polygon islands retain unknown net until actual copper touches attributed flashes/tracks.','Copper interiors removed at actual holes; plated-hole walls alone join four layers. No same-number pin or IC-internal joins are assumed.','Export equivalence does not certify schematic design, completed routing, fabrication tolerance, assembly yield, analog accuracy, signal integrity, current, thermal, gas or safety acceptance.','Unsupported blind/buried vias, native track arcs, nonzero paste scaling and negative copper polarity fail explicitly.','Rendering uses top coordinates on all layers; bottom is not mirrored.'])
 (args.out/'audit.json').write_text(json.dumps(report,indent=2)+'\n');print(json.dumps(dict(status=status,passed=report['passed'],failed=report['failed'],counts=report['counts'],open_net_count=len(opens)),indent=2))
 blocking=[c for c in checks if not c['pass_'] and (not args.diagnostic or c['category'] in ['export-equivalence','control'])]
 return 1 if blocking else 0

def svggeom(g,fill,stroke='none',width=0):
 chunks=[]
 for p in polys(g):
  d=' '.join('M '+' L '.join(f'{x:.6f},{-y:.6f}' for x,y in ring.coords)+' Z' for ring in [p.exterior,*p.interiors]);chunks.append(f'<path d="{d}" fill="{fill}" stroke="{stroke}" stroke-width="{width}" fill-rule="evenodd"/>')
 return ''.join(chunks)
def render(out,G,cache,board,drills,native):
 bx,by,tx,ty=board.bounds;vw=tx-bx+3;vh=ty-by+3
 for layer in CU:
  s=[f'<svg xmlns="http://www.w3.org/2000/svg" viewBox="{bx-1.5} {-ty-1.5} {vw} {vh}" width="{vw*22}" height="{vh*22}"><rect x="{bx-2}" y="{-ty-2}" width="{vw+1}" height="{vh+1}" fill="#f8fafb"/>',svggeom(board,'#eef0e8','#24313a',.025)]
  for o in G[layer].objects:
   net=attrs(o).get('.N',('',))[0];color='#8d9993' if not net or net=='GND' else '#'+hashlib.sha256(net.encode()).hexdigest()[:6];s.append(svggeom(cache[id(o)],color))
  for d in drills:s.append(svggeom(d,'#f8fafb','#25333b',.015))
  if layer in ['F.Cu','B.Cu']:
   for o in G['F.SilkS' if layer=='F.Cu' else 'B.SilkS'].objects:s.append(svggeom(cache[id(o)],'#121b20'))
  s.append(svggeom(board,'none','#132631',.03));s.append(f'<text x="{bx}" y="{-ty-.55}" font-size=".52" font-family="sans-serif">{layer} — independent Gerber, top coordinates</text>');s.append('</svg>');text=''.join(s);name=layer.replace('.','-');(out/(name+'.svg')).write_text(text);cairosvg.svg2png(bytestring=text.encode(),write_to=str(out/(name+'.png')),output_width=1000)
 for layer in ['F.Mask','B.Mask','F.Paste','B.Paste','Edge.Cuts']:
  (out/(layer.replace('.','-')+'.svg')).write_text(str(G[layer].to_svg(margin=.5)))
 # Detailed actual DSJ land/paste and bottom HotRod for visual review.
 for ref in ['U201','U115']:
  f=next((f for f in native.fps if f['ref']==ref),None)
  if not f:continue
  layer='F.Cu' if f['side']=='top' else 'B.Cu';cx,cy=f['x'],f['y'];area=box(cx-3,cy-3,cx+3,cy+3);s=[f'<svg xmlns="http://www.w3.org/2000/svg" viewBox="{cx-3} {-cy-3} 6 6" width="1200" height="1200"><rect x="{cx-3}" y="{-cy-3}" width="6" height="6" fill="#fafbf7"/>']
  for o in G[layer].objects:
   if cache[id(o)].intersects(area):s.append(svggeom(cache[id(o)].intersection(area),'#c7963f'))
  paste='F.Paste' if f['side']=='top' else 'B.Paste'
  for o in G[paste].objects:
   if cache[id(o)].intersects(area):s.append(svggeom(cache[id(o)].intersection(area),'#4166a9'))
  for p in native.pads:
   if p['ref']==ref and p['pin']:s.append(f'<text x="{p["x"]}" y="{-p["y"]}" text-anchor="middle" font-family="sans-serif" font-size=".11" fill="#fff">{p["pin"]}</text>')
  s.append('</svg>');text=''.join(s);(out/(ref+'-copper-paste.svg')).write_text(text);cairosvg.svg2png(bytestring=text.encode(),write_to=str(out/(ref+'-copper-paste.png')))
if __name__=='__main__':sys.exit(main())
