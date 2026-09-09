#!/usr/bin/env python3
"""Audit actual Bambu 3MF toolpaths and render selected layer contact sheets.

All-layer numeric checks are distinguished from selected-layer visual review.
No firmware commands are executed: G-code is read as text only.
"""
from __future__ import annotations
import argparse
from collections import Counter,defaultdict
import csv
import json
import math
from pathlib import Path
import re
import xml.etree.ElementTree as ET
import zipfile
import numpy as np
from PIL import Image,ImageDraw,ImageFont,ImageFilter
from print_pipeline import dump,sha

NUMBER=r'[-+]?(?:\d+(?:\.\d*)?|\.\d+)(?:[eE][-+]?\d+)?'
WORDS=re.compile(r'([XYZEFIJKR])('+NUMBER+')')
COLORS={'support': '#dc8c32','bridge':'#8b62ae','brim':'#abb4bd','model':'#187e88'}
NS='{http://schemas.microsoft.com/3dmanufacturing/core/2015/02}'
PROD='{http://schemas.microsoft.com/3dmanufacturing/production/2015/06}'

def role_color(role):
    r=role.lower()
    return COLORS['support' if 'support' in r else 'bridge' if 'bridge' in r else 'brim' if 'brim' in r else 'model']

def parse_gcode(text):
    position=np.zeros(3); e=0.;absolute_xyz=True;absolute_e=False
    role='Custom';width=.42;layer=-1;height=.2;active=False;layers=[];unhandled=[]
    for number,line in enumerate(text.splitlines(),1):
        if line.startswith('; CHANGE_LAYER'):
            layer+=1;active=True;layers.append({'index':layer+1,'z':None,'height':height,'segments':[]});continue
        if line.startswith('; Z_HEIGHT:'):
            if active:layers[-1]['z']=float(line.split(':',1)[1]);continue
        if line.startswith('; LAYER_HEIGHT:'):
            height=float(line.split(':',1)[1]);
            if active:layers[-1]['height']=height
            continue
        if line.startswith('; FEATURE:'):role=line.split(':',1)[1].strip();continue
        if line.startswith('; LINE_WIDTH:'):width=float(line.split(':',1)[1]);continue
        command=line.split(';',1)[0].strip()
        if not command:continue
        code=command.split()[0];values={k:float(v) for k,v in WORDS.findall(command)}
        if code=='G90':absolute_xyz=True;continue
        if code=='G91':absolute_xyz=False;continue
        if code=='M82':absolute_e=True;continue
        if code=='M83':absolute_e=False;continue
        if code=='G92':
            if 'E' in values:e=values['E']
            for i,key in enumerate('XYZ'):
                if key in values:position[i]=values[key]
            continue
        if code not in ('G0','G1','G2','G3'):continue
        end=position.copy()
        for i,key in enumerate('XYZ'):
            if key in values:end[i]=values[key] if absolute_xyz else position[i]+values[key]
        de=(values['E']-e if absolute_e else values['E']) if 'E' in values else 0.
        if 'E' in values:e=values['E'] if absolute_e else e+values['E']
        if active and de>1e-8 and role!='Custom':
            points=[position,end]
            if code in ('G2','G3'):
                if 'I' not in values and 'J' not in values:
                    unhandled.append({'line':number,'reason':'Arc without I/J centre','command':command})
                    position=end;continue
                center=position[:2]+[values.get('I',0),values.get('J',0)]
                radius=np.linalg.norm(position[:2]-center)
                start_angle=math.atan2(*(position[:2]-center)[::-1]);end_angle=math.atan2(*(end[:2]-center)[::-1])
                sweep=(end_angle-start_angle)%(2*math.pi)
                if code=='G2':sweep=sweep-2*math.pi if sweep>1e-10 else -2*math.pi
                elif sweep<1e-10:sweep=2*math.pi
                count=max(2,int(math.ceil(abs(sweep)*radius/.15)))
                angles=np.linspace(start_angle,start_angle+sweep,count+1)
                points=np.column_stack([center[0]+radius*np.cos(angles),center[1]+radius*np.sin(angles),np.linspace(position[2],end[2],count+1)])
                points[0]=position;points[-1]=end
            for start,finish in zip(points[:-1],points[1:]):
                if np.linalg.norm(finish[:2]-start[:2])>1e-7:
                    layers[-1]['segments'].append((start.tolist(),finish.tolist(),width,role))
        position=end
    return layers,unhandled

def matrix12(text):
    if not text:return np.eye(4)
    v=np.array(list(map(float,text.split())));m=np.eye(4)
    m[:3,:3]=v[:9].reshape(3,3).T;m[:3,3]=v[9:12];return m

def support_blocker_bounds(z):
    root=ET.fromstring(z.read('3D/3dmodel.model'));config=ET.fromstring(z.read('Metadata/model_settings.config'))
    types={int(p.get('id')):'support_blocker' for p in config.iter('part') if p.get('subtype')=='support_blocker'}
    names={int(p.get('id')):next((v.get('value') for v in p.findall('metadata') if v.get('key')=='name'),'blocker')
           for p in config.iter('part') if p.get('subtype')=='support_blocker'}
    leaves={};result=[]
    main_objects={int(o.get('id')):o for o in root.find(NS+'resources').findall(NS+'object')}
    for item in root.find(NS+'build').findall(NS+'item'):
        outer=matrix12(item.get('transform'));obj=main_objects[int(item.get('objectid'))]
        components=obj.find(NS+'components')
        if components is None:continue
        for component in components:
            pid=int(component.get('objectid'))
            if pid not in types:continue
            path=component.get(PROD+'path','3D/3dmodel.model').lstrip('/')
            if path not in leaves:leaves[path]=ET.fromstring(z.read(path))
            leaf=next(o for o in leaves[path].iter(NS+'object') if int(o.get('id'))==pid)
            vertices=np.array([[float(v.get(c)) for c in ('x','y','z')] for v in leaf.iter(NS+'vertex')])
            transform=outer@matrix12(component.get('transform'))
            transformed=vertices@transform[:3,:3].T+transform[:3,3]
            lower,upper=transformed.min(0),transformed.max(0)
            match=re.search(r'\[safety halo ([\d.]+)mm\]',names[pid]);halo=float(match.group(1)) if match else 0.
            result.append({'name':names[pid],'bounds_mm':[lower.tolist(),upper.tolist()],
              'safety_halo_mm':halo,'audit_core_bounds_mm':[(lower+halo).tolist(),(upper-halo).tolist()]})
    return result

def line_box(start,end,lower,upper):
    direction=end-start;t0=0.;t1=1.
    for axis in range(3):
        if abs(direction[axis])<1e-10:
            if start[axis]<lower[axis] or start[axis]>upper[axis]:return False
        else:
            low=(lower[axis]-start[axis])/direction[axis];high=(upper[axis]-start[axis])/direction[axis]
            if low>high:low,high=high,low
            t0=max(t0,low);t1=min(t1,high)
            if t1<t0:return False
    return True

def support_conflicts(layers,blockers):
    conflicts=[]
    for layer in layers:
        for start,end,width,role in layer['segments']:
            if 'support' not in role.lower():continue
            start=np.array(start);end=np.array(end)
            for block in blockers:
                low,high=np.array(block.get('audit_core_bounds_mm',block['bounds_mm']));low=low.copy();high=high.copy()
                # Conservative XY stroke envelope and the extruded layer below Z.
                low[:2]-=width/2;high[:2]+=width/2;high[2]+=layer['height']
                if line_box(start,end,low,high):
                    conflicts.append({'layer':layer['index'],'blocker':block['name'],'start_mm':start.tolist(),'end_mm':end.tolist(),'width_mm':width})
    return conflicts

def get_bounds(layers):
    points=[p[:2] for layer in layers for a,b,w,role in layer['segments'] for p in (a,b)]
    if not points:raise ValueError('No deposited layer toolpaths')
    points=np.array(points);return points.min(0)-1,points.max(0)+1

def raster_layer(layer,lower,upper,pitch=.25):
    size=np.maximum(2,np.ceil((upper-lower)/pitch).astype(int)+1)
    im=Image.new('1',tuple(size),0);draw=ImageDraw.Draw(im)
    for a,b,w,role in layer['segments']:
        if 'brim' in role.lower():continue
        start=(np.array(a[:2])-lower)/pitch;end=(np.array(b[:2])-lower)/pitch
        draw.line([tuple(start),tuple(end)],fill=1,width=max(1,round(w/pitch)))
    return im

def unsupported_components(mask,contact):
    """Row-run 8-connectivity; returns wholly unsupported connected islands."""
    arr=np.asarray(mask,dtype=bool);prior=np.asarray(contact,dtype=bool)
    parent=[];areas=[];supported=[];previous=[]
    def find(i):
        while parent[i]!=i:parent[i]=parent[parent[i]];i=parent[i]
        return i
    for y,row in enumerate(arr):
        transition=np.diff(np.r_[False,row,False].astype(np.int8));starts=np.where(transition==1)[0];ends=np.where(transition==-1)[0]-1
        current=[]
        for left,right in zip(starts,ends):
            index=len(parent);parent.append(index);areas.append(int(right-left+1));supported.append(bool(prior[y,left:right+1].any()))
            for pl,pr,pi in previous:
                if pr<left-1:continue
                if pl>right+1:break
                root=find(pi);own=find(index)
                if root!=own:
                    parent[own]=root;areas[root]+=areas[own];supported[root]|=supported[own]
            current.append((left,right,index))
        previous=current
    return [areas[i] for i in range(len(parent)) if find(i)==i and not supported[i]]

def connectivity_report(layers,lower,upper):
    rows=[];last_deposit=None;pitch=.25
    for layer in layers:
        mask=raster_layer(layer,lower,upper,pitch)
        current=np.asarray(mask,dtype=bool)
        # Bambu interleaves independent support Z events with 0.2 mm model
        # layers. Persist deposit height rather than forgetting prior model or
        # support paths after two intervening events.
        if last_deposit is not None:
            contact=Image.fromarray(last_deposit>=layer['z']-.5-1e-5).filter(ImageFilter.MaxFilter(3))
            islands=unsupported_components(mask,contact)
        else:islands=[]
        if last_deposit is None:last_deposit=np.full(current.shape,-1e6)
        last_deposit[current]=layer['z']
        roles=Counter(role for _,_,_,role in layer['segments'])
        support_count=sum(v for k,v in roles.items() if 'support' in k.lower())
        rows.append({'layer':layer['index'],'z_mm':layer['z'],'segments':len(layer['segments']),
          'support_segments':support_count,'island_candidates_ge_0_25mm2':sum(a*pitch*pitch>=.25 for a in islands),
          'largest_island_candidate_mm2':round(max(islands,default=0)*pitch*pitch,3),
          'occupied_raster_area_mm2':round(np.count_nonzero(np.asarray(mask))*pitch*pitch,3)})
    return rows

def font(size):
    p=Path('/System/Library/Fonts/Supplemental/Arial.ttf')
    return ImageFont.truetype(str(p),size) if p.exists() else ImageFont.load_default()

def contact_sheet(layers,lower,upper,dest,title,rows):
    count=len(layers)
    model_events=[i for i,l in enumerate(layers) if any('support' not in role.lower() and 'brim' not in role.lower() for a,b,w,role in l['segments'])]
    if not model_events:model_events=list(range(count))
    selected={model_events[i] for i in np.round(np.linspace(0,len(model_events)-1,min(8,len(model_events)))).astype(int)}
    changes=sorted(model_events[1:],key=lambda i:abs(rows[i]['occupied_raster_area_mm2']-rows[i-1]['occupied_raster_area_mm2']),reverse=True)
    for i in changes:
        if len(selected)>=12:break
        selected.add(i)
    selected=sorted(selected);columns=4;tilew=450;tileh=370;header=105
    canvas=Image.new('RGB',(columns*tilew,header+math.ceil(len(selected)/columns)*tileh+50),'#f4f7f8');draw=ImageDraw.Draw(canvas)
    draw.text((28,20),title,fill='#15343e',font=font(27))
    draw.text((28,59),'Actual Bambu G-code • teal: model • orange: support • purple: bridge • grey: brim',fill='#415c65',font=font(18))
    for n,index in enumerate(selected):
        ox=(n%columns)*tilew;oy=header+(n//columns)*tileh
        draw.rounded_rectangle((ox+10,oy+8,ox+tilew-10,oy+tileh-8),radius=12,fill='white')
        layer=layers[index]
        draw.text((ox+24,oy+20),f"Layer {layer['index']} / {count} — Z {layer['z']:.2f} mm",fill='#15343e',font=font(18))
        scale=min((tilew-65)/(upper[0]-lower[0]),(tileh-85)/(upper[1]-lower[1]))
        centre=(lower+upper)/2
        def point(v):return (ox+tilew/2+(v[0]-centre[0])*scale,oy+tileh/2+22-(v[1]-centre[1])*scale)
        for a,b,width,role in layer['segments']:
            draw.line([point(a),point(b)],fill=role_color(role),width=max(1,round(width*scale)))
    draw.text((28,canvas.height-34),'Selected model-deposition events; Bambu also interleaves support-only heights. Every event is screened numerically; physical printing is unverified.',fill='#415c65',font=font(15))
    canvas.save(dest)
    return [int(i+1) for i in selected]

def inspect(path,destination=None):
    path=Path(path);destination=Path(destination) if destination else path.parent/'inspection';destination.mkdir(parents=True,exist_ok=True)
    with zipfile.ZipFile(path) as z:
        members=[n for n in z.namelist() if n.endswith('.gcode')]
        if len(members)!=1:raise ValueError('Expected exactly one plate per project')
        text=z.read(members[0]).decode();settings=json.loads(z.read('Metadata/project_settings.config'))
        blockers=support_blocker_bounds(z)
        slicer_info=ET.fromstring(z.read('Metadata/slice_info.config'))
        warnings=[ET.tostring(n,encoding='unicode') for n in slicer_info.iter('warning')]
        native_images=[]
        for name in ('Metadata/plate_1.png','Metadata/top_1.png'):
            if name in z.namelist():
                target=destination/Path(name).name;target.write_bytes(z.read(name));native_images.append(str(target))
    layers,unhandled=parse_gcode(text);lower,upper=get_bounds(layers)
    rows=connectivity_report(layers,lower,upper)
    conflicts=support_conflicts(layers,blockers)
    selected=contact_sheet(layers,lower,upper,destination/'layers.png',path.stem,rows)
    with (destination/'all-layers.csv').open('w',newline='') as f:
        writer=csv.DictWriter(f,fieldnames=rows[0].keys());writer.writeheader();writer.writerows(rows)
    declared_layers=re.search(r'^; total layer number: (\d+)',text,re.M)
    report={'project':str(path),'sha256':sha(path),'slicer':re.search(r'^; BambuStudio (.+)',text,re.M).group(1),
      'layer_count':len(layers),'declared_layer_count':int(declared_layers.group(1)) if declared_layers else None,
      'settings':{k:settings.get(k) for k in ['printer_model','nozzle_diameter','layer_height','filament_type','curr_bed_type','enable_support','support_type','wall_loops']},
      'generated_support_segments':sum(r['support_segments'] for r in rows),
      'support_blockers_in_archive':blockers,'support_conflicts_with_exclusion_volumes':conflicts,
      'island_candidate_layers':[r for r in rows if r['island_candidates_ge_0_25mm2']],
      'unhandled_extruding_moves':unhandled,'slicer_warnings':warnings,
      'selected_visual_layers':selected,'native_plate_images':native_images,
      'limits':['G2/G3 arcs are linearized at at most 0.15 mm path steps.',
        'All-layer connectivity is a 0.25 mm raster screening of connected deposits, retaining prior deposit Z within0.5mm and one-pixel contact margin. This accommodates independently interleaved support layers; it is not a bridge-strength or full unsupported-area proof.',
        'Support conflict checks use conservative XY line-width envelopes and layer thickness against the core of actual archived blocker boxes, excluding their named bead-width safety halo.',
        'Selected contact sheet has not been marked visually reviewed automatically.',
        'No physical print, sensor installation, seal, heat-set or thermal qualification is implied.'],
      'physical_print_jobs_sent':False,'visual_review':'pending'}
    dump(destination/'inspection.json',report)
    if unhandled:raise RuntimeError('Unhandled extruding moves; inspect report')
    if conflicts:raise RuntimeError('Support intersects protected volume; inspect report')
    return report

if __name__=='__main__':
    parser=argparse.ArgumentParser(description=__doc__);parser.add_argument('project',type=Path);parser.add_argument('--destination',type=Path)
    args=parser.parse_args();report=inspect(args.project,args.destination)
    print(json.dumps({k:report[k] for k in ['project','layer_count','generated_support_segments','island_candidate_layers','support_conflicts_with_exclusion_volumes','unhandled_extruding_moves']}))
