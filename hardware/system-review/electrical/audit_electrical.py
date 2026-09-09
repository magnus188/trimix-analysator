"""Independent schematic/interface assertions and bounded analytical checks.

Expected pin functions below are transcribed from manufacturer pin tables,
not taken from the project generators. Run after fresh native XML/ERC exports.
This reports order blockers separately from electrical-contract assertions.
"""
from pathlib import Path
import collections
import csv
import hashlib
import json
import math
import re
import xml.etree.ElementTree as ET

ROOT = Path(__file__).resolve().parents[3]
OUT = Path(__file__).resolve().parent
NETLIST = OUT / 'analyzer-netlist.xml'

# Package-specific manufacturer pin ordering; EP numbers are KiCad conventions.
PIN_TABLES = {
    'BQ25895RTWR': ('https://www.ti.com/lit/ds/symlink/bq25895.pdf',
        'VBUS D+ D- STAT SCL SDA INT OTG CE ILIM TS QON BAT BAT SYS SYS PGND PGND SW SW BTST REGN PMID DSEL PGND'.split()),
    'TPS63020DSJR': ('https://www.ti.com/lit/ds/symlink/tps63020.pdf',
        'VINA GND FB VOUT VOUT L2 L2 L1 L1 VIN VIN EN PS/SYNC PG PGND/EP'.split()),
    'MAX17048G+': ('https://www.analog.com/media/en/technical-documentation/data-sheets/MAX17048-MAX17049.pdf',
        'CTG CELL VDD GND ALRT QSTRT SCL SDA EP'.split()),
    'ADS122C04IPWR': ('https://www.ti.com/lit/ds/symlink/ads122c04.pdf',
        'A0 A1 RESET DGND AVSS AIN3 AIN2 REFN REFP AIN1 AIN0 AVDD DVDD DRDY SDA SCL'.split()),
    'TPS7A2030PDBVR': ('https://www.ti.com/lit/ds/symlink/tps7a20.pdf', 'IN GND EN NC OUT'.split()),
    'TPS22950CQDDCRQ1': ('https://www.ti.com/lit/ds/symlink/tps22950-q1.pdf', 'ON VIN GND ILIM VOUT FLT'.split()),
    'TPS259470ARPWR': ('https://www.ti.com/lit/ds/symlink/tps25947.pdf','EN/UVLO OVLO AUXOFF FLT IN OUT DVDT GND ILM ITIMER'.split()),
    'TPS61023DRLR': ('https://www.ti.com/lit/ds/symlink/tps61023.pdf', 'FB EN VIN GND SW VOUT'.split()),
    'TXU0202DCUR': ('https://www.ti.com/lit/ds/symlink/txu0202.pdf', 'B2 GND VCCA A2Y A1 OE VCCB B1Y'.split()),
    'LTC2954CTS8-1': ('https://www.analog.com/media/en/technical-documentation/data-sheets/2954fb.pdf',
        'VIN PB ONT GND INT EN PDT KILL'.split()),
}

HOST = {
    'I2C_SDA': (21, 28, 'bidirectional', '100 kHz external bus'),
    'I2C_SCL': (14, 29, 'host output', '100 kHz external bus'),
    'CO_UART_TX': (12, 30, 'host output', '9600 baud, TXU0202 A1'),
    'CO_UART_RX': (10, 31, 'host input', '9600 baud, TXU0202 A2Y'),
    'POWER_INT_N': (19, 32, 'host input', 'active-low button interrupt'),
    'POWER_KILL_N': (8, 33, 'host open drain', 'assert low to shut down; release during boot'),
    'HE_ENABLE': (17, 34, 'host output', 'default low; GPIO34 JTAG strap caveat'),
    'CHG_INT_N': (13, 49, 'host input', 'shared active-low BQ interrupt + permission-absent feedback'),
    'USB_ILIM_AUTH': (11, 50, 'host output', 'fail-low source-current permission; fresh rising edge after qualification'),
    'CO_UART_EN': (9, 51, 'host output', 'default low until translated supplies valid'),
}


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def clean(name):
    return name.replace('~{', '').replace('}', '')


def run():
    root = ET.parse(NETLIST).getroot()
    components = {c.get('ref'): c for c in root.findall('./components/comp')}
    pins = {}
    nets = collections.defaultdict(set)
    for net in root.findall('./nets/net'):
        for n in net.findall('node'):
            key = (n.get('ref'), n.get('pin'))
            assert key not in pins
            pins[key] = net.get('name')
            nets[net.get('name')].add(key)
    checks = []

    def check(name, ok, detail=None):
        checks.append({'check': name, 'status': 'pass' if ok else 'fail', 'detail': detail})

    for ref, comp in components.items():
        value = comp.findtext('value')
        if value not in PIN_TABLES:
            continue
        source, names = PIN_TABLES[value]
        lib = comp.find('libsource')
        symbol = next(x for x in root.findall('./libparts/libpart')
                      if x.get('lib') == lib.get('lib') and x.get('part') == lib.get('part'))
        actual = {int(p.get('num')): clean(p.get('name')) for p in symbol.findall('./pins/pin')}
        expected = {i + 1: n for i, n in enumerate(names)}
        check(f'{ref}: exact package pin functions', actual == expected,
              {'mpn': value, 'source': source, 'pins_checked': len(expected),
               'actual': actual if actual != expected else None})

    required = {
        ('U101','1'):'USB_CHG_5V', ('U101','13'):'PACK_P', ('U101','14'):'PACK_P',
        ('U101','15'):'VSYS', ('U101','16'):'VSYS', ('U101','8'):'GND',
        ('U101','5'):'I2C_SCL', ('U101','6'):'I2C_SDA', ('U101','7'):'CHG_INT_N',
        ('U201','10'):'VSYS', ('U201','11'):'VSYS', ('U201','12'):'POWER_EN',
        ('U201','13'):'VSYS', ('U201','4'):'VOUT_5V', ('U201','5'):'VOUT_5V',
        ('U301','1'):'GND', ('U301','2'):'PACK_P', ('U301','3'):'PACK_P',
        ('U301','4'):'GND', ('U301','6'):'GND', ('U301','9'):'GND',
        ('U301','7'):'I2C_SCL', ('U301','8'):'I2C_SDA',
        ('U401','1'):'GND', ('U401','2'):'GND',
        ('U401','11'):'O2_A_AIN_P', ('U401','10'):'O2_A_AIN_N',
        ('U401','7'):'O2_B_AIN_P', ('U401','6'):'O2_B_AIN_N',
        ('U502','1'):'HOST_3V3', ('U502','2'):'GND',
        ('U502','11'):'HE_AIN_P', ('U502','10'):'HE_AIN_N',
        ('U502','7'):'HE_EXC_DIV', ('U502','6'):'O2_VMID',
        ('U501','1'):'VOUT_5V', ('U501','2'):'GND', ('U501','3'):'HE_ENABLE', ('U501','5'):'HE_3V0',
        ('U701','1'):'CO_FB', ('U701','2'):'VOUT_5V', ('U701','3'):'VOUT_5V',
        ('U701','4'):'GND', ('U701','5'):'CO_SW', ('U701','6'):'CO_5V28',
        ('U702','1'):'VOUT_5V', ('U702','2'):'GND', ('U702','3'):'VOUT_5V', ('U702','5'):'CO_LOGIC_3V0',
        ('U703','1'):'CO_TX_3V0', ('U703','2'):'GND', ('U703','3'):'HOST_3V3',
        ('U703','4'):'CO_UART_RX', ('U703','5'):'CO_UART_TX', ('U703','6'):'CO_UART_EN',
        ('U703','7'):'CO_LOGIC_3V0', ('U703','8'):'CO_RX_3V0',
        ('U801','1'):'VSYS', ('U801','4'):'GND', ('U801','5'):'POWER_INT_N',
        ('U801','6'):'POWER_EN', ('U801','8'):'POWER_KILL_N',
        ('RN501','1'):'HE_3V0', ('RN501','2'):'HE_REF', ('RN501','3'):'GND', ('RN501','4'):'HE_REF',
        ('J402','1'):'O2_B_RAW_P', ('J402','2'):'O2_B_RAW_N',
        ('J401','1'):'O2_A_RAW_P', ('J401','2'):'O2_A_RAW_N',
        ('J501','1'):'HE_3V0', ('J501','2'):'HE_SENSE', ('J501','3'):'GND',
        ('J102','1'):'PACK_P', ('J102','2'):'GND',
        ('J101','1'):'USB_5V', ('J101','2'):'GND', ('J902','1'):'USB_5V', ('J902','2'):'GND',
        ('J301','2'):'HOST_5V', ('J301','4'):'HOST_5V',
        ('J301','1'):'HOST_3V3', ('J301','3'):'HOST_3V3', ('J301','18'):'HOST_3V3',
        ('J301','5'):'GND', ('J301','6'):'GND', ('J301','16'):'GND',
    }
    required.update({('U302','1'):'VOUT_5V',('U302','2'):'GND',('U302','3'):'HOST_5V',('U302','5'):'GND',('U302','6'):'HOST_5V',('U114','1'):'USB_OVP_5V',('U114','2'):'USB_OVP_5V',('U114','3'):'GND',('U114','4'):'USB_LIMIT_SET',('U114','5'):'USB_CHG_5V',('U114','6'):'USB_LIMIT_FAULT_N',('R119','1'):'USB_LIMIT_SET',('R119','2'):'GND',('U112','1'):'USB_ILIM_AUTH',('U112','2'):'HOST_3V3',('U112','4'):'GND',('U112','5'):'USB_PERMISSION_Q',('U112','6'):'USB_PERMISSION_CLR_N',('U112','7'):'HOST_3V3',('U112','8'):'HOST_3V3',('U113','1'):'USB_PERMISSION_CLR_N',('U113','2'):'GND',('U113','3'):'USB_CC_INT_N',('U113','5'):'USB_VBUS_SENSE',('U113','6'):'HOST_3V3',('R506','1'):'HE_REF',('R507','1'):'HE_SENSE',('U112','3'):'USB_PERMISSION_Q_N',('Q112','1'):'USB_PERMISSION_Q_N',('Q112','2'):'GND',('Q112','3'):'CHG_INT_N',('U115','3'):'USB_CC_INT_N',('U115','5'):'USB_5V',('U115','6'):'USB_OVP_5V',('U115','8'):'GND',('R113','1'):'USB_OVP_5V',('R127','1'):'USB_OVP_5V',('R127','2'):'GND'})
    for j in ['J101','J902']:
        required.update({(j,str(k)):n for k,n in enumerate(['USB_5V','GND','USB_CC1','USB_CC2','USB_D_P','USB_D_M'],1)})
    for ref in ('U401','U502'):
        required.update({(ref,str(p)):'HOST_3V3' for p in (3,12,13)})
        required.update({(ref,str(p)):'GND' for p in (4,5)})
        required[(ref,'15')] = 'I2C_SDA'
        required[(ref,'16')] = 'I2C_SCL'
    for key, expected in required.items():
        check(f'{key[0]}.{key[1]} net', pins.get(key) == expected,
              {'expected': expected, 'actual': pins.get(key)})

    for signal, (pin, gpio, direction, purpose) in HOST.items():
        check(f'J301.{pin}/{signal}', pins[('J301',str(pin))] == signal,
              {'gpio': gpio, 'direction': direction, 'purpose': purpose})
    for p in (7,15,20,22,23,24,25,26):
        check(f'J301.{p} reserved/unused', pins[('J301',str(p))].startswith('unconnected-'))
    for ref, numbers in [('U101',[2,3,24]),('U401',[8,9,14]),('U502',[8,9,14]),('U501',[4]),('U702',[4]),('U113',[4]),('U115',[4,10])]:
        for number in numbers:
            check(f'{ref}.{number} deliberately NC',
                  pins[(ref,str(number))].startswith('unconnected-'))

    # Independent topology checks catch mistakes that pin-function/name audits miss.
    cc1, cc2 = pins[('J901','A5')], pins[('J901','B5')]
    check('USB CC pins are independent', cc1 != cc2)
    check('No duplicate daughterboard Rd resistors', all(r not in components for r in ['R901','R902']))
    check('CC1 reaches sink controller',pins[('U110','1')]==cc1)
    check('CC2 reaches sink controller',pins[('U110','2')]==cc2)
    check('Fixed supported-range BQ ILIM', components['R103'].findtext('value').startswith('300R'))
    r119_fields={q.get('name'):q.text or ''for q in components['R119'].findall('./fields/field')}
    check('Upstream default selected19.1k standard resistor',components['R119'].findtext('value').startswith('19.1k') and r119_fields.get('MPN')=='RT0402BRD0719K1L')
    check('Qualified parallel resistor1k',components['R116'].findtext('value').startswith('1k'))
    for pad in ('A4','A9','B4','B9'):
        check(f'USB {pad} VBUS', pins[('J901',pad)] == 'USB_5V')
    for ref,val in [('R121','34k'),('R122','649R'),('R123','10k')]:
        fields={q.get('name'):q.text or ''for q in components[ref].findall('./fields/field')}
        check(ref+' OVLO precise value/TCR',components[ref].findtext('value').startswith(val) and fields.get('MPN','').endswith('BYEA'))
    check('OVP cap shared not duplicated',components['C114'].findtext('value').startswith('4.7u / 25V'))
    check('SMB shell has no ground connection', ('J402','2') not in nets['GND'])
    check('TPS VINA internal-feed filter only', nets[pins[('U201','1')]] == {('U201','1'),('C203','1')})
    check('Charger cannot be firmware-armed by spare GPIO',
          not any(ref=='J301' for ref, pin in nets['CHARGE_ARM']))
    for ref in ('R506','R507'):
        check(f'{ref} fault current resistor', components[ref].findtext('value') == '680R / 0.1%')
    for ref in ('R602','R603','R604','R804'):
        check(f'{ref} deliberately DNP', any(p.get('name') == 'dnp' for p in components[ref].findall('property')))

    rmin = 680 * .999
    tau = (1000 + 2*680) * (1e-6 + 10e-9/2)
    gain, ref, vdd = 8, 2.048, 3.3
    fsr = ref/gain
    pga_margin = .2 + fsr*(gain-4)/8
    r_ilim = 300
    # Exposed errors retain units and conditions; these are not measured results.
    calculations = {
        'helium_unpowered_input_current_mA': {'before_100ohm': (3.1-.3)/(100*.999)*1000,
          'after_680ohm': (3.1-.3)/rmin*1000, 'TI_absolute_max_mA': 10,
          'conservative_after_zero_clamp_drop_mA':3.1/rmin*1000,
          'conservative_5V5_fault_source_zero_clamp_drop_mA':5.5/rmin*1000,
          'conditions':'HE3V <=3.1V, AVDD=0V; 0.3V clamp illustration plus conservative zero-drop bounds. Waveform/backpower not validated'},
        'helium_RC': {'tau_min_nominal_ms':tau*1000, 'corner_max_nominal_Hz':1/(2*math.pi*tau),
          'source_impedance_assumption_ohm':0, 'tau_has_no_upper_bound_without_sensor_source_impedance':True},
        'oxygen_PGA_gain8': {'full_scale_V':fsr,'individual_input_limits_at_fullscale_V':[pga_margin,vdd-pga_margin],
          'nominal_fullscale_symmetric_input_extremes_V':[vdd/2-fsr/2,vdd/2+fsr/2]},
        'BQ_hardware_ILIM_A': {'min':320/(r_ilim*1.01),'nominal':355/r_ilim,'max':390/(r_ilim*.99),
          'specification_conditions':'KILIM specified at1.5A. Backup only; TPS22950 defines default. ILIM <500mA unsupported; rejected4.02k extrapolation is not used.'},
        'BQ_cold_voltage_V': {'nominal':4.208,'min':4.208*.995,'max':4.208*1.005,'cell_acceptance':'unknown'},
        'MD62_LDO_heat': {'output_current_A':.12,'typical_rail_loss_W':(5-3)*.12,
          'theta_JA_datasheet_C_per_W':187.1,'rail_loss_temperature_rise_C':(5-3)*.12*187.1,'worst_5V15_to_2V955_W':(5.15-2.955)*.12,
          'note':'ignores ground current, copper/layout, nearby heat, enclosure; not a thermal pass'},
        'partial_5V_reference_budget': {'host_nominal_A':.32,'MD62_max_A':.12,'total_A':.44,'total_W':2.2,'scope':'Mixed reference case: host approximate nominal320mA plus MD62 specified maximum120mA. Neither guaranteed floor nor complete maximum.',
          'excluded':'CO current undocumented, button LED, ADCs, gauge, losses, startup peaks'},
        'upstream_cold_current_mA': {'published_TI_table':{'min':34,'typical':50,'max':66,'R_kohm':19.2},'selected_R_kohm':19.1,'selected_R_MPN':'RT0402BRD0719K1L','selected_typical_formula_mA':1000*1.18*19.1**(-1.072),'selected_guaranteed_min_mA':None,'selected_guaranteed_max_mA':None,'scope':'TPS22950CQDDCRQ1 published34/50/66mA table is at19.2k. The sourced19.1k E96 substitution uses the datasheet typical formula only; no new guaranteed corner is inferred. Resistor tolerance/TCR, entire board current and brief overshoot remain qualification gates.'},
        'critical_1210_cap_estimated_min_uF': {'each':22*.9*.8*.85*.9,'three_output':3*22*.9*.8*.85*.9,'PMID_required':8.2,'TPS_output_required':22,'scope':'TDK C3225X7R1C226M250AC typical bias curve with explicit engineering deratings, not a guaranteed combined minimum'},
        'I2C_4k7_rise_time': {'R_ohm':4700,'C_200pF_ns':.8473*4700*200e-12*1e9,
          'C_400pF_ns':.8473*4700*400e-12*1e9,'C_for_1000ns_pF':1e-6/(.8473*4700)*1e12,
          'note':'lumped host-side approximation; module translator/pullups/cable require waveform test'},
    }
    check('He series limiting calculation below 10 mA',calculations['helium_unpowered_input_current_mA']['conservative_after_zero_clamp_drop_mA']<10)
    check('Oxygen fullscale common mode has nominal margin', vdd/2-fsr/2>pga_margin and vdd/2+fsr/2<vdd-pga_margin)
    failed = [c for c in checks if c['status']=='fail']
    result={'status':'pass_contract_assertions_not_order_release' if not failed else 'fail',
            'checks_passed':len(checks)-len(failed),'checks_failed':len(failed),'checks':checks,
            'pin_table_scope':'Manufacturer package tables below plus topology assertions; source-controller full interface independently checked by firmware contract. Remote module physical pinouts remain measurement gates.',
            'netlist_sha256':sha(NETLIST),'calculations':calculations,
            'physical_tests_performed':False,'main_routing_complete':None,'routing_scope':'Not assessed from schematic XML; source-bound native routing/CAM audits determine completion.','order_release':False}
    (OUT/'electrical-audit.json').write_text(json.dumps(result,indent=2)+'\n')
    with (OUT/'host-interface.csv').open('w',newline='') as f:
        writer=csv.writer(f);writer.writerow(['net','J301_pin','Guition_JP1_pin','GPIO','direction','purpose','mechanical_status'])
        for net,(p,g,d,purpose) in HOST.items():writer.writerow([net,p,p,g,d,purpose,'pitch/mating view/cable unmeasured'])
    print(json.dumps({'passed':len(checks)-len(failed),'failed':failed,'calculations':calculations},indent=2))
    return 1 if failed else 0


if __name__ == '__main__':
    raise SystemExit(run())
