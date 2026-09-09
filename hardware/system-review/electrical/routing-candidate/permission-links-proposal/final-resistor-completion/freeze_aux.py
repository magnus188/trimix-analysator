from pathlib import Path
import re,json,hashlib
D=Path(__file__).resolve().parent
src=D/'synchronized-sys-source.kicad_pcb';out=D/'aux-stage.kicad_pcb'
def blocks(txt):
 res={}
 for m in re.finditer(r'\n\t\((footprint|segment|via)\b',txt):
  lo=m.start()+2;dep=0;quote=False;esc=False
  for hi in range(lo,len(txt)):
   ch=txt[hi]
   if quote:
    if esc:esc=False
    elif ch=='\\':esc=True
    elif ch=='"':quote=False
   elif ch=='"':quote=True
   elif ch=='(':dep+=1
   elif ch==')':
    dep-=1
    if dep==0:break
  s=txt[lo:hi+1];uid=re.search(r'\(uuid "([^"]+)"\)',s).group(1);res[uid]={'kind':m.group(1),'native':s}
 return res
s=blocks(src.read_text());t=blocks(out.read_text());text=out.read_text()
r116=next(k for k,v in s.items()if v['kind']=='footprint'and '(property "Reference" "R116"'in v['native'])
assert t[r116]['native']in text;text=text.replace(t[r116]['native'],s[r116]['native'],1)
(D/'aux-handoff-raw.kicad_pcb').write_text(text)
