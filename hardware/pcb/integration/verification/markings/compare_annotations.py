"""Read-only strict board comparison, allowing explicit annotation nodes only.

Usage: python3 compare_annotations.py BEFORE AFTER OUTPUT.json
Does not load/save KiCad or modify either board. All pad, footprint placement,
model, copper, outline and project-board rule nodes remain protected.
"""
import collections, hashlib, json, re, sys
from pathlib import Path

TOKEN=re.compile(r'"(?:\\.|[^"\\])*"|[()]|[^\s()]+')
MARKING_LAYERS={'"F.SilkS"','"B.SilkS"','"F.Fab"','"B.Fab"'}
SILK={'"F.SilkS"','"B.SilkS"'}

def parse(path):
    stack=[];root=None
    for t in TOKEN.findall(path.read_text()):
        if t=='(':
            node=[]
            if stack:stack[-1].append(node)
            else:
                assert root is None
                root=node
            stack.append(node)
        elif t==')':stack.pop()
        else:stack[-1].append(t)
    assert not stack and root[0]=='kicad_pcb'
    return root

def layer(node):
    return next((q[1]for q in node if isinstance(q,list)and q and q[0]=='layer'),None)

def ref(node):
    q=next(q for q in node if isinstance(q,list)and q[:2]==['property','"Reference"'])
    return json.loads(q[2])

def allowed(node):
    if not isinstance(node,list)or not node:return False
    tag=node[0]
    if tag in {'fp_text','gr_text','gr_text_box'}and layer(node)in MARKING_LAYERS:return True
    if tag in {'fp_line','fp_arc','fp_circle','fp_rect','fp_poly','gr_line','gr_arc','gr_circle','gr_rect','gr_poly'}and layer(node)in SILK:return True
    return False

def canon(node):
    return json.dumps(node,separators=(',',':'),ensure_ascii=False)

def normalize_hidden_default_stroke(node):
    """KiCad SaveBoard serializes this previously implicit hidden-field style.

    Keep the complete property value and all other geometry/metadata protected.
    This narrowly accepts only a 0.15 mm stroke on a hidden 1.27 mm field.
    """
    if not isinstance(node,list)or not node or node[0]!='property':return node
    if ['hide','yes']not in node:return node
    result=json.loads(json.dumps(node))
    for effect in result:
        if not isinstance(effect,list)or not effect or effect[0]!='effects':continue
        for font in effect:
            if not isinstance(font,list)or not font or font[0]!='font':continue
            if ['size','1.27','1.27']in font and ['thickness','0.15']in font:
                font.remove(['thickness','0.15'])
    return result

def protected(root):
    tops=[];footprints={};annotations=[]
    for node in root[1:]:
        if not isinstance(node,list):tops.append(node);continue
        if allowed(node):annotations.append(canon(node));continue
        if node[0]=='footprint':
            reference=ref(node);items=[]
            for child in node[2:]:
                if allowed(child):annotations.append(canon(child));continue
                if isinstance(child,list)and child[:2]==['property','"Reference"']:
                    # Reference identity remains protected; only formatting,
                    # visibility, position and layer are annotation settings.
                    annotations.append(canon(child));items.append(canon(child[:3]));continue
                normalized=normalize_hidden_default_stroke(child)
                if normalized!=child:annotations.append(canon(child))
                items.append(canon(normalized))
            assert reference not in footprints
            footprints[reference]={'library':node[1],'nodes':sorted(items)}
        else:tops.append(canon(node))
    return {'board_nodes':sorted(tops),'footprints':footprints},annotations

def compare(before,after):
    a,aa=protected(parse(before));b,ba=protected(parse(after))
    refs=set(a['footprints'])|set(b['footprints']);diff=[]
    for r in sorted(refs):
        if a['footprints'].get(r)!=b['footprints'].get(r):
            av=a['footprints'].get(r,{});bv=b['footprints'].get(r,{})
            ac=collections.Counter(av.get('nodes',[]));bc=collections.Counter(bv.get('nodes',[]))
            diff.append({'ref':r,'before_library':av.get('library'),'after_library':bv.get('library'),'removed':list((ac-bc).elements()),'added':list((bc-ac).elements())})
    ac=collections.Counter(a['board_nodes']);bc=collections.Counter(b['board_nodes'])
    board_diff={'removed':list((ac-bc).elements()),'added':list((bc-ac).elements())}
    marker_a=collections.Counter(aa);marker_b=collections.Counter(ba)
    return {'status':'passed_annotation_only'if not diff and not board_diff['removed']and not board_diff['added']else'protected_geometry_or_metadata_changed','before':str(before.resolve()),'after':str(after.resolve()),'before_sha256':hashlib.sha256(before.read_bytes()).hexdigest(),'after_sha256':hashlib.sha256(after.read_bytes()).hexdigest(),'footprint_count_before':len(a['footprints']),'footprint_count_after':len(b['footprints']),'changed_protected_footprints':diff,'changed_protected_board_nodes':board_diff,'changed_annotation_nodes':{'removed':len(list((marker_a-marker_b).elements())),'added':len(list((marker_b-marker_a).elements()))},'allowlist':['Reference property formatting/position/layer/visibility; actual reference identity remains protected.','Text on front/back silk or fabrication layers.','Graphic lines/arcs/circles/rectangles/polygons on silk layers.','Explicit 0.15 mm default stroke serialization on hidden 1.27 mm property fields; property contents and all other attributes remain protected.'],'limits':'Annotation geometry and readability require independent collision, DRC and visual checks. No board edits performed.'}

if __name__=='__main__':
    before,after,out=map(Path,sys.argv[1:]);result=compare(before,after)
    out.write_text(json.dumps(result,indent=2)+'\n')
    print(json.dumps({k:result[k]for k in ('status','footprint_count_before','footprint_count_after','changed_annotation_nodes')},indent=2))
