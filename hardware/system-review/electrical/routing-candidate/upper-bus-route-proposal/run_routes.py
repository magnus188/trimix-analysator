from route_bounded import route,c
from island_targets import connected_track_targets
from proposed_sda_bridge import apply
import json
apply(c)
bounds=(.6,65,29.2,89.15)
chg,witness=connected_track_targets(c.b,'CHG_INT_N','f4002328-741f-4a4d-a3e1-0de1ad0a95e5',bounds)
(c.OUT/'CHG-native-island-search.json').write_text(json.dumps(witness,indent=2)+'\n')
route('CHG_INT_N',(8.825,77.75),(11.75,86.8),start_layers=(0,),end_layers=(0,1,2),bounds=bounds,targets=chg)
c.save()
