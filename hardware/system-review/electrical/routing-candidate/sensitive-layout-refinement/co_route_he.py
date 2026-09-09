from pathlib import Path
import sys,types,shutil,json
import pcbnew as p
D=Path(__file__).resolve().parent;OUT=D/'co-he-routed';shutil.copytree(D/'co-repack4',OUT,dirs_exist_ok=True)
sys.path[:0]=[str(D.parents[3]/'tools'),str(D.parents[1])]
from analyzer_sheet import sx,child
from apply_review_fixes import top_blocks
board=OUT/'Trimix_Analyzer.kicad_pcb';raw=board.read_text();ed=[];removed=[]
for a,z,block in top_blocks(raw):
 if not block.startswith(('(segment','(via')):continue
 q=sx.loads(block);uid=child(q,'uuid')[1]
 if uid in ['1dec4277-ebf3-405f-ad46-ec7af44f839c','67d1932e-03fd-4273-bd0c-ac536d72ba55','028a16ca-cdad-4fee-a2b8-9fe5968e482d']:ed.append((a,z));removed.append(uid)
for a,z in reversed(ed):raw=raw[:a]+raw[z:]
board.write_text(raw);b=p.LoadBoard(str(board))
def vec(q):return p.VECTOR2I(p.FromMM(q[0]),p.FromMM(q[1]))
def xy(q):return p.ToMM(q.x),p.ToMM(q.y)
def track(net,points,layer,width=.15):
 for a,z in zip(points,points[1:]):
  if a==z:continue
  t=p.PCB_TRACK(b);t.SetStart(vec(a));t.SetEnd(vec(z));t.SetLayer(layer);t.SetWidth(p.FromMM(width));t.SetNet(b.FindNet(net));b.Add(t)
def via(net,q):
 v=p.PCB_VIA(b);v.SetPosition(vec(q));v.SetWidth(p.FromMM(.5));v.SetDrill(p.FromMM(.25));v.SetViaType(p.VIATYPE_THROUGH);v.SetLayerPair(p.F_Cu,p.B_Cu);v.SetNet(b.FindNet(net));b.Add(v)
c=types.SimpleNamespace(p=p,b=b,OUT=OUT,vec=vec,xy=xy,track=track,via=via)
code=(D.parent/'upper-bus-route-proposal/route_bounded.py').read_text().replace('import build_upper_bus as c','');g={'c':c};exec(compile(code,'bounded_native_route','exec'),g)
g['route']('HE_ENABLE',(17.1401,52.3878),(22.3325,50.195),start_layers=(1,),end_layers=(2,),allow_vias=True,bounds=(14.5,48.9,24,55.2))
p.ZONE_FILLER(b).Fill(b.Zones());p.SaveBoard(str(board),b)
