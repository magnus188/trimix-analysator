"""Native bounded CE bridge analysis; imports only the read-only scout."""
import scout as c
from collections import Counter
p=c.p; json=c.json; math=c.math
def in_box(s):
 bb=s.BBox();bb.Inflate(p.FromMM(1));a=c.xy(bb.GetOrigin());z=c.xy(bb.GetEnd())
 return a[0]<=12.5 and z[0]>=6.5 and a[1]<=90.25 and z[1]>=83.5
c.foreign={L:[r for r in rows if in_box(r[1])]for L,rows in c.foreign.items()}
c.smt=[r for r in c.smt if in_box(r[1])]
power=json.loads((c.D.parent/'power-corridor-scout.json').read_text())
assert power['source_sha256']==c.EXPECTED
power_points=power['hypothetical_points_mm'];power_shapes=[]
for a,z in zip(power_points,power_points[1:]):
 t=p.PCB_TRACK(c.b);t.SetStart(c.v(a));t.SetEnd(c.v(z));t.SetWidth(p.FromMM(.4));t.SetLayer(p.In2_Cu)
 power_shapes.append(({'reserved':'proposed_VSYS_0.40mm','start':a,'end':z},t.GetEffectiveShape(p.In2_Cu)))
c.foreign[p.In2_Cu]+=power_shapes
def main():
 lower=[];upper=[]; legal=[]; blocked=Counter()
 for ix in range(130,251):
  for iy in range(1670,1806):
   q=[round(ix*.05,4),round(iy*.05,4)]
   hits=c.via_blockers(q)
   if hits:
    blocked.update((h.get('net',h.get('reserved','')),h.get('uuid',''),h.get('layer',''))for h in hits)
    continue
   legal.append(q)
   if c.clear([8.75,88.425],q,p.In2_Cu):lower.append(q)
   if c.clear([10.825,85.825],q,p.In2_Cu):upper.append(q)
 print('legal',len(legal),'lower',lower,'upper',upper,flush=True)
 result={'source_sha256':c.EXPECTED,'power_reservation':power,'grid_mm':.05,'bounds_mm':[6.5,83.5,12.5,90.25],'legal_vias':legal,'lower_binding_vias':lower,'upper_binding_vias':upper,'most_common_blockers':[{'net':k[0],'uuid':k[1],'layer':k[2],'hits':v}for k,v in blocked.most_common(25)]}
 (c.D/'bounded-sites.json').write_text(json.dumps(result,indent=2)+'\n')
 for L in [p.F_Cu,p.B_Cu]:
  straight=[]
  for a in lower:
   for z in upper:
    if c.clear(a,z,L):straight.append((math.dist(a,z),a,z))
  straight.sort();print('straight',c.b.GetLayerName(L),straight[:5],flush=True)
  if straight:result[c.b.GetLayerName(L)+'_straight_bridges']=straight[:5]
 (c.D/'bounded-sites.json').write_text(json.dumps(result,indent=2)+'\n')
 assert c.hashlib.sha256(c.SOURCE.read_bytes()).hexdigest()==c.EXPECTED
if __name__=='__main__':main()
