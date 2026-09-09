#!/usr/bin/env python3
"""Read-only final-routing comparison; does not refill or rewrite board sources."""
from pathlib import Path
import hashlib
import importlib.util
import json
from datetime import datetime, timezone

D = Path(__file__).resolve().parent
R = D.parents[1]
BEFORE = R / 'complete-controls-root-review/current-paths/source.kicad_pcb'
BUNDLE = D.parent / 'frozen-bundle'
AFTER = BUNDLE / 'hardware/pcb/analyzer/Trimix_Analyzer.kicad_pcb'
EXPECTED = ['b305a4c3ce2de15ec42ec1ddef622cf50f9166c37a5fa0958b50593f753eddb2',
            '9f274fdf198f1bcb871a4fc360e76693f8a5b048553e6a02998141737956514f']
READER = R / 'cap-signal-reconnect/pullup-swap/independent-ground/audit_ground.py'

def sha(p):
    return hashlib.sha256(p.read_bytes()).hexdigest()

def main():
    assert [sha(p) for p in [BEFORE, AFTER]] == EXPECTED
    manifest_path = BUNDLE / 'review/geometry-handoff-manifest.json'
    manifest = json.loads(manifest_path.read_text())
    manifest_rows = []
    for item in manifest['files']:
        path = BUNDLE / item['path']
        actual = sha(path)
        assert actual == item['sha256'] and path.stat().st_size == item['bytes'], item['path']
        manifest_rows.append({'path': item['path'], 'sha256': actual, 'passed': True})
    spec = importlib.util.spec_from_file_location('saved_ground_reader', READER)
    g = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(g)
    g.OUT = D
    before, after = [g.load(p) for p in [BEFORE, AFTER]]
    a, b = [g.anchor_witnesses(q) for q in [before, after]]
    layers = {}
    for layer in ['In1.Cu', 'In2.Cu']:
        old = {q['uuid'] for q in a if q['layers'][layer]['contact']}
        new = {q['uuid'] for q in b if q['layers'][layer]['contact']}
        regions = g.components(after, layer)
        layers[layer] = dict(
            before_fill_area_mm2=before['fills'][layer].area,
            after_fill_area_mm2=after['fills'][layer].area,
            removed_fill_mm2=before['fills'][layer].difference(after['fills'][layer]).area,
            added_fill_mm2=after['fills'][layer].difference(before['fills'][layer]).area,
            before_anchor_count=len(old), after_anchor_count=len(new),
            lost_anchor_uuids=sorted(old-new), gained_anchor_uuids=sorted(new-old),
            after_physical_regions=regions)
        assert not old-new, (layer, old-new)
        assert all(q['has_anchor_to_In1'] for q in regions), layer
    assert len(layers['In1.Cu']['after_physical_regions']) == 1
    assert not [t for t in after['native'].tracks if t['layer'] == 'In1.Cu' and t['net'] != 'GND']
    assert g.zone_definitions(before['native']) == g.zone_definitions(after['native'])

    old_inventory = R / 'complete-controls-root-review/current-paths/inventory.json'
    new_inventory = D / 'current-paths/inventory.json'
    ai, bi = [json.loads(p.read_text()) for p in [old_inventory, new_inventory]]
    assert [ai['source_sha256'], bi['source_sha256']] == EXPECTED
    assert len(ai['pairs']) == len(bi['pairs']) == 29
    pair_rows = []
    for x, y in zip(ai['pairs'], bi['pairs']):
        assert (x['source'], x['target']) == (y['source'], y['target'])
        assert y['status'] == 'explicit_native_witness'
        assert x['ordered_item_uuids'] == y['ordered_item_uuids']
        assert len(x['ordered_edges']) == len(y['ordered_edges'])
        changes = []
        for old, new in zip(x['ordered_edges'], y['ordered_edges']):
            delta = {k: [old.get(k), new.get(k)] for k in old.keys() | new.keys()
                     if old.get(k) != new.get(k)}
            if delta:
                assert set(delta) == {'full_item_length_mm'}
                assert new['full_item_length_mm'] <= old['full_item_length_mm']
                changes.append({'uuid': old['uuid'], 'changes': delta})
        pair_rows.append(dict(source=y['source'], target=y['target'],
                              status=y['status'], same_ordered_physical_items=True,
                              full_item_changes=changes,
                              before_full_item_milliohm=x['full_item_estimate_ohm_20C_25um_1p6mm']*1000,
                              after_full_item_milliohm=y['full_item_estimate_ohm_20C_25um_1p6mm']*1000))

    renders = [g.view('final-ground-comparison', [
        (before, 'In1.Cu', 'ROUTED b305 In1', 'anchors'),
        (after, 'In1.Cu', 'FINAL 9f274 In1', 'anchors'),
        (before, 'In2.Cu', 'ROUTED b305 In2', 'anchors'),
        (after, 'In2.Cu', 'FINAL 9f274 In2', 'anchors')],
        (0, 0, 30, 99), 'Actual saved fill and drilled annuli; blue rings identify grounded barrel contacts.', 2400),
        g.view('final-lower-copper', [
            (before, 'F.Cu', 'ROUTED b305 FRONT', 'normal'),
            (after, 'F.Cu', 'FINAL 9f274 FRONT', 'normal'),
            (before, 'B.Cu', 'ROUTED b305 BACK', 'normal'),
            (after, 'B.Cu', 'FINAL 9f274 BACK', 'normal')],
            (0, 60, 30, 99), 'Dead copper cleanup and ordinary C708 via correction; dimensions come from native copper.', 2600)]
    receipt = dict(status='SCOPED_FINAL_POWER_AND_GROUND_PASSED',
        created_utc=datetime.now(timezone.utc).isoformat(),
        before_source_sha256=EXPECTED[0], final_source_sha256=EXPECTED[1],
        script_sha256=sha(Path(__file__)), reader_sha256=sha(READER),
        geometry_manifest_sha256=sha(manifest_path), geometry_manifest_checks=manifest_rows,
        current_inventory_sha256=sha(new_inventory), previous_inventory_sha256=sha(old_inventory),
        power_witnesses=pair_rows, power_witness_count=29,
        power_witnesses_with_trimmed_tail=sum(bool(x['full_item_changes']) for x in pair_rows),
        ground_layers=layers, ground_anchor_witnesses={'before': a, 'final': b},
        zone_definitions_preserved=True, In1_signal_tracks_absent=True,
        renders=renders, visual_review='PENDING', release=False,
        limits=[
            'Saved polygon and annular-contact checks do not measure impedance, thermal performance or EMI.',
            'In1 is one connected reference. In2 consists of grounded separate regions, not a second continuous ground plane.',
            'All 29 native trace/barrel paths remain connected. The sole shortened whole-item witness is a removed unused tail in a voltage-monitor branch.',
            'Complete-item copper resistance sensitivities are not end-to-end equivalent resistance or current ratings.',
            'Native DRC/parity, ERC reviewed exception, assembly CAM/process and final CAD have separate receipts.',
            'Factory fill/cap/stencil processes and all physical qualification remain pending.'])
    assert [sha(p) for p in [BEFORE, AFTER]] == EXPECTED
    (D / 'final-power-ground-review.json').write_text(json.dumps(receipt, indent=2)+'\n')
    print(json.dumps({'manifest_checks':len(manifest_rows), 'power_witnesses':29,
        'trimmed_tail_witnesses':receipt['power_witnesses_with_trimmed_tail'],
        'layers':{L:{k:v for k,v in row.items() if k!='after_physical_regions'} |
                  {'physical_regions':len(row['after_physical_regions'])} for L,row in layers.items()}}, indent=2))

if __name__ == '__main__':
    main()
