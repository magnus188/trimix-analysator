#!/usr/bin/env python3
"""Probe an unchanged TI PSpice model with KiCad's shared ngspice.

This tests model suitability, not the final Q1 device or physical design.
Run as a separate process; it never touches a KiCad/Fusion document.
"""
from pathlib import Path
import ctypes as C
import hashlib
import json

HERE = Path(__file__).resolve().parent
LIB = Path('/Applications/KiCad/KiCad.app/Contents/Frameworks/libngspice.0.dylib')
MODEL = HERE / 'manufacturer-model/TPS22950_TRANS.lib'


class Vector(C.Structure):
    _fields_ = [('name', C.c_char_p), ('type', C.c_int), ('flags', C.c_short),
                ('real', C.POINTER(C.c_double)), ('complex', C.c_void_p),
                ('length', C.c_int)]


def main():
    messages = []
    char_cb_type = C.CFUNCTYPE(C.c_int, C.c_char_p, C.c_int, C.c_void_p)
    exit_cb_type = C.CFUNCTYPE(C.c_int, C.c_int, C.c_bool, C.c_bool,
                             C.c_int, C.c_void_p)

    @char_cb_type
    def output(msg, _ident, _user):
        messages.append(msg.decode(errors='replace'))
        return 0

    @char_cb_type
    def status(_msg, _ident, _user):
        return 0

    @exit_cb_type
    def controlled_exit(code, immediate, quit_requested, _ident, _user):
        messages.append(f'controlled_exit {code} {immediate} {quit_requested}')
        return 0

    lib = C.CDLL(str(LIB))
    lib.ngSpice_Init.argtypes = [char_cb_type, char_cb_type, exit_cb_type,
                                C.c_void_p, C.c_void_p, C.c_void_p, C.c_void_p]
    lib.ngSpice_Command.argtypes = [C.c_char_p]
    lib.ngSpice_Circ.argtypes = [C.POINTER(C.c_char_p)]
    lib.ngGet_Vec_Info.argtypes = [C.c_char_p]
    lib.ngGet_Vec_Info.restype = C.POINTER(Vector)
    lib.ngSpice_Init(output, status, controlled_exit, None, None, None, None)
    lib.ngSpice_Command(b'version')
    lib.ngSpice_Command(b'set ngbehavior=psa')
    # Needed by PSpice POLY devices in KiCad's shared build.
    for code_model in ['spice2poly', 'analog', 'table', 'xtradev', 'xtraevt', 'digital', 'tlines']:
        lib.ngSpice_Command(('codemodel /Applications/KiCad/KiCad.app/Contents/PlugIns/sim/ngspice/'
                             + code_model + '.cm').encode())
    circuits = []
    for resistance, load_resistance in [(19200, 1), (20500, 1), (1000, 1), (20500, 1000)]:
        lines = [f'TI unchanged model probe RLIM={resistance}',
                 f'.include "{MODEL}"',
                 'VSUP vin 0 5', 'VEN en 0 PULSE(0 5 1m 1u 1u 20m 40m)',
                 'CIN vin 0 1u', 'COUT out 0 22u', f'RLOAD out 0 {load_resistance}',
                 f'RLIM ilim 0 {resistance}', 'RFAULT vin fault 10000',
                 f'XSW fault 0 ilim en vin out TPS22950_TRANS RLIM={resistance}',
                 '.save v(out) v(vin) v(en) i(VSUP)', '.tran 2u 12m', '.end']
        path = HERE / f'probe-{resistance}-load{load_resistance}.cir'
        path.write_text('\n'.join(lines) + '\n')
        data = (C.c_char_p * (len(lines) + 1))(
            *[line.encode() for line in lines], None)
        first_message = len(messages)
        load_result = lib.ngSpice_Circ(data)
        run_result = lib.ngSpice_Command(b'run')
        values = {}
        for name in ['time', 'v(out)', 'v(vin)', 'v(en)', 'i(vsup)']:
            ptr = lib.ngGet_Vec_Info(name.encode())
            if ptr and ptr.contents.real:
                vec = ptr.contents
                if 0 < vec.length < 2_000_000:
                    a = [vec.real[i] for i in range(vec.length)]
                    values[name] = {'points': len(a), 'last': a[-1],
                                    'min': min(a), 'max': max(a)}
        case_errors = [s for s in messages[first_message:] if 'error' in s.lower()]
        completed = (not case_errors and 'time' in values and
                     abs(values['time']['last'] - .012) < 1e-9)
        sanity = completed and values.get('v(out)', {}).get('last', 0) > .02
        circuits.append({'rlim_ohm': resistance, 'load_ohm': load_resistance,
                         'status': 'numerically completed' if completed else 'simulation unavailable',
                         'output_sanity_passed': sanity,
                         'errors': case_errors, 'load_result': load_result,
                         'run_result': run_result, 'values': values,
                         'log_start': first_message})
        lib.ngSpice_Command(b'destroy all')
    receipt = {'purpose': 'manufacturer-model suitability probe; not a device qualification',
               'model_url': 'https://www.ti.com/lit/zip/SLVMDI3',
               'model_sha256': hashlib.sha256(MODEL.read_bytes()).hexdigest(),
               'runner_sha256': hashlib.sha256(Path(__file__).read_bytes()).hexdigest(),
               'simulator_sha256': hashlib.sha256(LIB.read_bytes()).hexdigest(),
               'model_unchanged': True, 'physical_design_qualified': False,
               'cases': circuits}
    (HERE / 'model-probe.log').write_text('\n'.join(messages) + '\n')
    (HERE / 'model-probe.json').write_text(json.dumps(receipt, indent=2) + '\n')
    print(json.dumps(circuits, indent=2))


if __name__ == '__main__':
    main()
