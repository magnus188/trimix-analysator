"""Independent frozen-source witness comparison and RAW input neck inventory.

Run with the review Python environment (Shapely/sexpdata/CairoSVG).
Only reads native EDA; it does not refill or rerun the owner's DRC.
"""
from pathlib import Path
import sys, json, hashlib
from shapely.geometry import LineString
from shapely.ops import unary_union

D = Path(__file__).resolve().parent
sys.path.insert(0, str(D.parent / 'cap-signal-reconnect/pullup-swap/independent-ground'))
import audit_ground as a
a.OUT = D
sha = lambda p: hashlib.sha256(p.read_bytes()).hexdigest()
expected = ['f1c5f443cbd6cdf92e39e01fc7db374c30721b6e7945b3cdde3387e8cdff7432',
            'de594d8ef4db9489931fe091ba63d938a0d4a33f1bb0455e988433c3fefa95db']
folders = [D / 'before-current-paths', D / 'current-paths']
files = [p / 'source.kicad_pcb' for p in folders]
assert list(map(sha, files)) == expected
inventories = [json.loads((p / 'inventory.json').read_text()) for p in folders]
assert [j['source_sha256'] for j in inventories] == expected
assert all(j['snapshot_sha256_after_run'] == j['source_sha256'] for j in inventories)
assert len(inventories[0]['pairs']) == len(inventories[1]['pairs']) == 29
changed = []
unchanged = 0
for old, new in zip(*(j['pairs'] for j in inventories)):
    keys = ['source', 'target', 'source_pad_uuid', 'target_pad_uuid']
    assert [old[k] for k in keys] == [new[k] for k in keys]
    assert new['status'] == 'explicit_native_witness'
    if old['status'] == 'explicit_native_witness':
        assert old['ordered_item_uuids'] == new['ordered_item_uuids']
        assert old['ordered_edges'] == new['ordered_edges']
        unchanged += 1
    else:
        changed.append({k: new[k] for k in keys})
assert unchanged == 25 and len(changed) == 4

before, after = map(a.load, files)
old_tracks = {t['uuid']: t for t in before['native'].tracks}
new_sys = [t for t in after['native'].tracks if t['uuid'] not in old_tracks and t['net'] == 'VSYS']
assert len(new_sys) == 11
assert all(t['layer'] == 'In2.Cu' and abs(t['width'] - .4) < 1e-8 for t in new_sys)
old_vias = {v['uuid'] for v in before['native'].vias}
new_vias = [v for v in after['native'].vias if v['uuid'] not in old_vias]
assert len(new_vias) == 4 and all(v['net'] != 'VSYS' for v in new_vias)
assert a.zone_definitions(before['native']) == a.zone_definitions(after['native'])

raw = after['native']
pad = next(p for p in raw.pads if p['ref'] == 'U115' and p['pin'] == '5')
neck_ids = ['7613a482-ead5-57bb-b309-ed79e4c52867', '45c3258b-39cc-5c18-a6ff-ef9247c37855']
necks = [next(t for t in raw.tracks if t['uuid'] == u) for u in neck_ids]
assert all(t['layer'] == 'B.Cu' and t['net'] == 'USB_5V' and abs(t['width'] - .15) < 1e-8 for t in necks)
wider = unary_union([pad['geo']] + [t['geo'] for t in raw.tracks if t['layer'] == 'B.Cu' and t['net'] == 'USB_5V' and t['width'] >= .399999])
lines = unary_union([LineString([(14.25, -90), (14.25, -91.45)]), LineString([(14.25, -91.45), (14, -91.7)])])
copper = unary_union([t['geo'] for t in necks])
neck_review = {
    'status': 'existing_local_load_neck_quantified_not_current_rated',
    'width_mm': .15, 'uuids': neck_ids,
    'full_native_centerline_length_mm': lines.length,
    'centerline_length_outside_IN_pad_and_ge_040_B_traces_mm': lines.difference(wider).length,
    'copper_area_outside_IN_pad_and_ge_040_B_traces_mm2': copper.difference(wider).area,
    'IN_pad_bounds_mm': a.bounds(pad['geo']),
    'interpretation': 'Actual local load-carrying escape, not a voltage-sense-only branch. Overlap deductions describe geometry; they do not solve resistance, spreading or temperature.'
}
render = a.view('raw-input-escape', [(after, 'B.Cu', 'U115 RAW INPUT: ACTUAL B.Cu', 'normal')],
                (12.3, 88.7, 15.8, 92.3),
                'Local RAW input escape: nominal 0.15 mm sections join the central IN land. Geometry only; not a current rating.', 1600)
assert list(map(sha, files)) == expected
result = {
    'status': 'scoped_native_connectivity_passed_with_local_width_item_for_final_review',
    'source_sha256': expected[0], 'candidate_sha256': expected[1], 'script_sha256': sha(Path(__file__)),
    'inventory_sha256': [sha(p / 'inventory.json') for p in folders],
    'existing_25_witnesses_unchanged': True, 'newly_connected_pairs': changed,
    'all_29_requested_pairs_connected_without_zones': True,
    'new_SYS_segments': 11, 'new_SYS_width_mm': .4, 'new_SYS_layer': 'In2.Cu', 'new_power_vias': 0,
    'zone_definitions_preserved': True, 'raw_input_neck': neck_review, 'render': render,
    'limits': ['Native witnesses exclude zone conduction, solder, package internals and harnesses.',
               'The 29 requested pairs are not an all-net connectivity or ERC/DRC certificate.',
               'Full-item resistance estimates and sensitivities are in the inventory folders; they are neither equivalent resistance nor thermal/current ratings.',
               'This script does not refresh CAD, source metadata or manufacturing files.',
               'The candidate still has six unconnected items and two expected, unresolved R101 schematic-parity findings.'],
    'release': False
}
(D / 'review.json').write_text(json.dumps(result, indent=2) + '\n')
print(json.dumps({'status': result['status'], 'neck': neck_review}, indent=2))
