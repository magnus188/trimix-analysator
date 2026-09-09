"""Isolated UVLO gateway with independently rerouted HOST branch."""
import build_bridge as c
from route_bounded import route

c.remove(['daacecbf-3805-4164-b10b-2cc85f1369aa'])
c.via('USB_OVP_UVLO',(13,90.85))
c.track('USB_OVP_UVLO',[(13,90.85),(13.3,90.975)],c.p.B_Cu)
route('HOST_3V3',(11.95,91.6),(13.45,90.45),start_layers=(1,),end_layers=(1,),bounds=(10.5,88.2,15.5,94.5))
c.save()
