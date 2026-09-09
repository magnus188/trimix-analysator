"""Build only the root-authorized isolated CE candidate; source files are immutable."""
from pathlib import Path
import hashlib,json,uuid,shutil
import pcbnew as p
D=Path(__file__).resolve().parent;SRC=D.parent;OUT=D/'candidate';OUT.mkdir(exist_ok=True)
EXPECTED='609a6241ce50cbe3d40f7a1676c455092db583875895eeb8236083bf2c5f0ef1'
def sha(path):return hashlib.sha256(path.read_bytes()).hexdigest()
def xy(q):return [p.ToMM(q.x),p.ToMM(q.y)]
def v(q):return p.VECTOR2I(p.FromMM(q[0]),p.FromMM(q[1]))
def signature(t):
 r={'type':type(t).__name__,'net':t.GetNetname(),'start':xy(t.GetStart()),'end':xy(t.GetEnd())}
 if isinstance(t,p.PCB_VIA):r.update(diameter_mm=p.ToMM(t.GetWidth(p.F_Cu)),drill_mm=p.ToMM(t.GetDrillValue()),layers=[p.LayerName(L)for L in [p.F_Cu,p.In1_Cu,p.In2_Cu,p.B_Cu]if t.IsOnLayer(L)])
 else:r.update(layer=p.LayerName(t.GetLayer()),width_mm=p.ToMM(t.GetWidth()))
 return r
def poses(b):return {f.m_Uuid.AsString():{'ref':f.GetReference(),'position':xy(f.GetPosition()),'orientation_degrees':f.GetOrientationDegrees(),'layer':f.GetLayer(),'pads':{q.m_Uuid.AsString():{'pin':q.GetNumber(),'net':q.GetNetname(),'position':xy(q.GetPosition()),'size':xy(q.GetSize()),'orientation_degrees':q.GetOrientationDegrees()}for q in f.Pads()}}for f in b.GetFootprints()}
def main():
 source=SRC/'before.kicad_pcb';assert sha(source)==EXPECTED
 verified=json.loads((D/'verified-detour.json').read_text());assert verified['source_sha256']==EXPECTED
 inputs={source:EXPECTED}
 project_files=[q for q in SRC.rglob('*')if q.is_file()and D not in q.parents and(q.suffix in ['.kicad_sch','.kicad_pro','.kicad_sym','.kicad_dru','.kicad_mod']or q.name in ['sym-lib-table','fp-lib-table'])]
 for q in project_files:
  inputs[q]=sha(q);dest=OUT/q.relative_to(SRC);dest.parent.mkdir(parents=True,exist_ok=True);shutil.copyfile(q,dest);assert sha(dest)==inputs[q]
 target=OUT/'Trimix_Analyzer.kicad_pcb';shutil.copyfile(source,target)
 b=p.LoadBoard(str(target));before={t.m_Uuid.AsString():signature(t)for t in b.GetTracks()};before_poses=poses(b)
 lookup={t.m_Uuid.AsString():t for t in b.GetTracks()};net=lookup[verified['removed_track_uuids'][0]].GetNetCode()
 for uid in verified['removed_track_uuids']:b.Remove(lookup[uid])
 for i,row in enumerate(verified['segments']):
  tr=p.PCB_TRACK(b);tr.SetStart(v(row['start_mm']));tr.SetEnd(v(row['end_mm']));tr.SetLayer(b.GetLayerID(row['layer']));tr.SetWidth(p.FromMM(.15));tr.SetNetCode(net);tr.SetUuid(p.KIID(str(uuid.uuid5(uuid.NAMESPACE_URL,'trimix-609-ce-detour-track-'+str(i)))));b.Add(tr)
 via=p.PCB_VIA(b);via.SetPosition(v(verified['via']['position_mm']));via.SetWidth(p.FromMM(.5));via.SetDrill(p.FromMM(.25));via.SetLayerPair(p.F_Cu,p.B_Cu);via.SetViaType(p.VIATYPE_THROUGH);via.SetNetCode(net);via.SetUuid(p.KIID(str(uuid.uuid5(uuid.NAMESPACE_URL,'trimix-609-ce-detour-via'))));b.Add(via)
 assert poses(b)==before_poses
 filler=p.ZONE_FILLER(b);filler.Fill(b.Zones());p.SaveBoard(str(target),b)
 # pcbnew can serialize default project settings during SaveBoard; restore the
 # exact frozen project tree before native CLI verification.
 for q in project_files:shutil.copyfile(q,OUT/q.relative_to(SRC));assert sha(OUT/q.relative_to(SRC))==inputs[q]
 reloaded=p.LoadBoard(str(target));after={t.m_Uuid.AsString():signature(t)for t in reloaded.GetTracks()}
 removed=before.keys()-after.keys();added=after.keys()-before.keys();modified=[u for u in before.keys()&after.keys()if before[u]!=after[u]]
 assert set(removed)==set(verified['removed_track_uuids'])and len(added)==4 and not modified
 assert poses(reloaded)==before_poses and all(sha(q)==h for q,h in inputs.items())
 result={'status':'ISOLATED_CE_ONLY_BUILT_DRC_PENDING','source_sha256':EXPECTED,'candidate_sha256':sha(target),'source_inputs':{str(q.resolve()):h for q,h in inputs.items()},'removed_items':{u:before[u]for u in sorted(removed)},'added_items':{u:after[u]for u in sorted(added)},'modified_retained_tracks':modified,'all_footprint_and_pad_poses_and_nets_unchanged':True,'retained_tracks_unchanged':True,'source_inputs_unchanged':True,'hypothetical_power_tracks_added':False,'native_fill_run':True,'board_path':str(target.resolve()),'release':False}
 (D/'candidate-delta.json').write_text(json.dumps(result,indent=2)+'\n');print('CANDIDATE',result['candidate_sha256'],'removed',len(removed),'added',len(added),'project_files',len(project_files),flush=True)
if __name__=='__main__':main()
