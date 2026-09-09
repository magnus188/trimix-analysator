"""Read-only export-state serialization/cloud-save diagnosis."""
import json,hashlib
from pathlib import Path
from runtime import BASE

def inspect():
 import review_checkpoint as c
 app,doc,d=c._native();state=c._state(d);expected=json.loads((c.TARGET/'export.json').read_text())['state'];normalized=json.loads(json.dumps(state));changes=[]
 def walk(a,b,path):
  if a==b:return
  if type(a)!=type(b):changes.append({'path':path,'one_type':type(a).__name__,'two_type':type(b).__name__});return
  if isinstance(a,dict):
   if a.keys()!=b.keys():changes.append({'path':path,'keys_only_current':list(a.keys()-b.keys()),'keys_only_export':list(b.keys()-a.keys())})
   for k in a.keys()&b.keys():walk(a[k],b[k],path+'/'+str(k))
  elif isinstance(a,list):
   if len(a)!=len(b):changes.append({'path':path,'lengths':[len(a),len(b)]});return
   for i,(x,y)in enumerate(zip(a,b)):walk(x,y,path+'/'+str(i))
  else:changes.append({'path':path,'current':a,'export':b})
 walk(normalized,expected,'state')
 data={'document':doc.name,'cloud_version':doc.dataFile.versionNumber,'cloud_complete':doc.dataFile.isComplete,'modified':doc.isModified,
 'raw_state_matches':state==expected,'normalized_state_matches':normalized==expected,'field_comparison':{k:normalized[k]==expected[k]for k in state},
 'native_sequence_types':{'pose':type(next(iter(state['poses'].values()))).__name__,'local_pose':type(next(iter(state['main_descendants'].values()))['local_pose']).__name__},
 'changes':changes,'protected_documents':c._documents(app,doc),'read_only':True}
 path=c.TARGET/'state-diagnosis.json'
 if path.exists():raise RuntimeError('Preserve prior diagnosis')
 path.write_text(json.dumps(data,indent=2)+'\n');print(json.dumps(data))
