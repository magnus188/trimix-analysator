# GCT USB4720-03-A source record

Retrieved 6 September 2026. **No manufacturer STEP/IGES file was obtained.** No CAD bounding box or supplier CAD orientation can therefore be reported.

The [official GCT product page](https://gct.co/connector/usb4720) explicitly identifies its embedded preview as USB4720-03-A. Its [TraceParts viewer](https://www.traceparts.com/els/gct/en/api/viewer/3d?EnablePresentationMode=true&MenuAlwaysVisible=true&MergeUIMenu=true&PartNumber=USB4720-03-A&SupplierID=GLOBAL_431202195) returned HTTP 403, including when opened in Vivaldi. GCT's 3D Model Generator panel did not expose a usable download control. GCT's [SnapMagic partner page](https://www.snapeda.com/parts/USB4720-03-A/Global%20Connector%20Technology/view-part/) loaded, but the model panel remained blank and the normal format-download links led to account signup. No account, contact request, paid model request or agreement was submitted.

## Available manufacturer evidence

`GCT_USB4720_RevB_drawing.pdf` is the unmodified, three-sheet manufacturer drawing downloaded directly from [GCT](https://gct.co/files/drawings/usb4720.pdf). It identifies Revision B, revision date **02/01/25**, and original drawing date **26 October 2023**. It is also available through [GCT's Mouser distribution page](https://www.mouser.com/catalog/specsheets/GCT_USB4720_revB.pdf).

SHA-256: `b3347df8cf39cc4f72e60f88708d3ddedec681d77bfcbbc9a3a5fd53975a5be6`

The drawing is copyright Global Connector Technology, Ltd. Its title block restricts copying/disclosure; no open redistribution licence was identified. Keep attribution and obtain permission before public redistribution. This source copy is a local engineering reference, not a claim to ownership or an open-source asset.

## Reconstruction limits

`../scripts/usb_details.py` creates clearly labelled drawing-derived reference parts. The nominal panel uses three rounded sections **8.44 × 2.66 R1.05**, **9.14 × 3.35 R1.39**, and **9.64 × 3.86 R1.65 mm**, with a **10°** entry, **0.50 mm** seat and **0.67 mm** overall seat region. The **1.80 mm** local panel reference is represented in a separate metal faceplate; the backing frame is printed with **2 mm** nominal flange thickness. Small R0.20 transitions are omitted. No seal performance is established.

The **0.60 mm** daughterboard and straddle slot are provisional layout references. Metal shell, insulator, gasket, contacts, faceplate, printed support, screws and inserts are separate assembly components. Contact details and wall thicknesses within the purchased connector are illustrative; this is not an exact pin model or production footprint. Entry faces +X, with nominal Y/Z centre **16/27 mm** in Revision 03 coordinates. Actual board layout, physical tolerance, plug clearance and insertion loads remain integration checks.

`add_housing_clamp()` supplies a rear-accessible M2 clamp and permanent housing post; `fix_usb_geometry()` applies the corrected corner, upper faceplate mount and clamp position. Its proposed removal sequence is battery holder first, lower display retainer, clamp screw and clamp, then **11.7 mm inward (-X)** before rearward (+Z) cartridge extraction. That greater lateral travel is intended to clear the permanent post, including the faceplate screw heads. The nominal post gap is 0.5 mm and carrier gap 0.6 mm after translation; these are calculated from model inputs and require the assembly's actual BRep path audit and physical access check. The separate metal faceplate's 1.80 mm local section is outside the printed-wall claim. Selected printed sections and annuli calculate to at least 2 mm; [USB_WALL_EVIDENCE.md](USB_WALL_EVIDENCE.md) states the calculations and limits. A whole-model minimum-wall test has not been established by those source checks.

The partner library reported a Revision A drawing basis. This source record uses Revision B; the associated change notice was not retrieved and no claim about every revision difference is made.
