import route_context as c
c.b=c.p.LoadBoard(str(c.D/'simpler-frozen.kicad_pcb'))
import route_bounded as r
r.route('USB_ILIM_BRANCH',(17.8,89.5),(8.575,94.75),start_layers=(0,1,2),end_layers=(0,),bounds=(2,80,29.4,99.2))
c.save()
