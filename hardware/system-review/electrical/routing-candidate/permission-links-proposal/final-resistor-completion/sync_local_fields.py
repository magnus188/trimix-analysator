from pathlib import Path
import sexpdata as s,json,hashlib,shutil
D=Path(__file__).resolve().parent
board=s.loads((D/'Trimix_Analyzer.kicad_pcb').read_text())
def tag(q):return str(q[0])if isinstance(q,list)and q else''
fp={}
for q in board:
 if tag(q)!='footprint':continue
 props={a[1]:a[2]for a in q if tag(a)=='property'}
 if props.get('Reference')in ['R101','R118','R119']:fp[props['Reference']]={**props,'Footprint':q[1]}
changes=[]
for file in D.glob('*.kicad_sch'):
 raw=s.loads(file.read_text());changed=False
 for q in raw:
  if tag(q)!='symbol':continue
  props={a[1]:a for a in q if tag(a)=='property'};ref=props.get('Reference',[None,None,None])[2]
  if ref not in fp:continue
  for key in ['Footprint','MPN','Value','Datasheet']:
   if key not in fp[ref]or key not in props:continue
   if props[key][2]==fp[ref][key]:continue
   changes.append(dict(file=file.name,ref=ref,key=key,before=props[key][2],after=fp[ref][key]));props[key][2]=fp[ref][key];changed=True
 if changed:
  dest=D/'pre-field-sync';dest.mkdir(exist_ok=True);shutil.copyfile(file,dest/file.name);file.write_text(s.dumps(raw)+'\n')
(D/'isolated-field-sync.json').write_text(json.dumps(changes,indent=2)+'\n');print(changes)
