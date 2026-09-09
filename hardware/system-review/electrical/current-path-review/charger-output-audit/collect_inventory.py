from pathlib import Path
import hashlib,json,xml.etree.ElementTree as ET,sexpdata,sys
D=Path(__file__).resolve().parent;ROOT=Path(__file__).resolve().parents[5]
sys.path.insert(0,str(D.parents[1]/'main-final-independent'));from cam_geometry import Native,subs,sub
sources={'netlist.xml':ROOT/'hardware/system-review/electrical/analyzer-netlist.xml','authoritative.kicad_pcb':ROOT/'hardware/pcb/analyzer/Trimix_Analyzer.kicad_pcb','routing-snapshot.kicad_pcb':ROOT/'hardware/system-review/electrical/routing-candidate/native/Trimix_Analyzer.kicad_pcb'}
manifest={}
for name,file in sources.items():
 data=file.read_bytes();dest=D/'source'/name
 if dest.exists():assert dest.read_bytes()==data,'Snapshot already exists and current source changed; retain old snapshot.'
 else:dest.write_bytes(data)
 manifest[name]={'source':str(file.relative_to(ROOT)),'sha256':hashlib.sha256(data).hexdigest(),'source_same_after_copy':hashlib.sha256(file.read_bytes()).hexdigest()==hashlib.sha256(data).hexdigest()}
r=ET.parse(D/'source/netlist.xml').getroot();nets={}
for n in r.find('nets'):
 for p in n.findall('node'):nets[(p.get('ref'),p.get('pin'))]=n.get('name')
comps={c.get('ref'):c for c in r.find('components')};caps=[]
for ref,c in comps.items():
 if ref.startswith('C')and set(nets.get((ref,p))for p in ['1','2'])=={'VSYS','GND'}:
  caps.append(dict(ref=ref,value=c.findtext('value'),footprint=c.findtext('footprint'),fields={v.get('name'):v.text for v in c.find('fields')},pins={p:nets.get((ref,p))for p in ['1','2']}))
l=comps['L101'];inductor=dict(ref='L101',value=l.findtext('value'),fields={v.get('name'):v.text for v in l.find('fields')},pins={p:nets.get(('L101',p))for p in ['1','2']})
boards={}
for name in ['authoritative.kicad_pcb','routing-snapshot.kicad_pcb']:
 n=Native(sexpdata.loads((D/'source'/name).read_text()));wanted=['U101','L101']+[c['ref']for c in caps]
 rows={ref:{'component':next(f for f in n.fps if f['ref']==ref),'pads':[{k:q[k]for k in ['pin','net','x','y','layers']}for q in n.pads if q['ref']==ref]}for ref in wanted}
 # Native parser reports Y inverted for Gerber analysis; expose original Y here.
 for row in rows.values():
  row['component']['y']*=-1
  for q in row['pads']:q['y']*=-1
 boards[name]=rows
out={'source_manifest':manifest,'netlist_VSYS_capacitor_inventory':caps,'netlist_L101':inductor,'boards':boards,'notes':['Snapshots are for part/net/placement inventory; no claim every same-net item is physically connected.','C102 is PMID input capacitance and is excluded from VSYS total.','VSYS total does not establish local BQ output-loop adequacy.']}
(D/'inventory.json').write_text(json.dumps(out,indent=2)+'\n');print(json.dumps({'manifest':manifest,'capacitors':[(c['ref'],c['fields'].get('MPN'))for c in caps],'inductor':inductor,'routing_positions':{r:boards['routing-snapshot.kicad_pcb'][r]['component']for r in ['U101','L101','C104','C105','C201','C202']}},indent=2))
