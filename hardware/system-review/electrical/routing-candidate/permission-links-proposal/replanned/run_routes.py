from route_bounded import route
from build_bridge import save,D,b,p,xy
import json,math
fps={f.GetReference():f for f in b.GetFootprints()}
def pad(ref,pin):return next(q for q in fps[ref].Pads()if q.GetNumber()==str(pin))
def at(ref,pin):return xy(pad(ref,pin).GetPosition())
gnd=sorted([xy(q.GetPosition())for q in b.GetTracks()if isinstance(q,p.PCB_VIA)and q.GetNetname()=='GND'],key=lambda v:math.dist(at('R118',2),v))[0]
jobs=[('SERIES','USB_ILIM_SERIES',at('Q110',2),at('Q111',3),(0,),(0,)),('Qgate','USB_PERMISSION_Q',at('Q110',1),(16.1827,91.7017),(0,),(0,1,2)),('ILIM','USB_ILIM_BRANCH',at('R116',2),at('Q110',3),(0,),(0,)),('LIMIT','USB_LIMIT_SET',at('R116',1),at('R119',1),(0,),(0,)),('Qpull','USB_PERMISSION_Q',at('R118',1),(16.1827,91.7017),(2,),(0,1,2)),('GND','GND',at('R118',2),at('J102',2),(2,),(0,1,2)),('CLR','USB_PERMISSION_CLR_N',at('U113',1),(12.2546,95.1046),(0,),(0,1,2))]
assert pad('R119',1).GetNetname()=='USB_LIMIT_SET'
assert pad('Q110',3).GetNetname()=='USB_ILIM_BRANCH'
assert pad('Q110',2).GetNetname()==pad('Q111',3).GetNetname()=='USB_ILIM_SERIES'
assert pad('R118',1).GetNetname()==pad('Q110',1).GetNetname()=='USB_PERMISSION_Q'
assert pad('R118',2).GetNetname()==pad('J102',2).GetNetname()=='GND'
results=[]
for name,net,start,end,sl,el in jobs:
 before={q.m_Uuid.AsString()for q in b.GetTracks()};print('BEGIN',name,start,end,flush=True)
 try:
  route(net,start,end,start_layers=sl,end_layers=el,width=.15,bounds=(.6,78,29.4,98.2));ok=True
 except AssertionError as e:print('FAILED',name,str(e),flush=True);ok=False
 added=[q.m_Uuid.AsString()for q in b.GetTracks()if q.m_Uuid.AsString()not in before];results.append(dict(name=name,net=net,success=ok,added_copper_uuids=added));print('END',name,'success',ok,'added',len(added),flush=True)
 save();p.SaveBoard(str(D/(name+'-stage.kicad_pcb')),b)
save();(D/'route-results.json').write_text(json.dumps(results,indent=2)+'\n')
