from pathlib import Path
import pcbnew as p,shutil,json,hashlib
D=Path(__file__).resolve().parent;B=D/'before-check';source=D/'before.kicad_pcb';dest=B/'Trimix_Analyzer.kicad_pcb'
# The baseline includes an accepted trace jog; refill its planes before DRC.
shutil.copy2(source,dest);b=p.LoadBoard(str(dest));b.GetDesignSettings().m_TrackMinWidth=p.FromMM(.15);p.ZONE_FILLER(b).Fill(b.Zones());p.SaveBoard(str(dest),b)
shutil.copy2(D/'frozen-project.json',B/'Trimix_Analyzer.kicad_pro')
(D/'baseline-fill-receipt.json').write_text(json.dumps({'source_sha256':hashlib.sha256(source.read_bytes()).hexdigest(),'filled_native_sha256':hashlib.sha256(dest.read_bytes()).hexdigest(),'purpose':'Refill the accepted HOST jog on the coordinated placement before baseline DRC; source copper/poses/nets are not edited.','original_unfilled_report':'before-stale-fill-drc.json'},indent=2)+'\n')
