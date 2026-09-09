# Qualified-profile charge standby implementation

The software now supports a host-alive, dark-screen charging standby after a
future source-reviewed physical battery qualification. **The shipped profile is
still immutable `CommissioningInhibited`: charging remains disabled, J104 stays
OPEN, and there is no settings, NVS or touchscreen path to enable it.** The
synthetic enabled profile appears only in test executables. No hardware was
energized, flashed or qualified by this work.

## User-visible behavior and ownership

With the present inhibited profile, a normal button press still requests true
hardware off. A future qualified profile permits standby only after startup and
OTA probation have actually succeeded, with fresh healthy charger/gauge data,
verified higher-current USB authorization and the profile's battery reserve.
Waiting or failed startup acceptance cannot enter standby or make acquisition
look healthy by deliberately stopping it.

Entering standby uses a short maintenance barrier to stop acquisition/heater
control and drain storage writes. The screen is set to **zero PWM**, independently
of the saved 10–100% brightness setting. The barrier then releases: the host,
source qualification worker, hardware-feedback checks and charger monitoring
continue running. Acquisition does not automatically restart. A fresh USB grant
must complete before charging is explicitly enabled.

A second short press inhibits charging, starts acquisition again and restores
saved brightness. Normal sensor warm-up and calibration validity rules remain
in force. USB removal, insufficient/default/faulted source, invalid/stale power,
latched charger fault, inadequate battery reserve or failed transition requests
off. This deliberately conservative implementation does not keep charging
through a source fault or silently restart a failed charge session. Ordinary
settings changes during standby cannot relight the display. OTA cannot start
while this operating mode is active.

Forced long press still belongs to the LTC hardware. Main KILL normally removes
switched Guition power; a separately connected Guition service USB can keep the
CPU alive. If KILL returns, the software retains OffPending, keeps acquisition
stopped and AUTH LOW, blanks the display, retries charger inhibition and retries
KILL. An unavailable charger is explicitly **not** reported as confirmed
inhibited. Releasing an unrelated maintenance hold cannot restart this shutdown.
The Guition supply/backdrive service exception remains a separate hardware hold.

## Charger safeguards

The versioned source-controlled profile requires explicit evidence identity,
supported quantized voltage/current settings, precharge/termination limits,
safety timer, thermal-regulation setting and standby reserve. Numerical encoding
validation does not prove those values suit a cell. A future real profile still
requires exact cell, holder, NTC, charge-time and thermal acceptance. The test
profile's values are register fixtures, **not recommended charging settings**.

The BQ driver verifies identity and fresh input configuration, disables charging
first, programs and reads back the profile, and enables CHG_CONFIG last. OTG,
autonomous voltage negotiation and current optimization remain disabled;
hardware ILIM remains enabled. Termination and the safety timer stay enabled.
Reserved bits are preserved. It never clears a BATFET protection/ship latch to
force charging. Stable polling does not rewrite the profile or restart timers.
The profile includes whether the timer doubles during DPM; it does not invent a
charging-time guarantee. Register definitions are from the existing local copy
of [TI BQ25895 Rev C, §8.4](https://www.ti.com/lit/ds/symlink/bq25895.pdf).

Readback drift, programming error, charger faults (including a fault observed
before the first enabled session), timeout or cancelled enable triggers inhibit
and retains a charge failure. BQ fault reads retain the existing first-latched /
second-current interpretation. Loss of I2C cannot be described as an electrical
disable; source permission is lowered independently and true-off is attempted.

Maintenance publishes its pending state before trying to obtain the source
command mutex. The driver checks a cancellation/source guard between BQ
transactions, including after writes. Qualifying, Preparing, Standby and Waking
require confirmed inhibition before maintenance can become Held. An already
started hardware transaction can finish; maintenance must wait for the resulting
inhibit/readback. The same shared feedback pin can carry a normal 256 µs BQ IRQ,
so a brief LOW receives the existing 2 ms deglitch allowance before being treated
as persistent lost authorization. Current authorization is never renewed by
periodically cycling an otherwise healthy source.

Enable programming has a 1.5 s elapsed budget checked between transactions;
mode changes have a 3 s budget, source requalification 3 s, and off retries a
1 s minimum interval. The real I2C adapter has 100 ms transaction timeouts.
These are software bounds with bus scheduling and cleanup latency, not measured
worst-case real-time guarantees or a substitute for hardware cutoff.

## Verification boundary

`verify_standby.py` records source hashes before and after checks and saves logs
under `standby-evidence/`. The routine test suite also builds these targets.

The saved run passed all 21 commands with all 47 recorded inputs unchanged:
146 profile/policy/driver assertions, 12 backlight assertions and 87 worker
assertions across seven fresh-process scenarios under ASan/UBSan. TSan passed
the two injected maintenance races and the 8,000-call backlight workload.
The targeted CMake regression selection passed 12/12 tests. The complete source
and log hashes are in [the receipt](standby-evidence/receipt.json).

- `test_charge_standby`: actual profile encoder, mode policy and BQ driver with
  register-level fake I2C. It covers eligibility, startup gate, register bytes,
  failed/ignored writes, cancellation at every programming write, stale evidence,
  delayed successful transactions, faults, wrap, late completion and stable
  operation without timer resets.
- `test_backlight_standby`: actual service with a narrow PWM boundary stub,
  including zero/restore, failure state, saved-setting changes and 8,000 concurrent
  settings/standby calls. It does not measure photons or PWM on the physical LCD.
- `test_power_worker_standby`: the actual `ESP_PLATFORM` power-worker code, USB
  policy, CC/BC/BQ drivers, maintenance coordinator, standby policy and backlight
  service. The fixture substitutes GPIO, RTOS scheduling, I2C, environmental
  sensing, acquisition stop/start and the storage-pause boundary. It compiles the
  unchanged production profile encoder/provider under a test-local provider
  symbol and links a synthetic enabled provider **only in this test**. Each
  scenario uses a fresh process. It verifies real worker ordering for standby /
  wake / detach, maintenance injected during profile and final enable writes,
  service-powered KILL returns, charger loss/recovery, unaccepted startup,
  ordinary BQ IRQ pulses and a failed KILL write. The actual gas acquisition and
  NVS adapters have separate tests elsewhere; this fixture does not replace them.
- ASan/UBSan run all new tests. TSan runs the two injected worker races and the
  concurrent backlight workload. The normal CMake check includes existing power /
  environment, USB permission and storage-maintenance regression targets.

Combined pre3/v3 firmware builds and the whole-project source manifest belong to
the parent's final integration receipt. No claim about those fresh builds is
made by this narrower report.

## Remaining physical gates

There is no automatic USB-attach wake path and no powered host to grant more
than the nominal 50 mA branch when genuinely off. Standby does **not** solve
cold/depleted/protection-disconnected recovery, BQ cold-reset defaults, the LTC
rail-rise window or Guition backdrive. Those remain explicit feasibility holds.
Display logic and the CO module can remain powered despite a dark backlight and
stopped acquisition, so positive net charge, actual standby draw, temperatures,
NTC behavior, timer behavior, USB class/orientation transients, hardware long
press and repeated protection recovery still need controlled measurements.

The original findings and source hash manifest remain in `README.md` and
`review.json` as a historical baseline. `standby-state-table.csv` describes this
implementation. A qualified compile-time profile may be supplied by a future
reviewed firmware release after those measurements; an OTA mechanism alone is
not battery qualification.
