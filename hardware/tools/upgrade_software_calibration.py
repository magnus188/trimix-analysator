#!/usr/bin/env python3
"""Surgically upgrade the current sensor sheets, preserving later project edits.

Run with the KiCad MCP Python environment (sexpdata). This is intentionally not
a blanket regeneration: connector fields, symbol UUIDs, other sheets and all
test points are retained. A second run checks the applied marker and exits.
"""
from pathlib import Path
import copy, hashlib, json, subprocess
from analyzer_sheet import *
from build_analyzer_sensors import Sheet as SensorSheet, adc, wire_pin
from sensor_calibration_parts import *

OUT=HW/'pcb/integration/verification/software-calibration'
BEFORE=OUT/'before-schematic'

def digest(path):return hashlib.sha256(Path(path).read_bytes()).hexdigest()
def props(symbol):return {p[1]:p[2] for p in children(symbol,'property')}
def symbol(a,ref):return next(s for s in children(a,'symbol') if props(s).get('Reference')==ref)
def point(x):return tuple(round(float(v),5) for v in x)
def wire_ends(w):return [point(p[1:]) for p in children(child(w,'pts'),'xy')]

def old_adc_stubs(a,ref):
    s=symbol(a,ref);x,y,angle=child(s,'at')[1:]
    assert angle==0 and props(s)['Value'] in {'ADS1115IDGS','ADS122C04IPWR'}
    lib=next(v for v in children(child(a,'lib_symbols'),'symbol') if v[1]==child(s,'lib_id')[1])
    remove={id(s)}
    for unit in children(lib,'symbol'):
        for pin in children(unit,'pin'):
            at=child(pin,'at');xy=point((x+at[1],y-at[2]))
            noc=[n for n in children(a,'no_connect') if point(child(n,'at')[1:])==xy]
            if noc:
                assert len(noc)==1;remove.add(id(noc[0]));continue
            wires=[w for w in children(a,'wire') if xy in wire_ends(w)]
            assert len(wires)==1,(ref,xy,len(wires))
            w=wires[0];remove.add(id(w))
            end=next(p for p in wire_ends(w) if p!=xy)
            labels=[n for n in children(a,'global_label') if point(child(n,'at')[1:3])==end]
            assert len(labels)==1,(ref,xy,end)
            remove.add(id(labels[0]))
    a[:]=[v for v in a if id(v) not in remove]
    return s

def merge_fragment(a,s):
    libs=child(a,'lib_symbols')
    for lib in children(child(s.a,'lib_symbols'),'symbol'):
        if not any(x[1]==lib[1] for x in children(libs,'symbol')):libs.append(copy.deepcopy(lib))
    a.extend(copy.deepcopy(v) for v in s.a if tag(v) in {'symbol','wire','global_label','no_connect','junction'})

def replace_adc(a,name,ref,addr,inputs):
    old=old_adc_stubs(a,ref);x,y,_=child(old,'at')[1:]
    fragment=SensorSheet(name,5 if name=='Oxygen' else 6,'')
    adc(fragment,ref,x,y,addr,inputs)
    new=symbol(fragment.a,ref)
    child(new,'uuid')[1]=child(old,'uuid')[1]
    old_instance=child(old,'instances')
    new.remove(child(new,'instances'));new.append(copy.deepcopy(old_instance))
    # Preserve every non-replaced instance field from the actual saved sheet.
    current={p[1] for p in children(new,'property')}
    for p in children(old,'property'):
        if p[1] not in current:new.append(copy.deepcopy(p))
    for p in children(new,'property'):
        if p[1] in {'Reference','Value'}:
            child(p,'at')[1:3]=[x+20.32,y-33.02+(2.54 if p[1]=='Value' else 0)]
    merge_fragment(a,fragment)
    return fragment.intent

def replace_divider(a):
    delete={'RV501','R502','R503'}
    def branch(p):return 40<=p[0]<=100 and 155<=p[1]<=235
    remove=[]
    for v in a:
        t=tag(v)
        if t=='symbol' and props(v).get('Reference') in delete:remove.append(v)
        elif t=='wire' and all(branch(p) for p in wire_ends(v)):remove.append(v)
        elif t in {'global_label','junction'} and branch(point(child(v,'at')[1:3])):remove.append(v)
    assert {props(v)['Reference'] for v in remove if tag(v)=='symbol'}==delete
    for v in remove:a.remove(v)
    f=SensorSheet('Helium',6,'')
    f.add('Trimix_Analyzer:ACAS0606_2R_MATCHED','RN501','2x2k / 1:1 matched',
          66.04,196.85,{'1':'HE_3V0','4':'HE_REF','2':'HE_REF','3':'GND'},
          custom=divider_symbol(),footprint=RN_FP,autowire=False,
          field_at=(24.13,171.45),properties=divider_properties())
    wire_pin(f,'RN501',1,(66.04,161.29),(44.45,161.29));f.label('HE_3V0',(44.45,161.29),180)
    wire_pin(f,'RN501',3,(66.04,233.68),(44.45,233.68));f.label('GND',(44.45,233.68),180)
    wire_pin(f,'RN501',4,(88.9,191.77),(88.9,196.85))
    wire_pin(f,'RN501',2,(88.9,201.93),(88.9,196.85));f.label('HE_REF',(88.9,196.85),0)
    merge_fragment(a,f)
    return f.intent

def put_local_parts():
    p=P/'Trimix_Analyzer.kicad_sym';a=sx.loads(p.read_text())
    for part in [adc_symbol(),divider_symbol()]:
        part[1]=part[1].split(':',1)[1]
        assert not any(s[1]==part[1] for s in children(a,'symbol'))
        a.append(part)
    save(p,a)
    fpdir=P/'Trimix_Analog.pretty';fpdir.mkdir(exist_ok=True)
    lines=['(footprint "Vishay_ACAS0606_AT_IEC" (version 20260101) (generator "pcbnew") (layer "F.Cu")',
      ' (descr "Vishay ACAS 0606 AT; IEC pads from doc28950 Rev12-Jul-2022; body from doc28770 Rev15-Jun-2026; isolated 1-4 and2-3")',
      ' (tags "matched resistor array 2x2k 0606") (attr smd)',
      ' (property "Reference" "RN**" (at 0 -1.45) (layer "F.SilkS") (effects (font (size 1 1) (thickness 0.15))))',
      ' (property "Value" "ACASN2001U2001P1AT" (at 0 1.45) (layer "F.Fab") (effects (font (size 1 1) (thickness 0.15))))']
    for layer,x,y,width in [('F.Fab',.75,.8,.10),('F.CrtYd',1.25,1.15,.05)]:
        lines.append(f' (fp_rect (start {-x} {-y}) (end {x} {y}) (stroke (width {width}) (type default)) (layer "{layer}"))')
    lines.append(' (fp_line (start -.75 -.5) (end -.45 -.8) (stroke (width .1) (type default)) (layer "F.Fab"))')
    for n,x,y in [(1,-.65,-.5),(2,-.65,.5),(3,.65,.5),(4,.65,-.5)]:
        lines.append(f' (pad "{n}" smd rect (at {x} {y}) (size .70 .65) (layers "F.Cu" "F.Paste" "F.Mask"))')
    lines.append(' (model "${KIPRJMOD}/Trimix_Analog.3dshapes/Vishay_ACAS0606_AT.step" (offset (xyz 0 0 0)) (scale (xyz 1 1 1)) (rotate (xyz 0 0 0)))\n)')
    (fpdir/'Vishay_ACAS0606_AT_IEC.kicad_mod').write_text('\n'.join(lines)+'\n')
    p=P/'fp-lib-table';a=sx.loads(p.read_text())
    assert not any(child(v,'name')[1]=='Trimix_Analog' for v in children(a,'lib'))
    a.append(node('lib',node('name','Trimix_Analog'),node('type','KiCad'),node('uri','${KIPRJMOD}/Trimix_Analog.pretty'),node('options',''),node('descr','Datasheet-defined analog sensor parts')))
    save(p,a)

def run():
    OUT.mkdir(parents=True,exist_ok=True)
    current=sx.loads((P/'Oxygen.kicad_sch').read_text())
    if props(symbol(current,'U401'))['Value']=='ADS122C04IPWR':
        raise SystemExit('Already upgraded. Use saved receipts and native checks; do not regenerate live sheets.')
    BEFORE.mkdir(exist_ok=True)
    guarded=list(P.glob('*.kicad_sch'))+[P/'Trimix_Analyzer.kicad_sym',P/'fp-lib-table',P/'sym-lib-table',P/'Trimix_Analyzer.kicad_pro']
    hashes={str(p.relative_to(HW)):digest(p) for p in guarded}
    for p in guarded:
        dest=BEFORE/p.name
        assert not dest.exists(),dest
        dest.write_bytes(p.read_bytes())
    # Generator was edited separately in this change. Its tracked base is the
    # initial generator; preserve that version rather than post-edit content.
    previous=subprocess.check_output(['git','show','HEAD:hardware/tools/build_analyzer_sensors.py'])
    (BEFORE/'build_analyzer_sensors.py').write_bytes(previous)
    (BEFORE/'guard-hashes.json').write_text(json.dumps(hashes,indent=2)+'\n')
    intent={}
    text_changes={
      '3  |  DIFFERENTIAL ADC - I2C 0x48':'3  |  24-BIT DIFFERENTIAL ADC - I2C 0x40',
      '4  |  DIFFERENTIAL ADC - I2C 0x49':'4  |  24-BIT DIFFERENTIAL ADC - I2C 0x41',
      'Place C407 at U401 VDD/GND. I2C pull-ups are on the host sheet.':'C407: AVDD/AVSS; C408: DVDD/DGND. Place at their supply pins.',
      'AIN0-AIN1 = O2 A; AIN2-AIN3 = O2 B.\nStart at +/-0.256 V and 8 SPS; keep signed readings.\nOne ADC multiplexes the pairs; they are not simultaneous.':'AIN0-AIN1 = O2 A; AIN2-AIN3 = O2 B.\nInternal 2.048 V reference; 20 SPS normal; signed data.\nStart oxygen gain 8, PGA ON; verify headroom before use.\nIDAC and burn-out currents OFF. Pairs are multiplexed.',
      'Reference branch: 2k + 500R trim + 2k across the same 3 V.\nAdjust near air balance; record signed offset and span during calibration.\nHE_EXC_DIV = board excitation / 2; it does not sense remote cable drop.':'RN501: matched 2k + 2k; HE_REF = excitation / 2 (1.5 V nominal).\nNo manual trim. Store signed zero and span/curve with known gases.\nHE_EXC_DIV stays separate; it does not sense remote cable drop.',
      'AIN0-AIN1 = REF-SENSE. Start at +/-2.048 V.\nAIN2 = excitation / 2; AIN3 = O2 mid-supply bias.\nValidate zero/span with known O2/He mixes and\ncontrolled temperature, humidity, pressure and flow.':'REF-SENSE: gain 1, PGA bypass; +/-2.048 V.\n20 SPS normal; IDAC/burn-out OFF; signed data.\nAIN2 = excitation / 2; AIN3 = O2 bias.\nC508: AVDD/AVSS; C509: DVDD/DGND.\nKnown gases + controlled T/RH/pressure/flow.'}
    for name,ref,addr,inputs in [('Oxygen','U401','GND',['O2_A_AIN_P','O2_A_AIN_N','O2_B_AIN_P','O2_B_AIN_N']),('Helium','U502','HOST_3V3',['HE_AIN_P','HE_AIN_N','HE_EXC_DIV','O2_VMID'])]:
        p=P/(name+'.kicad_sch');a=sx.loads(p.read_text())
        intent.update(replace_adc(a,name,ref,addr,inputs))
        if name=='Helium':intent.update(replace_divider(a))
        libs=child(a,'lib_symbols')
        used={child(s,'lib_id')[1] for s in children(a,'symbol')}
        libs[:]=[v for v in libs if tag(v)!='symbol' or v[1] in used]
        for v in children(a,'text'):
            if v[1] in text_changes:v[1]=text_changes[v[1]]
        save(p,a)
    p=P/'Trimix_Analyzer.kicad_sch';a=sx.loads(p.read_text())
    for v in children(a,'text'):
        v[1]=v[1].replace('One ADS1115, two differential channels','ADS122C04: two differential channels').replace('Regulated 3.0 V excitation + ADS1115','3.0 V excitation + fixed reference + ADS122C04')
    save(p,a)
    put_local_parts()
    receipt={'changed_refs':['U401','U502'],'deleted_refs':['RV501','R502','R503'],'new_refs':['RN501'],
      'expected_new_pin_nets':intent,'PW_pin_names':PW_PIN_NAMES,
      'after_source_sha256':{str(p.relative_to(HW)):digest(p) for p in guarded},
      'sources':[ADS_DS,RN_DS,RN_LAND_DS],
      'limits':['No gas bench measurements performed','ADC configuration is a firmware contract, not an automatic hardware setting','Manufacturer order code is selected; distributor stock and lead time unconfirmed']}
    (OUT/'schematic-upgrade-intent.json').write_text(json.dumps(receipt,indent=2)+'\n')
    print(json.dumps(receipt,indent=2))

if __name__=='__main__':run()
