from pathlib import Path
import math,json
D=Path(__file__).resolve().parent
import route_context as c
p=c.p;c.b=p.LoadBoard(str(D/'scout-base.kicad_pcb'));b=c.b
for ref,at,ang,side in [('R116',(11.85,90.75),300,'F'),('R119',(5.5,88.5),180,'F'),('R118',(10.75,91.95),180,'F')]:
 f=next(f for f in b.GetFootprints()if f.GetReference()==ref)
 if side=='B':f.Flip(f.GetPosition(),False)
 f.SetPosition(c.vec(at));f.SetOrientationDegrees(ang)
def pad(r,n):return next(q for f in b.GetFootprints()if f.GetReference()==r for q in f.Pads()if q.GetNumber()==n)
for ref in ['R116','R119','R118']:
 for n in ['1','2']:
  q=pad(ref,n);print(ref,n,q.GetNetname(),c.xy(q.GetPosition()),q.GetLayerName(),flush=True)
import route_bounded as r
jobs=[('R119','1','U114','4'),('R116','1','U114','4'),('R116','2','Q110','3'),('R118','1','Q110','1')]
results=[]
for A,an,Z,zn in jobs:
 a,z=pad(A,an),pad(Z,zn);assert a.GetNetname()==z.GetNetname()
 print('BEGIN',A,an,Z,zn,flush=True);success=True
 try:r.route(a.GetNetname(),c.xy(a.GetPosition()),c.xy(z.GetPosition()),start_layers=(2 if a.IsOnLayer(p.B_Cu)else 0,),end_layers=(0,),bounds=(.6,80,30,98.35))
 except AssertionError as e:print('FAILED',e,flush=True);success=False
 results.append(dict(source=A+'.'+an,target=Z+'.'+zn,success=success));c.save()
def ground(ref):
 q=pad(ref,'2');a=c.xy(q.GetPosition());L=q.GetLayer();ALL=[p.F_Cu,p.In1_Cu,p.In2_Cu,p.B_Cu];obs=list(b.GetTracks())+[q for f in b.GetFootprints()for q in f.Pads()]
 def segclear(z):return all(not it.GetEffectiveShape(L).Collide(p.SEG(c.vec(a),c.vec(z)),p.FromMM(.2751))for it in obs if it.IsOnLayer(L)and it.GetNetname()!='GND')
 olds=[t for t in b.GetTracks()if isinstance(t,p.PCB_VIA)and t.GetNetname()=='GND'and math.dist(a,c.xy(t.GetPosition()))<2]
 for t in sorted(olds,key=lambda t:math.dist(a,c.xy(t.GetPosition()))):
  z=c.xy(t.GetPosition())
  if segclear(z):c.track('GND',[a,z],L);print('GROUND existing',ref,z,flush=True);return
 points=sorted([(round(a[0]/.025)*.025+i*.025,round(a[1]/.025)*.025+j*.025)for i in range(-60,61)for j in range(-60,61)],key=lambda z:math.dist(a,z))
 for z in points:
  if not segclear(z):continue
  if any(it.GetEffectiveShape(K).Collide(c.vec(z),p.FromMM(.4501))for it in obs for K in ALL if it.IsOnLayer(K)and it.GetNetname()!='GND'):continue
  if any(it.GetEffectiveShape(K).Collide(c.vec(z),p.FromMM(.4501))for it in obs if isinstance(it,p.PAD)and it.GetAttribute()==p.PAD_ATTRIB_SMD for K in[p.F_Cu,p.B_Cu]if it.IsOnLayer(K)):continue
  if any(it.GetEffectiveShape().Collide(c.vec(z),p.FromMM(.7501))for it in b.GetDrawings()if it.GetLayer()==p.Edge_Cuts):continue
  c.via('GND',z);c.track('GND',[a,z],L);print('GROUND new',ref,z,flush=True);return
 print('GROUND FAILED',ref,flush=True)
for ref in ['R119','R118']:ground(ref)
c.save();(D/'angle-trial-results.json').write_text(json.dumps(results,indent=2)+'\n')
