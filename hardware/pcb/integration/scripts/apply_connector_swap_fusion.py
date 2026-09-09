"""Apply the validated local carrier revision for the upper coax connector.

Uses native timeline features in the existing PCB fit document. Other open
documents are preserved by the dispatch wrapper. Never runs on import.
"""
from pathlib import Path
import json, sys, hashlib
import adsk.core as core
import adsk.fusion as fusion
import fusion_fit as fit

BASE=Path(__file__).resolve().parents[1]
OUT=BASE/'verification/connector-swap'

def apply_carrier():
    app,doc,d=fit.owned()
    c=next(o.component for o in d.rootComponent.occurrences if o.component.name=='Carrier / removable electronics tray')
    if c.attributes.itemByName('TrimixConnectorSwap','applied'):
        raise RuntimeError('Connector swap carrier already applied')
    if c.bRepBodies.count!=1:raise RuntimeError('Expected original carrier as one solid')
    sys.path.insert(0,str(BASE.parents[1]/'cad/rev04/scripts'))
    import build_a3 as build
    before=c.bRepBodies.item(0).volume*1000
    recipes=[
      ('Restore former coax opening','join',[50.2,88.59,18.5,59.71,97.41,20.5]),
      ('Restore former AO2 header opening','join',[53.45,102.010001,18.5,56.15,109.790001,20.5]),
      ('Coax recess lower end wall','join',[50.2,96.99,15,59.4,98.99,20.5]),
      ('Coax recess upper end wall','join',[50.2,107.81,15,59.4,109.81,20.5]),
      ('Coax recess two millimetre floor','join',[50.2,96.99,15,59.4,109.81,17]),
      ('Upper coax solder and pin clearance','cut',[50,98.99,18.4,59.26,107.81,20.6]),
      ('Lower AO2 header solder and pin clearance','cut',[53.95,89.11,18.4,56.65,96.89,20.6]),
    ]
    for name,op,b in recipes:
        values=[b[0],b[1],b[2],b[3]-b[0],b[4]-b[1],b[5]-b[2]]
        build.box(c,name,*[f'{v:.6f} mm' for v in values],op,c.bRepBodies.item(0) if op=='cut' else None)
        if c.bRepBodies.count!=1:raise RuntimeError('Carrier became disconnected at '+name)
    if not d.computeAll():raise RuntimeError('Carrier recompute failed')
    b=c.bRepBodies.item(0)
    if not b.isSolid or b.lumps.count!=1:raise RuntimeError('Carrier must be one connected solid')
    c.attributes.add('TrimixConnectorSwap','applied','J402 at local X4.45 Y16.60; J401 at X4.90 Y27.00 physical centres')
    c.attributes.add('TrimixConnectorSwap','physical_fit','Actual elbow, mating header, solder and tail dimensions pending. Structural floor/end walls are2mm nominal.')
    result={'status':'applied_pending_final_native_checks','component':c.name,'recipes':recipes,
      'volume_before_mm3':before,'volume_after_mm3':b.volume*1000,'solids':c.bRepBodies.count,'lumps':b.lumps.count,
      'floor_z_mm':[15,17],'nominal_wall_floor_thickness_mm':2,
      'physical_limits':'Generic connector tail model only; actual solder and mated cable validation still pending.',
      'timeline':d.timeline.count}
    (OUT/'carrier-applied.json').write_text(json.dumps(result,indent=2)+'\n')
    print(json.dumps(result))

def refresh_pcb():
    fit.refresh_main()

def service():
    """Reuse exact native service checks with an updated containing envelope."""
    source=Path(fit.__file__).read_text()
    source=source.replace('[50.2,103,18.5,59,120.5,top]','[50.2,103,18.5,59.4,120.5,top]')
    source=source.replace('[80.5,47.4,18.5,81.2,84.6,top]]','[80.5,47.4,18.5,81.2,84.6,top], [50.2,96.99,15,59.4,109.81,top]]')
    source=source.replace("report('pcb-service-check.json'","report('connector-swap/service-check.json'")
    ns={'__file__':fit.__file__,'__name__':'connector_swap_service_helpers'}
    exec(compile(source,fit.__file__,'exec'),ns)
    ns['service_check']()

def static_checks():
    fit._audit_board('Carrier / removable electronics tray','connector-swap/carrier-static.json')
    fit._audit_board('PCB A3 - main four-layer placement','connector-swap/pcb-static.json')
