from pathlib import Path
import pcbnew as p,json
D=Path(__file__).resolve().parent;OUT=D/'candidate';path=OUT/'Trimix_Analyzer.kicad_pcb';b=p.LoadBoard(str(path));f=next(f for f in b.GetFootprints()if f.GetReference()=='C107')
for q in f.GetFields():q.SetVisible(False)
f.Value().SetText('47uF / 10V X5R');f.Reference().SetVisible(False)
removed=[]
for t in list(b.GetTracks()):
 if t.m_Uuid.AsString()=='65de2131-f4a0-4d16-a224-ebeb297b275a':removed.append(t.m_Uuid.AsString());b.Remove(t)
p.SaveBoard(str(path),b)
(OUT/'cleanup.json').write_text(json.dumps({'removed_prior_via_confirmed_dangling_by_native':removed,'C107_reference':'assembly-map-only in isolated trial; owner will apply final marking layout','production_unchanged':True},indent=2)+'\n')
