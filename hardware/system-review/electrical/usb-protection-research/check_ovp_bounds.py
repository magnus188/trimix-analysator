#!/usr/bin/env python3
"""Reproducible engineering estimates; no transient or USB compliance claim."""
import hashlib
import json
from pathlib import Path

HERE = Path(__file__).resolve().parent


def divider_bounds(top, bottom, vmin, vmax, tcr_ppm, drift=0.0):
    # Independent resistor extrema. 25 C reference, worst excursion to 125 C.
    fraction = 0.001 + tcr_ppm * 1e-6 * 100 + drift
    hi, lo = 1 + fraction, 1 - fraction
    leakage_drop = 0.1e-6 * top * hi
    return {
        "min_V": vmin * (1 + top * lo / (bottom * hi)) - leakage_drop,
        "max_V": vmax * (1 + top * hi / (bottom * lo)) + leakage_drop,
        "per_resistor_fraction": fraction,
    }


result = {
    "kind": "primary-datasheet calculations plus explicitly assumed transient model",
    "date": "2026-09-07",
    "candidate": "TPS259470ARPWR",
    "preferred_ovlo": {},
    "rejected_or_lower_compatibility_alternatives": [],
}
for drift in (0, 0.0005, 0.001):
    result["preferred_ovlo"][f"additional_independent_drift_{drift}"] = {
        "rising": divider_bounds(34000 + 649, 10000, 1.183, 1.223, 10, drift),
        "falling": divider_bounds(34000 + 649, 10000, 1.076, 1.116, 10, drift),
    }
for top, tcr in ((34000, 25), (34649, 25), (34665, 25), (34800, 10)):
    result["rejected_or_lower_compatibility_alternatives"].append({
        "top_ohm": top, "bottom_ohm": 10000, "tcr_ppm": tcr,
        "rising": divider_bounds(top, 10000, 1.183, 1.223, tcr),
    })
result["uvlo"] = {
    "top_ohm": 21500, "bottom_ohm": 10000, "tcr_ppm": 25,
    "rising": divider_bounds(21500, 10000, 1.183, 1.223, 25),
    "falling": divider_bounds(21500, 10000, 1.076, 1.116, 25),
}

# TDK curve is reference characterization, NOT a guaranteed combined corner.
cout_estimated_min = 4.7e-6 * 0.90 * 0.90 * 0.85 * 0.90
cout_estimated_max = 4.7e-6 * 1.10 * 1.15 * 1.03
cin_estimated_max = 0.1e-6 * 1.10 * 1.15 * 1.03
vtrip = result["preferred_ovlo"]["additional_independent_drift_0.001"]["rising"]["max_V"]
result["capacitor_estimates"] = {
    "out_mpn": "C3216X7R1E475K160AC",
    "out_estimated_min_F": cout_estimated_min,
    "out_estimated_max_F": cout_estimated_max,
    "in_plus_out_estimated_max_F": cout_estimated_max + cin_estimated_max,
    "total_charge_at_5V_C": (cout_estimated_max + cin_estimated_max) * 5,
    "out_min_factors": ["90% assumed bias retention", "-10% tolerance", "-15% X7R", "10% engineering aging allowance"],
    "out_max_factors": ["+10% tolerance", "+15% X7R", "3% engineering allowance for initial bias increase"],
    "not_guaranteed_by_manufacturer_combined_corner": True,
}
result["illustrative_transients"] = [{
    "assumed_current_A": current,
    "assumed_duration_s": 1.2e-6,
    "starting_V": vtrip,
    "estimated_delta_V": current * 1.2e-6 / cout_estimated_min,
    "estimated_peak_V": vtrip + current * 1.2e-6 / cout_estimated_min,
    "minimum_C_for_6V_F": current * 1.2e-6 / (6.0 - vtrip),
    "minimum_C_for_5_5V_F": current * 1.2e-6 / (5.5 - vtrip),
} for current in (1, 2.2, 5)]
cdvdt_min = 3300e-12 * (1 - 0.05 - 30e-6 * 100)
result["cold_start_estimate"] = {
    "dvdt_mpn": "C1608C0G1H332J080AA",
    "nominal_dVdt_V_per_ms_from_eq4": 2000 / 3300,
    "estimated_max_dVdt_V_per_s_assuming_unity_transfer": 3.82e-6 / cdvdt_min,
    "estimated_max_cap_charging_A_assuming_unity_transfer": cout_estimated_max * 3.82e-6 / cdvdt_min,
    "recovery_bypasses_dvdt_on_TPS259470": True,
    "not_a_datasheet_guaranteed_system_slew_limit": True,
}
result["bleed_estimate"] = {
    "bleed_ohm": 10000,
    "max_resistor_fraction": 0.0125,
    "conservative_min_supervisor_threshold_V": 4.1,
    "assumed_initial_V": 5.5,
}
import math
result["bleed_estimate"]["estimated_seconds_to_threshold"] = (
    10000 * 1.0125 * cout_estimated_max * math.log(5.5 / 4.1)
)
result["added_steady_input_budget_A"] = (
    610e-6 + 5.5 / ((34000 + 649 + 10000) * (1 - 0.004))
    + 5.5 / ((21500 + 10000) * (1 - 0.0035))
    + 5.5 / (10000 * (1 - 0.0125))
)
result["limitations"] = [
    "1.2 us OVLO response is typical only; AUXOFF delay and powered VOL max not specified.",
    "Assumed surge current is NOT limited to 1 A by this hardware.",
    "No parasitic inductance, ESR, ESL, source impedance or nonlinear capacitance transient model.",
    "10 uF comparison is a capacitance budget only; root owns total USB inrush qualification.",
    "No hardware measurements or fabrication performed.",
]
sources = {
    "tps25947-ovp-review-datasheet.pdf": "https://www.ti.com/lit/ds/symlink/tps25947.pdf",
    "c3216x7r1e475k160ac-ovp.pdf": "https://product.tdk.cn/system/files/dam/doc/product/capacitor/ceramic/mlcc/charasheet/c3216x7r1e475k160ac.pdf",
    "tnpw-e3-ovp-divider.pdf": "https://www.vishay.com/docs/28758/tnpw_e3.pdf",
}
result["source_receipts"] = [{
    "file": filename, "url": url,
    "sha256": hashlib.sha256((HERE / filename).read_bytes()).hexdigest(),
} for filename, url in sources.items()]
assert result["preferred_ovlo"]["additional_independent_drift_0.001"]["rising"]["min_V"] > 5.25
assert vtrip < 5.5
assert result["illustrative_transients"][0]["estimated_peak_V"] < 6
assert result["illustrative_transients"][1]["estimated_peak_V"] > 6
assert result["capacitor_estimates"]["in_plus_out_estimated_max_F"] < 10e-6
print(json.dumps(result, indent=2))
