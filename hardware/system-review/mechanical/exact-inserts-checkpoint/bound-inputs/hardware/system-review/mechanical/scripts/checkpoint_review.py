"""Persist the independently verified mechanics before incoming PCB replacement."""
import importlib

def save():
    import materials_review,save_review
    importlib.reload(materials_review).insulator()
    importlib.reload(save_review).checkpoint()
