"""Map sliced project inputs into the guide without claiming visual approval.

Only guide-owned files are written. The slicer agent owns final print QA.
Use --approved only after that agent/root has accepted the final manifest.
"""
from __future__ import annotations
import argparse
import csv
import hashlib
import json
from pathlib import Path

RELEASE = Path(__file__).resolve().parents[1]
SOURCE = RELEASE / "docs/source"
PRINT = RELEASE / "printing"

ORIENTATIONS = {
    "TMX-A3-P01": "Front face down, rear opening up",
    "TMX-A3-P02": "Outside rear face down",
    "TMX-A3-P03": "Broad front face down",
    "TMX-A3-P04": "Broad rear plate face down",
    "TMX-A3-P05": "Broad rear plate face down",
    "TMX-A3-P06": "Floor down",
    "TMX-A3-P07": "Front floor down, lid opening up",
    "TMX-A3-P08": "Outside lid face down",
    "TMX-A3-P09": "USB axis vertical, hidden rear flange down",
    "TMX-A3-P10": "Broad rear face down",
    "TMX-A3-P11": "Thread axis vertical",
}


def refresh(approved=False):
    manifest_path = PRINT / "print-manifest.json"
    manifest = json.loads(manifest_path.read_text())
    if manifest["units"] != "mm":
        raise ValueError("Print manifest must use millimetres.")
    parts = {p["part_id"]: p for p in manifest["parts"]}
    mapping = json.loads((SOURCE / "part-map.json").read_text())
    expected = {p["cad_part_id"]: p for p in mapping["parts"] if p["category"] == "printed"}
    if set(parts) != set(expected) or len(parts) != 11:
        raise ValueError("Print manifest does not match all 11 stable printed IDs.")
    rows = []
    for pid, item in sorted(parts.items()):
        if item["component"] != expected[pid]["original_component_name"]:
            raise ValueError("Native component mismatch: " + pid)
        if set(item["materials"]) != {"pla", "petg"}:
            raise ValueError("Expected both material projects: " + pid)
        mesh = Path(item["file"])
        if hashlib.sha256(mesh.read_bytes()).hexdigest() != item["mesh"]["oriented_sha256"]:
            raise ValueError("Oriented mesh hash mismatch: " + pid)
        projects = {m: PRINT / "bambu-studio" / m / pid / f"{pid}_{m}.3mf" for m in item["materials"]}
        for p in projects.values():
            if not p.is_file():
                raise FileNotFoundError(p)
        rows.append({
            "part_id": pid, "item": expected[pid]["description"], "quantity": 1,
            "mesh_file": str(mesh.relative_to(RELEASE)), "orientation": ORIENTATIONS[pid],
            "supports": item["mode"].replace("_", " "),
            "pla_project": str(projects["pla"].relative_to(RELEASE)),
            "petg_project": str(projects["petg"].relative_to(RELEASE)),
            "review_notes": item["review"],
            "status": "Final digital print review accepted; physical coupon tests pending" if approved else "Projects mapped; final visual print QA pending",
        })
    with (SOURCE / "printed-parts.csv").open("w", newline="") as stream:
        writer = csv.DictWriter(stream, fieldnames=list(rows[0]))
        writer.writeheader()
        writer.writerows(rows)
    process = json.loads((PRINT / "profiles/accessible_supports.json").read_text())
    if process["layer_height"] != "0.2" or process["wall_loops"] != "4":
        raise ValueError("Guide process statement must be reviewed after a profile change.")
    if process["top_shell_layers"] != "5" or process["bottom_shell_layers"] != "5":
        raise ValueError("Guide shell-layer statement is stale.")
    if process["sparse_infill_density"] != "20%" or process["sparse_infill_pattern"] != "gyroid" or process["brim_width"] != "4":
        raise ValueError("Guide infill/brim statement is stale.")
    release_path = SOURCE / "release.json"
    release = json.loads(release_path.read_text())
    release["facts"]["print_nozzle"] = "0.4 mm"
    release["facts"]["print_layer"] = "0.20 mm model layers"
    release["facts"]["print_material"] = "PLA fit / PETG target"
    release["evidence"]["print_manifest"] = "printing/print-manifest.json"
    release["evidence"]["print_review"] = "printing/verification-summary.json"
    release["evidence"]["coupon_review"] = "printing/coupons/verification-summary.json"
    release["evidence"]["print_profile"] = "printing/profiles/provenance.json"
    release["print_manifest_reconciled"] = bool(approved)
    release_path.write_text(json.dumps(release, indent=2) + "\n")
    report = {
        "status": "accepted_final_manifest" if approved else "inputs_mapped_awaiting_final_visual_qa",
        "part_projects": 22, "printed_parts": 11, "materials": ["pla", "petg"],
        "manifest_sha256": hashlib.sha256(manifest_path.read_bytes()).hexdigest(),
        "process_sha256": hashlib.sha256((PRINT / "profiles/accessible_supports.json").read_bytes()).hexdigest(),
        "scope": "Manifest identities, project presence and mesh hashes checked. Approval flag follows root/slicer-agent review. Physical tests remain pending.",
    }
    (SOURCE / "print-input-reconciliation.json").write_text(json.dumps(report, indent=2) + "\n")
    return report


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--approved", action="store_true")
    args = parser.parse_args()
    print(json.dumps(refresh(args.approved), indent=2))
