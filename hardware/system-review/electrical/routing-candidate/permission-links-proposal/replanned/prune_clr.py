from pathlib import Path
import sys,json,hashlib,shutil
import pcbnew as p
sys.path.insert(0,str(Path('hardware/system-review/electrical/current-path-review').resolve()))
from inventory import NativeGraph,stackup
D=Path(__file__).resolve().parent
source=D/'Trimix_Analyzer.kicad_pcb';text=source.read_text();(D/'stage-after-clr.kicad_pcb').write_text(text)
pairs=[('R115.2','U113.1'),('R115.2','U112.6'),('U113.1','U112.6')]
def witnesses(path):
 b=p.LoadBoard(str(path));g=NativeGraph(b,stackup(path.read_text()));out=[]
 for a,z in pairs:
  w=g.witness(g.pad_index[a][0],g.pad_index[z][0]);assert w['status']=='explicit_native_witness',(a,z,w);out.append(dict(source=a,target=z,witness=w))
 return out
before=witnesses(D/'stage-after-clr.kicad_pcb')
ids=['598efd2c-40ea-486f-9c32-79d1ff3b4573','9fc8848d-bcd5-4edc-8e20-54cc6f895664','c929eb43-8058-49a6-b484-1863baef068b','d85e1461-a9fb-4508-a86a-971be288c3a8'];removed=[]
for uid in ids:
 pos=text.index(uid);lo=text.rfind('(segment',0,pos);dep=0;quoted=False;escape=False
 for hi in range(lo,len(text)):
  ch=text[hi]
  if quoted:
   if escape:escape=False
   elif ch==chr(92):escape=True
   elif ch=='"':quoted=False
  elif ch=='"':quoted=True
  elif ch=='(':dep+=1
  elif ch==')':
   dep-=1
   if dep==0:break
 assert uid in text[lo:hi+1];removed.append(dict(uuid=uid,native=text[lo:hi+1]));text=text[:lo]+text[hi+1:]
out=D/'stage-clr-pruned.kicad_pcb';out.write_text(text);b=p.LoadBoard(str(out));p.ZONE_FILLER(b).Fill(b.Zones());p.SaveBoard(str(out),b)
after=witnesses(out)
receipt=dict(before_sha256=hashlib.sha256((D/'stage-after-clr.kicad_pcb').read_bytes()).hexdigest(),after_sha256=hashlib.sha256(out.read_bytes()).hexdigest(),retained_real_endpoints=pairs,before_witnesses=before,after_witnesses=after,removed_source_stubs=removed,notes=['Both original CLR through-vias and all F copper retained.','Only four now-redundant In2 tracks pruned after completing and proving all three real endpoints.','Native adjacency witnesses exclude zones and never assume internal package joins.'])
(D/'clr-pruning-witnesses.json').write_text(json.dumps(receipt,indent=2)+'\n');print(receipt['after_sha256'],'all3before and3after witnesses pass')
