import route_context as c
p=c.p;D=c.D;c.b=p.LoadBoard(str(D/'gateway-open.kicad_pcb'));b=c.b
c.via('CHG_INT_N',(17.9,88.7));c.track('CHG_INT_N',[(16.8,87.8),(17.9,88.7)],p.F_Cu);c.track('CHG_INT_N',[(17.9,88.7),(12.2,89.75)],p.In2_Cu)
import route_bounded as r
r.route('HOST_3V3',(11,94.25),(22,83.25),start_layers=(0,1,2),end_layers=(0,1,2),bounds=(10,83,23.5,95.3))
c.save();print('SAVED HOST + proposedCHG')
