#!/usr/bin/env python3
"""Verify the production CO gate and actual acquisition adapter at host boundaries."""
from pathlib import Path
from datetime import datetime, timezone
import hashlib
import json
import subprocess
import tempfile

HERE=Path(__file__).resolve().parent
ROOT=next(p for p in HERE.parents if (p/'main/sensors/sensor_hardware.cpp').is_file())
OUT=HERE/'evidence'
OUT.mkdir(exist_ok=True)
BUILD=Path(tempfile.mkdtemp(prefix='trimix-co-qualification-'))
SOURCES=['main/sensors/co_qualification.cpp','main/sensors/ze07_co.cpp','main/sensors/sensor_hardware.cpp',
 'main/sensors/acquisition_engine.cpp','main/sensors/ads122c04.cpp','main/services/ota_core.cpp',
 'tests/test_co_qualification.cpp','tests/test_co_hardware_worker.cpp','tests/third_party/cjson/cJSON.c',
 'main/main.cpp','main/services/system_power.cpp','main/services/analysis_history.cpp',
 'main/ui/screens/analyse/analyse_screen.cpp','main/ui/screens/history/history_screen.cpp',
 'main/CMakeLists.txt','simulator/CMakeLists.txt','scripts/run_tests.sh','scripts/verify_portable_analysis.py',
 str(Path(__file__).resolve().relative_to(ROOT))]
for folder in ('main','tests/co_worker_stubs','tests/power_worker_stubs','tests/backlight_stubs','simulator/stubs','tests/third_party/cjson'):
    SOURCES.extend(str(p.relative_to(ROOT)) for p in (ROOT/folder).rglob('*.h'))
def hashes():return {p:hashlib.sha256((ROOT/p).read_bytes()).hexdigest() for p in sorted(set(SOURCES))}
before=hashes();checks=[];status='failed'
def run(name,command):
    p=subprocess.run(command,cwd=ROOT,text=True,stdout=subprocess.PIPE,stderr=subprocess.STDOUT)
    log=OUT/(name+'.log');log.write_text(p.stdout)
    checks.append({'name':name,'command':list(map(str,command)),'exit_code':p.returncode,
                   'log':str(log.relative_to(ROOT)),'sha256':hashlib.sha256(log.read_bytes()).hexdigest()})
    if p.returncode:raise RuntimeError(p.stdout)
    print('PASS',name,flush=True)
try:
    for variant in ('normal','asan-ubsan'):
        build=BUILD/variant
        flags=[] if variant=='normal' else ['-DCMAKE_C_FLAGS=-fsanitize=address,undefined -fno-omit-frame-pointer',
            '-DCMAKE_CXX_FLAGS=-fsanitize=address,undefined -fno-omit-frame-pointer','-DCMAKE_EXE_LINKER_FLAGS=-fsanitize=address,undefined']
        run(variant+'-configure',['cmake','-S','simulator','-B',build,*flags])
        run(variant+'-build',['cmake','--build',build,'--target','test_co_qualification','test_co_hardware_worker','-j','4'])
        run(variant+'-tests',['ctest','--test-dir',build,'-R','^co_','-V'])
    if before!=hashes():raise RuntimeError('Source changed during CO checks')
    status='passed'
finally:
    receipt={'schema':1,'utc':datetime.now(timezone.utc).isoformat(),'scope':'Production CO environment gate and actual ESP acquisition worker; hardware/RTOS/calibration services are explicit boundaries',
     'status':status,'source_sha256':before,'source_unchanged':before==hashes(),'checks':checks,
     'physical_tests':False,'parent_builds':'Separate verification/software-final.json',
     'manufacturer_source':'https://www.winsen-sensor.com/d/files/manual/ze07-co.pdf','manufacturer_version':'1.7',
     'consumer_review':'Existing UI invalid CO branch sets --; averaging requires every CO sample valid; history stores NaN/false and renders --. No layout or persistence change.'}
    (OUT/'receipt.json').write_text(json.dumps(receipt,indent=2)+'\n')
