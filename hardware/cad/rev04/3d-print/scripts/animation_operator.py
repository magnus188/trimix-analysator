"""Explicit root-controlled native Animation command preparation."""
import adsk.core as core,adsk.fusion as fusion,json
import print_runtime as rt
def commands():
    app=core.Application.get()
    result=[{'id':c.id,'name':c.name} for c in app.userInterface.commandDefinitions if
            any(t in (c.id+' '+c.name).lower() for t in ('explode','storyboard','transform component','animation','rename'))]
    rt.save_report('animation-command-catalog.json',result)

def named_storyboard():
    import drawing_animation as a
    app,doc,d,m=a._get();name='PrintReview service exploded'
    s=m.storyboards.itemByName(name)
    if not s:
        old=m.activeStoryboard
        if old.end!=0:raise RuntimeError('Only copy the newly empty storyboard')
        s=old.copy(name)
        if not s or not s.activate():raise RuntimeError('Named storyboard copy failed')
        if not old.deleteMe():raise RuntimeError('Could not remove generated empty copy')
    s.activate();s.isViewRecordingOn=False;s.playheadPosition=0
    rt.save_report('animation-named.json',{'name':name,'native_found':bool(m.storyboards.itemByName(name)),'count':m.storyboards.count,'end':s.end})

def cover_transform():
    import drawing_animation as a
    from audit_a3 import attribute
    app,doc,d,m=a._get();s=m.activeStoryboard;s.isViewRecordingOn=False;s.playheadPosition=2
    app.userInterface.activeSelections.clear();selected=[]
    for o in d.rootComponent.occurrences:
        group=attribute(o,'physical_group') or attribute(o.component,'physical_group')
        if group=='rear_cover':
            app.userInterface.activeSelections.add(o);selected.append(o.fullPathName)
    if len(selected)!=5:raise RuntimeError('Expected cover plus four screws')
    rt.save_report('animation-selected.json',{'group':'rear_cover','paths':selected,'playhead':2})
    command=app.userInterface.commandDefinitions.itemById('PublisherMoveComponentsCommand')
    if not command.execute():raise RuntimeError('Could not open native component transform')

def inspect():
    import drawing_animation as a
    app,doc,d,m=a._get();s=m.activeStoryboard
    print(json.dumps({'storyboard_end':s.end,'playhead':s.playheadPosition,'is_recording_view':s.isViewRecordingOn,'native_name_found':bool(m.storyboards.itemByName('PrintReview service exploded')),'modified':doc.isModified}))

def init_steps():
    import drawing_animation as a
    _,_,_,m=a._get()
    if m.activeStoryboard.end!=2:raise RuntimeError('Require the verified2second cover move')
    actions=[('Cover spread','rear_cover',[95,0,25]),('Display','display',[0,0,-45]),
      ('Display retainers','display_retainers',[-45,-5,20]),('Battery holder','battery',[-40,-15,40]),
      ('Battery disconnect','disconnect',[-40,-15,45]),('Carrier','carrier',[50,-10,40]),
      ('PCB','pcb',[50,-10,55]),('Button','button',[40,0,0]),('USB cartridge','usb',[0,-45,5]),
      ('Sample cartridge','chamber',[0,35,30]),('Chamber lid','chamber_lid',[0,35,75]),
      ('Inlet fitting','gas_inlet',[25,35,30]),('Outlet fitting','gas_outlet',[-25,35,30]),
      ('Individual screws','screws',[0,0,12]),('Disconnect mate','mate',[0,0,8])]
    rt.save_report('animation-steps.json',{'first_cover_action_verified':True,'next':0,'actions':[
      {'label':label,'selector':selector,'delta_mm':delta,'time':4+2*i,'status':'pending'} for i,(label,selector,delta) in enumerate(actions)]})

def start_next():
    import drawing_animation as a
    from audit_a3 import attribute
    app,doc,d,m=a._get();p=rt.BASE/'verification/animation-steps.json';plan=json.loads(p.read_text())
    row=plan['actions'][plan['next']];s=m.activeStoryboard;s.isViewRecordingOn=False;s.playheadPosition=row['time']
    selected=[];app.userInterface.activeSelections.clear();selector=row['selector']
    for o in d.rootComponent.occurrences:
        group=attribute(o,'physical_group') or attribute(o.component,'physical_group');c=o.component
        match=group==selector
        if selector in ('gas_inlet','gas_outlet') and group=='gas_fittings':
            center=(o.boundingBox.minPoint.x+o.boundingBox.maxPoint.x)*5
            match=(center>d.userParameters.itemByName('CaseWidth').value*5)==(selector=='gas_inlet')
        if selector=='screws':match=attribute(c,'hardware_kind')=='screw'
        if selector=='mate':match=attribute(c,'battery_role')=='disconnect_mate'
        if match:
            if not app.userInterface.activeSelections.add(o):raise RuntimeError('Selection failed '+o.fullPathName)
            selected.append(o.fullPathName)
    if not selected:raise RuntimeError('Empty selection '+selector)
    row['selected']=selected;row['status']='awaiting_native_UI_entry';p.write_text(json.dumps(plan,indent=2)+'\n')
    print(json.dumps(row))
    if not app.userInterface.commandDefinitions.itemById('PublisherMoveComponentsCommand').execute():raise RuntimeError('Native transform command failed')

def finish_step():
    import drawing_animation as a
    _,_,_,m=a._get();p=rt.BASE/'verification/animation-steps.json';plan=json.loads(p.read_text());row=plan['actions'][plan['next']]
    if m.activeStoryboard.end<row['time']:raise RuntimeError('No positive-duration action at expected time')
    row['status']='native_UI_action_recorded';row['observed_end']=m.activeStoryboard.end
    plan['next']+=1;p.write_text(json.dumps(plan,indent=2)+'\n');print(json.dumps({'completed':row['label'],'next':plan['next'],'total':len(plan['actions'])}))

def next_after_verified():
    finish_step()
    plan=json.loads((rt.BASE/'verification/animation-steps.json').read_text())
    if plan['next']<len(plan['actions']):start_next()
