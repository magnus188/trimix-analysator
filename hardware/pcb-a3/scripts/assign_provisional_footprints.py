"""Assign authorized provisional footprint metadata; preserve all electrical nodes.

Run once only. Board/model geometry is never modified. A source ZIP is saved
before any schematic edit. Final KiCad CLI netlist/ERC verification is separate.
"""
from pathlib import Path
import datetime, hashlib, json, re, zipfile

HW=Path(__file__).resolve().parents[2]
P=HW/'kicad/analyzer';V=HW/'pcb-a3/verification'
STATUS='PROVISIONAL: verify exact purchased part before fabrication'

def spans(text, depth_target=2):
    out=[];depth=0;quoted=False;escape=False;start=None
    for i,c in enumerate(text):
        if quoted:
            if escape:escape=False
            elif c=='\\':escape=True
            elif c=='"':quoted=False
            continue
        if c=='"':quoted=True
        elif c=='(':
            depth+=1
            if depth==depth_target:start=i
        elif c==')':
            if depth==depth_target:out.append((start,i+1))
            depth-=1
    assert depth==0 and not quoted
    return out

def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()

def main():
    intended=json.loads((V/'provisional-footprint-intent.json').read_text())
    sources=list(P.glob('*.kicad_sch'))+[P/'fp-lib-table']
    before={str(p.relative_to(HW.parent)):sha(p)for p in sources}
    edits={};seen={}
    for path in P.glob('*.kicad_sch'):
        old=path.read_text();changes=[]
        for a,b in spans(old):
            node=old[a:b]
            if not re.match(r'\(symbol\s',node):continue
            ref=re.search(r'\(property\s+"Reference"\s+"([^"]+)"',node)
            if not ref or ref[1]not in intended:continue
            ref=ref[1]
            assert ref not in seen
            m=re.search(r'\(property\s+"Footprint"\s+""',node)
            assert m, f'{ref}: footprint is no longer blank; stop for review.'
            assert '"Package_Status"'not in node
            changed=node[:m.end()-2]+json.dumps(intended[ref])+node[m.end():]
            pos=re.search(r'\(at\s+([-\d.]+)\s+([-\d.]+)\s+([-\d.]+)\)',node)
            assert pos
            prop='\n\t\t(property "Package_Status" '+json.dumps(STATUS)+'\n\t\t\t(at '+pos[1]+' '+pos[2]+' 0)\n\t\t\t(hide yes)\n\t\t\t(effects (font (size 1.27 1.27)))\n\t\t)\n\t'
            changed=changed[:-1]+prop+')'
            # Reversibility proof: all pre-existing bytes of the symbol are preserved
            # except the single blank Footprint value.
            restored=changed.replace(prop,'',1).replace(json.dumps(intended[ref]),'""',1)
            assert restored==node
            changes.append((a,b,changed))
            seen[ref]={'file':str(path.relative_to(HW.parent)),'before':'','after':intended[ref],'Package_Status':STATUS}
        if changes:
            text=old
            for a,b,changed in reversed(changes):text=text[:a]+changed+text[b:]
            spans(text);edits[path]=text
    assert set(seen)==set(intended),set(intended)-set(seen)
    stamp=datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%SZ')
    backup=V/f'analyzer-before-provisional-footprints-{stamp}.zip'
    with zipfile.ZipFile(backup,'x',zipfile.ZIP_DEFLATED)as z:
        for p in sources:z.write(p,str(p.relative_to(HW.parent)))
    with zipfile.ZipFile(backup)as z:assert z.testzip()is None
    assert before=={str(p.relative_to(HW.parent)):sha(p)for p in sources}
    for p,text in edits.items():p.write_text(text)
    receipt={'status':'metadata_applied_pending_CLI_verification','source_backup':str(backup.relative_to(HW.parent)),'source_backup_crc':'passed','before_hashes':before,'after_hashes':{str(p.relative_to(HW.parent)):sha(p)for p in sources},'assignments':seen,'preexisting_symbol_bytes_unchanged_except_footprint':True,'PCB_geometry_modified':False,'qualification':'These footprints match the current placement proxy; actual purchased parts remain unqualified.'}
    (V/'provisional-footprints-verification.json').write_text(json.dumps(receipt,indent=2)+'\n')
    print(json.dumps({'edited_files':[str(p)for p in edits],'references':sorted(seen),'backup':str(backup)},indent=2))

if __name__=='__main__':main()
