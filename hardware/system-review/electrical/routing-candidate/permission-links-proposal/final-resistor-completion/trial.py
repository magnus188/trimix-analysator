import route_context as c
import sys,json
D=c.D;p=c.p
source=sys.argv[1];rx=float(sys.argv[2]);ry=float(sys.argv[3]);rot=float(sys.argv[4]);side=sys.argv[5];which=sys.argv[6]
c.b=p.LoadBoard(str(D/source));b=c.b
for f in b.GetFootprints():
 if f.GetReference()=='R116':
  if f.GetLayer()!=(p.F_Cu if side=='F' else p.B_Cu):f.Flip(f.GetPosition(),False)
  f.SetOrientationDegrees(rot);f.SetPosition(c.vec((rx,ry)))
 if f.GetReference()=='R118':f.SetOrientationDegrees(0);f.SetPosition(c.vec((12.95,89.3)))
 if f.GetReference()=='R119':f.SetOrientationDegrees(0);f.SetPosition(c.vec((4.2,86.55)))
import route_bounded as r
fps={f.GetReference():f for f in b.GetFootprints()}
def pad(ref,num):return next(x for x in fps[ref].Pads()if x.GetNumber()==num)
a=pad('R116','1' if which=='limit' else '2');z=pad('U114','4') if which=='limit' else pad('Q110','3')
print('ROUTE',a.GetNetname(),c.xy(a.GetPosition()),c.xy(z.GetPosition()),flush=True)
r.route(a.GetNetname(),c.xy(a.GetPosition()),c.xy(z.GetPosition()),start_layers=(0 if side=='F' else 2,),end_layers=(0,),bounds=(.6,83,23,98.2))
c.save();print('SAVED')
