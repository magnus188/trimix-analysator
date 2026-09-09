#!/usr/bin/env python3
"""Independent actual CAM byte checks for the exact U115.3 POFV proposal."""
from pathlib import Path
import sys,json,hashlib,math,warnings,collections
import sexpdata as sx
from gerbonara import GerberFile,ExcellonFile
from shapely.geometry import Point,box
from shapely.ops import unary_union
sys.path.insert(0,str(Path(__file__).resolve().parents[1]/'main-final-independent'))
from cam_geometry import Native,sub,subs,geometry,attrs,SHAPE_EPS,polys
P=Path(__file__).resolve().parent/'native-v3-independent';B=P/'baseline';board=B/'Trimix_Analyzer.kicad_pcb';sourcehash=hashlib.sha256(board.read_bytes()).hexdigest();assert sourcehash=='d490110c6335a6594a8d2171386926c65a95e0f8ba729feb378c478e8a676a63'
n=Native(sx.loads(board.read_text()));viaid='b3d6a73a-b389-4126-b3c4-3d28ea9ea384';v=next(v for v in subs(n.raw,'via')if sub(v,'uuid')==[viaid]);disk=Point(13.6,-89.775).buffer(.2,quad_segs=128);hole=Point(13.6,-89.775).buffer(.1,quad_segs=128);pad=next(p for p in n.pads if p['ref']=='U115'and p['pin']=='3');checks=[]
def ck(name,ok,detail=None):checks.append({'check':name,'passed':bool(ok),'detail':detail})
def load(case):
 C=P/case/'cam';S={'F.Cu':'.gtl','In1.Cu':'.g1','In2.Cu':'.g2','B.Cu':'.gbl','F.Mask':'.gts','B.Mask':'.gbs','F.Paste':'.gtp','B.Paste':'.gbp'};return{l:GerberFile.open(next(C.glob('*'+ext)))for l,ext in S.items()}
with warnings.catch_warnings(record=True)as wr:
 warnings.simplefilter('always');G=load('baseline');NG=load('fully-opened-via');DR={f.name:ExcellonFile.open(f)for f in (B/'cam').glob('*.drl')}
warn=[str(w.message)for w in wr]
geo={id(o):geometry(o)for g in [*G.values(),*NG.values()]for o in g.objects}
def un(g):return unary_union([geo[id(o)]for o in g.objects if o.polarity_dark])
for layer in ['F.Cu','In1.Cu','In2.Cu','B.Cu']:
 matches=[o for o in G[layer].objects if type(o).__name__=='Flash'and math.dist((o.x,o.y),(13.6,-89.775))<.000002 and attrs(o).get('.N')==('USB_CC_INT_N',)and geo[id(o)].hausdorff_distance(disk)<SHAPE_EPS]
 ck(layer+' has one exact 0.40 mm CC via land',len(matches)==1,{'count':len(matches)})
for layer in ['B.Mask','B.Paste']:
 matches=[o for o in G[layer].objects if type(o).__name__=='Flash'and attrs(o).get('.C')==('U115',)and math.dist((o.x,o.y),(pad['x'],pad['y']))<.000002]
 ck(layer+' original U115.3 aperture geometry',len(matches)==1 and geo[id(matches[0])].hausdorff_distance(n.aperture(pad,layer))<SHAPE_EPS,{'count':len(matches),'expected_area_mm2':n.aperture(pad,layer).area,'actual_area_mm2':None if not matches else geo[id(matches[0])].area})
 actual=un(G[layer]).intersection(disk);expected=n.aperture(pad,layer).intersection(disk)
 ck(layer+' exposes no cap extension',actual.symmetric_difference(expected).area<1e-6,{'difference_mm2':actual.symmetric_difference(expected).area})
for layer in ['F.Mask','F.Paste']:
 area=un(G[layer]).intersection(disk).area;ck(layer+' has no opening over the via',area<1e-10,{'area_mm2':area})
ck('Via native process intent explicitly filled/capped and both faces tented',sub(v,'capping')==[sx.Symbol('yes')]and sub(v,'filling')==[sx.Symbol('yes')]and sub(next(q for q in v if isinstance(q,list)and str(q[0])=='tenting'),'front')==[sx.Symbol('yes')]and sub(next(q for q in v if isinstance(q,list)and str(q[0])=='tenting'),'back')==[sx.Symbol('yes')])
hits=[]
for name,g in DR.items():
 for o in g.objects:
  if math.dist((o.x,o.y),(13.6,-89.775))<.000002:hits.append({'file':name,'diameter_mm':o.tool.diameter})
ck('Exactly one 0.20 mm plated drill hit',len(hits)==1 and hits[0]['file'].endswith('-PTH.drl')and abs(hits[0]['diameter_mm']-.2)<1e-9,hits)
# Byte-level deliberately opened counterexample: copper/paste preserved, mask violates contract.
for layer in ['F.Cu','In1.Cu','In2.Cu','B.Cu','F.Paste','B.Paste']:
 a=un(G[layer]);z=un(NG[layer]);ck('Opened-via control leaves '+layer+' geometry unchanged',a.symmetric_difference(z).area<1e-7)
fm=un(NG['F.Mask']).intersection(disk).area;bm=un(NG['B.Mask']).intersection(disk).difference(n.aperture(pad,'B.Mask')).area
ck('Opened-via negative control adds forbidden F opening',fm>.12,{'added_area_mm2':fm})
ck('Opened-via negative control exposes B cap extension',bm>.032,{'added_area_mm2':bm})
# Native rule controls specifically identify the proposed via UUID; retain unrelated failures.
def mentions(v):return any(i.get('uuid')==viaid for i in v['items'])
reports={case:json.loads((P/case/'drc.json').read_text())for case in ['baseline','no-local-clearance-rule','oversized-land','shifted-via']}
ck('Native baseline has no violation involving exact CC via',not any(mentions(v)for v in reports['baseline']['violations']))
selected=[v for v in reports['no-local-clearance-rule']['violations']if mentions(v)];ck('Removing only local clearance rule exposes three expected pad errors',len(selected)==3 and all(v['type']=='clearance'for v in selected),[v['description']for v in selected])
selected=[v for v in reports['oversized-land']['violations']if mentions(v)];ck('Oversized-land native control fails exact maximum and copper spacing',any(v['type']=='via_diameter'and'max diameter 0.4000'in v['description']for v in selected)and any(v['type']=='clearance'for v in selected))
selected=[v for v in reports['shifted-via']['violations']if mentions(v)];ck('Moving via 0.01 mm loses its coordinate-scoped permissions',any(v['type']=='via_diameter'and'min diameter 0.4500'in v['description']for v in selected)and any(v['type']=='clearance'for v in selected))
# Assert the single-rule deletion really leaves all other source text intact.
s=(B/'Trimix_Analyzer.kicad_dru').read_text();t=(P/'no-local-clearance-rule/Trimix_Analyzer.kicad_dru').read_text();import re
pattern=r'\(rule "U115 AUXOFF masked via extension to adjacent manufacturer lands"\n \(layer "B.Cu"\)\n \(condition [^\n]+\n \(constraint clearance \(min 0.12mm\)\)\)'
expected,count=re.subn(pattern,'',s);ck('Single-rule control removes exactly one source-text block',count==1 and expected==t)
base=reports['baseline'];inherited=[v for v in base['violations']if v['type'] in ['clearance','hole_clearance','shorting_items','solder_mask_bridge']]
rec={'source_sha256':sourcehash,'via_uuid':viaid,'checks':checks,'passed':sum(c['passed']for c in checks),'failed':sum(not c['passed']for c in checks),'native_baseline':{'unconnected':len(base['unconnected_items']),'parity':len(base['schematic_parity']),'violations_by_type':dict(collections.Counter(v['type']for v in base['violations'])),'inherited_C116_CHG_findings':inherited,'distinct_inherited_geometry_findings':len({(v['type'],v['description'],tuple(sorted(i['uuid'] for i in v['items']))) for v in inherited}),'duplicate_geometry_row_explanation':'--all-track-errors repeats the same hole-clearance UUID pair once; five raw rows represent four distinct findings.'},'parser_warnings':warn,'scope':'Exact CC escape process, rule counterexamples and local CAM only. Unrelated remaining C116/CHG collision, three opens and silkscreen/dangling findings are not accepted here.','fabrication_release':False,'fabricator_or_assembler_acceptance':False,'no_authoritative_changes':True,'inputs':{str(f.relative_to(P)):hashlib.sha256(f.read_bytes()).hexdigest()for folder in [B/'cam',P/'fully-opened-via/cam']for f in folder.iterdir()if f.is_file()}}
(P/'independent-cam-and-controls.json').write_text(json.dumps(rec,indent=2));print(json.dumps({'passed':rec['passed'],'failed':rec['failed'],'unconnected':rec['native_baseline']['unconnected'],'failed_checks':[c for c in checks if not c['passed']]},indent=2))
