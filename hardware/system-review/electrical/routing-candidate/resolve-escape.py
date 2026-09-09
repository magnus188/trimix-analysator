from pathlib import Path
import sys,math,json
sys.path.insert(0,'hardware/tools');from analyzer_sheet import sx,children,child
import pcbnew as p
D=Path('hardware/system-review/electrical/routing-candidate');src=Path('hardware/pcb/analyzer/Trimix_Analyzer.kicad_pcb');dst=D/'native/Trimix_Analyzer.kicad_pcb'
poses={'C105':(8.2,85.75,90),'R101':(14.5,87.45,0),'C803':(12.25,69.35,0),'R301':(11.95,71.15,0),'R121':(8.75,84.8,90),'R122':(10.45,87.8,0),'R123':(13.5,87.6,0)}
for path in [src,dst]:
 b=p.LoadBoard(str(path));fs={f.GetReference():f for f in b.GetFootprints()}
 for r,(x,y,rot)in poses.items():
  f=fs[r];lab=f.Reference();lp=lab.GetPosition();la=lab.GetTextAngle();f.SetPosition(p.VECTOR2I(p.FromMM(x),p.FromMM(y)));f.SetOrientationDegrees(rot);lab.SetPosition(lp);lab.SetTextAngle(la)
 fs['R301'].Reference().SetPosition(p.VECTOR2I(p.FromMM(11.95),p.FromMM(71.2)));fs['R301'].Reference().SetVisible(False)
 fs['C114'].Reference().SetPosition(p.VECTOR2I(p.FromMM(6.0),p.FromMM(90.0)))
 b.GetDesignSettings().m_TrackMinWidth=p.FromMM(.15);p.SaveBoard(str(path),b)
# Remove colliding ordinary router copper, keeping exact saved manual necks.
a=sx.loads(dst.read_text());manual=sx.loads((D/'escaped-before-routing.kicad_pcb').read_text());new=json.load(open(D/'residual-fanouts.json'));newids={z['uuid'] for z in new['new_copper']}
def sig(z):
 return tuple(sx.dumps(q)for q in z if isinstance(q,list)and str(q[0])not in ['uuid','locked'])
manuals={sig(z)for k in ['segment','via']for z in children(manual,k)}
issues=json.load(open(D/'residual-fanout-drc.json'))['violations'];badids={it['uuid']for v in issues if v['type']in ['shorting_items','clearance','tracks_crossing','hole_clearance','hole_to_hole']for it in v['items']}
removed=[]
for k in ['segment','via']:
 for z in list(children(a,k)):
  uid=child(z,'uuid')[1]
  if uid in badids and uid not in newids and sig(z) not in manuals:
   removed.append(uid);a.remove(z)
# All BQ ILIM, QON and raw-USB routes near altered pad escapes are reroutable.
for k in ['segment','via']:
 for z in list(children(a,k)):
  if child(z,'net')[1] in ['USB_OVP_UPPER','BQ_ILIM','USB_VBUS_DET','USB_LIMIT_SET','/01  CHARGING + BATTERY/BQ_QON_N']and child(z,'uuid')[1]not in newids:
   a.remove(z)
# Replace only new U115 fanouts with checked staggered coordinates.
for k in ['segment','via']:
 for z in list(children(a,k)):
  uid=child(z,'uuid')[1]
  if uid not in newids:continue
  net=child(z,'net')[1];at=child(z,'at')if k=='via'else None
  if net in ['USB_OVP_SET','USB_OVP_UVLO'] or(net=='USB_CC_INT_N'and ((at and at[1]<20)or(k=='segment'and child(z,'layer')[1]=='B.Cu'))):a.remove(z)
  elif net=='USB_OVP_5V':a.remove(z)
  elif net=='/01  CHARGING + BATTERY/CHG_CE_N':
   for key in ['at','start','end']:
    q=child(z,key)
    if q and math.dist(q[1:3],[12.75,86.85])<.001:q[2]=86.65
dst.write_text(sx.dumps(a));b=p.LoadBoard(str(dst))
def v(q):return p.VECTOR2I(p.FromMM(q[0]),p.FromMM(q[1]))
def tr(n,pts,w=.15,L=p.B_Cu):
 for s,e in zip(pts,pts[1:]):
  t=p.PCB_TRACK(b);t.SetStart(v(s));t.SetEnd(v(e));t.SetWidth(p.FromMM(w));t.SetLayer(L);t.SetNetCode(b.FindNet(n).GetNetCode());b.Add(t)
def vi(n,q,d=.45,h=.2):
 t=p.PCB_VIA(b);t.SetPosition(v(q));t.SetWidth(p.FromMM(d));t.SetDrill(p.FromMM(h));t.SetLayerPair(p.F_Cu,p.B_Cu);t.SetViaType(p.VIATYPE_THROUGH);t.SetNetCode(b.FindNet(n).GetNetCode());b.Add(t)
tr('USB_CC_INT_N',[(13.6,89.775),(12.8,89.65),(12.8,88.15)]);vi('USB_CC_INT_N',(12.8,88.15))
tr('USB_OVP_SET',[(13.6,90.225),(12.4,90.3)]);vi('USB_OVP_SET',(12.4,90.3))
tr('USB_OVP_UVLO',[(13.6,90.7),(13.2,91.1),(13,91.1)]);vi('USB_OVP_UVLO',(13,91.1))
tr('USB_OVP_5V',[(14.75,91.65),(13.55,91.75)],.25);vi('USB_OVP_5V',(13.55,91.75),.6,.3)
tr('USB_OVP_5V',[(8.425,90),(9.025,90)],.4)
b.GetDesignSettings().m_TrackMinWidth=p.FromMM(.15);p.ZONE_FILLER(b).Fill(b.Zones());p.SaveBoard(str(dst),b)
(D/'residual-resolution.json').write_text(json.dumps({'poses':poses,'removed_conflicting_automatic_items':removed,'candidate_only':True},indent=2)+'\n')
