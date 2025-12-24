#include "gas_calculator.h"
#include <cmath>

/**
 * Gas calculation implementations
 * 
 * Pressure at depth: P = (depth/10) + 1 bar (absolute)
 * PPO2 = FO2 * P
 * EAD formula accounts for helium reducing narcotic gas fraction
 */

float calc_o2_for_depth_ppo2(float depth_m, float ppo2) {
    // P_abs = depth/10 + 1
    // PPO2 = FO2 * P_abs
    // FO2 = PPO2 / P_abs
    float p_abs = (depth_m / 10.0f) + 1.0f;
    float fo2 = ppo2 / p_abs;
    float o2_percent = fo2 * 100.0f;
    return clamp_float(o2_percent, 21.0f, 100.0f);
}

float calc_mod(float o2_percent, float ppo2) {
    // MOD = (PPO2 / FO2 - 1) * 10
    float fo2 = o2_percent / 100.0f;
    if (fo2 <= 0.0f) return 0.0f;
    float mod = ((ppo2 / fo2) - 1.0f) * 10.0f;
    return fmaxf(mod, 0.0f);
}

float calc_ppo2(float depth_m, float o2_percent) {
    // PPO2 = FO2 * P_abs
    float p_abs = (depth_m / 10.0f) + 1.0f;
    float fo2 = o2_percent / 100.0f;
    return fo2 * p_abs;
}

float calc_ead(float depth_m, float he_percent) {
    // EAD = ((1 - FHe) * (depth + 10) / 0.79) - 10
    // This gives the equivalent depth breathing air that would have
    // the same nitrogen partial pressure
    float f_he = he_percent / 100.0f;
    float narcotic_fraction = 1.0f - f_he;  // N2 + O2 (both narcotic at depth)
    
    // Simplified EAD: treats N2 as the narcotic component
    // EAD = ((FN2_mix / FN2_air) * (depth + 10)) - 10
    // For trimix: FN2_mix = 1 - FO2 - FHe, assuming ~21% O2 for simplicity
    // Or use narcotic gas fraction approach
    float ead = (narcotic_fraction * (depth_m + 10.0f) / 0.79f) - 10.0f;
    return fmaxf(ead, 0.0f);
}

float calc_depth_for_ead(float ead_m, float he_percent) {
    // Reverse EAD formula to get depth
    // EAD = ((1 - FHe) * (depth + 10) / 0.79) - 10
    // EAD + 10 = (1 - FHe) * (depth + 10) / 0.79
    // (EAD + 10) * 0.79 = (1 - FHe) * (depth + 10)
    // depth + 10 = (EAD + 10) * 0.79 / (1 - FHe)
    // depth = (EAD + 10) * 0.79 / (1 - FHe) - 10
    float f_he = he_percent / 100.0f;
    if (f_he >= 1.0f) return ead_m;  // Avoid division by zero
    
    float narcotic_fraction = 1.0f - f_he;
    float depth = ((ead_m + 10.0f) * 0.79f / narcotic_fraction) - 10.0f;
    return fmaxf(depth, 0.0f);
}

float calc_helium_for_ead(float depth_m, float ead_m) {
    // Solve EAD formula for FHe
    // EAD = ((1 - FHe) * (depth + 10) / 0.79) - 10
    // EAD + 10 = (1 - FHe) * (depth + 10) / 0.79
    // (EAD + 10) * 0.79 = (1 - FHe) * (depth + 10)
    // (EAD + 10) * 0.79 / (depth + 10) = 1 - FHe
    // FHe = 1 - (EAD + 10) * 0.79 / (depth + 10)
    if (depth_m <= 0.0f) return 0.0f;
    
    float f_he = 1.0f - ((ead_m + 10.0f) * 0.79f / (depth_m + 10.0f));
    float he_percent = f_he * 100.0f;
    return clamp_float(he_percent, 0.0f, 70.0f);
}

float clamp_float(float value, float min_val, float max_val) {
    if (value < min_val) return min_val;
    if (value > max_val) return max_val;
    return value;
}
