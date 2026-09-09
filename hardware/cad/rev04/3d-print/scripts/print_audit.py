#!/usr/bin/env python3
"""Regenerate all toolpath checks after the final slice; never print."""
import argparse,json
from pathlib import Path
from print_pipeline import PRINT,dump
from print_inspect import inspect
from print_sections import inspect_sections

def audit():
    manifest=json.loads((PRINT/'slice-manifest.json').read_text());rows=[];failed=[]
    for row in sorted(manifest['parts'],key=lambda r:(r['part_id'],r['material'])):
        print('Auditing '+row['part_id']+' '+row['material'],flush=True)
        try:
            r=inspect(row['project']);sections=inspect_sections(row['project'])
            row['island_candidate_layers']=r['island_candidate_layers']
            rows.append({'part_id':row['part_id'],'material':row['material'],'project':row['project'],
              'layer_events':r['layer_count'],'model_sections':sections['model_sections_checked'],
              'support_segments':r['generated_support_segments'],'support_core_conflicts':len(r['support_conflicts_with_exclusion_volumes']),
              'island_candidate_layers':r['island_candidate_layers'],
              'section_boundary_candidates':sections['sections_with_at_least_4_uncovered_boundary_pixels'],
              'slicer_warnings':r['slicer_warnings'],'visual_review':'pending'})
        except Exception as e:failed.append({'part_id':row['part_id'],'material':row['material'],'error':str(e)})
        dump(PRINT/'verification-summary.json',{'parts':rows,'failures':failed,'physical_print_jobs_sent':False,
          'scope':'All G-code layer events parsed; all model midlayer boundaries screened at0.25mm raster. Selected PNGs still require recorded visual review. No global wall, print strength or physical fit claim.'})
    dump(PRINT/'slice-manifest.json',manifest)
    cm=PRINT/'coupons/slice-manifest.json'
    if cm.exists():
        coupons=json.loads(cm.read_text());cr=[]
        for row in coupons['coupons']:
            print('Auditing '+row['coupon']+' '+row['material'],flush=True)
            r=inspect(row['project']);row['island_candidate_layers']=r['island_candidate_layers']
            cr.append({'coupon':row['coupon'],'material':row['material'],'layer_events':r['layer_count'],
              'support_core_conflicts':len(r['support_conflicts_with_exclusion_volumes']),
              'island_candidate_layers':r['island_candidate_layers'],'visual_review':'pending'})
        dump(cm,coupons);dump(PRINT/'coupons/verification-summary.json',{'coupons':cr,'physical_print_jobs_sent':False})
    if failed:raise RuntimeError('Audit failed; see verification-summary.json')
    print('Audit complete',flush=True)

if __name__=='__main__':audit()
