"""Bounded host-side dispatch, no dependency on historical paths/guards."""
from pathlib import Path
import argparse, json, sys
BASE = Path(__file__).resolve().parents[1]
ROOT = BASE.parents[2]
sys.path.insert(0, str(ROOT / 'hardware/cad/scripts'))
from fusion_mcp import Client
p=argparse.ArgumentParser(); p.add_argument('stage'); p.add_argument('--read-only', action='store_true')
p.add_argument('--timeout', type=float, default=300)
a=p.parse_args()
if not a.stage.isidentifier(): raise ValueError('One named stage only')
script=f'''import sys, importlib
def run(_context: str):
    p={str(BASE/'scripts')!r}
    if p not in sys.path: sys.path.insert(0,p)
    import connector_photo_review as m
    importlib.reload(m)
    getattr(m,{a.stage!r})()
'''
r=Client(timeout=a.timeout).call('fusion_mcp_execute',{'featureType':'script','object':{'script':script,'readOnly':a.read_only}})
out=BASE/'connector-review';out.mkdir(parents=True,exist_ok=True)
(out/('bridge-'+a.stage+'.json')).write_text(json.dumps(r,indent=2)+'\n')
print(json.dumps(r,indent=2))
if r.get('isError'): raise SystemExit(1)
for block in r.get('content',[]):
    if block.get('type')=='text':
        try: data=json.loads(block['text'])
        except json.JSONDecodeError: continue
        if isinstance(data,dict) and data.get('success') is False: raise SystemExit(1)
