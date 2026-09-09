import sys,json
def run(_context:str):
    path='/Users/magnustrandokken/Documents/Projects/Trimix/trimix-analysator/hardware/cad/rev03/scripts'
    if path not in sys.path:sys.path.insert(0,path)
    import build_rev03 as b
    _,d=b.get()
    print(json.dumps({'analyses_properties':[v for v in dir(d.analyses) if not v.startswith('_')],
      'sections':[{k:str(getattr(a,k)) for k in dir(a) if k in ['name','isLightBulbOn','isVisible','isSuppressed','offset','sectionPosition','isFlipDirection']} for a in d.analyses.sectionAnalyses],
      'cover':[(o.name,o.isLightBulbOn,[(v.name,v.isLightBulbOn,v.isVisible) for v in o.component.bRepBodies]) for o in d.rootComponent.occurrences if o.component.name=='02 Single rear cover']}))
