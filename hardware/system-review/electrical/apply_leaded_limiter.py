"""Approved accessible Q1 limiter package and compact internal service switch."""
from pathlib import Path
import sys,copy,shutil,json
ROOT=Path(__file__).resolve().parents[3];OUT=Path(__file__).resolve().parent
sys.path.insert(0,str(ROOT/'hardware/tools'))
from analyzer_sheet import *
STOCK=Path('/Applications/KiCad/KiCad.app/Contents/SharedSupport/footprints');LIB=P/'Trimix_Power.pretty'
def props(a):return {x[1]:x for x in children(a,'property')}
def sp(s,k,v):
 p=props(s)
 if k in p:p[k][2]=v
 else:s.append(node('property',k,v,node('at',*child(s,'at')[1:]),effects(hide=True)))
def run():
 before=OUT/'before-leaded-limiter';before.mkdir(exist_ok=True)
 for path in [P/'USB_Input_Limiter.kicad_sch',P/'Charging.kicad_sch',P/'Trimix_Analyzer.kicad_sym',P/'Trimix_Analyzer.kicad_pcb']:
  dest=before/path.name
  if not dest.exists():shutil.copy2(path,dest)
 path=P/'USB_Input_Limiter.kicad_sch';a=sx.loads(path.read_text());u=next(z for z in children(a,'symbol')if props(z)['Reference'][2]=='U114');oldid=child(u,'lib_id')[1];newid='Trimix_Analyzer:TPS22950_Q1_DDC'
 if oldid!=newid:
  lib=next(z for z in children(child(a,'lib_symbols'),'symbol')if z[1]==oldid);new=copy.deepcopy(lib);new[1]=newid
  mapping={'A1':'1','B1':'2','C1':'3','C2':'4','B2':'5','A2':'6'}
  for unit in children(new,'symbol'):
   unit[1]=unit[1].replace('TPS22950_YBH','TPS22950_Q1_DDC')
   for pin in children(unit,'pin'):child(pin,'number')[1]=mapping[child(pin,'number')[1]]
  child(a,'lib_symbols').append(new);child(u,'lib_id')[1]=newid
  for pin in children(u,'pin'):pin[1]=mapping[pin[1]]
 for k,v in {'Value':'TPS22950CQDDCRQ1','MPN':'TPS22950CQDDCRQ1','Footprint':'Trimix_Power:TI_DDC0006A','Datasheet':'https://www.ti.com/lit/ds/symlink/tps22950-q1.pdf','Maximum_body_height_mm':'1.1','Assembly':'Factory SMT preferred; accessible leaded DDC6 package'}.items():sp(u,k,v)
 for t in children(a,'text'):
  t[1]=t[1].replace('TPS22950YBHR is the50mA WCSP variant. TPS22950C/L are NOT drop-in alternatives.','TPS22950CQDDCRQ1 is the qualified50mA leaded Q1 variant. Industrial C/L are NOT substitutes.')
  t[1]=t[1].replace('U114:6-ball WCSP,0.4mm pitch,1.126x0.726mm maximum body,0.4mm maximum height.','U114:TI DDC0006A leaded6-pin package,0.95mm pitch,3.05mm maximum terminal span,1.1mm maximum height.')
  t[1]=t[1].replace('Use TI YBH0006-C02 lands and a qualified factory stencil/assembly process; do not substitute a SOT part.','Use TI DDC0006A lands. Only the exact Q1 part retains the50mA range; do not substitute industrial TPS22950C.')
  t[1]=t[1].replace('Input1uF capacitor close to VIN.','Input C114 is4.7uF16V close to VIN; its effective capacitance and raw-input inrush are reviewed.')
 save(path,a)
 path=P/'Charging.kicad_sch';a=sx.loads(path.read_text());sw=next(z for z in children(a,'symbol')if props(z)['Reference'][2]=='SW101')
 for k,v in {'Value':'BQ service wake / B3U-1000P','MPN':'B3U-1000P','Manufacturer':'Omron','Footprint':'Button_Switch_SMD:SW_SPST_B3U-1000P','Datasheet':'https://components.omron.com/us-en/system/files/2023-01/datasheet_pdf/A162-E1.pdf','Maximum_body_height_mm':'1.75','Assembly':'Internal service switch; top actuation with nonconductive tool after rear access'}.items():sp(sw,k,v)
 save(path,a)
 # Exact DDC land dimensions from TI4214841/E08/2024; footprint properties/models are explicit.
 fp=sx.loads((STOCK/'Package_TO_SOT_SMD.pretty/SOT-23-6.kicad_mod').read_text());fp[1]='TI_DDC0006A';child(fp,'descr')[1]='TI DDC0006A4214841/E; pads1.1x0.6mm,x+/-1.35mm,y-0.95/0/+0.95;maxheight1.1mm;Q1 exactpart only for50mA.'
 for pad in children(fp,'pad'):
  no=int(pad[1]);x=-1.35 if no<=3 else 1.35;y={1:-.95,2:0,3:.95,4:.95,5:0,6:-.95}[no];child(pad,'at')[1:]=[x,y];child(pad,'size')[1:]=[1.1,.6]
 save(LIB/'TI_DDC0006A.kicad_mod',fp)
 # Keep the deliberate silk simplification reproducible in the library, not a mismatched cache.
 fp=sx.loads((STOCK/'Package_SO.pretty/VSSOP-8_2.3x2mm_P0.5mm.kicad_mod').read_text());fp[1]='TI_DCU8_CompactSilk'
 for z in list(children(fp,'fp_poly')):
  if child(z,'layer')[1]=='F.SilkS':fp.remove(z)
 save(LIB/'TI_DCU8_CompactSilk.kicad_mod',fp)
 path=P/'Carbon_Monoxide.kicad_sch';a=sx.loads(path.read_text());u=next(z for z in children(a,'symbol')if props(z)['Reference'][2]=='U703');sp(u,'Footprint','Trimix_Power:TI_DCU8_CompactSilk');save(path,a)
 path=P/'Trimix_Analyzer.kicad_sym';a=sx.loads(path.read_text());sl=sx.loads((P/'USB_Input_Limiter.kicad_sch').read_text());new=copy.deepcopy(next(z for z in children(child(sl,'lib_symbols'),'symbol')if z[1]==newid));new[1]=newid.split(':')[1]
 if not any(z[1]==new[1]for z in children(a,'symbol')):a.append(new);save(path,a)
 (OUT/'leaded-limiter-change.json').write_text(json.dumps({'U114':'TPS22950CQDDCRQ1,notindustrialC;50mA table verifiedindependently','SW101':'B3U-1000P;3x2.5body,1.75maxactuatorheight;10uAat1Vminimumloadreference','approved_by_root':True,'layout_update_pending':True,'physical_tests':False},indent=2)+'\n')
if __name__=='__main__':run()
