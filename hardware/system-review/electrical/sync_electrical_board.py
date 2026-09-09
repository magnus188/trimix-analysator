"""Synchronize native XML to board; retain poses/UUIDs except changed land geometry.

This stage does not route or approve placement. New parts are staged off-board
until the following explicit placement operation passes geometric checks.
"""
from pathlib import Path
import sys,copy,json,shutil,xml.etree.ElementTree as ET
ROOT=Path(__file__).resolve().parents[3];OUT=Path(__file__).resolve().parent
sys.path.insert(0,str(ROOT/'hardware/tools'))
from analyzer_sheet import *
STOCK=Path('/Applications/KiCad/KiCad.app/Contents/SharedSupport/footprints')
def props(a):return {p[1]:p for p in children(a,'property')}
def loadfp(name):
 lib,fp=name.split(':');path=(P/(lib+'.pretty') if lib.startswith('Trimix_') else STOCK/(lib+'.pretty'))/(fp+'.kicad_mod')
 assert path.exists(),path
 a=sx.loads(path.read_text());a[1]=name;return a

def run():
 path=P/'Trimix_Analyzer.kicad_pcb';back=OUT/'before-board-source-sync.kicad_pcb'
 if not back.exists():shutil.copy2(path,back)
 a=sx.loads(path.read_text());xml=ET.parse(OUT/'analyzer-netlist.xml').getroot()
 comps={c.get('ref'):c for c in xml.findall('./components/comp') if c.findtext('footprint') and c.get('ref') not in ['J901','J902','R901','R902','U901','D901']}
 nets={(n.get('ref'),n.get('pin')):(net.get('name'),n.get('pinfunction',''),n.get('pintype','passive')) for net in xml.findall('./nets/net') for n in net.findall('node')}
 fps={props(f)['Reference'][2]:f for f in children(a,'footprint')};new=[];changed=[]
 for i,(ref,c) in enumerate(comps.items()):
  old=fps.get(ref);name=c.findtext('footprint');replace=old is None or old[1]!=name
  f=loadfp(name) if replace else old
  if replace:
   for k in ['uuid','at','path','sheetname','sheetfile']:
    for z in children(f,k):f.remove(z)
    z=child(old,k) if old else None
    if z:f.append(copy.deepcopy(z))
   if old:
    # Original ref/value field poses are preserved through the land replacement.
    for z in children(f,'property'):f.remove(z)
    for z in children(old,'property'):f.append(copy.deepcopy(z))
    a.remove(old);changed.append(ref)
   else:
    f.append(node('uuid',uid()));f.append(node('at',50+(len(new)%8)*7,110+(len(new)//8)*7,0));new.append(ref)
   a.append(f)
  pr=props(f)
  vals={z.get('name'):z.text or '' for z in c.findall('./fields/field') if z.get('name')!='Footprint'}
  vals.update(Reference=ref,Value=c.findtext('value',''),Datasheet=c.findtext('datasheet',''),Description=c.findtext('description',''))
  for k,v in vals.items():
   if k in pr:pr[k][2]=v
   else:f.append(node('property',k,v,node('at',0,0,0),node('layer','F.Fab'),effects(.8,hide=True)))
  for k in ['sheetname','sheetfile','path']:
   z=child(f,k)
   if z:f.remove(z)
  sh=c.find('sheetpath');f.append(node('path',sh.get('tstamps')+c.findtext('tstamps')))
  for k in ['Sheetname','Sheetfile']:
   v=next((p.get('value') for p in c.findall('property') if p.get('name')==k),'')
   f.append(node(k.lower(),v))
  attr=child(f,'attr')
  if attr is None:attr=node('attr',S('through_hole'));f.append(attr)
  dnp=any(p.get('name')=='dnp' for p in c.findall('property'))
  if S('dnp') in attr:attr.remove(S('dnp'))
  if dnp:attr.append(S('dnp'))
  for pad in children(f,'pad'):
   no=pad[1]
   if no=='':continue
   assert (ref,no) in nets,(ref,no)
   net,pfun,ptype=nets[ref,no]
   for k,v in [('net',net),('pinfunction',pfun),('pintype',ptype)]:
    z=child(pad,k)
    if z:z[1:]=[v]
    else:pad.append(node(k,v))
  # New footprint ref labels start in back silk to avoid consuming top assembly space.
  if old is None:
   r=props(f)['Reference'];child(r,'layer')[1]='B.SilkS';child(r,'at')[1:]=[0,-2,0]
   ef=child(r,'effects');j=child(ef,'justify')
   if j is None:ef.append(node('justify',S('mirror')))
  fps[ref]=f
 save(path,a)
 (OUT/'board-source-sync.json').write_text(json.dumps({'new_refs':new,'replaced_land_refs':changed,'new_parts_staged_off_board':True,'routing_complete':False},indent=2)+'\n')
 print(json.dumps({'new':new,'lands':changed}))
if __name__=='__main__':run()
