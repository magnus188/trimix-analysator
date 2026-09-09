"""Real R129 0603 jumper geometry; all-pad and courtyard checks, no EDA save."""
from pathlib import Path
import json,hashlib,math,collections,argparse
import pcbnew as p
D=Path(__file__).resolve().parent;R=D.parent
ap=argparse.ArgumentParser();ap.add_argument('--flex-cc',action='store_true');ap.add_argument('--allow-set-vippo',action='store_true');args=ap.parse_args()
src=D/'source-controls-overlay.kicad_pcb';expected='817a3f8c8ad51f40706cee62c9028a691af2ad19b233cdbb186b2b0de57e8ae9'
assert hashlib.sha256(src.read_bytes()).hexdigest()==expected
b=p.LoadBoard(str(src));nets={str(k):v.GetNetCode()for k,v in b.GetNetsByName().items()}
vec=lambda q:p.VECTOR2I(p.FromMM(q[0]),p.FromMM(q[1]))
xy=lambda q:[p.ToMM(q.x),p.ToMM(q.y)]
held=[t for t in b.GetTracks()if t.m_Uuid.AsString()in ['08c8df62-8fc9-470a-8189-85ea3bf09942','f46aa3fa-41c1-4b0e-8cae-bee5d5a3f615']]
assert len(held)==2
for t in held:b.Remove(t)
cc=json.loads((R/'hypothetical-cc-through-set.json').read_text())
for r in ([]if args.flex_cc else cc['segments']):
    t=p.PCB_TRACK(b);t.SetStart(vec(r['start']));t.SetEnd(vec(r['end']));t.SetLayer(p.F_Cu);t.SetWidth(p.FromMM(.15));t.SetNetCode(nets['USB_CC_INT_N']);b.Add(t)
f=p.FootprintLoad('/Applications/KiCad/KiCad.app/Contents/SharedSupport/footprints/Resistor_SMD.pretty','R_0603_1608Metric');f.SetReference('R129');f.SetValue('0R PROVISIONAL SET BRIDGE');b.Add(f)
for q in f.Pads():q.SetNetCode(nets['USB_OVP_SET'])
objects=[t for t in b.GetTracks()if t.IsOnLayer(p.F_Cu)]+[q for fp in b.GetFootprints()if fp.GetReference()!='R129'for q in fp.Pads()if q.IsOnLayer(p.F_Cu)]
foreign=[q.GetEffectiveShape(p.F_Cu)for q in objects if q.GetNetname()!='USB_OVP_SET']
vias=[v for v in b.GetTracks()if isinstance(v,p.PCB_VIA)]
pth=[q for fp in b.GetFootprints()for q in fp.Pads()if q.GetDrillSize().x>0]
courts=[]
for fp in b.GetFootprints():
    if fp.GetReference()=='R129':continue
    fp.BuildCourtyardCaches();q=fp.GetCourtyard(p.F_Cu)
    if q.OutlineCount():courts.append((fp.GetReference(),q))
edges=[e.GetEffectiveShape()for e in b.GetDrawings()if e.GetLayer()==p.Edge_Cuts]
rules=[z for z in list(b.Zones())+[z for fp in b.GetFootprints()for z in fp.Zones()]if z.GetIsRuleArea()and z.GetLayerSet().Contains(p.F_Cu)]
def clear_track(a,z):
    seg=p.SEG(vec(a),vec(z))
    return not any(s.Collide(seg,p.FromMM(.2751))for s in foreign)and not any(s.Collide(seg,p.FromMM(.5751))for s in edges)and not any(z.GetDoNotAllowTracks()and z.Outline().Collide(seg,p.FromMM(.0751))for z in rules)
out=[];fail=collections.Counter()
for ix in range(1150,1401,5):
 for iy in range(8825,9051,5):
  pos=[ix/100,iy/100]
  for angle in [0,15,30,45,60,75,90,105,120,135,150,165]:
   f.SetPosition(vec(pos));f.SetOrientationDegrees(angle);f.BuildCourtyardCaches();court=f.GetCourtyard(p.F_Cu)
   hit=next((ref for ref,g in courts if court.Collide(g,0)),None)
   if hit:fail['courtyard:'+hit]+=1;continue
   if any(z.GetDoNotAllowFootprints()and court.Collide(z.Outline(),0)for z in rules):fail['rule']+=1;continue
   pads=list(f.Pads());good=True;vippo=[]
   for pad in pads:
    s=pad.GetEffectiveShape(p.F_Cu)
    if any(s.Collide(g,p.FromMM(.2001))for g in foreign):fail['pad_copper']+=1;good=False;break
    overlaps=[v for v in vias if s.Collide(v.GetEffectiveShape(p.F_Cu),p.FromMM(.0501))]
    if overlaps:
     if not args.allow_set_vippo or any(v.GetNetname()!='USB_OVP_SET'for v in overlaps):fail['via_land_margin']+=1;good=False;break
     vippo.extend({'pin':pad.GetNumber(),'via_uuid':v.m_Uuid.AsString(),'via_at_mm':xy(v.GetPosition()),'diameter_mm':p.ToMM(v.GetWidth(p.F_Cu)),'drill_mm':p.ToMM(v.GetDrillValue()),'intent':'exact intended filled+capped VIPPO requiring separate audit, never ordinary via approval'}for v in overlaps)
    if any(s.Collide(q.GetEffectiveShape(p.F_Cu),p.FromMM(.0501))for q in pth):fail['PTH_land_margin']+=1;good=False;break
    if any(s.Collide(e,p.FromMM(.5001))for e in edges):fail['edge']+=1;good=False;break
   if not good:continue
   pts=[xy(q.GetPosition())for q in pads];routes=[]
   for i in (0,1):
    top,bottom=pts[i],pts[1-i]
    if clear_track([12.2,87.8],top)and clear_track(bottom,[12.4,90.3]):routes.append({'divider_pin':pads[i].GetNumber(),'IC_pin':pads[1-i].GetNumber(),'divider_route':[[12.2,87.8],top],'IC_route':[bottom,[12.4,90.3]]})
   out.append({'at_mm':pos,'rotation_deg':angle,'pads_mm':pts,'direct_F_routes':routes,'requires_VIPPO':vippo,'score':sum(math.dist(a,z)for a,z in zip(sorted(pts,key=lambda x:x[1]),[[12.2,87.8],[12.4,90.3]]))})
out.sort(key=lambda r:(not bool(r['direct_F_routes']),r['score']))
report={'status':'GEOMETRY_ONLY_NOT_ADOPTED','source_sha256':expected,'part':'RC0603JR-070RL','max_LWH_mm':[1.7,.9,.55],'reference_reserved':'R129','pad_nets_are_same_only_for_provisional_geometry':True,'final_required_nets':['USB_OVP_SET','USB_OVP_SET_IC'],'CC_proposed_F_corridor_omitted_for_joint_reroute':args.flex_cc,'SET_only_VIPPO_trial_allowed':args.allow_set_vippo,'candidates':out,'rejections':dict(fail),'release':False}
name='link-placement-scout'+('-flex'if args.flex_cc else '')+('-VIPPO'if args.allow_set_vippo else '')+'.json'
(D/name).write_text(json.dumps(report,indent=2)+'\n')
assert hashlib.sha256(src.read_bytes()).hexdigest()==expected
print(json.dumps({'count':len(out),'direct_routes':sum(bool(q['direct_F_routes'])for q in out),'top':out[:6],'rejections':dict(fail)},indent=2))
