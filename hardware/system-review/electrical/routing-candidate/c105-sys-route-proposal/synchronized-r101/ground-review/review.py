"""Hash-gated native ground comparison and measured-vector overlays. No PCB writes."""
from pathlib import Path
import argparse, importlib.util, subprocess, sys, json, hashlib, inspect
from shapely.geometry import Polygon
from shapely.ops import unary_union
from shapely import make_valid

OUT=Path(__file__).resolve().parent
D=OUT.parent
parser=argparse.ArgumentParser()
parser.add_argument('--source-sha256',required=True)
parser.add_argument('--candidate-sha256',required=True)
args=parser.parse_args()
paths=[D/'before.kicad_pcb',D/'complete-candidate/Trimix_Analyzer.kicad_pcb']
expected=[args.source_sha256,args.candidate_sha256]
def sha(path):return hashlib.sha256(path.read_bytes()).hexdigest()
assert[sha(p)for p in paths]==expected
module=D.parent.parent/'cap-signal-reconnect/pullup-swap/independent-ground/audit_ground.py'
spec=importlib.util.spec_from_file_location('shared_ground_geometry',module)
a=importlib.util.module_from_spec(spec);spec.loader.exec_module(a);a.OUT=OUT
a.COLORS.update({'/01  CHARGING + BATTERY/CHG_CE_N':'#1358be','USB_OVP_SET':'#d59d13','USB_CC_INT_N':'#9445a3','/01  CHARGING + BATTERY/BQ_REGN':'#7362b8','USB_VBUS_RAW':'#b44f2b'})
view_code=inspect.getsource(a.view)
view_code=view_code.replace('refs = {"R107", "R302", "U301", "C301", "C202", "C707", "U111", "R110"}', 'refs = {"U114", "C114", "C115", "C105", "R101", "U101"}')
exec(view_code,a.__dict__)
native_python='/Applications/KiCad/KiCad.app/Contents/Frameworks/Python.framework/Versions/Current/bin/python3'
run=subprocess.run([native_python,'-B',str(OUT/'extract_native.py'),str(paths[0]),str(paths[1]),*expected],text=True,capture_output=True)
if run.returncode:raise RuntimeError(run.stderr)
raw=json.loads(run.stdout)
def shape(items):
    return unary_union([g for item in items for g in a.polys(make_valid(Polygon([(x,-y)for x,y in item['outer']], [[(x,-y)for x,y in h]for h in item['holes']])) )])
boards={};measurements={}
for label,path in zip(['source','candidate'],paths):
    native=raw[label]
    board=a.load(path)
    holes=unary_union([shape(h['polygons'])for h in native['holes']])
    fills={L:unary_union([shape(z['polygons'])for z in zs])for L,zs in native['zones'].items()}
    crosscheck={L:{'native_area_mm2':sum(z['native_area_mm2']for z in native['zones'][L]),'native_contour_shapely_area_mm2':fills[L].area,'independent_sexpr_area_mm2':board['fills'][L].area,'symmetric_difference_mm2':fills[L].symmetric_difference(board['fills'][L]).area}for L in ['In1.Cu','In2.Cu']}
    board['fills']=fills;board['all_holes']=holes;board['physical']={L:g.difference(holes)for L,g in fills.items()}
    anchors=[]
    for q in native['anchors']:
        hole=shape(q['hole']);geos={L:shape(z['polygons']).difference(holes)for L,z in q['layers'].items()}
        row={k:v for k,v in q.items()if k not in ['layers','hole']};row['layers']={}
        for L in ['In1.Cu','In2.Cu']:
            flashed=q['layers'].get(L,{}).get('flashed',False);cu=geos.get(L,Polygon());g=board['physical'][L]
            overlap=g.intersection(cu).area if flashed else 0
            row['layers'][L]={'flashed':flashed,'contact':overlap>1e-8,'overlap_mm2':overlap,'distance_mm':g.distance(cu)if not cu.is_empty else None,'whole_disk_contact':g.distance(shape(q['layers'][L]['polygons']))<=.000002 if L in q['layers']else False}
        anchors.append(row)
        # Drawing and local-hole labels use matching native drill geometry.
        old=next((x for x in board['anchors']if x['uuid']==q['uuid']),None)
        if old is not None:
            old['drill']=hole;old['copper']=geos.get('In1.Cu',Polygon());old['layers']=[L for L,v in q['layers'].items()if v['flashed']]
    regions={}
    for L in ['In1.Cu','In2.Cu']:
        rows=[]
        for idx,g in enumerate(sorted(a.polys(board['physical'][L]),key=lambda g:-g.area)):
            hits=[]
            for q in native['anchors']:
                ls=q['layers'].get(L)
                if not ls or not ls['flashed']:continue
                cu=shape(ls['polygons']).difference(holes);ov=g.intersection(cu).area
                if ov<=1e-8:continue
                ar=next(x for x in anchors if x['uuid']==q['uuid'])
                hits.append({'uuid':q['uuid'],'kind':q['kind'],'label':q['label'],'position_mm':q['position_mm'],'overlap_mm2':ov,'reaches_In1':ar['layers']['In1.Cu']['contact']})
            rows.append({'region':idx+1,'physical_area_mm2':g.area,'bounds_mm':a.bounds(g),'holes':len(g.interiors),'anchors':hits,'anchor_count':len(hits),'has_anchor_to_In1':any(x['reaches_In1']for x in hits)})
        regions[L]=rows
    boards[label]=board;measurements[label]={'native_fill_crosscheck':crosscheck,'anchors':anchors,'regions':regions,'vias':native['vias']}
b,c=boards['source'],boards['candidate']
result={'status':'FINAL_SAVED_GROUND_GEOMETRY_REVIEW','source_path':str(paths[0]),'candidate_path':str(paths[1]),'source_sha256':expected[0],'candidate_sha256':expected[1],'script_sha256':sha(Path(__file__)),'native_extractor_sha256':sha(OUT/'extract_native.py'),'shared_geometry_script_sha256':sha(module),'method':['Native GetFilledPolysList contours; polygon make_valid union preserves voids.','Physical fill subtracts every native effective drilled opening; circular conversion max error 0.00001 mm.','Every GND via and PTH pad uses layer-specific native effective metal minus all holes, actual flashing, and positive overlap >1e-8 mm2.','Measurements use native polygons; PNGs only illustrate saved geometry.','No refill, PCB write, schematic-parity inference, or whole-board acceptance.'],'measurements':measurements,'layers':{},'local_new_via_ligaments':[],'renders':[],'release':False}
lost={};gained={}
for L in ['In1.Cu','In2.Cu']:
    B,C=b['fills'][L],c['fills'][L]
    aa={x['uuid']for x in measurements['source']['anchors']if x['layers'][L]['contact']};bb={x['uuid']for x in measurements['candidate']['anchors']if x['layers'][L]['contact']}
    lost[L]=sorted(aa-bb);gained[L]=sorted(bb-aa)
    result['layers'][L]={'source_saved_area_mm2':B.area,'candidate_saved_area_mm2':C.area,'removed_saved_area_mm2':B.difference(C).area,'added_saved_area_mm2':C.difference(B).area,'source_physical_area_mm2':b['physical'][L].area,'candidate_physical_area_mm2':c['physical'][L].area,'source_region_count':len(measurements['source']['regions'][L]),'candidate_region_count':len(measurements['candidate']['regions'][L]),'source_anchor_count':len(aa),'candidate_anchor_count':len(bb),'lost_anchor_uuids':lost[L],'gained_anchor_uuids':gained[L]}
    transitions=[]
    bp=sorted(a.polys(b['physical'][L]),key=lambda g:-g.area);cp=sorted(a.polys(c['physical'][L]),key=lambda g:-g.area)
    for i,old in enumerate(bp):
        hits=[{'candidate_region':j+1,'candidate_physical_area_mm2':new.area,'retained_source_area_mm2':old.intersection(new).area}for j,new in enumerate(cp)if old.intersection(new).area>1e-8]
        transitions.append({'source_region':i+1,'source_physical_area_mm2':old.area,'candidate_overlaps':hits})
    result['layers'][L]['region_transitions']=transitions
oldvia={v['uuid']for v in raw['source']['vias']}
selected=[v for v in raw['candidate']['vias']if v['uuid']not in oldvia and abs(v['size_mm']-.5)<1e-8]
for idx,v in enumerate(selected):
    row,lines=a.throat_review(b,c,v['at_mm']);row['via']=v
    row['smallest_verified_ligaments']=[x for x in row.get('ligament_witnesses',[])if x['material_line_verified']][:3]
    containing=[h for h in a.holes_of(c['physical']['In1.Cu'])if h.covers(a.Point(v['at_mm'][0],-v['at_mm'][1]))]
    row['new_vias_sharing_this_saved_void']=[q for q in selected if len(containing)==1 and containing[0].covers(a.Point(q['at_mm'][0],-q['at_mm'][1]))]
    result['local_new_via_ligaments'].append(row)
    x,y=v['at_mm'];endpoints=[q for r in row['smallest_verified_ligaments'][:2]for q in[r['from_mm'],r['to_mm']]]
    xs=[x-1,x+1]+[q[0]for q in endpoints];ys=[y-1,y+1]+[q[1]for q in endpoints]
    crop=(max(0,min(xs)-.35),max(0,min(ys)-.35),min(30,max(xs)+.95),min(99,max(ys)+.35))
    result['renders'].append(a.view(f'via-{idx+1}-ligaments',[(b,'In1.Cu','BEFORE In1','normal'),(c,'In1.Cu',f'VIA {x:g},{y:g} In1','throats')],crop,'Local material-line witnesses near a new via; not a global neck or thermal/current rating.',1600,lines))
result['renders'].append(a.view('all-board-planes',[(b,'In1.Cu','BEFORE In1','anchors'),(c,'In1.Cu','FINAL In1','anchors'),(b,'In2.Cu','BEFORE In2','anchors'),(c,'In2.Cu','FINAL In2','anchors')],(0,0,30,99),'Actual saved fills minus drill holes. Blue rings mark GND anchors with positive annular overlap.',2400))
result['renders'].append(a.view('local-plane-comparison',[(b,'In1.Cu','BEFORE In1','anchors'),(c,'In1.Cu','FINAL In1','anchors'),(b,'In2.Cu','BEFORE In2','anchors'),(c,'In2.Cu','FINAL In2','anchors')],(2,80,24,95),'Local saved ground geometry and actual signal/power copper. No current-capacity inference.',2800))
result['renders'].append(a.view('sys-outer-copper',[(b,'F.Cu','BEFORE F.Cu','normal'),(c,'F.Cu','FINAL F.Cu','normal'),(b,'B.Cu','BEFORE B.Cu','normal'),(c,'B.Cu','FINAL B.Cu','normal')],(3,81,23,95),'Actual F/B copper around C105 and the SYS route. VSYS magenta; CHG orange; ground green.',2800))
parts=[q for q in c['native'].pads if q['ref']in {'U114','C114','C115'}]
assert parts,'Requested power parts not found'
combined=unary_union([q['geo']for q in parts]);x0,y0,x1,y1=a.bounds(combined);power_crop=(max(0,x0-2),max(0,y0-2),min(30,x1+2),min(99,y1+2))
result['power_overlay_parts']=[{'ref':f['ref'],'at_mm':[f['x'],-f['y']],'rotation':f['rotation'],'side':f['side']}for f in c['native'].fps if f['ref']in {'U114','C114','C115'}]
def net_copper(board,L,net):
    n=board['native'];chunks=[t['geo']for t in n.tracks if t['layer']==L and t['net']==net]
    chunks +=[q['geo']for q in n.pads_on(L)if q['net']==net]
    chunks +=[v['geo']for v in n.vias if L in v['layers']and v['net']==net]
    if net=='GND':chunks.append(board['fills'][L])
    return unary_union(chunks).difference(board['all_holes'])
power_window=a.rect(power_crop);power_rows=[]
for L in ['F.Cu','B.Cu']:
    for net in ['GND','USB_OVP_5V','USB_CHG_5V','USB_5V','VSYS']:
        old=net_copper(b,L,net).intersection(power_window);new=net_copper(c,L,net).intersection(power_window)
        power_rows.append({'layer':L,'net':net,'source_copper_area_mm2':old.area,'candidate_copper_area_mm2':new.area,'removed_copper_mm2':old.difference(new).area,'added_copper_mm2':new.difference(old).area})
result['local_U114_C114_C115_power_copper_comparison']={'crop_mm':power_crop,'method':'Actual outer-layer tracks/pads/vias plus ground fill, drilled openings removed; equivalent geometry only, no capacity/thermal inference.','rows':power_rows}
result['renders'].append(a.view('u114-c114-c115-outer-copper',[(b,'F.Cu','BEFORE F.Cu','normal'),(c,'F.Cu','FINAL F.Cu','normal'),(b,'B.Cu','BEFORE B.Cu','normal'),(c,'B.Cu','FINAL B.Cu','normal')],power_crop,'Actual outer-layer copper around U114, C114 and C115. No projected plane or power/thermal claim.',2800))
result['gates']={'all_input_hashes_match':True,'zone_outlines_and_settings_preserved':a.zone_definitions(b['native'])==a.zone_definitions(c['native']),'no_lost_GND_anchor_contacts':not any(lost.values()),'In1_one_physical_region':len(measurements['candidate']['regions']['In1.Cu'])==1,'all_In2_regions_have_In1_anchor':all(x['has_anchor_to_In1']for x in measurements['candidate']['regions']['In2.Cu']),'In1_signal_tracks_absent':not[t for t in c['native'].tracks if t['layer']=='In1.Cu'and t['net']!='GND'],'all_native_vs_sexpr_fill_symdiff_below_1e-8':all(x['symmetric_difference_mm2']<1e-8 for m in measurements.values()for x in m['native_fill_crosscheck'].values()),'all_GND_anchor_flashing_recorded':True}
assert[sha(p)for p in paths]==expected
result['gates']['source_files_unchanged']=True
(OUT/'review.json').write_text(json.dumps(result,indent=2)+'\n')
print(json.dumps({'gates':result['gates'],'layers':result['layers'],'via_ligaments':[{'via':x['via'],'status':x['status'],'smallest_verified_ligaments':x['smallest_verified_ligaments']}for x in result['local_new_via_ligaments']]},indent=2))
