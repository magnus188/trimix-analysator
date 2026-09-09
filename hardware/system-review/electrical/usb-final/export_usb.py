"""USB-only engineering exports, not an order submission. DRC must run first."""
from pathlib import Path
import subprocess,json,hashlib
HERE=Path(__file__).resolve().parent; ROOT=HERE.parents[3]; P=ROOT/'hardware/pcb/usb-input';B=P/'Trimix_USB_Input.kicad_pcb';S=B.with_suffix('.kicad_sch');C='/Applications/KiCad/KiCad.app/Contents/MacOS/kicad-cli'
OUT=HERE/'manufacturing-diagnostic';OUT.mkdir(exist_ok=True);(OUT/'NOT_FOR_FABRICATION.txt').write_text('Engineering diagnostic exports only. Native DRC retains GCT copper-edge and PTH-annular conflicts. Obtain approved manufacturing/land/cutout and assembly process plus physical qualification before ordering. No quotation or order has been submitted.\n')
commands=[['sch','erc','--format','json','-o',str(HERE/'usb-erc.json'),str(S)],['sch','export','netlist','--format','kicadxml','-o',str(HERE/'usb-netlist.xml'),str(S)],['sch','export','pdf','-o',str(HERE/'usb-schematic.pdf'),str(S)],['sch','export','svg','-o',str(HERE/'schematic'),str(S)],['pcb','export','gerbers','--layers','F.Cu,B.Cu,F.Mask,B.Mask,F.Paste,B.Paste,F.Silkscreen,B.Silkscreen,Edge.Cuts','--use-drill-file-origin','-o',str(OUT),str(B)],['pcb','export','drill','--drill-origin','plot','--format','excellon','--excellon-oval-format','route','--excellon-separate-th','--generate-map','--generate-report','--report-path',str(OUT/'drill-report.txt'),'-o',str(OUT),str(B)],['pcb','export','pos','--format','csv','--units','mm','--use-drill-file-origin','--side','front','-o',str(OUT/'placement-all.csv'),str(B)],['pcb','export','step','--force','--drill-origin','--include-pads','--include-tracks','--include-zones','--no-extra-pad-thickness','-o',str(HERE/'Trimix_USB_Input.step'),str(B)]]
commands += [['pcb','render','--side',side,'--width','1400','--height','1400','-o',str(HERE/f'usb-{side}.png'),str(B)]for side in ['top','bottom']]
results=[]
with (HERE/'export.log').open('w') as log:
 for args in commands:
  log.write('COMMAND: '+json.dumps([C]+args)+'\n');log.flush();r=subprocess.run([C]+args,stdout=log,stderr=subprocess.STDOUT);results.append({'command':[C]+args,'exit_code':r.returncode});log.write('EXIT: '+str(r.returncode)+'\n');log.flush()
  if r.returncode:raise RuntimeError(args)
(HERE/'export-commands.json').write_text(json.dumps(results,indent=2)+'\n')
subprocess.run(['pdftoppm','-f','1','-singlefile','-r','130','-png',str(HERE/'usb-schematic.pdf'),str(HERE/'usb-schematic')],check=True)
print('completed',len(results),'export commands')
