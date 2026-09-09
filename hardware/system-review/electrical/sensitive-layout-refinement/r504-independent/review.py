from pathlib import Path
import sys,json,hashlib,math
from shapely.geometry import box,LineString
from shapely.ops import unary_union
import sexpdata as s
sys.path.insert(0,str(Path('hardware/system-review/electrical/main-final-independent').resolve()))
from cam_geometry import Native
D=Path(__file__).resolve().parent
src=Path('hardware/system-review/electrical/routing-candidate/sensitive-layout-refinement/root-r504/candidate3/Trimix_Analyzer.kicad_pcb');data=src.read_bytes();n=Native(s.loads(data.decode()))
region=box(19.5-2.15,-(50.65+2.15),19.5+2.15,-(50.65-2.15));ground=unary_union([z['geo']for z in n.zones if z['layer']=='In1.Cu'and z['net']=='GND'])
local=[t for t in n.tracks if t['layer']=='B.Cu'and t['net']=='HE_EXC_DIV'and t['geo'].intersects(box(17,-49.1,20.7,-47))]
geo=unary_union([t['geo']for t in local]);rows=[]
for y in [47.2,46.4]:
 line=LineString([(17.425,-48),(17.425,-y),(20.5,-y),(20.5,-47.75)]).buffer(.075)
 hits=[{'net':t['net'],'start_cartesian_mm':t.get('a',t.get('xy')),'end_cartesian_mm':t.get('b',t.get('xy'))}for t in [*n.tracks,*n.vias,*n.pads_on('B.Cu')]if t['net']!='HE_EXC_DIV'and ('layer'not in t or t['layer']=='B.Cu')and line.distance(t['geo'])<.2]
 rows.append({'nominal_northern_detour_y':y,'foreign_clearance_blockers':hits,'not_native_checked':True})
r={'source':str(src),'sha256':hashlib.sha256(data).hexdigest(),'hypothetical_inductor':'L701centre19.5,50.65 is NOT actually moved in source; analysis projects selected max4.3x4.3mm body only','projected_body_nativeXY':[17.35,48.5,21.65,52.8],'local_HE_EXC_DIV_copper_under_projected_inductor_mm2':geo.intersection(region).area,'local_route_copper_outside_In1_GND_mm2':geo.difference(ground).area,'route_under_inductor_outside_In1_GND_mm2':geo.intersection(region).difference(ground).area,'north_simple_alternatives':rows,'nominal_filter':{'Rtop_ohm':10000,'Rbottom_ohm':10000,'C_F':100e-9,'Rth_ohm':5000,'tau_s':.0005,'cutoff_Hz':1/(2*math.pi*.0005)},'source_reference_pin':'U502.7(AIN2), diagnosticHEexcitation only; RN501measurementbridge unaffected','production_code':{'path':'main/sensors/acquisition_engine.cpp','sha256':hashlib.sha256(Path('main/sensors/acquisition_engine.cpp').read_bytes()).hexdigest(),'lines':'61,65: e.volts*2; latch if excitation<2.9 or>3.1V'},'not_proved':['EM coupling amplitude/magnetic attenuation ofplane orshieldedinductor','postfilterinjection/ringing/rectification','falsefaultor missedfault rate','physicalhelummeasurementaccuracy']}
(D/'review.json').write_text(json.dumps(r,indent=2)+'\n');print(json.dumps(r,indent=2));assert data==src.read_bytes()
