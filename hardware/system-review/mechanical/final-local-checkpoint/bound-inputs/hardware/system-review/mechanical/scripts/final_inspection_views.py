"""Actual final engineering inspection views; no part movement or animation."""
from pathlib import Path
import json,hashlib
import adsk
import adsk.core as core
from runtime import BASE,owned,configure
from final_local_integration import BOARD_SHA,STEP_SHA,_require
OUT=BASE/'verification/final-local-checks/views'


def capture():
    import review_a3 as views
    import review_checkpoint as checkpoint
    import final_local_checks as checks
    checks._guard();app,doc,d=owned();configure()
    _require(abs(d.userParameters.itemByName('CaseWidth').value*10-85)<1e-6,'Inspection views require restored85mm design')
    _require(not OUT.exists(),'Preserve final views')
    before=checkpoint._state(d);protected=checkpoint._documents(app,doc)
    prior=views._visibility(d);camera=app.activeViewport.camera;active=d.activeOccurrence
    extras=[(c,'isOriginFolderLightBulbOn',c.isOriginFolderLightBulbOn)for c in d.allComponents]
    extras += [(q,'isLightBulbOn',q.isLightBulbOn)for c in d.allComponents for q in list(c.sketches)+list(c.constructionPlanes)]
    outputs=[];OUT.mkdir(parents=True)
    def save(name,delta,caption):
        cam=app.activeViewport.camera;cam.cameraType=core.CameraTypes.OrthographicCameraType
        target=(4.25,9,2.15);cam.target=core.Point3D.create(*target)
        cam.eye=core.Point3D.create(*(a+b for a,b in zip(target,delta)))
        cam.upVector=core.Vector3D.create(0,1,0);cam.isFitView=True;cam.isSmoothTransition=False
        app.activeViewport.camera=cam;adsk.doEvents();app.activeViewport.refresh()
        path=OUT/name;options=core.SaveImageFileOptions.create(str(path));options.width=1600;options.height=1600
        options.isAntiAliased=True;options.isBackgroundTransparent=False
        _require(app.activeViewport.saveAsImageFileWithOptions(options),'Inspection image export failed')
        outputs.append({'file':str(path),'sha256':hashlib.sha256(path.read_bytes()).hexdigest(),'caption':caption})
    def assembly():
        views._show_assembly(d)
        for o in d.rootComponent.occurrences:
            if o.component.partNumber=='REF-JJ-O2':o.isLightBulbOn=False
    try:
        assembly();save('assembled.png',(-28,15,-42),'Actual final085mm physical AO2 assembly, front three-quarter; no exploded transforms.')
        for o in d.rootComponent.occurrences:
            a=o.attributes.itemByName('TrimixRev04','physical_group')
            if o.component.partNumber=='TMX-A3-P02' or (a and a.value=='rear_cover'):o.isLightBulbOn=False
        save('rear-access.png',(-27,14,45),'Actual installed final PCB at its rigid datum; rear cover and cover screws hidden solely for inspection.')
        for o in d.rootComponent.occurrences:o.isLightBulbOn=o.component.name=='Carrier / removable electronics tray'
        save('carrier-apertures.png',(-8,7,45),'Actual two new rear-component apertures in the native carrier; other parts hidden, carrier pose unchanged.')
    finally:
        views._restore_visibility(d,prior)
        for entity,key,value in extras:
            if entity.isValid:setattr(entity,key,value)
        if active:_require(active.activate(),'Could not restore active component')
        else:_require(d.activateRootComponent(),'Could not restore root component')
        app.activeViewport.camera=camera;adsk.doEvents();app.activeViewport.refresh()
    _require(before==checkpoint._state(d) and protected==checkpoint._documents(app,doc),'Inspection altered source geometry or protected docs')
    data={'document':doc.name,'board_sha256':BOARD_SHA,'step_sha256':STEP_SHA,'timeline':d.timeline.count,
        'actual_Fusion_geometry':True,'part_poses_changed':False,'visibility_and_camera_restored':True,
        'source_and_protected_documents_preserved':True,'files':outputs,'scope':'Engineering inspection only; no animation, showcase or physical/manufacturing qualification.'}
    (OUT/'views.json').write_text(json.dumps(data,indent=2)+'\n')
    return data
