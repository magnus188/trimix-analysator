"""Replace the optional internal QON button with local service access.
The required external power button/controller is unchanged.
"""
from pathlib import Path
import sys,json,shutil
sys.path.insert(0,str(Path(__file__).resolve().parents[2]/'tools'))
from analyzer_sheet import *
OUT=Path(__file__).resolve().parent
path=P/'Charging.kicad_sch';backup=OUT/'before-qon-probe.kicad_sch'
if not backup.exists():shutil.copy2(path,backup)
a=sx.loads(path.read_text());assert any(child(n,'property')[2]=='SW101'for n in children(a,'symbol'))
rm={'4ddb58ba-0608-4469-a649-8bcfa0f4d95e','f55f8f64-0959-46f9-b052-a5bbc6fdf699','017917c1-8499-409e-baa1-c427c3712bc8'}
a=[n for n in a if not((tag(n)=='symbol'and child(n,'property')[2]=='SW101')or(isinstance(n,list)and child(n,'uuid')and child(n,'uuid')[1]in rm)or(tag(n)in['label','global_label']and child(n,'at')[1:3]==[229.87,200.66]))]
for n in children(a,'text'):
 n[1]=n[1].replace('SW101 is service wake/reset, not the front power button.','TP1014 = local QON service access; use TP1001 GND.').replace('SW101','TP1014')
s=Sheet('Charging',2,'');s.a=a;sy=s.add('Connector:TestPoint','TP1014','QON SERVICE',218.44,200.66,{1:'BQ_QON_N'},footprint='Trimix_Power:TestPoint_Pad_D0.8mm',autowire=False,field_at=(224.79,194.31),properties={'Access':'F.Cu local fine-probe pad; ground reference TP1001; inspect fault before service reset','Purpose':'Manual BATFET ship-mode recovery / full SYS reset; external user power button unchanged','Source':'TI BQ25895 SLUSC88C pin12 / sections8.2.10.2-3; internal pull-up holds QON high','Service_limit':'USB disconnected for QON full SYS reset; 12-18s specified reset hold over TJ -10..60C; physical recovery qualification pending'})
xy=s.pin('TP1014',1);s.wire(xy,(xy[0],xy[1]-5.08));s.label('BQ_QON_N',(xy[0],xy[1]-5.08),180,global_label=False);save(path,s.a)
ip=VERIFY/'Charging-intent.json';intent=json.loads(ip.read_text());intent.pop('SW101');intent['TP1014']={'1':'BQ_QON_N'};ip.write_text(json.dumps(intent,indent=2)+'\n')
(OUT/'qon-service-change.json').write_text(json.dumps({'removed_optional':'SW101','replacement':'TP1014','ground_reference':'TP1001','external_power_button_unchanged':True,'host_firmware_never_enters_ship_mode':True,'manual_recovery_retained':True,'physical_probe_access_and_fault_recovery_pending':True,'EL13_usb_depleted_pack_recovery_still_unproven':True},indent=2)+'\n')
