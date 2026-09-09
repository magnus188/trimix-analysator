"""USB-only offline design builder. Never accesses live KiCad/MCP or main PCB.
Run with ~/.codex/mcp-servers/kicad/venv/bin/python. Preserve before/ snapshot.
"""
from pathlib import Path
import sys,copy,json,shutil,math,uuid,subprocess,xml.etree.ElementTree as ET
ROOT=Path(__file__).resolve().parents[4]
sys.path.insert(0,str(ROOT/'hardware/tools'))
import analyzer_sheet as sh
from analyzer_sheet import sx, S,node,child,children,save,custom_symbol,Sheet
HERE=Path(__file__).resolve().parent
P=ROOT/'hardware/pcb/usb-input'; NAME='Trimix_USB_Input'
LIB=P/'Trimix_USB.pretty'; LIB.mkdir(exist_ok=True)
CLI='/Applications/KiCad/KiCad.app/Contents/MacOS/kicad-cli'

def schematic():
    # Redirect helper side outputs before using its constructor/finish.
    sh.P=P; sh.VERIFY=HERE; sh.PROJECT=NAME
    s=Sheet(NAME,1,'Trimix USB input | GCT + ESD + six-wire harness',
      'Dedicated 0.60 +/-0.10 mm board. Nominal 5 V input; USB-C attachment and BC1.2 detection are on the main PCB.')
    root=child(s.a,'uuid')[1]
    s.instance=lambda ref:node('instances',node('project',NAME,node('path','/'+root,node('reference',ref),node('unit',1))))
    child(child(s.a,'title_block'),'title')[1]='Trimix USB input / source and ESD interface'
    child(s.a,'title_block').append(node('comment',2,'GCT edge margin unresolved; factory assembly and physical tests pending.'))
    child(child(s.a,'title_block'),'date')[1]='2026-09-07';child(child(s.a,'title_block'),'rev')[1]='A3-USB6-ESD'
    s.box(20.32,45.72,165.1,134.62,'01  SEALED USB-C RECEPTACLE')
    s.box(193.04,45.72,205.74,134.62,'02  FOUR-LINE + VBUS ESD PROTECTION')
    s.box(20.32,190.5,165.1,76.2,'03  SIX-WIRE OUTPUT')
    s.box(193.04,190.5,205.74,55.88,'04  ASSEMBLY AND QUALIFICATION')
    nets={p:'GND' for p in ['A1','A12','B1','B12','SH']}
    nets.update({p:'USB_5V' for p in ['A4','A9','B4','B9']})
    nets.update({'A5':'USB_CC1','B5':'USB_CC2','A6':'USB_D_P','B6':'USB_D_P','A7':'USB_D_M','B7':'USB_D_M','A8':None,'B8':None})
    s.add('Connector:USB_C_Receptacle_USB2.0_16P','J901','USB4720-03-A',78.74,109.22,nets,
       footprint='Trimix_USB:USB4720_RevB',field_at=(33.02,66.04),
       properties={'Manufacturer':'GCT','MPN':'USB4720-03-A','Assembly':'USB daughterboard','Board thickness':'0.60 +/-0.10 mm','Interface':'GCT Rev B recommended lands; min0.10mm edge margin fails0.20mm general fabrication rule; no waiver'})
    cp=[(1,'CC1','passive',-12.7,10.16,0),(2,'CC2','passive',-12.7,5.08,0),(4,'D+','passive',-12.7,-5.08,0),(5,'D-','passive',-12.7,-10.16,0),(3,'GND','passive',0,-20.32,90),(8,'GND','passive',5.08,-20.32,90)]
    cp += [(n,'NC / PCB link','passive',12.7,y,180) for n,y in [(10,10.16),(9,5.08),(7,-5.08),(6,-10.16)]]
    esd=custom_symbol('TPD4E05U06_DQA',cp,bounds=(-10.16,-17.78,10.16,15.24),description='TI four independent signal ESD clamps; NC pads have no internal pass-through',datasheet='https://www.ti.com/lit/ds/symlink/tpd4e05u06.pdf');esd[1]='Trimix_USB:TPD4E05U06_DQA'
    s.add(esd[1],'U901','TPD4E05U06DQAR',259.08,111.76,{'1':'USB_CC1','2':'USB_CC2','3':'GND','4':'USB_D_P','5':'USB_D_M','6':'USB_D_M','7':'USB_D_P','8':'GND','9':'USB_CC2','10':'USB_CC1'},custom=esd,footprint='Trimix_USB:TI_DQA0010B',field_at=(218.44,68.58),properties={'Manufacturer':'Texas Instruments','MPN':'TPD4E05U06DQAR','Height max mm':'0.55','Assembly':'USB daughterboard; confirm DQA land/stencil variant with assembler'})
    diode=custom_symbol('TPD1E10B06_DYA',[(1,'VBUS','passive',-7.62,0,0),(2,'GND','passive',7.62,0,180)],bounds=(-5.08,-3.81,5.08,3.81),description='Bidirectional VBUS ESD suppression; not a 5.5V clamp or sustained OVP',datasheet='https://www.ti.com/lit/ds/symlink/tpd1e10b06.pdf');diode[1]='Trimix_USB:TPD1E10B06_DYA'
    s.add(diode[1],'D901','TPD1E10B06DYAR',350.52,99.06,{'1':'USB_5V','2':'GND'},custom=diode,footprint='Trimix_USB:TI_DYA0002A',field_at=(314.96,78.74),properties={'Manufacturer':'Texas Instruments','MPN':'TPD1E10B06DYAR','Height max mm':'0.77','Assembly':'USB daughterboard'})
    harness=custom_symbol('USB_Harness6',[(i,str(i),'passive',-5.08,-2.54*(i-1),0) for i in range(1,7)],bounds=(-2.54,1.27,2.54,-13.97),description='Six soldered wires; wire size and physical bend to be qualified');harness[1]='Trimix_USB:USB_Harness6'
    s.add(harness[1],'J902','TO MAIN J101 | SAME PIN NUMBERS',76.2,220.98,dict(zip(map(str,range(1,7)),['USB_5V','GND','USB_CC1','USB_CC2','USB_D_P','USB_D_M'])),custom=harness,footprint='Trimix_USB:USB_Harness_6P_P1.8mm',field_at=(29.21,207.01),properties={'Assembly':'Soldered harness supplied separately','Wire recommendation':'Power24AWG; signals28AWG. Actual insulated bundle, solder height and strain relief pending.'})
    for c in children(s.a,'symbol'):
      pr={v[1]:v for v in children(c,'property')}
      if pr['Reference'][2]=='J901':pr['Datasheet'][2]='https://gct.co/files/drawings/usb4720.pdf'
    s.text('Shield and all ground contacts join GND.\nA6/B6 join D+; A7/B7 join D-. SBU is NC.\nNo local Rd: TUSB320LAI on main PCB supplies Rd.',26.67,157.48,1.143)
    s.text('No internal links on pins6/7/9/10. PCB copper joins\n1-10(CC1),2-9(CC2),4-7(D+),5-6(D-).\nD901 surge clamp exceeds 6 V: upstream transient\ncoordination remains a main-system requirement.',304.8,119.38,1.143)
    s.text('1 = USB_5V   2 = GND\n3 = CC1       4 = CC2\n5 = D+        6 = D-\nDo not swap CC/data wires or populate old Rd.',104.14,223.52,1.143)
    s.text('GCT Rev B cutout and fixed connector pose retained.\nNo copper-edge exception rule;0.10mm GCT edge margin needs closure.\nFactory stencil/reflow for U901; support the port internally.\nMeasure harness/solder height inside the 5.7 mm gap.\nNo 9/12/20 V request; tests required for both cable orientations,\nsource change, hot plug, overcurrent and assembled-port ESD.',199.39,208.28,1.143)
    s.a.append(node('sheet_instances',node('path','/',node('page','1'))))
    s.finish()
    # Local symbol library, standalone and integration fragments share definitions.
    syms=copy.deepcopy(children(child(s.a,'lib_symbols'),'symbol'))
    local=[]
    for x in syms:
      if x[1].startswith('Trimix_USB:'):x[1]=x[1].split(':')[1];local.append(x)
    save(P/'Trimix_USB.kicad_sym',node('kicad_symbol_lib',node('version',20241209),node('generator','eeschema'),*local))
    save(P/'sym-lib-table',node('sym_lib_table',node('version',7),node('lib',node('name','Trimix_USB'),node('type','KiCad'),node('uri','${KIPRJMOD}/Trimix_USB.kicad_sym'),node('options',''),node('descr','USB daughterboard exact pin functions'))))
    # Main owner applies this replacement hierarchy file, adapting root/project path.
    main=copy.deepcopy(s.a);mainroot=sh.ROOT_UUID;sheetid=sh.sheet_uuid('USB_Input')
    child(main,'uuid')[1]=sheetid
    main[:]=[n for n in main if sh.tag(n)!='sheet_instances']
    for x in children(main,'symbol'):
      child(x,'on_board')[1]=S('no');props={p[1]:p for p in children(x,'property')}; ref=props['Reference'][2]
      child(x,'in_bom')[1]=S('no')
      x[:]=[n for n in x if sh.tag(n)!='instances'];x.append(node('instances',node('project','Trimix_Analyzer',node('path','/'+mainroot+'/'+sheetid,node('reference',ref),node('unit',1)))))
    save(HERE/'USB_Input-integration.kicad_sch',main)
    subprocess.run([CLI,'sch','export','netlist','--format','kicadxml','-o',str(HERE/'usb-netlist.xml'),str(s.path)],check=True)


def footprints():
    source=ROOT/'hardware/pcb/analyzer/Trimix_Connectors.pretty/USB_C_GCT_USB4720-03-A_A3.kicad_mod'
    a=sx.loads(source.read_text());a[1]='USB4720_RevB'
    child(a,'descr')[1]='GCT Rev B recommended lands unchanged; native cutout/pose retained.0.10mm minimum copper-edge margin conflicts with0.20mm general fabrication process. Supplier/assembler-approved geometry or suitable fabrication process required.'
    save(LIB/'USB4720_RevB.kicad_mod',a)
    shutil.copy2(ROOT/'hardware/pcb/analyzer/Trimix_Power.pretty/USB_Harness_6P_P1.8mm.kicad_mod',LIB/'USB_Harness_6P_P1.8mm.kicad_mod')
    def base(name,desc,body,court):
      a=node('footprint',name,node('version',20260206),node('generator','pcbnew'),node('layer','F.Cu'),node('descr',desc),node('attr',S('smd')))
      for label,value,y,layer in [('Reference','REF**',-2,'F.SilkS'),('Value',name,2,'F.Fab')]:a.append(node('property',label,value,node('at',0,y),node('layer',layer),node('effects',node('font',node('size',.8,.8),node('thickness',.1)))))
      for dims,layer,width in [(body,'F.Fab',.1),(court,'F.CrtYd',.05)]:a.append(node('fp_rect',node('start',-dims[0]/2,-dims[1]/2),node('end',dims[0]/2,dims[1]/2),node('stroke',node('width',width),node('type',S('solid'))),node('fill',S('none')),node('layer',layer)))
      return a
    def pad(a,n,x,y,w,h,paste=True):
      a.append(node('pad',str(n),S('smd'),S('roundrect'),node('at',x,y),node('size',w,h),node('layers','F.Cu',*(['F.Paste'] if paste else []),'F.Mask'),node('roundrect_rratio',min(.05/min(w,h),.25))))
    a=base('TI_DQA0010B','TI4230307/A12-2023land example:0.835mmrow pitch,0.5mmpin pitch. Joined3/8groundbar; optionalcentralviaomitted, externalpairedgroundvias. ConfirmquotedDQAvariant/stencil.',(1.1,2.6),(1.9,3.1))
    for i in range(1,6):pad(a,i,-.4175,(i-3)*.5,.565,.3 if i==3 else .2)
    for i in range(6,11):pad(a,i,.4175,(8-i)*.5,.565,.3 if i==8 else .2)
    pad(a,3,0,0,.8,.4,False)
    # Central ground paste matchesBexample, not a fabricated internal signal bridge.
    a.append(node('fp_rect',node('start',-.3,-.2),node('end',.3,.2),node('stroke',node('width',0),node('type',S('solid'))),node('fill',S('solid')),node('layer','F.Paste')))
    a.append(node('model','${KIPRJMOD}/Trimix_USB.3dshapes/USON-10_2.5x1.0mm_P0.5mm.step',node('offset',node('xyz',0,0,0)),node('scale',node('xyz',1,1,1)),node('rotate',node('xyz',0,0,0))))
    save(LIB/'TI_DQA0010B.kicad_mod',a)
    a=base('TI_DYA0002A','TI4224978/B09-2021SOD523landexample:2x0.67x0.40pads1.48mmpitch;0.77mmmaxheight.',(1.7,1.15),(2.65,1.65))
    pad(a,1,-.74,0,.67,.4);pad(a,2,.74,0,.67,.4)
    a.append(node('model','${KIPRJMOD}/Trimix_USB.3dshapes/D_SOD-523.step',node('offset',node('xyz',0,0,0)),node('scale',node('xyz',1,1,1)),node('rotate',node('xyz',0,0,0))))
    save(LIB/'TI_DYA0002A.kicad_mod',a)
    save(P/'fp-lib-table',node('fp_lib_table',node('version',7),node('lib',node('name','Trimix_USB'),node('type','KiCad'),node('uri','${KIPRJMOD}/Trimix_USB.pretty'),node('options',''),node('descr','USB-only footprints with documented drawing sources'))))

if __name__=='__main__':
    models=P/'Trimix_USB.3dshapes';models.mkdir(exist_ok=True)
    for folder,name in [('Package_SON','USON-10_2.5x1.0mm_P0.5mm.step'),('Diode_SMD','D_SOD-523.step')]:shutil.copy2(Path('/Applications/KiCad/KiCad.app/Contents/SharedSupport/3dmodels')/(folder+'.3dshapes')/name,models/name)
    footprints();schematic()
