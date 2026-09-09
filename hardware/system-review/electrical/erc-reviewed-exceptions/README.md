# Reviewed LM66100 ERC exception

`guard_erc.py` accepts exactly the existing U302 ST-to-GND `pin_to_pin` error when its electrical context is still verified. A pass means **one reviewed raw ERC error, zero unexpected violations, and zero warnings**. It does not mean that raw ERC is clean or that the hardware is released.

Texas Instruments' [LM66100 datasheet, Revision A, page 3, pin functions](https://www.ti.com/lit/ds/symlink/lm66100.pdf) describes ST as an open-drain status output and explicitly says: “Connect to GND if not required.” This primary source was checked on 2026-09-07. The reviewed design grounds unused U302 pin 5; the ground net also has a power flag. KiCad reports an open-collector/power-output conflict for that combination.

The guard leaves the raw report, schematic wiring, symbol pin types, project ERC settings, and existing ignored-check list unchanged. It creates only verification artifacts inside this directory.

## Exact identity and electrical conditions

| Object | Symbol UUID | Pin UUID |
|---|---|---|
| U302, LM66100DCKR, ST pin 5 | `5b884914-2a77-4cce-9416-53594c6d3d76` | `991d920b-13e3-4e55-b85b-3e724f870c86` |
| #FLG0103, pin 1 | `ede70981-302d-4b14-b504-703421d2a612` | `4b8e713f-edeb-4760-98ca-954d700f013d` |
| #PWR4003, GND anchor pin 1 | `4817470e-37ca-46a6-a8ca-5d33d92d6130` | `aed34d8e-3946-41c4-9f71-83fb53481dec` |

The UUIDs in raw ERC items identify **pins**, not their containing symbols. The guard verifies both levels, the exact sheet/instance UUID path, part/library identity, and cached pin functions. U302 pins 5 and 2 must each appear exactly once on `GND` in the complete native XML netlist. Both pins also require independent GND proof through schematic wires and labels.

KiCad XML omits power flags. The guard therefore traces #FLG0103 through actual schematic wires to the verified #PWR4003 pin at `(76.2,160.02)` mm. KiCad 10's cached `power:GND` definition has an empty pin name: its verified `power_in` pin, zero-offset endpoint, `power global` declaration, and matching cached/instance `GND` values establish the ground anchor. This is not inferred merely from a symbol reference or displayed property.

The raw error must have the exact type, severity, descriptions, two pin UUIDs, and sheet path. Additional errors, duplicate exceptions, warnings, a missing expected error, changed identities/nets, incomplete hierarchy, or a changed ignored-check policy fail the guard. Both error and warning severities must be captured. Raw JSON positions are deliberately excluded from matching because this report's coordinates appear scaled by 1/100 despite its `mm` declaration; schematic coordinates are used for connectivity proof instead.

## Live verification

From the repository root:

```sh
python3 hardware/system-review/electrical/erc-reviewed-exceptions/guard_erc.py --self-test
```

Defaults resolve relative to the script, not the shell's working directory:

- Root schematic: `hardware/pcb/analyzer/Trimix_Analyzer.kicad_sch` and all 13 reachable child sheets.
- Raw current report: `hardware/system-review/electrical/local-input-cap-erc.json`.
- Receipt: `erc-reviewed-exceptions/guard-verification.json`.
- Fresh native XML/ERC exports: `erc-reviewed-exceptions/check/fresh-netlist.xml` and `fresh-erc.json`.

Every live run exports the complete current XML netlist and runs native ERC through KiCad CLI. It compares fresh ERC with the supplied raw report, excluding only export time and item positions. Supplying `--netlist PATH` additionally requires that XML to match the fresh native export, excluding only its export timestamp. A stale report or XML cannot silently pass.

The receipt hashes the raw report, full XML, every reachable schematic, the project settings, recursive project/global symbol tables, all used symbol library files, and library-resolution settings. Those source inputs are hashed before and after native exports and validation; changes while parsing or during the run reject the capture. It also records the guard hash, native commands, the GND anchor, counts, and test results. Native output errors produce a nonzero exit status; no source repair or suppression is attempted.

The default CLI and global library paths target the installed macOS KiCad 10 environment. `--kicad-cli`, `--global-symbol-table`, and `--symbol-dir` can select another installation. Library resolution uses the project table over the global table and rejects unresolved used libraries.

## Frozen input verification

To check the current captured inputs without rerunning KiCad:

```sh
python3 hardware/system-review/electrical/erc-reviewed-exceptions/guard_erc.py \
  --netlist hardware/system-review/electrical/erc-reviewed-exceptions/check/fresh-netlist.xml \
  --frozen-manifest hardware/system-review/electrical/erc-reviewed-exceptions/guard-verification.json \
  --receipt hardware/system-review/electrical/erc-reviewed-exceptions/check/frozen-verification.json
```

Use `--schematic`, `--erc`, and the library-path options for a separately preserved input set. Frozen verification requires a successful receipt from this guard and an identical set of role-keyed SHA-256 hashes; changed content, missing inputs, or rejected/unrelated manifests fail. Recorded absolute paths may differ when a preserved input set is relocated. A frozen pass attests only to those captured inputs; it does not assert that they are still the live design.

`--self-test` checks modified **in-memory copies** for extra/duplicate errors, missing or changed raw errors, filtered severities, warnings, global pin-to-pin suppression, changed U302 pin nets, changed pin/symbol UUIDs, altered GND labels/anchor, and invalid/corrupt frozen manifests. The current verification receipt records 21 rejected negative cases. The authoritative raw ERC remains one error and zero warnings.
