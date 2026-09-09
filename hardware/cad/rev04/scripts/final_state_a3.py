"""Record the saved A3 cloud location and leave the assembled model visible."""
import json
import build_a3 as b
import review_a3 as r

def inspect():
    app,d=b.get();doc=app.activeDocument
    f=doc.dataFile
    report={'document':doc.name,'saved':doc.isSaved,'modified':doc.isModified,
            'file_id':f.id if f else None,'version':f.versionNumber if f else None,
            'folder':f.parentFolder.name if f else None,
            'folder_id':f.parentFolder.id if f else None,
            'units':d.unitsManager.defaultLengthUnits,
            'other_open_documents':[{'name':x.name,'modified':x.isModified} for x in app.documents if x!=doc]}
    if not f or f.parentFolder.id!=b.FOLDER_ID:raise RuntimeError('A3 is not in the expected Trimix analyzer folder')
    (b.BASE/'verification/final-fusion-state.json').write_text(json.dumps(report,indent=2)+'\n')
    print(json.dumps(report))

def save_review_state():
    app,d=b.get();r._show_assembly(d);r.camera('iso')
    if not d.exportManager.execute(d.exportManager.createFusionArchiveExportOptions(str(b.BASE/(b.NAME+'.f3d')))):
        raise RuntimeError('Could not save the final native review state')
    if not app.activeDocument.save('A3 reviewed fit concept; assembled display state and all checked geometry preserved'):
        raise RuntimeError('Final A3 cloud save failed')
    print(json.dumps({'saved_review_state':True}))
