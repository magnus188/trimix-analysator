"""Export the final editable PPTX to the matching 22-page PDF and QA renders.

Uses only the bundled LibreOffice, never the user's desktop application.
Requires pypdf from the documented bundled Python environment.
Visual review of every PNG remains mandatory after this structural check.
"""
from __future__ import annotations
import argparse
import hashlib
import json
import os
import subprocess
import xml.etree.ElementTree as ET
from pathlib import Path
from urllib.parse import unquote, urlsplit
from zipfile import ZipFile
from pypdf import PdfReader, PdfWriter
from pypdf.generic import NameObject, TextStringObject

RELEASE = Path(__file__).resolve().parents[1]
DOCS = RELEASE / "docs"
RUNTIME = Path(os.environ.get("GUIDE_RUNTIME", "/Users/magnustrandokken/.cache/codex-runtimes/codex-primary-runtime/dependencies"))
SOFFICE = RUNTIME / "bin/override/soffice"
PDFTOPPM = RUNTIME / "bin/override/pdftoppm"
NS = {"p": "http://schemas.openxmlformats.org/presentationml/2006/main",
      "a": "http://schemas.openxmlformats.org/drawingml/2006/main"}


def export_and_check(pptx: Path):
    pptx = pptx.resolve()
    if pptx.parent != DOCS.resolve() or not pptx.is_file():
        raise ValueError("Supply a finalized guide PPTX from this release's docs directory.")
    pdf = pptx.with_suffix(".pdf")
    if pdf.exists():
        raise FileExistsError("Use a new revision filename instead of overwriting a delivered PDF.")
    build = RELEASE / "scripts/guide-build"
    render_dir = build / (pptx.stem + "-pages")
    render_dir.mkdir(parents=True, exist_ok=True)
    with ZipFile(pptx) as archive:
        slides = [n for n in archive.namelist() if n.startswith("ppt/slides/slide") and n.endswith(".xml")]
        if len(slides) != 22:
            raise ValueError(f"PPTX contains {len(slides)} slides; expected exactly 22.")
        native_table_count = sum(len(ET.fromstring(archive.read(n)).findall(".//a:tbl", NS)) for n in slides)
        if native_table_count != 8:
            raise ValueError(f"Expected 8 editable tables, found {native_table_count}.")
    # A fresh private LibreOffice profile avoids disturbing the user's sessions.
    profile = build / (pptx.stem + "-lo-profile")
    subprocess.run([str(SOFFICE), "-env:UserInstallation=" + profile.as_uri(),
                    "--headless", "--convert-to", "pdf:impress_pdf_Export",
                    "--outdir", str(DOCS), str(pptx)], check=True, timeout=180)
    if not pdf.is_file():
        raise RuntimeError("Bundled LibreOffice did not produce the expected PDF.")
    reader = PdfReader(pdf)
    # Keep local companion-document links portable if LibreOffice expands them
    # into host-specific file URIs. This changes link targets, never page art.
    links_rewritten = 0
    repository = RELEASE.parents[3]
    for page in reader.pages:
        for reference in page.get("/Annots", []):
            annotation = reference.get_object()
            action = annotation.get("/A")
            if action is not None:
                action = action.get_object()
            if not action or action.get("/S") != "/URI":
                continue
            uri = str(action.get("/URI", ""))
            if not uri.startswith("file:"):
                continue
            target = Path(unquote(urlsplit(uri).path)).resolve()
            if target.is_relative_to(repository):
                action[NameObject("/URI")] = TextStringObject(os.path.relpath(target, DOCS))
                links_rewritten += 1
    if links_rewritten:
        portable = build / (pptx.stem + "-portable.pdf")
        writer = PdfWriter()
        writer.clone_document_from_reader(reader)
        with portable.open("wb") as stream:
            writer.write(stream)
        portable.replace(pdf)
        reader = PdfReader(pdf)
    if len(reader.pages) != 22:
        raise ValueError(f"PDF contains {len(reader.pages)} pages; expected exactly 22.")
    content = json.loads((build / "resolved-content.json").read_text())
    page_checks = []
    for i, (page, source) in enumerate(zip(reader.pages, content), 1):
        text = page.extract_text() or ""
        normalized = " ".join(text.split())
        title = " ".join(source["title"].split())
        if title not in normalized:
            raise ValueError(f"Missing page {i} title in PDF text: {title}")
        if "{{" in text or "}}" in text:
            raise ValueError(f"Unresolved template token on page {i}.")
        links = []
        for reference in page.get("/Annots", []):
            annotation = reference.get_object()
            if annotation.get("/Subtype") == "/Link":
                action = annotation.get("/A", {})
                if hasattr(action, "get_object"):
                    action = action.get_object()
                target = str(action.get("/URI", action.get("/F", "")))
                if target:
                    links.append(target)
        if len(links) < len(source["refs"]):
            raise ValueError(f"Page {i} has fewer clickable source links than expected: {links}")
        page_checks.append({"page": i, "title": source["title"], "extracted_characters": len(text),
                            "clickable_source_links": links,
                            "visual_review": "pending"})
    subprocess.run([str(PDFTOPPM), "-png", "-scale-to", "1600", str(pdf),
                    str(render_dir / "page")], check=True, timeout=180)
    images = sorted(render_dir.glob("page-*.png"))
    if len(images) != 22:
        raise ValueError(f"Expected 22 review images, found {len(images)}.")
    report = {
        "status": "structural_checks_passed_visual_review_pending",
        "pdf": str(pdf.relative_to(RELEASE)), "pptx": str(pptx.relative_to(RELEASE)),
        "pdf_sha256": hashlib.sha256(pdf.read_bytes()).hexdigest(),
        "pptx_sha256": hashlib.sha256(pptx.read_bytes()).hexdigest(),
        "slides": 22, "pages": 22, "native_tables": native_table_count,
        "portable_local_links_rewritten": links_rewritten,
        "renderer": str(SOFFICE), "render_directory": str(render_dir.relative_to(RELEASE)),
        "page_checks": page_checks,
        "scope": "Matching final PPTX/PDF content and structural checks. Manual page review remains pending.",
    }
    report_file = build / (pptx.stem + "-qa.json")
    report_file.write_text(json.dumps(report, indent=2) + "\n")
    return report


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("pptx", type=Path)
    args = parser.parse_args()
    print(json.dumps(export_and_check(args.pptx), indent=2))
