from pathlib import Path
D=Path(__file__).resolve().parent
import route_context as c
import route_bounded as r
p=c.p;b=c.b
def pad(ref,num):return next(q for f in b.GetFootprints()if f.GetReference()==ref for q in f.Pads()if q.GetNumber()==num)
a=pad('Q110','3');z=pad('R116','2')
print('pads',a.GetLayerSet().FmtHex(),z.GetLayerSet().FmtHex(),flush=True)
try:
 r.route(a.GetNetname(),c.xy(a.GetPosition()),c.xy(z.GetPosition()),start_layers=(0,),end_layers=(2,),bounds=(.6,80,30,98.35));c.save()
except AssertionError as e: print(e,flush=True)
