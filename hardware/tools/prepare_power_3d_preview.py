"""Prepare an isolated KiCad placement preview; never changes working schematics.

Run `prepare`, create_board_from_schematic via the KiCad MCP using the printed
paths, then run `layout`. Requires the KiCad MCP Python environment.
"""
from pathlib import Path
from hashlib import sha256
import csv, json, shutil, sys, tempfile, xml.etree.ElementTree as ET
import sexpdata as sx

HW = Path(__file__).resolve().parents[1]
SOURCE = HW / 'kicad/power'
DEST = SOURCE / 'preview'
VERIFY = HW / 'verification/power/preview'
BOARD = DEST / 'Trimix_Power_Preview.kicad_pcb'
LIBS = Path('/Applications/KiCad/KiCad.app/Contents/SharedSupport')
HEADER = 'Connector_PinHeader_2.54mm:PinHeader_1x02_P2.54mm_Vertical'
TERMINAL = 'TerminalBlock_Phoenix:TerminalBlock_Phoenix_MKDS-1,5-2-5.08_1x02_P5.08mm_Horizontal'
PLACEHOLDERS = {
    'D101': 'LED_SMD:LED_0805_2012Metric',
    'J101': TERMINAL, 'J102': TERMINAL, 'J103': HEADER,
    'L101': 'Inductor_SMD:L_Wuerth_HCM-7050',
    'SW101': 'Button_Switch_THT:SW_PUSH_6mm', 'J201': HEADER,
    'J301': TERMINAL,
    'J302': 'Connector_PinHeader_2.54mm:PinHeader_1x07_P2.54mm_Vertical',
}
MODEL_PLACEHOLDERS = {
    'L201': '${KICAD10_3DMODEL_DIR}/Inductor_SMD.3dshapes/L_Coilcraft_XAL4020-XXX.step',
    'U301': '${KICAD10_3DMODEL_DIR}/Package_DFN_QFN.3dshapes/DFN-8-1EP_2x2mm_P0.5mm_EP0.6x1.2mm.step',
}

def tag(x): return str(x[0]) if isinstance(x, list) and x else ''
def children(x, name): return [v for v in x if tag(v) == name]
def hashes(): return {p.name: sha256(p.read_bytes()).hexdigest() for p in SOURCE.glob('*.kicad_sch')}

def prepare():
    if BOARD.exists(): raise SystemExit('Preview already exists; refuse to overwrite user edits.')
    DEST.mkdir(exist_ok=True)
    VERIFY.mkdir(parents=True, exist_ok=True)
    stage = Path(tempfile.mkdtemp(prefix='trimix-power-3d-'))
    changed = []
    for src in SOURCE.iterdir():
        if src.suffix in {'.kicad_sch', '.kicad_sym', '.kicad_pro'} or src.name == 'sym-lib-table':
            shutil.copy2(src, stage / src.name)
    for path in stage.glob('*.kicad_sch'):
        root = sx.loads(path.read_text())
        for symbol in children(root, 'symbol'):
            props = {p[1]: p for p in children(symbol, 'property')}
            ref = props.get('Reference', ['', '', ''])[2]
            if ref in PLACEHOLDERS:
                assert not props['Footprint'][2], ref
                props['Footprint'][2] = PLACEHOLDERS[ref]
                changed.append(ref)
        path.write_text(sx.dumps(root) + '\n')
    assert set(changed) == set(PLACEHOLDERS)
    rows = list(csv.DictReader((HW/'verification/power/pcb-bom.csv').open()))
    model_status = []
    for row in rows:
        ident = row['footprint'] or PLACEHOLDERS[row['reference']]
        lib, name = ident.split(':')
        fp_path = LIBS/'footprints'/(lib+'.pretty')/(name+'.kicad_mod')
        fp = sx.loads(fp_path.read_text())
        models = [MODEL_PLACEHOLDERS[row['reference']]] if row['reference'] in MODEL_PLACEHOLDERS else [m[1] for m in children(fp, 'model')]
        missing = [m for m in models if not Path(m.replace('${KICAD10_3DMODEL_DIR}', str(LIBS/'3dmodels'))).exists()]
        assert models and not missing, (ident, missing)
        model_status.append({'reference': row['reference'], 'footprint': ident,
            'preview_placeholder': row['reference'] in PLACEHOLDERS,
            'models': models, 'all_models_exist': True})
    manifest = {'source_hashes': hashes(), 'staged_schematic': str(stage/'Trimix_Power.kicad_sch'),
        'board': str(BOARD), 'placeholder_footprints': PLACEHOLDERS,
        'placeholder_models': MODEL_PLACEHOLDERS, 'models': model_status,
        'status': 'Unrouted educational placement preview. Not for fabrication.',
        'board_size_mm': [90, 64], 'thickness_mm': 1.6}
    (VERIFY/'manifest.json').write_text(json.dumps(manifest, indent=2)+'\n')
    print(json.dumps({k:manifest[k] for k in ['staged_schematic','board','status']}, indent=2))

# Deliberately spread out to make each functional group easy to identify.
POSITIONS = {
    'J101':(108,87,0), 'J102':(126,87,0), 'J103':(146,85,0),
    'J301':(177,87,0), 'J302':(183,117,0),
    'U101':(116,107,0), 'L101':(127,107,0),
    'C101':(107,102,90), 'C102':(111,101,0), 'C103':(122,101,0),
    'C104':(123,115,90), 'C105':(127,115,90),
    'C106':(115,115,90), 'C107':(109,111,90),
    'R101':(105,116,0), 'R102':(105,119,0), 'R103':(109,115,0),
    'Q101':(132,117,0), 'R104':(130,112,0), 'R105':(132,121,0),
    'D101':(115,121,0), 'R106':(119,121,0), 'R107':(119,116,0),
    'SW101':(109,130,0),
    'U201':(159,107,0), 'L201':(166,107,0),
    'C201':(153,102,90), 'C202':(153,107,90), 'C203':(154,112,0),
    'C204':(174,102,90), 'C205':(174,107,90), 'C206':(174,112,90),
    'R201':(162,114,0), 'R202':(158,117,0), 'R203':(154,120,0),
    'J201':(161,131,0),
    'U301':(141,131,0), 'C301':(137,131,90), 'R301':(145,131,0),
    'R302':(137,136,0), 'R303':(145,136,0),
}

def layout():
    import pcbnew as pcb
    manifest = json.loads((VERIFY/'manifest.json').read_text())
    assert hashes() == manifest['source_hashes'], 'Working schematic changed since preview import.'
    b = pcb.LoadBoard(str(BOARD))
    assert len(b.GetTracks()) == 0 and not list(b.GetDrawings()), 'Preview has been edited already.'
    fps = {fp.GetReference():fp for fp in b.GetFootprints()}
    assert set(fps) == set(POSITIONS), (set(POSITIONS)-set(fps), set(fps)-set(POSITIONS))
    # MCP's geometric schematic parser missed junctions in this hierarchy.
    # KiCad's own audited CLI netlist is the authority for every numbered pad.
    netlist=ET.parse(HW/'verification/power/Trimix_Power-netlist.xml').getroot()
    expected={}
    nets={}
    for net in netlist.findall('./nets/net'):
        name=net.attrib['name']
        item=b.FindNet(name)
        if not item:
            item=pcb.NETINFO_ITEM(b,name); b.Add(item)
        nets[name]=item
        for node in net.findall('node'): expected[(node.attrib['ref'],node.attrib['pin'])]=name
    repaired=[]
    for ref,fp in fps.items():
        for pad in fp.Pads():
            if not pad.GetNumber(): continue
            key=(ref,pad.GetNumber())
            assert key in expected, key
            if pad.GetNetname()!=expected[key]: repaired.append(list(key))
            pad.SetNet(nets[expected[key]])
    def vec(x,y): return pcb.VECTOR2I(pcb.FromMM(x), pcb.FromMM(y))
    for ref, (x,y,angle) in POSITIONS.items():
        fp = fps[ref]
        fp.SetPosition(vec(x,y)); fp.SetOrientationDegrees(angle)
        fp.SetDNP(ref in {'R302','R303'})
        if ref in MODEL_PLACEHOLDERS:
            fp.Models().clear()
            model=pcb.FP_3DMODEL(); model.m_Filename=MODEL_PLACEHOLDERS[ref]
            fp.Add3DModel(model)
        fp.Value().SetVisible(False)
        fp.Reference().SetVisible(False)
    def text(label,x,y,size=.8,layer=pcb.F_SilkS):
        item=pcb.PCB_TEXT(b); item.SetText(label); item.SetPosition(vec(x,y))
        item.SetTextSize(vec(size,size)); item.SetTextThickness(pcb.FromMM(.12))
        item.SetLayer(layer); b.Add(item)
    def line(x1,y1,x2,y2,layer=pcb.F_SilkS,width=.15):
        item=pcb.PCB_SHAPE(); item.SetShape(pcb.SHAPE_T_SEGMENT)
        item.SetStart(vec(x1,y1)); item.SetEnd(vec(x2,y2))
        item.SetLayer(layer); item.SetWidth(pcb.FromMM(width)); b.Add(item)
    for x1,y1,x2,y2 in [(100,80,190,80),(190,80,190,144),(190,144,100,144),(100,144,100,80)]:
        line(x1,y1,x2,y2,pcb.Edge_Cuts,.05)
    for x1,y1,x2,y2 in [(102,94,135,94),(135,94,135,123),(135,123,102,123),
                         (102,123,102,94),(151,94,177,94),(177,94,177,123),
                         (177,123,151,123),(151,123,151,94),(133,124,150,124),
                         (150,124,150,139),(150,139,133,139),(133,139,133,124)]:
        line(x1,y1,x2,y2)
    text('01  CHARGER',118.5,96,1.1)
    text('BQ25895',116,110,.7)
    text('02  5V SUPPLY',164,96,1.1)
    text('TPS63020',162,99,.8)
    text('03  FUEL GAUGE',141.5,126,1)
    text('MAX17048',141.5,128,.7)
    text('USB 5V IN',110.5,92.7,.75)
    text('PROTECTED PACK',128.5,92.7,.75)
    text('PACK NTC',143,92.7,.75)
    text('5V TO GUITION',179.5,92.7,.75)
    text('HOST LOGIC',183,136,.75)
    text('BQ WAKE / RESET',112,138,.8)
    text('SHORT = OFF',161,138,.8)
    text('TRIMIX POWER | P1.1 | 3D PREVIEW - UNROUTED',145,141.5,1)
    text('PREVIEW ONLY: 9 PLACEHOLDER PACKAGES; FINAL PARTS AND LAYOUT PENDING',145,142,.9,pcb.B_SilkS)
    # Reference labels placed on the assembly drawing; 3D silk stays legible.
    for ref,(x,y,a) in POSITIONS.items(): text(ref,x,y-2,.65,pcb.F_Fab)
    b.GetTitleBlock().SetTitle('Trimix Power - UNROUTED 3D PLACEMENT PREVIEW')
    b.GetTitleBlock().SetRevision('P1.1-preview')
    b.GetTitleBlock().SetComment(0,'Nine placeholder packages. Not for manufacture or electrical validation.')
    b.GetDesignSettings().SetBoardThickness(pcb.FromMM(1.6))
    pcb.SaveBoard(str(BOARD),b)
    # Compare actual PCB pad memberships against the audited schematic export.
    b=pcb.LoadBoard(str(BOARD))
    actual={}
    groups={}
    for fp in b.GetFootprints():
        for pad in fp.Pads():
            key=(fp.GetReference(),pad.GetNumber())
            if not key[1]: continue
            name=pad.GetNetname()
            if key in actual: assert actual[key]==name
            actual[key]=name
            groups.setdefault(name,set()).add(key)
    # The MCP may choose different auto-net names; membership is authoritative.
    expected_groups={}
    for key,name in expected.items(): expected_groups.setdefault(name,set()).add(key)
    mismatches=[]
    for name,group in expected_groups.items():
        seen=groups.get(actual.get(next(iter(group))),set())
        if seen!=group: mismatches.append({'schematic_net':name,'expected':sorted(group),'actual':sorted(seen)})
    assert set(actual)==set(expected), (set(expected)-set(actual),set(actual)-set(expected))
    assert not mismatches, mismatches
    assert hashes()==manifest['source_hashes']
    audit={'status':'PASS', 'components':len(fps),'logical_pins':len(actual),
        'net_memberships_preserved':True, 'schematics_unchanged':True,
        'track_count':len(b.GetTracks()), 'dnp':['R302','R303'],
        'all_models_exist':True, 'preview_only_footprints':sorted(PLACEHOLDERS),
        'preview_only_models':MODEL_PLACEHOLDERS,
        'mcp_import_pad_assignments_corrected_from_kicad_cli':repaired,
        'scope':'Import/model availability check only; no safety or routing approval.'}
    (VERIFY/'audit.json').write_text(json.dumps(audit,indent=2)+'\n')
    print(json.dumps(audit,indent=2))

if __name__=='__main__':
    {'prepare':prepare,'layout':layout}[sys.argv[1]]()
