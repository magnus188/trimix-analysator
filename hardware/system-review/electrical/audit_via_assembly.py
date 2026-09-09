"""Read-only bore/SMT-aperture guard for the final main routed PCB.

Copper annulus overlap alone is not mistaken for an open bore in solder paste.
The three specifically reviewed VIPPO sites are checked by coordinate, net,
diameter, drill and actual intersected part/pin. Thermal drills implemented as
footprint pads require the separate package/CAM review; this audits routed vias.
"""
from pathlib import Path
import argparse
import hashlib
import json
import math
import sys

HERE = Path(__file__).resolve().parent
sys.path[:0] = [str(HERE / 'main-final-independent'), str(HERE.parents[1] / 'tools')]
from analyzer_sheet import sx, children, child
from cam_geometry import Native, CU, Point, Q

VIPPO = [
    {'xy': [13.6, 89.775], 'size': .40, 'drill': .20, 'net': 'USB_CC_INT_N',
     'pad': ['U115', '3'], 'review': 'vippo-process-review/native-v3-independent/README.md'},
    {'xy': [13.6, 91.0], 'size': .50, 'drill': .25, 'net': 'USB_OVP_UVLO',
     'pad': ['U115', '1'], 'review': 'routing-candidate/uvlo-vippo-process-proposal.json'},
    {'xy': [17.95, 87.925], 'size': .50, 'drill': .25, 'net': 'USB_OVP_UVLO',
     'pad': ['R125', '1'], 'review': 'routing-candidate/uvlo-vippo-process-proposal.json'},
]
EPS = .000002


def audit(board):
    data = board.read_bytes()
    raw = sx.loads(data.decode())
    n = Native(raw)
    setup = child(raw, 'setup')
    fps = {f['ref']: f for f in n.fps}
    results, checks = [], []
    seen = set()
    for v, native in zip(n.vias, children(raw, 'via')):
        xy = [v['xy'][0], -v['xy'][1]]
        spec = next((s for s in VIPPO if math.dist(s['xy'], xy) < EPS), None)
        bore = Point(v['xy']).buffer(v['drill']/2, quad_segs=Q)
        fill = child(native, 'filling') or child(setup, 'filling')
        cap = child(native, 'capping') or child(setup, 'capping')
        filled = fill is not None and str(fill[1]) == 'yes'
        capped = cap is not None and str(cap[1]) == 'yes'
        rows = []
        for pad in n.pads:
            if str(pad['raw'][2]) != 'smd' or not set(pad['layers']) & set(CU):
                continue
            annulus_overlap = v['geo'].intersection(pad['geo']).area
            if annulus_overlap <= 1e-8:
                continue
            fp = fps[pad['ref']]
            side = 'F' if fp['side'] == 'top' else 'B'
            mask = n.aperture(pad, side+'.Mask') if side+'.Mask' in pad['layers'] else None
            paste = n.aperture(pad, side+'.Paste') if side+'.Paste' in pad['layers'] else None
            mask_overlap = 0 if mask is None else bore.intersection(mask).area
            paste_overlap = 0 if paste is None else bore.intersection(paste).area
            dnp = 'dnp' in fp['attributes']
            matched = spec is not None and spec['pad'] == [pad['ref'], pad['pin']]
            geometry = (spec is not None and abs(v['size']-spec['size'])<EPS and
                        abs(v['drill']-spec['drill'])<EPS and v['net']==spec['net'])
            if matched:
                status = 'reviewed VIPPO; factory fill/cap and aperture acceptance remain required'
                passed = geometry and filled and capped and pad['net']==v['net']
            elif paste_overlap > 1e-8 and not dnp:
                status = 'FAIL: unreviewed routed bore intersects populated SMT paste aperture'
                passed = False
            elif dnp:
                status = 'DNP aperture: omit assembly paste or review before any future population'
                passed = pad['net'] == v['net']
            elif pad['ref'] == 'TP1013' and pad['pin'] == '1' and paste is None:
                status = 'intentional open probe via; no component paste aperture'
                passed = pad['net']==v['net'] and math.dist(xy,[10.15,84.0])<EPS
            elif paste_overlap <= 1e-8 and mask_overlap <= 1e-8:
                status = 'annulus joins same-net land; bore lies outside SMT mask/paste aperture'
                passed = pad['net'] == v['net']
            else:
                status = 'FAIL: open bore intersects an unreviewed exposed SMT aperture'
                passed = False
            rows.append({'part': pad['ref'], 'pin': pad['pin'], 'side': side, 'DNP': dnp,
                         'annulus_to_pad_overlap_mm2': annulus_overlap,
                         'bore_to_pad_gap_mm': bore.distance(pad['geo']),
                         'bore_in_mask_mm2': mask_overlap, 'bore_in_paste_mm2': paste_overlap,
                         'status': status, 'passed': bool(passed)})
        if spec:
            seen.add(tuple(spec['xy']))
            checks.append({'check': 'exact VIPPO '+str(spec['xy']),
                           'passed': bool(rows) and all(r['passed'] for r in rows) and
                                     any([r['part'],r['pin']]==spec['pad'] for r in rows),
                           'source_review': spec['review']})
        if rows:
            results.append({'via_uuid': child(native, 'uuid')[1], 'xy_mm': xy,
                            'net': v['net'], 'diameter_mm': v['size'], 'drill_mm': v['drill'],
                            'filled': filled, 'capped': capped, 'SMT_overlaps': rows})
    checks.append({'check': 'all three explicitly reviewed VIPPO sites exist',
                   'passed': seen == {tuple(s['xy']) for s in VIPPO},
                   'seen': sorted(seen)})
    checks.append({'check': 'all routed bore/SMT aperture encounters have a reviewed disposition',
                   'passed': all(r['passed'] for v in results for r in v['SMT_overlaps'])})
    return {'board': str(board.resolve()), 'board_sha256': hashlib.sha256(data).hexdigest(),
            'routed_vias_checked': len(n.vias), 'checks': checks,
            'all_checks_pass': all(c['passed'] for c in checks), 'encounters': results,
            'limitations': ['Uses exact native pad shapes, not exported mask/drill bytes; final CAM comparison is separately mandatory.',
                           'Drill tools, tolerances, plating, resin filling, copper capping and assembler flatness acceptance require the factory quote.',
                           'Thermal drills modeled as package pads are outside this routed-via check.',
                           'No electrical current, thermal, transient, fit or production-release claim.'],
            'order_release': False}


if __name__ == '__main__':
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument('--board', type=Path, required=True)
    ap.add_argument('--output', type=Path, required=True)
    args = ap.parse_args()
    result = audit(args.board)
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(json.dumps(result, indent=2)+'\n')
    print(json.dumps({'routed_vias_checked': result['routed_vias_checked'],
                      'all_checks_pass': result['all_checks_pass'],
                      'checks': result['checks']}, indent=2))
