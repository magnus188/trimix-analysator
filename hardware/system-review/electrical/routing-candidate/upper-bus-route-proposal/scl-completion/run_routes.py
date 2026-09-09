from route_bounded import route,c
from island_targets import connected_track_targets
import json
f=next(f for f in c.b.GetFootprints()if f.GetReference()=='C707')
assert c.xy(f.GetPosition())==[21.0,69.0] and f.GetOrientationDegrees()==90
fields=[(v,v.GetPosition(),v.GetTextAngle())for v in[f.Reference(),f.Value()]]
f.SetPosition(c.vec((21.70,68.925)))
for field,pos,angle in fields:field.SetPosition(pos);field.SetTextAngle(angle)
c.poses.append({'reference':'C707','from_mm':[21.0,69.0],'to_mm':[21.70,68.925],'rotation_before_deg':90,'rotation_after_deg':90,'reference_value_global_text_poses_preserved':True,'reason':'Open ordinary SCL through-via without changing purchased package or interface connectors'})
uuid='8065715f-01f7-4d87-93d1-782d09179296'
t=next(t for t in c.b.GetTracks()if t.m_Uuid.AsString()==uuid)
assert t.GetNetname()=='I2C_SCL'and c.xy(t.GetStart())==[20.0341,69.1662]and c.xy(t.GetEnd())==[22.8991,69.1662]
c.remove([uuid])
c.track('I2C_SCL',[(20.0341,69.1662),(20.2003,69),(22.7329,69),(22.8991,69.1662)],c.p.F_Cu)
c.track('I2C_SCL',[(20.0341,69.1662),(20.5,69.6)],c.p.F_Cu)
c.via('I2C_SCL',(20.5,69.6))
bounds=(.6,65,29.2,89.15)
targets,witness=connected_track_targets(c.b,'I2C_SCL','0ee9e820-7ebd-475d-8dca-983bb85d13d0',bounds)
(c.OUT/'BQ-target-island.json').write_text(json.dumps(witness,indent=2)+'\n')
route('I2C_SCL',(20.5,69.6),(9.98,84.75),start_layers=(0,1,2),end_layers=(0,1,2),bounds=bounds,targets=targets)
c.save()
