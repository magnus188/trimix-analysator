from pathlib import Path
D=Path(__file__).resolve().parent
import route_context as c
s=(D/'before.kicad_pcb').read_text();uid='877675ee-a8c4-429c-8084-f92d6210c16c';pos=s.index(uid);lo=s.rfind('(segment',0,pos);dep=0
for hi in range(lo,len(s)):
 if s[hi]=='(':dep+=1
 elif s[hi]==')':
  dep-=1
  if dep==0:break
s=s[:lo]+s[hi+1:];(D/'q-high-source.kicad_pcb').write_text(s);c.b=c.p.LoadBoard(str(D/'q-high-source.kicad_pcb'))
f=next(f for f in c.b.GetFootprints()if f.GetReference()=='R118');f.SetPosition(c.vec((26,86.75)));f.SetOrientationDegrees(270)
import route_bounded as r
try:r.route('USB_PERMISSION_Q',(26,85.925),(25.9507,82.0583),start_layers=(2,),end_layers=(0,1,2),bounds=(19,78,30,90))
except AssertionError as e:print('FAILED Q',e)
c.track('GND',[(26,87.575),(26,88.45)],c.p.B_Cu);c.via('GND',(26,88.45));c.save()
