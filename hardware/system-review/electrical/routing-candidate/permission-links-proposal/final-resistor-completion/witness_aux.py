from pathlib import Path
import sys,json,hashlib
import pcbnew as p
sys.path.insert(0,str(Path('hardware/system-review/electrical/current-path-review').resolve()))
from inventory import NativeGraph,stackup
D=Path(__file__).resolve().parent;path=D/'r118-r119-frozen.kicad_pcb';b=p.LoadBoard(str(path));g=NativeGraph(b,stackup(path.read_text()))
rows=[]
for A,Z in [('R118.1','U112.5'),('R119.1','U114.4')]:
 w=g.witness(g.pad_index[A][0],g.pad_index[Z][0]);assert w['status']=='explicit_native_witness',(A,Z,w);rows.append(dict(source=A,target=Z,witness=w))
for A,V in [('R118.2','71bceb66-738c-4023-9eb7-50d40bb299bb'),('R119.2','f37fff8a-5365-4545-b8ef-52d2339f0750')]:
 w=g.witness(g.pad_index[A][0],V);assert w['status']=='explicit_native_witness',(A,V,w);rows.append(dict(source=A,target_via=V,witness=w))
(D/'r118-r119-witnesses.json').write_text(json.dumps(dict(source_sha256=hashlib.sha256(path.read_bytes()).hexdigest(),pairs=rows,method='Native direct adjacency; no assumed IC or same-pin internal joins; no zones in witness paths.'),indent=2))
print('PASS',len(rows),flush=True)
