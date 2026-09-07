#!/usr/bin/env python3
"""Reopen every delivered project with Bambu and verify archive integrity."""
import csv,hashlib,json,re,zipfile
from pathlib import Path
import xml.etree.ElementTree as ET
from print_pipeline import PRINT,dump,sha,run_cli
from print_inspect import parse_gcode
from print_sections import inspect_sections

def geometry_signature(layers):
    digest=hashlib.sha256()
    for layer in layers:
        digest.update(f'{layer["z"]:.5f}\n'.encode())
        for a,b,w,role in layer['segments']:
            digest.update((','.join(f'{v:.4f}' for v in [*a,*b,w])+'|'+role+'\n').encode())
    return digest.hexdigest()

def finalize():
    part_manifest=json.loads((PRINT/'slice-manifest.json').read_text())
    coupon_manifest=json.loads((PRINT/'coupons/slice-manifest.json').read_text())
    if part_manifest['failures'] or coupon_manifest['failures']:raise RuntimeError('Unresolved slice failures')
    entries=[dict(r,kind='part',item=r['part_id']) for r in part_manifest['parts']]
    entries+=[dict(r,kind='coupon',item=r['coupon']) for r in coupon_manifest['coupons']]
    if len(entries)!=38:raise RuntimeError('Expected 22 part + 16 coupon projects')
    results=[]
    for row in sorted(entries,key=lambda x:(x['kind'],x['item'],x['material'])):
        p=Path(row['project']);print('Reopen '+row['item']+' '+row['material'],flush=True)
        cli=run_cli(['--info',p],p.parent/'reopen.log',60)
        if cli['exit_code']!=0:raise RuntimeError('Bambu could not reopen '+str(p))
        output=Path(cli['log']).read_text()
        if 'manifold = yes' not in output:raise RuntimeError('Bambu mesh manifold check failed '+str(p))
        with zipfile.ZipFile(p) as z:
            if z.testzip() is not None:raise RuntimeError('Corrupt ZIP '+str(p))
            code=z.read('Metadata/plate_1.gcode');expected=z.read('Metadata/plate_1.gcode.md5').decode().strip().lower()
            actual=hashlib.md5(code).hexdigest()
            if actual not in expected:raise RuntimeError('G-code checksum mismatch '+str(p))
            settings=json.loads(z.read('Metadata/project_settings.config'))
            if settings['printer_model']!='Bambu Lab H2D' or float(settings['layer_height'])!=.2:
                raise RuntimeError('Wrong printer/layer profile')
            if any(float(x)!=.4 for x in settings['nozzle_diameter']):raise RuntimeError('Wrong nozzle diameter')
            if settings['filament_type']!=[row['material'].upper()]:raise RuntimeError('Wrong material type')
            cfg=ET.fromstring(z.read('Metadata/model_settings.config'))
            if sum(p.get('subtype')=='normal_part' for p in cfg.iter('part'))!=1:raise RuntimeError('Expected one normal model part')
            info=ET.fromstring(z.read('Metadata/slice_info.config'))
            values={m.get('key'):m.get('value') for m in info.iter('metadata')}
        layers,unhandled=parse_gcode(code.decode())
        if unhandled:raise RuntimeError('Unparsed deposited arc')
        inspection=json.loads((p.parent/'inspection/inspection.json').read_text())
        if inspection['sha256']!=sha(p):raise RuntimeError('Inspection is stale '+str(p))
        if inspection['support_conflicts_with_exclusion_volumes'] or inspection['island_candidate_layers']:
            raise RuntimeError('Unresolved support or island candidate '+str(p))
        if row['kind']=='part':
            section_file=p.parent/'inspection/model-boundary-sections.json'
            if not section_file.exists() or json.loads(section_file.read_text()).get('sha256')!=sha(p):
                inspect_sections(p)
        results.append({'kind':row['kind'],'item':row['item'],'material':row['material'],'project':str(p),'sha256':sha(p),
          'bambu_reopened':True,'manifold':True,'zip_crc_pass':True,'gcode_md5_pass':True,
          'layer_events':len(layers),'toolpath_geometry_signature':geometry_signature(layers),
          'predicted_seconds':int(values.get('prediction',0)),'predicted_weight_g':float(values.get('weight',0)),
          'support_segments':inspection['generated_support_segments'],'gas_core_conflicts':0,
          'physical_status':'not printed / not measured'})
    paired=[]
    for item in sorted({r['item'] for r in results}):
        pair=[r for r in results if r['item']==item]
        paired.append({'item':item,'PLA_PETG_deposition_geometry_identical':pair[0]['toolpath_geometry_signature']==pair[1]['toolpath_geometry_signature']})
    aliases=[]
    for coupon,part in [('C06_usb_m2_frame','TMX-A3-P06'),('C07_usb_bezel','TMX-A3-P09'),('C08_ao2_thread','TMX-A3-P11')]:
        for material in ('pla','petg'):
            a=next(r for r in results if r['item']==coupon and r['material']==material)
            b=next(r for r in results if r['item']==part and r['material']==material)
            aliases.append({'coupon':coupon,'part':part,'material':material,'deposition_geometry_identical':a['toolpath_geometry_signature']==b['toolpath_geometry_signature']})
    result={'status':'All 38 projects reopened in installed Bambu Studio and pass archive/toolpath integrity checks',
      'projects':results,'material_geometry_pairs':paired,'complete_part_coupon_pairs':aliases,
      'note':'Geometric identity compares every deposited model/support segment, role, line width and Z event rounded to 0.0001 mm. It excludes temperature, speed, E volume and custom machine G-code. Identical geometry does not imply identical physical material behaviour.',
      'known_cli_messages':'Bambu reports absent machine_full/process_full system files on reopen in isolated data; complete project settings are embedded and verified. No filament-colour preference was loaded.',
      'physical_print_jobs_sent':False}
    dump(PRINT/'archive-reopen-verification.json',result)
    with (PRINT/'project-index.csv').open('w',newline='') as f:
        fields=['kind','item','material','project','layer_events','predicted_seconds','predicted_weight_g','support_segments','physical_status']
        w=csv.DictWriter(f,fieldnames=fields);w.writeheader();w.writerows({k:r[k] for k in fields} for r in results)
    print(json.dumps({'projects':len(results),'nonidentical_material_geometry':[p for p in paired if not p['PLA_PETG_deposition_geometry_identical']],
                      'nonidentical_full_coupon_geometry':[p for p in aliases if not p['deposition_geometry_identical']]}),flush=True)

if __name__=='__main__':finalize()
