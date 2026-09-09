import route_context as c
p=c.p;D=c.D;c.b=p.LoadBoard(str(D/'gateway-open-root-cc.kicad_pcb'));b=c.b
c.via('CHG_INT_N',(17.65,88.7));c.track('CHG_INT_N',[(16.8,87.8),(17.65,88.7)],p.F_Cu);c.track('CHG_INT_N',[(17.65,88.7),(12.2,89.75)],p.In2_Cu)
for at in [(13.6,91),(17.95,87.925)]:
 c.via('USB_OVP_UVLO',at)
 v=next(t for t in b.GetTracks()if isinstance(t,p.PCB_VIA)and c.xy(t.GetPosition())==at and t.GetNetname()=='USB_OVP_UVLO');v.SetFillingMode(p.FILLING_MODE_FILLED);v.SetCappingMode(p.CAPPING_MODE_CAPPED)
import route_bounded as r
r.route('USB_OVP_UVLO',(13.6,91),(17.95,87.925),start_layers=(1,),end_layers=(1,),allow_vias=False,bounds=(12.8,87.4,19.5,91.5))
p.ZONE_FILLER(b).Fill(b.Zones());p.SaveBoard(str(D/'uvlo-chg-open-host.kicad_pcb'),b);print('SAVED UVLO+CHG, HOST OPEN; EXACT TWO VIAFILL/CAP FLAGS SET')
