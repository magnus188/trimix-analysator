"""Generate source-bound assembly ledgers; never changes native population flags.

The all-reference map has quantity one per physical board feature. Purchasing
quantities are in a separate file, so a test pad or DNP is never an order item.
"""
from pathlib import Path
import argparse, csv, hashlib, json, re, sys
HERE = Path(__file__).resolve().parent
sys.path[:0] = [str(HERE / 'main-final-independent'), str(HERE.parents[1] / 'tools')]
from analyzer_sheet import sx, child, children
from cam_geometry import Native

ap = argparse.ArgumentParser(); ap.add_argument('--board', type=Path, required=True)
ap.add_argument('--cpl', type=Path, required=True); ap.add_argument('--out', type=Path, required=True)
a = ap.parse_args(); a.out.mkdir(parents=True, exist_ok=True)
raw = sx.loads(a.board.read_text()); n = Native(raw)
cpl = list(csv.DictReader(a.cpl.open())); cpl_by = {r['Ref']: r for r in cpl}
assert len(cpl_by) == len(cpl)
factory_special = {'R101', 'R115', 'R118', 'R119', 'C116', 'Q110'}
features = {f['ref'] for f in n.fps if f['ref'].startswith(('TP', 'H'))} | {'J101', 'J102'}
groups = {k: [] for k in ['factory', 'manual', 'DNP', 'PCB feature']}
rows = []
for f in sorted(n.fps, key=lambda f: (re.sub(r'\d+', '', f['ref']), int(re.search(r'\d+', f['ref'])[0]))):
    ref = f['ref']; p = f['props']; dnp = 'dnp' in f['attributes']
    category = 'DNP' if dnp else 'PCB feature' if ref in features else 'factory' if ref.startswith(('U', 'RN')) or ref in factory_special else 'manual'
    if category in ['factory', 'manual']: assert p.get('MPN'), (ref, 'missing purchased part identity')
    note = p.get('Assembly', '')
    if category == 'factory': note += '; quoted factory SMT placement/reflow and joint inspection required'
    if category == 'manual': note += '; manual assembly after factory inspection, using iron/hot air and microscope'
    if category == 'DNP': note += '; omit component and paste; no population without revised engineering authorization'
    if ref == 'J104': note += '; fit header only, keep charging-arm shunt OPEN'
    if ref == 'J301': note += '; keyed exact configuration is drawing-derived; availability and remote host power-entry qualification remain holds'
    if ref in ['J101', 'J102']: note += '; custom harness solder termination; no standalone board connector; actual wire fit/strain relief pending'
    r = {'Reference': ref, 'Value': f['value'], 'Manufacturer': p.get('Manufacturer', ''), 'MPN': p.get('MPN', ''), 'Quantity': 1,
         'Population_quantity': 0 if category in ['DNP', 'PCB feature'] else 1, 'Category': category,
         'Footprint': f['package'], 'Side': f['side'], 'PCB_X_mm': f['x'], 'PCB_Y_mm': -f['y'], 'Rotation_deg': f['rotation'],
         'Assembly_note': note.strip('; '), 'Native_exclude_from_BOM': 'exclude_from_bom' in f['attributes'],
         'Native_exclude_from_CPL': 'exclude_from_pos_files' in f['attributes']}
    rows.append(r); groups[category].append(r)
def write(name, rs, fields=None):
    with (a.out/name).open('w', newline='') as h:
        w = csv.DictWriter(h, fieldnames=fields or list(rows[0])); w.writeheader(); w.writerows(rs)
write('assembly-reference-map.csv', rows)
write('purchasing-bom.csv', [r for r in rows if r['Population_quantity']])
for k, rs in groups.items(): write({'factory':'factory-bom.csv','manual':'manual-bom.csv','DNP':'dnp-list.csv','PCB feature':'pcb-features.csv'}[k], rs)
factory_refs = {r['Reference'] for r in groups['factory']}
assert factory_refs <= set(cpl_by)
write('placement-factory.csv', [r for r in cpl if r['Ref'] in factory_refs], list(cpl[0]))
texts = []
for fp in children(raw, 'footprint'):
    pr = {q[1]: q[2] for q in children(fp, 'property')}; ref = pr['Reference']
    for t in children(fp, 'property') + children(fp, 'fp_text'):
        if child(t, 'layer') is None or child(t, 'layer')[1] not in ['F.SilkS','B.SilkS']: continue
        if any(str(q) == 'hide' for q in t) or child(t, 'hide') is not None or (child(t,'effects') and any(str(q)=='hide' for q in child(t,'effects'))): continue
        label = t[2]
        if label in [ref, '${REFERENCE}', '%R']: texts.append({'reference':ref,'layer':child(t,'layer')[1],'method':'native visible footprint text'})
for t in children(raw, 'gr_text'):
    if child(t,'layer')[1] in ['F.SilkS','B.SilkS'] and t[1] in {r['Reference'] for r in rows}:
        texts.append({'reference':t[1],'layer':child(t,'layer')[1],'method':'native independent board text'})
visible = {t['reference'] for t in texts}
markings = [{'Reference':r['Reference'],'Printed_reference':r['Reference'] in visible,'Printed_layers':','.join(sorted({t['layer'] for t in texts if t['reference']==r['Reference']})), 'Available_in':'silkscreen and assembly map' if r['Reference'] in visible else 'assembly reference map / native Fab view','Value':r['Value'],'MPN':r['MPN']} for r in rows]
write('marking-legend.csv', markings, list(markings[0]))
receipt = {'board_sha256':hashlib.sha256(a.board.read_bytes()).hexdigest(),'all_cpl_sha256':hashlib.sha256(a.cpl.read_bytes()).hexdigest(),
           'reference_count':len(rows),'category_counts':{k:len(v) for k,v in groups.items()},'visible_reference_count':len(visible),
           'factory_refs':sorted(factory_refs),'visible_reference_evidence':texts,
           'stencil_warning':'CAM full-board paste is diagnostic native output and includes manual/DNP apertures. Factory must build a subset stencil from the factory placement list, omitting all manual/DNP apertures, and obtain assembler approval. It is not an approved stencil order.',
           'order_release':False}
(a.out/'assembly-ledger-receipt.json').write_text(json.dumps(receipt,indent=2)+'\n')
print(json.dumps({k:receipt[k] for k in ['reference_count','category_counts','visible_reference_count']},indent=2))
