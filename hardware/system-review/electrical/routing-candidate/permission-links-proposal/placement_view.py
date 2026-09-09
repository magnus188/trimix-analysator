exec(open('hardware/system-review/electrical/routing-candidate/permission-links-proposal/scout_q110.py').read().split('candidates=[]')[0])
import cairosvg
out=['<svg xmlns="http://www.w3.org/2000/svg" width="1500" height="1400" viewBox="0 0 1500 1400"><rect width="1500" height="1400" fill="white"/><g transform="translate(20,60) scale(55,-55) translate(-3,75)">']
clip=box(3,-99,30,-75)
for t in n.tracks:
 if t['layer']=='F.Cu' and clip.intersects(t['geo']):out.append(t['geo'].svg(scale_factor=.0001,fill_color='#bacbca',opacity=.8).replace('stroke="#555555"','stroke="none"'))
for v in n.vias:
 if clip.intersects(v['geo']):out.append(v['geo'].svg(scale_factor=.0001,fill_color='#709890',opacity=.8).replace('stroke="#555555"','stroke="none"'))
for p in n.pads_on('F.Cu'):
 if clip.intersects(p['geo']):out.append(p['geo'].svg(scale_factor=.0001,fill_color='#aa80bb'if p['ref']in['Q110','Q111','R116','R118']else'#cccccc',opacity=.8).replace('stroke="#555555"','stroke="none"'))
for ref,g in cy.items():
 if not g.is_empty and clip.intersects(g):
  out.append(g.boundary.buffer(.012).svg(scale_factor=.0001,fill_color='#d06060',opacity=.8).replace('stroke="#555555"','stroke="none"'));pt=g.centroid;out.append(f'<g transform="translate({pt.x},{pt.y}) scale(1,-1)"><text font-size=".28" text-anchor="middle">{ref}</text></g>')
for x in range(4,30,2):out.append(f'<g transform="translate({x},-98.8) scale(1,-1)"><text font-size=".25">{x}</text></g>')
for y in range(76,99,2):out.append(f'<g transform="translate(3.1,{-y}) scale(1,-1)"><text font-size=".25">{y}</text></g>')
out.append('</g></svg>');(D/'placement.svg').write_text(''.join(out));cairosvg.svg2png(url=str(D/'placement.svg'),write_to=str(D/'placement.png'))
