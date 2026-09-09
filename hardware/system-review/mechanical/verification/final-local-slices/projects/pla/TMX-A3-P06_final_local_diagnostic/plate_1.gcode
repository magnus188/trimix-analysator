; HEADER_BLOCK_START
; BambuStudio 02.08.02.61
; model printing time: 11m 4s; total estimated time: 16m 31s
; total layer number: 85
; total filament length [mm] : 953.34
; total filament volume [cm^3] : 2293.04
; total filament weight [g] : 2.84
; filament_density: 1.24
; filament_diameter: 1.75
; max_z_height: 12.20
; filament: 1
; support_material_on_wipe_tower: 0
; HEADER_BLOCK_END

; CONFIG_BLOCK_START
; accel_to_decel_enable = 0
; accel_to_decel_factor = 50%
; activate_air_filtration = 0
; additional_cooling_fan_speed = 70
; additional_fan_full_speed_layer = 0
; alternate_extra_wall = 0
; ams_filament_load_time_ams = 0
; ams_filament_load_time_ams_lite = 0
; ams_filament_load_time_n3f_s = 0
; ams_filament_unload_time_ams = 0
; ams_filament_unload_time_ams_lite = 0
; ams_filament_unload_time_n3f_s = 0
; apply_scarf_seam_on_circles = 1
; auxiliary_fan = 1
; avoid_crossing_wall_includes_support = 0
; bed_custom_model = 
; bed_custom_texture = 
; bed_exclude_area = 
; bed_heat_soak_area = 
; bed_temperature_formula = by_highest_temp
; before_layer_change_gcode = 
; best_object_pos = 0.3,0.5
; bottom_color_penetration_layers = 3
; bottom_shell_layers = 5
; bottom_shell_thickness = 0
; bottom_surface_density = 100%
; bottom_surface_pattern = monotonic
; bridge_angle = 0
; bridge_flow = 1
; bridge_no_support = 0
; bridge_speed = 50,50
; brim_object_gap = 0.15
; brim_type = outer_only
; brim_width = 4
; chamber_temperatures = 0
; change_filament_gcode = ;======== H2D ========\n;===== 20260528 =====\nM993 A2 B2 C2 ; nozzle cam detection allow status save.\nM993 A0 B0 C0 ; nozzle cam detection not allowed.\n\n{if (filament_type[next_filament_id] == \"PLA\") ||  (filament_type[next_filament_id] == \"PETG\")\n ||  (filament_type[next_filament_id] == \"PLA-CF\")  ||  (filament_type[next_filament_id] == \"PETG-CF\")}\nM1015.4 S1 K0 ;disable E air printing detect\n{else}\nM1015.4 S0 ; disable E air printing detect\n{endif}\n\nM620 S[next_filament_id]A H[next_hotend]\nM1002 gcode_claim_action : 4\nM204 S9000\n\nG1 Z{max_layer_z + 3.0} F1200\n\nM400\nM106 P1 S0\nM106 P2 S0\n\n{if toolchange_count == 2}\n; get travel path for change filament\n;M620.1 X[travel_point_1_x] Y[travel_point_1_y] F21000 P0\n;M620.1 X[travel_point_2_x] Y[travel_point_2_y] F21000 P1\n;M620.1 X[travel_point_3_x] Y[travel_point_3_y] F21000 P2\n{endif}\n\n{if ((filament_type[current_filament_id] == \"PLA\") || (filament_type[current_filament_id] == \"PLA-CF\") || (filament_type[current_filament_id] == \"PETG\")) && (nozzle_diameter_at_nozzle_id[current_nozzle_id] == 0.2)}\nM620.10 A0 F74.8347 L[flush_length] H{nozzle_diameter_at_nozzle_id[current_nozzle_id]} T{flush_temperatures[current_filament_id]} P[old_filament_temp] S1\n{else}\nM620.10 A0 F{flush_volumetric_speeds[current_filament_id]/2.4053*60*0.8} L[flush_length] H{nozzle_diameter_at_nozzle_id[current_nozzle_id]} T{flush_temperatures[current_filament_id]} P[old_filament_temp] S1\n{endif}\n\n{if ((filament_type[next_filament_id] == \"PLA\") || (filament_type[next_filament_id] == \"PLA-CF\") || (filament_type[next_filament_id] == \"PETG\")) && (nozzle_diameter_at_nozzle_id[next_nozzle_id] == 0.2)}\nM620.10 A1 F74.8347 L[flush_length] H{nozzle_diameter_at_nozzle_id[next_nozzle_id]} T{flush_temperatures[next_filament_id]} P[new_filament_temp] S1\n{else}\nM620.10 A1 F{flush_volumetric_speeds[next_filament_id]/2.4053*60*0.8} L[flush_length] H{nozzle_diameter_at_nozzle_id[next_nozzle_id]} T{flush_temperatures[next_filament_id]} P[new_filament_temp] S1\n{endif}\n\n{if long_retraction_when_cut}\nM620.11 P1 I[current_filament_id] B[current_hotend] E-{retraction_distance_when_cut} F{max((flush_volumetric_speeds[current_filament_id]/2.4053*60), 200)}\n{else}\nM620.11 P0 I[current_filament_id] B[current_hotend] E0\n{endif}\n\n{if long_retraction_when_ec}\nM620.11 K1 I[current_filament_id] B[current_hotend] R{retraction_distance_when_ec} F{max((flush_volumetric_speeds[current_filament_id]/2.4053*60), 200)}\n{else}\nM620.11 K0 I[current_filament_id] B[current_hotend] R0\n{endif}\n\nM620.15 C{new_filament_temp - filament_cooling_before_tower[next_filament_id]}\n\nM628 S1\n{if filament_type[current_filament_id] == \"TPU\"}\nM620.11 S0 L0 I[current_filament_id] B[current_hotend] E-{retraction_distances_when_cut[current_filament_id]} F{max((flush_volumetric_speeds[current_filament_id]/2.4053*60), 200)}\n{else}\n{if (filament_type[current_filament_id] == \"PA\") || (filament_type[current_filament_id] == \"PA-GF\")}\nM620.11 S1 L0 I[current_filament_id] B[current_hotend] R4 D2 E-{retraction_distances_when_cut[current_filament_id]} F{max((flush_volumetric_speeds[current_filament_id]/2.4053*60), 200)}\n{else}\nM620.11 S1 L0 I[current_filament_id] B[current_hotend] R10 D8 E-{retraction_distances_when_cut[current_filament_id]} F{max((flush_volumetric_speeds[current_filament_id]/2.4053*60), 200)}\n{endif}\n{endif}\nM629\n\n{if (filament_type[current_filament_id] == \"TPU\") && (filament_map[current_filament_id] == 2) && (nozzle_volume_types[current_nozzle_id] != \"TPU High Flow\")}\nM620.11 H2 C331\n{else}\nM620.11 H0\n{endif}\n\n{if  (nozzle_volume_types[current_nozzle_id] == \"TPU High Flow\") && (filament_map[current_filament_id] == 2) && (filament_map[next_filament_id] == 1)}\n;sw from R2L&TPU kit, travel run a distance for sketch TPU\nG1 X30 Y30 F5000\nM400\nG1 X300 Y30 F5000\nM400\n{endif}\n\nT[next_filament_id] H[next_hotend]\n\n;deretract\n{if filament_type[next_filament_id] == \"TPU\"}\n{else}\n{if (filament_type[next_filament_id] == \"PA\") || (filament_type[next_filament_id] == \"PA-GF\")}\n;VG1 E1 F{max(new_filament_e_feedrate, 200)}\n;VG1 E1 F{max(new_filament_e_feedrate/2, 100)}\n{else}\n;VG1 E4 F{max(new_filament_e_feedrate, 200)}\n;VG1 E4 F{max(new_filament_e_feedrate/2, 100)}\n{endif}\n{endif}\n\n; VFLUSH_START\n\n{if flush_length>41.5}\n;VG1 E41.5 F{min(old_filament_e_feedrate,new_filament_e_feedrate)}\n;VG1 E{flush_length-41.5} F{new_filament_e_feedrate}\n{else}\n;VG1 E{flush_length} F{min(old_filament_e_feedrate,new_filament_e_feedrate)}\n{endif}\n\nSYNC T{ceil(flush_length / 125) * 5}\n\n; compensate for heating and cooling\n{if flush_length > 0}\n{if flush_temperatures[next_filament_id] > new_filament_temp}\nSYNC T{(flush_temperatures[next_filament_id]-(new_filament_temp - filament_cooling_before_tower[next_filament_id]))/hotend_cooling_rate[filament_map[next_filament_id]-1]}\nSYNC T{(flush_temperatures[next_filament_id]-(new_filament_temp - filament_cooling_before_tower[next_filament_id]))/hotend_heating_rate[filament_map[next_filament_id]-1]}\n{else}\nSYNC T{(new_filament_temp - filament_cooling_before_tower[next_filament_id] -flush_temperatures[next_filament_id])/hotend_cooling_rate[filament_map[next_filament_id]-1]}\nSYNC T{(new_filament_temp - filament_cooling_before_tower[next_filament_id] -flush_temperatures[next_filament_id])/hotend_heating_rate[filament_map[next_filament_id]-1]}\n{endif}\n{endif}\n\n\n; VFLUSH_END\n\nM1002 set_filament_type:{filament_type[next_filament_id]}\n\nM400\nM83\n{if next_filament_id < 255}\n\nM620.10 R{new_extruder_retracted_length}\nM628 S0\n;VM109 S[new_filament_temp]\nM629\nM400\n\n;prime_tower_interface\n{if is_prime_tower_interface && filament_tower_interface_purge_volume !=0}\nG150.1\nM620.13 W0 L{filament_tower_interface_purge_volume} T{filament_tower_interface_print_temp} R0.0\n{endif}\n;prime_tower_interface\n\nM983.3 F{filament_max_volumetric_speed[next_filament_id]/2.4} A0.4 R{new_extruder_retracted_length}\n\nM400\n{if wipe_avoid_perimeter}\nG1 Y320 F30000\nG1 X{wipe_avoid_pos_x} F30000\n{endif}\nG1 Y295 F30000\nG1 Y265 F18000\nG1 Z{max_layer_z + 3.0} F3000\n{if layer_z <= (initial_layer_print_height + 0.001)}\nM204 S[initial_layer_acceleration]\n{else}\nM204 S[default_acceleration]\n{endif}\n{else}\nG1 X[x_after_toolchange] Y[y_after_toolchange] Z[z_after_toolchange] F12000\n{endif}\nM621 S[next_filament_id]A\n\nM622.1 S0 ;for prev version, default skip\nM1002 judge_flag powerloss_resume_flag\nM622 J1\nM983.3 F{filament_max_volumetric_speed[next_filament_id]/2.4} A0.4 R{new_extruder_retracted_length}\nM400\n{if wipe_avoid_perimeter}\nG1 Y320 F30000\nG1 X{wipe_avoid_pos_x} F30000\n{endif}\nG1 Y295 F30000\nG1 Y265 F18000\nG1 Z{max_layer_z + 3.0} F3000\n{if layer_z <= (initial_layer_print_height + 0.001)}\nM204 S[initial_layer_acceleration]\n{else}\nM204 S[default_acceleration]\n{endif}\nM1002 set_flag powerloss_resume_flag=0\nM623\n\nM993 A3 B3 C3 ; nozzle cam detection allow status restore.\n\n{if (filament_type[next_filament_id]  == \"TPU\")}\nM1015.3 S1;enable tpu clog detect\n{else}\nM1015.3 S0;disable tpu clog detect\n{endif}\n\n{if (filament_type[next_filament_id] == \"PLA\") ||  (filament_type[next_filament_id] == \"PETG\")\n ||  (filament_type[next_filament_id] == \"PLA-CF\")  ||  (filament_type[next_filament_id] == \"PETG-CF\")}\nM1015.4 S1 K1 H{nozzle_diameter_at_nozzle_id[next_nozzle_id]} ;enable E air printing detect\n{else}\nM1015.4 S0 ; disable E air printing detect\n{endif}\n\nM620.6 I[next_filament_id] H[next_hotend] W1 ;enable ams air printing detect\nM620 Q{toolchange_count + 1}\nM1002 gcode_claim_action : 0\n
; circle_compensation_manual_offset = 0
; circle_compensation_speed = 200
; close_additional_fan_first_x_layers = 1
; close_fan_the_first_x_layers = 1
; compatible_printers_condition = 
; complete_print_exhaust_fan_speed = 70
; cool_plate_temp = 35
; cool_plate_temp_initial_layer = 35
; cooling_filter_enabled = 0
; cooling_perimeter_transition_distance = 10
; cooling_slowdown_logic = uniform_cooling
; counter_coef_1 = 0
; counter_coef_2 = 0.008
; counter_coef_3 = -0.041
; counter_limit_max = 0.033
; counter_limit_min = -0.035
; counterbore_hole_bridging = none
; curr_bed_type = Textured PEI Plate
; default_acceleration = 8000,8000
; default_ams_type = -1
; default_filament_colour = ""
; default_filament_profile = "Bambu PLA Basic @BBL H2D"
; default_jerk = 0
; default_nozzle_volume_type = Standard,Standard
; default_print_profile = 0.20mm Standard @BBL H2D
; deretraction_speed = 30,30
; detect_floating_vertical_shell = 1
; detect_narrow_internal_solid_infill = 1
; detect_overhang_wall = 1
; detect_thin_wall = 0
; diameter_limit = 50
; different_settings_to_system = ;;
; draft_shield = disabled
; during_print_exhaust_fan_speed = 70
; elefant_foot_compensation = 0.15
; embedding_wall_into_infill = 0
; enable_arc_fitting = 1
; enable_circle_compensation = 0
; enable_filament_dynamic_map = 0
; enable_height_slowdown = 0,0
; enable_long_retraction_when_cut = 2
; enable_mixed_color_sublayer = 0
; enable_order_independent_overlap_carving = 0
; enable_overhang_bridge_fan = 1
; enable_overhang_speed = 1,1
; enable_pre_heating = 1
; enable_pressure_advance = 0
; enable_prime_tower = 0
; enable_support = 1
; enable_support_ironing = 0
; enable_tower_interface_features = 1
; enable_wrapping_detection = 0
; enforce_support_layers = 0
; eng_plate_temp = 55
; eng_plate_temp_initial_layer = 55
; ensure_vertical_shell_thickness = enabled
; exclude_object = 1
; extruder_ams_count = 1#0|4#1;1#0|4#1
; extruder_clearance_dist_to_rod = 50
; extruder_clearance_height_to_lid = 201
; extruder_clearance_height_to_rod = 47.4
; extruder_clearance_max_radius = 96
; extruder_colour = #018001;#018001
; extruder_max_nozzle_count = 1,1
; extruder_nozzle_stats = Standard#1;Standard#1
; extruder_offset = 0x0,0x0
; extruder_printable_area = 0x0,325x0,325x320,0x320#25x0,350x0,350x320,25x320
; extruder_printable_height = 320,325
; extruder_type = Direct Drive,Direct Drive
; extruder_variant_list = "Direct Drive Standard,Direct Drive High Flow,Direct Drive E3D High Flow";"Direct Drive Standard,Direct Drive High Flow,Direct Drive TPU High Flow,Direct Drive E3D High Flow"
; fan_cooling_layer_time = 100
; fan_direction = left
; fan_max_speed = 100
; fan_min_speed = 100
; farthest_point_timelapse = 1
; filament_adaptive_volumetric_speed = 0
; filament_adhesiveness_category = 100
; filament_bridge_speed = 25
; filament_change_length = 10
; filament_change_length_nc = 10
; filament_colour = #00AE42
; filament_cooling_before_tower = 10
; filament_cost = 20
; filament_density = 1.24
; filament_dev_ams_drying_ams_limitations = 1
; filament_dev_ams_drying_heat_distortion_temperature = 45
; filament_dev_ams_drying_temperature = 45
; filament_dev_ams_drying_time = 12
; filament_dev_chamber_drying_bed_temperature = 70
; filament_dev_chamber_drying_time = 12
; filament_dev_drying_cooling_temperature = 45
; filament_dev_drying_softening_temperature = 50
; filament_diameter = 1.75
; filament_enable_overhang_speed = 1
; filament_end_gcode = "; filament end gcode \n"
; filament_extruder_compatibility = 0
; filament_extruder_variant = "Direct Drive Standard"
; filament_flow_ratio = 0.98
; filament_flush_temp = 0
; filament_flush_temp_fast = 0
; filament_flush_volumetric_speed = 0
; filament_ids = GFL99
; filament_is_mixed = 0
; filament_is_support = 0
; filament_map = 1
; filament_map_2 = 0
; filament_map_mode = Auto For Flush
; filament_max_volumetric_speed = 12
; filament_metal_stickiness = None
; filament_minimal_purge_on_wipe_tower = 15
; filament_mixed_components = ""
; filament_mixed_gradient = 0
; filament_mixed_gradient_curve = ""
; filament_mixed_gradient_per_part = 0
; filament_mixed_gradient_range = ""
; filament_mixed_sublayer_ratios = ""
; filament_notes = 
; filament_nozzle_map = 0
; filament_overhang_1_4_speed = 0
; filament_overhang_2_4_speed = 50
; filament_overhang_3_4_speed = 30
; filament_overhang_4_4_speed = 10
; filament_overhang_totally_speed = 10
; filament_pre_cooling_temperature = 0
; filament_pre_cooling_temperature_nc = 0
; filament_preheat_temperature_delta = 10
; filament_prime_volume = 45
; filament_prime_volume_nc = 60
; filament_printable = 3
; filament_ramming_travel_time = 0
; filament_ramming_travel_time_nc = 0
; filament_ramming_volumetric_speed = -1
; filament_ramming_volumetric_speed_nc = -1
; filament_retract_length_nc = 14
; filament_scarf_gap = 15%
; filament_scarf_height = 10%
; filament_scarf_length = 10
; filament_scarf_seam_type = none
; filament_self_index = 1
; filament_settings_id = "Generic PLA @BBL H2D"
; filament_shrink = 100%
; filament_soluble = 0
; filament_start_gcode = "; filament start gcode\n"
; filament_tower_interface_pre_extrusion_dist = 10
; filament_tower_interface_pre_extrusion_length = 0
; filament_tower_interface_print_temp = -1
; filament_tower_interface_purge_volume = 20
; filament_tower_ironing_area = 4
; filament_type = PLA
; filament_velocity_adaptation_factor = 1
; filament_vendor = Generic
; filament_volume_map = 0
; filename_format = {input_filename_base}_{filament_type[0]}_{print_time}.gcode
; fill_multiline = 1
; filter_out_gap_fill = 0
; first_layer_print_sequence = 0
; first_x_layer_fan_speed = 0
; first_x_layer_part_fan_speed = 0
; flush_into_infill = 0
; flush_into_objects = 0
; flush_into_support = 1
; flush_multiplier = 1
; flush_multiplier_fast = 1.2
; flush_volumes_matrix = 0,280,280,280,280,0,280,280,280,280,0,280,280,280,280,0
; flush_volumes_vector = 140,140,140,140,140,140,140,140
; full_fan_speed_layer = 0
; fuzzy_skin = none
; fuzzy_skin_first_layer = 0
; fuzzy_skin_mode = displacement
; fuzzy_skin_noise_type = classic
; fuzzy_skin_octaves = 4
; fuzzy_skin_persistence = 0.5
; fuzzy_skin_point_distance = 0.8
; fuzzy_skin_scale = 1
; fuzzy_skin_thickness = 0.3
; gap_infill_speed = 250,250
; gcode_add_line_number = 0
; gcode_flavor = marlin
; grab_length = 0,0
; group_algo_with_time = 0
; has_filament_switcher = 0
; has_scarf_joint_seam = 0
; head_wrap_detect_zone = 
; hole_coef_1 = 0
; hole_coef_2 = -0.008
; hole_coef_3 = 0.23415
; hole_limit_max = 0.22
; hole_limit_min = 0.088
; hot_plate_temp = 55
; hot_plate_temp_initial_layer = 55
; hotend_cooling_rate = 2,2
; hotend_heating_rate = 3.6,3.6
; impact_strength_z = 10
; independent_support_layer_height = 1
; infill_combination = 0
; infill_direction = 45
; infill_instead_top_bottom_surfaces = 0
; infill_jerk = 9
; infill_lock_depth = 1
; infill_rotate_step = 0
; infill_shift_step = 0.4
; infill_wall_overlap = 15%
; inherits_group = ;;
; initial_layer_acceleration = 500,500
; initial_layer_flow_ratio = 1
; initial_layer_infill_speed = 105,105
; initial_layer_jerk = 9
; initial_layer_line_width = 0.5
; initial_layer_print_height = 0.2
; initial_layer_speed = 50,50
; initial_layer_travel_acceleration = 6000,6000
; inner_wall_acceleration = 0,0
; inner_wall_jerk = 9
; inner_wall_line_width = 0.45
; inner_wall_speed = 300,300
; interface_shells = 0
; interlocking_beam = 0
; interlocking_beam_layer_count = 2
; interlocking_beam_width = 0.8
; interlocking_boundary_avoidance = 2
; interlocking_depth = 2
; interlocking_orientation = 22.5
; internal_bridge_support_thickness = 0.8
; internal_solid_infill_line_width = 0.42
; internal_solid_infill_pattern = zig-zag
; internal_solid_infill_speed = 250,250
; ironing_direction = 45
; ironing_fan_speed = -1
; ironing_flow = 10%
; ironing_inset = 0.21
; ironing_pattern = zig-zag
; ironing_spacing = 0.15
; ironing_speed = 30
; ironing_type = no ironing
; is_infill_first = 0
; layer_change_gcode = ;======== H2D 20250710 layer_change ========\n; layer num/total_layer_count: {layer_num+1}/[total_layer_count]\n; update layer progress\nM73 L{layer_num+1}\nM991 S0 P{layer_num} ;notify layer change\n
; layer_height = 0.2
; line_width = 0.42
; locked_skeleton_infill_pattern = zigzag
; locked_skin_infill_pattern = crosszag
; long_retractions_when_cut = 0,0
; long_retractions_when_ec = 1
; machine_bed_mass_Y = 0
; machine_end_gcode = ;========== H2D end ==========\n;===== date: 2026/07/29 =====\n\nM1003 S0\nM73 P100 R0\n\nG392 S0 ;turn off nozzle clog detect\nM993 A0 B0 C0 ; nozzle cam detection not allowed.\n\nM400 ; wait for buffer to clear\nG92 E0 ; zero the extruder\nM211 Z1\n\nG90\nG1 Z{max_layer_z + 0.4} F900 ; lower z a little\nM1002 judge_flag timelapse_record_flag\nM622 J1\n    G150.3\n    M400 ; wait all motion done\n    M991 S0 P-1 ;end smooth timelapse at safe pos\n    M400 S5 ;wait for last picture to be taken\nM623  ;end of \"timelapse_record_flag\"\n\nG90\nG1 Z{max_layer_z + 10} F900 ; lower z a little\n\nG90\nM141 S0 ; turn off chamber heating\nM140 S0 ; turn off bed\nM106 S0 ; turn off fan\nM106 P2 S0 ; turn off remote part cooling fan\nM106 P3 S0 ; turn off chamber cooling fan\nM106 P9 S0 ; turn off ext toodhead cooling fan\n; pull back filament to AMS\nM620 S65535\nT65535\nG150.2\nM621 S65535\n\nM620 S65279\nT65279\nG150.2\nM621 S65279\n\nG150.3\n\nM104 S0 T0; turn off hotend\nM104 S0 T1; turn off hotend\n\nM400 ; wait all motion done\nM17 S\nM17 Z0.4 ; lower z motor current to reduce impact if there is something in the bottom\n{if (100.0 - max_layer_z/2) > 0}\n    {if (max_layer_z + 100.0 - max_layer_z/2) < 320}\n        G1 Z{max_layer_z + 100.0 - max_layer_z/2} F600\n        G1 Z{max_layer_z + 98.0 - max_layer_z/2}\n    {else}\n        G1 Z320 F600\n        G1 Z320\n    {endif}\n{else}\n    {if (max_layer_z + 4.0) < 320}\n        G1 Z{max_layer_z + 4.0} F600\n        G1 Z{max_layer_z + 2.0}\n    {else}\n        G1 Z320 F600\n        G1 Z320\n    {endif}\n{endif}\nM400 P100\nM17 R ; restore z current\n\nM220 S100  ; Reset feedrate magnitude\nM201.2 K1.0 ; Reset acc magnitude\nM73.2   R1.0 ;Reset left time magnitude\nM1002 set_gcode_claim_speed_level : 0\n\nM1015.4 S0 K0 ;disable air printing detect\n\n;=====printer finish air purification=========\nM622.1 S0\nM1002 judge_flag print_finish_air_filt_flag\n\nM622 J1\nM1002 gcode_claim_action : 66\nM145 P1\nM106 P6 S255\nM400 S180\nM106 P6 S0\nM623\n\nM622 J2\nM1002 gcode_claim_action : 66\nM145 P0\nM106 P3 S127\nM400 S180\nM106 P3 S0\nM623\n;=====printer finish air purification=========\n\n\n;=====printer finish  sound=========\nM17\nM400 S1\nM1006 S1\nM1006 A53 B10 L99 C53 D10 M99 E53 F10 N99 \nM1006 A57 B10 L99 C57 D10 M99 E57 F10 N99 \nM1006 A0 B15 L0 C0 D15 M0 E0 F15 N0 \nM1006 A53 B10 L99 C53 D10 M99 E53 F10 N99 \nM1006 A57 B10 L99 C57 D10 M99 E57 F10 N99 \nM1006 A0 B15 L0 C0 D15 M0 E0 F15 N0 \nM1006 A48 B10 L99 C48 D10 M99 E48 F10 N99 \nM1006 A0 B15 L0 C0 D15 M0 E0 F15 N0 \nM1006 A60 B10 L99 C60 D10 M99 E60 F10 N99 \nM1006 W\n;=====printer finish  sound=========\nM400\nM18\n\n
; machine_hotend_change_time = 0
; machine_load_filament_time = 26
; machine_max_acceleration_e = 5000,5000,5000,5000
; machine_max_acceleration_extruding = 20000,20000,20000,20000
; machine_max_acceleration_retracting = 5000,5000,5000,5000
; machine_max_acceleration_travel = 9000,9000,9000,9000
; machine_max_acceleration_x = 20000,20000,20000,20000
; machine_max_acceleration_y = 20000,20000,20000,20000
; machine_max_acceleration_z = 500,500,500,500
; machine_max_force_Y = 0
; machine_max_jerk_e = 2.5,2.5,2.5,2.5
; machine_max_jerk_x = 9,9,9,9
; machine_max_jerk_y = 9,9,9,9
; machine_max_jerk_z = 3,3,3,3
; machine_max_printed_mass = 0
; machine_max_speed_e = 50,50,50,50
; machine_max_speed_x = 1000,1000,1000,1000
; machine_max_speed_y = 1000,1000,1000,1000
; machine_max_speed_z = 30,30,30,30
; machine_min_extruding_rate = 0,0
; machine_min_travel_rate = 0,0
; machine_pause_gcode = M400 U1
; machine_prepare_compensation_time = 260
; machine_start_gcode = ;===== machine: H2D =========================\n;===== date: 20260605 =====================\n\n;M1002 set_flag extrude_cali_flag=1\n;M1002 set_flag g29_before_print_flag=1\n;M1002 set_flag auto_cali_toolhead_offset_flag=1\n;M1002 set_flag build_plate_detect_flag=1\n\nM993 A0 B0 C0 ; nozzle cam detection not allowed.\n\nM400\n;M73 P99\n\nM960 S10 P1 ; ext fan led\n\n;=====printer start sound ===================\nM17\nM400 S1\nM1006 S1\nM1006 A53 B9 L99 C53 D9 M99 E53 F9 N99\nM1006 A56 B9 L99 C56 D9 M99 E56 F9 N99\nM1006 A61 B9 L99 C61 D9 M99 E61 F9 N99\nM1006 A53 B9 L99 C53 D9 M99 E53 F9 N99\nM1006 A56 B9 L99 C56 D9 M99 E56 F9 N99\nM1006 A61 B18 L99 C61 D18 M99 E61 F18 N99\nM1006 W\n;=====printer start sound ===================\n\n;===== reset machine status =================\nM204 S10000\nM630 S0 P0\n\nG90\nM17 D ; reset motor current to default\nM960 S5 P1 ; turn on logo lamp\nG90\nM1002 set_gcode_claim_speed_level 5 ;Reset speed level\nM220 S100 ;Reset Feedrate\nM221 S100 ;Reset Flowrate\nM73.2   R1.0 ;Reset left time magnitude\nG29.1 Z{+0.0} ; clear z-trim value first\nM983.1 M1\nM901 D4\nM481 S0 ; turn off cutter pos comp\nG28.140 D0; reset pre-extrude z pos\n;===== reset machine status =================\n\nM620 M ;enable remap\n\n;===== avoid end stop =================\nG91\nG380 S2 Z42 F1200\nG380 S2 Z-12 F1200\nG90\n;===== avoid end stop =================\n\n;==== set airduct mode ====\n\n{if (overall_chamber_temperature >= 40)}\n\n    M145 P1 ; set airduct mode to heating mode for heating\n    M106 P2 S0 ; turn off auxiliary fan\n    M106 P3 S0 ; turn off chamber fan\n\n{else}\n    M145 P0 ; set airduct mode to cooling mode for cooling\n    M106 P2 S178 ; turn on auxiliary fan for cooling\n    M106 P3 S127 ; turn on chamber fan for cooling\n    M140 S0 ; stop heatbed from heating\n\n    M1002 gcode_claim_action : 29\n    M191 S0 ; wait for chamber temp\n    M106 P2 S0 ; turn off auxiliary fan\n    {if (min_vitrification_temperature <= 50)}\n        {if (nozzle_diameter_at_nozzle_id[initial_nozzle_id] == 0.2)}\n            M142 P1 R30 S35 T40 U0.3 V0.5 W0.8 O40 ; set PLA/TPU ND0.2 chamber autocooling\n        {else}\n            M142 P1 R30 S40 T45 U0.3 V0.5 W0.8 O45; set PLA/TPU ND0.4 chamber autocooling\n        {endif}\n    {else}\n        {if (!is_all_bbl_filament)}\n            M142 P1 R35 S40 T45 U0.3 V0.5 W0.8 O45 L1 ; set third-party PETG chamber autocooling\n        {else}\n            {if (nozzle_diameter_at_nozzle_id[initial_nozzle_id] == 0.2)}\n                M142 P1 R35 S45 T50 U0.3 V0.5 W0.8 O50 L1 ; set PETG ND0.2 chamber autocooling\n            {else}\n                M142 P1 R35 S50 T55 U0.3 V0.5 W0.8 O55 L1 ; set PETG ND0.4 chamber autocooling\n            {endif}\n        {endif}\n    {endif}\n    {if(cooling_filter_enabled)}\n        M145.2 P0 F0\n    {else}\n        M145.2 P0 F1\n    {endif}\n{endif}\n\n;==== set airduct mode ====\n\n;===== start to heat heatbed & hotend==========\n\n    M1002 set_filament_type:{filament_type[initial_no_support_filament_id]}\n\n    M104 S140 A\n    M140 S[bed_temperature_initial_layer_single]\n\n    ;===== set chamber temperature ==========\n    {if (overall_chamber_temperature >= 40)}\n        M145 P1 ; set airduct mode to heating mode\n        M141 S[overall_chamber_temperature] ; Let Chamber begin to heat\n    {endif}\n    ;===== set chamber temperature ==========\n\n;===== start to heat heatbead & hotend==========\n\n;====== cog noise reduction=================\nM982.2 S1 ; turn on cog noise reduction\n\n;===== first homing start =====\nM1002 gcode_claim_action : 13\n\nG28 X T300\n\nG150.1 F18000 ; wipe mouth to avoid filament stick to heatbed\nG150.3 F18000\nM400 P200\nM972 S24 P0 T2000\n\nM1002 gcode_claim_action : 74 ; Heatbed surface foreign object detection\n{if curr_bed_type==\"Textured PEI Plate\"}\nM972 S26 P0 C0\n{else}\nM972 S36 P0 C0 X1\n{endif}\nM972 S35 P0 C0\n\nM972 S41 P0 T5000 ; trash can anti-collision\n\nM1009 Q1 L1\nG91\nG380 S2 Z30 F1200 ; lower heatbed to move toolhead\nG90\nG1 X175 Y160 F30000\nG28 Z P0 T250\nM1009 Q1 L0\n\n;===== first homing end =====\n\nM400\n;M73 P99\n\n;===== detection start =====\n\nM1002 judge_flag build_plate_detect_flag\nM622 S1\n    ;M1002 gcode_claim_action : 11 ; Indentifying build plate type\n    M972 S19 P0 C0    ; heatbed presence detection\n    M972 S31 P0 T5000 ; toolhead camera dirty detection\n    ;M1002 gcode_claim_action : 73 ; Build plate alignment detection\n    M972 S34 P0 T5000 ; heatbed plate offset detection\nM623\n\nM1002 gcode_claim_action : 72 ; Hotend Type Detection\nT1001\nM972 S14 P0 T5000 ; nozzle type detection\n\nM104 S{nozzle_temperature_initial_layer[initial_no_support_filament_id]} T{filament_map[initial_no_support_filament_id] % 2} ; rise temp in advance\n\nG151 P{filament_map[initial_no_support_filament_id] % 2} M ; plug the heat nozzle\n\n{if max_print_z >= 145}\nM1002 gcode_claim_action : 75 ; Heatbed underside foreign object detection\nG3811 Z{max_print_z}  ; Detect obstacles at the bottom of the heated bed\n{endif}\n\n;===== detection end =====\n\nM400\n;M73 P99\n\n;===== prepare print temperature and material ==========\nM400\nM211 X0 Y0 Z0 ;turn off soft endstop\nM975 S1 ; turn on input shaping\n\nG29.2 S0 ; avoid invalid abl data\n\n{if ((filament_type[initial_no_support_filament_id] == \"PLA\") || (filament_type[initial_no_support_filament_id] == \"PLA-CF\") || (filament_type[initial_no_support_filament_id] == \"PETG\")) && (nozzle_diameter_at_nozzle_id[initial_nozzle_id] == 0.2)}\nM620.10 A0 F74.8347 H{nozzle_diameter_at_nozzle_id[initial_nozzle_id]} T{flush_temperatures[initial_no_support_filament_id]} P{nozzle_temperature_initial_layer[initial_no_support_filament_id]} S1\nM620.10 A1 F74.8347 H{nozzle_diameter_at_nozzle_id[initial_nozzle_id]} T{flush_temperatures[initial_no_support_filament_id]} P{nozzle_temperature_initial_layer[initial_no_support_filament_id]} S1\n{else}\nM620.10 A0 F{flush_volumetric_speeds[initial_no_support_filament_id]/2.4053*60*0.8} H{nozzle_diameter_at_nozzle_id[initial_nozzle_id]} T{flush_temperatures[initial_no_support_filament_id]} P{nozzle_temperature_initial_layer[initial_no_support_filament_id]} S1\nM620.10 A1 F{flush_volumetric_speeds[initial_no_support_filament_id]/2.4053*60*0.8} H{nozzle_diameter_at_nozzle_id[initial_nozzle_id]} T{flush_temperatures[initial_no_support_filament_id]} P{nozzle_temperature_initial_layer[initial_no_support_filament_id]} S1\n{endif}\n\nM620.11 P0 I[initial_no_support_filament_id] B[initial_no_support_hotend] E0\n\n{if long_retraction_when_ec }\nM620.11 K1 I[initial_no_support_filament_id] B[initial_no_support_hotend] R{retraction_distance_when_ec} F{max((flush_volumetric_speeds[initial_no_support_filament_id]/2.4053*60), 200)}\n{else}\nM620.11 K0 I[initial_no_support_filament_id] B[initial_no_support_hotend] R0\n{endif}\n\nM628 S1\n{if filament_type[initial_no_support_filament_id] == \"TPU\"}\n    M620.11 S0 L0 I[initial_no_support_filament_id] B[initial_no_support_hotend] E-{retraction_distances_when_cut[initial_no_support_filament_id]} F{flush_volumetric_speeds[initial_no_support_filament_id]/2.4053*60}\n{else}\n{if (filament_type[initial_no_support_filament_id] == \"PA\") ||  (filament_type[initial_no_support_filament_id] == \"PA-GF\")}\n    M620.11 S1 L0 I[initial_no_support_filament_id] B[initial_no_support_hotend] R4 D2 E-{retraction_distances_when_cut[initial_no_support_filament_id]} F{flush_volumetric_speeds[initial_no_support_filament_id]/2.4053*60}\n{else}\n    M620.11 S1 L0 I[initial_no_support_filament_id] B[initial_no_support_hotend] R10 D8 E-{retraction_distances_when_cut[initial_no_support_filament_id]} F{flush_volumetric_speeds[initial_no_support_filament_id]/2.4053*60}\n{endif}\n{endif}\nM629\n\nM620 S[initial_no_support_filament_id]A H[initial_no_support_hotend] ; switch material if AMS exist\nM1002 gcode_claim_action : 4\nM1002 set_filament_type:UNKNOWN\nM400\nT[initial_no_support_filament_id] H[initial_no_support_hotend]\nM400\nM628 S0\nM629\nM400\nM1002 set_filament_type:{filament_type[initial_no_support_filament_id]}\nM621 S[initial_no_support_filament_id]A\n\nM104 S{nozzle_temperature_initial_layer[initial_no_support_filament_id]}\nM400\nM106 P1 S0\n\nG29.2 S1\n;===== prepare print temperature and material ==========\n\nM400\n;M73 P99\n\n;===== auto extrude cali start =========================\nM975 S1\nM1002 judge_flag extrude_cali_flag\n\nM622 J0\n    M983.3 F{filament_max_volumetric_speed[initial_no_support_filament_id]/2.4} A0.4 ; cali dynamic extrusion compensation\nM623\n\nM622 J1\n    M1002 set_filament_type:{filament_type[initial_no_support_filament_id]}\n    M1002 gcode_claim_action : 8\n\n    M109 S{nozzle_temperature[initial_no_support_filament_id]}\n\n    G90\n    M83\n    M983.3 F{filament_max_volumetric_speed[initial_no_support_filament_id]/2.4} A0.4 ; cali dynamic extrusion compensation\n\n    M400\n    M106 P1 S255\n    M400 S5\n    M106 P1 S0\n    G150.3\nM623\n\nM622 J2\n    M1002 set_filament_type:{filament_type[initial_no_support_filament_id]}\n    M1002 gcode_claim_action : 8\n\n    M109 S{nozzle_temperature[initial_no_support_filament_id]}\n\n    G90\n    M83\n    M983.3 F{filament_max_volumetric_speed[initial_no_support_filament_id]/2.4} A0.4 ; cali dynamic extrusion compensation\n\n    M400\n    M106 P1 S255\n    M400 S5\n    M106 P1 S0\n    G150.3\nM623\n\n;===== auto extrude cali end =========================\n\n{if filament_type[initial_no_support_filament_id] == \"TPU\"}\n    G150.2\n    G150.1\n    G150.2\n    G150.1\n    G150.2\n    G150.1\n{else}\n    M106 P1 S0\n    M400 S2\n    M109 S{nozzle_temperature[initial_no_support_filament_id]} ; wait tmpr to extrude\n    M83\n    {if(nozzle_diameter_at_nozzle_id[initial_nozzle_id] == 0.8)}\n        G1 E60 F{filament_max_volumetric_speed[initial_no_support_filament_id]/2.4053*60}\n    {else}\n        G1 E45 F{filament_max_volumetric_speed[initial_no_support_filament_id]/2.4053*60}\n    {endif}\n    G1 E-3 F1800\n    M400 P500\n    G150.2\n    G150.1\n{endif}\n\nG91\nG1 Y-16 F12000 ; move away from the trash bin\nG90\n\nM400\n;M73 P99\n\n;===== wipe right nozzle start =====\n\nM1002 gcode_claim_action : 14\n    G150 T{nozzle_temperature_initial_layer[initial_no_support_filament_id]}\n    {if (overall_chamber_temperature >= 40)}\n        G150 T{nozzle_temperature_initial_layer[initial_no_support_filament_id] - 80}\n    {endif}\nM106 S255 ; turn on fan to cool the nozzle\n\n;===== wipe left nozzle end =====\n\nM400\n;M73 P99\n\n{if (overall_chamber_temperature >= 40)}\n    M1002 gcode_claim_action : 49\n    M191 S[overall_chamber_temperature] ; wait for chamber temp\n{endif}\n\nM400\n;M73 P99\n\n;===== bed leveling ==================================\n\nM1002 judge_flag g29_before_print_flag\n\nM190 S[bed_temperature_initial_layer_single]; ensure bed temp\nM109 S140 A\nM106 S0 ; turn off fan , too noisy\n\nG91\nG1 Z5 F1200\nG90\nG1 X175 Y160 F30000\n\nM622 J1\n    M1002 gcode_claim_action : 1\n    G29.20 A3\n    G29 A1 O X{first_layer_print_min[0]} Y{first_layer_print_min[1]} I{first_layer_print_size[0]} J{first_layer_print_size[1]} R\n    M400\nM623\n\nM622 J2\n    M1002 gcode_claim_action : 1\n    {if has_tpu_in_first_layer}\n        G29.20 A3\n        G29 A1 O X{first_layer_print_min[0]} Y{first_layer_print_min[1]} I{first_layer_print_size[0]} J{first_layer_print_size[1]} R\n    {else}\n        G29.20 A4\n        G29 A2 O X{first_layer_print_min[0]} Y{first_layer_print_min[1]} I{first_layer_print_size[0]} J{first_layer_print_size[1]} R\n    {endif}\n    M400\nM623\n\nM622 J0\n    G28 R\nM623\n\n;===== bed leveling end ================================\n\n;===== z ofst cali start =====\n\n    M190 S[bed_temperature_initial_layer_single]; ensure bed temp\n\n    G383 O0 M2 T140\n\n;===== z ofst cali end =====\n\nG39.1 ; cali nozzle wrapped detection pos\n\nG90\nG1 Z5 F1200\nG1 X270 Y-0.5 F60000\nG28.140 S0 ; cali pre-extrude z pos\n\nM141 S[overall_chamber_temperature]\nM104 S{nozzle_temperature_initial_layer[initial_no_support_filament_id]} A\n\n;===== mech mode sweep start =====\n    M1002 gcode_claim_action : 3\n\n    G90\n    G1 Z5 F1200\n    G1 X187 Y160 F20000\n    T1000\n    M400 P200\n\n    M970.3 Q1 A5 K0 O1\n    M974 Q1 S2 P0\n\n    M970.3 Q0 A5 K0 O1\n    M974 Q0 S2 P0\n\n    M970.2 Q2 K0 W38 Z0.01\n    M974 Q2 S2 P0\n\n    M975 S1\n;===== mech mode sweep end =====\n\nM400\n;M73 P99\n\nG150.3 ; move to garbage can to wait for temp\nM1026\nG29.9\n\n;===== xy ofst cali start =====\n\nM1002 judge_flag auto_cali_toolhead_offset_flag\n\nM622 J0\n    M1012.5 N1 R1\nM623\n\nM622 J1\n    M1002 gcode_claim_action : 39\n    M141 S0\n    M620.17 T0 S{nozzle_temperature_initial_layer[(first_non_support_filaments[0] != -1 ? first_non_support_filaments[0] : (first_filaments[0] != -1 ? first_filaments[0] : 0))]} L{(first_non_support_filaments[0] != -1 ? first_non_support_filaments[0] : (first_filaments[0] != -1 ? first_filaments[0] : 0))}\n    M620.17 T1 S{nozzle_temperature_initial_layer[(first_non_support_filaments[1] != -1 ? first_non_support_filaments[1] : (first_filaments[1] != -1 ? first_filaments[1] : 0))]} L{(first_non_support_filaments[1] != -1 ? first_non_support_filaments[1] : (first_filaments[1] != -1 ? first_filaments[1] : 0))}\n    M620 D[initial_no_support_hotend]\n    G383 O1 T{nozzle_temperature_initial_layer[initial_no_support_filament_id]} L{initial_no_support_filament_id}\n    M141 S[overall_chamber_temperature]\nM623\n\nM622 J2\n    M1002 gcode_claim_action : 39\n    M141 S0\n    M620.17 T0 S{nozzle_temperature_initial_layer[(first_non_support_filaments[0] != -1 ? first_non_support_filaments[0] : (first_filaments[0] != -1 ? first_filaments[0] : 0))]} L{(first_non_support_filaments[0] != -1 ? first_non_support_filaments[0] : (first_filaments[0] != -1 ? first_filaments[0] : 0))}\n    M620.17 T1 S{nozzle_temperature_initial_layer[(first_non_support_filaments[1] != -1 ? first_non_support_filaments[1] : (first_filaments[1] != -1 ? first_filaments[1] : 0))]} L{(first_non_support_filaments[1] != -1 ? first_non_support_filaments[1] : (first_filaments[1] != -1 ? first_filaments[1] : 0))}\n    M620 D[initial_no_support_hotend]\n    G383.3 T{nozzle_temperature_initial_layer[initial_no_support_filament_id]} L{initial_no_support_filament_id}\n    M141 S[overall_chamber_temperature]\nM623\n;===== xy ofst cali end =====\n\nM400\n;M73 P99\n\nM1002 gcode_claim_action : 0\nM400\n\n;============switch again==================\nM211 X0 Y0 Z0 ;turn off soft endstop\nG91\nG1 Z6 F1200\nG90\nM1002 set_filament_type:{filament_type[initial_no_support_filament_id]}\nM620 S[initial_no_support_filament_id]A H[initial_no_support_hotend]\nM400\nT[initial_no_support_filament_id] H[initial_no_support_hotend]\nM400\nM628 S0\nM629\nM400\nM621 S[initial_no_support_filament_id]A\n\n;============switch again==================\n\nM400\n;M73 P99\n\n;===== wait temperature reaching the reference value =======\n\nM104 S{nozzle_temperature_initial_layer[initial_no_support_filament_id]} ; rise to print tmpr\n\nM140 S[bed_temperature_initial_layer_single]\nM190 S[bed_temperature_initial_layer_single]\n\n    ;========turn off light and fans =============\n    M960 S1 P0 ; turn off laser\n    M960 S2 P0 ; turn off laser\n    M106 S0 ; turn off fan\n    M106 P2 S0 ; turn off big fan\n    ;==== set ext toodhead cooling fan ====\n    {if (min_vitrification_temperature <= 50)}\n    M106 P9 S255\n    {endif}\n    ;============set motor current==================\n    M400 S1\n\n;===== wait temperature reaching the reference value =======\n\nM400\n;M73 P99\n\n;===== for Textured PEI Plate , lower the nozzle as the nozzle was touching topmost of the texture when homing ==\n    {if curr_bed_type==\"Textured PEI Plate\"}\n        {if nozzle_diameter_at_nozzle_id[initial_nozzle_id] == 0.2}\n            G29.1 Z{-0.01} ; for Textured PEI Plate\n        {else}\n            G29.1 Z{-0.02} ; for Textured PEI Plate\n        {endif}\n    {else}\n        {if nozzle_diameter_at_nozzle_id[initial_nozzle_id] == 0.2}\n            G29.1 Z{0.01}\n        {endif}\n    {endif}\n\nG150.1\n\nM975 S1 ; turn on mech mode supression\nM983.4 S1 ; turn on deformation compensation\nG29.2 S1 ; turn on pos comp\nG29.7 S1\n\nG90\nG1 Z5 F1200\nG1 Y295 F30000\nG1 Y265 F18000\n\n;===== nozzle load line ===============================\n    G29.2 S1 ; ensure z comp turn on\n    G90\n    M83\n    G1 Z5 F1200\n    G1 X270 Y-0.5 F60000\n    G28.14 R0\n    G29.2 S0\n    G91\n    G1 Z0.8 F1200\n    G90\n    G1 X250 F60000\n    M400 P50\n    M500 D1\n    M400 S3\n    M109 S{nozzle_temperature_initial_layer[initial_no_support_filament_id]}\n    M83\n{if nozzle_diameter_at_nozzle_id[initial_nozzle_id] == 0.8}\n    G1 E5 F{filament_max_volumetric_speed[initial_no_support_filament_id]/2.4053*60}\n{endif}\n{if (filament_type[initial_no_support_filament_id] == \"TPU\")}\n    G1 E5 F{filament_max_volumetric_speed[initial_no_support_filament_id]/2.4053*60}\n{endif}\n    G1 E5 F{filament_max_volumetric_speed[initial_no_support_filament_id]/2.4053*60}\n    G1 X290 E10 F{filament_max_volumetric_speed[initial_no_support_filament_id]/2.4053*60}\n    G91\n    G3 Z0.4 I1.217 J0 P1 F60000\n    G90\n    M83\n    G29.2 S1 ; ensure z comp turn on\n;===== noozle load line end ===========================\n\nM400\n;M73 P99\n\nM993 A1 B1 C1 ; nozzle cam detection allowed.\n\n{if (filament_type[initial_no_support_filament_id] == \"TPU\")}\nM1015.3 S1;enable tpu clog detect\n{else}\nM1015.3 S0;disable tpu clog detect\n{endif}\n\n{if (filament_type[initial_no_support_filament_id] == \"PLA\") ||  (filament_type[initial_no_support_filament_id] == \"PETG\")\n ||  (filament_type[initial_no_support_filament_id] == \"PLA-CF\")  ||  (filament_type[initial_no_support_filament_id] == \"PETG-CF\")}\nM1015.4 S1 K1 H{nozzle_diameter_at_nozzle_id[initial_nozzle_id]} ;enable E air printing detect\n{else}\nM1015.4 S0 K0 H{nozzle_diameter_at_nozzle_id[initial_nozzle_id]} ;disable E air printing detect\n{endif}\n\nM620.6 I[initial_no_support_filament_id] H[initial_no_support_hotend] W1 ;enable ams air printing detect\nM620 Q1\n\nM211 Z1\nG29.99\n
; machine_switch_extruder_time = 5.6
; machine_unload_filament_time = 26
; master_extruder_id = 2
; max_bridge_length = 0
; max_layer_height = 0.28,0.28
; max_travel_detour_distance = 0
; min_bead_width = 85%
; min_feature_size = 25%
; min_layer_height = 0.08,0.08
; minimum_sparse_infill_area = 15
; mmu_segmented_region_interlocking_depth = 0
; mmu_segmented_region_max_width = 0
; monotonic_travel_into_wall = 45%
; no_slow_down_for_cooling_on_outwalls = 0
; nozzle_diameter = 0.4,0.4
; nozzle_flush_dataset = 1,1
; nozzle_height = 4
; nozzle_temperature = 220
; nozzle_temperature_initial_layer = 220
; nozzle_temperature_range_high = 240
; nozzle_temperature_range_low = 190
; nozzle_type = hardened_steel,hardened_steel
; nozzle_volume = 130,145
; nozzle_volume_type = Standard,Standard
; only_one_wall_first_layer = 0
; ooze_prevention = 0
; other_layers_print_sequence = 0
; other_layers_print_sequence_nums = 0
; outer_wall_acceleration = 5000,5000
; outer_wall_jerk = 9
; outer_wall_line_width = 0.42
; outer_wall_speed = 200,200
; overhang_1_4_speed = 0,0
; overhang_2_4_speed = 50,50
; overhang_3_4_speed = 30,30
; overhang_4_4_speed = 10,10
; overhang_fan_speed = 100
; overhang_fan_threshold = 50%
; overhang_threshold_participating_cooling = 95%
; overhang_totally_speed = 10,10
; override_filament_scarf_seam_setting = 0
; override_process_overhang_speed = 0
; physical_extruder_map = 1,0
; post_process = 
; pre_start_fan_time = 0
; precise_outer_wall = 0
; precise_z_height = 0
; pressure_advance = 0.02
; prime_tower_brim_width = -1
; prime_tower_enable_framework = 0
; prime_tower_extra_rib_length = 0
; prime_tower_fillet_wall = 1
; prime_tower_flat_ironing = 1
; prime_tower_infill_gap = 150%
; prime_tower_lift_height = -1
; prime_tower_lift_speed = 90
; prime_tower_max_speed = 90
; prime_tower_rib_wall = 1
; prime_tower_rib_width = 8
; prime_tower_skip_points = 1
; prime_tower_width = 60
; prime_volume_mode = Default
; print_compatible_printers = "Bambu Lab H2D 0.4 nozzle"
; print_extruder_id = 1,2
; print_extruder_variant = "Direct Drive Standard";"Direct Drive Standard"
; print_flow_ratio = 1
; print_in_clockwise = 0
; print_sequence = by layer
; print_settings_id = Trimix A3 0.20 accessible_supports @BBL H2D
; printable_area = 0x0,350x0,350x320,0x320
; printable_height = 325
; printer_extruder_id = 1,2
; printer_extruder_variant = "Direct Drive Standard";"Direct Drive Standard"
; printer_model = Bambu Lab H2D
; printer_notes = 
; printer_settings_id = Bambu Lab H2D 0.4 nozzle
; printer_structure = corexy
; printer_technology = FFF
; printer_variant = 0.4
; printing_by_object_gcode = 
; process_notes = 
; raft_contact_distance = 0.1
; raft_expansion = 1.5
; raft_first_layer_density = 90%
; raft_first_layer_expansion = -1
; raft_layers = 0
; reduce_crossing_wall = 0
; reduce_fan_stop_start_freq = 1
; reduce_infill_retraction_mode = Auto
; required_nozzle_HRC = 3
; resolution = 0.012
; retract_before_wipe = 0%,0%
; retract_length_toolchange = 2,2
; retract_lift_above = 0,0
; retract_lift_below = 319,319
; retract_restart_extra = 0,0
; retract_restart_extra_toolchange = 0,0
; retract_when_changing_layer = 1,1
; retraction_distances_when_cut = 10,10
; retraction_distances_when_ec = 10
; retraction_length = 0.8,0.8
; retraction_minimum_travel = 1,1
; retraction_speed = 30,30
; role_base_wipe_speed = 1
; scan_first_layer = 0
; scarf_angle_threshold = 155
; seam_gap = 15%
; seam_placement_away_from_overhangs = 0
; seam_position = aligned
; seam_slope_conditional = 1
; seam_slope_entire_loop = 0
; seam_slope_gap = 0
; seam_slope_inner_walls = 1
; seam_slope_min_length = 10
; seam_slope_start_height = 10%
; seam_slope_steps = 10
; seam_slope_type = none
; silent_mode = 0
; single_extruder_multi_material = 1
; skeleton_infill_density = 15%
; skeleton_infill_line_width = 0.45
; skin_infill_density = 15%
; skin_infill_depth = 2
; skin_infill_line_width = 0.45
; skirt_distance = 2
; skirt_height = 1
; skirt_loops = 0
; skirt_per_object = 1
; slice_closing_radius = 0.049
; slicing_mode = regular
; slow_down_for_layer_cooling = 1
; slow_down_layer_time = 8
; slow_down_min_speed = 20
; slowdown_end_acc = 100000,100000
; slowdown_end_height = 400,400
; slowdown_end_speed = 1000,1000
; slowdown_start_acc = 100000,100000
; slowdown_start_height = 0,0
; slowdown_start_speed = 1000,1000
; small_perimeter_speed = 50%,50%
; small_perimeter_threshold = 0,0
; smooth_coefficient = 4
; smooth_speed_discontinuity_area = 1
; solid_infill_filament = 0
; sparse_infill_acceleration = 100%,100%
; sparse_infill_anchor = 400%
; sparse_infill_anchor_max = 20
; sparse_infill_density = 20%
; sparse_infill_filament = 0
; sparse_infill_lattice_angle_1 = -45
; sparse_infill_lattice_angle_2 = 45
; sparse_infill_line_width = 0.45
; sparse_infill_pattern = gyroid
; sparse_infill_speed = 350,350
; spiral_mode = 0
; spiral_mode_max_xy_smoothing = 200%
; spiral_mode_smooth = 0
; standby_temperature_delta = -5
; start_end_points = 30x-3,54x245
; supertack_plate_temp = 45
; supertack_plate_temp_initial_layer = 45
; support_air_filtration = 0
; support_angle = 0
; support_base_pattern = default
; support_base_pattern_spacing = 2.5
; support_bottom_interface_spacing = 0.5
; support_bottom_z_distance = 0.2
; support_chamber_temp_control = 1
; support_cooling_filter = 1
; support_critical_regions_only = 0
; support_expansion = 0
; support_fast_purge_mode = 0
; support_filament = 0
; support_interface_bottom_layers = 2
; support_interface_filament = 0
; support_interface_loop_pattern = 0
; support_interface_not_for_body = 1
; support_interface_pattern = auto
; support_interface_spacing = 0.5
; support_interface_speed = 80,80
; support_interface_top_layers = 3
; support_ironing_direction = 0
; support_ironing_flow = 10%
; support_ironing_inset = 0
; support_ironing_pattern = zig-zag
; support_ironing_spacing = 0.15
; support_ironing_speed = 30
; support_line_width = 0.42
; support_object_first_layer_gap = 0.2
; support_object_skip_flush = 0
; support_object_xy_distance = 0.35
; support_on_build_plate_only = 0
; support_remove_small_overhang = 1
; support_speed = 150,150
; support_style = snug
; support_threshold_angle = 30
; support_top_z_distance = 0.2
; support_type = normal(auto)
; symmetric_infill_y_axis = 0
; temperature_vitrification = 45
; template_custom_gcode = 
; textured_plate_temp = 55
; textured_plate_temp_initial_layer = 55
; thick_bridges = 0
; thumbnail_size = 50x50
; time_lapse_gcode = ;======== H2D 20260731========\n; SKIPPABLE_START\n; SKIPTYPE: timelapse\nM622.1 S1 ; for prev firmware, default turned on\n\nM1002 judge_flag timelapse_record_flag\nM622 J1\n    {if !spiral_mode && !timelapse_inline_photo}\n        M993 A2 B2 C2\n        M993 A0 B0 C0\n    {endif}\n\n    {if timelapse_inline_photo}\n        M971 S11 C10 O0\n        M1004 S5 P1  ; external shutter\n    {else}\n        M622.1 S0 ; for prev firmware, default turn off\n        M1002 set_flag smooth_safe_pos_suppoprt_flag=1\n        M1002 judge_flag smooth_safe_pos_suppoprt_flag\n        \n        M622 J0\n            {if !spiral_mode && !(has_timelapse_safe_pos && timelapse_type == 0) }\n                {if most_used_physical_extruder_id!= curr_physical_extruder_id || timelapse_type == 1}\n                    M83\n                    G1 Z{max_layer_z + 0.4} F1200\n                    M400\n                {endif}\n            {endif}\n\n            {if has_timelapse_safe_pos && timelapse_type == 0 && !spiral_mode}\n                M9711 M{timelapse_type} E{most_used_physical_extruder_id} X{timelapse_pos_x} Y{timelapse_pos_y} Z{layer_z + (farthest_point_timelapse_enabled ? 0.0 : 0.4)} S11 C10 O0 T3000\n            {else}\n                {if spiral_mode}\n                    M971 S11 C10 O0\n                    M1004 S5 P1  ; external shutter\n                {else}\n                    M9711 M{timelapse_type} E{most_used_physical_extruder_id} Z{layer_z + (farthest_point_timelapse_enabled ? 0.0 : 0.4)} S11 C10 O0 T3000\n                {endif}\n            {endif}\n\n            {if !spiral_mode && !(has_timelapse_safe_pos && timelapse_type == 0) }\n                {if most_used_physical_extruder_id!= curr_physical_extruder_id || timelapse_type == 1}\n                    G90\n                    G1 Z{max_layer_z + 3.0} F1200\n                    G1 Y295 F30000\n                    G1 Y265 F18000\n                    M83\n                {endif}\n            {endif}\n        M623\n\n        M622 J1\n            {if !spiral_mode && !(has_timelapse_safe_pos) }\n                {if most_used_physical_extruder_id!= curr_physical_extruder_id || timelapse_type == 1}\n                    M83\n                    G1 Z{max_layer_z + 0.4} F1200\n                    M400\n                {endif}\n            {endif}\n\n            {if has_timelapse_safe_pos && !spiral_mode}\n                M9711 M{timelapse_type} E{most_used_physical_extruder_id} U{timelapse_pos_x} V{timelapse_pos_y} Z{layer_z + (farthest_point_timelapse_enabled ? 0.0 : 0.4)} S11 C10 O0 T3000\n            {else}\n                {if spiral_mode}\n                    M971 S11 C10 O0\n                    M1004 S5 P1  ; external shutter\n                {else}\n                    M9711 M{timelapse_type} E{most_used_physical_extruder_id} Z{layer_z + (farthest_point_timelapse_enabled ? 0.0 : 0.4)} S11 C10 O0 T3000\n                {endif}\n            {endif}\n\n            {if !spiral_mode && !(has_timelapse_safe_pos) }\n                {if most_used_physical_extruder_id!= curr_physical_extruder_id || timelapse_type == 1}\n                    G90\n                    G1 Z{max_layer_z + 3.0} F1200\n                    G1 Y295 F30000\n                    G1 Y265 F18000\n                    M83\n                {endif}\n            {endif}\n        M623\n    {endif}\n    \n    {if !spiral_mode && !timelapse_inline_photo}\n        M993 A3 B3 C3\n    {endif}\nM623\n; SKIPPABLE_END\n
; timelapse_type = 0
; top_area_threshold = 200%
; top_color_penetration_layers = 5
; top_one_wall_type = all top
; top_shell_layers = 5
; top_shell_thickness = 1
; top_solid_infill_flow_ratio = 1,1
; top_surface_acceleration = 2000,2000
; top_surface_density = 100%
; top_surface_jerk = 9
; top_surface_line_width = 0.42
; top_surface_pattern = monotonicline
; top_surface_speed = 200,200
; top_z_overrides_xy_distance = 0
; travel_acceleration = 10000,10000
; travel_jerk = 9
; travel_short_distance_acceleration = 250,250
; travel_speed = 1000,1000
; travel_speed_z = 0,0
; tree_support_branch_angle = 45
; tree_support_branch_diameter = 2
; tree_support_branch_diameter_angle = 5
; tree_support_branch_distance = 5
; tree_support_wall_count = -1
; upward_compatible_machine = "Bambu Lab H2D Pro 0.4 nozzle"
; use_firmware_retraction = 0
; use_relative_e_distances = 1
; vertical_shell_speed = 80%,80%
; volumetric_speed_coefficients = "0 0 0 0 0 0"
; wall_distribution_count = 1
; wall_filament = 0
; wall_generator = classic
; wall_loops = 4
; wall_sequence = inner wall/outer wall
; wall_transition_angle = 10
; wall_transition_filter_deviation = 25%
; wall_transition_length = 100%
; wipe = 1,1
; wipe_distance = 2,2
; wipe_speed = 80%
; wipe_tower_no_sparse_layers = 0
; wipe_tower_rotation_angle = 0
; wipe_tower_x = 15
; wipe_tower_y = 220
; wrapping_detection_gcode = ;======== H2D 20250729 clumping ========\n{if !spiral_mode}\n    M622.1 S0 ; for previous firmware, default turn off\n    M1002 set_flag g39_forced_detection_flag=1\n    M1002 judge_flag g39_forced_detection_flag\n    M622 J1\n        {if layer_num == 3 || layer_num == 10 || layer_num == 19}\n            M993 A2 B2 C2 ; nozzle cam detection allow status save.\n            M993 A0 B0 C0 ; nozzle cam detection not allowed.\n\n            M400 P100\n\n            G39\n\n            G90\n            G1 Y295 F30000\n            G1 Y265 F18000\n            \n            M993 A3 B3 C3 ; nozzle cam detection allow status restore.\n        {endif}\n    M623\n{endif}\n
; wrapping_detection_layers = 20
; wrapping_exclude_area = 145x310,256x310,256x326,145x326
; xy_contour_compensation = 0
; xy_hole_compensation = 0
; z_direction_outwall_speed_continuous = 1
; z_hop = 0.4,0.4
; z_hop_types = Auto Lift,Auto Lift
; CONFIG_BLOCK_END

; EXECUTABLE_BLOCK_START
M73 P0 R16
M201 X20000 Y20000 Z500 E5000
M203 X1000 Y1000 Z30 E50
M204 P20000 R5000 T20000
M205 X9.00 Y9.00 Z3.00 E2.50
M106 S0
M106 P2 S0
; FEATURE: Custom
;===== machine: H2D =========================
;===== date: 20260605 =====================

;M1002 set_flag extrude_cali_flag=1
;M1002 set_flag g29_before_print_flag=1
;M1002 set_flag auto_cali_toolhead_offset_flag=1
;M1002 set_flag build_plate_detect_flag=1

M993 A0 B0 C0 ; nozzle cam detection not allowed.

M400
;M73 P99

M960 S10 P1 ; ext fan led

;=====printer start sound ===================
M17
M400 S1
M1006 S1
M1006 A53 B9 L99 C53 D9 M99 E53 F9 N99
M1006 A56 B9 L99 C56 D9 M99 E56 F9 N99
M1006 A61 B9 L99 C61 D9 M99 E61 F9 N99
M1006 A53 B9 L99 C53 D9 M99 E53 F9 N99
M1006 A56 B9 L99 C56 D9 M99 E56 F9 N99
M1006 A61 B18 L99 C61 D18 M99 E61 F18 N99
M1006 W
;=====printer start sound ===================

;===== reset machine status =================
M204 S10000
M630 S0 P0

G90
M17 D ; reset motor current to default
M960 S5 P1 ; turn on logo lamp
G90
M1002 set_gcode_claim_speed_level 5 ;Reset speed level
M220 S100 ;Reset Feedrate
M221 S100 ;Reset Flowrate
M73.2   R1.0 ;Reset left time magnitude
G29.1 Z0 ; clear z-trim value first
M983.1 M1
M901 D4
M481 S0 ; turn off cutter pos comp
G28.140 D0; reset pre-extrude z pos
;===== reset machine status =================

M620 M ;enable remap

;===== avoid end stop =================
G91
G380 S2 Z42 F1200
G380 S2 Z-12 F1200
G90
;===== avoid end stop =================

;==== set airduct mode ====


    M145 P0 ; set airduct mode to cooling mode for cooling
    M106 P2 S178 ; turn on auxiliary fan for cooling
    M106 P3 S127 ; turn on chamber fan for cooling
    M140 S0 ; stop heatbed from heating

    M1002 gcode_claim_action : 29
    M191 S0 ; wait for chamber temp
    M106 P2 S0 ; turn off auxiliary fan
    
        
            M142 P1 R30 S40 T45 U0.3 V0.5 W0.8 O45; set PLA/TPU ND0.4 chamber autocooling
        
    
    
        M145.2 P0 F1
    


;==== set airduct mode ====

;===== start to heat heatbed & hotend==========

    M1002 set_filament_type:PLA

    M104 S140 A
    M140 S55

    ;===== set chamber temperature ==========
    
    ;===== set chamber temperature ==========

;===== start to heat heatbead & hotend==========

;====== cog noise reduction=================
M982.2 S1 ; turn on cog noise reduction

;===== first homing start =====
M1002 gcode_claim_action : 13

G28 X T300

G150.1 F18000 ; wipe mouth to avoid filament stick to heatbed
G150.3 F18000
M400 P200
M972 S24 P0 T2000

M1002 gcode_claim_action : 74 ; Heatbed surface foreign object detection

M972 S26 P0 C0

M972 S35 P0 C0

M972 S41 P0 T5000 ; trash can anti-collision

M1009 Q1 L1
G91
G380 S2 Z30 F1200 ; lower heatbed to move toolhead
G90
G1 X175 Y160 F30000
G28 Z P0 T250
M1009 Q1 L0

;===== first homing end =====

M400
;M73 P99

;===== detection start =====

M1002 judge_flag build_plate_detect_flag
M622 S1
    ;M1002 gcode_claim_action : 11 ; Indentifying build plate type
    M972 S19 P0 C0    ; heatbed presence detection
    M972 S31 P0 T5000 ; toolhead camera dirty detection
    ;M1002 gcode_claim_action : 73 ; Build plate alignment detection
    M972 S34 P0 T5000 ; heatbed plate offset detection
M623

M1002 gcode_claim_action : 72 ; Hotend Type Detection
T1001
M972 S14 P0 T5000 ; nozzle type detection

M104 S220 T1 ; rise temp in advance

G151 P1 M ; plug the heat nozzle



;===== detection end =====

M400
;M73 P99

;===== prepare print temperature and material ==========
M400
M211 X0 Y0 Z0 ;turn off soft endstop
M975 S1 ; turn on input shaping

G29.2 S0 ; avoid invalid abl data


M620.10 A0 F239.471 H0.4 T240 P220 S1
M620.10 A1 F239.471 H0.4 T240 P220 S1


M620.11 P0 I0 B-1 E0


M620.11 K1 I0 B-1 R10 F299.339


M628 S1


    M620.11 S1 L0 I0 B-1 R10 D8 E-10 F299.339


M629

M620 S0A H-1 ; switch material if AMS exist
M1002 gcode_claim_action : 4
M1002 set_filament_type:UNKNOWN
M400
T0 H-1
M400
M628 S0
M629
M400
M1002 set_filament_type:PLA
M621 S0A

M104 S220
M400
M106 P1 S0

G29.2 S1
;===== prepare print temperature and material ==========

M400
;M73 P99

;===== auto extrude cali start =========================
M975 S1
M1002 judge_flag extrude_cali_flag

M622 J0
    M983.3 F5 A0.4 ; cali dynamic extrusion compensation
M623

M622 J1
    M1002 set_filament_type:PLA
    M1002 gcode_claim_action : 8

    M109 S220

    G90
    M83
    M983.3 F5 A0.4 ; cali dynamic extrusion compensation

    M400
    M106 P1 S255
    M400 S5
    M106 P1 S0
    G150.3
M623

M622 J2
    M1002 set_filament_type:PLA
    M1002 gcode_claim_action : 8

    M109 S220

    G90
    M83
    M983.3 F5 A0.4 ; cali dynamic extrusion compensation

    M400
    M106 P1 S255
    M400 S5
    M106 P1 S0
    G150.3
M623

;===== auto extrude cali end =========================


    M106 P1 S0
    M400 S2
    M109 S220 ; wait tmpr to extrude
    M83
    
        G1 E45 F299.339
    
    G1 E-3 F1800
    M400 P500
    G150.2
    G150.1


G91
M73 P2 R16
G1 Y-16 F12000 ; move away from the trash bin
G90

M400
;M73 P99

;===== wipe right nozzle start =====

M1002 gcode_claim_action : 14
    G150 T220
    
M106 S255 ; turn on fan to cool the nozzle

;===== wipe left nozzle end =====

M400
;M73 P99



M400
;M73 P99

;===== bed leveling ==================================

M1002 judge_flag g29_before_print_flag

M190 S55; ensure bed temp
M109 S140 A
M106 S0 ; turn off fan , too noisy

G91
M73 P4 R15
G1 Z5 F1200
G90
G1 X175 Y160 F30000

M622 J1
    M1002 gcode_claim_action : 1
    G29.20 A3
    G29 A1 O X158.147 Y146.368 I33.708 J27.2594 R
    M400
M623

M622 J2
    M1002 gcode_claim_action : 1
    
        G29.20 A4
        G29 A2 O X158.147 Y146.368 I33.708 J27.2594 R
    
    M400
M623

M622 J0
    G28 R
M623

;===== bed leveling end ================================

;===== z ofst cali start =====

    M190 S55; ensure bed temp

    G383 O0 M2 T140

;===== z ofst cali end =====

G39.1 ; cali nozzle wrapped detection pos

G90
M73 P31 R11
G1 Z5 F1200
G1 X270 Y-0.5 F60000
G28.140 S0 ; cali pre-extrude z pos

M141 S0
M104 S220 A

;===== mech mode sweep start =====
    M1002 gcode_claim_action : 3

    G90
    G1 Z5 F1200
    G1 X187 Y160 F20000
    T1000
    M400 P200

    M970.3 Q1 A5 K0 O1
    M974 Q1 S2 P0

    M970.3 Q0 A5 K0 O1
    M974 Q0 S2 P0

    M970.2 Q2 K0 W38 Z0.01
    M974 Q2 S2 P0

    M975 S1
;===== mech mode sweep end =====

M400
;M73 P99

G150.3 ; move to garbage can to wait for temp
M1026
G29.9

;===== xy ofst cali start =====

M1002 judge_flag auto_cali_toolhead_offset_flag

M622 J0
    M1012.5 N1 R1
M623

M622 J1
    M1002 gcode_claim_action : 39
    M141 S0
    M620.17 T0 S220 L0
    M620.17 T1 S220 L0
    M620 D-1
    G383 O1 T220 L0
    M141 S0
M623

M622 J2
    M1002 gcode_claim_action : 39
    M141 S0
    M620.17 T0 S220 L0
    M620.17 T1 S220 L0
    M620 D-1
    G383.3 T220 L0
    M141 S0
M623
;===== xy ofst cali end =====

M400
;M73 P99

M1002 gcode_claim_action : 0
M400

;============switch again==================
M211 X0 Y0 Z0 ;turn off soft endstop
G91
G1 Z6 F1200
G90
M1002 set_filament_type:PLA
M620 S0A H-1
M400
T0 H-1
M400
M628 S0
M629
M400
M621 S0A

;============switch again==================

M400
;M73 P99

;===== wait temperature reaching the reference value =======

M104 S220 ; rise to print tmpr

M140 S55
M190 S55

    ;========turn off light and fans =============
    M960 S1 P0 ; turn off laser
    M960 S2 P0 ; turn off laser
    M106 S0 ; turn off fan
    M106 P2 S0 ; turn off big fan
    ;==== set ext toodhead cooling fan ====
    
    M106 P9 S255
    
    ;============set motor current==================
    M400 S1

;===== wait temperature reaching the reference value =======

M400
;M73 P99

;===== for Textured PEI Plate , lower the nozzle as the nozzle was touching topmost of the texture when homing ==
    
        
            G29.1 Z-0.02 ; for Textured PEI Plate
        
    

G150.1

M975 S1 ; turn on mech mode supression
M983.4 S1 ; turn on deformation compensation
G29.2 S1 ; turn on pos comp
G29.7 S1

G90
G1 Z5 F1200
G1 Y295 F30000
G1 Y265 F18000

;===== nozzle load line ===============================
    G29.2 S1 ; ensure z comp turn on
    G90
    M83
    G1 Z5 F1200
    G1 X270 Y-0.5 F60000
    G28.14 R0
    G29.2 S0
    G91
    G1 Z0.8 F1200
    G90
    G1 X250 F60000
    M400 P50
    M500 D1
    M400 S3
    M109 S220
    M83


    G1 E5 F299.339
    G1 X290 E10 F299.339
    G91
    G3 Z0.4 I1.217 J0 P1 F60000
    G90
    M83
    G29.2 S1 ; ensure z comp turn on
;===== noozle load line end ===========================

M400
;M73 P99

M993 A1 B1 C1 ; nozzle cam detection allowed.


M1015.3 S0;disable tpu clog detect



M1015.4 S1 K1 H0.4 ;enable E air printing detect


M620.6 I0 H-1 W1 ;enable ams air printing detect
M620 Q1

M211 Z1
G29.99
; MACHINE_START_GCODE_END
; filament start gcode
;VT0 H-1
G90
G21
M83 ; use relative distances for extrusion
M981 S1 P20000 ;open spaghetti detector
; CHANGE_LAYER
; Z_HEIGHT: 0.2
; LAYER_HEIGHT: 0.2
G1 E-.8 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 1/85
; update layer progress
M73 L1
M991 S0 P0 ;notify layer change

M106 S0
M106 P2 S0
; OBJECT_ID: 15
M73 P32 R11
G1 X159.472 Y147.749 F60000
M204 S6000
G1 Z.4
G1 Z.2
G1 E.8 F1800
; FEATURE: Brim
; LINE_WIDTH: 0.5
G1 F3000
M204 S500
G1 X159.888 Y147.365 E.02109
G1 X160.362 Y147.053 E.02113
G1 X160.843 Y146.836 E.01967
G1 X161.387 Y146.673 E.02114
G1 X162.112 Y146.597 E.02715
G1 X187.891 Y146.597 E.96016
G1 X188.46 Y146.644 E.02127
G1 X189.275 Y146.886 E.03169
G1 X189.88 Y147.201 E.02537
M73 P33 R11
G1 X190.326 Y147.547 E.02104
G1 X190.71 Y147.963 E.02109
G1 X191.022 Y148.437 E.02113
G1 X191.239 Y148.918 E.01967
G1 X191.402 Y149.462 E.02114
G1 X191.478 Y150.187 E.02716
G1 X191.478 Y164.528 E.53414
G1 X191.594 Y165.332 E.03024
G1 X191.626 Y166.079 E.02786
G1 X191.592 Y166.742 E.02471
G1 X191.478 Y167.521 E.02934
G1 X191.478 Y169.666 E.07988
G1 X191.431 Y170.235 E.02127
G1 X191.148 Y171.146 E.03555
G1 X190.875 Y171.653 E.02144
G1 X190.528 Y172.101 E.02109
G1 X190.112 Y172.485 E.02109
G1 X189.637 Y172.797 E.02118
G1 X189.256 Y172.975 E.01565
G1 X188.612 Y173.177 E.02516
G1 X187.888 Y173.253 E.0271
G1 X185.747 Y173.253 E.07974
G1 X184.942 Y173.369 E.03031
G1 X184.438 Y173.399 E.01879
G1 X184.037 Y173.399 E.01494
G1 X183.574 Y173.371 E.01729
G1 X182.754 Y173.253 E.03083
G1 X167.247 Y173.253 E.57759
G1 X166.442 Y173.369 E.03031
G1 X165.938 Y173.399 E.01879
G1 X165.539 Y173.399 E.01486
G1 X164.812 Y173.342 E.02718
G1 X164.254 Y173.253 E.02101
G1 X162.109 Y173.253 E.07989
G1 X161.54 Y173.206 E.02127
G1 X160.725 Y172.964 E.03169
G1 X160.12 Y172.649 E.02537
G1 X159.674 Y172.303 E.02104
G1 X159.29 Y171.887 E.02109
G1 X158.978 Y171.412 E.02118
G1 X158.8 Y171.031 E.01565
G1 X158.598 Y170.387 E.02516
G1 X158.522 Y169.663 E.0271
G1 X158.522 Y167.522 E.07974
G1 X158.406 Y166.717 E.03031
G1 X158.376 Y166.214 E.01874
G1 X158.378 Y165.747 E.0174
G1 X158.404 Y165.351 E.01478
G1 X158.522 Y164.529 E.03092
G1 X158.522 Y150.184 E.5343
G1 X158.569 Y149.615 E.02127
G1 X158.852 Y148.704 E.03555
G1 X159.125 Y148.197 E.02144
G1 X159.435 Y147.796 E.01886
M204 S6000
G1 X159.796 Y148.076 F60000
G1 F3000
M204 S500
G1 X159.803 Y148.068 E.0004
G1 X160.162 Y147.734 E.01826
G1 X160.574 Y147.461 E.0184
G1 X161.012 Y147.263 E.01794
G1 X161.49 Y147.122 E.01855
G1 X162.143 Y147.054 E.02445
G1 X187.877 Y147.055 E.95851
G1 X188.389 Y147.1 E.01911
G1 X189.091 Y147.308 E.02728
G1 X189.621 Y147.581 E.02223
G1 X190.024 Y147.893 E.01896
G1 X190.355 Y148.254 E.01826
G1 X190.614 Y148.649 E.01756
G1 X190.806 Y149.07 E.01726
G1 X190.953 Y149.565 E.01922
G1 X191.02 Y150.204 E.02392
G1 X191.021 Y164.519 E.53317
G1 X191.137 Y165.368 E.03195
G1 X191.169 Y166.071 E.02618
G1 X191.136 Y166.702 E.02354
G1 X191.021 Y167.53 E.03116
G1 X191.021 Y169.652 E.07903
G1 X190.975 Y170.161 E.01904
G1 X190.718 Y170.98 E.03197
G1 X190.484 Y171.412 E.0183
G1 X190.197 Y171.782 E.01743
G1 X189.838 Y172.116 E.01826
G1 X189.422 Y172.392 E.01859
G1 X189.099 Y172.544 E.01332
G1 X188.505 Y172.729 E.02317
G1 X187.857 Y172.796 E.02426
G1 X185.756 Y172.796 E.07824
G1 X184.9 Y172.913 E.0322
G1 X184.428 Y172.942 E.0176
G1 X183.616 Y172.915 E.03029
G1 X182.745 Y172.796 E.03273
G1 X167.256 Y172.796 E.57689
G1 X166.4 Y172.913 E.0322
G1 X165.567 Y172.942 E.03104
G1 X164.871 Y172.888 E.02601
G1 X164.244 Y172.796 E.02359
G1 X162.134 Y172.796 E.0786
G1 X161.611 Y172.75 E.01954
G1 X160.909 Y172.542 E.02728
G1 X160.379 Y172.269 E.02223
G1 X159.993 Y171.972 E.01812
G1 X159.659 Y171.613 E.01826
G1 X159.383 Y171.197 E.01859
G1 X159.231 Y170.874 E.01332
G1 X159.046 Y170.28 E.02317
G1 X158.979 Y169.632 E.02425
G1 X158.979 Y167.531 E.07824
G1 X158.862 Y166.675 E.0322
G1 X158.833 Y166.206 E.01749
G1 X158.86 Y165.394 E.03025
G1 X158.979 Y164.52 E.03287
G1 X158.979 Y150.209 E.53304
G1 X159.025 Y149.689 E.01946
G1 X159.282 Y148.87 E.03197
G1 X159.516 Y148.438 E.0183
G1 X159.759 Y148.124 E.01479
M204 S6000
G1 X160.122 Y148.402 F60000
G1 F3000
M204 S500
G1 X160.135 Y148.386 E.00077
G1 X160.437 Y148.102 E.01545
G1 X160.786 Y147.869 E.01564
G1 X161.181 Y147.689 E.01615
G1 X161.592 Y147.571 E.01592
G1 X162.174 Y147.511 E.02179
G1 X187.851 Y147.512 E.95639
G1 X188.316 Y147.555 E.01738
G1 X188.907 Y147.73 E.02297
G1 X189.363 Y147.963 E.01907
G1 X189.721 Y148.239 E.01685
G1 X189.999 Y148.545 E.01541
G1 X190.207 Y148.861 E.01407
G1 X190.373 Y149.222 E.01481
G1 X190.504 Y149.667 E.01728
G1 X190.562 Y150.221 E.02071
M73 P33 R10
G1 X190.564 Y164.51 E.53222
G1 X190.681 Y165.404 E.0336
G1 X190.711 Y166.062 E.02454
G1 X190.68 Y166.664 E.02242
G1 X190.564 Y167.539 E.0329
G1 X190.563 Y169.638 E.07816
G1 X190.52 Y170.086 E.01676
G1 X190.289 Y170.813 E.02841
G1 X190.105 Y171.152 E.01436
G1 X189.865 Y171.464 E.01467
G1 X189.563 Y171.748 E.01545
G1 X189.206 Y171.987 E.016
G1 X188.941 Y172.113 E.01092
G1 X188.399 Y172.28 E.02114
G1 X187.826 Y172.339 E.02143
G1 X185.765 Y172.339 E.07676
G1 X184.859 Y172.458 E.03403
G1 X184.429 Y172.484 E.01608
G1 X183.648 Y172.458 E.02909
G1 X182.736 Y172.339 E.03426
G1 X167.265 Y172.339 E.57623
G1 X166.367 Y172.457 E.03374
G1 X165.585 Y172.484 E.02916
G1 X164.926 Y172.434 E.02458
G1 X164.235 Y172.339 E.026
G1 X162.16 Y172.339 E.07728
G1 X161.684 Y172.295 E.01781
G1 X161.093 Y172.12 E.02296
G1 X160.636 Y171.887 E.01912
G1 X160.311 Y171.64 E.0152
G1 X160.027 Y171.338 E.01543
G1 X159.788 Y170.981 E.016
G1 X159.662 Y170.716 E.01092
G1 X159.495 Y170.174 E.02114
G1 X159.436 Y169.601 E.02143
G1 X159.436 Y167.54 E.07676
G1 X159.317 Y166.634 E.03404
G1 X159.291 Y166.206 E.01597
G1 X159.317 Y165.427 E.02904
G1 X159.436 Y164.511 E.03439
G1 X159.436 Y150.235 E.53173
G1 X159.48 Y149.764 E.01763
G1 X159.711 Y149.037 E.0284
G1 X159.895 Y148.698 E.01436
G1 X160.086 Y148.45 E.01166
M204 S6000
G1 X160.448 Y148.728 F60000
G1 F3000
M204 S500
G1 X160.468 Y148.703 E.00121
G1 X160.714 Y148.469 E.01265
G1 X161.019 Y148.265 E.01367
G1 X161.349 Y148.117 E.01348
G1 X161.691 Y148.02 E.01323
G1 X162.204 Y147.968 E.01919
G1 X187.823 Y147.969 E.95423
G1 X188.242 Y148.01 E.01565
G1 X188.725 Y148.153 E.01878
G1 X189.106 Y148.345 E.0159
G1 X189.418 Y148.585 E.01467
G1 X189.643 Y148.835 E.01252
G1 X189.81 Y149.093 E.01144
G1 X189.94 Y149.375 E.01155
G1 X190.056 Y149.769 E.01532
G1 X190.105 Y150.237 E.01753
G1 X190.107 Y164.501 E.53128
G1 X190.225 Y165.439 E.03521
G1 X190.253 Y166.068 E.02343
G1 X190.224 Y166.627 E.02085
G1 X190.107 Y167.548 E.03458
G1 X190.106 Y169.609 E.07678
G1 X190.071 Y169.979 E.01385
G1 X189.871 Y170.621 E.02502
G1 X189.726 Y170.893 E.01147
G1 X189.532 Y171.147 E.01193
G1 X189.286 Y171.381 E.01265
G1 X188.988 Y171.583 E.01341
G1 X188.784 Y171.682 E.00844
G1 X188.294 Y171.832 E.01908
G1 X187.796 Y171.882 E.01863
G1 X185.774 Y171.882 E.07531
G1 X184.82 Y172.002 E.03583
G1 X184.429 Y172.026 E.01459
G1 X183.679 Y172.001 E.02792
G1 X182.727 Y171.882 E.03574
G1 X167.274 Y171.882 E.57559
G1 X166.335 Y172 E.03525
G1 X165.602 Y172.026 E.02733
G1 X164.972 Y171.979 E.02352
G1 X164.226 Y171.882 E.02801
G1 X162.187 Y171.882 E.07593
G1 X161.784 Y171.845 E.01508
G1 X161.275 Y171.697 E.01975
G1 X160.89 Y171.504 E.01604
G1 X160.627 Y171.306 E.01228
G1 X160.394 Y171.061 E.01259
G1 X160.192 Y170.763 E.01341
G1 X160.093 Y170.559 E.00844
G1 X159.943 Y170.069 E.01908
G1 X159.893 Y169.571 E.01863
G1 X159.893 Y167.549 E.07531
G1 X159.773 Y166.594 E.03584
G1 X159.749 Y166.206 E.0145
G1 X159.773 Y165.458 E.02787
G1 X159.893 Y164.503 E.03587
G1 X159.893 Y150.263 E.53037
G1 X159.935 Y149.841 E.01578
G1 X160.14 Y149.205 E.02488
G1 X160.286 Y148.939 E.0113
G1 X160.412 Y148.776 E.00769
M204 S6000
G1 X160.795 Y149.062 F60000
G1 F3000
M204 S500
G1 X160.882 Y148.946 E.00539
G1 X161.142 Y148.735 E.01248
G1 X161.396 Y148.594 E.01084
G1 X161.628 Y148.512 E.00914
G1 X162.135 Y148.425 E.01917
G1 X187.872 Y148.425 E.95861
G1 X188.172 Y148.46 E.01126
G1 X188.489 Y148.548 E.01226
G1 X188.594 Y148.594 E.00426
G1 X188.994 Y148.838 E.01743
G1 X189.253 Y149.1 E.01374
G1 X189.483 Y149.477 E.01644
G1 X189.563 Y149.703 E.00892
G1 X189.65 Y150.21 E.01917
G1 X189.65 Y164.752 E.54165
G1 X189.757 Y165.374 E.02352
G1 X189.794 Y166.096 E.0269
G1 X189.757 Y166.672 E.02151
M73 P34 R10
G1 X189.65 Y167.297 E.02361
G1 X189.632 Y169.844 E.09489
G1 X189.525 Y170.271 E.01637
G1 X189.241 Y170.765 E.02122
G1 X188.974 Y171.029 E.01402
G1 X188.696 Y171.208 E.01231
G1 X188.466 Y171.31 E.00936
G1 X188.105 Y171.399 E.01384
G1 X185.524 Y171.424 E.09617
G1 X184.903 Y171.532 E.02346
G1 X184.333 Y171.569 E.02128
G1 X183.608 Y171.532 E.02703
G1 X182.978 Y171.425 E.02381
G1 X167.022 Y171.425 E.59429
G1 X166.394 Y171.532 E.02373
G1 X165.643 Y171.569 E.02804
G1 X165.1 Y171.532 E.02027
G1 X164.478 Y171.425 E.02349
G1 X161.931 Y171.407 E.09489
G1 X161.504 Y171.3 E.01637
G1 X161.01 Y171.016 E.02122
G1 X160.746 Y170.749 E.01402
G1 X160.567 Y170.471 E.01231
G1 X160.465 Y170.241 E.00935
G1 X160.376 Y169.88 E.01385
G1 X160.351 Y167.299 E.09614
G1 X160.252 Y166.75 E.02078
G1 X160.207 Y166.2 E.02057
G1 X160.242 Y165.391 E.03013
G1 X160.35 Y164.753 E.0241
G1 X160.35 Y150.205 E.54189
G1 X160.405 Y149.813 E.01473
G1 X160.504 Y149.506 E.01201
G1 X160.595 Y149.33 E.0074
G1 X160.759 Y149.11 E.01019
M204 S6000
G1 X161.127 Y149.365 F60000
G1 F3000
M204 S500
G1 X161.173 Y149.298 E.00305
G1 X161.365 Y149.134 E.00939
G1 X161.558 Y149.021 E.00833
G1 X161.705 Y148.963 E.0059
G1 X162.123 Y148.882 E.01585
G1 X187.88 Y148.882 E.95934
G1 X188.121 Y148.914 E.00905
G1 X188.363 Y148.988 E.00942
G1 X188.677 Y149.167 E.01349
G1 X188.862 Y149.337 E.00936
G1 X189.055 Y149.636 E.01324
G1 X189.112 Y149.78 E.00579
G1 X189.193 Y150.198 E.01585
G1 X189.193 Y164.806 E.54409
G1 X189.3 Y165.394 E.02225
G1 X189.339 Y166.058 E.02479
G1 X189.3 Y166.65 E.02209
G1 X189.193 Y167.243 E.02246
G1 X189.185 Y169.746 E.09321
G1 X189.14 Y169.983 E.00899
G1 X189.088 Y170.136 E.00602
G1 X188.908 Y170.452 E.01355
G1 X188.738 Y170.638 E.00937
G1 X188.439 Y170.83 E.01324
G1 X188.293 Y170.888 E.00587
G1 X187.998 Y170.955 E.01123
G1 X185.469 Y170.968 E.09421
G1 X184.881 Y171.075 E.02228
G1 X184.295 Y171.114 E.02186
G1 X183.627 Y171.076 E.02492
G1 X183.032 Y170.968 E.02254
G1 X166.969 Y170.968 E.59827
G1 X166.377 Y171.075 E.02241
G1 X165.682 Y171.114 E.02593
G1 X165.124 Y171.075 E.02084
G1 X164.532 Y170.968 E.02241
G1 X162.029 Y170.96 E.09321
G1 X161.792 Y170.915 E.00899
G1 X161.639 Y170.863 E.00602
G1 X161.323 Y170.683 E.01355
G1 X161.138 Y170.513 E.00937
G1 X160.945 Y170.214 E.01324
G1 X160.887 Y170.068 E.00587
G1 X160.82 Y169.773 E.01124
G1 X160.807 Y167.244 E.0942
G1 X160.7 Y166.661 E.0221
G1 X160.662 Y166.157 E.0188
G1 X160.699 Y165.406 E.02801
G1 X160.807 Y164.807 E.0227
G1 X160.807 Y150.195 E.54422
G1 X160.839 Y149.954 E.00905
G1 X160.914 Y149.707 E.00962
G1 X160.966 Y149.597 E.00453
G1 X161.093 Y149.415 E.00827
M204 S6000
G1 X161.471 Y149.653 F60000
G1 F3000
M204 S500
G1 X161.483 Y149.633 E.00088
G1 X161.585 Y149.535 E.00529
G1 X161.798 Y149.41 E.00918
G1 X162.11 Y149.339 E.01191
G1 X187.889 Y149.339 E.96016
G1 X188.055 Y149.366 E.00626
G1 X188.23 Y149.425 E.00687
G1 X188.442 Y149.558 E.00934
G1 X188.54 Y149.66 E.00529
G1 X188.665 Y149.873 E.00918
G1 X188.736 Y150.185 E.01191
G1 X188.736 Y164.863 E.54671
G1 X188.843 Y165.416 E.02097
G1 X188.883 Y166.02 E.02254
G1 X188.844 Y166.628 E.02271
G1 X188.736 Y167.187 E.02118
G1 X188.736 Y169.664 E.09227
G1 X188.709 Y169.83 E.00626
G1 X188.651 Y170.005 E.00687
G1 X188.517 Y170.217 E.00934
G1 X188.415 Y170.315 E.00529
G1 X188.202 Y170.44 E.00918
G1 X187.89 Y170.511 E.01191
G1 X185.412 Y170.511 E.09231
G1 X184.858 Y170.619 E.02099
G1 X184.256 Y170.658 E.02248
G1 X183.649 Y170.619 E.02267
G1 X183.088 Y170.511 E.02126
G1 X166.912 Y170.511 E.60253
G1 X166.356 Y170.619 E.02107
G1 X165.722 Y170.658 E.02369
G1 X165.147 Y170.619 E.02146
G1 X164.588 Y170.511 E.02119
G1 X162.111 Y170.511 E.09227
G1 X161.945 Y170.484 E.00626
G1 X161.77 Y170.426 E.00687
G1 X161.558 Y170.292 E.00934
G1 X161.46 Y170.19 E.00529
G1 X161.335 Y169.977 E.00918
G1 X161.264 Y169.665 E.01191
G1 X161.264 Y167.187 E.09231
G1 X161.156 Y166.634 E.02099
G1 X161.117 Y166.114 E.01939
G1 X161.156 Y165.424 E.02576
G1 X161.264 Y164.863 E.02126
G1 X161.264 Y150.186 E.54668
G1 X161.291 Y150.02 E.00626
G1 X161.35 Y149.845 E.00687
G1 X161.439 Y149.704 E.00622
M204 S6000
G1 X161.788 Y149.974 F60000
G1 F3000
M204 S500
G1 X161.914 Y149.852 E.00651
G1 X162.1 Y149.796 E.00722
G1 X187.9 Y149.796 E.96095
G1 X188.101 Y149.863 E.0079
G1 X188.223 Y149.989 E.00651
G1 X188.279 Y150.175 E.00722
G1 X188.279 Y164.925 E.54938
G1 X188.387 Y165.443 E.0197
G1 X188.428 Y165.982 E.02013
G1 X188.387 Y166.608 E.02338
G1 X188.279 Y167.125 E.01968
G1 X188.279 Y169.675 E.09498
G1 X188.212 Y169.876 E.0079
G1 X188.086 Y169.998 E.00651
G1 X187.9 Y170.054 E.00722
G1 X185.35 Y170.054 E.09498
G1 X184.832 Y170.162 E.01972
G1 X184.295 Y170.203 E.02007
G1 X183.669 Y170.162 E.02333
G1 X183.15 Y170.054 E.01976
G1 X166.85 Y170.054 E.60712
G1 X166.332 Y170.162 E.01972
G1 X165.762 Y170.203 E.02129
G1 X165.169 Y170.162 E.02211
G1 X164.65 Y170.054 E.01976
G1 X162.1 Y170.054 E.09498
G1 X161.899 Y169.987 E.0079
G1 X161.777 Y169.861 E.00651
G1 X161.721 Y169.675 E.00722
G1 X161.721 Y167.125 E.09498
G1 X161.613 Y166.608 E.01969
G1 X161.572 Y166.071 E.02004
G1 X161.613 Y165.445 E.02337
G1 X161.721 Y164.925 E.01978
G1 X161.721 Y150.175 E.54938
G1 X161.77 Y150.031 E.00566
; WIPE_START
G1 X161.914 Y149.852 E-.08729
G1 X162.1 Y149.796 E-.07367
G1 X163.676 Y149.796 E-.59903
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X169.585 Y154.628 Z.6 F60000
G1 X187.5 Y169.275 Z.6
G1 Z.2
G1 E.8 F1800
; FEATURE: Outer wall
G1 F3000
M204 S500
G1 X185.257 Y169.275 E.08353
G3 X183.243 Y169.275 I-1.007 J-3.336 E.07613
G1 X166.757 Y169.275 E.61401
G3 X164.743 Y169.275 I-1.007 J-3.336 E.07613
G1 X162.5 Y169.275 E.08353
G1 X162.5 Y167.032 E.08353
G3 X162.5 Y165.018 I3.321 J-1.007 E.07614
G1 X162.5 Y150.575 E.53793
G1 X187.5 Y150.575 E.93116
G1 X187.5 Y165.018 E.53793
G3 X187.5 Y167.032 I-3.361 J1.007 E.07611
G1 X187.5 Y169.215 E.08129
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

M204 S6000
G1 X187.043 Y168.818 F60000
; FEATURE: Inner wall
M73 P35 R10
G1 F3000
M204 S500
G1 X185.201 Y168.818 E.06862
G3 X183.299 Y168.818 I-.951 J-2.962 E.07196
G1 X166.701 Y168.818 E.61825
G3 X164.799 Y168.818 I-.951 J-2.962 E.07196
G1 X162.957 Y168.818 E.06862
G1 X162.957 Y166.976 E.06862
G3 X162.957 Y165.074 I2.948 J-.951 E.07197
G1 X162.957 Y151.032 E.52303
G1 X187.043 Y151.032 E.89711
G1 X187.043 Y165.074 E.52303
G3 X187.043 Y166.976 I-2.985 J.951 E.07194
G1 X187.043 Y168.758 E.06639
M204 S6000
G1 X186.586 Y168.361 F60000
G1 F3000
M204 S500
G1 X185.144 Y168.361 E.05372
G3 X183.356 Y168.361 I-.894 J-2.61 E.06779
G1 X166.644 Y168.361 E.62248
G3 X164.856 Y168.361 I-.894 J-2.61 E.06779
G1 X163.414 Y168.361 E.05372
G1 X163.414 Y166.919 E.05372
G3 X163.414 Y165.131 I2.598 J-.894 E.0678
G1 X163.414 Y151.489 E.50812
G1 X186.586 Y151.489 E.86306
G1 X186.586 Y165.131 E.50812
G3 X186.586 Y166.919 I-2.63 J.894 E.06778
G1 X186.586 Y168.301 E.05148
M204 S6000
G1 X186.129 Y167.904 F60000
G1 F3000
M204 S500
G1 X185.087 Y167.904 E.03881
G3 X183.413 Y167.904 I-.837 J-2.342 E.06358
G1 X166.587 Y167.904 E.62672
G3 X164.913 Y167.904 I-.837 J-2.342 E.06358
G1 X163.871 Y167.904 E.03881
G1 X163.871 Y166.862 E.03881
G3 X163.871 Y165.188 I2.342 J-.837 E.06357
G1 X163.871 Y151.946 E.49321
G1 X186.129 Y151.946 E.82901
G1 X186.129 Y165.188 E.49321
G3 X186.129 Y166.862 I-2.343 J.837 E.06358
G1 X186.129 Y167.844 E.03658
; WIPE_START
G1 X185.087 Y167.904 E-.39662
G1 X184.543 Y168.032 E-.21245
G1 X184.258 Y168.053 E-.10846
G1 X184.146 Y168.045 E-.04247
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X184.565 Y160.424 Z.6 F60000
G1 X185.02 Y152.129 Z.6
G1 Z.2
G1 E.8 F1800
; FEATURE: Bottom surface
; LINE_WIDTH: 0.50101
G1 F6300
M204 S500
G1 X185.74 Y152.849 E.03803
G1 X185.74 Y153.497 E.02418
G1 X184.578 Y152.335 E.06137
G1 X183.93 Y152.335 E.02418
G1 X185.74 Y154.145 E.09557
G1 X185.74 Y154.793 E.02418
G1 X183.282 Y152.335 E.12977
G1 X182.634 Y152.335 E.02418
G1 X185.74 Y155.441 E.16397
G1 X185.74 Y156.089 E.02418
G1 X181.986 Y152.335 E.19817
G1 X181.339 Y152.335 E.02418
G1 X185.74 Y156.737 E.23237
G1 X185.74 Y157.384 E.02418
G1 X180.691 Y152.335 E.26657
G1 X180.043 Y152.335 E.02418
G1 X185.74 Y158.032 E.30077
G1 X185.74 Y158.68 E.02418
G1 X179.395 Y152.335 E.33497
G1 X178.747 Y152.335 E.02418
G1 X185.74 Y159.328 E.36917
G1 X185.74 Y159.976 E.02418
G1 X178.099 Y152.335 E.40337
G1 X177.452 Y152.335 E.02418
G1 X185.74 Y160.624 E.43757
G1 X185.74 Y161.271 E.02418
G1 X176.804 Y152.335 E.47177
G1 X176.156 Y152.335 E.02418
G1 X185.74 Y161.919 E.50597
G1 X185.74 Y162.567 E.02418
G1 X175.508 Y152.335 E.54017
G1 X174.86 Y152.335 E.02418
M73 P36 R10
G1 X185.74 Y163.215 E.57437
G1 X185.74 Y163.863 E.02418
G1 X174.212 Y152.335 E.60857
G1 X173.564 Y152.335 E.02418
G1 X185.74 Y164.511 E.64277
G1 X185.74 Y165.158 E.02418
G1 X172.917 Y152.335 E.67697
G1 X172.269 Y152.335 E.02418
G1 X185.88 Y165.946 E.71853
G3 X185.809 Y166.523 I-1.566 J.101 E.02183
G1 X171.621 Y152.335 E.74899
G1 X170.973 Y152.335 E.02418
G1 X185.74 Y167.102 E.77957
G1 X185.74 Y167.515 E.01543
G1 X185.506 Y167.515 E.00875
G1 X170.325 Y152.335 E.80139
G1 X169.677 Y152.335 E.02418
G1 X184.893 Y167.55 E.80323
G1 X184.483 Y167.646 E.01571
G1 X184.351 Y167.656 E.00494
G1 X169.03 Y152.335 E.80884
G1 X168.382 Y152.335 E.02418
G1 X183.594 Y167.547 E.80308
G1 X183.458 Y167.515 E.00522
G1 X182.915 Y167.515 E.02029
G1 X167.734 Y152.335 E.80139
G1 X167.086 Y152.335 E.02418
G1 X182.267 Y167.515 E.80139
G1 X181.619 Y167.515 E.02418
G1 X166.438 Y152.335 E.80139
G1 X165.79 Y152.335 E.02418
G1 X180.971 Y167.515 E.80139
G1 X180.323 Y167.515 E.02418
G1 X165.143 Y152.335 E.80139
G1 X164.495 Y152.335 E.02418
G1 X179.675 Y167.515 E.80139
G1 X179.028 Y167.515 E.02418
G1 X164.26 Y152.748 E.7796
G1 X164.26 Y153.395 E.02418
G1 X178.38 Y167.515 E.7454
G1 X177.732 Y167.515 E.02418
G1 X164.26 Y154.043 E.7112
G1 X164.26 Y154.691 E.02418
G1 X177.084 Y167.515 E.677
G1 X176.436 Y167.515 E.02418
G1 X164.26 Y155.339 E.6428
G1 X164.26 Y155.987 E.02418
G1 X175.788 Y167.515 E.6086
G1 X175.14 Y167.515 E.02418
G1 X164.26 Y156.635 E.5744
G1 X164.26 Y157.282 E.02418
G1 X174.493 Y167.515 E.5402
G1 X173.845 Y167.515 E.02418
M73 P37 R10
G1 X164.26 Y157.93 E.506
G1 X164.26 Y158.578 E.02418
G1 X173.197 Y167.515 E.4718
G1 X172.549 Y167.515 E.02418
G1 X164.26 Y159.226 E.4376
G1 X164.26 Y159.874 E.02418
G1 X171.901 Y167.515 E.4034
G1 X171.253 Y167.515 E.02418
G1 X164.26 Y160.522 E.3692
G1 X164.26 Y161.169 E.02418
G1 X170.606 Y167.515 E.335
G1 X169.958 Y167.515 E.02418
G1 X164.26 Y161.817 E.3008
G1 X164.26 Y162.465 E.02418
G1 X169.31 Y167.515 E.2666
G1 X168.662 Y167.515 E.02418
G1 X164.26 Y163.113 E.2324
G1 X164.26 Y163.761 E.02418
G1 X168.014 Y167.515 E.1982
G1 X167.366 Y167.515 E.02418
G1 X164.26 Y164.409 E.164
G1 X164.26 Y165.056 E.02418
G1 X166.719 Y167.515 E.1298
G1 X166.542 Y167.515 E.0066
G1 X166.16 Y167.605 E.01463
G1 X164.17 Y165.615 E.10506
G2 X164.126 Y166.218 I1.568 J.419 E.02271
G1 X165.557 Y167.649 E.07555
G1 X164.958 Y167.515 E.02289
G1 X164.775 Y167.515 E.00684
G1 X164.04 Y166.78 E.03881
; CHANGE_LAYER
; Z_HEIGHT: 0.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F6300
G1 X164.775 Y167.515 E-.39513
G1 X164.958 Y167.515 E-.06959
G1 X165.557 Y167.649 E-.23307
G1 X165.441 Y167.533 E-.06222
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 2/85
; update layer progress
M73 L2
M991 S0 P1 ;notify layer change

M106 S255
M106 P2 S178
; open powerlost recovery
M1003 S1
; OBJECT_ID: 15
M204 S10000
G17
G3 Z.6 I-.042 J1.216 P1  F60000
G1 X186.484 Y168.259 Z.6
G1 Z.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X185.131 Y168.259 E.04487
G3 X183.369 Y168.259 I-.881 J-2.534 E.05957
G1 X166.631 Y168.259 E.55521
G3 X164.869 Y168.259 I-.881 J-2.534 E.05957
G1 X163.516 Y168.259 E.04487
G1 X163.516 Y166.906 E.04487
G3 X163.516 Y165.144 I2.524 J-.881 E.05958
G1 X163.516 Y151.591 E.44956
G1 X186.484 Y151.591 E.76188
G1 X186.484 Y165.144 E.44956
G3 X186.484 Y166.906 I-2.534 J.881 E.05957
G1 X186.484 Y168.199 E.04288
M204 S10000
G1 X186.891 Y168.666 F60000
G1 F8843.478
M204 S8000
G1 X185.182 Y168.666 E.05669
G3 X183.318 Y168.666 I-.932 J-2.842 E.06287
G1 X166.682 Y168.666 E.55186
G3 X164.818 Y168.666 I-.932 J-2.842 E.06287
G1 X163.109 Y168.666 E.05669
G1 X163.109 Y166.957 E.05669
G3 X163.109 Y165.093 I2.831 J-.932 E.06287
G1 X163.109 Y151.184 E.46139
G1 X186.891 Y151.184 E.78888
G1 X186.891 Y165.093 E.46139
G3 X186.891 Y166.957 I-2.842 J.932 E.06287
G1 X186.891 Y168.606 E.0547
M204 S10000
G1 X187.298 Y169.073 F60000
G1 F8843.478
M204 S8000
G1 X185.232 Y169.073 E.06852
G3 X183.268 Y169.073 I-.982 J-3.167 E.06617
G1 X166.732 Y169.073 E.5485
G3 X164.768 Y169.073 I-.982 J-3.167 E.06617
G1 X162.702 Y169.073 E.06852
G1 X162.702 Y167.007 E.06852
G3 X162.702 Y165.043 I3.155 J-.982 E.06617
G1 X162.702 Y150.777 E.47322
G1 X187.298 Y150.777 E.81589
G1 X187.298 Y165.043 E.47321
G3 X187.298 Y167.007 I-3.167 J.982 E.06617
G1 X187.298 Y169.013 E.06653
M204 S250
G1 X187.69 Y169.465 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X185.281 Y169.465 E.07402
G3 X183.219 Y169.465 I-1.031 J-3.496 E.06424
G1 X166.781 Y169.465 E.50509
G3 X164.719 Y169.465 I-1.031 J-3.496 E.06424
G1 X162.31 Y169.465 E.07402
G1 X162.31 Y167.056 E.07402
G3 X162.31 Y164.994 I3.483 J-1.031 E.06425
G1 X162.31 Y150.385 E.44889
G1 X187.69 Y150.385 E.77986
G1 X187.69 Y164.994 E.44889
G3 X187.69 Y167.056 I-3.496 J1.031 E.06424
G1 X187.69 Y169.405 E.07218
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

; WIPE_START
M204 S8000
G1 X185.691 Y169.455 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X185.555 Y168.095 Z.8 F60000
G1 Z.4
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42123
G1 F9516.005
M204 S8000
G1 X186.151 Y167.5 E.02595
G1 X186.151 Y166.965 E.01649
G1 X185.19 Y167.926 E.04188
G1 X185.093 Y167.926 E.00298
G1 X184.527 Y168.054 E.01791
G1 X186.279 Y166.302 E.07639
G2 X186.28 Y165.765 I-1.832 J-.273 E.01659
G1 X183.99 Y168.055 E.09983
G1 X183.552 Y167.959 E.01385
G1 X186.184 Y165.327 E.11476
G1 X186.151 Y165.182 E.00458
G1 X186.151 Y164.825 E.011
G1 X183.05 Y167.926 E.13517
G1 X182.515 Y167.926 E.01649
G1 X186.151 Y164.29 E.1585
G1 X186.151 Y163.755 E.01649
G1 X181.98 Y167.926 E.18182
G1 X181.445 Y167.926 E.01649
G1 X186.151 Y163.22 E.20515
G1 X186.151 Y162.685 E.01649
G1 X180.91 Y167.926 E.22847
G1 X180.375 Y167.926 E.01649
G1 X186.151 Y162.15 E.2518
G1 X186.151 Y161.615 E.01649
G1 X179.84 Y167.926 E.27512
G1 X179.305 Y167.926 E.01649
G1 X186.151 Y161.08 E.29845
G1 X186.151 Y160.545 E.01649
G1 X178.77 Y167.926 E.32177
G1 X178.235 Y167.926 E.01649
G1 X186.151 Y160.01 E.3451
G1 X186.151 Y159.475 E.01649
G1 X177.7 Y167.926 E.36842
G1 X177.165 Y167.926 E.01649
G1 X186.151 Y158.94 E.39175
G1 X186.151 Y158.405 E.01649
G1 X176.63 Y167.926 E.41507
G1 X176.095 Y167.926 E.01649
G1 X186.151 Y157.87 E.4384
G1 X186.151 Y157.335 E.01649
G1 X175.56 Y167.926 E.46172
G1 X175.025 Y167.926 E.01649
G1 X186.151 Y156.8 E.48504
G1 X186.151 Y156.265 E.01649
G1 X174.49 Y167.926 E.50837
G1 X173.955 Y167.926 E.01649
G1 X186.151 Y155.73 E.53169
G1 X186.151 Y155.195 E.01649
G1 X173.42 Y167.926 E.55502
G1 X172.885 Y167.926 E.01649
G1 X186.151 Y154.66 E.57834
G1 X186.151 Y154.125 E.01649
M73 P38 R10
G1 X172.35 Y167.926 E.60167
G1 X171.815 Y167.926 E.01649
G1 X186.151 Y153.59 E.62499
G1 X186.151 Y153.055 E.01649
G1 X171.28 Y167.926 E.64832
G1 X170.745 Y167.926 E.01649
G1 X186.151 Y152.52 E.67164
G1 X186.151 Y151.985 E.01649
G1 X170.21 Y167.926 E.69497
G1 X169.675 Y167.926 E.01649
G1 X185.676 Y151.924 E.69759
G1 X185.141 Y151.924 E.01649
G1 X169.14 Y167.926 E.69759
G1 X168.605 Y167.926 E.01649
G1 X184.606 Y151.924 E.69759
G1 X184.071 Y151.924 E.01649
G1 X168.07 Y167.926 E.69759
G1 X167.535 Y167.926 E.01649
G1 X183.536 Y151.924 E.69759
G1 X183.001 Y151.924 E.01649
G1 X167 Y167.926 E.69759
G1 X166.593 Y167.926 E.01253
G1 X166.426 Y167.964 E.00529
G1 X182.466 Y151.924 E.69928
G1 X181.931 Y151.924 E.01649
G1 X165.783 Y168.072 E.70398
G3 X165.303 Y168.017 I.031 J-2.389 E.01492
G1 X181.396 Y151.924 E.70158
G1 X180.861 Y151.924 E.01649
G1 X164.86 Y167.926 E.69759
G1 X164.325 Y167.926 E.01649
G1 X180.326 Y151.924 E.69759
G1 X179.791 Y151.924 E.01649
G1 X163.849 Y167.866 E.69498
G1 X163.849 Y167.331 E.01649
G1 X179.256 Y151.924 E.67166
G1 X178.721 Y151.924 E.01649
G1 X163.836 Y166.809 E.64893
G1 X163.736 Y166.375 E.01375
G1 X178.186 Y151.924 E.62998
G1 X177.651 Y151.924 E.01649
G1 X163.713 Y165.862 E.60764
G1 X163.722 Y165.733 E.00398
G1 X163.847 Y165.193 E.01709
G1 X177.116 Y151.924 E.57847
G1 X176.581 Y151.924 E.01649
G1 X163.849 Y164.656 E.55503
G1 X163.849 Y164.121 E.01649
G1 X176.046 Y151.924 E.53171
G1 X175.511 Y151.924 E.01649
G1 X163.849 Y163.586 E.50838
G1 X163.849 Y163.051 E.01649
G1 X174.976 Y151.924 E.48506
G1 X174.441 Y151.924 E.01649
G1 X163.849 Y162.516 E.46173
G1 X163.849 Y161.981 E.01649
G1 X173.906 Y151.924 E.43841
G1 X173.371 Y151.924 E.01649
G1 X163.849 Y161.446 E.41509
G1 X163.849 Y160.911 E.01649
G1 X172.836 Y151.924 E.39176
G1 X172.3 Y151.924 E.01649
G1 X163.849 Y160.375 E.36844
G1 X163.849 Y159.84 E.01649
G1 X171.765 Y151.924 E.34511
G1 X171.23 Y151.924 E.01649
G1 X163.849 Y159.305 E.32179
G1 X163.849 Y158.77 E.01649
G1 X170.695 Y151.924 E.29846
G1 X170.16 Y151.924 E.01649
G1 X163.849 Y158.235 E.27514
G1 X163.849 Y157.7 E.01649
G1 X169.625 Y151.924 E.25181
G1 X169.09 Y151.924 E.01649
G1 X163.849 Y157.165 E.22849
G1 X163.849 Y156.63 E.01649
G1 X168.555 Y151.924 E.20516
G1 X168.02 Y151.924 E.01649
G1 X163.849 Y156.095 E.18184
G1 X163.849 Y155.56 E.01649
G1 X167.485 Y151.924 E.15851
G1 X166.95 Y151.924 E.01649
G1 X163.849 Y155.025 E.13519
G1 X163.849 Y154.49 E.01649
G1 X166.415 Y151.924 E.11187
G1 X165.88 Y151.924 E.01649
G1 X163.849 Y153.955 E.08854
G1 X163.849 Y153.42 E.01649
G1 X165.345 Y151.924 E.06522
G1 X164.81 Y151.924 E.01649
G1 X163.849 Y152.885 E.04189
G1 X163.849 Y152.35 E.01649
G1 X164.445 Y151.755 E.02596
; CHANGE_LAYER
; Z_HEIGHT: 0.6
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9516.005
G1 X163.849 Y152.35 E-.32004
G1 X163.849 Y152.885 E-.2033
G1 X164.29 Y152.445 E-.23665
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 3/85
; update layer progress
M73 L3
M991 S0 P2 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z.8 I-.706 J.991 P1  F60000
G1 X186.484 Y168.259 Z.8
G1 Z.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X185.132 Y168.259 E.04486
G3 X183.368 Y168.259 I-.882 J-2.534 E.05959
G1 X166.632 Y168.259 E.55519
G3 X164.868 Y168.259 I-.882 J-2.534 E.05959
G1 X163.516 Y168.259 E.04486
G1 X163.516 Y166.907 E.04486
G3 X163.516 Y165.143 I2.534 J-.882 E.05959
G1 X163.516 Y151.591 E.44955
G1 X186.484 Y151.591 E.76188
G1 X186.484 Y165.143 E.44955
G3 X186.484 Y166.907 I-2.534 J.882 E.05959
G1 X186.484 Y168.199 E.04287
; COOLING_NODE: 0
M204 S10000
G1 X186.891 Y168.666 F60000
G1 F8843.478
M204 S8000
G1 X185.182 Y168.666 E.05668
G3 X183.318 Y168.666 I-.932 J-2.841 E.06288
G1 X166.682 Y168.666 E.55184
G3 X164.818 Y168.666 I-.932 J-2.841 E.06288
G1 X163.109 Y168.666 E.05668
G1 X163.109 Y166.957 E.05668
G3 X163.109 Y165.093 I2.841 J-.932 E.06288
G1 X163.109 Y151.184 E.46138
G1 X186.891 Y151.184 E.78888
G1 X186.891 Y165.093 E.46138
G3 X186.891 Y166.957 I-2.841 J.932 E.06288
G1 X186.891 Y168.606 E.05469
; COOLING_NODE: 0
M204 S10000
G1 X187.298 Y169.073 F60000
G1 F8843.478
M204 S8000
G1 X185.233 Y169.073 E.06851
G3 X183.267 Y169.073 I-.983 J-3.165 E.06618
G1 X166.733 Y169.073 E.54849
G3 X164.767 Y169.073 I-.983 J-3.165 E.06618
G1 X162.702 Y169.073 E.06851
G1 X162.702 Y167.008 E.06851
G3 X162.702 Y165.042 I3.165 J-.983 E.06618
G1 X162.702 Y150.777 E.47321
G1 X187.298 Y150.777 E.81589
G1 X187.298 Y165.042 E.47321
G3 X187.298 Y167.008 I-3.165 J.983 E.06618
G1 X187.298 Y169.013 E.06652
; COOLING_NODE: 0
M204 S250
G1 X187.69 Y169.465 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4163
M204 S5000
G1 X185.281 Y169.465 E.07402
G3 X183.219 Y169.465 I-1.031 J-3.494 E.06425
G1 X166.781 Y169.465 E.50508
G3 X164.719 Y169.465 I-1.031 J-3.494 E.06425
G1 X162.31 Y169.465 E.07402
G1 X162.31 Y167.056 E.07402
G3 X162.31 Y164.994 I3.494 J-1.031 E.06425
G1 X162.31 Y150.385 E.44889
G1 X187.69 Y150.385 E.77986
G1 X187.69 Y164.994 E.44889
G3 X187.69 Y167.056 I-3.494 J1.031 E.06425
G1 X187.69 Y169.405 E.07217
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

; WIPE_START
G1 F9547.055
M204 S8000
G1 X185.691 Y169.455 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X185.974 Y161.828 Z1 F60000
G1 X186.32 Y152.52 Z1
M73 P39 R10
G1 Z.6
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42123
G1 F9516.005
M204 S8000
G1 X185.725 Y151.924 E.02595
G1 X185.19 Y151.924 E.01649
G1 X186.151 Y152.885 E.04188
G1 X186.151 Y153.42 E.01649
G1 X184.655 Y151.924 E.0652
G1 X184.12 Y151.924 E.01649
G1 X186.151 Y153.955 E.08853
G1 X186.151 Y154.49 E.01649
G1 X183.585 Y151.924 E.11185
G1 X183.05 Y151.924 E.01649
G1 X186.151 Y155.025 E.13517
G1 X186.151 Y155.56 E.01649
G1 X182.515 Y151.924 E.1585
G1 X181.98 Y151.924 E.01649
G1 X186.151 Y156.095 E.18182
G1 X186.151 Y156.63 E.01649
G1 X181.445 Y151.924 E.20515
G1 X180.91 Y151.924 E.01649
G1 X186.151 Y157.165 E.22847
G1 X186.151 Y157.7 E.01649
G1 X180.375 Y151.924 E.2518
G1 X179.84 Y151.924 E.01649
G1 X186.151 Y158.235 E.27512
G1 X186.151 Y158.77 E.01649
G1 X179.305 Y151.924 E.29845
G1 X178.77 Y151.924 E.01649
G1 X186.151 Y159.305 E.32177
G1 X186.151 Y159.84 E.01649
G1 X178.235 Y151.924 E.3451
G1 X177.7 Y151.924 E.01649
G1 X186.151 Y160.375 E.36842
G1 X186.151 Y160.91 E.01649
G1 X177.165 Y151.924 E.39175
G1 X176.63 Y151.924 E.01649
G1 X186.151 Y161.445 E.41507
G1 X186.151 Y161.98 E.01649
G1 X176.095 Y151.924 E.4384
G1 X175.56 Y151.924 E.01649
G1 X186.151 Y162.515 E.46172
G1 X186.151 Y163.05 E.01649
G1 X175.025 Y151.924 E.48505
G1 X174.49 Y151.924 E.01649
G1 X186.151 Y163.585 E.50837
G1 X186.151 Y164.12 E.01649
G1 X173.955 Y151.924 E.53169
G1 X173.42 Y151.924 E.01649
G1 X186.151 Y164.655 E.55502
G1 X186.153 Y165.193 E.01658
G1 X172.885 Y151.924 E.57846
G1 X172.35 Y151.924 E.01649
G1 X186.287 Y165.862 E.60764
G3 X186.264 Y166.374 I-2.132 J.161 E.01584
G1 X171.815 Y151.924 E.62996
G1 X171.28 Y151.924 E.01649
G1 X186.164 Y166.809 E.64892
G1 X186.151 Y166.869 E.00189
G1 X186.151 Y167.33 E.01423
G1 X170.745 Y151.924 E.67164
G1 X170.21 Y151.924 E.01649
G1 X186.151 Y167.865 E.69497
G1 X186.151 Y167.926 E.00186
G1 X185.676 Y167.926 E.01464
G1 X169.675 Y151.924 E.69759
G1 X169.14 Y151.924 E.01649
G1 X185.141 Y167.926 E.69759
G1 X184.697 Y168.017 E.01396
G1 X168.605 Y151.924 E.70158
G1 X168.07 Y151.924 E.01649
G1 X184.217 Y168.071 E.70395
G3 X183.574 Y167.964 I.022 J-2.111 E.02015
G1 X167.535 Y151.924 E.69928
G1 X167 Y151.924 E.01649
G1 X183.001 Y167.926 E.69759
G1 X182.466 Y167.926 E.01649
G1 X166.465 Y151.924 E.69759
G1 X165.93 Y151.924 E.01649
G1 X181.931 Y167.926 E.69759
G1 X181.396 Y167.926 E.01649
G1 X165.395 Y151.924 E.69759
G1 X164.86 Y151.924 E.01649
G1 X180.861 Y167.926 E.69759
G1 X180.326 Y167.926 E.01649
G1 X164.325 Y151.924 E.69759
G1 X163.849 Y151.924 E.01465
G1 X163.849 Y151.984 E.00185
G1 X179.791 Y167.926 E.69498
G1 X179.256 Y167.926 E.01649
G1 X163.849 Y152.519 E.67166
G1 X163.849 Y153.054 E.01649
G1 X178.721 Y167.926 E.64833
G1 X178.186 Y167.926 E.01649
M73 P39 R9
G1 X163.849 Y153.589 E.62501
G1 X163.849 Y154.124 E.01649
G1 X177.651 Y167.926 E.60168
G1 X177.116 Y167.926 E.01649
G1 X163.849 Y154.659 E.57836
G1 X163.849 Y155.194 E.01649
G1 X176.581 Y167.926 E.55503
G1 X176.046 Y167.926 E.01649
G1 X163.849 Y155.729 E.53171
G1 X163.849 Y156.264 E.01649
G1 X175.511 Y167.926 E.50838
G1 X174.976 Y167.926 E.01649
G1 X163.849 Y156.799 E.48506
G1 X163.849 Y157.334 E.01649
G1 X174.441 Y167.926 E.46174
G1 X173.906 Y167.926 E.01649
G1 X163.849 Y157.869 E.43841
G1 X163.849 Y158.405 E.01649
G1 X173.371 Y167.926 E.41509
G1 X172.836 Y167.926 E.01649
G1 X163.849 Y158.94 E.39176
G1 X163.849 Y159.475 E.01649
G1 X172.301 Y167.926 E.36844
G1 X171.765 Y167.926 E.01649
G1 X163.849 Y160.01 E.34511
G1 X163.849 Y160.545 E.01649
G1 X171.23 Y167.926 E.32179
G1 X170.695 Y167.926 E.01649
G1 X163.849 Y161.08 E.29846
G1 X163.849 Y161.615 E.01649
G1 X170.16 Y167.926 E.27514
G1 X169.625 Y167.926 E.01649
G1 X163.849 Y162.15 E.25181
G1 X163.849 Y162.685 E.01649
G1 X169.09 Y167.926 E.22849
G1 X168.555 Y167.926 E.01649
G1 X163.849 Y163.22 E.20516
G1 X163.849 Y163.755 E.01649
G1 X168.02 Y167.926 E.18184
G1 X167.485 Y167.926 E.01649
G1 X163.849 Y164.29 E.15851
G1 X163.849 Y164.825 E.01649
G1 X166.95 Y167.926 E.13519
G1 X166.594 Y167.926 E.011
G1 X166.449 Y167.959 E.00458
G1 X163.816 Y165.326 E.11478
G1 X163.72 Y165.765 E.01385
G1 X166.01 Y168.055 E.09985
G3 X165.474 Y168.054 I-.264 J-1.836 E.01659
G1 X163.721 Y166.301 E.07642
G1 X163.849 Y166.869 E.01794
G1 X163.849 Y166.965 E.00296
G1 X164.81 Y167.926 E.04189
G1 X164.275 Y167.926 E.01649
G1 X163.68 Y167.33 E.02596
; CHANGE_LAYER
; Z_HEIGHT: 0.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9516.005
G1 X164.275 Y167.926 E-.32004
G1 X164.81 Y167.926 E-.2033
G1 X164.37 Y167.485 E-.23665
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 4/85
; update layer progress
M73 L4
M991 S0 P3 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z1 I-.043 J1.216 P1  F60000
G1 X186.484 Y168.259 Z1
G1 Z.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X185.132 Y168.259 E.04485
G3 X183.368 Y168.259 I-.882 J-2.534 E.05961
G1 X166.632 Y168.259 E.55518
G3 X164.868 Y168.259 I-.882 J-2.534 E.05961
G1 X163.516 Y168.259 E.04485
G1 X163.516 Y166.907 E.04485
G3 X163.516 Y165.143 I2.534 J-.882 E.05961
G1 X163.516 Y151.591 E.44954
G1 X186.484 Y151.591 E.76188
G1 X186.484 Y165.143 E.44954
G3 X186.484 Y166.907 I-2.534 J.882 E.05961
G1 X186.484 Y168.199 E.04286
; COOLING_NODE: 0
M204 S10000
G1 X186.891 Y168.666 F60000
G1 F8843.478
M204 S8000
G1 X185.182 Y168.666 E.05668
G3 X183.318 Y168.666 I-.932 J-2.841 E.0629
G1 X166.682 Y168.666 E.55183
G3 X164.818 Y168.666 I-.932 J-2.841 E.0629
G1 X163.109 Y168.666 E.05668
G1 X163.109 Y166.957 E.05668
G3 X163.109 Y165.093 I2.841 J-.932 E.0629
G1 X163.109 Y151.184 E.46137
G1 X186.891 Y151.184 E.78888
G1 X186.891 Y165.093 E.46137
G3 X186.891 Y166.957 I-2.841 J.932 E.0629
G1 X186.891 Y168.606 E.05469
; COOLING_NODE: 0
M204 S10000
M73 P40 R9
G1 X187.298 Y169.073 F60000
G1 F8843.478
M204 S8000
G1 X185.233 Y169.073 E.06851
G3 X183.267 Y169.073 I-.983 J-3.164 E.06619
G1 X166.733 Y169.073 E.54848
G3 X164.767 Y169.073 I-.983 J-3.164 E.06619
G1 X162.702 Y169.073 E.06851
G1 X162.702 Y167.008 E.06851
G3 X162.702 Y165.042 I3.164 J-.983 E.06619
G1 X162.702 Y150.777 E.4732
G1 X187.298 Y150.777 E.81589
G1 X187.298 Y165.042 E.4732
G3 X187.298 Y167.008 I-3.164 J.983 E.06619
G1 X187.298 Y169.013 E.06652
; COOLING_NODE: 0
M204 S250
G1 X187.69 Y169.465 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4061
M204 S5000
G1 X185.281 Y169.465 E.07401
G3 X183.219 Y169.465 I-1.031 J-3.492 E.06425
G1 X166.781 Y169.465 E.50508
G3 X164.719 Y169.465 I-1.031 J-3.492 E.06425
G1 X162.31 Y169.465 E.07401
G1 X162.31 Y167.056 E.07401
G3 X162.31 Y164.994 I3.492 J-1.031 E.06425
G1 X162.31 Y150.385 E.44889
G1 X187.69 Y150.385 E.77986
G1 X187.69 Y164.994 E.44889
G3 X187.69 Y167.056 I-3.492 J1.031 E.06425
G1 X187.69 Y169.405 E.07217
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

; WIPE_START
G1 F9547.055
M204 S8000
G1 X185.691 Y169.455 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X185.555 Y168.095 Z1.2 F60000
G1 Z.8
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42123
G1 F9516.005
M204 S8000
G1 X186.151 Y167.5 E.02595
G1 X186.151 Y166.965 E.01649
G1 X185.19 Y167.926 E.04188
G1 X185.094 Y167.926 E.00296
G1 X184.526 Y168.054 E.01794
G1 X186.279 Y166.301 E.07642
G2 X186.28 Y165.765 I-1.845 J-.272 E.01659
G1 X183.99 Y168.055 E.09984
G1 X183.552 Y167.959 E.01385
G1 X186.184 Y165.327 E.11477
G1 X186.151 Y165.181 E.0046
G1 X186.151 Y164.825 E.01098
G1 X183.05 Y167.926 E.13517
G1 X182.515 Y167.926 E.01649
G1 X186.151 Y164.29 E.1585
G1 X186.151 Y163.755 E.01649
G1 X181.98 Y167.926 E.18182
G1 X181.445 Y167.926 E.01649
G1 X186.151 Y163.22 E.20515
G1 X186.151 Y162.685 E.01649
G1 X180.91 Y167.926 E.22847
G1 X180.375 Y167.926 E.01649
G1 X186.151 Y162.15 E.2518
G1 X186.151 Y161.615 E.01649
G1 X179.84 Y167.926 E.27512
G1 X179.305 Y167.926 E.01649
G1 X186.151 Y161.08 E.29845
G1 X186.151 Y160.545 E.01649
G1 X178.77 Y167.926 E.32177
G1 X178.235 Y167.926 E.01649
G1 X186.151 Y160.01 E.3451
G1 X186.151 Y159.475 E.01649
G1 X177.7 Y167.926 E.36842
G1 X177.165 Y167.926 E.01649
G1 X186.151 Y158.94 E.39175
G1 X186.151 Y158.405 E.01649
G1 X176.63 Y167.926 E.41507
G1 X176.095 Y167.926 E.01649
G1 X186.151 Y157.87 E.4384
G1 X186.151 Y157.335 E.01649
G1 X175.56 Y167.926 E.46172
G1 X175.025 Y167.926 E.01649
G1 X186.151 Y156.8 E.48504
G1 X186.151 Y156.265 E.01649
G1 X174.49 Y167.926 E.50837
G1 X173.955 Y167.926 E.01649
G1 X186.151 Y155.73 E.53169
G1 X186.151 Y155.195 E.01649
G1 X173.42 Y167.926 E.55502
G1 X172.885 Y167.926 E.01649
G1 X186.151 Y154.66 E.57834
G1 X186.151 Y154.125 E.01649
G1 X172.35 Y167.926 E.60167
G1 X171.815 Y167.926 E.01649
G1 X186.151 Y153.59 E.62499
G1 X186.151 Y153.055 E.01649
G1 X171.28 Y167.926 E.64832
G1 X170.745 Y167.926 E.01649
G1 X186.151 Y152.52 E.67164
G1 X186.151 Y151.985 E.01649
G1 X170.21 Y167.926 E.69497
G1 X169.675 Y167.926 E.01649
G1 X185.676 Y151.924 E.69759
G1 X185.141 Y151.924 E.01649
G1 X169.14 Y167.926 E.69759
G1 X168.605 Y167.926 E.01649
G1 X184.606 Y151.924 E.69759
G1 X184.071 Y151.924 E.01649
G1 X168.07 Y167.926 E.69759
G1 X167.535 Y167.926 E.01649
G1 X183.536 Y151.924 E.69759
G1 X183.001 Y151.924 E.01649
G1 X167 Y167.926 E.69759
G1 X166.594 Y167.926 E.0125
G1 X166.426 Y167.964 E.00531
G1 X182.466 Y151.924 E.69928
G1 X181.931 Y151.924 E.01649
G1 X165.783 Y168.072 E.70397
G3 X165.303 Y168.017 I.012 J-2.234 E.01493
G1 X181.396 Y151.924 E.70158
G1 X180.861 Y151.924 E.01649
G1 X164.86 Y167.926 E.69759
G1 X164.325 Y167.926 E.01649
G1 X180.326 Y151.924 E.69759
G1 X179.791 Y151.924 E.01649
G1 X163.849 Y167.866 E.69498
G1 X163.849 Y167.331 E.01649
G1 X179.256 Y151.924 E.67166
G1 X178.721 Y151.924 E.01649
G1 X163.836 Y166.809 E.64893
G1 X163.736 Y166.374 E.01376
G1 X178.186 Y151.924 E.62997
G1 X177.651 Y151.924 E.01649
G1 X163.713 Y165.862 E.60765
G1 X163.722 Y165.737 E.00388
G1 X163.847 Y165.193 E.01719
G1 X177.116 Y151.924 E.57848
G1 X176.581 Y151.924 E.01649
G1 X163.849 Y164.656 E.55503
G1 X163.849 Y164.121 E.01649
G1 X176.046 Y151.924 E.53171
G1 X175.511 Y151.924 E.01649
G1 X163.849 Y163.586 E.50838
G1 X163.849 Y163.051 E.01649
G1 X174.976 Y151.924 E.48506
G1 X174.441 Y151.924 E.01649
G1 X163.849 Y162.516 E.46173
G1 X163.849 Y161.981 E.01649
G1 X173.906 Y151.924 E.43841
G1 X173.371 Y151.924 E.01649
G1 X163.849 Y161.446 E.41509
G1 X163.849 Y160.911 E.01649
G1 X172.836 Y151.924 E.39176
G1 X172.3 Y151.924 E.01649
G1 X163.849 Y160.375 E.36844
G1 X163.849 Y159.84 E.01649
G1 X171.765 Y151.924 E.34511
G1 X171.23 Y151.924 E.01649
G1 X163.849 Y159.305 E.32179
G1 X163.849 Y158.77 E.01649
G1 X170.695 Y151.924 E.29846
G1 X170.16 Y151.924 E.01649
G1 X163.849 Y158.235 E.27514
G1 X163.849 Y157.7 E.01649
M73 P41 R9
G1 X169.625 Y151.924 E.25181
G1 X169.09 Y151.924 E.01649
G1 X163.849 Y157.165 E.22849
G1 X163.849 Y156.63 E.01649
G1 X168.555 Y151.924 E.20516
G1 X168.02 Y151.924 E.01649
G1 X163.849 Y156.095 E.18184
G1 X163.849 Y155.56 E.01649
G1 X167.485 Y151.924 E.15851
G1 X166.95 Y151.924 E.01649
G1 X163.849 Y155.025 E.13519
G1 X163.849 Y154.49 E.01649
G1 X166.415 Y151.924 E.11187
G1 X165.88 Y151.924 E.01649
G1 X163.849 Y153.955 E.08854
G1 X163.849 Y153.42 E.01649
G1 X165.345 Y151.924 E.06522
G1 X164.81 Y151.924 E.01649
G1 X163.849 Y152.885 E.04189
G1 X163.849 Y152.35 E.01649
G1 X164.445 Y151.755 E.02596
; CHANGE_LAYER
; Z_HEIGHT: 1
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9516.005
G1 X163.849 Y152.35 E-.32004
G1 X163.849 Y152.885 E-.2033
G1 X164.29 Y152.445 E-.23665
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 5/85
; update layer progress
M73 L5
M991 S0 P4 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z1.2 I-.706 J.991 P1  F60000
G1 X186.484 Y168.259 Z1.2
G1 Z1
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X185.132 Y168.259 E.04484
G3 X183.368 Y168.259 I-.882 J-2.534 E.05964
G1 X166.632 Y168.259 E.55515
G3 X164.868 Y168.259 I-.882 J-2.534 E.05964
G1 X163.516 Y168.259 E.04484
G1 X163.516 Y166.907 E.04484
G3 X163.516 Y165.143 I2.534 J-.882 E.05963
G1 X163.516 Y151.591 E.44953
G1 X186.484 Y151.591 E.76188
G1 X186.484 Y165.143 E.44953
G3 X186.484 Y166.907 I-2.534 J.882 E.05963
G1 X186.484 Y168.199 E.04285
; COOLING_NODE: 0
M204 S10000
G1 X186.891 Y168.666 F60000
G1 F8843.478
M204 S8000
G1 X185.183 Y168.666 E.05667
G3 X183.318 Y168.666 I-.933 J-2.84 E.06292
G1 X166.683 Y168.666 E.55181
G3 X164.818 Y168.666 I-.933 J-2.84 E.06292
G1 X163.109 Y168.666 E.05667
G1 X163.109 Y166.957 E.05667
G3 X163.109 Y165.093 I2.84 J-.932 E.06291
G1 X163.109 Y151.184 E.46137
G1 X186.891 Y151.184 E.78888
G1 X186.891 Y165.093 E.46137
G3 X186.891 Y166.957 I-2.84 J.932 E.06291
G1 X186.891 Y168.606 E.05468
; COOLING_NODE: 0
M204 S10000
G1 X187.298 Y169.073 F60000
G1 F8843.478
M204 S8000
G1 X185.233 Y169.073 E.0685
G3 X183.267 Y169.073 I-.983 J-3.163 E.0662
G1 X166.733 Y169.073 E.54847
G3 X164.767 Y169.073 I-.983 J-3.163 E.0662
G1 X162.702 Y169.073 E.0685
G1 X162.702 Y167.008 E.0685
G3 X162.702 Y165.042 I3.163 J-.983 E.0662
G1 X162.702 Y150.777 E.4732
G1 X187.298 Y150.777 E.81589
G1 X187.298 Y165.042 E.4732
G3 X187.298 Y167.008 I-3.163 J.983 E.0662
G1 X187.298 Y169.013 E.06651
; COOLING_NODE: 0
M204 S250
G1 X187.69 Y169.465 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3969
M204 S5000
G1 X185.281 Y169.465 E.07401
G3 X183.219 Y169.465 I-1.031 J-3.49 E.06426
G1 X166.781 Y169.465 E.50507
G3 X164.719 Y169.465 I-1.031 J-3.49 E.06426
G1 X162.31 Y169.465 E.07401
G1 X162.31 Y167.056 E.07401
G3 X162.31 Y164.994 I3.49 J-1.031 E.06426
G1 X162.31 Y150.385 E.44888
G1 X187.69 Y150.385 E.77986
G1 X187.69 Y164.994 E.44888
G3 X187.69 Y167.056 I-3.49 J1.031 E.06426
G1 X187.69 Y169.405 E.07217
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

; WIPE_START
G1 F9547.055
M204 S8000
G1 X185.691 Y169.455 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X185.974 Y161.828 Z1.4 F60000
G1 X186.32 Y152.52 Z1.4
G1 Z1
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42123
G1 F9516.005
M204 S8000
G1 X185.725 Y151.924 E.02595
G1 X185.19 Y151.924 E.01649
G1 X186.151 Y152.885 E.04188
G1 X186.151 Y153.42 E.01649
G1 X184.655 Y151.924 E.0652
G1 X184.12 Y151.924 E.01649
G1 X186.151 Y153.955 E.08853
G1 X186.151 Y154.49 E.01649
G1 X183.585 Y151.924 E.11185
G1 X183.05 Y151.924 E.01649
G1 X186.151 Y155.025 E.13517
G1 X186.151 Y155.56 E.01649
G1 X182.515 Y151.924 E.1585
G1 X181.98 Y151.924 E.01649
G1 X186.151 Y156.095 E.18182
G1 X186.151 Y156.63 E.01649
G1 X181.445 Y151.924 E.20515
G1 X180.91 Y151.924 E.01649
G1 X186.151 Y157.165 E.22847
G1 X186.151 Y157.7 E.01649
G1 X180.375 Y151.924 E.2518
G1 X179.84 Y151.924 E.01649
G1 X186.151 Y158.235 E.27512
G1 X186.151 Y158.77 E.01649
G1 X179.305 Y151.924 E.29845
G1 X178.77 Y151.924 E.01649
G1 X186.151 Y159.305 E.32177
G1 X186.151 Y159.84 E.01649
G1 X178.235 Y151.924 E.3451
G1 X177.7 Y151.924 E.01649
G1 X186.151 Y160.375 E.36842
G1 X186.151 Y160.91 E.01649
G1 X177.165 Y151.924 E.39175
G1 X176.63 Y151.924 E.01649
G1 X186.151 Y161.445 E.41507
G1 X186.151 Y161.98 E.01649
G1 X176.095 Y151.924 E.4384
G1 X175.56 Y151.924 E.01649
G1 X186.151 Y162.515 E.46172
G1 X186.151 Y163.05 E.01649
G1 X175.025 Y151.924 E.48504
G1 X174.49 Y151.924 E.01649
G1 X186.151 Y163.585 E.50837
G1 X186.151 Y164.12 E.01649
G1 X173.955 Y151.924 E.53169
G1 X173.42 Y151.924 E.01649
G1 X186.151 Y164.655 E.55502
G1 X186.153 Y165.193 E.01658
G1 X172.885 Y151.924 E.57847
G1 X172.35 Y151.924 E.01649
G1 X186.287 Y165.862 E.60763
G3 X186.264 Y166.374 I-2.043 J.164 E.01584
G1 X171.815 Y151.924 E.62995
G1 X171.28 Y151.924 E.01649
G1 X186.164 Y166.809 E.64892
G1 X186.151 Y166.869 E.00191
G1 X186.151 Y167.33 E.01421
G1 X170.745 Y151.924 E.67164
G1 X170.21 Y151.924 E.01649
G1 X186.151 Y167.865 E.69497
G1 X186.151 Y167.926 E.00186
G1 X185.676 Y167.926 E.01464
G1 X169.675 Y151.924 E.69759
G1 X169.14 Y151.924 E.01649
G1 X185.141 Y167.926 E.69759
G1 X184.697 Y168.017 E.01397
G1 X168.605 Y151.924 E.70157
G1 X168.07 Y151.924 E.01649
G1 X184.217 Y168.072 E.70398
G3 X183.574 Y167.964 I.028 J-2.14 E.02017
G1 X167.535 Y151.924 E.69928
G1 X167 Y151.924 E.01649
G1 X183.001 Y167.926 E.69759
G1 X182.466 Y167.926 E.01649
G1 X166.465 Y151.924 E.69759
G1 X165.93 Y151.924 E.01649
G1 X181.931 Y167.926 E.69759
G1 X181.396 Y167.926 E.01649
G1 X165.395 Y151.924 E.69759
G1 X164.86 Y151.924 E.01649
G1 X180.861 Y167.926 E.69759
G1 X180.326 Y167.926 E.01649
G1 X164.325 Y151.924 E.69759
G1 X163.849 Y151.924 E.01465
G1 X163.849 Y151.984 E.00185
G1 X179.791 Y167.926 E.69498
M73 P42 R9
G1 X179.256 Y167.926 E.01649
G1 X163.849 Y152.519 E.67166
G1 X163.849 Y153.054 E.01649
G1 X178.721 Y167.926 E.64833
G1 X178.186 Y167.926 E.01649
G1 X163.849 Y153.589 E.62501
G1 X163.849 Y154.124 E.01649
G1 X177.651 Y167.926 E.60168
G1 X177.116 Y167.926 E.01649
G1 X163.849 Y154.659 E.57836
G1 X163.849 Y155.194 E.01649
G1 X176.581 Y167.926 E.55503
G1 X176.046 Y167.926 E.01649
G1 X163.849 Y155.729 E.53171
G1 X163.849 Y156.264 E.01649
G1 X175.511 Y167.926 E.50838
G1 X174.976 Y167.926 E.01649
G1 X163.849 Y156.799 E.48506
G1 X163.849 Y157.334 E.01649
G1 X174.441 Y167.926 E.46174
G1 X173.906 Y167.926 E.01649
G1 X163.849 Y157.869 E.43841
G1 X163.849 Y158.405 E.01649
G1 X173.371 Y167.926 E.41509
G1 X172.836 Y167.926 E.01649
G1 X163.849 Y158.94 E.39176
G1 X163.849 Y159.475 E.01649
G1 X172.301 Y167.926 E.36844
G1 X171.765 Y167.926 E.01649
G1 X163.849 Y160.01 E.34511
G1 X163.849 Y160.545 E.01649
G1 X171.23 Y167.926 E.32179
G1 X170.695 Y167.926 E.01649
G1 X163.849 Y161.08 E.29846
G1 X163.849 Y161.615 E.01649
G1 X170.16 Y167.926 E.27514
G1 X169.625 Y167.926 E.01649
G1 X163.849 Y162.15 E.25181
G1 X163.849 Y162.685 E.01649
G1 X169.09 Y167.926 E.22849
G1 X168.555 Y167.926 E.01649
G1 X163.849 Y163.22 E.20516
G1 X163.849 Y163.755 E.01649
G1 X168.02 Y167.926 E.18184
G1 X167.485 Y167.926 E.01649
G1 X163.849 Y164.29 E.15851
G1 X163.849 Y164.825 E.01649
G1 X166.95 Y167.926 E.13519
G1 X166.594 Y167.926 E.01097
G1 X166.449 Y167.959 E.00461
G1 X163.816 Y165.326 E.11478
G1 X163.72 Y165.765 E.01384
G1 X166.01 Y168.055 E.09987
G3 X165.474 Y168.054 I-.264 J-1.85 E.01658
G1 X163.721 Y166.301 E.07644
G1 X163.849 Y166.869 E.01797
G1 X163.849 Y166.965 E.00294
G1 X164.81 Y167.926 E.04189
G1 X164.275 Y167.926 E.01649
G1 X163.68 Y167.33 E.02596
; CHANGE_LAYER
; Z_HEIGHT: 1.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9516.005
G1 X164.275 Y167.926 E-.32004
G1 X164.81 Y167.926 E-.2033
G1 X164.37 Y167.485 E-.23665
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 6/85
; update layer progress
M73 L6
M991 S0 P5 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z1.4 I-.043 J1.216 P1  F60000
G1 X186.484 Y168.259 Z1.4
G1 Z1.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X185.132 Y168.259 E.04484
G3 X183.368 Y168.259 I-.882 J-2.532 E.05963
G1 X166.632 Y168.259 E.55516
G3 X164.868 Y168.259 I-.882 J-2.532 E.05963
G1 X163.516 Y168.259 E.04484
G1 X163.516 Y166.907 E.04484
G3 X163.516 Y165.143 I2.531 J-.882 E.05963
G1 X163.516 Y151.591 E.44954
G1 X186.484 Y151.591 E.76188
G1 X186.484 Y165.143 E.44954
G3 X186.484 Y166.907 I-2.531 J.882 E.05963
G1 X186.484 Y168.199 E.04285
; COOLING_NODE: 0
M204 S10000
G1 X186.891 Y168.666 F60000
G1 F8843.478
M204 S8000
G1 X185.182 Y168.666 E.05668
G3 X183.318 Y168.666 I-.932 J-2.837 E.06291
G1 X166.682 Y168.666 E.55182
G3 X164.818 Y168.666 I-.932 J-2.837 E.06291
G1 X163.109 Y168.666 E.05668
G1 X163.109 Y166.957 E.05668
G3 X163.109 Y165.093 I2.837 J-.932 E.06291
G1 X163.109 Y151.184 E.46137
G1 X186.891 Y151.184 E.78888
G1 X186.891 Y165.093 E.46137
G3 X186.891 Y166.957 I-2.837 J.932 E.06291
G1 X186.891 Y168.606 E.05469
; COOLING_NODE: 0
M204 S10000
G1 X187.298 Y169.073 F60000
G1 F8843.478
M204 S8000
G1 X185.233 Y169.073 E.06851
G3 X183.267 Y169.073 I-.983 J-3.16 E.06619
G1 X166.733 Y169.073 E.54848
G3 X164.767 Y169.073 I-.983 J-3.16 E.06619
G1 X162.702 Y169.073 E.06851
G1 X162.702 Y167.008 E.06851
G3 X162.702 Y165.042 I3.16 J-.983 E.06619
G1 X162.702 Y150.777 E.47321
G1 X187.298 Y150.777 E.81589
G1 X187.298 Y165.042 E.4732
G3 X187.298 Y167.008 I-3.16 J.983 E.06619
G1 X187.298 Y169.013 E.06652
; COOLING_NODE: 0
M204 S250
G1 X187.69 Y169.465 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3856
M204 S5000
G1 X185.281 Y169.465 E.07402
G3 X183.219 Y169.465 I-1.031 J-3.487 E.06425
G1 X166.781 Y169.465 E.50508
G3 X164.719 Y169.465 I-1.031 J-3.487 E.06425
G1 X162.31 Y169.465 E.07402
G1 X162.31 Y167.056 E.07402
G3 X162.31 Y164.994 I3.487 J-1.031 E.06425
G1 X162.31 Y150.385 E.44889
G1 X187.69 Y150.385 E.77986
G1 X187.69 Y164.994 E.44889
G3 X187.69 Y167.056 I-3.487 J1.031 E.06425
G1 X187.69 Y169.405 E.07217
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

; WIPE_START
G1 F9547.055
M204 S8000
G1 X185.691 Y169.455 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X185.549 Y168.095 Z1.6 F60000
G1 Z1.2
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42427
G1 F9440.146
M204 S8000
G1 X186.151 Y167.494 E.02644
G1 X186.151 Y166.954 E.01676
G1 X185.179 Y167.926 E.04268
G1 X185.094 Y167.926 E.00265
G1 X184.51 Y168.056 E.0186
G1 X186.281 Y166.285 E.07782
G2 X186.279 Y165.747 I-1.868 J-.264 E.01677
G1 X183.972 Y168.055 E.1014
G1 X183.532 Y167.955 E.01401
G1 X186.18 Y165.307 E.11634
G1 X186.151 Y165.181 E.00404
G1 X186.151 Y164.797 E.01192
G1 X183.022 Y167.926 E.13749
G1 X182.483 Y167.926 E.01676
G1 X186.151 Y164.258 E.16119
G1 X186.151 Y163.719 E.01676
G1 X181.944 Y167.926 E.18489
G1 X181.404 Y167.926 E.01676
G1 X186.151 Y163.179 E.20859
G1 X186.151 Y162.64 E.01676
G1 X180.865 Y167.926 E.23229
G1 X180.326 Y167.926 E.01676
G1 X186.151 Y162.101 E.25599
G1 X186.151 Y161.561 E.01676
G1 X179.786 Y167.926 E.2797
G1 X179.247 Y167.926 E.01676
G1 X186.151 Y161.022 E.3034
G1 X186.151 Y160.483 E.01676
G1 X178.708 Y167.926 E.3271
G1 X178.168 Y167.926 E.01676
G1 X186.151 Y159.943 E.3508
G1 X186.151 Y159.404 E.01676
G1 X177.629 Y167.926 E.3745
G1 X177.09 Y167.926 E.01676
G1 X186.151 Y158.865 E.3982
G1 X186.151 Y158.326 E.01676
G1 X176.551 Y167.926 E.4219
G1 X176.011 Y167.926 E.01676
G1 X186.151 Y157.786 E.4456
G1 X186.151 Y157.247 E.01676
G1 X175.472 Y167.926 E.4693
G1 X174.933 Y167.926 E.01676
G1 X186.151 Y156.708 E.493
G1 X186.151 Y156.168 E.01676
G1 X174.393 Y167.926 E.51671
G1 X173.854 Y167.926 E.01676
G1 X186.151 Y155.629 E.54041
G1 X186.151 Y155.09 E.01676
G1 X173.315 Y167.926 E.56411
G1 X172.775 Y167.926 E.01676
G1 X186.151 Y154.55 E.58781
G1 X186.151 Y154.265 E.00885
G1 X185.896 Y154.265 E.00791
G1 X172.236 Y167.926 E.60033
G1 X171.697 Y167.926 E.01676
G1 X185.357 Y154.265 E.60033
G1 X184.818 Y154.265 E.01676
G1 X171.157 Y167.926 E.60033
G1 X170.618 Y167.926 E.01676
G1 X184.278 Y154.265 E.60033
G1 X183.739 Y154.265 E.01676
M73 P43 R9
G1 X170.079 Y167.926 E.60033
G1 X169.539 Y167.926 E.01676
G1 X183.2 Y154.265 E.60033
G1 X182.661 Y154.265 E.01676
G1 X169 Y167.926 E.60033
G1 X168.461 Y167.926 E.01676
G1 X182.121 Y154.265 E.60033
G1 X181.582 Y154.265 E.01676
G1 X167.922 Y167.926 E.60033
G1 X167.382 Y167.926 E.01676
G1 X181.043 Y154.265 E.60033
G1 X180.503 Y154.265 E.01676
G1 X166.843 Y167.926 E.60033
G1 X166.594 Y167.926 E.00772
G1 X166.217 Y168.012 E.01203
G1 X179.964 Y154.265 E.60413
G1 X179.425 Y154.265 E.01676
G1 X165.624 Y168.066 E.60648
G3 X165.165 Y167.985 I.033 J-1.537 E.01453
G1 X178.885 Y154.265 E.60295
G1 X178.346 Y154.265 E.01676
G1 X164.686 Y167.926 E.60033
G1 X164.146 Y167.926 E.01676
G1 X177.807 Y154.265 E.60033
G1 X177.267 Y154.265 E.01676
G1 X163.849 Y167.684 E.58969
G1 X163.849 Y167.144 E.01676
G1 X176.728 Y154.265 E.56598
G1 X176.189 Y154.265 E.01676
G1 X163.8 Y166.654 E.54445
G3 X163.713 Y166.201 I1.402 J-.503 E.01438
G1 X175.649 Y154.265 E.52455
G1 X175.11 Y154.265 E.01676
G1 X163.747 Y165.629 E.4994
G1 X163.849 Y165.181 E.01429
G1 X163.849 Y164.987 E.00602
G1 X174.571 Y154.265 E.47118
G1 X174.032 Y154.265 E.01676
G1 X163.849 Y164.448 E.44748
G1 X163.849 Y163.908 E.01676
G1 X173.492 Y154.265 E.42378
G1 X172.953 Y154.265 E.01676
G1 X163.849 Y163.369 E.40008
G1 X163.849 Y162.83 E.01676
G1 X172.414 Y154.265 E.37638
G1 X171.874 Y154.265 E.01676
G1 X163.849 Y162.29 E.35267
G1 X163.849 Y161.751 E.01676
G1 X171.335 Y154.265 E.32897
G1 X170.796 Y154.265 E.01676
G1 X163.849 Y161.212 E.30527
G1 X163.849 Y160.672 E.01676
G1 X170.256 Y154.265 E.28157
G1 X169.717 Y154.265 E.01676
G1 X163.849 Y160.133 E.25787
G1 X163.849 Y159.594 E.01676
G1 X169.178 Y154.265 E.23417
G1 X168.638 Y154.265 E.01676
G1 X163.849 Y159.055 E.21047
G1 X163.849 Y158.515 E.01676
G1 X168.099 Y154.265 E.18677
G1 X167.56 Y154.265 E.01676
G1 X163.849 Y157.976 E.16307
G1 X163.849 Y157.437 E.01676
G1 X167.02 Y154.265 E.13937
G1 X166.481 Y154.265 E.01676
G1 X163.849 Y156.897 E.11566
G1 X163.849 Y156.358 E.01676
G1 X165.942 Y154.265 E.09196
G1 X165.403 Y154.265 E.01676
G1 X163.849 Y155.819 E.06826
G1 X163.849 Y155.279 E.01676
G1 X164.863 Y154.265 E.04456
G1 X164.324 Y154.265 E.01676
G1 X163.68 Y154.91 E.02832
M204 S10000
G1 X163.864 Y153.586 F60000
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X163.864 Y153.873 E.00953
G1 X165.205 Y153.873 E.04448
G1 X165.828 Y153.337 E.02725
G3 X167.793 Y152.996 I1.209 J1.133 E.07101
G2 X168.886 Y153.873 I5.455 J-5.672 E.04656
G1 X170.447 Y153.873 E.05177
G1 X171.069 Y153.337 E.02725
G3 X173.035 Y152.996 I1.209 J1.133 E.07101
G2 X174.127 Y153.873 I5.455 J-5.672 E.04655
G1 X175.688 Y153.873 E.05177
G1 X176.311 Y153.337 E.02725
G3 X178.276 Y152.996 I1.209 J1.133 E.07101
G2 X179.369 Y153.873 I5.455 J-5.672 E.04656
G1 X180.929 Y153.873 E.05177
G1 X181.552 Y153.337 E.02725
G3 X183.517 Y152.996 I1.209 J1.133 E.07101
G2 X184.61 Y153.873 I5.455 J-5.672 E.04655
G1 X186.136 Y153.873 E.05061
G1 X186.136 Y153.771 E.00341
M204 S10000
G1 X163.959 Y152.034 F60000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.52142
G1 F7523.511
M204 S8000
G1 X185.981 Y152.034 E.85868
; CHANGE_LAYER
; Z_HEIGHT: 1.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F7523.511
G1 X183.981 Y152.034 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 7/85
; update layer progress
M73 L7
M991 S0 P6 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z1.6 I-1.203 J.186 P1  F60000
G1 X186.484 Y168.259 Z1.6
G1 Z1.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X185.132 Y168.259 E.04484
G3 X183.368 Y168.259 I-.882 J-2.645 E.05955
G1 X166.632 Y168.259 E.55515
G3 X164.868 Y168.259 I-.882 J-2.645 E.05955
G1 X163.516 Y168.259 E.04484
G1 X163.516 Y166.907 E.04484
G3 X163.516 Y165.143 I2.645 J-.882 E.05955
G1 X163.516 Y151.591 E.44953
G1 X186.484 Y151.591 E.76188
G1 X186.484 Y165.143 E.44953
G3 X186.484 Y166.907 I-2.645 J.882 E.05955
G1 X186.484 Y168.199 E.04284
; COOLING_NODE: 0
M204 S10000
G1 X186.891 Y168.666 F60000
G1 F8843.478
M204 S8000
G1 X185.182 Y168.666 E.05667
G3 X183.318 Y168.666 I-.932 J-2.98 E.06282
G1 X166.682 Y168.666 E.55182
G3 X164.818 Y168.666 I-.932 J-2.98 E.06282
G1 X163.109 Y168.666 E.05667
G1 X163.109 Y166.957 E.05667
G3 X163.109 Y165.093 I2.98 J-.932 E.06282
G1 X163.109 Y151.184 E.46137
G1 X186.891 Y151.184 E.78888
G1 X186.891 Y165.093 E.46137
G3 X186.891 Y166.957 I-2.98 J.932 E.06282
G1 X186.891 Y168.606 E.05468
; COOLING_NODE: 0
M204 S10000
G1 X187.298 Y169.073 F60000
G1 F8843.478
M204 S8000
G1 X185.233 Y169.073 E.06851
G3 X183.267 Y169.073 I-.983 J-3.336 E.0661
G1 X166.733 Y169.073 E.54848
G3 X164.767 Y169.073 I-.983 J-3.336 E.0661
G1 X162.702 Y169.073 E.06851
G1 X162.702 Y167.008 E.06851
G3 X162.702 Y165.042 I3.336 J-.983 E.0661
G1 X162.702 Y150.777 E.4732
G1 X187.298 Y150.777 E.81589
G1 X187.298 Y165.042 E.4732
G3 X187.298 Y167.008 I-3.336 J.983 E.0661
G1 X187.298 Y169.013 E.06652
; COOLING_NODE: 0
M204 S250
G1 X187.69 Y169.465 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3726
M204 S5000
G1 X185.281 Y169.465 E.07402
G3 X183.219 Y169.465 I-1.031 J-3.699 E.06416
G1 X166.781 Y169.465 E.50508
G3 X164.719 Y169.465 I-1.031 J-3.699 E.06416
G1 X162.31 Y169.465 E.07402
G1 X162.31 Y167.056 E.07402
G3 X162.31 Y164.994 I3.699 J-1.031 E.06416
G1 X162.31 Y150.385 E.44889
G1 X187.69 Y150.385 E.77986
G1 X187.69 Y164.994 E.44889
G3 X187.69 Y167.056 I-3.699 J1.031 E.06416
G1 X187.69 Y169.405 E.07217
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

; WIPE_START
G1 F9547.055
M204 S8000
G1 X185.691 Y169.455 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X185.974 Y161.828 Z1.8 F60000
G1 X186.32 Y152.52 Z1.8
G1 Z1.4
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42123
G1 F9516.005
M204 S8000
G1 X185.725 Y151.924 E.02595
G1 X185.19 Y151.924 E.01649
G1 X186.151 Y152.885 E.04188
G1 X186.151 Y153.42 E.01649
G1 X184.655 Y151.924 E.0652
G1 X184.12 Y151.924 E.01649
G1 X186.151 Y153.955 E.08853
G1 X186.151 Y154.49 E.01649
G1 X183.585 Y151.924 E.11185
G1 X183.05 Y151.924 E.01649
G1 X186.151 Y155.025 E.13517
G1 X186.151 Y155.56 E.01649
G1 X182.515 Y151.924 E.1585
G1 X181.98 Y151.924 E.01649
G1 X186.151 Y156.095 E.18182
G1 X186.151 Y156.63 E.01649
G1 X181.445 Y151.924 E.20515
G1 X180.91 Y151.924 E.01649
G1 X186.151 Y157.165 E.22847
G1 X186.151 Y157.7 E.01649
G1 X180.375 Y151.924 E.2518
G1 X179.84 Y151.924 E.01649
G1 X186.151 Y158.235 E.27512
G1 X186.151 Y158.77 E.01649
M73 P44 R9
G1 X179.305 Y151.924 E.29845
G1 X178.77 Y151.924 E.01649
G1 X186.151 Y159.305 E.32177
G1 X186.151 Y159.84 E.01649
G1 X178.235 Y151.924 E.3451
G1 X177.7 Y151.924 E.01649
G1 X186.151 Y160.375 E.36842
G1 X186.151 Y160.91 E.01649
G1 X177.165 Y151.924 E.39175
G1 X176.63 Y151.924 E.01649
G1 X186.151 Y161.445 E.41507
G1 X186.151 Y161.98 E.01649
G1 X176.095 Y151.924 E.4384
G1 X175.56 Y151.924 E.01649
G1 X186.151 Y162.515 E.46172
G1 X186.151 Y163.05 E.01649
G1 X175.025 Y151.924 E.48505
G1 X174.49 Y151.924 E.01649
G1 X186.151 Y163.585 E.50837
G1 X186.151 Y164.12 E.01649
G1 X173.955 Y151.924 E.53169
G1 X173.42 Y151.924 E.01649
G1 X186.151 Y164.655 E.55502
G1 X186.154 Y165.193 E.01658
G1 X172.885 Y151.924 E.57847
G1 X172.35 Y151.924 E.01649
G1 X186.288 Y165.862 E.60764
G3 X186.264 Y166.374 I-2.058 J.162 E.01583
G1 X171.815 Y151.924 E.62994
G1 X171.28 Y151.924 E.01649
G1 X186.165 Y166.809 E.64892
G1 X186.151 Y166.87 E.00191
G1 X186.151 Y167.33 E.0142
G1 X170.745 Y151.924 E.67164
G1 X170.21 Y151.924 E.01649
G1 X186.151 Y167.865 E.69497
G1 X186.151 Y167.926 E.00186
G1 X185.676 Y167.926 E.01463
G1 X169.675 Y151.924 E.6976
G1 X169.14 Y151.924 E.01649
G1 X185.141 Y167.926 E.6976
G1 X184.697 Y168.017 E.01397
G1 X168.605 Y151.924 E.70157
G1 X168.07 Y151.924 E.01649
G1 X184.217 Y168.072 E.70396
G3 X183.575 Y167.964 I.021 J-2.103 E.02015
G1 X167.535 Y151.924 E.69929
G1 X167 Y151.924 E.01649
G1 X183.001 Y167.926 E.6976
G1 X182.466 Y167.926 E.01649
G1 X166.465 Y151.924 E.6976
G1 X165.93 Y151.924 E.01649
G1 X181.931 Y167.926 E.6976
G1 X181.396 Y167.926 E.01649
G1 X165.395 Y151.924 E.6976
G1 X164.86 Y151.924 E.01649
G1 X180.861 Y167.926 E.6976
G1 X180.326 Y167.926 E.01649
G1 X164.325 Y151.924 E.6976
G1 X163.849 Y151.924 E.01465
G1 X163.849 Y151.984 E.00184
G1 X179.791 Y167.926 E.695
G1 X179.256 Y167.926 E.01649
G1 X163.849 Y152.519 E.67167
G1 X163.849 Y153.054 E.01649
G1 X178.721 Y167.926 E.64835
G1 X178.186 Y167.926 E.01649
G1 X163.849 Y153.589 E.62503
G1 X163.849 Y154.124 E.01649
G1 X177.651 Y167.926 E.6017
G1 X177.116 Y167.926 E.01649
G1 X163.849 Y154.659 E.57838
G1 X163.849 Y155.194 E.01649
G1 X176.581 Y167.926 E.55505
G1 X176.046 Y167.926 E.01649
G1 X163.849 Y155.729 E.53173
G1 X163.849 Y156.264 E.01649
G1 X175.511 Y167.926 E.5084
G1 X174.976 Y167.926 E.01649
G1 X163.849 Y156.799 E.48508
G1 X163.849 Y157.334 E.01649
G1 X174.441 Y167.926 E.46175
G1 X173.906 Y167.926 E.01649
G1 X163.849 Y157.869 E.43843
G1 X163.849 Y158.404 E.01649
G1 X173.371 Y167.926 E.4151
G1 X172.836 Y167.926 E.01649
G1 X163.849 Y158.939 E.39178
G1 X163.849 Y159.474 E.01649
G1 X172.301 Y167.926 E.36845
G1 X171.766 Y167.926 E.01649
G1 X163.849 Y160.009 E.34513
G1 X163.849 Y160.544 E.01649
G1 X171.231 Y167.926 E.3218
G1 X170.696 Y167.926 E.01649
G1 X163.849 Y161.079 E.29848
G1 X163.849 Y161.614 E.01649
G1 X170.161 Y167.926 E.27516
G1 X169.626 Y167.926 E.01649
G1 X163.849 Y162.149 E.25183
G1 X163.849 Y162.684 E.01649
G1 X169.091 Y167.926 E.22851
G1 X168.556 Y167.926 E.01649
G1 X163.849 Y163.219 E.20518
G1 X163.849 Y163.754 E.01649
G1 X168.021 Y167.926 E.18186
G1 X167.486 Y167.926 E.01649
G1 X163.849 Y164.289 E.15853
G1 X163.849 Y164.824 E.01649
G1 X166.951 Y167.926 E.13521
G1 X166.595 Y167.926 E.01098
G1 X166.449 Y167.959 E.0046
G1 X163.816 Y165.326 E.11479
G1 X163.719 Y165.764 E.01384
G1 X166.011 Y168.056 E.0999
G3 X165.475 Y168.055 I-.264 J-1.906 E.01658
G1 X163.72 Y166.3 E.07648
G1 X163.849 Y166.87 E.01799
G1 X163.849 Y166.964 E.00292
G1 X164.811 Y167.926 E.04191
G1 X164.276 Y167.926 E.01649
G1 X163.68 Y167.33 E.02598
; CHANGE_LAYER
; Z_HEIGHT: 1.6
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9516.005
G1 X164.276 Y167.926 E-.32026
G1 X164.811 Y167.926 E-.2033
G1 X164.371 Y167.486 E-.23644
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 8/85
; update layer progress
M73 L8
M991 S0 P7 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z1.8 I-.043 J1.216 P1  F60000
G1 X186.484 Y168.259 Z1.8
G1 Z1.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X185.132 Y168.259 E.04484
G3 X183.368 Y168.259 I-.882 J-2.644 E.05955
G1 X166.632 Y168.259 E.55515
G3 X164.868 Y168.259 I-.882 J-2.644 E.05955
G1 X163.516 Y168.259 E.04484
G1 X163.516 Y166.907 E.04483
G3 X163.516 Y165.143 I2.644 J-.882 E.05955
G1 X163.516 Y151.591 E.44953
G1 X186.484 Y151.591 E.76188
G1 X186.484 Y165.143 E.44953
G3 X186.484 Y166.907 I-2.644 J.882 E.05956
G1 X186.484 Y168.199 E.04284
; COOLING_NODE: 0
M204 S10000
G1 X186.891 Y168.666 F60000
G1 F8843.478
M204 S8000
G1 X185.182 Y168.666 E.05667
G3 X183.318 Y168.666 I-.932 J-2.978 E.06282
G1 X166.682 Y168.666 E.55182
G3 X164.818 Y168.666 I-.932 J-2.978 E.06282
G1 X163.109 Y168.666 E.05667
G1 X163.109 Y166.958 E.05667
G3 X163.109 Y165.093 I2.978 J-.932 E.06283
G1 X163.109 Y151.184 E.46137
G1 X186.891 Y151.184 E.78888
G1 X186.891 Y165.092 E.46137
G3 X186.891 Y166.958 I-2.979 J.933 E.06283
G1 X186.891 Y168.606 E.05468
; COOLING_NODE: 0
M204 S10000
G1 X187.298 Y169.073 F60000
G1 F8843.478
M204 S8000
G1 X185.233 Y169.073 E.06851
G3 X183.267 Y169.073 I-.983 J-3.334 E.0661
G1 X166.733 Y169.073 E.54848
G3 X164.767 Y169.073 I-.983 J-3.334 E.0661
G1 X162.702 Y169.073 E.06851
G1 X162.702 Y167.008 E.06851
G3 X162.702 Y165.042 I3.334 J-.983 E.0661
G1 X162.702 Y150.777 E.4732
G1 X187.298 Y150.777 E.81589
G1 X187.298 Y165.042 E.4732
G3 X187.298 Y167.008 I-3.334 J.983 E.0661
G1 X187.298 Y169.013 E.06651
; COOLING_NODE: 0
M204 S250
G1 X187.69 Y169.465 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
M73 P45 R9
G1 F3583
M204 S5000
G1 X185.281 Y169.465 E.07402
G3 X183.219 Y169.465 I-1.031 J-3.697 E.06416
G1 X166.781 Y169.465 E.50509
G3 X164.719 Y169.465 I-1.031 J-3.697 E.06416
G1 X162.31 Y169.465 E.07402
G1 X162.31 Y167.056 E.07402
G3 X162.31 Y164.994 I3.697 J-1.031 E.06416
G1 X162.31 Y150.385 E.44889
G1 X187.69 Y150.385 E.77986
G1 X187.69 Y164.994 E.44889
G3 X187.69 Y167.056 I-3.697 J1.031 E.06416
G1 X187.69 Y169.405 E.07217
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

; WIPE_START
G1 F9547.055
M204 S8000
G1 X185.691 Y169.455 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X185.555 Y168.095 Z2 F60000
G1 Z1.6
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42123
G1 F9516.005
M204 S8000
G1 X186.151 Y167.5 E.02595
G1 X186.151 Y166.965 E.01649
G1 X185.19 Y167.926 E.04188
G1 X185.095 Y167.926 E.00294
G1 X184.526 Y168.055 E.01797
G1 X186.28 Y166.301 E.07645
G2 X186.281 Y165.765 I-1.908 J-.272 E.01658
G1 X183.99 Y168.056 E.09987
G1 X183.552 Y167.959 E.01384
G1 X186.184 Y165.327 E.11477
G1 X186.151 Y165.18 E.00462
G1 X186.151 Y164.825 E.01096
G1 X183.05 Y167.926 E.13518
G1 X182.515 Y167.926 E.01649
G1 X186.151 Y164.29 E.1585
G1 X186.151 Y163.755 E.01649
G1 X181.98 Y167.926 E.18182
G1 X181.445 Y167.926 E.01649
G1 X186.151 Y163.22 E.20515
G1 X186.151 Y162.685 E.01649
G1 X180.91 Y167.926 E.22847
G1 X180.375 Y167.926 E.01649
G1 X186.151 Y162.15 E.2518
G1 X186.151 Y161.615 E.01649
G1 X179.84 Y167.926 E.27512
G1 X179.305 Y167.926 E.01649
G1 X186.151 Y161.08 E.29845
G1 X186.151 Y160.545 E.01649
G1 X178.77 Y167.926 E.32177
G1 X178.235 Y167.926 E.01649
G1 X186.151 Y160.01 E.3451
G1 X186.151 Y159.475 E.01649
G1 X177.7 Y167.926 E.36842
G1 X177.165 Y167.926 E.01649
G1 X186.151 Y158.94 E.39175
G1 X186.151 Y158.405 E.01649
G1 X176.63 Y167.926 E.41507
G1 X176.095 Y167.926 E.01649
G1 X186.151 Y157.87 E.4384
G1 X186.151 Y157.335 E.01649
G1 X175.56 Y167.926 E.46172
G1 X175.025 Y167.926 E.01649
G1 X186.151 Y156.8 E.48505
G1 X186.151 Y156.265 E.01649
G1 X174.49 Y167.926 E.50837
G1 X173.955 Y167.926 E.01649
G1 X186.151 Y155.73 E.53169
G1 X186.151 Y155.195 E.01649
G1 X173.42 Y167.926 E.55502
G1 X172.885 Y167.926 E.01649
G1 X186.151 Y154.66 E.57834
G1 X186.151 Y154.125 E.01649
G1 X172.35 Y167.926 E.60167
G1 X171.815 Y167.926 E.01649
G1 X186.151 Y153.59 E.62499
G1 X186.151 Y153.055 E.01649
G1 X171.28 Y167.926 E.64832
G1 X170.745 Y167.926 E.01649
G1 X186.151 Y152.52 E.67164
G1 X186.151 Y151.985 E.01649
G1 X170.21 Y167.926 E.69497
G1 X169.675 Y167.926 E.01649
G1 X185.676 Y151.924 E.69759
G1 X185.141 Y151.924 E.01649
G1 X169.14 Y167.926 E.69759
G1 X168.605 Y167.926 E.01649
G1 X184.606 Y151.924 E.69759
G1 X184.071 Y151.924 E.01649
G1 X168.07 Y167.926 E.69759
G1 X167.535 Y167.926 E.01649
G1 X183.536 Y151.924 E.69759
G1 X183.001 Y151.924 E.01649
G1 X167 Y167.926 E.69759
G1 X166.595 Y167.926 E.01249
G1 X166.426 Y167.964 E.00533
G1 X182.466 Y151.924 E.69927
G1 X181.931 Y151.924 E.01649
G1 X165.784 Y168.072 E.70396
G3 X165.304 Y168.017 I.006 J-2.181 E.01493
M73 P45 R8
G1 X181.396 Y151.924 E.70156
G1 X180.861 Y151.924 E.01649
G1 X164.86 Y167.926 E.69759
G1 X164.325 Y167.926 E.01649
G1 X180.326 Y151.924 E.69759
G1 X179.791 Y151.924 E.01649
G1 X163.849 Y167.866 E.69498
G1 X163.849 Y167.331 E.01649
G1 X179.256 Y151.924 E.67166
G1 X178.721 Y151.924 E.01649
G1 X163.836 Y166.809 E.64893
G1 X163.736 Y166.374 E.01377
G1 X178.186 Y151.924 E.62995
G1 X177.651 Y151.924 E.01649
G1 X163.713 Y165.863 E.60765
G1 X163.721 Y165.743 E.00371
G1 X163.846 Y165.194 E.01736
G1 X177.116 Y151.924 E.57849
G1 X176.581 Y151.924 E.01649
G1 X163.849 Y164.656 E.55503
G1 X163.849 Y164.121 E.01649
G1 X176.046 Y151.924 E.53171
G1 X175.511 Y151.924 E.01649
G1 X163.849 Y163.586 E.50838
G1 X163.849 Y163.051 E.01649
G1 X174.976 Y151.924 E.48506
G1 X174.441 Y151.924 E.01649
G1 X163.849 Y162.516 E.46174
G1 X163.849 Y161.981 E.01649
G1 X173.906 Y151.924 E.43841
G1 X173.371 Y151.924 E.01649
G1 X163.849 Y161.446 E.41509
G1 X163.849 Y160.911 E.01649
G1 X172.836 Y151.924 E.39176
G1 X172.3 Y151.924 E.01649
G1 X163.849 Y160.376 E.36844
G1 X163.849 Y159.84 E.01649
G1 X171.765 Y151.924 E.34511
G1 X171.23 Y151.924 E.01649
G1 X163.849 Y159.305 E.32179
G1 X163.849 Y158.77 E.01649
G1 X170.695 Y151.924 E.29846
G1 X170.16 Y151.924 E.01649
G1 X163.849 Y158.235 E.27514
G1 X163.849 Y157.7 E.01649
G1 X169.625 Y151.924 E.25181
G1 X169.09 Y151.924 E.01649
G1 X163.849 Y157.165 E.22849
G1 X163.849 Y156.63 E.01649
G1 X168.555 Y151.924 E.20516
G1 X168.02 Y151.924 E.01649
G1 X163.849 Y156.095 E.18184
G1 X163.849 Y155.56 E.01649
G1 X167.485 Y151.924 E.15851
G1 X166.95 Y151.924 E.01649
G1 X163.849 Y155.025 E.13519
G1 X163.849 Y154.49 E.01649
G1 X166.415 Y151.924 E.11187
G1 X165.88 Y151.924 E.01649
G1 X163.849 Y153.955 E.08854
G1 X163.849 Y153.42 E.01649
G1 X165.345 Y151.924 E.06522
G1 X164.81 Y151.924 E.01649
G1 X163.849 Y152.885 E.04189
M73 P46 R8
G1 X163.849 Y152.35 E.01649
G1 X164.445 Y151.755 E.02596
; CHANGE_LAYER
; Z_HEIGHT: 1.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9516.005
G1 X163.849 Y152.35 E-.32004
G1 X163.849 Y152.885 E-.2033
G1 X164.29 Y152.445 E-.23665
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 9/85
; update layer progress
M73 L9
M991 S0 P8 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z2 I-.706 J.991 P1  F60000
G1 X186.484 Y168.259 Z2
G1 Z1.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X185.12 Y168.259 E.04525
G3 X183.368 Y168.259 I-.876 J-2.524 E.05922
G1 X166.62 Y168.259 E.55556
G3 X164.868 Y168.259 I-.876 J-2.524 E.05922
G1 X163.516 Y168.259 E.04483
G1 X163.516 Y166.907 E.04483
G3 X163.516 Y165.143 I2.645 J-.882 E.05956
G1 X163.516 Y151.591 E.44953
G1 X186.484 Y151.591 E.76188
G1 X186.484 Y165.143 E.44952
G3 X186.484 Y166.907 I-2.645 J.882 E.05956
G1 X186.484 Y168.199 E.04284
; COOLING_NODE: 0
M204 S10000
G1 X186.891 Y168.666 F60000
G1 F8843.478
M204 S8000
G1 X185.174 Y168.666 E.05697
G3 X183.317 Y168.666 I-.928 J-2.842 E.06261
G1 X166.674 Y168.666 E.55211
G3 X164.817 Y168.666 I-.928 J-2.842 E.06261
G1 X163.109 Y168.666 E.05667
G1 X163.109 Y166.958 E.05667
G3 X163.109 Y165.092 I2.979 J-.933 E.06283
G1 X163.109 Y151.184 E.46137
G1 X186.891 Y151.184 E.78888
G1 X186.891 Y165.092 E.46136
G3 X186.891 Y166.958 I-2.979 J.933 E.06283
G1 X186.891 Y168.606 E.05468
; COOLING_NODE: 0
M204 S10000
G1 X187.298 Y169.073 F60000
G1 F8843.478
M204 S8000
G1 X185.227 Y169.073 E.06868
G3 X183.267 Y169.073 I-.98 J-3.179 E.06601
G1 X166.727 Y169.073 E.54865
G3 X164.767 Y169.073 I-.98 J-3.179 E.06601
G1 X162.702 Y169.073 E.0685
G1 X162.702 Y167.008 E.0685
G3 X162.702 Y165.042 I3.335 J-.983 E.0661
G1 X162.702 Y150.777 E.4732
G1 X187.298 Y150.777 E.81589
G1 X187.298 Y165.042 E.4732
G3 X187.378 Y166.69 I-3.18 J.98 E.05529
G1 X187.298 Y167.008 E.01089
G1 X187.298 Y169.013 E.06651
; COOLING_NODE: 0
M204 S250
G1 X187.69 Y169.465 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3434
M204 S5000
G1 X185.279 Y169.465 E.07407
G3 X183.219 Y169.465 I-1.03 J-3.521 E.06418
G1 X166.779 Y169.465 E.50514
G3 X164.719 Y169.465 I-1.03 J-3.521 E.06418
G1 X162.31 Y169.465 E.07402
G1 X162.31 Y167.056 E.07402
G3 X162.31 Y164.994 I3.698 J-1.031 E.06416
G1 X162.31 Y150.385 E.44889
G1 X187.69 Y150.385 E.77986
G1 X187.69 Y164.994 E.44889
G3 X187.69 Y167.056 I-3.697 J1.031 E.06416
G1 X187.69 Y169.405 E.07217
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

; WIPE_START
G1 F9547.055
M204 S8000
G1 X185.691 Y169.455 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X185.974 Y161.828 Z2.2 F60000
G1 X186.32 Y152.52 Z2.2
G1 Z1.8
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42123
G1 F9516.005
M204 S8000
G1 X185.725 Y151.924 E.02595
G1 X185.19 Y151.924 E.01649
G1 X186.151 Y152.885 E.04188
G1 X186.151 Y153.42 E.01649
G1 X184.655 Y151.924 E.0652
G1 X184.12 Y151.924 E.01649
G1 X186.151 Y153.955 E.08853
G1 X186.151 Y154.49 E.01649
G1 X183.585 Y151.924 E.11185
G1 X183.05 Y151.924 E.01649
G1 X186.151 Y155.025 E.13517
G1 X186.151 Y155.56 E.01649
G1 X182.515 Y151.924 E.1585
G1 X181.98 Y151.924 E.01649
G1 X186.151 Y156.095 E.18182
G1 X186.151 Y156.63 E.01649
G1 X181.445 Y151.924 E.20515
G1 X180.91 Y151.924 E.01649
G1 X186.151 Y157.165 E.22847
G1 X186.151 Y157.7 E.01649
G1 X180.375 Y151.924 E.2518
G1 X179.84 Y151.924 E.01649
G1 X186.151 Y158.235 E.27512
G1 X186.151 Y158.77 E.01649
G1 X179.305 Y151.924 E.29845
G1 X178.77 Y151.924 E.01649
G1 X186.151 Y159.305 E.32177
G1 X186.151 Y159.84 E.01649
G1 X178.235 Y151.924 E.3451
G1 X177.7 Y151.924 E.01649
G1 X186.151 Y160.375 E.36842
G1 X186.151 Y160.91 E.01649
G1 X177.165 Y151.924 E.39175
G1 X176.63 Y151.924 E.01649
G1 X186.151 Y161.445 E.41507
G1 X186.151 Y161.98 E.01649
G1 X176.095 Y151.924 E.4384
G1 X175.56 Y151.924 E.01649
G1 X186.151 Y162.515 E.46172
G1 X186.151 Y163.05 E.01649
G1 X175.025 Y151.924 E.48504
G1 X174.49 Y151.924 E.01649
G1 X186.151 Y163.585 E.50837
G1 X186.151 Y164.12 E.01649
G1 X173.955 Y151.924 E.53169
G1 X173.42 Y151.924 E.01649
G1 X186.151 Y164.655 E.55502
G1 X186.154 Y165.193 E.01658
G1 X172.885 Y151.924 E.57847
G1 X172.35 Y151.924 E.01649
G1 X186.288 Y165.862 E.60764
G3 X186.264 Y166.374 I-2.046 J.162 E.01583
G1 X171.815 Y151.924 E.62994
G1 X171.28 Y151.924 E.01649
G1 X186.164 Y166.809 E.64892
G1 X186.151 Y166.87 E.00191
G1 X186.151 Y167.33 E.0142
G1 X170.745 Y151.924 E.67164
G1 X170.21 Y151.924 E.01649
G1 X186.151 Y167.865 E.69497
G1 X186.151 Y167.926 E.00186
G1 X185.676 Y167.926 E.01464
G1 X169.675 Y151.924 E.69759
G1 X169.14 Y151.924 E.01649
G1 X185.141 Y167.926 E.69759
G1 X184.696 Y168.016 E.01399
G1 X168.605 Y151.924 E.70153
G1 X168.07 Y151.924 E.01649
G1 X184.217 Y168.072 E.70396
G3 X183.574 Y167.964 I.022 J-2.107 E.02016
G1 X167.535 Y151.924 E.69928
G1 X167 Y151.924 E.01649
G1 X183.001 Y167.926 E.69759
G1 X182.466 Y167.926 E.01649
G1 X166.465 Y151.924 E.69759
G1 X165.93 Y151.924 E.01649
G1 X181.931 Y167.926 E.69759
G1 X181.396 Y167.926 E.01649
G1 X165.395 Y151.924 E.69759
G1 X164.86 Y151.924 E.01649
G1 X180.861 Y167.926 E.69759
G1 X180.326 Y167.926 E.01649
G1 X164.325 Y151.924 E.69759
G1 X163.849 Y151.924 E.01465
G1 X163.849 Y151.984 E.00185
G1 X179.791 Y167.926 E.69498
G1 X179.256 Y167.926 E.01649
G1 X163.849 Y152.519 E.67166
G1 X163.849 Y153.054 E.01649
G1 X178.721 Y167.926 E.64833
G1 X178.186 Y167.926 E.01649
G1 X163.849 Y153.589 E.62501
G1 X163.849 Y154.124 E.01649
M73 P47 R8
G1 X177.651 Y167.926 E.60168
G1 X177.116 Y167.926 E.01649
G1 X163.849 Y154.659 E.57836
G1 X163.849 Y155.194 E.01649
G1 X176.581 Y167.926 E.55503
G1 X176.046 Y167.926 E.01649
G1 X163.849 Y155.729 E.53171
G1 X163.849 Y156.264 E.01649
G1 X175.511 Y167.926 E.50838
G1 X174.976 Y167.926 E.01649
G1 X163.849 Y156.799 E.48506
G1 X163.849 Y157.334 E.01649
G1 X174.441 Y167.926 E.46173
G1 X173.906 Y167.926 E.01649
G1 X163.849 Y157.869 E.43841
G1 X163.849 Y158.405 E.01649
G1 X173.371 Y167.926 E.41509
G1 X172.836 Y167.926 E.01649
G1 X163.849 Y158.94 E.39176
G1 X163.849 Y159.475 E.01649
G1 X172.3 Y167.926 E.36844
G1 X171.765 Y167.926 E.01649
G1 X163.849 Y160.01 E.34511
G1 X163.849 Y160.545 E.01649
G1 X171.23 Y167.926 E.32179
G1 X170.695 Y167.926 E.01649
G1 X163.849 Y161.08 E.29846
G1 X163.849 Y161.615 E.01649
G1 X170.16 Y167.926 E.27514
G1 X169.625 Y167.926 E.01649
G1 X163.849 Y162.15 E.25181
G1 X163.849 Y162.685 E.01649
G1 X169.09 Y167.926 E.22849
G1 X168.555 Y167.926 E.01649
G1 X163.849 Y163.22 E.20516
G1 X163.849 Y163.755 E.01649
G1 X168.02 Y167.926 E.18184
G1 X167.485 Y167.926 E.01649
G1 X163.849 Y164.29 E.15851
G1 X163.849 Y164.825 E.01649
G1 X166.95 Y167.926 E.13519
G1 X166.581 Y167.926 E.01138
G1 X166.447 Y167.957 E.00426
G1 X163.816 Y165.326 E.11469
G1 X163.719 Y165.765 E.01384
G1 X166.01 Y168.056 E.09988
G3 X165.474 Y168.055 I-.264 J-1.91 E.01658
G1 X163.72 Y166.301 E.07647
G1 X163.849 Y166.87 E.01799
G1 X163.849 Y166.965 E.00293
G1 X164.81 Y167.926 E.04189
G1 X164.275 Y167.926 E.01649
G1 X163.68 Y167.33 E.02596
; CHANGE_LAYER
; Z_HEIGHT: 2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9516.005
G1 X164.275 Y167.926 E-.32004
G1 X164.81 Y167.926 E-.2033
G1 X164.37 Y167.485 E-.23665
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 10/85
; update layer progress
M73 L10
M991 S0 P9 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z2.2 I.482 J1.117 P1  F60000
G1 X167.133 Y166.292 Z2.2
G1 Z2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G3 X167.004 Y166.689 I-2.09 J-.463 E.01387
G3 X166.613 Y167.152 I-1.254 J-.664 E.02024
G1 X165.72 Y167.791 E.03641
G1 X164.857 Y167.127 E.03613
G3 X164.648 Y166.918 I1.229 J-1.438 E.0098
G1 X163.984 Y166.055 E.03613
G1 X164.624 Y165.162 E.03641
G3 X165.824 Y164.608 I1.134 J.879 E.04558
G3 X166.966 Y165.294 I-.079 J1.424 E.04596
G1 X167.178 Y165.668 E.01428
G3 X167.145 Y166.234 I-2.134 J.162 E.01884
; COOLING_NODE: 0
M204 S10000
G1 X167.562 Y166.215 F60000
G1 F8843.478
M204 S8000
G3 X167.497 Y166.557 I-3.335 J-.458 E.01153
G3 X166.857 Y167.477 I-1.76 J-.54 E.03779
G1 X165.712 Y168.297 E.04673
G1 X164.6 Y167.443 E.0465
G3 X164.331 Y167.175 I1.586 J-1.854 E.01262
G1 X163.478 Y166.063 E.0465
G1 X164.298 Y164.918 E.04673
G3 X165.846 Y164.202 I1.462 J1.128 E.05882
G3 X167.315 Y165.084 I-.102 J1.834 E.05913
G1 X167.588 Y165.566 E.01836
G3 X167.569 Y166.156 I-3.36 J.192 E.01962
; COOLING_NODE: 0
M204 S10000
G1 X167.943 Y166.449 F60000
G1 F8843.478
M204 S8000
G3 X167.102 Y167.803 I-2.204 J-.43 E.05406
G1 X165.875 Y168.682 E.05006
G1 X166.045 Y169.212 E.01849
G3 X165.462 Y169.212 I-.293 J-4.167 E.01936
G1 X165.621 Y168.741 E.01651
G1 X164.344 Y167.76 E.05343
G3 X164.015 Y167.431 I1.938 J-2.266 E.01543
G1 X163.034 Y166.154 E.05344
G1 X162.563 Y166.313 E.01651
G3 X162.563 Y165.73 I4.169 J-.29 E.01935
G1 X163.093 Y165.901 E.01849
G1 X163.972 Y164.673 E.05007
G3 X165.868 Y163.795 I1.789 J1.376 E.07206
G3 X167.664 Y164.874 I-.126 J2.244 E.0723
G1 X167.997 Y165.463 E.02246
G3 X167.951 Y166.389 I-5.142 J.209 E.0308
; COOLING_NODE: 0
; WIPE_START
G1 X167.849 Y166.787 E-.15603
G1 X167.666 Y167.173 E-.16223
G1 X167.416 Y167.512 E-.16014
G1 X167.102 Y167.803 E-.16277
G1 X166.847 Y167.985 E-.11883
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X174.47 Y167.594 Z2.4 F60000
G1 X185.223 Y167.042 Z2.4
G1 Z2
G1 E.8 F1800
G1 F8843.478
M204 S8000
G1 X185.124 Y167.142 E.00467
G1 X184.249 Y167.791 E.03614
G3 X183.339 Y167.113 I7.076 J-10.443 E.03766
G3 X182.837 Y166.152 I.938 J-1.102 E.03688
G1 X182.81 Y165.704 E.01487
G3 X183.416 Y164.877 I1.995 J.826 E.03434
G3 X184.315 Y164.607 I.841 J1.17 E.0317
G3 X185.391 Y165.182 I-.071 J1.429 E.04181
G1 X185.983 Y166.04 E.03459
G1 X185.383 Y166.879 E.0342
G1 X185.265 Y166.999 E.00561
; COOLING_NODE: 0
M204 S10000
G1 X185.585 Y167.27 F60000
G1 F8843.478
M204 S8000
G3 X185.375 Y167.463 I-1.39 J-1.3 E.00946
G1 X184.249 Y168.298 E.04652
G1 X183.118 Y167.458 E.04673
G3 X182.431 Y166.184 I1.141 J-1.437 E.04934
G1 X182.397 Y165.612 E.01901
G3 X182.846 Y164.857 I3.535 J1.592 E.02919
G3 X184.337 Y164.201 I1.405 J1.169 E.05603
G3 X185.721 Y164.943 I-.095 J1.839 E.05382
G1 X186.481 Y166.045 E.04438
G1 X185.708 Y167.124 E.04403
G3 X185.625 Y167.226 I-1.513 J-1.153 E.00436
; COOLING_NODE: 0
M204 S10000
G1 X185.882 Y167.548 F60000
G1 F8843.478
M204 S8000
G3 X185.626 Y167.784 I-1.699 J-1.589 E.01157
G1 X184.372 Y168.713 E.05176
G1 X184.537 Y169.213 E.01746
G3 X183.963 Y169.213 I-.287 J-4.104 E.01906
G1 X184.128 Y168.715 E.01737
G1 X182.868 Y167.779 E.05208
G3 X182.025 Y166.217 I1.392 J-1.759 E.06053
G1 X181.984 Y165.52 E.02316
G3 X182.421 Y164.743 I5.283 J2.464 E.0296
G3 X184.359 Y163.794 I1.832 J1.287 E.0747
G3 X186.051 Y164.704 I-.12 J2.25 E.06583
G1 X186.873 Y165.896 E.048
G1 X187.437 Y165.72 E.0196
G3 X187.437 Y166.32 I-4.296 J.303 E.01993
G1 X186.906 Y166.15 E.0185
G1 X186.033 Y167.369 E.04975
G3 X185.923 Y167.504 I-1.85 J-1.41 E.00577
; COOLING_NODE: 0
; WIPE_START
G1 X185.626 Y167.784 E-.15509
G1 X184.372 Y168.713 E-.59298
G1 X184.382 Y168.743 E-.01193
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X187.69 Y169.465 Z2.4 F60000
G1 Z2
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3289
M204 S5000
G1 X185.279 Y169.465 E.07407
G3 X183.219 Y169.465 I-1.03 J-3.52 E.06418
G1 X166.779 Y169.465 E.50514
G3 X164.719 Y169.465 I-1.03 J-3.52 E.06418
G1 X162.31 Y169.465 E.07402
G1 X162.31 Y167.056 E.07402
G3 X162.31 Y164.994 I3.697 J-1.031 E.06416
G1 X162.31 Y150.385 E.44889
G1 X187.69 Y150.385 E.77986
G1 X187.69 Y164.994 E.44889
G3 X187.69 Y167.056 I-3.697 J1.031 E.06416
G1 X187.69 Y169.405 E.07217
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

M204 S10000
G1 X187.483 Y168.581 F60000
; FEATURE: Top surface
G1 F9547.055
M204 S2000
G1 X186.806 Y169.258 E.0294
G1 X186.672 Y169.391
G1 X186.139 Y169.391
G1 X186.273 Y169.258
G1 X187.483 Y168.048 E.05258
G1 X187.616 Y167.914
G1 X187.616 Y167.381
G1 X187.483 Y167.514
G1 X185.739 Y169.258 E.07575
G1 X185.606 Y169.391
G1 X185.056 Y169.408
G1 X185.189 Y169.274
G1 X187.499 Y166.965 E.10037
G1 X187.633 Y166.831
G1 X187.525 Y166.406
G1 X187.391 Y166.539
G1 X184.758 Y169.172 E.11442
M204 S10000
G1 X187.091 Y166.423 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.212423
G1 F15000
M204 S8000
G1 X186.868 Y166.687 E.00477
; LINE_WIDTH: 0.162723
G1 X186.644 Y166.95 E.00337
; LINE_WIDTH: 0.113023
G1 X186.42 Y167.214 E.00197
M204 S10000
G1 X185.412 Y168.222 F60000
; LINE_WIDTH: 0.110222
G1 F15000
M204 S8000
G1 X185.156 Y168.443 E.00186
; LINE_WIDTH: 0.154318
G1 X184.9 Y168.664 E.00307
; LINE_WIDTH: 0.198413
G1 X184.644 Y168.885 E.00429
; WIPE_START
G1 X184.9 Y168.664 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X183.073 Y169.258 Z2.4 F60000
G1 Z2
G1 E.8 F1800
; FEATURE: Top surface
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S2000
G1 X183.675 Y168.656 E.02614
G1 X183.808 Y168.522
G1 X183.502 Y168.295
G1 X183.369 Y168.429
G1 X182.54 Y169.258 E.03602
G1 X182.406 Y169.391
G1 X181.873 Y169.391
G1 X182.007 Y169.258
G1 X183.063 Y168.201 E.0459
G1 X183.197 Y168.068
G1 X182.891 Y167.84
G1 X182.757 Y167.974
G1 X181.473 Y169.258 E.05578
G1 X181.34 Y169.391
G1 X180.807 Y169.391
G1 X180.94 Y169.258
G1 X182.475 Y167.722 E.06672
G1 X182.609 Y167.589
G1 X182.369 Y167.295
G1 X182.236 Y167.429
G1 X180.407 Y169.258 E.07948
G1 X180.273 Y169.391
G1 X179.74 Y169.391
G1 X179.874 Y169.258
G1 X182.039 Y167.092 E.0941
G1 X182.173 Y166.959
G1 X182.025 Y166.573
G1 X181.891 Y166.707
G1 X179.34 Y169.258 E.11084
G1 X179.207 Y169.391
G1 X178.673 Y169.391
G1 X178.807 Y169.258
G1 X181.806 Y166.259 E.1303
G1 X181.939 Y166.126
G1 X181.908 Y165.623
G1 X181.775 Y165.757
G1 X178.274 Y169.258 E.15213
G1 X178.14 Y169.391
G1 X177.607 Y169.391
G1 X177.741 Y169.258
G1 X182.031 Y164.968 E.18642
; WIPE_START
M204 S8000
G1 X180.616 Y166.382 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X186.854 Y165.477 Z2.4 F60000
G1 Z2
G1 E.8 F1800
G1 F9547.055
M204 S2000
G1 X187.483 Y164.848 E.02732
G1 X187.616 Y164.715
G1 X187.616 Y164.181
G1 X187.483 Y164.315
G1 X186.636 Y165.161 E.03677
G1 X186.503 Y165.295
G1 X186.285 Y164.979
G1 X186.419 Y164.846
G1 X187.483 Y163.782 E.04623
G1 X187.616 Y163.648
G1 X187.616 Y163.115
G1 X187.483 Y163.248
G1 X186.199 Y164.532 E.05577
G1 X186.066 Y164.665
G1 X185.813 Y164.384
G1 X185.947 Y164.251
G1 X187.483 Y162.715 E.06673
G1 X187.616 Y162.582
G1 X187.616 Y162.048
G1 X187.483 Y162.182
G1 X185.654 Y164.011 E.07948
G1 X185.52 Y164.144
G1 X185.184 Y163.947
G1 X185.318 Y163.814
G1 X187.483 Y161.649 E.09408
G1 X187.616 Y161.515
G1 X187.616 Y160.982
G1 X187.483 Y161.115
G1 X184.932 Y163.666 E.11086
G1 X184.798 Y163.8
G1 X184.35 Y163.714
G1 X184.484 Y163.581
G1 X187.483 Y160.582 E.13031
G1 X187.616 Y160.448
G1 X187.616 Y159.915
G1 X187.483 Y160.049
G1 X183.942 Y163.589 E.15385
G1 X183.809 Y163.723
G1 X183.052 Y163.947
G1 X183.185 Y163.813
G1 X187.483 Y159.516 E.18674
G1 X187.616 Y159.382
G1 X187.616 Y158.849
G1 X187.483 Y158.982
G1 X177.207 Y169.258 E.44651
G1 X177.074 Y169.391
G1 X176.54 Y169.391
G1 X176.674 Y169.258
G1 X187.483 Y158.449 E.46968
G1 X187.616 Y158.315
G1 X187.616 Y157.782
G1 X187.483 Y157.916
G1 X176.141 Y169.258 E.49286
G1 X176.007 Y169.391
G1 X175.474 Y169.391
G1 X175.608 Y169.258
G1 X187.483 Y157.383 E.51603
G1 X187.616 Y157.249
G1 X187.616 Y156.716
G1 X187.483 Y156.849
G1 X175.074 Y169.258 E.5392
G1 X174.941 Y169.391
G1 X174.407 Y169.391
G1 X174.541 Y169.258
G1 X187.483 Y156.316 E.56237
G1 X187.616 Y156.182
G1 X187.616 Y155.649
G1 X187.483 Y155.783
G1 X174.008 Y169.258 E.58555
G1 X173.874 Y169.391
G1 X173.341 Y169.391
G1 X173.475 Y169.258
G1 X187.483 Y155.25 E.60872
G1 X187.616 Y155.116
G1 X187.616 Y154.583
G1 X187.483 Y154.716
M73 P48 R8
G1 X172.941 Y169.258 E.63189
G1 X172.808 Y169.391
G1 X172.274 Y169.391
G1 X172.408 Y169.258
G1 X187.483 Y154.183 E.65506
G1 X187.616 Y154.049
G1 X187.616 Y153.516
G1 X187.483 Y153.65
G1 X171.875 Y169.258 E.67824
G1 X171.741 Y169.391
G1 X171.208 Y169.391
G1 X171.342 Y169.258
G1 X187.483 Y153.117 E.70141
G1 X187.616 Y152.983
G1 X187.616 Y152.45
G1 X187.483 Y152.583
G1 X170.808 Y169.258 E.72458
G1 X170.675 Y169.391
G1 X170.141 Y169.391
G1 X170.275 Y169.258
G1 X187.483 Y152.05 E.74776
G1 X187.616 Y151.916
G1 X187.616 Y151.383
G1 X187.483 Y151.517
G1 X169.742 Y169.258 E.77093
G1 X169.608 Y169.391
G1 X169.075 Y169.391
G1 X169.208 Y169.258
G1 X187.483 Y150.983 E.7941
G1 X187.616 Y150.85
G1 X187.474 Y150.459
G1 X187.34 Y150.592
G1 X168.675 Y169.258 E.8111
G1 X168.542 Y169.391
G1 X168.008 Y169.391
G1 X168.142 Y169.258
G1 X186.807 Y150.592 E.8111
G1 X186.941 Y150.459
G1 X186.408 Y150.459
G1 X186.274 Y150.592
G1 X167.609 Y169.258 E.8111
G1 X167.475 Y169.391
G1 X166.942 Y169.391
G1 X167.075 Y169.258
G1 X185.741 Y150.592 E.8111
G1 X185.874 Y150.459
G1 X185.341 Y150.459
G1 X185.207 Y150.592
G1 X166.47 Y169.33 E.81423
G1 X166.336 Y169.463
G1 X166.09 Y169.176
G1 X166.224 Y169.042
G1 X184.674 Y150.592 E.80174
G1 X184.808 Y150.459
G1 X184.275 Y150.459
G1 X184.141 Y150.592
G1 X168.138 Y166.595 E.69539
G1 X168.005 Y166.729
G1 X168.073 Y166.127
G1 X168.207 Y165.994
G1 X183.608 Y150.592 E.66925
G1 X183.741 Y150.459
G1 X183.208 Y150.459
G1 X183.074 Y150.592
G1 X168.22 Y165.446 E.64548
G1 X168.087 Y165.58
G1 X167.909 Y165.225
G1 X168.042 Y165.091
G1 X182.541 Y150.592 E.63004
G1 X182.675 Y150.459
G1 X182.142 Y150.459
G1 X182.008 Y150.592
G1 X167.849 Y164.751 E.61526
G1 X167.716 Y164.885
G1 X167.492 Y164.575
G1 X167.626 Y164.441
G1 X181.475 Y150.592 E.6018
G1 X181.608 Y150.459
G1 X181.075 Y150.459
G1 X180.941 Y150.592
G1 X167.361 Y164.173 E.59013
G1 X167.228 Y164.306
G1 X166.921 Y164.079
G1 X167.055 Y163.945
G1 X180.408 Y150.592 E.58026
G1 X180.542 Y150.459
G1 X180.009 Y150.459
G1 X179.875 Y150.592
G1 X166.705 Y163.763 E.57231
G1 X166.571 Y163.896
G1 X166.168 Y163.766
G1 X166.301 Y163.633
G1 X179.342 Y150.592 E.56666
G1 X179.475 Y150.459
G1 X178.942 Y150.459
G1 X178.808 Y150.592
G1 X165.829 Y163.571 E.56399
G1 X165.696 Y163.705
G1 X165.111 Y163.756
G1 X165.245 Y163.622
G1 X178.275 Y150.592 E.56622
G1 X178.409 Y150.459
G1 X177.875 Y150.459
G1 X177.742 Y150.592
G1 X164.261 Y164.073 E.5858
G1 X163.793 Y164.541
G1 X162.771 Y165.563 E.04443
G1 X162.637 Y165.697
G1 X162.295 Y165.506
G1 X162.429 Y165.372
G1 X177.209 Y150.592 E.64224
G1 X177.342 Y150.459
G1 X176.809 Y150.459
G1 X176.675 Y150.592
G1 X162.517 Y164.75 E.61523
G1 X162.384 Y164.884
G1 X162.384 Y164.351
G1 X162.517 Y164.217
G1 X176.142 Y150.592 E.59206
G1 X176.276 Y150.459
G1 X175.742 Y150.459
G1 X175.609 Y150.592
G1 X162.517 Y163.684 E.56889
G1 X162.384 Y163.817
G1 X162.384 Y163.284
G1 X162.517 Y163.151
G1 X175.076 Y150.592 E.54571
G1 X175.209 Y150.459
G1 X174.676 Y150.459
G1 X174.542 Y150.592
G1 X162.517 Y162.617 E.52254
G1 X162.384 Y162.751
G1 X162.384 Y162.218
G1 X162.517 Y162.084
G1 X174.009 Y150.592 E.49937
G1 X174.143 Y150.459
G1 X173.609 Y150.459
G1 X173.476 Y150.592
G1 X162.517 Y161.551 E.47619
G1 X162.384 Y161.684
G1 X162.384 Y161.151
G1 X162.517 Y161.018
G1 X172.943 Y150.592 E.45302
G1 X173.076 Y150.459
G1 X172.543 Y150.459
G1 X172.409 Y150.592
G1 X162.517 Y160.484 E.42985
G1 X162.384 Y160.618
G1 X162.384 Y160.085
G1 X162.517 Y159.951
G1 X171.876 Y150.592 E.40668
G1 X172.01 Y150.459
G1 X171.476 Y150.459
G1 X171.343 Y150.592
G1 X162.517 Y159.418 E.3835
G1 X162.384 Y159.551
G1 X162.384 Y159.018
G1 X162.517 Y158.884
G1 X170.809 Y150.592 E.36033
G1 X170.943 Y150.459
G1 X170.41 Y150.459
G1 X170.276 Y150.592
G1 X162.517 Y158.351 E.33716
G1 X162.384 Y158.485
G1 X162.384 Y157.952
G1 X162.517 Y157.818
G1 X169.743 Y150.592 E.31399
G1 X169.877 Y150.459
G1 X169.343 Y150.459
G1 X169.21 Y150.592
G1 X162.517 Y157.285 E.29081
G1 X162.384 Y157.418
G1 X162.384 Y156.885
G1 X162.517 Y156.751
G1 X168.676 Y150.592 E.26764
G1 X168.81 Y150.459
G1 X168.277 Y150.459
G1 X168.143 Y150.592
G1 X162.517 Y156.218 E.24447
G1 X162.384 Y156.352
G1 X162.384 Y155.819
G1 X162.517 Y155.685
G1 X167.61 Y150.592 E.2213
G1 X167.744 Y150.459
G1 X167.21 Y150.459
G1 X167.077 Y150.592
G1 X162.517 Y155.152 E.19812
G1 X162.384 Y155.285
G1 X162.384 Y154.752
G1 X162.517 Y154.618
G1 X166.543 Y150.592 E.17495
G1 X166.677 Y150.459
G1 X166.144 Y150.459
G1 X166.01 Y150.592
G1 X162.517 Y154.085 E.15178
G1 X162.384 Y154.219
G1 X162.384 Y153.686
G1 X162.517 Y153.552
G1 X165.477 Y150.592 E.12861
G1 X165.611 Y150.459
G1 X165.077 Y150.459
G1 X164.944 Y150.592
G1 X162.517 Y153.019 E.10543
G1 X162.384 Y153.152
G1 X162.384 Y152.619
G1 X162.517 Y152.485
G1 X164.41 Y150.592 E.08226
G1 X164.544 Y150.459
G1 X164.011 Y150.459
G1 X163.877 Y150.592
G1 X162.517 Y151.952 E.05909
G1 X162.384 Y152.086
G1 X162.384 Y151.553
G1 X162.517 Y151.419
G1 X163.344 Y150.592 E.03591
; WIPE_START
M204 S8000
G1 X162.517 Y151.419 E-.44415
G1 X162.384 Y151.553 E-.07182
G1 X162.384 Y152.086 E-.20264
G1 X162.461 Y152.009 E-.04139
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z2.4 I-.574 J1.073 P1  F60000
G1 X187.587 Y165.46 Z2.4
G1 Z2
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.160375
G1 F15000
M204 S8000
G1 X187.362 Y165.235 E.00304
; WIPE_START
G1 X187.587 Y165.46 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X182.844 Y163.967 Z2.4 F60000
G1 Z2
G1 E.8 F1800
; LINE_WIDTH: 0.125076
G1 F15000
M204 S8000
G1 X182.536 Y164.244 E.00277
G1 X182.21 Y164.597 E.00322
; LINE_WIDTH: 0.17147
G1 X182.076 Y164.764 E.00225
; LINE_WIDTH: 0.20832
G1 X181.969 Y164.906 E.00239
; WIPE_START
G1 X182.076 Y164.764 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X174.662 Y166.578 Z2.4 F60000
G1 X166.362 Y168.609 Z2.4
G1 Z2
G1 E.8 F1800
; LINE_WIDTH: 0.107603
G1 F15000
M204 S8000
M73 P49 R8
G1 X166.129 Y168.806 E.00161
M204 S10000
G1 X165.349 Y168.851 F60000
; FEATURE: Top surface
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S2000
G1 X164.903 Y169.297 E.01939
G1 X164.769 Y169.431
G1 X164.276 Y169.391
G1 X164.409 Y169.258
G1 X165.069 Y168.598 E.02868
G1 X165.203 Y168.464
G1 X164.901 Y168.232
G1 X164.768 Y168.366
G1 X163.876 Y169.258 E.03875
G1 X163.742 Y169.391
G1 X163.209 Y169.391
G1 X163.343 Y169.258
G1 X164.466 Y168.134 E.04881
G1 X164.6 Y168.001
G1 X164.3 Y167.767
G1 X164.166 Y167.901
G1 X162.809 Y169.258 E.05896
G1 X162.676 Y169.391
G1 X162.384 Y169.15
G1 X162.517 Y169.016
G1 X163.898 Y167.636 E.05998
G1 X164.031 Y167.503
G1 X163.796 Y167.204
G1 X163.663 Y167.338
G1 X162.517 Y168.483 E.04977
G1 X162.384 Y168.617
G1 X162.384 Y168.084
G1 X162.517 Y167.95
G1 X163.431 Y167.036 E.03971
G1 X163.565 Y166.902
G1 X163.333 Y166.601
G1 X163.199 Y166.735
G1 X162.517 Y167.417 E.02964
G1 X162.384 Y167.55
G1 X162.354 Y167.047
G1 X162.488 Y166.913
G1 X162.968 Y166.433 E.02086
; WIPE_START
M204 S8000
G1 X162.488 Y166.913 E-.25793
G1 X162.354 Y167.047 E-.07182
G1 X162.384 Y167.55 E-.19175
G1 X162.517 Y167.417 E-.07182
G1 X162.828 Y167.106 E-.16668
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X165.923 Y165.884 Z2.4 F60000
G1 Z2
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.48443
G1 F8153.836
M204 S8000
G1 X165.755 Y165.804 E.00671
G1 X165.586 Y165.863 E.00643
G1 X165.456 Y166.023 E.0074
G2 X165.752 Y166.319 I1.124 J-.829 E.01509
G1 X165.968 Y166.091 E.01127
G2 X165.942 Y165.941 I-.196 J-.044 E.00564
M204 S10000
G1 X166.229 Y165.602 F60000
; LINE_WIDTH: 0.41999
G1 F9547.299
M204 S8000
G1 X166.032 Y165.453 E.0076
G1 X165.779 Y165.388 E.00803
G1 X165.542 Y165.42 E.00734
G1 X165.245 Y165.627 E.01113
G1 X164.945 Y166.034 E.01553
G1 X165.295 Y166.48 E.01741
G1 X165.741 Y166.83 E.01742
G1 X166.141 Y166.529 E.01538
G1 X166.34 Y166.262 E.01022
G2 X166.395 Y165.864 I-1.558 J-.418 E.0124
G1 X166.261 Y165.653 E.00768
M204 S10000
G1 X166.511 Y165.342 F60000
G1 F9547.299
M204 S8000
G1 X166.199 Y165.107 E.01202
G1 X165.801 Y165.004 E.01262
G1 X165.422 Y165.056 E.01177
G1 X165.105 Y165.23 E.01111
G1 X164.883 Y165.473 E.01009
G1 X164.474 Y166.044 E.02159
G1 X165.026 Y166.749 E.0275
G1 X165.731 Y167.301 E.02751
G1 X166.356 Y166.853 E.02362
G1 X166.631 Y166.547 E.01265
G1 X166.743 Y166.275 E.00903
G1 X166.78 Y165.767 E.01564
G1 X166.543 Y165.393 E.01362
; WIPE_START
G1 X166.78 Y165.767 E-.16845
G1 X166.743 Y166.275 E-.19338
G1 X166.631 Y166.547 E-.11171
G1 X166.356 Y166.853 E-.15644
G1 X166.078 Y167.053 E-.13003
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X173.696 Y166.591 Z2.4 F60000
G1 X184.015 Y165.966 Z2.4
G1 Z2
G1 E.8 F1800
; LINE_WIDTH: 0.48431
G1 F8156.052
M204 S8000
G1 X184.087 Y166.186 E.00832
G1 X184.243 Y166.319 E.00735
G1 X184.478 Y166.119 E.01108
G1 X184.543 Y166.028 E.00405
G1 X184.479 Y165.935 E.00405
G1 X184.293 Y165.802 E.00823
G1 X184.118 Y165.841 E.00644
G1 X184.053 Y165.92 E.00368
M204 S10000
G1 X183.596 Y165.876 F60000
; LINE_WIDTH: 0.41999
G1 F9547.299
M204 S8000
G1 X183.66 Y166.234 E.01117
G1 X183.814 Y166.493 E.00925
G1 X184.245 Y166.83 E.01681
G1 X184.711 Y166.478 E.01793
G1 X185.043 Y166.032 E.0171
G1 X184.816 Y165.703 E.0123
G1 X184.594 Y165.496 E.00932
G1 X184.371 Y165.401 E.00745
G1 X184.056 Y165.414 E.0097
G1 X183.799 Y165.582 E.00942
G1 X183.63 Y165.827 E.00916
M204 S10000
G1 X183.349 Y165.547 F60000
G1 F9547.299
M204 S8000
G1 X183.21 Y165.793 E.00869
G1 X183.251 Y166.246 E.01395
G1 X183.427 Y166.634 E.0131
G1 X183.685 Y166.884 E.01104
G1 X184.247 Y167.301 E.0215
G1 X184.968 Y166.756 E.02777
G1 X185.504 Y166.036 E.02759
G1 X185.127 Y165.488 E.02044
G1 X184.909 Y165.242 E.01011
G1 X184.589 Y165.059 E.01132
G1 X184.301 Y165.003 E.00904
G1 X183.944 Y165.048 E.01105
G1 X183.648 Y165.197 E.01019
G1 X183.388 Y165.501 E.01229
; CHANGE_LAYER
; Z_HEIGHT: 2.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9547.299
G1 X183.648 Y165.197 E-.15197
G1 X183.944 Y165.048 E-.12598
G1 X184.301 Y165.003 E-.13666
G1 X184.589 Y165.059 E-.11183
G1 X184.909 Y165.242 E-.13995
G1 X185.072 Y165.427 E-.09361
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 11/85
; update layer progress
M73 L11
M991 S0 P10 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 1
M204 S10000
G17
G3 Z2.4 I.57 J-1.075 P1  F60000
G1 X162.702 Y153.573 Z2.4
G1 Z2.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F3011
M204 S8000
G1 X162.702 Y152.777 E.0264
G1 X187.298 Y152.777 E.81589
G1 X187.298 Y153.573 E.0264
G1 X162.762 Y153.573 E.8139
; COOLING_NODE: 1
M204 S250
G1 X162.31 Y153.965 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2928
M204 S5000
G1 X162.31 Y152.385 E.04855
G1 X187.69 Y152.385 E.77986
G1 X187.69 Y153.965 E.04855
G1 X162.37 Y153.965 E.77801
M204 S10000
G1 X162.906 Y153.175 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F3011
M204 S8000
G1 X187.094 Y153.175 E.76636
; COOLING_NODE: 0
; WIPE_START
G1 F9259.259
G1 X185.094 Y153.175 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X183.194 Y160.567 Z2.6 F60000
G1 X181.929 Y165.487 Z2.6
G1 Z2.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F3011
M204 S8000
G3 X184.288 Y163.642 I2.322 J.537 E.10741
G1 X184.368 Y163.644 E.00266
G3 X181.917 Y165.546 I-.117 J2.38 E.38461
; COOLING_NODE: 0
M204 S10000
G1 X181.534 Y165.386 F60000
G1 F3011
M204 S8000
G1 X181.599 Y165.158 E.00784
G3 X184.292 Y163.235 I2.652 J.866 E.11753
G1 X184.39 Y163.238 E.00324
G3 X181.522 Y165.444 I-.139 J2.787 E.45093
; COOLING_NODE: 0
M204 S10000
G1 X181.142 Y165.277 F60000
G1 F3011
M204 S8000
G1 X181.213 Y165.03 E.0085
G3 X184.297 Y162.828 I3.039 J.994 E.13456
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X184.412 Y162.831 E.00383
G3 X181.13 Y165.335 I-.161 J3.193 E.5175
; COOLING_NODE: 0
M204 S250
G1 X180.765 Y165.171 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3011
M204 S5000
G1 X180.841 Y164.907 E.00846
G3 X184.301 Y162.435 I3.411 J1.118 E.13984
G1 X184.434 Y162.44 E.00408
G3 X180.752 Y165.23 I-.182 J3.585 E.53875
; WIPE_START
G1 F9547.055
M204 S8000
G1 X180.841 Y164.907 E-.12735
G1 X180.971 Y164.563 E-.1396
G1 X181.142 Y164.228 E-.14292
G1 X181.31 Y163.965 E-.11864
G1 X181.499 Y163.718 E-.11834
G1 X181.703 Y163.5 E-.11316
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X184.284 Y165.966 Z2.6 F60000
G1 Z2.2
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.58238
G1 F3011
M204 S8000
G2 X184.287 Y166.077 I-.029 J.056 E.01161
M204 S10000
G1 X183.796 Y165.888 F60000
; LINE_WIDTH: 0.41999
G1 F3011
M204 S8000
G1 X183.798 Y166.129 E.0074
G1 X183.865 Y166.298 E.00557
G1 X184.143 Y166.479 E.0102
G1 X184.37 Y166.481 E.00698
G1 X184.589 Y166.342 E.00796
G1 X184.717 Y166.093 E.00862
G1 X184.722 Y166.007 E.00264
G1 X184.656 Y165.8 E.00668
G1 X184.416 Y165.583 E.00993
G1 X184.164 Y165.56 E.00779
G1 X183.924 Y165.698 E.00849
G1 X183.83 Y165.839 E.00522
M204 S10000
G1 X183.489 Y165.639 F60000
G1 F3011
M204 S8000
G1 X183.405 Y165.933 E.00939
G1 X183.427 Y166.215 E.00868
G1 X183.583 Y166.553 E.01146
G1 X183.802 Y166.741 E.00885
G1 X184.191 Y166.876 E.01268
G1 X184.516 Y166.835 E.01006
G1 X184.868 Y166.602 E.01295
G1 X185.073 Y166.249 E.01256
G1 X185.099 Y165.997 E.00777
G1 X185.034 Y165.7 E.00934
G1 X184.825 Y165.406 E.01109
G1 X184.472 Y165.202 E.01254
G1 X184.132 Y165.18 E.01047
G1 X183.747 Y165.345 E.01284
G1 X183.529 Y165.594 E.0102
M204 S10000
G1 X183.206 Y165.383 F60000
G1 F3011
M204 S8000
G1 X183.067 Y165.681 E.01012
G2 X183.055 Y166.3 I1.955 J.347 E.01909
G1 X183.249 Y166.734 E.01462
G1 X183.599 Y167.064 E.01476
G1 X184.071 Y167.238 E.01548
G1 X184.398 Y167.248 E.01004
G1 X184.848 Y167.1 E.01456
G1 X185.146 Y166.862 E.01173
G1 X185.406 Y166.434 E.01537
G1 X185.479 Y166.11 E.01021
G2 X185.42 Y165.64 I-1.788 J-.015 E.01461
G2 X185.085 Y165.127 I-1.899 J.876 E.0189
G1 X184.657 Y164.868 E.01534
G1 X184.31 Y164.795 E.01091
G1 X183.871 Y164.855 E.01361
G1 X183.525 Y165.035 E.01199
G1 X183.246 Y165.339 E.01266
M204 S10000
G1 X182.978 Y165.039 F60000
G1 F3011
M204 S8000
G1 X182.755 Y165.445 E.01426
G1 X182.646 Y165.895 E.01422
G1 X182.683 Y166.385 E.0151
G1 X182.863 Y166.841 E.01503
G2 X183.396 Y167.387 I1.935 J-1.355 E.02356
G1 X183.844 Y167.582 E.01502
G1 X184.299 Y167.628 E.01405
G1 X184.755 Y167.555 E.01419
G1 X185.046 Y167.424 E.00978
G1 X185.425 Y167.122 E.01491
G1 X185.702 Y166.719 E.015
G1 X185.833 Y166.28 E.01408
G1 X185.853 Y165.978 E.00931
G1 X185.78 Y165.52 E.01424
G1 X185.65 Y165.232 E.00971
G1 X185.344 Y164.847 E.0151
G1 X184.941 Y164.572 E.01502
G1 X184.478 Y164.439 E.01478
G1 X184.025 Y164.43 E.01393
G1 X183.738 Y164.499 E.00907
G1 X183.302 Y164.726 E.01509
G1 X183.021 Y164.997 E.012
M204 S10000
G1 X182.684 Y164.798 F60000
G1 F3011
M204 S8000
G1 X182.414 Y165.282 E.01704
G2 X182.266 Y165.876 I2.686 J.983 E.01884
G1 X182.312 Y166.471 E.01832
G1 X182.528 Y167.021 E.01819
G1 X182.741 Y167.32 E.01127
G1 X183.193 Y167.71 E.01834
G1 X183.736 Y167.946 E.01819
G1 X184.279 Y168.005 E.01678
G2 X185.243 Y167.749 I-.167 J-2.568 E.03087
G1 X185.704 Y167.382 E.0181
G1 X186.039 Y166.895 E.01814
G1 X186.198 Y166.381 E.01655
G1 X186.23 Y165.968 E.01271
G1 X186.139 Y165.401 E.01765
G1 X185.975 Y165.034 E.01235
G1 X185.604 Y164.568 E.01831
G1 X185.116 Y164.234 E.01817
G1 X184.59 Y164.075 E.01689
G1 X184.137 Y164.048 E.01393
G1 X183.605 Y164.143 E.01661
G1 X183.08 Y164.416 E.01818
G1 X182.727 Y164.756 E.01505
; COOLING_NODE: 2
; WIPE_START
G1 F9547.299
G1 X183.08 Y164.416 E-.1861
G1 X183.605 Y164.143 E-.22483
G1 X184.137 Y164.048 E-.20548
G1 X184.514 Y164.07 E-.14359
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X178.702 Y164.377 Z2.6 F60000
G1 Z2.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F3011
M204 S8000
G1 X179.498 Y164.377 E.0264
G1 X179.498 Y165.173 E.0264
G1 X178.702 Y165.173 E.0264
G1 X178.702 Y164.437 E.02441
; COOLING_NODE: 2
M204 S250
G1 X178.31 Y163.985 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2996
M204 S5000
G1 X179.89 Y163.985 E.04855
G1 X179.89 Y165.565 E.04855
G1 X178.31 Y165.565 E.04855
G1 X178.31 Y164.045 E.04671
; COOLING_NODE: 2
; WIPE_START
G1 F9547.055
M204 S8000
G1 X179.89 Y163.985 E-.60084
G1 X179.89 Y164.404 E-.15916
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.283 Y165.027 Z2.6 F60000
G1 X170.502 Y165.173 Z2.6
G1 Z2.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F3011
M204 S8000
G1 X170.502 Y164.377 E.0264
G1 X171.298 Y164.377 E.0264
G1 X171.298 Y165.173 E.0264
G1 X170.562 Y165.173 E.02441
; COOLING_NODE: 2
M204 S250
G1 X170.11 Y165.565 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2996
M204 S5000
G1 X170.11 Y163.985 E.04855
G1 X171.69 Y163.985 E.04855
G1 X171.69 Y165.565 E.04855
G1 X170.17 Y165.565 E.04671
; COOLING_NODE: 0
; WIPE_START
G1 F9547.055
M204 S8000
G1 X170.11 Y163.985 E-.60084
G1 X170.529 Y163.985 E-.15917
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X167.985 Y165.205 Z2.6 F60000
G1 Z2.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F3011
M204 S8000
G3 X165.753 Y163.642 I-2.236 J.817 E.40003
G1 X165.876 Y163.645 E.00407
G3 X167.964 Y165.149 I-.127 J2.378 E.09017
; COOLING_NODE: 0
M204 S10000
G1 X168.368 Y165.067 F60000
G1 F3011
M204 S8000
G3 X165.756 Y163.234 I-2.619 J.955 E.46836
G1 X165.898 Y163.238 E.0047
G3 X168.347 Y165.011 I-.148 J2.784 E.106
; COOLING_NODE: 0
M204 S10000
G1 X168.752 Y164.929 F60000
G1 F3011
M204 S8000
G3 X165.759 Y162.827 I-3.002 J1.093 E.53669
G1 X165.92 Y162.832 E.00534
G3 X168.731 Y164.872 I-.169 J3.19 E.12184
; COOLING_NODE: 0
M204 S250
G1 X169.121 Y164.791 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3011
M204 S5000
G1 X169.121 Y164.795 E.00013
G3 X165.761 Y162.435 I-3.37 J1.226 E.5581
G1 X165.941 Y162.44 E.00551
G3 X169.002 Y164.507 I-.19 J3.582 E.11922
G1 X169.098 Y164.736 E.00763
; WIPE_START
M73 P50 R8
G1 F9547.055
M204 S8000
G1 X169.121 Y164.795 E-.02434
G1 X169.233 Y165.154 E-.14267
G1 X169.305 Y165.523 E-.143
G1 X169.335 Y165.834 E-.11844
G1 X169.335 Y166.209 E-.14277
G1 X169.306 Y166.52 E-.11859
G1 X169.271 Y166.701 E-.0702
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X167.452 Y164.996 Z2.6 F60000
G1 Z2.2
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F3011
M204 S8000
G1 X167.107 Y164.582 E.01658
G1 X166.78 Y164.334 E.0126
G1 X166.266 Y164.103 E.01729
G1 X165.687 Y164.046 E.01789
G1 X165.48 Y164.054 E.00637
G1 X164.912 Y164.221 E.01819
G1 X164.422 Y164.545 E.01806
G1 X164.047 Y164.997 E.01804
G1 X163.82 Y165.544 E.01818
G1 X163.771 Y166.111 E.0175
G1 X163.871 Y166.679 E.01773
G1 X164.044 Y167.048 E.01252
G1 X164.419 Y167.503 E.0181
G1 X164.907 Y167.826 E.01797
G1 X165.474 Y167.995 E.01819
G1 X166.025 Y167.994 E.01693
G1 X166.594 Y167.826 E.01822
G1 X167.082 Y167.501 E.01804
G1 X167.456 Y167.047 E.01805
G1 X167.682 Y166.499 E.01821
G2 X167.679 Y165.542 I-3.282 J-.471 E.0295
G1 X167.475 Y165.051 E.01634
M204 S10000
G1 X167.122 Y165.183 F60000
G1 F3011
M204 S8000
G1 X166.83 Y164.839 E.01387
G1 X166.456 Y164.577 E.01402
G1 X165.969 Y164.438 E.01558
G1 X165.542 Y164.429 E.01311
G1 X165.073 Y164.567 E.01503
G1 X164.676 Y164.829 E.0146
G1 X164.374 Y165.194 E.01458
G1 X164.186 Y165.645 E.015
G1 X164.148 Y166.107 E.01425
G1 X164.229 Y166.554 E.01395
G1 X164.365 Y166.845 E.00988
G1 X164.674 Y167.219 E.01491
G1 X165.068 Y167.48 E.01452
G1 X165.529 Y167.618 E.01477
G1 X165.97 Y167.617 E.01356
G1 X166.432 Y167.481 E.0148
G1 X166.827 Y167.218 E.01457
G1 X167.129 Y166.851 E.01459
G1 X167.315 Y166.398 E.01505
G2 X167.31 Y165.635 I-3.357 J-.356 E.02351
G1 X167.145 Y165.239 E.01318
M204 S10000
G1 X166.72 Y165.275 F60000
G1 F3011
M204 S8000
G1 X166.495 Y165.044 E.00989
G1 X166.072 Y164.836 E.01448
G1 X165.604 Y164.804 E.01442
G1 X165.233 Y164.913 E.01188
G1 X164.931 Y165.113 E.01114
G1 X164.7 Y165.391 E.01112
G1 X164.534 Y165.875 E.01571
G1 X164.53 Y166.194 E.00979
G1 X164.686 Y166.642 E.01459
G1 X164.929 Y166.936 E.01172
G1 X165.23 Y167.135 E.01107
G1 X165.584 Y167.241 E.01136
G1 X165.915 Y167.24 E.01019
G1 X166.271 Y167.135 E.01138
G1 X166.572 Y166.935 E.01111
G1 X166.802 Y166.655 E.01113
G1 X166.963 Y166.205 E.01469
G1 X166.94 Y165.727 E.01469
G1 X166.746 Y165.329 E.01362
M204 S10000
G1 X166.383 Y165.453 F60000
G1 F3011
M204 S8000
G1 X166.123 Y165.258 E.00999
G1 X165.793 Y165.173 E.01046
G1 X165.394 Y165.259 E.01254
G1 X165.107 Y165.492 E.01137
G1 X164.951 Y165.771 E.00982
G1 X164.901 Y166.057 E.00894
G1 X164.972 Y166.363 E.00966
G1 X165.184 Y166.653 E.01101
G1 X165.511 Y166.825 E.01137
G1 X165.861 Y166.863 E.0108
G1 X166.109 Y166.79 E.00796
G1 X166.395 Y166.556 E.01135
G1 X166.565 Y166.24 E.01103
G1 X166.59 Y166.15 E.00288
G1 X166.57 Y165.82 E.01015
G1 X166.41 Y165.507 E.0108
M204 S10000
G1 X166.152 Y165.798 F60000
G1 F3011
M204 S8000
G1 X166.039 Y165.648 E.00577
G1 X165.79 Y165.555 E.00815
G1 X165.555 Y165.605 E.0074
G1 X165.353 Y165.785 E.00833
G1 X165.278 Y166.053 E.00855
G1 X165.351 Y166.263 E.00681
G1 X165.552 Y166.444 E.00833
G1 X165.806 Y166.486 E.0079
G1 X166.061 Y166.369 E.00861
G1 X166.217 Y166.094 E.00971
G1 X166.165 Y165.857 E.00748
M204 S10000
G1 X165.784 Y165.966 F60000
; LINE_WIDTH: 0.58242
G1 F3011
M204 S8000
G2 X165.788 Y166.077 I-.029 J.056 E.01161
; CHANGE_LAYER
; Z_HEIGHT: 2.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F6672.845
G1 X165.716 Y166.083 E-.19835
G1 X165.683 Y166.025 E-.18722
G1 X165.716 Y165.966 E-.18723
G1 X165.784 Y165.966 E-.18719
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 12/85
; update layer progress
M73 L12
M991 S0 P11 ;notify layer change

; OBJECT_ID: 15
M204 S10000
G17
G3 Z2.6 I.358 J1.163 P1  F60000
G1 X172.269 Y163.972 Z2.6
G1 Z2.4
G1 E.8 F1800
; FEATURE: Support interface
; LINE_WIDTH: 0.42
G1 F3194
M204 S8000
G1 X172.697 Y163.543 E.01861
G1 X173.937 Y163.543 E.03811
G1 X172.438 Y165.042 E.06514
G1 X172.43 Y166.007 E.02963
G1 X172.714 Y166.007 E.00875
G1 X175.178 Y163.543 E.10704
G1 X176.418 Y163.543 E.03811
G1 X173.955 Y166.007 E.10704
G1 X175.195 Y166.007 E.03811
G1 X177.562 Y163.64 E.10283
G1 X177.562 Y164.881 E.03811
G1 X176.266 Y166.176 E.05631
; COOLING_NODE: 1
; WIPE_START
G1 F4800
G1 X177.562 Y164.881 E-.69633
G1 X177.562 Y164.713 E-.06367
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.455 Y160.135 Z2.8 F60000
G1 X162.702 Y153.573 Z2.8
G1 Z2.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F3194
M204 S8000
G1 X162.702 Y152.777 E.0264
G1 X187.298 Y152.777 E.81589
G1 X187.298 Y153.573 E.0264
G1 X162.762 Y153.573 E.8139
; COOLING_NODE: 1
M204 S250
G1 X162.31 Y153.965 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2885
M204 S5000
G1 X162.31 Y152.385 E.04855
G1 X187.69 Y152.385 E.77986
G1 X187.69 Y153.965 E.04855
G1 X162.37 Y153.965 E.77801
M204 S10000
G1 X162.906 Y153.175 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F3194
M204 S8000
G1 X187.094 Y153.175 E.76636
; COOLING_NODE: 0
; WIPE_START
G1 F9259.259
G1 X185.094 Y153.175 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X183.195 Y160.567 Z2.8 F60000
G1 X181.92 Y165.529 Z2.8
G1 Z2.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F3194
M204 S8000
G3 X184.274 Y163.642 I2.331 J.496 E.10834
G1 X184.37 Y163.645 E.00321
G3 X181.909 Y165.588 I-.119 J2.38 E.38312
; COOLING_NODE: 0
M204 S10000
G1 X181.535 Y165.391 F60000
G1 F3194
M204 S8000
G1 X181.589 Y165.19 E.00692
G3 X184.277 Y163.235 I2.662 J.835 E.11811
G1 X184.392 Y163.238 E.00381
G3 X181.521 Y165.45 I-.14 J2.787 E.45069
; COOLING_NODE: 0
M204 S10000
G1 X181.141 Y165.288 F60000
G1 F3194
M204 S8000
G1 X181.202 Y165.068 E.00757
G3 X184.281 Y162.827 I3.051 J.957 E.13531
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X184.414 Y162.831 E.00442
G3 X181.125 Y165.359 I-.162 J3.193 E.51664
G1 X181.128 Y165.346 E.00044
; COOLING_NODE: 0
M204 S250
G1 X180.762 Y165.188 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3043
M204 S5000
G1 X180.828 Y164.95 E.00759
G3 X184.284 Y162.435 I3.425 J1.075 E.14068
G1 X184.435 Y162.44 E.00463
G3 X180.742 Y165.278 I-.182 J3.585 E.53723
G1 X180.749 Y165.247 E.00098
; WIPE_START
G1 F9547.055
M204 S8000
G1 X180.828 Y164.95 E-.11666
G1 X180.946 Y164.621 E-.13283
G1 X181.11 Y164.284 E-.14234
G1 X181.309 Y163.966 E-.14269
G1 X181.517 Y163.697 E-.12907
G1 X181.691 Y163.512 E-.09641
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X184.284 Y165.967 Z2.8 F60000
G1 Z2.4
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.58226
G1 F3194
M204 S8000
G2 X184.287 Y166.077 I-.029 J.056 E.0116
M204 S10000
G1 X183.829 Y165.842 F60000
; LINE_WIDTH: 0.41999
G1 F3194
M204 S8000
G1 X183.785 Y165.948 E.00352
G2 X183.865 Y166.298 I.822 J-.005 E.01114
G1 X184.068 Y166.445 E.00769
G1 X184.262 Y166.497 E.00619
G1 X184.554 Y166.375 E.00973
G1 X184.671 Y166.207 E.00627
G1 X184.707 Y165.99 E.00677
G1 X184.651 Y165.792 E.00631
G1 X184.416 Y165.583 E.00967
G1 X184.184 Y165.555 E.00717
G1 X183.965 Y165.653 E.00736
G1 X183.864 Y165.794 E.00532
M204 S10000
G1 X183.533 Y165.578 F60000
G1 F3194
M204 S8000
G1 X183.405 Y165.929 E.0115
G1 X183.427 Y166.215 E.00881
G1 X183.584 Y166.554 E.01149
G1 X183.801 Y166.741 E.00879
G1 X184.191 Y166.876 E.01267
G1 X184.595 Y166.796 E.01265
G1 X184.885 Y166.569 E.01132
G1 X185.061 Y166.254 E.0111
G2 X185.026 Y165.717 I-.857 J-.214 E.01681
G1 X184.825 Y165.406 E.01136
G1 X184.473 Y165.202 E.01251
G1 X184.131 Y165.18 E.01053
G1 X183.813 Y165.292 E.01035
G1 X183.575 Y165.535 E.01045
M204 S10000
G1 X183.21 Y165.375 F60000
G1 F3194
M204 S8000
G1 X183.041 Y165.82 E.0146
G1 X183.055 Y166.3 E.01478
G1 X183.25 Y166.735 E.01463
G1 X183.599 Y167.064 E.01473
G1 X184.073 Y167.238 E.01552
G1 X184.374 Y167.248 E.00927
G1 X184.75 Y167.145 E.01199
G1 X185.055 Y166.95 E.01111
G1 X185.289 Y166.676 E.01109
G1 X185.459 Y166.228 E.01473
G2 X185.311 Y165.41 I-1.406 J-.166 E.0259
G1 X185.085 Y165.127 E.01112
G1 X184.659 Y164.869 E.01533
G1 X184.312 Y164.795 E.0109
G1 X183.852 Y164.859 E.01426
G1 X183.463 Y165.08 E.01373
G1 X183.249 Y165.33 E.01013
M204 S10000
G1 X182.887 Y165.173 F60000
G1 F3194
M204 S8000
G1 X182.693 Y165.62 E.01496
G2 X182.684 Y166.386 I2.329 J.41 E.02365
G1 X182.863 Y166.841 E.01504
G2 X183.396 Y167.387 I1.933 J-1.355 E.02356
G1 X183.848 Y167.583 E.01514
G1 X184.266 Y167.628 E.01292
G2 X184.905 Y167.493 I-.389 J-3.41 E.0201
G1 X185.305 Y167.238 E.01457
G1 X185.613 Y166.878 E.01455
G1 X185.808 Y166.427 E.01511
G1 X185.843 Y166.015 E.01271
G1 X185.816 Y165.663 E.01083
G1 X185.641 Y165.22 E.01467
G1 X185.345 Y164.848 E.01459
G1 X184.941 Y164.572 E.01504
G1 X184.486 Y164.44 E.01455
G1 X184.025 Y164.43 E.01416
G1 X183.545 Y164.586 E.01552
G1 X183.206 Y164.8 E.01231
G1 X182.926 Y165.128 E.01326
M204 S10000
G1 X182.563 Y164.971 F60000
G1 F3194
M204 S8000
G1 X182.328 Y165.511 E.01811
G1 X182.266 Y165.877 E.0114
G1 X182.312 Y166.471 E.0183
G1 X182.529 Y167.022 E.01819
G1 X182.742 Y167.322 E.01131
G1 X183.194 Y167.71 E.0183
G1 X183.74 Y167.948 E.01831
G1 X184.276 Y168.005 E.01655
G1 X184.486 Y168 E.00645
G1 X185.06 Y167.841 E.01832
G1 X185.555 Y167.525 E.01803
G1 X185.936 Y167.08 E.018
G1 X186.173 Y166.535 E.01827
G1 X186.234 Y166.17 E.01136
G1 X186.188 Y165.578 E.01826
G1 X185.971 Y165.029 E.01814
G1 X185.605 Y164.569 E.01805
G1 X185.116 Y164.234 E.0182
G1 X184.593 Y164.076 E.01678
G1 X184.156 Y164.047 E.01346
G1 X183.604 Y164.143 E.01721
G1 X183.112 Y164.404 E.01712
G2 X182.602 Y164.925 I1.912 J2.375 E.02246
; COOLING_NODE: 2
; WIPE_START
G1 F9547.299
G1 X182.819 Y164.672 E-.12674
G1 X183.112 Y164.404 E-.15081
G1 X183.604 Y164.143 E-.21176
G1 X184.156 Y164.047 E-.21286
G1 X184.308 Y164.057 E-.05782
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X178.702 Y164.377 Z2.8 F60000
G1 Z2.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F3194
M204 S8000
G1 X179.498 Y164.377 E.0264
G1 X179.498 Y165.173 E.0264
G1 X178.702 Y165.173 E.0264
G1 X178.702 Y164.437 E.02441
; COOLING_NODE: 2
M204 S250
G1 X178.31 Y163.985 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2966
M204 S5000
G1 X179.89 Y163.985 E.04855
G1 X179.89 Y165.565 E.04855
G1 X178.31 Y165.565 E.04855
G1 X178.31 Y164.045 E.04671
; COOLING_NODE: 2
; WIPE_START
G1 F9547.055
M204 S8000
G1 X179.89 Y163.985 E-.60084
G1 X179.89 Y164.404 E-.15916
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.283 Y165.027 Z2.8 F60000
G1 X170.502 Y165.173 Z2.8
G1 Z2.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F3194
M204 S8000
G1 X170.502 Y164.377 E.0264
G1 X171.298 Y164.377 E.0264
G1 X171.298 Y165.173 E.0264
G1 X170.562 Y165.173 E.02441
; COOLING_NODE: 2
M204 S250
G1 X170.11 Y165.565 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2966
M204 S5000
G1 X170.11 Y163.985 E.04855
G1 X171.69 Y163.985 E.04855
G1 X171.69 Y165.565 E.04855
G1 X170.17 Y165.565 E.04671
; COOLING_NODE: 0
; WIPE_START
G1 F9547.055
M204 S8000
G1 X170.11 Y163.985 E-.60084
G1 X170.529 Y163.985 E-.15917
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X168 Y165.241 Z2.8 F60000
G1 Z2.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F3194
M204 S8000
G1 X168.004 Y165.25 E.00032
G3 X165.768 Y163.642 I-2.253 J.774 E.39915
G1 X165.874 Y163.645 E.00351
G3 X167.91 Y165.017 I-.123 J2.379 E.08557
G1 X167.978 Y165.185 E.00601
; COOLING_NODE: 0
M204 S10000
G1 X168.377 Y165.089 F60000
G1 F3194
M204 S8000
G1 X168.389 Y165.116 E.001
G3 X165.772 Y163.235 I-2.638 J.908 E.46739
G1 X165.896 Y163.238 E.00413
G3 X168.279 Y164.845 I-.145 J2.786 E.10016
G1 X168.355 Y165.033 E.00673
; COOLING_NODE: 0
M204 S10000
G1 X168.754 Y164.936 F60000
G1 F3194
M204 S8000
G1 X168.774 Y164.983 E.00169
G3 X165.775 Y162.827 I-3.022 J1.041 E.53564
G1 X165.918 Y162.832 E.00475
G3 X168.649 Y164.672 I-.166 J3.192 E.11476
G1 X168.732 Y164.881 E.00744
; COOLING_NODE: 0
M204 S250
G1 X169.117 Y164.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3043
M204 S5000
G1 X169.145 Y164.855 E.00218
G3 X165.778 Y162.435 I-3.393 J1.169 E.55704
G1 X165.939 Y162.44 E.00495
G3 X169.005 Y164.506 I-.187 J3.584 E.11932
G1 X169.095 Y164.734 E.00752
; WIPE_START
M73 P51 R8
G1 F9547.055
M204 S8000
G1 X169.145 Y164.855 E-.04971
G1 X169.233 Y165.154 E-.1186
G1 X169.305 Y165.524 E-.14332
G1 X169.335 Y165.835 E-.11851
G1 X169.335 Y166.211 E-.14279
G1 X169.305 Y166.522 E-.11876
G1 X169.271 Y166.698 E-.06832
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X165.784 Y165.966 Z2.8 F60000
G1 Z2.4
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.58234
G1 F3194
M204 S8000
G2 X165.788 Y166.077 I-.029 J.056 E.01161
M204 S10000
G1 X166.132 Y165.771 F60000
; LINE_WIDTH: 0.41999
G1 F3194
M204 S8000
G1 X165.989 Y165.618 E.00646
G1 X165.752 Y165.552 E.00755
G1 X165.497 Y165.643 E.0083
G1 X165.342 Y165.79 E.00658
G1 X165.289 Y166.126 E.01044
G1 X165.396 Y166.317 E.00672
G1 X165.632 Y166.484 E.0089
G2 X166.031 Y166.403 I.095 J-.556 E.01278
G1 X166.174 Y166.199 E.00766
G1 X166.223 Y166.03 E.00543
G1 X166.152 Y165.828 E.00657
M204 S10000
G1 X166.516 Y165.668 F60000
G1 F3194
M204 S8000
G1 X166.265 Y165.345 E.01257
G1 X165.974 Y165.202 E.00994
G1 X165.667 Y165.179 E.00948
G1 X165.394 Y165.259 E.00875
G1 X165.072 Y165.508 E.0125
G1 X164.912 Y165.914 E.0134
G1 X164.943 Y166.302 E.01197
G1 X165.184 Y166.653 E.01308
G1 X165.542 Y166.852 E.01257
G1 X165.949 Y166.847 E.01252
G1 X166.293 Y166.68 E.01175
G1 X166.475 Y166.459 E.00878
G1 X166.602 Y166.07 E.01258
G1 X166.53 Y165.726 E.0108
M204 S10000
G1 X166.861 Y165.507 F60000
G1 F3194
M204 S8000
G1 X166.561 Y165.105 E.01542
G1 X166.291 Y164.918 E.01006
G1 X165.814 Y164.795 E.01517
G2 X165.233 Y164.913 I.141 J2.175 E.01827
G1 X164.833 Y165.211 E.01532
G1 X164.647 Y165.483 E.01012
G1 X164.535 Y165.859 E.01205
G1 X164.562 Y166.329 E.01448
G1 X164.685 Y166.64 E.01026
G1 X164.929 Y166.936 E.0118
G1 X165.361 Y167.188 E.01535
G1 X165.683 Y167.253 E.0101
G1 X166.043 Y167.216 E.0111
G1 X166.48 Y167.01 E.01487
G1 X166.802 Y166.655 E.0147
G1 X166.967 Y166.181 E.01542
G1 X166.976 Y165.997 E.00568
G1 X166.875 Y165.565 E.01363
M204 S10000
G1 X167.207 Y165.345 F60000
G1 F3194
M204 S8000
G1 X166.936 Y164.937 E.01507
G1 X166.581 Y164.654 E.01394
G1 X166.168 Y164.469 E.0139
G1 X165.702 Y164.422 E.01438
G2 X165.072 Y164.568 I.452 J3.399 E.01991
G1 X164.664 Y164.838 E.01505
G1 X164.389 Y165.179 E.01345
G2 X164.157 Y165.804 I2.341 J1.225 E.02053
G1 X164.158 Y166.26 E.01402
G1 X164.289 Y166.683 E.0136
G2 X164.674 Y167.22 I2.314 J-1.254 E.02035
G1 X165.082 Y167.489 E.01501
G1 X165.507 Y167.609 E.01358
G2 X166.136 Y167.586 I.202 J-3.064 E.01937
G1 X166.594 Y167.396 E.01522
G2 X167.129 Y166.852 I-1.392 J-1.905 E.02355
G1 X167.315 Y166.399 E.01505
G1 X167.353 Y165.981 E.0129
G2 X167.224 Y165.403 I-3.059 J.38 E.01821
M204 S10000
G1 X167.552 Y165.184 F60000
G1 F3194
M204 S8000
G1 X167.224 Y164.69 E.01822
G1 X166.81 Y164.352 E.01645
G2 X165.48 Y164.055 I-1.14 J1.976 E.04253
G1 X164.911 Y164.222 E.01821
G1 X164.417 Y164.549 E.0182
G1 X164.074 Y164.972 E.01675
G1 X163.951 Y165.175 E.00729
G1 X163.78 Y165.749 E.01839
G1 X163.781 Y166.305 E.01708
G1 X163.945 Y166.837 E.01712
G1 X164.042 Y167.046 E.00707
G1 X164.419 Y167.503 E.0182
G1 X164.912 Y167.829 E.01816
G1 X165.44 Y167.98 E.01687
G1 X165.668 Y168.013 E.00708
G1 X166.23 Y167.955 E.01734
G1 X166.781 Y167.726 E.01834
G1 X167.078 Y167.506 E.01135
G1 X167.456 Y167.048 E.01826
G1 X167.681 Y166.5 E.0182
G1 X167.73 Y165.965 E.01651
G1 X167.72 Y165.754 E.00649
G1 X167.569 Y165.242 E.01641
; CHANGE_LAYER
; Z_HEIGHT: 2.6
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9547.299
G1 X167.72 Y165.754 E-.20289
G1 X167.73 Y165.965 E-.08023
G1 X167.681 Y166.5 E-.20417
G1 X167.456 Y167.048 E-.22514
G1 X167.376 Y167.144 E-.04757
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 13/85
; update layer progress
M73 L13
M991 S0 P12 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 1
M204 S10000
G17
G3 Z2.8 I1.151 J-.396 P1  F60000
G1 X162.702 Y153.573 Z2.8
G1 Z2.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2992
M204 S8000
G1 X162.702 Y152.777 E.0264
G1 X187.298 Y152.777 E.81589
G1 X187.298 Y153.573 E.0264
G1 X162.762 Y153.573 E.8139
; COOLING_NODE: 1
M204 S250
G1 X162.31 Y153.965 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2846
M204 S5000
G1 X162.31 Y152.385 E.04855
G1 X187.69 Y152.385 E.77986
G1 X187.69 Y153.965 E.04855
G1 X162.37 Y153.965 E.77801
M204 S10000
G1 X162.906 Y153.175 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F2992
M204 S8000
G1 X187.094 Y153.175 E.76636
; COOLING_NODE: 0
; WIPE_START
G1 F9259.259
G1 X185.094 Y153.175 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X183.195 Y160.567 Z3 F60000
G1 X181.928 Y165.498 Z3
G1 Z2.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2992
M204 S8000
G1 X181.971 Y165.328 E.00583
G3 X184.259 Y163.642 I2.279 J.697 E.10101
G1 X184.373 Y163.645 E.00377
G3 X181.91 Y165.57 I-.123 J2.38 E.38368
G1 X181.914 Y165.557 E.00044
; COOLING_NODE: 0
M204 S10000
G1 X181.534 Y165.4 F60000
G1 F2992
M204 S8000
G1 X181.582 Y165.209 E.00654
G3 X184.394 Y163.238 I2.668 J.816 E.12268
G3 X184.493 Y168.805 I-.145 J2.787 E.2779
G3 X181.512 Y165.492 I-.242 J-2.78 E.17123
G1 X181.52 Y165.458 E.00115
; COOLING_NODE: 0
M204 S10000
G1 X181.139 Y165.301 F60000
G1 F2992
M204 S8000
G1 X181.194 Y165.09 E.00724
G3 X184.265 Y162.827 I3.058 J.935 E.13558
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X184.416 Y162.832 E.00502
G3 X181.113 Y165.414 I-.164 J3.193 E.51476
G1 X181.126 Y165.36 E.00186
; COOLING_NODE: 0
M204 S250
G1 X180.759 Y165.207 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2942
M204 S5000
G1 X180.819 Y164.975 E.00734
G3 X184.267 Y162.435 I3.433 J1.049 E.141
G1 X184.437 Y162.44 E.00521
G3 X180.728 Y165.339 I-.185 J3.585 E.53529
G1 X180.746 Y165.265 E.00235
; WIPE_START
G1 F9547.055
M204 S8000
G1 X180.819 Y164.975 E-.11353
G1 X180.946 Y164.622 E-.14263
G1 X181.102 Y164.3 E-.13597
G1 X181.274 Y164.017 E-.12606
G1 X181.5 Y163.717 E-.14257
G1 X181.677 Y163.525 E-.09925
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X183.9 Y165.709 Z3 F60000
G1 Z2.6
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F2992
M204 S8000
G1 X183.787 Y166 E.0096
G1 X183.87 Y166.305 E.0097
G1 X184.016 Y166.434 E.00601
G1 X184.351 Y166.486 E.01042
G1 X184.541 Y166.379 E.0067
G1 X184.704 Y166.156 E.00848
G1 X184.706 Y165.981 E.00538
G1 X184.603 Y165.708 E.00896
G1 X184.377 Y165.569 E.00817
G1 X184.155 Y165.575 E.00684
G1 X183.953 Y165.681 E.00699
M204 S10000
G1 X183.592 Y165.487 F60000
G1 F2992
M204 S8000
G1 X183.456 Y165.736 E.00873
G1 X183.418 Y166.104 E.01136
G1 X183.512 Y166.426 E.01028
G1 X183.677 Y166.651 E.0086
G1 X183.863 Y166.782 E.00699
G1 X184.256 Y166.863 E.01233
G1 X184.525 Y166.832 E.00831
G1 X184.878 Y166.591 E.01315
G1 X185.078 Y166.231 E.01265
G1 X185.081 Y165.946 E.00876
G1 X184.987 Y165.622 E.01037
G1 X184.817 Y165.393 E.00877
G1 X184.548 Y165.23 E.00966
G1 X184.234 Y165.176 E.00978
G1 X183.893 Y165.259 E.01081
G1 X183.64 Y165.45 E.00974
M204 S10000
G1 X183.346 Y165.197 F60000
G1 F2992
M204 S8000
G1 X183.098 Y165.606 E.01471
G1 X183.026 Y165.96 E.0111
G1 X183.06 Y166.321 E.01116
G1 X183.278 Y166.773 E.01543
G1 X183.508 Y167.008 E.01007
G2 X184.083 Y167.241 I1.021 J-1.699 E.01916
G1 X184.553 Y167.213 E.01445
M73 P51 R7
G1 X184.864 Y167.09 E.01028
G1 X185.161 Y166.846 E.01182
G1 X185.414 Y166.412 E.01543
G1 X185.476 Y166.118 E.00924
G1 X185.44 Y165.728 E.01203
G1 X185.221 Y165.276 E.01544
G1 X184.992 Y165.042 E.01005
G1 X184.571 Y164.836 E.01442
G1 X184.103 Y164.804 E.01442
G1 X183.731 Y164.914 E.01189
G1 X183.394 Y165.161 E.01284
M204 S10000
G1 X182.907 Y165.168 F60000
G1 F2992
M204 S8000
G1 X182.739 Y165.475 E.01075
G1 X182.645 Y165.94 E.01456
G1 X182.69 Y166.413 E.01463
G1 X182.878 Y166.866 E.01505
G1 X183.175 Y167.215 E.01409
G1 X183.557 Y167.477 E.01423
G1 X184.029 Y167.618 E.01513
G1 X184.485 Y167.617 E.01403
G1 X184.906 Y167.487 E.01355
G2 X185.444 Y167.101 I-1.253 J-2.316 E.02039
G1 X185.714 Y166.693 E.01504
G1 X185.832 Y166.29 E.0129
G2 X185.81 Y165.636 I-3.434 J-.211 E.02012
G1 X185.621 Y165.182 E.0151
G1 X185.327 Y164.837 E.01392
G1 X184.958 Y164.578 E.01386
G1 X184.467 Y164.437 E.01569
G1 X184.04 Y164.43 E.01312
G1 X183.57 Y164.568 E.01504
G1 X183.163 Y164.839 E.01503
G1 X182.943 Y165.121 E.01097
M204 S10000
G1 X182.664 Y164.824 F60000
G1 F2992
M204 S8000
G1 X182.381 Y165.345 E.01821
G1 X182.265 Y165.919 E.01802
G1 X182.32 Y166.505 E.01809
G1 X182.547 Y167.053 E.01821
G1 X182.892 Y167.466 E.01654
G2 X183.404 Y167.825 I1.871 J-2.123 E.01925
G1 X183.974 Y167.995 E.01828
G1 X184.53 Y167.994 E.01708
G1 X185.058 Y167.832 E.01699
G1 X185.269 Y167.733 E.00716
G1 X185.728 Y167.356 E.01823
G1 X186.054 Y166.862 E.01819
G1 X186.205 Y166.346 E.01652
G2 X186.208 Y165.84 I-1.014 J-.259 E.01571
G1 X186.18 Y165.544 E.00914
G1 X185.951 Y164.995 E.01827
G1 X185.609 Y164.584 E.01642
G1 X185.282 Y164.335 E.01265
G1 X184.764 Y164.103 E.01743
G1 X184.184 Y164.046 E.01791
G1 X183.977 Y164.055 E.00637
G1 X183.409 Y164.223 E.0182
G1 X182.916 Y164.55 E.01819
G1 X182.705 Y164.78 E.00959
; COOLING_NODE: 2
; WIPE_START
G1 F9547.299
G1 X182.916 Y164.55 E-.11856
G1 X183.409 Y164.223 E-.22496
G1 X183.977 Y164.055 E-.22507
G1 X184.184 Y164.046 E-.07879
G1 X184.479 Y164.075 E-.11261
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X178.702 Y164.377 Z3 F60000
G1 Z2.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2992
M204 S8000
G1 X179.498 Y164.377 E.0264
G1 X179.498 Y165.173 E.0264
G1 X178.702 Y165.173 E.0264
G1 X178.702 Y164.437 E.02441
; COOLING_NODE: 2
M204 S250
G1 X178.31 Y163.985 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2918
M204 S5000
G1 X179.89 Y163.985 E.04855
G1 X179.89 Y165.565 E.04855
G1 X178.31 Y165.565 E.04855
G1 X178.31 Y164.045 E.04671
; COOLING_NODE: 2
; WIPE_START
G1 F9547.055
M204 S8000
G1 X179.89 Y163.985 E-.60084
G1 X179.89 Y164.404 E-.15916
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.283 Y165.027 Z3 F60000
G1 X170.502 Y165.173 Z3
G1 Z2.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2992
M204 S8000
G1 X170.502 Y164.377 E.0264
G1 X171.298 Y164.377 E.0264
G1 X171.298 Y165.173 E.0264
G1 X170.562 Y165.173 E.02441
; COOLING_NODE: 2
M204 S250
G1 X170.11 Y165.565 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2918
M204 S5000
G1 X170.11 Y163.985 E.04855
G1 X171.69 Y163.985 E.04855
G1 X171.69 Y165.565 E.04855
G1 X170.17 Y165.565 E.04671
; COOLING_NODE: 0
; WIPE_START
G1 F9547.055
M204 S8000
G1 X170.11 Y163.985 E-.60084
G1 X170.529 Y163.985 E-.15917
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X167.975 Y165.174 Z3 F60000
G1 Z2.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2992
M204 S8000
G1 X168.042 Y165.367 E.00677
G3 X165.782 Y163.642 I-2.29 J.658 E.39563
G1 X165.871 Y163.645 E.00296
G3 X167.955 Y165.118 I-.12 J2.38 E.08932
; COOLING_NODE: 0
M204 S10000
G1 X168.36 Y165.043 F60000
G1 F2992
M204 S8000
G1 X168.433 Y165.254 E.00744
G3 X165.787 Y163.235 I-2.682 J.77 E.46318
G1 X165.894 Y163.238 E.00356
G3 X168.341 Y164.986 I-.142 J2.786 E.10534
; COOLING_NODE: 0
M204 S10000
G1 X168.744 Y164.911 F60000
G1 F2992
M204 S8000
G1 X168.825 Y165.142 E.00812
G3 X165.791 Y162.828 I-3.073 J.883 E.53073
G1 X165.917 Y162.832 E.00417
G3 X168.722 Y164.841 I-.165 J3.193 E.1209
G1 X168.726 Y164.854 E.00046
; COOLING_NODE: 0
M204 S250
G1 X169.115 Y164.784 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2942
M204 S5000
G1 X169.202 Y165.034 E.00812
G3 X165.795 Y162.435 I-3.45 J.991 E.55188
G1 X165.938 Y162.44 E.00439
G3 X169.087 Y164.696 I-.186 J3.585 E.12572
G1 X169.097 Y164.727 E.001
; WIPE_START
G1 F9547.055
M204 S8000
G1 X169.202 Y165.034 E-.12327
G1 X169.285 Y165.4 E-.14281
G1 X169.328 Y165.729 E-.12599
G1 X169.339 Y166.087 E-.13601
G1 X169.318 Y166.417 E-.12573
G1 X169.274 Y166.693 E-.10619
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X165.784 Y165.967 Z3 F60000
G1 Z2.6
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.58232
G1 F2992
M204 S8000
M73 P52 R7
G2 X165.787 Y166.077 I-.029 J.056 E.01161
M204 S10000
G1 X166.125 Y165.753 F60000
; LINE_WIDTH: 0.41999
G1 F2992
M204 S8000
G1 X165.91 Y165.581 E.00847
G1 X165.685 Y165.555 E.00696
G1 X165.475 Y165.641 E.00696
G1 X165.307 Y165.894 E.00933
G1 X165.279 Y166.079 E.00575
G1 X165.36 Y166.271 E.00642
G1 X165.583 Y166.466 E.00909
G1 X165.854 Y166.477 E.00833
G1 X166.024 Y166.409 E.00563
G1 X166.195 Y166.152 E.00949
G1 X166.222 Y166 E.00473
G1 X166.147 Y165.809 E.00631
M204 S10000
G1 X166.434 Y165.529 F60000
G1 F2992
M204 S8000
G1 X166.124 Y165.258 E.01262
G1 X165.791 Y165.173 E.01058
G1 X165.473 Y165.218 E.00987
G1 X165.219 Y165.361 E.00894
G1 X165.034 Y165.577 E.00874
G1 X164.899 Y165.966 E.01267
G1 X164.939 Y166.288 E.00997
G1 X165.174 Y166.643 E.01308
G1 X165.529 Y166.849 E.0126
G1 X165.94 Y166.848 E.01263
G1 X166.28 Y166.69 E.01154
G1 X166.467 Y166.472 E.00881
G1 X166.601 Y166.086 E.01255
G2 X166.461 Y165.582 I-.956 J-.007 E.01629
M204 S10000
G1 X166.742 Y165.304 F60000
G1 F2992
M204 S8000
G1 X166.368 Y164.966 E.0155
G1 X166.07 Y164.835 E.01
G1 X165.579 Y164.805 E.0151
G1 X165.135 Y164.957 E.01443
G2 X164.711 Y165.374 I1.34 J1.789 E.01834
G1 X164.536 Y165.848 E.01551
G1 X164.527 Y166.17 E.00991
G1 X164.674 Y166.62 E.01453
G1 X164.914 Y166.922 E.01186
G1 X165.343 Y167.182 E.01541
G1 X165.64 Y167.25 E.00937
G1 X166.026 Y167.22 E.01188
G1 X166.462 Y167.024 E.0147
G1 X166.79 Y166.674 E.01473
G1 X166.964 Y166.204 E.0154
G2 X166.77 Y165.358 I-1.18 J-.175 E.0273
M204 S10000
G1 X167.05 Y165.08 F60000
G1 F2992
M204 S8000
G1 X166.704 Y164.729 E.01515
G1 X166.307 Y164.521 E.01378
G1 X165.833 Y164.416 E.01489
G1 X165.367 Y164.468 E.01442
G1 X164.946 Y164.629 E.01384
G1 X164.707 Y164.8 E.00904
G1 X164.387 Y165.172 E.01507
G1 X164.192 Y165.623 E.01511
G1 X164.147 Y166.072 E.01386
G1 X164.219 Y166.526 E.01411
G1 X164.349 Y166.817 E.0098
G1 X164.654 Y167.201 E.01507
G1 X165.057 Y167.477 E.01501
G1 X165.461 Y167.602 E.013
G2 X166.111 Y167.591 I.27 J-3.364 E.02002
G1 X166.569 Y167.41 E.01512
G2 X167.114 Y166.876 I-1.357 J-1.929 E.02355
G1 X167.308 Y166.427 E.01506
G1 X167.352 Y165.972 E.01403
G1 X167.276 Y165.515 E.01424
G1 X167.078 Y165.133 E.01322
M204 S10000
G1 X167.359 Y164.856 F60000
G1 F2992
M204 S8000
G1 X166.94 Y164.431 E.01831
G1 X166.469 Y164.18 E.01641
G2 X165.658 Y164.047 I-.73 J1.912 E.02543
G1 X165.104 Y164.143 E.01729
G1 X164.622 Y164.397 E.01672
G1 X164.45 Y164.519 E.00648
G1 X164.064 Y164.97 E.01824
G1 X163.827 Y165.516 E.01828
G1 X163.769 Y166.05 E.01652
G2 X164.024 Y167.014 I2.568 J-.163 E.03082
G1 X164.394 Y167.48 E.01827
G1 X164.881 Y167.814 E.01817
G1 X165.398 Y167.974 E.01662
G1 X165.607 Y168.009 E.0065
G1 X166.197 Y167.963 E.0182
G1 X166.75 Y167.744 E.01828
G1 X167.05 Y167.531 E.01129
G1 X167.437 Y167.078 E.01831
G1 X167.673 Y166.534 E.01821
G1 X167.73 Y166.002 E.01644
G2 X167.633 Y165.384 I-4.198 J.343 E.01926
G1 X167.387 Y164.909 E.01644
; CHANGE_LAYER
; Z_HEIGHT: 2.64
; LAYER_HEIGHT: 0.0400002
; WIPE_START
G1 F9547.299
G1 X167.633 Y165.384 E-.20329
G1 X167.684 Y165.605 E-.08626
G1 X167.73 Y166.002 E-.15208
G1 X167.673 Y166.534 E-.20331
G1 X167.552 Y166.812 E-.11506
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 14/85
; update layer progress
M73 L14
M991 S0 P13 ;notify layer change

; OBJECT_ID: 15
M204 S10000
G17
G3 Z3 I.495 J1.112 P1  F60000
G1 X172.269 Y164.711 Z3
G1 Z2.64
G1 E.8 F1800
; FEATURE: Support interface
; LINE_WIDTH: 0.42
; LAYER_HEIGHT: 0.24
G1 F3157
M204 S8000
G1 X173.145 Y165.587 E.04463
G1 X174.385 Y165.587 E.04469
G1 X172.762 Y163.963 E.08272
G1 X174.002 Y163.963 E.04469
G1 X175.625 Y165.587 E.08272
G1 X176.866 Y165.587 E.04469
G1 X175.242 Y163.963 E.08272
G1 X176.483 Y163.963 E.04469
G1 X177.731 Y165.212 E.06363
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

; CHANGE_LAYER
; Z_HEIGHT: 2.8
; LAYER_HEIGHT: 0.16
; WIPE_START
G1 F4800
G1 X176.483 Y163.963 E-.67103
G1 X176.248 Y163.963 E-.08898
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 15/85
; update layer progress
M73 L15
M991 S0 P14 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 1
M204 S10000
G17
G3 Z3.04 I.741 J-.966 P1  F60000
G1 X162.702 Y153.573 Z3.04
G1 Z2.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
; LAYER_HEIGHT: 0.2
G1 F3157
M204 S8000
G1 X162.702 Y152.777 E.0264
G1 X187.298 Y152.777 E.81589
G1 X187.298 Y153.573 E.0264
G1 X162.762 Y153.573 E.8139
; COOLING_NODE: 1
M204 S250
G1 X162.31 Y153.965 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2800
M204 S5000
G1 X162.31 Y152.385 E.04855
G1 X187.69 Y152.385 E.77986
G1 X187.69 Y153.965 E.04855
G1 X162.37 Y153.965 E.77801
M204 S10000
G1 X162.906 Y153.175 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F3157
M204 S8000
G1 X187.094 Y153.175 E.76636
; COOLING_NODE: 0
; WIPE_START
G1 F9259.259
G1 X185.094 Y153.175 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X183.193 Y160.567 Z3.2 F60000
G1 X181.916 Y165.53 Z3.2
G1 Z2.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F3157
M204 S8000
G3 X184.245 Y163.642 I2.331 J.495 E.10756
G1 X184.374 Y163.645 E.00431
G3 X181.904 Y165.589 I-.128 J2.38 E.38282
; COOLING_NODE: 0
M204 S10000
G1 X181.526 Y165.423 F60000
G1 F3157
M204 S8000
G1 X181.579 Y165.212 E.00721
G3 X184.246 Y163.234 I2.669 J.812 E.118
G1 X184.396 Y163.238 E.00495
G3 X181.511 Y165.481 I-.148 J2.786 E.44938
; COOLING_NODE: 0
M204 S10000
G1 X181.132 Y165.322 F60000
G1 F3157
M204 S8000
G1 X181.191 Y165.092 E.00788
G3 X184.248 Y162.827 I3.058 J.932 E.13519
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X184.417 Y162.832 E.0056
G3 X181.117 Y165.38 I-.168 J3.193 E.51572
; COOLING_NODE: 0
M204 S250
G1 X180.753 Y165.224 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2850
M204 S5000
G1 X180.817 Y164.976 E.00788
G3 X184.25 Y162.435 I3.433 J1.048 E.14056
G1 X184.438 Y162.44 E.00577
G3 X180.738 Y165.283 I-.188 J3.584 E.53692
; WIPE_START
G1 F9547.055
M204 S8000
G1 X180.817 Y164.976 E-.1203
G1 X180.946 Y164.622 E-.14308
G1 X181.11 Y164.285 E-.14272
G1 X181.273 Y164.018 E-.11879
G1 X181.5 Y163.718 E-.14282
G1 X181.664 Y163.539 E-.0923
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X183.846 Y165.781 Z3.2 F60000
G1 Z2.8
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F3157
M204 S8000
G1 X183.782 Y166.022 E.00767
G1 X183.871 Y166.307 E.00917
G1 X184.16 Y166.487 E.01045
G2 X184.555 Y166.376 I.055 J-.562 E.01291
G1 X184.7 Y166.138 E.00858
G1 X184.706 Y166.069 E.0021
G1 X184.665 Y165.798 E.00842
G1 X184.49 Y165.619 E.00769
G1 X184.271 Y165.552 E.00705
G1 X184.041 Y165.615 E.00733
G1 X183.892 Y165.742 E.00602
M204 S10000
G1 X183.501 Y165.622 F60000
G1 F3157
M204 S8000
G1 X183.4 Y166.04 E.0132
G1 X183.519 Y166.464 E.01355
G1 X183.819 Y166.753 E.01281
G1 X184.205 Y166.876 E.01244
G1 X184.625 Y166.783 E.01322
G1 X184.895 Y166.556 E.01082
G1 X185.069 Y166.23 E.01139
G2 X184.947 Y165.538 I-1.069 J-.167 E.02198
G1 X184.766 Y165.345 E.00813
G1 X184.476 Y165.202 E.00993
G1 X184.132 Y165.18 E.01059
G1 X183.757 Y165.338 E.01251
G1 X183.541 Y165.577 E.00989
M204 S10000
G1 X183.204 Y165.384 F60000
G1 F3157
M204 S8000
G1 X183.032 Y165.854 E.01535
G1 X183.043 Y166.173 E.00982
G1 X183.154 Y166.575 E.01282
G1 X183.32 Y166.829 E.00933
G1 X183.622 Y167.079 E.01203
G1 X184.079 Y167.238 E.01487
G1 X184.423 Y167.242 E.01058
G1 X184.791 Y167.126 E.01184
G1 X185.067 Y166.94 E.01023
G1 X185.301 Y166.656 E.01132
G1 X185.439 Y166.322 E.01111
G1 X185.475 Y165.961 E.01115
G1 X185.346 Y165.474 E.01549
G1 X185.168 Y165.203 E.00994
G1 X184.789 Y164.917 E.01459
G1 X184.314 Y164.795 E.01507
G1 X183.853 Y164.861 E.01432
G1 X183.532 Y165.031 E.01116
G1 X183.245 Y165.34 E.01296
M204 S10000
G1 X182.956 Y165.068 F60000
G1 F3157
M204 S8000
G2 X182.658 Y165.786 I2.04 J1.266 E.02397
G1 X182.642 Y166.096 E.00955
G1 X182.743 Y166.589 E.01545
G1 X182.946 Y166.959 E.01297
G2 X183.424 Y167.405 I2.618 J-2.326 E.02011
G1 X183.846 Y167.583 E.01408
G1 X184.313 Y167.626 E.0144
G2 X184.956 Y167.47 I-.299 J-2.631 E.02039
G1 X185.322 Y167.222 E.01358
G1 X185.628 Y166.853 E.01474
G1 X185.809 Y166.414 E.01458
G1 X185.855 Y165.941 E.01461
G1 X185.757 Y165.461 E.01506
G1 X185.535 Y165.066 E.01393
G1 X185.223 Y164.741 E.01385
G1 X184.816 Y164.525 E.01414
G1 X184.336 Y164.417 E.01513
G1 X183.885 Y164.464 E.01392
G2 X183.307 Y164.723 I.954 J2.911 E.01952
G1 X182.999 Y165.026 E.01327
M204 S10000
G1 X182.659 Y164.832 F60000
G1 F3157
M204 S8000
G1 X182.464 Y165.149 E.01142
G1 X182.284 Y165.718 E.01834
G1 X182.263 Y166.124 E.01251
G1 X182.383 Y166.71 E.01835
G1 X182.643 Y167.183 E.01661
G1 X182.769 Y167.352 E.00647
G1 X183.227 Y167.73 E.01825
G1 X183.742 Y167.948 E.01719
G2 X184.559 Y167.99 I.507 J-1.899 E.02531
G1 X185.122 Y167.813 E.01814
G1 X185.578 Y167.505 E.01693
G1 X185.955 Y167.049 E.01815
G1 X186.179 Y166.507 E.01804
G1 X186.236 Y165.921 E.01807
G1 X186.117 Y165.34 E.01822
G1 X185.857 Y164.867 E.0166
G1 X185.588 Y164.565 E.01242
G1 X185.122 Y164.237 E.01752
G2 X184.357 Y164.038 I-.869 J1.772 E.02444
G1 X183.795 Y164.098 E.0174
G1 X183.582 Y164.151 E.00673
G1 X183.081 Y164.416 E.01739
G1 X182.701 Y164.79 E.01639
; COOLING_NODE: 2
; WIPE_START
G1 F9547.299
G1 X183.081 Y164.416 E-.20274
G1 X183.582 Y164.151 E-.21509
G1 X183.795 Y164.098 E-.08324
G1 X184.357 Y164.038 E-.21515
G1 X184.471 Y164.056 E-.04378
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X178.702 Y164.377 Z3.2 F60000
G1 Z2.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F3157
M204 S8000
G1 X179.498 Y164.377 E.0264
G1 X179.498 Y165.173 E.0264
G1 X178.702 Y165.173 E.0264
G1 X178.702 Y164.437 E.02441
; COOLING_NODE: 2
M204 S250
G1 X178.31 Y163.985 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2862
M204 S5000
G1 X179.89 Y163.985 E.04855
G1 X179.89 Y165.565 E.04855
G1 X178.31 Y165.565 E.04855
G1 X178.31 Y164.045 E.04671
; COOLING_NODE: 2
; WIPE_START
G1 F9547.055
M204 S8000
G1 X179.89 Y163.985 E-.60084
G1 X179.89 Y164.404 E-.15916
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.283 Y165.027 Z3.2 F60000
G1 X170.502 Y165.173 Z3.2
G1 Z2.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F3157
M204 S8000
G1 X170.502 Y164.377 E.0264
G1 X171.298 Y164.377 E.0264
G1 X171.298 Y165.173 E.0264
G1 X170.562 Y165.173 E.02441
; COOLING_NODE: 2
M204 S250
G1 X170.11 Y165.565 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2862
M204 S5000
G1 X170.11 Y163.985 E.04855
G1 X171.69 Y163.985 E.04855
G1 X171.69 Y165.565 E.04855
G1 X170.17 Y165.565 E.04671
; COOLING_NODE: 0
; WIPE_START
G1 F9547.055
M204 S8000
G1 X170.11 Y163.985 E-.60084
G1 X170.529 Y163.985 E-.15917
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X167.975 Y165.171 Z3.2 F60000
G1 Z2.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F3157
M204 S8000
G3 X165.797 Y163.642 I-2.225 J.854 E.40302
G1 X165.868 Y163.644 E.00238
G3 X167.952 Y165.115 I-.119 J2.38 E.08928
; COOLING_NODE: 0
M204 S10000
G1 X168.356 Y165.026 F60000
G1 F3157
M204 S8000
G1 X168.446 Y165.307 E.00978
G3 X165.802 Y163.235 I-2.696 J.718 E.46195
G1 X165.892 Y163.238 E.00297
G3 X168.333 Y164.971 I-.142 J2.787 E.10483
; COOLING_NODE: 0
M204 S10000
G1 X168.742 Y164.901 F60000
G1 F3157
M204 S8000
G1 X168.839 Y165.2 E.01042
G3 X165.807 Y162.828 I-3.089 J.825 E.52935
G1 X165.915 Y162.831 E.00357
G3 X168.722 Y164.845 I-.165 J3.193 E.12104
; COOLING_NODE: 0
M204 S250
G1 X169.115 Y164.78 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2850
M204 S5000
G1 X169.218 Y165.097 E.01023
G3 X165.812 Y162.436 I-3.467 J.928 E.55048
G1 X165.937 Y162.44 E.00383
G3 X169.095 Y164.723 I-.187 J3.584 E.12659
; WIPE_START
G1 F9547.055
M204 S8000
G1 X169.218 Y165.097 E-.14928
G1 X169.285 Y165.402 E-.1189
M73 P53 R7
G1 X169.331 Y165.775 E-.14293
G1 X169.339 Y166.088 E-.11888
G1 X169.313 Y166.463 E-.14265
G1 X169.275 Y166.689 E-.08737
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X165.784 Y165.967 Z3.2 F60000
G1 Z2.8
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.58234
G1 F3157
M204 S8000
G2 X165.788 Y166.077 I-.029 J.056 E.01161
M204 S10000
G1 X166.107 Y165.732 F60000
; LINE_WIDTH: 0.41999
G1 F3157
M204 S8000
G1 X165.968 Y165.605 E.00577
G1 X165.726 Y165.553 E.00763
G1 X165.483 Y165.635 E.00785
G1 X165.317 Y165.859 E.00857
G1 X165.278 Y166.036 E.00558
G1 X165.4 Y166.329 E.00974
G1 X165.674 Y166.491 E.00978
G1 X165.997 Y166.42 E.01017
G1 X166.107 Y166.325 E.00447
G1 X166.222 Y166.014 E.01018
G1 X166.129 Y165.787 E.00753
M204 S10000
G1 X166.522 Y165.682 F60000
G1 F3157
M204 S8000
G1 X166.275 Y165.353 E.01263
G1 X165.971 Y165.202 E.01045
G1 X165.633 Y165.18 E.01041
G1 X165.323 Y165.287 E.01008
G1 X165.101 Y165.475 E.00893
G1 X164.961 Y165.722 E.00872
G1 X164.902 Y166.091 E.01147
G1 X164.979 Y166.369 E.00887
G1 X165.207 Y166.66 E.01135
G1 X165.519 Y166.835 E.011
G1 X165.705 Y166.867 E.0058
G1 X166.057 Y166.802 E.011
G1 X166.306 Y166.672 E.00864
G1 X166.539 Y166.328 E.01274
G1 X166.599 Y166.003 E.01016
G1 X166.536 Y165.74 E.00831
M204 S10000
G1 X166.87 Y165.527 F60000
G1 F3157
M204 S8000
G1 X166.576 Y165.119 E.01545
G1 X166.31 Y164.928 E.01008
G1 X165.927 Y164.813 E.01227
G1 X165.58 Y164.805 E.01068
G1 X165.133 Y164.959 E.0145
G1 X164.796 Y165.249 E.01368
G1 X164.605 Y165.586 E.01189
G1 X164.524 Y166.055 E.01463
G1 X164.63 Y166.524 E.01479
G1 X164.825 Y166.829 E.01111
G1 X165.1 Y167.065 E.01114
G1 X165.548 Y167.234 E.01471
G1 X166.026 Y167.22 E.01468
G1 X166.48 Y167.011 E.01538
G1 X166.704 Y166.801 E.00943
G1 X166.895 Y166.465 E.01187
G1 X166.976 Y165.993 E.0147
G1 X166.884 Y165.585 E.01285
M204 S10000
G1 X166.955 Y164.958 F60000
G1 F3157
M204 S8000
G1 X166.607 Y164.67 E.0139
G1 X166.166 Y164.469 E.01487
G1 X165.674 Y164.423 E.01518
G1 X165.226 Y164.502 E.014
G1 X164.804 Y164.73 E.01474
G1 X164.491 Y165.023 E.01316
G1 X164.249 Y165.449 E.01505
G1 X164.144 Y165.928 E.01506
G2 X164.282 Y166.679 I2.361 J-.045 E.02358
G1 X164.537 Y167.079 E.01458
G1 X164.898 Y167.388 E.0146
G1 X165.348 Y167.583 E.01505
G2 X166.111 Y167.591 I.407 J-2.327 E.02358
G1 X166.568 Y167.411 E.01509
G1 X166.895 Y167.147 E.01292
G2 X167.251 Y166.601 I-2.622 J-2.097 E.02003
G1 X167.356 Y166.123 E.01506
G2 X167.219 Y165.371 I-3.364 J.228 E.02352
G1 X166.987 Y165.009 E.01322
M204 S10000
G1 X167.248 Y164.717 F60000
G1 F3157
M204 S8000
G1 X166.835 Y164.368 E.01659
G2 X165.657 Y164.047 I-1.166 J1.949 E.03799
G1 X165.102 Y164.144 E.01731
G1 X164.609 Y164.406 E.01715
G2 X164.186 Y164.797 I1.657 J2.221 E.01774
G1 X163.893 Y165.312 E.01822
G1 X163.766 Y165.891 E.01821
G1 X163.775 Y166.257 E.01126
G1 X163.933 Y166.834 E.01838
G1 X164.249 Y167.329 E.01805
G1 X164.696 Y167.712 E.01807
G1 X165.24 Y167.947 E.01821
G1 X165.607 Y168.009 E.01145
G1 X166.197 Y167.963 E.01818
G1 X166.749 Y167.745 E.01824
G1 X167.164 Y167.411 E.01635
G1 X167.315 Y167.253 E.00671
G1 X167.607 Y166.738 E.01819
G1 X167.734 Y166.159 E.01822
G2 X167.567 Y165.216 I-3.315 J.102 E.02952
G1 X167.28 Y164.767 E.01638
; CHANGE_LAYER
; Z_HEIGHT: 2.88
; LAYER_HEIGHT: 0.0800002
; WIPE_START
G1 F9547.299
G1 X167.567 Y165.216 E-.20252
G1 X167.675 Y165.608 E-.15454
G1 X167.73 Y165.973 E-.1402
G1 X167.734 Y166.159 E-.0706
G1 X167.625 Y166.653 E-.19213
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 16/85
; update layer progress
M73 L16
M991 S0 P15 ;notify layer change

; OBJECT_ID: 15
M204 S10000
G17
G3 Z3.2 I.519 J1.101 P1  F60000
G1 X173.687 Y163.794 Z3.2
G1 Z2.88
G1 E.8 F1800
; FEATURE: Support interface
; LINE_WIDTH: 0.42
; LAYER_HEIGHT: 0.24
G1 F2741
M204 S8000
G1 X172.438 Y165.042 E.06363
G1 X172.438 Y165.587 E.01962
G1 X173.134 Y165.587 E.02508
G1 X174.758 Y163.963 E.08272
G1 X175.998 Y163.963 E.04469
G1 X174.375 Y165.587 E.08272
G1 X175.615 Y165.587 E.04469
G1 X177.238 Y163.963 E.08272
G1 X177.562 Y163.963 E.01164
G1 X177.562 Y164.881 E.03305
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X176.686 Y165.756 E.04463
; CHANGE_LAYER
; Z_HEIGHT: 3
; LAYER_HEIGHT: 0.12
; WIPE_START
G1 F4800
G1 X177.562 Y164.881 E-.47063
G1 X177.562 Y164.119 E-.28937
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 17/85
; update layer progress
M73 L17
M991 S0 P16 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 1
M204 S10000
G17
G3 Z3.28 I.704 J-.992 P1  F60000
G1 X162.702 Y153.573 Z3.28
G1 Z3
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
; LAYER_HEIGHT: 0.2
G1 F2741
M204 S8000
G1 X162.702 Y152.777 E.0264
G1 X187.298 Y152.777 E.81589
G1 X187.298 Y153.573 E.0264
G1 X162.762 Y153.573 E.8139
; COOLING_NODE: 1
M204 S250
G1 X162.31 Y153.965 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2741
M204 S5000
G1 X162.31 Y152.385 E.04855
G1 X187.69 Y152.385 E.77986
G1 X187.69 Y153.965 E.04855
G1 X162.37 Y153.965 E.77801
M204 S10000
G1 X162.906 Y153.175 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F2741
M204 S8000
G1 X187.094 Y153.175 E.76636
; COOLING_NODE: 0
; WIPE_START
G1 F9259.259
G1 X185.094 Y153.175 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X183.192 Y160.567 Z3.4 F60000
G1 X181.937 Y165.443 Z3.4
G1 Z3
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2741
M204 S8000
G3 X184.251 Y163.642 I2.311 J.582 E.10478
G1 X184.374 Y163.645 E.00407
G3 X181.923 Y165.501 I-.126 J2.38 E.38583
; COOLING_NODE: 0
M204 S10000
G1 X181.533 Y165.396 F60000
G1 F2741
M204 S8000
G1 X181.543 Y165.346 E.00168
G3 X184.254 Y163.234 I2.706 J.678 E.1228
G1 X184.395 Y163.238 E.00471
G3 X181.486 Y165.637 I-.146 J2.786 E.44418
G1 X181.522 Y165.455 E.00615
; COOLING_NODE: 0
M204 S10000
G1 X181.134 Y165.318 F60000
G1 F2741
M204 S8000
G1 X181.149 Y165.249 E.00234
G3 X184.417 Y162.832 I3.102 J.776 E.14614
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G3 X184.529 Y169.211 I-.168 J3.193 E.31838
G3 X181.084 Y165.58 I-.278 J-3.186 E.19064
G1 X181.123 Y165.377 E.00685
; COOLING_NODE: 0
M204 S250
G1 X180.75 Y165.244 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2741
M204 S5000
G1 X180.768 Y165.156 E.00275
G3 X184.258 Y162.435 I3.483 J.869 E.1465
G1 X184.437 Y162.44 E.00552
G3 X180.697 Y165.526 I-.186 J3.584 E.52937
G1 X180.739 Y165.303 E.00697
; WIPE_START
G1 F9547.055
M204 S8000
G1 X180.768 Y165.156 E-.05686
G1 X180.856 Y164.857 E-.11848
G1 X180.997 Y164.507 E-.14307
G1 X181.141 Y164.23 E-.11886
G1 X181.346 Y163.915 E-.14279
G1 X181.582 Y163.623 E-.14296
G1 X181.651 Y163.554 E-.03698
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X184.338 Y168.047 Z3.4 F60000
G1 Z3
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F2741
M204 S8000
G3 X182.857 Y167.495 I-.088 J-2.028 E.05386
G1 X183.189 Y167.207 E.01458
G2 X183.555 Y165.569 I-1.407 J-1.175 E.05783
G2 X182.691 Y164.722 I-2.895 J2.089 E.04034
G3 X184.766 Y164.057 I1.563 J1.31 E.07625
G2 X185.056 Y165.241 I1.008 J.38 E.04298
G1 X185.809 Y165.896 E.03311
G1 X186.19 Y166.611 E.02687
G2 X186.022 Y165.038 I-2.162 J-.564 E.05364
; COOLING_NODE: 2
; WIPE_START
G1 F8843.478
G1 X186.263 Y165.734 E-.27997
G1 X186.281 Y166.135 E-.15249
G1 X186.19 Y166.611 E-.18416
G1 X186.013 Y166.278 E-.14339
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X178.702 Y164.377 Z3.4 F60000
G1 Z3
G1 E.8 F1800
; FEATURE: Inner wall
G1 F2741
M204 S8000
G1 X179.498 Y164.377 E.0264
G1 X179.498 Y165.173 E.0264
G1 X178.702 Y165.173 E.0264
G1 X178.702 Y164.437 E.02441
; COOLING_NODE: 2
M204 S250
G1 X178.31 Y163.985 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2741
M204 S5000
G1 X179.89 Y163.985 E.04855
G1 X179.89 Y165.565 E.04855
G1 X178.31 Y165.565 E.04855
G1 X178.31 Y164.045 E.04671
; COOLING_NODE: 2
; WIPE_START
G1 F9547.055
M204 S8000
G1 X179.89 Y163.985 E-.60084
G1 X179.89 Y164.404 E-.15916
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.283 Y165.027 Z3.4 F60000
G1 X170.502 Y165.173 Z3.4
G1 Z3
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2741
M204 S8000
G1 X170.502 Y164.377 E.0264
G1 X171.298 Y164.377 E.0264
G1 X171.298 Y165.173 E.0264
G1 X170.562 Y165.173 E.02441
; COOLING_NODE: 2
M204 S250
G1 X170.11 Y165.565 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2741
M204 S5000
G1 X170.11 Y163.985 E.04855
G1 X171.69 Y163.985 E.04855
G1 X171.69 Y165.565 E.04855
G1 X170.17 Y165.565 E.04671
; COOLING_NODE: 0
; WIPE_START
G1 F9547.055
M204 S8000
G1 X170.11 Y163.985 E-.60084
G1 X170.529 Y163.985 E-.15917
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X167.988 Y165.211 Z3.4 F60000
G1 Z3
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2741
M204 S8000
G3 X165.751 Y163.642 I-2.24 J.814 E.40015
G1 X165.874 Y163.645 E.00407
G3 X167.967 Y165.155 I-.126 J2.38 E.09046
; COOLING_NODE: 0
M204 S10000
G1 X168.371 Y165.071 F60000
G1 F2741
M204 S8000
G3 X165.754 Y163.234 I-2.622 J.953 E.46856
G1 X165.895 Y163.238 E.00471
G3 X168.35 Y165.015 I-.146 J2.786 E.10626
; COOLING_NODE: 0
M204 S10000
G1 X168.743 Y164.911 F60000
G1 F2741
M204 S8000
G1 X168.807 Y165.09 E.00631
G3 X166.029 Y169.211 I-3.058 J.935 E.1888
G3 X165.917 Y162.832 I-.278 J-3.186 E.34801
G3 X168.692 Y164.774 I-.168 J3.193 E.1184
G1 X168.722 Y164.855 E.00287
; COOLING_NODE: 0
M204 S250
G1 X169.115 Y164.776 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2741
M204 S5000
G1 X169.124 Y164.797 E.00071
G3 X165.758 Y162.435 I-3.373 J1.228 E.55844
G1 X165.937 Y162.44 E.00552
G3 X169.004 Y164.508 I-.186 J3.584 E.1194
G1 X169.092 Y164.72 E.00706
; WIPE_START
G1 F9547.055
M204 S8000
G1 X169.124 Y164.797 E-.0316
M73 P54 R7
G1 X169.233 Y165.156 E-.14282
G1 X169.305 Y165.525 E-.14283
G1 X169.335 Y165.836 E-.11849
G1 X169.335 Y166.213 E-.14337
G1 X169.305 Y166.524 E-.11885
G1 X169.274 Y166.685 E-.06203
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X164.995 Y164.145 Z3.4 F60000
G1 Z3
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F2741
M204 S8000
G3 X166.576 Y164.173 I.754 J2.096 E.05364
G1 X166.811 Y164.586 E.01577
G3 X167.678 Y165.38 I-1.874 J2.914 E.03916
G3 X164.923 Y167.88 I-1.954 J.614 E.15469
G2 X165.303 Y167.207 I-1.013 J-1.016 E.02595
G2 X164.844 Y165.896 I-1.837 J-.092 E.04723
G3 X163.958 Y165.078 I1.937 J-2.986 E.04021
G2 X163.818 Y166.655 I2.34 J1.003 E.05341
; CHANGE_LAYER
; Z_HEIGHT: 3.12
; LAYER_HEIGHT: 0.12
; WIPE_START
G1 F8843.478
G1 X163.719 Y165.914 E-.28404
G1 X163.778 Y165.529 E-.14822
G1 X163.958 Y165.078 E-.18447
G1 X164.235 Y165.334 E-.14327
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 18/85
; update layer progress
M73 L18
M991 S0 P17 ;notify layer change

; OBJECT_ID: 15
M204 S10000
G17
G3 Z3.4 I.094 J1.213 P1  F60000
G1 X172.269 Y164.711 Z3.4
G1 Z3.12
G1 E.8 F1800
; FEATURE: Support interface
; LINE_WIDTH: 0.42
; LAYER_HEIGHT: 0.24
G1 F2744
M204 S8000
G1 X173.145 Y165.587 E.04463
G1 X174.385 Y165.587 E.04469
G1 X172.762 Y163.963 E.08272
G1 X174.002 Y163.963 E.04469
G1 X175.625 Y165.587 E.08272
G1 X176.866 Y165.587 E.04469
G1 X175.242 Y163.963 E.08272
G1 X176.483 Y163.963 E.04469
G1 X177.731 Y165.212 E.06363
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

; CHANGE_LAYER
; Z_HEIGHT: 3.2
; LAYER_HEIGHT: 0.0800002
; WIPE_START
G1 F4800
G1 X176.483 Y163.963 E-.67103
G1 X176.248 Y163.963 E-.08898
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 19/85
; update layer progress
M73 L19
M991 S0 P18 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 1
M204 S10000
G17
G3 Z3.52 I.741 J-.966 P1  F60000
G1 X162.702 Y153.573 Z3.52
G1 Z3.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
; LAYER_HEIGHT: 0.2
G1 F2744
M204 S8000
G1 X162.702 Y152.777 E.0264
G1 X187.298 Y152.777 E.81589
G1 X187.298 Y153.573 E.0264
G1 X162.762 Y153.573 E.8139
; COOLING_NODE: 1
M204 S250
G1 X162.31 Y153.965 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2694
M204 S5000
G1 X162.31 Y152.385 E.04855
G1 X187.69 Y152.385 E.77986
G1 X187.69 Y153.965 E.04855
G1 X162.37 Y153.965 E.77801
M204 S10000
G1 X162.906 Y153.175 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F2744
M204 S8000
G1 X187.094 Y153.175 E.76636
; COOLING_NODE: 0
; WIPE_START
G1 F9259.259
G1 X185.094 Y153.175 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X183.193 Y160.567 Z3.6 F60000
G1 X181.938 Y165.448 Z3.6
G1 Z3.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2744
M204 S8000
G3 X184.259 Y163.642 I2.312 J.576 E.10517
G1 X184.373 Y163.645 E.00377
G3 X181.924 Y165.506 I-.123 J2.38 E.38573
; COOLING_NODE: 0
M204 S10000
G1 X181.529 Y165.417 F60000
G1 F2744
M204 S8000
G1 X181.543 Y165.35 E.00228
G3 X184.262 Y163.235 I2.707 J.675 E.12316
G1 X184.395 Y163.238 E.0044
G3 X181.488 Y165.637 I-.144 J2.786 E.44424
G1 X181.518 Y165.476 E.00544
; COOLING_NODE: 0
M204 S10000
G1 X181.13 Y165.34 F60000
G1 F2744
M204 S8000
G1 X181.149 Y165.251 E.00299
G3 X184.265 Y162.827 I3.102 J.773 E.14114
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X184.417 Y162.832 E.00503
G3 X181.085 Y165.58 I-.165 J3.193 E.50907
G1 X181.119 Y165.399 E.00614
; COOLING_NODE: 0
M204 S250
G1 X180.746 Y165.265 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2680
M204 S5000
G1 X180.769 Y165.157 E.0034
G3 X184.268 Y162.435 I3.483 J.868 E.14679
G1 X184.437 Y162.44 E.00522
G3 X180.698 Y165.526 I-.185 J3.585 E.5294
G1 X180.735 Y165.324 E.00631
; WIPE_START
G1 F9547.055
M204 S8000
G1 X180.769 Y165.157 E-.06479
G1 X180.877 Y164.797 E-.14267
G1 X180.996 Y164.508 E-.119
G1 X181.173 Y164.176 E-.14262
G1 X181.383 Y163.864 E-.14311
G1 X181.582 Y163.623 E-.11897
G1 X181.636 Y163.569 E-.02885
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X184.219 Y168.057 Z3.6 F60000
G1 Z3.2
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F2744
M204 S8000
G3 X182.77 Y167.414 I.074 J-2.122 E.05388
G1 X183.109 Y167.207 E.01317
G2 X183.881 Y165.569 I-1.782 J-1.842 E.0614
G1 X183.683 Y165.241 E.0127
G1 X182.748 Y164.668 E.03639
G3 X184.681 Y164.039 I1.592 J1.612 E.0699
G2 X184.463 Y164.914 I1.517 J.841 E.03024
G1 X184.661 Y165.241 E.0127
G1 X185.729 Y165.896 E.04156
G1 X186.222 Y166.521 E.02638
G2 X185.977 Y164.954 I-1.982 J-.493 E.05402
; COOLING_NODE: 2
; WIPE_START
G1 F8843.478
G1 X186.162 Y165.33 E-.15914
G1 X186.263 Y165.734 E-.15861
G1 X186.222 Y166.521 E-.29916
G1 X185.989 Y166.225 E-.14309
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X178.702 Y164.377 Z3.6 F60000
G1 Z3.2
G1 E.8 F1800
; FEATURE: Inner wall
G1 F2744
M204 S8000
G1 X179.498 Y164.377 E.0264
G1 X179.498 Y165.173 E.0264
G1 X178.702 Y165.173 E.0264
G1 X178.702 Y164.437 E.02441
; COOLING_NODE: 2
M204 S250
G1 X178.31 Y163.985 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2744
M204 S5000
G1 X179.89 Y163.985 E.04855
G1 X179.89 Y165.565 E.04855
G1 X178.31 Y165.565 E.04855
G1 X178.31 Y164.045 E.04671
; COOLING_NODE: 2
; WIPE_START
G1 F9547.055
M204 S8000
G1 X179.89 Y163.985 E-.60084
G1 X179.89 Y164.404 E-.15916
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.283 Y165.027 Z3.6 F60000
G1 X170.502 Y165.173 Z3.6
G1 Z3.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2744
M204 S8000
G1 X170.502 Y164.377 E.0264
G1 X171.298 Y164.377 E.0264
G1 X171.298 Y165.173 E.0264
G1 X170.562 Y165.173 E.02441
; COOLING_NODE: 2
M204 S250
G1 X170.11 Y165.565 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2744
M204 S5000
G1 X170.11 Y163.985 E.04855
G1 X171.69 Y163.985 E.04855
G1 X171.69 Y165.565 E.04855
G1 X170.17 Y165.565 E.04671
; COOLING_NODE: 0
; WIPE_START
G1 F9547.055
M204 S8000
G1 X170.11 Y163.985 E-.60084
G1 X170.529 Y163.985 E-.15917
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X167.987 Y165.204 Z3.6 F60000
G1 Z3.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2744
M204 S8000
G3 X165.759 Y163.642 I-2.238 J.82 E.40063
G1 X165.873 Y163.645 E.00377
G3 X167.966 Y165.148 I-.123 J2.38 E.09032
; COOLING_NODE: 0
M204 S10000
G1 X168.371 Y165.067 F60000
G1 F2744
M204 S8000
G3 X165.762 Y163.235 I-2.621 J.958 E.469
G1 X165.895 Y163.238 E.0044
G3 X168.35 Y165.011 I-.144 J2.787 E.10617
; COOLING_NODE: 0
M204 S10000
G1 X168.755 Y164.929 F60000
G1 F2744
M204 S8000
G3 X165.765 Y162.827 I-3.004 J1.096 E.53737
G1 X165.917 Y162.832 E.00503
G3 X168.734 Y164.873 I-.165 J3.193 E.12203
; COOLING_NODE: 0
M204 S250
G1 X169.113 Y164.771 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2680
M204 S5000
G1 X169.125 Y164.796 E.00085
G3 X165.768 Y162.435 I-3.373 J1.228 E.55876
G1 X165.937 Y162.44 E.00522
G3 X169.005 Y164.507 I-.185 J3.585 E.11942
G1 X169.09 Y164.716 E.00691
; WIPE_START
G1 F9547.055
M204 S8000
G1 X169.125 Y164.796 E-.03329
G1 X169.233 Y165.156 E-.14282
G1 X169.305 Y165.526 E-.14309
G1 X169.335 Y165.837 E-.11869
G1 X169.335 Y166.213 E-.14312
G1 X169.305 Y166.525 E-.11885
G1 X169.275 Y166.68 E-.06014
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X164.98 Y164.152 Z3.6 F60000
G1 Z3.2
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F2744
M204 S8000
G3 X166.561 Y164.167 I.771 J2.076 E.05364
G2 X167.468 Y164.94 I1.505 J-.848 E.04036
G3 X167.385 Y167.207 I-1.727 J1.072 E.07984
G1 X166.317 Y167.862 E.04156
G3 X166.069 Y168.033 I-.212 J-.041 E.01106
G3 X165.168 Y167.966 I-.287 J-2.233 E.03017
G2 X165.512 Y167.207 I-.341 J-.612 E.02962
G2 X163.847 Y165.334 I-2.719 J.74 E.08614
G3 X164.922 Y164.178 I1.9 J.689 E.0538
; CHANGE_LAYER
; Z_HEIGHT: 3.36
; LAYER_HEIGHT: 0.16
; WIPE_START
G1 F8843.478
G1 X164.394 Y164.508 E-.23674
M73 P55 R7
G1 X164.006 Y164.977 E-.23149
G1 X163.847 Y165.334 E-.14825
G1 X164.169 Y165.531 E-.14353
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 20/85
; update layer progress
M73 L20
M991 S0 P19 ;notify layer change

; OBJECT_ID: 15
M204 S10000
G17
G3 Z3.6 I.219 J1.197 P1  F60000
G1 X173.687 Y163.794 Z3.6
G1 Z3.36
G1 E.8 F1800
; FEATURE: Support interface
; LINE_WIDTH: 0.42
; LAYER_HEIGHT: 0.24
G1 F2733
M204 S8000
G1 X172.438 Y165.042 E.06363
G1 X172.438 Y165.587 E.01962
G1 X173.134 Y165.587 E.02508
G1 X174.758 Y163.963 E.08272
G1 X175.998 Y163.963 E.04469
G1 X174.375 Y165.587 E.08272
G1 X175.615 Y165.587 E.04469
G1 X177.238 Y163.963 E.08272
G1 X177.562 Y163.963 E.01164
G1 X177.562 Y164.881 E.03305
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X176.686 Y165.756 E.04463
; CHANGE_LAYER
; Z_HEIGHT: 3.4
; LAYER_HEIGHT: 0.0400002
; WIPE_START
G1 F4800
G1 X177.562 Y164.881 E-.47063
G1 X177.562 Y164.119 E-.28937
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 21/85
; update layer progress
M73 L21
M991 S0 P20 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 1
M204 S10000
G17
G3 Z3.76 I.704 J-.992 P1  F60000
G1 X162.702 Y153.573 Z3.76
G1 Z3.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
; LAYER_HEIGHT: 0.2
G1 F2733
M204 S8000
G1 X162.702 Y152.777 E.0264
G1 X187.298 Y152.777 E.81589
G1 X187.298 Y153.573 E.0264
G1 X162.762 Y153.573 E.8139
; COOLING_NODE: 1
M204 S250
G1 X162.31 Y153.965 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2629
M204 S5000
G1 X162.31 Y152.385 E.04855
G1 X187.69 Y152.385 E.77986
G1 X187.69 Y153.965 E.04855
G1 X162.37 Y153.965 E.77801
M204 S10000
G1 X162.906 Y153.175 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F2733
M204 S8000
G1 X187.094 Y153.175 E.76636
; COOLING_NODE: 0
; WIPE_START
G1 F9259.259
G1 X185.094 Y153.175 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X183.194 Y160.567 Z3.8 F60000
G1 X181.935 Y165.467 Z3.8
G1 Z3.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2733
M204 S8000
G1 X181.938 Y165.449 E.00062
G3 X184.267 Y163.642 I2.312 J.576 E.10542
G1 X184.372 Y163.645 E.00349
G3 X181.871 Y165.895 I-.122 J2.38 E.37276
G1 X181.926 Y165.526 E.01235
; COOLING_NODE: 0
M204 S10000
G1 X181.525 Y165.439 F60000
G1 F2733
M204 S8000
G1 X181.544 Y165.35 E.00302
G3 X184.271 Y163.235 I2.707 J.674 E.12342
G1 X184.394 Y163.238 E.00411
G3 X181.488 Y165.637 I-.143 J2.786 E.4443
G1 X181.514 Y165.498 E.00467
; COOLING_NODE: 0
M204 S10000
G1 X181.126 Y165.362 F60000
G1 F2733
M204 S8000
G1 X181.15 Y165.252 E.00372
G3 X184.274 Y162.827 I3.102 J.773 E.14143
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X184.416 Y162.832 E.00472
G3 X181.086 Y165.58 I-.164 J3.193 E.50912
G1 X181.115 Y165.421 E.00538
; COOLING_NODE: 0
M204 S250
G1 X180.741 Y165.287 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2599
M204 S5000
G1 X180.77 Y165.157 E.00408
G3 X184.277 Y162.435 I3.483 J.867 E.14707
G1 X184.437 Y162.44 E.00493
G3 X180.698 Y165.526 I-.185 J3.585 E.52942
G1 X180.731 Y165.346 E.00561
; WIPE_START
G1 F9547.055
M204 S8000
G1 X180.77 Y165.157 E-.07324
G1 X180.877 Y164.797 E-.14283
G1 X180.982 Y164.54 E-.1054
G1 X181.141 Y164.23 E-.13254
G1 X181.346 Y163.915 E-.14267
G1 X181.582 Y163.623 E-.143
G1 X181.62 Y163.585 E-.02031
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X185.341 Y167.735 Z3.8 F60000
G1 Z3.4
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F2733
M204 S8000
G2 X186.236 Y166.431 I-1.137 J-1.74 E.05385
G1 X186.138 Y166.286 E.00579
G2 X184.5 Y165.627 I-1.589 J1.583 E.0602
G1 X184.172 Y165.858 E.01329
G1 X183.517 Y166.817 E.03853
G1 X182.862 Y167.297 E.02694
G1 X182.706 Y167.343 E.00538
G3 X182.783 Y164.619 I1.621 J-1.318 E.09848
G1 X182.862 Y164.676 E.00324
G2 X183.845 Y164.856 I.756 J-1.359 E.03374
G1 X184.172 Y164.625 E.01329
G1 X184.58 Y164.029 E.02395
G3 X185.915 Y164.872 I-.424 J2.15 E.05361
; COOLING_NODE: 2
; WIPE_START
G1 F8843.478
G1 X185.479 Y164.405 E-.24299
G1 X184.945 Y164.113 E-.23106
G1 X184.58 Y164.029 E-.14268
G1 X184.367 Y164.34 E-.14328
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X178.702 Y164.377 Z3.8 F60000
G1 Z3.4
G1 E.8 F1800
; FEATURE: Inner wall
G1 F2733
M204 S8000
G1 X179.498 Y164.377 E.0264
G1 X179.498 Y165.173 E.0264
G1 X178.702 Y165.173 E.0264
G1 X178.702 Y164.437 E.02441
; COOLING_NODE: 2
M204 S250
G1 X178.31 Y163.985 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2702
M204 S5000
G1 X179.89 Y163.985 E.04855
G1 X179.89 Y165.565 E.04855
G1 X178.31 Y165.565 E.04855
G1 X178.31 Y164.045 E.04671
; COOLING_NODE: 2
; WIPE_START
G1 F9547.055
M204 S8000
G1 X179.89 Y163.985 E-.60084
G1 X179.89 Y164.404 E-.15916
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.283 Y165.027 Z3.8 F60000
G1 X170.502 Y165.173 Z3.8
G1 Z3.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2733
M204 S8000
G1 X170.502 Y164.377 E.0264
G1 X171.298 Y164.377 E.0264
G1 X171.298 Y165.173 E.0264
G1 X170.562 Y165.173 E.02441
; COOLING_NODE: 2
M204 S250
G1 X170.11 Y165.565 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2702
M204 S5000
G1 X170.11 Y163.985 E.04855
G1 X171.69 Y163.985 E.04855
G1 X171.69 Y165.565 E.04855
G1 X170.17 Y165.565 E.04671
; COOLING_NODE: 0
; WIPE_START
G1 F9547.055
M204 S8000
G1 X170.11 Y163.985 E-.60084
G1 X170.529 Y163.985 E-.15917
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X167.995 Y165.226 Z3.8 F60000
G1 Z3.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2733
M204 S8000
G3 X165.767 Y163.642 I-2.245 J.798 E.39993
G1 X165.872 Y163.645 E.00349
G3 X167.975 Y165.17 I-.122 J2.379 E.09111
; COOLING_NODE: 0
M204 S10000
G1 X168.38 Y165.09 F60000
G1 F2733
M204 S8000
G3 X165.771 Y163.235 I-2.628 J.934 E.46824
G1 X165.894 Y163.238 E.00411
G3 X168.359 Y165.034 I-.143 J2.786 E.10701
; COOLING_NODE: 0
M204 S10000
G1 X168.748 Y164.916 F60000
G1 F2733
M204 S8000
G1 X168.764 Y164.953 E.00135
G3 X165.774 Y162.827 I-3.012 J1.07 E.53655
G1 X165.916 Y162.832 E.00472
G3 X168.649 Y164.673 I-.164 J3.192 E.11483
G1 X168.725 Y164.861 E.00673
; COOLING_NODE: 0
M204 S250
G1 X169.11 Y164.768 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2599
M204 S5000
G1 X169.134 Y164.822 E.00183
G3 X165.777 Y162.435 I-3.381 J1.201 E.55794
G1 X165.937 Y162.44 E.00493
G3 X169.005 Y164.507 I-.185 J3.583 E.11942
G1 X169.088 Y164.712 E.00679
; WIPE_START
G1 F9547.055
M204 S8000
G1 X169.134 Y164.822 E-.04537
G1 X169.233 Y165.156 E-.13241
G1 X169.305 Y165.525 E-.14293
G1 X169.336 Y165.864 E-.12928
G1 X169.335 Y166.212 E-.13234
G1 X169.296 Y166.586 E-.14292
G1 X169.278 Y166.676 E-.03475
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X164.838 Y164.209 Z3.8 F60000
G1 Z3.4
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F2733
M204 S8000
G3 X166.421 Y164.105 I.955 J2.443 E.05346
G1 X167.138 Y164.676 E.03041
G3 X167.51 Y165.005 I-.094 J.482 E.01724
G3 X167.526 Y167.013 I-1.833 J1.019 E.06947
G3 X166.155 Y167.476 I-1.296 J-1.573 E.04906
G1 X165.828 Y167.246 E.01329
G1 X165.173 Y166.286 E.03853
G2 X163.759 Y165.618 I-1.717 J1.8 E.05276
G2 X164.077 Y167.168 I1.952 J.407 E.05397
; CHANGE_LAYER
; Z_HEIGHT: 3.6
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F8843.478
G1 X163.776 Y166.517 E-.27244
G1 X163.717 Y165.942 E-.2197
G1 X163.759 Y165.618 E-.12428
G1 X164.126 Y165.709 E-.14358
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 22/85
; update layer progress
M73 L22
M991 S0 P21 ;notify layer change

; OBJECT_ID: 15
M204 S10000
G17
G3 Z3.8 I.148 J1.208 P1  F60000
G1 X172.269 Y164.711 Z3.8
G1 Z3.6
G1 E.8 F1800
; FEATURE: Support interface
; LINE_WIDTH: 0.42
; LAYER_HEIGHT: 0.24
G1 F2731
M204 S8000
G1 X173.144 Y165.587 E.04462
G1 X174.385 Y165.587 E.04469
G1 X172.762 Y163.963 E.08271
G1 X174.002 Y163.963 E.04469
G1 X175.625 Y165.587 E.08271
G1 X176.865 Y165.587 E.04469
G1 X175.242 Y163.963 E.08271
M73 P56 R7
G1 X176.483 Y163.963 E.04469
G1 X177.731 Y165.212 E.06362
; COOLING_NODE: 1
; WIPE_START
G1 F4800
G1 X176.483 Y163.963 E-.67097
G1 X176.248 Y163.963 E-.08903
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X170.192 Y159.318 Z4 F60000
G1 X162.702 Y153.573 Z4
G1 Z3.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
; LAYER_HEIGHT: 0.2
G1 F2731
M204 S8000
G1 X162.702 Y152.777 E.0264
G1 X187.298 Y152.777 E.81589
G1 X187.298 Y153.573 E.0264
G1 X162.762 Y153.573 E.8139
; COOLING_NODE: 1
M204 S250
G1 X162.31 Y153.965 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2558
M204 S5000
G1 X162.31 Y152.385 E.04855
G1 X187.69 Y152.385 E.77986
G1 X187.69 Y153.965 E.04855
G1 X162.37 Y153.965 E.77801
M204 S10000
G1 X162.906 Y153.175 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F2731
M204 S8000
G1 X187.094 Y153.175 E.76636
; COOLING_NODE: 0
; WIPE_START
G1 F9259.259
G1 X185.094 Y153.175 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X183.195 Y160.567 Z4 F60000
G1 X181.919 Y165.536 Z4
G1 Z3.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2731
M204 S8000
G3 X184.276 Y163.642 I2.332 J.488 E.10866
G1 X184.372 Y163.645 E.00319
G3 X181.907 Y165.595 I-.121 J2.38 E.38282
; COOLING_NODE: 0
M204 S10000
G1 X181.521 Y165.45 F60000
G1 F2731
M204 S8000
G3 X184.279 Y163.235 I2.73 J.575 E.1271
G1 X184.394 Y163.238 E.0038
G3 X181.51 Y165.509 I-.142 J2.786 E.44862
; COOLING_NODE: 0
M204 S10000
G1 X181.12 Y165.374 F60000
G1 F2731
M204 S8000
G1 X181.124 Y165.364 E.00037
G3 X184.283 Y162.828 I3.128 J.661 E.14554
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X184.416 Y162.832 E.00441
G3 X181.079 Y165.635 I-.164 J3.193 E.50729
G1 X181.11 Y165.433 E.00678
; COOLING_NODE: 0
M204 S250
G1 X180.733 Y165.31 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2520
M204 S5000
G1 X180.742 Y165.281 E.00093
G3 X184.287 Y162.435 I3.511 J.744 E.15125
G1 X184.437 Y162.44 E.00463
G3 X180.69 Y165.588 I-.184 J3.585 E.52752
G1 X180.724 Y165.369 E.0068
; WIPE_START
G1 F9547.055
M204 S8000
G1 X180.742 Y165.281 E-.03419
G1 X180.817 Y164.976 E-.11931
G1 X180.946 Y164.622 E-.14311
G1 X181.11 Y164.284 E-.14275
G1 X181.31 Y163.965 E-.14305
G1 X181.501 Y163.717 E-.11898
G1 X181.606 Y163.604 E-.05861
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X185.831 Y164.757 Z4 F60000
G1 Z3.6
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F2731
M204 S8000
G2 X184.44 Y164.002 I-1.613 J1.313 E.05385
G3 X183.517 Y164.675 I-1.5 J-1.089 E.03851
G1 X182.809 Y164.592 E.02365
G2 X182.644 Y167.259 I1.583 J1.437 E.09573
G1 X182.862 Y167.24 E.00727
G1 X183.517 Y166.899 E.0245
G3 X184.5 Y165.919 I4.225 J3.251 E.04619
G3 X186.138 Y166.204 I.548 J1.696 E.05738
G1 X186.253 Y166.328 E.00563
G3 X185.425 Y167.673 I-2.006 J-.308 E.05381
; COOLING_NODE: 2
; WIPE_START
G1 F8843.478
G1 X185.874 Y167.251 E-.23435
G1 X186.162 Y166.72 E-.2293
G1 X186.253 Y166.328 E-.15289
G1 X186.138 Y166.204 E-.06444
G1 X185.953 Y166.108 E-.07902
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X178.702 Y164.377 Z4 F60000
G1 Z3.6
G1 E.8 F1800
; FEATURE: Inner wall
G1 F2731
M204 S8000
G1 X179.498 Y164.377 E.0264
G1 X179.498 Y165.173 E.0264
G1 X178.702 Y165.173 E.0264
G1 X178.702 Y164.437 E.02441
; COOLING_NODE: 2
M204 S250
G1 X178.31 Y163.985 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2639
M204 S5000
G1 X179.89 Y163.985 E.04855
G1 X179.89 Y165.565 E.04855
G1 X178.31 Y165.565 E.04855
G1 X178.31 Y164.045 E.04671
; COOLING_NODE: 2
; WIPE_START
G1 F9547.055
M204 S8000
G1 X179.89 Y163.985 E-.60084
G1 X179.89 Y164.404 E-.15916
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.283 Y165.027 Z4 F60000
G1 X170.502 Y165.173 Z4
G1 Z3.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2731
M204 S8000
G1 X170.502 Y164.377 E.0264
G1 X171.298 Y164.377 E.0264
G1 X171.298 Y165.173 E.0264
G1 X170.562 Y165.173 E.02441
; COOLING_NODE: 2
M204 S250
G1 X170.11 Y165.565 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2639
M204 S5000
G1 X170.11 Y163.985 E.04855
G1 X171.69 Y163.985 E.04855
G1 X171.69 Y165.565 E.04855
G1 X170.17 Y165.565 E.04671
; COOLING_NODE: 0
; WIPE_START
G1 F9547.055
M204 S8000
G1 X170.11 Y163.985 E-.60084
G1 X170.529 Y163.985 E-.15917
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X167.976 Y165.171 Z4 F60000
G1 Z3.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2731
M204 S8000
G3 X165.776 Y163.642 I-2.225 J.854 E.40228
G1 X165.872 Y163.645 E.00319
G3 X167.953 Y165.115 I-.121 J2.38 E.0892
; COOLING_NODE: 0
M204 S10000
G1 X168.356 Y165.024 F60000
G1 F2731
M204 S8000
G3 X165.779 Y163.235 I-2.605 J1 E.47099
G1 X165.894 Y163.238 E.0038
G3 X168.334 Y164.969 I-.142 J2.786 E.10474
; COOLING_NODE: 0
M204 S10000
G1 X168.737 Y164.885 F60000
G1 F2731
M204 S8000
G1 X168.834 Y165.175 E.01014
G3 X165.783 Y162.828 I-3.082 J.85 E.52933
G1 X165.916 Y162.832 E.00441
G3 X168.717 Y164.829 I-.164 J3.193 E.12051
; COOLING_NODE: 0
M204 S250
G1 X169.109 Y164.763 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2520
M204 S5000
G1 X169.213 Y165.07 E.00997
G3 X165.787 Y162.435 I-3.46 J.954 E.55045
G1 X165.937 Y162.44 E.00463
G3 X169.091 Y164.706 I-.184 J3.585 E.12608
; WIPE_START
G1 F9547.055
M204 S8000
G1 X169.213 Y165.07 E-.14598
G1 X169.285 Y165.402 E-.129
G1 X169.329 Y165.749 E-.13285
G1 X169.339 Y166.088 E-.12916
G1 X169.32 Y166.4 E-.11864
G1 X169.277 Y166.671 E-.10438
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X164.713 Y164.276 Z4 F60000
G1 Z3.6
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F2731
M204 S8000
G3 X166.284 Y164.064 I1.078 J2.052 E.05367
G1 X166.483 Y164.279 E.00971
G1 X167.138 Y164.62 E.0245
G3 X167.284 Y164.69 I.029 J.126 E.00582
G3 X167.493 Y167.056 I-1.555 J1.329 E.08404
G1 X167.138 Y167.24 E.01326
G1 X166.483 Y167.295 E.02181
G3 X165.828 Y166.912 I.169 J-1.04 E.02575
G1 X165.173 Y166.204 E.03201
G2 X163.726 Y165.854 I-1.139 J1.541 E.0507
G2 X164.218 Y167.361 I2.03 J.172 E.05402
; CHANGE_LAYER
; Z_HEIGHT: 3.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F8843.478
G1 X163.986 Y167.038 E-.1514
G1 X163.817 Y166.659 E-.15735
G1 X163.731 Y166.271 E-.15121
G1 X163.726 Y165.854 E-.15836
G1 X163.862 Y165.808 E-.05459
G1 X164.091 Y165.827 E-.08707
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 23/85
; update layer progress
M73 L23
M991 S0 P22 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 1
M204 S10000
G17
G3 Z4 I1.209 J-.137 P1  F60000
G1 X162.702 Y153.573 Z4
G1 Z3.8
G1 E.8 F1800
; FEATURE: Inner wall
G1 F2936
M204 S8000
G1 X162.702 Y152.777 E.0264
G1 X166.934 Y152.777 E.14037
G1 X166.934 Y153.573 E.0264
G1 X162.762 Y153.573 E.13838
; COOLING_NODE: 1
; WIPE_START
G1 F8843.478
G1 X162.702 Y152.777 E-.30329
G1 X163.904 Y152.777 E-.45671
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z4.2 I-.051 J1.216 P1  F60000
G1 X183.066 Y153.573 Z4.2
G1 Z3.8
G1 E.8 F1800
G1 F2936
M204 S8000
G1 X183.066 Y152.777 E.0264
G1 X187.298 Y152.777 E.14037
G1 X187.298 Y153.573 E.0264
G1 X183.126 Y153.573 E.13838
; COOLING_NODE: 1
; WIPE_START
G1 F8843.478
M73 P57 R7
G1 X183.066 Y152.777 E-.30329
G1 X184.268 Y152.777 E-.45671
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z4.2 I-.066 J-1.215 P1  F60000
G1 X162.31 Y153.965 Z4.2
G1 Z3.8
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2489
M204 S5000
G1 X162.31 Y152.385 E.04855
G1 X187.69 Y152.385 E.77986
G1 X187.69 Y153.965 E.04855
G1 X162.37 Y153.965 E.77801
M204 S10000
G1 X162.906 Y153.175 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F2936
M204 S8000
G1 X166.73 Y153.175 E.12117
; WIPE_START
G1 F9259.259
G1 X164.73 Y153.175 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z4.2 I0 J1.217 P1  F60000
G1 X182.844 Y153.179 Z4.2
G1 Z3.8
G1 E.8 F1800
; FEATURE: Top surface
; LINE_WIDTH: 0.42
G1 F2936
M204 S2000
G1 X182.257 Y152.592 E.0255
G1 X182.123 Y152.459
G1 X181.59 Y152.459
G1 X181.724 Y152.592
G1 X182.844 Y153.713 E.04868
G1 X182.977 Y153.846
G1 X182.489 Y153.891
G1 X182.356 Y153.758
G1 X181.19 Y152.592 E.05063
G1 X181.057 Y152.459
G1 X180.524 Y152.459
G1 X180.657 Y152.592
G1 X181.822 Y153.758 E.05063
G1 X181.956 Y153.891
G1 X181.423 Y153.891
G1 X181.289 Y153.758
G1 X180.124 Y152.592 E.05063
G1 X179.99 Y152.459
G1 X179.457 Y152.459
G1 X179.591 Y152.592
G1 X180.756 Y153.758 E.05063
G1 X180.889 Y153.891
G1 X180.356 Y153.891
G1 X180.223 Y153.758
G1 X179.057 Y152.592 E.05063
G1 X178.924 Y152.459
G1 X178.39 Y152.459
G1 X178.524 Y152.592
G1 X179.689 Y153.758 E.05063
G1 X179.823 Y153.891
G1 X179.29 Y153.891
G1 X179.156 Y153.758
G1 X177.991 Y152.592 E.05063
G1 X177.857 Y152.459
G1 X177.324 Y152.459
G1 X177.458 Y152.592
G1 X178.623 Y153.758 E.05063
G1 X178.756 Y153.891
G1 X178.223 Y153.891
G1 X178.09 Y153.758
G1 X176.924 Y152.592 E.05063
G1 X176.791 Y152.459
G1 X176.257 Y152.459
G1 X176.391 Y152.592
G1 X177.556 Y153.758 E.05063
G1 X177.69 Y153.891
G1 X177.157 Y153.891
G1 X177.023 Y153.758
G1 X175.858 Y152.592 E.05063
G1 X175.724 Y152.459
G1 X175.191 Y152.459
G1 X175.325 Y152.592
G1 X176.49 Y153.758 E.05063
G1 X176.623 Y153.891
G1 X176.09 Y153.891
G1 X175.957 Y153.758
G1 X174.791 Y152.592 E.05064
G1 X174.658 Y152.459
G1 X174.124 Y152.459
G1 X174.258 Y152.592
G1 X175.423 Y153.758 E.05064
G1 X175.557 Y153.891
G1 X175.024 Y153.891
G1 X174.89 Y153.758
G1 X173.725 Y152.592 E.05063
G1 X173.591 Y152.459
G1 X173.058 Y152.459
G1 X173.192 Y152.592
G1 X174.357 Y153.758 E.05063
G1 X174.49 Y153.891
G1 X173.957 Y153.891
G1 X173.823 Y153.758
G1 X172.658 Y152.592 E.05063
G1 X172.525 Y152.459
G1 X171.991 Y152.459
G1 X172.125 Y152.592
G1 X173.29 Y153.758 E.05063
G1 X173.424 Y153.891
G1 X172.891 Y153.891
G1 X172.757 Y153.758
G1 X171.592 Y152.592 E.05063
G1 X171.458 Y152.459
G1 X170.925 Y152.459
G1 X171.058 Y152.592
G1 X172.224 Y153.758 E.05063
G1 X172.357 Y153.891
G1 X171.824 Y153.891
G1 X171.69 Y153.758
G1 X170.525 Y152.592 E.05063
G1 X170.392 Y152.459
G1 X169.858 Y152.459
G1 X169.992 Y152.592
G1 X171.157 Y153.758 E.05063
G1 X171.291 Y153.891
G1 X170.758 Y153.891
G1 X170.624 Y153.758
G1 X169.459 Y152.592 E.05063
G1 X169.325 Y152.459
G1 X168.792 Y152.459
G1 X168.925 Y152.592
G1 X170.091 Y153.758 E.05063
G1 X170.224 Y153.891
G1 X169.691 Y153.891
G1 X169.557 Y153.758
G1 X168.392 Y152.592 E.05063
G1 X168.259 Y152.459
G1 X167.725 Y152.459
G1 X167.859 Y152.592
G1 X169.024 Y153.758 E.05063
G1 X169.158 Y153.891
G1 X168.625 Y153.891
G1 X168.491 Y153.758
G1 X167.326 Y152.592 E.05063
G1 X167.192 Y152.459
G1 X167.023 Y152.823
G1 X167.156 Y152.956
G1 X167.958 Y153.758 E.03483
; WIPE_START
G1 F9547.055
M204 S8000
G1 X167.156 Y152.956 E-.43068
G1 X167.023 Y152.823 E-.07182
G1 X167.192 Y152.459 E-.15251
G1 X167.326 Y152.592 E-.07182
G1 X167.387 Y152.654 E-.03317
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z4.2 I-.04 J1.216 P1  F60000
G1 X183.27 Y153.175 Z4.2
G1 Z3.8
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F2936
M204 S8000
G1 X187.094 Y153.175 E.12117
; COOLING_NODE: 0
; WIPE_START
G1 F9259.259
G1 X185.094 Y153.175 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X183.195 Y160.567 Z4.2 F60000
G1 X181.921 Y165.53 Z4.2
G1 Z3.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2936
M204 S8000
G3 X184.283 Y163.642 I2.331 J.495 E.10868
G1 X184.37 Y163.645 E.0029
G3 X181.909 Y165.589 I-.119 J2.38 E.3831
; COOLING_NODE: 0
M204 S10000
G1 X181.517 Y165.465 F60000
G1 F2936
M204 S8000
G1 X181.523 Y165.446 E.00068
G3 X184.288 Y163.235 I2.729 J.579 E.12722
G1 X184.393 Y163.238 E.00349
G3 X181.483 Y165.681 I-.141 J2.787 E.4429
G1 X181.508 Y165.525 E.00525
; COOLING_NODE: 0
M204 S10000
G1 X181.116 Y165.398 F60000
G1 F2936
M204 S8000
G1 X181.125 Y165.361 E.00124
G3 X184.292 Y162.828 I3.128 J.663 E.14574
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X184.415 Y162.832 E.0041
G3 X181.079 Y165.633 I-.163 J3.193 E.50739
G1 X181.107 Y165.457 E.00592
; COOLING_NODE: 0
M204 S250
G1 X180.729 Y165.333 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2447
M204 S5000
G1 X180.742 Y165.28 E.00167
G3 X184.296 Y162.435 I3.511 J.745 E.15152
G1 X184.437 Y162.44 E.00433
G3 X180.69 Y165.587 I-.184 J3.585 E.52753
G1 X180.72 Y165.392 E.00607
; WIPE_START
G1 F9547.055
M204 S8000
G1 X180.742 Y165.28 E-.04343
G1 X180.836 Y164.915 E-.14301
G1 X180.964 Y164.58 E-.13634
G1 X181.11 Y164.284 E-.12551
G1 X181.309 Y163.966 E-.14255
G1 X181.542 Y163.669 E-.14342
G1 X181.588 Y163.62 E-.02574
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X185.707 Y164.608 Z4.2 F60000
G1 Z3.8
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F2936
M204 S8000
G2 X184.246 Y163.999 I-1.475 J1.48 E.05384
G3 X183.517 Y164.525 I-2.831 J-3.152 E.02989
G1 X182.862 Y164.591 E.02184
G2 X182.391 Y166.852 I1.296 J1.449 E.08203
G2 X182.862 Y167.212 I.428 J-.072 E.02163
G1 X183.517 Y166.994 E.02291
G3 X184.827 Y165.957 I5.51 J5.619 E.05553
G3 X186.138 Y166.109 I.486 J1.536 E.04508
G1 X186.268 Y166.224 E.00577
G3 X185.51 Y167.613 I-2.232 J-.317 E.05363
; COOLING_NODE: 2
; WIPE_START
G1 F8843.478
G1 X185.873 Y167.251 E-.19474
G1 X186.079 Y166.914 E-.15021
G1 X186.268 Y166.224 E-.27174
G1 X186.138 Y166.109 E-.06608
G1 X185.945 Y166.045 E-.07723
; WIPE_END
G1 E-.04 F1800
M204 S10000
M73 P57 R6
G1 X178.702 Y164.377 Z4.2 F60000
G1 Z3.8
G1 E.8 F1800
; FEATURE: Inner wall
G1 F2936
M204 S8000
G1 X179.498 Y164.377 E.0264
G1 X179.498 Y165.173 E.0264
G1 X178.702 Y165.173 E.0264
G1 X178.702 Y164.437 E.02441
; COOLING_NODE: 2
M204 S250
G1 X178.31 Y163.985 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2564
M204 S5000
G1 X179.89 Y163.985 E.04855
G1 X179.89 Y165.565 E.04855
G1 X178.31 Y165.565 E.04855
G1 X178.31 Y164.045 E.04671
; COOLING_NODE: 2
; WIPE_START
G1 F9547.055
M204 S8000
G1 X179.89 Y163.985 E-.60084
G1 X179.89 Y164.404 E-.15916
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.283 Y165.027 Z4.2 F60000
G1 X170.502 Y165.173 Z4.2
G1 Z3.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2936
M204 S8000
G1 X170.502 Y164.377 E.0264
G1 X171.298 Y164.377 E.0264
G1 X171.298 Y165.173 E.0264
G1 X170.562 Y165.173 E.02441
; COOLING_NODE: 2
M204 S250
G1 X170.11 Y165.565 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2564
M204 S5000
G1 X170.11 Y163.985 E.04855
G1 X171.69 Y163.985 E.04855
G1 X171.69 Y165.565 E.04855
G1 X170.17 Y165.565 E.04671
; COOLING_NODE: 0
; WIPE_START
G1 F9547.055
M204 S8000
G1 X170.11 Y163.985 E-.60084
G1 X170.529 Y163.985 E-.15917
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X167.976 Y165.17 Z4.2 F60000
G1 Z3.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2936
M204 S8000
G3 X165.783 Y163.642 I-2.224 J.855 E.40253
G1 X165.87 Y163.645 E.0029
G3 X167.954 Y165.114 I-.119 J2.38 E.08925
; COOLING_NODE: 0
M204 S10000
G1 X168.356 Y165.024 F60000
G1 F2936
M204 S8000
G3 X165.788 Y163.235 I-2.604 J1.001 E.47127
G1 X165.893 Y163.238 E.00349
G3 X168.334 Y164.968 I-.141 J2.787 E.10478
; COOLING_NODE: 0
M204 S10000
G1 X168.736 Y164.88 F60000
G1 F2936
M204 S8000
G1 X168.841 Y165.199 E.01113
G3 X165.792 Y162.828 I-3.089 J.826 E.52879
G1 X165.915 Y162.832 E.0041
G3 X168.716 Y164.825 I-.163 J3.193 E.12038
; COOLING_NODE: 0
M204 S250
G1 X169.108 Y164.759 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2447
M204 S5000
G1 X169.22 Y165.096 E.01089
G3 X165.796 Y162.435 I-3.467 J.929 E.54992
G1 X165.937 Y162.44 E.00433
G3 X169.09 Y164.703 I-.184 J3.585 E.12598
; WIPE_START
G1 F9547.055
M204 S8000
G1 X169.22 Y165.096 E-.15742
G1 X169.285 Y165.402 E-.11889
G1 X169.33 Y165.758 E-.13649
G1 X169.339 Y166.088 E-.12544
G1 X169.315 Y166.446 E-.1363
G1 X169.279 Y166.668 E-.08547
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X164.54 Y164.401 Z4.2 F60000
G1 Z3.8
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F2936
M204 S8000
M73 P58 R6
G3 X166.077 Y164.017 I1.366 J2.202 E.0534
G2 X167.186 Y164.587 I1.182 J-.938 E.0426
G3 X167.478 Y167.099 I-1.478 J1.445 E.09028
G1 X167.138 Y167.212 E.01187
G1 X166.483 Y167.146 E.02184
G3 X165.173 Y166.109 I4.201 J-6.657 E.05553
G2 X163.862 Y165.957 I-.825 J1.384 E.04508
G2 X163.731 Y166.272 I.039 J.201 E.01335
G2 X164.356 Y167.506 I2.05 J-.262 E.04679
; CHANGE_LAYER
; Z_HEIGHT: 4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F8843.478
G1 X163.891 Y166.853 E-.30464
G1 X163.731 Y166.272 E-.22893
G1 X163.726 Y166.054 E-.08293
G1 X163.862 Y165.957 E-.0635
G1 X164.072 Y165.936 E-.08001
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 24/85
; update layer progress
M73 L24
M991 S0 P23 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 1
M204 S10000
G17
G3 Z4.2 I1.163 J.36 P1  F60000
G1 X167.898 Y153.573 Z4.2
G1 Z4
G1 E.8 F1800
; FEATURE: Inner wall
G1 F2292
M204 S8000
G1 X162.702 Y153.573 E.17236
G1 X162.702 Y152.777 E.0264
G1 X167.898 Y152.777 E.17236
G1 X167.898 Y153.513 E.02441
; COOLING_NODE: 1
M204 S250
G1 X168.29 Y153.965 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2292
M204 S5000
G1 X162.31 Y153.965 E.18375
G1 X162.31 Y152.385 E.04855
G1 X168.29 Y152.385 E.18375
G1 X168.29 Y153.905 E.04671
M204 S10000
G1 X167.694 Y153.175 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F2292
M204 S8000
G1 X162.906 Y153.175 E.15172
; COOLING_NODE: 0
; WIPE_START
G1 F9259.259
G1 X164.906 Y153.175 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X166.786 Y160.572 Z4.4 F60000
G1 X168.111 Y165.786 Z4.4
G1 Z4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2292
M204 S8000
G1 X168.134 Y166.067 E.00933
G3 X165.792 Y163.642 I-2.383 J-.042 E.37244
G1 X165.869 Y163.645 E.00258
G3 X168.099 Y165.617 I-.118 J2.38 E.10667
G1 X168.107 Y165.727 E.00363
; COOLING_NODE: 0
M204 S10000
G1 X168.531 Y165.782 F60000
G1 F2292
M204 S8000
G3 X165.797 Y163.235 I-2.779 J.243 E.44571
G1 X165.892 Y163.238 E.00317
G3 X168.525 Y165.722 I-.141 J2.787 E.13065
; COOLING_NODE: 0
M204 S10000
G1 X168.936 Y165.746 F60000
G1 F2292
M204 S8000
G3 X165.801 Y162.828 I-3.185 J.278 E.51068
G1 X165.915 Y162.831 E.00377
G3 X168.931 Y165.687 I-.164 J3.193 E.14993
; COOLING_NODE: 0
M204 S250
G1 X169.327 Y165.712 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2292
M204 S5000
G3 X165.806 Y162.436 I-3.576 J.313 E.531
G1 X165.937 Y162.44 E.00404
G3 X169.322 Y165.652 I-.185 J3.585 E.15609
; WIPE_START
G1 F9547.055
M204 S8000
G1 X169.339 Y166.088 E-.16576
G1 X169.314 Y166.455 E-.1399
G1 X169.261 Y166.772 E-.12185
G1 X169.166 Y167.128 E-.14003
G1 X169.054 Y167.428 E-.12185
G1 X168.973 Y167.595 E-.07062
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X164.345 Y164.565 Z4.4 F60000
G1 Z4
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F2292
M204 S8000
G3 X165.828 Y164 I1.57 J1.892 E.05362
G1 X166.483 Y164.486 E.02705
G1 X167.167 Y164.58 E.0229
G3 X167.434 Y167.162 I-1.438 J1.454 E.09331
G1 X167.138 Y167.208 E.00994
G1 X166.483 Y167.026 E.02255
G2 X165.173 Y165.997 I-9.936 J11.298 E.05531
G2 X163.725 Y166.191 I-.51 J1.69 E.04996
G2 X164.46 Y167.595 I2.026 J-.166 E.054
; COOLING_NODE: 2
; WIPE_START
G1 F8843.478
G1 X163.985 Y167.036 E-.27891
G1 X163.817 Y166.659 E-.15681
G1 X163.725 Y166.191 E-.18109
G1 X163.862 Y166.077 E-.06792
G1 X164.053 Y166.024 E-.07527
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.643 Y165.215 Z4.4 F60000
G1 X179.498 Y164.377 Z4.4
G1 Z4
G1 E.8 F1800
; FEATURE: Inner wall
G1 F2292
M204 S8000
G1 X179.498 Y164.773 E.01313
G1 X179.498 Y165.173 E.01327
G1 X179.083 Y165.173 E.01378
G1 X178.683 Y165.173 E.01327
G1 X178.283 Y165.173 E.01327
G1 F1800
G1 X177.9 Y165.173 E.01269
; FEATURE: Overhang wall
G1 F3000
M204 S5000
G1 X172.1 Y165.173 E.1924
; FEATURE: Inner wall
G1 F1800
M204 S8000
G1 X171.718 Y165.173 E.01269
G1 F2292
G1 X171.318 Y165.173 E.01327
G1 X170.918 Y165.173 E.01327
G1 X170.502 Y165.173 E.01378
G1 X170.502 Y164.773 E.01327
G1 X170.502 Y164.377 E.01313
G1 X170.918 Y164.377 E.01378
G1 X171.318 Y164.377 E.01327
G1 X171.718 Y164.377 E.01327
G1 F1800
G1 X172.1 Y164.377 E.01269
; FEATURE: Overhang wall
G1 F3000
M204 S5000
G1 X177.9 Y164.377 E.1924
; FEATURE: Inner wall
G1 F1800
M204 S8000
G1 X178.283 Y164.377 E.01269
G1 F2292
G1 X178.683 Y164.377 E.01327
G1 X179.083 Y164.377 E.01327
G1 X179.438 Y164.377 E.01179
; COOLING_NODE: 2
M204 S250
G1 X179.89 Y163.985 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2292
M204 S5000
G1 X179.89 Y164.365 E.01168
G1 X179.89 Y164.765 E.01229
G1 X179.89 Y165.165 E.01229
G1 X179.89 Y165.565 E.01229
G1 X179.469 Y165.565 E.01294
G1 X179.069 Y165.565 E.01229
G1 X178.669 Y165.565 E.01229
G1 X178.269 Y165.565 E.01229
G1 F1800
G1 X177.9 Y165.565 E.01134
; FEATURE: Overhang wall
; LINE_WIDTH: 0.45
G1 F3000
G1 X172.1 Y165.565 E.1924
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1800
G1 X171.731 Y165.565 E.01134
G1 F2292
G1 X171.331 Y165.565 E.01229
G1 X170.931 Y165.565 E.01229
G1 X170.531 Y165.565 E.01229
G1 X170.11 Y165.565 E.01294
G1 X170.11 Y165.165 E.01229
G1 X170.11 Y164.765 E.01229
G1 X170.11 Y164.385 E.01168
G1 X170.11 Y163.985 E.01229
G1 X170.531 Y163.985 E.01294
G1 X170.931 Y163.985 E.01229
G1 X171.331 Y163.985 E.01229
G1 X171.731 Y163.985 E.01229
G1 F1800
G1 X172.1 Y163.985 E.01134
; FEATURE: Overhang wall
; LINE_WIDTH: 0.45
G1 F3000
G1 X177.9 Y163.985 E.1924
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1800
G1 X178.269 Y163.985 E.01134
G1 F2292
G1 X178.669 Y163.985 E.01229
G1 X179.069 Y163.985 E.01229
G1 X179.469 Y163.985 E.01229
G1 X179.83 Y163.985 E.01109
M204 S10000
G1 X179.294 Y164.775 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F2292
M204 S8000
G1 X170.706 Y164.775 E.27211
; COOLING_NODE: 0
; WIPE_START
G1 F9259.259
G1 X172.706 Y164.775 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z4.4 I-.1 J1.213 P1  F60000
G1 X181.919 Y165.534 Z4.4
G1 Z4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2292
M204 S8000
G3 X184.292 Y163.642 I2.332 J.49 E.10914
G1 X184.369 Y163.645 E.00258
G3 X181.908 Y165.593 I-.118 J2.38 E.38296
; COOLING_NODE: 0
M204 S10000
G1 X181.513 Y165.487 F60000
G1 F2292
M204 S8000
G1 X181.521 Y165.448 E.00131
G3 X184.297 Y163.235 I2.73 J.576 E.12764
G1 X184.392 Y163.238 E.00317
G3 X181.482 Y165.684 I-.141 J2.787 E.44277
G1 X181.504 Y165.546 E.00464
; COOLING_NODE: 0
M204 S10000
G1 X181.112 Y165.42 F60000
G1 F2292
M204 S8000
G1 X181.123 Y165.362 E.00197
G3 X184.301 Y162.828 I3.128 J.662 E.14612
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X184.415 Y162.831 E.00377
G3 X181.078 Y165.635 I-.164 J3.193 E.5073
G1 X181.103 Y165.48 E.00522
; COOLING_NODE: 0
M204 S250
G1 X180.726 Y165.356 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2292
M204 S5000
G1 X180.741 Y165.279 E.0024
G3 X184.306 Y162.436 I3.511 J.745 E.15184
G1 X184.437 Y162.44 E.00404
G3 X180.689 Y165.587 I-.185 J3.585 E.5275
G1 X180.716 Y165.415 E.00536
; WIPE_START
G1 F9547.055
M204 S8000
G1 X180.741 Y165.279 E-.05243
G1 X180.836 Y164.915 E-.14298
G1 X180.968 Y164.571 E-.14
G1 X181.11 Y164.285 E-.12164
G1 X181.31 Y163.965 E-.14316
G1 X181.5 Y163.717 E-.11897
G1 X181.574 Y163.638 E-.04083
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X185.519 Y164.438 Z4.4 F60000
G1 Z4
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F2292
M204 S8000
G2 X183.994 Y164.01 I-1.296 J1.687 E.05386
G3 X182.862 Y164.588 I-1.208 J-.97 E.04343
G2 X182.545 Y167.12 I1.33 J1.453 E.09211
G1 X182.862 Y167.208 E.01091
G1 X183.517 Y167.106 E.02199
G1 X184.172 Y166.621 E.02705
G3 X186.138 Y165.997 I1.454 J1.172 E.07247
G1 X186.281 Y166.103 E.00591
G3 X185.607 Y167.539 I-2.575 J-.332 E.05347
; COOLING_NODE: 1
; WIPE_START
G1 F8843.478
G1 X186.078 Y166.917 E-.29646
G1 X186.214 Y166.551 E-.14817
G1 X186.281 Y166.103 E-.17226
G1 X186.138 Y165.997 E-.06769
G1 X185.942 Y165.966 E-.07543
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X183.683 Y158.676 Z4.4 F60000
G1 X182.102 Y153.573 Z4.4
G1 Z4
G1 E.8 F1800
; FEATURE: Inner wall
G1 F2292
M204 S8000
G1 X182.102 Y152.777 E.0264
G1 X187.298 Y152.777 E.17236
G1 X187.298 Y153.573 E.0264
G1 X182.162 Y153.573 E.17037
; COOLING_NODE: 1
M204 S250
G1 X181.71 Y153.965 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2292
M204 S5000
G1 X181.71 Y152.385 E.04855
G1 X187.69 Y152.385 E.18375
G1 X187.69 Y153.965 E.04855
G1 X181.77 Y153.965 E.18191
M204 S10000
G1 X182.306 Y153.175 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F2292
M204 S8000
G1 X187.094 Y153.175 E.15172
; CHANGE_LAYER
; Z_HEIGHT: 4.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.259
G1 X185.094 Y153.175 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 25/85
; update layer progress
M73 L25
M991 S0 P24 ;notify layer change

; OBJECT_ID: 15
M204 S10000
G17
G3 Z4.4 I.208 J-1.199 P1  F60000
G1 X181.131 Y152.487 Z4.4
G1 Z4.2
G1 E.8 F1800
; FEATURE: Support interface
; LINE_WIDTH: 0.42
G1 F2724
M204 S8000
G1 X180.587 Y151.943 E.02363
G1 X179.347 Y151.943 E.03811
G1 X180.962 Y153.558 E.07016
G1 X180.97 Y154.407 E.02608
G1 X180.57 Y154.407 E.0123
G1 X178.107 Y151.943 E.10703
G1 X176.866 Y151.943 E.03811
M73 P59 R6
G1 X179.329 Y154.407 E.10703
G1 X178.089 Y154.407 E.03811
G1 X175.626 Y151.943 E.10703
G1 X174.386 Y151.943 E.03811
G1 X176.849 Y154.407 E.10703
G1 X175.608 Y154.407 E.03811
G1 X173.145 Y151.943 E.10703
G1 X171.905 Y151.943 E.03811
G1 X174.368 Y154.407 E.10703
G1 X173.128 Y154.407 E.03811
G1 X170.665 Y151.943 E.10703
G1 X169.424 Y151.943 E.03811
G1 X171.887 Y154.407 E.10703
G1 X170.647 Y154.407 E.03811
G1 X169.038 Y152.798 E.0699
G1 X169.038 Y154.038 E.03811
G1 X169.576 Y154.576 E.02337
; COOLING_NODE: 1
; WIPE_START
G1 F4800
G1 X169.038 Y154.038 E-.28902
G1 X169.038 Y152.799 E-.47098
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z4.6 I-.683 J-1.007 P1  F60000
G1 X167.898 Y153.573 Z4.6
G1 Z4.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2724
M204 S8000
G1 X162.702 Y153.573 E.17236
G1 X162.702 Y152.777 E.0264
G1 X167.898 Y152.777 E.17236
G1 X167.898 Y153.513 E.02441
; COOLING_NODE: 1
M204 S250
G1 X168.29 Y153.965 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2395
M204 S5000
G1 X162.31 Y153.965 E.18375
G1 X162.31 Y152.385 E.04855
G1 X168.29 Y152.385 E.18375
G1 X168.29 Y153.905 E.04671
M204 S10000
G1 X167.694 Y153.175 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F2724
M204 S8000
G1 X162.906 Y153.175 E.15172
; COOLING_NODE: 0
; WIPE_START
G1 F9259.259
G1 X164.906 Y153.175 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X166.794 Y160.57 Z4.6 F60000
G1 X168.112 Y165.731 Z4.6
G1 Z4.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2724
M204 S8000
G1 X168.126 Y166.155 E.01407
G3 X165.745 Y163.642 I-2.379 J-.131 E.3681
G1 X165.874 Y163.645 E.0043
G3 X168.103 Y165.672 I-.128 J2.38 E.10819
; COOLING_NODE: 0
M204 S10000
G1 X168.527 Y165.781 F60000
G1 F2724
M204 S8000
G1 X168.534 Y165.879 E.00325
G3 X165.747 Y163.234 I-2.786 J.145 E.44094
G1 X165.896 Y163.238 E.00494
G3 X168.511 Y165.641 I-.148 J2.786 E.1277
G1 X168.521 Y165.722 E.0027
; COOLING_NODE: 0
M204 S10000
G1 X168.932 Y165.743 F60000
G1 F2724
M204 S8000
G1 X168.942 Y165.858 E.00381
G3 X165.749 Y162.827 I-3.193 J.167 E.50532
G1 X165.917 Y162.832 E.00558
G3 X168.915 Y165.582 I-.168 J3.193 E.1463
G1 X168.926 Y165.684 E.00338
; COOLING_NODE: 0
M204 S250
G1 X169.322 Y165.706 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2335
M204 S5000
G1 X169.33 Y165.837 E.00404
G3 X166.249 Y169.58 I-3.586 J.188 E.16352
G3 X165.938 Y162.44 I-.495 J-3.555 E.36738
G3 X169.3 Y165.526 I-.193 J3.585 E.15199
G1 X169.315 Y165.647 E.00372
; WIPE_START
G1 F9547.055
M204 S8000
G1 X169.33 Y165.837 E-.0727
G1 X169.335 Y166.213 E-.1429
G1 X169.305 Y166.524 E-.11857
G1 X169.183 Y167.074 E-.21409
G1 X169.078 Y167.37 E-.11943
G1 X168.976 Y167.591 E-.0923
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X164.551 Y167.664 Z4.6 F60000
G1 Z4.2
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F2724
M204 S8000
G3 X163.74 Y166.336 I1.298 J-1.705 E.05284
G3 X165.173 Y165.858 I1.143 J1.041 E.05235
G1 X165.5 Y165.99 E.01171
G3 X166.483 Y166.927 I-4.991 J6.216 E.04511
G1 X167.138 Y167.229 E.02393
G1 X167.385 Y167.235 E.00818
G2 X167.185 Y164.587 I-1.797 J-1.196 E.09489
G1 X166.483 Y164.624 E.02332
G3 X165.619 Y164.005 I.78 J-2.001 E.03565
G2 X164.202 Y164.708 I.105 J1.99 E.05398
; COOLING_NODE: 2
; WIPE_START
G1 F8843.478
G1 X164.383 Y164.518 E-.09988
G1 X164.89 Y164.181 E-.23148
G1 X165.619 Y164.005 E-.28483
G1 X165.899 Y164.259 E-.14382
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X173.531 Y164.325 Z4.6 F60000
G1 X179.498 Y164.377 Z4.6
G1 Z4.2
G1 E.8 F1800
; FEATURE: Inner wall
G1 F2724
M204 S8000
G1 X179.498 Y165.173 E.0264
G1 X170.502 Y165.173 E.29841
G1 X170.502 Y164.377 E.0264
G1 X179.438 Y164.377 E.29642
; COOLING_NODE: 2
M204 S250
G1 X179.89 Y163.985 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2459
M204 S5000
G1 X179.89 Y165.565 E.04855
G1 X170.11 Y165.565 E.30051
G1 X170.11 Y163.985 E.04855
G1 X179.83 Y163.985 E.29867
M204 S10000
G1 X179.294 Y164.775 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F2724
M204 S8000
G1 X170.706 Y164.775 E.27211
; COOLING_NODE: 0
; WIPE_START
G1 F9259.259
G1 X172.706 Y164.775 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z4.6 I-.106 J1.212 P1  F60000
G1 X181.906 Y165.576 Z4.6
G1 Z4.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2724
M204 S8000
G3 X184.245 Y163.642 I2.34 J.449 E.10913
G1 X184.374 Y163.645 E.0043
G3 X181.896 Y165.635 I-.128 J2.38 E.38124
; COOLING_NODE: 0
M204 S10000
G1 X181.508 Y165.497 F60000
G1 F2724
M204 S8000
G3 X184.247 Y163.234 I2.74 J.528 E.12774
G1 X184.396 Y163.238 E.00494
G3 X181.497 Y165.556 I-.148 J2.786 E.44685
; COOLING_NODE: 0
M204 S10000
G1 X181.108 Y165.437 F60000
G1 F2724
M204 S8000
G1 X181.11 Y165.417 E.00066
G3 X184.249 Y162.827 I3.139 J.607 E.14633
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X184.417 Y162.832 E.00558
G3 X181.069 Y165.691 I-.168 J3.193 E.50528
G1 X181.099 Y165.496 E.00653
; COOLING_NODE: 0
M204 S250
G1 X180.72 Y165.379 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2335
M204 S5000
G1 X180.726 Y165.341 E.00119
G3 X184.251 Y162.435 I3.524 J.683 E.15214
G1 X184.438 Y162.44 E.00575
G3 X180.68 Y165.65 I-.188 J3.584 E.52547
G1 X180.711 Y165.439 E.00657
; WIPE_START
G1 F9547.055
M204 S8000
G1 X180.726 Y165.341 E-.03756
G1 X180.817 Y164.976 E-.14304
G1 X180.922 Y164.68 E-.11934
G1 X181.08 Y164.34 E-.14264
G1 X181.274 Y164.018 E-.1426
G1 X181.461 Y163.765 E-.11956
G1 X181.558 Y163.657 E-.05526
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X185.323 Y164.305 Z4.6 F60000
G1 Z4.2
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F2724
M204 S8000
G2 X184.356 Y163.994 I-1.149 J1.914 E.03396
G2 X183.517 Y164.306 I-.18 J.8 E.03142
G1 X182.862 Y164.608 E.02393
G2 X182.501 Y167.063 I1.284 J1.442 E.08936
G1 X182.862 Y167.229 E.01318
G1 X183.517 Y167.245 E.02174
G1 X183.845 Y167.114 E.01171
G2 X184.827 Y166.176 I-4.993 J-6.217 E.04511
G3 X186.138 Y165.858 I1.024 J1.361 E.04599
G1 X186.272 Y165.912 E.00478
G3 X185.737 Y167.398 I-2.03 J.109 E.05382
; COOLING_NODE: 1
; WIPE_START
G1 F8843.478
G1 X186.162 Y166.721 E-.30402
G1 X186.272 Y165.912 E-.31013
G1 X186.138 Y165.858 E-.0548
G1 X185.898 Y165.864 E-.09105
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X183.646 Y158.572 Z4.6 F60000
G1 X182.102 Y153.573 Z4.6
G1 Z4.2
G1 E.8 F1800
; FEATURE: Inner wall
G1 F2724
M204 S8000
G1 X182.102 Y152.777 E.0264
G1 X187.298 Y152.777 E.17236
G1 X187.298 Y153.573 E.0264
G1 X182.162 Y153.573 E.17037
; COOLING_NODE: 1
M204 S250
G1 X181.71 Y153.965 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2395
M204 S5000
G1 X181.71 Y152.385 E.04855
G1 X187.69 Y152.385 E.18375
G1 X187.69 Y153.965 E.04855
G1 X181.77 Y153.965 E.18191
M204 S10000
G1 X182.306 Y153.175 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F2724
M204 S8000
G1 X187.094 Y153.175 E.15172
; CHANGE_LAYER
; Z_HEIGHT: 4.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.259
G1 X185.094 Y153.175 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 26/85
; update layer progress
M73 L26
M991 S0 P25 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 1
M204 S10000
G17
G3 Z4.6 I-.028 J-1.217 P1  F60000
G1 X167.898 Y153.573 Z4.6
G1 Z4.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2331
M204 S8000
G1 X162.702 Y153.573 E.17236
G1 X162.702 Y152.777 E.0264
G1 X167.898 Y152.777 E.17236
G1 X167.898 Y153.513 E.02441
; COOLING_NODE: 1
M204 S250
G1 X168.29 Y153.965 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2331
M204 S5000
M73 P60 R6
G1 X162.31 Y153.965 E.18375
G1 X162.31 Y152.385 E.04855
G1 X168.29 Y152.385 E.18375
G1 X168.29 Y153.905 E.04671
M204 S10000
G1 X167.694 Y153.175 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F2331
M204 S8000
G1 X162.906 Y153.175 E.15172
; COOLING_NODE: 0
; WIPE_START
G1 F9259.259
G1 X164.906 Y153.175 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X166.794 Y160.57 Z4.8 F60000
G1 X168.112 Y165.736 Z4.8
G1 Z4.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2331
M204 S8000
G1 X168.128 Y166.154 E.01387
G3 X165.753 Y163.642 I-2.379 J-.129 E.36837
G1 X165.874 Y163.645 E.00399
G3 X168.106 Y165.676 I-.125 J2.38 E.10842
; COOLING_NODE: 0
M204 S10000
G1 X168.528 Y165.785 F60000
G1 F2331
M204 S8000
G1 X168.536 Y165.879 E.00313
G3 X165.756 Y163.234 I-2.786 J.146 E.44117
G1 X165.895 Y163.238 E.00463
G3 X168.513 Y165.64 I-.146 J2.786 E.12774
G1 X168.522 Y165.725 E.00285
; COOLING_NODE: 0
M204 S10000
G1 X168.933 Y165.746 F60000
G1 F2331
M204 S8000
G1 X168.943 Y165.858 E.00372
G3 X165.758 Y162.827 I-3.193 J.167 E.50555
G1 X165.917 Y162.832 E.00528
G3 X168.917 Y165.582 I-.166 J3.193 E.14633
G1 X168.927 Y165.687 E.0035
; COOLING_NODE: 0
M204 S250
G1 X169.323 Y165.709 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2294
M204 S5000
G1 X169.336 Y165.837 E.00397
G3 X165.76 Y162.435 I-3.584 J.187 E.52574
G1 X165.938 Y162.44 E.00545
G3 X169.306 Y165.526 I-.186 J3.584 E.15214
G1 X169.317 Y165.649 E.00382
; WIPE_START
G1 F9547.055
M204 S8000
G1 X169.336 Y165.837 E-.07185
G1 X169.335 Y166.213 E-.14271
G1 X169.305 Y166.525 E-.11897
G1 X169.233 Y166.893 E-.14261
G1 X169.141 Y167.203 E-.12299
G1 X169.003 Y167.543 E-.1392
G1 X168.977 Y167.593 E-.02167
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X164.634 Y167.717 Z4.8 F60000
G1 Z4.4
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F2331
M204 S8000
G3 X163.756 Y166.401 I1.13 J-1.703 E.05387
G3 X165.173 Y165.68 I1.752 J1.69 E.0537
G3 X165.828 Y165.983 I.051 J.75 E.02498
G1 X166.483 Y166.841 E.03582
G1 X167.138 Y167.276 E.02608
G1 X167.319 Y167.317 E.00613
G2 X167.208 Y164.609 I-1.569 J-1.292 E.09838
G1 X166.483 Y164.803 E.02488
G3 X165.457 Y164.014 I.198 J-1.319 E.04483
G2 X164.101 Y164.836 I.3 J2.024 E.05401
; COOLING_NODE: 2
; WIPE_START
G1 F8843.478
G1 X164.388 Y164.513 E-.16414
G1 X164.726 Y164.267 E-.15888
G1 X165.457 Y164.014 E-.29385
G1 X165.686 Y164.313 E-.14314
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X173.318 Y164.348 Z4.8 F60000
G1 X179.498 Y164.377 Z4.8
G1 Z4.4
G1 E.8 F1800
; FEATURE: Inner wall
G1 F2331
M204 S8000
G1 X179.498 Y165.173 E.0264
G1 X170.502 Y165.173 E.29841
G1 X170.502 Y164.377 E.0264
G1 X179.438 Y164.377 E.29642
; COOLING_NODE: 2
M204 S250
G1 X179.89 Y163.985 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2331
M204 S5000
G1 X179.89 Y165.565 E.04855
G1 X170.11 Y165.565 E.30051
G1 X170.11 Y163.985 E.04855
G1 X179.83 Y163.985 E.29867
M204 S10000
G1 X179.294 Y164.775 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F2331
M204 S8000
G1 X170.706 Y164.775 E.27211
; COOLING_NODE: 0
; WIPE_START
G1 F9259.259
G1 X172.706 Y164.775 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z4.8 I-.106 J1.212 P1  F60000
G1 X181.917 Y165.583 Z4.8
G1 Z4.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2331
M204 S8000
G1 X181.936 Y165.448 E.0045
G3 X184.253 Y163.642 I2.312 J.576 E.10503
G1 X184.374 Y163.645 E.00399
G3 X181.869 Y165.901 I-.125 J2.38 E.37245
G1 X181.908 Y165.642 E.00869
; COOLING_NODE: 0
M204 S10000
G1 X181.499 Y165.563 F60000
G1 F2331
M204 S8000
G1 X181.542 Y165.35 E.00723
G3 X184.256 Y163.234 I2.707 J.675 E.12297
G1 X184.395 Y163.238 E.00463
G3 X181.489 Y165.622 I-.146 J2.786 E.44469
; COOLING_NODE: 0
M204 S10000
G1 X181.1 Y165.482 F60000
G1 F2331
M204 S8000
G1 X181.148 Y165.251 E.00781
G3 X184.258 Y162.827 I3.102 J.773 E.14093
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X184.417 Y162.832 E.00528
G3 X181.09 Y165.541 I-.166 J3.193 E.51036
; COOLING_NODE: 0
M204 S250
G1 X180.716 Y165.404 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2294
M204 S5000
G1 X180.769 Y165.157 E.00775
G3 X184.26 Y162.435 I3.483 J.868 E.14658
G1 X184.438 Y162.44 E.00545
G3 X180.706 Y165.464 I-.186 J3.584 E.53131
G1 X180.706 Y165.463 E.00003
; WIPE_START
G1 F9547.055
M204 S8000
G1 X180.769 Y165.157 E-.11867
G1 X180.877 Y164.797 E-.14281
G1 X181.023 Y164.451 E-.14261
G1 X181.178 Y164.167 E-.12291
G1 X181.383 Y163.864 E-.13909
G1 X181.541 Y163.673 E-.09391
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X185.19 Y164.227 Z4.8 F60000
G1 Z4.4
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F2331
M204 S8000
G2 X183.612 Y164.097 I-.95 J1.878 E.05387
G1 X183.517 Y164.221 E.00518
G1 X182.862 Y164.656 E.02608
G1 X182.732 Y164.685 E.00441
G2 X182.421 Y166.917 I1.55 J1.354 E.07912
G2 X183.517 Y167.423 I1.091 J-.921 E.04135
G2 X184.172 Y167.12 I.051 J-.75 E.02498
G1 X184.827 Y166.262 E.03582
G3 X186.138 Y165.68 I1.417 J1.424 E.04863
G1 X186.256 Y165.698 E.00398
G3 X185.881 Y167.24 I-2.58 J.188 E.0535
; COOLING_NODE: 1
; WIPE_START
G1 F8843.478
G1 X186.223 Y166.516 E-.30432
G1 X186.281 Y166.135 E-.14648
G1 X186.256 Y165.698 E-.16623
G1 X186.138 Y165.68 E-.04562
G1 X185.888 Y165.736 E-.09734
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X183.62 Y158.448 Z4.8 F60000
G1 X182.102 Y153.573 Z4.8
G1 Z4.4
G1 E.8 F1800
; FEATURE: Inner wall
G1 F2331
M204 S8000
G1 X182.102 Y152.777 E.0264
G1 X187.298 Y152.777 E.17236
G1 X187.298 Y153.573 E.0264
G1 X182.162 Y153.573 E.17037
; COOLING_NODE: 1
M204 S250
G1 X181.71 Y153.965 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2331
M204 S5000
G1 X181.71 Y152.385 E.04855
G1 X187.69 Y152.385 E.18375
G1 X187.69 Y153.965 E.04855
G1 X181.77 Y153.965 E.18191
M204 S10000
G1 X182.306 Y153.175 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F2331
M204 S8000
G1 X187.094 Y153.175 E.15172
; CHANGE_LAYER
; Z_HEIGHT: 4.47619
; LAYER_HEIGHT: 0.0761905
; WIPE_START
G1 F9259.259
G1 X185.094 Y153.175 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 27/85
; update layer progress
M73 L27
M991 S0 P26 ;notify layer change

; OBJECT_ID: 15
M204 S10000
G17
G3 Z4.8 I-.214 J-1.198 P1  F60000
G1 X179.603 Y154.156 Z4.8
G1 Z4.476
G1 E.8 F1800
; FEATURE: Support interface
; LINE_WIDTH: 0.42
; LAYER_HEIGHT: 0.27619
G1 F2624
M204 S8000
G1 X180.962 Y152.798 E.07798
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X180.962 Y152.363 E.01765
G1 X180.156 Y152.363 E.0327
G1 X178.533 Y153.987 E.09319
G1 X177.292 Y153.987 E.05035
G1 X178.916 Y152.363 E.09319
G1 X177.675 Y152.363 E.05035
G1 X176.052 Y153.987 E.09319
G1 X174.812 Y153.987 E.05035
G1 X176.435 Y152.363 E.09319
G1 X175.194 Y152.363 E.05035
G1 X173.571 Y153.987 E.09319
G1 X172.331 Y153.987 E.05035
G1 X173.954 Y152.363 E.09319
G1 X172.714 Y152.363 E.05035
G1 X171.09 Y153.987 E.09319
G1 X169.85 Y153.987 E.05035
G1 X171.473 Y152.363 E.09319
G1 X170.233 Y152.363 E.05035
G1 X168.869 Y153.728 E.07832
; CHANGE_LAYER
; Z_HEIGHT: 4.6
; LAYER_HEIGHT: 0.123809
; WIPE_START
G1 F4800
G1 X170.233 Y152.363 E-.73315
G1 X170.304 Y152.363 E-.02685
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 28/85
; update layer progress
M73 L28
M991 S0 P27 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 1
M204 S10000
G17
G3 Z4.876 I-.547 J-1.087 P1  F60000
M73 P61 R6
G1 X167.898 Y153.573 Z4.876
G1 Z4.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
; LAYER_HEIGHT: 0.2
G1 F2624
M204 S8000
G1 X162.702 Y153.573 E.17236
G1 X162.702 Y152.777 E.0264
G1 X167.898 Y152.777 E.17236
G1 X167.898 Y153.513 E.02441
; COOLING_NODE: 1
M204 S250
G1 X168.29 Y153.965 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2357
M204 S5000
G1 X162.31 Y153.965 E.18375
G1 X162.31 Y152.385 E.04855
G1 X168.29 Y152.385 E.18375
G1 X168.29 Y153.905 E.04671
M204 S10000
G1 X167.694 Y153.175 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F2624
M204 S8000
G1 X162.906 Y153.175 E.15172
; COOLING_NODE: 0
; WIPE_START
G1 F9259.259
G1 X164.906 Y153.175 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X166.793 Y160.57 Z5 F60000
G1 X168.112 Y165.741 Z5
G1 Z4.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2624
M204 S8000
G1 X168.129 Y166.155 E.01374
G3 X165.761 Y163.642 I-2.38 J-.13 E.3686
G1 X165.873 Y163.645 E.00372
G3 X168.108 Y165.682 I-.123 J2.38 E.10866
; COOLING_NODE: 0
M204 S10000
G1 X168.527 Y165.786 F60000
G1 F2624
M204 S8000
G1 X168.538 Y165.893 E.00357
G3 X165.764 Y163.235 I-2.787 J.132 E.44102
G1 X165.895 Y163.238 E.00434
G3 X168.514 Y165.636 I-.144 J2.787 E.12767
G1 X168.522 Y165.726 E.00299
; COOLING_NODE: 0
M204 S10000
G1 X168.932 Y165.747 F60000
G1 F2624
M204 S8000
G1 X168.945 Y165.874 E.00424
G3 X165.767 Y162.827 I-3.194 J.15 E.50534
G1 X165.916 Y162.832 E.00496
G3 X168.918 Y165.579 I-.165 J3.193 E.14631
G1 X168.927 Y165.688 E.0036
; COOLING_NODE: 0
M204 S250
G1 X169.322 Y165.711 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2258
M204 S5000
G1 X169.338 Y165.857 E.00451
G3 X165.77 Y162.435 I-3.586 J.168 E.52548
G1 X165.937 Y162.44 E.00516
G3 X169.307 Y165.525 I-.185 J3.585 E.15214
G1 X169.317 Y165.651 E.0039
; WIPE_START
G1 F9547.055
M204 S8000
G1 X169.338 Y165.857 E-.07854
G1 X169.335 Y166.213 E-.13549
G1 X169.305 Y166.525 E-.11888
G1 X169.233 Y166.894 E-.14282
G1 X169.123 Y167.253 E-.14292
G1 X169.004 Y167.542 E-.11879
G1 X168.976 Y167.594 E-.02257
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X165.804 Y168.05 Z5 F60000
G1 Z4.6
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F2624
M204 S8000
G2 X167.242 Y167.394 I-.058 J-2.032 E.05387
G3 X166.065 Y165.896 I1.475 J-2.371 E.06446
G3 X166.042 Y165.241 I.607 J-.35 E.02263
G2 X167.247 Y164.652 I-2.186 J-5.995 E.0446
G2 X165.354 Y164.038 I-1.53 J1.493 E.06866
G3 X165.614 Y165.241 I-1.196 J.888 E.04209
G1 X164.868 Y165.569 E.02704
G2 X163.78 Y166.491 I.765 J2.006 E.04821
G3 X164.044 Y164.933 I1.981 J-.465 E.05383
; COOLING_NODE: 2
; WIPE_START
G1 F8843.478
G1 X163.907 Y165.165 E-.10254
G1 X163.735 Y165.742 E-.2288
G1 X163.78 Y166.491 E-.28492
G1 X164.027 Y166.205 E-.14374
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.607 Y165.309 Z5 F60000
G1 X179.498 Y164.377 Z5
G1 Z4.6
G1 E.8 F1800
; FEATURE: Inner wall
G1 F2624
M204 S8000
G1 X179.498 Y165.173 E.0264
G1 X170.502 Y165.173 E.29841
G1 X170.502 Y164.377 E.0264
G1 X179.438 Y164.377 E.29642
; COOLING_NODE: 2
M204 S250
G1 X179.89 Y163.985 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2428
M204 S5000
G1 X179.89 Y165.565 E.04855
G1 X170.11 Y165.565 E.30051
G1 X170.11 Y163.985 E.04855
G1 X179.83 Y163.985 E.29867
M204 S10000
G1 X179.294 Y164.775 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F2624
M204 S8000
G1 X170.706 Y164.775 E.27211
; COOLING_NODE: 0
; WIPE_START
G1 F9259.259
G1 X172.706 Y164.775 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X180.31 Y165.432 Z5 F60000
G1 X181.911 Y165.57 Z5
G1 Z4.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2624
M204 S8000
G3 X184.261 Y163.642 I2.339 J.454 E.10936
G1 X184.373 Y163.645 E.00372
G3 X181.9 Y165.629 I-.123 J2.379 E.38147
; COOLING_NODE: 0
M204 S10000
G1 X181.505 Y165.536 F60000
G1 F2624
M204 S8000
G1 X181.512 Y165.493 E.00147
G3 X184.264 Y163.235 I2.738 J.531 E.12806
G1 X184.395 Y163.238 E.00434
G3 X181.471 Y165.786 I-.144 J2.786 E.43913
G1 X181.497 Y165.596 E.00636
; COOLING_NODE: 0
M204 S10000
G1 X181.102 Y165.48 F60000
G1 F2624
M204 S8000
G1 X181.113 Y165.415 E.00218
G3 X184.267 Y162.827 I3.138 J.609 E.14675
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X184.416 Y162.832 E.00496
G3 X181.067 Y165.749 I-.165 J3.192 E.50328
G1 X181.094 Y165.539 E.00701
; COOLING_NODE: 0
M204 S250
G1 X180.714 Y165.425 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2258
M204 S5000
G1 X180.729 Y165.34 E.00265
G3 X184.27 Y162.435 I3.523 J.683 E.15261
G1 X184.437 Y162.44 E.00516
G3 X180.677 Y165.713 I-.185 J3.583 E.52342
G1 X180.706 Y165.485 E.00707
; WIPE_START
G1 F9547.055
M204 S8000
G1 X180.729 Y165.34 E-.05559
G1 X180.817 Y164.975 E-.14278
G1 X180.922 Y164.68 E-.11898
G1 X181.08 Y164.339 E-.1428
G1 X181.239 Y164.069 E-.11901
G1 X181.46 Y163.766 E-.14263
G1 X181.527 Y163.691 E-.03822
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X185.031 Y164.154 Z5 F60000
G1 Z4.6
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F2624
M204 S8000
G2 X183.45 Y164.165 I-.777 J1.897 E.05382
G3 X182.577 Y164.876 I-1.447 J-.884 E.03808
G2 X182.48 Y167.024 I1.723 J1.154 E.07498
G2 X183.958 Y167.862 I2.632 J-2.921 E.05681
G1 X183.997 Y168.042 E.00612
G2 X184.7 Y168 I.209 J-2.359 E.02344
G1 X184.386 Y167.862 E.01136
G1 X184.316 Y167.534 E.01111
G3 X186.186 Y165.414 I2.81 J.593 E.09804
G2 X185.159 Y164.207 I-1.931 J.602 E.054
; COOLING_NODE: 1
; WIPE_START
G1 F8843.478
G1 X185.767 Y164.669 E-.29003
G1 X186.008 Y165.001 E-.15581
G1 X186.186 Y165.414 E-.17087
G1 X185.851 Y165.588 E-.1433
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X183.578 Y158.302 Z5 F60000
G1 X182.102 Y153.573 Z5
G1 Z4.6
G1 E.8 F1800
; FEATURE: Inner wall
G1 F2624
M204 S8000
G1 X182.102 Y152.777 E.0264
G1 X187.298 Y152.777 E.17236
G1 X187.298 Y153.573 E.0264
G1 X182.162 Y153.573 E.17037
; COOLING_NODE: 1
M204 S250
G1 X181.71 Y153.965 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2357
M204 S5000
G1 X181.71 Y152.385 E.04855
G1 X187.69 Y152.385 E.18375
G1 X187.69 Y153.965 E.04855
G1 X181.77 Y153.965 E.18191
M204 S10000
G1 X182.306 Y153.175 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F2624
M204 S8000
G1 X187.094 Y153.175 E.15172
; CHANGE_LAYER
; Z_HEIGHT: 4.75238
; LAYER_HEIGHT: 0.152381
; WIPE_START
G1 F9259.259
G1 X185.094 Y153.175 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 29/85
; update layer progress
M73 L29
M991 S0 P28 ;notify layer change

; OBJECT_ID: 15
M204 S10000
G17
G3 Z5 I-.168 J-1.205 P1  F60000
G1 X181.131 Y153.728 Z5
G1 Z4.752
G1 E.8 F1800
; FEATURE: Support interface
; LINE_WIDTH: 0.42
; LAYER_HEIGHT: 0.27619
G1 F2619
M204 S8000
G1 X179.767 Y152.363 E.07832
G1 X178.527 Y152.363 E.05035
G1 X180.15 Y153.987 E.09319
G1 X178.91 Y153.987 E.05035
G1 X177.286 Y152.363 E.09319
G1 X176.046 Y152.363 E.05035
G1 X177.669 Y153.987 E.09319
G1 X176.429 Y153.987 E.05035
G1 X174.806 Y152.363 E.09319
G1 X173.565 Y152.363 E.05035
G1 X175.189 Y153.987 E.09319
G1 X173.948 Y153.987 E.05035
G1 X172.325 Y152.363 E.09319
G1 X171.084 Y152.363 E.05035
G1 X172.708 Y153.987 E.09319
G1 X171.467 Y153.987 E.05035
G1 X169.844 Y152.363 E.09319
G1 X169.038 Y152.363 E.0327
G1 X169.038 Y152.798 E.01765
G1 X170.397 Y154.156 E.07798
; WIPE_START
G1 F4800
G1 X169.038 Y152.798 E-.72995
G1 X169.038 Y152.719 E-.03005
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z5.152 I1.217 J0 P1  F60000
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    
        M993 A2 B2 C2
        M993 A0 B0 C0
    

    
        M622.1 S0 ; for prev firmware, default turn off
        M1002 set_flag smooth_safe_pos_suppoprt_flag=1
        M1002 judge_flag smooth_safe_pos_suppoprt_flag
        
        M622 J0
            

            
                M9711 M0 E1 X256 Y153 Z4.75238 S11 C10 O0 T3000
            

            
        M623

        M622 J1
            

            
                M9711 M0 E1 U256 V153 Z4.75238 S11 C10 O0 T3000
            

            
        M623
    
    
    
        M993 A3 B3 C3
    
M623
; SKIPPABLE_END

G1 Z5.152
; CHANGE_LAYER
; Z_HEIGHT: 4.8
; LAYER_HEIGHT: 0.0476193
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 30/85
; update layer progress
M73 L30
M991 S0 P29 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 1
G1 X167.898 Y153.573
G1 Z4.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
; LAYER_HEIGHT: 0.2
G1 F2619
M204 S8000
G1 X162.702 Y153.573 E.17236
M73 P62 R6
G1 X162.702 Y152.777 E.0264
G1 X167.898 Y152.777 E.17236
G1 X167.898 Y153.513 E.02441
; COOLING_NODE: 1
M204 S250
G1 X168.29 Y153.965 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2342
M204 S5000
G1 X162.31 Y153.965 E.18375
G1 X162.31 Y152.385 E.04855
G1 X168.29 Y152.385 E.18375
G1 X168.29 Y153.905 E.04671
M204 S10000
G1 X167.694 Y153.175 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F2619
M204 S8000
G1 X162.906 Y153.175 E.15172
; COOLING_NODE: 0
; WIPE_START
G1 F9259.259
G1 X164.906 Y153.175 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X166.785 Y160.572 Z5.2 F60000
G1 X168.124 Y165.845 Z5.2
G1 Z4.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2619
M204 S8000
G1 X168.13 Y165.901 E.00188
G3 X165.769 Y163.642 I-2.379 J.123 E.37708
G1 X165.872 Y163.645 E.00342
G3 X168.104 Y165.65 I-.121 J2.379 E.10765
G1 X168.118 Y165.785 E.0045
; COOLING_NODE: 0
M204 S10000
G1 X168.529 Y165.802 F60000
G1 F2619
M204 S8000
G1 X168.537 Y165.88 E.00259
G3 X165.773 Y163.235 I-2.786 J.144 E.44149
G1 X165.894 Y163.238 E.00404
G3 X168.506 Y165.587 I-.143 J2.786 E.12605
G1 X168.522 Y165.742 E.00518
; COOLING_NODE: 0
M204 S10000
G1 X168.933 Y165.76 F60000
G1 F2619
M204 S8000
G1 X168.944 Y165.858 E.00329
G3 X165.776 Y162.827 I-3.192 J.165 E.5059
G1 X165.916 Y162.832 E.00465
G3 X168.909 Y165.524 I-.164 J3.192 E.14446
G1 X168.927 Y165.7 E.00587
; COOLING_NODE: 0
M204 S250
G1 X169.323 Y165.719 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2225
M204 S5000
G1 X169.336 Y165.838 E.00368
G3 X165.779 Y162.435 I-3.583 J.186 E.52609
G1 X165.937 Y162.44 E.00485
G3 X169.297 Y165.463 I-.185 J3.583 E.15023
G1 X169.317 Y165.659 E.00604
; WIPE_START
G1 F9547.055
M204 S8000
G1 X169.336 Y165.838 E-.06828
G1 X169.335 Y166.212 E-.14243
G1 X169.296 Y166.587 E-.14298
G1 X169.233 Y166.893 E-.11887
G1 X169.124 Y167.253 E-.14288
G1 X169.004 Y167.541 E-.11874
G1 X168.972 Y167.601 E-.02583
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X165.697 Y168.057 Z5.2 F60000
G1 Z4.8
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F2619
M204 S8000
G2 X167.17 Y167.472 I.023 J-2.088 E.0539
G3 X166.294 Y165.896 I1.374 J-1.794 E.0615
G1 X166.359 Y165.569 E.01108
G3 X167.292 Y164.704 I2.308 J1.552 E.04256
G2 X165.259 Y164.061 I-1.528 J1.298 E.07455
G3 X165.038 Y165.241 I-.911 J.44 E.04263
G1 X164.217 Y165.896 E.03486
G1 X163.799 Y166.565 E.02615
G3 X164.003 Y164.999 I1.964 J-.54 E.05381
; COOLING_NODE: 2
; WIPE_START
G1 F8843.478
G1 X163.838 Y165.329 E-.14049
G1 X163.718 Y165.926 E-.23146
G1 X163.799 Y166.565 E-.24453
G1 X163.999 Y166.245 E-.14352
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.577 Y165.332 Z5.2 F60000
G1 X179.498 Y164.377 Z5.2
G1 Z4.8
G1 E.8 F1800
; FEATURE: Inner wall
G1 F2619
M204 S8000
G1 X179.498 Y165.173 E.0264
G1 X170.502 Y165.173 E.29841
G1 X170.502 Y164.377 E.0264
G1 X179.438 Y164.377 E.29642
; COOLING_NODE: 2
M204 S250
G1 X179.89 Y163.985 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2421
M204 S5000
G1 X179.89 Y165.565 E.04855
G1 X170.11 Y165.565 E.30051
G1 X170.11 Y163.985 E.04855
G1 X179.83 Y163.985 E.29867
M204 S10000
G1 X179.294 Y164.775 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F2619
M204 S8000
G1 X170.706 Y164.775 E.27211
; COOLING_NODE: 0
; WIPE_START
G1 F9259.259
G1 X172.706 Y164.775 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X180.306 Y165.478 Z5.2 F60000
G1 X181.911 Y165.627 Z5.2
G1 Z4.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2619
M204 S8000
G1 X181.938 Y165.451 E.00592
G3 X184.269 Y163.642 I2.313 J.574 E.10554
G1 X184.372 Y163.645 E.00342
G3 X181.871 Y165.901 I-.121 J2.38 E.37258
G1 X181.902 Y165.686 E.00719
; COOLING_NODE: 0
M204 S10000
G1 X181.498 Y165.588 F60000
G1 F2619
M204 S8000
G3 X184.394 Y163.238 I2.756 J.437 E.13549
G3 X184.688 Y168.781 I-.149 J2.787 E.2712
G3 X181.489 Y165.647 I-.434 J-2.756 E.17242
; COOLING_NODE: 0
M204 S10000
G1 X181.094 Y165.524 F60000
G1 F2619
M204 S8000
G3 X184.276 Y162.827 I3.158 J.5 E.15072
G1 X184.416 Y162.832 E.00465
G3 X181.086 Y165.584 I-.164 J3.193 E.509
; COOLING_NODE: 0
M204 S250
G1 X180.707 Y165.448 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2225
M204 S5000
G1 X180.768 Y165.157 E.00914
G3 X184.437 Y162.44 I3.483 J.868 E.15204
G3 X184.625 Y169.595 I-.189 J3.585 E.32918
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G3 X180.699 Y165.507 I-.374 J-3.57 E.20074
; WIPE_START
G1 F9547.055
M204 S8000
G1 X180.768 Y165.157 E-.13576
G1 X180.877 Y164.797 E-.14267
G1 X181.024 Y164.45 E-.14318
G1 X181.173 Y164.176 E-.11857
G1 X181.383 Y163.864 E-.14314
G1 X181.516 Y163.712 E-.07667
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X185 Y164.143 Z5.2 F60000
G1 Z4.8
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F2619
M204 S8000
G2 X183.421 Y164.179 I-.743 J2.062 E.05362
G1 X183.163 Y164.586 E.01599
G1 X182.393 Y165.2 E.03266
G2 X182.672 Y167.295 I1.895 J.814 E.07361
G1 X183.383 Y167.862 E.03016
G2 X185.014 Y167.904 I.869 J-2.085 E.05538
G3 X184.704 Y167.534 I.631 J-.845 E.01614
G3 X185.182 Y165.896 I1.91 J-.331 E.0586
G1 X186.082 Y165.141 E.03899
G3 X186.16 Y166.726 I-1.863 J.885 E.05402
; COOLING_NODE: 1
; WIPE_START
G1 F8843.478
G1 X186.282 Y165.919 E-.31008
G1 X186.082 Y165.141 E-.3052
G1 X185.79 Y165.386 E-.14472
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X183.516 Y158.1 Z5.2 F60000
G1 X182.102 Y153.573 Z5.2
G1 Z4.8
G1 E.8 F1800
; FEATURE: Inner wall
G1 F2619
M204 S8000
G1 X182.102 Y152.777 E.0264
G1 X187.298 Y152.777 E.17236
G1 X187.298 Y153.573 E.0264
G1 X182.162 Y153.573 E.17037
; COOLING_NODE: 1
M204 S250
G1 X181.71 Y153.965 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2342
M204 S5000
G1 X181.71 Y152.385 E.04855
G1 X187.69 Y152.385 E.18375
G1 X187.69 Y153.965 E.04855
G1 X181.77 Y153.965 E.18191
M204 S10000
G1 X182.306 Y153.175 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F2619
M204 S8000
G1 X187.094 Y153.175 E.15172
; CHANGE_LAYER
; Z_HEIGHT: 5
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.259
G1 X185.094 Y153.175 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 31/85
; update layer progress
M73 L31
M991 S0 P30 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 1
M204 S10000
G17
G3 Z5.2 I-.028 J-1.217 P1  F60000
G1 X167.898 Y153.573 Z5.2
G1 Z5
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2318
M204 S8000
G1 X162.702 Y153.573 E.17236
G1 X162.702 Y152.777 E.0264
G1 X167.898 Y152.777 E.17236
G1 X167.898 Y153.513 E.02441
; COOLING_NODE: 1
M204 S250
G1 X168.29 Y153.965 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2318
M204 S5000
G1 X162.31 Y153.965 E.18375
G1 X162.31 Y152.385 E.04855
G1 X168.29 Y152.385 E.18375
G1 X168.29 Y153.905 E.04671
M204 S10000
G1 X167.694 Y153.175 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F2318
M204 S8000
G1 X162.906 Y153.175 E.15172
; COOLING_NODE: 0
; WIPE_START
G1 F9259.259
G1 X164.906 Y153.175 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X166.784 Y160.573 Z5.4 F60000
G1 X168.112 Y165.806 Z5.4
G1 Z5
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2318
M204 S8000
G1 X168.134 Y166.067 E.0087
G3 X165.777 Y163.642 I-2.383 J-.042 E.37196
M73 P63 R6
G1 X165.872 Y163.645 E.00313
G3 X168.098 Y165.611 I-.12 J2.38 E.10637
G1 X168.108 Y165.746 E.00449
; COOLING_NODE: 0
M204 S10000
G1 X168.534 Y165.813 F60000
G1 F2318
M204 S8000
G3 X165.781 Y163.235 I-2.782 J.212 E.44414
G1 X165.894 Y163.238 E.00374
G3 X168.529 Y165.753 I-.142 J2.786 E.13164
; COOLING_NODE: 0
M204 S10000
G1 X168.938 Y165.777 F60000
G1 F2318
M204 S8000
G1 X168.94 Y165.781 E.00014
G3 X165.785 Y162.828 I-3.188 J.244 E.50895
G1 X165.916 Y162.832 E.00435
G3 X168.901 Y165.469 I-.164 J3.193 E.14265
G1 X168.931 Y165.718 E.0083
; COOLING_NODE: 0
M204 S250
G1 X169.327 Y165.728 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2191
M204 S5000
G1 X169.332 Y165.75 E.0007
G3 X165.789 Y162.435 I-3.579 J.274 E.52925
G1 X165.937 Y162.44 E.00457
G3 X169.288 Y165.401 I-.184 J3.585 E.14832
G1 X169.319 Y165.669 E.00828
; WIPE_START
G1 F9547.055
M204 S8000
G1 X169.332 Y165.75 E-.0314
G1 X169.339 Y166.088 E-.12834
G1 X169.313 Y166.463 E-.14273
G1 X169.248 Y166.832 E-.14249
G1 X169.152 Y167.171 E-.13384
G1 X169.03 Y167.485 E-.12822
G1 X168.967 Y167.61 E-.05297
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X165.583 Y168.05 Z5.4 F60000
G1 Z5
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F2318
M204 S8000
G2 X167.09 Y167.555 I.164 J-2.042 E.05403
G3 X166.466 Y165.896 I1.292 J-1.433 E.06108
G3 X167.344 Y164.773 I2.737 J1.234 E.04774
G2 X165.19 Y164.078 I-1.597 J1.263 E.07959
G1 X165.19 Y164.586 E.01687
G3 X164.129 Y165.896 I-3.168 J-1.48 E.05647
G1 X163.845 Y166.552 E.02369
G2 X164.927 Y167.883 I1.738 J-.307 E.05944
; COOLING_NODE: 2
; WIPE_START
G1 F8843.478
G1 X164.528 Y167.651 E-.17538
G1 X164.237 Y167.385 E-.14987
G1 X163.999 Y167.06 E-.15303
G1 X163.845 Y166.725 E-.14005
G1 X163.845 Y166.552 E-.06596
G1 X163.924 Y166.369 E-.07572
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.495 Y165.401 Z5.4 F60000
G1 X179.498 Y164.377 Z5.4
G1 Z5
G1 E.8 F1800
; FEATURE: Inner wall
G1 F2318
M204 S8000
G1 X179.498 Y165.173 E.0264
G1 X170.502 Y165.173 E.29841
G1 X170.502 Y164.377 E.0264
G1 X179.438 Y164.377 E.29642
; COOLING_NODE: 2
M204 S250
G1 X179.89 Y163.985 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2318
M204 S5000
G1 X179.89 Y165.565 E.04855
G1 X170.11 Y165.565 E.30051
G1 X170.11 Y163.985 E.04855
G1 X179.83 Y163.985 E.29867
M204 S10000
G1 X179.294 Y164.775 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F2318
M204 S8000
G1 X170.706 Y164.775 E.27211
; COOLING_NODE: 0
; WIPE_START
G1 F9259.259
G1 X172.706 Y164.775 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X180.307 Y165.462 Z5.4 F60000
G1 X181.91 Y165.607 Z5.4
G1 Z5
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2318
M204 S8000
G1 X181.919 Y165.533 E.00245
G3 X184.277 Y163.642 I2.332 J.491 E.10861
G1 X184.372 Y163.645 E.00313
G3 X181.869 Y165.983 I-.12 J2.38 E.36988
G1 X181.903 Y165.666 E.01057
; COOLING_NODE: 0
M204 S10000
G1 X181.494 Y165.602 F60000
G1 F2318
M204 S8000
G1 X181.522 Y165.448 E.0052
G3 X184.281 Y163.235 I2.73 J.577 E.12708
G1 X184.394 Y163.238 E.00374
G3 X181.483 Y165.684 I-.142 J2.786 E.44276
G1 X181.486 Y165.662 E.00074
; COOLING_NODE: 0
M204 S10000
G1 X181.093 Y165.535 F60000
G1 F2318
M204 S8000
G1 X181.124 Y165.362 E.00583
G3 X184.285 Y162.828 I3.128 J.662 E.14555
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X184.416 Y162.832 E.00435
G3 X181.079 Y165.635 I-.164 J3.193 E.50732
G1 X181.085 Y165.595 E.00133
; COOLING_NODE: 0
M204 S250
G1 X180.706 Y165.471 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2191
M204 S5000
G1 X180.742 Y165.28 E.00595
G3 X184.289 Y162.435 I3.511 J.744 E.1513
G1 X184.437 Y162.44 E.00457
G3 X180.69 Y165.587 I-.184 J3.585 E.52753
G1 X180.698 Y165.53 E.00177
; WIPE_START
G1 F9547.055
M204 S8000
G1 X180.742 Y165.28 E-.09639
G1 X180.829 Y164.939 E-.13393
G1 X180.945 Y164.623 E-.12797
G1 X181.11 Y164.285 E-.14294
G1 X181.31 Y163.965 E-.14311
G1 X181.495 Y163.724 E-.11566
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X182.675 Y167.303 Z5.4 F60000
G1 Z5
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F2318
M204 S8000
G3 X182.33 Y165.569 I1.384 J-1.177 E.06125
G3 X183.25 Y164.586 I7.852 J6.433 E.0447
G1 X183.43 Y164.171 E.01501
G3 X185.977 Y164.958 I.826 J1.84 E.09658
G3 X185.094 Y165.896 I-7.498 J-6.168 E.04276
G2 X184.95 Y167.534 I1.454 J.953 E.05681
G1 X185.197 Y167.823 E.0126
G3 X183.619 Y167.952 I-.947 J-1.87 E.05386
; COOLING_NODE: 1
; WIPE_START
G1 F8843.478
G1 X184.101 Y168.054 E-.18711
G1 X184.496 Y168.044 E-.15027
G1 X185.197 Y167.823 E-.27921
G1 X184.952 Y167.536 E-.14341
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X183.426 Y160.058 Z5.4 F60000
G1 X182.102 Y153.573 Z5.4
G1 Z5
G1 E.8 F1800
; FEATURE: Inner wall
G1 F2318
M204 S8000
G1 X182.102 Y152.777 E.0264
G1 X187.298 Y152.777 E.17236
G1 X187.298 Y153.573 E.0264
G1 X182.162 Y153.573 E.17037
; COOLING_NODE: 1
M204 S250
G1 X181.71 Y153.965 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2318
M204 S5000
G1 X181.71 Y152.385 E.04855
G1 X187.69 Y152.385 E.18375
G1 X187.69 Y153.965 E.04855
G1 X181.77 Y153.965 E.18191
M204 S10000
G1 X182.306 Y153.175 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
M73 P63 R5
G1 F2318
M204 S8000
G1 X187.094 Y153.175 E.15172
; CHANGE_LAYER
; Z_HEIGHT: 5.02857
; LAYER_HEIGHT: 0.0285716
; WIPE_START
G1 F9259.259
G1 X185.094 Y153.175 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 32/85
; update layer progress
M73 L32
M991 S0 P31 ;notify layer change

; OBJECT_ID: 15
M204 S10000
G17
G3 Z5.4 I-.062 J-1.215 P1  F60000
G1 X169.095 Y153.987 Z5.4
G1 Z5.029
G1 E.8 F1800
; FEATURE: Support
; LINE_WIDTH: 0.42
; LAYER_HEIGHT: 0.27619
G1 F2566
M204 S8000
G1 X180.961 Y153.987 E.48169
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X180.961 Y152.363 E.06589
G1 X169.039 Y152.363 E.48399
G1 X169.039 Y153.987 E.06589
; CHANGE_LAYER
; Z_HEIGHT: 5.2
; LAYER_HEIGHT: 0.171428
; WIPE_START
G1 F7226.745
G1 X169.039 Y152.363 E-.61679
G1 X169.415 Y152.363 E-.14321
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 33/85
; update layer progress
M73 L33
M991 S0 P32 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 1
M204 S10000
G17
G3 Z5.429 I-.759 J-.952 P1  F60000
G1 X167.898 Y153.573 Z5.429
G1 Z5.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
; LAYER_HEIGHT: 0.2
G1 F2566
M204 S8000
G1 X162.702 Y153.573 E.17236
G1 X162.702 Y152.777 E.0264
G1 X167.898 Y152.777 E.17236
G1 X167.898 Y153.513 E.02441
; COOLING_NODE: 1
M204 S250
G1 X168.29 Y153.965 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2304
M204 S5000
G1 X162.31 Y153.965 E.18375
G1 X162.31 Y152.385 E.04855
G1 X168.29 Y152.385 E.18375
G1 X168.29 Y153.905 E.04671
M204 S10000
G1 X167.694 Y153.175 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F2566
M204 S8000
G1 X162.906 Y153.175 E.15172
; COOLING_NODE: 0
; WIPE_START
G1 F9259.259
G1 X164.906 Y153.175 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
M73 P64 R5
G1 X166.783 Y160.573 Z5.6 F60000
G1 X168.113 Y165.81 Z5.6
G1 Z5.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2566
M204 S8000
G1 X168.134 Y166.067 E.00856
G3 X165.785 Y163.642 I-2.383 J-.042 E.3722
G1 X165.87 Y163.645 E.00284
G3 X168.098 Y165.607 I-.119 J2.38 E.1063
G1 X168.108 Y165.75 E.00474
; COOLING_NODE: 0
M204 S10000
G1 X168.534 Y165.821 F60000
G1 F2566
M204 S8000
G3 X165.789 Y163.235 I-2.783 J.204 E.44414
G1 X165.893 Y163.238 E.00344
G3 X168.529 Y165.761 I-.141 J2.787 E.13195
; COOLING_NODE: 0
M204 S10000
G1 X168.938 Y165.779 F60000
G1 F2566
M204 S8000
G1 X168.941 Y165.79 E.00039
G3 X165.794 Y162.828 I-3.189 J.234 E.50895
G1 X165.915 Y162.832 E.00403
G3 X168.9 Y165.468 I-.163 J3.193 E.14263
G1 X168.931 Y165.719 E.00839
; COOLING_NODE: 0
M204 S250
G1 X169.326 Y165.73 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2158
M204 S5000
G1 X169.332 Y165.76 E.00093
G3 X165.798 Y162.435 I-3.58 J.264 E.52927
G1 X165.937 Y162.44 E.00427
G3 X169.287 Y165.401 I-.185 J3.585 E.14831
G1 X169.319 Y165.671 E.00834
; WIPE_START
G1 F9547.055
M204 S8000
G1 X169.332 Y165.76 E-.03425
G1 X169.339 Y166.088 E-.12468
G1 X169.313 Y166.463 E-.14279
G1 X169.248 Y166.832 E-.14256
G1 X169.149 Y167.18 E-.13738
G1 X169.03 Y167.485 E-.12449
G1 X168.965 Y167.612 E-.05385
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X165.46 Y168.037 Z5.6 F60000
G1 Z5.2
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F2566
M204 S8000
G2 X166.989 Y167.628 I.219 J-2.245 E.05366
G3 X166.6 Y165.896 I1.213 J-1.182 E.06195
G3 X167.406 Y164.86 I16.066 J11.657 E.04353
G2 X165.145 Y164.089 I-1.663 J1.172 E.0847
G1 X165.055 Y164.586 E.01677
G3 X164.028 Y165.896 I-20.326 J-14.885 E.05525
G1 X163.862 Y166.552 E.02242
G2 X165.133 Y167.959 I1.702 J-.26 E.06661
; COOLING_NODE: 2
; WIPE_START
G1 F8843.478
G1 X164.53 Y167.652 E-.25681
G1 X164.237 Y167.385 E-.15098
G1 X163.93 Y166.928 E-.20924
G1 X163.863 Y166.558 E-.14297
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.422 Y165.503 Z5.6 F60000
G1 X179.498 Y164.377 Z5.6
G1 Z5.2
G1 E.8 F1800
; FEATURE: Inner wall
G1 F2566
M204 S8000
G1 X179.498 Y165.173 E.0264
G1 X170.502 Y165.173 E.29841
G1 X170.502 Y164.377 E.0264
G1 X179.438 Y164.377 E.29642
; COOLING_NODE: 2
M204 S250
G1 X179.89 Y163.985 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2440
M204 S5000
G1 X179.89 Y165.565 E.04855
G1 X170.11 Y165.565 E.30051
G1 X170.11 Y163.985 E.04855
G1 X179.83 Y163.985 E.29867
M204 S10000
G1 X179.294 Y164.775 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F2566
M204 S8000
G1 X170.706 Y164.775 E.27211
; COOLING_NODE: 0
; WIPE_START
G1 F9259.259
G1 X172.706 Y164.775 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X180.3 Y165.54 Z5.6 F60000
G1 X181.89 Y165.701 Z5.6
G1 Z5.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2566
M204 S8000
G1 X181.929 Y165.489 E.00715
G3 X184.285 Y163.642 I2.322 J.536 E.10734
G1 X184.37 Y163.645 E.00284
G3 X181.883 Y165.76 I-.119 J2.38 E.37733
; COOLING_NODE: 0
M204 S10000
G1 X181.49 Y165.63 F60000
G1 F2566
M204 S8000
G1 X181.533 Y165.397 E.00786
G3 X184.289 Y163.235 I2.719 J.627 E.12563
G1 X184.393 Y163.238 E.00344
G3 X181.482 Y165.69 I-.141 J2.787 E.4426
; COOLING_NODE: 0
M204 S10000
G1 X181.089 Y165.559 F60000
G1 F2566
M204 S8000
G1 X181.137 Y165.306 E.00856
G3 X184.294 Y162.828 I3.115 J.719 E.14393
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X184.415 Y162.832 E.00403
G3 X181.079 Y165.635 I-.163 J3.193 E.50731
G1 X181.081 Y165.619 E.00055
; COOLING_NODE: 0
M204 S250
G1 X180.704 Y165.491 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2158
M204 S5000
G1 X180.755 Y165.218 E.00855
G3 X184.298 Y162.435 I3.497 J.807 E.14964
G1 X184.437 Y162.44 E.00427
G3 X180.69 Y165.587 I-.185 J3.585 E.52751
G1 X180.695 Y165.551 E.00114
; WIPE_START
G1 F9547.055
M204 S8000
G1 X180.755 Y165.218 E-.12858
G1 X180.851 Y164.87 E-.13719
G1 X180.97 Y164.565 E-.12435
G1 X181.141 Y164.23 E-.14275
G1 X181.309 Y163.967 E-.1187
G1 X181.482 Y163.74 E-.10844
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X183.076 Y167.683 Z5.6 F60000
G1 Z5.2
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F2566
M204 S8000
G3 X182.324 Y165.896 I.81 J-1.392 E.06899
G3 X183.352 Y164.586 I20.32 J14.881 E.05525
G1 X183.459 Y164.161 E.01455
G3 X185.86 Y164.797 I.774 J1.929 E.08831
G3 X184.993 Y165.896 I-17.057 J-12.574 E.04647
G2 X185.346 Y167.736 I1.519 J.662 E.06604
G3 X183.784 Y168.003 I-1.113 J-1.814 E.05387
; COOLING_NODE: 1
; WIPE_START
G1 F8843.478
G1 X184.497 Y168.044 E-.2716
G1 X184.885 Y167.958 E-.15094
G1 X185.346 Y167.736 E-.19433
G1 X185.118 Y167.436 E-.14313
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X183.496 Y159.978 Z5.6 F60000
G1 X182.102 Y153.573 Z5.6
G1 Z5.2
G1 E.8 F1800
; FEATURE: Inner wall
G1 F2566
M204 S8000
G1 X182.102 Y152.777 E.0264
G1 X187.298 Y152.777 E.17236
G1 X187.298 Y153.573 E.0264
G1 X182.162 Y153.573 E.17037
; COOLING_NODE: 1
M204 S250
G1 X181.71 Y153.965 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2304
M204 S5000
G1 X181.71 Y152.385 E.04855
G1 X187.69 Y152.385 E.18375
G1 X187.69 Y153.965 E.04855
G1 X181.77 Y153.965 E.18191
M204 S10000
G1 X182.306 Y153.175 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F2566
M204 S8000
G1 X187.094 Y153.175 E.15172
; CHANGE_LAYER
; Z_HEIGHT: 5.30476
; LAYER_HEIGHT: 0.104762
; WIPE_START
G1 F9259.259
G1 X185.094 Y153.175 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 34/85
; update layer progress
M73 L34
M991 S0 P33 ;notify layer change

; OBJECT_ID: 15
M204 S10000
G17
G3 Z5.6 I-.062 J-1.215 P1  F60000
G1 X169.095 Y153.987 Z5.6
G1 Z5.305
G1 E.8 F1800
; FEATURE: Support
; LINE_WIDTH: 0.42
; LAYER_HEIGHT: 0.27619
G1 F2565
M204 S8000
G1 X180.961 Y153.987 E.48169
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X180.961 Y152.363 E.06589
G1 X169.039 Y152.363 E.48399
G1 X169.039 Y153.987 E.06589
; CHANGE_LAYER
; Z_HEIGHT: 5.4
; LAYER_HEIGHT: 0.0952382
; WIPE_START
G1 F7226.745
G1 X169.039 Y152.363 E-.61679
G1 X169.415 Y152.363 E-.14321
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 35/85
; update layer progress
M73 L35
M991 S0 P34 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 1
M204 S10000
G17
G3 Z5.705 I-.759 J-.952 P1  F60000
G1 X167.898 Y153.573 Z5.705
G1 Z5.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
; LAYER_HEIGHT: 0.2
G1 F2565
M204 S8000
G1 X162.702 Y153.573 E.17236
G1 X162.702 Y152.777 E.0264
G1 X167.898 Y152.777 E.17236
G1 X167.898 Y153.513 E.02441
; COOLING_NODE: 1
M204 S250
G1 X168.29 Y153.965 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2269
M204 S5000
G1 X162.31 Y153.965 E.18375
G1 X162.31 Y152.385 E.04855
G1 X168.29 Y152.385 E.18375
G1 X168.29 Y153.905 E.04671
M204 S10000
G1 X167.694 Y153.175 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F2565
M204 S8000
G1 X162.906 Y153.175 E.15172
; COOLING_NODE: 0
; WIPE_START
G1 F9259.259
G1 X164.906 Y153.175 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X166.783 Y160.573 Z5.8 F60000
G1 X168.113 Y165.814 Z5.8
G1 Z5.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2565
M204 S8000
G1 X168.133 Y166.067 E.00843
M73 P65 R5
G3 X165.793 Y163.642 I-2.383 J-.042 E.3725
G1 X165.87 Y163.645 E.00254
G3 X168.097 Y165.606 I-.119 J2.38 E.10626
G1 X168.108 Y165.754 E.00492
; COOLING_NODE: 0
M204 S10000
G1 X168.534 Y165.83 F60000
G1 F2565
M204 S8000
G3 X165.798 Y163.235 I-2.783 J.195 E.44417
G1 X165.892 Y163.238 E.00314
G3 X168.53 Y165.77 I-.141 J2.786 E.13223
; COOLING_NODE: 0
M204 S10000
G1 X168.938 Y165.781 F60000
G1 F2565
M204 S8000
G1 X168.941 Y165.799 E.00062
G3 X165.803 Y162.828 I-3.189 J.225 E.50898
G1 X165.915 Y162.831 E.00373
G3 X168.9 Y165.467 I-.164 J3.193 E.14258
G1 X168.93 Y165.721 E.00848
; COOLING_NODE: 0
M204 S250
G1 X169.326 Y165.733 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2123
M204 S5000
G1 X169.332 Y165.77 E.00115
G3 X165.808 Y162.436 I-3.58 J.255 E.52929
G1 X165.937 Y162.44 E.00398
G3 X169.286 Y165.401 I-.186 J3.585 E.14827
G1 X169.319 Y165.673 E.00843
; WIPE_START
G1 F9547.055
M204 S8000
G1 X169.332 Y165.77 E-.03705
G1 X169.339 Y166.088 E-.12094
G1 X169.313 Y166.464 E-.14309
G1 X169.262 Y166.771 E-.11847
G1 X169.164 Y167.134 E-.14285
G1 X169.032 Y167.481 E-.14099
G1 X168.965 Y167.614 E-.05661
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X165.299 Y168.002 Z5.8 F60000
G1 Z5.4
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F2565
M204 S8000
G3 X164.069 Y165.569 I.237 J-1.647 E.10597
G3 X164.946 Y164.586 I37.921 J32.964 E.0437
G1 X165.122 Y164.094 E.01733
G3 X167.508 Y165.004 I.618 J1.963 E.09138
G3 X166.71 Y165.896 I-34.449 J-29.999 E.03972
G2 X166.689 Y167.534 I1.522 J.838 E.05658
G1 X166.859 Y167.728 E.00853
G3 X165.299 Y168.002 I-1.152 J-1.98 E.05365
; COOLING_NODE: 2
; WIPE_START
G1 F8843.478
G1 X165.998 Y168.043 E-.26612
G1 X166.386 Y167.957 E-.15109
G1 X166.859 Y167.728 E-.19972
G1 X166.689 Y167.534 E-.0977
G1 X166.636 Y167.428 E-.04537
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X174.062 Y165.666 Z5.8 F60000
G1 X179.498 Y164.377 Z5.8
G1 Z5.4
G1 E.8 F1800
; FEATURE: Inner wall
G1 F2565
M204 S8000
G1 X179.498 Y165.173 E.0264
G1 X170.502 Y165.173 E.29841
G1 X170.502 Y164.377 E.0264
G1 X179.438 Y164.377 E.29642
; COOLING_NODE: 2
M204 S250
G1 X179.89 Y163.985 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2447
M204 S5000
G1 X179.89 Y165.565 E.04855
G1 X170.11 Y165.565 E.30051
G1 X170.11 Y163.985 E.04855
G1 X179.83 Y163.985 E.29867
M204 S10000
G1 X179.294 Y164.775 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F2565
M204 S8000
G1 X170.706 Y164.775 E.27211
; COOLING_NODE: 0
; WIPE_START
G1 F9259.259
G1 X172.706 Y164.775 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X180.304 Y165.493 Z5.8 F60000
G1 X181.905 Y165.644 Z5.8
G1 Z5.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2565
M204 S8000
G1 X181.919 Y165.535 E.00365
G3 X184.293 Y163.642 I2.332 J.489 E.10921
G1 X184.37 Y163.645 E.00254
G3 X181.868 Y165.989 I-.119 J2.38 E.36973
G1 X181.899 Y165.704 E.00952
; COOLING_NODE: 0
M204 S10000
G1 X181.488 Y165.641 F60000
G1 F2565
M204 S8000
G1 X181.521 Y165.449 E.00647
G3 X184.298 Y163.235 I2.73 J.575 E.12771
G1 X184.392 Y163.238 E.00314
G3 X181.48 Y165.701 I-.141 J2.786 E.44222
; COOLING_NODE: 0
M204 S10000
G1 X181.086 Y165.575 F60000
G1 F2565
M204 S8000
G1 X181.123 Y165.363 E.00712
G3 X184.303 Y162.828 I3.128 J.661 E.1462
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X184.415 Y162.831 E.00373
G3 X181.078 Y165.635 I-.164 J3.193 E.5073
G1 X181.078 Y165.634 E.00003
; COOLING_NODE: 0
M204 S250
G1 X180.7 Y165.51 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2123
M204 S5000
G1 X180.74 Y165.28 E.00718
G3 X184.308 Y162.436 I3.511 J.744 E.15193
G1 X184.437 Y162.44 E.00398
G3 X180.689 Y165.587 I-.186 J3.585 E.52749
G1 X180.691 Y165.57 E.00055
; WIPE_START
G1 F9547.055
M204 S8000
G1 X180.74 Y165.28 E-.1116
G1 X180.817 Y164.977 E-.11882
G1 X180.946 Y164.622 E-.14352
G1 X181.11 Y164.285 E-.14257
G1 X181.31 Y163.965 E-.14316
G1 X181.471 Y163.756 E-.10033
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X183.122 Y167.715 Z5.8 F60000
G1 Z5.4
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F2565
M204 S8000
G3 X182.257 Y166.389 I1.335 J-1.814 E.05366
G1 X182.434 Y165.896 E.01735
G2 X183.475 Y164.586 I-3.274 J-3.67 E.05579
G1 X183.509 Y164.138 E.0149
G3 X185.799 Y164.71 I.72 J1.988 E.08308
G2 X184.87 Y165.896 I2.98 J3.293 E.05024
G2 X185.461 Y167.659 I1.823 J.369 E.06457
G3 X183.921 Y168.022 I-1.192 J-1.608 E.05398
; COOLING_NODE: 1
; WIPE_START
G1 F8843.478
G1 X184.708 Y168.007 E-.29924
G1 X185.461 Y167.659 E-.31539
G1 X185.205 Y167.374 E-.14538
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X183.531 Y159.928 Z5.8 F60000
G1 X182.102 Y153.573 Z5.8
G1 Z5.4
G1 E.8 F1800
; FEATURE: Inner wall
G1 F2565
M204 S8000
G1 X182.102 Y152.777 E.0264
G1 X187.298 Y152.777 E.17236
G1 X187.298 Y153.573 E.0264
G1 X182.162 Y153.573 E.17037
; COOLING_NODE: 1
M204 S250
G1 X181.71 Y153.965 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2269
M204 S5000
G1 X181.71 Y152.385 E.04855
G1 X187.69 Y152.385 E.18375
G1 X187.69 Y153.965 E.04855
G1 X181.77 Y153.965 E.18191
M204 S10000
G1 X182.306 Y153.175 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F2565
M204 S8000
G1 X187.094 Y153.175 E.15172
; CHANGE_LAYER
; Z_HEIGHT: 5.58095
; LAYER_HEIGHT: 0.180952
; WIPE_START
G1 F9259.259
G1 X185.094 Y153.175 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 36/85
; update layer progress
M73 L36
M991 S0 P35 ;notify layer change

; OBJECT_ID: 15
M204 S10000
G17
G3 Z5.8 I-.062 J-1.215 P1  F60000
G1 X169.095 Y153.987 Z5.8
G1 Z5.581
G1 E.8 F1800
; FEATURE: Support
; LINE_WIDTH: 0.42
; LAYER_HEIGHT: 0.27619
G1 F2563
M204 S8000
G1 X180.961 Y153.987 E.48169
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X180.961 Y152.363 E.06589
G1 X169.039 Y152.363 E.48399
G1 X169.039 Y153.987 E.06589
; CHANGE_LAYER
; Z_HEIGHT: 5.6
; LAYER_HEIGHT: 0.0190477
; WIPE_START
G1 F7226.745
G1 X169.039 Y152.363 E-.61679
G1 X169.415 Y152.363 E-.14321
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 37/85
; update layer progress
M73 L37
M991 S0 P36 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 1
M204 S10000
G17
G3 Z5.981 I-.759 J-.952 P1  F60000
G1 X167.898 Y153.573 Z5.981
G1 Z5.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
; LAYER_HEIGHT: 0.2
G1 F2563
M204 S8000
G1 X162.702 Y153.573 E.17236
G1 X162.702 Y152.777 E.0264
G1 X167.898 Y152.777 E.17236
G1 X167.898 Y153.513 E.02441
; COOLING_NODE: 1
M204 S250
G1 X168.29 Y153.965 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2228
M204 S5000
G1 X162.31 Y153.965 E.18375
G1 X162.31 Y152.385 E.04855
G1 X168.29 Y152.385 E.18375
G1 X168.29 Y153.905 E.04671
M204 S10000
G1 X167.694 Y153.175 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F2563
M204 S8000
G1 X162.906 Y153.175 E.15172
; COOLING_NODE: 0
; WIPE_START
G1 F9259.259
G1 X164.906 Y153.175 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X166.784 Y160.573 Z6 F60000
G1 X168.125 Y165.856 Z6
G1 Z5.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2563
M204 S8000
G1 X168.127 Y165.901 E.00149
G3 X165.747 Y163.642 I-2.38 J.124 E.3766
G1 X165.874 Y163.645 E.0042
G3 X168.101 Y165.652 I-.126 J2.38 E.10756
G1 X168.118 Y165.796 E.00482
; COOLING_NODE: 0
M204 S10000
M73 P66 R5
G1 X168.53 Y165.813 F60000
G1 F2563
M204 S8000
G1 X168.535 Y165.88 E.0022
G3 X165.749 Y163.234 I-2.786 J.145 E.44097
G1 X165.895 Y163.238 E.00485
G3 X168.504 Y165.588 I-.147 J2.786 E.12598
G1 X168.523 Y165.754 E.00552
; COOLING_NODE: 0
M204 S10000
G1 X168.934 Y165.771 F60000
G1 F2563
M204 S8000
G1 X168.942 Y165.858 E.00291
G3 X165.751 Y162.827 I-3.193 J.166 E.50535
G1 X165.917 Y162.832 E.0055
G3 X168.907 Y165.525 I-.168 J3.193 E.14438
G1 X168.928 Y165.711 E.00623
; COOLING_NODE: 0
M204 S250
G1 X169.324 Y165.73 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2088
M204 S5000
G1 X169.335 Y165.838 E.00332
G3 X165.753 Y162.435 I-3.584 J.187 E.52556
G1 X165.937 Y162.44 E.00567
G3 X169.295 Y165.463 I-.187 J3.584 E.15016
G1 X169.317 Y165.67 E.0064
; WIPE_START
G1 F9547.055
M204 S8000
G1 X169.335 Y165.838 E-.06392
G1 X169.335 Y166.213 E-.14277
G1 X169.305 Y166.525 E-.11887
G1 X169.233 Y166.893 E-.14267
G1 X169.123 Y167.253 E-.14293
G1 X168.976 Y167.6 E-.14317
G1 X168.969 Y167.613 E-.00567
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X167.646 Y166.759 Z6 F60000
G1 Z5.6
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F2563
M204 S8000
G2 X167.589 Y165.177 I-1.861 J-.724 E.05398
G3 X166.803 Y165.896 I-2.728 J-2.192 E.03548
G2 X166.471 Y167.534 I1.407 J1.137 E.05762
G1 X166.701 Y167.814 E.01201
G3 X164.915 Y167.862 I-.95 J-2.077 E.0609
G1 X164.182 Y167.207 E.03261
G3 X163.851 Y165.569 I1.406 J-1.137 E.05762
G3 X164.853 Y164.586 I3.693 J2.765 E.04675
G1 X165.123 Y164.094 E.01863
G3 X166.701 Y164.232 I.619 J2.013 E.05387
; COOLING_NODE: 2
; WIPE_START
G1 F8843.478
G1 X166.269 Y164.058 E-.17704
G1 X165.863 Y163.994 E-.1561
G1 X165.123 Y164.094 E-.28377
G1 X164.942 Y164.424 E-.1431
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.575 Y164.399 Z6 F60000
G1 X179.498 Y164.377 Z6
G1 Z5.6
G1 E.8 F1800
; FEATURE: Inner wall
G1 F2563
M204 S8000
G1 X179.498 Y165.173 E.0264
G1 X170.502 Y165.173 E.29841
G1 X170.502 Y164.377 E.0264
G1 X179.438 Y164.377 E.29642
; COOLING_NODE: 2
M204 S250
G1 X179.89 Y163.985 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2452
M204 S5000
G1 X179.89 Y165.565 E.04855
G1 X170.11 Y165.565 E.30051
G1 X170.11 Y163.985 E.04855
G1 X179.83 Y163.985 E.29867
M204 S10000
G1 X179.294 Y164.775 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F2563
M204 S8000
G1 X170.706 Y164.775 E.27211
; COOLING_NODE: 0
; WIPE_START
G1 F9259.259
G1 X172.706 Y164.775 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X180.298 Y165.553 Z6 F60000
G1 X181.889 Y165.716 Z6
G1 Z5.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2563
M204 S8000
G1 X181.918 Y165.523 E.00647
G3 X184.247 Y163.642 I2.33 J.501 E.10742
G1 X184.374 Y163.645 E.0042
G3 X181.878 Y165.776 I-.126 J2.38 E.37658
G1 X181.878 Y165.775 E.00001
; COOLING_NODE: 0
M204 S10000
G1 X181.488 Y165.652 F60000
G1 F2563
M204 S8000
G1 X181.52 Y165.441 E.00711
G3 X184.249 Y163.234 I2.728 J.584 E.12589
G1 X184.395 Y163.238 E.00485
G3 X181.474 Y165.733 I-.147 J2.786 E.44094
G1 X181.477 Y165.712 E.00073
; COOLING_NODE: 0
M204 S10000
G1 X181.087 Y165.568 F60000
G1 F2563
M204 S8000
G1 X181.091 Y165.525 E.00143
G3 X184.251 Y162.827 I3.158 J.499 E.15001
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X184.417 Y162.832 E.0055
G3 X181.056 Y165.858 I-.168 J3.193 E.49973
G1 X181.081 Y165.628 E.0077
; COOLING_NODE: 0
M204 S250
G1 X180.698 Y165.527 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2088
M204 S5000
G1 X180.705 Y165.464 E.00196
G3 X184.253 Y162.435 I3.545 J.561 E.15603
G1 X184.437 Y162.44 E.00567
G3 X180.666 Y165.838 I-.187 J3.584 E.51971
G1 X180.691 Y165.587 E.00776
; WIPE_START
G1 F9547.055
M204 S8000
G1 X180.705 Y165.464 E-.04699
G1 X180.767 Y165.154 E-.12014
G1 X180.877 Y164.797 E-.14176
G1 X181.024 Y164.45 E-.14331
G1 X181.173 Y164.176 E-.1184
G1 X181.383 Y163.864 E-.14307
G1 X181.461 Y163.77 E-.04633
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X182.598 Y164.848 Z6 F60000
G1 Z5.6
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F2563
M204 S8000
G2 X182.254 Y166.393 I1.715 J1.192 E.05384
G1 X182.526 Y165.896 E.01877
G2 X183.529 Y164.914 I-2.691 J-3.748 E.04675
G2 X183.588 Y164.102 I-2.065 J-.557 E.02715
G3 X185.748 Y164.649 I.626 J2.064 E.07766
G2 X184.815 Y165.569 I2.521 J3.487 E.0436
G1 X184.715 Y165.896 E.01136
G2 X185.559 Y167.575 I2.144 J-.026 E.06449
G3 X184.047 Y168.041 I-1.32 J-1.595 E.05384
; COOLING_NODE: 1
; WIPE_START
G1 F8843.478
G1 X184.536 Y168.039 E-.18569
G1 X184.939 Y167.939 E-.15801
G1 X185.559 Y167.575 E-.27305
G1 X185.278 Y167.324 E-.14325
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X183.56 Y159.887 Z6 F60000
G1 X182.102 Y153.573 Z6
G1 Z5.6
G1 E.8 F1800
; FEATURE: Inner wall
G1 F2563
M204 S8000
G1 X182.102 Y152.777 E.0264
G1 X187.298 Y152.777 E.17236
G1 X187.298 Y153.573 E.0264
G1 X182.162 Y153.573 E.17037
; COOLING_NODE: 1
M204 S250
G1 X181.71 Y153.965 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2228
M204 S5000
G1 X181.71 Y152.385 E.04855
G1 X187.69 Y152.385 E.18375
G1 X187.69 Y153.965 E.04855
G1 X181.77 Y153.965 E.18191
M204 S10000
G1 X182.306 Y153.175 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F2563
M204 S8000
G1 X187.094 Y153.175 E.15172
; CHANGE_LAYER
; Z_HEIGHT: 5.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.259
G1 X185.094 Y153.175 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 38/85
; update layer progress
M73 L38
M991 S0 P37 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 1
M204 S10000
G17
G3 Z6 I-.028 J-1.217 P1  F60000
G1 X167.898 Y153.573 Z6
G1 Z5.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2467
M204 S8000
G1 X162.702 Y153.573 E.17236
G1 X162.702 Y152.777 E.0264
G1 X167.898 Y152.777 E.17236
G1 X167.898 Y153.513 E.02441
; COOLING_NODE: 1
M204 S250
G1 X168.29 Y153.965 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2181
M204 S5000
G1 X162.31 Y153.965 E.18375
G1 X162.31 Y152.385 E.04855
G1 X168.29 Y152.385 E.18375
G1 X168.29 Y153.905 E.04671
M204 S10000
G1 X167.694 Y153.175 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F2467
M204 S8000
G1 X162.906 Y153.175 E.15172
; COOLING_NODE: 0
; WIPE_START
G1 F9259.259
G1 X164.906 Y153.175 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X166.791 Y160.571 Z6.2 F60000
G1 X168.114 Y165.762 Z6.2
G1 Z5.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2467
M204 S8000
G1 X168.129 Y166.156 E.01307
G3 X165.755 Y163.642 I-2.38 J-.131 E.36839
G1 X165.874 Y163.645 E.00396
G3 X168.11 Y165.698 I-.124 J2.38 E.10916
G1 X168.11 Y165.702 E.00014
; COOLING_NODE: 0
M204 S10000
G1 X168.53 Y165.804 F60000
G1 F2467
M204 S8000
G1 X168.537 Y165.879 E.00248
G3 X165.757 Y163.234 I-2.787 J.146 E.44127
G1 X165.895 Y163.238 E.00459
G3 X168.514 Y165.639 I-.145 J2.787 E.12775
G1 X168.524 Y165.745 E.00351
; COOLING_NODE: 0
M204 S10000
G1 X168.935 Y165.766 F60000
G1 F2467
M204 S8000
G1 X168.942 Y165.858 E.00306
G3 X166.084 Y169.205 I-3.193 J.167 E.16104
G3 X165.917 Y162.832 I-.333 J-3.18 E.34981
G3 X168.916 Y165.582 I-.168 J3.193 E.14629
G1 X168.928 Y165.706 E.00416
; COOLING_NODE: 0
M204 S250
G1 X169.324 Y165.714 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
M73 P67 R5
G1 F2054
M204 S5000
G1 X169.339 Y166.025 E.00956
G3 X166.125 Y169.595 I-3.59 J0 E.1617
G3 X165.938 Y162.44 I-.374 J-3.57 E.36378
G3 X169.32 Y165.654 I-.189 J3.585 E.15606
; WIPE_START
G1 F9547.055
M204 S8000
G1 X169.339 Y166.025 E-.141
G1 X169.326 Y166.337 E-.11862
G1 X169.274 Y166.71 E-.14323
G1 X169.123 Y167.253 E-.21407
G1 X169.004 Y167.542 E-.11902
G1 X168.974 Y167.598 E-.02405
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X166.631 Y164.194 Z6.2 F60000
G1 Z5.8
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F2467
M204 S8000
G3 X167.679 Y165.384 I-.887 J1.837 E.05402
G1 X166.884 Y165.896 E.03138
G2 X166.161 Y167.534 I1.681 J1.72 E.06085
G2 X166.472 Y167.924 I.594 J-.155 E.01701
G3 X165.386 Y168.024 I-.743 J-2.114 E.03652
G1 X165.28 Y167.862 E.00644
G1 X164.263 Y167.207 E.04012
G1 X163.802 Y166.604 E.02516
G3 X163.928 Y165.13 I2.622 J-.519 E.04974
G1 X164.772 Y164.586 E.0333
G1 X165.159 Y164.081 E.0211
G3 X166.631 Y164.194 I.564 J2.309 E.04983
; COOLING_NODE: 2
; WIPE_START
G1 F8843.478
G1 X166.269 Y164.058 E-.14709
G1 X165.863 Y163.994 E-.15608
G1 X165.159 Y164.081 E-.26983
G1 X164.86 Y164.472 E-.187
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.488 Y164.225 Z6.2 F60000
G1 X179.89 Y163.985 Z6.2
G1 Z5.8
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2456
M204 S5000
G1 X179.89 Y165.565 E.04855
G1 X170.11 Y165.565 E.30051
G1 X170.11 Y163.985 E.04855
G1 X179.83 Y163.985 E.29867
M204 S10000
G1 X178.926 Y164.192 F60000
; FEATURE: Top surface
G1 F2467
M204 S2000
G1 X179.683 Y164.949 E.03289
G1 X179.816 Y165.083
G1 X179.691 Y165.491
G1 X179.558 Y165.358
G1 X178.392 Y164.192 E.05063
G1 X178.259 Y164.059
G1 X177.726 Y164.059
G1 X177.859 Y164.192
G1 X179.024 Y165.358 E.05063
G1 X179.158 Y165.491
G1 X178.625 Y165.491
G1 X178.491 Y165.358
G1 X177.326 Y164.192 E.05063
G1 X177.192 Y164.059
G1 X176.659 Y164.059
G1 X176.793 Y164.192
G1 X177.958 Y165.358 E.05063
G1 X178.092 Y165.491
G1 X177.558 Y165.491
G1 X177.425 Y165.358
G1 X176.259 Y164.192 E.05063
G1 X176.126 Y164.059
G1 X175.593 Y164.059
G1 X175.726 Y164.192
G1 X176.891 Y165.358 E.05063
G1 X177.025 Y165.491
G1 X176.492 Y165.491
G1 X176.358 Y165.358
G1 X175.193 Y164.192 E.05063
G1 X175.059 Y164.059
G1 X174.526 Y164.059
G1 X174.66 Y164.192
G1 X175.825 Y165.358 E.05063
G1 X175.959 Y165.491
G1 X175.425 Y165.491
G1 X175.292 Y165.358
G1 X174.126 Y164.192 E.05063
G1 X173.993 Y164.059
G1 X173.459 Y164.059
G1 X173.593 Y164.192
G1 X174.758 Y165.358 E.05063
G1 X174.892 Y165.491
G1 X174.359 Y165.491
G1 X174.225 Y165.358
G1 X173.06 Y164.192 E.05063
G1 X172.926 Y164.059
G1 X172.393 Y164.059
G1 X172.527 Y164.192
G1 X173.692 Y165.358 E.05063
G1 X173.825 Y165.491
G1 X173.292 Y165.491
G1 X173.159 Y165.358
G1 X171.993 Y164.192 E.05063
G1 X171.86 Y164.059
G1 X171.326 Y164.059
G1 X171.46 Y164.192
G1 X172.625 Y165.358 E.05063
G1 X172.759 Y165.491
G1 X172.226 Y165.491
G1 X172.092 Y165.358
G1 X170.927 Y164.192 E.05063
G1 X170.793 Y164.059
G1 X170.26 Y164.059
G1 X170.394 Y164.192
G1 X171.559 Y165.358 E.05063
G1 X171.692 Y165.491
G1 X171.159 Y165.491
G1 X171.026 Y165.358
G1 X170.317 Y164.649 E.03077
; COOLING_NODE: 0
; WIPE_START
G1 F9547.055
M204 S8000
G1 X171.026 Y165.358 E-.38057
G1 X171.159 Y165.491 E-.07182
G1 X171.692 Y165.491 E-.20264
G1 X171.559 Y165.358 E-.07182
G1 X171.497 Y165.296 E-.03315
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X179.123 Y165.611 Z6.2 F60000
G1 X181.896 Y165.726 Z6.2
G1 Z5.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2467
M204 S8000
G1 X181.937 Y165.448 E.00931
G3 X184.255 Y163.642 I2.312 J.577 E.10502
G1 X184.374 Y163.645 E.00396
G3 X181.87 Y165.895 I-.124 J2.38 E.37268
G1 X181.887 Y165.785 E.00368
; COOLING_NODE: 0
M204 S10000
G1 X181.487 Y165.637 F60000
G1 F2467
M204 S8000
G3 X184.257 Y163.234 I2.763 J.388 E.1327
G1 X184.395 Y163.238 E.00459
G3 X181.48 Y165.696 I-.145 J2.786 E.44224
; COOLING_NODE: 0
M204 S10000
G1 X181.083 Y165.581 F60000
G1 F2467
M204 S8000
G1 X181.084 Y165.58 E.00007
G3 X184.417 Y162.832 I3.167 J.445 E.15731
G3 X184.584 Y169.205 I-.168 J3.193 E.31653
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G3 X181.058 Y165.856 I-.333 J-3.18 E.18331
G1 X181.078 Y165.641 E.00714
; COOLING_NODE: 0
M204 S250
G1 X180.693 Y165.544 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2054
M204 S5000
G1 X180.696 Y165.525 E.00057
G3 X184.438 Y162.44 I3.555 J.5 E.16359
G3 X184.625 Y169.595 I-.189 J3.585 E.32916
G3 X180.666 Y165.837 I-.374 J-3.57 E.19057
G1 X180.688 Y165.603 E.0072
; WIPE_START
G1 F9547.055
M204 S8000
G1 X180.696 Y165.525 E-.02988
G1 X180.767 Y165.156 E-.14277
G1 X180.877 Y164.797 E-.14273
G1 X180.997 Y164.508 E-.11907
G1 X181.173 Y164.176 E-.14276
G1 X181.383 Y163.865 E-.14253
G1 X181.452 Y163.785 E-.04026
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X182.609 Y164.824 Z6.2 F60000
G1 Z5.8
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F2467
M204 S8000
G2 X182.247 Y166.368 I2.216 J1.335 E.05348
G1 X182.607 Y165.896 E.01969
G1 X183.624 Y165.241 E.04012
G2 X183.832 Y164.586 I-.372 J-.478 E.02424
G1 X183.666 Y164.079 E.01771
G3 X185.705 Y164.607 I.584 J1.947 E.07346
G1 X184.72 Y165.241 E.03887
G2 X184.513 Y165.896 I.372 J.478 E.02424
G2 X185.661 Y167.486 I2.437 J-.551 E.06685
G3 X184.183 Y168.057 I-1.45 J-1.554 E.05388
; COOLING_NODE: 1
; WIPE_START
G1 F8843.478
G1 X184.946 Y167.936 E-.29358
G1 X185.299 Y167.768 E-.14869
G1 X185.661 Y167.486 E-.17439
G1 X185.344 Y167.282 E-.14335
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X183.588 Y159.854 Z6.2 F60000
G1 X182.102 Y153.573 Z6.2
G1 Z5.8
G1 E.8 F1800
; FEATURE: Inner wall
G1 F2467
M204 S8000
G1 X182.102 Y152.777 E.0264
G1 X187.298 Y152.777 E.17236
G1 X187.298 Y153.573 E.0264
G1 X182.162 Y153.573 E.17037
; COOLING_NODE: 1
M204 S250
G1 X181.71 Y153.965 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2181
M204 S5000
G1 X181.71 Y152.385 E.04855
G1 X187.69 Y152.385 E.18375
G1 X187.69 Y153.965 E.04855
G1 X181.77 Y153.965 E.18191
M204 S10000
G1 X182.306 Y153.175 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F2467
M204 S8000
G1 X187.094 Y153.175 E.15172
; CHANGE_LAYER
; Z_HEIGHT: 5.85714
; LAYER_HEIGHT: 0.0571427
; WIPE_START
G1 F9259.259
G1 X185.094 Y153.175 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 39/85
; update layer progress
M73 L39
M991 S0 P38 ;notify layer change

; OBJECT_ID: 15
M204 S10000
G17
G3 Z6.2 I-.062 J-1.215 P1  F60000
G1 X169.095 Y153.987 Z6.2
G1 Z5.857
G1 E.8 F1800
; FEATURE: Support
; LINE_WIDTH: 0.42
; LAYER_HEIGHT: 0.27619
G1 F2137
M204 S8000
G1 X180.961 Y153.987 E.48169
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X180.961 Y152.363 E.06589
G1 X169.039 Y152.363 E.48399
G1 X169.039 Y153.987 E.06589
; CHANGE_LAYER
; Z_HEIGHT: 6
; LAYER_HEIGHT: 0.142857
; WIPE_START
G1 F7226.745
G1 X169.039 Y152.363 E-.61679
G1 X169.415 Y152.363 E-.14321
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 40/85
; update layer progress
M73 L40
M991 S0 P39 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z6.257 I-1.211 J-.116 P1  F60000
G1 X168.126 Y165.862 Z6.257
G1 Z6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
; LAYER_HEIGHT: 0.2
G1 F2137
M204 S8000
G1 X168.129 Y165.901 E.0013
G3 X165.762 Y163.642 I-2.379 J.122 E.37678
G1 X165.873 Y163.645 E.00367
G3 X168.102 Y165.651 I-.123 J2.379 E.10762
G1 X168.119 Y165.802 E.00504
; COOLING_NODE: 0
M204 S10000
G1 X168.53 Y165.819 F60000
G1 F2137
M204 S8000
G1 X168.536 Y165.88 E.00201
G3 X166.041 Y168.8 I-2.787 J.145 E.14052
G3 X165.895 Y163.238 I-.289 J-2.775 E.30512
G3 X168.505 Y165.588 I-.146 J2.787 E.12601
G1 X168.524 Y165.76 E.00573
; COOLING_NODE: 0
M204 S10000
G1 X168.935 Y165.777 F60000
G1 F2137
M204 S8000
G1 X168.943 Y165.858 E.00272
G3 X165.769 Y162.827 I-3.191 J.165 E.50555
G1 X165.916 Y162.832 E.00489
G3 X168.908 Y165.525 I-.165 J3.191 E.14444
G1 X168.929 Y165.717 E.00642
; COOLING_NODE: 0
M204 S250
M73 P68 R5
G1 X169.324 Y165.736 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2020
M204 S5000
G1 X169.335 Y165.838 E.00314
G3 X165.772 Y162.435 I-3.583 J.185 E.52574
G1 X165.937 Y162.44 E.00509
G3 X169.296 Y165.464 I-.185 J3.583 E.15022
G1 X169.318 Y165.676 E.00657
; WIPE_START
G1 F9547.055
M204 S8000
G1 X169.335 Y165.838 E-.06167
G1 X169.335 Y166.212 E-.14243
G1 X169.296 Y166.587 E-.14298
G1 X169.233 Y166.893 E-.11895
G1 X169.123 Y167.253 E-.14282
G1 X168.976 Y167.599 E-.14301
G1 X168.966 Y167.618 E-.00815
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X167.428 Y167.16 Z6.4 F60000
G1 Z6
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F2137
M204 S8000
G2 X167.733 Y165.609 I-1.704 J-1.14 E.05382
G2 X166.483 Y166.294 I.345 J2.113 E.04822
G1 X165.828 Y167.296 E.03969
G3 X165.173 Y167.513 I-.488 J-.374 E.02432
G3 X163.836 Y166.715 I.487 J-2.334 E.05261
G3 X164.121 Y164.81 I1.991 J-.676 E.06636
G1 X164.518 Y164.684 E.01381
G1 X165.173 Y164.188 E.02725
G3 X165.467 Y164.011 I.241 J.067 E.01255
G3 X166.821 Y164.296 I.192 J2.443 E.04652
; COOLING_NODE: 1
; WIPE_START
G1 F8843.478
G1 X166.068 Y164.015 E-.30533
G1 X165.467 Y164.011 E-.22838
G1 X165.255 Y164.062 E-.08267
G1 X165.173 Y164.188 E-.05739
G1 X164.992 Y164.325 E-.08624
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X166.983 Y156.957 Z6.4 F60000
G1 X167.898 Y153.573 Z6.4
G1 Z6
G1 E.8 F1800
; FEATURE: Inner wall
G1 F2137
M204 S8000
G1 X162.702 Y153.573 E.17236
G1 X162.702 Y152.777 E.0264
G1 X167.898 Y152.777 E.17236
G1 X167.898 Y153.513 E.02441
; COOLING_NODE: 1
M204 S250
G1 X168.29 Y153.965 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2135
M204 S5000
G1 X162.31 Y153.965 E.18375
G1 X162.31 Y152.385 E.04855
G1 X168.29 Y152.385 E.18375
G1 X168.29 Y153.905 E.04671
M204 S10000
G1 X167.694 Y153.175 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F2137
M204 S8000
G1 X162.906 Y153.175 E.15172
; COOLING_NODE: 0
; WIPE_START
G1 F9259.259
G1 X164.906 Y153.175 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.179 Y157.523 Z6.4 F60000
G1 X182.072 Y165.072 Z6.4
G1 Z6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2137
M204 S8000
G1 X182.146 Y164.908 E.00597
G3 X184.373 Y163.645 I2.105 J1.117 E.08967
G3 X184.499 Y168.395 I-.124 J2.38 E.23597
G3 X182.011 Y165.21 I-.248 J-2.37 E.16001
G1 X182.048 Y165.127 E.00302
; COOLING_NODE: 0
M204 S10000
G1 X181.714 Y164.864 F60000
G1 F2137
M204 S8000
G1 X181.729 Y164.832 E.00117
G3 X184.266 Y163.235 I2.522 J1.193 E.10499
G1 X184.395 Y163.238 E.00428
G3 X181.629 Y165.071 I-.144 J2.786 E.46364
G1 X181.691 Y164.92 E.00544
; COOLING_NODE: 0
M204 S10000
G1 X181.339 Y164.708 F60000
G1 F2137
M204 S8000
G1 X181.362 Y164.657 E.00184
G3 X184.269 Y162.827 I2.89 J1.367 E.1203
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X184.416 Y162.832 E.00489
G3 X181.247 Y164.932 I-.165 J3.193 E.5313
G1 X181.316 Y164.763 E.00604
; COOLING_NODE: 0
M204 S250
G1 X180.977 Y164.557 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2020
M204 S5000
G1 X181.008 Y164.489 E.00229
G3 X184.272 Y162.435 I3.244 J1.535 E.12509
G1 X184.437 Y162.44 E.00509
G3 X180.879 Y164.798 I-.185 J3.585 E.55249
G1 X180.954 Y164.613 E.00615
; WIPE_START
G1 F9547.055
M204 S8000
G1 X181.008 Y164.489 E-.05114
G1 X181.173 Y164.176 E-.13434
G1 X181.383 Y163.864 E-.14309
G1 X181.582 Y163.623 E-.11886
G1 X181.848 Y163.357 E-.14286
G1 X182.202 Y163.085 E-.16971
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X184.311 Y168.057 Z6.4 F60000
G1 Z6
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F2137
M204 S8000
G2 X185.746 Y167.389 I-.303 J-2.527 E.0534
G1 X185.483 Y167.305 E.00919
G1 X184.827 Y166.809 E.02725
G1 X184.172 Y165.808 E.03969
G2 X183.517 Y165.59 I-.488 J.374 E.02432
G2 X182.235 Y166.273 I.326 J2.157 E.04914
G3 X183.769 Y164.059 I2.065 J-.208 E.09725
G1 X184.172 Y164.675 E.02442
G2 X184.827 Y164.893 I.488 J-.374 E.02432
G1 X185.483 Y164.684 E.02281
G1 X185.653 Y164.555 E.0071
G3 X186.282 Y166.01 I-1.957 J1.709 E.05345
; COOLING_NODE: 1
; WIPE_START
G1 F8843.478
G1 X186.161 Y165.33 E-.26278
G1 X185.993 Y164.977 E-.14846
G1 X185.653 Y164.555 E-.20588
G1 X185.483 Y164.684 E-.08135
G1 X185.328 Y164.733 E-.06154
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X183.209 Y157.401 Z6.4 F60000
G1 X182.102 Y153.573 Z6.4
G1 Z6
G1 E.8 F1800
; FEATURE: Inner wall
G1 F2137
M204 S8000
G1 X182.102 Y152.777 E.0264
G1 X187.298 Y152.777 E.17236
G1 X187.298 Y153.573 E.0264
G1 X182.162 Y153.573 E.17037
; COOLING_NODE: 1
M204 S250
G1 X181.71 Y153.965 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2135
M204 S5000
G1 X181.71 Y152.385 E.04855
G1 X187.69 Y152.385 E.18375
G1 X187.69 Y153.965 E.04855
G1 X181.77 Y153.965 E.18191
M204 S10000
G1 X182.306 Y153.175 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F2137
M204 S8000
G1 X187.094 Y153.175 E.15172
; CHANGE_LAYER
; Z_HEIGHT: 6.13333
; LAYER_HEIGHT: 0.133333
; WIPE_START
G1 F9259.259
G1 X185.094 Y153.175 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 41/85
; update layer progress
M73 L41
M991 S0 P40 ;notify layer change

; OBJECT_ID: 15
M204 S10000
G17
G3 Z6.4 I-.062 J-1.215 P1  F60000
G1 X169.095 Y153.987 Z6.4
G1 Z6.133
G1 E.8 F1800
; FEATURE: Support
; LINE_WIDTH: 0.42
; LAYER_HEIGHT: 0.27619
G1 F2144
M204 S8000
G1 X180.961 Y153.987 E.48169
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X180.961 Y152.363 E.06589
G1 X169.039 Y152.363 E.48399
G1 X169.039 Y153.987 E.06589
; CHANGE_LAYER
; Z_HEIGHT: 6.2
; LAYER_HEIGHT: 0.0666666
; WIPE_START
G1 F7226.745
G1 X169.039 Y152.363 E-.61679
G1 X169.415 Y152.363 E-.14321
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 42/85
; update layer progress
M73 L42
M991 S0 P41 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z6.533 I-1.211 J-.116 P1  F60000
G1 X168.123 Y165.841 Z6.533
G1 Z6.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
; LAYER_HEIGHT: 0.2
G1 F2144
M204 S8000
G1 X168.13 Y165.942 E.00336
G3 X165.792 Y163.642 I-2.38 J.082 E.37639
G1 X165.916 Y163.648 E.00414
G3 X168.108 Y165.688 I-.166 J2.376 E.1074
G1 X168.117 Y165.781 E.00312
; COOLING_NODE: 0
M204 S10000
G1 X168.528 Y165.805 F60000
G1 F2144
M204 S8000
G1 X168.537 Y165.927 E.00409
G3 X165.799 Y163.235 I-2.787 J.096 E.4407
G1 X165.945 Y163.241 E.00484
G3 X168.511 Y165.633 I-.194 J2.782 E.12586
G1 X168.522 Y165.745 E.00374
; COOLING_NODE: 0
M204 S10000
G1 X168.933 Y165.769 F60000
G1 F2144
M204 S8000
G1 X168.944 Y165.913 E.0048
G3 X165.806 Y162.828 I-3.194 J.11 E.50501
G1 X165.973 Y162.835 E.00554
G3 X168.915 Y165.578 I-.223 J3.188 E.14431
G1 X168.927 Y165.709 E.00438
; COOLING_NODE: 0
M204 S250
G1 X169.323 Y165.735 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1990
M204 S5000
G1 X169.336 Y165.9 E.00508
G3 X165.813 Y162.436 I-3.585 J.123 E.52517
G1 X166 Y162.444 E.00576
G3 X169.303 Y165.525 I-.25 J3.579 E.15012
G1 X169.318 Y165.675 E.00463
; WIPE_START
M73 P69 R5
G1 F9547.055
M204 S8000
G1 X169.336 Y165.9 E-.08566
G1 X169.331 Y166.275 E-.14279
G1 X169.285 Y166.648 E-.14283
G1 X169.201 Y167.015 E-.14281
G1 X169.102 Y167.311 E-.11857
G1 X168.966 Y167.617 E-.12735
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X167.32 Y167.312 Z6.6 F60000
G1 Z6.2
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F2144
M204 S8000
G2 X167.769 Y165.793 I-1.563 J-1.289 E.05399
G2 X166.483 Y166.213 I-.136 J1.762 E.04606
G3 X165.5 Y167.21 I-3.859 J-2.821 E.0466
G1 X165.173 Y167.313 E.01139
G3 X163.891 Y166.852 I-.06 J-1.847 E.04626
G3 X164.264 Y164.651 I1.834 J-.822 E.07854
G1 X164.518 Y164.624 E.00846
G1 X165.173 Y164.27 E.02471
G3 X165.483 Y164.009 I.339 J.089 E.01432
G3 X166.932 Y164.378 I.269 J1.974 E.05084
; COOLING_NODE: 1
; WIPE_START
G1 F8843.478
G1 X166.303 Y164.067 E-.26665
G1 X165.892 Y163.997 E-.15838
G1 X165.483 Y164.009 E-.15549
G1 X165.388 Y164.03 E-.03677
G1 X165.173 Y164.27 E-.12242
G1 X165.126 Y164.295 E-.02029
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X167.036 Y156.906 Z6.6 F60000
G1 X167.898 Y153.573 Z6.6
G1 Z6.2
G1 E.8 F1800
; FEATURE: Inner wall
G1 F2144
M204 S8000
G1 X162.702 Y153.573 E.17236
G1 X162.702 Y152.777 E.0264
G1 X167.898 Y152.777 E.17236
G1 X167.898 Y153.513 E.02441
; COOLING_NODE: 1
M204 S250
G1 X168.29 Y153.965 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2101
M204 S5000
G1 X162.31 Y153.965 E.18375
G1 X162.31 Y152.385 E.04855
G1 X168.29 Y152.385 E.18375
G1 X168.29 Y153.905 E.04671
M204 S10000
G1 X167.694 Y153.175 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F2144
M204 S8000
G1 X162.906 Y153.175 E.15172
; COOLING_NODE: 0
; WIPE_START
G1 F9259.259
G1 X164.906 Y153.175 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.173 Y157.531 Z6.6 F60000
G1 X182.056 Y165.094 Z6.6
G1 Z6.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2144
M204 S8000
G3 X184.292 Y163.642 I2.194 J.931 E.09383
G1 X184.416 Y163.648 E.00414
G3 X182.034 Y165.149 I-.166 J2.377 E.3967
; COOLING_NODE: 0
M204 S10000
G1 X181.682 Y164.935 F60000
G1 F2144
M204 S8000
G3 X184.299 Y163.235 I2.568 J1.09 E.10986
G1 X184.445 Y163.241 E.00484
G3 X181.659 Y164.99 I-.195 J2.783 E.46482
; COOLING_NODE: 0
M204 S10000
G1 X181.31 Y164.768 F60000
G1 F2144
M204 S8000
G1 X181.454 Y164.474 E.01084
G3 X184.306 Y162.828 I2.796 J1.55 E.11476
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X184.473 Y162.835 E.00554
G3 X181.287 Y164.823 I-.223 J3.189 E.53324
; COOLING_NODE: 0
M204 S250
G1 X180.958 Y164.596 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1990
M204 S5000
G1 X181.111 Y164.284 E.01065
G3 X184.313 Y162.436 I3.139 J1.74 E.11936
G1 X184.5 Y162.444 E.00576
G3 X180.934 Y164.651 I-.25 J3.581 E.55535
; WIPE_START
G1 F9547.055
M204 S8000
G1 X181.111 Y164.284 E-.15451
G1 X181.274 Y164.017 E-.11891
G1 X181.5 Y163.717 E-.14293
G1 X181.756 Y163.443 E-.14243
G1 X182.015 Y163.216 E-.131
G1 X182.165 Y163.108 E-.07022
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X184.456 Y168.047 Z6.6 F60000
G1 Z6.2
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F2144
M204 S8000
G2 X185.843 Y167.282 I-.203 J-2.011 E.05399
G1 X185.483 Y167.245 E.01204
G1 X184.827 Y166.89 E.02471
G2 X183.845 Y165.893 I-3.859 J2.822 E.0466
G1 X183.517 Y165.79 E.01139
G2 X182.23 Y166.201 I-.149 J1.758 E.04599
G3 X183.908 Y164.026 I2.033 J-.166 E.09997
G2 X184.827 Y164.692 I1.419 J-.991 E.03837
G1 X185.483 Y164.624 E.02185
G1 X185.63 Y164.544 E.00557
G3 X186.283 Y165.986 I-1.346 J1.478 E.05397
; COOLING_NODE: 1
; WIPE_START
G1 F8843.478
G1 X186.109 Y165.197 E-.30687
G1 X185.63 Y164.544 E-.30767
G1 X185.483 Y164.624 E-.06381
G1 X185.269 Y164.646 E-.08166
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X183.17 Y157.308 Z6.6 F60000
G1 X182.102 Y153.573 Z6.6
G1 Z6.2
G1 E.8 F1800
; FEATURE: Inner wall
G1 F2144
M204 S8000
G1 X182.102 Y152.777 E.0264
G1 X187.298 Y152.777 E.17236
G1 X187.298 Y153.573 E.0264
G1 X182.162 Y153.573 E.17037
; COOLING_NODE: 1
M204 S250
G1 X181.71 Y153.965 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2101
M204 S5000
G1 X181.71 Y152.385 E.04855
G1 X187.69 Y152.385 E.18375
G1 X187.69 Y153.965 E.04855
G1 X181.77 Y153.965 E.18191
M204 S10000
G1 X182.306 Y153.175 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F2144
M204 S8000
G1 X187.094 Y153.175 E.15172
; CHANGE_LAYER
; Z_HEIGHT: 6.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.259
G1 X185.094 Y153.175 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 43/85
; update layer progress
M73 L43
M991 S0 P42 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z6.6 I-.727 J-.976 P1  F60000
G1 X168.114 Y165.827 Z6.6
G1 Z6.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1908
M204 S8000
G1 X168.134 Y166.067 E.00799
G3 X165.779 Y163.642 I-2.383 J-.042 E.37202
G1 X165.871 Y163.645 E.00306
G3 X168.099 Y165.617 I-.12 J2.38 E.10659
G1 X168.11 Y165.767 E.00499
; COOLING_NODE: 0
M204 S10000
G1 X168.531 Y165.782 F60000
G1 F1908
M204 S8000
G3 X165.783 Y163.235 I-2.779 J.243 E.44525
G1 X165.893 Y163.238 E.00366
G3 X168.525 Y165.722 I-.142 J2.786 E.13062
; COOLING_NODE: 0
M204 S10000
G1 X168.937 Y165.746 F60000
G1 F1908
M204 S8000
G3 X165.787 Y162.828 I-3.185 J.279 E.51019
G1 X165.916 Y162.832 E.00426
G3 X168.932 Y165.686 I-.163 J3.193 E.14993
; COOLING_NODE: 0
M204 S250
G1 X169.327 Y165.722 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1908
M204 S5000
G1 X169.342 Y166.088 E.01125
M73 P69 R4
G3 X165.791 Y162.435 I-3.589 J-.064 E.51894
G1 X165.937 Y162.44 E.00449
G3 X169.324 Y165.663 I-.184 J3.585 E.15644
; WIPE_START
G1 F9547.055
M204 S8000
G1 X169.342 Y166.088 E-.16178
G1 X169.316 Y166.441 E-.13441
G1 X169.261 Y166.772 E-.12749
G1 X169.183 Y167.075 E-.11899
G1 X169.055 Y167.427 E-.14241
G1 X168.968 Y167.604 E-.07492
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X167.075 Y164.493 Z6.8 F60000
G1 Z6.4
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F1908
M204 S8000
G2 X165.571 Y164.007 I-1.332 J1.553 E.05381
G3 X164.518 Y164.593 I-1.237 J-.982 E.04103
G1 X164.333 Y164.578 E.00615
G2 X163.979 Y167.024 I1.431 J1.456 E.08808
G2 X165.173 Y167.16 I.749 J-1.269 E.04106
G1 X165.828 Y166.706 E.02644
G3 X167.782 Y165.943 I1.592 J1.192 E.07332
G3 X167.217 Y167.421 I-2.009 J.079 E.05398
; COOLING_NODE: 1
; WIPE_START
G1 F8843.478
G1 X167.376 Y167.247 E-.08984
G1 X167.662 Y166.721 E-.2275
G1 X167.782 Y165.943 E-.29918
G1 X167.406 Y165.912 E-.14347
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X167.71 Y158.285 Z6.8 F60000
G1 X167.898 Y153.573 Z6.8
G1 Z6.4
G1 E.8 F1800
; FEATURE: Inner wall
G1 F1908
M204 S8000
G1 X162.702 Y153.573 E.17236
G1 X162.702 Y152.777 E.0264
G1 X167.898 Y152.777 E.17236
G1 X167.898 Y153.513 E.02441
; COOLING_NODE: 1
M204 S250
G1 X168.29 Y153.965 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1908
M204 S5000
M73 P70 R4
G1 X162.31 Y153.965 E.18375
G1 X162.31 Y152.385 E.04855
G1 X168.29 Y152.385 E.18375
G1 X168.29 Y153.905 E.04671
M204 S10000
G1 X167.694 Y153.175 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1908
M204 S8000
G1 X162.906 Y153.175 E.15172
; COOLING_NODE: 0
; WIPE_START
G1 F9259.259
G1 X164.906 Y153.175 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.173 Y157.531 Z6.8 F60000
G1 X182.057 Y165.095 Z6.8
G1 Z6.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1908
M204 S8000
G3 X184.279 Y163.642 I2.194 J.93 E.0934
G1 X184.371 Y163.645 E.00306
G3 X182.034 Y165.15 I-.12 J2.38 E.39821
; COOLING_NODE: 0
M204 S10000
G1 X181.687 Y164.923 F60000
G1 F1908
M204 S8000
G1 X181.811 Y164.673 E.00927
G3 X184.283 Y163.235 I2.441 J1.352 E.09961
G1 X184.393 Y163.238 E.00366
G3 X181.665 Y164.979 I-.142 J2.786 E.46699
; COOLING_NODE: 0
M204 S10000
G1 X181.321 Y164.745 F60000
G1 F1908
M204 S8000
G1 X181.455 Y164.476 E.00998
G3 X184.287 Y162.828 I2.797 J1.549 E.11411
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X184.416 Y162.832 E.00426
G3 X181.299 Y164.801 I-.163 J3.193 E.53603
; COOLING_NODE: 0
M204 S250
G1 X180.969 Y164.573 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1908
M204 S5000
G1 X181.113 Y164.286 E.00987
G3 X184.291 Y162.435 I3.14 J1.739 E.11864
G1 X184.437 Y162.44 E.00449
G3 X180.946 Y164.629 I-.184 J3.585 E.55811
; WIPE_START
G1 F9547.055
M204 S8000
G1 X181.113 Y164.286 E-.14486
G1 X181.31 Y163.965 E-.14307
G1 X181.5 Y163.717 E-.11875
G1 X181.756 Y163.443 E-.14268
G1 X182.04 Y163.196 E-.14271
G1 X182.185 Y163.092 E-.06793
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X182.679 Y164.736 Z6.8 F60000
G1 Z6.4
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F1908
M204 S8000
G3 X184.084 Y164.006 I1.812 J1.769 E.05341
G2 X184.827 Y164.539 I2.514 J-2.722 E.03043
G1 X185.483 Y164.593 E.02181
G1 X185.628 Y164.542 E.00511
G3 X185.918 Y167.178 I-1.354 J1.483 E.09608
G1 X185.483 Y167.214 E.01449
G1 X184.827 Y166.983 E.02304
G2 X183.517 Y165.943 I-4.835 J4.747 E.05563
G2 X182.227 Y166.113 I-.456 J1.528 E.04446
G2 X182.906 Y167.54 I2.037 J-.094 E.05383
; COOLING_NODE: 1
; WIPE_START
G1 F8843.478
G1 X182.714 Y167.358 E-.10028
G1 X182.391 Y166.853 E-.228
G1 X182.227 Y166.113 E-.28796
G1 X182.584 Y165.987 E-.14376
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X182.288 Y158.361 Z6.8 F60000
G1 X182.102 Y153.573 Z6.8
G1 Z6.4
G1 E.8 F1800
; FEATURE: Inner wall
G1 F1908
M204 S8000
G1 X182.102 Y152.777 E.0264
G1 X187.298 Y152.777 E.17236
G1 X187.298 Y153.573 E.0264
G1 X182.162 Y153.573 E.17037
; COOLING_NODE: 1
M204 S250
G1 X181.71 Y153.965 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1908
M204 S5000
G1 X181.71 Y152.385 E.04855
G1 X187.69 Y152.385 E.18375
G1 X187.69 Y153.965 E.04855
G1 X181.77 Y153.965 E.18191
M204 S10000
G1 X182.306 Y153.175 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1908
M204 S8000
G1 X187.094 Y153.175 E.15172
; CHANGE_LAYER
; Z_HEIGHT: 6.40952
; LAYER_HEIGHT: 0.00952387
; WIPE_START
G1 F9259.259
G1 X185.094 Y153.175 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 44/85
; update layer progress
M73 L44
M991 S0 P43 ;notify layer change

; OBJECT_ID: 15
M204 S10000
G17
G3 Z6.8 I-.062 J-1.215 P1  F60000
G1 X169.095 Y153.987 Z6.8
G1 Z6.41
G1 E.8 F1800
; FEATURE: Support
; LINE_WIDTH: 0.42
; LAYER_HEIGHT: 0.27619
G1 F2142
M204 S8000
G1 X180.961 Y153.987 E.48169
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X180.961 Y152.363 E.06589
G1 X169.039 Y152.363 E.48399
G1 X169.039 Y153.987 E.06589
; CHANGE_LAYER
; Z_HEIGHT: 6.6
; LAYER_HEIGHT: 0.190476
; WIPE_START
G1 F7226.745
G1 X169.039 Y152.363 E-.61679
G1 X169.415 Y152.363 E-.14321
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 45/85
; update layer progress
M73 L45
M991 S0 P44 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z6.81 I-1.211 J-.117 P1  F60000
G1 X168.114 Y165.834 Z6.81
G1 Z6.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
; LAYER_HEIGHT: 0.2
G1 F2142
M204 S8000
G1 X168.134 Y166.067 E.00774
G3 X165.787 Y163.642 I-2.383 J-.042 E.37229
G1 X165.87 Y163.645 E.00276
G3 X168.097 Y165.605 I-.119 J2.38 E.10623
G1 X168.11 Y165.774 E.00564
; COOLING_NODE: 0
M204 S10000
G1 X168.534 Y165.823 F60000
G1 F2142
M204 S8000
G3 X165.791 Y163.235 I-2.783 J.202 E.44416
G1 X165.893 Y163.238 E.00336
G3 X168.529 Y165.763 I-.141 J2.787 E.13202
; COOLING_NODE: 0
M204 S10000
G1 X168.941 Y165.792 F60000
G1 F2142
M204 S8000
G3 X165.796 Y162.828 I-3.189 J.233 E.50896
G1 X165.915 Y162.831 E.00397
G3 X168.936 Y165.732 I-.163 J3.193 E.15148
; COOLING_NODE: 0
M204 S250
G1 X169.329 Y165.748 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1949
M204 S5000
G1 X169.332 Y165.762 E.00044
G3 X165.8 Y162.436 I-3.58 J.262 E.52927
G1 X165.937 Y162.44 E.00421
G3 X169.287 Y165.4 I-.184 J3.585 E.1483
G1 X169.321 Y165.689 E.00893
; WIPE_START
G1 F9547.055
M204 S8000
G1 X169.332 Y165.762 E-.02818
G1 X169.339 Y166.088 E-.12388
G1 X169.313 Y166.463 E-.14272
G1 X169.262 Y166.771 E-.11859
G1 X169.164 Y167.135 E-.14322
G1 X169.034 Y167.474 E-.13808
G1 X168.958 Y167.628 E-.06533
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X167.246 Y164.654 Z7 F60000
G1 Z6.6
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F2142
M204 S8000
G2 X165.806 Y163.996 I-1.527 J1.437 E.05384
G1 X165.173 Y164.473 E.0263
G1 X164.518 Y164.587 E.02206
G1 X164.362 Y164.547 E.00532
G2 X164.049 Y167.126 I1.527 J1.494 E.09265
G1 X164.518 Y167.207 E.01578
G1 X165.173 Y167.038 E.02245
G1 X165.828 Y166.503 E.02805
G3 X167.776 Y166.061 I1.282 J1.137 E.07074
G3 X167.137 Y167.509 I-2.246 J-.126 E.05365
; COOLING_NODE: 1
; WIPE_START
G1 F8843.478
G1 X167.577 Y166.92 E-.27933
G1 X167.714 Y166.552 E-.14949
G1 X167.776 Y166.061 E-.18788
G1 X167.411 Y165.966 E-.1433
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X167.711 Y158.34 Z7 F60000
G1 X167.898 Y153.573 Z7
G1 Z6.6
G1 E.8 F1800
; FEATURE: Inner wall
G1 F2142
M204 S8000
G1 X162.702 Y153.573 E.17236
G1 X162.702 Y152.777 E.0264
G1 X167.898 Y152.777 E.17236
G1 X167.898 Y153.513 E.02441
; COOLING_NODE: 1
M204 S250
G1 X168.29 Y153.965 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2078
M204 S5000
G1 X162.31 Y153.965 E.18375
G1 X162.31 Y152.385 E.04855
G1 X168.29 Y152.385 E.18375
G1 X168.29 Y153.905 E.04671
M204 S10000
M73 P71 R4
G1 X167.694 Y153.175 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F2142
M204 S8000
G1 X162.906 Y153.175 E.15172
; COOLING_NODE: 0
; WIPE_START
G1 F9259.259
G1 X164.906 Y153.175 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.181 Y157.52 Z7 F60000
G1 X182.072 Y165.061 Z7
G1 Z6.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2142
M204 S8000
G3 X184.287 Y163.642 I2.179 J.964 E.09243
G1 X184.37 Y163.645 E.00276
G3 X182.048 Y165.116 I-.119 J2.38 E.3995
; COOLING_NODE: 0
M204 S10000
G1 X181.699 Y164.897 F60000
G1 F2142
M204 S8000
G3 X184.291 Y163.235 I2.552 J1.127 E.1082
G1 X184.393 Y163.238 E.00336
G3 X181.676 Y164.953 I-.141 J2.787 E.46798
; COOLING_NODE: 0
M204 S10000
G1 X181.326 Y164.73 F60000
G1 F2142
M204 S8000
G1 X181.455 Y164.475 E.00947
G3 X184.296 Y162.828 I2.797 J1.549 E.11439
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X184.415 Y162.831 E.00397
G3 X181.305 Y164.785 I-.163 J3.193 E.5366
; COOLING_NODE: 0
M204 S250
G1 X180.976 Y164.556 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1949
M204 S5000
G1 X181.113 Y164.285 E.00931
G3 X184.3 Y162.436 I3.14 J1.739 E.11892
G1 X184.437 Y162.44 E.00421
G3 X180.953 Y164.611 I-.184 J3.585 E.55871
; WIPE_START
G1 F9547.055
M204 S8000
G1 X181.113 Y164.285 E-.1378
G1 X181.309 Y163.966 E-.14261
G1 X181.5 Y163.718 E-.11876
G1 X181.756 Y163.443 E-.1429
G1 X182.04 Y163.196 E-.14282
G1 X182.201 Y163.081 E-.07511
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X182.837 Y164.573 Z7 F60000
G1 Z6.6
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F2142
M204 S8000
G3 X184.311 Y163.996 I1.435 J1.494 E.05389
G2 X185.645 Y164.559 I1.288 J-1.191 E.04952
G3 X185.991 Y167.076 I-1.412 J1.476 E.09096
G3 X184.172 Y166.6 I-.561 J-1.568 E.06625
G1 X183.517 Y166.065 E.02805
G2 X182.225 Y166.006 I-.711 J1.396 E.04423
G2 X182.829 Y167.467 I2.036 J.013 E.05383
; COOLING_NODE: 1
; WIPE_START
G1 F8843.478
G1 X182.391 Y166.852 E-.28658
G1 X182.232 Y166.272 E-.22869
G1 X182.225 Y166.006 E-.10097
G1 X182.598 Y165.942 E-.14376
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X182.292 Y158.315 Z7 F60000
G1 X182.102 Y153.573 Z7
G1 Z6.6
G1 E.8 F1800
; FEATURE: Inner wall
G1 F2142
M204 S8000
G1 X182.102 Y152.777 E.0264
G1 X187.298 Y152.777 E.17236
G1 X187.298 Y153.573 E.0264
G1 X182.162 Y153.573 E.17037
; COOLING_NODE: 1
M204 S250
G1 X181.71 Y153.965 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2078
M204 S5000
G1 X181.71 Y152.385 E.04855
G1 X187.69 Y152.385 E.18375
G1 X187.69 Y153.965 E.04855
G1 X181.77 Y153.965 E.18191
M204 S10000
G1 X182.306 Y153.175 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F2142
M204 S8000
G1 X187.094 Y153.175 E.15172
; CHANGE_LAYER
; Z_HEIGHT: 6.68571
; LAYER_HEIGHT: 0.0857143
; WIPE_START
G1 F9259.259
G1 X185.094 Y153.175 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 46/85
; update layer progress
M73 L46
M991 S0 P45 ;notify layer change

; OBJECT_ID: 15
M204 S10000
G17
G3 Z7 I-.062 J-1.215 P1  F60000
G1 X169.095 Y153.987 Z7
G1 Z6.686
G1 E.8 F1800
; FEATURE: Support
; LINE_WIDTH: 0.42
; LAYER_HEIGHT: 0.27619
G1 F2133
M204 S8000
G1 X180.961 Y153.987 E.48169
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X180.961 Y152.363 E.06589
G1 X169.039 Y152.363 E.48399
G1 X169.039 Y153.987 E.06589
; CHANGE_LAYER
; Z_HEIGHT: 6.8
; LAYER_HEIGHT: 0.114286
; WIPE_START
G1 F7226.745
G1 X169.039 Y152.363 E-.61679
G1 X169.415 Y152.363 E-.14321
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 47/85
; update layer progress
M73 L47
M991 S0 P46 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z7.086 I-1.211 J-.117 P1  F60000
G1 X168.115 Y165.84 Z7.086
G1 Z6.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
; LAYER_HEIGHT: 0.2
G1 F2133
M204 S8000
G1 X168.132 Y166.061 E.00734
G3 X165.795 Y163.642 I-2.381 J-.037 E.37254
G1 X165.869 Y163.645 E.00245
G3 X168.095 Y165.605 I-.118 J2.379 E.10624
G1 X168.11 Y165.78 E.00582
; COOLING_NODE: 0
M204 S10000
G1 X168.533 Y165.83 F60000
G1 F2133
M204 S8000
G3 X165.8 Y163.235 I-2.782 J.193 E.44395
G1 X165.892 Y163.238 E.00305
G3 X168.528 Y165.771 I-.141 J2.785 E.13223
; COOLING_NODE: 0
M204 S10000
G1 X168.94 Y165.799 F60000
G1 F2133
M204 S8000
G1 X168.939 Y165.802 E.00011
G3 X165.805 Y162.828 I-3.188 J.221 E.50866
G1 X165.915 Y162.831 E.00364
G3 X168.898 Y165.467 I-.164 J3.191 E.14254
G1 X168.932 Y165.739 E.00909
; COOLING_NODE: 0
M204 S250
G1 X169.328 Y165.751 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1938
M204 S5000
G1 X169.33 Y165.774 E.00073
G3 X165.81 Y162.436 I-3.579 J.248 E.52891
G1 X165.937 Y162.44 E.0039
G3 X169.284 Y165.401 I-.186 J3.583 E.14824
G1 X169.321 Y165.691 E.00899
; WIPE_START
G1 F9547.055
M204 S8000
G1 X169.33 Y165.774 E-.03176
G1 X169.339 Y166.087 E-.11885
G1 X169.314 Y166.46 E-.14204
G1 X169.262 Y166.771 E-.11987
G1 X169.183 Y167.074 E-.11878
G1 X169.054 Y167.428 E-.14331
G1 X168.956 Y167.63 E-.08539
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X167.381 Y164.81 Z7.2 F60000
G1 Z6.8
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F2133
M204 S8000
G2 X166.012 Y164.01 I-1.637 J1.228 E.054
G3 X165.173 Y164.608 I-1.692 J-1.483 E.03452
G1 X164.518 Y164.605 E.02173
G1 X164.369 Y164.539 E.00538
G2 X164.122 Y167.228 I1.358 J1.481 E.09819
G1 X164.518 Y167.226 E.01314
G1 X165.173 Y166.937 E.02375
G3 X166.155 Y166.012 I6.982 J6.435 E.0448
G3 X167.778 Y166.16 I.673 J1.595 E.05629
G3 X167.063 Y167.575 I-2.033 J-.139 E.05403
; COOLING_NODE: 1
; WIPE_START
G1 F8843.478
G1 X167.358 Y167.271 E-.16089
G1 X167.575 Y166.924 E-.15579
G1 X167.778 Y166.16 E-.30024
G1 X167.434 Y166.008 E-.14309
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X167.719 Y158.381 Z7.2 F60000
G1 X167.898 Y153.573 Z7.2
G1 Z6.8
G1 E.8 F1800
; FEATURE: Inner wall
G1 F2133
M204 S8000
G1 X162.702 Y153.573 E.17236
G1 X162.702 Y152.777 E.0264
G1 X167.898 Y152.777 E.17236
G1 X167.898 Y153.513 E.02441
; COOLING_NODE: 1
M204 S250
G1 X168.29 Y153.965 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2087
M204 S5000
G1 X162.31 Y153.965 E.18375
G1 X162.31 Y152.385 E.04855
G1 X168.29 Y152.385 E.18375
G1 X168.29 Y153.905 E.04671
M204 S10000
G1 X167.694 Y153.175 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F2133
M204 S8000
G1 X162.906 Y153.175 E.15172
; COOLING_NODE: 0
; WIPE_START
G1 F9259.259
G1 X164.906 Y153.175 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.182 Y157.518 Z7.2 F60000
G1 X182.074 Y165.057 Z7.2
G1 Z6.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
M73 P72 R4
G1 F2133
M204 S8000
G1 X182.167 Y164.87 E.00691
G3 X184.295 Y163.642 I2.084 J1.153 E.08565
G1 X184.369 Y163.645 E.00245
G3 X182.05 Y165.112 I-.118 J2.379 E.39942
; COOLING_NODE: 0
M204 S10000
G1 X181.709 Y164.879 F60000
G1 F2133
M204 S8000
G1 X181.811 Y164.673 E.00762
G3 X184.3 Y163.235 I2.44 J1.35 E.10019
G1 X184.392 Y163.238 E.00305
G3 X181.683 Y164.935 I-.141 J2.785 E.46832
G1 X181.684 Y164.933 E.00006
; COOLING_NODE: 0
M204 S10000
G1 X181.343 Y164.7 F60000
G1 F2133
M204 S8000
G1 X181.455 Y164.476 E.00832
G3 X184.305 Y162.828 I2.796 J1.547 E.11473
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X184.415 Y162.831 E.00364
G3 X181.309 Y164.776 I-.164 J3.191 E.53658
G1 X181.318 Y164.755 E.00077
; COOLING_NODE: 0
M204 S250
G1 X180.991 Y164.528 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1938
M204 S5000
G1 X181.112 Y164.286 E.00833
G3 X184.31 Y162.436 I3.139 J1.737 E.11926
G1 X184.437 Y162.44 E.0039
G3 X180.948 Y164.623 I-.186 J3.583 E.55793
G1 X180.966 Y164.583 E.00135
; WIPE_START
G1 F9547.055
M204 S8000
G1 X181.112 Y164.286 E-.12583
G1 X181.308 Y163.968 E-.14167
G1 X181.5 Y163.717 E-.12027
G1 X181.757 Y163.442 E-.14284
G1 X181.99 Y163.235 E-.1186
G1 X182.226 Y163.064 E-.11078
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X182.988 Y164.432 Z7.2 F60000
G1 Z6.8
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F2133
M204 S8000
G3 X184.517 Y164.01 I1.425 J2.18 E.05345
G1 X184.827 Y164.316 E.01446
G1 X185.483 Y164.605 E.02375
G3 X185.896 Y164.829 I.081 J.344 E.01705
G3 X186.045 Y166.977 I-1.931 J1.214 E.07441
G3 X184.172 Y166.812 I-.842 J-1.148 E.06813
G1 X183.517 Y166.167 E.0305
G2 X182.221 Y165.883 I-1.089 J1.871 E.04471
G2 X182.733 Y167.376 I2.139 J.101 E.0536
; COOLING_NODE: 1
; WIPE_START
G1 F8843.478
G1 X182.485 Y167.036 E-.1598
G1 X182.318 Y166.661 E-.15598
G1 X182.221 Y165.883 E-.29791
G1 X182.607 Y165.88 E-.14632
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X182.294 Y158.254 Z7.2 F60000
G1 X182.102 Y153.573 Z7.2
G1 Z6.8
G1 E.8 F1800
; FEATURE: Inner wall
G1 F2133
M204 S8000
G1 X182.102 Y152.777 E.0264
G1 X187.298 Y152.777 E.17236
G1 X187.298 Y153.573 E.0264
G1 X182.162 Y153.573 E.17037
; COOLING_NODE: 1
M204 S250
G1 X181.71 Y153.965 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2087
M204 S5000
G1 X181.71 Y152.385 E.04855
G1 X187.69 Y152.385 E.18375
G1 X187.69 Y153.965 E.04855
G1 X181.77 Y153.965 E.18191
M204 S10000
G1 X182.306 Y153.175 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F2133
M204 S8000
G1 X187.094 Y153.175 E.15172
; CHANGE_LAYER
; Z_HEIGHT: 6.9619
; LAYER_HEIGHT: 0.161904
; WIPE_START
G1 F9259.259
G1 X185.094 Y153.175 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 48/85
; update layer progress
M73 L48
M991 S0 P47 ;notify layer change

; OBJECT_ID: 15
M204 S10000
G17
G3 Z7.2 I-.062 J-1.215 P1  F60000
G1 X169.095 Y153.987 Z7.2
G1 Z6.962
G1 E.8 F1800
; FEATURE: Support
; LINE_WIDTH: 0.42
; LAYER_HEIGHT: 0.27619
G1 F2286
M204 S8000
G1 X180.961 Y153.987 E.48169
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X180.961 Y152.363 E.06589
G1 X169.039 Y152.363 E.48399
G1 X169.039 Y153.987 E.06589
; CHANGE_LAYER
; Z_HEIGHT: 7
; LAYER_HEIGHT: 0.0380955
; WIPE_START
G1 F7226.745
G1 X169.039 Y152.363 E-.61679
G1 X169.415 Y152.363 E-.14321
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 49/85
; update layer progress
M73 L49
M991 S0 P48 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z7.362 I-1.211 J-.117 P1  F60000
G1 X168.114 Y165.791 Z7.362
G1 Z7
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
; LAYER_HEIGHT: 0.2
G1 F2286
M204 S8000
G1 X168.128 Y166.149 E.01188
G3 X165.749 Y163.642 I-2.38 J-.125 E.36839
G1 X165.874 Y163.645 E.00416
G3 X168.108 Y165.694 I-.126 J2.38 E.10897
G1 X168.11 Y165.731 E.00126
; COOLING_NODE: 0
M204 S10000
G1 X168.532 Y165.827 F60000
G1 F2286
M204 S8000
G1 X168.535 Y165.874 E.00158
G3 X165.751 Y163.234 I-2.786 J.15 E.44119
G1 X165.896 Y163.238 E.0048
G3 X168.512 Y165.637 I-.147 J2.786 E.1276
G1 X168.526 Y165.767 E.00435
; COOLING_NODE: 0
M204 S10000
G1 X168.937 Y165.787 F60000
G1 F2286
M204 S8000
G1 X168.942 Y165.855 E.00226
G3 X165.753 Y162.827 I-3.193 J.17 E.50552
G1 X165.917 Y162.832 E.00545
G3 X168.916 Y165.58 I-.167 J3.193 E.14625
G1 X168.931 Y165.727 E.00491
; COOLING_NODE: 0
M204 S250
G1 X169.327 Y165.749 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1931
M204 S5000
G1 X169.335 Y165.836 E.00268
G3 X165.755 Y162.435 I-3.584 J.189 E.52566
G1 X165.938 Y162.44 E.00561
G3 X169.305 Y165.525 I-.187 J3.584 E.1521
G1 X169.321 Y165.689 E.00507
; WIPE_START
G1 F9547.055
M204 S8000
G1 X169.335 Y165.836 E-.05594
G1 X169.335 Y166.212 E-.1431
G1 X169.296 Y166.587 E-.14326
G1 X169.233 Y166.893 E-.11864
G1 X169.124 Y167.252 E-.14274
G1 X168.976 Y167.6 E-.14333
G1 X168.96 Y167.63 E-.013
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X166.106 Y167.641 Z7.4 F60000
G1 Z7
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F2286
M204 S8000
G3 X164.601 Y167.216 I-.34 J-1.673 E.05387
G1 X165.173 Y166.85 E.02252
G1 X165.828 Y166.019 E.0351
G3 X166.483 Y165.701 I.635 J.473 E.02511
G1 X167.138 Y165.833 E.02217
G1 X167.397 Y166 E.01021
G2 X165.896 Y164.377 I-1.642 J.013 E.08044
G3 X164.759 Y164.698 I-.765 J-.532 E.04246
G2 X164.105 Y166.114 I1.052 J1.345 E.05374
M204 S10000
G1 X164.546 Y164.407 F60000
; FEATURE: Floating vertical shell
; LINE_WIDTH: 0.38292
G1 F2286
M204 S8000
G1 X164.158 Y164.789 E.01507
G1 X163.863 Y165.313 E.01667
G1 X163.742 Y165.924 E.01727
G1 X163.756 Y166.334 E.01137
G1 X163.867 Y166.746 E.0118
G1 X164.105 Y167.193 E.01403
G1 X164.417 Y167.539 E.01291
G1 X164.859 Y167.832 E.01469
G1 X165.278 Y167.987 E.01237
G1 X165.697 Y168.038 E.01171
G1 X166.216 Y167.987 E.01445
G1 X166.759 Y167.77 E.0162
G1 X167.231 Y167.39 E.01678
G1 X167.548 Y166.918 E.01575
G2 X167.764 Y166.107 I-1.962 J-.957 E.02339
G2 X167.709 Y165.536 I-7.282 J.41 E.0159
G1 X167.506 Y165.033 E.01504
G1 X167.232 Y164.658 E.01285
G1 X166.808 Y164.308 E.01524
G1 X166.289 Y164.081 E.01569
G1 X165.848 Y164.009 E.01239
G1 X165.403 Y164.042 E.01236
G2 X164.599 Y164.379 I.447 J2.197 E.02432
; COOLING_NODE: 1
; WIPE_START
G1 F10588.235
G1 X164.969 Y164.177 E-.16005
G1 X165.403 Y164.042 E-.17302
G1 X165.848 Y164.009 E-.16949
G1 X166.289 Y164.081 E-.16997
G1 X166.5 Y164.173 E-.08748
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X167.498 Y156.607 Z7.4 F60000
G1 X167.898 Y153.573 Z7.4
G1 Z7
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2286
M204 S8000
G1 X162.702 Y153.573 E.17236
G1 X162.702 Y152.777 E.0264
G1 X167.898 Y152.777 E.17236
G1 X167.898 Y153.513 E.02441
; COOLING_NODE: 1
M204 S250
G1 X168.29 Y153.965 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2100
M204 S5000
G1 X162.31 Y153.965 E.18375
G1 X162.31 Y152.385 E.04855
G1 X168.29 Y152.385 E.18375
G1 X168.29 Y153.905 E.04671
M204 S10000
G1 X167.694 Y153.175 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F2286
M204 S8000
G1 X162.906 Y153.175 E.15172
; COOLING_NODE: 0
; WIPE_START
G1 F9259.259
G1 X164.906 Y153.175 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.173 Y157.531 Z7.4 F60000
G1 X182.055 Y165.093 Z7.4
G1 Z7
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2286
M204 S8000
G3 X184.249 Y163.642 I2.193 J.932 E.09245
G1 X184.374 Y163.645 E.00416
G3 X182.032 Y165.148 I-.126 J2.38 E.39807
; COOLING_NODE: 0
M204 S10000
G1 X181.741 Y164.802 F60000
G1 F2286
M204 S8000
G3 X184.251 Y163.234 I2.508 J1.223 E.10346
M73 P73 R4
G1 X184.396 Y163.238 E.0048
G3 X181.715 Y164.856 I-.147 J2.786 E.47127
; COOLING_NODE: 0
M204 S10000
G1 X181.376 Y164.623 F60000
G1 F2286
M204 S8000
G3 X184.253 Y162.827 I2.874 J1.401 E.1186
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X184.417 Y162.832 E.00545
G3 X181.35 Y164.678 I-.167 J3.193 E.54034
; COOLING_NODE: 0
M204 S250
G1 X181.018 Y164.464 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1931
M204 S5000
G1 X181.024 Y164.452 E.00042
G3 X184.255 Y162.435 I3.227 J1.572 E.12337
G1 X184.438 Y162.44 E.00561
G3 X180.877 Y164.798 I-.187 J3.584 E.55244
G1 X180.995 Y164.52 E.00928
; WIPE_START
G1 F9547.055
M204 S8000
G1 X181.024 Y164.452 E-.02798
G1 X181.206 Y164.122 E-.14325
G1 X181.383 Y163.864 E-.11901
G1 X181.582 Y163.623 E-.11877
G1 X181.848 Y163.357 E-.14263
G1 X182.283 Y163.023 E-.20836
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X183.544 Y164.527 Z7.4 F60000
G1 Z7
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F2286
M204 S8000
G2 X182.612 Y165.783 I.712 J1.502 E.05402
G1 X182.862 Y165.833 E.00847
G1 X183.517 Y166.254 E.02582
G1 X184.172 Y167.084 E.0351
G2 X185.285 Y167.31 I.712 J-.653 E.04026
G2 X185.898 Y165.874 I-1.05 J-1.297 E.05388
M204 S10000
G1 X186.055 Y166.92 F60000
; FEATURE: Floating vertical shell
; LINE_WIDTH: 0.38292
G1 F2286
M204 S8000
G1 X186.211 Y166.49 E.0127
G2 X186.266 Y165.919 I-7.419 J-1.003 E.01589
G1 X186.153 Y165.361 E.01578
G1 X185.891 Y164.859 E.01569
G1 X185.577 Y164.519 E.01283
G1 X185.126 Y164.216 E.01503
G1 X184.586 Y164.04 E.01574
G1 X184.344 Y164.009 E.00677
G1 X183.786 Y164.066 E.01554
G1 X183.262 Y164.276 E.01562
G1 X182.886 Y164.551 E.01292
G1 X182.615 Y164.849 E.01116
G1 X182.363 Y165.314 E.01467
G1 X182.242 Y165.92 E.01711
G1 X182.296 Y166.513 E.01648
G1 X182.511 Y167.036 E.01568
G1 X182.748 Y167.367 E.01127
G1 X183.215 Y167.748 E.01671
G1 X183.769 Y167.976 E.01658
G1 X184.141 Y168.033 E.01043
G1 X184.737 Y167.979 E.0166
G1 X185.289 Y167.754 E.01652
G1 X185.734 Y167.391 E.0159
G1 X186.021 Y166.97 E.01412
; COOLING_NODE: 1
; WIPE_START
G1 F10588.235
G1 X185.734 Y167.391 E-.19368
G1 X185.289 Y167.754 E-.21809
G1 X184.737 Y167.979 E-.22652
G1 X184.418 Y168.008 E-.12172
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X183.209 Y160.472 Z7.4 F60000
G1 X182.102 Y153.573 Z7.4
G1 Z7
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2286
M204 S8000
G1 X182.102 Y152.777 E.0264
G1 X187.298 Y152.777 E.17236
G1 X187.298 Y153.573 E.0264
G1 X182.162 Y153.573 E.17037
; COOLING_NODE: 1
M204 S250
G1 X181.71 Y153.965 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2100
M204 S5000
G1 X181.71 Y152.385 E.04855
G1 X187.69 Y152.385 E.18375
G1 X187.69 Y153.965 E.04855
G1 X181.77 Y153.965 E.18191
M204 S10000
G1 X182.306 Y153.175 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F2286
M204 S8000
G1 X187.094 Y153.175 E.15172
; CHANGE_LAYER
; Z_HEIGHT: 7.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.259
G1 X185.094 Y153.175 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 50/85
; update layer progress
M73 L50
M991 S0 P49 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z7.4 I-.726 J-.977 P1  F60000
G1 X168.115 Y165.796 Z7.4
G1 Z7.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2071
M204 S8000
G1 X168.128 Y166.149 E.01174
G3 X165.756 Y163.642 I-2.379 J-.125 E.36848
G1 X165.873 Y163.645 E.00388
G3 X168.108 Y165.694 I-.124 J2.379 E.10901
G1 X168.111 Y165.736 E.0014
; COOLING_NODE: 0
M204 S10000
G1 X168.531 Y165.827 F60000
G1 F2071
M204 S8000
G1 X168.536 Y165.888 E.00202
G3 X165.759 Y163.234 I-2.786 J.136 E.44082
G1 X165.895 Y163.238 E.00451
G3 X168.512 Y165.637 I-.145 J2.786 E.12765
G1 X168.525 Y165.768 E.00437
; COOLING_NODE: 0
M204 S10000
G1 X168.936 Y165.789 F60000
G1 F2071
M204 S8000
G1 X168.944 Y165.869 E.00269
G3 X165.762 Y162.827 I-3.193 J.154 E.50511
G1 X165.917 Y162.832 E.00513
G3 X168.916 Y165.58 I-.166 J3.192 E.14628
G1 X168.931 Y165.729 E.00498
; COOLING_NODE: 0
M204 S250
G1 X169.326 Y165.752 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1925
M204 S5000
G1 X169.336 Y165.851 E.00307
G3 X165.764 Y162.435 I-3.584 J.172 E.52525
G1 X165.937 Y162.44 E.00532
G3 X169.305 Y165.525 I-.186 J3.583 E.15211
G1 X169.321 Y165.692 E.00516
; WIPE_START
G1 F9547.055
M204 S8000
G1 X169.336 Y165.851 E-.06079
G1 X169.335 Y166.212 E-.13717
G1 X169.296 Y166.587 E-.14306
G1 X169.233 Y166.894 E-.11893
G1 X169.124 Y167.253 E-.14266
G1 X168.976 Y167.599 E-.1432
G1 X168.958 Y167.632 E-.01419
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X167.504 Y167.375 Z7.6 F60000
G1 Z7.2
G1 E.8 F1800
; FEATURE: Bridge
; LINE_WIDTH: 0.44688
; LAYER_HEIGHT: 0.4
G1 F3000
M204 S8000
G1 X167.759 Y166.119 E.08189
G2 X167.479 Y164.997 I-2.036 J-.089 E.07497
G1 X166.945 Y167.632 E.17182
G3 X166.377 Y167.934 I-.973 J-1.142 E.04147
G1 X167.071 Y164.508 E.22341
G2 X166.623 Y164.215 I-1.953 J2.492 E.03424
G1 X165.851 Y168.027 E.24859
G3 X165.351 Y167.995 I-.14 J-1.743 E.03216
G1 X166.149 Y164.055 E.25695
G2 X165.648 Y164.025 I-.35 J1.657 E.03219
G1 X164.876 Y167.838 E.24861
G1 X164.7 Y167.73 E.01321
G3 X164.431 Y167.533 I.37 J-.788 E.02144
G1 X165.123 Y164.116 E.22281
G1 X165.098 Y164.122 E.0016
G2 X164.557 Y164.404 I.812 J2.214 E.03912
G1 X164.021 Y167.052 E.17266
G3 X163.74 Y165.937 I1.731 J-1.029 E.07451
G1 X163.995 Y164.676 E.08226
; COOLING_NODE: 1
; WIPE_START
G1 X163.74 Y165.937 E-.48917
G1 X163.763 Y166.34 E-.15333
G1 X163.84 Y166.64 E-.11751
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X166.104 Y159.35 Z7.6 F60000
G1 X167.898 Y153.573 Z7.6
G1 Z7.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
; LAYER_HEIGHT: 0.2
G1 F2071
M204 S8000
G1 X162.702 Y153.573 E.17236
G1 X162.702 Y152.777 E.0264
G1 X167.898 Y152.777 E.17236
G1 X167.898 Y153.513 E.02441
; COOLING_NODE: 1
M204 S250
G1 X168.29 Y153.965 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2071
M204 S5000
G1 X162.31 Y153.965 E.18375
G1 X162.31 Y152.385 E.04855
G1 X168.29 Y152.385 E.18375
G1 X168.29 Y153.905 E.04671
M204 S10000
G1 X167.694 Y153.175 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F2071
M204 S8000
G1 X162.906 Y153.175 E.15172
; COOLING_NODE: 0
; WIPE_START
G1 F9259.259
G1 X164.906 Y153.175 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.182 Y157.518 Z7.6 F60000
G1 X182.079 Y165.057 Z7.6
G1 Z7.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2071
M204 S8000
G1 X182.251 Y164.726 E.01235
G3 X184.256 Y163.642 I1.998 J1.297 E.07886
G1 X184.373 Y163.645 E.00388
G3 X182.04 Y165.132 I-.124 J2.379 E.3986
G1 X182.052 Y165.11 E.00082
; COOLING_NODE: 0
M204 S10000
G1 X181.743 Y164.807 F60000
G1 F2071
M204 S8000
G1 X181.789 Y164.712 E.00349
G3 X184.259 Y163.234 I2.461 J1.312 E.10033
G1 X184.395 Y163.238 E.00451
G3 X181.663 Y164.98 I-.145 J2.786 E.4667
G1 X181.718 Y164.861 E.00433
; COOLING_NODE: 0
M204 S10000
G1 X181.375 Y164.635 F60000
G1 F2071
M204 S8000
G1 X181.429 Y164.523 E.00412
G3 X184.262 Y162.827 I2.822 J1.501 E.11508
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X184.417 Y162.832 E.00513
G3 X181.287 Y164.828 I-.166 J3.192 E.5348
G1 X181.35 Y164.689 E.00505
; COOLING_NODE: 0
M204 S250
G1 X181.02 Y164.469 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1925
M204 S5000
M73 P74 R4
G1 X181.083 Y164.34 E.00439
G3 X184.264 Y162.435 I3.169 J1.683 E.11975
G1 X184.437 Y162.44 E.00532
G3 X180.924 Y164.681 I-.186 J3.583 E.55614
G1 X180.995 Y164.523 E.00531
; WIPE_START
G1 F9547.055
M204 S8000
G1 X181.083 Y164.34 E-.07712
G1 X181.239 Y164.069 E-.11895
G1 X181.46 Y163.765 E-.14285
G1 X181.712 Y163.486 E-.14263
G1 X181.991 Y163.235 E-.14259
G1 X182.28 Y163.025 E-.13587
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X182.491 Y164.681 Z7.6 F60000
G1 Z7.2
G1 E.8 F1800
; FEATURE: Bridge
; LINE_WIDTH: 0.4468
; LAYER_HEIGHT: 0.4
G1 F3000
M204 S8000
G1 X182.239 Y165.946 E.08243
G2 X182.525 Y167.059 I2.246 J.017 E.07418
G1 X183.049 Y164.423 E.17169
G3 X183.616 Y164.117 I.986 J1.152 E.04148
G1 X182.934 Y167.546 E.22335
G2 X183.383 Y167.839 I1.21 J-1.364 E.03432
G1 X184.141 Y164.025 E.24839
G3 X184.642 Y164.053 I.156 J1.7 E.03217
G1 X183.858 Y167.997 E.25685
G2 X184.166 Y168.036 I.338 J-1.435 E.0199
G2 X184.267 Y168.031 I.035 J-.338 E.00647
G1 X184.359 Y168.025 E.00586
G1 X185.117 Y164.211 E.24841
G3 X185.566 Y164.504 I-.757 J1.652 E.03432
G1 X184.884 Y167.929 E.22315
G2 X185.45 Y167.631 I-.515 J-1.663 E.0411
G1 X185.975 Y164.991 E.17197
G3 X186.258 Y166.114 I-1.745 J1.037 E.07502
G1 X186.008 Y167.371 E.08192
; COOLING_NODE: 1
; WIPE_START
G1 X186.258 Y166.114 E-.48729
G1 X186.242 Y165.737 E-.1433
G1 X186.203 Y165.538 E-.07715
G1 X186.163 Y165.406 E-.05226
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X183.685 Y158.187 Z7.6 F60000
G1 X182.102 Y153.573 Z7.6
G1 Z7.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
; LAYER_HEIGHT: 0.2
G1 F2071
M204 S8000
G1 X182.102 Y152.777 E.0264
G1 X187.298 Y152.777 E.17236
G1 X187.298 Y153.573 E.0264
G1 X182.162 Y153.573 E.17037
; COOLING_NODE: 1
M204 S250
G1 X181.71 Y153.965 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2071
M204 S5000
G1 X181.71 Y152.385 E.04855
G1 X187.69 Y152.385 E.18375
G1 X187.69 Y153.965 E.04855
G1 X181.77 Y153.965 E.18191
M204 S10000
G1 X182.306 Y153.175 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F2071
M204 S8000
G1 X187.094 Y153.175 E.15172
; CHANGE_LAYER
; Z_HEIGHT: 7.2381
; LAYER_HEIGHT: 0.0380955
; WIPE_START
G1 F9259.259
G1 X185.094 Y153.175 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 51/85
; update layer progress
M73 L51
M991 S0 P50 ;notify layer change

; OBJECT_ID: 15
M204 S10000
G17
G3 Z7.6 I-.062 J-1.215 P1  F60000
G1 X169.095 Y153.987 Z7.6
G1 Z7.238
G1 E.8 F1800
; FEATURE: Support
; LINE_WIDTH: 0.42
; LAYER_HEIGHT: 0.27619
G1 F2555
M204 S8000
G1 X180.961 Y153.987 E.48169
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X180.961 Y152.363 E.06589
G1 X169.039 Y152.363 E.48399
G1 X169.039 Y153.987 E.06589
; CHANGE_LAYER
; Z_HEIGHT: 7.4
; LAYER_HEIGHT: 0.161905
; WIPE_START
G1 F7226.745
G1 X169.039 Y152.363 E-.61679
G1 X169.415 Y152.363 E-.14321
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 52/85
; update layer progress
M73 L52
M991 S0 P51 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z7.638 I-1.211 J-.115 P1  F60000
G1 X168.128 Y165.883 Z7.638
G1 Z7.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
; LAYER_HEIGHT: 0.2
G1 F2555
M204 S8000
G1 X168.13 Y165.901 E.0006
G3 X165.764 Y163.642 I-2.38 J.124 E.37707
G1 X165.873 Y163.645 E.0036
G3 X168.104 Y165.651 I-.122 J2.38 E.10765
G1 X168.122 Y165.823 E.00575
; COOLING_NODE: 0
M204 S10000
G1 X168.533 Y165.84 F60000
G1 F2555
M204 S8000
G1 X168.537 Y165.88 E.00131
G3 X165.768 Y163.235 I-2.786 J.145 E.44149
G1 X165.895 Y163.238 E.00422
G3 X168.507 Y165.587 I-.143 J2.786 E.12606
G1 X168.527 Y165.781 E.00644
; COOLING_NODE: 0
M204 S10000
G1 X168.934 Y165.769 F60000
G1 F2555
M204 S8000
G1 X168.947 Y166.025 E.00851
G3 X166.029 Y169.211 I-3.198 J0 E.15733
G3 X165.916 Y162.832 I-.278 J-3.186 E.34795
G3 X168.929 Y165.691 I-.168 J3.193 E.14996
G1 X168.93 Y165.709 E.00059
; COOLING_NODE: 0
M204 S250
G1 X169.327 Y165.757 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1918
M204 S5000
G1 X169.337 Y165.838 E.0025
G3 X165.774 Y162.435 I-3.584 J.187 E.52613
G1 X165.937 Y162.44 E.00503
G3 X169.298 Y165.463 I-.185 J3.585 E.15025
G1 X169.321 Y165.697 E.00722
; WIPE_START
G1 F9547.055
M204 S8000
G1 X169.337 Y165.838 E-.05371
G1 X169.335 Y166.212 E-.14246
G1 X169.296 Y166.587 E-.14299
G1 X169.233 Y166.893 E-.11892
G1 X169.123 Y167.253 E-.14302
G1 X168.977 Y167.599 E-.14261
G1 X168.956 Y167.636 E-.0163
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X167.357 Y164.867 Z7.8 F60000
G1 Z7.4
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F2555
M204 S8000
G1 X167.084 Y164.562 E.01259
G1 X166.622 Y164.237 E.01735
G2 X165.856 Y164.038 I-.87 J1.777 E.02449
G1 X165.292 Y164.098 E.01742
G1 X164.752 Y164.303 E.01775
G2 X164.141 Y164.855 I.99 J1.712 E.02548
G1 X163.881 Y165.344 E.01701
G1 X163.763 Y165.93 E.01838
G1 X163.784 Y166.329 E.01229
G1 X163.963 Y166.898 E.01832
G1 X164.272 Y167.357 E.017
G1 X164.58 Y167.634 E.01272
G1 X165.069 Y167.894 E.01701
G1 X165.646 Y168.011 E.0181
G1 X166.231 Y167.955 E.01805
G1 X166.778 Y167.727 E.01822
G1 X167.191 Y167.383 E.01651
G1 X167.446 Y167.047 E.01296
G1 X167.679 Y166.513 E.01791
G1 X167.736 Y165.921 E.01826
G1 X167.617 Y165.34 E.01822
G1 X167.386 Y164.92 E.01475
M204 S10000
G1 X167.034 Y165.064 F60000
G1 F2555
M204 S8000
G1 X166.719 Y164.739 E.01391
G1 X166.315 Y164.525 E.01404
G1 X165.834 Y164.416 E.01515
G1 X165.372 Y164.467 E.0143
G1 X164.943 Y164.631 E.0141
G1 X164.571 Y164.941 E.01489
G2 X164.24 Y165.472 I2.274 J1.784 E.01926
G1 X164.142 Y165.958 E.01522
G1 X164.158 Y166.262 E.00935
G1 X164.306 Y166.733 E.01517
G1 X164.559 Y167.108 E.01389
G1 X164.798 Y167.323 E.00987
G1 X165.197 Y167.535 E.0139
G1 X165.666 Y167.63 E.0147
G1 X166.139 Y167.585 E.01459
G1 X166.591 Y167.397 E.01506
G1 X166.938 Y167.101 E.014
G1 X167.199 Y166.729 E.01394
G2 X167.332 Y166.179 I-1.003 J-.535 E.01758
G1 X167.355 Y165.941 E.00734
G1 X167.257 Y165.461 E.01506
G1 X167.063 Y165.117 E.01214
M204 S10000
G1 X166.846 Y165.475 F60000
G1 F2555
M204 S8000
G1 X166.666 Y165.202 E.01005
G1 X166.29 Y164.918 E.01449
G1 X165.813 Y164.795 E.01512
G1 X165.349 Y164.86 E.01441
G1 X164.926 Y165.109 E.01507
G2 X164.599 Y165.6 I1.553 J1.39 E.01819
G1 X164.527 Y166.09 E.0152
G1 X164.649 Y166.567 E.01515
G1 X164.931 Y166.935 E.01422
G1 X165.326 Y167.176 E.01423
G1 X165.686 Y167.249 E.0113
G1 X166.046 Y167.215 E.01112
G1 X166.498 Y166.997 E.01541
G1 X166.734 Y166.766 E.01013
G1 X166.937 Y166.345 E.01437
G1 X166.975 Y165.961 E.01184
G1 X166.861 Y165.533 E.01362
M204 S10000
G1 X166.447 Y165.54 F60000
G1 F2555
M204 S8000
G1 X166.263 Y165.344 E.00826
G1 X165.974 Y165.202 E.00989
G1 X165.632 Y165.18 E.01054
G1 X165.325 Y165.285 E.00996
G1 X165.075 Y165.508 E.01029
G1 X164.934 Y165.848 E.0113
G1 X164.906 Y166.127 E.00861
G1 X165.058 Y166.5 E.01238
G1 X165.233 Y166.7 E.00818
G1 X165.585 Y166.844 E.01166
G1 X165.954 Y166.845 E.01136
G1 X166.319 Y166.66 E.01257
G1 X166.516 Y166.4 E.01001
G1 X166.582 Y166.106 E.00926
G1 X166.551 Y165.773 E.01026
G1 X166.472 Y165.595 E.00602
M204 S10000
G1 X166.165 Y165.799 F60000
G1 F2555
M204 S8000
G1 X165.993 Y165.62 E.00765
G1 X165.77 Y165.552 E.00715
G1 X165.516 Y165.613 E.00803
G1 X165.352 Y165.79 E.00742
G1 X165.283 Y166.068 E.00879
G1 X165.419 Y166.36 E.00992
G1 X165.659 Y166.474 E.00817
G1 X165.862 Y166.475 E.00622
G1 X166.105 Y166.337 E.00858
G1 X166.199 Y166.142 E.00665
G2 X166.174 Y165.859 I-.573 J-.092 E.00883
M204 S10000
G1 X165.784 Y165.967 F60000
; LINE_WIDTH: 0.58246
G1 F2555
M204 S8000
G2 X165.788 Y166.077 I-.029 J.056 E.01161
; COOLING_NODE: 1
; WIPE_START
G1 F6672.351
G1 X165.716 Y166.084 E-.19836
G1 X165.683 Y166.025 E-.18721
G1 X165.716 Y165.967 E-.18721
G1 X165.784 Y165.967 E-.18722
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X167.067 Y158.443 Z7.8 F60000
G1 X167.898 Y153.573 Z7.8
G1 Z7.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2555
M204 S8000
G1 X162.702 Y153.573 E.17236
G1 X162.702 Y152.777 E.0264
G1 X167.898 Y152.777 E.17236
G1 X167.898 Y153.513 E.02441
; COOLING_NODE: 1
M204 S250
G1 X168.29 Y153.965 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2127
M204 S5000
G1 X162.31 Y153.965 E.18375
G1 X162.31 Y152.385 E.04855
G1 X168.29 Y152.385 E.18375
G1 X168.29 Y153.905 E.04671
M204 S10000
G1 X167.694 Y153.175 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F2555
M204 S8000
G1 X162.906 Y153.175 E.15172
; COOLING_NODE: 0
; WIPE_START
G1 F9259.259
G1 X164.906 Y153.175 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.199 Y157.493 Z7.8 F60000
G1 X182.11 Y164.977 Z7.8
G1 Z7.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2555
M204 S8000
G3 X184.264 Y163.642 I2.141 J1.047 E.08866
G1 X184.373 Y163.645 E.0036
G3 X182.084 Y165.032 I-.122 J2.38 E.40241
; COOLING_NODE: 0
M204 S10000
G1 X181.744 Y164.8 F60000
G1 F2555
M204 S8000
G3 X184.268 Y163.235 I2.507 J1.224 E.10387
G1 X184.395 Y163.238 E.00422
G3 X181.718 Y164.854 I-.143 J2.786 E.47143
; COOLING_NODE: 0
M204 S10000
G1 X181.377 Y164.622 F60000
G1 F2555
M204 S8000
G3 X184.416 Y162.832 I2.874 J1.403 E.12395
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G3 X184.584 Y169.205 I-.168 J3.193 E.31655
G3 X181.351 Y164.676 I-.333 J-3.18 E.22387
; COOLING_NODE: 0
M204 S250
G1 X181.026 Y164.452 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1918
M204 S5000
G3 X184.274 Y162.435 I3.227 J1.572 E.12388
G1 X184.437 Y162.44 E.00503
G3 X181 Y164.506 I-.185 J3.585 E.56221
; WIPE_START
G1 F9547.055
M204 S8000
M73 P75 R4
G1 X181.173 Y164.176 E-.14139
G1 X181.36 Y163.896 E-.12826
G1 X181.582 Y163.623 E-.13385
G1 X181.848 Y163.357 E-.14253
G1 X182.294 Y163.015 E-.21397
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X184.284 Y165.966 Z7.8 F60000
G1 Z7.4
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.58246
G1 F2555
M204 S8000
G2 X184.287 Y166.077 I-.029 J.056 E.01161
M204 S10000
G1 X183.815 Y165.862 F60000
; LINE_WIDTH: 0.41999
G1 F2555
M204 S8000
G1 X183.804 Y166.175 E.00964
G1 X183.932 Y166.373 E.00724
G2 X184.293 Y166.492 I.384 J-.559 E.01184
G1 X184.59 Y166.353 E.01009
G2 X184.72 Y166 I-.624 J-.431 E.01168
G1 X184.595 Y165.711 E.00967
G1 X184.417 Y165.583 E.00674
G1 X184.185 Y165.555 E.00718
G1 X183.951 Y165.66 E.00786
G1 X183.849 Y165.812 E.00563
M204 S10000
G1 X183.583 Y165.497 F60000
G1 F2555
M204 S8000
G1 X183.432 Y165.853 E.01189
G1 X183.427 Y166.198 E.01061
G1 X183.508 Y166.423 E.00733
G1 X183.706 Y166.68 E.00996
G1 X183.961 Y166.819 E.00894
G1 X184.352 Y166.869 E.0121
G1 X184.722 Y166.718 E.01228
G1 X184.906 Y166.566 E.00735
G1 X185.044 Y166.314 E.00883
G1 X185.097 Y165.98 E.01039
G1 X185.007 Y165.648 E.01057
G1 X184.765 Y165.345 E.01192
G1 X184.474 Y165.202 E.00995
G1 X184.132 Y165.18 E.01054
G1 X183.825 Y165.286 E.00997
G1 X183.628 Y165.457 E.00802
M204 S10000
G1 X183.186 Y165.44 F60000
G1 F2555
M204 S8000
G1 X183.098 Y165.603 E.00567
G1 X183.026 Y165.961 E.01123
G1 X183.1 Y166.445 E.01504
G1 X183.363 Y166.878 E.01557
G2 X183.831 Y167.177 I1.656 J-2.072 E.01709
G1 X184.315 Y167.248 E.01504
G1 X184.792 Y167.126 E.01515
G1 X185.148 Y166.86 E.01365
G1 X185.402 Y166.444 E.01495
G1 X185.473 Y165.96 E.01504
G1 X185.351 Y165.483 E.01515
G1 X185.066 Y165.109 E.01443
G1 X184.789 Y164.918 E.01034
G1 X184.313 Y164.795 E.01511
G1 X183.849 Y164.86 E.0144
G1 X183.424 Y165.111 E.01515
G1 X183.221 Y165.392 E.01066
M204 S10000
G1 X182.963 Y165.059 F60000
G1 F2555
M204 S8000
G1 X182.74 Y165.474 E.01448
G1 X182.645 Y165.941 E.01466
G1 X182.691 Y166.426 E.01497
G1 X182.798 Y166.72 E.00961
G1 X183.171 Y167.212 E.01896
G1 X183.7 Y167.536 E.01906
G1 X184.182 Y167.633 E.01512
G1 X184.487 Y167.617 E.00936
G1 X184.957 Y167.469 E.01516
G1 X185.426 Y167.115 E.01803
G2 X185.76 Y166.575 I-2.869 J-2.152 E.01955
G1 X185.858 Y166.092 E.01513
G1 X185.85 Y165.94 E.00468
G2 X185.694 Y165.317 I-3.453 J.534 E.01976
G1 X185.442 Y164.943 E.01387
G1 X185.081 Y164.654 E.0142
G1 X184.668 Y164.469 E.01392
G1 X184.176 Y164.423 E.01516
G1 X183.726 Y164.502 E.01406
G1 X183.286 Y164.745 E.01544
G1 X183.006 Y165.017 E.01199
M204 S10000
G1 X182.652 Y164.84 F60000
G1 F2555
M204 S8000
G1 X182.381 Y165.344 E.01761
G1 X182.264 Y165.921 E.01809
G1 X182.321 Y166.51 E.01817
G1 X182.46 Y166.894 E.01255
G1 X182.791 Y167.377 E.01798
G1 X183.046 Y167.608 E.01058
G1 X183.57 Y167.894 E.01834
G1 X184.155 Y168.012 E.01833
G1 X184.554 Y167.991 E.0123
G1 X185.123 Y167.812 E.01831
G1 X185.579 Y167.505 E.01691
G1 X185.833 Y167.23 E.01148
G1 X186.119 Y166.706 E.01836
G1 X186.237 Y166.12 E.01835
G1 X186.216 Y165.721 E.01229
G1 X186.037 Y165.152 E.01831
G1 X185.73 Y164.695 E.01692
G1 X185.304 Y164.348 E.01689
G2 X184.16 Y164.047 I-1.125 J1.945 E.03678
G1 X183.602 Y164.144 E.01739
G2 X182.693 Y164.795 I.778 J2.048 E.03476
; COOLING_NODE: 1
; WIPE_START
G1 F9547.299
G1 X182.918 Y164.547 E-.12746
G1 X183.252 Y164.304 E-.15697
G1 X183.602 Y164.144 E-.14632
G1 X184.16 Y164.047 E-.21503
G1 X184.46 Y164.064 E-.11422
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X182.786 Y156.617 Z7.8 F60000
G1 X182.102 Y153.573 Z7.8
G1 Z7.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2555
M204 S8000
G1 X182.102 Y152.777 E.0264
G1 X187.298 Y152.777 E.17236
G1 X187.298 Y153.573 E.0264
G1 X182.162 Y153.573 E.17037
; COOLING_NODE: 1
M204 S250
G1 X181.71 Y153.965 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2127
M204 S5000
G1 X181.71 Y152.385 E.04855
G1 X187.69 Y152.385 E.18375
G1 X187.69 Y153.965 E.04855
G1 X181.77 Y153.965 E.18191
M204 S10000
G1 X182.306 Y153.175 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F2555
M204 S8000
G1 X187.094 Y153.175 E.15172
; CHANGE_LAYER
; Z_HEIGHT: 7.51429
; LAYER_HEIGHT: 0.114285
; WIPE_START
G1 F9259.259
G1 X185.094 Y153.175 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 53/85
; update layer progress
M73 L53
M991 S0 P52 ;notify layer change

; OBJECT_ID: 15
M204 S10000
G17
G3 Z7.8 I-.062 J-1.215 P1  F60000
G1 X169.095 Y153.987 Z7.8
G1 Z7.514
G1 E.8 F1800
; FEATURE: Support
; LINE_WIDTH: 0.42
; LAYER_HEIGHT: 0.27619
G1 F2549
M204 S8000
G1 X180.961 Y153.987 E.48169
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X180.961 Y152.363 E.06589
G1 X169.039 Y152.363 E.48399
G1 X169.039 Y153.987 E.06589
; CHANGE_LAYER
; Z_HEIGHT: 7.6
; LAYER_HEIGHT: 0.0857143
; WIPE_START
G1 F7226.745
G1 X169.039 Y152.363 E-.61679
G1 X169.415 Y152.363 E-.14321
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 54/85
; update layer progress
M73 L54
M991 S0 P53 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z7.914 I-1.211 J-.117 P1  F60000
G1 X168.116 Y165.848 Z7.914
G1 Z7.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
; LAYER_HEIGHT: 0.2
G1 F2549
M204 S8000
G1 X168.132 Y166.067 E.00728
G3 X165.772 Y163.642 I-2.381 J-.043 E.37157
G1 X165.872 Y163.645 E.00329
G3 X168.098 Y165.617 I-.121 J2.379 E.10654
G1 X168.111 Y165.788 E.00571
; COOLING_NODE: 0
M204 S10000
G1 X168.53 Y165.781 F60000
G1 F2549
M204 S8000
G3 X165.776 Y163.235 I-2.778 J.242 E.44475
G1 X165.894 Y163.238 E.0039
G3 X168.524 Y165.722 I-.142 J2.785 E.13058
; COOLING_NODE: 0
M204 S10000
G1 X168.936 Y165.762 F60000
G1 F2549
M204 S8000
G1 X168.948 Y166.081 E.0106
G3 X165.78 Y162.827 I-3.195 J-.058 E.49849
G1 X165.916 Y162.832 E.00451
G3 X168.932 Y165.702 I-.163 J3.191 E.15043
; COOLING_NODE: 0
M204 S250
G1 X169.328 Y165.748 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1912
M204 S5000
G1 X169.34 Y166.088 E.01045
G3 X165.783 Y162.435 I-3.587 J-.065 E.51838
G1 X165.937 Y162.44 E.00472
G3 X169.325 Y165.688 I-.184 J3.583 E.15721
; WIPE_START
G1 F9547.055
M204 S8000
G1 X169.34 Y166.088 E-.15198
G1 X169.317 Y166.434 E-.13158
G1 X169.261 Y166.772 E-.13021
G1 X169.183 Y167.074 E-.11872
G1 X169.055 Y167.428 E-.14296
G1 X168.957 Y167.628 E-.08455
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X166.168 Y165.814 Z8 F60000
G1 Z7.6
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F2549
M204 S8000
G1 X165.935 Y165.596 E.0098
G1 X165.727 Y165.553 E.00654
G1 X165.542 Y165.605 E.00587
G1 X165.324 Y165.836 E.0098
G1 X165.279 Y166.021 E.00585
G1 X165.365 Y166.272 E.00815
G1 X165.561 Y166.456 E.00825
G1 X165.763 Y166.496 E.00634
G1 X166.003 Y166.42 E.00773
G1 X166.188 Y166.199 E.00885
G2 X166.177 Y165.874 I-.484 J-.148 E.01019
M204 S10000
G1 X166.551 Y165.739 F60000
G1 F2549
M204 S8000
G1 X166.326 Y165.407 E.01232
G1 X165.974 Y165.202 E.01253
G1 X165.635 Y165.18 E.01043
G1 X165.357 Y165.27 E.00896
G1 X165.132 Y165.449 E.00883
G1 X164.926 Y165.805 E.01263
G1 X164.905 Y166.121 E.00976
G1 X165.038 Y166.46 E.01119
G2 X165.437 Y166.816 I.813 J-.511 E.01664
G1 X165.816 Y166.873 E.01176
G1 X166.225 Y166.73 E.01333
G1 X166.516 Y166.401 E.01348
G1 X166.584 Y166.111 E.00915
G1 X166.556 Y165.799 E.00964
M204 S10000
G1 X166.827 Y165.431 F60000
G1 F2549
M204 S8000
G1 X166.586 Y165.128 E.01189
G1 X166.159 Y164.869 E.01535
G1 X165.812 Y164.795 E.0109
G1 X165.336 Y164.865 E.01481
G2 X164.853 Y165.189 I1.15 J2.234 E.01789
G1 X164.593 Y165.619 E.01546
G1 X164.521 Y165.939 E.01007
G2 X164.627 Y166.518 I2.087 J-.081 E.01814
G1 X164.834 Y166.84 E.01177
G1 X165.215 Y167.127 E.01466
G1 X165.685 Y167.253 E.01494
G2 X166.363 Y167.086 I-.069 J-1.734 E.02161
G1 X166.747 Y166.745 E.01576
G1 X166.94 Y166.337 E.01388
G2 X166.845 Y165.489 I-1.547 J-.256 E.02657
M204 S10000
G1 X167.152 Y165.235 F60000
G1 F2549
M204 S8000
G1 X166.846 Y164.849 E.01511
G1 X166.442 Y164.572 E.01505
G1 X165.987 Y164.441 E.01458
G1 X165.528 Y164.43 E.01411
G1 X165.099 Y164.559 E.01375
G2 X164.575 Y164.929 I1.782 J3.085 E.01974
G1 X164.297 Y165.332 E.01505
G1 X164.167 Y165.768 E.01398
G1 X164.155 Y166.241 E.01452
G1 X164.28 Y166.675 E.01389
G1 X164.547 Y167.091 E.0152
G1 X164.907 Y167.396 E.01448
G1 X165.19 Y167.534 E.00969
G1 X165.785 Y167.628 E.01849
G1 X166.266 Y167.531 E.01509
G1 X166.551 Y167.412 E.0095
G2 X167.31 Y166.422 I-.992 J-1.546 E.0391
G1 X167.357 Y165.969 E.014
G1 X167.277 Y165.517 E.01411
G1 X167.176 Y165.289 E.00765
M204 S10000
G1 X167.477 Y165.038 F60000
G1 F2549
M204 S8000
G1 X167.106 Y164.571 E.01832
G1 X166.618 Y164.235 E.01821
G1 X166.094 Y164.076 E.01682
G1 X165.66 Y164.047 E.01337
G1 X165.086 Y164.15 E.0179
G1 X164.761 Y164.299 E.01101
G1 X164.296 Y164.668 E.01824
G1 X163.96 Y165.157 E.01821
G1 X163.801 Y165.674 E.01663
G2 X163.78 Y166.3 I2.851 J.41 E.01929
G1 X163.932 Y166.833 E.01702
G1 X164.261 Y167.342 E.01863
G1 X164.699 Y167.714 E.01765
G1 X165.067 Y167.894 E.01258
G1 X165.615 Y168.01 E.01721
G1 X165.982 Y168.001 E.01128
G1 X166.563 Y167.841 E.01852
G1 X166.916 Y167.637 E.01252
G1 X167.341 Y167.218 E.01835
G1 X167.599 Y166.732 E.01689
G2 X167.709 Y166.229 I-.957 J-.475 E.016
G1 X167.738 Y165.955 E.00845
G1 X167.641 Y165.406 E.01715
G1 X167.501 Y165.092 E.01054
; COOLING_NODE: 1
; WIPE_START
G1 F9547.299
G1 X167.641 Y165.406 E-.13031
G1 X167.738 Y165.955 E-.21213
G1 X167.709 Y166.229 E-.10447
G1 X167.68 Y166.507 E-.10638
G1 X167.599 Y166.732 E-.091
G1 X167.456 Y167.002 E-.11572
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X167.707 Y159.373 Z8 F60000
G1 X167.898 Y153.573 Z8
G1 Z7.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2549
M204 S8000
G1 X162.702 Y153.573 E.17236
G1 X162.702 Y152.777 E.0264
G1 X167.898 Y152.777 E.17236
G1 X167.898 Y153.513 E.02441
; COOLING_NODE: 1
M204 S250
G1 X168.29 Y153.965 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2122
M204 S5000
G1 X162.31 Y153.965 E.18375
G1 X162.31 Y152.385 E.04855
G1 X168.29 Y152.385 E.18375
G1 X168.29 Y153.905 E.04671
M204 S10000
G1 X167.694 Y153.175 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F2549
M204 S8000
G1 X162.906 Y153.175 E.15172
; COOLING_NODE: 0
; WIPE_START
G1 F9259.259
G1 X164.906 Y153.175 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.203 Y157.487 Z8 F60000
G1 X182.12 Y164.963 Z8
G1 Z7.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2549
M204 S8000
M73 P75 R3
G1 X182.166 Y164.87 E.00343
G3 X184.272 Y163.642 I2.085 J1.154 E.0849
G1 X184.372 Y163.645 E.00329
G3 X182.057 Y165.094 I-.121 J2.38 E.4002
G1 X182.094 Y165.017 E.00284
; COOLING_NODE: 0
M204 S10000
G1 X181.755 Y164.785 F60000
G1 F2549
M204 S8000
G1 X181.811 Y164.673 E.00414
G3 X184.276 Y163.235 I2.441 J1.351 E.09939
G1 X184.394 Y163.238 E.0039
G3 X181.683 Y164.935 I-.142 J2.786 E.46855
G1 X181.729 Y164.839 E.00354
; COOLING_NODE: 0
M204 S10000
G1 X181.389 Y164.606 F60000
G1 F2549
M204 S8000
G1 X181.455 Y164.476 E.00485
G3 X184.28 Y162.827 I2.797 J1.548 E.11388
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X184.416 Y162.832 E.00451
G3 X181.309 Y164.777 I-.163 J3.193 E.53689
G1 X181.363 Y164.661 E.00425
; COOLING_NODE: 0
M204 S250
G1 X181.037 Y164.435 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1912
M204 S5000
G1 X181.113 Y164.286 E.00512
G3 X184.283 Y162.435 I3.14 J1.738 E.11842
M73 P76 R3
G1 X184.437 Y162.44 E.00472
G3 X180.948 Y164.624 I-.184 J3.585 E.55829
G1 X181.012 Y164.489 E.00457
; WIPE_START
G1 F9547.055
M204 S8000
G1 X181.113 Y164.286 E-.08615
G1 X181.309 Y163.966 E-.1426
G1 X181.522 Y163.692 E-.13196
G1 X181.756 Y163.442 E-.13013
G1 X182.013 Y163.217 E-.12989
G1 X182.295 Y163.014 E-.13195
G1 X182.312 Y163.004 E-.00733
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X184.285 Y165.967 Z8 F60000
G1 Z7.6
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.58154
G1 F2549
M204 S8000
G2 X184.288 Y166.077 I-.029 J.056 E.01157
M204 S10000
G1 X183.827 Y165.851 F60000
; LINE_WIDTH: 0.41999
G1 F2549
M204 S8000
G1 X183.778 Y166.039 E.00597
G1 X183.87 Y166.28 E.00792
G1 X184.007 Y166.429 E.00623
G1 X184.303 Y166.486 E.00924
G1 X184.503 Y166.42 E.00646
G1 X184.688 Y166.199 E.00885
G1 X184.709 Y166.072 E.00395
G1 X184.673 Y165.817 E.00792
G1 X184.504 Y165.636 E.00762
G1 X184.241 Y165.553 E.00846
G1 X183.998 Y165.625 E.00778
G1 X183.864 Y165.803 E.00687
M204 S10000
G1 X183.535 Y165.575 F60000
G1 F2549
M204 S8000
G1 X183.399 Y165.962 E.0126
G1 X183.477 Y166.366 E.01264
G1 X183.72 Y166.693 E.01252
G1 X184.101 Y166.857 E.01275
G1 X184.472 Y166.83 E.01144
G1 X184.725 Y166.73 E.00836
G1 X185.016 Y166.401 E.01348
G1 X185.084 Y166.112 E.00913
G1 X185.051 Y165.739 E.01149
G1 X184.896 Y165.473 E.00946
G1 X184.583 Y165.259 E.01165
G1 X184.291 Y165.173 E.00936
G1 X183.96 Y165.223 E.01028
G1 X183.72 Y165.36 E.00851
G1 X183.574 Y165.53 E.00687
M204 S10000
G1 X183.211 Y165.374 F60000
G1 F2549
M204 S8000
G1 X183.035 Y165.853 E.01569
G1 X183.027 Y166.151 E.00916
G1 X183.129 Y166.522 E.01183
G1 X183.426 Y166.935 E.01562
G1 X183.683 Y167.116 E.00965
G1 X184.035 Y167.233 E.01141
G1 X184.395 Y167.242 E.01105
G1 X184.863 Y167.086 E.01517
G1 X185.247 Y166.745 E.01575
G1 X185.44 Y166.337 E.01388
G2 X185.317 Y165.41 I-1.594 J-.261 E.02917
G2 X184.905 Y164.987 I-1.522 J1.073 E.0182
G1 X184.416 Y164.811 E.01596
G1 X184.081 Y164.805 E.01029
G1 X183.635 Y164.957 E.01447
G2 X183.25 Y165.328 I1.164 J1.593 E.01648
M204 S10000
G1 X182.888 Y165.172 F60000
G1 F2549
M204 S8000
G1 X182.688 Y165.638 E.01558
G1 X182.647 Y166.044 E.01252
G2 X182.781 Y166.678 I3.343 J-.377 E.01995
G1 X183.056 Y167.104 E.01557
G1 X183.379 Y167.37 E.01287
G2 X183.969 Y167.608 I1.486 J-2.833 E.0196
G1 X184.441 Y167.621 E.01448
G1 X184.916 Y167.49 E.01516
G1 X185.186 Y167.335 E.00955
G1 X185.544 Y166.982 E.01545
G1 X185.751 Y166.585 E.01376
G2 X185.857 Y165.969 I-2.91 J-.82 E.01924
G1 X185.777 Y165.517 E.01411
G1 X185.556 Y165.097 E.01459
G2 X185.105 Y164.663 I-2.241 J1.878 E.01925
G1 X184.652 Y164.467 E.01517
G1 X184.173 Y164.423 E.01478
G1 X183.711 Y164.507 E.01444
G1 X183.342 Y164.703 E.01283
G2 X182.927 Y165.127 I1.965 J2.343 E.01826
M204 S10000
G1 X182.564 Y164.971 F60000
G1 F2549
M204 S8000
G1 X182.323 Y165.532 E.01877
G2 X182.275 Y166.263 I2.748 J.547 E.02257
G1 X182.433 Y166.834 E.0182
G1 X182.764 Y167.347 E.01875
G2 X183.358 Y167.803 I1.998 J-1.988 E.02309
G1 X183.904 Y167.984 E.01767
G1 X184.487 Y167.999 E.01792
G1 X185.063 Y167.841 E.01837
G1 X185.416 Y167.637 E.01252
G1 X185.841 Y167.218 E.01835
G1 X186.099 Y166.732 E.01689
G2 X186.209 Y166.229 I-.956 J-.474 E.01598
G1 X186.238 Y165.955 E.00846
G1 X186.141 Y165.405 E.01716
G2 X185.73 Y164.695 I-1.874 J.61 E.0254
G1 X185.305 Y164.339 E.01702
G1 X184.758 Y164.102 E.01832
G1 X184.355 Y164.038 E.01255
G1 X183.796 Y164.098 E.01726
G1 X183.403 Y164.234 E.01278
G1 X182.951 Y164.519 E.01643
G1 X182.603 Y164.925 E.01644
; COOLING_NODE: 1
; WIPE_START
G1 F9547.299
G1 X182.951 Y164.519 E-.20327
G1 X183.403 Y164.234 E-.20319
G1 X183.796 Y164.098 E-.15805
G1 X184.308 Y164.043 E-.1955
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X182.734 Y156.575 Z8 F60000
G1 X182.102 Y153.573 Z8
G1 Z7.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2549
M204 S8000
G1 X182.102 Y152.777 E.0264
G1 X187.298 Y152.777 E.17236
G1 X187.298 Y153.573 E.0264
G1 X182.162 Y153.573 E.17037
; COOLING_NODE: 1
M204 S250
G1 X181.71 Y153.965 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2122
M204 S5000
G1 X181.71 Y152.385 E.04855
G1 X187.69 Y152.385 E.18375
G1 X187.69 Y153.965 E.04855
G1 X181.77 Y153.965 E.18191
M204 S10000
G1 X182.306 Y153.175 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F2549
M204 S8000
G1 X187.094 Y153.175 E.15172
; CHANGE_LAYER
; Z_HEIGHT: 7.79048
; LAYER_HEIGHT: 0.190476
; WIPE_START
G1 F9259.259
G1 X185.094 Y153.175 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 55/85
; update layer progress
M73 L55
M991 S0 P54 ;notify layer change

; OBJECT_ID: 15
M204 S10000
G17
G3 Z8 I-.062 J-1.215 P1  F60000
G1 X169.095 Y153.987 Z8
G1 Z7.79
G1 E.8 F1800
; FEATURE: Support
; LINE_WIDTH: 0.42
; LAYER_HEIGHT: 0.27619
G1 F2549
M204 S8000
G1 X180.961 Y153.987 E.48169
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X180.961 Y152.363 E.06589
G1 X169.039 Y152.363 E.48399
G1 X169.039 Y153.987 E.06589
; CHANGE_LAYER
; Z_HEIGHT: 7.8
; LAYER_HEIGHT: 0.00952387
; WIPE_START
G1 F7226.745
G1 X169.039 Y152.363 E-.61679
G1 X169.415 Y152.363 E-.14321
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 56/85
; update layer progress
M73 L56
M991 S0 P55 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z8.19 I-1.211 J-.117 P1  F60000
G1 X168.116 Y165.853 Z8.19
G1 Z7.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
; LAYER_HEIGHT: 0.2
G1 F2549
M204 S8000
G1 X168.134 Y166.069 E.00718
G3 X165.781 Y163.642 I-2.383 J-.044 E.37201
G1 X165.871 Y163.645 E.00299
G3 X168.098 Y165.612 I-.12 J2.38 E.10646
G1 X168.112 Y165.793 E.006
; COOLING_NODE: 0
M204 S10000
G1 X168.53 Y165.781 F60000
G1 F2549
M204 S8000
G1 X168.541 Y166.075 E.00978
G3 X165.785 Y163.235 I-2.79 J-.051 E.43555
G1 X165.893 Y163.238 E.0036
G3 X168.525 Y165.721 I-.141 J2.786 E.13061
; COOLING_NODE: 0
M204 S10000
G1 X168.936 Y165.766 F60000
G1 F2549
M204 S8000
G1 X168.949 Y166.082 E.01047
G3 X165.789 Y162.828 I-3.197 J-.057 E.49909
G1 X165.916 Y162.832 E.0042
G3 X168.934 Y165.707 I-.163 J3.193 E.15061
; COOLING_NODE: 0
M204 S250
G1 X169.328 Y165.753 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1905
M204 S5000
G1 X169.342 Y166.088 E.01032
G3 X165.793 Y162.435 I-3.589 J-.064 E.519
G1 X165.937 Y162.44 E.00443
G3 X169.327 Y165.693 I-.184 J3.585 E.15737
; WIPE_START
G1 F9547.055
M204 S8000
G1 X169.342 Y166.088 E-.15043
G1 X169.32 Y166.4 E-.11878
G1 X169.262 Y166.771 E-.14262
G1 X169.17 Y167.116 E-.13556
G1 X169.054 Y167.428 E-.12656
G1 X168.955 Y167.632 E-.08605
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X165.782 Y165.967 Z8.2 F60000
G1 Z7.8
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.58552
G1 F2549
M204 S8000
G2 X165.786 Y166.078 I-.029 J.056 E.01176
M204 S10000
G1 X166.136 Y165.778 F60000
; LINE_WIDTH: 0.41999
G1 F2549
M204 S8000
G1 X165.996 Y165.632 E.00624
G1 X165.74 Y165.553 E.00821
G1 X165.517 Y165.613 E.00712
G1 X165.318 Y165.836 E.00918
G1 X165.29 Y166.131 E.00909
G1 X165.381 Y166.318 E.0064
G1 X165.58 Y166.461 E.00752
G1 X165.856 Y166.485 E.0085
G1 X166.043 Y166.394 E.00641
G1 X166.214 Y166.107 E.01026
G1 X166.223 Y166.033 E.00229
G1 X166.156 Y165.835 E.00641
M204 S10000
G1 X166.523 Y165.683 F60000
G1 F2549
M204 S8000
G1 X166.293 Y165.39 E.01142
G1 X166.017 Y165.23 E.00981
G1 X165.791 Y165.173 E.00717
G1 X165.472 Y165.219 E.00989
G1 X165.198 Y165.378 E.00976
G1 X164.959 Y165.713 E.01261
G1 X164.903 Y166.129 E.0129
G1 X165.012 Y166.451 E.01045
G1 X165.319 Y166.758 E.01335
G1 X165.717 Y166.875 E.01275
G1 X166.011 Y166.837 E.00911
G1 X166.303 Y166.671 E.0103
G1 X166.516 Y166.358 E.01166
G1 X166.601 Y166.078 E.00898
G2 X166.536 Y165.741 I-.898 J-.001 E.01061
M204 S10000
G1 X166.675 Y165.221 F60000
G1 F2549
M204 S8000
G1 X166.4 Y164.985 E.01114
G1 X165.916 Y164.811 E.01581
G1 X165.579 Y164.805 E.01033
G1 X165.134 Y164.958 E.01446
G1 X164.84 Y165.218 E.01206
G1 X164.649 Y165.488 E.01016
G1 X164.522 Y165.957 E.01494
G1 X164.578 Y166.405 E.01386
G1 X164.749 Y166.731 E.01132
G1 X165.112 Y167.077 E.0154
G1 X165.497 Y167.214 E.01255
G1 X165.9 Y167.248 E.01243
G1 X166.366 Y167.092 E.0151
G2 X166.788 Y166.679 I-1.242 J-1.694 E.0182
G1 X166.963 Y166.201 E.01564
G1 X166.976 Y166.009 E.00591
G1 X166.871 Y165.527 E.01516
G1 X166.707 Y165.271 E.00933
M204 S10000
G1 X166.963 Y164.971 F60000
G1 F2549
M204 S8000
G1 X166.602 Y164.662 E.0146
G1 X166.152 Y164.467 E.01507
G1 X165.67 Y164.424 E.01486
G1 X165.225 Y164.502 E.01388
G1 X164.824 Y164.718 E.01401
G2 X164.31 Y165.323 I1.202 J1.541 E.02454
G2 X164.218 Y166.523 I1.722 J.736 E.03767
G1 X164.444 Y166.953 E.01491
G2 X165.048 Y167.465 I1.54 J-1.204 E.02448
G2 X166.248 Y167.557 I.736 J-1.722 E.03768
G1 X166.678 Y167.331 E.01491
G2 X167.112 Y166.88 I-1.871 J-2.235 E.01928
G1 X167.308 Y166.429 E.01509
G1 X167.353 Y165.998 E.01333
G2 X167.219 Y165.372 I-3.317 J.384 E.0197
G1 X166.995 Y165.021 E.01278
M204 S10000
G1 X167.251 Y164.721 F60000
G1 F2549
M204 S8000
G1 X166.804 Y164.338 E.01807
G1 X166.258 Y164.102 E.01828
G1 X165.854 Y164.038 E.01256
G1 X165.299 Y164.097 E.01717
G2 X164.42 Y164.546 I.724 J2.503 E.0305
G1 X164.061 Y164.973 E.01716
G1 X163.881 Y165.342 E.01259
G1 X163.766 Y165.888 E.01715
G1 X163.812 Y166.433 E.01682
G2 X164.27 Y167.355 I2.523 J-.679 E.03185
G1 X164.698 Y167.714 E.01717
G1 X165.067 Y167.894 E.01258
G1 X165.613 Y168.009 E.01716
G1 X166.158 Y167.963 E.01681
G2 X167.08 Y167.504 I-.679 J-2.523 E.03186
G1 X167.436 Y167.08 E.01702
G1 X167.672 Y166.537 E.0182
G1 X167.73 Y165.986 E.017
G1 X167.724 Y165.778 E.0064
G1 X167.567 Y165.216 E.01792
G1 X167.283 Y164.771 E.01623
; COOLING_NODE: 1
; WIPE_START
G1 F9547.299
G1 X167.567 Y165.216 E-.20067
G1 X167.724 Y165.778 E-.22164
G1 X167.73 Y165.986 E-.07909
G1 X167.672 Y166.537 E-.21028
G1 X167.621 Y166.653 E-.04831
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X167.783 Y159.022 Z8.2 F60000
G1 X167.898 Y153.573 Z8.2
G1 Z7.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2549
M204 S8000
G1 X162.702 Y153.573 E.17236
G1 X162.702 Y152.777 E.0264
G1 X167.898 Y152.777 E.17236
G1 X167.898 Y153.513 E.02441
; COOLING_NODE: 1
M204 S250
G1 X168.29 Y153.965 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2104
M204 S5000
G1 X162.31 Y153.965 E.18375
G1 X162.31 Y152.385 E.04855
G1 X168.29 Y152.385 E.18375
G1 X168.29 Y153.905 E.04671
M204 S10000
G1 X167.694 Y153.175 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F2549
M204 S8000
G1 X162.906 Y153.175 E.15172
; COOLING_NODE: 0
; WIPE_START
G1 F9259.259
G1 X164.906 Y153.175 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.208 Y157.48 Z8.2 F60000
G1 X182.131 Y164.941 Z8.2
G1 Z7.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2549
M204 S8000
G1 X182.167 Y164.87 E.00261
G3 X184.281 Y163.642 I2.085 J1.154 E.08517
G1 X184.371 Y163.645 E.00299
G3 X182.058 Y165.094 I-.12 J2.38 E.40025
G1 X182.105 Y164.995 E.00364
; COOLING_NODE: 0
M204 S10000
G1 X181.765 Y164.762 F60000
G1 F2549
M204 S8000
G1 X181.811 Y164.673 E.00331
G3 X184.285 Y163.235 I2.441 J1.351 E.09968
G1 X184.393 Y163.238 E.0036
G3 X181.683 Y164.935 I-.141 J2.786 E.46858
G1 X181.74 Y164.816 E.00435
; COOLING_NODE: 0
M204 S10000
G1 X181.4 Y164.584 F60000
G1 F2549
M204 S8000
G1 X181.455 Y164.476 E.00401
G3 X184.289 Y162.828 I2.797 J1.548 E.11419
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X184.416 Y162.832 E.0042
G3 X181.309 Y164.776 I-.163 J3.193 E.53691
G1 X181.374 Y164.638 E.00507
; COOLING_NODE: 0
M204 S250
G1 X181.048 Y164.412 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1905
M204 S5000
M73 P77 R3
G1 X181.112 Y164.286 E.00435
G3 X184.293 Y162.435 I3.14 J1.738 E.11872
G1 X184.437 Y162.44 E.00443
G3 X180.948 Y164.623 I-.184 J3.585 E.5583
G1 X181.022 Y164.466 E.00533
; WIPE_START
G1 F9547.055
M204 S8000
G1 X181.112 Y164.286 E-.07653
G1 X181.31 Y163.965 E-.14315
G1 X181.5 Y163.717 E-.11901
G1 X181.756 Y163.443 E-.1425
G1 X182.006 Y163.223 E-.12641
G1 X182.295 Y163.014 E-.13538
G1 X182.333 Y162.992 E-.01703
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X183.863 Y165.777 Z8.2 F60000
G1 Z7.8
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F2549
M204 S8000
G1 X183.778 Y166.027 E.00811
G1 X183.84 Y166.261 E.00745
G1 X184.061 Y166.457 E.00907
G1 X184.356 Y166.485 E.0091
G1 X184.543 Y166.393 E.00642
G1 X184.714 Y166.107 E.01025
G1 X184.723 Y166.035 E.00223
G1 X184.636 Y165.778 E.00832
G1 X184.495 Y165.632 E.00624
G1 X184.24 Y165.553 E.0082
G1 X184.006 Y165.618 E.00746
G1 X183.903 Y165.732 E.00474
M204 S10000
G1 X183.51 Y165.636 F60000
G1 F2549
M204 S8000
G1 X183.4 Y165.992 E.01146
G1 X183.438 Y166.287 E.00914
G1 X183.604 Y166.577 E.01026
G1 X183.937 Y166.816 E.01261
G1 X184.354 Y166.872 E.01291
G1 X184.676 Y166.764 E.01044
G1 X184.964 Y166.479 E.01244
G1 X185.102 Y166.076 E.01307
G1 X185.1 Y166.024 E.00161
G1 X185.022 Y165.681 E.01081
G1 X184.793 Y165.39 E.01137
G1 X184.517 Y165.23 E.0098
G1 X184.291 Y165.173 E.00718
G1 X183.974 Y165.218 E.00983
G1 X183.695 Y165.377 E.00986
G1 X183.545 Y165.587 E.00793
M204 S10000
G1 X183.28 Y165.27 F60000
G1 F2549
M204 S8000
G1 X183.096 Y165.609 E.01187
G1 X183.025 Y166.077 E.01454
G1 X183.079 Y166.406 E.01023
G1 X183.249 Y166.731 E.01128
G1 X183.612 Y167.077 E.0154
G1 X183.997 Y167.214 E.01255
G1 X184.4 Y167.248 E.01242
G1 X184.865 Y167.092 E.01509
G2 X185.288 Y166.679 I-1.151 J-1.601 E.01822
G1 X185.463 Y166.202 E.01561
G1 X185.477 Y166.013 E.00582
G1 X185.37 Y165.526 E.01533
G1 X185.175 Y165.221 E.01112
G1 X184.9 Y164.985 E.01115
G1 X184.416 Y164.811 E.0158
G1 X184.08 Y164.805 E.01033
G1 X183.626 Y164.963 E.01474
G1 X183.325 Y165.23 E.01239
M204 S10000
G1 X182.971 Y165.048 F60000
G1 F2549
M204 S8000
G1 X182.738 Y165.478 E.01503
G1 X182.644 Y165.923 E.01397
G1 X182.686 Y166.376 E.014
G1 X182.855 Y166.831 E.0149
G1 X183.048 Y167.096 E.01008
G1 X183.405 Y167.395 E.01433
G1 X183.69 Y167.534 E.00974
G1 X184.147 Y167.631 E.01436
G1 X184.6 Y167.59 E.01397
G1 X185.055 Y167.42 E.01492
G1 X185.321 Y167.227 E.01011
G1 X185.612 Y166.88 E.01392
G1 X185.808 Y166.429 E.01509
G1 X185.854 Y166.003 E.01318
G2 X185.718 Y165.371 I-3.492 J.418 E.01988
G1 X185.463 Y164.971 E.01458
G1 X185.102 Y164.662 E.01461
G1 X184.652 Y164.467 E.01506
G1 X184.17 Y164.424 E.01486
G1 X183.726 Y164.502 E.01386
G1 X183.312 Y164.724 E.01443
G1 X183.015 Y165.006 E.01261
M204 S10000
G1 X182.663 Y164.826 F60000
G1 F2549
M204 S8000
G1 X182.381 Y165.346 E.01818
G1 X182.266 Y165.888 E.01702
G1 X182.312 Y166.434 E.01685
G2 X182.77 Y167.355 I2.52 J-.679 E.03181
G1 X183.199 Y167.714 E.01717
G1 X183.567 Y167.893 E.01258
G1 X184.113 Y168.009 E.01715
G1 X184.658 Y167.963 E.01682
G2 X185.58 Y167.504 I-.68 J-2.525 E.03186
G1 X185.936 Y167.08 E.01702
G1 X186.172 Y166.536 E.0182
G1 X186.231 Y165.992 E.01683
G2 X186.067 Y165.216 I-3.289 J.29 E.02443
G1 X185.751 Y164.721 E.01805
G1 X185.304 Y164.338 E.01808
G1 X184.758 Y164.102 E.01827
G1 X184.354 Y164.038 E.01256
G1 X183.799 Y164.097 E.01716
G1 X183.409 Y164.233 E.01269
G1 X182.945 Y164.523 E.01682
G1 X182.704 Y164.782 E.01087
; COOLING_NODE: 1
; WIPE_START
G1 F9547.299
G1 X182.945 Y164.523 E-.13442
G1 X183.409 Y164.233 E-.20806
G1 X183.799 Y164.097 E-.15689
G1 X184.354 Y164.038 E-.21226
G1 X184.48 Y164.058 E-.04837
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X182.792 Y156.614 Z8.2 F60000
G1 X182.102 Y153.573 Z8.2
G1 Z7.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2549
M204 S8000
G1 X182.102 Y152.777 E.0264
G1 X187.298 Y152.777 E.17236
G1 X187.298 Y153.573 E.0264
G1 X182.162 Y153.573 E.17037
; COOLING_NODE: 1
M204 S250
G1 X181.71 Y153.965 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2104
M204 S5000
G1 X181.71 Y152.385 E.04855
G1 X187.69 Y152.385 E.18375
G1 X187.69 Y153.965 E.04855
G1 X181.77 Y153.965 E.18191
M204 S10000
G1 X182.306 Y153.175 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F2549
M204 S8000
G1 X187.094 Y153.175 E.15172
; CHANGE_LAYER
; Z_HEIGHT: 8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.259
G1 X185.094 Y153.175 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 57/85
; update layer progress
M73 L57
M991 S0 P56 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z8.2 I-.759 J-.951 P1  F60000
G1 X169.332 Y165.764 Z8.2
G1 Z8
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1898
M204 S5000
G3 X165.802 Y162.436 I-3.58 J.26 E.52928
G1 X165.937 Y162.44 E.00414
G3 X169.327 Y165.705 I-.185 J3.585 E.15771
; WIPE_START
G1 F9547.055
M204 S8000
G1 X169.339 Y166.088 E-.14576
G1 X169.313 Y166.463 E-.14273
G1 X169.248 Y166.833 E-.1427
G1 X169.144 Y167.194 E-.14285
G1 X169.03 Y167.484 E-.11866
G1 X168.949 Y167.642 E-.06731
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X166.36 Y168.906 Z8.4 F60000
G1 Z8
G1 E.8 F1800
; FEATURE: Top surface
G1 F2650
M204 S2000
G1 X168.629 Y166.638 E.09858
G1 X168.763 Y166.504
G1 X168.828 Y165.905
G1 X168.695 Y166.039
G1 X165.763 Y168.97 E.12739
G1 X165.63 Y169.104
G1 X165.138 Y169.062
G1 X165.272 Y168.928
G1 X168.653 Y165.547 E.14695
G1 X168.787 Y165.413
G1 X168.683 Y164.983
G1 X168.55 Y165.117
G1 X164.842 Y168.825 E.16112
G1 X164.708 Y168.958
G1 X164.329 Y168.804
G1 X164.463 Y168.671
G1 X168.396 Y164.738 E.1709
G1 X168.529 Y164.604
G1 X168.337 Y164.263
G1 X168.203 Y164.397
G1 X164.122 Y168.478 E.17736
G1 X163.988 Y168.612
G1 X163.687 Y168.38
G1 X163.82 Y168.247
G1 X167.971 Y164.096 E.18039
G1 X168.105 Y163.962
G1 X167.84 Y163.694
G1 X167.706 Y163.828
G1 X163.553 Y167.981 E.18048
G1 X163.419 Y168.115
G1 X163.183 Y167.817
G1 X163.317 Y167.684
G1 X167.407 Y163.593 E.17775
G1 X167.541 Y163.46
G1 X167.206 Y163.261
G1 X167.073 Y163.394
G1 X163.121 Y167.346 E.17173
G1 X162.987 Y167.48
G1 X162.83 Y167.104
G1 X162.963 Y166.971
G1 X166.695 Y163.239 E.16217
G1 X166.829 Y163.105
G1 X166.406 Y162.994
G1 X166.273 Y163.128
G1 X162.854 Y166.546 E.14855
G1 X162.721 Y166.68
G1 X162.673 Y166.195
G1 X162.806 Y166.061
G1 X165.786 Y163.082 E.12946
G1 X165.919 Y162.948
G1 X165.334 Y163
G1 X165.2 Y163.134
G1 X162.859 Y165.475 E.10176
M204 S10000
G1 X164.802 Y163.227 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.196364
G1 F2650
M204 S8000
G1 X164.603 Y163.367 E.00304
; LINE_WIDTH: 0.240406
G1 X164.404 Y163.508 E.00391
; LINE_WIDTH: 0.280277
G1 X164.289 Y163.598 E.00283
; LINE_WIDTH: 0.315962
G1 X164.174 Y163.688 E.00326
; LINE_WIDTH: 0.353978
G1 X163.955 Y163.878 E.00734
; LINE_WIDTH: 0.379391
G2 X163.597 Y164.237 I3.827 J4.178 E.01392
; LINE_WIDTH: 0.353796
G1 X163.416 Y164.445 E.00697
; LINE_WIDTH: 0.319154
G1 X163.336 Y164.547 E.00291
; LINE_WIDTH: 0.288739
G1 X163.256 Y164.648 E.00259
; LINE_WIDTH: 0.249195
G1 X163.104 Y164.862 E.00441
; LINE_WIDTH: 0.200542
G1 X162.951 Y165.075 E.00337
; WIPE_START
G1 F15000
G1 X163.104 Y164.862 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X168.514 Y167.053 Z8.4 F60000
G1 Z8
G1 E.8 F1800
; LINE_WIDTH: 0.154492
G1 F2650
M204 S8000
G1 X168.399 Y167.215 E.00181
; LINE_WIDTH: 0.201555
G1 X168.285 Y167.377 E.00257
; LINE_WIDTH: 0.243179
G1 X168.194 Y167.494 E.00242
; LINE_WIDTH: 0.279334
G1 X168.102 Y167.611 E.00286
; LINE_WIDTH: 0.317345
G1 X167.917 Y167.824 E.00631
; LINE_WIDTH: 0.342876
G3 X167.535 Y168.205 I-4.135 J-3.767 E.0132
; LINE_WIDTH: 0.316117
G1 X167.334 Y168.379 E.00591
; LINE_WIDTH: 0.279045
G1 X167.219 Y168.469 E.0028
; LINE_WIDTH: 0.243579
G1 X167.104 Y168.558 E.00238
; LINE_WIDTH: 0.203168
G1 X166.941 Y168.674 E.00261
; LINE_WIDTH: 0.157816
G1 X166.778 Y168.789 E.00187
M204 S10000
G1 X166.857 Y169.005 F60000
; LINE_WIDTH: 0.466486
G1 F2650
M204 S8000
G1 X166.696 Y169.062 E.00588
G3 X162.568 Y166.036 I-.947 J-3.037 E.20529
G1 X162.568 Y166.014 E.00076
G3 X162.584 Y165.704 I6.642 J.194 E.01073
G3 X166.978 Y168.959 I3.165 J.321 E.46275
G1 X166.913 Y168.983 E.00239
; COOLING_NODE: 1
; WIPE_START
G1 F8499.28
G1 X166.696 Y169.062 E-.08758
G1 X166.395 Y169.141 E-.11847
G1 X166.072 Y169.191 E-.12425
G1 X165.694 Y169.206 E-.14366
G1 X165.424 Y169.191 E-.10259
G1 X165.127 Y169.146 E-.11413
G1 X164.951 Y169.101 E-.0693
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X166.374 Y161.602 Z8.4 F60000
G1 X167.898 Y153.573 Z8.4
G1 Z8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2650
M204 S8000
G1 X162.702 Y153.573 E.17236
G1 X162.702 Y152.777 E.0264
G1 X167.898 Y152.777 E.17236
G1 X167.898 Y153.513 E.02441
; COOLING_NODE: 1
M204 S250
G1 X168.29 Y153.965 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2077
M204 S5000
G1 X162.31 Y153.965 E.18375
G1 X162.31 Y152.385 E.04855
G1 X168.29 Y152.385 E.18375
G1 X168.29 Y153.905 E.04671
M204 S10000
G1 X167.694 Y153.175 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F2650
M204 S8000
G1 X162.906 Y153.175 E.15172
; COOLING_NODE: 0
; WIPE_START
G1 F9259.259
G1 X164.906 Y153.175 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.175 Y157.528 Z8.4 F60000
G1 X181.059 Y164.39 Z8.4
G1 Z8
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1898
M204 S5000
G1 X181.113 Y164.286 E.00359
G3 X184.302 Y162.436 I3.139 J1.737 E.119
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X184.437 Y162.44 E.00414
G3 X180.949 Y164.623 I-.185 J3.583 E.55798
G1 X181.033 Y164.444 E.00609
M204 S10000
G1 X181.399 Y164.618 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.466471
G1 F2650
M204 S8000
G1 X181.438 Y164.537 E.00311
G3 X181.068 Y166.037 I2.811 J1.489 E.636
G1 X181.068 Y166.016 E.00074
G3 X181.083 Y165.719 I6.557 J.181 E.01025
G3 X181.318 Y164.789 I3.166 J.307 E.03326
G1 X181.373 Y164.672 E.00444
; WIPE_START
G1 F8499.565
G1 X181.438 Y164.537 E-.05708
G1 X181.605 Y164.255 E-.1244
G1 X181.795 Y164 E-.1207
G1 X182.005 Y163.77 E-.11842
G1 X182.202 Y163.59 E-.10154
G1 X182.479 Y163.381 E-.132
G1 X182.718 Y163.237 E-.10587
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X187.074 Y166.856 Z8.4 F60000
G1 Z8
G1 E.8 F1800
; FEATURE: Top surface
; LINE_WIDTH: 0.42
G1 F2650
M204 S2000
G1 X185.082 Y168.849 E.0866
G1 X184.948 Y168.983
G1 X184.303 Y169.094
G1 X184.436 Y168.961
G1 X187.186 Y166.211 E.11948
G1 X187.32 Y166.078
G1 X187.308 Y165.556
G1 X187.175 Y165.689
G1 X183.915 Y168.949 E.14167
M73 P78 R3
G1 X183.781 Y169.083
G1 X183.335 Y168.996
G1 X183.469 Y168.862
G1 X187.087 Y165.244 E.15722
G1 X187.221 Y165.11
G1 X187.082 Y164.716
G1 X186.948 Y164.85
G1 X183.074 Y168.723 E.16834
G1 X182.94 Y168.857
G1 X182.591 Y168.674
G1 X182.724 Y168.54
G1 X186.765 Y164.499 E.17559
G1 X186.899 Y164.366
G1 X186.681 Y164.05
G1 X186.548 Y164.184
G1 X182.409 Y168.322 E.17982
G1 X182.276 Y168.455
G1 X181.997 Y168.201
G1 X182.131 Y168.067
G1 X186.292 Y163.906 E.18084
G1 X186.426 Y163.772
G1 X186.136 Y163.529
G1 X186.002 Y163.662
G1 X181.887 Y167.778 E.17884
G1 X181.753 Y167.911
G1 X181.542 Y167.589
G1 X181.676 Y167.455
G1 X185.678 Y163.453 E.17393
G1 X185.812 Y163.319
G1 X185.45 Y163.148
G1 X185.317 Y163.281
G1 X181.507 Y167.091 E.16552
G1 X181.374 Y167.224
G1 X181.248 Y166.817
G1 X181.381 Y166.684
G1 X184.907 Y163.157 E.15323
G1 X185.041 Y163.024
G1 X184.577 Y162.955
G1 X184.443 Y163.088
G1 X181.314 Y166.217 E.13595
G1 X181.181 Y166.351
G1 X181.195 Y165.803
G1 X181.329 Y165.67
G1 X183.895 Y163.103 E.11153
G1 X184.029 Y162.969
G1 X183.315 Y163.15
G1 X183.182 Y163.283
G1 X181.508 Y164.957 E.07272
M204 S10000
G1 X182.521 Y163.647 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.11058
G1 F2650
M204 S8000
G2 X181.872 Y164.297 I5.151 J5.8 E.00507
; WIPE_START
G1 F15000
G1 X182.181 Y163.96 E-.37844
G1 X182.521 Y163.647 E-.38156
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X187.152 Y166.534 Z8.4 F60000
G1 Z8
G1 E.8 F1800
; LINE_WIDTH: 0.10022
G1 F2650
M204 S8000
G1 X187.018 Y166.8 E.00139
M204 S10000
G1 X186.882 Y167.342 F60000
; LINE_WIDTH: 0.0974014
G1 F2650
M204 S8000
G1 X186.837 Y167.405 E.00034
; LINE_WIDTH: 0.12507
G1 X186.744 Y167.524 E.00101
; LINE_WIDTH: 0.161963
G1 X186.651 Y167.644 E.00147
; LINE_WIDTH: 0.200758
G1 X186.462 Y167.861 E.00371
; LINE_WIDTH: 0.226825
G3 X186.072 Y168.25 I-4.221 J-3.845 E.00826
; LINE_WIDTH: 0.199508
G1 X185.867 Y168.428 E.00346
; LINE_WIDTH: 0.161669
G1 X185.75 Y168.519 E.00144
; LINE_WIDTH: 0.125495
G1 X185.632 Y168.611 E.001
; LINE_WIDTH: 0.097793
G1 X185.568 Y168.656 E.00036
; COOLING_NODE: 1
; WIPE_START
G1 F15000
G1 X185.632 Y168.611 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X183.888 Y161.18 Z8.4 F60000
G1 X182.102 Y153.573 Z8.4
G1 Z8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2650
M204 S8000
G1 X182.102 Y152.777 E.0264
G1 X187.298 Y152.777 E.17236
G1 X187.298 Y153.573 E.0264
G1 X182.162 Y153.573 E.17037
; COOLING_NODE: 1
M204 S250
G1 X181.71 Y153.965 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2077
M204 S5000
G1 X181.71 Y152.385 E.04855
G1 X187.69 Y152.385 E.18375
G1 X187.69 Y153.965 E.04855
G1 X181.77 Y153.965 E.18191
M204 S10000
G1 X182.306 Y153.175 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F2650
M204 S8000
G1 X187.094 Y153.175 E.15172
; CHANGE_LAYER
; Z_HEIGHT: 8.06667
; LAYER_HEIGHT: 0.0666666
; WIPE_START
G1 F9259.259
G1 X185.094 Y153.175 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 58/85
; update layer progress
M73 L58
M991 S0 P57 ;notify layer change

; OBJECT_ID: 15
M204 S10000
G17
G3 Z8.4 I-.062 J-1.215 P1  F60000
G1 X169.095 Y153.987 Z8.4
G1 Z8.067
G1 E.8 F1800
; FEATURE: Support
; LINE_WIDTH: 0.42
; LAYER_HEIGHT: 0.27619
G1 F2102
M204 S8000
G1 X180.961 Y153.987 E.48169
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X180.961 Y152.363 E.06589
G1 X169.039 Y152.363 E.48399
G1 X169.039 Y153.987 E.06589
; CHANGE_LAYER
; Z_HEIGHT: 8.2
; LAYER_HEIGHT: 0.133333
; WIPE_START
G1 F7226.745
G1 X169.039 Y152.363 E-.61679
G1 X169.415 Y152.363 E-.14321
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 59/85
; update layer progress
M73 L59
M991 S0 P58 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 5
M204 S10000
G17
G3 Z8.467 I-1.203 J-.187 P1  F60000
G1 X167.019 Y167.814 Z8.467
G1 Z8.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
; LAYER_HEIGHT: 0.2
G1 F2102
M204 S8000
G1 X166.785 Y167.965 E.00922
G3 X165.52 Y163.834 I-1.037 J-1.942 E.25763
G1 X165.739 Y163.822 E.00729
G3 X167.143 Y167.727 I.009 J2.201 E.17963
G1 X167.068 Y167.78 E.00303
; COOLING_NODE: 5
M204 S250
G1 X166.802 Y167.489 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1984
M204 S5000
G1 X166.6 Y167.62 E.0074
G3 X165.561 Y164.225 I-.851 J-1.596 E.19605
G1 X165.742 Y164.215 E.00556
G3 X166.894 Y167.425 I.008 J1.809 E.13677
G1 X166.851 Y167.455 E.00161
; COOLING_NODE: 5
; WIPE_START
G1 F9547.055
M204 S8000
G1 X166.6 Y167.62 E-.11431
G1 X166.28 Y167.756 E-.13197
G1 X165.939 Y167.825 E-.13217
G1 X165.569 Y167.826 E-.14074
G1 X165.221 Y167.756 E-.1349
G1 X164.963 Y167.65 E-.1059
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X168.94 Y165.803 Z8.6 F60000
G1 Z8.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2102
M204 S8000
G3 X165.807 Y162.828 I-3.19 J.222 E.50903
G1 X165.915 Y162.831 E.00357
G3 X168.935 Y165.743 I-.165 J3.193 E.15179
; COOLING_NODE: 0
M204 S250
G1 X169.331 Y165.77 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1891
M204 S5000
G1 X169.331 Y165.774 E.00013
G3 X165.812 Y162.436 I-3.581 J.251 E.52934
G1 X165.937 Y162.44 E.00384
G3 X169.285 Y165.402 I-.187 J3.584 E.14827
G1 X169.323 Y165.71 E.00955
M204 S10000
G1 X168.436 Y165.762 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.631702
G1 F2102
M204 S8000
G3 X163.05 Y166.04 I-2.686 J.272 E.41967
G1 X163.05 Y166.01 E.00147
G1 X163.051 Y165.978 E.00152
G3 X168.429 Y165.702 I2.699 J.056 E.38825
; COOLING_NODE: 1
; WIPE_START
G1 F6114.319
G1 X168.45 Y166.039 E-.12831
G1 X168.436 Y166.302 E-.10018
G1 X168.397 Y166.558 E-.09824
G1 X168.334 Y166.81 E-.09881
G1 X168.236 Y167.08 E-.10909
G1 X168.125 Y167.308 E-.09631
G1 X167.98 Y167.547 E-.10622
G1 X167.944 Y167.595 E-.02283
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X167.919 Y159.962 Z8.6 F60000
G1 X167.898 Y153.573 Z8.6
G1 Z8.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2102
M204 S8000
G1 X162.702 Y153.573 E.17236
G1 X162.702 Y152.777 E.0264
G1 X167.898 Y152.777 E.17236
G1 X167.898 Y153.513 E.02441
; COOLING_NODE: 1
M204 S250
G1 X168.29 Y153.965 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2042
M204 S5000
G1 X162.31 Y153.965 E.18375
G1 X162.31 Y152.385 E.04855
G1 X168.29 Y152.385 E.18375
G1 X168.29 Y153.905 E.04671
M204 S10000
G1 X167.694 Y153.175 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F2102
M204 S8000
G1 X162.906 Y153.175 E.15172
; COOLING_NODE: 4
; WIPE_START
G1 F9259.259
G1 X164.906 Y153.175 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.602 Y156.838 Z8.6 F60000
G1 X186.017 Y164.723 Z8.6
G1 Z8.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2102
M204 S8000
G1 X186.193 Y164.991 E.01064
G3 X184.02 Y163.834 I-1.944 J1.032 E.37215
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X184.239 Y163.822 E.00729
G3 X185.959 Y164.638 I.009 J2.201 E.06528
G1 X185.983 Y164.673 E.00144
; COOLING_NODE: 4
M204 S250
G1 X185.692 Y164.939 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1984
M204 S5000
G1 X185.847 Y165.176 E.0087
G3 X184.061 Y164.225 I-1.598 J.848 E.28328
G1 X184.242 Y164.215 E.00556
G3 X185.655 Y164.886 I.008 J1.809 E.04972
G1 X185.658 Y164.889 E.00013
; COOLING_NODE: 4
; WIPE_START
G1 F9547.055
M204 S8000
G1 X185.847 Y165.176 E-.13043
G1 X185.981 Y165.497 E-.13219
G1 X186.05 Y165.837 E-.13184
G1 X186.051 Y166.206 E-.1404
G1 X185.981 Y166.554 E-.13482
G1 X185.89 Y166.773 E-.09032
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X181.422 Y164.539 Z8.6 F60000
G1 Z8.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2102
M204 S8000
G1 X181.453 Y164.475 E.00237
G3 X184.307 Y162.828 I2.797 J1.55 E.11482
G1 X184.415 Y162.831 E.00357
G3 X181.307 Y164.776 I-.165 J3.193 E.53688
G1 X181.396 Y164.593 E.00674
; COOLING_NODE: 0
M204 S250
G1 X181.07 Y164.367 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1891
M204 S5000
M73 P79 R3
G1 X181.111 Y164.285 E.00282
G3 X184.312 Y162.436 I3.14 J1.74 E.11934
G1 X184.437 Y162.44 E.00384
G3 X180.946 Y164.622 I-.187 J3.584 E.55824
G1 X181.044 Y164.421 E.00688
M204 S10000
G1 X181.843 Y164.807 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.631704
G1 F2102
M204 S8000
G1 X181.874 Y164.742 E.00344
G3 X181.551 Y166.069 I2.376 J1.283 E.74762
G1 X181.55 Y166.011 E.00276
G1 X181.551 Y165.982 E.00138
G3 X181.765 Y164.97 I2.699 J.043 E.04994
G1 X181.817 Y164.861 E.00583
; COOLING_NODE: 1
; WIPE_START
G1 F6114.297
G1 X181.874 Y164.742 E-.05002
G1 X182.02 Y164.503 E-.10631
G1 X182.182 Y164.289 E-.10185
G1 X182.349 Y164.108 E-.09378
G1 X182.529 Y163.945 E-.09234
G1 X182.753 Y163.778 E-.10605
G1 X182.982 Y163.641 E-.1016
G1 X183.206 Y163.535 E-.09425
G1 X183.241 Y163.523 E-.01381
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X182.373 Y155.94 Z8.6 F60000
G1 X182.102 Y153.573 Z8.6
G1 Z8.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2102
M204 S8000
G1 X182.102 Y152.777 E.0264
G1 X187.298 Y152.777 E.17236
G1 X187.298 Y153.573 E.0264
G1 X182.162 Y153.573 E.17037
; COOLING_NODE: 1
M204 S250
G1 X181.71 Y153.965 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2042
M204 S5000
G1 X181.71 Y152.385 E.04855
G1 X187.69 Y152.385 E.18375
G1 X187.69 Y153.965 E.04855
G1 X181.77 Y153.965 E.18191
M204 S10000
G1 X182.306 Y153.175 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F2102
M204 S8000
G1 X187.094 Y153.175 E.15172
; CHANGE_LAYER
; Z_HEIGHT: 8.34286
; LAYER_HEIGHT: 0.142858
; WIPE_START
G1 F9259.259
G1 X185.094 Y153.175 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 60/85
; update layer progress
M73 L60
M991 S0 P59 ;notify layer change

; OBJECT_ID: 15
M204 S10000
G17
G3 Z8.6 I-.062 J-1.215 P1  F60000
G1 X169.095 Y153.987 Z8.6
G1 Z8.343
G1 E.8 F1800
; FEATURE: Support
; LINE_WIDTH: 0.42
; LAYER_HEIGHT: 0.27619
G1 F2101
M204 S8000
G1 X180.961 Y153.987 E.48169
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X180.961 Y152.363 E.06589
G1 X169.039 Y152.363 E.48399
G1 X169.039 Y153.987 E.06589
; CHANGE_LAYER
; Z_HEIGHT: 8.4
; LAYER_HEIGHT: 0.0571423
; WIPE_START
G1 F7226.745
G1 X169.039 Y152.363 E-.61679
G1 X169.415 Y152.363 E-.14321
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 61/85
; update layer progress
M73 L61
M991 S0 P60 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 5
M204 S10000
G17
G3 Z8.743 I-1.203 J-.184 P1  F60000
G1 X167.055 Y167.794 Z8.743
G1 Z8.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
; LAYER_HEIGHT: 0.2
G1 F2101
M204 S8000
G1 X167.013 Y167.825 E.00175
G3 X165.519 Y163.834 I-1.265 J-1.802 E.26646
G1 X165.728 Y163.822 E.00696
G3 X167.334 Y167.551 I.02 J2.201 E.17135
G1 X167.101 Y167.754 E.01028
; COOLING_NODE: 5
M204 S250
G1 X166.801 Y167.497 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1958
M204 S5000
G1 X166.787 Y167.505 E.0005
G3 X165.561 Y164.225 I-1.038 J-1.481 E.20281
G1 X165.732 Y164.215 E.00527
G3 X167.051 Y167.28 I.017 J1.809 E.13049
G1 X166.847 Y167.457 E.00833
; COOLING_NODE: 5
; WIPE_START
G1 F9547.055
M204 S8000
G1 X166.787 Y167.505 E-.02897
G1 X166.486 Y167.679 E-.13206
G1 X166.127 Y167.796 E-.14341
G1 X165.782 Y167.835 E-.13208
G1 X165.434 Y167.808 E-.13249
G1 X165.1 Y167.715 E-.13188
G1 X164.961 Y167.645 E-.05911
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X168.938 Y165.808 Z8.8 F60000
G1 Z8.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2101
M204 S8000
G1 X168.943 Y165.863 E.00181
G3 X165.755 Y162.827 I-3.193 J.162 E.50532
G1 X165.917 Y162.832 E.00537
G3 X168.916 Y165.58 I-.167 J3.193 E.14626
G1 X168.933 Y165.749 E.00562
; COOLING_NODE: 0
M204 S250
G1 X169.328 Y165.771 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1885
M204 S5000
G1 X169.336 Y165.844 E.00226
G3 X165.757 Y162.435 I-3.585 J.18 E.52546
G1 X165.938 Y162.44 E.00555
G3 X169.305 Y165.525 I-.187 J3.584 E.15211
G1 X169.323 Y165.711 E.00575
M204 S10000
G1 X168.435 Y165.768 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.631705
G1 F2101
M204 S8000
G1 X168.45 Y165.993 E.01077
G3 X163.052 Y166.114 I-2.7 J.034 E.40434
G1 X163.05 Y166.06 E.00259
G1 X163.05 Y166.03 E.00146
G3 X168.431 Y165.709 I2.7 J-.003 E.39181
; COOLING_NODE: 1
; WIPE_START
G1 F6114.287
G1 X168.45 Y165.993 E-.10813
G1 X168.439 Y166.269 E-.10511
G1 X168.406 Y166.513 E-.09357
G1 X168.343 Y166.778 E-.10371
G1 X168.263 Y167.011 E-.09323
G1 X168.164 Y167.235 E-.09306
G1 X168.029 Y167.472 E-.10384
G1 X167.939 Y167.6 E-.05935
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X167.917 Y159.967 Z8.8 F60000
G1 X167.898 Y153.573 Z8.8
G1 Z8.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2101
M204 S8000
G1 X162.702 Y153.573 E.17236
G1 X162.702 Y152.777 E.0264
G1 X167.898 Y152.777 E.17236
G1 X167.898 Y153.513 E.02441
; COOLING_NODE: 1
M204 S250
G1 X168.29 Y153.965 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2007
M204 S5000
G1 X162.31 Y153.965 E.18375
G1 X162.31 Y152.385 E.04855
G1 X168.29 Y152.385 E.18375
G1 X168.29 Y153.905 E.04671
M204 S10000
G1 X167.694 Y153.175 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F2101
M204 S8000
G1 X162.906 Y153.175 E.15172
; COOLING_NODE: 4
; WIPE_START
G1 F9259.259
G1 X164.906 Y153.175 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.603 Y156.835 Z8.8 F60000
G1 X186.007 Y164.706 Z8.8
G1 Z8.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2101
M204 S8000
G1 X186.053 Y164.762 E.00238
G3 X184.019 Y163.834 I-1.804 J1.262 E.38104
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X184.228 Y163.822 E.00696
G3 X185.778 Y164.44 I.02 J2.201 E.05676
G1 X185.968 Y164.661 E.00966
; COOLING_NODE: 4
M204 S250
G1 X185.71 Y164.96 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1958
M204 S5000
G1 X185.732 Y164.987 E.00106
G3 X184.061 Y164.225 I-1.483 J1.037 E.29007
G1 X184.232 Y164.215 E.00527
G3 X185.506 Y164.723 I.017 J1.809 E.04323
G1 X185.671 Y164.915 E.00777
; COOLING_NODE: 4
; WIPE_START
G1 F9547.055
M204 S8000
G1 X185.732 Y164.987 E-.03589
G1 X185.904 Y165.289 E-.13224
G1 X186.02 Y165.648 E-.14315
G1 X186.06 Y165.993 E-.13205
G1 X186.033 Y166.339 E-.13203
G1 X185.94 Y166.675 E-.13219
G1 X185.878 Y166.798 E-.05245
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X181.419 Y164.544 Z8.8 F60000
G1 Z8.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2101
M204 S8000
G1 X181.509 Y164.378 E.00628
G3 X184.255 Y162.827 I2.741 J1.646 E.10939
G1 X184.417 Y162.832 E.00537
G3 X181.377 Y164.621 I-.167 J3.193 E.54244
G1 X181.39 Y164.597 E.00089
; COOLING_NODE: 0
M204 S250
G1 X181.074 Y164.357 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1885
M204 S5000
G1 X181.174 Y164.176 E.00634
G3 X184.257 Y162.435 I3.077 J1.848 E.11378
M73 P80 R3
G1 X184.438 Y162.44 E.00555
G3 X181.025 Y164.451 I-.187 J3.584 E.56404
G1 X181.046 Y164.41 E.00141
M204 S10000
G1 X181.839 Y164.817 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.631705
G1 F2101
M204 S8000
G3 X181.551 Y166.084 I2.411 J1.214 E.75088
G1 X181.55 Y166.057 E.00128
G1 X181.551 Y166.025 E.00154
G3 X181.812 Y164.871 I2.7 J.006 E.05722
; COOLING_NODE: 1
; WIPE_START
G1 F6114.287
G1 X181.97 Y164.579 E-.12628
G1 X182.132 Y164.351 E-.10623
G1 X182.318 Y164.139 E-.10728
G1 X182.524 Y163.949 E-.10653
G1 X182.73 Y163.793 E-.09791
G1 X182.956 Y163.656 E-.10053
G1 X183.203 Y163.536 E-.10444
G1 X183.23 Y163.527 E-.01079
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X182.371 Y155.943 Z8.8 F60000
G1 X182.102 Y153.573 Z8.8
G1 Z8.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2101
M204 S8000
G1 X182.102 Y152.777 E.0264
G1 X187.298 Y152.777 E.17236
G1 X187.298 Y153.573 E.0264
G1 X182.162 Y153.573 E.17037
; COOLING_NODE: 1
M204 S250
G1 X181.71 Y153.965 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2007
M204 S5000
G1 X181.71 Y152.385 E.04855
G1 X187.69 Y152.385 E.18375
G1 X187.69 Y153.965 E.04855
G1 X181.77 Y153.965 E.18191
M204 S10000
G1 X182.306 Y153.175 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F2101
M204 S8000
G1 X187.094 Y153.175 E.15172
; CHANGE_LAYER
; Z_HEIGHT: 8.6
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F9259.259
G1 X185.094 Y153.175 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 62/85
; update layer progress
M73 L62
M991 S0 P61 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 5
M204 S10000
G17
G3 Z8.8 I-.766 J-.945 P1  F60000
G1 X167.058 Y167.791 Z8.8
G1 Z8.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1866
M204 S8000
G1 X167.01 Y167.829 E.00205
G3 X165.518 Y163.835 I-1.26 J-1.805 E.26624
G1 X165.717 Y163.823 E.00663
G3 X167.333 Y167.554 I.032 J2.201 E.17191
G1 X167.104 Y167.752 E.01003
; COOLING_NODE: 5
M204 S250
G1 X166.805 Y167.493 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1866
M204 S5000
G1 X166.786 Y167.507 E.00071
G3 X165.56 Y164.225 I-1.037 J-1.483 E.20275
G1 X165.722 Y164.215 E.00498
G3 X167.051 Y167.282 I.028 J1.809 E.1309
G1 X166.851 Y167.454 E.00812
; COOLING_NODE: 5
; WIPE_START
G1 F9547.055
M204 S8000
G1 X166.786 Y167.507 E-.03155
G1 X166.458 Y167.691 E-.14295
G1 X166.126 Y167.796 E-.1324
G1 X165.782 Y167.835 E-.13164
G1 X165.436 Y167.808 E-.13183
G1 X165.102 Y167.715 E-.13167
G1 X164.965 Y167.647 E-.05797
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X168.939 Y165.812 Z9 F60000
G1 Z8.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1866
M204 S8000
G1 X168.944 Y165.856 E.00146
G3 X165.764 Y162.827 I-3.193 J.169 E.50581
G1 X165.916 Y162.832 E.00506
G3 X168.917 Y165.58 I-.165 J3.193 E.14632
G1 X168.933 Y165.752 E.00573
; COOLING_NODE: 0
M204 S250
G1 X169.329 Y165.774 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1866
M204 S5000
G1 X169.336 Y165.837 E.00193
G3 X165.767 Y162.435 I-3.584 J.188 E.52595
G1 X165.937 Y162.44 E.00525
G3 X169.306 Y165.526 I-.185 J3.585 E.15216
G1 X169.324 Y165.714 E.00583
M204 S10000
G1 X168.437 Y165.765 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.631704
G1 F1866
M204 S8000
G1 X168.449 Y165.991 E.01084
G3 X163.051 Y166.091 I-2.7 J.025 E.40449
G1 X163.05 Y166.062 E.00135
G3 X168.432 Y165.705 I2.699 J-.047 E.39429
; COOLING_NODE: 1
; WIPE_START
G1 F6114.297
G1 X168.449 Y165.991 E-.10863
G1 X168.441 Y166.236 E-.09314
G1 X168.406 Y166.51 E-.10509
G1 X168.343 Y166.779 E-.1049
G1 X168.263 Y167.011 E-.09315
G1 X168.151 Y167.259 E-.10349
G1 X168.029 Y167.472 E-.09325
G1 X167.94 Y167.597 E-.05834
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X167.917 Y159.964 Z9 F60000
G1 X167.898 Y153.573 Z9
G1 Z8.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1866
M204 S8000
G1 X162.702 Y153.573 E.17236
G1 X162.702 Y152.777 E.0264
G1 X167.898 Y152.777 E.17236
G1 X167.898 Y153.513 E.02441
; COOLING_NODE: 1
M204 S250
G1 X168.29 Y153.965 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1866
M204 S5000
G1 X162.31 Y153.965 E.18375
G1 X162.31 Y152.385 E.04855
G1 X168.29 Y152.385 E.18375
G1 X168.29 Y153.905 E.04671
M204 S10000
G1 X167.694 Y153.175 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1866
M204 S8000
G1 X162.906 Y153.175 E.15172
; COOLING_NODE: 4
; WIPE_START
G1 F9259.259
G1 X164.906 Y153.175 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.602 Y156.837 Z9 F60000
G1 X186.02 Y164.722 Z9
G1 Z8.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1866
M204 S8000
G1 X186.056 Y164.765 E.00183
G3 X184.018 Y163.835 I-1.806 J1.259 E.38093
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X184.217 Y163.823 E.00663
G3 X185.782 Y164.443 I.032 J2.201 E.0573
G1 X185.981 Y164.676 E.01018
; COOLING_NODE: 4
M204 S250
G1 X185.723 Y164.975 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1866
M204 S5000
G1 X185.733 Y164.988 E.0005
G3 X184.06 Y164.225 I-1.483 J1.036 E.29005
G1 X184.222 Y164.215 E.00498
G3 X185.508 Y164.724 I.028 J1.809 E.04361
G1 X185.684 Y164.93 E.00831
; COOLING_NODE: 4
; WIPE_START
G1 F9547.055
M204 S8000
G1 X185.733 Y164.988 E-.02902
G1 X185.905 Y165.292 E-.13275
G1 X186.021 Y165.649 E-.14252
G1 X186.06 Y165.993 E-.13159
G1 X186.033 Y166.34 E-.13221
G1 X185.94 Y166.675 E-.13217
G1 X185.869 Y166.816 E-.05974
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X181.432 Y164.52 Z9 F60000
G1 Z8.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1866
M204 S8000
G1 X181.51 Y164.379 E.00537
G3 X184.264 Y162.827 I2.741 J1.646 E.10967
G1 X184.416 Y162.832 E.00506
G3 X181.378 Y164.621 I-.165 J3.193 E.54247
G1 X181.404 Y164.573 E.00181
; COOLING_NODE: 0
M204 S250
G1 X181.088 Y164.333 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1866
M204 S5000
G1 X181.175 Y164.177 E.00549
G3 X184.267 Y162.435 I3.077 J1.847 E.11406
G1 X184.437 Y162.44 E.00525
G3 X181.026 Y164.451 I-.185 J3.585 E.56406
G1 X181.06 Y164.386 E.00226
M204 S10000
G1 X181.847 Y164.784 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.631702
G1 F1866
M204 S8000
G3 X181.551 Y166.085 I2.403 J1.231 E.74913
G1 X181.551 Y166.059 E.00124
G3 X181.82 Y164.837 I2.699 J-.045 E.06059
; COOLING_NODE: 1
; WIPE_START
G1 F6114.326
M73 P81 R3
G1 X181.994 Y164.541 E-.13046
G1 X182.158 Y164.318 E-.10498
G1 X182.321 Y164.136 E-.09328
G1 X182.526 Y163.947 E-.10579
G1 X182.748 Y163.782 E-.10517
G1 X182.961 Y163.653 E-.09443
G1 X183.204 Y163.536 E-.10272
G1 X183.262 Y163.515 E-.02317
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X182.377 Y155.934 Z9 F60000
G1 X182.102 Y153.573 Z9
G1 Z8.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1866
M204 S8000
G1 X182.102 Y152.777 E.0264
G1 X187.298 Y152.777 E.17236
G1 X187.298 Y153.573 E.0264
G1 X182.162 Y153.573 E.17037
; COOLING_NODE: 1
M204 S250
G1 X181.71 Y153.965 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1866
M204 S5000
G1 X181.71 Y152.385 E.04855
G1 X187.69 Y152.385 E.18375
G1 X187.69 Y153.965 E.04855
G1 X181.77 Y153.965 E.18191
M204 S10000
G1 X182.306 Y153.175 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1866
M204 S8000
G1 X187.094 Y153.175 E.15172
; CHANGE_LAYER
; Z_HEIGHT: 8.61905
; LAYER_HEIGHT: 0.0190468
; WIPE_START
G1 F9259.259
G1 X185.094 Y153.175 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 63/85
; update layer progress
M73 L63
M991 S0 P62 ;notify layer change

; OBJECT_ID: 15
M204 S10000
G17
G3 Z9 I-.062 J-1.215 P1  F60000
G1 X169.095 Y153.987 Z9
G1 Z8.619
G1 E.8 F1800
; FEATURE: Support
; LINE_WIDTH: 0.42
; LAYER_HEIGHT: 0.27619
G1 F2102
M204 S8000
G1 X180.961 Y153.987 E.48169
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X180.961 Y152.363 E.06589
G1 X169.039 Y152.363 E.48399
G1 X169.039 Y153.987 E.06589
; CHANGE_LAYER
; Z_HEIGHT: 8.8
; LAYER_HEIGHT: 0.180953
; WIPE_START
G1 F7226.745
G1 X169.039 Y152.363 E-.61679
G1 X169.415 Y152.363 E-.14321
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 64/85
; update layer progress
M73 L64
M991 S0 P63 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 5
M204 S10000
G17
G3 Z9.019 I-1.203 J-.185 P1  F60000
G1 X167.034 Y167.805 Z9.019
G1 Z8.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
; LAYER_HEIGHT: 0.2
G1 F2102
M204 S8000
G1 X166.814 Y167.951 E.00876
G3 X165.52 Y163.834 I-1.066 J-1.927 E.25873
G1 X165.74 Y163.822 E.00731
G3 X167.143 Y167.728 I.009 J2.202 E.17966
G1 X167.083 Y167.77 E.00241
; COOLING_NODE: 5
M204 S250
G1 X166.815 Y167.481 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1942
M204 S5000
G1 X166.626 Y167.607 E.00699
G3 X165.561 Y164.225 I-.876 J-1.583 E.19698
G1 X165.742 Y164.215 E.00557
G3 X166.894 Y167.425 I.007 J1.809 E.13679
G1 X166.864 Y167.446 E.00113
; COOLING_NODE: 5
; WIPE_START
G1 F9547.055
M204 S8000
G1 X166.626 Y167.607 E-.10926
G1 X166.279 Y167.756 E-.14326
G1 X165.909 Y167.828 E-.14335
G1 X165.569 Y167.826 E-.12934
G1 X165.221 Y167.756 E-.13475
G1 X164.978 Y167.655 E-.10004
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X168.939 Y165.818 Z9.2 F60000
G1 Z8.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2102
M204 S8000
G1 X168.945 Y165.858 E.00133
G3 X165.773 Y162.827 I-3.193 J.167 E.50603
G1 X165.916 Y162.832 E.00475
G3 X168.91 Y165.524 I-.164 J3.193 E.14448
G1 X168.933 Y165.759 E.00782
; COOLING_NODE: 0
M204 S250
G1 X169.329 Y165.778 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1878
M204 S5000
G1 X169.337 Y165.838 E.00186
G3 X165.776 Y162.435 I-3.585 J.187 E.52622
G1 X165.937 Y162.44 E.00496
G3 X169.298 Y165.463 I-.185 J3.585 E.15025
G1 X169.323 Y165.718 E.00786
M204 S10000
G1 X168.435 Y165.743 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.631683
G1 F2102
M204 S8000
G3 X163.05 Y166.04 I-2.685 J.283 E.41983
G1 X163.05 Y166.01 E.00147
G3 X163.063 Y165.759 I4.797 J.126 E.01205
G3 X168.428 Y165.683 I2.687 J.267 E.37768
; COOLING_NODE: 1
; WIPE_START
G1 F6114.521
G1 X168.445 Y166.171 E-.18545
G1 X168.391 Y166.587 E-.15934
G1 X168.332 Y166.815 E-.08941
G1 X168.232 Y167.088 E-.11084
G1 X168.134 Y167.293 E-.0861
G1 X167.988 Y167.535 E-.10748
G1 X167.955 Y167.58 E-.02138
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X167.924 Y159.948 Z9.2 F60000
G1 X167.898 Y153.573 Z9.2
G1 Z8.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2102
M204 S8000
G1 X162.702 Y153.573 E.17236
G1 X162.702 Y152.777 E.0264
G1 X167.898 Y152.777 E.17236
G1 X167.898 Y153.513 E.02441
; COOLING_NODE: 1
M204 S250
G1 X168.29 Y153.965 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1964
M204 S5000
G1 X162.31 Y153.965 E.18375
G1 X162.31 Y152.385 E.04855
G1 X168.29 Y152.385 E.18375
G1 X168.29 Y153.905 E.04671
M204 S10000
G1 X167.694 Y153.175 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F2102
M204 S8000
G1 X162.906 Y153.175 E.15172
; COOLING_NODE: 4
; WIPE_START
G1 F9259.259
G1 X164.906 Y153.175 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.6 Y156.841 Z9.2 F60000
G1 X186.037 Y164.746 Z9.2
G1 Z8.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2102
M204 S8000
G1 X186.075 Y164.794 E.00203
G3 X184.02 Y163.834 I-1.826 J1.23 E.37984
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X184.24 Y163.822 E.00731
G3 X185.804 Y164.466 I.009 J2.202 E.05761
G1 X185.999 Y164.7 E.01008
; COOLING_NODE: 4
M204 S250
G1 X185.736 Y164.995 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1942
M204 S5000
G1 X185.75 Y165.013 E.00071
G3 X184.061 Y164.225 I-1.501 J1.011 E.28915
G1 X184.242 Y164.215 E.00557
G3 X185.528 Y164.745 I.007 J1.809 E.04388
G1 X185.698 Y164.949 E.00814
; COOLING_NODE: 4
; WIPE_START
G1 F9547.055
M204 S8000
G1 X185.75 Y165.013 E-.03163
G1 X185.925 Y165.34 E-.14079
G1 X186.027 Y165.68 E-.13507
G1 X186.053 Y165.866 E-.07127
G1 X186.05 Y166.214 E-.13244
G1 X185.972 Y166.584 E-.14356
G1 X185.864 Y166.839 E-.10524
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X181.451 Y164.484 Z9.2 F60000
G1 Z8.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2102
M204 S8000
G1 X181.482 Y164.427 E.00214
G3 X184.273 Y162.827 I2.77 J1.597 E.11181
G1 X184.416 Y162.832 E.00475
G3 X181.34 Y164.704 I-.164 J3.193 E.53947
G1 X181.424 Y164.537 E.00621
; COOLING_NODE: 0
M204 S250
G1 X181.103 Y164.305 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1878
M204 S5000
G1 X181.143 Y164.232 E.00257
G3 X184.276 Y162.435 I3.109 J1.793 E.11627
G1 X184.437 Y162.44 E.00496
G3 X180.984 Y164.542 I-.185 J3.585 E.56099
G1 X181.076 Y164.358 E.00632
M204 S10000
G1 X181.864 Y164.767 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.63167
G1 F2102
M204 S8000
M73 P81 R2
G3 X181.55 Y166.04 I2.386 J1.263 E.75034
G1 X181.55 Y166.023 E.00084
G3 X181.561 Y165.791 I6.66 J.2 E.01115
G3 X181.836 Y164.82 I2.689 J.239 E.0487
; COOLING_NODE: 1
; WIPE_START
G1 F6114.658
G1 X182.001 Y164.531 E-.12654
G1 X182.152 Y164.325 E-.09677
G1 X182.34 Y164.116 E-.10711
G1 X182.529 Y163.945 E-.09668
G1 X182.748 Y163.781 E-.10384
G1 X182.958 Y163.654 E-.09336
G1 X183.204 Y163.536 E-.10367
G1 X183.283 Y163.507 E-.03204
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X182.382 Y155.928 Z9.2 F60000
G1 X182.102 Y153.573 Z9.2
G1 Z8.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2102
M204 S8000
G1 X182.102 Y152.777 E.0264
M73 P82 R2
G1 X187.298 Y152.777 E.17236
G1 X187.298 Y153.573 E.0264
G1 X182.162 Y153.573 E.17037
; COOLING_NODE: 1
M204 S250
G1 X181.71 Y153.965 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1964
M204 S5000
G1 X181.71 Y152.385 E.04855
G1 X187.69 Y152.385 E.18375
G1 X187.69 Y153.965 E.04855
G1 X181.77 Y153.965 E.18191
M204 S10000
G1 X182.306 Y153.175 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F2102
M204 S8000
G1 X187.094 Y153.175 E.15172
; CHANGE_LAYER
; Z_HEIGHT: 8.89524
; LAYER_HEIGHT: 0.0952377
; WIPE_START
G1 F9259.259
G1 X185.094 Y153.175 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 65/85
; update layer progress
M73 L65
M991 S0 P64 ;notify layer change

; OBJECT_ID: 15
M204 S10000
G17
G3 Z9.2 I-.062 J-1.215 P1  F60000
G1 X169.095 Y153.987 Z9.2
G1 Z8.895
G1 E.8 F1800
; FEATURE: Support
; LINE_WIDTH: 0.42
; LAYER_HEIGHT: 0.27619
G1 F2111
M204 S8000
G1 X180.961 Y153.987 E.48169
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X180.961 Y152.363 E.06589
G1 X169.039 Y152.363 E.48399
G1 X169.039 Y153.987 E.06589
; CHANGE_LAYER
; Z_HEIGHT: 9
; LAYER_HEIGHT: 0.104762
; WIPE_START
G1 F7226.745
G1 X169.039 Y152.363 E-.61679
G1 X169.415 Y152.363 E-.14321
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 66/85
; update layer progress
M73 L66
M991 S0 P65 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 5
M204 S10000
G17
G3 Z9.295 I-1.203 J-.183 P1  F60000
G1 X167.068 Y167.783 Z9.295
G1 Z9
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
; LAYER_HEIGHT: 0.2
G1 F2111
M204 S8000
G1 X167.011 Y167.828 E.00239
G3 X165.519 Y163.834 I-1.263 J-1.804 E.26641
G1 X165.729 Y163.822 E.00697
G3 X167.333 Y167.552 I.02 J2.202 E.17141
G1 X167.113 Y167.744 E.00969
; COOLING_NODE: 5
M204 S250
G1 X166.814 Y167.486 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1938
M204 S5000
G1 X166.787 Y167.506 E.00104
G3 X165.561 Y164.225 I-1.038 J-1.482 E.20282
G1 X165.732 Y164.215 E.00528
G3 X167.051 Y167.281 I.017 J1.809 E.13052
G1 X166.859 Y167.447 E.0078
; COOLING_NODE: 5
; WIPE_START
G1 F9547.055
M204 S8000
G1 X166.787 Y167.506 E-.03558
G1 X166.458 Y167.691 E-.14319
G1 X166.127 Y167.796 E-.13221
G1 X165.781 Y167.835 E-.13203
G1 X165.436 Y167.808 E-.13173
G1 X165.101 Y167.715 E-.1321
G1 X164.976 Y167.652 E-.05315
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X168.937 Y165.792 Z9.4 F60000
G1 Z9
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2111
M204 S8000
G1 X168.947 Y166.081 E.00961
G3 X165.782 Y162.828 I-3.195 J-.058 E.49856
G1 X165.916 Y162.832 E.00444
G3 X168.935 Y165.732 I-.163 J3.191 E.15142
; COOLING_NODE: 0
M204 S250
G1 X169.329 Y165.778 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1877
M204 S5000
G1 X169.34 Y166.088 E.00953
G3 X165.786 Y162.435 I-3.587 J-.065 E.51844
G1 X165.937 Y162.44 E.00466
G3 X169.327 Y165.712 I-.184 J3.583 E.15792
G1 X169.327 Y165.718 E.00019
M204 S10000
G1 X168.438 Y165.79 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.631677
G1 F2111
M204 S8000
G3 X163.051 Y166.086 I-2.688 J.238 E.41547
G1 X163.051 Y166.056 E.00142
G3 X163.057 Y165.837 I4.212 J.016 E.01052
G3 X168.432 Y165.73 I2.692 J.191 E.38329
; COOLING_NODE: 1
; WIPE_START
G1 F6114.585
G1 X168.448 Y166.073 E-.13028
G1 X168.408 Y166.499 E-.16261
G1 X168.35 Y166.751 E-.09842
G1 X168.264 Y167.01 E-.10378
G1 X168.04 Y167.456 E-.18966
G1 X167.926 Y167.618 E-.07525
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X167.911 Y159.986 Z9.4 F60000
G1 X167.898 Y153.573 Z9.4
G1 Z9
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2111
M204 S8000
G1 X162.702 Y153.573 E.17236
G1 X162.702 Y152.777 E.0264
G1 X167.898 Y152.777 E.17236
G1 X167.898 Y153.513 E.02441
; COOLING_NODE: 1
M204 S250
G1 X168.29 Y153.965 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1952
M204 S5000
G1 X162.31 Y153.965 E.18375
G1 X162.31 Y152.385 E.04855
G1 X168.29 Y152.385 E.18375
G1 X168.29 Y153.905 E.04671
M204 S10000
G1 X167.694 Y153.175 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F2111
M204 S8000
G1 X162.906 Y153.175 E.15172
; COOLING_NODE: 4
; WIPE_START
G1 F9259.259
G1 X164.906 Y153.175 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.594 Y156.852 Z9.4 F60000
G1 X186.088 Y164.821 Z9.4
G1 Z9
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2111
M204 S8000
G1 X186.267 Y165.145 E.0123
G3 X184.019 Y163.834 I-2.019 J.879 E.3665
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X184.229 Y163.822 E.00697
G3 X186.054 Y164.764 I.02 J2.202 E.07089
G1 X186.057 Y164.769 E.0002
; COOLING_NODE: 4
M204 S250
G1 X185.747 Y165.012 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1938
M204 S5000
G1 X185.908 Y165.302 E.0102
G3 X184.061 Y164.225 I-1.659 J.722 E.27902
G1 X184.232 Y164.215 E.00528
G3 X185.714 Y164.962 I.017 J1.809 E.05296
; COOLING_NODE: 4
; WIPE_START
G1 F9547.055
M204 S8000
G1 X185.908 Y165.302 E-.14879
G1 X186.02 Y165.647 E-.13799
G1 X186.06 Y165.992 E-.13187
G1 X186.033 Y166.339 E-.13221
G1 X185.94 Y166.675 E-.13241
G1 X185.849 Y166.855 E-.07673
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X181.455 Y164.479 Z9.4 F60000
G1 Z9
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2111
M204 S8000
G3 X184.282 Y162.828 I2.798 J1.544 E.11404
G1 X184.416 Y162.832 E.00444
G3 X181.426 Y164.532 I-.163 J3.191 E.54555
; COOLING_NODE: 0
M204 S250
G1 X181.113 Y164.288 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1877
M204 S5000
G3 X184.286 Y162.435 I3.14 J1.735 E.11851
G1 X184.437 Y162.44 E.00466
G3 X181.084 Y164.34 I-.184 J3.583 E.56759
M204 S10000
G1 X181.852 Y164.784 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.631677
G1 F2111
M204 S8000
G1 X181.98 Y164.569 E.01203
G3 X181.551 Y166.092 I2.269 J1.462 E.73666
G1 X181.55 Y166.057 E.00166
G3 X181.557 Y165.837 I4.589 J.03 E.01058
G3 X181.828 Y164.839 I2.692 J.194 E.04993
; COOLING_NODE: 1
; WIPE_START
G1 F6114.585
G1 X181.98 Y164.569 E-.11788
G1 X182.14 Y164.34 E-.10601
G1 X182.479 Y163.988 E-.18569
G1 X182.705 Y163.81 E-.10925
G1 X182.927 Y163.671 E-.09961
G1 X183.181 Y163.546 E-.10733
G1 X183.265 Y163.515 E-.03422
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X182.378 Y155.934 Z9.4 F60000
G1 X182.102 Y153.573 Z9.4
G1 Z9
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2111
M204 S8000
G1 X182.102 Y152.777 E.0264
G1 X187.298 Y152.777 E.17236
G1 X187.298 Y153.573 E.0264
G1 X182.162 Y153.573 E.17037
; COOLING_NODE: 1
M204 S250
G1 X181.71 Y153.965 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1952
M204 S5000
G1 X181.71 Y152.385 E.04855
G1 X187.69 Y152.385 E.18375
M73 P83 R2
G1 X187.69 Y153.965 E.04855
G1 X181.77 Y153.965 E.18191
M204 S10000
G1 X182.306 Y153.175 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F2111
M204 S8000
G1 X187.094 Y153.175 E.15172
; CHANGE_LAYER
; Z_HEIGHT: 9.17143
; LAYER_HEIGHT: 0.171429
; WIPE_START
G1 F9259.259
G1 X185.094 Y153.175 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 67/85
; update layer progress
M73 L67
M991 S0 P66 ;notify layer change

; OBJECT_ID: 15
M204 S10000
G17
G3 Z9.4 I-.19 J-1.202 P1  F60000
G1 X179.961 Y153.987 Z9.4
G1 Z9.171
G1 E.8 F1800
; FEATURE: Support transition
; LINE_WIDTH: 0.42
; LAYER_HEIGHT: 0.27619
G1 F2196
M204 S8000
G1 X180.962 Y153.987 E.0406
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X180.962 Y152.798 E.04825
G1 X179.773 Y153.987 E.06824
G1 X178.533 Y153.987 E.05035
G1 X180.156 Y152.363 E.09319
G1 X178.916 Y152.363 E.05035
G1 X177.292 Y153.987 E.09319
G1 X176.052 Y153.987 E.05035
G1 X177.675 Y152.363 E.09319
G1 X176.435 Y152.363 E.05035
G1 X174.812 Y153.987 E.09319
G1 X173.571 Y153.987 E.05035
G1 X175.194 Y152.363 E.09319
G1 X173.954 Y152.363 E.05035
G1 X172.331 Y153.987 E.09319
G1 X171.09 Y153.987 E.05035
G1 X172.714 Y152.363 E.09319
G1 X171.473 Y152.363 E.05035
G1 X169.85 Y153.987 E.09319
G1 X169.038 Y153.987 E.03295
G1 X169.038 Y153.558 E.0174
G1 X170.233 Y152.363 E.06858
G1 X169.038 Y152.363 E.04849
G1 X169.038 Y153.369 E.04084
; CHANGE_LAYER
; Z_HEIGHT: 9.2
; LAYER_HEIGHT: 0.0285711
; WIPE_START
G1 F3000
G1 X169.038 Y152.363 E-.3823
G1 X170.032 Y152.363 E-.3777
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 68/85
; update layer progress
M73 L68
M991 S0 P67 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 5
M204 S10000
G17
G3 Z9.571 I-1.195 J-.229 P1  F60000
G1 X167.073 Y167.779 Z9.571
G1 Z9.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
; LAYER_HEIGHT: 0.2
G1 F2196
M204 S8000
G1 X167.012 Y167.827 E.00256
G3 X165.518 Y163.835 I-1.263 J-1.803 E.26637
G1 X165.718 Y163.823 E.00664
G3 X167.335 Y167.551 I.032 J2.201 E.17177
G1 X167.118 Y167.74 E.00952
; COOLING_NODE: 5
M204 S250
G1 X166.819 Y167.482 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1936
M204 S5000
G1 X166.788 Y167.506 E.00121
G3 X165.56 Y164.225 I-1.038 J-1.482 E.2028
G1 X165.722 Y164.215 E.00499
G3 X167.052 Y167.28 I.027 J1.809 E.13083
G1 X166.864 Y167.443 E.00763
; COOLING_NODE: 5
; WIPE_START
G1 F9547.055
M204 S8000
G1 X166.788 Y167.506 E-.0377
G1 X166.457 Y167.691 E-.14391
G1 X166.125 Y167.796 E-.13224
G1 X165.781 Y167.835 E-.13175
G1 X165.435 Y167.808 E-.13202
G1 X165.098 Y167.714 E-.13294
G1 X164.982 Y167.654 E-.04944
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X168.937 Y165.796 Z9.6 F60000
G1 Z9.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2196
M204 S8000
G1 X168.949 Y166.081 E.00948
G3 X165.791 Y162.828 I-3.197 J-.057 E.49919
G1 X165.915 Y162.832 E.00413
G3 X168.936 Y165.736 I-.163 J3.193 E.15158
; COOLING_NODE: 0
M204 S250
G1 X169.329 Y165.782 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1878
M204 S5000
G1 X169.341 Y166.088 E.00941
G3 X165.795 Y162.435 I-3.589 J-.064 E.51907
G1 X165.937 Y162.44 E.00437
G3 X169.328 Y165.712 I-.184 J3.585 E.15795
G1 X169.328 Y165.722 E.00033
M204 S10000
G1 X168.437 Y165.782 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.631704
G1 F2196
M204 S8000
G1 X168.449 Y165.965 E.00878
G3 X163.052 Y166.122 I-2.699 J.053 E.40442
G1 X163.051 Y166.063 E.00286
G3 X168.433 Y165.722 I2.699 J-.045 E.39484
; COOLING_NODE: 1
; WIPE_START
G1 F6114.298
G1 X168.449 Y165.965 E-.09236
G1 X168.444 Y166.213 E-.09431
G1 X168.411 Y166.483 E-.1031
G1 X168.35 Y166.751 E-.10477
G1 X168.271 Y166.994 E-.09687
G1 X168.04 Y167.456 E-.19617
G1 X167.931 Y167.612 E-.07243
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X167.913 Y159.979 Z9.6 F60000
G1 X167.898 Y153.573 Z9.6
G1 Z9.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2196
M204 S8000
G1 X162.702 Y153.573 E.17236
G1 X162.702 Y152.777 E.0264
G1 X167.898 Y152.777 E.17236
G1 X167.898 Y153.513 E.02441
; COOLING_NODE: 1
M204 S250
G1 X168.29 Y153.965 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1946
M204 S5000
G1 X162.31 Y153.965 E.18375
G1 X162.31 Y152.385 E.04855
G1 X168.29 Y152.385 E.18375
G1 X168.29 Y153.905 E.04671
M204 S10000
G1 X167.694 Y153.175 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F2196
M204 S8000
G1 X162.906 Y153.175 E.15172
; COOLING_NODE: 4
; WIPE_START
G1 F9259.259
G1 X164.906 Y153.175 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.592 Y156.855 Z9.6 F60000
G1 X186.099 Y164.841 Z9.6
G1 Z9.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2196
M204 S8000
G1 X186.264 Y165.135 E.01119
G3 X184.018 Y163.835 I-2.014 J.889 E.36682
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X184.218 Y163.823 E.00664
G3 X186.054 Y164.762 I.032 J2.201 E.07119
G1 X186.069 Y164.789 E.00102
; COOLING_NODE: 4
M204 S250
G1 X185.759 Y165.032 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1936
M204 S5000
G1 X185.905 Y165.293 E.00917
G3 X184.06 Y164.225 I-1.655 J.731 E.2793
G1 X184.222 Y164.215 E.00499
G3 X185.728 Y164.981 I.027 J1.809 E.054
; COOLING_NODE: 4
; WIPE_START
G1 F9547.055
M204 S8000
G1 X185.905 Y165.293 E-.13619
G1 X186.021 Y165.649 E-.14233
G1 X186.06 Y165.993 E-.13169
G1 X186.033 Y166.339 E-.13198
G1 X185.94 Y166.675 E-.13219
G1 X185.839 Y166.876 E-.08562
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X181.454 Y164.473 Z9.6 F60000
G1 Z9.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2196
M204 S8000
G1 X181.634 Y164.19 E.01112
G3 X184.291 Y162.828 I2.618 J1.835 E.10306
G1 X184.415 Y162.832 E.00413
G3 X181.428 Y164.526 I-.163 J3.193 E.54609
; COOLING_NODE: 0
M204 S250
G1 X181.122 Y164.265 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1878
M204 S5000
G1 X181.312 Y163.967 E.01087
G3 X184.295 Y162.435 I2.941 J2.058 E.10721
G1 X184.437 Y162.44 E.00437
G3 X181.095 Y164.319 I-.184 J3.585 E.56868
M204 S10000
G1 X181.867 Y164.76 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.631703
G1 F2196
M204 S8000
G1 X181.975 Y164.57 E.01049
G3 X181.551 Y166.085 I2.275 J1.453 E.73716
G1 X181.55 Y166.06 E.00123
G3 X181.556 Y165.845 I4.908 J.026 E.01029
G3 X181.837 Y164.812 I2.694 J.178 E.0517
; COOLING_NODE: 1
; WIPE_START
G1 F6114.311
G1 X181.975 Y164.57 E-.10589
G1 X182.119 Y164.367 E-.09474
G1 X182.297 Y164.161 E-.10349
G1 X182.479 Y163.988 E-.0955
G1 X182.724 Y163.797 E-.11789
G1 X182.933 Y163.668 E-.09327
G1 X183.292 Y163.509 E-.14923
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X182.384 Y155.93 Z9.6 F60000
G1 X182.102 Y153.573 Z9.6
G1 Z9.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2196
M204 S8000
G1 X182.102 Y152.777 E.0264
G1 X187.298 Y152.777 E.17236
G1 X187.298 Y153.573 E.0264
G1 X182.162 Y153.573 E.17037
; COOLING_NODE: 1
M204 S250
G1 X181.71 Y153.965 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1946
M204 S5000
G1 X181.71 Y152.385 E.04855
G1 X187.69 Y152.385 E.18375
G1 X187.69 Y153.965 E.04855
G1 X181.77 Y153.965 E.18191
M204 S10000
G1 X182.306 Y153.175 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F2196
M204 S8000
M73 P84 R2
G1 X187.094 Y153.175 E.15172
; CHANGE_LAYER
; Z_HEIGHT: 9.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.259
G1 X185.094 Y153.175 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 69/85
; update layer progress
M73 L69
M991 S0 P68 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 5
M204 S10000
G17
G3 Z9.6 I-.766 J-.946 P1  F60000
G1 X167.049 Y167.792 Z9.6
G1 Z9.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1868
M204 S8000
G1 X166.783 Y167.967 E.01055
G3 X165.519 Y163.834 I-1.035 J-1.943 E.25756
G1 X165.74 Y163.822 E.00733
G3 X167.162 Y167.712 I.009 J2.202 E.17881
G1 X167.098 Y167.757 E.00261
; COOLING_NODE: 5
M204 S250
G1 X166.83 Y167.468 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1868
M204 S5000
G1 X166.599 Y167.622 E.00853
G3 X165.561 Y164.225 I-.85 J-1.597 E.19604
G1 X165.742 Y164.215 E.00559
G3 X166.912 Y167.411 I.007 J1.809 E.13608
G1 X166.879 Y167.433 E.00121
; COOLING_NODE: 5
; WIPE_START
G1 F9547.055
M204 S8000
G1 X166.599 Y167.622 E-.12827
G1 X166.279 Y167.756 E-.13206
G1 X165.909 Y167.828 E-.14317
G1 X165.562 Y167.825 E-.132
G1 X165.221 Y167.756 E-.1321
G1 X164.996 Y167.663 E-.09239
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X168.94 Y165.797 Z9.8 F60000
G1 Z9.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1868
M204 S8000
G1 X168.948 Y166.081 E.00942
G3 X165.8 Y162.828 I-3.197 J-.057 E.4995
G1 X165.916 Y162.832 E.00384
G3 X168.936 Y165.738 I-.164 J3.193 E.15163
; COOLING_NODE: 0
M204 S250
G1 X169.331 Y165.787 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1868
M204 S5000
G1 X169.34 Y166.088 E.00926
G3 X165.805 Y162.436 I-3.589 J-.064 E.5194
G1 X165.937 Y162.44 E.00408
G3 X169.329 Y165.727 I-.186 J3.585 E.15839
M204 S10000
G1 X168.439 Y165.798 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.631705
G1 F1868
M204 S8000
G3 X163.05 Y166.044 I-2.689 J.232 E.41744
G1 X163.05 Y166.016 E.00135
G1 X163.051 Y165.977 E.00183
G3 X168.434 Y165.739 I2.699 J.054 E.39028
; COOLING_NODE: 1
; WIPE_START
G1 F6114.292
G1 X168.45 Y166.044 E-.11606
G1 X168.434 Y166.317 E-.10382
G1 X168.397 Y166.558 E-.09289
G1 X168.337 Y166.799 E-.09434
G1 X168.235 Y167.08 E-.11373
G1 X168.126 Y167.308 E-.0958
G1 X167.98 Y167.547 E-.10641
G1 X167.921 Y167.624 E-.03695
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X167.909 Y159.992 Z9.8 F60000
G1 X167.898 Y153.573 Z9.8
G1 Z9.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1868
M204 S8000
G1 X162.702 Y153.573 E.17236
G1 X162.702 Y152.777 E.0264
G1 X167.898 Y152.777 E.17236
G1 X167.898 Y153.513 E.02441
; COOLING_NODE: 1
M204 S250
G1 X168.29 Y153.965 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1868
M204 S5000
G1 X162.31 Y153.965 E.18375
G1 X162.31 Y152.385 E.04855
G1 X168.29 Y152.385 E.18375
G1 X168.29 Y153.905 E.04671
M204 S10000
G1 X167.694 Y153.175 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1868
M204 S8000
G1 X162.906 Y153.175 E.15172
; COOLING_NODE: 4
; WIPE_START
G1 F9259.259
G1 X164.906 Y153.175 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.589 Y156.86 Z9.8 F60000
G1 X186.118 Y164.871 Z9.8
G1 Z9.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1868
M204 S8000
G1 X186.287 Y165.191 E.01202
G3 X184.019 Y163.834 I-2.038 J.833 E.36487
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X184.24 Y163.822 E.00733
G3 X186.075 Y164.794 I.009 J2.202 E.07172
G1 X186.088 Y164.818 E.00092
; COOLING_NODE: 4
M204 S250
G1 X185.773 Y165.055 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1868
M204 S5000
G1 X185.924 Y165.34 E.00993
G3 X184.061 Y164.225 I-1.675 J.684 E.27774
G1 X184.242 Y164.215 E.00559
G3 X185.743 Y165.003 I.007 J1.809 E.0542
; COOLING_NODE: 4
; WIPE_START
G1 F9547.055
M204 S8000
G1 X185.924 Y165.34 E-.14552
G1 X186.027 Y165.679 E-.13457
G1 X186.053 Y165.866 E-.07158
G1 X186.05 Y166.213 E-.1321
G1 X185.981 Y166.554 E-.13209
G1 X185.848 Y166.875 E-.13201
G1 X185.83 Y166.902 E-.01213
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X181.489 Y164.428 Z9.8 F60000
G1 Z9.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1868
M204 S8000
G1 X181.569 Y164.287 E.00537
G3 X184.3 Y162.828 I2.683 J1.736 E.10724
G1 X184.416 Y162.832 E.00384
G3 X181.331 Y164.726 I-.164 J3.191 E.53838
G1 X181.461 Y164.481 E.0092
; COOLING_NODE: 0
M204 S250
G1 X181.146 Y164.242 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1868
M204 S5000
G1 X181.241 Y164.072 E.00597
G3 X184.305 Y162.436 I3.011 J1.95 E.11141
G1 X184.437 Y162.44 E.00408
G3 X180.973 Y164.566 I-.186 J3.583 E.55983
G1 X181.118 Y164.295 E.00946
M204 S10000
G1 X181.901 Y164.718 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.631677
G1 F1868
M204 S8000
G1 X182.007 Y164.531 E.0103
G3 X181.55 Y166.04 I2.242 J1.503 E.73672
G1 X181.55 Y166.01 E.00148
G1 X181.551 Y165.977 E.00155
G3 X181.768 Y164.971 I2.698 J.056 E.04971
G1 X181.873 Y164.771 E.01083
; COOLING_NODE: 1
; WIPE_START
G1 F6114.58
G1 X182.007 Y164.531 E-.1044
G1 X182.182 Y164.289 E-.11338
G1 X182.35 Y164.107 E-.09421
G1 X182.727 Y163.796 E-.1857
G1 X182.983 Y163.641 E-.11362
G1 X183.206 Y163.535 E-.09376
G1 X183.341 Y163.485 E-.05493
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X182.395 Y155.912 Z9.8 F60000
G1 X182.102 Y153.573 Z9.8
G1 Z9.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1868
M204 S8000
G1 X182.102 Y152.777 E.0264
G1 X187.298 Y152.777 E.17236
G1 X187.298 Y153.573 E.0264
G1 X182.162 Y153.573 E.17037
; COOLING_NODE: 1
M204 S250
G1 X181.71 Y153.965 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1868
M204 S5000
G1 X181.71 Y152.385 E.04855
G1 X187.69 Y152.385 E.18375
G1 X187.69 Y153.965 E.04855
G1 X181.77 Y153.965 E.18191
M204 S10000
G1 X182.306 Y153.175 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1868
M204 S8000
G1 X187.094 Y153.175 E.15172
; CHANGE_LAYER
; Z_HEIGHT: 9.44762
; LAYER_HEIGHT: 0.0476198
; WIPE_START
G1 F9259.259
G1 X185.094 Y153.175 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 70/85
; update layer progress
M73 L70
M991 S0 P69 ;notify layer change

; OBJECT_ID: 15
M204 S10000
G17
G3 Z9.8 I-.214 J-1.198 P1  F60000
G1 X179.603 Y154.156 Z9.8
G1 Z9.448
G1 E.8 F1800
; FEATURE: Support interface
; LINE_WIDTH: 0.42
; LAYER_HEIGHT: 0.27619
G1 F2152
M204 S8000
G1 X180.962 Y152.798 E.07798
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X180.962 Y152.363 E.01765
G1 X180.156 Y152.363 E.0327
G1 X178.533 Y153.987 E.09319
G1 X177.292 Y153.987 E.05035
G1 X178.916 Y152.363 E.09319
G1 X177.675 Y152.363 E.05035
G1 X176.052 Y153.987 E.09319
G1 X174.812 Y153.987 E.05035
G1 X176.435 Y152.363 E.09319
G1 X175.194 Y152.363 E.05035
M73 P85 R2
G1 X173.571 Y153.987 E.09319
G1 X172.331 Y153.987 E.05035
G1 X173.954 Y152.363 E.09319
G1 X172.714 Y152.363 E.05035
G1 X171.09 Y153.987 E.09319
G1 X169.85 Y153.987 E.05035
G1 X171.473 Y152.363 E.09319
G1 X170.233 Y152.363 E.05035
G1 X168.869 Y153.728 E.07832
; CHANGE_LAYER
; Z_HEIGHT: 9.6
; LAYER_HEIGHT: 0.152381
; WIPE_START
G1 F4800
G1 X170.233 Y152.363 E-.73315
G1 X170.304 Y152.363 E-.02685
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 71/85
; update layer progress
M73 L71
M991 S0 P70 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 5
M204 S10000
G17
G3 Z9.848 I-1.191 J-.249 P1  F60000
G1 X167.083 Y167.77 Z9.848
G1 Z9.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
; LAYER_HEIGHT: 0.2
G1 F2152
M204 S8000
G1 X167.013 Y167.826 E.00296
G3 X165.519 Y163.834 I-1.264 J-1.802 E.26643
G1 X165.729 Y163.822 E.00698
G3 X167.334 Y167.551 I.02 J2.201 E.17135
G1 X167.128 Y167.731 E.00907
; COOLING_NODE: 5
M204 S250
G1 X166.829 Y167.474 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1952
M204 S5000
G1 X166.787 Y167.505 E.0016
G3 X165.561 Y164.225 I-1.038 J-1.481 E.2028
G1 X165.733 Y164.215 E.00529
G3 X167.051 Y167.28 I.016 J1.809 E.13049
G1 X166.874 Y167.434 E.00721
; COOLING_NODE: 5
; WIPE_START
G1 F9547.055
M204 S8000
G1 X166.787 Y167.505 E-.0426
G1 X166.486 Y167.679 E-.13219
G1 X166.143 Y167.792 E-.13704
G1 X165.782 Y167.835 E-.13833
G1 X165.435 Y167.808 E-.13227
G1 X165.101 Y167.715 E-.13169
G1 X164.993 Y167.661 E-.04589
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X168.938 Y165.804 Z10 F60000
G1 Z9.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2152
M204 S8000
G1 X168.947 Y166.084 E.00928
G3 X165.808 Y162.828 I-3.197 J-.059 E.49976
G1 X165.915 Y162.831 E.00353
G3 X168.935 Y165.744 I-.165 J3.193 E.15182
; COOLING_NODE: 0
M204 S250
G1 X169.329 Y165.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1884
M204 S5000
G1 X169.339 Y166.089 E.00917
G3 X165.814 Y162.436 I-3.589 J-.064 E.5197
G1 X165.937 Y162.44 E.00379
G3 X169.326 Y165.712 I-.187 J3.584 E.15788
G1 X169.327 Y165.73 E.00058
M204 S10000
G1 X168.438 Y165.789 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.631699
G1 F2152
M204 S8000
G3 X163.051 Y166.088 I-2.689 J.239 E.41551
G1 X163.05 Y166.057 E.00147
G3 X163.057 Y165.837 I4.245 J.016 E.01059
G3 X168.432 Y165.73 I2.693 J.192 E.38329
; COOLING_NODE: 1
; WIPE_START
G1 F6114.352
G1 X168.448 Y166.077 E-.13224
G1 X168.405 Y166.513 E-.16633
G1 X168.343 Y166.777 E-.10334
G1 X168.264 Y167.009 E-.09315
G1 X168.04 Y167.456 E-.18996
G1 X167.927 Y167.618 E-.07499
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X167.911 Y159.986 Z10 F60000
G1 X167.898 Y153.573 Z10
G1 Z9.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2152
M204 S8000
G1 X162.702 Y153.573 E.17236
G1 X162.702 Y152.777 E.0264
G1 X167.898 Y152.777 E.17236
G1 X167.898 Y153.513 E.02441
; COOLING_NODE: 1
M204 S250
G1 X168.29 Y153.965 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1956
M204 S5000
G1 X162.31 Y153.965 E.18375
G1 X162.31 Y152.385 E.04855
G1 X168.29 Y152.385 E.18375
G1 X168.29 Y153.905 E.04671
M204 S10000
G1 X167.694 Y153.175 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F2152
M204 S8000
G1 X162.906 Y153.175 E.15172
; COOLING_NODE: 4
; WIPE_START
G1 F9259.259
G1 X164.906 Y153.175 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.588 Y156.863 Z10 F60000
G1 X186.124 Y164.884 Z10
G1 Z9.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2152
M204 S8000
G1 X186.261 Y165.132 E.00942
G3 X184.019 Y163.834 I-2.013 J.891 E.36691
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X184.229 Y163.822 E.00698
G3 X186.054 Y164.764 I.02 J2.201 E.07088
G1 X186.094 Y164.832 E.0026
; COOLING_NODE: 4
M204 S250
G1 X185.783 Y165.076 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1952
M204 S5000
G1 X185.903 Y165.29 E.00753
G3 X184.061 Y164.225 I-1.654 J.734 E.27935
G1 X184.233 Y164.215 E.00529
G3 X185.732 Y164.988 I.016 J1.809 E.05392
G1 X185.753 Y165.024 E.0013
; COOLING_NODE: 4
; WIPE_START
G1 F9547.055
M204 S8000
G1 X185.903 Y165.29 E-.11595
G1 X186.014 Y165.619 E-.13173
G1 X186.06 Y165.993 E-.1433
G1 X186.033 Y166.34 E-.13219
G1 X185.94 Y166.673 E-.13156
G1 X185.817 Y166.921 E-.10527
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X181.488 Y164.419 Z10 F60000
G1 Z9.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2152
M204 S8000
G1 X181.631 Y164.191 E.00892
G3 X184.308 Y162.828 I2.619 J1.831 E.10375
G1 X184.415 Y162.831 E.00353
G3 X181.454 Y164.475 I-.165 J3.191 E.54765
G1 X181.457 Y164.47 E.00018
; COOLING_NODE: 0
M204 S250
G1 X181.156 Y164.211 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1884
M204 S5000
G1 X181.31 Y163.966 E.0089
G3 X184.314 Y162.436 I2.94 J2.056 E.10783
G1 X184.437 Y162.44 E.00379
G3 X181.111 Y164.285 I-.187 J3.583 E.56945
G1 X181.125 Y164.263 E.0008
M204 S10000
G1 X181.901 Y164.7 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.631686
G1 F2152
M204 S8000
G1 X181.966 Y164.589 E.00616
G3 X181.551 Y166.085 I2.283 J1.439 E.73798
G1 X181.551 Y166.056 E.00142
G3 X181.557 Y165.837 I4.209 J.016 E.01051
G3 X181.838 Y164.815 I2.692 J.191 E.05118
G1 X181.873 Y164.752 E.00342
; COOLING_NODE: 1
; WIPE_START
G1 F6114.489
G1 X181.966 Y164.589 E-.07158
G1 X182.123 Y164.362 E-.10482
G1 X182.297 Y164.161 E-.10121
G1 X182.479 Y163.988 E-.09524
G1 X182.728 Y163.795 E-.11949
G1 X182.9 Y163.688 E-.07735
G1 X183.186 Y163.544 E-.12163
G1 X183.355 Y163.479 E-.06867
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X182.397 Y155.907 Z10 F60000
G1 X182.102 Y153.573 Z10
G1 Z9.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2152
M204 S8000
G1 X182.102 Y152.777 E.0264
G1 X187.298 Y152.777 E.17236
G1 X187.298 Y153.573 E.0264
G1 X182.162 Y153.573 E.17037
; COOLING_NODE: 1
M204 S250
G1 X181.71 Y153.965 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1956
M204 S5000
G1 X181.71 Y152.385 E.04855
G1 X187.69 Y152.385 E.18375
G1 X187.69 Y153.965 E.04855
G1 X181.77 Y153.965 E.18191
M204 S10000
G1 X182.306 Y153.175 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F2152
M204 S8000
G1 X187.094 Y153.175 E.15172
; CHANGE_LAYER
; Z_HEIGHT: 9.72381
; LAYER_HEIGHT: 0.123809
; WIPE_START
G1 F9259.259
G1 X185.094 Y153.175 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 72/85
; update layer progress
M73 L72
M991 S0 P71 ;notify layer change

; OBJECT_ID: 15
M204 S10000
G17
G3 Z10 I-.168 J-1.205 P1  F60000
G1 X181.131 Y153.728 Z10
G1 Z9.724
G1 E.8 F1800
; FEATURE: Support interface
; LINE_WIDTH: 0.42
; LAYER_HEIGHT: 0.27619
G1 F2151
M204 S8000
G1 X179.767 Y152.363 E.07832
G1 X178.527 Y152.363 E.05035
G1 X180.15 Y153.987 E.09319
G1 X178.91 Y153.987 E.05035
G1 X177.286 Y152.363 E.09319
G1 X176.046 Y152.363 E.05035
G1 X177.669 Y153.987 E.09319
G1 X176.429 Y153.987 E.05035
G1 X174.806 Y152.363 E.09319
G1 X173.565 Y152.363 E.05035
G1 X175.189 Y153.987 E.09319
G1 X173.948 Y153.987 E.05035
G1 X172.325 Y152.363 E.09319
G1 X171.084 Y152.363 E.05035
G1 X172.708 Y153.987 E.09319
G1 X171.467 Y153.987 E.05035
G1 X169.844 Y152.363 E.09319
G1 X169.038 Y152.363 E.0327
M73 P86 R2
G1 X169.038 Y152.798 E.01765
G1 X170.397 Y154.156 E.07798
; WIPE_START
G1 F4800
G1 X169.038 Y152.798 E-.72995
G1 X169.038 Y152.719 E-.03005
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z10.124 I1.217 J0 P1  F60000
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    
        M993 A2 B2 C2
        M993 A0 B0 C0
    

    
        M622.1 S0 ; for prev firmware, default turn off
        M1002 set_flag smooth_safe_pos_suppoprt_flag=1
        M1002 judge_flag smooth_safe_pos_suppoprt_flag
        
        M622 J0
            

            
                M9711 M0 E1 X256 Y153 Z9.72381 S11 C10 O0 T3000
            

            
        M623

        M622 J1
            

            
                M9711 M0 E1 U256 V153 Z9.72381 S11 C10 O0 T3000
            

            
        M623
    
    
    
        M993 A3 B3 C3
    
M623
; SKIPPABLE_END

G1 Z10.124
; CHANGE_LAYER
; Z_HEIGHT: 9.8
; LAYER_HEIGHT: 0.0761909
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 73/85
; update layer progress
M73 L73
M991 S0 P72 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 5
G1 X167.086 Y167.767
G1 Z9.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
; LAYER_HEIGHT: 0.2
G1 F2151
M204 S8000
G1 X167.006 Y167.831 E.00339
G3 X165.517 Y163.835 I-1.257 J-1.807 E.26608
G1 X165.718 Y163.823 E.00666
G3 X167.332 Y167.553 I.031 J2.201 E.17185
G1 X167.132 Y167.727 E.00882
; COOLING_NODE: 5
M204 S250
G1 X166.833 Y167.469 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1964
M204 S5000
G1 X166.783 Y167.508 E.00195
G3 X165.56 Y164.225 I-1.034 J-1.485 E.2026
G1 X165.723 Y164.215 E.00501
G3 X167.051 Y167.281 I.027 J1.809 E.13085
G1 X166.878 Y167.43 E.00699
; COOLING_NODE: 5
; WIPE_START
G1 F9547.055
M204 S8000
G1 X166.783 Y167.508 E-.04686
G1 X166.458 Y167.691 E-.14184
G1 X166.126 Y167.796 E-.13224
G1 X165.782 Y167.835 E-.13161
G1 X165.434 Y167.808 E-.13246
G1 X165.1 Y167.715 E-.13172
G1 X164.999 Y167.664 E-.04326
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X168.941 Y165.83 Z10.2 F60000
G1 Z9.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2151
M204 S8000
G1 X168.943 Y165.855 E.00085
G3 X165.757 Y162.827 I-3.193 J.169 E.50567
G1 X165.917 Y162.832 E.00531
G3 X168.916 Y165.58 I-.167 J3.193 E.14626
G1 X168.935 Y165.77 E.00635
; COOLING_NODE: 0
M204 S250
G1 X169.331 Y165.792 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1890
M204 S5000
G1 X169.336 Y165.837 E.00137
G3 X165.759 Y162.435 I-3.585 J.188 E.5258
G1 X165.938 Y162.44 E.00549
G3 X169.306 Y165.525 I-.187 J3.585 E.15211
G1 X169.325 Y165.732 E.0064
M204 S10000
G1 X168.438 Y165.782 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.63169
G1 F2151
M204 S8000
G1 X168.45 Y165.996 E.01029
G3 X163.051 Y166.087 I-2.699 J.037 E.40613
G1 X163.05 Y166.057 E.00146
G1 X163.05 Y166.025 E.00152
G3 X168.432 Y165.722 I2.7 J.009 E.39154
; COOLING_NODE: 1
; WIPE_START
G1 F6114.449
G1 X168.45 Y165.996 E-.10428
G1 X168.44 Y166.256 E-.09863
G1 X168.405 Y166.512 E-.09847
G1 X168.343 Y166.778 E-.10388
G1 X168.264 Y167.01 E-.09298
G1 X168.164 Y167.234 E-.09316
G1 X168.029 Y167.472 E-.1038
G1 X167.931 Y167.611 E-.0648
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X167.913 Y159.978 Z10.2 F60000
G1 X167.898 Y153.573 Z10.2
G1 Z9.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2151
M204 S8000
G1 X162.702 Y153.573 E.17236
G1 X162.702 Y152.777 E.0264
G1 X167.898 Y152.777 E.17236
G1 X167.898 Y153.513 E.02441
; COOLING_NODE: 1
M204 S250
G1 X168.29 Y153.965 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1967
M204 S5000
G1 X162.31 Y153.965 E.18375
G1 X162.31 Y152.385 E.04855
G1 X168.29 Y152.385 E.18375
G1 X168.29 Y153.905 E.04671
M204 S10000
G1 X167.694 Y153.175 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F2151
M204 S8000
G1 X162.906 Y153.175 E.15172
; COOLING_NODE: 4
; WIPE_START
G1 F9259.259
G1 X164.906 Y153.175 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.586 Y156.867 Z10.2 F60000
G1 X186.141 Y164.913 Z10.2
G1 Z9.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2151
M204 S8000
G1 X186.275 Y165.162 E.0094
G3 X184.017 Y163.835 I-2.026 J.861 E.36577
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X184.218 Y163.823 E.00666
G3 X186.074 Y164.792 I.031 J2.201 E.07237
G1 X186.112 Y164.86 E.0026
; COOLING_NODE: 4
M204 S250
G1 X185.798 Y165.1 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1964
M204 S5000
G1 X185.915 Y165.317 E.00759
G3 X184.06 Y164.225 I-1.665 J.707 E.27843
G1 X184.223 Y164.215 E.00501
G3 X185.749 Y165.012 I.027 J1.809 E.05516
G1 X185.769 Y165.047 E.00122
; COOLING_NODE: 4
; WIPE_START
G1 F9547.055
M204 S8000
G1 X185.915 Y165.317 E-.11662
G1 X186.021 Y165.649 E-.13252
G1 X186.06 Y165.994 E-.13184
G1 X186.033 Y166.34 E-.132
G1 X185.94 Y166.675 E-.13188
G1 X185.804 Y166.946 E-.11514
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X181.506 Y164.391 Z10.2 F60000
G1 Z9.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2151
M204 S8000
G1 X181.599 Y164.237 E.00594
G3 X184.257 Y162.827 I2.651 J1.788 E.10391
G1 X184.417 Y162.832 E.00531
G3 X181.427 Y164.524 I-.167 J3.193 E.54612
G1 X181.476 Y164.442 E.00315
; COOLING_NODE: 0
M204 S250
G1 X181.171 Y164.189 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1890
M204 S5000
G1 X181.274 Y164.018 E.00613
G3 X184.259 Y162.435 I2.977 J2.006 E.10809
G1 X184.438 Y162.44 E.00549
G3 X181.081 Y164.34 I-.187 J3.585 E.56792
G1 X181.14 Y164.241 E.00354
M204 S10000
G1 X181.908 Y164.69 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.631691
G1 F2151
M204 S8000
G1 X181.997 Y164.544 E.00821
G3 X181.551 Y166.085 I2.253 J1.487 E.73566
G1 X181.55 Y166.059 E.00124
G1 X181.551 Y166.025 E.00162
G3 X181.854 Y164.786 I2.7 J.006 E.06177
G1 X181.879 Y164.742 E.00243
; COOLING_NODE: 1
; WIPE_START
G1 F6114.439
G1 X181.997 Y164.544 E-.08779
G1 X182.149 Y164.329 E-.10004
G1 X182.321 Y164.136 E-.0982
G1 X182.526 Y163.947 E-.10608
G1 X182.748 Y163.782 E-.10493
G1 X182.958 Y163.655 E-.09321
G1 X183.203 Y163.537 E-.10354
G1 X183.367 Y163.476 E-.06622
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X182.4 Y155.905 Z10.2 F60000
G1 X182.102 Y153.573 Z10.2
G1 Z9.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2151
M204 S8000
G1 X182.102 Y152.777 E.0264
G1 X187.298 Y152.777 E.17236
G1 X187.298 Y153.573 E.0264
G1 X182.162 Y153.573 E.17037
; COOLING_NODE: 1
M204 S250
G1 X181.71 Y153.965 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1967
M204 S5000
G1 X181.71 Y152.385 E.04855
G1 X187.69 Y152.385 E.18375
G1 X187.69 Y153.965 E.04855
G1 X181.77 Y153.965 E.18191
M204 S10000
G1 X182.306 Y153.175 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F2151
M204 S8000
G1 X187.094 Y153.175 E.15172
; CHANGE_LAYER
; Z_HEIGHT: 10
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.259
G1 X185.094 Y153.175 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 74/85
; update layer progress
M73 L74
M991 S0 P73 ;notify layer change

; OBJECT_ID: 15
M204 S10000
G17
G3 Z10.2 I-.214 J-1.198 P1  F60000
G1 X179.603 Y154.156 Z10.2
G1 Z10
G1 E.8 F1800
; FEATURE: Support interface
; LINE_WIDTH: 0.42
; LAYER_HEIGHT: 0.27619
G1 F2149
M204 S8000
G1 X180.962 Y152.798 E.07797
G1 X180.962 Y152.363 E.01764
G1 X180.156 Y152.363 E.03271
G1 X178.533 Y153.987 E.09318
G1 X177.292 Y153.987 E.05035
G1 X178.915 Y152.363 E.09318
G1 X177.675 Y152.363 E.05035
G1 X176.052 Y153.987 E.09318
G1 X174.812 Y153.987 E.05035
G1 X176.435 Y152.363 E.09318
G1 X175.194 Y152.363 E.05035
G1 X173.571 Y153.987 E.09318
G1 X172.331 Y153.987 E.05035
G1 X173.954 Y152.363 E.09318
G1 X172.714 Y152.363 E.05035
G1 X171.091 Y153.987 E.09318
G1 X169.85 Y153.987 E.05035
G1 X171.473 Y152.363 E.09318
G1 X170.233 Y152.363 E.05035
G1 X168.869 Y153.728 E.07831
; COOLING_NODE: 5
; WIPE_START
G1 F4800
G1 X170.233 Y152.363 E-.7331
G1 X170.304 Y152.363 E-.02691
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X168.735 Y159.833 Z10.4 F60000
G1 X167.066 Y167.781 Z10.4
G1 Z10
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
; LAYER_HEIGHT: 0.2
G1 F2149
M204 S8000
M73 P87 R2
G1 X166.791 Y167.962 E.01093
G3 X165.52 Y163.834 I-1.042 J-1.939 E.25783
G1 X165.74 Y163.822 E.00733
G3 X167.162 Y167.711 I.008 J2.201 E.17877
G1 X167.114 Y167.746 E.00194
; COOLING_NODE: 5
M204 S250
G1 X166.847 Y167.457 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1984
M204 S5000
G1 X166.605 Y167.618 E.00892
G3 X165.561 Y164.225 I-.856 J-1.594 E.19623
G1 X165.743 Y164.215 E.00559
G3 X166.911 Y167.41 I.006 J1.809 E.13605
G1 X166.895 Y167.422 E.00061
; COOLING_NODE: 5
; WIPE_START
G1 F9547.055
M204 S8000
G1 X166.605 Y167.618 E-.13305
G1 X166.28 Y167.756 E-.13423
G1 X165.939 Y167.825 E-.13211
G1 X165.561 Y167.825 E-.14386
G1 X165.22 Y167.756 E-.13208
G1 X165.014 Y167.671 E-.08466
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X168.941 Y165.832 Z10.4 F60000
G1 Z10
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2149
M204 S8000
G1 X168.944 Y165.858 E.00084
G3 X165.766 Y162.827 I-3.193 J.167 E.50579
G1 X165.917 Y162.832 E.00501
G3 X168.918 Y165.582 I-.165 J3.193 E.14637
G1 X168.935 Y165.773 E.00636
; COOLING_NODE: 0
M204 S250
G1 X169.331 Y165.795 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1898
M204 S5000
G1 X169.337 Y165.837 E.00131
G3 X165.769 Y162.435 I-3.584 J.187 E.52598
G1 X165.937 Y162.44 E.00519
G3 X169.307 Y165.526 I-.185 J3.585 E.15218
G1 X169.326 Y165.735 E.00645
M204 S10000
G1 X168.434 Y165.759 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.631696
G1 F2149
M204 S8000
G1 X168.445 Y166.166 E.01954
G3 X163.05 Y166.04 I-2.696 J-.14 E.39941
G1 X163.05 Y166.025 E.00074
G3 X163.063 Y165.759 I6.638 J.205 E.01277
G3 X168.429 Y165.699 I2.686 J.266 E.37836
; COOLING_NODE: 1
; WIPE_START
G1 F6114.379
G1 X168.445 Y166.166 E-.1775
G1 X168.389 Y166.595 E-.16445
G1 X168.332 Y166.815 E-.08625
G1 X168.236 Y167.08 E-.10714
G1 X168.11 Y167.338 E-.10928
G1 X167.989 Y167.535 E-.08785
G1 X167.945 Y167.593 E-.02753
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X167.919 Y159.961 Z10.4 F60000
G1 X167.898 Y153.573 Z10.4
G1 Z10
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2149
M204 S8000
G1 X162.702 Y153.573 E.17236
G1 X162.702 Y152.777 E.0264
G1 X167.898 Y152.777 E.17236
G1 X167.898 Y153.513 E.02441
; COOLING_NODE: 1
M204 S250
G1 X168.29 Y153.965 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1986
M204 S5000
G1 X162.31 Y153.965 E.18375
G1 X162.31 Y152.385 E.04855
G1 X168.29 Y152.385 E.18375
G1 X168.29 Y153.905 E.04671
M204 S10000
G1 X167.694 Y153.175 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F2149
M204 S8000
G1 X162.906 Y153.175 E.15172
; COOLING_NODE: 4
; WIPE_START
G1 F9259.259
G1 X164.906 Y153.175 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.586 Y156.866 Z10.4 F60000
G1 X186.142 Y164.908 Z10.4
G1 Z10
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2149
M204 S8000
G1 X186.176 Y164.961 E.00209
G3 X184.02 Y163.834 I-1.928 J1.063 E.3733
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X184.24 Y163.822 E.00733
G3 X185.938 Y164.612 I.008 J2.201 E.06414
G1 X186.108 Y164.859 E.00995
; COOLING_NODE: 4
M204 S250
G1 X185.82 Y165.129 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1984
M204 S5000
G1 X185.833 Y165.149 E.00074
G3 X184.061 Y164.225 I-1.584 J.875 E.2842
G1 X184.243 Y164.215 E.00559
G3 X185.636 Y164.863 I.006 J1.809 E.04877
G1 X185.786 Y165.079 E.0081
; COOLING_NODE: 4
; WIPE_START
G1 F9547.055
M204 S8000
G1 X185.833 Y165.149 E-.03194
G1 X185.972 Y165.467 E-.13164
G1 X186.05 Y165.835 E-.14329
G1 X186.05 Y166.214 E-.14403
G1 X185.981 Y166.555 E-.13215
G1 X185.848 Y166.876 E-.13189
G1 X185.782 Y166.974 E-.04506
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X181.522 Y164.359 Z10.4 F60000
G1 Z10
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2149
M204 S8000
G1 X181.541 Y164.329 E.00117
G3 X184.266 Y162.827 I2.711 J1.695 E.1078
G1 X184.417 Y162.832 E.00501
G3 X181.378 Y164.624 I-.165 J3.193 E.5424
G1 X181.493 Y164.412 E.008
; COOLING_NODE: 0
M204 S250
G1 X181.18 Y164.17 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1898
M204 S5000
G1 X181.208 Y164.123 E.00166
G3 X184.269 Y162.435 I3.044 J1.901 E.11218
G1 X184.437 Y162.44 E.00519
G3 X181.026 Y164.452 I-.185 J3.585 E.56404
G1 X181.151 Y164.222 E.00804
M204 S10000
G1 X181.912 Y164.68 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.631691
G1 F2149
M204 S8000
G1 X182.009 Y164.519 E.00904
G3 X181.55 Y166.04 I2.24 J1.506 E.73631
G1 X181.55 Y166.025 E.00074
G3 X181.563 Y165.758 I6.608 J.203 E.01282
G3 X181.875 Y164.741 I2.686 J.267 E.05137
G1 X181.881 Y164.731 E.00054
; COOLING_NODE: 1
; WIPE_START
G1 F6114.432
G1 X182.009 Y164.519 E-.0944
G1 X182.164 Y164.311 E-.09848
G1 X182.337 Y164.119 E-.09822
G1 X182.529 Y163.945 E-.09838
G1 X182.752 Y163.779 E-.10579
G1 X182.959 Y163.654 E-.0918
G1 X183.211 Y163.533 E-.10619
G1 X183.376 Y163.473 E-.06674
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X182.402 Y155.903 Z10.4 F60000
G1 X182.102 Y153.573 Z10.4
G1 Z10
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2149
M204 S8000
G1 X182.102 Y152.777 E.0264
G1 X187.298 Y152.777 E.17236
G1 X187.298 Y153.573 E.0264
G1 X182.162 Y153.573 E.17037
; COOLING_NODE: 1
M204 S250
G1 X181.71 Y153.965 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1986
M204 S5000
G1 X181.71 Y152.385 E.04855
G1 X187.69 Y152.385 E.18375
G1 X187.69 Y153.965 E.04855
G1 X181.77 Y153.965 E.18191
M204 S10000
G1 X182.306 Y153.175 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F2149
M204 S8000
G1 X187.094 Y153.175 E.15172
; CHANGE_LAYER
; Z_HEIGHT: 10.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.259
G1 X185.094 Y153.175 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 75/85
; update layer progress
M73 L75
M991 S0 P74 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 5
M204 S10000
G17
G3 Z10.4 I-.766 J-.946 P1  F60000
G1 X167.098 Y167.757 Z10.4
G1 Z10.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1875
M204 S8000
G1 X167.012 Y167.827 E.00367
G3 X165.519 Y163.834 I-1.263 J-1.803 E.26644
G1 X165.729 Y163.822 E.00699
G3 X167.334 Y167.552 I.019 J2.202 E.17137
G1 X167.143 Y167.718 E.00839
; COOLING_NODE: 5
M204 S250
G1 X166.844 Y167.46 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1875
M204 S5000
G1 X166.787 Y167.506 E.00224
G3 X165.561 Y164.225 I-1.038 J-1.482 E.20283
G1 X165.733 Y164.215 E.0053
G3 X167.051 Y167.281 I.016 J1.809 E.13051
G1 X166.889 Y167.421 E.00658
; COOLING_NODE: 5
; WIPE_START
G1 F9547.055
M204 S8000
G1 X166.787 Y167.506 E-.05052
G1 X166.458 Y167.691 E-.14359
G1 X166.125 Y167.796 E-.13244
G1 X165.781 Y167.835 E-.13153
G1 X165.436 Y167.808 E-.13171
G1 X165.101 Y167.715 E-.13205
G1 X165.011 Y167.67 E-.03815
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X168.941 Y165.838 Z10.6 F60000
G1 Z10.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1875
M204 S8000
G1 X168.945 Y165.858 E.00068
G3 X165.775 Y162.827 I-3.193 J.166 E.50605
M73 P87 R1
G1 X165.916 Y162.832 E.00469
G3 X168.91 Y165.524 I-.164 J3.193 E.14448
G1 X168.935 Y165.778 E.00848
; COOLING_NODE: 0
M204 S250
M73 P88 R1
G1 X169.331 Y165.797 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1875
M204 S5000
G1 X169.337 Y165.838 E.00126
G3 X165.778 Y162.435 I-3.584 J.187 E.52624
G1 X165.937 Y162.44 E.0049
G3 X169.298 Y165.463 I-.185 J3.585 E.15025
G1 X169.325 Y165.737 E.00847
M204 S10000
G1 X168.437 Y165.782 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.631691
G1 F1875
M204 S8000
G1 X168.45 Y166.025 E.01168
G3 X163.051 Y166.087 I-2.7 J0 E.4039
G1 X163.05 Y166.059 E.00136
G3 X163.057 Y165.829 I4.429 J.02 E.01104
G3 X168.433 Y165.722 I2.693 J.196 E.38294
; COOLING_NODE: 1
; WIPE_START
G1 F6114.439
G1 X168.45 Y166.025 E-.11529
G1 X168.407 Y166.505 E-.18318
G1 X168.353 Y166.742 E-.09233
G1 X168.265 Y167.007 E-.10626
G1 X168.163 Y167.236 E-.0951
G1 X168.02 Y167.486 E-.10943
G1 X167.931 Y167.611 E-.0584
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X167.913 Y159.979 Z10.6 F60000
G1 X167.898 Y153.573 Z10.6
G1 Z10.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1875
M204 S8000
G1 X162.702 Y153.573 E.17236
G1 X162.702 Y152.777 E.0264
G1 X167.898 Y152.777 E.17236
G1 X167.898 Y153.513 E.02441
; COOLING_NODE: 1
M204 S250
G1 X168.29 Y153.965 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1875
M204 S5000
G1 X162.31 Y153.965 E.18375
G1 X162.31 Y152.385 E.04855
G1 X168.29 Y152.385 E.18375
G1 X168.29 Y153.905 E.04671
M204 S10000
G1 X167.694 Y153.175 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1875
M204 S8000
G1 X162.906 Y153.175 E.15172
; COOLING_NODE: 4
; WIPE_START
G1 F9259.259
G1 X164.906 Y153.175 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.579 Y156.878 Z10.6 F60000
G1 X186.175 Y164.978 Z10.6
G1 Z10.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1875
M204 S8000
G1 X186.275 Y165.163 E.007
G3 X184.019 Y163.834 I-2.026 J.861 E.36585
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X184.229 Y163.822 E.00699
G3 X186.055 Y164.765 I.019 J2.202 E.07089
G1 X186.145 Y164.926 E.00612
; COOLING_NODE: 4
M204 S250
G1 X185.833 Y165.167 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1875
M204 S5000
G1 X185.915 Y165.317 E.00526
G3 X184.061 Y164.225 I-1.666 J.707 E.2785
G1 X184.233 Y164.215 E.0053
G3 X185.733 Y164.988 I.016 J1.809 E.05393
G1 X185.804 Y165.115 E.00447
; COOLING_NODE: 4
; WIPE_START
G1 F9547.055
M204 S8000
G1 X185.915 Y165.317 E-.08781
G1 X186.021 Y165.649 E-.13228
G1 X186.06 Y165.993 E-.13173
G1 X186.033 Y166.339 E-.13182
G1 X185.94 Y166.674 E-.13202
G1 X185.777 Y166.997 E-.13727
G1 X185.766 Y167.011 E-.00707
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X181.528 Y164.35 Z10.6 F60000
G1 Z10.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1875
M204 S8000
G1 X181.699 Y164.1 E.01006
G3 X184.275 Y162.827 I2.553 J1.924 E.09884
G1 X184.416 Y162.832 E.00469
G3 X181.497 Y164.402 I-.164 J3.193 E.55078
; COOLING_NODE: 0
M204 S250
G1 X181.203 Y164.131 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1875
M204 S5000
G1 X181.385 Y163.866 E.0099
G3 X184.278 Y162.435 I2.867 J2.159 E.10284
G1 X184.437 Y162.44 E.0049
G3 X181.172 Y164.183 I-.185 J3.585 E.57348
M204 S10000
G1 X181.943 Y164.629 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.631707
G1 F1875
M204 S8000
G1 X181.983 Y164.566 E.00357
G3 X181.551 Y166.09 I2.267 J1.466 E.73669
G1 X181.55 Y166.06 E.00141
G1 X181.551 Y166.025 E.00169
G3 X181.854 Y164.79 I2.7 J.008 E.06161
G1 X181.914 Y164.681 E.00594
; COOLING_NODE: 1
; WIPE_START
G1 F6114.267
G1 X181.983 Y164.566 E-.05104
G1 X182.132 Y164.35 E-.09984
G1 X182.319 Y164.138 E-.1073
G1 X182.522 Y163.951 E-.10504
G1 X182.717 Y163.803 E-.09289
G1 X182.954 Y163.657 E-.10589
G1 X183.203 Y163.537 E-.10499
G1 X183.433 Y163.452 E-.09302
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X182.414 Y155.888 Z10.6 F60000
G1 X182.102 Y153.573 Z10.6
G1 Z10.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1875
M204 S8000
G1 X182.102 Y152.777 E.0264
G1 X187.298 Y152.777 E.17236
G1 X187.298 Y153.573 E.0264
G1 X182.162 Y153.573 E.17037
; COOLING_NODE: 1
M204 S250
G1 X181.71 Y153.965 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1875
M204 S5000
G1 X181.71 Y152.385 E.04855
G1 X187.69 Y152.385 E.18375
G1 X187.69 Y153.965 E.04855
G1 X181.77 Y153.965 E.18191
M204 S10000
G1 X182.306 Y153.175 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1875
M204 S8000
G1 X187.094 Y153.175 E.15172
; CHANGE_LAYER
; Z_HEIGHT: 10.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.259
G1 X185.094 Y153.175 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 76/85
; update layer progress
M73 L76
M991 S0 P75 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 5
M204 S10000
G17
G3 Z10.6 I-.766 J-.946 P1  F60000
G1 X167.103 Y167.753 Z10.6
G1 Z10.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2331
M204 S8000
G1 X167.012 Y167.827 E.00392
G3 X165.518 Y163.835 I-1.262 J-1.804 E.26629
G1 X165.719 Y163.823 E.00667
G3 X167.335 Y167.551 I.031 J2.201 E.17172
G1 X167.148 Y167.713 E.0082
; COOLING_NODE: 5
M204 S250
G1 X166.849 Y167.456 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2063
M204 S5000
G1 X166.787 Y167.506 E.00246
G3 X165.56 Y164.225 I-1.037 J-1.482 E.20273
G1 X165.723 Y164.215 E.00502
G3 X167.052 Y167.28 I.026 J1.809 E.13079
G1 X166.894 Y167.417 E.0064
; COOLING_NODE: 5
; WIPE_START
G1 F9547.055
M204 S8000
G1 X166.787 Y167.506 E-.0532
G1 X166.482 Y167.681 E-.13348
G1 X166.128 Y167.795 E-.14158
G1 X165.783 Y167.835 E-.1319
G1 X165.436 Y167.808 E-.13206
G1 X165.101 Y167.715 E-.13214
G1 X165.017 Y167.673 E-.03565
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X168.938 Y165.82 Z10.8 F60000
G1 Z10.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2331
M204 S8000
G1 X168.949 Y166.082 E.00871
G3 X165.784 Y162.828 I-3.197 J-.057 E.49892
G1 X165.916 Y162.832 E.00438
G3 X168.937 Y165.746 I-.164 J3.193 E.1519
G1 X168.937 Y165.76 E.00046
; COOLING_NODE: 0
M204 S250
G1 X169.33 Y165.806 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1926
M204 S5000
G1 X169.342 Y166.088 E.00869
G3 X165.788 Y162.435 I-3.589 J-.064 E.51883
G1 X165.937 Y162.44 E.0046
G3 X169.329 Y165.712 I-.184 J3.585 E.15795
G1 X169.329 Y165.746 E.00105
M204 S10000
G1 X168.429 Y165.816 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.631701
G1 F2331
M204 S8000
G1 X168.449 Y166.074 E.01243
G3 X163.051 Y166.091 I-2.699 J-.051 E.40113
G1 X163.051 Y166.063 E.00135
G3 X163.056 Y165.845 I4.178 J-.006 E.01045
G3 X168.409 Y165.561 I2.694 J.177 E.3761
M73 P89 R1
G1 X168.424 Y165.756 E.00938
; COOLING_NODE: 4
; WIPE_START
G1 F6114.336
G1 X168.449 Y166.074 E-.12126
G1 X168.407 Y166.505 E-.16447
G1 X168.351 Y166.747 E-.09429
G1 X168.265 Y167.007 E-.10447
G1 X168.04 Y167.456 E-.19057
G1 X167.912 Y167.639 E-.08495
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.466 Y166.546 Z10.8 F60000
G1 X186.187 Y164.995 Z10.8
G1 Z10.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2331
M204 S8000
G1 X186.262 Y165.132 E.00517
G3 X184.018 Y163.835 I-2.013 J.892 E.36686
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X184.219 Y163.823 E.00667
G3 X186.055 Y164.765 I.031 J2.201 E.07126
G1 X186.157 Y164.943 E.00683
; COOLING_NODE: 4
M204 S250
G1 X185.846 Y165.187 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2063
M204 S5000
G1 X185.903 Y165.29 E.0036
G3 X184.06 Y164.225 I-1.653 J.734 E.27933
G1 X184.223 Y164.215 E.00502
G3 X185.733 Y164.988 I.026 J1.809 E.05424
G1 X185.817 Y165.135 E.00521
; COOLING_NODE: 4
; WIPE_START
G1 F9547.055
M204 S8000
G1 X185.903 Y165.29 E-.06733
G1 X186.02 Y165.647 E-.14288
G1 X186.06 Y165.992 E-.13193
G1 X186.033 Y166.339 E-.13224
G1 X185.94 Y166.674 E-.13202
G1 X185.783 Y166.988 E-.1336
G1 X185.75 Y167.03 E-.01998
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X181.547 Y164.324 Z10.8 F60000
G1 Z10.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2331
M204 S8000
G1 X181.632 Y164.192 E.0052
G3 X184.284 Y162.828 I2.62 J1.832 E.10292
G1 X184.416 Y162.832 E.00438
G3 X181.455 Y164.476 I-.164 J3.193 E.54798
G1 X181.516 Y164.376 E.00389
; COOLING_NODE: 0
M204 S250
G1 X181.215 Y164.117 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1926
M204 S5000
G1 X181.311 Y163.968 E.00545
G3 X184.288 Y162.435 I2.942 J2.057 E.10701
G1 X184.437 Y162.44 E.0046
G3 X181.113 Y164.286 I-.184 J3.585 E.56983
G1 X181.184 Y164.168 E.00423
M204 S10000
G1 X181.957 Y164.593 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.631686
G1 F2331
M204 S8000
G3 X181.552 Y166.122 I2.293 J1.425 E.73681
G1 X181.551 Y166.063 E.00281
G3 X181.926 Y164.644 I2.699 J-.045 E.07133
; COOLING_NODE: 1
; WIPE_START
G1 F6114.486
G1 X182.123 Y164.361 E-.13106
G1 X182.297 Y164.161 E-.10071
G1 X182.5 Y163.969 E-.1061
G1 X182.694 Y163.819 E-.09338
G1 X182.927 Y163.671 E-.10478
G1 X183.178 Y163.548 E-.10614
G1 X183.407 Y163.46 E-.0933
G1 X183.469 Y163.443 E-.02452
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X177.071 Y159.282 Z10.8 F60000
G1 X168.292 Y153.573 Z10.8
G1 Z10.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2331
M204 S8000
G1 X162.702 Y153.573 E.18543
G1 X162.702 Y152.777 E.0264
G1 X164.718 Y152.777 E.06686
G1 X165.118 Y152.777 E.01327
G1 X165.518 Y152.777 E.01327
G1 X165.918 Y152.777 E.01327
G1 X166.318 Y152.777 E.01327
G1 X166.718 Y152.777 E.01327
G1 X167.118 Y152.777 E.01327
G1 X167.518 Y152.777 E.01327
G1 X167.918 Y152.777 E.01327
G1 X168.318 Y152.777 E.01327
G1 F1800
G1 X168.7 Y152.777 E.01269
; FEATURE: Overhang wall
G1 F3000
M204 S5000
G1 X181.3 Y152.777 E.41797
; FEATURE: Inner wall
G1 F1800
M204 S8000
G1 X181.683 Y152.777 E.01269
G1 F2331
G1 X182.083 Y152.777 E.01327
G1 X182.483 Y152.777 E.01327
G1 X182.883 Y152.777 E.01327
G1 X183.283 Y152.777 E.01327
G1 X183.683 Y152.777 E.01327
G1 X184.083 Y152.777 E.01327
G1 X184.483 Y152.777 E.01327
G1 X184.883 Y152.777 E.01327
G1 X185.283 Y152.777 E.01327
G1 X187.298 Y152.777 E.06686
G1 X187.298 Y153.573 E.0264
G1 X185.283 Y153.573 E.06686
G1 X184.883 Y153.573 E.01327
G1 X184.483 Y153.573 E.01327
G1 X184.083 Y153.573 E.01327
G1 X183.683 Y153.573 E.01327
G1 X183.283 Y153.573 E.01327
G1 X182.883 Y153.573 E.01327
G1 X182.483 Y153.573 E.01327
G1 X182.083 Y153.573 E.01327
G1 X181.683 Y153.573 E.01327
G1 F1800
G1 X181.3 Y153.573 E.01269
; FEATURE: Overhang wall
G1 F3000
M204 S5000
G1 X168.7 Y153.573 E.41797
; FEATURE: Inner wall
G1 F1800
M204 S8000
G1 X168.352 Y153.573 E.01154
; COOLING_NODE: 1
M204 S250
G1 X168.292 Y153.965 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2063
M204 S5000
G1 X162.31 Y153.965 E.18381
G1 X162.31 Y152.385 E.04855
G1 X164.731 Y152.385 E.07439
G1 X165.131 Y152.385 E.01229
G1 X165.531 Y152.385 E.01229
G1 X165.931 Y152.385 E.01229
G1 X166.331 Y152.385 E.01229
G1 X166.731 Y152.385 E.01229
G1 X167.131 Y152.385 E.01229
G1 X167.531 Y152.385 E.01229
G1 X167.931 Y152.385 E.01229
G1 X168.331 Y152.385 E.01229
G1 F1800
G1 X168.7 Y152.385 E.01134
; FEATURE: Overhang wall
; LINE_WIDTH: 0.45
G1 F3000
G1 X181.3 Y152.385 E.41797
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1800
G1 X181.669 Y152.385 E.01134
G1 F2063
G1 X182.069 Y152.385 E.01229
G1 X182.469 Y152.385 E.01229
G1 X182.869 Y152.385 E.01229
G1 X183.269 Y152.385 E.01229
G1 X183.669 Y152.385 E.01229
G1 X184.069 Y152.385 E.01229
G1 X184.469 Y152.385 E.01229
G1 X184.869 Y152.385 E.01229
G1 X185.269 Y152.385 E.01229
G1 X187.69 Y152.385 E.07439
G1 X187.69 Y153.965 E.04855
G1 X185.269 Y153.965 E.07439
G1 X184.869 Y153.965 E.01229
G1 X184.469 Y153.965 E.01229
G1 X184.069 Y153.965 E.01229
G1 X183.669 Y153.965 E.01229
G1 X183.269 Y153.965 E.01229
G1 X182.869 Y153.965 E.01229
G1 X182.469 Y153.965 E.01229
G1 X182.069 Y153.965 E.01229
G1 X181.669 Y153.965 E.01229
G1 F1800
G1 X181.3 Y153.965 E.01134
; FEATURE: Overhang wall
; LINE_WIDTH: 0.45
G1 F3000
G1 X168.7 Y153.965 E.41797
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1800
G1 X168.352 Y153.965 E.01069
; WIPE_START
M204 S8000
G1 X166.352 Y153.965 E-.76
; WIPE_END
G1 E-.04
M204 S10000
G1 X162.906 Y153.175 Z10.8 F60000
G1 Z10.4
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F2331
M204 S8000
G1 X187.094 Y153.175 E.76636
; CHANGE_LAYER
; Z_HEIGHT: 10.6
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F9259.259
G1 X185.094 Y153.175 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 77/85
; update layer progress
M73 L77
M991 S0 P76 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 5
M204 S10000
G17
G3 Z10.8 I-.766 J-.945 P1  F60000
G1 X167.08 Y167.773 Z10.8
G1 Z10.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2353
M204 S8000
G1 X166.783 Y167.967 E.01178
G3 X165.52 Y163.834 I-1.034 J-1.943 E.25751
G1 X165.741 Y163.822 E.00734
G3 X167.141 Y167.728 I.008 J2.201 E.17964
G1 X167.128 Y167.738 E.00053
; COOLING_NODE: 5
M204 S250
G1 X166.864 Y167.448 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2114
M204 S5000
G1 X166.598 Y167.621 E.00973
G3 X165.561 Y164.225 I-.849 J-1.597 E.196
G1 X165.743 Y164.215 E.0056
G3 X166.911 Y167.411 I.006 J1.809 E.13606
; COOLING_NODE: 5
; WIPE_START
G1 F9547.055
M204 S8000
G1 X166.598 Y167.621 E-.14306
G1 X166.279 Y167.756 E-.13196
G1 X165.938 Y167.825 E-.13208
G1 X165.561 Y167.825 E-.14312
G1 X165.22 Y167.756 E-.13218
G1 X165.032 Y167.678 E-.07759
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X168.94 Y165.821 Z11 F60000
G1 Z10.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2353
M204 S8000
G1 X168.949 Y166.079 E.00856
G3 X165.793 Y162.828 I-3.197 J-.055 E.49931
G1 X165.915 Y162.832 E.00407
G3 X168.938 Y165.762 I-.163 J3.193 E.15244
; COOLING_NODE: 0
M204 S250
G1 X169.332 Y165.811 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1945
M204 S5000
G1 X169.341 Y166.087 E.0085
G3 X165.797 Y162.435 I-3.589 J-.063 E.51916
G1 X165.937 Y162.44 E.00431
G3 X169.331 Y165.751 I-.185 J3.585 E.15916
M204 S10000
G1 X168.439 Y165.796 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.631706
G1 F2353
M204 S8000
G1 X168.449 Y166.015 E.01053
G3 X163.05 Y166.036 I-2.699 J-.001 E.40581
G1 X163.05 Y166.008 E.00136
G3 X168.435 Y165.736 I2.699 J.007 E.3932
; COOLING_NODE: 4
; WIPE_START
G1 F6114.283
G1 X168.449 Y166.015 E-.10616
G1 X168.437 Y166.281 E-.10116
G1 X168.402 Y166.53 E-.09549
G1 X168.337 Y166.799 E-.10525
G1 X168.245 Y167.056 E-.10355
G1 X168.139 Y167.283 E-.09545
G1 X167.997 Y167.522 E-.10551
G1 X167.923 Y167.622 E-.04743
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.479 Y166.55 Z11 F60000
G1 X186.202 Y165.028 Z11
G1 Z10.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2353
M204 S8000
G1 X186.287 Y165.192 E.00612
G3 X184.02 Y163.834 I-2.038 J.832 E.36479
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X184.241 Y163.822 E.00734
G3 X186.076 Y164.796 I.008 J2.201 E.07178
G1 X186.173 Y164.975 E.00676
; COOLING_NODE: 4
M204 S250
M73 P90 R1
G1 X185.857 Y165.212 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2114
M204 S5000
G1 X185.924 Y165.341 E.00447
G3 X184.061 Y164.225 I-1.675 J.683 E.27766
G1 X184.243 Y164.215 E.0056
G3 X185.75 Y165.014 I.006 J1.809 E.0546
G1 X185.829 Y165.159 E.00506
; COOLING_NODE: 4
; WIPE_START
G1 F9547.055
M204 S8000
G1 X185.924 Y165.341 E-.07807
G1 X186.027 Y165.679 E-.13426
G1 X186.053 Y165.866 E-.07179
G1 X186.05 Y166.215 E-.13236
G1 X185.981 Y166.555 E-.13205
G1 X185.837 Y166.897 E-.14089
G1 X185.732 Y167.05 E-.07057
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X181.562 Y164.301 Z11 F60000
G1 Z10.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2353
M204 S8000
G1 X181.632 Y164.192 E.00429
G3 X184.293 Y162.828 I2.62 J1.833 E.10321
G1 X184.415 Y162.832 E.00407
G3 X181.455 Y164.476 I-.163 J3.193 E.54799
G1 X181.531 Y164.352 E.00482
; COOLING_NODE: 0
M204 S250
G1 X181.23 Y164.093 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1945
M204 S5000
G1 X181.311 Y163.967 E.0046
G3 X184.297 Y162.435 I2.941 J2.057 E.10729
G1 X184.437 Y162.44 E.00431
G3 X181.113 Y164.286 I-.185 J3.585 E.56983
G1 X181.199 Y164.144 E.00509
M204 S10000
G1 X181.958 Y164.605 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.631704
G1 F2353
M204 S8000
G1 X182.018 Y164.509 E.00547
G3 X181.55 Y166.04 I2.231 J1.519 E.73561
G1 X181.55 Y166.01 E.00147
G3 X181.563 Y165.761 I6.188 J.206 E.01194
G3 X181.876 Y164.743 I2.686 J.267 E.05144
G1 X181.927 Y164.657 E.00479
; COOLING_NODE: 1
; WIPE_START
G1 F6114.303
G1 X182.018 Y164.509 E-.06615
G1 X182.164 Y164.312 E-.09311
G1 X182.351 Y164.106 E-.10571
G1 X182.531 Y163.944 E-.09205
G1 X182.933 Y163.668 E-.1853
G1 X183.178 Y163.547 E-.10364
G1 X183.407 Y163.46 E-.09325
G1 X183.46 Y163.446 E-.02079
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X186.225 Y156.332 Z11 F60000
G1 X187.298 Y153.573 Z11
G1 Z10.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2353
M204 S8000
G1 X162.702 Y153.573 E.81589
G1 X162.702 Y152.777 E.0264
G1 X187.298 Y152.777 E.81589
G1 X187.298 Y153.513 E.02441
; COOLING_NODE: 1
M204 S250
G1 X187.69 Y153.965 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2114
M204 S5000
G1 X162.31 Y153.965 E.77986
G1 X162.31 Y152.385 E.04855
G1 X187.69 Y152.385 E.77986
G1 X187.69 Y153.905 E.04671
M204 S10000
G1 X187.094 Y153.175 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F2353
M204 S8000
G1 X162.906 Y153.175 E.76636
; CHANGE_LAYER
; Z_HEIGHT: 10.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.259
G1 X164.906 Y153.175 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 78/85
; update layer progress
M73 L78
M991 S0 P77 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 5
M204 S10000
G17
G3 Z11 I-1.203 J.182 P1  F60000
G1 X167.113 Y167.744 Z11
G1 Z10.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2349
M204 S8000
G1 X167.01 Y167.828 E.00442
G3 X165.519 Y163.834 I-1.261 J-1.804 E.26631
G1 X165.73 Y163.822 E.00701
G3 X167.332 Y167.553 I.019 J2.201 E.1714
G1 X167.158 Y167.705 E.00766
; COOLING_NODE: 5
M204 S250
G1 X166.86 Y167.447 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2166
M204 S5000
G1 X166.786 Y167.506 E.0029
G3 X165.561 Y164.225 I-1.037 J-1.482 E.20277
G1 X165.733 Y164.215 E.00531
G3 X167.05 Y167.281 I.016 J1.809 E.13049
G1 X166.905 Y167.407 E.00593
; COOLING_NODE: 5
; WIPE_START
G1 F9547.055
M204 S8000
G1 X166.786 Y167.506 E-.05865
G1 X166.486 Y167.679 E-.13177
G1 X166.156 Y167.789 E-.13203
G1 X165.782 Y167.835 E-.14308
G1 X165.435 Y167.808 E-.13224
G1 X165.1 Y167.715 E-.13208
G1 X165.03 Y167.679 E-.03014
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X168.94 Y165.825 Z11.2 F60000
G1 Z10.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2349
M204 S8000
G1 X168.948 Y166.081 E.0085
G3 X165.802 Y162.828 I-3.197 J-.057 E.49959
G1 X165.915 Y162.831 E.00375
G3 X168.938 Y165.765 I-.164 J3.193 E.15255
; COOLING_NODE: 0
M204 S250
G1 X169.332 Y165.815 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1964
M204 S5000
G1 X169.34 Y166.088 E.0084
G3 X165.807 Y162.436 I-3.589 J-.063 E.51947
G1 X165.937 Y162.44 E.004
G3 X169.331 Y165.755 I-.185 J3.585 E.15924
M204 S10000
G1 X168.439 Y165.818 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.6317
G1 F2349
M204 S8000
G1 X168.449 Y165.96 E.00682
G3 X163.052 Y166.123 I-2.699 J.057 E.40458
G1 X163.051 Y166.06 E.00304
G3 X168.43 Y165.696 I2.699 J-.042 E.39346
G1 X168.435 Y165.759 E.00301
; COOLING_NODE: 4
; WIPE_START
G1 F6114.339
G1 X168.449 Y165.96 E-.07684
G1 X168.443 Y166.222 E-.09938
G1 X168.409 Y166.494 E-.10421
G1 X168.346 Y166.769 E-.1073
G1 X168.273 Y166.988 E-.0879
G1 X168.156 Y167.251 E-.10911
G1 X168.029 Y167.472 E-.09677
G1 X167.911 Y167.641 E-.07851
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.468 Y166.571 Z11.2 F60000
G1 X186.215 Y165.049 Z11.2
G1 Z10.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2349
M204 S8000
G1 X186.275 Y165.165 E.00434
G3 X184.019 Y163.834 I-2.027 J.859 E.36574
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X184.23 Y163.822 E.00701
G3 X186.074 Y164.794 I.019 J2.201 E.07205
G1 X186.186 Y164.996 E.00766
; COOLING_NODE: 4
M204 S250
G1 X185.872 Y165.235 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2166
M204 S5000
G1 X185.915 Y165.318 E.00287
G3 X184.061 Y164.225 I-1.666 J.706 E.27843
G1 X184.233 Y164.215 E.00531
G3 X185.75 Y165.013 I.016 J1.809 E.05485
G1 X185.843 Y165.183 E.00594
; COOLING_NODE: 4
; WIPE_START
G1 F9547.055
M204 S8000
G1 X185.915 Y165.318 E-.05825
G1 X186.021 Y165.648 E-.1317
G1 X186.06 Y165.993 E-.1318
G1 X186.033 Y166.34 E-.1325
G1 X185.94 Y166.674 E-.13164
G1 X185.785 Y166.984 E-.13187
G1 X185.717 Y167.072 E-.04225
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X181.577 Y164.277 Z11.2 F60000
G1 Z10.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2349
M204 S8000
G1 X181.633 Y164.189 E.00347
G3 X184.302 Y162.828 I2.618 J1.835 E.10345
M73 P91 R1
G1 X184.415 Y162.831 E.00375
G3 X181.454 Y164.475 I-.164 J3.193 E.548
G1 X181.545 Y164.328 E.00572
; COOLING_NODE: 0
M204 S250
G1 X181.244 Y164.07 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1964
M204 S5000
G1 X181.311 Y163.966 E.00379
G3 X184.307 Y162.436 I2.94 J2.058 E.10758
G1 X184.437 Y162.44 E.004
G3 X181.112 Y164.285 I-.185 J3.585 E.56981
G1 X181.213 Y164.121 E.00593
M204 S10000
G1 X181.961 Y164.595 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.631699
G1 F2349
M204 S8000
G3 X181.551 Y166.09 I2.289 J1.431 E.73831
G1 X181.55 Y166.06 E.00141
G3 X181.557 Y165.837 I5.008 J.035 E.01073
G3 X181.929 Y164.646 I2.693 J.189 E.06042
; COOLING_NODE: 1
; WIPE_START
G1 F6114.351
G1 X182.113 Y164.375 E-.1244
G1 X182.297 Y164.161 E-.10735
G1 X182.482 Y163.985 E-.09665
G1 X182.708 Y163.809 E-.10921
G1 X182.93 Y163.67 E-.09937
G1 X183.178 Y163.548 E-.1049
G1 X183.407 Y163.46 E-.09343
G1 X183.47 Y163.443 E-.02468
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X186.23 Y156.327 Z11.2 F60000
G1 X187.298 Y153.573 Z11.2
G1 Z10.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2349
M204 S8000
G1 X162.702 Y153.573 E.81589
G1 X162.702 Y152.777 E.0264
G1 X187.298 Y152.777 E.81589
G1 X187.298 Y153.513 E.02441
; COOLING_NODE: 1
M204 S250
G1 X187.69 Y153.965 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2166
M204 S5000
G1 X162.31 Y153.965 E.77986
G1 X162.31 Y152.385 E.04855
G1 X187.69 Y152.385 E.77986
G1 X187.69 Y153.905 E.04671
M204 S10000
G1 X187.094 Y153.175 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F2349
M204 S8000
G1 X162.906 Y153.175 E.76636
; CHANGE_LAYER
; Z_HEIGHT: 11
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.259
G1 X164.906 Y153.175 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 79/85
; update layer progress
M73 L79
M991 S0 P78 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 5
M204 S10000
G17
G3 Z11.2 I-1.203 J.183 P1  F60000
G1 X167.118 Y167.74 Z11.2
G1 Z11
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2348
M204 S8000
G1 X167.012 Y167.828 E.00459
G3 X165.518 Y163.835 I-1.262 J-1.804 E.26632
G1 X165.719 Y163.823 E.00668
G3 X167.334 Y167.552 I.031 J2.201 E.17178
G1 X167.164 Y167.701 E.0075
; COOLING_NODE: 5
M204 S250
G1 X166.864 Y167.443 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2215
M204 S5000
G1 X166.787 Y167.507 E.00308
G3 X165.56 Y164.225 I-1.037 J-1.483 E.20277
G1 X165.724 Y164.215 E.00502
G3 X167.051 Y167.281 I.026 J1.809 E.13083
G1 X166.91 Y167.404 E.00576
; COOLING_NODE: 5
; WIPE_START
G1 F9547.055
M204 S8000
G1 X166.787 Y167.507 E-.06091
G1 X166.482 Y167.681 E-.13355
G1 X166.126 Y167.796 E-.14201
G1 X165.781 Y167.835 E-.13198
G1 X165.436 Y167.808 E-.13163
G1 X165.101 Y167.715 E-.13195
G1 X165.035 Y167.682 E-.02797
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X168.942 Y165.846 Z11.4 F60000
G1 Z11
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2348
M204 S8000
G1 X168.942 Y165.856 E.00031
G3 X165.75 Y162.827 I-3.193 J.169 E.50541
G1 X165.917 Y162.832 E.00554
G3 X168.915 Y165.58 I-.168 J3.193 E.14624
G1 X168.936 Y165.787 E.00688
; COOLING_NODE: 0
M204 S250
G1 X169.332 Y165.808 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1983
M204 S5000
G1 X169.334 Y165.837 E.00087
G3 X165.752 Y162.435 I-3.584 J.188 E.52555
G1 X165.938 Y162.44 E.00572
G3 X169.304 Y165.526 I-.188 J3.584 E.1521
G1 X169.326 Y165.749 E.00689
M204 S10000
G1 X168.439 Y165.799 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.631706
G1 F2348
M204 S8000
G1 X168.45 Y165.996 E.00949
G3 X163.052 Y166.114 I-2.7 J.03 E.4041
G1 X163.05 Y166.057 E.00275
G1 X163.05 Y166.03 E.00132
G3 X168.434 Y165.739 I2.7 J-.004 E.3933
; COOLING_NODE: 4
; WIPE_START
G1 F6114.282
G1 X168.45 Y165.996 E-.09798
G1 X168.44 Y166.258 E-.09944
G1 X168.406 Y166.508 E-.09597
G1 X168.351 Y166.747 E-.09322
G1 X168.265 Y167.007 E-.10421
G1 X168.151 Y167.259 E-.10476
G1 X168.029 Y167.472 E-.09351
G1 X167.921 Y167.624 E-.07091
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.48 Y166.569 Z11.4 F60000
G1 X186.225 Y165.068 Z11.4
G1 Z11
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2348
M204 S8000
G1 X186.275 Y165.162 E.00354
G3 X184.018 Y163.835 I-2.026 J.862 E.36584
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X184.219 Y163.823 E.00668
G3 X186.054 Y164.762 I.031 J2.201 E.07118
G1 X186.195 Y165.016 E.00963
; COOLING_NODE: 4
M204 S250
G1 X185.883 Y165.258 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2215
M204 S5000
G1 X185.915 Y165.317 E.00207
G3 X184.06 Y164.225 I-1.665 J.707 E.27849
G1 X184.224 Y164.215 E.00502
G3 X185.732 Y164.987 I.026 J1.809 E.0542
G1 X185.854 Y165.205 E.00767
; COOLING_NODE: 4
; WIPE_START
G1 F9547.055
M204 S8000
G1 X185.915 Y165.317 E-.04835
G1 X186.021 Y165.649 E-.13237
G1 X186.06 Y165.994 E-.13199
G1 X186.033 Y166.34 E-.1319
G1 X185.94 Y166.674 E-.13176
G1 X185.784 Y166.985 E-.13226
G1 X185.701 Y167.092 E-.05137
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X181.592 Y164.255 Z11.4 F60000
G1 Z11
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2348
M204 S8000
G1 X181.663 Y164.145 E.00435
G3 X184.25 Y162.827 I2.586 J1.88 E.09996
G1 X184.417 Y162.832 E.00554
G3 X181.48 Y164.426 I-.168 J3.193 E.54975
G1 X181.559 Y164.305 E.00477
; COOLING_NODE: 0
M204 S250
G1 X181.263 Y164.041 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1983
M204 S5000
G1 X181.346 Y163.915 E.00465
G3 X184.252 Y162.435 I2.904 J2.11 E.104
G1 X184.438 Y162.44 E.00572
G3 X181.141 Y164.23 I-.188 J3.584 E.5717
G1 X181.231 Y164.092 E.00505
M204 S10000
G1 X181.981 Y164.551 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.631702
G1 F2348
M204 S8000
M73 P92 R1
G3 X181.551 Y166.082 I2.269 J1.464 E.73644
G1 X181.55 Y166.054 E.00135
G3 X181.949 Y164.602 I2.699 J-.039 E.0732
; COOLING_NODE: 1
; WIPE_START
G1 F6114.319
G1 X182.151 Y164.326 E-.13005
G1 X182.321 Y164.136 E-.09687
G1 X182.522 Y163.951 E-.10373
G1 X182.721 Y163.8 E-.095
G1 X182.955 Y163.656 E-.10437
G1 X183.204 Y163.536 E-.10498
G1 X183.439 Y163.45 E-.09488
G1 X183.515 Y163.43 E-.03013
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X186.25 Y156.304 Z11.4 F60000
G1 X187.298 Y153.573 Z11.4
G1 Z11
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2348
M204 S8000
G1 X162.702 Y153.573 E.81589
G1 X162.702 Y152.777 E.0264
G1 X187.298 Y152.777 E.81589
G1 X187.298 Y153.513 E.02441
; COOLING_NODE: 1
M204 S250
G1 X187.69 Y153.965 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2215
M204 S5000
G1 X162.31 Y153.965 E.77986
G1 X162.31 Y152.385 E.04855
G1 X187.69 Y152.385 E.77986
G1 X187.69 Y153.905 E.04671
M204 S10000
G1 X187.094 Y153.175 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F2348
M204 S8000
G1 X162.906 Y153.175 E.76636
; CHANGE_LAYER
; Z_HEIGHT: 11.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.259
G1 X164.906 Y153.175 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 80/85
; update layer progress
M73 L80
M991 S0 P79 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 5
M204 S10000
G17
G3 Z11.4 I-1.203 J.181 P1  F60000
G1 X167.097 Y167.762 Z11.4
G1 Z11.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2349
M204 S8000
G1 X166.785 Y167.966 E.01234
G3 X165.52 Y163.834 I-1.037 J-1.942 E.2576
G1 X165.741 Y163.822 E.00736
G3 X167.144 Y167.726 I.007 J2.201 E.1795
; COOLING_NODE: 5
M204 S250
G1 X166.88 Y167.437 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2260
M204 S5000
G1 X166.6 Y167.62 E.01029
G3 X165.561 Y164.225 I-.85 J-1.597 E.19603
G1 X165.743 Y164.215 E.00562
G3 X166.925 Y167.398 I.006 J1.809 E.13545
; COOLING_NODE: 5
; WIPE_START
G1 F9547.055
M204 S8000
G1 X166.6 Y167.62 E-.1499
G1 X166.279 Y167.756 E-.13221
G1 X165.938 Y167.825 E-.13228
G1 X165.561 Y167.825 E-.14345
G1 X165.22 Y167.756 E-.132
G1 X165.05 Y167.684 E-.07014
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X168.943 Y165.851 Z11.6 F60000
G1 Z11.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2349
M204 S8000
G1 X168.943 Y165.858 E.00025
G3 X165.759 Y162.827 I-3.192 J.165 E.50539
G1 X165.917 Y162.832 E.00525
G3 X168.908 Y165.524 I-.166 J3.192 E.14439
G1 X168.936 Y165.791 E.0089
; COOLING_NODE: 0
M204 S250
G1 X169.332 Y165.81 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2000
M204 S5000
G1 X169.334 Y165.838 E.00086
G3 X166.125 Y169.595 I-3.585 J.187 E.16745
G3 X165.938 Y162.44 I-.369 J-3.57 E.36342
G3 X169.295 Y165.463 I-.189 J3.585 E.15014
G1 X169.326 Y165.75 E.00886
M204 S10000
G1 X168.438 Y165.797 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.631682
G1 F2349
M204 S8000
G1 X168.45 Y166.025 E.01098
G3 X163.051 Y166.04 I-2.7 J.001 E.40624
G1 X163.051 Y166.01 E.00147
G3 X168.434 Y165.737 I2.7 J.016 E.39222
; COOLING_NODE: 4
; WIPE_START
G1 F6114.533
G1 X168.45 Y166.025 E-.10974
G1 X168.436 Y166.307 E-.10741
G1 X168.394 Y166.571 E-.10128
G1 X168.326 Y166.835 E-.10363
G1 X168.236 Y167.08 E-.09936
G1 X168.131 Y167.298 E-.09181
G1 X167.989 Y167.535 E-.10507
G1 X167.919 Y167.62 E-.0417
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.481 Y166.588 Z11.6 F60000
G1 X186.248 Y165.12 Z11.6
G1 Z11.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2349
M204 S8000
G1 X186.353 Y165.379 E.00925
G3 X184.02 Y163.834 I-2.105 J.645 E.35821
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X184.241 Y163.822 E.00736
G3 X186.192 Y164.99 I.007 J2.201 E.07924
G1 X186.225 Y165.065 E.00274
; COOLING_NODE: 4
M204 S250
G1 X185.888 Y165.27 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2260
M204 S5000
G1 X185.979 Y165.495 E.00745
G3 X184.061 Y164.225 I-1.73 J.529 E.27264
G1 X184.243 Y164.215 E.00562
G3 X185.847 Y165.175 I.006 J1.809 E.06034
G1 X185.864 Y165.215 E.00134
; COOLING_NODE: 4
; WIPE_START
G1 F9547.055
M204 S8000
G1 X185.979 Y165.495 E-.11495
G1 X186.05 Y165.836 E-.13253
G1 X186.05 Y166.215 E-.14372
G1 X185.974 Y166.578 E-.14122
G1 X185.848 Y166.876 E-.12285
G1 X185.694 Y167.104 E-.10472
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X181.61 Y164.226 Z11.6 F60000
G1 Z11.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2349
M204 S8000
G1 X181.766 Y164.013 E.00876
G3 X184.259 Y162.827 I2.485 J2.012 E.09469
G1 X184.417 Y162.832 E.00525
G3 X181.568 Y164.284 I-.166 J3.193 E.55537
G1 X181.575 Y164.275 E.00038
; COOLING_NODE: 0
M204 S250
G1 X181.293 Y163.996 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2000
M204 S5000
G1 X181.461 Y163.766 E.00875
G3 X184.261 Y162.435 I2.79 J2.259 E.0985
G1 X184.438 Y162.44 E.00543
G3 X181.24 Y164.071 I-.186 J3.585 E.57753
G1 X181.258 Y164.045 E.00098
M204 S10000
G1 X182.007 Y164.543 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.631696
G1 F2349
M204 S8000
G1 X182.155 Y164.328 E.01253
G3 X181.55 Y166.04 I2.095 J1.703 E.72493
G1 X181.55 Y166.022 E.00088
G3 X181.561 Y165.79 I6.233 J.183 E.01114
G3 X181.878 Y164.74 I2.689 J.24 E.05301
M73 P93 R1
G1 X181.974 Y164.593 E.0084
; COOLING_NODE: 1
; WIPE_START
G1 F6114.387
G1 X182.155 Y164.328 E-.12205
G1 X182.341 Y164.116 E-.10721
G1 X182.531 Y163.943 E-.0976
G1 X182.745 Y163.783 E-.10172
G1 X182.983 Y163.641 E-.10511
G1 X183.211 Y163.533 E-.09599
G1 X183.463 Y163.442 E-.1016
G1 X183.536 Y163.424 E-.02872
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X186.259 Y156.294 Z11.6 F60000
G1 X187.298 Y153.573 Z11.6
G1 Z11.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2349
M204 S8000
G1 X162.702 Y153.573 E.81589
G1 X162.702 Y152.777 E.0264
G1 X187.298 Y152.777 E.81589
G1 X187.298 Y153.513 E.02441
; COOLING_NODE: 1
M204 S250
G1 X187.69 Y153.965 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2260
M204 S5000
G1 X162.31 Y153.965 E.77986
G1 X162.31 Y152.385 E.04855
G1 X187.69 Y152.385 E.77986
G1 X187.69 Y153.905 E.04671
M204 S10000
G1 X187.094 Y153.175 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F2349
M204 S8000
G1 X162.906 Y153.175 E.76636
; CHANGE_LAYER
; Z_HEIGHT: 11.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.259
G1 X164.906 Y153.175 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 81/85
; update layer progress
M73 L81
M991 S0 P80 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 5
M204 S10000
G17
G3 Z11.6 I-1.203 J.184 P1  F60000
G1 X167.128 Y167.732 Z11.6
G1 Z11.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2347
M204 S8000
G1 X167.011 Y167.827 E.00501
G3 X165.519 Y163.834 I-1.262 J-1.804 E.26638
G1 X165.73 Y163.822 E.00702
G3 X167.332 Y167.553 I.019 J2.201 E.1714
G1 X167.173 Y167.692 E.00701
; COOLING_NODE: 5
M204 S250
G1 X166.874 Y167.434 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2302
M204 S5000
G1 X166.787 Y167.506 E.00347
G3 X165.561 Y164.225 I-1.038 J-1.482 E.2028
G1 X165.734 Y164.215 E.00533
G3 X167.05 Y167.281 I.016 J1.809 E.13049
G1 X166.92 Y167.395 E.00534
; COOLING_NODE: 5
; WIPE_START
G1 F9547.055
M204 S8000
G1 X166.787 Y167.506 E-.06568
G1 X166.458 Y167.691 E-.14364
G1 X166.126 Y167.796 E-.13199
G1 X165.782 Y167.835 E-.13171
G1 X165.435 Y167.808 E-.13227
G1 X165.101 Y167.715 E-.13182
G1 X165.047 Y167.688 E-.02289
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X168.943 Y165.851 Z11.8 F60000
G1 Z11.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2347
M204 S8000
G1 X168.944 Y165.856 E.00015
G3 X165.768 Y162.827 I-3.193 J.169 E.50593
G1 X165.916 Y162.832 E.00492
G3 X168.917 Y165.579 I-.165 J3.193 E.14631
G1 X168.937 Y165.791 E.00707
; COOLING_NODE: 0
M204 S250
G1 X169.333 Y165.814 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2014
M204 S5000
G1 X169.337 Y165.837 E.00072
G3 X165.771 Y162.435 I-3.584 J.188 E.52607
G1 X165.937 Y162.44 E.00512
G3 X169.307 Y165.525 I-.185 J3.585 E.15214
G1 X169.327 Y165.754 E.00707
M204 S10000
G1 X168.438 Y165.811 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.631704
G1 F2347
M204 S8000
G1 X168.449 Y165.993 E.00872
G3 X163.051 Y166.087 I-2.699 J.039 E.40615
G1 X163.05 Y166.059 E.00136
G1 X163.05 Y166.025 E.00161
G3 X168.431 Y165.714 I2.7 J.007 E.39128
G1 X168.434 Y165.751 E.00179
; COOLING_NODE: 4
; WIPE_START
G1 F6114.299
G1 X168.449 Y165.993 E-.09187
G1 X168.439 Y166.27 E-.10546
G1 X168.406 Y166.513 E-.09314
G1 X168.343 Y166.777 E-.10336
G1 X168.264 Y167.01 E-.09314
G1 X168.149 Y167.265 E-.10637
G1 X168.008 Y167.506 E-.10611
G1 X167.914 Y167.635 E-.06055
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.475 Y166.592 Z11.8 F60000
G1 X186.248 Y165.108 Z11.8
G1 Z11.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2347
M204 S8000
G1 X186.268 Y165.147 E.00146
G3 X184.019 Y163.834 I-2.019 J.877 E.36641
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X184.23 Y163.822 E.00702
G3 X186.054 Y164.764 I.019 J2.201 E.07085
G1 X186.219 Y165.055 E.01109
; COOLING_NODE: 4
M204 S250
G1 X185.907 Y165.298 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2302
M204 S5000
G1 X185.909 Y165.303 E.00016
G3 X184.061 Y164.225 I-1.659 J.721 E.27894
G1 X184.234 Y164.215 E.00533
G3 X185.732 Y164.988 I.016 J1.809 E.05389
G1 X185.878 Y165.246 E.00911
; COOLING_NODE: 4
; WIPE_START
G1 F9547.055
M204 S8000
G1 X185.909 Y165.303 E-.02471
G1 X186.021 Y165.649 E-.13804
G1 X186.06 Y165.994 E-.13197
G1 X186.033 Y166.341 E-.13217
G1 X185.94 Y166.674 E-.13155
G1 X185.769 Y167.01 E-.14339
G1 X185.673 Y167.13 E-.05816
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X181.622 Y164.209 Z11.8 F60000
G1 Z11.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2347
M204 S8000
G1 X181.675 Y164.132 E.00309
G3 X184.268 Y162.827 I2.577 J1.893 E.09995
G1 X184.416 Y162.832 E.00492
G3 X181.51 Y164.379 I-.165 J3.193 E.55165
G1 X181.589 Y164.259 E.00476
; COOLING_NODE: 0
M204 S250
G1 X181.296 Y163.991 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2014
M204 S5000
G1 X181.36 Y163.899 E.00343
G3 X184.271 Y162.435 I2.893 J2.125 E.10394
G1 X184.437 Y162.44 E.00512
G3 X181.175 Y164.177 I-.185 J3.585 E.57365
G1 X181.263 Y164.042 E.00498
M204 S10000
G1 X181.994 Y164.55 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.631679
G1 F2347
M204 S8000
G3 X181.551 Y166.083 I2.256 J1.482 E.73601
G1 X181.55 Y166.056 E.00129
G1 X181.551 Y166.025 E.00151
G3 X181.961 Y164.6 I2.7 J.007 E.07207
; COOLING_NODE: 1
; WIPE_START
G1 F6114.558
G1 X182.134 Y164.348 E-.1159
G1 X182.319 Y164.139 E-.10625
G1 X182.524 Y163.949 E-.10624
G1 X182.732 Y163.793 E-.09888
G1 X182.956 Y163.656 E-.09977
G1 X183.204 Y163.536 E-.10465
G1 X183.434 Y163.452 E-.09326
G1 X183.524 Y163.428 E-.03505
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X186.253 Y156.3 Z11.8 F60000
G1 X187.298 Y153.573 Z11.8
G1 Z11.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2347
M204 S8000
G1 X162.702 Y153.573 E.81589
G1 X162.702 Y152.777 E.0264
G1 X187.298 Y152.777 E.81589
G1 X187.298 Y153.513 E.02441
; COOLING_NODE: 1
M204 S250
M73 P94 R0
G1 X187.69 Y153.965 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2302
M204 S5000
G1 X162.31 Y153.965 E.77986
G1 X162.31 Y152.385 E.04855
G1 X187.69 Y152.385 E.77986
G1 X187.69 Y153.905 E.04671
M204 S10000
G1 X187.094 Y153.175 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F2347
M204 S8000
G1 X162.906 Y153.175 E.76636
; CHANGE_LAYER
; Z_HEIGHT: 11.6
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F9259.259
G1 X164.906 Y153.175 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 82/85
; update layer progress
M73 L82
M991 S0 P81 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 5
M204 S10000
G17
G3 Z11.8 I-1.203 J.184 P1  F60000
G1 X167.132 Y167.728 Z11.8
G1 Z11.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2347
M204 S8000
G1 X167.012 Y167.828 E.0052
G3 X165.518 Y163.834 I-1.262 J-1.804 E.26634
G1 X165.719 Y163.823 E.00668
G3 X167.334 Y167.552 I.03 J2.201 E.17176
G1 X167.177 Y167.689 E.00689
; COOLING_NODE: 5
M204 S250
G1 X166.878 Y167.431 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2345
M204 S5000
G1 X166.787 Y167.507 E.00364
G3 X165.56 Y164.225 I-1.037 J-1.482 E.20279
G1 X165.724 Y164.215 E.00503
G3 X167.051 Y167.281 I.026 J1.809 E.13081
G1 X166.924 Y167.392 E.00519
; COOLING_NODE: 5
; WIPE_START
G1 F9547.055
M204 S8000
G1 X166.787 Y167.507 E-.06785
G1 X166.481 Y167.681 E-.13373
G1 X166.126 Y167.796 E-.14184
G1 X165.782 Y167.835 E-.13174
G1 X165.436 Y167.808 E-.13195
G1 X165.102 Y167.715 E-.13172
G1 X165.052 Y167.69 E-.02118
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X168.943 Y165.855 Z12 F60000
G1 Z11.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2347
M204 S8000
G1 X168.945 Y165.858 E.00012
G3 X165.777 Y162.827 I-3.193 J.167 E.50615
G1 X165.916 Y162.832 E.00462
G3 X168.91 Y165.524 I-.164 J3.193 E.14448
G1 X168.937 Y165.796 E.00905
; COOLING_NODE: 0
M204 S250
G1 X169.333 Y165.814 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2026
M204 S5000
G1 X169.334 Y165.838 E.00072
G3 X166.125 Y169.595 I-3.585 J.187 E.16746
G3 X165.937 Y162.44 I-.374 J-3.57 E.36376
G3 X169.295 Y165.464 I-.189 J3.585 E.15016
G1 X169.326 Y165.755 E.00899
M204 S10000
G1 X168.438 Y165.811 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.631706
G1 F2347
M204 S8000
G1 X168.449 Y165.988 E.00852
G3 X163.051 Y166.09 I-2.699 J.043 E.40612
G1 X163.05 Y166.062 E.00136
G1 X163.05 Y166.023 E.00185
G3 X168.432 Y165.72 I2.7 J.008 E.39157
G1 X168.434 Y165.751 E.00148
; COOLING_NODE: 4
; WIPE_START
G1 F6114.277
G1 X168.449 Y165.988 E-.0903
G1 X168.441 Y166.238 E-.09493
G1 X168.406 Y166.509 E-.10395
G1 X168.343 Y166.777 E-.10475
G1 X168.265 Y167.005 E-.09135
G1 X168.177 Y167.209 E-.08431
G1 X168.038 Y167.46 E-.10928
G1 X167.914 Y167.634 E-.08113
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.48 Y166.631 Z12 F60000
G1 X186.285 Y165.198 Z12
G1 Z11.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2347
M204 S8000
G1 X186.403 Y165.565 E.01279
G3 X184.018 Y163.834 I-2.153 J.459 E.35181
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X184.219 Y163.823 E.00668
G3 X186.261 Y165.13 I.03 J2.201 E.08519
G1 X186.265 Y165.141 E.00038
; COOLING_NODE: 4
M204 S250
G1 X185.913 Y165.318 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2345
M204 S5000
G1 X186.019 Y165.648 E.01063
G3 X184.06 Y164.225 I-1.77 J.376 E.26782
G1 X184.224 Y164.215 E.00503
G3 X185.891 Y165.263 I.026 J1.809 E.06397
; COOLING_NODE: 4
; WIPE_START
G1 F9547.055
M204 S8000
G1 X186.019 Y165.648 E-.15417
G1 X186.06 Y165.992 E-.1318
G1 X186.033 Y166.339 E-.13235
G1 X185.94 Y166.674 E-.13212
G1 X185.785 Y166.985 E-.13206
G1 X185.659 Y167.146 E-.0775
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X181.634 Y164.191 Z12 F60000
G1 Z11.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2347
M204 S8000
G1 X181.665 Y164.146 E.00181
G3 X184.277 Y162.827 I2.587 J1.878 E.10081
G1 X184.416 Y162.832 E.00462
G3 X181.482 Y164.428 I-.164 J3.193 E.54983
G1 X181.601 Y164.241 E.00733
; COOLING_NODE: 0
M204 S250
G1 X181.305 Y163.978 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2026
M204 S5000
G1 X181.348 Y163.916 E.0023
G3 X184.28 Y162.435 I2.905 J2.109 E.10485
G1 X184.437 Y162.44 E.00482
G3 X181.143 Y164.232 I-.185 J3.585 E.57176
G1 X181.273 Y164.028 E.00742
M204 S10000
G1 X181.997 Y164.541 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.631689
G1 F2347
M204 S8000
G1 X182.135 Y164.353 E.01119
G3 X181.551 Y166.085 I2.115 J1.677 E.72437
G1 X181.55 Y166.059 E.00125
G1 X181.551 Y166.023 E.00171
G3 X181.965 Y164.592 I2.7 J.007 E.0724
; COOLING_NODE: 1
; WIPE_START
G1 F6114.453
G1 X182.135 Y164.353 E-.11139
G1 X182.319 Y164.138 E-.10762
G1 X182.527 Y163.947 E-.10733
G1 X182.753 Y163.778 E-.10749
G1 X182.983 Y163.641 E-.10143
G1 X183.207 Y163.535 E-.09417
G1 X183.434 Y163.452 E-.09188
G1 X183.532 Y163.426 E-.0387
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X186.257 Y156.296 Z12 F60000
G1 X187.298 Y153.573 Z12
G1 Z11.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2347
M204 S8000
G1 X162.702 Y153.573 E.81589
G1 X162.702 Y152.777 E.0264
G1 X187.298 Y152.777 E.81589
G1 X187.298 Y153.513 E.02441
; COOLING_NODE: 1
M204 S250
G1 X187.69 Y153.965 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2345
M204 S5000
M73 P95 R0
G1 X162.31 Y153.965 E.77986
G1 X162.31 Y152.385 E.04855
G1 X187.69 Y152.385 E.77986
G1 X187.69 Y153.905 E.04671
M204 S10000
G1 X187.094 Y153.175 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F2347
M204 S8000
G1 X162.906 Y153.175 E.76636
; CHANGE_LAYER
; Z_HEIGHT: 11.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.259
G1 X164.906 Y153.175 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 83/85
; update layer progress
M73 L83
M991 S0 P82 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 5
M204 S10000
G17
G3 Z12 I-1.203 J.182 P1  F60000
G1 X167.113 Y167.749 Z12
G1 Z11.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2353
M204 S8000
G1 X166.785 Y167.966 E.01303
G3 X165.519 Y163.834 I-1.037 J-1.942 E.25763
G1 X165.741 Y163.822 E.00738
G3 X167.162 Y167.712 I.007 J2.202 E.17875
G1 X167.161 Y167.713 E.00006
; COOLING_NODE: 5
M204 S250
G1 X166.894 Y167.425 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2353
M204 S5000
G1 X166.6 Y167.621 E.01086
G3 X165.561 Y164.225 I-.851 J-1.597 E.19606
G1 X165.744 Y164.215 E.00564
G3 X166.94 Y167.386 I.005 J1.809 E.13488
; COOLING_NODE: 5
; WIPE_START
G1 F9547.055
M204 S8000
G1 X166.6 Y167.621 E-.157
G1 X166.279 Y167.756 E-.13244
G1 X165.914 Y167.828 E-.14133
G1 X165.567 Y167.826 E-.13184
G1 X165.221 Y167.756 E-.134
G1 X165.067 Y167.693 E-.06339
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X168.939 Y165.844 Z12.2 F60000
G1 Z11.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2353
M204 S8000
G1 X168.949 Y166.082 E.00791
G3 X165.786 Y162.828 I-3.197 J-.057 E.49898
G1 X165.916 Y162.832 E.00432
G3 X168.937 Y165.746 I-.164 J3.193 E.15191
G1 X168.938 Y165.784 E.00126
; COOLING_NODE: 0
M204 S250
G1 X169.33 Y165.83 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2036
M204 S5000
G1 X169.342 Y166.088 E.00794
G3 X165.79 Y162.435 I-3.589 J-.064 E.5189
G1 X165.937 Y162.44 E.00454
G3 X169.329 Y165.712 I-.184 J3.585 E.15795
G1 X169.329 Y165.77 E.0018
M204 S10000
G1 X168.439 Y165.812 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.631689
G1 F2353
M204 S8000
G1 X168.45 Y166.04 E.01098
G3 X163.05 Y166.044 I-2.7 J-.01 E.4058
G1 X163.05 Y166.016 E.00135
G1 X163.051 Y165.977 E.00184
G3 X168.435 Y165.752 I2.699 J.053 E.39096
; COOLING_NODE: 4
; WIPE_START
G1 F6114.455
G1 X168.45 Y166.04 E-.10976
G1 X168.436 Y166.305 E-.10064
G1 X168.397 Y166.558 E-.09741
G1 X168.333 Y166.812 E-.09953
G1 X168.236 Y167.08 E-.10824
G1 X168.125 Y167.309 E-.09652
G1 X167.98 Y167.548 E-.10639
G1 X167.913 Y167.635 E-.04151
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.481 Y166.641 Z12.2 F60000
G1 X186.296 Y165.222 Z12.2
G1 Z11.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2353
M204 S8000
G1 X186.402 Y165.567 E.012
G3 X184.019 Y163.834 I-2.154 J.457 E.35179
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X184.241 Y163.822 E.00738
G3 X186.276 Y165.165 I.007 J2.202 E.08569
; COOLING_NODE: 4
M204 S250
G1 X185.923 Y165.339 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2353
M204 S5000
G1 X186.019 Y165.649 E.00996
G3 X184.061 Y164.225 I-1.77 J.375 E.26779
G1 X184.244 Y164.215 E.00564
G3 X185.9 Y165.284 I.005 J1.809 E.06406
; COOLING_NODE: 4
; WIPE_START
G1 F9547.055
M204 S8000
G1 X186.019 Y165.649 E-.14581
G1 X186.06 Y166.025 E-.1438
G1 X186.027 Y166.371 E-.13206
G1 X185.919 Y166.727 E-.14129
G1 X185.751 Y167.037 E-.13428
G1 X185.651 Y167.169 E-.06276
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X181.661 Y164.152 Z12.2 F60000
G1 Z11.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2353
M204 S8000
G1 X181.84 Y163.927 E.00954
G3 X184.286 Y162.828 I2.413 J2.098 E.0918
G1 X184.416 Y162.832 E.00432
G3 X181.626 Y164.201 I-.164 J3.193 E.55872
; COOLING_NODE: 0
M204 S250
G1 X181.352 Y163.911 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2036
M204 S5000
G1 X181.543 Y163.671 E.00942
G3 X184.29 Y162.435 I2.71 J2.354 E.0955
G1 X184.437 Y162.44 E.00454
G3 X181.311 Y163.968 I-.184 J3.585 E.58136
G1 X181.317 Y163.96 E.0003
M204 S10000
G1 X182.031 Y164.491 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.631688
G1 F2353
M204 S8000
G1 X182.172 Y164.306 E.01113
G3 X181.55 Y166.039 I2.078 J1.723 E.72346
G1 X181.55 Y166.013 E.00125
G3 X181.557 Y165.837 I3.704 J.057 E.00846
G3 X181.998 Y164.541 I2.692 J.192 E.06641
; COOLING_NODE: 1
; WIPE_START
G1 F6114.464
G1 X182.172 Y164.306 E-.1109
G1 X182.481 Y163.986 E-.16911
G1 X182.727 Y163.796 E-.1183
G1 X182.966 Y163.65 E-.1062
G1 X183.407 Y163.46 E-.18264
G1 X183.592 Y163.41 E-.07285
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X186.283 Y156.267 Z12.2 F60000
G1 X187.298 Y153.573 Z12.2
G1 Z11.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2353
M204 S8000
G1 X162.702 Y153.573 E.81589
G1 X162.702 Y152.777 E.0264
G1 X187.298 Y152.777 E.81589
G1 X187.298 Y153.513 E.02441
; COOLING_NODE: 1
M204 S250
G1 X187.69 Y153.965 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2353
M204 S5000
G1 X162.31 Y153.965 E.77986
G1 X162.31 Y152.385 E.04855
G1 X187.69 Y152.385 E.77986
G1 X187.69 Y153.905 E.04671
M204 S10000
G1 X187.094 Y153.175 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F2353
M204 S8000
M73 P96 R0
G1 X162.906 Y153.175 E.76636
; CHANGE_LAYER
; Z_HEIGHT: 12
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.259
G1 X164.906 Y153.175 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 84/85
; update layer progress
M73 L84
M991 S0 P83 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 5
M204 S10000
G17
G3 Z12.2 I-1.203 J.186 P1  F60000
G1 X167.152 Y167.711 Z12.2
G1 Z12
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2348
M204 S8000
G1 X166.98 Y167.848 E.00729
G3 X165.519 Y163.834 I-1.232 J-1.824 E.26517
G1 X165.731 Y163.822 E.00704
G3 X167.307 Y167.579 I.018 J2.201 E.17257
G1 X167.198 Y167.672 E.00475
; COOLING_NODE: 5
M204 S250
G1 X166.903 Y167.41 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2348
M204 S5000
G1 X166.761 Y167.523 E.00559
G3 X165.561 Y164.225 I-1.012 J-1.499 E.20185
G1 X165.734 Y164.215 E.00534
G3 X167.029 Y167.303 I.015 J1.809 E.13141
G1 X166.949 Y167.371 E.00323
; COOLING_NODE: 5
; WIPE_START
G1 F9547.055
M204 S8000
G1 X166.761 Y167.523 E-.09191
G1 X166.456 Y167.692 E-.13231
G1 X166.279 Y167.756 E-.07167
G1 X165.924 Y167.827 E-.13776
G1 X165.592 Y167.828 E-.12621
G1 X165.221 Y167.756 E-.14346
G1 X165.083 Y167.699 E-.05668
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X168.939 Y165.847 Z12.4 F60000
G1 Z12
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2348
M204 S8000
G1 X168.949 Y166.081 E.00779
G3 X165.795 Y162.828 I-3.197 J-.057 E.49931
G1 X165.915 Y162.832 E.00401
G3 X168.937 Y165.746 I-.163 J3.193 E.15193
G1 X168.938 Y165.787 E.00134
; COOLING_NODE: 0
M204 S250
G1 X169.331 Y165.833 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2043
M204 S5000
G1 X169.341 Y166.088 E.00784
G3 X165.799 Y162.435 I-3.589 J-.064 E.51921
G1 X165.937 Y162.44 E.00424
G3 X169.328 Y165.712 I-.185 J3.585 E.15794
G1 X169.329 Y165.773 E.00188
M204 S10000
G1 X168.439 Y165.815 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.631705
G1 F2348
M204 S8000
G1 X168.449 Y166.037 E.01068
G3 X163.05 Y166.042 I-2.699 J-.005 E.40622
G1 X163.05 Y166.013 E.00141
G1 X163.051 Y165.977 E.00169
G3 X168.435 Y165.755 I2.699 J.055 E.3909
; COOLING_NODE: 4
; WIPE_START
G1 F6114.294
G1 X168.449 Y166.037 E-.10741
G1 X168.436 Y166.298 E-.09901
G1 X168.397 Y166.557 E-.09966
G1 X168.328 Y166.826 E-.10568
G1 X168.239 Y167.071 E-.09891
G1 X168.126 Y167.308 E-.0997
G1 X167.981 Y167.545 E-.10575
G1 X167.911 Y167.637 E-.04388
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.48 Y166.652 Z12.4 F60000
G1 X186.302 Y165.242 Z12.4
G1 Z12
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2348
M204 S8000
G1 X186.406 Y165.586 E.01191
G3 X184.019 Y163.834 I-2.158 J.438 E.35112
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X184.231 Y163.822 E.00704
G3 X186.276 Y165.168 I.018 J2.201 E.08613
G1 X186.283 Y165.186 E.00063
; COOLING_NODE: 4
M204 S250
G1 X185.929 Y165.358 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2348
M204 S5000
G1 X186.022 Y165.664 E.00984
G3 X184.061 Y164.225 I-1.773 J.36 E.26729
G1 X184.234 Y164.215 E.00534
G3 X185.908 Y165.302 I.015 J1.809 E.06496
; COOLING_NODE: 4
; WIPE_START
G1 F9547.055
M204 S8000
G1 X186.022 Y165.664 E-.14439
G1 X186.06 Y166.025 E-.13768
G1 X186.027 Y166.371 E-.13224
G1 X185.922 Y166.718 E-.13757
G1 X185.751 Y167.037 E-.13781
G1 X185.633 Y167.18 E-.07031
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X181.677 Y164.131 Z12.4 F60000
G1 Z12
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2348
M204 S8000
G1 X181.831 Y163.936 E.00823
G3 X184.295 Y162.828 I2.421 J2.088 E.09253
G1 X184.415 Y162.832 E.00401
G3 X181.632 Y164.192 I-.163 J3.193 E.55909
G1 X181.641 Y164.179 E.00052
; COOLING_NODE: 0
M204 S250
G1 X181.368 Y163.89 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2043
M204 S5000
G1 X181.534 Y163.681 E.0082
G3 X184.299 Y162.435 I2.719 J2.343 E.09622
G1 X184.437 Y162.44 E.00424
G3 X181.311 Y163.967 I-.185 J3.585 E.58136
G1 X181.332 Y163.939 E.00109
M204 S10000
G1 X182.063 Y164.449 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.631705
G1 F2348
M204 S8000
G1 X182.128 Y164.366 E.00505
G3 X181.55 Y166.042 I2.122 J1.669 E.72719
G1 X181.55 Y166.013 E.00142
G3 X181.557 Y165.837 I3.791 J.071 E.00844
G3 X181.965 Y164.597 I2.692 J.198 E.06324
G1 X182.03 Y164.499 E.00564
; COOLING_NODE: 1
; WIPE_START
G1 F6114.286
G1 X182.128 Y164.366 E-.06277
G1 X182.45 Y164.014 E-.18134
G1 X182.664 Y163.841 E-.10453
G1 X182.894 Y163.692 E-.10431
G1 X183.11 Y163.579 E-.09252
G1 X183.364 Y163.476 E-.10432
G1 X183.597 Y163.406 E-.09219
G1 X183.643 Y163.397 E-.01803
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X186.304 Y156.244 Z12.4 F60000
G1 X187.298 Y153.573 Z12.4
G1 Z12
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2348
M204 S8000
G1 X162.702 Y153.573 E.81589
G1 X162.702 Y152.777 E.0264
G1 X187.298 Y152.777 E.81589
G1 X187.298 Y153.513 E.02441
; COOLING_NODE: 1
M204 S250
G1 X187.69 Y153.965 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2348
M204 S5000
G1 X162.31 Y153.965 E.77986
G1 X162.31 Y152.385 E.04855
G1 X187.69 Y152.385 E.77986
G1 X187.69 Y153.905 E.04671
M204 S10000
G1 X187.094 Y153.175 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F2348
M204 S8000
G1 X162.906 Y153.175 E.76636
; CHANGE_LAYER
; Z_HEIGHT: 12.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.259
G1 X164.906 Y153.175 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 85/85
; update layer progress
M73 L85
M991 S0 P84 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 5
M204 S10000
G17
M73 P97 R0
G3 Z12.4 I-1.205 J.17 P1  F60000
G1 X166.909 Y167.405 Z12.4
G1 Z12.2
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2529
M204 S5000
G1 X166.787 Y167.506 E.00486
G3 X165.56 Y164.225 I-1.038 J-1.482 E.2028
G1 X165.724 Y164.215 E.00504
G3 X167.052 Y167.28 I.025 J1.809 E.13077
G1 X166.954 Y167.365 E.00398
; COOLING_NODE: 0
; WIPE_START
G1 F9547.055
M204 S8000
G1 X166.787 Y167.506 E-.08296
G1 X166.481 Y167.681 E-.13399
G1 X166.126 Y167.796 E-.14172
G1 X165.782 Y167.835 E-.13171
G1 X165.435 Y167.808 E-.13213
G1 X165.096 Y167.713 E-.13384
G1 X165.087 Y167.709 E-.00365
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X169.331 Y165.836 Z12.6 F60000
G1 Z12.2
G1 E.8 F1800
G1 F2048
M204 S5000
G1 X169.34 Y166.088 E.00775
G3 X165.809 Y162.436 I-3.589 J-.064 E.51956
G1 X165.937 Y162.44 E.00393
G3 X169.327 Y165.712 I-.186 J3.584 E.15793
G1 X169.329 Y165.776 E.00195
; WIPE_START
G1 F9547.055
M204 S8000
G1 X169.34 Y166.088 E-.11869
G1 X169.314 Y166.459 E-.14121
G1 X169.262 Y166.771 E-.12039
G1 X169.183 Y167.073 E-.11856
G1 X169.055 Y167.427 E-.14313
G1 X168.919 Y167.706 E-.11802
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X166.921 Y162.853 Z12.6 F60000
G1 Z12.2
G1 E.8 F1800
; FEATURE: Top surface
G1 F3757
M204 S2000
G1 X168.918 Y164.85 E.08679
G1 X169.052 Y164.984
G1 X169.234 Y165.699
G1 X169.1 Y165.565
G1 X166.212 Y162.677 E.1255
G1 X166.079 Y162.544
G1 X165.513 Y162.511
G1 X165.646 Y162.645
G1 X169.126 Y166.125 E.15122
G1 X169.26 Y166.258
G1 X169.212 Y166.744
G1 X169.079 Y166.61
G1 X167.511 Y165.043 E.06813
G1 X167.377 Y164.909
G1 X167.621 Y165.686
G1 X167.754 Y165.819
G1 X168.974 Y167.038 E.05298
G1 X169.107 Y167.172
G1 X168.959 Y167.557
G1 X168.826 Y167.424
G1 X167.736 Y166.334 E.04734
G1 X167.602 Y166.201
G1 X167.489 Y166.62
G1 X167.622 Y166.754
G1 X168.642 Y167.774 E.04432
G1 X168.776 Y167.907
G1 X168.56 Y168.225
G1 X168.427 Y168.091
G1 X167.443 Y167.107 E.04275
G1 X167.309 Y166.974
G1 X167.075 Y167.273
G1 X167.209 Y167.407
G1 X168.178 Y168.376 E.04212
G1 X168.312 Y168.51
G1 X168.034 Y168.766
G1 X167.901 Y168.632
G1 X166.924 Y167.655 E.04246
G1 X166.79 Y167.521
G1 X166.454 Y167.718
G1 X166.587 Y167.852
G1 X167.592 Y168.856 E.04365
G1 X167.726 Y168.99
G1 X167.386 Y169.184
G1 X167.253 Y169.05
G1 X166.187 Y167.985 E.0463
G1 X166.053 Y167.851
G1 X165.572 Y167.903
G1 X165.705 Y168.036
G1 X166.879 Y169.21 E.05098
G1 X167.012 Y169.343
G1 X166.598 Y169.462
G1 X166.465 Y169.329
G1 X165.041 Y167.905 E.06186
; WIPE_START
G1 F9547.055
M204 S8000
G1 X166.455 Y169.319 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X166.737 Y164.268 Z12.6 F60000
G1 Z12.2
G1 E.8 F1800
G1 F3757
M204 S2000
G1 X165.166 Y162.698 E.06825
G1 X165.032 Y162.564
G1 X164.603 Y162.667
G1 X164.736 Y162.801
G1 X165.955 Y164.019 E.05295
G1 X166.088 Y164.153
G1 X165.573 Y164.171
G1 X165.44 Y164.038
G1 X164.35 Y162.948 E.04736
G1 X164.216 Y162.814
G1 X163.868 Y162.999
G1 X164.002 Y163.133
G1 X165.022 Y164.153 E.04432
G1 X165.155 Y164.287
G1 X164.8 Y164.465
G1 X164.667 Y164.331
G1 X163.686 Y163.35 E.04263
G1 X163.552 Y163.217
G1 X163.266 Y163.464
G1 X163.399 Y163.597
G1 X164.367 Y164.565 E.04206
G1 X164.501 Y164.699
G1 X164.253 Y164.984
G1 X164.119 Y164.85
G1 X163.144 Y163.876 E.04235
G1 X163.011 Y163.742
G1 X162.783 Y164.048
G1 X162.917 Y164.181
G1 X163.921 Y165.186 E.04364
G1 X164.055 Y165.319
G1 X163.922 Y165.719
G1 X163.788 Y165.586
G1 X162.722 Y164.52 E.0463
G1 X162.589 Y164.386
G1 X162.43 Y164.761
G1 X162.563 Y164.894
G1 X163.743 Y166.074 E.05125
G1 X163.876 Y166.207
G1 X164 Y166.864
G1 X163.866 Y166.73
G1 X162.447 Y165.311 E.06167
G1 X162.314 Y165.178
G1 X162.244 Y165.641
G1 X162.378 Y165.775
G1 X165.998 Y169.395 E.15731
G1 X166.131 Y169.529
G1 X165.596 Y169.526
G1 X165.462 Y169.393
G1 X162.383 Y166.314 E.13379
G1 X162.249 Y166.18
G1 X162.371 Y166.835
G1 X162.505 Y166.969
G1 X164.807 Y169.271 E.10002
; WIPE_START
G1 F9547.055
M204 S8000
G1 X163.393 Y167.857 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X166.868 Y162.906 Z12.6 F60000
G1 Z12.2
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.0994703
G1 F3757
M204 S8000
G1 X166.568 Y162.743 E.00157
; WIPE_START
G1 F15000
G1 X166.868 Y162.906 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X168.64 Y164.277 Z12.6 F60000
G1 Z12.2
G1 E.8 F1800
; LINE_WIDTH: 0.10194
G1 F3757
M204 S8000
G1 X168.55 Y164.166 E.00069
; LINE_WIDTH: 0.129498
G1 X168.46 Y164.054 E.00101
; LINE_WIDTH: 0.169119
G2 X167.763 Y163.351 I-5.758 J5.013 E.01019
; LINE_WIDTH: 0.138152
G1 X167.651 Y163.258 E.00113
; LINE_WIDTH: 0.106204
G2 X167.492 Y163.129 I-1.424 J1.598 E.00105
; WIPE_START
G1 F15000
G1 X167.651 Y163.258 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X167.286 Y164.744 Z12.6 F60000
G1 Z12.2
G1 E.8 F1800
; LINE_WIDTH: 0.125232
G1 F3757
M204 S8000
G1 X167.295 Y164.685 E.0004
; LINE_WIDTH: 0.155969
G1 X167.298 Y164.658 E.00025
; LINE_WIDTH: 0.182002
G2 X167.022 Y164.39 I-2.999 J2.807 E.00436
; LINE_WIDTH: 0.20835
G1 X166.797 Y164.208 E.0039
; WIPE_START
G1 F15000
G1 X167.022 Y164.39 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X164.164 Y167.266 Z12.6 F60000
G1 Z12.2
G1 E.8 F1800
; LINE_WIDTH: 0.103221
G1 F3757
M204 S8000
G1 X164.029 Y167.105 E.00103
G1 X164.041 Y167.056 E.00025
; WIPE_START
G1 F15000
G1 X164.029 Y167.105 E-.14823
G1 X164.164 Y167.266 E-.61177
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X164.972 Y167.974 Z12.6 F60000
G1 Z12.2
G1 E.8 F1800
; LINE_WIDTH: 0.163501
G1 F3757
M204 S8000
G1 X164.81 Y167.857 E.00197
; LINE_WIDTH: 0.14328
G1 X164.669 Y167.744 E.00148
; LINE_WIDTH: 0.106534
G1 X164.528 Y167.631 E.00094
; WIPE_START
G1 F15000
G1 X164.669 Y167.744 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X164.34 Y169.096 Z12.6 F60000
G1 Z12.2
G1 E.8 F1800
; LINE_WIDTH: 0.0990653
G1 F3757
M204 S8000
G1 X164.273 Y169.052 E.00036
; LINE_WIDTH: 0.134599
G1 X164.132 Y168.945 E.00132
; LINE_WIDTH: 0.183862
G1 X163.991 Y168.839 E.00203
; LINE_WIDTH: 0.221627
G1 X163.881 Y168.747 E.00209
; LINE_WIDTH: 0.247896
G1 X163.77 Y168.655 E.00239
; LINE_WIDTH: 0.278324
G3 X163.084 Y167.963 I4.964 J-5.609 E.01871
; LINE_WIDTH: 0.234596
G1 X162.974 Y167.827 E.00273
; LINE_WIDTH: 0.198087
G1 X162.864 Y167.692 E.00221
; LINE_WIDTH: 0.156923
G1 X162.771 Y167.564 E.00147
; LINE_WIDTH: 0.111082
G1 X162.679 Y167.436 E.00088
; COOLING_NODE: 4
; WIPE_START
G1 F15000
G1 X162.771 Y167.564 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X170.37 Y166.845 Z12.6 F60000
G1 X185.931 Y165.374 Z12.6
G1 Z12.2
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2529
M204 S5000
G1 X186.02 Y165.649 E.00887
G3 X184.06 Y164.225 I-1.77 J.375 E.26779
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X184.224 Y164.215 E.00504
G3 X185.903 Y165.289 I.025 J1.809 E.06485
G1 X185.912 Y165.317 E.00091
; COOLING_NODE: 0
; WIPE_START
G1 F9547.055
M204 S8000
G1 X186.02 Y165.649 E-.1325
G1 X186.06 Y165.994 E-.13201
G1 X186.033 Y166.34 E-.132
G1 X185.938 Y166.679 E-.13374
G1 X185.769 Y167.01 E-.1414
G1 X185.624 Y167.192 E-.08836
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X181.381 Y163.873 Z12.6 F60000
G1 Z12.2
G1 E.8 F1800
G1 F2048
M204 S5000
G1 X181.501 Y163.718 E.00601
G3 X184.309 Y162.436 I2.75 J2.306 E.09807
G1 X184.437 Y162.44 E.00393
G3 X181.31 Y163.966 I-.186 J3.584 E.58136
G1 X181.345 Y163.921 E.00175
; WIPE_START
G1 F9547.055
M204 S8000
G1 X181.501 Y163.718 E-.09712
G1 X181.756 Y163.443 E-.14283
G1 X181.994 Y163.233 E-.12045
G1 X182.294 Y163.014 E-.14126
G1 X182.621 Y162.826 E-.14322
G1 X182.897 Y162.7 E-.11512
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X187.302 Y164.57 Z12.6 F60000
G1 Z12.2
G1 E.8 F1800
; FEATURE: Top surface
G1 F3757
M204 S2000
G1 X185.706 Y162.974 E.06937
G1 X185.572 Y162.84
G1 X184.778 Y162.579
G1 X184.911 Y162.713
G1 X187.562 Y165.363 E.11519
G1 X187.696 Y165.497
G1 X187.763 Y166.097
G1 X187.629 Y165.964
G1 X184.312 Y162.646 E.14415
G1 X184.178 Y162.513
G1 X183.672 Y162.54
G1 X183.806 Y162.673
G1 X187.601 Y166.468 E.1649
; WIPE_START
G1 F9547.055
M204 S8000
G1 X186.186 Y165.054 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X186.216 Y165.617 Z12.6 F60000
G1 Z12.2
G1 E.8 F1800
G1 F3757
M204 S2000
G1 X187.513 Y166.914 E.05636
G1 X187.647 Y167.047
G1 X187.508 Y167.442
G1 X187.374 Y167.309
G1 X186.261 Y166.195 E.04839
G1 X186.127 Y166.061
G1 X186.035 Y166.503
G1 X186.169 Y166.636
G1 X187.201 Y167.668 E.04485
G1 X187.335 Y167.802
G1 X187.128 Y168.128
G1 X186.994 Y167.995
G1 X186.007 Y167.007 E.04291
G1 X185.873 Y166.874
G1 X185.655 Y167.189
G1 X185.789 Y167.323
G1 X186.758 Y168.292 E.04212
G1 X186.892 Y168.425
G1 X186.624 Y168.691
G1 X186.49 Y168.557
G1 X185.52 Y167.587 E.04216
G1 X185.386 Y167.454
G1 X185.068 Y167.668
G1 X185.202 Y167.802
G1 X186.191 Y168.792 E.043
G1 X186.325 Y168.925
G1 X185.995 Y169.129
G1 X185.861 Y168.995
G1 X184.822 Y167.956 E.04514
G1 X184.689 Y167.822
G1 X184.233 Y167.9
G1 X184.367 Y168.034
G1 X185.497 Y169.164 E.04912
G1 X185.631 Y169.298
G1 X185.23 Y169.431
G1 X185.097 Y169.297
G1 X183.781 Y167.981 E.05718
; WIPE_START
G1 F9547.055
M204 S8000
G1 X185.097 Y169.297 E-.70711
G1 X185.195 Y169.395 E-.05289
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X184.658 Y164.059 Z12.6 F60000
G1 Z12.2
G1 E.8 F1800
G1 F3757
M204 S2000
G1 X183.363 Y162.764 E.05629
G1 X183.229 Y162.63
G1 X182.833 Y162.767
G1 X182.967 Y162.901
G1 X184.083 Y164.017 E.04852
G1 X184.217 Y164.151
G1 X183.77 Y164.238
G1 X183.637 Y164.104
G1 X182.605 Y163.072 E.04485
G1 X182.471 Y162.938
G1 X182.144 Y163.145
G1 X182.278 Y163.278
G1 X183.264 Y164.265 E.04285
G1 X183.398 Y164.398
G1 X183.082 Y164.616
G1 X182.949 Y164.482
G1 X181.984 Y163.518 E.04192
G1 X181.85 Y163.384
G1 X181.586 Y163.653
G1 X181.719 Y163.786
G1 X182.686 Y164.753 E.04202
G1 X182.82 Y164.887
G1 X182.607 Y165.208
G1 X182.473 Y165.074
G1 X181.484 Y164.084 E.04301
G1 X181.35 Y163.95
G1 X181.147 Y164.281
G1 X181.281 Y164.415
G1 X182.317 Y165.451 E.04502
G1 X182.45 Y165.584
G1 X182.373 Y166.04
G1 X182.24 Y165.907
G1 X181.109 Y164.775 E.04916
G1 X180.975 Y164.642
G1 X180.843 Y165.043
G1 X180.977 Y165.177
G1 X182.297 Y166.497 E.05736
; WIPE_START
G1 F9547.055
M204 S8000
G1 X180.977 Y165.177 E-.70931
G1 X180.883 Y165.083 E-.05069
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X180.896 Y165.629 Z12.6 F60000
G1 Z12.2
G1 E.8 F1800
G1 F3757
M204 S2000
G1 X184.65 Y169.383 E.16314
G1 X184.783 Y169.517
G1 X184.268 Y169.535
G1 X184.134 Y169.401
G1 X180.872 Y166.139 E.14176
G1 X180.738 Y166.005
G1 X180.814 Y166.614
G1 X180.948 Y166.748
G1 X183.526 Y169.326 E.11202
; WIPE_START
G1 F9547.055
M204 S8000
G1 X182.111 Y167.911 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X187.602 Y166.488 Z12.6 F60000
G1 Z12.2
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.103036
G1 F3757
M204 S8000
G1 X187.521 Y166.655 E.00091
; WIPE_START
G1 F15000
G1 X187.602 Y166.488 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X186.288 Y165.545 Z12.6 F60000
G1 Z12.2
G1 E.8 F1800
; LINE_WIDTH: 0.123275
G1 F3757
M204 S8000
G2 X186.113 Y165.273 I-2.648 J1.513 E.00212
; WIPE_START
G1 F15000
G1 X186.288 Y165.545 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X187.465 Y164.976 Z12.6 F60000
G1 Z12.2
G1 E.8 F1800
; LINE_WIDTH: 0.0958357
G1 F3757
M204 S8000
G1 X187.253 Y164.619 E.00179
; WIPE_START
G1 F15000
G1 X187.465 Y164.976 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X185.007 Y164.155 Z12.6 F60000
G1 Z12.2
G1 E.8 F1800
; LINE_WIDTH: 0.151893
G1 F3757
M204 S8000
G1 X184.729 Y163.989 E.00288
; WIPE_START
M73 P98 R0
G1 F15000
G1 X185.007 Y164.155 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X182.425 Y166.866 Z12.6 F60000
G1 Z12.2
G1 E.8 F1800
; LINE_WIDTH: 0.108439
G1 F3757
M204 S8000
G1 X182.358 Y166.767 E.00064
; LINE_WIDTH: 0.151228
G1 X182.283 Y166.656 E.00117
; LINE_WIDTH: 0.183667
G1 X182.232 Y166.562 E.00123
; WIPE_START
G1 F15000
G1 X182.283 Y166.656 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X183.124 Y169.215 Z12.6 F60000
G1 Z12.2
G1 E.8 F1800
; LINE_WIDTH: 0.0901735
G1 F3757
M204 S8000
G1 X183.097 Y169.199 E.00012
; LINE_WIDTH: 0.114983
G1 X182.998 Y169.132 E.0007
; LINE_WIDTH: 0.160597
G1 X182.899 Y169.065 E.00115
; LINE_WIDTH: 0.20621
G1 X182.8 Y168.998 E.00159
; LINE_WIDTH: 0.253244
G1 X182.661 Y168.893 E.00299
; LINE_WIDTH: 0.301732
G1 X182.522 Y168.789 E.00367
; LINE_WIDTH: 0.338844
G1 X182.414 Y168.699 E.00338
; LINE_WIDTH: 0.364555
G1 X182.306 Y168.609 E.00368
; LINE_WIDTH: 0.392259
G3 X181.593 Y167.883 I4.809 J-5.438 E.02899
; LINE_WIDTH: 0.344301
G1 X181.504 Y167.773 E.00346
; LINE_WIDTH: 0.313642
G1 X181.416 Y167.664 E.00311
; LINE_WIDTH: 0.279944
G1 X181.296 Y167.498 E.00396
; LINE_WIDTH: 0.243196
G1 X181.175 Y167.332 E.00335
; LINE_WIDTH: 0.206449
G1 X181.054 Y167.166 E.00273
; COOLING_NODE: 1
; WIPE_START
G1 F15000
G1 X181.175 Y167.332 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X184.519 Y160.471 Z12.6 F60000
G1 X187.69 Y153.965 Z12.6
G1 Z12.2
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2529
M204 S5000
G1 X162.31 Y153.965 E.77986
G1 X162.31 Y152.385 E.04855
G1 X187.69 Y152.385 E.77986
G1 X187.69 Y153.905 E.04671
M204 S10000
G1 X187.483 Y153.019 F60000
; FEATURE: Top surface
G1 F3757
M204 S2000
G1 X187.056 Y152.592 E.01853
G1 X186.923 Y152.459
G1 X186.389 Y152.459
G1 X186.523 Y152.592
G1 X187.483 Y153.552 E.0417
G1 X187.616 Y153.686
G1 X187.289 Y153.891
G1 X187.155 Y153.758
G1 X185.99 Y152.592 E.05064
G1 X185.856 Y152.459
G1 X185.323 Y152.459
G1 X185.456 Y152.592
G1 X186.622 Y153.758 E.05064
G1 X186.755 Y153.891
G1 X186.222 Y153.891
G1 X186.088 Y153.758
G1 X184.923 Y152.592 E.05064
G1 X184.79 Y152.459
G1 X184.256 Y152.459
G1 X184.39 Y152.592
G1 X185.555 Y153.758 E.05064
G1 X185.689 Y153.891
G1 X185.156 Y153.891
G1 X185.022 Y153.758
G1 X183.857 Y152.592 E.05064
G1 X183.723 Y152.459
G1 X183.19 Y152.459
G1 X183.323 Y152.592
G1 X184.489 Y153.758 E.05064
G1 X184.622 Y153.891
G1 X184.089 Y153.891
G1 X183.955 Y153.758
G1 X182.79 Y152.592 E.05064
G1 X182.657 Y152.459
G1 X182.123 Y152.459
G1 X182.257 Y152.592
G1 X183.422 Y153.758 E.05064
G1 X183.556 Y153.891
G1 X183.023 Y153.891
G1 X182.889 Y153.758
G1 X181.724 Y152.592 E.05064
G1 X181.59 Y152.459
G1 X181.057 Y152.459
G1 X181.19 Y152.592
G1 X182.356 Y153.758 E.05064
G1 X182.489 Y153.891
G1 X181.956 Y153.891
G1 X181.822 Y153.758
G1 X180.657 Y152.592 E.05064
G1 X180.523 Y152.459
G1 X179.99 Y152.459
G1 X180.124 Y152.592
G1 X181.289 Y153.758 E.05064
G1 X181.423 Y153.891
G1 X180.89 Y153.891
G1 X180.756 Y153.758
G1 X179.591 Y152.592 E.05064
G1 X179.457 Y152.459
G1 X178.924 Y152.459
G1 X179.057 Y152.592
G1 X180.223 Y153.758 E.05064
G1 X180.356 Y153.891
G1 X179.823 Y153.891
G1 X179.689 Y153.758
G1 X178.524 Y152.592 E.05064
G1 X178.39 Y152.459
G1 X177.857 Y152.459
G1 X177.991 Y152.592
G1 X179.156 Y153.758 E.05064
G1 X179.29 Y153.891
G1 X178.756 Y153.891
G1 X178.623 Y153.758
G1 X177.458 Y152.592 E.05064
G1 X177.324 Y152.459
G1 X176.791 Y152.459
G1 X176.924 Y152.592
G1 X178.09 Y153.758 E.05064
G1 X178.223 Y153.891
G1 X177.69 Y153.891
G1 X177.556 Y153.758
G1 X176.391 Y152.592 E.05064
G1 X176.257 Y152.459
G1 X175.724 Y152.459
G1 X175.858 Y152.592
G1 X177.023 Y153.758 E.05064
G1 X177.157 Y153.891
G1 X176.623 Y153.891
G1 X176.49 Y153.758
G1 X175.325 Y152.592 E.05064
G1 X175.191 Y152.459
G1 X174.658 Y152.459
G1 X174.791 Y152.592
G1 X175.957 Y153.758 E.05064
G1 X176.09 Y153.891
G1 X175.557 Y153.891
G1 X175.423 Y153.758
G1 X174.258 Y152.592 E.05064
G1 X174.124 Y152.459
G1 X173.591 Y152.459
G1 X173.725 Y152.592
G1 X174.89 Y153.758 E.05064
G1 X175.024 Y153.891
G1 X174.49 Y153.891
G1 X174.357 Y153.758
G1 X173.192 Y152.592 E.05064
G1 X173.058 Y152.459
G1 X172.525 Y152.459
G1 X172.658 Y152.592
G1 X173.824 Y153.758 E.05064
G1 X173.957 Y153.891
G1 X173.424 Y153.891
G1 X173.29 Y153.758
G1 X172.125 Y152.592 E.05064
G1 X171.991 Y152.459
G1 X171.458 Y152.459
G1 X171.592 Y152.592
G1 X172.757 Y153.758 E.05064
G1 X172.891 Y153.891
G1 X172.357 Y153.891
G1 X172.224 Y153.758
G1 X171.058 Y152.592 E.05064
G1 X170.925 Y152.459
G1 X170.392 Y152.459
G1 X170.525 Y152.592
G1 X171.69 Y153.758 E.05064
G1 X171.824 Y153.891
G1 X171.291 Y153.891
G1 X171.157 Y153.758
G1 X169.992 Y152.592 E.05064
G1 X169.858 Y152.459
G1 X169.325 Y152.459
G1 X169.459 Y152.592
G1 X170.624 Y153.758 E.05064
G1 X170.758 Y153.891
G1 X170.224 Y153.891
G1 X170.091 Y153.758
G1 X168.925 Y152.592 E.05064
G1 X168.792 Y152.459
G1 X168.259 Y152.459
G1 X168.392 Y152.592
G1 X169.557 Y153.758 E.05064
G1 X169.691 Y153.891
G1 X169.158 Y153.891
G1 X169.024 Y153.758
G1 X167.859 Y152.592 E.05064
G1 X167.725 Y152.459
G1 X167.192 Y152.459
G1 X167.326 Y152.592
G1 X168.491 Y153.758 E.05064
G1 X168.625 Y153.891
G1 X168.091 Y153.891
G1 X167.958 Y153.758
G1 X166.792 Y152.592 E.05064
G1 X166.659 Y152.459
G1 X166.126 Y152.459
G1 X166.259 Y152.592
G1 X167.424 Y153.758 E.05064
G1 X167.558 Y153.891
G1 X167.025 Y153.891
G1 X166.891 Y153.758
G1 X165.726 Y152.592 E.05064
G1 X165.592 Y152.459
G1 X165.059 Y152.459
G1 X165.193 Y152.592
G1 X166.358 Y153.758 E.05064
G1 X166.492 Y153.891
G1 X165.958 Y153.891
G1 X165.825 Y153.758
G1 X164.659 Y152.592 E.05064
M73 P99 R0
G1 X164.526 Y152.459
G1 X163.993 Y152.459
G1 X164.126 Y152.592
G1 X165.291 Y153.758 E.05064
G1 X165.425 Y153.891
G1 X164.892 Y153.891
G1 X164.758 Y153.758
G1 X163.593 Y152.592 E.05064
G1 X163.459 Y152.459
G1 X162.926 Y152.459
G1 X163.06 Y152.592
G1 X164.225 Y153.758 E.05064
G1 X164.359 Y153.891
G1 X163.825 Y153.891
G1 X163.692 Y153.758
G1 X162.526 Y152.592 E.05064
G1 X162.393 Y152.459
G1 X162.384 Y152.983
G1 X162.517 Y153.117
G1 X163.158 Y153.758 E.02785
; close powerlost recovery
M1003 S0
; WIPE_START
G1 F9547.055
M204 S8000
G1 X162.517 Y153.117 E-.34446
G1 X162.384 Y152.983 E-.07182
G1 X162.393 Y152.459 E-.19925
G1 X162.526 Y152.592 E-.07182
G1 X162.662 Y152.728 E-.07265
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z12.6 I1.217 J0 P1  F60000
M106 S0
M106 P2 S0
M981 S0 P20000 ; close spaghetti detector
; FEATURE: Custom
; MACHINE_END_GCODE_START
; filament end gcode 
;========== H2D end ==========
;===== date: 2026/07/29 =====

M1003 S0
M73 P100 R0

G392 S0 ;turn off nozzle clog detect
M993 A0 B0 C0 ; nozzle cam detection not allowed.

M400 ; wait for buffer to clear
G92 E0 ; zero the extruder
M211 Z1

G90
G1 Z12.6 F900 ; lower z a little
M1002 judge_flag timelapse_record_flag
M622 J1
    G150.3
    M400 ; wait all motion done
    M991 S0 P-1 ;end smooth timelapse at safe pos
    M400 S5 ;wait for last picture to be taken
M623  ;end of "timelapse_record_flag"

G90
G1 Z22.2 F900 ; lower z a little

G90
M141 S0 ; turn off chamber heating
M140 S0 ; turn off bed
M106 S0 ; turn off fan
M106 P2 S0 ; turn off remote part cooling fan
M106 P3 S0 ; turn off chamber cooling fan
M106 P9 S0 ; turn off ext toodhead cooling fan
; pull back filament to AMS
M620 S65535
T65535
G150.2
M621 S65535

M620 S65279
T65279
G150.2
M621 S65279

G150.3

M104 S0 T0; turn off hotend
M104 S0 T1; turn off hotend

M400 ; wait all motion done
M17 S
M17 Z0.4 ; lower z motor current to reduce impact if there is something in the bottom

    
        G1 Z106.1 F600
        G1 Z104.1
    

M400 P100
M17 R ; restore z current

M220 S100  ; Reset feedrate magnitude
M201.2 K1.0 ; Reset acc magnitude
M73.2   R1.0 ;Reset left time magnitude
M1002 set_gcode_claim_speed_level : 0

M1015.4 S0 K0 ;disable air printing detect

;=====printer finish air purification=========
M622.1 S0
M1002 judge_flag print_finish_air_filt_flag

M622 J1
M1002 gcode_claim_action : 66
M145 P1
M106 P6 S255
M400 S180
M106 P6 S0
M623

M622 J2
M1002 gcode_claim_action : 66
M145 P0
M106 P3 S127
M400 S180
M106 P3 S0
M623
;=====printer finish air purification=========


;=====printer finish  sound=========
M17
M400 S1
M1006 S1
M1006 A53 B10 L99 C53 D10 M99 E53 F10 N99 
M1006 A57 B10 L99 C57 D10 M99 E57 F10 N99 
M1006 A0 B15 L0 C0 D15 M0 E0 F15 N0 
M1006 A53 B10 L99 C53 D10 M99 E53 F10 N99 
M1006 A57 B10 L99 C57 D10 M99 E57 F10 N99 
M1006 A0 B15 L0 C0 D15 M0 E0 F15 N0 
M1006 A48 B10 L99 C48 D10 M99 E48 F10 N99 
M1006 A0 B15 L0 C0 D15 M0 E0 F15 N0 
M1006 A60 B10 L99 C60 D10 M99 E60 F10 N99 
M1006 W
;=====printer finish  sound=========
M400
M18

M73 P100 R0
; EXECUTABLE_BLOCK_END

