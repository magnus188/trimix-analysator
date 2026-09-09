from scout_escape import b,p,NET,ALL,shapes,pad_owner,vec
import json
for xy in [(13.65,91),(13.7,91),(13.6,91),(13.65,91.025),(13.7,91.05),(13.65,91.1)]:
 bad=[]
 for t,L,s in shapes:
  if s.Collide(vec(xy),p.FromMM(.4501)):
   row={'uuid':t.m_Uuid.AsString(),'net':t.GetNetname(),'layer':b.GetLayerName(L)}
   if isinstance(t,p.PAD):row.update(ref=pad_owner[t.m_Uuid.AsString()],pin=t.GetNumber())
   bad.append(row)
 print(xy,bad)
