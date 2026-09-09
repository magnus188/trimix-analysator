from pathlib import Path
import json,re,hashlib
D=Path(__file__).resolve().parent
j=json.loads((D/'ground2-series-delta.json').read_text());source=(D/'before.kicad_pcb').read_text()
remove=set(json.loads((D/'series-removed.json').read_text()))|{'7c8f1f3d-e80e-4166-8e74-5640eb930861','be3677cd-cfc8-46d7-bb23-7e9bbe397de3'}
change={'1d396b5b-f931-4444-ae17-a56a77819885','81a50918-f412-49be-81fe-86e8e1ae9c47','2ba862de-d0a8-4cf0-87a2-0078c6153d03','b4d8c057-4379-49e5-80c2-a804cef61b61','a0994180-4fb3-457e-b4ca-49d043104353'}
added=[]
for q in j['added']:
 s=q['native']
 if '(net "USB_ILIM_SERIES")'in s:added.append(q)
 elif '(net "USB_PERMISSION_Q")'in s:
  if '(layer "In2.Cu")'in s or '(start 18.9375 90.45)'in s or '(start 17.45 90.975)'in s:added.append(q)
removed=[q for q in j['removed']if q['uuid']in remove];changed=[q for q in j['changed']if q['uuid']in change]
assert len(removed)==8,(len(removed),remove-set(q['uuid']for q in removed));assert len(changed)==5
for q in removed:assert q['native']in source;source=source.replace(q['native'],'',1)
for q in changed:assert q['before']['native']in source;source=source.replace(q['before']['native'],q['after']['native'],1)
source=source.rstrip();assert source.endswith(')');source=source[:-1]+'\n'+''.join('\t'+q['native']+'\n'for q in added)+')\n'
(D/'q110-core-raw.kicad_pcb').write_text(source)
receipt=dict(source=str(D/'before.kicad_pcb'),source_sha256=hashlib.sha256((D/'before.kicad_pcb').read_bytes()).hexdigest(),removed=removed,added=added,changed=changed,scope='Q110180 at18,89.5; two local .60/.30GND vias20.3,87.85/20.75,88.3 retaining .20B source returns; all-F SERIES/gate; ownedQIn2jog. All resistor footprints/values/oldcopper retained verbatim; R116/R118unconnectedremain. CC owner must rerouteagainstthispose. No orderrelease.')
(D/'q110-core-delta.json').write_text(json.dumps(receipt,indent=2));print('removed',len(removed),'added',len(added),'changed',len(changed))
