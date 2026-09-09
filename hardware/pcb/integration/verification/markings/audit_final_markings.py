"""Read-only saved-board and output-reference audit. Uses KiCad's bundled Python."""
from pathlib import Path
import collections,csv,hashlib,json,math,datetime
import pcbnew as p
from compare_annotations import compare

BASE=Path(__file__).resolve().parent
ROOT=BASE.parents[4]
BOARDS={'main':ROOT/'hardware/pcb/analyzer/Trimix_Analyzer.kicad_pcb','usb':ROOT/'hardware/pcb/usb-input/Trimix_USB_Input.kicad_pcb'}

def sha(path):return hashlib.sha256(path.read_bytes()).hexdigest()
def bbox(shape):
    q=shape.BBox()
    return [p.ToMM(q.GetX()),p.ToMM(q.GetY()),p.ToMM(q.GetRight()),p.ToMM(q.GetBottom())]
def circle_box_gap(box,x,y,r):
    return math.hypot(max(box[0]-x,x-box[2],0),max(box[1]-y,y-box[3],0))-r

def run():
    report={'generated_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'boards':{},'visual_review':'pending'}
    guard=json.loads((BASE/'source-guard-before.json').read_text())
    report['source_schematic_project_changes']=[q for q,digest in guard.items()if sha(ROOT/q)!=digest]
    csv_path=ROOT/'hardware/pcb/integration/reference/COMPONENT_REFERENCE.csv'
    with csv_path.open(newline='',encoding='utf-8-sig')as f:reader=csv.DictReader(f);csv_rows=list(reader)
    report['csv_columns']=reader.fieldnames
    for name,path in BOARDS.items():
        b=p.LoadBoard(str(path));comparison=compare(BASE/(name+'-before-markings.kicad_pcb'),path)
        (BASE/(name+'-annotation-only.json')).write_text(json.dumps(comparison,indent=2)+'\n')
        receipt=json.loads((BASE/(name+'-labels.json')).read_text());references={r['reference']:r for r in receipt['references']}
        fields=[];failures=[];nph=[];holes=[];hole_gaps=[];head_gaps=[]
        for fp in b.GetFootprints():
            for pad in fp.Pads():
                if pad.GetAttribute()==p.PAD_ATTRIB_NPTH:
                    dr=pad.GetDrillSize();pos=pad.GetPosition()
                    assert dr.x==dr.y,'Noncircular NPTH requires a native slot-shape audit.'
                    nph.append((fp.GetReference(),p.ToMM(pos.x),p.ToMM(pos.y),p.ToMM(dr.x)/2))
            f=fp.Reference();ref=fp.GetReference();bounds=bbox(f.GetEffectiveTextShape())
            side='front'if f.GetLayer()==p.F_SilkS else'back'if f.GetLayer()==p.B_SilkS else'other'
            row={'ref':ref,'side':side,'visible':f.IsVisible(),'text':f.GetText(),'font_size_mm':[p.ToMM(f.GetTextSize().x),p.ToMM(f.GetTextSize().y)],'stroke_mm':p.ToMM(f.GetTextThickness()),'mirrored':f.IsMirrored(),'ink_bounds_mm':bounds}
            fields.append(row)
            if not f.IsVisible()or f.GetText()!=ref or side=='other' or row['font_size_mm']!=[1.,1.]or abs(row['stroke_mm']-.15)>1e-8 or f.IsMirrored()!=(side=='back'):failures.append({'ref':ref,'issue':'visibility/string/size/stroke/layer/mirroring'})
            r=references.get(ref)
            if not r or r['side']!=side or max(abs(x-y)for x,y in zip(bounds,r['ink_bounds_mm']))>1e-5:failures.append({'ref':ref,'issue':'saved-field/receipt mismatch'})
        for row in fields:
            for href,x,y,r in nph:
                hole_gap=circle_box_gap(row['ink_bounds_mm'],x,y,r)
                head_gap=circle_box_gap(row['ink_bounds_mm'],x,y,2.5)if href in {'H1','H2'}else None
                hole_gaps.append(hole_gap)
                if head_gap is not None:head_gaps.append(head_gap)
                if hole_gap<.2-1e-6 or(head_gap is not None and head_gap<-.000001):failures.append({'ref':row['ref'],'hole':href,'hole_gap_mm':hole_gap,'head_gap_mm':head_gap})
                if row['ref']==href:holes.append({'ref':href,'hole_edge_clearance_mm':hole_gap,'head_reserve_clearance_mm':head_gap})
        drc={}
        for key in ('violations','unconnected_items','schematic_parity','ignored_checks'):
            old=json.loads((BASE.parent/(name+'-drc.json')).read_text());new=json.loads((BASE/(name+'-drc.json')).read_text())
            a=collections.Counter(json.dumps(q,sort_keys=True)for q in old.get(key,[]));c=collections.Counter(json.dumps(q,sort_keys=True)for q in new.get(key,[]))
            drc[key]={'before':len(old.get(key,[])),'after':len(new.get(key,[])),'added':list((c-a).elements()),'removed':list((a-c).elements())}
        report['boards'][name]={'board_sha256':sha(path),'annotation_comparison':comparison['status'],'receipt_hash_matches':receipt['after_sha256']==sha(path),'visible_reference_count':sum(f['visible']for f in fields),'side_counts':dict(collections.Counter(f['side']for f in fields)),'native_field_checks':failures,'mounting_hole_reference_clearances':holes,'all_reference_NPTH_head_checks':{'NPTH_circle_count':len(nph),'reference_circle_tests':len(hole_gaps),'minimum_hole_edge_clearance_mm':min(hole_gaps)if hole_gaps else None,'minimum_head_reserve_clearance_mm':min(head_gaps)if head_gaps else None,'all_references_clear_of_NPTH':all(x>=.2-1e-6 for x in hole_gaps),'all_references_clear_of_head_reserves':all(x>=-1e-6 for x in head_gaps)},'native_fields':fields,'DRC_delta':drc,'raw_report_file':str((BASE/(name+'-drc.json')).relative_to(ROOT))}
    csv_expected={(('Main'if name=='main'else'USB'),q['ref'],q['side'].title())for name,r in report['boards'].items()for q in r['native_fields']}
    csv_actual={(q['board'],q['reference'],q['silkscreen_side'])for q in csv_rows}
    report['CSV_reference_and_side_match']=csv_actual==csv_expected and len(csv_rows)==len(csv_expected)
    report['technical_status']='passed'if report['CSV_reference_and_side_match']and not report['source_schematic_project_changes']and all(r['annotation_comparison']=='passed_annotation_only'and r['receipt_hash_matches']and not r['native_field_checks']and all(not d['added']and not d['removed']for d in r['DRC_delta'].values())for r in report['boards'].values())else'needs_review'
    (BASE/'final-independent-audit.json').write_text(json.dumps(report,indent=2)+'\n')
    print(json.dumps({'technical_status':report['technical_status'],'boards':{k:{x:r[x]for x in ['visible_reference_count','side_counts','native_field_checks','mounting_hole_reference_clearances']}for k,r in report['boards'].items()}},indent=2))

if __name__=='__main__':run()
