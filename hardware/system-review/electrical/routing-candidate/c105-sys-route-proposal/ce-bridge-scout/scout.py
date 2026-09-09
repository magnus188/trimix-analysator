"""Read-only native geometry scout; never saves or mutates a board."""
from pathlib import Path
import pcbnew as p
import hashlib,json,math,heapq,itertools
D=Path(__file__).resolve().parent; SOURCE=D.parent/'before.kicad_pcb'
EXPECTED='609a6241ce50cbe3d40f7a1676c455092db583875895eeb8236083bf2c5f0ef1'
assert hashlib.sha256(SOURCE.read_bytes()).hexdigest()==EXPECTED
b=p.LoadBoard(str(SOURCE)); ALL=[p.F_Cu,p.In1_Cu,p.In2_Cu,p.B_Cu]
UID='d8e337d6-f633-48d8-8b77-3ad15ac9c500'; target=next(t for t in b.GetTracks()if t.m_Uuid.AsString()==UID); NET=target.GetNetname()
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
   if isinstance(t,p.PAD)and t.GetAttribute()==p.PAD_ATTRIB_SMD:smt.append((info(t,L),s))
for t in b.GetDrawings():
 if t.GetLayer()==p.Edge_Cuts:edges.append((info(t,p.Edge_Cuts),t.GetEffectiveShape()))
for z in list(b.Zones())+[z for f in b.GetFootprints()for z in f.Zones()]:
 if not z.GetIsRuleArea():continue
 for L in ALL:
  if z.IsOnLayer(L):
   if z.GetDoNotAllowTracks():rules[L].append((info(z,L),z.Outline()))
   if z.GetDoNotAllowVias():vrules.append((info(z,L),z.Outline()))
def test(q,rows,r):return [i for i,s in rows if s.Collide(q,p.FromMM(r))]
def via_blockers(q):
 q=v(q)
 return [dict(i,check='foreign_copper')for L in ALL for i in test(q,foreign[L],.4501)]+[dict(i,check='SMT_union_margin')for i in test(q,smt,.3001)]+[dict(i,check='edge')for i in test(q,edges,.7501)]+[dict(i,check='via_rule_area')for i in test(q,vrules,.2501)]
def seg_blockers(a,z,L):
 s=p.SEG(v(a),v(z))
 return test(s,foreign[L],.2751)+[dict(i,check='edge')for i in test(s,edges,.5751)]+[dict(i,check='track_rule_area')for i in test(s,rules[L],.0751)]
def clear(a,z,L):return not seg_blockers(a,z,L)
def legal(q,L):return not test(v(q),foreign[L],.2751) and not test(v(q),edges,.5751) and not test(v(q),rules[L],.0751)
def original(t):return [8.75+2.075*t,88.425-2.6*t]
def main():
 samples=[]
 for j in range(201):
  q=original(j/200); blockers=via_blockers(q)
  samples.append({'xy':q,'t':j/200,'blockers':blockers})
 legal_line=[r for r in samples if not r['blockers']]
 print('legal_on_original',[(r['t'],r['xy'])for r in legal_line],flush=True)
 rows=[]
 for ix in range(160,221):
  for iy in range(1720,1801):
   q=[ix*.05,iy*.05]
   if not via_blockers(q):rows.append(q)
 print('legal_grid_count',len(rows),flush=True)
 print('legal_grid',rows,flush=True)
 (D/'initial-sites.json').write_text(json.dumps({'source_sha256':EXPECTED,'net':NET,'original_track_uuid':UID,'legal_original_sites':legal_line,'all_original_samples':samples,'grid':rows},indent=2)+'\n')
 for q in [[9.45,88.8],[10,88.9],[9.9,88.9],[9.85,88.95],[9.45,86.65],[9.5,86.7],[10,86.65]]:print('test',q,via_blockers(q),flush=True)
 assert hashlib.sha256(SOURCE.read_bytes()).hexdigest()==EXPECTED
if __name__=='__main__':main()
