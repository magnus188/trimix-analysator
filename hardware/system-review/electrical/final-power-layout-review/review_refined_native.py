"""Read-only, explicitly hash-bound power-path comparison for a refined checkpoint.

Run with KiCad's Python: script BOARD EXPECTED_SHA OUTPUT_DIRECTORY.
Lengths are sums of complete native items, not equivalent impedances or loop areas.
"""
from pathlib import Path
import sys,json,hashlib,itertools
import pcbnew as p

D=Path(__file__).resolve().parent
sys.path.insert(0,str(D.parent/'current-path-review'))
from inventory import NativeGraph,stackup,run
src=Path(sys.argv[1]).resolve();expected=sys.argv[2];out=Path(sys.argv[3]).resolve()
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
assert sha(src)==expected
old=json.load(open(D/'native-local-paths.json'))
assert old['board_sha256']=='9f274fdf198f1bcb871a4fc360e76693f8a5b048553e6a02998141737956514f'
out.mkdir(parents=True,exist_ok=True)
run(src,out/'current-paths')
b=p.LoadBoard(str(src));g=NativeGraph(b,stackup(src.read_text()))
rows=[]
for previous in old['paths']:
 aa,bb=previous['source'],previous['target']
 opts=[g.witness(u,v)for u,v in itertools.product(g.pad_index[aa],g.pad_index[bb])]
 good=[q for q in opts if q['status']=='explicit_native_witness']
 assert good,(aa,bb)
 current=min(good,key=lambda q:q['full_item_estimate_ohm_20C_25um_1p6mm'])
 total=lambda q:sum(v['full_item_length_mm']for v in q.get('layer_summary',{}).values())
 rows.append(dict(source=aa,target=bb,before_full_item_length_mm=total(previous),after_full_item_length_mm=total(current),before_barrels=previous['barrel_transition_count'],after_barrels=current['barrel_transition_count'],before_layers=previous['layer_summary'],**current))
targets={('U701.1','R702.1'),('U101.21','C103.2'),('U101.19','C103.1'),('U701.6','C702.1'),('U101.22','C107.1')}
comparisons=[dict(source=r['source'],target=r['target'],before_mm=r['before_full_item_length_mm'],after_mm=r['after_full_item_length_mm'],shorter=r['after_full_item_length_mm']<r['before_full_item_length_mm'])for r in rows if(r['source'],r['target'])in targets]
assert len(comparisons)==5
ground=[]
for name in ['C103.1','C107.2','U701.4','C702.2','C703.2','R702.2']:
 u=g.pad_index[name][0]
 if g.items[u]['net']!='GND':continue
 pt=g.items[u]['at_mm'];anchors=sorted([q for q in g.items.values()if q.get('plated')and q['net']=='GND'],key=lambda q:sum((x-y)**2for x,y in zip(pt,q['at_mm'])))[:16]
 opts=[dict(anchor_uuid=a['uuid'],anchor_at_mm=a['at_mm'],**g.witness(u,a['uuid']))for a in anchors]
 good=[q for q in opts if q['status']=='explicit_native_witness']
 ground.append(dict(pad=name,nearest_16_search=True,witness=min(good,key=lambda q:q['full_item_estimate_ohm_20C_25um_1p6mm'])if good else None))
direct_return=g.witness(g.pad_index['C702.2'][0],g.pad_index['U701.4'][0])
assert direct_return['status']=='explicit_native_witness'and direct_return['barrel_transition_count']==0 and set(direct_return['layer_summary'])=={'F.Cu'}
r=dict(status='TRACE_WITNESSES_COMPLETE_PENDING_VISUAL_AND_GROUND_REVIEW',source=str(src),source_sha256=expected,previous_board_sha256=old['board_sha256'],previous_local_path_receipt_sha256=sha(D/'native-local-paths.json'),script_sha256=sha(Path(__file__)),inventory_reader_sha256=sha(D.parent/'current-path-review/inventory.py'),paths=rows,selected_layout_comparisons=comparisons,all_five_target_paths_shorter=all(r['shorter']for r in comparisons),direct_output_ground_return=dict(source='C702.2',target='U701.4',**direct_return),local_ground=ground,power_inventory_sha256=sha(out/'current-paths/inventory.json'),items={u:g.items[u]for r in rows for u in r['ordered_item_uuids']},limits=['No fill, save or board mutation.','Same-net or same-pin labels do not create graph connections.','Whole native item lengths and resistance sensitivities are not clipped end-to-end lengths, loop inductance, current ratings or guaranteed performance.','Ground-plane topology, component-pin limits, filtering and visual switching-loop review are separate.','Factory and physical qualification remain pending.'])
assert sha(src)==expected
(out/'refined-local-paths.json').write_text(json.dumps(r,indent=2)+'\n')
print(json.dumps(dict(paths=len(rows),all_five_target_paths_shorter=r['all_five_target_paths_shorter'],comparisons=comparisons),indent=2))
