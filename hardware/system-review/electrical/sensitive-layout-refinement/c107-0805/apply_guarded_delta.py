"""Apply only reviewed C107 delta to an ISOLATED output. KiCad refill/DRC and metadata integration remain separate."""
from pathlib import Path
import argparse,json,sexpdata as s
D=Path(__file__).resolve().parent
ap=argparse.ArgumentParser();ap.add_argument('--source',type=Path,required=True);ap.add_argument('--out',type=Path,required=True);a=ap.parse_args()
assert a.source.resolve()!=a.out.resolve(),'Never overwrite input'
assert 'hardware/pcb'not in str(a.out),'No canonical output permitted'
r=json.loads((D/'guarded-delta-and-ground.json').read_text());b=s.loads(a.source.read_text())
def sub(x,k):return next((v for v in x if isinstance(v,list)and str(v[0])==k),None)
def uid(x):
 q=sub(x,'uuid');return q[1]if q else None
objs={uid(x):x for x in b if isinstance(x,list)}
for u,t in r['removed_original_items'].items():assert objs[u]==s.loads(t),f'Original changed: {u}'
u=r['footprint_delta']['modified'][0];assert objs[u]==s.loads(r['original_C107_guard']),'C107 original changed'
remove=set(r['copper_delta']['removed'])|{u};b=[x for x in b if not isinstance(x,list)or uid(x)not in remove]
b.extend(s.loads(t)for t in r['added_items'].values());b.append(s.loads(r['new_C107']))
a.out.parent.mkdir(parents=True,exist_ok=True);a.out.write_text(s.dumps(b)+'\n');print('Wrote isolated delta. Refill/DRC/project+schematic sync required:',a.out)
