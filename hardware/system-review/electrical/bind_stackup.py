"""Bind published JLC layers without inventing a core adjustment."""
from pathlib import Path
import sys,json,hashlib
ROOT=Path(__file__).resolve().parents[3];OUT=Path(__file__).resolve().parent;sys.path.insert(0,str(ROOT/'hardware/tools'))
from analyzer_sheet import *
path=P/'Trimix_Analyzer.kicad_pcb';a=sx.loads(path.read_text());setup=child(a,'setup')
for old in children(setup,'stackup'):setup.remove(old)
r=json.loads((OUT/'stackup-review.json').read_text());st=node('stackup')
for layer,typ in [('F.SilkS','Top Silk Screen'),('F.Paste','Top Solder Paste'),('F.Mask','Top Solder Mask')]:st.append(node('layer',layer,node('type',typ)))
nd=0
for q in r['layers']:
 if q['dielectric_constant'] is None:st.append(node('layer',q['name'],node('type','copper'),node('thickness',q['thickness_mm'])))
 else:
  nd+=1;st.append(node('layer','dielectric '+str(nd),node('type','core'if q['name']=='core'else'prepreg'),node('thickness',q['thickness_mm']),node('material',q['name']),node('epsilon_r',q['dielectric_constant'])))
for layer,typ in [('B.Mask','Bottom Solder Mask'),('B.Paste','Bottom Solder Paste'),('B.SilkS','Bottom Silk Screen')]:st.append(node('layer',layer,node('type',typ)))
st.append(node('copper_finish','ENIG'));setup.append(st)
for z in children(a,'property'):
 if z[1]=='Fabrication_Stackup':a.remove(z)
a.append(node('property','Fabrication_Stackup','JLC04161H-3313; published laminate/copper sum1.5642mm; finished nominal1.6mm. Mask/finish/tolerance require final vendor quote.'))
save(path,a);r['native_binding_pending']=False;r['native_board_sha256']=hashlib.sha256(path.read_bytes()).hexdigest();r['native_mask_thickness']='not invented; absent from published source';r['native_nominal_finished_thickness_mm']=child(child(a,'general'),'thickness')[1];r['source_and_native_layers_match']=True
(OUT/'stackup-review.json').write_text(json.dumps(r,indent=2)+'\n')
