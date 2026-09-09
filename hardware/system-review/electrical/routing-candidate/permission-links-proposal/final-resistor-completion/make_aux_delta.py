from pathlib import Path
import hashlib,json,re
D=Path(__file__).resolve().parent
src=D/'synchronized-sys-source.kicad_pcb';out=D/'r118-r119-frozen.kicad_pcb'
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
receipt={'source':str(src),'source_sha256':hashlib.sha256(src.read_bytes()).hexdigest(),'output':str(out),'output_sha256':hashlib.sha256(out.read_bytes()).hexdigest(),'removed':removed,'added':added,'changed':changed,'scope':'ISOLATED R118/R119 PARTIAL: R118 true0402 F10.75,91.95/180; R119 true0402 B5.15,88.15/0 and19.1k .1%. R116 original0603 footprint/pose retained and both connections remain open. No authority source edits. Matching local SCH field synchronization separate. No fabrication or physical qualification.'}
(D/'r118-r119-delta.json').write_text(json.dumps(receipt,indent=2)+'\n')
print({k:receipt[k]for k in ['source_sha256','output_sha256']});print('removed',len(removed),'added',len(added),'changed',[(q['uuid'],q['after']['kind'])for q in changed])
