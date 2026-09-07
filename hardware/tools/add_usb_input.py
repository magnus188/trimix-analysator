"""A2.1: explicitly model required panel-side CC termination.

Preserves existing pages and user placements. Changes Charging annotations,
adds one overview link, and restores the previously verified bus pull-up fit
state if a stale KiCad editor save restored the old DNP state.
"""
from analyzer_sheet import *
from integrate_analyzer import PAGES

def revision(a):
    tb=child(a,'title_block');child(tb,'rev')[1]='A2.1';child(tb,'date')[1]='2026-09-06'

def build_usb():
    s=Sheet('USB_Input',10,'USB input | USB-A to C and USB-C to C',
      '5 V power-sinking input. Required panel-assembly circuit; the purchased socket internals are not yet verified.')
    revision(s.a)
    s.box(20.32,48.26,226.06,114.3,'01  REQUIRED USB-C SOCKET INTERNALS')
    s.box(254,48.26,147.32,114.3,'02  EXISTING TWO-WIRE HARNESS')
    s.box(20.32,171.45,226.06,87.63,'03  CABLES, ORIENTATION & CURRENT')
    s.box(254,171.45,147.32,77.47,'04  VERIFY THE PURCHASED ASSEMBLY')
    s.add('Connector:USB_C_Receptacle_PowerOnly_6P','J901','USB-C / panel assembly',53.34,86.36,
      {'A5':'USB_CC1','A9':'USB_5V','B9':'USB_5V','A12':'GND','B12':'GND','B5':'USB_CC2','SH':'GND'},
      footprint='',on_board=False,in_bom=True,autowire=False,field_at=(29.21,64.77),
      properties={'Assembly':'Off-board panel socket. Functional power-only symbol; exact purchased mechanical/pin variant unverified.',
        'Qualification':'Must contain exactly one 5.1k Rd from each independent CC pin to GND, present when unpowered.',
        'Evidence':'https://www.ti.com/lit/ug/sluucs1/sluucs1.pdf',
        'Stock':'Owned two-wire panel assembly; its CC circuit has not been established.'})
    for ref,y,net in [('R901',91.44,'USB_CC1'),('R902',119.38,'USB_CC2')]:
        s.add('Device:R',ref,'5.1k / 1%',139.7,y,{'1':net,'2':'GND'},angle=90,
          footprint='',on_board=False,in_bom=True,autowire=False,field_at=(124.46,y-8.89),
          properties={'Assembly':'Required inside panel assembly or connector-side board; not a main-PCB resistor.',
            'Fit':'One per CC pin. Count existing internal Rd; never add a second resistor in parallel.'})
        s.wire(s.pin(ref,2),(175.26,y));s.label('GND',(175.26,y),0)
        s.done.add((ref,'2'))
    s.wire(s.pin('J901','A5'),s.pin('R901',1));s.label('USB_CC1',(91.44,91.44),0)
    s.wire(s.pin('J901','B5'),(101.6,93.98),(101.6,119.38),s.pin('R902',1));s.label('USB_CC2',(101.6,113.03),90)
    s.wire(s.pin('J901','A9'),(210.82,78.74));s.label('USB_5V',(210.82,78.74),0)
    s.wire(s.pin('J901','A12'),(53.34,147.32));s.label('GND',(53.34,147.32),270)
    s.wire(s.pin('J901','SH'),(45.72,137.16),(53.34,137.16))
    for pin in s.intent['J901']:s.done.add(('J901',pin))
    s.done.update({('R901','1'),('R902','1')})
    s.text('CC1 and CC2 must remain separate. Each gets its own Rd.\nNo connection to an MCU or switched rail: attachment must work\nwith a flat/disconnected battery and the display off.\nJ901 / R901 / R902 are external to the main PCB.',78.74,137.16,1.143)
    s.text('PANEL SOCKET  ->  MAIN PCB J101',260.35,69.85,1.524,True)
    s.text('VBUS / positive wire  ->  J101 pin 1 / USB_5V\nGND / return wire      ->  J101 pin 2 / GND',260.35,88.9,1.27)
    s.text('CC resistors stay at the SOCKET end.\nOnly these two power wires reach the main PCB.\nThe charger does not supply CC termination.',260.35,109.22,1.27)
    s.text('If the sealed socket has no Rd and no accessible CC pads,\nreplace/modify the socket assembly. Resistors across\nthe two power wires cannot fix C-to-C detection.',260.35,139.7,1.143)
    s.text('USB-C charger + C-to-C cable: source detects Rd and supplies 5 V.\nTwo separate Rd resistors support either insertion orientation.\nTest both ends flipped, including an electronically marked cable.\n\nUSB-A charging adapter + A-to-C cable: use the same sink socket.\nA compliant legacy cable contains Rp; do not add Rp to this device.\n\nBQ25895 D+/D- remain separately unused: nominal 500 mA input.\nThis is input current, not battery charge current. No 9/12/20 V PD\nrequest or 1.5/3 A current detection is implemented.',25.4,187.96,1.27)
    s.text('1. Unpowered: inspect/measure each CC-to-GND path.\n   Confirm two independent 5.1k resistors, not one shared\n   resistor or duplicate parallel pull-downs.\n\n2. With the charge ARM still OPEN: test 5 V at J101\n   using A-to-C and C-to-C in every orientation.\n   Test without battery and with the host off.\n\n3. After cell/NTC qualification: verify loaded voltage,\n   input current, inrush and off-state charging.\n   See USB_CHARGING.md for the acceptance matrix.',259.08,186.69,1.143)
    s.finish()

def integrate():
    root=sx.loads((P/(PROJECT+'.kicad_sch')).read_text())
    assert not any(p[1]=='Sheet file' and p[2]=='USB_Input.kicad_sch' for sh in children(root,'sheet') for p in children(sh,'property')), 'USB input sheet already integrated; use a targeted edit.'
    # Replace the old explanatory card; retain every other user placement.
    root[:]=[v for v in root if not (tag(v)=='rectangle' and child(v,'start')[1:]==[274.32,187.96])
      and not(tag(v)=='text' and (v[1]=='READ THIS DESIGN' or v[1].startswith('Matching net labels are electrically') or v[1].startswith('All gas sensors: short wired harnesses')))]
    name,page,title,x,y,description=PAGES[-1]
    sh=node('sheet',node('at',x,y),node('size',116.84,48.26),node('fields_autoplaced',S('yes')),
      node('stroke',node('width',0.381),node('type',S('default'))),node('fill',node('color',0,0,0,0)),node('uuid',sheet_uuid(name)))
    for key,val,yy in [('Sheet name',title,y),('Sheet file',name+'.kicad_sch',y+48.26)]:
        sh.append(node('property',key,val,node('at',x,yy,0),effects(1.27,'left',hide=True)))
    sh.append(node('instances',node('project',PROJECT,node('path','/'+ROOT_UUID,node('page',str(page))))));root.append(sh)
    for text,xx,yy,size,bold in [(title,x+5.08,y+7.62,2.032,True),(description,x+5.08,y+25.4,1.778,False)]:
        root.append(node('text',text,node('at',xx,yy,0),effects(size,'left top',bold),node('uuid',uid())))
    for t in children(root,'text'):
        if t[1].startswith('A2 engineering review'):t[1]=t[1].replace('A2 engineering','A2.1 engineering',1)
    revision(root);save(P/(PROJECT+'.kicad_sch'),root)
    path=P/'Charging.kicad_sch';a=sx.loads(path.read_text())
    for t in children(a,'text'):
        if t[1].startswith('J101 brings 5 V from the two-pin'):
            t[1]='J101 receives 5 V from the two-wire panel assembly.\nRequired socket CC circuit: see USB_Input, sheet 10.\nVerify the actual assembly before enabling charging.'
    for sy in children(a,'symbol'):
        ps={p[1]:p for p in children(sy,'property')}
        if ps['Reference'][2]=='J101':ps['Value'][2]='USB-C panel harness (2P)'
    revision(a);save(path,a)
    path=P/'Gauge_Interface.kicad_sch';a=sx.loads(path.read_text())
    for sy in children(a,'symbol'):
        ps={p[1]:p for p in children(sy,'property')}
        if ps['Reference'][2] in ['R302','R303']:
            child(sy,'dnp')[1]=S('no');ps['Value'][2]='4.7k / FIT'
    for t in children(a,'text'):
        if 'R302/R303 are DNP' in t[1]:t[1]=t[1].replace('R302/R303 are DNP: select bus pull-ups\nafter measuring all connected modules.','R302/R303: FIT 4.7k on this new bus.\nVerify rise time with the complete harness.')
    save(path,a)
    print('Added USB_Input and overview link; kept the main-board USB nets and two-wire harness.')

if __name__=='__main__':
    # Refuse before writing anything: a rerun must not replace user edits.
    assert not (P/'USB_Input.kicad_sch').exists(), 'USB input sheet already exists; use a targeted edit.'
    build_usb();integrate()
