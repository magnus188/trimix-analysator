"""A3 top sampling cartridge: staged native Fusion code, no import mutation.

Purchased sensor references retain their nominal dimensions. AO2 body is dry;
only its nose faces the sample. Generic gas fittings, seals, BME breakout and
sensor supports remain fit-study references. No manufacturer STEP is claimed.
Call body(), sensors(), hardware(), provisions() individually from owned A3.
"""
import json
import adsk.core as core
import adsk.fusion as fusion
import build_a3 as b
from hardware_a3 import screw_instances, insert_instances

BODY = 'Chamber / A3 top manifold with serial return'
LID = 'Chamber / A3 four-screw service lid'
AO2 = 'Sensor / AO2 dry body with wetted threaded nose'
ADAPTER = 'Chamber / AO2 hand-tight adapter reference'
CO = 'Sensor / ZE07-CO drawing-derived assembly'
HE = 'Sensor / MD62 body and full-length lead references'
BME = 'Sensor / GYBMEP humidity breakout reference'
LID_POINTS = [('18 mm', 'CaseHeight-21 mm'),
              ('CaseWidth-54.5 mm', 'CaseHeight-45 mm'),
              ('17 mm', 'CaseHeight-7.8 mm'),
              ('CaseWidth-17 mm', 'CaseHeight-7.8 mm')]
SOURCES = {
 'ao2': 'https://prod-edam.honeywell.com/content/dam/honeywell-edam/sps/siot/en-us/products/sensors/gas-sensors/automotive-and-emissions/documents/hon-ia-hss-automotive-ao2-o2-gas-sensor-dts-en.pdf',
 'md62': 'https://www.winsen-sensor.com/d/files/PDF/Thermal%20Conductor%20Gas%20Sensor/MD62%20Manual%20V1.3.pdf',
 'co': 'https://www.winsen-sensor.com/d/files/manual/ze07-co.pdf',
 'bme_chip': 'https://www.bosch-sensortec.com/media/boschsensortec/downloads/datasheets/bst-bme280-ds002.pdf',
}


def _new(name, basis, group='chamber'):
    c = b.new(name, basis)
    b.mark(c, group)
    c.attributes.add(b.GROUP, 'manufacturer_cad', 'false')
    c.attributes.add(b.GROUP, 'service_sequence',
        'Remove rear cover; disconnect pack and chamber harness; withdraw both gas fittings; '
        'withdraw complete cartridge +Z. Release lid and rotate AO2 only on bench.')
    return c


def _meta(c, **kwargs):
    for key, value in kwargs.items():
        c.attributes.add(b.GROUP, key,
                         json.dumps(value) if not isinstance(value, str) else value)


def _check():
    _, d = b.get()
    if b.mm(d, 'CaseWidth') < 84.75:
        raise RuntimeError('This AO2/CO packing needs CaseWidth >=84.75 mm for a nominal 5 mm face channel; narrower A3 needs repacking.')
    if b.mm(d, 'CaseHeight') < 180 or b.mm(d, 'CaseDepth') < 43:
        raise RuntimeError('This unscaled sensor stage needs at least 180 H and 43 D mm.')
    if abs(b.mm(d, 'GasY-(CaseHeight-17.5 mm)')) > 1e-6 or abs(b.mm(d, 'GasZ-22 mm')) > 1e-6:
        raise RuntimeError('A3 cartridge requires gas ports at Y=CaseHeight-17.5, Z=22 mm.')
    return d


def _shape(c, name, z, depth):
    target = b.box(c, name+' CO pocket', '3 mm', 'CaseHeight-50 mm', z,
                   'CaseWidth-53 mm', '37 mm', depth)
    b.box(c, name+' upper row', '13 mm', 'CaseHeight-19.5 mm', z,
          'CaseWidth-25.5 mm', '16.5 mm', depth, 'join', target)
    return target


def body():
    """Create manifold, separate adapter and one lid; leave hardware to hardware()."""
    _check()
    c = _new(BODY, 'Designed removable manifold. Nominal 2 mm walls and flat seal lands; '
                   'gasket stock, compression, fastening preload and gas response unqualified.')
    bb = _shape(c, 'Manifold outer', '3 mm', 'CaseDepth-10 mm')
    # Closed printed inlet duct: OD9 / ID5 gives a nominal 2 mm radial wall.
    b.xcyl(c, 'Upper sensor row inlet turn', 'CaseWidth-17 mm', 'CaseHeight-15 mm',
           'GasZ', '4.5 mm', '2.75 mm', 'join', bb)
    b.ycyl(c, 'Inlet rise outside dry AO2 connector', 'CaseWidth-14.25 mm',
           'GasY', 'GasZ', '4.5 mm', '2.5 mm', 'join', bb)
    b.xcyl(c, 'Viewer-left inlet duct', 'CaseWidth-14.25 mm', 'GasY', 'GasZ',
           '4.5 mm', '11.25 mm', 'join', bb)
    # Rear-open cavities are closed by the independent lid at Z=CaseDepth-7.
    b.box(c, 'Wet CO pocket interior', '5 mm', 'CaseHeight-48 mm', '5 mm',
          'CaseWidth-57 mm', '33 mm', 'CaseDepth', 'cut', bb)
    b.box(c, 'Wet humidity and MD62 row interior', '15 mm', 'CaseHeight-17.5 mm',
          '5 mm', 'CaseWidth-29.5 mm', '12.5 mm', 'CaseDepth', 'cut', bb)
    # The two overlapping cavities form one wet space, with the following
    # joined bulkheads blocking the short route directly to the exhaust.
    b.box(c, 'Full-depth inlet-to-outlet bypass barrier', '4.9 mm',
          'CaseHeight-22 mm', '4.9 mm', 'CaseWidth-62.65 mm', '4.6 mm',
          'CaseDepth-11.9 mm', 'join', bb)
    b.box(c, 'Exhaust junction upper 2 mm wall extension', '4.9 mm',
          'CaseHeight-17.5 mm', '4.9 mm', '7.2 mm', '4.5 mm',
          'CaseDepth-11.9 mm', 'join', bb)
    b.box(c, 'Rear return isolation above sensing-face sweep', '4.9 mm',
          'CaseHeight-31 mm', '29 mm', 'CaseWidth-62.65 mm', '9.1 mm',
          'CaseDepth-36 mm', 'join', bb)
    b.box(c, 'Humidity compartment rear bypass baffle', '48 mm',
          'CaseHeight-17.6 mm', '28 mm', '2 mm', '12.7 mm',
          'CaseDepth-35 mm', 'join', bb)
    # Main inlet and serial outlet return, each a continuous nominal Ø5 bore.
    b.xcyl(c, 'Inlet bore', 'CaseWidth-14.35 mm', 'GasY', 'GasZ', '2.5 mm',
           '11.45 mm', 'cut', bb)
    b.ycyl(c, 'Inlet rise bore', 'CaseWidth-14.25 mm', 'GasY-0.1 mm', 'GasZ',
           '2.5 mm', '2.7 mm', 'cut', bb)
    b.xcyl(c, 'Upper inlet turn bore', 'CaseWidth-17.1 mm', 'CaseHeight-15 mm',
           'GasZ', '2.5 mm', '2.95 mm', 'cut', bb)
    b.xcyl(c, 'Exhaust wall and return junction bore', '2.9 mm', 'GasY', 'GasZ',
           '2.5 mm', '4.7 mm', 'cut', bb)
    b.cyl(c, 'Exhaust return depth bore', '7.5 mm', 'GasY', '21.9 mm',
          '2.5 mm', '11.7 mm', 'cut', bb)
    b.ycyl(c, 'Exhaust return from below face-sweep barrier', '7.5 mm',
           'CaseHeight-34.6 mm', '33.5 mm', '2.5 mm', '17.2 mm', 'cut', bb)
    # AO2 neck traverses the side wall. The separate adapter supports its
    # nominal M16x1 surface; a face seal closes the dry side, not a helical CAD thread.
    b.xcyl(c, 'AO2 nose clearance through wet wall', 'CaseWidth-52.1 mm',
           'CaseHeight-37.5 mm', '21.75 mm', '8.1 mm', '2.2 mm', 'cut', bb)
    for x, y in LID_POINTS:
        b.cyl(c, 'M2 lid insert boss', x, y, 'CaseDepth-13 mm', '3.6 mm',
              '6 mm', 'join', bb)
        b.cyl(c, 'M2 blind pilot with 2 mm nominal floor', x, y,
              'CaseDepth-11 mm', '1.6 mm', '4.1 mm', 'cut', bb)
    # One lower feedthrough, rearward of the CO envelope. Actual conductor
    # count, potting chemistry and strain relief await the real harness.
    b.ycyl(c, 'Feedthrough support collar', '17 mm', 'CaseHeight-50 mm',
           '31.5 mm', '4.2 mm', '2 mm', 'join', bb)
    b.ycyl(c, 'Feedthrough seal seat', '17 mm', 'CaseHeight-50.1 mm',
           '31.5 mm', '2.2 mm', '2.2 mm', 'cut', bb)
    _meta(c, seal_status='Flat contact lands only; seal profile and compression must be measured before manufacture.',
          chamber_height_basis='47 mm top-zone bounding height, stepped corners clear rear housing bosses.',
          wetted_sequence=['viewer-left inlet', 'BME upstream compartment', 'MD62 upper row',
                           'AO2 nose / CO face channel', 'isolated rear return', 'viewer-right exhaust'],
          source_scope='Designed gas geometry; probe clearance does not establish sample renewal or flow uniformity.')
    lid = _new(LID, 'Designed 2 mm internal lid with four rear M2 screws; '
                    'flat mating contact, gasket geometry and preload pending.', 'chamber_lid')
    lb = _shape(lid, 'Lid', 'CaseDepth-7 mm', '2 mm')
    for x, y in LID_POINTS:
        b.cyl(lid, 'M2 lid clearance', x, y, 'CaseDepth-7.1 mm', '1.1 mm',
              '2.2 mm', 'cut', lb)
    adapter = _new(ADAPTER, 'Nominal M16x1 hand-tight adapter with simplified Ø16.2 bore. '
                           'Exact nose engagement, stop and compatible face seal require the purchased AO2.')
    ab = b.xcyl(adapter, 'Hand-tight adapter shoulder', 'CaseWidth-50 mm',
           'CaseHeight-37.5 mm', '21.75 mm', '10.1 mm', '3.8 mm')
    b.xcyl(adapter, 'Simplified female M16 clearance surface', 'CaseWidth-50.1 mm',
           'CaseHeight-37.5 mm', '21.75 mm', '8.1 mm', '4 mm', 'cut', ab)
    _meta(adapter, thread='M16 x 1 nominal; cosmetic/unmodeled thread, not a fabrication fit',
          removal='Withdraw cartridge +Z, then rotate AO2 on bench; no in-case wrench clearance claimed.')
    if c.bRepBodies.count != 1 or lid.bRepBodies.count != 1:
        raise RuntimeError('Manifold and lid must each be one joined solid.')
    b.checkpoint('A3 top manifold and four-screw lid')


def sensors():
    """Create independently selectable full-size references, including uncut leads."""
    _check()
    b.comp(BODY)
    c = _new(AO2, 'Honeywell AA428-210 drawing: Ø29.3 x31.75 body and M16x1 x6.5 nose. '
                   'Body stays dry; manufacturer drawing-derived, not exact supplier CAD.')
    ab = b.xcyl(c, 'AO2 Ø29.3 dry body', 'CaseWidth-46 mm', 'CaseHeight-37.5 mm',
                 '21.75 mm', '14.65 mm', '31.75 mm')
    b.xcyl(c, 'AO2 nominal threaded nose', 'CaseWidth-52.5 mm', 'CaseHeight-37.5 mm',
           '21.75 mm', '8 mm', '6.5 mm', 'join', ab)
    _meta(c, source=SOURCES['ao2'], wetted_face='Nose plane X=CaseWidth-52.5, centre Y=CaseHeight-37.5,Z21.75',
          thread='M16 x1 simplified cylindrical surface', nominal_body_mm=[31.75,29.3,29.3])
    conn = _new('Sensor / AO2 cable connector allowance',
                'Unmeasured 6.5x10x10 mated connector allowance; not supplier-authenticated geometry.')
    b.box(conn, 'AO2 connector and wire origin allowance', 'CaseWidth-14.25 mm',
          'CaseHeight-42.5 mm', '16.75 mm', '6.5 mm', '10 mm', '10 mm')
    _meta(conn, geometry_role='clearance_envelope', measurement_required='Actual mated plug and bend radius')
    co = _new(CO, 'Winsen drawing reconstruction: 25.4x22.4x1.6 PCB, Ø20x16.7 can, '
                  '3.45 opposite pins; total21.75 alongX. PCB plane rotated to Y25.4/Z22.4. '
                  'Pin placement and body finishes illustrative.')
    b.box(co, 'ZE07 PCB', '8.95 mm', 'CaseHeight-47.7 mm', '5.4 mm',
          '1.6 mm', '25.4 mm', '22.4 mm')
    b.xcyl(co, 'ZE07 CO can', '10.55 mm', 'CaseHeight-35 mm', '16.6 mm',
           '10 mm', '16.7 mm')
    b.box(co, 'ZE07 header envelope', '5.5 mm', 'CaseHeight-45.7 mm', '13.4 mm',
          '3.45 mm', '6 mm', '8 mm')
    _meta(co, source=SOURCES['co'], clearance_envelope_mm={'min':[5.5,132.3,5.4], 'max':[27.25,157.7,27.8]},
          flow_limit='Experimental CO only; avoid strong convection. Probe route is not a response validation.')
    he = _new(HE, 'Winsen MD62 nominal 19x9.5x14 body rotated X14,Y9.5,Z19. '
                  'Full 27 mm lead length retained; lead diameters/positions illustrative within the reserved envelope.')
    b.box(he, 'MD62 full-size body', '19 mm', 'CaseHeight-17 mm', '8 mm',
          '14 mm', '9.5 mm', '19 mm')
    for y in ('CaseHeight-15.8 mm', 'CaseHeight-8.7 mm'):
        for z in ('13 mm', '24 mm'):
            b.xcyl(he, 'MD62 full-length lead visual reference', '33 mm', y, z,
                   '0.25 mm', '27 mm')
    _meta(he, source=SOURCES['md62'], lead_allowance_mm=27,
          installed_envelope_mm=[41,9.5,19], detector_marking='Physical detector mark and sensor face positions must be inspected.',
          mounting='Untrimmed leads need a measured support/terminal carrier; no unsupported solder joints are qualified.')
    hum = _new(BME, 'Provisional GYBMEP 17x12x5 envelope; board outline and hardware unmeasured. '
                   'Illustrative PCB/cap/IC detail does not establish purchased BME280 identity.')
    b.box(hum, 'GYBMEP provisional PCB', 'CaseWidth-32 mm', 'CaseHeight-17.2 mm',
          '6 mm', '17 mm', '12 mm', '1.6 mm')
    b.box(hum, 'Humidity cap visual reference', 'CaseWidth-20 mm', 'CaseHeight-10 mm',
          '7.6 mm', '3 mm', '3 mm', '1.2 mm')
    b.box(hum, 'Breakout regulator height allowance', 'CaseWidth-30 mm', 'CaseHeight-15 mm',
          '7.6 mm', '4 mm', '5 mm', '3.4 mm')
    _meta(hum, source=SOURCES['bme_chip'], geometry_role='unmeasured_breakout_reference',
          nominal_clearance_envelope_mm=[17,12,5], mounting='Header, holes, insulation and strain relief pending owner measurements.')
    b.checkpoint('A3 full-size sensor references and 27 mm MD62 leads')


def hardware():
    """Four M2x5 screws: 3 mm nominal insert overlap, 1 mm tip clearance."""
    d = _check()
    body_component = b.comp(BODY)
    if body_component.attributes.itemByName(b.GROUP, 'lid_hardware_added'):
        raise RuntimeError('A3 lid hardware already exists.')
    root = d.rootComponent
    screw_positions = [(b.mm(d,x), b.mm(d,y), b.mm(d,'CaseDepth-5 mm')) for x,y in LID_POINTS]
    insert_positions = [(b.mm(d,x), b.mm(d,y), b.mm(d,'CaseDepth-7 mm')) for x,y in LID_POINTS]
    screws = screw_instances(root, 'M2', 5, screw_positions, label='A3 chamber lid M2x5')
    inserts = insert_instances(root, 'M2', insert_positions, label='A3 chamber lid insert')
    for occurrences, group, expr_z in [(screws, 'chamber_lid', 'CaseDepth-5 mm'),
                                        (inserts, 'chamber', 'CaseDepth-7 mm')]:
        for occurrence, (x,y) in zip(occurrences, LID_POINTS):
            occurrence.attributes.add(b.GROUP, 'physical_group', group)
            occurrence.attributes.add(b.GROUP, 'position_expressions', json.dumps([x,y,expr_z]))
            occurrence.attributes.add(b.GROUP, 'mount_axis', 'z')
            occurrence.attributes.add(b.GROUP, 'service_role', 'internal lid screw' if group=='chamber_lid' else 'internal lid insert')
    body_component.attributes.add(b.GROUP, 'lid_hardware_added', 'true')
    b.checkpoint('A3 four independent chamber lid screws and inserts')


def provisions():
    """Separate fitting, face-seal and feedthrough references; actual seals deferred."""
    _check()
    for label, x, length in [('Viewer-left inlet', 'CaseWidth-3 mm', '9 mm'),
                              ('Viewer-right exhaust', '-6 mm', '9 mm')]:
        c = _new('Gas / '+label+' fitting reference',
                 'Nominal purchased fitting/tube reference Ø8 OD, Ø5 ID; actual flange, '
                 'seal, retention and insertion depth unmeasured.', 'gas_fittings')
        fb = b.xcyl(c, label+' OD8 tube reference', x, 'GasY', 'GasZ', '4 mm', length)
        b.xcyl(c, label+' ID5 bore', '('+x+')-0.1 mm', 'GasY', 'GasZ',
               '2.5 mm', '('+length+')+0.2 mm', 'cut', fb)
        _meta(c, removal='Remove both external fittings before closed cartridge withdraws +Z.',
              nominal_tube_mm={'outer_diameter':8,'inner_diameter':5})
    seal = _new('Chamber / AO2 face-seal allowance',
                'Provisional 0.2 mm annular face-seal allowance only. Compatible material, section, '
                'compression and the purchased AO2 sealing datum must be established.')
    sb = b.xcyl(seal, 'AO2 face seal allowance', 'CaseWidth-46.2 mm',
                 'CaseHeight-37.5 mm', '21.75 mm', '10.1 mm', '0.2 mm')
    b.xcyl(seal, 'AO2 face seal bore', 'CaseWidth-46.3 mm', 'CaseHeight-37.5 mm',
           '21.75 mm', '8 mm', '0.4 mm', 'cut', sb)
    _meta(seal, geometry_role='seal_clearance_reference', gas_seal_validated='false')
    plug = _new('Chamber / sealed harness feedthrough allowance',
                'Unmeasured potting/gland allowance Ø4.4 through a Ø8.4 support collar; '
                'solid reference represents intended gas closure, not a selected seal or fabricated wire arrangement.')
    b.ycyl(plug, 'Potted harness closure reference', '17 mm', 'CaseHeight-51.3 mm',
           '31.5 mm', '2.2 mm', '3.3 mm')
    _meta(plug, geometry_role='seal_and_harness_allowance',
          measurement_required='Conductor count, harness OD, sealing compound compatibility, flex and rear unplugging clearance.')
    b.checkpoint('A3 removable gas fittings and labelled seal provisions')


def probe_route_expressions():
    """Centre-line candidate for a Ø5 BRep clearance probe, not a flow model.

    Samples explicitly visit the BME compartment, MD62 rear sensing region,
    shared AO2/CO face gap and isolated exhaust return. Root owns the audit.
    """
    return [
      ['CaseWidth+6 mm','GasY','22 mm'], ['CaseWidth-14.25 mm','GasY','22 mm'],
      ['CaseWidth-14.25 mm','CaseHeight-15 mm','22 mm'],
      ['CaseWidth-22 mm','CaseHeight-15 mm','22 mm'],
      ['CaseWidth-22 mm','CaseHeight-12 mm','14.5 mm'],
      ['40 mm','CaseHeight-12 mm','14.5 mm'], ['40 mm','CaseHeight-12 mm','31.5 mm'],
      ['CaseWidth-55.125 mm','CaseHeight-12 mm','31.5 mm'],
      ['CaseWidth-55.125 mm','CaseHeight-37.5 mm','31.5 mm'],
      ['CaseWidth-55.125 mm','CaseHeight-37.5 mm','21.75 mm'],
      ['CaseWidth-55.125 mm','CaseHeight-37.5 mm','33.5 mm'],
      ['7.5 mm','CaseHeight-37.5 mm','33.5 mm'], ['7.5 mm','GasY','33.5 mm'],
      ['7.5 mm','GasY','22 mm'], ['-6 mm','GasY','22 mm']]
