from pathlib import Path
import sys,sexpdata,json,math
sys.path.insert(0,str(Path('hardware/system-review/electrical/main-final-independent').resolve()))
from cam_geometry import *
D=Path(__file__).resolve().parent
n=Native(sexpdata.loads((D/'q110-ground-frozen.kicad_pcb').read_text()))
obs=[q for q in n.pads+n.tracks+n.vias if q['net']!='GND'];tr=STRtree([q['geo']for q in obs]);smd=[q for q in n.pads if str(q['raw'][2])=='smd'];st=STRtree([q['geo']for q in smd]);hh=STRtree([q['geo']for q in n.holes]);out=[]
for x in range(330,461):
 for y in range(1680,1821):
  xy=(x/20,y/20);g=Point(xy[0],-xy[1]);
  if any(g.distance(obs[int(i)]['geo'])<.50001 for i in tr.query(g.buffer(.50001))):continue
  if any(g.distance(smd[int(i)]['geo'])<.50001 for i in st.query(g.buffer(.50001))):continue
  if any(g.distance(n.holes[int(i)]['geo'])<.40001 for i in hh.query(g.buffer(.40001))):continue
  out.append({'at':xy,'distance1':math.dist(xy,(18.6,88.45)),'distance2':math.dist(xy,(19.9921,88.2747))})
(D/'ground-sites-wide.json').write_text(json.dumps(out,indent=2));print('count',len(out));print('near1',sorted(out,key=lambda q:q['distance1'])[:15]);print('near2',sorted(out,key=lambda q:q['distance2'])[:15])
