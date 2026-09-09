from pathlib import Path
import sys,json,hashlib,math
D=Path(__file__).resolve().parent;sys.path.insert(0,str(D.parent));from inventory import p,NativeGraph,stackup
f=D/'source/routing-snapshot.kicad_pcb';b=p.LoadBoard(str(f));g=NativeGraph(b,stackup(f.read_text()))
pairs=[('L101.2','C104.1'),('L101.2','C105.1'),('U101.15','C104.1'),('U101.15','C105.1'),('U101.16','C104.1'),('U101.16','C105.1'),('U101.15','C201.1'),('U101.15','C202.1'),('U101.19','L101.1'),('U101.20','L101.1'),('C104.2','U101.17'),('C104.2','U101.18'),('C105.2','U101.17'),('C105.2','U101.18')]
rows=[]
for a,z in pairs:
 for u in g.pad_index[a]:
  for v in g.pad_index[z]:
   d=math.dist(g.items[u]['at_mm'],g.items[v]['at_mm']);w=g.witness(u,v);rows.append(dict(source=a,target=z,pad_centre_straight_line_mm=d,witness=w))
out=dict(source_board_sha256=hashlib.sha256(f.read_bytes()).hexdigest(),method='Native direct adjacency trace/barrel witnesses, zones excluded; no IC internals or presumed pad joins',meaning='Witness lengths are full native items, not extracted loop ESL or exact network impedance; missing witnesses may still have plane connections.',rows=rows)
(D/'trace-witnesses.json').write_text(json.dumps(out,indent=2)+'\n')
for q in rows:print(q['source'],q['target'],round(q['pad_centre_straight_line_mm'],3),q['witness']['status'],q['witness'].get('layer_summary'))
