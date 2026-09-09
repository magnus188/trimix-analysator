#!/usr/bin/env python3
"""Prepare native part STLs, exact mesh-cropped coupons and Bambu projects.

The native manifest is supplied by Fusion's serial geometry owner. This script
never calls Fusion and never sends jobs to a printer.
"""
from __future__ import annotations
import argparse
import json
from pathlib import Path
import shutil
import sys
import numpy as np
from print_pipeline import ROOT,PRINT,dump,sha,read_stl,write_stl,mesh_report,component_count,orient,slice_one,compound_3mf
from print_inspect import inspect

def native_manifest(path=None):
    path=Path(path) if path else ROOT/'verification/print-mesh-manifest.json'
    data=json.loads(path.read_text())
    if not data.get('parts'):raise ValueError('No native part exports')
    return data

def prepare(path=None):
    manifest=native_manifest(path)
    policy=json.loads((PRINT/'orientations.json').read_text())
    rows=[]
    for native in manifest['parts']:
        options=[p for p in policy['parts'] if p['component']==native['component']]
        if len(options)!=1:raise ValueError('No unique orientation for '+native['component'])
        rule=options[0];source=Path(native['file'])
        if native['units']!='mm':raise ValueError('Native units must be mm')
        if not source.exists():raise FileNotFoundError(source)
        rotation=policy['matrices'][rule['orientation']]
        target=PRINT/'oriented-stl'/(native['part_id']+'.stl')
        result=orient(source,target,rotation)
        actual=np.array(result['before']['bounds_mm']);nb=native['bounds_mm']
        expected=np.array([nb['min'],nb['max']] if isinstance(nb,dict) else nb)
        bound_error=float(np.max(np.abs(actual-expected)))
        if bound_error>.021:raise ValueError('Unexpected source bounds: '+native['part_id']+' '+str(bound_error))
        volume_error=abs(result['before']['signed_volume_mm3']-native['volume_mm3'])/native['volume_mm3']
        if volume_error>.005:raise ValueError('STL/native volume differs more than 0.5%: '+native['part_id'])
        row=dict(rule,part_id=native['part_id'],native_document=manifest['document'],native_description=native['description'],
          file=str(target),mesh=result,native_bound_max_error_mm=bound_error,native_relative_volume_error=volume_error)
        rows.append(row);print('Prepared '+native['part_id'],flush=True)
    result={'document':manifest['document'],'native_manifest_sha256':sha(path or ROOT/'verification/print-mesh-manifest.json'),
      'units':'mm','parts':rows,'status':'meshes_prepared; slicer and physical qualification separate'}
    dump(PRINT/'print-manifest.json',result);return result

def crop_mesh(source,destination,bounds):
    # Private workspace dependencies, deliberately not installed in user Python.
    sys.path.insert(0,str(PRINT/'.runtime_lib'))
    import trimesh
    tri=read_stl(source);mesh=trimesh.Trimesh(vertices=tri.reshape(-1,3),faces=np.arange(tri.size//3).reshape(-1,3),process=True)
    lower,upper=np.array(bounds,dtype=float)
    box=trimesh.creation.box(extents=upper-lower);box.apply_translation((lower+upper)/2)
    cut=trimesh.boolean.intersection([mesh,box],engine='manifold',check_volume=True)
    if cut is None or not len(cut.faces):raise ValueError('Empty coupon crop')
    components=component_count(cut.triangles)
    if not cut.is_watertight or not cut.is_winding_consistent or components!=1 or cut.volume<=0:
        raise ValueError('Crop must be a single closed positive-volume mesh: '+str(destination))
    write_stl(destination,cut.triangles)
    report=mesh_report(read_stl(destination))
    if any(report[k] for k in ('boundary_edges','nonmanifold_edges','degenerate_triangles')):
        raise ValueError('Exported crop failed topology: '+str(destination))
    return {'method':'Intersection of exact native-source STL with axis-aligned box using manifold3d; only crop/cap faces added. No scale or invented source feature.',
      'source':str(source),'source_sha256':sha(source),'assembly_crop_bounds_mm':bounds,
      'file':str(destination),'sha256':sha(destination),'connected_components':components,'mesh':report}

def coupons(path=None):
    manifest=native_manifest(path);native={p['part_id']:p for p in manifest['parts']}
    rules=json.loads((PRINT/'orientations.json').read_text())
    specs=[
      ('C01_gas_inlet','TMX-A3-P07',[[60,159,3],[83,170,36]],'front_down','gas_roof'),
      ('C02_gas_return','TMX-A3-P07',[[3,144,3],[14,168,36]],'front_down','gas_roof'),
      ('C03_m3_boss','TMX-A3-P01',[[0,0,29],[16,16,40.6]],'front_down','heat_set'),
      ('C04_holder_rail','TMX-A3-P01',[[44.5,50,14.3],[50.2,70,37]],'front_down','battery_fit'),
      ('C05_display_lip','TMX-A3-P01',[[0,55,0],[13,75,20]],'front_down','display_fit'),
      ('C06_usb_m2_frame','TMX-A3-P06',None,'front_down','heat_set'),
      ('C07_usb_bezel','TMX-A3-P09',None,'y_down','usb_fit'),
      ('C08_ao2_thread','TMX-A3-P11',None,'x_up','ao2_thread'),
    ];rows=[];failures=[]
    for cid,pid,bounds,orientation,requirement in specs:
        try:
            source=Path(native[pid]['file']);raw=PRINT/'coupons/source-stl'/(cid+'.stl');raw.parent.mkdir(parents=True,exist_ok=True)
            if bounds:record=crop_mesh(source,raw,bounds)
            else:
                shutil.copyfile(source,raw);record={'method':'Complete native exported printable used as exact fit coupon; no geometry change.',
                  'source':str(source),'source_sha256':sha(source),'file':str(raw),'sha256':sha(raw),'mesh':mesh_report(read_stl(raw))}
            target=PRINT/'coupons/oriented-stl'/(cid+'.stl')
            oriented=orient(raw,target,rules['matrices'][orientation])
            rows.append({'part_id':cid,'native_source_part_id':pid,'requirement':requirement,'orientation':orientation,
              'file':str(target),'mesh':oriented,'crop':record,'physical_status':'not printed / not measured'})
            print('Prepared coupon '+cid,flush=True)
        except Exception as error:
            failures.append({'coupon':cid,'error':str(error)});print('Coupon failed '+cid+': '+str(error),flush=True)
    result={'document':manifest['document'],'coupons':rows,'failures':failures,
      'seal_coupon_status':'No selected gasket/profile exists; seal-land coupon remains a requirement, not an invented tested seal.'}
    dump(PRINT/'coupons/coupon-manifest.json',result)
    return result

def slice_parts(materials=('pla','petg'),parts=None):
    manifest=json.loads((PRINT/'print-manifest.json').read_text());results=[];failures=[]
    if parts and (PRINT/'slice-manifest.json').exists():
        previous=json.loads((PRINT/'slice-manifest.json').read_text())
        results=[r for r in previous['parts'] if not (r['part_id'] in parts and r['material'] in materials)]
        failures=[r for r in previous['failures'] if not (r['part_id'] in parts and r['material'] in materials)]
    for row in manifest['parts']:
        if parts and row['part_id'] not in parts:continue
        for material in materials:
            pid=row['part_id'];print(f'Slicing {pid} {material}',flush=True)
            try:
                source=Path(row['file']);mode=row['mode']
                if row['id']=='chamber_body':
                    baseline=slice_one(source,material,'no_supports',pid+'_no_support_baseline')
                    blockers=json.loads((PRINT/'gas-support-blockers.json').read_text())['blockers']
                    source=compound_3mf(source,PRINT/'prepared-projects'/f'{pid}_{material}_protected.3mf',blockers,
                      row['mesh']['rotation_rows'],row['mesh']['translation_mm'],baseline['archive']['file'])
                    mode='accessible_supports'
                result=slice_one(source,material,mode,pid)
                audit=inspect(result['archive']['file'])
                results.append({'part_id':pid,'material':material,'project':result['archive']['file'],
                  'sha256':result['archive']['sha256'],'slice_seconds':result['seconds'],'layer_count':audit['layer_count'],
                  'support_segments':audit['generated_support_segments'],'protected_support_conflicts':len(audit['support_conflicts_with_exclusion_volumes']),
                  'island_candidate_layers':audit['island_candidate_layers'],'inspection':str(Path(result['archive']['file']).parent/'inspection/inspection.json'),
                  'status':'sliced; selected visual and physical validation pending'})
                print(f'Sliced {pid} {material}: {audit["layer_count"]} layers',flush=True)
            except Exception as error:
                failures.append({'part_id':pid,'material':material,'error':str(error)});print(f'FAILED {pid} {material}: {error}',flush=True)
            dump(PRINT/'slice-manifest.json',{'parts':results,'failures':failures,'physical_print_jobs_sent':False})
    if failures:raise RuntimeError('One or more slices failed; see slice-manifest.json')
    return results

def slice_coupons(materials=('pla','petg'),parts=None):
    manifest=json.loads((PRINT/'coupons/coupon-manifest.json').read_text());results=[];failures=[]
    if parts and (PRINT/'coupons/slice-manifest.json').exists():
        old=json.loads((PRINT/'coupons/slice-manifest.json').read_text())
        results=[r for r in old['coupons'] if not (r['coupon'] in parts and r['material'] in materials)]
        failures=[r for r in old['failures'] if not (r['coupon'] in parts and r['material'] in materials)]
    for row in manifest['coupons']:
        if parts and row['part_id'] not in parts:continue
        for material in materials:
            cid=row['part_id'];print(f'Slicing coupon {cid} {material}',flush=True)
            try:
                mode='accessible_supports' if cid in ('C03_m3_boss','C04_holder_rail','C05_display_lip','C06_usb_m2_frame','C07_usb_bezel') else 'no_supports'
                source=Path(row['file'])
                if row['requirement']=='gas_roof':
                    baseline=slice_one(source,material,'no_supports',cid+'_no_support_baseline')
                    blocks=json.loads((PRINT/'gas-support-blockers.json').read_text())['blockers']
                    source=compound_3mf(source,PRINT/'prepared-projects'/f'{cid}_{material}_protected.3mf',blocks,
                      row['mesh']['rotation_rows'],row['mesh']['translation_mm'],baseline['archive']['file'])
                    mode='accessible_supports'
                result=slice_one(source,material,mode,cid);audit=inspect(result['archive']['file'])
                results.append({'coupon':cid,'material':material,'project':result['archive']['file'],
                  'sha256':result['archive']['sha256'],'layer_count':audit['layer_count'],'support_segments':audit['generated_support_segments'],
                  'island_candidate_layers':audit['island_candidate_layers'],'physical_status':'not printed / not measured'})
            except Exception as error:failures.append({'coupon':cid,'material':material,'error':str(error)})
            dump(PRINT/'coupons/slice-manifest.json',{'coupons':results,'failures':failures,'physical_print_jobs_sent':False})
    if failures:raise RuntimeError('Coupon slicing failures; see coupons/slice-manifest.json')
    return results

if __name__=='__main__':
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('action',choices=['prepare','coupons','slice','slice-coupons'])
    parser.add_argument('--native-manifest',type=Path)
    parser.add_argument('--material',choices=['pla','petg','both'],default='both')
    parser.add_argument('--parts',nargs='*')
    a=parser.parse_args();materials=('pla','petg') if a.material=='both' else (a.material,)
    if a.action=='prepare':prepare(a.native_manifest)
    elif a.action=='coupons':coupons(a.native_manifest)
    elif a.action=='slice':slice_parts(materials,a.parts)
    else:slice_coupons(materials,a.parts)
