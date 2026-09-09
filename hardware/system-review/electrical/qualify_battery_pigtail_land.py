"""Approved drill-only22AWG pigtail improvement; preserve poses and copper lands."""
from pathlib import Path
import sys,copy,json,hashlib
ROOT=Path(__file__).resolve().parents[3];OUT=Path(__file__).resolve().parent
sys.path.insert(0,str(ROOT/'hardware/tools'))
from analyzer_sheet import *
def props(a):return {z[1]:z for z in children(a,'property')}
board=P/'Trimix_Analyzer.kicad_pcb';before=hashlib.sha256(board.read_bytes()).hexdigest();a=sx.loads(board.read_text())
f=next(f for f in children(a,'footprint')if props(f)['Reference'][2]=='J102')
name='Battery_Pigtail_2x22AWG_P4.2_D1.00_Pad1.85';fpname='Trimix_Power:'+name
notes={'Connection':'Custom22AWG pigtail PCB lands;1=protected P+,2=protected P-. Verify holder mating connector and polarity.','Package_Status':'Selected board-side1.00mm finished holes,1.85mm lands,4.2mm pitch. Min finished hole0.92mm under reviewed fab tolerance. Actual wire/tinned diameter and strain relief require fit coupon.'}
oldpads=[{'pin':z[1],'drill':child(z,'drill')[1],'size':child(z,'size')[1:]}for z in children(f,'pad')]
f[1]=fpname
for pad in children(f,'pad'):
 child(pad,'drill')[1]=1.0
 assert child(pad,'size')[1:]==[1.85,1.85]
for key,value in notes.items():props(f)[key][2]=value
child(f,'descr')[1]='Selected22AWG pigtail lands;1.00mm finished holes and1.85mm copper on4.2mm pitch. Physical wire/coupon and strain-relief qualification pending.'
lib=copy.deepcopy(f);lib[1]=name
for key in ['uuid','at','path','sheetname','sheetfile']:
 for z in children(lib,key):lib.remove(z)
for z in list(children(lib,'property')):
 if z[1]not in ['Reference','Value','Datasheet','Description']:lib.remove(z)
props(lib)['Reference'][2]='REF**';props(lib)['Value'][2]=name
for z in children(lib,'pad'):
 for key in ['net','pinfunction','pintype','uuid']:
  for y in children(z,key):z.remove(y)
(P/'Trimix_Power.pretty'/f'{name}.kicad_mod').write_text(sx.dumps(lib))
board.write_text(sx.dumps(a))
sch=P/'Charging.kicad_sch';s=sx.loads(sch.read_text());c=next(c for c in children(s,'symbol')if props(c).get('Reference',[0,0,''])[2]=='J102');props(c)['Footprint'][2]=fpname
for key,value in notes.items():props(c)[key][2]=value
sch.write_text(sx.dumps(s))
# Correct nominal-vs-maximum metadata without moving the SMB component.
f=next(f for f in children(a,'footprint')if props(f)['Reference'][2]=='J402')
props(f)['Maximum_body_height_mm'][2]='8.2'
board.write_text(sx.dumps(a))
for sch in P.glob('*.kicad_sch'):
 s=sx.loads(sch.read_text());cs=[c for c in children(s,'symbol')if props(c).get('Reference',[0,0,''])[2]=='J402']
 if cs:
  props(cs[0])['Maximum_body_height_mm'][2]='8.2';sch.write_text(sx.dumps(s))
receipt={'before_sha256':before,'after_sha256':hashlib.sha256(board.read_bytes()).hexdigest(),'old_pads':oldpads,'new_drill_mm':1.0,'retained_land_mm':1.85,'retained_pitch_mm':4.2,'annular_radial_mm':.425,'all_component_poses_preserved':True,'SMB_metadata_correction':'Maximum_body_height8.2mm derived independent extrema; nominal reconstruction7.6mm unchanged.','physical_wire_fit_pending':True,'order_release':False}
(OUT/'battery-pigtail-land-review.json').write_text(json.dumps(receipt,indent=2)+'\n');print(json.dumps(receipt,indent=2))
