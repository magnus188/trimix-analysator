"""Read-only serialized scope, electrical assignment and native clearance audit."""
from pathlib import Path
import collections, copy, hashlib, json, sys, xml.etree.ElementTree as ET
import pcbnew as p
import upgrade_calibration_pcb as build
BASE=Path(__file__).resolve().parents[1];OUT=BASE/'verification/software-calibration'
sys.path.insert(0,str(BASE/'verification/markings'))
import compare_annotations as a

def normalize(tree):
    t=copy.deepcopy(tree)
    def walk(n):
        if not isinstance(n,list):return
        if n and n[0]=='net' and len(n)==3:n[1]='CODE_BY_NAME'
        for q in n:walk(q)
    walk(t);return t

def run(path):
    before=a.parse(build.BEFORE);after=a.parse(path)
    normal_before,normal_after=normalize(before),normalize(after)
    for tree in (normal_before,normal_after):
        for f in tree[1:]:
            if not isinstance(f,list)or f[0]!='footprint':continue
            ref=a.ref(f)
            if ref in build.MOVED:
                for q in f[2:]:
                    if not isinstance(q,list):continue
                    if q[0]=='at':q[:]=['at','POSE_SEPARATELY_REPORTED']
                    if q[0] in ('pad','property'):
                        at=next((x for x in q if isinstance(x,list)and x[0]=='at'),None)
                        if at is not None:at[:]=at[:3]
    pa,_=a.protected(normal_before);pb,_=a.protected(normal_after)
    deltas={}
    for r in set(pa['footprints'])|set(pb['footprints']):
        if r in build.CHANGED|build.DELETED:continue
        if pa['footprints'][r]!=pb['footprints'][r]:deltas[r]=[pa['footprints'][r],pb['footprints'][r]]
    ac,bc=map(collections.Counter,(pa['board_nodes'],pb['board_nodes']))
    removed=list((ac-bc).elements());added=list((bc-ac).elements())
    unexpected_added=[n for n in added if json.loads(n)[0]!='net']
    if deltas or removed or unexpected_added:raise RuntimeError(json.dumps({'footprints':deltas,'removed_board':removed,'added_board':unexpected_added}))
    assert set(pa['footprints'])-set(pb['footprints'])==build.DELETED
    assert set(pb['footprints'])-set(pa['footprints'])=={'RN501'}
    old=p.LoadBoard(str(build.BEFORE));b=p.LoadBoard(str(path))
    oldfp={f.GetReference():f for f in old.GetFootprints()};fp={f.GetReference():f for f in b.GetFootprints()}
    fixed=[r for r in fp if r not in build.CHANGED|build.MOVED]
    assert all(build.pose(fp[r])==build.pose(oldfp[r]) for r in fixed)
    assert all(fp[r].m_Uuid.AsString()==oldfp[r].m_Uuid.AsString()for r in fp if r!='RN501')
    expected={}
    for n in ET.parse(build.NETLIST).findall('./nets/net'):
        for v in n.findall('node'):
            if v.attrib['ref']in fp:expected[(v.attrib['ref'],v.attrib['pin'])]=n.attrib['name']
    assert build.netmap(b)==expected
    checks=build.geometry(b);assert checks['passed']
    assert b.GetCopperLayerCount()==4 and p.ToMM(b.GetDesignSettings().GetBoardThickness())==1.6 and len(b.GetTracks())==0
    result={'status':'passed_scope_pin_net_and_native_placement_checks','before_sha256':build.sha(build.BEFORE),'current_sha256':build.sha(path),'netlist_sha256':build.sha(build.NETLIST),'footprints':len(fp),'pad_net_assignments':len(expected),'changed_footprints':sorted(build.CHANGED),'deleted':sorted(build.DELETED),'relocated_passives':{r:build.pose(fp[r])for r in sorted(build.MOVED)},'fixed_connectors_and_mounts':{r:build.pose(fp[r])for r in fixed if r.startswith(('J','H'))},'all_unrelated_footprint_geometry_models_nets_and_outline_preserved':True,'existing_uuids_preserved':True,'geometry':checks,'tracks':0,'layers':4,'thickness_mm':1.6,'new_global_net_records':len(added),'main_project_sha256':build.sha(build.SOURCE.with_suffix('.kicad_pro'))}
    (OUT/'pcb-scope-audit.json').write_text(json.dumps(result,indent=2)+'\n');print(json.dumps(result))
if __name__=='__main__':run(Path(sys.argv[1]) if len(sys.argv)>1 else build.SOURCE)
