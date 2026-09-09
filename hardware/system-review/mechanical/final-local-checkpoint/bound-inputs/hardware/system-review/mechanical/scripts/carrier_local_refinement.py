"""Source-bound two-aperture carrier proposal for frozen0962; transient first."""
from pathlib import Path
import json, hashlib
import adsk.fusion as fusion
from runtime import BASE,GROUP,owned,configure,bounds
from final_local_integration import STEP_SHA,BOARD_SHA,_require
OUT=BASE/'verification/final-local-carrier'
CARRIER='Carrier / removable electronics tray'
CUTS=[{'name':'C103 and C107 rear component aperture','references':['C103','C107'],'pcb_xy_mm':[11.955,77.805,15.795,81.595]},
      {'name':'R504 rear component aperture','references':['R504'],'pcb_xy_mm':[16.425,46.925,20.075,49.075]}]


def _sha(path):return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def _write(name,data):
    OUT.mkdir(parents=True,exist_ok=True)
    with (OUT/name).open('x')as f:f.write(json.dumps(data,indent=2)+'\n')
    return data


def _source():
    import width_contract_checks as width
    manifest=width._inputs()
    _require(manifest['main']['sha256']==STEP_SHA and manifest['main']['board_sha256']==BOARD_SHA,'Only frozen0962 is prepared')
    source=BASE/'verification/final-local-inputs/carrier-source-envelope.json'
    _require(_sha(source)=='82eee68167ba4b0e0db67298700dbe9ccca042b8caac2fc345639eefa535fc66','Frozen courtyard source changed')
    proof=json.loads(source.read_text())
    _require(proof['source_board_sha256']==BOARD_SHA,'Source courtyard mismatch')
    caps=proof['combined_capacitor_proposal']['rectangular_union_PCB_mm']
    resistor=next(r for r in proof['components'] if r['reference']=='R504')['proposed_window']['PCB_XY_mm']
    _require(caps==CUTS[0]['pcb_xy_mm'] and resistor==CUTS[1]['pcb_xy_mm'],'Re-review changed source windows')
    return manifest,source


def _world(cut,d):
    p=lambda n:d.userParameters.itemByName(n).value*10
    x0,y0,x1,y1=cut['pcb_xy_mm']
    return [p('PcbX')+x0,p('PcbY')+p('PcbHeight')-y1,p('PcbZ')-2.1,
            p('PcbX')+x1,p('PcbY')+p('PcbHeight')-y0,p('PcbZ')+.1]


def _box(manager,values):
    from backside_allocation import _box as create
    return create(manager,values)


def _difference(manager,one,two):
    copy=manager.copy(one)
    _require(manager.booleanOperation(copy,two,fusion.BooleanTypes.DifferenceBooleanType),'Temporary difference failed')
    return copy.volume*1000


def _candidate(manager,body,d):
    result=manager.copy(body)
    for cut in CUTS:
        _require(manager.booleanOperation(result,_box(manager,_world(cut,d)),fusion.BooleanTypes.DifferenceBooleanType),'Carrier subtraction failed')
    _require(result.isSolid and result.lumps.count==1,'Proposed carrier must remain one solid')
    return result


def sections(manager,body,d):
    """Entire2mm-wide,2mm-thick rings around both openings, not point-only walls."""
    rows=[]
    for cut in CUTS:
        x0,y0,_,x1,y1,_=_world(cut,d);z=d.userParameters.itemByName('PcbZ').value*10
        # The tiny boundary inset only avoids coincident Boolean surfaces.
        e=.0001
        ring=_box(manager,[x0-2+e,y0-2+e,z-2+e,x1+2-e,y1+2-e,z-e])
        _require(manager.booleanOperation(ring,_box(manager,[x0,y0,z-2-.1,x1,y1,z+.1]),fusion.BooleanTypes.DifferenceBooleanType),'Retained ring construction failed')
        missing=_difference(manager,ring,body)
        rows.append({'name':cut['name'],'nominal_XY_ring_width_mm':2,'nominal_plate_thickness_mm':2,
                     'Boolean_inset_mm':e,'whole_ring_probe_volume_mm3':ring.volume*1000,
                     'missing_material_mm3':missing,'pass':missing<1e-5,
                     'scope':'Whole local ring around this aperture; not global wall/load qualification.'})
    return rows


def probe():
    """Actual imported board/maxima against original and temporary cut carrier."""
    import review_checks as review
    import review_checkpoint as state
    import verification_a3 as v
    import integrated_clearance as ic
    import width_contract_checks as width
    app,doc,d=owned();configure();manifest,source=_source()
    before=state._state(d);protected=state._documents(app,doc)
    manager,rows=review.records();physical=[r for r in rows if r['physical_group']!='alternative_oxygen_reference']
    carriers=[r for r in physical if r['component']==CARRIER]
    _require(len(carriers)==1,'Exactly one source carrier required');carrier=carriers[0]
    candidate=_candidate(manager,carrier['body'],d)
    substituted=dict(carrier,body=candidate);substituted.pop('bounds_cm',None);v._record_bounds(substituted)
    main=[r for r in physical if r['occurrence'].startswith(width.MAIN)]
    actual_before=v._test(manager,'All actual0962 PCB solids versus original carrier',main,[carrier],[(0,0,0)],[])
    actual_after=v._test(manager,'All actual0962 PCB solids versus proposed carrier',main,[substituted],[(0,0,0)],[])
    contract=json.loads(Path(manifest['main']['height_contract_file']).read_text())
    fixed=[r for r in physical if not r['occurrence'].startswith(width.MAIN) and r is not carrier]+[substituted]
    with width.allocations(OUT):
        maxima=ic._main(manager,contract,.16)
        maximum=v._test(manager,'All fitted maximum/allocation bounds and proposed carrier at1.76mm board',maxima,fixed,[(0,0,0)],[])
    material=sections(manager,candidate,d)
    removed=manager.copy(carrier['body']);_require(manager.booleanOperation(removed,candidate,fusion.BooleanTypes.DifferenceBooleanType),'Removed-material proof failed')
    mount_tests=[]
    for x,y in ((25.6,92),(4.4,6)):
        import adsk.core as core
        xx=d.userParameters.itemByName('PcbX').value*10+x;yy=d.userParameters.itemByName('PcbY').value*10+d.userParameters.itemByName('PcbHeight').value*10-y
        axis=manager.createCylinderOrCone(core.Point3D.create(xx/10,yy/10,1.4),.31,core.Point3D.create(xx/10,yy/10,2.1),.31)
        volume=v._intersection_volume(manager,removed,axis)
        mount_tests.append({'PCB_axis_mm':[x,y],'protected_radius_mm':3.1,'Z_mm':[14,21], 'removed_material_in_protected_support_mm3':volume,'pass':volume<1e-5})
    preserved=before==state._state(d) and protected==state._documents(app,doc)
    data={'source_board_sha256':BOARD_SHA,'source_step_sha256':STEP_SHA,'courtyard_source_sha256':_sha(source),
          'active_inputs_sha256':_sha(BASE/'verification/incoming-boards.json'),'source_state':before,
          'protected_documents':protected,'cuts':[{**r,'world_cut_bounds_mm':_world(r,d)}for r in CUTS],
          'original_carrier_bounds_mm':bounds(carrier['body']),'candidate_bounds_mm':bounds(candidate),
          'original_volume_mm3':carrier['body'].volume*1000,'candidate_volume_mm3':candidate.volume*1000,
          'removed_material_mm3':removed.volume*1000,'candidate_lumps':candidate.lumps.count,
          'actual_before':actual_before,'actual_after':actual_after,'all_maximum_after':maximum,
          'whole_local_material_rings':material,'mount_support_preserved':mount_tests,
          'source_and_protected_documents_preserved':preserved,
          'pass':not actual_after['collision_count'] and not maximum['collision_count'] and all(r['pass']for r in material+mount_tests) and preserved and bounds(candidate)==bounds(carrier['body']),
          'native_geometry_changed':False,'global_minimum_wall_or_strength_proven':False}
    _write('proposal.json',data)
    _require(preserved,'Transient probe changed source state')
    return data


def apply_reviewed(proposal_sha256):
    """Apply exactly the passing source-bound two-aperture proposal; no save."""
    import review_checks as review
    import review_checkpoint as state
    from width_contract_proposal import _snapshots,compare_physical
    path=OUT/'proposal.json'
    _require(_sha(path)==proposal_sha256,'Exact passing candidate receipt hash required')
    proposal=json.loads(path.read_text());_require(proposal['pass'],'Candidate must pass before native edit')
    app,doc,d=owned();b=configure();manifest,source=_source()
    _require(_sha(source)==proposal['courtyard_source_sha256'] and
             _sha(BASE/'verification/incoming-boards.json')==proposal['active_inputs_sha256'],'Candidate input changed')
    _require(state._state(d)==proposal['source_state'] and state._documents(app,doc)==proposal['protected_documents'],'Native source changed after transient review')
    component=next(c for c in d.allComponents if c.name==CARRIER)
    _require(component.bRepBodies.count==1 and not component.attributes.itemByName(GROUP,'local_refinement_carrier'),'Carrier is ambiguous or already refined')
    manager,before=_snapshots();old=[r for r in before.values()if r['component']==CARRIER]
    _require(len(old)==1,'One physical carrier required')
    expected=_candidate(manager,old[0]['body'],d)
    protected=state._documents(app,doc);timeline=d.timeline.count
    _write('apply-started.json',{'proposal_sha256':proposal_sha256,'source_board_sha256':BOARD_SHA,
        'source_step_sha256':STEP_SHA,'timeline':timeline,'guarded_scope':'Two cuts in P03 only; no parameter, datum, purchased part or exterior edits.'})
    added=[]
    for cut in CUTS:
        x0,y0,x1,y1=cut['pcb_xy_mm']
        feature=b.box(component,cut['name'],f'PcbX + {x0:.6f} mm',f'PcbY + PcbHeight - {y1:.6f} mm',
            'PcbZ - 2.1 mm',f'{x1-x0:.6f} mm',f'{y1-y0:.6f} mm','2.2 mm','cut',component.bRepBodies.item(0))
        added.append(cut['name'])
    _require(d.computeAll(),'Native carrier recompute failed')
    _require(component.bRepBodies.count==1 and component.bRepBodies.item(0).lumps.count==1,'Carrier disconnected after native cut')
    native=component.bRepBodies.item(0)
    residuals=[_difference(manager,native,expected),_difference(manager,expected,native)]
    material=sections(manager,native,d)
    _,after=_snapshots()
    other_before={k:r for k,r in before.items()if r['component']!=CARRIER}
    other_after={k:r for k,r in after.items()if r['component']!=CARRIER}
    equivalence=compare_physical(other_before,other_after,manager)
    health=review.health(d)
    passed=max(residuals)<1e-5 and all(r['pass']for r in material) and equivalence['pass'] and health['pass'] and protected==state._documents(app,doc)
    _write('native-applied.json',{'source_board_sha256':BOARD_SHA,'source_step_sha256':STEP_SHA,
        'proposal_sha256':proposal_sha256,'new_features':added,'timeline_before':timeline,'timeline_after':d.timeline.count,
        'actual_carrier_bounds_mm':bounds(native),'actual_carrier_volume_mm3':native.volume*1000,'actual_carrier_lumps':native.lumps.count,
        'candidate_actual_bilateral_boolean_residuals_mm3':residuals,'whole_local_material_rings':material,
        'all_other_physical_solid_equivalence':equivalence,'health':health,'protected_documents_preserved':protected==state._documents(app,doc),
        'pass':passed,'saved':False,'global_wall_or_structural_qualification':False})
    _require(passed,'Native scope/equivalence/material failed; inspect state, do not save')
    component.attributes.add(GROUP,'local_refinement_carrier',json.dumps({'source_board_sha256':BOARD_SHA,
        'proposal_sha256':proposal_sha256,'cut_count':2,'basis':'Frozen rear component/pad/courtyard allocations;2mm local material rings proved. Physical fit, solder and strength remain unqualified.'}))
    return passed


def apply():
    return apply_reviewed('caec62bf876ff07fa78836e5100941b4db2f7a654bb37b3061f50c0a7f6c4c2c')
