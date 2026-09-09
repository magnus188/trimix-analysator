import route_context as c
import json,hashlib,uuid
D=c.OUT;p=c.p;b=c.b
old=json.loads((D.parent/'ce-bridge-scout/candidate-delta.json').read_text());lookup={t.m_Uuid.AsString():t for t in b.GetTracks()}
def sig(t):
 d={'type':type(t).__name__,'net':t.GetNetname(),'start':c.xy(t.GetStart()),'end':c.xy(t.GetEnd())}
 if isinstance(t,p.PCB_VIA):d.update(diameter_mm=p.ToMM(t.GetWidth(p.F_Cu)),drill_mm=p.ToMM(t.GetDrillValue()),layers=[p.LayerName(L)for L in[p.F_Cu,p.In1_Cu,p.In2_Cu,p.B_Cu]if t.IsOnLayer(L)])
 else:d.update(layer=p.LayerName(t.GetLayer()),width_mm=p.ToMM(t.GetWidth()))
 return d
removed=[]
for u,row in old['removed_items'].items():
 assert u in lookup and sig(lookup[u])==row,(u,sig(lookup[u])if u in lookup else None,row)
 removed.append(lookup[u]);b.Remove(lookup[u])
for u,row in old['added_items'].items():
 assert u not in lookup
 if row['type']=='PCB_VIA':c.via(row['net'],row['start'],d=row['diameter_mm'],h=row['drill_mm'])
 else:c.track(row['net'],[row['start'],row['end']],b.GetLayerID(row['layer']),width=row['width_mm'])
 t=next(t for t in b.GetTracks()if t.m_Uuid.AsString()==c.added[-1]['uuid']);t.SetUuid(p.KIID(u));c.added[-1]['uuid']=u
# Refuse geometry clashes introduced by the CE patch against this new source.
new=[t for t in b.GetTracks()if t.m_Uuid.AsString()in old['added_items']]
for t in new:
 for L in[p.F_Cu,p.In1_Cu,p.In2_Cu,p.B_Cu]:
  if not t.IsOnLayer(L):continue
  s=t.GetEffectiveShape(L)
  for q in list(b.GetTracks())+[a for f in b.GetFootprints()for a in f.Pads()]:
   if not q.IsOnLayer(L)or q.GetNetname()==t.GetNetname():continue
   assert not q.GetEffectiveShape(L).Collide(s,p.FromMM(.2)),(t.m_Uuid.AsString(),q.m_Uuid.AsString(),q.GetNetname(),L)
(D/'ce-applied-guard.json').write_text(json.dumps({'source_sha256':c.EXPECTED,'old_delta_source':old['source_sha256'],'old_CE_all_removed_signatures_match':True,'added_CE_native_foreign_clearance_pass':True,'removed_uuids':sorted(old['removed_items']),'added':c.added,'reserved_box_mm':[15.7,89.3,18.5,91],'native_DRC_pending':True},indent=2)+'\n')
print('CE guarded apply passes',len(removed),len(new),flush=True)
if __name__=='__main__':
 project=(D/'Trimix_Analyzer.kicad_pro').read_bytes();p.SaveBoard(str(D/'ce-baseline.kicad_pcb'),b);(D/'Trimix_Analyzer.kicad_pro').write_bytes(project);(D/'ce-baseline.kicad_pro').write_bytes(project)
 print('CEbaseline',hashlib.sha256((D/'ce-baseline.kicad_pcb').read_bytes()).hexdigest())
