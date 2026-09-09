"""Actual native M3 material/interface checks and bounded width endpoints."""
from contextlib import contextmanager
from datetime import datetime, timezone
from pathlib import Path
import json
import adsk.fusion as fusion
from runtime import BASE, GROUP, owned, configure, bounds
import m3_candidate_audit as candidate

OUT = BASE/'verification/m3-implementation'


def _write(directory, name, data):
    directory.mkdir(parents=True, exist_ok=True)
    with (directory/name).open('x') as stream:
        stream.write(json.dumps(data, indent=2)+'\n')
    return data


def _pairs():
    _,_,d = owned()
    marker = d.rootComponent.attributes.itemByName(GROUP,'m3_proposal_sha256')
    source = d.rootComponent.attributes.itemByName(GROUP,'m3_source_sha256')
    candidate._require(marker and marker.value == candidate.PROPOSAL_SHA and source and source.value == candidate.SOURCE_SHA, 'Adopted exact M3 source marker missing')
    rows = json.loads(d.rootComponent.attributes.itemByName(GROUP,'m3_interfaces').value)
    candidate._require(len(rows) == 4 and len({r['occurrence'] for r in rows}) == 4, 'M3 instance contract changed')
    return rows


def material(manager, physical):
    """Exact assigned pilot/thread pairs and whole nominal crest annuli."""
    import verification_a3 as v
    import wall_fastener_checks as fasteners
    import ruthex_m2_audit as rx
    import m3_service_audit as service
    _,_,design = owned()
    pairs = _pairs()
    hardware = fasteners._hardware_records(design, physical)
    hw = {r['occurrence']:r for r in hardware}
    by_name = {r['occurrence']:r for r in physical}
    hosts = [r for r in physical if r['component'] == '01 Shape A housing']
    candidate._require(len(hosts) == 1, 'Expected one actual housing')
    host = hosts[0]
    pilot_surfaces = rx.cylinders(host['body'])
    placements = []
    sections = []
    heatsets = []
    for pair in pairs:
        row = by_name[pair['occurrence']]
        h = hw[pair['occurrence']]
        definition = h['hardware']
        candidate._require(definition['external_step_sha256'] == candidate.SOURCE_SHA and
                           definition['length_mm'] == 4 and definition['outer_diameter_mm'] == 5 and
                           definition['nominal_thread_pitch_mm'] == .5 and h['joint_bound'] and
                           h['target_position_error_mm'] < .001, 'M3 source/pose/size changed')
        x,y,z = h['head_seat_mm']
        placements.append({'original_occurrence':row['occurrence'], 'paired_screw':pair['paired_screw'],
                           'open_face_mm_at_width85':[x,y,z]})
        annulus = candidate._ring(manager,x,y,z-4,z,2.5,4.5)
        missing = candidate._difference_volume(manager,annulus,host['body'])
        bore = rx._cylinder(manager,x,y,z-5+.0001,z-.0001,2.2-.0001)
        bore_hits = rx._intersections(manager,bore,[host])
        pilots=[s for s in pilot_surfaces if abs(s['radius_mm']-2.2)<1e-6 and
                max(abs(a-b) for a,b in zip(s['origin_mm'][:2],[x,y]))<1e-6 and
                abs(abs(s['axis'][2])-1)<1e-7 and abs(s['bounds_mm'][1][2]-z)<1e-5]
        candidate._require(len(pilots)==1,'Expected one full native cylindrical M3 pilot at the assigned axis')
        actual_depth=z-pilots[0]['bounds_mm'][0][2]
        # Narrow existing screw-tip relief deliberately interrupts the centre
        # of the blind floor; the surrounding annular floor remains 2mm thick.
        floor = candidate._ring(manager,x,y,z-7,z-5,1.6001,2.1999)
        missing_floor = candidate._difference_volume(manager,floor,host['body'])
        tip = fasteners._tip_probe(manager,hw[pair['paired_screw']],physical)
        overlap = manager.copy(row['body'])
        candidate._require(manager.booleanOperation(overlap,host['body'],fusion.BooleanTypes.IntersectionBooleanType), 'Actual M3 pilot displacement intersection failed')
        candidate._require(overlap.volume*1000 > 1e-5, 'Expected exact M3 pilot displacement absent')
        displacement_band = candidate._ring(manager,x,y,z-4-.0001,z+.0001,2.2-.0001,2.5+.0001)
        outside = candidate._difference_volume(manager,overlap,displacement_band)
        heatsets.append({'one':v._label(row), 'two':v._label(host), 'volume_mm3':overlap.volume*1000,
            'explicit_interface':pair, 'source_step_sha256':candidate.SOURCE_SHA,
            'pilot_radius_mm':2.2, 'source_crest_radius_mm':2.5, 'expected_Z_mm':[z-4,z],
            'boolean_boundary_padding_mm':.0001, 'outside_expected_displacement_band_mm3':outside,
            'pass':outside < 1e-5,
            'interpretation':'Only this exact source insert and its assigned printed pilot; nominal material displacement during heatsetting. Actual retention is unqualified.'})
        sections.append({'insert':row['occurrence'], 'face_mm':[x,y,z],
            'whole_crest_annulus':{'radii_mm':[2.5,4.5], 'Z_mm':[z-4,z], 'missing_material_mm3':missing, 'pass':missing<1e-5},
            'full_circular_pilot_depth':{'nominal_mm':5, 'actual_surface_depth_mm':actual_depth,
                                       'actual_surface':pilots[0], 'proved_interior_depth_mm':4.9998, 'probe_radius_mm':2.1999,
                                       'intersections':bore_hits, 'pass':not bore_hits and actual_depth>=5-1e-5},
            'preserved_annular_floor':{'radii_mm':[1.6001,2.1999], 'Z_mm':[z-7,z-5], 'nominal_thickness_mm':2,
                                      'missing_material_mm3':missing_floor, 'pass':missing_floor<1e-5,
                                      'limits':'The centre has the intentional smaller screw-tip relief; this is not a full-disk sealed-floor claim.'},
            'tip_probe':tip, 'pass':missing<1e-5 and not bore_hits and actual_depth>=5-1e-5 and missing_floor<1e-5 and tip['passes_selected_nominal_gap']})
    threads = service._thread(manager,{'candidate_placements_for_later_review':placements},by_name,hw)
    return {'generated_at_utc':datetime.now(timezone.utc).isoformat(),
            'source_step_sha256':candidate.SOURCE_SHA, 'proposal_sha256':candidate.PROPOSAL_SHA,
            'width_mm':design.userParameters.itemByName('CaseWidth').value*10,
            'interfaces':sections, 'heatset_interfaces':heatsets, 'thread_interfaces':threads,
            'housing_solid_lumps':host['body'].lumps.count,
            'pass':all(r['pass'] for r in sections+heatsets) and all(r['pass_representation_confinement'] for r in threads) and host['body'].lumps.count==1,
            'whole_assembly_minimum_wall_proven':False, 'physical_thread_retention_or_torque_qualified':False}


@contextmanager
def adapted(directory):
    configure()
    from short_m2_validation import adapted as m2_adapted
    import review_checks as review
    import width_contract_checks as width
    import verification_a3 as v
    import gas_checks_a3 as gas
    with m2_adapted(directory):
        previous_collision = review.collision_report
        previous_sections = width.selected_sections
        cache = {}
        def measured(manager=None,physical=None):
            _,_,d = owned()
            key = d.userParameters.itemByName('CaseWidth').value
            if key not in cache:
                if manager is None:
                    manager,physical = review.records()
                    physical = [r for r in physical if r['physical_group'] != 'alternative_oxygen_reference']
                cache[key] = material(manager,physical)
                _write(directory/('W'+str(round(key*10))), 'native-M3-material.json', cache[key])
            return cache[key]
        def collision(manager,physical):
            raw = previous_collision(manager,physical)
            proof = measured(manager,physical)
            candidate._require(proof['pass'], 'Actual M3 material/interface gate failed')
            labels = {r['occurrence']:v._label(r) for r in physical}
            host_pairs = {frozenset((q['one'],q['two'])):q for q in proof['heatset_interfaces']}
            thread_pairs = {frozenset((labels[q['insert']],labels[q['screw']])):q for q in proof['thread_interfaces']}
            hosts=[];threads=[];unrelated=[]
            for hit in raw['collisions']:
                pair = frozenset((hit['one'],hit['two']))
                if pair in host_pairs:
                    hosts.append(dict(hit,confinement=host_pairs[pair]))
                elif pair in thread_pairs:
                    threads.append(dict(hit,confinement=thread_pairs[pair],
                        classification='Exact specified smooth nominal M3 screw/female-thread CAD representation pair; physical thread fit remains unqualified.'))
                else:
                    unrelated.append(hit)
            candidate._require(len(hosts)==4 and len(threads)==4, 'Require all four actual pilot and all four actual shaft/thread pairs')
            raw.update(collisions=unrelated,M3_heatset_interfaces=hosts,M3_thread_representation_interfaces=threads,
                       all_positive_intersection_count=raw['all_positive_intersection_count'],
                       M3_classification_limits='Only eight exact occurrence/source-bound pairs with entire positive-volume confinement proofs; no unrelated intersection exemption.')
            return raw
        def sections():
            data=previous_sections()
            proof=measured()
            _,_,d=owned()
            gas_result=gas._gas_result(d)
            _write(directory/('W'+str(round(d.userParameters.itemByName('CaseWidth').value*10))), 'gas.json', gas_result)
            data.update({'M3_actual_material_pass':proof['pass'], 'gas_pass':gas_result['pass'],
                         'pass':data['pass'] and proof['pass'] and gas_result['pass']})
            return data
        review.collision_report=collision
        width.selected_sections=sections
        try:
            yield
        finally:
            review.collision_report=previous_collision
            width.selected_sections=previous_sections


def trial85():
    return trial(85)


def trial87():
    return trial(87)


def trial(value):
    import width_contract_checks as width
    directory=OUT/'width-tests'
    candidate._require(not (directory/('W'+str(value))/'trial-summary.json').exists(), 'Preserve completed endpoint receipt')
    with adapted(directory):
        return width.trial(value)
