from pathlib import Path
import sys,types,shutil,json
import pcbnew as p
D=Path(__file__).resolve().parent;OUT=D/'co-fixed2';shutil.copytree(D/'baseline',OUT)
sys.path[:0]=[str(D.parents[3]/'tools'),str(D.parents[1])]
from analyzer_sheet import sx,child
from apply_review_fixes import top_blocks
board=OUT/'Trimix_Analyzer.kicad_pcb';raw=board.read_text();ed=[];removed=[]
for a,z,block in top_blocks(raw):
 if block.startswith(('(segment','(via')):
  node=sx.loads(block)
  if child(node,'net')[1]=='CO_FB':ed.append((a,z));removed.append(child(node,'uuid')[1])
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
code=(D.parent/'upper-bus-route-proposal/route_bounded.py').read_text().replace('import build_upper_bus as c','')
g={'c':c};exec(compile(code,'bounded_native_route','exec'),g)
checks=[]
for name,start,end in [('topdivider_to_FB',(17.05,55.375),(18.7875,55.8)),('bottomdivider_to_FB',(17.675,58.65),(17.05,55.375))]:
 try:g['route']('CO_FB',start,end,start_layers=(0,),end_layers=(0,),allow_vias=False,bounds=(14.5,53.35,23,61.5));checks.append({'name':name,'routed':True})
 except AssertionError as e:checks.append({'name':name,'routed':False,'error':str(e)})
p.SaveBoard(str(OUT/'Trimix_Analyzer.kicad_pcb'),b);(OUT/'trial.json').write_text(json.dumps({'removed_original_CO_FB':removed,'routes':checks,'no_adoption':True},indent=2)+'\n');print(checks)
