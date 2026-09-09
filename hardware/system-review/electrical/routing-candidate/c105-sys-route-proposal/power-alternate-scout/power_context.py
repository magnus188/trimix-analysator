"""Read-only native geometry scout; never saves or mutates a board."""
from pathlib import Path
import pcbnew as p
import hashlib,json,math,heapq,itertools
D=Path(__file__).resolve().parent; SOURCE=D.parent/'ce-bridge-scout/candidate/Trimix_Analyzer.kicad_pcb'
EXPECTED='3ba04d481d49b39d87a800c941448d665bcbd465af761bb2b0d617c23429b469'
assert hashlib.sha256(SOURCE.read_bytes()).hexdigest()==EXPECTED
b=p.LoadBoard(str(SOURCE)); ALL=[p.F_Cu,p.In1_Cu,p.In2_Cu,p.B_Cu]
UID='e0ff3d79-dfcb-4e4d-bd20-72417ad68f09'; target=next(t for t in b.GetTracks()if t.m_Uuid.AsString()==UID); NET=target.GetNetname()
def v(q):return p.VECTOR2I(p.FromMM(q[0]),p.FromMM(q[1]))
def xy(q):return [p.ToMM(q.x),p.ToMM(q.y)]
def info(t,L):
 r={'uuid':t.m_Uuid.AsString(),'layer':b.GetLayerName(L)}
 if hasattr(t,'GetNetname'):r['net']=t.GetNetname()
 if isinstance(t,p.PAD):r.update(ref=t.GetParentFootprint().GetReference(),pin=t.GetNumber())
 return r
foreign={L:[]for L in ALL}; smt=[];edges=[];rules={L:[]for L in ALL};vrules=[]
for t in list(b.GetTracks())+[q for f in b.GetFootprints()for q in f.Pads()]:
 for L in ALL:
  if t.IsOnLayer(L):
   s=t.GetEffectiveShape(L)
   if t.GetNetname()!=NET:foreign[L].append((info(t,L),s))
   if isinstance(t,p.PAD):smt.append((info(t,L),s))
for t in b.GetDrawings():
 if t.GetLayer()==p.Edge_Cuts:edges.append((info(t,p.Edge_Cuts),t.GetEffectiveShape()))
for z in list(b.Zones())+[z for f in b.GetFootprints()for z in f.Zones()]:
 if not z.GetIsRuleArea():continue
 for L in ALL:
  if z.IsOnLayer(L):
   if z.GetDoNotAllowTracks():rules[L].append((info(z,L),z.Outline()))
   if z.GetDoNotAllowVias():vrules.append((info(z,L),z.Outline()))
def test(q,rows,r):return [i for i,s in rows if s.Collide(q,p.FromMM(r))]
def via_blockers(q,diameter=.6):
 q=v(q)
 r=diameter/2
 return [dict(i,check='foreign_copper')for L in ALL for i in test(q,foreign[L],r+.2001)]+[dict(i,check='all_pad_union_margin')for i in test(q,smt,r+.0501)]+[dict(i,check='edge')for i in test(q,edges,r+.5001)]+[dict(i,check='via_rule_area')for i in test(q,vrules,r+.0001)]
def seg_blockers(a,z,L):
 s=p.SEG(v(a),v(z))
 return test(s,foreign[L],.4001)+[dict(i,check='edge')for i in test(s,edges,.7001)]+[dict(i,check='track_rule_area')for i in test(s,rules[L],.2001)]
def clear(a,z,L):return not seg_blockers(a,z,L)
def legal(q,L):return not test(v(q),foreign[L],.4001) and not test(v(q),edges,.7001) and not test(v(q),rules[L],.2001)
