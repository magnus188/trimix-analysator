"""Candidate-only short package-width escapes before wide power routing."""
from pathlib import Path
import sys,json,shutil
import pcbnew as p
ROOT=Path(__file__).resolve().parents[4];OUT=Path(__file__).resolve().parent
sys.path.insert(0,str(ROOT/'hardware/tools'));from analyzer_sheet import sx,child,children
path=OUT/'native/Trimix_Analyzer.kicad_pcb';base=OUT/'corrected-package-base.kicad_pcb'
if not base.exists():shutil.copy2(path,base)
a=sx.loads(base.read_text())
manual={n for n in [child(z,'net')[1] for z in children(a,'segment')] if n.endswith(('/BQ_SW','/BQ_REGN','/BQ_BTST','/BQ_PMID'))}|{'CO_SW','USB_OVP_5V','USB_CHG_5V','USB_5V'}
for k in ['segment','via']:
 for z in list(children(a,k)):
  if child(z,'net')[1] in manual or child(z,'uuid')[1]=='d4867997-dc80-42f1-87b5-f4c0d5815f22':a.remove(z)

# Relocate only the ground stubs that obstruct the corrected local loops.
for k in ['segment','via']:
 for z in list(children(a,k)):
  if child(z,'net')[1]!='GND':continue
  pts=[child(z,kk)[1:3]for kk in (['at']if k=='via'else['start','end'])]
  if any(abs(x-8.1)<.001 and 79.5<=y<=80.8 or abs(x-16.6125)<.001 and abs(y-45.4)<.001 or abs(x-10.425)<.001 and 90.4<=y<=91.6 or abs(x-20.45)<.001 and abs(y-54.25)<.001 or abs(x-15.2125)<.001 and 81<=y<=82.1 or abs(x-10.5)<.001 and abs(y-88.425)<.001 for x,y in pts):a.remove(z)
path.write_text(sx.dumps(a));b=p.LoadBoard(str(path));added=[]
def v(q):return p.VECTOR2I(p.FromMM(q[0]),p.FromMM(q[1]))
def tr(net,pts,w=.2,layer=p.F_Cu):
 for st,en in zip(pts,pts[1:]):
  t=p.PCB_TRACK(b);t.SetStart(v(st));t.SetEnd(v(en));t.SetWidth(p.FromMM(w));t.SetNetCode(b.FindNet(net).GetNetCode());t.SetLayer(layer);b.Add(t);added.append({'uuid':str(t.m_Uuid),'net':net,'start':st,'end':en,'width_mm':w,'layer':b.GetLayerName(layer)})
def via(net,pt,d=.6,h=.3):
 t=p.PCB_VIA(b);t.SetPosition(v(pt));t.SetWidth(p.FromMM(d));t.SetDrill(p.FromMM(h));t.SetViaType(p.VIATYPE_THROUGH);t.SetLayerPair(p.F_Cu,p.B_Cu);t.SetNetCode(b.FindNet(net).GetNetCode());b.Add(t);added.append({'uuid':str(t.m_Uuid),'net':net,'via_mm':pt,'diameter_mm':d,'drill_mm':h})
def bq(s):return '/01  CHARGING + BATTERY/'+s
tr(bq('BQ_SW'),[(13.75,82.0375),(14.25,82.0375)],.25)
tr(bq('BQ_SW'),[(14.25,82.0375),(14.25,79.225),(13.5,79.225)],.45)
tr(bq('BQ_SW'),[(14.25,80.1),(15.71,80.1),(15.71,83.0),(18.75,83.0),(19,83.25)],.2)
tr(bq('BQ_PMID'),[(12.25,82.0375),(12.25,81.3),(10.5,81.3)],.25)
tr(bq('BQ_PMID'),[(10.5,81.3),(8.1,81.3),(8.1,82.475)],.65)
tr(bq('BQ_REGN'),[(12.75,82.0375),(12.75,81.5),(12.79,81.15)],.2);via(bq('BQ_REGN'),(12.79,81.15),.45,.2)
tr(bq('BQ_BTST'),[(13.25,82.0375),(13.25,81.7),(13.35,81.5),(13.5,81.2)],.2);via(bq('BQ_BTST'),(13.5,81.2),.45,.2)
tr(bq('BQ_BTST'),[(19,81.35),(20.1,81.35)],.25);via(bq('BQ_BTST'),(20.1,81.35))
tr(bq('BQ_BTST'),[(13.5,81.2),(14.5,80.2),(18.95,80.2),(20.1,81.35)],.25,p.B_Cu)
tr('USB_CHG_5V',[(11.0375,82.75),(10.1,82.75)],.25);via('USB_CHG_5V',(10.1,82.75))
tr('USB_CHG_5V',[(8.85,90.5),(10.2,90.35)],.35);via('USB_CHG_5V',(10.2,90.35))
tr('USB_OVP_5V',[(6.15,89.55),(6.15,90.5)],.4)
tr('USB_OVP_5V',[(6.15,89.55),(7.2,89.55)],.4);via('USB_OVP_5V',(7.2,89.55))
tr('USB_5V',[(14.25,90),(14.25,87.9)],.25,p.B_Cu)
tr('USB_5V',[(14.25,87.9),(14.25,87.85)],1,p.B_Cu)
tr('USB_OVP_5V',[(14.75,90),(14.75,91.65),(13.2,91.75)],.25,p.B_Cu);via('USB_OVP_5V',(13.2,91.75))
tr('USB_OVP_5V',[(9.025,90),(9.025,88.8),(9.75,88.4)],.4,p.B_Cu);via('USB_OVP_5V',(9.75,88.4))
tr('VOUT_5V',[(11.1625,50.85),(10.15,50.85)],.3)
tr('HOST_5V',[(12.8375,50.85),(14,50.85)],.3);via('HOST_5V',(14,50.85))
tr('HOST_5V',[(11.1625,52.15),(10.25,52.15)],.3);via('HOST_5V',(10.25,52.15))
tr('HOST_5V',[(11.225,49.65),(10.0,49.65)],.3);via('HOST_5V',(10,49.65))
tr('VOUT_5V',[(17.8625,44.45),(16.75,44.45),(16.75,46.35),(17.8625,46.35)],.4)
tr('VOUT_5V',[(18.7875,56.3),(17.85,56.3),(17.85,56.8),(18.7875,56.8)],.2)
tr('VOUT_5V',[(17.85,56.55),(17.85,54.4)],.2)
tr('CO_SW',[(20.2125,56.3),(20.86,56.3),(20.86,53.4),(19.5,52.385)],.2)
tr('GND',[(8.1,79.525),(6.2,79.525)],.35);via('GND',(6.2,79.525))
tr('GND',[(17.8625,45.4),(18.8,45.4)],.35);via('GND',(18.8,45.4))
tr('GND',[(10.425,91.5),(11.1,91.1)],.2);via('GND',(11.1,91.1))
tr('GND',[(21.9,54.25),(23.35,54.25)],.35);via('GND',(23.35,54.25))
tr('GND',[(14.9625,83.25),(14.1,83.25)],.25)
tr('GND',[(14.9625,82.75),(14.7,82.8),(14.1,82.8)],.2)
# Fine QFN escapes keep default0.20mm clearance. Only the initial lead-width
# segment uses0.125mm; the ordinary signal class will widen to0.15mm outside.
fs={f.GetReference():f for f in b.GetFootprints()}
for q in fs['U111'].Pads():
 net=q.GetNetname()
 if not net or net.startswith('unconnected-'):continue
 x,y=p.ToMM(q.GetPosition().x),p.ToMM(q.GetPosition().y);num=int(q.GetNumber())
 if num in [3,4,5]:end=(x,75.8)
 elif num in [7,8]:end=(28.0,y)
 else:end=(x,72.65)
 tr(net,[(x,y),end],.125)
p.ZONE_FILLER(b).Fill(b.Zones());p.SaveBoard(str(path),b)
(OUT/'package-escape-intent.json').write_text(json.dumps({'candidate_only':True,'changes':added,'local_vias':'.45/.20 through vias REGN/BTST;0.125mm annulus, four-layer published capability; native rule scoped separately','ordinary_vias':'.60/.30','order_release':False},indent=2)+'\n');print(len(added),'escape copper objects')
