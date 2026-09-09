import concurrent.futures, hashlib, json, pathlib, subprocess, time
root=pathlib.Path.cwd(); out=root/'hardware/system-review/software/ota/final-verification'; work=pathlib.Path('/tmp/trimix-ota-final'); work.mkdir(exist_ok=True)
base=['c++','-std=c++17','-Wall','-Wextra','-Werror','-pthread','-I','main','-I','simulator/stubs']
tests={
 'ota-asan':(['tests/test_ota_storage.cpp','main/services/ota_core.cpp','main/services/blob_journal.cpp','main/services/storage_service.cpp','main/services/maintenance_service.cpp'],['-I','tests/third_party/cjson',str(work/'cJSON-asan.o')]),
 'storage-maintenance-asan':(['tests/test_storage_maintenance_race.cpp','main/services/storage_service.cpp','main/services/blob_journal.cpp','main/services/maintenance_service.cpp'],[]),
 'storage-maintenance-tsan':(['tests/test_storage_maintenance_race.cpp','main/services/storage_service.cpp','main/services/blob_journal.cpp','main/services/maintenance_service.cpp'],[]),
 'calibration-asan':(['tests/test_gas_acquisition.cpp','main/sensors/ads122c04.cpp','main/sensors/ze07_co.cpp','main/services/gas_calibration_core.cpp','main/services/gas_calibration_journal.cpp'],[]),
 'oxygen-selection-asan':(['tests/test_oxygen_selection.cpp','main/services/oxygen_selection_core.cpp'],[]),
 'history-asan':(['tests/test_analysis_history.cpp','main/services/analysis_history.cpp'],['-DTRIMIX_SIMULATOR=1']),
 'cylinder-asan':(['tests/test_cylinder_profiles.cpp','main/services/cylinder_profiles.cpp','main/services/mix_label_service.cpp','main/analysis/analysis_calculator.cpp','main/services/analysis_history.cpp'],['-DTRIMIX_SIMULATOR=1']),
}
paths=sorted({p for sources,_ in tests.values() for p in sources} | {'tests/third_party/cjson/cJSON.c','tests/third_party/cjson/cJSON.h','main/hardware_contract.h'} | {str(p) for directory in ('main/services','main/sensors','main/analysis','simulator/stubs') for p in pathlib.Path(directory).glob('*.h')})
hashall=lambda:{p:hashlib.sha256((root/p).read_bytes()).hexdigest() for p in paths}
before=hashall()
c=['cc','-std=c11','-Wall','-Wextra','-Werror','-Wno-deprecated-declarations','-fsanitize=address,undefined','-I','tests/third_party/cjson','-c','tests/third_party/cjson/cJSON.c','-o',str(work/'cJSON-asan.o')]
vendor=subprocess.run(c,capture_output=True,text=True); (out/'vendor-build.log').write_text(vendor.stdout+vendor.stderr)
assert vendor.returncode==0

def run(item):
 name,(sources,args)=item; cmd=base+['-fsanitize=thread' if name.endswith('tsan') else '-fsanitize=address,undefined']+args+sources+['-o',str(work/name)]
 t=time.monotonic(); comp=subprocess.run(cmd,capture_output=True,text=True); log=comp.stdout+comp.stderr
 result={'compile_command':cmd,'compile_exit':comp.returncode}
 if comp.returncode==0:
  test=subprocess.run([str(work/name)],capture_output=True,text=True,timeout=90); log+=test.stdout+test.stderr; result['run_exit']=test.returncode
 result['duration_seconds']=round(time.monotonic()-t,3)
 (out/(name+'.log')).write_text(log)
 return name,result
with concurrent.futures.ThreadPoolExecutor(max_workers=2) as ex: results=dict(ex.map(run,tests.items()))
release=subprocess.run(['python3','tests/test_release_validation.py'],capture_output=True,text=True); (out/'release-validation.log').write_text(release.stdout+release.stderr)
results['release-validator']={'run_exit':release.returncode}
receipt={'timestamp_utc':time.strftime('%Y-%m-%dT%H:%M:%SZ',time.gmtime()),'results':results,'source_sha256_before':before,'source_sha256_after':hashall(),'sources_unchanged':before==hashall(),'scope':'Production source compiled on host with sanitizers; ESP flash/network adapters excluded. Root is still editing USB/power integration.'}
(out/'host-verification.json').write_text(json.dumps(receipt,indent=2)+'\n')
for name,r in results.items(): print(name,r.get('compile_exit',0),r.get('run_exit','not run'))
print('source hashes unchanged:',receipt['sources_unchanged'])
