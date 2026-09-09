# M2 heat-set insert candidate

**Source reviewed; not adopted in the model or BOM.** Ruthex RX-M2x4 has a manufacturer-supplied STEP model and nominal dimensions suitable for reviewing the existing 4 mm insert allocation. The official product identity is [RX-M2x4, order GE-M2x04-001](https://www.ruthex.de/en/products/ruthex-gewindeeinsatz-m2-70-stuck-rx-m2x4-messing-gewindebuchsen).

The manufacturer's drawing specifies 3.6 mm outer diameter, 3.1 mm lead-in, 4 mm length, a 3.2 mm pilot and at least 5 mm blind-hole depth. Its minimum radial wall recommendation is 1.3 mm. [Ruthex datasheet, manufacturer document hosted by its distributor](https://www.igo3d.com/mediafiles/Sonstiges/Ruthex/ruthex_Datenblatt_RX-Serie.pdf).

The current generic insert model and pilot do not establish a qualified heat-set fit. Calculated for the existing 7.2 mm support web, a 3.2 mm pilot leaves 2 mm per side, while the proposed insert's 3.6 mm crest leaves 1.8 mm. Maintaining 2 mm beyond that crest would require a 7.6 mm web. This is an interface calculation, not permission to change all bosses or ignore interference.

Before adoption, inspect the downloaded STEP, inventory affected occurrences, distinguish the printed pilot from the installed cavity, check screw depth and surrounding material, and qualify PLA/PETG coupons. The [source record](source-review.json) binds the downloads and the visually inspected first drawing page. No files were imported into Fusion and no parts were purchased.
