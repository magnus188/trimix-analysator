from pathlib import Path
import sys,json
D=Path(__file__).resolve().parent
sys.path.insert(0,str(D.parents[2]/'current-path-review'))
from inventory import *
f=D/'Trimix_Analyzer.kicad_pcb';b=p.LoadBoard(str(f));g=NativeGraph(b,stackup(f.read_text()))
for target in ['R124.2','R125.1']:
 for i,source in enumerate(g.pad_index['U115.1']):
  w=g.witness(source,g.pad_index[target][0]);assert w['status']=='explicit_native_witness';(D/('witness-'+str(i)+'-'+target+'.json')).write_text(json.dumps(w,indent=2)+'\n');print(i,target,w['status'])
