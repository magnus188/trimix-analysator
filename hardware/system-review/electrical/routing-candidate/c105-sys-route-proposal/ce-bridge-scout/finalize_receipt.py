"""Bind native saved candidate, exact source conservation, project and full DRC."""
import build_candidate as c
from collections import Counter
from datetime import datetime,timezone
def canonical(row):return (row.get('type'),row.get('severity'),row.get('description'),tuple(sorted(i.get('uuid','')for i in row.get('items',[]))))
def main():
 delta=c.json.loads((c.D/'candidate-delta.json').read_text());before=c.p.LoadBoard(str(c.SRC/'before.kicad_pcb'));after=c.p.LoadBoard(str(c.OUT/'Trimix_Analyzer.kicad_pcb'))
 a={t.m_Uuid.AsString():c.signature(t)for t in before.GetTracks()};b={t.m_Uuid.AsString():c.signature(t)for t in after.GetTracks()}
 assert set(a)-set(b)==set(delta['removed_items'])and set(b)-set(a)==set(delta['added_items'])
 assert all(a[u]==b[u]for u in a.keys()&b.keys())and c.poses(before)==c.poses(after)
 for q,h in delta['source_inputs'].items():
  path=c.Path(q);assert c.sha(path)==h
  if path.name!='before.kicad_pcb':assert c.sha(c.OUT/path.relative_to(c.SRC.resolve()))==h
 pre=c.json.loads((c.SRC/'before-drc.json').read_text());post=c.json.loads((c.OUT/'drc.json').read_text())
 assert {'error','warning'}<=set(post['included_severities']) and post['included_severities']==pre['included_severities'] and post['ignored_checks']==pre['ignored_checks']
 assert Counter(map(canonical,pre['violations']))==Counter(map(canonical,post['violations']))
 assert Counter(map(canonical,pre['unconnected_items']))==Counter(map(canonical,post['unconnected_items']))
 assert pre['schematic_parity']==post['schematic_parity']==[]
 delta.setdefault('pre_cli_save_candidate_sha256',delta['candidate_sha256']);delta['candidate_sha256']=c.sha(c.OUT/'Trimix_Analyzer.kicad_pcb');delta['status']='PASS_CE_ONLY_NATIVE_DRC_NO_NEW_VIOLATIONS';delta['native_cli_refill_and_save']=True;delta['native_drc_sha256']=c.sha(c.OUT/'drc.json')
 (c.D/'candidate-delta.json').write_text(c.json.dumps(delta,indent=2)+'\n')
 r={'created_utc':datetime.now(timezone.utc).isoformat(),'status':delta['status'],'source_sha256':c.EXPECTED,'candidate_sha256':delta['candidate_sha256'],'candidate_path':str((c.OUT/'Trimix_Analyzer.kicad_pcb').resolve()),'native_DRC_sha256':delta['native_drc_sha256'],'native_DRC_date':post['date'],'native_kicad_version':post['kicad_version'],'included_severities':post['included_severities'],'ignored_checks':post['ignored_checks'],'violation_counts':dict(Counter(v['type']for v in post['violations'])),'severity_counts':dict(Counter(v['severity']for v in post['violations'])),'unconnected_items':len(post['unconnected_items']),'schematic_parity_items':0,'same_full_violation_and_unconnected_signatures_as_baseline':True,'source_project_and_library_hashes_unchanged':True,'copied_project_and_library_hashes_match':True,'all_footprint_and_pad_poses_nets_unchanged':True,'all_retained_tracks_unchanged':True,'removed_tracks':5,'new_tracks':3,'new_ordinary_vias':1,'hypothetical_SYS_tracks_added':False,'geometric_candidate_only':True,'release':False,'diagnostic_report':'candidate/drc-invalid-default-project.json is retained but invalid as a final DRC gate; first SaveBoard changed the copied project to defaults. Exact project restored for the accepted run.','artifact_hashes':{str(p.relative_to(c.D)):c.sha(p)for p in sorted(c.D.rglob('*'))if p.is_file()and p.name!='receipt.json' and '__pycache__'not in p.parts}}
 (c.D/'receipt.json').write_text(c.json.dumps(r,indent=2)+'\n');print(r['status'],r['candidate_sha256'],r['violation_counts'])
if __name__=='__main__':main()
