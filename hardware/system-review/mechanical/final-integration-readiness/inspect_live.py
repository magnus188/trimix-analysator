import adsk.core as core
import adsk.fusion as fusion
import json
from pathlib import Path
from datetime import datetime,timezone
def run(_context:str):
    app=core.Application.get()
    rows=[]
    for doc in app.documents:
        d=fusion.Design.cast(doc.products.itemByProductType('DesignProductType'))
        rows.append({'name':doc.name,'id':doc.dataFile.id if doc.dataFile else None,'version':doc.dataFile.versionNumber if doc.dataFile else None,'modified':doc.isModified,'saved':doc.isSaved,'active':doc==app.activeDocument,'timeline':d.timeline.count if d else None})
    result={'generated_at_utc':datetime.now(timezone.utc).isoformat(),'documents':rows,'inspection_only':True,'document_activation_or_mutation':False}
    path=Path('/Users/magnustrandokken/Documents/Projects/Trimix/trimix-analysator/hardware/system-review/mechanical/final-integration-readiness/live-documents.json')
    path.write_text(json.dumps(result,indent=2)+'\n')
    print(json.dumps(result))
