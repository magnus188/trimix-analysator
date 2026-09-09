import sys,json
def run(_context:str):
    scripts='/Users/magnustrandokken/Documents/Projects/Trimix/trimix-analysator/hardware/cad/rev03/scripts'
    if scripts not in sys.path:sys.path.insert(0,scripts)
    import build_rev03 as b
    app,d=b.get()
    stages=[(a.name,a.value) for a in d.rootComponent.attributes if a.groupName==b.GROUP]
    print(json.dumps({'document':app.activeDocument.name,'timeline':d.timeline.count,'occurrences':d.rootComponent.occurrences.count,
       'stage_attributes':stages,'usb_attributes':[(c.name,[(a.name,a.value) for a in c.attributes if a.groupName==b.GROUP]) for c in d.allComponents if c.name.startswith('USB')],
       'joints':d.rootComponent.joints.count,'bound_hardware':sum(bool(o.attributes.itemByName(b.GROUP,'joint_bound')) for o in d.rootComponent.occurrences)}))
