from pathlib import Path
import sexpdata as s,sys,json,hashlib
from shapely.geometry import Point
from shapely.ops import unary_union
sys.path.insert(0,str(Path('hardware/system-review/electrical/main-final-independent').resolve()))
from cam_geometry import Native,polys
D=Path(__file__).resolve().parent
A=s.loads((D/'source.kicad_pcb').read_text());B=s.loads((D/'candidate/Trimix_Analyzer.kicad_pcb').read_text());na,nb=Native(A),Native(B)
def sub(a,k):return next((x for x in a if isinstance(x,list)and str(x[0])==k),None)
def uid(a):
 q=sub(a,'uuid');return q[1]if q else None
def objects(a,kinds):return{uid(x):x for x in a if isinstance(x,list)and str(x[0])in kinds}
def diff(a,b):return{'removed':sorted(a.keys()-b.keys()),'added':sorted(b.keys()-a.keys()),'modified':sorted(k for k in a.keys()&b.keys()if a[k]!=b[k])}
ca,cb=objects(A,{'segment','via','arc'}),objects(B,{'segment','via','arc'});fa,fb=objects(A,{'footprint'}),objects(B,{'footprint'})
d=diff(ca,cb);fd=diff(fa,fb)
assert len(fd['modified'])==1 and not fd['added']and not fd['removed'];assert fd['modified'][0]=='075b6afc-9789-4d1b-8b22-99f6cb601ff1'
assert len(d['modified'])==0
# Never submit an entire board to the owner. Only C107 body/lands + its exact copper delta.
patch=[cb[u]for u in d['added']]+[fb[fd['modified'][0]]]
(D/'guarded-patch.kicad_sexpr').write_text('\n'.join(s.dumps(x)for x in patch)+'\n')
planes=[]
for layer in['In1.Cu','In2.Cu']:
 aa=unary_union([z['geo']for z in na.zones if z['net']=='GND'and z['layer']==layer]);bb=unary_union([z['geo']for z in nb.zones if z['net']=='GND'and z['layer']==layer])
 regions=polys(bb);new=Point(16.05,-78.05)
 planes.append({'layer':layer,'before_region_count':len(polys(aa)),'after_region_count':len(regions),'symmetric_difference_area_mm2':aa.symmetric_difference(bb).area,'new_GNDvia_center_covered':bb.covers(new),'new_via_covering_region_area_mm2':[q.area for q in regions if q.covers(new)],'before_total_area_mm2':aa.area,'after_total_area_mm2':bb.area})
source_sha=hashlib.sha256((D/'source.kicad_pcb').read_bytes()).hexdigest();out_sha=hashlib.sha256((D/'candidate/Trimix_Analyzer.kicad_pcb').read_bytes()).hexdigest()
r={'source_sha256':source_sha,'candidate_sha256':out_sha,'copper_delta':d,'footprint_delta':fd,'removed_original_items':{u:s.dumps(ca[u])for u in d['removed']},'added_items':{u:s.dumps(cb[u])for u in d['added']},'original_C107_guard':s.dumps(fa[fd['modified'][0]]),'new_C107':s.dumps(fb[fd['modified'][0]]),'filled_ground':planes,'native_check':'drc-clean.json:0errors,0opens,0parity; inheritedC103silk warning only','do_not_copy_entire_board':'Source includes owner C103local2; use guarded C107-only delta and sync exact MPN/footprint/value in integration.','existing_cap3D_removed':'No claim that a generic0805 STEP has actual purchased height. Exactbodymax1.45mm+assembly.15 mechanical envelope supplied for owner integration.','ordinary_new_GNDvia':{'xy':[16.05,78.05],'diameter':.5,'drill':.25,'no_via_in_pad':True},'canonical_board_sha256':hashlib.sha256(Path('hardware/pcb/analyzer/Trimix_Analyzer.kicad_pcb').read_bytes()).hexdigest()}
(D/'guarded-delta-and-ground.json').write_text(json.dumps(r,indent=2)+'\n');print(json.dumps({'copper':d,'footprints':fd,'planes':planes},indent=2))
