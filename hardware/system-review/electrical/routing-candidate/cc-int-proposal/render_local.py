from pathlib import Path
import sys,sexpdata,cairosvg
P=Path(__file__).resolve().parent
sys.path.insert(0,str(P.parents[1]/'main-final-independent'))
from cam_geometry import *
n=Native(sexpdata.loads((P/'before.kicad_pcb').read_text()));colors={'USB_CC_INT_N':'#a520d0','HOST_3V3':'#e79800','GND':'#b5d8bc'}
def draw(g,c):
 s=''
 for p in polys(g):
  d=' '.join('M '+' L '.join(f'{x:.5f},{-y:.5f}' for x,y in r.coords)+' Z' for r in [p.exterior,*p.interiors]);s+=f'<path d="{d}" fill="{c}" fill-rule="evenodd"/>'
 return s
s=['<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 16.5 5" width="2800" height="800"><rect width="46" height="13" fill="white"/>']
for j,L in enumerate(['F.Cu','B.Cu','In2.Cu']):
 s.append(f'<g transform="translate({j*5.5-24.75},-75.0)">')
 area=box(24.75,-80.0,30.25,-75.0)
 for p in n.pads_on(L):
  if p['geo'].intersects(area):s.append(draw(p['geo'].intersection(area),colors.get(p['net'],'#bdc7ce')))
 for t in n.tracks:
  if t['layer']==L and t['geo'].intersects(area):s.append(draw(t['geo'].intersection(area),colors.get(t['net'],'#bdc7ce')))
 for v in n.vias:
  if v['geo'].intersects(area):s.append(draw(v['geo'],colors.get(v['net'],'#bdc7ce')));s.append(draw(Point(v['xy']).buffer(v['drill']/2),'white'))
 for p in n.pads_on(L):
  if p['geo'].intersects(area) :s.append(f'<text x="{p["x"]}" y="{-p["y"]+.05}" font-size=".1" text-anchor="middle" fill="black">{p["ref"]}.{p["pin"]}</text>')
 s.append(f'<text x="24.9" y="75.3" font-size=".4">{L}</text></g>')
s.append('</svg>');ss=''.join(s);(P/'local.svg').write_text(ss);cairosvg.svg2png(bytestring=ss.encode(),write_to=str(P/'local.png'))
