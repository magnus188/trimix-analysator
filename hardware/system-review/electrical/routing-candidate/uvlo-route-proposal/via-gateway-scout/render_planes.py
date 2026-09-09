"""Actual native filled-copper overlay for the UVLO/HOST proposal."""
from pathlib import Path
import sys,sexpdata,cairosvg
D=Path(__file__).resolve().parent
sys.path.insert(0,str(Path('hardware/system-review/electrical/main-final-independent').resolve()))
from cam_geometry import *
a=Native(sexpdata.loads((D/'before-refilled.kicad_pcb').read_text()))
b=Native(sexpdata.loads((D/'Trimix_Analyzer.kicad_pcb').read_text()))
area=box(6.5,-98.5,24,-84.5)
out=['<svg xmlns="http://www.w3.org/2000/svg" width="2880" height="760" viewBox="0 0 72 19"><rect width="72" height="19" fill="white"/>']
def draw(g,color,opacity=1):
 for p in polys(g.intersection(area)):
  path=' '.join('M '+' L '.join(f'{x:.6f},{-y:.6f}'for x,y in ring.coords)+' Z'for ring in[p.exterior,*p.interiors])
  out.append(f'<path d="{path}" fill="{color}" opacity="{opacity}" fill-rule="evenodd"/>')
colors={'HOST_3V3':'#843ab6','USB_OVP_SET':'#e27820','USB_OVP_UVLO':'#d51c37','USB_OVP_5V':'#16455c','USB_5V':'#136d8a','GND':'#428352'}
for k,(n,L,title)in enumerate([(a,'In2.Cu','Before In2'),(b,'In2.Cu','After In2'),(b,'F.Cu','After F / In2 projection'),(b,'B.Cu','After B / In2 projection')]):
 out.append(f'<g transform="translate({k*18-6.5},-83.5)">')
 for z in n.zones:
  if z['layer']=='In2.Cu'and z['net']=='GND':draw(z['geo'],'#d5e8d9'if L!='In2.Cu'else'#4d9065')
 for t in n.tracks:
  if t['layer']==L:draw(t['geo'],colors.get(t['net'],'#aab0b5'))
 for q in n.pads_on(L):draw(q['geo'],colors.get(q['net'],'#727a82'))
 for v in n.vias:
  draw(v['geo'],colors.get(v['net'],'#8c9297'))
  draw(Point(v['xy']).buffer(v['drill']/2),'white')
 draw(Point(13,-91.65).buffer(.30),'#00bbd5',.65)
 for q in n.pads_on(L):
  if q['ref']in['U115','R119','C114','C115','R116','R118','R124','R125']and area.covers(Point(q['x'],q['y'])):
   out.append(f'<text x="{q["x"]}" y="{-q["y"]+.07}" font-size=".19" text-anchor="middle" fill="black">{q["ref"]}.{q["pin"]}</text>')
 out.append(f'<text x="6.6" y="84.1" font-family="Arial" font-size=".36">{title}</text>')
 for yy in[85,90,95]:out.append(f'<text x="6.6" y="{yy}" font-family="Arial" font-size=".20">y{yy}</text>')
 out.append('</g>')
out.append('<text x=".2" y="16.6" font-family="Arial" font-size=".32">Purple: HOST_3V3. Red: UVLO. Orange: OVLO. Blue: raw/protected power. Cyan: reserved future 0.60/0.30 raw via (13,91.65).</text>')
out.append('<text x=".2" y="17.4" font-family="Arial" font-size=".30">Actual native filled copper and pads. X6.5..24 / Y84.5..98.5mm. New vias are ordinary 0.50/0.25mm; no In1 signal routing.</text>')
out.append('<text x=".2" y="18.2" font-family="Arial" font-size=".30">Review proposal only: the longer HOST path replaces its old In2 branch. See quantified plane audit; current capacity is not inferred from this view.</text></svg>')
s=''.join(out);(D/'final-plane-views.svg').write_text(s)
cairosvg.svg2png(bytestring=s.encode(),write_to=str(D/'final-plane-views.png'))
