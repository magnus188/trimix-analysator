# Exact M3 rear-cover insert candidate

The current four generic OD4.2 × 5 mm inserts do not establish a purchased heat-set interface. This candidate is the manufacturer's **VORON M3 × 5 × 4** insert, EAN **4262391010051**. The [official product page](https://cnckitchen.store/products/made-for-voron-gewindeeinsatz-threaded-insert-m3x5x4-100-stk-pcs) identifies M3 threads and 4 mm length. Its unrelated HTML page title is stale; use the displayed product name, EAN and matching manufacturer drawing, not the title as a part number. No exact TC stock code was visible in the reviewed text.

The [manufacturer poster](https://www.cnckitchen.com/s/CNCKitchen_Heat-Set-Insert-Dimensions-and-Design-Guidelines.pdf) specifies a 5 mm crest, 4.4 mm pilot and 1.6 mm minimum material measured from the pilot. Its blind-hole guidance is insert length plus 1 mm. The current full pilot depth is 5 mm, with separate narrower screw-tip relief below it. A candidate 9 mm boss would provide the project's nominal 2 mm beyond the 5 mm crest, subject to actual native geometry and adjacent cuts.

The proposed native review preserves the four open faces, axes, cover bearing surfaces, screws and tip relief. It checks the exact unscaled model, 9 mm bosses and 4.4 mm pilots, including the receiving webs, chamber, screwdriver and cover removal paths. This proposal is not adopted by extracting these files. It requires a separately reviewed geometry receipt before application.

The STEP and STL were extracted from the already source-bound official CAD archive, using exactly `STEP/m3_voron.step` and `STL/m3_voron.stl`. The binary STL has 59,898 triangles and nominal bounds 5.000 × 4.999385 × 4.000 mm. [The source receipt](source-review.json) binds the model, archive and poster hashes. Mesh bounds do not establish machining tolerances, a faithful modeled internal thread, screw engagement or retention strength.

Physical print/pilot accuracy, installation temperature, actual screws, usable thread, torque and repeated-service retention remain pending. Manufacturer reference material retains its original terms; no purchase or relicensing is included.
