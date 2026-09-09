from pathlib import Path
import sys,copy,shutil,uuid,json,hashlib
D=Path(__file__).resolve().parent;OUT=D/'c103-qualified';shutil.copytree(D/'c103-local2',OUT,dirs_exist_ok=True)
sys.path[:0]=[str(D.parents[3]/'tools'),str(D.parents[1])]
from analyzer_sheet import sx,child,tag
from apply_review_fixes import top_blocks
S=sx.Symbol
NAME='C_TDK_C1005_Recommended';FPID='Trimix_Power:'+NAME
source=Path('/Applications/KiCad/KiCad.app/Contents/SharedSupport/footprints/Capacitor_SMD.pretty/C_0402_1005Metric.kicad_mod')
lib=sx.loads(source.read_text());lib[1]=NAME
child(lib,'descr')[1]='TDK C1005X7R1H473K050BE recommended reflow lands: A=.40 inner gap, B=.40 pad length, C=.55 width; manufacturer C-series diagram/part page; factory assembly'
def modify_geometry(fp,side):
 for p in fp:
  if tag(p)=='pad':
   a=child(p,'at');a[1]=-.40 if p[1]=='1'else .40;child(p,'size')[1:]=[.40,.55];p[3]=S('rect');p[:]=[x for x in p if tag(x)!='roundrect_rratio']
 fp[:]=[x for x in fp if not(tag(x).startswith('fp_')and child(x,'layer')and str(child(x,'layer')[1]).endswith('CrtYd'))]
 fp.append([S('fp_rect'),[S('start'),-.825,-.55],[S('end'),.825,.55],[S('stroke'),[S('width'),.05],[S('type'),S('default')]],[S('fill'),S('none')],[S('layer'),side+'.CrtYd'],[S('uuid'),str(uuid.uuid4())]])
modify_geometry(lib,'F');(OUT/'Trimix_Power.pretty'/f'{NAME}.kicad_mod').write_text(sx.dumps(lib)+'\n')
vals={'MPN':'C1005X7R1H473K050BE','Manufacturer':'TDK','Datasheet':'https://product.tdk.com/en/search/capacitor/ceramic/mlcc/info?part_no=C1005X7R1H473K050BE','Footprint':FPID,'Maximum_body_length_mm':'1.15','Maximum_body_width_mm':'0.60','Maximum_body_height_mm':'0.60','Assembly':'Factory reflow for true0402; recommendedTDK lands; supplierprocess qualification remains required','Effective_capacitance_review':'47n nominal unchanged. At6.5V use95%typicalcurve retention asengineering estimate; .9tol*.85temp*.9aging gives30.74nF, notguaranteedmanufacturer minimum. TI nominal47n bootstrap recommendation retained.','Source_review':'sensitive-layout-refinement/c103-source/source-review.json; TDK exactcharasheet2017-03-16 and softseries recommendedlanddrawing'}
def props(o):return{p[1]:p for p in o if tag(p)=='property'}
def fields(o,isboard):
 pr=props(o);template=pr['MPN']
 for k,v in vals.items():
  if isboard and k=='Footprint':continue
  if k in pr:pr[k][2]=v
  else:
   q=copy.deepcopy(template);q[1:3]=[k,v];u=child(q,'uuid')
   if u:u[1]=str(uuid.uuid4())
   o.append(q)
 if isboard:
  ref=pr['Reference'];layer=child(ref,'layer');layer[1]='B.Fab'
  if not child(ref,'hide'):ref.append([S('hide'),S('yes')])
  eff=child(ref,'effects')
  if eff:
   j=child(eff,'justify')
   if j is None:eff.append([S('justify'),S('mirror')])
   elif S('mirror')not in j:j.append(S('mirror'))
raw=(OUT/'Trimix_Analyzer.kicad_pcb').read_text()
for a,z,block in top_blocks(raw):
 if not block.startswith('(footprint'):continue
 fp=sx.loads(block)
 if props(fp)['Reference'][2]!='C103':continue
 fp[1]=FPID;modify_geometry(fp,'B');fields(fp,True);raw=raw[:a]+sx.dumps(fp)+raw[z:];break
(OUT/'Trimix_Analyzer.kicad_pcb').write_text(raw)
p=OUT/'Charging.kicad_sch';raw=sx.loads(p.read_text())
for q in raw:
 if tag(q)=='symbol'and props(q).get('Reference',[None,None,None])[2]=='C103':fields(q,False)
p.write_text(sx.dumps(raw)+'\n')
(OUT/'land-contract.json').write_text(json.dumps({'manufacturer':'TDK','MPN':vals['MPN'],'footprint':FPID,'A_gap_mm':.4,'B_land_length_mm':.4,'C_land_width_mm':.55,'pad_centres_local_mm':[[-.4,0],[.4,0]],'maximum_purchased_body_mm':[1.15,.6,.6],'courtyard_body_allowance_per_side_mm':.25,'courtyard_mm':[1.65,1.10],'nominal_model':'unscaled KiCad1.0×.5×.5nominal0402; exactpurchasedmaximum separate','sources':['https://product.tdk.com/en/search/capacitor/ceramic/mlcc/info?part_no=C1005X7R1H473K050BE','https://media.digikey.com/pdf/Data%20Sheets/TDK%20PDFs/C_Series_GeneralAppl_B11.pdf p72'],'status':'isolated precisefootprint candidate; notcanonical'},indent=2)+'\n')
