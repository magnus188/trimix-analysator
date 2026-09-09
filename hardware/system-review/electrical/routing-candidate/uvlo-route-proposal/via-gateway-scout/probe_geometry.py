"""Native effective-shape checks for temporary candidate conductors."""
import math
import build_bridge as c
p=c.p
ALL=[p.F_Cu,p.In1_Cu,p.In2_Cu,p.B_Cu]

def foreign(net,shape,layer,clearance):
    bad=[]
    for t in list(c.b.GetTracks())+[q for f in c.b.GetFootprints()for q in f.Pads()]:
        if t.GetNetname()==net or not t.IsOnLayer(layer):continue
        if t.GetEffectiveShape(layer).Collide(shape,p.FromMM(clearance)):
            bad.append((t.m_Uuid.AsString(),t.GetNetname(),c.b.GetLayerName(layer)))
    return bad

def via_bad(net,pt,r=.25):
    bad=[]
    for L in ALL:bad+=foreign(net,c.vec(pt),L,r+.2001)
    for f in c.b.GetFootprints():
        for q in f.Pads():
            if q.GetAttribute()!=p.PAD_ATTRIB_SMD:continue
            for L in (p.F_Cu,p.B_Cu):
                if q.IsOnLayer(L)and q.GetEffectiveShape(L).Collide(c.vec(pt),p.FromMM(r+.0501)):
                    bad.append(('SMT',f.GetReference(),q.GetNumber()))
    if math.dist(pt,(13,91.65))<r+.30+.2001:bad.append(('RESERVED','USB_5V','all'))
    return bad

def track_bad(net,points,layer,w=.15):
    bad=[]
    for a,b in zip(points,points[1:]):
        bad+=foreign(net,p.SEG(c.vec(a),c.vec(b)),layer,w/2+.2001)
    return bad
