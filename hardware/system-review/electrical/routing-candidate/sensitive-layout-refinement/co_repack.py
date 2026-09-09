from pathlib import Path
import sys,json,types,shutil
import pcbnew as p
D=Path(__file__).resolve().parent;OUT=D/'co-repack';OUT.mkdir(exist_ok=True)
for q in(D/'baseline').iterdir():
 if q.is_dir():shutil.copytree(q,OUT/q.name,dirs_exist_ok=True)
 elif q.suffix!='.kicad_pcb':shutil.copy2(q,OUT/q.name)
sys.path[:0]=[str(D.parents[3]/'tools'),str(D.parents[1])]
from analyzer_sheet import sx,child,tag
from apply_review_fixes import top_blocks
# Start from the real0402 trial file with old FB removed; preserve all other source objects.
raw=(D/'R702-0402-scout.kicad_pcb').read_text();ed=[];removed=[]
extra=['0ce0ed48-2780-4331-8401-55108e4b043d','5645f15b-4d13-4c43-ab79-9ed37a1168f3','b0232ead-d20e-4760-89d9-9185325e40e2','17e5569d-4d7d-4ca4-b7dd-008e329430b3','7cd9140c-b676-4b91-ac68-50b2a9c025ba','a36c8aad-3c0b-4a78-84e0-b2671c78c93f']
for a,z,block in top_blocks(raw):
 if not block.startswith(('(segment','(via')):continue
 q=sx.loads(block);uid=child(q,'uuid')[1]
 if uid in extra:ed.append((a,z));removed.append(uid)
for a,z in reversed(ed):raw=raw[:a]+raw[z:]
board=OUT/'Trimix_Analyzer.kicad_pcb';board.write_text(raw);b=p.LoadBoard(str(board))
def vec(q):return p.VECTOR2I(p.FromMM(q[0]),p.FromMM(q[1]))
def xy(q):return p.ToMM(q.x),p.ToMM(q.y)
def track(net,points,layer,width=.15):
 for a,z in zip(points,points[1:]):
  if a==z:continue
  t=p.PCB_TRACK(b);t.SetStart(vec(a));t.SetEnd(vec(z));t.SetLayer(layer);t.SetWidth(p.FromMM(width));t.SetNet(b.FindNet(net));b.Add(t)
def via(net,q):
 v=p.PCB_VIA(b);v.SetPosition(vec(q));v.SetWidth(p.FromMM(.5));v.SetDrill(p.FromMM(.25));v.SetViaType(p.VIATYPE_THROUGH);v.SetLayerPair(p.F_Cu,p.B_Cu);v.SetNet(b.FindNet(net));b.Add(v)
fps={f.GetReference():f for f in b.GetFootprints()}
# Move actual inductor; keep current orientation/MPN/body.
f=fps['L701'];old={pad.GetNumber():xy(pad.GetPosition())for pad in f.Pads()};f.SetPosition(vec((19.5,50.65)));new={pad.GetNumber():xy(pad.GetPosition())for pad in f.Pads()}
for t in b.GetTracks():
 if isinstance(t,p.PCB_VIA):continue
 for pin,pt in old.items():
  if xy(t.GetStart())==pt:t.SetStart(vec(new[pin]))
  if xy(t.GetEnd())==pt:t.SetEnd(vec(new[pin]))
f=fps['C702'];f.SetPosition(vec((21.15,54.2)));f.SetOrientationDegrees(0)
f=fps['R702'];f.SetPosition(vec((19.1,54.15)));f.SetOrientationDegrees(0)
# HE via/body conflict: candidate shift within the local signal; incident endpoints only.
for t in b.GetTracks():
 if t.m_Uuid.AsString()=='1dec4277-ebf3-405f-ad46-ec7af44f839c':t.SetPosition(vec((18.05,53.1)))
 elif t.GetNetname()=='HE_ENABLE':
  if xy(t.GetStart())==(18.6399,53.8876):t.SetStart(vec((18.05,53.1)))
  if xy(t.GetEnd())==(18.6399,53.8876):t.SetEnd(vec((18.05,53.1)))
track('CO_SW',[(20.2125,56.3),(21.15,56.3),(21.15,53.15),new['2']],p.F_Cu,.2)
track('CO_5V28',[(20.2,54.2),(20.2125,54.9296)],p.F_Cu,.25)
track('GND',[(22.1,54.2),(23.35,54.25)],p.F_Cu,.35)
p.SaveBoard(str(board),b)
(OUT/'trial-mutations.json').write_text(json.dumps({'removed_source_uuids':removed,'status':'isolated geometry trial; no adoption'},indent=2)+'\n')
