from pathlib import Path
import json
D=Path(__file__).resolve().parent
# Frozen current partial is preserved.
import build_bridge as c
c.b=c.p.LoadBoard(str(D/'partial-13uc.kicad_pcb'))
f=next(f for f in c.b.GetFootprints()if f.GetReference()=='R116');f.SetPosition(c.vec((5.5,87.4)));f.SetOrientationDegrees(90)
import route_bounded as r
for name,start,end in [('LIMIT',(5.5,88.225),(9.6602,92.2602)),('ILIM',(5.5,86.575),(17.5,88.3625))]:
 net='USB_LIMIT_SET'if name=='LIMIT'else'USB_ILIM_BRANCH';print('BEGIN',name,flush=True)
 try:r.route(net,start,end,start_layers=(0,),end_layers=(0,),bounds=(.6,81,28,98.2))
 except AssertionError as e:print('FAILED',name,str(e),flush=True)
 c.save()
