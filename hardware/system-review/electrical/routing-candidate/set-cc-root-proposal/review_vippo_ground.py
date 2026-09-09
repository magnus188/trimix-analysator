"""Independent saved-fill/anchor comparison for the frozen CC escape only."""
from pathlib import Path
import json,sys
import sexpdata as s
D=Path(__file__).resolve().parent;O=D/'vippo-cc/ground-review';O.mkdir(exist_ok=True)
sys.path.insert(0,str(D.parent/'cap-signal-reconnect/pullup-swap/independent-ground'))
import audit_ground as a
a.OUT=O
original=D/'source-controls-overlay.kicad_pcb'
before=D/'vippo-cc/ground-baseline/Trimix_Analyzer.kicad_pcb'
after=D/'vippo-cc/native-v3/Trimix_Analyzer.kicad_pcb'
expected=['817a3f8c8ad51f40706cee62c9028a691af2ad19b233cdbb186b2b0de57e8ae9',
          '0bb3a6fed82bd5744ecc6112659de33dea331acfdfd5a333a21ad48f1e79a6f5',
          'd490110c6335a6594a8d2171386926c65a95e0f8ba729feb378c478e8a676a63']
assert list(map(a.sha,(original,before,after)))==expected
base,old,new=map(a.load,(original,before,after))
# Source baseline refill must not change any physical pad/track/via or rule geometry.
tags=('footprint','segment','via','setup','general','layers','gr_line','gr_arc','gr_poly')
for tag in tags:
    one,two=a.subs(base['native'].raw,tag),a.subs(old['native'].raw,tag)
    # SaveBoard may reorder physical item lists. Identity plus exact raw content
    # must agree; list order is not a geometry change.
    if tag in ('footprint','segment','via','gr_line','gr_arc','gr_poly'):
        one={a.sub(q,'uuid')[0]:q for q in one};two={a.sub(q,'uuid')[0]:q for q in two}
    assert one==two,tag
assert a.zone_definitions(base['native'])==a.zone_definitions(old['native'])==a.zone_definitions(new['native'])
anchors_before=a.anchor_witnesses(old);anchors_after=a.anchor_witnesses(new)
assert [r['uuid']for r in anchors_before]==[r['uuid']for r in anchors_after]
layers={}
for layer in ('In1.Cu','In2.Cu'):
    prior=a.components(old,layer);current=a.components(new,layer)
    old_contacts={r['uuid']for r in anchors_before if r['layers'][layer]['contact']}
    new_contacts={r['uuid']for r in anchors_after if r['layers'][layer]['contact']}
    assert old_contacts<=new_contacts,(layer,'lost ground anchors',old_contacts-new_contacts)
    assert all(r['has_anchor_to_In1']for r in current),(layer,'unanchored region')
    if layer=='In1.Cu':assert len(prior)==len(current)==1
    layers[layer]={'before_region_count':len(prior),'after_region_count':len(current),
        'before_area_mm2':old['physical'][layer].area,'after_area_mm2':new['physical'][layer].area,
        'area_change_mm2':new['physical'][layer].area-old['physical'][layer].area,
        'before_contacting_anchors':len(old_contacts),'after_contacting_anchors':len(new_contacts),
        'lost_anchors':sorted(old_contacts-new_contacts),'all_regions_reach_In1':True,
        'before_components':prior,'after_components':current}
ligaments,_=a.throat_review(old,new,(13.6,89.775))
outer=a.view('cc-set-outer',[(new,'F.Cu','CC DIRECT F ROUTE','normal'),(new,'B.Cu','PIN ESCAPE + SET TAIL','normal')],
    (11.3,88.3,17.3,91.5),'Scoped CC escape and SET clearance. Four unrelated C116/CHG source errors still block combined acceptance.',1800)
inner=a.view('cc-ground-before-after',[(old,'In1.Cu','BEFORE In1 GND','anchors'),(new,'In1.Cu','AFTER In1 GND','anchors'),
    (old,'In2.Cu','BEFORE In2','anchors'),(new,'In2.Cu','AFTER In2','anchors')],(10.5,87.5,18,92),
    'Both boards refilled with identical project/rules. Annulus contact is measured after deducting holes; no thermal/current claim.',2400)
assert list(map(a.sha,(original,before,after)))==expected
result={'status':'SCOPED_SAVED_FILL_AND_GROUND_ANCHOR_PASS','input_hashes':dict(zip(('original','refilled_baseline','candidate'),expected)),
    'baseline_refill_changes_no_pad_track_via_or_zone_definition':True,'layers':layers,
    'new_via_local_ligament_review':ligaments,'rendered_views':[outer,inner],
    'limits':['Combined routing remains unfinished and the source C116/CHG collision is not approved.',
              'This reviews saved plane geometry and physical annulus contacts; no global current/thermal or EMC qualification.',
              'Final coordinated routing must be refilled and checked again.'], 'release':False}
(O/'review.json').write_text(json.dumps(result,indent=2)+'\n')
print(json.dumps({'status':result['status'],'layers':{k:{a:b for a,b in v.items()if 'components'not in a}for k,v in layers.items()}},indent=2))
