"""Read-only dependency inventory for the proposed rigid-PCB width contract.

No parameter/occurrence/feature setter is called. No documents are activated,
saved, or closed. Correction and regeneration require a separately reviewed stage.
"""
from runtime import owned, report, bounds, attrs, other_documents


def inventory():
    app, doc, design = owned()
    before = other_documents(app)
    baseline = {'name': doc.name, 'id': doc.dataFile.id, 'modified': doc.isModified,
                'timeline': design.timeline.count}
    parameters = []
    for parameter in design.allParameters:
        owner = getattr(parameter, 'createdBy', None)
        component = getattr(owner, 'parentComponent', None) if owner else None
        parameters.append({'name': parameter.name, 'expression': parameter.expression,
                           'value_internal': parameter.value, 'unit': parameter.unit,
                           'owner': owner.name if owner else None,
                           'owner_type': owner.objectType if owner else None,
                           'component': component.name if component else None})
    components = []
    for occurrence in design.rootComponent.occurrences:
        component = occurrence.component
        if component.partNumber not in ('TMX-A3-P01','TMX-A3-P02','TMX-A3-P03','TMX-A3-P04',
                                        'TMX-A3-P05','TMX-A3-P06','TMX-A3-B01','TMX-A3-B02'):
            continue
        components.append({'name': component.name, 'part': component.partNumber,
            'occurrence': occurrence.fullPathName, 'transform': occurrence.transform2.asArray(),
            'bounds_mm': bounds(occurrence), 'attributes': attrs(component),
            'occurrence_attributes': attrs(occurrence),
            'bodies': [{'name': body.name, 'bounds_mm': bounds(body),
                        'volume_mm3': body.volume*1000, 'attributes': attrs(body)}
                       for body in occurrence.bRepBodies],
            'features': [{'name': feature.name, 'type': feature.objectType,
                          'index': feature.timelineObject.index if feature.timelineObject else None,
                          'suppressed': feature.isSuppressed}
                         for feature in component.features],
            'sketches': [{'name': sketch.name, 'index': sketch.timelineObject.index,
                          'attributes': attrs(sketch)} for sketch in component.sketches]})
    occurrences = [{'name': o.fullPathName, 'part': o.component.partNumber,
                    'transform': o.transform2.asArray(), 'bounds_mm': bounds(o),
                    'attributes': attrs(o), 'component_attributes': attrs(o.component)}
                   for o in design.rootComponent.occurrences]
    joints = [{'name': j.name, 'occurrence_one': j.occurrenceOne.fullPathName if j.occurrenceOne else None,
               'occurrence_two': j.occurrenceTwo.fullPathName if j.occurrenceTwo else None,
               'attributes': attrs(j), 'index': j.timelineObject.index} for j in design.rootComponent.joints]
    assert baseline == {'name': doc.name, 'id': doc.dataFile.id, 'modified': doc.isModified,
                        'timeline': design.timeline.count}, 'Owned state changed during read-only inventory'
    assert before == other_documents(app), 'Other document state changed during inventory'
    report('width-contract-full-inventory.json', {'document': baseline,
        'root_attributes': attrs(design.rootComponent), 'parameters': parameters,
        'components': components, 'occurrences': occurrences, 'joints': joints,
        'other_documents_before_after': before, 'read_only': True})
