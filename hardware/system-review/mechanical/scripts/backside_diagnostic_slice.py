#!/usr/bin/env python3
"""Local H2D carrier diagnostic slices; no printer send operation exists here."""
from datetime import datetime, timezone
import json
from pathlib import Path
import sys

BASE = Path(__file__).resolve().parents[1]
ROOT = BASE.parents[2]
sys.path.insert(0, str(ROOT / 'hardware/cad/rev04/3d-print/scripts'))
import print_pipeline as pipeline
import print_inspect

WORK = BASE / 'diagnostic-printing/backside-allocation'
MANIFEST = BASE / 'verification/backside-allocation-mesh.json'
REPORT = BASE / 'verification/backside-allocation-slice-review.json'
pipeline.ROOT = BASE
pipeline.PRINT = WORK


def main():
    row = json.loads(MANIFEST.read_text())
    source = WORK / 'TMX-A3-P03.stl'
    if row['part_id'] != 'TMX-A3-P03' or Path(row['file']).resolve() != source.resolve():
        raise RuntimeError('Expected only the authorized carrier STL')
    if row['units'] != 'mm' or row['scale'] != 1:
        raise RuntimeError('Expected unscaled millimetre mesh')
    if pipeline.sha(source) != row['sha256']:
        raise RuntimeError('Carrier STL SHA differs from native export manifest')
    receipt_hash = pipeline.sha(MANIFEST)
    oriented = WORK / 'oriented-stl/TMX-A3-P03_rear_down.stl'
    orientation = pipeline.orient(source, oriented, pipeline.REAR_DOWN)
    if orientation['source_sha256'] != row['sha256']:
        raise RuntimeError('Carrier STL changed during orientation')
    tri = pipeline.read_stl(source)
    connected = pipeline.component_count(tri)
    before = orientation['before']
    if connected != 1:
        raise RuntimeError('Carrier must contain one edge-connected mesh')
    for label in ('before', 'after'):
        topology = orientation[label]
        if any(topology[k] for k in ('boundary_edges', 'nonmanifold_edges', 'degenerate_triangles')):
            raise RuntimeError('Carrier topology failed: ' + label)
    bounds_error = max(abs(a-b) for ar, br in zip(row['native_bounds_mm'], before['bounds_mm']) for a, b in zip(ar, br))
    native_volume = row['native_volume_mm3']
    if native_volume <= 0:
        raise RuntimeError('Expected positive native carrier volume')
    relative_volume = abs(before['signed_volume_mm3'] - native_volume) / native_volume
    if bounds_error > .02 or relative_volume > .001:
        raise RuntimeError('Carrier mesh exceeds existing native comparison criteria')
    result = {
        'generated_at_utc': datetime.now(timezone.utc).isoformat(),
        'status': 'slicing',
        'part': row['part_id'],
        'native_mesh_manifest': str(MANIFEST),
        'native_mesh_manifest_sha256': receipt_hash,
        'source_sha256': row['sha256'],
        'native_mesh_manifest_status': row.get('status'),
        'source_sha256_verified': True,
        'orientation': orientation,
        'connected_mesh_components': connected,
        'native_to_mesh_max_bound_difference_mm': bounds_error,
        'native_to_mesh_relative_volume_difference': relative_volume,
        'criteria': {'bounds_mm': .02, 'relative_volume': .001, 'connected_mesh_components': 1},
        'tools': {str(p): pipeline.sha(p) for p in (Path(__file__), Path(pipeline.__file__), Path(print_inspect.__file__))},
        'results': [],
        'selected_layer_visual_review': 'pending',
        'physical_print_jobs_sent': False,
        'production_print_release': False,
        'limits': [
            'PLA is a dry-fit diagnostic; PETG is an unqualified target-material diagnostic.',
            'Mesh and all-layer screening do not qualify physical fit, retained wall strength, support removal, insert retention, gas sealing, or thermal performance.',
            'All-layer island screening uses the existing 0.25 mm raster method; selected images are a separate visual check.',
            'Only the changed carrier is sliced. This does not update the earlier production print release or qualify the latest electrical assembly.'
        ]
    }
    pipeline.dump(REPORT, result)
    try:
        for material in ('pla', 'petg'):
            if pipeline.sha(source) != row['sha256'] or pipeline.sha(MANIFEST) != receipt_hash:
                raise RuntimeError('Carrier source or native manifest changed during diagnostic run')
            if pipeline.sha(oriented) != orientation['oriented_sha256']:
                raise RuntimeError('Oriented carrier mesh changed before slicing')
            sliced = pipeline.slice_one(oriented, material, 'accessible_supports', 'TMX-A3-P03_backside_allocation_diagnostic')
            if sliced['archive']['zip_test_error']:
                raise RuntimeError('Sliced archive CRC failed')
            inspection = print_inspect.inspect(sliced['archive']['file'])
            checks = {
                'zero_slicer_warnings': not inspection['slicer_warnings'],
                'zero_raster_island_candidates': not inspection['island_candidate_layers'],
                'all_extruding_moves_parsed': not inspection['unhandled_extruding_moves'],
                'no_support_exclusion_conflicts': not inspection['support_conflicts_with_exclusion_volumes'],
                'declared_layer_count_matches': inspection['layer_count'] == inspection['declared_layer_count'],
            }
            result['results'].append({
                'material': material,
                'purpose': 'dry-fit diagnostic only' if material == 'pla' else 'unqualified target-material diagnostic',
                'slice': sliced,
                'inspection': inspection,
                'digital_checks': checks,
                'digital_checks_pass': all(checks.values()),
            })
            result['status'] = 'selected_visual_QA_pending' if all(r['digital_checks_pass'] for r in result['results']) else 'digital_review_required'
            pipeline.dump(REPORT, result)
            print(json.dumps({'material': material, 'layers': inspection['layer_count'], 'checks': checks,
                              'selected_images': str(Path(sliced['archive']['file']).parent / 'inspection/layers.png')}), flush=True)
        if pipeline.sha(source) != row['sha256'] or pipeline.sha(MANIFEST) != receipt_hash:
            raise RuntimeError('Carrier source or native manifest changed during diagnostic run')
        result['source_unchanged_after_slicing'] = True
        pipeline.dump(REPORT, result)
    except Exception as error:
        result['status'] = 'execution_error'
        result['error'] = str(error)
        pipeline.dump(REPORT, result)
        raise
    return result


if __name__ == '__main__':
    main()
