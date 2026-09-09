# Explicit power-path inventory

This is a read-only routing diagnostic, bound to source SHA256
`40158632831955192a2603701a928c6f53594d5937f9eee2602a55cd93141205`.
The board was still being routed. **13 of 29 requested pad pairs have an explicit
native trace/barrel witness; 16 are unresolved when pours are excluded.** This is
neither a full-board connectivity approval nor a current rating.

The immutable input is `diagnostic/source.kicad_pcb`. The source and snapshot
hashes were unchanged by the reader. No native board, schematic or firmware was
saved or edited. The final routed board needs a fresh run in a new output folder.

## What is recorded

- `diagnostic/inventory.json`: exact physical pad IDs, ordered item UUID witnesses,
  individual adjacency/trace/barrel edges, full native segment lengths, per-layer
  minimum widths, source hashes, assumptions and exclusions.
- `diagnostic/paths.csv`: one row per requested physical pad pair, with status,
  lengths, widths, barrel transitions and the nominal coefficient.
- `diagnostic/sensitivities.csv`: 36 labelled cases per resolved witness, or 468
  rows in this snapshot. A witness stays fixed across cases for comparison.
- `native-controls.json` / `.log`: 19 passing native geometry and calculation
  controls. The tests create fresh in-memory boards; they do not alter the source.
- `nbshandbook100.pdf`: the official NIST/NBS copper-material reference.

R110, R121 and R124 are identified separately as voltage-sense branches rather
than source-load trunks. Their directly adjacent track widths in this snapshot
are respectively 0.40/0.40 mm, 0.15 mm, and 0.40 mm; this does not establish the
widths along each entire branch. Trace-only routes from J101 to those resistors
are unresolved. Their direct endpoint copper UUIDs remain listed in the JSON.

## Method and limits

The graph uses KiCad 10.0.6 `GetConnectedTracks` and `GetConnectedPads` **direct
adjacency**. Net names only filter adjacency; they never create an edge. Zone
objects are never graph nodes. Layer-specific ports prevent crossings on different
copper layers from joining without a physical plated transition. Separate
same-number pad objects retain separate identities; IC internals are not joined.
These API semantics are documented by [KiCad](https://docs.kicad.org/doxygen-python-10.0/classpcbnew_1_1CONNECTIVITY__DATA.html).

The chosen witness minimizes the nominal sum of complete native trace-item and
barrel contributions. It is **not an equivalent-resistance solver**. Parallel
paths, current sharing, pad spreading, solder and connector/contact resistance
are excluded. The complete length of a track item is counted even when a pad or
branch meets it partway along its length. Pad overlap and unused tails are not
clipped. Thus the number is an auditable full-item contribution estimate, not an
exact end-to-end resistance or an accuracy bound.

Junctions within each physical pad item are ideal. A plated pad used to transition
between layers is charged a barrel contribution. Source/destination terminals
may terminate on any physical copper layer of that pad; conduction up the actual
connector pin and its contact resistance are outside this model. Repeated supply
pins such as J301.2/4 and U101.13/14 are reported independently. Their currents are
not assumed equal and their witness coefficients must not be added as a circuit.

A missing explicit witness is labelled **unresolved**, rather than automatically
being called an open circuit: excluded copper pours may connect it, or routing
may remain unfinished. No missing-path resistance is fabricated.

## Material and geometric assumptions

[NBS Handbook 100, printed page 40 / PDF page 46](https://nvlpubs.nist.gov/nistpubs/Legacy/hb/nbshandbook100.pdf)
gives the annealed-copper baseline used here:

- `rho20 = (1/58)/1000 = 0.0000172413793 ohm·mm`.
- `R(T)/R(20) = 1 + 0.00393 × (T − 20)` for the selected 20/60/85 °C cases.
- Track estimate: `R = rho(T) × length / (width × thickness)`.
- Circular plated bore: copper area `A = pi × t × (d + t)`, where `d` is the
  nominal finished bore and `t` is the assumed outward plating thickness.

The reader obtains copper thickness from the source stackup: F/B 0.035 mm,
In1/In2 0.0152 mm. The laminate/copper thickness sum is 1.5642 mm. Relative copper
center positions are scaled to each 1.44/1.60/1.76 mm finished-height case for
barrel-length sensitivity. A same-layer visit to a via adds no barrel resistance;
a cross-layer visit uses the corresponding span, not an automatic full-height
barrel. Oval plated pad bores use their perimeter plus the plating corner term.

The 20/25 µm plating cases are **unqualified sensitivities**, not known finished
plating. The optional geometry case subtracts 0.025 mm from each trace width and
uses 80% of its native copper thickness. These values are not fabrication minima
or guaranteed process tolerances. Deposited copper conductivity and the thermal
constraint of a real board are not established by the wire-material reference.

Both normalized coefficients have the same numeric value when R is in milliohms:
`voltage drop = (mV/A) × current`, and `dissipation = (mW/A²) × current²`.
No operating current, acceptable drop, simultaneous load, self-heating or trace
current-capacity limit is inferred.

## Resolved diagnostic examples

These use 20 °C, 25 µm assumed plating, 1.60 mm finished height and native trace
dimensions. They are full-item witness estimates with the limits above.

| Pad pair | mV/A = mW/A² | Included full trace length | Barrel transitions |
|---|---:|---:|---:|
| U201.5 → C204.1 | 3.471 | 2.337 mm F | 0 |
| U302.3 → J301.4 | 30.121 | 0.913 mm F + 22.364 mm B | 1 |
| U302.3 → J301.2 | 33.586 | 3.453 mm F + 22.364 mm B | 2 |
| C204.1 → U501.1 | 36.599 | 2.779 mm F + 26.142 mm B | 2 |
| C204.1 → U701.2 | 42.643 | 9.075 mm F + 21.915 mm B | 2 |
| C204.1 → U702.1 | 42.268 | 11.609 mm F + 21.915 mm B | 2 |
| J102.1 → U101.13 | 25.418 | 12.985 mm F + 5.296 mm B | 2 |

The unresolved set includes the requested USB input/OVP/limiter chain, SYS to the
converter input, capacitor bank to U302, and the three source-to-sense branches.
Consult the CSV rather than interpreting the example table as a complete system.

## Validation and rerun

The 19 controls include direct-versus-transitive adjacency, a removed bridge,
disconnected same-net copper, coincident F/B tracks without and with a via,
same-layer via visits, an inner-layer route, disconnected and overlapping
same-number pads, different IC pins, a genuinely filled-zone-only connection,
and independent trace/barrel/temperature/sensitivity formula checks.

```sh
/Applications/KiCad/KiCad.app/Contents/Frameworks/Python.framework/Versions/Current/bin/python3 hardware/system-review/electrical/current-path-review/test_inventory.py

/Applications/KiCad/KiCad.app/Contents/Frameworks/Python.framework/Versions/Current/bin/python3 hardware/system-review/electrical/current-path-review/inventory.py --board hardware/system-review/electrical/routing-candidate/native/Trimix_Analyzer.kicad_pcb --out hardware/system-review/electrical/current-path-review/diagnostic
```

For the final board, use `--board <frozen-board>` and a **new** `--out` directory.
The reader refuses to replace an existing snapshot with different bytes. Four
explicit copper layers are required; unsupported track arcs cause a failure
rather than a silent length approximation. The independent Gerber/CAM audit and
the physical electrical/thermal tests remain separate work.
