"""Assign visually reviewed actual Fusion views without modifying image files.

Cropping affects native image placement in the editable PPTX only. Composite
slots remain separate embedded photographs/screenshots with editable labels.
The final exploded view arrives separately from the native storyboard.
"""
from __future__ import annotations
import hashlib
import json
from pathlib import Path

RELEASE = Path(__file__).resolve().parents[1]
SOURCE = RELEASE / "docs/source"


def assign_reviewed():
    release_path = SOURCE / "release.json"
    release = json.loads(release_path.read_text())
    names = ["insert_detail", "display_install", "usb_cartridge", "button_carrier",
             "battery", "gas_section", "sensor_layout", "rear_cable_space"]
    for name in names:
        release["assets"][name] = {
            "path": "views/" + name + ".png", "provenance": "actual Fusion export",
            "reviewed": True, "review": "Inspected for framing, actual modeled content and unclipped subject."
        }
    release["assets"]["cover_assembled"] = {
        "path": "views/assembled.png", "provenance": "actual Fusion export", "reviewed": True,
        "review": "Complete assembled enclosure, front three-quarter view."
    }
    release["assets"]["gas_section"]["crop"] = {"left": 0.01, "right": 0.01, "top": 0.29, "bottom": 0.29}
    release["assets"]["gas_section"]["review"] = "Actual section through side ports. Crop removes blank background only. The full gas route extends outside this section plane."
    release["assets"]["usb_cartridge"] = {
        "provenance": "actual Fusion export", "reviewed": True,
        "review": "Actual front/underside and rear views inspected together. Connector mouth and both retaining screws are visible.",
        "children": [
            {"path": "views/usb_front.png", "label": "Connector mouth", "frame": [0, 0, 0.52, 1]},
            {"path": "views/usb_cartridge.png", "label": "Rear bridge", "frame": [0.54, 0, 0.46, 1]},
        ]
    }
    release["assets"]["sensor_layout"] = {
        "provenance": "actual Fusion export", "reviewed": True,
        "review": "Actual sensors-only and open-rear cartridge views identify all four sensors. Membranes, leads and finishes remain illustrative.",
        "children": [
            {"path": "views/sensors_only.png", "label": "Sensor references", "frame": [0, 0, 0.52, 1]},
            {"path": "views/chamber_open_rear.png", "label": "Installed positions", "frame": [0.54, 0, 0.46, 1]},
        ]
    }
    release["assets"]["external_views"] = {
        "provenance": "actual Fusion export", "reviewed": True,
        "review": "All five actual views inspected individually. Separate native image objects preserve source files.",
        "children": [
            {"path": "views/front.png", "label": "Front", "frame": [0, 0, 0.19, 1], "crop": {"left": 0.19, "right": 0.19, "top": 0.01, "bottom": 0.01}},
            {"path": "views/rear.png", "label": "Rear", "frame": [0.20, 0, 0.19, 1], "crop": {"left": 0.19, "right": 0.19, "top": 0.01, "bottom": 0.01}},
            {"path": "views/left.png", "label": "Left", "frame": [0.40, 0, 0.19, 1], "crop": {"left": 0.33, "right": 0.33, "top": 0.01, "bottom": 0.01}},
            {"path": "views/right.png", "label": "Right", "frame": [0.60, 0, 0.19, 1], "crop": {"left": 0.33, "right": 0.33, "top": 0.01, "bottom": 0.01}},
            {"path": "views/bottom.png", "label": "Bottom, rotated", "frame": [0.80, 0, 0.20, 1], "crop": {"left": 0.26, "right": 0.26, "top": 0.03, "bottom": 0.03}},
        ]
    }
    release["assets"]["lid_adapter"] = {
        "provenance": "actual Fusion export", "reviewed": True,
        "review": "Actual lid and actual modeled threaded adapter inspected. Shown as separate native image objects.",
        "children": [
            {"path": "views/lid_adapter.png", "label": "P08 chamber lid", "frame": [0, 0, 0.52, 1]},
            {"path": "views/TMX-A3-P11.png", "label": "P11 M16 x 1", "frame": [0.54, 0, 0.46, 1]},
        ]
    }
    release["assets"]["rear_cable_space"] = {
        "provenance": "actual Fusion export", "reviewed": True,
        "review": "Actual rear assembly and revised cover interior inspected. All four locating tabs show their new lead-ins; no source-image edits.",
        "children": [
            {"path": "views/rear_cable_space.png", "label": "Rear clearance", "frame": [0, 0, 0.52, 1]},
            {"path": "views/cover_leadins.png", "label": "Cover locating tabs", "frame": [0.54, 0, 0.46, 1],
             "crop": {"left": 0.26, "right": 0.26, "top": 0.02, "bottom": 0.02}},
        ]
    }
    inspected = []
    for name, asset in release["assets"].items():
        if not asset.get("reviewed"):
            continue
        for child in asset.get("children", [asset]):
            file = RELEASE / child["path"]
            inspected.append({"slot": name, "path": child["path"],
                              "sha256": hashlib.sha256(file.read_bytes()).hexdigest(),
                              "review": asset["review"]})
    release_path.write_text(json.dumps(release, indent=2) + "\n")
    (SOURCE / "image-review.json").write_text(json.dumps({
        "status": "mapped_reviewed_views_exploded_pending",
        "images": inspected, "source_media_modified": False,
        "notes": "Montages use separate embedded source images. Deck cropping removes background only."
    }, indent=2) + "\n")
    return {"reviewed_files": len(inspected), "remaining_slot": "exploded",
            "improvement_requests": []}


if __name__ == "__main__":
    print(json.dumps(assign_reviewed(), indent=2))
