"""Read-only native trace/barrel pad partitions for guarded routing cleanup.

Run once per process with KiCad Python. Never joins labels, pin numbers or a
component's internal circuitry. Filled-zone geometry/anchor conservation and
fresh native DRC remain separate checks; this snapshot excludes zone edges.
"""
from pathlib import Path
import argparse
import collections
import hashlib
import json
import sys
import pcbnew as p

HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE / 'current-path-review'))
from inventory import NativeGraph, stackup


def snapshot(path):
    raw = path.read_bytes()
    b = p.LoadBoard(str(path))
    graph = NativeGraph(b, stackup(raw.decode()))
    parent = {}

    def find(x):
        parent.setdefault(x, x)
        if parent[x] != x:
            parent[x] = find(parent[x])
        return parent[x]

    def join(a, z):
        a, z = find(a), find(z)
        if a != z:
            parent[z] = a

    for node, edges in graph.adj.items():
        find(node)
        for target, _, _ in edges:
            join(node, target)
    parts = collections.defaultdict(list)
    for uid, item in graph.items.items():
        if item['kind'] != 'pad':
            continue
        for layer in item['layers']:
            port = (uid, layer, 'port')
            parts[find(port)].append({'uuid': uid, 'reference': item['ref'],
                                     'pin': item['pin'], 'layer': layer, 'net': item['net']})
    partitions = []
    for rows in parts.values():
        rows.sort(key=lambda q: (q['uuid'], q['layer']))
        nets = sorted({r['net'] for r in rows})
        if len(nets) != 1:
            raise ValueError('Native trace partition unexpectedly spans different nets')
        partitions.append({'net': nets[0], 'pads': rows})
    partitions.sort(key=lambda q: (q['net'], q['pads'][0]['uuid'], q['pads'][0]['layer']))
    grounding = [dict(row) for row in graph.items.values() if row['net'] == 'GND']
    grounding.sort(key=lambda q: q['uuid'])
    return {'board': str(path.resolve()), 'board_sha256': hashlib.sha256(raw).hexdigest(),
            'pad_partitions': partitions, 'ground_pad_track_via_items': grounding,
            'native_direct_item_pairs': len(graph.native_pairs),
            'scope': 'Native pad/track adjacency and plated barrels only; excludes poured copper and internal IC conduction.',
            'required_complement': 'Filled-plane geometry/anchor audit and fresh native DRC. Pruning must preserve these partitions and all GND items unless an explicit separately reviewed ground delta is supplied.'}


if __name__ == '__main__':
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument('--board', type=Path, required=True)
    ap.add_argument('--output', type=Path, required=True)
    ap.add_argument('--compare-before', type=Path)
    args = ap.parse_args()
    result = snapshot(args.board)
    if args.compare_before:
        before = json.loads(args.compare_before.read_text())
        result['comparison'] = {'before_board_sha256': before['board_sha256'],
                                'pad_partitions_equal': before['pad_partitions'] == result['pad_partitions'],
                                'all_ground_items_equal': before['ground_pad_track_via_items'] == result['ground_pad_track_via_items']}
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(json.dumps(result, indent=2)+'\n')
    print(json.dumps({'board_sha256': result['board_sha256'],
                      'partitions': len(result['pad_partitions']),
                      'comparison': result.get('comparison')}, indent=2))
