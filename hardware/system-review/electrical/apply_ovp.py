"""Approved sustained-OVP stage. Prototype review, transient qualification open."""
from pathlib import Path
import sys,copy,shutil,json
ROOT=Path(__file__).resolve().parents[3];OUT=Path(__file__).resolve().parent
sys.path.insert(0,str(ROOT/'hardware/tools'))
from analyzer_sheet import *
from build_usb_source_review import box,passive
NAME='USB_Overvoltage';SRC='https://www.ti.com/lit/ds/symlink/tps25947.pdf'
def props(a):return {x[1]:x for x in children(a,'property')}
def sp(a,k,v):
 q=props(a)
 if k in q:q[k][2]=v
 else:a.append(node('property',k,v,node('at',*child(a,'at')[1:]),effects(hide=True)))
def run():
 back=OUT/'before-ovp';back.mkdir(exist_ok=True)
 for path in [P/'USB_Input_Limiter.kicad_sch',P/'USB_Source_Control.kicad_sch',P/'Trimix_Analyzer.kicad_sch',P/'Trimix_Analyzer.kicad_sym',P/'Trimix_Analyzer.kicad_pcb']:
  if not(back/path.name).exists():shutil.copy2(path,back/path.name)
 s=Sheet(NAME,14,'USB sustained overvoltage protection','Engineering prototype: DC cutoff corners checked; cable/ESD/fast surge survival is not established digitally.')
 box(s,'01  RAW USB TO PROTECTED INTERSTAGE RAIL',20.32,45.72,243.84,109.22)
 pn=[('EN/UVLO','input'),('OVLO','input'),('AUXOFF','open_collector'),('FLT','open_collector'),('IN','power_in'),('OUT','power_out'),('DVDT','passive'),('GND','power_in'),('ILM','passive'),('ITIMER','passive')]
 ps=[(i,n,t,-15.24 if i<=5 else 15.24,10.16-5.08*((i-1)%5),0 if i<=5 else 180)for i,(n,t)in enumerate(pn,1)]
 sym=custom_symbol('TPS259470_RPW',ps,bounds=(-12.7,12.7,12.7,-12.7),datasheet=SRC)
 s.add('Trimix_Analyzer:TPS259470_RPW','U115','TPS259470ARPWR',111.76,91.44,{1:'USB_OVP_UVLO',2:'USB_OVP_SET',3:'USB_CC_INT_N',4:None,5:'USB_5V',6:'USB_OVP_5V',7:'USB_OVP_DVDT',8:'GND',9:'USB_OVP_ILM',10:None},custom=sym,footprint='Trimix_Power:TI_RPW0010A',properties={'MPN':'TPS259470ARPWR','Manufacturer':'Texas Instruments','Datasheet':SRC,'Maximum_body_height_mm':'1.0','Assembly':'Factory reflow required; asymmetric HotRod RPW10 land/paste pattern'})
 passive(s,'C115','100n / 50V X7R',48.26,123.19,'USB_5V');passive(s,'C116','3.3n / 50V C0G / 5%',185.42,123.19,'USB_OVP_DVDT');passive(s,'R126','1.65k / 0.1%',233.68,123.19,'USB_OVP_ILM')
 box(s,'02  FIXED THRESHOLDS / NO FIRMWARE BOOT DEPENDENCY',276.86,45.72,124.46,180.34)
 for r,val,x,y,n1,n2 in [('R121','34k / 0.1% / 10ppm',299.72,76.2,'USB_5V','USB_OVP_UPPER'),('R122','649R / 0.1% / 10ppm',299.72,114.3,'USB_OVP_UPPER','USB_OVP_SET'),('R123','10k / 0.1% / 10ppm',299.72,152.4,'USB_OVP_SET','GND'),('R124','21.5k / 0.1% / 25ppm',370.84,76.2,'USB_5V','USB_OVP_UVLO'),('R125','10k / 0.1% / 25ppm',370.84,114.3,'USB_OVP_UVLO','GND'),('R127','10k / 1%',370.84,152.4,'USB_OVP_5V','GND')]:passive(s,r,val,x,y,n1,n2)
 s.text('R121+R122 / R123:5.254–5.490V rising\nincluding defined tolerance/TCR/aging.\nHysteresis may require unplug/replug.\nR127 discharges the protected node.\nAUXOFF clears permission on OVLO.\nFLT does NOT indicate OVLO.',281.94,180.34,1.016)
 box(s,'03  QUALIFICATION / ASSEMBLY',20.32,165.1,243.84,106.68)
 s.text('C114 on sheet13 is the shared protected-node4.7uF25V1206 capacitor.\nU114 VIN/ON and U113 SENSE divider now use USB_OVP_5V.\nNo duplicate interstage bulk: count all raw/interstage caps in USB inrush.\nAUXOFF shares CC interrupt/MR; R11133k limits pull-up load.\nThis stage prevents sustained excessive voltage after the stated cutoff.\nIt does NOT establish all-pulse survival of the6V-absolute TPS22950.\n1.2us OVLO response is typical only.2.2A surge estimate exceeds6V.\n470 OVLO recovery bypasses DVDT: qualify capacitive inrush physically.\nKeep BQ D+/D- NC and charging ARM OPEN until cells/NTC are qualified.\nUse no substitute OVLO resistor tolerance/TCR without recalculation.\nRPW10 has two central IN/OUT pads; no additional exposed-ground pad.\nSee usb-protection-research/upstream-ovp-review.md and physical checklist.',25.4,180.34,1.016)
 mp={'C115':('C1608X7R1H104K080AA','TDK','https://product.tdk.com/en/search/capacitor/ceramic/mlcc/info?part_no=C1608X7R1H104K080AA'),'C116':('C1608C0G1H332J080AA','TDK','https://product.tdk.com/en/search/capacitor/ceramic/mlcc/info?part_no=C1608C0G1H332J080AA')}
 codes={'R121':'TNPW060334K0BYEA','R122':'TNPW0603649RBYEA','R123':'TNPW060310K0BYEA','R124':'TNPW060321K5BEEA','R125':'TNPW060310K0BEEA','R126':'TNPW06031K65BEEA','R127':'RC0603FR-0710KL'}
 for r,c in codes.items():mp[r]=(c,'Vishay'if r!='R127'else'YAGEO','https://www.vishay.com/docs/28758/tnpw_e3.pdf'if r!='R127'else'https://yageogroup.com/content/datasheet/asset/file/PYU-RC_GROUP_51_ROHS_L')
 for z in children(s.a,'symbol'):
  r=props(z)['Reference'][2]
  if r in mp:
   m,mfr,ds=mp[r]
   for k,val in [('MPN',m),('Manufacturer',mfr),('Datasheet',ds),('Maximum_body_height_mm','.9'if r.startswith('C')else'.6')]:sp(z,k,val)
 save(s.path,s.a)
 for file in ['USB_Input_Limiter.kicad_sch','USB_Source_Control.kicad_sch']:
  path=P/file;a=sx.loads(path.read_text())
  if file.startswith('USB_Input'):
   for l in children(a,'global_label'):
    if l[1]=='USB_5V':l[1]='USB_OVP_5V'
   for z in children(a,'symbol'):
    if props(z)['Reference'][2]=='C114':
     for k,val in {'Value':'4.7u / 25V X7R / 10%','MPN':'C3216X7R1E475K160AC','Footprint':'Capacitor_SMD:C_1206_3216Metric','Maximum_body_height_mm':'1.8','Datasheet':'https://product.tdk.cn/system/files/dam/doc/product/capacitor/ceramic/mlcc/charasheet/c3216x7r1e475k160ac.pdf'}.items():sp(z,k,val)
   for t in children(a,'text'):t[1]=t[1].replace('Input C114 is4.7uF16V','Input C114 is4.7uF25V').replace('Input operating range1.8–5.5V;','U115 on sheet14 now protects input against sustained overvoltage. Input operating range1.8–5.5V;')
  else:
   # Only R113's high divider label changes; raw TUSB VBUS_DET resistor stays raw.
   r=next(z for z in children(a,'symbol')if props(z)['Reference'][2]=='R113');xy=child(r,'at')[1:3]
   candidates=[l for l in children(a,'global_label')if l[1]=='USB_5V'];near=min(candidates,key=lambda l:sum((a-b)**2for a,b in zip(child(l,'at')[1:3],xy)));near[1]='USB_OVP_5V'
   r=next(z for z in children(a,'symbol')if props(z)['Reference'][2]=='R111');sp(r,'Value','33k / 1%');sp(r,'MPN','RC0603FR-0733KL')
  save(path,a)
 path=P/'Trimix_Analyzer.kicad_sch';a=sx.loads(path.read_text())
 if not any(props(z).get('Sheetfile',[None,None,''])[2]==NAME+'.kicad_sch'for z in children(a,'sheet')):
  sh=copy.deepcopy(children(a,'sheet')[-1]);child(sh,'uuid')[1]=sheet_uuid(NAME);child(sh,'at')[1:]=[20.32,241.3];child(sh,'size')[1:]=[381,12.7];pr=props(sh);pr['Sheetname'][2]='13  USB OVERVOLTAGE PROTECTION';pr['Sheetfile'][2]=NAME+'.kicad_sch';child(pr['Sheetname'],'at')[1:3]=[20.32,241.3];child(pr['Sheetfile'],'at')[1:3]=[20.32,254]
  for pr in children(child(sh,'instances'),'project'):
   for z in children(pr,'path'):child(z,'page')[1]='14'
  a.append(sh);save(path,a)
 path=P/'Trimix_Analyzer.kicad_sym';a=sx.loads(path.read_text());sym[1]='TPS259470_RPW'
 if not any(z[1]==sym[1]for z in children(a,'symbol')):a.append(sym);save(path,a)
 # Manufacturer RPW0010A4225183/A land pattern, top view, exact asymmetric copper.
 fp=node('footprint','TI_RPW0010A',node('version',20241229),node('generator','pcbnew'),node('layer','F.Cu'),node('descr','TI RPW0010A4225183/A08/2019 exact example lands; top view.1.0mm maxheight. No extraEP.'),node('attr',S('smd')))
 for k,val,y,layer in [('Reference','REF**',-2,'F.SilkS'),('Value','TI_RPW0010A',2,'F.Fab')]:fp.append(node('property',k,val,node('at',0,y,0),node('layer',layer),effects(.8,hide=k=='Value')))
 for layer,size,w in [('F.Fab',1,.1),('F.CrtYd',1.45,.05)]:fp.append(node('fp_rect',node('start',-size,-size),node('end',size,size),node('stroke',node('width',w),node('type',S('solid'))),node('layer',layer)))
 def pad(no,x,y,w,h):fp.append(node('pad',str(no),S('smd'),S('roundrect'),node('at',x,y),node('size',w,h),node('layers','F.Cu','F.Paste','F.Mask'),node('roundrect_rratio',.05/min(w,h))))
 for no,x,y in [(1,-.9,-.7),(4,-.9,.7),(10,.9,-.7),(7,.9,.7)]:
  pad(no,x,y,.6,.3);pad(no,-.725 if x<0 else .725,-.875 if y<0 else .875,.25,.65)
 for no,x,y in [(2,-.9,-.225),(3,-.9,.225),(9,.9,-.225),(8,.9,.225)]:pad(no,x,y,.6,.25)
 for no,x in [(5,-.25),(6,.25)]:pad(no,x,0,.3,2.4)
 save(P/'Trimix_Power.pretty/TI_RPW0010A.kicad_mod',fp)
 (OUT/'ovp-change.json').write_text(json.dumps({'U115':'TPS259470ARPWR','protected':'USB_OVP_5V','OVLO':'(34k+649)/10k0.1%10ppm','MR_pullup':'33k1% conservative23uA leak budget','C114':'shared4.7u25V1206,notduplicatebulk','no_physical_transient_proof':True,'order_release':False},indent=2)+'\n')
if __name__=='__main__':run()
