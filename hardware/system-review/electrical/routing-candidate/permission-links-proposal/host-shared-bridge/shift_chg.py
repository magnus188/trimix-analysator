import route_context as c
p=c.p;b=c.b
old=c.vec((17.9,88.7));new=c.vec((17.65,88.7));changed=[]
for t in b.GetTracks():
 if t.GetNetname()!='CHG_INT_N':continue
 if isinstance(t,p.PCB_VIA)and t.GetPosition()==old:t.SetPosition(new);changed.append(t.m_Uuid.AsString())
 elif isinstance(t,p.PCB_TRACK):
  hit=False
  if t.GetStart()==old:t.SetStart(new);hit=True
  if t.GetEnd()==old:t.SetEnd(new);hit=True
  if hit:changed.append(t.m_Uuid.AsString())
assert len(changed)==3,changed;c.save();print(changed)
