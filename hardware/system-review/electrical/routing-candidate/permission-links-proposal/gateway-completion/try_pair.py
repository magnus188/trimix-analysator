from pathlib import Path
D=Path(__file__).resolve().parent
import route_context as c
c.b=c.p.LoadBoard(str(D/'scout-base.kicad_pcb'))
for ref,at,ang in [('R116',(5.5,87.4),90),('R119',(7.75,94.75),0)]:
 f=next(f for f in c.b.GetFootprints()if f.GetReference()==ref);f.SetPosition(c.vec(at));f.SetOrientationDegrees(ang)
import route_bounded as r
jobs=[('USB_LIMIT_SET',(5.5,88.225),(6.15,89.55)),('USB_LIMIT_SET',(6.925,94.75),(6.15,89.55)),('USB_ILIM_BRANCH',(5.5,86.575),(17.5,88.3625))]
for n,a,z in jobs:
 print('BEGIN',n,a,z,flush=True)
 try:r.route(n,a,z,start_layers=(0,),end_layers=(0,),bounds=(.6,70,28,98.2))
 except AssertionError as e:print('FAILED',e)
 c.save()
c.track('GND',[(8.575,94.75),(8.575,95.75)],c.p.F_Cu);c.via('GND',(8.575,95.75));c.save()
