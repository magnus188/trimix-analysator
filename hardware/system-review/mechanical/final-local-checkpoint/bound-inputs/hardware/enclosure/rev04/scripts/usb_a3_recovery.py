"""Bounded recovery stages for A3 USB; no import-time CAD execution.

Use only after parent confirms the previous Fusion call has ended and the
owned A3 state is known. This module never deletes existing components. Each
stage guards against duplicates and writes before/after progress to a JSONL
file so a slow kernel operation can be located without another Fusion call.

Recovery deliberately omits the10degree entry taper andR0.20 transitions. The
straight nominal8.44x2.66 throat, stepped gasket seat and local1.80mm metal
section remain. This is a fit-study deviation, not a released connector seat.

Call bezel(), frame(), bridge(), pcb(), shell(), insulator(), gasket(),
contacts(), hardware(), interface() separately, in that order. Each completed
component is checkpointed. Do not run all stages in one MCP transaction.
"""
from datetime import datetime, timezone
from pathlib import Path
import json
import os

import adsk.core as core
import adsk.fusion as fusion
import build_a3 as base
import usb_a3 as original
from fusion_helpers import evaluate_cm

GROUP=original.GROUP
NAMES=original.NAMES
SOURCE=original.SOURCE
BASIS=original.BASIS
_v=original._v
LOG=Path(__file__).resolve().parents[1]/'verification'/'usb-recovery-progress.jsonl'
_STAGE='not_started'


def _log(phase,label):
    LOG.parent.mkdir(parents=True,exist_ok=True)
    record={'at_utc':datetime.now(timezone.utc).isoformat(),'stage':_STAGE,'phase':phase,'operation':label}
    with LOG.open('a',encoding='utf-8') as stream:
        stream.write(json.dumps(record)+'\n');stream.flush();os.fsync(stream.fileno())


def _call(label,function,*args,**kwargs):
    _log('begin',label)
    result=function(*args,**kwargs)
    _log('complete',label)
    return result


class _LoggedBuilder:
    """Instrument known geometry calls without modifying the shared builder."""
    def __getattr__(self,name):
        value=getattr(base,name)
        if name not in ('box','cyl','xbox','xcyl','ybox','ycyl','cut_tool','checkpoint'):
            return value
        def invoke(*args,**kwargs):
            label=(str(args[1]) if name!='checkpoint' and len(args)>1 else str(args[0]))
            return _call(name+': '+label,value,*args,**kwargs)
        return invoke


b=_LoggedBuilder()


def _begin(stage):
    global _STAGE
    _STAGE=stage
    _log('stage_begin',stage)
    b.get()


def _new(key,basis):
    return _call('new component: '+key,original._new,key,basis)


def _finish(stage):
    b.checkpoint('USB recovery — '+stage)
    _log('stage_complete',stage)


def _entry(c,body):
    _log('intentional_omission','10degree taper omitted; straight nominal throat retained')
    c.attributes.add(GROUP,'entry_geometry_status','Recovery fit reference:10degree taper andR0.20 transitions omitted. Reconcile manufacturer interface before fabrication.')


def _rounded(c, name, y, length, width, height, radius, op='new', target=None):
    """Expression-driven XZ rectangle extruded+Y and rounded on four Y edges.

    A single tool body is consumed by each Cut/Join. The rectangle is fully
    constrained by the established shared-point helper; no coincident free
    profile points or initial-position fixes are introduced.
    """
    if radius <= 0 or 2 * radius >= min(width,height):
        raise ValueError('Rounded prism must have four nonzero straight sides')
    existing = target
    if op == 'join' and existing is None:
        if c.bRepBodies.count != 1:
            raise RuntimeError('Rounded Join needs one unambiguous existing body')
        existing = c.bRepBodies.item(0)
    if op == 'cut' and existing is None:
        raise ValueError('Rounded Cut requires an explicit target')
    tool = b.ybox(c,name+' rectangular stock',f'UsbX-({_v(width/2)})',y,
                  f'UsbZ-({_v(height/2)})',_v(width),length,_v(height))
    edges = core.ObjectCollection.create()
    span = abs(evaluate_cm(c,length))
    for edge in tool.edges:
        if not edge.startVertex or not edge.endVertex:
            continue
        p,q = edge.startVertex.geometry,edge.endVertex.geometry
        if (abs(p.x-q.x)<1e-7 and abs(p.z-q.z)<1e-7
                and abs(abs(p.y-q.y)-span)<1e-7):
            edges.add(edge)
    if edges.count != 4:
        raise RuntimeError('Expected four Y edges for rounded USB prism: '+name)
    request = c.features.filletFeatures.createInput()
    request.edgeSetInputs.addConstantRadiusEdgeSet(edges,core.ValueInput.createByString(_v(radius)),False)
    feature = _call(name+' / four longitudinal corner fillets',c.features.filletFeatures.add,request)
    feature.name = name+' corner rounds'
    tool.name = name
    if op == 'new':
        return tool
    collection = core.ObjectCollection.create(); collection.add(tool)
    request = c.features.combineFeatures.createInput(existing,collection)
    request.operation = (fusion.FeatureOperations.CutFeatureOperation if op == 'cut'
                         else fusion.FeatureOperations.JoinFeatureOperation)
    request.isKeepToolBodies = False
    feature = _call(name+' / explicit '+op+' Boolean',c.features.combineFeatures.add,request); feature.name = name
    if feature.bodies.count != 1:
        raise RuntimeError('USB rounded operation split the target: '+name)
    return feature.bodies.item(0)



def bezel():
    _begin('bezel')
    bezel = _new('bezel', 'Designed metal bezel14x8mm visible, hidden20x11mm flange; local drawing1.80mm seat. Material/process/seals pending.')
    bb = _rounded(bezel, 'Tiny flush metal bezel', '0 mm','2.4 mm',14,8,.8)
    b.ybox(bezel,'Hidden metal flange','UsbX-10 mm','2.4 mm','UsbZ-5 mm',
           '20 mm','2 mm','11 mm','join')
    b.ybox(bezel,'Metal seat rear relief to local1.80mm panel','UsbX-6.5 mm','1.8 mm','UsbZ-3.5 mm',
           '13 mm','2.7 mm','7 mm','cut',bb)
    _rounded(bezel,'GCT8.44x2.66 throat R1.05','-0.05 mm','1.9 mm',8.44,2.66,1.05,'cut',bb)
    _rounded(bezel,'GCT9.14x3.35 inner lip R1.39','1.63 mm','.18 mm',9.14,3.35,1.39,'cut',bb)
    _rounded(bezel,'GCT9.64x3.86 gasket seat R1.65','1.13 mm','.5 mm',9.64,3.86,1.65,'cut',bb)
    _entry(bezel,bb)
    bezel.attributes.add(GROUP,'seal_limits','Drawing nominal section1.80mm; lip0.17mm; gasket seat0.50mm; 10degree entry omitted in recovery fit model. R0.20 transitions omitted. Gasket compression and bezel-to-housing seam unqualified.')
    _finish('bezel')

def frame():
    _begin('frame')
    frame = _new('frame','Designed printed cartridge; floor2mm, boss OD7.3 around3.3mm pilot. Local nominal walls only, not global wall certification.')
    fb = b.box(frame,'USB printed frame floor','UsbX-12.9 mm','2.4 mm','UsbZ-7 mm',
               '25.8 mm','19.5 mm','2 mm')
    b.box(frame,'USB front flange backing wall','UsbX-12.9 mm','4.4 mm','UsbZ-5 mm',
          '25.8 mm','2 mm','10.2 mm','join')
    b.box(frame,'PCB and shell clear backing opening','UsbX-6.5 mm','4.3 mm','UsbZ-3.2 mm',
          '13 mm','2.2 mm','6.4 mm','cut',fb)
    for x in ('UsbX-9.25 mm','UsbX+9.25 mm'):
        b.cyl(frame,'USB M2 insert boss',x,'18.25 mm','UsbZ-7 mm','3.65 mm','12.2 mm','join')
        b.cyl(frame,'USB insert pilot reference',x,'18.25 mm','UsbZ+0.95 mm',
              '1.65 mm','4.35 mm','cut',fb)
    for x in ('UsbX-5.1 mm','UsbX+3.1 mm'):
        b.box(frame,'PCB rear ledge support',x,'16 mm','UsbZ-5 mm','2 mm','2 mm','2.7 mm','join')
    b.box(frame,'PCB supported rear edge ledge','UsbX-5.1 mm','16 mm','UsbZ-2.3 mm',
          '10.2 mm','2 mm','2 mm','join')
    _finish('frame')

def bridge():
    _begin('bridge')
    bridge = _new('bridge','Designed metal common bridge and PCB edge capture; two M2 screws. Positive solder-tab/PCB load path requires physical qualification.')
    rb = b.box(bridge,'Hidden USB common retaining bridge','UsbX-12.9 mm','5 mm','UsbZ+5.2 mm',
               '25.8 mm','16.9 mm','2 mm')
    b.box(bridge,'Hidden flange top capture lip','UsbX-10 mm','3.6 mm','UsbZ+6 mm',
          '20 mm','2.8 mm','1.2 mm','join')
    b.box(bridge,'PCB rear edge stop','UsbX-5.1 mm','18 mm','UsbZ-0.3 mm',
          '10.2 mm','2 mm','7.5 mm','join')
    for x in ('UsbX-5.1 mm','UsbX+3.1 mm'):
        b.box(bridge,'PCB upper capture stalk',x,'16 mm','UsbZ+2.3 mm','2 mm','2 mm','2.9 mm','join')
    b.box(bridge,'PCB upper capture pad','UsbX-5.1 mm','16 mm','UsbZ+0.3 mm',
          '10.2 mm','2 mm','2 mm','join')
    for x in ('UsbX-9.25 mm','UsbX+9.25 mm'):
        b.cyl(bridge,'Rear accessible USB M2 screw clearance',x,'18.25 mm','UsbZ+5.1 mm',
              '1.1 mm','2.2 mm','cut',rb)
    _finish('bridge')

def pcb():
    _begin('pcb')
    pcb = _new('pcb','Provisional 16x13.6x0.60mm daughterboard with straddle and support clearances. Routing, solder lands and fabrication outline pending.')
    pb = b.box(pcb,'USB supported0.60mm daughterboard','UsbX-8 mm','4.4 mm','UsbZ-0.3 mm',
               '16 mm','13.6 mm','.6 mm')
    for x in ('UsbX-8.1 mm','UsbX+6.3 mm'):
        b.box(pcb,'Board front shoulder backing relief',x,'4.3 mm','UsbZ-0.4 mm',
              '1.8 mm','2.1 mm','.8 mm','cut',pb)
    b.box(pcb,'Connector straddle relief footprint provisional','UsbX-4.63 mm','4.3 mm','UsbZ-0.4 mm',
          '9.26 mm','4.4 mm','.8 mm','cut',pb)
    for x in ('UsbX-9.25 mm','UsbX+9.25 mm'):
        b.cyl(pcb,'PCB rear corner insert boss clearance',x,'18.25 mm','UsbZ-0.4 mm',
              '3.85 mm','.8 mm','cut',pb)
    _finish('pcb')

def shell():
    _begin('shell')
    shell = _new('shell',BASIS)
    sb = _rounded(shell,'USB stainless main shell reference','2.1 mm','5.4 mm',8.34,3.26,1.05)
    _rounded(shell,'USB nose reference','1 mm','1.1 mm',8.34,2.56,1.05,'join')
    _rounded(shell,'USB shell rear cavity simplified','2.1 mm','5.5 mm',7.94,2.86,.85,'cut',sb)
    _rounded(shell,'USB nose inner cavity simplified','.9 mm','1.3 mm',7.94,2.16,.85,'cut',sb)
    for y in ('3.9 mm','5.9 mm'):
        for x in ('UsbX-5.65 mm','UsbX+4.12 mm'):
            b.box(shell,'USB grounding wing reference',x,y,'UsbZ+0.3 mm','1.53 mm','1.3 mm','.3 mm','join')
    shell.partNumber = 'USB4720-03-A-DRAWING-REFERENCE'
    _finish('shell')

def insulator():
    _begin('insulator')
    insulator = _new('insulator',BASIS+' Insulating tongue geometry simplified.')
    _rounded(insulator,'USB rear insulator','6.6 mm','1 mm',7.8,2.1,.5)
    b.box(insulator,'USB tongue6.69x0.70 reference','UsbX-3.345 mm','1.2 mm','UsbZ-0.35 mm',
          '6.69 mm','5.4 mm','.7 mm','join')
    _finish('insulator')

def gasket():
    _begin('gasket')
    gasket = _new('gasket',BASIS+' Uncompressed silicone reference; no seal simulation.')
    gb = _rounded(gasket,'USB LIM gasket reference','1.2 mm','.4 mm',9.5,3.72,1.5)
    _rounded(gasket,'USB gasket inner shell clearance','1.19 mm','.42 mm',8.38,2.60,1.07,'cut',gb)
    _finish('gasket')

def contacts():
    _begin('contacts')
    contacts = _new('contacts','Illustrative contact stripes only; not pin geometry or footprint.')
    for z in ('UsbZ-0.38 mm','UsbZ+0.35 mm'):
        for i in range(8):
            b.box(contacts,'USB visual contact stripe',f'UsbX+({_v(-1.875+i*.5)})','1.3 mm',z,
                  '.25 mm','2.7 mm','.03 mm')
    _finish('contacts')

def hardware():
    _begin('hardware')
    _,d=b.get()
    if d.rootComponent.attributes.itemByName(GROUP,'usb_a3'):
        raise RuntimeError('USB hardware/metadata already present; inspect before retry')
    _call('two M2 screws and inserts', original._hardware)
    d.rootComponent.attributes.add(GROUP,'usb_a3',json.dumps({
        'source':SOURCE,'supplier_cad':False,'entry_axis':'-Y','visible_bezel_mm':[14,8],
        'panel_reference_mm':1.8,'pcb_thickness_mm':.6,'installed_screws':'2xM2x5',
        'reserve_mm':{'x':'UsbX +/-12.9','y':[0,21.9],'z':'UsbZ-7 .. UsbZ+9.2'},
        'thread_overlap_mm':3,'screw_tip_to_insert_front_mm':1,
        'candidate_removal':[[0,2.5,0],[0,0,60]],
        'prerequisites':['rear cover and captured key removed','battery disconnected and removed',
                         'cable disconnected','PCB/carrier USB service corner X50.2..56.2,Y20.4..25.2 clear'],
        'validation':'CAD service/interference checks pending; electrical/load/seal validation pending'}))
    d.rootComponent.attributes.add(GROUP,'usb_recovery_entry_status','10degree taper omitted; straight nominal throat retained; manufacture pending interface reconciliation')
    _finish('hardware')

def interface():
    """Add housing aperture/support floor and cover-owned L-shaped capture key.

    Removing the cover removes the key. The cartridge then needs only2.5mm
    inward translation to clear the2.4mm wall before rearward withdrawal.
    The independent metal/PCB cartridge establishes its panel spacing; the
    outer cover key retains the assembly without claiming seal compression.
    """
    _begin('interface')
    housing = b.comp('01 Shape A housing')
    if housing.attributes.itemByName(GROUP,'usb_interface_added'):
        raise RuntimeError('USB interface already exists')
    b.comp(NAMES['frame'])
    hb = housing.bRepBodies.item(0)
    _rounded(housing,'Bottom tiny bezel aperture with0.2mm clearance','-.3 mm','2.8 mm',
             14.4,8.4,1.0,'cut',hb)
    b.box(housing,'Fixed USB cartridge support floor','UsbX-13.1 mm','2.3 mm','UsbZ-9 mm',
          '26.2 mm','19.7 mm','2 mm','join')
    cover = b.comp('02 Single rear cover')
    b.box(cover,'USB inward retention key integral to rear cover','UsbX-5.1 mm','22.4 mm','UsbZ+5.2 mm',
          '10.2 mm','2 mm','CaseDepth-Cover+CoverGap-(UsbZ+5.2 mm)+0.1 mm','join')
    b.box(cover,'USB rearward retention pad integral to rear cover','UsbX-5.1 mm','20 mm','UsbZ+7.7 mm',
          '10.2 mm','4.4 mm','CaseDepth-Cover+CoverGap-(UsbZ+7.7 mm)+0.1 mm','join')
    housing.attributes.add(GROUP,'usb_interface_added','true')
    housing.attributes.add(GROUP,'usb_support_limits','Nominal2mm fixed support floor; tiny14.4x8.4 aperture; bezel-to-housing seam unqualified. Cover captures cartridge with0.5mm nominal axial/rear stop gaps.')
    _finish('interface')


def run(_context):
    raise RuntimeError('Execute one named recovery stage per Fusion call')
