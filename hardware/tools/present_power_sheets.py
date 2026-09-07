"""Presentation-only layout pass over the archived P1 schematic.

Preserves symbols, values, footprints, pins and electrical net intent.
Refuses to overwrite changes outside the known seed/last generated layout.
Run with the KiCad MCP venv Python (sexpdata).
"""
from pathlib import Path
from zipfile import ZipFile
from hashlib import sha256
import copy, json, uuid
import sexpdata as sx

HW=Path(__file__).resolve().parents[1]
P=HW/'kicad/power'
V=HW/'verification/power'
SEED=V/'before-presentation-layout.zip'
MANIFEST=V/'presentation-layout.json'
S=sx.Symbol
def n(t,*args):return [S(t),*args]
def tag(v):return str(v[0]) if isinstance(v,list) and v else ''
def cs(v,t):return [x for x in v if tag(x)==t]
def c(v,t):return next((x for x in v if tag(x)==t),None)
def uid():return str(uuid.uuid4())
def fmt(a,lev=0):
    if not isinstance(a,list):return sx.dumps(a)
    if not any(isinstance(v,list) for v in a):return sx.dumps(a)
    first=next(i for i,v in enumerate(a) if isinstance(v,list))
    return '('+' '.join(sx.dumps(v) for v in a[:first])+'\n'+'\n'.join('\t'*(lev+1)+fmt(v,lev+1) for v in a[first:])+'\n'+'\t'*lev+')'
def eff(size=1.27,bold=False,justify='left top'):
    f=n('font',n('size',size,size))
    if bold:f.append(n('bold',S('yes')))
    e=n('effects',f)
    if justify:e.append(n('justify',*[S(x) for x in justify.split()]))
    return e
def text(a,t,x,y,size=1.27,bold=False,justify='left top'):
    a.append(n('text',t,n('at',x,y,0),eff(size,bold,justify),n('uuid',uid())))
def line(a,pts,width=.254,style='default'):
    a.append(n('polyline',n('pts',*[n('xy',*p) for p in pts]),n('stroke',n('width',width),n('type',S(style))),n('fill',n('type',S('none'))),n('uuid',uid())))
def rect(a,x,y,w,h,width=.254):
    a.append(n('rectangle',n('start',x,y),n('end',round(x+w,4),round(y+h,4)),n('stroke',n('width',width),n('type',S('default'))),n('fill',n('type',S('none'))),n('uuid',uid())))
def panel(a,number,title,x,y,w,h):
    rect(a,x,y,w,h)
    line(a,[(x,y+8.89),(x+w,y+8.89)],.1524)
    text(a,f'{number:02d}  {title}',x+3.81,y+2.54,1.778,True)
def header(a,kicker,title,subtitle):
    text(a,kicker,20.32,15.24,1.143,True)
    text(a,title,20.32,22.86,3.048,True)
    text(a,subtitle,20.32,34.29,1.27)
    edge=401.32 if c(a,'paper')[1]=='A3' else 281.94
    line(a,[(20.32,41.91),(edge,41.91)],.381)
def field(sy,key,x,y,angle=0,justify=None,size=1.27):
    p=next(v for v in cs(sy,'property') if v[1]==key)
    c(p,'at')[1:]=[x,y,angle]
    p[:]=[x for x in p if tag(x)!='effects']+[eff(size,False,justify)]

def offset(sheet,x,y):
    if sheet=='Charging':
        if y>=139.7:return (0,25.4)
        if x<130:return (0,12.7)
    if sheet=='Supply_5V' and x<120 and y>122.55:return (0,25.4)
    if sheet=='Gauge_Interface' and x<210:
        if y<115:return (0,10.16)
        if y>120:return (0,19.05)
    return (0,0)
def point(sheet,p):
    dx,dy=offset(sheet,*p)
    return [round(p[0]+dx,4),round(p[1]+dy,4)]
def translate(a,name):
    additions=[]
    for obj in a:
        kind=tag(obj)
        if kind=='symbol':
            at=c(obj,'at'); dx,dy=offset(name,at[1],at[2]);at[1]+=dx;at[2]+=dy
            for prop in cs(obj,'property'):
                pa=c(prop,'at');pa[1]+=dx;pa[2]+=dy
                if prop[1] in {'Reference','Value'} and not c(prop,'hide'):
                    size=c(c(c(prop,'effects'),'font'),'size')
                    if size:size[1:]=[1.27,1.27]
        elif kind in {'label','global_label','junction','no_connect'}:
            at=c(obj,'at');orig=at[1:3];new=point(name,orig);at[1:3]=new
            for prop in cs(obj,'property'):
                pa=c(prop,'at');pa[1]+=new[0]-orig[0];pa[2]+=new[1]-orig[1]
        elif kind=='wire':
            pts=cs(c(obj,'pts'),'xy'); old=[v[1:3] for v in pts];new=[point(name,p) for p in old]
            if new[0][0]!=new[1][0] and new[0][1]!=new[1][1]:
                assert name=='Charging' and old[0][1]==old[1][1],old
                # USB section is moved down; the elbow lives in the gutter.
                path=[new[0],[130.81,new[0][1]],[130.81,new[1][1]],new[1]]
                c(obj,'pts')[1:]=[n('xy',*path[0]),n('xy',*path[1])]
                for p,q in zip(path[1:],path[2:]):
                    w=copy.deepcopy(obj);c(w,'pts')[1:]=[n('xy',*p),n('xy',*q)];c(w,'uuid')[1]=uid();additions.append(w)
            else:
                for p,q in zip(pts,new):p[1:3]=q
    a.extend(additions)

sources={}; old_manifest=json.loads(MANIFEST.read_text()) if MANIFEST.exists() else {'files':{}}
with ZipFile(SEED) as z:
    for name in ['Trimix_Power','Charging','Supply_5V','Gauge_Interface']:
        fname=name+'.kicad_sch'; raw=z.read('kicad/power/'+fname)
        current=sha256((P/fname).read_bytes()).hexdigest()
        allowed={sha256(raw).hexdigest(),old_manifest['files'].get(fname,{}).get('sha256')}
        if current not in allowed:raise SystemExit(f'{fname}: unexpected edits; rebase layout before overwriting.')
        sources[name]=sx.loads(raw.decode())

for name,a in sources.items():
    a[:]=[x for x in a if tag(x) not in {'text','rectangle','polyline'}]
    tb=c(a,'title_block')
    if tb:
        c(tb,'rev')[1]='P1.1'
        for co in cs(tb,'comment'):co[2]='Review draft | Electrical design unchanged | See POWER_DESIGN.md'
    if name!='Trimix_Power':translate(a,name)

a=sources['Charging']
header(a,'TRIMIX  /  POWER ELECTRONICS  /  SHEET 2 OF 4','Charging & protected battery','Follow the top row from USB input to charger and battery. The lower row controls and monitors charging.')
panel(a,1,'USB INPUT',20.32,52.07,106.68,95.25)
panel(a,2,'CHARGER & POWER PATH',134.62,52.07,167.64,95.25)
panel(a,3,'PROTECTED BATTERY',309.88,52.07,91.44,95.25)
panel(a,4,'PACK TEMPERATURE',20.32,156.21,116.84,91.44)
panel(a,5,'CHARGE ENABLE & WAKE',144.78,156.21,124.46,91.44)
panel(a,6,'STATUS INDICATORS',276.86,156.21,124.46,91.44)
text(a,'J101 brings 5 V from the two-pin USB-C assembly.\nC101 bypasses the charger input.\nCC termination and available current remain unverified.',25.4,119.38,1.27)
text(a,'P+ = protected red lead.  P- = protected black lead.\nBoth 18650 cells sit in parallel in the FMA holder.\nThe holder supplies the battery protection.\nPCB ground always connects to protected P-.',314.96,126.365,1.143)
text(a,'R101/R102 and the external 10k NTC sense temperature.\nAttach the NTC to the cells; connect it at J103.\nAn open sensor inhibits charging.',25.4,232.41,1.27)
text(a,'HIGH at ALLOW_CHG turns Q101 on and enables charging.\nR105 holds charging off while the host resets.\nSW101 provides charger wake/reset, not a power switch.',149.86,237.49,1.143)
text(a,'D101 lights while the charger reports charging.\nR106 limits LED current.\nR107 pulls the interrupt up to the host 3.3 V rail.',281.94,203.2,1.27)
text(a,'IINLIM: 450 mA  /  ICHG: 512 mA  /  VREG: 4.192 V\nThese are draft firmware targets, not factory defaults.\nConfigure and verify the charger before ALLOW_CHG.',281.94,224.79,1.143)
rect(a,20.32,256.54,271.78,24.13)
text(a,'READING THIS SHEET',25.4,260.35,1.524,True)
text(a,'Matching labels connect, even when no wire is drawn between them. VSYS feeds the 5 V converter on sheet 3.\nCrossed pins are intentionally unused. Check input limits, cell ratings and capacitor derating before hardware tests.\nComponent selection and firmware requirements are recorded in hardware/POWER_DESIGN.md.',25.4,267.97,1.27)
for sy in cs(a,'symbol'):
    ref=next(p[2] for p in cs(sy,'property') if p[1]=='Reference')
    if ref=='J101':
        field(sy,'Reference',45.72,78.74)
        field(sy,'Value',45.72,96.52)
    if ref=='J103':field(sy,'Value',114.3,203.2)

a=sources['Supply_5V']
header(a,'TRIMIX  /  POWER ELECTRONICS  /  SHEET 3 OF 4','Regulated 5 V supply','VSYS from sheet 2 is converted to VOUT_5V for the Guition board. The target is 5 V / 1 A, subject to validation.')
panel(a,1,'INPUT FILTERING',20.32,45.72,96.52,85.09)
panel(a,2,'CONVERTER & FEEDBACK',123.19,45.72,77.47,85.09)
panel(a,3,'OUTPUT FILTERING',207.01,45.72,74.93,85.09)
panel(a,4,'ON / OFF INPUT',20.32,137.16,119.38,58.42)
panel(a,5,'HOW THE VOLTAGE IS SET',147.32,137.16,134.62,26.67)
text(a,'C201/C202 provide local input energy.\nC203 bypasses the internal control supply.',25.4,60.96,1.143)
text(a,'C204-C206 support load steps\nand reduce output ripple.',212.09,60.96,1.143)
text(a,'Open J201 = ON.  Short J201 = OFF.\nR203 supplies the normal enable level.',25.4,183.515,1.143)
text(a,'5.000 V = 0.5 V x (1 + 1.62M / 180k)\nR201/R202 feed a fraction of the output back to FB.\nUse 1% resistors; confirm the output on the bench.',152.4,149.86,1.143)
for sy in cs(a,'symbol'):
    ref=next(p[2] for p in cs(sy,'property') if p[1]=='Reference')
    if ref=='L201':
        field(sy,'Reference',139.7,57.15,90)
        field(sy,'Value',139.7,59.69,90,size=1.016)
    if ref=='C203':
        field(sy,'Reference',99.06,110.49,justify='right')
        field(sy,'Value',99.06,113.03,justify='right')

a=sources['Gauge_Interface']
header(a,'TRIMIX  /  POWER ELECTRONICS  /  SHEET 4 OF 4','Battery gauge & host interface','The fuel gauge reads the protected pack. All communication pull-ups use the Guition board\'s 3.3 V supply.')
panel(a,1,'BATTERY GAUGE',20.32,45.72,101.6,86.36)
panel(a,2,'I2C & ALERT PULL-UPS',128.27,45.72,77.47,86.36)
panel(a,3,'5 V TO GUITION',212.09,45.72,69.85,53.34)
panel(a,4,'HOST LOGIC CONNECTOR',212.09,105.41,69.85,58.42)
panel(a,5,'ERC POWER SOURCE MARKERS',20.32,140.97,148.59,38.1)
text(a,'C301 provides local bypassing.\nThe IC reports pack voltage and estimated charge.',25.4,121.92,1.143)
text(a,'R301 pulls the alert signal high.\nR302/R303 are DNP: fit only if the host\nneeds additional I2C pull-ups.\nI2C: gauge 0x36 / charger 0x6B.',133.35,104.14,1.143)
text(a,'Pin 1: 5 V output\nPin 2: protected ground\nCheck the Guition input before connection.',217.17,82.55,1.143)
text(a,'These are our PCB pin numbers.\nThe Guition header mapping is still pending.\nSignals use 3.3 V logic.',217.17,148.59,1.016)
text(a,'These symbols declare real power sources to KiCad.\nThey are drawing aids and add no physical parts.',25.4,170.18,1.143)
rect(a,20.32,184.15,148.59,12.7)
text(a,'PACK_P = protected red P+  /  GND = protected black P-.\nDNP = do not populate this component in the initial assembly.',25.4,187.96,1.143)
for sy in cs(a,'symbol'):
    ref=next(p[2] for p in cs(sy,'property') if p[1]=='Reference')
    if ref=='C301':
        field(sy,'Reference',48.26,90.17,justify='right')
        field(sy,'Value',48.26,92.71,justify='right')
    if ref=='R303':
        field(sy,'Reference',190.5,72.39,justify='right')
        field(sy,'Value',190.5,74.93,justify='right')

# Replace the empty cover-page boxes with a functional, navigable block diagram.
a=sources['Trimix_Power'];c(a,'paper')[1]='A3'
header(a,'TRIMIX  /  POWER ELECTRONICS  /  SHEET 1 OF 4','Power system overview','Read from left to right. Double-click a numbered circuit sheet, or select it in the Hierarchy Navigator and press Enter.')
sheet_layout={'Charging.kicad_sch':(99.06,71.12,96.52,50.8,'02  CHARGING & POWER PATH'),
              'Supply_5V.kicad_sch':(218.44,71.12,88.9,50.8,'03  REGULATED 5 V SUPPLY'),
              'Gauge_Interface.kicad_sch':(218.44,160.02,88.9,43.18,'05  GAUGE & HOST INTERFACE')}
for sh in cs(a,'sheet'):
    props={p[1]:p for p in cs(sh,'property')}
    x,y,w,h,title=sheet_layout[props['Sheet file'][2]]
    c(sh,'at')[1:]=[x,y];c(sh,'size')[1:]=[w,h]
    for p in props.values():
        if not c(p,'hide'):p.append(n('hide',S('yes')))
    text(a,title,x,y-7.62,1.778,True)
    c(c(sh,'stroke'),'width')[1]=.381
rect(a,20.32,71.12,55.88,50.8,.381)
text(a,'01  USB INPUT',20.32,63.5,1.778,True)
rect(a,330.2,71.12,71.12,50.8,.381)
text(a,'04  GUITION BOARD',330.2,63.5,1.778,True)
rect(a,99.06,160.02,96.52,43.18,.381)
text(a,'PROTECTED 1S2P BATTERY',99.06,152.4,1.778,True)
text(a,'USB-C',27.94,82.55,2.286,True)
text(a,'5 V input\nTwo-pin panel socket\nCurrent capability\nstill to be verified',27.94,94.615,1.778)
text(a,'BQ25895',106.68,82.55,2.286,True)
text(a,'Chooses USB or battery power\nCharges the single-cell voltage stack\nControls charging current and voltage',106.68,96.52,1.778)
text(a,'TPS63020',226.06,82.55,2.286,True)
text(a,'Buck-boost conversion\nVSYS -> regulated 5 V\nSee circuit sheet 3',226.06,96.52,1.778)
text(a,'ESP32-P4',337.82,82.55,2.286,True)
text(a,'Touchscreen + controller\nReceives the 5 V supply\nControls charging over I2C',337.82,96.52,1.778)
text(a,'FMA HOLDER + 2 x 18650',106.68,168.91,1.778,True)
text(a,'Parallel cells; one 3.7 V nominal stack\nProtected red P+ and black P- leads\nCharging and discharge share these leads',106.68,181.61,1.778)
text(a,'MAX17048',226.06,168.91,2.032,True)
text(a,'Battery voltage + charge estimate\n3.3 V I2C and host connections\nSee circuit sheet 4',226.06,181.61,1.778)
def arrow(points,both=False,control=False):
    line(a,points,.254 if control else .381,'dash' if control else 'default')
    def head(tail,end):
        dx=end[0]-tail[0];dy=end[1]-tail[1];length=(dx*dx+dy*dy)**.5;dx/=length;dy/=length
        return [(end[0]-dx*2.54-dy*1.27,end[1]-dy*2.54+dx*1.27),end,(end[0]-dx*2.54+dy*1.27,end[1]-dy*2.54-dx*1.27)]
    line(a,head(points[-2],points[-1]),.381)
    if both:line(a,head(points[1],points[0]),.381)
arrow([(76.2,96.52),(99.06,96.52)])
text(a,'5 V',82.55,89.535,1.27)
arrow([(195.58,96.52),(218.44,96.52)])
text(a,'VSYS',200.66,89.535,1.27)
arrow([(307.34,96.52),(330.2,96.52)])
text(a,'5 V',313.69,89.535,1.27)
arrow([(147.32,121.92),(147.32,160.02)],True)
text(a,'PACK_P\ncharge / discharge',152.4,135.89,1.27)
arrow([(195.58,181.61),(218.44,181.61)])
text(a,'sense',199.39,174.625,1.27)
arrow([(307.34,181.61),(365.76,181.61),(365.76,121.92)],True,True)
text(a,'I2C + control\n3.3 V logic',372.11,141.605,1.27)
arrow([(365.76,71.12),(365.76,52.07),(147.32,52.07),(147.32,71.12)],True,True)
text(a,'Host control: I2C + ALLOW_CHG',205.74,45.72,1.397)
panel(a,6,'HOW TO READ THE CIRCUIT SHEETS',20.32,219.71,271.78,59.69)
text(a,'1. Each outlined section performs one job. Read its title before tracing individual wires.\n2. Matching net labels are connected electrically, including across different sheets.\n3. Component prefixes: U = IC, R = resistor, C = capacitor, L = inductor, J = connector.\n4. A dot joins crossing wires. A cross on a pin means deliberately unconnected.\n5. DNP means the component is drawn but not fitted in the initial assembly.\nOverview: solid arrows show power/sensing; dashed arrows show host communication.\nThese arrows show function; the detailed sheets contain the actual wiring.',25.4,232.41,1.778)
panel(a,7,'DESIGN STATUS',304.8,219.71,96.52,29.21)
text(a,'Review draft; not released for fabrication.\nUSB input, cells and final parts need verification.\nCharging currently requires an active host.',309.88,232.41,1.524)

manifest={'purpose':'Presentation only: section frames, teaching notes, field placement and geometric reflow.','source_archive':SEED.name,'files':{}}
for name,a in sources.items():
    data=(fmt(a)+'\n').encode();f=P/(name+'.kicad_sch');f.write_bytes(data)
    manifest['files'][f.name]={'sha256':sha256(data).hexdigest(),'page_size':c(a,'paper')[1]}
MANIFEST.write_text(json.dumps(manifest,indent=2)+'\n')
print('Presentation layout written: overview + 3 circuit sheets.')
