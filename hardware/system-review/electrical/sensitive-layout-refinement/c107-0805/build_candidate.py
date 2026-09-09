import setup as c,json,hashlib
p=c.p;b=c.b;f=c.f
f.SetPosition(c.vec((13.875,79.125)));f.SetOrientationDegrees(0)
removed=[]
REMOVE=['d938035e-b894-48ac-a6e1-4f808e2ae730','fc360a06-afd6-417a-aa28-183203d8e73d','35d70dba-d39f-40e5-8108-2fcb07098cde','421eecae-b762-4d25-853a-db4c8ffef2f1','b60fa637-1165-4666-97bc-8532aec97ec6']
for t in list(b.GetTracks()):
 if t.m_Uuid.AsString()in REMOVE or (isinstance(t,p.PCB_VIA)and c.xy(t.GetPosition())==[9.7045,76.2536]):removed.append(t.m_Uuid.AsString());b.Remove(t)
print(type(b),type(b.GetNetInfo()),[(str(k),type(k))for k in c.NETCODES if 'REGN' in str(k)],flush=True)
c.track('/01  CHARGING + BATTERY/BQ_REGN',[(12.95,79.125),(12.79,81.15)],p.B_Cu,.25)
c.track('GND',[(14.8,79.125),(16.05,78.05)],p.B_Cu,.25);c.via('GND',(16.05,78.05))
c.save()
(c.OUT/'trial.json').write_text(json.dumps({'status':'isolated pending native/CAD/bench qualification','source_sha256':hashlib.sha256((c.D/'source.kicad_pcb').read_bytes()).hexdigest(),'removed':removed,'C107':{'side':'B','pose':[13.875,79.125,0],'mpn':'C2012X5R1A476M125AC','body_max_mm':[2.2,1.45,1.45],'footprint':f.GetFPIDAsString()},'no_canonical_mutation':True},indent=2)+'\n')
print('saved',c.OUT)
