"""A3 cartridge guides, cover stops and provisional sensor seats.

No work occurs on import. Root executes the two stages through official Fusion.
No extra screws: housing guides support the closed cartridge, while three cover
stops limit rear travel. Individual sensor supports are clearly labelled fit
provisions; actual boards, sensing faces and assembly paths need measurement.
"""
import json
import adsk.core as core
import build_a3 as b
import chamber_a3 as ch


def _tag(component, key, value):
    component.attributes.add(b.GROUP, key,
        value if isinstance(value, str) else json.dumps(value))


def _once(component, key):
    if component.attributes.itemByName(b.GROUP, key):
        raise RuntimeError('Stage already applied: '+key)


def _body_report(component):
    """Diagnostic bounds only; no geometry mutations or expensive properties."""
    _, d = b.get()
    occurrences = [o for o in d.rootComponent.occurrences
                   if o.component.id == component.id]
    rows = []
    for body in component.bRepBodies:
        bb = body.boundingBox
        local = {'min':[bb.minPoint.x*10,bb.minPoint.y*10,bb.minPoint.z*10],
                 'max':[bb.maxPoint.x*10,bb.maxPoint.y*10,bb.maxPoint.z*10]}
        world = []
        for occurrence in occurrences:
            corners = []
            for x in (bb.minPoint.x,bb.maxPoint.x):
                for y in (bb.minPoint.y,bb.maxPoint.y):
                    for z in (bb.minPoint.z,bb.maxPoint.z):
                        point = core.Point3D.create(x,y,z)
                        point.transformBy(occurrence.transform2)
                        corners.append((point.x*10,point.y*10,point.z*10))
            world.append({'occurrence':occurrence.fullPathName,
                          'min':[min(p[i] for p in corners) for i in range(3)],
                          'max':[max(p[i] for p in corners) for i in range(3)]})
        rows.append({'body':body.name,'local_bounds_mm':local,
                     'world_bounds_mm':world})
    return {'component':component.name,'body_count':component.bRepBodies.count,
            'bodies':rows}


def _single(component, stage):
    if component.bRepBodies.count != 1:
        raise RuntimeError('Retention body-count diagnostic: '+json.dumps({
            'stage':stage,'state':_body_report(component)}))


def _join(component, name, *args):
    """Report the exact first disconnected join, including before/after bounds."""
    _single(component, 'before '+name)
    before = _body_report(component)
    try:
        result = b.box(component, name, *args)
    except Exception as error:
        raise RuntimeError('Retention join diagnostic: '+json.dumps({
            'feature':name,'arguments':[str(a) for a in args[:6]],
            'before':before,'after':_body_report(component),'error':str(error)})) from error
    if component.bRepBodies.count != 1:
        raise RuntimeError('Retention detached-join diagnostic: '+json.dumps({
            'feature':name,'arguments':[str(a) for a in args[:6]],
            'before':before,'after':_body_report(component)}))
    return result


def housing_and_cover():
    """Add integral supports; cartridge remains free to withdraw along +Z."""
    _, d = b.get()
    chamber = b.comp(ch.BODY)
    b.comp(ch.LID)
    housing = b.comp('01 Shape A housing')
    cover = b.comp('02 Single rear cover')
    _once(housing, 'chamber_retention_added')
    _single(housing, 'pre-existing housing before retention')
    _single(cover, 'pre-existing rear cover before retention')
    hb = housing.bRepBodies.item(0)
    cb = cover.bRepBodies.item(0)
    # These are shallow raised pads on the existing 2.4 mm front wall, not
    # separate thin plates. Their continuous front-wall foundation totals3 mm.
    for x, y, width, height in [
        ('6 mm', 'CaseHeight-46 mm', '6 mm', '7 mm'),
        ('25 mm', 'CaseHeight-28 mm', '6 mm', '7 mm'),
        ('53 mm', 'CaseHeight-12 mm', '7 mm', '7 mm')]:
        _join(housing, 'Cartridge front datum support', x, y, '2.3 mm',
              width, height, '0.7 mm', 'join', hb)
    # All guide walls are at least2 mm thick in their short in-plane direction.
    # They root in the front wall and have no rearward hooks or undercuts.
    _join(housing, 'Cartridge lower guide — clear harness exit',
          '25 mm', 'CaseHeight-52.5 mm', '2.3 mm',
          'CaseWidth-50 mm-25 mm', '2 mm', 'CaseDepth-7.5 mm', 'join', hb)
    _join(housing, 'Cartridge dry-side straight guide',
          'CaseWidth-49.5 mm', 'CaseHeight-50 mm', '2.3 mm',
          '2 mm', '2.1 mm', 'CaseDepth-7.5 mm', 'join', hb)
    # The left shoulder guide ends atZ28, ahead of the rear M3 bosses atZ30.
    _join(housing, 'Cartridge upper shoulder guide', '3.5 mm',
          'CaseHeight-12.5 mm', '2.3 mm', '7 mm', '2 mm', '25.7 mm',
          'join', hb)
    # Contact lands bear above manifold walls/bulkheads, away from lid heads.
    # A0.2 mm nominal axial float permits assembly; no preload is claimed.
    for x, y, width, height in [
        ('6 mm', 'CaseHeight-46 mm', '6 mm', '7 mm'),
        ('21 mm', 'CaseHeight-30 mm', '6 mm', '6 mm'),
        ('48 mm', 'CaseHeight-14 mm', '2 mm', '7 mm')]:
        _join(cover, 'Closed cartridge rear capture stop', x, y,
              'CaseDepth-4.8 mm', width, height,
              '4.9 mm-Cover+CoverGap', 'join', cb)
    _tag(housing, 'chamber_retention_added', 'true')
    _tag(housing, 'chamber_guide_clearances_mm', {
        'lower':0.5, 'upper_shoulder':0.5, 'dry_side':0.5,
        'opposite_shell_wall':0.6, 'front_datum':0})
    _tag(cover, 'chamber_rear_capture_float_mm', 0.2)
    _tag(chamber, 'housing_retention',
         'Three front lands, three straight guide walls and three rear-cover stops. '
         'No added screws. Remove both fittings and cover before straight +Z withdrawal. '
         'Nominal0.2 mm axial float; retention stiffness, wear and actual tolerance need fit testing.')
    if housing.bRepBodies.count != 1 or cover.bRepBodies.count != 1:
        raise RuntimeError('Cartridge guides/stops must join their owning printed body.')
    b.checkpoint('A3 closed cartridge housing guides and cover capture')


def sensor_seats():
    """Add unmeasured contact/clip provisions, without inventing mounting holes.

    These features make the support intent visible. No guarantee is made that
    the purchased board corners are component-free, or that unmeasured active
    MD62 faces can be clamped. Root audits the resulting nominal geometry.
    """
    b.get()
    body = b.comp(ch.BODY)
    lid = b.comp(ch.LID)
    co = b.comp(ch.CO)
    he = b.comp(ch.HE)
    humidity = b.comp(ch.BME)
    _once(body, 'sensor_support_provisions_added')
    bb = body.bRepBodies.item(0)
    lb = lid.bRepBodies.item(0)
    # CO left-face supports avoid the illustrative header and sensor can.
    for y, z in [('CaseHeight-47 mm', '24.5 mm'),
                  ('CaseHeight-25 mm', '8 mm')]:
        _join(body, 'Provisional CO PCB left-face seat', '4.9 mm', y, z,
              '4.05 mm', '2 mm', '2 mm', 'join', bb)
    _join(body, 'Provisional CO front-edge seat', '8.75 mm',
          'CaseHeight-47 mm', '4.9 mm', '2 mm', '2 mm', '0.5 mm',
          'join', bb)
    # The0.5 mm raised edge is supported by the2 mm manifold front wall.
    # Both2 mm clips leave0.15 mm beside the drawing's PCB outer face.
    _join(body, 'Provisional CO upper corner keeper', '10.7 mm',
          'CaseHeight-24.5 mm', '6 mm', '2 mm', '4 mm', '2 mm',
          'join', bb)
    _join(body, 'Provisional CO lower corner keeper', '10.7 mm',
          'CaseHeight-48.5 mm', '25 mm', '2 mm', '2.8 mm', '2 mm',
          'join', bb)
    # Small MD62 end contacts leave the declared rear sensing region open.
    for y in ('CaseHeight-16 mm', 'CaseHeight-10.2 mm'):
        _join(body, 'Provisional MD62 front end-contact', '21.5 mm', y,
              '4.9 mm', '2 mm', '2 mm', '3.1 mm', 'join', bb)
        _join(lid, 'Provisional MD62 rear end-stop — 0.3 mm gap', '21.5 mm', y,
              '27.3 mm', '2 mm', '2 mm', 'CaseDepth-34.2 mm', 'join', lb)
    for x in ('16.7 mm', '33.3 mm'):
        _join(body, 'Provisional MD62 lateral guide', x, 'CaseHeight-16.5 mm',
              '4.9 mm', '2 mm', '8 mm', '5.1 mm', 'join', bb)
    # Humidity PCB feet and a shallow keeper use the provisional free corner.
    # Its header, chip identity and real outline have not been measured.
    for x, y in [('CaseWidth-31 mm', 'CaseHeight-16 mm'),
                  ('CaseWidth-18 mm', 'CaseHeight-8 mm')]:
        _join(body, 'Provisional humidity PCB foot', x, y, '4.9 mm',
              '2 mm', '2 mm', '1.1 mm', 'join', bb)
    _join(body, 'Provisional humidity corner keeper', 'CaseWidth-17 mm',
          'CaseHeight-16 mm', '7.9 mm', '2.6 mm', '2 mm', '2 mm',
          'join', bb)
    _tag(body, 'sensor_support_provisions_added', 'true')
    _tag(co, 'mounting',
         'Provisional left-face seats, front edge and0.15 mm corner keepers; '
         'no mounting holes invented. Actual PCB corner keep-outs and bench insertion path unverified.')
    _tag(he, 'mounting',
         'Provisional2x2 mm end contacts, lateral guides and0.3 mm rear-lid stop clearance. '
         'Measure real non-sensing contact surfaces before use. Full27 mm leads remain; '
         'terminal support and strain relief are still unmeasured.')
    _tag(humidity, 'mounting',
         'Provisional feet and0.3 mm upper-face keeper at an illustrative board corner. '
         'Confirm actual component-free contact area, header and installation path.')
    if body.bRepBodies.count != 1 or lid.bRepBodies.count != 1:
        raise RuntimeError('Sensor-seat provisions must join manifold or lid.')
    b.checkpoint('A3 labelled provisional sensor support provisions')
