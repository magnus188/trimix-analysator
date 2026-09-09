#!/usr/bin/env python3
"""Capture frozen inputs, then bind separately executed SD/full-software checks.

No building, networking, flashing, formatting or publishing is performed here.
"""
import argparse
from datetime import datetime, timezone
import hashlib
import json
from pathlib import Path
import re
import shutil

ROOT = Path(__file__).resolve().parents[4]
OUT = Path(__file__).resolve().parent / 'evidence'

def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()

def inventory():
    files = set()
    for base in ['main', 'tests', 'simulator/src', 'simulator/mocks', 'simulator/stubs',
                 'simulator/tests', 'simulator/lv_conf', 'cmake', 'patches/esp_hosted']:
        for p in (ROOT / base).rglob('*'):
            if p.is_file() and not {'build', '__pycache__'} & set(p.parts) and p.suffix in {
                    '.cpp', '.c', '.h', '.py', '.cmake', '.patch', '.json', '.md'}:
                files.add(p)
    files.update(p for p in (ROOT / 'scripts').iterdir() if p.suffix in {'.py', '.sh'} and p.is_file())
    files.update(ROOT / p for p in ['CMakeLists.txt', 'main/CMakeLists.txt', 'main/Kconfig.projbuild', 'simulator/CMakeLists.txt', 'Makefile', 'dependencies.lock'])
    for pattern in ['sdkconfig.defaults*', 'partitions*.csv']:
        files.update(ROOT.glob(pattern))
    manifest = json.loads((ROOT / 'patches/esp_hosted/manifest.json').read_text())
    files.update(ROOT / 'managed_components/espressif__esp_hosted' / row['path'] for row in manifest['files'])
    return [{'path': str(p.relative_to(ROOT)), 'sha256': digest(p), 'bytes': p.stat().st_size} for p in sorted(files)]

def bound(path):
    return {'path': str(path.relative_to(ROOT)), 'sha256': digest(path), 'bytes': path.stat().st_size}

def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--capture', action='store_true')
    args = parser.parse_args()
    OUT.mkdir(exist_ok=True)
    if args.capture:
        snapshot = {'captured_utc': datetime.now(timezone.utc).isoformat(), 'inputs': inventory()}
        (OUT / 'source-before.json').write_text(json.dumps(snapshot, indent=2) + '\n')
        print('Captured', len(snapshot['inputs']), 'source/build/test inputs')
        return
    before = json.loads((OUT / 'source-before.json').read_text())
    assert before['inputs'] == inventory(), 'Source/build/test inputs changed; rerun affected checks after a fresh capture'
    captured = datetime.fromisoformat(before['captured_utc']).timestamp()
    names = ['host-tests.log', 'sanitizer-tests.log', 'repository-tests.log',
             'build-pre3.log', 'build-v3.log', 'static-analysis.log', 'sd-tsan.log', 'sd-maintenance-tsan.log']
    for name in names:
        assert (OUT / name).stat().st_mtime >= captured, 'Stale check: ' + name
    counts = {}
    for name in ['host', 'sanitizer']:
        value = (OUT / (name + '-tests.log')).read_text()
        match = re.search(r'100% tests passed, 0 tests failed out of (\d+)', value)
        assert match and int(match[1]) >= 53, name + ' full suite failed/incomplete'
        counts[name + '_ctest'] = int(match[1])
    repo = re.sub(r'\x1b\[[0-9;]*m', '', (OUT / 'repository-tests.log').read_text())
    assert re.search(r'Failed:\s+0', repo) and 'All tests passed.' in repo
    counts['repository_checks'] = int(re.search(r'Passed:\s+(\d+)', repo)[1])
    static = json.loads((OUT / 'static-analysis/results.json').read_text())
    assert static['status'] == 'passed digitally'
    counts['portable_static_units'] = len(static['results'])
    for name in ['sd-tsan.log', 'sd-maintenance-tsan.log']:
        text = (OUT / name).read_text()
        assert 'assertions passed' in text and 'WARNING: ThreadSanitizer' not in text
    builds = []
    for family in ['pre3', 'v3']:
        build = ROOT / ('build/esp32p4-' + family)
        log = (OUT / ('build-' + family + '.log')).read_text()
        assert 'Project build complete.' in log and not re.search(r'(^|\n).*error:', log)
        # A successful up-to-date incremental build can retain the binary mtime.
        # Bind its actual bytes, the unchanged inputs and the fresh build log.
        target = OUT / ('Trimix_analyzer_p4-' + family + '.bin')
        shutil.copy2(build / 'Trimix_analyzer.bin', target)
        preserved = OUT / ('build-' + family)
        preserved.mkdir(exist_ok=True)
        copies = {}
        for source in ['partition_table/partition-table.bin', 'Trimix_analyzer.map',
                       'sdkconfig', 'project_description.json', 'guition-hosted-sdmmc/patch-receipt.json']:
            saved = preserved / Path(source).name
            shutil.copy2(build / source, saved)
            copies[source] = bound(saved)
        size = json.loads((OUT / ('size-' + family + '.json')).read_text())
        builds.append({'family': family, 'application': bound(target),
                       'partition_table': copies['partition_table/partition-table.bin'],
                       'map': copies['Trimix_analyzer.map'], 'memory': size,
                       'generated_configuration': copies['sdkconfig'],
                       'build_description': copies['project_description.json'],
                       'warning_count': len(re.findall(r'warning:', log)),
                       'patched_hosted_inputs': copies['guition-hosted-sdmmc/patch-receipt.json']})
    artifacts = [bound(p) for p in sorted(OUT.rglob('*')) if p.is_file() and
                 not any(part.startswith('before-') for part in p.parts) and p.name != 'receipt.json']
    receipt = {'schema': 1, 'created_utc': datetime.now(timezone.utc).isoformat(),
               'status': 'passed digitally; physical card, power and radio qualification pending',
               'source_capture': bound(OUT / 'source-before.json'), 'source_inputs': before['inputs'],
               'verifier': bound(Path(__file__).resolve()), 'review': bound(OUT.parent / 'README.md'),
               'counts': counts, 'builds': builds, 'artifacts': artifacts,
               'boundaries': ['No device flashing, card mounting or physical testing occurred',
                              'Host SD queue/files/format and NVS/maintenance execute production cores',
                              'Coordinator fixture uses actual production C plus explicit IDF/RTOS hardware boundaries',
                              'Existing CO/power fixtures substitute the optional SD service boundary',
                              'Native ESP writer-task glue is compiled; actual RTOS/card behavior remains physical work',
                              'No calibration/OTA storage migration or battery qualification is introduced']}
    (OUT / 'receipt.json').write_text(json.dumps(receipt, indent=2) + '\n')
    print(json.dumps({'status': receipt['status'], 'counts': counts, 'source_inputs': len(before['inputs'])}, indent=2))

if __name__ == '__main__':
    main()
