#!/usr/bin/env python3
"""Source-bound diagnostics only. No printer communication or native geometry editing."""
from pathlib import Path
import sys,json,argparse,datetime
import numpy as np
WORK=Path(__file__).resolve().parent
ROOT=WORK.parents[4]
SCRIPTS=ROOT/'hardware/cad/rev04/3d-print/scripts'
sys.path.insert(0,str(SCRIPTS))
import print_pipeline as pipeline
import print_inspect
pipeline.ROOT=WORK
pipeline.PRINT=WORK
ORIENTATIONS={'front_down':pipeline.IDENTITY,'rear_down':pipeline.REAR_DOWN}
ALLOWED={'TMX-A3-P01','TMX-A3-P03','TMX-A3-P06','TMX-A3-P07'}

def source_record(path):
 p=Path(path);return dict(path=str(p),sha256=pipeline.sha(p))

def slice_checked(source,material,mode,name):
 # slice_one regenerates installed presets. Bind and compare the bytes actually
 # present immediately before and after its regeneration/CLI call.
 pipeline.make_profiles()
 paths=[*sorted((WORK/'profiles').glob('*.json')),pipeline.APP]
 before=[source_record(p)for p in paths]
 sliced=pipeline.slice_one(source,material,mode,name)
 after=[source_record(p)for p in paths]
 if before!=after:raise RuntimeError('Installed slicer or generated profiles changed during slicing')
 sliced['actual_profiles_and_slicer']=after
 return sliced

def prepare():
 pipeline.make_profiles()
 profiles=WORK/'profiles'
 provenance=json.loads((profiles/'provenance.json').read_text())
 machine=json.loads((profiles/'h2d_04.json').read_text())
 process=json.loads((profiles/'accessible_supports.json').read_text())
 assert machine['printer_model']=='Bambu Lab H2D'
 assert all(float(v)==.4 for v in machine['nozzle_diameter'])
 assert float(process['layer_height'])==.2 and float(process['initial_layer_print_height'])==.2
 tools=[Path(__file__),SCRIPTS/'print_pipeline.py',SCRIPTS/'print_inspect.py',pipeline.APP]
 result={'status':'prepared_awaiting_final_native_STLs','runtime':sys.version,'scripts_and_slicer':[source_record(p)for p in tools],
 'profiles':[source_record(p)for p in sorted(profiles.glob('*.json'))],
 'profile_basis':provenance['basis'],'inputs_verified':all(pipeline.sha(q['path'])==q['sha256']for v in provenance['sources'].values()for q in v),
 'allowed_changed_parts':sorted(ALLOWED),'orientation_policy':{'TMX-A3-P01':'front_down','TMX-A3-P03':'rear_down','TMX-A3-P06':'front_down','TMX-A3-P07':'front_down'},
 'gas_support_policy':'P07 requires native-owner-confirmed current support blocker bounds before slicing.',
 'output_role':'Local diagnostics; no production print release','physical_print_jobs_sent':False}
 pipeline.dump(WORK/'prepared-workflow.json',result)
 print(json.dumps({'status':result['status'],'profiles_verified':result['inputs_verified']}),flush=True)

def run(manifest_path,selected):
 manifest_path=manifest_path.resolve();manifest=json.loads(manifest_path.read_text());manifest_sha=pipeline.sha(manifest_path)
 assert manifest['units']=='mm' and manifest['scale']==1
 rows=manifest['parts'];ids=[r['part_id']for r in rows]
 assert len(ids)==len(set(ids)) and set(ids)<=ALLOWED
 if selected:assert set(selected)<=set(ids)
 rows=[r for r in rows if not selected or r['part_id']in selected]
 output=WORK/'diagnostic-slice-review.json'
 result=json.loads(output.read_text())if output.exists()else{'results':[],'parts':[]}
 def write():pipeline.dump(output,result)
 result.update({'generated_at_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'status':'running','native_manifest':source_record(manifest_path),'physical_print_jobs_sent':False,'production_print_release':False,'limits':['PLA dry-fit and PETG target-material diagnostics only.','Topology and volume checks are not a mathematical self-intersection proof.','All-layer island screening is the inherited 0.25 mm raster heuristic with 0.5 mm prior-deposit window; not bridge strength or full unsupported-area proof.','Selected images require explicit human/model visual review, not an automatic pass.','Physical support removal, insert retention, sealing, module fit and thermal behaviour remain pending.']})
 write()
 for row in rows:
  pid=row['part_id'];source=Path(row['file']).resolve()
  assert pid in ALLOWED and pipeline.sha(source)==row['sha256']
  name=row['orientation'];matrix=ORIENTATIONS[name]
  assert name=={'TMX-A3-P03':'rear_down'}.get(pid,'front_down')
  dest=WORK/'oriented-stl'/(pid+'_'+name+'.stl')
  oriented=pipeline.orient(source,dest,matrix);mesh=oriented['before'];tri=pipeline.read_stl(source)
  connected=pipeline.component_count(tri)
  assert connected==1
  assert not any(mesh[k]for k in ['boundary_edges','nonmanifold_edges','degenerate_triangles'])
  error=max(abs(a-b)for ar,br in zip(row['native_bounds_mm'],mesh['bounds_mm'])for a,b in zip(ar,br))
  volume=row['native_volume_mm3'];assert volume>0
  relative=abs(mesh['signed_volume_mm3']-volume)/volume
  assert error<=.02 and relative<=.001
  record={'part_id':pid,'orientation':oriented,'connected_mesh_components':connected,'native_bounds_error_mm':error,'native_volume_relative_error':relative,'source_unchanged':True}
  result['parts']=[r for r in result['parts']if r['part_id']!=pid]+[record]
  write()
  for material in ['pla','petg']:
   assert pipeline.sha(source)==row['sha256'] and pipeline.sha(manifest_path)==manifest_sha
   assert pipeline.sha(dest)==oriented['oriented_sha256']
   name=pid+'_final_local_diagnostic';slicing_input=dest
   if pid=='TMX-A3-P07':
    assert row.get('blockers_confirmed_current_native')is True
    blockers=row['support_blockers'];assert len(blockers)>=3
    baseline=slice_checked(dest,material,'no_supports',pid+'_no_support_baseline')
    slicing_input=pipeline.compound_3mf(dest,WORK/'prepared-projects'/(name+'_'+material+'_protected.3mf'),blockers,
      oriented['rotation_rows'],oriented['translation_mm'],baseline['archive']['file'])
   sliced=slice_checked(slicing_input,material,'accessible_supports',name)
   assert sliced['archive']['zip_test_error']is None
   inspected=print_inspect.inspect(sliced['archive']['file'])
   settings=inspected['settings']
   checks={'zero_slicer_warnings':not inspected['slicer_warnings'],'zero_raster_island_candidates':not inspected['island_candidate_layers'],'all_extruding_moves_parsed':not inspected['unhandled_extruding_moves'],'no_support_exclusion_conflicts':not inspected['support_conflicts_with_exclusion_volumes'],'declared_layer_count_matches':inspected['layer_count']==inspected['declared_layer_count'],'correct_nozzle_layer_material':all(float(v)==.4 for v in settings['nozzle_diameter'])and float(settings['layer_height'])==.2 and settings['filament_type']==[material.upper()]}
   if pid=='TMX-A3-P07':checks['all_chamber_blockers_retained']=len(inspected['support_blockers_in_archive'])==len(row['support_blockers'])
   rr={'part_id':pid,'material':material,'slice':sliced,'inspection':inspected,'digital_checks':checks,'digital_checks_pass':all(checks.values()),'visual_review':'pending'}
   result['results']=[r for r in result['results']if(r['part_id'],r['material'])!=(pid,material)]+[rr]
   result['status']='selected_visual_QA_pending'if all(r['digital_checks_pass']for r in result['results'])else'digital_review_required'
   write();print(json.dumps({'part':pid,'material':material,'layers':inspected['layer_count'],'checks':checks,'images':str(Path(sliced['archive']['file']).parent/'inspection/layers.png')}),flush=True)
  assert pipeline.sha(source)==row['sha256'] and pipeline.sha(manifest_path)==manifest_sha
 result['source_unchanged_after_slicing']=True;write()

if __name__=='__main__':
 ap=argparse.ArgumentParser();ap.add_argument('--prepare',action='store_true');ap.add_argument('--manifest',type=Path);ap.add_argument('--part',action='append');a=ap.parse_args()
 if a.prepare:prepare()
 if a.manifest:run(a.manifest,a.part)
 if not(a.prepare or a.manifest):ap.error('Pass --prepare or --manifest')
