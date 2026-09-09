#!/usr/bin/env python3
"""Create three A3 concept-review sheets from seven actual Fusion view PNGs.

Requires ReportLab and Pillow. Missing or unreadable views are fatal. Optional
--status JSON carries model_state, overall_mm (height/width/depth), and up to six
checks with name/status/evidence/note. No check is inferred from a view or from a
previous revision. This generator never substitutes synthetic CAD imagery.
"""

from __future__ import annotations

import argparse
from datetime import date
from html import escape
import json
from pathlib import Path

from PIL import Image
from reportlab.lib import colors
from reportlab.lib.enums import TA_LEFT
from reportlab.lib.pagesizes import A3, landscape
from reportlab.lib.styles import ParagraphStyle
from reportlab.lib.utils import ImageReader
from reportlab.pdfgen import canvas
from reportlab.platypus import Paragraph, Table, TableStyle


ROOT = Path(__file__).resolve().parents[1]
PAGE_W, PAGE_H = landscape(A3)
MARGIN = 36
CONTENT_W = PAGE_W - 2 * MARGIN
INK = colors.HexColor("#1A2F3A")
MUTED = colors.HexColor("#546773")
TEAL = colors.HexColor("#007D84")
LINE = colors.HexColor("#CFDADE")
PALE = colors.HexColor("#F3F7F8")
VIEWS = ("front", "rear", "left", "right", "section", "rear-open", "exploded")
DEFAULT_CHECKS = (
    "Geometry and regeneration", "Clearance and interference",
    "Service paths and tool access", "Sample path and separation",
    "Native and STEP exports", "Review-sheet visual inspection",
)
GUITION = (
    "https://www.guition.com/icms/upload/fb081940d6fc11f09850077a33e1404f/"
    "FTPData/UEditor/file/2026121/1768961095795/"
    "JC4880P443C_I_W%20Specifications-EN-V1.0.pdf"
)
GCT = "https://gct.co/files/drawings/usb4720.pdf"


def style(name, size=9.3, leading=13, **kw):
    return ParagraphStyle(name, fontName="Helvetica", fontSize=size,
                          leading=leading, textColor=INK, alignment=TA_LEFT, **kw)


BODY = style("body")
SMALL = style("small", 8, 11)
SMALL.textColor = MUTED
CELL = style("cell", 9, 12)
COMPACT = style("compact", 8.3, 11.2)


def para(c, text, x, top, width, paragraph_style=BODY):
    p = Paragraph(text, paragraph_style)
    _, height = p.wrap(width, PAGE_H)
    p.drawOn(c, x, top - height)
    return height


def label(c, text, x, y, size=10, color=INK, bold=False):
    c.setFillColor(color)
    c.setFont("Helvetica-Bold" if bold else "Helvetica", size)
    c.drawString(x, y, text)


def header(c, title, subtitle, page):
    c.setFillColor(TEAL)
    c.rect(MARGIN, PAGE_H - 42, 27, 4, fill=1, stroke=0)
    label(c, "TRIMIX / ENCLOSURE A2", MARGIN + 36, PAGE_H - 43,
          10, TEAL, True)
    label(c, "REVISION 03", PAGE_W - MARGIN - 104, PAGE_H - 43,
          10, MUTED, True)
    label(c, title, MARGIN, PAGE_H - 81, 25, INK, True)
    para(c, subtitle, MARGIN, PAGE_H - 98, CONTENT_W - 242, SMALL)
    c.setStrokeColor(LINE)
    c.line(MARGIN, PAGE_H - 127, PAGE_W - MARGIN, PAGE_H - 127)
    label(c, "ENGINEERING CONCEPT REVIEW", PAGE_W - MARGIN - 213,
          PAGE_H - 104, 9, TEAL, True)
    label(c, "NOT TO SCALE / PRINT RELEASE PENDING", PAGE_W - MARGIN - 213,
          PAGE_H - 118, 7.5, MUTED)
    c.line(MARGIN, 49, PAGE_W - MARGIN, 49)
    label(c, "Actual Fusion views | Measured envelopes + provisional details | Not a manufacturing drawing",
          MARGIN, 34, 8, MUTED)
    c.setFont("Helvetica", 8)
    c.setFillColor(MUTED)
    c.drawRightString(PAGE_W - MARGIN, 34,
                      f"{date.today().isoformat()} / A3 landscape / {page} of 3")


def load_views(directory):
    missing = [str(directory / f"{name}.png") for name in VIEWS
               if not (directory / f"{name}.png").is_file()]
    if missing:
        raise SystemExit("Required actual Fusion view images are missing:\n" + "\n".join(missing))
    loaded = {}
    for name in VIEWS:
        path = directory / f"{name}.png"
        with Image.open(path) as im:
            if im.format != "PNG":
                raise SystemExit(f"Expected a PNG Fusion viewport image: {path}")
            im.load()
            if min(im.size) < 500:
                raise SystemExit(f"Fusion view is too small for this review sheet: {path} {im.size}")
            rgba = im.convert("RGBA")
            bg = Image.new("RGBA", rgba.size, (255, 255, 255, 255))
            loaded[name] = Image.alpha_composite(bg, rgba).convert("RGB")
    return loaded


def load_status(path):
    result = {
        "model_state": "Model completion and checks pending evidence.",
        "checks": [{"name": name, "status": "PENDING", "evidence": "",
                    "note": "No Revision 03 result recorded."}
                   for name in DEFAULT_CHECKS],
    }
    if path is not None:
        with path.open() as handle:
            supplied = json.load(handle)
        if not isinstance(supplied, dict):
            raise SystemExit("Review status must be a JSON object.")
        result.update(supplied)
    if not isinstance(result["model_state"], str):
        raise SystemExit("model_state must be text.")
    checks = result["checks"]
    if not isinstance(checks, list) or not 1 <= len(checks) <= 6:
        raise SystemExit("Review status must contain one to six concise check entries.")
    for check in checks:
        if not isinstance(check, dict) or not all(
                isinstance(check.get(key, ""), str)
                for key in ("name", "status", "evidence", "note")):
            raise SystemExit("Each review check must have text name/status/evidence/note fields.")
        if not check.get("name") or check.get("status") not in (
                "PENDING", "PASS", "FAIL", "PARTIAL", "NOT TESTED"):
            raise SystemExit("Review check needs a name and PENDING/PASS/FAIL/PARTIAL/NOT TESTED status.")
        if check["status"] in ("PASS", "FAIL", "PARTIAL") and not check.get("evidence"):
            raise SystemExit(f"Recorded result needs an evidence reference: {check['name']}")
    bounds = result.get("overall_mm")
    if bounds is not None and (not isinstance(bounds, dict) or not all(
            isinstance(bounds.get(axis), (int, float)) and bounds[axis] > 0
            for axis in ("height", "width", "depth"))):
        raise SystemExit("overall_mm must provide positive height/width/depth numbers.")
    return result


def view_card(c, image, title, caption, x, y, width, height):
    c.setFillColor(colors.white)
    c.setStrokeColor(LINE)
    c.roundRect(x, y, width, height, 5, fill=1, stroke=1)
    label(c, title, x + 14, y + height - 24, 11, INK, True)
    c.line(x + 14, y + height - 35, x + width - 14, y + height - 35)
    area_x, area_y = x + 10, y + 56
    area_w, area_h = width - 20, height - 98
    iw, ih = image.size
    scale = min(area_w / iw, area_h / ih)
    draw_w, draw_h = iw * scale, ih * scale
    c.drawImage(ImageReader(image), area_x + (area_w - draw_w) / 2,
                area_y + (area_h - draw_h) / 2, draw_w, draw_h,
                preserveAspectRatio=True, mask="auto")
    used = para(c, caption, x + 14, y + 43, width - 28, SMALL)
    if used > 36:
        raise RuntimeError(f"View caption exceeds its reserved area: {title}")


def table(c, rows, x, top, width, fractions):
    data = [[Paragraph(cell, CELL) for cell in row] for row in rows]
    t = Table(data, colWidths=[width * fraction for fraction in fractions])
    t.setStyle(TableStyle([
        ("BACKGROUND", (0, 0), (-1, 0), PALE),
        ("ROWBACKGROUNDS", (0, 1), (-1, -1), [colors.white, PALE]),
        ("BOX", (0, 0), (-1, -1), 0.6, LINE),
        ("LINEBELOW", (0, 0), (-1, 0), 0.6, LINE),
        ("VALIGN", (0, 0), (-1, -1), "TOP"),
        ("LEFTPADDING", (0, 0), (-1, -1), 10),
        ("RIGHTPADDING", (0, 0), (-1, -1), 10),
        ("TOPPADDING", (0, 0), (-1, -1), 7),
        ("BOTTOMPADDING", (0, 0), (-1, -1), 7),
    ]))
    _, height = t.wrap(width, PAGE_H)
    t.drawOn(c, x, top - height)
    return top - height


def overview(c, images, status):
    header(c, "Compact exterior arrangement",
           "Single rear cover. Screen-only front. Left USB / right power button. "
           "Upper-left inlet and upper-right exhaust; left and right are viewed from the screen.", 1)
    gap = 14
    card_w = (CONTENT_W - 3 * gap) / 4
    specs = (
        ("front", "01 / FRONT", "4.3-inch portrait screen in the measured factory housing."),
        ("rear", "02 / REAR", "One removable cover. Separate occurrences for individual screws."),
        ("left", "03 / LEFT SIDE", "USB-C and upper gas inlet. No external O2 coax socket."),
        ("right", "04 / RIGHT SIDE", "Power button and upper gas exhaust."),
    )
    for i, (name, title, caption) in enumerate(specs):
        view_card(c, images[name], title, caption,
                  MARGIN + i * (card_w + gap), 312, card_w, 382)
    label(c, "DIMENSION REFERENCES / MILLIMETRES", MARGIN, 292, 9, TEAL, True)
    bounds = status.get("overall_mm")
    actual = (f"Actual assembly: {bounds['height']:g} H x {bounds['width']:g} W x "
              f"{bounds['depth']:g} D mm, including projections." if bounds
              else "Actual body and complete-assembly bounds await the Revision 03 model audit.")
    rows = [
        ["REFERENCE", "ENVELOPE / SIZE", "BASIS AND LIMIT"],
        ["Model body", "125 H x 75 W x 56 D", actual],
        ["Factory-cased display", "116.8 H x 69.3 W x 13.7 D",
         "Owner-measured; factory back removed. Mounting details remain provisional."],
        ["Occupied FMA holder", "80.4 H x 42 W x 20.35 D",
         "Owner-measured with cells. Include retained plug and disconnection clearance."],
        ["Active display", "56.16 W x 93.60 H; 4.3-inch",
         "Manufacturer drawing; 480 x 800 portrait. Verify offset in actual housing."],
    ]
    bottom = table(c, rows, MARGIN, 279, CONTENT_W, (0.23, 0.26, 0.51))
    para(c, "<b>Model status:</b> " + escape(status["model_state"]),
         MARGIN, bottom - 10, CONTENT_W, SMALL)
    para(c,
         f'Sources: owner measurements; <link href="{GUITION}" color="#007D84">Guition specification</link>; '
         f'<link href="{GCT}" color="#007D84">GCT USB4720 Revision B drawing</link>. '
         "See MEASUREMENTS.md for part identities and remaining measurements. "
         "Views are resized independently; do not measure these sheets.",
         MARGIN, 82, CONTENT_W, SMALL)
    if bottom < 117:
        raise RuntimeError("Dimension table exceeds page 1 reserved area.")
    c.showPage()


def note(c, title, body, x, top, width, compact=False):
    used = para(c, f"<b>{title}</b><br/>{body}", x, top, width,
                COMPACT if compact else BODY)
    return top - used - (12 if compact else 17)


def internal(c, images):
    header(c, "Internal packaging and service access",
           "L-shaped chamber across the upper region and down the viewer's left side. "
           "Measured pack sits low behind the display; future PCB geometry remains a mechanical target.", 2)
    left_w, gap = 742, 16
    card_w = (left_w - gap) / 2
    side_x, side_w = MARGIN + left_w + 24, CONTENT_W - left_w - 24
    view_card(c, images["rear-open"], "05 / REAR OPEN",
              "Rear cover hidden. Inspect the actual internal arrangement and rear-accessible retainers.",
              MARGIN, 202, card_w, 492)
    view_card(c, images["section"], "06 / SECTION",
              "Screen left; rear cover right. Hatched cut shows display, pack and PCB depth clearances.",
              MARGIN + card_w + gap, 202, card_w, 492)
    label(c, "PACKAGING INTENT", side_x, 678, 11, TEAL, True)
    top = 657
    for title, body in (
        ("Display removal is forward",
         "Remove the single rear cover, disconnect the module and release rear retainers. "
         "Then lift the complete factory-cased display through the front. Actual frame capture and retention are unvalidated."),
        ("L-shaped sampling chamber",
         "AO2 axis along X; CO and MD62 in the viewer's-left column. Keep the gas path enclosed "
         "when the outer cover is removed."),
        ("Battery and future PCB",
         "Keep the protected holder low behind the display. Reserve plug access first. "
         "The reshaped PCB clearance is not a completed KiCad layout."),
        ("Side interfaces",
         "Support the GCT connector's separate 0.60 mm board. Include button nut, terminals, "
         "real plug overmould and wiring clearance."),
        ("Gas and temperature",
         "Leave an open route from inlet to exhaust around the installed sensors. "
         "The lower He/CO column can be bypassed; sample renewal is unvalidated. "
         "Avoid a direct inlet jet at CO and local heating of humidity sensing."),
    ):
        top = note(c, title, body, side_x, top, side_w)
    if top < 72:
        raise RuntimeError("Internal packaging notes exceed page 2.")
    c.setFillColor(PALE)
    c.setStrokeColor(LINE)
    c.roundRect(MARGIN, 84, left_w, 97, 5, fill=1, stroke=1)
    label(c, "READING THE MODEL", MARGIN + 16, 160, 10, TEAL, True)
    para(c, "<b>+X = viewer's left; +Y = up; +Z = rearward.</b> "
         "Rear views reverse visual left/right. Owner measurements establish display and pack envelopes; "
         "manufacturer-derived details and provisional clearances must retain their source labels.",
         MARGIN + 16, 144, left_w - 32, BODY)
    para(c, "Gas seals, fastener fit, purchased-part tolerances and flexible harness behaviour "
         "require physical checks. Visual separation in a view is not an interference or flow test.",
         MARGIN + 16, 104, left_w - 32, SMALL)
    c.showPage()


def exploded(c, images, status):
    header(c, "Exploded assembly and evidence",
           "One rear cover exposes the service fasteners. Individual screws remain separate assembly occurrences. "
           "The exploded arrangement illustrates relationships; it does not prove an extraction path.", 3)
    left_w = 750
    side_x, side_w = MARGIN + left_w + 24, CONTENT_W - left_w - 24
    view_card(c, images["exploded"], "07 / EXPLODED ASSEMBLY",
              "Actual Fusion assembly view. Display leaves forward after rear retainer release; "
              "pack, carrier and chamber service through the rear subject to verified prerequisites.",
              MARGIN, 133, left_w, 561)
    label(c, "SERVICE ORDER TO VERIFY", side_x, 678, 11, TEAL, True)
    top = 657
    top = note(c, "1 / Isolate and open",
               "Unplug USB, remove the cover and disconnect the reachable battery plug first.",
               side_x, top, side_w, True)
    top = note(c, "2 / Remove carrier, then chamber",
               "Remove shared carrier/PCB screws. Detach gas fittings and chamber attachments; withdraw the closed cartridge.",
               side_x, top, side_w, True)
    top = note(c, "3 / Shift the protected pack",
               "Use the recorded 9-degree in-plane turn, upward/sideways shifts, then rear withdrawal. "
               "See README for the exact order; direct rear extraction is not the checked path.",
               side_x, top, side_w, True)
    top = note(c, "4 / Release display from the rear",
               "Remove its retainers and wiring, then lift the complete module forward. Frame retention is not yet validated.",
               side_x, top, side_w, True)
    label(c, "RECORDED CAD CHECKS", side_x, top - 1, 10, TEAL, True)
    top -= 20
    for check in status["checks"]:
        body = escape(check.get("note", ""))
        evidence = check.get("evidence", "")
        if evidence:
            body += ("<br/>" if body else "") + "Evidence: " + escape(evidence)
        top = note(c, escape(check["name"]) + " / " + escape(check["status"]),
                   body, side_x, top, side_w, True)
    if top < 67:
        raise RuntimeError("Evidence notes exceed page 3; keep check notes concise.")
    para(c, "<b>Prototype boundary:</b> editable Fusion + STEP + review sheets. "
         "PLA fit testing on the Bambu H2D follows hardware measurements and clearance review. "
         "Print-ready release, final material, sealing and gas-response validation remain pending.",
         MARGIN, 112, left_w, BODY)
    c.showPage()


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--views", type=Path, default=ROOT / "views")
    parser.add_argument("--output", type=Path,
                        default=ROOT / "Trimix_Enclosure_A2_Review.pdf")
    parser.add_argument("--status", type=Path,
                        help="Explicit reviewed evidence JSON; omitted means checks pending.")
    args = parser.parse_args()
    images = load_views(args.views)
    status = load_status(args.status)
    args.output.parent.mkdir(parents=True, exist_ok=True)
    c = canvas.Canvas(str(args.output), pagesize=(PAGE_W, PAGE_H), pageCompression=1)
    c.setTitle("Trimix Enclosure A2 - Revision 03 Engineering Concept Review")
    c.setAuthor("Trimix analyzer project")
    c.setSubject("Actual Fusion views, measured envelopes and provisional compact packaging; not to scale")
    overview(c, images, status)
    internal(c, images)
    exploded(c, images, status)
    c.save()
    print(f"Created {args.output} (3 pages, A3 landscape)")


if __name__ == "__main__":
    main()
