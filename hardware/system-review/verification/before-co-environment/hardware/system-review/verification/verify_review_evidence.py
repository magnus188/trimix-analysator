#!/usr/bin/env python3
"""Check delivered evidence freshness without treating it as order approval."""
import csv
from datetime import datetime, timezone
import hashlib
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[3]
BASE = ROOT/'hardware/system-review'
ALLOWED = {'passed digitally','correction required','missing evidence','physical testing pending'}


def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def main():
    checks = []
    def check(label,ok,detail):
        checks.append({'check':label,'status':'passed digitally' if ok else 'correction required','detail':detail})
    def bound(label,path,expected):
        ok = path.is_file() and digest(path)==expected
        check(label,ok,{'path':str(path),'expected_sha256':expected,
                        'actual_sha256':digest(path) if path.is_file() else None})

    rows = list(csv.DictReader((BASE/'acceptance.csv').open()))
    check('Acceptance IDs and statuses',len({r['id'] for r in rows})==len(rows)
          and all(r['status'] in ALLOWED and r['blocks_prototype_order'] in ('yes','no') for r in rows),len(rows))
    for row in rows:
        path = BASE/row['evidence']
        check(row['id']+' evidence exists',path.exists(),str(path))
    sw = json.loads((BASE/'verification/software-final.json').read_text())
    for row in sw['sources'] + sw.get('firmware_inputs',[]):
        bound('Software source '+row['path'],ROOT/row['path'],row['sha256'])
    for row in sw['builds']:
        bound('Application '+row['family'],ROOT/row['application'],row['sha256'])
        bound('Build log '+row['family'],ROOT/row['build_log'],row['log_sha256'])
        check('Application fits '+row['family'],(ROOT/row['application']).stat().st_size<row['slot_bytes'],row['slot_bytes'])
    for row in sw['checks']:
        path = ROOT/row.get('log',row.get('receipt'))
        bound(row['name'],path,row['sha256'])
    capture = sw.get('input_capture', {})
    if capture:
        bound('Pre-verification input capture',ROOT/capture['path'],capture['sha256'])
    for row in sw.get('additional_checks', []):
        path = ROOT/row.get('receipt', row.get('source'))
        bound('Additional software evidence '+row['name'],path,row['sha256'])
    standby = json.loads((BASE/'software/power/input-isolation/evidence/receipt.json').read_text())
    check('Input-isolation and standby run completed on unchanged inputs',standby['status']=='passed'
          and standby['source_unchanged'] is True,standby['scope'])
    for path,expected in standby['source_sha256'].items():
        bound('Input-isolation/standby input '+path,ROOT/path,expected)
    for row in standby['checks']:
        bound('Input-isolation/standby command log '+row['name'],ROOT/row['log'],row['sha256'])
        check('Input-isolation/standby command exit '+row['name'],row['exit_code']==0,row['exit_code'])
    legacy=json.loads((BASE/'software/power/input-isolation/legacy-endurance-review/review.json').read_text())
    bound('Legacy correction current scoped receipt',ROOT/legacy['current_receipt'],legacy['current_receipt_sha256'])
    for row in legacy['sources']+legacy['evidence']:
        bound('Legacy correction source/evidence '+row['path'],ROOT/row['path'],row['sha256'])
    # The logical contract can become stale while native electrical work
    # continues even when no firmware source changes. Do not hide that case.
    contract = json.loads((BASE/'verification/system-contract.json').read_text())
    for row in contract['sources']:
        bound('Logical contract source '+row['path'],ROOT/row['path'],row['sha256'])
    # The active refinement has independent power/ground, native-rule and CAM
    # receipts. Historical9f outputs remain preserved, but are not substituted
    # for the current canonical board or its manufacturing delivery.
    final = BASE/'electrical/routing-candidate/sensitive-layout-refinement'
    bundle = final/'frozen-local-bundle'
    geometry_path = bundle/'review/geometry-handoff-manifest.json'
    geometry = json.loads(geometry_path.read_text())
    for row in geometry['files']:
        bound('Refined routed geometry '+row['path'],bundle/row['path'],row['sha256'])
    power_path = final/'root-final-review/root-power-layout-review.json'
    power = json.loads(power_path.read_text())
    for row in power['bound_sources']+power['visuals_inspected']:
        bound('Refined power/ground evidence '+row['path'],Path(row['path']),row['sha256'])
    check('Refined power paths and ground contacts',
          len(power['power_paths'])==29 and all(r['same_ordered_native_edges'] for r in power['power_paths'])
          and power['local_trace_path_count']==35
          and all(r['shorter'] for r in power['layout_comparisons'])
          and power['output_capacitor_ground_return']['barrel_transition_count']==0
          and all(r['retained_contacts_lost']==0 for r in power['ground_summary'].values())
          and power['order_release'] is False,power['status'])
    erc = json.loads((final/'root-final-review/root-contract-erc-review.json').read_text())
    for row in erc['source_inputs_checked']+erc['receipts']:
        bound('Refined electrical source/evidence '+row['path'],Path(row['path']),row['sha256'])
    bound('Refined ERC receipt checker',final/'root-final-review/review_contract_receipts.py',erc['checker_sha256'])
    check('Refined native rules and exact ERC disposition',
          erc['erc_counts']==dict(raw_error_count=1,reviewed_exception_count=1,unexpected_violation_count=0,warnings=0)
          and erc['native_drc']==dict(violations=0,unconnected_items=0,schematic_parity=0)
          and erc['electrical_assertions']==217 and erc['identity_assertions']==205
          and erc['erc_negative_controls']==21 and erc['electrical_negative_controls']==12
          and erc['identity_negative_controls']==4 and erc['routing_negative_controls']==3,erc['status'])
    cam = json.loads((BASE/'electrical/main-final-independent/final-0962ad86/verification-receipt.json').read_text())
    for row in cam['scripts']+cam['review_outputs']:
        bound('Independent refined CAM '+row['path'],ROOT/row['path'],row['sha256'])
    cam_manifest_path = bundle/'review/cam-input-manifest.json'
    bound('Refined CAM owner manifest',cam_manifest_path,cam['owner_cam_manifest']['sha256'])
    for row in json.loads(cam_manifest_path.read_text())['files']:
        bound('Refined manufacturing input '+row['path'],bundle/row['path'],row['sha256'])
    supplementary = json.loads((bundle/'review/supplementary-drawings-manifest.json').read_text())
    bound('Refined supplementary manifest',bundle/'review/supplementary-drawings-manifest.json',cam['supplementary_drawings_manifest']['sha256'])
    for row in supplementary['files']:
        bound('Refined supplementary drawing '+row['path'],bundle/row['path'],row['sha256'])
    check('Independent refined CAM retains factory hold',
          cam['general_checks']==dict(passed=44,failed=0)
          and cam['assembly_ledger_checks']==dict(passed=20,failed=0)
          and cam['refinement_preservation_checks']==dict(passed=12,failed=0)
          and cam['process_checks']==dict(passed=50,unfulfilled_external_factory_approval_holds=1,other_failures=0)
          and len(cam['visual_review']['inspected'])==23
          and len(cam['visual_review']['supplementary_inspected'])==5
          and cam['order_release'] is False,cam['status'])
    promotion = json.loads((final/'canonical-promotion-manifest.json').read_text())
    for row in promotion['source_files']:
        bound('Promoted refined source '+row['destination'],ROOT/row['destination'],row['sha256'])
    delivery_dir = BASE/'electrical/main-final'
    delivery = json.loads((delivery_dir/'delivery-manifest.json').read_text())
    for row in delivery['files']:
        bound('Main electrical delivery '+row['path'],delivery_dir/row['path'],row['sha256'])
    check('Canonical main source matches all active electrical reviews',
          digest(ROOT/'hardware/pcb/analyzer/Trimix_Analyzer.kicad_pcb')==geometry['board_sha256']
          ==cam['board_sha256']==promotion['source_board_sha256']==delivery['canonical_board_sha256']
          ==power['board_sha256']==erc['board_sha256'],geometry['board_sha256'])
    # This mechanical checkpoint proves exact-insert geometry preservation.
    # The later board/carrier integration has its own source-bound CAD reports.
    inserts_dir = BASE/'mechanical/exact-inserts-checkpoint'
    inserts = json.loads((inserts_dir/'root-archive-review.json').read_text())
    bound('Exact-insert native archive',Path(inserts['native_archive']),inserts['native_sha256'])
    for row in inserts['receipt_sources']:
        bound('Exact-insert receipt '+row['path'],inserts_dir/row['path'],row['sha256'])
    insert_inputs = json.loads((inserts_dir/'bound-inputs-map.json').read_text())
    for row in insert_inputs['files']:
        bound('Exact-insert saved input '+row['snapshot'],inserts_dir/row['snapshot'],row['sha256'])
    check('Exact-insert native checkpoint preserved',
          inserts['status']=='passed digitally' and inserts['zip_crc_failed_member'] is None
          and inserts['native_reopen_all_matches'] is True and inserts['order_release'] is False,
          dict(cloud_version=inserts['cloud_version'],source_files=inserts['bound_input_count']))
    slices = json.loads((BASE/'mechanical/verification/final-local-slices/verification-receipt.json').read_text())
    for row in slices['files']:
        bound('Final diagnostic slice evidence '+row['path'],ROOT/row['path'],row['sha256'])
    check('Final eight diagnostic slices retain physical limits',
          slices['checks']['digital_slice_checks_passed']==50
          and slices['checks']['digital_slice_checks_failed']==0
          and len(slices['results'])==8
          and all(all(r['digital_checks'].values()) for r in slices['results'])
          and slices['original_mesh_bytes_preserved'] is True
          and slices['production_print_release'] is False
          and slices['print_jobs_sent'] is False,slices['status'])
    # This is an explicitly historical routing diagnostic. Match its immutable
    # board snapshot and reader, not the evolving main board.
    path_review = BASE/'electrical/current-path-review'
    path_manifest = json.loads((path_review/'manifest.json').read_text())
    for path, expected in path_manifest.items():
        bound('Trace diagnostic artifact '+path,path_review/path,expected)
    paths = json.loads((path_review/'diagnostic/inventory.json').read_text())
    bound('Trace diagnostic immutable board',path_review/'diagnostic/source.kicad_pcb',paths['source_sha256'])
    bound('Trace diagnostic reader',path_review/'inventory.py',paths['reader_sha256'])
    packet = json.loads((BASE/'interface-packet.json').read_text())
    bound('Interface PDF',BASE/'interface-packet.pdf',packet['pdf_sha256'])
    for row in packet['sources']:
        bound('Interface packet source '+row['path'],BASE/row['path'],row['sha256'])
    render = packet.get('render_review', {})
    check('Six-page rendered review completed',render.get('status')=='passed digitally'
          and len(render.get('images', []))==packet['pages']==6,render.get('scope'))
    for row in render.get('images', []):
        bound('Inspected interface render '+row['path'],BASE/row['path'],row['sha256'])
    blockers = [r['id'] for r in rows if r['blocks_prototype_order']=='yes']
    result = {
        'generated_at_utc':datetime.now(timezone.utc).isoformat(),
        'checker_sha256':digest(Path(__file__)),
        'scope':'Listed software, logical-contract, final routed geometry/ground/contract/ERC, independent assembly CAM, immutable trace-diagnostic and interface-packet file integrity. CAD results remain in their source-bound subsystem reports.',
        'checks':checks,'passed':sum(r['status']=='passed digitally' for r in checks),
        'failed':sum(r['status']!='passed digitally' for r in checks),
        'prototype_order_status':'HOLD', 'ledger_blockers':blockers,
        'physical_tests_performed':False,
        'limitation':'A matching hash proves the referenced bytes match; it does not prove the engineering claim or qualify the manufacturing process.'
    }
    (BASE/'verification/evidence-integrity.json').write_text(json.dumps(result,indent=2)+'\n')
    print(f"Evidence integrity: {result['passed']} passed, {result['failed']} need refresh; order HOLD")
    for row in checks:
        if row['status']!='passed digitally':print(row['check'])
    return int(result['failed']!=0)


if __name__ == '__main__':
    raise SystemExit(main())
