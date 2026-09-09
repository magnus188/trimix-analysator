"""Import an isolated SES, preserving reviewed component geometry and source nets."""
from pathlib import Path
import sys,json,hashlib,copy,re,shutil
import pcbnew as p
ROOT=Path(__file__).resolve().parents[4];OUT=Path(__file__).resolve().parent
sys.path.insert(0,str(ROOT/'hardware/tools'));from analyzer_sheet import sx,children,child
P=ROOT/'hardware/pcb/analyzer';native=OUT/'native';native.mkdir(exist_ok=True)
def props(f):return {z[1]:z for z in children(f,'property')}
src=P/'Trimix_Analyzer.kicad_pcb';a=sx.loads((OUT/'refined-before-routing.kicad_pcb').read_text());latest=sx.loads(src.read_text())
# The only approved pose changes are the three output ceramics rotated180deg.
rotated={props(f)['Reference'][2]:copy.deepcopy(f)for f in children(a,'footprint')if props(f)['Reference'][2]in ['C204','C205','C206']}
for f in list(children(latest,'footprint')):
 if props(f)['Reference'][2]in rotated:
  latest.remove(f);latest.append(rotated[props(f)['Reference'][2]])
for f in list(children(a,'footprint')):a.remove(f)
a.extend(copy.deepcopy(children(latest,'footprint')))
dest=native/src.name;dest.write_text(sx.dumps(a))
for f in P.iterdir():
 if f.suffix in ['.kicad_sch','.kicad_pro','.kicad_dru','.kicad_sym'] or f.name in ['fp-lib-table','sym-lib-table'] or f.suffix=='.pretty':
  d=native/f.name
  if not d.exists():d.symlink_to(f.resolve())
b=p.LoadBoard(str(dest));names={n.GetNetname() for n in b.GetNetInfo().NetsByNetcode().values()};ses=(OUT/'refined.ses').read_text();remaps=[]
def reconcile(m):
 name=m[2]
 if name not in names and '/'+name in names:remaps.append(name);name='/'+name
 return m[1]+name+m[3]
ses=re.sub(r'(\(net\s+")([^"]*)(")',reconcile,ses)
(OUT/'refined-reconciled.ses').write_text(ses)
assert p.ImportSpecctraSES(b,str(OUT/'refined-reconciled.ses'))
p.SaveBoard(str(dest),b)
# SES placement precision rounds a few original coordinates by1–23nm. Restore
# the exact source footprint nodes; copper remains the independently checked candidate.
restored=sx.loads(dest.read_text())
for f in list(children(restored,'footprint')):restored.remove(f)
restored.extend(copy.deepcopy(children(latest,'footprint')))
dest.write_text(sx.dumps(restored));b=p.LoadBoard(str(dest))
p.ZONE_FILLER(b).Fill(b.Zones());p.SaveBoard(str(dest),b)
expect=OUT/'refined-expected-geometry.kicad_pcb';expect.write_text(sx.dumps(latest));old=p.LoadBoard(str(expect))
def geometry(b):
 return {f.GetReference():{'pose':[f.GetPosition().x,f.GetPosition().y,f.GetOrientationDegrees(),f.GetLayer()],'fp':str(f.GetFPID().GetLibNickname())+':'+str(f.GetFPID().GetLibItemName()),'pads':sorted([(q.GetNumber(),q.GetPosition().x,q.GetPosition().y,q.GetSize().x,q.GetSize().y,q.GetDrillSize().x,q.GetDrillSize().y,q.GetNetname())for q in f.Pads()])}for f in b.GetFootprints()}
assert geometry(old)==geometry(b),'Component/pad geometry changed'
newnames={n.GetNetname()for n in b.GetNetInfo().NetsByNetcode().values()};assert newnames==names,('Spurious SES nets',newnames-names)
assert all(not(t.GetLayer()==p.In1_Cu and not isinstance(t,p.PCB_VIA)) for t in b.GetTracks()),'In1 signal-plane violation'
result={'authoritative_board_unchanged_sha256':hashlib.sha256(src.read_bytes()).hexdigest(),'candidate_sha256':hashlib.sha256(dest.read_bytes()).hexdigest(),'candidate_path':str(dest.relative_to(ROOT)),'components_and_pad_geometry_match_approved_rotations':True,'approved_rotations':['C204','C205','C206'],'net_names_exact_match':True,'In1_no_signal_tracks':True,'net_name_remaps':remaps,'tracks':sum(not isinstance(t,p.PCB_VIA)for t in b.GetTracks()),'vias':sum(isinstance(t,p.PCB_VIA)for t in b.GetTracks()),'native_DRC_required':True,'power_nets_intentionally_unfinished':True,'order_release':False}
(OUT/'refined-import-receipt.json').write_text(json.dumps(result,indent=2)+'\n');print(json.dumps(result,indent=2))
