"""Read the existing KiCad preview; write only an offline A3 packaging assessment.

Run with KiCad's bundled Python (pcbnew). Never saves or edits a KiCad board.
Courtyard area is an occupancy indicator, not a routing or thermal qualification.
"""
from collections import Counter, defaultdict
from datetime import datetime, timezone
from pathlib import Path
import csv
import hashlib
import json
import pcbnew as pcb

BASE = Path(__file__).resolve().parents[1]
HW = BASE.parents[1]
BOARD = HW / 'kicad/analyzer/preview/Trimix_Analyzer_Preview.kicad_pcb'
MANIFEST = HW / 'verification/analyzer/preview/manifest.json'
BOM = HW / 'verification/analyzer/pcb-bom.csv'


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def pack_rectangles(parts, width, height, edge=1.0, gap=0.5, keepouts=()):
    """Deterministic MaxRects trial with rotations, no net/functional optimization.

    Axis-aligned bounding rectangles conservatively enclose real courtyards.
    Half-gap padding enforces an additional gap between adjacent courtyards.
    Fixed keepout rectangles use lower-left x/y and width/height in PCB mm.
    """
    free = [[edge, edge, width-2*edge, height-2*edge]]
    placed = []

    def overlap(a, b):
        return min(a[0]+a[2], b[0]+b[2]) > max(a[0], b[0])+1e-8 and min(a[1]+a[3], b[1]+b[3]) > max(a[1], b[1])+1e-8

    def occupy(rect):
        nonlocal free
        split = []
        for f in free:
            if not overlap(f, rect):
                split.append(f); continue
            x, y, w, h = f; a, b, c, d = rect
            if a > x: split.append([x, y, a-x, h])
            if a+c < x+w: split.append([a+c, y, x+w-a-c, h])
            if b > y: split.append([x, y, w, b-y])
            if b+d < y+h: split.append([x, b+d, w, y+h-b-d])
        free = [f for i, f in enumerate(split) if f[2] > 1e-8 and f[3] > 1e-8 and not any(
            j != i and o[0] <= f[0]+1e-8 and o[1] <= f[1]+1e-8 and o[0]+o[2] >= f[0]+f[2]-1e-8 and o[1]+o[3] >= f[1]+f[3]-1e-8 and (o != f or j < i)
            for j, o in enumerate(split))]

    for k in keepouts: occupy(k)
    ordered = sorted(parts, key=lambda p: (max(p['courtyard_bbox_size_mm']), p['courtyard_bbox_area_mm2']), reverse=True)
    failed = []
    for p in ordered:
        w, h = p['courtyard_bbox_size_mm']; candidates = []
        for turn, (a, b) in enumerate(((w+gap, h+gap), (h+gap, w+gap))):
            for f in free:
                if a <= f[2]+1e-8 and b <= f[3]+1e-8:
                    candidates.append(((min(f[2]-a, f[3]-b), max(f[2]-a, f[3]-b)), [f[0], f[1], a, b], turn))
        if not candidates:
            failed.append(p['reference']); continue
        _, rect, turn = min(candidates)
        occupy(rect)
        placed.append({'reference': p['reference'], 'padded_box_mm': rect, 'turn_90_degrees_from_existing_bbox': bool(turn)})
    # Independent numerical validation prevents a heuristic bug becoming fit evidence.
    errors = []
    for i, p in enumerate(placed):
        a = p['padded_box_mm']
        if a[0] < edge-1e-8 or a[1] < edge-1e-8 or a[0]+a[2] > width-edge+1e-8 or a[1]+a[3] > height-edge+1e-8:
            errors.append([p['reference'], 'boundary'])
        for k in keepouts:
            if overlap(a, k): errors.append([p['reference'], 'keepout'])
        for other in placed[:i]:
            if overlap(a, other['padded_box_mm']): errors.append([p['reference'], other['reference']])
    if errors: raise AssertionError(errors)
    return {'status': 'rectangle_trial_fits' if not failed else 'rectangle_trial_incomplete',
            'board_mm': [width, height], 'edge_allowance_mm': edge, 'additional_courtyard_gap_mm': gap,
            'keepout_rectangles_mm': list(keepouts), 'placed_count': len(placed), 'unplaced_references': failed,
            'placement': placed, 'numerical_overlap_boundary_check': 'pass',
            'limits': 'Artificial same-side packing only; no nets, signal/power grouping, copper, traces, thermal land, connector access or actual 3D keepouts were solved.'}


def assess():
    before = sha(BOARD)
    manifest = json.loads(MANIFEST.read_text())
    bom = {r['reference']: r for r in csv.DictReader(BOM.open())}
    board = pcb.LoadBoard(str(BOARD))
    parts = []; keepouts = []
    for footprint in board.GetFootprints():
        ref = footprint.GetReference(); source = manifest['components'][ref]
        courtyard = footprint.GetCourtyard(pcb.F_CrtYd)
        if not courtyard.OutlineCount():
            raise RuntimeError('Missing front courtyard: '+ref)
        box = courtyard.BBox()
        w, h = pcb.ToMM(box.GetWidth()), pcb.ToMM(box.GetHeight())
        parts.append({'reference': ref, 'value': footprint.GetValue(),
                      'footprint': str(footprint.GetFPID().GetLibNickname())+':'+str(footprint.GetFPID().GetLibItemName()),
                      'fit': not footprint.IsDNP(), 'bom_fit': bom[ref]['dnp'] == 'FIT',
                      'sheet': source['sheet'], 'placeholder_footprint': source['placeholder_footprint'],
                      'approximate_3d_model': source['approximate_model'],
                      'courtyard_area_mm2': round(courtyard.Area()/1e12, 6),
                      'courtyard_bbox_size_mm': [round(w, 6), round(h, 6)],
                      'courtyard_bbox_area_mm2': round(w*h, 6),
                      'pad_count_including_thermal_subpads': len(list(footprint.Pads())),
                      'through_hole_pads': footprint.HasThroughHolePads()})
        for zone in footprint.Zones():
            if zone.GetIsRuleArea(): keepouts.append({'reference': ref, 'area_mm2': zone.Outline().Area()/1e12})
    for zone in board.Zones():
        if zone.GetIsRuleArea(): keepouts.append({'reference': 'BOARD', 'area_mm2': zone.Outline().Area()/1e12})
    if any(p['fit'] != p['bom_fit'] for p in parts): raise AssertionError('PCB/BOM DNP mismatch')
    fit = [p for p in parts if p['fit']]
    groups = defaultdict(lambda: {'count': 0, 'courtyard_area_mm2': 0, 'bbox_area_mm2': 0})
    for p in fit:
        s = groups[p['sheet']]; s['count'] += 1
        s['courtyard_area_mm2'] += p['courtyard_area_mm2']; s['bbox_area_mm2'] += p['courtyard_bbox_area_mm2']
    area = sum(p['courtyard_area_mm2'] for p in fit)
    rectangles = sum(p['courtyard_bbox_area_mm2'] for p in fit)
    trials = []
    for width, height, label in ((30, 99, 'Current A3 datum-derived strip'), (31, 100, '31 mm comparison'), (34, 100, '34 mm comparison')):
        trials.append({'label': label, 'gross_area_mm2': width*height,
                       'fit_courtyard_occupancy_percent': 100*area/(width*height),
                       'fit_bbox_occupancy_percent': 100*rectangles/(width*height),
                       'all_119_rectangles_trial': pack_rectangles(parts, width, height)})
    # Supplied current A3 design datums, still subject to native-CAD/part validation.
    # Each R3.6 mount reservation uses its conservative 7.2 mm square envelope.
    stress = pack_rectangles(parts, 30, 99, keepouts=((8.6, 82, 21.4, 17), (22, 3.4, 7.2, 7.2), (0.8, 89.4, 7.2, 7.2), (0, 0, 5.8, 4.2)))
    unchanged = sha(BOARD) == before
    if not unchanged: raise AssertionError('Source KiCad board changed')
    report = {'generated_at_utc': datetime.now(timezone.utc).isoformat(),
              'status': 'offline_area_and_rectangle_assessment_only', 'source_board': str(BOARD),
              'source_board_sha256': before, 'source_manifest_sha256': sha(MANIFEST), 'source_bom_sha256': sha(BOM),
              'kicad_version': pcb.GetBuildVersion(), 'footprints': len(parts), 'fit': len(fit),
              'dnp_references': sorted(p['reference'] for p in parts if not p['fit']),
              'tracks': len(board.GetTracks()), 'zones': len(list(board.Zones())),
              'existing_encoded_rule_area_keepouts': keepouts,
              'all_front_courtyards_present': True, 'fit_courtyard_area_mm2': area,
              'fit_courtyard_bbox_area_mm2': rectangles,
              'placeholder_footprint_references': sorted(p['reference'] for p in parts if p['placeholder_footprint']),
              'offboard_excluded': manifest['offboard_excluded'],
              'functional_groups': dict(groups), 'strip_comparisons': trials,
              'a3_notch_and_two_mount_keepout_trial': stress,
              'keepout_geometry_basis': 'Current A3 builder datums at W85: PCB X50.4..80.4,Y21..120,Z20.5..22.1; upper notch X59..80.4,Y103..120; lower USB-service notch X50.4..56.2,Y21..25.2; mount centres (76,28),(54.8,114), reserved radius3.6. 7.2x7.2 square envelopes conservatively enclose those circles. Actual PCB hole radii1.15 are smaller. Native CAD and purchased-part tolerance checks remain separate.',
              'largest_courtyards': sorted(fit, key=lambda p:p['courtyard_bbox_area_mm2'], reverse=True)[:15],
              'components': sorted(parts, key=lambda p:p['reference']), 'source_board_unchanged': unchanged,
              'routing_verified': False,
              'conclusion': 'Bare footprint area does not rule out the strip. Artificial packing results are conditional evidence only. A final outline/notch, connector choices, 3D button/harness keepouts, electrical placement, power/thermal layout and routed DRC remain required.',
              'limits': ['No KiCad source was edited or saved.', 'Current preview is 186x150 mm and has zero tracks/zones; it is an educational arrangement.',
                         '115 FIT parts consume physical assembly space, but all 119 footprints including DNP still need copper pads and were included in rectangle trials.',
                         'Courtyards are library nominal data; placeholder connector packages and approximate models are not validated purchased parts.',
                         'No encoded keepout does not mean no real keepout. PCB mounting holes, button intrusion, connector mating, cable bends, RF/thermal and switching-loop constraints are not encoded in this preview.',
                         'A3 at CaseWidth=85 gives only 30x99 mm from the supplied carrier datums, before an upper button notch.']}
    out = BASE/'verification/pcb-strip-assessment.json'; out.parent.mkdir(parents=True, exist_ok=True)
    out.write_text(json.dumps(report, indent=2)+'\n')
    with (BASE/'verification/pcb-footprint-clearances.csv').open('w', newline='') as stream:
        fields = ['reference','value','footprint','fit','sheet','placeholder_footprint','courtyard_area_mm2','courtyard_bbox_size_mm','courtyard_bbox_area_mm2','through_hole_pads']
        writer = csv.DictWriter(stream, fields, extrasaction='ignore'); writer.writeheader(); writer.writerows(report['components'])
    print(json.dumps({k:report[k] for k in ('footprints','fit','fit_courtyard_area_mm2','fit_courtyard_bbox_area_mm2','placeholder_footprint_references','source_board_unchanged')}, indent=2))
    print(json.dumps({'rectangle_trials':[(t['label'],t['all_119_rectangles_trial']['status']) for t in trials], 'a3_notch_and_mount_trial':stress['status']}))
    return report


if __name__ == '__main__': assess()
