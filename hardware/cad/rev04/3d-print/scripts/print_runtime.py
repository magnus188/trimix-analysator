"""Route inherited A3 helpers exclusively into the separate PrintReview package."""
from pathlib import Path
import sys, importlib, json
BASE=Path(__file__).resolve().parents[1]
NAME='Trimix_Enclosure_A3_PrintReview'

def configure():
    old=str(BASE.parent/'scripts')
    if old not in sys.path:sys.path.append(old)
    import build_a3 as b
    b.BASE=BASE;b.NAME=NAME
    for name in ('audit_a3','verification_a3','wall_fastener_checks','gas_checks_a3','review_a3','step_a3'):
        m=importlib.import_module(name)
        if hasattr(m,'OUTPUT'):m.OUTPUT=BASE/'verification'
        if hasattr(m,'BASE'):m.BASE=BASE
    return b

def owned():
    import adsk.core as core, adsk.fusion as fusion
    app=core.Application.get();d=fusion.Design.cast(app.activeProduct)
    if not d or not app.activeDocument.name.startswith(NAME):
        raise RuntimeError('PrintReview must be active; preserve A3 and other documents')
    return app,d

def save_report(name,data):
    (BASE/'verification'/name).write_text(json.dumps(data,indent=2)+'\n')
    print(json.dumps(data))

def clone():
    import adsk.core as core, adsk.fusion as fusion
    app=core.Application.get()
    if any(doc.name.startswith(NAME) for doc in app.documents):raise RuntimeError('PrintReview already open; resume it')
    source=app.activeDocument
    if not source.name.startswith('Trimix_Enclosure_A3 v') or source.isModified:raise RuntimeError('Saved baseline A3 must be active')
    folder=source.dataFile.parentFolder
    if folder.id!='urn:adsk.wipprod:fs.folder:co.JKY47Dq7TLqRq7kWq4yYEA':raise RuntimeError('Wrong cloud folder')
    opts=app.importManager.createFusionArchiveImportOptions(str(BASE.parent/'Trimix_Enclosure_A3.f3d'))
    doc=app.importManager.importToNewDocument(opts)
    if not doc:raise RuntimeError('Archive import failed')
    doc.name=NAME
    d=fusion.Design.cast(app.activeProduct)
    d.rootComponent.attributes.add('TrimixPrintReview','baseline','A3 v3; source file PJWf-3ikQfeSu62k_ozEMw')
    if not doc.saveAs(NAME,folder,'A3 print refinement; preserved source A3 v3',''):raise RuntimeError('Cloud SaveAs failed')
    save_report('baseline-copy.json',{'document':doc.name,'source_preserved':source.name,'source_modified':source.isModified,'folder':folder.name,'occurrences':d.rootComponent.allOccurrences.count,'timeline':d.timeline.count})

def inspect():
    app,d=owned()
    save_report('live-state.json',{'document':app.activeDocument.name,'modified':app.activeDocument.isModified,'occurrences':d.rootComponent.allOccurrences.count,'timeline':d.timeline.count,'components':[{'name':o.component.name,'bodies':o.component.bRepBodies.count} for o in d.rootComponent.occurrences]})
