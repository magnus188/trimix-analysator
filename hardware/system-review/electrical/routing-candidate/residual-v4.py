from pathlib import Path
import sys,math
sys.path.insert(0,'hardware/tools');from analyzer_sheet import sx,children,child
import pcbnew as p
D=Path('hardware/system-review/electrical/routing-candidate');dst=D/'native/Trimix_Analyzer.kicad_pcb';a=sx.loads(dst.read_text());remove={'b8fd087f-27f3-436f-a04a-7c68afbe6d5e','e8172ace-e8ad-47db-a6b2-fb8763d17c4d','d62cbe0c-b793-458f-9c7a-ac233d55252d'}
for k in ['segment','via']:
 for z in list(children(a,k)):
  if child(z,'uuid')[1]in remove:a.remove(z);continue
  n=child(z,'net')[1]
  for q in ['at','start','end']:
   it=child(z,q)
   if not it:continue
   if n=='USB_OVP_5V'and math.dist(it[1:3],(14.75,91.2))<.001:it[2]=91.55
   if n=='USB_OVP_5V'and math.dist(it[1:3],(13.6,91.3))<.001:it[2]=91.55
   if n=='USB_OVP_DVDT'and math.dist(it[1:3],(15.4,88.5))<.001:it[1:3]=[15.89,88.8]
dst.write_text(sx.dumps(a));b=p.LoadBoard(str(dst));b.GetDesignSettings().m_TrackMinWidth=p.FromMM(.15);p.ZONE_FILLER(b).Fill(b.Zones());p.SaveBoard(str(dst),b)
