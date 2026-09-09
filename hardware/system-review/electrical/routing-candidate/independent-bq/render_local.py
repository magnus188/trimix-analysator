from pathlib import Path
import sys,sexpdata,cairosvg
P=Path(__file__).resolve().parent
sys.path.insert(0,str(P.parents[1]/'main-final-independent'))
from cam_geometry import *
n=Native(sexpdata.loads((P/'Trimix_Analyzer.kicad_pcb').read_text()));colors={'/01  CHARGING + BATTERY/CHG_STAT_N':'#a520d0','BQ_ILIM':'#f09c00','/01  CHARGING + BATTERY/PACK_TS':'#008b7c'}
def draw(g,c):
 s=''
 for p in polys(g):
  d=' '.join('M '+' L '.join(f'{x:.5f},{-y:.5f}' for x,y in r.coords)+' Z' for r in [p.exterior,*p.interiors]);s+=f'<path d="{d}" fill="{c}" fill-rule="evenodd"/>'
 return s
s=['<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 40 12" width="2400" height="720"><rect width="40" height="12" fill="white"/>']
for j,L in enumerate(['F.Cu','B.Cu','In2.Cu']):
 s.append(f'<g transform="translate({j*13.5-9.5},-80.5)">')
 area=box(9.5,-90.5,21.5,-80.5)
 for p in n.pads_on(L):
  if p['geo'].intersects(area):s.append(draw(p['geo'].intersection(area),colors.get(p['net'],'#bdc7ce')))
 for t in n.tracks:
  if t['layer']==L and t['geo'].intersects(area):s.append(draw(t['geo'].intersection(area),colors.get(t['net'],'#bdc7ce')))
 for v in n.vias:
  if v['geo'].intersects(area):s.append(draw(v['geo'],colors.get(v['net'],'#bdc7ce')));s.append(draw(Point(v['xy']).buffer(v['drill']/2),'white'))
 for p in n.pads_on(L):
  if p['geo'].intersects(area) and (p['net'] in colors or p['ref'] in ['U101','R101','R102','R103']):s.append(f'<text x="{p["x"]}" y="{-p["y"]+.05}" font-size=".13" text-anchor="middle" fill="black">{p["ref"]}.{p["pin"]}</text>')
 s.append(f'<text x="10" y="81" font-size=".4">{L}</text></g>')
s.append('</svg>');ss=''.join(s);(P/'local.svg').write_text(ss);cairosvg.svg2png(bytestring=ss.encode(),write_to=str(P/'local.png'))
