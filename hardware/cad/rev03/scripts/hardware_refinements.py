"""Bounded hardware corrections, executed explicitly inside owned Rev03 Fusion.

Reproduction order for USB: usb_details.build_usb(), add_housing_clamp(),
fix_usb_geometry(), parameter_checks.bind_rear_hardware(), then this module's
change_usb_clamp_screw_to_m2x5(). The original USB stage records its initial
M2x6; this explicit correction replaces only the rear clamp screw. Importing
this module performs no CAD operations.

After the USB correction, external_rear_cover_button_heads() removes the
obsolete recessed-head/bearing-pad construction and positions the four M3x8
heads outside the full-thickness rear cover.
"""

import json
import adsk.fusion as fusion
import build_rev03 as b
from hardware_details import screw_instances


def _same_occurrence(first, second):
    return bool(first and second and first.fullPathName == second.fullPathName)


def change_usb_clamp_screw_to_m2x5():
    """Replace one joint-bound M2x6 with M2x5 at69.3,16,45.2 mm.

    M2x6 reaches the blind pilot floor at Z39.2 exactly. M2x5 retains3 mm of
    nominal axial insert overlap and leaves1 mm to that floor. This is geometric
    clearance only: actual threads, torque, inserts and printed strength remain
    unqualified. Shared M2x6 faceplate screw geometry is never edited.
    """
    _, design = b.get()
    root = design.rootComponent
    if root.attributes.itemByName(b.GROUP, 'usb_clamp_screw_m2x5'):
        raise RuntimeError('USB clamp screw correction already applied.')
    target_position = (69.3, 16.0, 45.2)
    if abs(b.mm(design, 'CaseWidth')-75.0) > 1e-6:
        raise RuntimeError('Run this bounded correction at the reviewed75 mm width.')
    matches = []
    for occurrence in root.occurrences:
        attribute = occurrence.component.attributes.itemByName(b.GROUP, 'hardware_definition')
        if not attribute:
            continue
        definition = json.loads(attribute.value)
        if (definition.get('kind') != 'screw' or definition.get('size') != 'M2'
                or abs(definition.get('length_mm', 0)-6) > 1e-8):
            continue
        translation = occurrence.transform2.translation
        position = (translation.x*10, translation.y*10, translation.z*10)
        if max(abs(a-e) for a, e in zip(position, target_position)) < 1e-5:
            matches.append(occurrence)
    if len(matches) != 1:
        raise RuntimeError('Expected exactly one M2x6 at the reviewed USB clamp seat.')
    old = matches[0]
    role = old.attributes.itemByName(b.GROUP, 'service_role')
    if not role or role.value != 'USB housing clamp screw':
        raise RuntimeError('The selected screw does not carry the USB clamp role.')
    if not old.attributes.itemByName(b.GROUP, 'joint_bound'):
        raise RuntimeError('Expected the clamp screw to have its native parametric joint.')
    joints = [joint for joint in root.joints
              if _same_occurrence(joint.occurrenceOne, old)
              or _same_occurrence(joint.occurrenceTwo, old)]
    if len(joints) != 1:
        raise RuntimeError('Expected exactly one clamp screw joint; refusing broader changes.')
    joint = joints[0]
    origin = fusion.JointOrigin.cast(joint.geometryOrOriginTwo)
    if (not origin or origin.parentComponent.id != root.id
            or not origin.name.startswith('Parametric mounting datum')):
        raise RuntimeError('The screw does not reference its expected dedicated root datum.')
    # Timeline indices identify the live origin without comparing opaque tokens.
    origin_index = origin.timelineObject.index
    references = []
    for other in root.joints:
        for entity in (other.geometryOrOriginOne, other.geometryOrOriginTwo):
            candidate = fusion.JointOrigin.cast(entity)
            if (candidate and candidate.parentComponent.id == root.id
                    and candidate.timelineObject.index == origin_index):
                references.append(other.name)
    if references != [joint.name]:
        raise RuntimeError('Clamp mounting datum has additional references: '+json.dumps(references))

    attributes = [(attribute.groupName, attribute.name, attribute.value)
                  for attribute in old.attributes if attribute.name != 'joint_bound']
    old_component = old.component
    occurrence_count = root.occurrences.count
    old_name, old_joint_name, old_origin_name = old.name, joint.name, origin.name
    if not joint.deleteMe():
        raise RuntimeError('Could not delete the old clamp screw joint.')
    if not origin.deleteMe():
        raise RuntimeError('Could not delete the dedicated clamp screw datum.')
    if not old.deleteMe():
        raise RuntimeError('Could not delete the old clamp screw occurrence.')
    replacement = screw_instances(root, 'M2', 5, [target_position],
                                   label='USB rear housing clamp M2x5 screw')[0]
    for group, name, value in attributes:
        replacement.attributes.add(group, name, value)
    replacement.attributes.add(b.GROUP, 'underhead_length_mm', '5')
    replacement.attributes.add(b.GROUP, 'hardware_correction',
                               'Replaced M2x6 to provide1 mm blind pilot floor clearance')
    replacement.attributes.add(b.GROUP, 'position_expressions',
                               json.dumps(['CaseWidth-5.7 mm', '16 mm', '45.2 mm']))
    old_component.attributes.add(b.GROUP, 'quantity',
                                 str(sum(o.component.id == old_component.id for o in root.occurrences)))
    from parameter_checks import bind_rear_hardware
    bind_rear_hardware()
    if not replacement.attributes.itemByName(b.GROUP, 'joint_bound'):
        raise RuntimeError('Replacement screw was not bound to its parametric datum.')
    if not design.computeAll():
        raise RuntimeError('Replacement screw did not recompute.')
    bounds = replacement.bRepBodies.item(0).boundingBox
    if abs(bounds.minPoint.z*10-40.2) > 1e-5 or abs(bounds.maxPoint.z*10-47.2) > 1e-5:
        raise RuntimeError('Replacement screw has unexpected installed BRep bounds.')
    if root.occurrences.count != occurrence_count:
        raise RuntimeError('Clamp screw correction changed the assembly occurrence count.')
    report = {
        'replaced_occurrence': old_name, 'new_occurrence': replacement.name,
        'removed_joint': old_joint_name, 'removed_dedicated_origin': old_origin_name,
        'screw_underhead_length_mm': 5, 'underhead_seat_mm': list(target_position),
        'screw_tip_z_mm': 40.2, 'blind_pilot_floor_z_mm': 39.2,
        'nominal_tip_to_floor_clearance_mm': 1.0, 'nominal_axial_insert_overlap_mm': 3.0,
        'limits': 'Nominal geometric overlap and clearance; actual thread engagement and retention are unqualified.',
    }
    root.attributes.add(b.GROUP, 'usb_clamp_screw_m2x5', json.dumps(report))
    path = b.BASE / 'verification' / 'usb-clamp-screw-correction.json'
    path.write_text(json.dumps(report, indent=2)+'\n', encoding='utf-8')
    b.checkpoint('USB clamp M2x5 blind-floor clearance')
    return report


def external_rear_cover_button_heads():
    """Restore the printed corner walls and use external M3 button heads.

    Deletes only four local cover-pad joins, four head-recess cuts, and all
    named housing pad-clearance cuts, in reverse timeline order. The four
    through-hole cuts remain. Independent root joint datums move screw seating
    to CaseDepth; screw definitions, inserts and all other parts are preserved.
    """
    _, design = b.get()
    root = design.rootComponent
    if root.attributes.itemByName(b.GROUP, 'rear_external_button_heads'):
        raise RuntimeError('External rear button-head correction already applied.')
    cover = b.comp('02 Single rear cover')
    housing = b.comp('01 Tapered printed housing')
    if cover.bRepBodies.count != 1 or housing.bRepBodies.count != 1:
        raise RuntimeError('Expected single-body housing and rear cover before correction.')
    specifications = [
        (cover, 'Local 2 mm screw bearing pad', (4,)),
        (cover, 'Recessed M3 button head', (4,)),
        (housing, 'Rear cover bearing pad clearance', (4, 8)),
    ]
    obsolete, counts = [], {}
    for component, prefix, allowed in specifications:
        selected = [feature for feature in component.features.extrudeFeatures
                    if feature.name == prefix or feature.name.startswith(prefix+' (')]
        if len(selected) not in allowed:
            raise RuntimeError(f'Unexpected count for {prefix}: {len(selected)}')
        obsolete.extend(selected)
        counts[prefix] = len(selected)
    through_holes = [feature for feature in cover.features.extrudeFeatures
                     if feature.name == 'Rear M3 through clearance'
                     or feature.name.startswith('Rear M3 through clearance (')]
    if len(through_holes) != 4:
        raise RuntimeError('Expected four independent rear M3 through holes.')
    seats = [(6.0, 6.0), (b.mm(design, 'CaseWidth-6 mm'), 6.0),
             (6.0, b.mm(design, 'CaseHeight-6 mm')),
             (b.mm(design, 'CaseWidth-6 mm'), b.mm(design, 'CaseHeight-6 mm'))]
    screw_data = []
    for occurrence in root.occurrences:
        attribute = occurrence.component.attributes.itemByName(b.GROUP, 'hardware_definition')
        if not attribute:
            continue
        definition = json.loads(attribute.value)
        if definition.get('kind') != 'screw' or definition.get('size') != 'M3':
            continue
        if definition.get('length_mm') != 8:
            raise RuntimeError('Unexpected M3 length in the owned assembly.')
        translation = occurrence.transform2.translation
        xy = translation.x*10, translation.y*10
        if not any(max(abs(a-v) for a, v in zip(xy, seat)) < 1e-5 for seat in seats):
            raise RuntimeError('An M3 screw is not at a reviewed rear-cover centre.')
        expression_attribute = occurrence.attributes.itemByName(b.GROUP, 'position_expressions')
        if not expression_attribute or not occurrence.attributes.itemByName(b.GROUP, 'joint_bound'):
            raise RuntimeError('Rear M3 screw lacks its native parametric binding.')
        expressions = json.loads(expression_attribute.value)
        joints = [joint for joint in root.joints
                  if _same_occurrence(joint.occurrenceOne, occurrence)
                  or _same_occurrence(joint.occurrenceTwo, occurrence)]
        if len(joints) != 1:
            raise RuntimeError('Rear M3 screw does not have exactly one native joint.')
        origin = fusion.JointOrigin.cast(joints[0].geometryOrOriginTwo)
        if not origin or origin.parentComponent.id != root.id:
            raise RuntimeError('Rear M3 screw does not use a root positioning datum.')
        screw_data.append((occurrence, origin, expressions))
    if len(screw_data) != 4:
        raise RuntimeError('Expected exactly four rear M3 screw occurrences.')
    occurrence_count = root.occurrences.count
    deleted = []
    for feature in sorted(obsolete, key=lambda feature: feature.timelineObject.index, reverse=True):
        name = feature.name
        if not feature.deleteMe():
            raise RuntimeError('Could not delete obsolete rear-cover feature: '+name)
        deleted.append(name)
    for occurrence, origin, expressions in screw_data:
        origin.offsetZ.expression = 'CaseDepth'
        expressions[2] = 'CaseDepth'
        occurrence.attributes.add(b.GROUP, 'position_expressions', json.dumps(expressions))
        occurrence.attributes.add(b.GROUP, 'hardware_position_mm',
                                  json.dumps([b.mm(design, value) for value in expressions]))
        occurrence.attributes.add(b.GROUP, 'head_seating', 'External button head on full-thickness rear cover')
    if not design.computeAll():
        raise RuntimeError('External rear-head correction did not recompute.')
    if cover.bRepBodies.count != 1 or housing.bRepBodies.count != 1:
        raise RuntimeError('Rear-head correction changed the housing/cover body count.')
    through_after = [feature for feature in cover.features.extrudeFeatures
                     if feature.name == 'Rear M3 through clearance'
                     or feature.name.startswith('Rear M3 through clearance (')]
    if len(through_after) != 4:
        raise RuntimeError('Rear-head correction altered the required through holes.')
    depth = b.mm(design, 'CaseDepth')
    cover_box = cover.bRepBodies.item(0).boundingBox
    expected_front = b.mm(design, 'CaseDepth-Cover+CoverGap')
    if abs(cover_box.minPoint.z*10-expected_front) > 1e-5 or abs(cover_box.maxPoint.z*10-depth) > 1e-5:
        raise RuntimeError('Rear cover does not retain its intended full thickness.')
    for occurrence, _, _ in screw_data:
        bounds = occurrence.bRepBodies.item(0).boundingBox
        if abs(bounds.minPoint.z*10-(depth-8)) > 1e-5 or abs(bounds.maxPoint.z*10-(depth+1.65)) > 1e-5:
            raise RuntimeError('External M3 screw has unexpected installed bounds.')
    if root.occurrences.count != occurrence_count:
        raise RuntimeError('Rear-head correction changed the assembly occurrence count.')
    from fusion_audit import _health
    health = _health(design)
    if health['unhealthy_entities']:
        raise RuntimeError('Rear-head correction left unhealthy entities: '+json.dumps(health['unhealthy_entities']))
    report = {
        'feature_counts_removed': counts, 'deleted_feature_names_reverse_order': deleted,
        'rear_cover_thickness_mm': round(depth-expected_front, 6),
        'screw_underhead_z_expression': 'CaseDepth', 'screw_underhead_z_mm': depth,
        'external_head_top_z_mm': depth+1.65, 'screw_length_mm': 8,
        'nominal_axial_insert_overlap_mm': 3.6,
        'nominal_tip_to_pilot_floor_clearance_mm': 1.85,
        'through_holes_preserved': 4, 'assembly_occurrences_preserved': occurrence_count,
        'health_pass': health['pass'],
        'remaining_underconstrained_sketches': [item['name'] for item in health['under_constrained_sketches']],
        'limits': 'Restores the removed corner stock and full cover thickness; not a whole-model wall, torque, retention or production-tolerance qualification.',
    }
    root.attributes.add(b.GROUP, 'rear_external_button_heads', json.dumps(report))
    path = b.BASE/'verification/rear-external-button-heads.json'
    path.write_text(json.dumps(report, indent=2)+'\n', encoding='utf-8')
    b.checkpoint('external rear M3 button heads and full cover')
    return report
