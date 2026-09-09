# OTA, storage and startup: final targeted verification

This is the bounded OTA/storage review of the source hashes in `source-manifest.json`. USB/power integration was still being finalized by the parent review. The inspected binaries below are point-in-time artifacts, not a claim that all later source changes have been built. No firmware, bootloader, C6 image, partition, release or security fuse was programmed or published.

## Digital results

| Production logic exercised | Result | Evidence |
|---|---:|---|
| OTA metadata, installer sequencing/failures, journal, maintenance, probation | 67 assertions pass, ASan + UBSan | `ota-asan.log` |
| Storage/maintenance admission and transaction races | 17 assertions pass, including 100 competing cycles, ASan + UBSan and separate TSan | `storage-maintenance-*.log` |
| Real `ESP_PLATFORM` storage initializer and NVS calls with test adapter | 35 assertions pass across five fresh processes, ASan + UBSan | `esp-storage-adapter-asan.log` |
| Concurrent startup completion/expiry | 1,000 race rounds pass under ASan + UBSan; another 1,000 under TSan | `boot-probation-*.log` |
| ADC/calibration/CO core including saved acquisition-profile migration | 62 assertions pass, ASan + UBSan | `calibration-asan.log` |
| Oxygen selection, replacement/revision gate and profile migration | 35 assertions pass, ASan + UBSan | `oxygen-selection-asan.log` |
| History V1/V2 migration and identity; cylinder validation | 24 + 13 assertions pass, ASan + UBSan | `history-asan.log`, `cylinder-asan.log` |
| Offline release validator | 13 tests pass | `release-validation.log` |
| Artifact-generated metadata through the production device parser | Both silicon families pass with older/same/newer installed-version cases; only the older version is offered an update | `release-core-asan.log` |

`host-verification.json` records exact compiler commands and before/after source/header hashes. `compiler-dependencies.json` narrows those receipts to actual compiler dependencies; every tested dependency still matched at handoff. The source manifest separates tested OTA/storage dependencies from read-only startup/USB observations. The dedicated ESP fixture and stubs are in `tests/test_esp_storage_adapter.cpp` and `tests/esp_storage_stubs/`; the parent added these five scenarios to the normal CMake test suite. Additional compile commands are in `esp-storage-adapter-command.json` and `additional-commands.json`. The standard cJSON vendor source only suppresses macOS's deprecated `sprintf` declaration warning; project sources retain `-Wall -Wextra -Werror`. The parent's newer physical acquisition-wrapper tests supersede that wrapper's earlier evidence; this pass exercises the portable calibration cores only.

The real ESP storage branch now has coverage that the ordinary host branch could not provide: pending-OTA initialization really denies writes, both `NO_FREE_PAGES` and `NEW_VERSION_FOUND` preserve existing bytes, a failed probation leaves prior records readable, explicit acceptance opens writes, the capacity guard runs, and selector-commit failures leave a complete committed record. The adapter exercises both no persistence and persistence followed by a lost acknowledgement. A reported save failure therefore does not promise that physical flash still contains the old selector. No partition-erase symbol is supplied by the adapter.

## Startup and optional hardware

The pending-update supervisor is created before NVS and LVGL initialization. A pending image has a 60-second essential-startup deadline and a post-service health window of at most 80 × 250 ms inside it. Acceptance requires four UI timer ticks, both system/acquisition worker heartbeats younger than five seconds, and successful NVS initialization. Per-sensor validity, USB source qualification, Wi-Fi association and heater warm-up are deliberately separate from boot acceptance. `storage_ready()` proves NVS initialization, not compatibility or validity of every stored record; incompatible calibration/configuration records remain unavailable without being erased.

The optional Wi-Fi initializer runs in its own task and publishes plain service state. Its allocation/registration/start failures degrade local operation rather than aborting application startup. The UI health callback owns only a process-lifetime atomic, so failure to delete its timer does not leave a stack pointer. Startup completion and expiry have one atomic winner; a late main task cannot accept an already expired image. No additional lifetime defect was found in this read-only pass.

The new BC1.2 detector has a five-second detection policy but does not sleep through that interval in one call: it advances over worker polls. The USB grant sequence has an explicit 40 ms delay. Each ESP I²C transfer is configured for a 100 ms timeout, and a missing peripheral returns as unavailable. However, a worker step can contain many transfers; the shared-bus mutex, driver/controller reset, scheduling and flash operations do not have an independently proven aggregate upper bound. Consequently, the five-second heartbeat freshness threshold is a health policy, not proof that all combinations of bus faults finish inside five seconds. Test the complete worker with missing devices, delayed acknowledgements and held-low bus lines on the real board. Do not enlarge that threshold merely to mask a stalled worker.

Failure of a pending image requests rollback only when a prior bootable image exists. Otherwise the code retains available recovery UI/read-only storage without deliberately creating a reset loop. The supervisor itself depends on the scheduler and the ESP rollback API; host race tests cannot demonstrate an actual reset or recovery when those lower layers are stalled.

## Saved data and rollback boundary

Settings, history, cylinder and Wi-Fi updates write new versioned namespaces while retaining legacy keys. During failed pending-image startup, every application write path is gated off, including calibration journal slots and selectors; the adapter test confirms byte-identical persisted state in that scenario. Thus the previous namespace/schema can still read its prior record after rejected probation.

Current oxygen acquisition remains revision 1. Helium revision 2 retains an intact revision-1 calibration as archived history but refuses to convert with its coefficients. The production tests preserve revision 7 through a failed recalibration, then advance it to revision 8 only after a successful revision-2 calibration, which survives restart. Explicit oxygen replacement still requires a newer successful calibration; a migration cannot silently revive an older cell's coefficients.

This proves the logic and storage contracts, not execution of an old firmware image, bootloader selection and new image on physical ESP flash. An arbitrary manual downgrade after accepting the new firmware and saving a new acquisition profile is a different case: the older firmware may reject the new record and require compatible firmware/reconfiguration. Reusing an old calibration after a declared sensor replacement would be incorrect. No general promise of downgrade compatibility is made.

## Capacity and inspected application artifacts

Both inspected target ELF files agree on persistence ABI sizes: calibration record 368 B; history record 116 B; history snapshot 2,324 B; legacy history record 92/104 B; cylinder profile 72 B; Wi-Fi credentials 98 B; oxygen selection 32 B. See `target-dwarf-storage-sizes.json`. The synthetic NVS image conservatively allocates 64 B for selection.

The Espressif NVS generator accepts the full current journals plus both retained legacy histories in the unchanged 24 KiB partition: 495 written entries, 261 free entries, 202 required by the largest guarded write including its 128-entry reserve, leaving 59 entries beyond that guard. `nvs-capacity.json` is a synthetic allocation result using dummy payloads. It does not demonstrate write endurance, garbage-collection timing, actual key churn or power-loss recovery.

| Family | Inspected app bytes | Smallest installed OTA slot | Remaining bytes |
|---|---:|---:|---:|
| pre3 | 1,980,912 | 4,194,304 | 2,213,392 |
| v3 | 1,986,112 | 6,291,456 | 4,305,344 |

The inspected descriptors are `Trimix_analyzer` version `0.2.0`, P4 revision ranges 1–199 and 300–399 respectively. The release validator reads each compiled partition table and application descriptor. `artifact-manifest.json` records those exact binary SHA-256 values. `publication-metadata-fixture.json` was generated locally from that manifest; it is not a GitHub response or published release. Production parsing accepts its exact matching assets and rejects downgrade offers through the `newer` flag. The release workflow stages a draft and validates uploaded digests before publication; actual GitHub upload behavior was not executed here.

## Remaining acceptance checks

- Parent must freeze USB/power sources, rebuild both P4 variants and rerun the integrated suite before declaring a final firmware baseline. Recreate the release manifest whenever application bytes change.
- On the board, test accepted and rejected updates with prior calibration/settings/history, interruption during download and activation, a stalled/missing C6, absent external sensors, real bus faults, low-power refusal and wired recovery. Verify an unbootable candidate returns to the previous bootable image without erasing records.
- Exercise physical flash cuts during journal inactive-slot write and selector publication, including the possibility of a complete new record after a lost acknowledgement. Check NVS garbage collection/capacity over repeated actual saves.
- Keep C6 recovery separate. Its descriptor boundaries are tested here; no C6 upload, activation or P4/C6 compatibility run was performed.

No targeted production correction was necessary during this pass. The new tests improve coverage; they do not qualify charging, gas accuracy, thermal behavior or mechanical fit.
