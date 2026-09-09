"""Compare KiCad-exported physical connectivity with separately stored intent."""
from pathlib import Path
import csv, json, xml.etree.ElementTree as ET
from collections import defaultdict
import sexpdata as sx

hw=Path(__file__).resolve().parents[1]
v=hw/'pcb/verification/power'
intent=json.loads((v/'intended-nets.json').read_text())
root=ET.parse(v/'Trimix_Power-netlist.xml').getroot()
expected=defaultdict(set); nc=set()
for sheet,refs in intent.items():
    for ref,pins in refs.items():
        if ref.startswith('#'):continue
        for pin,net in pins.items():
            (nc if net is None else expected[net]).add((ref,pin))
actual=[]; by_pin={}
for net in root.findall('./nets/net'):
    group={(x.attrib['ref'],x.attrib['pin']) for x in net.findall('node') if not x.attrib['ref'].startswith('#')}
    if not group:continue
    actual.append((net.attrib['name'],group))
    for rp in group:by_pin[rp]=(net.attrib['name'],group)
errors=[]; matched=[]
for name,group in sorted(expected.items()):
    result=by_pin.get(next(iter(group)))
    if result is None or result[1]!=group:
        errors.append({'net':name,'expected':sorted(group),'actual':sorted(result[1]) if result else []})
    else:matched.append({'intended_name':name,'exported_name':result[0],'nodes':sorted(group)})
for rp in sorted(nc):
    if rp in by_pin and by_pin[rp][1]!={rp}:errors.append({'unexpected_connection_on_nc':rp,'actual':sorted(by_pin[rp][1])})
all_expected=set().union(*expected.values())|nc
if set(by_pin)!=all_expected:errors.append({'missing_or_extra_pins':sorted(set(by_pin)^all_expected)})

def tag(a):return str(a[0]) if isinstance(a,list) and a else ''
def children(a,t):return [x for x in a if tag(x)==t]
def child(a,t):return next((x for x in a if tag(x)==t),None)
ic_pinsets={'U101':set(map(str,range(1,26))),'U201':set(map(str,range(1,16))),'U301':set(map(str,range(1,10)))}
footprint_results=[]
for ref,expected_pads in ic_pinsets.items():
    comp=next(x for x in root.findall('./components/comp') if x.attrib['ref']==ref)
    lib,fp=comp.findtext('footprint').split(':',1)
    mod=Path('/Applications/KiCad/KiCad.app/Contents/SharedSupport/footprints')/(lib+'.pretty')/(fp+'.kicad_mod')
    pads={str(x[1]) for x in children(sx.loads(mod.read_text()),'pad') if x[1]!=''}
    if pads!=expected_pads:errors.append({'footprint_pad_mismatch':ref,'expected':sorted(expected_pads),'actual':sorted(pads)})
    footprint_results.append({'reference':ref,'footprint':lib+':'+fp,'pad_numbers_match':pads==expected_pads,'scope':'Pad numbering only; mechanical/thermal suitability not certified.'})
erc=json.loads((v/'Trimix_Power-erc.json').read_text())
violations=[x for sh in erc['sheets'] for x in sh.get('violations',[])]
if violations:errors.append({'erc_violations':len(violations)})
report={'result':'PASS' if not errors else 'FAIL','pcb_components':len(root.findall('./components/comp')),'intended_connected_nets':len(expected),'physical_pins_checked':len(all_expected),'intentionally_unused_pins':[list(x) for x in sorted(nc)],'erc_errors':sum(x['severity']=='error' for x in violations),'erc_warnings':sum(x['severity']=='warning' for x in violations),'erc_ignored_checks':erc.get('ignored_checks',[]),'connections':matched,'ic_footprint_pad_checks':footprint_results,'errors':errors}
(v/'connectivity-audit.json').write_text(json.dumps(report,indent=2)+'\n')
with (v/'pcb-bom.csv').open('w',newline='') as f:
    w=csv.writer(f);w.writerow(['reference','value','footprint','fit','status'])
    for comp in root.findall('./components/comp'):
        ref=comp.attrib['ref'];fp=comp.findtext('footprint','')
        w.writerow([ref,comp.findtext('value'),fp,'DNP - check host pull-ups' if ref in {'R302','R303'} else 'FIT','Provisional package; verify exact MPN' if fp else 'Footprint/part selection pending'])
print(json.dumps({k:report[k] for k in ['result','pcb_components','intended_connected_nets','physical_pins_checked','erc_errors','erc_warnings','errors']},indent=2))
if errors:raise SystemExit(1)
