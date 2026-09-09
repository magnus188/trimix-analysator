from pathlib import Path
D=Path(__file__).resolve().parent
import route_context as c
import route_bounded as r
for net,start,end,sl,el in [('USB_ILIM_SERIES',(18.9375,88.55),(20.9375,86),(0,),(0,)),('USB_PERMISSION_Q',(18.9375,90.45),(16.1827,91.7017),(0,),(0,1,2)),('USB_PERMISSION_Q',(11.26,91.95),(16.1827,91.7017),(0,),(0,1,2))]:
 print('BEGIN',net,start,end,flush=True)
 try:r.route(net,start,end,start_layers=sl,end_layers=el,bounds=(.6,80,30,98.35));c.save()
 except AssertionError as e:print(e,flush=True)
