"""A2.2: replace the unknown panel socket with a documented GCT USB board.

The integrated page excludes daughterboard parts from the main-board BOM.
The separate project includes those same four parts for its own PCB.
"""
from analyzer_sheet import *

DAUGHTER = HW/'kicad/usb-input'
NAME = 'Trimix_USB_Input'
FP = 'Trimix_Connectors:USB_C_GCT_USB4720-03-A'
WIRE_FP = 'Connector_Wire:SolderWire-0.25sqmm_1x02_P4.2mm_D0.65mm_OD1.7mm'


def rev(a):
    tb=child(a,'title_block');child(tb,'rev')[1]='A2.2';child(tb,'date')[1]='2026-09-06'


def build():
    s=Sheet('USB_Input',10,'USB input | GCT USB4720-03-A daughterboard',
      '5 V charging from USB-A or USB-C. Separate 0.60 mm USB PCB; main charger PCB remains 1.60 mm.')
    rev(s.a)
    s.box(20.32,48.26,226.06,114.3,'01  GCT SOCKET + TWO CC RESISTORS')
    s.box(254,48.26,147.32,114.3,'02  TWO-WIRE OUTPUT TO CHARGER')
    s.box(20.32,171.45,226.06,87.63,'03  CABLES, ORIENTATION & CURRENT')
    s.box(254,171.45,147.32,77.47,'04  MECHANICS & VERIFICATION')
    nets={p:'GND' for p in ['A1','A12','B1','B12','SH']}
    nets.update({p:'USB_5V' for p in ['A4','A9','B4','B9']})
    nets.update({'A5':'USB_CC1','B5':'USB_CC2'})
    nets.update({p:None for p in ['A6','A7','A8','B6','B7','B8']})
    sy=s.add('Connector:USB_C_Receptacle_USB2.0_16P','J901','GCT USB4720-03-A',53.34,93.98,nets,
      footprint=FP,on_board=False,in_bom=True,autowire=False,field_at=(29.21,64.77),
      properties={'Assembly':'USB daughterboard, not the main PCB',
        'PCB thickness':'0.60 +/- 0.10 mm per manufacturer drawing; mid-mount edge cutout required',
        'Status':'Selected replacement; not yet purchased or physically qualified',
        'Sealing':'GCT USB4720 connector IP67; enclosure/gasket installation requires separate validation',
        'Manufacturer':'GCT','MPN':'USB4720-03-A'})
    next(p for p in children(sy,'property') if p[1]=='Datasheet')[2]='https://gct.co/connector/usb4720'
    for ref,y,net in [('R901',83.82,'USB_CC1'),('R902',119.38,'USB_CC2')]:
        s.add('Device:R',ref,'5.1k / 1%',139.7,y,{'1':net,'2':'GND'},angle=90,
          footprint='Resistor_SMD:R_0603_1608Metric',on_board=False,in_bom=True,
          autowire=False,field_at=(124.46,88.9 if ref=='R901' else y-8.89),
          properties={'Assembly':'USB daughterboard; FIT one resistor per independent CC pin',
            'Purpose':'Passive sink attachment, present with battery disconnected and host off'})
        s.wire(s.pin(ref,2),(175.26,y));s.label('GND',(175.26,y),0)
        s.done.add((ref,'2'))
    s.wire(s.pin('J901','A5'),s.pin('R901',1));s.label('USB_CC1',(91.44,83.82),0)
    s.wire(s.pin('J901','B5'),(101.6,86.36),(101.6,119.38),s.pin('R902',1))
    s.label('USB_CC2',(101.6,113.03),90)
    s.wire(s.pin('J901','A4'),(210.82,78.74));s.label('USB_5V',(210.82,78.74),0)
    s.wire(s.pin('J901','A1'),(53.34,147.32));s.label('GND',(53.34,147.32),270)
    s.wire(s.pin('J901','SH'),(45.72,137.16),(53.34,137.16))
    for pin,net in nets.items():
        if net is not None:s.done.add(('J901',pin))
    s.done.update({('R901','1'),('R902','1')})
    s.text('CC1 and CC2 stay separate; fit both resistors.\nAll four VBUS and all four GND contacts are connected.\nData / SBU pins are unused. Shield connects to GND.\nThis is a passive 5 V sink, with no PD controller.',78.74,137.16,1.143)
    s.add('Connector_Generic:Conn_01x02','J902','TO MAIN PCB J101',342.9,83.82,
      {'1':'USB_5V','2':'GND'},footprint=WIRE_FP,on_board=False,in_bom=True,
      field_at=(304.8,68.58),properties={'Assembly':'USB daughterboard output pigtail pads; strain relief required',
        'Harness':'Pin 1 positive -> J101 pin 1; pin 2 return -> J101 pin 2. Verify physical polarity.'})
    s.text('J902 pin 1  ->  positive wire  ->  J101 pin 1\nJ902 pin 2  ->  return wire    ->  J101 pin 2',260.35,104.14,1.27)
    s.text('J901 / R901 / R902 / J902 belong to the USB PCB.\nThe main charger retains its two-wire input.\nUse soldered leads with enclosure strain relief;\nwire size and final mounting remain to be checked.',260.35,124.46,1.143)
    s.text('USB-C charger + C-to-C cable: separate Rd on CC1 / CC2\nallows source attachment in either plug orientation.\nTest both ends flipped, including an electronically marked cable.\n\nUSB-A charging adapter + A-to-C cable uses the same input.\nThe compliant legacy cable supplies Rp; do not add Rp here.\n\nBQ25895 D+/D- remain unused: nominal 500 mA INPUT setting.\nBattery charge current depends on available power and system load.\nNo 9/12/20 V PD request or 1.5/3 A detection is implemented.',25.4,187.96,1.27)
    s.text('GCT drawing: 0.60 +/- 0.10 mm PCB and edge cutout.\nDo not fit USB4720 directly to the 1.60 mm main board.\nProvide rigid support against cable insertion forces.\nIP67 connector does not certify the enclosure; charge dry.\n\nBefore power: verify CC1-GND and CC2-GND ~5.1k.\nWith ARM OPEN: verify 5 V in all cable orientations,\nincluding no battery / host off. Then qualify loaded\nvoltage, input current and inrush. Battery charging\ntests follow cell / holder / thermistor qualification.',259.08,186.69,1.143)
    s.finish()
    standalone(s.a)


def standalone(source):
    DAUGHTER.mkdir(exist_ok=True)
    a=copy.deepcopy(source);root=uid();child(a,'uuid')[1]=root
    tb=child(a,'title_block');child(tb,'title')[1]='Trimix USB daughterboard - GCT USB4720-03-A'
    for sy in children(a,'symbol'):
        ref=next(p[2] for p in children(sy,'property') if p[1]=='Reference')
        child(sy,'on_board')[1]=S('yes')
        sy[:]=[v for v in sy if tag(v)!='instances']
        sy.append(node('instances',node('project',NAME,node('path','/'+root,node('reference',ref),node('unit',1)))))
    a.append(node('sheet_instances',node('path','/',node('page','1'))))
    save(DAUGHTER/(NAME+'.kicad_sch'),a)
    pro=DAUGHTER/(NAME+'.kicad_pro')
    if not pro.exists():pro.write_text(json.dumps({'meta':{'filename':pro.name,'version':1}},indent=2)+'\n')
    for base,uri in [(P,'${KIPRJMOD}/Trimix_Connectors.pretty'),(DAUGHTER,'${KIPRJMOD}/../analyzer/Trimix_Connectors.pretty')]:
        path=base/'fp-lib-table'
        table=sx.loads(path.read_text()) if path.exists() else node('fp_lib_table',node('version',7))
        if not any(child(lib,'name')[1]=='Trimix_Connectors' for lib in children(table,'lib')):
            table.append(node('lib',node('name','Trimix_Connectors'),node('type','KiCad'),node('uri',uri),node('options',''),node('descr','GCT USB4720-03-A manufacturer drawing based footprint')))
        save(path,table)


def annotate():
    path=P/(PROJECT+'.kicad_sch');a=sx.loads(path.read_text());rev(a)
    for t in children(a,'text'):
        if t[1].startswith('A2.1 engineering'):t[1]=t[1].replace('A2.1','A2.2',1)
        if t[1].startswith('USB-C socket: separate CC resistors'):
            t[1]='GCT USB4720 + two CC resistors\nSeparate 0.60 mm USB daughterboard\n5 V input from USB-A or USB-C'
    save(path,a)
    path=P/'Charging.kicad_sch';a=sx.loads(path.read_text());rev(a)
    for t in children(a,'text'):
        if t[1].startswith('J101 receives 5 V from'):
            t[1]='J101 receives 5 V from the GCT USB daughterboard.\nJ902 -> two-wire harness -> J101 (same pin numbers).\nSee USB_Input, sheet 10; qualify before charging.'
    for sy in children(a,'symbol'):
        ps={p[1]:p for p in children(sy,'property')}
        if ps['Reference'][2]=='J101':ps['Value'][2]='FROM USB BOARD (2P)'
    save(path,a)


if __name__=='__main__':
    assert not DAUGHTER.exists(), 'USB daughterboard project exists; use a targeted edit to preserve user changes.'
    build();annotate()
