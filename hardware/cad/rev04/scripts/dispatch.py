"""Serial host-side dispatcher for the official local Fusion MCP."""
import argparse, json, re, sys
from pathlib import Path
BASE=Path(__file__).resolve().parents[1]
sys.path.insert(0,str(BASE.parent/'scripts'))
from fusion_mcp import Client
p=argparse.ArgumentParser();p.add_argument('stage');p.add_argument('--timeout',type=float,default=600)
a=p.parse_args()
if not re.fullmatch(r'[a-zA-Z_][a-zA-Z_0-9]*\.[a-zA-Z_][a-zA-Z_0-9]*',a.stage):raise ValueError('Expected module.function')
module,function=a.stage.split('.')
script=f'''import sys,importlib\ndef run(_context:str):\n    path={str(BASE/'scripts')!r}\n    if path not in sys.path:sys.path.insert(0,path)\n    import build_a3\n    importlib.reload(build_a3)\n    m=importlib.import_module({module!r})\n    importlib.reload(m)\n    getattr(m,{function!r})()\n'''
r=Client(timeout=a.timeout).call('fusion_mcp_execute',{'featureType':'script','object':{'script':script}})
destination=BASE/'verification'/('bridge-'+a.stage+'.json')
destination.write_text(json.dumps(r,indent=2)+'\n')
print(json.dumps(r,indent=2))
if r.get('isError'):raise SystemExit(1)
for block in r.get('content',[]):
    if block.get('type')!='text':continue
    try:s=json.loads(block['text'])
    except json.JSONDecodeError:continue
    if isinstance(s,dict) and s.get('success') is False:raise SystemExit(1)
