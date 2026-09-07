import sys,importlib
def run(_context:str):
    path='/Users/magnustrandokken/Documents/Projects/Trimix/trimix-analysator/hardware/enclosure/rev03/scripts'
    if path not in sys.path:sys.path.insert(0,path)
    import verify_step_roundtrip as v
    importlib.reload(v)
    v.verify()
