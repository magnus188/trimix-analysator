"""Make an enlarged front assembly map; never save changes to the source board.

Use KiCad's bundled Python. Digital-map labels are smaller than manufactured
silkscreen and identify every footprint from the component side.
"""
from pathlib import Path
import math, json, hashlib, subprocess, re
import pcbnew as p
from add_board_markings import bbox, centre, grow, overlap, polyrect, v, union

BASE = Path(__file__).resolve().parents[1]
SOURCE = BASE.parent/'analyzer/Trimix_Analyzer.kicad_pcb'
OUT = BASE/'reference'
STAGE = BASE/'verification/markings/map-staged'
CLI = '/Applications/KiCad/KiCad.app/Contents/MacOS/kicad-cli'

def sha(path): return hashlib.sha256(path.read_bytes()).hexdigest()

def main(side="front"):
    is_back = side == "back"
    cu = p.B_Cu if is_back else p.F_Cu
    fab = p.B_Fab if is_back else p.F_Fab
    before = sha(SOURCE)
    for name,path in [('main',SOURCE),('usb',BASE.parent/'usb-input/Trimix_USB_Input.kicad_pcb')]:
        for side,prefix in [('front','F'),('back','B')]:
            args=[CLI,'pcb','export','svg','--layers',f'{prefix}.Cu,{prefix}.SilkS,Edge.Cuts','--mode-single','--fit-page-to-board','--exclude-drawing-sheet','--output',str(OUT/f'{name}-{side}.svg')]
            if side=='back': args.append('--mirror')
            subprocess.run(args+[str(path)],check=True)
    board = p.LoadBoard(str(SOURCE))
    outline = p.SHAPE_POLY_SET()
    assert board.GetBoardPolygonOutlines(outline, False)
    fps = [f for f in board.GetFootprints() if f.GetLayer() == cu]
    targets = {}
    for fp in fps:
        fp.BuildCourtyardCaches()
        court = fp.GetCourtyard(cu)
        targets[fp.GetReference()] = bbox(court) if court.OutlineCount() else union([bbox(q) for q in fp.Pads()])
        fp.Value().SetVisible(False)
        for graphic in fp.GraphicalItems():
            if isinstance(graphic,p.PCB_TEXT): graphic.SetLayer(p.Dwgs_User)
    occupied = []; labels = []
    for fp in sorted(fps, key=lambda f: ((targets[f.GetReference()][2]-targets[f.GetReference()][0])*(targets[f.GetReference()][3]-targets[f.GetReference()][1]), f.GetReference())):
        ref = fp.GetReference(); target = targets[ref]; anchor = centre(target)
        t = fp.Reference(); t.SetLayer(fab); t.SetVisible(True)
        t.SetTextSize(v(.65,.65)); t.SetTextThickness(p.FromMM(.1))
        t.SetMirrored(False); t.SetKeepUpright(False)
        candidates = []
        for angle in (0,90):
            t.SetTextAngle(p.EDA_ANGLE(angle,p.DEGREES_T)); t.SetPosition(v(0,0))
            off = bbox(t.GetEffectiveTextShape()); w=off[2]-off[0]; h=off[3]-off[1]
            for ix in range(-12,13):
                for iy in range(-12,13):
                    x=anchor[0]+ix*.2; y=anchor[1]+iy*.2
                    box=[x-w/2,y-h/2,x+w/2,y+h/2]
                    # Prefer the label inside its own footprint region.
                    spill=sum(max(0,n) for n in (target[0]-box[0],target[1]-box[1],box[2]-target[2],box[3]-target[3]))
                    score=math.hypot(x-anchor[0],y-anchor[1])+spill*.6+(.05 if angle else 0)
                    candidates.append((score,angle,x,y,box,off))
        chosen=None
        for _,angle,x,y,box,off in sorted(candidates,key=lambda x:x[0]):
            if any(overlap(grow(box,.10),q) for q in occupied): continue
            q=polyrect(grow(box,.12)); q.BooleanSubtract(outline)
            if q.Area()>1: continue
            chosen=(angle,x,y,box,off); break
        if chosen is None: raise RuntimeError('No map label location: '+ref)
        angle,x,y,box,off=chosen
        t.SetTextAngle(p.EDA_ANGLE(angle,p.DEGREES_T))
        t.SetPosition(v(x-(off[0]+off[2])/2,y-(off[1]+off[3])/2))
        occupied.append(box)
        drift=math.hypot(x-anchor[0],y-anchor[1])
        if drift>.75:
            leader=p.PCB_SHAPE(board); leader.SetShape(p.SHAPE_T_SEGMENT)
            leader.SetStart(v(*anchor)); leader.SetEnd(v(x,y))
            leader.SetLayer(fab); leader.SetWidth(p.FromMM(.07)); board.Add(leader)
        labels.append({'reference':ref,'centre_mm':[x,y],'angle_deg':angle,'ink_bounds_mm':box,'drift_mm':drift})
        # Put a clean, readable digital label over the native fabrication plot.
        t.SetLayer(p.Dwgs_User)
    STAGE.mkdir(exist_ok=True)
    staged=STAGE/(side+"-"+SOURCE.name)
    p.SaveBoard(str(staged),board)
    dest=OUT/('main-back-assembly.svg' if is_back else 'main-assembly.svg')
    subprocess.run([CLI,'pcb','export','svg','--layers',('B.Fab,Edge.Cuts' if is_back else 'F.Fab,Edge.Cuts'),'--mode-single','--fit-page-to-board','--exclude-drawing-sheet','--output',str(dest),str(staged)],check=True)
    svg=dest.read_text()
    svg=re.sub(r'#[0-9A-Fa-f]{6}', '#a5b3b8', svg)
    start=svg.index('>',svg.index('<svg'))+1
    svg=svg[:start]+'<rect x="-1" y="-1" width="32" height="101" fill="white"/>'+svg[start:]
    if is_back:
        svg=svg[:start]+'<g transform="translate(30 0) scale(-1 1)">'+svg[start:]
        svg=svg.replace('</svg>','</g></svg>')
    overlay=['<g font-family="DejaVu Sans Mono, monospace" font-size="0.78" text-anchor="middle" fill="#163b4a">']
    for row in labels:
        x,y=row['centre_mm']; b=list(row['ink_bounds_mm']); ref=row['reference']
        angle = row['angle_deg']
        if is_back:
            x = 30-x
            b = [30-b[2], b[1], 30-b[0], b[3]]
            angle = -angle
        overlay.append(f'<rect x="{b[0]-.025}" y="{b[1]-.025}" width="{b[2]-b[0]+.05}" height="{b[3]-b[1]+.05}" rx=".06" fill="white"/>')
        overlay.append(f'<text transform="translate({x} {y}) rotate({-angle})" y=".27">{ref}</text>')
    overlay.append('</g>')
    svg=svg.replace('</svg>',''.join(overlay)+'</svg>')
    dest.write_text(svg)
    assert sha(SOURCE)==before, 'Source board changed'
    (BASE/('verification/markings/main-back-assembly-map.json' if is_back else 'verification/markings/main-assembly-map.json')).write_text(json.dumps({'source_board_sha256':before,'references':labels,'reference_count':len(labels),'view':side.capitalize()+' component-side assembly map. Digital labels only, not manufacturing silkscreen. Only components mounted on this face are labeled; native footprint fabrication geometry underneath. Back view mirrors the board, while labels remain readable.','source_board_unchanged':True},indent=2)+'\n')
    print('Assembly map:',len(labels),'references; max drift',max(x['drift_mm'] for x in labels))

if __name__=='__main__':
    main('front')
    main('back')
