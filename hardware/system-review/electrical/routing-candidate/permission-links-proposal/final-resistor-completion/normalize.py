from pathlib import Path
D=Path(__file__).resolve().parent
import route_context as c
c.b=c.p.LoadBoard(str(D/'0402-raw.kicad_pcb'));c.save()
