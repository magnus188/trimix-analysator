#!/usr/bin/env python3
"""Read-only independent reconciliation of explicit board assembly ledgers."""
import argparse,csv,hashlib,json,math
from pathlib import Path
from collections import Counter
import sexpdata
from cam_geometry import Native,sub,subs,tag,EPS

def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def main():
 p=argparse.ArgumentParser(description=__doc__);p.add_argument('--board',type=Path,required=True);p.add_argument('--cam',type=Path,required=True);p.add_argument('--out',type=Path,required=True);p.add_argument('--expected-sha256',required=True);a=p.parse_args()
 assert sha(a.board)==a.expected_sha256
 names=['assembly-reference-map','purchasing-bom','factory-bom','manual-bom','dnp-list','pcb-features','placement-all','placement-factory','marking-legend']
 paths=[a.board]+[a.cam/(name+'.csv')for name in names];before={str(f.resolve()):sha(f)for f in paths}
 data={name:list(csv.DictReader((a.cam/(name+'.csv')).open()))for name in names}
 n=Native(sexpdata.loads(a.board.read_text()));fps={f['ref']:f for f in n.fps};checks=[]
 def ck(name,ok,detail=None):checks.append(dict(check=name,passed=bool(ok),detail=detail))
 references=lambda name:[r['Reference']for r in data[name]]
 ck('All-reference map represents every physical native footprint exactly once',Counter(references('assembly-reference-map'))==Counter(fps.keys()))
 for name in names:
  key='Ref'if name.startswith('placement-')else'Reference'
  ck(name+' has no duplicate references',len(data[name])==len({r[key]for r in data[name]}))
 allrows={r['Reference']:r for r in data['assembly-reference-map']};fail=[]
 for ref,r in allrows.items():
  f=fps.get(ref)
  if not f:continue
  if not(r['Value']==f['value']and r['MPN']==f['props'].get('MPN','')and r['Footprint']==f['package']and r['Side']==f['side']and int(r['Quantity'])==1 and all(abs(float(r[k])-v)<EPS for k,v in [('PCB_X_mm',f['x']),('PCB_Y_mm',-f['y']),('Rotation_deg',f['rotation'])])):fail.append(ref)
 ck('Every ledger part identity and pose matches native bytes',not fail,fail)
 cats={'factory-bom':'factory','manual-bom':'manual','dnp-list':'DNP','pcb-features':'PCB feature'};partition=[];fails=[]
 for name,category in cats.items():
  partition+=references(name)
  for r in data[name]:
   if r!=allrows.get(r['Reference'])or r['Category']!=category or int(r['Population_quantity'])!=(1 if category in ['factory','manual']else 0):fails.append(r['Reference'])
 ck('Factory/manual/DNP/features partition the complete reference map',Counter(partition)==Counter(fps.keys())and not fails,dict(counts={cats[k]:len(data[k])for k in cats},mismatches=fails))
 ck('DNP ledger exactly matches native DNP flags',set(references('dnp-list'))=={f['ref']for f in n.fps if'dnp'in f['attributes']})
 features={f['ref']for f in n.fps if f['ref'].startswith(('TP','H'))}|{'J101','J102'}
 ck('PCB-only features are explicitly limited to test/holes and documented solder harness terminations',set(references('pcb-features'))==features,sorted(features))
 buy=data['factory-bom']+data['manual-bom'];buyrows={r['Reference']:r for r in buy}
 ck('Purchasing list exactly equals populated factory plus manual parts',len(buyrows)==len(buy)and {r['Reference']:r for r in data['purchasing-bom']}==buyrows and all(r['MPN']and int(r['Population_quantity'])==1 for r in buy))
 allpos={r['Ref']:r for r in data['placement-all']};facpos={r['Ref']:r for r in data['placement-factory']}
 ck('Factory CPL is an exact unchanged subset of whole-board CPL',set(facpos)==set(references('factory-bom'))and all(r==allpos.get(ref)for ref,r in facpos.items()))
 ck('No manual/DNP/feature appears in factory CPL',not(set(facpos)&(set(references('manual-bom'))|set(references('dnp-list'))|features)))
 high_precision={f['ref']for f in n.fps if f['ref'].startswith(('U','RN'))or '0402' in f['package']}|{'Q110'}
 ck('All ICs, resistor network, actual0402 parts and custom-land Q110 assigned factory',high_precision<=set(facpos),dict(expected=sorted(high_precision),missing=sorted(high_precision-set(facpos))))
 visible={};declarations=[]
 def is_hidden(t):
  return 'hide'in [str(x)for x in t if not isinstance(x,list)]or sub(t,'hide')in [[sexpdata.Symbol('yes')],[]]or ('hide'in [str(x)for x in sub(t,'effects',[])if not isinstance(x,list)])
 for fp in subs(n.raw,'footprint'):
  ref=next(x[2]for x in subs(fp,'property')if x[1]=='Reference')
  for t in subs(fp,'property')+subs(fp,'fp_text'):
   layer=sub(t,'layer',[''])[0]
   if layer in ['F.SilkS','B.SilkS']and not is_hidden(t)and t[2]in [ref,'${REFERENCE}','%R']:
    visible.setdefault(ref,set()).add(layer);declarations.append(dict(ref=ref,layer=layer,kind='footprint text'))
 for t in subs(n.raw,'gr_text'):
  layer=sub(t,'layer',[''])[0]
  if layer in ['F.SilkS','B.SilkS']and t[1]in fps:
   visible.setdefault(t[1],set()).add(layer);declarations.append(dict(ref=t[1],layer=layer,kind='board text'))
 issues=[]
 for row in data['marking-legend']:
  ref=row['Reference'];expect=ref in visible
  if (row['Printed_reference'].lower()=='true')!=expect or set(filter(None,row['Printed_layers'].split(',')))!=visible.get(ref,set()):issues.append(ref)
 ck('Marking legend matches independently parsed visible native reference declarations',not issues and set(references('marking-legend'))==set(fps),dict(visible=len(visible),assembly_map_only=sorted(set(fps)-set(visible)),mismatches=issues))
 ck('Immutable ledger and board bytes unchanged',before=={str(f.resolve()):sha(f)for f in paths})
 a.out.mkdir(parents=True,exist_ok=True)
 result=dict(board_sha256=a.expected_sha256,checks=checks,passed=sum(c['passed']for c in checks),failed=sum(not c['passed']for c in checks),visible_declarations=declarations,inputs=before,limitations=['Native reference visibility is independently parsed; final Gerber glyph appearance is separately visually reviewed. No automatic OCR/transcription of every rendered glyph is claimed.','A factory-only placement list is not a factory stencil, assembly quote, stock reservation or approval of manual skill demands.','Harness solder terminations are PCB features; this ledger does not purchase the external cable/battery/display/sensor assemblies.'],order_release=False)
 (a.out/'assembly-ledger-audit.json').write_text(json.dumps(result,indent=2)+'\n');print(json.dumps({k:result[k]for k in ['passed','failed','board_sha256']},indent=2))
 return int(result['failed']>0)
if __name__=='__main__':raise SystemExit(main())
