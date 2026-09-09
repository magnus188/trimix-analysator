from pathlib import Path
import sys,sexpdata,json,hashlib,cairosvg
D=Path(__file__).resolve().parent;sys.path.insert(0,str(D.parents[1]/'main-final-independent'))
from cam_geometry import *
files=['before.kicad_pcb','Trimix_Analyzer.kicad_pcb'];area=box(1,-86.5,23,-73)
colors={'CHG_INT_N':'#d47716','HOST_3V3':'#89a1c5','GND':'#aacbae','USB_5V':'#e19f5a','USB_OVP_5V':'#2769bc','USB_CHG_5V':'#c1407b','USB_PERMISSION_Q':'#8657a5'}
rows=[];natives=[]
for f in files:
 n=Native(sexpdata.loads((D/f).read_text()));natives.append(n);plane=unary_union([z['geo']for z in n.zones if z['net']=='GND'and z['layer']=='In1.Cu'])
 islands=[]
 for i,z in enumerate(n.zones):
  if z['net']!='GND'or z['layer']!='In2.Cu'or not z['geo'].intersects(area):continue
  for g in polys(z['geo']):
   anchors=[]
   for j,v in enumerate(n.vias):
    if v['net']=='GND'and g.intersection(v['geo']).area>1e-8:anchors.append({'kind':'through_via','xy_mm':[v['xy'][0],-v['xy'][1]],'overlap_mm2':g.intersection(v['geo']).area})
   for q in n.pads_on('In2.Cu'):
    if q['net']=='GND'and str(q['raw'][2])=='thru_hole' and bool(sub(q['raw'],'drill'))and g.intersection(q['geo']).area>1e-8:anchors.append({'kind':'plated_pad','ref':q['ref'],'pin':q['pin'],'xy_mm':[q['x'],-q['y']]})
   islands.append({'area_mm2':g.area,'bounds_xy_yup_mm':list(g.bounds),'direct_barrel_anchors':anchors})
 rows.append({'file':f,'sha256':hashlib.sha256((D/f).read_bytes()).hexdigest(),'In1_ground_filled_regions':len(polys(plane)),'In1_ground_area_mm2':plane.area,'local_In2_ground_filled_regions':islands})

def draw(g,c):
 s=''
 for q in polys(g):
  d=' '.join('M '+' L '.join(f'{x:.5f},{-y:.5f}' for x,y in r.coords)+' Z'for r in[q.exterior,*q.interiors]);s+=f'<path d="{d}" fill="{c}" fill-rule="evenodd"/>'
 return s
s=['<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 90 30" width="2520" height="840"><rect width="90" height="30" fill="white"/>']
for k,n in enumerate(natives):
 for j,L in enumerate(['F.Cu','B.Cu','In1.Cu','In2.Cu']):
  s.append(f'<g transform="translate({j*22.5-1},{k*15-72})">')
  for z in n.zones:
   if z['layer']==L and z['geo'].intersects(area):s.append(draw(z['geo'].intersection(area),'#dfede1'))
  for q in n.pads_on(L):
   if q['geo'].intersects(area):s.append(draw(q['geo'].intersection(area),colors.get(q['net'],'#c4ccd2')))
  for q in n.tracks:
   if q['layer']==L and q['geo'].intersects(area):s.append(draw(q['geo'].intersection(area),colors.get(q['net'],'#c4ccd2')))
  for v in n.vias:
   if v['geo'].intersects(area):s.append(draw(v['geo'],colors.get(v['net'],'#c4ccd2')));s.append(draw(Point(v['xy']).buffer(v['drill']/2),'white'))
  for q in n.pads_on(L):
   if q['geo'].intersects(area)and q['ref'] in ['U101','C101','C102','C105','C108','R107','R803','L101']:
    s.append(f'<text x="{q["x"]}" y="{-q["y"]+.06}" font-size=".22" text-anchor="middle">{q["ref"]}.{q["pin"]}</text>')
  s.append(f'<text x="1.1" y="72.8" font-size=".45">{["BEFORE","PROPOSAL"][k]} {L}</text></g>')
s.append('</svg>');svg=''.join(s);(D/'ground-comparison.svg').write_text(svg);cairosvg.svg2png(bytestring=svg.encode(),write_to=str(D/'ground-comparison.png'))
output={'scope':'Exact filled copper comparison; In2 local polygons versus through-GND anchors. Global In1 geometrical continuity recorded. Not a field, loop-inductance or EMC simulation.','inputs':rows,'native_DRC_separate':'after-drc.json','new_In1_signal_tracks':False,'ground_slot_review_pending':True}
(D/'ground-comparison.json').write_text(json.dumps(output,indent=2)+'\n')
for r in rows:print(r['file'],'In1',r['In1_ground_filled_regions'],'localIn2',[(round(x['area_mm2'],4),len(x['direct_barrel_anchors']))for x in r['local_In2_ground_filled_regions']])
