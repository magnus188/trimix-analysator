"""Approved internal passive moves that make manufacturer lands routable."""
from pathlib import Path
import sys,copy,json,shutil
import pcbnew as p
ROOT=Path(__file__).resolve().parents[4];OUT=Path(__file__).resolve().parent
sys.path.insert(0,str(ROOT/'hardware/tools'));from analyzer_sheet import sx,child,children
def props(a):return {q[1]:q for q in children(a,'property')}
src=ROOT/'hardware/pcb/analyzer/Trimix_Analyzer.kicad_pcb'
before=OUT/'before-component-escape-moves.kicad_pcb'
if not before.exists():shutil.copy2(src,before)
b=p.LoadBoard(str(src));fs={f.GetReference():f for f in b.GetFootprints()};changes=[]
poses={'C111':(28.9,73.7,90),'R301':(25.75,71.55,0),'C505':(9.2,51.5,90),'R701':(16.95,56.2,90),'L701':(19.5,51.2,270),'R124':(16,86.35,90)}
for ref,(x,y,ang) in poses.items():
 f=fs[ref];old=[p.ToMM(f.GetPosition().x),p.ToMM(f.GetPosition().y),f.GetOrientationDegrees()];label=f.Reference();lp=label.GetPosition();la=label.GetTextAngle();f.SetPosition(p.VECTOR2I(p.FromMM(x),p.FromMM(y)));f.SetOrientationDegrees(ang);label.SetPosition(lp);label.SetTextAngle(la);changes.append({'reference':ref,'old_pose':old,'new_pose':[x,y,ang]})
p.SaveBoard(str(src),b)
# Keep an unpopulated NC land at position7 so native schematic parity remains
# complete. The selected header and its3D reconstruction omit the physical post.
a=sx.loads(src.read_text());f=next(f for f in children(a,'footprint')if props(f)['Reference'][2]=='J301')
old=sx.loads((OUT/'before-J301-rotation.kicad_pcb').read_text());oh=next(f for f in children(old,'footprint')if props(f)['Reference'][2]=='J301');pad=copy.deepcopy(next(z for z in children(oh,'pad')if z[1]=='7'));child(pad,'drill')[1]=1.02
if not any(z[1]=='7'for z in children(f,'pad')):f.append(pad)
src.write_text(sx.dumps(a))
lib=ROOT/'hardware/pcb/analyzer/Trimix_Power.pretty/Samtec_HTSW-113-07-L-D-007_P2.54mm_Key7.kicad_mod';l=sx.loads(lib.read_text());lp=copy.deepcopy(pad)
for key in ['net','pinfunction','pintype','uuid']:
 for z in children(lp,key):lp.remove(z)
if not any(z[1]=='7'for z in children(l,'pad')):l.append(lp)
lib.write_text(sx.dumps(l))
# Restore clean pre-trial copper, retaining current corrected geometry and the
# previously reviewed output capacitor rotations.
dest=OUT/'native/Trimix_Analyzer.kicad_pcb';c=sx.loads((OUT/'before-package-escapes.kicad_pcb').read_text());caps={props(f)['Reference'][2]:copy.deepcopy(f)for f in children(c,'footprint')if props(f)['Reference'][2]in['C204','C205','C206']}
for f in list(children(c,'footprint')):c.remove(f)
for f in children(a,'footprint'):c.append(copy.deepcopy(caps.get(props(f)['Reference'][2],f)))
# All signal routes can be optimized again; retain existing power/ground and
# accepted converter loop copper. Avoid locking stale obstacle detours.
power={'GND','PACK_P','VSYS','VOUT_5V','HOST_5V','USB_5V','USB_OVP_5V','USB_CHG_5V'}
held={'Net-(L201-Pad1)','Net-(L201-Pad2)'}
for k in ['segment','via']:
 for z in list(children(c,k)):
  net=child(z,'net')[1]
  if net not in power|held:c.remove(z)
dest.write_text(sx.dumps(c));b=p.LoadBoard(str(dest));p.ZONE_FILLER(b).Fill(b.Zones());p.SaveBoard(str(dest),b)
shutil.copy2(dest,OUT/'corrected-package-base.kicad_pcb')
(OUT/'component-escape-moves.json').write_text(json.dumps({'candidate_geometry_pending_native_DRC':True,'changes':changes,'J301_pin7':'NC unpopulated land retained; physical post omitted and mating cavity blocked','purchased_sizes_scaled':False,'order_release':False},indent=2)+'\n');print(changes)
