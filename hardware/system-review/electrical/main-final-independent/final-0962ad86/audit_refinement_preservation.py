"""Read-only, revision-specific independent checks. No KiCad API, no claimed supplier qualification."""
from pathlib import Path
from collections import Counter
import json,hashlib,csv,xml.etree.ElementTree as E,sys
import sexpdata as s
sys.path.insert(0,str(Path(__file__).resolve().parent.parent));from cam_geometry import Native,sub,subs
D=Path(__file__).resolve().parent;BASE=Path('hardware/system-review/electrical/routing-candidate/sensitive-layout-refinement/frozen-local-bundle');OLD=Path('hardware/system-review/electrical/routing-candidate/final-cleanup/frozen-bundle')
B=BASE/'hardware/pcb/analyzer/Trimix_Analyzer.kicad_pcb';A=OLD/'hardware/pcb/analyzer/Trimix_Analyzer.kicad_pcb'
files=[B,A,BASE/'review/analyzer-netlist.xml',OLD/'review/analyzer-netlist.xml',BASE/'review/cam-input-manifest.json',BASE/'cam/factory-bom.csv',BASE/'cam/manual-bom.csv',BASE/'cam/marking-legend.csv',BASE/'fill-cap-process/required-fill-cap-holes.csv',OLD.parent/'fill-cap-process/required-fill-cap-holes.csv']
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest();before={str(p):sha(p)for p in files};assert sha(B)=='0962ad86f9834ce71b6439d0f95db603753801153490e78f387a88521e582788';assert sha(A)=='9f274fdf198f1bcb871a4fc360e76693f8a5b048553e6a02998141737956514f'
na,nb=Native(s.loads(A.read_text())),Native(s.loads(B.read_text()));fps={f['ref']:f for f in nb.fps};checks=[]
def ck(name,ok,detail=None):checks.append(dict(check=name,passed=bool(ok),detail=detail))
def pinmap(path):
 r=E.parse(path).getroot();return{n.attrib['name']:sorted((q.attrib['ref'],q.attrib['pin'])for q in n.findall('node'))for n in r.findall('./nets/net')}
pa,pb=pinmap(OLD/'review/analyzer-netlist.xml'),pinmap(BASE/'review/analyzer-netlist.xml');ck('Every schematic net retains exactly the previous physical reference/pin membership',pa==pb,{k:{'old':pa.get(k),'new':pb.get(k)}for k in pa.keys()|pb.keys()if pa.get(k)!=pb.get(k)})
factory={r['Reference']:r for r in csv.DictReader((BASE/'cam/factory-bom.csv').open())};manual={r['Reference']:r for r in csv.DictReader((BASE/'cam/manual-bom.csv').open())}
expect={'C103':('C1005X7R1H473K050BE','bottom'),'R702':('RT0402BRD07100KL','top'),'C107':('C2012X5R1A476M125AC','bottom')}
for ref,(mpn,side)in expect.items():
 f=fps[ref];pads=[q for q in nb.pads if q['ref']==ref]
 ck(ref+' exact revised factory part and side',ref in factory and ref not in manual and factory[ref]['MPN']==mpn and f['props'].get('MPN')==mpn and f['side']==side,dict(MPN=f['props'].get('MPN'),side=f['side'],footprint=f['package'],value=f['value']))
 ck(ref+' real selected land geometry, not prior scaled footprint',len(pads)==2 and (all(abs(q['w']-.4)<1e-7 and abs(q['h']-.55)<1e-7 for q in pads)if ref=='C103'else all(abs(q['w']-.54)<1e-7 and abs(q['h']-.64)<1e-7 for q in pads)if ref=='R702'else all(abs(q['w']-.8)<1e-7 and abs(q['h']-1.1)<1e-7 for q in pads)),[{k:q[k]for k in['pin','w','h','shape','x','y','net']}for q in pads])
f=fps['R504'];ck('R504 remains exact10k0603 manual rear component',f['props'].get('MPN')=='RT0603BRD0710KL'and f['side']=='bottom'and '0603'in f['package']and 'R504'in manual and 'R504'not in factory and abs(f['x']-18.25)<1e-7 and abs(f['y']+48)<1e-7,dict(MPN=f['props'].get('MPN'),pose=[f['x'],-f['y'],f['rotation']],package=f['package']))
# Physical split-pad identity of source-control silicon and Q110 manufacturer lands is preserved.
ctrl=['U110','U111','U112','U113','U114','U115','Q110','Q111','Q112','R116','R119','R125','R126']
def padsig(n,ref):return sorted((q['pin'],q['net'],q['x'],q['y'],q['w'],q['h'],q['angle'],q['shape'],tuple(q['layers']))for q in n.pads if q['ref']==ref)
ck('Critical source-control physical copper pads individually unchanged',all(padsig(na,r)==padsig(nb,r)for r in ctrl),{'refs':ctrl,'changed':[r for r in ctrl if padsig(na,r)!=padsig(nb,r)]})
# Exact fill/cap table semantic rows, independent of revised board hash text.
new=list(csv.DictReader((BASE/'fill-cap-process/required-fill-cap-holes.csv').open()));old=list(csv.DictReader((OLD.parent/'fill-cap-process/required-fill-cap-holes.csv').open()));cols=set(new[0])&set(old[0]);cols={k for k in cols if 'hash'not in k.lower()and 'sha'not in k.lower()}
ck('All27 specified fill/cap holes preserve prior exact semantic rows',len(new)==len(old)==27 and Counter(tuple((k,r[k])for k in sorted(cols))for r in new)==Counter(tuple((k,r[k])for k in sorted(cols))for r in old),{'columns':sorted(cols),'new_rows':len(new),'old_rows':len(old)})
m=json.loads((BASE/'review/cam-input-manifest.json').read_text());bad=[q['path']for q in m['files']if sha(BASE/q['path'])!=q['sha256']];ck('All36 frozen owner manifest artifacts match their claimed hashes',len(m['files'])==36 and not bad,bad)
ck('Inputs unchanged during independent revision audit',before=={str(p):sha(p)for p in files})
r={'board_sha256':sha(B),'previous_board_sha256':sha(A),'passed':sum(q['passed']for q in checks),'failed':sum(not q['passed']for q in checks),'checks':checks,'source_hashes':before,'limitations':['Netlist membership and preservedcontrolpad shapes are complementary to the fresh Gerber physical graph; they do not by themselves prove connectivity.','Land-pattern checks are digital geometry, not assembly process yield or cap bias/thermal qualification.'],'order_release':False};(D/'refinement-preservation-audit.json').write_text(json.dumps(r,indent=2)+'\n');print(json.dumps(r,indent=2));raise SystemExit(r['failed']>0)
