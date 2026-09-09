"""Export only changed printed parts for local diagnostic slicing; no print release."""
import math,hashlib
from runtime import owned,report,bounds,BASE
import adsk.fusion as fusion

PARTS={'TMX-A3-P03':'Carrier with lowered coax clearance bridge',
       'TMX-A3-P06':'USB frame with corrected PCB ledge elevation',
       'TMX-A3-P10':'USB bridge with 2.8 mm rear PCB capture pad'}

def export():
    _,doc,d=owned();out=BASE/'diagnostic-printing/source-stl';out.mkdir(parents=True,exist_ok=True)
    rows=[]
    for part,note in PARTS.items():
        components=[c for c in d.allComponents if c.partNumber==part]
        if len(components)!=1:raise RuntimeError('Expected unique printed part '+part)
        c=components[0]
        if c.bRepBodies.count!=1 or not c.bRepBodies.item(0).isSolid:raise RuntimeError('Part must be one solid '+part)
        body=c.bRepBodies.item(0);path=out/(part+'.stl')
        options=d.exportManager.createSTLExportOptions(body,str(path))
        options.isBinaryFormat=True;options.sendToPrintUtility=False
        options.unitType=fusion.DistanceUnits.MillimeterDistanceUnits
        options.surfaceDeviation=.001;options.normalDeviation=math.radians(3)
        if not d.exportManager.execute(options):raise RuntimeError('Diagnostic STL export failed '+part)
        rows.append({'part_id':part,'component':c.name,'change':note,'file':str(path),
            'sha256':hashlib.sha256(path.read_bytes()).hexdigest(),'native_bounds_mm':bounds(body),
            'native_volume_mm3':body.volume*1000,'surface_deviation_mm':options.surfaceDeviation*10,
            'normal_deviation_degrees':math.degrees(options.normalDeviation),'units':'mm','scale':1.0})
    report('diagnostic-mesh-export.json',{'document':doc.name,'parts':rows,
        'status':'diagnostic_meshes_pending_slice_review','printing_authorized_or_sent':False,
        'limits':'Local meshing/slicing only. Not a production print release or material/seal/insert-retention qualification.'})
