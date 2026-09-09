"""Save source-specific intermediate integration without replacing baseline archives."""
from pathlib import Path
import hashlib,json,zipfile
from runtime import owned,configure,BASE,report,other_documents

def usb():
    app,doc,d=owned();configure()
    from review_checks import health
    if not health(d)['pass']:raise RuntimeError('Cannot checkpoint unhealthy integration')
    receipt=json.loads((BASE/'verification/final-usb-clearance.json').read_text())
    if receipt['status']!='bounded_clear':raise RuntimeError('USB geometry has not passed')
    protected=other_documents(app);timeline=d.timeline.count
    target=BASE/'inputs/usb-final-integration/Trimix_Enclosure_A3_SystemReview_USBFrozen.f3d';target.parent.mkdir(parents=True,exist_ok=True)
    if not d.exportManager.execute(d.exportManager.createFusionArchiveExportOptions(str(target))):raise RuntimeError('Native checkpoint export failed')
    with zipfile.ZipFile(target) as archive:
        if archive.testzip():raise RuntimeError('Native checkpoint CRC failure')
    if not doc.save('Frozen routedUSB PCB and clearancecheck; mainSamtec/routing updatepending. Notfabricationrelease.'):
        raise RuntimeError('Cloud save failed')
    if d.timeline.count!=timeline or other_documents(app)!=protected:raise RuntimeError('Checkpoint changed source or otherdocuments')
    return report('usb-integration-checkpoint.json',{'document':doc.name,'file':str(target),'sha256':hashlib.sha256(target.read_bytes()).hexdigest(),
         'bytes':target.stat().st_size,'timeline':timeline,'native_zip_crc_pass':True,'other_documents_preserved':True,'source_usb_sha256':receipt['source']['sha256'],
         'status':'usb_frozen_main_update_pending'})
