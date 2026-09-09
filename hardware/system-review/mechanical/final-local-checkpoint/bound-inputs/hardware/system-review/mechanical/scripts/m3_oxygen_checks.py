"""Bounded native JJ alternative at W85/W87; restores all state in finally."""
from datetime import datetime, timezone
import json
from runtime import BASE, owned, configure
import m3_candidate_audit as candidate

OUT=BASE/'verification/m3-implementation/oxygen-variants'


def run():
    configure()
    import review_checks as review
    import review_checkpoint as checkpoint
    import width_contract_checks as width
    import verification_a3 as v
    from short_m2_validation import adapted
    from width_contract_proposal import _snapshots,compare_physical
    from m3_validation import _pairs
    _pairs()
    candidate._require(not OUT.exists(),'Preserve completed oxygen proof')
    app,doc,d=owned()
    before=checkpoint._state(d)
    protected=checkpoint._documents(app,doc)
    manager,solids=_snapshots()
    parameter=d.userParameters.itemByName('CaseWidth')
    expression=parameter.expression
    candidate._require(abs(parameter.value*10-85)<1e-6,'Start oxygen variant tests at85')
    sources={str(__file__):candidate._sha(__file__),str(BASE/'scripts/m3_validation.py'):candidate._sha(BASE/'scripts/m3_validation.py'),
             str(BASE/'verification/incoming-boards.json'):candidate._sha(BASE/'verification/incoming-boards.json')}
    outcomes=[]
    OUT.mkdir(parents=True)
    try:
        for nominal in (85,87):
            folder=OUT/('W'+str(nominal))
            parameter.expression=str(nominal)+' mm'
            candidate._require(d.computeAll(),'Oxygen variant width recompute failed')
            with adapted(folder):
                with width.allocations(folder) as ic:
                    manifest=ic._manifest()
                    main=json.loads(open(manifest['main']['height_contract_file']).read())
                    usb=json.loads(open(manifest['usb']['height_contract_file']).read())
                    for item in manifest.values():
                        for f,h in (('file','sha256'),('height_contract_file','height_contract_sha256')):
                            sources[item[f]]=item[h]
                    original=v._records
                    def records(design,temporary_manager):
                        # Keep all three alternative reference solids so the
                        # existing explicit AO2/JJ substitution remains visible.
                        return original(design,temporary_manager)+ic._main(temporary_manager,main,.16)+ic._usb(temporary_manager,usb)+[ic._mate(temporary_manager,main,.16),ic._cable(temporary_manager,main,.16)]
                    v._records=records
                    try:
                        review.oxygen()
                    finally:
                        v._records=original
            result=json.loads((folder/'oxygen-variant-checks.json').read_text())
            outcomes.append({'width_mm':nominal,'report':str(folder/'oxygen-variant-checks.json'),
                             'sha256':candidate._sha(folder/'oxygen-variant-checks.json'),
                             'status':result['status'],'pass':result['status']=='bounded_reference_checks_clear' and
                             len(result['tests'])==2 and all(t['collision_count']==0 for t in result['tests'])})
    finally:
        parameter.expression=expression
        restored_compute=d.computeAll()
        _,restored=_snapshots()
        comparison=compare_physical(solids,restored,manager)
        after=checkpoint._state(d)
        preserved=before==after and protected==checkpoint._documents(app,doc)
        stable=all(candidate._sha(path)==digest for path,digest in sources.items())
        result={'generated_at_utc':datetime.now(timezone.utc).isoformat(),'document':doc.name,
            'source_sha256':sources,'tests':outcomes,'restored_compute':restored_compute,
            'all_physical_geometry_restored':comparison,'all_parameters_and_poses_restored':before==after,
            'source_and_protected_documents_preserved':preserved,'source_files_unchanged':stable,
            'health':review.health(d),'pass':len(outcomes)==2 and all(t['pass'] for t in outcomes) and
                restored_compute and comparison['pass'] and preserved and stable,
            'limits':['Actual AO2 path covered by each full eight-stage M3 width test; this receipt separately substitutes the three measured-relative JJ reference solids.',
                'JJ shared thread is owner-confirmed, but shoulder, retained nose and cable allowance remain unmeasured. Nose is excluded only from installed dry-body fit because its mating interface is unqualified.',
                'Other installed assemblies include current source-bound main/USB maxima, J301 mate and cable/turn volumes. Actual wires, gas sealing and flow response remain unqualified.',
                'Sampled rear withdrawal, not continuous swept-volume proof; no source or purchased component scaling.']}
        with (OUT/'summary.json').open('x')as stream:stream.write(json.dumps(result,indent=2)+'\n')
        candidate._require(preserved and restored_compute and comparison['pass'] and stable,'Oxygen trial failed exact restoration')
    return result
