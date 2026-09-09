# PI3USB9201 BC1.2 source monitor

The pure driver has passed 66 host assertions and the same suite under AddressSanitizer and UndefinedBehaviorSanitizer. No physical USB hardware, charging current, cable behaviour or timing has been tested.

## Manufacturer basis

[Diodes PI3USB9201 datasheet, DS41358 Rev 3-2, April 2025](https://www.diodes.com/datasheet/download/PI3USB9201.pdf), pages 2–3, 6, 8–9, is the source for these register and interface facts. The cached PDF is `hardware/system-review/electrical/sources/pi3usb9201.pdf`.

- U111 is PI3USB9201ZTAEX, supplied by HOST_3V3. Grounded ADDR and ENB select address 0x5F and enable the device. Connector D+/D− connect to pins 8/7; transceiver pins 1/2 are unconnected.
- Control 1 = 0x08 selects client mode with the interrupt unmasked. Control 2 = 0x02 keeps the USB data switch off; changing it to 0x0A starts detection.
- Client status REG02 is read-and-clear. DCP/SDP/CDP are bits 7/6/5. Bits 3/2/1 identify proprietary modes, bit 0 other, and bit 4 is reserved. Host status REG03 also clears on read.
- USB-C detection starts in ATTACHED.SNK. On detach, clear the start bit and enter power-down mode.

## Application contract

`bc12::Monitor` runs in the single acquisition worker on the managed shared I2C bus. It has no GPIO, BQ charger, enumeration, power-delivery or charging-current authority. No current value is inferred from a class, and classification cannot verify that the physical input is 5 V. The combined power policy owns those decisions and voltage checks. No IC identification register exists in this device's published register map, so configuration readback does not prove the installed part identity.

The worker must hold the external ILIM permission command LOW for `begin_detection`, `collect_detection` and `stop`. It must verify a valid attached-sink CC generation before and after these transactions. It must drop permission and invalidate the result if CC, VBUS, power-good or bus evidence becomes invalid. The driver cannot observe an unreported physical detach. Its generation/TTL checks are additional software protections; the separate hardware reset path remains necessary.

`begin_detection(generation)` clears prior status in verified power-down state, enters client mode, observes the start bit LOW, then writes and verifies HIGH. A new detection generation is assigned on each attempt; generation zero and counter exhaustion are rejected. Only results from that cycle can become Ready. Status clear verification and exact control readbacks reject stale flags, ambiguous repeated completion, reserved fields and host events.

`collect_detection(generation)` explicitly reads/acknowledges REG02/03 while permission is LOW. Zero means Detecting. One-hot SDP/CDP/DCP means Ready with `valid=true`; proprietary, other or multiple bits are Rejected with `valid=false`. SDP classification does not establish enumeration or a 500/900 mA allowance. A failed collection requires a new cycle; no retry can revive its old result.

`poll(generation)` reads only the control registers and returns cached classification. It does not read any status/interrupt register, write any register, restart detection, or extend `observed_ms`. A generation mismatch, bus/configuration fault or expiry permanently invalidates that cycle. `invalidate()` does no I2C and is worker-only; an ISR must signal the worker instead of calling driver methods. `stop()` invalidates first, then clears detection and selects power-down even if one write fails.

The default ready lifetime is 30 seconds, configurable to a positive value below 2^31 ms. Detection has a 5-second timeout. Both are conservative application choices, not manufacturer guarantees. The policy must temporarily lower current permission before periodic requalification; its effects on load supply and charging need physical tests. Time differences tolerate a normal 32-bit millisecond wrap.

## Verification and remaining work

The test fixture models destructive reads, ignored writes and a fresh detection edge. Tests cover every class, multi-bit and reserved results, stale power-up flags, read-only repeated polling, generation changes, age/timeout/wrap, detector unplug/recovery, host events, control mutation, stuck status and every individual setup/collection read failure. Strict compilation uses `-Wall -Wextra -Werror`; sanitizer compilation adds `-fsanitize=address,undefined`.

See `bc12-source-monitor.json` for commands, source and binary hashes, and the two test logs. Combined source policy, latch/GPIO wiring, I2C electrical timing, periodic detection, standard USB-A/USB-C supplies and cable changes still require integration and bench tests. BQ25895 D+/D− remain physically unconnected; this driver never asks it to perform DPDM or a higher-voltage handshake.
