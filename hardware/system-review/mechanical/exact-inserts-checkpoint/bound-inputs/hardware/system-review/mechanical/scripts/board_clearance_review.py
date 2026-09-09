"""Overlay supplied maximum-body contracts using transient Fusion BRep boxes.

The immutable contract, imported STEP hash and PCB datum must match the staged
manifest. These boxes supplement generic/missing STEP components. They are not
purchased CAD, persistent physical parts, solder geometry or mated cable models.
"""
from datetime import datetime, timezone
from pathlib import Path
import hashlib
import json
import zipfile
import adsk.core as core
import adsk.fusion as fusion
from runtime import owned, configure, BASE, report, other_documents


def _inputs():
    manifest = json.loads((BASE/'verification/incoming-boards.json').read_text())
    spec = manifest['main']
    path = Path(spec['height_contract_file'])
    digest = hashlib.sha256(path.read_bytes()).hexdigest()
    if digest != spec['height_contract_sha256']:
        raise RuntimeError('Height-contract source hash changed')
    contract = json.loads(path.read_text())
    if contract['board_sha256'] != spec['board_sha256']:
        raise RuntimeError('PCB/height-contract hash mismatch')
    _, _, d = owned()
    matches = [o for o in d.rootComponent.occurrences if o.component.partNumber == 'TMX-A3-B01']
    if len(matches) != 1:
        raise RuntimeError('Expected one main PCB wrapper')
    wrapper = matches[0]
    installed = wrapper.component.attributes.itemByName('TrimixSystemReview', 'source_step_sha256')
    if not installed or installed.value != spec['sha256']:
        raise RuntimeError('Height contract does not match installed staged STEP')
    origin = wrapper.transform2.translation
    if max(abs(a-b) for a,b in zip((origin.x*10,origin.y*10,origin.z*10),(50.4,120,20.545))) > 1e-5:
        raise RuntimeError('Contract is for baseline PCB datum only; no arbitrary resizing')
    return spec, contract


def _envelopes(manager, contract):
    """Create independent transient world-coordinate boxes in Fusion cm."""
    import verification_a3 as v
    result = []
    for row in contract['rows']:
        if row['DNP']:
            continue
        low = [row['Fusion_x_min_mm'], row['Fusion_y_min_mm'], row['Fusion_z_bottom_mm']]
        high = [row['Fusion_x_max_mm'], row['Fusion_y_max_mm'], row['Fusion_z_top_mm']]
        lengths = [(b-a)/10 for a,b in zip(low,high)]
        if min(lengths) <= 0:
            raise RuntimeError('Nonpositive envelope: '+row['reference'])
        center = core.Point3D.create(*[(a+b)/20 for a,b in zip(low,high)])
        box = core.OrientedBoundingBox3D.create(center, core.Vector3D.create(1,0,0),
                                               core.Vector3D.create(0,1,0), *lengths)
        body = manager.createBox(box)
        if not body or not body.isTransient or not body.isSolid:
            raise RuntimeError('No transient envelope solid: '+row['reference'])
        record = {'uid': ('MAX_MAIN_'+row['reference'],0), 'body': body,
                  'name': row['reference']+' maximum/allocation envelope',
                  'component': 'REFERENCE main PCB maximum-body contracts',
                  'occurrence': 'MAX_MAIN/'+row['reference'], 'physical_group': 'pcb',
                  'service_role': None, 'battery_role': None, 'hardware': None,
                  'screw_axis': None, 'head_seat_mm': None, 'contract': row}
        v._record_bounds(record)
        result.append(record)
    return result


def _coax_tolerance(manager, contract):
    """Independent-extremes drawing tolerance bound; not a supplier-rated max."""
    source = next(r for r in contract['rows'] if r['reference'] == 'J402')
    cx = 50.4 + source['PCB_x_mm']
    cy = 120 - source['PCB_y_mm']
    plane = source['Fusion_z_bottom_mm']
    rows = []
    def add(ref, x0,y0,z0,x1,y1,z1,basis):
        row = dict(source)
        row.update(reference=ref, Fusion_x_min_mm=x0, Fusion_y_min_mm=y0,
                   Fusion_z_bottom_mm=z0, Fusion_x_max_mm=x1,
                   Fusion_y_max_mm=y1, Fusion_z_top_mm=z1, basis=basis,
                   max_body_height_mm=z1-z0, assembly_allowance_mm=0)
        rows.append(row)
    add('J402_DRAWING_TOL_UPPER',cx-3.6,cy-3.6,plane,cx+3.6,cy+3.6,plane+8.2,
        'Conservative independent-extremes bound from Rev B general tolerances: base7.00+0.20; abovePCB(11.50+0.40)-(3.90-0.20)=8.20. Not independently specified or supplier-rated maximum; no mated cable.')
    for sx in (-1,1):
        for sy in (-1,1):
            x,y=cx+sx*2.54,cy+sy*2.54
            add('J402_DRAWING_TOL_TAIL_%s_%s'%(sx,sy),x-.61,y-.61,plane-4.1,x+.61,y+.61,plane,
                'Nominal centre position with square leg1.02+0.20 and projection3.90+0.20; pin position tolerances/solder not modeled; enclosure-only test excludes PCB itself.')
    add('J402_DRAWING_TOL_SIGNAL_TAIL',cx-.58,cy-.58,plane-4.1,cx+.58,cy+.58,plane,
        'Conservative square box enclosing centre-tail diameter0.96+0.20 and projection3.90+0.20; solder fillet not included.')
    return _envelopes(manager, {'rows':rows})


def _adapter():
    configure()
    import verification_a3 as v
    spec, contract = _inputs()
    original = v._records
    def adapted(d, manager):
        records = original(d, manager)
        records = [r for r in records if r['physical_group'] != 'alternative_oxygen_reference']
        for row in records:
            if row['occurrence'].startswith('PCB A3 - main four-layer placement:'):
                row['physical_group'] = 'pcb'
            elif row['occurrence'].startswith('PCB A3 - routed USB daughterboard:'):
                row['physical_group'] = 'usb'
        return records + _envelopes(manager, contract) + _coax_tolerance(manager, contract)
    v._records = adapted
    return v, original, spec, contract


def installed():
    """Check every populated envelope against all non-main physical geometry."""
    app, doc, d = owned()
    configure()
    import review_checks as checks
    import verification_a3 as v
    before_timeline = d.timeline.count
    other = other_documents(app)
    spec, contract = _inputs()
    manager, records = checks.records()
    physical = [r for r in records if r['physical_group'] != 'alternative_oxygen_reference']
    fixed = [r for r in physical if not r['occurrence'].startswith('PCB A3 - main four-layer placement:')]
    envelopes = _envelopes(manager, contract)
    envelope_test = v._test(manager, 'All populated maximum/allocation envelopes installed', envelopes, fixed, [(0,0,0)], [])
    actual = checks.collision_report(manager, physical)
    rows = []
    for r in contract['rows']:
        rows.append({'reference': r['reference'], 'MPN': r['MPN'], 'DNP': r['DNP'],
                     'envelope_tested': not r['DNP'], 'bounds_mm': [[r['Fusion_x_min_mm'],r['Fusion_y_min_mm'],r['Fusion_z_bottom_mm']],
                                                                 [r['Fusion_x_max_mm'],r['Fusion_y_max_mm'],r['Fusion_z_top_mm']]],
                     'max_body_height_mm': r['max_body_height_mm'], 'assembly_allowance_mm': r['assembly_allowance_mm'],
                     'basis': r['basis'], 'XY_basis': r['XY_basis'], 'source': r['source']})
    health = checks.health(d)
    preserved = d.timeline.count == before_timeline and other_documents(app) == other
    if not preserved:
        raise RuntimeError('Read-only clearance review changed source state')
    result = {'generated_at_utc': datetime.now(timezone.utc).isoformat(), 'document': doc.name,
              'status': 'first_pass_bounded_clear' if not envelope_test['collision_count'] and not actual['collisions'] and health['pass'] else 'first_pass_requires_correction',
              'source_manifest': spec, 'native_timeline': before_timeline, 'physical_solid_count': len(physical),
              'contract_rows': len(rows), 'populated_envelopes_tested': len(envelopes),
              'omitted_DNP_references': [r['reference'] for r in contract['rows'] if r['DNP']],
              'health': health, 'actual_cross_assembly_interferences': actual,
              'maximum_envelope_test': envelope_test, 'envelopes': rows,
              'source_state_preserved': preserved,
              'limits': ['First-pass placement only; final synchronized STEP and height contract are required after SW101/U114/USB ESD and routing changes.',
                         'All populated contract rows are tested, including parts missing from the STEP. Geometry is never scaled to fit.',
                         'Contract includes exact/source-based maxima and explicitly provisional allocations. A generic F.Fab envelope or visual STEP is not a verified purchased-part dimension.',
                         'No connector mating housing, owned SMB elbow, six-wire solder/strain relief, cable bend or assembly tool is inferred from absent data.',
                         'The envelope boxes start at nominal F.Cu Z22.1; detailed STEP package placement may include the exporter 0.04 mm standoff. Source-specific allowances must cover this.',
                         'Internal main-PCB package/pad intersections remain in the separate PCB review scope. Cross-assembly envelope and actual-geometry tests are both retained.'],
              'final_fabrication_or_physical_fit_release': False}
    report('main-first-pass-clearance.json', result)
    return result


def paths():
    """All eight sampled service paths, with max envelopes moving with the PCB."""
    v, original, spec, contract = _adapter()
    old = v.OUTPUT
    v.OUTPUT = BASE/'verification/first-pass-max-envelopes'
    v.OUTPUT.mkdir(parents=True, exist_ok=True)
    try:
        result = v.audit_paths()
    finally:
        v._records = original
        v.OUTPUT = old
    return result


def coax_tolerance():
    """Check separately disclosed tolerance bounds against enclosure assemblies."""
    configure()
    import review_checks as checks
    import verification_a3 as v
    spec, contract = _inputs()
    manager, records = checks.records()
    fixed = [r for r in records if r['physical_group'] != 'alternative_oxygen_reference'
             and not r['occurrence'].startswith('PCB A3 - main four-layer placement:')]
    supplements = _coax_tolerance(manager, contract)
    test = v._test(manager, 'J402 drawing-tolerance supplemental bounds', supplements, fixed, [(0,0,0)], [])
    result = {'status': 'supplemental_bounds_clear' if not test['collision_count'] else 'requires_review',
              'source_manifest': spec, 'test': test,
              'bounds_and_basis': [{'reference': r['contract']['reference'], 'basis': r['contract']['basis'],
                                  'bounds_cm': list(v._record_bounds(r))} for r in supplements],
              'limits': 'Supplemental independent-extremes bounds, not certified supplier maxima or complete tolerance-stack/PCB-hole/solder/mated-cable qualification. Source drawing reconstruction is unchanged.'}
    report('main-first-pass-coax-tolerance.json', result)
    return result


def drivers():
    """All fourteen nominal shaft corridors, with max envelopes as obstacles."""
    v, original, spec, contract = _adapter()
    old = v.OUTPUT
    v.OUTPUT = BASE/'verification/first-pass-max-envelopes'
    v.OUTPUT.mkdir(parents=True, exist_ok=True)
    try:
        result = v.audit_drivers()
    finally:
        v._records = original
        v.OUTPUT = old
    return result


def checkpoint():
    """Save an explicitly first-pass archive without replacing the baseline file."""
    app, doc, d = owned()
    configure()
    import review_checks as checks
    spec, contract = _inputs()
    other = other_documents(app)
    if not checks.health(d)['pass']:
        raise RuntimeError('Cannot checkpoint unhealthy first-pass geometry')
    wrapper = next(o for o in d.rootComponent.occurrences if o.component.partNumber == 'TMX-A3-B01')
    count = sum(1 for o in d.rootComponent.allOccurrences
                if o.fullPathName.startswith(wrapper.fullPathName+'+') for body in o.bRepBodies if body.isSolid)
    wrapper.component.attributes.add('TrimixPcbFit','source_step',spec['file'])
    wrapper.component.attributes.add('TrimixSystemReview','placed_pcb_solids',str(count))
    wrapper.component.attributes.add('TrimixSystemReview','integration_status','first_pass_not_final')
    wrapper.component.attributes.add('TrimixSystemReview','prior_calibration_geometry_metadata','Historical calibration import metadata predates this STEP refresh; use current source SHA and placed_pcb_solids.')
    path = BASE/'inputs/main-placement-first-pass/Trimix_Enclosure_A3_SystemReview_MainFirstPass.f3d'
    if not d.exportManager.execute(d.exportManager.createFusionArchiveExportOptions(str(path))):
        raise RuntimeError('First-pass native export failed')
    with zipfile.ZipFile(path) as archive:
        if archive.testzip():
            raise RuntimeError('First-pass archive CRC failed')
        members = len(archive.namelist())
    if not doc.save('First-pass reviewed main PCB plus maximum-envelope fit checks; final SW101/U114/USB/routing update pending. Not a fabrication release.'):
        raise RuntimeError('First-pass cloud save failed')
    if other_documents(app) != other:
        raise RuntimeError('First-pass checkpoint changed protected documents')
    result = {'status': 'first_pass_checkpoint_not_final', 'file': str(path),
              'sha256': hashlib.sha256(path.read_bytes()).hexdigest(),
              'bytes': path.stat().st_size, 'archive_crc_pass': True, 'archive_members': members,
              'source_manifest': spec, 'timeline': d.timeline.count,
              'original_pre_refresh_archive_preserved': True, 'other_documents_preserved': True,
              'maximum_envelopes': 'Transient BRep checks and JSON records; not additional physical CAD bodies.'}
    report('main-first-pass-checkpoint.json', result)
    return result
