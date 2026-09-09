"""Targeted approved SPX3819 -> TPS7A2030 upgrade without moving parts.

Run with the existing KiCad MCP Python environment (sexpdata). Old bypass
capacitors remain as DNP locations; their unused pin1 and LDO pin4 are NC.
"""
from pathlib import Path
import copy
import hashlib
import json
import sys
ROOT = Path(__file__).resolve().parents[3]
sys.path.insert(0, str(ROOT/'hardware/tools'))
from analyzer_sheet import *
from power_review_parts import LDO_ID, LDO_MPN, LDO_DS, ldo_symbol

OUT = Path(__file__).resolve().parent


def props(s): return {p[1]:p for p in children(s, 'property')}
def sym(a,ref): return next(s for s in children(a,'symbol') if props(s)['Reference'][2]==ref)
def pt(node): return tuple(round(float(x),5) for x in child(node,'at')[1:3])
def endpoints(w): return [tuple(round(float(x),5) for x in p[1:]) for p in children(child(w,'pts'),'xy')]


def detach_branch(a, point):
    """Find only wire graph from an observed pin endpoint; no component traversal."""
    points={point};wires=[]
    while True:
        more=[w for w in children(a,'wire') if w not in wires and any(p in points for p in endpoints(w))]
        if not more:break
        for w in more:points.update(endpoints(w));wires.append(w)
    labels=[n for kind in ('global_label','label','junction') for n in children(a,kind) if pt(n) in points]
    for n in wires+labels:a.remove(n)
    return points,wires,labels


def run():
    if props(sym(sx.loads((P/'Helium.kicad_sch').read_text()),'U501'))['Value'][2]==LDO_MPN:
        raise SystemExit('LDO upgrade already applied; rerun verification rather than rewriting sources.')
    paths=[P/'Helium.kicad_sch',P/'Carbon_Monoxide.kicad_sch',P/'Trimix_Analyzer.kicad_sym',P/'Trimix_Analyzer.kicad_pcb',ROOT/'hardware/tools/build_analyzer_environment.py']
    before=OUT/'before-ldo-upgrade';before.mkdir(exist_ok=True)
    for p in paths:
        target=before/p.name
        assert not target.exists(),target
        target.write_bytes(p.read_bytes())
    receipt=[]
    for filename,ref,cap in [('Helium','U501','C503'),('Carbon_Monoxide','U702','C706')]:
        path=P/(filename+'.kicad_sch');a=sx.loads(path.read_text());s=sym(a,ref);c=sym(a,cap)
        x,y=pt(s);cx,cy=pt(c);ldop=(round(x+7.62,5),y);capp=(cx,round(cy-3.81,5))
        # Capacitor library has 3.81mm pin displacement, verified against its cached definition.
        caplib=next(l for l in children(child(a,'lib_symbols'),'symbol') if l[1]==child(c,'lib_id')[1])
        cappin=next(pin for u in children(caplib,'symbol') for pin in children(u,'pin') if child(pin,'number')[1]=='1')
        assert tuple(child(cappin,'at')[1:3])==(0,3.81)
        removed=[]
        for point in (ldop,capp):
            points,wires,labels=detach_branch(a,point);removed.extend(wires+labels)
            # Never silently detach another component's wired pin in this patch.
            assert len(points)<=7,(ref,point,points)
            if not any(pt(n)==point for n in children(a,'no_connect')):
                a.append(node('no_connect',node('at',*point),node('uuid',uid())))
        child(s,'lib_id')[1]=LDO_ID
        for key,val in [('Value',LDO_MPN),('Datasheet',LDO_DS),('Description','TI low-noise 3.0V 300mA LDO; pin4 NC; ceramic output capacitor'),('Primary_datasheet',LDO_DS),('Manufacturer','Texas Instruments'),('MPN',LDO_MPN)]:
            if key in props(s):props(s)[key][2]=val
            else:s.append(node('property',key,val,node('at',x,y,0),effects(hide=True)))
        child(c,'dnp')[1]=S('yes')
        props(c)['Value'][2]='10n / DNP: obsolete bypass'
        libs=child(a,'lib_symbols');libs.append(ldo_symbol())
        used={child(s,'lib_id')[1] for s in children(a,'symbol')}
        libs[:]=[v for v in libs if tag(v)!='symbol' or v[1] in used]
        for t in children(a,'text'):
            if 'C706 bypasses the LDO reference' in t[1]:
                t[1]=t[1].replace('C706 bypasses the LDO reference. Confirm stability with chosen capacitors.','TPS7A20: ceramic-stable; C706 DNP, pin4 NC. Qualify effective C and heat.')
        save(path,a)
        receipt.append({'ref':ref,'new_mpn':LDO_MPN,'DNP':cap,'LDO_NC_coordinate':ldop,'capacitor_NC_coordinate':capp,'removed_wires_or_labels':len(removed)})
    path=P/'Trimix_Analyzer.kicad_sym';a=sx.loads(path.read_text());l=ldo_symbol();l[1]=l[1].split(':')[-1]
    assert not any(s[1]==l[1] for s in children(a,'symbol'));a.append(l);save(path,a)
    (OUT/'ldo-upgrade.json').write_text(json.dumps({'status':'schematic applied; PCB sync and fresh checks required','changes':receipt,'source':LDO_DS},indent=2)+'\n')
    print(json.dumps(receipt,indent=2))

if __name__=='__main__':run()
