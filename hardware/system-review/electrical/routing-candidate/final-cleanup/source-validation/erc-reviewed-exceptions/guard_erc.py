#!/usr/bin/env python3
"""Fail-closed review of one LM66100 ST-to-GND ERC exception; no source edits."""
from __future__ import annotations

import argparse
import copy
import hashlib
import json
import os
import re
import subprocess
import sys
import xml.etree.ElementTree as ET
from datetime import datetime, timezone
from decimal import Decimal
from pathlib import Path

HERE = Path(__file__).resolve().parent
REPO = HERE.parents[3]
DEFAULT_ROOT = REPO / "hardware/pcb/analyzer/Trimix_Analyzer.kicad_sch"
DEFAULT_ERC = HERE.parent / "local-input-cap-erc.json"
CLI = "/Applications/KiCad/KiCad.app/Contents/MacOS/kicad-cli"
ROOT_UUID = "be5f93e7-90aa-5980-82d3-22f711149c2a"
GAUGE_UUID = "25c2a9f5-b13a-5aa2-b2a5-6332e3904bbb"
SHEET_PATH = "/03  GUITION + FUEL GAUGE/"
UUID_PATH = f"/{ROOT_UUID}/{GAUGE_UUID}"
U302_UUID = "5b884914-2a77-4cce-9416-53594c6d3d76"
ST_UUID = "991d920b-13e3-4e55-b85b-3e724f870c86"
FLAG_UUID = "ede70981-302d-4b14-b504-703421d2a612"
FLAG_PIN_UUID = "4b8e713f-edeb-4760-98ca-954d700f013d"
EXPECTED = {
    "description": "Pins of type Open collector and Power output are connected",
    "items": [
        {"description": "Symbol U302 Pin 5 [ST, Open collector, Line]",
         "uuid": ST_UUID},
        {"description": "Symbol #FLG0103 Pin 1 [Power output, Line]",
         "uuid": FLAG_PIN_UUID},
    ],
    "severity": "error", "type": "pin_to_pin",
}
IGNORED = {"single_global_label", "four_way_junction", "simulation_model_issue", "footprint_filter"}
PRIMARY = {"url": "https://www.ti.com/lit/ds/symlink/lm66100.pdf",
           "document": "LM66100 SLVSEZ8A, Revision A, June 2019",
           "page": 3, "section": "5 Pin Configuration and Functions, pin 5 ST",
           "quote": "Connect to GND if not required.", "reviewed_utc_date": "2026-09-07"}


class Rejected(Exception):
    pass


def require(condition, message):
    if not condition:
        raise Rejected(message)


def children(node, kind):
    return [x for x in node if isinstance(x, list) and x and x[0] == kind]


def one(node, kind):
    found = children(node, kind)
    require(len(found) == 1, f"Expected one {kind}, found {len(found)}")
    return found[0]


def props(node):
    rows = children(node, "property")
    require(len({x[1] for x in rows}) == len(rows), "Duplicate schematic property")
    return {x[1]: x[2] for x in rows}


def parse_schematic(data, root_kind="kicad_sch"):
    tokens = re.findall(r'"(?:\\.|[^"\\])*"|[^\s()]+|[()]', data)
    stack, roots = [], []
    for token in tokens:
        if token == "(":
            stack.append([])
        elif token == ")":
            require(bool(stack), "Unbalanced schematic parentheses")
            node = stack.pop()
            (stack[-1] if stack else roots).append(node)
        else:
            require(bool(stack), "Atom outside schematic")
            stack[-1].append(json.loads(token) if token.startswith('"') else token)
    require(not stack and len(roots) == 1 and roots[0][0] == root_kind, "Invalid S-expression document")
    return roots[0]


def load_hierarchy(root):
    documents, sheet_paths, parsed_hashes = {}, {}, {}

    def visit(path, name, uuid_path):
        path = path.resolve()
        require(path not in documents, "Repeated/recursive schematic instance is outside this review")
        data = path.read_bytes()
        parsed_hashes[path] = fingerprint(data)
        document = parse_schematic(data.decode())
        documents[path] = document
        sheet_paths[name] = uuid_path
        for sheet in children(document, "sheet"):
            pr = {k.replace(" ", "").lower(): v for k, v in props(sheet).items()}
            visit(path.parent / pr["sheetfile"], name + pr["sheetname"] + "/",
                  uuid_path + "/" + one(sheet, "uuid")[1])

    visit(root, "/", "/" + ROOT_UUID)
    require(one(documents[root.resolve()], "uuid")[1] == ROOT_UUID, "Root schematic UUID changed")
    return documents, sheet_paths, parsed_hashes


def library_inputs(root, documents, global_table, symbol_dir):
    """Resolve the native project/global symbol tables, including nested tables."""
    paths, libraries, parsed_hashes = {}, {}, {}
    variables = {**os.environ, "KIPRJMOD": str(root.parent), "KICAD10_SYMBOL_DIR": str(symbol_dir)}
    common = global_table.parent / "kicad_common.json"
    if common.is_file():
        data = common.read_bytes()
        paths["library-resolution-settings"] = common
        parsed_hashes[common] = fingerprint(data)
        configured = json.loads(data).get("environment", {}).get("vars") or {}
        variables.update(configured)

    def expand(uri):
        value = re.sub(r"\$\{([^}]+)\}", lambda m: variables.get(m[1], m[0]), uri)
        require("${" not in value, f"Unresolved symbol library URI: {uri}")
        return Path(value).expanduser().resolve()

    seen = set()

    def table(path):
        path = path.resolve()
        require(path not in seen, "Recursive/repeated symbol table")
        seen.add(path)
        paths[f"symbol-table:{len(seen)}:{path.name}"] = path
        data = path.read_bytes()
        parsed_hashes[path] = fingerprint(data)
        tree = parse_schematic(data.decode(), "sym_lib_table")
        for lib in children(tree, "lib"):
            kind, uri = one(lib, "type")[1], expand(one(lib, "uri")[1])
            if kind == "Table":
                table(uri)
            else:
                require(kind == "KiCad", f"Unsupported symbol library type: {kind}")
                libraries[one(lib, "name")[1]] = uri

    table(global_table)
    table(root.parent / "sym-lib-table")
    used = {one(s, "lib_id")[1].split(":")[0] for d in documents.values() for s in children(d, "symbol")}
    for name in sorted(used):
        require(name in libraries and libraries[name].is_file(), f"Unresolved used symbol library: {name}")
        paths["symbol-library:" + name] = libraries[name]
    return paths, parsed_hashes


def coordinate(values):
    return tuple(int(Decimal(str(v)) * 1_000_000) for v in values[:2])


def symbol_pin(document, ref, pin_number, symbol_uuid, pin_uuid, lib_id, pin_type, pin_name):
    symbols = [n for n in children(document, "symbol") if props(n).get("Reference") == ref]
    require(len(symbols) == 1, f"Expected unique {ref} schematic symbol")
    symbol = symbols[0]
    require(one(symbol, "uuid")[1] == symbol_uuid, f"{ref} symbol UUID changed")
    require(one(symbol, "lib_id")[1] == lib_id, f"{ref} library identity changed")
    require(one(symbol, "unit")[1] == "1", f"{ref} unit changed")
    require(not children(symbol, "mirror") and one(symbol, "at")[3] == "0",
            f"{ref} orientation changed; this bounded wiring review requires reassessment")
    instances = children(one(one(symbol, "instances"), "project"), "path")
    require(len(instances) == 1 and instances[0][1] == UUID_PATH
            and one(instances[0], "reference")[1] == ref, f"{ref} instance path changed")
    pins = [n for n in children(symbol, "pin") if n[1] == pin_number]
    require(len(pins) == 1 and one(pins[0], "uuid")[1] == pin_uuid, f"{ref}.{pin_number} pin UUID changed")
    libraries = [n for n in children(one(document, "lib_symbols"), "symbol") if n[1] == lib_id]
    require(len(libraries) == 1, f"Missing/duplicate cached library {lib_id}")
    definitions = [p for unit in children(libraries[0], "symbol") for p in children(unit, "pin")
                   if one(p, "number")[1] == pin_number]
    require(len(definitions) == 1, f"Ambiguous {ref}.{pin_number} library pin")
    definition = definitions[0]
    require(definition[1:3] == [pin_type, "line"] and one(definition, "name")[1] == pin_name,
            f"{ref}.{pin_number} pin function/type changed")
    origin, local = coordinate(one(symbol, "at")[1:]), coordinate(one(definition, "at")[1:])
    return symbol, (origin[0] + local[0], origin[1] - local[1])


def connected_labels(document, point, required_anchor=None):
    """Trace the local wire component to labels, independently of exported XML.

    This exact drawing uses global GND labels and a verified power:GND pin. Coordinates use
    integer nanometres; intersections connect only at explicit wire endpoints,
    junctions, or labelled/pin points, avoiding invented crossing junctions.
    """
    wires = [tuple(coordinate(n[1:]) for n in children(one(w, "pts"), "xy"))
             for w in children(document, "wire")]
    require(all(len(w) == 2 for w in wires), "Unexpected wire geometry")
    labels = [(coordinate(one(n, "at")[1:]), n[1]) for kind in ("global_label", "label", "hierarchical_label")
              for n in children(document, kind)]
    libraries = {n[1]: n for n in children(one(document, "lib_symbols"), "symbol")}
    for symbol in children(document, "symbol"):
        lib = libraries.get(one(symbol, "lib_id")[1])
        if lib is None or not children(lib, "power"):
            continue
        pins = [p for unit in children(lib, "symbol") for p in children(unit, "pin")]
        require(len(pins) == 1 and coordinate(one(pins[0], "at")[1:]) == (0, 0),
                "Power symbol geometry changed")
        pin_name = one(pins[0], "name")[1]
        if pins[0][1] == "power_out" and one(symbol, "lib_id")[1] == "power:PWR_FLAG":
            continue
        require(pins[0][1:3] == ["power_in", "line"] and one(pins[0], "number")[1] == "1",
                "Power net anchor pin type/number changed")
        # KiCad 10's cached power:GND has an empty pin name; its global-power
        # definition and matching cached/instance Value establish the net name.
        netname = props(lib).get("Value")
        require(one(lib, "power")[1] == "global" and bool(netname), "Power anchor definition changed")
        if one(symbol, "lib_id")[1] == "power:GND":
            require(netname == "GND" and pin_name == "", "Cached power:GND identity changed")
        require(props(symbol).get("Value") == netname, "Power symbol net name/value changed")
        labels.append((coordinate(one(symbol, "at")[1:]), netname))
    points = {point} | {q for w in wires for q in w} | {q for q, _ in labels}
    if required_anchor is not None:
        points.add(required_anchor)
    points |= {coordinate(one(n, "at")[1:]) for n in children(document, "junction")}
    parent = {q: q for q in points}

    def find(q):
        while parent[q] != q:
            parent[q] = parent[parent[q]]
            q = parent[q]
        return q

    for a, z in wires:
        for q in points:
            if ((q[0] - a[0]) * (z[1] - a[1]) == (q[1] - a[1]) * (z[0] - a[0])
                    and min(a[0], z[0]) <= q[0] <= max(a[0], z[0])
                    and min(a[1], z[1]) <= q[1] <= max(a[1], z[1])):
                parent[find(q)] = find(a)
    require(not any(coordinate(one(n, "at")[1:]) == point for n in children(document, "no_connect")),
            "Reviewed pin has a no-connect marker")
    if required_anchor is not None:
        require(find(point) == find(required_anchor), "Flag no longer wired to its verified GND anchor")
    return {name for q, name in labels if find(q) == find(point)}


def validate(report, netlist, documents, sheet_paths):
    require(report.get("$schema") == "https://schemas.kicad.org/erc.v1.json", "Unexpected ERC schema")
    require(report.get("source") == "Trimix_Analyzer.kicad_sch", "ERC source changed")
    require(set(report.get("included_severities", [])) == {"error", "warning"}, "Incomplete ERC severities")
    require({x["key"] for x in report.get("ignored_checks", [])} == IGNORED, "ERC ignored-check policy changed")
    sheets = report.get("sheets", [])
    require(len(sheets) == len(sheet_paths) and {x["path"]: x["uuid_path"] for x in sheets} == sheet_paths,
            "ERC report does not cover the complete current hierarchy")
    violations = [(s["path"], s["uuid_path"], without_positions(v)) for s in sheets for v in s["violations"]]
    require(violations == [(SHEET_PATH, UUID_PATH, EXPECTED)],
            "Unexpected ERC violation, changed reviewed violation, or missing reviewed error")
    gauge = [n for n in documents.values() if one(n, "uuid")[1] == GAUGE_UUID]
    require(len(gauge) == 1, "Reviewed gauge schematic UUID missing/duplicated")
    gauge = gauge[0]
    u302, st = symbol_pin(gauge, "U302", "5", U302_UUID, ST_UUID,
                           "Trimix_Analyzer:LM66100_DCK", "open_collector", "ST")
    _, gnd = symbol_pin(gauge, "U302", "2", U302_UUID, "f773c8d4-fd5b-4824-8e7b-5b49d2e0262c",
                        "Trimix_Analyzer:LM66100_DCK", "power_in", "GND")
    _, flag = symbol_pin(gauge, "#FLG0103", "1", FLAG_UUID, FLAG_PIN_UUID,
                         "power:PWR_FLAG", "power_out", "")
    _, ground_anchor = symbol_pin(gauge, "#PWR4003", "1", "4817470e-37ca-46a6-a8ca-5d33d92d6130",
                                  "aed34d8e-3946-41c4-9f71-83fb53481dec", "power:GND", "power_in", "")
    require(props(u302).get("Value") == "LM66100DCKR" and props(u302).get("MPN") == "LM66100DCKR",
            "U302 purchased part identity changed")
    for name, point in (("U302.5", st), ("U302.2", gnd), ("#FLG0103.1", flag)):
        require(connected_labels(gauge, point, ground_anchor if name == "#FLG0103.1" else None) == {"GND"},
                f"{name} schematic wire component is not exclusively GND")
    comps = netlist.findall("components/comp")
    matches = [c for c in comps if c.get("ref") == "U302"]
    require(len(matches) == 1, "Netlist U302 missing/duplicated")
    comp = matches[0]
    require(comp.findtext("tstamps") == U302_UUID, "Netlist U302 symbol UUID changed")
    require(comp.findtext("value") == "LM66100DCKR", "Netlist U302 part identity changed")
    require(comp.find("sheetpath").get("names") == SHEET_PATH, "Netlist U302 hierarchy changed")
    require({s.get("name") for s in netlist.findall("design/sheet")} == set(sheet_paths),
            "Netlist does not cover full schematic hierarchy")
    for pin, function, kind in (("5", "ST_5", "open_collector"), ("2", "GND_2", "power_in")):
        nodes = [(n.get("name"), q) for n in netlist.findall("nets/net") for q in n.findall("node")
                 if q.get("ref") == "U302" and q.get("pin") == pin]
        require(len(nodes) == 1 and nodes[0][0] == "GND", f"Netlist U302.{pin} is not uniquely GND")
        require(nodes[0][1].get("pinfunction") == function and nodes[0][1].get("pintype") == kind,
                f"Netlist U302.{pin} pin function/type changed")
    return {"raw_error_count": 1, "reviewed_exception_count": 1, "unexpected_violation_count": 0,
            "warnings": 0, "pins_verified_on_GND": ["U302.5", "U302.2", "#FLG0103.1"],
            "flag_net_proof": "schematic wire graph (KiCad XML omits power flags)",
            "flag_ground_anchor": {"reference": "#PWR4003", "library": "power:GND", "pin": "1",
                                   "symbol_uuid": "4817470e-37ca-46a6-a8ca-5d33d92d6130",
                                   "pin_uuid": "aed34d8e-3946-41c4-9f71-83fb53481dec",
                                   "pin_type": "power_in", "pin_name": "", "cached_global_power_value": "GND",
                                   "schematic_pin_position_mm": [v / 1_000_000 for v in ground_anchor]},
            "schematic_count": len(documents), "netlist_component_count": len(comps)}


def fingerprint(data):
    return hashlib.sha256(data).hexdigest()


def capture_inputs(root, erc, netlist, documents, libraries):
    paths = {"erc": erc, "netlist": netlist}
    paths.update({"schematic:" + str(p.relative_to(root.parent)): p for p in documents})
    project = root.with_suffix(".kicad_pro")
    require(project.is_file(), "Project settings file missing")
    paths["project"] = project
    paths.update(libraries)
    return {role: {"path": str(path.resolve()), "sha256": fingerprint(path.read_bytes())}
            for role, path in sorted(paths.items())}


def semantic_erc(report):
    result = copy.deepcopy(report)
    result.pop("date", None)
    for sheet in result.get("sheets", []):
        sheet["violations"] = [without_positions(v) for v in sheet["violations"]]
    return result


def without_positions(violation):
    result = copy.deepcopy(violation)
    # This KiCad report has misleading 1/100-scaled coordinates despite mm units.
    # Identity, pin descriptions, sheet UUIDs and independent wiring are decisive.
    for item in result.get("items", []):
        item.pop("pos", None)
    return result


def verify_manifest(prior, current_inputs, guard_id):
    require(prior.get("status") == "PASS_WITH_ONE_REVIEWED_EXCEPTION"
            and prior.get("guard") == guard_id, "Frozen manifest is not a successful receipt from this guard")
    require({k: v["sha256"] for k, v in current_inputs.items()} ==
            {k: v["sha256"] for k, v in prior["inputs"].items()}, "Frozen input manifest hash mismatch")


def manifest_regressions(current_inputs, guard_id):
    valid = {"status": "PASS_WITH_ONE_REVIEWED_EXCEPTION", "guard": guard_id, "inputs": current_inputs}
    verify_manifest(valid, current_inputs, guard_id)
    results = []
    for name in ("rejected_manifest", "wrong_guard_manifest", "corrupt_captured_hash"):
        prior = copy.deepcopy(valid)
        if name == "rejected_manifest":
            prior["status"] = "REJECTED"
        elif name == "wrong_guard_manifest":
            prior["guard"] = "unrelated-guard"
        else:
            prior["inputs"]["erc"]["sha256"] = "0" * 64
        try:
            verify_manifest(prior, current_inputs, guard_id)
        except Rejected as error:
            results.append({"case": name, "rejected": True, "reason": str(error)})
        else:
            raise Rejected(f"Regression test incorrectly accepted: {name}")
    return results


def regression_checks(report, netlist, documents, sheet_paths):
    results = []

    def reject(name, mutate):
        r, n, d = copy.deepcopy((report, netlist, documents))
        mutate(r, n, d)
        try:
            validate(r, n, d, sheet_paths)
        except Rejected as error:
            results.append({"case": name, "rejected": True, "reason": str(error)})
        else:
            raise Rejected(f"Regression test incorrectly accepted: {name}")

    def violation(r):
        return next(s["violations"] for s in r["sheets"] if s["violations"])

    reject("additional_error", lambda r, n, d: violation(r).append({"severity": "error", "type": "pin_not_connected", "items": []}))
    reject("duplicate_reviewed_error", lambda r, n, d: violation(r).append(copy.deepcopy(EXPECTED)))
    reject("changed_raw_pin_uuid", lambda r, n, d: violation(r)[0]["items"][0].update(uuid="00000000-0000-0000-0000-000000000000"))
    reject("changed_raw_pin_description", lambda r, n, d: violation(r)[0]["items"][0].update(description="Symbol U302 Pin 6 [VOUT, Power output, Line]"))
    reject("missing_reviewed_error", lambda r, n, d: violation(r).clear())
    reject("global_pin_to_pin_suppression", lambda r, n, d: r["ignored_checks"].append({"key": "pin_to_pin"}))
    reject("filtered_error_only_report", lambda r, n, d: r.update(included_severities=["error"]))
    reject("unexpected_warning", lambda r, n, d: violation(r).append({"severity": "warning", "type": "pin_not_connected", "items": []}))
    for pin in ("5", "2"):
        def move_net(r, n, d, pin=pin):
            ground = next(x for x in n.findall("nets/net") if x.get("name") == "GND")
            node = next(x for x in ground.findall("node") if x.get("ref") == "U302" and x.get("pin") == pin)
            ground.remove(node)
            ET.SubElement(n.find("nets"), "net", name="UNEXPECTED_NET").append(node)
        reject(f"netlist_U302_pin_{pin}_off_GND", move_net)
    reject("changed_netlist_symbol_uuid", lambda r, n, d: setattr(next(c for c in n.findall("components/comp") if c.get("ref") == "U302").find("tstamps"), "text", "unexpected"))

    def gauge(d):
        return next(v for v in d.values() if one(v, "uuid")[1] == GAUGE_UUID)

    for ref, pin in (("U302", "5"), ("#FLG0103", "1")):
        def change_pin(r, n, d, ref=ref, pin=pin):
            symbol = next(s for s in children(gauge(d), "symbol") if props(s).get("Reference") == ref)
            one(next(p for p in children(symbol, "pin") if p[1] == pin), "uuid")[1] = "unexpected"
        reject(f"changed_schematic_{ref}_pin_uuid", change_pin)
        def change_symbol(r, n, d, ref=ref):
            one(next(s for s in children(gauge(d), "symbol") if props(s).get("Reference") == ref), "uuid")[1] = "unexpected"
        reject(f"changed_schematic_{ref}_symbol_uuid", change_symbol)
    for pos, name in (((68.58, 247.65), "ST"), ((83.82, 257.81), "GND_pin")):
        def change_ground(r, n, d, pos=pos):
            label = next(x for x in children(gauge(d), "global_label") if coordinate(one(x, "at")[1:]) == coordinate(pos))
            label[1] = "UNEXPECTED_NET"
        reject(f"schematic_{name}_ground_label_changed", change_ground)
    def change_flag_ground(r, n, d):
        symbol = next(s for s in children(gauge(d), "symbol") if props(s).get("Reference") == "#PWR4003")
        next(p for p in children(symbol, "property") if p[1] == "Value")[2] = "UNEXPECTED_NET"
    reject("schematic_flag_ground_symbol_changed", change_flag_ground)
    return results


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--schematic", type=Path, default=DEFAULT_ROOT)
    parser.add_argument("--erc", type=Path, default=DEFAULT_ERC)
    parser.add_argument("--netlist", type=Path, help="Supplied XML; live mode compares it to a fresh native export")
    parser.add_argument("--frozen-manifest", type=Path, help="Prior guard receipt; requires --netlist, checks all input hashes, skips native refresh")
    parser.add_argument("--receipt", type=Path, default=HERE / "guard-verification.json")
    parser.add_argument("--kicad-cli", default=CLI)
    parser.add_argument("--global-symbol-table", type=Path,
                        default=Path.home() / "Library/Preferences/kicad/10.0/sym-lib-table")
    parser.add_argument("--symbol-dir", type=Path,
                        default=Path("/Applications/KiCad/KiCad.app/Contents/SharedSupport/symbols"))
    parser.add_argument("--self-test", action="store_true")
    args = parser.parse_args()
    if HERE not in args.receipt.resolve().parents:
        print("REJECTED: Receipt output must stay inside erc-reviewed-exceptions", file=sys.stderr)
        return 1
    result = {"guard": "LM66100-ST-ground-exact-ERC-review-v1", "status": "REJECTED",
              "guard_sha256": fingerprint(Path(__file__).read_bytes()),
              "created_utc": datetime.now(timezone.utc).isoformat(), "primary_source": PRIMARY,
              "scope": "one reviewed raw ERC error; not a clean raw ERC or manufacturing release"}
    try:
        root, erc = args.schematic.resolve(), args.erc.resolve()
        documents, sheet_paths, parsed_schematics = load_hierarchy(root)
        libraries, parsed_libraries = library_inputs(root, documents, args.global_symbol_table.resolve(), args.symbol_dir.resolve())
        before = {p: fingerprint(p.read_bytes()) for p in
                  [*documents, root.with_suffix(".kicad_pro"), erc, *libraries.values()]}
        require(all(before[p] == sha for p, sha in {**parsed_schematics, **parsed_libraries}.items()),
                "Input changed while parsing hierarchy/library tables")
        report = json.loads(erc.read_text())
        if args.frozen_manifest:
            require(args.netlist is not None, "Frozen input review requires --netlist")
            netlist_path = args.netlist.resolve()
            result["mode"] = "frozen-input-hash-verification"
        else:
            # All outputs stay in the guard's check folder, never alongside the live source.
            check = HERE / "check"
            check.mkdir(exist_ok=True)
            netlist_path = check / "fresh-netlist.xml"
            fresh_erc = check / "fresh-erc.json"
            commands = [
                [args.kicad_cli, "sch", "export", "netlist", "--format", "kicadxml", "--output", str(netlist_path), str(root)],
                [args.kicad_cli, "sch", "erc", "--format", "json", "--severity-error", "--severity-warning", "--output", str(fresh_erc), str(root)],
            ]
            for command in commands:
                completed = subprocess.run(command, capture_output=True, text=True)
                require(completed.returncode == 0, f"Native export failed: {completed.stderr or completed.stdout}")
            require(semantic_erc(json.loads(fresh_erc.read_text())) == semantic_erc(report),
                    "Supplied raw ERC report is stale or differs from fresh native ERC")
            if args.netlist:
                supplied = ET.parse(args.netlist).getroot()
                fresh = ET.parse(netlist_path).getroot()
                for tree in (supplied, fresh):
                    tree.find("design/date").text = "IGNORED_EXPORT_TIMESTAMP"
                require(ET.tostring(supplied) == ET.tostring(fresh), "Supplied XML differs from fresh native export")
                netlist_path = args.netlist.resolve()
            result.update(mode="live-native-refresh", native_commands=commands,
                          fresh_erc_sha256=fingerprint(fresh_erc.read_bytes()))
        xml_bytes = netlist_path.read_bytes()
        netlist = ET.fromstring(xml_bytes)
        xml_sha = fingerprint(xml_bytes)
        result["inputs"] = capture_inputs(root, erc, netlist_path, documents, libraries)
        require(result["inputs"]["netlist"]["sha256"] == xml_sha, "Netlist changed while parsing")
        if args.frozen_manifest:
            prior = json.loads(args.frozen_manifest.read_text())
            verify_manifest(prior, result["inputs"], result["guard"])
        result["verification"] = validate(report, netlist, documents, sheet_paths)
        if args.self_test:
            result["negative_tests"] = regression_checks(report, netlist, documents, sheet_paths)
            result["negative_tests"] += manifest_regressions(result["inputs"], result["guard"])
        require(all(fingerprint(p.read_bytes()) == sha for p, sha in before.items()), "Source input changed during verification")
        require(fingerprint(netlist_path.read_bytes()) == xml_sha, "Netlist changed during verification")
        result["source_inputs_unchanged"] = True
        result["status"] = "PASS_WITH_ONE_REVIEWED_EXCEPTION"
    except (Rejected, OSError, ValueError, KeyError, TypeError, AttributeError, ET.ParseError) as error:
        result["reason"] = str(error)
    if HERE not in args.receipt.resolve().parents:
        print("REJECTED: Receipt output must stay inside erc-reviewed-exceptions", file=sys.stderr)
        return 1
    args.receipt.parent.mkdir(parents=True, exist_ok=True)
    args.receipt.write_text(json.dumps(result, indent=2) + "\n")
    print(f"{result['status']}: {args.receipt.resolve()}")
    if result["status"] == "REJECTED":
        print(result["reason"], file=sys.stderr)
        return 1
    return 0


if __name__ == "__main__":
    sys.exit(main())
