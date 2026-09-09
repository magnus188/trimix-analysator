from search_local import *
out=[]
for cx,cy in [(17.2,90),(17.24,89.96),(17.25,89.95),(17.2,89.96),(17.15,89.96),(17.25,90)]:
 gnd,gs=route(cx,cy,'GND',(15.4,89.775),(cx,cy+.775))
 print(cx,cy,'GND',gs,gnd,flush=True)
 if not gnd:continue
 gg,ggs=route(cx,cy,'GND',(cx,cy+.775),(18.75,89.175))
 print('return',ggs,gg,flush=True)
 if not gg:continue
 ilm,st=route(cx,cy,NET['R126.1'],(15.4,90.225),(18.75,90.825),[('GND',gnd,.15),('GND',gg,.15)]);print('ILM',st,ilm,flush=True)
 if not ilm:continue
 dvd,ds=route(cx,cy,NET['C116.1'],(15.4,89.3),(cx,cy-.775),[(NET['R126.1'],ilm,.15),('GND',gnd,.15),('GND',gg,.15)])
 print('DVDT',ds,dvd,flush=True)
 if dvd:out.append({'centre':[cx,cy],'rotation':270,'removed':REM,'tracks':[(NET['R126.1'],ilm,.15),('GND',gnd,.15),('GND',gg,.15),(NET['C116.1'],dvd,.15)]})
(D/'ordered-results.json').write_text(json.dumps(out,indent=2))
