"""Targeted reviewed SYS bypass / diagnostic change. Never regenerates whole boards."""
from pathlib import Path
import sys,json,shutil,copy
sys.path.insert(0,str(Path(__file__).resolve().parents[2]/'tools'))
from analyzer_sheet import *
OUT=Path(__file__).resolve().parent

def run():
 path=P/'Charging.kicad_sch';back=OUT/'before-charger-bypass';back.mkdir(exist_ok=True)
 if not(back/path.name).exists():shutil.copy2(path,back/path.name)
 a=sx.loads(path.read_text());refs={child(z,'property')[2] for z in children(a,'symbol')};assert 'C108'not in refs
 remove={'05c3ab87-9893-43d9-8010-1f5acd133c35','331c2fa9-5ce1-4c21-9c00-55175e8a4f9f','ce10bbac-cf0e-4c2e-8839-70716b0e8ba1','b261ce54-93ab-4302-9d77-5c9d16ec5753','be05da7b-f51e-4340-a66c-7170b4bd81f6'}
 a=[n for n in a if not(isinstance(n,list)and((tag(n)=='symbol'and child(n,'property')[2]in['D101','R106'])or(child(n,'uuid')and child(n,'uuid')[1]in remove)))]
 for n in children(a,'text'):
  if n[1].startswith('D101 lights'):
   n[1]='C108 supplements the retained C104/C105 SYS bulk.\nTP1013 exposes charger STAT on the board rear.\nR107 pulls charger/permission feedback up to 3.3 V.'
 s=Sheet('Charging',2,'');s.a=a
 sy=s.add('Device:C','C108','4.7u / 16V X5R / 10%',330.2,177.8,{1:'VSYS',2:'GND'},footprint='Capacitor_SMD:C_0603_1608Metric',field_at=(338.455,171.45),properties={'MPN':'C1608X5R1C475K080AC','Manufacturer':'TDK','Maximum_body_height_mm':'.9','Effective_capacitance_review':'Supplementary local bypass only; conservative engineering ~0.97uF at5.5V from typical-bias assumption; not replacement for C104+C105 bulk','Purpose':'Short SYS-to-ground high-frequency bypass beside BQ25895; internal optional LED removed for this placement'})
 next(q for q in children(sy,'property')if q[1]=='Datasheet')[2]='https://product.tdk.com/en/search/capacitor/ceramic/mlcc/info?part_no=C1608X5R1C475K080AC'
 sy=s.add('Connector:TestPoint','TP1013','CHG_STAT_N',302.26,177.8,{1:'CHG_STAT_N'},footprint='Trimix_Power:TestPoint_Pad_D0.8mm',autowire=False,field_at=(281.94,184.15),properties={'Access':'B.Cu: remove PCB for fine-probe access; exposed existing STAT through-via; no solder paste','Purpose':'Charger status diagnostic retained after optional LED removal'})
 xy=s.pin('TP1013',1);s.wire(xy,(xy[0],xy[1]-5.08));s.label('CHG_STAT_N',(xy[0],xy[1]-5.08),0,global_label=False)
 save(path,s.a)
 intent_path=VERIFY/'Charging-intent.json';intent=json.loads(intent_path.read_text());intent.pop('D101');intent.pop('R106');intent['C108']={'1':'VSYS','2':'GND'};intent['TP1013']={'1':'CHG_STAT_N'};intent_path.write_text(json.dumps(intent,indent=2)+'\n')
 stock=Path('/Applications/KiCad/KiCad.app/Contents/SharedSupport/footprints/TestPoint.pretty/TestPoint_Pad_D1.0mm.kicad_mod');fp=sx.loads(stock.read_text());fp[1]='TestPoint_Pad_D0.8mm'
 for q in children(fp,'pad'):child(q,'size')[1:]=[.8,.8]
 fp[:]=[n for n in fp if tag(n)not in['fp_line','fp_circle','fp_rect','fp_poly']]
 save(P/'Trimix_Power.pretty/TestPoint_Pad_D0.8mm.kicad_mod',fp)
 (OUT/'charger-bypass-change.json').write_text(json.dumps({'removed_optional':['D101','R106'],'added_bypass':'C108','retained_bulk':['C104','C105'],'new_probe':'TP1013','probe_access':'backside; board removed; no paste','no_added_carrier_pocket':True,'native_candidate_geometry_checked':True,'physical_loop_noise_and_stability_pending':True},indent=2)+'\n')
if __name__=='__main__':run()
