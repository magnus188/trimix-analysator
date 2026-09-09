"""Source-reviewed real 0402 parts; no board or schematic mutation on import.

These replace actual purchased parts, never scale a 0603 model. R116 is excluded
until its final routing package is selected; its frozen coordinated stage still
uses 0603. Stock and factory process acceptance remain separate.
"""
RT_SOURCE='https://yageogroup.com/content/datasheet/asset/file/pyu-rt_1-to-0-01_rohs_l'
SPEC='https://yageogroup.com/component-documentation/download/specsheet/'
RES='Resistor_SMD:R_0402_1005Metric'
def resistor(mpn,value,max_length,max_height,tcr,source):
 return {'MPN':mpn,'Manufacturer':'YAGEO','Value':value,'Footprint':RES,'Datasheet':source,'Maximum_body_length_mm':str(max_length),'Maximum_body_width_mm':'0.55','Maximum_body_height_mm':str(max_height),'Resistor_power_W_at_70C':'0.063','Resistor_maximum_continuous_voltage_V':'50','Resistor_TCR_ppm_per_C':str(tcr),'Assembly':'Factory reflow for true 0402 part; exact BOM/CPL quote and inspection required','Voltage_rating_note':'Continuous voltage also limited by derated rated power; 50V is not permitted across every resistance value.'}
CHOICES={
 'R101':resistor('RC0402FR-075K23L','5.23k 1%',1.05,.4,100,SPEC+'RC0402FR-075K23L'),
 'R115':resistor('RT0402BRD0710KL','10k / 0.1%',1.10,.35,25,SPEC+'RT0402BRD0710KL'),
 'R118':resistor('RT0402BRD07100KL','100k / 0.1%',1.10,.35,25,SPEC+'RT0402BRD07100KL'),
 'R119':resistor('RT0402BRD0719K1L','19.1k / 0.1%',1.10,.35,25,RT_SOURCE),
 'C116':{'MPN':'GRM1555C1H332JE01D','Manufacturer':'Murata','Value':'3.3n / 50V C0G / 5%','Footprint':'Capacitor_SMD:C_0402_1005Metric','Datasheet':'https://search.murata.co.jp/Ceramy/image/img/A01X/G101/ENG/GRM1555C1H332JE01-01A.pdf','Maximum_body_length_mm':'1.05','Maximum_body_width_mm':'0.55','Maximum_body_height_mm':'0.55','Assembly':'Factory reflow for true 0402 part; 3.3nF C0G slew timing function unchanged; exact BOM/CPL quote required'},
}
CHOICES['R101']['Source_review']='electrical/r101-0402-proposal.json; actual TS-divider resistance remains5.23k'
CHOICES['R115']['Source_review']='electrical/compact-passive-review/r115-source-review.json'
CHOICES['R118']['Source_review']='YAGEO exact RT0402BRD07100KL specsheet, generated2026-08-30; verified2026-09-08'
CHOICES['R119']['Source_review']='RT-series manufacturer package/ordering data; exact19.1k E96 MPN listed by LCSC C852587; per-partPDF was not retrievable'
CHOICES['R119']['Current_limit_note']='TI34/50/66mA table is specified at19.2k. The19.1k standard-value substitution uses engineering interpolation only; actual current corners remain to be measured.'
CHOICES['C116']['Source_review']='electrical/capacitor-research/c116-0402-source-review.json'
