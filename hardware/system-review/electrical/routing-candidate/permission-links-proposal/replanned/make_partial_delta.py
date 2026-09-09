from pathlib import Path
import hashlib,json,re
D=Path(__file__).resolve().parent
src=D/'before.kicad_pcb';out=D/'handoff-partial-frozen.kicad_pcb';out.write_bytes((D/'Trimix_Analyzer.kicad_pcb').read_bytes())
def blocks(txt):
 res={};i=0
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
s=blocks(src.read_text());t=blocks(out.read_text())
removed=[dict(uuid=k,**v)for k,v in s.items()if k not in t];added=[dict(uuid=k,**v)for k,v in t.items()if k not in s];changed=[dict(uuid=k,before=s[k],after=v)for k,v in t.items()if k in s and s[k]['native']!=v['native']]
# Only three authorized physical footprints should change; unchanged copper bytes may serialize reorder but geometry must remain identical.
receipt={'source':str(src),'source_sha256':hashlib.sha256(src.read_bytes()).hexdigest(),'output':str(out),'output_sha256':hashlib.sha256(out.read_bytes()).hexdigest(),'removed':removed,'added':added,'changed':changed,'scope':'Partial only. SERIES, Q110 gate, CLR, R118 GND connected; R116 two legs and R118 Q remain open. Q110 F17.5,89.3 rot90; R116 F7.75,94.75 rot0; R118 B17.4,94.7 rot90. Includes parent accepted3 orphan cleanup UUIDs. Ten moved silk warnings remain. No final manufacture acceptance.'}
(D/'handoff-partial-delta.json').write_text(json.dumps(receipt,indent=2)+'\n')
print({k:receipt[k]for k in ['source_sha256','output_sha256']});print('removed',len(removed),'added',len(added),'changed',[(q['uuid'],q['after']['kind'])for q in changed])
