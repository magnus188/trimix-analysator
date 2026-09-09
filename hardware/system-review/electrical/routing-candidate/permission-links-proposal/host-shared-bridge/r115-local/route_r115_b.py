import route_context as c
c.b=c.p.LoadBoard(str(c.D/'placed.kicad_pcb'))
import route_bounded as r
r.route('HOST_3V3',(26,87.575),(26,83.75),start_layers=(2,),end_layers=(0,1,2),bounds=(20,80,29.4,90))
r.route('USB_PERMISSION_CLR_N',(26,85.925),(23.8625,84.85),start_layers=(2,),end_layers=(0,),bounds=(20,80,29.4,90))
c.save()
