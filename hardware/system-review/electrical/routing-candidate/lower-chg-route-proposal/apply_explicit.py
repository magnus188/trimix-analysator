from build_bridge import *
items=json.loads((OUT/"explicit-route-items.json").read_text())
for q in items:
 if q["type"]=="via":via(q["net"],q["at"],q["diameter_mm"],q["drill_mm"])
 else:track(q["net"],[q["start"],q["end"]],b.GetLayerID(q["layer"]),q["width_mm"])
save()
