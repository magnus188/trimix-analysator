"""Read-only local power path witnesses; uses prior tested native direct adjacency reader."""
import sys,json,hashlib,itertools
from pathlib import Path
sys.path.insert(0,str(Path('hardware/system-review/electrical/current-path-review').resolve()))
from inventory import NativeGraph,stackup,p
out=Path(__file__).resolve().parent
src=Path('hardware/pcb/analyzer/Trimix_Analyzer.kicad_pcb');data=src.read_bytes();sha=hashlib.sha256(data).hexdigest();assert sha=='9f274fdf198f1bcb871a4fc360e76693f8a5b048553e6a02998141737956514f'
b=p.LoadBoard(str(src));g=NativeGraph(b,stackup(data.decode()))
pairs=[('U101.23','C102.1'),('U101.19','L101.1'),('U101.20','L101.1'),('U101.21','C103.2'),('U101.19','C103.1'),('U101.22','C107.1'),('U101.15','C108.1'),('U101.16','C108.1'),('L101.2','C104.1'),('L101.2','C105.1'),('U101.15','C104.1'),('U101.15','C105.1'),('U201.10','C201.1'),('U201.10','C202.1'),('U201.1','C203.1'),('U201.4','C204.1'),('U201.4','C206.1'),('U201.6','L201.2'),('U201.8','L201.1'),('U201.3','R201.2'),('U201.3','R202.1'),('U701.3','C701.1'),('U701.5','L701.2'),('U701.6','C702.1'),('U701.6','C703.1'),('U701.1','R701.2'),('U701.1','R702.1'),('U114.2','C114.1'),('U114.5','C101.1'),('U114.4','R119.1'),('U114.4','R116.1'),('U115.5','C115.1'),('U115.6','C114.1'),('U115.9','R126.1'),('U115.7','C116.1')]
rows=[]
for a,c in pairs:
 options=[dict(source_pad_uuid=u,target_pad_uuid=v,**g.witness(u,v))for u,v in itertools.product(g.pad_index[a],g.pad_index[c])]
 good=[x for x in options if x['status']=='explicit_native_witness'];r=min(good,key=lambda x:x['full_item_estimate_ohm_20C_25um_1p6mm'])if good else options[0]
 rows.append(dict(source=a,target=c,**r))
 print(a,c,r['status'],{k:[round(v['full_item_length_mm'],4),v['minimum_width_mm']]for k,v in r.get('layer_summary',{}).items()},r.get('barrel_transition_count'))
ground=[]
for name in ['U101.8','U101.17','U101.18','C102.2','C103.1','C104.2','C105.2','C107.2','C108.2','U201.2','C201.2','C202.2','C203.2','C204.2','C205.2','C206.2','R202.2','U701.4','C701.2','C702.2','C703.2','R702.2','U114.3','R119.2','C114.2','U115.8','C115.2','C116.2','R126.2']:
 u=g.pad_index[name][0]
 if g.items[u]['net']!='GND':continue
 # Nearby physical GND plated anchors, then exact trace-only witness to closest 12.
 pt=g.items[u]['at_mm'];anchors=sorted([q for q in g.items.values()if q.get('plated')and q['net']=='GND'],key=lambda q:sum((a-c)**2 for a,c in zip(pt,q['at_mm'])))[:12]
 opts=[dict(anchor_uuid=q['uuid'],anchor_at_mm=q['at_mm'],**g.witness(u,q['uuid']))for q in anchors]
 good=[q for q in opts if q['status']=='explicit_native_witness']
 chosen=min(good,key=lambda x:x['full_item_estimate_ohm_20C_25um_1p6mm'])if good else None
 ground.append(dict(pad=name,pad_uuid=u,nearest_12_anchor_search=True,witness=chosen,meaning='A missing trace witness is not an open: zones are excluded.'))
 print('GROUND',name,chosen and chosen['anchor_at_mm'],chosen and {k:round(v['full_item_length_mm'],3)for k,v in chosen.get('layer_summary',{}).items()})
result=dict(board=str(src),board_sha256=sha,script_sha256=hashlib.sha256(Path(__file__).read_bytes()).hexdigest(),paths=rows,ground=ground,items={u:g.items[u]for r in rows for u in r.get('ordered_item_uuids',[])},limits=['Complete native item lengths, not clipped end-to-end lengths or loop-area estimates.','Trace/barrel witnesses exclude zones, IC internals and assumed same-number pad links.','No current rating, dynamic impedance, thermal or physical qualification.'])
assert src.read_bytes()==data
(out/'native-local-paths.json').write_text(json.dumps(result,indent=2)+'\n')
