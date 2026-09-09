from pathlib import Path
import sys,shutil,json
import pcbnew as p
D=Path(__file__).resolve().parent;OUT=D/'c103-local2';shutil.copytree(D/'baseline',OUT,dirs_exist_ok=True)
sys.path[:0]=[str(D.parents[3]/'tools'),str(D.parents[1])]
from analyzer_sheet import sx,child,tag
from apply_review_fixes import top_blocks
raw=(D/'C103-0402-B-scout.kicad_pcb').read_text();ed=[];removed=[]
extra=['0b3c2601-a7c1-4eea-9fdb-e12bb7956327','208eeaf7-99fd-47c9-89db-2b73643cb8f2','35794702-d7d7-477a-bfde-e78b5e5a5b32','d1448c0a-6d76-4946-9848-adfcc1e79daf','d244fad1-1ae0-4adb-9ff9-26bcf94e82c3','a94b99d3-da90-43bf-b594-b613b3d19051','a7adcf5d-7c83-4d1c-b103-051b3612f1e9','2056601b-984f-4627-b5f0-6a3f5a4b7342','3276c059-5355-4b4a-8d55-71d596063a52','984ab25b-6a6a-4f77-826d-87bb74200256']
for a,z,block in top_blocks(raw):
 if not block.startswith(('(segment','(via')):continue
 q=sx.loads(block);uid=child(q,'uuid')[1]
 if uid in extra:ed.append((a,z));removed.append(uid)
for a,z in reversed(ed):raw=raw[:a]+raw[z:]
board=OUT/'Trimix_Analyzer.kicad_pcb';board.write_text(raw);b=p.LoadBoard(str(board))
def vec(q):return p.VECTOR2I(p.FromMM(q[0]),p.FromMM(q[1]))
def track(net,points,layer,width=.2):
 for a,z in zip(points,points[1:]):
  if a==z:continue
  t=p.PCB_TRACK(b);t.SetStart(vec(a));t.SetEnd(vec(z));t.SetLayer(layer);t.SetWidth(p.FromMM(width));t.SetNet(b.FindNet(net));b.Add(t)
def via(net,q):
 v=p.PCB_VIA(b);v.SetPosition(vec(q));v.SetWidth(p.FromMM(.5));v.SetDrill(p.FromMM(.25));v.SetViaType(p.VIATYPE_THROUGH);v.SetLayerPair(p.F_Cu,p.B_Cu);v.SetNet(b.FindNet(net));b.Add(v)
f=next(f for f in b.GetFootprints()if f.GetReference()=='C103');f.Flip(f.GetPosition(),False);f.SetPosition(vec((14.6,80.7)));f.SetOrientationDegrees(180)
nets={pad.GetNumber():pad.GetNetname()for pad in f.Pads()}
print('C103 pads',[(pad.GetNumber(),p.ToMM(pad.GetPosition().x),p.ToMM(pad.GetPosition().y))for pad in f.Pads()])
track(nets['2'],[(13.5,81.2),(14.12,80.7)],p.B_Cu,.2)
via(nets['1'],(15.75,81.35));track(nets['1'],[(15.08,80.7),(15.75,81.35)],p.B_Cu,.2)
track(nets['1'],[(14.25,80.1),(15.75,80.1),(15.75,81.35)],p.F_Cu,.2)
p.ZONE_FILLER(b).Fill(b.Zones());p.SaveBoard(str(board),b)
(OUT/'mutation.json').write_text(json.dumps({'removed':removed,'status':'isolated only; nominal net/value retained; metadata pending exactpartcurve'},indent=2)+'\n')
