import sys
import importlib

def run(_context: str):
    scripts='/Users/magnustrandokken/Documents/Projects/Trimix/trimix-analysator/hardware/cad/scripts'
    if scripts not in sys.path:
        sys.path.insert(0,scripts)
    import fusion_helpers
    import build_enclosure
    importlib.reload(fusion_helpers)
    importlib.reload(build_enclosure)
    build_enclosure.finish_mechanics()
