"""Build the A2 overview and project library; audit KiCad CLI connectivity.

Run `overview` after sheet generators, then KiCad exports, then `audit`.
Does not modify the preserved P1 power design or firmware.
"""
import copy, csv, hashlib, json, sys, xml.etree.ElementTree as ET
from collections import defaultdict
from analyzer_sheet import *

PAGES=[
 ('Charging',2,'01  CHARGING + BATTERY',20.32,60.96,'BQ25895 / protected 1S2P holder\n2 x 3400 mAh = 6800 mAh nominal\nRCY/BEC pigtail + cell thermistor'),
 ('Supply_5V',3,'02  SWITCHED 5 V',147.32,60.96,'TPS63020 buck-boost\nPowers Guition and gas sensors\nBattery assists when USB power is limited'),
 ('Gauge_Interface',4,'03  GUITION + FUEL GAUGE',274.32,60.96,'MAX17048 + JP1 host harness\nSeparate 100 kHz sensor I2C bus\nUART + shutdown / enable signals'),
 ('Oxygen',5,'04  TWO OXYGEN INPUTS',20.32,124.46,'AO2 cable + insulated SMB coax\nOne ADS1115, two differential channels\nIndependent calibration; sequential reads'),
 ('Helium',6,'05  HELIUM BRIDGE',147.32,124.46,'MD62 thermal-conductivity bridge\nRegulated 3.0 V excitation + ADS1115\nKnown-gas calibration required'),
 ('Environment',7,'06  GAS-CHAMBER CLIMATE',274.32,124.46,'Wired GYBMEP / BME280 module\nTemperature, pressure and humidity\nVerify BME chip ID and module voltage'),
 ('Carbon_Monoxide',8,'07  EXPERIMENTAL CO',20.32,187.96,'Wired ZE07-CO + translated UART\nDedicated supply with voltage margin\nNot a breathing-gas safety clearance'),
 ('Power_Control',9,'08  PUSH-BUTTON ON / OFF',147.32,187.96,'LTC2954-1 + momentary 1NO button\nSave state, then switch off the 5 V rail\nHeld button provides forced shutdown'),
 ('USB_Input',10,'09  USB-A + USB-C INPUT',274.32,187.96,'GCT USB4720 + two CC resistors\nSeparate 0.60 mm USB daughterboard\n5 V input from USB-A or USB-C'),
]

def overview():
    s=Sheet('Trimix_Analyzer',1,'Trimix analyser — system overview',
       'A2.2 engineering review  /  Double-click a numbered block to open its circuit page.')
    child(s.a,'uuid')[1]=ROOT_UUID
    child(child(s.a,'title_block'),'rev')[1]='A2.2'
    child(child(s.a,'title_block'),'date')[1]='2026-09-06'
    for name,page,title,x,y,description in PAGES:
        sh=node('sheet',node('at',x,y),node('size',116.84,48.26),node('fields_autoplaced',S('yes')),
          node('stroke',node('width',0.381),node('type',S('default'))),node('fill',node('color',0,0,0,0)),node('uuid',sheet_uuid(name)))
        for key,val,yy in [('Sheet name',title,y),('Sheet file',name+'.kicad_sch',y+48.26)]:
            sh.append(node('property',key,val,node('at',x,yy,0),effects(1.27,'left',hide=True)))
        sh.append(node('instances',node('project',PROJECT,node('path','/'+ROOT_UUID,node('page',str(page))))))
        s.a.append(sh);s.text(title,x+5.08,y+7.62,2.032,True);s.text(description,x+5.08,y+25.4,1.778)
    s.text('POWER FLOW',20.32,48.26,1.27,True)
    s.text('USB / protected pack  >  charger SYS  >  switched 5 V  >  Guition and sensors',64.77,48.26,1.27)
    s.text('COMMISSIONING',20.32,248.92,1.27,True)
    s.text('Charge ARM stays open until cell / holder / USB checks pass.  Guition USB must be disconnected for full shutdown.',64.77,248.92,1.143)
    s.text('Native schematic + unrouted 3D placement preview.  Connector dimensions, thermal design and gas accuracy require bench validation.',20.32,257.81,1.143)
    save(P/(PROJECT+'.kicad_sch'),s.a)
    (P/(PROJECT+'.kicad_pro')).write_text(json.dumps({'meta':{'filename':PROJECT+'.kicad_pro','version':1}},indent=2)+'\n')
    symbols={}
    for path in P.glob('*.kicad_sch'):
        a=sx.loads(path.read_text());ls=child(a,'lib_symbols')
        if not ls:continue
        for sym in children(ls,'symbol'):
            if not sym[1].startswith('Trimix_Analyzer:'):continue
            value=copy.deepcopy(sym);value[1]=value[1].split(':',1)[1]
            if value[1] in symbols:assert symbols[value[1]]==value,(path,value[1],'conflicting custom symbols')
            symbols[value[1]]=value
    save(P/'Trimix_Analyzer.kicad_sym',node('kicad_symbol_lib',node('version',20241209),node('generator','kicad_symbol_editor'),*symbols.values()))
    (P/'sym-lib-table').write_text('(sym_lib_table (version 7)\n (lib (name "Trimix_Power") (type "KiCad") (uri "${KIPRJMOD}/Trimix_Power.kicad_sym") (options "") (descr "Preserved P1 power symbols"))\n (lib (name "Trimix_Analyzer") (type "KiCad") (uri "${KIPRJMOD}/Trimix_Analyzer.kicad_sym") (options "") (descr "A2 datasheet pin-mapped review symbols")))\n')
    print('Overview and project symbol library saved.')

def audit():
    intent={name:json.loads((VERIFY/(name+'-intent.json')).read_text()) for name,*_ in PAGES}
    (VERIFY/'intended-nets.json').write_text(json.dumps(intent,indent=2)+'\n')
    root=ET.parse(VERIFY/(PROJECT+'-netlist.xml')).getroot()
    expected=defaultdict(set);nc=set();refs=set()
    for page,parts in intent.items():
        for ref,pins in parts.items():
            if ref.startswith('#'):continue
            assert ref not in refs,(ref,'duplicate reference');refs.add(ref)
            for pin,net in pins.items():(nc if net is None else expected[net]).add((ref,str(pin)))
    by_pin={}
    for net in root.findall('./nets/net'):
        group={(n.attrib['ref'],n.attrib['pin']) for n in net.findall('node') if not n.attrib['ref'].startswith('#')}
        for rp in group:by_pin[rp]=(net.attrib['name'],group)
    errors=[];matches=[]
    for name,group in sorted(expected.items()):
        result=by_pin.get(next(iter(group)))
        if result is None or result[1]!=group:errors.append({'net':name,'expected':sorted(group),'actual':sorted(result[1]) if result else []})
        else:matches.append({'intended_name':name,'exported_name':result[0],'nodes':sorted(group)})
    for rp in sorted(nc):
        if rp in by_pin and by_pin[rp][1]!={rp}:errors.append({'nc_connected':rp,'actual':sorted(by_pin[rp][1])})
    allpins=set().union(*expected.values())|nc
    if set(by_pin)!=allpins:errors.append({'missing_or_extra_pins':sorted(set(by_pin)^allpins)})
    components=root.findall('./components/comp');actual_refs={c.attrib['ref'] for c in components}
    if refs!=actual_refs:errors.append({'missing_or_extra_components':sorted(refs^actual_refs)})
    footprints=[];rows=[];offboard=set()
    for comp in components:
        ref=comp.attrib['ref'];ident=comp.findtext('footprint','');pads=None
        flags={v.attrib['name'] for v in comp.findall('property')}
        if 'exclude_from_board' in flags:offboard.add(ref)
        if ident:
            lib,part=ident.split(':',1)
            local=P/(lib+'.pretty')/(part+'.kicad_mod')
            path=local if local.exists() else LIBS.parent/'footprints'/(lib+'.pretty')/(part+'.kicad_mod')
            if path.exists():
                pads={str(v[1]) for v in children(sx.loads(path.read_text()),'pad') if str(v[1])}
                pinset={p for r,p in allpins if r==ref}
                if pads!=pinset:errors.append({'footprint_pad_mismatch':ref,'pads':sorted(pads),'pins':sorted(pinset)})
            else:errors.append({'missing_footprint':ref,'path':str(path)})
        fields={f.attrib['name']:f.text for f in comp.findall('./fields/field')}
        footprints.append({'reference':ref,'footprint':ident,'pad_numbers_checked':pads is not None})
        if 'exclude_from_board' not in flags:
            rows.append([ref,comp.findtext('value',''),ident,'DNP' if 'dnp' in flags else 'FIT',fields.get('Assembly',''),fields.get('Status','')])
    erc=json.loads((VERIFY/(PROJECT+'-erc.json')).read_text());violations=[v for sheet in erc['sheets'] for v in sheet.get('violations',[])]
    if violations:errors.append({'erc_violations':len(violations)})
    report={'result':'FAIL' if errors else 'PASS','pages':len(PAGES)+1,'schematic_components':len(components),'pcb_components':len(components)-len(offboard),'offboard_modules':sorted(offboard),'connected_nets':len(expected),'schematic_pins_checked':len(allpins),'physical_pins_checked':len([rp for rp in allpins if rp[0] not in offboard]),'intentional_nc':len(nc),'erc_errors':sum(v['severity']=='error' for v in violations),'erc_warnings':sum(v['severity']=='warning' for v in violations),'ignored_checks':erc.get('ignored_checks',[]),'connections':matches,'footprints':footprints,'source_hashes':{p.name:hashlib.sha256(p.read_bytes()).hexdigest() for p in P.glob('*.kicad_sch')},'errors':errors}
    (VERIFY/'connectivity-audit.json').write_text(json.dumps(report,indent=2)+'\n')
    with (VERIFY/'pcb-bom.csv').open('w',newline='') as f:
        w=csv.writer(f);w.writerow(['reference','value','footprint','dnp','assembly','status']);w.writerows(rows)
    print(json.dumps({k:report[k] for k in ['result','pages','pcb_components','connected_nets','physical_pins_checked','intentional_nc','erc_errors','erc_warnings','errors']},indent=2))
    if errors:raise SystemExit(1)

if __name__=='__main__':
    {'overview':overview,'audit':audit}[sys.argv[1]]()
