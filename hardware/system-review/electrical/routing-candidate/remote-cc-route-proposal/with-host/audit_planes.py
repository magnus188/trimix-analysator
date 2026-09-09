from pathlib import Path
import sys,sexpdata,json,hashlib
D=Path(__file__).resolve().parent;sys.path.insert(0,str(Path('hardware/system-review/electrical/main-final-independent').resolve()))
from cam_geometry import *
source=sexpdata.loads((D/'before.kicad_pcb').read_text());target=sexpdata.loads((D/'Trimix_Analyzer.kicad_pcb').read_text());a,b=Native(source),Native(target)
local=box(7,-95,21,-83);rows={}
for L in ['In1.Cu','In2.Cu']:
 aa=unary_union([z['geo']for z in a.zones if z['net']=='GND'and z['layer']==L]);bb=unary_union([z['geo']for z in b.zones if z['net']=='GND'and z['layer']==L]);al=aa.intersection(local);bl=bb.intersection(local)
 def count(g):return sorted([q.area for q in polys(g)],reverse=True)
 rows[L]=dict(before_area_mm2=aa.area,after_area_mm2=bb.area,removed_area_mm2=aa.difference(bb).area,added_area_mm2=bb.difference(aa).area,before_component_areas_mm2=count(aa),after_component_areas_mm2=count(bb),local_review_rectangle=[7,83,21,95],local_before_component_areas_mm2=count(al),local_after_component_areas_mm2=count(bl),erosion_probe=[dict(radius_mm=r,before_component_areas_mm2=count(al.buffer(-r)),after_component_areas_mm2=count(bl.buffer(-r)))for r in [.05,.1,.15,.25,.5]])
 oldpins=[]
 for v in a.vias:
  if v['net']=='GND'and local.intersects(v['geo']):
   # Each annulus touches a plane if nominal filled copper intersects its metal.
   oldpins.append({'xy_mm':[v['xy'][0],-v['xy'][1]],'before_plane_touch':aa.distance(v['geo'])<.00001,'after_plane_touch':bb.distance(v['geo'])<.00001})
 rows[L]['existing_ground_via_plane_contacts']=oldpins
 anchors=[]
 g1=unary_union([z['geo']for z in b.zones if z['net']=='GND'and z['layer']=='In1.Cu'])
 for region in sorted(polys(bb),key=lambda g:-g.area):
  vias=[dict(at_mm=[v['xy'][0],-v['xy'][1]],touches_In1=g1.distance(v['geo'])<.00001)for v in b.vias if v['net']=='GND'and region.distance(v['geo'])<.00001]
  pads=[dict(pad=q['id'],touches_In1=g1.distance(q['geo'])<.00001)for q in b.pads if q['net']=='GND'and str(q['raw'][2])=='thru_hole'and sub(q['raw'],'drill')and region.distance(q['geo'])<.00001]
  anchors.append(dict(area_mm2=region.area,bounds_Gerber_mm=list(region.bounds),via_anchors=vias,plated_pad_anchors=pads,has_anchor_to_continuous_In1=any(x['touches_In1']for x in vias+pads)))
 rows[L]['after_region_ground_anchors']=anchors
 # Diagnostic neck probe: report newly separated eroded regions, without
 # interpreting this as an exact global neck or current-capacity bound.
 splits=[]
 for radius in [.2,.225,.25]:
  for original in polys(al.buffer(-radius)):
   hits=[g for g in polys(bl.buffer(-radius))if g.intersection(original).area>.00001]
   if len(hits)>1:splits.append(dict(radius_mm=radius,before_eroded_area_mm2=original.area,before_bounds_Gerber_mm=list(original.bounds),after_pieces=[dict(area_mm2=g.area,bounds_Gerber_mm=list(g.bounds))for g in hits]))
 rows[L]['new_erosion_splits']=splits


out=dict(source_sha256=hashlib.sha256((D/'before.kicad_pcb').read_bytes()).hexdigest(),candidate_sha256=hashlib.sha256((D/'Trimix_Analyzer.kicad_pcb').read_bytes()).hexdigest(),layers=rows,notes=['Filled-zone geometry only; counts exclude copper traces, pads and barrels that can join islands.','A rectangle intersection or erosion can split a connected outside region; probe results are geometric diagnostics, not measured current capacity or a guaranteed minimum neck width.','All In1 and In2 outlines/settings are preserved; new via clearances affect both planes.','Candidate adapted to frozen HOST source; acceptance still requires parent review.'])
(D/'final-plane-audit.json').write_text(json.dumps(out,indent=2)+'\n')
for L,r in rows.items():print(L,'removed',r['removed_area_mm2'],'components before',r['before_component_areas_mm2'],'after',r['after_component_areas_mm2'],'localbefore',r['local_before_component_areas_mm2'],'localafter',r['local_after_component_areas_mm2'])
