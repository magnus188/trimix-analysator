"""Wire the approved USB source-control sheet into the existing design.

Existing connector pin1/pin2 schematic endpoints and UUIDs are preserved.
The USB harness gains CC1,CC2,D+,D-. BQ25895 D+/D- remain deliberately NC.
"""
from pathlib import Path
import sys,copy,math,shutil,json
ROOT=Path(__file__).resolve().parents[3]
sys.path.insert(0,str(ROOT/'hardware/tools'))
from analyzer_sheet import *
from build_usb_source_review import source_sheet,USB_SHEET
OUT=Path(__file__).resolve().parent
FP='Trimix_Power:USB_Harness_6P_P1.8mm'

def props(s):return {p[1]:p for p in children(s,'property')}
def inst(a,ref):return next(s for s in children(a,'symbol') if props(s)['Reference'][2]==ref)
def owner(a,name):
    s=Sheet(name,12,'');s.a=a;return s

def extend_connector(a,ref,name):
    part=inst(a,ref);x,y,angle=child(part,'at')[1:]
    if child(part,'lib_id')[1]=='Trimix_Analyzer:USB_Harness6':return
    oldlib=next(l for l in children(child(a,'lib_symbols'),'symbol') if l[1]==child(part,'lib_id')[1])
    oldpins={child(p,'number')[1]:child(p,'at')[1:3] for u in children(oldlib,'symbol') for p in children(u,'pin')}
    assert oldpins=={'1':[-5.08,0],'2':[-5.08,-2.54]},oldpins
    lib=custom_symbol('USB_Harness6',[(i,str(i),'passive',-5.08,-2.54*(i-1),0) for i in range(1,7)],bounds=(-2.54,1.27,2.54,-13.97),description='Custom six-wire power/CC/BC1.2 pigtail')
    libs=child(a,'lib_symbols')
    if not any(l[1]==lib[1] for l in children(libs,'symbol')):libs.append(lib)
    child(part,'lib_id')[1]=lib[1];props(part)['Footprint'][2]=FP
    props(part)['Value'][2]='USB HARNESS: 5V/GND/CC1/CC2/D+/D-'
    s=owner(a,name)
    for n,net in [(3,'USB_CC1'),(4,'USB_CC2'),(5,'USB_D_P'),(6,'USB_D_M')]:
        part.append(node('pin',str(n),node('uuid',uid())))
        r=math.radians(angle);px,py=-5.08,-2.54*(n-1)
        pin=(round(x+px*math.cos(r)-py*math.sin(r),5),round(y-px*math.sin(r)-py*math.cos(r),5))
        end=(round(pin[0]-5.08*math.cos(r),5),round(pin[1]+5.08*math.sin(r),5))
        s.wire(pin,end);s.label(net,end,(180+angle)%360)

def connect_usb_data(a,name):
    s=owner(a,name);part=inst(a,'J901');x,y,angle=child(part,'at')[1:]
    assert angle==0
    lib=next(l for l in children(child(a,'lib_symbols'),'symbol') if l[1]==child(part,'lib_id')[1])
    for unit in children(lib,'symbol'):
        for pin in children(unit,'pin'):
            n=child(pin,'number')[1]
            if n not in ['A6','B6','A7','B7']:continue
            px,py,pa=child(pin,'at')[1:];xy=(round(x+px,5),round(y-py,5))
            nc=[v for v in children(a,'no_connect') if tuple(child(v,'at')[1:])==xy];assert len(nc)==1,(n,xy)
            a.remove(nc[0]);end=(round(xy[0]-5.08*math.cos(math.radians(pa)),5),round(xy[1]+5.08*math.sin(math.radians(pa)),5))
            s.wire(xy,end);s.label('USB_D_P' if n.endswith('6') else 'USB_D_M',end,(pa+180)%360)
    for ref in ('R901','R902'):
        r=inst(a,ref);child(r,'dnp')[1]=S('yes');props(r)['Value'][2]='5.1k / DNP: U110 internal Rd'
    for t in children(a,'text'):
        t[1]=t[1].replace('Independent 5.1k pull-downs on CC1 and CC2','U110 supplies independent internal Rd; R901/R902 DNP')

def run(resume=False):
    rootpath=P/'Trimix_Analyzer.kicad_sch';root=sx.loads(rootpath.read_text())
    integrated=any(props(sh).get('Sheetfile',[None,None,None])[2]==USB_SHEET+'.kicad_sch' for sh in children(root,'sheet'))
    if integrated and not resume:
        raise SystemExit('USB source sheet already integrated; verify rather than duplicate.')
    before=OUT/'before-usb-source';before.mkdir(exist_ok=True)
    paths=[rootpath,P/'Charging.kicad_sch',P/'USB_Input.kicad_sch',P/'Gauge_Interface.kicad_sch',P/'Trimix_Analyzer.kicad_sym',ROOT/'hardware/pcb/usb-input/Trimix_USB_Input.kicad_sch']
    for p in paths:
        dest=before/p.name
        if p.parent.name=='usb-input':dest=before/('daughter-'+p.name)
        if resume:assert dest.exists()
        else:assert not dest.exists();shutil.copy2(p,dest)
    s=source_sheet();save(s.path,s.a)
    # Add the new page alongside the existing bottom-row test-point page.
    sh=copy.deepcopy(children(root,'sheet')[-1]);child(sh,'uuid')[1]=sheet_uuid(USB_SHEET)
    child(sh,'at')[1:]=[154.94,264.16];child(sh,'size')[1:]=[134.62,17.78]
    pr=props(sh);pr['Sheetname'][2]='11  USB SOURCE QUALIFICATION';pr['Sheetfile'][2]=USB_SHEET+'.kicad_sch'
    child(pr['Sheetname'],'at')[1:3]=[154.94,264.16];child(pr['Sheetfile'],'at')[1:3]=[154.94,281.94]
    for project in children(child(sh,'instances'),'project'):
        for p in children(project,'path'):child(p,'page')[1]='12'
    if not integrated:
        root.append(sh);drawing=owner(root,'Trimix_Analyzer');drawing.text('11  USB SOURCE QUALIFICATION',160.02,270.51,1.524,True);save(rootpath,root)
    # Make the existing ILIM net global without removing its existing connections.
    path=P/'Charging.kicad_sch';a=sx.loads(path.read_text())
    for l in children(a,'label'):
        if l[1]=='BQ_ILIM':
            l[0]=S('global_label');l.insert(2,node('shape',S('bidirectional')))
            l.append(node('property','Intersheetrefs','${INTERSHEET_REFS}',copy.deepcopy(child(l,'at')),effects(hide=True)))
    extend_connector(a,'J101','Charging');save(path,a)
    # Move the spare gauge-alert wire to the source-current authorization output.
    path=P/'Gauge_Interface.kicad_sch';a=sx.loads(path.read_text())
    for l in children(a,'global_label'):
        if l[1]=='GAUGE_ALERT_N' and child(l,'at')[1]>210:l[1]='USB_ILIM_AUTH'
    for t in children(a,'text'):t[1]=t[1].replace('GPIO50 / pin11 = gauge ALT','GPIO50 / pin11 = USB current AUTH')
    save(path,a)
    for path in [P/'USB_Input.kicad_sch',ROOT/'hardware/pcb/usb-input/Trimix_USB_Input.kicad_sch']:
        a=sx.loads(path.read_text());extend_connector(a,'J902','USB_Input');connect_usb_data(a,'USB_Input');save(path,a)
    libpath=P/'Trimix_Analyzer.kicad_sym';a=sx.loads(libpath.read_text());existing={n[1] for n in children(a,'symbol')}
    for path in [s.path,P/'Charging.kicad_sch']:
        for lib in children(child(sx.loads(path.read_text()),'lib_symbols'),'symbol'):
            if lib[1].startswith('Trimix_Analyzer:') and lib[1].split(':')[1] not in existing:
                lib[1]=lib[1].split(':')[1];a.append(lib);existing.add(lib[1])
    save(libpath,a)
    (OUT/'usb-source-change.json').write_text(json.dumps({'status':'schematic integrated; PCB, placement and export checks pending','new_I2C':{'U110':'0x47','U111':'0x5F'},
        'J301_11':'USB_ILIM_AUTH / GPIO50','GPIO52':'unused','BQ_D_plus_D_minus':'NC; no HV negotiation',
        'J101_J902_pins':{'1':'USB_5V','2':'GND','3':'USB_CC1','4':'USB_CC2','5':'USB_D_P','6':'USB_D_M'},
        'DNP':['R901','R902'],'reset':'TPS3808 VBUS/POR/CC MR -> AUP74 CLR','physical_tests_performed':False},indent=2)+'\n')

if __name__=='__main__':run(resume='--resume' in sys.argv)
