"""Place readable PCB references without changing electrical or mechanical data.

Run with KiCad's bundled Python. Use two silkscreen sides when the front is
crowded, preserve polarity graphics, and save through a private staged file.
"""
from pathlib import Path
import json, hashlib, math, shutil, re
import pcbnew as p

BASE=Path(__file__).resolve().parents[1]
HW=BASE.parents[1]
OUT=BASE/'verification/markings'
BOARDS={'main':HW/'pcb/analyzer/Trimix_Analyzer.kicad_pcb',
        'usb':HW/'pcb/usb-input/Trimix_USB_Input.kicad_pcb'}
SIZE=1.0
STROKE=.15
MASK_GAP=.20
INK_GAP=.20
EDGE_GAP=.25

def sha(path):return hashlib.sha256(path.read_bytes()).hexdigest()
def v(x,y):return p.VECTOR2I(p.FromMM(x),p.FromMM(y))
def bbox(shape):
    q=shape.BBox() if hasattr(shape,'BBox') else shape.GetBoundingBox()
    return [p.ToMM(q.GetX()),p.ToMM(q.GetY()),p.ToMM(q.GetRight()),p.ToMM(q.GetBottom())]
def grow(b,d):return [b[0]-d,b[1]-d,b[2]+d,b[3]+d]
def overlap(a,b):return a[0]<b[2] and b[0]<a[2] and a[1]<b[3] and b[1]<a[3]
def polyrect(b):
    q=p.SHAPE_POLY_SET();q.NewOutline()
    for x,y in [(b[0],b[1]),(b[2],b[1]),(b[2],b[3]),(b[0],b[3])]:q.Append(v(x,y))
    return q
def centre(b):return [(b[0]+b[2])/2,(b[1]+b[3])/2]
def union(rects):return [min(b[0] for b in rects),min(b[1] for b in rects),max(b[2] for b in rects),max(b[3] for b in rects)]

def run(name,path):
    board=p.LoadBoard(str(path));before=sha(path)
    backup=OUT/(name+'-before-markings.kicad_pcb')
    if not backup.exists():shutil.copy2(path,backup)
    old=OUT/(name+'-labels.json')
    if old.exists():
        ids=set(json.loads(old.read_text()).get('owned_drawing_ids',[]))
        for d in list(board.GetDrawings()):
            if d.m_Uuid.AsString() in ids:board.Remove(d)
    protected={str(x):sha(x) for x in path.parent.glob('*.kicad_pro')}
    fps={f.GetReference():f for f in board.GetFootprints()}
    outline=p.SHAPE_POLY_SET()
    if not board.GetBoardPolygonOutlines(outline,False):raise RuntimeError('Invalid board outline')
    obstacles={p.F_SilkS:[],p.B_SilkS:[]};maskboxes={p.F_SilkS:[],p.B_SilkS:[]}
    targets={};bodyboxes=[]
    for ref,fp in fps.items():
        fp.BuildCourtyardCaches();court=fp.GetCourtyard(p.F_Cu)
        target=bbox(court) if court.OutlineCount() else union([bbox(q) for q in fp.Pads()])
        targets[ref]=target
        physical=[]
        for g in fp.GraphicalItems():
            if isinstance(g,p.PCB_SHAPE) and g.GetLayer()==p.F_Fab:physical.append(bbox(g))
            if g.GetLayer() in obstacles and isinstance(g,p.PCB_SHAPE):obstacles[g.GetLayer()].append(grow(bbox(g),INK_GAP))
        if physical:
            body=union(physical);bodyboxes.append(body);obstacles[p.F_SilkS].append(grow(body,.15))
        for q in fp.Pads():
            # NPTH holes may intentionally have no solder-mask layer flags.
            # Their physical drilled area still removes ink on BOTH faces.
            if q.GetDrillSize().x or q.GetDrillSize().y:
                drilled=grow(bbox(q),MASK_GAP)
                if ref in ('H1','H2'):
                    x,y=p.ToMM(q.GetPosition().x),p.ToMM(q.GetPosition().y)
                    drilled=[x-2.7,y-2.7,x+2.7,y+2.7] # Ø5 head reserve +0.20 ink gap
                for layer in obstacles:obstacles[layer].append(drilled)
            for layer,mask in [(p.F_SilkS,p.F_Mask),(p.B_SilkS,p.B_Mask)]:
                if q.IsOnLayer(mask):
                    expanded=grow(bbox(q),MASK_GAP+p.ToMM(q.GetSolderMaskExpansion(mask)))
                    obstacles[layer].append(expanded);maskboxes[layer].append(expanded)
        # Reference fields are placed afresh. Other fields and copper stay intact.
        fp.Reference().SetVisible(False)
    for g in board.GetDrawings():
        if g.GetLayer() in obstacles:
            if isinstance(g,p.PCB_TEXT):
                if g.IsVisible():obstacles[g.GetLayer()].append(grow(bbox(g.GetEffectiveTextShape()),INK_GAP))
            elif isinstance(g,p.PCB_SHAPE):obstacles[g.GetLayer()].append(grow(bbox(g),INK_GAP))
    occupied={p.F_SilkS:[],p.B_SilkS:[]};placed=[];missing=[];owned=[]
    def inside(box):
        q=polyrect(grow(box,EDGE_GAP));q.BooleanSubtract(outline)
        return q.Area()<=1
    def glyph(t,layer,angle):
        t.SetLayer(layer);t.SetTextSize(v(SIZE,SIZE));t.SetTextThickness(p.FromMM(STROKE))
        t.SetKeepUpright(False);t.SetTextAngle(p.EDA_ANGLE(angle,p.DEGREES_T));t.SetMirrored(layer==p.B_SilkS)
        t.SetPosition(v(0,0));t.SetVisible(True)
        return bbox(t.GetEffectiveTextShape())
    def try_place(t,target,layer,max_drift=4,count_only=False):
        anchor=centre(target);candidates=[]
        for angle in (0,90):
            off=glyph(t,layer,angle);w=off[2]-off[0];h=off[3]-off[1]
            # Work in actual ink-bounding-box centres, not selection-box metrics.
            positions=[anchor]
            for delta in (0,-.5,.5,-1,1,-1.5,1.5):
                positions.extend([(anchor[0]+delta,target[1]-h/2-.25),(anchor[0]+delta,target[3]+h/2+.25),
                                  (target[0]-w/2-.25,anchor[1]+delta),(target[2]+w/2+.25,anchor[1]+delta)])
            n=int(max_drift/.25)
            positions.extend((anchor[0]+ix*.25,anchor[1]+iy*.25) for ix in range(-n,n+1) for iy in range(-n,n+1))
            for x,y in positions:
                box=[x-w/2,y-h/2,x+w/2,y+h/2]
                # Labels remain local to their part; drawing maps resolve dense regions.
                score=math.hypot(x-anchor[0],y-anchor[1]) + (.12 if angle else 0)
                candidates.append((score,angle,x,y,box,off))
        feasible=0
        for _,angle,x,y,box,off in sorted(candidates,key=lambda r:r[0]):
            if any(overlap(box,q) for q in obstacles[layer]) or any(overlap(grow(box,INK_GAP),q) for q in occupied[layer]):continue
            if not inside(box):continue
            if count_only:
                feasible+=1
                continue
            glyph(t,layer,angle)
            pos=[x-(off[0]+off[2])/2,y-(off[1]+off[3])/2];t.SetPosition(v(*pos));t.SetVisible(True)
            actual=bbox(t.GetEffectiveTextShape())
            if any(abs(a-b)>1e-5 for a,b in zip(actual,box)):raise RuntimeError('Unexpected text transformation '+str((t.GetText(),angle,layer,pos,actual,box)))
            occupied[layer].append(actual)
            return {'side':'front' if layer==p.F_SilkS else 'back','layer':p.LayerName(layer),'position_mm':pos,'angle_deg':angle,'ink_bounds_mm':actual,'distance_from_part_centre_mm':math.hypot(x-anchor[0],y-anchor[1])}
        t.SetVisible(False)
        if count_only:return feasible
        return None
    def priority(ref):
        prefix=re.match(r'[A-Za-z]+',ref).group()
        rank={'TP':0,'J':1,'H':2,'U':3,'RN':3,'RV':3,'SW':3,'L':4,'D':4,'Q':4,'R':5,'C':5}.get(prefix,6)
        near=sum(overlap(grow(targets[ref],2),q) for q in bodyboxes)
        return (rank,-near,targets[ref][1],targets[ref][0])
    # Front first for service interfaces; every remaining reference gets a local
    # mirrored back label instead of reducing type size below the baseline.
    back=[]
    for ref in sorted(fps,key=priority):
        t=fps[ref].Reference();result=try_place(t,targets[ref],p.F_SilkS,3)
        if result is None:back.append(ref)
        else:placed.append({'reference':ref,**result})
    freedom={ref:try_place(fps[ref].Reference(),targets[ref],p.B_SilkS,3,True) for ref in back}
    for ref in sorted(back,key=lambda r:(0 if r=='SW101' else 1,freedom[r],priority(r))):
        result=try_place(fps[ref].Reference(),targets[ref],p.B_SilkS,3)
        if result is None:missing.append(ref)
        else:placed.append({'reference':ref,**result})
    for ref in list(missing):
        result=try_place(fps[ref].Reference(),targets[ref],p.B_SilkS,6)
        if result:placed.append({'reference':ref,**result});missing.remove(ref)
    # Dense two-sided boards may need a reference under a package body.
    # Copper/mask and ink clearances still apply; the assembly map remains
    # necessary after population. Preserve the1mm type size.
    if missing:
        saved_obstacles=list(obstacles[p.F_SilkS])
        covered=[grow(q,.15)for q in bodyboxes]
        obstacles[p.F_SilkS]=[q for q in obstacles[p.F_SilkS]if q not in covered]
        for ref in list(missing):
            result=try_place(fps[ref].Reference(),targets[ref],p.F_SilkS,6)
            if result:
                placed.append({'reference':ref,**result,'assembly_obscured_possible':True});missing.remove(ref)
        obstacles[p.F_SilkS]=saved_obstacles
    if missing:
        (OUT/(name+'-placement-attempt.json')).write_text(json.dumps({'placed':placed,'missing':missing},indent=2)+'\n')
        for ref in missing:
            t=fps[ref].Reference();t.SetVisible(False)
        # Preserve1mm manufacturing text; explicitly record assembly-map-only refs.

    # Short board identity: values and explanatory text belong in the companion key.
    for label,target in ([('TMX A3',[.5,.5,8.1,3.5])] if name=='main' else []):
        t=p.PCB_TEXT(board);t.SetText(label);board.Add(t)
        result=try_place(t,target,p.F_SilkS,1) or try_place(t,target,p.B_SilkS,1)
        if not result:board.Remove(t)
        else:owned.append(t.m_Uuid.AsString())
    staged=OUT/'staged';staged.mkdir(exist_ok=True)
    stage=staged/path.name;p.SaveBoard(str(stage),board)
    if protected!={str(x):sha(x) for x in path.parent.glob('*.kicad_pro')}:raise RuntimeError('Project settings changed')
    shutil.copy2(stage,path)
    data={'board':str(path),'before_sha256':before,'after_sha256':sha(path),'font_height_mm':SIZE,'stroke_mm':STROKE,
          'mask_gap_mm':MASK_GAP,'minimum_text_gap_mm':INK_GAP,'edge_gap_mm':EDGE_GAP,
          'references':placed,'missing':missing,'assembly_map_only':missing,'owned_drawing_ids':owned,
          'front_count':sum(x['side']=='front' for x in placed),'back_count':sum(x['side']=='back' for x in placed),
          'scope':'Reference fields and owned silkscreen text only; component poses, pads, nets, copper, holes and Edge.Cuts preserved.',
          'back_labels':'Mirrored on B.SilkS so they read normally when viewing the reverse of the bare board.',
          'mounting_clearance':'NPTH drill obstacles included explicitly; H1/H2 have a conservative Ø5mm screw-head reserve plus0.20mm ink clearance on both faces.',
          'body_clearance_basis':'Front physical-envelope proxy from F.Fab geometry; mask openings checked separately. Actual purchased modules remain provisional.'}
    (OUT/(name+'-labels.json')).write_text(json.dumps(data,indent=2)+'\n')
    print(name, data['front_count'],'front',data['back_count'],'back')

if __name__=='__main__':
    OUT.mkdir(parents=True,exist_ok=True)
    for name,path in BOARDS.items():run(name,path)
