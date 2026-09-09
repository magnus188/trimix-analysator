"""Conservative native enclosing-box broad phase, exact-solid fallback.

Every box is derived from and contains the actual native BRep bounding boxes.
A zero box/obstacle intersection proves all contained solids clear at that pose.
Positive boxes never become false collision reports: they recurse, then test the
actual solids. No source geometry or purchased dimensions are changed.
"""
from math import dist
import adsk.core as core
import adsk.fusion as fusion
PAD_CM=1e-5


def run(manager,name,moving,fixed,waypoints,prerequisites,diagnostic=False):
 import verification_a3 as v
 original=[(r,v._record_bounds(r))for r in moving];nodes=[]
 def build(items):
  bb=tuple((min(b[i]for _,b in items)-PAD_CM)if i<3 else(max(b[i]for _,b in items)+PAD_CM)for i in range(6))
  if not all(all(bb[i]<=b[i]and b[i+3]<=bb[i+3]for i in range(3))for _,b in items):raise RuntimeError('Native moving solid not enclosed')
  centre=[(bb[i]+bb[i+3])/2 for i in range(3)];sizes=[bb[i+3]-bb[i]for i in range(3)]
  box=manager.createBox(core.OrientedBoundingBox3D.create(core.Point3D.create(*centre),core.Vector3D.create(1,0,0),core.Vector3D.create(0,1,0),*sizes))
  if not box or not box.isTransient:raise RuntimeError('Enclosing box failed')
  node={'id':len(nodes),'bounds':bb,'box':box,'count':len(items),'children':None,'items':items};nodes.append(node)
  if len(items)>8:
   spans=[max((b[i]+b[i+3])/2 for _,b in items)-min((b[i]+b[i+3])/2 for _,b in items)for i in range(3)]
   axis=max(range(3),key=lambda i:spans[i]);ordered=sorted(items,key=lambda q:(q[1][axis]+q[1][axis+3])/2);mid=len(ordered)//2
   node['children']=[build(ordered[:mid]),build(ordered[mid:])]
  return node
 root=build(original);obstacles=[(r,v._record_bounds(r))for r in fixed]
 collisions=[];samples=[];counts={'box_boolean_checks':0,'box_clear_subtrees':0,'detailed_boolean_checks':0,'numeric_pruned_subtrees':0}
 def atbounds(bb,pose):return tuple(x+pose[i%3]/10 for i,x in enumerate(bb))
 for pose in v._path(waypoints):
  before=len(collisions);cache={}
  def inspect(node,obstacle,obstacle_bounds):
   if not v._numeric_overlap(atbounds(node['bounds'],pose),obstacle_bounds):counts['numeric_pruned_subtrees']+=1;return
   key=('box',node['id'])
   if key not in cache:cache[key]=v._at(manager,node['box'],pose)
   counts['box_boolean_checks']+=1
   if v._intersection_volume(manager,cache[key],obstacle['body'],True)<=v.VOLUME_TOLERANCE_MM3:
    counts['box_clear_subtrees']+=1;return
   if node['children']:
    for child in node['children']:inspect(child,obstacle,obstacle_bounds)
    return
   for part,bb in node['items']:
    if not v._numeric_overlap(atbounds(bb,pose),obstacle_bounds):continue
    key=('part',part['uid'])
    if key not in cache:cache[key]=v._at(manager,part['body'],pose)
    counts['detailed_boolean_checks']+=1
    volume=v._intersection_volume(manager,cache[key],obstacle['body'],True)
    if volume>v.VOLUME_TOLERANCE_MM3:collisions.append({'translation_mm':[round(x,6)for x in pose],'moving':v._label(part),'fixed':v._label(obstacle),'volume_mm3':round(volume,7)})
  for obstacle,bb in obstacles:inspect(root,obstacle,bb)
  samples.append({'translation_mm':[round(x,6)for x in pose],'collision_count':len(collisions)-before})
 return {'name':name,'diagnostic_only':diagnostic,'status':'blocked_at_sampled_poses'if collisions else'clear_at_sampled_poses',
  'moving':[v._label(r)for r in moving],'fixed':[v._label(r)for r in fixed],'prerequisites':prerequisites,'translation_waypoints_mm':waypoints,
  'maximum_sample_step_mm':v.MAX_STEP_MM,'sample_count':len(samples),'samples':samples,'collision_count':len(collisions),'collisions':collisions,
  'blocked_by':sorted({h['fixed']for h in collisions}),'continuous_swept_volume_checked':False,
  'method':'Native union bounding boxes (padded0.0001mm) with verified actual-body containment; exact box/obstacle Boolean clear proof; positive boxes subdivide and fall back to actual per-solid Booleans. Sampled rigid translations only.',
  'enclosing_volume_proof':{'all_actual_body_bounds_contained':True,'moving_body_count':len(moving),'node_count':len(nodes),'padding_mm':PAD_CM*10,
   'nodes':[{'id':n['id'],'bounds_cm':n['bounds'],'member_count':n['count'],'child_ids':[c['id']for c in n['children']]if n['children']else[],
     'leaf_members':[[v._label(r),b]for r,b in n['items']]if not n['children']else[]}for n in nodes],**counts}}
