#!/usr/bin/env python3
"""Saved-fill geometry, drilled annulus witnesses, and review overlays; no PCB writes."""
from pathlib import Path
import argparse
import hashlib
import json
import math
import sys
import textwrap
from datetime import datetime, timezone

import cairosvg
import numpy as np
import sexpdata
from shapely import contains_xy
from shapely.ops import nearest_points

OUT = Path(__file__).resolve().parent
SOURCE = OUT.parent
REPO = OUT.parents[6]
sys.path.insert(0, str(REPO / "hardware/system-review/electrical/main-final-independent"))
from cam_geometry import Native, Point, LineString, Polygon, box, unary_union, polys, sub, subs, tag

BASE_SHA = "43046290dd43fb281ee8711e50924bf6cb4f689afc3f26330c916a1776d2a0c3"
ACCEPTED_SHA = "12fc60412aa21dcbca3f4fb69da038a8d312193734992441231de17a70e3d5bc"
LAYERS = ["F.Cu", "In1.Cu", "In2.Cu", "B.Cu"]
LOCAL = (16, 60, 28, 78)
ALL_BOARD = (0, 0, 30, 99)
CONTACT_AREA = 1e-8
COLORS = {"GND": "#357b50", "CHG_INT_N": "#e87512", "I2C_SCL": "#cc2046", "I2C_SDA": "#7452bb",
          "HOST_3V3": "#2477ba", "HOST_5V": "#5899b5", "VSYS": "#ba3c97", "PACK_P": "#715aa1",
          "USB_5V": "#be432e", "USB_CHG_5V": "#e89b27", "USB_OVP_5V": "#087f8c"}


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def xy(point):
    return [point.x, -point.y]


def bounds(g):
    if g.is_empty:
        return None
    x0, y0, x1, y1 = g.bounds
    return [x0, -y1, x1, -y0]


def rect(b):
    return box(b[0], -b[3], b[2], -b[1])


def load(path):
    native = Native(sexpdata.loads(path.read_text()))
    for v, raw in zip(native.vias, subs(native.raw, "via")):
        v["uuid"] = str(sub(raw, "uuid")[0])
    for t, raw in zip(native.tracks, subs(native.raw, "segment")):
        t["uuid"] = str(sub(raw, "uuid")[0])
    for pad in native.pads:
        pad["uuid"] = str(sub(pad["raw"], "uuid")[0])
    holes = {h["id"]: h["geo"] for h in native.holes}
    all_holes = unary_union(list(holes.values()))
    fills = {layer: unary_union([z["geo"] for z in native.zones if z["layer"] == layer and z["net"] == "GND"])
             for layer in LAYERS}
    physical = {layer: g.difference(all_holes) for layer, g in fills.items()}
    anchors = []
    for v in native.vias:
        if v["net"] == "GND":
            anchors.append(dict(uuid=v["uuid"], kind="through_via", id=v["id"], position_mm=[v["xy"][0], -v["xy"][1]],
                                layers=v["layers"], copper=v["geo"].difference(holes[v["id"]]), drill=holes[v["id"]]))
    for p in native.pads:
        if p["net"] == "GND" and str(p["raw"][2]) == "thru_hole" and p["id"] in holes:
            anchors.append(dict(uuid=p["uuid"], kind="plated_pad", id=p["id"], ref=p["ref"], pin=p["pin"],
                                position_mm=[p["x"], -p["y"]], layers=LAYERS if "*.Cu" in p["layers"] else p["layers"],
                                copper=p["geo"].difference(holes[p["id"]]), drill=holes[p["id"]]))
    return dict(native=native, fills=fills, physical=physical, anchors=anchors, all_holes=all_holes)


def anchor_witnesses(board):
    rows = []
    for a in board["anchors"]:
        row = {k: v for k, v in a.items() if k not in ["copper", "drill", "layers"]}
        row["annulus_copper_area_mm2"] = a["copper"].area
        row["layers"] = {}
        for layer in ["In1.Cu", "In2.Cu"]:
            g = board["physical"][layer]
            overlap = g.intersection(a["copper"]).area if layer in a["layers"] else 0
            row["layers"][layer] = dict(overlap_mm2=overlap, contact=overlap > CONTACT_AREA,
                                        distance_mm=g.distance(a["copper"]) if not g.is_empty else None)
        rows.append(row)
    return rows


def components(board, layer):
    rows = []
    for i, g in enumerate(sorted(polys(board["physical"][layer]), key=lambda g: -g.area)):
        witnesses = []
        for a in board["anchors"]:
            overlap = g.intersection(a["copper"]).area if layer in a["layers"] else 0
            if overlap > CONTACT_AREA:
                in1 = board["physical"]["In1.Cu"].intersection(a["copper"]).area
                witnesses.append(dict(uuid=a["uuid"], id=a["id"], kind=a["kind"], position_mm=a["position_mm"],
                                      component_overlap_mm2=overlap, In1_overlap_mm2=in1, reaches_In1=in1 > CONTACT_AREA))
        rows.append(dict(component=i + 1, physical_area_mm2=g.area, bounds_mm=bounds(g), anchors=witnesses,
                         has_anchor_to_In1=any(a["reaches_In1"] for a in witnesses)))
    return rows


def zone_definitions(native):
    items = list(subs(native.raw, "zone"))
    items += [z for f in subs(native.raw, "footprint") for z in subs(f, "zone")]
    return {str(sub(z, "uuid")[0]): sexpdata.dumps([x for x in z if tag(x) not in ["filled_polygon", "fill_segments"]])
            for z in items}


def holes_of(g):
    return [Polygon(r) for q in polys(g) for r in q.interiors]


def throat_review(before, after, via_position):
    """Local boundary-to-boundary ligaments, not a global plane bottleneck."""
    g = after["physical"]["In1.Cu"]
    center = Point(via_position[0], -via_position[1])
    holes = holes_of(g)
    selected = [h for h in holes if h.covers(center)]
    if len(selected) != 1:
        return {"status": "NO_UNIQUE_ENCLOSING_VOID", "via_position_mm": via_position}, []
    opening = selected[0]
    prior_holes = holes_of(before["physical"]["In1.Cu"])
    adjacent_before = [h for h in prior_holes if h.intersection(opening).area > CONTACT_AREA]
    old_void = unary_union(adjacent_before)
    others = [h for h in holes if h is not opening]
    others += [Polygon(q.exterior) for q in polys(g)]
    rows, lines = [], []
    for other in others:
        p1, p2 = nearest_points(opening.boundary, other.boundary)
        line = LineString([p1, p2])
        width = line.length
        if width > 3:
            continue
        drilled = [a["uuid"] for a in after["anchors"] if other.symmetric_difference(a["drill"]).area < 1e-7]
        previous_width = old_void.boundary.distance(other.boundary) if not old_void.is_empty else None
        # This reports polygon geometry. The line may skirt a branch; verify its
        # interior is copper rather than assuming every pair of boundaries is a throat.
        interior = LineString([line.interpolate(.00001), line.interpolate(max(.00001, width - .00001))])
        contained = interior.difference(g).length < .00005
        row = dict(width_mm=width, from_mm=xy(p1), to_mm=xy(p2), material_line_verified=contained,
                   prior_related_void_gap_mm=previous_width, neighbor_bounds_mm=bounds(other),
                   neighbor_ground_drill_uuids=drilled)
        rows.append(row)
        lines.append((row, line))
    rows.sort(key=lambda r: r["width_mm"])
    lines.sort(key=lambda r: r[0]["width_mm"])
    return dict(status="MEASURED_SAVED_POLYGONS", via_position_mm=via_position, merged_void_area_mm2=opening.area,
                merged_void_bounds_mm=bounds(opening), previously_existing_void_count=len(adjacent_before),
                added_void_area_mm2=opening.difference(old_void).area,
                ligament_witnesses=rows,
                limitation="Local material ligaments only; paths can go around either end. These are not current ratings or a global minimum neck."), lines


def path_svg(g, color, opacity=1):
    paths = []
    # Display-only reduction; all measurements use the original geometry.
    for p in polys(g.simplify(.0005, preserve_topology=True)):
        d = " ".join("M " + " L ".join(f"{x:.6f},{-y:.6f}" for x, y in r.coords) + " Z" for r in [p.exterior, *p.interiors])
        paths.append(f'<path d="{d}" fill="{color}" opacity="{opacity}" fill-rule="evenodd"/>')
    return "".join(paths)


def view(name, panels, crop, note, width_pixels=2600, throat_lines=None):
    x0, y0, x1, y1 = crop
    w, h = x1 - x0, y1 - y0
    title_h = max(.8, h * .025)
    footer_h = max(1.1, h * .04)
    gap = w * .04
    total_w = len(panels) * (w + gap) + gap
    total_h = h + title_h + footer_h
    area = rect(crop)
    output = [f'<svg xmlns="http://www.w3.org/2000/svg" width="{width_pixels}" height="{round(width_pixels*total_h/total_w)}" viewBox="0 0 {total_w} {total_h}">',
              '<rect width="100%" height="100%" fill="#fff"/>']
    for i, (board, layer, title, mode) in enumerate(panels):
        offset = gap + i * (w + gap)
        title_font = min(title_h*.4, w / (len(title)*.64))
        output.append(f'<text x="{offset}" y="{title_h*.68}" font-family="Arial" font-size="{title_font}">{title}</text>')
        output.append(f'<g transform="translate({offset-x0},{title_h-y0})">')
        output.append(f'<defs><clipPath id="crop-{i}"><rect x="{x0}" y="{y0}" width="{w}" height="{h}"/></clipPath></defs><g clip-path="url(#crop-{i})">')
        output.append(f'<rect x="{x0}" y="{y0}" width="{w}" height="{h}" fill="#f4f7f8" stroke="#99a5b1" stroke-width=".025"/>')
        output.append(path_svg(board["physical"][layer].intersection(area), "#c6e0ce"))
        native = board["native"]
        for track in native.tracks:
            if track["layer"] == layer:
                output.append(path_svg(track["geo"].intersection(area), COLORS.get(track["net"], "#a3abb4")))
        for pad in native.pads_on(layer):
            output.append(path_svg(pad["geo"].intersection(area), COLORS.get(pad["net"], "#a3abb4")))
        for via in native.vias:
            output.append(path_svg(via["geo"].intersection(area), COLORS.get(via["net"], "#a3abb4")))
        output.append(path_svg(board["all_holes"].intersection(area), "#fff"))
        if mode == "anchors":
            for a in board["anchors"]:
                if layer in a["layers"] and board["physical"][layer].intersection(a["copper"]).area > CONTACT_AREA:
                    x, y = a["position_mm"]
                    if x0 <= x <= x1 and y0 <= y <= y1:
                        output.append(f'<circle cx="{x}" cy="{y}" r=".32" fill="none" stroke="#003e6c" stroke-width=".06"/>')
        if mode == "throats" and throat_lines:
            for j, (row, line) in enumerate([pair for pair in throat_lines if pair[0]["material_line_verified"]][:2]):
                a, b = row["from_mm"], row["to_mm"]
                output.append(f'<line x1="{a[0]}" y1="{a[1]}" x2="{b[0]}" y2="{b[1]}" stroke="#111" stroke-width=".025"/>')
                output.append(f'<text x="{(a[0]+b[0])/2+.04}" y="{(a[1]+b[1])/2}" font-family="Arial" font-size=".11">{j+1}: {row["width_mm"]:.3f} mm</text>')
        if h < 30:
            refs = {"R107", "R302", "U301", "C301", "C202", "C707", "U111", "R110"}
            for pad in native.pads_on(layer):
                if pad["ref"] in refs and area.covers(Point(pad["x"], pad["y"])):
                    output.append(f'<text x="{pad["x"]}" y="{-pad["y"]+.045}" font-family="Arial" font-size=".13" text-anchor="middle">{pad["ref"]}.{pad["pin"]}</text>')
        output.append('</g></g>')
    footer_font = min(footer_h*.20, total_w/110)
    footer_lines = textwrap.wrap(note, width=int((total_w-2*gap)/(footer_font*.6)))
    footer_lines += textwrap.wrap(f'Actual saved copper; X{x0:g}–{x1:g}, Y{y0:g}–{y1:g} mm. GND green; CHG orange; SCL red; SDA violet; HOST blue; VSYS magenta; USB brown.', width=int((total_w-2*gap)/(footer_font*.6)))
    for j, line in enumerate(footer_lines):
        output.append(f'<text x="{gap}" y="{title_h+h+footer_h*.28+j*footer_font*1.45}" font-family="Arial" font-size="{footer_font}">{line}</text>')
    output.append('</svg>')
    svg = "".join(output)
    (OUT / (name + ".svg")).write_text(svg)
    cairosvg.svg2png(bytestring=svg.encode(), write_to=str(OUT / (name + ".png")))
    return {"svg": name + ".svg", "png": name + ".png", "crop_mm": list(crop),
            "svg_coordinates_decimals_mm": 6, "png_mm_per_pixel": total_w / width_pixels,
            "display_only_simplification_mm": .0005,
            "png_not_a_measurement_source": True}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--candidate-sha256", required=True)
    parser.add_argument("--candidate-board", type=Path, default=SOURCE / "Trimix_Analyzer.kicad_pcb")
    parser.add_argument("--delta", type=Path, default=SOURCE / "delta.json")
    args = parser.parse_args()
    paths = [SOURCE / "before.kicad_pcb", args.candidate_board.resolve()]
    actual = [sha(p) for p in paths]
    assert actual == [BASE_SHA, args.candidate_sha256], actual
    accepted_path = OUT / "accepted-12fc.kicad_pcb"
    assert sha(accepted_path) == ACCEPTED_SHA
    delta_path = args.delta.resolve()
    delta_hash = sha(delta_path)
    delta = json.loads(delta_path.read_text())
    assert delta["before_sha256"] == BASE_SHA and delta["after_sha256"] == args.candidate_sha256
    before, after = [load(p) for p in paths]
    accepted = load(accepted_path)
    data = {"created_utc": datetime.now(timezone.utc).isoformat(), "candidate_status": "GEOMETRY_REVIEW_ONLY",
            "before_sha256": actual[0], "candidate_sha256": actual[1], "delta_sha256": delta_hash,
            "candidate_board": str(paths[1]), "delta_path": str(delta_path),
            "accepted_baseline_sha256": ACCEPTED_SHA,
            "baseline_disposition": "12fc is the clean accepted baseline; 430 is an invalid intermediate with four known CHG/SCL shorts. Both are measured, neither is rewritten.",
            "script_sha256": sha(Path(__file__)), "local_crop_mm": list(LOCAL), "all_board_crop_mm": list(ALL_BOARD),
            "method": ["Parse saved KiCad filled contours and preserve holes with make_valid polygon union; no refill or PCB mutation.",
                       "Physical fill subtracts every drilled opening. Anchor witnesses use annular copper, never entire via disks.",
                       "Circular pad/drill approximations use 128 segments per quadrant. Printed local neck values are saved-polygon distances, not raster measurements.",
                       "Independent native KiCad extraction cross-checked final a700, 12fc, and 430 nominal fill areas and annular contacts; native-crosscheck.json records the numerical approximation limits.",
                       "Erosion and cropped components are diagnostics. Neither constitutes a current-capacity, temperature, return-inductance, or EMC calculation."],
            "layers": {}, "anchors": {}, "accepted_baseline_comparison": {}, "renders": []}
    for label, board in [("accepted_12fc", accepted), ("before", before), ("candidate", after)]:
        data["anchors"][label] = anchor_witnesses(board)
    for layer in ["In1.Cu", "In2.Cu"]:
        a, b = before["fills"][layer], after["fills"][layer]
        ap, bp = before["physical"][layer], after["physical"][layer]
        row = {"before_saved_fill_area_mm2": a.area, "candidate_saved_fill_area_mm2": b.area,
               "removed_saved_fill_area_mm2": a.difference(b).area, "added_saved_fill_area_mm2": b.difference(a).area,
               "before_saved_fill_components": len(polys(a)), "candidate_saved_fill_components": len(polys(b)),
               "before_physical_fill_area_mm2": ap.area, "candidate_physical_fill_area_mm2": bp.area,
               "before_components_and_anchors": components(before, layer), "candidate_components_and_anchors": components(after, layer),
               "before_fill_bounds_mm": bounds(a), "candidate_fill_bounds_mm": bounds(b),
               "crop_before_fill_area_mm2": a.intersection(rect(LOCAL)).area,
               "crop_candidate_fill_area_mm2": b.intersection(rect(LOCAL)).area,
               "erosion_probes": []}
        for radius in [.05, .1, .15, .2, .25, .4]:
            row["erosion_probes"].append({"radius_mm": radius,
                "before_full_board_components_gt_001mm2": sorted([g.area for g in polys(ap.buffer(-radius)) if g.area > .01], reverse=True),
                "candidate_full_board_components_gt_001mm2": sorted([g.area for g in polys(bp.buffer(-radius)) if g.area > .01], reverse=True)})
        data["layers"][layer] = row
        clean = accepted["fills"][layer]
        data["accepted_baseline_comparison"][layer] = {
            "accepted_saved_fill_area_mm2": clean.area,
            "candidate_saved_fill_area_mm2": b.area,
            "removed_vs_accepted_mm2": clean.difference(b).area,
            "added_vs_accepted_mm2": b.difference(clean).area,
            "accepted_physical_fill_area_mm2": accepted["physical"][layer].area,
            "accepted_components_and_anchors": components(accepted, layer),
            "candidate_components_and_anchors": components(after, layer)}
    existing_contacts = {layer: {a["uuid"] for a in data["anchors"]["before"] if a["layers"][layer]["contact"]} for layer in ["In1.Cu", "In2.Cu"]}
    new_contacts = {layer: {a["uuid"] for a in data["anchors"]["candidate"] if a["layers"][layer]["contact"]} for layer in ["In1.Cu", "In2.Cu"]}
    new_vias = [v for v in delta["added_items"] if v["type"] == "via" and v["net"] == "CHG_INT_N"]
    assert len(new_vias) == 1
    data["local_In1_throats"], throat_lines = throat_review(accepted, after, new_vias[0]["at"])
    data["local_In1_throats"]["prior_baseline"] = "accepted_12fc"
    center = new_vias[0]["at"]
    neck_crop = (center[0]-1.8, center[1]-1.8, center[0]+1.8, center[1]+1.8)
    # Binary raster is explicitly resolution-limited corroboration, not the width measurement.
    pitch = .01
    xx = np.arange(neck_crop[0]+pitch/2, neck_crop[2], pitch)
    yy = np.arange(neck_crop[1]+pitch/2, neck_crop[3], pitch)
    gx, gy = np.meshgrid(xx, yy)
    mask = contains_xy(after["physical"]["In1.Cu"], gx, -gy)
    np.savez_compressed(OUT / "local-In1-occupancy.npz", x_mm=xx, y_mm=yy, copper=mask)
    data["local_raster"] = {"file": "local-In1-occupancy.npz", "pitch_mm": pitch, "pixel_center_sampling": True,
                            "crop_mm": list(neck_crop), "shape": list(mask.shape), "copper_sample_fraction": float(mask.mean()),
                            "boundary_location_quantization_mm": math.sqrt(2)*pitch/2,
                            "two_boundary_width_quantization_mm": math.sqrt(2)*pitch,
                            "narrower_than_one_pixel_features_can_be_missed": True}
    data["renders"].append(view("accepted-plane-comparison", [(accepted,"In1.Cu","ACCEPTED 12fc In1","anchors"),(after,"In1.Cu","CANDIDATE In1","anchors"),
                                                              (accepted,"In2.Cu","ACCEPTED 12fc In2","anchors"),(after,"In2.Cu","CANDIDATE In2","anchors")],
                                      ALL_BOARD, "Primary comparison to the clean accepted baseline; blue rings identify GND barrel anchors.", 2400))
    data["renders"].append(view("all-board-planes", [(before,"In1.Cu","INVALID TRIAL 430 In1","anchors"),(after,"In1.Cu","CANDIDATE In1","anchors"),
                                                   (before,"In2.Cu","INVALID TRIAL 430 In2","anchors"),(after,"In2.Cu","CANDIDATE In2","anchors")],
                                      ALL_BOARD, "Blue rings: GND barrel/annulus anchors with positive fill overlap. In2 fill is localized to Y83–94.2.", 2400))
    data["renders"].append(view("local-plane-comparison", [(before,"In1.Cu","BEFORE In1","normal"),(after,"In1.Cu","CANDIDATE In1","normal"),
                                                          (before,"In2.Cu","BEFORE In2: no GND fill","normal"),(after,"In2.Cu","CANDIDATE In2: no GND fill","normal")],
                                      LOCAL, "The long CHG route is actual In2 copper; no In2 GND fill occupies this crop. In1 has via clearances only.", 2800))
    data["renders"].append(view("local-power-overlays", [(accepted,"F.Cu","ACCEPTED 12fc F.Cu","normal"),(after,"F.Cu","CANDIDATE F.Cu","normal"),
                                                       (accepted,"B.Cu","ACCEPTED 12fc B.Cu","normal"),(after,"B.Cu","CANDIDATE B.Cu","normal")],
                                      LOCAL, "Outer-layer power and signal copper only; no projected plane or inferred current/thermal performance.", 2800))
    data["renders"].append(view("all-board-power-overlays", [(after,"F.Cu","CANDIDATE F.Cu","normal"),(after,"B.Cu","CANDIDATE B.Cu","normal")],
                                      ALL_BOARD, "Whole-board actual F/B copper context; colors identify nets, not current capacity.", 1400))
    data["renders"].append(view("local-In1-throat-witnesses", [(accepted,"In1.Cu","ACCEPTED 12fc drilled In1","normal"),(after,"In1.Cu","CANDIDATE drilled In1","throats")],
                                      neck_crop, "Black segments: saved-polygon local ligament witnesses. Neighboring drilled openings are included; no global bottleneck claim.", 2200, throat_lines))
    in1_tracks = [t for t in after["native"].tracks if t["layer"] == "In1.Cu" and t["net"] != "GND"]
    data["gates"] = {"input_hashes_match": True,
                     "zone_outlines_and_settings_preserved": zone_definitions(before["native"]) == zone_definitions(after["native"]),
                     "In1_physical_ground_continuous": len(polys(after["physical"]["In1.Cu"])) == 1,
                     "In1_signal_tracks_absent": not in1_tracks,
                     "all_candidate_In2_regions_have_In1_anchor": all(c["has_anchor_to_In1"] for c in data["layers"]["In2.Cu"]["candidate_components_and_anchors"]),
                     "ground_anchor_contacts_preserved": existing_contacts == new_contacts,
                     "accepted_ground_anchor_contacts_preserved": all(
                         {a["uuid"] for a in data["anchors"]["accepted_12fc"] if a["layers"][L]["contact"]} == new_contacts[L]
                         for L in new_contacts),
                     "accepted_zone_outlines_and_settings_preserved": zone_definitions(accepted["native"]) == zone_definitions(after["native"]),
                     "lost_anchor_uuids": {L: sorted(existing_contacts[L]-new_contacts[L]) for L in existing_contacts},
                     "native_DRC": "Owner-run DRC and matching-board disposition are a separate gate; this script does not run DRC.",
                     "release": False}
    assert [sha(p) for p in paths] == actual and sha(delta_path) == delta_hash and sha(accepted_path) == ACCEPTED_SHA
    data["gates"]["source_files_unchanged"] = True
    (OUT / "ground-audit.json").write_text(json.dumps(data, indent=2) + "\n")
    for layer, row in data["layers"].items():
        print(layer, row["before_saved_fill_area_mm2"], "->", row["candidate_saved_fill_area_mm2"],
              "components", row["before_saved_fill_components"], "->", row["candidate_saved_fill_components"])
    print("GATES", data["gates"])


if __name__ == "__main__":
    main()
