"""Serial read-only verification and review phases for the completed A3."""
import importlib,json
from datetime import datetime,timezone
import build_a3 as b

def _call(module,function):
    m=importlib.import_module(module);importlib.reload(m)
    progress={'phase':module+'.'+function,'time_utc':datetime.now(timezone.utc).isoformat()}
    (b.BASE/'verification/current-qa-phase.json').write_text(json.dumps(progress)+'\n')
    return getattr(m,function)()

def technical_checks():
    for module,function in [('audit_a3','audit'),('gas_checks_a3','audit'),
                            ('wall_fastener_checks','audit'),('verification_a3','audit_drivers'),
                            ('verification_a3','audit_paths')]:
        _call(module,function)

def review_views():
    for module,function in [('audit_a3','audit'),('wall_fastener_checks','audit'),
                            ('review_a3','style'),('review_a3','export_views'),('review_a3','exploded')]:
        _call(module,function)
