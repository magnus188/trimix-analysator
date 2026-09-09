"""Apply the approved matched, keyed Samtec header and inward cable orientation.

One-shot migration. The configured part code is drawing-derived, not an
availability claim. Logical pin7 remains NC; its physical post and PCB land
are omitted. Preserve the geometric centre and all other physical assemblies.
"""
from pathlib import Path
import sys,copy,json,hashlib,shutil
import pcbnew as p
ROOT=Path(__file__).resolve().parents[3];OUT=Path(__file__).resolve().parent
sys.path.insert(0,str(ROOT/'hardware/tools'));from analyzer_sheet import *
def props(a):return {z[1]:z for z in children(a,'property')}
name='Samtec_HTSW-113-07-L-D-007_P2.54mm_Key7';fpname='Trimix_Power:'+name
fields={'MPN':'HTSW-113-07-L-D-007','Manufacturer':'Samtec','Datasheet':'https://suddendocs.samtec.com/prints/htsw-xxx-xx-xxx-x-xx-xx-xx-mkt.pdf',
 'Package_Status':'Drawing-derived keyed option; exact configured availability requires supplier confirmation. Pin7 post omitted; do not manually remove a header pin without a manufacturer-approved procedure.',
 'Harness_review':'Matched gold HTSW -07 posts with IDSD-13-S-04.00-G-P07 cable. Actual Guition termination, cable routing/current/fit pending. Inward cable exit after approved180-degree footprint rotation.',
 'Mechanical':'Body33.02x5.0292x2.54mm nominal; exposed post5.842mm nominal; tail2.54mm reference. 1.02mm finished holes/1.70mm lands. Mated35x5.5x12.5mm engineering envelope is not a manufacturer maximum.',
 'Connection':'Logical pinN to remote JP1pinN via custom verified harness. Pin7 omitted/blocked and electrically unused. Do not reverse the mating connector.'}
src=P/'Trimix_Analyzer.kicad_pcb';before=OUT/'routing-candidate/before-J301-rotation.kicad_pcb'
if not before.exists():shutil.copy2(src,before)
original=sx.loads(src.read_text());f=next(f for f in children(original,'footprint')if props(f)['Reference'][2]=='J301')
old_pose=child(f,'at')[1:];assert old_pose[:2]==[24.725,38.765],old_pose
j_nets={child(z,'net')[1] for z in children(f,'pad') if child(z,'net') is not None};j_nets.discard('GND');j_nets={n for n in j_nets if not n.startswith('unconnected-')}
f[1]=fpname
child(f,'descr')[1]='Samtec HTSW-113-07-L-D-007, keyed position7 omitted, matched IDSD P07; drawing-derived configuration awaiting availability confirmation.'
for key,val in fields.items():props(f)[key][2]=val
for z in list(children(f,'pad')):
 if z[1]=='7':f.remove(z)
 else:child(z,'drill')[1]=1.02
# Correct the nominal insulator width while preserving its centre. Factory
# moulding drawing length33.02 and pin lattice are unchanged.
for z in children(f,'fp_line'):
 if child(z,'layer')[1]!='F.Fab':continue
 for key in ['start','end']:
  xy=child(z,key)
  if xy[1]==-1.27:xy[1]=-1.2446
  if xy[1]==3.81:xy[1]=3.7846
# The previous generic model has all26pins and an incorrect tail. Remove it;
# a separately sourced drawing reconstruction is attached after CAD export.
for z in list(children(f,'model')):f.remove(z)
lib=copy.deepcopy(f);lib[1]=name
for key in ['uuid','at','path','sheetname','sheetfile']:
 for z in children(lib,key):lib.remove(z)
for z in list(children(lib,'property')):
 if z[1] not in ['Reference','Value','Datasheet','Description']:lib.remove(z)
props(lib)['Reference'][2]='REF**';props(lib)['Value'][2]=name
for z in children(lib,'pad'):
 for key in ['net','pinfunction','pintype','uuid']:
  for q in children(z,key):z.remove(q)
(P/'Trimix_Power.pretty'/f'{name}.kicad_mod').write_text(sx.dumps(lib))
replacement=copy.deepcopy(f);removed={}
for target in [src,OUT/'routing-candidate/native/Trimix_Analyzer.kicad_pcb']:
 a=sx.loads(target.read_text());old=next(f for f in children(a,'footprint')if props(f)['Reference'][2]=='J301');a.remove(old);a.append(copy.deepcopy(replacement))
 gone=[]
 for tag in ['segment','via']:
  for z in list(children(a,tag)):
   net=child(z,'net')[1]
   kill=net in j_nets
   if net=='GND':
    points=[child(z,k)[1:3] for k in (['at'] if tag=='via' else ['start','end'])]
    kill=any(23<=x<=28.5 and 37<=y<=71 for x,y in points)
   if kill:a.remove(z);gone.append(child(z,'uuid')[1])
 target.write_text(sx.dumps(a));b=p.LoadBoard(str(target));h=next(q for q in b.GetFootprints()if q.GetReference()=='J301');label=h.Reference();pos=label.GetPosition();angle=label.GetTextAngle();h.SetPosition(p.VECTOR2I(p.FromMM(27.265),p.FromMM(69.245)));h.SetOrientationDegrees(180);label.SetPosition(pos);label.SetTextAngle(angle)
 p.ZONE_FILLER(b).Fill(b.Zones());p.SaveBoard(str(target),b);removed[str(target.relative_to(ROOT))]=len(gone)
sch=P/'Gauge_Interface.kicad_sch';a=sx.loads(sch.read_text());s=next(z for z in children(a,'symbol')if props(z).get('Reference',[0,0,''])[2]=='J301');props(s)['Footprint'][2]=fpname
for key,val in fields.items():props(s)[key][2]=val
sch.write_text(sx.dumps(a))
receipt={'old_pose':old_pose,'new_pose':[27.265,69.245,180],'centre_preserved_mm':[25.995,54.005],'physical_contacts':25,'logical_pin7':'NC and post omitted','signal_net_functions_changed':False,'drill_mm':1.02,'land_mm':1.7,'configured_orderability_confirmed':False,'ripped_up_J301_nets':sorted(j_nets),'removed_copper_counts':removed,'authoritative_after_sha256':hashlib.sha256(src.read_bytes()).hexdigest(),'routing_and_DRC_required':True,'order_release':False}
(OUT/'host-header-migration.json').write_text(json.dumps(receipt,indent=2)+'\n');print(json.dumps(receipt,indent=2))
