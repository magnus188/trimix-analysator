"""Offline M3 proposal scaffold. Reads cached evidence; never imports or calls Fusion."""
from datetime import datetime, timezone
import hashlib
import json
import math
from pathlib import Path
import struct

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[4]
MECH = ROOT / "hardware/system-review/mechanical"


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def build():
    review_path = MECH / "components/cnckitchen-m3-review/source-review.json"
    old_path = MECH / "verification/width-contract-full-inventory.json"
    recent_path = MECH / "verification/ruthex-m2-native-inventory.json"
    walls_path = MECH / "verification/selected-wall-fastener-checks.json"
    source_paths = [review_path, old_path, recent_path, walls_path,
                    ROOT / "hardware/cad/rev04/scripts/build_a3.py",
                    ROOT / "hardware/cad/rev04/scripts/service_refine_a3.py"]
    review = json.loads(review_path.read_text())
    assert review["status"] == "SOURCE_REVIEWED_CANDIDATE_NOT_ADOPTED"
    for name, expected in review["file_hashes"].items():
        path = review_path.parent / name
        assert sha(path) == expected, str(path)
        source_paths.append(path)
    for key in ("poster", "archive"):
        path = ROOT / review[key + "_path"]
        assert sha(path) == review[key + "_sha256"], str(path)
        source_paths.append(path)
    before = {str(p.relative_to(ROOT)): sha(p) for p in source_paths}
    old = json.loads(old_path.read_text())
    recent = json.loads(recent_path.read_text())
    walls = json.loads(walls_path.read_text())
    params = {p["name"]: p for p in old["parameters"]}
    latest = {p["name"]: p for f in recent["features"] for p in f["parameters"]}
    bosses = ["d267", "d317", "d367", "d417"]
    pilots = ["d274", "d324", "d374", "d424"]
    changes = []
    for names, expected, proposed in ((bosses, "4.2 mm", "4.5 mm"),
                                      (pilots, "2.15 mm", "2.2 mm")):
        for name in names:
            p = params[name]
            assert p["expression"] == expected
            if name in latest:
                assert latest[name]["expression"] == expected
            changes.append({"name": name, "component": p["component"],
                            "owner": p["owner"], "owner_type": p["owner_type"],
                            "expected_expression": expected, "proposed_expression": proposed,
                            "quantity": "radius_mm", "fresh_native_precondition_required": True})
    protected = [p for p in old["parameters"]
                 if p["name"] not in bosses + pilots and any(s in (p.get("owner") or "")
                 for s in ("Rear boss end-wall web", "Rear M3 boss", "M3 insert pilot",
                           "M3 blind screw tip clearance", "Reinforced rear screw seat",
                           "M3 screw clearance", "Flush M3 head recess"))]
    inserts = [o for o in old["occurrences"] if o.get("part") == "TMX-A3-F04"]
    assert len(inserts) == 4
    placements = []
    for o in inserts:
        attrs = o["attributes"]
        pose = json.loads(attrs["TrimixRev04/position_expressions"])
        assert pose[2] == "CaseDepth-4 mm"
        pair = next(p for p in walls["fastener_pairs"] if p.get("insert") == o["name"])
        joint = next(j for j in old["joints"] if j["occurrence_one"] == o["name"])
        placements.append({"original_occurrence": o["name"], "rollup": o["part"],
                           "saved_joint": joint, "position_expressions": pose,
                           "saved_transform_internal_cm": o["transform"],
                           "open_face_mm_at_width85": json.loads(attrs["TrimixRev04/hardware_position_mm"]),
                           "axis": [0, 0, 1], "paired_screw": pair["screw"],
                           "source_model_bounds_z_mm": [0, 4],
                           "candidate_model_translation_from_open_face_mm": [0, 0, -4],
                           "candidate_model_scale": [1, 1, 1],
                           "replacement_authorized_here": False})
    stl = (review_path.parent / "M3x5x4_VORON_manufacturer.stl").read_bytes()
    count = struct.unpack_from("<I", stl, 80)[0]
    assert len(stl) == 84 + count * 50
    lo, hi = [math.inf]*3, [-math.inf]*3
    for i in range(count):
        values = struct.unpack_from("<12f", stl, 84+i*50)
        for j in range(3):
            for axis in range(3):
                v = values[3+3*j+axis]
                lo[axis], hi[axis] = min(lo[axis], v), max(hi[axis], v)
    assert lo == review["STL"]["bounds_min_mm"] and hi == review["STL"]["bounds_max_mm"]
    optional_webs = []
    for i in range(4):
        xname, wname = f"d{257+50*i}", f"d{259+50*i}"
        axis = "8 mm" if i in (0, 2) else "CaseWidth - 8 mm"
        optional_webs.append({"owner": params[xname]["owner"],
                              "conditional_only_not_in_eight_change_set": True,
                              "changes": [
                                  {"name": xname, "expected_expression": params[xname]["expression"],
                                   "possible_expression": f"({axis}) - 4.5 mm"},
                                  {"name": wname, "expected_expression": "7.4 mm", "possible_expression": "9 mm"}],
                              "trigger": "Only a later native material/connectivity witness demonstrating necessity; reassess chamber/service clearance before widening."})
    data = {
        "generated_at_utc": datetime.now(timezone.utc).isoformat(),
        "status": "OFFLINE_PREPARED_FOR_TRANSIENT_ASSESSMENT_NOT_ADOPTED",
        "native_calls": 0, "native_geometry_changed": False, "BOM_changed": False,
        "scope": "Four rear-cover M3 insert hosts only; later transient assessment is authorized, adoption is not.",
        "candidate": {k: review[k] for k in ("manufacturer", "manufacturer_product_name", "EAN", "MPN", "nominal_mm")},
        "source_sha256": before,
        "cached_document_evidence": {"full_inventory": old["document"],
                                     "later_pilot_inventory": {k: recent[k] for k in ("document", "data_id", "version", "timeline", "generated_at_utc")},
                                     "live_document_guard": None,
                                     "limitation": "Saved v7/v8 evidence is not a current-document assertion after M2 and final-PCB integration. Rebase and check names, owners, expressions, datums, current version and timeline before transient work."},
        "parameter_change_count": len(changes), "parameter_changes": changes,
        "protected_parameter_expressions": protected,
        "candidate_placements_for_later_review": placements,
        "stl_bounds_independently_recomputed": {"triangles": count, "min_mm": lo, "max_mm": hi},
        "nominal_axial_stack_at_depth43_mm": {
            "boss_and_web": [30, 39], "full_radius_pilot_material_depth": [34, 39],
            "pilot_cut_extent_with_top_overshoot": [34, 39.1], "candidate_insert": [35, 39],
            "blind_depth": 5, "clear_depth_below_candidate": 1,
            "retained_narrow_tip_cut": {"z": [33, 35], "radius": 1.6},
            "unchanged_nominal_screw": {"under_head_z": 41.35, "tip_z": 33.35, "length": 8,
                                        "nominal_candidate_axial_overlap": 4, "extends_below_candidate_bottom": 1.65},
            "physical_thread_engagement_qualified": False,
            "limitation": "Source arithmetic only; candidate bore, chamfers, actual screw and final-body floor remain native/physical checks."},
        "web_analysis": {
            "current_width": 7.4, "half_width": 3.7, "current_boss_radius": 4.2, "candidate_boss_radius": 4.5,
            "crest_radius": 2.5, "candidate_pilot_radius": 2.2,
            "candidate_full_circle_material_from_crest": 2.0,
            "candidate_full_circle_material_from_pilot": 2.3,
            "web_alone_material_from_crest": 1.2,
            "web_alone_material_from_pilot": 1.5,
            "published_minimum_from_pilot": 1.6,
            "web_alone_passes_published_minimum": False,
            "circle_web_side_intersection_y_offset": math.sqrt(4.5**2-3.7**2),
            "automatic_web_widening_required_by_source_union": False,
            "reason": "A full joined cylinder includes the complete 2mm radial annulus outside the nominal 5mm crest. The web adds material; its narrower side cannot remove that annulus. Exposed web sides begin at or outside radius4.5. Later cuts or incomplete joins can invalidate this argument and require native checking.",
            "zero_nominal_margin_beyond_project_2mm_target": True,
            "old_selected_section_limit": "Old selected-wall report checked only one +X ray at Z37 on boss1: R4.2 minus pilotR2.15 =2.05. It neither proves all four annuli nor a 2mm wall beyond the new R2.5 crest (old boss gives1.7).",
            "optional_conditional_web_changes": optional_webs,
            "upper_inlet_web_protected": {"y_name": "d408", "y_expression": "CaseHeight - 10.5 mm", "height_name": "d410", "height_expression": "8.2 mm",
                                            "reason": "Source service_refine_a3.upper_web_relief shortened this web for closed-chamber withdrawal; do not undo."}},
        "required_transient_checks": [
            "Bind a fresh owner checkpoint after M2 and final routed PCB import; independently capture all eight expected parameter owners and values, four original insert occurrences, axes, joints and the housing body.",
            "Evaluate only the eight specified radius changes, with all other named expressions unchanged. Import candidate STEP exactly at unit scale in transient/reference context; measure source bounds and orientation before placing face Z39.",
            "For each final host, verify the complete intended annular material volume outside crestR2.5 to R4.5 across candidate Z35..39, using actual BRep differences/sections with documented tolerances. Check receiving-web connectivity, final floors and local cuts; sample rays alone are insufficient for a whole-volume claim.",
            "Check upper inlet-side boss and retained shortened web against the closed chamber, inlet/gas path and chamber withdrawal. Check other three bosses against rear cover, locating features, modules, final PCB/envelopes, wiring and service paths at widths85 and87 with restoration.",
            "Retain screw seats/axes, four M3x8 source screws, reinforced cover-bearing material, clearance bores, head recesses and narrow blind tip relief. Recheck actual candidate bore/chamfers, nominal overlap, tip gap, screwdriver access and rear-cover removal; a simplified CAD bore is not a mating-thread guarantee.",
            "Classify only the specific candidate-insert/assigned-host heat-set overlap (nominal crest versus pilot0.3mm radial) as intentional. Do not exempt other host/part pairs or alter purchased shapes to erase overlap.",
            "Require unchanged exterior, M2 interfaces, all purchased geometry, registration and rigid descendants, healthy native features/sketches and exact restoration after assessment. Review resulting evidence before separate adoption authorization."],
        "physical_pending": ["Purchased dimensional tolerances and actual internal threads", "Printed pilot fit and heat-set process", "Usable thread engagement, screw mating class and torque", "Retention and repeated-service strength"],
        "input_files_unchanged": all(sha(ROOT/p) == h for p, h in before.items())}
    assert data["input_files_unchanged"]
    out = HERE / "proposal.json"
    out.write_text(json.dumps(data, indent=2) + "\n")
    print(json.dumps({"path": str(out.relative_to(ROOT)), "sha256": sha(out), "parameter_changes": len(changes), "sources": len(before), "input_files_unchanged": True}))


if __name__ == "__main__":
    build()
