from pathlib import Path
import sys,sexpdata,cairosvg
sys.path.insert(0,str(Path('hardware/system-review/electrical/main-final-independent').resolve()))
from cam_geometry import *
D=Path(__file__).resolve().parent
n=Native(sexpdata.loads((D/'Trimix_Analyzer.kicad_pcb').read_text()))
colors={'USB_PERMISSION_Q':'#e74283','USB_PERMISSION_CLR_N':'#00aabb','USB_ILIM_SERIES':'#bbbb00','USB_ILIM_BRANCH':'#ca43d8','PACK_P':'#ff8030','USB_CC_INT_N':'#cc5030'}
out=['<svg xmlns="http://www.w3.org/2000/svg" width="1500" height="940" viewBox="0 0 1500 940"><rect width="1500" height="940" fill="white"/>']
for idx,L in enumerate(['In2.Cu','F.Cu']):
 out.append(f'<text x="{20+idx*740}" y="30" font-size="22">{L}</text><g transform="translate({20+idx*740},70) scale(65,-65) translate(-13,83)">')
 def draw(g,col):
  s=g.svg(scale_factor=.0001,fill_color=col,opacity=.72).replace('stroke="#555555"','stroke="none"');out.append(s)
 for t in n.tracks:
  if t['layer']==L and t['geo'].intersects(box(13,-96,24,-83)):draw(t['geo'],next((v for k,v in colors.items()if t['net'].endswith(k)),'#909898'))
 for v in n.vias:
  if v['geo'].intersects(box(13,-96,24,-83)):draw(v['geo'],next((col for k,col in colors.items()if v['net'].endswith(k)),'#507070'))
 for p in n.pads_on(L):
  if p['geo'].intersects(box(13,-96,24,-83)):
   draw(p['geo'],next((v for k,v in colors.items()if p['net'].endswith(k)),'#cccccc'));out.append(f'<text x="{p["x"]}" y="{p["y"]}" font-size=".17" text-anchor="middle">{p["ref"]}.{p["pin"]}</text>')
 for x in range(14,24):out.append(f'<text x="{x}" y="-95.8" font-size=".18">{x}</text>')
 out.append('</g>')
out.append('</svg>');(D/'local-inner.svg').write_text(''.join(out));cairosvg.svg2png(url=str(D/'local-inner.svg'),write_to=str(D/'local-inner.png'))
