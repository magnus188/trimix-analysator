"""Read-only KiCad/source correspondence for an immutable placement checkpoint.
Run with KiCad's bundled Python. Never saves or changes the board.
"""
from pathlib import Path
import hashlib,json,math
import pcbnew as pcb

BASE=Path(__file__).resolve().parents[1]
ROOT=BASE.parents[2]
CHECKPOINT=ROOT/'hardware/system-review/electrical/placement-checkpoint-v2/checkpoint.json'

def audit(checkpoint_path=CHECKPOINT, output_path=None):
    """Validate a hash-bound board/height bundle without saving the board.

    The default remains the historical placement-v2 bundle. Explicit paths let
    the final integration validate a new frozen bundle without editing that
    historical receipt or treating it as the final routed board.
    """
    checkpoint_path=Path(checkpoint_path)
    checkpoint=json.loads(checkpoint_path.read_text());files=checkpoint['files']
    for rel,digest in files.items():
        if hashlib.sha256((ROOT/rel).read_bytes()).hexdigest()!=digest:raise RuntimeError('Source changed: '+rel)
    boards=[k for k in files if k.endswith('.kicad_pcb')]
    contracts=[k for k in files if k.endswith('component-height-contract.json')]
    if len(boards)!=1 or len(contracts)!=1:raise RuntimeError('Exactly one board and height JSON are required in this checkpoint')
    board_path=ROOT/boards[0]
    contract_path=ROOT/contracts[0]
    board=pcb.LoadBoard(str(board_path));contract=json.loads(contract_path.read_text())
    if contract['board_sha256']!=hashlib.sha256(board_path.read_bytes()).hexdigest():
        raise RuntimeError('Height contract is not bound to the actual frozen board')
    native_footprints=list(board.GetFootprints())
    footprints={f.GetReference():f for f in native_footprints}
    if len(footprints)!=len(native_footprints):raise RuntimeError('Duplicate native footprint reference')
    rows={r['reference']:r for r in contract['rows']}
    if len(rows)!=len(contract['rows']):raise RuntimeError('Duplicate contract reference')
    errors=[];classified=[]
    for ref,fp in sorted(footprints.items()):
        row=rows.get(ref);name=fp.GetFPID().GetLibItemName().wx_str()
        if not row:
            if ref.startswith('TP') and 'TestPoint' in name:kind='testpad_no_component_height'
            elif ('MountingHole' in name or (ref in ('H1','H2') and len(list(fp.Pads()))==1 and all(p.GetAttribute()==pcb.PAD_ATTRIB_NPTH for p in fp.Pads()))):kind='mechanical_NPTH_no_component_height'
            else:kind='unclassified_missing_height';errors.append(ref+' lacks contract')
            classified.append({'reference':ref,'classification':kind,'footprint':fp.GetFPID().GetLibNickname().wx_str()+':'+name});continue
        side='B.Cu' if fp.GetLayer()==pcb.B_Cu else 'F.Cu'
        pose=[pcb.ToMM(fp.GetPosition().x),pcb.ToMM(fp.GetPosition().y),fp.GetOrientationDegrees()%360]
        expected=[row['PCB_x_mm'],row['PCB_y_mm'],row['rotation_deg']%360]
        if any(abs(a-b)>1e-6 for a,b in zip(pose,expected)):errors.append(ref+' pose mismatch')
        if side!=row['side']:errors.append(ref+' side mismatch')
        if bool(fp.IsDNP())!=bool(row['DNP']):errors.append(ref+' DNP mismatch')
        actual_mpn=fp.GetFieldsText().get('MPN','')
        if actual_mpn!=row['MPN']:errors.append(ref+' MPN mismatch')
        coords=[row[k] for k in ('Fusion_x_min_mm','Fusion_x_max_mm','Fusion_y_min_mm','Fusion_y_max_mm','Fusion_z_bottom_mm','Fusion_z_top_mm')]
        if not all(math.isfinite(x) for x in coords):errors.append(ref+' nonfinite bounds')
        if min(coords[1]-coords[0],coords[3]-coords[2],coords[5]-coords[4])<=0:errors.append(ref+' degenerate bounds')
        expectedxy=[50.4+row['x_min_mm'],50.4+row['x_max_mm'],120-row['y_max_mm'],120-row['y_min_mm']]
        if max(abs(a-b)for a,b in zip(coords[:4],expectedxy))>1e-6:errors.append(ref+' registration mismatch')
        plane=coords[5] if side=='B.Cu' else coords[4]
        if abs(plane-(20.5 if side=='B.Cu' else 22.1))>1e-6:errors.append(ref+' side-plane mismatch')
        classified.append({'reference':ref,'classification':'DNP_excluded' if row['DNP'] else'populated_maximum_or_allocation','side':side,'pose_mm_deg':pose,'MPN':actual_mpn,'footprint':fp.GetFPID().GetLibNickname().wx_str()+':'+name,'source':row.get('source'),'basis':row['basis']})
    for ref in rows.keys()-footprints.keys():errors.append(ref+' contract ref missing from board')
    counts={k:sum(r['classification']==k for r in classified)for k in sorted({r['classification']for r in classified})}
    report={'status':'source_coverage_and_pose_pass' if not errors else'needs_review','checkpoint_file':str(checkpoint_path),
      'checkpoint_sha256':hashlib.sha256(checkpoint_path.read_bytes()).hexdigest(),'source_hashes':files,'KiCad_version':pcb.GetBuildVersion(),
      'footprints':len(footprints),'contract_rows':len(rows),'classification_counts':counts,'rows':classified,'errors':errors,
      'backside_populated_references':[r['reference']for r in classified if r.get('side')=='B.Cu'and r['classification']=='populated_maximum_or_allocation'],
      'limits':['Coverage and source geometry registration only; maxima include nominal/F.Fab and provisional allocations.','No PCB routing, purchased dimensions, solder, connector mating, fabrication or physical fit qualification.'],'board_saved_or_modified':False}
    target=Path(output_path)if output_path else BASE/'verification/placement-v2-height-coverage.json'
    target.parent.mkdir(parents=True,exist_ok=True);target.write_text(json.dumps(report,indent=2)+'\n')
    print(json.dumps({k:v for k,v in report.items()if k not in ['rows','source_hashes']},indent=2))
    if errors:raise RuntimeError('Height contract does not correspond to frozen board')
    return report

if __name__=='__main__':
    import argparse
    parser=argparse.ArgumentParser()
    parser.add_argument('--checkpoint',type=Path,default=CHECKPOINT)
    parser.add_argument('--output',type=Path)
    args=parser.parse_args()
    audit(args.checkpoint,args.output)
