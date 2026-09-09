"""Synchronize approved LDO value/DNP/NC metadata only; never move copper.

Use KiCad MCP Python for sexpdata. Run after a fresh native XML netlist.
Only four existing footprint blocks and new net declarations may change.
"""
from pathlib import Path
import copy
import json
import sys
import xml.etree.ElementTree as ET
ROOT=Path(__file__).resolve().parents[3]
sys.path.insert(0,str(ROOT/'hardware/tools'))
from analyzer_sheet import sx, child, children, tag, node, S, fmt
sys.path.insert(0,str(Path(__file__).resolve().parent))
from apply_review_fixes import top_blocks

OUT=Path(__file__).resolve().parent
path=ROOT/'hardware/pcb/analyzer/Trimix_Analyzer.kicad_pcb'
raw=path.read_text();a=sx.loads(raw);before=copy.deepcopy(a)
xml=ET.parse(OUT/'analyzer-netlist.xml').getroot()
comp={c.get('ref'):c for c in xml.findall('./components/comp')}
nets={(n.get('ref'),n.get('pin')):net.get('name') for net in xml.findall('./nets/net') for n in net.findall('node')}
codes={n[2]:int(n[1]) for n in children(a,'net')}
legacy_codes=bool(codes)
nextcode=max(codes.values(),default=0)+1
changed={}
for f in children(a,'footprint'):
    p={v[1]:v for v in children(f,'property')};ref=p['Reference'][2]
    if ref not in {'U501','U702','C503','C706'}:continue
    p['Value'][2]=comp[ref].findtext('value')
    if ref.startswith('U'):
        p['Datasheet'][2]='https://www.ti.com/lit/ds/symlink/tps7a20.pdf'
        if 'Description' in p:p['Description'][2]='TI low-noise3.0V300mA LDO; pin4 NC; ceramic stable'
    else:
        attr=child(f,'attr')
        if S('dnp') not in attr:attr.append(S('dnp'))
    for pad in children(f,'pad'):
        name=nets[(ref,pad[1])]
        if legacy_codes and name not in codes:
            codes[name]=nextcode;nextcode+=1;a.append(node('net',codes[name],name))
        child(pad,'net')[1:]=[codes[name],name] if legacy_codes else [name]
        if ref.startswith('U') and pad[1]=='4':
            if child(pad,'pinfunction') is not None:child(pad,'pinfunction')[1]='NC'
            if child(pad,'pintype') is not None:child(pad,'pintype')[1]='no_connect'
    changed[ref]=f
# Replace only approved footprint blocks, retaining all unrelated bytes.
replacements=[]
for start,end,block in top_blocks(raw):
    if not block.startswith('(footprint '):continue
    old=sx.loads(block);p={v[1]:v for v in children(old,'property')};ref=p['Reference'][2]
    if ref in changed:replacements.append((start,end,fmt(changed[ref],1)))
assert len(replacements)==4
for start,end,content in sorted(replacements,reverse=True):raw=raw[:start]+content+raw[end:]
oldnames={n[2] for n in children(before,'net')}
newnets=[n for n in children(a,'net') if n[2] not in oldnames]
pos=raw.rfind(')');raw=raw[:pos]+''.join('\t'+fmt(n,1)+'\n' for n in newnets)+raw[pos:]
after=sx.loads(raw)
oldfps={next(p[2] for p in children(f,'property') if p[1]=='Reference'):f for f in children(before,'footprint')}
newfps={next(p[2] for p in children(f,'property') if p[1]=='Reference'):f for f in children(after,'footprint')}
assert oldfps.keys()==newfps.keys()
for ref in oldfps:
    if ref not in changed:assert oldfps[ref]==newfps[ref],ref
    else:
        # All geometric and graphical fields are protected even on changed parts.
        for key in ('at','layer','uuid','model','fp_line','fp_rect','fp_circle','fp_arc','fp_poly'):
            assert children(oldfps[ref],key)==children(newfps[ref],key),(ref,key)
        for p,q in zip(children(oldfps[ref],'pad'),children(newfps[ref],'pad')):
            for key in ('at','size','layers','drill','roundrect_rratio','uuid'):
                assert children(p,key)==children(q,key),(ref,p[1],key)
path.write_text(raw)
print(json.dumps({'changed_existing_refs':sorted(changed),'new_unconnected_nets':len(newnets),'all_existing_positions_pad_geometry_copper_and_models_preserved':True}))
