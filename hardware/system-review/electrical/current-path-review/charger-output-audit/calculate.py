from pathlib import Path
import json,hashlib,csv,math
D=Path(__file__).resolve().parent;ROOT=D.parents[4];r=json.loads((D/'inventory.json').read_text())
checks={}
for board,rows in r['boards'].items():
 for c in r['netlist_VSYS_capacitor_inventory']:
  row=rows[c['ref']];checks[board+':'+c['ref']+':MPN']=row['component']['props']['MPN']==c['fields']['MPN'];checks[board+':'+c['ref']+':nets']={p['pin']:p['net']for p in row['pads']}==c['pins']
 checks[board+':L101:MPN']=rows['L101']['component']['props']['MPN']=='74437349010'
 checks[board+':L101:value']=rows['L101']['component']['value']=='1u / 74437349010'
 checks[board+':L101:nets']={p['pin']:p['net']for p in rows['L101']['pads']}==r['netlist_L101']['pins']
assert all(checks.values())
tol,temp,aging=.8,.85,.9
rows=[]
for bias in [.9,.85,.8,.75,.7]:
 each=22*bias*tol*temp*aging;pair=2*each
 rows.append(dict(bias_retained_assumption=bias,each_uF=each,pair_uF=pair,margin_above_20uF_pct=(pair/20-1)*100))
with (D/'capacitance-sensitivity.csv').open('w')as f:
 w=csv.DictWriter(f,fieldnames=rows[0]);w.writeheader();w.writerows(rows)
out=dict(checks=checks,nominal_VSYS_capacitance_uF=88.1,dedicated_charger_pair_nominal_uF=44,assumed_analysis_bias_V=5.5,assumptions={'initial_tolerance_retained':tol,'temperature_retained':temp,'aging_retained':aging,'C104_C105_typical_DC_bias_retained_approx':.9,'C201_C202_typical_DC_bias_retained_conservative_approx':.5},dedicated_pair_model_uF=rows[0]['pair_uF'],C201_C202_additional_model_uF=2*22*.5*tol*temp*aging,total_four_capacitors_model_uF=2*22*(.9+.5)*tol*temp*aging,C801_credit_in_model_uF=0,dedicated_pair_required_retained_bias_factor_for_20uF=20/(44*tol*temp*aging),sensitivity=rows,limits=['The 5.5V analysis voltage is an intentionally conservative capacitor comparison point, not a permitted SYS operating-voltage declaration.','These factor products are engineering sensitivity, not a manufacturer-guaranteed combined bias/temperature/tolerance/aging limit.','The .9 aging factor is an explicit unqualified design allowance; no exact service interval or aging guarantee is established.','These sums assume both terminals connect with negligible impedance at the relevant loop frequencies; native net names alone do not prove this.','No extra bulk capacitor is recommended by this inventory.','No measured ripple, stability, transient, temperature or capacitance data exists in this audit.'])
(D/'analysis.json').write_text(json.dumps(out,indent=2)+'\n')
print(len(checks),'inventory checks passed; pair',out['dedicated_pair_model_uF'],'uF; four caps',out['total_four_capacitors_model_uF'],'uF')
