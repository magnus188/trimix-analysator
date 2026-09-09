"""Revision 03 mechanical fittings. Execute only in the owned Fusion design."""
import json
import build_rev03 as b
from hardware_details import screw_instances, insert_instances

def fit_parameters():
    _,d=b.get()
    for n,e in [('CaseDepth','56 mm'),('ChamberFront','16.5 mm'),
                ('ChamberRear','CaseDepth-Cover-2.8 mm'),('HolderZ','16.7 mm'),('ButtonZ','44.5 mm')]:
        d.userParameters.itemByName(n).expression=e
    b.checkpoint('56 mm mechanical stack')

def rear_fasteners():
    _,d=b.get(); root=d.rootComponent
    c=b.comp('01 Tapered printed housing'); body=c.bRepBodies.item(0)
    cover=b.comp('02 Single rear cover'); cb=cover.bRepBodies.item(0)
    points=[('6 mm','6 mm'),('CaseWidth-6 mm','6 mm'),
            ('6 mm','CaseHeight-6 mm'),('CaseWidth-6 mm','CaseHeight-6 mm')]
    for x,y in points:
        b.cyl(c,'Rear M3 boss',x,y,'CaseDepth-13 mm','4.2 mm','8.6 mm','join')
        b.cyl(c,'M3 insert pocket — supplier fit TBD',x,y,'CaseDepth-9.85 mm',
              '2.15 mm','5.55 mm','cut',body)
        b.cyl(cover,'Local 2 mm screw bearing pad',x,y,'CaseDepth-3.65 mm',
              '5.2 mm','2 mm','join')
        b.cyl(cover,'Rear M3 through clearance',x,y,'CaseDepth-3.75 mm','1.7 mm','4 mm','cut',cb)
        b.cyl(cover,'Recessed M3 button head',x,y,'CaseDepth-1.65 mm','3.05 mm','1.8 mm','cut',cb)
        b.cyl(c,'Rear cover bearing pad clearance',x,y,'CaseDepth-3.75 mm','5.3 mm','1.5 mm','cut',body)
    positions=[(b.mm(d,x),b.mm(d,y),b.mm(d,'CaseDepth-1.65 mm')) for x,y in points]
    screws=screw_instances(root,'M3',8,positions,label='Rear cover M3x8')
    inserts=insert_instances(root,'M3',[(x,y,b.mm(d,'CaseDepth-4.4 mm')) for x,y,z in positions])
    for o,(x,y) in zip(screws,points): o.attributes.add(b.GROUP,'position_expressions',json.dumps([x,y,'CaseDepth-1.65 mm']))
    for o,(x,y) in zip(inserts,points): o.attributes.add(b.GROUP,'position_expressions',json.dumps([x,y,'CaseDepth-4.4 mm']))
    b.checkpoint('rear fasteners')

def cover_pad_fit():
    c=b.comp('01 Tapered printed housing'); body=c.bRepBodies.item(0)
    for x in ('6 mm','CaseWidth-6 mm'):
        for y in ('6 mm','CaseHeight-6 mm'):
            b.cyl(c,'Rear cover bearing pad clearance',x,y,'CaseDepth-3.75 mm','5.3 mm','1.5 mm','cut',body)
    b.checkpoint('cover bearing pad fit')

def carrier():
    _,d=b.get(); root=d.rootComponent
    shell=b.comp('01 Tapered printed housing'); sb=shell.bRepBodies.item(0)
    # Rear-of-battery supports attach to the case walls; none passes through the pack.
    pts=[(6,18),(6,77),(40,14)]
    b.box(shell,'Carrier bottom wall bracket','36.2 mm','2.1 mm','37.65 mm','7.6 mm','12 mm','6 mm','join')
    for x,y in pts:
        b.cyl(shell,'Carrier M2 boss',f'{x} mm',f'{y} mm','37.65 mm','3.8 mm','6 mm','join')
        b.cyl(shell,'Carrier insert pocket',f'{x} mm',f'{y} mm','39.65 mm','1.65 mm','4.1 mm','cut',sb)
    c=b.new('Carrier / removable electronics plate',
            '2 mm printed carrier; future PCB and disconnect notches, procurement pending')
    cb=b.box(c,'Shaped electronics carrier','2.7 mm','10.4 mm','43.65 mm','40.9 mm','73.2 mm','2 mm')
    p=b.new('Carrier / future PCB allocation — layout pending',
            'Space allocation only; no claim that the charging and sensor circuitry is routed or fitted')
    pb=b.box(p,'Reshaped future PCB','3.6 mm','12 mm','45.65 mm','39.4 mm','70.4 mm','1.6 mm')
    for cc,bb in [(c,cb),(p,pb)]:
        b.box(cc,'Right button and terminal service notch','2 mm','37 mm','43.5 mm','24 mm','16 mm','4 mm','cut',bb)
        b.box(cc,'Battery disconnect access notch','28 mm','67 mm','43.5 mm','16 mm','17 mm','4 mm','cut',bb)
        for x,y in pts:
            b.cyl(cc,'Shared M2 mounting clearance',f'{x} mm',f'{y} mm','43.5 mm','1.2 mm','4 mm','cut',bb)
    # Low, sparse package references keep component height and the plug opening visible.
    for name,x,y,w,h,t in [('Power-stage allocation',12,18,20,13,3.5),
                          ('Analog allocation',28,40,12,19,2.5),
                          ('Digital allocation',12,57,12,8,2)]:
        b.box(p,name,f'{x} mm',f'{y} mm','47.25 mm',f'{w} mm',f'{h} mm',f'{t} mm')
    screw_instances(root,'M2',7,[(x,y,47.25) for x,y in pts],label='Carrier and PCB M2x7')
    insert_instances(root,'M2',[(x,y,43.65) for x,y in pts])
    c.attributes.add(b.GROUP,'service','Disconnect battery first; remove these three screws; lift carrier and PCB rearward')
    b.checkpoint('carrier')

def retainers():
    _,d=b.get(); root=d.rootComponent
    shell=b.comp('01 Tapered printed housing'); sb=shell.bRepBodies.item(0)
    b.box(shell,'Lower display retainer wall bracket','48.2 mm','2.1 mm','14.3 mm',
          '7.6 mm','9 mm','6 mm','join')
    pts=[(52,11),(14,119)]
    for x,y in pts:
        b.cyl(shell,'Display retainer M2 boss',f'{x} mm',f'{y} mm','14.3 mm','3.8 mm','6 mm','join')
        b.cyl(shell,'Display retainer insert pocket',f'{x} mm',f'{y} mm','16.3 mm','1.65 mm','4.1 mm','cut',sb)
    for name,x,y,px,py,pw,ph,sx,sy in [
        ('lower',52,11,48.6,7.5,11.4,7,58,5.5),
        ('upper',14,119,8,115.5,9.4,7,8,117)]:
        c=b.new('Display / '+name+' removable retainer concept',
                'Rear-release concept. Factory frame capture lip, pad contact and preload require measurement; not a validated display fastening detail')
        body=b.box(c,name+' clip screw seat',f'{px} mm',f'{py} mm','20.3 mm',f'{pw} mm',f'{ph} mm','2 mm')
        b.box(c,'Flat frame contact provision',f'{sx} mm',f'{sy} mm','14.2 mm','2 mm','4 mm','8.1 mm','join')
        b.cyl(c,'M2 retainer clearance',f'{x} mm',f'{y} mm','20.2 mm','1.2 mm','2.2 mm','cut',body)
        c.attributes.add(b.GROUP,'service','Remove chamber and rear carrier as needed; release screw from rear and lift clip rearward; display then exits front. Confirm factory capture lip before fabrication.')
    screw_instances(root,'M2',5,[(x,y,22.3) for x,y in pts],label='Display retainer M2x5')
    insert_instances(root,'M2',[(x,y,20.3) for x,y in pts])
    b.checkpoint('display retainer concepts')

def button():
    c=b.new('Controls / right 1NO power button body',
            '12 mm purchased button; barrel, nut and terminals are conservative unmeasured references')
    b.xcyl(c,'12 mm button barrel','0.15 mm','ButtonY','ButtonZ','5.8 mm','17.85 mm')
    b.xcyl(c,'External button bezel','-1.5 mm','ButtonY','ButtonZ','7 mm','1.5 mm')
    b.xbox(c,'Button terminal block allowance','18 mm','ButtonY-4 mm','ButtonZ-4 mm','7 mm','8 mm','8 mm')
    cap=b.new('Controls / green momentary power cap')
    b.xcyl(cap,'Green 1NO button face','-1.7 mm','ButtonY','ButtonZ','4.5 mm','0.2 mm')
    b.checkpoint('right power button')
