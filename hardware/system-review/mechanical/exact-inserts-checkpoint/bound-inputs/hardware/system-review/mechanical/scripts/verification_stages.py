"""Adapt prior qualified digital checks to the owned review and new PCB groups."""
import sys,importlib
from runtime import owned,configure,report,ROOT,OUT

def _record_adapter():
    configure()
    import verification_a3 as v,wall_fastener_checks as w
    original=v._records
    def adapted(d,manager):
        rows=original(d,manager)
        rows=[r for r in rows if r['physical_group']!='alternative_oxygen_reference']
        for r in rows:
            if r['occurrence'].startswith('PCB A3 - main four-layer placement:'):r['physical_group']='pcb'
            elif r['occurrence'].startswith('PCB A3 - routed USB daughterboard:'):r['physical_group']='usb'
        return rows
    v._records=adapted
    if hasattr(w,'_records'):w._records=adapted
    return v,w

def gas():
    configure();import gas_checks_a3 as g
    g.audit()

def paths():
    v,_=_record_adapter();v.audit_paths()

def drivers():
    v,_=_record_adapter();v.audit_drivers()

def walls():
    _,w=_record_adapter()
    path=str(ROOT/'hardware/cad/rev04/3d-print/scripts')
    if path not in sys.path:sys.path.append(path)
    import print_runtime as rt,release_checks as checks
    rt.BASE=OUT.parent;rt.owned=lambda:(owned()[0],owned()[2]);rt.save_report=report
    original=w._section
    aliases={'USB A3 — hidden metal retaining bridge':'USB A3 — printed retaining bridge',
             'USB A3 — tiny flush metal bezel and hidden flange':'USB A3 — printed bezel and hidden flange'}
    def section(d,records,name,component,*args):return original(d,records,name,aliases.get(component,component),*args)
    w._section=section
    try:checks.updated_walls()
    finally:w._section=original

def changed_sections():
    """Additional material segments in revised USB supports and coax carrier."""
    _,w=_record_adapter()
    from review_checks import records
    manager,rows=records();_,_,d=owned()
    specs=[
      ('USB lowered rear ledge','USB A3 — removable printed support frame',['UsbX','17 mm','UsbZ-3.1 mm'],['UsbX','17 mm','UsbZ-1.1 mm'],'Lowered0.8mm; nominal2mm support retained',2),
      ('USB upper capture pad','USB A3 — printed retaining bridge',['UsbX','17 mm','UsbZ-0.5 mm'],['UsbX','17 mm','UsbZ+2.3 mm'],'Pad thickened2.0→2.8mm while lowering its contact surface0.8mm',2.8),
      ('USB extended rear stop','USB A3 — printed retaining bridge',['UsbX','18 mm','UsbZ+1 mm'],['UsbX','20 mm','UsbZ+1 mm'],'Rearstop lowered without reducing2mm thickness alongY',2),
      ('Coax dropped carrier floor','Carrier / removable electronics tray',['54.85 mm','103.4 mm','15 mm'],['54.85 mm','103.4 mm','17 mm'],'2mm floor beneath the uppercoax clearance pocket',2),
      ('Coax carrier lower end wall','Carrier / removable electronics tray',['54.85 mm','96.99 mm','18 mm'],['54.85 mm','98.99 mm','18 mm'],'2mm lowerendwall joining droppedbridge to carrier',2),
      ('Coax carrier upper end wall','Carrier / removable electronics tray',['54.85 mm','107.81 mm','18 mm'],['54.85 mm','109.81 mm','18 mm'],'2mm upperendwall joining droppedbridge to carrier',2)]
    results=[w._section(d,rows,*spec)for spec in specs]
    report('changed-section-checks.json',{'status':'selected_sections_passed' if all(r['status']=='selected_section_passed'for r in results)else'needs_review',
      'sections':results,'count':len(results),'scope':'Six additional selectedmaterialsegments. Not a globalminimumwall or structuralqualification.',
      'USB_PCBtop_to_bridge_underside_mm':5.7,'solder_wire_bend_allowance_not_included':True})
