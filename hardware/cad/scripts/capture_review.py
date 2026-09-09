"""Export real Fusion viewport views and retain a named centre section analysis."""
import importlib
import json
import sys

def run(_context: str):
    scripts='/Users/magnustrandokken/Documents/Projects/Trimix/trimix-analysator/hardware/cad/scripts'
    if scripts not in sys.path:
        sys.path.insert(0, scripts)
    import build_enclosure as b
    importlib.reload(b)
    app,d=b.app_design()
    b.style_model()
    occurrences=list(d.rootComponent.occurrences)
    for occurrence in occurrences:
        occurrence.isLightBulbOn=True
    for view in ('front','rear','left','right'):
        b.capture(view)
    hidden=('02 ','04 ','19 ')
    for occurrence in occurrences:
        if occurrence.component.name.startswith(hidden):
            occurrence.isLightBulbOn=False
    b.capture('rear', 'rear-open.png')
    b.capture('rear_iso','rear-open-isometric.png')
    for occurrence in occurrences:
        occurrence.isLightBulbOn=True
    name='A-A centre section / X=0 / review only'
    analysis=next((a for a in d.analyses.sectionAnalyses if a.name==name),None)
    if not analysis:
        request=d.analyses.sectionAnalyses.createInput(d.rootComponent.yZConstructionPlane,0)
        request.isHatchShown=True
        analysis=d.analyses.sectionAnalyses.add(request)
        analysis.name=name
    analysis.isLightBulbOn=True
    b.capture('left','section.png')
    analysis.isLightBulbOn=False
    b.capture('iso','assembled.png')
    print(json.dumps({'views':'front, rear, left, right, rear-open, section, assembled',
                      'section':analysis.name,'all_occurrences_visible':True}))
