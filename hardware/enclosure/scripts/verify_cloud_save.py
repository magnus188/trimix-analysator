import importlib
import sys
import json
from datetime import datetime, timezone

def run(_context: str):
    scripts='/Users/magnustrandokken/Documents/Projects/Trimix/trimix-analysator/hardware/enclosure/scripts'
    if scripts not in sys.path:
        sys.path.insert(0,scripts)
    import build_enclosure as b
    importlib.reload(b)
    app,d=b.app_design()
    doc=app.activeDocument
    report={'verified_at_utc':datetime.now(timezone.utc).isoformat(),
            'name':doc.name,'folder':doc.dataFile.parentFolder.name,
            'folder_id':doc.dataFile.parentFolder.id,'file_id':doc.dataFile.id,
            'version':doc.dataFile.versionNumber,'cloud_processing_complete':doc.dataFile.isComplete,
            'is_modified':doc.isModified,'component_occurrences':d.rootComponent.occurrences.count,
            'open_documents':[{'name':document.name,'modified':document.isModified} for document in app.documents]}
    (b.BASE/'verification'/'cloud-save.json').write_text(json.dumps(report,indent=2)+'\n')
    print(json.dumps(report))
