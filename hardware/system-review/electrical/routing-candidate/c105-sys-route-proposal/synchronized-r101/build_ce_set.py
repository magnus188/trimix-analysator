import route_context as c
import apply_ce
import json,hashlib
D=c.OUT;b=c.b;p=c.p
setr=json.loads((D/'set-scout/proposal.json').read_text());assert setr['source_sha256']==c.EXPECTED
lookup={t.m_Uuid.AsString():t for t in b.GetTracks()};removed=[]
for uid in setr['removed_SET_uuids']:
 assert lookup[uid].GetNetname()=='USB_OVP_SET';removed.append(lookup[uid]);b.Remove(lookup[uid])
for row in setr['added']:
 assert row['type']=='segment'and row['net']=='USB_OVP_SET'
 c.track(row['net'],[row['start'],row['end']],b.GetLayerID(row['layer']),width=row['width_mm']);t=next(t for t in b.GetTracks()if t.m_Uuid.AsString()==c.added[-1]['uuid']);t.SetUuid(p.KIID(row['uuid']));c.added[-1]['uuid']=row['uuid']
ids={r['uuid']for r in c.added};errors=[]
for t in list(b.GetTracks()):
 if t.m_Uuid.AsString()not in ids:continue
 for L in[p.F_Cu,p.In1_Cu,p.In2_Cu,p.B_Cu]:
  if not t.IsOnLayer(L):continue
  s=t.GetEffectiveShape(L)
  for q in list(b.GetTracks())+[a for f in b.GetFootprints()for a in f.Pads()]:
   if not q.IsOnLayer(L)or q.GetNetname()==t.GetNetname():continue
   if q.GetEffectiveShape(L).Collide(s,p.FromMM(.2)):errors.append([t.m_Uuid.AsString(),q.m_Uuid.AsString(),q.GetNetname(),L])
assert not errors,errors
project=(D/'Trimix_Analyzer.kicad_pro').read_bytes();before_hash=hashlib.sha256(c.P.read_bytes()).hexdigest();p.ZONE_FILLER(b).Fill(b.Zones());p.SaveBoard(str(D/'Trimix_Analyzer.kicad_pcb'),b);(D/'Trimix_Analyzer.kicad_pro').write_bytes(project)
assert hashlib.sha256(c.P.read_bytes()).hexdigest()==before_hash==c.EXPECTED
(D/'ce-set-stage.json').write_text(json.dumps({'status':'SAVED_COMBINED_NATIVE_DRC_PENDING','source_sha256':c.EXPECTED,'candidate_sha256':hashlib.sha256((D/'Trimix_Analyzer.kicad_pcb').read_bytes()).hexdigest(),'added':c.added,'removed_CE_uuids':json.loads((D/'ce-applied-guard.json').read_text())['removed_uuids'],'removed_SET_uuids':setr['removed_SET_uuids'],'native_foreign_clearance_guard_pass':True,'project_sha256':hashlib.sha256(project).hexdigest(),'release':False},indent=2)+'\n')
print('savedCE+SET',hashlib.sha256((D/'Trimix_Analyzer.kicad_pcb').read_bytes()).hexdigest(),flush=True)
