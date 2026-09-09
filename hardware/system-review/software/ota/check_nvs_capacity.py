"""Build a synthetic FULL persistence image with ESP-IDF's generator, never flash it.
Payload contents are dummy bytes: this checks space, not semantic record validity.
"""
import csv, json, pathlib, subprocess, sys, tempfile
out = pathlib.Path(__file__).resolve().parent
python = pathlib.Path.home()/'.espressif/python_env/idf5.5_py3.13_env/bin/python'
with tempfile.TemporaryDirectory(prefix='trimix-nvs-') as temporary:
    work = pathlib.Path(temporary)
    rows = [['key','type','encoding','value']]
    def ns(name): rows.append([name,'namespace','',''])
    def blob(key,size): rows.append([key,'data','hex2bin','00'*size])
    def scalar(key,value=0): rows.append([key,'data','u8',str(value)])
    # Preserve both old history versions, old profile/settings/Wi-Fi, and full current journals.
    ns('analysis_hist'); blob('records',1840); scalar('count',20); blob('records_v2',2080); scalar('count_v2',20)
    ns('settings');
    for index in range(12): rows.append([f'k{index}','data','i32','100'])
    ns('cyl_profiles'); blob('profiles',432); scalar('selected')
    ns('wifi_creds'); rows.extend([['ssid','data','string','S'*32],['password','data','string','P'*64]])
    for name,size in [('hist_v3',2324),('settings_v3',44),('cyl_v2',436),('wifi_v2',98),('o2_hw_cfg',64)]:
        ns(name); blob('a',size+16); blob('b',size+16); blob('active',1)
    ns('gas_hw_v1')
    for channel in range(3):
        blob(f'c{channel}_0',368); blob(f'c{channel}_1',368); scalar(f'c{channel}_sel')
    csvpath=work/'capacity.csv'
    with csvpath.open('w') as f: csv.writer(f).writerows(rows)
    command=[str(python),'-m','esp_idf_nvs_partition_gen','generate',str(csvpath),str(work/'nvs.bin'),'0x6000']
    result=subprocess.run(command,capture_output=True,text=True)
    if result.returncode: raise SystemExit(result.stdout+result.stderr)
    image=(work/'nvs.bin').read_bytes()
    pages=[]
    for offset in range(0,len(image),4096):
        bitmap=int.from_bytes(image[offset+32:offset+64],'little')
        states=[(bitmap>>(index*2))&3 for index in range(126)]
        pages.append({'page':offset//4096,'written_entries':states.count(2),'free_or_erased_entries':states.count(3)+states.count(0)})
    free=sum(page['free_or_erased_entries'] for page in pages)
    # Mirrors the largest storage_write_blob capacity check; include transaction header.
    needed=(2324+47)//32+128
    report={'result':'pass' if free>=needed else 'fail','partition_bytes':len(image),'written_entries':sum(p['written_entries'] for p in pages),
            'free_entries':free,'largest_write_guard_entries':needed,'margin_after_guard':free-needed,'pages':pages,
            'assumptions':'Full current journals plus both legacy histories retained; O2 selection allowance64B; payload ABI sizes captured by host size probe. Synthetic image only, not valid calibration data.',
            'physical_nvs_test':'pending'}
    (out/'nvs-capacity.json').write_text(json.dumps(report,indent=2)+'\n')
    print(json.dumps(report,indent=2))
    if report['result']!='pass': raise SystemExit(1)
