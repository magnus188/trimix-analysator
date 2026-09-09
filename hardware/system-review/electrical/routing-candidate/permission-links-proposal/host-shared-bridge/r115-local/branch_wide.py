import route_context as c
c.b=c.p.LoadBoard(str(c.D/'r116-scout-base.kicad_pcb'))
import route_bounded as r
r.route('USB_ILIM_BRANCH',(17.0625,89.5),(8.26,94.75),start_layers=(0,),end_layers=(0,),bounds=(2,80,29.4,96.2))
