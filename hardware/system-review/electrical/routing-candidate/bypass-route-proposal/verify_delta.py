"""Validate and emit only the isolated bypass delta, never replace owner board."""
from pathlib import Path
import sys,json,hashlib,collections
sys.path.insert(0,str(Path.cwd()/'hardware/tools'))
from analyzer_sheet import sx,child as _child,children
def child(node, name, default=None):
 value=_child(node,name)
 return default if value is None else value
import pcbnew as p
D=Path(__file__).resolve().parent
def sha(f):return hashlib.sha256(f.read_bytes()).hexdigest()
before=D/'baseline/Trimix_Analyzer.kicad_pcb';after=D/'Trimix_Analyzer.kicad_pcb'
assert sha(before)=='471b5059a89365352759817f32cfa7922196a4002e63903c4b09b96962ca520a'
a,b=map(lambda f:sx.loads(f.read_text()),[before,after])
def byid(d,names):return{child(q,'uuid')[1]:q for name in names for q in children(d,name)}
old,new=byid(a,['segment','via']),byid(b,['segment','via'])
removed=set(old)-set(new);added=set(new)-set(old);changed={k for k in old.keys()&new.keys()if old[k]!=new[k]}
# Every modified copper node becomes an explicit precondition/removal and addition.
removed|=changed;added|=changed
fpo,fpn=byid(a,['footprint']),byid(b,['footprint']);assert fpo.keys()==fpn.keys()
fpc={k for k in fpo if fpo[k]!=fpn[k]}
def ref(q):return next(x[2]for x in children(q,'property')if x[1]=='Reference')
assert {ref(fpo[k])for k in fpc} <= {'C115','C116'}
for k in fpc:
 q1,q2=fpo[k],fpn[k]
 assert child(q1,'layer')==child(q2,'layer')
 assert q1[1]==q2[1], 'Package substitution'
 pads1,pads2=children(q1,'pad'),children(q2,'pad')
 assert len(pads1)==len(pads2)
 for p1,p2 in zip(pads1,pads2):
  assert p1[:4]==p2[:4], 'Pad number/type/shape changed'
  for name in ['size','drill','layers','net','roundrect_rratio','solder_mask_margin','solder_paste_margin']:
   assert child(p1,name)==child(p2,name), 'Pad electrical/geometry change: '+name
  assert child(p1,'at')[1:3]==child(p2,'at')[1:3], 'Pad moved relative to component'
 for prop in ['Value','Footprint','MPN']:
  x1=[x[2]for x in children(q1,'property')if x[1]==prop];x2=[x[2]for x in children(q2,'property')if x[1]==prop];assert x1==x2
for name in ['general','layers','setup','gr_line','gr_arc','gr_rect','gr_poly','dimension']:assert children(a,name)==children(b,name),name+' changed'
def zones(d):return[[q for q in z if not isinstance(q,list)or str(q[0])not in ['filled_polygon','fill_segments','filled_areas_thickness']]for z in children(d,'zone')]
assert zones(a)==zones(b)
for ext in ['kicad_pro','kicad_dru']:assert sha(D/('Trimix_Analyzer.'+ext))==sha(D/'baseline'/('Trimix_Analyzer.'+ext))
assert all(child(new[k],'layer',[None])[1]!='In1.Cu'for k in added if str(new[k][0])=='segment')
# Restrict all changed/removed electrical nets to the reviewed power cluster and
# explicitly authorized pre-existing unfinished Q front escape.
allowed={'GND','USB_5V','USB_OVP_5V','USB_OVP_UVLO','USB_OVP_DVDT','USB_OVP_ILM','USB_PERMISSION_Q'}
assert all(child(old[k],'net')[1]in allowed for k in removed)
assert all(child(new[k],'net')[1]in allowed for k in added)
bb=p.LoadBoard(str(after));overlaps=[];via_rows=[]
for v in bb.GetTracks():
 if not isinstance(v,p.PCB_VIA)or v.m_Uuid.AsString()not in added:continue
 via_rows.append({'uuid':v.m_Uuid.AsString(),'xy_mm':[p.ToMM(v.GetPosition().x),p.ToMM(v.GetPosition().y)],'diameter_mm':p.ToMM(v.GetWidth(p.F_Cu)),'drill_mm':p.ToMM(v.GetDrillValue())})
 for f in bb.GetFootprints():
  for pad in f.Pads():
   if pad.GetAttribute()!=p.PAD_ATTRIB_SMD:continue
   for L in [p.F_Cu,p.B_Cu]:
    if pad.IsOnLayer(L)and pad.GetEffectiveShape(L).Collide(v.GetPosition(),int(v.GetWidth(L)/2)):overlaps.append((v.m_Uuid.AsString(),f.GetReference(),pad.GetNumber()))
assert not overlaps,overlaps
p0=json.loads((D/'before-drc.json').read_text());p1=json.loads((D/'after-drc.json').read_text())
assert not p1['schematic_parity'];assert all(q['type']in ['track_dangling','via_dangling']for q in p1['violations'])
# Dangling counts can change when intentionally removing unfinished stubs; they
# remain explicit failures of the whole-board routing gate.
patch=[sx.Symbol('bypass_route_patch'),[sx.Symbol('remove')]+[old[k]for k in sorted(removed)],[sx.Symbol('add')]+[new[k]for k in sorted(added)],[sx.Symbol('replace_footprints')]+[[sx.Symbol('replacement'),[sx.Symbol('before'),fpo[k]],[sx.Symbol('after'),fpn[k]]]for k in sorted(fpc)]]
(D/'route-patch.kicad_sexpr').write_text(sx.dumps(patch)+'\n')
out={'status':'bounded_native_geometry_passed_not_order_release','before_sha256':sha(before),'after_sha256':sha(after),'removed_uuids':sorted(removed),'added_uuids':sorted(added),'footprint_changes':[{'reference':ref(fpo[k]),'uuid':k,'before_at':child(fpo[k],'at')[1:],'after_at':child(fpn[k],'at')[1:]}for k in sorted(fpc)],'new_or_changed_vias':via_rows,'new_via_smd_overlaps':overlaps,'unchanged_other_footprints':True,'unchanged_board_outline_stackup_zone_boundaries_rules':True,'before_drc':{'unconnected':len(p0['unconnected_items']),'violations':dict(collections.Counter(q['type']for q in p0['violations']))},'after_drc':{'unconnected':len(p1['unconnected_items']),'violations':dict(collections.Counter(q['type']for q in p1['violations'])),'parity':len(p1['schematic_parity'])},'patch_sha256':sha(D/'route-patch.kicad_sexpr'),'integration':'Check every removed node and before-footprint against owner board, apply only this delta, refill and repeat all native checks. Preserve unrelated newer poses and routes.','limits':['Short0.30mm F power neck and0.15/0.25mm IC land escapes require final current/path assessment.','RawUSB source routing and UVLO remain incomplete until owner integration.','C115/C116 reference fields hidden in dense Barea; assembly/Fab values and BOM retained; final visible-marking inventory required.','Digital topology does not qualify USB transient survival, charging or thermal performance.']}
(D/'proposal-verification.json').write_text(json.dumps(out,indent=2)+'\n');print(json.dumps({k:out[k]for k in ['status','before_sha256','after_sha256','footprint_changes','before_drc','after_drc']},indent=2))
