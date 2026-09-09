from pathlib import Path
import sexpdata as s,json
D=Path(__file__).resolve().parent;raw=s.loads((D/'base-with-aux.kicad_pcb').read_text())
def tag(q):return str(q[0])if isinstance(q,list)and q else''
def uid(q):return next((a[1]for a in q if tag(a)=='uuid'),None)if isinstance(q,list)else None
chg={'65121007-3de7-4bc3-a370-c282aa06715a','551051f9-15ca-4e98-9e17-600b206e2b0c','d56470aa-89ba-4753-b400-b48efdeb517f'}
host={'1bf7d7fe-e8c0-4c02-bdad-b262ecb35507','25d87e0b-8285-4a33-a305-21b77aa263be','7640755f-7eb3-4787-b80f-b44f25a93b49','d2933a5b-a6e9-4338-acc3-1c9d916099d4','f561edcc-2a29-4b19-a6b8-42838ea7185a'}
removed=[dict(uuid=uid(q),kind=tag(q),native=s.dumps(q),group='CHG'if uid(q)in chg else'HOST')for q in raw if uid(q)in chg|host];assert len(removed)==8
raw=[q for q in raw if uid(q)not in chg|host];(D/'gateway-open.kicad_pcb').write_text(s.dumps(raw)+'\n');(D/'removed.json').write_text(json.dumps(removed,indent=2))
