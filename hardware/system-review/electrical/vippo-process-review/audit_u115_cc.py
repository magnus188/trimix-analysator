#!/usr/bin/env python3
"""Read-only hypothetical dense U115.3 via geometry; no native board edits."""
from pathlib import Path
import argparse,sys,json,hashlib,html
import sexpdata as sx
from shapely.geometry import Point,box
from shapely.ops import unary_union
sys.path.insert(0,str(Path(__file__).resolve().parents[1]/'main-final-independent'))
from cam_geometry import Native,sub,subs,polys,CU
p=argparse.ArgumentParser();p.add_argument('--board',type=Path,required=True);p.add_argument('--out',type=Path,required=True);p.add_argument('--x',type=float,default=13.6);p.add_argument('--y',type=float,default=89.775);a=p.parse_args();a.out.mkdir(parents=True,exist_ok=True)
n=Native(sx.loads(a.board.read_text()));x,y=a.x,-a.y;net='USB_CC_INT_N';disk=Point(x,y).buffer(.2,quad_segs=128);hole=Point(x,y).buffer(.1,quad_segs=128)
selected=[v for v in n.pads if v['ref']=='U115' and v['pin']=='3'];pg=unary_union([v['geo']for v in selected]);mask=unary_union([n.aperture(v,'B.Mask') for v in selected]);paste=unary_union([n.aperture(v,'B.Paste')for v in selected]);rows=[]
for layer in CU:
 items=[{'kind':'pad','id':p['id'],'net':p['net'],'geo':p['geo']}for p in n.pads_on(layer)]+[{'kind':'track','id':str(sub(raw,'uuid')[0]),'net':t['net'],'geo':t['geo']}for raw,t in zip(subs(n.raw,'segment'),n.tracks)if t['layer']==layer]+[{'kind':'via','id':v['id'],'net':v['net'],'geo':v['geo']}for v in n.vias]
 foreign=[q for q in items if q['net']!=net];near=sorted(foreign,key=lambda q:disk.distance(q['geo']))[:8]
 rows.append({'layer':layer,'nearest_foreign_items':[{'kind':q['kind'],'id':q['id'],'net':q['net'],'via_copper_gap_mm':disk.distance(q['geo']),'via_hole_gap_mm':hole.distance(q['geo'])}for q in near]})
foreignmask=[q for q in n.pads_on('B.Mask')if q['net']!=net]
near_mask=sorted(foreignmask,key=lambda q:mask.distance(n.aperture(q,'B.Mask')))[:4]
regular=[q for q in n.holes if not q['id'].startswith('via')]
basegap=min(disk.distance(q['geo'])for q in n.pads if q['ref']=='U115'and q['net']!=net)
controls={'baseline_extension_vs_U115_foreign_pad_ge_0p1':basegap>=.1-1e-6,'negative_0p5_land_fails_0p1_spacing':min(Point(x,y).buffer(.25).distance(q['geo'])for q in n.pads if q['ref']=='U115'and q['net']!=net)<.1-1e-6,'negative_opening_enlarged_to_via_disk_fails_0p15_exposed_spacing':min(mask.union(disk).distance(n.aperture(q,'B.Mask'))for q in foreignmask)<.15-1e-6,'baseline_original_mask_ge_0p15':min(mask.distance(n.aperture(q,'B.Mask'))for q in foreignmask)>=.15-1e-6,'bore_wholly_inside_U115_3_land':hole.difference(pg).area<1e-8}
rec={'status':'read-only hypothetical geometry; not native routed/DRC/CAM acceptance','source':str(a.board.resolve()),'source_sha256':hashlib.sha256(a.board.read_bytes()).hexdigest(),'candidate':{'reference':'U115','pin':'3','net':net,'position_mm':[a.x,a.y],'land_diameter_mm':.4,'drill_mm':.2,'annulus_mm':.1,'pad_uuids':[sub(q['raw'],'uuid')[0]for q in selected],'via_copper_outside_original_pad_mm2':disk.difference(pg).area,'hole_outside_original_pad_mm2':hole.difference(pg).area,'pad_mask_paste_equal':pg.symmetric_difference(mask).area<1e-10 and pg.symmetric_difference(paste).area<1e-10,'SMT_aperture_area_mm2':mask.area,'minimum_via_copper_to_regular_PTH_NPTH_hole_mm':min(disk.distance(q['geo'])for q in regular),'minimum_via_hole_to_regular_PTH_NPTH_hole_mm':min(hole.distance(q['geo'])for q in regular)},'per_layer_foreign_copper_without_pours':rows,'mask':{'instruction':'Both via faces tented as a separate via object; preserve existing B SMT pad mask/paste exactly, thus only its original opening exposes cap. Via extension remains masked. Do not enlarge mask to full via disk.','nearest_foreign_B_openings':[{'id':q['id'],'net':q['net'],'existing_aperture_gap_mm':mask.distance(n.aperture(q,'B.Mask')),'opening_to_via_extension_gap_mm':n.aperture(q,'B.Mask').distance(disk),'gap_if_full_via_opened_mm':mask.union(disk).distance(n.aperture(q,'B.Mask'))}for q in near_mask]},'negative_controls':controls,'all_controls_pass':all(controls.values()),'pours':'Existing fills are not evaluated as final because adding a through via requires fresh native refill; final ground anchors and no islands required.','native_modifications':False,'fabrication_acceptance':False,'current_or_ESD_qualification':False}
(a.out/'geometry.json').write_text(json.dumps(rec,indent=2))
# Independent B copper and aperture visual. Units transformed to downward board Y in SVG group.
win=box(x-.85,y-.85,x+.85,y+.85)
svg=['<svg xmlns="http://www.w3.org/2000/svg" width="1000" height="620" viewBox="0 0 1000 620"><rect width="1000" height="620" fill="white"/><text x="25" y="35" font-family="sans-serif" font-size="22">U115.3: hypothetical 0.40 / 0.20 mm filled, capped via</text>']
def drawgeom(g,color,opacity=1):
 for q in polys(g.intersection(win)):
  coords=' '.join(f'{(xx-(x-.85))*300:.5f},{((y+.85)-yy)*300:.5f}'for xx,yy in q.exterior.coords)
  svg.append(f'<polygon points="{coords}" fill="{color}" fill-opacity="{opacity}" stroke="#333" stroke-width="0.7"/>')
svg.append('<g transform="translate(25,70)">')
for q in n.pads_on('B.Cu'):drawgeom(q['geo'],'#edd090' if q['net']==net else '#999')
for q in n.tracks:
 if q['layer']=='B.Cu':drawgeom(q['geo'],'#edd090'if q['net']==net else'#a6a6a6')
drawgeom(disk,'#d74b24',.75);drawgeom(mask,'#ffe87c',.9);drawgeom(hole,'#277bc7',.9)
svg.append('</g>')
texts=['Gold: unchanged original solder aperture','Orange: added cap copper; extension masked','Blue: 0.20 mm filled bore','Grey: other copper','The bore is within the existing pad.','No board has been changed.','Native DRC / refill / actual CAM still required.']
for i,s in enumerate(texts):svg.append(f'<text x="565" y="{105+i*39}" font-family="sans-serif" font-size="17">{html.escape(s)}</text>')
svg.append('</svg>');(a.out/'geometry.svg').write_text(''.join(svg))
import cairosvg
cairosvg.svg2png(bytestring=''.join(svg).encode(),write_to=str(a.out/'geometry.png'))
print(json.dumps({'source_sha256':rec['source_sha256'],'candidate':rec['candidate'],'controls':controls,'nearest_per_layer':[r['nearest_foreign_items'][0]for r in rows]},indent=2))
