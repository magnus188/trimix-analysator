from pathlib import Path
import sys,json,shutil
import pcbnew as p
D=Path(__file__).resolve().parent;ROOT=D.parents[3];sys.path.insert(0,str(ROOT/'hardware/tools'));from analyzer_sheet import sx,children,child
path=D/'native/Trimix_Analyzer.kicad_pcb';backup=D/'before-usb-row-escapes.kicad_pcb'
if not backup.exists():shutil.copy2(path,backup)
a=sx.loads(path.read_text());removed=[]
for k in ['segment','via']:
 for z in list(children(a,k)):
  n=child(z,'net')[1];uid=child(z,'uuid')[1]
  if n in ['USB_D_P','USB_D_M']or uid in ['80a7ef5d-6815-424b-81f9-9670e06f8999','3769e5c0-f646-4b3e-8e99-12184950597f']:
   removed.append(uid);a.remove(z)
path.write_text(sx.dumps(a));b=p.LoadBoard(str(path));items=[]
def v(pt):return p.VECTOR2I(p.FromMM(pt[0]),p.FromMM(pt[1]))
def tr(n,pts,w=.15,L=p.B_Cu):
 for s,e in zip(pts,pts[1:]):
  t=p.PCB_TRACK(b);t.SetStart(v(s));t.SetEnd(v(e));t.SetWidth(p.FromMM(w));t.SetLayer(L);t.SetNetCode(b.FindNet(n).GetNetCode());b.Add(t);items.append({'uuid':t.m_Uuid.AsString(),'net':n,'layer':b.GetLayerName(L),'start':s,'end':e,'width':w})
def vi(n,pt,d=.5,h=.25):
 t=p.PCB_VIA(b);t.SetPosition(v(pt));t.SetWidth(p.FromMM(d));t.SetDrill(p.FromMM(h));t.SetLayerPair(p.F_Cu,p.B_Cu);t.SetViaType(p.VIATYPE_THROUGH);t.SetNetCode(b.FindNet(n).GetNetCode());b.Add(t);items.append({'uuid':t.m_Uuid.AsString(),'net':n,'via':pt,'diameter':d,'drill':h})
for n,x in [('USB_CC2',15.65),('USB_D_P',17.45),('USB_D_M',19.25)]:tr(n,[(x,97),(x,95.5)]);vi(n,(x,95.5))
tr('USB_D_P',[(27.275,73.85),(27.8,73.85),(28.05,73.75)],.125,p.F_Cu);vi('USB_D_P',(28.05,73.75),.45,.2)
tr('USB_D_M',[(27.275,74.25),(27.95,74.25),(27.95,75.2)],.125,p.F_Cu);vi('USB_D_M',(27.95,75.2))
b.GetDesignSettings().m_TrackMinWidth=p.FromMM(.15);p.ZONE_FILLER(b).Fill(b.Zones());p.SaveBoard(str(path),b)
(D/'usb-row-escape-intent.json').write_text(json.dumps({'new_items':items,'removed_provisional_crossing_trunks':removed,'candidate_only':True,'native_DRC_required':True,'order_release':False},indent=2)+'\n')
