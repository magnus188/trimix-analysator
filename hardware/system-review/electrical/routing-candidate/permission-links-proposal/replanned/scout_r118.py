from pathlib import Path
import sys,sexpdata,json,math
sys.path.insert(0,str(Path('hardware/system-review/electrical/main-final-independent').resolve()))
from cam_geometry import *
from shapely.ops import polygonize
D=Path(__file__).resolve().parent
raw=sexpdata.loads((D/'before.kicad_pcb').read_text());n=Native(raw)
exec((D.parent/'scout_q110.py').read_text().split('def courtyard(fp):')[1].split('fps=subs')[0].join(['def courtyard(fp):','']))
fps={next(x[2]for x in subs(f,'property')if x[1]=='Reference'):f for f in subs(raw,'footprint')};cy={ref:courtyard(fp)for ref,fp in fps.items()}
def movegeo(g,ref,at,ang):
 f=next(q for q in n.fps if q['ref']==ref);return affinity.translate(affinity.rotate(g,ang-f['rotation'],origin=(f['x'],f['y'])),at[0]-f['x'],-at[1]-f['y'])
fixed={'Q110':((17.5,89.3),90),'R116':((7.75,94.75),0)}
others=[movegeo(g,ref,*fixed[ref])if ref in fixed else g for ref,g in cy.items()if ref!='R118' and not g.is_empty]
for z in subs(raw,'zone'):
 k=next((q for q in z if tag(q)=='keepout'),None)
 if not k or str(sub(k,'footprints',[''])[0])!='not_allowed':continue
 for poly in subs(z,'polygon'):
  pts=next(q for q in poly if tag(q)=='pts');others.append(Polygon([(q[1],-q[2])for q in pts[1:]]))
ct=STRtree(others)
removed={q['uuid']for q in json.loads((D/'removed-source-copper.json').read_text())}
tracks=[t for t in n.tracks if not any(math.dist(t['a'],n.xy(sub(q,'start')))<1e-6 and math.dist(t['b'],n.xy(sub(q,'end')))<1e-6 and str(sub(q,'uuid',[''])[0])in removed for q in subs(raw,'segment'))]
obs=[]
for q in n.pads_on('F.Cu'):
 if q['ref']=='R118':continue
 obs.append(dict(q,geo=movegeo(q['geo'],q['ref'],*fixed[q['ref']]))if q['ref']in fixed else q)
obs+=tracks+[v for v in n.vias if math.dist(v['xy'],(8.575,-95.75))>.001]
# Only F copper; track list needs layer filter.
obs=[o for o in obs if 'layer'not in o or o['layer']=='F.Cu']
obs+=[dict(net='UVLO_RESERVED',geo=Point(13.6,-91).buffer(.25))]
newpack=LineString([(21.5013,-90.25),(20.2,-90.25),(20.2,-91.4),(17.7,-91.4),(16.1335,-93)]).buffer(.2);obs.append(dict(net='PACK_P',geo=newpack))
tr=STRtree([o['geo']for o in obs]);pp=[q for q in n.pads if q['ref']=='R118'];good=[]
for ang in [0,90,180,270]:
 for xi in range(55,271):
  for yi in range(780,971):
   at=(xi*.1,yi*.1);g=movegeo(cy['R118'],'R118',at,ang)
   if len(ct.query(g.buffer(-.00001),predicate='intersects')):continue
   pads=[dict(q,geo=movegeo(q['geo'],'R118',at,ang))for q in pp]
   if any(any(obs[int(i)]['net']!=p['net']and p['geo'].distance(obs[int(i)]['geo'])<.20001 for i in tr.query(p['geo'].buffer(.20001)))for p in pads):continue
   good.append(dict(at=at,angle=ang,distance_to_Q110=math.dist(at,fixed['Q110'][0])))
good.sort(key=lambda q:q['distance_to_Q110']);(D/'r118-scout.json').write_text(json.dumps(good,indent=2)+'\n');print('clear',len(good));print(json.dumps(good[:15],indent=2))
