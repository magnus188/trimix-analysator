from pathlib import Path
import sys,json
D=Path(__file__).resolve().parent
sys.path.insert(0,str(D.parents[2]/'current-path-review'))
from inventory import *
f=D/'Trimix_Analyzer.kicad_pcb';b=p.LoadBoard(str(f));g=NativeGraph(b,stackup(f.read_text()))
for target in ['C112.1','C110.1','R120.1']:
 w=g.witness(g.pad_index['R115.1'][0],g.pad_index[target][0]);(D/('witness-'+target+'.json')).write_text(json.dumps(w,indent=2)+'\n')
 print(target,w['status'])
