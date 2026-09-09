"""Guard all review scripts to one owned Fusion document and local outputs."""
from pathlib import Path
import importlib,json,sys
import adsk.core as core
import adsk.fusion as fusion
BASE=Path(__file__).resolve().parents[1]
ROOT=BASE.parents[2]
OUT=BASE/'verification'
NAME='Trimix_Enclosure_A3_SystemReview'
FILE_ID='urn:adsk.wipprod:dm.lineage:geOTCCd5RLSccJsKjpLS-w'
GROUP='TrimixSystemReview'

def owned():
    app=core.Application.get();doc=app.activeDocument
    if not doc or not doc.name.startswith(NAME) or not doc.dataFile or doc.dataFile.id!=FILE_ID:
        raise RuntimeError('Only the exact SystemReview cloud copy may be active; preserve all other documents.')
    d=fusion.Design.cast(doc.products.itemByProductType('DesignProductType'))
    if not d or not d.rootComponent.attributes.itemByName(GROUP,'source_sha256'):
        raise RuntimeError('Owned SystemReview source guard missing')
    return app,doc,d

def configure():
    path=str(ROOT/'hardware/cad/rev04/scripts')
    if path not in sys.path:sys.path.append(path)
    import build_a3 as b
    b.NAME=NAME;b.BASE=BASE
    b.get=lambda:(owned()[0],owned()[2])
    for name in ('audit_a3','verification_a3','wall_fastener_checks','gas_checks_a3','review_a3','step_a3'):
        m=importlib.import_module(name)
        if hasattr(m,'OUTPUT'):m.OUTPUT=OUT
        if hasattr(m,'BASE'):m.BASE=BASE
        if hasattr(m,'_owned_design'):m._owned_design=lambda:(owned()[0],owned()[2])
    return b

def report(name,data):
    OUT.mkdir(parents=True,exist_ok=True);path=OUT/name
    path.write_text(json.dumps(data,indent=2)+'\n')
    print(json.dumps({'report':str(path),'keys':list(data),'counts':{k:len(v)for k,v in data.items()if isinstance(v,list)}}))

def bounds(entity):
    box=entity.boundingBox
    return [[v*10 for v in box.minPoint.asArray()],[v*10 for v in box.maxPoint.asArray()]]

def attrs(entity):
    return {a.groupName+'/'+a.name:a.value for a in entity.attributes}

def other_documents(app):
    return [{'name':q.name,'id':q.dataFile.id if q.dataFile else None,'modified':q.isModified}for q in app.documents if not q.name.startswith(NAME)]
