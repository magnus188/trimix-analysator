"""Native connectivity fault controls, using fresh in-memory KiCad boards."""
import json, math
from pathlib import Path
import pcbnew as p
from inventory import NativeGraph, uid, estimate_edge, BASE, RHO20, barrel_area

D=Path(__file__).resolve().parent
STACK={'copper_thickness_mm':{'F.Cu':.035,'In1.Cu':.0152,'In2.Cu':.0152,'B.Cu':.035},
       'copper_center_z_fraction':{'F.Cu':0.,'In1.Cu':.1,'In2.Cu':.9,'B.Cu':1.}}
tests=[]
def vec(x,y):return p.VECTOR2I(p.FromMM(x),p.FromMM(y))
def board():
    b=p.BOARD();b.SetCopperLayerCount(4);n=p.NETINFO_ITEM(b,'TEST',1);b.Add(n);return b,n
def pad(b,n,ref,pin,x,y,layer=p.F_Cu,fp=None):
    if fp is None:fp=p.FOOTPRINT(b);fp.SetReference(ref);b.Add(fp)
    q=p.PAD(fp);q.SetNumber(pin);q.SetPosition(vec(x,y));q.SetSize(vec(.6,.6));q.SetShape(p.PAD_SHAPE_RECT)
    q.SetAttribute(p.PAD_ATTRIB_SMD);l=p.LSET();l.AddLayer(layer);q.SetLayerSet(l);q.SetNet(n);fp.Add(q);return q
def track(b,n,a,c,layer=p.F_Cu,w=.2):
    q=p.PCB_TRACK(b);q.SetStart(vec(*a));q.SetEnd(vec(*c));q.SetLayer(layer);q.SetWidth(p.FromMM(w));q.SetNet(n);b.Add(q);return q
def via(b,n,x,y):
    q=p.PCB_VIA(b);q.SetPosition(vec(x,y));q.SetWidth(p.FromMM(.6));q.SetDrill(p.FromMM(.3));q.SetViaType(p.VIATYPE_THROUGH);q.SetLayerPair(p.F_Cu,p.B_Cu);q.SetNet(n);b.Add(q);return q
def check(name,condition,detail=None):
    tests.append(dict(name=name,passed=bool(condition),detail=detail))
    if not condition:raise AssertionError(name)
def connected(g,a,c):return g.witness(uid(a),uid(c))['status']=='explicit_native_witness'

b,n=board();a=pad(b,n,'J1','1',0,0);c=pad(b,n,'J2','1',6,0)
t1=track(b,n,(0,0),(2,0));t2=track(b,n,(2,0),(4,0));t3=track(b,n,(4,0),(6,0));g=NativeGraph(b,STACK)
check('three_segment_chain_connected',connected(g,a,c))
near={uid(x)for x in g.cn.GetConnectedTracks(t1)}
check('native_adjacency_is_direct_not_transitive',uid(t2)in near and uid(t3)not in near)
w=g.witness(uid(a),uid(c));check('full_item_resistance_matches_closed_form',math.isclose(w['full_item_estimate_ohm_20C_25um_1p6mm'],RHO20*6/(.2*.035),rel_tol=1e-12))
b.Remove(t2);g=NativeGraph(b,STACK);check('removed_middle_bridge_is_detected',not connected(g,a,c))

b,n=board();a=pad(b,n,'J1','1',0,0);c=pad(b,n,'J2','1',6,0)
track(b,n,(0,0),(2,0));track(b,n,(4,0),(6,0));g=NativeGraph(b,STACK)
check('same_net_disconnected_copper_has_no_path',not connected(g,a,c))

b,n=board();a=pad(b,n,'J1','1',0,0);c=pad(b,n,'J2','1',2,2,p.B_Cu)
track(b,n,(0,0),(2,0));track(b,n,(2,0),(2,2),p.B_Cu);g=NativeGraph(b,STACK)
check('coincident_F_B_tracks_without_via_do_not_join',not connected(g,a,c))
v=via(b,n,2,0);g=NativeGraph(b,STACK);w=g.witness(uid(a),uid(c))
check('physically_joined_F_B_via_connects',connected(g,a,c))
check('F_B_via_includes_one_full_barrel',w['barrel_transition_count']==1)
expected=RHO20*4/(.2*.035)+RHO20*1.6/barrel_area([.3,.3],.025)
check('via_trace_formula_is_dimensionally_correct',math.isclose(w['full_item_estimate_ohm_20C_25um_1p6mm'],expected,rel_tol=1e-12))

b,n=board();a=pad(b,n,'J1','1',0,0);c=pad(b,n,'J2','1',4,0)
track(b,n,(0,0),(2,0));track(b,n,(2,0),(4,0));via(b,n,2,0);g=NativeGraph(b,STACK);w=g.witness(uid(a),uid(c))
check('same_layer_via_touch_does_not_add_barrel',connected(g,a,c)and w['barrel_transition_count']==0)

b,n=board();a=pad(b,n,'J1','1',0,0);c=pad(b,n,'J1','1',3,0,fp=a.GetParentFootprint());g=NativeGraph(b,STACK)
check('same_number_disconnected_physical_pads_do_not_join',not connected(g,a,c))
c.SetPosition(vec(.5,0));g=NativeGraph(b,STACK)
check('same_number_physically_overlapping_pads_do_join',connected(g,a,c))

b,n=board();a=pad(b,n,'U1','1',0,0);c=pad(b,n,'U1','2',3,0,fp=a.GetParentFootprint());g=NativeGraph(b,STACK)
check('IC_package_does_not_create_internal_edges',not connected(g,a,c))

b,n=board();a=pad(b,n,'J1','1',2,2);c=pad(b,n,'J2','1',8,2)
z=p.ZONE(b);z.SetLayer(p.F_Cu);z.SetNetCode(n.GetNetCode());z.SetLocalClearance(p.FromMM(.2));z.SetPadConnection(p.ZONE_CONNECTION_FULL)
z.Outline().NewOutline()
for x,y in[(0,0),(10,0),(10,4),(0,4)]:z.Outline().Append(p.FromMM(x),p.FromMM(y))
b.Add(z)
for a1,c1 in[((0,0),(10,0)),((10,0),(10,4)),((10,4),(0,4)),((0,4),(0,0))]:
    shape=p.PCB_SHAPE(b);shape.SetShape(p.SHAPE_T_SEGMENT);shape.SetStart(vec(*a1));shape.SetEnd(vec(*c1));shape.SetLayer(p.Edge_Cuts);shape.SetWidth(p.FromMM(.05));b.Add(shape)
p.ZONE_FILLER(b).Fill(b.Zones());g=NativeGraph(b,STACK)
check('filled_zone_is_present_for_negative_control',z.GetFilledPolysList(p.F_Cu).OutlineCount()>0)
check('filled_zone_only_connection_is_excluded',not connected(g,a,c))

b,n=board();a=pad(b,n,'J1','1',0,0);c=pad(b,n,'J2','1',2,2,p.In2_Cu)
track(b,n,(0,0),(2,0));track(b,n,(2,0),(2,2),p.In2_Cu);via(b,n,2,0);g=NativeGraph(b,STACK);w=g.witness(uid(a),uid(c))
check('inner_layer_via_path_is_supported',connected(g,a,c))
expected=RHO20*2/(.2*.035)+RHO20*2/(.2*.0152)+RHO20*1.6*.9/barrel_area([.3,.3],.025)
check('inner_layer_uses_thinner_copper_and_partial_barrel',math.isclose(w['full_item_estimate_ohm_20C_25um_1p6mm'],expected,rel_tol=1e-12))

trace=dict(kind='trace',layer='F.Cu',full_item_length_mm=10,width_mm=.4)
r20=estimate_edge(trace,STACK,BASE);r85=estimate_edge(trace,STACK,dict(BASE,temperature_C=85))
check('temperature_scaling_matches_declared_model',math.isclose(r85/r20,1+.00393*65,rel_tol=1e-12))
thin=estimate_edge(trace,STACK,dict(BASE,geometry_case='width_minus_25um_copper_80pct'))
check('geometry_sensitivity_matches_declared_dimensions',math.isclose(thin/r20,.4/(.375*.8),rel_tol=1e-12))

result=dict(status='pass',tests=len(tests),passed=sum(t['passed']for t in tests),kicad_version=p.Version(),cases=tests)
(D/'native-controls.json').write_text(json.dumps(result,indent=2)+'\n');print(json.dumps(result,indent=2))
