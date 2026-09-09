"""USB5V-only source detection and fail-low current permission.

Independent CC and BC1.2 detectors keep BQ25895 D+/D- disconnected, preventing
its autonomous high-voltage handshake. Hardware permission is cleared by
VBUS loss, CC changes or host-supply startup, and requires a new host edge.
"""
from analyzer_sheet import *

USB_SHEET='USB_Source_Control'
TI='https://www.ti.com/lit/ds/symlink/'
PARTS={
 'U110':('TUSB320LAIRWBR','Package_DFN_QFN:Texas_X2QFN-12_1.6x1.6mm_P0.4mm',TI+'tusb320lai.pdf'),
 'U111':('PI3USB9201ZTAEX','Trimix_Power:PI3USB9201_UQFN2020_12_TypeC','https://www.diodes.com/datasheet/download/PI3USB9201.pdf'),
 'U112':('SN74AUP1G74DCUR','Package_SO:VSSOP-8_2.3x2mm_P0.5mm',TI+'sn74aup1g74.pdf'),
 'U113':('TPS3808G01DBVR','Package_TO_SOT_SMD:SOT-23-6',TI+'tps3808.pdf'),
}

def box(s,title,x,y,w,h):
    s.a.append(node('rectangle',node('start',x,y),node('end',x+w,y+h),node('stroke',node('width',.254),node('type',S('default'))),node('fill',node('type',S('none'))),node('uuid',uid())))
    s.text(title,x+5.08,y+5.08,1.27,True)

def ic(s,ref,name,names,nets,x,y):
    # Each list explicitly follows the manufacturer pin table, not a generic package numbering assumption.
    count=len(names);left=(count+1)//2;pins=[]
    for i,(pname,typ) in enumerate(names,1):
        side=0 if i<=left else 1;row=i-1 if side==0 else i-left-1
        pins.append((i,pname,typ,-15.24 if not side else 15.24,10.16-5.08*row,0 if not side else 180))
    symbol=custom_symbol(name,pins,bounds=(-12.7,12.7,12.7,7.62-5.08*max(left,count-left)),datasheet=PARTS[ref][2])
    s.add('Trimix_Analyzer:'+name,ref,PARTS[ref][0],x,y,nets,custom=symbol,footprint=PARTS[ref][1],
          field_at=(x-10.16,y-17.78),properties={'MPN':PARTS[ref][0],'Manufacturer':'Diodes Incorporated' if ref=='U111' else 'Texas Instruments','Primary_datasheet':PARTS[ref][2]})

def passive(s,ref,value,x,y,n1,n2='GND'):
    kind='C' if ref.startswith('C') else 'R';fp=('Capacitor_SMD:C_' if kind=='C' else 'Resistor_SMD:R_')+'0603_1608Metric'
    return s.add('Device:'+kind,ref,value,x,y,{1:n1,2:n2},footprint=fp)

def source_sheet():
    s=Sheet(USB_SHEET,12,'USB source qualification — 5 V only',
        'Nominal50mA upstream hardware default. Higher input permission requires a qualified source and a fresh host authorization edge.')
    box(s,'01  USB-C SINK / INTERNAL Rd / I2C 0x47',20.32,45.72,180.34,93.98)
    ic(s,'U110','TUSB320LAI_RWB',[('CC1','bidirectional'),('CC2','bidirectional'),('PORT','input'),('VBUS_DET','input'),('ADDR','input'),('INT_N','open_collector'),('SDA','bidirectional'),('SCL','input'),('ID','open_collector'),('GND','power_in'),('EN_N','input'),('VDD','power_in')],
       {1:'USB_CC1',2:'USB_CC2',3:'GND',4:'USB_VBUS_DET',5:'GND',6:'USB_CC_INT_N',7:'I2C_SDA',8:'I2C_SCL',9:None,10:'GND',11:'GND',12:'HOST_3V3'},83.82,81.28)
    passive(s,'R110','887k / 1%',152.4,72.39,'USB_5V','USB_VBUS_DET')
    passive(s,'R111','33k / 1%',152.4,100.33,'HOST_3V3','USB_CC_INT_N')
    passive(s,'C110','100n / 50V X7R',180.34,72.39,'HOST_3V3')
    s.text('R901/R902 on the USB board are DNP: U110 supplies both Rd terminations.\nUnpowered CC pins retain dead-battery Rd. PORT/ADDR/EN_N are hard-grounded.',25.4,125.73,1.016)
    box(s,'02  USB-A / BC1.2 DETECTOR / I2C 0x5F',212.09,45.72,189.23,93.98)
    ic(s,'U111','PI3USB9201_ZTA',[('USB+','bidirectional'),('USB-','bidirectional'),('SCL','input'),('SDA','bidirectional'),('INTB','open_collector'),('NC','no_connect'),('D-','bidirectional'),('D+','bidirectional'),('GND','power_in'),('ADDR','input'),('ENB','input'),('VDD','power_in')],
       {1:None,2:None,3:'I2C_SCL',4:'I2C_SDA',5:'USB_BC_INT_N',6:None,7:'USB_D_M',8:'USB_D_P',9:'GND',10:'GND',11:'GND',12:'HOST_3V3'},276.86,81.28)
    passive(s,'C111','100n / 50V X7R',375.92,72.39,'HOST_3V3')
    passive(s,'R112','10k / 1%',347.98,100.33,'HOST_3V3','USB_BC_INT_N')
    s.text('Client mode only. D+/D- never connect to the BQ25895. No PD or HVDCP.\nRead-and-clear BC status only while host permission is LOW. No USB data path.',217.17,125.73,1.016)
    box(s,'03  INDEPENDENT VBUS LOSS + CC RESET + STARTUP',20.32,146.05,180.34,132.08)
    ic(s,'U113','TPS3808G01_DBV',[('RESET','open_collector'),('GND','power_in'),('MR','input'),('CT','input'),('SENSE','input'),('VDD','power_in')],
       {1:'USB_PERMISSION_CLR_N',2:'GND',3:'USB_CC_INT_N',4:None,5:'USB_VBUS_SENSE',6:'HOST_3V3'},83.82,182.88)
    passive(s,'R113','97.6k / 0.1%',147.32,167.64,'USB_OVP_5V','USB_VBUS_SENSE')
    passive(s,'R114','10k / 0.1%',147.32,195.58,'USB_VBUS_SENSE')
    passive(s,'R115','10k / 1%',45.72,218.44,'HOST_3V3','USB_PERMISSION_CLR_N')
    passive(s,'C112','100n / 50V X7R',104.14,218.44,'HOST_3V3')
    s.text('TPS3808 is powered by HOST_3V3, separately senses USB VBUS.\nNominal falling threshold 4.358 V; corner threshold calculation in review.\nCT open: release delay 12–28 ms. Wait at least 30 ms after CC IRQ clear.\nLoss/CC change forces Q low even if the host GPIO remains stuck high.\nPower-up RESET is asserted for 0.8 V < VDD < 1.7 V.\nSub-microsecond transients and physical rail ramps require measurement.',25.4,240.03,1.016)
    box(s,'04  FRESH AUTHORIZATION EDGE / HARDWARE CURRENT CEILING',212.09,146.05,189.23,132.08)
    ic(s,'U112','SN74AUP1G74_DCU',[('CLK','input'),('D','input'),('Q_N','output'),('GND','power_in'),('Q','output'),('CLR_N','input'),('PRE_N','input'),('VCC','power_in')],
       {1:'USB_ILIM_AUTH',2:'HOST_3V3',3:'USB_PERMISSION_Q_N',4:'GND',5:'USB_PERMISSION_Q',6:'USB_PERMISSION_CLR_N',7:'HOST_3V3',8:'HOST_3V3'},276.86,182.88)
    passive(s,'C113','100n / 50V X7R',378.46,170.18,'HOST_3V3')
    passive(s,'R116','1k / 0.1%',340.36,195.58,'USB_LIMIT_SET','USB_ILIM_BRANCH')
    for ref,x,nets in [('Q110',254,{1:'USB_PERMISSION_Q',2:'USB_ILIM_SERIES',3:'USB_ILIM_BRANCH'}),('Q111',312.42,{1:'USB_ILIM_AUTH',2:'GND',3:'USB_ILIM_SERIES'})]:
        s.add('Transistor_FET:DMN2056U',ref,'DMN2056U-7',x,226.06,nets,footprint='Package_TO_SOT_SMD:SOT-23',
              properties={'Manufacturer':'Diodes Incorporated','MPN':'DMN2056U-7'})
    passive(s,'R117','100k / 1%',365.76,224.79,'USB_ILIM_AUTH')
    passive(s,'R118','100k / 1%',388.62,224.79,'USB_PERMISSION_Q')
    s.text('GPIO50 / J301.11: LOW selects nominal50mA upstream; a qualified rising edge authorizes.\nR103300R is a supported-range backup. U114 nominal50mA default; R1161k qualified branch.\nBoth FETs must be ON. A CC/VBUS reset requires a new host LOW→HIGH.\nBQ current register must still match the valid source budget. CHARGE ARM stays open.',217.17,256.54,1.016)
    return s

if __name__=='__main__':
    s=source_sheet();s.finish()
