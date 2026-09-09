"""Native saved fills and effective drilled copper; stdout only, no board saves."""
from pathlib import Path
import argparse, hashlib, json
import pcbnew as p

parser=argparse.ArgumentParser()
parser.add_argument('source')
parser.add_argument('candidate')
parser.add_argument('source_sha256')
parser.add_argument('candidate_sha256')
args=parser.parse_args()
ALL=[p.F_Cu,p.In1_Cu,p.In2_Cu,p.B_Cu]
def sha(path):return hashlib.sha256(path.read_bytes()).hexdigest()
def xy(v):return[p.ToMM(v.x),p.ToMM(v.y)]
def chain(c):return[xy(c.CPoint(i))for i in range(c.PointCount())]
def dump(poly):return[{'outer':chain(poly.COutline(i)),'holes':[chain(poly.CHole(i,j))for j in range(poly.HoleCount(i))]}for i in range(poly.OutlineCount())]
result={}
for label,path,expected in [('source',Path(args.source),args.source_sha256),('candidate',Path(args.candidate),args.candidate_sha256)]:
    assert sha(path)==expected,(label,sha(path),expected)
    b=p.LoadBoard(str(path))
    data={'path':str(path),'sha256':expected,'zones':{},'holes':[],'anchors':[],'vias':[]}
    for L in ALL:
        data['zones'][b.GetLayerName(L)]=[{'uuid':z.m_Uuid.AsString(),'native_area_mm2':z.GetFilledPolysList(L).Area()/1e12,'filled':z.IsFilled(),'polygons':dump(z.GetFilledPolysList(L))}for z in b.Zones()if not z.GetIsRuleArea()and z.GetNetname()=='GND'and z.IsOnLayer(L)]
    for ob in list(b.GetTracks())+[q for f in b.GetFootprints()for q in f.Pads()]:
        via=isinstance(ob,p.PCB_VIA);pad=isinstance(ob,p.PAD)
        if not via and(not pad or not ob.HasDrilledHole()):continue
        if via:
            assert ob.GetViaType()==p.VIATYPE_THROUGH,'Unsupported non-through drill span'
            data['vias'].append({'uuid':ob.m_Uuid.AsString(),'net':ob.GetNetname(),'at_mm':xy(ob.GetPosition()),'size_mm':p.ToMM(ob.GetWidth(p.F_Cu)),'drill_mm':p.ToMM(ob.GetDrill())})
        hp=p.SHAPE_POLY_SET();ob.GetEffectiveHoleShape().TransformToPolygon(hp,10,p.ERROR_INSIDE)
        hole=dump(hp)
        data['holes'].append({'uuid':ob.m_Uuid.AsString(),'plated':via or ob.GetAttribute()==p.PAD_ATTRIB_PTH,'polygons':hole})
        if ob.GetNetname()!='GND'or(pad and ob.GetAttribute()!=p.PAD_ATTRIB_PTH):continue
        row={'uuid':ob.m_Uuid.AsString(),'kind':'through_via'if via else 'plated_pad','label':'via'if via else ob.GetParentFootprint().GetReference()+'.'+ob.GetNumber(),'position_mm':xy(ob.GetPosition()),'hole':hole,'layers':{}}
        for L in ALL:
            if not ob.IsOnLayer(L):continue
            ps=p.SHAPE_POLY_SET();ob.TransformShapeToPolygon(ps,L,0,10,p.ERROR_INSIDE)
            row['layers'][b.GetLayerName(L)]={'flashed':ob.FlashLayer(L),'polygons':dump(ps)}
        data['anchors'].append(row)
    assert sha(path)==expected
    result[label]=data
print(json.dumps(result,separators=(',',':')))
