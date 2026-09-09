from pathlib import Path
import route_context as c
import apply_ce
import json,sys,types,hashlib
from island_targets import connected_track_targets
ROOT=c.OUT;c.OUT=ROOT/'set-scout';c.OUT.mkdir(exist_ok=True)
removed=['40b1bf21-f6b5-4820-b4be-583e59537237','d30696be-de67-4ae7-b9c6-81d80c77e129','4374b892-fa63-4f8d-9db1-237b41ff1de9','91a7f038-9249-4cde-9b20-cfbdfab57b7c'];held=[]
for t in list(c.b.GetTracks()):
 if t.m_Uuid.AsString()in removed:held.append(t);c.b.Remove(t)
assert len(held)==4
power=json.loads((ROOT.parent/'power-corridor-v2.json').read_text())['points_mm'];c.track('VSYS',power,c.p.In2_Cu,width=.4);c.added.clear()
oldvia=c.via
c.via=lambda net,q:oldvia(net,q,d=.5,h=.25)
sys.modules['build_bridge']=c
s=(ROOT.parent.parent/'cap-signal-reconnect/pullup-swap/route_bounded.py').read_text()
s=s.replace('if isinstance(it,p.PAD) and it.GetAttribute()==p.PAD_ATTRIB_SMD:add_shape(smd,layer,shape)','if isinstance(it,p.PAD):add_shape(smd,layer,shape)')
needle=' for it in b.GetDrawings():'
reservation=''' reserve=p.SHAPE_POLY_SET();reserve.NewOutline()
 for x,y in[(15.7,89.3),(18.5,89.3),(18.5,91),(15.7,91)]:reserve.Append(p.FromMM(x),p.FromMM(y))
 for L in ALL:add_shape(index,L,reserve)
'''
assert needle in s;s=s.replace(needle,reservation+needle)
m=types.ModuleType('set_signal_router');exec(s,m.__dict__)
net='USB_OVP_SET';bounds=(9,86,15.5,91.3)
starts,sr=connected_track_targets(c.b,net,'674c2f7e-3fc3-4bfb-a9c7-ef1bb5ae9d95',bounds)
targets,tr=connected_track_targets(c.b,net,'4ca9a873-669c-4374-8f94-908c56e6556f',bounds)
starts=[x for x in starts if x[0]==0];targets=[x for x in targets if x[0]==0]
print('SET F targets',targets,'starts',starts,flush=True)
try:m.route(net,(12.4,90.3),(12.2,87.8),start_layers=(0,),end_layers=(0,),width=.15,bounds=bounds,starts=starts,targets=targets,allow_vias=False)
except AssertionError as e:print('FAILED',e,flush=True)
else:
 out={'status':'SCOUT_REQUIRES_COMBINED_NATIVE_DRC','source_sha256':c.EXPECTED,'source_includes_CE_delta':True,'removed_SET_uuids':removed,'added':c.added,'source_witness':sr,'target_witness':tr,'reserved_power_corridor':power,'reserved_C116_CC_box_mm':[15.7,89.3,18.5,91],'release':False}
 (c.OUT/'proposal.json').write_text(json.dumps(out,indent=2)+'\n');print('FOUND',len(c.added),flush=True)
assert hashlib.sha256(c.P.read_bytes()).hexdigest()==c.EXPECTED
