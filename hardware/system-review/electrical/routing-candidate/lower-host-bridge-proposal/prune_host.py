from pathlib import Path
import sys,json,shutil
sys.path.insert(0,str(Path.cwd()/'hardware/tools'))
from analyzer_sheet import sx,child,children,fmt
D=Path(__file__).resolve().parent
f=D/'Trimix_Analyzer.kicad_pcb';a=sx.loads(f.read_text());o=sx.loads((D/'before.kicad_pcb').read_text())
old={child(q,'uuid')[1]for t in ['segment','via']for q in children(o,t)}
w=json.loads((D/'witness-C112.1.json').read_text());keep=[]
for u in w['ordered_item_uuids'][1:]:
 if u in old:break
 keep.append(u)
assert len(keep)==13
A=D/'unpruned-scout';A.mkdir(exist_ok=True)
for n in ['Trimix_Analyzer.kicad_pcb','after-drc.json','delta.json','witness-C112.1.json','witness-C110.1.json','witness-R120.1.json']:shutil.copy2(D/n,A/n)
removed=[]
for t in ['segment','via']:
 for q in list(children(a,t)):
  u=child(q,'uuid')[1]
  if u not in old and u not in keep:a.remove(q);removed.append(u)
  if u=='68f84deb-1702-403e-944c-520d4b6728f0':child(q,'end')[1:]=[26.1375,82.7372]
(D/'pruned-unfilled.kicad_pcb').write_text(fmt(a)+'\n')
(D/'pruning.json').write_text(json.dumps({'retained_added_items':keep,'removed_redundant_proposal_items':removed,'first_existing_join_uuid':'9ffc263c-0866-40de-98cd-06ae8a082e05','join_mm':[26.1375,82.7372],'why':'The proposed path had already joined the existing HOST rail before its remote search endpoint; remove the redundant loop.'},indent=2)+'\n')
print('Kept',len(keep),'removed',len(removed))
