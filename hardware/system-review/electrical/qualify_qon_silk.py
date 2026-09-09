"""Preserve all TI RTW lands; omit two silk lines under the local service pad."""
from pathlib import Path
import sys,copy,json
sys.path.insert(0,str(Path(__file__).resolve().parents[2]/'tools'));from analyzer_sheet import *
OUT=Path(__file__).resolve().parent;name='TI_RTW24_4x4_ThermalVias_ServicePad';lib='Trimix_Power:'+name
stock=Path('/Applications/KiCad/KiCad.app/Contents/SharedSupport/footprints/Package_DFN_QFN.pretty/Texas_RTW_WQFN-24-1EP_4x4mm_P0.5mm_EP2.7x2.7mm_ThermalVias.kicad_mod');a=sx.loads(stock.read_text());old=copy.deepcopy(children(a,'pad'));a[1]=name
removed=[n for n in children(a,'fp_line')if child(n,'layer')[1]=='F.SilkS'and all(float(v)>0 for v in child(n,'start')[1:]+child(n,'end')[1:])]
assert len(removed)==2
for n in removed:a.remove(n)
assert children(a,'pad')==old;save(P/'Trimix_Power.pretty'/f'{name}.kicad_mod',a)
path=P/'Charging.kicad_sch';s=sx.loads(path.read_text());u=next(n for n in children(s,'symbol')if child(n,'property')[2]=='U101');next(n for n in children(u,'property')if n[1]=='Footprint')[2]=lib;save(path,s)
path=OUT/'routing-candidate/qon-probe-source.kicad_pcb';b=sx.loads(path.read_text());u=next(n for n in children(b,'footprint')if child(n,'property')[2]=='U101');u[1]=lib;save(path,b)
(OUT/'qon-footprint-silk-review.json').write_text(json.dumps({'source_footprint':str(stock),'new_library_id':lib,'all_copper_drills_paste_mask_and_courtyard_identical':True,'only_change':'two bottom-right silk corner lines omitted to avoid TP1014 mask opening','pin1_mark_retained':True,'native_parity_required':True},indent=2)+'\n')
