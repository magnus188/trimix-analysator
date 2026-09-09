import route_context as c
p=c.p;c.b=p.LoadBoard(str(c.D/'r116-scout-base.kicad_pcb'))
f=next(q for q in c.b.GetFootprints()if q.GetReference()=='Q110')
for q in f.Pads():
 q.SetShape(p.PAD_SHAPE_RECT);q.SetSize(c.vec((.9,.8)));q.SetPosition(c.vec({'1':(19,90.45),'2':(19,88.55),'3':(17,89.5)}[q.GetNumber()]))
f.SetFPID(p.LIB_ID('Trimix_Power','DMN2056U_SOT23_Diodes_Recommended'))
p.SaveBoard(str(c.D/'q110-manufacturer-scout.kicad_pcb'),c.b)
import route_bounded as r
r.route('USB_ILIM_BRANCH',(17,89.5),(8.26,94.75),start_layers=(0,),end_layers=(0,),bounds=(2,80,29.4,96.2))
c.save()
