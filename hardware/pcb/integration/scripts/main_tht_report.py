"""Read the placed board and report carrier relief inputs; never edit CAD.

KiCad model bounds are drawing-library references, not measured purchased parts.
Lead/solder envelopes remain a qualification item; no drill-only fit assertion.
"""
from pathlib import Path
import hashlib
import json
import pcbnew as p

HW=Path(__file__).resolve().parents[3]
BOARD=HW/'pcb/analyzer/Trimix_Analyzer.kicad_pcb'
MODELS=Path('/Applications/KiCad/KiCad.app/Contents/SharedSupport/3dmodels')

def run():
    b=p.LoadBoard(str(BOARD));parts=[];thermal=[];cache={}
    frame=json.loads((HW/'pcb/integration/verification/main-step-frame.json').read_text())
    seating=frame['component_seating_plane_z_mm']
    translation_z=21.3-(frame['bounds_mm']['min'][2]+frame['bounds_mm']['max'][2])/2
    exported_fusion_seat=seating+translation_z
    for f in sorted(b.GetFootprints(),key=lambda q:q.GetReference()):
        if f.IsDNP() or f.GetReference().startswith('H'):continue
        pads=[]
        for pad in f.Pads():
            if pad.GetAttribute()!=p.PAD_ATTRIB_PTH:continue
            point=pad.GetPosition();size=pad.GetSize();drill=pad.GetDrillSize()
            row={'pin':pad.GetNumber(),'net':pad.GetNetname(),
                 'local_xy_mm':[p.ToMM(point.x),p.ToMM(point.y)],
                 'fusion_xy_mm':[50.4+p.ToMM(point.x),120-p.ToMM(point.y)],
                 'pad_size_mm':[p.ToMM(size.x),p.ToMM(size.y)],
                 'drill_size_mm':[p.ToMM(drill.x),p.ToMM(drill.y)],
                 'pad_angle_deg':pad.GetOrientationDegrees(),'shape_code':pad.GetShape()}
            if f.GetReference() in ('U101','U201'):
                row['reference']=f.GetReference();thermal.append(row)
            else:pads.append(row)
        if not pads:continue
        models=[]
        for model in f.Models():
            name=model.m_Filename.replace('${KICAD10_3DMODEL_DIR}',str(MODELS))
            item={'path':name,'scale':[model.m_Scale.x,model.m_Scale.y,model.m_Scale.z],
                  'rotation_deg':[model.m_Rotation.x,model.m_Rotation.y,model.m_Rotation.z],
                  'offset_mm':[model.m_Offset.x,model.m_Offset.y,model.m_Offset.z]}
            if not Path(name).is_file():
                item['status']='model_missing'
            elif model.m_Rotation.x or model.m_Rotation.y:
                item['status']='rotated_model_z_bounds_not_evaluated'
            else:
                if name not in cache:
                    raw=p.UTILS_STEP_MODEL.LoadSTEP(name).GetBoundingBox()
                    cache[name]=[raw.Min().z,raw.Max().z]
                z=[q*model.m_Scale.z+model.m_Offset.z for q in cache[name]]
                item.update(status='native_KiCad_STEP_model_bounds',model_z_relative_FCu_mm=z,
                            nominal_fusion_z_mm=[22.1+q for q in z],
                            actual_exported_fusion_z_mm=[exported_fusion_seat+q for q in z],
                            protrusion_below_nominal_board_back_mm=max(0,-1.6-min(z)))
            models.append(item)
        parts.append({'reference':f.GetReference(),'value':f.GetValue(),'footprint':f.GetFPIDAsString(),
                      'pads':pads,'models':models})
    result={'status':'carrier_relief_inputs_not_physical_solder_qualification',
            'board_sha256':hashlib.sha256(BOARD.read_bytes()).hexdigest(),
            'registration':'Fusion X=50.4+localX, Y=120-localY; back Z20.5, FCu Z22.1 mm',
            'exporter_registration':{'step_to_fusion_z_translation_mm':translation_z,
                'component_model_base_step_z_mm':seating,'component_model_base_fusion_z_mm':exported_fusion_seat,
                'measured_gap_above_exported_front_copper_mm':round(seating-frame['with_nominal_pads_bounds_mm']['max'][2],6),
                'scope':'Native one-component STEP measured model seating0.05mm above nominal pad copper. Enclosure alignment centres1.51mm dielectric at21.3 for1.6mm nominal stack20.5..22.1.'},
            'fitted_through_hole_footprints':len(parts),'fitted_through_hole_pads':sum(len(q['pads'])for q in parts),
            'parts':parts,'thermal_via_pad_drills_not_component_leads':thermal,
            'proposed_relief_allowance':{'lateral_beyond_copper_pad_edge_mm':0.5,
               'scope':'Conservative initial solder/assembly space around native pad extents, not validated solder fillet dimensions.',
               'depth':'Use actual modeled lead lower Z plus assembly allowance; unmodeled wire ends and solder height require measurement/coupon.',
               'carrier_web_minimum_mm':2.0,'status':'proposal_only'},
            'limits':['Connector/header/trimmer SKU and lead length are not all verified.',
                      'U101/U201 plated thermal drills have no protruding lead and are reported separately.',
                      'No solder fillet bodies are modeled. Copper pad plus0.5mm is an initial clearance proposal, not a standard-derived solder envelope.',
                      'J402 uses a scaled SMA body reference for an SMB footprint. Its body/lead bounds do not validate real SMB hardware.']}
    out=HW/'pcb/integration/verification/main-through-hole-relief.json';out.write_text(json.dumps(result,indent=2)+'\n')
    print(json.dumps({'path':str(out),'footprints':len(parts),'pads':result['fitted_through_hole_pads']}))

if __name__=='__main__':run()
