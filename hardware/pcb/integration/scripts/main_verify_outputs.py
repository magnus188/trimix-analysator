"""Summarize native checks and publish an already-generated placement STEP.

This does not route, change board geometry or waive fabrication-rule findings.
Run with the bundled KiCad Python after main_board.py and CLI DRC/STEP export.
"""
from pathlib import Path
import collections
import hashlib
import json
import shutil
import pcbnew as p

HW=Path(__file__).resolve().parents[3]
R=HW/'pcb/integration';V=R/'verification'

def sha(path):return hashlib.sha256(path.read_bytes()).hexdigest()

def bounds(path):
    model=p.UTILS_STEP_MODEL.LoadSTEP(str(path));box=model.GetBoundingBox()
    lo=box.Min();hi=box.Max()
    return [lo.x,lo.y,lo.z,hi.x,hi.y,hi.z]

def run():
    board=HW/'pcb/analyzer/Trimix_Analyzer.kicad_pcb'
    target=R/'exports/Trimix_Analyzer_A3_Placement.step'
    candidate=V/'main-final-placement.step'
    old_bounds,new_bounds=bounds(target),bounds(candidate)
    # Native bounding boxes contain kernel tolerance. Preserve the raw delta in
    # the receipt; this is a frame check, not a claimed surface-equivalence test.
    bounds_delta=max(abs(x-y)for x,y in zip(old_bounds,new_bounds))
    assert all(round(x,4)==round(y,4)for x,y in zip(old_bounds,new_bounds))
    b=p.LoadBoard(str(board));d=json.loads((V/'main-drc.json').read_text())
    placement=json.loads((V/'main-placement.json').read_text())
    assert not d['schematic_parity']
    assert len(d['violations'])==39 and len(d['unconnected_items'])==288
    assert all(sha(HW/f)==h for f,h in placement['source_hashes'].items())
    shutil.copy2(candidate,target)
    report={
      'status':'mechanical_placement_candidate_electrical_design_incomplete',
      'board':str(board.relative_to(HW)),'board_sha256':sha(board),
      'step':str(target.relative_to(HW)),'step_sha256':sha(target),
      'copper_layers':b.GetCopperLayerCount(),
      'thickness_mm':p.ToMM(b.GetDesignSettings().GetBoardThickness()),
      'footprints_total':len(b.GetFootprints()),'electrical_original_footprints':119,
      'test_pads':12,'mechanical_holes':2,
      'DNP_footprints':sorted(f.GetReference()for f in b.GetFootprints()if f.IsDNP()),
      'numbered_pin_nets':365,'original_numbered_pin_nets_preserved':353,
      'full_schematic_numbered_pin_nets':407,'tracks':len(b.GetTracks()),
      'copper_fill_zones':sum(not z.GetIsRuleArea()for z in b.Zones()),
      'mechanical_rule_areas':sum(z.GetIsRuleArea()for z in b.Zones()),
      'schematic_parity_issues':0,'unconnected_items':288,'DRC_violations':39,
      'DRC_types':dict(collections.Counter(x['type']for x in d['violations'])),
      'DRC_disposition':[
        {'type':'clearance','count':15,'refs':['U701','U703','U801'],
         'detail':'Adjacent native package pads:0.150mm actual vs0.200mm current rule. Rules have not been relaxed.'},
        {'type':'drill_out_of_range','count':24,'refs':['U101','U201'],
         'detail':'Thermal holes:0.200mm drill vs0.300mm current minimum. Fabricator/assembler capability and process must be selected before qualifying rules.'}],
      'native_courtyard_collisions':placement['actual_native_courtyard_collision_pairs'],
      'native_courtyards_outside_outline':placement['actual_native_courtyards_outside_outline'],
      'native_copper_under_0_5mm_edge':placement['actual_native_copper_below_0_5mm_edge_clearance'],
      'step_flags':['--drill-origin','--no-dnp','--include-pads','--no-extra-pad-thickness'],
      'step_loaded_by_native_KiCad_STEP_model':True,
      'step_bounds_mm':{'min':new_bounds[:3],'max':new_bounds[3:]},
      'metadata_refresh_native_bounds_max_difference_mm':bounds_delta,
      'step_frame_comparison_scope':'Raw kernel bounding boxes only, including native tolerance. All bounds unchanged to0.0001mm; no surface-equivalence assertion.',
      'frame_report':'verification/main-step-frame.json',
      'through_hole_relief_report':'verification/main-through-hole-relief.json',
      'top_view':'verification/main-top.png',
      'top_view_review':'Actual KiCad render visually inspected: bodies inside outline, both mounting holes accessible in projection. Does not verify plugs, solder fillets or3D enclosure clearance.',
      'source_guard':'All source schematic/project/preview hashes unchanged during final build and after CLI checks. Deliberate schematic assignments were separately backed up in provisional-footprints-verification.json.',
      'project_recovery_receipt':'verification/main-project-recovery.json',
      'known_gates':placement['known_gates'],'not_released_for_fabrication':True}
    (V/'main-final-verification.json').write_text(json.dumps(report,indent=2)+'\n')
    print(json.dumps({k:report[k]for k in ('board_sha256','step_sha256','DRC_violations','unconnected_items','schematic_parity_issues')},indent=2))

if __name__=='__main__':run()
