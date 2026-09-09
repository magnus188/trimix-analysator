"""Record completed visual inspection without rerunning slices or changing meshes."""
from pathlib import Path
import json,hashlib,datetime
D=Path(__file__).resolve().parent
sha=lambda p:hashlib.sha256(Path(p).read_bytes()).hexdigest()
rec=lambda p:dict(path=str(p),sha256=sha(p))
manifest=json.loads((D/'input-manifest.json').read_text());data=json.loads((D/'diagnostic-slice-review.json').read_text())
findings={
'TMX-A3-P01':'Front down, rear cavity up. Screen opening and side ports remain visible; housing walls and the four rear insert-boss annuli are retained. Supports beneath internal rails and lower ledges are reachable through the unassembled rear/screen openings. Broad front surface and tall walls still need warping, support-removal and insert-retention tests.',
'TMX-A3-P03':'Rear down. New carrier clearance windows and remaining webs have continuous deposited paths; the lowered coax bridge uses supports visible from the loose carrier sides. Remove those supports before fitting the PCB. The slice does not prove actual solder-tail clearance or residual-web strength.',
'TMX-A3-P06':'Floor down. The two bosses and backing ledges remain distinct. Blind insert pilots are open at the upper insertion region; interior gyroid below their designed blind floors is structural infill, not proof of a through-hole. Local bridge support is exposed before USB cartridge assembly. Physical pilot/insert fit and insertion-load testing remain pending.',
'TMX-A3-P07':'Floor down with lid opening upward. Four boss tops, chamber walls, lateral gas-route sections and roof closures are visible. External inlet underside and lid-open sensor pockets contain accessible supports; all three named gas-core exclusions contain zero generated support-bead conflicts. Passage cleanup, debris removal, leak rate and gas response remain physical checks; the selected images are not a full 3D porosity or flow proof.'}
assert len(data['parts'])==4 and len(data['results'])==8
visual=[]
for row in data['results']:
 assert row['digital_checks_pass'] and all(row['digital_checks'].values())
 arc=Path(row['slice']['archive']['file']);assert sha(arc)==row['slice']['archive']['sha256']
 folder=arc.parent/'inspection';ins=json.loads((folder/'inspection.json').read_text())
 row['visual_review']='Selected actual deposition-event contact sheet directly inspected'
 row['visual_review_scope']=findings[row['part_id']]
 ins['visual_review']=row['visual_review'];ins['visual_review_scope']=row['visual_review_scope']
 row['inspection']=ins;(folder/'inspection.json').write_text(json.dumps(ins,indent=2)+'\n')
 visual.append({'part_id':row['part_id'],'material':row['material'],'project':rec(arc),'contact_sheet':rec(folder/'layers.png'),'selected_events':ins['selected_visual_layers'],'finding':row['visual_review_scope'],'physical_status':'Not printed or measured'})
for row in manifest['parts']:assert sha(row['file'])==sha(row['original_file'])==row['sha256']
assert sha(manifest['owner_handoff']['path'])==manifest['owner_handoff']['sha256']
assert sha(manifest['owner_blocker_binding']['file'])==manifest['owner_blocker_binding']['sha256']
data['status']='EIGHT_SOURCE_BOUND_DIAGNOSTIC_SLICES_REVIEWED_PHYSICAL_VALIDATION_PENDING'
data['reviewed_at_utc']=datetime.datetime.now(datetime.timezone.utc).isoformat()
data['selected_visual_QA_complete']=True
data['checks']={'parts':4,'reviewed_material_projects':8,'intermediate_P07_no_support_templates':2,'digital_slice_checks_passed':sum(len(x['digital_checks'])for x in data['results']),'digital_slice_checks_failed':0,'all_source_meshes_unchanged':True,'all_selected_contact_sheets_inspected':True,'production_print_release':False,'physical_print_jobs_sent':False}
(D/'diagnostic-slice-review.json').write_text(json.dumps(data,indent=2)+'\n')
(D/'visual-review.json').write_text(json.dumps({'reviewed_at_utc':data['reviewed_at_utc'],'status':data['status'],'projects':visual,'additional_native_plate_previews_inspected':['pla/TMX-A3-P01_final_local_diagnostic/inspection/plate_1.png','pla/TMX-A3-P01_final_local_diagnostic/inspection/top_1.png','pla/TMX-A3-P03_final_local_diagnostic/inspection/plate_1.png','pla/TMX-A3-P06_final_local_diagnostic/inspection/plate_1.png','pla/TMX-A3-P06_final_local_diagnostic/inspection/top_1.png','pla/TMX-A3-P07_final_local_diagnostic/inspection/plate_1.png','pla/TMX-A3-P07_final_local_diagnostic/inspection/top_1.png'],'limits':'Selected layers visually inspected; all deposition events independently screened numerically. Physical support removal, strength, fit, leakage and temperature tests remain pending.'},indent=2)+'\n')
print(json.dumps(data['checks'],indent=2))
