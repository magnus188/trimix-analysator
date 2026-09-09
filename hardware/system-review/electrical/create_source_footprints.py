"""Explicit manufacturer-derived source-control lands and six-wire pigtail."""
from pathlib import Path
import sys
ROOT=Path(__file__).resolve().parents[3];sys.path.insert(0,str(ROOT/'hardware/tools'))
from analyzer_sheet import *
L=P/'Trimix_Power.pretty'
def base(name,desc,bx,by):
 a=node('footprint',name,node('version',20241229),node('generator','pcbnew'),node('layer','F.Cu'),node('descr',desc),node('attr',S('smd')))
 for k,v,y,layer in [('Reference','REF**',-by-1,'F.SilkS'),('Value',name,by+1,'F.Fab')]:a.append(node('property',k,v,node('at',0,y,0),node('layer',layer),effects(.8,hide=k=='Value')))
 for layer,x,y,w in [('F.Fab',bx,by,.1),('F.CrtYd',bx+.3,by+.3,.05)]:a.append(node('fp_rect',node('start',-x,-y),node('end',x,y),node('stroke',node('width',w),node('type',S('solid'))),node('layer',layer)))
 return a
def pad(a,n,x,y,w,h):a.append(node('pad',str(n),S('smd'),S('rect'),node('at',x,y),node('size',w,h),node('layers','F.Cu','F.Paste','F.Mask')))
a=base('PI3USB9201_UQFN2020_12_TypeC','Diodes DS41358 Rev3-2 U-QFN2020-12 TypeC; top-view pin map. Land0.25x0.65 engineered from0.15-0.25x0.45-0.55 terminals; factory IPC/process acceptance required.',1,1)
for n,x,y,w,h in [(1,-.825,-.2,.65,.25),(2,-.825,.2,.65,.25),(3,-.6,.825,.25,.65),(4,-.2,.825,.25,.65),(5,.2,.825,.25,.65),(6,.6,.825,.25,.65),(7,.825,.2,.65,.25),(8,.825,-.2,.65,.25),(9,.6,-.825,.25,.65),(10,.2,-.825,.25,.65),(11,-.2,-.825,.25,.65),(12,-.6,-.825,.25,.65)]:pad(a,n,x,y,w,h)
# Fab dot is the top-view pin1 side, independent of the bottom-view mechanical drawing.
a.append(node('fp_circle',node('center',-.7,-.6),node('end',-.6,-.6),node('stroke',node('width',.1),node('type',S('solid'))),node('fill',S('none')),node('layer','F.Fab')));save(L/(a[1]+'.kicad_mod'),a)
a=base('TPS22950_YBH6','TI YBH0006-C02 drawing4226594/A03/2021.0.2mm NSMD copper0.4pitch;0.3mask aperture;0.21paste. Factory75um stencil/X-ray required.',.363,.563)
# A1 upper left as top view. Manufacturer land pattern: rowsA/B/C, columns1/2.
for row,y in [('A',-.4),('B',0),('C',.4)]:
 for col,x in [('1',-.2),('2',.2)]:
  a.append(node('pad',row+col,S('smd'),S('circle'),node('at',x,y),node('size',.2,.2),node('layers','F.Cu','F.Paste','F.Mask'),node('solder_mask_margin',.05),node('solder_paste_margin',.005)))
a.append(node('fp_line',node('start',-.363,-.4),node('end',-.2,-.563),node('stroke',node('width',.1),node('type',S('solid'))),node('layer','F.Fab')));save(L/(a[1]+'.kicad_mod'),a)
a=base('USB_Harness_6P_P1.8mm','Six soldered wires:1USB5V2GND3CC1 4CC2 5D+6D-. Power24AWG stranded; signals28AWG.0.8mm finishedholes; inspect actual bundle/bend/strainrelief.',5.4,1)
child(a,'attr')[1:]=[S('through_hole')]
for n in range(1,7):
 a.append(node('pad',str(n),S('thru_hole'),S('rect' if n==1 else 'circle'),node('at',(n-1)*1.8-4.5,0),node('size',1.3,1.3),node('drill',.8),node('layers','*.Cu','*.Mask')))
save(L/(a[1]+'.kicad_mod'),a)
