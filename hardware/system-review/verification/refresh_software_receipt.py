#!/usr/bin/env python3
"""Capture inputs before verification, then bind successful checks to those bytes.

Never builds, flashes or publishes. Use --capture after implementation is frozen,
run the documented builds/checks, then run without arguments. Refuses a changed
input set, stale/failing logs, missing binaries or a shrinking test inventory.
"""
import argparse
from datetime import datetime, timezone
import hashlib
import json
from pathlib import Path
import re
import shutil

ROOT = Path(__file__).resolve().parents[3]
OUT = ROOT / 'hardware/system-review/verification'
WITNESS = OUT / 'integration-inputs-before.json'
BASELINE = OUT / 'integration-previous-receipt.json'


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def inventory(previous):
    paths = {r['path'] for r in previous['sources']}
    controls = {r['path'] for r in previous['firmware_inputs'] if not r['path'].startswith('main/')}
    for base in ('main', 'tests', 'simulator/mocks', 'simulator/stubs', 'simulator/tests'):
        paths.update(str(p.relative_to(ROOT)) for p in (ROOT/base).rglob('*')
                     if p.is_file() and p.suffix in {'.c','.cpp','.h','.hpp','.py'})
    paths.update(controls)
    return [{'path':p, 'sha256':sha(ROOT/p)} for p in sorted(paths)]


def capture():
    previous = json.loads((OUT/'software-final.json').read_text())
    rows = inventory(previous)
    controls = {r['path'] for r in previous['firmware_inputs'] if not r['path'].startswith('main/')}
    witness = {'captured_at_utc':datetime.now(timezone.utc).isoformat(), 'sources':rows,
               'firmware_inputs':[r for r in rows if r['path'].startswith('main/') or r['path'] in controls]}
    BASELINE.write_text(json.dumps(previous,indent=2)+'\n')
    WITNESS.write_text(json.dumps(witness,indent=2)+'\n')
    print(f"Captured {len(rows)} review inputs / {len(witness['firmware_inputs'])} firmware inputs before verification")


def main():
    previous = json.loads(BASELINE.read_text())
    before = json.loads(WITNESS.read_text())
    assert inventory(previous) == before['sources'], 'Inputs changed or appeared during verification; capture and rerun affected checks'
    captured = datetime.fromisoformat(before['captured_at_utc']).timestamp()
    for row in previous['builds']:
        family = row['family']
        build = ROOT/'build'/('esp32p4-'+family)
        log = ROOT/row['build_log']
        assert log.stat().st_mtime >= captured and 'Project build complete.' in log.read_text(), f'Build log not fresh/successful: {family}'
        source = build/'Trimix_analyzer.bin'
        target = ROOT/row['application']
        assert source.stat().st_size < row['slot_bytes']
        shutil.copy2(source,target)
        row.update(bytes=target.stat().st_size,sha256=sha(target),
                   remaining_bytes=row['slot_bytes']-target.stat().st_size,
                   log_sha256=sha(log),
                   compiler_warning_count=len(re.findall(r'\bwarning:',log.read_text())),
                   partition_table_sha256=sha(build/'partition_table/partition-table.bin'))
    for row in previous['checks']:
        path = ROOT/row.get('log',row.get('receipt'))
        assert path.stat().st_mtime >= captured, f'Stale check output: {path}'
        if 'CTest' in row['name']:
            match = re.search(r'100% tests passed, 0 tests failed out of (\d+)',path.read_text())
            assert match and int(match[1]) >= row['count'], f'CTest failed or inventory shrank: {path}'
            row['count'] = int(match[1])
        elif row['name'] == 'Repository checks':
            plain = re.sub(r'\x1b\[[0-9;]*m','',path.read_text())
            count = re.search(r'Passed:\s+(\d+)',plain)
            assert count and int(count[1]) >= row['count'] and re.search(r'Failed:\s+0\b',plain)
            row['count'] = int(count[1])
        elif row['name'] == 'Firmware/schematic logical contract':
            result = json.loads(path.read_text())
            assert result['failed'] == 0 and result['passed'] >= row['count']
            row['count'] = result['passed']
        elif row['name'] == 'Clang static analyzer':
            result = json.loads(path.read_text())
            assert result['status'] == 'passed digitally'
            # Its own receipt carries exact per-unit coverage and source hashes.
            assert len(result['results']) >= row['count'], 'Static-analysis inventory shrank'
            row['count'] = len(result['results'])
        row['sha256'] = sha(path)
    for row in previous['ui_review']['images']:
        assert sha(ROOT/row['path']) == row['sha256'], 'Previously inspected image changed'
    previous['generated_at_utc'] = datetime.now(timezone.utc).isoformat()
    previous['sources'] = before['sources']
    previous['firmware_inputs'] = before['firmware_inputs']
    previous['firmware_input_count'] = len(before['firmware_inputs'])
    previous['input_capture'] = {'path':str(WITNESS.relative_to(ROOT)), 'sha256':sha(WITNESS)}
    previous['checkpoint'] = 'Verified CO environment qualification plus charger input-isolation and charge-standby integration; production commissioning profile remains charge inhibited. Final hardware/CAD integration tracked separately.'
    previous['ui_review']['scope'] = 'Earlier inspected UI rendering retained. Standby backlight/service behaviour is covered separately by production-service tests; these images are not physical display evidence.'
    previous['limitations'] = [note for note in previous.get('limitations', [])
                               if 'warning' not in note.lower()]
    previous['limitations'].append('These are complete application artifacts from incremental ESP-IDF builds; current log warning counts are recorded per build. Earlier compilation of lvgl_port.cpp emitted seven vendor TE-disabled aggregate-initializer warnings: omitted members are zero initialized and gpio_num is explicitly -1. No warning suppression or vendor-source change was made. Physical display timing remains untested.')
    previous['additional_checks'] = [
        {'name':'CO environment qualification and optional-sensor startup',
         'receipt':'hardware/system-review/software/co-environment/evidence/receipt.json',
         'sha256':sha(ROOT/'hardware/system-review/software/co-environment/evidence/receipt.json'),
         'scope':'Portable gate and actual ESP acquisition worker tested with explicit UART/I2C/RTOS/calibration boundaries; range, freshness, fault clearing and missing optional hardware acceptance. No physical CO or safety-use qualification.'},
        {'name':'Charger input isolation, charging standby, actual power worker and backlight',
         'receipt':'hardware/system-review/software/power/input-isolation/evidence/receipt.json',
         'sha256':sha(ROOT/'hardware/system-review/software/power/input-isolation/evidence/receipt.json'),
         'scope':'460 reported assertions under ASan/UBSan; four maintenance races and concurrent backlight workload under TSan; seven prior standby, seven input-isolation and six legacy-attachment scenarios plus three attachment-race boundaries, including six virtual hours each DCP/CDP. Production profile remains inhibited; physical boundaries are stubbed.'},
        {'name':'USB latch feedback policy', 'receipt':'hardware/system-review/software/power/usb-latch-feedback-review.json',
         'sha256':sha(ROOT/'hardware/system-review/software/power/usb-latch-feedback-review.json')},
        {'name':'Header and netlist corruption tests', 'header_mutations':8,'feedback_disconnect_mutations':5,
         'source':'tests/test_system_review_tools.py','sha256':sha(ROOT/'tests/test_system_review_tools.py')},
        {'name':'Release image descriptors and slot sizes', 'receipt':'hardware/system-review/software/ota/release-artifact-manifest.json',
         'sha256':sha(ROOT/'hardware/system-review/software/ota/release-artifact-manifest.json')},
        {'name':'Legacy DCP/CDP attachment endurance correction',
         'receipt':'hardware/system-review/software/power/input-isolation/legacy-endurance-review/review.json',
         'sha256':sha(ROOT/'hardware/system-review/software/power/input-isolation/legacy-endurance-review/review.json')}
    ]
    (OUT/'software-final.json').write_text(json.dumps(previous,indent=2)+'\n')
    print(f"Bound {len(before['firmware_inputs'])} unchanged firmware inputs, both applications and completed checks")


if __name__ == '__main__':
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--capture',action='store_true')
    args=parser.parse_args()
    capture() if args.capture else main()
