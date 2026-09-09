"""Build a source-backed PCB reference list; read-only with respect to KiCad.

Run with KiCad's bundled Python. Only reference/ documentation, audit receipts
and fresh CLI XML snapshots are written. No PCB or schematic is saved.
"""
from pathlib import Path
import collections
import csv
import datetime
import hashlib
import json
import os
import re
import subprocess
import xml.etree.ElementTree as ET

import pcbnew

ROOT = Path(__file__).resolve().parents[4]
OUT = ROOT / 'hardware/pcb/integration/reference'
CLI = '/Applications/KiCad/KiCad.app/Contents/MacOS/kicad-cli'
BOARDS = {
    'Main': ROOT / 'hardware/pcb/analyzer/Trimix_Analyzer.kicad_pcb',
    'USB': ROOT / 'hardware/pcb/usb-input/Trimix_USB_Input.kicad_pcb',
}
PREFIXES = {
    'R': ('Resistor', 'Sets resistance; a zero-ohm part is an electrical link.'),
    'RN': ('Resistor network', 'Matched resistors in one package; their ratio provides a stable reference.'),
    'C': ('Capacitor', 'Stores charge; often used for filtering or supply decoupling.'),
    'U': ('Integrated circuit', 'A chip or, in the schematic, an explicitly identified remote module.'),
    'J': ('Connector', 'A cable connection, socket or jumper/header position.'),
    'L': ('Inductor', 'Stores energy magnetically, for example in a switching supply.'),
    'Q': ('Transistor', 'An electronic switching or signal-control device.'),
    'D': ('Diode', 'Includes light-emitting diodes (LEDs).'),
    'RV': ('Adjustable resistor', 'A potentiometer or trimming resistor.'),
    'SW': ('Switch', 'A physical contact switch.'),
    'TP': ('Test pad', 'Bare PCB copper for a measurement probe; no fitted component.'),
    'H': ('Mounting hole', 'A mechanical PCB hole; no electronic component.'),
}


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def asset(path):
    return {'path': str(path.relative_to(ROOT)), 'sha256': sha(path),
            'bytes': path.stat().st_size}


def prefix(ref):
    return re.match(r'[A-Z]+', ref).group()


def natural(ref):
    return (prefix(ref), int(re.search(r'\d+', ref).group()))


def english_value(ref, value):
    """Expand only the units explicitly encoded in the source value."""
    p = prefix(ref)
    if p == 'RN' and value == '2x2k / 1:1 matched':
        return 'Two matched 2 kilohm resistors; 1:1 divider'
    patterns = {
        'R': (r'^(\d+(?:\.\d+)?)(R|k|M)(?=\s|/|$)',
              {'R': 'ohm', 'k': 'kilohm', 'M': 'megaohm'}),
        'RV': (r'^(\d+(?:\.\d+)?)(R|k|M)(?=\s|/|$)',
               {'R': 'ohm', 'k': 'kilohm', 'M': 'megaohm'}),
        'C': (r'^(\d+(?:\.\d+)?)(p|n|u)(?:F)?(?=\s|/|$)',
              {'p': 'picofarad', 'n': 'nanofarad', 'u': 'microfarad'}),
        'L': (r'^(\d+(?:\.\d+)?)(u|m)(?:H)?(?=\s|/|$)',
              {'u': 'microhenry', 'm': 'millihenry'}),
    }
    if p in patterns:
        pat, units = patterns[p]
        def replace(m):
            unit = units[m[2]]
            if float(m[1]) != 1:
                unit = unit[:-1] + 'ies' if unit.endswith('henry') else unit + 's'
            return m[1] + ' ' + unit
        value = re.sub(pat, replace, value)
        value = re.sub(r'(?<!\w)(\d+(?:\.\d+)?)\s*V\b', r'\1 volts', value)
        value = re.sub(r'(?<!\w)(\d+(?:\.\d+)?)\s*A\b', r'\1 amperes', value)
        value = value.replace('Isat >=', 'saturation current at least')
    return value


def node_fields(node):
    return {x.attrib['name']: x.text or '' for x in node.findall('./fields/field')}


def props(node):
    return {x.attrib['name']: x.attrib.get('value', '') for x in node.findall('property')}


def source_line(path, ref):
    marker = '(property "Reference" "' + ref + '"'
    for i, line in enumerate(path.read_text().splitlines(), 1):
        if marker in line:
            return i
    raise AssertionError(('Reference not found in source', path, ref))


def component_type(ref, node):
    if ref.startswith('H'):
        return 'Mounting hole'
    part = node.find('libsource').attrib.get('part', '')
    if part == 'LED':
        return 'Light-emitting diode (LED)'
    if part in ('2N7002', 'BSS138'):
        return 'N-channel MOSFET transistor'
    if part == 'Jumper_2_Open':
        return 'Jumper header'
    if part == 'R_Potentiometer':
        return 'Trimmer potentiometer'
    return PREFIXES[prefix(ref)][0]


def footprint_id(fp):
    lib = str(fp.GetFPID().GetLibNickname())
    name = str(fp.GetFPID().GetLibItemName())
    return lib + ':' + name if lib else name


def source_function(ref, fields):
    key = next((k for k in ('Purpose', 'Use', 'Connection', 'Harness') if fields.get(k)), '')
    if key:
        return key, fields[key], fields[key]
    description = fields.get('Description', '')
    if prefix(ref) == 'U':
        summaries = [
            ('Fast Charger', 'Single-cell battery charger controlled over I2C.'),
            ('buck-boost converter', 'Adjustable buck-boost voltage converter.'),
            ('fuel gauge', 'Single-cell battery fuel gauge.'),
            ('16-Bit ADCs', '16-bit analog-to-digital converter.'),
            ('Low drop-out regulator', 'Low-dropout voltage regulator.'),
            ('pushbutton controller', 'Push-button controller.'),
        ]
        for fragment, summary in summaries:
            if fragment in description:
                return 'Description (concise summary)', summary, description
    return '', '', ''


def md(text):
    return str(text).replace('|', '\\|').replace('\n', ' ').strip()


def link(path):
    return os.path.relpath(path, OUT)


def main():
    OUT.mkdir(parents=True, exist_ok=True)
    (OUT / 'source').mkdir(exist_ok=True)
    guarded = sorted(set(BOARDS.values()) | {
        p for board in BOARDS.values()
        for pattern in ('*.kicad_sch', '*.kicad_pro')
        for p in board.parent.glob(pattern)
    })
    before = {str(p): sha(p) for p in guarded}
    sources = {}; xml_paths = {}
    for label, board in BOARDS.items():
        xml = OUT / 'source' / (label.lower() + '-fresh-netlist.xml')
        result = subprocess.run([CLI, 'sch', 'export', 'netlist', '--format',
            'kicadxml', '--output', str(xml), str(board.with_suffix('.kicad_sch'))],
            capture_output=True, text=True, check=True)
        sources[label] = ET.parse(xml).getroot(); xml_paths[label] = xml
    all_main = {n.attrib['ref']: n for n in sources['Main'].findall('./components/comp')}
    rows = []; board_membership = {}; board_values = {}; dnp_by_board = {}
    text_geometry = []
    labels = json.loads((ROOT / 'hardware/pcb/integration/verification/markings/main-labels.json').read_text())
    allowed_hidden = {'Main': set(labels.get('assembly_map_only', [])), 'USB': {'J901', 'J902'}}
    hidden_references = {'Main': [], 'USB': []}
    for label, board_path in BOARDS.items():
        board = pcbnew.LoadBoard(str(board_path))
        nodes = {n.attrib['ref']: n for n in sources[label].findall('./components/comp')}
        seen = set(); values = {}; dnp = []
        separate_labels = {d.GetText(): d for d in board.GetDrawings() if isinstance(d, pcbnew.PCB_TEXT)}
        for fp in board.GetFootprints():
            ref = fp.GetReference(); assert ref not in seen; seen.add(ref)
            value = fp.GetValue(); values[ref] = value
            reference_text = fp.Reference()
            label_source = 'footprint_reference'
            if not reference_text.IsVisible() and ref in separate_labels:
                reference_text = separate_labels[ref]
                label_source = 'independent_board_text'
            reference_layer = reference_text.GetLayer()
            assert reference_layer in (pcbnew.F_SilkS, pcbnew.B_SilkS), (label, ref, 'reference is not on silkscreen')
            visible = bool(reference_text.IsVisible())
            assert visible or ref in allowed_hidden[label], (label, ref, 'undocumented hidden reference')
            if not visible: hidden_references[label].append(ref)
            side = 'Front' if reference_layer == pcbnew.F_SilkS else 'Back'
            mirrored = bool(reference_text.IsMirrored())
            assert mirrored == (side == 'Back'), (label, ref, 'incorrect text mirroring')
            if visible: text_geometry.append({'board': label, 'reference': ref, 'side': side,
                'height_mm': pcbnew.ToMM(reference_text.GetTextHeight()),
                'stroke_mm': pcbnew.ToMM(reference_text.GetTextThickness()),
                'mirrored': mirrored, 'label_source': label_source})
            mechanical = prefix(ref) == 'H'
            n = None if mechanical else nodes[ref]
            f = {} if mechanical else node_fields(n)
            properties = {} if mechanical else props(n)
            if not mechanical:
                assert value == n.findtext('value'), (label, ref, value, n.findtext('value'))
                assert footprint_id(fp) == n.findtext('footprint'), (label, ref, 'footprint mismatch')
                assert fp.IsDNP() == ('dnp' in properties), (label, ref, 'DNP mismatch')
            if fp.IsDNP(): dnp.append(ref)
            source = board_path if mechanical else board_path.parent / properties['Sheetfile']
            section = 'Mechanical mounting' if mechanical else n.find('sheetpath').attrib['names'].strip('/')
            if label == 'USB': section = '09  USB-A + USB-C INPUT'
            provisional = any('provisional' in f.get(k, '').lower() for k in ('Package_Status', 'Assembly_hold'))
            assembly_hold = any(f.get(k) for k in ('Assembly_hold', 'Mechanical', 'Selection', 'Status'))
            if mechanical:
                fit = 'Mounting hole; no fitted component'
            elif ref.startswith('TP'):
                fit = 'Bare test pad; no fitted component'
            elif fp.IsDNP():
                fit = 'DNP — do not fit'
            else:
                fit = 'Fit in current draft'
            if provisional: fit += '; PROVISIONAL footprint'
            elif assembly_hold: fit += '; validation required'
            function_field, function, function_source_text = source_function(ref, f)
            extra = {k: val for k, val in f.items() if val and k not in {
                'Footprint', 'Datasheet', 'Description', 'MPN', 'Manufacturer',
                'Primary_datasheet', 'Source', 'Order_source', 'ChipDatasheet', function_field}}
            row = {
                'board': label, 'reference': ref, 'silkscreen_side': side if visible else 'Assembly map only',
                'component_side': 'Back' if fp.GetLayer() == pcbnew.B_Cu else 'Front',
                'component_type': component_type(ref, n),
                'value_plain_english': '2.30 mm non-plated hole for M2 mounting' if mechanical else english_value(ref, value),
                'schematic_value': '' if mechanical else value, 'board_value': value,
                'footprint': footprint_id(fp), 'fit_status': fit,
                'DNP': bool(fp.IsDNP()), 'provisional_footprint': provisional,
                'excluded_from_BOM': bool(fp.IsExcludedFromBOM()),
                'functional_sheet': section, 'function_from_source': function,
                'function_source_field': function_field, 'function_source_text': function_source_text,
                'assembly_and_selection_notes': '; '.join(k + ': ' + val for k, val in extra.items()),
                'manufacturer_field': f.get('Manufacturer', ''), 'MPN_field': f.get('MPN', ''),
                'source_file': str(source.relative_to(ROOT)), 'source_line': source_line(source, ref),
                'datasheet': '' if mechanical else (f.get('Primary_datasheet') or n.findtext('datasheet') or ''),
            }
            if mechanical:
                drills = [pcbnew.ToMM(p.GetDrillSize().x) for p in fp.Pads()]
                assert drills == [2.3], (ref, drills)
            rows.append(row)
        board_membership[label] = sorted(seen, key=natural); board_values[label] = values
        dnp_by_board[label] = sorted(dnp, key=natural)
    main_count, usb_count, total_count = len(board_membership['Main']), len(board_membership['USB']), len(rows)
    assert main_count == 169 and usb_count == 4, ('Reviewed reference membership changed', main_count, usb_count)
    assert all(set(hidden_references[k]) == allowed_hidden[k] for k in BOARDS)
    hidden_count = sum(len(v) for v in hidden_references.values())
    assert len({(r['board'], r['reference']) for r in rows}) == total_count
    remote = sorted(set(all_main) - set(board_membership['Main']) - set(board_membership['USB']), key=natural)
    assert remote == ['U601', 'U704'], remote
    assert all(node_fields(all_main[r]).get('ModuleOffBoard') == 'yes' for r in remote)
    for ref in board_membership['USB']:
        assert board_values['USB'][ref] == all_main[ref].findtext('value')
    assert sum(r['reference'].startswith('TP') for r in rows) == 12
    assert dnp_by_board == {'Main': ['C503', 'C706', 'R602', 'R603', 'R604', 'R804'], 'USB': []}
    assert {str(p): sha(p) for p in guarded} == before, 'Sources changed during read: rerun after the PCB writer finishes.'

    rows.sort(key=lambda r: (0 if r['board'] == 'Main' else 1, r['functional_sheet'], natural(r['reference'])))
    csv_path = OUT / 'COMPONENT_REFERENCE.csv'
    with csv_path.open('w', encoding='utf-8-sig', newline='') as handle:
        writer = csv.DictWriter(handle, fieldnames=list(rows[0]))
        writer.writeheader(); writer.writerows(rows)
    now = datetime.datetime.now(datetime.timezone.utc).isoformat()
    text = ['# PCB component reference', '',
        'Read the printed reference (for example **R101**) and find it below. The letters identify the component type; the number is its unique identifier, not its resistance or rating.', '',
        f'**{total_count} PCB references:** {main_count} on the main board and {usb_count} on the USB board. The main count includes twelve test pads and two mounting holes. These are the current design values, not a confirmed shopping list or fabrication release. Main routing is unfinished.', '',
        'Values below expand the schematic unit notation into plain English. The [CSV](COMPONENT_REFERENCE.csv) also preserves every exact schematic value, footprint, source field, assembly note and source location. Ratings and part numbers are shown only where the source supplies them. A blank manufacturer/MPN field means none is explicitly assigned there.', '',
        '**DNP** means “do not populate”: leave that component position empty. **Fit in current draft** describes the current assembly choice, not stock or package qualification. **PROVISIONAL** and **validation required** remain open gates. Test pads and mounting holes are not purchased electronic components. J104 uses a header, but its charging-arm shunt must remain off before commissioning.', '',
        '**Silkscreen side** tells you where the reference is printed; it is independent of the component mounting side in the CSV. Both faces now carry components. Back labels are mirrored in KiCad so they read normally when you turn the bare board over. Dense areas use reverse labels, which may be covered after assembly. Nine references are explicitly **Assembly map only** because no readable nearby silkscreen position was available: main ' + ', '.join(sorted(hidden_references['Main'], key=natural)) + '; USB J901 and J902. U901 and D901 use independent board-text labels. Use the assembly maps to locate unprinted references.', '',
        'Companion maps: main [front silkscreen](main-front.svg), [back silkscreen](main-back.svg) and [front assembly map](main-assembly.svg), [back assembly map](main-back-assembly.svg); USB [front silkscreen](usb-front.svg) and [back silkscreen](usb-back.svg).', '',
        '## Prefix legend', '', '| Prefix | Meaning | How to read it |', '|---|---|---|']
    for pref, (name, explanation) in PREFIXES.items(): text.append(f'| {pref} | {name} | {explanation} |')
    for board_label in ('Main', 'USB'):
        text += ['', '## ' + board_label + ' board', '']
        groups = collections.defaultdict(list)
        for row in rows:
            if row['board'] == board_label: groups[row['functional_sheet']].append(row)
        for section, items in groups.items():
            text += ['### ' + section, '', '| Marking | Silkscreen side | Component type | Value or type | Fit status | Function stated in source |', '|---|---|---|---|---|---|']
            for row in items:
                target = link(ROOT / row['source_file']) + '#L' + str(row['source_line'])
                cells = [f"[{row['reference']}]({target})", row['silkscreen_side'], row['component_type'], row['value_plain_english'], row['fit_status'], row['function_from_source'] or '—']
                text.append('| ' + ' | '.join(md(x) for x in cells) + ' |')
            text.append('')
    text += ['## Remote modules are separate', '',
        f'These two schematic references are off-board modules, so they are excluded from the {total_count}-row PCB list:', '']
    for ref in remote:
        n = all_main[ref]; f = node_fields(n)
        text.append(f"- **{ref} — {n.findtext('value')}**: {f.get('Assembly') or f.get('Use') or 'Off-board purchased module.'}")
    text += ['', 'The main schematic also shows J901/J902/U901/D901 for context; those four parts are counted once, on the separate USB board.', '',
        '## Sources and checks', '', f'Generated: {now}. KiCad CLI XML was freshly exported from both current schematics. Both native PCB files were loaded without saving.', '',
        f'Checks passed: exact {total_count}-reference membership; {len(text_geometry)} printed reference fields with correct front/back mirroring and {hidden_count} explicitly documented assembly-map-only references; exact schematic/native-board value and footprint agreement; native/schematic DNP agreement; twelve main test pads; two Ø2.30 mm mounting holes; and unchanged source files throughout generation.', '',
        'The [verification receipt](component-reference-verification.json) includes all source hashes, full reference membership and DNP checks. Board hashes identify the source snapshot; later markings-only saves require regeneration to bind their new hashes.', '',
        '| Source snapshot | SHA-256 |', '|---|---|']
    for p in list(BOARDS.values()) + list(xml_paths.values()):
        text.append(f'| [{p.name}]({link(p)}) | `{sha(p)}` |')
    md_path = OUT / 'COMPONENT_REFERENCE.md'; md_path.write_text('\n'.join(text) + '\n')
    receipt = {
        'status': 'passed_source_reference_mapping_not_design_release', 'generated_utc': now,
        'rows': total_count, 'main_rows': main_count, 'usb_rows': usb_count, 'test_pad_rows': 12, 'mounting_hole_rows': 2,
        'reference_membership': board_membership, 'DNP': dnp_by_board,
        'visible_printed_reference_count': len(text_geometry),
        'silkscreen_side_counts': {label: dict(collections.Counter(x['side'] for x in text_geometry if x['board'] == label)) for label in BOARDS},
        'native_reference_text': text_geometry,
        'printed_reference_sides_and_mirroring_verified': True,
        'assembly_map_only': hidden_references,
        'remote_modules_excluded': [{'reference': r, 'value': all_main[r].findtext('value')} for r in remote],
        'exact_native_board_schematic_value_and_footprint_match': True,
        'DNP_native_schematic_match': True, 'sources_unchanged_during_generation': True,
        'source_assets': [asset(p) for p in guarded] + [asset(p) for p in xml_paths.values()] + [asset(Path(__file__))],
        'outputs': [asset(csv_path), asset(md_path)],
        'qualification': 'Source mapping only. Manufacturer fields are not inferred from footprint names. No routing, package, purchasing, safety or manufacture qualification is asserted.'}
    (OUT / 'component-reference-verification.json').write_text(json.dumps(receipt, indent=2) + '\n')
    print(json.dumps({k: receipt[k] for k in ('status', 'rows', 'main_rows', 'usb_rows', 'test_pad_rows', 'mounting_hole_rows', 'DNP')}, indent=2))


if __name__ == '__main__':
    main()
