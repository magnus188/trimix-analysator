from pathlib import Path
import sys,sexpdata,json,cairosvg
D=Path(__file__).resolve().parent;sys.path.insert(0,str(D.parents[1]/'main-final-independent'))
from cam_geometry import *
area=box(14.6,-92.2,19.8,-88.1);out=['<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 11.3 5.1" width="2260" height="1020"><rect width="11.3" height="5.1" fill="white"/>']
colors={'GND':'#1f8b55','USB_OVP_DVDT':'#d7780d','USB_OVP_ILM':'#2167c3','USB_PERMISSION_Q':'#9855b5'}
def draw(g,c):
 for q in polys(g.intersection(area)):
  path=' '.join('M '+' L '.join(f'{x:.5f},{-y:.5f}'for x,y in r.coords)+' Z'for r in[q.exterior,*q.interiors]);out.append(f'<path d="{path}" fill="{c}" fill-rule="evenodd"/>')
for i,(file,title)in enumerate([('before.kicad_pcb','Before'),('Trimix_Analyzer.kicad_pcb','After — B.Cu, viewed through PCB')]):
 n=Native(sexpdata.loads((D/file).read_text()));out.append(f'<g transform="translate({i*5.6-14.5},-87.6)">')
 for x in range(15,20):out.append(f'<path d="M{x},88.1V92.2" stroke="#e4e4e4" stroke-width=".01"/>')
 for y in range(89,93):out.append(f'<path d="M14.6,{y}H19.8" stroke="#e4e4e4" stroke-width=".01"/>')
 for t in n.tracks:
  if t['layer']=='B.Cu':draw(t['geo'],colors.get(t['net'],'#aaa'))
 for p in n.pads_on('B.Cu'):draw(p['geo'],colors.get(p['net'],'#aaa'))
 for v in n.vias:draw(v['geo'],colors.get(v['net'],'#aaa'));draw(Point(v['xy']).buffer(v['drill']/2),'white')
 for p in n.pads_on('B.Cu'):
  if p['ref']in ['U115','C116','R126']and area.covers(Point(p['x'],p['y'])):out.append(f'<text x="{p["x"]}" y="{-p["y"]+.035}" text-anchor="middle" fill="white" font-family="Arial" font-weight="bold" font-size=".12">{p["ref"]}.{p["pin"]}</text>')
 out.append(f'<text x="14.65" y="87.92" font-family="Arial" font-size=".18">{title}</text></g>')
out.append('<text x=".1" y="4.91" font-family="Arial" font-size=".14">Orange: DVDT · Blue: ILM · Green: ground · Purple: preserved Q via. Nominal copper only; filled planes omitted.</text></svg>')
s=''.join(out);(D/'dvdt-copper.svg').write_text(s);cairosvg.svg2png(bytestring=s.encode(),write_to=str(D/'dvdt-copper.png'))
