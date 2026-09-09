from pathlib import Path
import sys,json,hashlib
import pcbnew as p
sys.path.insert(0,str(Path('hardware/system-review/electrical/current-path-review').resolve()))
from inventory import NativeGraph,stackup
D=Path(__file__).resolve().parent;path=D/'ground2-series-frozen.kicad_pcb';b=p.LoadBoard(str(path));g=NativeGraph(b,stackup(path.read_text()))
rows=[]
for A,Z in [('Q110.1','U112.5'),('R118.1','U112.5'),('Q110.2','Q111.3'),('R119.1','U114.4'),('R116.1','U114.4')]:
 w=g.witness(g.pad_index[A][0],g.pad_index[Z][0]);assert w['status']=='explicit_native_witness',(A,Z,w);rows.append(dict(source=A,target=Z,witness=w))
for A in ['U115.8','R126.2']:
 for V in ['81a50918-f412-49be-81fe-86e8e1ae9c47','2ba862de-d0a8-4cf0-87a2-0078c6153d03']:
  w=g.witness(g.pad_index[A][0],V);assert w['status']=='explicit_native_witness',(A,V,w);rows.append(dict(source=A,target_via=V,witness=w))
(D/'ground2-series-witnesses.json').write_text(json.dumps(dict(source_sha256=hashlib.sha256(path.read_bytes()).hexdigest(),pairs=rows,method='Native direct adjacency; no assumed IC or same-pin internal joins; no zones in witness paths.'),indent=2))
print('PASS',len(rows),flush=True)
