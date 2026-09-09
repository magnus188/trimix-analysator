"""A3 bottom USB cartridge; explicit staged execution inside owned Fusion only.

The USB4720 connector is reconstructed from GCT drawing Rev B. It is not a
supplier CAD model. The hidden metal seat uses the drawing's 1.80 mm panel
section; surrounding printed supports retain nominal >=2 mm sections. Seal
compression, the separate bezel/housing seal, solder-tab load strength, board
routing, printed tolerances and physical plug loading remain unqualified.

Call build(), then interface(). All dimensions use millimetre expressions;
the opening faces -Y, and X/Z follow UsbX/UsbZ. No import-time CAD mutation.
"""
import json
from math import tan, radians

import adsk.core as core
import adsk.fusion as fusion
import build_a3 as b
from fusion_helpers import evaluate_cm

GROUP = 'TrimixRev04'
SOURCE = 'https://gct.co/files/drawings/usb4720.pdf'
SOURCE_SHA256 = 'b3347df8cf39cc4f72e60f88708d3ddedec681d77bfcbbc9a3a5fd53975a5be6'
BASIS = ('GCT USB4720 Rev B drawing-derived reconstruction, not supplier CAD. '
         'Purchased geometry and physical seal/load qualification pending.')
NAMES = {
    'frame': 'USB A3 — removable printed support frame',
    'bridge': 'USB A3 — hidden metal retaining bridge',
    'bezel': 'USB A3 — tiny flush metal bezel and hidden flange',
    'shell': 'USB A3 — GCT USB4720 shell drawing reconstruction',
    'insulator': 'USB A3 — tongue and rear insulator reference',
    'gasket': 'USB A3 — GCT LIM gasket nominal reference',
    'pcb': 'USB A3 — supported 0.60 mm daughterboard provisional',
    'contacts': 'USB A3 — illustrative contact stripes',
}


def _v(number):
    return f'{float(number):.10g} mm'


def _new(key, basis):
    c = b.new(NAMES[key], basis)
    b.mark(c, 'usb')
    for name, value in {
        'source': SOURCE, 'source_sha256': SOURCE_SHA256,
        'supplier_model_obtained': 'false', 'subassembly': 'closed USB cartridge',
        'removal': 'Remove rear cover/key and battery; translate +Y2.5mm, then +Z. Sampled service audit required.',
    }.items():
        c.attributes.add(GROUP, name, value)
    return c


def _rounded(c, name, y, length, width, height, radius, op='new', target=None):
    """Expression-driven XZ rectangle extruded+Y and rounded on four Y edges.

    A single tool body is consumed by each Cut/Join. The rectangle is fully
    constrained by the established shared-point helper; no coincident free
    profile points or initial-position fixes are introduced.
    """
    if radius <= 0 or 2 * radius >= min(width,height):
        raise ValueError('Rounded prism must have four nonzero straight sides')
    existing = target
    if op == 'join' and existing is None:
        if c.bRepBodies.count != 1:
            raise RuntimeError('Rounded Join needs one unambiguous existing body')
        existing = c.bRepBodies.item(0)
    if op == 'cut' and existing is None:
        raise ValueError('Rounded Cut requires an explicit target')
    tool = b.ybox(c,name+' rectangular stock',f'UsbX-({_v(width/2)})',y,
                  f'UsbZ-({_v(height/2)})',_v(width),length,_v(height))
    edges = core.ObjectCollection.create()
    span = abs(evaluate_cm(c,length))
    for edge in tool.edges:
        if not edge.startVertex or not edge.endVertex:
            continue
        p,q = edge.startVertex.geometry,edge.endVertex.geometry
        if (abs(p.x-q.x)<1e-7 and abs(p.z-q.z)<1e-7
                and abs(abs(p.y-q.y)-span)<1e-7):
            edges.add(edge)
    if edges.count != 4:
        raise RuntimeError('Expected four Y edges for rounded USB prism: '+name)
    request = c.features.filletFeatures.createInput()
    request.edgeSetInputs.addConstantRadiusEdgeSet(edges,core.ValueInput.createByString(_v(radius)),False)
    feature = c.features.filletFeatures.add(request)
    feature.name = name+' corner rounds'
    tool.name = name
    if op == 'new':
        return tool
    collection = core.ObjectCollection.create(); collection.add(tool)
    request = c.features.combineFeatures.createInput(existing,collection)
    request.operation = (fusion.FeatureOperations.CutFeatureOperation if op == 'cut'
                         else fusion.FeatureOperations.JoinFeatureOperation)
    request.isKeepToolBodies = False
    feature = c.features.combineFeatures.add(request); feature.name = name
    if feature.bodies.count != 1:
        raise RuntimeError('USB rounded operation split the target: '+name)
    return feature.bodies.item(0)


def _end_face(body, y_cm):
    faces = []
    for face in body.faces:
        plane = core.Plane.cast(face.geometry)
        if plane and abs(abs(plane.normal.y)-1)<1e-7 and abs(plane.origin.y-y_cm)<1e-7:
            faces.append(face)
    if len(faces) != 1:
        raise RuntimeError('Cannot identify rounded USB loft section end face')
    return faces[0]


def _entry(c, body):
    """10-degree nominal entry loft between parameter-driven rounded end faces.

    The section solids are removed after the loft using timeline Remove
    features; their upstream geometry remains available to the parametric loft.
    No unconsumed tool or section body is left in the finished assembly.
    """
    expansion = 2*1.13*tan(radians(10))
    mouth = _rounded(c,'GCT external entry section','-.01 mm','.01 mm',
                     8.44+expansion,2.66+expansion,1.05+expansion/2)
    throat = _rounded(c,'GCT inner entry section','1.13 mm','.01 mm',8.44,2.66,1.05)
    request = c.features.loftFeatures.createInput(fusion.FeatureOperations.NewBodyFeatureOperation)
    request.loftSections.add(_end_face(mouth,0))
    request.loftSections.add(_end_face(throat,.113))
    feature = c.features.loftFeatures.add(request)
    feature.name = 'GCT nominal10degree entry cutting tool'
    tool = feature.bodies.item(0)
    for section in (mouth,throat):
        removal = c.features.removeFeatures.add(section)
        if removal is None:
            raise RuntimeError('Cannot remove consumed USB loft section solid')
        removal.name = 'Remove USB entry construction section'
    b.cut_tool(c,body,tool,'GCT nominal10degree external lead-in')


def _hardware():
    _, d = b.get()
    points = [('UsbX-9.25 mm','18.25 mm'), ('UsbX+9.25 mm','18.25 mm')]
    screws, inserts = b.fasteners(d.rootComponent, 'M2', 5, points,
                                 'UsbZ+7.2 mm', 'UsbZ+5.2 mm', 'usb', 'usb')
    for o in screws+inserts:
        o.attributes.add(GROUP, 'subassembly', 'closed USB cartridge')
    return screws, inserts


def build():
    """Build the independently removable USB cartridge with exactly two M2x5.

    Printed frame carries a 0.6mm board close to the connector and captures its
    rear edge. Shell solder tabs transfer connector loads to that board; the
    model does not invent a rear shoulder on the purchased SMT connector.
    """
    _, d = b.get()
    if any(o.component.name in NAMES.values() for o in d.rootComponent.occurrences):
        raise RuntimeError('USB A3 already exists; do not duplicate')

    bezel = _new('bezel', 'Designed metal bezel14x8mm visible, hidden20x11mm flange; local drawing1.80mm seat. Material/process/seals pending.')
    bb = _rounded(bezel, 'Tiny flush metal bezel', '0 mm','2.4 mm',14,8,.8)
    b.ybox(bezel,'Hidden metal flange','UsbX-10 mm','2.4 mm','UsbZ-5 mm',
           '20 mm','2 mm','11 mm','join')
    b.ybox(bezel,'Metal seat rear relief to local1.80mm panel','UsbX-6.5 mm','1.8 mm','UsbZ-3.5 mm',
           '13 mm','2.7 mm','7 mm','cut',bb)
    _rounded(bezel,'GCT8.44x2.66 throat R1.05','-0.05 mm','1.9 mm',8.44,2.66,1.05,'cut',bb)
    _rounded(bezel,'GCT9.14x3.35 inner lip R1.39','1.63 mm','.18 mm',9.14,3.35,1.39,'cut',bb)
    _rounded(bezel,'GCT9.64x3.86 gasket seat R1.65','1.13 mm','.5 mm',9.64,3.86,1.65,'cut',bb)
    _entry(bezel,bb)
    bezel.attributes.add(GROUP,'seal_limits','Drawing nominal section1.80mm; lip0.17mm; gasket seat0.50mm; entry1.13mm at10deg. R0.20 transitions omitted. Gasket compression and bezel-to-housing seam unqualified.')

    frame = _new('frame','Designed printed cartridge; floor2mm, boss OD7.3 around3.3mm pilot. Local nominal walls only, not global wall certification.')
    fb = b.box(frame,'USB printed frame floor','UsbX-12.9 mm','2.4 mm','UsbZ-7 mm',
               '25.8 mm','19.5 mm','2 mm')
    b.box(frame,'USB front flange backing wall','UsbX-12.9 mm','4.4 mm','UsbZ-5 mm',
          '25.8 mm','2 mm','10.2 mm','join')
    b.box(frame,'PCB and shell clear backing opening','UsbX-6.5 mm','4.3 mm','UsbZ-3.2 mm',
          '13 mm','2.2 mm','6.4 mm','cut',fb)
    for x in ('UsbX-9.25 mm','UsbX+9.25 mm'):
        b.cyl(frame,'USB M2 insert boss',x,'18.25 mm','UsbZ-7 mm','3.65 mm','12.2 mm','join')
        b.cyl(frame,'USB insert pilot reference',x,'18.25 mm','UsbZ+0.95 mm',
              '1.65 mm','4.35 mm','cut',fb)
    for x in ('UsbX-5.1 mm','UsbX+3.1 mm'):
        b.box(frame,'PCB rear ledge support',x,'16 mm','UsbZ-5 mm','2 mm','2 mm','2.7 mm','join')
    b.box(frame,'PCB supported rear edge ledge','UsbX-5.1 mm','16 mm','UsbZ-2.3 mm',
          '10.2 mm','2 mm','2 mm','join')

    bridge = _new('bridge','Designed metal common bridge and PCB edge capture; two M2 screws. Positive solder-tab/PCB load path requires physical qualification.')
    rb = b.box(bridge,'Hidden USB common retaining bridge','UsbX-12.9 mm','5 mm','UsbZ+5.2 mm',
               '25.8 mm','16.9 mm','2 mm')
    b.box(bridge,'Hidden flange top capture lip','UsbX-10 mm','3.6 mm','UsbZ+6 mm',
          '20 mm','2.8 mm','1.2 mm','join')
    b.box(bridge,'PCB rear edge stop','UsbX-5.1 mm','18 mm','UsbZ-0.3 mm',
          '10.2 mm','2 mm','7.5 mm','join')
    for x in ('UsbX-5.1 mm','UsbX+3.1 mm'):
        b.box(bridge,'PCB upper capture stalk',x,'16 mm','UsbZ+2.3 mm','2 mm','2 mm','2.9 mm','join')
    b.box(bridge,'PCB upper capture pad','UsbX-5.1 mm','16 mm','UsbZ+0.3 mm',
          '10.2 mm','2 mm','2 mm','join')
    for x in ('UsbX-9.25 mm','UsbX+9.25 mm'):
        b.cyl(bridge,'Rear accessible USB M2 screw clearance',x,'18.25 mm','UsbZ+5.1 mm',
              '1.1 mm','2.2 mm','cut',rb)

    pcb = _new('pcb','Provisional 16x13.6x0.60mm daughterboard with straddle and support clearances. Routing, solder lands and fabrication outline pending.')
    pb = b.box(pcb,'USB supported0.60mm daughterboard','UsbX-8 mm','4.4 mm','UsbZ-0.3 mm',
               '16 mm','13.6 mm','.6 mm')
    for x in ('UsbX-8.1 mm','UsbX+6.3 mm'):
        b.box(pcb,'Board front shoulder backing relief',x,'4.3 mm','UsbZ-0.4 mm',
              '1.8 mm','2.1 mm','.8 mm','cut',pb)
    b.box(pcb,'Connector straddle relief footprint provisional','UsbX-4.63 mm','4.3 mm','UsbZ-0.4 mm',
          '9.26 mm','4.4 mm','.8 mm','cut',pb)
    for x in ('UsbX-9.25 mm','UsbX+9.25 mm'):
        b.cyl(pcb,'PCB rear corner insert boss clearance',x,'18.25 mm','UsbZ-0.4 mm',
              '3.85 mm','.8 mm','cut',pb)

    shell = _new('shell',BASIS)
    sb = _rounded(shell,'USB stainless main shell reference','2.1 mm','5.4 mm',8.34,3.26,1.05)
    _rounded(shell,'USB nose reference','1 mm','1.1 mm',8.34,2.56,1.05,'join')
    _rounded(shell,'USB shell rear cavity simplified','2.1 mm','5.5 mm',7.94,2.86,.85,'cut',sb)
    _rounded(shell,'USB nose inner cavity simplified','.9 mm','1.3 mm',7.94,2.16,.85,'cut',sb)
    for y in ('3.9 mm','5.9 mm'):
        for x in ('UsbX-5.65 mm','UsbX+4.12 mm'):
            b.box(shell,'USB grounding wing reference',x,y,'UsbZ+0.3 mm','1.53 mm','1.3 mm','.3 mm','join')
    shell.partNumber = 'USB4720-03-A-DRAWING-REFERENCE'
    insulator = _new('insulator',BASIS+' Insulating tongue geometry simplified.')
    _rounded(insulator,'USB rear insulator','6.6 mm','1 mm',7.8,2.1,.5)
    b.box(insulator,'USB tongue6.69x0.70 reference','UsbX-3.345 mm','1.2 mm','UsbZ-0.35 mm',
          '6.69 mm','5.4 mm','.7 mm','join')
    gasket = _new('gasket',BASIS+' Uncompressed silicone reference; no seal simulation.')
    gb = _rounded(gasket,'USB LIM gasket reference','1.2 mm','.4 mm',9.5,3.72,1.5)
    _rounded(gasket,'USB gasket inner shell clearance','1.19 mm','.42 mm',8.38,2.60,1.07,'cut',gb)
    contacts = _new('contacts','Illustrative contact stripes only; not pin geometry or footprint.')
    for z in ('UsbZ-0.38 mm','UsbZ+0.35 mm'):
        for i in range(8):
            b.box(contacts,'USB visual contact stripe',f'UsbX+({_v(-1.875+i*.5)})','1.3 mm',z,
                  '.25 mm','2.7 mm','.03 mm')
    _hardware()
    d.rootComponent.attributes.add(GROUP,'usb_a3',json.dumps({
        'source':SOURCE,'supplier_cad':False,'entry_axis':'-Y','visible_bezel_mm':[14,8],
        'panel_reference_mm':1.8,'pcb_thickness_mm':.6,'installed_screws':'2xM2x5',
        'reserve_mm':{'x':'UsbX +/-12.9','y':[0,21.9],'z':'UsbZ-7 .. UsbZ+9.2'},
        'thread_overlap_mm':3,'screw_tip_to_insert_front_mm':1,
        'candidate_removal':[[0,2.5,0],[0,0,60]],
        'prerequisites':['rear cover and captured key removed','battery disconnected and removed',
                         'cable disconnected','PCB/carrier USB service corner X50.2..56.2,Y20.4..25.2 clear'],
        'validation':'CAD service/interference checks pending; electrical/load/seal validation pending'}))
    b.checkpoint('A3 bottom USB cartridge — two internal screws')


def interface():
    """Add housing aperture/support floor and cover-owned L-shaped capture key.

    Removing the cover removes the key. The cartridge then needs only2.5mm
    inward translation to clear the2.4mm wall before rearward withdrawal.
    The independent metal/PCB cartridge establishes its panel spacing; the
    outer cover key retains the assembly without claiming seal compression.
    """
    housing = b.comp('01 Shape A housing')
    if housing.attributes.itemByName(GROUP,'usb_interface_added'):
        raise RuntimeError('USB interface already exists')
    b.comp(NAMES['frame'])
    hb = housing.bRepBodies.item(0)
    _rounded(housing,'Bottom tiny bezel aperture with0.2mm clearance','-.3 mm','2.8 mm',
             14.4,8.4,1.0,'cut',hb)
    b.box(housing,'Fixed USB cartridge support floor','UsbX-13.1 mm','2.3 mm','UsbZ-9 mm',
          '26.2 mm','19.7 mm','2 mm','join')
    cover = b.comp('02 Single rear cover')
    b.box(cover,'USB inward retention key integral to rear cover','UsbX-5.1 mm','22.4 mm','UsbZ+5.2 mm',
          '10.2 mm','2 mm','CaseDepth-Cover+CoverGap-(UsbZ+5.2 mm)+0.1 mm','join')
    b.box(cover,'USB rearward retention pad integral to rear cover','UsbX-5.1 mm','20 mm','UsbZ+7.7 mm',
          '10.2 mm','4.4 mm','CaseDepth-Cover+CoverGap-(UsbZ+7.7 mm)+0.1 mm','join')
    housing.attributes.add(GROUP,'usb_interface_added','true')
    housing.attributes.add(GROUP,'usb_support_limits','Nominal2mm fixed support floor; tiny14.4x8.4 aperture; bezel-to-housing seam unqualified. Cover captures cartridge with0.5mm nominal axial/rear stop gaps.')
    b.checkpoint('A3 hidden USB housing and rear cover capture')


def run(_context):
    raise RuntimeError('Call build() and interface() explicitly inside owned A3')
