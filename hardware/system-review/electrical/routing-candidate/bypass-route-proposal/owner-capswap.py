from pathlib import Path
import sys
sys.path.insert(0,'hardware/tools');from analyzer_sheet import sx,child
import pcbnew as p
D=Path('hardware/system-review/electrical/routing-candidate');r=sx.loads((D/'native/Trimix_Analyzer.kicad_pcb').read_text());out=[]
for n in r:
 if isinstance(n,list)and str(n[0])=='segment':
  a=child(n,'start')[1:];e=child(n,'end')[1:];net=child(n,'net')[1]
  if net=='GND'and(a==[10.3,91.975]and e==[12,91.975]):continue
  if net=='USB_5V'and child(n,'layer')[1]=='B.Cu' and (a==[17,90.775]or(a==[17,92.5662])):continue
 out.append(n)
f=D/'capswap-open.kicad_pcb';f.write_text(sx.dumps(out));b=p.LoadBoard(str(f));v=lambda x,y:p.VECTOR2I(p.FromMM(x),p.FromMM(y))
for fp in b.GetFootprints():
 if fp.GetReference()=='C115':fp.SetPosition(v(12,92.75));fp.SetOrientationDegrees(270)
 if fp.GetReference()=='C116':fp.SetPosition(v(17,90))
p.ZONE_FILLER(b).Fill(b.Zones());p.SaveBoard(str(f),b)
