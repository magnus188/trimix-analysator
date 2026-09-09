"""Derived paste-only export source; never alters the routed design source.

Remove only paste-layer membership and paste graphics belonging to components
outside the approved factory list. Every other pad/footprint/native item must
remain structurally identical. The resulting stencil still needs shop approval.
"""
from pathlib import Path
import argparse, copy, csv, hashlib, json, sys
HERE=Path(__file__).resolve().parent
sys.path[:0]=[str(HERE.parents[1]/'tools'),str(HERE)]
from analyzer_sheet import sx,child,children,fmt
from apply_review_fixes import top_blocks
ap=argparse.ArgumentParser();ap.add_argument('--board',type=Path,required=True);ap.add_argument('--factory-bom',type=Path,required=True);ap.add_argument('--out',type=Path,required=True);a=ap.parse_args()
factory={r['Reference'] for r in csv.DictReader(a.factory_bom.open())};raw=a.board.read_text();changes=[];edits=[];found=set()
for start,end,block in top_blocks(raw):
    if not block.startswith('(footprint'):continue
    before=sx.loads(block);after=copy.deepcopy(before);ref=next(p[2]for p in children(before,'property')if p[1]=='Reference');found.add(ref)
    if ref in factory:continue
    removed=[]
    for pad in children(after,'pad'):
        layers=child(pad,'layers')
        for layer in ['F.Paste','B.Paste']:
            if layer in layers:layers.remove(layer);removed.append({'pad_uuid':child(pad,'uuid')[1],'paste_layer':layer})
    for g in list(after):
        if isinstance(g,list) and child(g,'layer') and child(g,'layer')[1] in ['F.Paste','B.Paste']:
            after.remove(g);removed.append({'graphic':str(g)})
    if after!=before:
        # Replay the inverse layer-only edit to prove no other pad attributes changed.
        restored=copy.deepcopy(after)
        for bp,rp in zip(children(before,'pad'),children(restored,'pad')):
            old=child(rp,'layers');rp[rp.index(old)]=copy.deepcopy(child(bp,'layers'))
        before_without_paste_graphics=[g for g in before if not(isinstance(g,list)and child(g,'layer')and child(g,'layer')[1]in['F.Paste','B.Paste'])]
        assert restored==before_without_paste_graphics
        edits.append((start,end,fmt(after,1)));changes.append({'reference':ref,'removed':removed})
assert factory<=found
for start,end,text in reversed(edits):raw=raw[:start]+text+raw[end:]
a.out.mkdir(parents=True,exist_ok=False);board=a.out/'Factory_Stencil_Only.kicad_pcb';board.write_text(raw)
receipt={'source_board_sha256':hashlib.sha256(a.board.read_bytes()).hexdigest(),'derived_board_sha256':hashlib.sha256(board.read_bytes()).hexdigest(),'factory_bom_sha256':hashlib.sha256(a.factory_bom.read_bytes()).hexdigest(),'factory_references':sorted(factory),'changes':changes,'all_nonpaste_structure_preserved':True,'factory_part_apertures_unchanged':True,'derived_source_only':'Use only its F.Paste/B.Paste exports; this is not an alternate assembly/design board','shop_approval_pending':True,'order_release':False}
(a.out/'derivation-receipt.json').write_text(json.dumps(receipt,indent=2)+'\n');print(len(changes),'non-factory footprints have paste removed')
