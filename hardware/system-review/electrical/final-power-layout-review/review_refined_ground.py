"""Independent saved-fill comparison. Run with geometry Python, BOARD SHA OUT."""
from pathlib import Path
import sys,hashlib,importlib.util,json
D=Path(__file__).resolve().parent;E=D.parent
before_path=E/'routing-candidate/final-cleanup/frozen-bundle/hardware/pcb/analyzer/Trimix_Analyzer.kicad_pcb'
after_path=Path(sys.argv[1]).resolve();expected=sys.argv[2];out=Path(sys.argv[3]).resolve()
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
assert sha(before_path)=='9f274fdf198f1bcb871a4fc360e76693f8a5b048553e6a02998141737956514f'and sha(after_path)==expected
reader=E/'routing-candidate/cap-signal-reconnect/pullup-swap/independent-ground/audit_ground.py'
spec=importlib.util.spec_from_file_location('saved_ground_reader',reader);g=importlib.util.module_from_spec(spec);spec.loader.exec_module(g)
out.mkdir(parents=True,exist_ok=True);g.OUT=out
a,b=[g.load(p)for p in [before_path,after_path]];aa,ba=[g.anchor_witnesses(q)for q in [a,b]]
old_by={x['uuid']:x for x in aa};new_by={x['uuid']:x for x in ba};layers={}
for layer in ['In1.Cu','In2.Cu']:
 old={q['uuid']for q in aa if q['layers'][layer]['contact']};new={q['uuid']for q in ba if q['layers'][layer]['contact']};regions=g.components(b,layer)
 lost_remaining=sorted((old-new)&set(new_by));removed=sorted((old-new)-set(new_by))
 assert not lost_remaining,(layer,lost_remaining)
 assert all(q['has_anchor_to_In1']for q in regions),layer
 layers[layer]=dict(before_area_mm2=a['fills'][layer].area,after_area_mm2=b['fills'][layer].area,added_fill_mm2=b['fills'][layer].difference(a['fills'][layer]).area,removed_fill_mm2=a['fills'][layer].difference(b['fills'][layer]).area,before_anchor_count=len(old),after_anchor_count=len(new),lost_contacts_on_retained_anchors=lost_remaining,removed_ground_anchor_uuids=removed,newly_contacting_anchor_uuids=sorted(new-old),physical_regions=regions)
assert len(layers['In1.Cu']['physical_regions'])==1
assert not[t for t in b['native'].tracks if t['layer']=='In1.Cu'and t['net']!='GND']
assert g.zone_definitions(a['native'])==g.zone_definitions(b['native'])
views=[g.view('refined-ground-comparison',[(a,'In1.Cu','PRESERVED 9f274 In1','anchors'),(b,'In1.Cu','REFINED '+expected[:8]+' In1','anchors'),(a,'In2.Cu','PRESERVED 9f274 In2','anchors'),(b,'In2.Cu','REFINED '+expected[:8]+' In2','anchors')],(0,0,30,99),'Actual saved fill and drilled annular contacts; no board refill or modification.',2400),g.view('refined-local-copper',[(a,'F.Cu','PRESERVED FRONT','normal'),(b,'F.Cu','REFINED FRONT','normal'),(a,'B.Cu','PRESERVED BACK','normal'),(b,'B.Cu','REFINED BACK','normal')],(4,43,26,89),'Power-layout refinements; colors identify native nets and real trace/land geometry.',2600)]
r=dict(status='SAVED_GROUND_TOPOLOGY_PASSED_PENDING_VISUAL_REVIEW',before_path=str(before_path.resolve()),before_sha256=sha(before_path),after_path=str(after_path),after_sha256=expected,script_sha256=sha(Path(__file__)),reader_sha256=sha(reader),layers=layers,anchor_witnesses=dict(before=aa,after=ba),zone_definitions_unchanged=True,In1_one_connected_region=True,no_In1_signal_tracks=True,renders=views,visual_review='PENDING',limits=['Independent geometry of saved copper, not an impedance or EMI simulation.','In2 has separate grounded regions; it is not claimed to be a second continuous ground plane.','Any removed ground anchor requires an explicit reviewed change-set disposition.','Native ERC/DRC, switching loops, analogue routing, assembly CAM, CAD and physical qualification have separate acceptance gates.'],order_release=False)
assert sha(after_path)==expected
(out/'refined-ground-review.json').write_text(json.dumps(r,indent=2)+'\n')
print(json.dumps({layer:{k:v for k,v in q.items()if k!='physical_regions'}|dict(physical_region_count=len(q['physical_regions']))for layer,q in layers.items()},indent=2))
