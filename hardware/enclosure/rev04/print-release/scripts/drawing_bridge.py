"""Call one explicit native-documentation stage through the official Fusion MCP."""
import argparse
import json
from pathlib import Path
import re
import sys

BASE = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(BASE.parents[1] / 'scripts'))
from fusion_mcp import Client

p = argparse.ArgumentParser()
p.add_argument('stage')
p.add_argument('--kwargs', default='{}')
p.add_argument('--read-only', action='store_true')
p.add_argument('--timeout', type=float, default=55)
a = p.parse_args()
if not re.fullmatch(r'drawing_[a-z_]+\.[a-z_]+', a.stage):
    raise ValueError('Expected drawing_module.function')
module, function = a.stage.split('.')
kwargs = json.loads(a.kwargs)
if not isinstance(kwargs, dict):
    raise ValueError('kwargs must be an object')
script = f'''import sys, importlib, json
def run(_context: str):
    path = {str(BASE / 'scripts')!r}
    if path not in sys.path: sys.path.insert(0, path)
    module = importlib.import_module({module!r})
    importlib.reload(module)
    result = getattr(module, {function!r})(**{kwargs!r})
    print(json.dumps(result, indent=2))
'''
response = Client(timeout=a.timeout).call('fusion_mcp_execute', {
    'featureType': 'script', 'object': {'script': script, 'readOnly': a.read_only}})
(BASE / 'verification').mkdir(parents=True, exist_ok=True)
(BASE / 'verification' / f'bridge-{a.stage}.json').write_text(json.dumps(response, indent=2) + '\n')
print(json.dumps(response, indent=2))
if response.get('isError'):
    raise SystemExit(1)
for block in response.get('content', []):
    if block.get('type') == 'text':
        try:
            result = json.loads(block['text'])
        except json.JSONDecodeError:
            continue
        if isinstance(result, dict) and result.get('success') is False:
            raise SystemExit(1)
