import build_bridge as c
from route_bounded import route
p=c.p
c.track('PACK_P',[(10.64,79.9091),(13.6,78.1),(13.85,78.0),(15.5,75.85),(16.1271,74.422)],p.B_Cu,.4)
regn='/01  CHARGING + BATTERY/BQ_REGN'
route(regn,(12.79,81.15),(12.8,80.075),start_layers=(2,),end_layers=(2,),allow_vias=False,width=.4,bounds=(9,74,20,83))
at=(11.2,74.8);radius=p.FromMM(.3)
for t in list(c.b.GetTracks())+[q for f in c.b.GetFootprints() for q in f.Pads()]:
 for L in [p.F_Cu,p.In1_Cu,p.In2_Cu,p.B_Cu]:
  if t.IsOnLayer(L) and t.GetNetname()!='GND':assert not t.GetEffectiveShape(L).Collide(c.vec(at),radius+p.FromMM(.2001)),('GND via foreign',t.m_Uuid.AsString(),c.b.GetLayerName(L))
 if isinstance(t,p.PAD) and t.GetAttribute()==p.PAD_ATTRIB_SMD:
  for L in [p.F_Cu,p.B_Cu]:
   if t.IsOnLayer(L):assert not t.GetEffectiveShape(L).Collide(c.vec(at),radius+p.FromMM(.05)),('GNDvia SMT',t.m_Uuid.AsString())
for z in list(c.b.Zones())+[z for f in c.b.GetFootprints() for z in f.Zones()]:
 if z.GetIsRuleArea() and z.GetDoNotAllowVias():assert not z.Outline().Collide(c.vec(at),radius)
c.via('GND',at)
route('GND',(12.8,77.125),at,start_layers=(2,),end_layers=(2,),allow_vias=False,width=.4,bounds=(9,71,20,82))
c.save()
