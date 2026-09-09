"""Verify the bounded upper-route delta and emit an additive integration patch."""
from pathlib import Path
import collections, hashlib, json, sys
import pcbnew as p

OUT = Path(__file__).resolve().parent
ROOT = OUT.parents[4]
sys.path.insert(0, str(ROOT/'hardware/tools'))
from analyzer_sheet import sx, children, child

def sha(path): return hashlib.sha256(path.read_bytes()).hexdigest()
before = OUT/'baseline/Trimix_Analyzer.kicad_pcb'
after = OUT/'Trimix_Analyzer.kicad_pcb'
assert sha(before) == '40158632831955192a2603701a928c6f53594d5937f9eee2602a55cd93141205'
a, b = sx.loads(before.read_text()), sx.loads(after.read_text())
def items(doc, names):
    return {child(q,'uuid')[1]: q for name in names for q in children(doc,name)}
old = items(a, ['segment','via'])
new = items(b, ['segment','via'])
ids = set(new)-set(old)
manifest={'before_sha256':sha(before),'after_sha256':sha(after),'added_items':[{'uuid':u,'type':'via' if str(new[u][0])=='via' else 'segment'}for u in sorted(ids)]}
(OUT/'added-items.json').write_text(json.dumps(manifest,indent=2)+'\n')
assert new.keys() - old.keys() == ids
assert not old.keys() - new.keys()
assert all(old[k] == new[k] for k in old), 'Existing copper changed'
assert children(a,'footprint') == children(b,'footprint'), 'Footprint/pad/pose change'
for name in ['general','layers','setup','gr_line','gr_arc','gr_rect','gr_poly','dimension']:
    assert children(a,name) == children(b,name), name + ' changed'
# The zone boundary and rules must match; derived fill polygons may change.
def zone_rules(doc):
    return [[q for q in z if not isinstance(q,list) or str(q[0]) not in ['filled_polygon','fill_segments','filled_areas_thickness']] for z in children(doc,'zone')]
assert zone_rules(a) == zone_rules(b), 'Zone boundary/rule change'
assert sha(OUT/'Trimix_Analyzer.kicad_pro') == sha(OUT/'baseline/Trimix_Analyzer.kicad_pro')
assert sha(OUT/'Trimix_Analyzer.kicad_dru') == sha(OUT/'baseline/Trimix_Analyzer.kicad_dru')
prior = json.loads((OUT/'before-drc.json').read_text())
post = json.loads((OUT/'after-drc.json').read_text())
def signature(q): return (q['type'], q['severity'], tuple(sorted(t['uuid'] for t in q['items'])))
prior_set = {signature(q) for q in prior['violations']}
introduced = [q for q in post['violations'] if signature(q) not in prior_set]
assert not introduced
assert not post['schematic_parity']
assert len(prior['unconnected_items']) == 40 and len(post['unconnected_items']) == 38
native = p.LoadBoard(str(after))
vias = [q for q in native.GetTracks() if isinstance(q,p.PCB_VIA) and q.m_Uuid.AsString() in ids]
smdoverlaps = []
for v in vias:
    for f in native.GetFootprints():
        for pad in f.Pads():
            if pad.GetAttribute() != p.PAD_ATTRIB_SMD: continue
            for layer in [p.F_Cu,p.B_Cu]:
                if not pad.IsOnLayer(layer): continue
                shape = pad.GetEffectiveShape(layer)
                if shape.Collide(v.GetPosition(), int(v.GetWidth(layer)/2)):
                    smdoverlaps.append([v.m_Uuid.AsString(),f.GetReference(),pad.GetNumber()])
assert not smdoverlaps, 'New via copper overlaps an SMD land'
patch = [sx.Symbol('gauge_host_route_patch')] + [new[q['uuid']] for q in manifest['added_items']]
(OUT/'added-items.kicad_sexpr').write_text(sx.dumps(patch)+'\n')
out = {
    'status':'bounded_proposal_passed_not_full_board_release',
    'before_sha256':sha(before),'after_sha256':sha(after),
    'added_segments':sum(q['type']=='segment' for q in manifest['added_items']),
    'added_vias':len(vias),'removed_items':0,'new_zones':0,
    'modified_existing_copper_items':0,'modified_footprints':0,
    'zone_boundary_and_rules_unchanged':True,'existing_ground_zones_refilled':True,
    'exact_project_and_custom_rules_preserved':True,
    'new_via_overlap_with_SMD_lands':smdoverlaps,
    'before_DRC':{'violations':len(prior['violations']),'types':dict(collections.Counter(q['type']for q in prior['violations'])),'unconnected':len(prior['unconnected_items']),'schematic_parity':len(prior['schematic_parity'])},
    'after_DRC':{'violations':len(post['violations']),'types':dict(collections.Counter(q['type']for q in post['violations'])),'unconnected':len(post['unconnected_items']),'schematic_parity':len(post['schematic_parity'])},
    'introduced_DRC_violations':introduced,
    'resolved_scope':['R301 HOST supply to existing HOST In2 spine','R107 HOST supply branch to R301 supply'],
    'new_signal_track_width_mm':.15,'ground_track_width_mm':None,
    'new_signal_via_diameter_drill_mm':[.5,.25],'new_ground_via_diameter_drill_mm':None,
    'minimum_nominal_new_via_annulus_mm':.125,
    'no_new_In1_signal_tracks':True,
    'integration':'Append only the segment/via nodes in added-items.kicad_sexpr to the owner board, after checking original UUIDs and scoped copper. Refill ground zones and rerun native DRC/parity against the owner’s combined changes. Do not replace the owner board wholesale.',
    'limits':['Two scoped HOST connections completed;38 other missing connections and39 prior dangling warnings remain in this frozen isolated board. GAUGE_ALERT_N still requires a separate escape correction.','Ground-plane continuity, fabrication qualification, circuit performance and physical fit remain broader project gates.'],
    'files':{name:sha(OUT/name)for name in ['added-items.json','added-items.kicad_sexpr','before-drc.json','after-drc.json']}
}
(OUT/'proposal-verification.json').write_text(json.dumps(out,indent=2)+'\n')
print(json.dumps({k:out[k]for k in ['status','added_segments','added_vias','before_DRC','after_DRC','after_sha256']},indent=2))
