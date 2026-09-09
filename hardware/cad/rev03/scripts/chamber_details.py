"""Bounded Rev03 sampling cartridge stages, called explicitly inside Fusion.

This is an editable packaging concept. Sensor dimensions are conservative
references, not supplier-authenticated CAD. Seals, sensor retention, thermal
behaviour and gas distribution require measurements and bench validation.
No CAD work occurs on import. Coordinates are global millimetres, +Z rearward.
"""

import json
import adsk.core as core
import adsk.fusion as fusion
import build_rev03 as b
from hardware_details import screw_instances, insert_instances


BODY_NAME = 'Chamber / sealed L cartridge concept'
LID_NAME = 'Chamber / removable internal lid'
MOUNT_POINTS = [(8.8, 94.7), (59.2, 115.4)]
LID_POINTS = [(17.4, 92.6), (12.9, 110.6), (66.5, 83.5),
              (66.5, 110.5), (51.2, 34.0), (66.5, 34.0)]
PREREQUISITES = [
    'Remove the single rear cover and disconnect the battery.',
    'Disconnect both external gas fittings before translating the cartridge.',
    'Unplug the chamber feedthrough harness through the carrier access notch.',
    'Remove the two chamber mounting screws through the lid access holes.',
    'Withdraw the closed cartridge rearward along +Z, off its stationary posts.',
    'Remove the six internal lid screws on the bench for sensor access.',
]


def _s(value):
    return f'{float(value):.9g} mm'


def _tag(component, group, basis=None):
    component.attributes.add(b.GROUP, 'service_group', group)
    if basis:
        component.attributes.add(b.GROUP, 'model_basis', basis)


def _tag_instances(occurrences, role, points, z_expression):
    for occurrence, (x, y) in zip(occurrences, points):
        occurrence.attributes.add(b.GROUP, 'service_group', role)
        occurrence.attributes.add(b.GROUP, 'position_expressions',
                                   json.dumps([_s(x), _s(y), z_expression]))


def _combine_cut(component, target, tool, name):
    tools = core.ObjectCollection.create()
    tools.add(tool)
    request = component.features.combineFeatures.createInput(target, tools)
    request.operation = fusion.FeatureOperations.CutFeatureOperation
    request.isKeepToolBodies = False
    feature = component.features.combineFeatures.add(request)
    feature.name = name


def _l_solid(component, name, front, depth, inner=False):
    if inner:
        left, right = 'ChamberLeft+ChamberWall', 'ChamberRight-ChamberWall'
        side = 'ChamberSideX+ChamberWall'
        bottom, top = 'ChamberBottom+ChamberWall', 'ChamberTop-ChamberWall'
        bar = 'ChamberBarY+ChamberWall'
    else:
        left, right, side = 'ChamberLeft', 'ChamberRight', 'ChamberSideX'
        bottom, top, bar = 'ChamberBottom', 'ChamberTop', 'ChamberBarY'
    body = b.box(component, name, left, bar, front,
                 f'({right})-({left})', f'({top})-({bar})', depth)
    # Cavity geometry initially overlaps the outer body. A normal extrusion
    # Join would also absorb that outer body. Explicitly combine only the two
    # temporary cavity bodies instead.
    column = b.box(component, name+' side column', side, bottom, front,
                   f'({right})-({side})', f'({top})-({bottom})', depth,
                   'new' if inner else 'join')
    if inner:
        tools = core.ObjectCollection.create()
        tools.add(column)
        request = component.features.combineFeatures.createInput(body, tools)
        request.operation = fusion.FeatureOperations.JoinFeatureOperation
        request.isKeepToolBodies = False
        component.features.combineFeatures.add(request).name = 'Join cavity tools only'
    return body


def _round_top(component, body, name, min_span):
    _, design = b.get()
    top = b.mm(design, 'ChamberTop') / 10
    b.fillet_long(component, body, '3.1 mm', name, min_span,
                  lambda p, q: abs(p.y-top) < 1e-6 and abs(q.y-top) < 1e-6)


def _outer_notches(component, body, name):
    for x in ('6 mm', 'CaseWidth-6 mm'):
        b.cyl(component, name+' upper M3 post clearance', x, 'CaseHeight-6 mm',
              'ChamberFront-1 mm', '4.5 mm', '2*CaseDepth', 'cut', body)
    b.box(component, name+' upper display retainer service notch',
          'ChamberLeft-1 mm', '114.8 mm', 'ChamberFront-1 mm',
          '18.1 mm-(ChamberLeft-1 mm)', 'CaseHeight-114.8 mm',
          '2*CaseDepth', 'cut', body)


def _validate_parameters(design):
    # This arrangement is deliberately bounded. Do not silently shrink sensors
    # or preserve claims after changes that make the initial tight fit invalid.
    for expression, expected in [('CaseWidth', 75), ('CaseHeight', 125),
                                 ('ChamberFront', 16.5), ('ChamberRear', 50.8),
                                 ('ChamberWall', 2), ('ChamberLid', 2)]:
        if abs(b.mm(design, expression)-expected) > 1e-6:
            raise ValueError('Recheck chamber packaging before changing '+expression)


def _build_cartridge_body(chamber):
    """Create exactly one body using direct cuts and floor-connected additions.

    No persistent cavity tool is created. Exclusion columns initially extend
    past the XY silhouette, then explicit clipping restores the original outer
    boundary before rounding and piercing. Every addition is joined to the
    original continuous floor or an existing wall, so no separate tool can be
    accidentally absorbed by a later Join on recompute.
    """
    body = _l_solid(chamber, 'L sampling cartridge', 'ChamberFront',
                    'ChamberRear-ChamberLid-ChamberFront')
    b.box(chamber, 'Direct upper gas cavity', 'ChamberLeft+ChamberWall',
          'ChamberBarY+ChamberWall', 'ChamberFront+ChamberWall',
          'ChamberRight-ChamberLeft-2*ChamberWall',
          'ChamberTop-ChamberBarY-2*ChamberWall', 'CaseDepth', 'cut', body)
    b.box(chamber, 'Direct connected side gas cavity', 'ChamberSideX+ChamberWall',
          'ChamberBottom+ChamberWall', 'ChamberFront+ChamberWall',
          'ChamberRight-ChamberSideX-2*ChamberWall',
          'ChamberTop-ChamberBottom-2*ChamberWall', 'CaseDepth', 'cut', body)
    # Full-depth exclusion material joins the 2 mm floor. Clip these columns
    # before piercing them so their nominal walls remain inside the enclosure.
    for x in ('6 mm', 'CaseWidth-6 mm'):
        b.cyl(chamber, 'Joined M3 exclusion wall stock', x, 'CaseHeight-6 mm',
              'ChamberFront', '6.5 mm', 'ChamberRear-ChamberLid-ChamberFront', 'join')
    b.box(chamber, 'Joined 2 mm retainer notch wall stock', 'ChamberLeft',
          '112.8 mm', 'ChamberFront', '20.1 mm-ChamberLeft',
          'ChamberTop-112.8 mm', 'ChamberRear-ChamberLid-ChamberFront', 'join')
    for x, y in MOUNT_POINTS:
        b.cyl(chamber, 'Joined isolated housing post tunnel', _s(x), _s(y),
              'ChamberFront', '5.8 mm', 'ChamberRear-ChamberLid-ChamberFront', 'join')
    b.box(chamber, 'Trim stock outside left outline', 'ChamberLeft-10 mm', '-10 mm',
          'ChamberFront-1 mm', '10 mm', 'CaseHeight+20 mm', '2*CaseDepth', 'cut', body)
    b.box(chamber, 'Trim stock outside right outline', 'ChamberRight', '-10 mm',
          'ChamberFront-1 mm', '10 mm', 'CaseHeight+20 mm', '2*CaseDepth', 'cut', body)
    b.box(chamber, 'Trim stock outside upper outline', 'ChamberLeft-10 mm', 'ChamberTop',
          'ChamberFront-1 mm', 'ChamberRight-ChamberLeft+20 mm', '10 mm', '2*CaseDepth', 'cut', body)
    _round_top(chamber, body, 'Housing clearance top corner rounds', 1.0)
    _outer_notches(chamber, body, 'Cartridge')

    # Housing attachment posts are isolated from sample gas by full-depth
    # cartridge walls. Their top roofs carry the removable M2 mounting screws.
    for x, y in MOUNT_POINTS:
        b.cyl(chamber, 'Stationary post withdrawal passage', _s(x), _s(y),
              'ChamberFront-0.1 mm', '3.8 mm',
              'ChamberRear-ChamberLid-2 mm-(ChamberFront-0.1 mm)', 'cut', body)
        b.cyl(chamber, 'M2 mounting roof clearance', _s(x), _s(y),
              'ChamberRear-ChamberLid-2.1 mm', '1.2 mm', '2.2 mm', 'cut', body)

    # Short rear bosses avoid the real sensor volumes nearer the front.
    # Pocket radius1.65 plus2 mm plastic requires R3.65, not merely R3.6.
    webs = [(13.75, 87.0, 7.3, 5.6), (2.9, 106.95, 10.0, 7.3),
            (66.5, 79.85, 5.6, 7.3), (66.5, 106.85, 5.6, 7.3),
            (45.6, 30.35, 5.6, 7.3), (66.5, 30.35, 5.6, 7.3)]
    for (x, y), (wx, wy, ww, wh) in zip(LID_POINTS, webs):
        b.box(chamber, 'Lid boss wall support', _s(wx), _s(wy),
              'ChamberRear-ChamberLid-6 mm', _s(ww), _s(wh), '6 mm', 'join')
        b.cyl(chamber, 'M2 lid boss with 2 mm radial plastic', _s(x), _s(y),
              'ChamberRear-ChamberLid-6 mm', '3.65 mm', '6 mm', 'join')
        b.cyl(chamber, 'M2 lid insert pocket — supplier fit pending', _s(x), _s(y),
              'ChamberRear-ChamberLid-4 mm', '1.65 mm', '4.1 mm', 'cut', body)
    b.xcyl(chamber, 'Gas fitting chamber wall passages', '-1 mm', 'GasY', 'GasZ',
           '4.1 mm', 'CaseWidth+2 mm', 'cut', body)
    b.xcyl(chamber, 'Wired sensor feedthrough opening — gland fit pending',
           '42 mm', '73 mm', '44.5 mm', '2.4 mm', '6 mm', 'cut', body)
    body.name = 'Closed-wall L cartridge — unqualified sealing concept'
    if chamber.bRepBodies.count != 1:
        raise RuntimeError('Direct cartridge construction must leave exactly one body.')
    return body


def build_chamber():
    """Build the body, lid, sensors, fittings and housing mount posts.

    Call add_chamber_hardware() afterwards to instantiate separate fasteners.
    The body has isolated axial post tunnels rather than unsealed mounting
    holes in the sample cavity. Their wall and roof are nominally 2 mm.
    """
    _, design = b.get()
    _validate_parameters(design)
    if any(o.component.name == BODY_NAME for o in design.rootComponent.occurrences):
        raise RuntimeError('Chamber stage already exists; do not duplicate it.')
    chamber = b.new(BODY_NAME,
                    'Designed concept; nominal 2 mm walls; seal geometry and pressure qualification deferred')
    _tag(chamber, 'closed_chamber')
    body = _build_cartridge_body(chamber)

    lid = b.new(LID_NAME, 'Separate 2 mm internal lid; gasket and seal groove deferred')
    _tag(lid, 'closed_chamber')
    lid_body = _l_solid(lid, 'Internal L lid', 'ChamberRear-ChamberLid', 'ChamberLid')
    _round_top(lid, lid_body, 'Lid housing-clearance top rounds', 0.1)
    _outer_notches(lid, lid_body, 'Lid')
    for x, y in LID_POINTS:
        b.cyl(lid, 'Internal lid M2 clearance', _s(x), _s(y),
              'ChamberRear-ChamberLid-0.1 mm', '1.2 mm', 'ChamberLid+0.2 mm', 'cut', lid_body)
    for x, y in MOUNT_POINTS:
        b.cyl(lid, 'Mounting screw driver access inside isolated tunnel', _s(x), _s(y),
              'ChamberRear-ChamberLid-0.1 mm', '2.7 mm', 'ChamberLid+0.2 mm', 'cut', lid_body)

    shell = b.comp('01 Tapered printed housing')
    shell_body = shell.bRepBodies.item(0)
    b.box(shell, 'Left cartridge post front support bridge', '2.1 mm', '91.05 mm',
          '14.3 mm', '6.7 mm', '7.3 mm', '2 mm', 'join')
    b.box(shell, 'Top cartridge post front support bridge', '55.55 mm', '115.4 mm',
          '14.3 mm', '7.3 mm', '7.5 mm', '2 mm', 'join')
    for x, y in MOUNT_POINTS:
        b.cyl(shell, 'Stationary isolated cartridge M2 post', _s(x), _s(y),
              '14.3 mm', '3.65 mm', 'ChamberRear-ChamberLid-2 mm-14.3 mm', 'join')
        b.cyl(shell, 'Cartridge mount insert pocket', _s(x), _s(y),
              'ChamberRear-ChamberLid-6 mm', '1.65 mm', '4.1 mm', 'cut', shell_body)

    _sensors()
    _fittings()
    chamber.attributes.add(b.GROUP, 'service', json.dumps(PREREQUISITES))
    chamber.attributes.add(b.GROUP, 'seal_status',
                           'No final gasket, groove, wire potting or port sealing geometry; not leak qualified')
    chamber.attributes.add(b.GROUP, 'flow_status',
                           'Connected L cavity; port-to-port free-space route only. Lower CO/He branch flow and mixing are unvalidated; a distributor may be required.')
    chamber.attributes.add(b.GROUP, 'sensor_retention',
                           'Sensor mounts, cable constraints and AO2 gas interface remain unmeasured and are not fabricated here.')
    if chamber.bRepBodies.count != 1 or lid.bRepBodies.count != 1:
        raise RuntimeError('Chamber and lid must each be one joined body; cavity tool must be consumed.')
    b.checkpoint('L chamber and bounded sensors')


def fix_chamber_geometry():
    """Replace only the defective owned cartridge, preserving all other parts.

    This repairs the earlier persistent-cavity-tool implementation. It removes
    the single matching cartridge occurrence (and therefore its old feature
    timeline), then creates an equivalent cartridge using direct cuts. Existing
    lid, sensors, screws, inserts and housing posts are not edited. Fusion MCP
    should execute the whole function within its normal rollback transaction.
    """
    _, design = b.get()
    _validate_parameters(design)
    matches = [occurrence for occurrence in design.rootComponent.occurrences
               if occurrence.component.name == BODY_NAME]
    if len(matches) != 1:
        raise RuntimeError('Repair requires exactly one owned cartridge occurrence.')
    original = matches[0]
    service = original.component.attributes.itemByName(b.GROUP, 'service_group')
    if not service or service.value != 'closed_chamber':
        raise RuntimeError('Refusing to replace a cartridge without the owned service tag.')
    attributes = [(attribute.name, attribute.value)
                  for attribute in original.component.attributes
                  if attribute.groupName == b.GROUP]
    appearance = original.component.bRepBodies.item(0).appearance
    count_before = design.rootComponent.occurrences.count
    if not original.deleteMe():
        raise RuntimeError('Failed to remove the defective cartridge occurrence.')
    chamber = b.new(BODY_NAME,
                    'Designed concept; direct cavity cuts; nominal2 mm walls; sealing qualification deferred')
    for name, value in attributes:
        chamber.attributes.add(b.GROUP, name, value)
    chamber.attributes.add(b.GROUP, 'construction_revision', 'direct_cavities_v2')
    body = _build_cartridge_body(chamber)
    if appearance:
        body.appearance = appearance
    if not design.computeAll():
        raise RuntimeError('Fusion could not recompute the repaired cartridge.')
    if chamber.bRepBodies.count != 1 or not body.isSolid:
        raise RuntimeError('Repaired cartridge is not exactly one solid after recompute.')
    box = body.boundingBox
    actual = [box.minPoint.x*10, box.maxPoint.x*10,
              box.minPoint.y*10, box.maxPoint.y*10,
              box.minPoint.z*10, box.maxPoint.z*10]
    expected = [b.mm(design, name) for name in
                ('ChamberLeft', 'ChamberRight', 'ChamberBottom', 'ChamberTop',
                 'ChamberFront', 'ChamberRear-ChamberLid')]
    if any(abs(a-e) > 1e-5 for a, e in zip(actual, expected)):
        raise RuntimeError('Repaired cartridge exceeds its intended bounds: '+json.dumps(actual))
    unhealthy = [entity.name+': '+entity.errorOrWarningMessage
                 for collection in (chamber.features, chamber.sketches, chamber.constructionPlanes)
                 for entity in collection
                 if entity.healthState != fusion.FeatureHealthStates.HealthyFeatureHealthState]
    if unhealthy:
        raise RuntimeError('Repaired cartridge has unhealthy features: '+json.dumps(unhealthy))
    if design.rootComponent.occurrences.count != count_before:
        raise RuntimeError('Cartridge repair unexpectedly changed the assembly occurrence count.')
    b.checkpoint('cartridge direct-cavity rebuild')
    return {'body_count': 1, 'bounds_mm': actual, 'other_components_modified': False,
            'construction': 'direct cavity cuts; no persistent cavity tool'}


def _sensors():
    ao2 = b.new('Sensor / AO2 sideways body and neck',
                'Datasheet dimensional envelope: body Ø29.3x31.75, neck Ø16x6.5; no exact threads or supplier CAD')
    _tag(ao2, 'closed_chamber')
    b.xcyl(ao2, 'AO2 full-size body', '21.4 mm', '104.3 mm',
           'ChamberFront+17.15 mm', '14.65 mm', '31.75 mm')
    b.xcyl(ao2, 'AO2 M16 nose reference', '14.9 mm', '104.3 mm',
           'ChamberFront+17.15 mm', '8 mm', '6.5 mm', 'join')
    specifications = [
        ('Sensor / AO2 connector allowance', 'Unmeasured 6.5x10x10 connector and wire clearance',
         '53.15 mm', '99.3 mm', 'ChamberFront+12.15 mm', '6.5 mm', '10 mm', '10 mm'),
        ('Sensor / ZE07-CO rotated total envelope', 'Published total dimensions rotated: X21.75,Y22.4,Z25.4; mount and connector detail pending',
         '47.975 mm', '38 mm', 'ChamberFront+2.5 mm', '21.75 mm', '22.4 mm', '25.4 mm'),
        ('Sensor / MD62 rotated body envelope', 'Full19x9.5x14 body rotated to X9.5,Y14,Z19; no manufacturer CAD available',
         '60.1 mm', '61 mm', 'ChamberFront+2.5 mm', '9.5 mm', '14 mm', '19 mm'),
        ('Sensor / MD62 27 mm lead allowance', 'Conservative clearance block for full26±1 mm leads, +Y orientation; not a physical solid lead bundle',
         '60.1 mm', '75 mm', 'ChamberFront+2.5 mm', '9.5 mm', '27 mm', '19 mm'),
        ('Sensor / GYBMEP wired module envelope', 'Provisional12x17x5 board allowance; actual BME280 identity, orientation and holes require confirmation',
         '55.5 mm', '88.8 mm', 'ChamberFront+25.5 mm', '12 mm', '17 mm', '5 mm'),
    ]
    for name, basis, x, y, z, width, height, depth in specifications:
        component = b.new(name, basis)
        _tag(component, 'closed_chamber')
        component.attributes.add(b.GROUP, 'geometry_role', 'clearance_envelope')
        b.box(component, name.split(' / ')[1], x, y, z, width, height, depth)


def _fittings():
    for name, x, length in [('left inlet', 'ChamberRight-ChamberWall',
                              'CaseWidth+6 mm-(ChamberRight-ChamberWall)'),
                             ('right exhaust', '-6 mm', 'ChamberLeft+ChamberWall+6 mm')]:
        component = b.new('Gas / '+name+' fitting reference',
                          'Nominal8 mm OD/5 mm ID straight fitting reference; actual part, flange, seal and hose bend unmeasured')
        _tag(component, 'external_gas_fitting')
        body = b.xcyl(component, name+' hollow fitting', x, 'GasY', 'GasZ', '4 mm', length)
        b.xcyl(component, name+' 5 mm through bore', f'({x})-0.1 mm', 'GasY', 'GasZ',
               'GasBore', f'({length})+0.2 mm', 'cut', body)
    component = b.new('Chamber / sealed wire feedthrough concept',
                      'Nominal4.4 mm OD feedthrough reference; wire potting, actual gland, cable diameter and bends unverified')
    _tag(component, 'closed_chamber')
    body = b.xcyl(component, 'Harness feedthrough envelope', '42 mm', '73 mm', '44.5 mm', '2.2 mm', '5.6 mm')
    b.xcyl(component, 'Provisional wire bore — sealing pending', '41.9 mm', '73 mm', '44.5 mm',
           '1.3 mm', '5.8 mm', 'cut', body)


def add_chamber_hardware():
    """Add six lid screws/inserts and two separately removable mount screws.

    Every occurrence has a service_group attribute for assembly service audits.
    Generic M2 hardware requires supplier selection and physical fit tests.
    """
    _, design = b.get()
    _validate_parameters(design)
    chamber = b.comp(BODY_NAME)
    if chamber.attributes.itemByName(b.GROUP, 'hardware_added'):
        raise RuntimeError('Chamber hardware already added.')
    root = design.rootComponent
    rear = b.mm(design, 'ChamberRear')
    lid_seat = b.mm(design, 'ChamberRear-ChamberLid')
    _tag_instances(screw_instances(root, 'M2', 5, [(x, y, rear) for x, y in LID_POINTS],
                                   label='Chamber lid M2x5'), 'chamber_lid_fastener',
                   LID_POINTS, 'ChamberRear')
    _tag_instances(insert_instances(root, 'M2', [(x, y, lid_seat) for x, y in LID_POINTS]),
                   'chamber_lid_fastener', LID_POINTS, 'ChamberRear-ChamberLid')
    _tag_instances(screw_instances(root, 'M2', 5, [(x, y, lid_seat) for x, y in MOUNT_POINTS],
                                   label='Cartridge attachment M2x5'), 'chamber_mount_screw',
                   MOUNT_POINTS, 'ChamberRear-ChamberLid')
    _tag_instances(insert_instances(root, 'M2', [(x, y, lid_seat-2) for x, y in MOUNT_POINTS]),
                   'chamber_mount_insert', MOUNT_POINTS, 'ChamberRear-ChamberLid-2 mm')
    chamber.attributes.add(b.GROUP, 'hardware_added', 'true')
    metadata = inspection_metadata()
    path = b.BASE / 'verification' / 'chamber-layout.json'
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(metadata, indent=2), encoding='utf-8')
    b.checkpoint('chamber hardware')
    return metadata


def inspection_metadata():
    """Return numeric placements and explicit limits for independent audits."""
    _, design = b.get()
    rear = b.mm(design, 'ChamberRear')
    return {
        'units': 'mm', 'body_component': BODY_NAME, 'lid_component': LID_NAME,
        'housing_post_centres_xy': MOUNT_POINTS,
        'housing_post_radius': 3.65, 'post_passage_radius': 3.8,
        'mount_driver_access_diameter': 5.4,
        'post_z': [14.3, rear-4], 'post_tunnel_wall': 2.0,
        'chamber_mount_screw_underhead_z': rear-2,
        'lid_screw_centres_xy': LID_POINTS, 'lid_screw_underhead_z': rear,
        'lid_insert_rear_z': rear-2, 'mount_insert_rear_z': rear-4,
        'fasteners': {'M2x5_screws': 8, 'M2_OD3.2_L4_inserts': 8},
        'minimum_nominal_boss_wall_mm': 2.0,
        'prerequisites': PREREQUISITES,
        'gas_route_for_sampled_audit_only': [
            [81, 105, 23], [57, 105, 23], [57, 91.8, 21.3],
            [12, 91.8, 21.3], [12, 105, 23], [-6, 105, 23]],
        'route_warning': 'This establishes only a candidate connected free-space route. It does not prove gas passes all sensors, uniform sampling, pressure loss, seal integrity or sensor response.',
        'unverified': ['All gas seals and grooves', 'Sensor retention and actual connector dimensions',
                       'Lower-column gas distribution and mixing; baffle may be required',
                       'MD62 and charger thermal influence on humidity and composition measurements',
                       'Actual cable diameter, bend radius and strain relief',
                       'Printed bridge/post strength and fastener torque',
                       'Fit clearances after printing and insert supplier tolerances'],
    }


def refine_sensor_appearance():
    """Optionally replace CO/BME boxes with bounded visual reconstructions.

    Call only after build_chamber(). Component names and service groups remain
    unchanged. A native Remove feature retains the original envelope in the
    timeline; its full bounds remain in metadata. Dimensions of CO's PCB/can
    stack are drawing references supplied for this stage. Header shape, BME
    component positions, pad holes and colours are illustrative and must not be
    mistaken for supplier-authenticated purchased-part CAD or drilling data.
    MD62's full conservative lead-clearance body is deliberately untouched.
    """
    app, design = b.get()
    _validate_parameters(design)
    co = b.comp('Sensor / ZE07-CO rotated total envelope')
    humidity = b.comp('Sensor / GYBMEP wired module envelope')
    for component in (co, humidity):
        if component.attributes.itemByName(b.GROUP, 'visual_refinement_added'):
            raise RuntimeError('Sensor visual refinement already applied: '+component.name)
        if component.bRepBodies.count != 1:
            raise RuntimeError('Expected one original envelope body: '+component.name)

    library = app.materialLibraries.itemByName('Fusion Appearance Library')
    if not library:
        raise RuntimeError('Fusion Appearance Library unavailable for sensor styling.')
    appearances = {}
    for name, source_id in [('PCB green', 'Prism-117'), ('IC dark', 'Prism-113'),
                            ('Sensor light metal reference', 'Prism-116'),
                            ('Contact gold reference', 'Prism-040')]:
        full_name = 'Rev03 '+name
        appearance = design.appearances.itemByName(full_name)
        if not appearance:
            source = library.appearances.itemById(source_id)
            if not source:
                raise RuntimeError('Sensor appearance source unavailable: '+source_id)
            appearance = design.appearances.addByCopy(source, full_name)
        appearances[name] = appearance

    def remove_envelope(component, bounds, note):
        feature = component.features.removeFeatures.add(component.bRepBodies.item(0))
        if not feature:
            raise RuntimeError('Could not remove original sensor envelope: '+component.name)
        feature.name = 'Replace envelope with bounded visual reconstruction'
        component.attributes.add(b.GROUP, 'clearance_envelope_mm', json.dumps(bounds))
        component.attributes.add(b.GROUP, 'geometry_role', 'drawing_reference_with_envelope_metadata')
        component.attributes.add(b.GROUP, 'model_basis', note)
        component.attributes.add(b.GROUP, 'preserve_appearance', 'true')
        component.attributes.add(b.GROUP, 'visual_refinement_added', 'true')

    remove_envelope(co, {'min': [47.975, 38, 19], 'max': [69.725, 60.4, 44.4]},
                    'Drawing-derived PCB thickness1.6, can Ø20x16.7, opposite3.45 mm header allowance. Header profile and finishes illustrative; original total envelope remains reserved.')
    pcb = b.box(co, 'ZE07-CO PCB — drawing-derived stack', '51.425 mm', '38 mm',
                'ChamberFront+2.5 mm', '1.6 mm', '22.4 mm', '25.4 mm')
    pcb.appearance = appearances['PCB green']
    can = b.xcyl(co, 'ZE07-CO sensor can — Ø20 x 16.7 reference', '53.025 mm',
                 '49.2 mm', 'ChamberFront+15.2 mm', '10 mm', '16.7 mm')
    can.appearance = appearances['Sensor light metal reference']
    # The depth is real allocated space; lateral header geometry is illustrative.
    header = b.box(co, 'ZE07 opposite-side pin header allowance — profile unmeasured',
                   '47.975 mm', '40 mm', 'ChamberFront+11 mm',
                   '3.45 mm', '6 mm', '8 mm')
    header.appearance = appearances['IC dark']
    header.attributes.add(b.GROUP, 'geometry_role', 'connector_clearance_reference')

    remove_envelope(humidity, {'min': [55.5, 88.8, 42], 'max': [67.5, 105.8, 47]},
                    'Provisional12x17x5 GYBMEP envelope retained. Board thickness, pad holes, cap, IC placement and finishes are illustrative; module identity and all mounting dimensions remain unverified.')
    board = b.box(humidity, 'GYBMEP board — provisional visual reference', '55.5 mm',
                  '88.8 mm', 'ChamberFront+25.5 mm', '12 mm', '17 mm', '1.6 mm')
    board.appearance = appearances['PCB green']
    for x in (57.2, 59.74, 62.28, 64.82):
        b.cyl(humidity, 'Illustrative I2C pad drill — not fabrication data', _s(x),
              '90.3 mm', 'ChamberFront+25.4 mm', '0.5 mm', '1.9 mm', 'cut', board)
        pad = b.cyl(humidity, 'Illustrative I2C plated pad', _s(x), '90.3 mm',
                    'ChamberFront+27.1 mm', '0.85 mm', '0.08 mm')
        b.cyl(humidity, 'Illustrative pad bore', _s(x), '90.3 mm',
              'ChamberFront+27.05 mm', '0.5 mm', '0.2 mm', 'cut', pad)
        pad.appearance = appearances['Contact gold reference']
    cap = b.box(humidity, 'Humidity metal cap — placement unverified', '63.5 mm',
                '101.5 mm', 'ChamberFront+27.1 mm', '3 mm', '3 mm', '1.2 mm')
    cap.appearance = appearances['Sensor light metal reference']
    for name, x, y, width, height, depth in [
            ('Regulator allocation visual', 56.2, 94.0, 4, 5, 3.4),
            ('Interface IC visual', 62.0, 94.0, 3, 4, 1.4),
            ('Passive component reference', 58.0, 102.5, 2.5, 1.5, 0.8)]:
        item = b.box(humidity, name, _s(x), _s(y), 'ChamberFront+27.1 mm',
                     _s(width), _s(height), _s(depth))
        item.appearance = appearances['IC dark']
    if co.bRepBodies.count != 3 or humidity.bRepBodies.count != 9:
        raise RuntimeError('Unexpected body count after bounded sensor visual refinement.')
    b.checkpoint('drawing-derived CO and illustrative humidity detail')
