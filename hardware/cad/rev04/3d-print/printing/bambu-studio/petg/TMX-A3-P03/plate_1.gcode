; HEADER_BLOCK_START
; BambuStudio 02.08.02.61
; model printing time: 11m 6s; total estimated time: 16m 33s
; total layer number: 10
; total filament length [mm] : 2163.60
; total filament volume [cm^3] : 5204.08
; total filament weight [g] : 6.61
; filament_density: 1.27
; filament_diameter: 1.75
; max_z_height: 2.00
; filament: 1
; support_material_on_wipe_tower: 0
; HEADER_BLOCK_END

; CONFIG_BLOCK_START
; accel_to_decel_enable = 0
; accel_to_decel_factor = 50%
; activate_air_filtration = 0
; additional_cooling_fan_speed = 0
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
; close_additional_fan_first_x_layers = 3
; close_fan_the_first_x_layers = 3
; compatible_printers_condition = 
; complete_print_exhaust_fan_speed = 70
; cool_plate_temp = 0
; cool_plate_temp_initial_layer = 0
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
; enable_support = 0
; enable_support_ironing = 0
; enable_tower_interface_features = 1
; enable_wrapping_detection = 0
; enforce_support_layers = 0
; eng_plate_temp = 70
; eng_plate_temp_initial_layer = 70
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
; fan_cooling_layer_time = 30
; fan_direction = left
; fan_max_speed = 90
; fan_min_speed = 40
; farthest_point_timelapse = 1
; filament_adaptive_volumetric_speed = 0
; filament_adhesiveness_category = 300
; filament_bridge_speed = 25
; filament_change_length = 10
; filament_change_length_nc = 10
; filament_colour = #00AE42
; filament_cooling_before_tower = 10
; filament_cost = 30
; filament_density = 1.27
; filament_dev_ams_drying_ams_limitations = 1
; filament_dev_ams_drying_heat_distortion_temperature = 75
; filament_dev_ams_drying_temperature = 65
; filament_dev_ams_drying_time = 12
; filament_dev_chamber_drying_bed_temperature = 80
; filament_dev_chamber_drying_time = 12
; filament_dev_drying_cooling_temperature = 55
; filament_dev_drying_softening_temperature = 60
; filament_diameter = 1.75
; filament_enable_overhang_speed = 1
; filament_end_gcode = "; filament end gcode \n"
; filament_extruder_compatibility = 0
; filament_extruder_variant = "Direct Drive Standard"
; filament_flow_ratio = 0.95
; filament_flush_temp = 0
; filament_flush_temp_fast = 0
; filament_flush_volumetric_speed = 0
; filament_ids = GFG99
; filament_is_mixed = 0
; filament_is_support = 0
; filament_map = 1
; filament_map_2 = 0
; filament_map_mode = Auto For Flush
; filament_max_volumetric_speed = 12
; filament_metal_stickiness = High
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
; filament_scarf_gap = 0%
; filament_scarf_height = 10%
; filament_scarf_length = 10
; filament_scarf_seam_type = none
; filament_self_index = 1
; filament_settings_id = "Generic PETG @BBL H2D"
; filament_shrink = 100%
; filament_soluble = 0
; filament_start_gcode = "; filament start gcode\n"
; filament_tower_interface_pre_extrusion_dist = 10
; filament_tower_interface_pre_extrusion_length = 0
; filament_tower_interface_print_temp = -1
; filament_tower_interface_purge_volume = 20
; filament_tower_ironing_area = 4
; filament_type = PETG
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
; hot_plate_temp = 70
; hot_plate_temp_initial_layer = 70
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
; nozzle_temperature = 255
; nozzle_temperature_initial_layer = 255
; nozzle_temperature_range_high = 270
; nozzle_temperature_range_low = 220
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
; overhang_fan_speed = 90
; overhang_fan_threshold = 10%
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
; print_settings_id = Trimix A3 0.20 no_supports @BBL H2D
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
; slow_down_layer_time = 12
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
; supertack_plate_temp = 70
; supertack_plate_temp_initial_layer = 70
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
; temperature_vitrification = 70
; template_custom_gcode = 
; textured_plate_temp = 70
; textured_plate_temp_initial_layer = 70
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
    
        
            M142 P1 R35 S40 T45 U0.3 V0.5 W0.8 O45 L1 ; set third-party PETG chamber autocooling
        
    
    
        M145.2 P0 F1
    


;==== set airduct mode ====

;===== start to heat heatbed & hotend==========

    M1002 set_filament_type:PETG

    M104 S140 A
    M140 S70

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

M104 S255 T1 ; rise temp in advance

G151 P1 M ; plug the heat nozzle



;===== detection end =====

M400
;M73 P99

;===== prepare print temperature and material ==========
M400
M211 X0 Y0 Z0 ;turn off soft endstop
M975 S1 ; turn on input shaping

G29.2 S0 ; avoid invalid abl data


M620.10 A0 F239.471 H0.4 T270 P255 S1
M620.10 A1 F239.471 H0.4 T270 P255 S1


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
M1002 set_filament_type:PETG
M621 S0A

M104 S255
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
    M1002 set_filament_type:PETG
    M1002 gcode_claim_action : 8

    M109 S255

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
    M1002 set_filament_type:PETG
    M1002 gcode_claim_action : 8

    M109 S255

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
    M109 S255 ; wait tmpr to extrude
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
    G150 T255
    
M106 S255 ; turn on fan to cool the nozzle

;===== wipe left nozzle end =====

M400
;M73 P99



M400
;M73 P99

;===== bed leveling ==================================

M1002 judge_flag g29_before_print_flag

M190 S70; ensure bed temp
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
    G29 A1 O X155.993 Y106.193 I38.0131 J107.613 R
    M400
M623

M622 J2
    M1002 gcode_claim_action : 1
    
        G29.20 A4
        G29 A2 O X155.993 Y106.193 I38.0131 J107.613 R
    
    M400
M623

M622 J0
    G28 R
M623

;===== bed leveling end ================================

;===== z ofst cali start =====

    M190 S70; ensure bed temp

    G383 O0 M2 T140

;===== z ofst cali end =====

G39.1 ; cali nozzle wrapped detection pos

G90
M73 P31 R11
G1 Z5 F1200
G1 X270 Y-0.5 F60000
G28.140 S0 ; cali pre-extrude z pos

M141 S0
M104 S255 A

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
    M620.17 T0 S255 L0
    M620.17 T1 S255 L0
    M620 D-1
    G383 O1 T255 L0
    M141 S0
M623

M622 J2
    M1002 gcode_claim_action : 39
    M141 S0
    M620.17 T0 S255 L0
    M620.17 T1 S255 L0
    M620 D-1
    G383.3 T255 L0
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
M1002 set_filament_type:PETG
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

M104 S255 ; rise to print tmpr

M140 S70
M190 S70

    ;========turn off light and fans =============
    M960 S1 P0 ; turn off laser
    M960 S2 P0 ; turn off laser
    M106 S0 ; turn off fan
    M106 P2 S0 ; turn off big fan
    ;==== set ext toodhead cooling fan ====
    
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
    M109 S255
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
; layer num/total_layer_count: 1/10
; update layer progress
M73 L1
M991 S0 P0 ;notify layer change

M106 S0
M106 P2 S0
; OBJECT_ID: 15
M73 P32 R11
G1 X156.826 Y112.72 F60000
M204 S6000
G1 Z.4
G1 Z.2
G1 E.8 F1800
; FEATURE: Brim
; LINE_WIDTH: 0.5
G1 F3000
M204 S500
G1 X157.172 Y112.274 E.02039
G1 X157.588 Y111.89 E.02045
G1 X158.063 Y111.578 E.02053
G1 X158.444 Y111.4 E.01517
G1 X159.088 Y111.198 E.02439
G1 X159.812 Y111.122 E.02627
G1 X161.993 Y111.122 E.07877
G1 X162.134 Y111.073 E.00538
G1 X162.222 Y110.893 E.00722
G1 X162.222 Y110.009 E.03192
G1 X162.269 Y109.44 E.02062
G1 X162.511 Y108.625 E.03072
G1 X162.826 Y108.02 E.0246
G1 X163.172 Y107.574 E.02039
G1 X163.588 Y107.19 E.02045
G1 X164.063 Y106.878 E.02053
G1 X164.444 Y106.7 E.01517
G1 X165.088 Y106.498 E.02439
G1 X165.812 Y106.422 E.02627
G1 X190.191 Y106.422 E.88022
G1 X190.76 Y106.469 E.02062
G1 X191.575 Y106.711 E.03072
G1 X192.18 Y107.026 E.0246
M73 P33 R11
G1 X192.626 Y107.372 E.02039
G1 X193.01 Y107.788 E.02045
G1 X193.322 Y108.262 E.02048
G1 X193.539 Y108.743 E.01907
G1 X193.702 Y109.287 E.0205
G1 X193.778 Y110.012 E.02632
G1 X193.778 Y192.491 E2.97797
G1 X193.731 Y193.06 E.02062
G1 X193.489 Y193.875 E.03072
G1 X193.174 Y194.48 E.0246
G1 X192.828 Y194.926 E.02039
G1 X192.412 Y195.31 E.02045
G1 X191.937 Y195.622 E.02053
G1 X191.556 Y195.8 E.01517
G1 X190.912 Y196.002 E.02439
G1 X190.188 Y196.078 E.02627
G1 X172.407 Y196.078 E.64202
G1 X172.266 Y196.127 E.00538
G1 X172.178 Y196.307 E.00722
G1 X172.178 Y209.991 E.49407
G1 X172.131 Y210.56 E.02062
G1 X171.889 Y211.375 E.03072
G1 X171.574 Y211.98 E.0246
G1 X171.228 Y212.426 E.02039
G1 X170.812 Y212.81 E.02045
G1 X170.337 Y213.122 E.02053
G1 X169.956 Y213.3 E.01517
G1 X169.312 Y213.502 E.02439
G1 X168.588 Y213.578 E.02627
G1 X159.809 Y213.578 E.31696
G1 X159.24 Y213.531 E.02062
G1 X158.425 Y213.289 E.03072
G1 X157.82 Y212.974 E.0246
G1 X157.374 Y212.628 E.02039
G1 X156.99 Y212.212 E.02045
G1 X156.678 Y211.738 E.02048
G1 X156.461 Y211.257 E.01907
G1 X156.298 Y210.713 E.0205
G1 X156.222 Y209.988 E.02632
G1 X156.222 Y114.709 E3.44014
G1 X156.269 Y114.14 E.02062
G1 X156.511 Y113.325 E.03072
G1 X156.798 Y112.774 E.02243
M204 S6000
G1 X157.205 Y112.986 F60000
G1 F3000
M204 S500
G1 X157.22 Y112.958 E.00111
G1 X157.518 Y112.576 E.0175
G1 X157.862 Y112.259 E.01689
G1 X158.295 Y111.974 E.01873
G1 X158.618 Y111.825 E.01285
G1 X159.195 Y111.646 E.02181
G1 X159.843 Y111.579 E.02351
G1 X161.982 Y111.579 E.07723
G1 X162.27 Y111.51 E.0107
G1 X162.443 Y111.407 E.00726
G1 X162.551 Y111.262 E.00654
G1 X162.626 Y111.108 E.0062
G1 X162.679 Y110.878 E.00851
G1 X162.679 Y110.034 E.03047
G1 X162.725 Y109.511 E.01894
G1 X162.933 Y108.809 E.02644
G1 X163.206 Y108.279 E.02155
G1 X163.518 Y107.876 E.01838
G1 X163.879 Y107.545 E.0177
G1 X164.278 Y107.283 E.0172
G1 X164.601 Y107.131 E.01291
G1 X165.168 Y106.952 E.02148
G1 X165.843 Y106.879 E.02449
G1 X190.177 Y106.88 E.87862
G1 X190.689 Y106.925 E.01853
G1 X191.391 Y107.133 E.02644
G1 X191.921 Y107.406 E.02155
M73 P33 R10
G1 X192.324 Y107.718 E.01838
G1 X192.655 Y108.079 E.0177
G1 X192.914 Y108.474 E.01702
G1 X193.106 Y108.895 E.01673
G1 X193.253 Y109.39 E.01864
G1 X193.321 Y110.043 E.0237
G1 X193.321 Y192.466 E2.97596
G1 X193.275 Y192.989 E.01894
G1 X193.057 Y193.715 E.02739
G1 X192.794 Y194.221 E.0206
G1 X192.482 Y194.624 E.01838
G1 X192.121 Y194.955 E.0177
G1 X191.705 Y195.226 E.01792
G1 X191.382 Y195.375 E.01285
G1 X190.805 Y195.554 E.02181
G1 X190.157 Y195.621 E.02351
G1 X172.418 Y195.621 E.64048
G1 X172.13 Y195.69 E.01069
G1 X171.957 Y195.793 E.00726
G1 X171.849 Y195.938 E.00654
G1 X171.774 Y196.092 E.00619
G1 X171.721 Y196.322 E.00851
G1 X171.72 Y209.977 E.49303
G1 X171.675 Y210.489 E.01853
G1 X171.467 Y211.191 E.02644
G1 X171.18 Y211.742 E.02243
G1 X170.882 Y212.124 E.0175
G1 X170.521 Y212.455 E.0177
G1 X170.122 Y212.717 E.0172
G1 X169.799 Y212.869 E.01291
G1 X169.205 Y213.054 E.02246
G1 X168.557 Y213.121 E.02351
G1 X159.834 Y213.121 E.31495
G1 X159.311 Y213.075 E.01894
G1 X158.609 Y212.867 E.02644
G1 X158.079 Y212.594 E.02155
G1 X157.693 Y212.297 E.01757
G1 X157.359 Y211.938 E.0177
G1 X157.086 Y211.526 E.01784
G1 X156.888 Y211.088 E.01739
G1 X156.747 Y210.61 E.01798
G1 X156.679 Y209.957 E.0237
G1 X156.679 Y114.734 E3.43813
G1 X156.725 Y114.211 E.01894
G1 X156.933 Y113.509 E.02644
G1 X157.178 Y113.039 E.01915
M204 S6000
M73 P34 R10
G1 X157.583 Y113.25 F60000
G1 F3000
M204 S500
G1 X157.6 Y113.218 E.00131
G1 X157.849 Y112.896 E.01469
G1 X158.154 Y112.614 E.01499
G1 X158.509 Y112.38 E.01537
G1 X158.774 Y112.256 E.01055
G1 X159.301 Y112.095 E.01989
G1 X159.86 Y112.037 E.02029
G1 X161.974 Y112.036 E.07635
G1 X162.367 Y111.957 E.01446
G1 X162.513 Y111.897 E.00572
G1 X162.665 Y111.806 E.0064
G1 X162.817 Y111.669 E.00739
G1 X162.911 Y111.543 E.00568
G1 X163.072 Y111.205 E.01351
G1 X163.136 Y110.865 E.0125
G1 X163.136 Y110.06 E.02907
G1 X163.18 Y109.584 E.01726
G1 X163.355 Y108.993 E.02226
G1 X163.588 Y108.537 E.01849
G1 X163.849 Y108.196 E.01549
G1 X164.17 Y107.901 E.01577
G1 X164.494 Y107.689 E.01396
G1 X164.76 Y107.562 E.01066
G1 X165.25 Y107.405 E.01856
G1 X165.875 Y107.336 E.02271
G1 X190.151 Y107.337 E.87652
G1 X190.616 Y107.38 E.01685
G1 X191.207 Y107.555 E.02227
G1 X191.663 Y107.788 E.01849
G1 X192.021 Y108.064 E.01633
G1 X192.299 Y108.37 E.01493
G1 X192.507 Y108.686 E.01364
G1 X192.673 Y109.047 E.01435
G1 X192.804 Y109.492 E.01675
G1 X192.864 Y110.074 E.0211
G1 X192.864 Y192.44 E2.97392
G1 X192.82 Y192.916 E.01724
G1 X192.626 Y193.554 E.02408
G1 X192.413 Y193.963 E.01666
G1 X192.136 Y194.321 E.01635
G1 X191.83 Y194.599 E.01492
G1 X191.474 Y194.829 E.01531
G1 X191.209 Y194.95 E.01052
G1 X190.699 Y195.105 E.01923
G1 X190.126 Y195.164 E.0208
G1 X172.432 Y195.164 E.63889
G1 X172.031 Y195.244 E.01474
G1 X171.887 Y195.303 E.00562
G1 X171.735 Y195.394 E.0064
G1 X171.583 Y195.531 E.00739
G1 X171.489 Y195.657 E.00568
G1 X171.328 Y195.995 E.01351
G1 X171.264 Y196.335 E.0125
G1 X171.263 Y209.951 E.49162
G1 X171.22 Y210.416 E.01685
G1 X171.045 Y211.006 E.02223
G1 X170.786 Y211.503 E.02024
G1 X170.537 Y211.82 E.01456
G1 X170.247 Y212.086 E.01419
G1 X169.89 Y212.321 E.01545
G1 X169.623 Y212.445 E.0106
G1 X169.125 Y212.6 E.01884
G1 X168.54 Y212.663 E.02124
G1 X159.86 Y212.664 E.31341
G1 X159.384 Y212.62 E.01726
G1 X158.793 Y212.445 E.02226
G1 X158.336 Y212.212 E.01853
G1 X158.011 Y211.965 E.01474
G1 X157.727 Y211.663 E.01496
G1 X157.494 Y211.314 E.01516
G1 X157.314 Y210.919 E.01565
G1 X157.196 Y210.508 E.01543
G1 X157.136 Y209.926 E.02113
G1 X157.136 Y114.76 E3.43608
G1 X157.18 Y114.284 E.01726
G1 X157.365 Y113.67 E.02316
G1 X157.556 Y113.303 E.01493
M204 S6000
G1 X157.961 Y113.514 F60000
G1 F3000
M204 S500
G1 X157.981 Y113.476 E.00156
G1 X158.18 Y113.214 E.01186
G1 X158.446 Y112.969 E.01306
G1 X158.725 Y112.785 E.01206
G1 X158.93 Y112.688 E.00821
G1 X159.379 Y112.549 E.01698
G1 X159.876 Y112.495 E.01805
G1 X162.076 Y112.482 E.07943
G1 X162.548 Y112.376 E.01744
G1 X162.752 Y112.287 E.00807
G1 X162.98 Y112.139 E.0098
G1 X163.116 Y112.016 E.00662
G1 X163.272 Y111.823 E.00895
G1 X163.482 Y111.408 E.01678
G1 X163.523 Y111.282 E.00479
G1 X163.593 Y110.854 E.01568
G1 X163.593 Y110.087 E.02768
G1 X163.63 Y109.684 E.01462
G1 X163.778 Y109.175 E.01914
G1 X163.97 Y108.793 E.01546
G1 X164.196 Y108.498 E.01341
G1 X164.462 Y108.256 E.01295
G1 X164.71 Y108.093 E.01075
G1 X164.92 Y107.992 E.00841
G1 X165.359 Y107.853 E.01661
G1 X165.908 Y107.793 E.01993
G1 X190.123 Y107.794 E.87433
G1 X190.542 Y107.835 E.01517
G1 X191.025 Y107.978 E.0182
G1 X191.406 Y108.17 E.01541
G1 X191.718 Y108.41 E.01422
G1 X191.943 Y108.66 E.01214
G1 X192.11 Y108.918 E.01109
G1 X192.24 Y109.2 E.0112
G1 X192.355 Y109.594 E.01483
G1 X192.407 Y110.104 E.01852
G1 X192.407 Y192.412 E2.97183
G1 X192.365 Y192.84 E.01552
G1 X192.205 Y193.368 E.01991
G1 X192.032 Y193.705 E.01366
G1 X191.806 Y194 E.01344
G1 X191.558 Y194.228 E.01214
G1 X191.262 Y194.422 E.01279
G1 X191.038 Y194.525 E.00889
G1 X190.596 Y194.656 E.01667
G1 X190.11 Y194.706 E.01763
G1 X172.444 Y194.707 E.63786
G1 X171.952 Y194.794 E.01802
G1 X171.646 Y194.915 E.01189
G1 X171.42 Y195.061 E.0097
G1 X171.286 Y195.182 E.00652
G1 X171.07 Y195.472 E.01307
G1 X170.919 Y195.79 E.0127
G1 X170.877 Y195.918 E.00485
G1 X170.807 Y196.346 E.01568
G1 X170.806 Y209.923 E.49022
G1 X170.765 Y210.342 E.01517
G1 X170.623 Y210.822 E.01808
G1 X170.393 Y211.265 E.01803
M73 P35 R10
G1 X170.207 Y211.5 E.01081
G1 X169.973 Y211.717 E.01153
G1 X169.657 Y211.925 E.01366
G1 X169.45 Y212.02 E.00825
G1 X169.045 Y212.146 E.01531
G1 X168.523 Y212.205 E.01896
G1 X159.887 Y212.207 E.3118
G1 X159.458 Y212.165 E.01558
G1 X158.975 Y212.022 E.01818
G1 X158.59 Y211.829 E.01555
G1 X158.327 Y211.631 E.01191
G1 X158.094 Y211.386 E.01221
G1 X157.89 Y211.081 E.01325
G1 X157.742 Y210.751 E.01307
G1 X157.645 Y210.409 E.01283
G1 X157.593 Y209.896 E.01861
G1 X157.593 Y114.787 E3.43399
G1 X157.635 Y114.358 E.01556
G1 X157.796 Y113.831 E.01991
G1 X157.933 Y113.567 E.01074
M204 S6000
G1 X158.348 Y113.798 F60000
G1 F3000
M204 S500
G1 X158.444 Y113.625 E.00716
G1 X158.578 Y113.474 E.00728
G1 X158.841 Y113.261 E.01225
G1 X159.111 Y113.114 E.01109
G1 X159.353 Y113.026 E.0093
G1 X159.831 Y112.95 E.01747
G1 X163.913 Y112.95 E.14739
G1 X164.017 Y112.903 E.00413
G1 X164.05 Y112.813 E.00344
G1 X164.05 Y110.032 E.10042
G1 X164.108 Y109.632 E.01459
G1 X164.241 Y109.257 E.01439
G1 X164.399 Y108.989 E.01123
G1 X164.621 Y108.733 E.01221
G1 X165.002 Y108.468 E.01676
G1 X165.331 Y108.337 E.01277
G1 X165.835 Y108.25 E.01848
G1 X190.172 Y108.25 E.87871
G1 X190.472 Y108.285 E.01092
G1 X190.784 Y108.372 E.01168
G1 X191.199 Y108.592 E.01697
G1 X191.292 Y108.661 E.00419
G1 X191.47 Y108.824 E.00871
G1 X191.608 Y108.993 E.00788
G1 X191.77 Y109.271 E.0116
G1 X191.859 Y109.495 E.0087
G1 X191.95 Y110.035 E.0198
G1 X191.95 Y192.472 E2.97645
G1 X191.915 Y192.772 E.01093
G1 X191.828 Y193.084 E.01167
G1 X191.607 Y193.499 E.01698
G1 X191.42 Y193.727 E.01066
G1 X191.158 Y193.94 E.01217
G1 X190.904 Y194.081 E.0105
G1 X190.672 Y194.163 E.00886
G1 X190.165 Y194.25 E.01858
G1 X170.487 Y194.25 E.7105
G1 X170.383 Y194.297 E.00413
G1 X170.35 Y194.387 E.00344
G1 X170.35 Y209.966 E.5625
G1 X170.26 Y210.484 E.01896
G1 X170.099 Y210.853 E.01456
G1 X169.818 Y211.229 E.01693
G1 X169.557 Y211.441 E.01216
G1 X169.38 Y211.544 E.00738
G1 X169.173 Y211.633 E.00816
G1 X168.564 Y211.75 E.02238
G1 X159.828 Y211.75 E.31541
G1 X159.528 Y211.715 E.01093
G1 X159.216 Y211.628 E.01167
G1 X158.801 Y211.407 E.01698
G1 X158.573 Y211.22 E.01066
G1 X158.36 Y210.958 E.01217
G1 X158.219 Y210.704 E.01051
G1 X158.137 Y210.472 E.00886
G1 X158.05 Y209.965 E.01858
G1 X158.05 Y114.728 E3.43863
G1 X158.085 Y114.428 E.01092
G1 X158.173 Y114.111 E.01188
G1 X158.318 Y113.851 E.01074
M204 S6000
G1 X158.707 Y114.072 F60000
G1 F3000
M204 S500
G1 X158.794 Y113.919 E.00637
G1 X158.869 Y113.826 E.00431
G1 X159.065 Y113.659 E.0093
G1 X159.256 Y113.547 E.00801
G1 X159.521 Y113.451 E.01015
G1 X159.82 Y113.407 E.01093
G1 X164.37 Y113.407 E.16428
G1 X164.474 Y113.36 E.00413
G1 X164.507 Y113.27 E.00344
G1 X164.507 Y110.022 E.11727
G1 X164.56 Y109.694 E.012
G1 X164.67 Y109.415 E.01081
G1 X164.79 Y109.225 E.00813
G1 X164.962 Y109.038 E.00919
G1 X165.261 Y108.845 E.01284
G1 X165.405 Y108.788 E.00561
G1 X165.823 Y108.707 E.01536
G1 X190.18 Y108.707 E.87942
G1 X190.421 Y108.739 E.00878
G1 X190.663 Y108.812 E.00913
G1 X190.977 Y108.992 E.01307
G1 X191.168 Y109.167 E.00935
G1 X191.245 Y109.27 E.00464
G1 X191.376 Y109.503 E.00964
G1 X191.434 Y109.662 E.0061
G1 X191.493 Y110.024 E.01326
G1 X191.493 Y192.48 E2.97715
G1 X191.461 Y192.721 E.00878
G1 X191.388 Y192.963 E.00913
G1 X191.206 Y193.281 E.01322
M73 P36 R10
G1 X191.131 Y193.374 E.00431
G1 X190.935 Y193.541 E.0093
G1 X190.742 Y193.654 E.00807
G1 X190.595 Y193.712 E.00572
G1 X190.177 Y193.793 E.01536
G1 X170.03 Y193.793 E.72743
G1 X169.926 Y193.84 E.00413
G1 X169.893 Y193.93 E.00344
G1 X169.893 Y209.978 E.57943
G1 X169.839 Y210.306 E.01201
G1 X169.731 Y210.582 E.01069
G1 X169.527 Y210.877 E.01297
G1 X169.335 Y211.041 E.00911
G1 X169.142 Y211.154 E.00807
G1 X168.995 Y211.212 E.00572
G1 X168.577 Y211.293 E.01536
G1 X159.82 Y211.293 E.31617
G1 X159.579 Y211.261 E.00878
G1 X159.337 Y211.188 E.00913
G1 X159.019 Y211.006 E.01322
G1 X158.926 Y210.931 E.00431
G1 X158.759 Y210.735 E.0093
G1 X158.646 Y210.542 E.00808
G1 X158.588 Y210.395 E.00572
G1 X158.507 Y209.977 E.01536
G1 X158.507 Y114.72 E3.43934
G1 X158.539 Y114.479 E.00878
G1 X158.612 Y114.237 E.00913
G1 X158.677 Y114.124 E.00468
M204 S6000
G1 X159.054 Y114.363 F60000
G1 F3000
M204 S500
G1 X159.183 Y114.158 E.00872
G1 X159.285 Y114.06 E.00513
G1 X159.498 Y113.935 E.0089
G1 X159.658 Y113.887 E.00605
G1 X159.81 Y113.864 E.00553
G1 X164.827 Y113.864 E.18115
G1 X164.931 Y113.817 E.00413
G1 X164.964 Y113.727 E.00344
G1 X164.964 Y110.011 E.13418
G1 X164.991 Y109.845 E.00607
G1 X165.05 Y109.67 E.00666
G1 X165.183 Y109.458 E.00905
G1 X165.285 Y109.36 E.00513
G1 X165.498 Y109.235 E.0089
G1 X165.81 Y109.164 E.01155
G1 X190.189 Y109.164 E.88022
G1 X190.355 Y109.191 E.00607
G1 X190.53 Y109.25 E.00666
G1 X190.742 Y109.383 E.00905
G1 X190.842 Y109.487 E.00523
G1 X190.983 Y109.737 E.01036
G1 X191.036 Y110.013 E.01013
G1 X191.036 Y192.489 E2.97788
G1 X191.009 Y192.655 E.00607
G1 X190.95 Y192.83 E.00666
G1 X190.817 Y193.042 E.00905
G1 X190.715 Y193.14 E.00513
G1 X190.502 Y193.265 E.0089
G1 X190.19 Y193.336 E.01155
G1 X169.573 Y193.336 E.7444
G1 X169.469 Y193.383 E.00413
G1 X169.436 Y193.473 E.00344
G1 X169.436 Y209.989 E.59633
G1 X169.409 Y210.155 E.00607
G1 X169.35 Y210.33 E.00666
G1 X169.217 Y210.542 E.00905
G1 X169.115 Y210.64 E.00513
G1 X168.902 Y210.765 E.0089
G1 X168.59 Y210.836 E.01155
G1 X159.811 Y210.836 E.31697
G1 X159.645 Y210.809 E.00607
G1 X159.47 Y210.75 E.00666
G1 X159.258 Y210.617 E.00905
G1 X159.16 Y210.515 E.00513
G1 X159.035 Y210.302 E.0089
G1 X158.964 Y209.99 E.01155
G1 X158.964 Y114.711 E3.44014
G1 X158.991 Y114.545 E.00607
G1 X159.033 Y114.419 E.00482
M204 S6000
G1 X159.467 Y114.563 F60000
G1 F3000
M204 S500
G1 X159.488 Y114.499 E.00244
G1 X159.614 Y114.377 E.00631
G1 X159.8 Y114.321 E.007
G1 X165.421 Y114.321 E.20297
G1 X165.421 Y110 E.15603
G1 X165.488 Y109.799 E.00766
G1 X165.614 Y109.677 E.00631
G1 X165.8 Y109.621 E.007
M73 P37 R10
G1 X190.2 Y109.621 E.88099
G1 X190.401 Y109.688 E.00766
G1 X190.523 Y109.814 E.00631
G1 X190.563 Y109.916 E.00396
G1 X190.579 Y110 E.00307
G1 X190.579 Y192.5 E2.97875
G1 X190.512 Y192.701 E.00766
G1 X190.386 Y192.823 E.00631
G1 X190.2 Y192.879 E.007
G1 X168.979 Y192.879 E.76622
G1 X168.979 Y210 E.61819
G1 X168.912 Y210.201 E.00766
G1 X168.786 Y210.323 E.00631
G1 X168.6 Y210.379 E.007
G1 X159.8 Y210.379 E.31773
G1 X159.599 Y210.312 E.00766
G1 X159.477 Y210.186 E.00631
G1 X159.421 Y210 E.007
G1 X159.421 Y114.7 E3.4409
G1 X159.448 Y114.62 E.00305
; WIPE_START
G1 X159.488 Y114.499 E-.04846
G1 X159.614 Y114.377 E-.06645
G1 X159.8 Y114.321 E-.07367
G1 X161.304 Y114.321 E-.57141
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X161.978 Y121.924 Z.6 F60000
G1 X168.2 Y192.1 Z.6
G1 Z.2
G1 E.8 F1800
; FEATURE: Outer wall
G1 F3000
M204 S500
G1 X168.2 Y209.6 E.63186
G1 X160.2 Y209.6 E.28885
G1 X160.2 Y115.1 E3.41202
G1 X166.2 Y115.1 E.21664
G1 X166.2 Y110.4 E.1697
G1 X189.8 Y110.4 E.8521
G1 X189.8 Y192.1 E2.94986
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

G1 X168.26 Y192.1 E.77772
M204 S6000
G1 X167.743 Y191.643 F60000
; FEATURE: Inner wall
G1 F3000
M204 S500
M73 P38 R10
G1 X167.743 Y209.143 E.63186
G1 X160.657 Y209.143 E.25584
G1 X160.657 Y115.557 E3.37901
G1 X166.657 Y115.557 E.21664
G1 X166.657 Y110.857 E.1697
G1 X189.343 Y110.857 E.8191
G1 X189.343 Y191.643 E2.91686
G1 X167.803 Y191.643 E.77772
M204 S6000
G1 X167.286 Y191.186 F60000
G1 F3000
M204 S500
G1 X167.286 Y208.686 E.63186
G1 X161.114 Y208.686 E.22284
G1 X161.114 Y116.014 E3.34601
G1 X167.114 Y116.014 E.21664
G1 X167.114 Y111.314 E.1697
G1 X188.886 Y111.314 E.78609
G1 X188.886 Y191.186 E2.88385
G1 X167.346 Y191.186 E.77772
; WIPE_START
M73 P39 R10
G1 X167.339 Y193.186 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X169.031 Y185.743 Z.6 F60000
G1 X184.851 Y116.144 Z.6
G1 Z.2
G1 E.8 F1800
; FEATURE: Outer wall
G1 F3000
M204 S500
G1 X184.865 Y116.134 E.00061
G3 X185.437 Y115.958 I.734 J1.365 E.02174
G1 X185.592 Y115.95 E.00562
G3 X184.618 Y116.3 I.007 J1.549 E.3134
G1 X184.801 Y116.177 E.00795
M204 S6000
G1 X184.598 Y115.766 F60000
; FEATURE: Inner wall
G1 F3000
M204 S500
G1 X184.648 Y115.731 E.00218
G3 X185.388 Y115.503 I.951 J1.767 E.02817
G1 X185.589 Y115.492 E.00726
G3 X184.328 Y115.946 I.009 J2.007 E.4059
G1 X184.548 Y115.799 E.00956
M204 S6000
G1 X184.344 Y115.387 F60000
G1 F3000
M204 S500
G1 X184.43 Y115.328 E.00376
G3 X185.34 Y115.048 I1.167 J2.17 E.0346
G1 X185.586 Y115.034 E.00891
G3 X184.037 Y115.591 I.011 J2.464 E.4984
G1 X184.294 Y115.42 E.01115
M204 S6000
G1 X184.147 Y114.967 F60000
G1 F3000
M204 S500
G1 X183.969 Y115.075 E.00752
G2 X188.216 Y118.797 I1.629 J2.425 E.38615
G1 X188.429 Y118.846 E.00788
G1 X188.429 Y190.729 E2.59541
G1 X166.829 Y190.729 E.77989
G1 X166.829 Y201.834 E.40097
G2 X165.213 Y200.692 I-2.626 J2.001 E.07257
M73 P39 R9
G2 X161.774 Y202.208 I-.808 J2.824 E.14721
G1 X161.571 Y202.154 E.0076
G1 X161.571 Y116.471 E3.09366
G1 X167.571 Y116.471 E.21664
G1 X167.571 Y111.771 E.1697
G1 X188.429 Y111.771 E.75308
G1 X188.429 Y116.155 E.15828
G1 X188.216 Y116.204 E.00788
G2 X184.214 Y114.928 I-2.618 J1.296 E.16928
M73 P40 R9
G1 X184.199 Y114.936 E.00062
; WIPE_START
G1 X183.969 Y115.075 E-.10191
G1 X183.747 Y115.239 E-.10475
G1 X183.532 Y115.434 E-.11056
G1 X183.327 Y115.661 E-.11603
G1 X183.148 Y115.908 E-.11614
G1 X182.999 Y116.166 E-.11302
G1 X182.893 Y116.399 E-.0976
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X181.533 Y123.91 Z.6 F60000
G1 X166.829 Y205.166 Z.6
G1 Z.2
G1 E.8 F1800
G1 F3000
M204 S500
G1 X166.829 Y208.229 E.11059
G1 X161.571 Y208.229 E.18983
G1 X161.571 Y204.851 E.12196
G1 X161.772 Y204.795 E.00753
G1 X161.974 Y205.13 E.01412
G2 X166.472 Y205.562 I2.427 J-1.632 E.18649
G1 X166.789 Y205.211 E.01706
; WIPE_START
G1 X166.815 Y207.21 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X164.991 Y202.068 Z.6 F60000
G1 Z.2
G1 E.8 F1800
; FEATURE: Outer wall
G1 F3000
M204 S500
G1 X165.26 Y202.211 E.011
G3 X164.237 Y201.958 I-.861 J1.288 E.31272
G1 X164.392 Y201.95 E.00562
G3 X164.936 Y202.046 I.007 J1.55 E.02003
M204 S6000
G1 X165.204 Y201.665 F60000
; FEATURE: Inner wall
G1 F3000
M204 S500
G1 X165.513 Y201.83 E.01265
G3 X164.189 Y201.503 I-1.115 J1.669 E.40503
G1 X164.389 Y201.492 E.00726
G3 X165.151 Y201.638 I.009 J2.007 E.02817
M204 S6000
G1 X165.226 Y201.185 F60000
G1 F3000
M204 S500
G1 X165.323 Y201.215 E.00365
G3 X164.14 Y201.048 I-.925 J2.284 E.51549
G1 X164.386 Y201.034 E.0089
G3 X164.864 Y201.079 I.011 J2.464 E.01736
G1 X165.169 Y201.168 E.01146
; WIPE_START
G1 X165.323 Y201.215 E-.0612
G1 X165.556 Y201.322 E-.09759
G1 X165.767 Y201.448 E-.09346
G1 X166.144 Y201.756 E-.1847
G1 X166.316 Y201.948 E-.09787
G1 X166.468 Y202.157 E-.09832
G1 X166.594 Y202.375 E-.09576
G1 X166.624 Y202.451 E-.0311
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X166.74 Y202.118 Z.6 F60000
G1 Z.2
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.116686
G1 F3000
M204 S500
G1 X166.835 Y202.248 E.00094
; LINE_WIDTH: 0.149939
G1 X166.906 Y202.356 E.00109
; LINE_WIDTH: 0.188654
G1 X166.975 Y202.461 E.00144
; LINE_WIDTH: 0.183814
G1 X166.999 Y202.6 E.00157
; LINE_WIDTH: 0.138356
G1 X167.021 Y202.731 E.001
; LINE_WIDTH: 0.109404
G1 X167.031 Y202.816 E.00045
; WIPE_START
G1 X167.021 Y202.731 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X167.031 Y204.185 Z.6 F60000
G1 Z.2
G1 E.8 F1800
; LINE_WIDTH: 0.108173
G1 F3000
M204 S500
G1 X167.022 Y204.26 E.00039
; LINE_WIDTH: 0.136326
G1 X166.999 Y204.395 E.001
; LINE_WIDTH: 0.182923
G1 X166.975 Y204.539 E.00162
; LINE_WIDTH: 0.188689
G1 X166.907 Y204.643 E.00144
; LINE_WIDTH: 0.15006
G1 X166.836 Y204.751 E.00109
; LINE_WIDTH: 0.116767
G1 X166.74 Y204.882 E.00095
; WIPE_START
G1 X166.836 Y204.751 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X166.646 Y206.586 Z.6 F60000
G1 Z.2
G1 E.8 F1800
; FEATURE: Bottom surface
; LINE_WIDTH: 0.51914
G1 F6300
M204 S500
G1 X166.283 Y206.223 E.01931
G3 X165.857 Y206.47 I-2.291 J-3.453 E.01854
G1 X166.44 Y207.054 E.03102
G1 X166.44 Y207.727 E.02533
G1 X165.377 Y206.664 E.05656
G3 X164.821 Y206.782 I-1.167 J-4.145 E.02139
G1 X165.88 Y207.84 E.05633
G1 X165.207 Y207.84 E.02533
G1 X164.167 Y206.801 E.05532
G3 X163.32 Y206.627 I.085 J-2.571 E.03267
G1 X164.533 Y207.84 E.06453
G1 X163.86 Y207.84 E.02533
G1 X161.96 Y205.94 E.10109
G1 X161.96 Y206.614 E.02533
G1 X163.186 Y207.84 E.06526
G1 X162.513 Y207.84 E.02533
G1 X161.754 Y207.082 E.04037
; WIPE_START
G1 X162.513 Y207.84 E-.4078
G1 X163.186 Y207.84 E-.25592
G1 X163.007 Y207.661 E-.09628
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X161.901 Y204.522 Z.6 F60000
G1 Z.2
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.519574
G1 F3000
M204 S500
G1 X161.588 Y204.355 E.01337
G1 X161.569 Y204.204 E.00573
; LINE_WIDTH: 0.478417
G1 X161.552 Y204.066 E.0048
; LINE_WIDTH: 0.439867
G3 X161.531 Y203.776 I5.563 J-.55 E.0091
; LINE_WIDTH: 0.412421
G3 X161.531 Y203.215 I8.099 J-.275 E.01637
; LINE_WIDTH: 0.438564
G3 X161.55 Y202.956 I5.422 J.263 E.00813
; LINE_WIDTH: 0.473526
G1 X161.566 Y202.817 E.00477
; LINE_WIDTH: 0.504248
G1 X161.58 Y202.696 E.00444
; LINE_WIDTH: 0.528544
G3 X161.628 Y202.406 I6.155 J.868 E.01127
M204 S6000
G1 X161.8 Y201.604 F60000
; LINE_WIDTH: 0.14633
G1 F3000
M204 S500
G1 X161.912 Y201.49 E.00131
; LINE_WIDTH: 0.118611
G1 X162.055 Y201.359 E.00116
; WIPE_START
G1 X161.912 Y201.49 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X164.21 Y194.211 Z.6 F60000
G1 X188.098 Y118.535 Z.6
G1 Z.2
G1 E.8 F1800
; LINE_WIDTH: 0.463763
G1 F3000
M204 S500
G1 X188.379 Y118.375 E.01077
; LINE_WIDTH: 0.516201
G1 X188.412 Y118.355 E.0014
G1 X188.427 Y118.235 E.00454
; LINE_WIDTH: 0.487135
G1 X188.443 Y118.114 E.00426
; LINE_WIDTH: 0.446494
G2 X188.467 Y117.812 I-5.891 J-.627 E.00966
; LINE_WIDTH: 0.413134
G2 X188.469 Y117.212 I-8.282 J-.316 E.01754
; LINE_WIDTH: 0.440094
G2 X188.448 Y116.939 I-5.613 J.278 E.00859
; LINE_WIDTH: 0.478905
G1 X188.43 Y116.785 E.00535
; LINE_WIDTH: 0.51456
G1 X188.413 Y116.651 E.00504
; LINE_WIDTH: 0.516314
G1 X188.098 Y116.466 E.01367
; WIPE_START
G1 X188.413 Y116.651 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X188.246 Y112.883 Z.6 F60000
G1 Z.2
G1 E.8 F1800
; FEATURE: Bottom surface
; LINE_WIDTH: 0.50251
G1 F6300
M204 S500
G1 X187.522 Y112.16 E.03715
G1 X186.873 Y112.16 E.0236
G1 X188.04 Y113.327 E.05996
G1 X188.04 Y113.977 E.0236
G1 X186.223 Y112.16 E.09333
G1 X185.573 Y112.16 E.0236
G1 X188.04 Y114.627 E.1267
G1 X188.04 Y115.267 E.0232
G2 X184.923 Y112.16 I-824.364 J824.117 E.15979
G1 X184.273 Y112.16 E.0236
G1 X186.404 Y114.291 E.10943
G2 X185.654 Y114.191 I-.824 J3.32 E.02753
G1 X183.623 Y112.16 E.10429
G1 X182.973 Y112.16 E.0236
G1 X185.051 Y114.238 E.10669
G2 X184.532 Y114.368 I.545 J3.258 E.01946
G1 X182.323 Y112.16 E.11341
G1 X181.673 Y112.16 E.0236
G1 X184.075 Y114.562 E.12335
G2 X183.673 Y114.81 I1.868 J3.48 E.01716
G1 X181.023 Y112.16 E.13607
G1 X180.373 Y112.16 E.0236
G1 X183.317 Y115.104 E.15117
G2 X183.006 Y115.442 I3.241 J3.295 E.01671
G1 X179.723 Y112.16 E.16855
G1 X179.073 Y112.16 E.0236
G1 X182.744 Y115.831 E.18848
G2 X182.528 Y116.264 I3.842 J2.188 E.0176
G1 X178.423 Y112.16 E.21074
G1 X177.773 Y112.16 E.0236
G1 X182.375 Y116.761 E.23626
G2 X182.296 Y117.333 I3.186 J.73 E.02096
G1 X177.123 Y112.16 E.2656
G1 X176.473 Y112.16 E.0236
G1 X182.598 Y118.285 E.31448
; WIPE_START
G1 X181.184 Y116.871 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X187.85 Y119.637 Z.6 F60000
G1 Z.2
G1 E.8 F1800
G1 F6300
M204 S500
G1 X188.04 Y119.827 E.00976
G1 X188.04 Y120.477 E.0236
G1 X187.657 Y120.093 E.0197
G3 X187.269 Y120.356 I-1.525 J-1.831 E.01702
G1 X188.04 Y121.127 E.03958
G1 X188.04 Y121.777 E.0236
G1 X186.834 Y120.571 E.06191
G3 X186.339 Y120.725 I-.994 J-2.32 E.01888
G1 X188.04 Y122.427 E.08736
G1 X188.04 Y123.077 E.0236
G1 X185.767 Y120.804 E.1167
G3 X185.081 Y120.768 I-.168 J-3.334 E.02499
G1 X188.04 Y123.727 E.15193
M73 P41 R9
G1 X188.04 Y124.377 E.0236
G1 X175.823 Y112.16 E.62725
G1 X175.173 Y112.16 E.0236
G1 X188.04 Y125.027 E.66062
G1 X188.04 Y125.677 E.0236
G1 X174.523 Y112.16 E.694
G1 X173.873 Y112.16 E.0236
G1 X188.04 Y126.327 E.72737
G1 X188.04 Y126.977 E.0236
G1 X173.223 Y112.16 E.76074
G1 X172.573 Y112.16 E.0236
G1 X188.04 Y127.627 E.79411
G1 X188.04 Y128.277 E.0236
G1 X171.923 Y112.16 E.82748
G1 X171.274 Y112.16 E.0236
G1 X188.04 Y128.927 E.86085
G1 X188.04 Y129.576 E.0236
G1 X170.624 Y112.16 E.89422
G1 X169.974 Y112.16 E.0236
G1 X188.04 Y130.226 E.92759
G1 X188.04 Y130.876 E.0236
G1 X169.324 Y112.16 E.96096
G1 X168.674 Y112.16 E.0236
G1 X188.04 Y131.526 E.99433
G1 X188.04 Y132.176 E.0236
G1 X168.024 Y112.16 E1.0277
G1 X167.96 Y112.16 E.00233
G1 X167.96 Y112.745 E.02127
G1 X188.04 Y132.826 E1.03099
G1 X188.04 Y133.476 E.0236
G1 X167.96 Y113.395 E1.03099
G1 X167.96 Y114.045 E.0236
G1 X188.04 Y134.126 E1.03099
G1 X188.04 Y134.776 E.0236
G1 X167.96 Y114.695 E1.03099
G1 X167.96 Y115.345 E.0236
G1 X188.04 Y135.426 E1.03099
G1 X188.04 Y136.076 E.0236
G1 X167.96 Y115.995 E1.03099
G1 X167.96 Y116.645 E.0236
G1 X188.04 Y136.726 E1.03099
G1 X188.04 Y137.376 E.0236
G1 X167.524 Y116.86 E1.05335
G1 X166.874 Y116.86 E.0236
G1 X188.04 Y138.026 E1.08672
G1 X188.04 Y138.676 E.0236
M73 P42 R9
G1 X166.224 Y116.86 E1.12009
G1 X165.574 Y116.86 E.0236
G1 X188.04 Y139.326 E1.15346
G1 X188.04 Y139.976 E.0236
G1 X164.924 Y116.86 E1.18683
G1 X164.274 Y116.86 E.0236
G1 X188.04 Y140.626 E1.2202
G1 X188.04 Y141.276 E.0236
G1 X163.624 Y116.86 E1.25357
G1 X162.974 Y116.86 E.0236
G1 X188.04 Y141.926 E1.28694
G1 X188.04 Y142.576 E.0236
G1 X162.324 Y116.86 E1.32031
G1 X161.96 Y116.86 E.01324
G1 X161.96 Y117.145 E.01035
G1 X188.04 Y143.226 E1.33904
G1 X188.04 Y143.876 E.0236
G1 X161.96 Y117.795 E1.33904
G1 X161.96 Y118.445 E.0236
G1 X188.04 Y144.526 E1.33904
G1 X188.04 Y145.175 E.0236
G1 X161.96 Y119.095 E1.33904
G1 X161.96 Y119.745 E.0236
G1 X188.04 Y145.825 E1.33904
G1 X188.04 Y146.475 E.0236
G1 X161.96 Y120.395 E1.33904
G1 X161.96 Y121.045 E.0236
G1 X188.04 Y147.125 E1.33904
G1 X188.04 Y147.775 E.0236
G1 X161.96 Y121.695 E1.33904
G1 X161.96 Y122.344 E.0236
G1 X188.04 Y148.425 E1.33904
G1 X188.04 Y149.075 E.0236
G1 X161.96 Y122.994 E1.33904
G1 X161.96 Y123.644 E.0236
G1 X188.04 Y149.725 E1.33904
G1 X188.04 Y150.375 E.0236
M73 P43 R9
G1 X161.96 Y124.294 E1.33904
G1 X161.96 Y124.944 E.0236
G1 X188.04 Y151.025 E1.33904
G1 X188.04 Y151.675 E.0236
G1 X161.96 Y125.594 E1.33904
G1 X161.96 Y126.244 E.0236
G1 X188.04 Y152.325 E1.33904
G1 X188.04 Y152.975 E.0236
G1 X161.96 Y126.894 E1.33904
G1 X161.96 Y127.544 E.0236
G1 X188.04 Y153.625 E1.33904
G1 X188.04 Y154.275 E.0236
G1 X161.96 Y128.194 E1.33904
G1 X161.96 Y128.844 E.0236
G1 X188.04 Y154.925 E1.33904
G1 X188.04 Y155.575 E.0236
G1 X161.96 Y129.494 E1.33904
G1 X161.96 Y130.144 E.0236
G1 X188.04 Y156.225 E1.33904
G1 X188.04 Y156.875 E.0236
G1 X161.96 Y130.794 E1.33904
G1 X161.96 Y131.444 E.0236
G1 X188.04 Y157.525 E1.33904
G1 X188.04 Y158.175 E.0236
G1 X161.96 Y132.094 E1.33904
G1 X161.96 Y132.744 E.0236
G1 X188.04 Y158.825 E1.33904
G1 X188.04 Y159.475 E.0236
G1 X161.96 Y133.394 E1.33904
G1 X161.96 Y134.044 E.0236
G1 X188.04 Y160.125 E1.33904
G1 X188.04 Y160.774 E.0236
G1 X161.96 Y134.694 E1.33904
G1 X161.96 Y135.344 E.0236
G1 X188.04 Y161.424 E1.33904
G1 X188.04 Y162.074 E.0236
M73 P44 R9
G1 X161.96 Y135.994 E1.33904
G1 X161.96 Y136.644 E.0236
G1 X188.04 Y162.724 E1.33904
G1 X188.04 Y163.374 E.0236
G1 X161.96 Y137.294 E1.33904
G1 X161.96 Y137.943 E.0236
G1 X188.04 Y164.024 E1.33904
G1 X188.04 Y164.674 E.0236
G1 X161.96 Y138.593 E1.33904
G1 X161.96 Y139.243 E.0236
G1 X188.04 Y165.324 E1.33904
G1 X188.04 Y165.974 E.0236
G1 X161.96 Y139.893 E1.33904
G1 X161.96 Y140.543 E.0236
G1 X188.04 Y166.624 E1.33904
G1 X188.04 Y167.274 E.0236
G1 X161.96 Y141.193 E1.33904
G1 X161.96 Y141.843 E.0236
G1 X188.04 Y167.924 E1.33904
G1 X188.04 Y168.574 E.0236
G1 X161.96 Y142.493 E1.33904
G1 X161.96 Y143.143 E.0236
G1 X188.04 Y169.224 E1.33904
G1 X188.04 Y169.874 E.0236
G1 X161.96 Y143.793 E1.33904
G1 X161.96 Y144.443 E.0236
G1 X188.04 Y170.524 E1.33904
G1 X188.04 Y171.174 E.0236
G1 X161.96 Y145.093 E1.33904
G1 X161.96 Y145.743 E.0236
G1 X188.04 Y171.824 E1.33904
G1 X188.04 Y172.474 E.0236
G1 X161.96 Y146.393 E1.33904
G1 X161.96 Y147.043 E.0236
M73 P45 R9
G1 X188.04 Y173.124 E1.33904
G1 X188.04 Y173.774 E.0236
G1 X161.96 Y147.693 E1.33904
G1 X161.96 Y148.343 E.0236
G1 X188.04 Y174.424 E1.33904
G1 X188.04 Y175.074 E.0236
G1 X161.96 Y148.993 E1.33904
G1 X161.96 Y149.643 E.0236
G1 X188.04 Y175.724 E1.33904
G1 X188.04 Y176.373 E.0236
G1 X161.96 Y150.293 E1.33904
G1 X161.96 Y150.943 E.0236
G1 X188.04 Y177.023 E1.33904
G1 X188.04 Y177.673 E.0236
G1 X161.96 Y151.593 E1.33904
G1 X161.96 Y152.243 E.0236
G1 X188.04 Y178.323 E1.33904
G1 X188.04 Y178.973 E.0236
G1 X161.96 Y152.893 E1.33904
G1 X161.96 Y153.543 E.0236
G1 X188.04 Y179.623 E1.33904
G1 X188.04 Y180.273 E.0236
G1 X161.96 Y154.192 E1.33904
G1 X161.96 Y154.842 E.0236
M73 P45 R8
G1 X188.04 Y180.923 E1.33904
G1 X188.04 Y181.573 E.0236
G1 X161.96 Y155.492 E1.33904
G1 X161.96 Y156.142 E.0236
G1 X188.04 Y182.223 E1.33904
G1 X188.04 Y182.873 E.0236
G1 X161.96 Y156.792 E1.33904
G1 X161.96 Y157.442 E.0236
G1 X188.04 Y183.523 E1.33904
G1 X188.04 Y184.173 E.0236
M73 P46 R8
G1 X161.96 Y158.092 E1.33904
G1 X161.96 Y158.742 E.0236
G1 X188.04 Y184.823 E1.33904
G1 X188.04 Y185.473 E.0236
G1 X161.96 Y159.392 E1.33904
G1 X161.96 Y160.042 E.0236
G1 X188.04 Y186.123 E1.33904
G1 X188.04 Y186.773 E.0236
G1 X161.96 Y160.692 E1.33904
G1 X161.96 Y161.342 E.0236
G1 X188.04 Y187.423 E1.33904
G1 X188.04 Y188.073 E.0236
G1 X161.96 Y161.992 E1.33904
G1 X161.96 Y162.642 E.0236
G1 X188.04 Y188.723 E1.33904
G1 X188.04 Y189.373 E.0236
G1 X161.96 Y163.292 E1.33904
G1 X161.96 Y163.942 E.0236
G1 X188.04 Y190.023 E1.33904
G1 X188.04 Y190.34 E.01154
G1 X187.708 Y190.34 E.01206
G1 X161.96 Y164.592 E1.32199
G1 X161.96 Y165.242 E.0236
G1 X187.058 Y190.34 E1.28862
G1 X186.408 Y190.34 E.0236
G1 X161.96 Y165.892 E1.25525
G1 X161.96 Y166.542 E.0236
G1 X185.758 Y190.34 E1.22188
G1 X185.108 Y190.34 E.0236
G1 X161.96 Y167.192 E1.1885
G1 X161.96 Y167.842 E.0236
G1 X184.458 Y190.34 E1.15513
G1 X183.808 Y190.34 E.0236
G1 X161.96 Y168.492 E1.12176
G1 X161.96 Y169.141 E.0236
G1 X183.159 Y190.34 E1.08839
G1 X182.509 Y190.34 E.0236
M73 P47 R8
G1 X161.96 Y169.791 E1.05502
G1 X161.96 Y170.441 E.0236
G1 X181.859 Y190.34 E1.02165
G1 X181.209 Y190.34 E.0236
G1 X161.96 Y171.091 E.98828
G1 X161.96 Y171.741 E.0236
G1 X180.559 Y190.34 E.95491
G1 X179.909 Y190.34 E.0236
G1 X161.96 Y172.391 E.92154
G1 X161.96 Y173.041 E.0236
G1 X179.259 Y190.34 E.88817
G1 X178.609 Y190.34 E.0236
G1 X161.96 Y173.691 E.8548
G1 X161.96 Y174.341 E.0236
G1 X177.959 Y190.34 E.82143
G1 X177.309 Y190.34 E.0236
G1 X161.96 Y174.991 E.78806
G1 X161.96 Y175.641 E.0236
G1 X176.659 Y190.34 E.75469
G1 X176.009 Y190.34 E.0236
G1 X161.96 Y176.291 E.72132
G1 X161.96 Y176.941 E.0236
G1 X175.359 Y190.34 E.68795
G1 X174.709 Y190.34 E.0236
G1 X161.96 Y177.591 E.65458
G1 X161.96 Y178.241 E.0236
G1 X174.059 Y190.34 E.62121
G1 X173.409 Y190.34 E.0236
G1 X161.96 Y178.891 E.58784
G1 X161.96 Y179.541 E.0236
G1 X172.759 Y190.34 E.55447
G1 X172.109 Y190.34 E.0236
G1 X161.96 Y180.191 E.5211
G1 X161.96 Y180.841 E.0236
G1 X171.459 Y190.34 E.48773
G1 X170.809 Y190.34 E.0236
G1 X161.96 Y181.491 E.45436
G1 X161.96 Y182.141 E.0236
G1 X170.159 Y190.34 E.42099
G1 X169.509 Y190.34 E.0236
G1 X161.96 Y182.791 E.38762
G1 X161.96 Y183.441 E.0236
G1 X168.859 Y190.34 E.35425
G1 X168.209 Y190.34 E.0236
G1 X161.96 Y184.091 E.32088
G1 X161.96 Y184.74 E.0236
G1 X167.56 Y190.34 E.28751
G1 X166.91 Y190.34 E.0236
G1 X161.96 Y185.39 E.25414
M73 P48 R8
G1 X161.96 Y186.04 E.0236
G1 X166.44 Y190.521 E.23005
G1 X166.44 Y191.171 E.0236
G1 X161.96 Y186.69 E.23005
G1 X161.96 Y187.34 E.0236
G1 X166.44 Y191.821 E.23005
G1 X166.44 Y192.471 E.0236
G1 X161.96 Y187.99 E.23005
G1 X161.96 Y188.64 E.0236
G1 X166.44 Y193.121 E.23005
G1 X166.44 Y193.771 E.0236
G1 X161.96 Y189.29 E.23005
G1 X161.96 Y189.94 E.0236
G1 X166.44 Y194.421 E.23005
G1 X166.44 Y195.071 E.0236
G1 X161.96 Y190.59 E.23005
G1 X161.96 Y191.24 E.0236
G1 X166.44 Y195.721 E.23005
G1 X166.44 Y196.371 E.0236
G1 X161.96 Y191.89 E.23005
G1 X161.96 Y192.54 E.0236
G1 X166.44 Y197.021 E.23005
G1 X166.44 Y197.671 E.0236
G1 X161.96 Y193.19 E.23005
G1 X161.96 Y193.84 E.0236
G1 X166.44 Y198.321 E.23005
G1 X166.44 Y198.971 E.0236
G1 X161.96 Y194.49 E.23005
G1 X161.96 Y195.14 E.0236
G1 X166.44 Y199.621 E.23005
G1 X166.44 Y200.271 E.0236
G1 X161.96 Y195.79 E.23005
G1 X161.96 Y196.44 E.0236
G1 X166.339 Y200.82 E.22487
G2 X165.147 Y200.277 I-1.951 J2.704 E.04789
G1 X161.96 Y197.09 E.16363
G1 X161.96 Y197.74 E.0236
G1 X164.409 Y200.189 E.12576
G2 X163.814 Y200.244 I.066 J4.001 E.02173
G1 X161.96 Y198.39 E.09519
G1 X161.96 Y199.04 E.0236
G1 X163.302 Y200.382 E.0689
G1 X162.846 Y200.576 E.01798
G1 X161.96 Y199.69 E.0455
G1 X161.96 Y200.339 E.0236
G1 X162.595 Y200.975 E.03264
; CHANGE_LAYER
; Z_HEIGHT: 0.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F6300
G1 X161.96 Y200.339 E-.34169
G1 X161.96 Y199.69 E-.24698
G1 X162.278 Y200.008 E-.17133
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 2/10
; update layer progress
M73 L2
M991 S0 P1 ;notify layer change

; open powerlost recovery
M1003 S1
; OBJECT_ID: 15
M204 S10000
G17
G3 Z.6 I1.177 J.307 P1  F60000
G1 X184.419 Y115.223 Z.6
G1 Z.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X184.597 Y115.136 E.00636
G3 X185.326 Y114.947 I1.002 J2.363 E.02433
G1 X185.569 Y114.932 E.00783
G3 X184.355 Y115.254 I.029 J2.566 E.47769
G1 X184.365 Y115.249 E.00035
M204 S10000
G1 X184.634 Y115.576 F60000
G1 F8843.478
M204 S8000
G1 X184.964 Y115.435 E.01154
G3 X185.37 Y115.352 I.635 J2.064 E.01336
G1 X185.574 Y115.34 E.00656
G3 X184.553 Y115.61 I.025 J2.159 E.40188
G1 X184.579 Y115.599 E.00091
M204 S10000
G1 X184.793 Y115.949 F60000
G1 F8843.478
M204 S8000
G1 X185.085 Y115.824 E.01022
G3 X185.414 Y115.757 I.514 J1.674 E.01083
G1 X185.578 Y115.747 E.00528
G3 X184.738 Y115.974 I.021 J1.752 E.32562
M204 S250
G1 X184.945 Y116.308 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X185.201 Y116.199 E.00829
G3 X185.457 Y116.147 I.398 J1.3 E.00778
G1 X185.583 Y116.14 E.00376
G3 X184.893 Y116.338 I.017 J1.359 E.23278
; WIPE_START
M204 S8000
G1 X185.201 Y116.199 E-.12843
G1 X185.457 Y116.147 E-.09906
G1 X185.583 Y116.14 E-.04793
G1 X185.859 Y116.165 E-.10534
G1 X186.109 Y116.239 E-.09906
G1 X186.341 Y116.359 E-.09935
G1 X186.546 Y116.522 E-.09949
G1 X186.685 Y116.685 E-.08133
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X184.749 Y124.068 Z.8 F60000
G1 X167.184 Y191.084 Z.8
G1 Z.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X167.184 Y203.237 E.39079
G1 X166.96 Y203.255 E.00723
G2 X166.87 Y204.203 I-2.556 J.236 E.48779
G2 X166.954 Y203.74 I-2.169 J-.636 E.01518
G1 X167.184 Y203.754 E.00739
G1 X167.184 Y208.584 E.15532
G1 X161.216 Y208.584 E.1919
G1 X161.216 Y116.116 E2.97342
G1 X167.216 Y116.116 E.19294
G1 X167.216 Y111.416 E.15113
G1 X188.784 Y111.416 E.69354
G1 X188.784 Y191.084 E2.56182
G1 X167.244 Y191.084 E.69265
; WIPE_START
G1 X167.234 Y193.084 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X165.506 Y200.518 Z.8 F60000
G1 X165.271 Y201.53 Z.8
G1 Z.4
G1 E.8 F1800
G1 F8843.478
M204 S8000
G1 X165.573 Y201.687 E.01096
G3 X164.171 Y201.352 I-1.174 J1.812 E.38891
G1 X164.374 Y201.34 E.00655
G3 X165.206 Y201.496 I.025 J2.159 E.0274
G1 X165.218 Y201.502 E.00043
M204 S10000
G1 X165.085 Y201.89 F60000
G1 F8843.478
M204 S8000
G1 X165.353 Y202.029 E.00971
G3 X164.215 Y201.757 I-.953 J1.469 E.31554
G1 X164.378 Y201.747 E.00528
G3 X165.03 Y201.865 I.021 J1.751 E.02143
M204 S250
G1 X164.909 Y202.239 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G3 X164.257 Y202.147 I-.509 J1.26 E.23459
G1 X164.383 Y202.14 E.00376
G3 X164.853 Y202.218 I.017 J1.359 E.01427
; WIPE_START
M204 S8000
G1 X165.14 Y202.359 E-.12167
G1 X165.345 Y202.522 E-.09948
G1 X165.515 Y202.72 E-.09915
G1 X165.645 Y202.953 E-.10131
G1 X165.73 Y203.216 E-.10533
G1 X165.76 Y203.475 E-.09891
G1 X165.74 Y203.736 E-.09957
G1 X165.715 Y203.824 E-.03458
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X166.863 Y196.278 Z.8 F60000
G1 X167.591 Y191.491 Z.8
G1 Z.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X167.591 Y208.991 E.56274
G1 X160.809 Y208.991 E.21808
G1 X160.809 Y115.709 E2.9996
G1 X166.809 Y115.709 E.19294
G1 X166.809 Y111.009 E.15113
G1 X189.191 Y111.009 E.71972
M73 P49 R8
G1 X189.191 Y191.491 E2.588
G1 X167.651 Y191.491 E.69265
M204 S10000
G1 X167.998 Y191.898 F60000
G1 F8843.478
M204 S8000
G1 X167.998 Y209.398 E.56274
G1 X160.402 Y209.398 E.24426
G1 X160.402 Y115.302 E3.02578
G1 X166.402 Y115.302 E.19294
G1 X166.402 Y110.602 E.15113
G1 X189.598 Y110.602 E.7459
G1 X189.598 Y191.898 E2.61418
G1 X168.058 Y191.898 E.69265
M204 S250
G1 X168.39 Y192.29 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X168.39 Y209.79 E.52127
G1 X160.01 Y209.79 E.24961
G1 X160.01 Y114.91 E2.82615
G1 X166.01 Y114.91 E.17872
G1 X166.01 Y110.21 E.14
G1 X189.99 Y110.21 E.71428
G1 X189.99 Y192.29 E2.44488
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

G1 X168.45 Y192.29 E.6416
; WIPE_START
M204 S8000
G1 X168.443 Y194.29 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X161.38 Y196.046 Z.8 F60000
G1 Z.4
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42037
G1 F9537.687
M204 S8000
G1 X188.451 Y168.975 E1.14147
G1 X188.451 Y168.441 E.01592
G1 X161.549 Y195.343 E1.13432
G1 X161.549 Y194.809 E.01592
G1 X188.451 Y167.908 E1.13432
G1 X188.451 Y167.374 E.01592
G1 X161.549 Y194.275 E1.13432
G1 X161.549 Y193.741 E.01592
G1 X188.451 Y166.84 E1.13432
G1 X188.451 Y166.306 E.01592
G1 X161.549 Y193.207 E1.13432
G1 X161.549 Y192.674 E.01592
G1 X188.451 Y165.772 E1.13432
G1 X188.451 Y165.239 E.01592
G1 X161.549 Y192.14 E1.13432
G1 X161.549 Y191.606 E.01592
G1 X188.451 Y164.705 E1.13432
G1 X188.451 Y164.171 E.01592
G1 X161.549 Y191.072 E1.13432
G1 X161.549 Y190.538 E.01592
G1 X188.451 Y163.637 E1.13432
G1 X188.451 Y163.103 E.01592
G1 X161.549 Y190.005 E1.13432
G1 X161.549 Y189.471 E.01592
G1 X188.451 Y162.57 E1.13432
G1 X188.451 Y162.036 E.01592
G1 X161.549 Y188.937 E1.13432
G1 X161.549 Y188.403 E.01592
G1 X188.451 Y161.502 E1.13432
G1 X188.451 Y160.968 E.01592
G1 X161.549 Y187.87 E1.13432
G1 X161.549 Y187.336 E.01592
G1 X188.451 Y160.434 E1.13432
G1 X188.451 Y159.901 E.01592
G1 X161.549 Y186.802 E1.13432
G1 X161.549 Y186.268 E.01592
G1 X188.451 Y159.367 E1.13432
G1 X188.451 Y158.833 E.01592
M73 P50 R8
G1 X161.549 Y185.734 E1.13432
G1 X161.549 Y185.201 E.01592
G1 X188.451 Y158.299 E1.13432
G1 X188.451 Y157.765 E.01592
G1 X161.549 Y184.667 E1.13432
G1 X161.549 Y184.133 E.01592
G1 X188.451 Y157.232 E1.13432
G1 X188.451 Y156.698 E.01592
G1 X161.549 Y183.599 E1.13432
G1 X161.549 Y183.065 E.01592
G1 X188.451 Y156.164 E1.13432
G1 X188.451 Y155.63 E.01592
G1 X161.549 Y182.532 E1.13432
G1 X161.549 Y181.998 E.01592
G1 X188.451 Y155.096 E1.13432
G1 X188.451 Y154.563 E.01592
G1 X161.549 Y181.464 E1.13432
G1 X161.549 Y180.93 E.01592
G1 X188.451 Y154.029 E1.13432
G1 X188.451 Y153.495 E.01592
G1 X161.549 Y180.396 E1.13432
G1 X161.549 Y179.863 E.01592
G1 X188.451 Y152.961 E1.13432
G1 X188.451 Y152.428 E.01592
G1 X161.549 Y179.329 E1.13432
G1 X161.549 Y178.795 E.01592
G1 X188.451 Y151.894 E1.13432
G1 X188.451 Y151.36 E.01592
G1 X161.549 Y178.261 E1.13432
G1 X161.549 Y177.727 E.01592
G1 X188.451 Y150.826 E1.13432
G1 X188.451 Y150.292 E.01592
G1 X161.549 Y177.194 E1.13432
G1 X161.549 Y176.66 E.01592
G1 X188.451 Y149.759 E1.13432
G1 X188.451 Y149.225 E.01592
G1 X161.549 Y176.126 E1.13432
G1 X161.549 Y175.592 E.01592
G1 X188.451 Y148.691 E1.13432
G1 X188.451 Y148.157 E.01592
G1 X161.549 Y175.058 E1.13432
G1 X161.549 Y174.525 E.01592
G1 X188.451 Y147.623 E1.13432
G1 X188.451 Y147.09 E.01592
G1 X161.549 Y173.991 E1.13432
G1 X161.549 Y173.457 E.01592
G1 X188.451 Y146.556 E1.13432
G1 X188.451 Y146.022 E.01592
G1 X161.549 Y172.923 E1.13432
G1 X161.549 Y172.389 E.01592
G1 X188.451 Y145.488 E1.13432
G1 X188.451 Y144.954 E.01592
G1 X161.549 Y171.856 E1.13432
G1 X161.549 Y171.322 E.01592
G1 X188.451 Y144.421 E1.13432
G1 X188.451 Y143.887 E.01592
G1 X161.549 Y170.788 E1.13432
G1 X161.549 Y170.254 E.01592
G1 X188.451 Y143.353 E1.13432
G1 X188.451 Y142.819 E.01592
G1 X161.549 Y169.72 E1.13432
G1 X161.549 Y169.187 E.01592
G1 X188.451 Y142.285 E1.13432
G1 X188.451 Y141.752 E.01592
G1 X161.549 Y168.653 E1.13432
G1 X161.549 Y168.119 E.01592
G1 X188.451 Y141.218 E1.13432
G1 X188.451 Y140.684 E.01592
G1 X161.549 Y167.585 E1.13432
G1 X161.549 Y167.052 E.01592
G1 X188.451 Y140.15 E1.13432
G1 X188.451 Y139.616 E.01592
M73 P51 R8
G1 X161.549 Y166.518 E1.13432
G1 X161.549 Y165.984 E.01592
G1 X188.451 Y139.083 E1.13432
G1 X188.451 Y138.549 E.01592
G1 X161.549 Y165.45 E1.13432
G1 X161.549 Y164.916 E.01592
G1 X188.451 Y138.015 E1.13432
G1 X188.451 Y137.481 E.01592
G1 X161.549 Y164.383 E1.13432
G1 X161.549 Y163.849 E.01592
G1 X188.451 Y136.947 E1.13432
G1 X188.451 Y136.414 E.01592
G1 X161.549 Y163.315 E1.13432
G1 X161.549 Y162.781 E.01592
G1 X188.451 Y135.88 E1.13432
G1 X188.451 Y135.346 E.01592
G1 X161.549 Y162.247 E1.13432
G1 X161.549 Y161.714 E.01592
G1 X188.451 Y134.812 E1.13432
G1 X188.451 Y134.278 E.01592
G1 X161.549 Y161.18 E1.13432
G1 X161.549 Y160.646 E.01592
G1 X188.451 Y133.745 E1.13432
G1 X188.451 Y133.211 E.01592
G1 X161.549 Y160.112 E1.13432
G1 X161.549 Y159.578 E.01592
G1 X188.451 Y132.677 E1.13432
G1 X188.451 Y132.143 E.01592
G1 X161.549 Y159.045 E1.13432
G1 X161.549 Y158.511 E.01592
G1 X188.451 Y131.61 E1.13432
G1 X188.451 Y131.076 E.01592
G1 X161.549 Y157.977 E1.13432
G1 X161.549 Y157.443 E.01592
G1 X188.451 Y130.542 E1.13432
G1 X188.451 Y130.008 E.01592
G1 X161.549 Y156.909 E1.13432
G1 X161.549 Y156.376 E.01592
G1 X188.451 Y129.474 E1.13432
G1 X188.451 Y128.941 E.01592
G1 X161.549 Y155.842 E1.13432
G1 X161.549 Y155.308 E.01592
G1 X188.451 Y128.407 E1.13432
G1 X188.451 Y127.873 E.01592
G1 X161.549 Y154.774 E1.13432
G1 X161.549 Y154.24 E.01592
G1 X188.451 Y127.339 E1.13432
G1 X188.451 Y126.805 E.01592
G1 X161.549 Y153.707 E1.13432
G1 X161.549 Y153.173 E.01592
G1 X188.451 Y126.272 E1.13432
G1 X188.451 Y125.738 E.01592
G1 X161.549 Y152.639 E1.13432
M73 P51 R7
G1 X161.549 Y152.105 E.01592
G1 X188.451 Y125.204 E1.13432
G1 X188.451 Y124.67 E.01592
G1 X161.549 Y151.571 E1.13432
G1 X161.549 Y151.038 E.01592
G1 X188.451 Y124.136 E1.13432
G1 X188.451 Y123.603 E.01592
G1 X161.549 Y150.504 E1.13432
G1 X161.549 Y149.97 E.01592
G1 X188.451 Y123.069 E1.13432
G1 X188.451 Y122.535 E.01592
G1 X161.549 Y149.436 E1.13432
G1 X161.549 Y148.902 E.01592
G1 X188.451 Y122.001 E1.13432
G1 X188.451 Y121.467 E.01592
G1 X161.549 Y148.369 E1.13432
G1 X161.549 Y147.835 E.01592
G1 X188.451 Y120.934 E1.13432
G1 X188.451 Y120.4 E.01592
G1 X161.549 Y147.301 E1.13432
G1 X161.549 Y146.767 E.01592
M73 P52 R7
G1 X188.451 Y119.866 E1.13432
G1 X188.451 Y119.332 E.01592
G1 X161.549 Y146.234 E1.13432
G1 X161.549 Y145.7 E.01592
G1 X188 Y119.249 E1.11533
G1 X187.964 Y119.177 E.00241
G1 X187.872 Y119.305 E.00472
G1 X187.499 Y119.695 E.01609
G1 X187.052 Y120.012 E.01634
G3 X186.443 Y120.272 I-1.514 J-2.707 E.01977
G1 X161.549 Y145.166 E1.04967
G1 X161.549 Y144.632 E.01592
G1 X185.796 Y120.385 E1.0224
G3 X185.269 Y120.379 I-.242 J-1.792 E.01579
G1 X161.549 Y144.098 E1.00015
G1 X161.549 Y143.565 E.01592
G1 X184.82 Y120.294 E.98123
G1 X184.434 Y120.146 E.01232
G1 X161.549 Y143.031 E.96496
G1 X161.549 Y142.497 E.01592
G1 X184.079 Y119.968 E.94997
G3 X183.766 Y119.747 I2.446 J-3.802 E.01142
G1 X161.549 Y141.963 E.93677
G1 X161.549 Y141.429 E.01592
G1 X183.496 Y119.483 E.92538
G3 X183.255 Y119.19 I.658 J-.787 E.01137
G1 X161.549 Y140.896 E.91523
G1 X161.549 Y140.362 E.01592
G1 X183.044 Y118.867 E.90635
G3 X182.879 Y118.498 I1.665 J-.966 E.01207
G1 X161.549 Y139.828 E.89939
G1 X161.549 Y139.294 E.01592
G1 X182.768 Y118.075 E.89472
G3 X182.712 Y117.597 I1.183 J-.38 E.01444
G1 X161.549 Y138.76 E.89236
G1 X161.549 Y138.227 E.01592
G1 X182.737 Y117.039 E.8934
G3 X182.978 Y116.264 I3.073 J.531 E.02426
G1 X161.549 Y137.693 E.90356
G1 X161.549 Y137.159 E.01592
G1 X186.959 Y111.749 E1.07142
G1 X187.493 Y111.749 E.01592
G1 X184.363 Y114.879 E.13198
G3 X185.129 Y114.647 I1.152 J2.422 E.02395
G1 X188.027 Y111.749 E.12219
G1 X188.451 Y111.749 E.01264
G1 X188.451 Y111.859 E.00327
G1 X185.7 Y114.61 E.11599
G3 X186.175 Y114.668 I.09 J1.232 E.01437
G1 X188.451 Y112.393 E.09595
G1 X188.451 Y112.927 E.01592
G1 X186.592 Y114.785 E.07837
G3 X186.968 Y114.944 I-.35 J1.357 E.01219
G1 X188.451 Y113.461 E.06253
G1 X188.451 Y113.994 E.01592
G1 X187.295 Y115.15 E.04872
G3 X187.582 Y115.397 I-.698 J1.098 E.01132
G1 X188.451 Y114.528 E.03664
G1 X188.451 Y115.062 E.01592
G1 X187.845 Y115.667 E.02552
G1 X188.036 Y115.941 E.00995
G1 X188.121 Y115.925 E.00258
G1 X188.62 Y115.426 E.02104
M204 S10000
G1 X188.336 Y116.224 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.441411
G1 F9034.079
M204 S8000
G1 X188.369 Y116.4 E.00562
; LINE_WIDTH: 0.412591
G1 F9738.394
G1 X188.404 Y116.593 E.00573
; LINE_WIDTH: 0.377175
G1 F10770.232
G1 X188.422 Y116.724 E.00349
; LINE_WIDTH: 0.34012
G1 F12113.087
G1 X188.441 Y116.868 E.00342
; LINE_WIDTH: 0.296357
G1 F14204.715
G1 X188.466 Y117.156 E.00579
; LINE_WIDTH: 0.265486
G1 F15000
G1 X188.472 Y117.712 E.00977
G1 X188.453 Y118.01 E.00526
; LINE_WIDTH: 0.31297
G1 F13330.866
G1 X188.437 Y118.153 E.00306
; LINE_WIDTH: 0.347202
G1 F11831.154
G1 X188.419 Y118.311 E.00383
; LINE_WIDTH: 0.387486
G1 F10447.935
G1 X188.397 Y118.442 E.00362
; LINE_WIDTH: 0.43358
G1 F9215.193
G1 X188.376 Y118.573 E.0041
G1 X188.102 Y118.712 E.00947
; WIPE_START
G1 X188.376 Y118.573 E-.5303
G1 X188.397 Y118.442 E-.2297
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X181.089 Y116.241 Z.8 F60000
G1 X167.38 Y112.112 Z.8
G1 Z.4
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42037
G1 F9537.687
M204 S8000
G1 X167.742 Y111.749 E.01529
G1 X168.276 Y111.749 E.01592
G1 X167.549 Y112.476 E.03065
G1 X167.549 Y113.01 E.01592
G1 X168.81 Y111.749 E.05316
G1 X169.344 Y111.749 E.01592
G1 X167.549 Y113.544 E.07566
G1 X167.549 Y114.078 E.01592
G1 X169.878 Y111.749 E.09817
G1 X170.411 Y111.749 E.01592
G1 X167.549 Y114.611 E.12068
G1 X167.549 Y115.145 E.01592
G1 X170.945 Y111.749 E.14319
G1 X171.479 Y111.749 E.01592
G1 X167.38 Y115.849 E.17285
; WIPE_START
G1 X168.794 Y114.434 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X161.595 Y116.969 Z.8 F60000
G1 X161.38 Y117.044 Z.8
G1 Z.4
G1 E.8 F1800
G1 F9537.687
M204 S8000
G1 X161.975 Y116.449 E.02509
G1 X162.509 Y116.449 E.01592
G1 X161.549 Y117.409 E.04045
G1 X161.549 Y117.942 E.01592
G1 X163.042 Y116.449 E.06295
G1 X163.576 Y116.449 E.01592
G1 X161.549 Y118.476 E.08546
G1 X161.549 Y119.01 E.01592
G1 X164.11 Y116.449 E.10797
G1 X164.644 Y116.449 E.01592
G1 X161.549 Y119.544 E.13048
G1 X161.549 Y120.078 E.01592
G1 X165.178 Y116.449 E.15299
G1 X165.711 Y116.449 E.01592
G1 X161.549 Y120.611 E.17549
G1 X161.549 Y121.145 E.01592
G1 X166.245 Y116.449 E.198
G1 X166.779 Y116.449 E.01592
G1 X161.549 Y121.679 E.22051
G1 X161.549 Y122.213 E.01592
G1 X172.013 Y111.749 E.4412
G1 X172.547 Y111.749 E.01592
G1 X161.549 Y122.747 E.46371
G1 X161.549 Y123.28 E.01592
G1 X173.08 Y111.749 E.48622
G1 X173.614 Y111.749 E.01592
G1 X161.549 Y123.814 E.50872
G1 X161.549 Y124.348 E.01592
G1 X174.148 Y111.749 E.53123
G1 X174.682 Y111.749 E.01592
G1 X161.549 Y124.882 E.55374
G1 X161.549 Y125.416 E.01592
G1 X175.216 Y111.749 E.57625
G1 X175.749 Y111.749 E.01592
G1 X161.549 Y125.949 E.59875
G1 X161.549 Y126.483 E.01592
G1 X176.283 Y111.749 E.62126
G1 X176.817 Y111.749 E.01592
G1 X161.549 Y127.017 E.64377
G1 X161.549 Y127.551 E.01592
G1 X177.351 Y111.749 E.66628
G1 X177.884 Y111.749 E.01592
G1 X161.549 Y128.084 E.68879
G1 X161.549 Y128.618 E.01592
G1 X178.418 Y111.749 E.7113
G1 X178.952 Y111.749 E.01592
G1 X161.549 Y129.152 E.7338
G1 X161.549 Y129.686 E.01592
G1 X179.486 Y111.749 E.75631
G1 X180.02 Y111.749 E.01592
G1 X161.549 Y130.22 E.77882
G1 X161.549 Y130.753 E.01592
G1 X180.553 Y111.749 E.80133
G1 X181.087 Y111.749 E.01592
G1 X161.549 Y131.287 E.82384
G1 X161.549 Y131.821 E.01592
G1 X181.621 Y111.749 E.84634
G1 X182.155 Y111.749 E.01592
G1 X161.549 Y132.355 E.86885
G1 X161.549 Y132.889 E.01592
M73 P53 R7
G1 X182.689 Y111.749 E.89136
G1 X183.222 Y111.749 E.01592
G1 X161.549 Y133.422 E.91387
G1 X161.549 Y133.956 E.01592
G1 X183.756 Y111.749 E.93637
G1 X184.29 Y111.749 E.01592
G1 X161.549 Y134.49 E.95888
G1 X161.549 Y135.024 E.01592
G1 X184.824 Y111.749 E.98139
G1 X185.358 Y111.749 E.01592
G1 X161.549 Y135.558 E1.0039
G1 X161.549 Y136.091 E.01592
G1 X185.891 Y111.749 E1.02641
G1 X186.425 Y111.749 E.01592
G1 X161.38 Y136.795 E1.05607
; WIPE_START
G1 X162.794 Y135.381 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X165.933 Y142.338 Z.8 F60000
G1 X187.857 Y190.92 Z.8
G1 Z.4
G1 E.8 F1800
G1 F9537.687
M204 S8000
G1 X188.451 Y190.327 E.02502
G1 X188.451 Y189.793 E.01592
G1 X187.493 Y190.751 E.04037
G1 X186.959 Y190.751 E.01592
G1 X188.451 Y189.259 E.06288
G1 X188.451 Y188.726 E.01592
G1 X186.426 Y190.751 E.08539
G1 X185.892 Y190.751 E.01592
G1 X188.451 Y188.192 E.1079
G1 X188.451 Y187.658 E.01592
G1 X185.358 Y190.751 E.13041
G1 X184.824 Y190.751 E.01592
G1 X188.451 Y187.124 E.15291
G1 X188.451 Y186.59 E.01592
G1 X184.29 Y190.751 E.17542
G1 X183.757 Y190.751 E.01592
G1 X188.451 Y186.057 E.19793
G1 X188.451 Y185.523 E.01592
G1 X183.223 Y190.751 E.22044
G1 X182.689 Y190.751 E.01592
G1 X188.451 Y184.989 E.24295
G1 X188.451 Y184.455 E.01592
G1 X182.155 Y190.751 E.26545
G1 X181.621 Y190.751 E.01592
G1 X188.451 Y183.921 E.28796
G1 X188.451 Y183.388 E.01592
G1 X181.088 Y190.751 E.31047
G1 X180.554 Y190.751 E.01592
G1 X188.451 Y182.854 E.33298
G1 X188.451 Y182.32 E.01592
G1 X180.02 Y190.751 E.35549
G1 X179.486 Y190.751 E.01592
G1 X188.451 Y181.786 E.37799
G1 X188.451 Y181.252 E.01592
G1 X178.952 Y190.751 E.4005
G1 X178.419 Y190.751 E.01592
G1 X188.451 Y180.719 E.42301
G1 X188.451 Y180.185 E.01592
G1 X177.885 Y190.751 E.44552
G1 X177.351 Y190.751 E.01592
G1 X188.451 Y179.651 E.46803
G1 X188.451 Y179.117 E.01592
G1 X176.817 Y190.751 E.49053
G1 X176.283 Y190.751 E.01592
G1 X188.451 Y178.583 E.51304
G1 X188.451 Y178.05 E.01592
G1 X175.75 Y190.751 E.53555
G1 X175.216 Y190.751 E.01592
G1 X188.451 Y177.516 E.55806
G1 X188.451 Y176.982 E.01592
G1 X174.682 Y190.751 E.58057
G1 X174.148 Y190.751 E.01592
G1 X188.451 Y176.448 E.60307
G1 X188.451 Y175.914 E.01592
G1 X173.614 Y190.751 E.62558
G1 X173.081 Y190.751 E.01592
G1 X188.451 Y175.381 E.64809
G1 X188.451 Y174.847 E.01592
G1 X172.547 Y190.751 E.6706
G1 X172.013 Y190.751 E.01592
G1 X188.451 Y174.313 E.6931
G1 X188.451 Y173.779 E.01592
G1 X171.479 Y190.751 E.71561
G1 X170.946 Y190.751 E.01592
G1 X188.451 Y173.246 E.73812
G1 X188.451 Y172.712 E.01592
G1 X170.412 Y190.751 E.76063
G1 X169.878 Y190.751 E.01592
G1 X188.451 Y172.178 E.78314
G1 X188.451 Y171.644 E.01592
G1 X169.344 Y190.751 E.80564
G1 X168.81 Y190.751 E.01592
G1 X188.451 Y171.11 E.82815
G1 X188.451 Y170.577 E.01592
G1 X168.277 Y190.751 E.85066
G1 X167.743 Y190.751 E.01592
G1 X188.451 Y170.043 E.87317
G1 X188.451 Y169.509 E.01592
G1 X167.209 Y190.751 E.89568
G1 X166.851 Y190.751 E.01068
G1 X166.851 Y191.109 E.01068
G1 X161.549 Y196.41 E.22353
G1 X161.549 Y196.944 E.01592
G1 X166.851 Y191.643 E.22353
G1 X166.851 Y192.177 E.01592
G1 X161.549 Y197.478 E.22353
G1 X161.549 Y198.012 E.01592
G1 X166.851 Y192.71 E.22353
G1 X166.851 Y193.244 E.01592
G1 X161.549 Y198.545 E.22353
G1 X161.549 Y199.079 E.01592
G1 X166.851 Y193.778 E.22353
G1 X166.851 Y194.312 E.01592
G1 X161.549 Y199.613 E.22353
G1 X161.549 Y200.147 E.01592
G1 X166.851 Y194.846 E.22353
G1 X166.851 Y195.379 E.01592
G1 X161.549 Y200.681 E.22353
G1 X161.549 Y201.214 E.01592
G1 X166.851 Y195.913 E.22353
G1 X166.851 Y196.447 E.01592
G1 X161.549 Y201.748 E.22353
G1 X161.549 Y201.837 E.00264
G1 X161.952 Y201.635 E.01342
G1 X162.033 Y201.798 E.00542
G1 X166.851 Y196.981 E.20313
G1 X166.851 Y197.515 E.01592
G1 X163.662 Y200.703 E.13446
G3 X164.296 Y200.603 I.712 J2.445 E.01919
G1 X166.851 Y198.048 E.10772
G1 X166.851 Y198.582 E.01592
G1 X164.802 Y200.63 E.08636
G3 X165.242 Y200.725 I-.477 J3.28 E.01341
G1 X166.851 Y199.116 E.06785
G1 X166.851 Y199.65 E.01592
G1 X165.623 Y200.877 E.05175
G3 X165.972 Y201.062 I-.461 J1.293 E.01182
G1 X166.851 Y200.183 E.03703
G1 X166.851 Y200.717 E.01592
G1 X166.277 Y201.291 E.02421
G3 X166.548 Y201.554 I-1.137 J1.445 E.01128
G1 X167.02 Y201.081 E.01993
M204 S10000
G1 X166.762 Y202.01 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.108878
G1 F15000
M204 S8000
G1 X166.854 Y202.13 E.00079
; LINE_WIDTH: 0.138527
G1 X166.98 Y202.312 E.00167
; WIPE_START
G1 X166.854 Y202.13 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X167.387 Y203.493 Z.8 F60000
G1 Z.4
G1 E.8 F1800
; LINE_WIDTH: 0.152652
G1 F15000
M204 S8000
G1 X167.083 Y203.496 E.00264
; LINE_WIDTH: 0.115497
G1 X166.779 Y203.5 E.00174
; WIPE_START
G1 X167.083 Y203.496 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X166.98 Y204.666 Z.8 F60000
G1 Z.4
G1 E.8 F1800
; LINE_WIDTH: 0.122323
G1 F15000
M204 S8000
G1 X166.799 Y204.93 E.00201
M204 S10000
G1 X166.708 Y205.353 F60000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F9547.299
M204 S8000
G1 X166.323 Y205.751 E.01649
G1 X165.857 Y206.076 E.01692
G1 X165.393 Y206.286 E.01518
G1 X164.779 Y206.435 E.0188
G1 X164.195 Y206.452 E.0174
G1 X163.605 Y206.351 E.01783
G1 X163.115 Y206.166 E.01559
G1 X162.59 Y205.842 E.0184
G1 X162.177 Y205.454 E.01688
G1 X161.936 Y205.122 E.0122
G1 X161.608 Y205.184 E.00994
G1 X161.608 Y208.192 E.08959
G1 X166.792 Y208.192 E.15439
G1 X166.792 Y205.396 E.08326
G1 X166.761 Y205.381 E.00101
M204 S10000
G1 X166.415 Y206.15 F60000
G1 F9547.299
M204 S8000
G3 X165.521 Y206.641 I-1.893 J-2.381 E.03052
G1 X164.863 Y206.803 E.02017
G1 X164.204 Y206.829 E.01966
G1 X163.539 Y206.722 E.02006
G1 X162.98 Y206.518 E.01772
G1 X162.39 Y206.161 E.02055
G1 X161.985 Y205.792 E.01632
G1 X161.985 Y207.815 E.06025
G1 X166.415 Y207.815 E.13193
G1 X166.415 Y206.21 E.04781
M204 S10000
G1 X166.011 Y206.866 F60000
; LINE_WIDTH: 0.45206
G1 F8798.944
M204 S8000
G1 X165.504 Y207.049 E.01743
; LINE_WIDTH: 0.415098
G1 F9672.804
G1 X165.223 Y207.096 E.00838
; LINE_WIDTH: 0.382913
G1 F10588.469
G1 X164.942 Y207.144 E.00766
; LINE_WIDTH: 0.366633
G1 F11120.987
G1 X164.212 Y207.17 E.01868
G1 X163.474 Y207.086 E.01897
; LINE_WIDTH: 0.424954
G1 F9423.262
G1 X163.258 Y207.03 E.00673
; LINE_WIDTH: 0.46488
G1 F8531.614
G1 X163.042 Y206.975 E.00743
; LINE_WIDTH: 0.504807
G1 F7794.119
G1 X162.826 Y206.919 E.00814
; LINE_WIDTH: 0.535983
G1 F7301.302
G1 X162.422 Y206.696 E.018
G1 X162.422 Y207.378 E.02656
; LINE_WIDTH: 0.521409
G1 F7523.695
G1 X162.691 Y207.396 E.01018
; LINE_WIDTH: 0.486585
G1 F8114.23
G1 X162.959 Y207.413 E.00944
; LINE_WIDTH: 0.451762
G1 F8805.364
G1 X163.228 Y207.43 E.0087
; LINE_WIDTH: 0.414598
G1 F9685.816
G1 X163.616 Y207.45 E.01141
; LINE_WIDTH: 0.361386
G1 F11304.215
G2 X164.761 Y207.471 I.782 J-11.531 E.02882
; LINE_WIDTH: 0.372818
G1 F10912.48
G1 X165.154 Y207.451 E.01025
; LINE_WIDTH: 0.411733
G1 F9761.057
G1 X165.547 Y207.432 E.01146
; LINE_WIDTH: 0.462726
G1 F8575.398
G1 X166.011 Y207.411 E.0154
G1 X166.011 Y206.926 E.0161
; WIPE_START
G1 X166.011 Y207.411 E-.3884
G1 X165.547 Y207.432 E-.3716
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X161.664 Y204.775 Z.8 F60000
G1 Z.4
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.432347
G1 F9244.352
M204 S8000
M73 P54 R7
G1 X161.603 Y204.455 E.01001
; LINE_WIDTH: 0.387806
G1 F10438.24
G1 X161.581 Y204.299 E.00428
; LINE_WIDTH: 0.34677
G1 F11847.969
G1 X161.562 Y204.161 E.00334
; LINE_WIDTH: 0.312858
G1 F13336.404
G1 X161.548 Y204.002 E.00341
; LINE_WIDTH: 0.286276
G1 F14793.163
G1 X161.535 Y203.858 E.00279
; LINE_WIDTH: 0.265142
G1 F15000
G1 X161.524 Y203.553 E.00535
G1 X161.545 Y203.003 E.00967
; LINE_WIDTH: 0.311364
G1 F13410.623
G1 X161.563 Y202.848 E.00331
; LINE_WIDTH: 0.345191
G1 F11909.856
G1 X161.579 Y202.706 E.00341
; LINE_WIDTH: 0.383417
G1 F10572.793
G1 X161.601 Y202.566 E.0038
; LINE_WIDTH: 0.426354
G1 F9388.849
G1 X161.622 Y202.442 E.00381
; LINE_WIDTH: 0.452859
G1 F8781.797
G1 X161.625 Y202.425 E.00058
G1 X161.904 Y202.285 E.01011
; CHANGE_LAYER
; Z_HEIGHT: 0.6
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F8781.797
G1 X161.625 Y202.425 E-.71875
G1 X161.622 Y202.442 E-.04125
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 3/10
; update layer progress
M73 L3
M991 S0 P2 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z.8 I1.178 J.306 P1  F60000
G1 X184.285 Y115.305 Z.8
G1 Z.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X184.381 Y115.239 E.00377
G3 X185.329 Y114.946 I1.216 J2.26 E.0321
G1 X185.585 Y114.932 E.00825
G3 X183.972 Y115.512 I.012 J2.566 E.46229
G1 X184.235 Y115.338 E.01014
; COOLING_NODE: 0
M204 S10000
G1 X184.51 Y115.642 F60000
G1 F8843.478
M204 S8000
G1 X184.575 Y115.597 E.00252
G3 X185.372 Y115.352 I1.023 J1.901 E.027
G1 X185.588 Y115.34 E.00695
G3 X184.231 Y115.828 I.01 J2.159 E.38891
G1 X184.461 Y115.675 E.00887
; COOLING_NODE: 0
M204 S10000
G1 X184.736 Y115.979 F60000
G1 F8843.478
M204 S8000
G1 X184.769 Y115.956 E.00128
G3 X185.416 Y115.757 I.83 J1.543 E.0219
G1 X185.591 Y115.747 E.00565
G3 X184.49 Y116.143 I.008 J1.752 E.31554
G1 X184.686 Y116.012 E.0076
; COOLING_NODE: 0
M204 S250
G1 X184.954 Y116.303 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X184.956 Y116.302 E.00008
G3 X185.457 Y116.147 I.644 J1.197 E.01573
G1 X185.594 Y116.14 E.00407
G3 X184.739 Y116.447 I.006 J1.359 E.22682
G1 X184.904 Y116.337 E.0059
; COOLING_NODE: 0
; WIPE_START
M204 S8000
G1 X184.956 Y116.302 E-.02381
G1 X185.201 Y116.2 E-.10102
G1 X185.457 Y116.147 E-.0993
G1 X185.594 Y116.14 E-.05194
G1 X185.859 Y116.165 E-.10128
G1 X186.11 Y116.239 E-.09949
G1 X186.238 Y116.299 E-.05379
G1 X186.457 Y116.444 E-.09961
G1 X186.657 Y116.643 E-.10732
G1 X186.69 Y116.692 E-.02244
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X184.754 Y124.075 Z1 F60000
G1 X167.184 Y191.084 Z1
G1 Z.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X167.184 Y203.247 E.39111
G1 X166.957 Y203.263 E.00732
G2 X166.958 Y203.74 I-2.555 J.244 E.50324
G1 X167.184 Y203.757 E.00729
G1 X167.184 Y208.584 E.1552
G1 X161.216 Y208.584 E.1919
G1 X161.216 Y116.116 E2.97342
G1 X167.216 Y116.116 E.19294
G1 X167.216 Y111.416 E.15113
G1 X188.784 Y111.416 E.69354
G1 X188.784 Y191.084 E2.56182
G1 X167.244 Y191.084 E.69265
; COOLING_NODE: 0
; WIPE_START
G1 X167.234 Y193.084 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X165.512 Y200.519 Z1 F60000
G1 X165.278 Y201.533 Z1
G1 Z.6
G1 E.8 F1800
G1 F8843.478
M204 S8000
G1 X165.597 Y201.704 E.01166
G3 X164.172 Y201.352 I-1.2 J1.795 E.38808
G1 X164.388 Y201.34 E.00695
G3 X165.209 Y201.498 I.01 J2.159 E.02704
G1 X165.224 Y201.506 E.00056
; COOLING_NODE: 0
M204 S10000
G1 X165.088 Y201.891 F60000
G1 F8843.478
M204 S8000
G1 X165.372 Y202.043 E.01035
G3 X164.216 Y201.757 I-.973 J1.456 E.31485
G1 X164.391 Y201.747 E.00565
G3 X165.034 Y201.866 I.008 J1.752 E.02114
; COOLING_NODE: 1
M204 S250
G1 X164.909 Y202.239 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G3 X164.257 Y202.147 I-.51 J1.26 E.23462
G1 X164.394 Y202.14 E.00407
G3 X164.853 Y202.218 I.006 J1.359 E.01396
; COOLING_NODE: 1
; WIPE_START
M204 S8000
G1 X165.155 Y202.369 E-.12833
G1 X165.362 Y202.538 E-.10151
G1 X165.457 Y202.644 E-.05392
G1 X165.611 Y202.881 E-.10775
G1 X165.706 Y203.119 E-.09715
G1 X165.754 Y203.375 E-.0991
G1 X165.753 Y203.641 E-.10115
G1 X165.717 Y203.825 E-.07109
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X166.863 Y196.279 Z1 F60000
G1 X167.591 Y191.491 Z1
G1 Z.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X167.591 Y208.991 E.56274
G1 X160.809 Y208.991 E.21808
G1 X160.809 Y115.709 E2.9996
G1 X166.809 Y115.709 E.19294
G1 X166.809 Y111.009 E.15113
G1 X189.191 Y111.009 E.71972
G1 X189.191 Y191.491 E2.588
G1 X167.651 Y191.491 E.69265
; COOLING_NODE: 1
M204 S10000
G1 X167.998 Y191.898 F60000
G1 F8843.478
M204 S8000
G1 X167.998 Y209.398 E.56274
G1 X160.402 Y209.398 E.24426
G1 X160.402 Y115.302 E3.02578
G1 X166.402 Y115.302 E.19294
G1 X166.402 Y110.602 E.15113
G1 X189.598 Y110.602 E.7459
G1 X189.598 Y191.898 E2.61418
G1 X168.058 Y191.898 E.69265
; COOLING_NODE: 2
M204 S250
G1 X168.39 Y192.29 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X168.39 Y209.79 E.52127
G1 X160.01 Y209.79 E.24961
G1 X160.01 Y114.91 E2.82615
G1 X166.01 Y114.91 E.17872
G1 X166.01 Y110.21 E.14
G1 X189.99 Y110.21 E.71428
G1 X189.99 Y192.29 E2.44488
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

G1 X168.45 Y192.29 E.6416
; WIPE_START
M204 S8000
G1 X168.443 Y194.29 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X166.851 Y201.755 Z1 F60000
G1 X166.788 Y202.051 Z1
G1 Z.6
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.125037
G1 F15000
M204 S8000
G1 X166.98 Y202.327 E.00218
; WIPE_START
G1 X166.788 Y202.051 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X167.387 Y203.502 Z1 F60000
G1 Z.6
G1 E.8 F1800
; LINE_WIDTH: 0.14842
G1 F15000
M204 S8000
G1 X167.106 Y203.502 E.00235
; LINE_WIDTH: 0.114088
G1 X166.825 Y203.501 E.00158
; WIPE_START
M73 P55 R7
G1 X167.106 Y203.502 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X166.98 Y204.673 Z1 F60000
G1 Z.6
G1 E.8 F1800
; LINE_WIDTH: 0.125095
G1 F15000
M204 S8000
G1 X166.788 Y204.949 E.00218
M204 S10000
G1 X166.685 Y205.381 F60000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F9547.299
M204 S8000
G3 X165.542 Y206.23 I-2.392 J-2.027 E.0428
G1 X164.98 Y206.403 E.01751
G1 X164.414 Y206.46 E.01692
G1 X163.853 Y206.409 E.01679
G1 X163.277 Y206.238 E.0179
G1 X162.762 Y205.965 E.01737
G1 X162.321 Y205.607 E.01691
G1 X161.943 Y205.123 E.01828
G1 X161.608 Y205.181 E.01011
G1 X161.608 Y208.192 E.08967
G1 X166.792 Y208.192 E.15439
G1 X166.792 Y205.43 E.08227
G1 X166.74 Y205.406 E.0017
M204 S10000
G1 X166.415 Y206.156 F60000
G1 F9547.299
M204 S8000
G1 X165.719 Y206.563 E.02399
G1 X165.088 Y206.764 E.01974
G1 X164.45 Y206.835 E.01911
G1 X163.816 Y206.784 E.01894
G1 X163.168 Y206.599 E.0201
G1 X162.583 Y206.297 E.0196
G1 X161.989 Y205.808 E.0229
G2 X161.985 Y207.815 I181.781 J1.337 E.05976
G1 X166.415 Y207.815 E.13193
G1 X166.415 Y206.216 E.04761
M204 S10000
G1 X166.011 Y206.864 F60000
; LINE_WIDTH: 0.472215
G1 F8385.841
M204 S8000
G1 X165.731 Y206.992 E.01045
; LINE_WIDTH: 0.451725
G1 F8806.154
G1 X165.461 Y207.051 E.00891
; LINE_WIDTH: 0.411355
G1 F9771.058
G1 X165.192 Y207.111 E.00803
; LINE_WIDTH: 0.363126
G1 F11242.766
G1 X164.483 Y207.174 E.01801
G1 X163.782 Y207.135 E.01774
; LINE_WIDTH: 0.388414
G1 F10419.883
G1 X163.538 Y207.085 E.0068
; LINE_WIDTH: 0.42336
G1 F9462.727
G1 X163.294 Y207.036 E.00748
; LINE_WIDTH: 0.458307
G1 F8666.623
G1 X163.05 Y206.986 E.00817
; LINE_WIDTH: 0.492428
G1 F8008.765
G1 X162.921 Y206.946 E.0048
; LINE_WIDTH: 0.540528
G1 F7234.614
G1 X162.792 Y206.907 E.00531
G1 X162.424 Y206.709 E.01643
G1 X162.424 Y207.376 E.02625
; LINE_WIDTH: 0.525723
G1 F7456.465
G1 X162.705 Y207.393 E.01077
; LINE_WIDTH: 0.492428
G1 F8008.765
G1 X162.987 Y207.41 E.01002
; LINE_WIDTH: 0.454865
G1 F8739.03
G1 X163.269 Y207.431 E.0092
; LINE_WIDTH: 0.413035
G1 F9726.706
G1 X163.551 Y207.452 E.00827
; LINE_WIDTH: 0.363278
G1 F11237.448
G2 X165.028 Y207.462 I.85 J-15.156 E.03739
; LINE_WIDTH: 0.387319
G1 F10453.013
G1 X165.283 Y207.445 E.00695
; LINE_WIDTH: 0.421155
G1 F9517.893
G1 X165.538 Y207.429 E.00763
; LINE_WIDTH: 0.467797
G1 F8473.052
G3 X166.011 Y207.411 I.369 J3.63 E.01592
G1 X166.011 Y206.924 E.01636
; WIPE_START
G1 X166.011 Y207.411 E-.38532
G1 X165.538 Y207.429 E-.37468
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X161.66 Y204.774 Z1 F60000
G1 Z.6
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.435238
G1 F9176.243
M204 S8000
G1 X161.624 Y204.569 E.00648
; LINE_WIDTH: 0.399113
G1 F10106.9
G1 X161.589 Y204.363 E.00588
; LINE_WIDTH: 0.360758
G1 F11326.547
G1 X161.569 Y204.204 E.00402
; LINE_WIDTH: 0.323745
G1 F12819.378
G1 X161.551 Y204.062 E.00318
; LINE_WIDTH: 0.285159
G1 F14861.367
G1 X161.531 Y203.773 E.00554
; LINE_WIDTH: 0.258283
G1 F15000
G1 X161.531 Y203.212 E.00954
; LINE_WIDTH: 0.284888
G1 F14878.018
G1 X161.55 Y202.953 E.00496
; LINE_WIDTH: 0.319726
G1 F13005.525
G1 X161.566 Y202.817 E.00299
; LINE_WIDTH: 0.350521
G1 F11703.471
G1 X161.581 Y202.692 E.00305
; LINE_WIDTH: 0.387969
G1 F10433.31
G1 X161.604 Y202.552 E.00387
; LINE_WIDTH: 0.432155
G1 F9248.916
G1 X161.625 Y202.427 E.00388
; LINE_WIDTH: 0.440391
G1 F9057.273
G1 X161.641 Y202.419 E.00058
; LINE_WIDTH: 0.415228
G1 F9669.432
G1 X161.657 Y202.41 E.00054
; LINE_WIDTH: 0.387894
G1 F10435.574
G1 X161.899 Y202.289 E.00737
; WIPE_START
G1 X161.657 Y202.41 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X161.38 Y201.373 Z1 F60000
G1 Z.6
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42006
G1 F9545.527
M204 S8000
G1 X161.77 Y201.764 E.01645
G1 X161.96 Y201.668 E.00634
G1 X162.038 Y201.822 E.00512
G3 X162.178 Y201.638 I.945 J.574 E.0069
G1 X161.549 Y201.009 E.02647
G1 X161.549 Y200.476 E.01589
G1 X162.443 Y201.37 E.03764
G1 X162.735 Y201.128 E.01129
G1 X161.549 Y199.943 E.04994
G1 X161.549 Y199.409 E.01589
G1 X163.073 Y200.933 E.06419
G3 X163.445 Y200.772 I.604 J.886 E.01216
G1 X161.549 Y198.876 E.07987
G1 X161.549 Y198.343 E.01589
G1 X163.859 Y200.652 E.09729
G3 X164.341 Y200.601 I.488 J2.315 E.01448
G1 X161.549 Y197.809 E.11762
G1 X161.549 Y197.276 E.01589
G1 X164.92 Y200.647 E.14202
G1 X165.48 Y200.806 E.01733
G1 X165.729 Y200.922 E.0082
G1 X161.549 Y196.743 E.1761
G1 X161.549 Y196.209 E.01589
G1 X166.851 Y201.511 E.22335
G1 X166.851 Y200.977 E.01589
G1 X161.549 Y195.676 E.22335
G1 X161.549 Y195.143 E.01589
G1 X166.851 Y200.444 E.22335
G1 X166.851 Y199.91 E.01589
G1 X161.549 Y194.609 E.22335
G1 X161.549 Y194.076 E.01589
G1 X166.851 Y199.377 E.22335
G1 X166.851 Y198.844 E.01589
G1 X161.549 Y193.543 E.22335
G1 X161.549 Y193.009 E.01589
G1 X166.851 Y198.31 E.22335
G1 X166.851 Y197.777 E.01589
G1 X161.549 Y192.476 E.22335
G1 X161.549 Y191.942 E.01589
G1 X166.851 Y197.244 E.22335
G1 X166.851 Y196.71 E.01589
G1 X161.549 Y191.409 E.22335
G1 X161.549 Y190.876 E.01589
G1 X166.851 Y196.177 E.22335
G1 X166.851 Y195.644 E.01589
G1 X161.549 Y190.342 E.22335
G1 X161.549 Y189.809 E.01589
G1 X166.851 Y195.11 E.22335
G1 X166.851 Y194.577 E.01589
G1 X161.549 Y189.276 E.22335
G1 X161.549 Y188.742 E.01589
G1 X166.851 Y194.044 E.22335
G1 X166.851 Y193.51 E.01589
G1 X161.549 Y188.209 E.22335
G1 X161.549 Y187.676 E.01589
G1 X166.851 Y192.977 E.22335
G1 X166.851 Y192.443 E.01589
G1 X161.549 Y187.142 E.22335
G1 X161.549 Y186.609 E.01589
G1 X166.851 Y191.91 E.22335
G1 X166.851 Y191.377 E.01589
G1 X161.549 Y186.076 E.22335
G1 X161.549 Y185.542 E.01589
G1 X166.851 Y190.843 E.22335
G1 X166.851 Y190.751 E.00276
G1 X167.291 Y190.751 E.01313
G1 X161.549 Y185.009 E.24191
G1 X161.549 Y184.475 E.01589
G1 X167.825 Y190.751 E.26438
G1 X168.358 Y190.751 E.01589
G1 X161.549 Y183.942 E.28685
G1 X161.549 Y183.409 E.01589
G1 X168.891 Y190.751 E.30932
G1 X169.425 Y190.751 E.01589
G1 X161.549 Y182.875 E.3318
G1 X161.549 Y182.342 E.01589
G1 X169.958 Y190.751 E.35427
G1 X170.491 Y190.751 E.01589
G1 X161.549 Y181.809 E.37674
G1 X161.549 Y181.275 E.01589
G1 X171.025 Y190.751 E.39921
G1 X171.558 Y190.751 E.01589
G1 X161.549 Y180.742 E.42168
G1 X161.549 Y180.209 E.01589
G1 X172.091 Y190.751 E.44415
G1 X172.625 Y190.751 E.01589
G1 X161.549 Y179.675 E.46662
G1 X161.549 Y179.142 E.01589
G1 X173.158 Y190.751 E.48909
G1 X173.691 Y190.751 E.01589
G1 X161.549 Y178.609 E.51156
G1 X161.549 Y178.075 E.01589
G1 X174.225 Y190.751 E.53403
G1 X174.758 Y190.751 E.01589
G1 X161.549 Y177.542 E.55651
G1 X161.549 Y177.008 E.01589
G1 X175.292 Y190.751 E.57898
G1 X175.825 Y190.751 E.01589
G1 X161.549 Y176.475 E.60145
G1 X161.549 Y175.942 E.01589
G1 X176.358 Y190.751 E.62392
G1 X176.892 Y190.751 E.01589
G1 X161.549 Y175.408 E.64639
G1 X161.549 Y174.875 E.01589
G1 X177.425 Y190.751 E.66886
G1 X177.958 Y190.751 E.01589
G1 X161.549 Y174.342 E.69133
G1 X161.549 Y173.808 E.01589
G1 X178.492 Y190.751 E.7138
G1 X179.025 Y190.751 E.01589
G1 X161.549 Y173.275 E.73627
G1 X161.549 Y172.742 E.01589
G1 X179.558 Y190.751 E.75874
G1 X180.092 Y190.751 E.01589
G1 X161.549 Y172.208 E.78122
G1 X161.549 Y171.675 E.01589
G1 X180.625 Y190.751 E.80369
G1 X181.158 Y190.751 E.01589
G1 X161.549 Y171.142 E.82616
G1 X161.549 Y170.608 E.01589
G1 X181.692 Y190.751 E.84863
G1 X182.225 Y190.751 E.01589
G1 X161.549 Y170.075 E.8711
G1 X161.549 Y169.541 E.01589
G1 X182.759 Y190.751 E.89357
G1 X183.292 Y190.751 E.01589
G1 X161.549 Y169.008 E.91604
G1 X161.549 Y168.475 E.01589
G1 X183.825 Y190.751 E.93851
G1 X184.359 Y190.751 E.01589
G1 X161.549 Y167.941 E.96098
G1 X161.549 Y167.408 E.01589
G1 X184.892 Y190.751 E.98346
G1 X185.425 Y190.751 E.01589
G1 X161.549 Y166.875 E1.00593
G1 X161.549 Y166.341 E.01589
G1 X185.959 Y190.751 E1.0284
G1 X186.492 Y190.751 E.01589
G1 X161.549 Y165.808 E1.05087
G1 X161.549 Y165.275 E.01589
G1 X187.025 Y190.751 E1.07334
G1 X187.559 Y190.751 E.01589
G1 X161.549 Y164.741 E1.09581
G1 X161.549 Y164.208 E.01589
G1 X188.092 Y190.751 E1.11828
G1 X188.451 Y190.751 E.01068
M73 P56 R7
G1 X188.451 Y190.576 E.00521
G1 X161.549 Y163.675 E1.13339
G1 X161.549 Y163.141 E.01589
G1 X188.451 Y190.042 E1.13339
G1 X188.451 Y189.509 E.01589
G1 X161.549 Y162.608 E1.13339
G1 X161.549 Y162.074 E.01589
G1 X188.451 Y188.976 E1.13339
G1 X188.451 Y188.442 E.01589
G1 X161.549 Y161.541 E1.13339
G1 X161.549 Y161.008 E.01589
G1 X188.451 Y187.909 E1.13339
G1 X188.451 Y187.376 E.01589
G1 X161.549 Y160.474 E1.13339
G1 X161.549 Y159.941 E.01589
G1 X188.451 Y186.842 E1.13339
G1 X188.451 Y186.309 E.01589
G1 X161.549 Y159.408 E1.13339
G1 X161.549 Y158.874 E.01589
G1 X188.451 Y185.776 E1.13339
G1 X188.451 Y185.242 E.01589
G1 X161.549 Y158.341 E1.13339
G1 X161.549 Y157.808 E.01589
G1 X188.451 Y184.709 E1.13339
G1 X188.451 Y184.176 E.01589
G1 X161.549 Y157.274 E1.13339
G1 X161.549 Y156.741 E.01589
G1 X188.451 Y183.642 E1.13339
G1 X188.451 Y183.109 E.01589
G1 X161.549 Y156.208 E1.13339
G1 X161.549 Y155.674 E.01589
G1 X188.451 Y182.575 E1.13339
G1 X188.451 Y182.042 E.01589
G1 X161.549 Y155.141 E1.13339
G1 X161.549 Y154.607 E.01589
G1 X188.451 Y181.509 E1.13339
G1 X188.451 Y180.975 E.01589
G1 X161.549 Y154.074 E1.13339
G1 X161.549 Y153.541 E.01589
G1 X188.451 Y180.442 E1.13339
G1 X188.451 Y179.909 E.01589
G1 X161.549 Y153.007 E1.13339
G1 X161.549 Y152.474 E.01589
G1 X188.451 Y179.375 E1.13339
G1 X188.451 Y178.842 E.01589
G1 X161.549 Y151.941 E1.13339
G1 X161.549 Y151.407 E.01589
G1 X188.451 Y178.309 E1.13339
G1 X188.451 Y177.775 E.01589
G1 X161.549 Y150.874 E1.13339
G1 X161.549 Y150.341 E.01589
G1 X188.451 Y177.242 E1.13339
G1 X188.451 Y176.709 E.01589
G1 X161.549 Y149.807 E1.13339
G1 X161.549 Y149.274 E.01589
G1 X188.451 Y176.175 E1.13339
G1 X188.451 Y175.642 E.01589
G1 X161.549 Y148.741 E1.13339
G1 X161.549 Y148.207 E.01589
G1 X188.451 Y175.108 E1.13339
G1 X188.451 Y174.575 E.01589
G1 X161.549 Y147.674 E1.13339
G1 X161.549 Y147.14 E.01589
G1 X188.451 Y174.042 E1.13339
G1 X188.451 Y173.508 E.01589
G1 X161.549 Y146.607 E1.13339
G1 X161.549 Y146.074 E.01589
G1 X188.451 Y172.975 E1.13339
G1 X188.451 Y172.442 E.01589
G1 X161.549 Y145.54 E1.13339
G1 X161.549 Y145.007 E.01589
G1 X188.451 Y171.908 E1.13339
G1 X188.451 Y171.375 E.01589
G1 X161.549 Y144.474 E1.13339
G1 X161.549 Y143.94 E.01589
M73 P57 R7
G1 X188.451 Y170.842 E1.13339
G1 X188.451 Y170.308 E.01589
G1 X161.549 Y143.407 E1.13339
G1 X161.549 Y142.874 E.01589
G1 X188.451 Y169.775 E1.13339
G1 X188.451 Y169.242 E.01589
G1 X161.549 Y142.34 E1.13339
G1 X161.549 Y141.807 E.01589
G1 X188.451 Y168.708 E1.13339
G1 X188.451 Y168.175 E.01589
G1 X161.549 Y141.274 E1.13339
G1 X161.549 Y140.74 E.01589
G1 X188.451 Y167.641 E1.13339
G1 X188.451 Y167.108 E.01589
G1 X161.549 Y140.207 E1.13339
G1 X161.549 Y139.673 E.01589
G1 X188.451 Y166.575 E1.13339
G1 X188.451 Y166.041 E.01589
G1 X161.549 Y139.14 E1.13339
G1 X161.549 Y138.607 E.01589
G1 X188.451 Y165.508 E1.13339
G1 X188.451 Y164.975 E.01589
G1 X161.549 Y138.073 E1.13339
G1 X161.549 Y137.54 E.01589
G1 X188.451 Y164.441 E1.13339
G1 X188.451 Y163.908 E.01589
G1 X161.549 Y137.007 E1.13339
G1 X161.549 Y136.473 E.01589
G1 X188.451 Y163.375 E1.13339
G1 X188.451 Y162.841 E.01589
G1 X161.549 Y135.94 E1.13339
G1 X161.549 Y135.407 E.01589
G1 X188.451 Y162.308 E1.13339
G1 X188.451 Y161.775 E.01589
G1 X161.549 Y134.873 E1.13339
G1 X161.549 Y134.34 E.01589
G1 X188.451 Y161.241 E1.13339
G1 X188.451 Y160.708 E.01589
G1 X161.549 Y133.807 E1.13339
G1 X161.549 Y133.273 E.01589
G1 X188.451 Y160.174 E1.13339
G1 X188.451 Y159.641 E.01589
G1 X161.549 Y132.74 E1.13339
G1 X161.549 Y132.207 E.01589
G1 X188.451 Y159.108 E1.13339
G1 X188.451 Y158.574 E.01589
G1 X161.549 Y131.673 E1.13339
G1 X161.549 Y131.14 E.01589
G1 X188.451 Y158.041 E1.13339
G1 X188.451 Y157.508 E.01589
G1 X161.549 Y130.606 E1.13339
G1 X161.549 Y130.073 E.01589
G1 X188.451 Y156.974 E1.13339
G1 X188.451 Y156.441 E.01589
G1 X161.549 Y129.54 E1.13339
G1 X161.549 Y129.006 E.01589
M73 P57 R6
G1 X188.451 Y155.908 E1.13339
G1 X188.451 Y155.374 E.01589
G1 X161.549 Y128.473 E1.13339
G1 X161.549 Y127.94 E.01589
G1 X188.451 Y154.841 E1.13339
G1 X188.451 Y154.308 E.01589
G1 X161.549 Y127.406 E1.13339
G1 X161.549 Y126.873 E.01589
G1 X188.451 Y153.774 E1.13339
G1 X188.451 Y153.241 E.01589
G1 X161.549 Y126.34 E1.13339
G1 X161.549 Y125.806 E.01589
G1 X188.451 Y152.708 E1.13339
G1 X188.451 Y152.174 E.01589
G1 X161.549 Y125.273 E1.13339
G1 X161.549 Y124.74 E.01589
G1 X188.451 Y151.641 E1.13339
G1 X188.451 Y151.107 E.01589
M73 P58 R6
G1 X161.549 Y124.206 E1.13339
G1 X161.549 Y123.673 E.01589
G1 X188.451 Y150.574 E1.13339
G1 X188.451 Y150.041 E.01589
G1 X161.549 Y123.139 E1.13339
G1 X161.549 Y122.606 E.01589
G1 X188.451 Y149.507 E1.13339
G1 X188.451 Y148.974 E.01589
G1 X161.549 Y122.073 E1.13339
G1 X161.549 Y121.539 E.01589
G1 X188.451 Y148.441 E1.13339
G1 X188.451 Y147.907 E.01589
G1 X161.549 Y121.006 E1.13339
G1 X161.549 Y120.473 E.01589
G1 X188.451 Y147.374 E1.13339
G1 X188.451 Y146.841 E.01589
G1 X161.549 Y119.939 E1.13339
G1 X161.549 Y119.406 E.01589
G1 X188.451 Y146.307 E1.13339
G1 X188.451 Y145.774 E.01589
G1 X161.549 Y118.873 E1.13339
G1 X161.549 Y118.339 E.01589
G1 X188.451 Y145.241 E1.13339
G1 X188.451 Y144.707 E.01589
G1 X161.549 Y117.806 E1.13339
G1 X161.549 Y117.273 E.01589
G1 X188.451 Y144.174 E1.13339
G1 X188.451 Y143.64 E.01589
G1 X161.549 Y116.739 E1.13339
G1 X161.549 Y116.449 E.00863
G1 X161.793 Y116.449 E.00726
G1 X188.451 Y143.107 E1.12313
G1 X188.451 Y142.574 E.01589
G1 X162.326 Y116.449 E1.10066
G1 X162.86 Y116.449 E.01589
G1 X188.451 Y142.04 E1.07818
G1 X188.451 Y141.507 E.01589
G1 X163.393 Y116.449 E1.05571
G1 X163.926 Y116.449 E.01589
G1 X188.451 Y140.974 E1.03324
G1 X188.451 Y140.44 E.01589
G1 X164.46 Y116.449 E1.01077
G1 X164.993 Y116.449 E.01589
G1 X188.451 Y139.907 E.9883
G1 X188.451 Y139.374 E.01589
G1 X165.526 Y116.449 E.96583
G1 X166.06 Y116.449 E.01589
G1 X188.451 Y138.84 E.94336
G1 X188.451 Y138.307 E.01589
G1 X166.593 Y116.449 E.92089
G1 X167.126 Y116.449 E.01589
G1 X188.451 Y137.774 E.89842
G1 X188.451 Y137.24 E.01589
G1 X167.549 Y116.339 E.8806
G1 X167.549 Y115.806 E.01589
G1 X188.451 Y136.707 E.8806
G1 X188.451 Y136.173 E.01589
G1 X167.549 Y115.272 E.8806
G1 X167.549 Y114.739 E.01589
G1 X188.451 Y135.64 E.8806
G1 X188.451 Y135.107 E.01589
G1 X167.549 Y114.205 E.8806
G1 X167.549 Y113.672 E.01589
G1 X188.451 Y134.573 E.8806
G1 X188.451 Y134.04 E.01589
G1 X167.549 Y113.139 E.8806
G1 X167.549 Y112.605 E.01589
G1 X188.451 Y133.507 E.8806
G1 X188.451 Y132.973 E.01589
G1 X167.549 Y112.072 E.8806
G1 X167.549 Y111.749 E.00961
G1 X167.76 Y111.749 E.00628
G1 X188.451 Y132.44 E.87172
G1 X188.451 Y131.907 E.01589
G1 X168.293 Y111.749 E.84925
G1 X168.827 Y111.749 E.01589
G1 X188.451 Y131.373 E.82678
G1 X188.451 Y130.84 E.01589
G1 X169.36 Y111.749 E.80431
G1 X169.893 Y111.749 E.01589
G1 X188.451 Y130.307 E.78184
G1 X188.451 Y129.773 E.01589
M73 P59 R6
G1 X170.427 Y111.749 E.75937
G1 X170.96 Y111.749 E.01589
G1 X188.451 Y129.24 E.7369
G1 X188.451 Y128.706 E.01589
G1 X171.494 Y111.749 E.71443
G1 X172.027 Y111.749 E.01589
G1 X188.451 Y128.173 E.69195
G1 X188.451 Y127.64 E.01589
G1 X172.56 Y111.749 E.66948
G1 X173.094 Y111.749 E.01589
G1 X188.451 Y127.106 E.64701
G1 X188.451 Y126.573 E.01589
G1 X173.627 Y111.749 E.62454
G1 X174.16 Y111.749 E.01589
G1 X188.451 Y126.04 E.60207
G1 X188.451 Y125.506 E.01589
G1 X174.694 Y111.749 E.5796
G1 X175.227 Y111.749 E.01589
G1 X188.62 Y125.143 E.56428
; WIPE_START
G1 X187.206 Y123.728 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X188.339 Y116.225 Z1 F60000
G1 Z.6
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.43649
G1 F9147.048
M204 S8000
G1 X188.374 Y116.427 E.0064
; LINE_WIDTH: 0.400909
G1 F10056.181
G1 X188.41 Y116.63 E.00582
; LINE_WIDTH: 0.363061
G1 F11245.065
G1 X188.43 Y116.785 E.00396
; LINE_WIDTH: 0.32673
G1 F12684.573
G1 X188.447 Y116.923 E.00311
; LINE_WIDTH: 0.288289
G1 F14671.778
G1 X188.468 Y117.198 E.00534
; LINE_WIDTH: 0.258934
G1 F15000
G1 X188.468 Y117.796 E.01021
; LINE_WIDTH: 0.289666
G1 F14589.931
G1 X188.445 Y118.096 E.00587
; LINE_WIDTH: 0.332443
G1 F12434.247
G1 X188.426 Y118.248 E.0035
; LINE_WIDTH: 0.370302
G1 F10996.357
G1 X188.408 Y118.386 E.0036
; LINE_WIDTH: 0.407185
G1 F9882.938
G1 X188.372 Y118.589 E.00592
; LINE_WIDTH: 0.438965
G1 F9089.889
G1 X188.338 Y118.775 E.00592
M204 S10000
G1 X187.845 Y119.034 F60000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42006
G1 F9545.527
M204 S8000
G1 X188.451 Y119.639 E.0255
G1 X188.451 Y120.173 E.01589
G1 X187.732 Y119.454 E.03027
G1 X187.465 Y119.72 E.01124
G1 X188.451 Y120.706 E.04154
G1 X188.451 Y121.239 E.01589
G1 X187.157 Y119.945 E.05452
G3 X186.805 Y120.128 I-.794 J-1.101 E.01183
G1 X188.451 Y121.773 E.06932
G1 X188.451 Y122.306 E.01589
G1 X186.425 Y120.281 E.08534
G1 X185.982 Y120.371 E.01348
G1 X188.451 Y122.84 E.10402
G1 X188.451 Y123.373 E.01589
G1 X185.473 Y120.395 E.12546
G3 X184.842 Y120.297 I.126 J-2.901 E.01906
G1 X188.451 Y123.906 E.15204
G1 X188.451 Y124.44 E.01589
G1 X175.76 Y111.749 E.53466
G1 X176.294 Y111.749 E.01589
G1 X182.803 Y118.258 E.27422
G3 X182.705 Y117.627 I2.86 J-.767 E.01907
G1 X176.827 Y111.749 E.24763
G1 X177.36 Y111.749 E.01589
G1 X182.73 Y117.119 E.22621
G1 X182.819 Y116.674 E.0135
G1 X177.894 Y111.749 E.2075
G1 X178.427 Y111.749 E.01589
G1 X182.97 Y116.292 E.19141
G3 X183.153 Y115.942 I1.336 J.475 E.01181
G1 X178.961 Y111.749 E.17665
G1 X179.494 Y111.749 E.01589
G1 X183.38 Y115.635 E.16372
G3 X183.642 Y115.364 I1.448 J1.135 E.01126
G1 X180.027 Y111.749 E.15228
G1 X180.561 Y111.749 E.01589
G1 X183.943 Y115.132 E.14252
G3 X184.269 Y114.924 I.887 J1.03 E.01154
G1 X181.094 Y111.749 E.13376
G1 X181.627 Y111.749 E.01589
G1 X184.643 Y114.765 E.12704
G3 X185.071 Y114.659 I.571 J1.4 E.01318
G1 X182.161 Y111.749 E.1226
G1 X182.694 Y111.749 E.01589
G1 X185.556 Y114.611 E.12057
G3 X186.126 Y114.648 I.163 J1.937 E.01707
G1 X183.227 Y111.749 E.1221
G1 X183.761 Y111.749 E.01589
G1 X186.938 Y114.926 E.13386
G1 X187.425 Y115.244 E.01731
G3 X188.035 Y115.94 I-1.789 J2.182 E.0277
G1 X188.417 Y115.872 E.01158
G1 X184.294 Y111.749 E.17371
G1 X184.827 Y111.749 E.01589
G1 X188.451 Y115.373 E.15265
G1 X188.451 Y114.839 E.01589
G1 X185.361 Y111.749 E.13018
G1 X185.894 Y111.749 E.01589
G1 X188.451 Y114.306 E.10771
G1 X188.451 Y113.772 E.01589
G1 X186.428 Y111.749 E.08524
G1 X186.961 Y111.749 E.01589
G1 X188.451 Y113.239 E.06277
G1 X188.451 Y112.706 E.01589
G1 X187.494 Y111.749 E.04029
G1 X188.028 Y111.749 E.01589
G1 X188.62 Y112.342 E.02497
; CHANGE_LAYER
; Z_HEIGHT: 0.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9545.527
G1 X188.028 Y111.749 E-.31853
G1 X187.494 Y111.749 E-.20268
G1 X187.939 Y112.194 E-.23879
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 4/10
; update layer progress
M73 L4
M991 S0 P3 ;notify layer change

M106 S102
; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z1 I-.794 J-.922 P1  F60000
G1 X184.419 Y115.223 Z1
G1 Z.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X184.597 Y115.136 E.00637
G3 X185.326 Y114.947 I1.002 J2.363 E.02433
G1 X185.569 Y114.932 E.00783
G3 X184.355 Y115.254 I.029 J2.566 E.47769
G1 X184.365 Y115.249 E.00035
; COOLING_NODE: 0
M204 S10000
G1 X184.635 Y115.575 F60000
G1 F8843.478
M204 S8000
G1 X184.964 Y115.435 E.01152
G3 X185.37 Y115.352 I.635 J2.064 E.01336
G1 X185.574 Y115.34 E.00656
G3 X184.553 Y115.61 I.025 J2.159 E.40188
G1 X184.579 Y115.599 E.00094
; COOLING_NODE: 0
M204 S10000
G1 X184.793 Y115.949 F60000
G1 F8843.478
M204 S8000
G1 X185.085 Y115.824 E.01019
G3 X185.414 Y115.757 I.514 J1.674 E.01083
G1 X185.578 Y115.747 E.00528
G3 X184.739 Y115.973 I.021 J1.752 E.32565
; COOLING_NODE: 0
M204 S250
G1 X184.946 Y116.308 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X185.201 Y116.199 E.00827
G3 X185.457 Y116.147 I.398 J1.3 E.00778
G1 X185.583 Y116.14 E.00376
G3 X184.894 Y116.337 I.017 J1.359 E.2328
; COOLING_NODE: 0
; WIPE_START
M204 S8000
G1 X185.201 Y116.199 E-.12811
G1 X185.457 Y116.147 E-.09906
G1 X185.583 Y116.14 E-.04793
G1 X185.859 Y116.165 E-.10535
G1 X186.109 Y116.239 E-.09906
G1 X186.341 Y116.359 E-.09936
G1 X186.546 Y116.522 E-.09949
G1 X186.685 Y116.686 E-.08165
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X184.75 Y124.069 Z1.2 F60000
G1 X167.184 Y191.084 Z1.2
G1 Z.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X167.184 Y203.237 E.39079
G1 X166.96 Y203.255 E.00723
G2 X166.87 Y204.203 I-2.556 J.236 E.48779
G2 X166.954 Y203.74 I-2.169 J-.636 E.01518
G1 X167.184 Y203.754 E.00739
G1 X167.184 Y208.584 E.15532
G1 X161.216 Y208.584 E.1919
G1 X161.216 Y116.116 E2.97342
G1 X167.216 Y116.116 E.19294
G1 X167.216 Y111.416 E.15113
G1 X188.784 Y111.416 E.69354
G1 X188.784 Y191.084 E2.56182
G1 X167.244 Y191.084 E.69265
; COOLING_NODE: 0
; WIPE_START
G1 X167.234 Y193.084 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X165.508 Y200.518 Z1.2 F60000
G1 X165.273 Y201.53 Z1.2
G1 Z.8
G1 E.8 F1800
G1 F8843.478
M204 S8000
G1 X165.573 Y201.687 E.0109
G3 X164.171 Y201.352 I-1.174 J1.812 E.38891
G1 X164.374 Y201.34 E.00655
G3 X165.206 Y201.496 I.025 J2.159 E.0274
G1 X165.219 Y201.503 E.00048
; COOLING_NODE: 0
M204 S10000
G1 X165.086 Y201.891 F60000
G1 F8843.478
M204 S8000
G1 X165.353 Y202.029 E.00966
G3 X164.215 Y201.757 I-.953 J1.469 E.31554
G1 X164.378 Y201.747 E.00528
G3 X165.032 Y201.866 I.021 J1.751 E.02149
; COOLING_NODE: 1
M204 S250
G1 X164.909 Y202.239 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G3 X164.257 Y202.147 I-.509 J1.26 E.23459
G1 X164.383 Y202.14 E.00376
G3 X164.853 Y202.218 I.017 J1.359 E.01427
; COOLING_NODE: 1
; WIPE_START
M204 S8000
G1 X165.14 Y202.359 E-.12167
G1 X165.345 Y202.522 E-.09948
G1 X165.515 Y202.72 E-.09915
G1 X165.645 Y202.953 E-.10131
G1 X165.73 Y203.216 E-.10533
G1 X165.76 Y203.475 E-.09891
G1 X165.74 Y203.736 E-.09957
G1 X165.715 Y203.824 E-.03458
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X166.863 Y196.278 Z1.2 F60000
G1 X167.591 Y191.491 Z1.2
G1 Z.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X167.591 Y208.991 E.56274
G1 X160.809 Y208.991 E.21808
G1 X160.809 Y115.709 E2.9996
G1 X166.809 Y115.709 E.19294
G1 X166.809 Y111.009 E.15113
G1 X189.191 Y111.009 E.71972
G1 X189.191 Y191.491 E2.588
G1 X167.651 Y191.491 E.69265
; COOLING_NODE: 1
M204 S10000
G1 X167.998 Y191.898 F60000
G1 F8843.478
M204 S8000
G1 X167.998 Y209.398 E.56274
G1 X160.402 Y209.398 E.24426
G1 X160.402 Y115.302 E3.02578
G1 X166.402 Y115.302 E.19294
M73 P60 R6
G1 X166.402 Y110.602 E.15113
G1 X189.598 Y110.602 E.7459
G1 X189.598 Y191.898 E2.61418
G1 X168.058 Y191.898 E.69265
; COOLING_NODE: 2
M204 S250
G1 X168.39 Y192.29 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X168.39 Y209.79 E.52127
G1 X160.01 Y209.79 E.24961
G1 X160.01 Y114.91 E2.82615
G1 X166.01 Y114.91 E.17872
G1 X166.01 Y110.21 E.14
G1 X189.99 Y110.21 E.71428
G1 X189.99 Y192.29 E2.44488
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

G1 X168.45 Y192.29 E.6416
; WIPE_START
M204 S8000
G1 X168.443 Y194.29 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X161.38 Y196.046 Z1.2 F60000
G1 Z.8
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42037
G1 F9537.687
M204 S8000
G1 X188.451 Y168.975 E1.14147
G1 X188.451 Y168.441 E.01592
G1 X161.549 Y195.343 E1.13432
G1 X161.549 Y194.809 E.01592
G1 X188.451 Y167.908 E1.13432
G1 X188.451 Y167.374 E.01592
G1 X161.549 Y194.275 E1.13432
G1 X161.549 Y193.741 E.01592
G1 X188.451 Y166.84 E1.13432
G1 X188.451 Y166.306 E.01592
G1 X161.549 Y193.207 E1.13432
G1 X161.549 Y192.674 E.01592
G1 X188.451 Y165.772 E1.13432
G1 X188.451 Y165.239 E.01592
G1 X161.549 Y192.14 E1.13432
G1 X161.549 Y191.606 E.01592
G1 X188.451 Y164.705 E1.13432
G1 X188.451 Y164.171 E.01592
G1 X161.549 Y191.072 E1.13432
G1 X161.549 Y190.538 E.01592
G1 X188.451 Y163.637 E1.13432
G1 X188.451 Y163.103 E.01592
G1 X161.549 Y190.005 E1.13432
G1 X161.549 Y189.471 E.01592
G1 X188.451 Y162.57 E1.13432
G1 X188.451 Y162.036 E.01592
G1 X161.549 Y188.937 E1.13432
G1 X161.549 Y188.403 E.01592
G1 X188.451 Y161.502 E1.13432
G1 X188.451 Y160.968 E.01592
G1 X161.549 Y187.87 E1.13432
G1 X161.549 Y187.336 E.01592
G1 X188.451 Y160.434 E1.13432
G1 X188.451 Y159.901 E.01592
G1 X161.549 Y186.802 E1.13432
G1 X161.549 Y186.268 E.01592
G1 X188.451 Y159.367 E1.13432
G1 X188.451 Y158.833 E.01592
G1 X161.549 Y185.734 E1.13432
G1 X161.549 Y185.201 E.01592
G1 X188.451 Y158.299 E1.13432
G1 X188.451 Y157.765 E.01592
G1 X161.549 Y184.667 E1.13432
G1 X161.549 Y184.133 E.01592
G1 X188.451 Y157.232 E1.13432
G1 X188.451 Y156.698 E.01592
G1 X161.549 Y183.599 E1.13432
G1 X161.549 Y183.065 E.01592
M73 P61 R6
G1 X188.451 Y156.164 E1.13432
G1 X188.451 Y155.63 E.01592
G1 X161.549 Y182.532 E1.13432
G1 X161.549 Y181.998 E.01592
G1 X188.451 Y155.096 E1.13432
G1 X188.451 Y154.563 E.01592
G1 X161.549 Y181.464 E1.13432
G1 X161.549 Y180.93 E.01592
G1 X188.451 Y154.029 E1.13432
G1 X188.451 Y153.495 E.01592
G1 X161.549 Y180.396 E1.13432
G1 X161.549 Y179.863 E.01592
G1 X188.451 Y152.961 E1.13432
G1 X188.451 Y152.428 E.01592
G1 X161.549 Y179.329 E1.13432
G1 X161.549 Y178.795 E.01592
G1 X188.451 Y151.894 E1.13432
G1 X188.451 Y151.36 E.01592
G1 X161.549 Y178.261 E1.13432
G1 X161.549 Y177.727 E.01592
G1 X188.451 Y150.826 E1.13432
G1 X188.451 Y150.292 E.01592
G1 X161.549 Y177.194 E1.13432
G1 X161.549 Y176.66 E.01592
G1 X188.451 Y149.759 E1.13432
G1 X188.451 Y149.225 E.01592
G1 X161.549 Y176.126 E1.13432
G1 X161.549 Y175.592 E.01592
G1 X188.451 Y148.691 E1.13432
G1 X188.451 Y148.157 E.01592
G1 X161.549 Y175.058 E1.13432
G1 X161.549 Y174.525 E.01592
G1 X188.451 Y147.623 E1.13432
G1 X188.451 Y147.09 E.01592
G1 X161.549 Y173.991 E1.13432
G1 X161.549 Y173.457 E.01592
G1 X188.451 Y146.556 E1.13432
G1 X188.451 Y146.022 E.01592
G1 X161.549 Y172.923 E1.13432
G1 X161.549 Y172.389 E.01592
G1 X188.451 Y145.488 E1.13432
G1 X188.451 Y144.954 E.01592
G1 X161.549 Y171.856 E1.13432
G1 X161.549 Y171.322 E.01592
G1 X188.451 Y144.421 E1.13432
G1 X188.451 Y143.887 E.01592
G1 X161.549 Y170.788 E1.13432
G1 X161.549 Y170.254 E.01592
G1 X188.451 Y143.353 E1.13432
G1 X188.451 Y142.819 E.01592
G1 X161.549 Y169.72 E1.13432
G1 X161.549 Y169.187 E.01592
G1 X188.451 Y142.285 E1.13432
G1 X188.451 Y141.752 E.01592
G1 X161.549 Y168.653 E1.13432
G1 X161.549 Y168.119 E.01592
G1 X188.451 Y141.218 E1.13432
G1 X188.451 Y140.684 E.01592
G1 X161.549 Y167.585 E1.13432
G1 X161.549 Y167.052 E.01592
G1 X188.451 Y140.15 E1.13432
G1 X188.451 Y139.616 E.01592
G1 X161.549 Y166.518 E1.13432
G1 X161.549 Y165.984 E.01592
G1 X188.451 Y139.083 E1.13432
G1 X188.451 Y138.549 E.01592
G1 X161.549 Y165.45 E1.13432
G1 X161.549 Y164.916 E.01592
G1 X188.451 Y138.015 E1.13432
G1 X188.451 Y137.481 E.01592
G1 X161.549 Y164.383 E1.13432
G1 X161.549 Y163.849 E.01592
M73 P62 R6
G1 X188.451 Y136.947 E1.13432
G1 X188.451 Y136.414 E.01592
G1 X161.549 Y163.315 E1.13432
G1 X161.549 Y162.781 E.01592
G1 X188.451 Y135.88 E1.13432
G1 X188.451 Y135.346 E.01592
G1 X161.549 Y162.247 E1.13432
G1 X161.549 Y161.714 E.01592
G1 X188.451 Y134.812 E1.13432
G1 X188.451 Y134.278 E.01592
G1 X161.549 Y161.18 E1.13432
G1 X161.549 Y160.646 E.01592
G1 X188.451 Y133.745 E1.13432
G1 X188.451 Y133.211 E.01592
G1 X161.549 Y160.112 E1.13432
G1 X161.549 Y159.578 E.01592
G1 X188.451 Y132.677 E1.13432
G1 X188.451 Y132.143 E.01592
G1 X161.549 Y159.045 E1.13432
G1 X161.549 Y158.511 E.01592
G1 X188.451 Y131.61 E1.13432
G1 X188.451 Y131.076 E.01592
G1 X161.549 Y157.977 E1.13432
G1 X161.549 Y157.443 E.01592
G1 X188.451 Y130.542 E1.13432
G1 X188.451 Y130.008 E.01592
G1 X161.549 Y156.909 E1.13432
G1 X161.549 Y156.376 E.01592
G1 X188.451 Y129.474 E1.13432
G1 X188.451 Y128.941 E.01592
G1 X161.549 Y155.842 E1.13432
G1 X161.549 Y155.308 E.01592
G1 X188.451 Y128.407 E1.13432
G1 X188.451 Y127.873 E.01592
G1 X161.549 Y154.774 E1.13432
G1 X161.549 Y154.24 E.01592
G1 X188.451 Y127.339 E1.13432
G1 X188.451 Y126.805 E.01592
G1 X161.549 Y153.707 E1.13432
G1 X161.549 Y153.173 E.01592
G1 X188.451 Y126.272 E1.13432
G1 X188.451 Y125.738 E.01592
G1 X161.549 Y152.639 E1.13432
G1 X161.549 Y152.105 E.01592
G1 X188.451 Y125.204 E1.13432
G1 X188.451 Y124.67 E.01592
G1 X161.549 Y151.571 E1.13432
G1 X161.549 Y151.038 E.01592
G1 X188.451 Y124.136 E1.13432
G1 X188.451 Y123.603 E.01592
G1 X161.549 Y150.504 E1.13432
G1 X161.549 Y149.97 E.01592
G1 X188.451 Y123.069 E1.13432
G1 X188.451 Y122.535 E.01592
G1 X161.549 Y149.436 E1.13432
G1 X161.549 Y148.902 E.01592
G1 X188.451 Y122.001 E1.13432
G1 X188.451 Y121.467 E.01592
G1 X161.549 Y148.369 E1.13432
G1 X161.549 Y147.835 E.01592
G1 X188.451 Y120.934 E1.13432
G1 X188.451 Y120.4 E.01592
G1 X161.549 Y147.301 E1.13432
G1 X161.549 Y146.767 E.01592
G1 X188.451 Y119.866 E1.13432
G1 X188.451 Y119.332 E.01592
G1 X161.549 Y146.234 E1.13432
G1 X161.549 Y145.7 E.01592
G1 X188 Y119.249 E1.11533
G1 X187.964 Y119.177 E.00241
G1 X187.872 Y119.305 E.00472
G1 X187.499 Y119.695 E.01609
G1 X187.052 Y120.012 E.01634
G3 X186.443 Y120.272 I-1.514 J-2.707 E.01977
G1 X161.549 Y145.166 E1.04967
G1 X161.549 Y144.632 E.01592
G1 X185.796 Y120.385 E1.0224
G3 X185.269 Y120.379 I-.242 J-1.792 E.01579
M73 P63 R6
G1 X161.549 Y144.098 E1.00015
G1 X161.549 Y143.565 E.01592
G1 X184.82 Y120.294 E.98123
G1 X184.434 Y120.146 E.01232
G1 X161.549 Y143.031 E.96496
G1 X161.549 Y142.497 E.01592
G1 X184.079 Y119.968 E.94997
G3 X183.766 Y119.747 I2.446 J-3.802 E.01142
G1 X161.549 Y141.963 E.93677
G1 X161.549 Y141.429 E.01592
G1 X183.496 Y119.483 E.92538
G3 X183.255 Y119.19 I.658 J-.787 E.01137
G1 X161.549 Y140.896 E.91523
G1 X161.549 Y140.362 E.01592
G1 X183.044 Y118.867 E.90635
G3 X182.879 Y118.498 I1.665 J-.966 E.01207
G1 X161.549 Y139.828 E.89939
G1 X161.549 Y139.294 E.01592
G1 X182.768 Y118.075 E.89472
G3 X182.712 Y117.597 I1.183 J-.38 E.01444
G1 X161.549 Y138.76 E.89236
G1 X161.549 Y138.227 E.01592
G1 X182.737 Y117.039 E.8934
G3 X182.978 Y116.264 I3.073 J.531 E.02426
G1 X161.549 Y137.693 E.90356
G1 X161.549 Y137.159 E.01592
G1 X186.959 Y111.749 E1.07142
G1 X187.493 Y111.749 E.01592
G1 X184.363 Y114.879 E.13198
G3 X185.129 Y114.647 I1.152 J2.422 E.02395
G1 X188.027 Y111.749 E.12219
G1 X188.451 Y111.749 E.01264
G1 X188.451 Y111.859 E.00327
G1 X185.7 Y114.61 E.11599
G3 X186.175 Y114.668 I.09 J1.232 E.01437
G1 X188.451 Y112.393 E.09595
G1 X188.451 Y112.927 E.01592
G1 X186.592 Y114.785 E.07837
G3 X186.968 Y114.944 I-.35 J1.357 E.01219
G1 X188.451 Y113.461 E.06253
G1 X188.451 Y113.994 E.01592
G1 X187.295 Y115.15 E.04872
G3 X187.582 Y115.397 I-.698 J1.098 E.01132
G1 X188.451 Y114.528 E.03664
G1 X188.451 Y115.062 E.01592
G1 X187.845 Y115.667 E.02552
G1 X188.036 Y115.941 E.00995
G1 X188.121 Y115.925 E.00258
G1 X188.62 Y115.426 E.02104
M204 S10000
G1 X188.336 Y116.224 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.441411
G1 F9034.079
M204 S8000
G1 X188.369 Y116.4 E.00562
; LINE_WIDTH: 0.412591
G1 F9738.394
G1 X188.404 Y116.593 E.00573
; LINE_WIDTH: 0.377175
G1 F10770.232
G1 X188.422 Y116.724 E.00349
; LINE_WIDTH: 0.34012
G1 F12113.087
G1 X188.441 Y116.868 E.00342
; LINE_WIDTH: 0.296357
G1 F14204.715
G1 X188.466 Y117.156 E.00579
; LINE_WIDTH: 0.265486
G1 F15000
G1 X188.472 Y117.712 E.00977
G1 X188.453 Y118.01 E.00526
; LINE_WIDTH: 0.31297
G1 F13330.866
G1 X188.437 Y118.153 E.00306
; LINE_WIDTH: 0.347202
G1 F11831.154
G1 X188.419 Y118.311 E.00383
; LINE_WIDTH: 0.387486
G1 F10447.935
G1 X188.397 Y118.442 E.00362
; LINE_WIDTH: 0.43358
G1 F9215.193
G1 X188.376 Y118.573 E.0041
G1 X188.102 Y118.712 E.00947
; WIPE_START
G1 X188.376 Y118.573 E-.5303
G1 X188.397 Y118.442 E-.2297
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X181.089 Y116.241 Z1.2 F60000
G1 X167.38 Y112.112 Z1.2
G1 Z.8
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42037
G1 F9537.687
M204 S8000
G1 X167.742 Y111.749 E.01529
G1 X168.276 Y111.749 E.01592
G1 X167.549 Y112.476 E.03065
G1 X167.549 Y113.01 E.01592
G1 X168.81 Y111.749 E.05316
G1 X169.344 Y111.749 E.01592
G1 X167.549 Y113.544 E.07566
G1 X167.549 Y114.078 E.01592
G1 X169.878 Y111.749 E.09817
G1 X170.411 Y111.749 E.01592
G1 X167.549 Y114.611 E.12068
G1 X167.549 Y115.145 E.01592
G1 X170.945 Y111.749 E.14319
G1 X171.479 Y111.749 E.01592
G1 X167.38 Y115.849 E.17285
; WIPE_START
G1 X168.794 Y114.434 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X161.595 Y116.969 Z1.2 F60000
G1 X161.38 Y117.044 Z1.2
G1 Z.8
G1 E.8 F1800
G1 F9537.687
M204 S8000
G1 X161.975 Y116.449 E.02509
G1 X162.509 Y116.449 E.01592
G1 X161.549 Y117.409 E.04045
G1 X161.549 Y117.942 E.01592
G1 X163.042 Y116.449 E.06295
G1 X163.576 Y116.449 E.01592
G1 X161.549 Y118.476 E.08546
G1 X161.549 Y119.01 E.01592
G1 X164.11 Y116.449 E.10797
G1 X164.644 Y116.449 E.01592
G1 X161.549 Y119.544 E.13048
G1 X161.549 Y120.078 E.01592
G1 X165.178 Y116.449 E.15299
G1 X165.711 Y116.449 E.01592
G1 X161.549 Y120.611 E.17549
G1 X161.549 Y121.145 E.01592
G1 X166.245 Y116.449 E.198
G1 X166.779 Y116.449 E.01592
G1 X161.549 Y121.679 E.22051
G1 X161.549 Y122.213 E.01592
G1 X172.013 Y111.749 E.4412
G1 X172.547 Y111.749 E.01592
G1 X161.549 Y122.747 E.46371
G1 X161.549 Y123.28 E.01592
G1 X173.08 Y111.749 E.48622
G1 X173.614 Y111.749 E.01592
G1 X161.549 Y123.814 E.50872
G1 X161.549 Y124.348 E.01592
G1 X174.148 Y111.749 E.53123
G1 X174.682 Y111.749 E.01592
G1 X161.549 Y124.882 E.55374
G1 X161.549 Y125.416 E.01592
G1 X175.216 Y111.749 E.57625
G1 X175.749 Y111.749 E.01592
G1 X161.549 Y125.949 E.59875
G1 X161.549 Y126.483 E.01592
G1 X176.283 Y111.749 E.62126
G1 X176.817 Y111.749 E.01592
G1 X161.549 Y127.017 E.64377
G1 X161.549 Y127.551 E.01592
G1 X177.351 Y111.749 E.66628
G1 X177.884 Y111.749 E.01592
G1 X161.549 Y128.084 E.68879
G1 X161.549 Y128.618 E.01592
G1 X178.418 Y111.749 E.7113
G1 X178.952 Y111.749 E.01592
G1 X161.549 Y129.152 E.7338
G1 X161.549 Y129.686 E.01592
G1 X179.486 Y111.749 E.75631
G1 X180.02 Y111.749 E.01592
G1 X161.549 Y130.22 E.77882
G1 X161.549 Y130.753 E.01592
G1 X180.553 Y111.749 E.80133
G1 X181.087 Y111.749 E.01592
M73 P63 R5
G1 X161.549 Y131.287 E.82384
G1 X161.549 Y131.821 E.01592
G1 X181.621 Y111.749 E.84634
G1 X182.155 Y111.749 E.01592
G1 X161.549 Y132.355 E.86885
G1 X161.549 Y132.889 E.01592
G1 X182.689 Y111.749 E.89136
G1 X183.222 Y111.749 E.01592
G1 X161.549 Y133.422 E.91387
G1 X161.549 Y133.956 E.01592
G1 X183.756 Y111.749 E.93637
G1 X184.29 Y111.749 E.01592
G1 X161.549 Y134.49 E.95888
G1 X161.549 Y135.024 E.01592
G1 X184.824 Y111.749 E.98139
G1 X185.358 Y111.749 E.01592
G1 X161.549 Y135.558 E1.0039
G1 X161.549 Y136.091 E.01592
M73 P64 R5
G1 X185.891 Y111.749 E1.02641
G1 X186.425 Y111.749 E.01592
G1 X161.38 Y136.795 E1.05607
; WIPE_START
G1 X162.794 Y135.381 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X165.933 Y142.338 Z1.2 F60000
G1 X187.857 Y190.92 Z1.2
G1 Z.8
G1 E.8 F1800
G1 F9537.687
M204 S8000
G1 X188.451 Y190.327 E.02502
G1 X188.451 Y189.793 E.01592
G1 X187.493 Y190.751 E.04037
G1 X186.959 Y190.751 E.01592
G1 X188.451 Y189.259 E.06288
G1 X188.451 Y188.726 E.01592
G1 X186.426 Y190.751 E.08539
G1 X185.892 Y190.751 E.01592
G1 X188.451 Y188.192 E.1079
G1 X188.451 Y187.658 E.01592
G1 X185.358 Y190.751 E.13041
G1 X184.824 Y190.751 E.01592
G1 X188.451 Y187.124 E.15291
G1 X188.451 Y186.59 E.01592
G1 X184.29 Y190.751 E.17542
G1 X183.757 Y190.751 E.01592
G1 X188.451 Y186.057 E.19793
G1 X188.451 Y185.523 E.01592
G1 X183.223 Y190.751 E.22044
G1 X182.689 Y190.751 E.01592
G1 X188.451 Y184.989 E.24295
G1 X188.451 Y184.455 E.01592
G1 X182.155 Y190.751 E.26545
G1 X181.621 Y190.751 E.01592
G1 X188.451 Y183.921 E.28796
G1 X188.451 Y183.388 E.01592
G1 X181.088 Y190.751 E.31047
G1 X180.554 Y190.751 E.01592
G1 X188.451 Y182.854 E.33298
G1 X188.451 Y182.32 E.01592
G1 X180.02 Y190.751 E.35549
G1 X179.486 Y190.751 E.01592
G1 X188.451 Y181.786 E.37799
G1 X188.451 Y181.252 E.01592
G1 X178.952 Y190.751 E.4005
G1 X178.419 Y190.751 E.01592
G1 X188.451 Y180.719 E.42301
G1 X188.451 Y180.185 E.01592
G1 X177.885 Y190.751 E.44552
G1 X177.351 Y190.751 E.01592
G1 X188.451 Y179.651 E.46803
G1 X188.451 Y179.117 E.01592
G1 X176.817 Y190.751 E.49053
G1 X176.283 Y190.751 E.01592
G1 X188.451 Y178.583 E.51304
G1 X188.451 Y178.05 E.01592
G1 X175.75 Y190.751 E.53555
G1 X175.216 Y190.751 E.01592
G1 X188.451 Y177.516 E.55806
G1 X188.451 Y176.982 E.01592
G1 X174.682 Y190.751 E.58057
G1 X174.148 Y190.751 E.01592
G1 X188.451 Y176.448 E.60307
G1 X188.451 Y175.914 E.01592
G1 X173.614 Y190.751 E.62558
G1 X173.081 Y190.751 E.01592
G1 X188.451 Y175.381 E.64809
G1 X188.451 Y174.847 E.01592
G1 X172.547 Y190.751 E.6706
G1 X172.013 Y190.751 E.01592
G1 X188.451 Y174.313 E.6931
G1 X188.451 Y173.779 E.01592
G1 X171.479 Y190.751 E.71561
G1 X170.946 Y190.751 E.01592
G1 X188.451 Y173.246 E.73812
G1 X188.451 Y172.712 E.01592
G1 X170.412 Y190.751 E.76063
G1 X169.878 Y190.751 E.01592
G1 X188.451 Y172.178 E.78314
G1 X188.451 Y171.644 E.01592
G1 X169.344 Y190.751 E.80564
G1 X168.81 Y190.751 E.01592
G1 X188.451 Y171.11 E.82815
G1 X188.451 Y170.577 E.01592
G1 X168.277 Y190.751 E.85066
G1 X167.743 Y190.751 E.01592
G1 X188.451 Y170.043 E.87317
G1 X188.451 Y169.509 E.01592
G1 X167.209 Y190.751 E.89568
G1 X166.851 Y190.751 E.01068
G1 X166.851 Y191.109 E.01068
G1 X161.549 Y196.41 E.22353
G1 X161.549 Y196.944 E.01592
G1 X166.851 Y191.643 E.22353
G1 X166.851 Y192.177 E.01592
G1 X161.549 Y197.478 E.22353
G1 X161.549 Y198.012 E.01592
G1 X166.851 Y192.71 E.22353
G1 X166.851 Y193.244 E.01592
G1 X161.549 Y198.545 E.22353
G1 X161.549 Y199.079 E.01592
G1 X166.851 Y193.778 E.22353
G1 X166.851 Y194.312 E.01592
G1 X161.549 Y199.613 E.22353
G1 X161.549 Y200.147 E.01592
G1 X166.851 Y194.846 E.22353
G1 X166.851 Y195.379 E.01592
G1 X161.549 Y200.681 E.22353
G1 X161.549 Y201.214 E.01592
G1 X166.851 Y195.913 E.22353
G1 X166.851 Y196.447 E.01592
G1 X161.549 Y201.748 E.22353
G1 X161.549 Y201.837 E.00264
G1 X161.952 Y201.635 E.01342
G1 X162.033 Y201.798 E.00542
G1 X166.851 Y196.981 E.20313
G1 X166.851 Y197.515 E.01592
G1 X163.662 Y200.703 E.13446
G3 X164.296 Y200.603 I.712 J2.445 E.01919
G1 X166.851 Y198.048 E.10772
G1 X166.851 Y198.582 E.01592
G1 X164.802 Y200.63 E.08636
G3 X165.242 Y200.725 I-.477 J3.28 E.01341
G1 X166.851 Y199.116 E.06785
G1 X166.851 Y199.65 E.01592
G1 X165.623 Y200.877 E.05175
G3 X165.972 Y201.062 I-.461 J1.293 E.01182
G1 X166.851 Y200.183 E.03703
G1 X166.851 Y200.717 E.01592
G1 X166.277 Y201.291 E.02421
G3 X166.548 Y201.554 I-1.137 J1.445 E.01128
G1 X167.02 Y201.081 E.01993
M204 S10000
G1 X166.762 Y202.01 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.108878
G1 F15000
M204 S8000
G1 X166.854 Y202.13 E.00079
; LINE_WIDTH: 0.138527
G1 X166.98 Y202.312 E.00167
; WIPE_START
G1 X166.854 Y202.13 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X167.387 Y203.493 Z1.2 F60000
G1 Z.8
G1 E.8 F1800
; LINE_WIDTH: 0.152652
G1 F15000
M204 S8000
G1 X167.083 Y203.496 E.00264
; LINE_WIDTH: 0.115497
G1 X166.779 Y203.5 E.00174
; WIPE_START
G1 X167.083 Y203.496 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X166.98 Y204.666 Z1.2 F60000
G1 Z.8
G1 E.8 F1800
; LINE_WIDTH: 0.122323
G1 F15000
M204 S8000
G1 X166.799 Y204.93 E.00201
M204 S10000
G1 X166.708 Y205.353 F60000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F9547.299
M204 S8000
G1 X166.323 Y205.751 E.01649
G1 X165.857 Y206.076 E.01692
G1 X165.393 Y206.286 E.01518
G1 X164.779 Y206.435 E.0188
G1 X164.195 Y206.452 E.0174
G1 X163.605 Y206.351 E.01783
G1 X163.115 Y206.166 E.01559
G1 X162.59 Y205.842 E.0184
G1 X162.177 Y205.454 E.01688
G1 X161.936 Y205.122 E.0122
G1 X161.608 Y205.184 E.00994
G1 X161.608 Y208.192 E.08959
G1 X166.792 Y208.192 E.15439
G1 X166.792 Y205.396 E.08326
G1 X166.761 Y205.381 E.00101
M204 S10000
G1 X166.415 Y206.15 F60000
G1 F9547.299
M204 S8000
G3 X165.521 Y206.641 I-1.893 J-2.381 E.03052
G1 X164.863 Y206.803 E.02017
G1 X164.204 Y206.829 E.01966
G1 X163.539 Y206.722 E.02006
G1 X162.98 Y206.518 E.01772
G1 X162.39 Y206.161 E.02055
G1 X161.985 Y205.792 E.01632
G1 X161.985 Y207.815 E.06025
G1 X166.415 Y207.815 E.13193
G1 X166.415 Y206.21 E.04781
M204 S10000
G1 X166.011 Y206.866 F60000
; LINE_WIDTH: 0.45206
G1 F8798.944
M204 S8000
G1 X165.504 Y207.049 E.01743
; LINE_WIDTH: 0.415098
G1 F9672.804
G1 X165.223 Y207.096 E.00838
; LINE_WIDTH: 0.382913
G1 F10588.469
G1 X164.942 Y207.144 E.00766
; LINE_WIDTH: 0.366633
G1 F11120.987
G1 X164.212 Y207.17 E.01868
G1 X163.474 Y207.086 E.01897
; LINE_WIDTH: 0.424954
G1 F9423.262
G1 X163.258 Y207.03 E.00673
; LINE_WIDTH: 0.46488
G1 F8531.614
G1 X163.042 Y206.975 E.00743
; LINE_WIDTH: 0.504807
G1 F7794.119
G1 X162.826 Y206.919 E.00814
; LINE_WIDTH: 0.535983
G1 F7301.302
G1 X162.422 Y206.696 E.018
G1 X162.422 Y207.378 E.02656
; LINE_WIDTH: 0.521409
G1 F7523.695
G1 X162.691 Y207.396 E.01018
; LINE_WIDTH: 0.486585
G1 F8114.23
G1 X162.959 Y207.413 E.00944
; LINE_WIDTH: 0.451762
G1 F8805.364
G1 X163.228 Y207.43 E.0087
; LINE_WIDTH: 0.414598
G1 F9685.816
G1 X163.616 Y207.45 E.01141
; LINE_WIDTH: 0.361386
G1 F11304.215
G2 X164.761 Y207.471 I.782 J-11.531 E.02882
; LINE_WIDTH: 0.372818
G1 F10912.48
G1 X165.154 Y207.451 E.01025
; LINE_WIDTH: 0.411733
G1 F9761.057
G1 X165.547 Y207.432 E.01146
; LINE_WIDTH: 0.462726
G1 F8575.398
G1 X166.011 Y207.411 E.0154
G1 X166.011 Y206.926 E.0161
; WIPE_START
G1 X166.011 Y207.411 E-.3884
G1 X165.547 Y207.432 E-.3716
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X161.664 Y204.775 Z1.2 F60000
G1 Z.8
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.432347
G1 F9244.352
M204 S8000
G1 X161.603 Y204.455 E.01001
; LINE_WIDTH: 0.387806
G1 F10438.24
G1 X161.581 Y204.299 E.00428
; LINE_WIDTH: 0.34677
G1 F11847.969
G1 X161.562 Y204.161 E.00334
; LINE_WIDTH: 0.312858
G1 F13336.404
G1 X161.548 Y204.002 E.00341
; LINE_WIDTH: 0.286276
G1 F14793.163
G1 X161.535 Y203.858 E.00279
; LINE_WIDTH: 0.265142
G1 F15000
G1 X161.524 Y203.553 E.00535
G1 X161.545 Y203.003 E.00967
; LINE_WIDTH: 0.311364
G1 F13410.623
G1 X161.563 Y202.848 E.00331
; LINE_WIDTH: 0.345191
G1 F11909.856
G1 X161.579 Y202.706 E.00341
; LINE_WIDTH: 0.383417
G1 F10572.793
G1 X161.601 Y202.566 E.0038
; LINE_WIDTH: 0.426354
G1 F9388.849
G1 X161.622 Y202.442 E.00381
; LINE_WIDTH: 0.452859
G1 F8781.797
G1 X161.625 Y202.425 E.00058
G1 X161.904 Y202.285 E.01011
; CHANGE_LAYER
; Z_HEIGHT: 1
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F8781.797
G1 X161.625 Y202.425 E-.71875
G1 X161.622 Y202.442 E-.04125
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 5/10
; update layer progress
M73 L5
M991 S0 P4 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z1.2 I1.178 J.306 P1  F60000
G1 X184.282 Y115.306 Z1.2
G1 Z1
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X184.381 Y115.239 E.00386
G3 X185.329 Y114.946 I1.216 J2.26 E.0321
G1 X185.585 Y114.932 E.00825
G3 X183.972 Y115.512 I.012 J2.566 E.46229
G1 X184.232 Y115.339 E.01004
; COOLING_NODE: 0
M204 S10000
G1 X184.508 Y115.643 F60000
G1 F8843.478
M204 S8000
G1 X184.575 Y115.597 E.00261
G3 X185.372 Y115.352 I1.023 J1.901 E.027
G1 X185.588 Y115.34 E.00695
G3 X184.231 Y115.828 I.01 J2.159 E.38891
G1 X184.458 Y115.677 E.00878
; COOLING_NODE: 0
M204 S10000
G1 X184.734 Y115.98 F60000
G1 F8843.478
M204 S8000
G1 X184.769 Y115.956 E.00137
G3 X185.416 Y115.757 I.83 J1.543 E.0219
G1 X185.591 Y115.747 E.00565
G3 X184.49 Y116.143 I.008 J1.752 E.31554
G1 X184.684 Y116.014 E.00751
; COOLING_NODE: 0
M204 S250
G1 X184.951 Y116.305 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X184.956 Y116.302 E.00016
G3 X185.457 Y116.147 I.644 J1.197 E.01573
G1 X185.594 Y116.14 E.00407
G3 X184.739 Y116.447 I.006 J1.359 E.22682
G1 X184.901 Y116.338 E.00582
; COOLING_NODE: 0
; WIPE_START
M204 S8000
G1 X184.956 Y116.302 E-.02489
G1 X185.201 Y116.2 E-.10102
G1 X185.457 Y116.147 E-.0993
G1 X185.594 Y116.14 E-.05194
G1 X185.859 Y116.165 E-.10128
G1 X186.11 Y116.239 E-.09949
G1 X186.238 Y116.299 E-.05379
G1 X186.457 Y116.444 E-.09961
G1 X186.657 Y116.643 E-.10732
G1 X186.688 Y116.69 E-.02136
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X184.752 Y124.073 Z1.4 F60000
G1 X167.184 Y191.084 Z1.4
G1 Z1
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X167.184 Y203.247 E.39111
G1 X166.957 Y203.263 E.00732
G2 X166.958 Y203.74 I-2.555 J.244 E.50324
G1 X167.184 Y203.757 E.00729
G1 X167.184 Y208.584 E.1552
G1 X161.216 Y208.584 E.1919
M73 P65 R5
G1 X161.216 Y116.116 E2.97342
G1 X167.216 Y116.116 E.19294
G1 X167.216 Y111.416 E.15113
G1 X188.784 Y111.416 E.69354
G1 X188.784 Y191.084 E2.56182
G1 X167.244 Y191.084 E.69265
; COOLING_NODE: 0
; WIPE_START
G1 X167.234 Y193.084 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X165.514 Y200.52 Z1.4 F60000
G1 X165.279 Y201.534 Z1.4
G1 Z1
G1 E.8 F1800
G1 F8843.478
M204 S8000
G1 X165.597 Y201.704 E.0116
G3 X164.172 Y201.352 I-1.2 J1.795 E.38808
G1 X164.388 Y201.34 E.00695
G3 X165.209 Y201.498 I.01 J2.159 E.02704
G1 X165.226 Y201.507 E.00062
; COOLING_NODE: 0
M204 S10000
G1 X165.09 Y201.892 F60000
G1 F8843.478
M204 S8000
G1 X165.372 Y202.043 E.01029
G3 X164.216 Y201.757 I-.973 J1.456 E.31485
G1 X164.391 Y201.747 E.00565
G3 X165.035 Y201.867 I.008 J1.752 E.0212
; COOLING_NODE: 1
M204 S250
G1 X164.909 Y202.239 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G3 X164.257 Y202.147 I-.51 J1.26 E.23462
G1 X164.394 Y202.14 E.00407
G3 X164.853 Y202.218 I.006 J1.359 E.01396
; COOLING_NODE: 1
; WIPE_START
M204 S8000
G1 X165.155 Y202.369 E-.12833
G1 X165.362 Y202.538 E-.10151
G1 X165.457 Y202.644 E-.05392
G1 X165.611 Y202.881 E-.10775
G1 X165.706 Y203.119 E-.09715
G1 X165.754 Y203.375 E-.0991
G1 X165.753 Y203.641 E-.10115
G1 X165.717 Y203.825 E-.07109
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X166.863 Y196.279 Z1.4 F60000
G1 X167.591 Y191.491 Z1.4
G1 Z1
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X167.591 Y208.991 E.56274
G1 X160.809 Y208.991 E.21808
G1 X160.809 Y115.709 E2.9996
G1 X166.809 Y115.709 E.19294
G1 X166.809 Y111.009 E.15113
G1 X189.191 Y111.009 E.71972
G1 X189.191 Y191.491 E2.588
G1 X167.651 Y191.491 E.69265
; COOLING_NODE: 1
M204 S10000
G1 X167.998 Y191.898 F60000
G1 F8843.478
M204 S8000
G1 X167.998 Y209.398 E.56274
G1 X160.402 Y209.398 E.24426
G1 X160.402 Y115.302 E3.02578
G1 X166.402 Y115.302 E.19294
G1 X166.402 Y110.602 E.15113
G1 X189.598 Y110.602 E.7459
G1 X189.598 Y191.898 E2.61418
G1 X168.058 Y191.898 E.69265
; COOLING_NODE: 2
M204 S250
G1 X168.39 Y192.29 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X168.39 Y209.79 E.52127
G1 X160.01 Y209.79 E.24961
G1 X160.01 Y114.91 E2.82615
G1 X166.01 Y114.91 E.17872
G1 X166.01 Y110.21 E.14
G1 X189.99 Y110.21 E.71428
G1 X189.99 Y192.29 E2.44488
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

G1 X168.45 Y192.29 E.6416
; WIPE_START
M204 S8000
G1 X168.443 Y194.29 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X166.851 Y201.755 Z1.4 F60000
G1 X166.788 Y202.051 Z1.4
G1 Z1
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.125037
G1 F15000
M204 S8000
G1 X166.98 Y202.327 E.00218
; WIPE_START
G1 X166.788 Y202.051 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X167.387 Y203.502 Z1.4 F60000
G1 Z1
G1 E.8 F1800
; LINE_WIDTH: 0.14842
G1 F15000
M204 S8000
G1 X167.106 Y203.502 E.00235
; LINE_WIDTH: 0.114088
G1 X166.825 Y203.501 E.00158
; WIPE_START
G1 X167.106 Y203.502 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X166.98 Y204.673 Z1.4 F60000
G1 Z1
G1 E.8 F1800
; LINE_WIDTH: 0.125095
G1 F15000
M204 S8000
G1 X166.788 Y204.949 E.00218
M204 S10000
G1 X166.685 Y205.381 F60000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F9547.299
M204 S8000
G3 X165.542 Y206.23 I-2.392 J-2.027 E.0428
G1 X164.98 Y206.403 E.01751
G1 X164.414 Y206.46 E.01692
G1 X163.853 Y206.409 E.01679
G1 X163.277 Y206.238 E.0179
G1 X162.762 Y205.965 E.01737
G1 X162.321 Y205.607 E.01691
G1 X161.943 Y205.123 E.01828
G1 X161.608 Y205.181 E.01011
G1 X161.608 Y208.192 E.08967
G1 X166.792 Y208.192 E.15439
G1 X166.792 Y205.43 E.08227
G1 X166.74 Y205.406 E.0017
M204 S10000
G1 X166.415 Y206.156 F60000
G1 F9547.299
M204 S8000
G1 X165.719 Y206.563 E.02399
G1 X165.088 Y206.764 E.01974
G1 X164.45 Y206.835 E.01911
G1 X163.816 Y206.784 E.01894
G1 X163.168 Y206.599 E.0201
G1 X162.583 Y206.297 E.0196
G1 X161.989 Y205.808 E.0229
G2 X161.985 Y207.815 I181.781 J1.337 E.05976
G1 X166.415 Y207.815 E.13193
G1 X166.415 Y206.216 E.04761
M204 S10000
G1 X166.011 Y206.864 F60000
; LINE_WIDTH: 0.472215
G1 F8385.841
M204 S8000
G1 X165.731 Y206.992 E.01045
; LINE_WIDTH: 0.451725
G1 F8806.154
G1 X165.461 Y207.051 E.00891
; LINE_WIDTH: 0.411355
G1 F9771.058
G1 X165.192 Y207.111 E.00803
; LINE_WIDTH: 0.363126
G1 F11242.766
G1 X164.483 Y207.174 E.01801
G1 X163.782 Y207.135 E.01774
; LINE_WIDTH: 0.388414
G1 F10419.883
G1 X163.538 Y207.085 E.0068
; LINE_WIDTH: 0.42336
G1 F9462.727
G1 X163.294 Y207.036 E.00748
; LINE_WIDTH: 0.458307
G1 F8666.623
G1 X163.05 Y206.986 E.00817
; LINE_WIDTH: 0.492428
G1 F8008.765
G1 X162.921 Y206.946 E.0048
; LINE_WIDTH: 0.540528
G1 F7234.614
G1 X162.792 Y206.907 E.00531
G1 X162.424 Y206.709 E.01643
G1 X162.424 Y207.376 E.02625
; LINE_WIDTH: 0.525723
G1 F7456.465
G1 X162.705 Y207.393 E.01077
; LINE_WIDTH: 0.492428
G1 F8008.765
G1 X162.987 Y207.41 E.01002
; LINE_WIDTH: 0.454865
G1 F8739.03
G1 X163.269 Y207.431 E.0092
; LINE_WIDTH: 0.413035
G1 F9726.706
G1 X163.551 Y207.452 E.00827
; LINE_WIDTH: 0.363278
G1 F11237.448
G2 X165.028 Y207.462 I.85 J-15.156 E.03739
; LINE_WIDTH: 0.387319
G1 F10453.013
G1 X165.283 Y207.445 E.00695
; LINE_WIDTH: 0.421155
G1 F9517.893
G1 X165.538 Y207.429 E.00763
; LINE_WIDTH: 0.467797
G1 F8473.052
G3 X166.011 Y207.411 I.369 J3.63 E.01592
G1 X166.011 Y206.924 E.01636
; WIPE_START
G1 X166.011 Y207.411 E-.38532
G1 X165.538 Y207.429 E-.37468
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X161.66 Y204.774 Z1.4 F60000
G1 Z1
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.435238
G1 F9176.243
M204 S8000
G1 X161.624 Y204.569 E.00648
; LINE_WIDTH: 0.399113
G1 F10106.9
G1 X161.589 Y204.363 E.00588
; LINE_WIDTH: 0.360758
G1 F11326.547
G1 X161.569 Y204.204 E.00402
; LINE_WIDTH: 0.323745
G1 F12819.378
G1 X161.551 Y204.062 E.00318
; LINE_WIDTH: 0.285159
G1 F14861.367
G1 X161.531 Y203.773 E.00554
; LINE_WIDTH: 0.258283
G1 F15000
G1 X161.531 Y203.212 E.00954
; LINE_WIDTH: 0.284888
G1 F14878.018
G1 X161.55 Y202.953 E.00496
; LINE_WIDTH: 0.319726
G1 F13005.525
G1 X161.566 Y202.817 E.00299
; LINE_WIDTH: 0.350521
G1 F11703.471
G1 X161.581 Y202.692 E.00305
; LINE_WIDTH: 0.387969
G1 F10433.31
G1 X161.604 Y202.552 E.00387
; LINE_WIDTH: 0.432155
G1 F9248.916
G1 X161.625 Y202.427 E.00388
; LINE_WIDTH: 0.440391
G1 F9057.273
G1 X161.641 Y202.419 E.00058
; LINE_WIDTH: 0.415228
G1 F9669.432
G1 X161.657 Y202.41 E.00054
; LINE_WIDTH: 0.387894
G1 F10435.574
G1 X161.899 Y202.289 E.00737
; WIPE_START
G1 X161.657 Y202.41 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X161.38 Y201.373 Z1.4 F60000
G1 Z1
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42006
G1 F9545.527
M204 S8000
G1 X161.77 Y201.764 E.01645
G1 X161.96 Y201.668 E.00634
G1 X162.038 Y201.822 E.00512
G3 X162.178 Y201.638 I.945 J.574 E.0069
G1 X161.549 Y201.009 E.02647
G1 X161.549 Y200.476 E.01589
G1 X162.443 Y201.37 E.03764
G1 X162.735 Y201.128 E.01129
G1 X161.549 Y199.943 E.04994
G1 X161.549 Y199.409 E.01589
G1 X163.073 Y200.933 E.06419
G3 X163.445 Y200.772 I.604 J.886 E.01216
G1 X161.549 Y198.876 E.07987
G1 X161.549 Y198.343 E.01589
G1 X163.859 Y200.652 E.09729
G3 X164.341 Y200.601 I.488 J2.315 E.01448
G1 X161.549 Y197.809 E.11762
G1 X161.549 Y197.276 E.01589
G1 X164.92 Y200.647 E.14202
G1 X165.48 Y200.806 E.01733
M73 P66 R5
G1 X165.729 Y200.922 E.0082
G1 X161.549 Y196.743 E.1761
G1 X161.549 Y196.209 E.01589
G1 X166.851 Y201.511 E.22335
G1 X166.851 Y200.977 E.01589
G1 X161.549 Y195.676 E.22335
G1 X161.549 Y195.143 E.01589
G1 X166.851 Y200.444 E.22335
G1 X166.851 Y199.91 E.01589
G1 X161.549 Y194.609 E.22335
G1 X161.549 Y194.076 E.01589
G1 X166.851 Y199.377 E.22335
G1 X166.851 Y198.844 E.01589
G1 X161.549 Y193.543 E.22335
G1 X161.549 Y193.009 E.01589
G1 X166.851 Y198.31 E.22335
G1 X166.851 Y197.777 E.01589
G1 X161.549 Y192.476 E.22335
G1 X161.549 Y191.942 E.01589
G1 X166.851 Y197.244 E.22335
G1 X166.851 Y196.71 E.01589
G1 X161.549 Y191.409 E.22335
G1 X161.549 Y190.876 E.01589
G1 X166.851 Y196.177 E.22335
G1 X166.851 Y195.644 E.01589
G1 X161.549 Y190.342 E.22335
G1 X161.549 Y189.809 E.01589
G1 X166.851 Y195.11 E.22335
G1 X166.851 Y194.577 E.01589
G1 X161.549 Y189.276 E.22335
G1 X161.549 Y188.742 E.01589
G1 X166.851 Y194.044 E.22335
G1 X166.851 Y193.51 E.01589
G1 X161.549 Y188.209 E.22335
G1 X161.549 Y187.676 E.01589
G1 X166.851 Y192.977 E.22335
G1 X166.851 Y192.443 E.01589
G1 X161.549 Y187.142 E.22335
G1 X161.549 Y186.609 E.01589
G1 X166.851 Y191.91 E.22335
G1 X166.851 Y191.377 E.01589
G1 X161.549 Y186.076 E.22335
G1 X161.549 Y185.542 E.01589
G1 X166.851 Y190.843 E.22335
G1 X166.851 Y190.751 E.00276
G1 X167.291 Y190.751 E.01313
G1 X161.549 Y185.009 E.24191
G1 X161.549 Y184.475 E.01589
G1 X167.825 Y190.751 E.26438
G1 X168.358 Y190.751 E.01589
G1 X161.549 Y183.942 E.28685
G1 X161.549 Y183.409 E.01589
G1 X168.891 Y190.751 E.30932
G1 X169.425 Y190.751 E.01589
G1 X161.549 Y182.875 E.3318
G1 X161.549 Y182.342 E.01589
G1 X169.958 Y190.751 E.35427
G1 X170.491 Y190.751 E.01589
G1 X161.549 Y181.809 E.37674
G1 X161.549 Y181.275 E.01589
G1 X171.025 Y190.751 E.39921
G1 X171.558 Y190.751 E.01589
G1 X161.549 Y180.742 E.42168
G1 X161.549 Y180.209 E.01589
G1 X172.091 Y190.751 E.44415
G1 X172.625 Y190.751 E.01589
G1 X161.549 Y179.675 E.46662
G1 X161.549 Y179.142 E.01589
G1 X173.158 Y190.751 E.48909
G1 X173.691 Y190.751 E.01589
G1 X161.549 Y178.609 E.51156
G1 X161.549 Y178.075 E.01589
G1 X174.225 Y190.751 E.53403
G1 X174.758 Y190.751 E.01589
G1 X161.549 Y177.542 E.55651
G1 X161.549 Y177.008 E.01589
G1 X175.292 Y190.751 E.57898
G1 X175.825 Y190.751 E.01589
G1 X161.549 Y176.475 E.60145
G1 X161.549 Y175.942 E.01589
G1 X176.358 Y190.751 E.62392
G1 X176.892 Y190.751 E.01589
G1 X161.549 Y175.408 E.64639
G1 X161.549 Y174.875 E.01589
G1 X177.425 Y190.751 E.66886
G1 X177.958 Y190.751 E.01589
G1 X161.549 Y174.342 E.69133
G1 X161.549 Y173.808 E.01589
G1 X178.492 Y190.751 E.7138
G1 X179.025 Y190.751 E.01589
G1 X161.549 Y173.275 E.73627
G1 X161.549 Y172.742 E.01589
G1 X179.558 Y190.751 E.75874
G1 X180.092 Y190.751 E.01589
G1 X161.549 Y172.208 E.78122
G1 X161.549 Y171.675 E.01589
G1 X180.625 Y190.751 E.80369
G1 X181.158 Y190.751 E.01589
G1 X161.549 Y171.142 E.82616
G1 X161.549 Y170.608 E.01589
G1 X181.692 Y190.751 E.84863
G1 X182.225 Y190.751 E.01589
G1 X161.549 Y170.075 E.8711
G1 X161.549 Y169.541 E.01589
G1 X182.759 Y190.751 E.89357
G1 X183.292 Y190.751 E.01589
G1 X161.549 Y169.008 E.91604
G1 X161.549 Y168.475 E.01589
G1 X183.825 Y190.751 E.93851
G1 X184.359 Y190.751 E.01589
G1 X161.549 Y167.941 E.96098
G1 X161.549 Y167.408 E.01589
G1 X184.892 Y190.751 E.98346
G1 X185.425 Y190.751 E.01589
G1 X161.549 Y166.875 E1.00593
G1 X161.549 Y166.341 E.01589
G1 X185.959 Y190.751 E1.0284
G1 X186.492 Y190.751 E.01589
G1 X161.549 Y165.808 E1.05087
G1 X161.549 Y165.275 E.01589
G1 X187.025 Y190.751 E1.07334
G1 X187.559 Y190.751 E.01589
G1 X161.549 Y164.741 E1.09581
G1 X161.549 Y164.208 E.01589
G1 X188.092 Y190.751 E1.11828
G1 X188.451 Y190.751 E.01068
G1 X188.451 Y190.576 E.00521
G1 X161.549 Y163.675 E1.13339
G1 X161.549 Y163.141 E.01589
G1 X188.451 Y190.042 E1.13339
G1 X188.451 Y189.509 E.01589
G1 X161.549 Y162.608 E1.13339
G1 X161.549 Y162.074 E.01589
G1 X188.451 Y188.976 E1.13339
G1 X188.451 Y188.442 E.01589
G1 X161.549 Y161.541 E1.13339
G1 X161.549 Y161.008 E.01589
G1 X188.451 Y187.909 E1.13339
M73 P67 R5
G1 X188.451 Y187.376 E.01589
G1 X161.549 Y160.474 E1.13339
G1 X161.549 Y159.941 E.01589
G1 X188.451 Y186.842 E1.13339
G1 X188.451 Y186.309 E.01589
G1 X161.549 Y159.408 E1.13339
G1 X161.549 Y158.874 E.01589
G1 X188.451 Y185.776 E1.13339
G1 X188.451 Y185.242 E.01589
G1 X161.549 Y158.341 E1.13339
G1 X161.549 Y157.808 E.01589
G1 X188.451 Y184.709 E1.13339
G1 X188.451 Y184.176 E.01589
G1 X161.549 Y157.274 E1.13339
G1 X161.549 Y156.741 E.01589
G1 X188.451 Y183.642 E1.13339
G1 X188.451 Y183.109 E.01589
G1 X161.549 Y156.208 E1.13339
G1 X161.549 Y155.674 E.01589
G1 X188.451 Y182.575 E1.13339
G1 X188.451 Y182.042 E.01589
G1 X161.549 Y155.141 E1.13339
G1 X161.549 Y154.607 E.01589
G1 X188.451 Y181.509 E1.13339
G1 X188.451 Y180.975 E.01589
G1 X161.549 Y154.074 E1.13339
G1 X161.549 Y153.541 E.01589
G1 X188.451 Y180.442 E1.13339
G1 X188.451 Y179.909 E.01589
G1 X161.549 Y153.007 E1.13339
G1 X161.549 Y152.474 E.01589
G1 X188.451 Y179.375 E1.13339
G1 X188.451 Y178.842 E.01589
G1 X161.549 Y151.941 E1.13339
G1 X161.549 Y151.407 E.01589
G1 X188.451 Y178.309 E1.13339
G1 X188.451 Y177.775 E.01589
G1 X161.549 Y150.874 E1.13339
G1 X161.549 Y150.341 E.01589
G1 X188.451 Y177.242 E1.13339
G1 X188.451 Y176.709 E.01589
G1 X161.549 Y149.807 E1.13339
G1 X161.549 Y149.274 E.01589
G1 X188.451 Y176.175 E1.13339
G1 X188.451 Y175.642 E.01589
G1 X161.549 Y148.741 E1.13339
G1 X161.549 Y148.207 E.01589
G1 X188.451 Y175.108 E1.13339
G1 X188.451 Y174.575 E.01589
G1 X161.549 Y147.674 E1.13339
G1 X161.549 Y147.14 E.01589
G1 X188.451 Y174.042 E1.13339
G1 X188.451 Y173.508 E.01589
G1 X161.549 Y146.607 E1.13339
G1 X161.549 Y146.074 E.01589
G1 X188.451 Y172.975 E1.13339
G1 X188.451 Y172.442 E.01589
G1 X161.549 Y145.54 E1.13339
G1 X161.549 Y145.007 E.01589
G1 X188.451 Y171.908 E1.13339
G1 X188.451 Y171.375 E.01589
G1 X161.549 Y144.474 E1.13339
G1 X161.549 Y143.94 E.01589
G1 X188.451 Y170.842 E1.13339
G1 X188.451 Y170.308 E.01589
G1 X161.549 Y143.407 E1.13339
G1 X161.549 Y142.874 E.01589
G1 X188.451 Y169.775 E1.13339
G1 X188.451 Y169.242 E.01589
G1 X161.549 Y142.34 E1.13339
G1 X161.549 Y141.807 E.01589
G1 X188.451 Y168.708 E1.13339
G1 X188.451 Y168.175 E.01589
M73 P68 R5
G1 X161.549 Y141.274 E1.13339
G1 X161.549 Y140.74 E.01589
G1 X188.451 Y167.641 E1.13339
G1 X188.451 Y167.108 E.01589
G1 X161.549 Y140.207 E1.13339
G1 X161.549 Y139.673 E.01589
G1 X188.451 Y166.575 E1.13339
G1 X188.451 Y166.041 E.01589
G1 X161.549 Y139.14 E1.13339
G1 X161.549 Y138.607 E.01589
G1 X188.451 Y165.508 E1.13339
G1 X188.451 Y164.975 E.01589
G1 X161.549 Y138.073 E1.13339
G1 X161.549 Y137.54 E.01589
G1 X188.451 Y164.441 E1.13339
G1 X188.451 Y163.908 E.01589
G1 X161.549 Y137.007 E1.13339
G1 X161.549 Y136.473 E.01589
G1 X188.451 Y163.375 E1.13339
G1 X188.451 Y162.841 E.01589
G1 X161.549 Y135.94 E1.13339
G1 X161.549 Y135.407 E.01589
G1 X188.451 Y162.308 E1.13339
G1 X188.451 Y161.775 E.01589
G1 X161.549 Y134.873 E1.13339
G1 X161.549 Y134.34 E.01589
G1 X188.451 Y161.241 E1.13339
G1 X188.451 Y160.708 E.01589
G1 X161.549 Y133.807 E1.13339
G1 X161.549 Y133.273 E.01589
G1 X188.451 Y160.174 E1.13339
G1 X188.451 Y159.641 E.01589
G1 X161.549 Y132.74 E1.13339
G1 X161.549 Y132.207 E.01589
G1 X188.451 Y159.108 E1.13339
G1 X188.451 Y158.574 E.01589
G1 X161.549 Y131.673 E1.13339
G1 X161.549 Y131.14 E.01589
G1 X188.451 Y158.041 E1.13339
G1 X188.451 Y157.508 E.01589
G1 X161.549 Y130.606 E1.13339
G1 X161.549 Y130.073 E.01589
G1 X188.451 Y156.974 E1.13339
G1 X188.451 Y156.441 E.01589
G1 X161.549 Y129.54 E1.13339
G1 X161.549 Y129.006 E.01589
G1 X188.451 Y155.908 E1.13339
G1 X188.451 Y155.374 E.01589
G1 X161.549 Y128.473 E1.13339
G1 X161.549 Y127.94 E.01589
G1 X188.451 Y154.841 E1.13339
G1 X188.451 Y154.308 E.01589
G1 X161.549 Y127.406 E1.13339
G1 X161.549 Y126.873 E.01589
G1 X188.451 Y153.774 E1.13339
G1 X188.451 Y153.241 E.01589
G1 X161.549 Y126.34 E1.13339
G1 X161.549 Y125.806 E.01589
G1 X188.451 Y152.708 E1.13339
G1 X188.451 Y152.174 E.01589
G1 X161.549 Y125.273 E1.13339
G1 X161.549 Y124.74 E.01589
G1 X188.451 Y151.641 E1.13339
G1 X188.451 Y151.107 E.01589
G1 X161.549 Y124.206 E1.13339
G1 X161.549 Y123.673 E.01589
G1 X188.451 Y150.574 E1.13339
G1 X188.451 Y150.041 E.01589
G1 X161.549 Y123.139 E1.13339
G1 X161.549 Y122.606 E.01589
G1 X188.451 Y149.507 E1.13339
G1 X188.451 Y148.974 E.01589
G1 X161.549 Y122.073 E1.13339
G1 X161.549 Y121.539 E.01589
M73 P69 R5
G1 X188.451 Y148.441 E1.13339
G1 X188.451 Y147.907 E.01589
G1 X161.549 Y121.006 E1.13339
G1 X161.549 Y120.473 E.01589
G1 X188.451 Y147.374 E1.13339
G1 X188.451 Y146.841 E.01589
G1 X161.549 Y119.939 E1.13339
G1 X161.549 Y119.406 E.01589
G1 X188.451 Y146.307 E1.13339
G1 X188.451 Y145.774 E.01589
G1 X161.549 Y118.873 E1.13339
G1 X161.549 Y118.339 E.01589
G1 X188.451 Y145.241 E1.13339
G1 X188.451 Y144.707 E.01589
G1 X161.549 Y117.806 E1.13339
G1 X161.549 Y117.273 E.01589
G1 X188.451 Y144.174 E1.13339
G1 X188.451 Y143.64 E.01589
G1 X161.549 Y116.739 E1.13339
G1 X161.549 Y116.449 E.00863
G1 X161.793 Y116.449 E.00726
G1 X188.451 Y143.107 E1.12313
G1 X188.451 Y142.574 E.01589
G1 X162.326 Y116.449 E1.10066
G1 X162.86 Y116.449 E.01589
G1 X188.451 Y142.04 E1.07818
G1 X188.451 Y141.507 E.01589
G1 X163.393 Y116.449 E1.05571
G1 X163.926 Y116.449 E.01589
G1 X188.451 Y140.974 E1.03324
G1 X188.451 Y140.44 E.01589
G1 X164.46 Y116.449 E1.01077
G1 X164.993 Y116.449 E.01589
G1 X188.451 Y139.907 E.9883
G1 X188.451 Y139.374 E.01589
G1 X165.526 Y116.449 E.96583
G1 X166.06 Y116.449 E.01589
G1 X188.451 Y138.84 E.94336
G1 X188.451 Y138.307 E.01589
G1 X166.593 Y116.449 E.92089
G1 X167.126 Y116.449 E.01589
G1 X188.451 Y137.774 E.89842
G1 X188.451 Y137.24 E.01589
G1 X167.549 Y116.339 E.8806
G1 X167.549 Y115.806 E.01589
G1 X188.451 Y136.707 E.8806
G1 X188.451 Y136.173 E.01589
G1 X167.549 Y115.272 E.8806
G1 X167.549 Y114.739 E.01589
G1 X188.451 Y135.64 E.8806
G1 X188.451 Y135.107 E.01589
G1 X167.549 Y114.205 E.8806
G1 X167.549 Y113.672 E.01589
G1 X188.451 Y134.573 E.8806
G1 X188.451 Y134.04 E.01589
G1 X167.549 Y113.139 E.8806
G1 X167.549 Y112.605 E.01589
G1 X188.451 Y133.507 E.8806
G1 X188.451 Y132.973 E.01589
G1 X167.549 Y112.072 E.8806
G1 X167.549 Y111.749 E.00961
G1 X167.76 Y111.749 E.00628
G1 X188.451 Y132.44 E.87172
G1 X188.451 Y131.907 E.01589
G1 X168.293 Y111.749 E.84925
G1 X168.827 Y111.749 E.01589
G1 X188.451 Y131.373 E.82678
G1 X188.451 Y130.84 E.01589
G1 X169.36 Y111.749 E.80431
G1 X169.893 Y111.749 E.01589
M73 P69 R4
G1 X188.451 Y130.307 E.78184
G1 X188.451 Y129.773 E.01589
G1 X170.427 Y111.749 E.75937
G1 X170.96 Y111.749 E.01589
G1 X188.451 Y129.24 E.7369
G1 X188.451 Y128.706 E.01589
G1 X171.494 Y111.749 E.71443
G1 X172.027 Y111.749 E.01589
G1 X188.451 Y128.173 E.69195
G1 X188.451 Y127.64 E.01589
G1 X172.56 Y111.749 E.66948
G1 X173.094 Y111.749 E.01589
G1 X188.451 Y127.106 E.64701
G1 X188.451 Y126.573 E.01589
G1 X173.627 Y111.749 E.62454
G1 X174.16 Y111.749 E.01589
M73 P70 R4
G1 X188.451 Y126.04 E.60207
G1 X188.451 Y125.506 E.01589
G1 X174.694 Y111.749 E.5796
G1 X175.227 Y111.749 E.01589
G1 X188.62 Y125.143 E.56428
; WIPE_START
G1 X187.206 Y123.728 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X188.339 Y116.225 Z1.4 F60000
G1 Z1
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.43649
G1 F9147.048
M204 S8000
G1 X188.374 Y116.427 E.0064
; LINE_WIDTH: 0.400909
G1 F10056.181
G1 X188.41 Y116.63 E.00582
; LINE_WIDTH: 0.363061
G1 F11245.065
G1 X188.43 Y116.785 E.00396
; LINE_WIDTH: 0.32673
G1 F12684.573
G1 X188.447 Y116.923 E.00311
; LINE_WIDTH: 0.288289
G1 F14671.778
G1 X188.468 Y117.198 E.00534
; LINE_WIDTH: 0.258934
G1 F15000
G1 X188.468 Y117.796 E.01021
; LINE_WIDTH: 0.289666
G1 F14589.931
G1 X188.445 Y118.096 E.00587
; LINE_WIDTH: 0.332443
G1 F12434.247
G1 X188.426 Y118.248 E.0035
; LINE_WIDTH: 0.370302
G1 F10996.357
G1 X188.408 Y118.386 E.0036
; LINE_WIDTH: 0.407185
G1 F9882.938
G1 X188.372 Y118.589 E.00592
; LINE_WIDTH: 0.438965
G1 F9089.889
G1 X188.338 Y118.775 E.00592
M204 S10000
G1 X187.845 Y119.034 F60000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42006
G1 F9545.527
M204 S8000
G1 X188.451 Y119.639 E.0255
G1 X188.451 Y120.173 E.01589
G1 X187.732 Y119.454 E.03027
G1 X187.465 Y119.72 E.01124
G1 X188.451 Y120.706 E.04154
G1 X188.451 Y121.239 E.01589
G1 X187.157 Y119.945 E.05452
G3 X186.805 Y120.128 I-.794 J-1.101 E.01183
G1 X188.451 Y121.773 E.06932
G1 X188.451 Y122.306 E.01589
G1 X186.425 Y120.281 E.08534
G1 X185.982 Y120.371 E.01348
G1 X188.451 Y122.84 E.10402
G1 X188.451 Y123.373 E.01589
G1 X185.473 Y120.395 E.12546
G3 X184.842 Y120.297 I.126 J-2.901 E.01906
G1 X188.451 Y123.906 E.15204
G1 X188.451 Y124.44 E.01589
G1 X175.76 Y111.749 E.53466
G1 X176.294 Y111.749 E.01589
G1 X182.803 Y118.258 E.27422
G3 X182.705 Y117.627 I2.86 J-.767 E.01907
G1 X176.827 Y111.749 E.24763
G1 X177.36 Y111.749 E.01589
G1 X182.73 Y117.119 E.22621
G1 X182.819 Y116.674 E.0135
G1 X177.894 Y111.749 E.2075
G1 X178.427 Y111.749 E.01589
G1 X182.97 Y116.292 E.19141
G3 X183.153 Y115.942 I1.336 J.475 E.01181
G1 X178.961 Y111.749 E.17665
G1 X179.494 Y111.749 E.01589
G1 X183.38 Y115.635 E.16372
G3 X183.642 Y115.364 I1.448 J1.135 E.01126
G1 X180.027 Y111.749 E.15228
G1 X180.561 Y111.749 E.01589
G1 X183.943 Y115.132 E.14252
G3 X184.269 Y114.924 I.887 J1.03 E.01154
G1 X181.094 Y111.749 E.13376
G1 X181.627 Y111.749 E.01589
G1 X184.643 Y114.765 E.12704
G3 X185.071 Y114.659 I.571 J1.4 E.01318
G1 X182.161 Y111.749 E.1226
G1 X182.694 Y111.749 E.01589
G1 X185.556 Y114.611 E.12057
G3 X186.126 Y114.648 I.163 J1.937 E.01707
G1 X183.227 Y111.749 E.1221
G1 X183.761 Y111.749 E.01589
G1 X186.938 Y114.926 E.13386
G1 X187.425 Y115.244 E.01731
G3 X188.035 Y115.94 I-1.789 J2.182 E.0277
G1 X188.417 Y115.872 E.01158
G1 X184.294 Y111.749 E.17371
G1 X184.827 Y111.749 E.01589
G1 X188.451 Y115.373 E.15265
G1 X188.451 Y114.839 E.01589
G1 X185.361 Y111.749 E.13018
G1 X185.894 Y111.749 E.01589
G1 X188.451 Y114.306 E.10771
G1 X188.451 Y113.772 E.01589
G1 X186.428 Y111.749 E.08524
G1 X186.961 Y111.749 E.01589
G1 X188.451 Y113.239 E.06277
G1 X188.451 Y112.706 E.01589
G1 X187.494 Y111.749 E.04029
G1 X188.028 Y111.749 E.01589
G1 X188.62 Y112.342 E.02497
; CHANGE_LAYER
; Z_HEIGHT: 1.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9545.527
G1 X188.028 Y111.749 E-.31853
G1 X187.494 Y111.749 E-.20268
G1 X187.939 Y112.194 E-.23879
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 6/10
; update layer progress
M73 L6
M991 S0 P5 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z1.4 I-.794 J-.922 P1  F60000
G1 X184.419 Y115.223 Z1.4
G1 Z1.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X184.593 Y115.138 E.00623
G3 X185.327 Y114.947 I1.006 J2.361 E.02448
G1 X185.569 Y114.932 E.00782
G3 X184.355 Y115.254 I.029 J2.566 E.47769
G1 X184.365 Y115.249 E.00034
; COOLING_NODE: 0
M204 S10000
G1 X184.632 Y115.576 F60000
G1 F8843.478
M204 S8000
G1 X184.943 Y115.442 E.01092
G3 X185.371 Y115.352 I.655 J2.057 E.01406
G1 X185.574 Y115.34 E.00655
G3 X184.553 Y115.61 I.025 J2.159 E.40188
G1 X184.577 Y115.6 E.00084
; COOLING_NODE: 0
M204 S10000
G1 X184.792 Y115.949 F60000
G1 F8843.478
M204 S8000
G1 X185.067 Y115.83 E.00962
G3 X185.415 Y115.757 I.532 J1.669 E.01144
G1 X185.578 Y115.747 E.00528
G3 X184.738 Y115.974 I.021 J1.752 E.32562
; COOLING_NODE: 0
M204 S250
G1 X184.947 Y116.308 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X185.186 Y116.204 E.00775
G3 X185.457 Y116.147 I.414 J1.295 E.00826
G1 X185.583 Y116.14 E.00376
G3 X184.895 Y116.337 I.017 J1.359 E.23283
; COOLING_NODE: 0
; WIPE_START
M204 S8000
G1 X185.186 Y116.204 E-.12158
G1 X185.457 Y116.147 E-.10522
G1 X185.583 Y116.14 E-.04792
G1 X185.859 Y116.165 E-.10523
G1 X186.108 Y116.238 E-.09903
G1 X186.34 Y116.359 E-.09917
G1 X186.545 Y116.522 E-.09949
G1 X186.686 Y116.686 E-.08236
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X184.75 Y124.069 Z1.6 F60000
G1 X167.184 Y191.084 Z1.6
G1 Z1.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X167.184 Y203.237 E.39079
G1 X166.96 Y203.255 E.00723
G2 X166.87 Y204.204 I-2.556 J.236 E.48775
G2 X166.955 Y203.739 I-2.17 J-.637 E.01522
G1 X167.184 Y203.754 E.00739
G1 X167.184 Y208.584 E.15532
G1 X161.216 Y208.584 E.1919
G1 X161.216 Y116.116 E2.97342
G1 X167.216 Y116.116 E.19294
G1 X167.216 Y111.416 E.15113
G1 X188.784 Y111.416 E.69354
G1 X188.784 Y191.084 E2.56182
G1 X167.244 Y191.084 E.69265
; COOLING_NODE: 0
; WIPE_START
G1 X167.234 Y193.084 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X165.509 Y200.519 Z1.6 F60000
G1 X165.275 Y201.531 Z1.6
G1 Z1.2
G1 E.8 F1800
G1 F8843.478
M204 S8000
G1 X165.573 Y201.687 E.01084
G3 X164.17 Y201.352 I-1.175 J1.811 E.3889
G1 X164.374 Y201.34 E.00656
G3 X165.206 Y201.496 I.025 J2.159 E.02741
G1 X165.221 Y201.504 E.00054
; COOLING_NODE: 0
M204 S10000
G1 X165.088 Y201.891 F60000
G1 F8843.478
M204 S8000
G1 X165.353 Y202.03 E.0096
G3 X164.214 Y201.757 I-.953 J1.469 E.31553
G1 X164.378 Y201.747 E.00528
G3 X165.034 Y201.866 I.021 J1.752 E.02155
; COOLING_NODE: 1
M204 S250
G1 X164.909 Y202.239 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G3 X164.257 Y202.147 I-.509 J1.26 E.23459
G1 X164.383 Y202.14 E.00376
G3 X164.853 Y202.218 I.017 J1.359 E.01427
; COOLING_NODE: 1
; WIPE_START
M204 S8000
G1 X165.14 Y202.359 E-.12167
G1 X165.345 Y202.522 E-.09948
G1 X165.515 Y202.72 E-.09916
G1 X165.645 Y202.953 E-.10131
G1 X165.73 Y203.216 E-.10532
G1 X165.76 Y203.475 E-.09891
G1 X165.74 Y203.736 E-.09965
G1 X165.715 Y203.824 E-.0345
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X166.863 Y196.278 Z1.6 F60000
G1 X167.591 Y191.491 Z1.6
G1 Z1.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X167.591 Y208.991 E.56274
G1 X160.809 Y208.991 E.21808
G1 X160.809 Y115.709 E2.9996
G1 X166.809 Y115.709 E.19294
G1 X166.809 Y111.009 E.15113
G1 X189.191 Y111.009 E.71972
G1 X189.191 Y191.491 E2.588
G1 X167.651 Y191.491 E.69265
; COOLING_NODE: 1
M204 S10000
G1 X167.998 Y191.898 F60000
G1 F8843.478
M204 S8000
G1 X167.998 Y209.398 E.56274
G1 X160.402 Y209.398 E.24426
G1 X160.402 Y115.302 E3.02578
G1 X166.402 Y115.302 E.19294
G1 X166.402 Y110.602 E.15113
G1 X189.598 Y110.602 E.7459
G1 X189.598 Y191.898 E2.61418
G1 X168.058 Y191.898 E.69265
; COOLING_NODE: 2
M204 S250
G1 X168.39 Y192.29 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
M73 P71 R4
G1 X168.39 Y209.79 E.52127
G1 X160.01 Y209.79 E.24961
G1 X160.01 Y114.91 E2.82615
G1 X166.01 Y114.91 E.17872
G1 X166.01 Y110.21 E.14
G1 X189.99 Y110.21 E.71428
G1 X189.99 Y192.29 E2.44488
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

G1 X168.45 Y192.29 E.6416
; WIPE_START
M204 S8000
G1 X168.443 Y194.29 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X161.38 Y196.046 Z1.6 F60000
G1 Z1.2
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42037
G1 F9537.687
M204 S8000
G1 X188.451 Y168.975 E1.14147
G1 X188.451 Y168.441 E.01592
G1 X161.549 Y195.343 E1.13432
G1 X161.549 Y194.809 E.01592
G1 X188.451 Y167.908 E1.13432
G1 X188.451 Y167.374 E.01592
G1 X161.549 Y194.275 E1.13432
G1 X161.549 Y193.741 E.01592
G1 X188.451 Y166.84 E1.13432
G1 X188.451 Y166.306 E.01592
G1 X161.549 Y193.207 E1.13432
G1 X161.549 Y192.674 E.01592
G1 X188.451 Y165.772 E1.13432
G1 X188.451 Y165.239 E.01592
G1 X161.549 Y192.14 E1.13432
G1 X161.549 Y191.606 E.01592
G1 X188.451 Y164.705 E1.13432
G1 X188.451 Y164.171 E.01592
G1 X161.549 Y191.072 E1.13432
G1 X161.549 Y190.538 E.01592
G1 X188.451 Y163.637 E1.13432
G1 X188.451 Y163.103 E.01592
G1 X161.549 Y190.005 E1.13432
G1 X161.549 Y189.471 E.01592
G1 X188.451 Y162.57 E1.13432
G1 X188.451 Y162.036 E.01592
G1 X161.549 Y188.937 E1.13432
G1 X161.549 Y188.403 E.01592
G1 X188.451 Y161.502 E1.13432
G1 X188.451 Y160.968 E.01592
G1 X161.549 Y187.87 E1.13432
G1 X161.549 Y187.336 E.01592
G1 X188.451 Y160.434 E1.13432
G1 X188.451 Y159.901 E.01592
G1 X161.549 Y186.802 E1.13432
G1 X161.549 Y186.268 E.01592
G1 X188.451 Y159.367 E1.13432
G1 X188.451 Y158.833 E.01592
G1 X161.549 Y185.734 E1.13432
G1 X161.549 Y185.201 E.01592
G1 X188.451 Y158.299 E1.13432
G1 X188.451 Y157.765 E.01592
G1 X161.549 Y184.667 E1.13432
G1 X161.549 Y184.133 E.01592
G1 X188.451 Y157.232 E1.13432
G1 X188.451 Y156.698 E.01592
G1 X161.549 Y183.599 E1.13432
G1 X161.549 Y183.065 E.01592
G1 X188.451 Y156.164 E1.13432
G1 X188.451 Y155.63 E.01592
G1 X161.549 Y182.532 E1.13432
G1 X161.549 Y181.998 E.01592
G1 X188.451 Y155.096 E1.13432
G1 X188.451 Y154.563 E.01592
G1 X161.549 Y181.464 E1.13432
G1 X161.549 Y180.93 E.01592
G1 X188.451 Y154.029 E1.13432
G1 X188.451 Y153.495 E.01592
M73 P72 R4
G1 X161.549 Y180.396 E1.13432
G1 X161.549 Y179.863 E.01592
G1 X188.451 Y152.961 E1.13432
G1 X188.451 Y152.428 E.01592
G1 X161.549 Y179.329 E1.13432
G1 X161.549 Y178.795 E.01592
G1 X188.451 Y151.894 E1.13432
G1 X188.451 Y151.36 E.01592
G1 X161.549 Y178.261 E1.13432
G1 X161.549 Y177.727 E.01592
G1 X188.451 Y150.826 E1.13432
G1 X188.451 Y150.292 E.01592
G1 X161.549 Y177.194 E1.13432
G1 X161.549 Y176.66 E.01592
G1 X188.451 Y149.759 E1.13432
G1 X188.451 Y149.225 E.01592
G1 X161.549 Y176.126 E1.13432
G1 X161.549 Y175.592 E.01592
G1 X188.451 Y148.691 E1.13432
G1 X188.451 Y148.157 E.01592
G1 X161.549 Y175.058 E1.13432
G1 X161.549 Y174.525 E.01592
G1 X188.451 Y147.623 E1.13432
G1 X188.451 Y147.09 E.01592
G1 X161.549 Y173.991 E1.13432
G1 X161.549 Y173.457 E.01592
G1 X188.451 Y146.556 E1.13432
G1 X188.451 Y146.022 E.01592
G1 X161.549 Y172.923 E1.13432
G1 X161.549 Y172.389 E.01592
G1 X188.451 Y145.488 E1.13432
G1 X188.451 Y144.954 E.01592
G1 X161.549 Y171.856 E1.13432
G1 X161.549 Y171.322 E.01592
G1 X188.451 Y144.421 E1.13432
G1 X188.451 Y143.887 E.01592
G1 X161.549 Y170.788 E1.13432
G1 X161.549 Y170.254 E.01592
G1 X188.451 Y143.353 E1.13432
G1 X188.451 Y142.819 E.01592
G1 X161.549 Y169.72 E1.13432
G1 X161.549 Y169.187 E.01592
G1 X188.451 Y142.285 E1.13432
G1 X188.451 Y141.752 E.01592
G1 X161.549 Y168.653 E1.13432
G1 X161.549 Y168.119 E.01592
G1 X188.451 Y141.218 E1.13432
G1 X188.451 Y140.684 E.01592
G1 X161.549 Y167.585 E1.13432
G1 X161.549 Y167.052 E.01592
G1 X188.451 Y140.15 E1.13432
G1 X188.451 Y139.616 E.01592
G1 X161.549 Y166.518 E1.13432
G1 X161.549 Y165.984 E.01592
G1 X188.451 Y139.083 E1.13432
G1 X188.451 Y138.549 E.01592
G1 X161.549 Y165.45 E1.13432
G1 X161.549 Y164.916 E.01592
G1 X188.451 Y138.015 E1.13432
G1 X188.451 Y137.481 E.01592
G1 X161.549 Y164.383 E1.13432
G1 X161.549 Y163.849 E.01592
G1 X188.451 Y136.947 E1.13432
G1 X188.451 Y136.414 E.01592
G1 X161.549 Y163.315 E1.13432
G1 X161.549 Y162.781 E.01592
G1 X188.451 Y135.88 E1.13432
G1 X188.451 Y135.346 E.01592
G1 X161.549 Y162.247 E1.13432
G1 X161.549 Y161.714 E.01592
G1 X188.451 Y134.812 E1.13432
G1 X188.451 Y134.278 E.01592
G1 X161.549 Y161.18 E1.13432
M73 P73 R4
G1 X161.549 Y160.646 E.01592
G1 X188.451 Y133.745 E1.13432
G1 X188.451 Y133.211 E.01592
G1 X161.549 Y160.112 E1.13432
G1 X161.549 Y159.578 E.01592
G1 X188.451 Y132.677 E1.13432
G1 X188.451 Y132.143 E.01592
G1 X161.549 Y159.045 E1.13432
G1 X161.549 Y158.511 E.01592
G1 X188.451 Y131.61 E1.13432
G1 X188.451 Y131.076 E.01592
G1 X161.549 Y157.977 E1.13432
G1 X161.549 Y157.443 E.01592
G1 X188.451 Y130.542 E1.13432
G1 X188.451 Y130.008 E.01592
G1 X161.549 Y156.909 E1.13432
G1 X161.549 Y156.376 E.01592
G1 X188.451 Y129.474 E1.13432
G1 X188.451 Y128.941 E.01592
G1 X161.549 Y155.842 E1.13432
G1 X161.549 Y155.308 E.01592
G1 X188.451 Y128.407 E1.13432
G1 X188.451 Y127.873 E.01592
G1 X161.549 Y154.774 E1.13432
G1 X161.549 Y154.24 E.01592
G1 X188.451 Y127.339 E1.13432
G1 X188.451 Y126.805 E.01592
G1 X161.549 Y153.707 E1.13432
G1 X161.549 Y153.173 E.01592
G1 X188.451 Y126.272 E1.13432
G1 X188.451 Y125.738 E.01592
G1 X161.549 Y152.639 E1.13432
G1 X161.549 Y152.105 E.01592
G1 X188.451 Y125.204 E1.13432
G1 X188.451 Y124.67 E.01592
G1 X161.549 Y151.571 E1.13432
G1 X161.549 Y151.038 E.01592
G1 X188.451 Y124.136 E1.13432
G1 X188.451 Y123.603 E.01592
G1 X161.549 Y150.504 E1.13432
G1 X161.549 Y149.97 E.01592
G1 X188.451 Y123.069 E1.13432
G1 X188.451 Y122.535 E.01592
G1 X161.549 Y149.436 E1.13432
G1 X161.549 Y148.902 E.01592
G1 X188.451 Y122.001 E1.13432
G1 X188.451 Y121.467 E.01592
G1 X161.549 Y148.369 E1.13432
G1 X161.549 Y147.835 E.01592
G1 X188.451 Y120.934 E1.13432
G1 X188.451 Y120.4 E.01592
G1 X161.549 Y147.301 E1.13432
G1 X161.549 Y146.767 E.01592
G1 X188.451 Y119.866 E1.13432
G1 X188.451 Y119.332 E.01592
G1 X161.549 Y146.234 E1.13432
G1 X161.549 Y145.7 E.01592
G1 X188 Y119.249 E1.11534
G1 X187.964 Y119.177 E.00241
G1 X187.872 Y119.305 E.00472
G1 X187.504 Y119.69 E.01587
G3 X186.442 Y120.273 I-1.871 J-2.148 E.03638
G1 X161.549 Y145.166 E1.04964
G1 X161.549 Y144.632 E.01592
G1 X185.796 Y120.385 E1.02239
G3 X185.269 Y120.379 I-.242 J-1.796 E.01578
G1 X161.549 Y144.098 E1.00015
G1 X161.549 Y143.565 E.01592
G1 X184.82 Y120.294 E.98123
G1 X184.434 Y120.146 E.01232
G1 X161.549 Y143.031 E.96496
G1 X161.549 Y142.497 E.01592
G1 X184.079 Y119.968 E.94997
G3 X183.766 Y119.747 I2.446 J-3.802 E.01142
G1 X161.549 Y141.963 E.93677
G1 X161.549 Y141.429 E.01592
G1 X183.496 Y119.483 E.92538
G3 X183.255 Y119.19 I.658 J-.787 E.01137
M73 P74 R4
G1 X161.549 Y140.896 E.91523
G1 X161.549 Y140.362 E.01592
G1 X183.044 Y118.867 E.90635
G3 X182.879 Y118.498 I1.667 J-.967 E.01207
G1 X161.549 Y139.828 E.89939
G1 X161.549 Y139.294 E.01592
G1 X182.768 Y118.075 E.89472
G3 X182.712 Y117.597 I1.183 J-.38 E.01444
G1 X161.549 Y138.76 E.89236
G1 X161.549 Y138.227 E.01592
G1 X182.75 Y117.026 E.89394
G1 X182.798 Y116.742 E.0086
G1 X182.978 Y116.264 E.01522
G1 X161.549 Y137.693 E.90356
G1 X161.549 Y137.159 E.01592
G1 X186.959 Y111.749 E1.07142
G1 X187.493 Y111.749 E.01592
G1 X184.363 Y114.879 E.13198
G3 X185.136 Y114.64 I1.072 J2.092 E.02427
G1 X188.027 Y111.749 E.12187
G1 X188.451 Y111.749 E.01264
G1 X188.451 Y111.859 E.00327
G1 X185.7 Y114.61 E.11599
G3 X186.175 Y114.668 I.09 J1.233 E.01437
G1 X188.451 Y112.393 E.09595
G1 X188.451 Y112.927 E.01592
G1 X186.592 Y114.785 E.07837
G1 X186.967 Y114.944 E.01214
G1 X188.451 Y113.461 E.06257
G1 X188.451 Y113.994 E.01592
G1 X187.292 Y115.153 E.04885
G3 X187.589 Y115.39 I-.657 J1.129 E.01137
G1 X188.451 Y114.528 E.03633
G1 X188.451 Y115.062 E.01592
G1 X187.845 Y115.667 E.02552
G1 X188.036 Y115.941 E.00995
G1 X188.121 Y115.925 E.00258
G1 X188.62 Y115.426 E.02104
M204 S10000
G1 X188.336 Y116.224 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.441405
G1 F9034.225
M204 S8000
G1 X188.369 Y116.4 E.00562
; LINE_WIDTH: 0.412574
G1 F9738.85
G1 X188.404 Y116.593 E.00573
; LINE_WIDTH: 0.377141
G1 F10771.336
G1 X188.422 Y116.724 E.00349
; LINE_WIDTH: 0.340054
G1 F12115.777
G1 X188.441 Y116.868 E.00342
; LINE_WIDTH: 0.296284
G1 F14208.822
G1 X188.466 Y117.157 E.0058
; LINE_WIDTH: 0.26548
G1 F15000
G1 X188.472 Y117.712 E.00976
G1 X188.453 Y118.011 E.00526
; LINE_WIDTH: 0.312996
G1 F13329.607
G1 X188.437 Y118.153 E.00305
; LINE_WIDTH: 0.347237
G1 F11829.795
G1 X188.419 Y118.311 E.00383
; LINE_WIDTH: 0.387525
G1 F10446.746
G1 X188.397 Y118.442 E.00362
; LINE_WIDTH: 0.433457
G1 F9218.096
G1 X188.376 Y118.573 E.0041
G1 X188.102 Y118.712 E.00946
; WIPE_START
G1 X188.376 Y118.573 E-.53035
G1 X188.397 Y118.442 E-.22965
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X181.089 Y116.241 Z1.6 F60000
G1 X167.38 Y112.112 Z1.6
G1 Z1.2
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42037
G1 F9537.687
M204 S8000
G1 X167.742 Y111.749 E.01529
G1 X168.276 Y111.749 E.01592
G1 X167.549 Y112.476 E.03065
G1 X167.549 Y113.01 E.01592
G1 X168.81 Y111.749 E.05316
G1 X169.344 Y111.749 E.01592
G1 X167.549 Y113.544 E.07566
G1 X167.549 Y114.078 E.01592
G1 X169.878 Y111.749 E.09817
G1 X170.411 Y111.749 E.01592
G1 X167.549 Y114.611 E.12068
G1 X167.549 Y115.145 E.01592
G1 X170.945 Y111.749 E.14319
G1 X171.479 Y111.749 E.01592
G1 X167.38 Y115.849 E.17285
; WIPE_START
G1 X168.794 Y114.434 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X161.595 Y116.969 Z1.6 F60000
G1 X161.38 Y117.044 Z1.6
G1 Z1.2
G1 E.8 F1800
G1 F9537.687
M204 S8000
G1 X161.975 Y116.449 E.02509
G1 X162.509 Y116.449 E.01592
G1 X161.549 Y117.409 E.04045
G1 X161.549 Y117.942 E.01592
G1 X163.042 Y116.449 E.06295
G1 X163.576 Y116.449 E.01592
G1 X161.549 Y118.476 E.08546
G1 X161.549 Y119.01 E.01592
G1 X164.11 Y116.449 E.10797
G1 X164.644 Y116.449 E.01592
G1 X161.549 Y119.544 E.13048
G1 X161.549 Y120.078 E.01592
G1 X165.178 Y116.449 E.15299
G1 X165.711 Y116.449 E.01592
G1 X161.549 Y120.611 E.17549
G1 X161.549 Y121.145 E.01592
G1 X166.245 Y116.449 E.198
G1 X166.779 Y116.449 E.01592
G1 X161.549 Y121.679 E.22051
G1 X161.549 Y122.213 E.01592
G1 X172.013 Y111.749 E.4412
G1 X172.547 Y111.749 E.01592
G1 X161.549 Y122.747 E.46371
G1 X161.549 Y123.28 E.01592
G1 X173.08 Y111.749 E.48622
G1 X173.614 Y111.749 E.01592
G1 X161.549 Y123.814 E.50872
G1 X161.549 Y124.348 E.01592
G1 X174.148 Y111.749 E.53123
G1 X174.682 Y111.749 E.01592
G1 X161.549 Y124.882 E.55374
G1 X161.549 Y125.416 E.01592
G1 X175.216 Y111.749 E.57625
G1 X175.749 Y111.749 E.01592
G1 X161.549 Y125.949 E.59875
G1 X161.549 Y126.483 E.01592
G1 X176.283 Y111.749 E.62126
G1 X176.817 Y111.749 E.01592
G1 X161.549 Y127.017 E.64377
G1 X161.549 Y127.551 E.01592
G1 X177.351 Y111.749 E.66628
G1 X177.884 Y111.749 E.01592
G1 X161.549 Y128.084 E.68879
G1 X161.549 Y128.618 E.01592
G1 X178.418 Y111.749 E.7113
G1 X178.952 Y111.749 E.01592
G1 X161.549 Y129.152 E.7338
G1 X161.549 Y129.686 E.01592
G1 X179.486 Y111.749 E.75631
G1 X180.02 Y111.749 E.01592
G1 X161.549 Y130.22 E.77882
G1 X161.549 Y130.753 E.01592
G1 X180.553 Y111.749 E.80133
G1 X181.087 Y111.749 E.01592
G1 X161.549 Y131.287 E.82384
G1 X161.549 Y131.821 E.01592
G1 X181.621 Y111.749 E.84634
G1 X182.155 Y111.749 E.01592
G1 X161.549 Y132.355 E.86885
G1 X161.549 Y132.889 E.01592
G1 X182.689 Y111.749 E.89136
G1 X183.222 Y111.749 E.01592
G1 X161.549 Y133.422 E.91387
G1 X161.549 Y133.956 E.01592
G1 X183.756 Y111.749 E.93637
G1 X184.29 Y111.749 E.01592
G1 X161.549 Y134.49 E.95888
G1 X161.549 Y135.024 E.01592
G1 X184.824 Y111.749 E.98139
G1 X185.358 Y111.749 E.01592
G1 X161.549 Y135.558 E1.0039
G1 X161.549 Y136.091 E.01592
G1 X185.891 Y111.749 E1.02641
G1 X186.425 Y111.749 E.01592
G1 X161.38 Y136.795 E1.05607
; WIPE_START
G1 X162.794 Y135.381 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X165.933 Y142.338 Z1.6 F60000
G1 X187.857 Y190.92 Z1.6
G1 Z1.2
G1 E.8 F1800
G1 F9537.687
M204 S8000
G1 X188.451 Y190.327 E.02502
G1 X188.451 Y189.793 E.01592
G1 X187.493 Y190.751 E.04037
G1 X186.959 Y190.751 E.01592
G1 X188.451 Y189.259 E.06288
G1 X188.451 Y188.726 E.01592
G1 X186.426 Y190.751 E.08539
G1 X185.892 Y190.751 E.01592
G1 X188.451 Y188.192 E.1079
G1 X188.451 Y187.658 E.01592
G1 X185.358 Y190.751 E.13041
G1 X184.824 Y190.751 E.01592
G1 X188.451 Y187.124 E.15291
G1 X188.451 Y186.59 E.01592
G1 X184.29 Y190.751 E.17542
G1 X183.757 Y190.751 E.01592
M73 P75 R4
G1 X188.451 Y186.057 E.19793
G1 X188.451 Y185.523 E.01592
G1 X183.223 Y190.751 E.22044
G1 X182.689 Y190.751 E.01592
G1 X188.451 Y184.989 E.24295
G1 X188.451 Y184.455 E.01592
G1 X182.155 Y190.751 E.26545
G1 X181.621 Y190.751 E.01592
G1 X188.451 Y183.921 E.28796
G1 X188.451 Y183.388 E.01592
G1 X181.088 Y190.751 E.31047
G1 X180.554 Y190.751 E.01592
G1 X188.451 Y182.854 E.33298
G1 X188.451 Y182.32 E.01592
G1 X180.02 Y190.751 E.35549
G1 X179.486 Y190.751 E.01592
G1 X188.451 Y181.786 E.37799
G1 X188.451 Y181.252 E.01592
G1 X178.952 Y190.751 E.4005
G1 X178.419 Y190.751 E.01592
G1 X188.451 Y180.719 E.42301
G1 X188.451 Y180.185 E.01592
G1 X177.885 Y190.751 E.44552
G1 X177.351 Y190.751 E.01592
G1 X188.451 Y179.651 E.46803
G1 X188.451 Y179.117 E.01592
G1 X176.817 Y190.751 E.49053
G1 X176.283 Y190.751 E.01592
G1 X188.451 Y178.583 E.51304
G1 X188.451 Y178.05 E.01592
G1 X175.75 Y190.751 E.53555
G1 X175.216 Y190.751 E.01592
G1 X188.451 Y177.516 E.55806
G1 X188.451 Y176.982 E.01592
G1 X174.682 Y190.751 E.58057
G1 X174.148 Y190.751 E.01592
G1 X188.451 Y176.448 E.60307
G1 X188.451 Y175.914 E.01592
G1 X173.614 Y190.751 E.62558
G1 X173.081 Y190.751 E.01592
G1 X188.451 Y175.381 E.64809
G1 X188.451 Y174.847 E.01592
G1 X172.547 Y190.751 E.6706
G1 X172.013 Y190.751 E.01592
G1 X188.451 Y174.313 E.6931
G1 X188.451 Y173.779 E.01592
G1 X171.479 Y190.751 E.71561
G1 X170.946 Y190.751 E.01592
G1 X188.451 Y173.246 E.73812
G1 X188.451 Y172.712 E.01592
G1 X170.412 Y190.751 E.76063
G1 X169.878 Y190.751 E.01592
G1 X188.451 Y172.178 E.78314
G1 X188.451 Y171.644 E.01592
G1 X169.344 Y190.751 E.80564
G1 X168.81 Y190.751 E.01592
G1 X188.451 Y171.11 E.82815
G1 X188.451 Y170.577 E.01592
G1 X168.277 Y190.751 E.85066
G1 X167.743 Y190.751 E.01592
G1 X188.451 Y170.043 E.87317
G1 X188.451 Y169.509 E.01592
G1 X167.209 Y190.751 E.89568
G1 X166.851 Y190.751 E.01068
G1 X166.851 Y191.109 E.01068
G1 X161.549 Y196.41 E.22353
G1 X161.549 Y196.944 E.01592
G1 X166.851 Y191.643 E.22353
G1 X166.851 Y192.177 E.01592
G1 X161.549 Y197.478 E.22353
G1 X161.549 Y198.012 E.01592
G1 X166.851 Y192.71 E.22353
G1 X166.851 Y193.244 E.01592
G1 X161.549 Y198.545 E.22353
G1 X161.549 Y199.079 E.01592
G1 X166.851 Y193.778 E.22353
G1 X166.851 Y194.312 E.01592
G1 X161.549 Y199.613 E.22353
G1 X161.549 Y200.147 E.01592
G1 X166.851 Y194.846 E.22353
G1 X166.851 Y195.379 E.01592
G1 X161.549 Y200.681 E.22353
G1 X161.549 Y201.214 E.01592
G1 X166.851 Y195.913 E.22353
G1 X166.851 Y196.447 E.01592
G1 X161.549 Y201.748 E.22353
G1 X161.549 Y201.859 E.0033
G1 X161.899 Y201.932 E.01066
G1 X166.851 Y196.981 E.20877
G1 X166.851 Y197.514 E.01592
G1 X163.662 Y200.703 E.13445
G3 X164.296 Y200.603 I.711 J2.446 E.01919
G1 X166.851 Y198.048 E.10772
G1 X166.851 Y198.582 E.01592
G1 X164.802 Y200.63 E.08637
G3 X165.242 Y200.725 I-.478 J3.284 E.01341
G1 X166.851 Y199.116 E.06785
G1 X166.851 Y199.65 E.01592
G1 X165.623 Y200.877 E.05175
G3 X165.972 Y201.062 I-.46 J1.291 E.01182
G1 X166.851 Y200.183 E.03703
G1 X166.851 Y200.717 E.01592
G1 X166.277 Y201.291 E.02421
G3 X166.548 Y201.554 I-1.138 J1.446 E.01128
G1 X167.02 Y201.081 E.01993
M204 S10000
G1 X166.762 Y202.01 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.108967
G1 F15000
M204 S8000
G1 X166.855 Y202.131 E.0008
; LINE_WIDTH: 0.13862
G1 X166.98 Y202.312 E.00167
; WIPE_START
G1 X166.855 Y202.131 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X167.387 Y203.493 Z1.6 F60000
G1 Z1.2
G1 E.8 F1800
; LINE_WIDTH: 0.152592
G1 F15000
M204 S8000
G1 X167.084 Y203.496 E.00263
; LINE_WIDTH: 0.115477
G1 X166.78 Y203.5 E.00174
; WIPE_START
G1 X167.084 Y203.496 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X166.98 Y204.661 Z1.6 F60000
G1 Z1.2
G1 E.8 F1800
; LINE_WIDTH: 0.119882
G1 F15000
M204 S8000
G1 X166.809 Y204.912 E.00185
M204 S10000
G1 X166.729 Y205.33 F60000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F9547.299
M204 S8000
G1 X166.319 Y205.753 E.01755
G1 X165.857 Y206.077 E.01682
G1 X165.396 Y206.282 E.01502
G1 X164.766 Y206.437 E.01933
G1 X164.204 Y206.454 E.01674
G1 X163.644 Y206.362 E.0169
G1 X163.117 Y206.167 E.01675
G1 X162.815 Y205.999 E.01029
G1 X162.36 Y205.644 E.01719
G3 X161.943 Y205.122 I24.875 J-20.308 E.01991
G1 X161.608 Y205.184 E.01013
G1 X161.608 Y208.192 E.0896
G1 X166.792 Y208.192 E.15439
G1 X166.792 Y205.397 E.08325
G1 X166.77 Y205.374 E.00095
M204 S10000
G1 X166.415 Y206.15 F60000
G1 F9547.299
M204 S8000
G3 X164.847 Y206.805 I-2.108 J-2.84 E.05112
G1 X164.213 Y206.83 E.01889
G1 X163.581 Y206.734 E.01904
G1 X162.984 Y206.52 E.01889
G1 X162.583 Y206.296 E.01368
G1 X162.128 Y205.941 E.01719
G1 X161.985 Y205.786 E.00627
G1 X161.985 Y207.815 E.06041
G1 X166.415 Y207.815 E.13193
G1 X166.415 Y206.21 E.04781
M204 S10000
G1 X166.011 Y206.866 F60000
; LINE_WIDTH: 0.4672
G1 F8484.962
M204 S8000
G1 X165.647 Y207.017 E.0132
; LINE_WIDTH: 0.436623
G1 F9143.96
G1 X165.284 Y207.082 E.01145
; LINE_WIDTH: 0.388948
G1 F10403.797
G1 X164.922 Y207.147 E.01007
; LINE_WIDTH: 0.364259
G1 F11203.119
G1 X164.221 Y207.171 E.01779
G1 X163.52 Y207.095 E.01791
; LINE_WIDTH: 0.419485
G1 F9560.102
G1 X163.291 Y207.037 E.00702
; LINE_WIDTH: 0.460975
G1 F8611.307
G1 X163.062 Y206.979 E.0078
; LINE_WIDTH: 0.502465
G1 F7833.836
G1 X162.833 Y206.921 E.00857
; LINE_WIDTH: 0.535579
G1 F7307.291
G1 X162.422 Y206.741 E.01747
G1 X162.422 Y207.378 E.0248
; LINE_WIDTH: 0.520235
G1 F7542.189
G1 X162.706 Y207.397 E.01074
; LINE_WIDTH: 0.483105
G1 F8178.38
G1 X162.99 Y207.415 E.0099
; LINE_WIDTH: 0.445975
G1 F8931.784
G1 X163.275 Y207.434 E.00907
; LINE_WIDTH: 0.409035
G1 F9832.976
G1 X163.648 Y207.452 E.01081
; LINE_WIDTH: 0.359749
G1 F11362.615
G2 X164.751 Y207.471 I.747 J-11.378 E.02761
; LINE_WIDTH: 0.37071
G1 F10982.641
G1 X165.128 Y207.453 E.00978
; LINE_WIDTH: 0.40667
G1 F9896.907
G1 X165.505 Y207.435 E.01085
; LINE_WIDTH: 0.461353
G1 F8603.542
G1 X166.011 Y207.411 E.01673
G1 X166.011 Y206.926 E.01603
; WIPE_START
G1 X166.011 Y207.411 E-.37182
G1 X165.505 Y207.435 E-.38818
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X161.663 Y204.775 Z1.6 F60000
G1 Z1.2
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.440395
G1 F9057.191
M204 S8000
G1 X161.63 Y204.596 E.0057
; LINE_WIDTH: 0.412023
G1 F9753.387
G1 X161.597 Y204.417 E.0053
; LINE_WIDTH: 0.376086
G1 F10805.432
G1 X161.576 Y204.259 E.00421
; LINE_WIDTH: 0.336716
G1 F12253.405
G1 X161.557 Y204.118 E.00329
; LINE_WIDTH: 0.295323
G1 F14262.914
G1 X161.535 Y203.85 E.00537
; LINE_WIDTH: 0.264917
G1 F15000
G1 X161.524 Y203.553 E.0052
G1 X161.545 Y203.007 E.00958
; LINE_WIDTH: 0.309148
G1 F13522.272
G1 X161.561 Y202.864 E.00303
; LINE_WIDTH: 0.339464
G1 F12139.874
G1 X161.575 Y202.734 E.00308
; LINE_WIDTH: 0.376988
G1 F10776.276
G1 X161.599 Y202.585 E.00398
; LINE_WIDTH: 0.422015
G1 F9496.308
G1 X161.62 Y202.45 E.00407
; LINE_WIDTH: 0.451355
G1 F8814.14
G3 X161.667 Y202.224 I4.615 J.836 E.00747
; CHANGE_LAYER
; Z_HEIGHT: 1.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F8814.14
G1 X161.62 Y202.45 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 7/10
; update layer progress
M73 L7
M991 S0 P6 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z1.6 I1.178 J.306 P1  F60000
G1 X184.28 Y115.308 Z1.6
G1 Z1.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X184.381 Y115.238 E.00396
G3 X185.329 Y114.946 I1.216 J2.26 E.0321
G1 X185.585 Y114.932 E.00825
G3 X183.972 Y115.512 I.012 J2.566 E.46233
G1 X184.23 Y115.341 E.00995
; COOLING_NODE: 0
M204 S10000
G1 X184.506 Y115.645 F60000
G1 F8843.478
M204 S8000
G1 X184.575 Y115.597 E.00271
G3 X185.372 Y115.352 I1.023 J1.902 E.027
G1 X185.588 Y115.34 E.00695
G3 X184.231 Y115.828 I.01 J2.159 E.38895
G1 X184.456 Y115.678 E.00868
; COOLING_NODE: 0
M204 S10000
G1 X184.731 Y115.982 F60000
G1 F8843.478
M204 S8000
G1 X184.769 Y115.956 E.00146
G3 X185.416 Y115.757 I.83 J1.543 E.0219
G1 X185.591 Y115.747 E.00565
G3 X184.49 Y116.143 I.008 J1.752 E.31558
G1 X184.682 Y116.015 E.00741
; COOLING_NODE: 0
M204 S250
G1 X184.949 Y116.307 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X184.956 Y116.302 E.00025
G3 X185.457 Y116.147 I.644 J1.197 E.01573
G1 X185.594 Y116.14 E.00407
G3 X184.739 Y116.447 I.006 J1.359 E.22686
G1 X184.899 Y116.34 E.00573
; COOLING_NODE: 0
; WIPE_START
M204 S8000
G1 X184.956 Y116.302 E-.02602
G1 X185.201 Y116.2 E-.10102
G1 X185.457 Y116.147 E-.0993
G1 X185.594 Y116.14 E-.05194
G1 X185.859 Y116.165 E-.10137
G1 X186.11 Y116.239 E-.09949
G1 X186.355 Y116.369 E-.10537
G1 X186.562 Y116.538 E-.10152
G1 X186.686 Y116.688 E-.07397
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X184.75 Y124.071 Z1.8 F60000
G1 X167.184 Y191.084 Z1.8
G1 Z1.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X167.184 Y203.247 E.39111
G1 X166.957 Y203.263 E.00732
G2 X166.958 Y203.74 I-2.556 J.244 E.50328
G1 X167.184 Y203.757 E.00729
G1 X167.184 Y208.584 E.15521
G1 X161.216 Y208.584 E.1919
G1 X161.216 Y116.116 E2.97342
G1 X167.216 Y116.116 E.19294
G1 X167.216 Y111.416 E.15113
G1 X188.784 Y111.416 E.69354
M73 P75 R3
G1 X188.784 Y191.084 E2.56182
G1 X167.244 Y191.084 E.69265
; COOLING_NODE: 0
; WIPE_START
G1 X167.234 Y193.084 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
M73 P76 R3
G1 X165.516 Y200.52 Z1.8 F60000
G1 X165.281 Y201.535 Z1.8
G1 Z1.4
G1 E.8 F1800
G1 F8843.478
M204 S8000
G1 X165.597 Y201.704 E.01153
G3 X164.172 Y201.352 I-1.2 J1.795 E.38808
G1 X164.388 Y201.34 E.00695
G3 X165.209 Y201.498 I.01 J2.159 E.02704
G1 X165.228 Y201.508 E.00069
; COOLING_NODE: 0
M204 S10000
G1 X165.092 Y201.893 F60000
G1 F8843.478
M204 S8000
G1 X165.372 Y202.043 E.01022
G3 X164.216 Y201.757 I-.973 J1.456 E.31485
G1 X164.391 Y201.747 E.00565
G3 X165.037 Y201.868 I.008 J1.752 E.02127
; COOLING_NODE: 1
M204 S250
G1 X164.909 Y202.239 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G3 X164.257 Y202.147 I-.51 J1.26 E.23462
G1 X164.394 Y202.14 E.00407
G3 X164.853 Y202.218 I.006 J1.359 E.01396
; COOLING_NODE: 1
; WIPE_START
M204 S8000
G1 X165.155 Y202.369 E-.12833
G1 X165.362 Y202.538 E-.10143
G1 X165.528 Y202.74 E-.09936
G1 X165.653 Y202.97 E-.09932
G1 X165.701 Y203.102 E-.05363
G1 X165.754 Y203.375 E-.1057
G1 X165.753 Y203.641 E-.10118
G1 X165.716 Y203.825 E-.07105
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X166.863 Y196.279 Z1.8 F60000
G1 X167.591 Y191.491 Z1.8
G1 Z1.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X167.591 Y208.991 E.56274
G1 X160.809 Y208.991 E.21808
G1 X160.809 Y115.709 E2.9996
G1 X166.809 Y115.709 E.19294
G1 X166.809 Y111.009 E.15113
G1 X189.191 Y111.009 E.71972
G1 X189.191 Y191.491 E2.588
G1 X167.651 Y191.491 E.69265
; COOLING_NODE: 1
M204 S10000
G1 X167.998 Y191.898 F60000
G1 F8843.478
M204 S8000
G1 X167.998 Y209.398 E.56274
G1 X160.402 Y209.398 E.24426
G1 X160.402 Y115.302 E3.02578
G1 X166.402 Y115.302 E.19294
G1 X166.402 Y110.602 E.15113
G1 X189.598 Y110.602 E.7459
G1 X189.598 Y191.898 E2.61418
G1 X168.058 Y191.898 E.69265
; COOLING_NODE: 2
M204 S250
G1 X168.39 Y192.29 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X168.39 Y209.79 E.52127
G1 X160.01 Y209.79 E.24961
G1 X160.01 Y114.91 E2.82615
G1 X166.01 Y114.91 E.17872
G1 X166.01 Y110.21 E.14
G1 X189.99 Y110.21 E.71428
G1 X189.99 Y192.29 E2.44488
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

G1 X168.45 Y192.29 E.6416
; WIPE_START
M204 S8000
G1 X168.443 Y194.29 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X166.847 Y201.754 Z1.8 F60000
G1 X166.785 Y202.047 Z1.8
G1 Z1.4
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.10849
G1 F15000
M204 S8000
G1 X166.873 Y202.165 E.00077
; LINE_WIDTH: 0.134214
G1 X166.98 Y202.325 E.00139
; WIPE_START
G1 X166.873 Y202.165 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X166.825 Y203.501 Z1.8 F60000
G1 Z1.4
G1 E.8 F1800
; LINE_WIDTH: 0.114089
G1 F15000
M204 S8000
G1 X167.106 Y203.502 E.00158
; LINE_WIDTH: 0.148421
G1 X167.387 Y203.502 E.00234
; WIPE_START
G1 X167.106 Y203.502 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X166.98 Y204.681 Z1.8 F60000
G1 Z1.4
G1 E.8 F1800
; LINE_WIDTH: 0.139884
G1 F15000
M204 S8000
G1 X166.881 Y204.827 E.00135
; LINE_WIDTH: 0.112391
G1 X166.773 Y204.973 E.00099
M204 S10000
G1 X166.663 Y205.38 F60000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F9547.299
M204 S8000
G1 X166.318 Y205.753 E.01515
G1 X166.039 Y205.964 E.01042
G1 X165.542 Y206.23 E.01678
G1 X164.98 Y206.402 E.0175
G1 X164.415 Y206.46 E.01693
G1 X163.853 Y206.409 E.0168
G1 X163.277 Y206.238 E.0179
G1 X162.762 Y205.965 E.01737
G1 X162.321 Y205.607 E.01691
G1 X162.043 Y205.254 E.01338
G1 X161.92 Y205.336 E.0044
G1 X161.608 Y205.235 E.00977
G1 X161.608 Y208.192 E.08807
G1 X166.792 Y208.192 E.15439
G1 X166.792 Y205.436 E.08209
G1 X166.718 Y205.404 E.00239
M204 S10000
G1 X166.415 Y206.156 F60000
G1 F9547.299
M204 S8000
G1 X165.72 Y206.563 E.02398
G1 X165.089 Y206.764 E.01973
G1 X164.45 Y206.835 E.01913
G1 X163.816 Y206.784 E.01895
G1 X163.167 Y206.599 E.0201
G1 X162.583 Y206.297 E.01959
G1 X161.989 Y205.808 E.02291
G2 X161.985 Y207.815 I183.33 J1.337 E.05976
G1 X166.415 Y207.815 E.13193
G1 X166.415 Y206.216 E.04761
M204 S10000
G1 X166.011 Y206.864 F60000
; LINE_WIDTH: 0.47227
G1 F8384.767
M204 S8000
G1 X165.731 Y206.992 E.01044
; LINE_WIDTH: 0.45182
G1 F8804.108
G1 X165.462 Y207.051 E.00891
; LINE_WIDTH: 0.41146
G1 F9768.275
G1 X165.193 Y207.111 E.00803
; LINE_WIDTH: 0.363174
G1 F11241.094
G1 X164.483 Y207.173 E.01803
G1 X163.782 Y207.135 E.01776
; LINE_WIDTH: 0.388454
G1 F10418.676
G1 X163.538 Y207.085 E.0068
; LINE_WIDTH: 0.4234
G1 F9461.733
G1 X163.294 Y207.036 E.00748
; LINE_WIDTH: 0.458347
G1 F8665.789
G1 X163.05 Y206.986 E.00817
; LINE_WIDTH: 0.49246
G1 F8008.186
G1 X162.921 Y206.946 E.00479
; LINE_WIDTH: 0.54054
G1 F7234.441
G1 X162.792 Y206.907 E.00531
G1 X162.424 Y206.709 E.01643
G1 X162.424 Y207.376 E.02625
; LINE_WIDTH: 0.52574
G1 F7456.195
G1 X162.705 Y207.393 E.01076
; LINE_WIDTH: 0.49246
G1 F8008.186
G1 X162.987 Y207.41 E.01002
; LINE_WIDTH: 0.454905
G1 F8738.182
G1 X163.269 Y207.431 E.0092
; LINE_WIDTH: 0.413075
G1 F9725.656
G1 X163.551 Y207.452 E.00827
; LINE_WIDTH: 0.363313
G1 F11236.219
G2 X165.029 Y207.462 I.85 J-15.136 E.03742
; LINE_WIDTH: 0.387409
G1 F10450.282
G1 X165.284 Y207.445 E.00694
; LINE_WIDTH: 0.421245
G1 F9515.628
G1 X165.538 Y207.429 E.00763
; LINE_WIDTH: 0.467843
G1 F8472.137
G3 X166.011 Y207.411 I.368 J3.619 E.0159
G1 X166.011 Y206.924 E.01636
; WIPE_START
G1 X166.011 Y207.411 E-.38554
G1 X165.538 Y207.429 E-.37446
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X161.898 Y204.708 Z1.8 F60000
G1 Z1.4
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.371246
G1 F10964.735
M204 S8000
G1 X161.667 Y204.594 E.00669
; LINE_WIDTH: 0.428541
G1 F9335.608
G1 X161.625 Y204.572 E.00147
G1 X161.604 Y204.447 E.00384
; LINE_WIDTH: 0.390356
G1 F10361.633
G1 X161.583 Y204.323 E.00346
; LINE_WIDTH: 0.351863
G1 F11652.638
G1 X161.566 Y204.179 E.00353
; LINE_WIDTH: 0.319714
G1 F13006.081
G1 X161.551 Y204.051 E.00282
; LINE_WIDTH: 0.283865
G1 F14941.179
G1 X161.53 Y203.763 E.0055
; LINE_WIDTH: 0.257911
G1 F15000
G1 X161.531 Y203.221 E.00921
; LINE_WIDTH: 0.284744
G1 F14886.912
G1 X161.551 Y202.948 E.00522
; LINE_WIDTH: 0.323048
G1 F12851.289
G1 X161.569 Y202.793 E.00345
; LINE_WIDTH: 0.359461
G1 F11372.965
G1 X161.587 Y202.651 E.00358
; LINE_WIDTH: 0.398376
G1 F10127.855
G1 X161.625 Y202.43 E.00631
; LINE_WIDTH: 0.435838
G1 F9162.227
G1 X161.661 Y202.226 E.00643
M204 S10000
G1 X162.126 Y201.988 F60000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42136
G1 F9512.736
M204 S8000
G1 X161.549 Y201.411 E.02438
G1 X161.549 Y200.876 E.016
G1 X162.245 Y201.572 E.02942
G3 X162.517 Y201.308 I.82 J.573 E.01138
G1 X161.549 Y200.341 E.0409
G1 X161.549 Y199.806 E.016
G1 X162.816 Y201.072 E.05355
G1 X163.163 Y200.884 E.0118
G1 X161.549 Y199.27 E.06822
G1 X161.549 Y198.735 E.016
G1 X163.552 Y200.738 E.08467
G3 X163.982 Y200.632 I.566 J1.375 E.01327
G1 X161.549 Y198.2 E.10283
G1 X161.549 Y197.665 E.016
G1 X164.488 Y200.603 E.12422
G3 X165.12 Y200.7 I-.053 J2.448 E.01919
G1 X161.549 Y197.13 E.15096
G1 X161.549 Y196.594 E.016
G1 X166.147 Y201.192 E.19436
G1 X166.224 Y201.243 E.00278
G3 X166.679 Y201.711 I-1.958 J2.359 E.01953
G1 X166.851 Y201.583 E.0064
G1 X166.851 Y201.361 E.00665
G1 X161.549 Y196.059 E.22412
G1 X161.549 Y195.524 E.016
G1 X166.851 Y200.825 E.22412
G1 X166.851 Y200.29 E.016
G1 X161.549 Y194.989 E.22412
G1 X161.549 Y194.454 E.016
G1 X166.851 Y199.755 E.22412
G1 X166.851 Y199.22 E.016
G1 X161.549 Y193.918 E.22412
G1 X161.549 Y193.383 E.016
G1 X166.851 Y198.685 E.22412
G1 X166.851 Y198.149 E.016
G1 X161.549 Y192.848 E.22412
G1 X161.549 Y192.313 E.016
G1 X166.851 Y197.614 E.22412
G1 X166.851 Y197.079 E.016
G1 X161.549 Y191.778 E.22412
G1 X161.549 Y191.242 E.016
G1 X166.851 Y196.544 E.22412
G1 X166.851 Y196.009 E.016
G1 X161.549 Y190.707 E.22412
G1 X161.549 Y190.172 E.016
G1 X166.851 Y195.473 E.22412
G1 X166.851 Y194.938 E.016
G1 X161.549 Y189.637 E.22412
G1 X161.549 Y189.102 E.016
G1 X166.851 Y194.403 E.22412
G1 X166.851 Y193.868 E.016
G1 X161.549 Y188.567 E.22412
G1 X161.549 Y188.031 E.016
G1 X166.851 Y193.333 E.22412
G1 X166.851 Y192.797 E.016
G1 X161.549 Y187.496 E.22412
G1 X161.549 Y186.961 E.016
G1 X166.851 Y192.262 E.22412
G1 X166.851 Y191.727 E.016
G1 X161.549 Y186.426 E.22412
G1 X161.549 Y185.891 E.016
M73 P77 R3
G1 X166.851 Y191.192 E.22412
G1 X166.851 Y190.751 E.01319
G1 X166.945 Y190.751 E.00281
G1 X161.549 Y185.355 E.22809
G1 X161.549 Y184.82 E.016
G1 X167.48 Y190.751 E.25072
G1 X168.015 Y190.751 E.016
G1 X161.549 Y184.285 E.27335
G1 X161.549 Y183.75 E.016
G1 X168.55 Y190.751 E.29597
G1 X169.085 Y190.751 E.016
G1 X161.549 Y183.215 E.3186
G1 X161.549 Y182.679 E.016
G1 X169.621 Y190.751 E.34123
G1 X170.156 Y190.751 E.016
G1 X161.549 Y182.144 E.36385
G1 X161.549 Y181.609 E.016
G1 X170.691 Y190.751 E.38648
G1 X171.226 Y190.751 E.016
G1 X161.549 Y181.074 E.4091
G1 X161.549 Y180.539 E.016
G1 X171.761 Y190.751 E.43173
G1 X172.297 Y190.751 E.016
G1 X161.549 Y180.003 E.45436
G1 X161.549 Y179.468 E.016
G1 X172.832 Y190.751 E.47698
G1 X173.367 Y190.751 E.016
G1 X161.549 Y178.933 E.49961
G1 X161.549 Y178.398 E.016
G1 X173.902 Y190.751 E.52223
G1 X174.437 Y190.751 E.016
G1 X161.549 Y177.863 E.54486
G1 X161.549 Y177.327 E.016
G1 X174.973 Y190.751 E.56749
G1 X175.508 Y190.751 E.016
G1 X161.549 Y176.792 E.59011
G1 X161.549 Y176.257 E.016
G1 X176.043 Y190.751 E.61274
G1 X176.578 Y190.751 E.016
G1 X161.549 Y175.722 E.63537
G1 X161.549 Y175.187 E.016
G1 X177.113 Y190.751 E.65799
G1 X177.649 Y190.751 E.016
G1 X161.549 Y174.651 E.68062
G1 X161.549 Y174.116 E.016
G1 X178.184 Y190.751 E.70324
G1 X178.719 Y190.751 E.016
G1 X161.549 Y173.581 E.72587
G1 X161.549 Y173.046 E.016
G1 X179.254 Y190.751 E.7485
G1 X179.789 Y190.751 E.016
G1 X161.549 Y172.511 E.77112
G1 X161.549 Y171.975 E.016
G1 X180.325 Y190.751 E.79375
G1 X180.86 Y190.751 E.016
G1 X161.549 Y171.44 E.81638
G1 X161.549 Y170.905 E.016
G1 X181.395 Y190.751 E.839
G1 X181.93 Y190.751 E.016
G1 X161.549 Y170.37 E.86163
G1 X161.549 Y169.835 E.016
G1 X182.465 Y190.751 E.88425
G1 X183.001 Y190.751 E.016
G1 X161.549 Y169.3 E.90688
G1 X161.549 Y168.764 E.016
G1 X183.536 Y190.751 E.92951
G1 X184.071 Y190.751 E.016
G1 X161.549 Y168.229 E.95213
G1 X161.549 Y167.694 E.016
G1 X184.606 Y190.751 E.97476
G1 X185.141 Y190.751 E.016
G1 X161.549 Y167.159 E.99739
G1 X161.549 Y166.624 E.016
G1 X185.676 Y190.751 E1.02001
G1 X186.212 Y190.751 E.016
G1 X161.549 Y166.088 E1.04264
G1 X161.549 Y165.553 E.016
G1 X186.747 Y190.751 E1.06526
G1 X187.282 Y190.751 E.016
G1 X161.549 Y165.018 E1.08789
G1 X161.549 Y164.483 E.016
G1 X187.817 Y190.751 E1.11052
G1 X188.352 Y190.751 E.016
G1 X161.549 Y163.948 E1.13314
G1 X161.549 Y163.412 E.016
G1 X188.451 Y190.314 E1.13729
G1 X188.451 Y189.778 E.016
G1 X161.549 Y162.877 E1.13729
G1 X161.549 Y162.342 E.016
G1 X188.451 Y189.243 E1.13729
G1 X188.451 Y188.708 E.016
G1 X161.549 Y161.807 E1.13729
G1 X161.549 Y161.272 E.016
G1 X188.451 Y188.173 E1.13729
G1 X188.451 Y187.638 E.016
G1 X161.549 Y160.736 E1.13729
G1 X161.549 Y160.201 E.016
G1 X188.451 Y187.102 E1.13729
G1 X188.451 Y186.567 E.016
G1 X161.549 Y159.666 E1.13729
G1 X161.549 Y159.131 E.016
G1 X188.451 Y186.032 E1.13729
G1 X188.451 Y185.497 E.016
G1 X161.549 Y158.596 E1.13729
G1 X161.549 Y158.06 E.016
G1 X188.451 Y184.962 E1.13729
G1 X188.451 Y184.426 E.016
M73 P78 R3
G1 X161.549 Y157.525 E1.13729
G1 X161.549 Y156.99 E.016
G1 X188.451 Y183.891 E1.13729
G1 X188.451 Y183.356 E.016
G1 X161.549 Y156.455 E1.13729
G1 X161.549 Y155.92 E.016
G1 X188.451 Y182.821 E1.13729
G1 X188.451 Y182.286 E.016
G1 X161.549 Y155.384 E1.13729
G1 X161.549 Y154.849 E.016
G1 X188.451 Y181.751 E1.13729
G1 X188.451 Y181.215 E.016
G1 X161.549 Y154.314 E1.13729
G1 X161.549 Y153.779 E.016
G1 X188.451 Y180.68 E1.13729
G1 X188.451 Y180.145 E.016
G1 X161.549 Y153.244 E1.13729
G1 X161.549 Y152.708 E.016
G1 X188.451 Y179.61 E1.13729
G1 X188.451 Y179.075 E.016
G1 X161.549 Y152.173 E1.13729
G1 X161.549 Y151.638 E.016
G1 X188.451 Y178.539 E1.13729
G1 X188.451 Y178.004 E.016
G1 X161.549 Y151.103 E1.13729
G1 X161.549 Y150.568 E.016
G1 X188.451 Y177.469 E1.13729
G1 X188.451 Y176.934 E.016
G1 X161.549 Y150.032 E1.13729
G1 X161.549 Y149.497 E.016
G1 X188.451 Y176.399 E1.13729
G1 X188.451 Y175.863 E.016
G1 X161.549 Y148.962 E1.13729
G1 X161.549 Y148.427 E.016
G1 X188.451 Y175.328 E1.13729
G1 X188.451 Y174.793 E.016
G1 X161.549 Y147.892 E1.13729
G1 X161.549 Y147.357 E.016
G1 X188.451 Y174.258 E1.13729
G1 X188.451 Y173.723 E.016
G1 X161.549 Y146.821 E1.13729
G1 X161.549 Y146.286 E.016
G1 X188.451 Y173.187 E1.13729
G1 X188.451 Y172.652 E.016
G1 X161.549 Y145.751 E1.13729
G1 X161.549 Y145.216 E.016
G1 X188.451 Y172.117 E1.13729
G1 X188.451 Y171.582 E.016
G1 X161.549 Y144.681 E1.13729
G1 X161.549 Y144.145 E.016
G1 X188.451 Y171.047 E1.13729
G1 X188.451 Y170.511 E.016
G1 X161.549 Y143.61 E1.13729
G1 X161.549 Y143.075 E.016
G1 X188.451 Y169.976 E1.13729
G1 X188.451 Y169.441 E.016
G1 X161.549 Y142.54 E1.13729
G1 X161.549 Y142.005 E.016
G1 X188.451 Y168.906 E1.13729
G1 X188.451 Y168.371 E.016
G1 X161.549 Y141.469 E1.13729
G1 X161.549 Y140.934 E.016
G1 X188.451 Y167.835 E1.13729
G1 X188.451 Y167.3 E.016
G1 X161.549 Y140.399 E1.13729
G1 X161.549 Y139.864 E.016
G1 X188.451 Y166.765 E1.13729
G1 X188.451 Y166.23 E.016
G1 X161.549 Y139.329 E1.13729
G1 X161.549 Y138.793 E.016
G1 X188.451 Y165.695 E1.13729
G1 X188.451 Y165.159 E.016
M73 P79 R3
G1 X161.549 Y138.258 E1.13729
G1 X161.549 Y137.723 E.016
G1 X188.451 Y164.624 E1.13729
G1 X188.451 Y164.089 E.016
G1 X161.549 Y137.188 E1.13729
G1 X161.549 Y136.653 E.016
G1 X188.451 Y163.554 E1.13729
G1 X188.451 Y163.019 E.016
G1 X161.549 Y136.117 E1.13729
G1 X161.549 Y135.582 E.016
G1 X188.451 Y162.483 E1.13729
G1 X188.451 Y161.948 E.016
G1 X161.549 Y135.047 E1.13729
G1 X161.549 Y134.512 E.016
G1 X188.451 Y161.413 E1.13729
G1 X188.451 Y160.878 E.016
G1 X161.549 Y133.977 E1.13729
G1 X161.549 Y133.441 E.016
G1 X188.451 Y160.343 E1.13729
G1 X188.451 Y159.808 E.016
G1 X161.549 Y132.906 E1.13729
G1 X161.549 Y132.371 E.016
G1 X188.451 Y159.272 E1.13729
G1 X188.451 Y158.737 E.016
G1 X161.549 Y131.836 E1.13729
G1 X161.549 Y131.301 E.016
G1 X188.451 Y158.202 E1.13729
G1 X188.451 Y157.667 E.016
G1 X161.549 Y130.765 E1.13729
G1 X161.549 Y130.23 E.016
G1 X188.451 Y157.132 E1.13729
G1 X188.451 Y156.596 E.016
G1 X161.549 Y129.695 E1.13729
G1 X161.549 Y129.16 E.016
G1 X188.451 Y156.061 E1.13729
G1 X188.451 Y155.526 E.016
G1 X161.549 Y128.625 E1.13729
G1 X161.549 Y128.089 E.016
G1 X188.451 Y154.991 E1.13729
G1 X188.451 Y154.456 E.016
G1 X161.549 Y127.554 E1.13729
G1 X161.549 Y127.019 E.016
G1 X188.451 Y153.92 E1.13729
G1 X188.451 Y153.385 E.016
G1 X161.549 Y126.484 E1.13729
G1 X161.549 Y125.949 E.016
G1 X188.451 Y152.85 E1.13729
G1 X188.451 Y152.315 E.016
G1 X161.549 Y125.414 E1.13729
G1 X161.549 Y124.878 E.016
G1 X188.451 Y151.78 E1.13729
G1 X188.451 Y151.244 E.016
G1 X161.549 Y124.343 E1.13729
G1 X161.549 Y123.808 E.016
G1 X188.451 Y150.709 E1.13729
G1 X188.451 Y150.174 E.016
G1 X161.549 Y123.273 E1.13729
G1 X161.549 Y122.738 E.016
G1 X188.451 Y149.639 E1.13729
G1 X188.451 Y149.104 E.016
G1 X161.549 Y122.202 E1.13729
G1 X161.549 Y121.667 E.016
G1 X188.451 Y148.568 E1.13729
G1 X188.451 Y148.033 E.016
G1 X161.549 Y121.132 E1.13729
G1 X161.549 Y120.597 E.016
G1 X188.451 Y147.498 E1.13729
G1 X188.451 Y146.963 E.016
G1 X161.549 Y120.062 E1.13729
G1 X161.549 Y119.526 E.016
G1 X188.451 Y146.428 E1.13729
G1 X188.451 Y145.892 E.016
G1 X161.549 Y118.991 E1.13729
G1 X161.549 Y118.456 E.016
M73 P80 R3
G1 X188.451 Y145.357 E1.13729
G1 X188.451 Y144.822 E.016
G1 X161.549 Y117.921 E1.13729
G1 X161.549 Y117.386 E.016
G1 X188.451 Y144.287 E1.13729
G1 X188.451 Y143.752 E.016
G1 X161.549 Y116.85 E1.13729
G1 X161.549 Y116.449 E.01199
G1 X161.684 Y116.449 E.00401
G1 X188.451 Y143.216 E1.13162
G1 X188.451 Y142.681 E.016
G1 X162.219 Y116.449 E1.109
G1 X162.754 Y116.449 E.016
G1 X188.451 Y142.146 E1.08637
G1 X188.451 Y141.611 E.016
G1 X163.289 Y116.449 E1.06374
G1 X163.824 Y116.449 E.016
G1 X188.451 Y141.076 E1.04112
G1 X188.451 Y140.541 E.016
G1 X164.36 Y116.449 E1.01849
G1 X164.895 Y116.449 E.016
G1 X188.451 Y140.005 E.99586
G1 X188.451 Y139.47 E.016
G1 X165.43 Y116.449 E.97324
G1 X165.965 Y116.449 E.016
G1 X188.451 Y138.935 E.95061
G1 X188.451 Y138.4 E.016
G1 X166.5 Y116.449 E.92799
G1 X167.035 Y116.449 E.016
G1 X188.451 Y137.865 E.90536
G1 X188.451 Y137.329 E.016
G1 X167.549 Y116.428 E.88363
G1 X167.549 Y115.893 E.016
G1 X188.451 Y136.794 E.88363
G1 X188.451 Y136.259 E.016
G1 X167.549 Y115.358 E.88363
G1 X167.549 Y114.822 E.016
G1 X188.451 Y135.724 E.88363
G1 X188.451 Y135.189 E.016
G1 X167.549 Y114.287 E.88363
G1 X167.549 Y113.752 E.016
G1 X188.451 Y134.653 E.88363
G1 X188.451 Y134.118 E.016
G1 X167.549 Y113.217 E.88363
G1 X167.549 Y112.682 E.016
G1 X188.451 Y133.583 E.88363
G1 X188.451 Y133.048 E.016
G1 X167.549 Y112.146 E.88363
G1 X167.549 Y111.749 E.01187
G1 X167.687 Y111.749 E.00413
G1 X188.451 Y132.513 E.8778
G1 X188.451 Y131.977 E.016
G1 X168.223 Y111.749 E.85517
G1 X168.758 Y111.749 E.016
G1 X188.451 Y131.442 E.83254
G1 X188.451 Y130.907 E.016
G1 X169.293 Y111.749 E.80992
G1 X169.828 Y111.749 E.016
G1 X188.451 Y130.372 E.78729
G1 X188.451 Y129.837 E.016
G1 X170.363 Y111.749 E.76467
G1 X170.899 Y111.749 E.016
G1 X188.451 Y129.301 E.74204
G1 X188.451 Y128.766 E.016
G1 X171.434 Y111.749 E.71941
G1 X171.969 Y111.749 E.016
G1 X188.451 Y128.231 E.69679
G1 X188.451 Y127.696 E.016
G1 X172.504 Y111.749 E.67416
G1 X173.039 Y111.749 E.016
G1 X188.451 Y127.161 E.65154
G1 X188.451 Y126.625 E.016
G1 X173.575 Y111.749 E.62891
G1 X174.11 Y111.749 E.016
G1 X188.451 Y126.09 E.60628
G1 X188.451 Y125.555 E.016
G1 X174.645 Y111.749 E.58366
G1 X175.18 Y111.749 E.016
G1 X188.62 Y125.19 E.5682
; WIPE_START
G1 X187.206 Y123.775 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X188.339 Y116.227 Z1.8 F60000
G1 X188.339 Y116.226 Z1.8
G1 Z1.4
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.436148
G1 F9154.994
M204 S8000
G1 X188.375 Y116.428 E.0064
; LINE_WIDTH: 0.400444
G1 F10069.252
G1 X188.41 Y116.631 E.00582
; LINE_WIDTH: 0.361768
G1 F11290.669
G1 X188.431 Y116.794 E.00412
; LINE_WIDTH: 0.324028
G1 F12806.483
G1 X188.449 Y116.939 E.00324
; LINE_WIDTH: 0.285147
G1 F14862.12
G1 X188.469 Y117.227 E.00554
; LINE_WIDTH: 0.258403
G1 F15000
G1 X188.468 Y117.796 E.00968
; LINE_WIDTH: 0.289647
G1 F14591.053
G1 X188.445 Y118.096 E.00586
; LINE_WIDTH: 0.332422
G1 F12435.147
G1 X188.426 Y118.248 E.0035
; LINE_WIDTH: 0.370217
G1 F10999.18
G1 X188.408 Y118.386 E.00359
; LINE_WIDTH: 0.40706
G1 F9886.312
G1 X188.372 Y118.588 E.00592
; LINE_WIDTH: 0.438777
G1 F9094.194
G1 X188.338 Y118.774 E.00591
M204 S10000
G1 X187.841 Y119.059 F60000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42136
G1 F9512.736
M204 S8000
G1 X188.451 Y119.668 E.02576
G1 X188.451 Y120.203 E.016
G1 X187.717 Y119.469 E.03102
G1 X187.449 Y119.736 E.01131
G1 X188.451 Y120.738 E.04237
G1 X188.451 Y121.273 E.016
G1 X187.135 Y119.958 E.05561
G3 X186.78 Y120.138 I-.777 J-1.092 E.01195
G1 X188.451 Y121.809 E.07062
G1 X188.451 Y122.344 E.016
G1 X186.395 Y120.288 E.0869
G3 X185.949 Y120.377 I-.656 J-2.119 E.01362
G1 X188.451 Y122.879 E.10576
G1 X188.451 Y123.414 E.016
G1 X185.425 Y120.389 E.12791
G3 X184.784 Y120.283 I.101 J-2.614 E.01946
G1 X188.451 Y123.949 E.155
G1 X188.451 Y124.485 E.016
G1 X175.715 Y111.749 E.5384
G1 X176.251 Y111.749 E.016
G1 X182.818 Y118.316 E.27764
G1 X182.714 Y117.807 E.01555
G1 X182.707 Y117.671 E.00407
G1 X176.786 Y111.749 E.25034
G1 X177.321 Y111.749 E.016
G1 X182.723 Y117.152 E.22839
G1 X182.813 Y116.706 E.01359
G1 X177.856 Y111.749 E.20955
G1 X178.391 Y111.749 E.016
M73 P81 R3
G1 X182.962 Y116.32 E.19323
G3 X183.142 Y115.965 I1.281 J.426 E.01195
G1 X178.927 Y111.749 E.17821
G1 X179.462 Y111.749 E.016
G1 X183.364 Y115.652 E.16498
G1 X183.631 Y115.384 E.01131
G1 X179.997 Y111.749 E.15364
G1 X180.532 Y111.749 E.016
G1 X183.926 Y115.144 E.1435
G3 X184.251 Y114.933 I.895 J1.022 E.0116
G1 X181.067 Y111.749 E.13459
G1 X181.602 Y111.749 E.016
G1 X184.624 Y114.771 E.12776
G3 X185.052 Y114.663 I.58 J1.395 E.01322
G1 X182.138 Y111.749 E.12319
G1 X182.673 Y111.749 E.016
G1 X185.535 Y114.611 E.121
G3 X186.103 Y114.644 I.173 J1.931 E.01708
G1 X183.208 Y111.749 E.12239
G1 X183.743 Y111.749 E.016
G1 X186.905 Y114.911 E.13367
G1 X187.425 Y115.244 E.01844
G3 X188.034 Y115.941 I-1.754 J2.145 E.02781
G1 X188.405 Y115.876 E.01127
G1 X184.278 Y111.749 E.17444
G1 X184.814 Y111.749 E.016
G1 X188.451 Y115.386 E.15376
G1 X188.451 Y114.851 E.016
G1 X185.349 Y111.749 E.13113
G1 X185.884 Y111.749 E.016
G1 X188.451 Y114.316 E.10851
G1 X188.451 Y113.781 E.016
G1 X186.419 Y111.749 E.08588
G1 X186.954 Y111.749 E.016
G1 X188.451 Y113.246 E.06325
G1 X188.451 Y112.71 E.016
G1 X187.49 Y111.749 E.04063
G1 X188.025 Y111.749 E.016
G1 X188.62 Y112.345 E.02518
; CHANGE_LAYER
; Z_HEIGHT: 1.6
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9512.736
G1 X188.025 Y111.749 E-.32001
G1 X187.49 Y111.749 E-.20337
G1 X187.93 Y112.19 E-.23662
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 8/10
; update layer progress
M73 L8
M991 S0 P7 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z1.8 I-.796 J-.921 P1  F60000
G1 X184.418 Y115.223 Z1.8
G1 Z1.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X184.593 Y115.138 E.00624
G3 X185.327 Y114.947 I1.006 J2.361 E.02448
G1 X185.569 Y114.932 E.00782
G3 X184.355 Y115.254 I.029 J2.566 E.47769
G1 X184.364 Y115.249 E.00034
; COOLING_NODE: 0
M204 S10000
G1 X184.633 Y115.576 F60000
G1 F8843.478
M204 S8000
G1 X184.943 Y115.442 E.01089
G3 X185.371 Y115.352 I.655 J2.057 E.01406
G1 X185.574 Y115.34 E.00655
G3 X184.553 Y115.61 I.025 J2.159 E.40188
G1 X184.577 Y115.6 E.00087
; COOLING_NODE: 0
M204 S10000
G1 X184.793 Y115.948 F60000
G1 F8843.478
M204 S8000
G1 X185.067 Y115.83 E.0096
G3 X185.415 Y115.757 I.532 J1.669 E.01144
G1 X185.578 Y115.747 E.00528
G3 X184.738 Y115.973 I.021 J1.752 E.32564
; COOLING_NODE: 0
M204 S250
G1 X184.948 Y116.307 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X185.186 Y116.204 E.00773
G3 X185.457 Y116.147 I.414 J1.295 E.00826
G1 X185.583 Y116.14 E.00376
G3 X184.895 Y116.336 I.017 J1.359 E.23286
; COOLING_NODE: 0
; WIPE_START
M204 S8000
G1 X185.186 Y116.204 E-.12128
G1 X185.457 Y116.147 E-.10522
G1 X185.583 Y116.14 E-.04792
G1 X185.859 Y116.165 E-.10523
G1 X186.108 Y116.238 E-.09903
G1 X186.34 Y116.359 E-.09917
G1 X186.545 Y116.522 E-.09949
G1 X186.686 Y116.687 E-.08265
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X184.751 Y124.07 Z2 F60000
G1 X167.184 Y191.084 Z2
G1 Z1.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X167.184 Y203.237 E.39079
G1 X166.96 Y203.255 E.00723
G2 X166.87 Y204.204 I-2.556 J.236 E.48775
G2 X166.955 Y203.739 I-2.17 J-.637 E.01522
G1 X167.184 Y203.754 E.00739
G1 X167.184 Y208.584 E.15532
G1 X161.216 Y208.584 E.1919
G1 X161.216 Y116.116 E2.97342
G1 X167.216 Y116.116 E.19294
G1 X167.216 Y111.416 E.15113
G1 X188.784 Y111.416 E.69354
G1 X188.784 Y191.084 E2.56182
G1 X167.244 Y191.084 E.69265
; COOLING_NODE: 0
; WIPE_START
G1 X167.234 Y193.084 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X165.511 Y200.519 Z2 F60000
G1 X165.276 Y201.532 Z2
G1 Z1.6
G1 E.8 F1800
G1 F8843.478
M204 S8000
G1 X165.573 Y201.687 E.01078
G3 X164.17 Y201.352 I-1.175 J1.811 E.3889
G1 X164.374 Y201.34 E.00656
G3 X165.206 Y201.496 I.025 J2.159 E.02741
G1 X165.223 Y201.505 E.0006
; COOLING_NODE: 0
M204 S10000
G1 X165.09 Y201.892 F60000
G1 F8843.478
M204 S8000
G1 X165.353 Y202.03 E.00954
G3 X164.214 Y201.757 I-.953 J1.469 E.31553
G1 X164.378 Y201.747 E.00528
G3 X165.035 Y201.867 I.021 J1.752 E.02161
; COOLING_NODE: 1
M204 S250
G1 X164.91 Y202.239 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X165.14 Y202.359 E.00774
G3 X164.257 Y202.147 I-.74 J1.14 E.22682
G1 X164.383 Y202.14 E.00376
G3 X164.854 Y202.218 I.017 J1.359 E.01429
; COOLING_NODE: 1
; WIPE_START
M204 S8000
G1 X165.14 Y202.359 E-.12133
G1 X165.345 Y202.522 E-.09946
G1 X165.515 Y202.72 E-.09916
G1 X165.645 Y202.953 E-.10131
G1 X165.73 Y203.216 E-.10532
G1 X165.76 Y203.475 E-.09891
G1 X165.74 Y203.736 E-.09965
G1 X165.715 Y203.825 E-.03485
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X166.863 Y196.279 Z2 F60000
G1 X167.591 Y191.491 Z2
G1 Z1.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X167.591 Y208.991 E.56274
G1 X160.809 Y208.991 E.21808
G1 X160.809 Y115.709 E2.9996
G1 X166.809 Y115.709 E.19294
G1 X166.809 Y111.009 E.15113
G1 X189.191 Y111.009 E.71972
G1 X189.191 Y191.491 E2.588
G1 X167.651 Y191.491 E.69265
; COOLING_NODE: 1
M204 S10000
G1 X167.998 Y191.898 F60000
G1 F8843.478
M204 S8000
G1 X167.998 Y209.398 E.56274
G1 X160.402 Y209.398 E.24426
G1 X160.402 Y115.302 E3.02578
G1 X166.402 Y115.302 E.19294
G1 X166.402 Y110.602 E.15113
G1 X189.598 Y110.602 E.7459
G1 X189.598 Y191.898 E2.61418
G1 X168.058 Y191.898 E.69265
; COOLING_NODE: 2
M204 S250
G1 X168.39 Y192.29 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X168.39 Y209.79 E.52127
G1 X160.01 Y209.79 E.24961
G1 X160.01 Y114.91 E2.82615
G1 X166.01 Y114.91 E.17872
G1 X166.01 Y110.21 E.14
G1 X189.99 Y110.21 E.71428
M73 P81 R2
G1 X189.99 Y192.29 E2.44488
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

G1 X168.45 Y192.29 E.6416
; WIPE_START
M204 S8000
G1 X168.443 Y194.29 E-.76
; WIPE_END
M73 P82 R2
G1 E-.04 F1800
M204 S10000
G1 X161.38 Y196.046 Z2 F60000
G1 Z1.6
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42037
G1 F9537.687
M204 S8000
G1 X188.451 Y168.975 E1.14147
G1 X188.451 Y168.441 E.01592
G1 X161.549 Y195.343 E1.13432
G1 X161.549 Y194.809 E.01592
G1 X188.451 Y167.908 E1.13432
G1 X188.451 Y167.374 E.01592
G1 X161.549 Y194.275 E1.13432
G1 X161.549 Y193.741 E.01592
G1 X188.451 Y166.84 E1.13432
G1 X188.451 Y166.306 E.01592
G1 X161.549 Y193.207 E1.13432
G1 X161.549 Y192.674 E.01592
G1 X188.451 Y165.772 E1.13432
G1 X188.451 Y165.239 E.01592
G1 X161.549 Y192.14 E1.13432
G1 X161.549 Y191.606 E.01592
G1 X188.451 Y164.705 E1.13432
G1 X188.451 Y164.171 E.01592
G1 X161.549 Y191.072 E1.13432
G1 X161.549 Y190.538 E.01592
G1 X188.451 Y163.637 E1.13432
G1 X188.451 Y163.103 E.01592
G1 X161.549 Y190.005 E1.13432
G1 X161.549 Y189.471 E.01592
G1 X188.451 Y162.57 E1.13432
G1 X188.451 Y162.036 E.01592
G1 X161.549 Y188.937 E1.13432
G1 X161.549 Y188.403 E.01592
G1 X188.451 Y161.502 E1.13432
G1 X188.451 Y160.968 E.01592
G1 X161.549 Y187.87 E1.13432
G1 X161.549 Y187.336 E.01592
G1 X188.451 Y160.434 E1.13432
G1 X188.451 Y159.901 E.01592
G1 X161.549 Y186.802 E1.13432
G1 X161.549 Y186.268 E.01592
G1 X188.451 Y159.367 E1.13432
G1 X188.451 Y158.833 E.01592
G1 X161.549 Y185.734 E1.13432
G1 X161.549 Y185.201 E.01592
G1 X188.451 Y158.299 E1.13432
G1 X188.451 Y157.765 E.01592
G1 X161.549 Y184.667 E1.13432
G1 X161.549 Y184.133 E.01592
G1 X188.451 Y157.232 E1.13432
G1 X188.451 Y156.698 E.01592
G1 X161.549 Y183.599 E1.13432
G1 X161.549 Y183.065 E.01592
G1 X188.451 Y156.164 E1.13432
G1 X188.451 Y155.63 E.01592
G1 X161.549 Y182.532 E1.13432
G1 X161.549 Y181.998 E.01592
G1 X188.451 Y155.096 E1.13432
G1 X188.451 Y154.563 E.01592
G1 X161.549 Y181.464 E1.13432
G1 X161.549 Y180.93 E.01592
G1 X188.451 Y154.029 E1.13432
G1 X188.451 Y153.495 E.01592
G1 X161.549 Y180.396 E1.13432
G1 X161.549 Y179.863 E.01592
G1 X188.451 Y152.961 E1.13432
G1 X188.451 Y152.428 E.01592
G1 X161.549 Y179.329 E1.13432
G1 X161.549 Y178.795 E.01592
G1 X188.451 Y151.894 E1.13432
G1 X188.451 Y151.36 E.01592
G1 X161.549 Y178.261 E1.13432
G1 X161.549 Y177.727 E.01592
G1 X188.451 Y150.826 E1.13432
G1 X188.451 Y150.292 E.01592
M73 P83 R2
G1 X161.549 Y177.194 E1.13432
G1 X161.549 Y176.66 E.01592
G1 X188.451 Y149.759 E1.13432
G1 X188.451 Y149.225 E.01592
G1 X161.549 Y176.126 E1.13432
G1 X161.549 Y175.592 E.01592
G1 X188.451 Y148.691 E1.13432
G1 X188.451 Y148.157 E.01592
G1 X161.549 Y175.058 E1.13432
G1 X161.549 Y174.525 E.01592
G1 X188.451 Y147.623 E1.13432
G1 X188.451 Y147.09 E.01592
G1 X161.549 Y173.991 E1.13432
G1 X161.549 Y173.457 E.01592
G1 X188.451 Y146.556 E1.13432
G1 X188.451 Y146.022 E.01592
G1 X161.549 Y172.923 E1.13432
G1 X161.549 Y172.389 E.01592
G1 X188.451 Y145.488 E1.13432
G1 X188.451 Y144.954 E.01592
G1 X161.549 Y171.856 E1.13432
G1 X161.549 Y171.322 E.01592
G1 X188.451 Y144.421 E1.13432
G1 X188.451 Y143.887 E.01592
G1 X161.549 Y170.788 E1.13432
G1 X161.549 Y170.254 E.01592
G1 X188.451 Y143.353 E1.13432
G1 X188.451 Y142.819 E.01592
G1 X161.549 Y169.72 E1.13432
G1 X161.549 Y169.187 E.01592
G1 X188.451 Y142.285 E1.13432
G1 X188.451 Y141.752 E.01592
G1 X161.549 Y168.653 E1.13432
G1 X161.549 Y168.119 E.01592
G1 X188.451 Y141.218 E1.13432
G1 X188.451 Y140.684 E.01592
G1 X161.549 Y167.585 E1.13432
G1 X161.549 Y167.052 E.01592
G1 X188.451 Y140.15 E1.13432
G1 X188.451 Y139.616 E.01592
G1 X161.549 Y166.518 E1.13432
G1 X161.549 Y165.984 E.01592
G1 X188.451 Y139.083 E1.13432
G1 X188.451 Y138.549 E.01592
G1 X161.549 Y165.45 E1.13432
G1 X161.549 Y164.916 E.01592
G1 X188.451 Y138.015 E1.13432
G1 X188.451 Y137.481 E.01592
G1 X161.549 Y164.383 E1.13432
G1 X161.549 Y163.849 E.01592
G1 X188.451 Y136.947 E1.13432
G1 X188.451 Y136.414 E.01592
G1 X161.549 Y163.315 E1.13432
G1 X161.549 Y162.781 E.01592
G1 X188.451 Y135.88 E1.13432
G1 X188.451 Y135.346 E.01592
G1 X161.549 Y162.247 E1.13432
G1 X161.549 Y161.714 E.01592
G1 X188.451 Y134.812 E1.13432
G1 X188.451 Y134.278 E.01592
G1 X161.549 Y161.18 E1.13432
G1 X161.549 Y160.646 E.01592
G1 X188.451 Y133.745 E1.13432
G1 X188.451 Y133.211 E.01592
G1 X161.549 Y160.112 E1.13432
G1 X161.549 Y159.578 E.01592
G1 X188.451 Y132.677 E1.13432
G1 X188.451 Y132.143 E.01592
G1 X161.549 Y159.045 E1.13432
G1 X161.549 Y158.511 E.01592
G1 X188.451 Y131.61 E1.13432
G1 X188.451 Y131.076 E.01592
M73 P84 R2
G1 X161.549 Y157.977 E1.13432
G1 X161.549 Y157.443 E.01592
G1 X188.451 Y130.542 E1.13432
G1 X188.451 Y130.008 E.01592
G1 X161.549 Y156.909 E1.13432
G1 X161.549 Y156.376 E.01592
G1 X188.451 Y129.474 E1.13432
G1 X188.451 Y128.941 E.01592
G1 X161.549 Y155.842 E1.13432
G1 X161.549 Y155.308 E.01592
G1 X188.451 Y128.407 E1.13432
G1 X188.451 Y127.873 E.01592
G1 X161.549 Y154.774 E1.13432
G1 X161.549 Y154.24 E.01592
G1 X188.451 Y127.339 E1.13432
G1 X188.451 Y126.805 E.01592
G1 X161.549 Y153.707 E1.13432
G1 X161.549 Y153.173 E.01592
G1 X188.451 Y126.272 E1.13432
G1 X188.451 Y125.738 E.01592
G1 X161.549 Y152.639 E1.13432
G1 X161.549 Y152.105 E.01592
G1 X188.451 Y125.204 E1.13432
G1 X188.451 Y124.67 E.01592
G1 X161.549 Y151.571 E1.13432
G1 X161.549 Y151.038 E.01592
G1 X188.451 Y124.136 E1.13432
G1 X188.451 Y123.603 E.01592
G1 X161.549 Y150.504 E1.13432
G1 X161.549 Y149.97 E.01592
G1 X188.451 Y123.069 E1.13432
G1 X188.451 Y122.535 E.01592
G1 X161.549 Y149.436 E1.13432
G1 X161.549 Y148.902 E.01592
G1 X188.451 Y122.001 E1.13432
G1 X188.451 Y121.467 E.01592
G1 X161.549 Y148.369 E1.13432
G1 X161.549 Y147.835 E.01592
G1 X188.451 Y120.934 E1.13432
G1 X188.451 Y120.4 E.01592
G1 X161.549 Y147.301 E1.13432
G1 X161.549 Y146.767 E.01592
G1 X188.451 Y119.866 E1.13432
G1 X188.451 Y119.332 E.01592
G1 X161.549 Y146.234 E1.13432
G1 X161.549 Y145.7 E.01592
G1 X188 Y119.249 E1.11534
G1 X187.964 Y119.177 E.00241
G1 X187.872 Y119.305 E.00472
G1 X187.504 Y119.69 E.01587
G3 X186.442 Y120.273 I-1.871 J-2.148 E.03638
G1 X161.549 Y145.166 E1.04964
G1 X161.549 Y144.632 E.01592
G1 X185.796 Y120.385 E1.02239
G3 X185.269 Y120.379 I-.242 J-1.796 E.01578
G1 X161.549 Y144.098 E1.00015
G1 X161.549 Y143.565 E.01592
G1 X184.82 Y120.294 E.98123
G1 X184.434 Y120.146 E.01232
G1 X161.549 Y143.031 E.96496
G1 X161.549 Y142.497 E.01592
G1 X184.079 Y119.968 E.94997
G3 X183.766 Y119.747 I2.446 J-3.802 E.01142
G1 X161.549 Y141.963 E.93677
G1 X161.549 Y141.429 E.01592
G1 X183.496 Y119.483 E.92538
G3 X183.255 Y119.19 I.658 J-.787 E.01137
G1 X161.549 Y140.896 E.91523
G1 X161.549 Y140.362 E.01592
G1 X183.044 Y118.867 E.90635
G3 X182.879 Y118.498 I1.667 J-.967 E.01207
G1 X161.549 Y139.828 E.89939
G1 X161.549 Y139.294 E.01592
G1 X182.768 Y118.075 E.89472
G3 X182.712 Y117.597 I1.183 J-.38 E.01444
G1 X161.549 Y138.76 E.89236
G1 X161.549 Y138.227 E.01592
G1 X182.75 Y117.026 E.89394
G1 X182.798 Y116.742 E.0086
G1 X182.978 Y116.264 E.01522
G1 X161.549 Y137.693 E.90356
M73 P85 R2
G1 X161.549 Y137.159 E.01592
G1 X186.959 Y111.749 E1.07142
G1 X187.493 Y111.749 E.01592
G1 X184.363 Y114.879 E.13198
G3 X185.136 Y114.64 I1.072 J2.092 E.02427
G1 X188.027 Y111.749 E.12187
G1 X188.451 Y111.749 E.01264
G1 X188.451 Y111.859 E.00327
G1 X185.7 Y114.61 E.11599
G3 X186.175 Y114.668 I.09 J1.233 E.01437
G1 X188.451 Y112.393 E.09595
G1 X188.451 Y112.927 E.01592
G1 X186.592 Y114.785 E.07837
G1 X186.967 Y114.944 E.01214
G1 X188.451 Y113.461 E.06257
G1 X188.451 Y113.994 E.01592
G1 X187.292 Y115.153 E.04885
G3 X187.589 Y115.39 I-.657 J1.129 E.01137
G1 X188.451 Y114.528 E.03633
G1 X188.451 Y115.062 E.01592
G1 X187.845 Y115.667 E.02552
G1 X188.036 Y115.941 E.00995
G1 X188.121 Y115.925 E.00258
G1 X188.62 Y115.426 E.02104
M204 S10000
G1 X188.336 Y116.224 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.441405
G1 F9034.225
M204 S8000
G1 X188.369 Y116.4 E.00562
; LINE_WIDTH: 0.412574
G1 F9738.85
G1 X188.404 Y116.593 E.00573
; LINE_WIDTH: 0.377141
G1 F10771.336
G1 X188.422 Y116.724 E.00349
; LINE_WIDTH: 0.340054
G1 F12115.777
G1 X188.441 Y116.868 E.00342
; LINE_WIDTH: 0.296284
G1 F14208.822
G1 X188.466 Y117.157 E.0058
; LINE_WIDTH: 0.26548
G1 F15000
G1 X188.472 Y117.712 E.00976
G1 X188.453 Y118.011 E.00526
; LINE_WIDTH: 0.312996
G1 F13329.607
G1 X188.437 Y118.153 E.00305
; LINE_WIDTH: 0.347237
G1 F11829.795
G1 X188.419 Y118.311 E.00383
; LINE_WIDTH: 0.387525
G1 F10446.746
G1 X188.397 Y118.442 E.00362
; LINE_WIDTH: 0.433457
G1 F9218.096
G1 X188.376 Y118.573 E.0041
G1 X188.102 Y118.712 E.00946
; WIPE_START
G1 X188.376 Y118.573 E-.53035
G1 X188.397 Y118.442 E-.22965
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X181.089 Y116.241 Z2 F60000
G1 X167.38 Y112.112 Z2
G1 Z1.6
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42037
G1 F9537.687
M204 S8000
G1 X167.742 Y111.749 E.01529
G1 X168.276 Y111.749 E.01592
G1 X167.549 Y112.476 E.03065
G1 X167.549 Y113.01 E.01592
G1 X168.81 Y111.749 E.05316
G1 X169.344 Y111.749 E.01592
G1 X167.549 Y113.544 E.07566
G1 X167.549 Y114.078 E.01592
G1 X169.878 Y111.749 E.09817
G1 X170.411 Y111.749 E.01592
G1 X167.549 Y114.611 E.12068
G1 X167.549 Y115.145 E.01592
G1 X170.945 Y111.749 E.14319
G1 X171.479 Y111.749 E.01592
G1 X167.38 Y115.849 E.17285
; WIPE_START
G1 X168.794 Y114.434 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X161.595 Y116.969 Z2 F60000
G1 X161.38 Y117.044 Z2
G1 Z1.6
G1 E.8 F1800
G1 F9537.687
M204 S8000
G1 X161.975 Y116.449 E.02509
G1 X162.509 Y116.449 E.01592
G1 X161.549 Y117.409 E.04045
G1 X161.549 Y117.942 E.01592
G1 X163.042 Y116.449 E.06295
G1 X163.576 Y116.449 E.01592
G1 X161.549 Y118.476 E.08546
G1 X161.549 Y119.01 E.01592
G1 X164.11 Y116.449 E.10797
G1 X164.644 Y116.449 E.01592
G1 X161.549 Y119.544 E.13048
G1 X161.549 Y120.078 E.01592
G1 X165.178 Y116.449 E.15299
G1 X165.711 Y116.449 E.01592
G1 X161.549 Y120.611 E.17549
G1 X161.549 Y121.145 E.01592
G1 X166.245 Y116.449 E.198
G1 X166.779 Y116.449 E.01592
G1 X161.549 Y121.679 E.22051
G1 X161.549 Y122.213 E.01592
G1 X172.013 Y111.749 E.4412
G1 X172.547 Y111.749 E.01592
G1 X161.549 Y122.747 E.46371
G1 X161.549 Y123.28 E.01592
G1 X173.08 Y111.749 E.48622
G1 X173.614 Y111.749 E.01592
G1 X161.549 Y123.814 E.50872
G1 X161.549 Y124.348 E.01592
G1 X174.148 Y111.749 E.53123
G1 X174.682 Y111.749 E.01592
G1 X161.549 Y124.882 E.55374
G1 X161.549 Y125.416 E.01592
G1 X175.216 Y111.749 E.57625
G1 X175.749 Y111.749 E.01592
G1 X161.549 Y125.949 E.59875
G1 X161.549 Y126.483 E.01592
G1 X176.283 Y111.749 E.62126
G1 X176.817 Y111.749 E.01592
G1 X161.549 Y127.017 E.64377
G1 X161.549 Y127.551 E.01592
G1 X177.351 Y111.749 E.66628
G1 X177.884 Y111.749 E.01592
G1 X161.549 Y128.084 E.68879
G1 X161.549 Y128.618 E.01592
G1 X178.418 Y111.749 E.7113
G1 X178.952 Y111.749 E.01592
G1 X161.549 Y129.152 E.7338
G1 X161.549 Y129.686 E.01592
G1 X179.486 Y111.749 E.75631
G1 X180.02 Y111.749 E.01592
G1 X161.549 Y130.22 E.77882
G1 X161.549 Y130.753 E.01592
G1 X180.553 Y111.749 E.80133
G1 X181.087 Y111.749 E.01592
G1 X161.549 Y131.287 E.82384
G1 X161.549 Y131.821 E.01592
G1 X181.621 Y111.749 E.84634
G1 X182.155 Y111.749 E.01592
G1 X161.549 Y132.355 E.86885
G1 X161.549 Y132.889 E.01592
G1 X182.689 Y111.749 E.89136
G1 X183.222 Y111.749 E.01592
G1 X161.549 Y133.422 E.91387
G1 X161.549 Y133.956 E.01592
G1 X183.756 Y111.749 E.93637
G1 X184.29 Y111.749 E.01592
G1 X161.549 Y134.49 E.95888
G1 X161.549 Y135.024 E.01592
G1 X184.824 Y111.749 E.98139
G1 X185.358 Y111.749 E.01592
G1 X161.549 Y135.558 E1.0039
G1 X161.549 Y136.091 E.01592
G1 X185.891 Y111.749 E1.02641
G1 X186.425 Y111.749 E.01592
G1 X161.38 Y136.795 E1.05607
; WIPE_START
G1 X162.794 Y135.381 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X165.933 Y142.338 Z2 F60000
G1 X187.857 Y190.92 Z2
G1 Z1.6
G1 E.8 F1800
G1 F9537.687
M204 S8000
G1 X188.451 Y190.327 E.02502
G1 X188.451 Y189.793 E.01592
G1 X187.493 Y190.751 E.04037
G1 X186.959 Y190.751 E.01592
G1 X188.451 Y189.259 E.06288
G1 X188.451 Y188.726 E.01592
G1 X186.426 Y190.751 E.08539
G1 X185.892 Y190.751 E.01592
G1 X188.451 Y188.192 E.1079
G1 X188.451 Y187.658 E.01592
G1 X185.358 Y190.751 E.13041
G1 X184.824 Y190.751 E.01592
G1 X188.451 Y187.124 E.15291
G1 X188.451 Y186.59 E.01592
G1 X184.29 Y190.751 E.17542
G1 X183.757 Y190.751 E.01592
G1 X188.451 Y186.057 E.19793
G1 X188.451 Y185.523 E.01592
G1 X183.223 Y190.751 E.22044
G1 X182.689 Y190.751 E.01592
G1 X188.451 Y184.989 E.24295
G1 X188.451 Y184.455 E.01592
G1 X182.155 Y190.751 E.26545
G1 X181.621 Y190.751 E.01592
G1 X188.451 Y183.921 E.28796
G1 X188.451 Y183.388 E.01592
G1 X181.088 Y190.751 E.31047
G1 X180.554 Y190.751 E.01592
G1 X188.451 Y182.854 E.33298
G1 X188.451 Y182.32 E.01592
G1 X180.02 Y190.751 E.35549
G1 X179.486 Y190.751 E.01592
G1 X188.451 Y181.786 E.37799
G1 X188.451 Y181.252 E.01592
G1 X178.952 Y190.751 E.4005
G1 X178.419 Y190.751 E.01592
G1 X188.451 Y180.719 E.42301
G1 X188.451 Y180.185 E.01592
G1 X177.885 Y190.751 E.44552
G1 X177.351 Y190.751 E.01592
G1 X188.451 Y179.651 E.46803
G1 X188.451 Y179.117 E.01592
G1 X176.817 Y190.751 E.49053
G1 X176.283 Y190.751 E.01592
G1 X188.451 Y178.583 E.51304
G1 X188.451 Y178.05 E.01592
G1 X175.75 Y190.751 E.53555
G1 X175.216 Y190.751 E.01592
M73 P86 R2
G1 X188.451 Y177.516 E.55806
G1 X188.451 Y176.982 E.01592
G1 X174.682 Y190.751 E.58057
G1 X174.148 Y190.751 E.01592
G1 X188.451 Y176.448 E.60307
G1 X188.451 Y175.914 E.01592
G1 X173.614 Y190.751 E.62558
G1 X173.081 Y190.751 E.01592
G1 X188.451 Y175.381 E.64809
G1 X188.451 Y174.847 E.01592
G1 X172.547 Y190.751 E.6706
G1 X172.013 Y190.751 E.01592
G1 X188.451 Y174.313 E.6931
G1 X188.451 Y173.779 E.01592
G1 X171.479 Y190.751 E.71561
G1 X170.946 Y190.751 E.01592
G1 X188.451 Y173.246 E.73812
G1 X188.451 Y172.712 E.01592
G1 X170.412 Y190.751 E.76063
G1 X169.878 Y190.751 E.01592
G1 X188.451 Y172.178 E.78314
G1 X188.451 Y171.644 E.01592
G1 X169.344 Y190.751 E.80564
G1 X168.81 Y190.751 E.01592
G1 X188.451 Y171.11 E.82815
G1 X188.451 Y170.577 E.01592
G1 X168.277 Y190.751 E.85066
G1 X167.743 Y190.751 E.01592
G1 X188.451 Y170.043 E.87317
G1 X188.451 Y169.509 E.01592
G1 X167.209 Y190.751 E.89568
G1 X166.851 Y190.751 E.01068
G1 X166.851 Y191.109 E.01068
G1 X161.549 Y196.41 E.22353
G1 X161.549 Y196.944 E.01592
G1 X166.851 Y191.643 E.22353
G1 X166.851 Y192.177 E.01592
G1 X161.549 Y197.478 E.22353
G1 X161.549 Y198.012 E.01592
G1 X166.851 Y192.71 E.22353
G1 X166.851 Y193.244 E.01592
G1 X161.549 Y198.545 E.22353
G1 X161.549 Y199.079 E.01592
G1 X166.851 Y193.778 E.22353
G1 X166.851 Y194.312 E.01592
G1 X161.549 Y199.613 E.22353
G1 X161.549 Y200.147 E.01592
G1 X166.851 Y194.846 E.22353
G1 X166.851 Y195.379 E.01592
G1 X161.549 Y200.681 E.22353
G1 X161.549 Y201.214 E.01592
G1 X166.851 Y195.913 E.22353
G1 X166.851 Y196.447 E.01592
G1 X161.549 Y201.748 E.22353
G1 X161.549 Y201.859 E.0033
G1 X161.899 Y201.932 E.01066
G1 X166.851 Y196.981 E.20877
G1 X166.851 Y197.514 E.01592
G1 X163.662 Y200.703 E.13445
G3 X164.296 Y200.603 I.711 J2.446 E.01919
G1 X166.851 Y198.048 E.10772
G1 X166.851 Y198.582 E.01592
G1 X164.802 Y200.63 E.08637
G3 X165.242 Y200.725 I-.478 J3.284 E.01341
G1 X166.851 Y199.116 E.06785
G1 X166.851 Y199.65 E.01592
G1 X165.623 Y200.877 E.05175
G3 X165.972 Y201.062 I-.46 J1.291 E.01182
G1 X166.851 Y200.183 E.03703
G1 X166.851 Y200.717 E.01592
G1 X166.277 Y201.291 E.02421
G3 X166.548 Y201.554 I-1.138 J1.446 E.01128
G1 X167.02 Y201.081 E.01993
M204 S10000
G1 X166.762 Y202.01 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.108967
G1 F15000
M204 S8000
G1 X166.855 Y202.131 E.0008
; LINE_WIDTH: 0.13862
G1 X166.98 Y202.312 E.00167
; WIPE_START
G1 X166.855 Y202.131 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X167.387 Y203.493 Z2 F60000
G1 Z1.6
G1 E.8 F1800
; LINE_WIDTH: 0.152592
G1 F15000
M204 S8000
G1 X167.084 Y203.496 E.00263
; LINE_WIDTH: 0.115477
G1 X166.78 Y203.5 E.00174
; WIPE_START
G1 X167.084 Y203.496 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X166.98 Y204.661 Z2 F60000
G1 Z1.6
G1 E.8 F1800
; LINE_WIDTH: 0.119882
G1 F15000
M204 S8000
G1 X166.809 Y204.912 E.00185
M204 S10000
G1 X166.729 Y205.33 F60000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F9547.299
M204 S8000
G1 X166.319 Y205.753 E.01755
G1 X165.857 Y206.077 E.01682
G1 X165.396 Y206.282 E.01502
G1 X164.766 Y206.437 E.01933
G1 X164.204 Y206.454 E.01674
G1 X163.644 Y206.362 E.0169
G1 X163.117 Y206.167 E.01675
G1 X162.815 Y205.999 E.01029
G1 X162.36 Y205.644 E.01719
G3 X161.943 Y205.122 I24.875 J-20.308 E.01991
G1 X161.608 Y205.184 E.01013
G1 X161.608 Y208.192 E.0896
G1 X166.792 Y208.192 E.15439
G1 X166.792 Y205.397 E.08325
G1 X166.77 Y205.374 E.00095
M204 S10000
G1 X166.415 Y206.15 F60000
G1 F9547.299
M204 S8000
G3 X164.847 Y206.805 I-2.108 J-2.84 E.05112
G1 X164.213 Y206.83 E.01889
G1 X163.581 Y206.734 E.01904
G1 X162.984 Y206.52 E.01889
G1 X162.583 Y206.296 E.01368
G1 X162.128 Y205.941 E.01719
G1 X161.985 Y205.786 E.00627
G1 X161.985 Y207.815 E.06041
G1 X166.415 Y207.815 E.13193
G1 X166.415 Y206.21 E.04781
M204 S10000
G1 X166.011 Y206.866 F60000
; LINE_WIDTH: 0.4672
G1 F8484.962
M204 S8000
G1 X165.647 Y207.017 E.0132
; LINE_WIDTH: 0.436623
G1 F9143.96
G1 X165.284 Y207.082 E.01145
; LINE_WIDTH: 0.388948
G1 F10403.797
G1 X164.922 Y207.147 E.01007
; LINE_WIDTH: 0.364259
G1 F11203.119
G1 X164.221 Y207.171 E.01779
G1 X163.52 Y207.095 E.01791
; LINE_WIDTH: 0.419485
G1 F9560.102
G1 X163.291 Y207.037 E.00702
; LINE_WIDTH: 0.460975
G1 F8611.307
G1 X163.062 Y206.979 E.0078
; LINE_WIDTH: 0.502465
G1 F7833.836
G1 X162.833 Y206.921 E.00857
; LINE_WIDTH: 0.535579
G1 F7307.291
G1 X162.422 Y206.741 E.01747
G1 X162.422 Y207.378 E.0248
; LINE_WIDTH: 0.520235
G1 F7542.189
G1 X162.706 Y207.397 E.01074
; LINE_WIDTH: 0.483105
G1 F8178.38
G1 X162.99 Y207.415 E.0099
; LINE_WIDTH: 0.445975
G1 F8931.784
G1 X163.275 Y207.434 E.00907
; LINE_WIDTH: 0.409035
G1 F9832.976
G1 X163.648 Y207.452 E.01081
; LINE_WIDTH: 0.359749
G1 F11362.615
G2 X164.751 Y207.471 I.747 J-11.378 E.02761
; LINE_WIDTH: 0.37071
G1 F10982.641
G1 X165.128 Y207.453 E.00978
; LINE_WIDTH: 0.40667
G1 F9896.907
G1 X165.505 Y207.435 E.01085
; LINE_WIDTH: 0.461353
G1 F8603.542
G1 X166.011 Y207.411 E.01673
G1 X166.011 Y206.926 E.01603
; WIPE_START
G1 X166.011 Y207.411 E-.37182
G1 X165.505 Y207.435 E-.38818
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X161.663 Y204.775 Z2 F60000
G1 Z1.6
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.440395
G1 F9057.191
M204 S8000
G1 X161.63 Y204.596 E.0057
; LINE_WIDTH: 0.412023
G1 F9753.387
G1 X161.597 Y204.417 E.0053
; LINE_WIDTH: 0.376086
G1 F10805.432
G1 X161.576 Y204.259 E.00421
; LINE_WIDTH: 0.336716
G1 F12253.405
G1 X161.557 Y204.118 E.00329
; LINE_WIDTH: 0.295323
G1 F14262.914
G1 X161.535 Y203.85 E.00537
; LINE_WIDTH: 0.264917
G1 F15000
G1 X161.524 Y203.553 E.0052
G1 X161.545 Y203.007 E.00958
; LINE_WIDTH: 0.309148
G1 F13522.272
G1 X161.561 Y202.864 E.00303
; LINE_WIDTH: 0.339464
G1 F12139.874
G1 X161.575 Y202.734 E.00308
; LINE_WIDTH: 0.376988
G1 F10776.276
G1 X161.599 Y202.585 E.00398
; LINE_WIDTH: 0.422015
G1 F9496.308
G1 X161.62 Y202.45 E.00407
; LINE_WIDTH: 0.451355
G1 F8814.14
G3 X161.667 Y202.224 I4.615 J.836 E.00747
; CHANGE_LAYER
; Z_HEIGHT: 1.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F8814.14
G1 X161.62 Y202.45 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 9/10
; update layer progress
M73 L9
M991 S0 P8 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z2 I1.178 J.306 P1  F60000
G1 X184.278 Y115.309 Z2
G1 Z1.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X184.381 Y115.238 E.00404
G3 X185.329 Y114.946 I1.216 J2.26 E.0321
G1 X185.585 Y114.932 E.00825
G3 X183.972 Y115.512 I.012 J2.566 E.46233
G1 X184.228 Y115.343 E.00986
; COOLING_NODE: 0
M204 S10000
G1 X184.503 Y115.646 F60000
G1 F8843.478
M204 S8000
G1 X184.575 Y115.597 E.00279
G3 X185.372 Y115.352 I1.023 J1.902 E.027
G1 X185.588 Y115.34 E.00695
G3 X184.231 Y115.828 I.01 J2.159 E.38895
G1 X184.453 Y115.68 E.00859
; COOLING_NODE: 0
M204 S10000
G1 X184.729 Y115.983 F60000
G1 F8843.478
M204 S8000
G1 X184.769 Y115.956 E.00155
G3 X185.416 Y115.757 I.83 J1.543 E.0219
G1 X185.591 Y115.747 E.00565
G3 X184.49 Y116.143 I.008 J1.752 E.31558
G1 X184.679 Y116.017 E.00733
; COOLING_NODE: 0
M204 S250
G1 X184.947 Y116.308 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X184.956 Y116.302 E.00033
G3 X185.457 Y116.147 I.644 J1.197 E.01573
G1 X185.594 Y116.14 E.00407
G3 X184.739 Y116.447 I.006 J1.359 E.22686
G1 X184.897 Y116.341 E.00565
; COOLING_NODE: 0
; WIPE_START
M204 S8000
G1 X184.956 Y116.302 E-.02702
G1 X185.201 Y116.2 E-.10102
G1 X185.457 Y116.147 E-.0993
G1 X185.594 Y116.14 E-.05194
G1 X185.859 Y116.165 E-.10137
G1 X186.11 Y116.239 E-.09949
G1 X186.355 Y116.369 E-.10537
G1 X186.562 Y116.538 E-.10152
G1 X186.684 Y116.686 E-.07296
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X184.749 Y124.069 Z2.2 F60000
G1 X167.184 Y191.084 Z2.2
G1 Z1.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X167.184 Y203.247 E.39111
G1 X166.957 Y203.263 E.00732
G2 X166.958 Y203.74 I-2.556 J.244 E.50328
G1 X167.184 Y203.757 E.00729
G1 X167.184 Y208.584 E.15521
G1 X161.216 Y208.584 E.1919
G1 X161.216 Y116.116 E2.97342
G1 X167.216 Y116.116 E.19294
G1 X167.216 Y111.416 E.15113
G1 X188.784 Y111.416 E.69354
G1 X188.784 Y191.084 E2.56182
G1 X167.244 Y191.084 E.69265
; COOLING_NODE: 0
; WIPE_START
G1 X167.234 Y193.084 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X165.517 Y200.521 Z2.2 F60000
G1 X165.283 Y201.536 Z2.2
G1 Z1.8
G1 E.8 F1800
G1 F8843.478
M204 S8000
G1 X165.597 Y201.704 E.01147
G3 X164.172 Y201.352 I-1.2 J1.795 E.38808
G1 X164.388 Y201.34 E.00695
G3 X165.209 Y201.498 I.01 J2.159 E.02704
G1 X165.229 Y201.508 E.00075
; COOLING_NODE: 0
M204 S10000
G1 X165.093 Y201.894 F60000
G1 F8843.478
M204 S8000
G1 X165.372 Y202.043 E.01016
G3 X164.216 Y201.757 I-.973 J1.456 E.31485
G1 X164.391 Y201.747 E.00565
G3 X165.039 Y201.869 I.008 J1.752 E.02133
; COOLING_NODE: 1
M204 S250
G1 X164.908 Y202.238 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X164.909 Y202.239 E.00005
G3 X164.257 Y202.147 I-.51 J1.26 E.23462
G1 X164.394 Y202.14 E.00407
G3 X164.659 Y202.165 I.006 J1.359 E.00794
G1 X164.85 Y202.221 E.00595
; COOLING_NODE: 1
; WIPE_START
M204 S8000
G1 X164.909 Y202.239 E-.02344
G1 X165.155 Y202.369 E-.10569
G1 X165.362 Y202.538 E-.10143
G1 X165.528 Y202.74 E-.09936
G1 X165.653 Y202.97 E-.09932
G1 X165.701 Y203.102 E-.05363
G1 X165.754 Y203.375 E-.1057
G1 X165.753 Y203.641 E-.10118
G1 X165.716 Y203.823 E-.07025
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X166.863 Y196.277 Z2.2 F60000
G1 X167.591 Y191.491 Z2.2
G1 Z1.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X167.591 Y208.991 E.56274
G1 X160.809 Y208.991 E.21808
G1 X160.809 Y115.709 E2.9996
G1 X166.809 Y115.709 E.19294
G1 X166.809 Y111.009 E.15113
G1 X189.191 Y111.009 E.71972
M73 P87 R2
G1 X189.191 Y191.491 E2.588
G1 X167.651 Y191.491 E.69265
; COOLING_NODE: 1
M204 S10000
G1 X167.998 Y191.898 F60000
G1 F8843.478
M204 S8000
G1 X167.998 Y209.398 E.56274
G1 X160.402 Y209.398 E.24426
G1 X160.402 Y115.302 E3.02578
G1 X166.402 Y115.302 E.19294
G1 X166.402 Y110.602 E.15113
G1 X189.598 Y110.602 E.7459
G1 X189.598 Y191.898 E2.61418
G1 X168.058 Y191.898 E.69265
; COOLING_NODE: 2
M204 S250
G1 X168.39 Y192.29 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X168.39 Y209.79 E.52127
G1 X160.01 Y209.79 E.24961
G1 X160.01 Y114.91 E2.82615
G1 X166.01 Y114.91 E.17872
G1 X166.01 Y110.21 E.14
G1 X189.99 Y110.21 E.71428
G1 X189.99 Y192.29 E2.44488
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

G1 X168.45 Y192.29 E.6416
; WIPE_START
M204 S8000
G1 X168.443 Y194.29 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X166.847 Y201.754 Z2.2 F60000
G1 X166.785 Y202.047 Z2.2
G1 Z1.8
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.10849
G1 F15000
M204 S8000
G1 X166.873 Y202.165 E.00077
; LINE_WIDTH: 0.134214
G1 X166.98 Y202.325 E.00139
; WIPE_START
G1 X166.873 Y202.165 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X166.825 Y203.501 Z2.2 F60000
G1 Z1.8
G1 E.8 F1800
; LINE_WIDTH: 0.114089
G1 F15000
M204 S8000
G1 X167.106 Y203.502 E.00158
; LINE_WIDTH: 0.148421
G1 X167.387 Y203.502 E.00234
; WIPE_START
G1 X167.106 Y203.502 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X166.98 Y204.681 Z2.2 F60000
G1 Z1.8
G1 E.8 F1800
; LINE_WIDTH: 0.139884
G1 F15000
M204 S8000
G1 X166.881 Y204.827 E.00135
; LINE_WIDTH: 0.112391
G1 X166.773 Y204.973 E.00099
M204 S10000
G1 X166.663 Y205.38 F60000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F9547.299
M204 S8000
G1 X166.318 Y205.753 E.01515
G1 X166.039 Y205.964 E.01042
G1 X165.542 Y206.23 E.01678
G1 X164.98 Y206.402 E.0175
G1 X164.415 Y206.46 E.01693
G1 X163.853 Y206.409 E.0168
G1 X163.277 Y206.238 E.0179
G1 X162.762 Y205.965 E.01737
G1 X162.321 Y205.607 E.01691
G1 X162.043 Y205.254 E.01338
G1 X161.92 Y205.336 E.0044
G1 X161.608 Y205.235 E.00977
G1 X161.608 Y208.192 E.08807
G1 X166.792 Y208.192 E.15439
G1 X166.792 Y205.436 E.08209
G1 X166.718 Y205.404 E.00239
M204 S10000
G1 X166.415 Y206.156 F60000
G1 F9547.299
M204 S8000
G1 X165.72 Y206.563 E.02398
G1 X165.089 Y206.764 E.01973
G1 X164.45 Y206.835 E.01913
G1 X163.816 Y206.784 E.01895
G1 X163.167 Y206.599 E.0201
G1 X162.583 Y206.297 E.01959
G1 X161.989 Y205.808 E.02291
G2 X161.985 Y207.815 I183.33 J1.337 E.05976
G1 X166.415 Y207.815 E.13193
G1 X166.415 Y206.216 E.04761
M204 S10000
G1 X166.011 Y206.864 F60000
; LINE_WIDTH: 0.47227
G1 F8384.767
M204 S8000
G1 X165.731 Y206.992 E.01044
; LINE_WIDTH: 0.45182
G1 F8804.108
G1 X165.462 Y207.051 E.00891
; LINE_WIDTH: 0.41146
G1 F9768.275
G1 X165.193 Y207.111 E.00803
; LINE_WIDTH: 0.363174
G1 F11241.094
G1 X164.483 Y207.173 E.01803
G1 X163.782 Y207.135 E.01776
; LINE_WIDTH: 0.388454
G1 F10418.676
G1 X163.538 Y207.085 E.0068
; LINE_WIDTH: 0.4234
G1 F9461.733
G1 X163.294 Y207.036 E.00748
; LINE_WIDTH: 0.458347
G1 F8665.789
G1 X163.05 Y206.986 E.00817
; LINE_WIDTH: 0.49246
G1 F8008.186
G1 X162.921 Y206.946 E.00479
; LINE_WIDTH: 0.54054
G1 F7234.441
G1 X162.792 Y206.907 E.00531
G1 X162.424 Y206.709 E.01643
G1 X162.424 Y207.376 E.02625
; LINE_WIDTH: 0.52574
G1 F7456.195
G1 X162.705 Y207.393 E.01076
; LINE_WIDTH: 0.49246
G1 F8008.186
G1 X162.987 Y207.41 E.01002
; LINE_WIDTH: 0.454905
G1 F8738.182
G1 X163.269 Y207.431 E.0092
; LINE_WIDTH: 0.413075
G1 F9725.656
G1 X163.551 Y207.452 E.00827
; LINE_WIDTH: 0.363313
G1 F11236.219
G2 X165.029 Y207.462 I.85 J-15.136 E.03742
; LINE_WIDTH: 0.387409
G1 F10450.282
G1 X165.284 Y207.445 E.00694
; LINE_WIDTH: 0.421245
G1 F9515.628
G1 X165.538 Y207.429 E.00763
; LINE_WIDTH: 0.467843
G1 F8472.137
G3 X166.011 Y207.411 I.368 J3.619 E.0159
G1 X166.011 Y206.924 E.01636
; WIPE_START
G1 X166.011 Y207.411 E-.38554
G1 X165.538 Y207.429 E-.37446
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X161.898 Y204.708 Z2.2 F60000
G1 Z1.8
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.371246
G1 F10964.735
M204 S8000
G1 X161.667 Y204.594 E.00669
; LINE_WIDTH: 0.428541
G1 F9335.608
G1 X161.625 Y204.572 E.00147
G1 X161.604 Y204.447 E.00384
; LINE_WIDTH: 0.390356
G1 F10361.633
G1 X161.583 Y204.323 E.00346
; LINE_WIDTH: 0.351863
G1 F11652.638
G1 X161.566 Y204.179 E.00353
; LINE_WIDTH: 0.319714
G1 F13006.081
G1 X161.551 Y204.051 E.00282
; LINE_WIDTH: 0.283865
G1 F14941.179
G1 X161.53 Y203.763 E.0055
; LINE_WIDTH: 0.257911
G1 F15000
G1 X161.531 Y203.221 E.00921
; LINE_WIDTH: 0.284744
G1 F14886.912
G1 X161.551 Y202.948 E.00522
; LINE_WIDTH: 0.323048
G1 F12851.289
G1 X161.569 Y202.793 E.00345
; LINE_WIDTH: 0.359461
G1 F11372.965
G1 X161.587 Y202.651 E.00358
; LINE_WIDTH: 0.398376
G1 F10127.855
G1 X161.625 Y202.43 E.00631
; LINE_WIDTH: 0.435838
G1 F9162.227
G1 X161.661 Y202.226 E.00643
M204 S10000
G1 X162.126 Y201.988 F60000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42136
G1 F9512.736
M204 S8000
G1 X161.549 Y201.411 E.02438
G1 X161.549 Y200.876 E.016
G1 X162.245 Y201.572 E.02942
G3 X162.517 Y201.308 I.82 J.573 E.01138
G1 X161.549 Y200.341 E.0409
G1 X161.549 Y199.806 E.016
G1 X162.816 Y201.072 E.05355
G1 X163.163 Y200.884 E.0118
G1 X161.549 Y199.27 E.06822
G1 X161.549 Y198.735 E.016
G1 X163.552 Y200.738 E.08467
G3 X163.982 Y200.632 I.566 J1.375 E.01327
G1 X161.549 Y198.2 E.10283
G1 X161.549 Y197.665 E.016
G1 X164.488 Y200.603 E.12422
G3 X165.12 Y200.7 I-.053 J2.448 E.01919
G1 X161.549 Y197.13 E.15096
G1 X161.549 Y196.594 E.016
G1 X166.147 Y201.192 E.19436
G1 X166.224 Y201.243 E.00278
G3 X166.679 Y201.711 I-1.958 J2.359 E.01953
G1 X166.851 Y201.583 E.0064
G1 X166.851 Y201.361 E.00665
G1 X161.549 Y196.059 E.22412
G1 X161.549 Y195.524 E.016
G1 X166.851 Y200.825 E.22412
G1 X166.851 Y200.29 E.016
G1 X161.549 Y194.989 E.22412
G1 X161.549 Y194.454 E.016
G1 X166.851 Y199.755 E.22412
G1 X166.851 Y199.22 E.016
G1 X161.549 Y193.918 E.22412
G1 X161.549 Y193.383 E.016
G1 X166.851 Y198.685 E.22412
G1 X166.851 Y198.149 E.016
G1 X161.549 Y192.848 E.22412
G1 X161.549 Y192.313 E.016
G1 X166.851 Y197.614 E.22412
G1 X166.851 Y197.079 E.016
G1 X161.549 Y191.778 E.22412
G1 X161.549 Y191.242 E.016
G1 X166.851 Y196.544 E.22412
G1 X166.851 Y196.009 E.016
G1 X161.549 Y190.707 E.22412
G1 X161.549 Y190.172 E.016
G1 X166.851 Y195.473 E.22412
G1 X166.851 Y194.938 E.016
G1 X161.549 Y189.637 E.22412
G1 X161.549 Y189.102 E.016
G1 X166.851 Y194.403 E.22412
G1 X166.851 Y193.868 E.016
G1 X161.549 Y188.567 E.22412
G1 X161.549 Y188.031 E.016
G1 X166.851 Y193.333 E.22412
G1 X166.851 Y192.797 E.016
G1 X161.549 Y187.496 E.22412
G1 X161.549 Y186.961 E.016
G1 X166.851 Y192.262 E.22412
G1 X166.851 Y191.727 E.016
G1 X161.549 Y186.426 E.22412
G1 X161.549 Y185.891 E.016
G1 X166.851 Y191.192 E.22412
G1 X166.851 Y190.751 E.01319
G1 X166.945 Y190.751 E.00281
G1 X161.549 Y185.355 E.22809
G1 X161.549 Y184.82 E.016
G1 X167.48 Y190.751 E.25072
G1 X168.015 Y190.751 E.016
G1 X161.549 Y184.285 E.27335
G1 X161.549 Y183.75 E.016
G1 X168.55 Y190.751 E.29597
G1 X169.085 Y190.751 E.016
G1 X161.549 Y183.215 E.3186
G1 X161.549 Y182.679 E.016
G1 X169.621 Y190.751 E.34123
G1 X170.156 Y190.751 E.016
G1 X161.549 Y182.144 E.36385
G1 X161.549 Y181.609 E.016
G1 X170.691 Y190.751 E.38648
G1 X171.226 Y190.751 E.016
G1 X161.549 Y181.074 E.4091
G1 X161.549 Y180.539 E.016
G1 X171.761 Y190.751 E.43173
G1 X172.297 Y190.751 E.016
G1 X161.549 Y180.003 E.45436
G1 X161.549 Y179.468 E.016
G1 X172.832 Y190.751 E.47698
G1 X173.367 Y190.751 E.016
M73 P87 R1
G1 X161.549 Y178.933 E.49961
G1 X161.549 Y178.398 E.016
G1 X173.902 Y190.751 E.52223
G1 X174.437 Y190.751 E.016
G1 X161.549 Y177.863 E.54486
M73 P88 R1
G1 X161.549 Y177.327 E.016
G1 X174.973 Y190.751 E.56749
G1 X175.508 Y190.751 E.016
G1 X161.549 Y176.792 E.59011
G1 X161.549 Y176.257 E.016
G1 X176.043 Y190.751 E.61274
G1 X176.578 Y190.751 E.016
G1 X161.549 Y175.722 E.63537
G1 X161.549 Y175.187 E.016
G1 X177.113 Y190.751 E.65799
G1 X177.649 Y190.751 E.016
G1 X161.549 Y174.651 E.68062
G1 X161.549 Y174.116 E.016
G1 X178.184 Y190.751 E.70324
G1 X178.719 Y190.751 E.016
G1 X161.549 Y173.581 E.72587
G1 X161.549 Y173.046 E.016
G1 X179.254 Y190.751 E.7485
G1 X179.789 Y190.751 E.016
G1 X161.549 Y172.511 E.77112
G1 X161.549 Y171.975 E.016
G1 X180.325 Y190.751 E.79375
G1 X180.86 Y190.751 E.016
G1 X161.549 Y171.44 E.81638
G1 X161.549 Y170.905 E.016
G1 X181.395 Y190.751 E.839
G1 X181.93 Y190.751 E.016
G1 X161.549 Y170.37 E.86163
G1 X161.549 Y169.835 E.016
G1 X182.465 Y190.751 E.88425
G1 X183.001 Y190.751 E.016
G1 X161.549 Y169.3 E.90688
G1 X161.549 Y168.764 E.016
G1 X183.536 Y190.751 E.92951
G1 X184.071 Y190.751 E.016
G1 X161.549 Y168.229 E.95213
G1 X161.549 Y167.694 E.016
G1 X184.606 Y190.751 E.97476
G1 X185.141 Y190.751 E.016
G1 X161.549 Y167.159 E.99739
G1 X161.549 Y166.624 E.016
G1 X185.676 Y190.751 E1.02001
G1 X186.212 Y190.751 E.016
G1 X161.549 Y166.088 E1.04264
G1 X161.549 Y165.553 E.016
G1 X186.747 Y190.751 E1.06526
G1 X187.282 Y190.751 E.016
G1 X161.549 Y165.018 E1.08789
G1 X161.549 Y164.483 E.016
G1 X187.817 Y190.751 E1.11052
G1 X188.352 Y190.751 E.016
G1 X161.549 Y163.948 E1.13314
G1 X161.549 Y163.412 E.016
G1 X188.451 Y190.314 E1.13729
G1 X188.451 Y189.778 E.016
G1 X161.549 Y162.877 E1.13729
G1 X161.549 Y162.342 E.016
G1 X188.451 Y189.243 E1.13729
G1 X188.451 Y188.708 E.016
G1 X161.549 Y161.807 E1.13729
G1 X161.549 Y161.272 E.016
G1 X188.451 Y188.173 E1.13729
G1 X188.451 Y187.638 E.016
G1 X161.549 Y160.736 E1.13729
G1 X161.549 Y160.201 E.016
G1 X188.451 Y187.102 E1.13729
G1 X188.451 Y186.567 E.016
G1 X161.549 Y159.666 E1.13729
G1 X161.549 Y159.131 E.016
G1 X188.451 Y186.032 E1.13729
G1 X188.451 Y185.497 E.016
G1 X161.549 Y158.596 E1.13729
G1 X161.549 Y158.06 E.016
G1 X188.451 Y184.962 E1.13729
G1 X188.451 Y184.426 E.016
G1 X161.549 Y157.525 E1.13729
G1 X161.549 Y156.99 E.016
G1 X188.451 Y183.891 E1.13729
G1 X188.451 Y183.356 E.016
G1 X161.549 Y156.455 E1.13729
G1 X161.549 Y155.92 E.016
G1 X188.451 Y182.821 E1.13729
G1 X188.451 Y182.286 E.016
G1 X161.549 Y155.384 E1.13729
G1 X161.549 Y154.849 E.016
G1 X188.451 Y181.751 E1.13729
G1 X188.451 Y181.215 E.016
M73 P89 R1
G1 X161.549 Y154.314 E1.13729
G1 X161.549 Y153.779 E.016
G1 X188.451 Y180.68 E1.13729
G1 X188.451 Y180.145 E.016
G1 X161.549 Y153.244 E1.13729
G1 X161.549 Y152.708 E.016
G1 X188.451 Y179.61 E1.13729
G1 X188.451 Y179.075 E.016
G1 X161.549 Y152.173 E1.13729
G1 X161.549 Y151.638 E.016
G1 X188.451 Y178.539 E1.13729
G1 X188.451 Y178.004 E.016
G1 X161.549 Y151.103 E1.13729
G1 X161.549 Y150.568 E.016
G1 X188.451 Y177.469 E1.13729
G1 X188.451 Y176.934 E.016
G1 X161.549 Y150.032 E1.13729
G1 X161.549 Y149.497 E.016
G1 X188.451 Y176.399 E1.13729
G1 X188.451 Y175.863 E.016
G1 X161.549 Y148.962 E1.13729
G1 X161.549 Y148.427 E.016
G1 X188.451 Y175.328 E1.13729
G1 X188.451 Y174.793 E.016
G1 X161.549 Y147.892 E1.13729
G1 X161.549 Y147.357 E.016
G1 X188.451 Y174.258 E1.13729
G1 X188.451 Y173.723 E.016
G1 X161.549 Y146.821 E1.13729
G1 X161.549 Y146.286 E.016
G1 X188.451 Y173.187 E1.13729
G1 X188.451 Y172.652 E.016
G1 X161.549 Y145.751 E1.13729
G1 X161.549 Y145.216 E.016
G1 X188.451 Y172.117 E1.13729
G1 X188.451 Y171.582 E.016
G1 X161.549 Y144.681 E1.13729
G1 X161.549 Y144.145 E.016
G1 X188.451 Y171.047 E1.13729
G1 X188.451 Y170.511 E.016
G1 X161.549 Y143.61 E1.13729
G1 X161.549 Y143.075 E.016
G1 X188.451 Y169.976 E1.13729
G1 X188.451 Y169.441 E.016
G1 X161.549 Y142.54 E1.13729
G1 X161.549 Y142.005 E.016
G1 X188.451 Y168.906 E1.13729
G1 X188.451 Y168.371 E.016
G1 X161.549 Y141.469 E1.13729
G1 X161.549 Y140.934 E.016
G1 X188.451 Y167.835 E1.13729
G1 X188.451 Y167.3 E.016
G1 X161.549 Y140.399 E1.13729
G1 X161.549 Y139.864 E.016
G1 X188.451 Y166.765 E1.13729
G1 X188.451 Y166.23 E.016
G1 X161.549 Y139.329 E1.13729
G1 X161.549 Y138.793 E.016
G1 X188.451 Y165.695 E1.13729
G1 X188.451 Y165.159 E.016
G1 X161.549 Y138.258 E1.13729
G1 X161.549 Y137.723 E.016
G1 X188.451 Y164.624 E1.13729
G1 X188.451 Y164.089 E.016
G1 X161.549 Y137.188 E1.13729
G1 X161.549 Y136.653 E.016
G1 X188.451 Y163.554 E1.13729
G1 X188.451 Y163.019 E.016
G1 X161.549 Y136.117 E1.13729
G1 X161.549 Y135.582 E.016
G1 X188.451 Y162.483 E1.13729
G1 X188.451 Y161.948 E.016
M73 P90 R1
G1 X161.549 Y135.047 E1.13729
G1 X161.549 Y134.512 E.016
G1 X188.451 Y161.413 E1.13729
G1 X188.451 Y160.878 E.016
G1 X161.549 Y133.977 E1.13729
G1 X161.549 Y133.441 E.016
G1 X188.451 Y160.343 E1.13729
G1 X188.451 Y159.808 E.016
G1 X161.549 Y132.906 E1.13729
G1 X161.549 Y132.371 E.016
G1 X188.451 Y159.272 E1.13729
G1 X188.451 Y158.737 E.016
G1 X161.549 Y131.836 E1.13729
G1 X161.549 Y131.301 E.016
G1 X188.451 Y158.202 E1.13729
G1 X188.451 Y157.667 E.016
G1 X161.549 Y130.765 E1.13729
G1 X161.549 Y130.23 E.016
G1 X188.451 Y157.132 E1.13729
G1 X188.451 Y156.596 E.016
G1 X161.549 Y129.695 E1.13729
G1 X161.549 Y129.16 E.016
G1 X188.451 Y156.061 E1.13729
G1 X188.451 Y155.526 E.016
G1 X161.549 Y128.625 E1.13729
G1 X161.549 Y128.089 E.016
G1 X188.451 Y154.991 E1.13729
G1 X188.451 Y154.456 E.016
G1 X161.549 Y127.554 E1.13729
G1 X161.549 Y127.019 E.016
G1 X188.451 Y153.92 E1.13729
G1 X188.451 Y153.385 E.016
G1 X161.549 Y126.484 E1.13729
G1 X161.549 Y125.949 E.016
G1 X188.451 Y152.85 E1.13729
G1 X188.451 Y152.315 E.016
G1 X161.549 Y125.414 E1.13729
G1 X161.549 Y124.878 E.016
G1 X188.451 Y151.78 E1.13729
G1 X188.451 Y151.244 E.016
G1 X161.549 Y124.343 E1.13729
G1 X161.549 Y123.808 E.016
G1 X188.451 Y150.709 E1.13729
G1 X188.451 Y150.174 E.016
G1 X161.549 Y123.273 E1.13729
G1 X161.549 Y122.738 E.016
G1 X188.451 Y149.639 E1.13729
G1 X188.451 Y149.104 E.016
G1 X161.549 Y122.202 E1.13729
G1 X161.549 Y121.667 E.016
G1 X188.451 Y148.568 E1.13729
G1 X188.451 Y148.033 E.016
G1 X161.549 Y121.132 E1.13729
G1 X161.549 Y120.597 E.016
G1 X188.451 Y147.498 E1.13729
G1 X188.451 Y146.963 E.016
G1 X161.549 Y120.062 E1.13729
G1 X161.549 Y119.526 E.016
G1 X188.451 Y146.428 E1.13729
G1 X188.451 Y145.892 E.016
G1 X161.549 Y118.991 E1.13729
G1 X161.549 Y118.456 E.016
G1 X188.451 Y145.357 E1.13729
G1 X188.451 Y144.822 E.016
G1 X161.549 Y117.921 E1.13729
G1 X161.549 Y117.386 E.016
G1 X188.451 Y144.287 E1.13729
G1 X188.451 Y143.752 E.016
G1 X161.549 Y116.85 E1.13729
G1 X161.549 Y116.449 E.01199
G1 X161.684 Y116.449 E.00401
G1 X188.451 Y143.216 E1.13162
G1 X188.451 Y142.681 E.016
G1 X162.219 Y116.449 E1.109
G1 X162.754 Y116.449 E.016
M73 P91 R1
G1 X188.451 Y142.146 E1.08637
G1 X188.451 Y141.611 E.016
G1 X163.289 Y116.449 E1.06374
G1 X163.824 Y116.449 E.016
G1 X188.451 Y141.076 E1.04112
G1 X188.451 Y140.541 E.016
G1 X164.36 Y116.449 E1.01849
G1 X164.895 Y116.449 E.016
G1 X188.451 Y140.005 E.99586
G1 X188.451 Y139.47 E.016
G1 X165.43 Y116.449 E.97324
G1 X165.965 Y116.449 E.016
G1 X188.451 Y138.935 E.95061
G1 X188.451 Y138.4 E.016
G1 X166.5 Y116.449 E.92799
G1 X167.035 Y116.449 E.016
G1 X188.451 Y137.865 E.90536
G1 X188.451 Y137.329 E.016
G1 X167.549 Y116.428 E.88363
G1 X167.549 Y115.893 E.016
G1 X188.451 Y136.794 E.88363
G1 X188.451 Y136.259 E.016
G1 X167.549 Y115.358 E.88363
G1 X167.549 Y114.822 E.016
G1 X188.451 Y135.724 E.88363
G1 X188.451 Y135.189 E.016
G1 X167.549 Y114.287 E.88363
G1 X167.549 Y113.752 E.016
G1 X188.451 Y134.653 E.88363
G1 X188.451 Y134.118 E.016
G1 X167.549 Y113.217 E.88363
G1 X167.549 Y112.682 E.016
G1 X188.451 Y133.583 E.88363
G1 X188.451 Y133.048 E.016
G1 X167.549 Y112.146 E.88363
G1 X167.549 Y111.749 E.01187
G1 X167.687 Y111.749 E.00413
G1 X188.451 Y132.513 E.8778
G1 X188.451 Y131.977 E.016
G1 X168.223 Y111.749 E.85517
G1 X168.758 Y111.749 E.016
G1 X188.451 Y131.442 E.83254
G1 X188.451 Y130.907 E.016
G1 X169.293 Y111.749 E.80992
G1 X169.828 Y111.749 E.016
G1 X188.451 Y130.372 E.78729
G1 X188.451 Y129.837 E.016
G1 X170.363 Y111.749 E.76467
G1 X170.899 Y111.749 E.016
G1 X188.451 Y129.301 E.74204
G1 X188.451 Y128.766 E.016
G1 X171.434 Y111.749 E.71941
G1 X171.969 Y111.749 E.016
G1 X188.451 Y128.231 E.69679
G1 X188.451 Y127.696 E.016
G1 X172.504 Y111.749 E.67416
G1 X173.039 Y111.749 E.016
G1 X188.451 Y127.161 E.65154
G1 X188.451 Y126.625 E.016
G1 X173.575 Y111.749 E.62891
G1 X174.11 Y111.749 E.016
G1 X188.451 Y126.09 E.60628
G1 X188.451 Y125.555 E.016
G1 X174.645 Y111.749 E.58366
G1 X175.18 Y111.749 E.016
G1 X188.62 Y125.19 E.5682
; WIPE_START
G1 X187.206 Y123.775 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X188.339 Y116.227 Z2.2 F60000
G1 X188.339 Y116.226 Z2.2
G1 Z1.8
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.436148
G1 F9154.994
M204 S8000
G1 X188.375 Y116.428 E.0064
; LINE_WIDTH: 0.400444
G1 F10069.252
G1 X188.41 Y116.631 E.00582
; LINE_WIDTH: 0.361768
G1 F11290.669
G1 X188.431 Y116.794 E.00412
; LINE_WIDTH: 0.324028
G1 F12806.483
G1 X188.449 Y116.939 E.00324
; LINE_WIDTH: 0.285147
G1 F14862.12
G1 X188.469 Y117.227 E.00554
; LINE_WIDTH: 0.258403
G1 F15000
G1 X188.468 Y117.796 E.00968
; LINE_WIDTH: 0.289647
G1 F14591.053
G1 X188.445 Y118.096 E.00586
; LINE_WIDTH: 0.332422
G1 F12435.147
G1 X188.426 Y118.248 E.0035
; LINE_WIDTH: 0.370217
G1 F10999.18
G1 X188.408 Y118.386 E.00359
; LINE_WIDTH: 0.40706
G1 F9886.312
G1 X188.372 Y118.588 E.00592
; LINE_WIDTH: 0.438777
G1 F9094.194
G1 X188.338 Y118.774 E.00591
M204 S10000
G1 X187.841 Y119.059 F60000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42136
G1 F9512.736
M204 S8000
G1 X188.451 Y119.668 E.02576
G1 X188.451 Y120.203 E.016
G1 X187.717 Y119.469 E.03102
G1 X187.449 Y119.736 E.01131
G1 X188.451 Y120.738 E.04237
G1 X188.451 Y121.273 E.016
G1 X187.135 Y119.958 E.05561
G3 X186.78 Y120.138 I-.777 J-1.092 E.01195
G1 X188.451 Y121.809 E.07062
G1 X188.451 Y122.344 E.016
G1 X186.395 Y120.288 E.0869
G3 X185.949 Y120.377 I-.656 J-2.119 E.01362
G1 X188.451 Y122.879 E.10576
G1 X188.451 Y123.414 E.016
G1 X185.425 Y120.389 E.12791
G3 X184.784 Y120.283 I.101 J-2.614 E.01946
G1 X188.451 Y123.949 E.155
G1 X188.451 Y124.485 E.016
G1 X175.715 Y111.749 E.5384
G1 X176.251 Y111.749 E.016
G1 X182.818 Y118.316 E.27764
G1 X182.714 Y117.807 E.01555
G1 X182.707 Y117.671 E.00407
G1 X176.786 Y111.749 E.25034
G1 X177.321 Y111.749 E.016
G1 X182.723 Y117.152 E.22839
G1 X182.813 Y116.706 E.01359
G1 X177.856 Y111.749 E.20955
G1 X178.391 Y111.749 E.016
G1 X182.962 Y116.32 E.19323
G3 X183.142 Y115.965 I1.281 J.426 E.01195
G1 X178.927 Y111.749 E.17821
G1 X179.462 Y111.749 E.016
G1 X183.364 Y115.652 E.16498
G1 X183.631 Y115.384 E.01131
G1 X179.997 Y111.749 E.15364
G1 X180.532 Y111.749 E.016
G1 X183.926 Y115.144 E.1435
G3 X184.251 Y114.933 I.895 J1.022 E.0116
G1 X181.067 Y111.749 E.13459
G1 X181.602 Y111.749 E.016
G1 X184.624 Y114.771 E.12776
G3 X185.052 Y114.663 I.58 J1.395 E.01322
G1 X182.138 Y111.749 E.12319
G1 X182.673 Y111.749 E.016
G1 X185.535 Y114.611 E.121
G3 X186.103 Y114.644 I.173 J1.931 E.01708
G1 X183.208 Y111.749 E.12239
G1 X183.743 Y111.749 E.016
G1 X186.905 Y114.911 E.13367
G1 X187.425 Y115.244 E.01844
G3 X188.034 Y115.941 I-1.754 J2.145 E.02781
G1 X188.405 Y115.876 E.01127
G1 X184.278 Y111.749 E.17444
G1 X184.814 Y111.749 E.016
G1 X188.451 Y115.386 E.15376
G1 X188.451 Y114.851 E.016
G1 X185.349 Y111.749 E.13113
G1 X185.884 Y111.749 E.016
G1 X188.451 Y114.316 E.10851
G1 X188.451 Y113.781 E.016
G1 X186.419 Y111.749 E.08588
G1 X186.954 Y111.749 E.016
G1 X188.451 Y113.246 E.06325
G1 X188.451 Y112.71 E.016
G1 X187.49 Y111.749 E.04063
G1 X188.025 Y111.749 E.016
G1 X188.62 Y112.345 E.02518
; CHANGE_LAYER
; Z_HEIGHT: 2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9512.736
G1 X188.025 Y111.749 E-.32001
G1 X187.49 Y111.749 E-.20337
G1 X187.93 Y112.19 E-.23662
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 10/10
; update layer progress
M73 L10
M991 S0 P9 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 1
M204 S10000
G17
G3 Z2.2 I-1.179 J-.301 P1  F60000
G1 X164.911 Y202.24 Z2.2
G1 Z2
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X165.14 Y202.359 E.00769
G3 X164.257 Y202.147 I-.74 J1.14 E.22682
G1 X164.383 Y202.14 E.00376
G3 X164.855 Y202.218 I.017 J1.359 E.01434
; COOLING_NODE: 0
; WIPE_START
M204 S8000
G1 X165.14 Y202.359 E-.12076
M73 P92 R1
G1 X165.345 Y202.522 E-.09946
G1 X165.515 Y202.72 E-.09916
G1 X165.645 Y202.953 E-.10131
G1 X165.73 Y203.216 E-.10532
G1 X165.76 Y203.475 E-.09891
G1 X165.74 Y203.736 E-.09965
G1 X165.714 Y203.826 E-.03542
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X167.353 Y196.372 Z2.4 F60000
G1 X184.948 Y116.307 Z2.4
G1 Z2
G1 E.8 F1800
G1 F9547.055
M204 S5000
G1 X185.186 Y116.204 E.00771
G3 X185.457 Y116.147 I.414 J1.295 E.00826
G1 X185.583 Y116.14 E.00376
G3 X184.896 Y116.336 I.017 J1.359 E.23288
; COOLING_NODE: 2
; WIPE_START
M204 S8000
G1 X185.186 Y116.204 E-.12103
G1 X185.457 Y116.147 E-.10522
G1 X185.583 Y116.14 E-.04792
G1 X185.859 Y116.165 E-.10523
G1 X186.108 Y116.238 E-.09903
G1 X186.34 Y116.359 E-.09917
G1 X186.545 Y116.522 E-.09949
G1 X186.687 Y116.688 E-.0829
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X184.891 Y124.106 Z2.4 F60000
G1 X168.39 Y192.29 Z2.4
G1 Z2
G1 E.8 F1800
G1 F9547.055
M204 S5000
G1 X168.39 Y209.79 E.52127
G1 X160.01 Y209.79 E.24961
G1 X160.01 Y114.91 E2.82615
G1 X166.01 Y114.91 E.17872
G1 X166.01 Y110.21 E.14
G1 X189.99 Y110.21 E.71428
G1 X189.99 Y192.29 E2.44488
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

G1 X168.45 Y192.29 E.6416
; WIPE_START
M204 S8000
G1 X168.443 Y194.29 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X176.032 Y193.477 Z2.4 F60000
G1 X189.044 Y192.083 Z2.4
G1 Z2
G1 E.8 F1800
; FEATURE: Top surface
G1 F9547.055
M204 S2000
G1 X189.783 Y191.344 E.03111
G1 X189.916 Y191.21
G1 X189.916 Y190.677
G1 X189.783 Y190.811
G1 X188.511 Y192.083 E.05357
G1 X188.377 Y192.216
G1 X187.844 Y192.216
G1 X187.978 Y192.083
G1 X189.783 Y190.278 E.07604
G1 X189.916 Y190.144
G1 X189.916 Y189.611
G1 X189.783 Y189.744
G1 X187.444 Y192.083 E.0985
G1 X187.311 Y192.216
G1 X186.777 Y192.216
G1 X186.911 Y192.083
G1 X189.783 Y189.211 E.12096
G1 X189.916 Y189.077
G1 X189.916 Y188.544
G1 X189.783 Y188.678
G1 X186.378 Y192.083 E.14343
G1 X186.244 Y192.216
G1 X185.711 Y192.216
G1 X185.845 Y192.083
G1 X189.783 Y188.145 E.16589
G1 X189.916 Y188.011
G1 X189.916 Y187.478
G1 X189.783 Y187.611
G1 X185.311 Y192.083 E.18835
G1 X185.178 Y192.216
G1 X184.644 Y192.216
G1 X184.778 Y192.083
G1 X189.783 Y187.078 E.21082
G1 X189.916 Y186.944
G1 X189.916 Y186.411
G1 X189.783 Y186.545
G1 X184.245 Y192.083 E.23328
G1 X184.111 Y192.216
G1 X183.578 Y192.216
G1 X183.712 Y192.083
G1 X189.783 Y186.011 E.25574
G1 X189.916 Y185.878
G1 X189.916 Y185.345
G1 X189.783 Y185.478
G1 X183.178 Y192.083 E.27821
G1 X183.045 Y192.216
G1 X182.511 Y192.216
G1 X182.645 Y192.083
G1 X189.783 Y184.945 E.30067
G1 X189.916 Y184.811
G1 X189.916 Y184.278
G1 X189.783 Y184.412
G1 X182.112 Y192.083 E.32313
G1 X181.978 Y192.216
G1 X181.445 Y192.216
G1 X181.578 Y192.083
G1 X189.783 Y183.878 E.3456
G1 X189.916 Y183.745
G1 X189.916 Y183.212
G1 X189.783 Y183.345
G1 X181.045 Y192.083 E.36806
G1 X180.912 Y192.216
G1 X180.378 Y192.216
G1 X180.512 Y192.083
G1 X189.783 Y182.812 E.39052
G1 X189.916 Y182.678
G1 X189.916 Y182.145
G1 X189.783 Y182.279
G1 X179.979 Y192.083 E.41299
G1 X179.845 Y192.216
G1 X179.312 Y192.216
G1 X179.445 Y192.083
G1 X189.783 Y181.745 E.43545
G1 X189.916 Y181.612
G1 X189.916 Y181.079
G1 X189.783 Y181.212
G1 X178.912 Y192.083 E.45791
G1 X178.779 Y192.216
G1 X178.245 Y192.216
G1 X178.379 Y192.083
G1 X189.783 Y180.679 E.48038
G1 X189.916 Y180.545
G1 X189.916 Y180.012
G1 X189.783 Y180.146
G1 X177.846 Y192.083 E.50284
G1 X177.712 Y192.216
G1 X177.179 Y192.216
G1 X177.312 Y192.083
G1 X189.783 Y179.612 E.5253
G1 X189.916 Y179.479
G1 X189.916 Y178.946
G1 X189.783 Y179.079
G1 X176.779 Y192.083 E.54777
G1 X176.646 Y192.216
G1 X176.112 Y192.216
G1 X176.246 Y192.083
G1 X189.783 Y178.546 E.57023
G1 X189.916 Y178.412
G1 X189.916 Y177.879
G1 X189.783 Y178.013
G1 X175.713 Y192.083 E.59269
G1 X175.579 Y192.216
G1 X175.046 Y192.216
G1 X175.179 Y192.083
G1 X189.783 Y177.479 E.61516
G1 X189.916 Y177.346
G1 X189.916 Y176.812
G1 X189.783 Y176.946
G1 X174.646 Y192.083 E.63762
G1 X174.512 Y192.216
G1 X173.979 Y192.216
G1 X174.113 Y192.083
G1 X189.783 Y176.413 E.66008
G1 X189.916 Y176.279
G1 X189.916 Y175.746
G1 X189.783 Y175.88
G1 X173.58 Y192.083 E.68255
G1 X173.446 Y192.216
G1 X172.913 Y192.216
G1 X173.046 Y192.083
G1 X189.783 Y175.346 E.70501
G1 X189.916 Y175.213
G1 X189.916 Y174.679
G1 X189.783 Y174.813
G1 X172.513 Y192.083 E.72747
G1 X172.379 Y192.216
G1 X171.846 Y192.216
G1 X171.98 Y192.083
G1 X189.783 Y174.28 E.74994
G1 X189.916 Y174.146
G1 X189.916 Y173.613
G1 X189.783 Y173.747
G1 X171.447 Y192.083 E.7724
G1 X171.313 Y192.216
G1 X170.78 Y192.216
G1 X170.913 Y192.083
G1 X189.783 Y173.213 E.79486
G1 X189.916 Y173.08
G1 X189.916 Y172.546
G1 X189.783 Y172.68
G1 X170.38 Y192.083 E.81733
G1 X170.246 Y192.216
G1 X169.713 Y192.216
G1 X169.847 Y192.083
G1 X189.783 Y172.147 E.83979
G1 X189.916 Y172.013
G1 X189.916 Y171.48
G1 X189.783 Y171.614
G1 X169.314 Y192.083 E.86225
G1 X169.18 Y192.216
G1 X168.647 Y192.216
G1 X168.78 Y192.083
G1 X189.783 Y171.08 E.88472
G1 X189.916 Y170.947
G1 X189.916 Y170.413
G1 X189.783 Y170.547
G1 X168.247 Y192.083 E.90718
; WIPE_START
M204 S8000
G1 X169.661 Y190.668 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X169.055 Y198.277 Z2.4 F60000
G1 X168.183 Y209.211 Z2.4
G1 Z2
G1 E.8 F1800
G1 F9547.055
M204 S2000
G1 X167.811 Y209.583 E.01564
G1 X167.678 Y209.716
G1 X167.144 Y209.716
G1 X167.278 Y209.583
G1 X168.183 Y208.678 E.03811
G1 X168.316 Y208.544
G1 X168.316 Y208.011
G1 X168.183 Y208.145
G1 X166.745 Y209.583 E.06057
G1 X166.611 Y209.716
G1 X166.078 Y209.716
G1 X166.211 Y209.583
G1 X168.183 Y207.612 E.08303
M73 P93 R1
G1 X168.316 Y207.478
G1 X168.316 Y206.945
G1 X168.183 Y207.078
G1 X165.678 Y209.583 E.1055
G1 X165.545 Y209.716
G1 X165.011 Y209.716
G1 X165.145 Y209.583
G1 X168.183 Y206.545 E.12796
G1 X168.316 Y206.411
G1 X168.316 Y205.878
G1 X168.183 Y206.012
G1 X164.612 Y209.583 E.15042
G1 X164.478 Y209.716
G1 X163.945 Y209.716
G1 X164.078 Y209.583
G1 X168.183 Y205.478 E.17289
G1 X168.316 Y205.345
G1 X168.316 Y204.812
G1 X168.183 Y204.945
G1 X163.545 Y209.583 E.19535
G1 X163.412 Y209.716
G1 X162.878 Y209.716
G1 X163.012 Y209.583
G1 X168.183 Y204.412 E.21781
G1 X168.316 Y204.278
G1 X168.316 Y203.745
G1 X168.183 Y203.879
G1 X162.479 Y209.583 E.24028
G1 X162.345 Y209.716
G1 X161.812 Y209.716
G1 X161.945 Y209.583
G1 X168.183 Y203.345 E.26274
G1 X168.316 Y203.212
G1 X168.316 Y202.679
G1 X168.183 Y202.812
G1 X161.412 Y209.583 E.2852
G1 X161.279 Y209.716
G1 X160.745 Y209.716
G1 X160.879 Y209.583
G1 X168.183 Y202.279 E.30767
; WIPE_START
M204 S8000
G1 X166.768 Y203.693 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X165.851 Y204.078 Z2.4 F60000
G1 Z2
G1 E.8 F1800
G1 F9547.055
M204 S2000
G1 X168.183 Y201.746 E.09824
G1 X168.316 Y201.612
G1 X168.316 Y201.079
G1 X168.183 Y201.212
G1 X165.96 Y203.435 E.09362
G1 X165.827 Y203.568
G1 X165.744 Y203.117
G1 X165.878 Y202.984
G1 X168.183 Y200.679 E.09708
G1 X168.316 Y200.546
G1 X168.316 Y200.012
G1 X168.183 Y200.146
G1 X165.697 Y202.631 E.10469
G1 X165.564 Y202.765
G1 X165.317 Y202.478
G1 X165.45 Y202.345
G1 X168.183 Y199.613 E.11509
G1 X168.316 Y199.479
G1 X168.316 Y198.946
G1 X168.183 Y199.079
G1 X165.141 Y202.121 E.12812
G1 X165.008 Y202.254
G1 X164.618 Y202.111
G1 X164.751 Y201.978
G1 X168.183 Y198.546 E.14455
G1 X168.316 Y198.412
G1 X168.316 Y197.879
G1 X168.183 Y198.013
G1 X164.256 Y201.94 E.16543
; WIPE_START
M204 S8000
G1 X165.67 Y200.526 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X164.976 Y204.952 Z2.4 F60000
G1 Z2
G1 E.8 F1800
G1 F9547.055
M204 S2000
G1 X160.346 Y209.583 E.19506
G1 X160.212 Y209.716
G1 X160.084 Y209.311
G1 X160.217 Y209.178
G1 X164.331 Y205.064 E.1733
G1 X164.465 Y204.93
G1 X164.02 Y204.841
G1 X163.887 Y204.975
G1 X160.217 Y208.644 E.15457
G1 X160.084 Y208.778
G1 X160.084 Y208.245
G1 X160.217 Y208.111
G1 X163.531 Y204.797 E.1396
G1 X163.665 Y204.663
G1 X163.376 Y204.42
G1 X163.242 Y204.553
G1 X160.217 Y207.578 E.12741
G1 X160.084 Y207.712
G1 X160.084 Y207.178
G1 X160.217 Y207.045
G1 X163.02 Y204.242 E.11806
G1 X163.154 Y204.108
G1 X163.012 Y203.717
G1 X162.878 Y203.85
G1 X160.217 Y206.511 E.11209
G1 X160.084 Y206.645
G1 X160.084 Y206.112
G1 X160.217 Y205.978
G1 X162.841 Y203.354 E.11053
; WIPE_START
M204 S8000
G1 X161.427 Y204.768 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X160.217 Y205.445 Z2.4 F60000
G1 Z2
G1 E.8 F1800
G1 F9547.055
M204 S2000
G1 X168.183 Y197.48 E.33553
G1 X168.316 Y197.346
G1 X168.316 Y196.813
G1 X168.183 Y196.946
G1 X160.217 Y204.912 E.33553
G1 X160.084 Y205.045
G1 X160.084 Y204.512
G1 X160.217 Y204.378
G1 X168.183 Y196.413 E.33553
G1 X168.316 Y196.279
G1 X168.316 Y195.746
G1 X168.183 Y195.88
G1 X160.217 Y203.845 E.33553
G1 X160.084 Y203.979
G1 X160.084 Y203.445
G1 X160.217 Y203.312
G1 X168.183 Y195.347 E.33553
G1 X168.316 Y195.213
G1 X168.316 Y194.68
G1 X168.183 Y194.813
G1 X160.217 Y202.779 E.33553
G1 X160.084 Y202.912
G1 X160.084 Y202.379
G1 X160.217 Y202.245
G1 X168.183 Y194.28 E.33553
G1 X168.316 Y194.146
G1 X168.316 Y193.613
G1 X168.183 Y193.747
G1 X160.217 Y201.712 E.33553
G1 X160.084 Y201.846
G1 X160.084 Y201.312
G1 X160.217 Y201.179
G1 X168.183 Y193.214 E.33553
G1 X168.316 Y193.08
G1 X168.316 Y192.547
G1 X168.183 Y192.68
G1 X160.217 Y200.646 E.33553
G1 X160.084 Y200.779
G1 X160.084 Y200.246
G1 X160.217 Y200.112
G1 X168.183 Y192.147 E.33553
; WIPE_START
M204 S8000
G1 X166.768 Y193.561 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X161.148 Y198.725 Z2.4 F60000
G1 X160.217 Y199.579 Z2.4
G1 Z2
G1 E.8 F1800
G1 F9547.055
M204 S2000
G1 X189.783 Y170.014 E1.24542
G1 X189.916 Y169.88
G1 X189.916 Y169.347
G1 X189.783 Y169.481
G1 X160.217 Y199.046 E1.24542
G1 X160.084 Y199.179
G1 X160.084 Y198.646
G1 X160.217 Y198.513
G1 X189.783 Y168.947 E1.24542
G1 X189.916 Y168.814
G1 X189.916 Y168.28
G1 X189.783 Y168.414
G1 X160.217 Y197.979 E1.24542
G1 X160.084 Y198.113
G1 X160.084 Y197.58
G1 X160.217 Y197.446
G1 X189.783 Y167.881 E1.24542
G1 X189.916 Y167.747
G1 X189.916 Y167.214
G1 X189.783 Y167.347
G1 X160.217 Y196.913 E1.24542
G1 X160.084 Y197.046
G1 X160.084 Y196.513
G1 X160.217 Y196.379
G1 X189.783 Y166.814 E1.24542
G1 X189.916 Y166.681
G1 X189.916 Y166.147
G1 X189.783 Y166.281
G1 X160.217 Y195.846 E1.24542
G1 X160.084 Y195.98
G1 X160.084 Y195.447
G1 X160.217 Y195.313
G1 X189.783 Y165.748 E1.24542
G1 X189.916 Y165.614
G1 X189.916 Y165.081
G1 X189.783 Y165.214
G1 X160.217 Y194.78 E1.24542
G1 X160.084 Y194.913
G1 X160.084 Y194.38
G1 X160.217 Y194.246
G1 X189.783 Y164.681 E1.24542
G1 X189.916 Y164.548
G1 X189.916 Y164.014
G1 X189.783 Y164.148
G1 X160.217 Y193.713 E1.24542
G1 X160.084 Y193.847
G1 X160.084 Y193.314
G1 X160.217 Y193.18
G1 X189.783 Y163.615 E1.24542
G1 X189.916 Y163.481
G1 X189.916 Y162.948
G1 X189.783 Y163.081
G1 X160.217 Y192.647 E1.24542
G1 X160.084 Y192.78
G1 X160.084 Y192.247
G1 X160.217 Y192.113
G1 X189.783 Y162.548 E1.24542
G1 X189.916 Y162.415
G1 X189.916 Y161.881
G1 X189.783 Y162.015
G1 X160.217 Y191.58 E1.24542
G1 X160.084 Y191.714
G1 X160.084 Y191.181
G1 X160.217 Y191.047
M73 P94 R0
G1 X189.783 Y161.482 E1.24542
G1 X189.916 Y161.348
G1 X189.916 Y160.815
G1 X189.783 Y160.948
G1 X160.217 Y190.514 E1.24542
G1 X160.084 Y190.647
G1 X160.084 Y190.114
G1 X160.217 Y189.98
G1 X189.783 Y160.415 E1.24542
G1 X189.916 Y160.282
G1 X189.916 Y159.748
G1 X189.783 Y159.882
G1 X160.217 Y189.447 E1.24542
G1 X160.084 Y189.581
G1 X160.084 Y189.048
G1 X160.217 Y188.914
G1 X189.783 Y159.349 E1.24542
G1 X189.916 Y159.215
G1 X189.916 Y158.682
G1 X189.783 Y158.815
G1 X160.217 Y188.381 E1.24542
G1 X160.084 Y188.514
G1 X160.084 Y187.981
G1 X160.217 Y187.847
G1 X189.783 Y158.282 E1.24542
G1 X189.916 Y158.148
G1 X189.916 Y157.615
G1 X189.783 Y157.749
G1 X160.217 Y187.314 E1.24542
G1 X160.084 Y187.448
G1 X160.084 Y186.914
G1 X160.217 Y186.781
G1 X189.783 Y157.216 E1.24542
G1 X189.916 Y157.082
G1 X189.916 Y156.549
G1 X189.783 Y156.682
G1 X160.217 Y186.248 E1.24542
G1 X160.084 Y186.381
G1 X160.084 Y185.848
G1 X160.217 Y185.714
G1 X189.783 Y156.149 E1.24542
G1 X189.916 Y156.015
G1 X189.916 Y155.482
G1 X189.783 Y155.616
G1 X160.217 Y185.181 E1.24542
G1 X160.084 Y185.315
G1 X160.084 Y184.781
G1 X160.217 Y184.648
G1 X189.783 Y155.083 E1.24542
G1 X189.916 Y154.949
G1 X189.916 Y154.416
G1 X189.783 Y154.549
G1 X160.217 Y184.115 E1.24542
G1 X160.084 Y184.248
G1 X160.084 Y183.715
G1 X160.217 Y183.581
G1 X189.783 Y154.016 E1.24542
G1 X189.916 Y153.882
G1 X189.916 Y153.349
G1 X189.783 Y153.483
G1 X160.217 Y183.048 E1.24542
G1 X160.084 Y183.182
G1 X160.084 Y182.648
G1 X160.217 Y182.515
G1 X189.783 Y152.95 E1.24542
G1 X189.916 Y152.816
G1 X189.916 Y152.283
G1 X189.783 Y152.416
G1 X160.217 Y181.982 E1.24542
G1 X160.084 Y182.115
G1 X160.084 Y181.582
G1 X160.217 Y181.448
G1 X189.783 Y151.883 E1.24542
G1 X189.916 Y151.749
G1 X189.916 Y151.216
G1 X189.783 Y151.35
G1 X160.217 Y180.915 E1.24542
G1 X160.084 Y181.049
G1 X160.084 Y180.515
G1 X160.217 Y180.382
G1 X189.783 Y150.817 E1.24542
G1 X189.916 Y150.683
G1 X189.916 Y150.15
G1 X189.783 Y150.283
G1 X160.217 Y179.849 E1.24542
G1 X160.084 Y179.982
G1 X160.084 Y179.449
G1 X160.217 Y179.315
G1 X189.783 Y149.75 E1.24542
G1 X189.916 Y149.616
G1 X189.916 Y149.083
G1 X189.783 Y149.217
G1 X160.217 Y178.782 E1.24542
G1 X160.084 Y178.916
G1 X160.084 Y178.382
G1 X160.217 Y178.249
G1 X189.783 Y148.683 E1.24542
G1 X189.916 Y148.55
G1 X189.916 Y148.017
G1 X189.783 Y148.15
G1 X160.217 Y177.715 E1.24542
G1 X160.084 Y177.849
G1 X160.084 Y177.316
G1 X160.217 Y177.182
G1 X189.783 Y147.617 E1.24542
G1 X189.916 Y147.483
G1 X189.916 Y146.95
G1 X189.783 Y147.084
G1 X160.217 Y176.649 E1.24542
G1 X160.084 Y176.783
G1 X160.084 Y176.249
G1 X160.217 Y176.116
G1 X189.783 Y146.55 E1.24542
G1 X189.916 Y146.417
G1 X189.916 Y145.884
G1 X189.783 Y146.017
G1 X160.217 Y175.582 E1.24542
G1 X160.084 Y175.716
G1 X160.084 Y175.183
G1 X160.217 Y175.049
M73 P95 R0
G1 X189.783 Y145.484 E1.24542
G1 X189.916 Y145.35
G1 X189.916 Y144.817
G1 X189.783 Y144.951
G1 X160.217 Y174.516 E1.24542
G1 X160.084 Y174.65
G1 X160.084 Y174.116
G1 X160.217 Y173.983
G1 X189.783 Y144.417 E1.24542
G1 X189.916 Y144.284
G1 X189.916 Y143.751
G1 X189.783 Y143.884
G1 X160.217 Y173.449 E1.24542
G1 X160.084 Y173.583
G1 X160.084 Y173.05
G1 X160.217 Y172.916
G1 X189.783 Y143.351 E1.24542
G1 X189.916 Y143.217
G1 X189.916 Y142.684
G1 X189.783 Y142.818
G1 X160.217 Y172.383 E1.24542
G1 X160.084 Y172.517
G1 X160.084 Y171.983
G1 X160.217 Y171.85
G1 X189.783 Y142.284 E1.24542
G1 X189.916 Y142.151
G1 X189.916 Y141.617
G1 X189.783 Y141.751
G1 X160.217 Y171.316 E1.24542
G1 X160.084 Y171.45
G1 X160.084 Y170.917
G1 X160.217 Y170.783
G1 X189.783 Y141.218 E1.24542
G1 X189.916 Y141.084
G1 X189.916 Y140.551
G1 X189.783 Y140.685
G1 X160.217 Y170.25 E1.24542
G1 X160.084 Y170.384
G1 X160.084 Y169.85
G1 X160.217 Y169.717
G1 X189.783 Y140.151 E1.24542
G1 X189.916 Y140.018
G1 X189.916 Y139.484
G1 X189.783 Y139.618
G1 X160.217 Y169.183 E1.24542
G1 X160.084 Y169.317
G1 X160.084 Y168.784
G1 X160.217 Y168.65
G1 X189.783 Y139.085 E1.24542
G1 X189.916 Y138.951
G1 X189.916 Y138.418
G1 X189.783 Y138.552
G1 X160.217 Y168.117 E1.24542
G1 X160.084 Y168.25
G1 X160.084 Y167.717
G1 X160.217 Y167.584
G1 X189.783 Y138.018 E1.24542
G1 X189.916 Y137.885
G1 X189.916 Y137.351
G1 X189.783 Y137.485
G1 X160.217 Y167.05 E1.24542
G1 X160.084 Y167.184
G1 X160.084 Y166.651
G1 X160.217 Y166.517
G1 X189.783 Y136.952 E1.24542
G1 X189.916 Y136.818
G1 X189.916 Y136.285
G1 X189.783 Y136.419
G1 X160.217 Y165.984 E1.24542
G1 X160.084 Y166.117
G1 X160.084 Y165.584
G1 X160.217 Y165.451
G1 X189.783 Y135.885 E1.24542
G1 X189.916 Y135.752
G1 X189.916 Y135.218
G1 X189.783 Y135.352
G1 X160.217 Y164.917 E1.24542
G1 X160.084 Y165.051
G1 X160.084 Y164.518
G1 X160.217 Y164.384
G1 X189.783 Y134.819 E1.24542
G1 X189.916 Y134.685
G1 X189.916 Y134.152
G1 X189.783 Y134.286
G1 X160.217 Y163.851 E1.24542
G1 X160.084 Y163.984
G1 X160.084 Y163.451
G1 X160.217 Y163.318
G1 X189.783 Y133.752 E1.24542
G1 X189.916 Y133.619
G1 X189.916 Y133.085
G1 X189.783 Y133.219
G1 X160.217 Y162.784 E1.24542
G1 X160.084 Y162.918
G1 X160.084 Y162.385
G1 X160.217 Y162.251
G1 X189.783 Y132.686 E1.24542
G1 X189.916 Y132.552
G1 X189.916 Y132.019
G1 X189.783 Y132.153
G1 X160.217 Y161.718 E1.24542
G1 X160.084 Y161.851
G1 X160.084 Y161.318
G1 X160.217 Y161.184
G1 X189.783 Y131.619 E1.24542
G1 X189.916 Y131.486
G1 X189.916 Y130.952
G1 X189.783 Y131.086
G1 X160.217 Y160.651 E1.24542
G1 X160.084 Y160.785
G1 X160.084 Y160.252
G1 X160.217 Y160.118
G1 X189.783 Y130.553 E1.24542
G1 X189.916 Y130.419
G1 X189.916 Y129.886
G1 X189.783 Y130.019
G1 X160.217 Y159.585 E1.24542
G1 X160.084 Y159.718
G1 X160.084 Y159.185
G1 X160.217 Y159.051
M73 P96 R0
G1 X189.783 Y129.486 E1.24542
G1 X189.916 Y129.353
G1 X189.916 Y128.819
G1 X189.783 Y128.953
G1 X160.217 Y158.518 E1.24542
G1 X160.084 Y158.652
G1 X160.084 Y158.119
G1 X160.217 Y157.985
G1 X189.783 Y128.42 E1.24542
G1 X189.916 Y128.286
G1 X189.916 Y127.753
G1 X189.783 Y127.886
G1 X160.217 Y157.452 E1.24542
G1 X160.084 Y157.585
G1 X160.084 Y157.052
G1 X160.217 Y156.918
G1 X189.783 Y127.353 E1.24542
G1 X189.916 Y127.22
G1 X189.916 Y126.686
G1 X189.783 Y126.82
G1 X160.217 Y156.385 E1.24542
G1 X160.084 Y156.519
G1 X160.084 Y155.986
G1 X160.217 Y155.852
G1 X189.783 Y126.287 E1.24542
G1 X189.916 Y126.153
G1 X189.916 Y125.62
G1 X189.783 Y125.753
G1 X160.217 Y155.319 E1.24542
G1 X160.084 Y155.452
G1 X160.084 Y154.919
G1 X160.217 Y154.785
G1 X189.783 Y125.22 E1.24542
G1 X189.916 Y125.087
G1 X189.916 Y124.553
G1 X189.783 Y124.687
G1 X160.217 Y154.252 E1.24542
G1 X160.084 Y154.386
G1 X160.084 Y153.853
G1 X160.217 Y153.719
G1 X189.783 Y124.154 E1.24542
G1 X189.916 Y124.02
G1 X189.916 Y123.487
G1 X189.783 Y123.62
G1 X160.217 Y153.186 E1.24542
G1 X160.084 Y153.319
G1 X160.084 Y152.786
G1 X160.217 Y152.652
G1 X189.783 Y123.087 E1.24542
G1 X189.916 Y122.953
G1 X189.916 Y122.42
G1 X189.783 Y122.554
G1 X160.217 Y152.119 E1.24542
G1 X160.084 Y152.253
G1 X160.084 Y151.719
G1 X160.217 Y151.586
G1 X189.783 Y122.021 E1.24542
G1 X189.916 Y121.887
G1 X189.916 Y121.354
G1 X189.783 Y121.487
G1 X160.217 Y151.053 E1.24542
G1 X160.084 Y151.186
G1 X160.084 Y150.653
G1 X160.217 Y150.519
G1 X189.783 Y120.954 E1.24542
G1 X189.916 Y120.82
G1 X189.916 Y120.287
G1 X189.783 Y120.421
G1 X160.217 Y149.986 E1.24542
G1 X160.084 Y150.12
G1 X160.084 Y149.586
G1 X160.217 Y149.453
G1 X189.783 Y119.888 E1.24542
G1 X189.916 Y119.754
G1 X189.916 Y119.221
G1 X189.783 Y119.354
G1 X160.217 Y148.92 E1.24542
G1 X160.084 Y149.053
G1 X160.084 Y148.52
G1 X160.217 Y148.386
G1 X189.783 Y118.821 E1.24542
G1 X189.916 Y118.687
G1 X189.916 Y118.154
G1 X189.783 Y118.288
G1 X160.217 Y147.853 E1.24542
G1 X160.084 Y147.987
G1 X160.084 Y147.453
G1 X160.217 Y147.32
G1 X189.783 Y117.755 E1.24542
G1 X189.916 Y117.621
G1 X189.916 Y117.088
G1 X189.783 Y117.221
G1 X160.217 Y146.787 E1.24542
G1 X160.084 Y146.92
G1 X160.084 Y146.387
G1 X160.217 Y146.253
G1 X189.783 Y116.688 E1.24542
G1 X189.916 Y116.554
G1 X189.916 Y116.021
G1 X189.783 Y116.155
G1 X160.217 Y145.72 E1.24542
G1 X160.084 Y145.854
G1 X160.084 Y145.32
G1 X160.217 Y145.187
G1 X189.783 Y115.622 E1.24542
G1 X189.916 Y115.488
G1 X189.916 Y114.955
G1 X189.783 Y115.088
G1 X187.145 Y117.726 E.11112
G1 X187.011 Y117.86
G1 X187 Y117.338
G1 X187.134 Y117.204
G1 X189.783 Y114.555 E.11159
G1 X189.916 Y114.421
G1 X189.916 Y113.888
G1 X189.783 Y114.022
G1 X186.999 Y116.805 E.11726
G1 X186.865 Y116.939
G1 X186.657 Y116.614
G1 X186.791 Y116.481
G1 X189.783 Y113.488 E.12604
G1 X189.916 Y113.355
G1 X189.916 Y112.822
G1 X189.783 Y112.955
G1 X186.51 Y116.228 E.13788
G1 X186.376 Y116.362
G1 X186.028 Y116.177
G1 X186.162 Y116.043
G1 X189.783 Y112.422 E.15254
G1 X189.916 Y112.288
G1 X189.916 Y111.755
G1 X189.783 Y111.889
G1 X185.734 Y115.937 E.17055
G1 X185.6 Y116.071
G1 X185.001 Y116.137
G1 X185.135 Y116.003
G1 X189.783 Y111.355 E.19578
; WIPE_START
M204 S8000
G1 X188.368 Y112.77 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X185.821 Y119.05 Z2.4 F60000
M73 P97 R0
G1 Z2
G1 E.8 F1800
G1 F9547.055
M204 S2000
G1 X160.217 Y144.654 E1.07853
G1 X160.084 Y144.787
G1 X160.084 Y144.254
G1 X160.217 Y144.12
G1 X185.305 Y119.032 E1.05682
G1 X185.439 Y118.899
G1 X185.035 Y118.769
G1 X184.901 Y118.903
G1 X160.217 Y143.587 E1.03981
G1 X160.084 Y143.721
G1 X160.084 Y143.187
G1 X160.217 Y143.054
G1 X184.582 Y118.689 E1.02636
G1 X184.716 Y118.555
G1 X184.463 Y118.275
G1 X184.329 Y118.409
G1 X160.217 Y142.52 E1.01569
G1 X160.084 Y142.654
G1 X160.084 Y142.121
G1 X160.217 Y141.987
G1 X184.142 Y118.062 E1.00783
G1 X184.276 Y117.929
G1 X184.175 Y117.496
G1 X184.041 Y117.63
G1 X160.217 Y141.454 E1.00358
G1 X160.084 Y141.588
G1 X160.084 Y141.054
G1 X160.217 Y140.921
G1 X184.109 Y117.029 E1.00643
; WIPE_START
M204 S8000
G1 X182.695 Y118.443 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X187.893 Y112.854 Z2.4 F60000
G1 X189.783 Y110.822 Z2.4
G1 Z2
G1 E.8 F1800
G1 F9547.055
M204 S2000
G1 X160.217 Y140.387 E1.24542
G1 X160.084 Y140.521
G1 X160.084 Y139.988
G1 X160.217 Y139.854
G1 X189.654 Y110.417 E1.24001
G1 X189.788 Y110.284
G1 X189.255 Y110.284
G1 X189.121 Y110.417
G1 X160.217 Y139.321 E1.21755
G1 X160.084 Y139.455
G1 X160.084 Y138.921
G1 X160.217 Y138.788
G1 X188.588 Y110.417 E1.19509
G1 X188.721 Y110.284
G1 X188.188 Y110.284
G1 X188.054 Y110.417
G1 X160.217 Y138.254 E1.17262
G1 X160.084 Y138.388
G1 X160.084 Y137.855
G1 X160.217 Y137.721
G1 X187.521 Y110.417 E1.15016
G1 X187.655 Y110.284
G1 X187.122 Y110.284
G1 X186.988 Y110.417
G1 X160.217 Y137.188 E1.1277
G1 X160.084 Y137.322
G1 X160.084 Y136.788
G1 X160.217 Y136.655
G1 X186.455 Y110.417 E1.10523
G1 X186.588 Y110.284
G1 X186.055 Y110.284
G1 X185.921 Y110.417
G1 X160.217 Y136.121 E1.08277
G1 X160.084 Y136.255
G1 X160.084 Y135.722
G1 X160.217 Y135.588
G1 X185.388 Y110.417 E1.06031
G1 X185.522 Y110.284
G1 X184.989 Y110.284
G1 X184.855 Y110.417
G1 X160.217 Y135.055 E1.03784
G1 X160.084 Y135.189
G1 X160.084 Y134.655
G1 X160.217 Y134.522
G1 X184.322 Y110.417 E1.01538
G1 X184.455 Y110.284
G1 X183.922 Y110.284
G1 X183.788 Y110.417
G1 X160.217 Y133.988 E.99292
G1 X160.084 Y134.122
G1 X160.084 Y133.589
G1 X160.217 Y133.455
G1 X183.255 Y110.417 E.97046
G1 X183.389 Y110.284
G1 X182.855 Y110.284
G1 X182.722 Y110.417
G1 X160.217 Y132.922 E.94799
G1 X160.084 Y133.055
G1 X160.084 Y132.522
G1 X160.217 Y132.389
M73 P98 R0
G1 X182.189 Y110.417 E.92553
G1 X182.322 Y110.284
G1 X181.789 Y110.284
G1 X181.655 Y110.417
G1 X160.217 Y131.855 E.90307
G1 X160.084 Y131.989
G1 X160.084 Y131.456
G1 X160.217 Y131.322
G1 X181.122 Y110.417 E.8806
G1 X181.256 Y110.284
G1 X180.722 Y110.284
G1 X180.589 Y110.417
G1 X160.217 Y130.789 E.85814
G1 X160.084 Y130.922
G1 X160.084 Y130.389
G1 X160.217 Y130.256
G1 X180.056 Y110.417 E.83568
G1 X180.189 Y110.284
G1 X179.656 Y110.284
G1 X179.522 Y110.417
G1 X160.217 Y129.722 E.81321
G1 X160.084 Y129.856
G1 X160.084 Y129.323
G1 X160.217 Y129.189
G1 X178.989 Y110.417 E.79075
G1 X179.123 Y110.284
G1 X178.589 Y110.284
G1 X178.456 Y110.417
G1 X160.217 Y128.656 E.76829
G1 X160.084 Y128.789
G1 X160.084 Y128.256
G1 X160.217 Y128.123
G1 X177.923 Y110.417 E.74582
G1 X178.056 Y110.284
G1 X177.523 Y110.284
G1 X177.389 Y110.417
G1 X160.217 Y127.589 E.72336
G1 X160.084 Y127.723
G1 X160.084 Y127.19
G1 X160.217 Y127.056
G1 X176.856 Y110.417 E.7009
G1 X176.99 Y110.284
G1 X176.456 Y110.284
G1 X176.323 Y110.417
G1 X160.217 Y126.523 E.67843
G1 X160.084 Y126.656
G1 X160.084 Y126.123
G1 X160.217 Y125.989
G1 X175.79 Y110.417 E.65597
G1 X175.923 Y110.284
G1 X175.39 Y110.284
G1 X175.256 Y110.417
G1 X160.217 Y125.456 E.63351
G1 X160.084 Y125.59
G1 X160.084 Y125.057
G1 X160.217 Y124.923
G1 X174.723 Y110.417 E.61104
G1 X174.857 Y110.284
G1 X174.323 Y110.284
G1 X174.19 Y110.417
G1 X160.217 Y124.39 E.58858
G1 X160.084 Y124.523
G1 X160.084 Y123.99
G1 X160.217 Y123.856
G1 X173.656 Y110.417 E.56612
G1 X173.79 Y110.284
G1 X173.257 Y110.284
G1 X173.123 Y110.417
G1 X160.217 Y123.323 E.54365
G1 X160.084 Y123.457
G1 X160.084 Y122.924
G1 X160.217 Y122.79
G1 X172.59 Y110.417 E.52119
G1 X172.724 Y110.284
G1 X172.19 Y110.284
G1 X172.057 Y110.417
G1 X160.217 Y122.257 E.49873
G1 X160.084 Y122.39
G1 X160.084 Y121.857
G1 X160.217 Y121.723
G1 X171.523 Y110.417 E.47626
G1 X171.657 Y110.284
G1 X171.124 Y110.284
G1 X170.99 Y110.417
G1 X160.217 Y121.19 E.4538
G1 X160.084 Y121.324
G1 X160.084 Y120.791
G1 X160.217 Y120.657
G1 X165.757 Y115.117 E.23335
G1 X165.891 Y114.984
G1 X165.357 Y114.984
G1 X165.224 Y115.117
G1 X160.217 Y120.124 E.21089
G1 X160.084 Y120.257
G1 X160.084 Y119.724
G1 X160.217 Y119.59
G1 X164.69 Y115.117 E.18842
G1 X164.824 Y114.984
G1 X164.291 Y114.984
G1 X164.157 Y115.117
G1 X160.217 Y119.057 E.16596
G1 X160.084 Y119.191
G1 X160.084 Y118.658
G1 X160.217 Y118.524
G1 X163.624 Y115.117 E.1435
G1 X163.758 Y114.984
G1 X163.224 Y114.984
G1 X163.091 Y115.117
G1 X160.217 Y117.991 E.12103
G1 X160.084 Y118.124
G1 X160.084 Y117.591
G1 X160.217 Y117.457
G1 X162.557 Y115.117 E.09857
G1 X162.691 Y114.984
G1 X162.158 Y114.984
G1 X162.024 Y115.117
G1 X160.217 Y116.924 E.07611
G1 X160.084 Y117.058
G1 X160.084 Y116.524
G1 X160.217 Y116.391
G1 X161.491 Y115.117 E.05365
G1 X161.625 Y114.984
G1 X161.091 Y114.984
G1 X160.958 Y115.117
G1 X160.217 Y115.858 E.03118
; WIPE_START
M204 S8000
G1 X160.958 Y115.117 E-.3978
G1 X161.091 Y114.984 E-.07182
G1 X161.625 Y114.984 E-.20264
G1 X161.491 Y115.117 E-.07182
G1 X161.461 Y115.147 E-.01593
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X166.217 Y114.657 Z2.4 F60000
G1 Z2
G1 E.8 F1800
G1 F9547.055
M204 S2000
G1 X170.457 Y110.417 E.17859
G1 X170.591 Y110.284
G1 X170.057 Y110.284
G1 X169.924 Y110.417
G1 X166.217 Y114.124 E.15613
G1 X166.084 Y114.257
G1 X166.084 Y113.724
G1 X166.217 Y113.59
G1 X169.39 Y110.417 E.13366
G1 X169.524 Y110.284
G1 X168.991 Y110.284
G1 X168.857 Y110.417
G1 X166.217 Y113.057 E.1112
G1 X166.084 Y113.191
G1 X166.084 Y112.658
G1 X166.217 Y112.524
G1 X168.324 Y110.417 E.08874
G1 X168.458 Y110.284
G1 X167.924 Y110.284
G1 X167.791 Y110.417
G1 X166.217 Y111.991 E.06627
G1 X166.084 Y112.124
G1 X166.084 Y111.591
G1 X166.217 Y111.457
G1 X167.257 Y110.417 E.04381
G1 X167.391 Y110.284
G1 X166.858 Y110.284
G1 X166.724 Y110.417
G1 X166.217 Y110.924 E.02135
; WIPE_START
M204 S8000
G1 X166.724 Y110.417 E-.27233
G1 X166.858 Y110.284 E-.07182
G1 X167.391 Y110.284 E-.20264
G1 X167.257 Y110.417 E-.07182
G1 X166.994 Y110.68 E-.1414
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X174 Y113.71 Z2.4 F60000
G1 X186.147 Y118.964 Z2.4
G1 Z2
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.104212
G1 F15000
M204 S8000
G3 X185.894 Y119.123 I-1.754 J-2.515 E.00145
; WIPE_START
G1 X186.147 Y118.964 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X184.356 Y116.544 Z2.4 F60000
G1 Z2
G1 E.8 F1800
; LINE_WIDTH: 0.104717
G1 F15000
M204 S8000
G1 X184.258 Y116.667 E.00077
; LINE_WIDTH: 0.148317
G2 X184.039 Y116.959 I2.802 J2.329 E.00304
; WIPE_START
G1 X184.258 Y116.667 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X184.792 Y116.136 Z2.4 F60000
G1 Z2
G1 E.8 F1800
; LINE_WIDTH: 0.101829
G1 F15000
M204 S8000
G1 X184.627 Y116.274 E.001
; WIPE_START
G1 X184.792 Y116.136 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X182.928 Y123.537 Z2.4 F60000
G1 X162.9 Y203.054 Z2.4
G1 Z2
G1 E.8 F1800
; LINE_WIDTH: 0.0942021
G1 F15000
M204 S8000
G2 X162.768 Y203.281 I2.195 J1.437 E.00106
; WIPE_START
G1 X162.9 Y203.054 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X165.913 Y204.14 Z2.4 F60000
G1 Z2
G1 E.8 F1800
; LINE_WIDTH: 0.202291
G1 F15000
M204 S8000
G1 X165.844 Y204.245 E.00158
; LINE_WIDTH: 0.176822
G1 X165.748 Y204.364 E.00162
; LINE_WIDTH: 0.130366
G1 X165.652 Y204.483 E.00106
G3 X165.42 Y204.718 I-24.378 J-23.761 E.00228
; LINE_WIDTH: 0.135891
G1 X165.305 Y204.814 E.0011
; LINE_WIDTH: 0.164437
G1 X165.179 Y204.918 E.00156
; LINE_WIDTH: 0.196265
G1 X165.038 Y205.014 E.00207
; close powerlost recovery
M1003 S0
; WIPE_START
G1 F15000
G1 X165.179 Y204.918 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z2.4 I1.217 J0 P1  F60000
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
G1 Z2.4 F900 ; lower z a little
M1002 judge_flag timelapse_record_flag
M622 J1
    G150.3
    M400 ; wait all motion done
    M991 S0 P-1 ;end smooth timelapse at safe pos
    M400 S5 ;wait for last picture to be taken
M623  ;end of "timelapse_record_flag"

G90
G1 Z12 F900 ; lower z a little

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

    
        G1 Z101 F600
M73 P99 R0
        G1 Z99
    

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

