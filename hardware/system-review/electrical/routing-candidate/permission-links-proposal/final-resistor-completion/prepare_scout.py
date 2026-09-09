from pathlib import Path
import sexpdata as s,json
D=Path(__file__).resolve().parent
raw=s.loads((D/'Trimix_Analyzer.kicad_pcb').read_text());ids={'aa4d8f16-f45b-430f-9d0a-d1556cb5d332','efc875d4-adb5-4084-9ecc-7deb366feef2','b3ef2552-3f64-445c-8038-ce0bfac7cf8c','877675ee-a8c4-429c-8084-f92d6210c16c'}
def uid(q):return next((x[1]for x in q if isinstance(x,list)and str(x[0])=='uuid'),None)if isinstance(q,list)else None
removed=[q for q in raw if uid(q)in ids];assert len(removed)==4
raw=[q for q in raw if uid(q)not in ids]
(D/'scout-base-v2.kicad_pcb').write_text(s.dumps(raw)+'\n')
