; HEADER_BLOCK_START
; BambuStudio 02.08.02.61
; model printing time: 8m 7s; total estimated time: 13m 34s
; total layer number: 50
; total filament length [mm] : 313.83
; total filament volume [cm^3] : 754.84
; total filament weight [g] : 0.96
; filament_density: 1.27
; filament_diameter: 1.75
; max_z_height: 10.00
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
M73 P0 R13
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
M73 P3 R13
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
M73 P6 R12
G1 Z5 F1200
G90
G1 X175 Y160 F30000

M622 J1
    M1002 gcode_claim_action : 1
    G29.20 A3
    G29 A1 O X166.193 Y151.193 I17.6131 J17.6131 R
    M400
M623

M622 J2
    M1002 gcode_claim_action : 1
    
        G29.20 A4
        G29 A2 O X166.193 Y151.193 I17.6131 J17.6131 R
    
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
M73 P37 R8
G1 Z5 F1200
M73 P38 R8
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
; layer num/total_layer_count: 1/50
; update layer progress
M73 L1
M991 S0 P0 ;notify layer change

M106 S0
M106 P2 S0
; OBJECT_ID: 15
M73 P39 R8
G1 X167.372 Y152.574 F60000
M204 S6000
M73 P40 R8
G1 Z.4
G1 Z.2
G1 E.8 F1800
; FEATURE: Brim
; LINE_WIDTH: 0.5
G1 F3000
M204 S500
G1 X167.788 Y152.19 E.02045
G1 X168.263 Y151.878 E.02053
G1 X168.644 Y151.7 E.01517
G1 X169.288 Y151.498 E.02439
G1 X170.012 Y151.422 E.02627
G1 X179.991 Y151.422 E.36029
G1 X180.56 Y151.469 E.02062
G1 X181.471 Y151.752 E.03446
G1 X181.978 Y152.025 E.02079
G1 X182.426 Y152.372 E.02045
G1 X182.81 Y152.788 E.02045
G1 X183.122 Y153.262 E.02048
G1 X183.339 Y153.743 E.01907
G1 X183.502 Y154.287 E.0205
G1 X183.578 Y155.012 E.02632
G1 X183.578 Y164.991 E.36028
G1 X183.531 Y165.56 E.02062
G1 X183.289 Y166.375 E.03072
G1 X182.974 Y166.98 E.0246
G1 X182.628 Y167.426 E.02039
G1 X182.212 Y167.81 E.02045
G1 X181.738 Y168.122 E.02048
G1 X181.257 Y168.339 E.01907
G1 X180.713 Y168.502 E.0205
G1 X179.988 Y168.578 E.02632
G1 X170.009 Y168.578 E.36028
G1 X169.44 Y168.531 E.02062
G1 X168.625 Y168.289 E.03072
G1 X168.02 Y167.974 E.0246
G1 X167.574 Y167.628 E.02039
G1 X167.19 Y167.212 E.02045
G1 X166.878 Y166.738 E.02048
G1 X166.661 Y166.257 E.01907
G1 X166.498 Y165.713 E.0205
G1 X166.422 Y164.988 E.02632
G1 X166.422 Y155.009 E.36029
G1 X166.469 Y154.44 E.02062
G1 X166.711 Y153.625 E.03072
G1 X167.026 Y153.02 E.0246
G1 X167.335 Y152.621 E.01823
M204 S6000
G1 X167.697 Y152.904 F60000
G1 F3000
M204 S500
G1 X167.718 Y152.876 E.00127
G1 X168.079 Y152.545 E.0177
G1 X168.478 Y152.283 E.0172
G1 X168.801 Y152.131 E.01291
G1 X169.395 Y151.946 E.02246
G1 X170.043 Y151.879 E.02351
G1 X179.977 Y151.88 E.35869
G1 X180.486 Y151.925 E.01845
G1 X181.281 Y152.171 E.03004
G1 X181.718 Y152.404 E.01788
G1 X182.107 Y152.703 E.01771
G1 X182.441 Y153.062 E.0177
G1 X182.714 Y153.474 E.01784
G1 X182.912 Y153.912 E.01739
G1 X183.053 Y154.39 E.01798
G1 X183.121 Y155.043 E.0237
G1 X183.121 Y164.966 E.35828
G1 X183.075 Y165.489 E.01894
G1 X182.867 Y166.191 E.02644
G1 X182.58 Y166.742 E.02243
G1 X182.282 Y167.124 E.0175
G1 X181.938 Y167.441 E.01689
G1 X181.508 Y167.724 E.01861
G1 X181.088 Y167.912 E.01661
G1 X180.635 Y168.048 E.01706
G1 X179.971 Y168.12 E.02411
G1 X170.023 Y168.12 E.3592
G1 X169.511 Y168.075 E.01853
G1 X168.809 Y167.867 E.02644
G1 X168.258 Y167.58 E.02243
G1 X167.876 Y167.282 E.0175
G1 X167.559 Y166.938 E.01689
G1 X167.276 Y166.508 E.01861
G1 X167.088 Y166.088 E.01661
G1 X166.952 Y165.635 E.01706
G1 X166.88 Y164.971 E.02411
G1 X166.88 Y155.023 E.35921
G1 X166.925 Y154.511 E.01853
G1 X167.133 Y153.809 E.02644
G1 X167.42 Y153.258 E.02243
G1 X167.66 Y152.951 E.01407
M204 S6000
G1 X168.022 Y153.231 F60000
G1 F3000
M204 S500
G1 X168.048 Y153.196 E.00156
G1 X168.37 Y152.901 E.0158
G1 X168.694 Y152.689 E.01396
G1 X168.959 Y152.562 E.01061
G1 X169.501 Y152.395 E.02049
G1 X170.06 Y152.337 E.02026
G1 X179.951 Y152.337 E.35714
G1 X180.411 Y152.38 E.0167
G1 X181.092 Y152.591 E.02574
G1 X181.46 Y152.784 E.01499
G1 X181.789 Y153.035 E.01496
G1 X182.073 Y153.337 E.01496
G1 X182.306 Y153.686 E.01516
G1 X182.486 Y154.081 E.01565
G1 X182.604 Y154.492 E.01543
G1 X182.664 Y155.074 E.02113
G1 X182.663 Y164.952 E.35666
G1 X182.62 Y165.416 E.01683
G1 X182.445 Y166.006 E.02222
G1 X182.2 Y166.482 E.01934
G1 X181.951 Y166.804 E.01469
G1 X181.646 Y167.086 E.01499
G1 X181.296 Y167.316 E.01512
G1 X180.936 Y167.48 E.01429
G1 X180.531 Y167.6 E.01523
G1 X179.939 Y167.663 E.02151
G1 X170.037 Y167.663 E.35753
G1 X169.584 Y167.62 E.01641
G1 X168.994 Y167.445 E.02223
G1 X168.518 Y167.2 E.01934
G1 X168.196 Y166.951 E.01469
G1 X167.914 Y166.646 E.01499
G1 X167.684 Y166.296 E.01512
G1 X167.521 Y165.936 E.01429
G1 X167.4 Y165.531 E.01523
G1 X167.337 Y164.939 E.02151
G1 X167.337 Y155.037 E.35754
G1 X167.38 Y154.584 E.01641
G1 X167.555 Y153.994 E.02223
G1 X167.8 Y153.518 E.01934
G1 X167.985 Y153.278 E.01092
M204 S6000
G1 X168.349 Y153.555 F60000
G1 F3000
M204 S500
G1 X168.379 Y153.516 E.00177
G1 X168.661 Y153.256 E.01386
G1 X168.911 Y153.093 E.01076
G1 X169.116 Y152.993 E.00826
G1 X169.58 Y152.849 E.01754
G1 X170.076 Y152.795 E.01801
G1 X179.936 Y152.794 E.35599
G1 X180.335 Y152.835 E.01448
G1 X180.905 Y153.012 E.02156
G1 X181.203 Y153.166 E.01212
G1 X181.473 Y153.369 E.0122
G1 X181.706 Y153.614 E.01222
G1 X181.899 Y153.9 E.01245
G1 X182.052 Y154.231 E.01315
G1 X182.155 Y154.591 E.01354
G1 X182.207 Y155.104 E.01861
G1 X182.206 Y164.924 E.35456
G1 X182.165 Y165.342 E.01515
G1 X182.023 Y165.823 E.01811
G1 X181.818 Y166.225 E.01628
G1 X181.62 Y166.486 E.01183
G1 X181.355 Y166.731 E.01305
G1 X181.084 Y166.909 E.01168
G1 X180.784 Y167.046 E.01192
G1 X180.429 Y167.151 E.01338
G1 X179.907 Y167.206 E.01893
G1 X170.052 Y167.205 E.35584
G1 X169.659 Y167.165 E.01427
G1 X169.177 Y167.023 E.01814
G1 X168.775 Y166.818 E.01628
G1 X168.514 Y166.62 E.01183
G1 X168.269 Y166.355 E.01305
G1 X168.091 Y166.084 E.01168
G1 X167.954 Y165.784 E.01192
G1 X167.849 Y165.429 E.01338
G1 X167.794 Y164.907 E.01893
G1 X167.795 Y155.052 E.35585
G1 X167.835 Y154.659 E.01427
G1 X167.977 Y154.177 E.01814
G1 X168.182 Y153.775 E.01629
G1 X168.313 Y153.603 E.00781
M204 S6000
G1 X168.666 Y153.911 F60000
G1 F3000
M204 S500
G1 X168.821 Y153.734 E.0085
G1 X168.92 Y153.65 E.0047
G1 X169.302 Y153.417 E.01613
G1 X169.528 Y153.337 E.00865
G1 X170.035 Y153.25 E.01858
G1 X179.97 Y153.25 E.35873
G1 X180.361 Y153.304 E.01423
G1 X180.699 Y153.421 E.0129
G1 X181.094 Y153.663 E.01672
G1 X181.354 Y153.926 E.01338
G1 X181.534 Y154.204 E.01194
G1 X181.633 Y154.428 E.00886
G1 X181.75 Y155.036 E.02235
G1 X181.75 Y164.97 E.35868
G1 X181.696 Y165.361 E.01424
G1 X181.579 Y165.699 E.0129
G1 X181.337 Y166.094 E.01672
G1 X181.074 Y166.354 E.01339
G1 X180.796 Y166.533 E.01193
G1 X180.572 Y166.633 E.00886
G1 X179.964 Y166.75 E.02235
G1 X170.03 Y166.75 E.35868
G1 X169.639 Y166.696 E.01424
G1 X169.301 Y166.579 E.0129
G1 X168.906 Y166.337 E.01672
G1 X168.646 Y166.074 E.01339
G1 X168.467 Y165.796 E.01194
G1 X168.367 Y165.572 E.00886
G1 X168.25 Y164.964 E.02236
G1 X168.269 Y154.832 E.3658
G1 X168.338 Y154.519 E.01159
G1 X168.44 Y154.258 E.0101
G1 X168.599 Y153.988 E.01131
G1 X168.627 Y153.956 E.00154
M204 S6000
G1 X168.99 Y154.225 F60000
G1 F3000
M204 S500
G1 X169.162 Y154.038 E.00919
G1 X169.461 Y153.845 E.01284
G1 X169.605 Y153.788 E.00561
G1 X170.023 Y153.707 E.01536
G1 X179.98 Y153.707 E.3595
G1 X180.221 Y153.739 E.00878
G1 X180.463 Y153.812 E.00913
G1 X180.777 Y153.992 E.01307
G1 X180.962 Y154.162 E.00908
G1 X181.155 Y154.461 E.01284
G1 X181.212 Y154.605 E.00561
G1 X181.293 Y155.023 E.01536
G1 X181.293 Y164.98 E.3595
G1 X181.261 Y165.221 E.00878
G1 X181.188 Y165.463 E.00913
G1 X181.008 Y165.777 E.01307
M73 P41 R8
G1 X180.838 Y165.963 E.00908
G1 X180.539 Y166.155 E.01283
G1 X180.395 Y166.212 E.00561
G1 X179.977 Y166.293 E.01536
G1 X170.02 Y166.293 E.3595
G1 X169.779 Y166.261 E.00878
G1 X169.537 Y166.188 E.00913
G1 X169.223 Y166.008 E.01307
G1 X169.038 Y165.838 E.00908
G1 X168.845 Y165.539 E.01283
G1 X168.788 Y165.395 E.00561
G1 X168.707 Y164.977 E.01536
G1 X168.715 Y154.929 E.36278
G1 X168.76 Y154.696 E.00857
G1 X168.87 Y154.415 E.01088
G1 X168.958 Y154.276 E.00597
M204 S6000
G1 X169.345 Y154.519 F60000
G1 F3000
M204 S500
G1 X169.383 Y154.458 E.00261
G1 X169.485 Y154.36 E.00513
G1 X169.698 Y154.235 E.0089
G1 X170.01 Y154.164 E.01155
G1 X179.989 Y154.164 E.3603
G1 X180.155 Y154.191 E.00607
G1 X180.33 Y154.25 E.00666
G1 X180.542 Y154.383 E.00905
G1 X180.64 Y154.485 E.00513
G1 X180.765 Y154.698 E.0089
G1 X180.836 Y155.01 E.01155
G1 X180.836 Y164.989 E.3603
G1 X180.809 Y165.155 E.00607
G1 X180.751 Y165.33 E.00666
G1 X180.617 Y165.542 E.00905
M73 P41 R7
G1 X180.515 Y165.64 E.00513
G1 X180.302 Y165.765 E.0089
G1 X179.99 Y165.836 E.01155
G1 X170.011 Y165.836 E.3603
G1 X169.845 Y165.809 E.00607
G1 X169.67 Y165.75 E.00666
G1 X169.458 Y165.617 E.00905
G1 X169.36 Y165.515 E.00513
G1 X169.235 Y165.302 E.0089
G1 X169.164 Y164.99 E.01155
G1 X169.164 Y155.011 E.3603
G1 X169.191 Y154.845 E.00607
G1 X169.25 Y154.67 E.00666
G1 X169.313 Y154.57 E.00427
M204 S6000
G1 X169.688 Y154.799 F60000
G1 F3000
M204 S500
G1 X169.814 Y154.677 E.00631
G1 X170 Y154.621 E.007
G1 X180 Y154.621 E.36106
G1 X180.201 Y154.688 E.00766
G1 X180.323 Y154.814 E.00631
G1 X180.379 Y155 E.007
G1 X180.379 Y165 E.36106
G1 X180.312 Y165.201 E.00766
G1 X180.186 Y165.323 E.00631
G1 X180 Y165.379 E.007
G1 X170 Y165.379 E.36106
G1 X169.799 Y165.312 E.00766
G1 X169.677 Y165.186 E.00631
G1 X169.621 Y165 E.007
G1 X169.621 Y155 E.36106
G1 X169.67 Y154.856 E.00549
; WIPE_START
G1 X169.814 Y154.677 E-.08729
G1 X170 Y154.621 E-.07367
G1 X171.576 Y154.621 E-.59903
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X176.359 Y160.57 Z.6 F60000
G1 X179.6 Y164.6 Z.6
G1 Z.2
G1 E.8 F1800
; FEATURE: Outer wall
G1 F3000
M204 S500
G1 X170.4 Y164.6 E.33218
G1 X170.4 Y155.4 E.33218
G1 X179.6 Y155.4 E.33218
G1 X179.6 Y164.54 E.33001
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
G1 X179.143 Y164.143 F60000
; FEATURE: Inner wall
G1 F3000
M204 S500
G1 X170.857 Y164.143 E.29917
G1 X170.857 Y155.857 E.29917
G1 X179.143 Y155.857 E.29917
G1 X179.143 Y164.083 E.297
M204 S6000
G1 X178.686 Y163.686 F60000
G1 F3000
M204 S500
G1 X171.314 Y163.686 E.26616
G1 X171.314 Y156.314 E.26616
G1 X178.686 Y156.314 E.26616
G1 X178.686 Y163.626 E.264
M204 S6000
G1 X178.229 Y163.229 F60000
G1 F3000
M204 S500
G1 X171.771 Y163.229 E.23316
G1 X171.771 Y156.771 E.23316
G1 X178.229 Y156.771 E.23316
G1 X178.229 Y163.169 E.23099
; WIPE_START
G1 X176.229 Y163.187 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X177.069 Y156.954 Z.6 F60000
G1 Z.2
G1 E.8 F1800
; FEATURE: Bottom surface
; LINE_WIDTH: 0.52513
G1 F6300
M204 S500
G1 X177.84 Y157.726 E.04156
G1 X177.84 Y158.408 E.02598
G1 X176.592 Y157.16 E.06722
G1 X175.91 Y157.16 E.02598
G1 X177.84 Y159.09 E.10396
G1 X177.84 Y159.771 E.02598
G1 X175.229 Y157.16 E.14069
G1 X174.547 Y157.16 E.02598
G1 X177.84 Y160.453 E.17743
G1 X177.84 Y161.135 E.02598
G1 X173.865 Y157.16 E.21416
G1 X173.183 Y157.16 E.02598
G1 X177.84 Y161.817 E.2509
G1 X177.84 Y162.499 E.02598
G1 X172.501 Y157.16 E.28764
G1 X172.16 Y157.16 E.01299
G1 X172.16 Y157.501 E.01299
M73 P42 R7
G1 X177.499 Y162.84 E.28764
G1 X176.817 Y162.84 E.02598
G1 X172.16 Y158.183 E.25091
G1 X172.16 Y158.865 E.02598
G1 X176.135 Y162.84 E.21417
G1 X175.454 Y162.84 E.02598
G1 X172.16 Y159.546 E.17743
G1 X172.16 Y160.228 E.02598
G1 X174.772 Y162.84 E.1407
G1 X174.09 Y162.84 E.02598
G1 X172.16 Y160.91 E.10396
G1 X172.16 Y161.592 E.02598
G1 X173.408 Y162.84 E.06723
G1 X172.726 Y162.84 E.02598
G1 X171.954 Y162.069 E.04157
; CHANGE_LAYER
; Z_HEIGHT: 0.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F6300
G1 X172.726 Y162.84 E-.41471
G1 X173.408 Y162.84 E-.25914
G1 X173.247 Y162.68 E-.08615
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 2/50
; update layer progress
M73 L2
M991 S0 P1 ;notify layer change

; open powerlost recovery
M1003 S1
; OBJECT_ID: 15
M204 S10000
G17
G3 Z.6 I-.203 J1.2 P1  F60000
G1 X178.584 Y163.584 Z.6
G1 Z.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1298
M204 S8000
G1 X171.416 Y163.584 E.23048
G1 X171.416 Y156.416 E.23048
G1 X178.584 Y156.416 E.23048
G1 X178.584 Y163.524 E.22855
M204 S10000
G1 X178.991 Y163.991 F60000
G1 F1298
M204 S8000
G1 X171.009 Y163.991 E.25666
G1 X171.009 Y156.009 E.25666
G1 X178.991 Y156.009 E.25666
G1 X178.991 Y163.931 E.25473
M204 S10000
G1 X179.398 Y164.398 F60000
G1 F1298
M204 S8000
G1 X170.602 Y164.398 E.28284
G1 X170.602 Y155.602 E.28284
G1 X179.398 Y155.602 E.28284
G1 X179.398 Y164.338 E.28091
M204 S250
G1 X179.79 Y164.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1298
M204 S5000
G1 X170.21 Y164.79 E.28536
G1 X170.21 Y155.21 E.28536
G1 X179.79 Y155.21 E.28536
G1 X179.79 Y164.73 E.28357
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
G1 X177.79 Y164.743 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
M73 P43 R7
G1 X177.632 Y163.42 Z.8 F60000
G1 Z.4
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.432
G1 F1298
M204 S8000
G1 X178.251 Y162.802 E.02686
G1 X178.251 Y162.252 E.01691
G1 X177.252 Y163.251 E.04341
G1 X176.702 Y163.251 E.01691
G1 X178.251 Y161.702 E.06732
G1 X178.251 Y161.151 E.01691
G1 X176.151 Y163.251 E.09124
G1 X175.601 Y163.251 E.01691
G1 X178.251 Y160.601 E.11515
G1 X178.251 Y160.051 E.01691
G1 X175.051 Y163.251 E.13907
G1 X174.501 Y163.251 E.01691
G1 X178.251 Y159.501 E.16299
G1 X178.251 Y158.95 E.01691
G1 X173.95 Y163.251 E.1869
G1 X173.4 Y163.251 E.01691
G1 X178.251 Y158.4 E.21082
G1 X178.251 Y157.85 E.01691
G1 X172.85 Y163.251 E.23474
G1 X172.3 Y163.251 E.01691
G1 X178.251 Y157.3 E.25865
G1 X178.251 Y156.75 E.01691
G1 X171.749 Y163.251 E.28257
G1 X171.749 Y162.7 E.01691
G1 X177.7 Y156.749 E.25866
G1 X177.15 Y156.749 E.01691
G1 X171.749 Y162.15 E.23474
G1 X171.749 Y161.6 E.01691
G1 X176.6 Y156.749 E.21082
G1 X176.05 Y156.749 E.01691
G1 X171.749 Y161.05 E.18691
G1 X171.749 Y160.499 E.01691
G1 X175.499 Y156.749 E.16299
G1 X174.949 Y156.749 E.01691
G1 X171.749 Y159.949 E.13907
G1 X171.749 Y159.399 E.01691
G1 X174.399 Y156.749 E.11516
G1 X173.849 Y156.749 E.01691
G1 X171.749 Y158.849 E.09124
G1 X171.749 Y158.298 E.01691
G1 X173.298 Y156.749 E.06732
G1 X172.748 Y156.749 E.01691
G1 X171.749 Y157.748 E.04341
G1 X171.749 Y157.198 E.01691
G1 X172.368 Y156.58 E.02687
; CHANGE_LAYER
; Z_HEIGHT: 0.6
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9252.596
G1 X171.749 Y157.198 E-.33219
G1 X171.749 Y157.748 E-.20909
G1 X172.156 Y157.341 E-.21872
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 3/50
; update layer progress
M73 L3
M991 S0 P2 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z.8 I-.848 J.873 P1  F60000
G1 X178.584 Y163.584 Z.8
G1 Z.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1298
M204 S8000
G1 X171.416 Y163.584 E.23048
G1 X171.416 Y156.416 E.23048
G1 X178.584 Y156.416 E.23048
G1 X178.584 Y163.524 E.22855
; COOLING_NODE: 0
M204 S10000
G1 X178.991 Y163.991 F60000
G1 F1298
M204 S8000
G1 X171.009 Y163.991 E.25666
G1 X171.009 Y156.009 E.25666
G1 X178.991 Y156.009 E.25666
G1 X178.991 Y163.931 E.25473
; COOLING_NODE: 0
M204 S10000
G1 X179.398 Y164.398 F60000
M73 P44 R7
G1 F1298
M204 S8000
G1 X170.602 Y164.398 E.28284
G1 X170.602 Y155.602 E.28284
G1 X179.398 Y155.602 E.28284
G1 X179.398 Y164.338 E.28091
; COOLING_NODE: 0
M204 S250
G1 X179.79 Y164.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1298
M204 S5000
G1 X170.21 Y164.79 E.28536
G1 X170.21 Y155.21 E.28536
G1 X179.79 Y155.21 E.28536
G1 X179.79 Y164.73 E.28357
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
G1 X177.79 Y164.743 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X178.42 Y157.368 Z1 F60000
G1 Z.6
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.432
G1 F1298
M204 S8000
G1 X177.802 Y156.749 E.02686
G1 X177.252 Y156.749 E.01691
G1 X178.251 Y157.748 E.0434
G1 X178.251 Y158.298 E.01691
G1 X176.702 Y156.749 E.06732
G1 X176.151 Y156.749 E.01691
G1 X178.251 Y158.849 E.09124
G1 X178.251 Y159.399 E.01691
G1 X175.601 Y156.749 E.11515
G1 X175.051 Y156.749 E.01691
G1 X178.251 Y159.949 E.13907
G1 X178.251 Y160.499 E.01691
G1 X174.501 Y156.749 E.16299
G1 X173.95 Y156.749 E.01691
G1 X178.251 Y161.05 E.1869
G1 X178.251 Y161.6 E.01691
G1 X173.4 Y156.749 E.21082
G1 X172.85 Y156.749 E.01691
G1 X178.251 Y162.15 E.23474
G1 X178.251 Y162.7 E.01691
G1 X172.3 Y156.749 E.25865
G1 X171.75 Y156.749 E.01691
G1 X178.251 Y163.251 E.28257
G1 X177.7 Y163.251 E.01691
G1 X171.749 Y157.3 E.25866
G1 X171.749 Y157.85 E.01691
G1 X177.15 Y163.251 E.23474
G1 X176.6 Y163.251 E.01691
G1 X171.749 Y158.4 E.21082
G1 X171.749 Y158.95 E.01691
M73 P45 R7
G1 X176.05 Y163.251 E.18691
G1 X175.499 Y163.251 E.01691
G1 X171.749 Y159.501 E.16299
G1 X171.749 Y160.051 E.01691
G1 X174.949 Y163.251 E.13907
G1 X174.399 Y163.251 E.01691
G1 X171.749 Y160.601 E.11516
G1 X171.749 Y161.151 E.01691
G1 X173.849 Y163.251 E.09124
G1 X173.298 Y163.251 E.01691
G1 X171.749 Y161.702 E.06733
G1 X171.749 Y162.252 E.01691
G1 X172.748 Y163.251 E.04341
G1 X172.198 Y163.251 E.01691
G1 X171.58 Y162.632 E.02687
; CHANGE_LAYER
; Z_HEIGHT: 0.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9252.596
G1 X172.198 Y163.251 E-.33219
G1 X172.748 Y163.251 E-.20909
G1 X172.341 Y162.844 E-.21872
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 4/50
; update layer progress
M73 L4
M991 S0 P3 ;notify layer change

M106 S226.95
; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z1 I-.143 J1.208 P1  F60000
G1 X178.584 Y163.584 Z1
G1 Z.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1298
M204 S8000
G1 X171.416 Y163.584 E.23048
G1 X171.416 Y156.416 E.23048
G1 X178.584 Y156.416 E.23048
G1 X178.584 Y163.524 E.22855
; COOLING_NODE: 0
M204 S10000
G1 X178.991 Y163.991 F60000
G1 F1298
M204 S8000
G1 X171.009 Y163.991 E.25666
G1 X171.009 Y156.009 E.25666
G1 X178.991 Y156.009 E.25666
G1 X178.991 Y163.931 E.25473
; COOLING_NODE: 0
M204 S10000
G1 X179.398 Y164.398 F60000
G1 F1298
M204 S8000
G1 X170.602 Y164.398 E.28284
G1 X170.602 Y155.602 E.28284
G1 X179.398 Y155.602 E.28284
G1 X179.398 Y164.338 E.28091
; COOLING_NODE: 0
M204 S250
G1 X179.79 Y164.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1298
M204 S5000
G1 X170.21 Y164.79 E.28536
G1 X170.21 Y155.21 E.28536
G1 X179.79 Y155.21 E.28536
G1 X179.79 Y164.73 E.28357
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
G1 X177.79 Y164.743 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
M73 P46 R7
G1 X177.632 Y163.42 Z1.2 F60000
G1 Z.8
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.432
G1 F1298
M204 S8000
G1 X178.251 Y162.802 E.02686
G1 X178.251 Y162.252 E.01691
G1 X177.252 Y163.251 E.04341
G1 X176.702 Y163.251 E.01691
G1 X178.251 Y161.702 E.06732
G1 X178.251 Y161.151 E.01691
G1 X176.151 Y163.251 E.09124
G1 X175.601 Y163.251 E.01691
G1 X178.251 Y160.601 E.11515
G1 X178.251 Y160.051 E.01691
G1 X175.051 Y163.251 E.13907
G1 X174.501 Y163.251 E.01691
G1 X178.251 Y159.501 E.16299
G1 X178.251 Y158.95 E.01691
G1 X173.95 Y163.251 E.1869
G1 X173.4 Y163.251 E.01691
G1 X178.251 Y158.4 E.21082
G1 X178.251 Y157.85 E.01691
G1 X172.85 Y163.251 E.23474
G1 X172.3 Y163.251 E.01691
G1 X178.251 Y157.3 E.25865
G1 X178.251 Y156.75 E.01691
G1 X171.749 Y163.251 E.28257
G1 X171.749 Y162.7 E.01691
G1 X177.7 Y156.749 E.25866
G1 X177.15 Y156.749 E.01691
G1 X171.749 Y162.15 E.23474
G1 X171.749 Y161.6 E.01691
G1 X176.6 Y156.749 E.21082
G1 X176.05 Y156.749 E.01691
G1 X171.749 Y161.05 E.18691
G1 X171.749 Y160.499 E.01691
G1 X175.499 Y156.749 E.16299
G1 X174.949 Y156.749 E.01691
G1 X171.749 Y159.949 E.13907
G1 X171.749 Y159.399 E.01691
G1 X174.399 Y156.749 E.11516
G1 X173.849 Y156.749 E.01691
G1 X171.749 Y158.849 E.09124
G1 X171.749 Y158.298 E.01691
G1 X173.298 Y156.749 E.06732
G1 X172.748 Y156.749 E.01691
G1 X171.749 Y157.748 E.04341
G1 X171.749 Y157.198 E.01691
G1 X172.368 Y156.58 E.02687
; CHANGE_LAYER
; Z_HEIGHT: 1
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9252.596
G1 X171.749 Y157.198 E-.33219
G1 X171.749 Y157.748 E-.20909
G1 X172.156 Y157.341 E-.21872
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 5/50
; update layer progress
M73 L5
M991 S0 P4 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z1.2 I-.848 J.873 P1  F60000
G1 X178.584 Y163.584 Z1.2
G1 Z1
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1298
M204 S8000
G1 X171.416 Y163.584 E.23048
G1 X171.416 Y156.416 E.23048
G1 X178.584 Y156.416 E.23048
G1 X178.584 Y163.524 E.22855
; COOLING_NODE: 0
M204 S10000
G1 X178.991 Y163.991 F60000
G1 F1298
M204 S8000
G1 X171.009 Y163.991 E.25666
G1 X171.009 Y156.009 E.25666
G1 X178.991 Y156.009 E.25666
G1 X178.991 Y163.931 E.25473
; COOLING_NODE: 0
M204 S10000
G1 X179.398 Y164.398 F60000
M73 P47 R7
G1 F1298
M204 S8000
G1 X170.602 Y164.398 E.28284
G1 X170.602 Y155.602 E.28284
G1 X179.398 Y155.602 E.28284
G1 X179.398 Y164.338 E.28091
; COOLING_NODE: 0
M204 S250
G1 X179.79 Y164.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1298
M204 S5000
G1 X170.21 Y164.79 E.28536
G1 X170.21 Y155.21 E.28536
G1 X179.79 Y155.21 E.28536
G1 X179.79 Y164.73 E.28357
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
G1 X177.79 Y164.743 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X178.42 Y157.368 Z1.4 F60000
G1 Z1
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.432
G1 F1298
M204 S8000
G1 X177.802 Y156.749 E.02686
G1 X177.252 Y156.749 E.01691
G1 X178.251 Y157.748 E.0434
G1 X178.251 Y158.298 E.01691
G1 X176.702 Y156.749 E.06732
G1 X176.151 Y156.749 E.01691
G1 X178.251 Y158.849 E.09124
G1 X178.251 Y159.399 E.01691
G1 X175.601 Y156.749 E.11515
G1 X175.051 Y156.749 E.01691
G1 X178.251 Y159.949 E.13907
G1 X178.251 Y160.499 E.01691
G1 X174.501 Y156.749 E.16299
G1 X173.95 Y156.749 E.01691
G1 X178.251 Y161.05 E.1869
G1 X178.251 Y161.6 E.01691
G1 X173.4 Y156.749 E.21082
G1 X172.85 Y156.749 E.01691
G1 X178.251 Y162.15 E.23474
G1 X178.251 Y162.7 E.01691
G1 X172.3 Y156.749 E.25865
G1 X171.75 Y156.749 E.01691
G1 X178.251 Y163.251 E.28257
G1 X177.7 Y163.251 E.01691
G1 X171.749 Y157.3 E.25866
G1 X171.749 Y157.85 E.01691
G1 X177.15 Y163.251 E.23474
G1 X176.6 Y163.251 E.01691
G1 X171.749 Y158.4 E.21082
M73 P48 R7
G1 X171.749 Y158.95 E.01691
G1 X176.05 Y163.251 E.18691
G1 X175.499 Y163.251 E.01691
G1 X171.749 Y159.501 E.16299
G1 X171.749 Y160.051 E.01691
G1 X174.949 Y163.251 E.13907
G1 X174.399 Y163.251 E.01691
G1 X171.749 Y160.601 E.11516
G1 X171.749 Y161.151 E.01691
G1 X173.849 Y163.251 E.09124
G1 X173.298 Y163.251 E.01691
G1 X171.749 Y161.702 E.06733
G1 X171.749 Y162.252 E.01691
G1 X172.748 Y163.251 E.04341
G1 X172.198 Y163.251 E.01691
G1 X171.58 Y162.632 E.02687
; CHANGE_LAYER
; Z_HEIGHT: 1.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9252.596
G1 X172.198 Y163.251 E-.33219
G1 X172.748 Y163.251 E-.20909
G1 X172.341 Y162.844 E-.21872
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 6/50
; update layer progress
M73 L6
M991 S0 P5 ;notify layer change

M106 S229.5
; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z1.4 I-.143 J1.208 P1  F60000
G1 X178.584 Y163.584 Z1.4
G1 Z1.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X171.416 Y163.584 E.23048
G1 X171.416 Y156.416 E.23048
G1 X178.584 Y156.416 E.23048
G1 X178.584 Y163.524 E.22855
; COOLING_NODE: 0
M204 S10000
G1 X178.991 Y163.991 F60000
G1 F1200
M204 S8000
G1 X171.009 Y163.991 E.25666
G1 X171.009 Y156.009 E.25666
G1 X178.991 Y156.009 E.25666
G1 X178.991 Y163.931 E.25473
; COOLING_NODE: 0
M204 S10000
M73 P48 R6
G1 X179.398 Y164.398 F60000
G1 F1200
M204 S8000
G1 X170.602 Y164.398 E.28284
G1 X170.602 Y155.602 E.28284
G1 X179.398 Y155.602 E.28284
G1 X179.398 Y164.338 E.28091
; COOLING_NODE: 0
M204 S250
G1 X179.79 Y164.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X170.21 Y164.79 E.28536
G1 X170.21 Y155.21 E.28536
G1 X179.79 Y155.21 E.28536
G1 X179.79 Y164.73 E.28357
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
M73 P49 R6
G1 X177.79 Y164.743 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.764 Y162.473 Z1.6 F60000
G1 Z1.2
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X171.764 Y160.845 E.05236
G3 X173.035 Y160.73 I.763 J1.353 E.04226
G1 X173.69 Y161.199 E.02592
G2 X175.655 Y161.891 I1.521 J-1.184 E.07079
G1 X176.31 Y161.422 E.02592
G3 X178.236 Y160.725 I1.512 J1.17 E.06947
G1 X178.236 Y158.224 E.08041
G2 X176.966 Y158.109 I-.763 J1.353 E.04225
G1 X176.31 Y158.578 E.02592
G3 X174.345 Y159.271 I-1.521 J-1.184 E.07079
G1 X173.69 Y158.801 E.02592
G2 X171.764 Y158.104 I-1.512 J1.17 E.06948
G1 X171.764 Y156.764 E.04308
G1 X172.053 Y156.764 E.00928
; CHANGE_LAYER
; Z_HEIGHT: 1.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F8843.478
G1 X171.764 Y156.764 E-.1097
G1 X171.764 Y158.104 E-.50906
G1 X172.134 Y158.06 E-.14124
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 7/50
; update layer progress
M73 L7
M991 S0 P6 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z1.6 I-.792 J.924 P1  F60000
G1 X178.584 Y163.584 Z1.6
G1 Z1.4
G1 E.8 F1800
; FEATURE: Inner wall
G1 F1200
M204 S8000
G1 X171.416 Y163.584 E.23048
G1 X171.416 Y156.416 E.23048
G1 X178.584 Y156.416 E.23048
G1 X178.584 Y163.524 E.22855
; COOLING_NODE: 0
M204 S10000
G1 X178.991 Y163.991 F60000
G1 F1200
M204 S8000
G1 X171.009 Y163.991 E.25666
G1 X171.009 Y156.009 E.25666
G1 X178.991 Y156.009 E.25666
G1 X178.991 Y163.931 E.25473
; COOLING_NODE: 0
M204 S10000
G1 X179.398 Y164.398 F60000
G1 F1200
M204 S8000
G1 X170.602 Y164.398 E.28284
G1 X170.602 Y155.602 E.28284
G1 X179.398 Y155.602 E.28284
G1 X179.398 Y164.338 E.28091
; COOLING_NODE: 0
M204 S250
G1 X179.79 Y164.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X170.21 Y164.79 E.28536
G1 X170.21 Y155.21 E.28536
G1 X179.79 Y155.21 E.28536
G1 X179.79 Y164.73 E.28357
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
M73 P50 R6
G1 X177.79 Y164.743 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X178.236 Y162.463 Z1.8 F60000
G1 Z1.4
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X178.236 Y160.835 E.05236
G2 X176.31 Y161.22 I-.7 J1.505 E.06755
G1 X175.655 Y161.774 E.02759
G3 X173.69 Y161.401 I-.731 J-1.51 E.06893
G1 X173.035 Y160.847 E.02759
G2 X171.764 Y160.737 I-.756 J1.352 E.04225
G1 X171.764 Y158.214 E.08114
G3 X173.69 Y158.6 I.7 J1.505 E.06756
G1 X174.345 Y159.154 E.02759
G2 X176.31 Y158.78 I.731 J-1.51 E.06893
G1 X176.966 Y158.226 E.02759
G3 X178.236 Y158.117 I.756 J1.352 E.04224
G1 X178.236 Y156.764 E.04348
G1 X177.959 Y156.764 E.00888
; CHANGE_LAYER
; Z_HEIGHT: 1.6
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F8843.478
G1 X178.236 Y156.764 E-.10496
G1 X178.236 Y158.117 E-.5138
G1 X177.867 Y158.066 E-.14124
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 8/50
; update layer progress
M73 L8
M991 S0 P7 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z1.8 I-1.207 J.157 P1  F60000
G1 X178.584 Y163.584 Z1.8
G1 Z1.6
G1 E.8 F1800
; FEATURE: Inner wall
G1 F1200
M204 S8000
G1 X171.416 Y163.584 E.23048
G1 X171.416 Y156.416 E.23048
G1 X178.584 Y156.416 E.23048
G1 X178.584 Y163.524 E.22855
; COOLING_NODE: 0
M204 S10000
G1 X178.991 Y163.991 F60000
G1 F1200
M204 S8000
G1 X171.009 Y163.991 E.25666
G1 X171.009 Y156.009 E.25666
G1 X178.991 Y156.009 E.25666
G1 X178.991 Y163.931 E.25473
; COOLING_NODE: 0
M204 S10000
G1 X179.398 Y164.398 F60000
G1 F1200
M204 S8000
G1 X170.602 Y164.398 E.28284
G1 X170.602 Y155.602 E.28284
G1 X179.398 Y155.602 E.28284
G1 X179.398 Y164.338 E.28091
; COOLING_NODE: 0
M204 S250
G1 X179.79 Y164.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X170.21 Y164.79 E.28536
G1 X170.21 Y155.21 E.28536
G1 X179.79 Y155.21 E.28536
G1 X179.79 Y164.73 E.28357
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
M73 P51 R6
G1 X177.79 Y164.743 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.764 Y162.555 Z2 F60000
G1 Z1.6
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X171.764 Y163.236 E.02187
G3 X173.072 Y163.236 I.654 J15.486 E.04205
G1 X178.236 Y163.236 E.16604
G1 X178.236 Y160.925 E.0743
G2 X176.966 Y160.601 I-1.014 J1.324 E.04332
G1 X176.638 Y160.725 E.01127
G2 X175.655 Y161.676 I4.256 J5.381 E.04405
G3 X174.345 Y162.02 I-1.057 J-1.361 E.04477
G1 X174.017 Y161.895 E.01127
G3 X173.035 Y160.944 I4.256 J-5.381 E.04405
G2 X171.764 Y160.602 I-1.035 J1.315 E.04347
G1 X171.764 Y158.304 E.0739
G3 X173.035 Y157.98 I1.015 J1.324 E.04332
G1 X173.362 Y158.105 E.01127
G3 X174.345 Y159.056 I-4.256 J5.381 E.04405
G2 X175.655 Y159.399 I1.057 J-1.361 E.04477
G1 X175.983 Y159.275 E.01127
G2 X176.966 Y158.324 I-4.256 J-5.381 E.04405
G3 X178.236 Y157.982 I1.035 J1.315 E.04346
G1 X178.236 Y156.764 E.03915
G3 X174.307 Y156.764 I-1.964 J-52.07 E.12635
G1 X172.679 Y156.764 E.05236
; CHANGE_LAYER
; Z_HEIGHT: 1.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F8843.478
G1 X174.307 Y156.764 E-.61876
G1 X174.679 Y156.764 E-.14125
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 9/50
; update layer progress
M73 L9
M991 S0 P8 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z2 I-1.056 J.605 P1  F60000
G1 X178.584 Y163.584 Z2
G1 Z1.8
G1 E.8 F1800
; FEATURE: Inner wall
G1 F1200
M204 S8000
G1 X171.416 Y163.584 E.23048
G1 X171.416 Y156.416 E.23048
G1 X178.584 Y156.416 E.23048
G1 X178.584 Y163.524 E.22855
; COOLING_NODE: 0
M204 S10000
G1 X178.991 Y163.991 F60000
G1 F1200
M204 S8000
G1 X171.009 Y163.991 E.25666
G1 X171.009 Y156.009 E.25666
G1 X178.991 Y156.009 E.25666
G1 X178.991 Y163.931 E.25473
; COOLING_NODE: 0
M204 S10000
G1 X179.398 Y164.398 F60000
G1 F1200
M204 S8000
G1 X170.602 Y164.398 E.28284
G1 X170.602 Y155.602 E.28284
G1 X179.398 Y155.602 E.28284
G1 X179.398 Y164.338 E.28091
; COOLING_NODE: 0
M204 S250
G1 X179.79 Y164.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X170.21 Y164.79 E.28536
G1 X170.21 Y155.21 E.28536
G1 X179.79 Y155.21 E.28536
G1 X179.79 Y164.73 E.28357
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
M73 P52 R6
G1 F9547.055
M204 S8000
G1 X177.79 Y164.743 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.764 Y162.17 Z2.2 F60000
G1 Z1.8
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X171.764 Y163.236 E.03426
G1 X172.327 Y163.236 E.0181
G1 X173.035 Y163.038 E.02361
G3 X173.572 Y163.236 I.098 J.563 E.0193
G1 X177.569 Y163.236 E.12851
G1 X178.236 Y163.048 E.02227
G1 X178.236 Y161.001 E.06581
G2 X176.966 Y160.417 I-1.413 J1.4 E.04593
G2 X176.31 Y160.703 I-.081 J.709 E.02408
G1 X175.655 Y161.592 E.0355
G3 X174.345 Y162.204 I-1.47 J-1.44 E.04752
G3 X173.69 Y161.918 I-.081 J-.709 E.02408
G1 X173.035 Y161.029 E.0355
G2 X171.764 Y160.427 I-1.437 J1.391 E.04618
G1 X171.764 Y158.381 E.06581
G3 X173.035 Y157.797 I1.413 J1.4 E.04594
G3 X173.69 Y158.083 I.081 J.709 E.02408
G1 X174.345 Y158.971 E.0355
G2 X175.655 Y159.583 I1.47 J-1.44 E.04752
G2 X176.31 Y159.297 I.081 J-.709 E.02408
G1 X176.966 Y158.408 E.0355
G3 X178.236 Y157.806 I1.437 J1.391 E.04618
G1 X178.236 Y156.764 E.03351
G1 X175.052 Y156.764 E.10237
G1 X174.345 Y156.962 E.02362
G3 X173.807 Y156.764 I-.098 J-.563 E.0193
G1 X172.179 Y156.764 E.05236
; CHANGE_LAYER
; Z_HEIGHT: 2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F8843.478
G1 X173.807 Y156.764 E-.61876
G1 X174.017 Y156.923 E-.1
G1 X174.125 Y156.936 E-.04124
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 10/50
; update layer progress
M73 L10
M991 S0 P9 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z2.2 I-1.011 J.678 P1  F60000
G1 X178.584 Y163.584 Z2.2
G1 Z2
G1 E.8 F1800
; FEATURE: Inner wall
G1 F1200
M204 S8000
G1 X171.416 Y163.584 E.23048
G1 X171.416 Y156.416 E.23048
G1 X178.584 Y156.416 E.23048
G1 X178.584 Y163.524 E.22855
; COOLING_NODE: 0
M204 S10000
G1 X178.991 Y163.991 F60000
G1 F1200
M204 S8000
G1 X171.009 Y163.991 E.25666
G1 X171.009 Y156.009 E.25666
G1 X178.991 Y156.009 E.25666
G1 X178.991 Y163.931 E.25473
; COOLING_NODE: 0
M204 S10000
G1 X179.398 Y164.398 F60000
G1 F1200
M204 S8000
G1 X170.602 Y164.398 E.28284
G1 X170.602 Y155.602 E.28284
G1 X179.398 Y155.602 E.28284
G1 X179.398 Y164.338 E.28091
; COOLING_NODE: 0
M204 S250
G1 X179.79 Y164.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
M73 P53 R6
G1 X170.21 Y164.79 E.28536
G1 X170.21 Y155.21 E.28536
G1 X179.79 Y155.21 E.28536
G1 X179.79 Y164.73 E.28357
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
G1 X177.79 Y164.743 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.836 Y163.236 Z2.4 F60000
G1 Z2
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X177.464 Y163.236 E.05236
G1 X178.236 Y162.817 E.02824
G1 X178.236 Y161.112 E.0548
G1 X177.852 Y160.655 E.01919
G1 X176.645 Y160 E.04415
G1 X176.508 Y159.672 E.01143
G3 X177.39 Y158.035 I2.986 J.551 E.0608
G1 X178.236 Y157.575 E.03095
G1 X178.236 Y156.764 E.02607
G1 X175.157 Y156.764 E.09899
G1 X174.025 Y157.379 E.04144
G1 X173.887 Y157.707 E.01143
G2 X174.769 Y159.345 I2.986 J-.551 E.0608
G1 X175.976 Y160 E.04415
G1 X176.113 Y160.328 E.01143
G3 X175.231 Y161.966 I-2.986 J-.551 E.0608
G1 X174.025 Y162.621 E.04415
G2 X173.946 Y163.236 I.41 J.365 E.02118
G1 X172.223 Y163.236 E.05541
G1 X173.355 Y162.621 E.04143
G1 X173.493 Y162.293 E.01143
G2 X172.611 Y160.655 I-2.986 J.551 E.0608
G1 X171.764 Y160.196 E.03096
G1 X171.764 Y158.492 E.0548
G1 X172.148 Y158.035 E.01919
G1 X173.355 Y157.379 E.04415
G2 X173.434 Y156.764 I-.41 J-.365 E.02118
G1 X171.805 Y156.764 E.05236
; CHANGE_LAYER
; Z_HEIGHT: 2.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F8843.478
G1 X173.434 Y156.764 E-.61876
G1 X173.493 Y157.052 E-.11146
G1 X173.462 Y157.124 E-.02978
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 11/50
; update layer progress
M73 L11
M991 S0 P10 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z2.4 I-.954 J.756 P1  F60000
G1 X178.584 Y163.584 Z2.4
G1 Z2.2
G1 E.8 F1800
; FEATURE: Inner wall
G1 F1200
M204 S8000
G1 X171.416 Y163.584 E.23048
G1 X171.416 Y156.416 E.23048
G1 X178.584 Y156.416 E.23048
G1 X178.584 Y163.524 E.22855
; COOLING_NODE: 0
M204 S10000
G1 X178.991 Y163.991 F60000
G1 F1200
M204 S8000
G1 X171.009 Y163.991 E.25666
G1 X171.009 Y156.009 E.25666
G1 X178.991 Y156.009 E.25666
G1 X178.991 Y163.931 E.25473
; COOLING_NODE: 0
M204 S10000
G1 X179.398 Y164.398 F60000
G1 F1200
M204 S8000
G1 X170.602 Y164.398 E.28284
G1 X170.602 Y155.602 E.28284
G1 X179.398 Y155.602 E.28284
G1 X179.398 Y164.338 E.28091
; COOLING_NODE: 0
M204 S250
M73 P54 R6
G1 X179.79 Y164.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X170.21 Y164.79 E.28536
G1 X170.21 Y155.21 E.28536
G1 X179.79 Y155.21 E.28536
G1 X179.79 Y164.73 E.28357
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
G1 X177.79 Y164.743 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.732 Y163.236 Z2.6 F60000
G1 Z2.2
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X177.36 Y163.236 E.05236
G1 X178.108 Y162.621 E.03114
G1 X178.236 Y162.461 E.00655
G1 X178.236 Y161.154 E.04204
G1 X177.93 Y160.655 E.01881
G3 X176.871 Y159.672 I1.787 J-2.987 E.04679
G3 X177.311 Y158.035 I1.859 J-.379 E.05654
G1 X178.236 Y157.22 E.03961
G1 X178.236 Y156.764 E.01465
G1 X175.261 Y156.764 E.09567
G2 X174.251 Y157.707 I1.717 J2.852 E.04474
G2 X174.691 Y159.345 I1.859 J.379 E.05654
G3 X175.749 Y160.328 I-1.787 J2.987 E.04679
G3 X175.309 Y161.966 I-1.859 J.379 E.05654
G1 X174.512 Y162.621 E.03318
G2 X174.185 Y163.236 I.474 J.647 E.02317
G1 X172.119 Y163.236 E.06644
G2 X173.129 Y162.293 I-1.717 J-2.851 E.04474
G2 X172.689 Y160.655 I-1.859 J-.379 E.05654
G1 X171.764 Y159.841 E.03962
G1 X171.764 Y158.534 E.04203
G1 X172.07 Y158.035 E.01882
G1 X172.867 Y157.379 E.03318
G2 X173.194 Y156.764 I-.474 J-.647 E.02317
G1 X171.764 Y156.764 E.04598
G1 X171.764 Y156.963 E.00638
; CHANGE_LAYER
; Z_HEIGHT: 2.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F8843.478
G1 X171.764 Y156.764 E-.07545
G1 X173.194 Y156.764 E-.54331
G1 X173.129 Y157.052 E-.112
G1 X173.081 Y157.112 E-.02924
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 12/50
; update layer progress
M73 L12
M991 S0 P11 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z2.6 I-.927 J.788 P1  F60000
G1 X178.584 Y163.584 Z2.6
G1 Z2.4
G1 E.8 F1800
; FEATURE: Inner wall
G1 F1200
M204 S8000
G1 X171.416 Y163.584 E.23048
G1 X171.416 Y156.416 E.23048
G1 X178.584 Y156.416 E.23048
G1 X178.584 Y163.524 E.22855
; COOLING_NODE: 0
M204 S10000
G1 X178.991 Y163.991 F60000
G1 F1200
M204 S8000
G1 X171.009 Y163.991 E.25666
G1 X171.009 Y156.009 E.25666
G1 X178.991 Y156.009 E.25666
G1 X178.991 Y163.931 E.25473
; COOLING_NODE: 0
M204 S10000
G1 X179.398 Y164.398 F60000
G1 F1200
M204 S8000
G1 X170.602 Y164.398 E.28284
M73 P55 R6
G1 X170.602 Y155.602 E.28284
G1 X179.398 Y155.602 E.28284
G1 X179.398 Y164.338 E.28091
; COOLING_NODE: 0
M204 S250
G1 X179.79 Y164.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X170.21 Y164.79 E.28536
G1 X170.21 Y155.21 E.28536
G1 X179.79 Y155.21 E.28536
G1 X179.79 Y164.73 E.28357
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
G1 X177.79 Y164.743 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.633 Y163.236 Z2.8 F60000
G1 Z2.4
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X177.261 Y163.236 E.05236
G2 X178.236 Y162.06 I-2.416 J-2.993 E.04943
G1 X178.236 Y161.178 E.02836
G1 X178.019 Y160.655 E.01819
G3 X177.11 Y159.672 I8.866 J-9.11 E.04306
G3 X177.223 Y158.035 I1.582 J-.714 E.05499
G1 X177.85 Y157.379 E.02916
G2 X178.236 Y156.764 I-.653 J-.839 E.02383
G1 X175.36 Y156.764 E.09248
G2 X174.489 Y157.707 I8.501 J8.722 E.04127
G2 X174.602 Y159.345 I1.582 J.714 E.05499
G3 X175.511 Y160.328 I-8.866 J9.11 E.04306
G3 X175.398 Y161.966 I-1.582 J.714 E.05499
G2 X174.361 Y163.236 I2.386 J3.006 E.05313
G1 X172.02 Y163.236 E.07529
G2 X172.89 Y162.293 I-8.5 J-8.722 E.04127
G2 X172.777 Y160.655 I-1.582 J-.714 E.05499
G3 X171.764 Y159.439 I2.487 J-3.101 E.05124
G1 X171.764 Y158.557 E.02835
G1 X171.981 Y158.035 E.0182
G2 X173.018 Y156.764 I-2.385 J-3.006 E.05313
G1 X174.647 Y156.764 E.05236
; CHANGE_LAYER
; Z_HEIGHT: 2.6
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F8843.478
G1 X173.018 Y156.764 E-.61876
G1 X172.89 Y157.052 E-.11956
G1 X172.851 Y157.094 E-.02168
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 13/50
; update layer progress
M73 L13
M991 S0 P12 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z2.8 I-.912 J.806 P1  F60000
G1 X178.584 Y163.584 Z2.8
G1 Z2.6
G1 E.8 F1800
; FEATURE: Inner wall
G1 F1200
M204 S8000
G1 X171.416 Y163.584 E.23048
G1 X171.416 Y156.416 E.23048
G1 X178.584 Y156.416 E.23048
G1 X178.584 Y163.524 E.22855
; COOLING_NODE: 0
M204 S10000
G1 X178.991 Y163.991 F60000
G1 F1200
M204 S8000
G1 X171.009 Y163.991 E.25666
M73 P55 R5
G1 X171.009 Y156.009 E.25666
G1 X178.991 Y156.009 E.25666
G1 X178.991 Y163.931 E.25473
; COOLING_NODE: 0
M204 S10000
G1 X179.398 Y164.398 F60000
M73 P56 R5
G1 F1200
M204 S8000
G1 X170.602 Y164.398 E.28284
G1 X170.602 Y155.602 E.28284
G1 X179.398 Y155.602 E.28284
G1 X179.398 Y164.338 E.28091
; COOLING_NODE: 0
M204 S250
G1 X179.79 Y164.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X170.21 Y164.79 E.28536
G1 X170.21 Y155.21 E.28536
G1 X179.79 Y155.21 E.28536
G1 X179.79 Y164.73 E.28357
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
G1 X177.79 Y164.743 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.523 Y163.236 Z3 F60000
G1 Z2.6
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X177.151 Y163.236 E.05236
G1 X177.641 Y162.621 E.02528
G2 X178.122 Y160.655 I-1.161 J-1.326 E.06931
G1 X177.6 Y160 E.02694
G3 X177.119 Y158.035 I1.149 J-1.323 E.06936
G2 X178.115 Y156.764 I-37.938 J-30.779 E.05191
G1 X175.47 Y156.764 E.08507
G1 X174.979 Y157.379 E.02529
G2 X174.498 Y159.345 I1.149 J1.323 E.06936
G1 X175.021 Y160 E.02694
G3 X175.502 Y161.966 I-1.149 J1.323 E.06936
G2 X174.506 Y163.236 I37.954 J30.792 E.0519
G1 X171.91 Y163.236 E.08347
G1 X172.4 Y162.621 E.02528
G2 X172.881 Y160.655 I-1.149 J-1.323 E.06936
G1 X172.359 Y160 E.02694
G3 X171.878 Y158.035 I1.161 J-1.326 E.06931
G2 X172.874 Y156.764 I-37.917 J-30.762 E.05191
G1 X174.502 Y156.764 E.05236
; CHANGE_LAYER
; Z_HEIGHT: 2.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F8843.478
G1 X172.874 Y156.764 E-.61876
G1 X172.645 Y157.057 E-.14124
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 14/50
; update layer progress
M73 L14
M991 S0 P13 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z3 I-.9 J.819 P1  F60000
G1 X178.584 Y163.584 Z3
G1 Z2.8
G1 E.8 F1800
; FEATURE: Inner wall
G1 F1200
M204 S8000
G1 X171.416 Y163.584 E.23048
G1 X171.416 Y156.416 E.23048
G1 X178.584 Y156.416 E.23048
G1 X178.584 Y163.524 E.22855
; COOLING_NODE: 0
M204 S10000
G1 X178.991 Y163.991 F60000
G1 F1200
M204 S8000
G1 X171.009 Y163.991 E.25666
G1 X171.009 Y156.009 E.25666
G1 X178.991 Y156.009 E.25666
G1 X178.991 Y163.931 E.25473
; COOLING_NODE: 0
M204 S10000
M73 P57 R5
G1 X179.398 Y164.398 F60000
G1 F1200
M204 S8000
G1 X170.602 Y164.398 E.28284
G1 X170.602 Y155.602 E.28284
G1 X179.398 Y155.602 E.28284
G1 X179.398 Y164.338 E.28091
; COOLING_NODE: 0
M204 S250
G1 X179.79 Y164.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X170.21 Y164.79 E.28536
G1 X170.21 Y155.21 E.28536
G1 X179.79 Y155.21 E.28536
G1 X179.79 Y164.73 E.28357
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
G1 X177.79 Y164.743 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X178.236 Y158.159 Z3.2 F60000
G1 Z2.8
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X178.236 Y156.764 E.04484
G1 X178.002 Y156.764 E.00752
G2 X177.152 Y157.707 I17.636 J16.762 E.04082
G2 X177.203 Y159.345 I1.554 J.771 E.05488
G3 X178.236 Y160.63 I-2.953 J3.431 E.0533
G1 X178.236 Y161.443 E.02617
G1 X178.039 Y161.966 E.01795
G2 X177.013 Y163.236 I2.978 J3.455 E.05278
G1 X174.619 Y163.236 E.07698
G2 X175.469 Y162.293 I-17.633 J-16.759 E.04082
G2 X175.418 Y160.655 I-1.554 J-.771 E.05488
G3 X174.531 Y159.672 I18.39 J-17.491 E.04258
G3 X174.582 Y158.035 I1.554 J-.771 E.05488
G2 X175.608 Y156.764 I-2.978 J-3.455 E.05278
G1 X172.76 Y156.764 E.09156
G2 X171.764 Y158.009 I2.867 J3.315 E.05155
G1 X171.764 Y158.822 E.02615
G1 X171.961 Y159.345 E.01796
G3 X172.848 Y160.328 I-18.372 J17.475 E.04258
G3 X172.797 Y161.966 I-1.554 J.771 E.05488
G2 X171.772 Y163.236 I2.979 J3.455 E.05278
G1 X171.764 Y161.614 E.05213
; CHANGE_LAYER
; Z_HEIGHT: 3
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F8843.478
G1 X171.772 Y163.236 E-.61605
G1 X171.91 Y162.948 E-.12121
G1 X171.95 Y162.904 E-.02274
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 15/50
; update layer progress
M73 L15
M991 S0 P14 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z3.2 I-.124 J1.211 P1  F60000
G1 X178.584 Y163.584 Z3.2
G1 Z3
G1 E.8 F1800
; FEATURE: Inner wall
G1 F1200
M204 S8000
G1 X171.416 Y163.584 E.23048
G1 X171.416 Y156.416 E.23048
G1 X178.584 Y156.416 E.23048
G1 X178.584 Y163.524 E.22855
; COOLING_NODE: 0
M204 S10000
G1 X178.991 Y163.991 F60000
G1 F1200
M204 S8000
G1 X171.009 Y163.991 E.25666
M73 P58 R5
G1 X171.009 Y156.009 E.25666
G1 X178.991 Y156.009 E.25666
G1 X178.991 Y163.931 E.25473
; COOLING_NODE: 0
M204 S10000
G1 X179.398 Y164.398 F60000
G1 F1200
M204 S8000
G1 X170.602 Y164.398 E.28284
G1 X170.602 Y155.602 E.28284
G1 X179.398 Y155.602 E.28284
G1 X179.398 Y164.338 E.28091
; COOLING_NODE: 0
M204 S250
G1 X179.79 Y164.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X170.21 Y164.79 E.28536
G1 X170.21 Y155.21 E.28536
G1 X179.79 Y155.21 E.28536
G1 X179.79 Y164.73 E.28357
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
G1 X177.79 Y164.743 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X178.236 Y158.058 Z3.4 F60000
G1 Z3
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X178.236 Y156.764 E.04161
G1 X177.901 Y156.764 E.01075
G2 X176.927 Y157.707 I2.253 J3.303 E.04379
G2 X177.294 Y159.345 I1.773 J.463 E.05606
G3 X178.236 Y160.231 I-2.106 J3.18 E.04179
G1 X178.236 Y161.46 E.0395
G1 X177.947 Y161.966 E.01872
G1 X177.195 Y162.621 E.03209
G2 X176.846 Y163.236 I.534 J.708 E.02337
G1 X174.72 Y163.236 E.06839
G2 X175.694 Y162.293 I-2.253 J-3.303 E.04379
G2 X175.327 Y160.655 I-1.773 J-.463 E.05606
G3 X174.307 Y159.672 I2.347 J-3.457 E.04577
G3 X174.673 Y158.035 I1.773 J-.463 E.05606
G1 X175.426 Y157.379 E.03209
G2 X175.774 Y156.764 I-.534 J-.708 E.02337
G1 X172.66 Y156.764 E.10015
G2 X171.764 Y157.611 I2.013 J3.026 E.03981
G1 X171.764 Y158.839 E.03949
G1 X172.053 Y159.345 E.01873
G3 X173.073 Y160.328 I-2.347 J3.457 E.04577
G3 X172.706 Y161.966 I-1.773 J.463 E.05606
G2 X171.764 Y162.852 I2.106 J3.181 E.04179
G1 X171.764 Y161.224 E.05236
; CHANGE_LAYER
; Z_HEIGHT: 3.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F8843.478
G1 X171.764 Y162.852 E-.61876
G1 X172.035 Y162.597 E-.14124
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 16/50
; update layer progress
M73 L16
M991 S0 P15 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z3.4 I-.181 J1.203 P1  F60000
G1 X178.584 Y163.584 Z3.4
G1 Z3.2
G1 E.8 F1800
; FEATURE: Inner wall
G1 F1200
M204 S8000
G1 X171.416 Y163.584 E.23048
G1 X171.416 Y156.416 E.23048
G1 X178.584 Y156.416 E.23048
G1 X178.584 Y163.524 E.22855
; COOLING_NODE: 0
M204 S10000
G1 X178.991 Y163.991 F60000
M73 P59 R5
G1 F1200
M204 S8000
G1 X171.009 Y163.991 E.25666
G1 X171.009 Y156.009 E.25666
G1 X178.991 Y156.009 E.25666
G1 X178.991 Y163.931 E.25473
; COOLING_NODE: 0
M204 S10000
G1 X179.398 Y164.398 F60000
G1 F1200
M204 S8000
G1 X170.602 Y164.398 E.28284
G1 X170.602 Y155.602 E.28284
G1 X179.398 Y155.602 E.28284
G1 X179.398 Y164.338 E.28091
; COOLING_NODE: 0
M204 S250
G1 X179.79 Y164.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X170.21 Y164.79 E.28536
G1 X170.21 Y155.21 E.28536
G1 X179.79 Y155.21 E.28536
G1 X179.79 Y164.73 E.28357
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
G1 X177.79 Y164.743 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X178.236 Y157.959 Z3.6 F60000
G1 Z3.2
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X178.236 Y156.764 E.03841
G1 X177.802 Y156.764 E.01395
G1 X176.8 Y157.379 E.03781
G1 X176.601 Y157.707 E.01231
G2 X177.374 Y159.345 I2.555 J-.204 E.05952
G1 X178.236 Y159.873 E.0325
G1 X178.236 Y161.499 E.05228
G1 X177.867 Y161.966 E.01911
G1 X176.8 Y162.621 E.04028
G2 X176.623 Y163.236 I.343 J.431 E.02195
G1 X174.819 Y163.236 E.05801
G1 X175.821 Y162.621 E.03781
G1 X176.019 Y162.293 E.01231
G2 X175.247 Y160.655 I-2.555 J.204 E.05952
G1 X174.179 Y160 E.04028
G1 X173.981 Y159.672 E.01231
G3 X174.753 Y158.035 I2.555 J.204 E.05952
G1 X175.821 Y157.379 E.04028
G2 X175.998 Y156.764 I-.343 J-.431 E.02195
G1 X172.56 Y156.764 E.11053
G1 X171.764 Y157.253 E.03003
G1 X171.764 Y158.878 E.05227
G1 X172.133 Y159.345 E.01911
G1 X173.201 Y160 E.04028
G1 X173.399 Y160.328 E.01231
G3 X172.626 Y161.966 I-2.555 J-.204 E.05952
G1 X171.764 Y162.494 E.0325
G1 X171.764 Y163.236 E.02384
G1 X172.651 Y163.236 E.02852
; CHANGE_LAYER
; Z_HEIGHT: 3.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F8843.478
G1 X171.764 Y163.236 E-.33704
G1 X171.764 Y162.494 E-.28172
M73 P60 R5
G1 X172.081 Y162.3 E-.14124
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 17/50
; update layer progress
M73 L17
M991 S0 P16 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z3.6 I-.236 J1.194 P1  F60000
G1 X178.584 Y163.584 Z3.6
G1 Z3.4
G1 E.8 F1800
; FEATURE: Inner wall
G1 F1200
M204 S8000
G1 X171.416 Y163.584 E.23048
G1 X171.416 Y156.416 E.23048
G1 X178.584 Y156.416 E.23048
G1 X178.584 Y163.524 E.22855
; COOLING_NODE: 0
M204 S10000
G1 X178.991 Y163.991 F60000
G1 F1200
M204 S8000
G1 X171.009 Y163.991 E.25666
G1 X171.009 Y156.009 E.25666
G1 X178.991 Y156.009 E.25666
G1 X178.991 Y163.931 E.25473
; COOLING_NODE: 0
M204 S10000
G1 X179.398 Y164.398 F60000
G1 F1200
M204 S8000
G1 X170.602 Y164.398 E.28284
G1 X170.602 Y155.602 E.28284
G1 X179.398 Y155.602 E.28284
G1 X179.398 Y164.338 E.28091
; COOLING_NODE: 0
M204 S250
G1 X179.79 Y164.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X170.21 Y164.79 E.28536
G1 X170.21 Y155.21 E.28536
G1 X179.79 Y155.21 E.28536
G1 X179.79 Y164.73 E.28357
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
G1 X177.79 Y164.743 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X177.936 Y163.236 Z3.8 F60000
G1 Z3.4
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X176.308 Y163.236 E.05236
G2 X175.655 Y162.993 I-.514 J.384 E.02367
G1 X174.932 Y163.236 E.02453
G1 X171.764 Y163.236 E.10186
G1 X171.764 Y162.237 E.03212
G2 X173.035 Y161.576 I-.281 J-2.091 E.04698
G1 X173.69 Y160.616 E.03735
G3 X174.345 Y160.372 I.517 J.385 E.02377
G3 X175.655 Y161.045 I-.277 J2.152 E.04833
G1 X176.31 Y162.004 E.03735
G2 X176.966 Y162.249 I.517 J-.385 E.02376
G2 X178.236 Y161.605 I-.257 J-2.082 E.04671
G1 X178.236 Y159.616 E.06396
G3 X176.966 Y158.955 I.281 J-2.09 E.04697
G1 X176.31 Y157.996 E.03735
G2 X175.655 Y157.752 I-.517 J.385 E.02376
G2 X174.345 Y158.425 I.277 J2.152 E.04833
G1 X173.69 Y159.384 E.03735
M73 P61 R5
G3 X173.035 Y159.628 I-.517 J-.385 E.02376
G3 X171.764 Y158.984 I.257 J-2.082 E.04671
G1 X171.764 Y156.995 E.06396
G1 X172.448 Y156.764 E.02319
G1 X176.313 Y156.764 E.12428
G2 X176.966 Y157.007 I.515 J-.384 E.02368
G1 X177.689 Y156.764 E.02453
G1 X178.236 Y156.764 E.01758
G1 X178.236 Y157.846 E.03478
; CHANGE_LAYER
; Z_HEIGHT: 3.6
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F8843.478
G1 X178.236 Y156.764 E-.41103
G1 X177.689 Y156.764 E-.20773
G1 X177.337 Y156.883 E-.14124
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 18/50
; update layer progress
M73 L18
M991 S0 P17 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z3.8 I-1.196 J.223 P1  F60000
G1 X178.584 Y163.584 Z3.8
G1 Z3.6
G1 E.8 F1800
; FEATURE: Inner wall
G1 F1200
M204 S8000
G1 X171.416 Y163.584 E.23048
G1 X171.416 Y156.416 E.23048
G1 X178.584 Y156.416 E.23048
G1 X178.584 Y163.524 E.22855
; COOLING_NODE: 0
M204 S10000
G1 X178.991 Y163.991 F60000
G1 F1200
M204 S8000
G1 X171.009 Y163.991 E.25666
G1 X171.009 Y156.009 E.25666
G1 X178.991 Y156.009 E.25666
G1 X178.991 Y163.931 E.25473
; COOLING_NODE: 0
M204 S10000
G1 X179.398 Y164.398 F60000
G1 F1200
M204 S8000
G1 X170.602 Y164.398 E.28284
G1 X170.602 Y155.602 E.28284
G1 X179.398 Y155.602 E.28284
G1 X179.398 Y164.338 E.28091
; COOLING_NODE: 0
M204 S250
G1 X179.79 Y164.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X170.21 Y164.79 E.28536
G1 X170.21 Y155.21 E.28536
G1 X179.79 Y155.21 E.28536
G1 X179.79 Y164.73 E.28357
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
G1 X177.79 Y164.743 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X177.426 Y163.236 Z4 F60000
G1 Z3.6
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X175.798 Y163.236 E.05236
G1 X175.655 Y163.187 E.00484
G1 X175.08 Y163.236 E.01858
G1 X171.764 Y163.236 E.1066
G1 X171.764 Y162.051 E.0381
G1 X172.379 Y161.999 E.01984
G1 X173.035 Y161.658 E.02375
M73 P62 R5
G3 X174.017 Y160.677 I4.225 J3.251 E.04477
G1 X174.345 Y160.567 E.01112
G3 X175.655 Y160.963 I.183 J1.762 E.04519
G2 X176.638 Y161.943 I4.225 J-3.251 E.04477
G1 X176.966 Y162.054 E.01112
G2 X178.236 Y161.679 I.188 J-1.703 E.04372
G1 X178.236 Y159.43 E.07232
G1 X177.621 Y159.379 E.01984
G1 X176.966 Y159.037 E.02375
G2 X175.983 Y158.057 I-4.225 J3.251 E.04477
G1 X175.655 Y157.946 E.01112
G2 X174.345 Y158.342 I-.183 J1.762 E.04519
G3 X173.362 Y159.323 I-4.225 J-3.251 E.04477
G1 X173.035 Y159.433 E.01112
G3 X171.764 Y159.058 I-.188 J-1.703 E.04372
G1 X171.764 Y156.809 E.07232
G1 X172.301 Y156.764 E.01732
G1 X176.823 Y156.764 E.1454
G1 X176.966 Y156.813 E.00485
G3 X178.236 Y156.764 I.923 J7.575 E.04092
G1 X178.236 Y157.7 E.03007
; CHANGE_LAYER
; Z_HEIGHT: 3.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F8843.478
G1 X178.236 Y156.764 E-.35539
G1 X177.172 Y156.805 E-.40462
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 19/50
; update layer progress
M73 L19
M991 S0 P18 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z4 I-1.191 J.248 P1  F60000
G1 X178.584 Y163.584 Z4
G1 Z3.8
G1 E.8 F1800
; FEATURE: Inner wall
G1 F1200
M204 S8000
G1 X171.416 Y163.584 E.23048
G1 X171.416 Y156.416 E.23048
G1 X178.584 Y156.416 E.23048
G1 X178.584 Y163.524 E.22855
; COOLING_NODE: 0
M204 S10000
G1 X178.991 Y163.991 F60000
G1 F1200
M204 S8000
G1 X171.009 Y163.991 E.25666
G1 X171.009 Y156.009 E.25666
G1 X178.991 Y156.009 E.25666
G1 X178.991 Y163.931 E.25473
; COOLING_NODE: 0
M204 S10000
G1 X179.398 Y164.398 F60000
G1 F1200
M204 S8000
G1 X170.602 Y164.398 E.28284
G1 X170.602 Y155.602 E.28284
G1 X179.398 Y155.602 E.28284
G1 X179.398 Y164.338 E.28091
; COOLING_NODE: 0
M204 S250
G1 X179.79 Y164.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X170.21 Y164.79 E.28536
G1 X170.21 Y155.21 E.28536
G1 X179.79 Y155.21 E.28536
G1 X179.79 Y164.73 E.28357
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
G1 X177.79 Y164.743 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
M73 P63 R5
G1 X172.066 Y163.236 Z4.2 F60000
G1 Z3.8
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X171.764 Y163.236 E.0097
G1 X171.764 Y161.909 E.04266
G2 X173.035 Y161.753 I.461 J-1.494 E.04239
G3 X174.345 Y160.716 I5.51 J5.619 E.05383
G3 X175.655 Y160.868 I.486 J1.537 E.0437
G1 X176.31 Y161.443 E.02803
G2 X178.236 Y161.766 I1.177 J-1.114 E.06737
G1 X178.236 Y159.288 E.07968
G3 X176.966 Y159.132 I-.461 J-1.494 E.04239
G2 X175.655 Y158.095 I-5.511 J5.62 E.05383
G2 X174.345 Y158.247 I-.486 J1.536 E.0437
G1 X173.69 Y158.822 E.02803
G3 X171.764 Y159.145 I-1.177 J-1.114 E.06737
G1 X171.764 Y157.517 E.05236
; CHANGE_LAYER
; Z_HEIGHT: 4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F8843.478
G1 X171.764 Y159.145 E-.61876
G1 X172.117 Y159.263 E-.14124
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 20/50
; update layer progress
M73 L20
M991 S0 P19 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z4.2 I-.676 J1.012 P1  F60000
G1 X178.584 Y163.584 Z4.2
G1 Z4
G1 E.8 F1800
; FEATURE: Inner wall
G1 F1200
M204 S8000
G1 X171.416 Y163.584 E.23048
G1 X171.416 Y156.416 E.23048
G1 X178.584 Y156.416 E.23048
G1 X178.584 Y163.524 E.22855
; COOLING_NODE: 0
M204 S10000
M73 P63 R4
G1 X178.991 Y163.991 F60000
G1 F1200
M204 S8000
G1 X171.009 Y163.991 E.25666
G1 X171.009 Y156.009 E.25666
G1 X178.991 Y156.009 E.25666
G1 X178.991 Y163.931 E.25473
; COOLING_NODE: 0
M204 S10000
G1 X179.398 Y164.398 F60000
G1 F1200
M204 S8000
G1 X170.602 Y164.398 E.28284
G1 X170.602 Y155.602 E.28284
G1 X179.398 Y155.602 E.28284
G1 X179.398 Y164.338 E.28091
; COOLING_NODE: 0
M204 S250
G1 X179.79 Y164.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X170.21 Y164.79 E.28536
G1 X170.21 Y155.21 E.28536
G1 X179.79 Y155.21 E.28536
G1 X179.79 Y164.73 E.28357
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
G1 X177.79 Y164.743 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
M73 P64 R4
G1 X177.971 Y163.236 Z4.4 F60000
G1 Z4
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X178.236 Y163.236 E.00849
G1 X178.236 Y161.871 E.04387
G3 X176.31 Y161.241 I-.48 J-1.788 E.06892
G1 X175.655 Y160.756 E.02622
G2 X173.69 Y161.38 I-.512 J1.796 E.07025
G1 X173.035 Y161.865 E.02622
G3 X171.764 Y161.796 I-.559 J-1.438 E.04216
G1 X171.764 Y159.251 E.08186
G2 X173.69 Y158.62 I.48 J-1.788 E.06893
G1 X174.345 Y158.135 E.02622
G3 X176.31 Y158.759 I.512 J1.796 E.07025
G1 X176.966 Y159.244 E.02622
G2 X178.236 Y159.176 I.559 J-1.438 E.04215
G1 X178.236 Y157.547 E.05236
; CHANGE_LAYER
; Z_HEIGHT: 4.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F8843.478
G1 X178.236 Y159.176 E-.61876
G1 X177.877 Y159.275 E-.14124
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 21/50
; update layer progress
M73 L21
M991 S0 P20 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z4.4 I-1.201 J.197 P1  F60000
G1 X178.584 Y163.584 Z4.4
G1 Z4.2
G1 E.8 F1800
; FEATURE: Inner wall
G1 F1200
M204 S8000
G1 X171.416 Y163.584 E.23048
G1 X171.416 Y156.416 E.23048
G1 X178.584 Y156.416 E.23048
G1 X178.584 Y163.524 E.22855
; COOLING_NODE: 0
M204 S10000
G1 X178.991 Y163.991 F60000
G1 F1200
M204 S8000
G1 X171.009 Y163.991 E.25666
G1 X171.009 Y156.009 E.25666
G1 X178.991 Y156.009 E.25666
G1 X178.991 Y163.931 E.25473
; COOLING_NODE: 0
M204 S10000
G1 X179.398 Y164.398 F60000
G1 F1200
M204 S8000
G1 X170.602 Y164.398 E.28284
G1 X170.602 Y155.602 E.28284
G1 X179.398 Y155.602 E.28284
G1 X179.398 Y164.338 E.28091
; COOLING_NODE: 0
M204 S250
G1 X179.79 Y164.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X170.21 Y164.79 E.28536
G1 X170.21 Y155.21 E.28536
G1 X179.79 Y155.21 E.28536
G1 X179.79 Y164.73 E.28357
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
G1 X177.79 Y164.743 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
M73 P65 R4
G1 X177.84 Y163.236 Z4.6 F60000
G1 Z4.2
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X178.236 Y163.236 E.01272
G1 X178.236 Y162.003 E.03964
G3 X176.966 Y161.686 I-.267 J-1.632 E.04328
G2 X175.983 Y160.748 I-5.974 J5.278 E.04373
G1 X175.655 Y160.617 E.01135
G2 X174.345 Y160.935 I-.286 J1.679 E.04458
G3 X173.362 Y161.873 I-5.975 J-5.28 E.04373
G1 X173.035 Y162.004 E.01135
G3 X171.764 Y161.704 I-.288 J-1.623 E.04314
G1 X171.764 Y159.382 E.07467
G2 X173.035 Y159.065 I.267 J-1.632 E.04328
G3 X174.017 Y158.128 I5.976 J5.28 E.04373
G1 X174.345 Y157.996 E.01135
G3 X175.655 Y158.314 I.286 J1.679 E.04458
G2 X176.638 Y159.252 I5.977 J-5.281 E.04373
G1 X176.966 Y159.383 E.01135
G2 X178.236 Y159.084 I.288 J-1.623 E.04314
G1 X178.236 Y157.455 E.05236
; CHANGE_LAYER
; Z_HEIGHT: 4.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F8843.478
G1 X178.236 Y159.084 E-.61876
G1 X177.898 Y159.239 E-.14125
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 22/50
; update layer progress
M73 L22
M991 S0 P21 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z4.6 I-1.202 J.19 P1  F60000
G1 X178.584 Y163.584 Z4.6
G1 Z4.4
G1 E.8 F1800
; FEATURE: Inner wall
G1 F1200
M204 S8000
G1 X171.416 Y163.584 E.23048
G1 X171.416 Y156.416 E.23048
G1 X178.584 Y156.416 E.23048
G1 X178.584 Y163.524 E.22855
; COOLING_NODE: 0
M204 S10000
G1 X178.991 Y163.991 F60000
G1 F1200
M204 S8000
G1 X171.009 Y163.991 E.25666
G1 X171.009 Y156.009 E.25666
G1 X178.991 Y156.009 E.25666
G1 X178.991 Y163.931 E.25473
; COOLING_NODE: 0
M204 S10000
G1 X179.398 Y164.398 F60000
G1 F1200
M204 S8000
G1 X170.602 Y164.398 E.28284
G1 X170.602 Y155.602 E.28284
G1 X179.398 Y155.602 E.28284
G1 X179.398 Y164.338 E.28091
; COOLING_NODE: 0
M204 S250
G1 X179.79 Y164.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X170.21 Y164.79 E.28536
G1 X170.21 Y155.21 E.28536
G1 X179.79 Y155.21 E.28536
G1 X179.79 Y164.73 E.28357
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
G1 X177.79 Y164.743 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
M73 P66 R4
G1 X172.226 Y163.236 Z4.8 F60000
G1 Z4.4
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X173.855 Y163.236 E.05236
G3 X174.345 Y163.059 I.406 J.359 E.01748
G1 X175.044 Y163.236 E.02318
G1 X178.236 Y163.236 E.10263
G1 X178.236 Y162.173 E.03416
G1 X177.621 Y162.035 E.02026
G1 X176.966 Y161.6 E.02529
G1 X176.31 Y160.742 E.03472
G1 X175.983 Y160.49 E.01329
G2 X174.345 Y161.021 I-.26 J1.991 E.05722
G1 X173.69 Y161.879 E.03472
G1 X173.362 Y162.131 E.01329
G3 X171.764 Y161.627 I-.261 J-1.957 E.05564
G1 X171.764 Y159.552 E.0667
G2 X173.035 Y158.979 I-.115 J-1.949 E.04582
G1 X173.69 Y158.121 E.03472
G1 X174.017 Y157.869 E.01329
G3 X175.655 Y158.4 I.26 J1.991 E.05722
G1 X176.31 Y159.258 E.03472
G1 X176.638 Y159.51 E.01329
G2 X178.236 Y159.006 I.261 J-1.957 E.05563
G1 X178.236 Y156.932 E.0667
G1 X177.577 Y156.764 E.02186
G1 X173.525 Y156.764 E.13029
G3 X173.035 Y156.941 I-.406 J-.359 E.01748
G1 X172.335 Y156.764 E.02319
G1 X171.764 Y156.764 E.01836
G1 X171.764 Y157.822 E.034
; CHANGE_LAYER
; Z_HEIGHT: 4.6
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F8843.478
G1 X171.764 Y156.764 E-.40179
G1 X172.335 Y156.764 E-.21697
G1 X172.696 Y156.855 E-.14124
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 23/50
; update layer progress
M73 L23
M991 S0 P22 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z4.8 I-.916 J.801 P1  F60000
G1 X178.584 Y163.584 Z4.8
G1 Z4.6
G1 E.8 F1800
; FEATURE: Inner wall
G1 F1200
M204 S8000
G1 X171.416 Y163.584 E.23048
G1 X171.416 Y156.416 E.23048
G1 X178.584 Y156.416 E.23048
G1 X178.584 Y163.524 E.22855
; COOLING_NODE: 0
M204 S10000
G1 X178.991 Y163.991 F60000
G1 F1200
M204 S8000
G1 X171.009 Y163.991 E.25666
G1 X171.009 Y156.009 E.25666
G1 X178.991 Y156.009 E.25666
G1 X178.991 Y163.931 E.25473
; COOLING_NODE: 0
M204 S10000
G1 X179.398 Y164.398 F60000
G1 F1200
M204 S8000
G1 X170.602 Y164.398 E.28284
G1 X170.602 Y155.602 E.28284
G1 X179.398 Y155.602 E.28284
G1 X179.398 Y164.338 E.28091
; COOLING_NODE: 0
M204 S250
G1 X179.79 Y164.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X170.21 Y164.79 E.28536
G1 X170.21 Y155.21 E.28536
G1 X179.79 Y155.21 E.28536
G1 X179.79 Y164.73 E.28357
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
M73 P67 R4
G1 X177.79 Y164.743 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X177.433 Y163.236 Z5 F60000
G1 Z4.6
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X178.236 Y163.236 E.02579
G1 X178.236 Y162.409 E.02657
G3 X176.547 Y160.655 I.763 J-2.423 E.08164
G3 X176.524 Y160 I.607 J-.35 E.02194
G1 X177.271 Y159.672 E.02621
G2 X178.236 Y158.893 I-.625 J-1.76 E.04067
G1 X178.236 Y157.168 E.05546
G3 X177.468 Y156.764 I1.524 J-3.832 E.02795
G1 X175.839 Y156.764 E.05236
; WIPE_START
G1 F8843.478
G1 X177.468 Y156.764 E-.61876
G1 X177.797 Y156.937 E-.14124
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.764 Y158.16 Z5 F60000
G1 Z4.6
G1 E.8 F1800
G1 F1200
M204 S8000
G1 X171.764 Y159.789 E.05236
G2 X173.546 Y157.707 I-1.005 J-2.662 E.09192
G1 X173.476 Y157.379 E.01077
G3 X172.226 Y156.764 I2.283 J-6.216 E.04486
G1 X173.915 Y156.764 E.05431
G2 X173.904 Y157.379 I.575 J.319 E.02058
G3 X175.224 Y158.035 I-2.438 J6.569 E.04747
G3 X176.166 Y159.672 I-2.367 J2.453 E.06158
G1 X176.097 Y160 E.01077
G2 X174.777 Y160.655 I2.438 J6.569 E.04747
G2 X173.834 Y162.293 I2.367 J2.453 E.06158
G1 X173.904 Y162.621 E.01077
G3 X175.153 Y163.236 I-2.283 J6.215 E.04486
G1 X173.464 Y163.236 E.05431
G2 X173.476 Y162.621 I-.575 J-.319 E.02058
G3 X172.156 Y161.966 I2.438 J-6.569 E.04747
G1 X171.764 Y161.513 E.01924
G1 X171.764 Y163.142 E.05236
; CHANGE_LAYER
; Z_HEIGHT: 4.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F8843.478
G1 X171.764 Y161.513 E-.61876
G1 X172.008 Y161.794 E-.14124
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 24/50
; update layer progress
M73 L24
M991 S0 P23 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z5 I-.32 J1.174 P1  F60000
G1 X178.584 Y163.584 Z5
G1 Z4.8
G1 E.8 F1800
; FEATURE: Inner wall
G1 F1200
M204 S8000
G1 X171.416 Y163.584 E.23048
G1 X171.416 Y156.416 E.23048
G1 X178.584 Y156.416 E.23048
G1 X178.584 Y163.524 E.22855
; COOLING_NODE: 0
M204 S10000
G1 X178.991 Y163.991 F60000
G1 F1200
M204 S8000
G1 X171.009 Y163.991 E.25666
G1 X171.009 Y156.009 E.25666
G1 X178.991 Y156.009 E.25666
G1 X178.991 Y163.931 E.25473
; COOLING_NODE: 0
M204 S10000
G1 X179.398 Y164.398 F60000
G1 F1200
M204 S8000
G1 X170.602 Y164.398 E.28284
G1 X170.602 Y155.602 E.28284
G1 X179.398 Y155.602 E.28284
G1 X179.398 Y164.338 E.28091
; COOLING_NODE: 0
M204 S250
G1 X179.79 Y164.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X170.21 Y164.79 E.28536
M73 P68 R4
G1 X170.21 Y155.21 E.28536
G1 X179.79 Y155.21 E.28536
G1 X179.79 Y164.73 E.28357
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
G1 X177.79 Y164.743 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X178.236 Y161.112 Z5.2 F60000
G1 Z4.8
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X178.236 Y162.74 E.05236
G1 X177.32 Y161.966 E.03857
G3 X176.777 Y160.655 I1.406 J-1.35 E.04668
G3 X177.1 Y160 I.805 J-.01 E.02438
G1 X177.922 Y159.345 E.0338
G1 X178.236 Y158.85 E.01885
G1 X178.236 Y157.499 E.04344
G1 X178.142 Y157.379 E.00488
G1 X177.37 Y156.764 E.03172
G1 X174.164 Y156.764 E.1031
G2 X174.479 Y157.379 I.762 J-.002 E.02306
G1 X175.301 Y158.035 E.0338
G3 X175.844 Y159.345 I-1.406 J1.35 E.04668
G3 X175.521 Y160 I-.805 J.01 E.02438
G1 X174.699 Y160.655 E.0338
G2 X174.156 Y161.966 I1.406 J1.35 E.04668
G2 X174.479 Y162.621 I.805 J.01 E.02438
G1 X175.25 Y163.236 E.03172
G1 X173.215 Y163.236 E.06544
G2 X172.9 Y162.621 I-.762 J.002 E.02306
G1 X172.078 Y161.966 E.0338
G1 X171.764 Y161.47 E.01886
G1 X171.764 Y160.119 E.04343
G1 X172.68 Y159.345 E.03857
G2 X173.223 Y158.035 I-1.406 J-1.35 E.04668
G2 X172.9 Y157.379 I-.805 J-.01 E.02438
G1 X172.129 Y156.764 E.03172
G1 X171.764 Y156.764 E.01172
G1 X171.764 Y158.028 E.04064
; CHANGE_LAYER
; Z_HEIGHT: 5
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F8843.478
G1 X171.764 Y156.764 E-.48026
G1 X172.129 Y156.764 E-.1385
G1 X172.42 Y156.996 E-.14124
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 25/50
; update layer progress
M73 L25
M991 S0 P24 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z5.2 I-.889 J.831 P1  F60000
G1 X178.584 Y163.584 Z5.2
G1 Z5
G1 E.8 F1800
; FEATURE: Inner wall
G1 F1200
M204 S8000
G1 X171.416 Y163.584 E.23048
G1 X171.416 Y156.416 E.23048
G1 X178.584 Y156.416 E.23048
G1 X178.584 Y163.524 E.22855
; COOLING_NODE: 0
M204 S10000
G1 X178.991 Y163.991 F60000
G1 F1200
M204 S8000
G1 X171.009 Y163.991 E.25666
G1 X171.009 Y156.009 E.25666
G1 X178.991 Y156.009 E.25666
G1 X178.991 Y163.931 E.25473
; COOLING_NODE: 0
M204 S10000
G1 X179.398 Y164.398 F60000
G1 F1200
M204 S8000
G1 X170.602 Y164.398 E.28284
G1 X170.602 Y155.602 E.28284
G1 X179.398 Y155.602 E.28284
G1 X179.398 Y164.338 E.28091
; COOLING_NODE: 0
M204 S250
G1 X179.79 Y164.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
M73 P69 R4
G1 X170.21 Y164.79 E.28536
G1 X170.21 Y155.21 E.28536
G1 X179.79 Y155.21 E.28536
G1 X179.79 Y164.73 E.28357
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
G1 X177.79 Y164.743 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X178.236 Y161.513 Z5.4 F60000
G1 Z5
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X178.236 Y163.142 E.05236
G2 X177.232 Y161.966 I-3.347 J1.839 E.05005
G3 X176.949 Y160.655 I1.362 J-.981 E.04435
G3 X178.009 Y159.345 I3.168 J1.48 E.05474
G1 X178.236 Y158.823 E.01829
G1 X178.236 Y157.9 E.02968
G2 X177.272 Y156.764 I-3.239 J1.772 E.04823
G1 X174.345 Y156.764 E.09411
G2 X175.388 Y158.035 I3.187 J-1.555 E.05334
G3 X175.672 Y159.345 I-1.362 J.981 E.04435
G3 X174.612 Y160.655 I-3.168 J-1.48 E.05474
G2 X174.328 Y161.966 I1.362 J.981 E.04435
G2 X175.349 Y163.236 I3.075 J-1.426 E.05292
G1 X173.034 Y163.236 E.07443
G2 X171.991 Y161.966 I-3.187 J1.555 E.05333
G1 X171.764 Y161.444 E.01829
G1 X171.764 Y160.521 E.02967
G3 X172.768 Y159.345 I3.346 J1.838 E.05006
G2 X173.052 Y158.035 I-1.362 J-.981 E.04435
G2 X172.03 Y156.764 I-3.075 J1.427 E.05292
G1 X171.764 Y156.764 E.00855
G1 X171.764 Y158.127 E.04381
; CHANGE_LAYER
; Z_HEIGHT: 5.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F8843.478
G1 X171.764 Y156.764 E-.51769
G1 X172.03 Y156.764 E-.10108
G1 X172.284 Y157.036 E-.14124
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 26/50
; update layer progress
M73 L26
M991 S0 P25 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z5.4 I-.877 J.844 P1  F60000
G1 X178.584 Y163.584 Z5.4
G1 Z5.2
G1 E.8 F1800
; FEATURE: Inner wall
G1 F1200
M204 S8000
G1 X171.416 Y163.584 E.23048
G1 X171.416 Y156.416 E.23048
G1 X178.584 Y156.416 E.23048
G1 X178.584 Y163.524 E.22855
; COOLING_NODE: 0
M204 S10000
G1 X178.991 Y163.991 F60000
G1 F1200
M204 S8000
G1 X171.009 Y163.991 E.25666
G1 X171.009 Y156.009 E.25666
G1 X178.991 Y156.009 E.25666
G1 X178.991 Y163.931 E.25473
; COOLING_NODE: 0
M204 S10000
G1 X179.398 Y164.398 F60000
G1 F1200
M204 S8000
G1 X170.602 Y164.398 E.28284
G1 X170.602 Y155.602 E.28284
G1 X179.398 Y155.602 E.28284
G1 X179.398 Y164.338 E.28091
; COOLING_NODE: 0
M204 S250
M73 P70 R4
G1 X179.79 Y164.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X170.21 Y164.79 E.28536
G1 X170.21 Y155.21 E.28536
G1 X179.79 Y155.21 E.28536
G1 X179.79 Y164.73 E.28357
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
G1 X177.79 Y164.743 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X178.236 Y161.715 Z5.6 F60000
G1 Z5.2
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X178.236 Y163.236 E.0489
G1 X178.128 Y163.236 E.00346
G1 X177.662 Y162.621 E.0248
G3 X177.083 Y160.655 I1.165 J-1.411 E.06993
G1 X177.579 Y160 E.02643
G2 X178.158 Y158.035 I-1.206 J-1.423 E.06975
G2 X177.163 Y156.764 I-19.696 J14.407 E.05189
G1 X174.493 Y156.764 E.08587
G1 X174.959 Y157.379 E.02481
G3 X175.538 Y159.345 I-1.165 J1.411 E.06993
G1 X175.041 Y160 E.02643
G2 X174.462 Y161.966 I1.165 J1.411 E.06993
G2 X175.457 Y163.236 I19.688 J-14.401 E.05189
G1 X172.887 Y163.236 E.08267
G1 X172.421 Y162.621 E.0248
G3 X171.842 Y160.655 I1.205 J-1.423 E.06976
G1 X172.338 Y160 E.02643
G2 X172.917 Y158.035 I-1.165 J-1.411 E.06993
G2 X171.922 Y156.764 I-19.701 J14.412 E.05189
G1 X171.764 Y156.764 E.00507
G1 X171.764 Y158.235 E.0473
; CHANGE_LAYER
; Z_HEIGHT: 5.4
; LAYER_HEIGHT: 0.2
; WIPE_START
M73 P70 R3
G1 F8843.478
G1 X171.764 Y156.764 E-.5589
G1 X171.922 Y156.764 E-.05986
G1 X172.151 Y157.057 E-.14124
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 27/50
; update layer progress
M73 L27
M991 S0 P26 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z5.6 I-.867 J.854 P1  F60000
G1 X178.584 Y163.584 Z5.6
G1 Z5.4
G1 E.8 F1800
; FEATURE: Inner wall
G1 F1200
M204 S8000
G1 X171.416 Y163.584 E.23048
G1 X171.416 Y156.416 E.23048
G1 X178.584 Y156.416 E.23048
G1 X178.584 Y163.524 E.22855
; COOLING_NODE: 0
M204 S10000
G1 X178.991 Y163.991 F60000
G1 F1200
M204 S8000
G1 X171.009 Y163.991 E.25666
G1 X171.009 Y156.009 E.25666
G1 X178.991 Y156.009 E.25666
G1 X178.991 Y163.931 E.25473
; COOLING_NODE: 0
M204 S10000
G1 X179.398 Y164.398 F60000
G1 F1200
M204 S8000
G1 X170.602 Y164.398 E.28284
M73 P71 R3
G1 X170.602 Y155.602 E.28284
G1 X179.398 Y155.602 E.28284
G1 X179.398 Y164.338 E.28091
; COOLING_NODE: 0
M204 S250
G1 X179.79 Y164.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X170.21 Y164.79 E.28536
G1 X170.21 Y155.21 E.28536
G1 X179.79 Y155.21 E.28536
G1 X179.79 Y164.73 E.28357
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
G1 X177.79 Y164.743 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X174.4 Y163.236 Z5.8 F60000
G1 Z5.4
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X172.771 Y163.236 E.05236
G3 X171.766 Y161.966 I3.178 J-3.548 E.05233
G3 X171.764 Y161.177 I5.188 J-.407 E.02539
G1 X171.951 Y160.655 E.01781
G2 X172.992 Y159.345 I-3.274 J-3.67 E.05408
G2 X172.218 Y157.379 I-1.972 J-.358 E.07155
G3 X171.787 Y156.764 I.961 J-1.132 E.02442
G1 X174.608 Y156.764 E.09073
G3 X175.613 Y158.035 I-3.179 J3.548 E.05233
G3 X174.838 Y160 I-1.972 J.358 E.07155
G2 X174.337 Y161.31 I.993 J1.131 E.04693
G1 X174.572 Y161.966 E.02238
G3 X175.593 Y163.236 I-3.351 J3.74 E.05263
G1 X178.013 Y163.236 E.07781
G3 X177.008 Y161.966 I3.178 J-3.547 E.05233
G3 X177.782 Y160 I1.972 J-.358 E.07155
G2 X178.236 Y159.32 I-1.256 J-1.328 E.02649
G2 X177.459 Y157.379 I-1.971 J-.338 E.07074
G3 X177.028 Y156.764 I.961 J-1.132 E.02442
G1 X175.4 Y156.764 E.05236
; CHANGE_LAYER
; Z_HEIGHT: 5.6
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F8843.478
G1 X177.028 Y156.764 E-.61876
G1 X177.172 Y157.052 E-.12212
G1 X177.205 Y157.09 E-.01912
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 28/50
; update layer progress
M73 L28
M991 S0 P27 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z5.8 I-1.19 J.253 P1  F60000
G1 X178.584 Y163.584 Z5.8
G1 Z5.6
G1 E.8 F1800
; FEATURE: Inner wall
G1 F1200
M204 S8000
G1 X171.416 Y163.584 E.23048
G1 X171.416 Y156.416 E.23048
G1 X178.584 Y156.416 E.23048
G1 X178.584 Y163.524 E.22855
; COOLING_NODE: 0
M204 S10000
G1 X178.991 Y163.991 F60000
G1 F1200
M204 S8000
G1 X171.009 Y163.991 E.25666
G1 X171.009 Y156.009 E.25666
G1 X178.991 Y156.009 E.25666
G1 X178.991 Y163.931 E.25473
; COOLING_NODE: 0
M204 S10000
G1 X179.398 Y164.398 F60000
M73 P72 R3
G1 F1200
M204 S8000
G1 X170.602 Y164.398 E.28284
G1 X170.602 Y155.602 E.28284
G1 X179.398 Y155.602 E.28284
G1 X179.398 Y164.338 E.28091
; COOLING_NODE: 0
M204 S250
G1 X179.79 Y164.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X170.21 Y164.79 E.28536
G1 X170.21 Y155.21 E.28536
G1 X179.79 Y155.21 E.28536
G1 X179.79 Y164.73 E.28357
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
G1 X177.79 Y164.743 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X174.298 Y163.236 Z6 F60000
G1 Z5.6
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X172.67 Y163.236 E.05236
G3 X171.764 Y162.356 I2.402 J-3.38 E.04074
G1 X171.764 Y161.165 E.03833
G1 X172.044 Y160.655 E.01868
G2 X173.046 Y159.672 I-2.691 J-3.748 E.04532
G1 X173.147 Y159.345 E.01102
G2 X172.715 Y158.035 I-1.803 J-.132 E.04552
G3 X171.764 Y157.115 I2.511 J-3.547 E.04269
G1 X171.764 Y156.764 E.01128
G1 X174.71 Y156.764 E.0947
G3 X175.667 Y157.707 I-2.582 J3.581 E.04338
G1 X175.767 Y158.035 E.01102
G3 X175.336 Y159.345 I-1.803 J.132 E.04552
G2 X174.333 Y160.328 I2.69 J3.748 E.04532
G1 X174.233 Y160.655 E.01102
G2 X174.664 Y161.966 I1.803 J.132 E.04552
G3 X175.667 Y162.948 I-2.69 J3.748 E.04532
G1 X175.755 Y163.236 E.00966
G1 X177.911 Y163.236 E.06933
G3 X176.954 Y162.293 I2.582 J-3.581 E.04337
G1 X176.853 Y161.966 E.01102
G3 X177.285 Y160.655 I1.803 J-.132 E.04552
G2 X178.236 Y159.736 I-2.51 J-3.546 E.04268
G1 X178.236 Y158.544 E.03834
G1 X177.956 Y158.035 E.01867
G3 X176.954 Y157.052 I2.691 J-3.748 E.04532
G1 X176.866 Y156.764 E.00966
G1 X178.236 Y156.764 E.04405
G1 X178.236 Y157.023 E.00831
; CHANGE_LAYER
; Z_HEIGHT: 5.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F8843.478
G1 X178.236 Y156.764 E-.09819
G1 X176.866 Y156.764 E-.52057
G1 X176.954 Y157.052 E-.1142
G1 X176.999 Y157.107 E-.02704
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 29/50
; update layer progress
M73 L29
M991 S0 P28 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z6 I-1.182 J.289 P1  F60000
G1 X178.584 Y163.584 Z6
G1 Z5.8
G1 E.8 F1800
; FEATURE: Inner wall
G1 F1200
M204 S8000
G1 X171.416 Y163.584 E.23048
G1 X171.416 Y156.416 E.23048
G1 X178.584 Y156.416 E.23048
G1 X178.584 Y163.524 E.22855
; COOLING_NODE: 0
M204 S10000
G1 X178.991 Y163.991 F60000
G1 F1200
M204 S8000
G1 X171.009 Y163.991 E.25666
G1 X171.009 Y156.009 E.25666
G1 X178.991 Y156.009 E.25666
G1 X178.991 Y163.931 E.25473
; COOLING_NODE: 0
M204 S10000
M73 P73 R3
G1 X179.398 Y164.398 F60000
G1 F1200
M204 S8000
G1 X170.602 Y164.398 E.28284
G1 X170.602 Y155.602 E.28284
G1 X179.398 Y155.602 E.28284
G1 X179.398 Y164.338 E.28091
; COOLING_NODE: 0
M204 S250
G1 X179.79 Y164.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X170.21 Y164.79 E.28536
G1 X170.21 Y155.21 E.28536
G1 X179.79 Y155.21 E.28536
G1 X179.79 Y164.73 E.28357
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
G1 X177.79 Y164.743 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X174.2 Y163.236 Z6.2 F60000
G1 Z5.8
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X172.571 Y163.236 E.05236
G1 X171.764 Y162.716 E.03086
G1 X171.764 Y161.126 E.05111
G1 X172.125 Y160.655 E.01908
G1 X173.142 Y160 E.0389
G2 X173.349 Y159.345 I-.372 J-.478 E.0235
G2 X171.764 Y157.474 I-2.686 J.669 E.08167
G1 X171.764 Y156.764 E.02283
G1 X174.808 Y156.764 E.09787
G1 X175.762 Y157.379 E.03651
G3 X175.97 Y158.035 I-.372 J.478 E.0235
G3 X175.255 Y159.345 I-2.228 J-.366 E.04893
G1 X174.238 Y160 E.0389
G2 X174.03 Y160.655 I.372 J.478 E.0235
G2 X174.746 Y161.966 I2.227 J-.366 E.04893
G1 X175.762 Y162.621 E.0389
G3 X175.971 Y163.236 I-.342 J.459 E.0222
G1 X177.813 Y163.236 E.05922
G1 X176.858 Y162.621 E.0365
G3 X176.651 Y161.966 I.372 J-.478 E.0235
G3 X178.236 Y160.095 I2.686 J.669 E.08167
G1 X178.236 Y158.506 E.05111
G1 X177.875 Y158.035 E.01907
G1 X176.858 Y157.379 E.0389
G3 X176.65 Y156.764 I.342 J-.459 E.0222
G1 X178.236 Y156.764 E.05099
G1 X178.236 Y156.807 E.00137
; CHANGE_LAYER
; Z_HEIGHT: 6
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F8843.478
G1 X178.236 Y156.764 E-.01622
G1 X176.65 Y156.764 E-.60254
G1 X176.643 Y157.052 E-.10922
G1 X176.69 Y157.122 E-.03202
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 30/50
; update layer progress
M73 L30
M991 S0 P29 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z6.2 I-1.168 J.342 P1  F60000
G1 X178.584 Y163.584 Z6.2
G1 Z6
G1 E.8 F1800
; FEATURE: Inner wall
G1 F1200
M204 S8000
G1 X171.416 Y163.584 E.23048
G1 X171.416 Y156.416 E.23048
G1 X178.584 Y156.416 E.23048
G1 X178.584 Y163.524 E.22855
; COOLING_NODE: 0
M204 S10000
G1 X178.991 Y163.991 F60000
G1 F1200
M204 S8000
M73 P74 R3
G1 X171.009 Y163.991 E.25666
G1 X171.009 Y156.009 E.25666
G1 X178.991 Y156.009 E.25666
G1 X178.991 Y163.931 E.25473
; COOLING_NODE: 0
M204 S10000
G1 X179.398 Y164.398 F60000
G1 F1200
M204 S8000
G1 X170.602 Y164.398 E.28284
G1 X170.602 Y155.602 E.28284
G1 X179.398 Y155.602 E.28284
G1 X179.398 Y164.338 E.28091
; COOLING_NODE: 0
M204 S250
G1 X179.79 Y164.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X170.21 Y164.79 E.28536
G1 X170.21 Y155.21 E.28536
G1 X179.79 Y155.21 E.28536
G1 X179.79 Y164.73 E.28357
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
G1 X177.79 Y164.743 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X178.236 Y162.146 Z6.4 F60000
G1 Z6
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X178.236 Y163.236 E.03503
G1 X177.697 Y163.236 E.01733
G1 X177.621 Y163.178 E.00306
G2 X176.638 Y162.968 I-.828 J1.467 E.03282
G2 X176.268 Y163.236 I.317 J.828 E.01486
G1 X172.455 Y163.236 E.1226
G1 X171.764 Y162.982 E.02366
G1 X171.764 Y161.023 E.06301
G3 X173.362 Y160.347 I1.637 J1.644 E.05717
G1 X173.69 Y160.567 E.01268
G1 X174.345 Y161.568 E.03847
G2 X175.983 Y162.274 I1.684 J-1.653 E.05882
G1 X176.31 Y162.054 E.01268
G1 X176.966 Y161.053 E.03847
G3 X178.236 Y160.362 I1.614 J1.452 E.04741
G1 X178.236 Y158.402 E.06301
G2 X176.638 Y157.726 I-1.637 J1.644 E.05717
G1 X176.31 Y157.946 E.01268
G1 X175.655 Y158.947 E.03847
G3 X174.017 Y159.653 I-1.684 J-1.653 E.05882
G1 X173.69 Y159.434 E.01268
G1 X173.035 Y158.433 E.03847
G2 X171.764 Y157.741 I-1.614 J1.453 E.04741
G1 X171.764 Y156.764 E.0314
G1 X174.924 Y156.764 E.1016
G1 X175 Y156.822 E.00307
G2 X175.983 Y157.033 I.828 J-1.467 E.03282
G2 X176.342 Y156.764 I-.137 J-.558 E.01481
G1 X177.97 Y156.764 E.05236
; CHANGE_LAYER
; Z_HEIGHT: 6.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F8843.478
G1 X176.342 Y156.764 E-.61876
G1 X176.044 Y156.987 E-.14125
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 31/50
; update layer progress
M73 L31
M991 S0 P30 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z6.4 I-1.136 J.437 P1  F60000
G1 X178.584 Y163.584 Z6.4
G1 Z6.2
G1 E.8 F1800
; FEATURE: Inner wall
G1 F1200
M204 S8000
G1 X171.416 Y163.584 E.23048
G1 X171.416 Y156.416 E.23048
G1 X178.584 Y156.416 E.23048
G1 X178.584 Y163.524 E.22855
; COOLING_NODE: 0
M204 S10000
M73 P75 R3
G1 X178.991 Y163.991 F60000
G1 F1200
M204 S8000
G1 X171.009 Y163.991 E.25666
G1 X171.009 Y156.009 E.25666
G1 X178.991 Y156.009 E.25666
G1 X178.991 Y163.931 E.25473
; COOLING_NODE: 0
M204 S10000
G1 X179.398 Y164.398 F60000
G1 F1200
M204 S8000
G1 X170.602 Y164.398 E.28284
G1 X170.602 Y155.602 E.28284
G1 X179.398 Y155.602 E.28284
G1 X179.398 Y164.338 E.28091
; COOLING_NODE: 0
M204 S250
G1 X179.79 Y164.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X170.21 Y164.79 E.28536
G1 X170.21 Y155.21 E.28536
G1 X179.79 Y155.21 E.28536
G1 X179.79 Y164.73 E.28357
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
G1 X177.79 Y164.743 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X178.236 Y162.243 Z6.6 F60000
G1 Z6.2
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X178.236 Y163.236 E.03191
G3 X176.966 Y163.17 I-.318 J-6.155 E.04097
G1 X176.756 Y163.236 E.00705
G1 X172.358 Y163.236 E.14142
G1 X171.764 Y163.174 E.0192
G1 X171.764 Y160.95 E.07151
G3 X173.362 Y160.652 I1.088 J1.4 E.05429
G3 X174.345 Y161.649 I-2.876 J3.818 E.04518
G2 X175.983 Y161.969 I1.125 J-1.407 E.05579
G2 X176.966 Y160.972 I-2.876 J-3.818 E.04518
G1 X177.621 Y160.617 E.02396
G1 X178.236 Y160.553 E.01988
G1 X178.236 Y158.329 E.07152
G2 X176.638 Y158.031 I-1.087 J1.4 E.05429
G2 X175.655 Y159.028 I2.876 J3.818 E.04518
G3 X174.017 Y159.348 I-1.125 J-1.407 E.05579
G3 X173.035 Y158.351 I2.876 J-3.818 E.04518
G1 X172.379 Y157.996 E.02396
G1 X171.764 Y157.933 E.01988
G1 X171.764 Y156.764 E.03756
G1 X175.02 Y156.764 E.10469
M73 P76 R3
G1 X175.655 Y156.83 E.02053
G1 X175.865 Y156.764 E.00706
G1 X177.493 Y156.764 E.05236
; CHANGE_LAYER
; Z_HEIGHT: 6.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F8843.478
G1 X175.865 Y156.764 E-.61876
G1 X175.655 Y156.83 E-.08344
G1 X175.504 Y156.815 E-.0578
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 32/50
; update layer progress
M73 L32
M991 S0 P31 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z6.6 I-1.108 J.504 P1  F60000
G1 X178.584 Y163.584 Z6.6
G1 Z6.4
G1 E.8 F1800
; FEATURE: Inner wall
G1 F1200
M204 S8000
G1 X171.416 Y163.584 E.23048
G1 X171.416 Y156.416 E.23048
G1 X178.584 Y156.416 E.23048
G1 X178.584 Y163.524 E.22855
; COOLING_NODE: 0
M204 S10000
G1 X178.991 Y163.991 F60000
G1 F1200
M204 S8000
G1 X171.009 Y163.991 E.25666
G1 X171.009 Y156.009 E.25666
G1 X178.991 Y156.009 E.25666
G1 X178.991 Y163.931 E.25473
; COOLING_NODE: 0
M204 S10000
G1 X179.398 Y164.398 F60000
G1 F1200
M204 S8000
G1 X170.602 Y164.398 E.28284
G1 X170.602 Y155.602 E.28284
G1 X179.398 Y155.602 E.28284
G1 X179.398 Y164.338 E.28091
; COOLING_NODE: 0
M204 S250
G1 X179.79 Y164.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X170.21 Y164.79 E.28536
G1 X170.21 Y155.21 E.28536
G1 X179.79 Y155.21 E.28536
G1 X179.79 Y164.73 E.28357
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
G1 X177.79 Y164.743 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.764 Y162.493 Z6.8 F60000
G1 Z6.4
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X171.764 Y160.864 E.05236
G3 X173.035 Y160.702 I.817 J1.34 E.04241
G1 X173.69 Y161.156 E.02563
G2 X175.655 Y161.919 I1.594 J-1.195 E.07143
G1 X176.31 Y161.465 E.02563
G3 X178.236 Y160.699 I1.585 J1.183 E.07012
G1 X178.236 Y158.244 E.07895
G2 X176.966 Y158.082 I-.817 J1.34 E.04241
G1 X176.31 Y158.536 E.02563
G3 X174.345 Y159.298 I-1.594 J-1.195 E.07143
G1 X173.69 Y158.844 E.02563
M73 P77 R3
G2 X171.764 Y158.078 I-1.585 J1.183 E.07012
G1 X171.764 Y156.764 E.04225
G1 X172.079 Y156.764 E.01011
; CHANGE_LAYER
; Z_HEIGHT: 6.6
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F8843.478
G1 X171.764 Y156.764 E-.11953
G1 X171.764 Y158.078 E-.49924
G1 X172.135 Y158.048 E-.14124
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 33/50
; update layer progress
M73 L33
M991 S0 P32 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z6.8 I-.793 J.923 P1  F60000
G1 X178.584 Y163.584 Z6.8
G1 Z6.6
G1 E.8 F1800
; FEATURE: Inner wall
G1 F1200
M204 S8000
G1 X171.416 Y163.584 E.23048
G1 X171.416 Y156.416 E.23048
G1 X178.584 Y156.416 E.23048
G1 X178.584 Y163.524 E.22855
; COOLING_NODE: 0
M204 S10000
G1 X178.991 Y163.991 F60000
G1 F1200
M204 S8000
G1 X171.009 Y163.991 E.25666
G1 X171.009 Y156.009 E.25666
G1 X178.991 Y156.009 E.25666
G1 X178.991 Y163.931 E.25473
; COOLING_NODE: 0
M204 S10000
G1 X179.398 Y164.398 F60000
G1 F1200
M204 S8000
G1 X170.602 Y164.398 E.28284
G1 X170.602 Y155.602 E.28284
G1 X179.398 Y155.602 E.28284
G1 X179.398 Y164.338 E.28091
; COOLING_NODE: 0
M204 S250
G1 X179.79 Y164.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X170.21 Y164.79 E.28536
G1 X170.21 Y155.21 E.28536
G1 X179.79 Y155.21 E.28536
G1 X179.79 Y164.73 E.28357
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
G1 X177.79 Y164.743 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X178.236 Y162.442 Z7 F60000
G1 Z6.6
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X178.236 Y160.814 E.05236
G2 X176.31 Y161.262 I-.648 J1.576 E.06781
G1 X175.655 Y161.797 E.02719
G3 X173.69 Y161.359 I-.679 J-1.581 E.06917
G1 X173.035 Y160.824 E.02719
G2 X171.764 Y160.761 I-.704 J1.37 E.04215
G1 X171.764 Y158.193 E.08258
M73 P77 R2
G3 X173.69 Y158.641 I.648 J1.576 E.06781
G1 X174.345 Y159.176 E.02719
G2 X176.31 Y158.738 I.679 J-1.581 E.06917
M73 P78 R2
G1 X176.966 Y158.204 E.02719
G3 X178.236 Y158.141 I.704 J1.37 E.04215
G1 X178.236 Y156.764 E.04425
G1 X177.983 Y156.764 E.00811
; CHANGE_LAYER
; Z_HEIGHT: 6.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F8843.478
G1 X178.236 Y156.764 E-.0958
G1 X178.236 Y158.141 E-.52296
G1 X177.869 Y158.077 E-.14124
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 34/50
; update layer progress
M73 L34
M991 S0 P33 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z7 I-1.207 J.157 P1  F60000
G1 X178.584 Y163.584 Z7
G1 Z6.8
G1 E.8 F1800
; FEATURE: Inner wall
G1 F1200
M204 S8000
G1 X171.416 Y163.584 E.23048
G1 X171.416 Y156.416 E.23048
G1 X178.584 Y156.416 E.23048
G1 X178.584 Y163.524 E.22855
; COOLING_NODE: 0
M204 S10000
G1 X178.991 Y163.991 F60000
G1 F1200
M204 S8000
G1 X171.009 Y163.991 E.25666
G1 X171.009 Y156.009 E.25666
G1 X178.991 Y156.009 E.25666
G1 X178.991 Y163.931 E.25473
; COOLING_NODE: 0
M204 S10000
G1 X179.398 Y164.398 F60000
G1 F1200
M204 S8000
G1 X170.602 Y164.398 E.28284
G1 X170.602 Y155.602 E.28284
G1 X179.398 Y155.602 E.28284
G1 X179.398 Y164.338 E.28091
; COOLING_NODE: 0
M204 S250
G1 X179.79 Y164.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X170.21 Y164.79 E.28536
G1 X170.21 Y155.21 E.28536
G1 X179.79 Y155.21 E.28536
G1 X179.79 Y164.73 E.28357
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
G1 X177.79 Y164.743 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X178.236 Y162.536 Z7.2 F60000
G1 Z6.8
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X178.236 Y160.908 E.05236
G2 X176.31 Y161.05 I-.881 J1.166 E.0678
G1 X175.655 Y161.695 E.02957
G3 X174.017 Y161.85 I-.963 J-1.45 E.0551
G3 X173.035 Y160.925 I5.999 J-7.359 E.04343
G2 X171.764 Y160.633 I-.971 J1.315 E.04311
G1 X171.764 Y158.287 E.07544
G3 X173.69 Y158.43 I.882 J1.166 E.06781
G1 X174.345 Y159.075 E.02957
G2 X175.983 Y159.23 I.963 J-1.45 E.0551
M73 P79 R2
G2 X176.966 Y158.305 I-5.997 J-7.358 E.04343
G3 X178.236 Y158.012 I.971 J1.315 E.0431
G1 X178.236 Y156.764 E.04013
G1 X177.855 Y156.764 E.01223
; CHANGE_LAYER
; Z_HEIGHT: 7
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F8843.478
G1 X178.236 Y156.764 E-.14454
G1 X178.236 Y158.012 E-.47422
G1 X177.864 Y158.014 E-.14124
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 35/50
; update layer progress
M73 L35
M991 S0 P34 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z7.2 I-1.207 J.156 P1  F60000
G1 X178.584 Y163.584 Z7.2
G1 Z7
G1 E.8 F1800
; FEATURE: Inner wall
G1 F1200
M204 S8000
G1 X171.416 Y163.584 E.23048
G1 X171.416 Y156.416 E.23048
G1 X178.584 Y156.416 E.23048
G1 X178.584 Y163.524 E.22855
; COOLING_NODE: 0
M204 S10000
G1 X178.991 Y163.991 F60000
G1 F1200
M204 S8000
G1 X171.009 Y163.991 E.25666
G1 X171.009 Y156.009 E.25666
G1 X178.991 Y156.009 E.25666
G1 X178.991 Y163.931 E.25473
; COOLING_NODE: 0
M204 S10000
G1 X179.398 Y164.398 F60000
G1 F1200
M204 S8000
G1 X170.602 Y164.398 E.28284
G1 X170.602 Y155.602 E.28284
G1 X179.398 Y155.602 E.28284
G1 X179.398 Y164.338 E.28091
; COOLING_NODE: 0
M204 S250
G1 X179.79 Y164.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X170.21 Y164.79 E.28536
G1 X170.21 Y155.21 E.28536
G1 X179.79 Y155.21 E.28536
G1 X179.79 Y164.73 E.28357
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
G1 X177.79 Y164.743 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.764 Y162.187 Z7.4 F60000
G1 Z7
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X171.764 Y163.236 E.03373
G1 X172.344 Y163.236 E.01863
G1 X173.035 Y163.08 E.02277
G3 X173.482 Y163.236 I.074 J.509 E.01582
G1 X177.585 Y163.236 E.13195
G1 X178.236 Y163.088 E.02144
G1 X178.236 Y160.986 E.06758
G2 X176.966 Y160.459 I-1.313 J1.371 E.04524
G2 X176.31 Y160.778 I-.021 J.791 E.02434
G1 X175.655 Y161.608 E.03402
G3 X174.345 Y162.161 I-1.367 J-1.41 E.0468
M73 P80 R2
G3 X173.69 Y161.843 I-.021 J-.791 E.02434
G1 X173.035 Y161.012 E.03402
G1 X172.379 Y160.592 E.02503
G1 X171.764 Y160.468 E.02018
G1 X171.764 Y158.366 E.06758
G3 X173.035 Y157.839 I1.313 J1.371 E.04525
G3 X173.69 Y158.157 I.021 J.791 E.02434
G1 X174.345 Y158.988 E.03402
G2 X175.655 Y159.541 I1.367 J-1.41 E.0468
G2 X176.31 Y159.222 I.021 J-.791 E.02434
G1 X176.966 Y158.392 E.03402
G1 X177.621 Y157.971 E.02503
G1 X178.236 Y157.847 E.02017
G1 X178.236 Y156.764 E.03481
G1 X175.036 Y156.764 E.10289
G1 X174.345 Y156.92 E.02277
G3 X173.897 Y156.764 I-.074 J-.509 E.01583
G1 X172.269 Y156.764 E.05236
; CHANGE_LAYER
; Z_HEIGHT: 7.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F8843.478
G1 X173.897 Y156.764 E-.61876
G1 X174.017 Y156.858 E-.05785
G1 X174.233 Y156.899 E-.0834
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 36/50
; update layer progress
M73 L36
M991 S0 P35 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z7.4 I-1.02 J.664 P1  F60000
G1 X178.584 Y163.584 Z7.4
G1 Z7.2
G1 E.8 F1800
; FEATURE: Inner wall
G1 F1200
M204 S8000
G1 X171.416 Y163.584 E.23048
G1 X171.416 Y156.416 E.23048
G1 X178.584 Y156.416 E.23048
G1 X178.584 Y163.524 E.22855
; COOLING_NODE: 0
M204 S10000
G1 X178.991 Y163.991 F60000
G1 F1200
M204 S8000
G1 X171.009 Y163.991 E.25666
G1 X171.009 Y156.009 E.25666
G1 X178.991 Y156.009 E.25666
G1 X178.991 Y163.931 E.25473
; COOLING_NODE: 0
M204 S10000
G1 X179.398 Y164.398 F60000
G1 F1200
M204 S8000
G1 X170.602 Y164.398 E.28284
G1 X170.602 Y155.602 E.28284
G1 X179.398 Y155.602 E.28284
G1 X179.398 Y164.338 E.28091
; COOLING_NODE: 0
M204 S250
G1 X179.79 Y164.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X170.21 Y164.79 E.28536
G1 X170.21 Y155.21 E.28536
G1 X179.79 Y155.21 E.28536
G1 X179.79 Y164.73 E.28357
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
G1 X177.79 Y164.743 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
M73 P81 R2
G1 X171.764 Y162.079 Z7.6 F60000
G1 Z7.2
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X171.764 Y163.236 E.03718
G1 X172.237 Y163.236 E.01518
G1 X172.379 Y163.137 E.00558
G3 X173.69 Y162.771 I1.171 J1.662 E.04461
G1 X173.881 Y163.236 E.01616
G1 X177.478 Y163.236 E.11567
G3 X178.236 Y162.866 I1.356 J1.819 E.02727
G1 X178.236 Y161.047 E.05851
G2 X177.621 Y160.517 I-1.533 J1.157 E.0263
G2 X176.31 Y160.15 I-1.171 J1.662 E.04461
G1 X175.983 Y160.947 E.02769
G3 X175 Y162.104 I-2.274 J-.935 E.04964
G3 X173.69 Y162.471 I-1.171 J-1.662 E.04461
G1 X173.362 Y161.674 E.02769
G2 X171.764 Y160.245 I-2.272 J.933 E.07132
G1 X171.764 Y158.426 E.0585
G3 X172.379 Y157.896 I1.534 J1.157 E.02631
G3 X173.69 Y157.53 I1.171 J1.662 E.04461
G1 X174.017 Y158.326 E.02769
G2 X175 Y159.483 I2.274 J-.935 E.04964
G2 X176.31 Y159.85 I1.171 J-1.662 E.04461
G1 X176.638 Y159.053 E.02769
G3 X178.236 Y157.625 I2.272 J.933 E.07131
G1 X178.236 Y156.764 E.02767
G1 X175.143 Y156.764 E.09944
G1 X175 Y156.863 E.00558
G3 X173.69 Y157.229 I-1.171 J-1.662 E.04461
G1 X173.499 Y156.764 E.01616
G1 X171.87 Y156.764 E.05236
; CHANGE_LAYER
; Z_HEIGHT: 7.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F8843.478
G1 X173.499 Y156.764 E-.61876
G1 X173.64 Y157.108 E-.14124
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 37/50
; update layer progress
M73 L37
M991 S0 P36 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z7.6 I-.967 J.738 P1  F60000
G1 X178.584 Y163.584 Z7.6
G1 Z7.4
G1 E.8 F1800
; FEATURE: Inner wall
G1 F1200
M204 S8000
G1 X171.416 Y163.584 E.23048
G1 X171.416 Y156.416 E.23048
G1 X178.584 Y156.416 E.23048
G1 X178.584 Y163.524 E.22855
; COOLING_NODE: 0
M204 S10000
G1 X178.991 Y163.991 F60000
G1 F1200
M204 S8000
G1 X171.009 Y163.991 E.25666
G1 X171.009 Y156.009 E.25666
G1 X178.991 Y156.009 E.25666
G1 X178.991 Y163.931 E.25473
; COOLING_NODE: 0
M204 S10000
G1 X179.398 Y164.398 F60000
G1 F1200
M204 S8000
G1 X170.602 Y164.398 E.28284
G1 X170.602 Y155.602 E.28284
G1 X179.398 Y155.602 E.28284
G1 X179.398 Y164.338 E.28091
; COOLING_NODE: 0
M204 S250
G1 X179.79 Y164.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X170.21 Y164.79 E.28536
G1 X170.21 Y155.21 E.28536
G1 X179.79 Y155.21 E.28536
G1 X179.79 Y164.73 E.28357
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
M73 P82 R2
G1 X177.79 Y164.743 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.752 Y163.236 Z7.8 F60000
G1 Z7.4
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X177.38 Y163.236 E.05236
G1 X178.236 Y162.545 E.03535
G1 X178.236 Y161.146 E.04497
G1 X177.913 Y160.655 E.01889
G1 X177.065 Y160 E.03447
G1 X176.811 Y159.672 E.01332
G3 X177.328 Y158.035 I1.969 J-.279 E.05711
G1 X178.236 Y157.304 E.03747
G1 X178.236 Y156.764 E.01733
G1 X175.24 Y156.764 E.09631
G1 X174.444 Y157.379 E.03236
G1 X174.19 Y157.707 E.01332
G2 X174.708 Y159.345 I1.969 J.279 E.05711
G1 X175.556 Y160 E.03447
G1 X175.81 Y160.328 E.01332
G3 X175.293 Y161.966 I-1.969 J.279 E.05711
G1 X174.444 Y162.621 E.03447
G2 X174.142 Y163.236 I.421 J.588 E.02294
G1 X172.139 Y163.236 E.06441
G1 X172.935 Y162.621 E.03235
G1 X173.189 Y162.293 E.01332
G2 X172.672 Y160.655 I-1.969 J-.279 E.05711
G1 X171.764 Y159.924 E.03747
G1 X171.764 Y158.526 E.04496
G1 X172.087 Y158.035 E.0189
G1 X172.935 Y157.379 E.03447
G2 X173.237 Y156.764 I-.421 J-.588 E.02295
G1 X171.764 Y156.764 E.04736
G1 X171.764 Y156.92 E.005
; CHANGE_LAYER
; Z_HEIGHT: 7.6
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F8843.478
G1 X171.764 Y156.764 E-.0591
G1 X173.237 Y156.764 E-.55966
G1 X173.189 Y157.052 E-.11071
G1 X173.14 Y157.115 E-.03053
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 38/50
; update layer progress
M73 L38
M991 S0 P37 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z7.8 I-.931 J.784 P1  F60000
G1 X178.584 Y163.584 Z7.8
G1 Z7.6
G1 E.8 F1800
; FEATURE: Inner wall
G1 F1200
M204 S8000
G1 X171.416 Y163.584 E.23048
G1 X171.416 Y156.416 E.23048
G1 X178.584 Y156.416 E.23048
G1 X178.584 Y163.524 E.22855
; COOLING_NODE: 0
M204 S10000
G1 X178.991 Y163.991 F60000
G1 F1200
M204 S8000
G1 X171.009 Y163.991 E.25666
G1 X171.009 Y156.009 E.25666
G1 X178.991 Y156.009 E.25666
G1 X178.991 Y163.931 E.25473
; COOLING_NODE: 0
M204 S10000
G1 X179.398 Y164.398 F60000
G1 F1200
M204 S8000
G1 X170.602 Y164.398 E.28284
G1 X170.602 Y155.602 E.28284
G1 X179.398 Y155.602 E.28284
G1 X179.398 Y164.338 E.28091
; COOLING_NODE: 0
M204 S250
G1 X179.79 Y164.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X170.21 Y164.79 E.28536
G1 X170.21 Y155.21 E.28536
G1 X179.79 Y155.21 E.28536
G1 X179.79 Y164.73 E.28357
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
M73 P83 R2
G1 F9547.055
M204 S8000
G1 X177.79 Y164.743 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.654 Y163.236 Z8 F60000
G1 Z7.6
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X177.282 Y163.236 E.05236
G2 X178.236 Y162.145 I-2.216 J-2.899 E.04689
G1 X178.236 Y161.175 E.03117
G1 X177.999 Y160.655 E.01837
G3 X177.066 Y159.672 I5.634 J-6.283 E.04362
G3 X177.242 Y158.035 I1.617 J-.655 E.05517
G1 X177.897 Y157.379 E.02978
G2 X178.236 Y156.764 I-.374 J-.607 E.02361
G1 X175.339 Y156.764 E.09316
G2 X174.446 Y157.707 I5.403 J6.013 E.04179
G2 X174.621 Y159.345 I1.617 J.655 E.05517
G3 X175.554 Y160.328 I-5.634 J6.284 E.04362
G3 X175.379 Y161.966 I-1.617 J.655 E.05517
G1 X174.724 Y162.621 E.02978
G2 X174.329 Y163.236 I.737 J.909 E.02391
G1 X172.041 Y163.236 E.07356
G2 X172.934 Y162.293 I-5.404 J-6.013 E.04179
G2 X172.758 Y160.655 I-1.617 J-.655 E.05517
G3 X171.764 Y159.524 I2.283 J-3.007 E.04874
G1 X171.764 Y158.555 E.03116
G1 X172.001 Y158.035 E.01838
G1 X172.655 Y157.379 E.02978
G2 X173.051 Y156.764 I-.737 J-.909 E.02391
G1 X171.764 Y156.764 E.04137
G1 X171.764 Y157.106 E.01099
; CHANGE_LAYER
; Z_HEIGHT: 7.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F8843.478
G1 X171.764 Y156.764 E-.12991
G1 X173.051 Y156.764 E-.48885
G1 X172.934 Y157.052 E-.11791
G1 X172.894 Y157.099 E-.02333
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 39/50
; update layer progress
M73 L39
M991 S0 P38 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z8 I-.915 J.803 P1  F60000
G1 X178.584 Y163.584 Z8
G1 Z7.8
G1 E.8 F1800
; FEATURE: Inner wall
G1 F1200
M204 S8000
G1 X171.416 Y163.584 E.23048
G1 X171.416 Y156.416 E.23048
G1 X178.584 Y156.416 E.23048
G1 X178.584 Y163.524 E.22855
; COOLING_NODE: 0
M204 S10000
G1 X178.991 Y163.991 F60000
G1 F1200
M204 S8000
G1 X171.009 Y163.991 E.25666
G1 X171.009 Y156.009 E.25666
G1 X178.991 Y156.009 E.25666
G1 X178.991 Y163.931 E.25473
; COOLING_NODE: 0
M204 S10000
G1 X179.398 Y164.398 F60000
G1 F1200
M204 S8000
G1 X170.602 Y164.398 E.28284
G1 X170.602 Y155.602 E.28284
G1 X179.398 Y155.602 E.28284
G1 X179.398 Y164.338 E.28091
; COOLING_NODE: 0
M204 S250
G1 X179.79 Y164.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X170.21 Y164.79 E.28536
M73 P84 R2
G1 X170.21 Y155.21 E.28536
G1 X179.79 Y155.21 E.28536
G1 X179.79 Y164.73 E.28357
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
G1 X177.79 Y164.743 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.547 Y163.236 Z8.2 F60000
G1 Z7.8
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X177.175 Y163.236 E.05236
G1 X177.683 Y162.621 E.02564
G2 X178.099 Y160.655 I-1.151 J-1.271 E.06903
G1 X177.559 Y160 E.02732
G3 X177.142 Y158.035 I1.141 J-1.269 E.06908
G2 X178.141 Y156.764 I-12.268 J-10.677 E.05198
G1 X175.446 Y156.764 E.08668
G1 X174.938 Y157.379 E.02564
G2 X174.521 Y159.345 I1.141 J1.269 E.06908
G1 X175.062 Y160 E.02732
G3 X175.479 Y161.966 I-1.141 J1.269 E.06908
G2 X174.48 Y163.236 I12.268 J10.678 E.05198
G1 X171.934 Y163.236 E.08186
G1 X172.442 Y162.621 E.02564
G2 X172.858 Y160.655 I-1.141 J-1.269 E.06908
G1 X172.317 Y160 E.02732
G3 X171.901 Y158.035 I1.151 J-1.271 E.06903
G2 X172.9 Y156.764 I-12.268 J-10.677 E.05198
G1 X174.528 Y156.764 E.05236
; CHANGE_LAYER
; Z_HEIGHT: 8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F8843.478
G1 X172.9 Y156.764 E-.61876
G1 X172.67 Y157.057 E-.14124
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 40/50
; update layer progress
M73 L40
M991 S0 P39 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z8.2 I-.902 J.817 P1  F60000
G1 X178.584 Y163.584 Z8.2
G1 Z8
G1 E.8 F1800
; FEATURE: Inner wall
G1 F1200
M204 S8000
G1 X171.416 Y163.584 E.23048
G1 X171.416 Y156.416 E.23048
G1 X178.584 Y156.416 E.23048
G1 X178.584 Y163.524 E.22855
; COOLING_NODE: 0
M204 S10000
G1 X178.991 Y163.991 F60000
G1 F1200
M204 S8000
G1 X171.009 Y163.991 E.25666
G1 X171.009 Y156.009 E.25666
G1 X178.991 Y156.009 E.25666
G1 X178.991 Y163.931 E.25473
; COOLING_NODE: 0
M204 S10000
G1 X179.398 Y164.398 F60000
G1 F1200
M204 S8000
G1 X170.602 Y164.398 E.28284
G1 X170.602 Y155.602 E.28284
G1 X179.398 Y155.602 E.28284
G1 X179.398 Y164.338 E.28091
; COOLING_NODE: 0
M204 S250
G1 X179.79 Y164.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
M73 P85 R2
G1 X170.21 Y164.79 E.28536
G1 X170.21 Y155.21 E.28536
G1 X179.79 Y155.21 E.28536
G1 X179.79 Y164.73 E.28357
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
G1 X177.79 Y164.743 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
M73 P85 R1
G1 X178.236 Y158.181 Z8.4 F60000
G1 Z8
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X178.236 Y156.764 E.04555
G1 X178.024 Y156.764 E.00681
G2 X177.022 Y158.035 I5.132 J5.08 E.05213
G2 X177.182 Y159.345 I1.543 J.476 E.04373
G3 X178.22 Y160.655 I-5.293 J5.258 E.05386
G3 X178.059 Y161.966 I-2.736 J.33 E.04287
G2 X177.05 Y163.236 I5.128 J5.112 E.05228
G1 X174.597 Y163.236 E.07888
G2 X175.599 Y161.966 I-5.131 J-5.079 E.05213
G2 X175.439 Y160.655 I-1.543 J-.476 E.04373
G3 X174.401 Y159.345 I5.293 J-5.258 E.05386
G3 X174.561 Y158.035 I1.543 J-.476 E.04373
G2 X175.571 Y156.764 I-5.128 J-5.112 E.05228
G1 X172.783 Y156.764 E.08966
G2 X171.78 Y158.035 I5.132 J5.08 E.05213
G2 X171.941 Y159.345 I2.732 J.331 E.04287
G3 X172.978 Y160.655 I-5.292 J5.257 E.05386
G3 X172.818 Y161.966 I-1.543 J.476 E.04373
G2 X171.809 Y163.236 I5.127 J5.111 E.05228
G1 X171.764 Y163.236 E.00142
G1 X171.764 Y161.651 E.05094
; CHANGE_LAYER
; Z_HEIGHT: 8.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F8843.478
G1 X171.764 Y163.236 E-.60198
G1 X171.809 Y163.236 E-.01678
G1 X172.022 Y162.931 E-.14124
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 41/50
; update layer progress
M73 L41
M991 S0 P40 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z8.4 I-.12 J1.211 P1  F60000
G1 X178.584 Y163.584 Z8.4
G1 Z8.2
G1 E.8 F1800
; FEATURE: Inner wall
G1 F1200
M204 S8000
G1 X171.416 Y163.584 E.23048
G1 X171.416 Y156.416 E.23048
G1 X178.584 Y156.416 E.23048
G1 X178.584 Y163.524 E.22855
; COOLING_NODE: 0
M204 S10000
G1 X178.991 Y163.991 F60000
G1 F1200
M204 S8000
G1 X171.009 Y163.991 E.25666
G1 X171.009 Y156.009 E.25666
G1 X178.991 Y156.009 E.25666
G1 X178.991 Y163.931 E.25473
; COOLING_NODE: 0
M204 S10000
G1 X179.398 Y164.398 F60000
G1 F1200
M204 S8000
G1 X170.602 Y164.398 E.28284
G1 X170.602 Y155.602 E.28284
G1 X179.398 Y155.602 E.28284
G1 X179.398 Y164.338 E.28091
; COOLING_NODE: 0
M204 S250
M73 P86 R1
G1 X179.79 Y164.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X170.21 Y164.79 E.28536
G1 X170.21 Y155.21 E.28536
G1 X179.79 Y155.21 E.28536
G1 X179.79 Y164.73 E.28357
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
G1 X177.79 Y164.743 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X178.236 Y158.079 Z8.6 F60000
G1 Z8.2
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X178.236 Y156.764 E.04226
G1 X177.921 Y156.764 E.0101
G2 X176.979 Y157.707 I2.97 J3.912 E.04299
G2 X177.276 Y159.345 I1.706 J.536 E.05568
G3 X178.236 Y160.295 I-2.991 J3.978 E.04356
G1 X178.236 Y161.453 E.03724
G1 X177.965 Y161.966 E.01862
G1 X177.251 Y162.621 E.03117
G2 X176.884 Y163.236 I.6 J.774 E.02356
G1 X174.7 Y163.236 E.07026
G2 X175.642 Y162.293 I-2.97 J-3.911 E.04298
G2 X175.345 Y160.655 I-1.707 J-.536 E.05568
G3 X174.358 Y159.672 I3.095 J-4.092 E.04491
G3 X174.656 Y158.035 I1.707 J-.536 E.05568
G1 X175.37 Y157.379 E.03117
G2 X175.736 Y156.764 I-.6 J-.774 E.02357
G1 X172.68 Y156.764 E.09828
G2 X171.764 Y157.675 I2.866 J3.799 E.04165
G1 X171.764 Y158.833 E.03723
G1 X172.035 Y159.345 E.01863
G3 X173.021 Y160.328 I-3.095 J4.092 E.04491
G3 X172.724 Y161.966 I-1.706 J.536 E.05568
G2 X171.764 Y162.916 I2.991 J3.979 E.04357
G1 X171.764 Y161.288 E.05236
; CHANGE_LAYER
; Z_HEIGHT: 8.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F8843.478
G1 X171.764 Y162.916 E-.61876
G1 X172.029 Y162.655 E-.14124
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 42/50
; update layer progress
M73 L42
M991 S0 P41 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z8.6 I-.171 J1.205 P1  F60000
G1 X178.584 Y163.584 Z8.6
G1 Z8.4
G1 E.8 F1800
; FEATURE: Inner wall
G1 F1200
M204 S8000
G1 X171.416 Y163.584 E.23048
G1 X171.416 Y156.416 E.23048
G1 X178.584 Y156.416 E.23048
G1 X178.584 Y163.524 E.22855
; COOLING_NODE: 0
M204 S10000
G1 X178.991 Y163.991 F60000
G1 F1200
M204 S8000
G1 X171.009 Y163.991 E.25666
G1 X171.009 Y156.009 E.25666
G1 X178.991 Y156.009 E.25666
G1 X178.991 Y163.931 E.25473
; COOLING_NODE: 0
M204 S10000
G1 X179.398 Y164.398 F60000
G1 F1200
M204 S8000
G1 X170.602 Y164.398 E.28284
M73 P87 R1
G1 X170.602 Y155.602 E.28284
G1 X179.398 Y155.602 E.28284
G1 X179.398 Y164.338 E.28091
; COOLING_NODE: 0
M204 S250
G1 X179.79 Y164.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X170.21 Y164.79 E.28536
G1 X170.21 Y155.21 E.28536
G1 X179.79 Y155.21 E.28536
G1 X179.79 Y164.73 E.28357
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
G1 X177.79 Y164.743 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X178.236 Y157.981 Z8.8 F60000
G1 Z8.4
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X178.236 Y156.764 E.03911
G1 X177.823 Y156.764 E.01325
G1 X176.91 Y157.379 E.0354
G1 X176.683 Y157.707 E.01282
G2 X177.358 Y159.345 I2.28 J.018 E.05851
G1 X178.236 Y159.936 E.03401
G1 X178.236 Y161.49 E.04998
G1 X177.883 Y161.966 E.01903
G1 X176.91 Y162.621 E.03772
G2 X176.676 Y163.236 I.35 J.486 E.0224
G1 X174.798 Y163.236 E.06039
G1 X175.71 Y162.621 E.03539
G1 X175.938 Y162.293 E.01282
G2 X175.263 Y160.655 I-2.28 J-.018 E.05851
G1 X174.29 Y160 E.03772
G1 X174.062 Y159.672 E.01282
G3 X174.738 Y158.035 I2.28 J-.018 E.05851
G1 X175.71 Y157.379 E.03772
G2 X175.945 Y156.764 I-.351 J-.486 E.02241
G1 X172.582 Y156.764 E.10814
G1 X171.764 Y157.315 E.0317
G1 X171.764 Y158.869 E.04997
G1 X172.117 Y159.345 E.01904
G1 X173.09 Y160 E.03772
G1 X173.317 Y160.328 E.01282
G3 X172.642 Y161.966 I-2.28 J.018 E.05851
G1 X171.764 Y162.556 E.03401
G1 X171.764 Y163.236 E.02184
G1 X172.714 Y163.236 E.03052
; CHANGE_LAYER
; Z_HEIGHT: 8.6
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F8843.478
G1 X171.764 Y163.236 E-.3607
G1 X171.764 Y162.556 E-.25807
G1 X172.073 Y162.349 E-.14124
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 43/50
; update layer progress
M73 L43
M991 S0 P42 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z8.8 I-.227 J1.196 P1  F60000
G1 X178.584 Y163.584 Z8.8
G1 Z8.6
G1 E.8 F1800
; FEATURE: Inner wall
G1 F1200
M204 S8000
G1 X171.416 Y163.584 E.23048
G1 X171.416 Y156.416 E.23048
G1 X178.584 Y156.416 E.23048
G1 X178.584 Y163.524 E.22855
; COOLING_NODE: 0
M204 S10000
G1 X178.991 Y163.991 F60000
G1 F1200
M204 S8000
G1 X171.009 Y163.991 E.25666
G1 X171.009 Y156.009 E.25666
G1 X178.991 Y156.009 E.25666
G1 X178.991 Y163.931 E.25473
; COOLING_NODE: 0
M204 S10000
G1 X179.398 Y164.398 F60000
M73 P88 R1
G1 F1200
M204 S8000
G1 X170.602 Y164.398 E.28284
G1 X170.602 Y155.602 E.28284
G1 X179.398 Y155.602 E.28284
G1 X179.398 Y164.338 E.28091
; COOLING_NODE: 0
M204 S250
G1 X179.79 Y164.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X170.21 Y164.79 E.28536
G1 X170.21 Y155.21 E.28536
G1 X179.79 Y155.21 E.28536
G1 X179.79 Y164.73 E.28357
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
G1 X177.79 Y164.743 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X178.024 Y163.236 Z9 F60000
G1 Z8.6
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X176.396 Y163.236 E.05236
G2 X175.655 Y162.945 I-.621 J.495 E.02679
G1 X174.916 Y163.236 E.02553
G1 X171.764 Y163.236 E.10135
G1 X171.764 Y162.283 E.03065
G2 X173.035 Y161.56 I-.412 J-2.202 E.04787
G1 X173.69 Y160.51 E.03978
G3 X174.345 Y160.324 I.459 J.371 E.02334
G3 X175.655 Y161.061 I-.412 J2.267 E.04924
G1 X176.31 Y162.11 E.03978
G2 X176.966 Y162.296 I.459 J-.371 E.02334
G2 X178.236 Y161.591 I-.387 J-2.193 E.04758
G1 X178.236 Y159.662 E.06204
G3 X176.966 Y158.939 I.412 J-2.202 E.04787
G1 X176.31 Y157.89 E.03978
G2 X175.655 Y157.704 I-.459 J.371 E.02334
G2 X174.345 Y158.44 I.412 J2.267 E.04924
G1 X173.69 Y159.49 E.03978
G3 X173.035 Y159.676 I-.459 J-.371 E.02334
G3 X171.764 Y158.97 I.387 J-2.193 E.04759
G1 X171.764 Y157.041 E.06204
G1 X172.463 Y156.764 E.02417
G1 X176.245 Y156.764 E.1216
G2 X176.966 Y157.055 I.589 J-.422 E.02637
G1 X177.705 Y156.764 E.02554
G1 X178.236 Y156.764 E.01707
G1 X178.236 Y157.862 E.03529
; CHANGE_LAYER
; Z_HEIGHT: 8.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F8843.478
G1 X178.236 Y156.764 E-.41704
G1 X177.705 Y156.764 E-.20172
G1 X177.359 Y156.9 E-.14124
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 44/50
; update layer progress
M73 L44
M991 S0 P43 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z9 I-1.197 J.219 P1  F60000
G1 X178.584 Y163.584 Z9
G1 Z8.8
G1 E.8 F1800
; FEATURE: Inner wall
G1 F1200
M204 S8000
G1 X171.416 Y163.584 E.23048
G1 X171.416 Y156.416 E.23048
G1 X178.584 Y156.416 E.23048
G1 X178.584 Y163.524 E.22855
; COOLING_NODE: 0
M204 S10000
G1 X178.991 Y163.991 F60000
G1 F1200
M204 S8000
G1 X171.009 Y163.991 E.25666
M73 P89 R1
G1 X171.009 Y156.009 E.25666
G1 X178.991 Y156.009 E.25666
G1 X178.991 Y163.931 E.25473
; COOLING_NODE: 0
M204 S10000
G1 X179.398 Y164.398 F60000
G1 F1200
M204 S8000
G1 X170.602 Y164.398 E.28284
G1 X170.602 Y155.602 E.28284
G1 X179.398 Y155.602 E.28284
G1 X179.398 Y164.338 E.28091
; COOLING_NODE: 0
M204 S250
G1 X179.79 Y164.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X170.21 Y164.79 E.28536
G1 X170.21 Y155.21 E.28536
G1 X179.79 Y155.21 E.28536
G1 X179.79 Y164.73 E.28357
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
G1 X177.79 Y164.743 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X177.573 Y163.236 Z9.2 F60000
G1 Z8.8
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X175.944 Y163.236 E.05236
G1 X175.655 Y163.152 E.00968
G1 X174.995 Y163.236 E.02139
G1 X171.764 Y163.236 E.1039
G1 X171.764 Y162.085 E.037
G1 X172.379 Y162.008 E.01993
G1 X173.035 Y161.64 E.02417
G3 X174.017 Y160.626 I3.551 J2.458 E.04561
G1 X174.345 Y160.531 E.01097
G3 X175.655 Y160.981 I.106 J1.825 E.04569
G2 X176.638 Y161.995 I3.552 J-2.459 E.04561
G1 X176.966 Y162.09 E.01097
G2 X178.236 Y161.663 I.114 J-1.764 E.04419
G1 X178.236 Y159.464 E.0707
G1 X177.621 Y159.388 E.01992
G1 X176.966 Y159.019 E.02417
G2 X175.983 Y158.005 I-3.551 J2.458 E.04561
G1 X175.655 Y157.91 E.01097
G2 X174.345 Y158.36 I-.106 J1.825 E.04569
G3 X173.362 Y159.374 I-3.551 J-2.458 E.04561
G1 X173.035 Y159.469 E.01097
G3 X171.764 Y159.042 I-.114 J-1.765 E.04419
G1 X171.764 Y156.844 E.0707
G1 X172.384 Y156.764 E.02009
G1 X176.676 Y156.764 E.13801
G1 X176.966 Y156.849 E.00969
G1 X177.625 Y156.764 E.02139
G1 X178.236 Y156.764 E.01962
G1 X178.236 Y157.783 E.03274
; CHANGE_LAYER
; Z_HEIGHT: 9
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F8843.478
G1 X178.236 Y156.764 E-.38694
G1 X177.625 Y156.764 E-.23182
G1 X177.257 Y156.811 E-.14124
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 45/50
; update layer progress
M73 L45
M991 S0 P44 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z9.2 I-1.194 J.234 P1  F60000
G1 X178.584 Y163.584 Z9.2
G1 Z9
G1 E.8 F1800
; FEATURE: Inner wall
G1 F1200
M204 S8000
G1 X171.416 Y163.584 E.23048
G1 X171.416 Y156.416 E.23048
G1 X178.584 Y156.416 E.23048
G1 X178.584 Y163.524 E.22855
; COOLING_NODE: 0
M204 S10000
G1 X178.991 Y163.991 F60000
M73 P90 R1
G1 F1200
M204 S8000
G1 X171.009 Y163.991 E.25666
G1 X171.009 Y156.009 E.25666
G1 X178.991 Y156.009 E.25666
G1 X178.991 Y163.931 E.25473
; COOLING_NODE: 0
M204 S10000
G1 X179.398 Y164.398 F60000
G1 F1200
M204 S8000
G1 X170.602 Y164.398 E.28284
G1 X170.602 Y155.602 E.28284
G1 X179.398 Y155.602 E.28284
G1 X179.398 Y164.338 E.28091
; COOLING_NODE: 0
M204 S250
G1 X179.79 Y164.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X170.21 Y164.79 E.28536
G1 X170.21 Y155.21 E.28536
G1 X179.79 Y155.21 E.28536
G1 X179.79 Y164.73 E.28357
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
G1 X177.79 Y164.743 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.871 Y162.858 Z9.4 F60000
G1 Z9
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X172.142 Y162.858 E.02345
G1 X172.142 Y161.959 E.02891
G1 X172.379 Y161.975 E.00766
G1 X173.035 Y161.732 E.02247
G3 X174.017 Y160.848 I20.923 J22.282 E.0425
G3 X175.655 Y160.889 I.781 J1.55 E.05487
G2 X176.966 Y161.933 I3.486 J-3.032 E.05417
G1 X177.621 Y161.975 E.02111
G1 X177.858 Y161.886 E.00815
G1 X177.858 Y159.339 E.08193
G1 X177.621 Y159.354 E.00766
G1 X176.966 Y159.111 E.02247
G2 X175.983 Y158.228 I-20.884 J22.239 E.0425
G2 X174.345 Y158.268 I-.781 J1.55 E.05487
G3 X173.035 Y159.312 I-3.486 J-3.032 E.05417
G1 X172.379 Y159.354 E.02111
G1 X172.142 Y159.266 E.00815
G1 X172.142 Y157.637 E.05236
; WIPE_START
G1 F8843.478
G1 X172.142 Y159.266 E-.61876
G1 X172.379 Y159.354 E-.09635
G1 X172.497 Y159.346 E-.0449
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X178.221 Y156.938 Z9.4 F60000
G1 Z9
G1 E.8 F1800
; FEATURE: Floating vertical shell
; LINE_WIDTH: 0.383617
G1 F1200
M204 S8000
G1 X178.194 Y156.806 E.00362
G1 X178.062 Y156.779 E.00362
G1 X171.938 Y156.779 E.16481
G1 X171.806 Y156.806 E.00362
G1 X171.779 Y156.938 E.00362
G1 X171.779 Y163.062 E.16481
G1 X171.806 Y163.194 E.00362
G1 X171.938 Y163.221 E.00362
G1 X178.062 Y163.221 E.16481
M73 P91 R1
G1 X178.194 Y163.194 E.00362
G1 X178.221 Y163.062 E.00362
G1 X178.221 Y156.998 E.16319
; CHANGE_LAYER
; Z_HEIGHT: 9.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F10566.587
G1 X178.221 Y158.998 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 46/50
; update layer progress
M73 L46
M991 S0 P45 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z9.4 I-1.213 J.096 P1  F60000
G1 X178.584 Y163.584 Z9.4
G1 Z9.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X171.416 Y163.584 E.23048
G1 X171.416 Y156.416 E.23048
G1 X178.584 Y156.416 E.23048
G1 X178.584 Y163.524 E.22855
; COOLING_NODE: 0
M204 S10000
G1 X178.991 Y163.991 F60000
G1 F1200
M204 S8000
G1 X171.009 Y163.991 E.25666
G1 X171.009 Y156.009 E.25666
G1 X178.991 Y156.009 E.25666
G1 X178.991 Y163.931 E.25473
; COOLING_NODE: 0
M204 S10000
G1 X179.398 Y164.398 F60000
G1 F1200
M204 S8000
G1 X170.602 Y164.398 E.28284
G1 X170.602 Y155.602 E.28284
G1 X179.398 Y155.602 E.28284
G1 X179.398 Y164.338 E.28091
; COOLING_NODE: 0
M204 S250
G1 X179.79 Y164.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X170.21 Y164.79 E.28536
G1 X170.21 Y155.21 E.28536
G1 X179.79 Y155.21 E.28536
G1 X179.79 Y164.73 E.28357
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
G1 X177.79 Y164.743 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X177.713 Y163.417 Z9.6 F60000
G1 Z9.2
G1 E.8 F1800
; FEATURE: Bridge
; LINE_WIDTH: 0.42036
; LAYER_HEIGHT: 0.4
G1 F3000
M204 S8000
G1 X178.214 Y161.611 E.10273
G1 X178.214 Y159.851 E.09645
G1 X177.281 Y163.214 E.1913
G1 X176.793 Y163.214 E.02676
G1 X178.214 Y158.092 E.29139
G1 X178.214 Y156.786 E.07157
G1 X178.088 Y156.786 E.0069
G1 X176.305 Y163.214 E.36566
G1 X175.817 Y163.214 E.02676
G1 X177.6 Y156.786 E.36566
G1 X177.112 Y156.786 E.02676
M73 P92 R1
G1 X175.329 Y163.214 E.36566
G1 X174.841 Y163.214 E.02676
G1 X176.624 Y156.786 E.36566
G1 X176.136 Y156.786 E.02676
G1 X174.352 Y163.214 E.36566
G1 X173.864 Y163.214 E.02676
G1 X175.648 Y156.786 E.36566
G1 X175.159 Y156.786 E.02676
G1 X173.376 Y163.214 E.36566
G1 X172.888 Y163.214 E.02676
G1 X174.671 Y156.786 E.36566
G1 X174.183 Y156.786 E.02676
G1 X172.4 Y163.214 E.36566
G1 X171.912 Y163.214 E.02676
G1 X173.695 Y156.786 E.36566
G1 X173.207 Y156.786 E.02676
G1 X171.786 Y161.908 E.29137
G1 X171.786 Y160.149 E.09645
G1 X172.719 Y156.786 E.19128
G1 X172.231 Y156.786 E.02676
G1 X171.583 Y159.119 E.13272
; CHANGE_LAYER
; Z_HEIGHT: 9.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F3000
G1 X172.118 Y157.192 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 47/50
; update layer progress
M73 L47
M991 S0 P46 ;notify layer change

M106 S226.95
; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z9.6 I-.856 J.865 P1  F60000
G1 X178.584 Y163.584 Z9.6
G1 Z9.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1302
M204 S8000
G1 X171.416 Y163.584 E.23048
G1 X171.416 Y156.416 E.23048
G1 X178.584 Y156.416 E.23048
G1 X178.584 Y163.524 E.22855
; COOLING_NODE: 0
M204 S10000
G1 X178.991 Y163.991 F60000
G1 F1302
M204 S8000
G1 X171.009 Y163.991 E.25666
G1 X171.009 Y156.009 E.25666
G1 X178.991 Y156.009 E.25666
G1 X178.991 Y163.931 E.25473
; COOLING_NODE: 0
M204 S10000
G1 X179.398 Y164.398 F60000
G1 F1302
M204 S8000
G1 X170.602 Y164.398 E.28284
G1 X170.602 Y155.602 E.28284
G1 X179.398 Y155.602 E.28284
G1 X179.398 Y164.338 E.28091
; COOLING_NODE: 0
M204 S250
G1 X179.79 Y164.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1302
M204 S5000
M73 P92 R0
G1 X170.21 Y164.79 E.28536
G1 X170.21 Y155.21 E.28536
G1 X179.79 Y155.21 E.28536
G1 X179.79 Y164.73 E.28357
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
G1 X177.79 Y164.743 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
M73 P93 R0
G1 X178.42 Y157.368 Z9.8 F60000
G1 Z9.4
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.432
G1 F1302
M204 S8000
G1 X177.802 Y156.749 E.02686
G1 X177.252 Y156.749 E.01691
G1 X178.251 Y157.748 E.0434
G1 X178.251 Y158.298 E.01691
G1 X176.702 Y156.749 E.06732
G1 X176.151 Y156.749 E.01691
G1 X178.251 Y158.849 E.09124
G1 X178.251 Y159.399 E.01691
G1 X175.601 Y156.749 E.11515
G1 X175.051 Y156.749 E.01691
G1 X178.251 Y159.949 E.13907
G1 X178.251 Y160.499 E.01691
G1 X174.501 Y156.749 E.16299
G1 X173.95 Y156.749 E.01691
G1 X178.251 Y161.05 E.1869
G1 X178.251 Y161.6 E.01691
G1 X173.4 Y156.749 E.21082
G1 X172.85 Y156.749 E.01691
G1 X178.251 Y162.15 E.23474
G1 X178.251 Y162.7 E.01691
G1 X172.3 Y156.749 E.25865
G1 X171.75 Y156.749 E.01691
G1 X178.251 Y163.251 E.28257
G1 X177.7 Y163.251 E.01691
G1 X171.749 Y157.3 E.25866
G1 X171.749 Y157.85 E.01691
G1 X177.15 Y163.251 E.23474
G1 X176.6 Y163.251 E.01691
G1 X171.749 Y158.4 E.21082
G1 X171.749 Y158.95 E.01691
G1 X176.05 Y163.251 E.18691
G1 X175.499 Y163.251 E.01691
G1 X171.749 Y159.501 E.16299
G1 X171.749 Y160.051 E.01691
G1 X174.949 Y163.251 E.13907
G1 X174.399 Y163.251 E.01691
G1 X171.749 Y160.601 E.11516
G1 X171.749 Y161.151 E.01691
G1 X173.849 Y163.251 E.09124
G1 X173.298 Y163.251 E.01691
G1 X171.749 Y161.702 E.06733
G1 X171.749 Y162.252 E.01691
G1 X172.748 Y163.251 E.04341
G1 X172.198 Y163.251 E.01691
G1 X171.58 Y162.632 E.02687
; CHANGE_LAYER
; Z_HEIGHT: 9.6
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F9252.596
G1 X172.198 Y163.251 E-.33219
G1 X172.748 Y163.251 E-.20909
G1 X172.341 Y162.844 E-.21872
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 48/50
; update layer progress
M73 L48
M991 S0 P47 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z9.8 I-.143 J1.208 P1  F60000
G1 X178.584 Y163.584 Z9.8
G1 Z9.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1298
M204 S8000
G1 X171.416 Y163.584 E.23048
G1 X171.416 Y156.416 E.23048
G1 X178.584 Y156.416 E.23048
G1 X178.584 Y163.524 E.22855
; COOLING_NODE: 0
M204 S10000
G1 X178.991 Y163.991 F60000
G1 F1298
M204 S8000
G1 X171.009 Y163.991 E.25666
G1 X171.009 Y156.009 E.25666
G1 X178.991 Y156.009 E.25666
G1 X178.991 Y163.931 E.25473
; COOLING_NODE: 0
M204 S10000
G1 X179.398 Y164.398 F60000
M73 P94 R0
G1 F1298
M204 S8000
G1 X170.602 Y164.398 E.28284
G1 X170.602 Y155.602 E.28284
G1 X179.398 Y155.602 E.28284
G1 X179.398 Y164.338 E.28091
; COOLING_NODE: 0
M204 S250
G1 X179.79 Y164.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1298
M204 S5000
G1 X170.21 Y164.79 E.28536
G1 X170.21 Y155.21 E.28536
G1 X179.79 Y155.21 E.28536
G1 X179.79 Y164.73 E.28357
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
G1 X177.79 Y164.743 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X177.632 Y163.42 Z10 F60000
G1 Z9.6
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.432
G1 F1298
M204 S8000
G1 X178.251 Y162.802 E.02686
G1 X178.251 Y162.252 E.01691
G1 X177.252 Y163.251 E.04341
G1 X176.702 Y163.251 E.01691
G1 X178.251 Y161.702 E.06732
G1 X178.251 Y161.151 E.01691
G1 X176.151 Y163.251 E.09124
G1 X175.601 Y163.251 E.01691
G1 X178.251 Y160.601 E.11515
G1 X178.251 Y160.051 E.01691
G1 X175.051 Y163.251 E.13907
G1 X174.501 Y163.251 E.01691
G1 X178.251 Y159.501 E.16299
G1 X178.251 Y158.95 E.01691
G1 X173.95 Y163.251 E.1869
G1 X173.4 Y163.251 E.01691
G1 X178.251 Y158.4 E.21082
G1 X178.251 Y157.85 E.01691
G1 X172.85 Y163.251 E.23474
G1 X172.3 Y163.251 E.01691
G1 X178.251 Y157.3 E.25865
G1 X178.251 Y156.75 E.01691
G1 X171.749 Y163.251 E.28257
G1 X171.749 Y162.7 E.01691
G1 X177.7 Y156.749 E.25866
G1 X177.15 Y156.749 E.01691
G1 X171.749 Y162.15 E.23474
G1 X171.749 Y161.6 E.01691
G1 X176.6 Y156.749 E.21082
G1 X176.05 Y156.749 E.01691
M73 P95 R0
G1 X171.749 Y161.05 E.18691
G1 X171.749 Y160.499 E.01691
G1 X175.499 Y156.749 E.16299
G1 X174.949 Y156.749 E.01691
G1 X171.749 Y159.949 E.13907
G1 X171.749 Y159.399 E.01691
G1 X174.399 Y156.749 E.11516
G1 X173.849 Y156.749 E.01691
G1 X171.749 Y158.849 E.09124
G1 X171.749 Y158.298 E.01691
G1 X173.298 Y156.749 E.06732
G1 X172.748 Y156.749 E.01691
G1 X171.749 Y157.748 E.04341
G1 X171.749 Y157.198 E.01691
G1 X172.368 Y156.58 E.02687
; CHANGE_LAYER
; Z_HEIGHT: 9.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9252.596
G1 X171.749 Y157.198 E-.33219
G1 X171.749 Y157.748 E-.20909
G1 X172.156 Y157.341 E-.21872
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 49/50
; update layer progress
M73 L49
M991 S0 P48 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z10 I-.848 J.873 P1  F60000
G1 X178.584 Y163.584 Z10
G1 Z9.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1298
M204 S8000
G1 X171.416 Y163.584 E.23048
G1 X171.416 Y156.416 E.23048
G1 X178.584 Y156.416 E.23048
G1 X178.584 Y163.524 E.22855
; COOLING_NODE: 0
M204 S10000
G1 X178.991 Y163.991 F60000
G1 F1298
M204 S8000
G1 X171.009 Y163.991 E.25666
M73 P96 R0
G1 X171.009 Y156.009 E.25666
G1 X178.991 Y156.009 E.25666
G1 X178.991 Y163.931 E.25473
; COOLING_NODE: 0
M204 S10000
G1 X179.398 Y164.398 F60000
G1 F1298
M204 S8000
G1 X170.602 Y164.398 E.28284
G1 X170.602 Y155.602 E.28284
G1 X179.398 Y155.602 E.28284
G1 X179.398 Y164.338 E.28091
; COOLING_NODE: 0
M204 S250
G1 X179.79 Y164.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1298
M204 S5000
G1 X170.21 Y164.79 E.28536
G1 X170.21 Y155.21 E.28536
G1 X179.79 Y155.21 E.28536
G1 X179.79 Y164.73 E.28357
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
G1 X177.79 Y164.743 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X178.42 Y157.368 Z10.2 F60000
G1 Z9.8
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.432
G1 F1298
M204 S8000
G1 X177.802 Y156.749 E.02686
G1 X177.252 Y156.749 E.01691
G1 X178.251 Y157.748 E.0434
G1 X178.251 Y158.298 E.01691
G1 X176.702 Y156.749 E.06732
G1 X176.151 Y156.749 E.01691
G1 X178.251 Y158.849 E.09124
G1 X178.251 Y159.399 E.01691
G1 X175.601 Y156.749 E.11515
G1 X175.051 Y156.749 E.01691
G1 X178.251 Y159.949 E.13907
G1 X178.251 Y160.499 E.01691
G1 X174.501 Y156.749 E.16299
G1 X173.95 Y156.749 E.01691
G1 X178.251 Y161.05 E.1869
G1 X178.251 Y161.6 E.01691
G1 X173.4 Y156.749 E.21082
G1 X172.85 Y156.749 E.01691
G1 X178.251 Y162.15 E.23474
G1 X178.251 Y162.7 E.01691
G1 X172.3 Y156.749 E.25865
G1 X171.75 Y156.749 E.01691
G1 X178.251 Y163.251 E.28257
G1 X177.7 Y163.251 E.01691
G1 X171.749 Y157.3 E.25866
G1 X171.749 Y157.85 E.01691
M73 P97 R0
G1 X177.15 Y163.251 E.23474
G1 X176.6 Y163.251 E.01691
G1 X171.749 Y158.4 E.21082
G1 X171.749 Y158.95 E.01691
G1 X176.05 Y163.251 E.18691
G1 X175.499 Y163.251 E.01691
G1 X171.749 Y159.501 E.16299
G1 X171.749 Y160.051 E.01691
G1 X174.949 Y163.251 E.13907
G1 X174.399 Y163.251 E.01691
G1 X171.749 Y160.601 E.11516
G1 X171.749 Y161.151 E.01691
G1 X173.849 Y163.251 E.09124
G1 X173.298 Y163.251 E.01691
G1 X171.749 Y161.702 E.06733
G1 X171.749 Y162.252 E.01691
G1 X172.748 Y163.251 E.04341
G1 X172.198 Y163.251 E.01691
G1 X171.58 Y162.632 E.02687
; CHANGE_LAYER
; Z_HEIGHT: 10
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9252.596
G1 X172.198 Y163.251 E-.33219
G1 X172.748 Y163.251 E-.20909
G1 X172.341 Y162.844 E-.21872
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 50/50
; update layer progress
M73 L50
M991 S0 P49 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z10.2 I-.308 J1.177 P1  F60000
G1 X179.79 Y164.79 Z10.2
G1 Z10
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1532
M204 S5000
G1 X170.21 Y164.79 E.28536
G1 X170.21 Y155.21 E.28536
G1 X179.79 Y155.21 E.28536
G1 X179.79 Y164.73 E.28357
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
G1 X179.583 Y164.216 F60000
; FEATURE: Top surface
G1 F1532
M204 S2000
G1 X179.216 Y164.583 E.01544
G1 X179.082 Y164.716
G1 X178.549 Y164.716
G1 X178.683 Y164.583
G1 X179.583 Y163.683 E.03791
G1 X179.716 Y163.549
G1 X179.716 Y163.016
G1 X179.583 Y163.15
G1 X178.15 Y164.583 E.06037
G1 X178.016 Y164.716
G1 X177.483 Y164.716
G1 X177.616 Y164.583
G1 X179.583 Y162.616 E.08283
G1 X179.716 Y162.483
G1 X179.716 Y161.949
G1 X179.583 Y162.083
G1 X177.083 Y164.583 E.1053
G1 X176.949 Y164.716
G1 X176.416 Y164.716
G1 X176.55 Y164.583
G1 X179.583 Y161.55 E.12776
G1 X179.716 Y161.416
G1 X179.716 Y160.883
G1 X179.583 Y161.016
G1 X176.017 Y164.583 E.15022
G1 X175.883 Y164.716
G1 X175.35 Y164.716
G1 X175.483 Y164.583
G1 X179.583 Y160.483 E.17269
G1 X179.716 Y160.35
G1 X179.716 Y159.816
G1 X179.583 Y159.95
G1 X174.95 Y164.583 E.19515
G1 X174.816 Y164.716
G1 X174.283 Y164.716
G1 X174.417 Y164.583
G1 X179.583 Y159.417 E.21761
G1 X179.716 Y159.283
G1 X179.716 Y158.75
G1 X179.583 Y158.883
G1 X173.883 Y164.583 E.24008
G1 X173.75 Y164.716
G1 X173.217 Y164.716
G1 X173.35 Y164.583
G1 X179.583 Y158.35 E.26254
G1 X179.716 Y158.217
G1 X179.716 Y157.683
G1 X179.583 Y157.817
G1 X172.817 Y164.583 E.285
G1 X172.683 Y164.716
G1 X172.15 Y164.716
G1 X172.284 Y164.583
G1 X179.583 Y157.284 E.30747
G1 X179.716 Y157.15
G1 X179.716 Y156.617
G1 X179.583 Y156.75
M73 P98 R0
G1 X171.75 Y164.583 E.32993
G1 X171.617 Y164.716
G1 X171.084 Y164.716
G1 X171.217 Y164.583
G1 X179.583 Y156.217 E.35239
G1 X179.716 Y156.084
G1 X179.716 Y155.55
G1 X179.583 Y155.684
G1 X170.684 Y164.583 E.37485
G1 X170.55 Y164.716
G1 X170.284 Y164.45
G1 X170.417 Y164.316
G1 X179.316 Y155.417 E.37485
G1 X179.45 Y155.284
G1 X178.916 Y155.284
G1 X178.783 Y155.417
G1 X170.417 Y163.783 E.35238
G1 X170.284 Y163.916
G1 X170.284 Y163.383
G1 X170.417 Y163.249
G1 X178.249 Y155.417 E.32992
G1 X178.383 Y155.284
G1 X177.85 Y155.284
G1 X177.716 Y155.417
G1 X170.417 Y162.716 E.30746
G1 X170.284 Y162.85
G1 X170.284 Y162.317
G1 X170.417 Y162.183
G1 X177.183 Y155.417 E.28499
G1 X177.317 Y155.284
G1 X176.783 Y155.284
G1 X176.65 Y155.417
G1 X170.417 Y161.65 E.26253
G1 X170.284 Y161.783
G1 X170.284 Y161.25
G1 X170.417 Y161.116
G1 X176.116 Y155.417 E.24007
G1 X176.25 Y155.284
G1 X175.717 Y155.284
G1 X175.583 Y155.417
G1 X170.417 Y160.583 E.2176
G1 X170.284 Y160.717
G1 X170.284 Y160.183
G1 X170.417 Y160.05
G1 X175.05 Y155.417 E.19514
G1 X175.184 Y155.284
G1 X174.65 Y155.284
G1 X174.517 Y155.417
G1 X170.417 Y159.517 E.17268
G1 X170.284 Y159.65
G1 X170.284 Y159.117
G1 X170.417 Y158.983
G1 X173.983 Y155.417 E.15022
G1 X174.117 Y155.284
G1 X173.584 Y155.284
G1 X173.45 Y155.417
G1 X170.417 Y158.45 E.12775
G1 X170.284 Y158.584
G1 X170.284 Y158.05
G1 X170.417 Y157.917
G1 X172.917 Y155.417 E.10529
G1 X173.05 Y155.284
G1 X172.517 Y155.284
G1 X172.384 Y155.417
G1 X170.417 Y157.384 E.08283
G1 X170.284 Y157.517
G1 X170.284 Y156.984
G1 X170.417 Y156.85
G1 X171.85 Y155.417 E.06036
G1 X171.984 Y155.284
G1 X171.451 Y155.284
G1 X171.317 Y155.417
G1 X170.417 Y156.317 E.0379
G1 X170.284 Y156.451
G1 X170.284 Y155.917
G1 X170.417 Y155.784
G1 X170.784 Y155.417 E.01544
; close powerlost recovery
M1003 S0
; WIPE_START
G1 F9547.055
M204 S8000
G1 X170.417 Y155.784 E-.19692
G1 X170.284 Y155.917 E-.07182
G1 X170.284 Y156.451 E-.20264
G1 X170.417 Y156.317 E-.07182
G1 X170.821 Y155.914 E-.21681
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z10.4 I1.217 J0 P1  F60000
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
G1 Z10.4 F900 ; lower z a little
M1002 judge_flag timelapse_record_flag
M622 J1
    G150.3
    M400 ; wait all motion done
    M991 S0 P-1 ;end smooth timelapse at safe pos
    M400 S5 ;wait for last picture to be taken
M623  ;end of "timelapse_record_flag"

G90
G1 Z20 F900 ; lower z a little

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

    
        G1 Z105 F600
        G1 Z103
    

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

