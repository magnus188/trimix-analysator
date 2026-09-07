"""A2 educational 3D placement, with audited CLI netlist as pin authority.

prepare -> KiCad MCP create_board_from_schematic -> layout.
Placeholder packages are assigned only in a temporary schematic copy.
"""
from pathlib import Path
import hashlib,json,shutil,sys,tempfile,xml.etree.ElementTree as ET
from analyzer_sheet import P,HW,VERIFY,PROJECT,tag,child,children,sx
LIBROOT=Path('/Applications/KiCad/KiCad.app/Contents/SharedSupport')
DEST=P/'preview'; PV=VERIFY/'preview'; BOARD=DEST/'Trimix_Analyzer_Preview.kicad_pcb'
HEADER='Connector_PinHeader_2.54mm:PinHeader_1x02_P2.54mm_Vertical'
PLACEHOLDERS={
 'D101':'LED_SMD:LED_0805_2012Metric',
 'J101':'Connector_Wire:SolderWire-0.25sqmm_1x02_P4.2mm_D0.65mm_OD1.7mm',
 'J102':'Connector_Wire:SolderWire-0.25sqmm_1x02_P4.2mm_D0.65mm_OD1.7mm',
 'J103':HEADER,'L101':'Inductor_SMD:L_Wuerth_HCM-7050',
 'SW101':'Button_Switch_THT:SW_PUSH_6mm',
 'J301':'Connector_PinHeader_2.54mm:PinHeader_2x13_P2.54mm_Vertical',
 'J402':'Connector_Coaxial:SMB_Jack_Vertical',
 'J801':HEADER,'J802':HEADER,
}
MODEL_SUBS={
 'L701':'${KICAD10_3DMODEL_DIR}/Inductor_SMD.3dshapes/L_Coilcraft_XAL4020-XXX.step',
 'L201':'${KICAD10_3DMODEL_DIR}/Inductor_SMD.3dshapes/L_Coilcraft_XAL4020-XXX.step',
 'U301':'${KICAD10_3DMODEL_DIR}/Package_DFN_QFN.3dshapes/DFN-8-1EP_2x2mm_P0.5mm_EP0.6x1.2mm.step',
 'J402':'${KICAD10_3DMODEL_DIR}/Connector_Coaxial.3dshapes/SMA_Amphenol_132134-10_Vertical.step',
}
NO_BODY_MODELS={'J101','J102'}
def hashes():return {p.name:hashlib.sha256(p.read_bytes()).hexdigest() for p in P.glob('*.kicad_sch')}
def prepare():
    assert not BOARD.exists(),'Refuse to overwrite an existing user-editable preview.'
    audit=json.loads((VERIFY/'connectivity-audit.json').read_text());assert audit['result']=='PASS'
    assert audit['source_hashes']==hashes(),'Re-export and audit after schematic changes.'
    DEST.mkdir(exist_ok=True);PV.mkdir(exist_ok=True)
    stage=Path(tempfile.mkdtemp(prefix='trimix-analyzer-preview-'))
    for src in P.iterdir():
        if src.suffix in {'.kicad_sch','.kicad_sym','.kicad_pro'} or src.name=='sym-lib-table':shutil.copy2(src,stage/src.name)
    components={};offboard=[];missing=[]
    for path in stage.glob('*.kicad_sch'):
        a=sx.loads(path.read_text())
        for sy in children(a,'symbol'):
            props={v[1]:v for v in children(sy,'property')};ref=props['Reference'][2]
            if ref.startswith('#'):continue
            if str(child(sy,'on_board')[1])=='no':offboard.append(ref);continue
            ident=props['Footprint'][2];placeholder=not ident
            if placeholder:
                assert ref in PLACEHOLDERS,(ref,'No reviewed preview placeholder')
                ident=PLACEHOLDERS[ref];props['Footprint'][2]=ident
            lib,name=ident.split(':');fp=sx.loads((LIBROOT/'footprints'/(lib+'.pretty')/(name+'.kicad_mod')).read_text())
            models=[] if ref in NO_BODY_MODELS else [MODEL_SUBS[ref]] if ref in MODEL_SUBS else [m[1] for m in children(fp,'model')]
            absent=[m for m in models if not Path(m.replace('${KICAD10_3DMODEL_DIR}',str(LIBROOT/'3dmodels'))).exists()]
            if absent:missing.append({'reference':ref,'models':absent})
            components[ref]={'value':props['Value'][2],'sheet':path.stem,'footprint':ident,'placeholder_footprint':placeholder,'dnp':str(child(sy,'dnp')[1])=='yes','models':models,'approximate_model':ref in MODEL_SUBS,'model_absence_expected':not models and lib=='Connector_Wire'}
        path.write_text(sx.dumps(a)+'\n')
    assert not missing,missing
    manifest={'status':'Unrouted educational placement, not mechanical or electrical release','source_hashes':hashes(),'staged_schematic':str(stage/(PROJECT+'.kicad_sch')),'board':str(BOARD),'components':components,'offboard_excluded':sorted(offboard),'board_size_mm':[186,150],'placeholder_model_notes':{'J402':'SMA body used only as a visibly approximate coax placeholder; NOT the actual SMB model','L201':'Approximate family body','L701':'Approximate inductor body','U301':'Approximate exposed-pad package body'},'battery_connection':'J102 wire pads represent PCB end of an RCY/BEC mating pigtail. Holder plug remains on its cable.'}
    (PV/'manifest.json').write_text(json.dumps(manifest,indent=2)+'\n')
    print(json.dumps({k:manifest[k] for k in ['staged_schematic','board','offboard_excluded','status']},indent=2))

def layout():
    import pcbnew as pcb
    m=json.loads((PV/'manifest.json').read_text());assert hashes()==m['source_hashes']
    b=pcb.LoadBoard(str(BOARD));assert not b.GetTracks() and not list(b.GetDrawings())
    comps=m['components'];fps={f.GetReference():f for f in b.GetFootprints()}
    assert set(fps)==set(comps),(set(comps)-set(fps),set(fps)-set(comps))
    def vec(x,y):return pcb.VECTOR2I(pcb.FromMM(x),pcb.FromMM(y))
    def txt(text,x,y,size=.9,layer=pcb.F_SilkS):
        t=pcb.PCB_TEXT(b);t.SetText(text);t.SetPosition(vec(x,y));t.SetTextSize(vec(size,size));t.SetTextThickness(pcb.FromMM(.13));t.SetLayer(layer);b.Add(t)
    def line(x1,y1,x2,y2,layer=pcb.F_SilkS,width=.15):
        t=pcb.PCB_SHAPE();t.SetShape(pcb.SHAPE_T_SEGMENT);t.SetStart(vec(x1,y1));t.SetEnd(vec(x2,y2));t.SetLayer(layer);t.SetWidth(pcb.FromMM(width));b.Add(t)
    def rect(x,y,w,h,layer=pcb.F_SilkS):
        for a,c in [((x,y),(x+w,y)),((x+w,y),(x+w,y+h)),((x+w,y+h),(x,y+h)),((x,y+h),(x,y))]:line(*a,*c,layer,.05 if layer==pcb.Edge_Cuts else .15)
    root=ET.parse(VERIFY/(PROJECT+'-netlist.xml')).getroot();expected={};nets={}
    for net in root.findall('./nets/net'):
        name=net.attrib['name'];item=b.FindNet(name)
        if not item:item=pcb.NETINFO_ITEM(b,name);b.Add(item)
        nets[name]=item
        for n in net.findall('node'):
            if n.attrib['ref'] in fps:expected[(n.attrib['ref'],n.attrib['pin'])]=name
    repaired=[]
    for ref,fp in fps.items():
        for pad in fp.Pads():
            no=pad.GetNumber()
            if not no:continue
            key=(ref,no);assert key in expected,key
            if pad.GetNetname()!=expected[key]:repaired.append(key)
            pad.SetNet(nets[expected[key]])
        fp.SetDNP(comps[ref]['dnp']);fp.Reference().SetVisible(False);fp.Value().SetVisible(False)
        if ref in NO_BODY_MODELS:fp.Models().clear()
        if ref in MODEL_SUBS:
            fp.Models().clear();model=pcb.FP_3DMODEL();model.m_Filename=MODEL_SUBS[ref]
            if ref=='J402':model.m_Scale.x=.7;model.m_Scale.y=.7;model.m_Scale.z=.7
            fp.Add3DModel(model)
    rect(100,80,186,150,pcb.Edge_Cuts)
    txt('TRIMIX ANALYSER  /  A2  /  UNROUTED 3D STUDY',193,85,1.8)
    groups=[('Charging','01 CHARGER + PACK'),('Supply_5V','02 SWITCHED 5 V'),('Gauge_Interface','03 GUITION + GAUGE'),('Oxygen','04 OXYGEN x2'),('Helium','05 MD62 BRIDGE'),('Environment','06 HUMIDITY'),('Carbon_Monoxide','07 EXPERIMENTAL CO'),('Power_Control','08 PUSH BUTTON')]
    positions={}
    for ix,(sheet,title) in enumerate(groups):
        ox=103+(ix%3)*61;oy=91+(ix//3)*44;rect(ox,oy,58,41);txt(title,ox+29,oy+3,1.2)
        refs=[ref for ref in fps if comps[ref]['sheet']==sheet]
        # Make room for connector bodies; this is a readable arrangement, not power-loop placement.
        def order(ref):return (0 if ref.startswith('J') else 1 if ref.startswith('U') else 2 if ref.startswith(('L','RV','SW')) else 3,ref)
        x=ox+3;y=oy+9;rowh=0
        for ref in sorted(refs,key=order):
            fp=fps[ref];angle=90 if ref.startswith('J') and ref!='J402' else 0
            fp.SetOrientationDegrees(angle);fp.SetPosition(vec(0,0))
            boxes=[g.GetBoundingBox() for g in fp.GraphicalItems() if g.GetLayer()==pcb.F_CrtYd]
            if boxes:
                left=min(v.GetLeft() for v in boxes);right=max(v.GetRight() for v in boxes);top=min(v.GetTop() for v in boxes);bottom=max(v.GetBottom() for v in boxes)
            else:
                bb=fp.GetBoundingBox(False,False);left=bb.GetLeft();right=bb.GetRight();top=bb.GetTop();bottom=bb.GetBottom()
            left=pcb.ToMM(left);right=pcb.ToMM(right);top=pcb.ToMM(top);bottom=pcb.ToMM(bottom)
            w=max(right-left,2.5);h=max(bottom-top,2.5)
            if x+w>ox+55:x=ox+3;y+=rowh+2.5;rowh=0
            assert y+h<=oy+39,(sheet,ref,'tile overflow',y+h,oy+39)
            px=x-left;py=y-top;fp.SetPosition(vec(px,py));positions[ref]=[px,py,angle]
            txt(ref,x+w/2,y+h+1.1,.65,pcb.F_Fab)
            if ref.startswith('U'):txt(comps[ref]['value'].split(' / ')[0],x+w/2,y+h+1.3,.65)
            x+=w+2.5;rowh=max(rowh,h)
    rect(225,179,58,41)
    txt('REMOTE HARNESS CONNECTIONS',254,183,1)
    txt('AO2  /  insulated SMB\nMD62  /  BME280  /  ZE07-CO\nPanel button + LED\nProtected RCY/BEC pack pigtail',254,195,.95)
    txt('CHARGE ARM: OPEN FOR TESTING',254,211,.9)
    txt('PLACEHOLDER CONNECTORS / MODELS\nNO COPPER TRACKS OR ROUTING',254,216,.75)
    txt('Physical board size is a study assumption; enclosure and final layout pending.',193,225,.9)
    b.GetTitleBlock().SetTitle('Trimix analyser A2 — unrouted educational placement')
    b.GetTitleBlock().SetRevision('A2-preview');b.GetTitleBlock().SetComment(0,'Not for manufacture. See preview manifest for provisional packages/models.')
    b.GetDesignSettings().SetBoardThickness(pcb.FromMM(1.6));pcb.SaveBoard(str(BOARD),b)
    (DEST/'Trimix_Analyzer_Preview.kicad_pro').write_text(json.dumps({'meta':{'filename':'Trimix_Analyzer_Preview.kicad_pro','version':1}},indent=2)+'\n')
    check=pcb.LoadBoard(str(BOARD));actual={}
    for fp in check.GetFootprints():
        for pad in fp.Pads():
            if pad.GetNumber():
                key=(fp.GetReference(),pad.GetNumber());name=pad.GetNetname()
                assert key not in actual or actual[key]==name;actual[key]=name
    assert actual==expected,{'missing':list(set(expected)-set(actual)),'different':[k for k in actual if actual[k]!=expected.get(k)]}
    assert hashes()==m['source_hashes']
    out={'result':'PASS','board_components':len(fps),'numbered_pins':len(actual),'tracks':len(check.GetTracks()),'zones':len(list(check.Zones())),'source_schematics_unchanged':True,'all_pad_nets_match_kicad_cli':True,'mcp_import_pad_nets_corrected':len(repaired),'offboard_excluded':m['offboard_excluded'],'positions':positions}
    (PV/'audit.json').write_text(json.dumps(out,indent=2)+'\n');print(json.dumps({k:v for k,v in out.items() if k!='positions'},indent=2))

if __name__=='__main__':{'prepare':prepare,'layout':layout}[sys.argv[1]]()
