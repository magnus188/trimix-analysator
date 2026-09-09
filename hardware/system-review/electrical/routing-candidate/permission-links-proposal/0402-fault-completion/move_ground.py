from pathlib import Path
import json
D=Path(__file__).resolve().parent
import route_context as c
p=c.p;b=c.b;changes=[]
for old,new in [((18.6,88.45),(19.7,87.75)),((19.9921,88.2747),(20.4,87.9))]:
 for t in b.GetTracks():
  if t.GetNetname()!='GND':continue
  if isinstance(t,p.PCB_VIA):
   if c.xy(t.GetPosition())==old:
    changes.append({'uuid':t.m_Uuid.AsString(),'kind':'via','before':old,'after':new});t.SetPosition(c.vec(new))
  else:
   for fn,setfn in [('GetStart','SetStart'),('GetEnd','SetEnd')]:
    if c.xy(getattr(t,fn)())==old:
     changes.append({'uuid':t.m_Uuid.AsString(),'kind':'track','endpoint':fn,'before':old,'after':new,'width':p.ToMM(t.GetWidth()),'layer':b.GetLayerName(t.GetLayer())});getattr(t,setfn)(c.vec(new))
(D/'ground-relocation.json').write_text(json.dumps(changes,indent=2));c.save()
print(changes,flush=True)
