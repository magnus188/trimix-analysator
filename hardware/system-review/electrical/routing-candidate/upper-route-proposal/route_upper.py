"""Bounded additive route proposal against an immutable KiCad board copy.

Uses a reviewed explicit path and native CLI DRC as the acceptance gate. No changes to footprints, existing copper or rules.
"""
from pathlib import Path
import hashlib, json, math, shutil
import pcbnew as p

OUT = Path(__file__).resolve().parent
BASE = OUT / 'before.kicad_pcb'
DEST = OUT / 'Trimix_Analyzer.kicad_pcb'
EXPECTED = 'f836e8a68f4a4bfa8bec3684f96ef2766bd40bcc5af55bbfe4549180c43dc992'
assert hashlib.sha256(BASE.read_bytes()).hexdigest() == EXPECTED
b = p.LoadBoard(str(OUT / 'baseline/Trimix_Analyzer.kicad_pcb'))
added = []
def vec(q): return p.VECTOR2I(p.FromMM(q[0]), p.FromMM(q[1]))
def xy(q): return (p.ToMM(q.x), p.ToMM(q.y))
def track(net, pts, layer=p.F_Cu, width=.15):
    for st, en in zip(pts, pts[1:]):
        if math.dist(st, en) < .000001: continue
        t = p.PCB_TRACK(b)
        t.SetStart(vec(st)); t.SetEnd(vec(en)); t.SetWidth(p.FromMM(width))
        t.SetNetCode(b.FindNet(net).GetNetCode()); t.SetLayer(layer); b.Add(t)
        added.append({'uuid': t.m_Uuid.AsString(), 'type': 'segment', 'net': net,
                      'start': st, 'end': en, 'width_mm': width,
                      'layer': b.GetLayerName(layer)})
def via(net, pt, diameter=.5, drill=.25):
    t = p.PCB_VIA(b); t.SetPosition(vec(pt)); t.SetWidth(p.FromMM(diameter))
    t.SetDrill(p.FromMM(drill)); t.SetViaType(p.VIATYPE_THROUGH)
    t.SetLayerPair(p.F_Cu, p.B_Cu); t.SetNetCode(b.FindNet(net).GetNetCode()); b.Add(t)
    added.append({'uuid': t.m_Uuid.AsString(), 'type': 'via', 'net': net,
                  'at': pt, 'diameter_mm': diameter, 'drill_mm': drill,
                  'layers': ['F.Cu', 'B.Cu']})

# These two ground clusters use short local returns into the continuous In1
# plane, rather than a long analog-region daisy chain.
track('GND', [(1.299999,25.735),(2.1,25.735)], width=.2)
via('GND', (2.1,25.735), .6, .3)
track('GND', [(12.275,20.3375),(12.275,21.075),(12.6,21.4)], width=.2)
via('GND', (12.6,21.4), .6, .3)
# Deliberate two-layer handoff keeps the BME branch and local host rail
# on separate sides of the narrow existing In2 signal corridor.
track('BME_VIN', [(1.25,59.675),(1.25,58.9)])
via('BME_VIN', (1.25,58.9))
track('BME_VIN', [(1.25,58.9),(.6,59.55),(.6,63.0),(1.25,63.65)], p.B_Cu)
via('BME_VIN', (1.25,63.65))
track('BME_VIN', [(1.25,62.925),(1.25,63.65)])
track('HOST_3V3', [(1.25,61.325),(1.2,61.375),(1.2,62.05)])
via('HOST_3V3', (1.2,62.05))
track('HOST_3V3', [(1.2,62.05),(1.2,62.25),(.6,62.85),(.6,72.15),(2.45,74.0)], p.In2_Cu)
via('HOST_3V3', (2.45,74.0))
track('HOST_3V3', [(2.45,74.0),(1.775,74.0),(1.45,74.325),(1.25,74.325)])
track('BME_VIN', [(1.25,63.65),(1.25,64.9),(.975,65.175),(.975,68.15),(1.1,68.275),(1.1,68.95),(1.925,69.775),(2.3,69.775)], p.In2_Cu)
via('BME_VIN', (2.3,69.775))
track('BME_VIN', [(2.3,69.775),(2.7342,69.775)])
b.GetDesignSettings().m_TrackMinWidth = p.FromMM(.15)
p.ZONE_FILLER(b).Fill(b.Zones())
p.SaveBoard(str(DEST), b)
# SaveBoard's standalone Python context may leave a previous destination
# project file in place; preserve the exact frozen project rules explicitly.
shutil.copy2(OUT/'baseline/Trimix_Analyzer.kicad_pro', OUT/'Trimix_Analyzer.kicad_pro')
(OUT/'added-items.json').write_text(json.dumps({'before_sha256':EXPECTED,'after_sha256':hashlib.sha256(DEST.read_bytes()).hexdigest(),'added_items':added,'removed_items':[],'zones_added':0,'existing_zones_refilled':True,'native_DRC_required':True,'release':False},indent=2)+'\n')
print('Added',len(added),'items to',DEST,flush=True)
