#!/usr/bin/env python3
"""Read native evidence and reproduce dimensional/DC scenarios. No native edits.

Run with KiCad MCP venv Python (sexpdata). This is closed-form arithmetic,
not an electrical/thermal qualification or a SPICE simulation.
"""
import csv
import hashlib
import json
import math
from pathlib import Path
import xml.etree.ElementTree as ET
import sexpdata

OUT = Path(__file__).resolve().parent
ROOT = OUT.parents[3]
NET = ROOT / 'hardware/system-review/electrical/analyzer-netlist.xml'
PCB = ROOT / 'hardware/pcb/analyzer/Trimix_Analyzer.kicad_pcb'
def sha(p):
    return hashlib.sha256(p.read_bytes()).hexdigest()
def children(n, key):
    return [v for v in n if isinstance(v, list) and v and str(v[0]) == key]
def one(n, key):
    return children(n, key)[0]

xml = ET.parse(NET).getroot()
nets = {int(node.get('pin')): net.get('name') for net in xml.find('nets')
        for node in net if node.get('ref') == 'J301'}
assert set(nets) == set(range(1, 27))
assert nets[7].startswith('unconnected-')
assert [nets[n] for n in [1, 3, 18]] == ['HOST_3V3'] * 3
assert [nets[n] for n in [2, 4]] == ['HOST_5V'] * 2
assert [nets[n] for n in [5, 6, 16]] == ['GND'] * 3
tree = sexpdata.loads(PCB.read_text())
fp = next(v for v in children(tree, 'footprint')
          if any(p[1:3] == ['Reference', 'J301'] for p in children(v, 'property')))
pose = one(fp, 'at')[1:]
assert len(pose) < 3 or pose[2] == 0, 'Recompute cable-exit direction after rotation'
pads = {int(p[1]): p for p in children(fp, 'pad')}
assert len(pads) == 26
gpio = {7:52,8:33,9:51,10:31,11:50,12:30,13:49,14:29,17:34,19:32,21:28}
pin_rows = []
for pin in range(1, 27):
    net = nets[pin]
    pad = pads[pin]
    xy = one(pad, 'at')[1:3]
    nc = net.startswith('unconnected-')
    pin_rows.append(dict(contact=pin, ribbon_conductor=pin,
        remote_JP1_logical_pin=pin, net='NC' if nc else net,
        host_gpio_reference=gpio.get(pin,''),
        use='polarization candidate; electrically unused' if pin == 7 else ('unused' if nc else 'connected'),
        pcb_x_mm=pose[0]+xy[0], pcb_y_mm=pose[1]+xy[1],
        remote_mating_status='physical JP1 connector and termination unverified'))
with (OUT/'pin-map.csv').open('w', newline='') as f:
    w=csv.DictWriter(f,fieldnames=list(pin_rows[0]));w.writeheader();w.writerows(pin_rows)

inch=25.4
dim = dict(
    socket_length_nominal_mm=(13*.100+.059)*inch,
    socket_length_min_mm=(13*.100+.059-.005)*inch,
    socket_length_max_mm=(13*.100+.059+.015)*inch,
    socket_height_nominal_mm=.365*inch,
    socket_height_min_mm=(.365-.005)*inch,
    socket_height_max_mm=(.365+.010)*inch,
    socket_width_catalog_nominal_mm=.200*inch,
    socket_width_guaranteed_max_mm=None,
    socket_max_bow_ratio=.006,
    socket_max_bow_over_max_length_mm=.006*(13*.100+.059+.015)*inch,
    socket_allowed_insertion_min_mm=.220*inch,
    socket_allowed_insertion_max_mm=.245*inch,
    socket_allowed_square_post_min_mm=.022*inch,
    socket_allowed_square_post_max_mm=.028*inch,
    htsw_exposed_post_nominal_mm=.230*inch,
    htsw_exposed_post_min_mm=(.230-.008)*inch,
    htsw_exposed_post_max_mm=(.230+.008)*inch,
    htsw_insulator_height_ref_mm=.100*inch,
    htsw_insulator_height_guaranteed_max_mm=None,
    htsw_body_length_nominal_mm=13*.100*inch,
    htsw_body_length_min_mm=(13*.100-.015)*inch,
    htsw_body_length_max_mm=(13*.100+.005)*inch,
    htsw_body_width_ref_mm=.198*inch,
    htsw_tail_length_ref_mm=.100*inch,
    mated_height_nominal_mm=(.100+.365)*inch,
    mated_height_using_socket_max_and_header_nominal_mm=(.100+.375)*inch,
    guaranteed_mated_height_max_mm=None,
    overall_cable_assembly_length_nominal_mm=4*inch,
    overall_cable_assembly_length_min_mm=(4-.125)*inch,
    overall_cable_assembly_length_max_mm=(4+.125)*inch,
    free_wire_length_guaranteed_mm=None,
    proposed_engineering_clearance_LWH_mm=[35.0,5.5,12.5],
    engineering_clearance_is_manufacturer_max=False,
    initial_service_axial_withdrawal_allowance_mm=6.1,
    required_cable_bend_radius_mm=None,
    harwin_exposed_post_min_mm=6.10-.25,
    harwin_exposed_post_max_mm=6.10+.25,
    harwin_socket_max_insertion_excess_mm=(6.10+.25)-.245*inch)
assert dim['htsw_exposed_post_min_mm'] >= dim['socket_allowed_insertion_min_mm']
assert dim['htsw_exposed_post_max_mm'] <= dim['socket_allowed_insertion_max_mm']

# Belden 9L28026 nominal DCR: reference material, NOT exact Samtec lot identity.
dcr=68.2/304.8
alpha=.00393 # engineering copper-temperature approximation, not a cable guarantee
scenarios=[]
for length in [101.6,104.775]:
    for temp in [20,60,85]:
        wire=dcr*length/1000*(1+alpha*(temp-20))
        for contact_per_end in [0,.020]:
            branch=wire+2*contact_per_end
            for current in [.5,1,1.5,2]:
                loop=branch*(1/2+1/3)
                scenarios.append(dict(length_mm=length,temperature_C=temp,
                    hypothetical_contact_resistance_per_end_ohm=contact_per_end,
                    current_5V_A=current,current_each_supply_A=current/2,
                    current_each_ground_A=current/3,
                    wire_resistance_ohm=wire,loop_resistance_ohm=loop,
                    loop_drop_mV=1000*current*loop,
                    loop_heating_W=current*current*loop,
                    evidence_class='conditional arithmetic; not guaranteed bound'))
with (OUT/'drop-scenarios.csv').open('w',newline='') as f:
    w=csv.DictWriter(f,fieldnames=list(scenarios[0]));w.writeheader();w.writerows(scenarios)

pullups={'R107':10000,'R111':33000,'R112':10000,'R115':10000,'R120':10000,
         'R301':10000,'R302':4700,'R303':4700,'R802':10000,'R803':100000}
pullup_mA=3.3*sum(1/r for r in pullups.values())*1000
divider_mA=3.3/20000*1000
current_notes=dict(
    reference_wire='Belden 9L28026: nominal 68.2 ohm/1000ft; 1 A/conductor at20C recommendation',
    actual_samtec_wire_supplier_and_DCR_max=None,
    reference_20C_dcr_ohm_per_m=dcr,
    copper_temperature_coefficient_assumption_per_C=alpha,
    actual_hot_enclosure_ampacity_A=None,
    actual_complete_harness_contact_resistance_max_ohm=None,
    branch_sharing='Equal-path DC model only; one missing supply wire forces the other to carry the full load.',
    example_2A_supply_max_branch_current_at_plus_minus_10percent_R_A=2*1.1/(.9+1.1),
    combined_ground_current_with_only_5V_and_3V3_exchange='signed Ig = I5 - I3',
    conservative_ground_current_bound_A='abs(Ig) <= abs(I5)+abs(I3), before external paths are characterized',
    guaranteed_whole_harness_voltage_drop_mV=None)

contract=dict(
    schema=1, status='PENDING PHYSICAL AND PROCUREMENT QUALIFICATION',
    scope='read-only native J301 audit; mathematical scenarios and source review only',
    native_modified=False,
    source_snapshot={str(p.relative_to(ROOT)):sha(p) for p in [NET,PCB,
        ROOT/'hardware/system-review/electrical/host-interface.csv',
        ROOT/'hardware/system-review/electrical/interface-contract.md']},
    recommended_header='HTSW-113-07-L-D',
    recommended_cable='IDSD-13-S-04.00-G',
    preferred_polarized_candidate=dict(header='HTSW-113-07-L-D-007',
        cable='IDSD-13-S-04.00-G-P07',
        exact_configured_part_orderability_confirmed=False,
        source='HTSW RevBQ p1 Option2, IDSX RevAE p2 Fig3',
        fallback='Standard IDSD plus manufacturer PK-06 inserted in cavity7; factory-omitted header still required unless Samtec supplies an approved modification procedure.',
        manual_header_pin_removal_approved=False,
        prevents_correct_grid_180_degree_full_seating=True,
        prevents_all_shifted_or_partial_engagement=False),
    rejected_original_pair=dict(header='M20-9981346', cable='IDSD-13-S-04.00-G',
        reasons=['Tin/gold contact pair','Worst permitted fully seated Harwin post exceeds socket insertion maximum by0.127mm']),
    geometry_mm=dim,
    native_pose=dict(origin_xy_mm=pose[:2],angle_deg=0,
        long_axis='+KiCadY',standard_ribbon_exit='+KiCadX toward even row',
        socket_mating_view='mirrored relative to PCB top view',
        footnote='Actual remote harness must preserve logical pinN to JP1pinN; pin1 stripe verified by continuity.'),
    pins=pin_rows,
    current_and_drop=current_notes,
    host_3v3_partial_budget=dict(voltage_for_math_V=3.3,
        pullup_nominal_all_low_mA=pullup_mA,
        oxygen_bias_divider_nominal_mA=divider_mA,
        combined_external_resistor_nominal_mA=pullup_mA+divider_mA,
        resistor_table=pullups,
        known_ADC_typical_normal_plus_idle_digital_mA=(360+250+65*2)/1000,
        TUSB_UFP_datasheet_typical_mA=.070,
        TUSB_test_condition='4.5V GPIO mode; not bound for actual3.3V I2C configuration',
        PI3USB9201_active_typical_mA=.200,
        TUSB_active_max_mA=None,PI3USB_active_max_mA=None,
        remote_BME_board_max_mA=None,
        guaranteed_combined_current_max_mA=None,
        Guition_3v3_spare_current_guarantee_mA=None,
        conclusion='Cannot close maximum HOST3V3 load budget from these typical-only tables and unmeasured display/BME assemblies. Measure actual startup and operating demand and rail minima.'),
    checked_native_net_assertions=7,
    source_urls=json.loads((OUT/'source-urls.json').read_text()))
(OUT/'contract.json').write_text(json.dumps(contract,indent=2)+'\n')
manifest={p.name:sha(p) for p in sorted(OUT.iterdir()) if p.is_file() and p.name!='manifest.json'}
(OUT/'manifest.json').write_text(json.dumps(manifest,indent=2)+'\n')
print(json.dumps(dict(native_sources=contract['source_snapshot'],
    dimensions=dim, external_resistor_current_mA=pullup_mA+divider_mA,
    scenarios=len(scenarios), evidence_sha=sha(OUT/'contract.json')),indent=2))
