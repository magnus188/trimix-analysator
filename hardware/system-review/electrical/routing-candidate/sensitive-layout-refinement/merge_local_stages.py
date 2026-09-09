from pathlib import Path
import sys,shutil,copy,uuid,json,hashlib
D=Path(__file__).resolve().parent;OUT=D/'synchronized-local';shutil.copytree(D/'co-load-separated',OUT,dirs_exist_ok=True)
sys.path[:0]=[str(D.parents[3]/'tools'),str(D.parents[1])]
from analyzer_sheet import sx,child,tag
from apply_review_fixes import top_blocks
base=(D/'baseline/Trimix_Analyzer.kicad_pcb').read_text();raw=(OUT/'Trimix_Analyzer.kicad_pcb').read_text()
def items(raw):
 d={}
 for a,z,s in top_blocks(raw):
  if not s.startswith(('(footprint','(segment','(via')):continue
  q=sx.loads(s);uid=child(q,'uuid')[1];d[uid]=(a,z,s,q)
 return d
old=items(base);logs=[]
for source in [D/'c103-qualified/Trimix_Analyzer.kicad_pcb',D/'root-r504/candidate3/Trimix_Analyzer.kicad_pcb']:
 after=items(source.read_text());cur=items(raw);removed=sorted(old.keys()-after.keys());added=sorted(after.keys()-old.keys());modified=sorted(k for k in old.keys()&after.keys()if sx.dumps(old[k][3])!=sx.dumps(after[k][3]));ed=[]
 for uid in removed+modified:
  assert uid in cur,('missingprecondition',uid)
  assert sx.dumps(cur[uid][3])==sx.dumps(old[uid][3]),('changedprecondition',uid)
  a,z,s,q=cur[uid];ed.append((a,z,''if uid in removed else after[uid][2]))
 for a,z,s in sorted(ed,reverse=True):raw=raw[:a]+s+raw[z:]
 for uid in added:
  assert uid not in cur
  at=raw.rfind(')');raw=raw[:at]+after[uid][2]+'\n'+raw[at:]
 logs.append({'source':str(source),'source_sha256':hashlib.sha256(source.read_bytes()).hexdigest(),'removed':removed,'added':added,'modified':modified,'preconditions':'allnativeobjects source-identical'})
# Synchronize actual R702 purchased0402 fields in this isolated schematic andboard only.
vals={'MPN':'RT0402BRD07100KL','Manufacturer':'YAGEO','Datasheet':'https://yageogroup.com/component-documentation/download/specsheet/RT0402BRD07100KL','Footprint':'Resistor_SMD:R_0402_1005Metric','Maximum_body_length_mm':'1.10','Maximum_body_width_mm':'0.55','Maximum_body_height_mm':'0.35','Assembly':'Factory reflow for true0402; exact100k0.1% value retained','Source_review':'SameexactYAGEORT0402BRD07100KL specsheet asselectedR118; sensitive-layout-refinement dividerplacement'}
def fields(q,isboard):
 props={x[1]:x for x in q if tag(x)=='property'}
 for key,val in vals.items():
  if isboard and key=='Footprint':continue
  if key in props:props[key][2]=val
  else:
   x=copy.deepcopy(props['MPN']);x[1:3]=[key,val];u=child(x,'uuid')
   if u:u[1]=str(uuid.uuid4())
   q.append(x)
for uid,(a,z,s,q)in items(raw).items():
 if tag(q)=='footprint'and next(x[2]for x in q if tag(x)=='property'and x[1]=='Reference')=='R702':fields(q,True);raw=raw[:a]+sx.dumps(q)+raw[z:];break
(OUT/'Trimix_Analyzer.kicad_pcb').write_text(raw)
shutil.copy2(D/'c103-qualified/Charging.kicad_sch',OUT/'Charging.kicad_sch');shutil.copy2(D/'c103-qualified/Trimix_Power.pretty/C_TDK_C1005_Recommended.kicad_mod',OUT/'Trimix_Power.pretty/C_TDK_C1005_Recommended.kicad_mod')
for p in OUT.glob('*.kicad_sch'):
 r=sx.loads(p.read_text());changed=False
 for q in r:
  if tag(q)!='symbol':continue
  props={x[1]:x for x in q if tag(x)=='property'}
  if props.get('Reference',[None,None,None])[2]=='R702':fields(q,False);changed=True
 if changed:p.write_text(sx.dumps(r)+'\n')
(OUT/'merge-receipt.json').write_text(json.dumps(logs,indent=2)+'\n')
