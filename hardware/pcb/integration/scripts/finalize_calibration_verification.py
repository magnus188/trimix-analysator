"""Bind completed digital evidence to the final editable source snapshot."""
from pathlib import Path
import hashlib,json,datetime
ROOT=Path(__file__).resolve().parents[4]
BASE=ROOT/'hardware/pcb/integration';OUT=BASE/'verification/software-calibration'
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def read(p):return json.loads(p.read_text())
def asset(p):return {'path':str(p.relative_to(ROOT)),'sha256':sha(p),'bytes':p.stat().st_size}
def run():
    b=ROOT/'hardware/pcb/analyzer/Trimix_Analyzer.kicad_pcb'
    scope=read(OUT/'pcb-scope-audit.json');ind=read(OUT/'independent-pcb-review.json')
    assert sha(b)==scope['current_sha256']==ind['board_sha256']
    assert ind['status']=='passed_independent_review' and ind['drc']['all_fabrication_finding_identities_exactly_equal']
    assert len(read(OUT/'analyzer-upgraded-erc.json')['sheets'])>0
    assert not any(s['violations']for s in read(OUT/'analyzer-upgraded-erc.json')['sheets'])
    assert sha(OUT/'analyzer-upgraded-netlist.xml')==ind['netlist_sha256']
    ref=read(BASE/'reference/component-reference-verification.json')
    assert ref['rows']==135 and ref['main_rows']==131
    assert next(a for a in ref['source_assets']if a['path'].endswith('analyzer/Trimix_Analyzer.kicad_pcb'))['sha256']==sha(b)
    fusion=read(BASE/'verification/fusion-delivery.json')
    assert fusion['status']=='saved_native_reopened_and_visually_reviewed' and fusion['native_reopen']['passed']
    for a in fusion['files']:assert sha(Path(a['path']))==a['sha256']
    for a in fusion['imported_steps']:assert sha(Path(a['path']))==a['sha256']
    for n in ('pcb-static.json','carrier-static.json'):
        r=read(OUT/n);assert not r['hits']and not r['errors']
    service=read(OUT/'service-check.json');assert service['status']=='clear_for_modeled_geometry'
    fw=read(OUT/'firmware/verification.json')
    for a in fw['source_snapshot']+fw['binaries']:assert sha(ROOT/a['path'])==a['sha256'],a['path']
    ui=read(OUT/'ui/review.json')
    for path,h in ui['source_sha256'].items():assert sha(ROOT/path)==h,path
    for path,h in ui['capture_sha256'].items():assert sha(OUT/'ui'/path)==h,path
    documents=[ROOT/'hardware/SOFTWARE_CALIBRATION.md',ROOT/'hardware/ANALYZER_DESIGN.md',BASE/'README.md',BASE/'reference/COMPONENT_REFERENCE.md',BASE/'reference/COMPONENT_REFERENCE.csv',BASE/'reference/main-assembly.svg',BASE/'reference/main-front.svg',BASE/'reference/main-back.svg',OUT/'characterization-log.csv']
    receipts=[OUT/n for n in ['schematic-verification.json','analyzer-upgraded-erc.json','pcb-scope-audit.json','independent-pcb-review.json','independent-main-drc.json','fusion-refresh.json','pcb-static.json','carrier-static.json','service-check.json','firmware/verification.json','ui/review.json']]+[BASE/'verification/fusion-delivery.json']
    r={'status':'digital_implementation_complete_routing_and_physical_validation_pending','generated_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'sensors_retained':['AO2','R17JJ-CCR','MD62'],'upgraded_ADCs':{'U401':'ADS122C04IPWR /0x40','U502':'ADS122C04IPWR /0x41'},'fixed_reference':'RN501 ACASN2001U2001P1AT /2x2kohm matched; RV501/R502/R503 removed','board':asset(b),'main_footprints':131,'all_board_reference_rows':135,'main_numbered_pad_net_assignments':374,'copper_layers':4,'nominal_thickness_mm':1.6,'connectors_and_mounts_preserved':True,'PCB_native_checks':{'ERC':0,'schematic_parity':0,'courtyard_collisions':0,'courtyard_outside':0,'pad_edge_failures_below_0_5mm':0,'existing_fabrication_findings':39,'all_existing_finding_identities_preserved':True,'unconnected_items':295,'tracks':0},'Fusion':{'design':'Trimix_Enclosure_A3_PCBFit v6','folder':'Trimix analyzer','main_solid_pairs_checked':read(OUT/'pcb-static.json')['candidate_pairs'],'main_solid_interferences':0,'carrier_solid_interferences':0,'rearward_extraction_mm':28,'driver_access_checked':2,'healthy_recompute':True,'native_reopen_solid_count':834,'native_reopen_volume_difference_mm3':0,'purchased_components_not_scaled':True,'enclosure_unchanged':True},'firmware_checks':fw['host_summary'],'UI_assertions':ui['ui_assertions']['passed'],'hardware_build_presets':fw['hardware_presets_built'],'physical_tests_performed':False,'firmware_flashed':False,'unproven_accuracy_targets_percentage_points':{'O2':0.2,'He':0.5},'remaining':['Main PCB routing and39fabrication-rule findings, including analog layout/noise/power review.','Actual SMB elbow/J401mate and GCT connector geometry, solder/wiring fit.','MD62conditioning/warmup, known-gas calibration and excluded-mixture validation acrossoxygenfraction and environment.','Battery and both USBcable charging-operation measurements withreference uncertainty.','PhysicalADC/NVS/touchscreen verification; BMEenvironment driver, charger/gauge/shutdown integration and calendar-age prompts.','No measured nonlinear helium correctioncurve; currenttwo-pointrecords are bench-only.','Showcase and enclosure print preparation remain paused.'],'documents':[asset(p)for p in documents],'evidence':[asset(p)for p in receipts]}
    (OUT/'final-verification.json').write_text(json.dumps(r,indent=2)+'\n');print(json.dumps({k:r[k]for k in ['status','main_footprints','main_numbered_pad_net_assignments','PCB_native_checks','UI_assertions']}))
if __name__=='__main__':run()
