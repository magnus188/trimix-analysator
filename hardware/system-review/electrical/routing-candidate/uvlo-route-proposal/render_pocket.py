from pathlib import Path
import sys,sexpdata,cairosvg,json
D=Path(__file__).resolve().parent;sys.path.insert(0,str(D.parents[1]/'main-final-independent'))
from cam_geometry import *
n=Native(sexpdata.loads((D/'before.kicad_pcb').read_text()));area=box(10,-93.8,18,-88.5)
colors={'USB_OVP_UVLO':'#dc8613','USB_CC_INT_N':'#aaa','USB_5V':'#bf433c','USB_CHG_5V':'#99433c','VSYS':'#3d9c67','GND':'#637c91','USB_OVP_UPPER':'#5e4d97','PACK_P':'#ae467e','USB_OVP_OUT':'#bc6247'}
out=['<svg xmlns="http://www.w3.org/2000/svg" width="2880" height="1062" viewBox="0 0 16.4 6"><rect width="16.4" height="6" fill="white"/>']
def draw(g,c):
 for q in polys(g.intersection(area)):
  path=' '.join('M '+' L '.join(f'{x:.5f},{-y:.5f}'for x,y in ring.coords)+' Z'for ring in[q.exterior,*q.interiors]);out.append(f'<path d="{path}" fill="{c}" fill-rule="evenodd"/>')
for i,L in enumerate(['F.Cu','B.Cu']):
 out.append(f'<g transform="translate({i*8.2-9.9},-87.9)">')
 for t in n.tracks:
  if t['layer']==L:draw(t['geo'],colors.get(t['net'],'#aaa'))
 for q in n.pads_on(L):draw(q['geo'],colors.get(q['net'],'#aaa'))
 for v in n.vias:draw(v['geo'],colors.get(v['net'],'#aaa'));draw(Point(v['xy']).buffer(v['drill']/2),'white')
 for q in n.pads_on(L):
  if area.covers(Point(q['x'],q['y'])):out.append(f'<text x="{q["x"]}" y="{-q["y"]+.04}" text-anchor="middle" font-family="Arial" font-weight="bold" fill="white" font-size=".11">{q["ref"]}.{q["pin"]}</text>')
 out.append(f'<text x="10.1" y="88.22" font-family="Arial" font-size=".2">{L} — UVLO pocket, native coordinates</text>')
 out.append('')
 out.append('</g>')
out.append('<text x=".1" y="5.85" font-family="Arial" font-size=".13">Orange: UVLO input; red: USB; green: SYS; grey-blue: GND; purple: OVP divider. Planes omitted; B viewed through PCB.</text></svg>')
s=''.join(out);(D/'source-pocket.svg').write_text(s);cairosvg.svg2png(bytestring=s.encode(),write_to=str(D/'source-pocket.png'))
