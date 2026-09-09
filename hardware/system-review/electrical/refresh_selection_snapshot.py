"""Read the exported schematic, without replaying historical part mutations."""
from pathlib import Path
import hashlib
import json
import xml.etree.ElementTree as ET

OUT = Path(__file__).resolve().parent


def run():
    source = OUT / 'analyzer-netlist.xml'
    parts = {}
    for component in ET.parse(source).getroot().findall('components/comp'):
        fields = {f.get('name'): f.text or ''
                  for f in component.findall('fields/field')}
        if not fields.get('MPN'):
            continue
        fields.update(Value=component.findtext('value', ''),
                      Footprint=component.findtext('footprint', ''),
                      Datasheet=component.findtext('datasheet', ''))
        parts[component.get('ref')] = fields
    assert parts['C101']['MPN'] == 'C0603C105K4RACTU'
    assert parts['J301']['MPN'] == 'HTSW-113-07-L-D-007'
    assert not {'D101', 'R106', 'SW101'} & parts.keys()
    (OUT / 'standard-part-selections.json').write_text(json.dumps({
        'parts': parts,
        'status': 'Selected schematic fields from the source-matched promoted design; supplier availability and manufacturing/physical acceptance remain unconfirmed',
        'source': str(source.relative_to(OUT.parents[2])),
        'source_sha256': hashlib.sha256(source.read_bytes()).hexdigest(),
        'physical_tests_performed': False,
        'supplier_quote': False,
        'removed_references': ['D101', 'R106', 'SW101'],
    }, indent=2) + '\n')
    print(f'{len(parts)} exact MPN fields read from the current schematic export')


if __name__ == '__main__':
    run()
