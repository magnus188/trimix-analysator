"""Read exact USB feature parameters before a bounded datum correction."""
from runtime import owned,report,bounds,attrs
def inspect():
    _,doc,d=owned();cs=[]
    for c in d.allComponents:
        if not c.partNumber.startswith('TMX-A3-') or c.partNumber not in ['TMX-A3-P06','TMX-A3-P09','TMX-A3-P10','TMX-A3-C05-V01','TMX-A3-C05-V02','TMX-A3-C05-V04']:continue
        cs.append({'part':c.partNumber,'name':c.name,'features':[{'name':f.name,'type':f.objectType,'index':f.timelineObject.index,'parameters':[{'name':p.name,'expression':p.expression,'role':p.role}for p in d.allParameters if getattr(p,'createdBy',None) and p.createdBy==f]}for f in c.features],
            'parameters':[{'name':p.name,'expression':p.expression,'role':p.role,'created_by':p.createdBy.name if p.createdBy else None}for p in d.allParameters if getattr(p,'createdBy',None) and getattr(p.createdBy,'parentComponent',None)==c],
            'bodies':[{'name':b.name,'bounds_mm':bounds(b)}for b in c.bRepBodies]})
    report('usb-native-datums.json',{'document':doc.name,'components':cs,'parameters':[{'name':p.name,'expression':p.expression,'created_by':p.createdBy.name if p.createdBy else None}for p in d.allParameters if getattr(p,'createdBy',None) and 'PCB' in p.createdBy.name and ('ledge' in p.createdBy.name or 'capture' in p.createdBy.name or 'stop' in p.createdBy.name)]})
