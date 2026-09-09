"""One serialized operation through Autodesk's official local Fusion MCP."""
from pathlib import Path
import argparse,json,re,sys
BASE=Path(__file__).resolve().parents[1]
sys.path.insert(0,str(BASE.parents[2]/'hardware/cad/scripts'))
from fusion_mcp import Client
p=argparse.ArgumentParser();p.add_argument('stage');p.add_argument('--read-only',action='store_true');p.add_argument('--timeout',type=float,default=600)
a=p.parse_args()
if not re.fullmatch(r'[a-zA-Z_][a-zA-Z_0-9]*\.[a-zA-Z_][a-zA-Z_0-9]*',a.stage):raise ValueError('module.function required')
module,fn=a.stage.split('.')
script=f'''import sys,importlib
def run(_context:str):
    path={str(BASE/'scripts')!r}
    if path not in sys.path:sys.path.insert(0,path)
    import runtime
    importlib.reload(runtime)
    runtime.owned()
    runtime.configure()
    m=importlib.import_module({module!r})
    importlib.reload(m)
    getattr(m,{fn!r})()
'''
r=Client(timeout=a.timeout).call('fusion_mcp_execute',{'featureType':'script','object':{'script':script,'readOnly':a.read_only}})
out=BASE/'verification';out.mkdir(parents=True,exist_ok=True)
(out/('bridge-'+a.stage+'.json')).write_text(json.dumps(r,indent=2)+'\n')
print(json.dumps(r,indent=2))
if r.get('isError'):raise SystemExit(1)
for block in r.get('content',[]):
    if block.get('type')!='text':continue
    try:j=json.loads(block['text'])
    except json.JSONDecodeError:continue
    if isinstance(j,dict)and j.get('success')is False:raise SystemExit(1)
