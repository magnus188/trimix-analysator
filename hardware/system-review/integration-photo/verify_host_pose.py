#!/usr/bin/env python3
"""Read current J301 geometry and compare its logical nets with the prior audit.

Run with KiCad's bundled Python. Does not write a PCB, schematic or BOM.
"""
import hashlib
import json
from pathlib import Path

import pcbnew

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[2]
BOARD = ROOT / 'hardware/pcb/analyzer/Trimix_Analyzer.kicad_pcb'
OLD = HERE.parent / 'electrical/host-harness-review/contract.json'


def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def main():
    before = digest(BOARD)
    old = json.loads(OLD.read_text())
    expected = {str(p['contact']): p['net'] for p in old['pins']}
    board = pcbnew.LoadBoard(str(BOARD))
    header = next(f for f in board.GetFootprints() if f.GetReference() == 'J301')
    pads = []
    for pad in header.Pads():
        net = pad.GetNetname()
        net = 'NC' if net.startswith('unconnected-') else net
        x, y = pcbnew.ToMM(pad.GetPosition().x), pcbnew.ToMM(pad.GetPosition().y)
        pads.append({'pin': int(pad.GetNumber()), 'net': net, 'pcb_xy_mm': [x, y],
                     'fusion_xy_mm_at_W85': [50.4 + x, 120 - y]})
    pads.sort(key=lambda p: p['pin'])
    pin1, pin2 = pads[:2]
    dx = pin2['pcb_xy_mm'][0] - pin1['pcb_xy_mm'][0]
    dy = pin2['pcb_xy_mm'][1] - pin1['pcb_xy_mm'][1]
    checks = {
        'all_26_pins_keep_logical_contract': len(pads) == 26 and all(
            p['net'] == expected[str(p['pin'])] for p in pads),
        'current_standard_exit_is_inward_minus_X': dx < 0 and abs(dy) < 1e-9,
        'main_pin7_remains_electrically_unused': pads[6]['net'] == 'NC',
        'native_board_preserved': before == digest(BOARD),
    }
    result = {
        'status': 'passed digitally' if all(checks.values()) else 'correction required',
        'scope': 'Native main-board pose and logical pin audit; no remote mating, cable or power qualification',
        'sources': [{'path': str(p.relative_to(ROOT)), 'sha256': digest(p)}
                    for p in (BOARD, OLD, Path(__file__))],
        'checks': checks, 'orientation_degrees': header.GetOrientationDegrees(),
        'standard_exit_rule': 'From pin1 toward pin2, from the source Samtec drawing; preserves mating orientation',
        'standard_exit_PCB_vector_mm': [dx, dy],
        'supersedes': 'Only historical native_pose/XY and outward-exit prose in host-harness-review; same-number nets retained',
        'pins': pads,
    }
    (HERE / 'current-host-pose.json').write_text(json.dumps(result, indent=2) + '\n')
    print(json.dumps({'status': result['status'], 'checks': checks}))
    raise SystemExit(not all(checks.values()))


if __name__ == '__main__':
    main()
