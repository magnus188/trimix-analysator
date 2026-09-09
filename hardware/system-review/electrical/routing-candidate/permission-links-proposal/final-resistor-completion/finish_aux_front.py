import route_context as c
D=c.D;p=c.p
c.b=p.LoadBoard(str(D/'scout-base-v2.kicad_pcb'));b=c.b
for f in b.GetFootprints():
 if f.GetReference()=='R116':f.Flip(f.GetPosition(),False);f.SetOrientationDegrees(0);f.SetPosition(c.vec((5.15,88.15)))
 if f.GetReference()=='R118':f.SetOrientationDegrees(180);f.SetPosition(c.vec((10.75,91.95)))
 if f.GetReference()=='R119':f.SetOrientationDegrees(180);f.SetPosition(c.vec((4.2,89.1)))
import route_bounded as r
fps={f.GetReference():f for f in b.GetFootprints()}
def pad(ref,num):return next(x for x in fps[ref].Pads()if x.GetNumber()==num)
def run(ref,num,to,ends=(0,),ground=False):
 a=pad(ref,num);net=a.GetNetname();pts=None
 if ground:
  pts=[(c.xy(v.GetPosition()),L)for v in b.GetTracks()if isinstance(v,p.PCB_VIA) and v.GetNetname()=='GND' and .6<c.xy(v.GetPosition())[0]<21 and 83<c.xy(v.GetPosition())[1]<98 for L in [0,1,2]]
 print(ref,num,net,c.xy(a.GetPosition()),to,flush=True)
 r.route(net,c.xy(a.GetPosition()),to,start_layers=(0 if a.IsOnLayer(p.F_Cu) else 2,),end_layers=ends,target_points=pts,bounds=(.6,83,23,98.2))
run('R118','1',(16.1827,91.7017),(0,1,2))
run('R118','2',(10.45,90.5),(0,1,2),True)
p.SaveBoard(str(D/'q-pulldown-stage.kicad_pcb'),b)
run('R119','1',(6.15,89.55))
run('R119','2',(4.425,85.175),(0,1,2),True)
p.ZONE_FILLER(b).Fill(b.Zones());p.SaveBoard(str(D/'aux-stage.kicad_pcb'),b);print('SAVED AUX')
