"""Build a source-bound, non-executable RX-M2x4 geometry proposal offline."""
from pathlib import Path
from datetime import datetime,timezone
import json,hashlib
B=Path(__file__).resolve().parents[1];V=B/'verification'
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def build():
    inv=json.loads((V/'ruthex-m2-native-inventory.json').read_text())
    ev=json.loads((V/'ruthex-m2-interface-evaluation.json').read_text())
    fl=json.loads((V/'ruthex-m2-existing-floors.json').read_text())
    old=json.loads((V/'width-contract-full-inventory.json').read_text())
    parameters={p['name']:{'name':p['name'],'expected_expression':p['expression'],'owner':p['owner']}for p in old['parameters']}
    for f in inv['features']:
        for p in f['parameters']:parameters[p['name']]={'name':p['name'],'expected_expression':p['expression'],'owner':f['name']}
    def group(label,changes,meaning):
        return {'label':label,'status':'PROPOSED_NOT_APPLIED','meaning':meaning,'changes':[dict(parameters[n],proposed_expression=e)for n,e in changes]}
    groups=[]
    for s,delta in [('left',0),('right',14)]:
        groups.append(group('USB '+s,[('d'+str(1094+delta),'3.8 mm'),('d'+str(1097+delta),'UsbZ + 0.2 mm'),('d'+str(1101+delta),'1.6 mm'),('d'+str(1102+delta),'5.1 mm')],
                            'Enlarge only the existing boss radius0.15mm; lower pilot floor0.75mm and use publishedØ3.2. Insert face/screw/PCB/port datums unchanged.'))
    for i in range(4):
        j=14*i
        groups.append(group('Chamber '+str(i+1),[('d'+str(1656+j),'CaseDepth - 14 mm'),('d'+str(1660+j),'3.8 mm'),('d'+str(1661+j),'7 mm'),('d'+str(1663+j),'CaseDepth - 12 mm'),('d'+str(1668+j),'5.1 mm')],
                            'Grow boss0.2mm radially and1mm forward; deepen blind pilot1mm, retaining a nominal2mm floor. Remains a sealed blind provision; gas route must be rerun.'))
    groups.append(group('Upper display retainer only',[('d715','11.5 mm'),('d719','3.8 mm'),('d720','7 mm'),('d722','13.5 mm'),('d726','1.6 mm'),('d727','5.1 mm')],
                        'Upper retainer alone has actual frame material available; no unrelated static overlap from the proposedboss. Retainer pose/fasteners remain unchanged.'))
    floor={q['insert']:q for q in fl['interfaces']};interfaces=[]
    for e in ev['interfaces']:
        i=next(q for q in inv['native_m2_interfaces']if q['occurrence']==e['insert'])
        interfaces.append({'insert':e['insert'],'group':e['group'],'face_mm':e['face_mm'],
          'pilot_diameter_mm':e['pilot_diameter_mm'],'blind_depth_mm':e['actual_blind_depth_mm'],
          'existing_full_pilot_floor_lower_mm':floor[e['insert']]['whole_pilot_diameter_floor_lower_bound_mm'],
          'sampled_crest_ligament_lower_mm':e['minimum_sampled_material_beyond_crest_mm'],
          'exact_candidate_other_parts_overlap':e['official_candidate_unrelated_parts_overlap'],
          'proposal_status':e['transient_proposed_boss']['status'],
          'proposal_other_parts_overlaps':e['transient_proposed_boss']['added_material_foreign_overlaps'],
          'screw_nominal_overlap_mm':e['screw_geometry']['nominal_insert_span_overlap_mm'],
          'position_expressions':i['position_expressions']})
    sources=[V/n for n in ('ruthex-m2-native-inventory.json','ruthex-m2-interface-evaluation.json','ruthex-m2-existing-floors.json')]
    sources += [B/'components/ruthex-review'/n for n in ('ruthex_RX-M2x4.step','ruthex_Datenblatt_RX-Serie.pdf','source-review.json')]
    result={'generated_at_utc':datetime.now(timezone.utc).isoformat(),'status':'REVIEW_REQUIRED_CANDIDATE_NOT_ADOPTED',
      'document_guard':{'id':inv['data_id'],'version':8,'modified':False,'timeline':1199,'CaseWidth_mm':85},
      'source_sha256':{str(p):sha(p)for p in sources},'candidate':'Ruthex RX-M2x4 / GE-M2x04-001',
      'manufacturer_mm':{'length':4,'crest_diameter':3.6,'lead_in_diameter':3.1,'pilot':3.2,'minimum_wall_from_pilot':1.3,'hole_depth_minimum':5},
      'project_selected_criterion_mm':{'material_beyond_crest':2,'blind_floor':2,'boss_diameter':7.6},
      'interfaces':interfaces,'seven_static_feasible_parameter_groups':groups,
      'blocked_interfaces':[q for q in interfaces if q['proposal_status']=='interference_blocked'],
      'recommendation':'Do not universally substitute RX-M2x4. Review a shorter manufacturer-supported insert and intentional through-pilots for the three thin-floor non-gas posts. Preserve blind sealed chamber holes. These seven possible RX geometry groups are reviewable alternatives, not an adoption instruction.',
      'explicit_interface_semantics':[
        'Printed pilot model retains pre-installation material. Exact metal intersects only its identified receiving printedbody by0.620mm³ atØ3.3 or1.149mm³ atØ3.2. This is quantified intended heat-set displacement, still physically unqualified.',
        'Exact internal threads intersect simplified unthreaded screwshafts byapproximately1.05–1.19mm³. Only an explicitly bound M2threadpair can be classed as an engaged interface; never waive other collisions.',
        'An installed visualization may retain both states with these exact pair records, or use an explicit post-install cavity while preserving separate unmodified printed pilot manufacturing geometry. Do not export the post-install cavity as the print pilot.',
        'OfficialSTEP translated at unit scale: axis+Z, openfaceZ0, extends-4mm. It is nominal CAD, with no manufacturing tolerance or retention guarantee.',
        'First inventory transient getPhysicalProperties(high) returned0volume; that value is unusable. Evaluation records positive persistent high/veryhigh and body.volume separately. No precision/production claim relies on the zero return.'
      ],
      'before_any_native_adoption':[
        'Select exact insert part/locations after root review; rebase if final PCB import changesv8.',
        'Guard every parameter expression/owner, receiving component, insert face and source digest.',
        'Preserve all purchased poses/geometry, exterior and native width datum.',
        'If replacing generic instances, retain occurrence positioning expressions/rigid joints and exactpartnumber metadata; source CAD must remain unscaled.',
        'Run actual whole-body geometry/interference with narrowly bound interface classifications, material sections, screw/depth/thickness, gasØ5 path, service/tool routes and width endpoints.',
        'Qualify actual printed coupons/material/process before heatsetting full parts; measure inserteddepth, retention and repeatedservice.'
      ],'native_geometry_changed':False,'BOM_changed':False,'production_release':False}
    p=V/'ruthex-m2-proposal.json';p.write_text(json.dumps(result,indent=2)+'\n');print(p,sha(p))
if __name__=='__main__':build()
