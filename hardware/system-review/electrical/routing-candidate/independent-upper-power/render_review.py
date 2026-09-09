from pathlib import Path
import sys,sexpdata,json,cairosvg
D=Path(__file__).resolve().parent
sys.path.insert(0,str(D.parents[1]/'main-final-independent'))
from cam_geometry import *
n=Native(sexpdata.loads((D/'Trimix_Analyzer.kicad_pcb').read_text()));delta=json.loads((D/'final-delta.json').read_text())
color={'VOUT_5V':'#1972c6','VSYS':'#d1780d'}
area=box(7.5,-63.5,21.5,-46.5)
out=['<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 45 18.8" width="2250" height="940"><rect width="45" height="18.8" fill="white"/>']
def draw(g,c):
 for q in polys(g.intersection(area)):
  path=' '.join('M '+' L '.join(f'{x:.5f},{-y:.5f}'for x,y in r.coords)+' Z'for r in[q.exterior,*q.interiors])
  out.append(f'<path d="{path}" fill="{c}" fill-rule="evenodd"/>')
for i,L in enumerate(['F.Cu','B.Cu','In2.Cu']):
 out.append(f'<g transform="translate({i*15-7.5},-45.8)">')
 for x in range(8,22):out.append(f'<path d="M{x},46.5V63.5" stroke="#eee" stroke-width=".01"/>')
 for y in range(47,64):out.append(f'<path d="M7.5,{y}H21.5" stroke="#eee" stroke-width=".01"/>')
 for t in n.tracks:
  if t['layer']==L:draw(t['geo'],'#c1cbd2')
 for q in n.pads_on(L):draw(q['geo'],'#a9b8c3')
 for v in n.vias:draw(v['geo'],'#a9b8c3');draw(Point(v['xy']).buffer(v['drill']/2),'white')
 for q in delta['added_copper']:
  if q['type']=='via':
   x,y=q['at_mm'];draw(Point(x,-y).buffer(q['diameter_mm']/2),color[q['net']]);draw(Point(x,-y).buffer(q['drill_mm']/2),'white')
  elif q['layer']==L:draw(LineString([(x,-y)for x,y in[q['start_mm'],q['end_mm']]]).buffer(q['width_mm']/2),color[q['net']])
 for v in n.vias:draw(Point(v['xy']).buffer(v['drill']/2),'white')
 for q in n.pads_on(L):
  if q['ref']in ['C302','C303','U302','U801','U201','C201']and q['pin']not in['','15']:
   out.append(f'<text x="{q["x"]}" y="{-q["y"]+.06}" text-anchor="middle" font-family="Arial" font-size=".17">{q["ref"]}.{q["pin"]}</text>')
 out.append(f'<text x="7.65" y="46.25" font-family="Arial" font-size=".38">{L}</text></g>')
out.append('<text x=".2" y="18.3" font-family="Arial" font-size=".25">Blue: added VOUT; orange: added VSYS. Existing copper grey. PCB coordinates; B viewed through board. Filled planes omitted.</text></svg>')
text=''.join(out);(D/'upper-copper.svg').write_text(text);cairosvg.svg2png(bytestring=text.encode(),write_to=str(D/'upper-copper.png'))
