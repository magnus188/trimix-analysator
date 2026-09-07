"""Create three A3 review sheets from eight actual Revision04 Fusion views.

Statuses and bounds are read from this revision only. Missing views are fatal.
No PDF is created by importing this module. Render and inspect before delivery.
"""
from __future__ import annotations

import argparse

from datetime import date

from html import escape

import json

from pathlib import Path

from PIL import Image

from reportlab.lib import colors

from reportlab.lib.enums import TA_LEFT

from reportlab.lib.pagesizes import A3, landscape

from reportlab.lib.styles import ParagraphStyle

from reportlab.lib.utils import ImageReader

from reportlab.pdfgen import canvas

from reportlab.platypus import Paragraph, Table, TableStyle

ROOT = Path(__file__).resolve().parents[1]

PAGE_W, PAGE_H = landscape(A3)

MARGIN = 36

CONTENT_W = PAGE_W - 2 * MARGIN

INK = colors.HexColor("#1A2F3A")

MUTED = colors.HexColor("#546773")

TEAL = colors.HexColor("#007D84")

LINE = colors.HexColor("#CFDADE")

PALE = colors.HexColor("#F3F7F8")

VIEWS = ("front", "rear", "left", "right", "section-aa", "section-bb", "rear-open", "exploded")

DEFAULT_CHECKS = (
    "Geometry and regeneration", "Clearance and interference",
    "Service paths and tool access", "Sample path and separation",
    "Native and STEP exports", "Review-sheet visual inspection",
)

GUITION = (
    "https://www.guition.com/icms/upload/fb081940d6fc11f09850077a33e1404f/"
    "FTPData/UEditor/file/2026121/1768961095795/"
    "JC4880P443C_I_W%20Specifications-EN-V1.0.pdf"
)

GCT = "https://gct.co/files/drawings/usb4720.pdf"

def style(name, size=9.3, leading=13, **kw):
    return ParagraphStyle(name, fontName="Helvetica", fontSize=size,
                          leading=leading, textColor=INK, alignment=TA_LEFT, **kw)

BODY = style("body")

SMALL = style("small", 8, 11)

SMALL.textColor = MUTED

CELL = style("cell", 9, 12)

COMPACT = style("compact", 8.3, 11.2)

def para(c, text, x, top, width, paragraph_style=BODY):
    p = Paragraph(text, paragraph_style)
    _, height = p.wrap(width, PAGE_H)
    p.drawOn(c, x, top - height)
    return height

def label(c, text, x, y, size=10, color=INK, bold=False):
    c.setFillColor(color)
    c.setFont("Helvetica-Bold" if bold else "Helvetica", size)
    c.drawString(x, y, text)

def header(c, title, subtitle, page):
    c.setFillColor(TEAL)
    c.rect(MARGIN, PAGE_H - 42, 27, 4, fill=1, stroke=0)
    label(c, "TRIMIX / ENCLOSURE A3", MARGIN + 36, PAGE_H - 43,
          10, TEAL, True)
    label(c, "REVISION 04", PAGE_W - MARGIN - 104, PAGE_H - 43,
          10, MUTED, True)
    label(c, title, MARGIN, PAGE_H - 81, 25, INK, True)
    para(c, subtitle, MARGIN, PAGE_H - 98, CONTENT_W - 242, SMALL)
    c.setStrokeColor(LINE)
    c.line(MARGIN, PAGE_H - 127, PAGE_W - MARGIN, PAGE_H - 127)
    label(c, "ENGINEERING CONCEPT REVIEW", PAGE_W - MARGIN - 213,
          PAGE_H - 104, 9, TEAL, True)
    label(c, "NOT TO SCALE / PRINT RELEASE PENDING", PAGE_W - MARGIN - 213,
          PAGE_H - 118, 7.5, MUTED)
    c.line(MARGIN, 49, PAGE_W - MARGIN, 49)
    label(c, "Actual Fusion views | Measured envelopes + provisional details | Not a manufacturing drawing",
          MARGIN, 34, 8, MUTED)
    c.setFont("Helvetica", 8)
    c.setFillColor(MUTED)
    c.drawRightString(PAGE_W - MARGIN, 34,
                      f"{date.today().isoformat()} / A3 landscape / {page} of 3")

def load_views(directory):
    missing = [str(directory / f"{name}.png") for name in VIEWS
               if not (directory / f"{name}.png").is_file()]
    if missing:
        raise SystemExit("Required actual Fusion view images are missing:\n" + "\n".join(missing))
    loaded = {}
    for name in VIEWS:
        path = directory / f"{name}.png"
        with Image.open(path) as im:
            if im.format != "PNG":
                raise SystemExit(f"Expected a PNG Fusion viewport image: {path}")
            im.load()
            if min(im.size) < 500:
                raise SystemExit(f"Fusion view is too small for this review sheet: {path} {im.size}")
            rgba = im.convert("RGBA")
            bg = Image.new("RGBA", rgba.size, (255, 255, 255, 255))
            loaded[name] = Image.alpha_composite(bg, rgba).convert("RGB")
    return loaded

def view_card(c, image, title, caption, x, y, width, height):
    c.setFillColor(colors.white)
    c.setStrokeColor(LINE)
    c.roundRect(x, y, width, height, 5, fill=1, stroke=1)
    label(c, title, x + 14, y + height - 24, 11, INK, True)
    c.line(x + 14, y + height - 35, x + width - 14, y + height - 35)
    area_x, area_y = x + 10, y + 56
    area_w, area_h = width - 20, height - 98
    iw, ih = image.size
    scale = min(area_w / iw, area_h / ih)
    draw_w, draw_h = iw * scale, ih * scale
    c.drawImage(ImageReader(image), area_x + (area_w - draw_w) / 2,
                area_y + (area_h - draw_h) / 2, draw_w, draw_h,
                preserveAspectRatio=True, mask="auto")
    used = para(c, caption, x + 14, y + 43, width - 28, SMALL)
    if used > 36:
        raise RuntimeError(f"View caption exceeds its reserved area: {title}")

def table(c, rows, x, top, width, fractions):
    data = [[Paragraph(cell, CELL) for cell in row] for row in rows]
    t = Table(data, colWidths=[width * fraction for fraction in fractions])
    t.setStyle(TableStyle([
        ("BACKGROUND", (0, 0), (-1, 0), PALE),
        ("ROWBACKGROUNDS", (0, 1), (-1, -1), [colors.white, PALE]),
        ("BOX", (0, 0), (-1, -1), 0.6, LINE),
        ("LINEBELOW", (0, 0), (-1, 0), 0.6, LINE),
        ("VALIGN", (0, 0), (-1, -1), "TOP"),
        ("LEFTPADDING", (0, 0), (-1, -1), 10),
        ("RIGHTPADDING", (0, 0), (-1, -1), 10),
        ("TOPPADDING", (0, 0), (-1, -1), 7),
        ("BOTTOMPADDING", (0, 0), (-1, -1), 7),
    ]))
    _, height = t.wrap(width, PAGE_H)
    t.drawOn(c, x, top - height)
    return top - height


def evidence():
    def read(name):
        p = ROOT/'verification'/name
        return json.loads(p.read_text()) if p.exists() else None
    audit = read('model-audit.json'); regeneration = read('parameter-regeneration.json')
    services = read('service-paths-cover-disconnect-battery-carrier-chamber-retainers-display-usb.json')
    drivers = read('service-drivers.json'); pcb = read('pcb-strip-assessment.json')
    gas = read('gas-clearance-paths.json'); walls = read('selected-wall-fastener-checks.json')
    checks = []
    def check(name, item, passed, note, source):
        checks.append({'name':name, 'status':'PENDING' if item is None else 'PASS' if passed else 'NEEDS REVIEW',
                       'note':note if item is not None else 'No Revision04 result recorded.', 'source':source})
    check('Native CAD', audit, audit and audit['status']=='cad_checks_passed',
          f"{audit['body_instance_count']} bodies, {audit['occurrence_count']} occurrences; {audit['interference']['collision_count']} overlaps. {len(audit.get('selected_printed_parts_one_solid',[]))} selected printed parts each have one solid." if audit else '', 'model-audit.json')
    check('Parameter regeneration', regeneration, regeneration and regeneration['pass'],
          'Independent size trials; purchased dimensions checked and original geometry restored.' if regeneration and regeneration['pass'] else 'See report for failed or incomplete size trials.', 'parameter-regeneration.json')
    check('Service paths', services, services and services['status']=='sampled_paths_clear_with_prerequisites',
          f"{len(services['tests'])} paths checked at poses no more than 1 mm apart. Prerequisites apply." if services else '', 'Final service-paths report; README')
    check('Driver shafts', drivers, drivers and drivers['status']=='clear_for_nominal_shafts',
          f"{drivers['screw_occurrence_count']} approaches checked. Handles, hands and torque remain unqualified." if drivers else '', 'service-drivers.json')
    check('Selected walls and fasteners', walls, walls and walls['status']=='selected_checks_passed',
          f"{walls['selected_wall_section_count']} sections and {walls['screw_count']} screw/insert pairs checked. Global minimum wall is not verified." if walls else '', 'selected-wall-fastener-checks.json')
    checks.append({'name':'PCB allocation', 'status':'PARTIAL' if pcb else 'PENDING',
                   'note':f"{pcb['footprints']} footprints / {pcb['fit']} FIT. Offline courtyard packing only; routing, thermal layout and real connectors remain open." if pcb else 'No footprint assessment recorded.', 'source':'pcb-strip-assessment.json'})
    checks.append({'name':'Physical qualification', 'status':'OPEN',
                   'note':'Actual retention, global minimum wall, seals, gas response, wiring and prototype fit are not qualified.', 'source':'README.md; MEASUREMENTS.md'})
    return {'audit':audit,'pcb':pcb,'gas':gas,'walls':walls,'checks':checks}


def overview(c, images, data):
    header(c, 'Shape A exterior arrangement',
           'Slimmer grip with a taller top sampling pod. Single rear cover; screen-only front. Viewer-left power button and bottom USB-C.',1)
    gap=14; w=(CONTENT_W-3*gap)/4
    for i,(name,title,caption) in enumerate((
            ('front','01 / FRONT','Measured 4.3-inch factory-cased display; top sampling pod above.'),
            ('rear','02 / REAR','One removable cover with four separate recessed rear screws.'),
            ('left','03 / LEFT SIDE','Power button on viewer-left side; upper gas fitting.'),
            ('right','04 / RIGHT SIDE','Opposed upper gas fitting. USB-C is on the bottom face.'))):
        view_card(c,images[name],title,caption,MARGIN+i*(w+gap),312,w,382)
    audit=data['audit']; actual='Model audit pending.'; body='Target: 180 H x 85 W x 43 D'
    dimensions={'CaseHeight':180,'CaseWidth':85,'CaseDepth':43}
    if audit:
        size=audit['assembly_body_bounds_mm']['size']; actual=f'Audited total: {size[1]:g} H x {size[0]:g} W x {size[2]:g} D, including projections.'
        parameters={p['name']:p['value_mm'] for p in audit['parameters']}
        dimensions={name:parameters[name] for name in dimensions}
        body=f"{parameters['CaseHeight']:g} H x {parameters['CaseWidth']:g} W x {parameters['CaseDepth']:g} D"
    label(c,'DIMENSION REFERENCES / MILLIMETRES',MARGIN,292,9,TEAL,True)
    table_bottom=table(c,[['REFERENCE','ENVELOPE / SIZE','BASIS AND LIMIT'],
             ['Housing',body,actual],
             ['Factory-cased display','116.8 H x 69.3 W x 13.7 D','Owner measurement with factory back removed; local mounting details unmeasured.'],
             ['Occupied FMA holder','80.4 H x 42 W x 20.35 D','Owner measurement including two cells; retained RCY/BEC plug is provisional geometry.'],
             ['Future PCB strip','30 W x 99 H, before notches','Datum-derived at 85 mm case width; footprint study only, not a routed board.']],
          MARGIN,279,CONTENT_W,(.23,.27,.5))
    thin=(1-dimensions['CaseDepth']/56)*100
    volume=(dimensions['CaseHeight']*dimensions['CaseWidth']*dimensions['CaseDepth']/(125*75*56)-1)*100
    coverage=116.8*69.3/(dimensions['CaseHeight']*dimensions['CaseWidth'])*100
    comparison=(f'<b>Shape tradeoff:</b> {thin:.1f}% thinner than A2; {volume:.1f}% more body bounding-box volume. '
                f'The measured factory display casing occupies {coverage:.1f}% of the front rectangle; this is not active screen area.')
    used=para(c,comparison,MARGIN,table_bottom-12,CONTENT_W,SMALL)
    if table_bottom-12-used<95:raise RuntimeError('Dimension comparison intrudes on page1 source note')
    para(c,'Sources: owner measurements; <link href="'+GUITION+'" color="#007D84">Guition specification</link>; <link href="'+GCT+'" color="#007D84">GCT USB4720 Revision B drawing</link>. Actual viewport views are independently resized; do not measure these sheets.',MARGIN,81,CONTENT_W,SMALL)
    c.showPage()


def internal(c, images, data):
    header(c,'Separate battery, PCB and sample path',
           'Battery and PCB sit side by side behind the display. The top manifold uses a continuous candidate clearance route; gas performance remains unqualified.',2)
    gap=16; w=(CONTENT_W-2*gap)/3
    specs=(('rear-open','05 / REAR OPEN','Cover hidden. Pack, side PCB strip and top cartridge remain visible.'),
           ('section-aa','06 / SECTION A-A','Battery/screen cut. Screen left; rear cover right.'),
           ('section-bb','07 / SECTION B-B','Top-manifold cut at GasY. Front at image top; rear at bottom.'))
    for i,(name,title,caption) in enumerate(specs):view_card(c,images[name],title,caption,MARGIN+i*(w+gap),220,w,474)
    c.setFillColor(PALE);c.setStrokeColor(LINE);c.roundRect(MARGIN,88,CONTENT_W,109,5,fill=1,stroke=1)
    label(c,'READING THE MODEL',MARGIN+16,177,10,TEAL,True)
    gas=data['gas']
    gas_status='PENDING' if gas is None else 'PASS' if gas.get('pass') else 'NEEDS REVIEW'
    gas_label='5 MM CONTINUOUS GAS PROBE / '+gas_status
    if gas is not None:gas_label+=' / '+str(gas['collision_count'])+' INTERSECTIONS'
    label(c,gas_label,MARGIN+480,177,9,TEAL,True)
    para(c,'+X points toward the viewer\'s left; +Y up; +Z rearward. Rear views reverse visual left/right. The complete display leaves forward after its rear retainers are released. Keep the protected cells in the measured holder.',MARGIN+16,158,CONTENT_W-32,BODY)
    para(c,'Gas evidence: gas-clearance-paths.json records cylinders, corner spheres and selected channel dimensions. Flow rating, sample renewal, sealing and sensor response require physical validation. Nominal part allowances, the AO2 seal and atmospheric sampling remain unqualified.',MARGIN+16,121,CONTENT_W-32,SMALL)
    c.showPage()


def assembly(c, images, data):
    header(c,'Exploded relationships and recorded checks',
           'Separate occurrences for individual screws. The exploded arrangement explains ownership and access; it is not a removal trajectory.',3)
    left=CONTENT_W*.63
    view_card(c,images['exploded'],'08 / EXPLODED ASSEMBLY',
              'Cover, display, battery, carrier, PCB, USB cartridge and top sample assembly shown separately.',MARGIN,150,left,544)
    x=MARGIN+left+24; width=CONTENT_W-left-24; top=694
    label(c,'CURRENT REVISION04 EVIDENCE',x,top-16,10,TEAL,True); top-=39
    for check in data['checks']:
        used=para(c,escape(check['name']+' / '+check['status'])+'<br/>'+escape(check['note'])+'<br/><font color="#546773">'+escape(check['source'])+'</font>',x,top,width,COMPACT)
        top-=used+16
    if top<157:raise RuntimeError('Evidence sidebar exceeds page3 reserved area')
    para(c,'Service intent: cover off and battery unplugged first. Pack and PCB carrier have separate rearward routes. Release external fittings before withdrawing the closed top cartridge. USB service follows pack removal; actual checked movements and prerequisites are recorded in README and the service report.',MARGIN,128,CONTENT_W,BODY)
    para(c,'Concept deliverables only. Print-ready release follows actual part measurements, PCB layout, retention/seal checks and physical fit testing.',MARGIN,83,CONTENT_W,SMALL)
    c.showPage()


def main():
    parser=argparse.ArgumentParser();parser.add_argument('--views',type=Path,default=ROOT/'views')
    parser.add_argument('--output',type=Path,default=ROOT/'Trimix_Enclosure_A3_Review.pdf')
    args=parser.parse_args();images=load_views(args.views);data=evidence()
    args.output.parent.mkdir(parents=True,exist_ok=True)
    c=canvas.Canvas(str(args.output),pagesize=landscape(A3))
    c.setTitle('Trimix Enclosure A3 - Revision04 Engineering Concept Review')
    c.setAuthor('Trimix analyser project')
    overview(c,images,data);internal(c,images,data);assembly(c,images,data);c.save()
    print(f'Created {args.output} (3 pages, A3 landscape; render and inspect before delivery)')


if __name__=='__main__':main()
