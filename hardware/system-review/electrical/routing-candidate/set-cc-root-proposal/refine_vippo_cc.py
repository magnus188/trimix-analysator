"""Retain .20mm routing clearance by moving the existing SET tail in its land."""
from pathlib import Path
import hashlib,json,shutil
import pcbnew as p
import sexpdata as s
D=Path(__file__).resolve().parent;A=D/'vippo-cc/native';O=D/'vippo-cc/native-v2'
sha=lambda q:hashlib.sha256(q.read_bytes()).hexdigest()
expected='fa1f1b03edcfcb05882ddff3c5c9e4220c1617b8b363a5c487d70903bcff7fbf'
assert sha(A/'Trimix_Analyzer.kicad_pcb')==expected and not O.exists()
shutil.copytree(A,O)
b=p.LoadBoard(str(O/'Trimix_Analyzer.kicad_pcb'))
tail=next(t for t in b.GetTracks()if t.m_Uuid.AsString()=='97221b3e-53ad-480c-bf50-4f989f070dbc')
xy=lambda q:[p.ToMM(q.x),p.ToMM(q.y)]
assert tail.GetNetname()=='USB_OVP_SET'and tail.GetLayer()==p.B_Cu
assert xy(tail.GetStart())==[13.6,90.225]and xy(tail.GetEnd())==[12.4,90.3]
tail.SetStart(p.VECTOR2I(p.FromMM(13.6),p.FromMM(90.3)))
pad=next(q for f in b.GetFootprints()if f.GetReference()=='U115'for q in f.Pads()if q.GetNumber()=='2')
assert pad.GetEffectiveShape(p.B_Cu).Collide(tail.GetStart(),0)
project=(O/'Trimix_Analyzer.kicad_pro').read_bytes()
b.GetDesignSettings().m_TrackMinWidth=p.FromMM(.15);b.BuildConnectivity()
p.ZONE_FILLER(b).Fill(b.Zones());p.SaveBoard(str(O/'Trimix_Analyzer.kicad_pcb'),b)
(O/'Trimix_Analyzer.kicad_pro').write_bytes(project)
tag=lambda q:str(q[0])if isinstance(q,list)and q else''
changes=[]
for file in O.glob('*.kicad_sch'):
    data=s.loads(file.read_text());changed=False
    for item in data:
        if tag(item)!='symbol':continue
        props={q[1]:q for q in item if tag(q)=='property'}
        if props.get('Reference',[None,None,None])[2]!='C116':continue
        field=props['Manufacturer'];assert field[2]=='TDK'
        changes.append(dict(file=file.name,ref='C116',field='Manufacturer',before='TDK',after='Murata'))
        field[2]='Murata';changed=True
    if changed:file.write_text(s.dumps(data)+'\n')
assert sha(A/'Trimix_Analyzer.kicad_pcb')==expected
(D/'vippo-cc/native-v2-preparation.json').write_text(json.dumps({
    'status':'ISOLATED_NATIVE_V2_DRC_PENDING','source_sha256':expected,
    'board_sha256':sha(O/'Trimix_Analyzer.kicad_pcb'),
    'modified_track':{'uuid':tail.m_Uuid.AsString(),'net':'USB_OVP_SET','layer':'B.Cu',
        'old_start_mm':[13.6,90.225],'new_start_mm':[13.6,90.3],
        'end_mm':[12.4,90.3],'width_mm':.15,'new_start_inside_original_U115_2_land':True},
    'isolated_field_changes':changes,'canonical_EDA_modified':False,'release':False},indent=2)+'\n')
print('prepared',sha(O/'Trimix_Analyzer.kicad_pcb'),flush=True)
