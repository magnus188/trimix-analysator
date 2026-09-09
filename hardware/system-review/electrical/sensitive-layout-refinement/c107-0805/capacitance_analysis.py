"""Reproducible piecewise-linear engineering estimates from visually read TDK typical charts. Not SPICE; no guaranteed DC-bias or startup model."""
from pathlib import Path
import json
D=Path(__file__).resolve().parent
curves={
 'C2012X5R1A476M125AC':{'nominal_uF':47,'points_V_ratio':[[0,1],[1.25,.88],[2,.70],[2.5,.59],[3.125,.49],[4,.38],[5,.30],[6.3,.23],[8,.17],[10,.13]],'screening_retained_factor_6p5V':.22},
 'C3216X5R1E226M160AB':{'nominal_uF':22,'points_V_ratio':[[0,1],[1,.99],[2,.90],[3.125,.775],[4,.68],[5,.58],[6.25,.48],[8,.375],[10,.29],[12.5,.22],[16,.165],[25,.10]],'screening_retained_factor_6p5V':.45}}
def val(pts,x):
 for (a,y),(z,w) in zip(pts,pts[1:]):
  if a<=x<=z:return y+(w-y)*(x-a)/(z-a)
 raise ValueError(x)
def charge_uC(C,pts,x):
 nodes=[q for q in pts if q[0]<x]+[[x,val(pts,x)]]
 return C*sum((z-a)*(y+w)/2 for (a,y),(z,w)in zip(nodes,nodes[1:]))
for part,c in curves.items():
 C=c['nominal_uF'];pts=c['points_V_ratio'];c['calculations']=[]
 for V in [4.8,6.4,6.5]:
  r=val(pts,V);Q=charge_uC(C,pts,V)
  c['calculations'].append({'voltage_V':V,'typical_graph_interpolated_uF':C*r,'nominal_integrated_charge_uC':Q,'nameplate_plus20pct_charge_sensitivity_uC':1.2*Q,'equivalent_time_ms_at20mA_NOT_guaranteed':Q/20,'equivalent_time_ms_at40mA_NOT_guaranteed':Q/40,'meaning':'20/40mA are TI voltage-characterization test conditions only, not guaranteed spare startup current; Q/I is illustrative.'})
 factor=c['screening_retained_factor_6p5V'];c['screening_at6p5V']={'bias_estimate_uF':C*factor,'tolerance_temp_uF':C*factor*.8*.85,'plus_unqualified_10pct_aging_allowance_uF':C*factor*.8*.85*.9,'plus_additional_unqualified_20pct_measurement_ripple_sensitivity_uF':C*factor*.8*.85*.9*.8}
r={'analysis':'closed-form integration of visually digitized typical C(V), no actual SPICE or physical measurement','curves':curves,'guaranteed_spec_scope':'Nominal±20%, X5R±15% temperature class, voltage rating and dimension tolerances are manufacturer part specifications under their stated tests. Typical bias charts, multiplied combined effects and illustrative aging/ripple factors are not guaranteed minimum effective capacitance.','startup_source':'TI BQ25895 RevC table7.5:50mA minimum REGN current limit at VBUS9V,REGN3.8V only; REGN voltage tested at20mA/5V and40mA/9V. §8.2.3.1:220ms precedes REGN enable, not a cap-charge time budget. No guaranteed external-cap maximum/ramp or spare charging-current bound found. No conclusion of guaranteed startup at5V or cold-limited source.','recommendation':'47uF10V0805 gives similar/slightly better conditional retained-cap margin and a much shorter layout than the existing22uF25V1206. Prototype only after mechanical acceptance and explicit startup/ripple/temperature checks; EL13 cold/depleted-source startup remains open.'}
(D/'capacitance-analysis.json').write_text(json.dumps(r,indent=2)+'\n');print(json.dumps(r,indent=2))
