# Width regeneration: dependency audit

The read-only Fusion inventory on 2026-09-08 confirms that SystemReview v7 remains saved, unmodified, with 1,197 timeline items. Other open documents, including the unsaved FlowGrid R3.1 work, were preserved. See [width-dependency-inventory.json](width-dependency-inventory.json).

The earlier 85→87 mm test exposed a real registration mismatch. `UsbX = CaseWidth / 2` correctly moves the whole USB assembly. The main PCB wrapper stays at X50.4 because it has no placement joint and `PcbX` is fixed. The widening carrier allocation does not move or resize the purchased PCB. At 87 mm the USB support frame overlaps the main board by the previously recorded 0.0819 mm³; the restored 85 mm baseline was clear. See [width-datum-diagnosis.json](width-datum-diagnosis.json) and the existing regeneration evidence.

Changing only `PcbX` is not a completed correction. Although the lower mounting support and carrier geometry reference it, the upper 54.8 mm mounting datum, battery divider and several carrier clearance features were authored with separate coordinates. The imported board, mounting hardware, back-side pockets, height envelopes and harness allocations must share one rigid placement contract before a new width-dependent datum can be accepted. Purchased parts must not be scaled.

This audit makes no geometry changes and does not clear the width-regeneration acceptance gate. The approved 85 mm exterior remains the baseline. The final routed-board integration must either correct and retest these dependencies or state the verified parameter range explicitly; a healthy timeline alone is not an interference check.
