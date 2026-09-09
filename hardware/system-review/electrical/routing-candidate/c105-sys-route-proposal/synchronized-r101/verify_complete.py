"""Immutable, exact-item patch and native conservation checks; no PCB writes."""
from pathlib import Path
import sys,json,hashlib,collections
sys.path.append("/private/tmp/trimix-gerbonara-venv/lib/python3.14/site-packages")
sys.path.insert(0,str(Path.cwd()/'hardware/tools'))
from analyzer_sheet import sx,child as cc,children
import pcbnew as p
D=Path(__file__).resolve().parent;A=D/'before.kicad_pcb';B=D/'complete-candidate/Trimix_Analyzer.kicad_pcb';HA='f1c5f443cbd6cdf92e39e01fc7db374c30721b6e7945b3cdde3387e8cdff7432';HB='de594d8ef4db9489931fe091ba63d938a0d4a33f1bb0455e988433c3fefa95db'
def sha(f):return hashlib.sha256(f.read_bytes()).hexdigest()
def child(q,k,d=None):
 v=cc(q,k);return d if v is None else v
assert(sha(A),sha(B))==(HA,HB)
a,b=map(lambda f:sx.loads(f.read_text()),[A,B])
def byid(doc,tags):return{child(q,'uuid')[1]:q for k in tags for q in children(doc,k)}
o,n=byid(a,['segment','via']),byid(b,['segment','via']);removed=set(o)-set(n);added=set(n)-set(o);modified={u for u in o.keys()&n.keys()if o[u]!=n[u]};assert not modified,modified
assert len(removed)==11 and len(added)==29,(len(removed),len(added))
assert byid(a,['footprint'])==byid(b,['footprint']),'Footprint metadata/geometry changed'
for key in ['general','layers','setup','gr_line','gr_arc','gr_rect','gr_poly','dimension']:assert children(a,key)==children(b,key),key
strip=lambda doc:[[q for q in z if not isinstance(q,list)or str(q[0])not in['filled_polygon','fill_segments','filled_areas_thickness']]for z in children(doc,'zone')]
assert strip(a)==strip(b),'zone definitions changed'
allowed={'VSYS','CHG_INT_N','USB_OVP_SET','/01  CHARGING + BATTERY/CHG_CE_N'}
assert all(child(q,'net')[1]in allowed for q in [*[o[u]for u in removed],*[n[u]for u in added]])
assert all(child(n[u],'layer',[None,None])[1]!='In1.Cu'for u in added if str(n[u][0])=='segment')
source_manifest=json.loads((D/'source-manifest.json').read_text())
for rel,h in source_manifest['inputs_sha256'].items():
 if rel.endswith('.kicad_pcb'):continue
 assert sha(D/rel)==h and sha(D/'complete-candidate'/rel)==h,rel
bb=p.LoadBoard(str(B));vias=[];hits=[];signature={}
for t in bb.GetTracks():
 u=t.m_Uuid.AsString()
 if u not in added:continue
 xy=lambda q:[p.ToMM(q.x),p.ToMM(q.y)]
 r={'uuid':u,'type':'via'if isinstance(t,p.PCB_VIA)else'segment','net':t.GetNetname()}
 if isinstance(t,p.PCB_VIA):
  r.update(at=xy(t.GetPosition()),diameter_mm=p.ToMM(t.GetWidth(p.F_Cu)),drill_mm=p.ToMM(t.GetDrillValue()));assert(r['diameter_mm'],r['drill_mm'])==(.5,.25);assert r['net']!='VSYS'
  for f in bb.GetFootprints():
   for pad in f.Pads():
    for L in[p.F_Cu,p.B_Cu]:
     if pad.IsOnLayer(L)and pad.GetEffectiveShape(L).Collide(t.GetPosition(),p.FromMM(.300001)):hits.append([u,f.GetReference(),pad.GetNumber(),bb.GetLayerName(L)])
  vias.append(r)
 else:r.update(start=xy(t.GetStart()),end=xy(t.GetEnd()),width_mm=p.ToMM(t.GetWidth()),layer=bb.GetLayerName(t.GetLayer()));assert r['width_mm']==(.4 if r['net']=='VSYS'else .15)
 signature[u]=r
assert not hits,hits
old=json.loads((D/'before-drc.json').read_text());new=json.loads((D/'final-drc.json').read_text())
def isig(x):return(x['type'],x['severity'],x['description'],tuple(sorted(i.get('uuid','')for i in x['items'])))
assert set(map(isig,new['violations']))==set(map(isig,old['violations']))
assert new['schematic_parity']==old['schematic_parity']and len(new['schematic_parity'])==2
assert len(new['unconnected_items'])==len(old['unconnected_items'])-1==6
patch=[sx.Symbol('c105_sys_route_patch'),[sx.Symbol('remove')]+[o[u]for u in sorted(removed)],[sx.Symbol('add')]+[n[u]for u in sorted(added)],[sx.Symbol('replace_footprints')]]
(D/'route-patch.kicad_sexpr').write_text(sx.dumps(patch)+'\n')
out={'status':'NATIVE_GEOMETRY_PASS_NOT_ORDER_RELEASE','before_board':str(A.resolve()),'after_board':str(B.resolve()),'before_sha256':HA,'after_sha256':HB,'removed_uuids':sorted(removed),'added_uuids':sorted(added),'modified_existing_uuids':[],'removed_items':{u:sx.dumps(o[u])for u in sorted(removed)},'added_items':[signature[u]for u in sorted(added)],'footprint_changes':[],'unchanged_all_footprints_pads_nets':True,'unchanged_outline_stackup_zone_definitions_rules':True,'source_project_library_hashes_preserved':True,'new_vias':vias,'new_via_all_SMT_PTH_land_plus_005mm_violations':hits,'before_drc':{'unconnected':7,'warnings':dict(collections.Counter(x['type']for x in old['violations'])),'parity':2},'after_drc':{'unconnected':6,'warnings':dict(collections.Counter(x['type']for x in new['violations'])),'parity':2,'same_full_warning_and_parity_signatures':True},'native_DRC_sha256':sha(D/'final-drc.json'),'patch_sha256':sha(D/'route-patch.kicad_sexpr'),'reservation':'No new copper enters x15.7..18.5/y89.3..91 plus0.20mm clearance (C116/CC owner).','integration':'Check each removed raw node and absence of added UUIDs against owner board, apply only this delta, preserve unrelated newer changes, refill and rerun native checks.','limits':['Two existing R101 package/MPN parity differences remain pending authoritative adoption; raw failures are retained.','Six logical routing connections remain unfinished.','Ground and trace/barrel sensitivity reviews are separate source-bound receipts; no thermal/current/manufacturing approval.'],'release':False}
(D/'candidate-delta.json').write_text(json.dumps(out,indent=2)+'\n');print(json.dumps({k:out[k]for k in['status','before_sha256','after_sha256','before_drc','after_drc']},indent=2))
assert(sha(A),sha(B))==(HA,HB)
