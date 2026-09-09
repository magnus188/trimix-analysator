"""Create and audit the A3 main-board mechanical placement using KiCad Python.

Run with KiCad's bundled Python 3.9. No UI, MCP, routing, schematic edits or
manufacturing exports. All 119 electrical footprints retain their CLI XML nets.
Bounding boxes guide initial placement; native KiCad courtyard polygons are
independently checked afterward. This is a placement candidate, not a release.
"""
from pathlib import Path
import argparse
import hashlib
import json
import math
import re
import shutil
import subprocess
import xml.etree.ElementTree as ET
import pcbnew as pcb

HW = Path(__file__).resolve().parents[3]
PROJECT = HW / 'pcb/analyzer'
SOURCE = PROJECT / 'previews/Trimix_Analyzer_Preview.kicad_pcb'
BOARD = PROJECT / 'Trimix_Analyzer.kicad_pcb'
VERIFY = HW / 'pcb/integration/verification'
MANIFEST = HW / 'pcb/verification/analyzer/previews/manifest.json'
CLI = '/Applications/KiCad/KiCad.app/Contents/MacOS/kicad-cli'
POLYGON = [(0, 0), (8.6, 0), (8.6, 17), (30, 17), (30, 99),
           (5.8, 99), (5.8, 94.8), (0, 94.8)]
HOLES = [(25.6, 92), (4.4, 6)]
EDGE_MARGIN = 0.50
COURTYARD_GAP = 0.15
TOOL_RADIUS = 3.0
COPPER_RADIUS = 2.4

# Coordinates are courtyard centres, not pin-1 positions. KiCad +y points down.
# The long Guition connector stays near the side; sensor interfaces are upper;
# three power stages and the protected-pack/USB inputs occupy the lower region.
ANCHORS = {
    'J401': (4.4, 14.1, 0), 'J402': (4.9, 27, 0),
    'J601': (22.7, 21, 180), 'J701': (22.7, 29, 180),
    'J501': (4, 37.5, 0), 'J301': (26, 54, 0),
    'RV501': (11.5, 42.5, 0),
    'U401': (12.6, 22, 0), 'U502': (12.6, 33, 0),
    'U501': (4, 45.7, 90),
    'Q601': (19.5, 35, 0), 'Q602': (20.5, 39.2, 0),
    'C601': (19.5, 42.1, 0),
    'U702': (19, 45.4, 0), 'U703': (13, 49, 0),
    'J801': (5, 51.5, 90), 'J802': (7, 55.3, 90),
    'U801': (13.6, 55, 0), 'L701': (19.5, 51.2, 90),
    'U701': (19.5, 56.3, 0),
    'U201': (13, 61, 0), 'L201': (13, 66, 0),
    'C201': (18, 61, 0), 'C202': (18, 63.6, 0),
    'C204': (7.6, 61, 0), 'C205': (7.6, 63.6, 0),
    'C206': (7.6, 66.2, 0),
    'U301': (18, 69.8, 0), 'C301': (18, 67, 0),
    'J104': (4, 71, 0), 'J103': (4, 79, 0),
    'L101': (13.5, 77, 90), 'U101': (13, 84, 0),
    'C102': (8.3, 83.5, 90), 'C103': (19, 82.3, 90),
    'C106': (18.5, 86, 0), 'C107': (18.5, 88.5, 0),
    'C104': (20, 72.3, 0), 'C105': (20, 74.6, 0),
    'C101': (3, 84, 0), 'SW101': (5.4, 90, 0),
    'J102': (17, 93, 0), 'J101': (15.5, 97, 0),
    'C401': (4.4, 20.5, 0), 'C402': (7.65, 20.5, 0),
    'C403': (6.9, 32.3, 0), 'C404': (10.95, 26.75, 0),
    'C405': (14.15, 26.75, 0), 'C406': (10.95, 28.5, 0),
    'C407': (14.15, 25, 0), 'C408': (1.3, 36.3, 90),
    'C409': (9.1, 36.3, 0),
    'R401': (9, 18.5, 0), 'R402': (12.5, 18.5, 0),
    'R403': (1.3, 19.2, 90), 'R404': (1.3, 33, 90),
    'R405': (10.95, 25, 0), 'R406': (14.15, 28.5, 0),
    'R407': (10.95, 30.25, 0), 'R408': (14.15, 30.25, 0),
    'R409': (12.25, 36.3, 0), 'R410': (15.5, 36.4, 0),
    'R506': (9, 38.4, 0), 'R507': (12.25, 38.4, 0),
    'C506': (15.5, 38.4, 0), 'C507': (6.65, 38.1, 90),
    'C508': (16.65, 34.025, 90), 'C501': (4, 42.7, 0),
    'C502': (4, 48.7, 0), 'R502': (1.3, 39.6, 90),
    'R503': (1.3, 42.85, 90), 'R501': (2.2, 54.2, 0),
    'C503': (8.5, 46.3, 0), 'C504': (8.5, 48.1, 0),
    'C505': (9.7, 51.5, 90),
    'R704': (24.75, 33.4, 0), 'R705': (28, 33.4, 0),
    'TP1006': (22.6, 35.4, 0), 'TP1008': (24.85, 35.4, 0),
    'TP1009': (27.1, 35.4, 0), 'TP1010': (1.1, 46.2, 0),
    'TP1011': (7.8, 34.2, 0), 'TP1012': (15.6, 46.5, 0),
    'R701': (17.35, 56.3, 90), 'R702': (18.5, 58.65, 0),
}
TP_TARGETS = {'TP1001':(22,66), 'TP1002':(23,83), 'TP1003':(21,92),
              'TP1004':(21,73), 'TP1005':(11,69), 'TP1007':(19,60)}
TARGETS = {
    'Oxygen': (12, 26), 'Helium': (11, 37), 'Environment': (21, 35),
    'Carbon_Monoxide': (18, 50), 'Power_Control': (11, 54),
    'Supply_5V': (13, 64), 'Gauge_Interface': (20, 68), 'Charging': (18, 82),
}
BANDS = {'Oxygen': (17.5, 42), 'Helium': (30, 52), 'Environment': (30, 80),
         'Carbon_Monoxide': (38, 75), 'Power_Control': (43, 90),
         'Supply_5V': (56, 78), 'Gauge_Interface': (45, 80), 'Charging': (66, 98.5)}


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def vec(x, y):
    return pcb.VECTOR2I(pcb.FromMM(x), pcb.FromMM(y))


def saved_hashes():
    return {str(p.relative_to(HW)): sha(p) for p in
            [SOURCE, MANIFEST, *PROJECT.glob('*.kicad_sch'), *PROJECT.glob('*.kicad_pro')]}


def strip_preview_drawings(text, replace_u201=False):
    """Drop board art and optionally the superseded U201; avoid Remove/SWIG bug."""
    ranges = []; depth = 0; quoted = False; escape = False; start = None
    for i, char in enumerate(text):
        if quoted:
            if escape: escape = False
            elif char == '\\': escape = True
            elif char == '"': quoted = False
            continue
        if char == '"': quoted = True
        elif char == '(':
            if depth == 1: start = i
            depth += 1
        elif char == ')':
            depth -= 1
            if depth == 1 and start is not None:
                node = text[start:i+1]
                if node.startswith('(gr_') or (replace_u201 and node.startswith('(footprint ') and re.search(r'\(property\s+"Reference"\s+"U201"',node)):
                    ranges.append((start, i+1))
                start = None
    if depth or quoted: raise ValueError('Unbalanced source board syntax')
    for start, end in reversed(ranges): text = text[:start]+text[end:]
    return text


def polygon(points):
    result = pcb.SHAPE_POLY_SET()
    result.NewOutline()
    for x, y in points:
        result.Append(pcb.FromMM(x), pcb.FromMM(y))
    return result


def courtyard_box(fp):
    fp.BuildCourtyardCaches()
    shape = fp.GetCourtyard(pcb.F_Cu)
    if shape.OutlineCount() < 1:
        raise ValueError('Missing real front courtyard: ' + fp.GetReference())
    points = [shape.Outline(j).CPoint(i) for j in range(shape.OutlineCount())
              for i in range(shape.Outline(j).PointCount())]
    return [pcb.ToMM(min(q.x for q in points)), pcb.ToMM(min(q.y for q in points)),
            pcb.ToMM(max(q.x for q in points)), pcb.ToMM(max(q.y for q in points))]


def dimensions(fp, angle):
    fp.SetPosition(vec(0, 0))
    fp.SetOrientationDegrees(angle)
    box = courtyard_box(fp)
    return (box[2]-box[0], box[3]-box[1], (box[0]+box[2])/2, (box[1]+box[3])/2)


def centred(fp, x, y, angle, dims):
    w, h, ox, oy = dims[(fp.GetReference(), angle)]
    fp.SetOrientationDegrees(angle)
    fp.SetPosition(vec(x-ox, y-oy))
    return (x-w/2, y-h/2, x+w/2, y+h/2)


def fits(box, occupied, testpad=False):
    l, t, r, b = box
    # Bare test pads may have a probe courtyard closer to the edge; their actual
    # copper pad still needs >=0.50 mm edge clearance (checked independently).
    m = 0.0 if testpad else EDGE_MARGIN
    if l < m or r > 30-m or t < m or b > 99-m:
        return False
    if r > 8.6-m and t < 17+m:
        return False
    if l < 5.8+m and b > 94.8-m:
        return False
    for x, y in HOLES:
        dx, dy = max(l-x, 0, x-r), max(t-y, 0, y-b)
        if dx*dx+dy*dy < (TOOL_RADIUS+COURTYARD_GAP)**2:
            return False
    g = COURTYARD_GAP
    return all(r+g <= q[0] or q[2]+g <= l or b+g <= q[1] or q[3]+g <= t
               for q in occupied.values())


def add_outline(board):
    for start, end in zip(POLYGON, POLYGON[1:]+POLYGON[:1]):
        line = pcb.PCB_SHAPE()
        line.SetShape(pcb.SHAPE_T_SEGMENT)
        line.SetLayer(pcb.Edge_Cuts)
        line.SetWidth(pcb.FromMM(0.05))
        line.SetStart(vec(*start)); line.SetEnd(vec(*end)); board.Add(line)


def add_holes_and_rules(board):
    for i, (x, y) in enumerate(HOLES, 1):
        fp = pcb.FOOTPRINT(board)
        fp.SetReference('H'+str(i)); fp.SetValue('M2 NPTH 2.30')
        fp.SetFPID(pcb.LIB_ID('', 'Mechanical_M2_NPTH_2.30mm'))
        fp.SetAttributes(pcb.FP_THROUGH_HOLE | pcb.FP_BOARD_ONLY | pcb.FP_EXCLUDE_FROM_BOM | pcb.FP_EXCLUDE_FROM_POS_FILES)
        fp.SetAllowMissingCourtyard(True)
        fp.SetPosition(vec(x, y)); fp.Reference().SetVisible(False); fp.Value().SetVisible(False)
        pad = pcb.PAD(fp); pad.SetAttribute(pcb.PAD_ATTRIB_NPTH); pad.SetShape(pcb.PAD_SHAPE_CIRCLE)
        pad.SetNumber(''); pad.SetSize(vec(2.3, 2.3)); pad.SetDrillSize(vec(2.3, 2.3))
        pad.SetLayerSet(pcb.LSET.AllCuMask(4)); pad.SetPosition(vec(x, y)); fp.Add(pad); board.Add(fp)
        for radius, footprints in ((COPPER_RADIUS, False), (TOOL_RADIUS, True)):
            zone = pcb.ZONE(board); zone.SetIsRuleArea(True)
            zone.SetZoneName(('Driver Ø6 component' if footprints else 'M2 head Ø4.8 copper')+' H'+str(i))
            layers = pcb.LSET.AllCuMask(4)
            if footprints:
                layers = pcb.LSET(); layers.AddLayer(pcb.F_Cu)
            zone.SetLayerSet(layers)
            zone.SetDoNotAllowFootprints(footprints)
            zone.SetDoNotAllowPads(not footprints); zone.SetDoNotAllowTracks(not footprints)
            zone.SetDoNotAllowVias(not footprints); zone.SetDoNotAllowZoneFills(not footprints)
            zone.Outline().NewOutline()
            # Circumscribed 96-gon conservatively encloses the requested circle.
            rr = radius / math.cos(math.pi/96)
            for j in range(96):
                a = 2*math.pi*j/96
                zone.Outline().Append(pcb.FromMM(x+rr*math.cos(a)), pcb.FromMM(y+rr*math.sin(a)))
            if not footprints:
                # This copper exclusion is an annulus: the NPTH interior has no
                # copper, and must not be reported as violating its own rule.
                void=polygon([(x+1.16*math.cos(2*math.pi*j/96),y+1.16*math.sin(2*math.pi*j/96))for j in range(96)])
                zone.Outline().BooleanSubtract(void)
            board.Add(zone)


def xml_nets(board, path):
    refs = {f.GetReference() for f in board.GetFootprints() if not f.GetReference().startswith('H')}
    expected = {}
    for net in ET.parse(path).getroot().findall('./nets/net'):
        for node in net.findall('node'):
            if node.attrib['ref'] in refs:
                expected[(node.attrib['ref'], node.attrib['pin'])] = net.attrib['name']
    actual = {}
    for fp in board.GetFootprints():
        for pad in fp.Pads():
            if not pad.GetNumber():
                continue
            key = (fp.GetReference(), pad.GetNumber())
            if key in actual and actual[key] != pad.GetNetname():
                raise ValueError('Split physical pads have conflicting net: '+str(key))
            actual[key] = pad.GetNetname().replace('{slash}','/')
    if expected != actual:
        raise ValueError({'missing': sorted(set(expected)-set(actual)),
                          'extra': sorted(set(actual)-set(expected)),
                          'different': [k for k in actual if actual[k] != expected.get(k)]})
    return len(actual)


def build():
    VERIFY.mkdir(parents=True, exist_ok=True)
    receipt_path = VERIFY / 'main-placement.json'
    if BOARD.exists():
        if not receipt_path.exists() or sha(BOARD) != json.loads(receipt_path.read_text()).get('board_sha256'):
            raise RuntimeError('Refuse to overwrite an existing or externally edited main board.')
    original = saved_hashes()
    (VERIFY/'main-build-source-hashes.json').write_text(json.dumps(original,indent=2)+'\n')
    shutil.copy2(PROJECT/'Trimix_Analyzer.kicad_pro',VERIFY/'main-build-project-before.kicad_pro')
    manifest = json.loads(MANIFEST.read_text())
    staged = VERIFY / 'main-preview-input.kicad_pcb'
    staged.write_text(strip_preview_drawings(SOURCE.read_text()))
    board = pcb.LoadBoard(str(staged))
    refs = {f.GetReference(): f for f in board.GetFootprints()}
    assert set(refs) == set(manifest['components']) and len(refs) == 119
    netlist = VERIFY / 'main-current-netlist.xml'
    subprocess.run([CLI, 'sch', 'export', 'netlist', '--format', 'kicadxml',
                    '-o', str(netlist), str(PROJECT/'Trimix_Analyzer.kicad_sch')], check=True)
    xml = ET.parse(netlist).getroot()
    original_pin_count = xml_nets(board, netlist)
    assert original_pin_count == 353
    # The preview's generic DE pad/stencil is superseded by the verified TI DSJ
    # footprint. Load a new board without that one node; never mutate the preview.
    old_u201_uuid = refs['U201'].m_Uuid
    old_u201_value = refs['U201'].GetValue()
    staged.write_text(strip_preview_drawings(SOURCE.read_text(), replace_u201=True))
    board = pcb.LoadBoard(str(staged))
    refs = {f.GetReference():f for f in board.GetFootprints()}
    assert len(refs)==118 and 'U201' not in refs
    fp=pcb.FootprintLoad(str(PROJECT/'Trimix_Power.pretty'),'TI_DSJ_14')
    fp.SetReference('U201');fp.SetValue(old_u201_value);fp.SetUuidDirect(old_u201_uuid)
    fp.SetFPID(pcb.LIB_ID('Trimix_Power','TI_DSJ_14'))
    board.Add(fp);refs['U201']=fp
    components = dict(manifest['components'])
    net_by_pin = {(n.attrib['ref'], n.attrib['pin']):net.attrib['name']
                  for net in xml.findall('./nets/net') for n in net.findall('node')}
    for pad in refs['U201'].Pads():
        if pad.GetNumber():
            name=net_by_pin[('U201',pad.GetNumber())];net=board.FindNet(name)
            if not net:net=pcb.NETINFO_ITEM(board,name);board.Add(net)
            pad.SetNet(net)
    for component in xml.findall('./components/comp'):
        ref = component.attrib['ref']
        if ref.startswith('TP'):
            fp = pcb.FootprintLoad('/Applications/KiCad/KiCad.app/Contents/SharedSupport/footprints/TestPoint.pretty', 'TestPoint_Pad_D1.0mm')
            fp.SetReference(ref); fp.SetValue(component.findtext('value'))
            fp.SetFPID(pcb.LIB_ID('TestPoint','TestPoint_Pad_D1.0mm'))
            fp.SetAttributes(pcb.FP_EXCLUDE_FROM_BOM | pcb.FP_EXCLUDE_FROM_POS_FILES)
            board.Add(fp); refs[ref] = fp
            for pad in fp.Pads():
                name = net_by_pin[(ref,pad.GetNumber())]; net = board.FindNet(name)
                if not net: net = pcb.NETINFO_ITEM(board,name); board.Add(net)
                pad.SetNet(net)
            components[ref] = {'sheet':'Testpoints','placeholder_footprint':False,'dnp':False,'value':fp.GetValue()}
        if ref in refs:
            sheet = component.find('sheetpath')
            refs[ref].SetPath(pcb.KIID_PATH(sheet.attrib['tstamps']+component.findtext('tstamps')))
            props = {p.attrib['name']:p.attrib.get('value','') for p in component.findall('property')}
            refs[ref].SetValue(component.findtext('value') or '')
            for field_id,value in ((pcb.FIELD_T_DESCRIPTION,component.findtext('description')or ''),
                                   (pcb.FIELD_T_DATASHEET,component.findtext('datasheet')or '')):
                refs[ref].GetField(field_id).SetText(value)
                refs[ref].GetField(field_id).SetVisible(False)
            for source_field in component.findall('./fields/field'):
                name=source_field.attrib['name']
                if name in ('Reference','Value','Footprint','Datasheet','Description'):continue
                if refs[ref].HasField(name):field=refs[ref].GetField(name)
                else:
                    field=pcb.PCB_FIELD(refs[ref],pcb.FIELD_T_USER,name);refs[ref].Add(field)
                field.SetText(source_field.text or '');field.SetVisible(False)
            attr=refs[ref].GetAttributes()
            if 'exclude_from_bom' in props:attr|=pcb.FP_EXCLUDE_FROM_BOM
            else:attr &= ~pcb.FP_EXCLUDE_FROM_BOM
            refs[ref].SetAttributes(attr)
            refs[ref].SetSheetname(props.get('Sheetname',''))
            refs[ref].SetSheetfile(props.get('Sheetfile',''))
    for ref in ('U401','U502'):
        for pad in refs[ref].Pads():
            if pad.GetNumber()=='2':
                name=pad.GetNetname().replace('ALERT/RDY','ALERT{slash}RDY')
                net=board.FindNet(name)
                if not net:net=pcb.NETINFO_ITEM(board,name);board.Add(net)
                pad.SetNet(net)
    assert len(refs) == 131
    assert not board.GetTracks() and not list(board.Zones())
    assert not list(board.GetDrawings())
    board.SetCopperLayerCount(4)
    board.GetDesignSettings().SetBoardThickness(pcb.FromMM(1.6))
    board.GetDesignSettings().SetAuxOrigin(vec(0, 0))
    dims = {(ref, angle): dimensions(fp, angle) for ref, fp in refs.items() for angle in (0, 90, 180, 270)}
    occupied, positions = {}, {}
    for ref, (x, y, angle) in ANCHORS.items():
        box = centred(refs[ref], x, y, angle, dims)
        if not fits(box, occupied, ref.startswith('TP')):
            raise ValueError({'anchor_conflict': ref, 'box': box,
                              'near': {r:b for r,b in occupied.items() if not (box[2]+.15<=b[0] or b[2]+.15<=box[0] or box[3]+.15<=b[1] or b[3]+.15<=box[1])}})
        occupied[ref], positions[ref] = box, [x, y, angle]
    remaining = sorted(set(refs)-set(occupied), key=lambda r: (
        0 if r.startswith('TP') else 1 if r.startswith('C') else 2 if r.startswith(('U','Q')) else 3,
        -dims[(r, 0)][0]*dims[(r, 0)][1], r))
    for ref in remaining:
        sheet = components[ref]['sheet']
        if sheet == 'Testpoints': tx,ty = TP_TARGETS[ref]; lo,hi = 56,98.5
        else: tx, ty = TARGETS[sheet]; lo, hi = BANDS[sheet]
        fp = refs[ref]
        # A connectivity preference keeps small-net neighbours close. Global
        # power/I2C nets do not drag every part toward a common board centroid.
        nets = {p.GetNetname() for p in fp.Pads() if p.GetNumber()}
        neighbours = []
        for other in occupied:
            if components[other]['sheet'] != sheet:
                continue
            common = nets & {p.GetNetname() for p in refs[other].Pads() if p.GetNumber()}
            useful = [n for n in common if n and n not in ('GND','HOST_3V3','PACK_P','VSYS','VOUT_5V','I2C_SDA','I2C_SCL')]
            if useful:
                neighbours.append(positions[other][:2])
        if neighbours:
            tx = .35*tx + .65*sum(p[0] for p in neighbours)/len(neighbours)
            ty = .35*ty + .65*sum(p[1] for p in neighbours)/len(neighbours)
        choices = []
        for angle in (0, 90):
            w, h, _, _ = dims[(ref, angle)]
            for yi in range(math.ceil(lo*4), math.floor(hi*4)+1):
                y = yi/4
                for xi in range(3, 118):
                    x = xi/4; box = (x-w/2, y-h/2, x+w/2, y+h/2)
                    if fits(box, occupied, ref.startswith('TP')):
                        score = (x-tx)**2 + (y-ty)**2 + (0.02 if angle else 0)
                        choices.append((score, x, y, angle, box))
        if not choices:
            raise ValueError({'unplaced': ref, 'sheet': sheet, 'placed': len(occupied)})
        _, x, y, angle, box = min(choices)
        centred(fp, x, y, angle, dims); occupied[ref] = box; positions[ref] = [x, y, angle]
    for ref, fp in refs.items():
        fp.Reference().SetVisible(True); fp.Reference().SetLayer(pcb.F_Fab)
        fp.Reference().SetTextSize(vec(.65, .65)); fp.Reference().SetTextThickness(pcb.FromMM(.10))
        fp.Reference().SetPosition(fp.GetPosition()); fp.Reference().SetTextAngle(pcb.EDA_ANGLE(0, pcb.DEGREES_T))
        fp.Value().SetVisible(False)
    add_outline(board); add_holes_and_rules(board)
    title = board.GetTitleBlock()
    title.SetTitle('Trimix analyser A3 — mechanical placement candidate')
    title.SetRevision('A3-placement-01')
    title.SetComment(0, 'UNROUTED. Footprint and mechanical gates remain. Not for fabrication.')
    title.SetComment(1, '4 layers / 1.6 mm / components on F.Cu. Inner GND planes pending routing.')
    title.SetComment(2, 'Fusion X=50.4+u, Y=120-v; PCB back Z20.5, F.Cu Z22.1 mm.')
    assert xml_nets(board, netlist) == 365
    native = {}
    for ref, fp in refs.items():
        fp.BuildCourtyardCaches(); native[ref] = fp.GetCourtyard(pcb.F_Cu)
    clashes = [[a,b] for i,a in enumerate(sorted(native)) for b in sorted(native)[i+1:] if native[a].Collide(native[b], 0)]
    outside = []
    shape = polygon(POLYGON)
    for ref, court in native.items():
        difference = court.CloneDropTriangulation(); difference.BooleanSubtract(shape)
        if difference.Area() > 1:
            outside.append(ref)
    assert not clashes and not outside, (clashes, outside)
    # Check actual copper expanded by 0.5 mm, including the deliberately closer
    # probe courtyards. ERROR_OUTSIDE yields a conservative polygon approximation.
    copper_outside=[]
    for ref,fp in refs.items():
        for pad in fp.Pads():
            if not pad.IsOnLayer(pcb.F_Cu):continue
            expanded=pcb.SHAPE_POLY_SET()
            pad.TransformShapeToPolygon(expanded,pcb.F_Cu,pcb.FromMM(.5),pcb.FromMM(.001),pcb.ERROR_OUTSIDE)
            expanded.BooleanSubtract(shape)
            if expanded.Area()>1:copper_outside.append([ref,pad.GetNumber()])
    assert not copper_outside, copper_outside
    # SaveBoard also saves a project file in KiCad 10. Stage it under verification
    # so the existing user project configuration cannot be overwritten.
    staged_board = VERIFY / 'main-build-candidate.kicad_pcb'
    pcb.SaveBoard(str(staged_board), board)
    check = pcb.LoadBoard(str(staged_board)); assert xml_nets(check, netlist) == 365
    assert saved_hashes() == original, 'Source schematics, project and preview must remain unchanged.'
    shutil.copy2(staged_board, BOARD)
    receipt = {
        'status': 'mechanical_placement_candidate_not_routed_or_released',
        'board': str(BOARD.relative_to(HW)), 'board_sha256': sha(BOARD),
        'source_files_unchanged': True, 'source_hashes': original,
        'original_electrical_footprints':119, 'bare_test_pads':12,
        'electrical_footprints':131, 'mechanical_holes':2, 'numbered_pin_nets':365,
        'original_numbered_pin_nets_preserved':353,
        'all_pad_nets_match_current_cli_xml':True, 'copper_layers':check.GetCopperLayerCount(),
        'net_name_serialization':'Two unconnected ADC ALERT/RDY names use KiCad {slash} escaping; comparison decodes to the unchanged CLI XML logical names.',
        'thickness_mm':pcb.ToMM(check.GetDesignSettings().GetBoardThickness()),
        'tracks':len(check.GetTracks()), 'copper_fill_zones':sum(not z.GetIsRuleArea() for z in check.Zones()),
        'mechanical_rule_areas':sum(z.GetIsRuleArea() for z in check.Zones()),
        'all_electrical_footprints_on_front':all(f.GetLayer()==pcb.F_Cu for f in check.GetFootprints()),
        'actual_native_courtyard_collision_pairs':clashes, 'actual_native_courtyards_outside_outline':outside,
        'actual_native_copper_below_0_5mm_edge_clearance':copper_outside,
        'u201_footprint':'Trimix_Power:TI_DSJ_14; reviewed TI land and stencil example, fabrication process qualification pending',
        'outline_local_mm':POLYGON, 'holes_local_mm':HOLES, 'hole_diameter_mm':2.3,
        'minimum_courtyard_edge_margin_mm':EDGE_MARGIN, 'courtyard_bbox_gap_mm':COURTYARD_GAP,
        'bare_testpad_courtyard_edge_exception':'Bare pads may have probe courtyards within 0.5mm of an edge; copper edge clearance checked separately.',
        'tool_component_keepout_diameter_mm':6.0, 'all_layer_copper_keepout_diameter_mm':4.8,
        'positions_courtyard_centres_mm':positions,
        'positions_footprint_origins_mm':{r:[pcb.ToMM(f.GetPosition().x),pcb.ToMM(f.GetPosition().y),f.GetOrientationDegrees()]for r,f in refs.items()},
        'courtyard_bounds_mm':occupied,
        'provisional_footprints':[r for r,c in components.items() if c['placeholder_footprint']],
        'dnp_footprints':[r for r,c in components.items() if c['dnp']],
        'known_gates':['U201 TI DSJ thermal via and stencil process must be accepted by the assembler.',
          'J301 connector pitch/mating geometry unverified; J402 scaled SMA visual is not real SMB CAD.',
          'L101 and L701 current/package choices need exact orderable parts; sizes not reduced.',
          'Through-hole lead tails require carrier relief and actual solder/protrusion checks.',
          'Placement uses actual courtyards but is not a routed power-loop, thermal, EMI or analogue review.',
          'Real harness plugs, wire bends and tall-component enclosure clearance require assembly checks.'],
    }
    receipt_path.write_text(json.dumps(receipt, indent=2)+'\n')
    print(json.dumps({k:v for k,v in receipt.items() if k not in ('positions_courtyard_centres_mm','positions_footprint_origins_mm','courtyard_bounds_mm','source_hashes')},indent=2))


if __name__ == '__main__':
    parser = argparse.ArgumentParser(); parser.parse_args(); build()
