#!/usr/bin/env python3
"""Reproducible conditional VBUS budget; never claims legacy USB compliance."""
from pathlib import Path
import hashlib
import json
import xml.etree.ElementTree as ET

HERE = Path(__file__).resolve().parent
ELECTRICAL = HERE.parent
NETLIST = ELECTRICAL / 'analyzer-netlist.xml'


def main():
    tree = ET.parse(NETLIST).getroot()
    expected = {
        'USB_5V': {'C115','D901','J101','J901','J902','R110','R121','R124','TP1002','U115'},
        'USB_OVP_5V': {'C114','R113','R127','U114','U115'},
        'USB_CHG_5V': {'C101','U101','U114'},
    }
    actual = {n.attrib['name'].split('/')[-1]: {x.attrib['ref'] for x in n}
              for n in tree.find('nets') if n.attrib['name'].split('/')[-1] in expected}
    assert actual == expected, 'VBUS population changed; review every new current path'
    components = {c.attrib['ref']: c.findtext('value') for c in tree.find('components')}
    values = {'R110':'887k / 1%', 'R121':'34k / 0.1% / 10ppm',
              'R122':'649R / 0.1% / 10ppm', 'R124':'21.5k / 0.1% / 25ppm',
              'R113':'97.6k / 0.1%', 'R127':'10k / 1%',
              'U114':'TPS22950CQDDCRQ1','U115':'TPS259470ARPWR','U101':'BQ25895RTWR'}
    for ref, value in values.items():
        assert components[ref] == value, (ref,components[ref],value)

    cases = []
    for voltage in (5.0, 5.5):
        # Bound these signal-leg currents using ONLY the upper resistor and
        # nonnegative pin voltage. This intentionally overestimates normal
        # divider current; no exact input-leakage cancellation is assumed.
        # The fractional allowances are explicit engineering assumptions.
        rows = [
            ('U115 supply',610e-6,'TI maximum at VIN=12V/OUT open; application at 5V is not a new guaranteed limit'),
            ('U115 OVLO upper leg',voltage/((34000+649)*(1-.003)),'R121+R122; 0.3% independent tolerance/TCR/drift allowance'),
            ('U115 UVLO upper leg',voltage/(21500*(1-.0045)),'R124; 0.45% allowance'),
            ('Protected-node bleed',voltage/(10000*(1-.021)),'R127; 2.1% allowance'),
            ('Supervisor sense upper leg',voltage/(97600*(1-.0045)),'R113; 0.45% allowance'),
            ('Raw VBUS detect upper leg',voltage/(887000*(1-.021)),'R110; 2.1% allowance'),
            ('U114 supply',60e-6,'TI ON-state maximum; OUT open'),
            ('U114 ON pin',50e-9,'TI ON leakage maximum'),
            ('D901 leakage reference',100e-9,'TI maximum at 5V; no full-temperature/5.5V extrapolation claimed'),
        ]
        subtotal = sum(r[1] for r in rows)
        cases.append({
            'VBUS_V':voltage,
            'terms':[{'path':r[0],'A':r[1],'basis':r[2]} for r in rows],
            'conditional_upstream_subtotal_A':subtotal,
            'with_BQ_35uA_reference_A':subtotal+35e-6,
            'remaining_to_2_5mA_before_unbounded_terms_A':.0025-subtotal-35e-6,
            'with_BQ_non_HIZ_3mA_reference_A':subtotal+.003,
        })
    sources = [NETLIST, Path(__file__),
               ELECTRICAL/'sources/bq25895.pdf',
               ELECTRICAL/'usb-protection-research/tpd1e10b06.pdf',
               ELECTRICAL/'usb-protection-research/tps22950-q1-review-datasheet.pdf',
               ELECTRICAL/'usb-protection-research/tps25947-ovp-review-datasheet.pdf']
    result = {
        'status':'missing evidence; conditional current budget only',
        'topology_assertions_passed':len(expected)+len(values),
        'source_net_members':{k:sorted(v) for k,v in actual.items()},
        'cases':cases,
        'conditions':[
            'Normal DC polarity, healthy components and nonnegative divider-input pin voltages; no fault clamp current or inrush.',
            'BQ EN_HIZ must be verified, ADC inactive, and watchdog/reset behaviour managed. Charge disable alone is insufficient.',
            'Host and external CC/BC detector supplies originate from the battery while isolated, not from VBUS.',
            'BQ 35uA maximum is specified at 5V with no battery and battery monitor disabled. Battery-present and 5.5V behaviour are not bounded here.',
        ],
        'unbounded_terms_and_exclusions':[
            'Whole-board temperature, PCB contamination/leakage, MLCC insulation and assembled connector leakage.',
            'U115 supply-current voltage/test-condition transfer and active-ramp/fault behaviour.',
            'HIZ/ADC transitions, source reclassification, USB attach/inrush, POR/watchdog and firmware-stall windows.',
            'Host-off or depleted-pack recovery; no firmware can enforce this mode while the host is unpowered.',
            'CC/data-line signalling current is separate from this VBUS-only sum.',
        ],
        'acceptance':'Neither the residual numerical margin nor matching topology establishes a 2.5mA average-current compliance result. Bench and missing manufacturer bounds remain required.',
        'sources':[{'path':str(p.relative_to(ELECTRICAL)), 'sha256':hashlib.sha256(p.read_bytes()).hexdigest()} for p in sources],
    }
    (HERE/'standby-budget.json').write_text(json.dumps(result,indent=2)+'\n')
    for c in cases:
        print(f"{c['VBUS_V']:.1f}V: conditional total with 35uA BQ reference = {c['with_BQ_35uA_reference_A']*1000:.4f}mA; NOT a compliance bound")


if __name__ == '__main__':
    main()
