"""Source-bound routing-rule exceptions and return-layer audit; no physical claims."""
from pathlib import Path
import argparse,json,math,hashlib,collections
import pcbnew as p
ROOT=Path(__file__).resolve().parents[3]
ap=argparse.ArgumentParser();ap.add_argument('--board',type=Path,required=True);ap.add_argument('--drc',type=Path,required=True);ap.add_argument('--output',type=Path,required=True);a=ap.parse_args();b=p.LoadBoard(str(a.board));d=json.loads(a.drc.read_text())
rows=[]
def check(name,ok,detail):rows.append({'check':name,'passed':bool(ok),'detail':detail})
tracks=[t for t in b.GetTracks()if not isinstance(t,p.PCB_VIA)];vias=[t for t in b.GetTracks()if isinstance(t,p.PCB_VIA)]
def mm(v):return p.ToMM(v)
def xy(pt):return(mm(pt.x),mm(pt.y))
def within(pt,r):return r[0]-.00001<=pt[0]<=r[2]+.00001 and r[1]-.00001<=pt[1]<=r[3]+.00001
check('all native electrical connections complete',len(d['unconnected_items'])==0,{'unconnected':len(d['unconnected_items'])})
check('native schematic parity',len(d['schematic_parity'])==0,{'mismatches':len(d['schematic_parity'])})
check('native DRC errors and warnings resolved',not d['violations'],collections.Counter(z['type']for z in d['violations']))
check('In1 carries no routed signal tracks',all(t.GetLayer()!=p.In1_Cu for t in tracks),'Layer reserved for continuous ground return; split/slot geometry still needs final visual/CAM review.')
check('In1 zones are filled ground',all(z.GetNetname()=='GND'and z.IsFilled()for z in b.Zones()if z.GetLayer()==p.In1_Cu),'Zone filling is necessary; this does not prove every return-current path.')
small=[t for t in tracks if mm(t.GetWidth())<.15-.00001]
check('125um tracks remain inside U111 local escape allocation',all(mm(t.GetWidth())>=.125-.00001 and within(xy(t.GetStart()),(24.7,72.3,28.1,75.85)) and within(xy(t.GetEnd()),(24.7,72.3,28.1,75.85))for t in small),{'count':len(small),'rectangle_mm':[24.7,72.3,28.1,75.85]})
# Human-reviewed package fanout coordinates; do not infer permission from a
# new board's own via locations. Every other signal via uses >=0.50/0.25mm.
local=[(12.79,81.15),(13.5,81.2),(10.15,84),(9.98,84.75),(10.2,85.5),(11.75,86.8),(12.75,86.65),(13.75,86.6),(16.95,85.2),(15.84,84.25),(23.6,77.15),(23.6,77.85),(24.5,75.98),(26.1,78.9),(25.2,75.9),(24.6,79.15),(25.4,79.2),(26.65,77.75),(26.6,76.7),(11.9,88.65),(12.2,87.8),(12.4,90.3),(13,91.6),(15.89,88.8),(28.05,73.75)]
# Exact U115.3 escape reviewed independently against JLC POFV rules and actual
# mask/paste/drill bytes. This is the sole 100um-annulus routed-via exception;
# audit_via_assembly.py separately requires its fill/cap and part/pin identity.
def exact_cc_vippo(v):return math.dist(xy(v.GetPosition()),(13.6,89.775))<.000002 and v.GetNetname()=='USB_CC_INT_N' and abs(mm(v.GetDrillValue())-.2)<.000002 and abs(mm(v.GetWidth(p.F_Cu))-.4)<.000002
smallvias=[v for v in vias if mm(v.GetDrillValue())<.25-.00001 or mm(v.GetWidth(p.F_Cu))<.5-.00001]
check('200um drills restricted to explicit reviewed package escapes',all(exact_cc_vippo(v) or (mm(v.GetDrillValue())>=.2-.00001 and mm(v.GetWidth(p.F_Cu))>=.45-.00001 and any(math.dist(xy(v.GetPosition()),q)<.0002 for q in local))for v in smallvias),{'count':len(smallvias),'reviewed_450um_land_coordinates_mm':local,'sole_400um_land_VIPPO_mm':[13.6,89.775],'process_review':'vippo-process-review/native-v3-independent/README.md'})
check('routed via annuli125um except exact100um U115.3 VIPPO',all(exact_cc_vippo(v) or (mm(v.GetWidth(p.F_Cu))-mm(v.GetDrillValue()))/2>=.125-.00001 for v in vias),'Only the independently reviewed filled/capped U115.3 escape uses100um nominal annulus. Thermal pad drilling is audited separately.')
held={'Net-(L201-Pad1)','Net-(L201-Pad2)','CO_SW','/01  CHARGING + BATTERY/BQ_PMID'}
check('power switch and PMID loops remain on front copper',all(t.GetLayer()==p.F_Cu for t in tracks if t.GetNetname()in held),sorted(held))
# A single explicitly sourced C103 bootstrap branch changes layers. It is not
# the U101-to-L101 load-current loop; do not waive all switching-net copper.
sw='/01  CHARGING + BATTERY/BQ_SW'
backs=[t for t in tracks if t.GetNetname()==sw and t.GetLayer()!=p.F_Cu]
swvias=[v for v in vias if v.GetNetname()==sw]
def expected_branch(t):
 ends=[xy(t.GetStart()),xy(t.GetEnd())]
 return t.GetLayer()==p.B_Cu and abs(mm(t.GetWidth())-.2)<.000002 and (all(math.dist(x,y)<.000002 for x,y in zip(ends,[(15.08,80.7),(15.75,81.35)])) or all(math.dist(x,y)<.000002 for x,y in zip(ends,[(15.75,81.35),(15.08,80.7)])))
check('sole BQ_SW rear branch is short C103 bootstrap connection',len(backs)==1 and expected_branch(backs[0]) and len(swvias)==1 and math.dist(xy(swvias[0].GetPosition()),(15.75,81.35))<.000002 and abs(mm(swvias[0].GetWidth(p.F_Cu))-.5)<.000002 and abs(mm(swvias[0].GetDrillValue())-.25)<.000002,{'rear_tracks':len(backs),'switch_vias':len(swvias),'scope':'Only C103 bootstrap gate-charge branch; source and load path witnesses checked independently.'})
fs={f.GetReference():f for f in b.GetFootprints()};fixed={'J401':(4.9,24.46,0),'J402':(4.45,16.6,0),'J301':(27.265,69.245,180)}
check('approved connector poses preserved',all(math.dist(xy(fs[r].GetPosition()),q[:2])<.00001 and abs(fs[r].GetOrientationDegrees()-q[2])<.001 for r,q in fixed.items()),fixed)
for ref,n in [('L701','CO_SW'),('L201','Net-(L201-Pad2)')]:check(ref+' marked short lead is pad2 switch terminal',next(q.GetNetname()for q in fs[ref].Pads()if q.GetNumber()=='2')==n,{'net':n,'assembly_note':'Manufacturer stripe/short lead at custom footprint +X pad2. Electrically nonpolar; winding orientation affects EMI.'})
netstats={}
for t in tracks:
 n=t.GetNetname();r=netstats.setdefault(n,{'length_mm':0,'minimum_width_mm':999,'layers':set(),'vias':0});r['length_mm']+=mm(t.GetLength());r['minimum_width_mm']=min(r['minimum_width_mm'],mm(t.GetWidth()));r['layers'].add(b.GetLayerName(t.GetLayer()))
for v in vias:
 n=v.GetNetname();r=netstats.setdefault(n,{'length_mm':0,'minimum_width_mm':999,'layers':set(),'vias':0});r['vias']+=1
for r in netstats.values():r['layers']=sorted(r['layers']);r['length_mm']=round(r['length_mm'],4)
out={'board':str(a.board),'board_sha256':hashlib.sha256(a.board.read_bytes()).hexdigest(),'drc_sha256':hashlib.sha256(a.drc.read_bytes()).hexdigest(),'checks':rows,'passed':sum(z['passed']for z in rows),'failed':sum(not z['passed']for z in rows),'tracks':len(tracks),'vias':len(vias),'net_route_statistics':netstats,'limitations':['Geometric/routing audit only; not thermal, EMC, signal-noise or physical fit qualification.','Native DRC does not prove source-current transient compliance or connector/host power-entry compatibility.','All unresolved manufacturing, host input, battery and physical measurement holds remain in force.'],'order_release':False}
a.output.write_text(json.dumps(out,indent=2)+'\n');print(out['passed'],'passed;',out['failed'],'failed; tracks',len(tracks),'vias',len(vias))
