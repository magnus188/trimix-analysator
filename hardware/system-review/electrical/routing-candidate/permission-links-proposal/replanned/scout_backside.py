from pathlib import Path
import sys,sexpdata,json,math
sys.path.insert(0,str(Path('hardware/system-review/electrical/main-final-independent').resolve()))
from cam_geometry import *
from shapely.ops import polygonize
D=Path(__file__).resolve().parent
raw=sexpdata.loads((D/'Trimix_Analyzer.kicad_pcb').read_text());n=Native(raw)
func=(D.parent/'scout_q110.py').read_text().split('def courtyard(fp):')[1].split('fps=subs')[0];func=func.replace("['F.CrtYd']","['B.CrtYd']");exec('def courtyard(fp):'+func)
fps={next(x[2]for x in subs(f,'property')if x[1]=='Reference'):f for f in subs(raw,'footprint')};cy={ref:courtyard(fp)for ref,fp in fps.items()};ignore={'R116','R118'}
othercy=[g for ref,g in cy.items()if ref not in ignore and not g.is_empty]
for z in subs(raw,'zone'):
 k=next((q for q in z if tag(q)=='keepout'),None)
 if not k or str(sub(k,'footprints',[''])[0])!='not_allowed' or sub(z,'layer')!=['B.Cu']:continue
 for poly in subs(z,'polygon'):othercy.append(Polygon([(q[1],-q[2])for q in next(q for q in poly if tag(q)=='pts')[1:]]))
ct=STRtree(othercy)
obs=[q for q in n.pads_on('B.Cu')if q['ref']not in ignore]+[q for q in n.tracks if q['layer']=='B.Cu']+n.vias
# Reserve verified UVLO and raw-source through-via proposals.
for at in [(13.6,-91),(16.7,-87.95),(13,-91.65)]:obs.append(dict(net='RESERVED',geo=Point(at).buffer(.25)))
for a,b in [((13.675,-90.975),(13.6,-91)),((16.7,-87.95),(17.5,-87.2217))]:obs.append(dict(net='RESERVED',geo=LineString([a,b]).buffer(.075)))
tr=STRtree([q['geo']for q in obs]);holes=STRtree([h['geo']for h in n.holes]);allout={}
for ref,target,bounds in [('R118',(16.1827,91.7017),(13,88,23,96.4)),('R116',(12.075,91.5),(8,82,23,96.4))]:
 fp=next(q for q in n.fps if q['ref']==ref);pp=[q for q in n.pads if q['ref']==ref];good=[]
 def transform(g,at,ang):return affinity.translate(affinity.rotate(g,ang-fp['rotation'],origin=(fp['x'],fp['y'])),at[0]-fp['x'],-at[1]-fp['y'])
 for ang in [0,90,180,270]:
  for xi in range(round(bounds[0]*10),round(bounds[2]*10)+1):
   for yi in range(round(bounds[1]*10),round(bounds[3]*10)+1):
    at=(xi/10,yi/10);g=transform(cy[ref],at,ang)
    if len(ct.query(g.buffer(-.00001),predicate='intersects')):continue
    pads=[dict(q,geo=transform(q['geo'],at,ang))for q in pp]
    if any(any(obs[int(i)]['net']!=p['net']and p['geo'].distance(obs[int(i)]['geo'])<.20001 for i in tr.query(p['geo'].buffer(.20001)))for p in pads):continue
    if any(any(p['geo'].distance(n.holes[int(i)]['geo'])<.25001 for i in holes.query(p['geo'].buffer(.25001)))for p in pads):continue
    good.append(dict(at=at,angle=ang,distance_to_target=math.dist(at,target)))
 good.sort(key=lambda q:q['distance_to_target']);allout[ref]=good;print(ref,len(good),json.dumps(good[:10]),flush=True)
(D/'backside-scout.json').write_text(json.dumps(allout,indent=2)+'\n')
