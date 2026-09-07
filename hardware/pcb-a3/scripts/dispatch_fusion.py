"""Serialize explicit PCBFit stages through official local Fusion MCP."""
from pathlib import Path
import sys,json,argparse,re
BASE=Path(__file__).resolve().parents[1]
sys.path.insert(0,str(BASE.parent/'enclosure/scripts'))
from fusion_mcp import Client
p=argparse.ArgumentParser();p.add_argument('stage');p.add_argument('--timeout',type=float,default=900);a=p.parse_args()
if not re.fullmatch(r'[a-zA-Z_][a-zA-Z_0-9]*\.[a-zA-Z_][a-zA-Z_0-9]*',a.stage):raise ValueError('module.function required')
mod,fn=a.stage.split('.')
script=f'''import sys,importlib\nimport adsk.core\ndef run(_context:str):\n    app=adsk.core.Application.get()\n    previous=app.activeDocument\n    path={str(BASE/'scripts')!r}\n    if path not in sys.path:sys.path.insert(0,path)\n    m=importlib.import_module({mod!r})\n    importlib.reload(m)\n    try:\n        getattr(m,{fn!r})()\n    finally:\n        if previous and previous.isValid and not previous.name.startswith('Trimix_Enclosure_A3_PCBFit'):\n            previous.activate()\n'''
r=Client(timeout=a.timeout).call('fusion_mcp_execute',{'featureType':'script','object':{'script':script}})
(BASE/'verification'/('bridge-'+a.stage+'.json')).write_text(json.dumps(r,indent=2)+'\n');print(json.dumps(r,indent=2))
if r.get('isError'):raise SystemExit(1)
for block in r.get('content',[]):
    if block.get('type')=='text':
        try:v=json.loads(block['text'])
        except json.JSONDecodeError:continue
        if isinstance(v,dict) and v.get('success') is False:raise SystemExit(1)
