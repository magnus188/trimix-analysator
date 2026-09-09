"""Bounded read-only lower CHG bridge search. Only writes this scout directory."""
from pathlib import Path
import sys, types, json, math, hashlib, argparse

OUT = Path(__file__).resolve().parent
PARENT = OUT.parent
sys.path.insert(0, str(PARENT))
import route_context as c
from island_targets import connected_track_targets

parser = argparse.ArgumentParser()
parser.add_argument('--bounds', nargs=4, type=float, default=[9,85.5,13.5,91.5])
parser.add_argument('--name', default='initial')
parser.add_argument('--reverse', action='store_true')
parser.add_argument('--step', type=float, choices=[.05,.025], default=.05)
args = parser.parse_args()
c.OUT = OUT
NET = 'CHG_INT_N'
REMOVE = 'a0d0b138-e4e0-41c6-a8c9-2fd0fa5a83d8'
UPPER = '0e4a678b-3cca-451f-97dc-36f6f7bc6e0c'
LOWER = '699897a5-66eb-4820-96ec-8e0602bad845'
held = [t for t in c.b.GetTracks() if t.m_Uuid.AsString() == REMOVE]
assert len(held) == 1
c.b.Remove(held[0])
power = json.loads((PARENT / 'power-corridor-scout.json').read_text())
assert power['source_sha256'] == c.EXPECTED
c.track('VSYS', power['hypothetical_points_mm'], c.p.In2_Cu, width=.4)
c.added.clear()
old_via = c.via
def ordinary_via(net, q):
    return old_via(net, q, d=.5, h=.25)
c.via = ordinary_via
sys.modules['build_bridge'] = c
router = types.ModuleType('bounded_chg_router')
router_code=(PARENT.parent / 'cap-signal-reconnect/pullup-swap/route_bounded.py').read_text()
assert 'STEP=.05; BOUNDS=bounds' in router_code
exec(router_code.replace('STEP=.05; BOUNDS=bounds',f'STEP={args.step}; BOUNDS=bounds'), router.__dict__)
starts, sr = connected_track_targets(c.b, NET, UPPER, args.bounds, spacing=.2)
targets, tr = connected_track_targets(c.b, NET, LOWER, args.bounds, spacing=.2)
assert not set(sr['connected_object_uuids']) & set(tr['connected_object_uuids'])
receipt = {'source_sha256':c.EXPECTED, 'removed_uuids':[REMOVE], 'bounds_mm':args.bounds, 'grid_step_mm':args.step,
           'upper_island':sr, 'lower_island':tr, 'reserved_SYS':power,
           'status':'SEARCHING', 'release':False}
(OUT / (args.name + '-islands.json')).write_text(json.dumps(receipt, indent=2)+'\n')
print('ISLANDS', len(sr['connected_object_uuids']), len(tr['connected_object_uuids']), 'STARTS',len(starts),'TARGETS',len(targets), flush=True)
try:
    router.route(NET, (11.75,86.8), (10.7,89.2), width=.15, bounds=args.bounds, starts=targets if args.reverse else starts, targets=starts if args.reverse else targets)
except AssertionError as error:
    receipt['status'] = 'NO_BOUNDED_ROUTE'
    receipt['error'] = str(error)
    reachable = OUT / 'CHG_INT_N-reachable.json'
    if reachable.exists():
        reachable.rename(OUT / (args.name + '-reachable.json'))
else:
    receipt['status'] = 'ROUTE_FOUND_NEEDS_INDEPENDENT_NATIVE_CHECK'
    receipt['added'] = c.added
    _, joined = connected_track_targets(c.b, NET, UPPER, args.bounds)
    receipt['all_original_island_members_rejoined'] = (set(sr['connected_object_uuids']) | set(tr['connected_object_uuids'])) <= set(joined['connected_object_uuids'])
    assert receipt['all_original_island_members_rejoined']
    print('FOUND', json.dumps(c.added), flush=True)
(OUT / (args.name + '-proposal.json')).write_text(json.dumps(receipt, indent=2)+'\n')
assert hashlib.sha256(c.P.read_bytes()).hexdigest() == c.EXPECTED
print('DONE', receipt['status'], flush=True)
