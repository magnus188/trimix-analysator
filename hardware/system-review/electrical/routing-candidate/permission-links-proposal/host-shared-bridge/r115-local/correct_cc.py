import route_context as c
p=c.p;c.b=p.LoadBoard(str(c.D/'simpler-frozen.kicad_pcb'))
for q in c.b.GetTracks():
 if q.GetNetname()!='USB_CC_INT_N':continue
 if isinstance(q,p.PCB_VIA):
  if c.xy(q.GetPosition())==(16.325,90.3):q.SetPosition(c.vec((16.7,90.36)))
 else:
  if c.xy(q.GetStart())==(16.325,90.3):q.SetStart(c.vec((16.7,90.36)))
  if c.xy(q.GetEnd())==(16.325,90.3):q.SetEnd(c.vec((16.7,90.36)))
c.save()
