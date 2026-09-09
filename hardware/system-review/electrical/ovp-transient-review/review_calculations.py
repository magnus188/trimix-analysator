#!/usr/bin/env python3
"""Source-bound, conditional charge/headroom calculations. Not an IC simulation."""
import argparse
import csv
import hashlib
import itertools
import json
from pathlib import Path
import sexpdata

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[3]
DEFAULT_BOARD = ROOT / 'hardware/system-review/electrical/routing-candidate/permission-links-proposal/host-shared-bridge/r115-local/complete-controls-frozen.kicad_pcb'

def digest(data):
    return hashlib.sha256(data).hexdigest()

def children(node, key):
    return [x for x in node if isinstance(x, list) and x and str(x[0]) == key]

def first(node, key):
    return next(iter(children(node, key)), None)

def main():
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument('--board', type=Path, default=DEFAULT_BOARD)
    p.add_argument('--out', type=Path, default=HERE)
    args = p.parse_args()
    args.out.mkdir(parents=True, exist_ok=True)
    board_bytes = args.board.read_bytes()
    board = sexpdata.loads(board_bytes.decode())
    wanted = {'U115', 'U114', 'U101', 'C114', 'C115', 'C116', 'C101', 'R119', 'R116', 'R126', 'R124', 'R125', 'R121', 'R122', 'R123'}
    inventory = {}
    for fp in children(board, 'footprint'):
        fields = {str(v[1]): str(v[2]) for v in children(fp, 'property')}
        ref = fields.get('Reference')
        if ref not in wanted:
            continue
        inventory[ref] = dict(footprint=str(fp[1]), fields=fields,
                              position=first(fp, 'at')[1:],
                              layer=first(fp, 'layer')[1],
                              physical_pad_nets=[dict(pin=str(v[1]), net=first(v, 'net')[-1] if first(v, 'net') else None)
                                                 for v in children(fp, 'pad')])
    assert wanted <= inventory.keys()
    old_path = ROOT / 'hardware/system-review/electrical/usb-protection-research/upstream-ovp-review.json'
    old_bytes = old_path.read_bytes()
    old = json.loads(old_bytes)
    vtrip = old['preferred_ovlo']['additional_independent_drift_0.001']['rising']['max_V']
    capacitance = old['capacitor_estimates']['out_estimated_min_F']
    # Currents below are NET capacitor charging currents, not U115 guaranteed limits.
    rows = []
    for start, current, time_us in itertools.product((5.0, 5.25, vtrip), (1.0, 2.2, 5.0), (0.1, 0.5, 1.2, 2.0, 5.0)):
        rows.append(dict(start_V=start, assumed_net_capacitor_current_A=current,
                         assumed_duration_us=time_us, assumed_effective_capacitance_uF=capacitance*1e6,
                         conditional_peak_V=start+current*time_us*1e-6/capacitance))
    with (args.out/'conditional-charge-sweep.csv').open('w') as stream:
        writer=csv.DictWriter(stream, fieldnames=list(rows[0])); writer.writeheader(); writer.writerows(rows)
    # This answers the charge budget directly without assuming any controller response.
    headroom = []
    for start, ceiling in itertools.product((5.0, 5.25, vtrip), (5.5, 6.0)):
        headroom.append(dict(start_V=start, ceiling_V=ceiling,
                             available_charge_uC=capacitance*(ceiling-start)*1e6,
                             max_time_at_assumed_2_2A_us=capacitance*(ceiling-start)/2.2*1e6,
                             effective_capacitance_required_at_2_2A_1_2us_uF=2.2*1.2/(ceiling-start)))
    references = {
        ROOT/'hardware/system-review/electrical/usb-protection-research/tps25947-ovp-review-datasheet.pdf': 'https://www.ti.com/lit/ds/symlink/tps25947.pdf',
        ROOT/'hardware/system-review/electrical/usb-protection-research/tps22950-q1-review-datasheet.pdf': 'https://www.ti.com/lit/ds/symlink/tps22950-q1.pdf',
        ROOT/'hardware/system-review/electrical/usb-protection-research/c3216x7r1e475k160ac-ovp.pdf': 'https://product.tdk.com/system/files/dam/doc/product/capacitor/ceramic/mlcc/charasheet/c3216x7r1e475k160ac.pdf',
        ROOT/'hardware/system-review/electrical/usb-protection-research/transient-options/sources/tps1641.pdf': 'https://www.ti.com/lit/ds/symlink/tps1641.pdf',
        ROOT/'hardware/system-review/electrical/sources/bq25895.pdf': 'https://www.ti.com/lit/ds/symlink/bq25895.pdf',
        HERE/'sources/tps25200.pdf': 'https://www.ti.com/lit/ds/symlink/tps25200.pdf',
        HERE/'sources/fpf2286ucx-d.pdf': 'https://www.onsemi.com/download/data-sheet/pdf/fpf2286ucx-d.pdf',
    }
    source_files = [args.board, old_path, ROOT/'main/sensors/usb_input_policy.cpp', ROOT/'main/sensors/power_monitor.cpp', Path(__file__)]
    hashes = [dict(path=str(f.relative_to(ROOT)), sha256=digest(f.read_bytes())) for f in source_files]
    result = dict(status='EL11_OPEN_NOT_A_DEMONSTRATED_FAILURE', date='2026-09-08',
                  method='Closed-form conditional charge balance; no SPICE/IC model or physical test.',
                  source_manifest=hashes,
                  board_source_unchanged_after_read=args.board.read_bytes()==board_bytes,
                  board_inventory=inventory,
                  existing_illustration=dict(start_V=vtrip, net_current_A=2.2, duration_us=1.2,
                                             assumed_effective_capacitance_uF=capacitance*1e6,
                                             conditional_peak_V=vtrip+2.2*1.2e-6/capacitance),
                  headroom=headroom,
                  source_receipts=[dict(path=str(f.relative_to(ROOT)), sha256=digest(f.read_bytes()), url=url) for f,url in references.items()],
                  limitations=['2.2 A is not a guaranteed instantaneous source-current cap.',
                               '1.2 us is a typical-only OVLO response to VOUT beginning to fall, not a guaranteed zero-current interval.',
                               '2.912355 uF combines an estimated DC-bias factor and engineering aging allowance; it is not a guaranteed combined minimum.',
                               'No specified input waveform/impedance, current waveform, switch control model, ESR/ESL, cable/trace inductance or ceramic nonlinear-capacitance integration.',
                               'Starting at the high DC threshold is one conditional state, not the initial voltage of every 5 V input step.',
                               'Additional downstream capacitance through U114 and load current may help but are not credited as unconditional local shunt capacitance.',
                               'Finite capacitor growth improves assumed charge headroom but cannot supply the missing maximum response and surge-current bounds.',
                               'No authoritative EDA, routed source, firmware, component selection or charge permission modified.'])
    assert abs(result['existing_illustration']['conditional_peak_V']-6.396043754860135)<0.002
    assert result['board_source_unchanged_after_read']
    (args.out/'review-calculations.json').write_text(json.dumps(result, indent=2)+'\n')
    print(json.dumps(dict(source_sha256=digest(board_bytes), example=result['existing_illustration'], headroom=headroom,
                          parts={r:inventory[r]['fields'].get('MPN') for r in sorted(wanted)}), indent=2))

if __name__ == '__main__':
    main()
