#!/usr/bin/env python3
"""Reproduce photo, source, unchanged-board and reference-packet checks.

This is an input-integrity check, not a mechanical or electrical qualification.
Run after rebuilding and visually reviewing the interface packet.
"""
import hashlib
import json
import math
from pathlib import Path

HERE = Path(__file__).resolve().parent
REVIEW = HERE.parent
ROOT = REVIEW.parent.parent


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def main():
    checks = []

    def check(name, passed, detail):
        checks.append({'check': name, 'passed': bool(passed), 'detail': detail})

    reg = json.loads((HERE / 'registration.json').read_text())
    check('Archived owner photograph matches recorded original digest',
          sha(HERE / reg['source']) == reg['sha256'], reg['sha256'])
    matrix = reg['homography_annotation_px_to_local_mm']

    def mapped(point):
        value = [sum(a * b for a, b in zip(row, [*point, 1])) for row in matrix]
        return [value[0] / value[2], value[1] / value[2]]

    residual = max(math.dist(mapped(p), target) for p, target in zip(
        reg['mounting_ear_hole_centres_annotation_px_TL_TR_BR_BL'],
        reg['mounting_ear_hole_centres_local_mm_TL_TR_BR_BL']))
    check('Hole registration reproduces its declared anchors', residual < 1e-9,
          {'maximum_residual_mm': residual, 'scope': 'Numeric reproduction; positions remain reference'})
    span = math.dist(*(mapped(o['annotation_px']) for o in reg['observations'][:2]))
    expected = reg['header_cross_check']['nominal_pitch_mm'] * reg['header_cross_check']['intervals']
    check('Independent header-span arithmetic reproduces record',
          abs(span - reg['header_cross_check']['mapped_span_mm_approx']) < 0.001,
          {'span_mm': span, 'expected_mm': expected,
           'relative_difference_percent': 100 * abs(span / expected - 1)})
    depth = reg['owner_depth_measurement']
    check('Owner bare-header datum retained',
          depth['distance_mm'] == 13.4 and depth['datum'] == 'front glass surface'
          and depth['mated_socket_included'] is False, depth)
    vendor = HERE / 'guition-manufacturer'
    receipt = json.loads((vendor / 'source-receipt.json').read_text())
    check('Manufacturer extracted PDF hashes match retrieval receipt',
          all(sha(vendor / row['path']) == row['sha256'] for row in receipt['files']),
          {'files': len(receipt['files']), 'scope': 'Local hashes; no network retrieval repeated'})
    boards = {
        'hardware/pcb/analyzer/Trimix_Analyzer.kicad_pcb':
            '0962ad86f9834ce71b6439d0f95db603753801153490e78f387a88521e582788',
        'hardware/pcb/usb-input/Trimix_USB_Input.kicad_pcb':
            '63d5742a1f8a2598a80c5d6a962a5551b9bebfa1a59c6780a00ab8ba3dd15ea7',
    }
    check('Both PCB layouts preserved byte-for-byte',
          all(sha(ROOT / path) == digest for path, digest in boards.items()), boards)
    pose = json.loads((HERE / 'current-host-pose.json').read_text())
    check('Current J301 inward pose audit is source-bound',
          all(sha(ROOT / row['path']) == row['sha256'] for row in pose['sources'])
          and all(pose['checks'].values()) and pose['orientation_degrees'] == 180.0,
          {'checks': pose['checks'], 'scope': pose['scope']})
    packet = json.loads((REVIEW / 'interface-packet.json').read_text())
    check('Interface packet source and PDF hashes match',
          all(sha(REVIEW / row['path']) == row['sha256'] for row in packet['sources'])
          and sha(REVIEW / 'interface-packet.pdf') == packet['pdf_sha256'],
          {'source_bindings': len(packet['sources'])})
    check('Six-page packet has recorded visual render inspection',
          packet['pages'] == 6 and 'inspected' in packet['status'], packet['status'])
    result = {
        'status': 'passed digitally' if all(row['passed'] for row in checks) else 'correction required',
        'scope': 'Source and documentation consistency; no physical fit, wiring, charging or gas tests',
        'checks': checks, 'passed': sum(row['passed'] for row in checks),
        'failed': sum(not row['passed'] for row in checks),
        'script_sha256': sha(Path(__file__)),
    }
    (HERE / 'review-input-checks.json').write_text(json.dumps(result, indent=2) + '\n')
    print(json.dumps({'status': result['status'], 'passed': result['passed'], 'failed': result['failed']}))
    raise SystemExit(bool(result['failed']))


if __name__ == '__main__':
    main()
