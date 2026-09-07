import importlib
import sys

def run(_context: str):
    scripts='/Users/magnustrandokken/Documents/Projects/Trimix/trimix-analysator/hardware/enclosure/scripts'
    if scripts not in sys.path:
        sys.path.insert(0,scripts)
    import build_enclosure as b
    import fusion_audit as a
    importlib.reload(b)
    importlib.reload(a)
    app,d=b.app_design()
    c=b.component(d,'17 Chamber sensor envelopes TBD')
    plane=c.constructionPlanes.itemByName('ZE07-CO total envelope sketch / plane')
    plane.definition.offset.expression='16 mm'
    d.rootComponent.attributes.add(b.GROUP,'gas_clearance','ZE07 front moved to Z16 mm to clear the 5 mm exhaust bore')
    if not d.computeAll():
        raise RuntimeError('Recompute failed after gas clearance change')
    a.audit()
