"""Run one reviewed, automatically restored width sample via official MCP."""
from pathlib import Path
import argparse
import json
import sys

BASE=Path(__file__).resolve().parents[1]
sys.path.insert(0,str(BASE.parents[2]/'hardware/cad/scripts'))
from fusion_mcp import Client

parser=argparse.ArgumentParser()
parser.add_argument('width',type=float,choices=(85,85.5,86,86.5,87))
args=parser.parse_args()
width=int(args.width) if args.width.is_integer() else args.width
script=f'''import sys,importlib,json
def run(_context:str):
    path={str(BASE/'scripts')!r}
    if path not in sys.path:sys.path.insert(0,path)
    import runtime
    importlib.reload(runtime);runtime.owned();runtime.configure()
    import width_contract_checks as checks
    importlib.reload(checks)
    result=checks.trial({width!r})
    keys=('width_mm','core_width_contract_pass','clearance_status',
          'minimum_thickness_allocation_collisions','fastener_thickness_status',
          'path_status','driver_status','release')
    print(json.dumps({{k:result[k] for k in keys}}))
'''
reply=Client(timeout=1200).call('fusion_mcp_execute',{
    'featureType':'script','object':{'script':script,'readOnly':False}})
label='W'+str(width).replace('.','_')
(BASE/'verification'/('bridge-width-trial-'+label+'.json')).write_text(json.dumps(reply,indent=2)+'\n')
print(json.dumps(reply,indent=2))
if reply.get('isError'):raise SystemExit(1)
for block in reply.get('content',[]):
    if block.get('type')!='text':continue
    try:decoded=json.loads(block['text'])
    except json.JSONDecodeError:continue
    if isinstance(decoded,dict) and decoded.get('success') is False:raise SystemExit(1)
