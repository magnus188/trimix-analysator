"""Source-bound supplement to the existing package/pin electrical audit."""
from pathlib import Path
import sys,json,hashlib,copy,xml.etree.ElementTree as E
import sexpdata as s
D=Path(__file__).resolve().parent;O=D/'frozen-local-bundle';P=O/'hardware/pcb/analyzer/Trimix_Analyzer.kicad_pcb';X=O/'review/analyzer-netlist.xml'
B=D.parents[1]/'routing-candidate/final-cleanup/frozen-bundle/review/analyzer-netlist.xml'
def sub(q,k):return next((x for x in q if isinstance(x,list)and str(x[0])==k),None)
def comps(x):return{c.get('ref'):c for c in x.findall('./components/comp')}
def fields(c):return{q.get('name'):q.text or ''for q in c.findall('./fields/field')}
def pins(x):return{(q.get('ref'),q.get('pin')):net.get('name')for net in x.findall('./nets/net')for q in net.findall('node')}
before=E.parse(B).getroot();target=E.parse(X).getroot();raw=s.loads(P.read_text())
expected={'C103':('47n / 50V X7R / 10%','C1005X7R1H473K050BE','Trimix_Power:C_TDK_C1005_Recommended',(1.15,.60,.60)), 'C107':('47u / 10V X5R / 20%','C2012X5R1A476M125AC','Trimix_Power:C_TDK_C2012_Recommended',(2.20,1.45,1.45)), 'R702':('100k / 0.1%','RT0402BRD07100KL','Resistor_SMD:R_0402_1005Metric',(1.10,.55,.35)), 'R504':('10k / 0.1%','RT0603BRD0710KL','Resistor_SMD:R_0603_1608Metric',(1.70,.90,.55))}
def validate(xml,board):
 rows=[]
 def check(name,ok):rows.append({'check':name,'passed':bool(ok)})
 aa,bb=comps(before),comps(xml)
 check('Entire schematic component population unchanged',set(aa)==set(bb))
 check('Every schematic ref/pin/net assignment preserved',pins(before)==pins(xml))
 for ref in aa:
  if ref in ['C103','C107','R702']:continue
  check(ref+' purchased value/MPN/footprint conserved',aa[ref].findtext('value')==bb[ref].findtext('value')and fields(aa[ref]).get('MPN')==fields(bb[ref]).get('MPN')and aa[ref].findtext('footprint')==bb[ref].findtext('footprint'))
 fps={sub(q,'property')[2]:q for q in board if isinstance(q,list)and str(q[0])=='footprint'}
 # Read Reference by name rather than assuming property order.
 fps={next(p[2]for p in q if isinstance(p,list)and str(p[0])=='property'and p[1]=='Reference'):q for q in board if isinstance(q,list)and str(q[0])=='footprint'}
 for ref,(val,mpn,fp,dims)in expected.items():
  c=bb[ref];f=fields(c);q=fps[ref];pr={p[1]:p[2]for p in q if isinstance(p,list)and str(p[0])=='property'}
  check(ref+' exact sourced value and MPN',c.findtext('value')==val and f['MPN']==mpn and pr['Value']==val and pr['MPN']==mpn)
  check(ref+' exact physical footprint identity',c.findtext('footprint')==fp and q[1]==fp)
  for key,v in zip(['Maximum_body_length_mm','Maximum_body_width_mm','Maximum_body_height_mm'],dims):check(ref+' '+key,float(f[key])==v and float(pr[key])==v)
  for pad in [p for p in q if isinstance(p,list)and str(p[0])=='pad']:check(ref+'.'+pad[1]+' board net matches source',sub(pad,'net')[1]==pins(xml)[(ref,pad[1])])
 for ref,pitch,size in [('C103',.40,[.40,.55]),('C107',.925,[.80,1.10])]:
  for pad in [p for p in fps[ref]if isinstance(p,list)and str(p[0])=='pad']:
   check(ref+'.'+pad[1]+' manufacturer-range rectangular land',str(pad[3])=='rect'and sub(pad,'size')[1:]==size and abs(float(sub(pad,'at')[1]))==pitch)
 check('C107 effective/startup metadata replaced, not inherited', '6.328' in fields(bb['C107'])['Effective_capacitance_review'] and 'startup' in fields(bb['C107'])['Effective_capacitance_review'])
 return rows
rows=validate(target,raw);negative=[]
for ref,key,bad in [('C107','value','22u / 25V X5R / 20%'),('C103','MPN','C2012X7R1H473K125AA'),('R702','footprint','Resistor_SMD:R_0603_1608Metric'),('R504','Maximum_body_height_mm','0.60')]:
 x=copy.deepcopy(target);c=comps(x)[ref]
 if key in ['value','footprint']:c.find(key).text=bad
 else:next(q for q in c.findall('./fields/field')if q.get('name')==key).text=bad
 negative.append({'injected_fault':ref+' '+key,'rejected':any(not r['passed']for r in validate(x,raw))})
assert all(r['passed']for r in rows),[r for r in rows if not r['passed']]
assert all(r['rejected']for r in negative)
receipt={'script_sha256':hashlib.sha256(Path(__file__).read_bytes()).hexdigest(),'board_sha256':hashlib.sha256(P.read_bytes()).hexdigest(),'netlist_sha256':hashlib.sha256(X.read_bytes()).hexdigest(),'baseline_netlist_sha256':hashlib.sha256(B.read_bytes()).hexdigest(),'checks':rows,'passed':len(rows),'failed':0,'negative_controls':negative,'source_evidence':['c103-source/source-review.json','../../sensitive-layout-refinement/c107-0805/README.md','root-r504/candidate3/scope-and-witnesses.json'],'meaning':'Exact purchased identity, land and pin-conservation checks supplement 217 freshly rerun electrical assertions. Source choice and physical behavior remain separately reviewed; no order release.'}
(O/'review/refinement-identity-audit.json').write_text(json.dumps(receipt,indent=2)+'\n');print(len(rows),'identity checks;4 injected metadata faults rejected')
