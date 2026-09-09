from pathlib import Path
import sys,json,math,shutil
import pcbnew as p
D=Path(__file__).resolve().parent;OUT=D/'co-output-corrected';shutil.copytree(D/'co-fb-complete',OUT,dirs_exist_ok=True)
sys.path[:0]=[str(D.parents[3]/'tools'),str(D.parents[1])]
from analyzer_sheet import sx,child
from apply_review_fixes import top_blocks
board=OUT/'Trimix_Analyzer.kicad_pcb';raw=board.read_text();ed=[];removed=[]
for a,z,block in top_blocks(raw):
 if not block.startswith(('(segment','(via')):continue
 q=sx.loads(block);uid=child(q,'uuid')[1];n=child(q,'net')[1]
 hit=uid in ['4e351ce6-766a-4bea-83de-5a0d180ba7c1','a67f5c9e-f7e8-49df-b279-d93414105432','9d08a0ce-8536-4ead-930b-9f47d648ba7b']
 if n=='CO_5V28'and child(q,'end')and child(q,'end')[1:]==[20.2125,54.9296]:hit=True
 if hit:ed.append((a,z));removed.append(uid)
for a,z in reversed(ed):raw=raw[:a]+raw[z:]
board.write_text(raw);b=p.LoadBoard(str(board))
def v(q):return p.VECTOR2I(p.FromMM(q[0]),p.FromMM(q[1]))
def track(net,pts,layer,width=.25):
 for a,z in zip(pts,pts[1:]):
  if a==z:continue
  t=p.PCB_TRACK(b);t.SetStart(v(a));t.SetEnd(v(z));t.SetLayer(layer);t.SetWidth(p.FromMM(width));t.SetNet(b.FindNet(net));b.Add(t)
def via(net,at):
 q=p.PCB_VIA(b);q.SetPosition(v(at));q.SetWidth(p.FromMM(.6));q.SetDrill(p.FromMM(.3));q.SetLayerPair(p.F_Cu,p.B_Cu);q.SetViaType(p.VIATYPE_THROUGH);q.SetNet(b.FindNet(net));b.Add(q)
NET='CO_5V28';start=(20.3,54.2);end=(22.8203,52.3218);LAYERS=[p.F_Cu,p.In1_Cu,p.In2_Cu,p.B_Cu]
objs=[(t,t.GetEffectiveShape(l),l)for t in list(b.GetTracks())+[q for f in b.GetFootprints()for q in f.Pads()]for l in LAYERS if t.IsOnLayer(l)]
rules=[z.Outline()for z in list(b.Zones())+[z for f in b.GetFootprints()for z in f.Zones()]if z.GetIsRuleArea()and z.GetDoNotAllowVias()];rows=[]
for xi in range(380,445):
 for yi in range(1040,1111):
  at=(xi*.05,yi*.05);q=v(at);seg=p.SEG(v(start),q);segB=p.SEG(q,v(end))
  if any(s.Collide(q,p.FromMM(.5001))for t,s,l in objs if t.GetNetname()!=NET):continue
  if any(s.Collide(q,p.FromMM(.3501))for t,s,l in objs if isinstance(t,p.PAD)and t.GetAttribute()==p.PAD_ATTRIB_SMD):continue
  if any(s.Collide(q,p.FromMM(.3001))for s in rules):continue
  if any(s.Collide(seg,p.FromMM(.3251))for t,s,l in objs if l==p.F_Cu and t.GetNetname()!=NET):continue
  if any(s.Collide(segB,p.FromMM(.2751))for t,s,l in objs if l==p.B_Cu and t.GetNetname()!=NET):continue
  rows.append((math.dist(at,start)+.2*math.dist(at,end),at))
rows.sort();print(rows[:8]);assert rows
at=rows[0][1];via(NET,at);track(NET,[start,at],p.F_Cu,.25);track(NET,[at,end],p.B_Cu,.15)
track(NET,[(20.2125,55.8),(20.2125,55.4)],p.F_Cu,.2);track(NET,[(20.2125,55.4),start],p.F_Cu,.4)
p.ZONE_FILLER(b).Fill(b.Zones());p.SaveBoard(str(board),b);(OUT/'output-via-correction.json').write_text(json.dumps({'removed':removed,'new_via':at,'candidates':rows[:8],'status':'isolated; rootR504 stillpending'},indent=2)+'\n')
