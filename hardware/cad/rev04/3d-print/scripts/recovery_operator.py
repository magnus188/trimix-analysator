"""Explicit document recovery inspection and checkpoint helpers."""
import json
import adsk.core as core
import adsk.fusion as fusion
import print_runtime as rt

def inspect():
    app=core.Application.get();rows=[]
    for doc in app.documents:
        d=fusion.Design.cast(doc.products.itemByProductType('DesignProductType'))
        row={'name':doc.name,'active':doc==app.activeDocument,'modified':doc.isModified,
             'data_file': {'name':doc.dataFile.name,'id':doc.dataFile.id,'version':doc.dataFile.versionNumber,'complete':doc.dataFile.isComplete} if doc.dataFile else None,
             'design':bool(d)}
        if d:
            row.update({'timeline':d.timeline.count,'occurrences':d.rootComponent.allOccurrences.count,
                        'animation_active':d.animationManager.isAnimationWorkspaceActive})
            if d.animationManager.isAnimationWorkspaceActive:
                try:
                    m=d.animationManager;s=m.activeStoryboard
                    row['animation']={'storyboards':m.storyboards.count,'playhead':s.playheadPosition,'end':s.end,
                                      'named':bool(m.storyboards.itemByName('PrintReview service exploded'))}
                except RuntimeError as e:
                    row['animation_error']=str(e)
        rows.append(row)
    rt.save_report('recovery-state.json',rows)

def checkpoint():
    app=core.Application.get();doc=app.activeDocument
    if not doc.dataFile or doc.dataFile.id!='urn:adsk.wipprod:dm.lineage:l5zV9NCVS8ysJ6aeOO-4sw':
        raise RuntimeError('Unexpected recovery lineage; inspect before saving')
    if not doc.save('Recovered PrintReview after Animation crash; geometry checkpoint'):
        raise RuntimeError('Recovery save failed')
    inspect()
