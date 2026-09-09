from pathlib import Path
import sys,sexpdata as s,html,json
sys.path.insert(0,str(Path('hardware/system-review/electrical/main-final-independent').resolve()))
from cam_geometry import *
import cairosvg
D=Path(__file__).resolve().parent;n=Native(s.loads((D/'complete-controls-frozen.kicad_pcb').read_text()));bounds=box(1,-99,29.5,-79)
def path(g,color,alpha=1):
 g=affinity.scale(g.intersection(bounds),1,-1,origin=(0,0));parts=[]
 for p in polys(g):
  d='M '+' L '.join(f'{x:.5f},{y:.5f}'for x,y in p.exterior.coords)+' Z '
  for h in p.interiors:d+='M '+' L '.join(f'{x:.5f},{y:.5f}'for x,y in h.coords)+' Z '
  parts.append(f'<path d="{d}" fill="{color}" fill-opacity="{alpha}" fill-rule="evenodd"/>')
 return ''.join(parts)
ctrl={'USB_ILIM_BRANCH':'#b21e83','USB_LIMIT_SET':'#ad6200','USB_OVP_UVLO':'#135dac','CHG_INT_N':'#db492c','USB_CC_INT_N':'#753cbd','HOST_3V3':'#158899','USB_PERMISSION_CLR_N':'#775b00','USB_PERMISSION_Q':'#3e456e'}
for L in ['In1.Cu','In2.Cu']:
 for outer in ['F.Cu','B.Cu']:
  pieces=['<svg xmlns="http://www.w3.org/2000/svg" width="1425" height="1125" viewBox="1 76.5 28.5 22.5"><rect x="1" y="76.5" width="28.5" height="22.5" fill="white"/>']
  pieces.append(f'<text x="1.5" y="77.1" font-family="Arial" font-size=".46">{L} filled GND with {outer} copper — completed isolated controls</text>')
  pieces.append('<text x="1.5" y="77.8" font-family="Arial" font-size=".32">b305a4c3 · green ground; heavy red/blue power; coloured In2 controls; circles plated vias</text>')
  pieces+= [path(z['geo'],'#bcdfc2')for z in n.zones if z['net']=='GND'and z['layer']==L]
  pieces+=[path(q['geo'],'#b8bdc8',.5)for q in n.tracks if q['layer']==outer]
  pieces+=[path(q['geo'],'#c32225'if outer=='F.Cu'else'#2768b5',.9)for q in n.tracks if q['layer']==outer and q.get('width',0)>=.39]
  pieces+=[path(q['geo'],ctrl.get(q['net'],'#404040'),.95)for q in n.tracks if q['layer']=='In2.Cu']
  pieces+=[path(q['geo'],'#777777',.55)for q in n.pads_on(outer)]
  for q in n.vias:
   x,y=q['xy'];y=-y
   if not(1<x<29.5 and 79<y<99):continue
   color='#27803e'if q['net']=='GND'else ctrl.get(q['net'],'#333333')
   pieces.append(f'<circle cx="{x}" cy="{y}" r=".13" fill="white" stroke="{color}" stroke-width=".035"/>')
  for name,xy in {'R115':(21.4,83.3),'R118':(10.75,91.95),'R119':(5.15,88.15),'R116':(7.75,94.75),'Q110':(18,89.5),'C116':(16.5,89.05)}.items():
   x,y=xy;pieces.append(f'<text x="{x+.5}" y="{y-.4}" font-family="Arial" font-size=".3" fill="#111">{name}</text>')
  pieces.append('</svg>');name=L.replace('.','_')+'_'+outer.replace('.','_');f=D/(name+'.svg');f.write_text(''.join(pieces));cairosvg.svg2png(url=str(f),write_to=str(D/(name+'.png')))
