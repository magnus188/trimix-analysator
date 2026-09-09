"""Read-only final swap audit. Run with KiCad's bundled Python after final save.

Usage: python audit_final_swap.py [FINAL_DRC_JSON]
Does not save a KiCad board, project, schematic, or Fusion document.
"""
from pathlib import Path
import collections, copy, csv, datetime, hashlib, json, math, sys
import pcbnew as p

BASE = Path(__file__).resolve().parent
ROOT = BASE.parents[4]
MARKINGS = BASE.parent / 'markings'
sys.path.insert(0, str(MARKINGS))
import compare_annotations as annotations

BEFORE = BASE / 'before/Trimix_Analyzer.kicad_pcb'
CANDIDATE = BASE / 'Trimix_Analyzer_connector_swap_final_candidate.kicad_pcb'
FINAL = ROOT / 'hardware/pcb/analyzer/Trimix_Analyzer.kicad_pcb'
EXPECTED_BEFORE_SHA = '2b4ae00be776b203d60fb9a4dab12d7d63d141d9a07779e8f759dc58cd2d0d66'
EXPECTED_CANDIDATE_SHA = '4c024973370b55ab001201210de33f2d72766c2aeec4562d373c7f10f113c925'
APPROVED_ORIGINS = {
    'J402': ['4.45', '16.6'],
    'J401': ['4.9', '24.46'],
    'C401': ['1.299999', '23.3', '90'],
    'C402': ['1.299999', '26.51', '90'],
    'R403': ['1.3', '29.759999', '90'],
    'R401': ['8.25', '25.5', '90'],
}
ROTATED = {'C401', 'C402', 'R401'}


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def protected_delta(a, b):
    result = {'footprints': [], 'board_nodes': {}}
    for ref in sorted(set(a['footprints']) | set(b['footprints'])):
        aa, bb = a['footprints'].get(ref), b['footprints'].get(ref)
        if aa != bb:
            result['footprints'].append({'ref': ref, 'before': aa, 'after': bb})
    aa, bb = collections.Counter(a['board_nodes']), collections.Counter(b['board_nodes'])
    result['board_nodes'] = {'removed': list((aa-bb).elements()), 'added': list((bb-aa).elements())}
    result['passed'] = not result['footprints'] and not any(result['board_nodes'].values())
    return result


def expected_tree(before):
    """Apply exactly the approved six poses and four outline endpoint edits in memory.

    KiCad serializes pad and property text angles with the footprint's rotation.
    Their coordinates, other attributes, pad identities and property values stay
    protected. No geometry is inferred from the candidate file.
    """
    tree = copy.deepcopy(before)
    changed_refs = []
    endpoint_edits = []
    for node in tree[1:]:
        if not isinstance(node, list):
            continue
        if node[0] == 'footprint':
            ref = annotations.ref(node)
            if ref not in APPROVED_ORIGINS:
                continue
            changed_refs.append(ref)
            for child in node[2:]:
                if not isinstance(child, list):
                    continue
                if child[0] == 'at':
                    child[:] = ['at'] + APPROVED_ORIGINS[ref]
                elif ref in ROTATED and child[0] in {'pad', 'property'} and child[:2] != ['property', '"Reference"']:
                    at = next(q for q in child if isinstance(q, list) and q[0] == 'at')
                    previous = float(at[3]) if len(at) > 3 else 0
                    assert previous == 0, (ref, child[0], at)
                    at[:] = at[:3] + ['90']
        elif node[0] == 'gr_line' and annotations.layer(node) == '"Edge.Cuts"':
            for child in node:
                if isinstance(child, list) and child[0] in {'start', 'end'} and child[1] == '8.6':
                    assert child[2] in {'0', '17'}, child
                    endpoint_edits.append(copy.deepcopy(child))
                    child[1] = '8.9'
    assert set(changed_refs) == set(APPROVED_ORIGINS)
    assert len(endpoint_edits) == 4
    return tree, endpoint_edits


def bounds(poly):
    bb = poly.BBox()
    return [p.ToMM(bb.GetX()), p.ToMM(bb.GetY()), p.ToMM(bb.GetRight()), p.ToMM(bb.GetBottom())]


def gap(box, x, y, radius):
    return math.hypot(max(box[0]-x, x-box[2], 0), max(box[1]-y, y-box[3], 0))-radius


def netmap(board):
    result = {}
    for f in board.GetFootprints():
        for pad in f.Pads():
            if not pad.GetNumber():
                continue
            key = f.GetReference() + ':' + pad.GetNumber()
            assert key not in result or result[key] == pad.GetNetname()
            result[key] = pad.GetNetname()
    return result


def physical_checks(board):
    outline = p.SHAPE_POLY_SET()
    assert board.GetBoardPolygonOutlines(outline, False)
    outside, copper, courts, collisions = [], [], {}, []
    for f in board.GetFootprints():
        ref = f.GetReference()
        f.BuildCourtyardCaches()
        poly = f.GetCourtyard(p.F_Cu)
        courts[ref] = poly
        if poly.OutlineCount():
            q = poly.CloneDropTriangulation()
            q.BooleanSubtract(outline)
            if q.Area() > 1:
                outside.append({'ref': ref, 'outside_mm2': q.Area()/1e12})
        for pad in f.Pads():
            if not pad.IsOnLayer(p.F_Cu):
                continue
            q = p.SHAPE_POLY_SET()
            pad.TransformShapeToPolygon(q, p.F_Cu, p.FromMM(.5), p.FromMM(.001), p.ERROR_OUTSIDE)
            q.BooleanSubtract(outline)
            if q.Area() > 1:
                copper.append({'ref': ref, 'pin': pad.GetNumber(), 'outside_mm2': q.Area()/1e12})
    refs = sorted(courts)
    for i, ref in enumerate(refs):
        if not courts[ref].OutlineCount():
            continue
        for other in refs[i+1:]:
            if courts[other].OutlineCount() and courts[ref].Collide(courts[other], 0):
                collisions.append([ref, other])
    coax = bounds(courts['J402'])
    return {'courtyards_outside_outline': outside, 'courtyard_overlaps': collisions,
            'pads_below_0_50mm_copper_edge': copper, 'J402_courtyard_mm': coax,
            'J402_H2_R3_driver_gap_mm': gap(coax, 4.4, 6, 3),
            'passed': not outside and not copper and not collisions and gap(coax, 4.4, 6, 3) >= .15}


def label_checks(board, board_sha):
    receipt_path = MARKINGS / 'main-labels.json'
    receipt = json.loads(receipt_path.read_text())
    expected = {q['reference']: q for q in receipt['references']}
    fields, failures, circles, tests = [], [], [], []
    for f in board.GetFootprints():
        for pad in f.Pads():
            if pad.GetAttribute() == p.PAD_ATTRIB_NPTH:
                assert pad.GetDrillSize().x == pad.GetDrillSize().y
                pos = pad.GetPosition()
                circles.append((f.GetReference(), p.ToMM(pos.x), p.ToMM(pos.y), p.ToMM(pad.GetDrillSize().x)/2))
        text = f.Reference()
        side = 'front' if text.GetLayer() == p.F_SilkS else 'back' if text.GetLayer() == p.B_SilkS else 'other'
        box = bounds(text.GetEffectiveTextShape())
        row = {'ref': f.GetReference(), 'side': side, 'visible': text.IsVisible(),
               'font_mm': [p.ToMM(text.GetTextSize().x), p.ToMM(text.GetTextSize().y)],
               'stroke_mm': p.ToMM(text.GetTextThickness()), 'ink_bounds_mm': box}
        fields.append(row)
        if not row['visible'] or text.GetText() != row['ref'] or side == 'other' or row['font_mm'] != [1, 1] or abs(row['stroke_mm']-.15) > 1e-8 or text.IsMirrored() != (side == 'back'):
            failures.append({'ref': row['ref'], 'issue': 'field visibility/string/size/stroke/layer/mirror'})
        expected_row = expected.get(row['ref'])
        if not expected_row or expected_row['side'] != side or max(abs(x-y) for x, y in zip(box, expected_row['ink_bounds_mm'])) > 1e-5:
            failures.append({'ref': row['ref'], 'issue': 'saved field/receipt mismatch'})
    for row in fields:
        for ref, x, y, radius in circles:
            drill_gap = gap(row['ink_bounds_mm'], x, y, radius)
            head_gap = gap(row['ink_bounds_mm'], x, y, 2.5) if ref in {'H1', 'H2'} else None
            tests.append({'reference': row['ref'], 'hole': ref, 'drill_gap_mm': drill_gap, 'head_gap_mm': head_gap})
            if drill_gap < .2-1e-6 or head_gap is not None and head_gap < -1e-6:
                failures.append(tests[-1])
    return {'receipt': str(receipt_path.relative_to(ROOT)), 'receipt_sha256': sha(receipt_path),
            'receipt_matches_saved_board': receipt['after_sha256'] == board_sha,
            'visible_reference_count': sum(r['visible'] for r in fields),
            'side_counts': dict(collections.Counter(r['side'] for r in fields)),
            'failures': failures, 'native_fields': fields, 'NPTH_head_reserve_tests': tests,
            'passed': receipt['after_sha256'] == board_sha and len(fields) == 133 and not failures}


def drc_checks(path):
    old_path = BASE / 'before/main-drc.json'
    old, new = json.loads(old_path.read_text()), json.loads(path.read_text())
    def signatures(rows):
        return collections.Counter(json.dumps({k: v for k, v in row.items() if k != 'items'}, sort_keys=True) + ' ' +
                                   json.dumps(sorted((q['uuid'], q['description']) for q in row.get('items', []))) for row in rows)
    aa, bb = signatures(old['violations']), signatures(new['violations'])
    counts = {k: {'before': len(old[k]), 'after': len(new[k])} for k in ['violations', 'unconnected_items', 'schematic_parity']}
    return {'source': str(path.resolve()), 'sha256': sha(path), 'report_date': new.get('date'), 'counts': counts,
            'violation_types': dict(collections.Counter(q['type'] for q in new['violations'])),
            'added_violation_identities': list((bb-aa).elements()), 'removed_violation_identities': list((aa-bb).elements()),
            'ignored_checks_unchanged': old.get('ignored_checks') == new.get('ignored_checks'),
            'limits': 'Unconnected-item endpoints can change when unrouted footprints move; their count is checked, not treated as routed connectivity.',
            'passed': [len(new[k]) for k in ['violations', 'unconnected_items', 'schematic_parity']] == [39, 288, 0]
                      and aa == bb and old.get('ignored_checks') == new.get('ignored_checks')}


def run(drc_path):
    hashes = {name: sha(path) for name, path in [('before', BEFORE), ('candidate', CANDIDATE), ('final', FINAL)]}
    assert hashes['before'] == EXPECTED_BEFORE_SHA and hashes['candidate'] == EXPECTED_CANDIDATE_SHA, hashes
    before_tree = annotations.parse(BEFORE)
    planned_tree, endpoint_edits = expected_tree(before_tree)
    expected, _ = annotations.protected(planned_tree)
    candidate, _ = annotations.protected(annotations.parse(CANDIDATE))
    actual, _ = annotations.protected(annotations.parse(FINAL))
    candidate_scope = protected_delta(expected, candidate)
    final_scope = protected_delta(expected, actual)
    annotation_delta = annotations.compare(CANDIDATE, FINAL)
    before_board, final_board = p.LoadBoard(str(BEFORE)), p.LoadBoard(str(FINAL))
    before_nets, after_nets = netmap(before_board), netmap(final_board)
    values_before = {f.GetReference(): f.GetValue() for f in before_board.GetFootprints()}
    values_after = {f.GetReference(): f.GetValue() for f in final_board.GetFootprints()}
    guards = json.loads((MARKINGS/'source-guard-before.json').read_text())
    guard_changes = [{'file': str(path), 'before': value, 'after': sha(ROOT/path)} for path, value in guards.items() if sha(ROOT/path) != value]
    report = {'generated_utc': datetime.datetime.now(datetime.timezone.utc).isoformat(), 'board_hashes': hashes,
              'approved_footprint_origins_mm_deg': APPROVED_ORIGINS, 'outline_endpoint_edits_before': endpoint_edits,
              'candidate_independent_scope_check': candidate_scope, 'final_independent_scope_check': final_scope,
              'candidate_to_final_annotation_comparison': annotation_delta,
              'numbered_pin_net_count': len(after_nets), 'all_numbered_pin_nets_unchanged': before_nets == after_nets,
              'all_133_values_unchanged': values_before == values_after and len(values_after) == 133,
              'schematic_project_guard_changes': guard_changes,
              'physical_PCB_checks': physical_checks(final_board), 'labels': label_checks(final_board, hashes['final']),
              'DRC': drc_checks(drc_path),
              'visual_review': 'pending',
              'limits': ['Read-only comparison; no source edits performed.', 'Actual 90-degree coax plug and J401 mating/removal envelopes remain unverified.',
                         'The main PCB remains unrouted, with the existing 39 fabrication checks and 288 unconnected items; this is not fabrication approval.',
                         'Native enclosure/carrier/service checks are separate evidence.']}
    report['technical_status'] = 'passed' if all([candidate_scope['passed'], final_scope['passed'],
        annotation_delta['status'] == 'passed_annotation_only', before_nets == after_nets, len(after_nets) == 365,
        report['all_133_values_unchanged'], not guard_changes, report['physical_PCB_checks']['passed'],
        report['labels']['passed'], report['DRC']['passed']]) else 'needs_review'
    assert sha(FINAL) == hashes['final'], 'Board changed during read-only audit; rerun on final saved version.'
    output = BASE / 'final-independent-audit.json'
    output.write_text(json.dumps(report, indent=2)+'\n')
    print(json.dumps({'technical_status': report['technical_status'], 'board_sha256': hashes['final'],
                      'scope_passed': final_scope['passed'], 'label_counts': report['labels']['side_counts'],
                      'DRC_counts': report['DRC']['counts'], 'guard_changes': guard_changes}, indent=2))


if __name__ == '__main__':
    run(Path(sys.argv[1]) if len(sys.argv) > 1 else MARKINGS/'main-drc.json')
