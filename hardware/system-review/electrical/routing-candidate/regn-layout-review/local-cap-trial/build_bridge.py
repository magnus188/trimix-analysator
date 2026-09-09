"""Isolated C107 placement/upper PACK detour trial, never authoritative EDA."""
from pathlib import Path
import sys,hashlib,json,math,shutil
import pcbnew as p
OUT=Path(__file__).resolve().parent
BASE=OUT.parent/'before.kicad_pcb';DEST=OUT/'Trimix_Analyzer.kicad_pcb'
SHA='609a6241ce50cbe3d40f7a1676c455092db583875895eeb8236083bf2c5f0ef1'
assert hashlib.sha256(BASE.read_bytes()).hexdigest()==SHA
sys.path.insert(0,str(Path.cwd()/'hardware/tools'))
from analyzer_sheet import sx,child,children,fmt
a=sx.loads(BASE.read_text());removed=[]
for q in children(a,'segment'):
 if child(q,'uuid')[1]=='dcf3adfc-98b6-4b63-9e3c-1e074a51d2df':
  assert child(q,'net')[1]=='PACK_P' and child(q,'width')[1]==.4
  removed.append(child(q,'uuid')[1]);a.remove(q)
assert len(removed)==1
DEST.write_text(fmt(a)+'\n');b=p.LoadBoard(str(DEST))
src=OUT.parents[1]/'native'
for q in src.iterdir():
 if q.is_file() and (q.suffix in ['.kicad_pro','.kicad_dru','.kicad_sch','.kicad_sym'] or q.name in ['sym-lib-table','fp-lib-table']):shutil.copy2(q,OUT/q.name)
 if q.is_dir() and q.name.endswith('.pretty'):shutil.copytree(q,OUT/q.name,dirs_exist_ok=True)
shutil.copy2(OUT/'Trimix_Analyzer.kicad_pro',OUT/'frozen-project.json')
def vec(q):return p.VECTOR2I(p.FromMM(q[0]),p.FromMM(q[1]))
def xy(q):return [p.ToMM(q.x),p.ToMM(q.y)]
f=next(f for f in b.GetFootprints() if f.GetReference()=='C107');f.Flip(f.GetPosition(),False);f.SetPosition(vec((12.8,78.6)));f.SetOrientationDegrees(90)
assert f.GetLayer()==p.B_Cu
added=[];nets={str(k):q.GetNetCode() for k,q in b.GetNetsByName().items()}
def track(net,pts,layer=p.F_Cu,width=.15):
 for a,z in zip(pts,pts[1:]):
  if math.dist(a,z)<1e-6:continue
  q=p.PCB_TRACK(b);q.SetStart(vec(a));q.SetEnd(vec(z));q.SetWidth(p.FromMM(width));q.SetNetCode(nets[net]);q.SetLayer(layer);b.Add(q)
  added.append({'uuid':q.m_Uuid.AsString(),'net':net,'layer':b.GetLayerName(layer),'start':a,'end':z,'width_mm':width})
def via(net,at,d=.6,h=.3):
 q=p.PCB_VIA(b);q.SetPosition(vec(at));q.SetWidth(p.FromMM(d));q.SetDrill(p.FromMM(h));q.SetViaType(p.VIATYPE_THROUGH);q.SetLayerPair(p.F_Cu,p.B_Cu);q.SetNetCode(nets[net]);b.Add(q)
 added.append({'uuid':q.m_Uuid.AsString(),'net':net,'at':at,'diameter_mm':d,'drill_mm':h})
def save():
 b.GetDesignSettings().m_TrackMinWidth=p.FromMM(.15);p.ZONE_FILLER(b).Fill(b.Zones());p.SaveBoard(str(DEST),b)
 shutil.copy2(OUT/'frozen-project.json',OUT/'Trimix_Analyzer.kicad_pro')
 assert hashlib.sha256(BASE.read_bytes()).hexdigest()==SHA
 (OUT/'trial-delta.json').write_text(json.dumps({'source_sha256':SHA,'after_sha256':hashlib.sha256(DEST.read_bytes()).hexdigest(),'removed':removed,'added':added,'C107':{'side':'B','xy_mm':[12.8,78.6],'rotation_deg':90,'same_exact_1206_part':True},'status':'ISOLATED_TRIAL_NOT_ADOPTED','requires':['Native DRC','REGN and GND explicit paths','Ground return review','New carrier clearance pocket and Fusion interference checks']},indent=2)+'\n')
