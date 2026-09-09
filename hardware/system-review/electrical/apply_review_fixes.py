"""Guarded electrical review fixes; deliberately preserves layout and pin nets.

Run with ordinary Python. Native ERC/netlist/PCB audits are separate commands.
The baseline is immutable and is captured before calling this file.
"""
from pathlib import Path
import hashlib
import json
import re

ROOT = Path(__file__).resolve().parents[3]
OUT = Path(__file__).resolve().parent


def top_blocks(text):
    depth = 0
    quoted = escaped = False
    start = None
    for i, ch in enumerate(text):
        if quoted:
            if escaped:
                escaped = False
            elif ch == '\\':
                escaped = True
            elif ch == '"':
                quoted = False
            continue
        if ch == '"':
            quoted = True
        elif ch == '(':
            if depth == 1:
                start = i
            depth += 1
        elif ch == ')':
            depth -= 1
            if depth == 1:
                yield start, i + 1, text[start:i + 1]
    assert depth == 0 and not quoted


def update_values(path, kind, values):
    before = path.read_text()
    edits = []
    seen = set()
    for start, end, block in top_blocks(before):
        if not re.match(r'\(' + kind + r'\s', block):
            continue
        match = re.search(r'\(property\s+"Reference"\s+"([^"]+)"', block)
        if not match or match[1] not in values:
            continue
        ref = match[1]
        old, new = values[ref]
        current = re.search(r'\(property\s+"Value"\s+"([^"]+)"', block)[1]
        assert current in (old, new), (ref, current)
        seen.add(ref)
        if current == old:
            changed, count = re.subn(r'(\(property\s+"Value"\s+)"[^"]+"',
                                     lambda m: m[1] + json.dumps(new), block, count=1)
            assert count == 1
            edits.append((start, end, changed))
    assert seen == set(values), (path, seen)
    after = before
    for start, end, new in reversed(edits):
        after = after[:start] + new + after[end:]
    if after != before:
        path.write_text(after)
    return {'path': str(path.relative_to(ROOT)), 'changed': bool(edits),
            'before': hashlib.sha256(before.encode()).hexdigest(),
            'after': hashlib.sha256(after.encode()).hexdigest()}


def run():
    assert (OUT / 'baseline/manifest.json').exists()
    values = {'R506': ('100R / 0.1%', '680R / 0.1%'),
              'R507': ('100R / 0.1%', '680R / 0.1%')}
    changes = [update_values(ROOT / 'hardware/pcb/analyzer/Helium.kicad_sch', 'symbol', values),
               update_values(ROOT / 'hardware/pcb/analyzer/Trimix_Analyzer.kicad_pcb', 'footprint', values)]
    generator = ROOT / 'hardware/tools/build_analyzer_sensors.py'
    original = generator.read_text()
    # These are the only two He ADC series resistors in this helper loop.
    old = "resistor(s, ref, '100R / 0.1%', 254.0"
    new = "resistor(s, ref, '680R / 0.1%', 254.0"
    if old in original:
        assert original.count(old) == 1
        generator.write_text(original.replace(old, new))
    else:
        assert new in original
    receipt = {'changes': changes, 'allowed_value_changes': values,
               'rationale': 'TI ADS122C04 8.3.1 series input-current limiting; below 10 mA for 3.1 V source with ADC off. No claim of valid off-state conversion or eliminated backpower.',
               'layout_changes': False, 'net_changes': False,
               'source': 'https://www.ti.com/lit/ds/symlink/ads122c04.pdf'}
    (OUT / 'electrical-fixes.json').write_text(json.dumps(receipt, indent=2) + '\n')
    print(json.dumps(receipt, indent=2))


if __name__ == '__main__':
    run()
