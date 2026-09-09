from pathlib import Path
import sexpdata as s,copy,uuid,json,hashlib
D=Path(__file__).resolve().parent
lib=Path('/Applications/KiCad/KiCad.app/Contents/SharedSupport/footprints/Resistor_SMD.pretty/R_0402_1005Metric.kicad_mod');new=s.loads(lib.read_text());raw=s.loads((D/'synchronized-sys-source.kicad_pcb').read_text())
def tag(q):return str(q[0])if isinstance(q,list)and q else''
def sub(q,k):return next((a for a in q if tag(a)==k),None)
records=[]
for fp in raw:
 if tag(fp)!='footprint':continue
 props={q[1]:q[2]for q in fp if tag(q)=='property'};ref=props['Reference']
 if ref not in ['R116','R119','R118']:continue
 oldpads={p[1]:p for p in fp if tag(p)=='pad'};old=copy.deepcopy(fp)
 fp[1]='Resistor_SMD:R_0402_1005Metric';sub(fp,'layer')[1]='F.Cu';at=sub(fp,'at');at[3:]=[0]
 replace={'fp_line','fp_rect','fp_text','fp_arc','fp_circle','fp_poly','pad','model','descr','tags'}
 fp[:]=[x for x in fp if tag(x)not in replace]
 for q in new:
  if tag(q)not in replace:continue
  q=copy.deepcopy(q)
  if tag(q)=='pad':
   source=oldpads[q[1]]
   for k in ['net','uuid','pinfunction','pintype']:
    v=sub(source,k)
    if v:q.append(copy.deepcopy(v))
  elif tag(q).startswith('fp_'):q.append([s.Symbol('uuid'),str(uuid.uuid4())])
  fp.append(q)
 mpn={'R116':'RT0402BRD071KL','R119':'RT0402BRD0719K1L','R118':'RT0402BRD07100KL'}[ref]
 for p in fp:
  if tag(p)!='property':continue
  if p[1]=='MPN':p[2]=mpn
  if p[1]=='Datasheet':p[2]='https://yageogroup.com/content/datasheet/asset/file/pyu-rt_1-to-0-01_rohs_l'
  if ref=='R118'and p[1]=='Value':p[2]='100k / 0.1%'
  if ref=='R119'and p[1]=='Value':p[2]='19.1k / 0.1%'
 records.append(dict(ref=ref,old_package=old[1],new_package=fp[1],MPN=mpn,old_native=s.dumps(old),new_native=s.dumps(fp)))
(D/'0402-raw.kicad_pcb').write_text(s.dumps(raw)+'\n')
(D/'package-change-contract.json').write_text(json.dumps(dict(source_sha256=hashlib.sha256((D/'before.kicad_pcb').read_bytes()).hexdigest(),manufacturer_datasheet='https://yageogroup.com/content/datasheet/asset/file/pyu-rt_1-to-0-01_rohs_l',revision='YAGEO RT V17 2026-02-12',body_max_mm=[1.1,.55,.35],footprint_library_sha256=hashlib.sha256(lib.read_bytes()).hexdigest(),records=records,procurement='19.1k E96 selected with source-listed C852587; R116 C852624. Purchase, configured stock and assembler capability remain unverified. Factory reflow intended.',scope='Isolated true0402 candidate; authoritative schematic and PCB unchanged.'),indent=2)+'\n')
