import route_context as c
from pathlib import Path
import sys,types,json,math,hashlib
from island_targets import connected_track_targets
c.OUT=c.OUT/'set-bridge-scout';c.OUT.mkdir(exist_ok=True)
removed_ids=['40b1bf21-f6b5-4820-b4be-583e59537237','d30696be-de67-4ae7-b9c6-81d80c77e129','4374b892-fa63-4f8d-9db1-237b41ff1de9','91a7f038-9249-4cde-9b20-cfbdfab57b7c'];held=[]
for t in list(c.b.GetTracks()):
 if t.m_Uuid.AsString()in removed_ids:held.append(t);c.b.Remove(t)
assert len(held)==4
power=json.loads((c.OUT.parent/'power-corridor-scout.json').read_text())['hypothetical_points_mm'];c.track('VSYS',power,c.p.In2_Cu,width=.4);c.added.clear()
original_via=c.via
def ordinary(net,q):return original_via(net,q,d=.5,h=.25)
c.via=ordinary
sys.modules['build_bridge']=c
m=types.ModuleType('bounded_signal_router');exec((c.OUT.parent.parent/'cap-signal-reconnect/pullup-swap/route_bounded.py').read_text(),m.__dict__)
NET='USB_OVP_SET';bounds=(9,84.5,19,93)
starts,sr=connected_track_targets(c.b,NET,'674c2f7e-3fc3-4bfb-a9c7-ef1bb5ae9d95',bounds)
targets,tr=connected_track_targets(c.b,NET,'4ca9a873-669c-4374-8f94-908c56e6556f',bounds)
assert not set(sr['connected_object_uuids'])&set(tr['connected_object_uuids'])
(c.OUT/'islands.json').write_text(json.dumps({'source':sr,'target':tr,'reserved_hypothetical_power':power},indent=2)+'\n');print('targets',len(targets),'starts',len(starts),flush=True)
try:m.route(NET,(12.4,90.3),(12.2,87.8),width=.15,bounds=bounds,starts=starts,targets=targets)
except AssertionError as e:print('FAILED',e,flush=True)
else:
 (c.OUT/'proposal.json').write_text(json.dumps({'source_sha256':c.EXPECTED,'removed_uuids':removed_ids,'added':c.added,'source_witness':sr,'target_witness':tr,'status':'SCOUT_REQUIRES_NATIVE_DRC','release':False},indent=2)+'\n');print('FOUND',len(c.added),flush=True)
assert hashlib.sha256(c.P.read_bytes()).hexdigest()==c.EXPECTED
