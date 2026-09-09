from pathlib import Path
D=Path(__file__).resolve().parent;s=(D/'before.kicad_pcb').read_text()
for uid in ['aa4d8f16-f45b-430f-9d0a-d1556cb5d332','efc875d4-adb5-4084-9ecc-7deb366feef2','b3ef2552-3f64-445c-8038-ce0bfac7cf8c']:
 pos=s.index(uid);lo=s.rfind('(segment',0,pos);dep=0
 for hi in range(lo,len(s)):
  if s[hi]=='(':dep+=1
  elif s[hi]==')':
   dep-=1
   if dep==0:break
 s=s[:lo]+s[hi+1:]
(D/'scout-base.kicad_pcb').write_text(s)
