import route_context as c
p=c.p;c.b=p.LoadBoard(str(c.D/'simpler-escape-open.kicad_pcb'))
for q in c.b.GetTracks():
 if q.GetNetname()!='USB_CC_INT_N':continue
 if isinstance(q,p.PCB_VIA):
  if c.xy(q.GetPosition())==(16.7,90.3):q.SetPosition(c.vec((16.325,90.3)))
 else:
  if c.xy(q.GetStart())==(16.7,90.3):q.SetStart(c.vec((16.325,90.3)))
  if c.xy(q.GetEnd())==(16.7,90.3):q.SetEnd(c.vec((16.325,90.3)))
c.via('USB_ILIM_BRANCH',(17.8,89.5));c.track('USB_ILIM_BRANCH',[(17,89.5),(17.8,89.5)],p.F_Cu)
c.track('GND',[(16.5,89.53),(17.1,89.3),(17.3,88.8),(18.75,89.175)],p.B_Cu)
import route_bounded as r
r.route('CHG_INT_N',(16.8,87.8),(12.2,89.75),start_layers=(1,),end_layers=(1,),allow_vias=False,bounds=(11,87,19,91))
r.route('USB_OVP_UVLO',(13.6,91),(17.95,87.925),start_layers=(1,),end_layers=(1,),allow_vias=False,bounds=(12,87,20,92))
c.save()
