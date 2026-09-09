from pathlib import Path
import sys,json,hashlib
D=Path(__file__).resolve().parent;sys.path.insert(0,str(Path('hardware/system-review/electrical/current-path-review').resolve()));from inventory import p,NativeGraph,stackup
f=D/'Trimix_Analyzer.kicad_pcb';b=p.LoadBoard(str(f));g=NativeGraph(b,stackup(f.read_text()));rows=[]
for a,z in [('U115.3','U113.3'),('U115.3','U110.6'),('U115.3','R111.2')]:
 for u in g.pad_index[a]:
  for v in g.pad_index[z]:rows.append(dict(source=a,target=z,witness=g.witness(u,v)))
assert all(x['witness']['status']=='explicit_native_witness'for x in rows)
(D/'native-witnesses.json').write_text(json.dumps({'board_sha256':hashlib.sha256(f.read_bytes()).hexdigest(),'method':'Native direct adjacency; zones and internal device connections excluded','rows':rows},indent=2)+'\n');print(len(rows),'direct CC witnesses passed')
