"""Offline source adapter/coverage for the frozen local PCB; no Fusion or board saves.
Run using KiCad bundled Python with PYTHONDONTWRITEBYTECODE=1.
Outputs only beside this script; source files and active manifests remain untouched.
"""
from pathlib import Path
import hashlib,json,re,sys,xml.etree.ElementTree as ET
from datetime import datetime,timezone
sys.dont_write_bytecode=True
OUT=Path(__file__).resolve().parent
BASE=OUT.parents[1];ROOT=BASE.parents[2]
BUNDLE=ROOT/'hardware/system-review/electrical/routing-candidate/sensitive-layout-refinement/frozen-local-bundle'
MANIFEST=BUNDLE/'review/geometry-handoff-manifest.json'
BOARD=BUNDLE/'hardware/pcb/analyzer/Trimix_Analyzer.kicad_pcb'
STEP=BUNDLE/'review/Trimix_Analyzer_Local_Refinement.step'
HEIGHT=BUNDLE/'review/component-height-contract.json'
XML=BUNDLE/'review/analyzer-netlist.xml'
EXPECTED_BOARD='0962ad86f9834ce71b6439d0f95db603753801153490e78f387a88521e582788'
EXPECTED_STEP='81eef0182d0d3bbaaf1a433cf43dce3e70f975c9ccd6d8d94bd196aa00c99014'
ACTIVE=BASE/'verification/incoming-boards.json'
OLD=ROOT/'hardware/system-review/electrical/placement-checkpoint-v2'
FINAL=ROOT/'hardware/system-review/electrical/routing-candidate/final-cleanup/frozen-bundle'


def sha(path):return hashlib.sha256(Path(path).read_bytes()).hexdigest()
def read(path):return json.loads(Path(path).read_bytes())
def require(test,message):
    if not test:raise RuntimeError(message)
def relative(path):return str(Path(path).resolve().relative_to(ROOT))
def write(name,data):
    with (OUT/name).open('x') as stream:stream.write(json.dumps(data,indent=2)+'\n')


def changed(a,b):
    if isinstance(a,(float,int)) and not isinstance(a,bool) and isinstance(b,(float,int)) and not isinstance(b,bool):return abs(a-b)>1e-6
    return a!=b


def delta(old,new,old_path,label,native_old,native_new):
    before={r['reference']:r for r in old['rows']};after={r['reference']:r for r in new['rows']}
    pose={'PCB_x_mm','PCB_y_mm','rotation_deg'};xy={'x_min_mm','x_max_mm','y_min_mm','y_max_mm','Fusion_x_min_mm','Fusion_x_max_mm','Fusion_y_min_mm','Fusion_y_max_mm'}
    height={'max_body_height_mm','assembly_allowance_mm','clearance_height_above_FCu_mm','Fusion_z_bottom_mm','Fusion_z_top_mm'}
    counts={k:[] for k in ('pose','side','MPN','DNP','XY_bounds','height_or_Z','metadata_only')};rows=[]
    for ref in sorted(before.keys()&after.keys()):
        a,b=before[ref],after[ref];fields={k:{'before':a.get(k),'after':b.get(k)} for k in a.keys()|b.keys() if changed(a.get(k),b.get(k))}
        if not fields:continue
        for category,keys in [('pose',pose),('side',{'side'}),('MPN',{'MPN'}),('DNP',{'DNP'}),('XY_bounds',xy),('height_or_Z',height)]:
            if fields.keys()&keys:counts[category].append(ref)
        if not fields.keys()&(pose|xy|height|{'side','MPN','DNP'}):counts['metadata_only'].append(ref)
        rows.append({'reference':ref,'changes':fields})
    native_changes=[]
    for ref in sorted(native_old.keys()&native_new.keys()):
        a,b=native_old[ref],native_new[ref];fields={k:{'before':a[k],'after':b[k]} for k in a if changed(a[k],b[k])}
        if fields:native_changes.append({'reference':ref,'changes':fields})
    return {'comparison':label,'before_contract':relative(old_path),'before_contract_sha256':sha(old_path),'after_contract':relative(HEIGHT),'after_contract_sha256':sha(HEIGHT),
        'before_board_sha256':old['board_sha256'],'after_board_sha256':new['board_sha256'],
        'before_contract_rows':len(before),'after_contract_rows':len(after),'added_contract_refs':sorted(after.keys()-before.keys()),'removed_contract_refs':sorted(before.keys()-after.keys()),
        'changed_common_contract_rows':len(rows),'change_counts':{k:len(v) for k,v in counts.items()},'change_references':counts,'rows':rows,
        'native_footprint_added_refs':sorted(native_new.keys()-native_old.keys()),'native_footprint_removed_refs':sorted(native_old.keys()-native_new.keys()),
        'native_component_changes':native_changes,'interpretation':'Counts distinguish native component identity/pose from height-contract metadata; this does not establish carrier or enclosure clearance.'}


def native_rows(path):
    import pcbnew as pcb
    board=pcb.LoadBoard(str(path));rows={}
    for fp in board.GetFootprints():
        ref=fp.GetReference();require(ref not in rows,'Duplicate board reference')
        rows[ref]={'UUID':fp.m_Uuid.AsString(),'side':'B.Cu' if fp.GetLayer()==pcb.B_Cu else 'F.Cu',
            'PCB_x_mm':pcb.ToMM(fp.GetPosition().x),'PCB_y_mm':pcb.ToMM(fp.GetPosition().y),'rotation_deg':fp.GetOrientationDegrees()%360,
            'DNP':bool(fp.IsDNP()),'MPN':fp.GetFieldsText().get('MPN',''),'value':fp.GetValue(),'footprint':str(fp.GetFPID().GetLibNickname())+':'+str(fp.GetFPID().GetLibItemName())}
    return board,rows


def main():
    require(not (OUT/'checkpoint.json').exists(),'Preserve existing scoped outputs; no overwrite')
    protected={relative(p):sha(p) for p in [ACTIVE,*sorted((BASE/'scripts').glob('*.py')),*sorted((BASE/'verification/final-route-inputs').glob('*'))] if p.is_file()}
    manifest=read(MANIFEST);require(len(manifest['files'])==9,'Expected nine owner handoff members')
    files={};verified=[]
    for row in manifest['files']:
        path=(BUNDLE/row['path']).resolve();require(path.is_relative_to(BUNDLE),'Manifest path escaped frozen bundle')
        require(path.stat().st_size==row['bytes'] and sha(path)==row['sha256'],'Owner member hash/size mismatch: '+row['path'])
        files[relative(path)]=row['sha256'];verified.append(dict(row,workspace_path=relative(path)))
    require(sha(BOARD)==manifest['board_sha256']==EXPECTED_BOARD and sha(STEP)==EXPECTED_STEP,'Frozen board/STEP identity changed')
    files[relative(MANIFEST)]=sha(MANIFEST)
    for directory in (BUNDLE/'hardware/pcb/analyzer',BUNDLE/'hardware/system-review/mechanical/components'):
        for path in sorted(directory.rglob('*')):
            if path.is_file():files[relative(path)]=sha(path)
    require(len([p for p in files if p.endswith('.kicad_pcb')])==1,'Adapter must contain only actual main PCB, not factory stencil variant')
    contract=read(HEIGHT);require(len(contract['rows'])==153 and contract['board_sha256']==EXPECTED_BOARD and contract['netlist_sha256']==sha(XML),'Height contract binding changed')
    checkpoint={'status':'DRAFT frozen local-refinement geometry input checkpoint for independent CAD review; canonical9f preserved; not imported or released',
        'source_manifest':relative(MANIFEST),'source_manifest_sha256':sha(MANIFEST),'source_board_sha256':EXPECTED_BOARD,
        'source_frame':contract['main_transform'],'files':dict(sorted(files.items())),
        'verified_owner_manifests':[{'path':relative(MANIFEST),'sha256':sha(MANIFEST),'listed_files_verified':9}],
        'additional_native_inputs':'Copied source tree is read only; adapter hashes native schematic/project/rules/library/model files alongside the nine owner handoff artifacts. Factory-stencil derivative is deliberately outside this one-board correspondence checkpoint.'}
    write('checkpoint.json',checkpoint)
    sys.path.insert(0,str(BASE/'scripts'))
    import placement_height_coverage
    coverage=placement_height_coverage.audit(OUT/'checkpoint.json',OUT/'height-coverage.json')
    require(coverage['status']=='source_coverage_and_pose_pass' and coverage['footprints']==169 and coverage['contract_rows']==153 and not coverage['errors'],'Native height coverage failed')
    native,latest=native_rows(BOARD)
    xml=ET.fromstring(XML.read_bytes());xmlrows={c.attrib['ref']:c for c in xml.findall('./components/comp')}
    errors=[];xml_proof=[]
    for row in contract['rows']:
        ref=row['reference'];component=xmlrows.get(ref)
        if component is None:errors.append(ref+' missing XML');continue
        fields={f.attrib['name']:f.text or '' for f in component.findall('./fields/field')}
        footprint=component.findtext('footprint','');mpn=fields.get('MPN','')
        dnp=any(p.attrib.get('name')=='dnp' for p in component.findall('property'))
        ok=mpn==row['MPN']==latest[ref]['MPN'] and footprint==latest[ref]['footprint'] and dnp==row['DNP']
        if not ok:errors.append(ref+' XML/native height identity mismatch')
        xml_proof.append({'reference':ref,'MPN':mpn,'footprint':footprint,'DNP':dnp,'pass':ok})
    require(not errors,'XML/native package identity mismatch: '+str(errors))
    extra_rows=[]
    for ref in sorted(xmlrows.keys()-{r['reference'] for r in contract['rows']}):
        c=xmlrows[ref];excluded=any(q.attrib.get('name')=='exclude_from_board' for q in c.findall('property'))
        kind='schematic_explicitly_excluded_from_main_board' if excluded else 'native_testpad_no_component_height' if ref.startswith('TP') else 'unclassified'
        require(kind!='unclassified','Unclassified extra XML component: '+ref)
        extra_rows.append({'reference':ref,'classification':kind,'value':c.findtext('value'),'footprint':c.findtext('footprint'),'exclude_from_board':excluded})
    write('xml-height-correspondence.json',{'status':'all153_height_rows_match_XML_and_native_MPN_footprint_DNP','XML_sha256':sha(XML),'board_sha256':EXPECTED_BOARD,'height_sha256':sha(HEIGHT),'rows':xml_proof,'errors':errors,
         'outside_contract_classification':extra_rows,'main_native_NPTH_refs_absent_from_XML':['H1','H2'],
         'XML_components':len(xmlrows),'XML_refs_outside_height_contract':sorted(xmlrows.keys()-{r['reference'] for r in contract['rows']})})
    oldcheckpoint=read(OLD/'checkpoint.json');oldboard=ROOT/next(k for k in oldcheckpoint['files'] if k.endswith('.kicad_pcb'))
    require(sha(oldboard)==oldcheckpoint['files'][relative(oldboard)],'Historical placement board changed')
    oldheight=OLD/'component-height-contract.json';finalheight=FINAL/'review/component-height-contract.json';finalboard=FINAL/'hardware/pcb/analyzer/Trimix_Analyzer.kicad_pcb'
    old=read(oldheight);final=read(finalheight)
    require(sha(finalboard)==final['board_sha256']=='9f274fdf198f1bcb871a4fc360e76693f8a5b048553e6a02998141737956514f','Historical canonical9f changed')
    _,v2rows=native_rows(oldboard);_,finalrows=native_rows(finalboard)
    deltas={'placement-v2':delta(old,contract,oldheight,'latest local versus placement-v2',v2rows,latest),'final-9f':delta(final,contract,finalheight,'latest local versus frozen final9f',finalrows,latest)}
    for label,data in deltas.items():write('pose-component-delta-vs-'+label+'.json',data)
    active=read(ACTIVE);draft=json.loads(json.dumps(active));draft['main']={
        'file':str(STEP),'sha256':EXPECTED_STEP,'height_contract_file':str(HEIGHT),'height_contract_sha256':sha(HEIGHT),'board_sha256':EXPECTED_BOARD,
        'status':'DRAFT_local_refinement_geometry_hash_bound_pending_native_STEP_datums_and_CAD_checks_not_adopted',
        'checkpoint_file':str(OUT/'checkpoint.json'),'checkpoint_sha256':sha(OUT/'checkpoint.json'),
        'coverage_file':str(OUT/'height-coverage.json'),'coverage_sha256':sha(OUT/'height-coverage.json'),
        'native_STEP_datum_measurement_pending':True}
    require(draft['usb']==active['usb'],'USB source manifest must remain exact')
    for f,h in (('file','sha256'),('height_contract_file','height_contract_sha256')):require(sha(active['usb'][f])==active['usb'][h],'Unchanged USB source file changed')
    write('incoming-boards.json',draft)
    text=BOARD.read_text();start=text.index('(stackup');end=text.index('(pad_to_mask_clearance',start)
    stack=text[start:end];layers=[]
    for match in re.finditer(r'\(layer "([^"]+)"\s+\(type "([^"]+)"\)\s*(?:\(thickness ([0-9.]+)\))?',stack):
        if match[3]:layers.append({'name':match[1],'type':match[2],'thickness_mm':float(match[3])})
    dielectrics=[r['thickness_mm'] for r in layers if r['name'].startswith('dielectric')];copper=[r['thickness_mm'] for r in layers if r['type']=='copper'];masks=[r['thickness_mm'] for r in layers if 'Solder Mask' in r['type']]
    require(len(dielectrics)==3 and len(copper)==4 and len(masks)==2,'Native stack source parse failed')
    stack_result={'layers':layers,'dielectric_sum_mm':sum(dielectrics),'copper_sum_mm':sum(copper),'copper_and_dielectric_sum_mm':sum(dielectrics+copper),
        'masks_sum_mm':sum(masks),'all_defined_layers_sum_mm':sum(dielectrics+copper+masks),'nominal_finished_mm':1.6,
        'interior_span_including_inner_copper_mm':sum(dielectrics)+sum(copper[1:-1]),'BRep_measured':False}
    rawstep=STEP.read_text(errors='strict')
    labels=re.findall(r"NEXT_ASSEMBLY_USAGE_OCCURRENCE\(\s*'[^']*'\s*,\s*'([^']*)'\s*,\s*''\s*,\s*#5\s*,\s*#\d+",rawstep,re.S)
    refs={r['reference'] for r in contract['rows'] if not r['DNP']};present=refs&set(labels)
    steplabels={'method':'Textual root assembly occurrence labels with parent product definition #5 only; not BRep classification or measured maximum geometry',
        'root_occurrence_label_count':len(labels),'anonymous_or_nonreference_labels':sorted(set(labels)-refs),'populated_named_references':sorted(present),'populated_refs_without_exact_root_ref_label':sorted(refs-present),
        'known_absent_models_from_owner_manifest':manifest['known_absent_models'],'native_STEP_model_identity_review_pending':True,
        'generic_STEP_not_maximum_proof':True}
    rows={r['reference']:r for r in contract['rows']};focus=[]
    for ref in ('C103','C107','R504'):
        r=rows[ref];focus.append({'reference':ref,'MPN':r['MPN'],'side':r['side'],'PCB_pose_mm_deg':[r['PCB_x_mm'],r['PCB_y_mm'],r['rotation_deg']],
            'maximum_body_height_mm':r['max_body_height_mm'],'assembly_allowance_mm':r['assembly_allowance_mm'],
            'W85_world_bounds_mm':[[r['Fusion_x_min_mm'],r['Fusion_y_min_mm'],r['Fusion_z_bottom_mm']],[r['Fusion_x_max_mm'],r['Fusion_y_max_mm'],r['Fusion_z_top_mm']]],
            'dynamic_registration':'X=PcbX+PCB_x; Y=PcbY+PcbHeight-PCB_y; backside allocation anchored to PcbZ=20.5 at current depth; purchased geometry remains rigid.',
            'source':r['source'],'carrier_interference_or_relief_verified':False})
    unchanged=all(sha(ROOT/p)==h for p,h in files.items()) and all(sha(ROOT/p)==h for p,h in protected.items())
    require(unchanged,'Frozen source or protected input changed during preflight')
    preflight={'status':'PASS_OFFLINE_SOURCE_ADAPTER_COVERAGE_ONLY_NATIVE_CAD_PENDING','generated_at_utc':datetime.now(timezone.utc).isoformat(),
        'source_manifest':relative(MANIFEST),'source_manifest_sha256':sha(MANIFEST),'owner_nine_members_verified':verified,
        'producer_script':relative(Path(__file__)),'producer_script_sha256':sha(__file__),
        'checkpoint_sha256':sha(OUT/'checkpoint.json'),'draft_incoming_sha256':sha(OUT/'incoming-boards.json'),'height_coverage_sha256':sha(OUT/'height-coverage.json'),
        'coverage':{k:coverage[k] for k in ('footprints','contract_rows','classification_counts','backside_populated_references','errors')},
        'all153_height_rows_mandatory_checked':True,'native_and_XML_MPN_footprint_DNP_correspondence':True,
        'DNP_references':[r['reference'] for r in contract['rows'] if r['DNP']],
        'exclusions':[r for r in coverage['rows'] if r['classification'] in ('testpad_no_component_height','mechanical_NPTH_no_component_height','DNP_excluded')],
        'source_stack_arithmetic_mm':stack_result,'registration_expectation':{'current_parametric_main_expressions':['PcbX','PcbY+PcbHeight','PcbZ+0.0529 mm'],
            'PcbX_expression':'CaseWidth-PcbWidth-4.6','PcbWidth_mm':30,'height_contract_W85_frame':contract['main_transform'],
            'nominal_backseat_FCu_mm':[20.5,22.1],'live_STEP_datum_measurement_pending':True,'measured_STEP_datums_mm':None,
            'no_automatic_scale_or_datum_correction':True},
        'focused_new_backside_components':focus,'STEP_occurrence_identity':steplabels,
        'comparison_summaries':{k:{f:v[f] for f in ('before_board_sha256','after_board_sha256','added_contract_refs','removed_contract_refs','change_counts','change_references')} for k,v in deltas.items()},
        'protected_inputs_sha256':protected,'all_source_and_protected_files_unchanged':unchanged,'active_incoming_manifest_unchanged':draft['usb']==active['usb'] and sha(ACTIVE)==protected[relative(ACTIVE)],
        'Fusion_calls':0,'board_saved_or_modified':False,'limits':['Source coverage and arithmetic only. All153 contract rows are checked; DNP rows remain explicitly excluded from populated geometry.',
            'Known absent/generic STEP bodies never remove a populated maximum envelope requirement.',
            'Rear C103/C107/R504 need new native carrier and service checks; no prior clearance is inherited.',
            'Measured native STEP datums, rigid joint/descendants, full153-row dynamic maxima, native body/pose conservation and both width endpoints remain parent work.',
            'Active placement-v2 manifest and prepared historical9f inputs are preserved; local candidate is isolated and not an order release.']}
    write('preflight.json',preflight)
    print(json.dumps({'status':preflight['status'],'outputs':str(OUT),'coverage':preflight['coverage'],'hashes':{name:sha(OUT/name) for name in ['checkpoint.json','incoming-boards.json','height-coverage.json','preflight.json']}},indent=2))

if __name__=='__main__':main()
