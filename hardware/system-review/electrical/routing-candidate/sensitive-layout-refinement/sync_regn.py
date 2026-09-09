from pathlib import Path
import sys,copy,uuid,json
D=Path(__file__).resolve().parent;O=D/'synchronized-regn'
sys.path[:0]=[str(D.parents[3]/'tools'),str(D.parents[1])]
from analyzer_sheet import sx,child,tag
S=sx.Symbol;name='C_TDK_C2012_Recommended';fpid='Trimix_Power:'+name
source=D.parents[1]/'sensitive-layout-refinement/c107-0805'
lib=sx.loads((source/'candidate/C107_Trial.pretty/C_TDK_C2012_Manufacturer_Reflow.kicad_mod').read_text());lib[1]=name
model=[S('model'),'${KICAD10_3DMODEL_DIR}/Capacitor_SMD.3dshapes/C_0805_2012Metric.step',[S('offset'),[S('xyz'),0,0,0]],[S('scale'),[S('xyz'),1,1,1]],[S('rotate'),[S('xyz'),0,0,0]]]
lib.append(copy.deepcopy(model));(O/'Trimix_Power.pretty'/f'{name}.kicad_mod').write_text(sx.dumps(lib)+'\n')
values={'Value':'47u / 10V X5R / 20%','MPN':'C2012X5R1A476M125AC','Manufacturer':'TDK','Datasheet':'https://product.tdk.com/en/search/capacitor/ceramic/mlcc/info?part_no=C2012X5R1A476M125AC','Footprint':fpid,'Maximum_body_length_mm':'2.20','Maximum_body_width_mm':'1.45','Maximum_body_height_mm':'1.45','Effective_capacitance_review':'At6.5V use .22 typical curve retention: 47u*.22*.8 tolerance*.85 temp*.9 illustrative aging =6.328uF. Engineering sensitivity only, not guaranteed minimum. Additional typical startup charge ~56–58uC versus former22u1206; startup/ripple remains unqualified.','Assembly':'Factory reflow recommended for rear local REGN capacitor and manufacturer reflow lands; supplier process qualification remains open.','Source_review':'electrical/sensitive-layout-refinement/c107-0805/README.md and frozen verification-receipt.json; exact TDK47u/10V/X5R part, body/land and startup comparison.'}
def fields(q,board):
 pr={x[1]:x for x in q if tag(x)=='property'}
 for k,v in values.items():
  if board and k=='Footprint':continue
  if k in pr:pr[k][2]=v
  else:
   x=copy.deepcopy(pr['MPN']);x[1:3]=[k,v];u=child(x,'uuid')
   if u:u[1]=str(uuid.uuid4())
   q.append(x)
 if board:
  q[1]=fpid;q.append(copy.deepcopy(model));child(pr['Reference'],'layer')[1]='B.Fab'
p=O/'Trimix_Analyzer.kicad_pcb';q=sx.loads(p.read_text())
for x in q:
 if tag(x)=='footprint' and next(v[2]for v in x if tag(v)=='property'and v[1]=='Reference')=='C107':fields(x,True)
p.write_text(sx.dumps(q)+'\n')
p=O/'Charging.kicad_sch';q=sx.loads(p.read_text())
for x in q:
 if tag(x)!='symbol':continue
 pr={v[1]:v for v in x if tag(v)=='property'}
 if pr.get('Reference',[None,None,None])[2]=='C107':fields(x,False)
p.write_text(sx.dumps(q)+'\n');(O/'c107-metadata-sync.json').write_text(json.dumps(values,indent=2)+'\n')
import pcbnew as p
b=p.LoadBoard(str(O/'Trimix_Analyzer.kicad_pcb'));p.ZONE_FILLER(b).Fill(b.Zones());p.SaveBoard(str(O/'Trimix_Analyzer.kicad_pcb'),b)
