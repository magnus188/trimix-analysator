#!/usr/bin/env python3
"""Independent final-main holes/apertures/process review from immutable native/CAM bytes."""
import argparse,hashlib,json,math,warnings
from pathlib import Path
import sexpdata
from gerbonara import GerberFile,ExcellonFile
from cam_geometry import *

def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def readcam(folder, only=None):
    suffix={'F.Cu':'.gtl','In1.Cu':'.g1','In2.Cu':'.g2','B.Cu':'.gbl','F.Mask':'.gts','B.Mask':'.gbs','F.Paste':'.gtp','B.Paste':'.gbp'}
    result={}
    for layer,extension in suffix.items():
        if only is not None and layer not in only:continue
        files=list(folder.glob('*'+extension));assert len(files)==1,(layer,files)
        result[layer]=GerberFile.open(files[0])
    return result

def main():
    p=argparse.ArgumentParser(description=__doc__)
    p.add_argument('--board',type=Path,required=True);p.add_argument('--cam',type=Path,required=True)
    p.add_argument('--out',type=Path,required=True);p.add_argument('--expected-sha256',required=True)
    p.add_argument('--factory-cam',type=Path)
    p.add_argument('--fill-cap-table',type=Path)
    p.add_argument('--contract',type=Path,default=Path(__file__).with_name('final-process-contract.json'))
    a=p.parse_args();a.out.mkdir(parents=True,exist_ok=True)
    inputs=[a.board,a.contract,*sorted(f for f in a.cam.iterdir()if f.is_file())]
    if a.factory_cam:inputs+=sorted(f for f in a.factory_cam.iterdir()if f.is_file())
    if a.fill_cap_table:inputs.append(a.fill_cap_table)
    before={str(f.resolve()):sha(f)for f in inputs};assert sha(a.board)==a.expected_sha256,'Expected immutable board hash mismatch'
    n=Native(sexpdata.loads(a.board.read_text()));contract=json.loads(a.contract.read_text());checks=[]
    def ck(name,passed,detail=None,category='export-process-equivalence'):
        checks.append(dict(check=name,passed=bool(passed),detail=detail,category=category))
    with warnings.catch_warnings(record=True)as caught:
        warnings.simplefilter('always');G=readcam(a.cam)
        factory=readcam(a.factory_cam,['F.Paste','B.Paste'])if a.factory_cam else None
        drills={str(f):ExcellonFile.open(f)for f in a.cam.glob('*.drl')}
    def union(g):
        assert all(o.polarity_dark for o in g.objects),'Negative composite aperture polarity needs separate implementation'
        return unary_union([geometry(o)for o in g.objects])
    openings={l:union(G[l])for l in ['F.Mask','B.Mask','F.Paste','B.Paste']}
    factory_paste={l:union(factory[l])for l in ['F.Paste','B.Paste']}if factory else None
    if factory:
        import csv
        factory_bom=a.cam/'factory-bom.csv'
        # Bind supplied factory list and derive expected apertures directly from
        # the unchanged original native board, not from a filtered-board claim.
        inputs.append(factory_bom);before[str(factory_bom.resolve())]=sha(factory_bom)
        factory_refs={row['Reference']for row in csv.DictReader(factory_bom.open())}
        for layer in ['F.Paste','B.Paste']:
            expected=unary_union([n.aperture(pad,layer)for pad in n.pads_on(layer)if pad['ref']in factory_refs]+[g['geo']for g in n.graphics if g['layer']==layer and g['ref']in factory_refs])
            actual=factory_paste[layer]
            extra_refs={attrs(o).get('.C',('',))[0]for o in factory[layer].objects if attrs(o).get('.C')} - factory_refs
            ck(layer+' factory stencil exactly retains original factory-part apertures only',actual.hausdorff_distance(expected)<SHAPE_EPS and actual.symmetric_difference(expected).area<max(.00001,expected.length*SHAPE_EPS)and not extra_refs,dict(factory_refs=sorted(factory_refs),expected_area_mm2=expected.area,actual_area_mm2=actual.area,extra_refs=sorted(extra_refs)))
            copper=union(G['F.Cu'if layer=='F.Paste'else'B.Cu'])
            unsupported=actual.difference(copper.buffer(SHAPE_EPS))
            ck(layer+' factory paste stays over exported copper lands',unsupported.area<1e-8,dict(paste_outside_copper_area_mm2=unsupported.area))
            forbidden=openings[layer].difference(expected.buffer(SHAPE_EPS)).area
            ck('Negative control: full native '+layer+' is rejected as a factory-only stencil',forbidden>1e-4,dict(forbidden_full_stencil_area_mm2=forbidden),category='control')
    allholes=[]
    for f,g in drills.items():
        for o in g.objects:
            shape=geometry(o);centre=shape.centroid
            allholes.append(dict(file=f,plated='NPTH'not in Path(f).name,xy=(centre.x,centre.y),diameter=o.aperture.diameter,geo=shape))
    stack=next(x for x in n.setup if tag(x)=='stackup')
    cu=[(str(x[1]),sub(x,'thickness'))for x in subs(stack,'layer')if str(x[1])in CU]
    ck('Native nominal thickness and four-layer copper stack match contract',abs(float(sub(next(x for x in n.raw if tag(x)=='general'),'thickness')[0])-contract['nominal_board_thickness_mm'])<EPS and [v[0]for v in cu]==CU and all(abs(float(v[1][0])-target)<EPS for v,target in zip(cu,contract['copper_thickness_mm'])),cu)
    expected_xy=set();vip=[]
    for wanted in contract['VIPPO']:
        xy=n.xy(wanted['xy_mm']);expected_xy.add(tuple(wanted['xy_mm']))
        found=[v for v in subs(n.raw,'via')if math.dist(sub(v,'at'),wanted['xy_mm'])<EPS]
        ck('Exactly one native VIPPO at '+str(wanted['xy_mm']),len(found)==1)
        if len(found)!=1:continue
        v=found[0];disk=Point(xy).buffer(wanted['land_mm']/2,quad_segs=Q)
        global_tent=next((x for x in n.setup if tag(x)=='tenting'),[])
        tent=next((x for x in v if tag(x)=='tenting'),global_tent)
        ck('Exact filled/capped/effective-tented size/net '+str(wanted['xy_mm']),abs(sub(v,'size')[0]-wanted['land_mm'])<EPS and abs(sub(v,'drill')[0]-wanted['drill_mm'])<EPS and sub(v,'net')==[wanted['net']] and sub(v,'filling')==[sexpdata.Symbol('yes')] and sub(v,'capping')==[sexpdata.Symbol('yes')] and sub(tent,'front')==[sexpdata.Symbol('yes')] and sub(tent,'back')==[sexpdata.Symbol('yes')],dict(tenting_source='explicit via'if tent is not global_tent else 'native setup default',front=str(sub(tent,'front')),back=str(sub(tent,'back'))))
        pads=[q for q in n.pads if q['ref']==wanted['reference']and q['pin']==wanted['pin']]
        for layer in CU:
            hits=[o for o in G[layer].objects if type(o).__name__=='Flash'and math.dist((o.x,o.y),xy)<EPS and attrs(o).get('.N')==(wanted['net'],)and geometry(o).hausdorff_distance(disk)<SHAPE_EPS]
            ck(layer+' exact single VIPPO land '+str(wanted['xy_mm']),len(hits)==1,dict(count=len(hits)))
        hits=[h for h in allholes if math.dist(h['xy'],xy)<EPS]
        ck('Exact single plated hole '+str(wanted['xy_mm']),len(hits)==1 and hits[0]['plated']and abs(hits[0]['diameter']-wanted['drill_mm'])<EPS)
        for layer in ['F.Mask','F.Paste','B.Mask','B.Paste']:
            actual=openings[layer].intersection(disk)
            expected=unary_union([n.aperture(q,layer)for q in pads if q in n.pads_on(layer)]).intersection(disk)
            ck(layer+' preserves only purchased-pad aperture at '+str(wanted['xy_mm']),actual.symmetric_difference(expected).area<1e-6,dict(actual_area_mm2=actual.area,expected_area_mm2=expected.area))
        # In-memory process negatives: full cap opening is forbidden even with identical copper.
        forbidden=disk.difference(unary_union([n.aperture(q,'B.Mask')for q in pads if q in n.pads_on('B.Mask')])).area
        ck('Negative control: full front via mask opening would fail '+str(wanted['xy_mm']),disk.area>1e-3 and openings['F.Mask'].intersection(disk).area<1e-8,category='control')
        vip.append(wanted|dict(uuid=str(sub(v,'uuid')[0]),nominal_annulus_mm=(wanted['land_mm']-wanted['drill_mm'])/2,full_back_cap_extra_exposed_area_mm2=forbidden))
    other_special=[dict(xy=sub(v,'at'),uuid=str(sub(v,'uuid')[0]))for v in subs(n.raw,'via')if(sub(v,'filling')==[sexpdata.Symbol('yes')]or sub(v,'capping')==[sexpdata.Symbol('yes')])and tuple(sub(v,'at'))not in expected_xy]
    ck('No unlisted filled/capped routed via hidden in process list',not other_special,other_special)
    q110=next(f for f in n.fps if f['ref']=='Q110');qspec=contract['Q110'];qp=[q for q in n.pads if q['ref']=='Q110']
    ck('Q110 exact manufacturer-land identity and dimensions retained',q110['props'].get('MPN')==qspec['MPN']and q110['package']==qspec['footprint_suffix']and len(qp)==3 and all(q['shape']==qspec['pad_shape']and abs(q['w']-.9)<EPS and abs(q['h']-.8)<EPS and math.dist(sub(q['raw'],'at')[:2],qspec['pad_centres_native_local_mm'][q['pin']])<EPS for q in qp),dict(MPN=q110['props'].get('MPN'),package=q110['package'],pads=[{k:q[k]for k in ['pin','shape','w','h','x','y','angle']}for q in qp]))
    c708=contract['ordinary_C708_via'];cv=[v for v in n.vias if math.dist(v['xy'],n.xy(c708['xy_mm']))<EPS]
    ck('Ordinary C708 ground via has corrected exact centre and ordinary dimensions',len(cv)==1 and cv[0]['net']==c708['net']and abs(cv[0]['size']-c708['land_mm'])<EPS and abs(cv[0]['drill']-c708['drill_mm'])<EPS)
    interactions=[];ordinary_bad=[];package_bad=[]
    # Examine actual exported holes against actual exported paste, including package pad holes.
    for hole in n.holes:
        centre=hole['geo'].centroid
        hits=[h for h in allholes if h['plated']==hole['plated']and math.dist(h['xy'],(centre.x,centre.y))<.000710 and abs(h['diameter']-hole['diameter'])<EPS and h['geo'].hausdorff_distance(hole['geo'])<.000710]
        if len(hits)!=1:continue # General reader reports exact drill parity failure separately.
        actual=hits[0];is_routed=hole['id'].startswith('via');v=n.vias[int(hole['id'][3:])]if is_routed else None
        is_special=is_routed and any(math.dist(v['xy'],n.xy(c['xy_mm']))<EPS for c in contract['VIPPO'])
        for layer in ['F.Paste','B.Paste']:
            area=actual['geo'].intersection(openings[layer]).area
            if area<1e-8:continue
            involved=[q for q in n.pads_on(layer)if n.aperture(q,layer).intersection(actual['geo']).area>1e-8]
            populated=[q for q in involved if 'dnp'not in next(f for f in n.fps if f['ref']==q['ref'])['attributes']]
            fa=None if factory_paste is None else actual['geo'].intersection(factory_paste[layer]).area
            row=dict(hole=hole['id'],xy_cam_mm=actual['xy'],diameter_mm=actual['diameter'],plated=actual['plated'],layer=layer,paste_overlap_mm2=area,affected_pads=[q['id']for q in involved],populated_pads=[q['id']for q in populated],reviewed_VIPPO=is_special,factory_paste_overlap_mm2=fa)
            interactions.append(row)
            if is_routed and not is_special and (populated or fa is None or fa>1e-8):ordinary_bad.append(row)
            if not is_routed and populated:package_bad.append(row)
    ck('No ordinary routed bore prints solder paste without explicit factory disposition',not ordinary_bad,ordinary_bad,'assembly-process-gate')
    fill_table=[]
    if a.fill_cap_table:
        import csv
        fill_table=list(csv.DictReader(a.fill_cap_table.open()));expected=[]
        for pad in n.pads:
            if (pad['ref'],pad['pin'])not in [('U101','25'),('U201','15')]or str(pad['raw'][2])!='thru_hole':continue
            hole=next(h for h in n.holes if h['id']==pad['id'])
            expected.append(dict(ref=pad['ref'],pin=pad['pin'],xy=(pad['x'],pad['y']),diameter=hole['diameter'],uuid=str(sub(pad['raw'],'uuid')[0]),net=pad['net']))
        for wanted in contract['VIPPO']:
            v=next(v for v in subs(n.raw,'via')if math.dist(sub(v,'at'),wanted['xy_mm'])<EPS)
            expected.append(dict(ref=wanted['reference'],pin=wanted['pin'],xy=n.xy(wanted['xy_mm']),diameter=wanted['drill_mm'],uuid=str(sub(v,'uuid')[0]),net=wanted['net']))
        used=set();fail=[]
        for item in expected:
            hits=[i for i,row in enumerate(fill_table)if i not in used and row['Reference']==item['ref']and row['Pin']==item['pin']and row['Native_UUID']==item['uuid']and row['Net']==item['net']and math.dist(n.xy([float(row['PCB_X_mm']),float(row['PCB_Y_mm'])]),item['xy'])<EPS and abs(float(row['Bore_mm'])-item['diameter'])<EPS and row['Required_process']]
            actual=[h for h in allholes if h['plated']and math.dist(h['xy'],item['xy'])<.000710 and abs(h['diameter']-item['diameter'])<EPS]
            if len(hits)==1 and len(actual)==1:used.add(hits[0])
            else:fail.append(item|dict(table_hits=len(hits),exported_hole_hits=len(actual)))
        ck('Exact fill/cap table covers24package thermal holes plus3signalVIPPO and actual drills',len(expected)==27 and len(fill_table)==27 and len(used)==27 and not fail,dict(expected=len(expected),listed=len(fill_table),matched=len(used),mismatches=fail))
    else:ck('Exact fill/cap coordinate table supplied',False,None,'assembly-process-gate')
    ck('Package thermal-hole paste overlaps still need acknowledged factory fill/cap process',not package_bad,package_bad,'factory-approval-hold')
    ck('Actual factory stencil exports supplied for DNP assembly verification',factory is not None,None,'assembly-process-gate')
    ck('Immutable input bytes unchanged',before=={str(f.resolve()):sha(f)for f in inputs})
    out=dict(schema=1,status='Final supplied bytes — no fabrication/assembly release',expected_board_sha256=a.expected_sha256,checks=checks,passed=sum(c['passed']for c in checks),failed=sum(not c['passed']for c in checks),VIPPO=vip,all_bore_paste_interactions=interactions,fill_cap_table=fill_table,inputs=before,parser_warnings=[str(w.message)for w in caught],fabricator_or_assembler_acceptance=False,order_release=False,factory_holds=contract['factory_holds'])
    (a.out/'process-audit.json').write_text(json.dumps(out,indent=2)+'\n')
    print(json.dumps({k:out[k]for k in ['status','passed','failed','expected_board_sha256']},indent=2))
    return int(any(not c['passed']for c in checks))

if __name__=='__main__':raise SystemExit(main())
