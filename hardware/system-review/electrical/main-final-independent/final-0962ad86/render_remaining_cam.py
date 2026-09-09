"""Extra source-bound CAM review images: pure Gerber/Excellon, no KiCad renderer."""
from pathlib import Path
import sys,hashlib,json,sexpdata as s,cairosvg
from gerbonara import GerberFile,ExcellonFile
from shapely.geometry import box
sys.path.insert(0,str(Path(__file__).resolve().parent.parent));from cam_geometry import geometry,Native
from audit_exports import svggeom
D=Path(__file__).resolve().parent;BASE=Path('hardware/system-review/electrical/routing-candidate/sensitive-layout-refinement/frozen-local-bundle');cam=BASE/'cam';board=BASE/'hardware/pcb/analyzer/Trimix_Analyzer.kicad_pcb';n=Native(s.loads(board.read_text()));hashes={str(board):hashlib.sha256(board.read_bytes()).hexdigest()}
G={};out=[]
for layer,ext in [('F.Cu','gtl'),('B.Cu','gbl'),('F.Mask','gts'),('B.Mask','gbs'),('F.Paste','gtp'),('B.Paste','gbp'),('F.SilkS','gto'),('B.SilkS','gbo'),('Edge.Cuts','gm1')]:
 f=next(cam.glob('*.'+ext));G[layer]=GerberFile.open(f);hashes[str(f)]=hashlib.sha256(f.read_bytes()).hexdigest()
 if layer in['F.Cu','B.Cu']:continue
 svg=str(G[layer].to_svg(margin=.5));name=layer.replace('.','-');(D/(name+'.svg')).write_text(svg);cairosvg.svg2png(bytestring=svg.encode(),write_to=str(D/(name+'.png')),output_width=850,background_color="#ffffff");out.append(name+'.png')
FG={}
for layer,ext in [('F.Paste','gtp'),('B.Paste','gbp')]:
 f=next((BASE/'factory-stencil').glob('*.'+ext));g=GerberFile.open(f);FG[layer]=g;hashes[str(f)]=hashlib.sha256(f.read_bytes()).hexdigest();svg=str(g.to_svg(margin=.5));name='Factory-'+layer.replace('.','-');(D/(name+'.svg')).write_text(svg);cairosvg.svg2png(bytestring=svg.encode(),write_to=str(D/(name+'.png')),output_width=850,background_color="#ffffff");out.append(name+'.png')
for f in cam.glob('*.drl'):
 g=ExcellonFile.open(f);hashes[str(f)]=hashlib.sha256(f.read_bytes()).hexdigest();name=f.stem;svg=str(g.to_svg(margin=.5));(D/(name+'.svg')).write_text(svg);cairosvg.svg2png(bytestring=svg.encode(),write_to=str(D/(name+'.png')),output_width=850,background_color="#ffffff");out.append(name+'.png')
cache={id(o):geometry(o)for g in [*G.values(),*FG.values()]for o in g.objects}
for ref in ['C103','C107','R702','R504','Q110','R125']:
 f=next(f for f in n.fps if f['ref']==ref);cx,cy=f['x'],f['y'];area=box(cx-2,cy-2,cx+2,cy+2);layer='F.Cu'if f['side']=='top'else'B.Cu';paste='F.Paste'if f['side']=='top'else'B.Paste'
 text=[f'<svg xmlns="http://www.w3.org/2000/svg" viewBox="{cx-2} {-cy-2.25} 4 4.25" width="800" height="850"><rect x="{cx-2}" y="{-cy-2.25}" width="4" height="4.25" fill="#fafbf7"/>',f'<text x="{cx-1.9}" y="{-cy-2.07}" font-family="sans-serif" font-size=".13">{ref}: {layer}, copper gold / factory paste blue; top coordinates</text>']
 for o in G[layer].objects:
  if cache[id(o)].intersects(area):text.append(svggeom(cache[id(o)].intersection(area),'#c7963f'))
 for o in FG[paste].objects:
  if cache[id(o)].intersects(area):text.append(svggeom(cache[id(o)].intersection(area),'#4166a9'))
 for p in n.pads:
  if p['ref']==ref:text.append(f'<text x="{p["x"]}" y="{-p["y"]}" text-anchor="middle" font-family="sans-serif" font-size=".11" fill="#111">{p["pin"]}</text>')
 text.append('</svg>');name=ref+'-factory-paste';svg=''.join(text);(D/(name+'.svg')).write_text(svg);cairosvg.svg2png(bytestring=svg.encode(),write_to=str(D/(name+'.png')));out.append(name+'.png')
assert all(hashlib.sha256(Path(k).read_bytes()).hexdigest()==v for k,v in hashes.items());(D/'rendered-cam-files.json').write_text(json.dumps({'outputs':out,'inputs':hashes,'notes':'Additional exact Gerber/Excellon renderings; bottoms remain in top coordinates, not mirrored.'},indent=2)+'\n');print(out)
