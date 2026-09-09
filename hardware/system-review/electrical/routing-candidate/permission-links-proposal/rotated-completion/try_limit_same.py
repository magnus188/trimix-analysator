from pathlib import Path
D=Path(__file__).resolve().parent
import route_context as c
c.b=c.p.LoadBoard(str(D/'scout-base.kicad_pcb'))
import route_bounded as r
jobs=[('USB_LIMIT_SET',(6.15,89.55),(12.075,91.5)),('USB_LIMIT_SET',(6.925,94.75),(6.15,89.55)),('USB_ILIM_BRANCH',(8.575,94.75),(17.5,88.3625))]
for n,a,z in jobs:
 print('BEGIN',n,a,z,flush=True)
 try:r.route(n,a,z,start_layers=(0,),end_layers=(0,),bounds=(.6,81,28,98.2))
 except AssertionError as e:print('FAILED',e)
 c.save()
