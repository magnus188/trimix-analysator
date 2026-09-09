#!/usr/bin/env python3
"""Local Bambu H2D diagnostic slicing of three changed parts; never sends a job."""
from pathlib import Path
import json,sys
BASE=Path(__file__).resolve().parents[1]
ROOT=BASE.parents[2]
sys.path.insert(0,str(ROOT/'hardware/cad/rev04/3d-print/scripts'))
import print_pipeline as pipeline
import print_inspect
pipeline.ROOT=BASE;pipeline.PRINT=BASE/'diagnostic-printing'

ORIENTATIONS={
    'TMX-A3-P03':('rear_down',pipeline.REAR_DOWN,'accessible_supports'),
    'TMX-A3-P06':('front_down',pipeline.IDENTITY,'accessible_supports'),
    'TMX-A3-P10':('rear_down',pipeline.REAR_DOWN,'accessible_supports'),
}

def main():
    manifest=json.loads((BASE/'verification/diagnostic-mesh-export.json').read_text());results=[]
    for row in manifest['parts']:
        if pipeline.sha(row['file'])!=row['sha256']:raise RuntimeError('STL source SHA differs from native export manifest '+row['part_id'])
    for row in manifest['parts']:
        part=row['part_id'];name,rotation,supports=ORIENTATIONS[part]
        dest=pipeline.PRINT/'oriented-stl'/(part+'_'+name+'.stl')
        orientation=pipeline.orient(row['file'],dest,rotation)
        if orientation['source_sha256']!=row['sha256']:raise RuntimeError('STL changed during orientation '+part)
        mesh=orientation['before'];tri=pipeline.read_stl(row['file'])
        topology_components=pipeline.component_count(tri)
        if topology_components!=1:raise RuntimeError('Changed part is not one connected mesh '+part)
        bbox_error=max(abs(a-b)for ar,br in zip(row['native_bounds_mm'],mesh['bounds_mm'])for a,b in zip(ar,br))
        relative_volume=abs(mesh['signed_volume_mm3']-row['native_volume_mm3'])/row['native_volume_mm3']
        if bbox_error>.02 or relative_volume>.001:raise RuntimeError('Mesh differs excessively from native '+part)
        for material in ('pla','petg'):
            sliced=pipeline.slice_one(dest,material,supports,part+'_systemreview_diagnostic')
            inspection=print_inspect.inspect(sliced['archive']['file'])
            result={'part':part,'material':material,'purpose':'dry-fit diagnostic only' if material=='pla' else 'unqualified target-material diagnostic',
                    'orientation':orientation,'connected_mesh_components':topology_components,
                    'native_to_mesh_max_bound_difference_mm':bbox_error,'native_to_mesh_relative_volume_difference':relative_volume,
                    'slice':sliced,'inspection':inspection}
            results.append(result)
            pipeline.dump(BASE/'verification/diagnostic-slice-review.json',{'status':'selected_visual_QA_pending','results':results,
                'physical_print_jobs_sent':False,'production_print_release':False,
                'limits':'Local mesh/topology/toolpath review only; physical fit, supports removal, insert retention, material and gas sealing remain unqualified.'})
            print(json.dumps({'part':part,'material':material,'layers':inspection['layer_count'],
                'island_candidate_layers':len(inspection['island_candidate_layers']),'warnings':inspection['slicer_warnings'],
                'images':str(Path(sliced['archive']['file']).parent/'inspection/layers.png')}),flush=True)
    return results
if __name__=='__main__':main()
