import route_context as c
p=c.p;c.b=p.LoadBoard(str(c.D/'branch-escape-open.kicad_pcb'))
for q in c.b.GetTracks():
 if q.GetNetname()!='CHG_INT_N':continue
 if isinstance(q,p.PCB_VIA):
  if c.xy(q.GetPosition())==(17.65,88.7):q.SetPosition(c.vec((17.675,88.7)))
 else:
  if c.xy(q.GetStart())==(17.65,88.7):q.SetStart(c.vec((17.675,88.7)))
  if c.xy(q.GetEnd())==(17.65,88.7):q.SetEnd(c.vec((17.675,88.7)))
c.via('USB_ILIM_BRANCH',(17.8,89.5));c.track('USB_ILIM_BRANCH',[(17,89.5),(17.8,89.5)],p.F_Cu)
c.track('GND',[(16.5,89.53),(17.1,89.3),(17.3,88.8),(18.75,89.175)],p.B_Cu)
import route_bounded as r
r.route('USB_OVP_UVLO',(13.6,91),(17.95,87.925),start_layers=(1,),end_layers=(1,),allow_vias=False,bounds=(12,87,20,92))
c.save()
