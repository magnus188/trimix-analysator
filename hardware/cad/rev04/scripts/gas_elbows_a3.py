"""Native parametric A3 gas elbow corrections; explicit execution only.

The nominal Ø5 path audit found four blocked corner volumes. Two inlet elbows
receive concentric outerR4.5 joins and innerR2.5 cuts; the two enclosed exhaust
elbows need innerR2.5 cuts only. Each sphere is a native360degree revolution of
an expression-positioned, radius-dimensioned semicircle. No mesh, temporary
marker solid, unmanaged scale or persistent cutting body is left behind.

Outer joins precede three straight-bore recuts: adding full outer spheres can
otherwise refill portions of the existing bores and their opening into the
plenum. restore_inlet_bores() upgrades the already-applied initial stage.

Call apply() only after parent reviews the gas audit. This module does nothing
to Fusion on import. Nominal2mm inlet radial walls do not prove global minimum
wall, seal compression, sample renewal, pressure rating or manufacturability.
"""
from math import cos, sin, radians
import json

import adsk.core as core
import adsk.fusion as fusion
import build_a3 as b
from fusion_helpers import _xy_sketch, _positioned_point, evaluate_cm

COMPONENT = 'Chamber / A3 top manifold with serial return'
INLET_CENTRES = [
    ('CaseWidth-14.25 mm','GasY','GasZ'),
    ('CaseWidth-14.25 mm','CaseHeight-15 mm','GasZ'),
]
EXHAUST_CENTRES = [
    ('7.5 mm','GasY','22 mm'),
    ('7.5 mm','GasY','33.5 mm'),
]
BORE_RESTORE = {
    'inlet':{'x':'CaseWidth-14.35 mm','y':'GasY','z':'GasZ','length':'11.45 mm'},
    'rise':{'x':'CaseWidth-14.25 mm','y':'GasY-0.1 mm','z':'GasZ','length':'2.7 mm'},
    'exit':{'x':'CaseWidth-20.1 mm','y':'CaseHeight-15 mm','z':'GasZ','length':'5.95 mm'},
    'radius':'2.5 mm',
}


def sphere(component, name, x_expr, y_expr, z_expr, radius_expr,
           operation, target):
    """Join/Cut one native sphere, returning its sole modified target body.

    Only one initial sketch point is dimension-positioned, avoiding the
    repeated inferred point relations that affected the earlier USB profiles.
    An initially non-axis-aligned arc is explicitly constrained: radius,
    vertical diameter and vertical alignment of its start with its centre.
    Together with the positioned centre, these leave a single semicircle.
    """
    if operation not in ('join','cut') or target is None:
        raise ValueError('Sphere helper requires Join/Cut and an explicit target')
    if component.bRepBodies.count != 1:
        raise RuntimeError('Gas elbow stage expects exactly one manifold body')
    radius=evaluate_cm(component,radius_expr)
    if radius <= 0:
        raise ValueError('Sphere radius must be positive')
    sketch=_xy_sketch(component,name+' semicircle',z_expr)
    centre=_positioned_point(component,sketch,x_expr,y_expr)
    cx,cy=centre.geometry.x,centre.geometry.y
    # Do not begin with points sharing axis coordinates; that can create
    # inferred relations before the intended constraints are added.
    angle=radians(-75)
    initial=core.Point3D.create(cx+radius*cos(angle),cy+radius*sin(angle),0)
    arc=sketch.sketchCurves.sketchArcs.addByCenterStartSweep(centre,initial,radians(160))
    if arc is None:
        raise RuntimeError('Cannot create gas elbow semicircle arc')
    dimension=sketch.sketchDimensions.addRadialDimension(
        arc,core.Point3D.create(cx+radius+.5,cy,0),True)
    if dimension is None:
        raise RuntimeError('Cannot dimension gas elbow radius')
    dimension.parameter.expression=radius_expr
    diameter=sketch.sketchCurves.sketchLines.addByTwoPoints(
        arc.startSketchPoint,arc.endSketchPoint)
    sketch.geometricConstraints.addVertical(diameter)
    sketch.geometricConstraints.addVerticalPoints(arc.centerSketchPoint,arc.startSketchPoint)
    # Unlike addByCenterRadius, some Fusion versions create an independent
    # centre for addByCenterStartSweep even when passed an existing SketchPoint.
    # Anchor that actual arc centre once its radius/orientation are constrained.
    if (arc.centerSketchPoint.entityToken != centre.entityToken
            and not arc.centerSketchPoint.isFullyConstrained):
        sketch.geometricConstraints.addCoincident(arc.centerSketchPoint,centre)
    if not sketch.isFullyConstrained or sketch.profiles.count != 1:
        diagnostic={'name':name,'profile_count':sketch.profiles.count,
                    'sketch_fully_constrained':sketch.isFullyConstrained,
                    'arc_fully_constrained':arc.isFullyConstrained,
                    'diameter_fully_constrained':diameter.isFullyConstrained,
                    'centre_tokens_match':arc.centerSketchPoint.entityToken==centre.entityToken,
                    'points':[{'index':i,'fully_constrained':p.isFullyConstrained,
                               'internal_cm':[p.geometry.x,p.geometry.y,p.geometry.z]}
                              for i,p in enumerate(sketch.sketchPoints)],
                    'constraints':[x.objectType for x in sketch.geometricConstraints]}
        raise RuntimeError('Gas elbow semicircle constraint diagnostic: '+json.dumps(diagnostic))
    actual=arc.geometry
    if abs(actual.radius-radius)>1e-6:
        raise RuntimeError('Gas elbow radius changed unexpectedly')
    a=arc.startSketchPoint.geometry; z=arc.endSketchPoint.geometry
    if abs(a.distanceTo(z)-2*radius)>1e-6:
        raise RuntimeError('Constrained gas elbow arc is not a semicircle')
    op=(fusion.FeatureOperations.JoinFeatureOperation if operation=='join'
        else fusion.FeatureOperations.CutFeatureOperation)
    request=component.features.revolveFeatures.createInput(sketch.profiles.item(0),diameter,op)
    if request is None or not request.setAngleExtent(False,core.ValueInput.createByString('360 deg')):
        raise RuntimeError('Cannot define native gas elbow revolution')
    if operation=='cut':
        request.participantBodies=[target]
    feature=component.features.revolveFeatures.add(request)
    if feature is None:
        raise RuntimeError('Gas elbow revolution failed')
    feature.name=name
    sketch.isLightBulbOn=False
    if feature.bodies.count != 1 or component.bRepBodies.count != 1:
        raise RuntimeError('Gas elbow operation did not retain one manifold solid')
    return feature.bodies.item(0)


def _restore_bores(c,target):
    """Restore the nominalØ5 centreline after additive outer elbow geometry.

    The outlet cut reaches beyond outer sphereX=CaseWidth-18.75 into the
    original open plenum. Its olderCaseWidth-17.1 start was inside the new
    sphere and could leave a plug even though the elbow centre was hollow.
    """
    for key,function,label in (
        ('inlet',b.xcyl,'Restore inletØ5 after outer sphere joins'),
        ('rise',b.ycyl,'Restore riseØ5 after outer sphere joins'),
        ('exit',b.xcyl,'Restore exitØ5 through outer sphere into plenum')):
        p=BORE_RESTORE[key]
        target=function(c,label,p['x'],p['y'],p['z'],BORE_RESTORE['radius'],p['length'],'cut',target)
        if c.bRepBodies.count != 1:
            raise RuntimeError('Restoring inlet bore split the manifold: '+key)
    return target


def _mark_restored(c):
    c.attributes.add(b.GROUP,'inlet_bores_restored_after_elbows',json.dumps({
        'version':1,'cuts':BORE_RESTORE,
        'purpose':'Remove material reintroduced by outer sphere joins; restoreØ5 exit into original plenum',
        'validation':'Re-run current-position unchangedØ5 gas path and static interference'}))


def restore_inlet_bores():
    """Incremental three-cut stage for a manifold with initial elbows applied."""
    _,d=b.get();c=b.comp(COMPONENT)
    if not c.attributes.itemByName(b.GROUP,'gas_elbows_added'):
        raise RuntimeError('Apply the elbow stage before incremental bore restoration')
    if c.attributes.itemByName(b.GROUP,'inlet_bores_restored_after_elbows'):
        raise RuntimeError('Inlet bore restoration already applied')
    if c.bRepBodies.count != 1:
        raise RuntimeError('Expected one manifold body before inlet bore restoration')
    if abs(b.mm(d,'GasY-(CaseHeight-17.5 mm)'))>1e-6 or abs(b.mm(d,'GasZ-22 mm'))>1e-6:
        raise RuntimeError('Bore restoration requires the reviewed A3 gas-port datums')
    _restore_bores(c,c.bRepBodies.item(0))
    if not d.computeAll() or c.bRepBodies.count != 1:
        raise RuntimeError('Inlet bore restoration failed recompute or solid count')
    _mark_restored(c)
    b.checkpoint('Restore threeØ5 inlet bores after outer elbow joins')


def apply():
    """Correct the four gas audit blockers without changing nominal bore size."""
    _,d=b.get(); c=b.comp(COMPONENT)
    if c.attributes.itemByName(b.GROUP,'gas_elbows_added'):
        raise RuntimeError('A3 gas elbow corrections already applied')
    if abs(b.mm(d,'GasY-(CaseHeight-17.5 mm)'))>1e-6 or abs(b.mm(d,'GasZ-22 mm'))>1e-6:
        raise RuntimeError('Elbow centres require the reviewed A3 gas-port datums')
    if c.bRepBodies.count != 1:
        raise RuntimeError('Expected one manifold body before elbow corrections')
    target=c.bRepBodies.item(0)
    for index,centre in enumerate(INLET_CENTRES,1):
        target=sphere(c,f'Inlet elbow{index} outerR4.5',*centre,'4.5 mm','join',target)
    target=_restore_bores(c,target)
    for index,centre in enumerate(INLET_CENTRES,1):
        target=sphere(c,f'Inlet elbow{index} innerR2.5',*centre,'2.5 mm','cut',target)
    for index,centre in enumerate(EXHAUST_CENTRES,1):
        target=sphere(c,f'Exhaust elbow{index} innerR2.5',*centre,'2.5 mm','cut',target)
    if not d.computeAll() or c.bRepBodies.count != 1:
        raise RuntimeError('A3 elbow corrections failed recompute or solid count')
    c.attributes.add(b.GROUP,'gas_elbows_added',json.dumps({
        'inlet_centres_expressions_mm':INLET_CENTRES,
        'exhaust_centres_expressions_mm':EXHAUST_CENTRES,
        'inlet_outer_radius_mm':4.5,'inner_radius_mm':2.5,
        'selected_inlet_nominal_radial_wall_mm':2,
        'method':'Native expression-driven semicircle revolutions; Join/Cut only',
        'validation':'Re-run unchangedØ5 path probe, static interference and selected wall checks',
        'limits':'No global wall, gas flow distribution, seal or manufacturing qualification'}))
    _mark_restored(c)
    b.checkpoint('Four continuousØ5 gas elbows with inlet outer support')


def run(_context):
    raise RuntimeError('Call apply() or incremental restore_inlet_bores() explicitly after reviewing the gas audit')
