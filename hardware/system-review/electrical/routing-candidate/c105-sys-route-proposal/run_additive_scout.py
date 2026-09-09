import route_context as c
from route_power import route
from island_targets import connected_track_targets
import json,hashlib
bounds=(5,79,22,92)
goals,gr=connected_track_targets(c.b,'VSYS','bb5aec9b-1ff4-4544-8878-dac6d41c8a1b',bounds)
starts,sr=connected_track_targets(c.b,'VSYS','e0ff3d79-dfcb-4e4d-bd20-72417ad68f09',bounds)
assert not set(gr['connected_object_uuids'])&set(sr['connected_object_uuids'])
(c.OUT/'SYS-target-island.json').write_text(json.dumps(gr,indent=2)+'\n');(c.OUT/'SYS-source-island.json').write_text(json.dumps(sr,indent=2)+'\n');print('nativeconnected targets',len(goals),'starts',len(starts),flush=True)
try:
 route('VSYS',(7.0507,88.8048),(15.84,84.25),start_layers=(0,1,2),end_layers=(0,1,2),width=.4,bounds=bounds,starts=starts,targets=goals)
except AssertionError as e:
 print('FAILED',e,flush=True);raise
else:
 (c.OUT/'additive-power-scout.json').write_text(json.dumps({'source_sha256':c.EXPECTED,'status':'UNSAVED_NATIVE_GEOMETRY_SCOUT_REQUIRES_DRC','added':c.added,'release':False},indent=2)+'\n');print('FOUND',len(c.added),flush=True)
assert hashlib.sha256(c.P.read_bytes()).hexdigest()==c.EXPECTED
