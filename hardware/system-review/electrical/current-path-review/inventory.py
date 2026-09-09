"""Read-only, trace-only native KiCad adjacency witnesses and copper estimates.

Run with KiCad's bundled Python. Never calls SaveBoard and never edits its input.
Resistance is a full-native-item sum for one explicit witness, not a field or
parallel-network solution. Pad/track overlap and mid-segment junction tails are
not clipped; these ambiguities are retained explicitly in every report.
"""
import argparse, collections, csv, hashlib, heapq, itertools, json, math, re
from pathlib import Path
import pcbnew as p

RHO20 = 1.0 / 58.0 / 1000.0  # ohm mm: NBS H100, printed p40 / PDF p46
ALPHA20 = .00393
NIST_URL = 'https://nvlpubs.nist.gov/nistpubs/Legacy/hb/nbshandbook100.pdf'
KICAD_URL = 'https://docs.kicad.org/doxygen-python-10.0/classpcbnew_1_1CONNECTIVITY__DATA.html'
BASE = dict(temperature_C=20, finished_height_mm=1.6, plating_um=25,
            geometry_case='native_nominal')

def uid(o): return o.m_Uuid.AsString()
def mm(v): return p.ToMM(v)
def xy(v): return [mm(v.x), mm(v.y)]
def digest(data): return hashlib.sha256(data).hexdigest()

def stackup(text):
    start = text.index('(stackup')
    depth = 0; quoted = False; escaped = False; end = start
    for end in range(start, len(text)):
        c = text[end]
        if escaped: escaped = False; continue
        if c == '\\' and quoted: escaped = True; continue
        if c == '"': quoted = not quoted
        if not quoted:
            depth += (c == '(') - (c == ')')
            if depth == 0: break
    blocks = re.findall(r'\(layer "([^"]+)"\s+\(type "([^"]+)"\)\s+\(thickness ([0-9.]+)\)', text[start:end+1])
    cu = {}; centers = {}; z = 0
    for name, kind, thickness in blocks:
        thickness = float(thickness)
        if kind == 'copper': cu[name] = thickness; centers[name] = z + thickness / 2
        if kind in ('copper', 'core', 'prepreg'): z += thickness
    expected = {'F.Cu', 'In1.Cu', 'In2.Cu', 'B.Cu'}
    if set(cu) != expected: raise ValueError('Expected explicit four-layer stackup; do not assume copper thickness')
    f, back = centers['F.Cu'], centers['B.Cu']
    return {'copper_thickness_mm': cu, 'laminate_and_copper_sum_mm': z,
            'copper_center_z_fraction': {k: (v-f)/(back-f) for k,v in centers.items()},
            'barrel_model': 'Native relative copper-center positions scaled to each labelled finished-height sensitivity; outer-to-outer equals the whole selected height.'}

def barrel_area(drill, plating_mm):
    """Circular/oval finished bore, outward copper thickness; mm²."""
    small, large = sorted(drill)
    if small <= 0: raise ValueError('Non-positive plated bore')
    perimeter = math.pi * small + 2 * (large-small)
    return perimeter * plating_mm + math.pi * plating_mm**2

def estimate_edge(meta, stack, case):
    rho = RHO20 * (1 + ALPHA20 * (case['temperature_C']-20))
    if meta['kind'] == 'trace':
        w = meta['width_mm']; t = stack['copper_thickness_mm'][meta['layer']]
        if case['geometry_case'] == 'width_minus_25um_copper_80pct': w -= .025; t *= .8
        if w <= 0: raise ValueError('Sensitivity has non-positive width')
        return rho * meta['full_item_length_mm'] / (w*t)
    if meta['kind'] == 'barrel':
        dz = abs(stack['copper_center_z_fraction'][meta['from_layer']]-stack['copper_center_z_fraction'][meta['to_layer']])
        length = case['finished_height_mm'] * dz
        return rho * length / barrel_area(meta['drill_mm'], case['plating_um']/1000)
    return 0.0

class NativeGraph:
    def __init__(self, board, stack):
        self.board = board; self.stack = stack
        self.ignored_zone_count = len(list(board.Zones()))
        # Direct adjacency queries below admit only physical track/pad objects;
        # zone objects are never nodes or edges, and no transitive net query is used.
        self.cn = board.GetConnectivity(); self.cn.Build(board)
        self.layers = list(board.GetEnabledLayers().CuStack())
        self.items = {}; self.objects = {}; self.pad_index = collections.defaultdict(list)
        for f in board.GetFootprints():
            for q in f.Pads():
                if not q.GetNetname(): continue
                layers = [board.GetLayerName(L) for L in self.layers if q.IsOnLayer(L)]
                if not layers: continue
                u = uid(q); self.objects[u] = q
                self.items[u] = dict(uuid=u, kind='pad', ref=f.GetReference(), pin=q.GetNumber(),
                    net=q.GetNetname(), layers=layers, at_mm=xy(q.GetPosition()),
                    drill_mm=xy(q.GetDrillSize()), plated=q.GetAttribute()==p.PAD_ATTRIB_PTH)
                self.pad_index[f.GetReference()+'.'+q.GetNumber()].append(u)
        for q in board.GetTracks():
            u=uid(q); self.objects[u]=q
            if isinstance(q,p.PCB_VIA):
                layers=[board.GetLayerName(L) for L in self.layers if q.IsOnLayer(L)]
                self.items[u]=dict(uuid=u,kind='via',net=q.GetNetname(),layers=layers,
                    at_mm=xy(q.GetPosition()),diameter_mm=mm(q.GetWidth(p.F_Cu)),
                    drill_mm=[mm(q.GetDrillValue())]*2,plated=True)
            elif isinstance(q,p.PCB_ARC):
                raise ValueError('Track arcs are unsupported; fail rather than approximate their witness')
            else:
                L=board.GetLayerName(q.GetLayer())
                self.items[u]=dict(uuid=u,kind='track',net=q.GetNetname(),layers=[L],
                    start_mm=xy(q.GetStart()),end_mm=xy(q.GetEnd()),width_mm=mm(q.GetWidth()),
                    full_item_length_mm=mm(q.GetLength()))
        self.adj=collections.defaultdict(list); self.native_pairs=set()
        for u,row in self.items.items():
            for L in row['layers']:
                if row['kind']=='track':
                    self.edge((u,L,'in'),(u,L,'out'),dict(kind='trace',uuid=u,layer=L,
                        full_item_length_mm=row['full_item_length_mm'],width_mm=row['width_mm']))
            if row.get('plated') and min(row['drill_mm'])>0:
                for a,b in itertools.combinations(row['layers'],2):
                    for f,t in [(a,b),(b,a)]:
                        self.edge((u,f,'port'),(u,t,'port'),dict(kind='barrel',uuid=u,
                            barrel_type=row['kind'],from_layer=f,to_layer=t,drill_mm=row['drill_mm']))
            obj=self.objects[u]
            for vobj in list(self.cn.GetConnectedTracks(obj))+list(self.cn.GetConnectedPads(obj)):
                v=uid(vobj)
                if v not in self.items or v==u: continue
                other=self.items[v]
                if row['net']!=other['net']: continue
                self.native_pairs.add(tuple(sorted((u,v))))
                # A direct neighbour may exist on only one of a plated item's layers.
                # Restrict each edge to common physical copper layers.
                for L in set(row['layers']) & set(other['layers']):
                    self.edge((u,L,'out' if row['kind']=='track' else 'port'),
                              (v,L,'in' if other['kind']=='track' else 'port'),
                              dict(kind='native_adjacency',from_uuid=u,to_uuid=v,layer=L))

    def edge(self,a,b,meta):
        self.adj[a].append((b,estimate_edge(meta,self.stack,BASE),meta))

    def witness(self,source,target):
        if self.items[source]['net']!=self.items[target]['net']:
            return {'status':'different_net_contract', 'source_net':self.items[source]['net'],
                    'target_net':self.items[target]['net']}
        starts=[(source,L,'port') for L in self.items[source]['layers']]
        goals={(target,L,'port') for L in self.items[target]['layers']}
        dist={s:0.0 for s in starts}; prev={}; queue=[(0.0,s)for s in starts];heapq.heapify(queue);end=None
        while queue:
            cost,node=heapq.heappop(queue)
            if cost!=dist.get(node):continue
            if node in goals:end=node;break
            for nxt,w,meta in self.adj[node]:
                new=cost+w
                if new < dist.get(nxt,float('inf'))-1e-15:
                    dist[nxt]=new;prev[nxt]=(node,meta);heapq.heappush(queue,(new,nxt))
        if end is None:return {'status':'no_explicit_trace_path','reachable_port_count':len(dist),
            'meaning':'Unresolved by this zone-free witness; not proof that the full board is open.'}
        edges=[];nodes=[end]
        while end in prev:
            end,meta=prev[end];edges.append(meta);nodes.append(end)
        edges.reverse();nodes.reverse()
        used=[]
        for node in nodes:
            if not used or used[-1]!=node[0]:used.append(node[0])
        sums=collections.defaultdict(lambda:{'full_item_length_mm':0.0,'minimum_width_mm':None,'track_uuids':[]})
        for e in edges:
            if e['kind']=='trace':
                q=sums[e['layer']];q['full_item_length_mm']+=e['full_item_length_mm']
                q['minimum_width_mm']=min(q['minimum_width_mm']or e['width_mm'],e['width_mm']);q['track_uuids'].append(e['uuid'])
        return {'status':'explicit_native_witness','net':self.items[source]['net'],
            'source_layer':nodes[0][1],'target_layer':nodes[-1][1],
            'ordered_item_uuids':used,'ordered_edges':edges,'layer_summary':dict(sums),
            'barrel_transition_count':sum(e['kind']=='barrel'for e in edges),
            'full_item_estimate_ohm_20C_25um_1p6mm':sum(estimate_edge(e,self.stack,BASE)for e in edges),
            'length_interpretation':'Complete native trace-item lengths; pad overlaps and entry/exit in mid-segment are not clipped. This is not exact end-to-end resistance.'}

def requested_pairs():
    pairs=[]
    def add(a,bs,category='source_trunk'):
        for b in bs:pairs.append(dict(source=a,target=b,category=category))
    add('J101.1',['U115.5','C115.1'])
    add('U115.6',['U114.2','C114.1'])
    add('U114.5',['U101.1','C101.1'])
    for a in ['U101.15','U101.16']:add(a,['C105.1'])
    add('C105.1',['U201.10','U201.11'])
    for a in ['U201.4','U201.5']:add(a,['C204.1','C205.1','C206.1'])
    for a in ['C204.1','C205.1','C206.1']:add(a,['U302.1'])
    add('U302.3',['J301.2','J301.4'])
    add('C204.1',['U701.2','U501.1','U702.1'],'VOUT_branch')
    add('J102.1',['U101.13','U101.14'],'battery_trunk')
    add('J101.1',['R110.1','R121.1','R124.1'],'voltage_sense_branch_not_load_trunk')
    return pairs

def run(board_path,out):
    out.mkdir(parents=True,exist_ok=True)
    data=board_path.read_bytes();source_hash=digest(data)
    snapshot=out/'source.kicad_pcb'
    if snapshot.exists() and snapshot.read_bytes()!=data:raise ValueError('Output already binds a different source; use a fresh --out directory')
    if not snapshot.exists(): snapshot.write_bytes(data)
    s=stackup(data.decode());b=p.LoadBoard(str(snapshot));g=NativeGraph(b,s)
    results=[]
    for pair in requested_pairs():
        left=g.pad_index.get(pair['source'],[]);right=g.pad_index.get(pair['target'],[])
        if not left or not right:results.append(dict(pair,status='missing_pad_contract'));continue
        for a,c in itertools.product(left,right):
            results.append(dict(pair,source_pad_uuid=a,target_pad_uuid=c,**g.witness(a,c)))
    cases=[dict(temperature_C=t,finished_height_mm=h,plating_um=pl,geometry_case=geo)
        for t,h,pl,geo in itertools.product([20,60,85],[1.44,1.6,1.76],[20,25],
        ['native_nominal','width_minus_25um_copper_80pct'])]
    scenario_rows=[]
    for idx,r in enumerate(results):
        if r['status']!='explicit_native_witness':continue
        for case in cases:
            value=sum(estimate_edge(e,s,case)for e in r['ordered_edges'])
            scenario_rows.append(dict(pair_index=idx,source=r['source'],target=r['target'],category=r['category'],
                **case,trace_and_barrel_full_item_ohm=value,mV_per_A=value*1000,mW_per_A_squared=value*1000))
    sense_adjacency=[]
    for name in ['R110.1','R121.1','R124.1']:
        for u in g.pad_index.get(name,[]):
            neighbours=[uid(x) for x in g.cn.GetConnectedTracks(g.objects[u]) if uid(x) in g.items]
            sense_adjacency.append(dict(endpoint=name,pad_uuid=u,category='voltage_sense_branch_not_load_trunk',
                direct_copper_uuids=neighbours,
                direct_track_widths_mm=[g.items[v]['width_mm']for v in neighbours if g.items[v]['kind']=='track']))
    receipt=dict(schema=1,status='Read-only routing diagnostic; not a manufacturing or current-rating approval',
        source_original_path=str(board_path.resolve()),source_snapshot=str(snapshot.resolve()),
        source_sha256=source_hash,input_current_sha256_after_run=digest(board_path.read_bytes()),
        snapshot_sha256_after_run=digest(snapshot.read_bytes()),kicad_version=p.Version(),
        reader_sha256=digest(Path(__file__).read_bytes()),stackup=s,
        constants=dict(rho20_ohm_mm=RHO20,alpha20_per_C=ALPHA20,source_url=NIST_URL,source_pdf_page=46,printed_page=40),
        native_api_source=KICAD_URL,graph=dict(physical_items=len(g.items),native_direct_pairs=len(g.native_pairs),
        directed_port_nodes=len(g.adj),ignored_zones=g.ignored_zone_count),
        pair_status_counts=dict(collections.Counter(r['status']for r in results)),pairs=results,
        physical_items=g.items,sense_endpoint_adjacency=sense_adjacency,scenario_count=len(cases),omissions=[
            'Zones, poured copper, package internals, resistor/load conduction, solder, connector contacts, wires, current sharing, skin/proximity effect, thermal rise and trace current capacity are omitted.',
            'Separate same-number physical pads are not joined by pin identity; only direct native physical adjacency is admitted.',
            'Ideal zero-resistance junctions within each physical pad item; terminal PTH contact resistance is omitted. Plated pad barrels traversed between layers are included with the same unqualified plating sensitivities as vias.',
            'Full native segment lengths over-count unused tails when a connection enters mid-segment and include pad-overlap copper. The single witness is selected by the lowest nominal full-item sum; this is not an equivalent-resistance solver or an accuracy bound.',
            '20/25 µm plating, 1.44/1.6/1.76 mm finished heights, and the width-minus-25 µm/copper-80% case are labelled sensitivities, not measured values or fabrication guarantees.',
            'NIST annealed-copper resistivity and linear temperature scaling are material assumptions, not qualification of deposited PCB copper.',
            'A missing trace-only path remains unresolved; a valid full-board connection could use excluded planes or still need routing.',
            'No simultaneous load, operating current, voltage-drop allowance, power dissipation limit, or board thermal rating is invented.'])
    (out/'inventory.json').write_text(json.dumps(receipt,indent=2)+'\n')
    with (out/'sensitivities.csv').open('w',newline='')as f:
        w=csv.DictWriter(f,fieldnames=list(scenario_rows[0])if scenario_rows else ['pair_index']);w.writeheader();w.writerows(scenario_rows)
    summary=[]
    for r in results:
        q={k:r.get(k,'')for k in ['source','target','category','status','source_pad_uuid','target_pad_uuid']}
        q['full_item_mV_per_A_20C_25um_1p6mm']=r.get('full_item_estimate_ohm_20C_25um_1p6mm',float('nan'))*1000
        q['barrel_transitions']=r.get('barrel_transition_count','')
        for L in s['copper_thickness_mm']:
            row=r.get('layer_summary',{}).get(L,{})
            q[L+'_length_mm']=row.get('full_item_length_mm',0);q[L+'_min_width_mm']=row.get('minimum_width_mm','')
        summary.append(q)
    with (out/'paths.csv').open('w',newline='')as f:
        w=csv.DictWriter(f,fieldnames=list(summary[0]));w.writeheader();w.writerows(summary)
    print(json.dumps({'source_sha256':source_hash,'counts':receipt['pair_status_counts'],'graph':receipt['graph'],'scenarios':len(scenario_rows)},indent=2))
    return receipt

if __name__=='__main__':
    ap=argparse.ArgumentParser();ap.add_argument('--board',type=Path,required=True);ap.add_argument('--out',type=Path,required=True)
    args=ap.parse_args();run(args.board,args.out)
