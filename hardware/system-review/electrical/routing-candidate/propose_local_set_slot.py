"""Isolated short OVP-set slot proposal; not accepted without filled-plane review."""
from pathlib import Path
import pcbnew as p,json,hashlib,sys
sys.path.insert(0,str(Path(__file__).resolve().parents[3]/'tools'))
from analyzer_sheet import sx,child
D=Path(__file__).resolve().parent;src=D/'native/Trimix_Analyzer.kicad_pcb';b=p.LoadBoard(str(src));fp123=next(q for q in b.GetFootprints()if q.GetReference()=='R123');n='/01  CHARGING + BATTERY/BQ_REGN';rm={'6d0e3f5a-4224-41ff-8b5a-988eaa93618d','780d62f0-9d20-476b-af63-124df37c8c91','b8ad260a-106e-4d94-a690-8d0757a4c0e6','fb8fda68-4525-4d88-92bb-e02ee9f1416c'};rm.update({'27998978-88da-46f4-9c4b-98944186ff1f','47015132-c909-4069-9833-2e3b567c534e','4c598f02-7af1-4d84-b0a6-f27e2942b9fe','32e0f8fd-d823-482c-a957-20892f32112c','98203c94-221f-4bb2-bca4-444062cd083f','9c8d967e-a9bc-4fc0-862f-e533309d8965','fb614c41-02fd-44d6-a607-a51b3b1bb33b'});removed=[]
r=sx.loads(src.read_text());removed=[str(child(t,'uuid')[1])for t in r if isinstance(t,list)and child(t,'uuid')and str(child(t,'uuid')[1])in rm];r=[t for t in r if not(isinstance(t,list)and child(t,'uuid')and str(child(t,'uuid')[1])in rm)];tmp=D/'local-set-open.kicad_pcb';tmp.write_text(sx.dumps(r));b=p.LoadBoard(str(tmp));fp123=next(q for q in b.GetFootprints()if q.GetReference()=='R123')
fp123.SetPosition(p.VECTOR2I(p.FromMM(13.725),p.FromMM(87.6)))
def v(q):return p.VECTOR2I(p.FromMM(q[0]),p.FromMM(q[1]))
def path(net,L,pts):
 for s,e in zip(pts,pts[1:]):
  t=p.PCB_TRACK(b);t.SetStart(v(s));t.SetEnd(v(e));t.SetWidth(p.FromMM(.15));t.SetLayer(L);t.SetNetCode(b.FindNet(net).GetNetCode());b.Add(t)
path(n,p.F_Cu,[(10.4,88.15),(11.675,88.15),(11.675,87.55),(12,87.3),(12.4,87.3),(13.675,87.55)])
net='USB_OVP_SET';t=p.PCB_VIA(b);t.SetPosition(v((12.2,87.8)));t.SetWidth(p.FromMM(.45));t.SetDrill(p.FromMM(.2));t.SetViaType(p.VIATYPE_THROUGH);t.SetLayerPair(p.F_Cu,p.B_Cu);t.SetNetCode(b.FindNet(net).GetNetCode());b.Add(t)
path(net,p.B_Cu,[(12.2,87.8),(12.9,87.6)]);path(net,p.In2_Cu,[(12.4,90.3),(12.65,90.05),(12.65,88.4),(12.2,87.95),(12.2,87.8)])
path('USB_5V',p.B_Cu,[(14.25,90),(14.25,88.5),(15.4,88.5),(15.4,86.7),(15.1,86.4)])
p.ZONE_FILLER(b).Fill(b.Zones());out=D/'local-set-slot-explicit.kicad_pcb';p.SaveBoard(str(out),b);(D/'local-set-slot-explicit.json').write_text(json.dumps({'source_sha256':hashlib.sha256(src.read_bytes()).hexdigest(),'output_sha256':hashlib.sha256(out.read_bytes()).hexdigest(),'removed':removed,'R123_pose':[13.725,87.6,0],'new_via':[12.2,87.8,.45,.2],'ground_review_required':True},indent=2)+'\n')
