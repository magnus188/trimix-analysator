from pathlib import Path
import hashlib,json,math,sys,uuid
sys.path.insert(0,str(Path(__file__).resolve().parents[4]/'tools'))
# Resolve the project tool directory from the working-tree root.
sys.path.insert(0,str(Path.cwd()/'hardware/tools'))
from analyzer_sheet import sx,child,children
D=Path(__file__).resolve().parent;src=D/'capswap-open.kicad_pcb'
assert hashlib.sha256(src.read_bytes()).hexdigest()=='951fcf2db9f528dd0ca528d266329ee64c8f9dfd8c9f9c573e22a7410ae6fb23'
r=sx.loads(src.read_text());rm={
 'a4904902-c263-4f25-8e2f-454536875848','937ff7e9-2f34-48ce-ba31-94893fdcd158','47ddc8c7-5a60-4105-8c72-163067177412','aa997d23-21f8-4502-9700-5b19f229ad9b','06367844-ccbd-4f6e-ba78-0c12755ade4f',
 '67e355ab-67ee-496e-83c7-df7afb11e6fe','1ce19ad5-25a8-4efc-b4fb-d90f3ed67797','c803d936-ef33-46b5-b9aa-1b0e17224047'}
rm.update({'08e4f380-4cc2-49a4-b9e9-b69dea88ab32','165857da-3811-4a2b-adf1-cff78a7f6edf','5d55b6fa-82d3-4e50-8dfe-2f0d9ba82515','8c2da038-2474-4bba-be3c-ff5a5d96bdc2','f9049640-5852-4144-9aa6-2c1c6ee4547d'})
found=set();out=[]
for q in r:
 if isinstance(q,list) and str(q[0]) in ['segment','via'] and child(q,'uuid')[1] in rm:found.add(child(q,'uuid')[1])
 else:out.append(q)
assert found==rm
added=[]
def track(net,pts,width=.4,layer='B.Cu'):
 for s,e in zip(pts,pts[1:]):
  if math.dist(s,e)<1e-6:continue
  u=str(uuid.uuid5(uuid.NAMESPACE_URL,'Trimix/bypass/'+str((net,s,e,width,layer))))
  q=sx.loads(f'(segment(start {s[0]} {s[1]})(end {e[0]} {e[1]})(width {width})(layer "{layer}")(net "{net}")(uuid "{u}"))')
  out.append(q);added.append(u)
track('USB_OVP_5V',[(14.75,90),(14.75,91.55)],.25)
track('USB_OVP_5V',[(14.75,91.55),(14.8,91.6)],.25)
track('USB_OVP_5V',[(14.8,91.6),(14.1,91.6)],.4,'F.Cu')
track('USB_OVP_5V',[(14.1,91.6),(13.3,92.4)],.3,'F.Cu')
track('USB_5V',[(14.25,90),(14.25,91.45),(14.0,91.7)],.15)
track('USB_5V',[(14.0,91.7),(13.0,91.7),(12.725,91.975),(12.0,91.975)],.4)
track('GND',[(12,93.525),(12.3,93.825),(12.65,93.825),(12.8,93.95)],.2)
for net,x,y in [('USB_OVP_5V',14.8,91.6),('GND',12.8,93.95)]:
 u=str(uuid.uuid5(uuid.NAMESPACE_URL,'Trimix/bypass/via/'+str((net,x,y))))
 out.append(sx.loads(f'(via(at {x} {y})(size 0.5)(drill 0.25)(layers "F.Cu" "B.Cu")(net "{net}")(uuid "{u}"))'));added.append(u)
(D/'stage1-unfilled.kicad_pcb').write_text(sx.dumps(out)+'\n')
(D/'stage1.json').write_text(json.dumps({'source_sha256':hashlib.sha256(src.read_bytes()).hexdigest(),'removed':sorted(rm),'added':added,'native_DRC_required':True},indent=2)+'\n')
print('Unfilled explicit bypass candidate generated')
