"""Correct PCB elevation from GCT RevB profile dimensions, keeping mouth Z26.

Profile2.13 above board + offset1.13 below board =3.26; shell centre is0.50
above board top. The old stack centre coincided with the shell centre, a0.80
mm datum error for the0.60mm board. No purchased part is scaled.
"""
import json
import adsk.core as core
import adsk.fusion as fusion
from runtime import owned,report,bounds,GROUP

def connector_datum():
    """Correct the whole purchased reference pose from dimensioned stake datum.

    Existing footprint stake rows are correct: worldY3.56/7.56. Drawing2.95
    from nose to front stake makes noseY0.61, not the formerY1.0 approximation.
    Shapes are preserved here; undimensioned internal details remain references.
    """
    _,doc,d=owned();root=d.rootComponent
    o=next(q for q in root.occurrences if q.component.partNumber=='TMX-A3-C05')
    if o.component.attributes.itemByName(GROUP,'nose_datum_corrected'):raise RuntimeError('Already corrected connector Y datum')
    m=o.transform2
    if any(abs(v)>1e-7 for v in m.translation.asArray()):raise RuntimeError('Unexpected GCT parent pose')
    m.translation=core.Vector3D.create(0,-.039,0);o.transform2=m
    if d.snapshots.hasPendingSnapshot:d.snapshots.add()
    o.component.attributes.add(GROUP,'nose_datum_corrected','NoseY0.61 = frontstake3.56 - drawing2.95. ParentYtranslation-0.39mm; PCB XY unchanged.')
    o.component.attributes.add(GROUP,'remaining_shape_uncertainty','This is a dimension-led reconstruction, not manufacturer CAD. Shell bend radii, rear-insulator profile, formed contacts and full LIM gasket section remain simplified.')
    if not d.computeAll():raise RuntimeError('Connector datum recompute failed')
    report('usb-connector-datum.json',{'document':doc.name,'source':'GCT RevB page1 side view2.95nose-to-frontstake;4.00stake pitch',
      'independent_PCB_review':'Existing footprint stake rows0.30/4.30 are correct; footprint nose7.25; J901y110.14 andFusionY118-PCB_y implynose0.61.',
      'old_nose_y_mm':1,'correct_nose_y_mm':.61,'parent_translation_mm':[0,-.39,0],
      'front_stake_centre_y_mm':3.56,'rear_stake_centre_y_mm':7.56,'PCB_XY_changed':False,'purchased_shapes_scaled_or_carved':False,
      'bounds_mm':bounds(o),'remaining_uncertainty':'Manufacturer rear-insulator, bend, full gasket and formed-contact geometry is not completely dimensioned.'})

def shell_stakes():
    """Replace incorrect flat wings with RevB stake locations and sheet sizes.

    The bent-sheet corners are square reference bends; radii are not supplied.
    The four0.30-thick x1.30-wide tabs occupy the0.50 x1.65 PCB slots. Nose
    correction is a parent transform, so native local rows3.95/7.95 map to
    installed world3.56/7.56. No PCB clearance geometry drives purchased shape.
    """
    from runtime import configure
    _,doc,d=owned();b=configure()
    c=next(c for c in d.allComponents if c.partNumber=='TMX-A3-C05-V01')
    if c.attributes.itemByName(GROUP,'stakes_corrected'):raise RuntimeError('Stakes already corrected')
    wings=[f for f in c.features.extrudeFeatures if f.name.startswith('USB grounding wing reference')]
    if len(wings)!=4 or any(f.isSuppressed for f in wings):raise RuntimeError('Expected four original wing features')
    for f in sorted(wings,key=lambda q:q.timelineObject.index,reverse=True):f.isSuppressed=True
    if not d.computeAll():raise RuntimeError('Wing retirement failed')
    body=c.bRepBodies.item(0);sizes=[]
    for row,y,leg in [('front',3.95,.75),('rear',7.95,.60)]:
        for side in (-1,1):
            x='UsbX - 5.8 mm' if side<0 else 'UsbX + 4.12 mm'
            b.box(c,'RevB '+row+' shell arm '+str(side),x,f'{y-.65} mm','UsbZ - 0.5 mm','1.68 mm','1.30 mm','0.30 mm','join')
            x=f'UsbX + ({side*5.65-.15} mm)'
            b.box(c,'RevB '+row+' shell stake '+str(side),x,f'{y-.65} mm',f'UsbZ - {leg+.5} mm','0.30 mm','1.30 mm',f'{leg+.3} mm','join')
            sizes.append({'row':row,'installed_x_expression':f'UsbX + ({side*5.65} mm)','installed_y_mm':y-.39,'width_x_mm':.3,'length_y_mm':1.3,'projection_below_board_top_mm':leg})
    c.attributes.add(GROUP,'stakes_corrected','RevB0.30x1.30 tabs;11.30Xpitch,4.00Ypitch; frontprojection0.75/rear0.60; square bends are visual references, no force/formed-radius qualification.')
    if not d.computeAll():raise RuntimeError('Reconstructed stakes recompute failed')
    if c.bRepBodies.count!=1:raise RuntimeError('Shell reconstruction must remain one connected solid')
    report('usb-shell-stakes.json',{'document':doc.name,'retired_flat_wing_features':[f.name for f in wings],
        'stakes':sizes,'body_count':c.bRepBodies.count,'unqualified_detail':'Square bend radii, formed contact/tag tip shapes; supplier/physical fit required.',
        'geometry_selected_to_fit_PCB':False})

def _norm(s):return ''.join(s.split())

def board_elevation():
    _,doc,d=owned();root=d.rootComponent
    if root.attributes.itemByName(GROUP,'usb_board_elevation_corrected'):raise RuntimeError('USB datum correction already applied')
    expected={
      'd1134':('UsbZ-2.3mm','UsbZ - 3.1 mm','PCB supported rear edge ledge sketch / plane'),
      'd1158':('UsbZ-0.3mm','UsbZ - 1.1 mm','PCB rear edge stop sketch / plane'),
      'd1164':('7.5mm','8.3 mm','PCB rear edge stop'),
      'd1182':('UsbZ+0.3mm','UsbZ - 0.5 mm','PCB upper capture pad sketch / plane'),
      'd1188':('2mm','2.8 mm','PCB upper capture pad')}
    changes=[]
    for name,(old,new,owner) in expected.items():
        p=d.allParameters.itemByName(name)
        if p is None or _norm(p.expression)!=old or p.createdBy.name!=owner:raise RuntimeError('Unexpected support datum '+name)
        changes.append({'parameter':name,'feature':owner,'old':p.expression,'new':new})
    usb=next(o for o in root.occurrences if o.component.partNumber=='TMX-A3-B02')
    t=usb.transform2
    if abs(t.translation.z-2.5745)>1e-6:raise RuntimeError('Unexpected original USB STEP elevation')
    for change in changes:d.allParameters.itemByName(change['parameter']).expression=change['new']
    t.translation=core.Vector3D.create(t.translation.x,t.translation.y,2.4945)
    usb.transform2=t
    if d.snapshots.hasPendingSnapshot:d.snapshots.add()
    usb.component.attributes.add('TrimixPcbFit','registration_mm','X34.5 Y18 Z24.945; nominal0.60mm stack centreZ25.20; connector mouth centreZ26')
    usb.component.attributes.add(GROUP,'registration_mm',json.dumps([34.5,18,24.945]))
    for c in d.allComponents:
        if c.partNumber in ('TMX-A3-P06','TMX-A3-P10'):c.attributes.add(GROUP,'usb_z_correction','PCBstack lowered0.8mm; mouth/fasteners unchanged. Rearledge/capture updated parametrically. Physical tolerances and insertion-load test pending.')
    if not d.computeAll():raise RuntimeError('USB datum recompute failed')
    unhealthy=[f.name for c in d.allComponents for f in c.features if f.healthState!=fusion.FeatureHealthStates.HealthyFeatureHealthState]
    if unhealthy:raise RuntimeError('Unhealthy features after USB elevation: '+repr(unhealthy))
    root.attributes.add(GROUP,'usb_board_elevation_corrected','true')
    report('usb-board-elevation.json',{'document':doc.name,'source':'GCT_USB4720_RevB_drawing.pdf page1; profile2.13, offset1.13,0.60PCB',
       'old_nominal_stack_mm':[25.7,26.3],'new_nominal_stack_mm':[24.9,25.5],
       'connector_axis_z_mm':26,'new_STEP_translation_mm':[34.5,18,24.945],
       'source_dielectric_bounds_mm':[0,.51],'source_nominal_stack_thickness_mm':.6,
       'printed_parameters_changed':changes,'USB_import_bounds_mm':bounds(usb),
       'exterior_aperture_or_fastener_positions_changed':False,'geometry_scaled':False,
       'physical_fit_or_force_qualified':False})

def gasket_envelope():
    """Correct the two drawing-dimensioned gasket bounds, retaining unknown section."""
    from runtime import owned,report,bounds,GROUP
    _,doc,d=owned()
    c=next(c for c in d.allComponents if c.partNumber=='TMX-A3-C05-V04')
    s=c.sketches.itemByName('USB LIM gasket reference rectangular stock sketch')
    if not s or s.sketchDimensions.count!=4:raise RuntimeError('Unexpected gasket rectangle dimensions')
    original=[v.parameter.expression for v in s.sketchDimensions]
    expected=['UsbX - ( 4.75 mm )','-( -( ( UsbZ - ( 1.86 mm ) ) + ( 3.72 mm ) ) )','9.5 mm','3.72 mm']
    if [''.join(e.split())for e in original]!=[''.join(e.split())for e in expected]:raise RuntimeError('Gasket dimensions differ from reviewed original')
    updated=['UsbX - 4.77 mm','UsbZ + 1.875 mm','9.54 mm','3.75 mm']
    for q,e in zip(s.sketchDimensions,updated):q.parameter.expression=e
    if not d.computeAll():raise RuntimeError('Gasket bounds recompute failed')
    c.attributes.add(GROUP,'gasket_geometry_basis','Rev B dimensioned outside bounds9.54x3.75mm. Axial section, radii, contact/compression and physical seating remain unqualified reconstruction.')
    report('gct-gasket-dimensions.json',{'document':doc.name,'part':c.partNumber,'old_expressions':original,'new_expressions':updated,
        'component_local_bounds_mm':bounds(c.bRepBodies.item(0)),'source':'https://gct.co/files/drawings/usb4720.pdf',
        'sourced_nominal_dimensions_mm':[9.54,3.75],'seal_or_compression_qualified':False,
        'limits':'Drawing-nominal outside bounds only. Existing axial section, radii and uncompressed position remain reference geometry.'})
