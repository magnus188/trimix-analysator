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
    # The final routing checkpoint is separate from the historical diagnostic
    # below. Bind its native inputs and inspected outputs, without converting a
    # geometry pass into factory or physical qualification.
    final = BASE/'electrical/routing-candidate/final-cleanup'
    bundle = final/'frozen-bundle'
    geometry_path = bundle/'review/geometry-handoff-manifest.json'
    geometry = json.loads(geometry_path.read_text())
    for row in geometry['files']:
        bound('Final routed geometry '+row['path'],bundle/row['path'],row['sha256'])
    power_path = final/'root-review/final-power-ground-review.json'
    power = json.loads(power_path.read_text())
    bound('Final geometry handoff manifest',geometry_path,power['geometry_manifest_sha256'])
    bound('Final power path inventory',final/'root-review/current-paths/inventory.json',power['current_inventory_sha256'])
    bound('Final power/ground review script',final/'root-review/review_final.py',power['script_sha256'])
    bound('Final saved-ground reader',BASE/'electrical/routing-candidate/cap-signal-reconnect/pullup-swap/independent-ground/audit_ground.py',power['reader_sha256'])
    check('Final29 power paths and inspected ground comparison',
          power['power_witness_count']==29 and all(r['status']=='explicit_native_witness' for r in power['power_witnesses'])
          and power['visual_review'].get('status')=='PASSED_SCOPED_REVIEW',power['status'])
    for row in power['renders']:
        for ext in ('svg','png'):
            bound('Final ground/copper render '+row[ext],final/'root-review'/row[ext],row[ext+'_sha256'])
    erc = json.loads((final/'root-review/final-contract-erc-review.json').read_text())
    for row in erc['source_inputs_checked']:
        bound('Final ERC source '+row['name'],Path(row['path']),row['sha256'])
    for label in ('ERC_guard','DRC','contract'):
        bound('Final '+label+' receipt',ROOT/erc[label+'_path'],erc[label+'_sha256'])
    check('Final native rule and exact ERC disposition',
          erc['ERC_counts']==dict(raw_error_count=1,reviewed_exception_count=1,unexpected_violation_count=0,warnings=0)
          and erc['DRC_counts']==dict(violations=0,unconnected_items=0,schematic_parity=0),erc['status'])
    cam = json.loads((BASE/'electrical/main-final-independent/final-9f274fdf/verification-receipt.json').read_text())
    for row in cam['scripts']+cam['review_outputs']+cam['logs']:
        bound('Independent final CAM '+row['path'],ROOT/row['path'],row['sha256'])
    cam_manifest_path = bundle/'review/cam-input-manifest.json'
    bound('Final CAM owner manifest',cam_manifest_path,cam['owner_cam_manifest_sha256'])
    for row in json.loads(cam_manifest_path.read_text())['files']:
        bound('Final manufacturing input '+row['path'],bundle/row['path'],row['sha256'])
    check('Independent CAM review retains factory hold',
          cam['general_checks']==dict(passed=44,failed=0)
          and cam['assembly_ledger_checks']==dict(passed=20,failed=0)
          and cam['process_checks']==dict(passed=50,unfulfilled_external_factory_approval_holds=1,other_failures=0)
          and cam['order_release'] is False,cam['status'])
    promotion = json.loads((final/'canonical-promotion-manifest.json').read_text())
    for row in promotion['source_files']:
        bound('Promoted electrical source '+row['destination'],ROOT/row['destination'],row['sha256'])
    delivery_dir = BASE/'electrical/main-final'
    delivery = json.loads((delivery_dir/'delivery-manifest.json').read_text())
    for row in delivery['files']:
        bound('Main electrical delivery '+row['path'],delivery_dir/row['path'],row['sha256'])
    check('Canonical main source is reviewed geometry',
          digest(ROOT/'hardware/pcb/analyzer/Trimix_Analyzer.kicad_pcb')==geometry['source_board_sha256']
          ==cam['board_sha256']==promotion['source_board_sha256']==delivery['canonical_board_sha256'],
          geometry['source_board_sha256'])
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
