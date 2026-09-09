# USB default-current review — charging-only Trimix input

Reviewed 2026-09-07. **No CAD, schematic, PCB or firmware changes.** The intended J901 port has CC current detection and D+/D− battery-charger detection, but no USB enumeration or Alternate Mode function.

**100 mA is not a mandatory limit for every Default source. Native Type-C explicitly permits a Power Sinking Device (PSD) to consume 500 mA. However, this review does not establish an unconditional 500 mA entitlement through a legacy USB-A SDP. That distinction remains an architecture gate.**

## Verified source rules

| Connection / state | Current rule and primary clause |
|---|---|
| Native C-to-C, Default, power-only PSD | Up to **500 mA after attachment**; USB2 inrush still applies. PSDs must support Type-C Current, may support BC1.2, and cannot provide USB/Alternate Mode communications. **Type-C R2.5 §4.6.2.1, p226.** |
| Type-C advertises 1.5 A / 3 A | Up to the advertised level, including during USB suspend. Track decreases within **60 ms maximum**. A failed BC detection does not override a valid higher CC advertisement. **§4.6.1.1, §4.6.2.1–2; Table 4-32.** |
| Successfully detected BC1.2 CDP / DCP | Sink allowance up to **1.5 A**, without USB configuration or suspend restrictions. CDP supports 1.5 A; a DCP may begin current/voltage limiting above 0.5 A. The sink must avoid pulling it below 2 V. **BC1.2 §1.2, §4.2.1, §4.4.1, §4.6.1, Tables 5-1/2.** |
| USB-A SDP through A-to-C, no enumeration | **No verified unconditional 500 mA permission.** Under legacy rules, a good-battery unconnected/suspended sink draws below **2.5 mA average**; **100 mA** belongs to connected, unconfigured, unsuspended operation. **BC1.2 §1.4.13, p3.** |

“Default” is not itself a 900 mA authorization. Ordinary USB2 data functions start at one 100 mA unit load and require configuration for up to 500 mA. SuperSpeed operation uses 150 mA initially and up to 900 mA when configured; this design has no SuperSpeed connection. **USB2 §7.2.1, pp171–172; BC1.2 §1.7.**

## Why the legacy case remains unresolved

Type-C R2.5 **§3.5, p85** restricts legacy cables to 56 kΩ Default advertising referenced to legacy USB/BC limits. **§4.5.3.2.2, pp222–223** describes the adapter mimicking a Source. **§4.6.2.2, p228** directs a Default sink that fails BC charging-source discovery to standard USB levels through Table 4-19. These clauses do not explicitly settle precedence against the PSD permission. CC Default alone cannot distinguish these connections.

[TI’s directly relevant power-only TUSB320LAI answer](https://e2e.ti.com/support/interface-group/interface/f/interface-forum/660466/tusb320lai-usb-2-0-enumeration-and-power-sink-ufp---getting-more-than-100ma-out-of-a-usb-port) specifically retains the pre-enumeration limitation for A-to-C. Its separate 900 mA Default statement is too broad for PSDs. [Infineon’s legacy-charging answer](https://community.infineon.com/t5/EZ-PD-USB-Type-C/CYPD3177-5V-Legacy-Charging-issue/td-p/452456) uses 500 mA terminology but does not resolve SDP enumeration. Neither substitutes for an explicit cross-clause clarification.

## Startup, suspend and design disposition

- **Inrush is separate from steady current.** USB2 §7.2.4.1, p177, specifies the equivalent 10 µF parallel 44 Ω attach load and requires surge limiting for larger effective capacitance. A higher steady allowance does not waive this.
- **Suspend is not 100 mA.** The USB2 Suspend Current ECN sets 2.5 mA for ordinary USB devices. Type-C §4.6.1.1 applies USB suspend rules at Default without an explicit PSD exception; do not infer universal legacy suspend behavior from the PSD paragraph.
- BC1.2 **§2.2** dead-battery permission has signaling, timeout and eventual-enumeration obligations. It does not authorize indefinite 100 mA power-only charging.

The existing nominal 50 mA limiter and BQ 100 mA setting are **ceilings, not actual input consumption**. Calculate upstream detector/protection quiescents and downstream charge-disabled draw before evaluating legacy standby. Merely inhibiting battery charging may be insufficient. An SDP result is not a qualifying high-current source; it also does not identify whether the connector upstream is A or C.

The [conditional standby-current calculation](STANDBY_BUDGET.md) inventories the
current VBUS legs and records the missing device conditions. Its numerical
margin is not a whole-board 2.5 mA compliance result.

Do not select the proposed TPS16416/332 kΩ mode assuming it guarantees charger startup: its separately reviewed 24 mA lower limit is below BQ25895's **typical 30 mA** poor-source test, which precedes normal charging. The BQ value lacks a guaranteed maximum in its table. See [BQ25895 §8.2.3.2](https://www.ti.com/lit/ds/symlink/bq25895.pdf).

**Recommended disposition (not implemented):** do not release unclassified/SDP charging pending the actual low-current budget and a documented legacy-PSD interpretation; retain qualified CDP/DCP and 1.5/3 A charging paths. This note neither approves a new limiter nor changes firmware. A 1.4 A target must still leave tolerance and upstream-current margin below the source allowance.

## Primary source archive

- [USB-IF Type-C R2.5, March 2026](https://www.usb.org/sites/default/files/USB%20Type-C%202.5%20Release%20202603.zip), official current archive; relevant PDF pages equal printed pages.
- [USB-IF BC1.2 including March 2012 errata](https://www.usb.org/sites/default/files/BCv1.2_070312_0.zip), printed p3 corresponds to PDF p14.
- [USB-IF USB2 specification and ECNs](https://www.usb.org/sites/default/files/usb_20_20250603.zip), printed p171/p177 correspond to PDF p199/p205.
- Download hashes and selected archive members: [source manifest](sources/manifest.json). Cached older Type-C releases were cross-checks; R2.5 governs this note. Independent second reading reached the same unresolved legacy-SDP disposition.
