"""Build wired BME280 and experimental ZE07-CO review sheets.

Run with KiCad MCP's Python venv. Pin assignments come from manufacturer
datasheets; unidentified purchased module details are marked for qualification.
"""
from analyzer_sheet import Sheet, custom_symbol

R='Resistor_SMD:R_0603_1608Metric'
C='Capacitor_SMD:C_0805_2012Metric'
J='Connector_JST:JST_XH_B4B-XH-A_1x04_P2.50mm_Vertical'

def resistor(s,ref,value,x,y,a,b,angle=90,dnp=False,autowire=True):
    return s.add('Device:R',ref,value,x,y,{1:a,2:b},R,angle=angle,dnp=dnp,autowire=autowire,field_at=(x-5.08,y-7.62) if angle==90 else None)

def capacitor(s,ref,value,x,y,a,b='GND'):
    return s.add('Device:C',ref,value,x,y,{1:a,2:b},C)

def connector(name, labels):
    return custom_symbol(name,[(str(i+1),label,'passive',-12.7,7.62-i*5.08,0) for i,label in enumerate(labels)],bounds=(-10.16,-10.16,10.16,10.16))

def environment():
    s=Sheet('Environment',7,'Wired humidity, temperature & pressure',
        'GYBMEP module in the vented gas chamber. Four-wire harness, maximum 30 cm; dedicated sensor I2C at 100 kHz.')
    s.box(20.32,48.26,109.22,101.6,'01  MODULE POWER SELECTION')
    s.box(137.16,48.26,147.32,101.6,'02  I2C LEVEL INTERFACE')
    s.box(292.1,48.26,109.22,101.6,'03  PCB HARNESS CONNECTION')
    resistor(s,'R601','0R / fit: 3.3 V',63.5,78.74,'HOST_3V3','BME_VIN')
    resistor(s,'R602','0R / DNP: 5 V option',63.5,105.41,'VOUT_5V','BME_VIN',dnp=True)
    capacitor(s,'C601','1u / 10V',106.68,93.98,'BME_VIN')
    s.text('Fit only R601 initially. Never fit both links.\nR602 requires a verified 5 V VIN module.\nCheck the module regulator output and pull-ups\nbefore choosing an alternate supply.',25.4,129.54,1.016)
    s.add('Transistor_FET:BSS138','Q601','BSS138',191.77,80.01,
          {1:'HOST_3V3',2:'I2C_SCL',3:'BME_SCL'},'Package_TO_SOT_SMD:SOT-23',angle=270,field_at=(170.18,91.44))
    s.add('Transistor_FET:BSS138','Q602','BSS138',191.77,118.11,
          {1:'HOST_3V3',2:'I2C_SDA',3:'BME_SDA'},'Package_TO_SOT_SMD:SOT-23',angle=270,field_at=(170.18,129.54))
    resistor(s,'R603','4.7k / DNP',252.73,80.01,'BME_VIN','BME_SCL',angle=0,dnp=True)
    resistor(s,'R604','4.7k / DNP',252.73,118.11,'BME_VIN','BME_SDA',angle=0,dnp=True)
    jc=connector('BME_Harness',['VIN','GND','SCL','SDA'])
    s.add('Trimix_Analyzer:BME_Harness','J601','BME280 harness',350.52,87.63,
          {1:'BME_VIN',2:'GND',3:'BME_SCL',4:'BME_SDA'},J,custom=jc,field_at=(340.36,67.31))
    s.text('Main PCB: JST-XH, 2.50 mm, 4 positions.\nWire to the module labels, not its board colour.\nVIN / GND / SCL / SDA, as photographed.\nUse strain relief at both cable ends.',297.18,125.73,1.016)
    s.box(20.32,157.48,185.42,110.49,'04  COMMISSIONING & SIGNAL INTEGRITY')
    s.text('1. Read chip ID register 0xD0: BME280 must return 0x60.\n    BMP280 does not measure humidity. Probe 0x76 and 0x77.\n\n2. Verify the actual module VDD / VDDIO and pull-up rail.\n    Chip limits: VDD 1.71-3.6 V; VDDIO 1.2-3.6 V.\n    The product photograph does not prove the fitted regulator.\n\n3. R603/R604 are unpopulated initially; use module pull-ups.\n    Fit only after checking their rail and the installed resistance.\n    Host pull-ups are on the host interface sheet.\n\n4. Measure rise time with the complete cable: <=1 us at 100 kHz.\n    Keep total bus capacitance within the device / I2C limits.\n    BSS138 translates logic; it does not isolate a stuck-low bus.',25.4,175.26,1.143)
    s.box(213.36,157.48,187.96,93.98,'05  REMOTE MODULE IN THE CHAMBER')
    mod=connector('GYBMEP_Module',['VIN','GND','SCL','SDA'])
    s.add('Trimix_Analyzer:GYBMEP_Module','U601','GYBMEP / BME280-5V',335.28,195.58,
          {1:'BME_VIN',2:'GND',3:'BME_SCL',4:'BME_SDA'},'',on_board=False,in_bom=False,custom=mod,field_at=(325.12,175.26),
          properties={'ModuleOffBoard':'yes','Assembly':'Off-board purchased module; verify actual chip ID and pull-up rail','Stock':'Owned, order variant BME280-5V',
                      'ChipDatasheet':'https://www.bosch-sensortec.com/media/boschsensortec/downloads/datasheets/bst-bme280-ds002.pdf'})
    s.text('U601 is off-board; only J601 is mounted on the main PCB.\nKeep the sensor away from the MD62 heater and regulator.\nUse a regulated, vented chamber near atmospheric pressure.\nAllow gas contact with the sensor opening; prevent condensation.\nThis chamber sensor does not replace the battery thermistor.',218.44,229.87,1.143)
    return s.finish()

def carbon_monoxide():
    s=Sheet('Carbon_Monoxide',8,'Experimental carbon monoxide channel',
        'ZE07-CO is CO, not CO2. Wired module with a separate boosted supply and 3.0 V UART translation.')
    s.box(20.32,48.26,190.5,101.6,'01  CO MODULE SUPPLY / NOMINAL 5.28 V')
    s.box(218.44,48.26,182.88,101.6,'02  DEDICATED 3.0 V UART LOGIC SUPPLY')
    s.box(20.32,157.48,190.5,110.49,'03  UART LEVEL TRANSLATION')
    s.box(218.44,157.48,182.88,93.98,'04  REMOTE CO MODULE & HARNESS')
    boost=custom_symbol('TPS61023',[
        (3,'VIN','power_in',-12.7,7.62,0),(2,'EN','input',-12.7,-2.54,0),
        (5,'SW','passive',0,15.24,270),(6,'VOUT','power_out',12.7,7.62,180),
        (1,'FB','input',12.7,-2.54,180),(4,'GND','power_in',0,-15.24,90)],
        bounds=(-10.16,-12.7,10.16,12.7),datasheet='https://www.ti.com/lit/ds/symlink/tps61023.pdf')
    s.add('Trimix_Analyzer:TPS61023','U701','TPS61023DRLR',102.87,97.79,
          {1:'CO_FB',2:'VOUT_5V',3:'VOUT_5V',4:'GND',5:'CO_SW',6:'CO_5V28'},
          'Package_TO_SOT_SMD:SOT-563',custom=boost,autowire=False,field_at=(88.9,123.19),properties={'Stock':'New part / not confirmed in stock'})
    s.add('Device:L','L701','1uH / Isat >= 5 A',102.87,69.85,{1:'VOUT_5V',2:'CO_SW'},
          'Inductor_SMD:L_Taiyo-Yuden_NR-40xx',angle=90,autowire=False,field_at=(88.9,59.69),properties={'Selection':'Exact MPN, current, DCR and footprint require qualification'})
    capacitor(s,'C701','10u / 10V',44.45,93.98,'VOUT_5V')
    resistor(s,'R701','787k / 0.1%',156.21,83.82,'CO_5V28','CO_FB',angle=0,autowire=False)
    resistor(s,'R702','100k / 0.1%',156.21,115.57,'CO_FB','GND',angle=0,autowire=False)
    # Draw the switch-energy path and feedback divider as continuous wires.
    for ref,no in [('L701','2'),('U701','5'),('U701','1'),('R701','2'),('R702','1')]:
        s.done.add((ref,no))
    lx,ly=s.pin('L701','2')
    sx,sy=s.pin('U701','5')
    s.wire((lx,ly),(lx,76.2),(sx,76.2),(sx,sy))
    s.label('CO_SW',(lx,76.2),0)
    fx,fy=s.pin('U701','1')
    s.wire(s.pin('R701','2'),(156.21,fy),s.pin('R702','1'))
    s.wire((fx,fy),(156.21,fy))
    s.label('CO_FB',(130.81,fy),0)
    capacitor(s,'C702','22u / 10V',191.77,85.09,'CO_5V28')
    capacitor(s,'C703','22u / 10V',191.77,118.11,'CO_5V28')
    s.text('0.595 x (1 + 787k/100k) = 5.278 V nominal.\nVerify >=5.0 V at the module under start-up and load; account for ripple and cable loss.',25.4,139.7,1.016)
    s.add('Regulator_Linear:SPX3819M5-L-3-0','U702','SPX3819M5-L-3-0',297.18,96.52,
          {1:'VOUT_5V',2:'GND',3:'VOUT_5V',4:'CO_LOGIC_BYP',5:'CO_LOGIC_3V0'},
          'Package_TO_SOT_SMD:SOT-23-5',field_at=(281.94,74.93),properties={'Stock':'New part / not confirmed in stock'})
    capacitor(s,'C704','4.7u / 10V',241.3,91.44,'VOUT_5V')
    capacitor(s,'C705','4.7u / 10V',346.71,91.44,'CO_LOGIC_3V0')
    capacitor(s,'C706','10n',381,115.57,'CO_LOGIC_BYP')
    s.text('Powered by switched 5 V; independent of the MD62 heater rail.\nC706 bypasses the LDO reference. Confirm stability with chosen capacitors.\nCO_LOGIC_3V0 powers the translator only; do not use a reserved module pin.',223.52,137.16,1.016)
    txu=custom_symbol('TXU0202DCU',[
        (3,'VCCA','power_in',-15.24,15.24,0),(7,'VCCB','power_in',15.24,15.24,180),
        (5,'A1','input',-15.24,5.08,0),(8,'B1Y','output',15.24,5.08,180),
        (4,'A2Y','output',-15.24,-5.08,0),(1,'B2','input',15.24,-5.08,180),
        (6,'OE','input',-15.24,-15.24,0),(2,'GND','power_in',0,-22.86,90)],
        bounds=(-12.7,-20.32,12.7,17.78),datasheet='https://www.ti.com/lit/ds/symlink/txu0202.pdf')
    s.add('Trimix_Analyzer:TXU0202DCU','U703','TXU0202DCUR',111.76,205.74,
          {1:'CO_TX_3V0',2:'GND',3:'HOST_3V3',4:'CO_UART_RX',5:'CO_UART_TX',6:'CO_UART_EN',7:'CO_LOGIC_3V0',8:'CO_RX_3V0'},
          'Package_SO:VSSOP-8_2.3x2mm_P0.5mm',custom=txu,field_at=(97.79,177.8),properties={'Stock':'New part / not confirmed in stock'})
    capacitor(s,'C707','100n',45.72,201.93,'HOST_3V3')
    capacitor(s,'C708','100n',187.96,201.93,'CO_LOGIC_3V0')
    resistor(s,'R703','100k',53.34,240.03,'CO_UART_EN','GND',angle=0)
    s.text('A1 -> B1Y: host TX to module RX. B2 -> A2Y: module TX to host RX.\nOE is low during reset. Enable only after the CO supply is valid;\ndisable OE before power-down. Firmware: 9600 baud, 8 data bits, no parity, 1 stop.',25.4,255.27,1.016)
    h=connector('CO_Harness',['5.28V','GND','CO_TX','CO_RX'])
    s.add('Trimix_Analyzer:CO_Harness','J701','ZE07-CO harness',266.7,198.12,
          {1:'CO_5V28',2:'GND',3:'CO_TX_CABLE',4:'CO_RX_CABLE'},J,custom=h,field_at=(255.27,176.53))
    resistor(s,'R704','100R',262.89,224.79,'CO_TX_3V0','CO_TX_CABLE')
    resistor(s,'R705','100R',262.89,242.57,'CO_RX_3V0','CO_RX_CABLE')
    co=custom_symbol('ZE07_CO_Module',[
        (15,'VIN','power_in',-15.24,15.24,0),(14,'GND','power_in',-15.24,10.16,0),
        (5,'GND','power_in',-15.24,5.08,0),(8,'TXD','output',-15.24,0,0),
        (7,'RXD','input',-15.24,-5.08,0),(10,'DAC','output',15.24,15.24,180),
        *[(p,'RES' if p in (1,3,4,9) else 'NC','no_connect',15.24,10.16-i*3.81,180)
          for i,p in enumerate([1,2,3,4,6,9,11,12,13])]],
        bounds=(-12.7,-22.86,12.7,17.78),datasheet='https://www.winsen-sensor.com/d/files/manual/ze07-co.pdf')
    s.add('Trimix_Analyzer:ZE07_CO_Module','U704','ZE07-CO / off-board',358.14,201.93,
          {1:None,2:None,3:None,4:None,5:'GND',6:None,7:'CO_RX_CABLE',8:'CO_TX_CABLE',9:None,10:None,11:None,12:None,13:None,14:'GND',15:'CO_5V28'},
          '',custom=co,on_board=False,in_bom=False,field_at=(342.9,176.53),properties={'ModuleOffBoard':'yes','Stock':'Owned ZE07-CO module','Use':'Experimental CO measurement; manufacturer excludes human safety use'})
    s.text('Off-board; pins 1 and 9 reserved.\nJoin both ground pins at the module.\n15-90% RH: dry gas may be out of range.\nInvalid / stale data never means clean gas.\nManufacturer excludes human-safety systems.',309.88,232.41,1.016)
    return s.finish()

if __name__=='__main__':
    print(environment())
    print(carbon_monoxide())
