import adsk.core
import adsk.fusion
import json
def run(_context: str):
    app=adsk.core.Application.get()
    d=adsk.fusion.Design.cast(app.activeProduct)
    print('grid commands',[(x.id,x.name) for x in app.userInterface.commandDefinitions if 'grid' in x.id.lower() or 'grid' in x.name.lower()])
    for lib in app.materialLibraries:
        found=[(a.name,a.id) for a in lib.appearances if any(w in a.name.lower() for w in ('matte','opaque','plastic'))]
        if found:
            print('appearances',lib.name,found[:12])
    print('origin flag',hasattr(d.rootComponent,'isOriginFolderLightBulbOn'))
