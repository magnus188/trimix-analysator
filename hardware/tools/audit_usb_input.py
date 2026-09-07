"""Verify the A2.2 GCT USB daughterboard and existing main PCB.

Run after fresh KiCad CLI netlist/ERC exports and integrate_analyzer.py audit.
Physical source/cable/charging tests are deliberately recorded as not performed.
"""
import hashlib
import json
import xml.etree.ElementTree as ET
import zipfile
from analyzer_sheet import P, VERIFY, PROJECT


def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def pin_map(root, refs=None):
    pins, groups = {}, {}
    for net in root.findall('./nets/net'):
        group = {(n.attrib['ref'], n.attrib['pin']) for n in net.findall('node')
                 if refs is None or n.attrib['ref'] in refs}
        for pin in group:
            assert pin not in pins, ('Duplicate net assignment', pin)
            pins[pin] = net.attrib['name']
            groups[pin] = group
    return pins, groups


def main():
    hashes = {p.name: digest(p) for p in P.glob('*.kicad_sch')}
    audit = json.loads((VERIFY/'connectivity-audit.json').read_text())
    assert audit['result'] == 'PASS' and audit['source_hashes'] == hashes
    netlist = VERIFY/(PROJECT+'-netlist.xml')
    root = ET.parse(netlist).getroot()
    comps = {c.attrib['ref']: c for c in root.findall('./components/comp')}
    offboard = {r for r, c in comps.items() if any(
        p.attrib['name'] == 'exclude_from_board' for p in c.findall('property'))}
    assert offboard == {'J901', 'J902', 'R901', 'R902', 'U601', 'U704'}
    board_refs = set(comps)-offboard
    pins, groups = pin_map(root)
    for contact, resistor, net in [('A5', 'R901', 'USB_CC1'), ('B5', 'R902', 'USB_CC2')]:
        assert pins['J901', contact] == net
        assert groups['J901', contact] == {('J901', contact), (resistor, '1')}
        assert pins[resistor, '2'] == 'GND'
        assert comps[resistor].findtext('value') == '5.1k / 1%'
    for contact in ['A4', 'A9', 'B4', 'B9']:
        assert pins['J901', contact] == pins['J902', '1'] == pins['J101', '1'] == 'USB_5V'
    for contact in ['A1', 'A12', 'B1', 'B12', 'SH']:
        assert pins['J901', contact] == pins['J902', '2'] == pins['J101', '2'] == 'GND'
    for contact in ['A6', 'A7', 'A8', 'B6', 'B7', 'B8']:
        assert groups['J901', contact] == {('J901', contact)}
    assert comps['J901'].findtext('value') == 'GCT USB4720-03-A'
    daughter_refs = {'J901', 'J902', 'R901', 'R902'}
    daughter = ET.parse(VERIFY/'USB_Daughterboard-netlist.xml').getroot()
    assert {c.attrib['ref'] for c in daughter.findall('./components/comp')} == daughter_refs
    assert pin_map(daughter)[0] == pin_map(root, daughter_refs)[0]
    erc = json.loads((VERIFY/'USB_Daughterboard-erc.json').read_text())
    assert not [v for s in erc['sheets'] for v in s.get('violations', [])]
    for number in ['2', '3', '24']:
        assert groups['U101', number] == {('U101', number)}
    assert comps['R103'].findtext('value') == '620R 1%'
    baseline = VERIFY/'before-usb-compatibility-20260906.zip'
    with zipfile.ZipFile(baseline) as z:
        old = ET.fromstring(z.read('verification/analyzer/Trimix_Analyzer-netlist.xml'))
    expected, _ = pin_map(root, board_refs)
    previous, _ = pin_map(old, board_refs)
    assert expected == previous, 'Existing main-board net assignments changed'

    import pcbnew as pcb
    board_path = P/'preview/Trimix_Analyzer_Preview.kicad_pcb'
    board_hash = digest(board_path)
    board = pcb.LoadBoard(str(board_path))
    footprints = {f.GetReference(): f for f in board.GetFootprints()}
    assert set(footprints) == board_refs
    actual, positions = {}, {}
    for ref, fp in footprints.items():
        positions[ref] = [pcb.ToMM(fp.GetPosition().x), pcb.ToMM(fp.GetPosition().y), fp.GetOrientationDegrees()]
        for pad in fp.Pads():
            if pad.GetNumber():
                key = (ref, pad.GetNumber())
                assert key not in actual or actual[key] == pad.GetNetname()
                actual[key] = pad.GetNetname()
    assert actual == expected, 'Saved PCB pad nets differ from the current CLI netlist'
    assert digest(board_path) == board_hash
    assert {p.name: digest(p) for p in P.glob('*.kicad_sch')} == hashes

    checks = {
        'separate_cc_nets_with_one_5k1_1percent_rd_each': True,
        'cc_resistors_return_to_unswitched_ground': True,
        'all_four_vbus_and_all_four_ground_contacts_connected': True,
        'standalone_usb_board_matches_integrated_page': True,
        'standalone_usb_board_erc_zero_violations': True,
        'two_wire_main_board_harness_preserved': True,
        'charger_data_and_detection_select_pins_separately_nc': True,
        'main_board_pin_nets_unchanged_from_a2': True,
        'saved_pcb_pad_nets_match_current_cli_netlist': True,
        'board_file_not_modified': True,
    }
    report = {
        'schematic_result': 'PASS', 'revision': 'A2.2',
        'checks': checks, 'pcb_components': len(footprints), 'pcb_pins_checked': len(actual),
        'erc_errors': audit['erc_errors'], 'erc_warnings': audit['erc_warnings'],
        'nominal_input_voltage_v': 5, 'nominal_input_current_setting_ma': 500,
        'current_limit_note': '500 mA is the charger input setting, not a measured maximum or battery charge current.',
        'usb_pd_or_1p5_3a_cc_detection': False,
        'selected_connector': 'GCT USB4720-03-A',
        'usb_daughterboard_thickness_mm': 0.6,
        'old_purchased_socket': 'Superseded by GCT daughterboard; not assumed defective or qualified',
        'selected_connector_and_pcb_physical_qualification': 'NOT PERFORMED',
        'physical_cable_and_charging_tests': 'NOT PERFORMED',
        'compatibility_condition': 'Assemble both 5.1k CC resistors on the USB daughterboard. Source/cable/current/inrush, mechanical installation and charging qualification remain required.',
        'source_hashes': hashes, 'netlist_sha256': digest(netlist),
        'board_sha256': board_hash, 'baseline_archive_sha256': digest(baseline),
    }
    (VERIFY/'usb-compatibility.json').write_text(json.dumps(report, indent=2)+'\n')

    preview = VERIFY/'preview'
    manifest_path = preview/'manifest.json'
    manifest = json.loads(manifest_path.read_text())
    manifest.setdefault('initial_import_source_hashes', manifest['source_hashes'])
    manifest['source_hashes'] = hashes
    manifest['offboard_excluded'] = sorted(offboard)
    manifest['staged_schematic_note'] = 'Historical initial import only. Current A2.2 source is verified directly against saved PCB pads.'
    manifest['revision_verification_note'] = 'GCT USB daughterboard is separate; all 119 main-board footprints and 353 numbered pad nets rechecked without modifying the main PCB.'
    for ref, data in manifest['components'].items():
        data['current_schematic_value'] = comps[ref].findtext('value')
    manifest_path.write_text(json.dumps(manifest, indent=2)+'\n')
    preview_audit_path = preview/'audit.json'
    preview_audit = json.loads(preview_audit_path.read_text())
    preview_audit.update({
        'result': 'PASS', 'board_components': len(footprints), 'numbered_pins': len(actual),
        'tracks': len(board.GetTracks()), 'zones': len(list(board.Zones())),
        'source_schematics_unchanged': True, 'all_pad_nets_match_kicad_cli': True,
        'offboard_excluded': sorted(offboard), 'positions': positions,
        'board_sha256': board_hash, 'verified_source_hashes': hashes,
        'verification_revision': 'A2.2', 'board_modified_during_a2_2_verification': False,
    })
    preview_audit_path.write_text(json.dumps(preview_audit, indent=2)+'\n')
    print(json.dumps({k: v for k, v in report.items() if not k.endswith('hashes') and not k.endswith('sha256')}, indent=2))


if __name__ == '__main__':
    main()
