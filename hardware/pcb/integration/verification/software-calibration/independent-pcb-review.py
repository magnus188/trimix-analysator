"""Independent read-only review; does not import placement/update audit helpers."""
from pathlib import Path
import collections, copy, csv, datetime, hashlib, json, sys
import xml.etree.ElementTree as ET
import pcbnew as pcb
import sexpdata as sexp

OUT=Path(__file__).resolve().parent
HW=OUT.parents[3]
BOARD=HW/'pcb/analyzer/Trimix_Analyzer.kicad_pcb'
OLD=OUT/'before-board/Trimix_Analyzer.kicad_pcb'
NETLIST=OUT/'analyzer-upgraded-netlist.xml'
DELETED={'R502','R503','RV501'}
REPLACED={'U401','U502','RN501'}
MOVED={'R405','C407','C404','C405','C408','C406','R406','C508','C509','C506','R507'}

def sha(path):return hashlib.sha256(Path(path).read_bytes()).hexdigest()
def tag(x):return str(x[0]) if isinstance(x,list) and x else ''
def nodes(x,name):return [v for v in x if tag(v)==name]
def one(x,name):return next(v for v in x if tag(v)==name)
def properties(f):return {v[1]:v[2] for v in nodes(f,'property')}
def normalized(f,allow_pose=False):
    f=copy.deepcopy(f)
    def walk(v,root=False):
        if not isinstance(v,list):return
        if tag(v)=='net' and len(v)==3:v[1]='NET_CODE_IGNORED_BY_NAME'
        if tag(v)=='property' and v[1] in {'Reference','Value'}:
            # Text content retained; annotation placement/style intentionally changed.
            v[:]=v[:3];return
        if root and allow_pose:one(v,'at')[1:]=['ALLOWED_PLACEMENT']
        if tag(v) in {'pad','property','fp_text'} and allow_pose:
            at=one(v,'at');at[:]=at[:3] # Relative pad XY/shape retained, rotation follows footprint.
        for child in v:walk(child)
    walk(f,True)
    return f
def pose(f):return [pcb.ToMM(f.GetPosition().x),pcb.ToMM(f.GetPosition().y),f.GetOrientationDegrees()]
def drc_identity(v):
    return json.dumps({'type':v['type'],'severity':v['severity'],'description':v['description'],
        'items':sorted(v.get('items',[]),key=lambda x:x['uuid'])},sort_keys=True)

def run():
    start_sha=sha(BOARD)
    original=sexp.loads(OLD.read_text());current=sexp.loads(BOARD.read_text())
    old={properties(f)['Reference']:f for f in nodes(original,'footprint')}
    new={properties(f)['Reference']:f for f in nodes(current,'footprint')}
    assert set(old)-set(new)==DELETED
    assert set(new)-set(old)=={'RN501'}
    untouched=[]
    for ref in set(old)&set(new)-REPLACED:
        assert normalized(old[ref],ref in MOVED)==normalized(new[ref],ref in MOVED),ref
        untouched.append(ref)
    # Copper, board settings, rules, outline and model placements outside the
    # explicitly replaced footprints must be byte-structure identical.
    def board_nodes(tree):
        return collections.Counter(sexp.dumps(v) for v in tree if tag(v) not in {'footprint','net','property','gr_text'})
    assert board_nodes(original)==board_nodes(current)
    for kind in ['segment','arc','via','zone']:
        assert nodes(original,kind)==nodes(current,kind),kind
    def edge(tree):
        return [v for v in tree if tag(v).startswith('gr_') and any(tag(q)=='layer' and q[1]=='Edge.Cuts' for q in v)]
    assert edge(original)==edge(current)
    b=pcb.LoadBoard(str(BOARD));ob=pcb.LoadBoard(str(OLD))
    fps={f.GetReference():f for f in b.GetFootprints()};ofps={f.GetReference():f for f in ob.GetFootprints()}
    assert len(fps)==131
    actual={(r,pad.GetNumber()):pad.GetNetname() for r,f in fps.items() for pad in f.Pads() if pad.GetNumber()}
    root=ET.parse(NETLIST).getroot();expected={}
    for net in root.findall('./nets/net'):
        for pin in net.findall('node'):
            if pin.attrib['ref'] in fps:expected[(pin.attrib['ref'],pin.attrib['pin'])]=net.attrib['name']
    assert actual==expected and len(actual)==374
    comps={c.attrib['ref']:c for c in root.findall('./components/comp')}
    for r,f in fps.items():
        if r.startswith('H'):continue # Mechanical mounting holes are PCB-only.
        assert f.GetValue()==comps[r].findtext('value'),r
        assert f.GetFPID().GetUniStringLibId()==comps[r].findtext('footprint'),r
    metadata={}
    for r in REPLACED:
        f=fps[r];c=comps[r]
        fields={x.attrib['name']:x.text or '' for x in c.findall('./fields/field')}
        got=properties(new[r])
        for name,value in fields.items():
            if name=='Footprint':continue # Verified through the native FPID above.
            assert got.get(name)==value,(r,name,value,got.get(name))
        assert f.GetSheetfile()==next(x.attrib['value'] for x in c.findall('property') if x.attrib['name']=='Sheetfile')
        assert f.GetPath().AsString()==c.find('sheetpath').attrib['tstamps']+c.findtext('tstamps')
        metadata[r]={'value':f.GetValue(),'footprint':f.GetFPID().GetUniStringLibId(),'MPN':got.get('MPN'),'Manufacturer':got.get('Manufacturer'),'schematic_path':f.GetPath().AsString()}
    fixed={}
    for r,f in fps.items():
        if r not in REPLACED|MOVED:assert pose(f)==pose(ofps[r]),r
        if r!='RN501':assert f.m_Uuid.AsString()==ofps[r].m_Uuid.AsString(),r
        if r.startswith(('J','H')):
            fixed[r]=pose(f);assert fixed[r]==pose(ofps[r]),r
    assert fixed['J402']==[4.45,16.6,0.0]
    assert fixed['J401']==[4.9,24.46,0.0]
    outline=pcb.SHAPE_POLY_SET();assert b.GetBoardPolygonOutlines(outline,False)
    courts={}
    for r,f in fps.items():
        f.BuildCourtyardCaches();courts[r]=f.GetCourtyard(pcb.F_Cu)
        outside=courts[r].CloneDropTriangulation();outside.BooleanSubtract(outline)
        assert outside.Area()<=1,r
    collision_pairs=[]
    for i,r in enumerate(sorted(courts)):
        for s in sorted(courts)[i+1:]:
            if courts[r].Collide(courts[s],0):collision_pairs.append([r,s])
    assert not collision_pairs
    copper_checks=0
    for r,f in fps.items():
        for pad in f.Pads():
            if not pad.IsOnLayer(pcb.F_Cu):continue
            expanded=pcb.SHAPE_POLY_SET()
            pad.TransformShapeToPolygon(expanded,pcb.F_Cu,pcb.FromMM(.5),pcb.FromMM(.001),pcb.ERROR_OUTSIDE)
            expanded.BooleanSubtract(outline)
            assert expanded.Area()<=1,(r,pad.GetNumber());copper_checks+=1
    assert b.GetCopperLayerCount()==4 and pcb.ToMM(b.GetDesignSettings().GetBoardThickness())==1.6
    assert len(b.GetTracks())==0
    sides=collections.Counter()
    csv_rows=list(csv.DictReader((HW/'pcb/integration/reference/COMPONENT_REFERENCE.csv').open(encoding='utf-8-sig')))
    assert len(csv_rows)==135
    csv_main={r['reference']:r for r in csv_rows if r['board']=='Main'}
    assert set(csv_main)==set(fps)
    for ref,f in fps.items():
        field=f.Reference();side='Front' if field.GetLayer()==pcb.F_SilkS else 'Back' if field.GetLayer()==pcb.B_SilkS else 'Invalid'
        assert side!='Invalid' and field.IsVisible() and field.GetText()==ref
        assert field.IsMirrored()==(side=='Back')
        assert pcb.ToMM(field.GetTextHeight())==1.0 and pcb.ToMM(field.GetTextThickness())==.15
        assert csv_main[ref]['silkscreen_side']==side
        assert csv_main[ref]['board_value']==f.GetValue()
        if not ref.startswith('H'):assert csv_main[ref]['schematic_value']==f.GetValue(),ref
        assert csv_main[ref]['footprint']==f.GetFPID().GetUniStringLibId()
        assert csv_main[ref]['DNP']==str(f.IsDNP())
        sides[side]+=1
    assert sides=={'Front':31,'Back':100}
    older=json.loads((OUT.parent/'connector-swap/main-drc.json').read_text())
    latest=json.loads((OUT/'independent-main-drc.json').read_text())
    assert collections.Counter(map(drc_identity,older['violations']))==collections.Counter(map(drc_identity,latest['violations']))
    assert older['included_severities']==latest['included_severities']
    assert older['ignored_checks']==latest['ignored_checks']
    assert len(latest['violations'])==39 and len(latest['unconnected_items'])==295 and not latest['schematic_parity']
    assert sha(BOARD)==start_sha
    result={'status':'passed_independent_review','generated_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),
      'board_sha256':start_sha,'before_board_sha256':sha(OLD),'netlist_sha256':sha(NETLIST),
      'footprints':131,'numbered_pad_net_assignments':374,'metadata_verified':metadata,
      'unchanged_other_footprint_structure_count':len(untouched),'allowed_moved_passives':{r:pose(fps[r]) for r in sorted(MOVED)},
      'fixed_connectors_and_mounts':fixed,'connector_order':'J402 coax above J401 AO2; exact prior footprint datums preserved',
      'outline_copper_global_settings_unchanged':True,'existing_footprint_UUIDs_preserved':True,
      'courtyard_collision_count':0,'courtyards_outside_count':0,'copper_pad_edge_0_50mm_checks':copper_checks,
      'layers':4,'thickness_mm':1.6,'tracks':0,'main_reference_sides':dict(sides),'reference_key_total_rows':len(csv_rows),
      'drc':{'violations_before':39,'violations_after':39,'all_fabrication_finding_identities_exactly_equal':True,
        'unconnected_before':288,'unconnected_after':295,'schematic_parity_after':0,
        'severities':latest['included_severities'],'ignored_checks_identical':True,
        'independent_report_sha256':sha(OUT/'independent-main-drc.json')},
      'reference_csv_sha256':sha(HW/'pcb/integration/reference/COMPONENT_REFERENCE.csv'),
      'limits':['Unrouted board, not a fabrication release','Actual sensor connector/cable envelopes remain unmeasured','No physical fit or gas-performance qualification']}
    (OUT/'independent-pcb-review.json').write_text(json.dumps(result,indent=2)+'\n')
    print(json.dumps(result,indent=2))

if __name__=='__main__':run()
