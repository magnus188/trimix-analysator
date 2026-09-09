from pathlib import Path
import pcbnew as p,json,hashlib,math
OUT=Path(__file__).resolve().parent;P=OUT/'before.kicad_pcb';EXPECTED='f1c5f443cbd6cdf92e39e01fc7db374c30721b6e7945b3cdde3387e8cdff7432';assert hashlib.sha256(P.read_bytes()).hexdigest()==EXPECTED;b=p.LoadBoard(str(P));NETS={str(k):v.GetNetCode()for k,v in b.GetNetsByName().items()};added=[]
def vec(q):return p.VECTOR2I(p.FromMM(q[0]),p.FromMM(q[1]))
def xy(q):return[p.ToMM(q.x),p.ToMM(q.y)]
def track(net,pts,layer=p.F_Cu,width=.4):
 for a,z in zip(pts,pts[1:]):
  if math.dist(a,z)<1e-6:continue
  t=p.PCB_TRACK(b);t.SetStart(vec(a));t.SetEnd(vec(z));t.SetLayer(layer);t.SetNetCode(NETS[net]);t.SetWidth(p.FromMM(width));b.Add(t);added.append({'uuid':t.m_Uuid.AsString(),'type':'segment','net':net,'start':a,'end':z,'width_mm':width,'layer':b.GetLayerName(layer)})
def via(net,q,d=.6,h=.3):
 t=p.PCB_VIA(b);t.SetPosition(vec(q));t.SetWidth(p.FromMM(d));t.SetDrill(p.FromMM(h));t.SetViaType(p.VIATYPE_THROUGH);t.SetLayerPair(p.F_Cu,p.B_Cu);t.SetNetCode(NETS[net]);b.Add(t);added.append({'uuid':t.m_Uuid.AsString(),'type':'via','net':net,'at':q,'diameter_mm':d,'drill_mm':h})
