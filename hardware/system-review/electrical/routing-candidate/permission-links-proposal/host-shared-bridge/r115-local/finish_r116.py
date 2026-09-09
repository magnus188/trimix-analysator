import route_context as c
p=c.p;c.b=p.LoadBoard(str(c.D/'escape-frozen.kicad_pcb'))
f=next(q for q in c.b.GetFootprints()if q.GetReference()=='R116');f.SetOrientationDegrees(0);f.SetPosition(c.vec((4.2,86.55)))
import route_bounded as r
r.route('USB_LIMIT_SET',(3.69,86.55),(4.95,88.85),start_layers=(0,),end_layers=(0,1,2),bounds=(2,83,12,96))
r.route('USB_ILIM_BRANCH',(4.71,86.55),(17.8,89.5),start_layers=(0,),end_layers=(0,1,2),bounds=(2,82,21,96.2))
c.save()
