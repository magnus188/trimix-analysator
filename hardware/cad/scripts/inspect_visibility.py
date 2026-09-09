import adsk.core as core
import adsk.fusion as fusion
import json

def run(_context: str):
    app=core.Application.get()
    d=fusion.Design.cast(app.activeProduct)
    values=[]
    for o in d.rootComponent.occurrences:
        values.append({'name':o.name,'bulb':o.isLightBulbOn,'visible':o.isVisible,
            'bodies':[{'name':b.name,'bulb':b.isLightBulbOn,'visible':b.isVisible} for b in o.bRepBodies]})
    cam=app.activeViewport.camera
    print(json.dumps({'visibility':values,'camera_eye':cam.eye.asArray(),'target':cam.target.asArray(),
                      'analyses':[{'name':a.name,'on':a.isLightBulbOn} for a in d.analyses.sectionAnalyses]}))
