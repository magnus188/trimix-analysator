from pathlib import Path
import sys,json,math,shutil
import pcbnew as p
D=Path(__file__).resolve().parent;OUT=D/'co-load-separated';shutil.copytree(D/'co-fb-complete',OUT,dirs_exist_ok=True)
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
NET='CO_5V28'
track(NET,[(20.2125,55.8),(20.2125,55.4)],p.F_Cu,.2);track(NET,[(20.2125,55.4),(20.3,54.2)],p.F_Cu,.4)
import types
def xy(q):return p.ToMM(q.x),p.ToMM(q.y)
c=types.SimpleNamespace(p=p,b=b,OUT=OUT,vec=v,xy=xy,track=track,via=via)
code=(D.parent/'upper-bus-route-proposal/route_bounded.py').read_text().replace('import build_upper_bus as c','').replace('for l in range(3)if l!=n[2]','for l in (0,2)if l!=n[2]')
code=code.replace('.7501','.8001').replace('.2501','.3001').replace('.4501','.5001').replace('.3001))for l in [p.F_Cu,p.B_Cu]','.3501))for l in [p.F_Cu,p.B_Cu]')
g={'c':c};exec(compile(code,'bounded_native_route','exec'),g)
g['route'](NET,(21.7582,58.3836),(22.8203,52.3218),start_layers=(0,),end_layers=(2,),width=.20,allow_vias=True,bounds=(19.0,51,24.1,60))
p.ZONE_FILLER(b).Fill(b.Zones());p.SaveBoard(str(board),b)
