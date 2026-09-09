"""Finalize bounded GCT reference details and diagnostics in the owned copy."""
import importlib
from runtime import owned

def apply():
    owned()
    import usb_correction,materials_review,inspect_review
    importlib.reload(usb_correction).gasket_envelope()
    importlib.reload(materials_review).gasket()
    importlib.reload(inspect_review).inspect()
