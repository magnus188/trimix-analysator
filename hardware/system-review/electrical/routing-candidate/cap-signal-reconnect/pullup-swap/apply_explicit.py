"""Reproduce the reviewed route without depending on routing-grid choices."""
import build_bridge as c
c.track('I2C_SCL',[(4.225,83.5),(4.2905,85.2995)])
c.track('HOST_3V3',[(23.4185,75),(24.325,75)])
c.track('CHG_INT_N',[(22.675,75),(21.8,73.8),(21.65,73.65),(21.25,73.6),(20.55,73.6),(20,73.8),(19.95,74.3)])
c.via('CHG_INT_N',(19.95,74.3))
c.track('CHG_INT_N',[(19.95,74.3),(18.9,73.05),(18.35,68.25),(18.9,66.3),(20.2,65),(22.8,63),(23.35,62.95),(23.8258,63.4536)],c.p.In2_Cu)
c.save()
