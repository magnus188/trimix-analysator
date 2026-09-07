"""Prepare guide source and procurement rollups without opening Fusion.

Final geometry, media and release facts come from the root-controlled Fusion
pipeline. The original CAD inventory stays separate from the community BOM.
"""
from __future__ import annotations
import csv
import json
from pathlib import Path

RELEASE = Path(__file__).resolve().parents[1]
REV04 = RELEASE.parent
SOURCE = RELEASE / "docs" / "source"

PRINTED = [
    ("P01", "01 Shape A housing", "Main housing"),
    ("P02", "02 Single rear cover", "Single rear cover"),
    ("P03", "Carrier / removable electronics tray", "Electronics carrier"),
    ("P04", "Display / lower rear-release retainer", "Lower display retainer"),
    ("P05", "Display / upper rear-release retainer", "Upper display retainer"),
    ("P06", "USB A3 — removable printed support frame", "USB support frame"),
    ("P07", "Chamber / A3 top manifold with serial return", "Sampling manifold"),
    ("P08", "Chamber / A3 four-screw service lid", "Sampling chamber lid"),
    ("P09", "USB A3 — tiny flush metal bezel and hidden flange", "Printed USB bezel and hidden flange"),
    ("P10", "USB A3 — hidden metal retaining bridge", "Printed USB retaining bridge"),
    ("P11", "Chamber / AO2 hand-tight adapter reference", "AO2 threaded adapter"),
]

GROUPS = [
    ("C01", "Guition display assembly", 1, "JC4880P443C_I_W / JC-ESP32P4-M3", "Owner-measured envelope; revision and frame details need confirmation", ["03 Guition factory casing — measured envelope", "04 Guition front glass — drawing reference", "05 Active 4.3 inch screen", "06 Guition PCB and connectors — illustrative detail"]),
    ("C02", "Protected two-cell holder", 1, "FMA FPML1S2P050C", "Owner-measured occupied envelope; local protection PCB and wire exit need confirmation", ["Battery / FMA protected holder - owner-measured envelope"]),
    ("C03", "18650 cell", 2, "Exact manufacturer/model pending; owner rates each 3400 mAh", "Confirm identity, dimensions and cell limits before electrical use", ["Battery / 18650 cell A - owner-rated 3400 mAh", "Battery / 18650 cell B - owner-rated 3400 mAh"]),
    ("C04", "Momentary illuminated 1NO button", 1, "12 mm nominal, green, 3-6 V illumination; exact SKU pending", "Body, nut and cap form one purchased assembly; measure terminals and panel fit", ["Controls / left 1NO button body", "Controls / left momentary power cap", "Controls / button retaining nut reference"]),
    ("C05", "USB-C receptacle", 1, "GCT USB4720-03-A", "One connector includes shell, insulators, contacts and nominal LIM seal; verify purchased revision", ["USB A3 — GCT USB4720 shell drawing reconstruction", "USB A3 — tongue and rear insulator reference", "USB A3 — illustrative contact stripes", "USB A3 — GCT LIM gasket nominal reference"]),
    ("C06", "Oxygen sensor", 1, "Honeywell AO2 / AA428-210 drawing reference", "Purchased variant, nose, membrane and seal need confirmation", ["Sensor / AO2 dry body with wetted threaded nose"]),
    ("C07", "Thermal-conductivity sensor", 1, "Winsen MD62", "Check detector marking, full leads and support; helium use requires experimental calibration", ["Sensor / MD62 body and full-length lead references"]),
    ("C08", "Humidity breakout", 1, "GYBMEP board with BME280 intended", "Confirm BME280 identity, board dimensions and electrical interface", ["Sensor / GYBMEP humidity breakout reference"]),
    ("C09", "Carbon-monoxide module", 1, "Winsen ZE07-CO", "Confirm module revision and header; this module measures CO", ["Sensor / ZE07-CO drawing-derived assembly"]),
    ("C10", "Two-wire battery disconnect pair", 1, "RCY/BEC-style; exact connector family pending", "Account for any holder-supplied half; select matching crimp/pigtail pair after inspection", ["Battery / red RCY disconnect body - provisional reference", "Battery / red RCY disconnect mate - provisional reference"]),
    ("C11", "Gas fitting", 2, "Nominal 8 mm OD / 5 mm ID reference; exact SKU pending", "Select matching fitting, tubing, seals and retention after physical measurement", ["Gas / Viewer-left inlet fitting reference", "Gas / Viewer-right exhaust fitting reference"]),
    ("C12", "AO2 mating cable/connector", 1, "Exact mate pending purchased AO2 inspection", "May come with sensor; do not order twice", ["Sensor / AO2 cable connector allowance"]),
    ("B01", "Main electronics PCB", 1, "A2.2 circuit, A3 notched outline pending", "Mechanical allocation only; layout, connector placement, routing and fabrication release remain open", ["Carrier / future PCB allocation — layout pending"]),
    ("B02", "USB daughterboard", 1, "GCT straddle mount, 0.60 mm substrate", "Requires final routed outline, two 5.1k 1% CC resistors and VBUS/GND loom", ["USB A3 — supported 0.60 mm daughterboard provisional"]),
    ("S01", "Chamber harness closure", 1, "Potting/gland specification pending", "CAD allowance is not a selected seal, wire arrangement or procurement item", ["Chamber / sealed harness feedthrough allowance"]),
    ("S02", "AO2 face seal", 1, "Material and dimensions pending", "Select using the measured AO2 sealing datum and revised adapter", ["Chamber / AO2 face-seal allowance"]),
]

FASTENERS = [
    ("F01", "GEN-M3-BHCS-L8-AF2", "M3 x 8 button-head screw", 4, "2 mm hex; verify actual head and shaft dimensions"),
    ("F02", "GEN-M2-SHCS-L5-AF1.5", "M2 x 5 socket-cap screw", 8, "1.5 mm hex; display 2, USB 2, chamber lid 4 in baseline"),
    ("F03", "GEN-M2-SHCS-L7-AF1.5", "M2 x 7 socket-cap screw", 2, "1.5 mm hex; shared PCB/carrier fasteners in baseline"),
    ("F04", "GEN-M3-HEATSET-OD4.2-L5", "M3 heat-set insert, OD4.2 x 5", 4, "Generic envelope; actual manufacturer's hole and installation guidance governs"),
    ("F05", "GEN-M2-HEATSET-OD3.2-L4", "M2 heat-set insert, OD3.2 x 4", 10, "Generic envelope; actual manufacturer's hole and installation guidance governs"),
]


def prepare_bom():
    """Write proposed IDs, baseline quantities and explicit evidence limits."""
    SOURCE.mkdir(parents=True, exist_ok=True)
    with (REV04 / "PARTS.csv").open(newline="") as stream:
        inventory = list(csv.DictReader(stream))
    by_name = {r["component"]: r for r in inventory}
    mapping, procurement = [], []

    def add_map(name, cad_id, group_id, category, description):
        original = by_name[name]
        mapping.append({"original_component_name": name, "cad_part_id": cad_id,
                        "procurement_id": group_id, "category": category,
                        "description": description, "cad_instance_quantity": int(original["quantity"]),
                        "original_basis": original["basis"], "source_url": original["source"]})

    for key, name, label in PRINTED:
        pid = "TMX-A3-" + key
        add_map(name, pid, pid, "printed", label)
        procurement.append(dict(part_id=pid, item=label, quantity=1, unit="piece", category="printed",
                                specification="Native revised CAD and matching print export",
                                status="Pending revised CAD/mesh release and physical fit",
                                included_parts="", source="Revised Fusion model",
                                procurement_scope="Enclosure fit prototype"))
    for key, label, qty, spec, status, names in GROUPS:
        pid = "TMX-A3-" + key
        category = {"B": "pcb_fabrication", "S": "seal_allowance"}.get(key[0], "purchased")
        for index, name in enumerate(names, 1):
            cid = pid + (f"-V{index:02d}" if len(names) > 1 else "")
            add_map(name, cid, pid, category, label)
        procurement.append(dict(part_id=pid, item=label, quantity=qty, unit="pair" if key == "C10" else "piece",
                                category=category, specification=spec, status=status,
                                included_parts="; ".join(names),
                                source="; ".join(sorted({by_name[n]["source"] for n in names if by_name[n]["source"]})),
                                procurement_scope="Enclosure fit prototype" if key[0] != "B" else "Electronics handoff; not fabrication released"))
    for key, generic, label, qty, note in FASTENERS:
        originals = [r for r in inventory if r["part_number"] == generic or generic in r["component"]]
        if len(originals) != 1:
            raise ValueError(f"Expected exactly one CAD hardware definition for {generic}")
        original = originals[0]
        if int(original["quantity"]) != qty:
            raise ValueError(f"Baseline hardware quantity changed: {generic}")
        pid = "TMX-A3-" + key
        add_map(original["component"], pid, pid, "fastener", label)
        procurement.append(dict(part_id=pid, item=label, quantity=qty, unit="piece", category="fastener",
                                specification=generic,
                                status="Nominal generic reference; exact supplier and revised engagement checks pending. " + note,
                                included_parts="", source="Baseline native hardware metadata",
                                procurement_scope="Enclosure fit prototype"))
    mapped = {r["original_component_name"] for r in mapping}
    if mapped != set(by_name):
        raise ValueError(f"Unmapped CAD components: {set(by_name) - mapped}; extras: {mapped - set(by_name)}")
    (SOURCE / "part-map.json").write_text(json.dumps({
        "status": "proposed_ids_pending_final_native_reconciliation",
        "inventory": "../../../PARTS.csv", "parts": mapping}, indent=2) + "\n")
    with (SOURCE / "procurement-bom.csv").open("w", newline="") as stream:
        writer = csv.DictWriter(stream, fieldnames=list(procurement[0]))
        writer.writeheader()
        writer.writerows(procurement)
    with (SOURCE / "printed-parts.csv").open("w", newline="") as stream:
        writer = csv.DictWriter(stream, fieldnames=["part_id", "item", "quantity", "mesh_file", "orientation", "supports", "status"])
        writer.writeheader()
        writer.writerows(dict(part_id=r["part_id"], item=r["item"], quantity=1, mesh_file="",
                              orientation="", supports="", status="Await final print manifest")
                         for r in procurement if r["category"] == "printed")
    return {"cad_definitions_mapped": len(mapping), "procurement_rows": len(procurement), "printed_parts": len(PRINTED)}


if __name__ == "__main__":
    print(json.dumps(prepare_bom(), indent=2))
