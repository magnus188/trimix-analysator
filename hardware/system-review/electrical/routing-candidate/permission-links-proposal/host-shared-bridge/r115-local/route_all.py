import route_context as c
p=c.p;c.b=p.LoadBoard(str(c.D/'routes-open.kicad_pcb'))
f=next(q for q in c.b.GetFootprints()if q.GetReference()=='R115');f.SetOrientationDegrees(270);f.SetPosition(c.vec((21.4,83.3)));f.SetValue('10k / 0.1%')
import route_bounded as r
r.route('HOST_3V3',(21.4,82.79),(22,83.25),start_layers=(0,),end_layers=(0,1,2),bounds=(19,80,25,87))
r.route('USB_PERMISSION_CLR_N',(21.4,83.81),(21.4,84.4671),start_layers=(0,),end_layers=(0,),bounds=(19,80,25,87))
r.route('CHG_INT_N',(17.65,88.7),(12.2,89.75),start_layers=(1,),end_layers=(1,),allow_vias=False,bounds=(11,87,19,91))
r.route('USB_PERMISSION_Q',(11.26,91.95),(16.1827,91.7017),start_layers=(0,),end_layers=(0,1,2),bounds=(9,90,19,96))
c.save()
