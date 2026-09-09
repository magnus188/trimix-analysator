"""Expose actual latch state through spare shared open-drain charger interrupt."""
from pathlib import Path
import sys,copy
ROOT=Path(__file__).resolve().parents[3];sys.path.insert(0,str(ROOT/'hardware/tools'))
from analyzer_sheet import *
from build_usb_source_review import passive
PTH=P/'USB_Source_Control.kicad_sch';a=sx.loads(PTH.read_text())
def pr(z):return {q[1]:q for q in children(z,'property')}
u=next(z for z in children(a,'symbol')if pr(z)['Reference'][2]=='U112')
# Pin3 is left third at x261.62,y182.88 in the independent custom pin definition.
lib=next(z for z in children(child(a,'lib_symbols'),'symbol')if z[1]==child(u,'lib_id')[1]);pin=next(q for un in children(lib,'symbol')for q in children(un,'pin')if child(q,'number')[1]=='3');at=child(pin,'at')[1:3];c=child(u,'at')[1:3];pos=(c[0]+at[0],c[1]-at[1])
for n in list(children(a,'no_connect')):
 if tuple(child(n,'at')[1:3])==pos:a.remove(n)
s=Sheet('USB_Source_Control',12,'');s.a=a;s.label('USB_PERMISSION_Q_N',pos,0)
# Add visualization on OVP sheet to keep original source sheet legible; global Qbar is explicit.
s=Sheet('USB_Overvoltage',14,'');s.a=sx.loads(s.path.read_text())
s.add('Transistor_FET:DMN2056U','Q112','DMN2056U-7',312.42,259.08,{1:'USB_PERMISSION_Q_N',2:'GND',3:'CHG_INT_N'},footprint='Package_TO_SOT_SMD:SOT-23',properties={'MPN':'DMN2056U-7','Manufacturer':'Diodes Incorporated','Datasheet':'https://www.diodes.com/assets/Datasheets/DMN2056U.pdf','Maximum_body_height_mm':'1.1'})
passive(s,'R128','100k / 1%',375.92,260.35,'USB_PERMISSION_Q_N')
r=next(z for z in children(s.a,'symbol')if pr(z)['Reference'][2]=='R128');r.append(node('property','MPN','RC0603FR-07100KL',node('at',375.92,260.35,0),effects(hide=True)))
s.text('ACTUAL LATCH FEEDBACK: Q=0 forces GPIO49 LOW.\nShared BQ interrupt; poll/deglitch before requalification.',279.4,233.68,1.016)
save(s.path,s.a);save(PTH,a)
