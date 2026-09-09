"""Make an isolated cleanup trial; native partitions and DRC must follow.

Never edits its source. Never removes a named current-path witness or GND item.
The deliberately retained midpoint-junction failures in earlier rounds explain
why a DRC dangling warning alone is not permission to adopt these removals.
"""
from pathlib import Path
import argparse, hashlib, json, shutil, sys
HERE=Path(__file__).resolve().parent
ELECTRICAL=HERE.parent.parent
sys.path[:0]=[str(ELECTRICAL),str(ELECTRICAL.parents[1]/'tools')]
from analyzer_sheet import sx,child
from apply_review_fixes import top_blocks
ap=argparse.ArgumentParser();ap.add_argument('source',type=Path);ap.add_argument('output',type=Path);args=ap.parse_args()
base=args.source;out=args.output;d=json.loads((base/'drc.json').read_text())
assert not d['unconnected_items'] and not d['schematic_parity'],'Only source-complete candidates may enter final cleanup'
ids={x['uuid']for v in d['violations']if v['type']in ['track_dangling','via_dangling']for x in v['items']}
w=json.loads((HERE.parent/'complete-controls-root-review/current-paths/inventory.json').read_text())
def get(o):
 if isinstance(o,dict):
  for k,v in o.items():
   if k=='ordered_item_uuids':yield from v
   else:yield from get(v)
 elif isinstance(o,list):
  for v in o:yield from get(v)
assert not ids&set(get(w)),('Live power witness requires a separately reviewed tail trim',ids&set(get(w)))
raw=(base/'Trimix_Analyzer.kicad_pcb').read_text();ed=[]
for start,end,block in top_blocks(raw):
 if not block.startswith(('(segment','(via')):continue
 q=sx.loads(block)
 if child(q,'uuid')[1]in ids:
  assert child(q,'net')[-1]!='GND','Ground changes require an explicit reviewed delta'
  ed.append((start,end,block))
assert len(ed)==len(ids)and ids,'Missing UUID or no cleanup work'
shutil.copytree(base,out)
for start,end,block in reversed(ed):raw=raw[:start]+raw[end:]
(out/'Trimix_Analyzer.kicad_pcb').write_text(raw)
(out/'prune-delta.json').write_text(json.dumps({'source_sha256':hashlib.sha256((base/'Trimix_Analyzer.kicad_pcb').read_bytes()).hexdigest(),'removed':[{'uuid':child(sx.loads(block),'uuid')[1],'raw':block}for _,_,block in ed],'power_witness_items_removed':[],'ground_items_removed':[],'native_partition_and_DRC_checks_still_required':True},indent=2)+'\n')
print('Prepared isolated removal trial for',len(ids),'non-GND, non-power-witness leaves.')
