from pathlib import Path
import sys,json,sexpdata,cairosvg,html
D=Path(__file__).resolve().parent
sys.path.insert(0,str(D.parents[1]/'main-final-independent'))
from cam_geometry import Native,polys,box,LineString,Point
b=Native(sexpdata.loads((D/'before.kicad_pcb').read_text()))
cols={'VSYS':'#d6197e','USB_OVP_SET':'#d18b00','CHG_INT_N':'#c43a1f','USB_CC_INT_N':'#965abd','/01  CHARGING + BATTERY/CHG_CE_N':'#227eb2','GND':'#22864d','PACK_P':'#7256a1','PACK_TS':'#24527b','/01  CHARGING + BATTERY/BQ_REGN':'#b6480c','HOST_3V3':'#06a3a4'}
W=1700;H=900;allsvg=[f'<svg xmlns="http://www.w3.org/2000/svg" width="{W}" height="{H}"><rect width="100%" height="100%" fill="white"/>']
for i,L in enumerate(['F.Cu','In2.Cu','B.Cu']):
 x0,y0,x1,y1=8.5,83,20,94;scale=47;ox=30+i*565;oy=75
 def path(g,col,alpha=1):
  for q in polys(g):
   rings=[q.exterior,*q.interiors];d=' '.join('M'+' L'.join(f'{ox+(x-x0)*scale:.3f},{oy+(-y-y0)*scale:.3f}'for x,y in r.coords)+' Z'for r in rings)
   allsvg.append(f'<path d="{d}" fill="{col}" fill-opacity="{alpha}" fill-rule="evenodd"/>')
 def text(x,y,t,size=10):allsvg.append(f'<text x="{ox+(x-x0)*scale:.3f}" y="{oy+(y-y0)*scale:.3f}" font-size="{size}" font-family="Arial" fill="#111" paint-order="stroke" stroke="white" stroke-width="2">{html.escape(t)}</text>')
 text(x0,y0-.4,L,18)
 clip=box(x0,-y1,x1,-y0)
 for t in b.tracks:
  if t['layer']==L:path(t['geo'].intersection(clip),cols.get(t['net'],'#80949d'),.8)
 for v in b.vias:
  if not clip.intersects(v['geo']):continue
  path(v['geo'],cols.get(v['net'],'#80949d'));path(Point(v['xy']).buffer(v['drill']/2),'white')
 for p in b.pads_on(L):
  if not clip.intersects(p['geo']):continue
  path(p['geo'],cols.get(p['net'],'#80949d'),.9);text(p['x']-.3,-p['y'],p['ref']+'.'+p['pin'],8)
 if L=='In2.Cu':
  pts=json.loads((D/'power-corridor-scout.json').read_text())['hypothetical_points_mm'];path(LineString([(x,-y)for x,y in pts]).buffer(.2).intersection(clip),'#ff0',.8)
 for y in range(83,95):text(x0,y,str(y),9)
 for x in range(9,21):text(x,y1+.45,str(x),9)
for i,(n,c) in enumerate(cols.items()):allsvg.append(f'<rect x="{30+(i%4)*410}" y="{700+(i//4)*35}" width="15" height="15" fill="{c}"/><text x="{50+(i%4)*410}" y="{713+(i//4)*35}" font-size="12" font-family="Arial">{html.escape(n)}</text>')
allsvg.append('</svg>');s=''.join(allsvg);(D/'corridor-view.svg').write_text(s);cairosvg.svg2png(bytestring=s.encode(),write_to=str(D/'corridor-view.png'))
