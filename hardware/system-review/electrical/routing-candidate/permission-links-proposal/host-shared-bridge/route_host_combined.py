import route_context as c
p=c.p;D=c.D;c.b=p.LoadBoard(str(D/'uvlo-chg-open-host.kicad_pcb'));b=c.b
import route_bounded as r
r.route('HOST_3V3',(11,94.25),(22,83.25),start_layers=(0,1,2),end_layers=(0,1,2),bounds=(9,83,24,96.3))
c.save();print('SAVED MUTUALLY COMPATIBLE HOST+CHG+UVLO')
