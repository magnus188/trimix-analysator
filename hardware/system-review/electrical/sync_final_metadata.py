"""Copy hidden source metadata to an already matching, routed PCB.

This deliberately cannot repair a part, footprint, population, DNP or pad/net
disagreement. Those require a separately reviewed design change. Copper,
placement, pads, models, markings and property presentation are immutable here.
Run with a Python environment providing sexpdata; no KiCad GUI is needed.
"""
from pathlib import Path
import argparse
import copy
import hashlib
import json
import re
import sys
import uuid
import xml.etree.ElementTree as ET

ROOT = Path(__file__).resolve().parents[3]
sys.path.insert(0, str(ROOT / 'hardware/tools'))
from analyzer_sheet import sx, child, children, tag, node, S, fmt
from apply_review_fixes import top_blocks


def sha(data):
    return hashlib.sha256(data).hexdigest()


def properties(fp):
    pairs = children(fp, 'property')
    result = {p[1]: p for p in pairs}
    if len(result) != len(pairs):
        raise ValueError('Duplicate footprint property names')
    return result


def without_properties(fp):
    return [v for v in fp if tag(v) != 'property']


def hidden(prop):
    h = child(prop, 'hide')
    if h is not None and (len(h) == 1 or str(h[1]) == 'yes'):
        return True
    e = child(prop, 'effects')
    return e is not None and child(e, 'hide') is not None


def source_components(xml):
    return {c.get('ref'): c for c in xml.findall('./components/comp')
            if c.findtext('footprint', '') and not any(
                p.get('name') == 'exclude_from_board' for p in c.findall('property'))}


def sync(board, netlist, output, receipt):
    raw = board.read_text()
    tree = sx.loads(raw)
    xml_bytes = netlist.read_bytes()
    xml = ET.fromstring(xml_bytes)
    comps = source_components(xml)
    blocks = {}
    fps = {}
    for start, end, block in top_blocks(raw):
        if not block.startswith('(footprint '):
            continue
        fp = sx.loads(block)
        ref = properties(fp)['Reference'][2]
        if ref in fps:
            raise ValueError('Duplicate footprint reference ' + ref)
        fps[ref] = fp
        blocks[ref] = (start, end, block)
    # Only these two established mechanical NPTH footprints are absent from the
    # electrical netlist. Extra electrical/testpoint footprints are not ignored.
    mechanical = {'H1', 'H2'}
    errors = []
    if set(fps) - mechanical != set(comps):
        errors.append({'population': {'board_only': sorted(set(fps)-set(comps)-mechanical),
                                      'netlist_only': sorted(set(comps)-set(fps))}})
    expected = {}
    for net in xml.findall('./nets/net'):
        for pin in net.findall('node'):
            key = (pin.get('ref'), pin.get('pin'))
            if key in expected and expected[key] != net.get('name'):
                raise ValueError('Netlist pin appears on multiple nets: ' + repr(key))
            expected[key] = net.get('name')
    changes = {}
    matched_pads = 0
    for ref, fp in fps.items():
        props = properties(fp)
        if ref in mechanical:
            if any(p[2] != S('np_thru_hole') or child(p, 'net') is not None
                   for p in children(fp, 'pad')):
                errors.append({'reference': ref, 'mechanical_NPTH_only': False})
            continue
        if ref not in comps:
            continue
        c = comps[ref]
        fields = {q.get('name'): q.text or '' for q in c.findall('./fields/field')}
        identity = {'Value': (props.get('Value', ['', '', ''])[2], c.findtext('value', '')),
                    'MPN': (props.get('MPN', ['', '', ''])[2], fields.get('MPN', '')),
                    'Footprint': (fp[1], c.findtext('footprint', ''))}
        for name, (actual, wanted) in identity.items():
            if actual != wanted:
                errors.append({'reference': ref, 'field': name, 'board': actual, 'netlist': wanted})
        attrs = child(fp, 'attr') or []
        for native, exported in [('dnp', 'dnp'), ('exclude_from_bom', 'exclude_from_bom')]:
            actual = S(native) in attrs
            wanted = any(p.get('name') == exported for p in c.findall('property'))
            if actual != wanted:
                errors.append({'reference': ref, 'field': native, 'board': actual, 'netlist': wanted})
        numbered = set()
        for pad in children(fp, 'pad'):
            number = str(pad[1])
            net = child(pad, 'net')
            actual = '' if net is None else net[-1]
            if not number:
                # Established unnumbered mask/paste helper apertures are allowed;
                # any unexpected electrical net still fails.
                if actual:
                    errors.append({'reference': ref, 'unnumbered_pad_has_net': actual})
                continue
            numbered.add(number)
            wanted = expected.get((ref, number))
            if wanted is None or actual != wanted:
                errors.append({'reference': ref, 'pad': number, 'board_net': actual,
                               'netlist_net': wanted})
            else:
                matched_pads += 1
        expected_numbers = {pin for r, pin in expected if r == ref}
        if numbered != expected_numbers:
            errors.append({'reference': ref, 'pad_population': {
                'board_only': sorted(numbered - expected_numbers),
                'netlist_only': sorted(expected_numbers - numbered)}})
        fields.update(Datasheet=c.findtext('datasheet', ''),
                      Description=c.findtext('description', ''))
        modified = copy.deepcopy(fp)
        mp = properties(modified)
        field_changes = []
        for name, value in sorted(fields.items()):
            if name in {'Reference', 'Value', 'Footprint'}:
                continue
            if name in mp:
                if mp[name][2] == value:
                    continue
                if not hidden(mp[name]):
                    errors.append({'reference': ref, 'visible_field_would_change': name})
                    continue
                old = mp[name][2]
                mp[name][2] = value
            else:
                old = None
                back = child(fp, 'layer')[1] == 'B.Cu'
                effects = node('effects', node('font', node('size', .8, .8), node('thickness', .15)))
                if back:
                    effects.append(node('justify', S('mirror')))
                prop = node('property', name, value, node('at', 0, 0, 0),
                            node('layer', 'B.Fab' if back else 'F.Fab'), node('hide', S('yes')),
                            node('uuid', str(uuid.uuid5(uuid.NAMESPACE_URL,
                                 'trimix:final-hidden-metadata:' + str(child(fp, 'uuid')[1]) + ':' + name))),
                            effects)
                # Properties belong before pads/graphics. No presentation or
                # placement of any pre-existing property is changed.
                insert = max(i for i, v in enumerate(modified) if tag(v) == 'property') + 1
                modified.insert(insert, prop)
                mp[name] = prop
            field_changes.append({'field': name, 'before': old, 'after': value})
        if field_changes:
            assert without_properties(fp) == without_properties(modified)
            for name, old in props.items():
                new = mp[name]
                assert old[:2] == new[:2] and old[3:] == new[3:], (ref, name)
            changes[ref] = (modified, field_changes)
    if errors:
        raise ValueError('Metadata sync refused before writing:\n' + json.dumps(errors, indent=2))
    result = raw
    for ref, (start, end, _) in sorted(blocks.items(), key=lambda row: row[1][0], reverse=True):
        if ref in changes:
            result = result[:start] + fmt(changes[ref][0], 1) + result[end:]
    after = sx.loads(result)
    # All non-footprint blocks retain their original bytes, not merely parsed
    # equivalence. That includes routing, filled polygons, stackup and rules.
    before_other = [b for _, _, b in top_blocks(raw) if not b.startswith('(footprint ')]
    after_other = [b for _, _, b in top_blocks(result) if not b.startswith('(footprint ')]
    assert before_other == after_other
    after_fps = {properties(fp)['Reference'][2]: fp for fp in children(after, 'footprint')}
    assert fps.keys() == after_fps.keys()
    for ref in fps:
        assert without_properties(fps[ref]) == without_properties(after_fps[ref]), ref
        if ref not in changes:
            assert fps[ref] == after_fps[ref], ref
    output.parent.mkdir(parents=True, exist_ok=True)
    output.write_text(result)
    data = {'source_board': str(board.resolve()), 'source_board_sha256': sha(raw.encode()),
            'netlist': str(netlist.resolve()), 'netlist_sha256': sha(xml_bytes),
            'output_board': str(output.resolve()), 'output_board_sha256': sha(result.encode()),
            'references_checked': len(comps), 'numbered_pads_checked': matched_pads,
            'metadata_changes': {ref: change for ref, (_, change) in sorted(changes.items())},
            'native_copper_pads_placement_models_graphics_unchanged': True,
            'existing_property_presentation_unchanged': True,
            'requires_fresh_native_DRC_ERC_and_manufacturing_audits': True}
    receipt.parent.mkdir(parents=True, exist_ok=True)
    receipt.write_text(json.dumps(data, indent=2) + '\n')
    return data


if __name__ == '__main__':
    ap = argparse.ArgumentParser(description=__doc__)
    for name in ['board', 'netlist', 'output', 'receipt']:
        ap.add_argument('--' + name, type=Path, required=True)
    args = ap.parse_args()
    try:
        result = sync(args.board, args.netlist, args.output, args.receipt)
    except (ValueError, AssertionError) as exc:
        raise SystemExit(str(exc))
    print(json.dumps({k: result[k] for k in ['output_board_sha256', 'references_checked',
                                           'numbered_pads_checked']}, indent=2))
