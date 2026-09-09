"""Isolated drawing-derived HTSW-113-07-L-D-007 nominal KiCad STEP.

Factory omitted contact7 is a purchasing candidate, not authorization to remove
pins manually. No supplier-authored CAD or toleranced mating detail is claimed.
"""
from pathlib import Path
import hashlib,json
import adsk.core as core
import adsk.fusion as fusion
from runtime import owned,configure,BASE,ROOT,report,other_documents,bounds

STEM='Samtec_HTSW_113_07_L_D_007_Drawing_Reconstruction'
GROUP='TrimixHTSW'


def _box(manager,low,high):
    result=manager.createBox(core.OrientedBoundingBox3D.create(
        core.Point3D.create(*[(a+b)/20 for a,b in zip(low,high)]),
        core.Vector3D.create(1,0,0),core.Vector3D.create(0,1,0),*[(b-a)/10 for a,b in zip(low,high)]))
    if not result or not result.isTransient or not result.isSolid:raise RuntimeError('Couldnotcreatenominalbox')
    return result


def build():
    app,original,native=owned();configure()
    timeline=native.timeline.count;modified=original.isModified;protected=other_documents(app)
    original_transforms={o.fullPathName:o.transform2.asArray()for o in native.rootComponent.allOccurrences}
    temporary=None;roundtrip=None;result=None
    target=BASE/'components'/f'{STEM}.step';target.parent.mkdir(parents=True,exist_ok=True)
    source=ROOT/'hardware/system-review/electrical/host-harness-review/samtec-htsw-series.pdf'
    contract=ROOT/'hardware/system-review/electrical/host-harness-review/contract.json'
    try:
        temporary=app.documents.add(core.DocumentTypes.FusionDesignDocumentType)
        design=fusion.Design.cast(temporary.products.itemByProductType('DesignProductType'))
        design.designType=fusion.DesignTypes.DirectDesignType
        design.unitsManager.distanceDisplayUnits=fusion.DistanceUnits.MillimeterDistanceUnits
        occurrence=design.rootComponent.occurrences.addNewComponent(core.Matrix3D.create());c=occurrence.component
        c.name='Samtec HTSW-113-07-L-D-007 nominal drawing reconstruction'
        c.partNumber='HTSW-113-07-L-D-007'
        c.description='Proposed factory-omitted pin7. Nominal referencebody/squarepost model; not manufacturer CAD. No manually removedpin approval or orderability guarantee.'
        manager=fusion.TemporaryBRepManager.get();plastic=_box(manager,[-1.2446,-31.75,0],[3.7846,1.27,2.54]);pins=[]
        for pair in range(13):
            for row in range(2):
                number=2*pair+row+1
                if number==7:continue
                x,y=2.54*row,-2.54*pair
                pin=_box(manager,[x-.32,y-.32,-2.54],[x+.32,y+.32,8.382])
                if not manager.booleanOperation(plastic,pin,fusion.BooleanTypes.DifferenceBooleanType):raise RuntimeError('Cannot form nominal plastic/contact interface')
                pins.append((number,x,y,pin))
        body=c.bRepBodies.add(plastic);body.name='Nominal polymer insulator 33.02 x5.0292 x2.54 - mold details omitted'
        if not body:raise RuntimeError('Couldnotpersistinsulator')
        c.attributes.add(GROUP,'source_sha256',hashlib.sha256(source.read_bytes()).hexdigest())
        c.attributes.add(GROUP,'geometry_basis','Nominaldrawing-derivedbodyandposts. Pin7absent. Standoffs,mold/chamfertipgeometry,platingthicknessandguaranteedmaximaomitted.')
        appearances=app.materialLibraries.itemByName('Fusion Appearance Library')
        gold=None
        if appearances and appearances.appearances.itemById('Prism-040'):
            gold=design.appearances.addByCopy(appearances.appearances.itemById('Prism-040'),'Gold plated contact visual reference')
        black=next((a for a in design.appearances if 'black' in a.name.lower()),None)
        if black:body.appearance=black
        for number,x,y,pin in pins:
            solid=c.bRepBodies.add(pin)
            if not solid:raise RuntimeError('Couldnotpersistpin'+str(number))
            solid.name='Contact '+str(number)+' nominal0.64square - unchamfered reference'
            solid.attributes.add(GROUP,'contact_number',str(number))
            if gold:solid.appearance=gold
        if c.bRepBodies.count!=26:raise RuntimeError('Expectedinsulatorplus25pins')
        design.computeAll()
        original_rows=[{'name':b.name,'bounds_mm':bounds(b),'volume_mm3':b.volume*1000}for b in c.bRepBodies]
        if not design.exportManager.execute(design.exportManager.createSTEPExportOptions(str(target),c)):raise RuntimeError('HTSWSTEPexportfailed')
        options=app.importManager.createSTEPImportOptions(str(target));options.isViewFit=False
        roundtrip=app.importManager.importToNewDocument(options)
        if not roundtrip or roundtrip.isSaved:raise RuntimeError('ExpectedunsavedSTEPcheck')
        imported=fusion.Design.cast(roundtrip.products.itemByProductType('DesignProductType'))
        imported_rows=[{'name':b.name,'bounds_mm':bounds(b),'volume_mm3':b.volume*1000} for b in imported.rootComponent.bRepBodies if b.isSolid]
        for o in imported.rootComponent.allOccurrences:
            for b in o.bRepBodies:
                if b.isSolid:imported_rows.append({'name':b.name,'bounds_mm':bounds(b),'volume_mm3':b.volume*1000})
        def aggregate(rows):
            return {'solids':len(rows),'bounds_mm':[[min(r['bounds_mm'][0][i]for r in rows)for i in range(3)],
                    [max(r['bounds_mm'][1][i]for r in rows)for i in range(3)]], 'volume_mm3':sum(r['volume_mm3']for r in rows)}
        expected,actual=aggregate(original_rows),aggregate(imported_rows)
        bbox_error=max(abs(a-b)for aa,bb in zip(expected['bounds_mm'],actual['bounds_mm'])for a,b in zip(aa,bb))
        volume_error=abs(expected['volume_mm3']-actual['volume_mm3'])
        passed=expected['solids']==actual['solids']==26 and bbox_error<1e-5 and volume_error<.001
        if not passed:raise RuntimeError('HTSWSTEProundtripfailed'+json.dumps([expected,actual]))
        result={'status':'nominal_model_roundtrip_pass','file':str(target),'sha256':hashlib.sha256(target.read_bytes()).hexdigest(),'bytes':target.stat().st_size,
            'source_drawing_file':str(source),'source_drawing_sha256':hashlib.sha256(source.read_bytes()).hexdigest(),
            'source_contract_sha256':hashlib.sha256(contract.read_bytes()).hexdigest(),
            'origin':{'pin1_xy_mm':[0,0],'row2_x_mm':2.54,'successive_pairs_y_step_mm':-2.54,'PCB_seating_Z_mm':0,'model_scale':[1,1,1],'model_rotation_deg':[0,0,0],'model_offset_mm':[0,0,0]},
            'body_bounds_mm':[[-1.2446,-31.75,0],[3.7846,1.27,2.54]],'pin_square_mm':.64,'pin_Z_mm':[-2.54,8.382],
            'omitted_contact':7,'contact_centres':[{'number':n,'XY_mm':[x,y]}for n,x,y,_ in pins],
            'native':expected,'imported':actual,'maximum_bbox_error_mm':bbox_error,'volume_error_mm3':volume_error,
            'source_geometry':'Drawing-derivednominalenvelopes,notmanufacturerCAD;omittedpin7factoryconfigurationpendingprocurementconfirmation.',
            'limits':['Bodydimensionsand2.54tailareREF/nominal;noguaranteedmaximum ormatedcable/shroudgeometry.','Squarepostsomitundimensionedtipchamfers;plasticcontactcutoutsarevisualinterfaces,nottoolingdetails.','Blackpolymer/goldappearances(ifavailable)arevisualonly;nomass/material-property/platingqualification.','Pin7omissionmodelsproposedfactory-007configuration;noauthorizedmanualpinremoval.']}
    finally:
        try:
            if roundtrip and not roundtrip.close(False):raise RuntimeError('CannotclosetemporarySTEPcheck')
            if temporary and not temporary.close(False):raise RuntimeError('CannotclosetemporaryHTSWdesign')
        finally:
            if not original.activate():raise RuntimeError('CannotreactivateSystemReview')
        preserved=native.timeline.count==timeline and original.isModified==modified and other_documents(app)==protected and original_transforms=={o.fullPathName:o.transform2.asArray()for o in native.rootComponent.allOccurrences}
        if result:report('htsw-keyed-model.json',{**result,'source_and_unrelated_documents_preserved':preserved})
        if not preserved:raise RuntimeError('HTSWmodeltaskchangedsourceorotherdocuments')
    return result
