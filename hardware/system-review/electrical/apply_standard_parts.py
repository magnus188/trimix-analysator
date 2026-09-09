"""Apply exact ordinary procurement choices, preserving symbol/pad identities.

Manufacturer typical DC-bias curves support engineering margins, not guaranteed
combined-corner capacitance. Physical, supplier and factory qualification stay open.
"""
from pathlib import Path
import sys,csv,re,json,shutil
ROOT=Path(__file__).resolve().parents[3];OUT=Path(__file__).resolve().parent
sys.path.insert(0,str(ROOT/'hardware/tools'))
from analyzer_sheet import *
CANDIDATES={r['reference']:r for r in csv.DictReader((OUT/'capacitor-research/ordinary-capacitor-proposals.csv').open())}
TDK='https://product.tdk.com/en/search/capacitor/ceramic/mlcc/info?part_no='
RC='https://yageogroup.com/content/datasheet/asset/file/PYU-RC_GROUP_51_ROHS_L'
RT='https://yageogroup.com/content/datasheet/asset/file/pyu-rt_1-to-0-01_rohs_l'
PARTS={}
def cap(refs,mpn,value,size,height,eff=None):
 for ref in refs.split():
  PARTS[ref]={'MPN':mpn,'Manufacturer':'TDK','Datasheet':TDK+mpn,'Value':value,'Footprint':'Capacitor_SMD:C_'+{'0603':'0603_1608','0805':'0805_2012','1206':'1206_3216','1210':'1210_3225'}[size]+'Metric','Maximum_body_height_mm':str(height)}
  if eff:PARTS[ref]['Effective_capacitance_review']=eff
for r in CANDIDATES.values():
 ref=r['reference'];uv=float(r['capacitance_uF']);val=(str(int(uv))+'u') if uv>=1 else (str(round(uv*1000,6)).rstrip('0').rstrip('.')+'n')
 PARTS[ref]={'MPN':r['proposed_mpn'],'Manufacturer':r['manufacturer'],'Datasheet':r['primary_source'],'Value':f"{val} / {r['rated_voltage_V']}V {r['dielectric']} / {r['tolerance_percent']}%",'Maximum_body_height_mm':r['max_body_height_mm']}
cap('C102 C104 C105 C204 C205 C206','C3225X7R1C226M250AC','22u / 16V X7R / 20%','1210',2.8,'5.5V typical bias~90%; engineering 12.1176u each after .8tol*.85temp*.9aging; combined corners not guaranteed')
cap('C106 C107 C201 C202 C701','C3216X5R1E226M160AB','22u / 25V X5R / 20%','1206',1.8,'5.5V typical bias~50%; engineering~6.73u each after tolerance/temp/aging; validate ripple/startup')
cap('C501 C502 C302 C303','C1608X5R1C475K080AC','4.7u / 16V X5R / 10%','0603',.9,'5.5V engineering estimate .9708u > TPS7A20 .47u effective minimum; at3V more margin; not a guaranteed production corner')
cap('C114','C3216X7R1E475K160AC','4.7u / 25V X7R / 10%','1206',1.8,'OVP shared interstage capacitor;2.912u engineering estimate, full transient test remains open')
cap('C704 C705','C2012X7R1E105K125AB','1u / 25V X7R / 10%','0805',1.45,'Engineering retained .55u at5.5V > TPS7A20 .47u effective minimum')
cap('C702 C703','C2012X5R1C226M125AC','22u / 16V X5R / 20%','0805',1.45,'Two parallel estimated~7u at5.5V; TPS61023 minimum4u; verify worst-temperature/bias and need for Cff if bank >40u')
cap('C203 C801 C802 C110 C111 C112 C113','C1608X7R1H104K080AA','100n / 50V X7R / 10%','0603',.9)
PARTS['C804']=dict(PARTS['C401']);PARTS['C804']['Footprint']='Capacitor_SMD:C_0603_1608Metric'
# Latest local VBUS bypass choice; retains the required nominal1uF function.
from apply_local_input_cap import CHOICE as LOCAL_INPUT_CAP
PARTS['C101']=dict(LOCAL_INPUT_CAP)
from compact_passive_choices import CHOICES as COMPACT_PASSIVES
PARTS.update({ref:dict(choice)for ref,choice in COMPACT_PASSIVES.items()})
PARTS['R301']={'MPN':'RC0603FR-0710KL','Manufacturer':'YAGEO','Datasheet':'https://yageogroup.com/component-documentation/download/specsheet/RC0603FR-0710KL','Maximum_body_length_mm':'1.7','Maximum_body_width_mm':'0.9','Maximum_body_height_mm':'0.55','Source_review':'electrical/compact-passive-review/r301-mating-clearance-review.json; exact manufacturer specsheet generated2026-09-06; actual routing placement checked separately from stale CAD v2'}
PARTS['Q110']={'MPN':'DMN2056U-7','Manufacturer':'Diodes Incorporated','Datasheet':'https://www.diodes.com/datasheet/download/DMN2056U.pdf','Footprint':'Trimix_Power:DMN2056U_SOT23_Diodes_Recommended','Land_pattern_review':'Manufacturer DS38480Rev2-2 page7:0.90x0.80mm lands,2.00mm opposing-row centres,1.90mm paired-pin pitch. Actual purchased SOT23 body and model are unchanged; factory stencil/assembly acceptance separate.'}
for ref in ['Q101','Q601','Q602']:
 mpn='2N7002-7-F' if ref=='Q101' else 'BSS138-7-F'
 PARTS[ref]={'MPN':mpn,'Manufacturer':'Diodes Incorporated','Datasheet':'https://www.diodes.com/datasheet/download/'+mpn.split('-')[0]+'.pdf'}
# D101/R106 and SW101 were removed from the active design; local C108 and
# TP1013/TP1014 provide the reviewed bypass and service interfaces.
for ref in ['J103','J104','J801','J802','J401','J501']:
 mpn='M20-9990346' if ref in ['J401','J501'] else 'M20-9990246'
 PARTS[ref]={'MPN':mpn,'Manufacturer':'Harwin','Datasheet':'https://www.harwin.com/products/'+mpn,'Harness_review':'New standard2.54mm PCB header; custom sensor/button/NTC harness; actual remote cable polarity/mate remains measured'}
for ref in ['J601','J701']:
 PARTS[ref]={'MPN':'B4B-XH-A(LF)(SN)','Manufacturer':'JST','Datasheet':'https://www.jst-mfg.com/product/pdf/eng/eXH.pdf','Harness_review':'New XHP-4 mating housing with SXH-001T-P0.6 contacts; 28-22AWG; remote module pinout must be checked'}
for ref,mpn in {'U101':'BQ25895RTWR','U201':'TPS63020DSJR','U701':'TPS61023DRLR','U703':'TXU0202DCUR'}.items():
 PARTS[ref]={'MPN':mpn,'Manufacturer':'Texas Instruments'}
PARTS['U301']={'MPN':'MAX17048G+T10','Manufacturer':'Analog Devices'}
PARTS['U801']={'MPN':'LTC2954CTS8-1#TRMPBF','Manufacturer':'Analog Devices'}
PARTS['J301']={'MPN':'HTSW-113-07-L-D-007','Manufacturer':'Samtec','Datasheet':'https://suddendocs.samtec.com/prints/htsw-xxx-xx-xxx-x-xx-xx-xx-mkt.pdf','Harness_review':'Drawing-derived keyed header and IDSD-13-S-04.00-G-P07 gold mate. Exact configured orderability, physical harness and remote connector require qualification.'}
PARTS['J402']={'MPN':'142138','Manufacturer':'Amphenol RF','Datasheet':'https://www.amphenolrf.com/en-us/part/142138/883/','Value':'SMB male-centre / Amphenol142138','Footprint':'Trimix_Power:SMB_Amphenol_142138','Maximum_body_height_mm':'8.2','Harness_review':'Actual R17JJ90degreefemale-SMB elbow envelope remains measured; shell is O2_B_RAW_N'}
def rcode(value):
 m=re.match(r'(\d+(?:\.\d+)?)(R|k|M)',value)
 if not m:return None
 n,u=m.groups();u=u.upper();return n.replace('.',u) if '.' in n else n+u

def run():
 before=OUT/'before-standard-parts';before.mkdir(exist_ok=True)
 for path in list(P.glob('*.kicad_sch')):
  a=sx.loads(path.read_text());changed=False
  for s in children(a,'symbol'):
   pr={p[1]:p for p in children(s,'property')};ref=pr['Reference'][2];dnp=str(child(s,'dnp')[1])=='yes'
   choice=dict(PARTS.get(ref,{}))
   if re.fullmatch(r'R\d+',ref) and ref not in ['R121','R122','R123','R124','R125','R126'] and not choice.get('MPN'):
    # A reviewed replacement's package/value takes precedence over the old
    # symbol fields. Never overwrite an explicit manufacturer-qualified MPN.
    fp=choice.get('Footprint',pr['Footprint'][2]);value=choice.get('Value',pr['Value'][2]);sz=re.search(r'R_(\d{4})_',fp);n=rcode(value);prec='0.1%' in value
    if sz and n:choice.update(MPN=('RT'+sz[1]+'BRD07' if prec else 'RC'+sz[1]+('JR-07' if n=='0R' else 'FR-07'))+n+'L',Manufacturer='YAGEO',Datasheet=RT if prec else RC)
   if not choice:continue
   if dnp and 'Value'in choice:choice['Value']+=' / DNP'
   for k,v in choice.items():
    if k in pr:pr[k][2]=v
    else:s.append(node('property',k,v,node('at',*child(s,'at')[1:]),effects(hide=True)))
   PARTS[ref]=choice;changed=True
  if changed:
   dest=before/(('daughter-' if path.parent.name=='usb-input' else '')+path.name)
   if not dest.exists():shutil.copy2(path,dest)
   save(path,a)
 (OUT/'standard-part-selections.json').write_text(json.dumps({'parts':PARTS,'status':'native schematic choices; PCB sync and qualification pending','physical_tests_performed':False,'supplier_quote':False},indent=2)+'\n')
if __name__=='__main__':run()
