import route_context as c
from route_power import route
from island_targets import connected_track_targets
import json
c.OUT=c.OUT/'upper-power-approach';c.OUT.mkdir(exist_ok=True)
bounds=(14,78,28.75,90)
goals,gr=connected_track_targets(c.b,'VSYS','bb5aec9b-1ff4-4544-8878-dac6d41c8a1b',bounds)
try:route('VSYS',(17.825,86.225),(15.84,84.25),start_layers=(1,),end_layers=(0,1,2),width=.4,bounds=bounds,targets=goals)
except AssertionError as e:print('FAILED',e,flush=True)
else:
 (c.OUT/'proposal.json').write_text(json.dumps({'status':'HYPOTHETICAL_PARTIAL_POWER_APPROACH_ONLY','source_sha':c.EXPECTED,'source_midpoint':[17.825,86.225],'added':c.added,'target_island':gr,'release':False},indent=2)+'\n');print('FOUND',len(c.added),flush=True)
