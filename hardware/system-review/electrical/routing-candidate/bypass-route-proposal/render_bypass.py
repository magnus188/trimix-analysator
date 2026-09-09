from pathlib import Path
import sys,sexpdata,cairosvg,hashlib,json
D=Path(__file__).resolve().parent;sys.path.insert(0,str(D.parents[1]/'main-final-independent'))
from cam_geometry import *
f=D/'frozen-out-input-stage.kicad_pcb';n=Native(sexpdata.loads(f.read_text()))
colors={'USB_5V':'#d77916','USB_OVP_5V':'#2460b1','GND':'#9fc6a5','USB_OVP_DVDT':'#9956b5','USB_OVP_ILM':'#bd799a'}
def draw(g,c):
 s=''
 for p in polys(g):
  d=' '.join('M '+' L '.join(f'{x:.5f},{-y:.5f}' for x,y in r.coords)+' Z' for r in [p.exterior,*p.interiors]);s+=f'<path d="{d}" fill="{c}" fill-rule="evenodd"/>'
 return s
s=['<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 43 11" width="2580" height="660"><rect width="43" height="11" fill="white"/>']
for j,L in enumerate(['F.Cu','B.Cu','In1.Cu']):
 s.append(f'<g transform="translate({j*14.5-7},-85.5)">');area=box(7,-95,20.5,-86)
 for z in n.zones:
  if z['layer']==L and z['geo'].intersects(area):s.append(draw(z['geo'].intersection(area),'#e2eee4'))
 for q in n.pads_on(L):
  if q['geo'].intersects(area):s.append(draw(q['geo'].intersection(area),colors.get(q['net'],'#c6ced5')))
 for t in n.tracks:
  if t['layer']==L and t['geo'].intersects(area):s.append(draw(t['geo'].intersection(area),colors.get(t['net'],'#c6ced5')))
 for v in n.vias:
  if v['geo'].intersects(area):s.append(draw(v['geo'],colors.get(v['net'],'#c6ced5')));s.append(draw(Point(v['xy']).buffer(v['drill']/2),'white'))
 for q in n.pads_on(L):
  if q['geo'].intersects(area) and q['ref'] in ['U115','C114','C115','C116','J102','R116','R126']:s.append(f'<text x="{q["x"]}" y="{-q["y"]+.04}" font-size=".15" text-anchor="middle" fill="black">{q["ref"]}.{q["pin"]}</text>')
 s.append(f'<text x="7" y="86" font-size=".42">{L}</text></g>')
s.append('<text x="0.2" y="10.6" font-size=".25">Raw USB orange / protected USB blue / ground green / DVDT violet. Exact native geometry; staged routing review.</text></svg>')
ss=''.join(s);(D/'power-stage.svg').write_text(ss);cairosvg.svg2png(bytestring=ss.encode(),write_to=str(D/'power-stage.png'))
(D/'power-stage-render.json').write_text(json.dumps({'board':str(f),'sha256':hashlib.sha256(f.read_bytes()).hexdigest(),'scope':'F/B/In1 exact copper and selected pads; diagnostic stage, not final routing'},indent=2)+'\n')
