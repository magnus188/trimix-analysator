from pathlib import Path
D=Path(__file__).resolve().parent
import build_bridge as c
s=(D/'partial-13uc.kicad_pcb').read_text()
for uid in ['c275b53a-257e-47b7-93eb-b01e5ec9c376','df3bc06f-eac3-4e42-88c7-89049665b00a','ed10eecb-4ca9-4bb9-bf6b-9d93947fecb3']:
 if uid not in s:continue
 pos=s.index(uid);lo=max(s.rfind('(segment',0,pos),s.rfind('(via',0,pos));depth=0;quote=False
 for hi in range(lo,len(s)):
  ch=s[hi]
  if ch=='"':quote=not quote
  elif not quote:
   if ch=='(':depth+=1
   elif ch==')':
    depth-=1
    if depth==0:break
 s=s[:lo]+s[hi+1:]
(D/'partial-cleanup.kicad_pcb').write_text(s);c.b=c.p.LoadBoard(str(D/'partial-cleanup.kicad_pcb'))
import route_bounded as r
try:r.route('USB_PERMISSION_Q',(17.4,95.525),(16.1827,91.7017),start_layers=(2,),end_layers=(0,1,2),bounds=(11,85,27,98.2))
except AssertionError as e:print('FAILED',e)
c.save()
