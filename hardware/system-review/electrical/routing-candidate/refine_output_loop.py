"""Candidate-only capacitor rotation and directF.Cu TPS63020 output loop."""
from pathlib import Path
import pcbnew as p,sys,json,shutil,math
ROOT=Path(__file__).resolve().parents[4];OUT=Path(__file__).resolve().parent
sys.path.insert(0,str(ROOT/'hardware/tools'));from analyzer_sheet import sx,child,children
path=OUT/'native/Trimix_Analyzer.kicad_pcb';base=OUT/'before-output-cap-rotation.kicad_pcb'
if not base.exists():shutil.copy2(path,base)
a=sx.loads(path.read_text());nets={n[1]:n[2]for n in children(a,'net')};removed=[]
old_ground={(8.375,62.35),(8.375,65.5),(8.375,68.9),(9.625,62.1),(9.625,65.5),(9.625,68.9)}
def close(x,y):return any(math.dist((float(x),float(y)),q)<.0002 for q in old_ground)
for k in ['segment','via']:
 for t in list(children(a,k)):
  n=child(t,'net')[1];name=nets.get(n,n)
  kill=name=='VOUT_5V'
  if name=='GND':
   points=[child(t,kk)for kk in (['at']if k=='via'else['start','end'])]
   kill=any(close(z[1],z[2])for z in points)
  if kill:removed.append({'type':k,'net':name,'uuid':child(t,'uuid')[1]});a.remove(t)
path.write_text(sx.dumps(a));b=p.LoadBoard(str(path));fs={f.GetReference():f for f in b.GetFootprints()}
def v(pt):return p.VECTOR2I(p.FromMM(pt[0]),p.FromMM(pt[1]))
for r in['C204','C205','C206']:
 f=fs[r];t=f.Reference();pos=t.GetPosition();angle=t.GetTextAngle();f.SetOrientationDegrees(180);t.SetPosition(pos);t.SetTextAngle(angle)
added=[]
def tr(net,pts,w,layer=p.F_Cu):
 for start,end in zip(pts,pts[1:]):
  t=p.PCB_TRACK(b);t.SetStart(v(start));t.SetEnd(v(end));t.SetWidth(p.FromMM(w));t.SetNetCode(b.FindNet(net).GetNetCode());t.SetLayer(layer);b.Add(t);added.append({'net':net,'start':start,'end':end,'width_mm':w,'layer':b.GetLayerName(layer)})
def via(net,pt):
 t=p.PCB_VIA(b);t.SetPosition(v(pt));t.SetWidth(p.FromMM(.6));t.SetDrill(p.FromMM(.3));t.SetViaType(p.VIATYPE_THROUGH);t.SetLayerPair(p.F_Cu,p.B_Cu);t.SetNetCode(b.FindNet(net).GetNetCode());b.Add(t);added.append({'net':net,'via_mm':pt,'diameter_mm':.6,'drill_mm':.3})
tr('VOUT_5V',[(11.6,61),(10.5,61),(10.5,61.5)],.2)
tr('VOUT_5V',[(11.6,61.5),(10.5,61.5)],.2)
tr('VOUT_5V',[(10.5,61.5),(9.625,62.375),(9.625,68.9)],.8)
for y in[62.1,65.5,68.9]:
 tr('GND',[(6.675,y),(5.35,y)],.35);via('GND',(5.35,y))
p.ZONE_FILLER(b).Fill(b.Zones());p.SaveBoard(str(path),b)
(OUT/'output-cap-loop-candidate.json').write_text(json.dumps({'candidate_only':True,'rotated_centres_preserved':['C204','C205','C206'],'rotation_deg':180,'removed':removed,'added':added,'no_output_power_via':True,'current_and_native_DRC_qualification_pending':True},indent=2)+'\n')
print('Output loop candidate',len(removed),'olditems removed;',len(added),'items added')
