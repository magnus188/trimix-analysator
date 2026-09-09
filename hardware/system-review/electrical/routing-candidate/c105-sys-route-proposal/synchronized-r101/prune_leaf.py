from pathlib import Path
import pcbnew as p,hashlib,json,shutil
from island_targets import connected_track_targets
D=Path(__file__).resolve().parent;O=D/'complete-candidate';P=O/'Trimix_Analyzer.kicad_pcb';H='4baa7c3bf073e2202612c4ed2eb525e019bf30b2c21b2c3c782e5f822d2cfb3e'
assert hashlib.sha256(P.read_bytes()).hexdigest()==H
b=p.LoadBoard(str(P));uid='13c916da-d379-489a-b013-f3538b34d9f4';t=next(t for t in b.GetTracks()if t.m_Uuid.AsString()==uid);assert t.GetNetname()=='CHG_INT_N'
xy=lambda q:[p.ToMM(q.x),p.ToMM(q.y)]
contacts=[]
for q in list(b.GetTracks())+[a for f in b.GetFootprints()for a in f.Pads()]:
 if q.m_Uuid.AsString()==uid or q.GetNetname()!='CHG_INT_N'or not q.IsOnLayer(p.In2_Cu):continue
 if q.GetEffectiveShape(p.In2_Cu).Collide(t.GetEffectiveShape(p.In2_Cu),0):contacts.append({'uuid':q.m_Uuid.AsString(),'start':xy(q.GetStart()),'end':xy(q.GetEnd()),'touches_leaf_start':q.GetEffectiveShape(p.In2_Cu).Collide(t.GetStart(),0),'touches_leaf_end':q.GetEffectiveShape(p.In2_Cu).Collide(t.GetEnd(),0)})
assert xy(t.GetStart())==[11.85,87.4]and xy(t.GetEnd())==[12.1659,87.2159]
assert contacts and not any(c['touches_leaf_start']for c in contacts)and all(c['touches_leaf_end']for c in contacts),contacts
_,before=connected_track_targets(b,'CHG_INT_N','0e4a678b-3cca-451f-97dc-36f6f7bc6e0c',(0,0,30,99))
b.Remove(t)
_,after=connected_track_targets(b,'CHG_INT_N','0e4a678b-3cca-451f-97dc-36f6f7bc6e0c',(0,0,30,99))
assert set(before['connected_object_uuids'])-{uid}==set(after['connected_object_uuids'])
shutil.copy2(P,D/'complete-unpruned.kicad_pcb');shutil.copy2(D/'complete-drc.json',D/'complete-unpruned-drc.json');project=(O/'Trimix_Analyzer.kicad_pro').read_bytes();p.ZONE_FILLER(b).Fill(b.Zones());p.SaveBoard(str(P),b);(O/'Trimix_Analyzer.kicad_pro').write_bytes(project)
out={'source_sha256':H,'candidate_sha256':hashlib.sha256(P.read_bytes()).hexdigest(),'removed_uuid':uid,'native_endpoint_contacts':contacts,'remaining_CHG_component_unchanged':True,'before_connected_objects':len(before['connected_object_uuids']),'after_connected_objects':len(after['connected_object_uuids']),'status':'DEGREE_ONE_LEAF_PRUNED_NATIVE_DRC_PENDING','release':False};(D/'leaf-pruning-witness.json').write_text(json.dumps(out,indent=2)+'\n');print(json.dumps(out,indent=2))
