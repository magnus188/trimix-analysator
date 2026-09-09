"""Actual Fusion diagnostic views; visibility/camera restored, no animation."""
import adsk
import adsk.core as core
from runtime import owned,configure,report,BASE

def capture():
    app,doc,d=owned();configure()
    import review_a3 as r
    state=r._visibility(d);cam=app.activeViewport.camera;timeline=d.timeline.count;outputs=[]
    active=d.activeOccurrence
    extras=[(c,'isOriginFolderLightBulbOn',c.isOriginFolderLightBulbOn)for c in d.allComponents]
    extras += [(q,'isLightBulbOn',q.isLightBulbOn)for c in d.allComponents for q in list(c.sketches)+list(c.constructionPlanes)]
    def save(name,delta,target=None):
        camera=app.activeViewport.camera;camera.cameraType=core.CameraTypes.OrthographicCameraType
        target=target or (4.25,9,2.15)
        camera.target=core.Point3D.create(*target)
        camera.eye=core.Point3D.create(*(v+w for v,w in zip(target,delta)))
        camera.upVector=core.Vector3D.create(0,1,0);camera.isFitView=True;camera.isSmoothTransition=False
        app.activeViewport.camera=camera;adsk.doEvents();app.activeViewport.refresh()
        path=BASE/'views'/name;path.parent.mkdir(exist_ok=True)
        options=core.SaveImageFileOptions.create(str(path));options.width=1800;options.height=1400
        options.isAntiAliased=True;options.isBackgroundTransparent=False
        if not app.activeViewport.saveAsImageFileWithOptions(options):raise RuntimeError('Diagnostic capture failed '+name)
        outputs.append(str(path))
    try:
        r._show_assembly(d)
        for o in d.rootComponent.occurrences:
            p=o.component.partNumber
            if p in ('REF-JJ-O2','TMX-A3-P02'):o.isLightBulbOn=False
            a=o.attributes.itemByName('TrimixRev04','physical_group')
            if a and a.value=='rear_cover':o.isLightBulbOn=False
        save('system-review-rear-open.png',(-30,15,45))
        for o in d.rootComponent.occurrences:
            o.isLightBulbOn=o.component.partNumber in {'TMX-A3-P06','TMX-A3-P09','TMX-A3-C05','TMX-A3-B02'}
        save('usb-datum-review.png',(-8,-8,12),(4.25,1,2.6))
        for o in d.rootComponent.occurrences:
            o.isLightBulbOn=o.component.partNumber in {'REF-JJ-O2','TMX-A3-P07','TMX-A3-P11','TMX-A3-C07','TMX-A3-C08','TMX-A3-C09'}
        save('jj-chamber-reference.png',(-12,7,18),(4.3,15.3,2.1))
    finally:
        r._restore_visibility(d,state)
        for entity,property_name,value in extras:
            if entity.isValid:setattr(entity,property_name,value)
        if active:
            if not active.activate():raise RuntimeError('Cannot restore prior active component')
        elif not d.activateRootComponent():raise RuntimeError('Cannot restore root active component')
        app.activeViewport.camera=cam;adsk.doEvents();app.activeViewport.refresh()
    if d.timeline.count!=timeline:raise RuntimeError('Diagnostic view modified timeline')
    report('diagnostic-views.json',{'document':doc.name,'actual_Fusion_geometry':True,'files':outputs,
        'visibility_and_camera_restored':True,'geometry_or_pose_changed':False,
        'limits':'JJ is a comparative measurement envelope; USB/other purchased details remain drawing references. Images are not sealing, force, wiring or manufacturing verification.'})
