"""Install manufacturer-land inductors and the approved cold-start ILIM value.

The original placements remain unchanged in this stage. Subsequent placement
checks may move local converter passives, never the approved oxygen connectors.
"""
from pathlib import Path
import sys,json,shutil
ROOT=Path(__file__).resolve().parents[3]
sys.path.insert(0,str(ROOT/'hardware/tools'))
from analyzer_sheet import *

OUT=Path(__file__).resolve().parent
LIB=P/'Trimix_Power.pretty'
STOCK=Path('/Applications/KiCad/KiCad.app/Contents/SharedSupport/footprints')
SELECTIONS={
 'L101':dict(value='1u / 74437349010',mpn='74437349010',maker='Würth Elektronik',
    footprint='Trimix_Power:L_Wurth_74437349010_7050',source='https://www.we-online.com/components/products/datasheet/74437349010.pdf',max_body_mm=[7.6,6.9,5.0]),
 'L201':dict(value='1.5u / XGL4030-152MEC',mpn='XGL4030-152MEC',maker='Coilcraft',
    footprint='Trimix_Power:L_Coilcraft_XGL4030',source='https://www.coilcraft.com/pdfs/xgl4030.pdf',max_body_mm=[4.3,4.3,3.1]),
 'L701':dict(value='1u / XGL4020-102MEC',mpn='XGL4020-102MEC',maker='Coilcraft',
    footprint='Trimix_Power:L_Coilcraft_XGL4020',source='https://www.coilcraft.com/pdfs/xgl4020.pdf',max_body_mm=[4.3,4.3,2.1]),
 'R103':dict(value='4.02k / 1% / cold <=100mA',mpn='RC0603FR-074K02L',maker='YAGEO',
    source='https://yageogroup.com/content/datasheet/asset/file/PYU-RC_GROUP_51_ROHS_L'),
}

def make_libs():
    for kind in ('4020','4030'):
        a=sx.loads((STOCK/'Inductor_SMD.pretty'/('L_Coilcraft_XxL'+kind+'.kicad_mod')).read_text())
        a[1]='L_Coilcraft_XGL'+kind
        child(a,'descr')[1]='Coilcraft XGL'+kind+'; manufacturer lands0.98x3.4mm, centers+/-1.185mm. Drawing02/19/26; model is family illustration.'
        # The stock land geometry was independently matched to the exact XGL sheet.
        assert [child(p,'size')[1:] for p in children(a,'pad')]==[[.98,3.4],[.98,3.4]]
        save(LIB/(a[1]+'.kicad_mod'),a)
    name='L_Wurth_74437349010_7050'
    a=node('footprint',name,node('version',20241229),node('generator','pcbnew'),node('layer','F.Cu'),
        node('descr','Würth74437349010 Rev003.000; 8.4mm outer land width,2.5mm gap,2.95x3.5mm pads. No top traces/vias beneath center restricted strip.'),
        node('attr',S('smd')))
    for key,val,y,layer,hide in [('Reference','REF**',-4.3,'F.SilkS',False),('Value',name,4.3,'F.Fab',True)]:
        a.append(node('property',key,val,node('at',0,y,0),node('layer',layer),effects(1,hide=hide)))
    for layer,x,y,w in [('F.Fab',3.65,3.3,.1),('F.CrtYd',4.5,3.7,.05)]:
        a.append(node('fp_rect',node('start',-x,-y),node('end',x,y),node('stroke',node('width',w),node('type',S('solid'))),node('layer',layer)))
    for n,x in [('1',-2.725),('2',2.725)]:
        a.append(node('pad',n,S('smd'),S('rect'),node('at',x,0),node('size',2.95,3.5),node('layers','F.Cu','F.Paste','F.Mask')))
    # Keep the center strip free of surface routing as specified on the manufacturer land drawing.
    a.append(node('zone',node('net',0),node('net_name',''),node('layer','F.Cu'),node('hatch',S('edge'),.5),
        node('connect_pads',node('clearance',0)),node('min_thickness',.25),node('filled_areas_thickness',S('no')),
        node('keepout',node('tracks',S('not_allowed')),node('vias',S('not_allowed')),node('pads',S('allowed')),node('copperpour',S('allowed')),node('footprints',S('allowed'))),
        node('polygon',node('pts',node('xy',-1.25,-3.3),node('xy',1.25,-3.3),node('xy',1.25,3.3),node('xy',-1.25,3.3)))))
    save(LIB/(name+'.kicad_mod'),a)

def run():
    before=OUT/'before-inductor-selection';before.mkdir(exist_ok=True)
    make_libs()
    for path in P.glob('*.kicad_sch'):
        a=sx.loads(path.read_text());changed=False
        for s in children(a,'symbol'):
            pr={x[1]:x for x in children(s,'property')};ref=pr['Reference'][2]
            if ref not in SELECTIONS:continue
            choice=SELECTIONS[ref];changed=True
            for k,v in {'Value':choice['value'],'MPN':choice['mpn'],'Manufacturer':choice['maker'],'Datasheet':choice['source'],
                        **({'Footprint':choice['footprint']} if 'footprint' in choice else {})}.items():
                if k in pr:pr[k][2]=v
                else:s.append(node('property',k,v,node('at',*child(s,'at')[1:]),effects(hide=True)))
        if changed:
            target=before/path.name
            if not target.exists():shutil.copy2(path,target)
            save(path,a)
    (OUT/'inductor-selection.json').write_text(json.dumps({'selected':SELECTIONS,'status':'schematic and exact land libraries; PCB sync pending',
        'manufacturer_curves_are_typical':True,'physical_thermal_tests_performed':False},indent=2)+'\n')

if __name__=='__main__':run()
