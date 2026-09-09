from route_bounded import route,c
c.remove(['3c0670f1-c03a-4a0a-bf6a-33687f86a6cc','e1670b7a-858d-41a6-aa2d-11c5439e603d'])
route('CHG_INT_N',(15.913,84.9019),(18.1454,81.272),start_layers=(1,),end_layers=(1,),bounds=(7,76,29.2,89.15))
c.save()
from island_targets import connected_track_targets
bounds=(.6,65,29.2,89.15)
sources,sw=connected_track_targets(c.b,'I2C_SCL','532da661-1898-4d38-b7fc-5d71fe61ab57',bounds)
targets,tw=connected_track_targets(c.b,'I2C_SCL','0ee9e820-7ebd-475d-8dca-983bb85d13d0',bounds)
route('I2C_SCL',(25.1,75.15),(9.98,84.75),start_layers=(0,1,2),end_layers=(0,1,2),bounds=bounds,starts=sources,targets=targets)
c.save()
