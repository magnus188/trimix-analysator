"""Read-only exact native copper projections, no electrical simulation."""
import sys,json,hashlib,html
from pathlib import Path
import sexpdata,cairosvg
from shapely.geometry import box
from shapely import affinity
from shapely.ops import unary_union
sys.path.insert(0,str(Path('hardware/system-review/electrical/main-final-independent').resolve()))
from cam_geometry import Native,polys,sub
out=Path(__file__).resolve().parent/'synchronized-return';src=out/'Trimix_Analyzer.kicad_pcb';data=src.read_bytes();n=Native(sexpdata.loads(data.decode()))
expected=hashlib.sha256(data).hexdigest()

def elem(g,fill,stroke=None):
 g=affinity.scale(g,1,-1,origin=(0,0)); chunks=[]
 for p in polys(g):
  def ring(r):return 'M'+' L'.join(f'{x:.5f},{y:.5f}'for x,y in r.coords)+'Z'
  d=ring(p.exterior)+''.join(ring(r)for r in p.interiors)
  chunks.append(f'<path d="{d}" fill="{fill}" fill-rule="evenodd"'+(f' stroke="{stroke}" stroke-width="0.025"'if stroke else '')+'/>')
 return ''.join(chunks)
cases=[('bq','BQ25895: SW / BTST / REGN / SYS', (4,70,23,89),['U101','L101','C101','C102','C103','C104','C105','C107','C108'], {'/01  CHARGING + BATTERY/BQ_SW':'#bd4020','/01  CHARGING + BATTERY/BQ_BTST':'#8e3296','/01  CHARGING + BATTERY/BQ_REGN':'#1877b7','/01  CHARGING + BATTERY/BQ_PMID':'#b39400','VSYS':'#dc7615'}),
('tps63020','TPS63020: local switching / input / output / FB',(4,55,22,74),['U201','C201','C202','C203','C204','C205','C206','L201','R201','R202'],{'Net-(L201-Pad1)':'#bd4020','Net-(L201-Pad2)':'#8e3296','VSYS':'#1877b7','VOUT_5V':'#dc7615','/02  SWITCHED 5 V/TPS_FB':'#019c9c','/02  SWITCHED 5 V/TPS_VINA':'#bb9a00'}),
('co','TPS61023: SW / output / feedback branch',(14,48,27,69),['U701','C701','C702','C703','L701','R701','R702'],{'CO_SW':'#bd4020','CO_5V28':'#dc7615','CO_FB':'#8e3296','VOUT_5V':'#1877b7'}),
('usb','TPS25947 / TPS22950-Q1: bypass / limit',(3,85,23,96),['U114','U115','C114','C115','C116','R116','R119','R126'],{'USB_5V':'#bd4020','USB_OVP_5V':'#dc7615','USB_CHG_5V':'#1877b7','USB_LIMIT_SET':'#8e3296','USB_OVP_ILM':'#019c9c','USB_OVP_DVDT':'#bb9a00'})]
for name,title,(x0,y0,x1,y1),refs,colors in cases:
 w=x1-x0;h=y1-y0;scale=24;W=(w*2+3)*scale;H=(h+5)*scale;clip=box(x0,-y1,x1,-y0)
 svg=[f'<svg xmlns="http://www.w3.org/2000/svg" width="{W}" height="{H}" viewBox="0 0 {W} {H}"><rect width="100%" height="100%" fill="white"/>',f'<text x="12" y="20" font-family="sans-serif" font-size="15">{html.escape(title)}</text>',f'<text x="12" y="38" font-family="sans-serif" font-size="11">Exact native geometry | isolated synchronized local trial | top coordinates on both views</text>']
 for i,layer in enumerate(['F.Cu','B.Cu']):
  dx=(1+i*(w+1))*scale;dy=60
  svg += [f'<text x="{dx}" y="54" font-size="12" font-family="sans-serif">{layer}; pale green = In1 GND projection</text>',f'<g transform="translate({dx-x0*scale},{dy-y0*scale}) scale({scale})">']
  g=unary_union([z['geo'] for z in n.zones if z['layer']=='In1.Cu' and z['net']=='GND']).intersection(clip);svg.append(elem(g,'#eff8f0'))
  for obj in [*n.tracks,*n.vias,*n.pads_on(layer)]:
   if 'layer'in obj and obj['layer']!=layer:continue
   g=obj['geo'].intersection(clip)
   if g.is_empty:continue
   color=colors.get(obj['net'],'#659274'if obj['net']=='GND'else'#d5d5d5')
   svg.append(elem(g,color))
  for ho in n.holes:
   g=ho['geo'].intersection(clip)
   if not g.is_empty:svg.append(elem(g,'white'))
  for f in n.fps:
   if f['ref'] in refs:
    x,y=f['x'],-f['y'];svg.append(f'<text x="{x}" y="{y-.4}" text-anchor="middle" fill="#111" font-size=".43" font-family="sans-serif">{f["ref"]}</text>')
  svg.append('</g>')
 label='  |  '.join(k.rsplit('/',1)[-1] for k in colors)
 svg +=[f'<text x="12" y="{H-14}" font-family="sans-serif" font-size="10">Colored: {html.escape(label)}. Grey: other nets. Lengths/UUIDs in native-local-paths.json.</text>','</svg>']
 s=out/(name+'.svg');s.write_text(''.join(svg));cairosvg.svg2png(url=str(s),write_to=str(out/(name+'.png')))
assert data==src.read_bytes()
