import route_context as c
p=c.p;c.b=p.LoadBoard(str(c.D/'simpler-frozen.kicad_pcb'))
import route_bounded as r
r.route('USB_LIMIT_SET',(6.925,94.75),(4.95,88.85),start_layers=(0,),end_layers=(0,1,2),bounds=(2,83,12,96.2))
r.route('USB_ILIM_BRANCH',(8.575,94.75),(17.8,89.5),start_layers=(0,),end_layers=(0,1,2),bounds=(2,82,21,96.2))
c.save()
