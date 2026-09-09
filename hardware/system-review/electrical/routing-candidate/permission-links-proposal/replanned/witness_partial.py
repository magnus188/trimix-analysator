from pathlib import Path
import sys,json,hashlib
import pcbnew as p
sys.path.insert(0,str(Path('hardware/system-review/electrical/current-path-review').resolve()))
from inventory import NativeGraph,stackup
D=Path(__file__).resolve().parent;path=D/'handoff-partial-frozen.kicad_pcb';b=p.LoadBoard(str(path));g=NativeGraph(b,stackup(path.read_text()))
pairs=[('Q110.1','U112.5',True),('Q110.2','Q111.3',True),('R115.2','U113.1',True),('R115.2','U112.6',True),('U113.1','U112.6',True),('R118.2','J102.2',True),('TP1003.1','J102.1',True),('J101.5','U111.8',True),('R116.1','U114.4',False),('R116.2','Q110.3',False),('R118.1','U112.5',False)]
rows=[]
for a,z,expected in pairs:
 w=g.witness(g.pad_index[a][0],g.pad_index[z][0]);actual=w['status']=='explicit_native_witness';assert actual==expected,(a,z,w);rows.append(dict(source=a,target=z,expected_connected=expected,expected_status_verified=True,witness=w));print(a,z,w['status'])
(D/'handoff-partial-witnesses.json').write_text(json.dumps(dict(source_sha256=hashlib.sha256(path.read_bytes()).hexdigest(),pairs=rows,method='Native direct track/pad adjacency, excluding zones and never joining IC pins internally or disconnected same-number pads. This is a partial routing report, not board acceptance.'),indent=2)+'\n')
