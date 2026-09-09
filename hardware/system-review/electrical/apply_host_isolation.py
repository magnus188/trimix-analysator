"""Approved LM66100 host-rail reverse-current isolation, schematic stage.

Preserves purchased connector poses and every existing schematic pin except
J301.2/4, which now receive HOST_5V through U302. No global regeneration.
"""
from pathlib import Path
import sys, json, shutil
ROOT = Path(__file__).resolve().parents[3]
sys.path.insert(0,str(ROOT/'hardware/tools'))
from analyzer_sheet import *

OUT=Path(__file__).resolve().parent
DS='https://www.ti.com/lit/ds/symlink/lm66100.pdf'
def run():
    path=P/'Gauge_Interface.kicad_sch';a=sx.loads(path.read_text())
    if any(any(p[1]=='Reference' and p[2]=='U302' for p in children(x,'property')) for x in children(a,'symbol')):
        raise SystemExit('Host isolation already added; verify rather than duplicate.')
    before=OUT/'before-host-isolation';before.mkdir(exist_ok=True)
    for f in [path,P/'Trimix_Analyzer.kicad_sym',P/'Trimix_Analyzer.kicad_pcb']:
        target=before/f.name;assert not target.exists();shutil.copy2(f,target)
    for label in children(a,'global_label'):
        if label[1]=='VOUT_5V' and float(child(label,'at')[1])>210:label[1]='HOST_5V'
    s=Sheet('Gauge_Interface',4,'');s.a=a
    ic=custom_symbol('LM66100_DCK',[
        (1,'VIN','power_in',-10.16,5.08,0),(2,'GND','power_in',0,-10.16,90),
        (3,'CE','input',-10.16,0,0),(4,'NC','no_connect',10.16,0,180),
        (5,'ST','open_collector',-10.16,-5.08,0),(6,'VOUT','power_out',10.16,5.08,180)],
        bounds=(-7.62,-7.62,7.62,7.62),description='1.5A ideal diode; CE tied to VOUT enables reverse-current blocking',datasheet=DS)
    s.add('Trimix_Analyzer:LM66100_DCK','U302','LM66100DCKR',83.82,242.57,
        {1:'VOUT_5V',2:'GND',3:'HOST_5V',4:None,5:'GND',6:'HOST_5V'},
        footprint='Package_TO_SOT_SMD:SOT-363_SC-70-6',custom=ic,field_at=(71.12,224.79),
        properties={'Manufacturer':'Texas Instruments','MPN':'LM66100DCKR','Primary_datasheet':DS,
                    'Purpose':'Blocks Guition USB-powered 5V rail from feeding our buck-boost output'})
    for ref,x,net in [('C302',137.16,'VOUT_5V'),('C303',172.72,'HOST_5V')]:
        s.add('Device:C',ref,'4.7u / 16V X5R',x,242.57,{1:net,2:'GND'},
            footprint='Capacitor_SMD:C_0603_1608Metric',properties={'Manufacturer':'TDK','MPN':'C1608X5R1C475K080AC'})
    s.a.append(node('rectangle',node('start',20.32,217.17),node('end',200.66,278.13),
        node('stroke',node('width',0.254),node('type',S('default'))),node('fill',node('type',S('none'))),node('uuid',uid())))
    s.text('05  HOST 5 V REVERSE-CURRENT ISOLATION',25.4,222.25,1.27,True)
    s.text('CE = HOST_5V for reverse-current blocking. ST may be grounded.\n1.5 A path rating; verify display startup current and voltage drop.\nGuition internal charger/USB behaviour remains a separate qualification.',25.4,264.16,1.016)
    for t in children(s.a,'text'):
        t[1]=t[1].replace('5 V flows TO Guition; HOST_3V3 returns FROM its switched 3.3 V regulator.',
            'HOST_5V flows through U302 TO Guition; HOST_3V3 returns FROM its regulator.')
        t[1]=t[1].replace('charger 0x6A','charger 0x6B').replace('The firmware must add the new GPIO28/29 I2C bus; it is not implemented.',
            'GPIO28/29 I2C is implemented; physical harness and rise time remain to be tested.')
    save(path,s.a)
    libpath=P/'Trimix_Analyzer.kicad_sym';lib=sx.loads(libpath.read_text());ic[1]='LM66100_DCK';lib.append(ic);save(libpath,lib)
    (OUT/'host-isolation.json').write_text(json.dumps({'status':'schematic applied; PCB sync pending','new_refs':['U302','C302','C303'],
        'changed_existing_pins':['J301.2','J301.4'],'source':DS,'not_whole_host_backfeed_qualification':True},indent=2)+'\n')

if __name__=='__main__':run()
