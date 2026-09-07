"""Native KiCad review-sheet construction, shared by the A2 generators.

Explicit pin/net intent is saved separately and checked against KiCad's CLI.
Coordinates are millimetres; library pins use KiCad's Y-up convention.
"""
from pathlib import Path
import copy, json, math, uuid
import sexpdata as sx

HW = Path(__file__).resolve().parents[1]
P = HW / 'kicad/analyzer'
VERIFY = HW / 'verification/analyzer'
LIBS = Path('/Applications/KiCad/KiCad.app/Contents/SharedSupport/symbols')
PROJECT = 'Trimix_Analyzer'
ROOT_UUID = str(uuid.uuid5(uuid.NAMESPACE_URL, 'trimix:analyzer:A2:root'))
S = sx.Symbol
def node(name, *args): return [S(name), *args]
def tag(v): return str(v[0]) if isinstance(v, list) and v else ''
def child(v, name): return next((x for x in v if tag(x)==name), None)
def children(v, name): return [x for x in v if tag(x)==name]
def uid(): return str(uuid.uuid4())
def sheet_uuid(name): return str(uuid.uuid5(uuid.NAMESPACE_URL, 'trimix:analyzer:A2:'+name))
def fmt(a, level=0):
    if not isinstance(a,list): return sx.dumps(a)
    if not any(isinstance(v,list) for v in a): return sx.dumps(a)
    first=next(i for i,v in enumerate(a) if isinstance(v,list))
    return '('+' '.join(sx.dumps(v) for v in a[:first])+'\n'+'\n'.join('\t'*(level+1)+fmt(v,level+1) for v in a[first:])+'\n'+'\t'*level+')'
def save(path, a): Path(path).write_text(fmt(a)+'\n')
def effects(size=1.016, justify=None, bold=False, hide=False):
    font=node('font',node('size',size,size))
    if bold: font.append(node('bold',S('yes')))
    e=node('effects',font)
    if justify: e.append(node('justify',*[S(v) for v in justify.split()]))
    if hide:e.append(node('hide',S('yes')))
    return e

_lib_cache={}
def library_symbol(lib_id):
    lib,name=lib_id.split(':',1)
    if lib not in _lib_cache:
        path=(P/(lib+'.kicad_sym')) if (P/(lib+'.kicad_sym')).exists() else LIBS/(lib+'.kicad_sym')
        _lib_cache[lib]=sx.loads(path.read_text())
    a=copy.deepcopy(next(v for v in children(_lib_cache[lib],'symbol') if v[1]==name))
    ext=child(a,'extends')
    if ext:
        base=library_symbol(lib+':'+ext[1]); old=base[1].split(':')[-1]
        for unit in children(base,'symbol'):
            unit[1]=name+unit[1][len(old):]
        props={p[1] for p in children(a,'property')}
        base[:]=[v for v in base if not(tag(v)=='property' and v[1] in props)]
        base.extend(copy.deepcopy(v) for v in a[2:] if tag(v) not in {'extends','symbol'})
        a=base
    a[1]=lib_id
    return a

def custom_symbol(name, pins, bounds=(-10.16,-12.7,10.16,12.7), description='', datasheet=''):
    """pins: (number,name,electrical_type,x,y,angle), body coordinates Y-up."""
    ident='Trimix_Analyzer:'+name
    a=node('symbol',ident,node('pin_names',node('offset',0.762)),node('in_bom',S('yes')),node('on_board',S('yes')),
        node('property','Reference','U',node('at',0,16.51,0),effects()),
        node('property','Value',name,node('at',0,13.97,0),effects()),
        node('property','Footprint','',node('at',0,0,0),effects(hide=True)),
        node('property','Datasheet',datasheet,node('at',0,0,0),effects(hide=True)),
        node('property','Description',description,node('at',0,0,0),effects(hide=True)))
    x1,y1,x2,y2=bounds
    body=node('symbol',name+'_0_1',node('rectangle',node('start',x1,y1),node('end',x2,y2),node('stroke',node('width',0.254),node('type',S('default'))),node('fill',node('type',S('background')))))
    unit=node('symbol',name+'_1_1')
    for number,pname,ptype,x,y,angle in pins:
        unit.append(node('pin',S(ptype),S('line'),node('at',x,y,angle),node('length',2.54),node('name',pname,effects()),node('number',str(number),effects())))
    a.extend([body,unit]);return a

class Sheet:
    def __init__(self,name,page,title,subtitle='',paper='A3'):
        P.mkdir(parents=True,exist_ok=True); VERIFY.mkdir(parents=True,exist_ok=True)
        self.name=name;self.page=page;self.path=P/(name+'.kicad_sch');self.intent={};self.pins={};self.done=set();self.segments=[]
        self.a=node('kicad_sch',node('version',20260101),node('generator','eeschema'),node('generator_version','10.0'),node('uuid',sheet_uuid(name)),node('paper',paper),
          node('title_block',node('title',title),node('date','2026-09-05'),node('rev','A2'),node('company','Trimix'),node('comment',1,'Engineering review draft — not released for manufacture')),node('lib_symbols'))
        self.text(title.upper(),20.32,22.86,2.54,True)
        if subtitle:self.text(subtitle,20.32,34.29,1.27)
    def instance(self,ref):
        return node('instances',node('project',PROJECT,node('path','/'+ROOT_UUID+'/'+sheet_uuid(self.name),node('reference',ref),node('unit',1))))
    def add(self,lib_id,ref,value,x,y,nets,footprint=None,angle=0,dnp=False,on_board=True,in_bom=True,custom=None,autowire=True,field_at=None,properties=None):
        lib=copy.deepcopy(custom) if custom is not None else library_symbol(lib_id)
        lib_id=lib[1]
        libs=child(self.a,'lib_symbols')
        if not any(v[1]==lib_id for v in children(libs,'symbol')):libs.append(lib)
        props={p[1]:p[2] for p in children(lib,'property')}
        sy=node('symbol',node('lib_id',lib_id),node('at',x,y,angle),node('unit',1),node('in_bom',S('yes' if in_bom else 'no')),node('on_board',S('yes' if on_board else 'no')),node('dnp',S('yes' if dnp else 'no')),node('uuid',uid()))
        fx,fy=field_at or (x+7.62,y-5.08)
        for key,val,xx,yy,hide in [('Reference',ref,fx,fy,ref.startswith('#')),('Value',value,fx,fy+2.54,ref.startswith('#')),('Footprint',footprint if footprint is not None else props.get('Footprint',''),x,y,True),('Datasheet',props.get('Datasheet',''),x,y,True),('Description',props.get('Description',''),x,y,True)]:
            sy.append(node('property',key,val,node('at',xx,yy,angle),effects(1.016,'left',hide=hide)))
        for key,val in (properties or {}).items():sy.append(node('property',key,str(val),node('at',x,y,0),effects(hide=True)))
        self.pins[ref]={}
        r=math.radians(angle)
        for unit in children(lib,'symbol'):
            for pin in children(unit,'pin'):
                no=str(child(pin,'number')[1]);at=child(pin,'at');px,py,pa=at[1:]
                wx=round(x+px*math.cos(r)-py*math.sin(r),5);wy=round(y-px*math.sin(r)-py*math.cos(r),5)
                self.pins[ref][no]={'x':wx,'y':wy,'angle':(pa+angle)%360,'type':str(pin[1]),'name':child(pin,'name')[1]}
                sy.append(node('pin',no,node('uuid',uid())))
        nets={str(k):v for k,v in nets.items()}
        assert set(nets)==set(self.pins[ref]),(self.name,ref,'missing',set(self.pins[ref])-set(nets),'extra',set(nets)-set(self.pins[ref]))
        self.intent[ref]=nets;sy.append(self.instance(ref));self.a.append(sy)
        if autowire:self.connect(ref)
        return sy
    def pin(self,ref,number):
        p=self.pins[ref][str(number)];return (p['x'],p['y'])
    def wire(self,*points):
        for a,b in zip(points,points[1:]):
            a=tuple(a);b=tuple(b)
            if a==b:continue
            assert a[0]==b[0] or a[1]==b[1],(a,b)
            self.segments.append((a,b))
            self.a.append(node('wire',node('pts',node('xy',*a),node('xy',*b)),node('stroke',node('width',0),node('type',S('default'))),node('uuid',uid())))
    def label(self,net,xy,angle=0,global_label=True):
        label=node('global_label' if global_label else 'label',net)
        if global_label:label.append(node('shape',S('bidirectional')))
        label.extend([node('at',*xy,angle),effects(1.016,'left' if angle in (0,90) else 'right'),node('uuid',uid())])
        if global_label:label.append(node('property','Intersheetrefs','${INTERSHEET_REFS}',node('at',*xy,angle),effects(hide=True)))
        self.a.append(label)
    def connect(self,ref,stub=5.08):
        for no,net in self.intent[ref].items():
            if (ref,no) in self.done:continue
            self.done.add((ref,no));p=self.pins[ref][no];xy=(p['x'],p['y'])
            if net is None:
                self.a.append(node('no_connect',node('at',*xy),node('uuid',uid())));continue
            # Pins point into the body; wires leave in the opposite direction.
            a=p['angle'];dx=round(-math.cos(math.radians(a)));dy=round(math.sin(math.radians(a)))
            end=(round(xy[0]+dx*stub,5),round(xy[1]+dy*stub,5));self.wire(xy,end)
            # Keep label text outside the component, away from the pin body.
            self.label(net,end,180 if dx<0 else 0 if dx>0 else 270 if dy>0 else 90)
    def text(self,text,x,y,size=1.016,bold=False):
        self.a.append(node('text',text,node('at',x,y,0),effects(size,'left top',bold),node('uuid',uid())))
    def box(self,x,y,w,h,title,note=None):
        self.a.append(node('rectangle',node('start',x,y),node('end',x+w,y+h),node('stroke',node('width',0.254),node('type',S('default'))),node('fill',node('type',S('none'))),node('uuid',uid())))
        self.text(title,x+3.81,y+5.08,1.524,True)
        if note:self.text(note,x+3.81,y+h-7.62,1.016)
    def flag(self,net,x,y,ref):
        return self.add('power:PWR_FLAG',ref,'PWR_FLAG',x,y,{'1':net},in_bom=False,on_board=False)
    def finish(self):
        for ref in self.intent:self.connect(ref)
        # Junctions at three-way connections, including endpoint-on-segment.
        for p in set(p for seg in self.segments for p in seg):
            count=0
            for a,b in self.segments:
                if p in (a,b):count+=1
                elif (a[0]==b[0]==p[0] and min(a[1],b[1])<p[1]<max(a[1],b[1])) or (a[1]==b[1]==p[1] and min(a[0],b[0])<p[0]<max(a[0],b[0])):count+=2
            if count>=3:self.a.append(node('junction',node('at',*p),node('diameter',0),node('color',0,0,0,0),node('uuid',uid())))
        save(self.path,self.a)
        (VERIFY/(self.name+'-intent.json')).write_text(json.dumps(self.intent,indent=2)+'\n')
        return self.path
    save=finish
