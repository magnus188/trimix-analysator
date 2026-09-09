"""Reviewed replacement parts with manufacturer pin ordering.

Display geometry of the small LDO symbol is retained to avoid disturbing the
existing framed sheets; this is a distinct part with an electrically NC pin4.
"""
import copy
from analyzer_sheet import library_symbol, child, children, S

LDO_ID = 'Trimix_Analyzer:TPS7A2030P_DBV'
LDO_MPN = 'TPS7A2030PDBVR'
LDO_DS = 'https://www.ti.com/lit/ds/symlink/tps7a20.pdf'


def ldo_symbol():
    a = library_symbol('Regulator_Linear:SPX3819M5-L-3-0')
    old = a[1].split(':')[-1]
    a[1] = LDO_ID
    for unit in children(a, 'symbol'):
        unit[1] = LDO_ID.split(':')[-1] + unit[1][len(old):]
        for pin in children(unit, 'pin'):
            if child(pin, 'number')[1] == '4':
                child(pin, 'name')[1] = 'NC'
                pin[1] = S('no_connect')
    for p in children(a, 'property'):
        if p[1] == 'Value': p[2] = LDO_MPN
        if p[1] == 'Datasheet': p[2] = LDO_DS
        if p[1] == 'Footprint': p[2] = 'Package_TO_SOT_SMD:SOT-23-5'
        if p[1] == 'Description': p[2] = 'TI low-noise 3.0V 300mA LDO; DBV:1 IN,2 GND,3 EN,4 NC,5 OUT; ceramic stable'
    return a
