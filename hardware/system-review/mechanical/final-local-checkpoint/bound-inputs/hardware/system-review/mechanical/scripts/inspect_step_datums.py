"""Unit-aware frozen STEP datum inspection in temporary unsaved documents."""
import json
import hashlib
from pathlib import Path
import adsk.fusion as fusion
import adsk.core as core
from runtime import owned,configure,BASE,report,bounds,other_documents


def inspect(manifest_path=None,receipt_path=None):
    app,doc,d=owned();configure()
    other=other_documents(app);timeline=d.timeline.count;modified=doc.isModified
    sources=json.loads((Path(manifest_path) if manifest_path else BASE/'verification/incoming-boards.json').read_text());results={}
    for key,spec in sources.items():
        path=Path(spec['file'])
        if hashlib.sha256(path.read_bytes()).hexdigest()!=spec['sha256']:
            raise RuntimeError('Frozen source hash changed')
        temp=None
        try:
            options=app.importManager.createSTEPImportOptions(str(path));options.isViewFit=False
            temp=app.importManager.importToNewDocument(options)
            if not temp or temp.isSaved:raise RuntimeError('Expected unsaved STEP inspection document')
            design=fusion.Design.cast(temp.products.itemByProductType('DesignProductType'))
            import audit_a3 as audit
            rows=[];substrate_solids=[]
            for o,c,i,b in audit._instances(design):
                if b.isSolid:
                    rows.append({'occurrence':o.fullPathName if o else'ROOT','component':c.name,'name':b.name,'bounds_mm':bounds(b)})
                    if c.name.endswith('_PCB') or '_PCB (' in c.name:substrate_solids.append(b)
            substrates=[r for r in rows if r['component'].endswith('_PCB') or '_PCB (' in r['component']]
            if len(substrates)!=1:
                raise RuntimeError('Expected exactly one recognized substrate '+str([r['component']for r in rows if'PCB'in r['component']]))
            if len(substrate_solids)!=1:raise RuntimeError('Expected one actual substrate solid')
            holes=[]
            for face in substrate_solids[0].faces:
                cylinder=core.Cylinder.cast(face.geometry)
                if cylinder and abs(abs(cylinder.axis.z)-1)<1e-7:
                    holes.append({'radius_mm':cylinder.radius*10,
                                  'axis_XY_mm':[cylinder.origin.x*10,cylinder.origin.y*10]})
            lo,hi=substrates[0]['bounds_mm']
            target_centre = 21.3 if key == 'main' else 25.2
            result={'source_file':str(path),'source_sha256':spec['sha256'],'placed_solids':len(rows),
                    'substrate':substrates[0],'substrate_Z_thickness_mm':hi[2]-lo[2],
                    'nominal_allocation_centre_Z_mm':target_centre,
                    'proposed_centre_aligned_translation_Z_mm':target_centre-(lo[2]+hi[2])/2,
                    'bodies':rows,'substrate_cylindrical_axes':holes,'geometry_scaled':False}
            results[key]=result
        finally:
            try:
                if temp and not temp.close(False):raise RuntimeError('Could not close own STEP inspection')
            finally:
                if not doc.activate():raise RuntimeError('Could not reactivate SystemReview')
    preserved=other_documents(app)==other and d.timeline.count==timeline and doc.isModified==modified
    receipt={'sources':results,'source_preserved':preserved,
           'status':'measured_pending_explicit_registration_review','method':'Fusion unit-aware import into temporary documents; no scaling; STEP substrate is a simplified exported body, not the nominal finished-board tolerance envelope.'}
    if receipt_path:Path(receipt_path).write_text(json.dumps(receipt,indent=2)+'\n')
    else:report('frozen-step-datums.json',receipt)
    if not preserved:raise RuntimeError('Source/document preservation failed')


def final_routed():
    return inspect(BASE/'verification/final-route-inputs/incoming-boards.json',BASE/'verification/final-route-inputs/frozen-step-datums.json')
