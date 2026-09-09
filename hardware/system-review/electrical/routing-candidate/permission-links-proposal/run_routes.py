from route_bounded import route
from build_bridge import save,D,b,p
import json
jobs=[('SERIES','USB_ILIM_SERIES',(16,88.4),(20.9375,86),(2,),(0,)),('ILIM','USB_ILIM_BRANCH',(19.1375,89.2),(15.325,90.75),(0,),(0,)),('Qgate','USB_PERMISSION_Q',(17.2625,88.25),(22.0427,87.1732),(0,),(0,1,2)),('Qlower','USB_PERMISSION_Q',(13.0309,95.2047),(16.1827,91.7017),(0,),(0,1,2)),('CLR','USB_PERMISSION_CLR_N',(23.8625,84.85),(12.2546,95.1046),(0,),(0,1,2))]
results=[]
for name,net,start,end,sl,el in jobs:
 before={q.m_Uuid.AsString()for q in b.GetTracks()}
 print('BEGIN',name,flush=True)
 try:
  route(net,start,end,start_layers=sl,end_layers=el,width=.15,bounds=(.6,78,29.4,98.2));ok=True
 except AssertionError as e:print('FAILED',name,str(e),flush=True);ok=False
 added=[q.m_Uuid.AsString()for q in b.GetTracks()if q.m_Uuid.AsString()not in before]
 results.append(dict(name=name,net=net,success=ok,added_copper_uuids=added));print('END',name,'success',ok,'added',len(added),flush=True)
 save();p.SaveBoard(str(D/(name+'-stage.kicad_pcb')),b)
save()
(D/'route-results.json').write_text(json.dumps(results,indent=2)+'\n')
