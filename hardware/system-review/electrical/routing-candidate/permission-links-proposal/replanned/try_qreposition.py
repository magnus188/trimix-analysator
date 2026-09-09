from pathlib import Path
D=Path(__file__).resolve().parent
import build_bridge as c
s=(D/'handoff-partial-frozen.kicad_pcb').read_text();uid='877675ee-a8c4-429c-8084-f92d6210c16c';pos=s.index(uid);lo=s.rfind('(segment',0,pos);dep=0
for hi in range(lo,len(s)):
 if s[hi]=='(':dep+=1
 elif s[hi]==')':
  dep-=1
  if dep==0:break
s=s[:lo]+s[hi+1:];(D/'q-reposition-source.kicad_pcb').write_text(s)
c.b=c.p.LoadBoard(str(D/'q-reposition-source.kicad_pcb'))
f=next(f for f in c.b.GetFootprints()if f.GetReference()=='R118');f.SetPosition(c.vec((17.4,94)));f.SetOrientationDegrees(270)
import route_bounded as r
for name,start,end,sl,el in [('USB_PERMISSION_Q',(17.4,93.175),(16.1827,91.7017),(2,),(0,1,2)),('GND',(17.4,94.825),(19.1,93),(2,),(0,1,2))]:
 print('BEGIN',name,flush=True)
 try:r.route(name,start,end,start_layers=sl,end_layers=el,bounds=(11,85,27,98.2))
 except AssertionError as e:print('FAILED',e)
c.save()
