from pathlib import Path
import json
D=Path(__file__).resolve().parent
snap=(D/'Trimix_Analyzer.kicad_pcb').read_bytes();(D/'partial-13uc.kicad_pcb').write_bytes(snap)
import build_bridge as c
c.b=c.p.LoadBoard(str(D/'partial-13uc.kicad_pcb'))
f=next(f for f in c.b.GetFootprints()if f.GetReference()=='R116');f.SetOrientationDegrees(180)
import route_bounded as r
for name,start,end in [('LIMIT',(8.575,94.75),(9.6602,92.2602)),('ILIM',(6.925,94.75),(17.5,88.3625))]:
 net='USB_LIMIT_SET'if name=='LIMIT'else'USB_ILIM_BRANCH';print('BEGIN',name,flush=True)
 try:r.route(net,start,end,start_layers=(0,),end_layers=(0,),bounds=(.6,83,28,98.2))
 except AssertionError as e:print('FAILED',name,str(e),flush=True)
 c.save()
