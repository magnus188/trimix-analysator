"""Build an isolated connector-swap candidate; never change the source PCB/CAD."""
from pathlib import Path
import pcbnew as p,json,hashlib,math,datetime
ROOT=Path(__file__).resolve().parents[5]
SOURCE=ROOT/'hardware/pcb/analyzer/Trimix_Analyzer.kicad_pcb'
OUT=Path(__file__).resolve().parent

def sha(path):return hashlib.sha256(path.read_bytes()).hexdigest()
def vec(x,y):return p.VECTOR2I(p.FromMM(x),p.FromMM(y))
def bounds(poly):
 q=poly.BBox();return[p.ToMM(q.GetX()),p.ToMM(q.GetY()),p.ToMM(q.GetRight()),p.ToMM(q.GetBottom())]
def netmap(b):return{(f.GetReference(),q.GetNumber()):q.GetNetname()for f in b.GetFootprints()for q in f.Pads()if q.GetNumber()}
def centre(fp):
 fp.BuildCourtyardCaches();bb=bounds(fp.GetCourtyard(p.F_Cu));return[(bb[0]+bb[2])/2,(bb[1]+bb[3])/2]
def build():
 source_hash=sha(SOURCE);pro=SOURCE.with_suffix('.kicad_pro');project_hash=sha(pro)
 b=p.LoadBoard(str(SOURCE));before_nets=netmap(b);fps={f.GetReference():f for f in b.GetFootprints()}
 poses={r:[p.ToMM(f.GetPosition().x),p.ToMM(f.GetPosition().y),f.GetOrientationDegrees()]for r,f in fps.items()}
 target={'J402':(4.45,16.75),'J401':(4.9,27),'C401':(1.3,23.30),'C402':(1.3,26.51),'R403':(1.3,29.76),'R401':(8.25,25.50)}
 rotations={'C401':90,'C402':90,'R401':90}
 movements=[]
 for ref,new in target.items():
  f=fps[ref];old=centre(f);oldangle=f.GetOrientationDegrees()
  if ref in rotations:f.SetOrientationDegrees(rotations[ref])
  rotatedcentre=centre(f);pos=f.GetPosition();delta=(new[0]-rotatedcentre[0],new[1]-rotatedcentre[1]);f.SetPosition(vec(p.ToMM(pos.x)+delta[0],p.ToMM(pos.y)+delta[1]));f.BuildCourtyardCaches();movements.append({'ref':ref,'old_physical_centre_mm':old,'new_physical_centre_mm':centre(f),'centre_translation_mm':[new[0]-old[0],new[1]-old[1]],'rotation_before_deg':oldangle,'rotation_after_deg':f.GetOrientationDegrees()})
 modified_edges=0
 for g in b.GetDrawings():
  if g.GetLayer()!=p.Edge_Cuts or not isinstance(g,p.PCB_SHAPE):continue
  for getter,setter in [('GetStart','SetStart'),('GetEnd','SetEnd')]:
   v=getattr(g,getter)()
   if v.x==p.FromMM(8.6):getattr(g,setter)(vec(8.9,p.ToMM(v.y)));modified_edges+=1
 assert modified_edges==4,modified_edges
 outline=p.SHAPE_POLY_SET();assert b.GetBoardPolygonOutlines(outline,False)
 courts={};outside=[];copper=[]
 for ref,f in fps.items():
  f.BuildCourtyardCaches();poly=f.GetCourtyard(p.F_Cu);courts[ref]=poly
  if poly.OutlineCount():
   q=poly.CloneDropTriangulation();q.BooleanSubtract(outline)
   if q.Area()>1:outside.append({'ref':ref,'outside_mm2':q.Area()/1e12})
  for pad in f.Pads():
   if not pad.IsOnLayer(p.F_Cu):continue
   q=p.SHAPE_POLY_SET();pad.TransformShapeToPolygon(q,p.F_Cu,p.FromMM(.5),p.FromMM(.001),p.ERROR_OUTSIDE);q.BooleanSubtract(outline)
   if q.Area()>1:copper.append({'ref':ref,'pin':pad.GetNumber(),'outside_mm2':q.Area()/1e12})
 collisions=[]
 refs=sorted(courts)
 for i,ref in enumerate(refs):
  if not courts[ref].OutlineCount():continue
  for rr in refs[i+1:]:
   if courts[rr].OutlineCount()and courts[ref].Collide(courts[rr],0):collisions.append([ref,rr])
 court=bounds(courts['J402']);h2=(4.4,6);distance=math.hypot(max(court[0]-h2[0],h2[0]-court[2],0),max(court[1]-h2[1],h2[1]-court[3],0))
 afterposes={r:[p.ToMM(f.GetPosition().x),p.ToMM(f.GetPosition().y),f.GetOrientationDegrees()]for r,f in fps.items()}
 changed={r for r in poses if poses[r]!=afterposes[r]};assert changed==set(target),changed
 assert before_nets==netmap(b)
 path=OUT/'Trimix_Analyzer_connector_swap_y16_75_candidate.kicad_pcb';p.SaveBoard(str(path),b)
 assert sha(SOURCE)==source_hash and sha(pro)==project_hash
 r={'status':'passed_candidate_PCB_geometry'if not outside and not copper and not collisions and distance>=3.15 else'candidate_needs_review','generated_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'source_board_sha256':source_hash,'candidate':str(path.relative_to(ROOT)),'candidate_sha256':sha(path),'source_board_and_project_unchanged':True,'selected_pose_changes':movements,'all_other_footprint_poses_unchanged':True,'numbered_pin_nets_unchanged':len(before_nets),'outline_change':'Upper tongue widened from 8.60 to 8.90 mm; other outline vertices unchanged.','courtyards_outside_outline':outside,'native_courtyard_collisions':collisions,'copper_below_0_5mm_edge':copper,'J402_courtyard_mm':court,'H2_reserve':{'centre_mm':list(h2),'courtyard_to_centre_mm':distance,'clearance_to_R3_driver_mm':distance-3,'clearance_beyond_R3_plus_0_15mm':distance-3.15},'J402_upper_shell_copper_edge_mm':{'left':4.45-3.91,'right':8.9-(4.45+3.91)},'mechanical_change':{'added_strip_Fusion_X_mm':[59,59.3],'added_strip_Fusion_Y_mm':[103,120],'PCB_nominal_Z_mm':[20.5,22.1]},'limits':['Isolated candidate only: actual source PCB and Fusion untouched.','Coax centre Y16.75 meets the requested Y>=16.51 carrier source constraint; carrier solder-tail windows/support geometry still require native fit/service checks before adoption.','New annotation positions need refresh/collision checks after placement acceptance.','No routing or fabrication release; existing electrical DRC gates remain.','Actual 90-degree coax mating cable and J401 plug/removal envelopes remain unverified.','Generic connector footprints and models still need exact purchased-part qualification.']}
 (OUT/'candidate-checks-y16_75.json').write_text(json.dumps(r,indent=2)+'\n');print(json.dumps(r,indent=2))
if __name__=='__main__':build()
