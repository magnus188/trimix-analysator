"""Joint SET/R129 and CC trial with genuinely separate resistor-terminal nets."""
from pathlib import Path
import sys,types,hashlib,json,math
import pcbnew as p
D=Path(__file__).resolve().parent;ROOT=D.parent;OUT=D/'link-route';OUT.mkdir(exist_ok=True)
SOURCE=D/'source-controls-overlay.kicad_pcb';EXPECTED='817a3f8c8ad51f40706cee62c9028a691af2ad19b233cdbb186b2b0de57e8ae9'
assert hashlib.sha256(SOURCE.read_bytes()).hexdigest()==EXPECTED
c=types.ModuleType('build_bridge');c.p=p;c.b=p.LoadBoard(str(SOURCE));c.OUT=OUT;c.added=[]
c.vec=lambda q:p.VECTOR2I(p.FromMM(q[0]),p.FromMM(q[1]))
c.xy=lambda q:[p.ToMM(q.x),p.ToMM(q.y)]
net=p.NETINFO_ITEM(c.b,'USB_OVP_SET_IC');c.b.Add(net)
NETS={str(k):v.GetNetCode()for k,v in c.b.GetNetsByName().items()}
def track(net,pts,layer=p.F_Cu,width=.15):
 for a,z in zip(pts,pts[1:]):
  if math.dist(a,z)<1e-6:continue
  t=p.PCB_TRACK(c.b);t.SetStart(c.vec(a));t.SetEnd(c.vec(z));t.SetLayer(layer);t.SetNetCode(NETS[net]);t.SetWidth(p.FromMM(width));c.b.Add(t)
  c.added.append({'uuid':t.m_Uuid.AsString(),'type':'segment','net':net,'start':a,'end':z,'layer':c.b.GetLayerName(layer),'width_mm':width})
def via(net,q):raise RuntimeError('This short CC crossing must not add vias')
c.track=track;c.via=via
remove=['08c8df62-8fc9-470a-8189-85ea3bf09942','f46aa3fa-41c1-4b0e-8cae-bee5d5a3f615']
held=[t for t in c.b.GetTracks()if t.m_Uuid.AsString()in remove]
assert len(held)==2
for t in held:c.b.Remove(t)
ic_ids=['674c2f7e-3fc3-4bfb-a9c7-ef1bb5ae9d95','97221b3e-53ad-480c-bf50-4f989f070dbc','70c949b2-64e1-41ff-9ce9-f4577403d6fd']
objects=list(c.b.GetTracks())+[q for fp in c.b.GetFootprints()for q in fp.Pads()]
changed=[]
for q in objects:
 if q.m_Uuid.AsString()in ic_ids:
  assert q.GetNetname()=='USB_OVP_SET';q.SetNetCode(NETS['USB_OVP_SET_IC']);changed.append(q.m_Uuid.AsString())
assert set(changed)==set(ic_ids)
f=p.FootprintLoad('/Applications/KiCad/KiCad.app/Contents/SharedSupport/footprints/Resistor_SMD.pretty','R_0603_1608Metric')
f.SetReference('R129');f.SetValue('0R / SET bridge');c.b.Add(f);f.SetFPID(p.LIB_ID('Resistor_SMD','R_0603_1608Metric'));f.SetPosition(c.vec([13.95,90.25]));f.SetOrientationDegrees(0)
# Exact MPN, factory assembly and maximum envelope are bound in the proposal.
# Authoritative schematic/board field synchronization belongs to the EDA owner.
f.Reference().SetVisible(False)
for q in f.Pads():q.SetNetCode(NETS['USB_OVP_SET_IC'if q.GetNumber()=='1'else 'USB_OVP_SET'])
track('USB_OVP_SET',[[12.2,87.8],[14.775,90.25]])
track('USB_OVP_SET_IC',[[13.125,90.25],[12.4,90.3]])
set_tracks=list(c.added);c.added.clear()
sys.modules['build_bridge']=c
code=(ROOT/'cap-signal-reconnect/pullup-swap/route_bounded.py').read_text()
code=code.replace('STEP=.05; BOUNDS=bounds','STEP=.025; BOUNDS=bounds')
code=code.replace('if isinstance(it,p.PAD) and it.GetAttribute()==p.PAD_ATTRIB_SMD:add_shape(smd,layer,shape)','if isinstance(it,p.PAD):add_shape(smd,layer,shape)')
router=types.ModuleType('root_link_cc_router');exec(code,router.__dict__)
report={'source_sha256':EXPECTED,'R129':{'position_mm':[13.95,90.25],'angle':0,'pin1':'USB_OVP_SET_IC','pin2':'USB_OVP_SET','mpn':'RC0603JR-070RL'},'removed_SET_tracks':remove,'renamed_IC_items':changed,'SET_tracks':set_tracks,'release':False,'known_source_issue':'C116/CHG via clash pending separate exact fix','schematic_not_yet_updated':True}
try:
 router.route('USB_CC_INT_N',(11.9,88.65),(16.7,90.3),start_layers=(0,),end_layers=(0,),allow_vias=False,width=.15,bounds=(10.5,88.3,17.0,91.3))
except AssertionError as e:report['status']='NO_BOUNDED_CC_ROUTE';report['error']=str(e)
else:
 report['status']='FOUND_JOINT_ROUTE_REQUIRES_NATIVE_DRC';report['CC_added']=c.added
 c.b.BuildConnectivity();c.b.GetDesignSettings().m_TrackMinWidth=p.FromMM(.15)
 p.SaveBoard(str(OUT/'candidate-unfilled.kicad_pcb'),c.b)
 report['unfilled_candidate_sha256']=hashlib.sha256((OUT/'candidate-unfilled.kicad_pcb').read_bytes()).hexdigest()
assert hashlib.sha256(SOURCE.read_bytes()).hexdigest()==EXPECTED
(OUT/'proposal.json').write_text(json.dumps(report,indent=2)+'\n')
print(json.dumps(report,indent=2),flush=True)
