from pathlib import Path
D=Path(__file__).resolve().parent
import route_context as c
s=(D/'before.kicad_pcb').read_text();uid='877675ee-a8c4-429c-8084-f92d6210c16c';pos=s.index(uid);lo=s.rfind('(segment',0,pos);dep=0
for hi in range(lo,len(s)):
 if s[hi]=='(':dep+=1
 elif s[hi]==')':
  dep-=1
  if dep==0:break
s=s[:lo]+s[hi+1:];(D/'q-high-source.kicad_pcb').write_text(s);c.b=c.p.LoadBoard(str(D/'q-high-source.kicad_pcb'))
f=next(f for f in c.b.GetFootprints()if f.GetReference()=='R118');f.SetPosition(c.vec((26,86.75)));f.SetOrientationDegrees(270)
import route_multiple_dense as r
import math
b=c.b;b.BuildConnectivity();co=b.GetConnectivity();seed=next(q for f in b.GetFootprints()if f.GetReference()=='U112'for q in f.Pads()if q.GetNumber()=='5');queue=[seed];seen=set()
while queue:
 item=queue.pop();uid=item.m_Uuid.AsString()
 if uid in seen:continue
 seen.add(uid)
 queue.extend(list(co.GetConnectedTracks(item))+list(co.GetConnectedPads(item)))
target_points=[];layerindices={c.p.F_Cu:0,c.p.In2_Cu:1,c.p.B_Cu:2}
for t in b.GetTracks():
 if t.GetNetname()!='USB_PERMISSION_Q':continue
 assert t.m_Uuid.AsString()in seen,'No assumed disconnected Q targets'
 if isinstance(t,c.p.PCB_VIA):target_points.extend((c.xy(t.GetPosition()),l)for l in [0,1,2])
 else:
  a,z=c.xy(t.GetStart()),c.xy(t.GetEnd());N=max(1,math.ceil(math.dist(a,z)/.05))
  if t.GetLayer()in layerindices:
   target_points.extend(((a[0]+(z[0]-a[0])*i/N,a[1]+(z[1]-a[1])*i/N),layerindices[t.GetLayer()])for i in range(N+1))
print('Verified native connected target points',len(target_points),flush=True)
ordinary_via=c.via
def dense_via(net,at):
 for old in c.b.GetTracks():
  if isinstance(old,c.p.PCB_VIA)and old.GetNetname()==net and c.xy(old.GetPosition())==at:return
 q=c.p.PCB_VIA(c.b);q.SetPosition(c.vec(at));q.SetWidth(c.p.FromMM(.45));q.SetDrill(c.p.FromMM(.2));q.SetViaType(c.p.VIATYPE_THROUGH);q.SetLayerPair(c.p.F_Cu,c.p.B_Cu);q.SetNetCode(c.b.FindNet(net).GetNetCode());c.b.Add(q)
c.via=dense_via
try:r.route('USB_PERMISSION_Q' ,(26,85.925),(25.9507,82.0583),start_layers=(2,),end_layers=(0,1,2),bounds=(19,78,30,90),target_points=target_points)
except AssertionError as e:print('FAILED Q',e)
c.via=ordinary_via
c.track('GND',[(26,87.575),(26,88.45)],c.p.B_Cu);c.via('GND',(26,88.45));c.save()
