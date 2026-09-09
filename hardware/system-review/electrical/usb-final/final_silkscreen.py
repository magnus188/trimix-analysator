from pathlib import Path
import sys
ROOT=Path(__file__).resolve().parents[4];sys.path.insert(0,str(ROOT/'hardware/tools'))
from analyzer_sheet import sx,child,children,save
p=ROOT/'hardware/pcb/usb-input/Trimix_USB_Input.kicad_pcb';a=sx.loads(p.read_text())
for t in children(a,'gr_text'):
 if child(t,'layer')[1]!='F.SilkS':continue
 if t[1] in ('1+','2-'):t[1]=t[1][0]
 font=child(child(t,'effects'),'font');child(font,'size')[1:]=[1,1];child(font,'thickness')[1]=.15
save(p,a)
