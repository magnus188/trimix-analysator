#!/usr/bin/env python3
"""Build a two-page A3 review PDF from the six actual Fusion viewport PNGs.

Run with the Codex workspace Python (ReportLab and Pillow required). Missing or
unreadable views are fatal: this generator never substitutes synthetic imagery.
"""

from __future__ import annotations

import argparse
from datetime import date
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
WHITE = colors.white
VIEWS = ("front", "rear", "left", "right", "section", "rear-open")
GUITION = (
    "https://www.guition.com/icms/upload/fb081940d6fc11f09850077a33e1404f/"
    "FTPData/UEditor/file/2026121/1768961095795/"
    "JC4880P443C_I_W%20Specifications-EN-V1.0.pdf"
)
GCT = "https://www.mouser.com/pdfDocs/USB4720-ProductDrawing.pdf"


def style(name: str, size: float = 9.3, leading: float = 13, **kw):
    return ParagraphStyle(
        name, fontName="Helvetica", fontSize=size, leading=leading,
        textColor=INK, alignment=TA_LEFT, **kw
    )


BODY = style("body")
SMALL = ParagraphStyle(
    "small", parent=BODY, fontSize=8, leading=11, textColor=MUTED
)
CELL = ParagraphStyle("cell", parent=BODY, fontSize=9, leading=12)


def para(c, text, x, top, width, paragraph_style=BODY):
    p = Paragraph(text, paragraph_style)
    _, height = p.wrap(width, PAGE_H)
    p.drawOn(c, x, top - height)
    return height


def label(c, text, x, y, size=10, color=INK, bold=False):
    c.setFillColor(color)
    c.setFont("Helvetica-Bold" if bold else "Helvetica", size)
    c.drawString(x, y, text)


def header(c, section, subtitle, number):
    c.setFillColor(TEAL)
    c.rect(MARGIN, PAGE_H - 42, 27, 4, fill=1, stroke=0)
    label(c, "TRIMIX / ENCLOSURE A1", MARGIN + 36, PAGE_H - 43,
          10, TEAL, True)
    label(c, "REVISION 02", PAGE_W - MARGIN - 104, PAGE_H - 43,
          10, MUTED, True)
    label(c, section, MARGIN, PAGE_H - 81, 25, INK, True)
    para(c, subtitle, MARGIN, PAGE_H - 98, CONTENT_W - 228, SMALL)
    c.setStrokeColor(LINE)
    c.line(MARGIN, PAGE_H - 127, PAGE_W - MARGIN, PAGE_H - 127)
    label(c, "ENGINEERING CONCEPT REVIEW", PAGE_W - MARGIN - 213,
          PAGE_H - 104, 9, TEAL, True)
    label(c, "NOT TO SCALE / FIT PROTOTYPE", PAGE_W - MARGIN - 213,
          PAGE_H - 118, 8, MUTED)
    footer(c, number)


def footer(c, number):
    c.setStrokeColor(LINE)
    c.line(MARGIN, 49, PAGE_W - MARGIN, 49)
    label(c, "Actual Fusion views | Provisional dimensions | Not a manufacturing drawing",
          MARGIN, 34, 8, MUTED)
    c.setFont("Helvetica", 8)
    c.setFillColor(MUTED)
    c.drawRightString(PAGE_W - MARGIN, 34,
                      f"{date.today().isoformat()}  /  A3 landscape  /  {number} of 2")


def load_views(directory):
    missing = [str(directory / f"{name}.png") for name in VIEWS
               if not (directory / f"{name}.png").is_file()]
    if missing:
        raise SystemExit("Required Fusion view images are missing:\n" + "\n".join(missing))
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
            white_background = Image.new("RGBA", rgba.size, (255, 255, 255, 255))
            loaded[name] = Image.alpha_composite(white_background, rgba).convert("RGB")
    return loaded


def view_card(c, image, title, caption, x, y, width, height):
    c.setFillColor(WHITE)
    c.setStrokeColor(LINE)
    c.roundRect(x, y, width, height, 5, fill=1, stroke=1)
    label(c, title, x + 14, y + height - 24, 11, INK, True)
    c.setStrokeColor(LINE)
    c.line(x + 14, y + height - 35, x + width - 14, y + height - 35)
    # Preserve complete viewport image and aspect ratio; never crop CAD geometry.
    area_x, area_y = x + 10, y + 53
    area_w, area_h = width - 20, height - 95
    iw, ih = image.size
    scale = min(area_w / iw, area_h / ih)
    draw_w, draw_h = iw * scale, ih * scale
    c.drawImage(ImageReader(image), area_x + (area_w - draw_w) / 2,
                area_y + (area_h - draw_h) / 2, draw_w, draw_h,
                preserveAspectRatio=True, mask="auto")
    para(c, caption, x + 14, y + 40, width - 28, SMALL)


def dimension_table(c, x, top, width):
    rows = [
        ["DESIGN REFERENCE", "NOMINAL DIMENSION", "BASIS / REVIEW NOTE"],
        ["Housing envelope", "180 H x 95 W x 60 D mm",
         "Current complete model width is 107 mm including side projections. Physical fit remains unconfirmed."],
        ["Walls / single rear cover", "3 mm wall / 2.75 mm cover",
         "Cover Z = 57.25-60 mm: nominal 3 mm allocation includes a 0.25 mm seating gap."],
        ["Portrait display envelope", "69.41 W x 117.01 H mm",
         "Guition published larger assembly. Confirm bare/shell variant and complete depth."],
        ["Active display area", "56.16 W x 93.60 H mm",
         "4.3-inch diagonal, 480 x 800 portrait. Mounting offsets require physical confirmation."],
    ]
    data = [[Paragraph(cell, CELL) for cell in row] for row in rows]
    table = Table(data, colWidths=[width * 0.24, width * 0.25, width * 0.51])
    table.setStyle(TableStyle([
        ("BACKGROUND", (0, 0), (-1, 0), PALE),
        ("ROWBACKGROUNDS", (0, 1), (-1, -1), [WHITE, PALE]),
        ("BOX", (0, 0), (-1, -1), 0.6, LINE),
        ("LINEBELOW", (0, 0), (-1, 0), 0.6, LINE),
        ("VALIGN", (0, 0), (-1, -1), "TOP"),
        ("LEFTPADDING", (0, 0), (-1, -1), 10),
        ("RIGHTPADDING", (0, 0), (-1, -1), 10),
        ("TOPPADDING", (0, 0), (-1, -1), 7),
        ("BOTTOMPADDING", (0, 0), (-1, -1), 7),
    ]))
    _, height = table.wrap(width, PAGE_H)
    table.drawOn(c, x, top - height)
    return top - height


def overview(c, images):
    header(c, "Exterior arrangement",
           "Single rear cover. Screen-only front. Upper left-to-right sampling flow. "
           "Left and right are defined while looking at the screen.", 1)
    gap = 14
    card_w = (CONTENT_W - 3 * gap) / 4
    y, height = 295, 399
    specs = (
        ("front", "01 / FRONT", "4.3-inch portrait screen and bezel only."),
        ("rear", "02 / REAR", "One cover opens access to the complete assembly."),
        ("left", "03 / LEFT SIDE", "USB-C below the upper gas inlet."),
        ("right", "04 / RIGHT SIDE", "Power button below the upper gas exhaust."),
    )
    for i, (name, title, caption) in enumerate(specs):
        view_card(c, images[name], title, caption,
                  MARGIN + i * (card_w + gap), y, card_w, height)
    label(c, "PARAMETER REFERENCES / ALL DIMENSIONS IN MILLIMETRES",
          MARGIN, 276, 9, TEAL, True)
    bottom = dimension_table(c, MARGIN, 263, CONTENT_W)
    para(c,
         f'Sources: <link href="{GUITION}" color="#007D84">Guition module specification</link>'
         f' and <link href="{GCT}" color="#007D84">GCT USB4720 drawing</link>. '
         "Detailed component references and unmeasured features: MEASUREMENTS.md. "
         "View images are resized independently; do not measure this sheet.",
         MARGIN, bottom - 9, CONTENT_W, SMALL)
    c.showPage()


def checklist_item(c, title, body, x, top, width):
    c.setStrokeColor(TEAL)
    c.setLineWidth(0.8)
    c.rect(x, top - 9, 7, 7, fill=0, stroke=1)
    height = para(c, f"<b>{title}</b><br/>{body}",
                  x + 17, top, width - 17, BODY)
    return top - height - 17


def service(c, images):
    header(c, "Assembly and service review",
           "The upper chamber remains separate from the battery and electronics. "
           "Clearance bodies represent unmeasured parts; they are not qualified production geometry.", 2)
    gap = 16
    left_w = 740
    side_x = MARGIN + left_w + 24
    side_w = PAGE_W - MARGIN - side_x
    card_w = (left_w - gap) / 2
    view_card(c, images["section"], "05 / SECTION REVIEW",
              "Section at X = 0; front is on the right. Inspect the display stack and chamber separation.",
              MARGIN, 225, card_w, 469)
    view_card(c, images["rear-open"], "06 / REAR OPEN",
              "Rear cover and internal chamber lid hidden for review of sensors and service access.",
              MARGIN + card_w + gap, 225, card_w, 469)

    label(c, "FIT AND ACCESS CHECKLIST", side_x, 679, 11, TEAL, True)
    top = 657
    items = (
        ("One rear access cover",
         "Confirm screw engagement in the selected M3 inserts and clear screwdriver access."),
        ("Rearward service sequence",
         "Disconnect battery first. Remove pack, USB insert and button before carrier/display; remove gas stubs before chamber. See README for the tested sequence."),
        ("Controls and connections",
         "Verify right-side button barrel, nut and terminals; left-side USB plug and supported daughterboard clearances."),
        ("Upper cross-flow chamber",
         "Maintain an open inlet-to-exhaust passage, sealed wire feedthroughs and separation from the electrical compartment."),
        ("Actual component fit",
         "Measure the display variant, protected holder and plug, sensors, BME280 board, wiring and installed inserts."),
        ("Prototype release",
         "Review interference, cable bends and removal paths in Fusion. PLA fit prototype only; final seals and material remain open."),
    )
    for title, body in items:
        top = checklist_item(c, title, body, side_x, top, side_w)
    if top < 60:
        raise RuntimeError("Service checklist exceeds the page; shorten text or adjust spacing.")

    c.setFillColor(PALE)
    c.setStrokeColor(LINE)
    c.roundRect(MARGIN, 89, left_w, 115, 5, fill=1, stroke=1)
    label(c, "REVIEW INTENT", MARGIN + 16, 182, 10, TEAL, True)
    para(c,
         "<b>Front Z = 0. X points left as viewed from the front, Y points up, Z points rearward.</b> "
         "All internal parts need a feasible removal sequence through the rear opening. "
         "The gas connections and button must not trap the chamber or carrier.",
         MARGIN + 16, 166, left_w - 32, BODY)
    para(c,
         "These views document the current concept; they do not establish manufacturing tolerances, "
         "pressure containment, weather sealing or validated sensor performance. "
         "Confirm outstanding dimensions in MEASUREMENTS.md before preparing the Bambu H2D PLA fit print.",
         MARGIN + 16, 123, left_w - 32, SMALL)
    c.showPage()


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--views", type=Path, default=ROOT / "views")
    parser.add_argument("--output", type=Path,
                        default=ROOT / "Trimix_Enclosure_A1_Review.pdf")
    args = parser.parse_args()
    images = load_views(args.views)
    args.output.parent.mkdir(parents=True, exist_ok=True)
    c = canvas.Canvas(str(args.output), pagesize=(PAGE_W, PAGE_H), pageCompression=1)
    c.setTitle("Trimix Enclosure A1 - Revision 02 Engineering Concept Review")
    c.setAuthor("Trimix analyzer project")
    c.setSubject("Actual Fusion views, nominal dimensions and prototype fit checks; not to scale")
    overview(c, images)
    service(c, images)
    c.save()
    print(f"Created {args.output} (2 pages, A3 landscape)")


if __name__ == "__main__":
    main()
