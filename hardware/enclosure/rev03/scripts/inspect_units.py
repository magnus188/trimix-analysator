import sys,json
def run(_context:str):
    path='/Users/magnustrandokken/Documents/Projects/Trimix/trimix-analysator/hardware/enclosure/rev03/scripts'
    if path not in sys.path:sys.path.insert(0,path)
    import build_rev03 as b
    app,d=b.get()
    print(json.dumps({'display_units_enum':int(d.fusionUnitsManager.distanceDisplayUnits),'default_length_units':d.unitsManager.defaultLengthUnits,'millimetre_enum':int(b.fusion.DistanceUnits.MillimeterDistanceUnits),'document':app.activeDocument.name,'cloud_version':app.activeDocument.dataFile.versionNumber}))
