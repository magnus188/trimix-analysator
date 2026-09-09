from pathlib import Path
D=Path(__file__).resolve().parent
import route_context as c
c.b=c.p.LoadBoard(str(D/'before.kicad_pcb'))
import route_bounded as r
for n,a,z in [('USB_LIMIT_SET',(6.925,94.75),(6.15,89.55)),('USB_LIMIT_SET',(6.925,94.75),(12.075,91.5)),('USB_ILIM_BRANCH',(8.575,94.75),(17.5,88.3625))]:
 print('BEGIN',n,a,z,flush=True)
 try:r.route(n,a,z,start_layers=(0,),end_layers=(0,),bounds=(.6,70,30,99.1))
 except AssertionError as e:print('FAILED',e,flush=True)
 c.save()
