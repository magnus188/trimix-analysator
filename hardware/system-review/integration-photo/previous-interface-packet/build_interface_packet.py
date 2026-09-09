#!/usr/bin/env python3
"""Generate the review harness drawings from the exported electrical contract.

Reference drawings, not a released cable manufacturing specification. Run only
after electrical export; refuse the superseded two-wire USB/gauge-alert map.
"""
import csv
import hashlib
import json
from pathlib import Path
from reportlab.pdfgen import canvas
from reportlab.lib import colors
from reportlab.lib.pagesizes import A4, landscape
from reportlab.platypus import Paragraph
from reportlab.lib.styles import ParagraphStyle

HERE = Path(__file__).resolve().parent
OUT = HERE / 'interface-packet.pdf'
PINMAP = HERE / 'electrical/connector-testpoint-pinmap.csv'
HOST = HERE / 'electrical/host-interface.csv'
W, H = landscape(A4)
INK = colors.HexColor('#173247')
BLUE = colors.HexColor('#006C8F')
GRAY = colors.HexColor('#EDF2F5')
AMBER = colors.HexColor('#9B5C0B')
styles = {n: ParagraphStyle(n, fontName='Helvetica', fontSize=size, leading=size*1.35,
                            textColor=INK) for n,size in [('body',10),('small',8.5)]}

def main():
    rows = list(csv.DictReader(PINMAP.open()))
    pins = {(r['reference'],r['pin']):r['net'].split('/')[-1] for r in rows}
    host = {r['net']:r for r in csv.DictReader(HOST.open())}
    usb = ['USB_5V','GND','USB_CC1','USB_CC2','USB_D_P','USB_D_M']
    assert pins['J301','11']=='USB_ILIM_AUTH', 'Refresh the exported GPIO50 contract'
    assert pins['J301','2']==pins['J301','4']=='HOST_5V', 'Refresh host isolation export'
    for ref in ['J101','J902']:
        assert [pins.get((ref,str(i))) for i in range(1,7)]==usb, 'Refresh six-wire USB export'
    c = canvas.Canvas(str(OUT), pagesize=(W,H))
    c.setTitle('Trimix SystemReview - wiring and measurement reference')
    c.setAuthor('Trimix analyzer project')
    page = 0
    def para(text,x,y,width=740,style='body'):
        p=Paragraph(text, styles[style]); _,height=p.wrap(width,700)
        p.drawOn(c,x,H-y-height); return y+height
    def line(text,x,y,size=10,color=INK,font='Helvetica'):
        c.setFillColor(color); c.setFont(font,size); c.drawString(x,H-y,text)
    def start(title,subtitle):
        nonlocal page
        if page: c.showPage()
        page+=1
        c.setFillColor(INK);c.rect(0,H-10,W,10,fill=1,stroke=0)
        line('TRIMIX  /  SYSTEM REVIEW',36,35,9,BLUE,'Helvetica-Bold')
        line(title,36,64,23,INK,'Helvetica-Bold')
        para(subtitle,36,78)
        line('REFERENCE - NOT RELEASED FOR FABRICATION OR WIRING',36,H-26,8,AMBER,'Helvetica-Bold')
        line(f'{page}  /  6',W-68,H-26,9)
    def box(x,y,w,h,title,body):
        c.setFillColor(GRAY);c.roundRect(x,H-y-h,w,h,7,fill=1,stroke=0)
        line(title,x+12,y+23,11,BLUE,'Helvetica-Bold')
        para(body,x+12,y+33,w-24,'small')
    def arrow(x1,y1,x2,y2):
        import math
        c.setStrokeColor(BLUE);c.setLineWidth(1.4);c.line(x1,H-y1,x2,H-y2)
        angle=math.atan2(y2-y1,x2-x1)
        for d in [-.5,.5]:c.line(x2,H-y2,x2-8*math.cos(angle+d),H-y2+8*math.sin(angle+d))
    def table(headers,data,x=36,y=132,widths=None,rowheight=24):
        widths=widths or [740/len(headers)]*len(headers)
        for ri,row in enumerate([headers]+data):
            xx=x; yy=y+ri*rowheight
            c.setFillColor(INK if ri==0 else GRAY if ri%2 else colors.white)
            c.rect(x,H-yy-rowheight,sum(widths),rowheight,fill=1,stroke=0)
            for col,w in zip(row,widths):
                line(str(col),xx+8,yy+rowheight*.68,9,
                     colors.white if ri==0 else INK,'Helvetica-Bold' if ri==0 else 'Helvetica')
                xx+=w
        return y+(len(data)+1)*rowheight
    def net(ref,pin):
        n=pins.get((ref,str(pin)),'MISSING')
        return 'NC - leave unused' if n.startswith('unconnected') else n

    start('The complete connection map',
          'Six logical harness groups connect the main PCB to the installed modules. Connector drawings are schematic views; no mating orientation is implied.')
    box(36,137,180,92,'USB daughterboard','J901 GCT USB4720<br/>J902 to J101: power, ground, CC1, CC2, D+, D-.<br/>5 V input; no USB data service.')
    box(325,137,210,92,'Main PCB','Four copper layers.<br/>Power conversion, battery monitoring, ADCs, sensor interfaces and shutdown.')
    box(642,137,162,92,'Guition screen','J301 to JP1.<br/>5 V toward screen; HOST_3V3 from screen.<br/>GPIO52 stays unused.')
    arrow(216,181,325,181);arrow(535,181,642,181)
    box(36,289,180,101,'Protected FMA holder','J102: protected pack output.<br/>Two cells in parallel; one-cell voltage.<br/>J103: separate temperature sensor.<br/>J104 charge arm stays OPEN.')
    box(325,289,210,101,'Gas chamber','One oxygen cell: J401 AO2 OR J402 JJ-CCR.<br/>J501 MD62; J601 humidity.<br/>J701 ZE07-CO module.')
    box(642,289,162,101,'Button','J801 normally-open switch.<br/>J802 optional button LED.<br/>Hardware held-button shutdown is independent of firmware.')
    arrow(216,335,305,335);arrow(305,335,325,221)
    arrow(430,229,430,289);arrow(642,335,555,335);arrow(555,335,535,221)
    para('<b>Before making a cable:</b> identify both mating parts, locate pin 1 from the actual mating side, verify continuity without power, and record wire gauge, length, strain relief and minimum bend radius. The model does not yet establish every purchased connector.',36,423)
    para('Drawing sources: current KiCad net export and firmware/JP1 contract. Full measurements: mechanical/MEASUREMENTS.md. Electrical bring-up: electrical/measurement-and-bringup.md.',36,486,740,'small')

    start('H01 - Guition JP1 to main J301',
          'Logical pin-to-same-pin mapping. This is a numbered list, not a view of the two-row connector. Pitch, row spacing, mating height and cable exit still require measurement.')
    line('Main mate candidate: Samtec HTSW-113-07-L-D-007 / IDSD-13-S-04.00-G-P07. Configured availability pending.',36,124,8.5,BLUE)
    data=[]
    for pin in range(1,27):
        n=net('J301',pin);r=host.get(n,{})
        direction={'HOST_3V3':'from screen','HOST_5V':'to screen','GND':'ground return'}.get(n,'no wire')
        data.append([pin,n,r.get('GPIO','-'),r.get('direction',direction)])
    for half,x in [(data[:13],36),(data[13:],429)]:
        table(['Pin','Net','GPIO','Direction'],half,x=x,y=137,widths=[30,157,38,112],rowheight=24)
    para('<b>Power-entry HOLD:</b> Guition ties JP1 5 V to the IP5306 boost output; external input at JP1 is still unqualified. Analyzer reverse isolation does not establish that use. Keep J301 disconnected for wired USB service; leave Guition BAT empty.<br/><b>Supplies:</b> 2/4 HOST_5V to screen; 1/3/18 HOST_3V3 from screen; 5/6/16 ground.<br/><b>Pin 13 / GPIO49:</b> shared charger IRQ and lost latch feedback. GPIO50 commands permission; GPIO49 checks it.',36,485,740,'small')

    start('H02 - concealed bottom USB',
          'J902 on the thin USB board connects to J101 on the main board. Pin numbering is logical: verify the silkscreen and continuity at both ends.')
    table(['J902 pin','Net','J101 pin','Planned wire'],[[i,n,i,'24 AWG' if i<3 else '28 AWG'] for i,n in enumerate(usb,1)],
          widths=[90,250,110,290],rowheight=30)
    box(36,374,352,119,'Electrical provisions','Two internal CC pull-downs in the sink controller; do not fit duplicate external Rd resistors.<br/>D+/D- go only to the BC1.2 detector, not the BQ25895.<br/>Upstream current limiting must work before firmware starts.<br/>No fast-charge or USB-PD negotiation is provided.')
    box(410,374,366,119,'Mechanical datums to verify','GCT drawing: 0.60 +/-0.10 mm board.<br/>PCB nominal Z24.9-25.5; port centre Z26.0.<br/>Nominal clearance above PCB to support bridge: 5.7 mm before solder/wire.<br/>Check plug overmould, pigtail bend and strain relief physically.')
    para('Wire gauges are design proposals; qualify the actual insulation, solder process, length and rated current. Do not interpret a clear cable line here as a verified installed bend.',36,513,740,'small')

    start('H03-H06 - sensors, pack and button',
          'Only one oxygen cell is installed. J402 shield/shell carries the negative cell signal; do not bond it to chassis or ground.')
    groups=[('J401','AO2',3),('J402','JJ-CCR',2),('J501','MD62',3),('J601','Humidity',4),('J701','ZE07-CO',4),('J102','Protected pack',2),('J103','Pack NTC',2),('J801','NO button',2),('J802','Button LED',2)]
    data=[]
    for ref,name,count in groups:
        data.append([ref,name,';  '.join(f'{i}: {net(ref,i)}' for i in range(1,count+1))])
    table(['Connector','Module','PCB pin-to-net map'],data,widths=[80,120,540],rowheight=31)
    para('<b>Remote ends still need measurement.</b> Verify actual module pin order, mating parts, cable polarity and sensor lead drawings. PCB net names do not establish remote pin numbers. Use a real BME280 for humidity.<br/><b>CO:</b> the ZE07-CO requires -10 to 55 C and 15-90% RH without condensation. It cannot certify breathing-gas safety. See the <a href="https://www.winsen-sensor.com/d/files/manual/ze07-co.pdf" color="#006C8F">manufacturer manual</a>.',36,455)
    para('J104 is a charge-arm link, not a sensor selector. Keep it open for commissioning. Oxygen choice and calibration are stored through the touchscreen; GPIO52/J301 pin 7 remains unused.',36,522,740,'small')

    start('Measurements that unblock the order',
          'Record millimetres, instrument accuracy, the actual part marking, and photographs from the mating side. Preserve the approved exterior while resolving these interfaces.')
    measure=[
        ('Guition JP1','First-to-last of 13 physical pins in one row; row spacing; pin 1; mated height.'),
        ('Battery holder / cells','Actual plug and polarity; protrusions; cell maker/model and charging limits.'),
        ('AO2 and JJ-CCR','Sealing shoulder to nose and rear; thread engagement; seal size and face.'),
        ('J401 / J402 cables','Mated 90-degree elbow envelope, exit direction, grip and bend radius.'),
        ('USB cartridge','Real connector on 0.60 mm coupon; notch/lands; wire bend and plug clearance.'),
        ('Gas modules','MD62 leads; actual BME280 board; ZE07-CO connector and can height.'),
        ('Chamber seals','Real gasket/feedthrough/fitting dimensions and supplier compression guidance.'),
        ('Fasteners / button','TC-M2x3.0 / VORON M3x5x4 insert coupons; actual screws; button nut/terminal stack.'),
    ]
    table(['Item','Needed evidence'],measure,widths=[135,605],rowheight=37)
    para('<b>Recorded already:</b> display 69.3 x 116.8 x 13.7 mm; occupied protected holder 42 x 80.4 x 20.35 mm. The owner confirms a common oxygen thread, with JJ-CCR 2 mm smaller in diameter and 2 mm longer. The location of that extra length and the sealing faces still need verification.',36,492,740,'small')

    start('Staged first power - after release gates close',
          'All powered and physical checks are pending. Start with modules and cells disconnected, microscope inspection and unpowered continuity. Record test limits before applying power.')
    stages=[
        ('1  Inspect','Check BOM/DNP, pin 1, solder bridges, exposed pads, rail resistance and every harness.'),
        ('2  Pack-input rails','J104 OPEN; no cells or USB. Use a current-limited source after verifying pack polarity.'),
        ('3  Converters','Controlled load steps, startup, ripple and overshoot before attaching the host.'),
        ('4  Host / modules','First qualify Guition power entry; add modules individually and verify levels and faults.'),
        ('5  Button / storage','Short/held press, stalled firmware, save interruption and safe battery disconnection.'),
        ('6  USB power','Separate controlled fixture; A-to-C / C-to-C, orientations, source limits and recovery.'),
        ('7  Charging','Only with documented cells/NTC/protection: voltage, current, faults, termination and heat.'),
        ('8  Reference gas','Condition MD62; characterize known mixtures, environment, drift and held-out validation.'),
    ]
    table(['Stage','Check'],stages,widths=[132,608],rowheight=34)
    para('Confirmed equipment: microscope, soldering iron and hot-air station. Powered checks also need a DMM and current-limited supply; load and transient checks need suitable loads and an oscilloscope. Access to these test instruments is not confirmed. A nonsinking supply is not a battery emulator.',36,463)
    para('Retain board/firmware hashes, instrument identity/accuracy, hookup, limits, readings, conditions and corrective actions. O2 +/-0.2 percentage points and He +/-0.5 points remain unproven targets. Follow first-power.md for the full sequence and electrical/measurement-and-bringup.md for source-linked limits.',36,513,740,'small')
    c.save()
    sources=[PINMAP,HOST,HERE/'mechanical/MEASUREMENTS.md',HERE/'first-power.md',HERE/'electrical/measurement-and-bringup.md',HERE/'electrical/host-harness-review/contract.json',HERE/'electrical/host-power-review/sources.json',HERE/'electrical/co-module-use-review.md',Path(__file__)]
    receipt={'status':'reference packet; render inspection required', 'pages':page,
             'sources':[{'path':str(p.relative_to(HERE)),'sha256':hashlib.sha256(p.read_bytes()).hexdigest()} for p in sources],
             'pdf_sha256':hashlib.sha256(OUT.read_bytes()).hexdigest()}
    (HERE/'interface-packet.json').write_text(json.dumps(receipt,indent=2)+'\n')
    print(OUT)

if __name__=='__main__':main()
