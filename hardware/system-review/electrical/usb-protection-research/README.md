# USB connector protection review

2026-09-07. This is a sourced component/layout recommendation. The native
schematic, layout and final audit determine whether it has been implemented.
It does not establish a system ESD rating or complete the VBUS transient review.

## Four exposed signal lines

Use **TPD4E05U06DQAR**, TI USON-10 DQA: pins 1/2 protect CC1/CC2;
pins 4/5 protect D+/D−; pins 3 and 8 connect to ground. Pins 6, 7, 9 and 10
are internally unconnected. Any straight-through routing needs actual external
copper; these pads do not join signals inside the package.

The part has 5.5 V standoff, 0.5 pF typical line capacitance and 10 nA maximum
leakage at 2.5 V. Package maxima are 2.6 × 1.1 × 0.55 mm. The two published
DQA land variants differ at the ground contacts, so the final footprint must
be reconciled with the quoted supply. Place it beside the receptacle before
the harness, with short, direct ground connections. Factory assembly is
appropriate. [TI Rev O, pin table and package drawings](https://www.ti.com/lit/ds/symlink/tpd4e05u06.pdf)

## VBUS ESD suppression

Use **TPD1E10B06DYAR**, SOD-523, pin 1 to USB VBUS and pin 2 to ground.
The part supports 5.5 V standoff and 100 nA maximum leakage at 5 V. Its land
example has two 0.67 × 0.40 mm pads on 1.48 mm centres. Maximum terminal span
is 1.70 mm and height 0.77 mm; body width is 0.85 mm before the drawing's
0.15 mm per-side mould-flash allowance. Keep the ground loop short.

**This is not a 5.5 V voltage clamp.** The specified surge clamp can reach
10 V at 1 A and 14 V at 5 A. It cannot, by itself, demonstrate protection of
the TPS22950 family's 6 V absolute-maximum input. Sustained overvoltage is
also outside its purpose. [TI Rev G, electrical and package tables](https://www.ti.com/lit/ds/symlink/tpd1e10b06.pdf)

## Remaining design decision

The current input architecture is for nominal 5 V USB. The BQ25895 D+/D−
pins remain disconnected, avoiding its autonomous high-voltage source request.
No USB-PD voltage contract above 5 V is requested. This does not prove immunity
to cable hot-plug ringing, electrical discharge or a faulty supply.

An upstream **TPS259531DSG** was considered but is not selected here: its
published clamp maximum is 5.7 V and its response is finite. Adding it would
not establish a guaranteed 5.5 V downstream rail or eliminate the need to
evaluate overshoot. It also cannot replace the separate low-current startup
limiter. [TI TPS2595 Rev C](https://www.ti.com/lit/ds/symlink/tps2595.pdf)

**Missing evidence:** coordinated VBUS transient/overvoltage protection and
the final assembled port's discharge performance. A final input-protection
decision must precede a claim of electrical release readiness. Scope captures
at the limiter input during hot plug and power faults, or a suitably validated
protection network, are still needed. Part-level IEC ratings are not results
for this enclosure and wiring.

The neighbouring `tps22950-q1-review` files independently assess the accessible
SOT-23-THIN package alternative to the industrial WCSP current limiter. That
package decision does not resolve the VBUS voltage limitation.

Downloaded PDFs are unchanged manufacturer evidence; their terms and notices
are retained. Hashes and recommendation pin assignments are recorded in
`usb-protection-review.json`.
