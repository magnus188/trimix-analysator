"""Select a real 1 uF/0603 capacitor for the short BQ VBUS bypass.

TI specifies nominal 1 uF at VBUS. This is not a 100 nF substitution or a
scaled model; qualified source data and current-loop validation remain separate.
"""
from pathlib import Path
import sys,json,shutil,copy
sys.path.insert(0,str(Path(__file__).resolve().parents[2]/'tools'))
from analyzer_sheet import *
OUT=Path(__file__).resolve().parent
CHOICE={'Value':'1u / 16V X7R / 10%','Footprint':'Capacitor_SMD:C_0603_1608Metric','MPN':'C0603C105K4RACTU','Manufacturer':'KEMET / YAGEO','Datasheet':'https://search.kemet.com/component-documentation/download/specsheet/C0603C105K4RACTU','Maximum_body_height_mm':'0.9','Effective_capacitance_review':'Nominal1uF as TI BQ VBUS recommendation; typical5.5V bias retains~90%; combined tolerance/temp/aging estimate~0.620uF, not guaranteed; physical startup/ripple pending','Purpose':'Short F-side VBUS bypass beside BQ25895; exact smaller purchased0603 package, not scaled0805'}
def run():
 path=P/'Charging.kicad_sch';backup=OUT/'before-local-input-cap.kicad_sch'
 if not backup.exists():shutil.copy2(path,backup)
 a=sx.loads(path.read_text());s=next(s for s in children(a,'symbol')if child(s,'property')[2]=='C101');pr={q[1]:q for q in children(s,'property')}
 for k,v in CHOICE.items():
  if k in pr:pr[k][2]=v
  else:s.append(node('property',k,v,node('at',*child(s,'at')[1:]),effects(hide=True)))
 save(path,a)
 (OUT/'local-input-cap-change.json').write_text(json.dumps({'part':CHOICE,'TI_source':'sources/bq25895.txt pin1 description: place1uF close toVBUS/PGND','manufacturer_characterization':'capacitor-research/C0603C105K4RACTU.pdf','replaced':'C2012X7R1E105K125AB0805','PMID_bulk_preserved':'C102 C3225X7R1C226M250AC22uF1210','SYS_bulk_preserved':['C104','C105'],'physical_tests_performed':False,'supplier_orderability_quote_pending':True},indent=2)+'\n')
if __name__=='__main__':run()
