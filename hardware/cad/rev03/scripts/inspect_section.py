import sys,json
def run(_context:str):
    path='/Users/magnustrandokken/Documents/Projects/Trimix/trimix-analysator/hardware/cad/rev03/scripts'
    if path not in sys.path:sys.path.insert(0,path)
    import build_rev03 as b,review_views as v
    _,d=b.get();a=d.analyses.sectionAnalyses.item(0)
    d.analyses.isLightBulbOn=True;a.isLightBulbOn=True
    print(json.dumps({'folder':d.analyses.isLightBulbOn,'visible':a.isVisible,'transform':a.transform.asArray(),'attributes':[k for k in dir(a) if not k.startswith('_')]}))
    v.capture('left','section-left-test.png')
    a.flip()
    v.capture('right','section-right-flipped-test.png')
    a.isLightBulbOn=False
