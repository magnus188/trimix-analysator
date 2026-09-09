import route_context as c
p=c.p;c.b=p.LoadBoard(str(c.D/'branch-complete-frozen.kicad_pcb'))
for q in c.b.GetTracks():
 if q.GetNetname()!='USB_CC_INT_N':continue
 if isinstance(q,p.PCB_VIA):
  if c.xy(q.GetPosition())==(16.325,90.3):q.SetPosition(c.vec((16.7,90.36)))
 else:
  if c.xy(q.GetStart())==(16.325,90.3):q.SetStart(c.vec((16.7,90.36)))
  if c.xy(q.GetEnd())==(16.325,90.3):q.SetEnd(c.vec((16.7,90.36)))
c.via('USB_LIMIT_SET',(5.925,94.025));c.via('USB_LIMIT_SET',(7.125,91.1))
c.track('USB_LIMIT_SET',[(6.925,94.75),(5.925,94.025)],p.F_Cu)
c.track('USB_LIMIT_SET',[(5.925,94.025),(4.55,92.6),(4.475,92.4),(4.45,92.1),(5.475,91.1),(7.125,91.1)],p.B_Cu)
c.track('USB_LIMIT_SET',[(7.125,91.1),(6.675,90.75),(4.95,88.85)],p.In2_Cu)
c.save()
