# Touchscreen oxygen setup verification

Implemented explicit **Unconfigured / AO2 / JJ-CCR** setup. GPIO52 remains unused. The ADC keeps both differential input paths; ordinary acquisition uses the configured oxygen input, and the optional known-air check requests both raw inputs temporarily.

From **Analyse**, tap **O2 setup**. Choose the type physically installed and press **Confirm installed sensor**. A type change or checked **New / replacement cell** requires a fresh two-reference calibration. The previous record stays stored and is shown as inactive until a compatible newer calibration exists. Failed capture or save preserves the previous record. No input voltage is treated as automatic physical sensor identification.

The known-air check requires an explicit air confirmation. Both raw responses are displayed, but advice remains manual/inconclusive because qualified identity-response bounds are not available. Leaving the screen stops the extra probe and clears the air confirmation.

Calibration identities remain AO2=0, JJ-CCR=1, He=2. Configuration identity and its generation are stored separately, using the centralized versioned CRC journal. Simulator storage remains separate from hardware storage. O2 acquisition profile 1 uses gain 8, 20 SPS and the internal 2.048 V reference; He profile 2 uses gain 1 with PGA bypass and the revised 680 Ω input protection resistors. The He change rejects incompatible He calibration without invalidating compatible O2 records.

An OTA update to a known newer acquisition profile retains the installed oxygen type and replacement gate without a boot-time storage write. Intact incompatible calibration records remain visible as inactive history; they do not clear the calibration requirement or supply converted readings. A fresh successful calibration increments the previous successful revision, including after a profile change. Failed recalibration leaves the archived record intact. Unknown future selection formats/profiles still fail closed.

Analysis rejects impossible gas compositions instead of reducing helium to force the total under 100%. History records the selected oxygen type, setup generation, and calibration revision. Legacy history has unknown oxygen identity rather than an assumed AO2 identity. Device Settings shows storage read-only/recovery states and makes an unavailable battery gauge explicit.

Validation evidence:

- Six relevant CTest targets passed.
- 34 rendered LVGL UI assertions passed, including first setup, staged selection, independent JJ calibration, replacement lockout, history identity, read-only storage and unavailable battery.
- 35 pure selection assertions, 30 sensor-interface assertions, 25 analysis assertions and 62 ADC/calibration assertions passed.
- Selection and ADC/calibration tests also pass with AddressSanitizer and UndefinedBehaviorSanitizer.
- All 10 PNG views in `views/` were inspected. They are simulator framebuffer captures, not physical-display photographs. The final run regenerated their PPM source frames byte-identically after the profile-compatibility change.
- `verification.json` binds commands, sources, logs and reviewed images by SHA-256.

No physical sensor, battery, NVS-failure, gas-accuracy, sealing or thermal test is claimed. Actual board acquisition, power coordination and final ESP-IDF builds are documented by the parent system-review package. The existing provisional warm-up and bench-only gas-validation limits remain in force.

## Later integrated checkpoint

The original counts above remain tied to `verification.json`. The final integrated run additionally checks faulted known-air labels and atomic selected-sensor frame publication: 35 UI assertions and 37 sensor-interface assertions, including seven stale-generation regressions. Eleven final simulator views are under `../../verification/ui-current/`; the source-bound combined receipt is `../../verification/software-final.json`. These supersede the earlier counts for the current source.
