# Release and startup integration review

The release filenames and application descriptor already agreed: `Trimix_analyzer`, version `0.2.0`, with separate `pre3` and `v3` application assets. Read-only inspection confirmed P4 revision ranges 1–199 and 300–399. The compiled partition tables contain 4 MiB and 6 MiB OTA slots respectively. The artifact manifest records the exact bytes inspected at that point in the review; later root builds supersede those hashes.

The pre-v3 CI size check incorrectly used the default 6 MiB table. Both workflows now explicitly use the pre-v3 table for that check. Release validation additionally reads the compiled binary partition table and uses the smaller of its two OTA slots, checks P4 family and descriptor identity/version, rejects C6 recovery builds, and verifies renamed assets are identical to the built application.

The version setter now rejects leading zeroes, suffixes and components above 65535. These would otherwise disagree with the device's canonical asset/version selection. Version calculation excludes noncanonical tags.

The workflow creates a draft, then compares GitHub's exact uploaded asset names, size, download URL and server-generated SHA-256 digest with the local manifest. It also enforces the device's 32 KiB release-metadata limit. Missing digests or failed validation leave the release as a draft, outside the `/latest` feed. A successful gate publishes the complete release. The small JSON manifest accompanies the binaries for audit; the device continues using GitHub's `digest` field directly. Factory files and C6 recovery remain separate from normal OTA applications.

References: [GitHub asset digest schema](https://docs.github.com/en/rest/releases/assets), [release action draft/output behavior](https://github.com/softprops/action-gh-release), and [publishing an existing draft](https://cli.github.com/manual/gh_release_edit). The binary offsets follow the installed ESP-IDF v5.5.4 `esp_app_format.h`; this validator complements ESP-IDF's image verification and does not replace it.

## Startup correction

The old 20-second health loop began after synchronous hosted Wi-Fi initialization and therefore did not bound a blocked Wi-Fi initializer. NVS and LVGL initialization also preceded that loop. The inspected configuration enables a five-second task watchdog for idle tasks without panic; the bootloader watchdog is disabled before user code. These settings do not reliably recover an `app_main` task waiting on a mutex.

A pending OTA image now starts a separate supervisor before essential initialization, with a 60-second total deadline. Its atomic production state machine prevents completion and timeout from both owning rollback, including at the deadline and across clock wrap. The 20-second observed UI/worker/storage check remains inside that total deadline. Failure rolls back only if a previous bootable image exists. Without one, persistence remains read only and the software retains available recovery rather than forcing repeated restarts. Scheduler/flash operation and actual reset behavior still require bench tests.

Wi-Fi initialization and autoconnection now run in an optional worker with process-lifetime synchronized state. Application-level Wi-Fi allocation, event registration, interface attachment, mode and start errors return to local-only operation with partial initialization cleaned up. The netif convenience function that internally asserts was replaced with its checked component operations. No UI objects are accessed by the initializer. The dedicated C6 recovery branch remains explicit and separate.

## Evidence and limits

- `release-validation-tests.log`: 13 offline test cases, including wrong family/C6, version mismatch, factory image, slot overflow, server digest/URL/size mismatch and missing/duplicate assets.
- `release-production-core-compatibility.log`: actual production OTA parser accepts metadata generated from both inspected application artifacts.
- `ota-startup-sanitizers.log`: 67 production-core assertions pass with AddressSanitizer and UndefinedBehaviorSanitizer; seven cover the new total startup deadline/arbitration.
- Both modified workflow files parse as YAML; `set_version.sh` passes shell syntax validation. Root owns fresh integrated ESP builds and the complete suite.

No release was created, published, pushed, flashed or installed. Native GitHub upload/digest availability, missing/stalled C6 hardware, task allocation failures, blocked essential initialization, real OTA rollback and recovery remain physical/integration test cases.
