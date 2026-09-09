from pathlib import Path
D=Path(__file__).resolve().parent
import route_context as c
p=c.p;c.b=p.LoadBoard(str(D/'q110-turn-base.kicad_pcb'));b=c.b
f=next(f for f in b.GetFootprints()if f.GetReference()=='Q110');f.SetPosition(c.vec((18,89.5)));f.SetOrientationDegrees(180)
for q in f.Pads(): print(q.GetNumber(),c.xy(q.GetPosition()),q.GetNetname(),flush=True)
c.save()
