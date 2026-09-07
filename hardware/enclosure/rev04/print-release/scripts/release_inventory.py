"""Create a portable file inventory from actual release artifacts.

Run locally after CAD, drawing, slicer and guide work. This reads artifacts and
writes an index/checksum list only; it never changes CAD or sends print jobs.
"""
from pathlib import Path
import csv,hashlib,json,zipfile
from datetime import datetime,timezone

ROOT=Path(__file__).resolve().parents[1]

def digest(path):
    h=hashlib.sha256()
    with path.open('rb') as stream:
        for block in iter(lambda:stream.read(1024*1024),b''):h.update(block)
    return h.hexdigest()

def manifest_assets():
    """Only current projects/meshes are distributable print assets.

    Source meshes are retained as reproducible inputs and explicitly labelled;
    oriented meshes are the 19 ready-to-import part/coupon print meshes.
    """
    assets={}
    for name,key,expected in [('slice-manifest.json','parts',22),
                              ('coupons/slice-manifest.json','coupons',16)]:
        data=json.loads((ROOT/'printing'/name).read_text())
        if data.get('failures') or len(data[key])!=expected:
            raise RuntimeError('Incomplete current print manifest: '+name)
        for row in data[key]:
            p=Path(row['project']).resolve()
            p.relative_to(ROOT)
            if not p.is_file() or digest(p)!=row['sha256']:
                raise RuntimeError('Missing or stale print project: '+str(p))
            assets[p]='sliced print project'
    for name,key,expected in [('print-manifest.json','parts',11),
                              ('coupons/coupon-manifest.json','coupons',8)]:
        data=json.loads((ROOT/'printing'/name).read_text())
        if data.get('failures') or len(data[key])!=expected:
            raise RuntimeError('Incomplete current mesh manifest: '+name)
        for row in data[key]:
            for field,role in [('source','source mesh input'),('oriented','oriented print mesh')]:
                p=Path(row['mesh'][field]).resolve()
                p.relative_to(ROOT)
                if not p.is_file() or digest(p)!=row['mesh'][field+'_sha256']:
                    raise RuntimeError('Missing or stale mesh input: '+str(p))
                assets[p]=role
    if sum(p.suffix.lower()=='.3mf' for p in assets)!=38:
        raise RuntimeError('Current manifests must identify exactly 38 unique print projects')
    return assets

def collect():
    assets=manifest_assets()
    paths=set(assets)
    for p in ROOT.rglob('*'):
        if not p.is_file() or p.is_symlink():continue
        rel=p.relative_to(ROOT)
        if any(x.startswith('.') or x in ('__pycache__','guide-build','diagnostics',
            'pipeline-check','prepared-projects','isolated-bambu-data','slicedata') for x in rel.parts):continue
        if p.suffix.lower() not in ('.f3d','.f3z','.f2d','.step','.stl','.3mf','.pdf','.pptx','.csv','.md','.py','.mjs'):continue
        # Neither globbing nor a convenient filename may promote an old/test
        # STL or 3MF into the current distribution manifest.
        if p.suffix.lower() in ('.stl','.3mf'):continue
        if any('pipeline_' in x for x in rel.parts):continue
        if 'inspection' in rel.parts:continue
        if p.name in ('FILE_INDEX.csv','FILE_INDEX.md'):continue
        paths.add(p)
    return sorted(paths),assets

def main():
    rows=[]
    paths,assets=collect()
    for p in paths:
        rel=str(p.relative_to(ROOT))
        row={'path':rel,'bytes':p.stat().st_size,'sha256':digest(p),
             'format':p.suffix.lower().lstrip('.'),'role':assets.get(p,'artifact or editable source')}
        if p.suffix.lower() in ('.f3d','.f3z','.3mf','.pptx'):
            with zipfile.ZipFile(p) as archive:
                if archive.testzip():raise RuntimeError('Archive CRC failed: '+rel)
        rows.append(row)
    with (ROOT/'FILE_INDEX.csv').open('w',newline='') as stream:
        writer=csv.DictWriter(stream,fieldnames=['path','bytes','sha256','format','role']);writer.writeheader();writer.writerows(rows)
    counts={extension:sum(r['format']==extension for r in rows) for extension in sorted({r['format'] for r in rows})}
    report={'generated_at_utc':datetime.now(timezone.utc).isoformat(),'counts':counts,'files':rows,
      'readiness':'Current partial artifact inventory only; this does not declare the enclosure/documentation release complete.',
      'print_asset_counts':{role:sum(r['role']==role for r in rows) for role in
                            ('sliced print project','oriented print mesh','source mesh input')},
      'inclusion_policy':'STL/3MF inclusion is controlled by the four current print/coupon manifests and validated hashes. Diagnostics, unsupported baselines, prepared support-blocker intermediates, slicer runtime/cache, inspection intermediates and guide-build directories are excluded. Source STL inputs are distinct from oriented print meshes. Files are preserved on disk.',
      'scope':'File existence, size, SHA256 and archive CRC only. CAD, drawing associations, print paths and visual guide QA have separate records. Physical qualification remains pending.'}
    (ROOT/'verification/file-inventory.json').write_text(json.dumps(report,indent=2)+'\n')
    print(json.dumps({'files':len(rows),'counts':counts}))

if __name__=='__main__':main()
