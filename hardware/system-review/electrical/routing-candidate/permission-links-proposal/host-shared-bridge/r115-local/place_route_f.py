import route_context as c
p=c.p;c.b=p.LoadBoard(str(c.D/'r115-0402-scout.kicad_pcb'))
f=next(q for q in c.b.GetFootprints()if q.GetReference()=='R115');f.SetOrientationDegrees(270);f.SetPosition(c.vec((22.45,84.4)));f.SetValue('10k / 0.1%')
for q in f.Pads():print('pad',q.GetNumber(),c.xy(q.GetPosition()),flush=True)
import route_bounded as r
r.route('HOST_3V3',(22.45,83.89),(22,83.25),start_layers=(0,),end_layers=(0,1,2),bounds=(20,80,25,87))
r.route('USB_PERMISSION_CLR_N',(22.45,84.91),(23.8625,84.85),start_layers=(0,),end_layers=(0,),bounds=(20,80,25,87))
c.save()
