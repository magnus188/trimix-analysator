"""Drawing-based USB PCB draft. KiCad bundled Python; explicit execution only.

Land locations follow GCT Rev B. The front blend is a clearance chamfer pending
supplier/physical review, not a claim to reproduce an undimensioned blend.
"""
from pathlib import Path
import hashlib,json,math,shutil,xml.etree.ElementTree as ET
import pcbnew as p
ROOT=Path(__file__).resolve().parents[3]
BASE=ROOT/'pcb/integration'
BOARD=ROOT/'pcb/usb-input/Trimix_USB_Input.kicad_pcb'
NETLIST=BASE/'verification/USB_Input-netlist.xml'
O=(100.,100.)

def v(x,y):return p.VECTOR2I(p.FromMM(x),p.FromMM(y))
def point(x,y):return v(O[0]+x,O[1]+y)
def digest(path):return hashlib.sha256(path.read_bytes()).hexdigest()

def build():
    backup=BASE/'verification/USB_Input-initial-import.kicad_pcb'
    if not backup.exists():shutil.copy2(BOARD,backup)
    b=p.LoadBoard(str(backup));fps={f.GetReference():f for f in b.GetFootprints()}
    assert set(fps)=={'J901','J902','R901','R902'}
    old=fps['J901']
    fp=p.FootprintLoad(str(ROOT/'pcb/analyzer/Trimix_Connectors.pretty'),'USB_C_GCT_USB4720-03-A_A3')
    fp.SetFPID(p.LIB_ID('Trimix_Connectors','USB_C_GCT_USB4720-03-A_A3'))
    fp.SetReference('J901');fp.SetValue(old.GetValue());fp.SetPath(old.GetPath())
    b.Remove(old);b.Add(fp);fps['J901']=fp
    b.GetDesignSettings().SetBoardThickness(p.FromMM(.6))
    b.GetDesignSettings().SetCopperLayerCount(2)
    b.GetDesignSettings().m_CopperEdgeClearance=p.FromMM(.25)
    for drawing in list(b.GetDrawings()):b.Remove(drawing)
    expected={};nets={}
    for n in ET.parse(NETLIST).getroot().findall('./nets/net'):
        name=n.attrib['name'];net=b.FindNet(name)
        if not net:net=p.NETINFO_ITEM(b,name);b.Add(net)
        nets[name]=net
        for node in n.findall('node'):expected[node.attrib['ref'],node.attrib['pin']]=name
    repaired=[]
    for ref,fp in fps.items():
        for pad in fp.Pads():
            key=(ref,pad.GetNumber());assert key in expected,key
            if pad.GetNetname()!=expected[key]:repaired.append(key)
            pad.SetNet(nets[expected[key]])
        fp.Reference().SetVisible(False);fp.Value().SetVisible(False)
    for node in ET.parse(NETLIST).getroot().findall('./components/comp'):
        fp=fps[node.attrib['ref']]
        fp.SetExcludedFromBOM(any(x.attrib['name']=='exclude_from_bom' for x in node.findall('property')))
        for field in node.findall('./fields/field'):
            if field.attrib['name']=='Footprint':continue
            fp.SetField(field.attrib['name'],field.text or '')
            fp.GetField(field.attrib['name']).SetVisible(False)
    fps['J902'].Models().clear() # Solder pads have no purchased body; harness is modeled separately.
    positions={'J901':(8,10.14,0),'J902':(5.9,4,0),'R901':(6.75,7.3,90),'R902':(9.75,7.3,90)}
    for ref,(x,y,angle) in positions.items():
        fps[ref].SetOrientationDegrees(angle);fps[ref].SetPosition(point(x,y))
    # The mid-mount connector legitimately straddles the outside board edge.
    # Remove its obsolete guide text, retaining the library's dimensional land data.
    for g in fps['J901'].GraphicalItems():
        if g.GetLayer()==p.F_SilkS:g.SetLayer(p.Dwgs_User)
    edges=[]
    def line(a,c):
        g=p.PCB_SHAPE();g.SetShape(p.SHAPE_T_SEGMENT);g.SetStart(point(*a));g.SetEnd(point(*c));g.SetLayer(p.Edge_Cuts);g.SetWidth(p.FromMM(.05));b.Add(g)
        edges.append({'line':[a,c]})
    def arc(a,m,c):
        g=p.PCB_SHAPE();g.SetShape(p.SHAPE_T_ARC);g.SetArcGeometry(point(*a),point(*m),point(*c));g.SetLayer(p.Edge_Cuts);g.SetWidth(p.FromMM(.05));b.Add(g)
        edges.append({'arc':[a,m,c]})
    # Rear corners clear the two existing cartridge insert bosses by0.20 radial.
    r=3.85;cx=-1.25;cy=-.25
    x0=cx+math.sqrt(r*r-cy*cy);y0=cy+math.sqrt(r*r-cx*cx)
    angle_a=math.atan2(.25,x0-cx);angle_b=math.atan2(y0-cy,1.25)
    mid=(cx+r*math.cos((angle_a+angle_b)/2),cy+r*math.sin((angle_a+angle_b)/2))
    line((x0,0),(16-x0,0))
    arc((16-x0,0),(16-mid[0],mid[1]),(16,y0))
    line((16,y0),(16,11.4));line((16,11.4),(14.3,11.4));line((14.3,11.4),(14.3,15.72))
    line((14.3,15.72),(13.05,15.72));line((13.05,15.72),(12.525,14.59));line((12.525,14.59),(12.525,11.19))
    arc((12.525,11.19),(12.775,10.94),(12.525,10.69))
    line((12.525,10.69),(3.475,10.69))
    arc((3.475,10.69),(3.225,10.94),(3.475,11.19))
    line((3.475,11.19),(3.475,14.59));line((3.475,14.59),(2.95,15.72));line((2.95,15.72),(1.7,15.72))
    line((1.7,15.72),(1.7,11.4));line((1.7,11.4),(0,11.4));line((0,11.4),(0,y0));arc((0,y0),mid,(x0,0))
    def track(net,xy,width=.2,layer=p.F_Cu):
        for a,c in zip(xy,xy[1:]):
            t=p.PCB_TRACK(b);t.SetStart(point(*a));t.SetEnd(point(*c));t.SetWidth(p.FromMM(width));t.SetLayer(layer);t.SetNet(nets[net]);b.Add(t)
    def via(net,x,y):
        q=p.PCB_VIA(b);q.SetPosition(point(x,y));q.SetWidth(p.FromMM(.6));q.SetDrill(p.FromMM(.3));q.SetLayerPair(p.F_Cu,p.B_Cu);q.SetNet(nets[net]);b.Add(q)
    def pad(ref,num):
        q=next(q for q in fps[ref].Pads() if q.GetNumber()==num)
        return (p.ToMM(q.GetPosition().x)-O[0],p.ToMM(q.GetPosition().y)-O[1])
    for ref,cc in [('R901','A5'),('R902','B5')]:
        track('USB_CC1' if ref=='R901' else 'USB_CC2',[pad('J901',cc),pad(ref,'1')])
        g=pad(ref,'2');track('GND',[g,(g[0],5.8)],.3);via('GND',g[0],5.8)
    # Short VBUS branches join behind the connector. Broad return on back copper.
    track('USB_5V',[pad('J901','A4'),(5.57,9.65)],.3)
    track('USB_5V',[(5.57,9.65),(5.57,6.2),(5.9,5.87),pad('J902','1')],.55)
    track('USB_5V',[pad('J901','A9'),(10.43,9.4),(12.1,7.73),(12.1,2.5),(7.4,2.5),pad('J902','1')],.3)
    for x in (4.72,11.28):
        track('GND',[(x,10.19),(x,9.9)],.3);via('GND',x,9.9)
    for layer in (p.F_Cu,p.B_Cu):
        z=p.ZONE(b);z.SetLayer(layer);z.SetNet(nets['GND']);z.SetLocalClearance(p.FromMM(.2));z.SetMinThickness(p.FromMM(.2));z.SetThermalReliefGap(p.FromMM(.2));z.SetThermalReliefSpokeWidth(p.FromMM(.3))
        poly=z.Outline();poly.NewOutline()
        for x,y in [(-1,-1),(17,-1),(17,17),(-1,17)]:q=point(x,y);poly.Append(q.x,q.y)
        b.Add(z)
    for q in fps['J901'].Pads():
        if q.GetNetname()=='GND':q.SetLocalZoneConnection(p.ZONE_CONNECTION_FULL)
    # Rear capture zone is deliberately free of components, pads and routing.
    def text(s,x,y,size=.65,layer=p.F_SilkS):
        t=p.PCB_TEXT(b);t.SetText(s);t.SetPosition(point(x,y));t.SetTextSize(v(size,size));t.SetTextThickness(p.FromMM(.11));t.SetLayer(layer);b.Add(t)
    text('USB A3',8,2.1,.8);text('+',4.6,3.0,.8);text('-',11.5,3.0,.8)
    text('0.60 mm / FIT DRAFT',8,-2,.8,p.Dwgs_User)
    text('GCT Rev B lands; front blend is provisional',8,-3.5,.7,p.Dwgs_User)
    b.GetTitleBlock().SetTitle('Trimix USB input A3 - enclosure fit draft')
    b.GetTitleBlock().SetRevision('A3-fit');b.GetTitleBlock().SetComment(0,'0.60 +/-0.10 mm PCB. Physical connector and front blend qualification pending.')
    b.GetDesignSettings().SetAuxOrigin(point(0,0));b.GetDesignSettings().SetGridOrigin(point(0,0))
    p.SaveBoard(str(BOARD),b)
    check=p.LoadBoard(str(BOARD));actual={}
    for fp in check.GetFootprints():
        for q in fp.Pads():
            key=fp.GetReference(),q.GetNumber()
            assert key not in actual or actual[key]==q.GetNetname()
            actual[key]=q.GetNetname()
    assert actual==expected
    result={'status':'routed_fit_draft_pending_DRC_and_native_fit','board':str(BOARD),'board_sha256':digest(BOARD),
      'source_netlist_sha256':digest(NETLIST),'source_schematic_sha256':digest(BOARD.with_suffix('.kicad_sch')),
      'dimensions_mm':[16,15.72,.6],'footprints':4,'numbered_pin_nets':len(actual),'mcp_initial_net_corrections':repaired,
      'all_pad_nets_match_fresh_cli_netlist':True,'layers':2,'outline':edges,'positions_local_mm':positions,
      'registration':{'FusionX':'UsbX-8+(KiCadX-100)','FusionY':'18-(KiCadY-100)','FusionPCBBottomZ':'UsbZ-0.3','FusionPCBTopZ':'UsbZ+0.3'},
      'drawing_datums_mm':{'ground_tag_row':7.86,'smt_row':7.81,'front_board_edge':2.28,'cutout_rear':7.31,'nose':1.,'ground_tag_pitch':8.2,'shell_pitch_x':11.3,'shell_row_pitch':4.},
      'open_items':['Front blend represented by explicit clearance chamfer; compare supplier CAD or sample before fabrication','Current Fusion connector reconstruction and old PCB envelope require native re-fit','Pigtail lead clearance, solder strain relief and actual connector insertion tests pending']}
    (BASE/'verification/usb-layout.json').write_text(json.dumps(result,indent=2)+'\n')
    print(json.dumps({k:result[k] for k in ('status','footprints','numbered_pin_nets','all_pad_nets_match_fresh_cli_netlist')}))

if __name__=='__main__':build()
