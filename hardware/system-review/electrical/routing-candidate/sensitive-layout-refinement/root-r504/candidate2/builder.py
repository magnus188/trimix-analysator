"""Isolated same-package R504 rear trial. Full DRC is mandatory before handoff."""
from pathlib import Path
import pcbnew as p
import json,hashlib,shutil
D=Path(__file__).resolve().parent;root=Path.cwd();src=root/'hardware/pcb/analyzer/Trimix_Analyzer.kicad_pcb'
sha=hashlib.sha256(src.read_bytes()).hexdigest();assert sha=='9f274fdf198f1bcb871a4fc360e76693f8a5b048553e6a02998141737956514f'
out=D/'candidate2';out.mkdir(exist_ok=True)
for q in src.parent.iterdir():
 if q.suffix in ['.kicad_pro','.kicad_dru','.kicad_sch']:shutil.copy2(q,out/q.name)
b=p.LoadBoard(str(src));vec=lambda q:p.VECTOR2I(p.FromMM(q[0]),p.FromMM(q[1]));xy=lambda q:[p.ToMM(q.x),p.ToMM(q.y)]
f=next(f for f in b.GetFootprints()if f.GetReference()=='R504');f.Flip(f.GetPosition(),False);f.SetOrientationDegrees(180)
removed=[];added=[];mutated=[];dead={'54b7bc9f-e4cd-4b0b-9003-590e0153dba7','60490e6d-9dc3-40db-b8c2-c06eed5eef94','075fcbfb-49ac-4a0d-8a19-3383e3944e12','ae911bf7-cc2f-41a5-a7c8-2c765e0d5a56','2b8c2651-e963-4c7b-a23c-346fba30a357','646b0393-4d73-4cbb-928d-8dec9de95cea'}
keeprefs=[]
for t in list(b.GetTracks()):
 u=t.m_Uuid.AsString()
 if u in dead:removed.append(u);keeprefs.append(t);b.Remove(t)
 if u=='918a51d0-58a7-44e8-a4f9-89dfe314382a':
  t.SetPosition(vec((20.5,47.75)));mutated.append(dict(uuid=u,at=[20.5,47.75]))
assert set(removed)==dead
netcodes={n.GetNetname():n.GetNetCode()for n in b.GetNetsByNetcode().values()}
def route(net,layer,pts,width=.15):
 for a,z in zip(pts,pts[1:]):
  t=p.PCB_TRACK(b);t.SetLayer(layer);t.SetNetCode(netcodes[net]);t.SetWidth(p.FromMM(width));t.SetStart(vec(a));t.SetEnd(vec(z));b.Add(t);added.append(dict(uuid=t.m_Uuid.AsString(),net=net,layer=b.GetLayerName(layer),start=a,end=z,width=width))
route('HE_3V0',p.B_Cu,[(19.022,46.8581),(19.075,46.9111),(19.075,48)])
route('HE_EXC_DIV',p.F_Cu,[(20.5,47.75),(20.0894,47.75)])
route('HE_EXC_DIV',p.B_Cu,[(17.425,48),(17.425,48.95),(19.8,48.95),(20.5,48.25),(20.5,47.75)])
# The old B trunk physically intersects R504.2; its F mate joins the old R505 branch midpoint.
p.ZONE_FILLER(b).Fill(b.Zones());dest=out/'Trimix_Analyzer.kicad_pcb';p.SaveBoard(str(dest),b)
shutil.copy2(src.with_suffix('.kicad_pro'),out/'Trimix_Analyzer.kicad_pro')
assert hashlib.sha256(src.read_bytes()).hexdigest()==sha
(D/'candidate-delta.json').write_text(json.dumps(dict(status='UNACCEPTED_REQUIRES_DRC_AND_CAD',source_sha256=sha,board_sha256=hashlib.sha256(dest.read_bytes()).hexdigest(),moved_footprint=dict(ref='R504',side='B',at=[18.25,48],angle=180,package_unchanged=True),removed=removed,added=added,mutated=mutated,hypothetical_L701_not_moved_in_this_board=True),indent=2)+'\n')
print(str(dest))
