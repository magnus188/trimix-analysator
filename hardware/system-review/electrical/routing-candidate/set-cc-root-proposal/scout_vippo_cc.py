"""Exact source-bound U115.3 capped-via escape; no canonical EDA changes.

The isolated process trial retains the complete existing SET circuit. A .40/.20
VIPPO at the CC pin replaces its three B-layer escape segments and remote via.
Only the original SMT pad contributes a B mask/paste aperture; the via is tented
on both faces. Filling/capping metadata is explicit but is not factory approval.
"""
from pathlib import Path
import hashlib, json, math, sys, types
import pcbnew as p

D=Path(__file__).resolve().parent; ROOT=D.parent
OUT=D/'vippo-cc'; OUT.mkdir(exist_ok=True)
SOURCE=D/'source-controls-overlay.kicad_pcb'
EXPECTED='817a3f8c8ad51f40706cee62c9028a691af2ad19b233cdbb186b2b0de57e8ae9'
sha=lambda q:hashlib.sha256(q.read_bytes()).hexdigest()
assert sha(SOURCE)==EXPECTED
c=types.ModuleType('build_bridge'); c.p=p; c.b=p.LoadBoard(str(SOURCE)); c.OUT=OUT; c.added=[]
c.vec=lambda q:p.VECTOR2I(p.FromMM(q[0]),p.FromMM(q[1]))
c.xy=lambda q:[p.ToMM(q.x),p.ToMM(q.y)]
NET='USB_CC_INT_N'
NETS={str(k):v.GetNetCode()for k,v in c.b.GetNetsByName().items()}
removed=['fb50447b-fb72-4dfe-b752-dba9ff00c5d6','3defb919-bf30-4701-b0aa-8fa3a353a018',
         '81be3eeb-f77d-4589-9761-d20848e3d9fe','ccd731be-34a0-4966-8996-5149a398a9e0']
held=[t for t in c.b.GetTracks()if t.m_Uuid.AsString()in removed]
assert len(held)==4 and all(t.GetNetname()==NET for t in held)
for t in held:c.b.Remove(t)

def track(net,pts,layer=p.F_Cu,width=.15):
    for a,z in zip(pts,pts[1:]):
        if math.dist(a,z)<1e-6:continue
        t=p.PCB_TRACK(c.b);t.SetStart(c.vec(a));t.SetEnd(c.vec(z));t.SetLayer(layer)
        t.SetWidth(p.FromMM(width));t.SetNetCode(NETS[net]);c.b.Add(t)
        c.added.append({'uuid':t.m_Uuid.AsString(),'type':'segment','net':net,'start':a,'end':z,'layer':c.b.GetLayerName(layer),'width_mm':width})
def via(net,q):raise RuntimeError('No additional ordinary vias are permitted in this short trial')
c.track=track;c.via=via
v=p.PCB_VIA(c.b);v.SetPosition(c.vec((13.6,89.775)));v.SetWidth(p.FromMM(.4));v.SetDrill(p.FromMM(.2))
v.SetViaType(p.VIATYPE_THROUGH);v.SetLayerPair(p.F_Cu,p.B_Cu);v.SetNetCode(NETS[NET])
v.SetFrontTentingMode(p.TENTING_MODE_TENTED);v.SetBackTentingMode(p.TENTING_MODE_TENTED)
v.SetFillingMode(p.FILLING_MODE_FILLED);v.SetCappingMode(p.CAPPING_MODE_CAPPED)
c.b.Add(v)
vippo={'uuid':v.m_Uuid.AsString(),'at_mm':[13.6,89.775],'diameter_mm':.4,'drill_mm':.2,
       'filled':True,'capped':True,'tenting':'both; existing U115.3 pad defines only B mask/paste aperture',
       'process_status':'Exact JLC POFV capability checked separately; quotation/CAM acceptance pending'}
sys.modules['build_bridge']=c
code=(ROOT/'cap-signal-reconnect/pullup-swap/route_bounded.py').read_text()
code=code.replace('STEP=.05; BOUNDS=bounds','STEP=.025; BOUNDS=bounds')
router=types.ModuleType('root_vippo_cc_router');exec(code,router.__dict__)
report={'source_file':str(SOURCE),'source_sha256':EXPECTED,'removed_CC_items':removed,'added_VIPPO':vippo,
        'SET_retained':True,'R129_added':False,'known_source_issue':'C116/CHG clash, separate coordinated correction pending',
        'release':False}
try:
    router.route(NET,(13.6,89.775),(16.7,90.3),start_layers=(0,),end_layers=(0,),
                 allow_vias=False,width=.15,bounds=(13.25,88.75,17.1,91.2))
except AssertionError as e:report.update(status='NO_BOUNDED_CC_ROUTE',error=str(e))
else:
    # Existing destination escape is a separately audited B route. This overlay
    # source predates it; use the exact frozen proposed endpoints here.
    report['source_CC_route']=list(c.added)
    track(NET,[(16.7,90.3),(20.95,89.525),(21.925,88.575),(22.2,88.35)],p.B_Cu)
    report.update(status='FOUND_REQUIRES_NATIVE_DRC',added_segments=c.added)
    c.b.BuildConnectivity();c.b.GetDesignSettings().m_TrackMinWidth=p.FromMM(.15)
    p.SaveBoard(str(OUT/'candidate-unfilled.kicad_pcb'),c.b)
    report['unfilled_sha256']=sha(OUT/'candidate-unfilled.kicad_pcb')
assert sha(SOURCE)==EXPECTED
report['source_unchanged']=True
(OUT/'proposal.json').write_text(json.dumps(report,indent=2)+'\n')
print(json.dumps(report,indent=2),flush=True)
