"""Replace unsupported BQ sub500mA ILIM extrapolation with TPS22950 stage."""
from pathlib import Path
import sys,json,copy,shutil
ROOT=Path(__file__).resolve().parents[3];OUT=Path(__file__).resolve().parent
sys.path.insert(0,str(ROOT/'hardware/tools'))
from analyzer_sheet import *
from build_usb_source_review import box,passive
NAME='USB_Input_Limiter'
SRC='https://www.ti.com/lit/ds/symlink/tps22950.pdf'
def props(s):return {p[1]:p for p in children(s,'property')}
def setprop(s,k,v):
 p=props(s)
 if k in p:p[k][2]=v
 else:s.append(node('property',k,v,node('at',*child(s,'at')[1:]),effects(hide=True)))
def run():
 before=OUT/'before-input-limiter';before.mkdir(exist_ok=True)
 paths=[P/'Charging.kicad_sch',P/'USB_Source_Control.kicad_sch',P/'Trimix_Analyzer.kicad_sch',P/'Trimix_Analyzer.kicad_sym']
 for path in paths:
  dest=before/path.name
  if not dest.exists():shutil.copy2(path,dest)
 # Keep native source symbol UUIDs; change the external resistor branch net only.
 path=P/'USB_Source_Control.kicad_sch';a=sx.loads(path.read_text())
 for s in children(a,'symbol'):
  if props(s)['Reference'][2]=='R116':
   setprop(s,'Value','1k / 0.1%');setprop(s,'MPN','RT0603BRD071KL')
 for n in children(a,'global_label'):
  if n[1]=='BQ_ILIM':n[1]='USB_LIMIT_SET'
 for t in children(a,'text'):
  t[1]=t[1].replace('LOW forces <=100 mA','LOW selects nominal50mA')
  t[1]=t[1].replace('R103 4.02k remains fitted. Switched 300R branch caps worst-case <1.5 A.','U114 on sheet13 provides the input limit. R116 switches its parallel1k branch.')
 for c in children(child(a,'title_block'),'comment'):
  c[2]=c[2].replace('100 mA hardware default.','Nominal50mA external input limit. See sheet13 for qualifications.')
 save(path,a)
 path=P/'Charging.kicad_sch';a=sx.loads(path.read_text())
 for s in children(a,'symbol'):
  if props(s)['Reference'][2]=='R103':
   setprop(s,'Value','300R / 1% / supported ILIM range');setprop(s,'MPN','RC0603FR-07300RL')
 # Split the previously shared connector-to-charger wire at its verified coordinates.
 wires=[w for w in children(a,'wire') if [tuple(v[1:]) for v in child(w,'pts')[1:]]==[(50.8,86.36),(76.2,86.36)]]
 assert len(wires)==1
 child(wires[0],'pts')[2][1:]=[55.88,86.36]
 labs=[v for v in children(a,'global_label') if v[1]=='USB_5V' and child(v,'at')[1:3]==[101.6,86.36]]
 assert len(labs)==1;labs[0][1]='USB_CHG_5V'
 own=Sheet('Charging',2,'');own.a=a;own.label('USB_5V',(55.88,86.36),0)
 for t in children(a,'text'):t[1]=t[1].replace('4.02k','300R').replace('620R','300R')
 save(path,a)
 s=Sheet(NAME,13,'USB input current limiter — cold start and qualified source','Engineering draft: default50mA nominal; dynamic overshoot, startup and combined corners require bench verification.')
 box(s,'01  ALWAYS-AVAILABLE LOW-CURRENT INPUT',20.32,45.72,243.84,109.22)
 sym=custom_symbol('TPS22950_YBH',[('A1','ON','input',-15.24,10.16,0),('B1','VIN','power_in',-15.24,0,0),('C1','GND','power_in',-15.24,-10.16,0),('A2','FLT','open_collector',15.24,10.16,180),('B2','VOUT','power_out',15.24,0,180),('C2','ILIM','output',15.24,-10.16,180)],bounds=(-12.7,12.7,12.7,-12.7),datasheet=SRC)
 s.add('Trimix_Analyzer:TPS22950_YBH','U114','TPS22950YBHR',111.76,93.98,{'A1':'USB_5V','B1':'USB_5V','C1':'GND','A2':'USB_LIMIT_FAULT_N','B2':'USB_CHG_5V','C2':'USB_LIMIT_SET'},custom=sym,footprint='Trimix_Power:TPS22950_YBH6',properties={'MPN':'TPS22950YBHR','Manufacturer':'Texas Instruments','Datasheet':SRC,'Maximum_body_height_mm':'0.4','Assembly':'Factory WCSP placement and X-ray inspection required'})
 passive(s,'R119','19.2k / 0.1%',190.5,96.52,'USB_LIMIT_SET')
 passive(s,'C114','1u / 25V X7R',48.26,123.19,'USB_5V')
 c=next(z for z in children(s.a,'symbol') if props(z)['Reference'][2]=='C114');setprop(c,'Footprint','Capacitor_SMD:C_0805_2012Metric');setprop(c,'MPN','C2012X7R1E105K125AB');setprop(c,'Manufacturer','TDK')
 passive(s,'R120','10k / 1%',233.68,123.19,'HOST_3V3','USB_LIMIT_FAULT_N')
 s.text('R119 stays fitted. R116/Q110/Q111 on sheet12 add a parallel1k branch only after qualification.\nBQ25895 input capacitor C101 is downstream. BQ ILIM R103 is fixed300R; D+/D- stay NC.\nTPS22950YBHR is the50mA WCSP variant. TPS22950C/L are NOT drop-in alternatives.',25.4,139.7,1.016)
 box(s,'02  DEFAULT INPUT AND RECOVERY SEQUENCE',276.86,45.72,124.46,109.22)
 s.text('Default:34/50/66mA at19.2k in TI table.\n0.1% resistor adds finite tolerance.\nNo formula for guaranteed extrema is supplied.\nThe sizeable100mA margin is an engineering\nassessment; verify complete-board input draw.\n\nOnce cells and NTC are qualified, device OFF\nallows slow depleted-pack recovery before\npressing POWER. J104 stays OPEN now.\nFirmware cannot bootstrap from a dead pack\nwhile charge is deliberately inhibited.\n\nFLT reports thermal/reverse-current faults;\nit is not a normal current-limit flag.',281.94,60.96,1.016)
 box(s,'03  ASSEMBLY / SOURCE / TRANSIENT QUALIFICATION',20.32,165.1,381,100.33)
 s.text('U114:6-ball WCSP,0.4mm pitch,1.126x0.726mm maximum body,0.4mm maximum height.\nUse TI YBH0006-C02 lands and a qualified factory stencil/assembly process; do not substitute a SOT part.\nInput1uF capacitor close to VIN. Downstream wiring and caps must pass inrush/ringing checks with both cable orientations.\nInput operating range1.8–5.5V; autonomous high-voltage negotiation is prevented by keeping BQ D+/D- disconnected.\nCurrent-limit response5us and thermal behavior are typical values, not guaranteed zero-duration overshoot bounds.\nAt large voltage drop the switch may enter thermal retry; this limits recovery power and must be tested.\nOpen/short ILIM resistor failure behavior is unspecified and is not claimed as a safety mechanism.\nQualified current is limited by both the upstream switch and BQ setting. Firmware request1.4A does not promise1.4A output.\nBQ300R at stated KILIM range yields~1.06–1.31A with1% tolerance; verify intended operating conditions.\nAll physical tests are pending. Keep charging ARM open and use a current-limited bench supply for first bring-up.',25.4,180.34,1.016)
 save(s.path,s.a)
 path=P/'Trimix_Analyzer.kicad_sch';a=sx.loads(path.read_text())
 if not any(props(sh).get('Sheetfile',[None,None,''])[2]==NAME+'.kicad_sch' for sh in children(a,'sheet')):
  sh=copy.deepcopy(children(a,'sheet')[-1]);child(sh,'uuid')[1]=sheet_uuid(NAME);child(sh,'at')[1:]=[294.64,264.16];child(sh,'size')[1:]=[106.68,17.78]
  p=props(sh);p['Sheetname'][2]='12  USB INPUT LIMITER';p['Sheetfile'][2]=NAME+'.kicad_sch';child(p['Sheetname'],'at')[1:3]=[294.64,264.16];child(p['Sheetfile'],'at')[1:3]=[294.64,281.94]
  for pr in children(child(sh,'instances'),'project'):
   for x in children(pr,'path'):child(x,'page')[1]='13'
  a.append(sh);save(path,a)
 path=P/'Trimix_Analyzer.kicad_sym';a=sx.loads(path.read_text());sym[1]='TPS22950_YBH'
 if not any(v[1]==sym[1] for v in children(a,'symbol')):a.append(sym);save(path,a)
 (OUT/'input-limiter-change.json').write_text(json.dumps({'rejected':'BQ ILIM4.02k<500mA extrapolation unsupported by datasheet; not final current limiter','final_stage':'TPS22950YBHR19.2k0.1% plus qualified1k branch','BQ_ILIM':'300ohm1%','tests':'native topology pending export; physical current/transient/thermal pending','charging_arm':'open'},indent=2)+'\n')
if __name__=='__main__':run()
