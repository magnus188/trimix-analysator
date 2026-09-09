from pathlib import Path
import json
D=Path(__file__).resolve().parent
import route_context as c
p=c.p;c.b=p.LoadBoard(str(D/'series-base.kicad_pcb'));b=c.b
proposal=json.loads((D.parents[1]/'hypothetical-cc-outer-direct.json').read_text())
ids0={t.m_Uuid.AsString()for t in b.GetTracks()}
for x in proposal['segments']:
 if min(x['start'][0],x['end'][0])<17.9:continue
 c.track('USB_CC_INT_N',[x['start'],x['end']],p.F_Cu if x['layer']=='F.Cu'else p.B_Cu)
c.via('USB_CC_INT_N',(20.85,89.15))
ids={t.m_Uuid.AsString()for t in b.GetTracks()}-ids0
(D/'series-mock-cc-ids.json').write_text(json.dumps(list(ids)))
import route_bounded as r
r.route('USB_ILIM_SERIES',(20.9375,86),(18.45,90.2375),start_layers=(0,),end_layers=(0,),bounds=(.6,80,30,98.35))
c.save()
