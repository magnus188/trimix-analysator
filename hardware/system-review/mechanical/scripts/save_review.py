"""Save only the guarded SystemReview design, preserving other open documents."""
import hashlib,json,zipfile
from runtime import owned,report,BASE,other_documents

def checkpoint():
    app,doc,d=owned();before=other_documents(app)
    if not d.computeAll():raise RuntimeError('Review checkpoint recompute failed')
    path=BASE/'Trimix_Enclosure_A3_SystemReview.f3d'
    if not d.exportManager.execute(d.exportManager.createFusionArchiveExportOptions(str(path))):raise RuntimeError('Native archive export failed')
    with zipfile.ZipFile(path) as archive:
        if archive.testzip() is not None:raise RuntimeError('Native archive CRC failed')
        count=len(archive.namelist())
    if not doc.save('SystemReview mechanical corrections; purchasing, cable/seal, charging and routing qualifications remain open'):raise RuntimeError('SystemReview cloud save failed')
    if before!=other_documents(app):raise RuntimeError('A protected other document changed')
    report('native-checkpoint.json',{'document':doc.name,'cloud_id':doc.dataFile.id,'version':doc.dataFile.versionNumber,
        'native':str(path),'bytes':path.stat().st_size,'sha256':hashlib.sha256(path.read_bytes()).hexdigest(),
        'archive_crc_pass':True,'archive_members':count,'timeline':d.timeline.count,
        'body_instance_count':sum(o.component.bRepBodies.count for o in d.rootComponent.allOccurrences)+d.rootComponent.bRepBodies.count,
        'other_documents_preserved':before,'status':'engineering_review_checkpoint; final PCB refresh and verification pending'})
