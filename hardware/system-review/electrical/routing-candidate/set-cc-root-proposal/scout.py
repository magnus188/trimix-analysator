"""Bounded SET bridge with exact CC corridor hard; isolated in-memory trial."""
from pathlib import Path
import sys, types, hashlib, json, math, argparse
import pcbnew as p

D = Path(__file__).resolve().parent
ROOT = D.parent
ap=argparse.ArgumentParser();ap.add_argument('--step',type=float,default=.05);ap.add_argument('--bounds',type=float,nargs=4,default=[9,86,15.7,92.3]);ap.add_argument('--soft-net',choices=['CHG_INT_N','HOST_3V3']);args=ap.parse_args()
OUT = D / ('step-' + str(args.step).replace('.', 'p') + ('-hypothetical-'+args.soft_net if args.soft_net else ''))
OUT.mkdir(parents=True, exist_ok=True)
SOURCE = ROOT / 'c116-cc-via-ready.kicad_pcb'
EXPECTED = '3a4602e834c0548dcf404e043945873e9a373d8839c6478f86059c6d80bbd1a0'
CC = ROOT / 'hypothetical-cc-through-set.json'
CCSHA = 'd0a37b83a972e9fbd025c641e21ad5b9077b06ef52ef47a21b1f648ee7685103'
sha=lambda q:hashlib.sha256(q.read_bytes()).hexdigest()
assert sha(SOURCE)==EXPECTED and sha(CC)==CCSHA
c=types.ModuleType('build_bridge');c.p=p;c.b=p.LoadBoard(str(SOURCE));c.OUT=OUT;c.added=[]
c.vec=lambda q:p.VECTOR2I(p.FromMM(q[0]),p.FromMM(q[1]))
c.xy=lambda q:[p.ToMM(q.x),p.ToMM(q.y)]
NETS={str(k):v.GetNetCode()for k,v in c.b.GetNetsByName().items()}
def track(net, pts, layer=p.F_Cu, width=.15):
    for a,z in zip(pts,pts[1:]):
        if math.dist(a,z)<1e-6:continue
        t=p.PCB_TRACK(c.b);t.SetStart(c.vec(a));t.SetEnd(c.vec(z));t.SetLayer(layer);t.SetWidth(p.FromMM(width));t.SetNetCode(NETS[net]);c.b.Add(t)
        c.added.append({'uuid':t.m_Uuid.AsString(),'type':'segment','net':net,'start':a,'end':z,'layer':c.b.GetLayerName(layer),'width_mm':width})
def via(net,q):
    t=p.PCB_VIA(c.b);t.SetPosition(c.vec(q));t.SetWidth(p.FromMM(.5));t.SetDrill(p.FromMM(.25));t.SetViaType(p.VIATYPE_THROUGH);t.SetLayerPair(p.F_Cu,p.B_Cu);t.SetNetCode(NETS[net]);c.b.Add(t)
    c.added.append({'uuid':t.m_Uuid.AsString(),'type':'via','net':net,'at':q,'diameter_mm':.5,'drill_mm':.25})
c.track=track;c.via=via
remove=['08c8df62-8fc9-470a-8189-85ea3bf09942','f46aa3fa-41c1-4b0e-8cae-bee5d5a3f615']
held=[t for t in c.b.GetTracks()if t.m_Uuid.AsString()in remove]
assert len(held)==2 and all(t.GetNetname()=='USB_OVP_SET'for t in held)
for t in held:c.b.Remove(t)
cc=json.loads(CC.read_text())
for row in cc['segments']:track('USB_CC_INT_N',[row['start'],row['end']],c.b.GetLayerID(row['layer']),row['width_mm'])
hard_cc=list(c.added);c.added.clear()
soft=[]
if args.soft_net:
    soft=[t for t in c.b.GetTracks() if isinstance(t,p.PCB_TRACK) and not isinstance(t,p.PCB_VIA) and t.GetNetname()==args.soft_net and t.GetLayer()==p.In2_Cu]
    for t in soft:c.b.Remove(t)
sys.modules['build_bridge']=c
code=(ROOT/'cap-signal-reconnect/pullup-swap/route_bounded.py').read_text()
code=code.replace('STEP=.05; BOUNDS=bounds','STEP='+str(args.step)+'; BOUNDS=bounds')
code=code.replace('if isinstance(it,p.PAD) and it.GetAttribute()==p.PAD_ATTRIB_SMD:add_shape(smd,layer,shape)','if isinstance(it,p.PAD):add_shape(smd,layer,shape)')
code=code.replace('for l in [p.F_Cu,p.B_Cu]for s in shapes(smd,l,q)','for l in ALL for s in shapes(smd,l,q)')
router=types.ModuleType('root_set_router');exec(code,router.__dict__)
out={'source_sha256':EXPECTED,'source_file':str(SOURCE),'hard_CC_json_sha256':CCSHA,'hard_CC_segments':hard_cc,'removed_SET_uuids':remove,'step_mm':args.step,'bounds_mm':args.bounds,'source_has_known_C116_CHG_collision':True,'release':False,'hypothetical_soft_net':args.soft_net,'soft_track_uuids':[t.m_Uuid.AsString()for t in soft]}
try:
    router.route('USB_OVP_SET',(12.4,90.3),(12.2,87.8),start_layers=(0,1,2),end_layers=(0,1,2),bounds=args.bounds,width=.15)
except AssertionError as e:
    out['status']='NO_BOUNDED_ROUTE';out['error']=str(e)
else:
    out['status']='HYPOTHETICAL_SOFT_TRACKS_NOT_A_ROUTE'if args.soft_net else 'FOUND_REQUIRES_NATIVE_VERIFICATION';out['added']=c.added
assert sha(SOURCE)==EXPECTED and sha(CC)==CCSHA
out['source_unchanged']=True
(OUT/'proposal.json').write_text(json.dumps(out,indent=2)+'\n')
print(json.dumps({'status':out['status'],'added':out.get('added',[]),'error':out.get('error')}),flush=True)
