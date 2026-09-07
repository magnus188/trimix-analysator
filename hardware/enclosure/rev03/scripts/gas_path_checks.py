"""Continuous transient BRep clearance probes through the open sample volume.

These are probe volumes, not physical tubes or a flow simulation. A connected
path does not prove flow distribution, gas mixing or sensor response.
"""
import json
import adsk.core as core
import adsk.fusion as fusion
import build_rev03 as b
from service_checks import _records, _intersection_volume, _label
from fusion_audit import _bodies

def audit():
    _,d=b.get(); before=_bodies(d); timeline=d.timeline.count
    manager=fusion.TemporaryBRepManager.get(); records=_records(d,manager)
    paths={
        'inlet to exhaust':[(78,105,23),(57,105,23),(57,91.75,23),(57,91.75,21.25),
                            (17.5,91.75,21.25),(17.5,105,21.25),(17.5,105,23),(-3,105,23)],
        'connection to lower CO and He region':[(57,105,23),(57,77,23),(57,77,40.75),
                                               (67,77,40.75),(67,61.5,40.75),(67,61.5,45),(67,50,45)],
    }
    results=[]
    point=lambda xyz: core.Point3D.create(*[v/10 for v in xyz])
    for name,route in paths.items():
        probes=[]; hits=[]
        for i,p in enumerate(route): probes.append(('vertex '+str(i),manager.createSphere(point(p),0.25)))
        for i,(p,q) in enumerate(zip(route,route[1:])):
            probes.append(('segment '+str(i),manager.createCylinderOrCone(point(p),0.25,point(q),0.25)))
        for label,probe in probes:
            if not probe or not probe.isTransient: raise RuntimeError('Gas clearance probe creation failed')
            for part in records:
                volume=_intersection_volume(manager,probe,part['body'])
                if volume>1e-5:
                    hits.append({'probe':label,'obstacle':_label(part),'volume_mm3':round(volume,8)})
        results.append({'name':name,'waypoints_mm':route,'probe_diameter_mm':5,
                        'continuous_cylinders_and_vertex_spheres':True,'collisions':hits,
                        'status':'clear_5_mm_probe' if not hits else 'probe_blocked'})
    if timeline!=d.timeline.count or before!=_bodies(d): raise AssertionError('Gas audit changed CAD geometry')
    report={'paths':results,'pass':all(not r['collisions'] for r in results),
            'persistent_geometry_unchanged':True,
            'method':'Exact continuous transient 5 mm diameter cylinders plus spheres at every path corner, checked against all placed solid BReps.',
            'limits':['Probe volumes are not modelled physical inlet tubes, hoses or bend-radius claims.',
                      'The two routes demonstrate connected clearance only; the upper inlet can bypass the lower CO/He region.',
                      'Flow distribution, seal leakage, sensor gas interfaces, thermal effects and response time require later design and bench validation.']}
    path=b.BASE/'verification'/'gas-clearance-paths.json'
    path.write_text(json.dumps(report,indent=2)+'\n')
    print(json.dumps({'gas_clearance_report':str(path),'pass':report['pass'],
                      'results':[{'name':r['name'],'status':r['status'],'collisions':r['collisions']} for r in results]}))
