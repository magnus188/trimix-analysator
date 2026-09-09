"""TI TPS63020 DSJ land pattern from manufacturer drawing4210895-2/E.

Runs offline; creates a project-local footprint and dimensional metadata only.
Dimensions are transcribed from datasheet page33, independently reviewed.
No schematic or working PCB is edited by this generator.
"""
from pathlib import Path
import json
import hashlib
import math

HW=Path(__file__).resolve().parents[3]
LIB=HW/'pcb/analyzer/Trimix_Power.pretty'
OUT=LIB/'TI_DSJ_14.kicad_mod'
VERIFY=HW/'pcb/integration/verification'


def f(v):
    return format(float(v),'.8f').rstrip('0').rstrip('.') if v else '0'


def rot(point):
    # Rotate drawing's long horizontal axis into KiCad's vertical body axis.
    # Pin1 stays upper-left, as in TPS63020 top-view pin diagram.
    x,y=point
    return (-y,x)


def poly(points):
    return '(gr_poly (pts '+' '.join(f'(xy {f(x)} {f(y)})' for x,y in points)+') (width 0) (fill yes))'


def area(points):
    return abs(sum(a[0]*b[1]-b[0]*a[1] for a,b in zip(points,points[1:]+points[:1])))/2


def generate():
    LIB.mkdir(parents=True,exist_ok=True)
    rects=[]
    for side in [-1,1]:
        for y in [-.69,-.23,.23,.69]:
            a,b=sorted([side*1.425,side*2.2])
            rects.append([(a,y-.1),(b,y-.1),(b,y+.1),(a,y+.1)])
    # Upper-right C-shaped aperture, then reflect into the other quadrants.
    base=[(.1,.13),(2.2,.13),(2.2,.33),(1.35,.33),
          (1.35,.59),(2.2,.59),(2.2,.79),(.1,.79)]
    apertures=[]
    for sx in [-1,1]:
        for sy in [-1,1]:
            vertices=[rot((sx*x,sy*y)) for x,y in base]
            center=rot((sx*.725,sy*.46))
            apertures.append({'center':center,'vertices':vertices,'area_mm2':area(vertices)})
    copper_area=2.85*1.58+8*.775*.2
    paste_area=sum(a['area_mm2'] for a in apertures)
    assert abs(copper_area-5.743)<1e-12 and abs(paste_area-4.66)<1e-12
    lines=['''(footprint "TI_DSJ_14" (version 20260206) (generator "pcbnew") (layer "F.Cu")
      (descr "TI TPS63020 DSJ VSON14; TI4210895-2/E02/16 land/stencil example, datasheetp33.0.125mm stencil;15x0.2mm thermal drills.0.4mm via lands and bottom tenting are engineering choices.3D body is generic reference only. https://www.ti.com/lit/ds/symlink/tps63020.pdf")
      (tags "TI TPS63020 DSJ VSON14 thermal vias 3x4mm")
      (property "Reference" "REF**" (at 0 -3) (layer "F.SilkS") (effects (font (size 1 1) (thickness 0.15))))
      (property "Value" "TI_DSJ_14" (at 0 3) (layer "F.Fab") (effects (font (size 1 1) (thickness 0.15))))
      (attr smd)
      (duplicate_pad_numbers_are_jumpers no)
      (fp_rect (start -1.95 -2.45) (end 1.95 2.45) (stroke (width 0.05) (type solid)) (fill no) (layer "F.CrtYd"))
      (fp_line (start -1.5 -1.65) (end -1.15 -2) (stroke (width 0.1) (type solid)) (layer "F.Fab"))
      (fp_line (start -1.15 -2) (end 1.5 -2) (stroke (width 0.1) (type solid)) (layer "F.Fab"))
      (fp_line (start 1.5 -2) (end 1.5 2) (stroke (width 0.1) (type solid)) (layer "F.Fab"))
      (fp_line (start 1.5 2) (end -1.5 2) (stroke (width 0.1) (type solid)) (layer "F.Fab"))
      (fp_line (start -1.5 2) (end -1.5 -1.65) (stroke (width 0.1) (type solid)) (layer "F.Fab"))
      (fp_text user "${REFERENCE}" (at 0 0 90) (layer "F.Fab") (effects (font (size 0.65 0.65) (thickness 0.1))))''']
    for side in [-1,1]:
        for top in [-1,1]:
            x,y=side*1.78,top*2.15
            lines.append(f'(fp_line (start {f(x)} {f(y)}) (end {f(side*1.2)} {f(y)}) (stroke (width 0.12) (type solid)) (layer "F.SilkS"))')
    lines.append('(fp_circle (center -1.9 -1.9) (end -1.82 -1.9) (stroke (width 0.1) (type solid)) (fill solid) (layer "F.SilkS"))')
    perimeter=[]
    for pin in range(1,15):
        x=-1.4 if pin<=7 else 1.4
        y=-1.5+(pin-1)*.5 if pin<=7 else 1.5-(pin-8)*.5
        perimeter.append({'pin':str(pin),'center_mm':[x,y],'size_mm':[.6,.24],'shape':'oval','mask_expansion_mm':.07})
        lines.append(f'(pad "{pin}" smd oval (at {f(x)} {f(y)}) (size 0.6 0.24) (layers "F.Cu" "F.Paste" "F.Mask") (solder_mask_margin 0.07))')
    primitives=' '.join(poly([rot(v) for v in rect]) for rect in rects)
    lines.append('(pad "15" smd custom (at 0 0) (size 1.58 2.85) (layers "F.Cu" "F.Mask") (solder_mask_margin 0.07) (zone_connect 2) (options (clearance outline) (anchor rect)) (primitives '+primitives+'))')
    for a in apertures:
        cx,cy=a['center'];local=[(x-cx,y-cy) for x,y in a['vertices']]
        lines.append(f'(pad "" smd custom (at {f(cx)} {f(cy)}) (size 0.01 0.01) (layers "F.Paste") (options (clearance outline) (anchor rect)) (primitives {poly(local)}))')
    vias=[]
    for x in [-1,-.5,0,.5,1]:
        for y in [-.5,0,.5]:
            cx,cy=rot((x,y));vias.append([cx,cy])
            lines.append(f'(pad "15" thru_hole circle (at {f(cx)} {f(cy)}) (size 0.4 0.4) (drill 0.2) (layers "*.Cu") (zone_connect 2))')
    lines.append('''(model "${KICAD10_3DMODEL_DIR}/Package_DFN_QFN.3dshapes/DFN-14-1EP_3x4mm_P0.5mm_EP1.7x3.3mm.step"
      (offset (xyz 0 0 0)) (scale (xyz 1 1 1)) (rotate (xyz 0 0 0)))\n)''')
    OUT.write_text('\n'.join(lines)+'\n')
    record={'status':'generated_pending_native_verification','footprint':str(OUT),'library_id':'Trimix_Power:TI_DSJ_14',
       'source_url':'https://www.ti.com/lit/ds/symlink/tps63020.pdf','source_pdf':'source-review/tps63020.pdf','source_page':33,'source_drawing':'4210895-2/E02/16',
       'source_sha256':hashlib.sha256((VERIFY/'source-review/tps63020.pdf').read_bytes()).hexdigest(),
       'source_interpretation':'Manufacturer example land and0.125mm stencil; not merely the package-metal core. Drawing longX maps to footprint+Y; drawing+Y maps to footprint-X.',
       'body_mm':[3,4],'pad_number_convention':'Pins1..14 as datasheet top view; EP assigned KiCad15; all15via pads also15(GND).',
       'perimeter_pads':perimeter,'EP_core_mm':[1.58,2.85],'EP_overall_bounds_mm':[-.79,-2.2,.79,2.2],
       'EP_finger_count':8,'EP_finger_size_mm':[.2,.775],'EP_copper_area_mm2':copper_area,
       'paste_apertures':apertures,'EP_paste_area_mm2':paste_area,'EP_paste_coverage_percent':100*paste_area/copper_area,'stencil_thickness_mm':.125,
       'thermal_vias':{'centres_mm':vias,'drill_mm':.2,'land_diameter_mm':.4,'top_mask':'open within exposed-pad mask','bottom_mask':'tented; noB.Mask opening in footprint'},
       'manufacturer_dimensioned':{'signal_land_mm':[.6,.24],'pitch_mm':.5,'pad_row_spacing_mm':2.8,'signal_mask_expansion_mm':.07,'minimum_signal_mask_web_mm':.12,'vias':15,'drill_mm':.2},
       'engineering_choices':['Via land diameter0.4mm/0.1mm radial annulus; manufacturer drawing specifies hole diameter but not annular copper.','Bottom via tenting; discuss via plugging/filling and stencil solder loss with assembler.','0.07mm mask expansion applied to EP also; only signal-pad mask expansion is explicitly dimensioned byTI.','Courtyard3.9x4.9mm includes0.25mm over maximum copper/body extent.','Existing generic3x4mm body STEP retained as visual reference; does not assert TI leadframe geometry.'],
       'independent_source_review':'enclosure_mechanical_inputs independently confirmed copper, vias and fourC-shaped paste polygons;81.1423% calculated coverage matches81% printed.',
       'remaining_process_gates':['Fabricator confirms0.2mm plated drills and0.1mm annular ring.','Assembler confirms0.125mm stencil process, fine-pitch mask web and thermal-via solder control.','PCB still requires low-inductance routing andthermal copper planes; footprint alone cannot verify output-load performance.'],
       'footprint_sha256':hashlib.sha256(OUT.read_bytes()).hexdigest()}
    (VERIFY/'u201-ti-dsj-footprint.json').write_text(json.dumps(record,indent=2)+'\n')
    print(OUT)
    print('EP area',copper_area,'paste',paste_area,'coverage%',100*paste_area/copper_area)


if __name__=='__main__':generate()
