"""Resolve measured native escape obstructions; candidate copper remains isolated."""
from pathlib import Path
import sys,json,shutil,copy,math
import pcbnew as p
ROOT=Path(__file__).resolve().parents[4];OUT=Path(__file__).resolve().parent
sys.path.insert(0,str(ROOT/'hardware/tools'));from analyzer_sheet import sx,children,child
def props(f):return {q[1]:q for q in children(f,'property')}
src=ROOT/'hardware/pcb/analyzer/Trimix_Analyzer.kicad_pcb';dest=OUT/'native/Trimix_Analyzer.kicad_pcb';base=OUT/'before-residual-fanouts.kicad_pcb'
if not base.exists():shutil.copy2(dest,base)
poses={'C105':(8,85.75,None),'R102':(10.9,88.25,None),'R101':(14.6,87.55,None),'D101':(17,83,None),'C110':(22.7,77.4,None),'R301':(21.2,69.1,90),'C114':(9.9,90,None)}
changes=[]
for path in [src,dest]:
 if path==dest:shutil.copy2(base,dest)
 b=p.LoadBoard(str(path));fs={f.GetReference():f for f in b.GetFootprints()}
 for ref,(x,y,ang)in poses.items():
  f=fs[ref];old=[p.ToMM(f.GetPosition().x),p.ToMM(f.GetPosition().y),f.GetOrientationDegrees()];lab=f.Reference();lp=lab.GetPosition();la=lab.GetTextAngle();f.SetPosition(p.VECTOR2I(p.FromMM(x),p.FromMM(y)))
  if ang is not None:f.SetOrientationDegrees(ang)
  lab.SetPosition(lp);lab.SetTextAngle(la)
  if path==dest:changes.append({'reference':ref,'old_pose':old,'new_pose':[x,y,f.GetOrientationDegrees()]})
 b.GetDesignSettings().m_TrackMinWidth=p.FromMM(.15);p.SaveBoard(str(path),b)
a=sx.loads(dest.read_text())
reroute={'HOST_3V3','I2C_SCL','I2C_SDA','USB_CC1','USB_CC2','USB_CC_INT_N','USB_OVP_SET','USB_OVP_UVLO','USB_OVP_DVDT','GAUGE_ALERT_N','CHG_INT_N'}|{'/01  CHARGING + BATTERY/'+n for n in ['PACK_TS','CHG_STAT_N','CHG_CE_N','BQ_REGN']}
for k in ['segment','via']:
 for z in list(children(a,k)):
  net=child(z,'net')[1]
  # Remove the obsolete protected-output escape via/neck; other established
  # power distribution can remain available to the next router pass.
  pts=[child(z,q)[1:3]for q in (['at']if k=='via'else['start','end'])]
  kill=net in reroute or (net=='USB_OVP_5V' and any(math.dist(v,(13.2,91.75))<.0001 for v in pts))
  if kill:a.remove(z)
dest.write_text(sx.dumps(a));b=p.LoadBoard(str(dest));added=[]
def v(q):return p.VECTOR2I(p.FromMM(q[0]),p.FromMM(q[1]))
def tr(net,pts,w=.15,layer=p.F_Cu):
 for st,en in zip(pts,pts[1:]):
  t=p.PCB_TRACK(b);t.SetStart(v(st));t.SetEnd(v(en));t.SetWidth(p.FromMM(w));t.SetNetCode(b.FindNet(net).GetNetCode());t.SetLayer(layer);b.Add(t);added.append({'uuid':t.m_Uuid.AsString(),'net':net,'start':st,'end':en,'width_mm':w,'layer':b.GetLayerName(layer)})
def via(net,pt,d=.45,h=.2):
 t=p.PCB_VIA(b);t.SetPosition(v(pt));t.SetWidth(p.FromMM(d));t.SetDrill(p.FromMM(h));t.SetViaType(p.VIATYPE_THROUGH);t.SetLayerPair(p.F_Cu,p.B_Cu);t.SetNetCode(b.FindNet(net).GetNetCode());b.Add(t);added.append({'uuid':t.m_Uuid.AsString(),'net':net,'via_mm':pt,'diameter_mm':d,'drill_mm':h})
def bq(s):return '/01  CHARGING + BATTERY/'+s
for net,start,end in [(bq('CHG_STAT_N'),(11.0375,84.25),(10.35,84.25)),('I2C_SCL',(11.0375,84.75),(9.8,84.75)),('I2C_SDA',(11.0375,85.25),(10.35,85.25)),('CHG_INT_N',(11.75,85.9625),(11.75,86.8)),(bq('CHG_CE_N'),(12.75,85.9625),(12.75,86.85)),(bq('PACK_TS'),(13.75,85.9625),(13.75,86.6))]:
 tr(net,[start,end]);via(net,end)
tr(bq('BQ_REGN'),[(12.75,82.0375),(12.75,81.5),(12.79,81.15)],.2);via(bq('BQ_REGN'),(12.79,81.15))
tr('PACK_P',[(15.4625,85.25),(16.875,85.25)],.35);via('PACK_P',(16.875,85.25))
tr('VSYS',[(15.4625,84.25),(15.84,84.25)],.25);via('VSYS',(15.84,84.25))
for net,start,end in [('USB_CC1',(24.475,77.2),(23.6,77.15)),('USB_CC2',(24.475,77.6),(23.6,77.85)),('HOST_3V3',(24.6,76.575),(24.5,75.98)),('USB_CC_INT_N',(25.8,78.225),(26.1,78.9))]:
 tr(net,[start,end]);via(net,end)
tr('GND',[(25,76.575),(25,75.98),(25.4,75.98),(25.4,76.575)]);via('GND',(25.2,75.9))
for start,end in [((24.6,78.225),(24.6,79.15)),((25.4,78.225),(25.4,79.2))]:tr('GND',[start,end]);via('GND',end)
tr('I2C_SDA',[(25.925,77.6),(26.5,77.6),(26.65,77.75)]);via('I2C_SDA',(26.65,77.75))
tr('I2C_SCL',[(25.925,77.2),(26.5,77.2),(26.6,76.7)]);via('I2C_SCL',(26.6,76.7))
# U111 factory land pitch needs125um short necks before normal150um routing.
fs={f.GetReference():f for f in b.GetFootprints()}
for q in fs['U111'].Pads():
 net=q.GetNetname();num=int(q.GetNumber())
 if not net or net.startswith('unconnected-')or net=='GND':continue
 x,y=p.ToMM(q.GetPosition().x),p.ToMM(q.GetPosition().y)
 end=(x,75.8)if num in[3,4,5]else((28.0,y)if num in[7,8]else(x,72.65))
 tr(net,[(x,y),end],.125)
tr('GND',[(26.25,72.65),(27.05,72.65)]);via('GND',(26.65,72.4),.5,.25)
tr('USB_CC_INT_N',[(13.6,89.775),(12.6,89.775),(12.6,88.15)],.15,p.B_Cu);via('USB_CC_INT_N',(12.6,88.15))
tr('USB_OVP_SET',[(13.6,90.225),(12.25,90.225),(12.25,91.25),(13,91.6)],.15,p.B_Cu);via('USB_OVP_SET',(13,91.6))
tr('USB_OVP_UVLO',[(13.6,90.7),(12.8,90.6)],.15,p.B_Cu);via('USB_OVP_UVLO',(12.8,90.6))
tr('USB_OVP_DVDT',[(15.225,89.125),(15.4,88.5)],.15,p.B_Cu);via('USB_OVP_DVDT',(15.4,88.5))
tr('USB_OVP_5V',[(14.75,91.65),(13.85,91.8)],.25,p.B_Cu);via('USB_OVP_5V',(13.85,91.8),.6,.3)
b.GetDesignSettings().m_TrackMinWidth=p.FromMM(.15);p.ZONE_FILLER(b).Fill(b.Zones());p.SaveBoard(str(dest),b)
(OUT/'residual-fanouts.json').write_text(json.dumps({'candidate_only':True,'changed_poses':changes,'new_copper':added,'rerouted_nets':sorted(reroute),'minimum_ordinary_track_mm':.15,'local_via_diameter_drill_mm':[.45,.2],'requires_fresh_DRC':True,'order_release':False},indent=2)+'\n');print(len(added),'new copper items;',len(changes),'internal passive moves')
