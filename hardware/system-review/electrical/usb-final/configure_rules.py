"""Apply USB-only manufacturing constraints after SWIG process has exited.
SWIG carries an in-memory project and saves it with the PCB; external JSON edits
must follow that save. No copper-edge waiver is present.
"""
from pathlib import Path
import json
P=Path(__file__).resolve().parents[3]/'pcb/usb-input'
p=P/'Trimix_USB_Input.kicad_pro';a=json.loads(p.read_text());ds=a['board']['design_settings'];ds['drc_exclusions']=[]
ds['rules'].update({'min_clearance':.15,'min_copper_edge_clearance':.2,'min_track_width':.15,'min_hole_clearance':.2,'min_hole_to_hole':.25,'min_via_diameter':.45,'min_through_hole_diameter':.2,'min_via_annular_width':.1,'min_silk_clearance':.15})
a['net_settings']['classes'][0].update({'clearance':.15,'track_width':.15,'via_diameter':.45,'via_drill':.2})
p.write_text(json.dumps(a,indent=2)+'\n')
(P/'Trimix_USB_Input.kicad_dru').write_text('''(version 1)
(rule "Two-layer PTH solder-land annular minimum"
 (condition "A.Type == 'Pad' && A.Pad_Type == 'Through-hole'")
 (constraint annular_width (min 0.18mm)))
''')
