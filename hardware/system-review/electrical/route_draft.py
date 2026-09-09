"""Conservative draft router for two-terminal/local signal connections.

Uses the actual pad/keepout geometry, adds no plane split, never moves parts.
Copper must pass native DRC. Power routes are deliberately excluded until their
wide paths and hot-loop geometry are reviewed; no order-release claim.
"""
from pathlib import Path
import pcbnew as p,math,heapq,json,shutil,hashlib,sys
ROOT=Path(__file__).resolve().parents[3];OUT=Path(__file__).resolve().parent;PATH=ROOT/'hardware/pcb/analyzer/Trimix_Analyzer.kicad_pcb'
STEP=.1; CLEAR=.215; WIDTH=.20
POWER={'GND','USB_5V','USB_CHG_5V','PACK_P','VSYS','VOUT_5V','HOST_5V','HOST_3V3','HE_3V0','CO_5V28','CO_LOGIC_3V0','CO_SW','Net-(L201-Pad1)','Net-(L201-Pad2)'}
def v(q):return p.VECTOR2I(p.FromMM(q[0]),p.FromMM(q[1]))
def mm(q):return p.ToMM(q.x),p.ToMM(q.y)
def bbox(q):return tuple(p.ToMM(t)for t in(q.GetX(),q.GetY(),q.GetRight(),q.GetBottom()))
def intersects(a,b):return a[0]<=b[2] and b[0]<=a[2] and a[1]<=b[3] and b[1]<=a[3]
def main():
 b=p.LoadBoard(str(PATH));base=OUT/'before-signal-routing.kicad_pcb'
 if not base.exists():shutil.copy2(PATH,base)
 outline=p.SHAPE_POLY_SET();assert b.GetBoardPolygonOutlines(outline,False)
 pads=[q for f in b.GetFootprints()for q in f.Pads()];by={}
 for q in pads:
  if q.IsOnLayer(p.F_Cu) and not q.GetNetname().startswith('unconnected') and q.GetNetname():by.setdefault(q.GetNetname(),[]).append(q)
 # A rectangular broad phase is intentionally conservative for round/oval pads.
 keep=[]
 for z in list(b.Zones())+[z for f in b.GetFootprints()for z in f.Zones()]:
  if z.GetIsRuleArea()and z.GetDoNotAllowTracks() and z.GetLayerSet().Contains(p.F_Cu):keep.append(bbox(z.Outline().BBox()))
 tracks=list(b.GetTracks());done=[];held=[]
 jobs=[]
 for net,qs in by.items():
  if net in POWER or '/BQ_' in net or net.endswith(('/BQ_SW','/BQ_REGN','/BQ_PMID','/BQ_BTST')):continue
  if len(qs)<2:continue
  # Prim tree keeps each local connection short. Existing tracks are not used
  # to assert connectivity: the native DRC remains authoritative.
  seen=[qs[0]];todo=qs[1:]
  while todo:
   _,a,c=min(((math.dist(mm(a.GetPosition()),mm(c.GetPosition())),a,c)for a in seen for c in todo),key=lambda z:z[0])
   jobs.append((math.dist(mm(a.GetPosition()),mm(c.GetPosition())),net,a,c));seen.append(c);todo.remove(c)
 for dist,net,a,c in sorted(jobs,key=lambda x:x[0]):
  if dist<.01:continue
  if max(mm(a.GetPosition())[1],mm(c.GetPosition())[1])>70:continue
  obs=[]
  for q in pads:
   if q.IsOnLayer(p.F_Cu)and q.GetNetname()!=net:
    r=bbox(q.GetBoundingBox());d=CLEAR+WIDTH/2;obs.append((r[0]-d,r[1]-d,r[2]+d,r[3]+d))
  for t in tracks:
   if t.IsOnLayer(p.F_Cu) and t.GetNetname()!=net:
    # Segment bounding boxes are conservative, may reject an otherwise legal path.
    r=bbox(t.GetBoundingBox());d=CLEAR+WIDTH/2;obs.append((r[0]-d,r[1]-d,r[2]+d,r[3]+d))
  for r in keep:obs.append((r[0]-.11,r[1]-.11,r[2]+.11,r[3]+.11))
  s=tuple(round(t/STEP)for t in mm(a.GetPosition()));g=tuple(round(t/STEP)for t in mm(c.GetPosition()));
  # Grid broad phase with exact conservative point clearance from the outline.
  bad=set();x0,y0=0,0;x1,y1=300,990
  for r in obs:
   for x in range(max(x0,math.ceil(r[0]/STEP)),min(x1,math.floor(r[2]/STEP))+1):
    for y in range(max(y0,math.ceil(r[1]/STEP)),min(y1,math.floor(r[3]/STEP))+1):bad.add((x,y))
  def good(q):
   if q in bad:return False
   x,y=q[0]*STEP,q[1]*STEP
   if not(.62<=x<=29.38 and .62<=y<=98.38):return False
   if y<17.62 and x>8.28:return False
   if y>94.18 and x<6.42:return False
   return True
  if not good(s)or not good(g):held.append((net,'endpoint escape requires narrower/custom fanout',p.Cast_to_FOOTPRINT(a.GetParent()).GetReference(),p.Cast_to_FOOTPRINT(c.GetParent()).GetReference()));continue
  heap=[(math.dist(s,g),0,s)];cost={s:0};prev={};found=False
  while heap:
   _,d,q=heapq.heappop(heap)
   if cost.get(q)!=d:continue
   if q==g:found=True;break
   if len(cost)>150000:break
   for dx,dy in [(1,0),(-1,0),(0,1),(0,-1),(1,1),(-1,1),(1,-1),(-1,-1)]:
    n=q[0]+dx,q[1]+dy
    if not good(n)or(dx and dy and(not good((q[0]+dx,q[1]))or not good((q[0],q[1]+dy)))):continue
    nd=d+(1.414214 if dx and dy else 1)
    if q in prev and (q[0]-prev[q][0],q[1]-prev[q][1])!=(dx,dy):nd+=.025
    if nd<cost.get(n,1e20):cost[n]=nd;prev[n]=q;heapq.heappush(heap,(nd+math.dist(n,g),nd,n))
  if not found:held.append((net,'no conservative F.Cu path; multilayer/manual route remains',p.Cast_to_FOOTPRINT(a.GetParent()).GetReference(),p.Cast_to_FOOTPRINT(c.GetParent()).GetReference()));continue
  seq=[g]
  while seq[-1]!=s:seq.append(prev[seq[-1]])
  seq.reverse();corners=[mm(a.GetPosition()),tuple(t*STEP for t in s)]
  old=None
  for i in range(1,len(seq)):
   delta=seq[i][0]-seq[i-1][0],seq[i][1]-seq[i-1][1]
   if old is not None and delta!=old:corners.append(tuple(t*STEP for t in seq[i-1]))
   old=delta
  corners.append(tuple(t*STEP for t in g));corners.append(mm(c.GetPosition()))
  for start,end in zip(corners,corners[1:]):
   if math.dist(start,end)<.000001:continue
   t=p.PCB_TRACK(b);t.SetStart(v(start));t.SetEnd(v(end));t.SetWidth(p.FromMM(WIDTH));t.SetLayer(p.F_Cu);t.SetNetCode(a.GetNetCode());b.Add(t);tracks.append(t)
  done.append({'net':net,'from':p.Cast_to_FOOTPRINT(a.GetParent()).GetReference()+'.'+a.GetNumber(),'to':p.Cast_to_FOOTPRINT(c.GetParent()).GetReference()+'.'+c.GetNumber(),'length_mm':sum(math.dist(x,y)for x,y in zip(corners,corners[1:])),'width_mm':WIDTH,'segments':len(corners)-1})
 p.SaveBoard(str(PATH),b)
 receipt={'draft_only':True,'manufacturing_release':False,'routed_connections':done,'held':held,'native_DRC_required':True,'power_nets_excluded':sorted(POWER),'tracks':len(tracks),'notes':'F.Cu signal draft only. Review return paths, high-impedance pickup, thermal and branch current before release. No component movement.'}
 (OUT/'signal-routing-draft.json').write_text(json.dumps(receipt,indent=2)+'\n');print(len(done),'connections',len(held),'held',len(tracks),'segments')
if __name__=='__main__':main()
