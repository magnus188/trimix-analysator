from pathlib import Path
import sys,sexpdata,cairosvg
P=Path(__file__).resolve().parent
sys.path.insert(0,str(P.parents[1]/'main-final-independent'))
from cam_geometry import *
n=Native(sexpdata.loads((P/'baseline/Trimix_Analyzer.kicad_pcb').read_text()));colors={'GAUGE_ALERT_N':'#a520d0','HOST_3V3':'#e79800','GND':'#b5d8bc'}
def draw(g,c):
 s=''
 for p in polys(g):
  d=' '.join('M '+' L '.join(f'{x:.5f},{-y:.5f}' for x,y in r.coords)+' Z' for r in [p.exterior,*p.interiors]);s+=f'<path d="{d}" fill="{c}" fill-rule="evenodd"/>'
 return s
s=['<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 46 13" width="2760" height="780"><rect width="46" height="13" fill="white"/>']
for j,L in enumerate(['F.Cu','B.Cu','In2.Cu']):
 s.append(f'<g transform="translate({j*15.5-6},-67)">')
 area=box(9.5,-90.5,21.5,-67)
 for p in n.pads_on(L):
  if p['geo'].intersects(area):s.append(draw(p['geo'].intersection(area),colors.get(p['net'],'#bdc7ce')))
 for t in n.tracks:
  if t['layer']==L and t['geo'].intersects(area):s.append(draw(t['geo'].intersection(area),colors.get(t['net'],'#bdc7ce')))
 for v in n.vias:
  if v['geo'].intersects(area):s.append(draw(v['geo'],colors.get(v['net'],'#bdc7ce')));s.append(draw(Point(v['xy']).buffer(v['drill']/2),'white'))
 for p in n.pads_on(L):
  if p['geo'].intersects(area) and (p['net'] in colors or p['ref'] in ['U301','R301','C301','C707','R107','R106']):s.append(f'<text x="{p["x"]}" y="{-p["y"]+.05}" font-size=".13" text-anchor="middle" fill="black">{p["ref"]}.{p["pin"]}</text>')
 s.append(f'<text x="6.2" y="67.5" font-size=".4">{L}</text></g>')
s.append('</svg>');ss=''.join(s);(P/'local.svg').write_text(ss);cairosvg.svg2png(bytestring=ss.encode(),write_to=str(P/'local.png'))
