"""Source-bound scope and physical-contact witnesses for the isolated R504 move."""
from pathlib import Path
import sys,json,hashlib,shutil
import pcbnew as p
import sexpdata as sx
D=Path(__file__).resolve().parent;src=Path('hardware/pcb/analyzer/Trimix_Analyzer.kicad_pcb');dst=D/'candidate3/Trimix_Analyzer.kicad_pcb'
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
assert sha(src)=='9f274fdf198f1bcb871a4fc360e76693f8a5b048553e6a02998141737956514f'
def tag(q):return str(q[0])if isinstance(q,list)and q else None
def sub(q,k):return next(v[1:]for v in q if tag(v)==k)
def fps(raw):return{next(v[2]for v in f if tag(v)=='property'and v[1]=='Reference'):f for f in raw if tag(f)=='footprint'}
a=sx.loads(src.read_text());z=sx.loads(dst.read_text());af,zf=fps(a),fps(z)
unchanged={r:af[r]==zf[r]for r in af if r!='R504'}
assert set(af)==set(zf)and all(unchanged.values())
for f in [af['R504'],zf['R504']]:
 assert f[1]=='Resistor_SMD:R_0603_1608Metric'
 assert next(v[2]for v in f if tag(v)=='property'and v[1]=='Value')=='10k / 0.1%'
items=lambda raw:{sub(t,'uuid')[0]:t for t in raw if tag(t)in ['segment','via']}
at,zt=items(a),items(z);delta=json.load(open(D/'candidate-delta.json'))
removed=set(at)-set(zt);added=set(zt)-set(at);changed={u for u in set(at)&set(zt)if at[u]!=zt[u]}
assert removed==set(delta['removed'])and added=={r['uuid']for r in delta['added']}and changed=={r['uuid']for r in delta['mutated']}
sys.path.insert(0,str(Path('hardware/system-review/electrical/current-path-review').resolve()))
from inventory import NativeGraph,stackup
b=p.LoadBoard(str(dst));g=NativeGraph(b,stackup(dst.read_text()));rows=[]
for aa,bb in [('R504.1','RN501.1'),('R504.1','J501.1'),('R504.2','R505.1'),('R504.2','U502.7'),('R504.2','C504.1')]:
 r=g.witness(g.pad_index[aa][0],g.pad_index[bb][0]);assert r['status']=='explicit_native_witness';rows.append(dict(source=aa,target=bb,**r))
drc=json.load(open(D/'candidate3/drc.json'));assert not drc['violations']and not drc['unconnected_items']and not drc['schematic_parity']
v=json.load(open(D/'candidate3/via-assembly.json'));assert v['all_checks_pass']and v['board_sha256']==sha(dst)
out=dict(status='passed_digitally_for_isolated_R504_delta_pending_merged_CAD_and_COPower_checks',source_sha256=sha(src),candidate_sha256=sha(dst),script_sha256=sha(Path(__file__)),unchanged_other_footprints=unchanged,same_value_package=True,removed_uuids=sorted(removed),added_uuids=sorted(added),changed_uuids=sorted(changed),physical_witnesses=rows,drc_sha256=sha(D/'candidate3/drc.json'),via_audit_sha256=sha(D/'candidate3/via-assembly.json'),limits=['No canonical board mutation','Final merged CO/C103/C107 copper not represented here','New rear-side body must clear enclosure and service volumes','No thermal or gas-accuracy qualification'])
(D/'candidate3/scope-and-witnesses.json').write_text(json.dumps(out,indent=2)+'\n');shutil.copy2(D/'candidate-delta.json',D/'candidate3/delta.json');shutil.copy2(D/'candidate.py',D/'candidate3/builder.py')
print(dict(status=out['status'],footprints_unchanged=len(unchanged),physical_witnesses=len(rows),removed=len(removed),added=len(added),changed=len(changed)))
