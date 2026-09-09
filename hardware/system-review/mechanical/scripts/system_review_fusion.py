"""Separate system-review copy. Does not alter other open Fusion documents."""
from pathlib import Path
import hashlib,json
import adsk.core as core
import adsk.fusion as fusion
BASE=Path(__file__).resolve().parents[1]
ROOT=BASE.parents[2]
NAME='Trimix_Enclosure_A3_SystemReview'
FOLDER='urn:adsk.wipprod:fs.folder:co.JKY47Dq7TLqRq7kWq4yYEA'

def report(name,data):
    (BASE/name).write_text(json.dumps(data,indent=2)+'\n')
    print(json.dumps(data))

def clone():
    app=core.Application.get()
    if any(d.name.startswith(NAME) for d in app.documents): raise RuntimeError('Review already open; inspect/resume it')
    source=ROOT/'hardware/pcb/integration/exports/Trimix_Enclosure_A3_PCBFit.f3d'
    expected='971ea5b68066e22f1ae21e56e033e6166053ed6532dab78bbd0c3a5edd7f164e'
    actual=hashlib.sha256(source.read_bytes()).hexdigest()
    if actual!=expected: raise RuntimeError('Baseline archive hash changed; inspect before cloning')
    folder=app.data.findFolderById(FOLDER)
    if not folder or folder.name!='Trimix analyzer': raise RuntimeError('Expected Trimix analyzer folder')
    before=[{'name':d.name,'modified':d.isModified} for d in app.documents]
    options=app.importManager.createFusionArchiveImportOptions(str(source))
    document=app.importManager.importToNewDocument(options)
    if not document: raise RuntimeError('Could not import baseline')
    design=fusion.Design.cast(document.products.itemByProductType('DesignProductType'))
    if not design: raise RuntimeError('No design in baseline')
    document.name=NAME
    design.rootComponent.attributes.add('TrimixSystemReview','source_sha256',actual)
    design.rootComponent.attributes.add('TrimixSystemReview','readiness','PLACEMENT REVIEW - ROUTING AND INTERFACE QUALIFICATION PENDING')
    if not document.saveAs(NAME,folder,'System review copy; preserves PCBFit v6 and approved exterior',''): raise RuntimeError('Cloud SaveAs failed')
    report('fusion-baseline.json',{'name':document.name,'id':document.dataFile.id,'source':str(source),'source_sha256':actual,
        'folder':folder.name,'timeline':design.timeline.count,'occurrences':design.rootComponent.allOccurrences.count,'preserved_documents':before})

def inspect():
    app=core.Application.get()
    matches=[d for d in app.documents if d.name.startswith(NAME)]
    if len(matches)!=1: raise RuntimeError('Expected exactly one SystemReview document')
    doc=matches[0]; design=fusion.Design.cast(doc.products.itemByProductType('DesignProductType'))
    report('fusion-state.json',{'name':doc.name,'modified':doc.isModified,'id':doc.dataFile.id,'timeline':design.timeline.count,
      'parameters':[{'name':p.name,'expression':p.expression,'value_cm':p.value} for p in design.userParameters],
      'components':[{'name':o.component.name,'path':o.fullPathName,'part':o.component.partNumber,'visible':o.isVisible,
                    'bounds_mm':[[v*10 for v in o.boundingBox.minPoint.asArray()],[v*10 for v in o.boundingBox.maxPoint.asArray()]]} for o in design.rootComponent.occurrences],
      'unhealthy':[{'index':i,'name':design.timeline.item(i).name,'message':design.timeline.item(i).errorOrWarningMessage} for i in range(design.timeline.count) if design.timeline.item(i).healthState!=fusion.FeatureHealthStates.HealthyFeatureHealthState]})
