#pragma once

#include <cstdint>

#ifdef __cplusplus
extern "C" {
#endif

/**
 * Gas calculation functions for dive planning
 * 
 * Key formulas:
 * - PPO2 = FO2 * (depth/10 + 1)  where FO2 is fraction (0.21 for air)
 * - MOD = (PPO2 / FO2 - 1) * 10
 * - EAD = ((1 - FHe) * (depth + 10) / 0.79) - 10  (Equivalent Air Depth)
 * - END = ((1 - FO2 - FHe) * (depth + 10) / 0.79) - 10  (Equivalent Narcotic Depth)
 */

/**
 * Calculate required O2 percentage for given depth and PPO2
 * @param depth_m Depth in meters
 * @param ppo2 Partial pressure of O2 in bar (e.g., 1.4)
 * @return O2 percentage (21-100)
 */
float calc_o2_for_depth_ppo2(float depth_m, float ppo2);

/**
 * Calculate Maximum Operating Depth for given O2% and PPO2
 * @param o2_percent O2 percentage (21-100)
 * @param ppo2 Target PPO2 in bar
 * @return MOD in meters
 */
float calc_mod(float o2_percent, float ppo2);

/**
 * Calculate PPO2 for given depth and O2%
 * @param depth_m Depth in meters
 * @param o2_percent O2 percentage
 * @return PPO2 in bar
 */
float calc_ppo2(float depth_m, float o2_percent);

/**
 * Calculate Equivalent Air Depth (EAD) for trimix
 * @param depth_m Actual depth in meters
 * @param he_percent Helium percentage (0-70)
 * @return EAD in meters
 */
float calc_ead(float depth_m, float he_percent);

/**
 * Calculate required depth for target EAD with given helium
 * @param ead_m Target EAD in meters
 * @param he_percent Helium percentage
 * @return Required actual depth in meters
 */
float calc_depth_for_ead(float ead_m, float he_percent);

/**
 * Calculate required helium for target EAD at given depth
 * @param depth_m Actual depth in meters
 * @param ead_m Target EAD in meters
 * @return Required helium percentage
 */
float calc_helium_for_ead(float depth_m, float ead_m);

/**
 * Clamp a value between min and max
 */
float clamp_float(float value, float min_val, float max_val);

#ifdef __cplusplus
}
#endif
