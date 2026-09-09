from pathlib import Path
import sys,json,math
sys.path.insert(0,'hardware/tools');from analyzer_sheet import sx,children,child
import pcbnew as p
D=Path('hardware/system-review/electrical/routing-candidate');dst=D/'native/Trimix_Analyzer.kicad_pcb';src=Path('hardware/pcb/analyzer/Trimix_Analyzer.kicad_pcb')
for path in [dst,src]:
 b=p.LoadBoard(str(path));fs={f.GetReference():f for f in b.GetFootprints()};fs['R101'].SetPosition(p.VECTOR2I(p.FromMM(14.5),p.FromMM(87.55)))
 # Changed labels will be regenerated after placement; these four are now map-only.
 for r in ['TP1005','R103','R121','R122','C114']:fs[r].Reference().SetVisible(False)
 p.SaveBoard(str(path),b)
a=sx.loads(dst.read_text());report=json.load(open(D/'residual-v2-drc.json'));bad=set()
new=json.load(open(D/'residual-fanouts.json'));newids={z['uuid']for z in new['new_copper']}
# Remove colliding old routing, including now-obsolete ground stubs. Exact
# fixed switch loops are unaffected by these reported UUIDs.
keepnets={'I2C_SCL','I2C_SDA','/01  CHARGING + BATTERY/CHG_STAT_N','/01  CHARGING + BATTERY/PACK_TS','PACK_P','USB_OVP_SET','USB_OVP_UVLO','USB_CC_INT_N'}
for x in report['violations']:
 if x['type']in ['shorting_items','clearance','tracks_crossing','hole_clearance','hole_to_hole','solder_mask_bridge']:
  for i in x['items']:
   if i['description'].startswith(('Track','Via')):bad.add(i['uuid'])
for k in ['segment','via']:
 for z in list(children(a,k)):
  n=child(z,'net')[1];u=child(z,'uuid')[1]
  if u in bad and n not in keepnets:a.remove(z)
# Replace controls/power escape pieces in the altered lower region.
remove_nets={'USB_OVP_UVLO'}
for k in ['segment','via']:
 for z in list(children(a,k)):
  n=child(z,'net')[1];pts=[child(z,q)[1:3]for q in (['at']if k=='via'else['start','end'])]
  if n in remove_nets or(n=='USB_CC_INT_N'and any(x<20 and y>88 for x,y in pts))or(n=='USB_OVP_5V'and any((x<14.9 and y>88) for x,y in pts))or(n=='USB_5V'and k=='segment'and child(z,'layer')[1]=='B.Cu'and any(13<x<16 and 87<y<91 for x,y in pts)):
   a.remove(z);continue
  remap={}
  if n=='I2C_SCL':remap={(9.8,84.75):(9.98,84.75)}
  if n=='I2C_SDA':remap={(10.35,85.25):(10.2,85.5)}
  if n=='PACK_P':remap={(16.875,85.25):(16.95,85.2)}
  for q in ['at','start','end']:
   it=child(z,q)
   if it:
    for old,newpt in remap.items():
     if math.dist(it[1:3],old)<.0001:it[1:3]=newpt
  if n=='/01  CHARGING + BATTERY/CHG_STAT_N'and child(z,'uuid')[1]in newids:a.remove(z)
dst.write_text(sx.dumps(a));b=p.LoadBoard(str(dst))
def v(q):return p.VECTOR2I(p.FromMM(q[0]),p.FromMM(q[1]))
def tr(n,ps,w=.15,L=p.B_Cu):
 for s,e in zip(ps,ps[1:]):
  t=p.PCB_TRACK(b);t.SetStart(v(s));t.SetEnd(v(e));t.SetWidth(p.FromMM(w));t.SetLayer(L);t.SetNetCode(b.FindNet(n).GetNetCode());b.Add(t)
def vi(n,q,d=.45,h=.2):
 t=p.PCB_VIA(b);t.SetPosition(v(q));t.SetWidth(p.FromMM(d));t.SetDrill(p.FromMM(h));t.SetLayerPair(p.F_Cu,p.B_Cu);t.SetViaType(p.VIATYPE_THROUGH);t.SetNetCode(b.FindNet(n).GetNetCode());b.Add(t)
tr('/01  CHARGING + BATTERY/CHG_STAT_N',[(11.0375,84.25),(10.55,84.25),(10.15,84.0)],L=p.F_Cu);vi('/01  CHARGING + BATTERY/CHG_STAT_N',(10.15,84))
tr('USB_CC_INT_N',[(13.6,89.775),(12.8,89.65),(12.8,89.0),(11.9,88.65)]);vi('USB_CC_INT_N',(11.9,88.65))
tr('USB_OVP_UVLO',[(13.6,90.7),(13.0,91.25),(13.0,91.6)]);vi('USB_OVP_UVLO',(13,91.6))
tr('USB_OVP_5V',[(14.75,90),(14.75,91.2),(13.6,91.3),(13.6,92.4),(13.3,92.4)],.25);vi('USB_OVP_5V',(13.3,92.4),.6,.3)
tr('USB_OVP_5V',[(8.425,90),(8.425,88.9),(8,88.55)],.4);vi('USB_OVP_5V',(8,88.55),.6,.3)
tr('USB_5V',[(14.25,90),(14.25,88.5),(15.1,88.3),(15.1,86.4)],.25);vi('USB_5V',(15.1,86.4),.6,.3)
b.GetDesignSettings().m_TrackMinWidth=p.FromMM(.15);p.ZONE_FILLER(b).Fill(b.Zones());p.SaveBoard(str(dst),b)
