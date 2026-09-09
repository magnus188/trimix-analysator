"""Build purchasing candidates and harness truth from the native netlist.

This is not a purchase/release action. No stock availability or physical test is
inferred from a valid manufacturer ordering code.
"""
from pathlib import Path
import argparse,csv,json,hashlib,re,xml.etree.ElementTree as ET
ROOT=Path(__file__).resolve().parents[3];OUT=Path(__file__).resolve().parent;SRC=OUT/'analyzer-netlist.xml'
ap=argparse.ArgumentParser();ap.add_argument('--netlist',type=Path,default=SRC);ap.add_argument('--output-dir',type=Path,default=OUT);args=ap.parse_args();SRC=args.netlist;OUT=args.output_dir;OUT.mkdir(parents=True,exist_ok=True)
x=ET.parse(SRC).getroot();rows=[];harness={'J101','J102','J902'}
for c in x.findall('./components/comp'):
 fp=c.findtext('footprint','')
 if not fp:continue
 ref=c.get('ref');pr={q.get('name'):q.text or ''for q in c.findall('./fields/field')};dnp=any(q.get('name')=='dnp'for q in c.findall('property'));feature=ref.startswith(('TP','H'))or ref in harness
 board='USB'if ref in ['J901','J902','R901','R902','U901','D901','U902']else'Main';mpn=pr.get('MPN','')
 assembly=pr.get('Assembly','user SMT/THT after factory inspection')
 if ref.startswith('U')or ref=='RN501':assembly='factory SMT preferred; exact BOM/CPL process quote pending'
 qualification='manufacturer part selected in native schematic; source/package evidence archived'
 gate='Supplier/JLC assembly quotation and final routing/assembly process acceptance'
 if feature:qualification='PCB fabricated feature or custom soldered harness; no standalone electronic component';gate='Actual wire, termination, polarity, strain relief and service access validation'if ref in harness else'Probe/tool access review'
 if ref.startswith('C'):gate+='; effective-capacitance evidence is typical-curve engineering estimate, physical stability/inrush tests pending'
 if ref.startswith('L'):gate+='; DC/saturation/thermal corners depend on measured Guition/CO load; max package envelopes included'
 if ref.startswith('J')and ref not in harness:gate+='; actual mating cable orientation, clearance and retention pending'
 if ref=='J301':gate+='; matched Samtec HTSW-113-07-L-D-007 with IDSD-13-S-04.00-G-P07 is drawing-derived, exact configured availability unconfirmed; actual Guition post/plating/harness and approved5V entry still unresolved'
 if ref=='J402':gate+='; Amphenol142138 new specified SMB jack, owned elbow gender/fit still unmeasured'
 if ref in ['U501','U702']:gate+='; TPS7A20 output capacitor effective minimum0.47uF, thermal test pending; pin4NC and obsolete bypass DNP'
 if ref=='U114':gate+='; exact TPS22950CQDDCRQ1 ONLY; industrial C/L not equivalent to Q1 50mA range'
 if dnp:qualification='DNP - do not populate';gate='Requires documented engineering authorization to populate'
 rows.append(dict(board=board,reference=ref,quantity=0 if dnp or feature else 1,source_value=c.findtext('value'),footprint=fp,proposed_manufacturer=pr.get('Manufacturer',''),proposed_order_code=mpn,assembly=assembly,qualification=qualification,primary_source=c.findtext('datasheet')or pr.get('Datasheet',''),release_blocker=gate,supplier_stock='not quoted',DNP=dnp))
rows.sort(key=lambda r:(r['board'],re.sub(r'\d+','',r['reference']),int(re.search(r'\d+',r['reference'])[0])))
with(OUT/'part-qualification.csv').open('w',newline='')as f:w=csv.DictWriter(f,fieldnames=rows[0]);w.writeheader();w.writerows(rows)
pins=[]
for net in x.findall('./nets/net'):
 for n in net.findall('node'):
  if n.get('ref').startswith(('J','TP')):pins.append(dict(reference=n.get('ref'),pin=n.get('pin'),net=net.get('name'),function=n.get('pinfunction',''),verification='native logical net export; physical mating orientation pending'))
pins.sort(key=lambda r:(r['reference'],r['pin']))
with(OUT/'connector-testpoint-pinmap.csv').open('w',newline='')as f:w=csv.DictWriter(f,fieldnames=pins[0]);w.writeheader();w.writerows(pins)
missing=[r['reference']for r in rows if r['quantity']and not r['proposed_order_code']]
receipt={'native_netlist_sha256':hashlib.sha256(SRC.read_bytes()).hexdigest(),'board_rows':len(rows),'selected_order_codes':sum(bool(r['proposed_order_code'])for r in rows),'populated_rows_without_code':missing,'stock_or_factory_quote_confirmed':False,'order_release':False,'DNP':[r['reference']for r in rows if r['DNP']],'harness_features_not_standalone_parts':sorted(harness),'note':'Exact ordinary selections are in native files. No supplier availability or measured suitability is implied. See capacitor and package receipts for qualification limits.'}
(OUT/'part-qualification.json').write_text(json.dumps(receipt,indent=2)+'\n');print(json.dumps(receipt))
