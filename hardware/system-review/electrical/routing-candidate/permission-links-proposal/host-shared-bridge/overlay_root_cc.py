from pathlib import Path
import sexpdata as s,json,hashlib
D=Path(__file__).resolve().parent;R=D.parents[1]/'set-cc-root-proposal/vippo-cc'
j=json.loads((R/'proposal.json').read_text());p=R/'candidate-unfilled.kicad_pcb';assert hashlib.sha256(p.read_bytes()).hexdigest()==j['unfilled_sha256']
raw=s.loads((D/'gateway-open.kicad_pcb').read_text());root=s.loads(p.read_text());old=s.loads(Path(j['source_file']).read_text())
def tag(q):return str(q[0])if isinstance(q,list)and q else''
def uid(q):return next((a[1]for a in q if tag(a)=='uuid'),None)if isinstance(q,list)else None
mine={uid(q):q for q in raw if uid(q)};theirs={uid(q):q for q in root if uid(q)};original={uid(q):q for q in old if uid(q)}
for k in j['removed_CC_items']:assert mine[k]==original[k],k
raw=[q for q in raw if uid(q)not in j['removed_CC_items']]
for k in [j['added_VIPPO']['uuid'],j['source_CC_route'][0]['uuid']]:assert k not in mine;raw.append(theirs[k])
def canon(q):return [x for x in q if tag(x)!='uuid']
for q in j['added_segments'][1:]:
 hits=[v for v in mine.values()if tag(v)=='segment'and canon(v)==canon(theirs[q['uuid']])]
 assert len(hits)==1,(q['uuid'],len(hits))
(D/'gateway-open-root-cc.kicad_pcb').write_text(s.dumps(raw)+'\n');(D/'root-cc-overlay.json').write_text(json.dumps(dict(root_proposal_sha256=hashlib.sha256((R/'proposal.json').read_bytes()).hexdigest(),root_board_sha256=j['unfilled_sha256'],removed=j['removed_CC_items'],added=[j['added_VIPPO']['uuid'],j['source_CC_route'][0]['uuid']],scope='Exact guardedCCsource delta; Bdestination alreadypresent. Root owns exact process/rule qualification; isolatedrouting overlay only.'),indent=2))
