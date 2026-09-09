#!/usr/bin/env python3
"""Linear passive nodal analysis, not SPICE or an IC/sensor model.

Inputs: frozen KiCad netlist snapshot. Outputs: deterministic corner sweeps,
thermal-noise integration, plots, source bindings and numerical self checks.
Run with requirements.txt in this directory; no native design files are written.
"""
from pathlib import Path
import csv, hashlib, itertools, json, math, platform
import xml.etree.ElementTree as ET
import numpy as np
import scipy
from scipy.linalg import eigh, expm
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt

HERE = Path(__file__).resolve().parent
REPO = HERE.parents[3]
KB = 1.380649e-23
TEMP = 298.15
RS_VALUES = [0, 100, 1000, 10000, 100000, 1000000]


class Network:
    def __init__(self, size):
        self.G = np.zeros((size, size)); self.C = self.G.copy()
        self.resistors = []
        self.size = size

    def vector(self, a, b=-1):
        q = np.zeros(self.size); q[a] = 1
        if b >= 0: q[b] -= 1
        return q

    def resistor(self, label, a, b, resistance, fractions=None):
        if math.isinf(resistance): return
        q = self.vector(a, b)
        self.G += np.outer(q, q) / resistance
        self.resistors.append((label, q, resistance, fractions or {label: 1.0}))

    def capacitor(self, a, b, capacitance):
        q = self.vector(a, b); self.C += capacitance * np.outer(q, q)

    def modes(self, output):
        # Generalized symmetric eigenvectors satisfy V.T C V = I.
        lam, V = eigh(self.G, self.C)
        assert np.all(lam > 0), 'Floating/unstable network'
        return lam, V, output @ V

    def step(self, output, forcing, times):
        lam, V, a = self.modes(output)
        coeff = a * (V.T @ forcing) / lam
        return float(np.sum(coeff)), coeff @ (1 - np.exp(-np.outer(lam, times)))

    def noise(self, output, temp=TEMP):
        lam, V, a = self.modes(output)
        values = {}
        for label, q, resistance, fractions in self.resistors:
            coeff = a * (V.T @ q)
            # One-sided Norton density 4 k T / R. Its exact 0..infinity
            # integral is 2 k T/R sum(ci*cj/(lambda_i+lambda_j)).
            variance = float(2 * KB * temp / resistance * np.sum(
                np.outer(coeff, coeff) / (lam[:, None] + lam[None, :])))
            for part, fraction in fractions.items():
                values[part] = values.get(part, 0.0) + max(0.0, variance) * fraction
        expected = float(KB * temp * output @ np.linalg.solve(self.C, output))
        assert math.isclose(sum(values.values()), expected, rel_tol=2e-8), 'kT/C check'
        return values

    def psd(self, output, frequency, temp=TEMP):
        values = np.zeros(len(frequency))
        for k, f in enumerate(frequency):
            transfer = output @ np.linalg.inv(self.G + 2j * math.pi * f * self.C)
            values[k] = sum(4 * KB * temp / r * abs(transfer @ q)**2
                            for _, q, r, _ in self.resistors)
        return values


def oxygen(rs, signs=(0,)*14, cap_tolerance=.1, rt=.001, rb=.01,
           capacitance_factor=1.0, leakage=False):
    """5 nodes: selected AIN+, AIN-, shared VMID, unselected AIN+, AIN-.
    Unselected input is open, matching the approved one-installed-sensor use.
    A passive floating Thevenin cell has combined differential Rs; no ground tie.
    """
    s, bp, bn, top, bottom, cd, cp, cn, cb, bbp, bbn, bcd, bcp, bcn = signs
    r_series = 200 * (1 + rt*s)
    resistance = rs + r_series
    n = Network(5)
    n.resistor('cell_plus_series', 0, 1, resistance,
               {'R401_R402': r_series/resistance,
                'assumed_cell_resistance': rs/resistance}) if not math.isinf(rs) else None
    n.resistor('R404', 0, 2, 1e6*(1+rb*bp))
    n.resistor('R403', 1, 2, 1e6*(1+rb*bn))
    n.resistor('R409', 2, -1, 1e4*(1+rt*top))
    n.resistor('R410', 2, -1, 1e4*(1+rt*bottom))
    n.capacitor(0, 1, 1e-6*(1+cap_tolerance*cd)*capacitance_factor)
    n.capacitor(0, -1, 1e-8*(1+cap_tolerance*cp)*capacitance_factor)
    n.capacitor(1, -1, 1e-8*(1+cap_tolerance*cn)*capacitance_factor)
    n.capacitor(2, -1, 1e-6*(1+cap_tolerance*cb)*capacitance_factor)
    n.resistor('R408', 3, 2, 1e6*(1+rb*bbp))
    n.resistor('R407', 4, 2, 1e6*(1+rb*bbn))
    n.capacitor(3,4,1e-6*(1+cap_tolerance*bcd)*capacitance_factor)
    n.capacitor(3,-1,1e-8*(1+cap_tolerance*bcp)*capacitance_factor)
    n.capacitor(4,-1,1e-8*(1+cap_tolerance*bcn)*capacitance_factor)
    if leakage:
        n.resistor('assumed_C401_leakage_100Mohm',0,1,1e8)
    forcing = n.vector(0,1)/resistance if not math.isinf(rs) else np.zeros(5)
    return n, n.vector(0,1), forcing


def helium(rs, signs=(0,)*6, cap_tolerance=.1, rt=.001,
           capacitance_factor=1.0, leakage=False):
    """AIN0 = REF through RN501 Thevenin and R506; AIN1 = SENSE via R507.
    Source signal is REF-SENSE. The fixed reference is ideal in this signal
    transfer; its source resistance and thermal noise are explicitly included.
    """
    a,b,r,cd,cp,cn = signs
    r506 = 680*(1+rt*a); r507 = 680*(1+rt*b); rref = 1000*(1+rt*r)
    n = Network(2)
    n.resistor('reference_arm',0,-1,rref+r506,
        {'RN501_equivalent':rref/(rref+r506),'R506':r506/(rref+r506)})
    n.resistor('sense_arm',1,-1,rs+r507,
        {'assumed_MD62_resistance':rs/(rs+r507),'R507':r507/(rs+r507)})
    n.capacitor(0,1,1e-6*(1+cap_tolerance*cd)*capacitance_factor)
    n.capacitor(0,-1,1e-8*(1+cap_tolerance*cp)*capacitance_factor)
    n.capacitor(1,-1,1e-8*(1+cap_tolerance*cn)*capacitance_factor)
    if leakage: n.resistor('assumed_C505_leakage_100Mohm',0,1,1e8)
    return n,n.vector(0,1),-n.vector(1)/(rs+r507)


def scalar_o2(rs, rt=.001, rb=.01, caplo=.9, caphi=1.1):
    # Bounds on the symmetric differential reduction; independent input-cap
    # asymmetry is evaluated separately using the full two-input 5-node corners.
    rblo,rbhi=2e6*(1-rb),2e6*(1+rb)
    rlo,rhi=rs+200*(1-rt),rs+200*(1+rt)
    par=lambda a,b: a*b/(a+b) if not math.isinf(a) else b
    return {'gain_min':rblo/(rblo+rhi) if not math.isinf(rs) else 0,
            'gain_max':rbhi/(rbhi+rlo) if not math.isinf(rs) else 0,
            'tau_min_s':par(rlo,rblo)*1.005e-6*caplo,
            'tau_max_s':par(rhi,rbhi)*1.005e-6*caphi}


def snapshot_inputs():
    live=REPO/'hardware/system-review/electrical/analyzer-netlist.xml'
    frozen=HERE/'input-netlist.xml'
    if not frozen.exists(): frozen.write_bytes(live.read_bytes())
    xml=ET.fromstring(frozen.read_bytes())
    components={}
    for comp in xml.findall('./components/comp'):
        ref=comp.attrib['ref']
        if ref.startswith(('R4','R5','C4','C5')) or ref in ('RN501','U401','U502','U501'):
            fields={f.attrib['name']:f.text for f in comp.findall('./fields/field')}
            components[ref]={'value':comp.findtext('value'),'mpn':fields.get('MPN'),
                             'datasheet':comp.findtext('datasheet')}
    pins={(x.attrib['ref'],x.attrib['pin']):n.attrib['name']
          for n in xml.findall('./nets/net') for x in n.findall('node')}
    for a,b in [(('U401','11'),('R402','2')),(('U401','10'),('R401','2')),
                (('U401','7'),('R406','2')),(('U401','6'),('R405','2')),
                (('U502','11'),('R506','2')),(('U502','10'),('R507','2')),
                (('RN501','2'),('R506','1')),(('J501','2'),('R507','1'))]:
        assert pins[a]==pins[b],(a,b,'netlist topology mismatch')
    for ref,mpn in [('C401','C0603C105K4RACTU'),('C505','C0603C105K4RACTU'),
                    ('C402','C1608X7R1H103K080AA'),('C506','C1608X7R1H103K080AA'),
                    ('R401','RT0603BRD07100RL'),('R506','RT0603BRD07680RL'),
                    ('R403','RC0603FR-071ML'),('RN501','ACASN2001U2001P1AT')]:
        assert components[ref]['mpn']==mpn,(ref,'MPN changed; rederive model')
    return components


def analyse():
    components=snapshot_inputs()
    rows=[]; comparisons=[]; checks=[]
    times=np.array([.1,10,20])
    scenarios={'initial_tolerance':(.1,.001,.01,1.),
               # Independent initial plus TCR excursions for +/-25K from25C;
               # capacitor +/-15% is full rated X7R TCC, not a +/-25K claim.
               'initial_plus_temperature':(.1,.001625,.0125,1.15),
               'initial_plus_temperature_low_C':(.1,.001625,.0125,.85),
               'hypothetical_50pct_effective_C':(.1,.001,.01,.5)}
    for kind,make,ncorners in [('O2',oxygen,14),('He',helium,6)]:
        for rs in RS_VALUES:
            n,out,forcing=make(rs)
            gain,response=n.step(out,forcing,times)
            noise=n.noise(out)
            total=math.sqrt(sum(noise.values()))
            board=sum(v for k,v in noise.items() if not k.startswith('assumed_'))
            # Independent scipy matrix exponential validates eigen step method.
            xinf=np.linalg.solve(n.G,forcing)
            direct=out@(xinf-expm(-np.linalg.solve(n.C,n.G)*.1)@xinf)
            checks.append(abs(float(direct)-response[0]))
            if kind=='O2':
                tau=(rs+200)*2e6/(rs+200+2e6)*1.005e-6
                closed=2e6/(rs+200+2e6)*(1-math.exp(-.1/tau))
                checks.append(abs(closed-response[0]))
            # Numeric integration cross-check over 12 decades; finite-band
            # endpoints leave a small known tail, checked against exact integral.
            freq=np.logspace(-6,6,6000)
            psd=n.psd(out,freq)
            integrated=float(np.trapezoid(psd,freq))
            assert abs(integrated/sum(noise.values())-1)<.005
            comparisons.append({'channel':kind,'assumed_source_ohm':rs,
                'gain':gain,'residual_100ms_fraction':float(1-response[0]/gain),
                'all_resistors_0_to_infinity_rms_uV':total*1e6,
                'board_resistors_only_rms_uV':math.sqrt(board)*1e6,
                'all_resistors_0_to10Hz_rms_uV':math.sqrt(float(np.trapezoid(psd[freq<=10],freq[freq<=10])))*1e6,
                'variance_by_resistor_V2':noise,
                'numeric_integral_relative_error':integrated/sum(noise.values())-1})
            for scenario,(ct,rt,rb,cf) in scenarios.items():
                residual=[]; gains=[]; taus=[]; noises=[]
                for signs in itertools.product((-1,1),repeat=ncorners):
                    kwargs={'signs':signs,'cap_tolerance':ct,'rt':rt,'capacitance_factor':cf}
                    if kind=='O2': kwargs['rb']=rb
                    nn,oo,ff=make(rs,**kwargs)
                    gg,yy=nn.step(oo,ff,times)
                    residual.append(np.abs(1-yy/gg)); gains.append(gg)
                    taus.append(1/min(nn.modes(oo)[0]))
                    # Equipartition identity already independently validated
                    # per-resistor above. Avoid repeating the noise integral
                    # for everyR corner when onlyC determines its full-band sum.
                    noises.append(math.sqrt(float(KB*TEMP*oo@np.linalg.solve(nn.C,oo)))*1e6)
                r=np.array(residual)
                rows.append({'channel':kind,'assumed_source_ohm':rs,'scenario':scenario,
                    'corners':2**ncorners,'gain_min':min(gains),'gain_max':max(gains),
                    'residual_100ms_max':float(r[:,0].max()),
                    'residual_10s_max':float(r[:,1].max()),'residual_20s_max':float(r[:,2].max()),
                    'slowest_network_pole_tau_max_s':max(taus),
                    'resistor_rms_0_to_infinity_max_uV':max(noises)})
    assert max(checks)<1e-9
    with (HERE/'corner-sweep.csv').open('w') as f:
        w=csv.DictWriter(f,fieldnames=rows[0]);w.writeheader();w.writerows(rows)
    (HERE/'noise-and-nominal.json').write_text(json.dumps(comparisons,indent=2)+'\n')
    # Open/disconnected case is discharge, not a measurable1V source gain.
    open_bounds=scalar_o2(math.inf)
    open_tau=2e6*1.005e-6
    leakage=[]
    for kind,make in [('O2',oxygen),('He',helium)]:
        for rs in RS_VALUES:
            n,out,forcing=make(rs,leakage=True)
            g,_=n.step(out,forcing,[.1])
            leakage.append({'channel':kind,'assumed_source_ohm':rs,
                            'gain_with_100Mohm_differential_leakage':g})
    # Input-current sensitivities are transfer resistances. Multiplication by
    # TI typical currents is illustrative, never a worst-case IC specification.
    currents=[]
    for kind,make,ityp in [('O2',oxygen,1e-9),('He',helium,5e-9)]:
        for rs in RS_VALUES:
            n,out,forcing=make(rs)
            z=out@np.linalg.inv(n.G)
            currents.append({'channel':kind,'assumed_source_ohm':rs,
                'offset_per_1nA_into_AINplus_uV':float(z[0]*1e-3),
                'offset_per_1nA_into_AINminus_uV':float(z[1]*1e-3),
                'opposing_per_pin_typical_current_scale_uV':float((abs(z[0])+abs(z[1]))*ityp*1e6),
                'note':'Assumed independent opposing currents; TI current specs are typical only, not guaranteed bounds.'})
    result={'method':'Exact linear resistor/capacitor nodal analysis, generalized eigen step and analytical Johnson-noise integration; independently cross-checked with SciPy expm and numerical PSD integration. NOT SPICE.',
        'physical_tested':False,'ngspice_available':False,'sensor_or_IC_models_used':False,
        'temperature_noise_K':TEMP,'source_impedance_status':'All swept cell/MD62 source resistances are explicit hypothetical assumptions; none is a sensor measurement or datasheet limit.',
        'assumed_source_ohms':RS_VALUES,'corner_count_total':sum(r['corners'] for r in rows),
        'cross_checks_max_step_absolute_error':max(checks),'components':components,
        'open_O2':{'tau_nominal_s':open_tau,'initial_tolerance_symmetric_bounds':open_bounds,
            'residual_100ms':math.exp(-.1/open_tau),'residual_10s':math.exp(-10/open_tau),
            'residual_20s':math.exp(-20/open_tau),'note':'ADC leakage/switching and unmeasured sensor/cable leakage can dominate an open input.'},
        'input_current_sensitivity':currents,'conditional_cap_leakage_sweep':leakage,
        'capacitor_scope':'Initial +/-10%; full rated X7R TCC +/-15%. The initial_plus_temperature upper-envelope scenario uses max1.15*TOL. It does not specify a guaranteed minimum effectiveC under DC bias, aging, AC amplitude, humidity or process. The50% case is a labelled stress assumption.',
        'adc':{'O2_profile':1,'He_profile':2,'O2_gain':8,'He_gain':1,'He_PGA_bypass':True,
               'internal_reference_V':2.048,'data_rate_SPS':20,'preconversion_ms':100,
               'O2_full_scale_nominal_V':.256,'He_full_scale_nominal_V':2.048,
               'O2_RMS_typical_uV':.64,'He_RMS_typical_uV':5.04,
               'note':'ADC noise already includes its internal digital filter. External resistor full-band RMS is an upper comparison for this passive model; do not assume20SPS means a10Hz brick-wall filter or delivered20Hz gas frames.'},
        'unmodeled':['Sensor source impedance versus gas, temperature, frequency and age; electrochemical noise and MD62 thermal nonlinearity.',
            'ADC dynamic input loading, charge injection, offset/gain/reference drift, digital filter transfer, aliasing, coherent noise and conversion timing jitter.',
            'LDO output noise, dropout, current limit, board/cable IR drop and thermal behaviour; BQ/TPS switching ripple and actual layout coupling.',
            'PCB/surface leakage, moisture/flux, connector noise, dielectric absorption, microphonics, ESR/ESL, component aging and full DC-bias capacitance guarantee.',
            'Real cable capacitance/common-mode coupling and non-passive input transients. Both boardO2inputs and their sharedVMID are included; the unused connector is assumed open.'],
        'versions':{'python':platform.python_version(),'numpy':np.__version__,'scipy':scipy.__version__,'matplotlib':matplotlib.__version__},
        'source_files_sha256':{str(p.relative_to(REPO)):hashlib.sha256(p.read_bytes()).hexdigest() for p in [HERE/'input-netlist.xml',REPO/'main/sensors/ads122c04.cpp',REPO/'main/sensors/gas_acquisition_config.h']}}
    # Full two-channel nominal O2 model: add open B input at shared VMID.
    full,out,forcing=oxygen(10000)
    small=Network(3);small.G=full.G[:3,:3].copy();small.C=full.C[:3,:3].copy()
    small.G[2,2]-=2e-6
    _,yy=full.step(out,forcing,times)
    _,ss=small.step(out[:3],forcing[:3],times)
    result['nominal_unselected_open_channel_step_delta']=float(np.max(np.abs(yy-ss)))
    assert result['nominal_unselected_open_channel_step_delta']<1e-8
    ref_min,ref_max=2.048*.9985,2.048*1.0015
    headroom=[]
    for supply in (3.0,3.3,3.6):
        vdiff=ref_max/8
        # The 1M bias resistors can move the floating differential pair relative
        # to VMID. +/-1% -> one side may carry50.5% of the differential voltage.
        vmid_min,vmid_max=supply*.4995,supply*.5005
        pin_min,pin_max=vmid_min-vdiff*.505,vmid_max+vdiff*.505
        pga_min,pga_max=.2+vdiff*.5,supply-.2-vdiff*.5
        headroom.append({'assumed_HOST_V':supply,'O2_input_envelope_V':[pin_min,pin_max],
            'PGA_allowed_at_fullscale_V':[pga_min,pga_max],
            'minimum_voltage_margin_V':min(pin_min-pga_min,pga_max-pin_max),
            'He_max_midpoint_assumed_V':3.045,'He_bypass_upper_margin_V':supply+.1-3.045})
    result['conditional_adc_headroom']=headroom
    result['reference_only_fullscale_O2_V']=[ref_min/8,ref_max/8]
    result['minimum_HOST_for_He_passive_midpoint_up_to_3_045V']=2.945
    result['noise_budget_scope']={
        'maximum_resistor_RMS_initial_corners_25C_uV':max(float(r['resistor_rms_0_to_infinity_max_uV']) for r in rows if r['scenario']=='initial_tolerance'),
        'maximum_resistor_RMS_TCC_corners_25C_uV':max(float(r['resistor_rms_0_to_infinity_max_uV']) for r in rows if r['scenario']=='initial_plus_temperature_low_C'),
        'O2_LSB_nV':2.048/8/8388608*1e9,'He_LSB_nV':2.048/8388608*1e9,
        'He_sensitivity_for_3sigma_0_5pp_ADC_noise_alone_uV_per_pp':3*5.04/.5,
        'He_sensitivity_for_3sigma_0_125pp_ADC_noise_allocation_uV_per_pp':3*5.04/.125,
        'claim':'Required-sensitivity arithmetic only. No MD62 sensitivity or achieved gas accuracy is established.'}
    (HERE/'results.json').write_text(json.dumps(result,indent=2)+'\n')
    make_plots(rows,comparisons)
    print(json.dumps({'status':'PASS analytical self-checks','corners':result['corner_count_total'],
        'max_step_crosscheck_error':max(checks),'nominal':comparisons[:2],
        'open_O2':result['open_O2']},indent=2))


def make_plots(rows,comparisons):
    plt.rcParams.update({'font.size':10,'axes.grid':True,'grid.alpha':.2})
    fig,axs=plt.subplots(2,2,figsize=(12,8),layout='constrained')
    colors={'O2':'#1764aa','He':'#b05a19'}
    x=np.logspace(0,6,160)
    for kind,make in [('O2',oxygen),('He',helium)]:
        gains=[];res=[]
        for rs in x:
            n,o,f=make(rs); g,y=n.step(o,f,[.1]);gains.append(g);res.append(max(1e-15,abs(1-y[0]/g)))
        axs[0,0].semilogx(x,np.array(gains)*100,label=kind,color=colors[kind])
        axs[0,1].loglog(x,res,label=kind,color=colors[kind])
        for rs,style in [(0,'-'),(10000,'--'),(100000,':')]:
            n,o,f=make(rs); t=np.logspace(-4,1.5,400);g,y=n.step(o,f,t)
            axs[1,0].semilogx(t,y/g,label=f'{kind}, Rs={rs:g} ohm',color=colors[kind],ls=style)
        subset=[r for r in comparisons if r['channel']==kind]
        axs[1,1].semilogx([max(1,r['assumed_source_ohm']) for r in subset],
            [r['board_resistors_only_rms_uV'] for r in subset],label=f'{kind}: board resistors',color=colors[kind])
    axs[0,0].set(title='DC signal transfer: unknown source resistance matters',xlabel='Assumed sensor source resistance (ohm)',ylabel='DC gain (%)',ylim=(60,102))
    axs[0,1].set(title='Residual at start of integration (100 ms)',xlabel='Assumed sensor source resistance (ohm)',ylabel='Fraction of final step remaining',ylim=(1e-8,1))
    axs[0,1].axhline(1e-4,color='gray',ls=':',label='100 ppm of voltage step')
    axs[1,0].axvline(.1,color='gray',ls=':')
    axs[1,0].set(title='Nominal linear passive settling',xlabel='Time (s)',ylabel='Fraction of final value',ylim=(0,1.02))
    axs[1,1].set(title='Board resistor thermal noise, 25 C',xlabel='Assumed sensor source resistance (ohm)',ylabel='RMS at ADC inputs, 0 to infinity (uV)',ylim=(0,.075))
    for ax in axs.flat: ax.legend(fontsize=8,loc='best')
    fig.suptitle('O2 / He passive filter study — hypothetical source impedances; no hardware accuracy claim',fontsize=13)
    fig.savefig(HERE/'filter-study.png',dpi=180);fig.savefig(HERE/'filter-study.pdf');plt.close(fig)


if __name__=='__main__': analyse()
