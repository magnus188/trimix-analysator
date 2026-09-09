> Superseded proposal. The Harwin/IDSD pair was rejected at worst-case insertion depth and plating review. Use the matched Samtec decision in `../host-harness-review/README.md` and current native J301 metadata; exact keyed availability and host power-entry qualification remain open.

# J301 board-side harness proposal

The chosen board header is Harwin M20-9981346: 2×13 positions on 2.54 mm pitch, nominal 0.64 mm square posts and 6.1 mm exposed length. The old M20-1071300 crimp housing is obsolete and is not the purchasing choice.

A proposed currently documented cable is **Samtec IDSD-13-S-04.00-G**: a 26-conductor single-ended socket assembly, 101.6 mm nominal length, grey 28 AWG stranded ribbon. Its free end can be terminated to the measured Guition connector; the remote pin sequence must be checked conductor by conductor. No assumption of a straight-through Guition ribbon is made. Supplier quotation and lead time remain pending.

The manufacturer [current IDSS/IDSD catalog](https://suddendocs.samtec.com/catalog_english/idss.pdf) permits 0.56–0.71 mm square posts and 5.59–6.22 mm insertion. Those ranges contain the nominal Harwin dimensions. Its nominal socket body is 34.52 × 5.08 × 9.27 mm for 13 positions per row, derived from the printed dimensional formula. Including the 2.54 mm header insulator gives approximately 11.81 mm mated height above the PCB before cable bending. These are nominal packaging estimates, not a physical mate or tolerance-stack test.

A 101.6 mm length of 28 AWG copper is approximately 21.6 milliohms per conductor at 20°C from bulk copper resistivity. At 1.5 A, one supply conductor drops approximately 32 mV and dissipates 49 mW, excluding contacts, returns, strand construction and heating. This estimate does not approve the continuous current rating. The connector catalog's 3 A figure explicitly belongs to IDMD and must not be misquoted as an IDSD cable rating. Measure Guition startup and operating current, confirm the actual cable/contact rating with the vendor and verify loaded voltage/temperature before freezing this cable.

Assembly gates: preserve J301 orientation and pin-1 indication; leave GPIO52/J301.7 electrically unused; map HOST_5V to J301.1; use all designated ground returns; insulate unused free conductors separately; provide bend/strain-relief clearance and accessible removal. Exact remote plug, cable shape and enclosure fit remain pending measurement.
