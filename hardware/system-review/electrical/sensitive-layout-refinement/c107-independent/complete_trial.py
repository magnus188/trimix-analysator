import build_bridge as c,json,hashlib,shutil
p=c.p;b=c.b
q=p.PCB_VIA(b);q.SetPosition(c.vec((16.05,78.05)));q.SetWidth(p.FromMM(.5));q.SetDrill(p.FromMM(.25));q.SetViaType(p.VIATYPE_THROUGH);q.SetLayerPair(p.F_Cu,p.B_Cu);q.SetNetCode(b.GetNetsByName()['GND'].GetNetCode());b.Add(q)
c.track('GND',[(15.225,79),(16.05,78.05)],p.B_Cu,.25)
# Keep the old empty C107 traces visible for now, so pruning cannot hide a missing endpoint.
p.SaveBoard(str(c.OUT/'Trimix_Analyzer.kicad_pcb'),b)
for suffix in ['.kicad_pro','.kicad_dru']:shutil.copy2('hardware/pcb/analyzer/Trimix_Analyzer'+suffix,c.OUT/('Trimix_Analyzer'+suffix))
(c.OUT/'complete-trial.json').write_text(json.dumps(dict(status='pending_native_DRC',source_sha256=hashlib.sha256((c.OUT.parent/'source.kicad_pcb').read_bytes()).hexdigest(),board_sha256=hashlib.sha256((c.OUT/'Trimix_Analyzer.kicad_pcb').read_bytes()).hexdigest(),new_GND_via_uuid=q.m_Uuid.AsString(),new_GND_via=[16.05,78.05,.5,.25],cap_pose=[13.75,79,0],side='B.Cu',MPN='C3216X5R1E226M160AB',removed_PACK_uuid='dcf3adfc-98b6-4b63-9e3c-1e074a51d2df',not_adopted=True),indent=2)+'\n')
