"""Read-only preflight for the reviewed M2 proposal; intentionally no apply API."""
from pathlib import Path
import hashlib,json
from runtime import BASE,owned,configure,other_documents,report

def cnckitchen():
    configure();import audit_a3 as a
    p=BASE/'verification/cnckitchen-m2-proposal.json';data=json.loads(p.read_text())
    app,doc,d=owned();before=a._bodies(d);others=other_documents(app);g=data['document_guard'];errors=[]
    if (doc.dataFile.id,doc.dataFile.versionNumber,doc.isModified,d.timeline.count)!=(g['id'],g['version'],g['modified'],g['timeline']):errors.append('Document version/state/timeline mismatch')
    if abs(d.userParameters.itemByName('CaseWidth').value*10-g['CaseWidth_mm'])>1e-7:errors.append('CaseWidth mismatch')
    for path,digest in data['source_sha256'].items():
        q=Path(path)
        if not q.is_file()or hashlib.sha256(q.read_bytes()).hexdigest()!=digest:errors.append('Source changed '+path)
    changes=[r for group in data['parameter_groups']for r in group['changes']]
    for row in changes:
        q=d.allParameters.itemByName(row['name']);owner=getattr(q,'createdBy',None)if q else None
        if not q or q.expression!=row['expected_expression']or not owner or owner.name!=row['owner']:errors.append('Parameter guard '+row['name'])
        if q:
            proposed=d.unitsManager.evaluateExpression(row['proposed_expression'],q.unit)
            if not d.unitsManager.isValidExpression(row['proposed_expression'],q.unit):errors.append('Expression invalid '+row['name'])
    occurrences={o.fullPathName:o for o in d.rootComponent.allOccurrences}
    for row in data['replacement_occurrences']:
        o=occurrences.get(row['original_occurrence'])
        if not o:errors.append('Missing hardware '+row['original_occurrence']);continue
        attr=o.attributes.itemByName('TrimixRev04','position_expressions')
        if not attr or json.loads(attr.value)!=row['position_expressions']:errors.append('Position binding changed '+o.fullPathName)
        position=[v*10 for v in o.transform2.translation.asArray()]
        if max(abs(x-y)for x,y in zip(position,row['original_face_mm']))>1e-6:errors.append('Hardware pose changed '+o.fullPathName)
    preserved=a._bodies(d)==before and other_documents(app)==others and not doc.isModified
    report('cnckitchen-m2-proposal-preflight.json',{'status':'preflight_passed_waiting_review'if not errors and preserved else'preflight_failed','proposal_sha256':hashlib.sha256(p.read_bytes()).hexdigest(),'parameter_count':len(changes),'insert_count':len(data['replacement_occurrences']),'errors':errors,'source_preserved':preserved,'other_documents':others,'native_mutation_performed':False})
    if errors or not preserved:raise RuntimeError('Insert proposal guard failed '+repr(errors))
