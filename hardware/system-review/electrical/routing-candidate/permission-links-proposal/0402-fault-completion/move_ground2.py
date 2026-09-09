from pathlib import Path
import json
D=Path(__file__).resolve().parent
import route_context as c
p=c.p;c.b=p.LoadBoard(str(D/'ground2-base.kicad_pcb'));b=c.b;changes=[]
for old,new in [((19.7,87.75),(20.3,87.85)),((20.4,87.9),(20.75,88.3))]:
 for t in b.GetTracks():
  if t.GetNetname()!='GND':continue
  if isinstance(t,p.PCB_VIA):
   if c.xy(t.GetPosition())==old:
    changes.append({'uuid':t.m_Uuid.AsString(),'kind':'via','before':old,'after':new});t.SetPosition(c.vec(new))
  else:
   for fn,setfn in [('GetStart','SetStart'),('GetEnd','SetEnd')]:
    if c.xy(getattr(t,fn)())==old:
     changes.append({'uuid':t.m_Uuid.AsString(),'kind':'track','endpoint':fn,'before':old,'after':new,'width':p.ToMM(t.GetWidth()),'layer':b.GetLayerName(t.GetLayer())});getattr(t,setfn)(c.vec(new))
(D/'ground2-relocation.json').write_text(json.dumps(changes,indent=2));c.track('USB_PERMISSION_Q',[(17.5142,91.7017),(21.4,88.8),(22.0427,87.1732)],p.In2_Cu);c.save()
print(changes,flush=True)
