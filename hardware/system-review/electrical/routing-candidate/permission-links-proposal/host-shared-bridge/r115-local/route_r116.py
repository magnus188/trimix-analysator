import route_context as c
p=c.p;c.b=p.LoadBoard(str(c.D/'r116-scout-base.kicad_pcb'))
f=next(q for q in c.b.GetFootprints()if q.GetReference()=='R116');f.SetOrientationDegrees(0);f.SetPosition(c.vec((7.75,94.75)))
for q in f.Pads():print(q.GetNumber(),q.GetNetname(),c.xy(q.GetPosition()),flush=True)
import route_bounded as r
r.route('USB_LIMIT_SET',(7.24,94.75),(4.95,88.85),start_layers=(0,),end_layers=(0,1,2),bounds=(2,85,12,96.2))
r.route('USB_ILIM_BRANCH',(8.26,94.75),(17.0625,89.5),start_layers=(0,),end_layers=(0,),bounds=(2,85,21,96.2))
c.save()
