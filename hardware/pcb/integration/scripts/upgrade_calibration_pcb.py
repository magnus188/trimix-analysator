"""Synchronize the approved ADC/reference change into an isolated PCB candidate.

Run with KiCad Python after the full upgraded schematic netlist is exported.
Preserves unrelated placement, copper, outline, models and project settings.
"""
from pathlib import Path
import hashlib, json, math, sys, xml.etree.ElementTree as ET
import pcbnew as p

BASE = Path(__file__).resolve().parents[1]
ROOT = BASE.parents[2]
OUT = BASE / 'verification/software-calibration'
SOURCE = BASE.parent / 'analyzer/Trimix_Analyzer.kicad_pcb'
BEFORE = OUT / 'before-board/Trimix_Analyzer.kicad_pcb'
NETLIST = OUT / 'analyzer-upgraded-netlist.xml'
CHANGED = {'U401', 'U502', 'RN501'}
DELETED = {'RV501', 'R502', 'R503'}
PACKED = {'R405', 'C407', 'C404', 'C405'}
MOVED = PACKED | {'C408', 'C406', 'R406', 'C508', 'C509', 'C506', 'R507'}
SHARED = Path('/Applications/KiCad/KiCad.app/Contents/SharedSupport')

def sha(path): return hashlib.sha256(path.read_bytes()).hexdigest()
def v(x, y): return p.VECTOR2I(p.FromMM(x), p.FromMM(y))
def pose(f): return [p.ToMM(f.GetPosition().x), p.ToMM(f.GetPosition().y), f.GetOrientationDegrees()]
def box(q):
    b=q.BBox();return [p.ToMM(b.GetX()),p.ToMM(b.GetY()),p.ToMM(b.GetRight()),p.ToMM(b.GetBottom())]
def court(f):
    f.BuildCourtyardCaches();return f.GetCourtyard(p.F_Cu)
def collide(a,b,gap=.02):
    return a[0]-gap < b[2] and b[0]-gap < a[2] and a[1]-gap < b[3] and b[1]-gap < a[3]
def netmap(b): return {(f.GetReference(),q.GetNumber()):q.GetNetname() for f in b.GetFootprints() for q in f.Pads() if q.GetNumber()}

def geometry(b):
    outline=p.SHAPE_POLY_SET()
    if not b.GetBoardPolygonOutlines(outline,False):raise RuntimeError('Invalid outline')
    courts={f.GetReference():court(f) for f in b.GetFootprints()}
    outside=[];edge=[];overlaps=[]
    for ref,c in courts.items():
        q=c.CloneDropTriangulation();q.BooleanSubtract(outline)
        if q.Area()>1:outside.append(ref)
    refs=sorted(courts)
    for i,r in enumerate(refs):
        for other in refs[i+1:]:
            if courts[r].Collide(courts[other],0):overlaps.append([r,other])
    for f in b.GetFootprints():
        for pad in f.Pads():
            if not pad.IsOnLayer(p.F_Cu):continue
            q=p.SHAPE_POLY_SET();pad.TransformShapeToPolygon(q,p.F_Cu,p.FromMM(.5),p.FromMM(.001),p.ERROR_OUTSIDE)
            q.BooleanSubtract(outline)
            if q.Area()>1:edge.append([f.GetReference(),pad.GetNumber()])
    return {'courtyard_outside':outside,'courtyard_overlaps':overlaps,'pads_below_0_5mm_edge':edge,'passed':not(outside or overlaps or edge)}

def build():
    initial=sha(SOURCE);project=sha(SOURCE.with_suffix('.kicad_pro'))
    if initial!=sha(BEFORE):raise RuntimeError('Source differs from the guarded before snapshot')
    tree=ET.parse(NETLIST).getroot();parts={c.attrib['ref']:c for c in tree.findall('./components/comp')}
    b=p.LoadBoard(str(BEFORE));old={f.GetReference():f for f in b.GetFootprints()}
    before_poses={r:pose(f)for r,f in old.items()};before_nets=netmap(b)
    for r in DELETED:b.Remove(old[r])
    for ref in sorted(CHANGED):
        c=parts[ref];fpname=c.findtext('footprint');lib,item=fpname.split(':')
        libpath=SOURCE.parent/(lib+'.pretty') if lib.startswith('Trimix_') else SHARED/'footprints'/(lib+'.pretty')
        f=p.FootprintLoad(str(libpath),item)
        if f is None:raise RuntimeError('Missing footprint '+fpname)
        f.SetReference(ref);f.SetValue(c.findtext('value'));f.SetFPIDAsString(fpname)
        if ref in old:
            f.SetUuidDirect(old[ref].m_Uuid);b.Remove(old[ref])
        f.SetPath(p.KIID_PATH(c.find('sheetpath').attrib['tstamps']+c.findtext('tstamps')))
        for fid,val in ((p.FIELD_T_DESCRIPTION,c.findtext('description')or ''),(p.FIELD_T_DATASHEET,c.findtext('datasheet')or '')):
            f.GetField(fid).SetText(val);f.GetField(fid).SetVisible(False)
        for field in c.findall('./fields/field'):
            name=field.attrib['name']
            if name in ('Reference','Value','Footprint','Datasheet','Description'):continue
            if f.HasField(name):fld=f.GetField(name)
            else:fld=p.PCB_FIELD(f,p.FIELD_T_USER,name);f.Add(fld)
            fld.SetText(field.text or '');fld.SetVisible(False)
        props={q.attrib['name']:q.attrib.get('value','')for q in c.findall('property')}
        f.SetSheetname(props.get('Sheetname',''));f.SetSheetfile(props.get('Sheetfile',''))
        f.Value().SetVisible(False);b.Add(f)
    fps={f.GetReference():f for f in b.GetFootprints()}
    expected={}
    for net in tree.findall('./nets/net'):
        name=net.attrib['name'];info=b.FindNet(name)
        if not info or info.GetNetCode()<0:
            info=p.NETINFO_ITEM(b,name);b.Add(info)
        for n in net.findall('node'):
            if n.attrib['ref'] in fps:expected[(n.attrib['ref'],n.attrib['pin'])]=(name,info)
    for r,f in fps.items():
        for q in f.Pads():
            if not q.GetNumber():continue
            key=(r,q.GetNumber())
            if key not in expected:raise RuntimeError('Pad absent from full netlist: '+str(key))
            q.SetNet(expected[key][1])
    delta={k:(val,netmap(b).get(k))for k,val in before_nets.items()if k[0] not in CHANGED|DELETED and netmap(b).get(k)!=val}
    if delta:raise RuntimeError('Unapproved net changes '+str(delta))
    # Preserve every existing part pose. Search only the three changed parts.
    occupied={r:box(court(f))for r,f in fps.items()if r not in CHANGED|PACKED}
    outline=p.SHAPE_POLY_SET();assert b.GetBoardPolygonOutlines(outline,False)
    regions={'U401':(7.0,17.1,29.3,37.0),'U502':(.5,30.,29.3,51.5),'RN501':(.5,30.,29.3,51.5)}
    regions.update({r:(9.2,30.9,15.85,35.4) for r in PACKED})
    anchors={'U401':(12.6,22.),'U502':(12.6,40.9),'RN501':(2.2,40.9)}
    anchors.update({r:(12.6,33.) for r in PACKED})
    placed={}
    for ref in ['U401','U502','RN501']+sorted(PACKED):
        f=fps[ref];rx0,ry0,rx1,ry1=regions[ref];ax,ay=anchors[ref];candidates=[]
        for angle in [0,90]:
            f.SetOrientationDegrees(angle);f.SetPosition(v(0,0));bb=box(court(f))
            for ix in range(math.ceil((rx0-bb[0])*10),math.floor((rx1-bb[2])*10)+1):
                for iy in range(math.ceil((ry0-bb[1])*10),math.floor((ry1-bb[3])*10)+1):
                    x,y=ix/10,iy/10;test=[bb[0]+x,bb[1]+y,bb[2]+x,bb[3]+y]
                    if any(collide(test,q)for q in occupied.values()):continue
                    candidates.append((math.hypot(x-ax,y-ay)+(.2 if angle else 0),x,y,angle))
        found=False
        for _,x,y,angle in sorted(candidates):
            f.SetOrientationDegrees(angle);f.SetPosition(v(x,y));c=court(f);diff=c.CloneDropTriangulation();diff.BooleanSubtract(outline)
            if diff.Area()>1:continue
            occupied[ref]=box(c);placed[ref]=pose(f);found=True;break
        if not found:raise RuntimeError('No local placement without moving other parts: '+ref)
    # Turn the oxygen supply pins toward its local bypass capacitors.
    fps['U401'].SetOrientationDegrees(270)
    def exchange(a,b):
        pa,aa=fps[a].GetPosition(),fps[a].GetOrientationDegrees()
        pb,ab=fps[b].GetPosition(),fps[b].GetOrientationDegrees()
        fps[a].SetPosition(pb);fps[a].SetOrientationDegrees(ab)
        fps[b].SetPosition(pa);fps[b].SetOrientationDegrees(aa)
    exchange('C407','C406');exchange('C408','R406')
    exchange('C508','C506');exchange('C509','R507')
    placed.update({r:pose(fps[r]) for r in CHANGED|MOVED})
    assert all(pose(f)==before_poses[r]for r,f in fps.items()if r not in CHANGED|MOVED)
    result=geometry(b)
    if not result['passed']:raise RuntimeError(json.dumps(result))
    path=OUT/'Trimix_Analyzer_calibration_candidate.kicad_pcb';p.SaveBoard(str(path),b)
    if initial!=sha(SOURCE) or project!=sha(SOURCE.with_suffix('.kicad_pro')):raise RuntimeError('Source/project changed')
    after=p.LoadBoard(str(path));assert netmap(after)=={k:v[0]for k,v in expected.items()}
    receipt={'status':'candidate_ready_for_native_DRC_and_Fusion','before_sha256':initial,'candidate_sha256':sha(path),'netlist_sha256':sha(NETLIST),'footprint_count':len(fps),'changed_poses_mm_deg':placed,'deleted_refs':sorted(DELETED),'relocated_passives':sorted(MOVED),'all_other_poses_and_pin_nets_unchanged':True,'numbered_pad_net_assignments':len(expected),'geometry':result,'project_sha256_unchanged':project,'limits':'Unrouted placement; native DRC, exact enclosure checks and physical gas characterization remain required.'}
    (OUT/'pcb-candidate.json').write_text(json.dumps(receipt,indent=2)+'\n');print(json.dumps(receipt,indent=2))

if __name__=='__main__':build()
