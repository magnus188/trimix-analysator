from pathlib import Path
import sys, shutil, copy, uuid, json, hashlib
D=Path(__file__).resolve().parent
src=D/'synchronized-local'; out=D/'synchronized-clean'
shutil.copytree(src,out,dirs_exist_ok=True)
sys.path[:0]=[str(D.parents[3]/'tools'),str(D.parents[1])]
from analyzer_sheet import sx,child,tag
from apply_review_fixes import top_blocks
S=sx.Symbol
raw=(out/'Trimix_Analyzer.kicad_pcb').read_text(); edits=[]
removed='9c343bd6-e313-40ea-acb9-8ff15d8e2649'
values={'Maximum_body_length_mm':'1.70','Maximum_body_width_mm':'0.90','Maximum_body_height_mm':'0.55','Source_review':'YAGEO RT specification V17, 2026-02-12, page 4 Table 1: 0603 L1.60±0.10 W0.80±0.10 H0.45±0.10 mm. Any 0.60 mm envelope is conservative, not the manufacturer maximum.'}
def set_fields(q):
 props={x[1]:x for x in q if tag(x)=='property'}
 for k,v in values.items():
  if k in props:props[k][2]=v
  else:
   p=copy.deepcopy(props['MPN']);p[1:3]=[k,v];u=child(p,'uuid')
   if u:u[1]=str(uuid.uuid4())
   q.append(p)
for a,z,b in top_blocks(raw):
 if not b.startswith(('(segment','(footprint')):continue
 q=sx.loads(b)
 if child(q,'uuid')[1]==removed:
  assert tag(q)=='segment' and child(q,'layer')[1]=='F.Cu'
  edits.append((a,z,''));continue
 if tag(q)!='footprint':continue
 props={x[1]:x for x in q if tag(x)=='property'};ref=props['Reference'][2]
 if ref=='R504':set_fields(q)
 elif ref in ['U701','R702','C702']:
  r=props['Reference'];child(r,'layer')[1]='F.Fab'
  if child(r,'hide') is None:r.append([S('hide'),S('yes')])
 else:continue
 edits.append((a,z,sx.dumps(q)))
assert len(edits)==5
for a,z,b in sorted(edits,reverse=True):raw=raw[:a]+b+raw[z:]
(out/'Trimix_Analyzer.kicad_pcb').write_text(raw)
for p in out.glob('*.kicad_sch'):
 q=sx.loads(p.read_text());changed=False
 for x in q:
  if tag(x)!='symbol':continue
  pr={v[1]:v for v in x if tag(v)=='property'}
  if pr.get('Reference',[None,None,None])[2]=='R504':set_fields(x);changed=True
 if changed:p.write_text(sx.dumps(q)+'\n')
(out/'cleanup-receipt.json').write_text(json.dumps({'source_sha256':hashlib.sha256((src/'Trimix_Analyzer.kicad_pcb').read_bytes()).hexdigest(),'removed_copper':[removed],'removed_reason':'Old R702 ground tail ends at vacated pad. Existing ground via and all other copper retained; native partitions and filled-plane anchors require comparison.','hidden_fab_references':['U701','R702','C702'],'reference_policy':'Dense overlapping labels moved to assembly/Fab map, pending refreshed visible-marking legend.','metadata_change':{'R504':values},'status':'isolated cleanup pending fresh native and plane checks'},indent=2)+'\n')
import pcbnew as p
b=p.LoadBoard(str(out/'Trimix_Analyzer.kicad_pcb'));p.ZONE_FILLER(b).Fill(b.Zones());p.SaveBoard(str(out/'Trimix_Analyzer.kicad_pcb'),b)
