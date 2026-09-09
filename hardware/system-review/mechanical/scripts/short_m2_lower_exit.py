"""Read-only diagnosis of lower PCB pilot exit; no changes."""
import json
import adsk.core as core
from runtime import BASE,owned,configure,other_documents,bounds

def inspect():
 configure()
 import review_checks as r
 import ruthex_m2_audit as rx
 import audit_a3 as a
 from short_m2_validation import write,ROOT
 app,doc,d=owned();before=a._bodies(d);others=other_documents(app)
 m,rows=r.records();host=next(q for q in rows if q['component']=='01 Shape A housing');x=d.userParameters.itemByName('PcbX').value*10+25.6;y=28
 samples=[]
 for z in (14.275,14.225,14.199,14.175,14.125,14.075,13.975,13.5,13,12,10,5,1):
  p=rx._cylinder(m,x,y,z-.005,z+.005,1.59);hits=rx._intersections(m,p,[host]); inside=[]
  for dx in (-1.58,-1.4,-1,-.5,0,.5,1,1.4,1.58):
   for dy in (-1,-.5,0,.5,1):
    if dx*dx+dy*dy>1.59**2:continue
    s=host['body'].pointContainment(core.Point3D.create((x+dx)/10,(y+dy)/10,z/10))
    if 'Inside' in str(s)or'OnPoint' in str(s):inside.append([round(x+dx,3),round(y+dy,3),z])
  samples.append({'z_mm':z,'intersection_mm3':sum(h['volume_mm3']for h in hits),'full_disk_mm3':p.volume*1000,'inside_samples':inside})
 result={'centre':[x,y],'samples':samples,'parameters':{n:d.allParameters.itemByName(n).expression for n in ('d543','d544','d545','d546','d547','d549','d553','d554')},'source_preserved':before==a._bodies(d)and others==other_documents(app)}
 write(ROOT,'lower-pilot-exit-diagnosis.json',result)
 if not result['source_preserved']:raise RuntimeError('Source changed')
 print(json.dumps(result))

def disposition():
 """Explicit source-bound partially-open exit, preserving failed full-through test."""
 configure()
 import adsk.fusion as fusion
 import review_checks as r
 import ruthex_m2_audit as rx
 import audit_a3 as a
 from short_m2_validation import write,ROOT
 app,doc,d=owned();before=a._bodies(d);others=other_documents(app)
 m,rows=r.records();host=next(q for q in rows if q['component']=='01 Shape A housing');x=d.userParameters.itemByName('PcbX').value*10+25.6;y=28;face=18.5
 tests=[]
 for name,radius,z0,z1 in [('full_pilot_clear_depth',1.6,14.201,18.499),('full_pilot_peripheral_remainder',1.6,14.15,14.19),('source_lead_diameter_exit',1.55,14.15,14.19),('nominal_M2_shaft_exit',1,14.15,14.19)]:
  p=rx._cylinder(m,x,y,z0,z1,radius)
  if not m.booleanOperation(p,host['body'],fusion.BooleanTypes.IntersectionBooleanType):raise RuntimeError('Exit intersection failed')
  tests.append({'name':name,'diameter_mm':2*radius,'Z_mm':[z0,z1],'volume_mm3':p.volume*1000,'remainder_bounds_mm':bounds(p)if p.volume*1000>1e-7 else None})
 first=tests[0];cap=tests[1]
 data={'status':'accepted_geometric_partly_open_pilot'if first['volume_mm3']<1e-6 and all(q['volume_mm3']<1e-6 for q in tests[2:])else'needs_review',
 'approval_basis':'Root authorizes retaining the relieved non-gas pilot if full circular depth≥4mm, crest material and shaft/lead clearances pass; no exterior cut or false full-through claim.',
 'lower_PCB_insert_face_mm':[x,y,face],'full_unobstructed_circular_depth_lower_bound_mm':face-14.201,'source_pilot_end_plane_mm':14.2,'manufacturer_minimum_blind_depth_mm':4,
 'exit_classification':'Partly open relieved pilot; tiny peripheral crescent of adjacent front-opening wall remains belowZ14.2. Neither fully enclosed blindfloor nor100%openØ3.2exit is claimed.',
 'tests':tests,'peripheral_section_area_mm2':cap['volume_mm3']/.04,'total_pilot_section_area_mm2':3.141592653589793*1.6**2,
 'lead_basis':'Exact manufacturer source lead conical face boundsØ3.1 atsourceZ0..0.1; sample at exit demonstrates nominalclearance only; inserted lead endsatZ15.5 aboveexit.',
 'failed_stricter_control_retained':str(ROOT/'baseline/actual-M2-material.json'),'geometry_changed':False,'physical_retention_qualified':False,
 'source_preserved':before==a._bodies(d)and others==other_documents(app)}
 data['pass']=data['status']=='accepted_geometric_partly_open_pilot'and data['source_preserved']
 write(ROOT,'lower-pilot-exit-disposition.json',data);print(json.dumps(data))
 if not data['pass']:raise RuntimeError('Partiallyopenpilot disposition failed')

def classify():
 """Correct only the exit description after the measured/root-approved result."""
 import hashlib
 from runtime import GROUP
 from short_m2_validation import ROOT,write,interfaces
 from width_contract_proposal import _snapshots,compare_physical
 p=ROOT/'lower-pilot-exit-disposition.json';digest=hashlib.sha256(p.read_bytes()).hexdigest()
 if digest!='7976cded17aca71f3398440c3855cbb396e2de42b7ffbe696d6078bd00953b54':raise RuntimeError('Approved exit receipt changed')
 app,doc,d=owned();configure();manager,before=_snapshots();protected=other_documents(app);timeline=d.timeline.count
 data=json.loads(p.read_text())
 if not data['pass']:raise RuntimeError('Measured exit failed')
 rows=interfaces();selected=[q for q in rows if q['face_mm']==[76.0,28.0,18.5]]
 if len(selected)!=1:
  selected=[q for q in rows if max(abs(a-b)for a,b in zip(q['face_mm'],[76,28,18.5]))<1e-6]
 if len(selected)!=1:raise RuntimeError('Lower PCB exact interface not found')
 selected[0]['pilot_type']='partly_open_non_gas';selected[0]['exit_disposition_sha256']=digest
 d.rootComponent.attributes.add(GROUP,'short_m2_interfaces',json.dumps(rows))
 d.rootComponent.attributes.add(GROUP,'short_m2_exit_disposition_sha256',digest)
 component=next(o.component for o in d.rootComponent.occurrences if o.component.name=='M2 insert — CNC Kitchen TC-M2x3.0')
 component.attributes.add('TrimixRev04','installation_limits','Two non-gas through-pilots, one partly-open relieved non-gas lower-PCB pilot with4.299mm clear full-diameter depth, seven sealed/blindpilots. Electronics/display removed for heatsetting. Actual retention/torque/pullout and usable thread physically pending.')
 _,after=_snapshots();same=compare_physical(before,after,manager)
 result={'status':'measured_exit_metadata_classified','exit_disposition_sha256':digest,'geometry_unchanged':same,'timeline_unchanged':timeline==d.timeline.count,'protected_documents_preserved':protected==other_documents(app),'native_saved':False}
 write(ROOT,'exit-metadata-classification.json',result)
 if not same['pass']or not result['timeline_unchanged']or not result['protected_documents_preserved']:raise RuntimeError('Exit metadata altered source geometry/state')
 print(json.dumps({k:v for k,v in result.items()if k!='geometry_unchanged'}))
