"""Offline rollup of completed native width receipts; never controls Fusion."""
from pathlib import Path
import hashlib
import json
from datetime import datetime,timezone

BASE=Path(__file__).resolve().parents[1]
ROOT=BASE/'verification/width-contract-tests'


def main():
    summaries=[]
    for value in (85,85.5,86,86.5,87):
        directory=ROOT/('W'+str(value).replace('.','_'))
        path=directory/'trial-summary.json'
        if not path.exists():
            summaries.append({'width_mm':value,'status':'not_completed'})
            continue
        result=json.loads(path.read_text());trial=result['trial'];rest=result['restoration']
        if trial is None:
            summaries.append({'width_mm':value,'status':'trial_failed_before_summary',
                              'restoration':rest,'receipt':str(path)})
            continue
        inputs=json.loads((directory/'final-integrated-clearance.json').read_text())
        allocation_tests=inputs['tests']+json.loads((directory/'minimum-thickness-allocations.json').read_text())['tests']
        restored=(rest['compute_success'] and rest['all_parameter_expressions_restored']
                  and rest['all_physical_geometry_restored']['pass'] and rest['timeline_unchanged']
                  and rest['other_documents_preserved'] and rest['health']['pass'])
        summaries.append({
            'width_mm':value,'core_width_contract_pass':trial['core_width_contract_pass'],
            'restoration_pass':restored,'physical_cross_assembly_collisions':inputs['actual_cross_assembly']['collisions'],
            'allocation_failures':[{'test':t['name'],'collisions':t['collisions']} for t in allocation_tests if t['collision_count']],
            'service_scope':trial.get('service_scope','Full sampled removal, driver and thickness checks'),
            'path_status':trial['path_status'],'driver_status':trial['driver_status'],
            'fastener_thickness_status':trial['fastener_thickness_status'],
            'source_main_STEP_sha256':inputs['source_manifest']['main']['sha256'],
            'receipt':str(path),'receipt_sha256':hashlib.sha256(path.read_bytes()).hexdigest()})
    staged=[]
    for label in ('retainer-path-diagnosis-W85','retainer-path-diagnosis'):
        path=ROOT/label/'diagnosis.json'
        if not path.exists():
            staged.append({'status':'not_completed','file':str(path)})
            continue
        a=json.loads(path.read_text());selected=[t for t in a['diagnosis']['tests'] if 'X-1.5mm' in t['name']]
        r=a['restoration'];passed=(len(selected)==1 and not selected[0]['collision_count'] and r['compute']
            and r['physical']['pass'] and r['parameters_restored'] and r['timeline_preserved']
            and r['protected_documents_preserved'] and r['health']['pass'])
        staged.append({'width_mm':a['diagnosis']['width_mm'],'pass':passed,'file':str(path),'sha256':hashlib.sha256(path.read_bytes()).hexdigest()})
    core_pass=all(s.get('core_width_contract_pass') and s.get('restoration_pass') and not s.get('physical_cross_assembly_collisions') for s in summaries)
    data={'status':'width_datum_static_samples_passed_with_service_sequence_and_existing_fit_limits' if core_pass and all(s.get('pass')for s in staged) else 'checks_incomplete_or_need_review',
          'generated_at_utc':datetime.now(timezone.utc).isoformat(),'trials':summaries,
          'all_five_core_static_and_restoration_checks_pass':core_pass,
          'adopted_upper_retainer_endpoint_proofs':staged,
          'adopted_upper_retainer_sequence':'Remove upper retainer screw; keep lower retainer and screen installed; lift rigid upper clip+Z6mm, shift-X1.5mm, then withdraw rearward. Chamber/feedthrough stays installed. Check was sampled at<=0.25mm intervals, not continuous sweep or hand-access qualification.',
          'original_W87_straight_path_failure_retained':True,
          'scope':'Full sampled service at85/87mm endpoints; intermediate static/maxima/axis/material/rigid-body checks. Each native trial restores its85mm baseline.',
          'existing_limit':'1.95mm upper pilot ligament remains unchanged and below selected2mm target.',
          'existing_mated_fit_conflict':'Placement-v2 R301 intersects the provisional J301 mated envelope by0.2135625mm3; this is retained at every width. Overall installed fit is not accepted.',
          'final_routed_PCB_integrated':False,'manufacturing_release':False}
    output=BASE/'verification/width-contract-validation-disposition.json'
    output.write_text(json.dumps(data,indent=2)+'\n')
    print(json.dumps({'output':str(output),'trials':len(summaries)},indent=2))


if __name__=='__main__':main()
