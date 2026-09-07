"""Save the owned Fusion design and export the complete parametric/neutral assembly."""
import importlib
import json
import sys
from datetime import datetime, timezone

def run(_context: str):
    scripts='/Users/magnustrandokken/Documents/Projects/Trimix/trimix-analysator/hardware/enclosure/scripts'
    if scripts not in sys.path:
        sys.path.insert(0,scripts)
    import build_enclosure as b
    importlib.reload(b)
    app,d=b.app_design()
    doc=app.activeDocument
    if doc.dataFile.parentFolder.id!=b.FOLDER_ID:
        raise RuntimeError('Active enclosure is not in the authorized Trimix analyzer folder')
    for o in d.rootComponent.occurrences:
        o.isLightBulbOn=True
    for analysis in d.analyses.sectionAnalyses:
        analysis.isLightBulbOn=False
    b.set_camera('iso')
    d.rootComponent.attributes.add(b.GROUP,'stage','Revision 02 concept delivered / measurements and seals pending')
    if not d.computeAll():
        raise RuntimeError('Fusion recompute failed before export')
    paths={}
    for suffix,create_options in (('f3d',d.exportManager.createFusionArchiveExportOptions),
                                  ('step',d.exportManager.createSTEPExportOptions)):
        path=b.BASE/(b.NAME+'.'+suffix)
        if not d.exportManager.execute(create_options(str(path))):
            raise RuntimeError('Fusion export failed: '+suffix)
        if not path.is_file() or path.stat().st_size<1000:
            raise RuntimeError('Export is unexpectedly missing or empty: '+str(path))
        paths[suffix]={'path':str(path),'bytes':path.stat().st_size}
    if not doc.save('Revision 02 editable enclosure concept; reviewed geometry, provisional physical fit and gas seals.'):
        raise RuntimeError('Fusion cloud save failed')
    report={'saved_at_utc':datetime.now(timezone.utc).isoformat(),
            'name':doc.name,'folder':doc.dataFile.parentFolder.name,
            'folder_id':doc.dataFile.parentFolder.id,'file_id':doc.dataFile.id,
            'version':doc.dataFile.versionNumber,'cloud_processing_complete':doc.dataFile.isComplete,
            'is_modified':doc.isModified,'exports':paths,
            'open_documents':[{'name':document.name,'modified':document.isModified} for document in app.documents]}
    (b.BASE/'verification'/'delivery.json').write_text(json.dumps(report,indent=2)+'\n')
    print(json.dumps(report))
