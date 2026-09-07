"""Wire the MCP-placed first power draft; not a general schematic editor.

Run with the KiCad MCP venv Python (sexpdata). Uses captured physical pin
coordinates, writes design intent for independent netlist comparison.
Do not rerun after manually moving components without refreshing coordinates.
"""
from pathlib import Path
import json, math, uuid
import sexpdata as sx

HW = Path(__file__).resolve().parents[1]
if (HW / 'verification/power/presentation-layout.json').exists():
    raise SystemExit('P1.1 presentation exists. Do not overwrite it with the initial-placement generator; rebase before a later electrical revision.')
P = HW / 'kicad/power'
S = sx.Symbol
def node(tag, *args): return [S(tag), *args]
def tag(a): return str(a[0]) if isinstance(a, list) and a else ''
def child(a, key): return next((v for v in a if tag(v) == key), None)
def children(a, key): return [v for v in a if tag(v) == key]
def uid(): return str(uuid.uuid4())
def fmt(a, level=0):
    if not isinstance(a, list): return sx.dumps(a)
    if not any(isinstance(v, list) for v in a): return sx.dumps(a)
    first = next(i for i, v in enumerate(a) if isinstance(v, list))
    return '(' + ' '.join(sx.dumps(v) for v in a[:first]) + '\n' + '\n'.join('\t'*(level+1)+fmt(v,level+1) for v in a[first:]) + '\n'+'\t'*level+')'
def save(path, a): path.write_text(fmt(a)+'\n')
def effects(size=1.016, justify=None, bold=False):
    f = node('font', node('size', size, size))
    if bold: f.append(node('bold', S('yes')))
    e = node('effects', f)
    if justify: e.append(node('justify', *[S(x) for x in justify.split()]))
    return e

pins = json.loads((HW/'verification/power/placement-pins.json').read_text())
maps = {
 'Charging': {
  'U101': {'1':'USB_5V','2':None,'3':None,'4':'CHG_STAT_N','5':'I2C_SCL','6':'I2C_SDA','7':'CHG_INT_N','8':'GND','9':'CHG_CE_N','10':'BQ_ILIM','11':'PACK_TS','12':'BQ_QON_N','13':'PACK_P','14':'PACK_P','15':'VSYS','16':'VSYS','17':'GND','18':'GND','19':'BQ_SW','20':'BQ_SW','21':'BQ_BTST','22':'BQ_REGN','23':'BQ_PMID','24':None,'25':'GND'},
  'J101': {'1':'USB_5V','2':'GND'}, 'J102': {'1':'PACK_P','2':'GND'}, 'J103': {'1':'PACK_TS','2':'GND'},
  'C101': {'1':'USB_5V','2':'GND'}, 'C102': {'1':'BQ_PMID','2':'GND'}, 'L101': {'1':'BQ_SW','2':'VSYS'},
  'C103': {'1':'BQ_SW','2':'BQ_BTST'}, 'C104': {'1':'VSYS','2':'GND'}, 'C105': {'1':'VSYS','2':'GND'},
  'C106': {'1':'PACK_P','2':'GND'}, 'C107': {'1':'BQ_REGN','2':'GND'},
  'R101': {'1':'BQ_REGN','2':'PACK_TS'}, 'R102': {'1':'PACK_TS','2':'GND'}, 'R103': {'1':'BQ_ILIM','2':'GND'},
  'R104': {'1':'VSYS','2':'CHG_CE_N'}, 'Q101': {'1':'ALLOW_CHG','2':'GND','3':'CHG_CE_N'},
  'R105': {'1':'ALLOW_CHG','2':'GND'}, 'SW101': {'1':'BQ_QON_N','2':'GND'},
  'D101': {'1':'CHG_STAT_N','2':'CHG_LED_A'}, 'R106': {'1':'CHG_LED_A','2':'VSYS'}, 'R107': {'1':'HOST_3V3','2':'CHG_INT_N'}
 },
 'Supply_5V': {
  'U201': {'1':'TPS_VINA','2':'GND','3':'TPS_FB','4':'VOUT_5V','5':'VOUT_5V','6':'TPS_L2','7':'TPS_L2','8':'TPS_L1','9':'TPS_L1','10':'VSYS','11':'VSYS','12':'POWER_EN','13':'VSYS','14':None,'15':'GND'},
  'L201': {'1':'TPS_L1','2':'TPS_L2'}, 'C201': {'1':'VSYS','2':'GND'}, 'C202': {'1':'VSYS','2':'GND'},
  'C203': {'1':'TPS_VINA','2':'GND'}, 'C204': {'1':'VOUT_5V','2':'GND'}, 'C205': {'1':'VOUT_5V','2':'GND'},
  'C206': {'1':'VOUT_5V','2':'GND'}, 'R201': {'1':'VOUT_5V','2':'TPS_FB'}, 'R202': {'1':'TPS_FB','2':'GND'},
  'R203': {'1':'VSYS','2':'POWER_EN'}, 'J201': {'1':'POWER_EN','2':'GND'}
 },
 'Gauge_Interface': {
  'U301': {'1':'GND','2':'PACK_P','3':'PACK_P','4':'GND','5':'GAUGE_ALERT_N','6':'GND','7':'I2C_SCL','8':'I2C_SDA','9':'GND'},
  'C301': {'1':'PACK_P','2':'GND'}, 'R301': {'1':'HOST_3V3','2':'GAUGE_ALERT_N'},
  'R302': {'1':'HOST_3V3','2':'I2C_SCL'}, 'R303': {'1':'HOST_3V3','2':'I2C_SDA'},
  'J301': {'1':'VOUT_5V','2':'GND'}, 'J302': {'1':'GND','2':'HOST_3V3','3':'I2C_SCL','4':'I2C_SDA','5':'ALLOW_CHG','6':'CHG_INT_N','7':'GAUGE_ALERT_N'},
  '#FLG0101': {'1':'USB_5V'}, '#FLG0102': {'1':'PACK_P'}, '#FLG0103': {'1':'GND'},
  '#FLG0104': {'1':'HOST_3V3'}, '#FLG0105': {'1':'VSYS'}
 }
}
GLOBAL = {'USB_5V','PACK_P','GND','VSYS','VOUT_5V','HOST_3V3','I2C_SCL','I2C_SDA','ALLOW_CHG','CHG_INT_N','GAUGE_ALERT_N'}
root = sx.loads((P/'Trimix_Power.kicad_sch').read_text())
root_uuid = str(child(root,'uuid')[1])
sheet_ids = {next(v[2] for v in children(sh,'property') if v[1]=='Sheet file').removesuffix('.kicad_sch'):str(child(sh,'uuid')[1]) for sh in children(root,'sheet')}

# VINA is an internally fed bypass node. An external VIN strap would bypass
# the chip's internal RC filter; reflect this in both library and cache.
lib = sx.loads((P/'Trimix_Power.kicad_sym').read_text())
def fix_vina(a):
    for u in children(a,'symbol'):
        for pin in children(u,'pin'):
            if str(child(pin,'number')[1]) == '1': pin[1] = S('passive')
for symbol in children(lib,'symbol'):
    if symbol[1]=='TPS63020DSJ': fix_vina(symbol)
save(P/'Trimix_Power.kicad_sym', lib)
(P/'sym-lib-table').write_text('(sym_lib_table (version 7) (lib (name "Trimix_Power") (type "KiCad") (uri "${KIPRJMOD}/Trimix_Power.kicad_sym") (options "") (descr "Datasheet checked power symbols")))\n')
(P/'Trimix_Power.kicad_pro').write_text(json.dumps({'meta':{'filename':'Trimix_Power.kicad_pro','version':1}},indent=2)+'\n')

GROUND_LIB = sx.loads(Path('/Applications/KiCad/KiCad.app/Contents/SharedSupport/symbols/power.kicad_sym').read_text())
GROUND = next(s for s in children(GROUND_LIB,'symbol') if s[1]=='GND')
import copy

class Sheet:
    def __init__(self,name,page):
        self.name=name; self.page=page; self.path=P/(name+'.kicad_sch'); self.a=sx.loads(self.path.read_text()); self.done=set(); self.segments=[]; self.labels=set(); self.grounds=set()
        self.a[:]=[v for v in self.a if tag(v) not in {'wire','label','global_label','junction','no_connect','text','title_block'} and not (tag(v)=='symbol' and any(x[1]=='Reference' and str(x[2]).startswith('#PWR') for x in children(v,'property')))]
        child(self.a,'paper')[1]='A3' if name=='Charging' else 'A4'
        self.a.append(node('title_block',node('title',{'Charging':'USB charging and protected 1S2P pack','Supply_5V':'5 V buck-boost supply','Gauge_Interface':'Battery gauge and Guition interface'}[name]),node('date','2026-09-05'),node('rev','P1'),node('company','Trimix'),node('comment',1,'Review draft; see hardware/POWER_DESIGN.md before fabrication')))
        libs=child(self.a,'lib_symbols')
        libs[:]=[v for v in libs if not(tag(v)=='symbol' and v[1]=='power:GND')]
        g=copy.deepcopy(GROUND);g[1]='power:GND';libs.append(g)
        for sy in children(libs,'symbol'):
            if sy[1]=='Trimix_Power:TPS63020DSJ': fix_vina(sy)
        for sy in children(self.a,'symbol'):
            ref=next(x[2] for x in children(sy,'property') if x[1]=='Reference')
            if ref=='R106' and name=='Charging': self.move(sy,ref,50.8,0)
            if ref=='R107' and name=='Charging': self.move(sy,ref,35.56,0)
            sy[:]=[x for x in sy if tag(x)!='instances']
            sy.append(self.instance(ref))
            if ref in {'R302','R303'}:
                dn=child(sy,'dnp')
                if dn: dn[1]=S('yes')
                else: sy.append(node('dnp',S('yes')))
            at=child(sy,'at'); x,y,angle=at[1:]
            props={v[1]:v for v in children(sy,'property')}
            if ref=='L201': props['Footprint'][2]='Inductor_SMD:L_Coilcraft_XxL4020'
            if ref[0] in 'RCL':
                if angle==0: positions={'Reference':(x+2.54,y-1.27),'Value':(x+2.54,y+1.27)}; j='left'
                else: positions={'Reference':(x,y-3.81),'Value':(x,y+3.81)}; j=None
                for pn,xy in positions.items():
                    child(props[pn],'at')[1:]=[*xy,angle]
                    props[pn][:]=[v for v in props[pn] if tag(v)!='effects']+[effects(1.016,j)]
            if ref[0]=='J' or ref=='Q101':
                for pn,yy in [('Reference',y-1.27),('Value',y+1.27)]:
                    child(props[pn],'at')[1:]=[x+5.08,yy,0 if angle==180 else angle]
                    props[pn][:]=[v for v in props[pn] if tag(v)!='effects']+[effects(1.016,'left')]
            if ref in {'U101','U201','U301'}:
                xx,yy={'U101':(177.8,63.5),'U201':(165.1,66.04),'U301':(86.36,60.96)}[ref]
                for pn,off in [('Reference',0),('Value',2.54)]:
                    child(props[pn],'at')[1:]=[xx,yy+off,0]
                    props[pn][:]=[v for v in props[pn] if tag(v)!='effects']+[effects(1.016,'left' if ref=='U201' else None)]
            if ref.startswith('#FLG'):
                for pn in ['Reference','Value']:
                    props[pn][:]=[v for v in props[pn] if tag(v)!='hide']+[node('hide',S('yes'))]
            if ref=='L201':
                child(props['Reference'],'at')[1:]=[139.7,52.07,90]
                child(props['Value'],'at')[1:]=[139.7,54.61,90]
        for ref,m in maps[name].items():
            assert set(m)==set(pins[name][ref]),(ref,m,pins[name][ref])
    def instance(self,ref):
        return node('instances',node('project','Trimix_Power',node('path','/'+root_uuid+'/'+sheet_ids[self.name],node('reference',ref),node('unit',1))))
    def move(self,sy,ref,dx,dy):
        a=child(sy,'at');actual_dx={'R106':330.2,'R107':365.76}[ref]-a[1];a[1]+=actual_dx;a[2]+=dy
        for pr in children(sy,'property'):
            b=child(pr,'at');b[1]+=actual_dx;b[2]+=dy
        for pp in pins[self.name][ref].values(): pp['x']+=dx;pp['y']+=dy
    def pin(self,ref,n):
        d=pins[self.name][ref][str(n)];return (d['x'],d['y'])
    def mark(self,*refs):
        for ref,n in refs:
            xy=self.pin(ref,n)
            for no,p in pins[self.name][ref].items():
                if (p['x'],p['y'])==xy:self.done.add((ref,no))
    def wire(self,*points):
        points=[tuple(round(v,4) for v in p) for p in points]
        for a,b in zip(points,points[1:]):
            if a==b:continue
            assert a[0]==b[0] or a[1]==b[1],(a,b)
            key=tuple(sorted((a,b)))
            if key in self.segments:continue
            self.segments.append(key)
            self.a.append(node('wire',node('pts',node('xy',*a),node('xy',*b)),node('stroke',node('width',0),node('type',S('default'))),node('uuid',uid())))
    def label(self,net,xy,angle=0):
        key=(net,tuple(xy))
        if key in self.labels:return
        self.labels.add(key)
        # Normal labels are compact; a global label on each used cross-sheet
        # net establishes the shared name for the whole hierarchy.
        global_here=net in GLOBAL
        if global_here:
            self.a.append(node('global_label',net,node('shape',S('bidirectional')),node('at',*xy,angle),effects(1.016,'left' if angle==0 else 'right'),node('uuid',uid()),node('property','Intersheetrefs','${INTERSHEET_REFS}',node('at',*xy,angle),effects(1.016),node('hide',S('yes')))))
        else:self.a.append(node('label',net,node('at',*xy,angle),effects(1.016,'left bottom' if angle==0 else 'right bottom'),node('uuid',uid())))
    def ground(self,xy):
        if tuple(xy) in self.grounds:return
        self.grounds.add(tuple(xy));ref=f'#PWR{self.page}{len(self.grounds):03}'
        sy=node('symbol',node('lib_id','power:GND'),node('at',*xy,0),node('unit',1),node('in_bom',S('no')),node('on_board',S('yes')),node('dnp',S('no')),node('uuid',uid()),node('property','Reference',ref,node('at',xy[0],xy[1]+3.81,0),effects(1.016),node('hide',S('yes'))),node('property','Value','GND',node('at',xy[0],xy[1]+5.08,0),effects(1.016)),node('pin','1',node('uuid',uid())),self.instance(ref))
        self.a.append(sy)
    def net(self,net,refs,paths,label_at=None):
        self.mark(*refs)
        for path in paths:self.wire(*path)
        if label_at:self.label(net,label_at)
    def finish(self):
        for ref,m in maps[self.name].items():
            for no,net in m.items():
                if (ref,no) in self.done:continue
                p=pins[self.name][ref][no];a=(p['x'],p['y']);self.mark((ref,no))
                if net is None:self.a.append(node('no_connect',node('at',*a),node('uuid',uid())));continue
                dx=round(math.cos(math.radians(p['angle'])));dy=-round(math.sin(math.radians(p['angle'])))
                b=(round(a[0]+dx*6.35,4),round(a[1]+dy*6.35,4))
                self.wire(a,b)
                if net=='GND' and not dx:self.ground(b)
                else:self.label(net,b,0 if dx>=0 else 180)
        # Add junctions only at wire endpoints touching a third branch.
        ends=set(p for seg in self.segments for p in seg)
        for p in ends:
            count=0
            for a,b in self.segments:
                if p in (a,b):count+=1
                elif (a[0]==b[0]==p[0] and min(a[1],b[1])<p[1]<max(a[1],b[1])) or (a[1]==b[1]==p[1] and min(a[0],b[0])<p[0]<max(a[0],b[0])):count+=2
            if count>=3:self.a.append(node('junction',node('at',*p),node('diameter',0),node('color',0,0,0,0),node('uuid',uid())))
        save(self.path,self.a)
    def text(self,t,x,y,size=1.27,bold=False):self.a.append(node('text',t,node('at',x,y,0),effects(size,'left',bold),node('uuid',uid())))

s=Sheet('Charging',2);p=s.pin
s.net('USB_5V',[('J101',1),('U101',1),('C101',1)],[[p('J101',1),(76.2,73.66),p('U101',1)],[p('C101',1),(76.2,73.66)]],(101.6,73.66))
s.mark(('J101',2));s.wire(p('J101',2),(58.42,71.12),(58.42,60.96));s.ground((58.42,60.96))
s.net('BQ_SW',[('U101',19),('L101',1),('C103',1)],[[p('U101',19),p('L101',1)],[p('C103',1),(208.28,86.36)]],(213.36,86.36))
s.net('VSYS',[('L101',2),('C104',1),('C105',1)],[[p('L101',2),(254,86.36),(254,96.52),(281.94,96.52),p('C105',1)],[p('C104',1),(254,96.52)]],(254,96.52))
s.net('BQ_PMID',[('U101',23),('C102',1)],[[p('U101',23),(264.16,81.28),(264.16,68.58),(281.94,68.58),p('C102',1)]],(269.24,68.58))
s.net('PACK_P',[('C106',1),('J102',1)],[[p('C106',1),(330.2,91.44),(350.52,91.44),(350.52,99.06),p('J102',1)]],(330.2,91.44))
s.net('BQ_ILIM',[('U101',10),('R103',1)],[[p('U101',10),(147.32,109.22),p('R103',1)]],(147.32,116.84))
s.net('BQ_REGN',[('C107',1),('R101',1)],[[p('C107',1),(45.72,144.78),(81.28,144.78),p('R101',1)]],(45.72,144.78))
s.net('PACK_TS',[('R101',2),('R102',1),('J103',1)],[[p('R101',2),(81.28,168.91),p('R102',1)],[(81.28,168.91),p('J103',1)]],(86.36,168.91))
s.net('CHG_CE_N',[('R104',2),('Q101',3)],[[p('R104',2),(177.8,165.1),(180.34,165.1),p('Q101',3)]],(180.34,165.1))
s.net('ALLOW_CHG',[('Q101',1),('R105',1)],[[p('Q101',1),(152.4,177.8),p('R105',1)]],(152.4,177.8))
s.net('CHG_LED_A',[('D101',2),('R106',1)],[[p('D101',2),p('R106',1)]])
s.text('CHARGING + PROTECTED BATTERY',25.4,25.4,2.54,True)
s.text('5 V input only in this draft. USB jack is the ordered 2-pin panel assembly.\nIts CC pull-downs are unverified; no USB data, PD negotiation or 3 A source detection.',25.4,38.1)
s.text('J102: 1 = protected red P+; 2 = protected black P-.\nFMA FPML1S2P050C holds 2 cells in PARALLEL.\nNever connect raw cell negatives to PCB ground.\nUser reports 2 x 3700 mAh; cell model/rating unverified.',294.64,124.46,1.016)
s.text('PACK TEMPERATURE',25.4,134.62,1.52,True)
s.text('External 10k NTC, Semitec 103AT-2 characteristic.\nMount thermally against the cells. Open sensor inhibits charge.\nVerify hot/cold thresholds using resistor substitution before cells.',25.4,207.01,1.016)
s.text('CHARGE ENABLE + WAKE',152.4,139.7,1.52,True)
s.text('ALLOW_CHG = HIGH enables charging through Q101.\nR105 holds it OFF while the host resets.\nConfigure charger registers BEFORE asserting this signal.\nSW101 wakes ship mode; a long press can reset SYS.',152.4,217.17,1.016)
s.text('STATUS',279.4,139.7,1.52,True)
s.text('R103 = 680 ohm: ~522 mA nominal hardware ceiling.\nComponent/IC tolerance means this is NOT a precise 500 mA limit.\nFirmware starting point: IINLIM 450 mA, ICHG 512 mA,\nVREG 4.192 V. Verify cell specification before enabling charge.\nOTG is grounded; D+/D-/DSEL intentionally unused.\nCheck C102 >= 8.2 uF effective at 5 V and USB inrush.\nL101 stock candidate: 1 uH, 7 x 7 x 5 mm; rating/land TBD.',279.4,182.88,1.016)
s.finish()

s=Sheet('Supply_5V',3);p=s.pin
s.net('TPS_L1',[('U201',8),('U201',9),('L201',1)],[[p('U201',8),(132.08,60.96),p('L201',1)],[p('U201',9),(134.62,60.96)]])
s.net('TPS_L2',[('U201',6),('U201',7),('L201',2)],[[p('L201',2),(147.32,60.96),p('U201',7)],[p('U201',6),(144.78,60.96)]])
s.net('VSYS',[('U201',10),('U201',11),('C201',1),('C202',1)],[[p('U201',10),(48.26,78.74),p('C201',1)],[p('C202',1),(73.66,78.74)],[p('U201',11),(119.38,81.28),(119.38,78.74)]],(48.26,78.74))
s.net('TPS_VINA',[('U201',1),('C203',1)],[[p('U201',1),(101.6,86.36),p('C203',1)]],(101.6,104.14))
s.net('VOUT_5V',[('U201',4),('U201',5),('R201',1),('C204',1),('C205',1),('C206',1)],[[p('U201',4),(259.08,78.74),p('C206',1)],[p('U201',5),(160.02,81.28),(160.02,78.74)],[p('R201',1),(180.34,78.74)],[p('C204',1),(213.36,78.74)],[p('C205',1),(236.22,78.74)]],(236.22,78.74))
s.net('TPS_FB',[('U201',3),('R201',2),('R202',1)],[[p('U201',3),p('R201',2),p('R202',1)]],(180.34,101.6))
s.net('POWER_EN',[('R203',2),('J201',1)],[[p('R203',2),(73.66,147.32),p('J201',1)]],(73.66,147.32))
s.mark(('U201',2),('U201',15));s.wire(p('U201',2),(137.16,119.38),(142.24,119.38),p('U201',15));s.ground((137.16,119.38))
s.text('REGULATED 5 V FOR GUITION',25.4,25.4,2.54,True)
s.text('VSYS comes from the BQ25895 system output. Design target: 5 V / 1 A.\nAvailable USB-only power is lower; the battery supplies load peaks.',25.4,38.1)
s.text('5.000 V nominal = 0.5 V x (1 + 1.62M / 180k).\nUse 1% feedback resistors. Load-step/thermal validation still required.',152.4,137.16,1.016)
s.text('J201 is a low-current OFF-switch interface.\nShort its pins to disable the converter; open = ON.\nPS/SYNC HIGH selects forced PWM. PG is unused.',25.4,166.37,1.016)
s.text('VINA: only 100 nF to GND; internally fed from VIN.\nDo not strap VINA directly to VIN. Keep switch loops short.\nThree 22 uF output capacitors follow the TI application circuit.\nL201 candidate is 1.5 uH / 5.1 A Coilcraft XFL4020-152ME.',152.4,160.02,1.016)
s.finish()

s=Sheet('Gauge_Interface',4);p=s.pin
s.net('PACK_P',[('U301',3),('U301',2),('C301',1)],[[p('U301',3),(50.8,71.12),p('C301',1)],[p('U301',2),(63.5,76.2),(63.5,71.12)]],(50.8,71.12))
s.mark(('U301',1),('U301',4),('U301',9));s.wire(p('U301',1),(81.28,101.6),(91.44,101.6),p('U301',9));s.wire(p('U301',4),(86.36,101.6));s.ground((86.36,101.6))
s.net('GAUGE_ALERT_N',[('U301',5),('R301',2)],[[p('U301',5),(132.08,83.82),p('R301',2)]],(132.08,83.82))
s.net('I2C_SCL',[('U301',7),('R302',2)],[[p('U301',7),(162.56,73.66),p('R302',2)]],(162.56,73.66))
s.net('I2C_SDA',[('U301',8),('R303',2)],[[p('U301',8),(193.04,78.74),p('R303',2)]],(193.04,78.74))
s.net('HOST_3V3',[('R301',1),('R302',1),('R303',1)],[[p('R301',1),(132.08,50.8),(193.04,50.8),p('R303',1)],[p('R302',1),(162.56,50.8)]],(162.56,50.8))
s.text('BATTERY GAUGE + GUITION CONNECTIONS',25.4,25.4,2.54,True)
s.text('MAX17048 monitors the protected 1S pack: two parallel cells are still one voltage stack.\nGauge and charger I2C logic must use the Guition 3.3 V rail.',25.4,38.1)
s.text('External-source power flags',25.4,119.38,1.016,True)
s.text('USB input / protected pack / ground / host 3.3 V / SYS after L101.\nFlags describe actual sources; they add no physical parts.',25.4,153.67,1.016)
s.text('J301: our PCB pin 1 = 5 V OUT; pin 2 = GND.\nJ302: our PCB connector numbering, NOT Guition pin numbers.\n1 GND; 2 host 3.3 V IN; 3 SCL; 4 SDA;\n5 charge permission IN; 6 charger interrupt OUT;\n7 fuel-gauge alert OUT. All logic is 3.3 V.',162.56,160.02,1.016)
s.text('R302/R303 are DNP until existing board pull-ups are checked.\nFirmware currently uses GPIO8 SCL / GPIO7 SDA (shared touch bus).\nBQ25895 address 0x6B; MAX17048 address 0x36.\nVerify physical Guition header mapping and 5 V backfeed isolation.\nDo not connect Guition USB 5 V simultaneously until verified.',25.4,175.26,1.016)
s.finish()

root[:]=[a for a in root if tag(a) not in {'text','title_block'}]
for i,sh in enumerate(children(root,'sheet'),2):
    sh[:]=[v for v in sh if tag(v)!='instances']
    sh.append(node('instances',node('project','Trimix_Power',node('path','/'+root_uuid,node('page',str(i))))))
    child(child(sh,'stroke'),'width')[1]=0.254
root.append(node('title_block',node('title','Trimix power system - replacement schematic'),node('date','2026-09-05'),node('rev','P1'),node('company','Trimix')))
def rt(t,x,y,size=1.27,bold=False):root.append(node('text',t,node('at',x,y,0),effects(size,'left',bold),node('uuid',uid())))
rt('TRIMIX / POWER SYSTEM',25.4,25.4,2.54,True)
rt('Replacement for the outdated power circuit. Original imported schematic is preserved one directory above.',25.4,35.56,1.016)
rt('USB 5 V -> BQ25895 SYS -> TPS63020 -> regulated 5 V -> Guition ESP32-P4\nProtected FMA 1S2P pack <-> BQ25895 BAT; MAX17048 senses the protected pack.',25.4,104.14,1.52)
rt('HOW TO READ THESE SHEETS',25.4,127,1.52,True)
rt('Matching net names connect electrically, including between sheets. Cross-sheet nets use global labels.\nGND is always the protected black lead (P-). PACK_P is the protected red lead (P+).\nVSYS changes with battery/charger operation; VOUT_5V is the regulated output for the display board.\nOpen the sheet blocks above to follow each stage. DNP means the part is not fitted initially.',25.4,139.7,1.016)
rt('REVIEW DRAFT: connector CC resistors, cell ratings, Guition input wiring, passive selections and PCB layout\nremain to be verified. See hardware/POWER_DESIGN.md and hardware/power-inventory.csv.\nNo charger firmware or routed PCB is included in this revision.',25.4,170.18,1.016)
save(P/'Trimix_Power.kicad_sch',root)
(HW/'verification/power/intended-nets.json').write_text(json.dumps(maps,indent=2)+'\n')
print('Wired 3 power sheets; design intent recorded.')
