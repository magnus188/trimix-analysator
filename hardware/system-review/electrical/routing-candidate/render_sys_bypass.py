from pathlib import Path
import sys,sexpdata,cairosvg,hashlib,json
D=Path(__file__).resolve().parent;sys.path.insert(0,str(D.parent/'main-final-independent'));from cam_geometry import *
f=D/'sys-bootstrap.kicad_pcb';n=Native(sexpdata.loads(f.read_text()));colors={'VSYS':'#2765c2','GND':'#8eb399','/01  CHARGING + BATTERY/BQ_SW':'#e98620','/01  CHARGING + BATTERY/CHG_STAT_N':'#933d94'}
def draw(g,c):
 return ''.join('<path d="'+' '.join('M '+' L '.join(f'{x:.5f},{-y:.5f}'for x,y in r.coords)+' Z'for r in[p.exterior,*p.interiors])+'" fill="'+c+'" fill-rule="evenodd"/>'for p in polys(g))
s=['<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 43 10" width="2580" height="600"><rect width="43" height="10" fill="white"/>']
for j,L in enumerate(['F.Cu','In1.Cu','B.Cu']):
 s.append(f'<g transform="translate({j*14.3-8},-78.5)">');area=box(8,-87.5,21.5,-79)
 for z in n.zones:
  if z['layer']==L and z['geo'].intersects(area):s.append(draw(z['geo'].intersection(area),'#e4eee6'))
 for v in n.pads_on(L):
  if v['geo'].intersects(area):s.append(draw(v['geo'].intersection(area),colors.get(v['net'],'#c6cdd5')))
 for v in n.tracks:
  if v['layer']==L and v['geo'].intersects(area):s.append(draw(v['geo'].intersection(area),colors.get(v['net'],'#c6cdd5')))
 for v in n.vias:
  if v['geo'].intersects(area):s.append(draw(v['geo'],colors.get(v['net'],'#c6cdd5')));s.append(draw(Point(v['xy']).buffer(v['drill']/2),'white'))
 for v in n.pads_on(L):
  if v['geo'].intersects(area)and v['ref']in['C108','U101','C105','TP1013','L101']:s.append(f'<text x="{v["x"]}" y="{-v["y"]+.04}" font-size=".16" text-anchor="middle">{v["ref"]}.{v["pin"]}</text>')
 s.append(f'<text x="8" y="79" font-size=".35">{L}</text></g>')
s.append('<text x=".2" y="9.75" font-size=".25">SYS blue / GND green / SW orange / STAT purple. C108 supplementary bypass; C104+C105 bulk retained. Incomplete routing review.</text></svg>')
ss=''.join(s);(D/'sys-bypass-review.svg').write_text(ss);cairosvg.svg2png(bytestring=ss.encode(),write_to=str(D/'sys-bypass-review.png'))
