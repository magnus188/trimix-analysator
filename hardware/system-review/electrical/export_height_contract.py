"""Explicit clearance bodies for CAD; never silently scale purchased models."""
from pathlib import Path
import pcbnew as p,csv,json,math,hashlib,xml.etree.ElementTree as ET,argparse
ROOT=Path(__file__).resolve().parents[3];OUT=Path(__file__).resolve().parent
ap=argparse.ArgumentParser();ap.add_argument('--board',type=Path,default=ROOT/'hardware/pcb/analyzer/Trimix_Analyzer.kicad_pcb');ap.add_argument('--netlist',type=Path,default=OUT/'analyzer-netlist.xml');ap.add_argument('--output-dir',type=Path,default=OUT);args=ap.parse_args()
path=args.board;b=p.LoadBoard(str(path));xml=ET.parse(args.netlist).getroot();comps={c.get('ref'):c for c in xml.findall('./components/comp')};OUT=args.output_dir
# Geometry from one revision and MPN/heights from another can hide a real
# enclosure clash. Refuse that mixed input before overwriting any artifact.
mismatches=[]
actual_refs={f.GetReference()for f in b.GetFootprints()if not f.GetReference().startswith(('TP','H'))}
expected_refs={ref for ref,c in comps.items()if not ref.startswith(('TP','H'))and c.findtext('footprint','')and not any(q.get('name')=='exclude_from_board'for q in c.findall('property'))}
if actual_refs!=expected_refs:mismatches.append({'field':'component population','board_only':sorted(actual_refs-expected_refs),'netlist_only':sorted(expected_refs-actual_refs)})
for f in b.GetFootprints():
 if f.GetReference().startswith(('TP','H')):continue
 c=comps.get(f.GetReference());fields={q.GetName():q.GetText()for q in f.GetFields()};props={}if c is None else{q.get('name'):q.text or ''for q in c.findall('./fields/field')}
 for key,actual,expected in [('MPN',fields.get('MPN',''),props.get('MPN','')),('Footprint',f.GetFPID().GetUniStringLibId(),''if c is None else c.findtext('footprint','')),('Value',f.GetValue(),''if c is None else c.findtext('value',''))]:
  if actual!=expected:mismatches.append({'reference':f.GetReference(),'field':key,'board':actual,'netlist':expected})
if mismatches:raise SystemExit('Height export refused: board/netlist part identity mismatch:\n'+json.dumps(mismatches,indent=2))
OUT.mkdir(parents=True,exist_ok=True)
H={'U101':1.0,'U201':1.0,'U301':.8,'U401':1.2,'U502':1.2,'U501':1.45,'U702':1.45,'U701':.6,'U703':.9,'U801':1,'U302':1.1,'U110':.4,'U111':.65,'U112':.9,'U113':1.45,'U114':1.1,'U115':1.0,'Q112':1.1,'Q101':1.1,'Q601':1.1,'Q602':1.1,'Q110':1.1,'Q111':1.1,'RN501':.6}
DIMS={'L101':(7.6,6.9,5.0),'L201':(4.3,4.3,3.1),'L701':(4.3,4.3,2.1),'U110':(1.65,1.65,.4),'U111':(2.05,2.05,.65),'U114':(3.05,3.05,1.1),'U115':(2.1,2.1,1.0),'J402':(7.2,7.2,8.2)}
rows=[]
for f in b.GetFootprints():
 ref=f.GetReference();c=comps.get(ref);props={}if c is None else{q.get('name'):q.text or ''for q in c.findall('./fields/field')};dims=[]
 if ref.startswith(('TP','H')):continue
 for g in f.GraphicalItems():
  if isinstance(g,p.PCB_SHAPE)and g.GetLayer()==(p.F_Fab if f.GetLayer()==p.F_Cu else p.B_Fab):
   q=g.GetBoundingBox();dims.append([p.ToMM(q.GetX()),p.ToMM(q.GetY()),p.ToMM(q.GetRight()),p.ToMM(q.GetBottom())])
 if not dims:raise SystemExit('Height export refused: '+ref+' has no Fab body geometry; supply an explicit clearance envelope instead of silently omitting it.')
 bb=[min(q[0]for q in dims),min(q[1]for q in dims),max(q[2]for q in dims),max(q[3]for q in dims)];cx,cy=(bb[0]+bb[2])/2,(bb[1]+bb[3])/2
 h=float(props.get('Maximum_body_height_mm')or H.get(ref,0));basis='manufacturer package/part dimension; conservative package maxima where listed'
 if props.get('Maximum_body_length_mm')and props.get('Maximum_body_width_mm'):
  l,w=float(props['Maximum_body_length_mm']),float(props['Maximum_body_width_mm']);ang=math.radians(f.GetOrientationDegrees());dx=abs(l*math.cos(ang))+abs(w*math.sin(ang));dy=abs(l*math.sin(ang))+abs(w*math.cos(ang));bb=[cx-dx/2,cy-dy/2,cx+dx/2,cy+dy/2];basis='explicit manufacturer maximum length/width/height from source-matched part fields; assembly allowance is separate'
 elif ref in DIMS:
  l,w,h=DIMS[ref];ang=math.radians(f.GetOrientationDegrees());dx=abs(l*math.cos(ang))+abs(w*math.sin(ang));dy=abs(l*math.sin(ang))+abs(w*math.cos(ang));bb=[cx-dx/2,cy-dy/2,cx+dx/2,cy+dy/2]
 elif ref.startswith('C'):
  bb=[bb[0]-.15,bb[1]-.15,bb[2]+.15,bb[3]+.15];basis+='; extra0.15mm per-side XY allowance around F.Fab'
 elif ref.startswith('R')and not ref.startswith('RN'):
  if props.get('Maximum_body_height_mm'):basis='explicit manufacturer maximum height from the source-matched native part fields'
  else:h=.6;basis='conservative resistor height allowance; exact maximum not separately supplied'
 elif ref in ['J101','J102']:
  h=6;basis='UNMEASURED soldered-wire bend/strainrelief allocation; not connector CAD or qualified clearance'
 elif ref.startswith('J'):
  h=8.95 if ref not in ['J601','J701'] else 7.3;basis='header clearance allocation; mating housing, wire bend and actual harness not included'
  if ref=='J301':basis='SamtecHTSW-113-07-L-D-007 nominal8.382mm abovePCB;8.95mm engineering clearance is NOT manufacturer maximum; mated35x5.5x12.5mm housing/withdrawal/bend allocation checked separately; post7 omitted'
 if not h:h=1.5;basis='UNVERIFIED conservative placeholder; measure/source before manufacturing'
 if ref=='J402':basis='Conservative independent-extremes derived envelope: body7.0+0.20mm; total11.5+0.40 minus minimum tail3.9-0.20 =8.2mm; nominal manufacturer drawing body7mm,height7.6mm; not a separately manufacturer-rated maximum'
 margin=0 if ref.startswith('J')else .15
 side='F.Cu'if f.GetLayer()==p.F_Cu else'B.Cu'
 zlo,zhi=(22.1,22.1+h+margin)if side=='F.Cu'else(20.5-h-margin,20.5)
 rows.append(dict(reference=ref,side=side,MPN=props.get('MPN',''),DNP=f.IsDNP(),PCB_x_mm=p.ToMM(f.GetPosition().x),PCB_y_mm=p.ToMM(f.GetPosition().y),rotation_deg=f.GetOrientationDegrees(),x_min_mm=bb[0],y_min_mm=bb[1],x_max_mm=bb[2],y_max_mm=bb[3],max_body_height_mm=h,assembly_allowance_mm=margin,clearance_height_above_FCu_mm=h+margin,Fusion_z_bottom_mm=zlo,Fusion_z_top_mm=zhi,Fusion_x_min_mm=50.4+bb[0],Fusion_x_max_mm=50.4+bb[2],Fusion_y_min_mm=120-bb[3],Fusion_y_max_mm=120-bb[1],basis=basis,XY_basis='manufacturer max where explicitly listed; otherwise current F.Fab bounding envelope',source=props.get('Datasheet',c.findtext('datasheet','')if c is not None else''),model_status='check this envelope independently of generic STEP model; no scaling of purchased CAD'))
rows.sort(key=lambda r:r['reference'])
with (OUT/'component-height-contract.csv').open('w',newline='')as f:w=csv.DictWriter(f,fieldnames=rows[0]);w.writeheader();w.writerows(rows)
(OUT/'component-height-contract.json').write_text(json.dumps({'board_sha256':hashlib.sha256(path.read_bytes()).hexdigest(),'netlist_sha256':hashlib.sha256(args.netlist.read_bytes()).hexdigest(),'part_identity_matches':True,'rows':rows,'rule':'CAD must excludeDNP, overlay stated clearance envelopes; same-model visual body is not evidence of exact height','main_transform':'X=50.4+PCB_x,Y=120-PCB_y,FCuZ22.1; boardback20.5','physical_tests':False},indent=2)+'\n')
print(len(rows),'height envelope rows')
