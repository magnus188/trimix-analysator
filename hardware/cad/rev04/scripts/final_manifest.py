"""Host-side final artifact integrity and evidence manifest; no Fusion actions."""
from pathlib import Path
from datetime import datetime,timezone
import hashlib,json,zipfile

BASE=Path(__file__).resolve().parents[1]

def main():
    reports={}
    requirements={
      'model-audit.json':('status','cad_checks_passed'),
      'gas-clearance-paths.json':('pass',True),
      'selected-wall-fastener-checks.json':('status','selected_checks_passed'),
      'service-drivers.json':('status','clear_for_nominal_shafts'),
      'service-paths-cover-disconnect-battery-carrier-chamber-retainers-display-usb.json':('status','sampled_paths_clear_with_prerequisites'),
      'parameter-regeneration.json':('pass',True),
      'size-reduction-trials.json':('geometry_and_poses_restored',True),
      'step-roundtrip.json':('status','passed'),
    }
    for name,(key,value) in requirements.items():
        p=BASE/'verification'/name;data=json.loads(p.read_text())
        if data.get(key)!=value:raise RuntimeError(name+' has not passed its required gate')
        reports[name]={'sha256':hashlib.sha256(p.read_bytes()).hexdigest(),'gate':{key:value}}
    with zipfile.ZipFile(BASE/'Trimix_Enclosure_A3.f3d') as z:
        bad=z.testzip()
        if bad:raise RuntimeError('Native archive CRC failed: '+bad)
    paths=[BASE/n for n in ['Trimix_Enclosure_A3.f3d','Trimix_Enclosure_A3.step',
        'Trimix_Enclosure_A3_Review.pdf','PARTS.csv','README.md','MEASUREMENTS.md']]
    paths+=sorted((BASE/'views').glob('*.png'))
    artifacts={str(p.relative_to(BASE)):{'bytes':p.stat().st_size,'sha256':hashlib.sha256(p.read_bytes()).hexdigest()} for p in paths}
    state=json.loads((BASE/'verification/final-fusion-state.json').read_text())
    if not state['saved'] or state['modified'] or state['folder']!='Trimix analyzer':
        raise RuntimeError('Final native Fusion save/location is not confirmed')
    result={'completed_utc':datetime.now(timezone.utc).isoformat(),'status':'reviewed_fit_concept_delivered',
            'native_archive_crc_pass':True,'fusion':state,'artifacts':artifacts,'verification_reports':reports,
            'scope':'CAD and selected service checks only. Physical measurements, materials, seals, cable bends, gas response and routed PCB qualification remain open.'}
    (BASE/'verification/delivery-manifest.json').write_text(json.dumps(result,indent=2)+'\n')
    (BASE/'verification/current-qa-phase.json').write_text(json.dumps({'phase':'completed','time_utc':result['completed_utc']})+'\n')
    print(json.dumps({'status':result['status'],'artifact_count':len(artifacts),'folder':state['folder']}))

if __name__=='__main__':main()
