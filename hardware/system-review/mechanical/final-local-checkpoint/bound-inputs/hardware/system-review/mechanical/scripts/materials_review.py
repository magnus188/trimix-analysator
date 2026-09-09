"""Correct verified material families; never imply qualified FDM properties."""
import json
from runtime import owned,report,GROUP

def apply():
    app,doc,d=owned();changes=[]
    lib=next(x for x in app.materialLibraries if x.name=='Fusion Material Library')
    sources={k:lib.materials.itemById(v)for k,v in {'PET':'PrismMaterial-279','FR4':'PrismMaterial-401','Copper':'PrismMaterial-005','Brass':'PrismMaterial-003','Stainless':'PrismMaterial-017'}.items()}
    if any(v is None for v in sources.values()):raise RuntimeError('Required native material source unavailable')
    surrogate_name='PET-family surrogate — PETG print target (unqualified)'
    pet=d.materials.itemByName(surrogate_name) or d.materials.addByCopy(sources['PET'],surrogate_name)
    for c in d.allComponents:
        material=None;basis=None;old=c.material.name if c.material else None;old_name=c.name
        if c.partNumber in {'TMX-A3-P%02d'%i for i in range(1,12)}:
            material=pet;basis='PETG target; generic PET-family library surrogate only. PLA fit prototypes are separate. No filament/process qualification, FEA or mass claim.'
        elif c.partNumber.endswith('_PCB'):
            material=sources['FR4'];basis='Generic FR4 family for PCB dielectric; exact laminate and stack material are not qualified.'
        elif c.partNumber.endswith('_pad') or c.partNumber.endswith('_track') or c.partNumber.endswith('_via'):
            material=sources['Copper'];basis='Copper conductor family; no plating/finish or manufacturing thickness qualification.'
        elif c.partNumber=='TMX-A3-C05-V01':
            material=sources['Stainless'];basis='GCT datasheet specifies stainless shell; exact grade unspecified.'
        elif c.partNumber=='TMX-A3-C05-V03':
            material=sources['Copper'];basis='GCT specifies copper-alloy contacts; pure copper is a visual/material-family surrogate, not alloy qualification.'
        if c.partNumber=='TMX-A3-P09':
            c.name='USB A3 — printed bezel and hidden flange'
            for q in c.bRepBodies:
                if q.name=='Tiny flush metal bezel':q.name='Printed flush USB bezel'
        elif c.partNumber=='TMX-A3-P10':
            c.name='USB A3 — printed retaining bridge'
            for q in c.bRepBodies:
                if q.name=='Hidden USB common retaining bridge':q.name='Printed USB retaining bridge'
        if material:
            c.material=material;c.attributes.add(GROUP,'material_basis',basis)
            c.attributes.add(GROUP,'material_properties_qualified','false')
            changes.append({'part':c.partNumber,'old_name':old_name,'name':c.name,'old_material':old,'new_material':c.material.name,'basis':basis})
        elif c.bRepBodies.count:
            c.attributes.add(GROUP,'material_basis','Unverified assembly or constituent. Inherited library material is not a confirmed specification; exclude from mass/FEA claims.')
            c.attributes.add(GROUP,'material_properties_qualified','false')
    d.rootComponent.attributes.add(GROUP,'mass_and_FEA_status','NOT QUALIFIED: print material uses PET-family surrogate and purchased assemblies have unverified constituent properties.')
    report('material-corrections.json',{'document':doc.name,'changes':changes,'printed_component_count':sum(x['part'].startswith('TMX-A3-P') for x in changes),
        'geometry_changed':False,'mass_or_FEA_qualification':False})

def gasket():
    """Use the manufacturer's stated silicone family, without seal mechanics."""
    app,doc,d=owned()
    lib=next(x for x in app.materialLibraries if x.name=='Fusion Material Library')
    source=lib.materials.itemById('PrismMaterial-029')
    if not source or 'silicone' not in source.name.lower():raise RuntimeError('Expected native silicone family')
    c=next(c for c in d.allComponents if c.partNumber=='TMX-A3-C05-V04')
    old=c.material.name
    name='Silicone-family surrogate — GCT 60A gasket (unqualified properties)'
    material=d.materials.itemByName(name) or d.materials.addByCopy(source,name)
    c.material=material
    c.attributes.add(GROUP,'material_basis','GCT Rev B specifies LIM silicone 60A. Native silicone-family surrogate; hardness/constitutive curve/compression/friction not qualified.')
    c.attributes.add(GROUP,'material_properties_qualified','false')
    report('gct-gasket-material.json',{'document':doc.name,'part':c.partNumber,'old_material':old,
        'material':c.material.name,'source_material':source.name,'manufacturer_specification':'LIM silicone 60A',
        'geometry_changed':False,'seal_simulation_or_IP_qualification':False})

def insulator():
    """Record specified PA9T with an explicit broad polyamide-family surrogate."""
    app,doc,d=owned()
    lib=next(x for x in app.materialLibraries if x.name=='Fusion Material Library')
    source=lib.materials.itemById('PrismMaterial-023')
    if not source or source.name!='Nylon 6/6':raise RuntimeError('Expected native polyamide-family source')
    c=next(c for c in d.allComponents if c.partNumber=='TMX-A3-C05-V02')
    old=c.material.name;name='Polyamide-family surrogate — GCT PA9T (properties unqualified)'
    c.material=d.materials.itemByName(name) or d.materials.addByCopy(source,name)
    c.attributes.add(GROUP,'material_basis','GCT Rev B specifies PA9T UL94V-0 black. Native Nylon6/6 is only a broad polyamide-family surrogate; not PA9T mechanical, thermal, dielectric or flammability qualification.')
    c.attributes.add(GROUP,'material_properties_qualified','false')
    report('gct-insulator-material.json',{'document':doc.name,'part':c.partNumber,'old_material':old,'material':c.material.name,
        'manufacturer_specification':'PA9T, UL94V-0, black','native_surrogate_source':source.name,
        'geometry_changed':False,'mass_FEA_or_material_qualification':False})
