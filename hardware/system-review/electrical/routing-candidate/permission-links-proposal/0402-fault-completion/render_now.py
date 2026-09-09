from pathlib import Path
import sys,sexpdata
sys.path.insert(0,str(Path('hardware/system-review/electrical/main-final-independent').resolve()))
from cam_geometry import *
import cairosvg
D=Path(__file__).resolve().parent;n=Native(sexpdata.loads((D/'Trimix_Analyzer.kicad_pcb').read_text()))
colors={'USB_PERMISSION_CLR_N':'#66d9ef','USB_PERMISSION_Q':'#ffb347','USB_ILIM_BRANCH':'#e44cf4','USB_LIMIT_SET':'#b2eb7c','USB_ILIM_SERIES':'#ffff5b','PACK_P':'#f34545','HOST_3V3':'#ccc','GND':'#646464'}
for L in ['F.Cu','In2.Cu','B.Cu']:
 a=['<svg xmlns="http://www.w3.org/2000/svg" width="1200" height="1000" viewBox="3 -100 25 20"><rect x="3" y="-100" width="25" height="20" fill="#151820"/>']
 for q in [t for t in n.tracks if t['layer']==L]+n.vias+n.pads_on(L):
  g=q['geo'];c=colors.get(q['net'],'#4879a7');a.append(g.svg(fill_color=c,opacity=.8,scale_factor=.015))
 for f in n.fps:
  if 3<f['x']<28 and-100<f['y']<-80:a.append(f'<text x="{f["x"]}" y="{f["y"]}" fill="white" font-size=".3">{f["ref"]}</text>')
 a+=['</svg>'];fn=D/('now-'+L.replace('.','-')+'.svg');fn.write_text(''.join(a));cairosvg.svg2png(url=str(fn),write_to=str(fn.with_suffix('.png')))
