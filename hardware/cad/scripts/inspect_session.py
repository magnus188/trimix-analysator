import adsk.core
import adsk.fusion
import json

def run(_context: str):
    app = adsk.core.Application.get()
    data = app.data
    active = app.activeDocument
    print(json.dumps({
        'version': app.version,
        'active_document': active.name if active else None,
        'active_project': data.activeProject.name if data.activeProject else None,
        'active_folder': {'name': data.activeFolder.name, 'id': data.activeFolder.id} if data.activeFolder else None,
        'documents': [{'name': d.name, 'modified': d.isModified, 'saved': d.isSaved} for d in app.documents],
        'root_bodies': adsk.fusion.Design.cast(app.activeProduct).rootComponent.bRepBodies.count,
        'root_occurrences': adsk.fusion.Design.cast(app.activeProduct).rootComponent.occurrences.count,
    }, indent=2))
