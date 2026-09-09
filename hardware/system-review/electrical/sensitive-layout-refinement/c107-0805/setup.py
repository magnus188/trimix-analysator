from pathlib import Path
import pcbnew as p,hashlib,json,shutil
D=Path(__file__).resolve().parent;OUT=D/'candidate';OUT.mkdir(exist_ok=True)
SRC=Path('hardware/system-review/electrical/routing-candidate/sensitive-layout-refinement/c103-local2')
if not (D/'source.kicad_pcb').exists():(D/'source.kicad_pcb').write_bytes((SRC/'Trimix_Analyzer.kicad_pcb').read_bytes())
b=p.LoadBoard(str(D/'source.kicad_pcb'));old=next(f for f in b.GetFootprints()if f.GetReference()=='C107')
LIB=D/'C107_Trial.pretty';LIB.mkdir(exist_ok=True)
name='C_TDK_C2012_Manufacturer_Reflow'
mod='''(footprint "C_TDK_C2012_Manufacturer_Reflow" (version 20241229) (generator pcbnew) (layer "F.Cu")
(descr "TDK C2012 real0805 manufacturer reflow: A1.05 gap B0.80 padlength C1.10 width; maxbody2.20x1.45x1.45. Reference production process qualification pending.")
(property "Reference" "C107" (at 0 -1.4) (layer "F.SilkS") (effects (font (size .6 .6) (thickness .1))))
(property "Value" "47uF/10V X5R" (at 0 1.4) (layer "F.Fab") (effects (font (size .6 .6) (thickness .1))))
(attr smd)
(fp_rect (start -1.575 -.975) (end 1.575 .975) (stroke (width .05) (type solid)) (fill none) (layer "F.CrtYd"))
(fp_rect (start -1 -.625) (end 1 .625) (stroke (width .1) (type solid)) (fill none) (layer "F.Fab"))
(pad "1" smd rect (at -.925 0) (size .8 1.1) (layers "F.Cu" "F.Paste" "F.Mask"))
(pad "2" smd rect (at .925 0) (size .8 1.1) (layers "F.Cu" "F.Paste" "F.Mask"))
)
'''
(LIB/(name+'.kicad_mod')).write_text(mod)
f=p.FootprintLoad(str(LIB),name);f.SetReference('C107');f.SetValue('47uF / 10V X5R');f.SetFPIDAsString('C107_Trial:'+name);f.SetPath(old.GetPath());f.SetUuid(old.m_Uuid)
f.SetFields({q.GetName():q.GetText()for q in old.GetFields()});f.SetField('MPN','C2012X5R1A476M125AC');f.SetField('Manufacturer','TDK');f.SetField('Datasheet','https://product.tdk.cn/system/files/dam/doc/product/capacitor/ceramic/mlcc/charasheet/c2012x5r1a476m125ac.pdf');f.SetValue('47uF / 10V X5R')
oldpads={q.GetNumber():q for q in old.Pads()}
for q in f.Pads():q.SetNet(oldpads[q.GetNumber()].GetNet());q.SetUuid(oldpads[q.GetNumber()].m_Uuid)
b.Remove(old);b.Add(f);f.Flip(f.GetPosition(),False)
def xy(a):return[p.ToMM(a.x),p.ToMM(a.y)]
def vec(a):return p.VECTOR2I(p.FromMM(a[0]),p.FromMM(a[1]))
NETCODES={str(name):item.GetNetCode()for name,item in b.GetNetsByName().items()}
def track(net,pts,layer,width=.25):
 for a,z in zip(pts,pts[1:]):
  if a==z:continue
  t=p.PCB_TRACK(b);t.SetStart(vec(a));t.SetEnd(vec(z));t.SetWidth(p.FromMM(width));t.SetLayer(layer);t.SetNetCode(NETCODES[net]);b.Add(t)
def via(net,at):
 t=p.PCB_VIA(b);t.SetPosition(vec(at));t.SetWidth(p.FromMM(.5));t.SetDrill(p.FromMM(.25));t.SetViaType(p.VIATYPE_THROUGH);t.SetLayerPair(p.F_Cu,p.B_Cu);t.SetNetCode(NETCODES[net]);b.Add(t)
def save():
 p.SaveBoard(str(OUT/'Trimix_Analyzer.kicad_pcb'),b)
 for q in SRC.iterdir():
  if q.name.endswith(('.kicad_pro','.kicad_dru','.kicad_sch','.kicad_sym'))or q.name in ['sym-lib-table','fp-lib-table']:shutil.copy2(q,OUT/q.name)
  elif q.is_dir()and q.name.endswith('.pretty'):
   dst=OUT/q.name
   if not dst.exists():dst.symlink_to(q.resolve(),target_is_directory=True)
 dst=OUT/LIB.name
 if not dst.exists():dst.symlink_to(LIB.resolve(),target_is_directory=True)
 # Trial-only library for exact manufacturer's smaller lands.
 tab=OUT/'fp-lib-table';t=tab.read_text();t=t[:t.rfind(')')]+' (lib (name "C107_Trial") (type "KiCad") (uri "${KIPRJMOD}/C107_Trial.pretty") (options "") (descr "Isolated exact TDK reflow trial"))\n)\n';tab.write_text(t)
