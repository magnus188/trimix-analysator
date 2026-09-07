#!/usr/bin/env python3
"""Compare archived model section boundaries with actual model toolpaths.

This is a raster feature-omission screen, not a global minimum-wall result.
It intentionally ignores sparse interior infill and tests material boundaries.
"""
from __future__ import annotations
import argparse,csv,json
from pathlib import Path
import xml.etree.ElementTree as ET
import zipfile
import numpy as np
from PIL import Image,ImageDraw,ImageFilter
from print_inspect import NS,PROD,matrix12,parse_gcode,get_bounds,font
from print_pipeline import dump,sha

def archived_triangles(z):
    main=ET.fromstring(z.read('3D/3dmodel.model'));cfg=ET.fromstring(z.read('Metadata/model_settings.config'))
    normal_ids={int(p.get('id')) for p in cfg.iter('part') if p.get('subtype')=='normal_part'}
    objects={int(o.get('id')):o for o in main.find(NS+'resources')};leaves={};out=[]
    for item in main.find(NS+'build'):
        build=matrix12(item.get('transform'));assembly=objects[int(item.get('objectid'))]
        for part in assembly.find(NS+'components'):
            pid=int(part.get('objectid'))
            if pid not in normal_ids:continue
            path=part.get(PROD+'path').lstrip('/')
            if path not in leaves:leaves[path]=ET.fromstring(z.read(path))
            obj=next(o for o in leaves[path].iter(NS+'object') if int(o.get('id'))==pid)
            vertices=np.array([[float(v.get(c)) for c in ('x','y','z')] for v in obj.iter(NS+'vertex')])
            faces=np.array([[int(t.get(c)) for c in ('v1','v2','v3')] for t in obj.iter(NS+'triangle')])
            m=build@matrix12(part.get('transform'));v=vertices@m[:3,:3].T+m[:3,3]
            out.append(v[faces])
    if not out:raise ValueError('No normal model part in archive')
    return np.concatenate(out)

def section_mask(tri,z,lower,upper,pitch=.25):
    size=np.ceil((upper-lower)/pitch).astype(int)+1
    mask=np.zeros((size[1],size[0]),dtype=bool)
    active=tri[(tri[:,:,2].min(1)<=z)&(tri[:,:,2].max(1)>z)]
    if not len(active):return Image.fromarray(mask)
    a=active;b=np.roll(active,-1,axis=1)
    hit=((a[:,:,2]<=z)&(b[:,:,2]>z))|((b[:,:,2]<=z)&(a[:,:,2]>z))
    if np.any(hit.sum(1)!=2):raise ValueError('Ambiguous triangle-plane section')
    aa=a[hit];bb=b[hit];points=aa+(bb-aa)*((z-aa[:,2])/(bb[:,2]-aa[:,2]))[:,None]
    segments=points[:,:2].reshape(-1,2,2);s0=segments[:,0];s1=segments[:,1]
    for row in range(size[1]):
        y=lower[1]+(row+.5)*pitch
        crossing=((s0[:,1]<=y)&(s1[:,1]>y))|((s1[:,1]<=y)&(s0[:,1]>y))
        if not crossing.any():continue
        left=s0[crossing];right=s1[crossing]
        xs=np.sort(left[:,0]+(y-left[:,1])/(right[:,1]-left[:,1])*(right[:,0]-left[:,0]))
        if len(xs)%2:raise ValueError('Open section scanline')
        for x0,x1 in xs.reshape(-1,2):
            i0=max(0,int(np.ceil((x0-lower[0])/pitch-.5)))
            i1=min(size[0],int(np.ceil((x1-lower[0])/pitch-.5)))
            mask[row,i0:i1]=True
    return Image.fromarray(mask)

def path_mask(layer,lower,upper,pitch=.25):
    size=np.ceil((upper-lower)/pitch).astype(int)+1;image=Image.new('1',tuple(size));draw=ImageDraw.Draw(image)
    for a,b,w,role in layer['segments']:
        if 'support' in role.lower() or 'brim' in role.lower():continue
        aa=(np.array(a[:2])-lower)/pitch-.5;bb=(np.array(b[:2])-lower)/pitch-.5
        draw.line([tuple(aa),tuple(bb)],fill=1,width=max(1,round(w/pitch)))
    return image

def inspect_sections(project):
    project=Path(project);dest=project.parent/'inspection';dest.mkdir(exist_ok=True)
    with zipfile.ZipFile(project) as z:
        tri=archived_triangles(z);gcode=z.read('Metadata/plate_1.gcode').decode()
        settings=json.loads(z.read('Metadata/project_settings.config'))
    layers,_=parse_gcode(gcode);lower,upper=get_bounds(layers);height=float(settings['layer_height']);rows=[]
    for layer in layers:
        if not any('support' not in r.lower() and 'brim' not in r.lower() for _,_,_,r in layer['segments']):continue
        plane=layer['z']-height/2
        expected=section_mask(tri,plane,lower,upper);mask=np.asarray(expected,dtype=bool)
        eroded=np.asarray(expected.filter(ImageFilter.MinFilter(3)),dtype=bool)
        boundary=mask&~eroded
        actual=path_mask(layer,lower,upper).filter(ImageFilter.MaxFilter(5))
        missing=boundary&~np.asarray(actual,dtype=bool)
        count=int(boundary.sum());miss=int(missing.sum())
        rows.append({'event':layer['index'],'toolpath_z_mm':layer['z'],'section_z_mm':round(plane,6),
          'boundary_pixels':count,'boundary_pixels_beyond_0_5mm_path_margin':miss,
          'uncovered_boundary_percent':round(100*miss/max(1,count),4)})
        if miss>=4:
            yy,xx=np.where(missing);bbox=[[float(lower[0]+xx.min()*.25),float(lower[1]+yy.min()*.25)],
                                       [float(lower[0]+(xx.max()+1)*.25),float(lower[1]+(yy.max()+1)*.25)]]
            rows[-1]['candidate_xy_bounds_mm']=json.dumps(bbox)
            raw=np.full((*mask.shape,3),255,dtype=np.uint8);raw[mask]=[225,231,234]
            raw[np.asarray(path_mask(layer,lower,upper),dtype=bool)]=[24,126,136];raw[missing]=[211,40,57]
            image=Image.fromarray(raw).transpose(Image.Transpose.FLIP_TOP_BOTTOM)
            scale=min(1400/image.width,1100/image.height)
            image=image.resize((round(image.width*scale),round(image.height*scale)),Image.Resampling.NEAREST)
            canvas=Image.new('RGB',(max(850,image.width+50),image.height+115),'white');canvas.paste(image,((canvas.width-image.width)//2,90));d=ImageDraw.Draw(canvas)
            d.text((20,15),f'{project.stem} • event {layer["index"]} • Z {layer["z"]:.2f} mm',fill='#15343e',font=font(22))
            d.text((20,49),'Grey: mesh section • teal: extrusion stroke • red: boundary >0.5 mm from a stroke (review candidate)',fill='#415c65',font=font(15))
            canvas.save(dest/f'section-candidate-{layer["index"]:03}.png')
        else:rows[-1]['candidate_xy_bounds_mm']=''
    with (dest/'model-boundary-sections.csv').open('w',newline='') as f:
        w=csv.DictWriter(f,fieldnames=rows[0]);w.writeheader();w.writerows(rows)
    suspect=[r for r in rows if r['boundary_pixels_beyond_0_5mm_path_margin']>=4]
    report={'project':str(project),'sha256':sha(project),'model_sections_checked':len(rows),
      'sections_with_at_least_4_uncovered_boundary_pixels':suspect,
      'max_uncovered_boundary_percent':max(r['uncovered_boundary_percent'] for r in rows),
      'pitch_mm':.25,'nominal_path_margin_mm':.5,
      'scope':'At every model-deposition event, cross-section the actual archived mesh at nominal layer midheight; compare its material boundary pixels with actual model extrusion strokes. Support-only events and sparse-infill interior voids are excluded.',
      'limits':['Raster and margin can miss submillimetre omissions.',
        'Rounded/stepped surfaces change within a layer; flagged rows are candidates for review, not automatically missing material.',
        'This does not calculate global wall thickness, printed strength, air tightness or physical feature accuracy.']}
    dump(dest/'model-boundary-sections.json',report);return report

if __name__=='__main__':
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('project',type=Path);a=p.parse_args()
    r=inspect_sections(a.project);print(json.dumps({k:r[k] for k in ['project','model_sections_checked','max_uncovered_boundary_percent','sections_with_at_least_4_uncovered_boundary_pixels']}))
