#!/usr/bin/env python3
"""Reproducible, local-only Bambu Studio slicing for the A3 print release.

No printer API or send action is implemented. Uses an isolated --datadir and
resolves the installed system presets; never reads or edits user presets.
Requires Python 3 and numpy (available in Codex's bundled Python runtime).
"""
from __future__ import annotations
import argparse
import hashlib
import json
import os
from pathlib import Path
import re
import struct
import subprocess
import sys
import time
import zipfile
import xml.etree.ElementTree as ET
import numpy as np

ROOT = Path(__file__).resolve().parents[1]
PRINT = ROOT / 'printing'
APP = Path('/Applications/BambuStudio.app/Contents/MacOS/BambuStudio')
PROFILES = APP.parents[1] / 'Resources/profiles/BBL'
MACHINE = 'Bambu Lab H2D 0.4 nozzle'
PROCESS = '0.20mm Standard @BBL H2D'
MATERIALS = {'pla': 'Generic PLA @BBL H2D', 'petg': 'Generic PETG @BBL H2D'}
IDENTITY = [[1,0,0],[0,1,0],[0,0,1]]
REAR_DOWN = [[1,0,0],[0,-1,0],[0,0,-1]]
X_UP = [[0,0,-1],[0,1,0],[1,0,0]]
Y_UP = [[1,0,0],[0,0,-1],[0,1,0]]

def dump(path, value):
    path=Path(path); path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(value, indent=2, ensure_ascii=False)+'\n')

def sha(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()

def preset_index():
    index={}
    for p in sorted(PROFILES.rglob('*.json')):
        try: data=json.loads(p.read_text())
        except (ValueError, UnicodeDecodeError): continue
        if data.get('name'): index[data['name']]=p
        index.setdefault(p.stem,p)
    return index

def resolve_preset(name, index, stack=()):
    if name in stack: raise ValueError('Preset inheritance cycle: '+str(stack+(name,)))
    p=index[name]; data=json.loads(p.read_text()); result={}; sources=[]
    if data.get('inherits'):
        parent, chain=resolve_preset(data['inherits'],index,stack+(name,))
        result.update(parent); sources+=chain
    for included in data.get('include',[]):
        inc, chain=resolve_preset(included,index,stack+(name,))
        result.update(inc); sources+=chain
    result.update({k:v for k,v in data.items() if k not in ('inherits','include')})
    sources.append({'path':str(p),'sha256':sha(p)})
    return result, sources

def make_profiles():
    index=preset_index(); dest=PRINT/'profiles'; evidence={}
    machine, src=resolve_preset(MACHINE,index)
    # Preserve Bambu's complete official machine G-code and physical limits.
    dump(dest/'h2d_04.json',machine); evidence['machine']=src
    for material, name in MATERIALS.items():
        filament, src=resolve_preset(name,index)
        dump(dest/f'{material}.json',filament); evidence[material]=src
    for mode in ('accessible_supports','no_supports'):
        process, src=resolve_preset(PROCESS,index)
        process.update({
          'name':f'Trimix A3 0.20 {mode} @BBL H2D',
          'print_settings_id':f'Trimix A3 0.20 {mode} @BBL H2D',
          'layer_height':'0.2', 'initial_layer_print_height':'0.2',
          'wall_loops':'4', 'top_shell_layers':'5', 'bottom_shell_layers':'5',
          'sparse_infill_density':'20%', 'sparse_infill_pattern':'gyroid',
          'enable_support':'1' if mode=='accessible_supports' else '0',
          'support_type':'normal(auto)', 'support_style':'snug',
          'support_on_build_plate_only':'0', 'support_threshold_angle':'30',
          'support_top_z_distance':'0.2', 'support_bottom_z_distance':'0.2',
          'support_object_xy_distance':'0.35', 'support_interface_top_layers':'3',
          'brim_type':'outer_only', 'brim_width':'4', 'brim_object_gap':'0.15',
          'enable_prime_tower':'0', 'timelapse_type':'0',
          'curr_bed_type':'Textured PEI Plate', 'print_sequence':'by layer',
        })
        dump(dest/f'{mode}.json',process); evidence[mode]=src
    dump(dest/'provenance.json',{
      'basis':'Flattened installed Bambu Studio system presets; inherits then include then local values.',
      'upstream':'https://github.com/bambulab/BambuStudio',
      'cli_documentation':'https://github.com/bambulab/BambuStudio/wiki/Command-Line-Usage',
      'process_role':'Conservative starting profiles for dry mechanical prototypes; not thermally or gas qualified.',
      'user_profiles_accessed':False, 'sources':evidence})
    return dest

def read_stl(path):
    raw=Path(path).read_bytes()
    if len(raw)>=84 and 84+struct.unpack_from('<I',raw,80)[0]*50==len(raw):
        dtype=np.dtype([('normal','<f4',(3,)),('vertices','<f4',(3,3)),('attr','<u2')])
        tri=np.frombuffer(raw, dtype=dtype, offset=84)['vertices'].astype(np.float64)
    else:
        points=re.findall(rb'\bvertex\s+([-+\deE.]+)\s+([-+\deE.]+)\s+([-+\deE.]+)',raw)
        if not points or len(points)%3: raise ValueError('Invalid or empty STL: '+str(path))
        tri=np.array(points,dtype=np.float64).reshape(-1,3,3)
    if not np.isfinite(tri).all(): raise ValueError('Non-finite mesh coordinates')
    return tri

def write_stl(path,tri):
    path=Path(path); path.parent.mkdir(parents=True,exist_ok=True)
    dtype=np.dtype([('normal','<f4',(3,)),('vertices','<f4',(3,3)),('attr','<u2')])
    data=np.zeros(len(tri),dtype=dtype); data['vertices']=tri
    normals=np.cross(tri[:,1]-tri[:,0],tri[:,2]-tri[:,0]); norms=np.linalg.norm(normals,axis=1)
    good=norms>1e-12; normals[good]/=norms[good,None]; data['normal']=normals
    path.write_bytes(b'Trimix A3; millimetres; local preparation only'.ljust(80,b' ')+struct.pack('<I',len(tri))+data.tobytes())

def mesh_report(tri):
    flat=tri.reshape(-1,3); verts, ids=np.unique(np.round(flat,6),axis=0,return_inverse=True)
    faces=ids.reshape(-1,3)
    edges=np.sort(np.concatenate([faces[:,[0,1]],faces[:,[1,2]],faces[:,[2,0]]]),axis=1)
    _, counts=np.unique(edges,axis=0,return_counts=True)
    area2=np.linalg.norm(np.cross(tri[:,1]-tri[:,0],tri[:,2]-tri[:,0]),axis=1)
    volume=float(np.einsum('ij,ij->i',tri[:,0],np.cross(tri[:,1],tri[:,2])).sum()/6)
    return {'triangles':len(tri),'vertices':len(verts),'bounds_mm':[flat.min(0).tolist(),flat.max(0).tolist()],
      'size_mm':np.ptp(flat,axis=0).tolist(),'signed_volume_mm3':volume,
      'boundary_edges':int((counts==1).sum()),'nonmanifold_edges':int((counts>2).sum()),
      'degenerate_triangles':int((area2<1e-10).sum()),
      'method':'STL welded to 1e-6 mm for edge counts; topology gate, not self-intersection proof'}

def component_count(tri):
    """Count edge-connected face sets without an optional graph dependency."""
    _,indices=np.unique(np.round(tri.reshape(-1,3),6),axis=0,return_inverse=True)
    faces=indices.reshape(-1,3);parent=np.arange(len(faces));edges={}
    def find(i):
        while parent[i]!=i:parent[i]=parent[parent[i]];i=parent[i]
        return i
    for i,face in enumerate(faces):
        for a,b in ((face[0],face[1]),(face[1],face[2]),(face[2],face[0])):
            key=(min(a,b),max(a,b))
            if key in edges:
                first,second=find(i),find(edges[key])
                if first!=second:parent[first]=second
            else:edges[key]=i
    return len({find(i) for i in range(len(faces))})

def orient(path, dest, rotation):
    tri=read_stl(path); before=mesh_report(tri); matrix=np.asarray(rotation,dtype=float)
    if not np.allclose(matrix@matrix.T,np.eye(3)) or not np.isclose(np.linalg.det(matrix),1):
        raise ValueError('Orientation must be a proper rigid rotation')
    rotated=tri@matrix.T; minimum=rotated.reshape(-1,3).min(0)
    rotated-=minimum; write_stl(dest,rotated)
    after=mesh_report(rotated)
    if any(after[k] for k in ('boundary_edges','nonmanifold_edges','degenerate_triangles')):
        raise ValueError('Mesh topology failed: '+json.dumps(after))
    if after['signed_volume_mm3']<=0: raise ValueError('Nonpositive oriented mesh volume')
    return {'source':str(path),'source_sha256':sha(path),'oriented':str(dest),'oriented_sha256':sha(dest),
      'rotation_rows':rotation,'translation_mm':(-minimum).tolist(),'before':before,'after':after,
      'unit_conversion':False,'scale':1.0}

def run_cli(args, log, timeout=900):
    datadir=PRINT/'isolated-bambu-data'; datadir.mkdir(parents=True,exist_ok=True)
    command=[str(APP),'--datadir',str(datadir),'--debug','2']+list(map(str,args))
    log=Path(log);log.parent.mkdir(parents=True,exist_ok=True)
    started=time.time()
    with log.open('w') as f:
        process=subprocess.Popen(command,stdout=f,stderr=subprocess.STDOUT)
        try: result=process.wait(timeout=timeout)
        except subprocess.TimeoutExpired:
            process.terminate()
            try: process.wait(timeout=10)
            except subprocess.TimeoutExpired: process.kill();process.wait()
            raise RuntimeError('Bambu Studio timeout; see '+str(log))
    return {'command':command,'exit_code':result,'seconds':round(time.time()-started,2),'log':str(log)}

def inspect_3mf(path):
    with zipfile.ZipFile(path) as z:
        gcode=[n for n in z.namelist() if n.endswith('.gcode')]
        configs=[n for n in z.namelist() if n.endswith('project_settings.config')]
        settings=json.loads(z.read(configs[0])) if configs else {}
        return {'file':str(path),'sha256':sha(path),'zip_test_error':z.testzip(),'gcode_members':gcode,
          'settings':{k:settings.get(k) for k in ['printer_model','printer_settings_id','nozzle_diameter','layer_height','filament_type','curr_bed_type','enable_support','support_type','wall_loops']},
          'members':z.namelist()}

def slice_one(stl, material, mode, part_id, timeout=900):
    make_profiles()
    project_root=PRINT/'diagnostics/projects' if part_id.startswith('pipeline_') or part_id.endswith('_no_support_baseline') else PRINT/'projects'
    base=project_root/material/part_id; base.mkdir(parents=True,exist_ok=True)
    project=base/f'{part_id}_{material}.3mf';profiles=PRINT/'profiles'
    result=run_cli(['--load-settings',str(profiles/'h2d_04.json')+';'+str(profiles/f'{mode}.json'),
      '--load-filaments',profiles/f'{material}.json','--orient','0','--arrange','1',
      '--ensure-on-bed','--slice','0','--export-3mf',project.name,'--outputdir',base,
      '--export-slicedata',base/'slicedata','--mstpp','600',stl],base/'slice.log',timeout)
    if project.exists(): result['archive']=inspect_3mf(project)
    dump(base/'slice-result.json',result)
    if result['exit_code']!=0 or not project.exists(): raise RuntimeError('Slice failed; see '+str(base/'slice.log'))
    if not result['archive']['gcode_members']: raise RuntimeError('Export has no G-code')
    return result

def box_triangles(bounds):
    lo,hi=np.asarray(bounds,dtype=float)
    v=np.array([[x,y,z] for z in [lo[2],hi[2]] for y in [lo[1],hi[1]] for x in [lo[0],hi[0]]])
    faces=[[0,2,1],[1,2,3],[4,5,6],[5,7,6],[0,1,4],[1,5,4],
           [2,6,3],[3,6,7],[0,4,2],[2,4,6],[1,3,5],[3,7,5]]
    return v[np.array(faces)]

def compound_3mf(stl, destination, blockers, rotation=None, translation=None, template=None):
    """Write editable Bambu support-blocker parts in the same model assembly.

    Part subtype is grounded in Bambu Studio ModelVolume::type_from_string and
    bbs_3mf.cpp. Blockers are not negative/printable geometry. Bounds are
    transformed using exactly the mesh's orientation transform.
    """
    if template is not None:
        return add_blockers_to_bambu_project(template,destination,blockers,rotation,translation)
    raise ValueError('An actual Bambu-generated template is required; standalone partial metadata crashes Bambu 2.8')

def add_blockers_to_bambu_project(template,destination,blockers,rotation=None,translation=None):
    ns='http://schemas.microsoft.com/3dmanufacturing/core/2015/02'
    prod='http://schemas.microsoft.com/3dmanufacturing/production/2015/06'
    ET.register_namespace('',ns)
    ET.register_namespace('p',prod)
    with zipfile.ZipFile(template) as z: data={n:z.read(n) for n in z.namelist()}
    model=ET.fromstring(data['3D/3dmodel.model']);config=ET.fromstring(data['Metadata/model_settings.config'])
    q=lambda tag:'{'+ns+'}'+tag
    assembly=model.find(q('resources')).find(q('object'))
    components=assembly.find(q('components'))
    if components is None:raise ValueError('Template has no component assembly')
    leafpath=components.find(q('component')).get('{'+prod+'}path').lstrip('/')
    leaf=ET.fromstring(data[leafpath]);resources=leaf.find(q('resources'))
    config_object=config.find('object')
    if len(config.findall('object'))!=1:raise ValueError('Expected one Bambu object')
    max_id=max(int(o.get('id')) for m in (model,leaf) for o in m.iter(q('object')))
    rotation=np.array(rotation if rotation is not None else IDENTITY,dtype=float)
    translation=np.array(translation if translation is not None else [0,0,0],dtype=float)
    for index,blocker in enumerate(blockers,1):
        halo=float(blocker.get('safety_halo_mm',.35));bounds=np.array(blocker['bounds_mm'],dtype=float)
        bounds[0]-=halo;bounds[1]+=halo
        tri=box_triangles(bounds)@rotation.T+translation
        pid=max_id+index
        obj=ET.SubElement(resources,q('object'),{'id':str(pid),'type':'other'})
        mesh=ET.SubElement(obj,q('mesh'));vertices=ET.SubElement(mesh,q('vertices'));triangles=ET.SubElement(mesh,q('triangles'))
        verts,indices=np.unique(tri.reshape(-1,3),axis=0,return_inverse=True)
        for vertex in verts:
            ET.SubElement(vertices,q('vertex'),dict(zip(('x','y','z'),(f'{v:.8f}' for v in vertex))))
        for face in indices.reshape(-1,3):
            ET.SubElement(triangles,q('triangle'),dict(zip(('v1','v2','v3'),map(str,face))))
        part=ET.SubElement(config_object,'part',{'id':str(pid),'subtype':'support_blocker'})
        ET.SubElement(part,'metadata',{'key':'name','value':blocker['id']+f' [safety halo {halo:g}mm]'})
        ET.SubElement(part,'metadata',{'key':'matrix','value':'1 0 0 0 0 1 0 0 0 0 1 0 0 0 0 1'})
        ET.SubElement(components,q('component'),{'objectid':str(pid),'{'+prod+'}path':'/'+leafpath,
          'transform':'1 0 0 0 1 0 0 0 1 0 0 0'})
    data['3D/3dmodel.model']=ET.tostring(model,encoding='utf-8',xml_declaration=True)
    data[leafpath]=ET.tostring(leaf,encoding='utf-8',xml_declaration=True)
    data['Metadata/model_settings.config']=ET.tostring(config,encoding='utf-8',xml_declaration=True)
    # Keep complete Bambu project metadata. Subsequent --slice recomputes G-code.
    destination=Path(destination);destination.parent.mkdir(parents=True,exist_ok=True)
    with zipfile.ZipFile(destination,'w',zipfile.ZIP_DEFLATED) as z:
        for n,raw in data.items():z.writestr(n,raw)
    return destination

def support_smoke():
    # An L-shaped extrusion makes the blocker test exercise actual support.
    polygon=np.array([[0,0],[4,0],[4,10],[12,10],[12,14],[0,14]],float)
    vertices=np.array([[x,y,z] for y in [0,10] for x,z in polygon])
    faces=[]
    ends=[[0,1,2],[0,2,5],[2,3,4],[2,4,5]]
    faces+=ends;faces+=[[a+6,c+6,b+6] for a,b,c in ends]
    for a in range(6):
        b=(a+1)%6;faces.extend([[a,a+6,b],[b,a+6,b+6]])
    tri=vertices[np.array(faces)]
    if mesh_report(tri)['signed_volume_mm3']<0:tri=tri[:,[0,2,1]]
    source=PRINT/'pipeline-check/cantilever.stl';write_stl(source,tri)
    regular=slice_one(source,'pla','accessible_supports','pipeline_support')
    blocked=compound_3mf(source,PRINT/'pipeline-check/cantilever_blocked.3mf',[
      {'id':'Test blocker','bounds_mm':[[3.9,-.1,0],[12.1,10.1,10.1]]}],template=regular['archive']['file'])
    modified=slice_one(blocked,'pla','accessible_supports','pipeline_blocker')
    results=[]
    for result in (regular,modified):
        with zipfile.ZipFile(result['archive']['file']) as z:
            cfg=ET.fromstring(z.read('Metadata/model_settings.config'))
            support_parts=[p.attrib for p in cfg.iter('part') if p.get('subtype')=='support_blocker']
            info=ET.fromstring(z.read('Metadata/slice_info.config'))
            support=next((m.get('value') for m in info.iter('metadata') if m.get('key')=='support_used'),None)
            gcode=z.read('Metadata/plate_1.gcode').decode()
            support_roles=len(re.findall(r'^; FEATURE: Support',gcode,re.M))
            results.append({'file':result['archive']['file'],'support_parts':support_parts,'support_used':support,'support_feature_markers':support_roles})
    passed=results[0]['support_feature_markers']>0 and results[1]['support_feature_markers']==0 and len(results[1]['support_parts'])==1
    dump(PRINT/'pipeline-check/support-blocker-verification.json',{'passed':passed,'results':results,
      'scope':'Actual Bambu CLI differential slice of same overhang with/without blocker; integration specimen only.'})
    if not passed:raise RuntimeError('Support-blocker differential test failed')
    return results

def smoke_cube():
    # Algorithm integration specimen only, never substituted for a CAD part.
    v=np.array([[x,y,z] for z in [0,10] for y in [0,10] for x in [0,10]],dtype=float)
    faces=[[0,2,1],[1,2,3],[4,5,6],[5,7,6],[0,1,4],[1,5,4],
           [2,6,3],[3,6,7],[0,4,2],[2,4,6],[1,3,5],[3,7,5]]
    p=PRINT/'pipeline-check/cube_10mm.stl';write_stl(p,v[np.array(faces)])
    return p

def main():
    parser=argparse.ArgumentParser(description=__doc__)
    sub=parser.add_subparsers(dest='action',required=True)
    sub.add_parser('profiles');sub.add_parser('smoke');sub.add_parser('support-smoke')
    orient_p=sub.add_parser('orient');orient_p.add_argument('source',type=Path);orient_p.add_argument('destination',type=Path)
    orient_p.add_argument('--orientation',choices=['front_down','rear_down','x_up','y_up'],default='front_down')
    slice_p=sub.add_parser('slice');slice_p.add_argument('source',type=Path)
    slice_p.add_argument('--material',choices=MATERIALS,required=True)
    slice_p.add_argument('--mode',choices=['accessible_supports','no_supports'],required=True)
    slice_p.add_argument('--part-id',required=True)
    a=parser.parse_args()
    if a.action=='profiles': print(make_profiles())
    elif a.action=='support-smoke':print(json.dumps(support_smoke()))
    elif a.action=='smoke':
        for m in MATERIALS: print(json.dumps(slice_one(smoke_cube(),m,'no_supports','pipeline_cube')))
    elif a.action=='orient':
        r=orient(a.source,a.destination,{'front_down':IDENTITY,'rear_down':REAR_DOWN,'x_up':X_UP,'y_up':Y_UP}[a.orientation])
        dump(a.destination.with_suffix('.orientation.json'),r);print(json.dumps(r))
    else: print(json.dumps(slice_one(a.source,a.material,a.mode,a.part_id)))

if __name__=='__main__': main()
