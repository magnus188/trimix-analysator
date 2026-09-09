"""Read-only native local-bypass witnesses; no thermal/current-rating inference."""
from pathlib import Path
import sys,json,hashlib
D=Path(__file__).resolve().parent;sys.path.insert(0,str(D.parent/'current-path-review'));import inventory as a
out=[]
for name in['sys-main-pruned','cap-scl-merged']:
 f=D/(name+'.kicad_pcb');b=a.p.LoadBoard(str(f));g=a.NativeGraph(b,a.stackup(f.read_text()));rows=[]
 pairs=[('C101.1','U101.1'),('C101.2','C105.2'),('C108.1','U101.15')]
 for u,m in g.items.items():
  if m.get('ref')=='U101' and m['net']=='/01  CHARGING + BATTERY/BQ_PMID':pairs.append(('C102.1','U101.'+m['pin']))
 for s,t in pairs:
  for x in g.pad_index.get(s,[]):
   for y in g.pad_index.get(t,[]):rows.append({'source':s,'target':t,**g.witness(x,y)})
 out.append({'source_path':str(f),'source_sha256':hashlib.sha256(f.read_bytes()).hexdigest(),'witnesses':rows})
(D/'local-cap-loop-witnesses.json').write_text(json.dumps({'status':'Explicit native copper witnesses only; full-item resistance/length not true equivalent resistance; package/cap parasitics, planes and thermal omitted; physical stability/inrush/ripple pending','boards':out},indent=2))
for row in out:
 print(row['source_path'])
 for w in row['witnesses']:print(w['source'],w['target'],w['status'],w.get('layer_summary'),w.get('barrel_transition_count'))
