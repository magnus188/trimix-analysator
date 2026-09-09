from pathlib import Path
import sys,json,math
import pcbnew as p
D=Path(__file__).resolve().parent
sys.path[:0]=[str(D.parents[3]/'tools'),str(D.parents[1])]
from analyzer_sheet import sx,child
from apply_review_fixes import top_blocks
raw=(D/'c103-local/Trimix_Analyzer.kicad_pcb').read_text();orig=(D/'baseline/Trimix_Analyzer.kicad_pcb').read_text();ids=set()
for a,z,block in top_blocks(orig):
 if block.startswith(('(segment','(via')):ids.add(child(sx.loads(block),'uuid')[1])
ed=[]
for a,z,block in top_blocks(raw):
 if not block.startswith(('(segment','(via')):continue
 q=sx.loads(block)
 if child(q,'net')[1].endswith('BQ_SW')and child(q,'uuid')[1]not in ids:ed.append((a,z))
for a,z in reversed(ed):raw=raw[:a]+raw[z:]
f=D/'c103-via-base.kicad_pcb';f.write_text(raw);b=p.LoadBoard(str(f));NET='/01  CHARGING + BATTERY/BQ_SW';LAYERS=[p.F_Cu,p.In1_Cu,p.In2_Cu,p.B_Cu]
def xy(q):return[p.ToMM(q.x),p.ToMM(q.y)]
def v(q):return p.VECTOR2I(p.FromMM(q[0]),p.FromMM(q[1]))
objs=[(t,t.GetEffectiveShape(l),l)for t in list(b.GetTracks())+[q for f in b.GetFootprints()for q in f.Pads()]for l in LAYERS if t.IsOnLayer(l)]
rules=[z.Outline()for z in list(b.Zones())+[z for f in b.GetFootprints()for z in f.Zones()]if z.GetIsRuleArea()and z.GetDoNotAllowVias()]
rows=[]
for xi in range(285,336):
 for yi in range(1590,1646):
  x,y=xi*.05,yi*.05;q=v((x,y))
  if any(s.Collide(q,p.FromMM(.4501))for t,s,l in objs if t.GetNetname()!=NET):continue
  if any(s.Collide(q,p.FromMM(.3001))for t,s,l in objs if isinstance(t,p.PAD)and t.GetAttribute()==p.PAD_ATTRIB_SMD):continue
  if any(s.Collide(q,p.FromMM(.2501))for s in rules):continue
  rows.append(dict(x=x,y=y,score=math.dist((x,y),(15.08,80.7))+abs(x-14.25)))
rows.sort(key=lambda x:x['score']);print(rows[:35]);(D/'c103-via-scout.json').write_text(json.dumps(rows,indent=2)+'\n')
