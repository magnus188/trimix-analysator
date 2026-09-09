import importlib
import sys

def run(_context: str):
    scripts='/Users/magnustrandokken/Documents/Projects/Trimix/trimix-analysator/hardware/cad/scripts'
    if scripts not in sys.path:
        sys.path.insert(0, scripts)
    import fusion_audit
    importlib.reload(fusion_audit)
    fusion_audit.parameter_regeneration_test()
