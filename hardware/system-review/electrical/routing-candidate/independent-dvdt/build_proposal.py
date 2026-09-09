from pathlib import Path
import json,shutil,re
import pcbnew as p
D=Path(__file__).resolve().parent
r=json.loads((D/'ordered-results.json').read_text())[0]
text=(D/'before.kicad_pcb').read_text()
def remove_form(text,uid,kind="segment"):
 # Source includes both formatted and one-line segment forms. Parse exact
 # balanced parentheses instead of assuming indentation or line breaks.
 for match in re.finditer(r'\('+kind+r'(?=\s)',text):
  start=match.start();depth=0;quoted=False;escaped=False
  for i in range(start,len(text)):
   ch=text[i]
   if quoted:
    if escaped:escaped=False
    elif ch=='\\':escaped=True
    elif ch=='"':quoted=False
   elif ch=='"':quoted=True
   elif ch=='(':depth+=1
   elif ch==')':
    depth-=1
    if depth==0:
     form=text[start:i+1]
     if uid in form:return text[:start]+text[i+1:]
     break
 raise ValueError('Missing segment '+uid)
for uid in r['removed']+['51e38235-6fa6-42a4-a681-1ca4736c7fc9']:text=remove_form(text,uid)
text=remove_form(text,'50ab0909-e3af-442a-9258-f6ab20dd176b','via')
(D/'stripped.kicad_pcb').write_text(text)
for ext,snap in [('kicad_pro','source-project.kicad_pro'),('kicad_dru','source-rules.kicad_dru')]:shutil.copyfile(D/snap,D/('stripped.'+ext))
b=p.LoadBoard(str(D/'stripped.kicad_pcb'))
def v(xy):return p.VECTOR2I(p.FromMM(xy[0]),p.FromMM(xy[1]))
c=next(f for f in b.GetFootprints()if f.GetReference()=='C116')
c.SetOrientationDegrees(r['rotation']);c.SetPosition(v(r['centre']))
nets={net:b.FindNet(net).GetNetCode()for net,pts,w in r['tracks']}
for net,pts,w in r['tracks']:
 for a,z in zip(pts,pts[1:]):
  q=p.PCB_TRACK(b);q.SetStart(v(a));q.SetEnd(v(z));q.SetWidth(p.FromMM(w));q.SetLayer(p.B_Cu);q.SetNetCode(nets[net]);b.Add(q)
p.ZONE_FILLER(b).Fill(b.Zones());p.SaveBoard(str(D/'Trimix_Analyzer.kicad_pcb'),b)
for ext,snap in [('kicad_pro','source-project.kicad_pro'),('kicad_dru','source-rules.kicad_dru')]:shutil.copyfile(D/snap,D/('Trimix_Analyzer.'+ext))
print('Built isolated C116 proposal',r['centre'],r['rotation'])
