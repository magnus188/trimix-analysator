from pathlib import Path
import sys,math,html
from gerbonara import GerberFile
from shapely.geometry import box,Point
from shapely.ops import unary_union
import cairosvg
sys.path.insert(0,str(Path(__file__).resolve().parents[1]/'main-final-independent'))
from cam_geometry import geometry,polys,attrs
P=Path(__file__).resolve().parent/'native-v3-independent';win=box(12.9,-90.6,14.5,-89.0);S=245
svg=['<svg xmlns="http://www.w3.org/2000/svg" width="1100" height="1060" viewBox="0 0 1100 1060"><rect width="1100" height="1060" fill="white"/><text x="25" y="34" font-family="sans-serif" font-size="23">Actual exported CAM — U115.3 POFV proposal and deliberate mask counterexample</text>']
def draw(g,fill,opacity=1):
 for q in polys(g.intersection(win)):
  pts=' '.join(f'{(x-12.9)*S:.4f},{(-89-y)*S:.4f}'for x,y in q.exterior.coords);svg.append(f'<polygon points="{pts}" fill="{fill}" fill-opacity="{opacity}" stroke="#555" stroke-width="0.6"/>')
def objects(case,suffix):return GerberFile.open(next((P/case/'cam').glob('*'+suffix))).objects
panels=[('baseline','.gbl','Copper: cap land extends beyond the SMT pad'),('baseline','.gbs','Accepted B mask: original pad aperture retained'),('fully-opened-via','.gbs','REJECTED control: enlarged B opening exposes cap'),('fully-opened-via','.gts','REJECTED control: extra F opening; baseline has none')]
for i,(case,suf,title)in enumerate(panels):
 ox=30+(i%2)*540;oy=90+(i//2)*470;svg.append(f'<text x="{ox}" y="{oy-15}" font-family="sans-serif" font-size="17">{html.escape(title)}</text><g transform="translate({ox},{oy})"><rect width="392" height="392" fill="#f6f7f8" stroke="#bbb"/>')
 for o in objects(case,suf):
  fill='#b5bec7'
  if suf=='.gbl'and attrs(o).get('.N')==('USB_CC_INT_N',):fill='#e29065'
  elif suf in ['.gbs','.gts']:fill='#f0cd61'if case=='baseline'else'#e78378'
  draw(geometry(o),fill)
 # Centring cross and hole outline are annotations; filled hole is not an aperture.
 c=Point(13.6,-89.775).buffer(.1,quad_segs=128);coords=' '.join(f'{(x-12.9)*S:.4f},{(-89-y)*S:.4f}'for x,y in c.exterior.coords);svg.append(f'<polygon points="{coords}" fill="none" stroke="#1e60a3" stroke-width="1.5"/>')
 svg.append('</g>')
svg.append('<text x="30" y="1040" font-family="sans-serif" font-size="17">Blue outlines mark the 0.20 mm filled bore. No production release: remaining routing and supplier/assembly review are open.</text></svg>')
(P/'actual-cam.svg').write_text(''.join(svg));cairosvg.svg2png(bytestring=''.join(svg).encode(),write_to=str(P/'actual-cam.png'))
