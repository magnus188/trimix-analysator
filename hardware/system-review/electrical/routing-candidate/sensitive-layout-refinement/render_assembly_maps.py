"""Exact native pad locators for references omitted from dense silkscreen."""
from pathlib import Path
import sys,csv,json,hashlib,html,math
import sexpdata,cairosvg
from shapely.geometry import box
from shapely import affinity
D=Path(__file__).resolve().parent;O=D/'frozen-local-bundle';P=O/'hardware/pcb/analyzer/Trimix_Analyzer.kicad_pcb';OUT=O/'assembly-drawings';OUT.mkdir(exist_ok=True)
sys.path.insert(0,str(D.parents[1]/'main-final-independent'));from cam_geometry import Native,polys
n=Native(sexpdata.loads(P.read_text()));fps={f['ref']:f for f in n.fps};rows=list(csv.DictReader((O/'cam/marking-legend.csv').open()));hidden=[r for r in rows if r['Printed_reference']=='False']
def path(g,color):
 g=affinity.scale(g,1,-1,origin=(0,0));out=[]
 for p in polys(g):
  d='M'+' L'.join(f'{x:.5f},{y:.5f}'for x,y in p.exterior.coords)+'Z'
  for ring in p.interiors:d+='M'+' L'.join(f'{x:.5f},{y:.5f}'for x,y in ring.coords)+'Z'
  out.append(f'<path d="{d}" fill="{color}" fill-rule="evenodd"/>')
 return ''.join(out)
for page in range(math.ceil(len(hidden)/8)):
 parts=['<svg xmlns="http://www.w3.org/2000/svg" width="1200" height="1560" viewBox="0 0 1200 1560"><rect width="100%" height="100%" fill="white"/>',f'<text x="30" y="32" font-family="sans-serif" font-size="23">Assembly-only reference locators — {page+1}</text>','<text x="30" y="58" font-family="sans-serif" font-size="15">TOP-VIEW PCB coordinates on BOTH sides. Back locators are not mirrored assembly views.</text>','<text x="30" y="80" font-family="sans-serif" font-size="15">Confirm board side and pin 1 before assembly. Orange = target pads; grey = same-side copper context.</text>']
 for i,row in enumerate(hidden[page*8:(page+1)*8]):
  f=fps[row['Reference']];cx,cy=f['x'],-f['y'];x=30+(i%2)*590;y=110+(i//2)*360;layer='F.Cu'if f['side']=='top'else'B.Cu';clip=box(cx-4,-cy-3.4,cx+4,-cy+3.4)
  parts += [f'<rect x="{x}" y="{y}" width="560" height="340" fill="#fafafa" stroke="#ccd2d7"/>',f'<text x="{x+14}" y="{y+27}" font-size="21" font-family="sans-serif">{html.escape(row["Reference"])} · {layer} · X {cx:.3f} / Y {cy:.3f} mm</text>',f'<text x="{x+14}" y="{y+49}" font-size="14" font-family="sans-serif">{html.escape(row["Value"])} | {html.escape(row["MPN"] or "PCB feature")}</text>',f'<g transform="translate({x+280-cx*32},{y+194-cy*32}) scale(32)">']
  for t in n.tracks:
   if t['layer']==layer:parts.append(path(t['geo'].intersection(clip),'#d5ddd8'))
  for v in n.vias:parts.append(path(v['geo'].intersection(clip),'#bcc8c3'))
  for p in n.pads_on(layer):parts.append(path(p['geo'].intersection(clip),'#e58327'if p['ref']==row['Reference']else'#aeb9c0'))
  for p in n.pads_on(layer):
   if p['ref']==row['Reference']:parts.append(f'<text x="{p["x"]}" y="{-p["y"]+.12}" text-anchor="middle" font-size=".3" fill="#101820" font-family="sans-serif">{html.escape(p["pin"])}</text>')
  parts += ['</g>',f'<text x="{x+14}" y="{y+324}" font-size="13" font-family="sans-serif">8 × 6.8 mm local window; part/feature centred at the listed native origin.</text>']
 parts.append('</svg>');p=OUT/f'assembly-only-locators-{page+1}.svg';p.write_text(''.join(parts));cairosvg.svg2png(url=str(p),write_to=str(p.with_suffix('.png')))
(OUT/'locator-receipt.json').write_text(json.dumps({'board_sha256':hashlib.sha256(P.read_bytes()).hexdigest(),'unprinted_reference_count':len(hidden),'references':[r['Reference']for r in hidden],'coordinates':'Top-view native PCB X/Y for both sides; not mirrored rear assembly. Actual exported copper context and native target pads only.','printed_references':'See source-matched CAM silkscreen and marking-legend.csv for141 printed references.','order_release':False},indent=2)+'\n')
print(len(hidden),'hidden-reference locators rendered')
