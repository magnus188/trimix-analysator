from pathlib import Path
import sys,sexpdata,cairosvg
D=Path(__file__).resolve().parent;sys.path.insert(0,str(Path('hardware/system-review/electrical/main-final-independent').resolve()))
from cam_geometry import *
old=Native(sexpdata.loads((D/'before.kicad_pcb').read_text()));n=Native(sexpdata.loads((D/'Trimix_Analyzer.kicad_pcb').read_text()));area=box(7,-97,26,-83)
out=['<svg xmlns="http://www.w3.org/2000/svg" width="3120" height="1200" viewBox="0 0 78 30"><rect width="78" height="30" fill="white"/>']
def draw(g,c):
 for q in polys(g.intersection(area)):
  s=' '.join('M '+' L '.join(f'{x:.5f},{-y:.5f}'for x,y in r.coords)+' Z'for r in[q.exterior,*q.interiors]);out.append(f'<path d="{s}" fill="{c}" fill-rule="evenodd"/>')
for i,(data,L,title)in enumerate([(old,'In2.Cu','Before: HOST + In2 GND'),(n,'In2.Cu','After: HOST + CC / In2 GND'),(n,'F.Cu','After: F copper / In2 CC projection'),(n,'B.Cu','After: B copper / In2 CC projection')]):
 out.append(f'<g transform="translate({i*19.5-6.8},-82)">')
 for z in data.zones:
  if z['layer']=='In2.Cu'and z['net']=='GND':draw(z['geo'],'#dcebe1'if L in['F.Cu','B.Cu']else'#4d9065')
 for q in data.tracks:
  if q['layer']==L:draw(q['geo'],'#bd7638'if q['net']=='USB_CC_INT_N'else'#a5a5a5')
 for q in data.pads_on(L):draw(q['geo'],'#666'if q['net']!='GND'else'#347749')
 if L in['F.Cu','B.Cu']:
  for q in data.tracks:
   if q['layer']=='In2.Cu'and q['net']=='USB_CC_INT_N':draw(q['geo'],'#e27516')
 for v in data.vias:draw(v['geo'],'#e27516'if v['net']=='USB_CC_INT_N'else'#3d6261');draw(Point(v['xy']).buffer(v['drill']/2),'white')
 for q in data.pads_on(L):
  if q['ref']in['U115','C115','C116','C114','U101','U113','J102']and area.covers(Point(q['x'],q['y'])):out.append(f'<text x="{q["x"]}" y="{-q["y"]+.07}" text-anchor="middle" font-family="Arial" font-size=".2" fill="white">{q["ref"]}.{q["pin"]}</text>')
 out.append(f'<text x="7" y="82.7" font-family="Arial" font-size=".4">{title}</text></g>')
out.append('<text x=".2" y="16.2" font-family="Arial" font-size=".34">CC candidate adapted to frozen HOST route. Nominal geometric overlay; parent review required before integration.</text>')
out.append('<text x=".2" y="16.8" font-family="Arial" font-size=".34">In1 remains one connected filled plane. In2 regions retain ground anchors to In1. Orange = CC trace/vias; F/B projection shows overlap, not same-layer shorts.</text></svg>')
s=''.join(out).replace('height="1200"','height="680"').replace('0 0 78 30','0 0 78 17');(D/'final-plane-views.svg').write_text(s);cairosvg.svg2png(bytestring=s.encode(),write_to=str(D/'final-plane-views.png'))
