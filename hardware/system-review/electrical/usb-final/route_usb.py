"""Offline USB-only layout. DRC/CLI validation is mandatory after this builder."""
from pathlib import Path
import pcbnew as p
import sexpdata as sx
import json,math,xml.etree.ElementTree as ET
HERE=Path(__file__).resolve().parent;ROOT=HERE.parents[3];P=ROOT/'hardware/pcb/usb-input';NAME='Trimix_USB_Input';LIB=P/'Trimix_USB.pretty'

def v(x,y):return p.VECTOR2I(p.FromMM(x),p.FromMM(y))
def make():
 a=sx.loads((HERE/'before'/f'{NAME}.kicad_pcb').read_text())
 a[:]=[n for n in a if not(isinstance(n,list) and str(n[0]) in ('footprint','segment','via','zone','gr_text'))]
 (HERE/'bare-board.kicad_pcb').write_text(sx.dumps(a))
 b=p.LoadBoard(str(HERE/'bare-board.kicad_pcb'))
 xml=ET.parse(HERE/'usb-netlist.xml').getroot(); nets={}; pins={};fps={}
 for n in xml.findall('./nets/net'):
  name=n.attrib['name']; net=b.FindNet(name)
  if not net:net=p.NETINFO_ITEM(b,name);b.Add(net)
  nets[name]=net
  for nd in n.findall('node'):pins[(nd.attrib['ref'],nd.attrib['pin'])]=name
 positions={'J901':(108,110.14,0),'J902':(108,104.5,0),'U901':(109.5,106.8,90),'D901':(104,108.0,0)}
 for comp in xml.findall('./components/comp'):
  ref=comp.attrib['ref'];lib,name=comp.findtext('footprint').split(':');fp=p.FootprintLoad(str(LIB),name);assert fp
  fp.SetFPID(p.LIB_ID(lib,name));fp.SetReference(ref);fp.SetValue(comp.findtext('value'))
  stamps=comp.findall('tstamps');path=''.join(comp.find('sheetpath').attrib.get('tstamps',''))+stamps[0].text
  fp.SetPath(p.KIID_PATH(path));x,y,angle=positions[ref];fp.SetOrientationDegrees(angle);fp.SetPosition(v(x,y));b.Add(fp);fps[ref]=fp
  for fld in comp.findall('./fields/field'):
   if fld.attrib['name']!='Footprint':fp.SetField(fld.attrib['name'],fld.text or '')
  for field in fp.GetFields():field.SetVisible(False)
  for pad in fp.Pads():
   pad.SetNet(nets[pins[(ref,pad.GetNumber())]])
   if pad.GetNetname()=='GND':pad.SetLocalZoneConnection(p.ZONE_CONNECTION_FULL)
  if ref in ('J901','J902'):fp.Models().clear() # Connector and harness remain separate native Fusion assemblies.
 ds=b.GetDesignSettings();ds.SetBoardThickness(p.FromMM(.6));ds.SetCopperLayerCount(2);ds.m_CopperEdgeClearance=p.FromMM(.2)
 def text(s,x,y,sz=.8,layer=p.F_SilkS):
  sz=max(sz,1) if layer==p.F_SilkS else sz
  t=p.PCB_TEXT(b);t.SetText(s);t.SetPosition(v(x,y));t.SetTextSize(v(sz,sz));t.SetTextThickness(p.FromMM(.15 if layer==p.F_SilkS else .1));t.SetLayer(layer);b.Add(t)
 text('USB6',108,101.5);text('1',103.5,102.95);text('2',105.3,102.95)
 for n,x in [(3,107.1),(4,108.9),(5,110.7),(6,112.5)]:text(str(n),x,102.95)
 text('U901',113,107.3);text('D901',103.7,106.65,.8)
 text('0.60 +/-0.10 mm / 2-layer / A3-USB6-ESD',108,97,.8,p.Dwgs_User)
 text('Original GCT lands:0.10mm edge margin requires fabrication closure',108,98.3,.7,p.Dwgs_User)
 b.GetTitleBlock().SetTitle('Trimix USB input - 6-wire + ESD / prototype review');b.GetTitleBlock().SetRevision('A3-USB6-ESD');b.GetTitleBlock().SetComment(0,'0.60 +/-0.10mm. GCT edge margin fails0.20mm; fabrication, ESD and harness-fit tests pending.')
 p.SaveBoard(str(P/f'{NAME}.kicad_pcb'),b)
 pro=json.loads((P/f'{NAME}.kicad_pro').read_text());ds=pro['board']['design_settings'];ds['drc_exclusions']=[]
 ds['rules'].update({'min_clearance':.15,'min_copper_edge_clearance':.2,'min_track_width':.15,'min_hole_clearance':.2,'min_hole_to_hole':.25,'min_via_diameter':.45,'min_through_hole_diameter':.2,'min_via_annular_width':.1,'min_silk_clearance':.15})
 pro['net_settings']['classes'][0].update({'clearance':.15,'track_width':.15,'via_diameter':.45,'via_drill':.2})
 (P/f'{NAME}.kicad_pro').write_text(json.dumps(pro,indent=2)+'\n');(P/f'{NAME}.kicad_dru').write_text('(version 1)\n')
 (HERE/'placement.json').write_text(json.dumps({'positions_KiCad_mm_degrees':positions,'PCB_stack_Fusion_Z_mm':[24.9,25.5],'support_underside_Fusion_Z_mm':31.2,'signal_protection_body_max_mm':[2.6,1.1,.55],'VBUS_protection_height_max_mm':.77,'harness_reference_height_max_mm':4.5,'harness_height_status':'Unmeasured allowance; actual wire exit, bend and solder tips must fit.','connector_land_shift_mm':0,'purchased_geometry_or_connector_pose_changed':False},indent=2)+'\n')
 return b,nets,fps

if __name__=='__main__':make()
