"""Freeze a guarded copper-only delta and native CC/SET continuity witnesses."""
from pathlib import Path
import hashlib,json,sys,collections
import sexpdata as s
D=Path(__file__).resolve().parent;O=D/'vippo-cc';A=D/'source-controls-overlay.kicad_pcb';B=O/'native-v3/Trimix_Analyzer.kicad_pcb'
ha='817a3f8c8ad51f40706cee62c9028a691af2ad19b233cdbb186b2b0de57e8ae9'
hb='d490110c6335a6594a8d2171386926c65a95e0f8ba729feb378c478e8a676a63'
sha=lambda q:hashlib.sha256(q.read_bytes()).hexdigest()
assert(sha(A),sha(B))==(ha,hb)
tag=lambda q:str(q[0])if isinstance(q,list)and q else''
child=lambda q,k:next((x for x in q if tag(x)==k),None)
byid=lambda d,tags:{child(q,'uuid')[1]:q for q in d if tag(q)in tags}
a,b=[s.loads(q.read_text())for q in (A,B)]
old,new=[byid(d,('segment','via'))for d in (a,b)]
removed=sorted(old.keys()-new.keys());added=sorted(new.keys()-old.keys())
modified=sorted(u for u in old.keys()&new.keys()if old[u]!=new[u])
assert len(removed)==4 and len(added)==5 and modified==['97221b3e-53ad-480c-bf50-4f989f070dbc']
assert byid(a,('footprint',))==byid(b,('footprint',))
for k in ('general','layers','setup','net','gr_line','gr_arc','gr_rect','gr_poly','dimension'):
    assert[q for q in a if tag(q)==k]==[q for q in b if tag(q)==k],k
strip=lambda d:[[x for x in z if tag(x)not in ('filled_polygon','fill_segments','filled_areas_thickness')]for z in d if tag(z)=='zone']
assert strip(a)==strip(b)
assert all(child(new[u],'layer')[1]!='In1.Cu'for u in added if tag(new[u])=='segment')
assert all(child(old[u],'net')[1]=='USB_CC_INT_N'for u in removed)
assert all(child(new[u],'net')[1]=='USB_CC_INT_N'for u in added)
drc=json.loads((O/'native-v3-drc.json').read_text())
geometry={'clearance','shorting_items','hole_clearance','solder_mask_bridge'}
known_ids={'551051f9-15ca-4e98-9e17-600b206e2b0c','8d04b12f-af6f-4f52-9518-3ae7d04d29aa','2e10c5dc-bd48-480c-b636-de00b00a6e8b'}
geom=[v for v in drc['violations']if v['severity']=='error']
assert all(v['type']in geometry and set(i['uuid']for i in v['items'])<=known_ids for v in geom)
assert len(geom)==4 and len(drc['unconnected_items'])==3 and not drc['schematic_parity']
patch=[s.Symbol('cc_vippo_copper_patch'),[s.Symbol('remove')]+[old[u]for u in removed],
       [s.Symbol('add')]+[new[u]for u in added],
       [s.Symbol('replace')]+[[s.Symbol('item'),[s.Symbol('before'),old[u]],[s.Symbol('after'),new[u]]]for u in modified]]
(O/'copper-patch.kicad_sexpr').write_text(s.dumps(patch)+'\n')
sys.path.insert(0,str(D.parents[1]/'current-path-review'))
from inventory import p,NativeGraph,stackup
board=p.LoadBoard(str(B));g=NativeGraph(board,stackup(B.read_text()));rows=[]
for left,right in [('U115.3','U113.3'),('U115.3','U110.6'),('U115.3','R111.2'),('U115.2','R122.2'),('U115.2','R123.1')]:
    for u in g.pad_index[left]:
        for v in g.pad_index[right]:
            w=g.witness(u,v);assert w['status']=='explicit_native_witness',(left,right,w)
            rows.append(dict(source=left,target=right,source_pad_uuid=u,target_pad_uuid=v,**w))
groups={}
for net in ('USB_CC_INT_N','USB_OVP_SET'):
    remaining={u for u,row in g.items.items()if row['net']==net};components=[]
    neighbours=collections.defaultdict(set)
    for u,v in g.native_pairs:neighbours[u].add(v);neighbours[v].add(u)
    while remaining:
        seen=set();todo=[next(iter(remaining))]
        while todo:
            u=todo.pop()
            if u in seen:continue
            seen.add(u);todo.extend(neighbours[u]&remaining-seen)
        remaining-=seen;components.append(sorted(seen))
    assert len(components)==1,(net,components)
    groups[net]={'connected_object_count':len(components[0]),'components':components}
receipt={'status':'SCOPED_CC_SET_NATIVE_PASS; COMBINED_SOURCE_STILL_HAS_KNOWN_C116_CHG_COLLISION',
    'before_board':str(A.resolve()),'after_board':str(B.resolve()),'before_sha256':ha,'after_sha256':hb,
    'removed_uuids':removed,'added_uuids':added,'modified_uuids':modified,
    'removed_items':{u:s.dumps(old[u])for u in removed},'added_items':{u:s.dumps(new[u])for u in added},
    'replaced_items':{u:{'before':s.dumps(old[u]),'after':s.dumps(new[u])}for u in modified},
    'all_footprints_pads_nets_outline_stackup_zone_definitions_unchanged':True,
    'R129_added':False,'no_In1_signal_tracks_added':True,
    'special_process':'One exact epoxy-filled copper-capped .40/.20 via, source-bound scoped mask/clearance rules required; factory approval pending',
    'rules_file':str((O/'native-v3/Trimix_Analyzer.kicad_dru').resolve()),'rules_sha256':sha(O/'native-v3/Trimix_Analyzer.kicad_dru'),
    'patch_sha256':sha(O/'copper-patch.kicad_sexpr'),'native_DRC_sha256':sha(O/'native-v3-drc.json'),
    'native_DRC':{'CC_SET_errors':0,'known_other_geometry_errors':geom,'unconnected':3,'parity':0},
    'native_witnesses':rows,'whole_net_native_components':groups,
    'integration':'Guard every removed/replaced original raw item and added UUID absence, append exact scoped rules, preserve unrelated edits, refill and run full native DRC/parity.',
    'limits':['This is a local routing/process proof, not a manufacturing or order release.',
        'Native graph excludes zones and internal device conduction; no equivalent resistance claim.',
        'Independent actual CAM/mask/drill controls and combined ground review are pending.'], 'release':False}
assert(sha(A),sha(B))==(ha,hb)
(O/'guarded-delta-and-witnesses.json').write_text(json.dumps(receipt,indent=2)+'\n')
print(json.dumps({'status':receipt['status'],'native_witnesses':len(rows),'whole_net_object_counts':{k:v['connected_object_count']for k,v in groups.items()},'patch_sha256':receipt['patch_sha256']},indent=2))
