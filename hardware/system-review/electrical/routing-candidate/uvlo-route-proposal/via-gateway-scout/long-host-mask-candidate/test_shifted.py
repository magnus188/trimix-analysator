"""Ordinary OVLO replacement and isolated HOST reroute exploration."""
from probe_geometry import *
from route_bounded import route
from island_targets import connected_track_targets

c.remove(['674c2f7e-3fc3-4bfb-a9c7-ef1bb5ae9d95','97221b3e-53ad-480c-bf50-4f989f070dbc',
          '91a7f038-9249-4cde-9b20-cfbdfab57b7c','daacecbf-3805-4164-b10b-2cc85f1369aa'])
ov=(12.5,90.1);uv=(13,90.85)
assert not via_bad('USB_OVP_SET',ov)
assert not track_bad('USB_OVP_SET',[ov,(13.6,90.225)],p.B_Cu)
c.via('USB_OVP_SET',ov)
c.track('USB_OVP_SET',[ov,(13.6,90.225)],p.B_Cu)
c.track('USB_OVP_SET',[ov,(12.65,90.05)],p.In2_Cu)
assert not via_bad('USB_OVP_UVLO',uv),via_bad('USB_OVP_UVLO',uv)
c.via('USB_OVP_UVLO',uv)
c.track('USB_OVP_UVLO',[uv,(13.3,90.975)],p.B_Cu)
route('USB_OVP_UVLO',uv,(15.2,89.7),start_layers=(0,),end_layers=(0,),allow_vias=False,bounds=(12.5,88.9,15.5,91.3))
region=(6.5,84.5,29.2,98.5)
starts,sr=connected_track_targets(c.b,'HOST_3V3','1bf7d7fe-e8c0-4c02-bdad-b262ecb35507',region)
targets,tr=connected_track_targets(c.b,'HOST_3V3','c253b6c2-ca2e-4bb8-859e-84bc94ad8f79',region)
assert not set(sr['connected_object_uuids'])&set(tr['connected_object_uuids'])
route('HOST_3V3',(11.95,91.6),(13.45,90.45),starts=starts,targets=targets,bounds=region)
c.save()
