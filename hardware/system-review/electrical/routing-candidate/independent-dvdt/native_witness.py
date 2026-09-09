from pathlib import Path
import sys,json,hashlib
D=Path(__file__).resolve().parent;sys.path.insert(0,str(D.parents[1]/'current-path-review'))
from inventory import p,NativeGraph,stackup
file=D/'Trimix_Analyzer.kicad_pcb';text=file.read_text();b=p.LoadBoard(str(file));g=NativeGraph(b,stackup(text));checks=[]
for a,z in [('U115.7','C116.1'),('U115.8','C116.2'),('C116.2','R126.2'),('U115.9','R126.1')]:
 for u in g.pad_index[a]:
  for v in g.pad_index[z]:
   checks.append(dict(source=a,target=z,source_uuid=u,target_uuid=v,witness=g.witness(u,v)))
via='81a50918-f412-49be-81fe-86e8e1ae9c47'
for a in ['U115.8','C116.2','R126.2']:
 for u in g.pad_index[a]:checks.append(dict(source=a,target='Existing GND via 18.6,88.45',source_uuid=u,target_uuid=via,witness=g.witness(u,via)))
out=dict(board_sha256=hashlib.sha256(file.read_bytes()).hexdigest(),method='KiCad direct GetConnectedTracks/GetConnectedPads only, no zones or presumed package joins',checks=checks)
assert all(q['witness']['status']=='explicit_native_witness'for q in checks)
(D/'native-witnesses.json').write_text(json.dumps(out,indent=2)+'\n');print(len(checks),'direct native witnesses passed')
