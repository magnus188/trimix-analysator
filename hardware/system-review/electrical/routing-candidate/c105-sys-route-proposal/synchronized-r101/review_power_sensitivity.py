"""Read-only native copper-path resistance sensitivities; never an ampacity claim."""
from pathlib import Path
import importlib.util,json,hashlib,itertools,csv,math
D=Path(__file__).resolve().parent;P=D/'complete-candidate/Trimix_Analyzer.kicad_pcb';H='de594d8ef4db9489931fe091ba63d938a0d4a33f1bb0455e988433c3fefa95db';O=D/'power-review';O.mkdir(exist_ok=True)
M=D.parents[2]/'current-path-review/inventory.py'
spec=importlib.util.spec_from_file_location('review_inventory',M);m=importlib.util.module_from_spec(spec);spec.loader.exec_module(m)
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest();assert sha(P)==H
s=m.stackup(P.read_text());b=m.p.LoadBoard(str(P));g=m.NativeGraph(b,s);pairs=[]
for target in ['U101.15','U101.16','U201.10','U201.11']:
 for a,z in itertools.product(g.pad_index['C105.1'],g.pad_index[target]):
  r=g.witness(a,z);assert r['status']=='explicit_native_witness',(target,r);pairs.append({'source':'C105.1','target':target,'source_pad_uuid':a,'target_pad_uuid':z,**r})
case_rows=[]
for pair in pairs:
 for T,pl,h,geom in itertools.product([20,60,85],[20,25],[1.44,1.6,1.76],['native_nominal','width_minus_25um_copper_80pct']):
  case={'temperature_C':T,'finished_height_mm':h,'plating_um':pl,'geometry_case':geom};R=sum(m.estimate_edge(e,s,case)for e in pair['ordered_edges']);case_rows.append({'source':pair['source'],'target':pair['target'],**case,'full_item_path_ohm':R,'mV_per_A':R*1000,'mW_per_A_squared':R*1000})
delta=json.loads((D/'candidate-delta.json').read_text());sysrows=[r for r in delta['added_items']if r['net']=='VSYS'];assert len(sysrows)==11and all(r['type']=='segment'and r['width_mm']==.4and r['layer']=='In2.Cu'for r in sysrows)
length=sum(math.dist(r['start'],r['end'])for r in sysrows);newR=m.RHO20*length/(.4*s['copper_thickness_mm']['In2.Cu'])
barrels=[]
for pair in pairs:
 for e in pair['ordered_edges']:
  if e['kind']!='barrel':continue
  if any(x['uuid']==e['uuid']and x['from_layer']==e['from_layer']and x['to_layer']==e['to_layer']for x in barrels):continue
  meta=g.items[e['uuid']];barrels.append({**e,'at_mm':meta.get('at_mm'),'diameter_mm':meta.get('diameter_mm'),'sensitivities':[{'plating_um':pl,'finished_height_mm':h,'ohm_20C':m.estimate_edge(e,s,{'temperature_C':20,'plating_um':pl,'finished_height_mm':h,'geometry_case':'native_nominal'})}for pl,h in itertools.product([20,25],[1.44,1.6,1.76])]})
out={'status':'RESISTANCE_DIAGNOSTIC_NOT_CURRENT_OR_THERMAL_RATING','source_sha256':H,'source_board':str(P.resolve()),'source_delta_sha256':sha(D/'candidate-delta.json'),'stackup':s,'constants':{'rho20_ohm_mm':m.RHO20,'alpha20_per_C':m.ALPHA20,'source_url':m.NIST_URL,'source_pdf_page':46,'source_printed_page':40},'shared_native_reader_sha256':sha(M),'new_SYS_route':{'native_item_count':11,'layer':'In2.Cu','width_mm':.4,'full_item_length_mm':length,'copper_thickness_mm':s['copper_thickness_mm']['In2.Cu'],'rho20_nominal_item_sum_ohm':newR,'new_power_vias':0,'track_uuids':[r['uuid']for r in sysrows]},'pairs':pairs,'existing_barrels_in_witnesses':barrels,'limitations':['These are explicit, zone-free paths from KiCad direct physical adjacency; same-net name alone never forms a junction.','Path weights use complete native trace-item lengths; unused tails and pad-overlap portions are not clipped. A shortest full-item witness is not equivalent resistance or a mathematical bound on it.','NewSYSrouteitemresistance excludes source/target pads, solder, existing connecting copper and barrel transitions; the separate fullpath witnesses include explicit existing barrels.','20/25 micrometre plating, 1.44/1.60/1.76 mm finished thickness, temperatures and reduced copper/width cases are unqualified sensitivity assumptions, not measured/ordered fabrication values.','No current sharing, skin/proximity effect, contacts, package internals, thermal rise, impedance/EMC, load or board current rating is calculated.','Four new vias belong to CE/CHG controlsignals only; SYS adds no new power via.'],'release':False}
(O/'review.json').write_text(json.dumps(out,indent=2)+'\n')
with(O/'sensitivities.csv').open('w',newline='')as f:w=csv.DictWriter(f,fieldnames=list(case_rows[0]));w.writeheader();w.writerows(case_rows)
assert sha(P)==H
print(json.dumps({'newSYS':out['new_SYS_route'],'pairs':[{'target':q['target'],'mohm20C':q['full_item_estimate_ohm_20C_25um_1p6mm']*1000,'layers':q['layer_summary'],'barreltransitions':q['barrel_transition_count']}for q in pairs]},indent=2))
