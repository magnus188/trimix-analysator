"""Four changed-part meshes for diagnostic slicing only; no printer job."""
from pathlib import Path
import hashlib,json,math
import adsk.core as core
import adsk.fusion as fusion
from runtime import BASE,ROOT,owned,configure,bounds
from final_local_integration import STEP_SHA,BOARD_SHA,_require
OUT=BASE/'diagnostic-printing/final-local/meshes'


def sha(path):return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def export():
    import review_checkpoint as checkpoint
    import final_local_checks as checks
    checks._guard();app,doc,d=owned();configure()
    before=checkpoint._state(d);protected=checkpoint._documents(app,doc)
    _require(abs(d.userParameters.itemByName('CaseWidth').value*10-85)<1e-6,'Only85mm print geometry reviewed')
    _require(not OUT.exists(),'Preserve existing mesh handoff')
    original=json.loads((BASE/'exact-inserts-checkpoint/export.json').read_text())
    fixed=json.loads((BASE/'verification/final-local-carrier/native-applied.json').read_text())
    _require(fixed['pass'] and fixed['all_other_physical_solid_equivalence']['pass'],'Carrier-only geometry scope proof required')
    rows=[];OUT.mkdir(parents=True)
    for number,orientation in [('TMX-A3-P01','front_down'),('TMX-A3-P03','rear_down'),('TMX-A3-P06','front_down'),('TMX-A3-P07','front_down')]:
        matches=[o for o in d.rootComponent.occurrences if o.component.partNumber==number]
        _require(len(matches)==1 and matches[0].component.bRepBodies.count==1,'Unique printed part expected '+number)
        occurrence=matches[0];component=occurrence.component;body=component.bRepBodies.item(0)
        _require(body.isSolid and body.lumps.count==1 and max(abs(a-b)for a,b in zip(occurrence.transform2.asArray(),core.Matrix3D.create().asArray()))<1e-8,'Printed part must be single solid at native assembly identity')
        if number!='TMX-A3-P03':
            now=[r for r in before['bodies']if r['component']==component.name]
            prior=[r for r in original['state']['bodies']if r['component']==component.name]
            _require(now==prior,'Settled insert-host geometry changed from v10 '+number)
        path=OUT/(number+'.stl');option=d.exportManager.createSTLExportOptions(body,str(path))
        option.isBinaryFormat=True;option.sendToPrintUtility=False;option.unitType=fusion.DistanceUnits.MillimeterDistanceUnits
        option.surfaceDeviation=.001;option.normalDeviation=math.radians(3)
        _require(d.exportManager.execute(option),'STL export failed '+number)
        rows.append({'part_id':number,'component':component.name,'file':str(path),'sha256':sha(path),
            'native_bounds_mm':bounds(body),'native_volume_mm3':body.volume*1000,'orientation':orientation,
            'native_part_lumps':body.lumps.count,'units':'mm','scale':1,'geometry_scaled':False,
            'status':'diagnostic_slice_only_final_full_assembly_validation_pending'})
    source=ROOT/'hardware/cad/rev04/3d-print/printing/gas-support-blockers.json'
    blockers=json.loads(source.read_text())
    # Since the original printed revision, the only P07 host geometry edits were
    # these four M2-boss radii3.6->3.8. Their complete possible XY footprints are
    # disjoint from even the .35mm-expanded passage protection volumes.
    centres=[(18,159),(30.5,135),(17,172.2),(68,172.2)]
    gaps=[]
    for blocker in blockers['blockers']:
        low,high=blocker['bounds_mm'];halo=blocker['safety_halo_mm']
        for x,y in centres:
            dx=max(low[0]-halo-(x+3.8),(x-3.8)-(high[0]+halo),0)
            dy=max(low[1]-halo-(y+3.8),(y-3.8)-(high[1]+halo),0)
            gap=math.hypot(dx,dy)
            gaps.append({'blocker':blocker['id'],'changed_P07_M2_boss_XY_mm':[x,y],'full_edit_bounding_radius_mm':3.8,
                         'XY_gap_to_haloed_blocker_mm':gap,'pass':gap>0})
    _require(all(r['pass']for r in gaps),'Gas support blocker overlaps a changed boss; re-review')
    params={n:d.userParameters.itemByName(n).value*10 for n in ('CaseWidth','CaseHeight','CaseDepth','GasY','GasZ')}
    _require(all(abs(params[n]-v)<1e-6 for n,v in {'CaseWidth':85,'CaseHeight':180,'CaseDepth':43,'GasY':162.5,'GasZ':22}.items()),'Gas passage datum changed')
    for name in ('d1660','d1674','d1688','d1702'):
        _require(abs(d.allParameters.itemByName(name).value*10-3.8)<1e-6,'Expected only adopted chamber boss change')
    blocker_copy=OUT/'gas-support-blockers.json';blocker_copy.write_bytes(source.read_bytes())
    preservation=before==checkpoint._state(d) and protected==checkpoint._documents(app,doc)
    data={'source_board_sha256':BOARD_SHA,'source_step_sha256':STEP_SHA,'document':doc.name,
          'cloud_lineage':doc.dataFile.id,'native_timeline':d.timeline.count,'native_state_sha256':hashlib.sha256(json.dumps(before,sort_keys=True,separators=(',',':')).encode()).hexdigest(),
          'exact_insert_archive':original['native_archive'],'exact_insert_archive_sha256':original['sha256'],
          'carrier_apply_proof_file':str(BASE/'verification/final-local-carrier/native-applied.json'),
          'carrier_apply_proof_sha256':sha(BASE/'verification/final-local-carrier/native-applied.json'),
          'parts':rows,'protected_documents_preserved':preservation,'gas_support_blockers':{
              'file':str(blocker_copy),'sha256':sha(blocker_copy),'source_file':str(source),'source_sha256':sha(source),
              'native_gas_parameters_mm':params,'changed_boss_footprints_disjoint_from_all_blocker_halos':gaps,
              'basis':'Existing reviewed passage protection coordinates remain at W85/H180/D43. P07 only changed four boss radii; their full affected footprints are disjoint. Settled P07 body matches verified v10; carrier edits leave it Boolean-equivalent. Non-printable support blockers do not alter part geometry.'},
          'status':'SOURCE_BOUND_DIAGNOSTIC_MESHES_NOT_PRODUCTION_RELEASE','print_job_sent':False,
          'limits':'PLA fit/PETG diagnostic profiles only. Actual heatset retention, screw/thread fit, seal/leak performance and structural qualification remain physical gates.'}
    (OUT/'handoff.json').write_text(json.dumps(data,indent=2)+'\n')
    _require(preservation,'Diagnostic export changed document state')
    return data
