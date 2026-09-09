"""Primary-datasheet sensor ADC and fixed matched-divider definitions.

ADS122C04 PW pin numbering is deliberately independent of KiCad's ADC library.
The two analog channels retain their established external harness net names.
"""
from analyzer_sheet import custom_symbol, node, S, child, children, effects

ADS_DS = 'https://www.ti.com/lit/ds/symlink/ads122c04.pdf'
RN_DS = 'https://www.vishay.com/doc?28770='
RN_LAND_DS = 'https://www.vishay.com/doc?28950='
ADC_FP = 'Package_SO:TSSOP-16_4.4x5mm_P0.65mm'
RN_FP = 'Trimix_Analog:Vishay_ACAS0606_AT_IEC'
RN_MPN = 'ACASN2001U2001P1AT'
PW_PIN_NAMES = {'1':'A0','2':'A1','3':'~{RESET}','4':'DGND','5':'AVSS',
                '6':'AIN3','7':'AIN2','8':'REFN','9':'REFP','10':'AIN1',
                '11':'AIN0','12':'AVDD','13':'DVDD','14':'~{DRDY}',
                '15':'SDA','16':'SCL'}

def adc_pin_nets(address_a0, inputs):
    return {'1':address_a0,'2':'GND','3':'HOST_3V3','4':'GND','5':'GND',
            '6':inputs[3],'7':inputs[2],'8':None,'9':None,'10':inputs[1],
            '11':inputs[0],'12':'HOST_3V3','13':'HOST_3V3','14':None,
            '15':'I2C_SDA','16':'I2C_SCL'}

def adc_symbol():
    positions = {
      '1':(15.24,-2.54,180),'2':(15.24,-7.62,180),
      '3':(15.24,12.7,180),'4':(2.54,-20.32,90),
      '5':(-2.54,-20.32,90),'6':(-15.24,-7.62,0),
      '7':(-15.24,-2.54,0),'8':(-15.24,-15.24,0),
      '9':(-15.24,-12.7,0),'10':(-15.24,2.54,0),
      '11':(-15.24,7.62,0),'12':(-2.54,20.32,270),
      '13':(2.54,20.32,270),'14':(15.24,-12.7,180),
      '15':(15.24,7.62,180),'16':(15.24,2.54,180)}
    pins=[]
    for number,name in PW_PIN_NAMES.items():
        kind='power_in' if number in {'4','5','12','13'} else 'bidirectional' if number=='15' else 'open_collector' if number=='14' else 'input'
        pins.append((number,name,kind,*positions[number]))
    a=custom_symbol('ADS122C04_PW',pins,(-12.7,-17.78,12.7,17.78),
        'TI ADS122C04, 24-bit differential ADC, PW TSSOP-16; exact TI PW pinmap',ADS_DS)
    for p in children(a,'property'):
        if p[1]=='Value':p[2]='ADS122C04IPWR'
        if p[1]=='Footprint':p[2]=ADC_FP
    return a

def divider_symbol():
    # Two isolated elements: R1 is 1--4; R2 is 2--3. The schematic must join 4--2.
    a=custom_symbol('ACAS0606_2R_MATCHED',[
      ('1','R1.1','passive',0,17.78,270),
      ('4','R1.2','passive',12.7,5.08,180),
      ('2','R2.1','passive',12.7,-5.08,180),
      ('3','R2.2','passive',0,-17.78,90)],(-5.08,-15.24,10.16,15.24),
      'Vishay ACAS0606 isolated matched 2-resistor array: 1--4 and 2--3',RN_DS)
    for p in children(a,'property'):
        if p[1]=='Reference':p[2]='RN'
        if p[1]=='Value':p[2]='2x2k / 1:1 matched'
        if p[1]=='Footprint':p[2]=RN_FP
    child(a,'pin_names').append(node('hide',S('yes')))
    body=child(a,'symbol')
    def line(*pts):
        body.append(node('polyline',node('pts',*[node('xy',*p) for p in pts]),
            node('stroke',node('width',0.254),node('type',S('default'))),node('fill',node('type',S('none')))))
    for y1,y2 in [(12.7,7.62),(-7.62,-12.7)]:
        body.append(node('rectangle',node('start',-1.27,y1),node('end',1.27,y2),
            node('stroke',node('width',0.254),node('type',S('default'))),node('fill',node('type',S('none')))))
    line((0,15.24),(0,12.7));line((0,7.62),(0,5.08),(10.16,5.08))
    line((10.16,-5.08),(0,-5.08),(0,-7.62));line((0,-12.7),(0,-15.24))
    return a

def divider_properties():
    return {'Manufacturer':'Vishay Beyschlag','MPN':RN_MPN,
            'Primary_datasheet':RN_DS,'Land_pattern_source':RN_LAND_DS,
            'Purpose':'Fixed 1.5 V nominal MD62 bridge reference; software stores signed zero/span',
            'Absolute_tolerance':'0.1%','Ratio_matching':'0.05% relative, per Vishay medial-axis definition',
            'TCR_tracking':'5 ppm/K relative; 10 ppm/K absolute (U grade)',
            'Ordering_status':'Manufacturer ordering-code selection; distributor stock and lead time must be confirmed',
            'Package':'ACAS 0606 AT, 1.5 x 1.6 x 0.45 mm nominal; IEC land pattern'}
