"""Prepare an isolated, matched native project for the CC process trial."""
from pathlib import Path
import hashlib,json,shutil
import pcbnew as p
import sexpdata as s
D=Path(__file__).resolve().parent;ROOT=D.parent;O=D/'vippo-cc/native';O.mkdir(parents=True,exist_ok=True)
P=ROOT/'permission-links-proposal/final-resistor-completion'
source=D/'vippo-cc/candidate-unfilled.kicad_pcb'
expected='1b9fa8abb6170f05252bef4e5a7c80572722a637b0797b580f2ece01d841e88c'
sha=lambda q:hashlib.sha256(q.read_bytes()).hexdigest()
assert sha(source)==expected
inputs={}
for q in list(P.glob('*.kicad_sch'))+list(P.glob('*.kicad_sym'))+[P/'sym-lib-table',P/'fp-lib-table',P/'Trimix_Analyzer.kicad_pro',P/'Trimix_Analyzer.kicad_dru']:
    if q.exists():shutil.copy2(q,O/q.name);inputs[q.name]=sha(q)
for q in P.glob('*.pretty'):
    shutil.copytree(q,O/q.name,dirs_exist_ok=True)
    for f in q.rglob('*'):
        if f.is_file():inputs[str(f.relative_to(P))]=sha(f)
rules=ROOT.parent/'vippo-process-review/u115-cc-scoped-rules.kicad_sexpr'
baseline_rules=(O/'Trimix_Analyzer.kicad_dru').read_text()
(O/'Trimix_Analyzer.kicad_dru').write_text(baseline_rules+'\n'+rules.read_text())
shutil.copy2(source,O/'Trimix_Analyzer.kicad_pcb')
b=p.LoadBoard(str(O/'Trimix_Analyzer.kicad_pcb'));b.GetDesignSettings().m_TrackMinWidth=p.FromMM(.15)
project=(O/'Trimix_Analyzer.kicad_pro').read_bytes()
p.ZONE_FILLER(b).Fill(b.Zones());p.SaveBoard(str(O/'Trimix_Analyzer.kicad_pcb'),b)
(O/'Trimix_Analyzer.kicad_pro').write_bytes(project)
tag=lambda q:str(q[0])if isinstance(q,list)and q else''
board=s.loads((O/'Trimix_Analyzer.kicad_pcb').read_text());parts={}
for q in board:
    if tag(q)!='footprint':continue
    props={a[1]:a[2]for a in q if tag(a)=='property'}
    if props.get('Reference')in ('R101','R118','R119','C116'):parts[props['Reference']]={**props,'Footprint':q[1]}
changes=[]
for q in O.glob('*.kicad_sch'):
    data=s.loads(q.read_text());modified=False
    for item in data:
        if tag(item)!='symbol':continue
        props={a[1]:a for a in item if tag(a)=='property'};ref=props.get('Reference',[None,None,None])[2]
        if ref not in parts:continue
        for key in ('Footprint','MPN','Value','Datasheet'):
            if key not in parts[ref]or key not in props or props[key][2]==parts[ref][key]:continue
            changes.append(dict(file=q.name,ref=ref,key=key,before=props[key][2],after=parts[ref][key]))
            props[key][2]=parts[ref][key];modified=True
    if modified:q.write_text(s.dumps(data)+'\n')
assert sha(source)==expected
(D/'vippo-cc/native-preparation.json').write_text(json.dumps({'status':'ISOLATED_NATIVE_PROJECT_DRC_PENDING',
    'source_sha256':expected,'native_board_sha256':sha(O/'Trimix_Analyzer.kicad_pcb'),
    'supporting_inputs_sha256':inputs,'scoped_rule_source_sha256':sha(rules),
    'isolated_schema_field_changes':changes,'canonical_EDA_modified':False,'release':False},indent=2)+'\n')
print('Prepared',O,'boardSHA',sha(O/'Trimix_Analyzer.kicad_pcb'),flush=True)
