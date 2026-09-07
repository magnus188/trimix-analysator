"""Record the final sampled USB service result and delivery dimensions."""
import json
import build_rev03 as b

def run_metadata():
    _,d=b.get()
    report=json.loads((b.BASE/'verification'/'service-paths-usb-cover.json').read_text())
    usb=next(t for t in report['tests'] if t['name']=='usb')
    if usb['collision_count'] or usb['translation_waypoints_mm'][1][0]!=-12.4:
        raise RuntimeError('Expected the passing12.4 mm USB path before finalising metadata')
    sequence=('Disconnect harnesses and remove cover, carrier, closed chamber, battery, lower display retainer and USB housing clamp in the documented order. '
              'Translate the complete USB cartridge12.4 mm inward (-X), then rearward (+Z). '
              'Sampled rigid CAD path clear; actual tolerances, wire bends and hand access pending.')
    for c in d.allComponents:
        sub=c.attributes.itemByName(b.GROUP,'subassembly')
        if sub and sub.value=='removable USB insert':
            c.attributes.add(b.GROUP,'removal',sequence)
    d.rootComponent.attributes.add(b.GROUP,'usb_service',json.dumps({
        'sequence':sequence,'inward_translation_mm':12.4,
        'native_sampled_result':'clear_at_sampled_poses',
        'evidence':'verification/service-paths-usb-cover.json',
        'nominal_selected_clearances_mm':{'rear_M3_boss_to_faceplate_head':.3,'lower_retainer_bracket_to_panel_insert':.4},
        'limits':'Selected clearances are nominal; actual fabrication tolerances and continuous sweeps are not proven.'}))
    dimensions={
        'body_mm':{'height':125,'width':75,'depth':56},
        'overall_reference_mm':{'height':125,'width':87,'depth':57.65},
        'display_assembly_mm':{'height':116.8,'width':69.3,'depth':13.7},
        'occupied_holder_mm':{'height':80.4,'width':42,'depth':20.35},
        'display_assembly_front_area_percent':116.8*69.3/(125*75)*100,
        'active_display_front_area_percent':56.16*93.6/(125*75)*100,
        'body_box_volume_reduction_from_rev02_percent':(1-125*75*56/(180*95*60))*100,
        'note':'Overall reference includes provisional side gas fittings and external rear button-head screws. Final measured hardware projections pending.'}
    (b.BASE/'verification'/'delivery-dimensions.json').write_text(json.dumps(dimensions,indent=2)+'\n')
