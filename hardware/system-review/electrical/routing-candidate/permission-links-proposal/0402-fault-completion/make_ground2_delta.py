from pathlib import Path
import hashlib,json,re
D=Path(__file__).resolve().parent
src=D/'before.kicad_pcb';out=D/'ground2-series-frozen.kicad_pcb'
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
receipt={'source':str(src),'source_sha256':hashlib.sha256(src.read_bytes()).hexdigest(),'output':str(out),'output_sha256':hashlib.sha256(out.read_bytes()).hexdigest(),'removed':removed,'added':added,'changed':changed,'scope':'ISOLATED COORDINATED INTERMEDIATE. True0402 R116/R119/R118, Q110180 at18,89.5; local0.60/0.30GND vias20.3,87.85 and20.75,88.3 with0.20B returns, QIn2jog. SERIES, gate/R118Q and LIMIT connected. R116 branch remains open; R116B pose conflicts with proposed laterCE and must move beforemerge. CC reroute still needsadaptation toQ110 drain; do notadoptunchanged. 8 intentionalunsynchronizedsymbolfield/packageparityissues. Noorderrelease.'}
(D/'ground2-series-delta.json').write_text(json.dumps(receipt,indent=2)+'\n')
print({k:receipt[k]for k in ['source_sha256','output_sha256']});print('removed',len(removed),'added',len(added),'changed',[(q['uuid'],q['after']['kind'])for q in changed])
