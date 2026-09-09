import build_bridge as c
import route_bounded as r
from pathlib import Path
import json,shutil
try:
 r.route('GND',(15.225,79),(19.825,75.25),end_layers=(2,),start_layers=(2,),width=.25,allow_vias=False,bounds=(11,73.5,20.5,80.1),targets=[(2,(19.825,75.25)),(2,(19.0625,78.7)),(2,(19.925,72.25)),(2,(22,77.125))])
 status='ground_route_found'
except AssertionError as e:status=str(e)
c.p.SaveBoard(str(c.OUT/'Trimix_Analyzer.kicad_pcb'),c.b)
shutil.copy2('hardware/pcb/analyzer/Trimix_Analyzer.kicad_pro',c.OUT/'Trimix_Analyzer.kicad_pro');shutil.copy2('hardware/pcb/analyzer/Trimix_Analyzer.kicad_dru',c.OUT/'Trimix_Analyzer.kicad_dru')
(c.OUT/'status.json').write_text(json.dumps({'status':status,'ground_width_mm':.25,'no_new_vias':True,'not_adopted':True},indent=2)+'\n');print(status)
