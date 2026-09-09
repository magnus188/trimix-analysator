"""Offline source-bound TC-M2x3.0 proposal generator; never changes CAD."""
from pathlib import Path
from datetime import datetime,timezone
import hashlib,json
B=Path(__file__).resolve().parents[1];V=B/'verification'
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def build():
    inv=json.loads((V/'ruthex-m2-native-inventory.json').read_text());old=json.loads((V/'width-contract-full-inventory.json').read_text())
    params={p['name']:{'name':p['name'],'expected_expression':p['expression'],'owner':p['owner']}for p in old['parameters']}
    for f in inv['features']:
        for p in f['parameters']:params[p['name']]={'name':p['name'],'expected_expression':p['expression'],'owner':f['name']}
    plans=[
      ('Two PCB support webs',[('d543','(PcbX + 25.6 mm) - 3.8 mm'),('d544','28 mm - 3.8 mm'),('d545','CaseWidth - Wall + 0.1 mm - ((PcbX + 25.6 mm) - 3.8 mm)'),('d546','7.6 mm'),('d559','114 mm - 3.8 mm'),('d560','PcbX + 8.2 mm - (HolderX + HolderWidth + 0.8 mm)'),('d561','7.6 mm')]),
      ('Three intentional through-pilots only',[(n,e)for a in [(549,553,554),(564,568,569),(708,712,713)]for n,e in [(f'd{a[0]}','14.2 mm'),(f'd{a[1]}','1.6 mm'),(f'd{a[2]}','4.4 mm')]]),
      ('Both display boss radii and upper blind pilot',[('d705','3.8 mm'),('d719','3.8 mm'),('d726','1.6 mm')]),
      ('Both USB boss radii and retained blind pilots',[('d1094','3.8 mm'),('d1108','3.8 mm'),('d1101','1.6 mm'),('d1115','1.6 mm')]),
      ('Four chamber boss radii; blind depths and sealed floors retained',[(f'd{1660+14*i}','3.8 mm')for i in range(4)])]
    groups=[{'label':label,'changes':[dict(params[n],proposed_expression=e)for n,e in items]}for label,items in plans]
    rows=[]
    for r in inv['native_m2_interfaces']:
        z=r['face_mm'][2];x,y,_=r['face_mm'];s=r['screws'][0]
        through=abs(z-18.5)<1e-6 and not(y>120)
        rows.append({'original_occurrence':r['occurrence'],'original_definition':r['definition'],'original_face_mm':r['face_mm'],
           'position_expressions':r['position_expressions'],'axis':[0,0,1],'candidate_part':'TC-M2x3.0',
           'manufacturer_source_model_translation_from_insert_face_mm':[0,0,-3],
           'pilot_type':'through_non_gas'if through else'blind_retained','paired_screw':s['name'],'paired_screw_definition':s['definition'],
           'candidate_external_geometry_scaled':False,'internal_thread_geometry_role':'visual_reference_not_M2_engagement_evidence'})
    sources=[V/n for n in ('ruthex-m2-native-inventory.json','ruthex-m2-existing-floors.json','cnckitchen-m2-model-inspection.json','cnckitchen-m2-proposal-evaluation.json')]
    sources += [B/'components/cnckitchen-m2-review'/n for n in ('TC-M2x3.0_manufacturer.step','CNCKitchen_Heat-Set-Insert-Dimensions-and-Design-Guidelines.pdf','source-review.json')]
    ev=json.loads((V/'cnckitchen-m2-proposal-evaluation.json').read_text())
    data={'generated_at_utc':datetime.now(timezone.utc).isoformat(),'status':'PREPARED_FOR_REVIEW_NOT_ADOPTED',
      'document_guard':{'id':inv['data_id'],'version':8,'modified':False,'timeline':1199,'CaseWidth_mm':85},
      'candidate':{'manufacturer':'CNC Kitchen / TwoChefs GmbH','part_number':'TC-M2x3.0','EAN':'4262391010013','quantity':10,
         'length_mm':3,'crest_diameter_mm':3.6,'pilot_mm':3.2,'minimum_through_support_length_mm':3,'minimum_blind_depth_mm':4},
      'parameter_groups':groups,'parameter_change_count':sum(len(g['changes'])for g in groups),'replacement_occurrences':rows,
      'source_sha256':{str(p):sha(p)for p in sources},'transient_evaluation_status':ev['status'],
      'preserved_datums':['All insert open faces, screw seats and axes','Main and USB board registrations and purchased part dimensions','Display casing and its front removal direction','Housing exterior85×180×43','Native right-edge datum and all rigid hardware joints'],
      'interface_semantics':[
        'Only two PCB posts and lower display retainer change to intentional through-pilots; the existing0.1mm membrane is removed. Support length4.2mm exceeds published3mm through-hole guidance. Purchased display/electronics must be removed for installation.',
        'The other seven pilots stay blind at their current4.00–4.25mm depth, with native measured floor≥2mm. All gas-chamber holes remain blind; no new gas-to-electronics leakage path is proposed.',
        'Printed pilots retain manufacturer pre-installation geometry. The exact assigned insert-to-host pair overlap is a quantified intended heat-set interface, never a global interference exception.',
        'Exact manufacturerSTEP external geometry is used without scaling. Its Ø2.0755 internal bore does not establish a faithful M2thread, so mark internal thread visual/reference only. Do not silently remodel or shrink purchasedCAD.',
        'Nominal axial screw allocation and source0.2mm end-chamfers are measured separately. Actual usablethread, matingclass, torque, retention and printprocess remain physical gates.',
        'The four M3 insert references are outside this candidate proposal and remain unqualified.'
      ],
      'required_after_review_before_save':['Recheck current source/parameter expressions and rebase after any final PCB import.','Apply only named parameter changes and replace only ten exact M2 instances while retaining position-expression bindings/rigid axes.','Compare all other purchased bodies/poses and exterior; require healthy features and constrained sketches.','Repeat actual static interference with exact per-instance heat-set classification, gas5mm probes, blind/through material sections, screw tip at1.44/1.60/1.76,14drivers and service paths.','Test width85and87 plus restoration using the staged upper-retainer removal route; use final populated PCB maximum-height contracts.','Save a new owned native version only after review and checks; preservev8 and all FlowGrid documents.'],
      'native_geometry_changed':False,'BOM_changed':False,'coupon_or_strength_qualification':False}
    p=V/'cnckitchen-m2-proposal.json';p.write_text(json.dumps(data,indent=2)+'\n');print(str(p),sha(p))
if __name__=='__main__':build()
