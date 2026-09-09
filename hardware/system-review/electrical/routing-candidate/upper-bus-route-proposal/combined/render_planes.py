"""Actual native copper/fill overlay; proposed SYS path is explicitly ghosted."""
from pathlib import Path
import sys,sexpdata,cairosvg
D=Path(__file__).resolve().parent;sys.path.insert(0,str(Path('hardware/system-review/electrical/main-final-independent').resolve()))
from cam_geometry import *
a=Native(sexpdata.loads((D/'before.kicad_pcb').read_text()));b=Native(sexpdata.loads((D/'Trimix_Analyzer.kicad_pcb').read_text()));area=box(7,-89.15,27,-65)
out=['<svg xmlns="http://www.w3.org/2000/svg" width="3240" height="1100" viewBox="0 0 81 27.5"><rect width="81" height="27.5" fill="white"/>']
def draw(g,color,opacity=1):
 for p in polys(g.intersection(area)):
  path=' '.join('M '+' L '.join(f'{x:.6f},{-y:.6f}'for x,y in ring.coords)+' Z'for ring in[p.exterior,*p.interiors]);out.append(f'<path d="{path}" fill="{color}" opacity="{opacity}" fill-rule="evenodd"/>')
colors={'CHG_INT_N':'#e27820','I2C_SDA':'#6455b6','I2C_SCL':'#d51c37','VSYS':'#136d8a','PACK_P':'#556d84','USB_5V':'#136d8a','GND':'#428352'}
for k,(n,L,title)in enumerate([(a,'In2.Cu','Before In2'),(b,'In2.Cu','After In2'),(b,'F.Cu','After F / projected SYS'),(b,'B.Cu','After B / projected SYS')]):
 out.append(f'<g transform="translate({k*20.25-7},-63.8)">')
 for z in n.zones:
  if z['layer']=='In2.Cu'and z['net']=='GND':draw(z['geo'],'#d5e8d9'if L!='In2.Cu'else'#4d9065')
 for t in n.tracks:
  if t['layer']==L:draw(t['geo'],colors.get(t['net'],'#aab0b5'))
 for q in n.pads_on(L):draw(q['geo'],colors.get(q['net'],'#727a82'))
 for v in n.vias:draw(v['geo'],colors.get(v['net'],'#8c9297'));draw(Point(v['xy']).buffer(v['drill']/2),'white')
 # This cyan corridor is not in the candidate copper; it is the owner's reserved next step.
 ghost=LineString([(15.84,-84.25),(17.5,-83.9),(19,-83.3)]).buffer(.2,cap_style=1,join_style=1);draw(ghost,'#00bbd5',.60)
 for q in n.pads_on(L):
  if q['ref']in['U101','C108','C103','Q111','TP1013','R107','C707','U301']and area.covers(Point(q['x'],q['y'])):out.append(f'<text x="{q["x"]}" y="{-q["y"]+.07}" font-size=".19" text-anchor="middle" fill="black">{q["ref"]}.{q["pin"]}</text>')
 out.append(f'<text x="7.1" y="64.5" font-family="Arial" font-size=".36">{title}</text>')
 for yy in[65,70,75,80,85]:out.append(f'<text x="7.1" y="{yy}" font-family="Arial" font-size=".18">y{yy}</text>')
 out.append('</g>')
out.append('<text x=".2" y="26.3" font-family="Arial" font-size=".32">Red: SCL. Orange: CHG. Purple: SDA. Cyan: reserved future 0.40mm SYS path (not yet actual copper); outer-layer panels show its projection.</text>')
out.append('<text x=".2" y="27.0" font-family="Arial" font-size=".30">Native filled copper and package pads only. Scope X7..27 / Y65..89.15mm. In1 stays continuous; all seven final In2 ground regions retain an In1 anchor.</text></svg>')
s=''.join(out);(D/'final-plane-views.svg').write_text(s);cairosvg.svg2png(bytestring=s.encode(),write_to=str(D/'final-plane-views.png'))
