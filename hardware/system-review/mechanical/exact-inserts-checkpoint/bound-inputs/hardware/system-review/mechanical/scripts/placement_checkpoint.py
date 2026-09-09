"""Explicit placement-only checkpoint exports and scoped follow-up receipts.

Routing remains external and unfinished. Preserve prior SystemReview archives
and keep the new files separate from any later fully routed integration.
"""
from contextlib import contextmanager
from pathlib import Path
import importlib
import json
import runtime

DEST=runtime.BASE/'placement-checkpoint-v2'

@contextmanager
def scope():
    old=runtime.OUT
    runtime.OUT=DEST/'verification';runtime.OUT.mkdir(parents=True,exist_ok=True)
    try:
        runtime.configure()
        yield
    finally:
        runtime.OUT=old;runtime.configure()


def export():
    with scope():
        import delivery_geometry as module
        importlib.reload(module)
        old_base,old_stem=module.BASE,module.STEM
        module.BASE=DEST;module.STEM='Trimix_Enclosure_A3_SystemReview_PlacementV2'
        try:
            module.export()
            path=runtime.OUT/'geometry-export.json';receipt=json.loads(path.read_text())
            receipt['integration_scope']='Immutable placement/package-escape checkpoint v2, not fully routed PCB integration or order release.'
            receipt['final_routed_integration']=False
            receipt['source_manifest']=json.loads((runtime.BASE/'verification/incoming-boards.json').read_text())
            path.write_text(json.dumps(receipt,indent=2)+'\n')
        finally:module.BASE=old_base;module.STEM=old_stem


def verify_native():
    with scope():
        import delivery_geometry as module
        importlib.reload(module)
        old_base,old_stem=module.BASE,module.STEM
        module.BASE=DEST;module.STEM='Trimix_Enclosure_A3_SystemReview_PlacementV2'
        try:return module.verify_native()
        finally:module.BASE=old_base;module.STEM=old_stem


def verify_step():
    with scope():
        import delivery_geometry as module
        importlib.reload(module)
        old_base,old_stem=module.BASE,module.STEM
        module.BASE=DEST;module.STEM='Trimix_Enclosure_A3_SystemReview_PlacementV2'
        try:return module.verify_step()
        finally:module.BASE=old_base;module.STEM=old_stem


def wall_and_changed_sections():
    with scope():
        import verification_stages as stages
        importlib.reload(stages)
        stages.walls()
        stages.changed_sections()


def gas_and_oxygen():
    with scope():
        import verification_stages as stages
        import review_checks as checks
        import verification_a3 as paths
        import wall_fastener_checks as walls
        # Prior wall adapters filter the alternative configuration. Reset those
        # cached record functions before the separate JJ replacement audit.
        importlib.reload(paths);importlib.reload(walls);runtime.configure()
        importlib.reload(stages);importlib.reload(checks)
        stages.gas();checks.oxygen()


def annotate_imports():
    """Mark imported board constituents and placement scope without geometry edits."""
    import re
    from runtime import owned,configure,other_documents,bounds,GROUP,report
    app,doc,d=owned();configure();timeline=d.timeline.count;protected=other_documents(app)
    manifest=json.loads((runtime.BASE/'verification/incoming-boards.json').read_text())
    library=next(lib for lib in app.materialLibraries if lib.name=='Fusion Material Library')
    fr4=library.materials.itemById('PrismMaterial-401');copper=library.materials.itemById('PrismMaterial-005')
    if not fr4 or not copper:raise RuntimeError('Expected PCB material families')
    changes=[];before={}
    for number,key in [('TMX-A3-B01','main'),('TMX-A3-B02','usb')]:
        wrapper=next(o for o in d.rootComponent.occurrences if o.component.partNumber==number)
        children=[o for o in d.rootComponent.allOccurrences if o.fullPathName.startswith(wrapper.fullPathName+'+')]
        for o in children:
            before[o.fullPathName]=bounds(o)
        seen=set()
        for o in children:
            c=o.component
            if c.id in seen:continue
            seen.add(c.id)
            if not c.bRepBodies.count:continue
            name=re.sub(r' \(\d+\)$','',c.name)
            old=c.material.name if c.material else None
            if name.endswith('_PCB'):
                c.material=fr4;basis='Generic FR4 family for STEP substrate. Exact finished laminate, copper/mask distribution and material properties remain unqualified.'
            elif name.endswith(('_pad','_track','_via','_copper')):
                c.material=copper;basis='Copper conductor family for explicitly named KiCad exported pads/tracks/vias; plating and process properties remain unqualified.'
            else:
                basis='Imported purchased-part or nominal reconstruction constituents are unverified; inherited material is not a confirmed specification and must not support mass or FEA claims.'
            c.attributes.add(GROUP,'material_basis',basis)
            c.attributes.add(GROUP,'material_properties_qualified','false')
            changes.append({'component':c.name,'old_material':old,'current_material':c.material.name if c.material else None,'basis':basis})
        wrapper.component.description=('Immutable placement/package-escape checkpoint v2; 169 footprints, four copper layers, nominal finished1.6mm. Not fully routed or fabrication-released.' if key=='main' else 'Frozen routedUSB daughterboard; nominalfinished0.6mm; GCTconnector retainedseparately. Fabricationedge/annular/cutout and harnessphysicalholds remain.')
        wrapper.component.attributes.add(GROUP,'integration_status',manifest[key]['status'])
    if not d.computeAll():raise RuntimeError('Metadata recompute failed')
    after={o.fullPathName:bounds(o)for o in d.rootComponent.allOccurrences if o.fullPathName in before}
    if before!=after or timeline!=d.timeline.count or protected!=other_documents(app):raise RuntimeError('Metadata operation changed geometry or protected state')
    with scope():
        report('import-material-scope.json',{'document':doc.name,'changes':changes,'geometry_unchanged':True,'protected_documents_preserved':True,'mass_or_FEA_qualified':False,'source_manifest':manifest})


def post_metadata_state():
    """Read current source/other-document state after the compound guard failure."""
    from runtime import owned,configure,other_documents,bounds,GROUP,report
    import review_checks
    app,doc,d=owned();configure()
    comparison=[];metadata=[]
    for key,number in [('main','TMX-A3-B01'),('usb','TMX-A3-B02')]:
        baseline=json.loads((runtime.BASE/('verification/pcb-refresh-'+key+'.json')).read_text())
        expected={(r['occurrence'],r['name']):r['bounds_mm']for r in baseline['placed_solids']}
        wrapper=next(o for o in d.rootComponent.occurrences if o.component.partNumber==number)
        actual={};seen=set()
        for o in d.rootComponent.allOccurrences:
            if not o.fullPathName.startswith(wrapper.fullPathName+'+'):continue
            for body in o.bRepBodies:
                if body.isSolid:actual[o.fullPathName,body.name]=bounds(body)
            if o.component.id in seen:continue
            seen.add(o.component.id)
            a=o.component.attributes.itemByName(GROUP,'material_basis')
            metadata.append({'board':key,'component':o.component.name,'material':o.component.material.name if o.component.material else None,
                             'material_basis':a.value if a else None})
        changed=[{'occurrence':k[0],'body':k[1],'maximum_bound_change_mm':max(abs(a-b)for aa,bb in zip(expected[k],actual[k])for a,b in zip(aa,bb))}
                 for k in expected.keys()&actual.keys() if max(abs(a-b)for aa,bb in zip(expected[k],actual[k])for a,b in zip(aa,bb))>1e-6]
        comparison.append({'board':key,'expected_solids':len(expected),'actual_solids':len(actual),'identities_match':expected.keys()==actual.keys(),'changed_bounds':changed,
                           'all_placed_body_bounds_preserved':expected.keys()==actual.keys() and not changed,'wrapper_description':wrapper.component.description})
    before=json.loads((runtime.BASE/'verification/pcb-refresh-main.json').read_text())['protected_documents_preserved']
    after=other_documents(app)
    result={'document':doc.name,'id':doc.dataFile.id,'modified':doc.isModified,'timeline':d.timeline.count,
       'failed_operation':'placement_checkpoint.annotate_imports',
       'failed_guard_exact':'before != after or timeline != d.timeline.count or protected != other_documents(app)',
       'failure_reason_limit':'The failed compound guard did not log its individual Boolean values. Its precise failing term cannot be recovered retrospectively. No rollback is assumed.',
       'current_board_geometry_vs_successful_import_receipts':comparison,'current_imported_material_metadata':metadata,
       'current_imported_components_with_material_basis':sum(bool(r['material_basis'])for r in metadata),
       'off_target_baseline':before,'off_target_now':after,'off_target_identities_and_modified_flags_match':before==after,'health':review_checks.health(d),
       'all_open_documents':[{'name':q.name,'id':q.dataFile.id if q.dataFile else None,'modified':q.isModified}for q in app.documents],
       'persistent_change_during_this_inspection':False}
    with scope():report('post-metadata-state.json',result)
    if not all(c['all_placed_body_bounds_preserved']for c in comparison)or before!=after:raise RuntimeError('Post-metadata geometry or protected-document mismatch')
    return result
