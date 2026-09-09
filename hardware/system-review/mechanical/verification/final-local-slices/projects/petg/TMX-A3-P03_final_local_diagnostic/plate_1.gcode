; HEADER_BLOCK_START
; BambuStudio 02.08.02.61
; model printing time: 15m 47s; total estimated time: 21m 14s
; total layer number: 37
; total filament length [mm] : 1707.67
; total filament volume [cm^3] : 4107.43
; total filament weight [g] : 5.22
; filament_density: 1.27
; filament_diameter: 1.75
; max_z_height: 5.40
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
; enable_support = 1
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
M73 P0 R21
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
M73 P2 R20
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
M73 P3 R20
G1 Z5 F1200
G90
G1 X175 Y160 F30000

M622 J1
    M1002 gcode_claim_action : 1
    G29.20 A3
    G29 A1 O X155.693 Y106.193 I38.6131 J107.613 R
    M400
M623

M622 J2
    M1002 gcode_claim_action : 1
    
        G29.20 A4
        G29 A2 O X155.693 Y106.193 I38.6131 J107.613 R
    
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
M73 P24 R16
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
; layer num/total_layer_count: 1/37
; update layer progress
M73 L1
M991 S0 P0 ;notify layer change

M106 S0
M106 P2 S0
; OBJECT_ID: 15
M73 P24 R15
G1 X159.05 Y122.876 F60000
M204 S6000
M73 P25 R15
G1 Z.4
G1 Z.2
G1 E.8 F1800
; FEATURE: Support
; LINE_WIDTH: 0.5
G1 F3000
M204 S500
G1 X159.314 Y123.14 E.01346
G1 X168.886 Y123.14 E.34563
G1 X169.15 Y122.876 E.01346
G1 X169.15 Y121.29 E.05727
G1 X170.45 Y121.29 E.04694
G1 X170.45 Y127.05 E.20797
G1 X168.374 Y127.05 E.07497
G1 X168.11 Y127.314 E.01346
G1 X168.11 Y131.06 E.13527
G1 X159.314 Y131.06 E.3176
G1 X159.05 Y131.324 E.01346
G1 X159.05 Y132.91 E.05727
G1 X157.75 Y132.91 E.04694
G1 X157.75 Y121.29 E.41954
G1 X159.05 Y121.29 E.04694
G1 X159.05 Y122.808 E.0548
M204 S6000
G1 X169.921 Y126.844 F60000
G1 F3000
M204 S500
G1 X169.921 Y121.701 E.18569
G1 X169.561 Y121.701 E.013
G1 X169.561 Y123.047 E.04857
G1 X169.414 Y123.195 E.00755
G1 X169.414 Y126.639 E.12435
G1 X168.906 Y126.639 E.01834
G1 X168.906 Y123.551 E.11147
G1 X168.398 Y123.551 E.01834
G1 X168.398 Y126.639 E.11147
G1 X168.203 Y126.639 E.00703
G1 X167.89 Y126.952 E.016
G1 X167.89 Y123.551 E.12278
G1 X167.382 Y123.551 E.01834
G1 X167.382 Y130.649 E.25625
G1 X166.874 Y130.649 E.01834
G1 X166.874 Y123.551 E.25625
G1 X166.366 Y123.551 E.01834
G1 X166.366 Y130.649 E.25625
G1 X165.859 Y130.649 E.01834
G1 X165.859 Y123.551 E.25625
G1 X165.351 Y123.551 E.01834
G1 X165.351 Y130.649 E.25625
G1 X164.843 Y130.649 E.01834
G1 X164.843 Y123.551 E.25625
G1 X164.335 Y123.551 E.01834
G1 X164.335 Y130.649 E.25625
G1 X163.827 Y130.649 E.01834
G1 X163.827 Y123.551 E.25625
M73 P26 R15
G1 X163.319 Y123.551 E.01834
G1 X163.319 Y130.649 E.25625
G1 X162.811 Y130.649 E.01834
G1 X162.811 Y123.551 E.25625
G1 X162.303 Y123.551 E.01834
G1 X162.303 Y130.649 E.25625
G1 X161.796 Y130.649 E.01834
G1 X161.796 Y123.551 E.25625
G1 X161.288 Y123.551 E.01834
G1 X161.288 Y130.649 E.25625
G1 X160.78 Y130.649 E.01834
G1 X160.78 Y123.551 E.25625
G1 X160.272 Y123.551 E.01834
G1 X160.272 Y130.649 E.25625
G1 X159.764 Y130.649 E.01834
G1 X159.764 Y123.551 E.25625
G1 X159.256 Y123.551 E.01834
G1 X159.256 Y130.649 E.25625
G1 X159.143 Y130.649 E.00408
G1 X158.748 Y131.043 E.02016
G1 X158.748 Y123.157 E.28476
G1 X158.639 Y123.047 E.00561
G1 X158.639 Y121.701 E.04857
G1 X158.241 Y121.701 E.01437
G1 X158.241 Y132.704 E.39727
M204 S6000
G1 X158.241 Y133.388 F60000
; FEATURE: Brim
G1 F3000
M204 S500
G1 X159.121 Y133.388 E.0318
G1 X159.121 Y194.2 E2.19566
G1 X159.177 Y194.386 E.007
G1 X159.299 Y194.512 E.00631
G1 X159.5 Y194.579 E.00766
G1 X179.846 Y194.579 E.73463
G1 X179.846 Y210 E.55681
G1 X179.902 Y210.186 E.007
G1 X180.024 Y210.312 E.00631
G1 X180.225 Y210.379 E.00766
G1 X189.9 Y210.379 E.34933
G1 X190.086 Y210.323 E.007
G1 X190.212 Y210.201 E.00631
G1 X190.279 Y210 E.00766
G1 X190.279 Y183.479 E.95758
G1 X190.5 Y183.479 E.008
G1 X190.686 Y183.423 E.007
G1 X190.812 Y183.301 E.00631
G1 X190.879 Y183.1 E.00766
G1 X190.879 Y145.9 E1.34314
G1 X190.823 Y145.714 E.007
G1 X190.701 Y145.588 E.00631
G1 X190.5 Y145.521 E.00766
G1 X190.279 Y145.521 E.008
G1 X190.279 Y127.5 E.65068
G1 X190.263 Y127.416 E.00307
G1 X190.223 Y127.314 E.00396
G1 X190.101 Y127.188 E.00631
G1 X189.9 Y127.121 E.00766
G1 X170.929 Y127.121 E.68498
G1 X170.929 Y121.04 E.21957
G1 X170.88 Y120.899 E.00538
G1 X170.7 Y120.812 E.00722
G1 X169.143 Y120.812 E.05621
G1 X169.023 Y120.504 E.01192
G1 X168.901 Y120.378 E.00631
G1 X168.679 Y120.281 E.00877
G1 X168.679 Y110 E.37122
G1 X168.623 Y109.814 E.007
G1 X168.501 Y109.688 E.00631
G1 X168.3 Y109.621 E.00766
G1 X159.5 Y109.621 E.31773
G1 X159.314 Y109.677 E.007
G1 X159.188 Y109.799 E.00631
G1 X159.121 Y110 E.00766
G1 X159.121 Y120.812 E.39036
G1 X157.5 Y120.812 E.05854
G1 X157.359 Y120.86 E.00538
G1 X157.271 Y121.04 E.00722
G1 X157.271 Y125.471 E.15999
G1 X157.074 Y125.318 E.00902
G1 X156.69 Y124.902 E.02045
G1 X156.378 Y124.427 E.02053
G1 X156.2 Y124.046 E.01517
G1 X155.998 Y123.402 E.02439
G1 X155.922 Y122.678 E.02627
G1 X155.922 Y110.009 E.45742
G1 X155.969 Y109.44 E.02062
G1 X156.211 Y108.625 E.03072
G1 X156.526 Y108.02 E.0246
G1 X156.872 Y107.574 E.02039
G1 X157.288 Y107.19 E.02045
G1 X157.763 Y106.878 E.02053
G1 X158.144 Y106.7 E.01517
G1 X158.788 Y106.498 E.02439
G1 X159.512 Y106.422 E.02627
G1 X168.291 Y106.422 E.31697
G1 X168.86 Y106.469 E.02062
G1 X169.771 Y106.752 E.03446
G1 X170.278 Y107.025 E.02079
G1 X170.726 Y107.372 E.02045
G1 X171.11 Y107.788 E.02045
G1 X171.422 Y108.262 E.02048
G1 X171.639 Y108.743 E.01907
G1 X171.802 Y109.287 E.0205
G1 X171.878 Y110.012 E.02632
G1 X171.878 Y119.022 E.32531
G1 X171.898 Y119.115 E.00342
G1 X172.039 Y119.433 E.01256
G1 X172.202 Y119.977 E.02052
G1 X172.278 Y120.702 E.02632
G1 X172.278 Y122.681 E.07144
G1 X172.231 Y123.25 E.02062
G1 X172.119 Y123.628 E.01426
G1 X172.125 Y123.777 E.00538
G1 X172.222 Y123.891 E.00538
G1 X172.338 Y123.922 E.00432
G1 X189.891 Y123.922 E.63377
G1 X190.46 Y123.969 E.02062
G1 X191.371 Y124.252 E.03446
G1 X191.878 Y124.525 E.02079
G1 X192.326 Y124.872 E.02045
G1 X192.71 Y125.288 E.02045
G1 X193.022 Y125.762 E.02048
G1 X193.239 Y126.243 E.01907
G1 X193.402 Y126.787 E.0205
G1 X193.478 Y127.512 E.02632
G1 X193.478 Y143.875 E.5908
G1 X193.515 Y144 E.00472
G1 X193.622 Y144.163 E.00703
G1 X193.8 Y144.544 E.01517
G1 X194.002 Y145.188 E.02439
G1 X194.078 Y145.912 E.02627
G1 X194.078 Y183.091 E1.34237
G1 X194.031 Y183.66 E.02062
G1 X193.789 Y184.476 E.03073
G1 X193.504 Y185.026 E.02237
G1 X193.478 Y185.131 E.00391
G1 X193.478 Y209.991 E.89759
G1 X193.431 Y210.56 E.02062
G1 X193.189 Y211.375 E.03072
G1 X192.874 Y211.98 E.0246
G1 X192.528 Y212.426 E.02039
G1 X192.112 Y212.81 E.02045
G1 X191.638 Y213.122 E.02048
G1 X191.157 Y213.339 E.01907
M73 P27 R15
G1 X190.613 Y213.502 E.0205
G1 X189.888 Y213.578 E.02632
G1 X180.234 Y213.578 E.34855
G1 X179.665 Y213.531 E.02062
G1 X178.85 Y213.289 E.03072
G1 X178.245 Y212.974 E.0246
G1 X177.799 Y212.628 E.02039
G1 X177.415 Y212.212 E.02045
G1 X177.103 Y211.738 E.02048
G1 X176.886 Y211.257 E.01907
G1 X176.723 Y210.713 E.0205
G1 X176.647 Y209.988 E.02632
G1 X176.647 Y198.007 E.43261
G1 X176.598 Y197.866 E.00538
G1 X176.418 Y197.778 E.00722
G1 X159.509 Y197.778 E.61052
G1 X158.94 Y197.731 E.02062
G1 X158.029 Y197.448 E.03446
G1 X157.522 Y197.175 E.02079
G1 X157.074 Y196.828 E.02045
G1 X156.69 Y196.412 E.02045
G1 X156.378 Y195.938 E.02048
G1 X156.161 Y195.457 E.01907
G1 X155.998 Y194.913 E.0205
G1 X155.922 Y194.188 E.02632
G1 X155.922 Y131.519 E2.26272
G1 X155.969 Y130.95 E.02062
G1 X156.211 Y130.135 E.03072
G1 X156.526 Y129.53 E.0246
G1 X156.872 Y129.084 E.02039
G1 X157.271 Y128.715 E.01966
G1 X157.271 Y133.16 E.1605
G1 X157.32 Y133.301 E.00538
G1 X157.5 Y133.388 E.00722
G1 X158.181 Y133.388 E.02457
M204 S6000
G1 X158.181 Y133.846 F60000
G1 F3000
M204 S500
G1 X158.527 Y133.846 E.01252
G1 X158.631 Y133.893 E.00413
G1 X158.664 Y133.983 E.00344
G1 X158.664 Y194.19 E2.17385
G1 X158.735 Y194.502 E.01155
G1 X158.86 Y194.715 E.0089
G1 X158.958 Y194.817 E.00513
G1 X159.17 Y194.95 E.00905
G1 X159.345 Y195.009 E.00666
G1 X159.511 Y195.036 E.00607
G1 X179.252 Y195.036 E.71278
G1 X179.356 Y195.083 E.00413
G1 X179.389 Y195.173 E.00344
G1 X179.389 Y209.99 E.53499
G1 X179.46 Y210.302 E.01155
G1 X179.585 Y210.515 E.0089
G1 X179.683 Y210.617 E.00513
G1 X179.895 Y210.75 E.00905
G1 X180.07 Y210.809 E.00666
G1 X180.236 Y210.836 E.00607
G1 X189.89 Y210.836 E.34856
G1 X190.202 Y210.765 E.01155
G1 X190.415 Y210.64 E.0089
G1 X190.517 Y210.542 E.00513
G1 X190.65 Y210.33 E.00905
G1 X190.709 Y210.155 E.00666
G1 X190.736 Y209.989 E.00607
G1 X190.736 Y183.982 E.93899
G1 X190.803 Y183.864 E.00492
G1 X191.015 Y183.74 E.00883
G1 X191.117 Y183.642 E.00513
G1 X191.25 Y183.43 E.00905
G1 X191.309 Y183.255 E.00666
G1 X191.336 Y183.089 E.00607
G1 X191.336 Y145.91 E1.34238
G1 X191.265 Y145.598 E.01155
G1 X191.14 Y145.385 E.0089
G1 X191.043 Y145.284 E.00509
G1 X190.801 Y145.136 E.01021
G1 X190.736 Y145.019 E.00484
G1 X190.736 Y127.509 E.63222
G1 X190.712 Y127.337 E.00626
G1 X190.651 Y127.157 E.00687
G1 X190.542 Y126.987 E.00728
G1 X190.442 Y126.883 E.00523
G1 X190.23 Y126.75 E.00905
G1 X190.055 Y126.691 E.00666
G1 X189.889 Y126.664 E.00607
G1 X171.523 Y126.664 E.66313
G1 X171.419 Y126.617 E.00413
G1 X171.386 Y126.527 E.00344
G1 X171.386 Y121.052 E.19771
G1 X171.357 Y120.88 E.00627
G1 X171.317 Y120.763 E.00446
G1 X171.214 Y120.591 E.00726
G1 X171.068 Y120.483 E.00654
G1 X170.914 Y120.407 E.0062
G1 X170.684 Y120.355 E.00851
G1 X169.531 Y120.355 E.04165
G1 X169.415 Y120.291 E.00475
G1 X169.344 Y120.181 E.00475
G1 X169.179 Y120.027 E.00813
G1 X169.136 Y119.927 E.00396
G1 X169.136 Y110.01 E.35806
G1 X169.065 Y109.698 E.01155
G1 X168.94 Y109.485 E.0089
G1 X168.842 Y109.383 E.00513
G1 X168.63 Y109.25 E.00905
G1 X168.455 Y109.191 E.00666
G1 X168.289 Y109.164 E.00607
G1 X159.51 Y109.164 E.31697
G1 X159.198 Y109.235 E.01155
G1 X158.985 Y109.36 E.0089
G1 X158.883 Y109.458 E.00513
G1 X158.749 Y109.67 E.00905
G1 X158.691 Y109.845 E.00666
G1 X158.664 Y110.011 E.00607
G1 X158.664 Y120.217 E.36851
G1 X158.617 Y120.321 E.00413
G1 X158.527 Y120.355 E.00344
G1 X157.511 Y120.355 E.03668
G1 X157.34 Y120.383 E.00627
G1 X157.223 Y120.423 E.00446
G1 X157.051 Y120.527 E.00726
G1 X156.942 Y120.672 E.00654
G1 X156.867 Y120.826 E.00619
G1 X156.814 Y121.056 E.00851
G1 X156.814 Y123.582 E.09122
G1 X156.767 Y123.686 E.00413
G1 X156.657 Y123.718 E.00413
G1 X156.546 Y123.623 E.00524
G1 X156.446 Y123.295 E.0124
G1 X156.379 Y122.647 E.02351
G1 X156.379 Y110.034 E.45541
G1 X156.425 Y109.511 E.01894
G1 X156.633 Y108.809 E.02644
G1 X156.92 Y108.258 E.02243
G1 X157.218 Y107.876 E.0175
G1 X157.579 Y107.545 E.0177
G1 X157.978 Y107.283 E.0172
G1 X158.301 Y107.131 E.01291
G1 X158.895 Y106.946 E.02246
G1 X159.543 Y106.879 E.02351
G1 X168.277 Y106.88 E.31537
G1 X168.786 Y106.925 E.01845
G1 X169.581 Y107.171 E.03004
G1 X170.018 Y107.404 E.01788
G1 X170.407 Y107.703 E.01771
G1 X170.741 Y108.062 E.0177
G1 X171.014 Y108.474 E.01784
G1 X171.206 Y108.895 E.01673
G1 X171.348 Y109.365 E.01771
G1 X171.421 Y110.043 E.02462
G1 X171.421 Y119.012 E.32382
G1 X171.449 Y119.201 E.00691
G1 X171.612 Y119.6 E.01554
G1 X171.748 Y120.055 E.01716
G1 X171.82 Y120.719 E.02411
G1 X171.82 Y122.667 E.07035
G1 X171.78 Y123.151 E.01752
G1 X171.684 Y123.488 E.01265
G1 X171.662 Y123.66 E.00627
G1 X171.668 Y123.783 E.00446
G1 X171.717 Y123.978 E.00725
G1 X171.865 Y124.175 E.00889
G1 X172.118 Y124.334 E.01078
G1 X172.351 Y124.379 E.00856
G1 X189.866 Y124.379 E.63241
G1 X190.357 Y124.419 E.01779
G1 X191.205 Y124.682 E.03206
G1 X191.637 Y124.916 E.01774
G1 X192.024 Y125.218 E.01771
G1 X192.355 Y125.579 E.0177
G1 X192.614 Y125.974 E.01702
G1 X192.806 Y126.395 E.01673
G1 X192.948 Y126.865 E.01771
G1 X193.021 Y127.543 E.02462
G1 X193.021 Y143.861 E.58916
G1 X193.077 Y144.124 E.00974
G1 X193.367 Y144.697 E.02319
G1 X193.548 Y145.268 E.02164
G1 X193.621 Y145.943 E.0245
G1 X193.621 Y183.066 E1.34036
G1 X193.575 Y183.589 E.01894
G1 X193.367 Y184.291 E.02647
G1 X193.102 Y184.808 E.02096
G1 X193.059 Y184.921 E.00436
G1 X193.021 Y185.143 E.00812
G1 X193.021 Y209.966 E.89627
G1 X192.975 Y210.489 E.01894
G1 X192.767 Y211.191 E.02644
G1 X192.494 Y211.721 E.02155
G1 X192.197 Y212.107 E.01757
G1 X191.838 Y212.441 E.0177
G1 X191.426 Y212.714 E.01784
G1 X191.005 Y212.906 E.01673
G1 X190.535 Y213.048 E.01771
G1 X189.857 Y213.121 E.02462
G1 X180.259 Y213.121 E.34654
G1 X179.764 Y213.08 E.01793
G1 X179.034 Y212.867 E.02745
G1 X178.504 Y212.594 E.02155
G1 X178.118 Y212.297 E.01757
G1 X177.784 Y211.938 E.0177
G1 X177.511 Y211.526 E.01784
G1 X177.313 Y211.088 E.01739
G1 X177.172 Y210.61 E.01798
G1 X177.105 Y209.971 E.02318
G1 X177.104 Y198.018 E.43159
G1 X177.035 Y197.73 E.0107
G1 X176.932 Y197.557 E.00726
G1 X176.787 Y197.449 E.00654
G1 X176.633 Y197.374 E.0062
G1 X176.403 Y197.321 E.00851
G1 X159.534 Y197.321 E.60906
G1 X159.043 Y197.281 E.0178
G1 X158.195 Y197.018 E.03206
G1 X157.763 Y196.784 E.01774
M73 P28 R15
G1 X157.376 Y196.482 E.01771
G1 X157.045 Y196.121 E.0177
G1 X156.786 Y195.726 E.01702
G1 X156.594 Y195.305 E.01673
G1 X156.452 Y194.835 E.01771
G1 X156.379 Y194.157 E.02462
G1 X156.379 Y131.544 E2.26071
G1 X156.425 Y131.021 E.01894
G1 X156.546 Y130.613 E.01537
G1 X156.621 Y130.527 E.00413
G1 X156.736 Y130.528 E.00413
G1 X156.814 Y130.652 E.00531
G1 X156.814 Y133.149 E.09013
G1 X156.883 Y133.437 E.01069
G1 X156.986 Y133.609 E.00726
G1 X157.132 Y133.717 E.00654
G1 X157.286 Y133.793 E.0062
G1 X157.516 Y133.846 E.00851
G1 X158.121 Y133.846 E.02184
M204 S6000
G1 X158.073 Y134.303 F60000
G1 F3000
M204 S500
G1 X158.176 Y134.353 E.00413
G1 X158.207 Y134.44 E.00334
G1 X158.207 Y194.177 E2.15687
G1 X158.288 Y194.595 E.01536
G1 X158.345 Y194.739 E.00561
G1 X158.537 Y195.038 E.01283
G1 X158.723 Y195.208 E.00908
G1 X159.037 Y195.388 E.01307
G1 X159.279 Y195.461 E.00913
G1 X159.52 Y195.493 E.00878
G1 X178.795 Y195.493 E.69595
G1 X178.899 Y195.54 E.00413
G1 X178.932 Y195.63 E.00344
G1 X178.932 Y209.977 E.51801
G1 X179.013 Y210.395 E.01536
G1 X179.07 Y210.539 E.00561
G1 X179.262 Y210.838 E.01283
G1 X179.448 Y211.008 E.00908
G1 X179.762 Y211.188 E.01307
G1 X180.004 Y211.261 E.00913
G1 X180.245 Y211.293 E.00878
G1 X189.877 Y211.293 E.34776
G1 X190.295 Y211.212 E.01536
G1 X190.442 Y211.154 E.00572
G1 X190.635 Y211.041 E.00807
G1 X190.831 Y210.874 E.0093
G1 X190.906 Y210.781 E.00431
G1 X191.088 Y210.463 E.01322
G1 X191.161 Y210.221 E.00913
G1 X191.193 Y209.98 E.00878
G1 X191.193 Y184.242 E.9293
G1 X191.24 Y184.138 E.00412
G1 X191.426 Y183.977 E.00888
G1 X191.631 Y183.682 E.01299
G1 X191.739 Y183.406 E.01069
G1 X191.793 Y183.078 E.01201
G1 X191.793 Y145.923 E1.34151
G1 X191.712 Y145.505 E.01536
G1 X191.655 Y145.361 E.00561
G1 X191.463 Y145.063 E.01278
G1 X191.239 Y144.866 E.01078
G1 X191.193 Y144.763 E.00408
G1 X191.193 Y127.517 E.62268
G1 X191.166 Y127.285 E.00842
G1 X191.086 Y127.016 E.01016
G1 X191.031 Y126.903 E.00451
G1 X190.933 Y126.749 E.0066
G1 X190.778 Y126.574 E.00844
G1 X190.478 Y126.366 E.01318
G1 X190.368 Y126.314 E.00439
G1 X190.121 Y126.239 E.00932
G1 X189.88 Y126.207 E.00878
G1 X171.98 Y126.207 E.6463
G1 X171.876 Y126.16 E.00413
G1 X171.843 Y126.07 E.00344
G1 X171.843 Y124.908 E.04198
G1 X171.89 Y124.804 E.00413
G1 X172.042 Y124.785 E.00552
G1 X172.362 Y124.836 E.01168
G1 X189.842 Y124.836 E.63114
G1 X190.255 Y124.87 E.01497
G1 X191.039 Y125.111 E.02962
G1 X191.395 Y125.307 E.01465
G1 X191.72 Y125.563 E.01497
G1 X191.986 Y125.853 E.01418
G1 X192.207 Y126.186 E.01444
G1 X192.374 Y126.549 E.0144
G1 X192.495 Y126.944 E.01493
G1 X192.564 Y127.575 E.02291
G1 X192.564 Y143.849 E.58758
G1 X192.628 Y144.212 E.01333
G1 X192.673 Y144.339 E.00486
G1 X192.937 Y144.861 E.02113
G1 X193.095 Y145.35 E.01854
G1 X193.164 Y145.975 E.02271
G1 X193.164 Y183.04 E1.33827
G1 X193.12 Y183.516 E.01726
G1 X192.944 Y184.108 E.02231
G1 X192.636 Y184.75 E.02571
G1 X192.564 Y185.155 E.01484
G1 X192.564 Y209.94 E.8949
G1 X192.52 Y210.416 E.01726
G1 X192.345 Y211.007 E.02226
G1 X192.112 Y211.464 E.01853
G1 X191.865 Y211.789 E.01474
G1 X191.563 Y212.073 E.01496
G1 X191.213 Y212.307 E.01519
G1 X190.851 Y212.474 E.01438
G1 X190.456 Y212.595 E.01493
G1 X189.825 Y212.664 E.02291
G1 X180.272 Y212.663 E.34492
G1 X179.834 Y212.625 E.01587
G1 X179.193 Y212.435 E.02415
G1 X178.74 Y212.199 E.01845
G1 X178.419 Y211.95 E.01468
G1 X178.152 Y211.663 E.01414
G1 X177.919 Y211.314 E.01516
G1 X177.739 Y210.919 E.01565
G1 X177.621 Y210.508 E.01544
G1 X177.562 Y209.94 E.02062
G1 X177.561 Y198.032 E.42998
G1 X177.481 Y197.631 E.01474
G1 X177.422 Y197.487 E.00562
G1 X177.331 Y197.335 E.0064
G1 X177.196 Y197.184 E.00731
G1 X176.98 Y197.035 E.00946
G1 X176.726 Y196.927 E.00999
G1 X176.39 Y196.864 E.01234
G1 X159.558 Y196.864 E.60772
G1 X159.145 Y196.83 E.01498
G1 X158.361 Y196.589 E.02962
G1 X158.005 Y196.393 E.01465
G1 X157.68 Y196.137 E.01497
G1 X157.414 Y195.847 E.01418
G1 X157.193 Y195.514 E.01444
G1 X157.026 Y195.151 E.0144
G1 X156.905 Y194.756 E.01493
G1 X156.836 Y194.125 E.02291
G1 X156.836 Y134.301 E2.16001
G1 X156.884 Y134.197 E.00413
G1 X157.023 Y134.174 E.00511
G1 X157.193 Y134.24 E.00658
G1 X157.399 Y134.288 E.00764
G1 X158.013 Y134.301 E.02218
M204 S6000
G1 X157.719 Y134.8 F60000
G1 F3000
M204 S500
G1 X157.75 Y134.887 E.00334
G1 X157.75 Y194.165 E2.1403
G1 X157.837 Y194.672 E.01858
G1 X157.917 Y194.898 E.00865
G1 X158.15 Y195.28 E.01613
G1 X158.233 Y195.378 E.00466
G1 X158.506 Y195.61 E.01292
G1 X158.916 Y195.828 E.01678
G1 X159.228 Y195.915 E.01167
G1 X159.528 Y195.95 E.01093
G1 X178.338 Y195.95 E.67915
G1 X178.442 Y195.997 E.00413
G1 X178.475 Y196.087 E.00344
G1 X178.475 Y209.964 E.50104
G1 X178.592 Y210.572 E.02235
G1 X178.691 Y210.796 E.00886
G1 X178.871 Y211.074 E.01194
M73 P29 R15
G1 X179.131 Y211.337 E.01339
G1 X179.526 Y211.579 E.01672
G1 X179.864 Y211.696 E.0129
G1 X180.255 Y211.75 E.01424
G1 X189.865 Y211.75 E.347
G1 X190.372 Y211.663 E.01858
G1 X190.604 Y211.581 E.00886
G1 X190.858 Y211.44 E.0105
G1 X191.122 Y211.226 E.01227
G1 X191.256 Y211.075 E.00728
G1 X191.527 Y210.588 E.02013
G1 X191.595 Y210.363 E.0085
G1 X191.645 Y210.047 E.01152
G1 X191.65 Y184.451 E.92417
G1 X191.687 Y184.357 E.00366
G1 X191.806 Y184.231 E.00626
G1 X192.061 Y183.838 E.0169
G1 X192.192 Y183.468 E.01417
G1 X192.25 Y183.068 E.01459
G1 X192.25 Y145.935 E1.34073
G1 X192.163 Y145.428 E.01858
G1 X192.083 Y145.202 E.00865
G1 X191.853 Y144.825 E.01592
G1 X191.688 Y144.651 E.00868
G1 X191.65 Y144.557 E.00367
G1 X191.65 Y127.526 E.61491
G1 X191.601 Y127.143 E.01392
G1 X191.526 Y126.894 E.00939
G1 X191.412 Y126.65 E.00973
G1 X191.271 Y126.443 E.00905
G1 X191.027 Y126.191 E.01267
G1 X190.746 Y125.995 E.01238
G1 X190.569 Y125.904 E.00718
G1 X190.261 Y125.804 E.01168
G1 X189.947 Y125.755 E.01147
G1 X172.437 Y125.75 E.63223
G1 X172.333 Y125.703 E.00413
G1 X172.3 Y125.613 E.00344
G1 X172.3 Y125.43 E.0066
G1 X172.347 Y125.326 E.00413
G1 X172.437 Y125.293 E.00344
G1 X189.829 Y125.294 E.62795
G1 X190.183 Y125.326 E.01283
G1 X190.846 Y125.53 E.02508
G1 X191.131 Y125.684 E.01169
G1 X191.4 Y125.893 E.01228
G1 X191.617 Y126.127 E.01156
G1 X191.8 Y126.401 E.01188
G1 X191.948 Y126.721 E.01273
G1 X192.046 Y127.05 E.01239
G1 X192.107 Y127.607 E.02026
G1 X192.107 Y143.837 E.58597
G1 X192.201 Y144.373 E.01966
G1 X192.269 Y144.552 E.00692
G1 X192.508 Y145.026 E.01916
G1 X192.641 Y145.433 E.01547
G1 X192.707 Y146.008 E.0209
G1 X192.707 Y183.013 E1.33609
G1 X192.665 Y183.442 E.01559
G1 X192.512 Y183.953 E.01926
G1 X192.228 Y184.543 E.02365
G1 X192.184 Y184.678 E.00512
G1 X192.107 Y185.165 E.0178
G1 X192.107 Y209.913 E.89352
G1 X192.07 Y210.316 E.01462
G1 X191.913 Y210.848 E.02004
G1 X191.729 Y211.21 E.01465
G1 X191.516 Y211.49 E.01273
G1 X191.268 Y211.72 E.0122
G1 X190.998 Y211.901 E.01172
G1 X190.679 Y212.048 E.01269
G1 X190.35 Y212.146 E.01238
G1 X189.793 Y212.207 E.02026
G1 X180.298 Y212.206 E.3428
G1 X179.934 Y212.175 E.0132
G1 X179.353 Y212.003 E.02186
G1 X178.998 Y211.818 E.01445
G1 X178.72 Y211.603 E.01269
G1 X178.505 Y211.369 E.01147
G1 X178.315 Y211.081 E.01248
G1 X178.167 Y210.751 E.01306
M73 P29 R14
G1 X178.07 Y210.408 E.01284
G1 X178.019 Y209.91 E.0181
G1 X178.018 Y198.044 E.42844
G1 X177.931 Y197.55 E.0181
G1 X177.848 Y197.323 E.00873
G1 X177.664 Y197.022 E.01274
G1 X177.447 Y196.803 E.01114
G1 X177.149 Y196.611 E.0128
G1 X176.912 Y196.509 E.0093
G1 X176.379 Y196.407 E.01961
G1 X159.582 Y196.407 E.60645
G1 X159.247 Y196.38 E.01216
G1 X158.528 Y196.159 E.02716
G1 X158.25 Y196.004 E.0115
G1 X158 Y195.807 E.01146
G1 X157.783 Y195.573 E.01156
G1 X157.6 Y195.299 E.01188
G1 X157.458 Y194.996 E.01207
G1 X157.359 Y194.676 E.01213
G1 X157.293 Y194.093 E.02118
G1 X157.293 Y134.883 E2.13784
G1 X157.341 Y134.779 E.00413
G1 X157.433 Y134.746 E.00354
G1 X157.616 Y134.75 E.0066
G1 X157.665 Y134.773 E.00196
; WIPE_START
G1 X157.75 Y134.887 E-.05387
G1 X157.75 Y136.745 E-.70613
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X157.418 Y129.12 Z.6 F60000
G1 X157.022 Y120.016 Z.6
G1 Z.2
G1 E.8 F1800
G1 F3000
M204 S500
G1 X156.908 Y120.009 E.00413
G1 X156.836 Y119.888 E.00508
G1 X156.837 Y110.048 E.35528
G1 X156.88 Y109.584 E.01683
G1 X157.055 Y108.994 E.02222
G1 X157.3 Y108.518 E.01934
G1 X157.548 Y108.196 E.01465
G1 X157.87 Y107.901 E.0158
G1 X158.194 Y107.689 E.01396
G1 X158.459 Y107.562 E.01061
G1 X159.001 Y107.395 E.02049
G1 X159.559 Y107.337 E.02026
G1 X168.251 Y107.337 E.31381
G1 X168.711 Y107.38 E.0167
G1 X169.392 Y107.591 E.02574
G1 X169.76 Y107.784 E.01499
G1 X170.089 Y108.035 E.01496
G1 X170.373 Y108.337 E.01496
G1 X170.607 Y108.687 E.01519
G1 X170.774 Y109.049 E.01438
G1 X170.895 Y109.444 E.01493
G1 X170.964 Y110.075 E.02291
G1 X170.964 Y119.003 E.32236
G1 X171.029 Y119.381 E.01386
G1 X171.189 Y119.783 E.01559
G1 X171.183 Y119.897 E.00413
G1 X171.035 Y119.968 E.00591
G1 X170.671 Y119.897 E.01339
G1 X169.761 Y119.897 E.03285
G1 X169.663 Y119.856 E.00387
G1 X169.593 Y119.728 E.00527
G1 X169.593 Y110.023 E.35039
G1 X169.512 Y109.605 E.01536
G1 X169.454 Y109.458 E.00572
G1 X169.341 Y109.265 E.00808
G1 X169.177 Y109.073 E.0091
G1 X168.878 Y108.866 E.01314
G1 X168.768 Y108.814 E.00439
G1 X168.521 Y108.739 E.00932
G1 X168.28 Y108.707 E.00878
G1 X159.523 Y108.707 E.31617
G1 X159.105 Y108.788 E.01536
G1 X158.961 Y108.845 E.00561
G1 X158.662 Y109.038 E.01284
G1 X158.49 Y109.225 E.00919
G1 X158.314 Y109.532 E.01278
G1 X158.239 Y109.779 E.00932
G1 X158.207 Y110.02 E.00878
G1 X158.207 Y119.76 E.35168
G1 X158.16 Y119.864 E.00413
G1 X158.072 Y119.897 E.00339
G1 X157.428 Y119.905 E.02327
G1 X157.185 Y119.954 E.00894
G1 X157.078 Y119.994 E.00411
M204 S6000
G1 X157.339 Y119.407 F60000
G1 F3000
M204 S500
G1 X157.327 Y119.402 E.00047
G1 X157.293 Y119.311 E.0035
G1 X157.294 Y110.063 E.33391
G1 X157.335 Y109.658 E.01469
G1 X157.477 Y109.177 E.01811
G1 X157.682 Y108.775 E.01629
G1 X157.894 Y108.499 E.01259
G1 X158.161 Y108.256 E.01302
G1 X158.41 Y108.093 E.01076
G1 X158.616 Y107.993 E.00826
G1 X159.08 Y107.849 E.01754
G1 X159.576 Y107.795 E.01801
G1 X168.236 Y107.794 E.31267
G1 X168.635 Y107.835 E.01448
G1 X169.205 Y108.012 E.02156
G1 X169.503 Y108.166 E.01212
G1 X169.773 Y108.369 E.0122
G1 X170.006 Y108.614 E.01222
G1 X170.201 Y108.902 E.01254
G1 X170.348 Y109.221 E.01269
G1 X170.446 Y109.55 E.01238
G1 X170.507 Y110.107 E.02026
G1 X170.507 Y118.993 E.32083
G1 X170.549 Y119.284 E.0106
G1 X170.516 Y119.393 E.00413
G1 X170.413 Y119.44 E.00409
G1 X170.187 Y119.44 E.00816
G1 X170.083 Y119.393 E.00413
G1 X170.05 Y119.303 E.00344
G1 X170.05 Y110.035 E.33464
G1 X169.963 Y109.528 E.01858
G1 X169.881 Y109.296 E.00886
G1 X169.74 Y109.042 E.01051
G1 X169.529 Y108.782 E.0121
G1 X169.146 Y108.495 E.01727
G1 X168.969 Y108.404 E.00718
G1 X168.662 Y108.305 E.01164
G1 X168.27 Y108.25 E.01428
G1 X159.535 Y108.25 E.3154
G1 X159.028 Y108.337 E.01858
G1 X158.802 Y108.417 E.00865
G1 X158.42 Y108.65 E.01613
G1 X158.322 Y108.733 E.00466
G1 X158.087 Y109.009 E.01307
G1 X157.921 Y109.298 E.01204
G1 X157.785 Y109.728 E.01627
G1 X157.75 Y110.028 E.01092
G1 X157.75 Y119.309 E.33509
G1 X157.703 Y119.413 E.00413
G1 X157.615 Y119.446 E.00339
G1 X157.432 Y119.448 E.0066
G1 X157.394 Y119.431 E.0015
; WIPE_START
G1 X157.327 Y119.402 E-.0277
G1 X157.293 Y119.311 E-.03684
G1 X157.293 Y117.481 E-.69546
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X162.092 Y123.416 Z.6 F60000
G1 X168.96 Y131.91 Z.6
G1 Z.2
G1 E.8 F1800
; FEATURE: Outer wall
G1 F3000
M204 S500
G1 X168.96 Y127.9 E.14479
G1 X189.5 Y127.9 E.74162
G1 X189.5 Y146.3 E.66435
G1 X190.1 Y146.3 E.02166
G1 X190.1 Y182.7 E1.31426
G1 X189.5 Y182.7 E.02166
G1 X189.5 Y209.6 E.97125
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

G1 X180.625 Y209.6 E.32044
M73 P30 R14
G1 X180.625 Y193.8 E.57047
G1 X159.9 Y193.8 E.7483
G1 X159.9 Y131.91 E2.2346
G1 X168.9 Y131.91 E.32495
M204 S6000
G1 X169.417 Y132.367 F60000
; FEATURE: Inner wall
G1 F3000
M204 S500
G1 X169.417 Y128.357 E.14479
G1 X189.043 Y128.357 E.70861
G1 X189.043 Y146.757 E.66435
G1 X189.643 Y146.757 E.02166
G1 X189.643 Y182.243 E1.28125
G1 X189.043 Y182.243 E.02166
G1 X189.043 Y209.143 E.97125
G1 X181.082 Y209.143 E.28744
G1 X181.082 Y193.343 E.57047
G1 X160.357 Y193.343 E.7483
G1 X160.357 Y132.367 E2.2016
G1 X169.357 Y132.367 E.32495
; WIPE_START
G1 X169.387 Y130.367 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X170.245 Y137.951 Z.6 F60000
G1 X175.895 Y187.905 Z.6
G1 Z.2
G1 E.8 F1800
; FEATURE: Outer wall
G1 F3000
M204 S500
G1 X175.895 Y192.495 E.16573
G1 X171.255 Y192.495 E.16753
G1 X171.255 Y187.905 E.16573
G1 X175.835 Y187.905 E.16537
M204 S6000
G1 X175.895 Y187.448 F60000
; FEATURE: Inner wall
G1 F3000
M204 S500
G1 X176.352 Y187.448 E.0165
G1 X176.352 Y192.952 E.19873
G1 X170.798 Y192.952 E.20054
G1 X170.798 Y187.448 E.19873
G1 X175.835 Y187.448 E.18187
; WIPE_START
G1 X176.352 Y187.448 E-.19649
G1 X176.352 Y188.931 E-.56351
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X168.946 Y190.774 Z.6 F60000
G1 X161.95 Y192.515 Z.6
G1 Z.2
G1 E.8 F1800
; FEATURE: Outer wall
G1 F3000
M204 S500
G1 X161.95 Y186.475 E.21808
G1 X165.45 Y186.475 E.12637
G1 X165.45 Y192.515 E.21808
G1 X162.01 Y192.515 E.1242
M204 S6000
G1 X161.95 Y192.972 F60000
; FEATURE: Inner wall
G1 F3000
M204 S500
G1 X161.493 Y192.972 E.0165
G1 X161.493 Y186.018 E.25109
G1 X165.907 Y186.018 E.15938
G1 X165.907 Y192.972 E.25109
G1 X162.01 Y192.972 E.14071
; WIPE_START
G1 X161.493 Y192.972 E-.19649
G1 X161.493 Y191.489 E-.56351
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X165.259 Y184.851 Z.6 F60000
G1 X165.45 Y184.515 Z.6
G1 Z.2
G1 E.8 F1800
; FEATURE: Outer wall
G1 F3000
M204 S500
G1 X161.95 Y184.515 E.12637
G1 X161.95 Y178.475 E.21808
G1 X165.45 Y178.475 E.12637
G1 X165.45 Y184.455 E.21591
M204 S6000
M73 P31 R14
G1 X165.907 Y184.515 F60000
; FEATURE: Inner wall
G1 F3000
M204 S500
G1 X165.907 Y184.972 E.0165
G1 X161.493 Y184.972 E.15938
G1 X161.493 Y178.018 E.25109
G1 X165.907 Y178.018 E.15938
G1 X165.907 Y184.455 E.23242
; WIPE_START
G1 X165.907 Y184.972 E-.19649
G1 X164.424 Y184.972 E-.56351
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X166.642 Y177.669 Z.6 F60000
G1 X169.715 Y167.55 Z.6
G1 Z.2
G1 E.8 F1800
; FEATURE: Outer wall
G1 F3000
M204 S500
G1 X161.674 Y167.55 E.29033
G1 X161.674 Y160.25 E.26357
G1 X169.715 Y160.25 E.29033
G1 X169.715 Y167.49 E.26141
M204 S6000
G1 X170.172 Y167.55 F60000
; FEATURE: Inner wall
G1 F3000
M204 S500
G1 X170.172 Y168.007 E.0165
G1 X161.217 Y168.007 E.32333
G1 X161.217 Y159.793 E.29658
G1 X170.172 Y159.793 E.32333
G1 X170.172 Y167.49 E.27791
; WIPE_START
G1 X170.172 Y168.007 E-.19649
G1 X168.689 Y168.007 E-.56351
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X172.078 Y161.168 Z.6 F60000
G1 X187.9 Y129.236 Z.6
G1 Z.2
G1 E.8 F1800
G1 F3000
M204 S500
G1 X175.986 Y129.236 E.43017
G1 X175.986 Y134.814 E.20141
G1 X188.586 Y134.814 E.45494
G1 X188.586 Y137.236 E.08744
G1 X175.986 Y137.236 E.45494
G1 X175.986 Y142.814 E.20141
G1 X188.586 Y142.814 E.45494
G1 X188.586 Y146.601 E.13672
G1 X181.761 Y146.601 E.24642
G1 X181.761 Y182.409 E1.29289
G1 X188.586 Y182.409 E.24642
G1 X188.586 Y208.686 E.94875
G1 X181.539 Y208.686 E.25443
G1 X181.539 Y192.886 E.57047
G1 X176.809 Y192.886 E.17078
G1 X176.809 Y186.991 E.21284
G1 X170.341 Y186.991 E.23354
G1 X170.341 Y192.886 E.21284
G1 X166.364 Y192.886 E.14358
G1 X166.364 Y177.561 E.55332
G1 X160.814 Y177.561 E.20039
G1 X160.814 Y168.464 E.32845
G1 X170.629 Y168.464 E.35438
G1 X170.629 Y159.336 E.32959
G1 X160.814 Y159.336 E.35438
G1 X160.814 Y153.204 E.22139
G1 X166.126 Y153.204 E.19179
G1 X166.126 Y155.529 E.08395
G1 X176.274 Y155.529 E.36641
G1 X176.274 Y150.461 E.183
G1 X166.364 Y150.461 E.35781
G1 X166.364 Y142.704 E.28006
G1 X167.264 Y142.704 E.0325
G1 X167.264 Y132.824 E.35673
G1 X169.874 Y132.824 E.09424
G1 X169.874 Y128.814 E.14479
G1 X188.586 Y128.814 E.67561
G1 X188.586 Y129.236 E.01523
G1 X187.96 Y129.236 E.0226
; WIPE_START
G1 X185.96 Y129.236 E-.76
; WIPE_END
M73 P32 R14
G1 E-.04 F1800
M204 S6000
G1 X185.785 Y136.866 Z.6 F60000
G1 X184.306 Y201.312 Z.6
G1 Z.2
G1 E.8 F1800
; FEATURE: Outer wall
G1 F3000
M204 S500
G1 X184.318 Y201.3 E.00064
G3 X185.137 Y200.958 I.981 J1.2 E.03249
G1 X185.292 Y200.95 E.00562
G3 X184.095 Y201.524 I.007 J1.55 E.30201
G1 X184.263 Y201.355 E.0086
M204 S6000
G1 X183.983 Y200.991 F60000
; FEATURE: Inner wall
G1 F3000
M204 S500
G1 X184.028 Y200.946 E.0023
G3 X185.089 Y200.503 I1.271 J1.553 E.0421
G1 X185.289 Y200.492 E.00726
G3 X183.739 Y201.235 I.009 J2.007 E.39116
G1 X183.941 Y201.034 E.0103
M204 S6000
G1 X183.817 Y200.539 F60000
G1 F3000
M204 S500
G1 X184.137 Y200.325 E.0139
G3 X185.04 Y200.048 I1.161 J2.174 E.03432
G1 X185.286 Y200.034 E.0089
G3 X183.737 Y200.592 I.011 J2.464 E.49844
G1 X183.767 Y200.572 E.00129
; WIPE_START
G1 X184.137 Y200.325 E-.16914
G1 X184.573 Y200.144 E-.17944
G1 X185.04 Y200.048 E-.18118
G1 X185.286 Y200.034 E-.09367
G1 X185.644 Y200.068 E-.13656
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X185.91 Y192.44 Z.6 F60000
G1 X187.9 Y135.271 Z.6
G1 Z.2
G1 E.8 F1800
G1 F3000
M204 S500
G1 X188.129 Y135.271 E.00826
G1 X188.129 Y136.779 E.05443
G1 X175.529 Y136.779 E.45494
G1 X175.529 Y143.271 E.23442
G1 X188.129 Y143.271 E.45494
G1 X188.129 Y146.144 E.10372
G1 X181.304 Y146.144 E.24642
G1 X181.304 Y155.654 E.34337
G1 X176.731 Y155.654 E.1651
G1 X176.731 Y150.004 E.204
G1 X166.821 Y150.004 E.35781
G1 X166.821 Y143.161 E.24706
G1 X167.721 Y143.161 E.0325
G1 X167.721 Y133.281 E.35673
G1 X170.331 Y133.281 E.09424
G1 X170.331 Y129.271 E.14479
G1 X175.529 Y129.271 E.18766
G1 X175.529 Y135.271 E.21664
G1 X187.84 Y135.271 E.44451
; WIPE_START
G1 X188.129 Y135.271 E-.10974
G1 X188.129 Y136.779 E-.57288
G1 X187.925 Y136.779 E-.07737
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X182.307 Y141.945 Z.6 F60000
G1 X167.04 Y155.986 Z.6
G1 Z.2
G1 E.8 F1800
G1 F3000
M204 S500
G1 X174.354 Y155.986 E.26407
G1 X174.354 Y161.346 E.19353
G1 X181.304 Y161.346 E.25094
G1 X181.304 Y182.866 E.777
G1 X188.129 Y182.866 E.24642
G1 X188.129 Y201.148 E.66009
G1 X187.928 Y201.204 E.00752
G2 X187.928 Y203.795 I-2.622 J1.295 E.56662
G1 X188.129 Y203.851 E.00753
G1 X188.129 Y208.229 E.15807
G1 X181.996 Y208.229 E.22142
G1 X181.996 Y192.429 E.57047
G1 X177.266 Y192.429 E.17078
G1 X177.266 Y186.534 E.21284
G1 X169.884 Y186.534 E.26655
G1 X169.884 Y192.429 E.21284
G1 X166.821 Y192.429 E.11058
G1 X166.821 Y177.104 E.55332
G1 X161.271 Y177.104 E.20039
G1 X161.271 Y168.921 E.29544
G1 X171.086 Y168.921 E.35438
G1 X171.086 Y158.879 E.36259
G1 X161.271 Y158.879 E.35438
G1 X161.271 Y153.661 E.18839
G1 X165.669 Y153.661 E.15878
G1 X165.669 Y155.986 E.08395
G1 X166.98 Y155.986 E.04734
; WIPE_START
G1 X168.98 Y155.986 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X176.17 Y158.548 Z.6 F60000
G1 X180.175 Y159.975 Z.6
G1 Z.2
G1 E.8 F1800
; FEATURE: Outer wall
G1 F3000
M204 S500
G1 X175.725 Y159.975 E.16067
G1 X175.725 Y157.025 E.10651
G1 X180.175 Y157.025 E.16067
G1 X180.175 Y159.915 E.10435
M204 S6000
G1 X180.632 Y159.975 F60000
; FEATURE: Inner wall
G1 F3000
M204 S500
M73 P33 R14
G1 X180.632 Y160.432 E.0165
G1 X175.268 Y160.432 E.19368
G1 X175.268 Y156.568 E.13952
G1 X180.632 Y156.568 E.19368
G1 X180.632 Y159.915 E.12085
; WIPE_START
G1 X180.632 Y160.432 E-.19649
G1 X179.149 Y160.432 E-.56351
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X180.175 Y160.889 Z.6 F60000
G1 Z.2
G1 E.8 F1800
G1 F3000
M204 S500
G1 X174.811 Y160.889 E.19368
G1 X174.811 Y156.111 E.17252
G1 X181.089 Y156.111 E.22668
G1 X181.089 Y160.889 E.17252
G1 X180.235 Y160.889 E.03084
; WIPE_START
G1 X178.235 Y160.889 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X180.524 Y153.608 Z.6 F60000
G1 X187.9 Y130.15 Z.6
G1 Z.2
G1 E.8 F1800
; FEATURE: Outer wall
G1 F3000
M204 S500
G1 X187.9 Y133.9 E.1354
G1 X176.9 Y133.9 E.39717
G1 X176.9 Y130.15 E.1354
G1 X187.84 Y130.15 E.395
M204 S6000
G1 X187.9 Y129.693 F60000
; FEATURE: Inner wall
G1 F3000
M204 S500
G1 X188.357 Y129.693 E.0165
G1 X188.357 Y134.357 E.1684
G1 X176.443 Y134.357 E.43017
G1 X176.443 Y129.693 E.1684
G1 X187.84 Y129.693 E.4115
; WIPE_START
G1 X188.357 Y129.693 E-.19649
G1 X188.357 Y131.176 E-.56351
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X182.785 Y136.392 Z.6 F60000
G1 X176.9 Y141.9 Z.6
G1 Z.2
G1 E.8 F1800
; FEATURE: Outer wall
G1 F3000
M204 S500
G1 X176.9 Y138.15 E.1354
G1 X187.9 Y138.15 E.39717
G1 X187.9 Y141.9 E.1354
G1 X176.96 Y141.9 E.395
M204 S6000
G1 X176.9 Y142.357 F60000
; FEATURE: Inner wall
G1 F3000
M204 S500
G1 X176.443 Y142.357 E.0165
G1 X176.443 Y137.693 E.1684
G1 X188.357 Y137.693 E.43017
G1 X188.357 Y142.357 E.1684
G1 X176.96 Y142.357 E.4115
; WIPE_START
G1 X176.443 Y142.357 E-.19649
G1 X176.443 Y140.874 E-.56351
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X183.156 Y144.507 Z.6 F60000
G1 X188.715 Y147.515 Z.6
G1 Z.2
G1 E.8 F1800
; FEATURE: Outer wall
G1 F3000
M204 S500
G1 X188.715 Y181.495 E1.22688
G1 X182.675 Y181.495 E.21808
G1 X182.675 Y147.515 E1.22688
G1 X188.655 Y147.515 E.21591
M204 S6000
G1 X188.715 Y147.058 F60000
; FEATURE: Inner wall
G1 F3000
M204 S500
G1 X189.172 Y147.058 E.0165
G1 X189.172 Y181.952 E1.25989
G1 X182.218 Y181.952 E.25109
G1 X182.218 Y147.058 E1.25989
G1 X188.655 Y147.058 E.23242
; WIPE_START
G1 X189.172 Y147.058 E-.19649
G1 X189.172 Y148.541 E-.56351
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X181.853 Y146.376 Z.6 F60000
G1 X166.35 Y141.79 Z.6
G1 Z.2
G1 E.8 F1800
; FEATURE: Outer wall
G1 F3000
M204 S500
G1 X162.85 Y141.79 E.12637
G1 X162.85 Y133.21 E.30979
G1 X166.35 Y133.21 E.12637
G1 X166.35 Y141.73 E.30762
M204 S6000
G1 X166.807 Y141.79 F60000
; FEATURE: Inner wall
G1 F3000
M204 S500
G1 X166.807 Y142.247 E.0165
G1 X162.393 Y142.247 E.15938
G1 X162.393 Y132.753 E.3428
G1 X166.807 Y132.753 E.15938
G1 X166.807 Y141.73 E.32413
; WIPE_START
G1 X166.807 Y142.247 E-.19649
G1 X165.324 Y142.247 E-.56351
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X161.936 Y142.796 Z.6 F60000
G1 Z.2
G1 E.8 F1800
G1 F3000
M204 S500
G1 X160.814 Y142.796 E.0405
G1 X160.814 Y132.824 E.36004
G1 X161.936 Y132.824 E.0405
G1 X161.936 Y142.736 E.35787
; WIPE_START
G1 X160.814 Y142.796 E-.42687
M73 P34 R14
G1 X160.814 Y141.919 E-.33313
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X165.45 Y143.71 Z.6 F60000
G1 Z.2
G1 E.8 F1800
; FEATURE: Outer wall
G1 F3000
M204 S500
G1 X165.45 Y152.29 E.30979
G1 X161.95 Y152.29 E.12637
G1 X161.95 Y143.71 E.30979
G1 X165.39 Y143.71 E.1242
M204 S6000
G1 X165.45 Y143.253 F60000
; FEATURE: Inner wall
G1 F3000
M204 S500
G1 X165.907 Y143.253 E.0165
G1 X165.907 Y152.747 E.3428
G1 X161.493 Y152.747 E.15938
G1 X161.493 Y143.253 E.3428
G1 X165.39 Y143.253 E.14071
; WIPE_START
M73 P34 R13
G1 X165.907 Y143.253 E-.19649
G1 X165.907 Y144.736 E-.56351
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X166.777 Y152.319 Z.6 F60000
G1 X167.04 Y154.615 Z.6
G1 Z.2
G1 E.8 F1800
; FEATURE: Outer wall
G1 F3000
M204 S500
G1 X167.04 Y151.375 E.11698
G1 X175.36 Y151.375 E.3004
G1 X175.36 Y154.615 E.11698
G1 X167.1 Y154.615 E.29824
M204 S6000
G1 X167.04 Y155.072 F60000
; FEATURE: Inner wall
G1 F3000
M204 S500
G1 X166.583 Y155.072 E.0165
G1 X166.583 Y150.918 E.14999
G1 X175.817 Y150.918 E.33341
G1 X175.817 Y155.072 E.14999
G1 X167.1 Y155.072 E.31474
; WIPE_START
G1 X166.583 Y155.072 E-.19649
G1 X166.583 Y153.589 E-.56351
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X166.245 Y152.975 Z.6 F60000
G1 Z.2
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.26172
G1 F3000
M204 S500
G1 X166.245 Y150.689 E.03951
; WIPE_START
G1 X166.245 Y152.689 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X160.925 Y152.975 Z.6 F60000
G1 Z.2
G1 E.8 F1800
; LINE_WIDTH: 0.72172
G1 F3000
M204 S500
G1 X160.925 Y143.024 E.53358
M204 S6000
G1 X161.375 Y142.567 F60000
; LINE_WIDTH: 0.70758
G1 F3000
M204 S500
G1 X161.375 Y133.053 E.49955
; WIPE_START
G1 X161.375 Y135.053 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X162.154 Y142.645 Z.6 F60000
G1 X162.164 Y142.75 Z.6
G1 Z.2
G1 E.8 F1800
; LINE_WIDTH: 0.59172
G1 F3000
M204 S500
G1 X166.135 Y142.75 E.17215
; WIPE_START
G1 X164.135 Y142.75 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X168.512 Y149.003 Z.6 F60000
G1 X173.528 Y156.169 Z.6
G1 Z.2
G1 E.8 F1800
; FEATURE: Bottom surface
; LINE_WIDTH: 0.50331
G1 F6300
M204 S500
G1 X173.965 Y156.606 E.0225
G1 X173.965 Y157.258 E.02368
G1 X173.082 Y156.375 E.04541
G1 X172.431 Y156.375 E.02368
G1 X173.965 Y157.909 E.0789
G1 X173.965 Y158.56 E.02368
G1 X171.78 Y156.375 E.11238
G1 X171.129 Y156.375 E.02368
G1 X173.965 Y159.211 E.14587
G1 X173.965 Y159.862 E.02368
G1 X170.478 Y156.375 E.17935
G1 X169.827 Y156.375 E.02368
G1 X174.171 Y160.719 E.22342
; WIPE_START
G1 X172.757 Y159.304 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X180.069 Y161.493 Z.6 F60000
G1 X180.19 Y161.529 Z.6
G1 Z.2
G1 E.8 F1800
G1 F6300
M204 S500
G1 X180.915 Y162.254 E.0373
G1 X180.915 Y162.905 E.02368
G1 X179.745 Y161.735 E.06021
G1 X179.094 Y161.735 E.02368
G1 X180.915 Y163.556 E.0937
G1 X180.915 Y164.208 E.02368
G1 X178.442 Y161.735 E.12718
G1 X177.791 Y161.735 E.02368
G1 X180.915 Y164.859 E.16067
G1 X180.915 Y165.51 E.02368
G1 X177.14 Y161.735 E.19416
G1 X176.489 Y161.735 E.02368
G1 X180.915 Y166.161 E.22764
G1 X180.915 Y166.812 E.02368
G1 X175.838 Y161.735 E.26113
G1 X175.187 Y161.735 E.02368
G1 X180.915 Y167.463 E.29462
G1 X180.915 Y168.114 E.02368
G1 X174.536 Y161.735 E.3281
G1 X173.965 Y161.735 E.02075
G1 X173.965 Y161.164 E.02075
G1 X169.176 Y156.375 E.24633
G1 X168.525 Y156.375 E.02368
G1 X170.641 Y158.49 E.10882
G1 X169.99 Y158.49 E.02368
G1 X167.874 Y156.375 E.10882
G1 X167.223 Y156.375 E.02368
G1 X169.338 Y158.49 E.10882
G1 X168.687 Y158.49 E.02368
G1 X166.366 Y156.169 E.1194
; WIPE_START
G1 X167.78 Y157.583 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X165.486 Y154.638 Z.6 F60000
G1 Z.2
G1 E.8 F1800
G1 F6300
M204 S500
G1 X164.898 Y154.05 E.03026
G1 X164.247 Y154.05 E.02368
G1 X165.486 Y155.289 E.06375
; WIPE_START
G1 X164.247 Y154.05 E-.66609
G1 X164.494 Y154.05 E-.09391
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X163.39 Y153.844 Z.6 F60000
G1 Z.2
G1 E.8 F1800
G1 F6300
M204 S500
G1 X165.28 Y155.734 E.09723
G1 X165.28 Y156.375 E.02328
G1 X165.92 Y156.375 E.02328
G1 X168.036 Y158.49 E.10882
G1 X167.385 Y158.49 E.02368
G1 X162.944 Y154.05 E.22839
G1 X162.293 Y154.05 E.02368
G1 X166.734 Y158.49 E.22839
G1 X166.083 Y158.49 E.02368
G1 X161.66 Y154.067 E.2275
G1 X161.66 Y154.718 E.02368
G1 X165.432 Y158.49 E.19401
G1 X164.781 Y158.49 E.02368
G1 X161.66 Y155.369 E.16053
G1 X161.66 Y156.02 E.02368
G1 X164.13 Y158.49 E.12704
G1 X163.479 Y158.49 E.02368
G1 X161.66 Y156.671 E.09356
G1 X161.66 Y157.322 E.02368
G1 X162.828 Y158.49 E.06007
G1 X162.176 Y158.49 E.02368
G1 X161.454 Y157.768 E.03716
; WIPE_START
G1 X162.176 Y158.49 E-.38829
M73 P35 R13
G1 X162.828 Y158.49 E-.24742
G1 X162.596 Y158.259 E-.12429
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X170.192 Y159.012 Z.6 F60000
G1 X171.269 Y159.119 Z.6
G1 Z.2
G1 E.8 F1800
G1 F6300
M204 S500
G1 X180.915 Y168.765 E.49613
G1 X180.915 Y169.416 E.02368
G1 X171.475 Y159.975 E.48555
G1 X171.475 Y160.627 E.02368
G1 X180.915 Y170.067 E.48555
G1 X180.915 Y170.718 E.02368
G1 X171.475 Y161.278 E.48555
G1 X171.475 Y161.929 E.02368
G1 X180.915 Y171.369 E.48555
G1 X180.915 Y172.021 E.02368
G1 X171.475 Y162.58 E.48555
G1 X171.475 Y163.231 E.02368
G1 X180.915 Y172.672 E.48555
G1 X180.915 Y173.323 E.02368
G1 X171.475 Y163.882 E.48555
G1 X171.475 Y164.533 E.02368
G1 X180.915 Y173.974 E.48555
G1 X180.915 Y174.625 E.02368
G1 X171.475 Y165.184 E.48555
G1 X171.475 Y165.835 E.02368
G1 X180.915 Y175.276 E.48555
G1 X180.915 Y175.927 E.02368
G1 X171.475 Y166.486 E.48555
G1 X171.475 Y167.137 E.02368
G1 X180.915 Y176.578 E.48555
G1 X180.915 Y177.229 E.02368
G1 X171.475 Y167.789 E.48555
G1 X171.475 Y168.44 E.02368
G1 X180.915 Y177.88 E.48555
G1 X180.915 Y178.531 E.02368
G1 X171.475 Y169.091 E.48555
G1 X171.475 Y169.31 E.00796
G1 X171.042 Y169.31 E.01572
G1 X180.915 Y179.183 E.50778
G1 X180.915 Y179.834 E.02368
G1 X170.391 Y169.31 E.54127
G1 X169.74 Y169.31 E.02368
G1 X180.915 Y180.485 E.57475
G1 X180.915 Y181.136 E.02368
G1 X169.089 Y169.31 E.60824
G1 X168.438 Y169.31 E.02368
G1 X180.915 Y181.787 E.64173
G1 X180.915 Y182.438 E.02368
G1 X167.581 Y169.104 E.68579
; WIPE_START
G1 X168.996 Y170.518 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X175.275 Y174.856 Z.6 F60000
G1 X187.946 Y183.609 Z.6
G1 Z.2
G1 E.8 F1800
G1 F6300
M204 S500
G1 X187.592 Y183.255 E.01822
G1 X186.941 Y183.255 E.02368
G1 X187.74 Y184.054 E.04113
G1 X187.74 Y184.705 E.02368
G1 X186.29 Y183.255 E.07461
G1 X185.639 Y183.255 E.02368
G1 X187.74 Y185.356 E.1081
G1 X187.74 Y186.008 E.02368
G1 X184.987 Y183.255 E.14159
G1 X184.336 Y183.255 E.02368
G1 X187.74 Y186.659 E.17507
G1 X187.74 Y187.31 E.02368
G1 X183.685 Y183.255 E.20856
G1 X183.034 Y183.255 E.02368
G1 X187.74 Y187.961 E.24205
G1 X187.74 Y188.612 E.02368
G1 X182.383 Y183.255 E.27553
G1 X181.732 Y183.255 E.02368
G1 X187.74 Y189.263 E.30902
G1 X187.74 Y189.914 E.02368
G1 X167.136 Y169.31 E1.05972
G1 X166.485 Y169.31 E.02368
G1 X187.74 Y190.565 E1.0932
G1 X187.74 Y191.216 E.02368
G1 X165.834 Y169.31 E1.12669
G1 X165.183 Y169.31 E.02368
G1 X187.74 Y191.867 E1.16018
G1 X187.74 Y192.518 E.02368
G1 X164.532 Y169.31 E1.19366
G1 X163.88 Y169.31 E.02368
G1 X187.74 Y193.17 E1.22715
G1 X187.74 Y193.821 E.02368
M73 P36 R13
G1 X163.229 Y169.31 E1.26064
G1 X162.578 Y169.31 E.02368
G1 X187.74 Y194.472 E1.29412
G1 X187.74 Y195.123 E.02368
G1 X161.927 Y169.31 E1.32761
G1 X161.66 Y169.31 E.00973
G1 X161.66 Y169.693 E.01395
G1 X187.74 Y195.774 E1.34137
G1 X187.74 Y196.425 E.02368
G1 X161.66 Y170.344 E1.34137
G1 X161.66 Y170.995 E.02368
G1 X176.81 Y186.145 E.77919
G1 X176.159 Y186.145 E.02368
G1 X167.21 Y177.196 E.46026
G1 X167.21 Y176.715 E.01749
G1 X166.729 Y176.715 E.01749
G1 X161.66 Y171.646 E.2607
G1 X161.66 Y172.298 E.02368
G1 X166.077 Y176.715 E.22722
G1 X165.426 Y176.715 E.02368
G1 X161.66 Y172.949 E.19373
G1 X161.66 Y173.6 E.02368
G1 X164.775 Y176.715 E.16025
G1 X164.124 Y176.715 E.02368
G1 X161.66 Y174.251 E.12676
G1 X161.66 Y174.902 E.02368
G1 X163.473 Y176.715 E.09327
G1 X162.822 Y176.715 E.02368
G1 X161.66 Y175.553 E.05979
G1 X161.66 Y176.204 E.02368
G1 X162.377 Y176.921 E.03688
; WIPE_START
G1 X161.66 Y176.204 E-.38533
G1 X161.66 Y175.553 E-.24741
G1 X161.896 Y175.79 E-.12725
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X167.004 Y177.642 Z.6 F60000
G1 Z.2
G1 E.8 F1800
G1 F6300
M204 S500
G1 X175.507 Y186.145 E.43735
G1 X174.856 Y186.145 E.02368
G1 X167.21 Y178.499 E.39329
G1 X167.21 Y179.15 E.02368
G1 X174.205 Y186.145 E.3598
G1 X173.554 Y186.145 E.02368
G1 X167.21 Y179.801 E.32631
G1 X167.21 Y180.452 E.02368
G1 X172.903 Y186.145 E.29283
G1 X172.252 Y186.145 E.02368
G1 X167.21 Y181.103 E.25934
G1 X167.21 Y181.754 E.02368
G1 X171.601 Y186.145 E.22585
G1 X170.95 Y186.145 E.02368
G1 X167.21 Y182.405 E.19237
G1 X167.21 Y183.056 E.02368
G1 X170.299 Y186.145 E.15888
G1 X169.648 Y186.145 E.02368
G1 X167.21 Y183.707 E.12539
G1 X167.21 Y184.358 E.02368
G1 X169.495 Y186.644 E.11756
G1 X169.495 Y187.295 E.02368
G1 X167.21 Y185.01 E.11756
G1 X167.21 Y185.661 E.02368
G1 X169.495 Y187.946 E.11756
G1 X169.495 Y188.597 E.02368
G1 X167.21 Y186.312 E.11756
G1 X167.21 Y186.963 E.02368
G1 X169.495 Y189.249 E.11756
G1 X169.495 Y189.9 E.02368
G1 X167.21 Y187.614 E.11756
G1 X167.21 Y188.265 E.02368
G1 X169.495 Y190.551 E.11756
G1 X169.495 Y191.202 E.02368
G1 X167.21 Y188.916 E.11756
G1 X167.21 Y189.567 E.02368
G1 X169.495 Y191.853 E.11756
G1 X169.495 Y192.04 E.00682
G1 X169.032 Y192.04 E.01686
G1 X167.21 Y190.218 E.09372
G1 X167.21 Y190.869 E.02368
G1 X168.381 Y192.04 E.06023
G1 X167.73 Y192.04 E.02368
G1 X167.004 Y191.315 E.03732
; WIPE_START
G1 X167.73 Y192.04 E-.38998
G1 X168.381 Y192.04 E-.24741
G1 X168.153 Y191.812 E-.12261
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X174.866 Y188.181 Z.6 F60000
G1 X177.449 Y186.785 Z.6
G1 Z.2
G1 E.8 F1800
G1 F6300
M204 S500
G1 X187.74 Y197.076 E.5293
G1 X187.74 Y197.727 E.02368
G1 X177.655 Y187.641 E.51872
G1 X177.655 Y188.293 E.02368
G1 X181.402 Y192.04 E.19276
G1 X180.751 Y192.04 E.02368
G1 X177.655 Y188.944 E.15927
G1 X177.655 Y189.595 E.02368
G1 X180.1 Y192.04 E.12579
G1 X179.449 Y192.04 E.02368
G1 X177.655 Y190.246 E.0923
G1 X177.655 Y190.897 E.02368
G1 X178.798 Y192.04 E.05881
G1 X178.147 Y192.04 E.02368
G1 X177.449 Y191.342 E.0359
; WIPE_START
G1 X178.147 Y192.04 E-.37516
G1 X178.798 Y192.04 E-.24742
G1 X178.542 Y191.785 E-.13742
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X182.179 Y192.817 Z.6 F60000
G1 Z.2
G1 E.8 F1800
G1 F6300
M204 S500
G1 X187.74 Y198.378 E.28603
G1 X187.74 Y199.029 E.02368
G1 X182.385 Y193.674 E.27545
G1 X182.385 Y194.325 E.02368
M73 P37 R13
G1 X187.74 Y199.68 E.27545
G1 X187.74 Y200.267 E.02132
G2 X187.198 Y199.789 I-2.514 J2.308 E.02635
G1 X182.385 Y194.976 E.24754
G1 X182.385 Y195.627 E.02368
G1 X186.031 Y199.273 E.18752
G2 X185.295 Y199.189 I-.779 J3.547 E.02697
G1 X182.385 Y196.278 E.1497
G1 X182.385 Y196.929 E.02368
G1 X184.701 Y199.246 E.11914
G2 X184.189 Y199.384 I.612 J3.284 E.01933
G1 X182.385 Y197.58 E.09278
G1 X182.385 Y198.231 E.02368
G1 X183.735 Y199.581 E.06943
G2 X183.338 Y199.836 I1.094 J2.138 E.01716
G1 X182.385 Y198.882 E.04905
G1 X182.385 Y199.533 E.02368
G1 X182.985 Y200.133 E.03086
G2 X182.701 Y200.449 I3.877 J3.77 E.01543
G1 X182.51 Y200.31 E.00859
G1 X182.179 Y199.979 E.01704
M204 S6000
G1 X182.588 Y200.847 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.124587
G1 F3000
M204 S500
G1 X182.449 Y201.039 E.00153
; LINE_WIDTH: 0.165307
G1 X182.381 Y201.142 E.00119
; LINE_WIDTH: 0.204999
G2 X182.303 Y201.294 I.192 J.195 E.00222
; LINE_WIDTH: 0.175894
G1 X182.277 Y201.45 E.00167
; LINE_WIDTH: 0.127245
G1 X182.25 Y201.607 E.00106
; WIPE_START
G1 X182.277 Y201.45 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X182.275 Y203.391 Z.6 F60000
G1 Z.2
G1 E.8 F1800
; LINE_WIDTH: 0.115743
G1 F3000
M204 S500
G1 X182.255 Y203.423 E.00022
G1 X182.272 Y203.526 E.0006
; LINE_WIDTH: 0.155592
G1 X182.29 Y203.626 E.0009
; LINE_WIDTH: 0.190144
G1 X182.307 Y203.725 E.00118
; LINE_WIDTH: 0.208987
G1 X182.442 Y204.407 E.00911
M204 S6000
G1 X182.466 Y204.399 F60000
; LINE_WIDTH: 0.354116
G1 F3000
M204 S500
G1 X182.225 Y203.432 E.0245
; WIPE_START
G1 X182.466 Y204.399 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X187.373 Y204.808 Z.6 F60000
G1 Z.2
G1 E.8 F1800
; FEATURE: Bottom surface
; LINE_WIDTH: 0.52248
G1 F6300
M204 S500
G1 X187.74 Y205.176 E.01969
G1 X187.74 Y205.854 E.02569
G1 X187.14 Y205.253 E.03217
G3 X186.704 Y205.496 I-1.48 J-2.149 E.01892
G1 X187.74 Y206.532 E.05552
G1 X187.74 Y207.21 E.02569
G1 X186.212 Y205.682 E.08188
G3 X185.644 Y205.792 I-.817 J-2.682 E.02195
G1 X187.692 Y207.84 E.10971
G1 X187.014 Y207.84 E.02569
G1 X184.969 Y205.795 E.10956
G3 X184.049 Y205.554 I.32 J-3.09 E.03618
G1 X186.336 Y207.84 E.12251
G1 X185.658 Y207.84 E.02569
G1 X182.586 Y204.769 E.16453
G1 X182.385 Y204.82 E.00788
G1 X182.385 Y205.246 E.01613
G1 X184.979 Y207.84 E.13901
G1 X184.301 Y207.84 E.02569
G1 X182.385 Y205.924 E.10268
G1 X182.385 Y206.602 E.02569
G1 X183.623 Y207.84 E.06635
G1 X182.945 Y207.84 E.02569
G1 X182.179 Y207.074 E.04103
; WIPE_START
G1 X182.945 Y207.84 E-.41161
G1 X183.623 Y207.84 E-.25772
G1 X183.454 Y207.672 E-.09068
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X187.8 Y203.523 Z.6 F60000
G1 Z.2
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.519232
G1 F3000
M204 S500
G1 X188.114 Y203.345 E.01357
; LINE_WIDTH: 0.51273
G1 X188.131 Y203.205 E.00524
; LINE_WIDTH: 0.475751
G1 X188.15 Y203.043 E.00558
; LINE_WIDTH: 0.436463
G2 X188.17 Y202.749 I-6.208 J-.572 E.00915
; LINE_WIDTH: 0.412446
G2 X188.168 Y202.194 I-8.561 J-.235 E.01621
; LINE_WIDTH: 0.443002
G2 X188.146 Y201.92 I-5.696 J.303 E.00869
; LINE_WIDTH: 0.481203
G1 X188.13 Y201.786 E.00467
; LINE_WIDTH: 0.516223
G1 X188.112 Y201.644 E.00533
G1 X187.801 Y201.477 E.01323
; WIPE_START
G1 X188.112 Y201.644 E-.54166
G1 X188.13 Y201.786 E-.21834
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X181.997 Y197.243 Z.6 F60000
G1 X166.135 Y185.495 Z.6
G1 Z.2
G1 E.8 F1800
; LINE_WIDTH: 0.63171
G1 F3000
M204 S500
G1 X161.264 Y185.495 E.22656
; LINE_WIDTH: 0.653471
G1 X161.209 Y185.495 E.00266
; LINE_WIDTH: 0.697012
G1 X161.154 Y185.495 E.00285
; LINE_WIDTH: 0.740553
G1 X161.099 Y185.495 E.00304
; LINE_WIDTH: 0.784094
G1 X161.044 Y185.495 E.00323
; LINE_WIDTH: 0.827635
G1 X160.989 Y185.495 E.00342
; LINE_WIDTH: 0.828113
G1 X160.968 Y185.593 E.00623
; LINE_WIDTH: 0.785556
G1 X160.946 Y185.691 E.00589
; LINE_WIDTH: 0.722008
G1 X160.925 Y185.789 E.00539
G1 X160.925 Y193.114 E.39294
; WIPE_START
G1 X160.925 Y191.114 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X160.989 Y185.495 Z.6 F60000
G1 Z.2
G1 E.8 F1800
; LINE_WIDTH: 0.82812
G1 F3000
M204 S500
G1 X160.968 Y185.397 E.00623
; LINE_WIDTH: 0.78556
G1 X160.946 Y185.299 E.00589
; LINE_WIDTH: 0.722005
G1 X160.925 Y185.201 E.00539
G1 X160.925 Y177.79 E.39755
; WIPE_START
G1 X160.925 Y179.79 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X160.834 Y172.158 Z.6 F60000
G1 X160.787 Y168.236 Z.6
G1 Z.2
G1 E.8 F1800
; LINE_WIDTH: 0.44572
G1 F3000
M204 S500
G1 X160.787 Y159.565 E.2759
; WIPE_START
G1 X160.787 Y161.565 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X167.833 Y158.631 Z.6 F60000
G1 X174.582 Y155.82 Z.6
G1 Z.2
G1 E.8 F1800
; LINE_WIDTH: 0.16758
G1 F3000
M204 S500
G1 X176.503 Y155.82 E.01891
; WIPE_START
G1 X174.582 Y155.82 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X181.425 Y155.882 Z.6 F60000
G1 Z.2
G1 E.8 F1800
; LINE_WIDTH: 0.25758
G1 F3000
M204 S500
G1 X181.425 Y161.118 E.08877
; WIPE_START
G1 X181.425 Y159.118 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X184.499 Y152.132 Z.6 F60000
G1 X188.7 Y142.585 Z.6
G1 Z.2
G1 E.8 F1800
; LINE_WIDTH: 0.27172
G1 F3000
M204 S500
G1 X188.7 Y137.464 E.09255
; WIPE_START
G1 X188.7 Y139.464 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X188.7 Y134.585 Z.6 F60000
G1 Z.2
G1 E.8 F1800
G1 F3000
M204 S500
G1 X188.7 Y129.464 E.09255
; WIPE_START
G1 X188.7 Y131.464 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X181.094 Y130.828 Z.6 F60000
G1 X175.346 Y130.347 Z.6
G1 Z.2
G1 E.8 F1800
; FEATURE: Bottom surface
; LINE_WIDTH: 0.50647
G1 F6300
M204 S500
G1 X174.658 Y129.66 E.03561
G1 X174.003 Y129.66 E.024
G1 X175.14 Y130.797 E.0589
G1 X175.14 Y131.453 E.024
G1 X173.347 Y129.66 E.09285
G1 X172.692 Y129.66 E.024
G1 X175.14 Y132.108 E.1268
G1 X175.14 Y132.764 E.02401
G1 X172.036 Y129.66 E.16075
G1 X171.381 Y129.66 E.024
G1 X175.14 Y133.419 E.19469
G1 X175.14 Y134.075 E.024
G1 X170.72 Y129.66 E.22878
G1 X170.72 Y130.31 E.0238
G1 X175.346 Y134.936 E.23958
; WIPE_START
G1 X173.932 Y133.522 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X181.482 Y134.637 Z.6 F60000
G1 X187.008 Y135.454 Z.6
G1 Z.2
G1 E.8 F1800
G1 F6300
M204 S500
G1 X187.74 Y136.186 E.03791
G1 X187.74 Y136.39 E.00749
G1 X187.289 Y136.39 E.01652
G1 X186.558 Y135.66 E.03784
G1 X185.903 Y135.66 E.024
G1 X186.634 Y136.39 E.03784
G1 X185.978 Y136.39 E.024
G1 X185.247 Y135.66 E.03784
G1 X184.592 Y135.66 E.024
G1 X185.323 Y136.39 E.03784
G1 X184.667 Y136.39 E.024
G1 X183.936 Y135.66 E.03784
G1 X183.281 Y135.66 E.024
G1 X184.011 Y136.39 E.03784
G1 X183.356 Y136.39 E.024
G1 X182.625 Y135.66 E.03784
G1 X181.97 Y135.66 E.024
G1 X182.7 Y136.39 E.03784
G1 X182.045 Y136.39 E.024
G1 X181.314 Y135.66 E.03784
G1 X180.658 Y135.66 E.024
G1 X181.389 Y136.39 E.03784
G1 X180.734 Y136.39 E.024
G1 X180.003 Y135.66 E.03784
G1 X179.347 Y135.66 E.024
G1 X180.078 Y136.39 E.03784
G1 X179.423 Y136.39 E.024
G1 X178.692 Y135.66 E.03784
G1 X178.036 Y135.66 E.024
G1 X178.767 Y136.39 E.03784
G1 X178.111 Y136.39 E.024
G1 X177.381 Y135.66 E.03784
G1 X176.725 Y135.66 E.024
G1 X177.456 Y136.39 E.03784
G1 X176.8 Y136.39 E.024
G1 X175.864 Y135.454 E.04849
; WIPE_START
G1 X176.8 Y136.39 E-.50325
G1 X177.456 Y136.39 E-.24911
G1 X177.442 Y136.376 E-.00763
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X176.35 Y136.596 Z.6 F60000
G1 Z.2
G1 E.8 F1800
G1 F6300
M204 S500
G1 X170.72 Y130.965 E.29159
G1 X170.72 Y131.621 E.024
G1 X175.489 Y136.39 E.24699
G1 X175.14 Y136.39 E.01277
G1 X175.14 Y136.697 E.01123
G1 X170.72 Y132.276 E.22893
M73 P38 R13
G1 X170.72 Y132.932 E.024
G1 X175.14 Y137.353 E.22893
G1 X175.14 Y138.008 E.024
G1 X170.72 Y133.587 E.22893
G1 X170.72 Y133.67 E.00301
G1 X170.146 Y133.67 E.021
G1 X175.14 Y138.664 E.25862
G1 X175.14 Y139.319 E.024
G1 X169.491 Y133.67 E.29257
G1 X168.835 Y133.67 E.024
G1 X175.14 Y139.975 E.32652
G1 X175.14 Y140.63 E.024
G1 X168.18 Y133.67 E.36046
G1 X168.11 Y133.67 E.00256
G1 X168.11 Y134.255 E.02144
G1 X175.14 Y141.286 E.36408
G1 X175.14 Y141.942 E.024
G1 X168.11 Y134.911 E.36408
G1 X168.11 Y135.566 E.024
G1 X175.346 Y142.803 E.37474
; WIPE_START
G1 X173.932 Y141.389 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X181.409 Y142.92 Z.6 F60000
G1 X187.946 Y144.258 Z.6
G1 Z.2
G1 E.8 F1800
G1 F6300
M204 S500
G1 X187.347 Y143.66 E.031
G1 X186.692 Y143.66 E.024
G1 X187.74 Y144.708 E.0543
G1 X187.74 Y145.364 E.024
G1 X186.036 Y143.66 E.08825
G1 X185.381 Y143.66 E.024
G1 X187.476 Y145.755 E.10853
G1 X186.821 Y145.755 E.024
G1 X184.725 Y143.66 E.10853
G1 X184.07 Y143.66 E.024
G1 X186.165 Y145.755 E.10853
G1 X185.51 Y145.755 E.024
G1 X183.414 Y143.66 E.10853
G1 X182.758 Y143.66 E.024
G1 X184.854 Y145.755 E.10853
G1 X184.199 Y145.755 E.024
G1 X182.103 Y143.66 E.10853
G1 X181.447 Y143.66 E.024
G1 X183.543 Y145.755 E.10853
G1 X182.888 Y145.755 E.024
G1 X180.792 Y143.66 E.10853
G1 X180.136 Y143.66 E.024
G1 X182.232 Y145.755 E.10853
G1 X181.576 Y145.755 E.024
G1 X179.481 Y143.66 E.10853
G1 X178.825 Y143.66 E.024
G1 X180.921 Y145.755 E.10853
G1 X180.915 Y146.405 E.02381
G1 X178.17 Y143.66 E.14219
G1 X177.514 Y143.66 E.024
G1 X180.915 Y147.061 E.17614
G1 X180.915 Y147.717 E.024
G1 X176.858 Y143.66 E.21009
G1 X176.203 Y143.66 E.024
G1 X180.915 Y148.372 E.24404
G1 X180.915 Y149.028 E.024
G1 X168.11 Y136.222 E.66314
G1 X168.11 Y136.877 E.024
G1 X180.915 Y149.683 E.66314
G1 X180.915 Y150.339 E.024
G1 X168.11 Y137.533 E.66314
G1 X168.11 Y138.189 E.024
G1 X180.915 Y150.994 E.66314
G1 X180.915 Y151.65 E.024
G1 X168.11 Y138.844 E.66314
G1 X168.11 Y139.5 E.024
G1 X180.915 Y152.306 E.66314
G1 X180.915 Y152.961 E.024
G1 X168.11 Y140.155 E.66314
G1 X168.11 Y140.811 E.024
G1 X180.915 Y153.617 E.66314
G1 X180.915 Y154.272 E.024
G1 X177.12 Y150.476 E.19656
G1 X177.12 Y151.132 E.024
G1 X180.915 Y154.928 E.19656
G1 X180.915 Y155.265 E.01236
G1 X180.597 Y155.265 E.01164
G1 X177.12 Y151.788 E.1801
G1 X177.12 Y152.443 E.024
G1 X179.942 Y155.265 E.14615
G1 X179.286 Y155.265 E.024
G1 X177.12 Y153.099 E.1122
G1 X177.12 Y153.754 E.024
G1 X178.631 Y155.265 E.07825
G1 X177.975 Y155.265 E.024
G1 X177.12 Y154.41 E.04431
G1 X177.12 Y155.065 E.024
G1 X177.525 Y155.471 E.02101
; WIPE_START
G1 X177.12 Y155.065 E-.21803
M73 P38 R12
G1 X177.12 Y154.41 E-.24911
G1 X177.665 Y154.955 E-.29285
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X176.464 Y149.821 Z.6 F60000
G1 Z.2
G1 E.8 F1800
G1 F6300
M204 S500
G1 X168.11 Y141.466 E.43264
G1 X168.11 Y142.122 E.024
G1 X175.603 Y149.615 E.38804
G1 X174.947 Y149.615 E.024
G1 X168.11 Y142.778 E.3541
G1 X168.11 Y143.433 E.024
G1 X174.292 Y149.615 E.32015
G1 X173.636 Y149.615 E.024
G1 X167.571 Y143.55 E.31411
G1 X167.21 Y143.55 E.01322
G1 X167.21 Y143.844 E.01079
G1 X172.981 Y149.615 E.29886
G1 X172.325 Y149.615 E.024
G1 X167.21 Y144.5 E.26491
G1 X167.21 Y145.155 E.024
G1 X171.67 Y149.615 E.23096
G1 X171.014 Y149.615 E.024
M73 P39 R12
G1 X167.21 Y145.811 E.19701
G1 X167.21 Y146.466 E.024
G1 X170.359 Y149.615 E.16307
G1 X169.703 Y149.615 E.024
G1 X167.21 Y147.122 E.12912
G1 X167.21 Y147.778 E.024
G1 X169.047 Y149.615 E.09517
G1 X168.392 Y149.615 E.024
G1 X167.21 Y148.433 E.06122
G1 X167.21 Y149.089 E.024
G1 X167.942 Y149.821 E.03793
; WIPE_START
G1 X167.21 Y149.089 E-.39359
G1 X167.21 Y148.433 E-.24911
G1 X167.428 Y148.651 E-.1173
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X167.559 Y141.02 Z.6 F60000
G1 X167.9 Y121.09 Z.6
G1 Z.2
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.5
G1 F3000
M204 S500
G1 X168.3 Y121.09 E.01444
G1 X168.3 Y122.29 E.04333
G1 X159.9 Y122.29 E.30329
G1 X159.9 Y110.4 E.4293
G1 X167.9 Y110.4 E.28885
G1 X167.9 Y121.03 E.38381
M204 S6000
G1 X167.443 Y121.09 F60000
; FEATURE: Inner wall
G1 F3000
M204 S500
G1 X167.443 Y121.547 E.0165
G1 X167.843 Y121.547 E.01444
G1 X167.843 Y121.833 E.01032
G1 X160.357 Y121.833 E.27028
G1 X160.357 Y110.857 E.39629
G1 X167.443 Y110.857 E.25584
G1 X167.443 Y121.03 E.3673
M204 S6000
G1 X166.986 Y121.09 F60000
G1 F3000
M204 S500
G1 X166.986 Y121.376 E.01032
G1 X160.814 Y121.376 E.22284
G1 X160.814 Y111.314 E.36329
G1 X166.986 Y111.314 E.22284
G1 X166.986 Y121.03 E.3508
; WIPE_START
G1 X166.986 Y121.376 E-.13143
G1 X165.332 Y121.376 E-.62857
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X165.121 Y113.764 Z.6 F60000
G1 Z.2
G1 E.8 F1800
G1 F3000
M204 S500
G1 X164.913 Y113.692 E.00795
G2 X161.474 Y115.208 I-.808 J2.824 E.14722
G1 X161.271 Y115.154 E.0076
G1 X161.271 Y111.771 E.12213
G1 X166.529 Y111.771 E.18983
G1 X166.529 Y114.834 E.11058
G2 X165.192 Y113.796 I-2.627 J2.003 E.0618
G1 X165.176 Y113.788 E.00065
; WIPE_START
G1 X164.913 Y113.692 E-.10638
G1 X164.65 Y113.629 E-.10272
G1 X164.36 Y113.588 E-.1114
G1 X164.083 Y113.577 E-.10505
G1 X163.792 Y113.593 E-.11097
G1 X163.499 Y113.639 E-.11266
G1 X163.238 Y113.707 E-.10262
G1 X163.217 Y113.714 E-.0082
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X164.691 Y115.068 Z.6 F60000
G1 Z.2
G1 E.8 F1800
; FEATURE: Outer wall
G1 F3000
M204 S500
G1 X164.96 Y115.211 E.011
G3 X163.937 Y114.958 I-.861 J1.288 E.31272
G1 X164.092 Y114.95 E.00562
G3 X164.636 Y115.046 I.007 J1.55 E.02003
M204 S6000
G1 X164.904 Y114.665 F60000
; FEATURE: Inner wall
G1 F3000
M204 S500
G1 X165.213 Y114.83 E.01265
G3 X163.889 Y114.503 I-1.115 J1.669 E.40503
G1 X164.089 Y114.492 E.00726
G3 X164.851 Y114.638 I.009 J2.007 E.02817
M204 S6000
G1 X164.927 Y114.185 F60000
G1 F3000
M204 S500
G1 X165.023 Y114.215 E.00365
G3 X163.84 Y114.048 I-.925 J2.284 E.51549
G1 X164.086 Y114.034 E.0089
G3 X164.564 Y114.079 I.011 J2.464 E.01736
G1 X164.869 Y114.168 E.01146
; WIPE_START
G1 X165.023 Y114.215 E-.06116
G1 X165.256 Y114.322 E-.0976
G1 X165.467 Y114.448 E-.09346
G1 X165.844 Y114.756 E-.18473
G1 X166.016 Y114.948 E-.09789
G1 X166.168 Y115.157 E-.09827
G1 X166.294 Y115.375 E-.09575
G1 X166.324 Y115.451 E-.03114
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X166.529 Y118.166 Z.6 F60000
G1 Z.2
G1 E.8 F1800
G1 F3000
M204 S500
G1 X166.529 Y120.919 E.09939
G1 X161.271 Y120.919 E.18983
G1 X161.271 Y117.851 E.11077
G1 X161.472 Y117.795 E.00753
G1 X161.674 Y118.13 E.01412
G2 X166.172 Y118.562 I2.427 J-1.632 E.18649
G1 X166.489 Y118.211 E.01706
M204 S6000
G1 X166.44 Y117.882 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.116766
G1 F3000
M204 S500
G1 X166.536 Y117.751 E.00095
; LINE_WIDTH: 0.150058
G1 X166.607 Y117.643 E.00109
; LINE_WIDTH: 0.188679
G1 X166.675 Y117.539 E.00144
; LINE_WIDTH: 0.182913
G1 X166.699 Y117.395 E.00162
; LINE_WIDTH: 0.136287
G1 X166.722 Y117.26 E.001
; LINE_WIDTH: 0.10814
G1 X166.731 Y117.185 E.00039
; WIPE_START
G1 X166.722 Y117.26 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X166.731 Y115.816 Z.6 F60000
G1 Z.2
G1 E.8 F1800
; LINE_WIDTH: 0.109404
G1 F3000
M204 S500
G1 X166.721 Y115.731 E.00045
; LINE_WIDTH: 0.138356
G1 X166.699 Y115.6 E.001
; LINE_WIDTH: 0.183853
G1 X166.675 Y115.461 E.00157
; LINE_WIDTH: 0.188741
G1 X166.606 Y115.356 E.00144
; LINE_WIDTH: 0.150036
G1 X166.535 Y115.248 E.00109
; LINE_WIDTH: 0.116747
G1 X166.44 Y115.117 E.00095
; WIPE_START
G1 X166.535 Y115.248 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X165.328 Y111.954 Z.6 F60000
G1 Z.2
G1 E.8 F1800
; FEATURE: Bottom surface
; LINE_WIDTH: 0.54457
G1 F6300
M204 S500
G1 X166.14 Y112.767 E.04555
G1 X166.14 Y113.476 E.02811
G1 X164.824 Y112.16 E.07378
G1 X164.114 Y112.16 E.02811
G1 X165.42 Y113.466 E.0732
G2 X164.455 Y113.209 I-1.256 J2.782 E.03978
G1 X163.405 Y112.16 E.05883
G1 X162.695 Y112.16 E.02811
G1 X163.743 Y113.207 E.05871
G2 X163.154 Y113.327 I.329 J3.119 E.02387
G1 X161.986 Y112.16 E.06544
G1 X161.66 Y112.16 E.01293
G1 X161.66 Y112.543 E.01518
G1 X162.645 Y113.528 E.05524
G2 X162.198 Y113.791 I1.66 J3.34 E.02056
G1 X161.454 Y113.046 E.04172
; WIPE_START
G1 X162.198 Y113.791 E-.40008
G1 X162.645 Y113.528 E-.19697
G1 X162.342 Y113.225 E-.16295
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X161.755 Y114.359 Z.6 F60000
G1 Z.2
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.118611
G1 F3000
M204 S500
G1 X161.612 Y114.49 E.00116
; LINE_WIDTH: 0.14633
G1 X161.5 Y114.604 E.00131
M204 S6000
G1 X161.328 Y115.406 F60000
; LINE_WIDTH: 0.528529
G1 F3000
M204 S500
G2 X161.28 Y115.696 I6.022 J1.145 E.01127
; LINE_WIDTH: 0.50422
G1 X161.266 Y115.817 E.00444
; LINE_WIDTH: 0.473492
G1 X161.25 Y115.956 E.00477
; LINE_WIDTH: 0.438543
G2 X161.231 Y116.215 I5.397 J.522 E.00813
; LINE_WIDTH: 0.412426
G2 X161.231 Y116.776 I8.1 J.286 E.01637
; LINE_WIDTH: 0.439876
G2 X161.252 Y117.066 I5.672 J-.267 E.0091
; LINE_WIDTH: 0.478423
G1 X161.269 Y117.204 E.0048
; LINE_WIDTH: 0.519612
G1 X161.288 Y117.355 E.00573
G1 X161.601 Y117.522 E.01337
; WIPE_START
G1 X161.288 Y117.355 E-.53211
G1 X161.269 Y117.204 E-.22789
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X166.346 Y119.64 Z.6 F60000
G1 Z.2
G1 E.8 F1800
; FEATURE: Bottom surface
; LINE_WIDTH: 0.54484
G1 F6300
M204 S500
G1 X165.952 Y119.247 E.02209
G3 X165.495 Y119.499 I-1.457 J-2.091 E.02073
G1 X166.14 Y120.145 E.03617
G1 X166.14 Y120.53 E.0153
G1 X165.816 Y120.53 E.01284
G1 X164.977 Y119.691 E.04708
G3 X164.375 Y119.799 I-.996 J-3.802 E.02425
G1 X165.107 Y120.53 E.041
G1 X164.397 Y120.53 E.02814
G1 X163.643 Y119.777 E.04225
G3 X162.613 Y119.456 I.367 J-2.996 E.043
G1 X163.687 Y120.53 E.06022
G1 X162.977 Y120.53 E.02814
G1 X161.66 Y119.213 E.07387
G1 X161.66 Y119.923 E.02814
G1 X162.473 Y120.736 E.04561
; CHANGE_LAYER
; Z_HEIGHT: 0.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F6300
G1 X161.66 Y119.923 E-.43711
G1 X161.66 Y119.213 E-.26973
G1 X161.759 Y119.312 E-.05317
; WIPE_END
G1 E-.03999 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 2/37
; update layer progress
M73 L2
M991 S0 P1 ;notify layer change

; open powerlost recovery
M1003 S1
; OBJECT_ID: 15
M204 S10000
G17
G3 Z.6 I-.88 J.841 P1  F60000
G1 X188.525 Y147.313 Z.6
G1 Z.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X188.917 Y147.313 E.01261
G1 X188.917 Y181.697 E1.10567
G1 X182.473 Y181.697 E.20722
G1 X182.473 Y147.313 E1.10567
G1 X188.465 Y147.313 E.19268
M204 S250
G1 X188.525 Y147.705 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X188.525 Y181.305 E1.00083
G1 X182.865 Y181.305 E.16859
G1 X182.865 Y147.705 E1.00083
G1 X188.465 Y147.705 E.1668
; WIPE_START
M204 S8000
G1 X188.469 Y149.705 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X181.081 Y151.625 Z.8 F60000
G1 X167.23 Y155.224 Z.8
G1 Z.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
M73 P40 R12
G1 F8843.478
M204 S8000
G1 X166.431 Y155.224 E.0257
G1 X166.431 Y150.766 E.14336
G1 X175.969 Y150.766 E.30672
G1 X175.969 Y155.224 E.14336
G1 X167.29 Y155.224 E.27909
M204 S10000
G1 X167.23 Y154.817 F60000
G1 F8843.478
M204 S8000
G1 X166.838 Y154.817 E.01261
G1 X166.838 Y151.173 E.11718
G1 X175.562 Y151.173 E.28054
G1 X175.562 Y154.817 E.11718
G1 X167.29 Y154.817 E.266
M204 S250
G1 X167.23 Y154.425 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X167.23 Y151.565 E.08519
G1 X175.17 Y151.565 E.23651
G1 X175.17 Y154.425 E.08519
G1 X167.29 Y154.425 E.23472
; WIPE_START
M204 S8000
G1 X167.248 Y152.425 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X166.194 Y144.866 Z.8 F60000
G1 X166.059 Y143.9 Z.8
G1 Z.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X166.059 Y152.899 E.28938
G1 X161.341 Y152.899 E.15172
G1 X161.341 Y143.101 E.31508
G1 X166.059 Y143.101 E.15172
G1 X166.059 Y143.84 E.02377
M204 S10000
G1 X165.652 Y143.9 F60000
G1 F8843.478
M204 S8000
G1 X165.652 Y152.492 E.27629
G1 X161.748 Y152.492 E.12554
G1 X161.748 Y143.508 E.2889
G1 X165.652 Y143.508 E.12554
G1 X165.652 Y143.84 E.01068
M204 S250
G1 X165.26 Y143.9 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X165.26 Y152.1 E.24425
G1 X162.14 Y152.1 E.09293
G1 X162.14 Y143.9 E.24425
G1 X165.2 Y143.9 E.09115
; WIPE_START
M204 S8000
G1 X165.215 Y145.9 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X161.834 Y142.694 Z.8 F60000
G1 Z.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X160.916 Y142.694 E.02951
G1 X160.916 Y132.926 E.31409
G1 X161.834 Y132.926 E.02951
G1 X161.834 Y142.634 E.31216
; WIPE_START
G1 X160.916 Y142.694 E-.34943
G1 X160.916 Y141.613 E-.41057
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X168.548 Y141.661 Z.8 F60000
G1 X176.291 Y141.71 Z.8
G1 Z.4
G1 E.8 F1800
G1 F8843.478
M204 S8000
G1 X176.291 Y137.541 E.13406
G1 X188.509 Y137.541 E.3929
G1 X188.509 Y142.509 E.15976
G1 X176.291 Y142.509 E.3929
G1 X176.291 Y141.77 E.02377
M204 S10000
G1 X176.698 Y141.71 F60000
G1 F8843.478
M204 S8000
G1 X176.698 Y137.948 E.12097
G1 X188.102 Y137.948 E.36672
G1 X188.102 Y142.102 E.13358
G1 X176.698 Y142.102 E.36672
G1 X176.698 Y141.77 E.01068
M204 S250
G1 X177.09 Y141.71 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X177.09 Y138.34 E.10038
G1 X187.71 Y138.34 E.31633
G1 X187.71 Y141.71 E.10038
G1 X177.15 Y141.71 E.31455
; WIPE_START
M204 S8000
G1 X177.114 Y139.71 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X176 Y147.261 Z.8 F60000
G1 X174.709 Y156.009 Z.8
G1 Z.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X181.191 Y156.009 E.20845
G1 X181.191 Y160.991 E.16022
G1 X174.709 Y160.991 E.20845
G1 X174.709 Y156.069 E.15829
; WIPE_START
G1 X176.709 Y156.05 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X180.784 Y159.785 Z.8 F60000
G1 Z.4
G1 E.8 F1800
G1 F8843.478
M204 S8000
G1 X180.784 Y160.584 E.0257
G1 X175.116 Y160.584 E.18227
G1 X175.116 Y156.416 E.13404
G1 X180.784 Y156.416 E.18227
G1 X180.784 Y159.725 E.10641
M204 S10000
G1 X180.377 Y159.785 F60000
G1 F8843.478
M204 S8000
G1 X180.377 Y160.177 E.01261
G1 X175.523 Y160.177 E.15609
G1 X175.523 Y156.823 E.10786
G1 X180.377 Y156.823 E.15609
G1 X180.377 Y159.725 E.09332
M204 S250
G1 X179.985 Y159.785 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X175.915 Y159.785 E.12123
G1 X175.915 Y157.215 E.07655
G1 X179.985 Y157.215 E.12123
G1 X179.985 Y159.725 E.07476
; WIPE_START
M204 S8000
G1 X177.985 Y159.754 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X179.055 Y167.312 Z.8 F60000
G1 X183.748 Y200.465 Z.8
G1 Z.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X184.056 Y200.253 E.01202
G3 X185.026 Y199.947 I1.243 J2.245 E.03295
G1 X185.269 Y199.932 E.00783
G3 X183.645 Y200.536 I.029 J2.566 E.46167
G1 X183.699 Y200.499 E.00208
M204 S10000
G1 X183.978 Y200.799 F60000
G1 F8843.478
M204 S8000
G1 X184.253 Y200.61 E.01073
G3 X185.07 Y200.352 I1.046 J1.889 E.02774
G1 X185.274 Y200.34 E.00656
G3 X183.909 Y200.847 I.025 J2.159 E.38843
G1 X183.929 Y200.833 E.00079
M204 S10000
G1 X184.209 Y201.133 F60000
G1 F8843.478
M204 S8000
G1 X184.451 Y200.967 E.00945
G3 X185.114 Y200.757 I.849 J1.532 E.02253
G1 X185.278 Y200.747 E.00528
G3 X184.16 Y201.168 I.021 J1.752 E.31469
M204 S250
G1 X184.43 Y201.455 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X184.641 Y201.31 E.00761
G3 X185.157 Y201.147 I.659 J1.189 E.01623
G1 X185.283 Y201.14 E.00376
G3 X184.384 Y201.494 I.017 J1.359 E.225
; WIPE_START
M204 S8000
G1 X184.641 Y201.31 E-.1198
G1 X184.881 Y201.206 E-.09959
G1 X185.157 Y201.147 E-.10712
G1 X185.283 Y201.14 E-.04793
G1 X185.559 Y201.165 E-.10547
G1 X185.809 Y201.239 E-.09894
G1 X186.041 Y201.359 E-.09936
G1 X186.209 Y201.493 E-.08179
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X186.381 Y193.863 Z.8 F60000
G1 X187.71 Y134.916 Z.8
G1 Z.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X188.484 Y134.916 E.02488
G1 X188.484 Y137.134 E.07131
G1 X175.884 Y137.134 E.40517
G1 X175.884 Y142.916 E.18594
G1 X188.484 Y142.916 E.40517
G1 X188.484 Y146.499 E.1152
G1 X181.659 Y146.499 E.21947
G1 X181.659 Y182.511 E1.15803
G1 X188.484 Y182.511 E.21947
G1 X188.484 Y208.584 E.8384
G1 X181.641 Y208.584 E.22003
G1 X181.641 Y192.784 E.50807
G1 X176.911 Y192.784 E.1521
G1 X176.911 Y186.889 E.18956
G1 X170.239 Y186.889 E.21456
G1 X170.239 Y192.784 E.18956
G1 X166.466 Y192.784 E.12131
G1 X166.466 Y177.459 E.4928
G1 X160.916 Y177.459 E.17847
G1 X160.916 Y168.566 E.28595
G1 X170.731 Y168.566 E.31561
G1 X170.731 Y159.234 E.3001
G1 X160.916 Y159.234 E.31561
G1 X160.916 Y153.306 E.19061
G1 X166.024 Y153.306 E.16424
G1 X166.024 Y155.631 E.07476
G1 X176.376 Y155.631 E.3329
G1 X176.376 Y150.359 E.16954
G1 X166.466 Y150.359 E.31867
G1 X166.466 Y142.806 E.24286
G1 X167.366 Y142.806 E.02894
G1 X167.366 Y132.926 E.3177
G1 X169.976 Y132.926 E.08393
G1 X169.976 Y128.916 E.12895
G1 X175.884 Y128.916 E.18997
G1 X175.884 Y134.916 E.19294
G1 X187.65 Y134.916 E.37836
; WIPE_START
G1 X188.484 Y134.916 E-.31685
G1 X188.484 Y136.082 E-.44315
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X187.71 Y129.541 Z.8 F60000
G1 Z.4
G1 E.8 F1800
G1 F8843.478
M204 S8000
G1 X188.509 Y129.541 E.0257
G1 X188.509 Y134.509 E.15976
G1 X176.291 Y134.509 E.3929
G1 X176.291 Y129.541 E.15976
G1 X187.65 Y129.541 E.36527
M204 S10000
G1 X187.71 Y129.948 F60000
G1 F8843.478
M204 S8000
G1 X188.102 Y129.948 E.01261
G1 X188.102 Y134.102 E.13358
G1 X176.698 Y134.102 E.36672
G1 X176.698 Y129.948 E.13358
G1 X187.65 Y129.948 E.35218
M204 S250
G1 X187.71 Y130.34 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X187.71 Y133.71 E.10038
G1 X177.09 Y133.71 E.31633
G1 X177.09 Y130.34 E.10038
G1 X187.65 Y130.34 E.31455
; WIPE_START
M204 S8000
G1 X187.686 Y132.34 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X184.295 Y139.178 Z.8 F60000
G1 X170.324 Y167.36 Z.8
G1 Z.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X170.324 Y168.159 E.0257
G1 X161.065 Y168.159 E.29774
G1 X161.065 Y159.641 E.27392
G1 X170.324 Y159.641 E.29774
G1 X170.324 Y167.3 E.24629
M204 S10000
G1 X169.917 Y167.36 F60000
G1 F8843.478
M204 S8000
G1 X169.917 Y167.752 E.01261
G1 X161.472 Y167.752 E.27156
G1 X161.472 Y160.048 E.24774
G1 X169.917 Y160.048 E.27156
G1 X169.917 Y167.3 E.2332
M204 S250
G1 X169.525 Y167.36 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X161.864 Y167.36 E.22819
G1 X161.864 Y160.44 E.20612
G1 X169.525 Y160.44 E.22819
G1 X169.525 Y167.3 E.20434
; WIPE_START
M204 S8000
G1 X167.525 Y167.316 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X166.87 Y174.92 Z.8 F60000
G1 X166.059 Y184.325 Z.8
G1 Z.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X166.059 Y185.124 E.0257
G1 X161.341 Y185.124 E.15172
G1 X161.341 Y177.866 E.2334
G1 X166.059 Y177.866 E.15172
G1 X166.059 Y184.265 E.20577
M204 S10000
G1 X165.652 Y184.325 F60000
G1 F8843.478
M204 S8000
G1 X165.652 Y184.717 E.01261
G1 X161.748 Y184.717 E.12554
G1 X161.748 Y178.273 E.20722
G1 X165.652 Y178.273 E.12554
G1 X165.652 Y184.265 E.19268
M204 S250
G1 X165.26 Y184.325 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X162.14 Y184.325 E.09293
G1 X162.14 Y178.665 E.16859
G1 X165.26 Y178.665 E.09293
G1 X165.26 Y184.265 E.1668
; WIPE_START
M204 S8000
G1 X163.26 Y184.303 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X167.533 Y177.979 Z.8 F60000
G1 X188.525 Y146.906 Z.8
G1 Z.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X182.066 Y146.906 E.2077
G1 X182.066 Y182.104 E1.13185
G1 X188.891 Y182.104 E.21947
G1 X188.891 Y208.991 E.86458
G1 X181.234 Y208.991 E.24621
G1 X181.234 Y193.191 E.50807
G1 X176.504 Y193.191 E.1521
G1 X176.504 Y187.296 E.18956
G1 X170.646 Y187.296 E.18838
G1 X170.646 Y193.191 E.18956
M73 P41 R12
G1 X166.059 Y193.191 E.14749
G1 X166.059 Y185.866 E.23555
G1 X161.341 Y185.866 E.15172
G1 X161.341 Y193.191 E.23555
G1 X160.509 Y193.191 E.02675
G1 X160.509 Y132.519 E1.95098
G1 X162.241 Y132.519 E.05569
G1 X162.241 Y142.399 E.3177
G1 X166.959 Y142.399 E.15172
G1 X166.959 Y132.519 E.3177
G1 X169.569 Y132.519 E.08393
G1 X169.569 Y128.509 E.12895
G1 X188.891 Y128.509 E.62132
G1 X188.891 Y146.906 E.59157
G1 X188.585 Y146.906 E.00984
; WIPE_START
G1 X186.585 Y146.906 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X179.164 Y145.121 Z.8 F60000
G1 X166.16 Y141.992 Z.8
G1 Z.4
G1 E.8 F1800
G1 F8843.478
M204 S8000
G1 X162.648 Y141.992 E.11294
G1 X162.648 Y133.008 E.2889
G1 X166.552 Y133.008 E.12554
G1 X166.552 Y141.992 E.2889
G1 X166.22 Y141.992 E.01068
M204 S250
G1 X166.16 Y141.6 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X163.04 Y141.6 E.09293
G1 X163.04 Y133.4 E.24425
G1 X166.16 Y133.4 E.09293
G1 X166.16 Y141.54 E.24246
; WIPE_START
M204 S8000
G1 X164.16 Y141.578 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X163.798 Y149.202 Z.8 F60000
G1 X161.748 Y192.325 Z.8
G1 Z.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X161.748 Y186.273 E.19461
G1 X165.652 Y186.273 E.12554
G1 X165.652 Y192.717 E.20722
G1 X161.748 Y192.717 E.12554
G1 X161.748 Y192.385 E.01068
M204 S250
G1 X162.14 Y192.325 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X162.14 Y186.665 E.16859
G1 X165.26 Y186.665 E.09293
G1 X165.26 Y192.325 E.16859
G1 X162.2 Y192.325 E.09115
; WIPE_START
M204 S8000
G1 X162.179 Y190.325 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X169.672 Y188.873 Z.8 F60000
G1 X175.705 Y187.703 Z.8
G1 Z.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X176.097 Y187.703 E.01261
G1 X176.097 Y192.697 E.16059
G1 X171.053 Y192.697 E.1622
G1 X171.053 Y187.703 E.16059
G1 X175.645 Y187.703 E.14766
M204 S250
G1 X175.705 Y188.095 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X175.705 Y192.305 E.1254
G1 X171.445 Y192.305 E.12689
G1 X171.445 Y188.095 E.1254
G1 X175.645 Y188.095 E.1251
; WIPE_START
M204 S8000
G1 X175.673 Y190.095 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X174.822 Y182.51 Z.8 F60000
G1 X169.162 Y132.112 Z.8
G1 Z.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X169.162 Y128.102 E.12895
G1 X189.298 Y128.102 E.6475
G1 X189.298 Y146.502 E.59168
G1 X189.898 Y146.502 E.01929
G1 X189.898 Y182.498 E1.1575
G1 X189.298 Y182.498 E.01929
G1 X189.298 Y209.398 E.86501
G1 X180.827 Y209.398 E.27239
G1 X180.827 Y193.598 E.50807
G1 X160.102 Y193.598 E.66644
G1 X160.102 Y132.112 E1.97716
G1 X169.102 Y132.112 E.28941
M204 S250
G1 X168.77 Y131.72 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X168.77 Y127.71 E.11944
G1 X189.69 Y127.71 E.62314
G1 X189.69 Y146.11 E.54807
G1 X190.29 Y146.11 E.01787
G1 X190.29 Y182.89 E1.09555
G1 X189.69 Y182.89 E.01787
G1 X189.69 Y209.79 E.80126
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

G1 X180.435 Y209.79 E.27568
G1 X180.435 Y193.99 E.47063
G1 X159.71 Y193.99 E.61733
G1 X159.71 Y131.72 E1.85481
G1 X168.71 Y131.72 E.26808
; WIPE_START
M204 S8000
G1 X168.74 Y129.72 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X167.965 Y133.09 Z.8 F60000
G1 Z.4
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.4213
G1 F9514.245
M204 S8000
G1 X167.699 Y133.356 E.01124
G1 X167.699 Y133.891 E.01599
G1 X168.331 Y133.259 E.02668
G1 X168.866 Y133.259 E.01599
G1 X167.699 Y134.426 E.0493
G1 X167.699 Y134.961 E.01599
G1 X169.401 Y133.259 E.07192
G1 X169.936 Y133.259 E.01599
G1 X167.699 Y135.496 E.09454
G1 X167.699 Y136.031 E.01599
G1 X174.481 Y129.249 E.28666
G1 X175.016 Y129.249 E.01599
G1 X167.699 Y136.566 E.30928
G1 X167.699 Y137.101 E.01599
G1 X175.551 Y129.25 E.33187
G1 X175.551 Y129.785 E.01599
G1 X167.699 Y137.636 E.33187
G1 X167.699 Y138.172 E.01599
G1 X175.551 Y130.32 E.33187
G1 X175.551 Y130.855 E.01599
G1 X167.699 Y138.707 E.33187
G1 X167.699 Y139.242 E.01599
G1 X175.551 Y131.39 E.33187
G1 X175.551 Y131.926 E.01599
G1 X167.699 Y139.777 E.33187
G1 X167.699 Y140.312 E.01599
G1 X175.551 Y132.461 E.33187
G1 X175.551 Y132.996 E.01599
G1 X167.699 Y140.847 E.33187
G1 X167.699 Y141.382 E.01599
G1 X175.551 Y133.531 E.33187
G1 X175.551 Y134.066 E.01599
G1 X167.699 Y141.917 E.33187
G1 X167.699 Y142.452 E.01599
G1 X175.551 Y134.601 E.33187
G1 X175.551 Y135.136 E.01599
G1 X166.799 Y143.888 E.36992
G1 X166.799 Y144.423 E.01599
G1 X175.973 Y135.249 E.38775
G1 X176.508 Y135.249 E.01599
G1 X166.63 Y145.127 E.41754
; WIPE_START
G1 X168.044 Y143.713 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X167.182 Y142.97 Z.8 F60000
G1 Z.4
G1 E.8 F1800
G1 F9514.245
M204 S8000
G1 X166.63 Y143.522 E.02335
M204 S10000
G1 X166.263 Y142.75 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.33758
G1 F12217.47
M204 S8000
G1 X162.037 Y142.75 E.09834
; WIPE_START
G1 X164.037 Y142.75 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X162.578 Y150.242 Z.8 F60000
G1 X160.787 Y159.437 Z.8
G1 Z.4
G1 E.8 F1800
; LINE_WIDTH: 0.19158
G1 F15000
M204 S8000
G1 X160.787 Y168.363 E.10481
M204 S10000
G1 X161.08 Y169.192 F60000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42065
G1 F9530.617
M204 S8000
G1 X161.372 Y168.899 E.01234
G1 X161.906 Y168.899 E.01594
G1 X161.249 Y169.556 E.02772
G1 X161.249 Y170.091 E.01594
G1 X162.441 Y168.899 E.05026
G1 X162.975 Y168.899 E.01594
G1 X161.249 Y170.625 E.07281
G1 X161.249 Y171.159 E.01594
G1 X163.509 Y168.899 E.09535
G1 X164.043 Y168.899 E.01594
G1 X161.249 Y171.693 E.11789
G1 X161.249 Y172.227 E.01594
G1 X164.577 Y168.899 E.14043
G1 X165.111 Y168.899 E.01594
G1 X161.249 Y172.761 E.16297
G1 X161.249 Y173.296 E.01594
G1 X165.646 Y168.899 E.18551
G1 X166.18 Y168.899 E.01594
G1 X161.249 Y173.83 E.20805
G1 X161.249 Y174.364 E.01594
G1 X166.714 Y168.899 E.23059
G1 X167.248 Y168.899 E.01594
G1 X161.249 Y174.898 E.25314
G1 X161.249 Y175.432 E.01594
G1 X167.782 Y168.899 E.27568
G1 X168.317 Y168.899 E.01594
G1 X161.249 Y175.967 E.29822
G1 X161.249 Y176.501 E.01594
G1 X168.851 Y168.899 E.32076
G1 X169.385 Y168.899 E.01594
G1 X161.249 Y177.035 E.3433
G1 X161.249 Y177.126 E.0027
G1 X161.693 Y177.126 E.01323
G1 X169.919 Y168.899 E.34713
G1 X170.453 Y168.899 E.01594
G1 X162.057 Y177.295 E.35429
; WIPE_START
G1 X163.472 Y175.881 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X160.925 Y177.662 Z.8 F60000
G1 Z.4
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.467762
G1 F8473.752
M204 S8000
G1 X160.925 Y185.328 E.25724
G1 X160.941 Y185.411 E.00286
; LINE_WIDTH: 0.51702
G1 F7593.335
G1 X160.958 Y185.495 E.00319
; WIPE_START
G1 X160.941 Y185.411 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X165.03 Y191.856 Z.8 F60000
G1 X165.855 Y193.158 Z.8
G1 Z.4
G1 E.8 F1800
; LINE_WIDTH: 0.51671
G1 F7598.303
M204 S8000
G1 X161.544 Y193.158 E.16134
M204 S10000
G1 X160.925 Y192.987 F60000
; LINE_WIDTH: 0.46758
G1 F8477.369
M204 S8000
G1 X160.925 Y185.662 E.24572
; LINE_WIDTH: 0.503353
G1 F7818.736
G1 X160.958 Y185.495 E.0062
G1 X161.003 Y185.495 E.00163
; LINE_WIDTH: 0.475038
G1 F8331.074
G1 X161.048 Y185.495 E.00153
; LINE_WIDTH: 0.436047
G1 F9157.362
G1 X161.092 Y185.495 E.00139
; LINE_WIDTH: 0.397056
G1 F10165.602
G1 X161.137 Y185.495 E.00125
; LINE_WIDTH: 0.37757
G1 F10757.508
G1 X166.263 Y185.495 E.13549
; WIPE_START
G1 X164.263 Y185.495 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X166.63 Y189.283 Z.8 F60000
G1 Z.4
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42065
G1 F9530.617
M204 S8000
G1 X181.326 Y174.587 E.62013
G1 X181.326 Y174.053 E.01594
G1 X166.799 Y188.579 E.61297
G1 X166.799 Y188.045 E.01594
G1 X181.326 Y173.519 E.61297
G1 X181.326 Y172.984 E.01594
G1 X166.799 Y187.511 E.61297
G1 X166.799 Y186.977 E.01594
G1 X181.326 Y172.45 E.61297
G1 X181.326 Y171.916 E.01594
G1 X166.799 Y186.442 E.61297
G1 X166.799 Y185.908 E.01594
G1 X181.326 Y171.382 E.61297
M73 P42 R12
G1 X181.326 Y170.848 E.01594
G1 X166.799 Y185.374 E.61297
G1 X166.799 Y184.84 E.01594
G1 X181.326 Y170.314 E.61297
G1 X181.326 Y169.779 E.01594
G1 X166.799 Y184.306 E.61297
G1 X166.799 Y183.771 E.01594
G1 X181.326 Y169.245 E.61297
G1 X181.326 Y168.711 E.01594
G1 X166.799 Y183.237 E.61297
G1 X166.799 Y182.703 E.01594
G1 X181.326 Y168.177 E.61297
G1 X181.326 Y167.643 E.01594
G1 X166.799 Y182.169 E.61297
G1 X166.799 Y181.635 E.01594
G1 X181.326 Y167.108 E.61297
G1 X181.326 Y166.574 E.01594
G1 X166.799 Y181.1 E.61297
G1 X166.799 Y180.566 E.01594
G1 X181.326 Y166.04 E.61297
G1 X181.326 Y165.506 E.01594
G1 X166.799 Y180.032 E.61297
G1 X166.799 Y179.498 E.01594
G1 X181.326 Y164.972 E.61297
G1 X181.326 Y164.437 E.01594
G1 X166.799 Y178.964 E.61297
G1 X166.799 Y178.429 E.01594
G1 X181.326 Y163.903 E.61297
G1 X181.326 Y163.369 E.01594
G1 X166.799 Y177.895 E.61297
G1 X166.799 Y177.361 E.01594
G1 X181.326 Y162.835 E.61297
G1 X181.326 Y162.301 E.01594
G1 X166.501 Y177.126 E.62557
G1 X165.966 Y177.126 E.01594
G1 X181.326 Y161.766 E.64812
G1 X181.326 Y161.528 E.00712
G1 X181.04 Y161.518 E.00853
G1 X165.432 Y177.126 E.65861
G1 X164.898 Y177.126 E.01594
G1 X180.699 Y161.324 E.66677
G1 X180.165 Y161.324 E.01594
G1 X164.364 Y177.126 E.66677
G1 X163.83 Y177.126 E.01594
G1 X179.631 Y161.324 E.66677
G1 X179.097 Y161.324 E.01594
G1 X163.295 Y177.126 E.66677
G1 X162.761 Y177.126 E.01594
G1 X178.563 Y161.324 E.66677
G1 X178.028 Y161.324 E.01594
G1 X171.064 Y168.288 E.29386
G1 X171.064 Y167.754 E.01594
G1 X177.494 Y161.324 E.27132
G1 X176.96 Y161.324 E.01594
G1 X171.064 Y167.22 E.24878
G1 X171.064 Y166.686 E.01594
G1 X176.426 Y161.324 E.22624
G1 X175.892 Y161.324 E.01594
G1 X171.064 Y166.152 E.2037
G1 X171.064 Y165.617 E.01594
G1 X175.357 Y161.324 E.18116
G1 X174.823 Y161.324 E.01594
G1 X171.064 Y165.083 E.15862
G1 X171.064 Y164.549 E.01594
G1 X174.376 Y161.238 E.13973
G1 X174.376 Y160.704 E.01594
G1 X171.064 Y164.015 E.13973
G1 X171.064 Y163.481 E.01594
G1 X174.376 Y160.169 E.13973
G1 X174.376 Y159.635 E.01594
G1 X171.064 Y162.946 E.13973
G1 X171.064 Y162.412 E.01594
G1 X174.376 Y159.101 E.13973
G1 X174.376 Y158.567 E.01594
G1 X171.064 Y161.878 E.13973
G1 X171.064 Y161.344 E.01594
G1 X174.376 Y158.033 E.13973
G1 X174.376 Y157.498 E.01594
G1 X171.064 Y160.81 E.13973
G1 X171.064 Y160.276 E.01594
G1 X174.376 Y156.964 E.13973
G1 X174.376 Y156.43 E.01594
G1 X171.064 Y159.741 E.13973
G1 X171.064 Y159.207 E.01594
G1 X174.307 Y155.964 E.13684
G1 X173.773 Y155.964 E.01594
G1 X170.837 Y158.901 E.1239
G1 X170.302 Y158.901 E.01594
G1 X173.239 Y155.964 E.1239
G1 X172.705 Y155.964 E.01594
G1 X169.768 Y158.901 E.1239
G1 X169.234 Y158.901 E.01594
G1 X172.17 Y155.964 E.1239
G1 X171.636 Y155.964 E.01594
G1 X168.7 Y158.901 E.1239
G1 X168.166 Y158.901 E.01594
G1 X171.102 Y155.964 E.1239
G1 X170.568 Y155.964 E.01594
G1 X167.632 Y158.901 E.1239
G1 X167.097 Y158.901 E.01594
G1 X170.034 Y155.964 E.1239
G1 X169.499 Y155.964 E.01594
G1 X166.563 Y158.901 E.1239
G1 X166.029 Y158.901 E.01594
G1 X168.965 Y155.964 E.1239
G1 X168.431 Y155.964 E.01594
G1 X165.495 Y158.901 E.1239
G1 X164.961 Y158.901 E.01594
G1 X167.897 Y155.964 E.1239
G1 X167.363 Y155.964 E.01594
G1 X164.426 Y158.901 E.1239
G1 X163.892 Y158.901 E.01594
G1 X166.828 Y155.964 E.1239
G1 X166.294 Y155.964 E.01594
G1 X163.358 Y158.901 E.1239
G1 X162.824 Y158.901 E.01594
G1 X165.76 Y155.964 E.1239
G1 X165.691 Y155.964 E.00207
G1 X165.691 Y155.5 E.01387
G1 X162.29 Y158.901 E.14351
G1 X161.755 Y158.901 E.01594
G1 X165.691 Y154.965 E.16605
G1 X165.691 Y154.431 E.01594
G1 X161.249 Y158.873 E.18741
G1 X161.249 Y158.338 E.01594
G1 X165.691 Y153.897 E.18741
G1 X165.691 Y153.639 E.00769
G1 X165.414 Y153.639 E.00825
G1 X161.249 Y157.804 E.17574
G1 X161.249 Y157.27 E.01594
G1 X164.88 Y153.639 E.1532
G1 X164.346 Y153.639 E.01594
G1 X161.249 Y156.736 E.13066
G1 X161.249 Y156.202 E.01594
G1 X163.812 Y153.639 E.10812
G1 X163.277 Y153.639 E.01594
G1 X161.249 Y155.667 E.08558
G1 X161.249 Y155.133 E.01594
G1 X162.743 Y153.639 E.06304
G1 X162.209 Y153.639 E.01594
G1 X161.249 Y154.599 E.04049
G1 X161.249 Y154.065 E.01594
G1 X161.844 Y153.47 E.02511
M204 S10000
G1 X160.925 Y153.103 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.46758
G1 F8477.369
M204 S8000
G1 X160.925 Y142.897 E.34233
M204 S10000
G1 X161.375 Y142.49 F60000
; LINE_WIDTH: 0.55344
G1 F7051.634
M204 S8000
G1 X161.375 Y133.13 E.37749
; WIPE_START
G1 X161.375 Y135.13 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X162.444 Y132.56 Z.8 F60000
G1 Z.4
G1 E.8 F1800
; LINE_WIDTH: 0.53172
G1 F7364.976
M204 S8000
G1 X166.755 Y132.56 E.16645
; WIPE_START
G1 X164.755 Y132.56 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X170.14 Y133.056 Z.8 F60000
G1 Z.4
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.4213
G1 F9514.245
M204 S8000
G1 X173.946 Y129.249 E.16089
G1 X173.411 Y129.249 E.01599
G1 X170.309 Y132.351 E.1311
G1 X170.309 Y131.816 E.01599
G1 X172.876 Y129.249 E.10848
G1 X172.341 Y129.249 E.01599
G1 X170.309 Y131.281 E.08586
G1 X170.309 Y130.746 E.01599
G1 X171.806 Y129.249 E.06324
G1 X171.27 Y129.249 E.01599
G1 X170.309 Y130.21 E.04062
G1 X170.309 Y129.675 E.01599
G1 X170.905 Y129.08 E.02518
; WIPE_START
G1 X170.309 Y129.675 E-.3201
G1 X170.309 Y130.21 E-.20334
G1 X170.75 Y129.77 E-.23656
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X176.087 Y129.025 Z.8 F60000
G1 Z.4
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.66758
G1 F5763.136
M204 S8000
G1 X188.687 Y129.025 E.62173
; WIPE_START
G1 X186.687 Y129.025 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X187.586 Y136.604 Z.8 F60000
G1 X187.629 Y136.97 Z.8
G1 Z.4
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.4213
G1 F9514.245
M204 S8000
G1 X188.151 Y136.449 E.02203
G1 X188.151 Y135.914 E.01599
G1 X187.264 Y136.801 E.03748
G1 X186.729 Y136.801 E.01599
G1 X188.151 Y135.379 E.0601
G1 X188.151 Y135.249 E.00387
G1 X187.745 Y135.249 E.01212
G1 X186.194 Y136.801 E.06557
G1 X185.659 Y136.801 E.01599
G1 X187.21 Y135.249 E.06557
G1 X186.675 Y135.249 E.01599
G1 X185.124 Y136.801 E.06557
G1 X184.588 Y136.801 E.01599
G1 X186.14 Y135.249 E.06557
G1 X185.605 Y135.249 E.01599
G1 X184.053 Y136.801 E.06557
G1 X183.518 Y136.801 E.01599
G1 X185.07 Y135.249 E.06557
G1 X184.534 Y135.249 E.01599
G1 X182.983 Y136.801 E.06557
G1 X182.448 Y136.801 E.01599
G1 X183.999 Y135.249 E.06557
G1 X183.464 Y135.249 E.01599
G1 X181.913 Y136.801 E.06557
G1 X181.378 Y136.801 E.01599
G1 X182.929 Y135.249 E.06557
G1 X182.394 Y135.249 E.01599
G1 X180.843 Y136.801 E.06557
G1 X180.308 Y136.801 E.01599
G1 X181.859 Y135.249 E.06557
G1 X181.324 Y135.249 E.01599
G1 X179.772 Y136.801 E.06557
G1 X179.237 Y136.801 E.01599
G1 X180.789 Y135.249 E.06557
G1 X180.254 Y135.249 E.01599
G1 X178.702 Y136.801 E.06557
G1 X178.167 Y136.801 E.01599
G1 X179.718 Y135.249 E.06557
G1 X179.183 Y135.249 E.01599
G1 X177.632 Y136.801 E.06557
G1 X177.097 Y136.801 E.01599
G1 X178.648 Y135.249 E.06557
G1 X178.113 Y135.249 E.01599
G1 X176.562 Y136.801 E.06557
G1 X176.027 Y136.801 E.01599
G1 X177.578 Y135.249 E.06557
G1 X177.043 Y135.249 E.01599
G1 X166.799 Y145.493 E.43299
G1 X166.799 Y146.028 E.01599
G1 X175.551 Y137.277 E.36992
G1 X175.551 Y137.812 E.01599
G1 X166.799 Y146.563 E.36992
G1 X166.799 Y147.098 E.01599
G1 X175.551 Y138.347 E.36992
G1 X175.551 Y138.882 E.01599
G1 X166.799 Y147.633 E.36992
G1 X166.799 Y148.168 E.01599
G1 X175.551 Y139.417 E.36992
G1 X175.551 Y139.952 E.01599
G1 X166.799 Y148.704 E.36992
G1 X166.799 Y149.239 E.01599
G1 X175.551 Y140.487 E.36992
G1 X175.551 Y141.022 E.01599
G1 X166.799 Y149.774 E.36992
G1 X166.799 Y150.026 E.00753
G1 X167.083 Y150.026 E.00846
G1 X175.551 Y141.558 E.35794
G1 X175.551 Y142.093 E.01599
G1 X167.618 Y150.026 E.33533
G1 X168.153 Y150.026 E.01599
G1 X175.551 Y142.628 E.31271
G1 X175.551 Y143.163 E.01599
G1 X168.688 Y150.026 E.29009
G1 X169.223 Y150.026 E.01599
G1 X175.999 Y143.249 E.28643
G1 X176.534 Y143.249 E.01599
G1 X169.758 Y150.026 E.28643
G1 X170.293 Y150.026 E.01599
G1 X177.069 Y143.249 E.28643
G1 X177.605 Y143.249 E.01599
G1 X170.828 Y150.026 E.28643
G1 X171.363 Y150.026 E.01599
G1 X178.14 Y143.249 E.28643
G1 X178.675 Y143.249 E.01599
G1 X171.899 Y150.026 E.28643
G1 X172.434 Y150.026 E.01599
G1 X179.21 Y143.249 E.28643
G1 X179.745 Y143.249 E.01599
G1 X172.969 Y150.026 E.28643
G1 X173.504 Y150.026 E.01599
G1 X180.28 Y143.249 E.28643
G1 X180.815 Y143.249 E.01599
G1 X174.039 Y150.026 E.28643
G1 X174.574 Y150.026 E.01599
G1 X181.35 Y143.249 E.28643
G1 X181.885 Y143.249 E.01599
G1 X175.109 Y150.026 E.28643
G1 X175.644 Y150.026 E.01599
G1 X182.421 Y143.249 E.28643
G1 X182.956 Y143.249 E.01599
G1 X176.179 Y150.026 E.28643
G1 X176.709 Y150.031 E.01584
G1 X183.491 Y143.249 E.28665
G1 X184.026 Y143.249 E.01599
G1 X176.54 Y150.736 E.31644
; WIPE_START
G1 X177.954 Y149.321 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X180.096 Y156.647 Z.8 F60000
G1 X181.425 Y161.195 Z.8
G1 Z.4
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.10344
G1 F15000
M204 S8000
G1 X181.425 Y155.805 E.02576
M204 S10000
G1 X180.527 Y155.845 F60000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.4213
G1 F9514.245
M204 S8000
G1 X181.326 Y155.047 E.03377
G1 X181.326 Y154.511 E.01599
G1 X180.161 Y155.676 E.04921
G1 X179.626 Y155.676 E.01599
G1 X181.326 Y153.976 E.07183
G1 X181.326 Y153.441 E.01599
M73 P43 R12
G1 X179.091 Y155.676 E.09445
G1 X178.556 Y155.676 E.01599
G1 X181.326 Y152.906 E.11707
G1 X181.326 Y152.371 E.01599
G1 X178.021 Y155.676 E.13969
G1 X177.486 Y155.676 E.01599
G1 X181.326 Y151.836 E.16231
G1 X181.326 Y151.301 E.01599
G1 X176.951 Y155.676 E.18493
G1 X176.709 Y155.676 E.00722
G1 X176.709 Y155.382 E.00878
G1 X181.326 Y150.766 E.19513
G1 X181.326 Y150.231 E.01599
G1 X176.709 Y154.847 E.19513
G1 X176.709 Y154.312 E.01599
G1 X181.326 Y149.695 E.19513
G1 X181.326 Y149.16 E.01599
G1 X176.709 Y153.777 E.19513
G1 X176.709 Y153.241 E.01599
G1 X181.326 Y148.625 E.19513
G1 X181.326 Y148.09 E.01599
G1 X176.709 Y152.706 E.19513
G1 X176.709 Y152.171 E.01599
G1 X181.326 Y147.555 E.19513
G1 X181.326 Y147.02 E.01599
G1 X176.709 Y151.636 E.19513
G1 X176.709 Y151.101 E.01599
G1 X184.561 Y143.249 E.33189
G1 X185.096 Y143.249 E.01599
G1 X182.18 Y146.166 E.12327
G1 X182.715 Y146.166 E.01599
G1 X185.631 Y143.249 E.12327
G1 X186.166 Y143.249 E.01599
G1 X183.25 Y146.166 E.12327
G1 X183.785 Y146.166 E.01599
G1 X186.701 Y143.249 E.12327
G1 X187.237 Y143.249 E.01599
G1 X184.32 Y146.166 E.12327
G1 X184.855 Y146.166 E.01599
G1 X187.772 Y143.249 E.12327
G1 X188.151 Y143.249 E.01133
G1 X188.151 Y143.406 E.00467
G1 X185.391 Y146.166 E.11667
G1 X185.926 Y146.166 E.01599
G1 X188.151 Y143.941 E.09405
G1 X188.151 Y144.476 E.01599
G1 X186.461 Y146.166 E.07143
G1 X186.996 Y146.166 E.01599
G1 X188.151 Y145.011 E.04881
G1 X188.151 Y145.546 E.01599
G1 X187.531 Y146.166 E.02619
G1 X188.066 Y146.166 E.01599
G1 X188.32 Y145.911 E.01075
; WIPE_START
G1 X188.066 Y146.166 E-.13662
G1 X187.531 Y146.166 E-.20334
G1 X188.151 Y145.546 E-.33301
G1 X188.151 Y145.317 E-.08703
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X189.095 Y147.093 Z.8 F60000
G1 Z.4
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.118631
G1 F15000
M204 S8000
G1 X189.12 Y147.083 E.00016
; LINE_WIDTH: 0.165653
G1 X189.146 Y147.074 E.00027
; LINE_WIDTH: 0.212674
G1 X189.172 Y147.065 E.00037
; LINE_WIDTH: 0.259695
G1 X189.198 Y147.055 E.00047
; LINE_WIDTH: 0.306717
G1 F13646.879
G1 X189.224 Y147.046 E.00057
; LINE_WIDTH: 0.353738
G1 F11582.34
G1 X189.25 Y147.037 E.00068
; LINE_WIDTH: 0.40076
G1 F10060.376
G1 X189.276 Y147.028 E.00078
; LINE_WIDTH: 0.447781
G1 F8891.942
G1 X189.302 Y147.018 E.00088
; LINE_WIDTH: 0.494803
G1 F7966.675
G1 X189.327 Y147.009 E.00098
; LINE_WIDTH: 0.541824
G1 F7215.819
G1 X189.353 Y147 E.00108
; LINE_WIDTH: 0.588846
G1 F6594.309
G1 X189.379 Y146.99 E.00119
; LINE_WIDTH: 0.616778
G1 F6273.336
G1 X189.398 Y147.002 E.001
G1 X189.408 Y147.109 E.00487
G1 X189.408 Y181.901 E1.57711
G1 X189.399 Y181.999 E.00448
G1 X189.371 Y182.018 E.00153
; LINE_WIDTH: 0.573214
G1 F6788.692
G1 X189.346 Y182.009 E.00112
; LINE_WIDTH: 0.527681
G1 F7426.342
G1 X189.321 Y182 E.00102
; LINE_WIDTH: 0.482149
G1 F8196.196
G1 X189.296 Y181.99 E.00093
; LINE_WIDTH: 0.436616
G1 F9144.123
G1 X189.27 Y181.981 E.00083
; LINE_WIDTH: 0.391083
G1 F10339.991
G1 X189.245 Y181.972 E.00074
; LINE_WIDTH: 0.34555
G1 F11895.715
G1 X189.22 Y181.963 E.00064
; LINE_WIDTH: 0.300018
G1 F14002.483
G1 X189.195 Y181.954 E.00054
; LINE_WIDTH: 0.254485
G1 F15000
G1 X189.17 Y181.945 E.00045
; LINE_WIDTH: 0.208952
G1 X189.145 Y181.936 E.00035
; LINE_WIDTH: 0.163419
G1 X189.12 Y181.926 E.00025
; LINE_WIDTH: 0.117887
G1 X189.095 Y181.917 E.00016
; WIPE_START
G1 X189.12 Y181.926 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X183.377 Y186.953 Z.8 F60000
G1 X176.301 Y193.148 Z.8
G1 Z.4
G1 E.8 F1800
; LINE_WIDTH: 0.53672
G1 F7290.401
M204 S8000
G1 X170.849 Y193.148 E.21263
; WIPE_START
G1 X172.849 Y193.148 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X170.075 Y192.248 Z.8 F60000
G1 Z.4
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42065
G1 F9530.617
M204 S8000
G1 X169.872 Y192.451 E.00857
G1 X169.338 Y192.451 E.01594
G1 X169.906 Y191.883 E.02395
G1 X169.906 Y191.349 E.01594
G1 X168.804 Y192.451 E.04649
G1 X168.27 Y192.451 E.01594
G1 X169.906 Y190.815 E.06903
G1 X169.906 Y190.281 E.01594
G1 X167.736 Y192.451 E.09157
G1 X167.201 Y192.451 E.01594
G1 X169.906 Y189.746 E.11411
G1 X169.906 Y189.212 E.01594
G1 X166.799 Y192.318 E.13108
G1 X166.799 Y191.784 E.01594
G1 X169.906 Y188.678 E.13108
G1 X169.906 Y188.144 E.01594
G1 X166.799 Y191.25 E.13108
G1 X166.799 Y190.716 E.01594
G1 X169.906 Y187.61 E.13108
G1 X169.906 Y187.075 E.01594
G1 X166.799 Y190.182 E.13108
G1 X166.799 Y189.648 E.01594
G1 X181.326 Y175.121 E.61297
G1 X181.326 Y175.655 E.01594
G1 X170.425 Y186.556 E.45996
G1 X170.96 Y186.556 E.01594
G1 X181.326 Y176.19 E.43742
G1 X181.326 Y176.724 E.01594
G1 X171.494 Y186.556 E.41488
G1 X172.028 Y186.556 E.01594
G1 X181.326 Y177.258 E.39234
G1 X181.326 Y177.792 E.01594
G1 X172.562 Y186.556 E.36979
G1 X173.096 Y186.556 E.01594
G1 X181.326 Y178.326 E.34725
G1 X181.326 Y178.861 E.01594
G1 X173.631 Y186.556 E.32471
G1 X174.165 Y186.556 E.01594
G1 X181.326 Y179.395 E.30217
G1 X181.326 Y179.929 E.01594
G1 X174.699 Y186.556 E.27963
G1 X175.233 Y186.556 E.01594
G1 X181.326 Y180.463 E.25709
G1 X181.326 Y180.997 E.01594
G1 X175.767 Y186.556 E.23455
G1 X176.302 Y186.556 E.01594
G1 X181.326 Y181.532 E.212
G1 X181.326 Y182.066 E.01594
G1 X176.836 Y186.556 E.18946
G1 X177.244 Y186.556 E.01219
G1 X177.244 Y186.681 E.00375
G1 X181.326 Y182.6 E.17222
G1 X181.326 Y182.844 E.00729
G1 X181.615 Y182.844 E.00864
G1 X177.244 Y187.215 E.18444
G1 X177.244 Y187.75 E.01594
G1 X182.15 Y182.844 E.20699
G1 X182.684 Y182.844 E.01594
G1 X177.244 Y188.284 E.22953
G1 X177.244 Y188.818 E.01594
G1 X183.218 Y182.844 E.25207
G1 X183.752 Y182.844 E.01594
G1 X177.244 Y189.352 E.27461
G1 X177.244 Y189.886 E.01594
G1 X184.286 Y182.844 E.29715
G1 X184.82 Y182.844 E.01594
G1 X177.244 Y190.421 E.31969
G1 X177.244 Y190.955 E.01594
G1 X185.355 Y182.844 E.34223
G1 X185.889 Y182.844 E.01594
G1 X177.244 Y191.489 E.36477
G1 X177.244 Y192.023 E.01594
G1 X186.423 Y182.844 E.38732
G1 X186.957 Y182.844 E.01594
G1 X177.351 Y192.451 E.40536
G1 X177.885 Y192.451 E.01594
G1 X187.491 Y182.844 E.40536
G1 X188.026 Y182.844 E.01594
G1 X178.419 Y192.451 E.40536
G1 X178.954 Y192.451 E.01594
G1 X188.151 Y183.254 E.38809
G1 X188.151 Y183.788 E.01594
G1 X179.488 Y192.451 E.36555
G1 X180.022 Y192.451 E.01594
G1 X188.151 Y184.322 E.34301
G1 X188.151 Y184.856 E.01594
G1 X180.556 Y192.451 E.32047
G1 X181.09 Y192.451 E.01594
G1 X188.151 Y185.39 E.29793
G1 X188.151 Y185.925 E.01594
G1 X181.625 Y192.451 E.27538
G1 X181.974 Y192.451 E.01044
G1 X181.974 Y192.635 E.0055
G1 X188.151 Y186.459 E.26062
G1 X188.151 Y186.993 E.01594
G1 X181.974 Y193.169 E.26062
G1 X181.974 Y193.703 E.01594
G1 X188.151 Y187.527 E.26062
G1 X188.151 Y188.061 E.01594
G1 X181.974 Y194.238 E.26062
G1 X181.974 Y194.772 E.01594
M73 P43 R11
G1 X188.151 Y188.595 E.26062
G1 X188.151 Y189.13 E.01594
G1 X181.974 Y195.306 E.26062
G1 X181.974 Y195.84 E.01594
G1 X188.151 Y189.664 E.26062
G1 X188.151 Y190.198 E.01594
G1 X181.974 Y196.374 E.26062
G1 X181.974 Y196.909 E.01594
G1 X188.151 Y190.732 E.26062
G1 X188.151 Y191.266 E.01594
G1 X181.974 Y197.443 E.26062
G1 X181.974 Y197.977 E.01594
G1 X188.151 Y191.801 E.26062
G1 X188.151 Y192.335 E.01594
G1 X181.974 Y198.511 E.26062
G1 X181.974 Y199.045 E.01594
G1 X188.151 Y192.869 E.26062
G1 X188.151 Y193.403 E.01594
G1 X181.974 Y199.579 E.26062
G1 X181.974 Y200.114 E.01594
G1 X188.151 Y193.937 E.26062
G1 X188.151 Y194.472 E.01594
G1 X181.974 Y200.648 E.26062
G1 X181.974 Y201.182 E.01594
G1 X188.151 Y195.006 E.26062
G1 X188.151 Y195.54 E.01594
G1 X181.805 Y201.886 E.26778
; WIPE_START
G1 X183.219 Y200.472 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X187.802 Y203.712 Z.8 F60000
G1 Z.4
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.433869
G1 F9208.362
M204 S8000
G1 X188.076 Y203.573 E.00947
G1 X188.097 Y203.441 E.00412
; LINE_WIDTH: 0.387287
G1 F10453.961
G1 X188.119 Y203.31 E.00363
; LINE_WIDTH: 0.347034
G1 F11837.694
G1 X188.137 Y203.152 E.00381
; LINE_WIDTH: 0.312892
G1 F13334.752
G1 X188.153 Y203.01 E.00305
; LINE_WIDTH: 0.265442
G1 F15000
G1 X188.172 Y202.712 E.00526
G1 X188.166 Y202.162 E.00967
; LINE_WIDTH: 0.293187
G1 F14384.676
G1 X188.144 Y201.896 E.00527
; LINE_WIDTH: 0.333907
G1 F12371.714
G1 X188.125 Y201.749 E.00342
; LINE_WIDTH: 0.370734
G1 F10981.835
G1 X188.108 Y201.614 E.00351
; LINE_WIDTH: 0.407197
G1 F9882.6
G1 X188.072 Y201.411 E.00593
; LINE_WIDTH: 0.438989
G1 F9089.335
G1 X188.038 Y201.225 E.00592
; WIPE_START
G1 X188.072 Y201.411 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X188.32 Y200.178 Z.8 F60000
G1 Z.4
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42065
G1 F9530.617
M204 S8000
G1 X187.662 Y200.836 E.02778
G2 X187.426 Y200.538 I-.883 J.456 E.01142
G1 X188.151 Y199.813 E.03058
G1 X188.151 Y199.279 E.01594
G1 X187.156 Y200.274 E.04197
G2 X186.848 Y200.048 I-2.339 J2.86 E.01141
G1 X188.151 Y198.745 E.05497
G1 X188.151 Y198.211 E.01594
G1 X186.496 Y199.866 E.06984
G1 X186.113 Y199.714 E.01228
G1 X188.151 Y197.677 E.08598
G1 X188.151 Y197.143 E.01594
G1 X185.664 Y199.629 E.10492
G1 X185.555 Y199.608 E.00331
G1 X185.147 Y199.612 E.0122
G1 X188.151 Y196.608 E.12676
G1 X188.151 Y196.074 E.01594
G1 X184.514 Y199.711 E.15345
G1 X184.403 Y199.74 E.00343
G1 X183.894 Y199.96 E.01656
G2 X182.691 Y201.229 I1.481 J2.608 E.05294
G1 X182.507 Y201.717 E.01556
G1 X181.974 Y202.25 E.02249
G1 X181.974 Y202.785 E.01594
G1 X182.407 Y202.352 E.01824
G1 X182.423 Y202.87 E.01546
G1 X181.974 Y203.319 E.01892
G1 X181.974 Y203.853 E.01594
G1 X182.52 Y203.307 E.02302
G2 X182.668 Y203.693 I1.059 J-.186 E.01241
G1 X181.974 Y204.387 E.02929
G1 X181.974 Y204.921 E.01594
G1 X182.854 Y204.042 E.03711
G1 X183.072 Y204.358 E.01146
G1 X181.974 Y205.456 E.04632
G1 X181.974 Y205.99 E.01594
G1 X183.334 Y204.63 E.05736
G2 X183.63 Y204.869 I1.388 J-1.422 E.01135
G1 X181.974 Y206.524 E.06985
G1 X181.974 Y207.058 E.01594
G1 X183.96 Y205.072 E.08379
G1 X184.34 Y205.227 E.01223
G1 X181.974 Y207.592 E.09982
G1 X181.974 Y208.127 E.01594
G1 X184.753 Y205.348 E.11726
G2 X185.238 Y205.398 I.582 J-3.282 E.01454
G1 X182.384 Y208.251 E.12039
G1 X182.919 Y208.251 E.01594
G1 X185.818 Y205.351 E.12235
G2 X186.632 Y205.071 I-.504 J-2.788 E.02579
G1 X183.453 Y208.251 E.13417
G1 X183.987 Y208.251 E.01594
G1 X188.019 Y204.218 E.17016
G1 X188.151 Y204.152 E.00439
G1 X188.151 Y204.621 E.01401
G1 X184.521 Y208.251 E.15315
G1 X185.055 Y208.251 E.01594
G1 X188.151 Y205.155 E.13061
G1 X188.151 Y205.69 E.01594
G1 X185.59 Y208.251 E.10807
G1 X186.124 Y208.251 E.01594
G1 X188.151 Y206.224 E.08553
G1 X188.151 Y206.758 E.01594
G1 X186.658 Y208.251 E.06299
G1 X187.192 Y208.251 E.01594
G1 X188.151 Y207.292 E.04045
G1 X188.151 Y207.826 E.01594
G1 X187.557 Y208.42 E.02506
; WIPE_START
G1 X188.151 Y207.826 E-.3192
G1 X188.151 Y207.292 E-.20299
G1 X187.708 Y207.735 E-.23781
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X185.928 Y200.313 Z.8 F60000
G1 X166.884 Y120.9 Z.8
G1 Z.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X166.884 Y121.274 E.01202
G1 X160.916 Y121.274 E.1919
G1 X160.916 Y111.416 E.31698
G1 X166.884 Y111.416 E.1919
G1 X166.884 Y116.237 E.15501
G1 X166.66 Y116.255 E.00723
G2 X166.57 Y117.203 I-2.556 J.236 E.48778
G2 X166.654 Y116.74 I-2.169 J-.636 E.01518
G1 X166.884 Y116.754 E.00739
G1 X166.884 Y120.84 E.1314
; WIPE_START
G1 X166.884 Y121.274 E-.16484
G1 X165.318 Y121.274 E-.59516
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X164.971 Y114.53 Z.8 F60000
G1 Z.4
G1 E.8 F1800
G1 F8843.478
M204 S8000
G1 X165.273 Y114.687 E.01096
G3 X163.871 Y114.352 I-1.175 J1.811 E.38894
G1 X164.074 Y114.34 E.00653
G3 X164.906 Y114.496 I.025 J2.159 E.0274
G1 X164.918 Y114.502 E.00043
M204 S10000
G1 X164.785 Y114.89 F60000
G1 F8843.478
M204 S8000
G1 X165.053 Y115.03 E.00971
G3 X163.915 Y114.757 I-.953 J1.469 E.31556
G1 X164.078 Y114.747 E.00526
G3 X164.73 Y114.865 I.021 J1.752 E.02143
M204 S250
G1 X164.609 Y115.239 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G3 X163.957 Y115.147 I-.509 J1.26 E.23461
G1 X164.083 Y115.14 E.00374
G3 X164.553 Y115.218 I.017 J1.359 E.01427
; WIPE_START
M204 S8000
G1 X164.84 Y115.359 E-.12167
G1 X165.045 Y115.522 E-.09948
G1 X165.215 Y115.72 E-.09915
G1 X165.345 Y115.953 E-.10131
G1 X165.43 Y116.216 E-.10532
G1 X165.46 Y116.475 E-.09891
G1 X165.44 Y116.736 E-.09956
G1 X165.415 Y116.824 E-.03459
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X167.291 Y120.9 Z.8 F60000
G1 Z.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X167.291 Y121.681 E.02511
G1 X160.509 Y121.681 E.21808
G1 X160.509 Y111.009 E.34316
G1 X167.291 Y111.009 E.21808
G1 X167.291 Y120.84 E.31613
M204 S10000
G1 X167.698 Y120.9 F60000
G1 F8843.478
M204 S8000
G1 X167.698 Y121.292 E.01261
G1 X168.098 Y121.292 E.01286
G1 X168.098 Y122.088 E.02559
G1 X160.102 Y122.088 E.25712
G1 X160.102 Y110.602 E.36934
G1 X167.698 Y110.602 E.24426
G1 X167.698 Y120.84 E.32921
M204 S250
G1 X168.09 Y120.9 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X168.49 Y120.9 E.01191
G1 X168.49 Y122.48 E.04706
G1 X159.71 Y122.48 E.26153
G1 X159.71 Y110.21 E.36548
G1 X168.09 Y110.21 E.24961
G1 X168.09 Y120.84 E.31663
; WIPE_START
M204 S8000
G1 X168.49 Y120.9 E-.1537
G1 X168.49 Y122.48 E-.60041
G1 X168.474 Y122.48 E-.00589
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X166.499 Y117.93 Z.8 F60000
G1 Z.4
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.122323
G1 F15000
M204 S8000
G1 X166.68 Y117.666 E.00201
; WIPE_START
M73 P44 R11
G1 X166.499 Y117.93 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X166.783 Y116.496 Z.8 F60000
G1 Z.4
G1 E.8 F1800
; LINE_WIDTH: 0.115498
G1 F15000
M204 S8000
G1 X166.479 Y116.5 E.00174
M204 S10000
G1 X166.783 Y116.496 F60000
; LINE_WIDTH: 0.152656
G1 F15000
M204 S8000
G1 X167.087 Y116.493 E.00264
; WIPE_START
G1 X166.783 Y116.496 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X166.68 Y115.312 Z.8 F60000
G1 Z.4
G1 E.8 F1800
; LINE_WIDTH: 0.138523
G1 F15000
M204 S8000
G1 X166.554 Y115.13 E.00167
; LINE_WIDTH: 0.108877
G1 X166.462 Y115.01 E.00079
; WIPE_START
G1 X166.554 Y115.13 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X165.712 Y113.137 Z.8 F60000
G1 Z.4
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.47146
G1 F8400.616
M204 S8000
G1 X165.712 Y112.588 E.01857
; LINE_WIDTH: 0.451325
G1 F8814.78
G1 X165.326 Y112.568 E.01245
; LINE_WIDTH: 0.411055
G1 F9779.021
G1 X164.941 Y112.548 E.01123
; LINE_WIDTH: 0.359943
G1 F11355.658
G2 X163.801 Y112.528 I-.836 J15.005 E.02856
; LINE_WIDTH: 0.36859
G1 F11054.134
G1 X163.406 Y112.546 E.01017
; LINE_WIDTH: 0.40471
G1 F9950.523
G1 X163.011 Y112.564 E.0113
; LINE_WIDTH: 0.442784
G1 F9003.077
G1 X162.798 Y112.584 E.00673
; LINE_WIDTH: 0.48281
G1 F8183.864
G1 X162.586 Y112.604 E.00741
; LINE_WIDTH: 0.540056
G1 F7241.482
G3 X162.124 Y112.624 I-.337 J-2.442 E.0182
G1 X162.124 Y113.291 E.02621
G1 X162.473 Y113.103 E.01557
; LINE_WIDTH: 0.522837
G1 F7501.302
G1 X162.665 Y113.049 E.00758
; LINE_WIDTH: 0.48281
G1 F8183.864
G1 X162.858 Y112.994 E.00695
; LINE_WIDTH: 0.442784
G1 F9003.077
G1 X163.05 Y112.94 E.00632
; LINE_WIDTH: 0.407625
G1 F9870.991
G1 X163.335 Y112.894 E.00832
; LINE_WIDTH: 0.364409
G1 F11197.91
G1 X163.621 Y112.849 E.00734
G1 X164.331 Y112.832 E.01804
G1 X164.892 Y112.889 E.01432
; LINE_WIDTH: 0.409888
G1 F9810.133
G1 X165.149 Y112.945 E.00764
; LINE_WIDTH: 0.458676
G1 F8658.931
G3 X165.657 Y113.112 I-.151 J1.314 E.01768
M204 S10000
G1 X166.115 Y113.855 F60000
; LINE_WIDTH: 0.41999
G1 F9547.299
M204 S8000
G1 X166.115 Y112.185 E.04973
G1 X161.685 Y112.185 E.13193
G1 X161.685 Y114.218 E.06054
G1 X161.997 Y113.911 E.01302
G1 X162.436 Y113.609 E.01588
G1 X163.022 Y113.344 E.01914
G1 X163.693 Y113.19 E.02052
G1 X164.334 Y113.173 E.0191
G3 X166.066 Y113.819 I-.223 J3.24 E.05585
M204 S10000
G1 X166.35 Y114.601 F60000
G1 F9547.299
M204 S8000
G1 X166.438 Y114.535 E.00326
G1 X166.492 Y114.543 E.00164
G1 X166.492 Y111.808 E.08147
G1 X161.308 Y111.808 E.15439
G1 X161.308 Y114.811 E.08944
G1 X161.633 Y114.879 E.00988
G1 X161.78 Y114.663 E.00777
G1 X162.182 Y114.246 E.01727
G1 X162.65 Y113.919 E.017
G1 X163.171 Y113.69 E.01696
G1 X163.771 Y113.559 E.0183
G1 X164.337 Y113.55 E.01686
G3 X165.688 Y114.003 I-.387 J3.396 E.04275
G1 X166.144 Y114.36 E.01725
G1 X166.311 Y114.555 E.00767
; WIPE_START
G1 X166.144 Y114.36 E-.09785
G1 X165.688 Y114.003 E-.22006
G1 X165.192 Y113.748 E-.21195
G1 X164.683 Y113.598 E-.20172
G1 X164.608 Y113.588 E-.02842
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X161.367 Y115.224 Z.8 F60000
G1 Z.4
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.451924
G1 F8801.886
M204 S8000
G1 X161.32 Y115.447 E.00737
; LINE_WIDTH: 0.42284
G1 F9475.677
G1 X161.299 Y115.583 E.00412
; LINE_WIDTH: 0.377277
G1 F10766.958
G1 X161.275 Y115.733 E.00402
; LINE_WIDTH: 0.339397
G1 F12142.615
G1 X161.261 Y115.865 E.0031
; LINE_WIDTH: 0.308923
G1 F13533.723
G1 X161.245 Y116.009 E.00304
; LINE_WIDTH: 0.264937
G1 F15000
G1 X161.224 Y116.553 E.00956
G1 X161.235 Y116.858 E.00534
; LINE_WIDTH: 0.286276
G1 F14793.163
G1 X161.248 Y117.002 E.00279
; LINE_WIDTH: 0.312858
G1 F13336.435
G1 X161.262 Y117.161 E.0034
; LINE_WIDTH: 0.346766
G1 F11848.13
G1 X161.281 Y117.299 E.00335
; LINE_WIDTH: 0.387802
G1 F10438.371
G1 X161.303 Y117.455 E.00428
; LINE_WIDTH: 0.432326
G1 F9244.85
G1 X161.364 Y117.775 E.01001
; WIPE_START
G1 X161.303 Y117.455 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X163.214 Y120.116 Z.8 F60000
G1 Z.4
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.420675
G1 F9529.986
M204 S8000
G1 X163.473 Y120.138 E.00777
; LINE_WIDTH: 0.360047
G1 F11351.92
G2 X164.536 Y120.157 I.742 J-12.026 E.02662
; WIPE_START
G1 X163.733 Y120.16 E-.57387
G1 X163.473 Y120.138 E-.18613
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X163.214 Y120.116 Z.8 F60000
G1 Z.4
G1 E.8 F1800
; LINE_WIDTH: 0.427157
G1 F9369.238
M204 S8000
G1 X162.551 Y119.874 E.02142
G1 X162.063 Y119.603 E.01692
G1 X162.063 Y120.127 E.01588
G2 X163.154 Y120.118 I.329 J-26.871 E.0331
; WIPE_START
G1 X162.063 Y120.127 E-.41438
G1 X162.063 Y119.603 E-.19884
G1 X162.401 Y119.791 E-.14679
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X165.772 Y120.162 Z.8 F60000
G1 Z.4
G1 E.8 F1800
; LINE_WIDTH: 0.35438
G1 F11558.471
M204 S8000
G1 X165.772 Y119.772 E.00961
G1 X165.195 Y120.009 E.01536
G3 X164.595 Y120.154 I-4.335 J-16.661 E.01517
G2 X165.712 Y120.162 I.867 J-41.638 E.02748
M204 S10000
G1 X166.115 Y120.505 F60000
; LINE_WIDTH: 0.41999
G1 F9547.299
M204 S8000
G1 X166.115 Y119.15 E.04036
G3 X165.221 Y119.641 I-1.893 J-2.381 E.03052
G1 X164.563 Y119.803 E.02017
G1 X163.899 Y119.829 E.0198
G1 X163.28 Y119.733 E.01867
G1 X162.684 Y119.52 E.01884
G1 X162.283 Y119.296 E.01369
G1 X161.828 Y118.941 E.01719
G1 X161.685 Y118.786 E.00627
G1 X161.685 Y120.505 E.05118
G1 X166.055 Y120.505 E.13014
M204 S10000
G1 X166.492 Y120.882 F60000
G1 F9547.299
M204 S8000
G1 X166.492 Y118.397 E.07402
G1 X166.408 Y118.353 E.0028
G1 X166.023 Y118.751 E.01649
G1 X165.557 Y119.076 E.01692
G1 X165.068 Y119.297 E.01597
G1 X164.479 Y119.435 E.01803
G1 X163.891 Y119.452 E.01754
G1 X163.343 Y119.362 E.01653
G1 X162.817 Y119.167 E.01671
G1 X162.515 Y118.999 E.0103
G1 X162.06 Y118.644 E.01719
G3 X161.642 Y118.121 I24.858 J-20.288 E.01994
G1 X161.308 Y118.184 E.01012
G1 X161.308 Y120.882 E.08035
G1 X166.432 Y120.882 E.15261
; CHANGE_LAYER
; Z_HEIGHT: 0.475
; LAYER_HEIGHT: 0.075
; WIPE_START
G1 F9547.299
G1 X164.432 Y120.882 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 3/37
; update layer progress
M73 L3
M991 S0 P2 ;notify layer change

; OBJECT_ID: 15
M204 S10000
G17
G3 Z.8 I-.893 J.827 P1  F60000
G1 X168.512 Y125.287 Z.8
G1 Z.475
G1 E.8 F1800
; FEATURE: Support
; LINE_WIDTH: 0.42
; LAYER_HEIGHT: 0.275
G1 F7252.893
M204 S8000
G1 X168.512 Y123.229 E.08069
G1 X159.688 Y123.229 E.34594
G1 X159.688 Y125.475 E.08809
G1 X168.512 Y125.475 E.34594
G1 X168.512 Y126.961 E.05828
G1 X168.337 Y126.961 E.00685
G1 X168.021 Y127.277 E.01749
G1 X168.021 Y128.352 E.04216
G1 X159.688 Y128.352 E.32672
G1 X159.688 Y130.971 E.1027
G1 X168.021 Y130.971 E.32672
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

G1 X168.021 Y128.541 E.0953
; CHANGE_LAYER
; Z_HEIGHT: 0.6
; LAYER_HEIGHT: 0.125
; WIPE_START
G1 X168.021 Y130.541 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 4/37
; update layer progress
M73 L4
M991 S0 P3 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z.875 I-.771 J.942 P1  F60000
G1 X188.525 Y147.313 Z.875
G1 Z.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
; LAYER_HEIGHT: 0.2
G1 F8843.478
M204 S8000
G1 X188.917 Y147.313 E.01261
G1 X188.917 Y181.697 E1.10567
G1 X182.473 Y181.697 E.20722
G1 X182.473 Y147.313 E1.10567
G1 X188.465 Y147.313 E.19268
; COOLING_NODE: 0
M204 S250
G1 X188.525 Y147.705 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X188.525 Y181.305 E1.00083
G1 X182.865 Y181.305 E.16859
G1 X182.865 Y147.705 E1.00083
G1 X188.465 Y147.705 E.1668
; COOLING_NODE: 0
; WIPE_START
M204 S8000
G1 X188.469 Y149.705 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X181.081 Y151.625 Z1 F60000
G1 X167.23 Y155.224 Z1
G1 Z.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X166.431 Y155.224 E.0257
G1 X166.431 Y150.766 E.14336
G1 X175.969 Y150.766 E.30672
G1 X175.969 Y155.224 E.14336
G1 X167.29 Y155.224 E.27909
; COOLING_NODE: 0
M204 S10000
G1 X167.23 Y154.817 F60000
G1 F8843.478
M204 S8000
G1 X166.838 Y154.817 E.01261
G1 X166.838 Y151.173 E.11718
G1 X175.562 Y151.173 E.28054
G1 X175.562 Y154.817 E.11718
G1 X167.29 Y154.817 E.266
; COOLING_NODE: 1
M204 S250
G1 X167.23 Y154.425 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X167.23 Y151.565 E.08519
G1 X175.17 Y151.565 E.23651
G1 X175.17 Y154.425 E.08519
G1 X167.29 Y154.425 E.23472
; COOLING_NODE: 1
; WIPE_START
M204 S8000
G1 X167.248 Y152.425 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X166.194 Y144.866 Z1 F60000
G1 X166.059 Y143.9 Z1
G1 Z.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X166.059 Y152.899 E.28938
G1 X161.341 Y152.899 E.15172
G1 X161.341 Y143.101 E.31508
G1 X166.059 Y143.101 E.15172
G1 X166.059 Y143.84 E.02377
; COOLING_NODE: 1
M204 S10000
G1 X165.652 Y143.9 F60000
G1 F8843.478
M204 S8000
G1 X165.652 Y152.492 E.27629
G1 X161.748 Y152.492 E.12554
G1 X161.748 Y143.508 E.2889
G1 X165.652 Y143.508 E.12554
G1 X165.652 Y143.84 E.01068
; COOLING_NODE: 2
M204 S250
G1 X165.26 Y143.9 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X165.26 Y152.1 E.24425
G1 X162.14 Y152.1 E.09293
G1 X162.14 Y143.9 E.24425
G1 X165.2 Y143.9 E.09115
; COOLING_NODE: 2
; WIPE_START
M204 S8000
G1 X165.215 Y145.9 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X161.834 Y142.694 Z1 F60000
G1 Z.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X160.916 Y142.694 E.02951
G1 X160.916 Y132.926 E.31409
G1 X161.834 Y132.926 E.02951
G1 X161.834 Y142.634 E.31216
; COOLING_NODE: 2
; WIPE_START
G1 X160.916 Y142.694 E-.34943
G1 X160.916 Y141.613 E-.41057
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X168.548 Y141.661 Z1 F60000
G1 X176.291 Y141.71 Z1
G1 Z.6
G1 E.8 F1800
G1 F8843.478
M204 S8000
G1 X176.291 Y137.541 E.13406
G1 X188.509 Y137.541 E.3929
G1 X188.509 Y142.509 E.15976
G1 X176.291 Y142.509 E.3929
G1 X176.291 Y141.77 E.02377
; COOLING_NODE: 2
M204 S10000
G1 X176.698 Y141.71 F60000
G1 F8843.478
M204 S8000
G1 X176.698 Y137.948 E.12097
G1 X188.102 Y137.948 E.36672
G1 X188.102 Y142.102 E.13358
G1 X176.698 Y142.102 E.36672
G1 X176.698 Y141.77 E.01068
; COOLING_NODE: 3
M204 S250
G1 X177.09 Y141.71 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X177.09 Y138.34 E.10038
G1 X187.71 Y138.34 E.31633
G1 X187.71 Y141.71 E.10038
G1 X177.15 Y141.71 E.31455
; COOLING_NODE: 3
; WIPE_START
M204 S8000
G1 X177.114 Y139.71 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X176 Y147.261 Z1 F60000
G1 X174.709 Y156.009 Z1
G1 Z.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X181.191 Y156.009 E.20845
G1 X181.191 Y160.991 E.16022
G1 X174.709 Y160.991 E.20845
G1 X174.709 Y156.069 E.15829
; COOLING_NODE: 3
; WIPE_START
G1 X176.709 Y156.05 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X180.784 Y159.785 Z1 F60000
G1 Z.6
G1 E.8 F1800
G1 F8843.478
M204 S8000
G1 X180.784 Y160.584 E.0257
G1 X175.116 Y160.584 E.18227
G1 X175.116 Y156.416 E.13404
G1 X180.784 Y156.416 E.18227
G1 X180.784 Y159.725 E.10641
; COOLING_NODE: 3
M204 S10000
G1 X180.377 Y159.785 F60000
G1 F8843.478
M204 S8000
G1 X180.377 Y160.177 E.01261
G1 X175.523 Y160.177 E.15609
G1 X175.523 Y156.823 E.10786
G1 X180.377 Y156.823 E.15609
G1 X180.377 Y159.725 E.09332
; COOLING_NODE: 4
M204 S250
G1 X179.985 Y159.785 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X175.915 Y159.785 E.12123
G1 X175.915 Y157.215 E.07655
G1 X179.985 Y157.215 E.12123
G1 X179.985 Y159.725 E.07476
; COOLING_NODE: 4
; WIPE_START
M204 S8000
G1 X177.985 Y159.754 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X179.031 Y167.315 Z1 F60000
G1 X183.627 Y200.555 Z1
G1 Z.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X183.672 Y200.512 E.00202
G3 X185.029 Y199.946 I1.625 J1.986 E.04796
G1 X185.285 Y199.932 E.00825
G3 X183.482 Y200.684 I.012 J2.566 E.45409
G1 X183.582 Y200.595 E.00429
; COOLING_NODE: 4
M204 S10000
G1 X183.873 Y200.887 F60000
G1 F8843.478
M204 S8000
G1 X183.931 Y200.828 E.00266
G3 X185.072 Y200.352 I1.367 J1.671 E.04034
G1 X185.288 Y200.34 E.00695
G3 X183.621 Y201.139 I.01 J2.159 E.37478
G1 X183.831 Y200.929 E.00955
; COOLING_NODE: 4
M204 S10000
G1 X184.161 Y201.173 F60000
G1 F8843.478
M204 S8000
G1 X184.19 Y201.143 E.00135
G3 X185.116 Y200.757 I1.109 J1.356 E.03272
G1 X185.291 Y200.747 E.00565
G3 X183.938 Y201.396 I.008 J1.752 E.30407
G1 X184.118 Y201.216 E.00821
; COOLING_NODE: 5
M204 S250
G1 X184.437 Y201.449 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X184.439 Y201.447 E.00008
G3 X185.157 Y201.147 I.86 J1.053 E.02351
G1 X185.294 Y201.14 E.00407
G3 X184.243 Y201.643 I.006 J1.359 E.21858
G1 X184.395 Y201.491 E.0064
; COOLING_NODE: 5
; WIPE_START
M204 S8000
G1 X184.439 Y201.447 E-.0238
G1 X184.661 Y201.299 E-.10117
G1 X184.901 Y201.2 E-.09893
G1 X185.157 Y201.147 E-.0993
G1 X185.294 Y201.14 E-.05193
G1 X185.559 Y201.165 E-.10134
G1 X185.81 Y201.239 E-.09952
G1 X186.055 Y201.369 E-.10536
G1 X186.215 Y201.5 E-.07864
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X186.387 Y193.869 Z1 F60000
G1 X187.71 Y134.916 Z1
G1 Z.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X188.484 Y134.916 E.02488
G1 X188.484 Y137.134 E.07131
G1 X175.884 Y137.134 E.40517
G1 X175.884 Y142.916 E.18594
G1 X188.484 Y142.916 E.40517
G1 X188.484 Y146.499 E.1152
G1 X181.659 Y146.499 E.21947
G1 X181.659 Y182.511 E1.15803
G1 X188.484 Y182.511 E.21947
G1 X188.484 Y208.584 E.8384
G1 X181.641 Y208.584 E.22003
G1 X181.641 Y192.784 E.50807
G1 X176.911 Y192.784 E.1521
G1 X176.911 Y186.889 E.18956
G1 X170.239 Y186.889 E.21456
G1 X170.239 Y192.784 E.18956
G1 X166.466 Y192.784 E.12131
G1 X166.466 Y177.459 E.4928
G1 X160.916 Y177.459 E.17847
G1 X160.916 Y168.566 E.28595
G1 X170.731 Y168.566 E.31561
G1 X170.731 Y159.234 E.3001
G1 X160.916 Y159.234 E.31561
G1 X160.916 Y153.306 E.19061
G1 X166.024 Y153.306 E.16424
G1 X166.024 Y155.631 E.07476
G1 X176.376 Y155.631 E.3329
G1 X176.376 Y150.359 E.16954
G1 X166.466 Y150.359 E.31867
G1 X166.466 Y142.806 E.24286
G1 X167.366 Y142.806 E.02894
G1 X167.366 Y132.926 E.3177
G1 X169.976 Y132.926 E.08393
G1 X169.976 Y128.916 E.12895
G1 X175.884 Y128.916 E.18997
M73 P45 R11
G1 X175.884 Y134.916 E.19294
G1 X187.65 Y134.916 E.37836
; COOLING_NODE: 5
; WIPE_START
G1 X188.484 Y134.916 E-.31685
G1 X188.484 Y136.082 E-.44315
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X187.71 Y129.541 Z1 F60000
G1 Z.6
G1 E.8 F1800
G1 F8843.478
M204 S8000
G1 X188.509 Y129.541 E.0257
G1 X188.509 Y134.509 E.15976
G1 X176.291 Y134.509 E.3929
G1 X176.291 Y129.541 E.15976
G1 X187.65 Y129.541 E.36527
; COOLING_NODE: 5
M204 S10000
G1 X187.71 Y129.948 F60000
G1 F8843.478
M204 S8000
G1 X188.102 Y129.948 E.01261
G1 X188.102 Y134.102 E.13358
G1 X176.698 Y134.102 E.36672
G1 X176.698 Y129.948 E.13358
G1 X187.65 Y129.948 E.35218
; COOLING_NODE: 6
M204 S250
G1 X187.71 Y130.34 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X187.71 Y133.71 E.10038
G1 X177.09 Y133.71 E.31633
G1 X177.09 Y130.34 E.10038
G1 X187.65 Y130.34 E.31455
; COOLING_NODE: 6
; WIPE_START
M204 S8000
G1 X187.686 Y132.34 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X184.295 Y139.178 Z1 F60000
G1 X170.324 Y167.36 Z1
G1 Z.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X170.324 Y168.159 E.0257
G1 X161.065 Y168.159 E.29774
G1 X161.065 Y159.641 E.27392
G1 X170.324 Y159.641 E.29774
G1 X170.324 Y167.3 E.24629
; COOLING_NODE: 6
M204 S10000
G1 X169.917 Y167.36 F60000
G1 F8843.478
M204 S8000
G1 X169.917 Y167.752 E.01261
G1 X161.472 Y167.752 E.27156
G1 X161.472 Y160.048 E.24774
G1 X169.917 Y160.048 E.27156
G1 X169.917 Y167.3 E.2332
; COOLING_NODE: 7
M204 S250
G1 X169.525 Y167.36 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X161.864 Y167.36 E.22819
G1 X161.864 Y160.44 E.20612
G1 X169.525 Y160.44 E.22819
G1 X169.525 Y167.3 E.20434
; COOLING_NODE: 7
; WIPE_START
M204 S8000
G1 X167.525 Y167.316 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X166.87 Y174.92 Z1 F60000
G1 X166.059 Y184.325 Z1
G1 Z.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X166.059 Y185.124 E.0257
G1 X161.341 Y185.124 E.15172
G1 X161.341 Y177.866 E.2334
G1 X166.059 Y177.866 E.15172
G1 X166.059 Y184.265 E.20577
; COOLING_NODE: 7
M204 S10000
G1 X165.652 Y184.325 F60000
G1 F8843.478
M204 S8000
G1 X165.652 Y184.717 E.01261
G1 X161.748 Y184.717 E.12554
G1 X161.748 Y178.273 E.20722
G1 X165.652 Y178.273 E.12554
G1 X165.652 Y184.265 E.19268
; COOLING_NODE: 8
M204 S250
G1 X165.26 Y184.325 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X162.14 Y184.325 E.09293
G1 X162.14 Y178.665 E.16859
G1 X165.26 Y178.665 E.09293
G1 X165.26 Y184.265 E.1668
; COOLING_NODE: 8
; WIPE_START
M204 S8000
G1 X163.26 Y184.303 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X167.533 Y177.979 Z1 F60000
G1 X188.525 Y146.906 Z1
G1 Z.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X182.066 Y146.906 E.2077
G1 X182.066 Y182.104 E1.13185
G1 X188.891 Y182.104 E.21947
G1 X188.891 Y208.991 E.86458
G1 X181.234 Y208.991 E.24621
G1 X181.234 Y193.191 E.50807
G1 X176.504 Y193.191 E.1521
G1 X176.504 Y187.296 E.18956
G1 X170.646 Y187.296 E.18838
G1 X170.646 Y193.191 E.18956
G1 X166.059 Y193.191 E.14749
G1 X166.059 Y185.866 E.23555
G1 X161.341 Y185.866 E.15172
G1 X161.341 Y193.191 E.23555
G1 X160.509 Y193.191 E.02675
G1 X160.509 Y132.519 E1.95098
G1 X162.241 Y132.519 E.05569
G1 X162.241 Y142.399 E.3177
G1 X166.959 Y142.399 E.15172
G1 X166.959 Y132.519 E.3177
G1 X169.569 Y132.519 E.08393
G1 X169.569 Y128.509 E.12895
G1 X188.891 Y128.509 E.62132
G1 X188.891 Y146.906 E.59157
G1 X188.585 Y146.906 E.00984
; COOLING_NODE: 8
; WIPE_START
G1 X186.585 Y146.906 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X179.164 Y145.121 Z1 F60000
G1 X166.16 Y141.992 Z1
G1 Z.6
G1 E.8 F1800
G1 F8843.478
M204 S8000
G1 X162.648 Y141.992 E.11294
G1 X162.648 Y133.008 E.2889
G1 X166.552 Y133.008 E.12554
G1 X166.552 Y141.992 E.2889
G1 X166.22 Y141.992 E.01068
; COOLING_NODE: 9
M204 S250
G1 X166.16 Y141.6 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X163.04 Y141.6 E.09293
G1 X163.04 Y133.4 E.24425
G1 X166.16 Y133.4 E.09293
G1 X166.16 Y141.54 E.24246
; COOLING_NODE: 9
; WIPE_START
M204 S8000
G1 X164.16 Y141.578 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X163.798 Y149.202 Z1 F60000
G1 X161.748 Y192.325 Z1
G1 Z.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X161.748 Y186.273 E.19461
G1 X165.652 Y186.273 E.12554
G1 X165.652 Y192.717 E.20722
G1 X161.748 Y192.717 E.12554
G1 X161.748 Y192.385 E.01068
; COOLING_NODE: 10
M204 S250
G1 X162.14 Y192.325 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X162.14 Y186.665 E.16859
G1 X165.26 Y186.665 E.09293
G1 X165.26 Y192.325 E.16859
G1 X162.2 Y192.325 E.09115
; COOLING_NODE: 10
; WIPE_START
M204 S8000
G1 X162.179 Y190.325 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X169.672 Y188.873 Z1 F60000
G1 X175.705 Y187.703 Z1
G1 Z.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X176.097 Y187.703 E.01261
G1 X176.097 Y192.697 E.16059
G1 X171.053 Y192.697 E.1622
G1 X171.053 Y187.703 E.16059
G1 X175.645 Y187.703 E.14766
; COOLING_NODE: 11
M204 S250
G1 X175.705 Y188.095 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X175.705 Y192.305 E.1254
G1 X171.445 Y192.305 E.12689
G1 X171.445 Y188.095 E.1254
G1 X175.645 Y188.095 E.1251
; COOLING_NODE: 11
; WIPE_START
M204 S8000
G1 X175.673 Y190.095 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X174.822 Y182.51 Z1 F60000
G1 X169.162 Y132.112 Z1
G1 Z.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X169.162 Y128.102 E.12895
G1 X189.298 Y128.102 E.6475
G1 X189.298 Y146.502 E.59168
G1 X189.898 Y146.502 E.01929
G1 X189.898 Y182.498 E1.1575
G1 X189.298 Y182.498 E.01929
G1 X189.298 Y209.398 E.86501
G1 X180.827 Y209.398 E.27239
G1 X180.827 Y193.598 E.50807
G1 X160.102 Y193.598 E.66644
G1 X160.102 Y132.112 E1.97716
G1 X169.102 Y132.112 E.28941
; COOLING_NODE: 12
M204 S250
G1 X168.77 Y131.72 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2356
M204 S5000
G1 X168.77 Y127.71 E.11944
G1 X189.69 Y127.71 E.62314
G1 X189.69 Y146.11 E.54807
G1 X190.29 Y146.11 E.01787
G1 X190.29 Y182.89 E1.09555
G1 X189.69 Y182.89 E.01787
G1 X189.69 Y209.79 E.80126
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

G1 X180.435 Y209.79 E.27568
G1 X180.435 Y193.99 E.47063
G1 X159.71 Y193.99 E.61733
M73 P46 R11
G1 X159.71 Y131.72 E1.85481
G1 X168.71 Y131.72 E.26808
; WIPE_START
G1 F9547.055
M204 S8000
G1 X168.74 Y129.72 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X166.755 Y132.56 Z1 F60000
G1 Z.6
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.53172
G1 F7364.976
M204 S8000
G1 X162.444 Y132.56 E.16645
; WIPE_START
G1 X164.444 Y132.56 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X161.375 Y133.13 Z1 F60000
G1 Z.6
G1 E.8 F1800
; LINE_WIDTH: 0.55344
G1 F7051.634
M204 S8000
G1 X161.375 Y142.49 E.37749
M204 S10000
G1 X160.925 Y142.897 F60000
; LINE_WIDTH: 0.46758
G1 F8477.369
M204 S8000
G1 X160.925 Y153.103 E.34233
; WIPE_START
G1 X160.925 Y151.103 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X161.933 Y143.537 Z1 F60000
G1 X162.037 Y142.75 Z1
G1 Z.6
G1 E.8 F1800
; LINE_WIDTH: 0.33758
G1 F12217.47
M204 S8000
G1 X166.263 Y142.75 E.09834
; WIPE_START
G1 X164.263 Y142.75 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X167.449 Y135.814 Z1 F60000
G1 X170.14 Y129.957 Z1
G1 Z.6
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42088
G1 F9524.817
M204 S8000
G1 X176.983 Y136.801 E.28896
G1 X176.449 Y136.801 E.01596
G1 X170.309 Y130.661 E.25922
G1 X170.309 Y131.196 E.01596
G1 X175.914 Y136.801 E.23665
G1 X175.551 Y136.801 E.01086
G1 X175.551 Y136.972 E.0051
G1 X170.309 Y131.73 E.2213
G1 X170.309 Y132.265 E.01596
G1 X175.551 Y137.506 E.2213
G1 X175.551 Y138.041 E.01596
G1 X170.309 Y132.799 E.2213
G1 X170.309 Y133.259 E.01374
G1 X170.235 Y133.259 E.00222
G1 X175.551 Y138.575 E.22445
G1 X175.551 Y139.11 E.01596
G1 X169.7 Y133.259 E.24702
G1 X169.166 Y133.259 E.01596
G1 X175.551 Y139.644 E.26958
G1 X175.551 Y140.179 E.01596
G1 X168.631 Y133.259 E.29215
G1 X168.097 Y133.259 E.01596
G1 X175.551 Y140.713 E.31472
G1 X175.551 Y141.248 E.01596
G1 X167.699 Y133.396 E.3315
G1 X167.699 Y133.931 E.01596
G1 X175.551 Y141.782 E.3315
G1 X175.551 Y142.317 E.01596
G1 X167.699 Y134.465 E.3315
G1 X167.699 Y135 E.01596
G1 X175.551 Y142.851 E.3315
G1 X175.551 Y143.249 E.01189
G1 X175.949 Y143.249 E.01189
G1 X181.326 Y148.626 E.22703
G1 X181.326 Y148.092 E.01596
G1 X176.483 Y143.249 E.20446
G1 X177.018 Y143.249 E.01596
G1 X181.326 Y147.557 E.18189
G1 X181.326 Y147.023 E.01596
G1 X177.552 Y143.249 E.15932
G1 X178.087 Y143.249 E.01596
G1 X181.326 Y146.488 E.13675
G1 X181.326 Y146.166 E.00963
G1 X181.538 Y146.166 E.00633
G1 X178.621 Y143.249 E.12313
G1 X179.156 Y143.249 E.01596
G1 X182.072 Y146.166 E.12313
G1 X182.607 Y146.166 E.01596
G1 X179.69 Y143.249 E.12313
G1 X180.225 Y143.249 E.01596
G1 X183.141 Y146.166 E.12313
G1 X183.676 Y146.166 E.01596
G1 X180.759 Y143.249 E.12313
G1 X181.294 Y143.249 E.01596
G1 X184.21 Y146.166 E.12313
G1 X184.745 Y146.166 E.01596
G1 X181.828 Y143.249 E.12313
G1 X182.363 Y143.249 E.01596
G1 X185.279 Y146.166 E.12313
G1 X185.814 Y146.166 E.01596
G1 X182.897 Y143.249 E.12313
G1 X183.432 Y143.249 E.01596
G1 X186.348 Y146.166 E.12313
G1 X186.883 Y146.166 E.01596
G1 X183.966 Y143.249 E.12313
G1 X184.501 Y143.249 E.01596
G1 X187.417 Y146.166 E.12313
G1 X187.952 Y146.166 E.01596
G1 X185.036 Y143.249 E.12313
G1 X185.57 Y143.249 E.01596
G1 X188.151 Y145.83 E.10896
G1 X188.151 Y145.295 E.01596
G1 X186.105 Y143.249 E.08639
G1 X186.639 Y143.249 E.01596
G1 X188.151 Y144.761 E.06382
G1 X188.151 Y144.226 E.01596
G1 X187.174 Y143.249 E.04125
G1 X187.708 Y143.249 E.01596
G1 X188.32 Y143.862 E.02585
; WIPE_START
G1 X187.708 Y143.249 E-.32901
G1 X187.174 Y143.249 E-.20312
G1 X187.598 Y143.673 E-.22788
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X189.095 Y147.093 Z1 F60000
G1 Z.6
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.118631
G1 F15000
M204 S8000
G1 X189.12 Y147.083 E.00016
; LINE_WIDTH: 0.165653
G1 X189.146 Y147.074 E.00027
; LINE_WIDTH: 0.212674
G1 X189.172 Y147.065 E.00037
; LINE_WIDTH: 0.259695
G1 X189.198 Y147.055 E.00047
; LINE_WIDTH: 0.306717
G1 F13646.879
G1 X189.224 Y147.046 E.00057
; LINE_WIDTH: 0.353738
G1 F11582.34
G1 X189.25 Y147.037 E.00068
; LINE_WIDTH: 0.40076
G1 F10060.376
G1 X189.276 Y147.028 E.00078
; LINE_WIDTH: 0.447781
G1 F8891.942
G1 X189.302 Y147.018 E.00088
; LINE_WIDTH: 0.494803
G1 F7966.675
G1 X189.327 Y147.009 E.00098
; LINE_WIDTH: 0.541824
G1 F7215.819
G1 X189.353 Y147 E.00108
; LINE_WIDTH: 0.588846
G1 F6594.309
G1 X189.379 Y146.99 E.00119
; LINE_WIDTH: 0.616778
G1 F6273.336
G1 X189.398 Y147.002 E.001
G1 X189.408 Y147.109 E.00487
G1 X189.408 Y181.901 E1.57711
G1 X189.399 Y181.999 E.00448
G1 X189.371 Y182.018 E.00153
; LINE_WIDTH: 0.573214
G1 F6788.692
G1 X189.346 Y182.009 E.00112
; LINE_WIDTH: 0.527681
G1 F7426.342
G1 X189.321 Y182 E.00102
; LINE_WIDTH: 0.482149
G1 F8196.196
G1 X189.296 Y181.99 E.00093
; LINE_WIDTH: 0.436616
G1 F9144.123
G1 X189.27 Y181.981 E.00083
; LINE_WIDTH: 0.391083
G1 F10339.991
G1 X189.245 Y181.972 E.00074
; LINE_WIDTH: 0.34555
G1 F11895.715
G1 X189.22 Y181.963 E.00064
; LINE_WIDTH: 0.300018
G1 F14002.483
G1 X189.195 Y181.954 E.00054
; LINE_WIDTH: 0.254485
G1 F15000
G1 X189.17 Y181.945 E.00045
; LINE_WIDTH: 0.208952
G1 X189.145 Y181.936 E.00035
; LINE_WIDTH: 0.163419
G1 X189.12 Y181.926 E.00025
; LINE_WIDTH: 0.117887
G1 X189.095 Y181.917 E.00016
; WIPE_START
G1 X189.12 Y181.926 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X187.509 Y182.675 Z1 F60000
G1 Z.6
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42352
G1 F9458.749
M204 S8000
G1 X188.151 Y183.316 E.02726
G1 X188.151 Y183.854 E.01618
G1 X187.141 Y182.844 E.04294
G1 X186.603 Y182.844 E.01618
G1 X188.151 Y184.392 E.06582
G1 X188.151 Y184.931 E.01618
G1 X186.064 Y182.844 E.08871
G1 X185.526 Y182.844 E.01618
G1 X188.151 Y185.469 E.11159
G1 X188.151 Y186.007 E.01618
G1 X184.988 Y182.844 E.13448
G1 X184.45 Y182.844 E.01618
G1 X188.151 Y186.545 E.15736
G1 X188.151 Y187.084 E.01618
G1 X183.911 Y182.844 E.18025
G1 X183.373 Y182.844 E.01618
G1 X188.151 Y187.622 E.20313
G1 X188.151 Y188.16 E.01618
G1 X182.835 Y182.844 E.22602
G1 X182.297 Y182.844 E.01618
G1 X188.151 Y188.698 E.2489
G1 X188.151 Y189.237 E.01618
G1 X181.758 Y182.844 E.27179
G1 X181.326 Y182.844 E.01301
G1 X181.326 Y182.412 E.01301
G1 X167.813 Y168.899 E.57451
G1 X168.352 Y168.899 E.01618
G1 X181.326 Y181.873 E.55163
G1 X181.326 Y181.335 E.01618
G1 X168.89 Y168.899 E.52874
G1 X169.428 Y168.899 E.01618
G1 X181.326 Y180.797 E.50586
G1 X181.326 Y180.259 E.01618
G1 X169.966 Y168.899 E.48297
G1 X170.505 Y168.899 E.01618
G1 X181.326 Y179.72 E.46009
G1 X181.326 Y179.182 E.01618
G1 X171.043 Y168.899 E.4372
G1 X171.064 Y168.899 E.00065
G1 X171.064 Y168.383 E.01554
G1 X181.326 Y178.644 E.43629
G1 X181.326 Y178.106 E.01618
G1 X171.064 Y167.844 E.43629
G1 X171.064 Y167.306 E.01618
G1 X181.326 Y177.567 E.43629
G1 X181.326 Y177.029 E.01618
G1 X171.064 Y166.768 E.43629
G1 X171.064 Y166.23 E.01618
G1 X181.326 Y176.491 E.43629
G1 X181.326 Y175.953 E.01618
G1 X171.064 Y165.691 E.43629
G1 X171.064 Y165.153 E.01618
G1 X181.326 Y175.414 E.43629
G1 X181.326 Y174.876 E.01618
G1 X171.064 Y164.615 E.43629
G1 X171.064 Y164.077 E.01618
G1 X181.326 Y174.338 E.43629
G1 X181.326 Y173.8 E.01618
G1 X171.064 Y163.538 E.43629
G1 X171.064 Y163 E.01618
G1 X181.326 Y173.261 E.43629
G1 X181.326 Y172.723 E.01618
G1 X171.064 Y162.462 E.43629
G1 X171.064 Y161.924 E.01618
G1 X181.326 Y172.185 E.43629
G1 X181.326 Y171.647 E.01618
G1 X171.064 Y161.385 E.43629
G1 X171.064 Y160.847 E.01618
G1 X181.326 Y171.108 E.43629
G1 X181.326 Y170.57 E.01618
G1 X171.064 Y160.309 E.43629
G1 X171.064 Y159.771 E.01618
G1 X181.326 Y170.032 E.43629
G1 X181.326 Y169.494 E.01618
G1 X167.796 Y155.964 E.57524
G1 X168.335 Y155.964 E.01618
G1 X181.495 Y169.125 E.55957
; WIPE_START
G1 X180.081 Y167.711 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X176.651 Y160.893 Z1 F60000
G1 X174.086 Y155.795 Z1
G1 Z.6
G1 E.8 F1800
G1 F9458.749
M204 S8000
G1 X174.376 Y156.085 E.01233
G1 X174.376 Y156.623 E.01618
G1 X173.717 Y155.964 E.028
G1 X173.179 Y155.964 E.01618
G1 X174.376 Y157.161 E.05089
G1 X174.376 Y157.699 E.01618
G1 X172.641 Y155.964 E.07377
G1 X172.102 Y155.964 E.01618
G1 X174.376 Y158.238 E.09666
G1 X174.376 Y158.776 E.01618
G1 X171.564 Y155.964 E.11954
G1 X171.026 Y155.964 E.01618
G1 X174.376 Y159.314 E.14243
G1 X174.376 Y159.852 E.01618
G1 X170.488 Y155.964 E.16531
G1 X169.949 Y155.964 E.01618
G1 X174.376 Y160.391 E.1882
G1 X174.376 Y160.929 E.01618
G1 X169.411 Y155.964 E.21108
G1 X168.873 Y155.964 E.01618
G1 X181.326 Y168.417 E.52947
G1 X181.326 Y167.879 E.01618
G1 X174.771 Y161.324 E.27869
G1 X175.309 Y161.324 E.01618
G1 X181.326 Y167.341 E.2558
G1 X181.326 Y166.802 E.01618
M73 P47 R11
G1 X175.848 Y161.324 E.23292
G1 X176.386 Y161.324 E.01618
G1 X181.326 Y166.264 E.21003
G1 X181.326 Y165.726 E.01618
G1 X176.924 Y161.324 E.18715
G1 X177.462 Y161.324 E.01618
G1 X181.326 Y165.188 E.16426
G1 X181.326 Y164.649 E.01618
G1 X178.001 Y161.324 E.14138
G1 X178.539 Y161.324 E.01618
G1 X181.326 Y164.111 E.11849
G1 X181.326 Y163.573 E.01618
G1 X179.077 Y161.324 E.0956
G1 X179.615 Y161.324 E.01618
G1 X181.326 Y163.035 E.07272
G1 X181.326 Y162.496 E.01618
G1 X180.154 Y161.324 E.04983
G1 X180.692 Y161.324 E.01618
G1 X181.495 Y162.128 E.03416
M204 S10000
G1 X181.425 Y161.195 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.10344
G1 F15000
M204 S8000
G1 X181.425 Y155.805 E.02576
M204 S10000
G1 X181.495 Y155.21 F60000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42088
G1 F9524.817
M204 S8000
G1 X176.709 Y150.424 E.20208
G1 X176.709 Y150.959 E.01596
G1 X181.223 Y155.472 E.19057
G1 X181.04 Y155.472 E.00546
G1 X181.04 Y155.676 E.00607
G1 X180.892 Y155.676 E.00443
G1 X176.709 Y151.493 E.17659
G1 X176.709 Y152.028 E.01596
G1 X180.357 Y155.676 E.15403
G1 X179.823 Y155.676 E.01596
G1 X176.709 Y152.562 E.13146
G1 X176.709 Y153.097 E.01596
G1 X179.288 Y155.676 E.10889
G1 X178.754 Y155.676 E.01596
G1 X176.709 Y153.631 E.08632
G1 X176.709 Y154.166 E.01596
G1 X178.219 Y155.676 E.06375
G1 X177.685 Y155.676 E.01596
G1 X176.709 Y154.7 E.04118
G1 X176.709 Y155.235 E.01596
G1 X177.32 Y155.845 E.02578
; WIPE_START
G1 X176.709 Y155.235 E-.32809
G1 X176.709 Y154.7 E-.20312
G1 X177.135 Y155.126 E-.2288
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X181.495 Y149.33 Z1 F60000
G1 Z.6
G1 E.8 F1800
G1 F9524.817
M204 S8000
G1 X167.699 Y135.534 E.58251
G1 X167.699 Y136.069 E.01596
G1 X181.326 Y149.695 E.57534
G1 X181.326 Y150.23 E.01596
G1 X167.699 Y136.604 E.57534
G1 X167.699 Y137.138 E.01596
G1 X181.326 Y150.764 E.57534
G1 X181.326 Y151.299 E.01596
G1 X167.699 Y137.673 E.57534
G1 X167.699 Y138.207 E.01596
G1 X181.326 Y151.833 E.57534
G1 X181.326 Y152.368 E.01596
G1 X167.699 Y138.742 E.57534
G1 X167.699 Y139.276 E.01596
G1 X181.326 Y152.902 E.57534
G1 X181.326 Y153.437 E.01596
G1 X167.699 Y139.811 E.57534
G1 X167.699 Y140.345 E.01596
G1 X181.326 Y153.971 E.57534
G1 X181.326 Y154.506 E.01596
G1 X167.699 Y140.88 E.57534
G1 X167.699 Y141.414 E.01596
G1 X176.311 Y150.026 E.3636
G1 X175.776 Y150.026 E.01596
G1 X167.699 Y141.949 E.34103
G1 X167.699 Y142.483 E.01596
G1 X175.242 Y150.026 E.31846
G1 X174.707 Y150.026 E.01596
G1 X167.699 Y143.018 E.29589
G1 X167.699 Y143.139 E.00363
G1 X167.286 Y143.139 E.01233
G1 X174.173 Y150.026 E.29076
G1 X173.638 Y150.026 E.01596
G1 X166.799 Y143.187 E.28876
G1 X166.799 Y143.721 E.01596
G1 X173.104 Y150.026 E.26619
G1 X172.569 Y150.026 E.01596
G1 X166.799 Y144.256 E.24362
G1 X166.799 Y144.79 E.01596
G1 X172.035 Y150.026 E.22105
G1 X171.5 Y150.026 E.01596
G1 X166.799 Y145.325 E.19848
G1 X166.799 Y145.859 E.01596
G1 X170.966 Y150.026 E.17591
G1 X170.431 Y150.026 E.01596
G1 X166.799 Y146.394 E.15335
G1 X166.799 Y146.928 E.01596
G1 X169.897 Y150.026 E.13078
G1 X169.362 Y150.026 E.01596
G1 X166.799 Y147.463 E.10821
G1 X166.799 Y147.997 E.01596
G1 X168.828 Y150.026 E.08564
G1 X168.293 Y150.026 E.01596
G1 X166.799 Y148.532 E.06307
G1 X166.799 Y149.066 E.01596
G1 X167.759 Y150.026 E.0405
G1 X167.224 Y150.026 E.01596
G1 X166.63 Y149.431 E.0251
; WIPE_START
G1 X167.224 Y150.026 E-.31942
G1 X167.759 Y150.026 E-.20311
G1 X167.317 Y149.584 E-.23746
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X165.86 Y154.028 Z1 F60000
G1 Z.6
G1 E.8 F1800
; LINE_WIDTH: 0.42352
G1 F9458.749
M204 S8000
G1 X165.471 Y153.639 E.01654
G1 X164.933 Y153.639 E.01618
G1 X165.691 Y154.397 E.03221
G1 X165.691 Y154.935 E.01618
G1 X164.395 Y153.639 E.0551
G1 X163.857 Y153.639 E.01618
G1 X165.691 Y155.473 E.07798
G1 X165.691 Y155.964 E.01476
G1 X166.182 Y155.964 E.01476
G1 X169.118 Y158.901 E.12484
G1 X169.656 Y158.901 E.01618
G1 X166.72 Y155.964 E.12484
G1 X167.258 Y155.964 E.01618
G1 X170.364 Y159.07 E.13206
; WIPE_START
G1 X168.95 Y157.656 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X168.749 Y159.07 Z1 F60000
G1 Z.6
G1 E.8 F1800
G1 F9458.749
M204 S8000
G1 X163.318 Y153.639 E.23091
G1 X162.78 Y153.639 E.01618
G1 X168.041 Y158.901 E.2237
G1 X167.503 Y158.901 E.01618
G1 X162.242 Y153.639 E.2237
G1 X161.704 Y153.639 E.01618
G1 X166.965 Y158.901 E.2237
G1 X166.427 Y158.901 E.01618
G1 X161.249 Y153.723 E.22013
G1 X161.249 Y154.262 E.01618
G1 X165.888 Y158.901 E.19724
G1 X165.35 Y158.901 E.01618
G1 X161.249 Y154.8 E.17435
G1 X161.249 Y155.338 E.01618
G1 X164.812 Y158.901 E.15147
G1 X164.274 Y158.901 E.01618
G1 X161.249 Y155.876 E.12858
G1 X161.249 Y156.415 E.01618
G1 X163.735 Y158.901 E.1057
G1 X163.197 Y158.901 E.01618
G1 X161.249 Y156.953 E.08281
G1 X161.249 Y157.491 E.01618
G1 X162.659 Y158.901 E.05993
G1 X162.121 Y158.901 E.01618
G1 X161.249 Y158.029 E.03704
G1 X161.249 Y158.568 E.01618
G1 X161.752 Y159.07 E.02137
; WIPE_START
G1 X161.249 Y158.568 E-.27014
G1 X161.249 Y158.029 E-.20454
G1 X161.78 Y158.56 E-.28533
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X160.787 Y159.437 Z1 F60000
G1 Z.6
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.19158
G1 F15000
M204 S8000
G1 X160.787 Y168.363 E.10481
; WIPE_START
G1 X160.787 Y166.363 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X166.584 Y171.328 Z1 F60000
G1 X188.32 Y189.945 Z1
G1 Z.6
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42352
G1 F9458.749
M204 S8000
G1 X167.275 Y168.899 E.8948
G1 X166.737 Y168.899 E.01618
G1 X188.151 Y190.313 E.91047
G1 X188.151 Y190.851 E.01618
G1 X166.199 Y168.899 E.93335
G1 X165.66 Y168.899 E.01618
G1 X188.151 Y191.39 E.95624
G1 X188.151 Y191.928 E.01618
G1 X165.122 Y168.899 E.97913
G1 X164.584 Y168.899 E.01618
G1 X188.151 Y192.466 E1.00201
G1 X188.151 Y193.004 E.01618
G1 X164.046 Y168.899 E1.0249
G1 X163.507 Y168.899 E.01618
G1 X188.151 Y193.543 E1.04778
G1 X188.151 Y194.081 E.01618
G1 X162.969 Y168.899 E1.07067
G1 X162.431 Y168.899 E.01618
G1 X188.151 Y194.619 E1.09355
G1 X188.151 Y195.157 E.01618
G1 X161.893 Y168.899 E1.11644
G1 X161.354 Y168.899 E.01618
G1 X188.151 Y195.696 E1.13932
G1 X188.151 Y196.234 E.01618
G1 X161.249 Y169.333 E1.14379
G1 X161.249 Y169.871 E.01618
G1 X188.151 Y196.772 E1.14379
G1 X188.151 Y197.31 E.01618
G1 X161.249 Y170.409 E1.14379
G1 X161.249 Y170.947 E.01618
G1 X176.858 Y186.556 E.66363
G1 X176.319 Y186.556 E.01618
G1 X161.249 Y171.486 E.64074
G1 X161.249 Y172.024 E.01618
G1 X166.351 Y177.126 E.21692
G1 X165.813 Y177.126 E.01618
G1 X161.249 Y172.562 E.19403
G1 X161.249 Y173.1 E.01618
G1 X165.275 Y177.126 E.17115
G1 X164.736 Y177.126 E.01618
G1 X161.249 Y173.639 E.14826
G1 X161.249 Y174.177 E.01618
G1 X164.198 Y177.126 E.12537
G1 X163.66 Y177.126 E.01618
G1 X161.249 Y174.715 E.10249
G1 X161.249 Y175.253 E.01618
G1 X163.122 Y177.126 E.0796
G1 X162.583 Y177.126 E.01618
G1 X161.249 Y175.792 E.05672
G1 X161.249 Y176.33 E.01618
G1 X162.045 Y177.126 E.03383
G1 X161.507 Y177.126 E.01618
G1 X161.08 Y176.698 E.01816
M204 S10000
G1 X160.925 Y177.662 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.467762
G1 F8473.752
M204 S8000
G1 X160.925 Y185.328 E.25724
G1 X160.941 Y185.411 E.00286
; LINE_WIDTH: 0.51702
G1 F7593.335
G1 X160.958 Y185.495 E.00319
; WIPE_START
G1 X160.941 Y185.411 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X166.263 Y185.495 Z1 F60000
G1 Z.6
G1 E.8 F1800
; LINE_WIDTH: 0.37757
G1 F10757.508
M204 S8000
G1 X161.137 Y185.495 E.13549
; LINE_WIDTH: 0.397056
G1 F10165.602
G1 X161.092 Y185.495 E.00125
; LINE_WIDTH: 0.436047
G1 F9157.362
G1 X161.048 Y185.495 E.00139
; LINE_WIDTH: 0.475038
G1 F8331.074
G1 X161.003 Y185.495 E.00153
; LINE_WIDTH: 0.503353
G1 F7818.736
G1 X160.958 Y185.495 E.00163
G1 X160.925 Y185.662 E.0062
; LINE_WIDTH: 0.46758
G1 F8477.369
G1 X160.925 Y192.987 E.24572
M204 S10000
G1 X161.544 Y193.158 F60000
; LINE_WIDTH: 0.51671
G1 F7598.303
M204 S8000
G1 X165.855 Y193.158 E.16134
; WIPE_START
G1 X163.855 Y193.158 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X167.313 Y192.62 Z1 F60000
G1 Z.6
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42352
G1 F9458.749
M204 S8000
G1 X166.799 Y192.107 E.02184
G1 X166.799 Y191.568 E.01618
G1 X167.682 Y192.451 E.03751
G1 X168.22 Y192.451 E.01618
G1 X166.799 Y191.03 E.0604
G1 X166.799 Y190.492 E.01618
G1 X168.758 Y192.451 E.08328
G1 X169.296 Y192.451 E.01618
G1 X166.799 Y189.954 E.10617
G1 X166.799 Y189.415 E.01618
G1 X169.835 Y192.451 E.12905
G1 X169.906 Y192.451 E.00214
G1 X169.906 Y191.983 E.01405
G1 X166.799 Y188.877 E.13207
G1 X166.799 Y188.339 E.01618
G1 X169.906 Y191.445 E.13207
G1 X169.906 Y190.907 E.01618
G1 X166.799 Y187.801 E.13207
G1 X166.799 Y187.262 E.01618
G1 X169.906 Y190.369 E.13207
G1 X169.906 Y189.83 E.01618
G1 X166.799 Y186.724 E.13207
G1 X166.799 Y186.186 E.01618
G1 X169.906 Y189.292 E.13207
G1 X169.906 Y188.754 E.01618
G1 X166.799 Y185.648 E.13207
G1 X166.799 Y185.109 E.01618
G1 X169.906 Y188.216 E.13207
G1 X169.906 Y187.677 E.01618
G1 X166.799 Y184.571 E.13207
G1 X166.799 Y184.033 E.01618
G1 X169.906 Y187.139 E.13207
G1 X169.906 Y186.601 E.01618
G1 X166.799 Y183.495 E.13207
G1 X166.799 Y182.956 E.01618
G1 X170.399 Y186.556 E.15303
G1 X170.937 Y186.556 E.01618
G1 X166.799 Y182.418 E.17592
G1 X166.799 Y181.88 E.01618
M73 P48 R11
G1 X171.475 Y186.556 E.1988
G1 X172.013 Y186.556 E.01618
G1 X166.799 Y181.342 E.22169
G1 X166.799 Y180.803 E.01618
G1 X172.552 Y186.556 E.24457
G1 X173.09 Y186.556 E.01618
G1 X166.799 Y180.265 E.26746
G1 X166.799 Y179.727 E.01618
G1 X173.628 Y186.556 E.29034
G1 X174.166 Y186.556 E.01618
G1 X166.799 Y179.189 E.31323
G1 X166.799 Y178.65 E.01618
G1 X174.705 Y186.556 E.33611
G1 X175.243 Y186.556 E.01618
G1 X166.799 Y178.112 E.359
G1 X166.799 Y177.574 E.01618
G1 X175.951 Y186.725 E.3891
; WIPE_START
G1 X174.537 Y185.311 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.287 Y192.217 Z1 F60000
G1 X170.849 Y193.148 Z1
G1 Z.6
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.53672
G1 F7290.401
M204 S8000
G1 X176.301 Y193.148 E.21263
; WIPE_START
G1 X174.301 Y193.148 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X177.075 Y192.155 Z1 F60000
G1 Z.6
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42352
G1 F9458.749
M204 S8000
G1 X177.37 Y192.451 E.01256
G1 X177.908 Y192.451 E.01618
G1 X177.244 Y191.787 E.02823
G1 X177.244 Y191.248 E.01618
G1 X178.447 Y192.451 E.05112
G1 X178.985 Y192.451 E.01618
G1 X177.244 Y190.71 E.074
G1 X177.244 Y190.172 E.01618
G1 X179.523 Y192.451 E.09689
G1 X180.061 Y192.451 E.01618
G1 X177.244 Y189.634 E.11977
G1 X177.244 Y189.095 E.01618
G1 X180.6 Y192.451 E.14266
G1 X181.138 Y192.451 E.01618
G1 X177.244 Y188.557 E.16554
G1 X177.244 Y188.019 E.01618
G1 X188.151 Y198.925 E.46371
G1 X188.151 Y198.387 E.01618
G1 X177.244 Y187.481 E.46371
G1 X177.244 Y186.942 E.01618
G1 X188.32 Y198.018 E.47093
; WIPE_START
G1 X186.906 Y196.604 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X188.32 Y199.633 Z1 F60000
G1 Z.6
G1 E.8 F1800
G1 F9458.749
M204 S8000
G1 X181.974 Y193.287 E.26982
G1 X181.974 Y193.825 E.01618
G1 X188.151 Y200.002 E.2626
G1 X188.151 Y200.54 E.01618
G1 X181.974 Y194.364 E.2626
G1 X181.974 Y194.902 E.01618
G1 X187.972 Y200.899 E.25499
G1 X187.734 Y200.941 E.00727
G2 X187.124 Y200.243 I-2.363 J1.448 E.02798
G1 X186.661 Y199.936 E.01671
G1 X186.337 Y199.802 E.01055
G1 X181.974 Y195.44 E.18548
G1 X181.974 Y195.978 E.01618
G1 X185.614 Y199.618 E.15474
G1 X185.07 Y199.613 E.01634
G1 X181.974 Y196.517 E.13164
G1 X181.974 Y197.055 E.01618
G1 X184.612 Y199.692 E.11213
G2 X184.207 Y199.826 I.14 J1.106 E.01289
G1 X181.974 Y197.593 E.09492
G1 X181.974 Y198.131 E.01618
G1 X183.84 Y199.997 E.07931
G2 X183.518 Y200.213 I.938 J1.74 E.01168
G1 X181.974 Y198.67 E.06564
G1 X181.974 Y199.208 E.01618
G1 X183.232 Y200.466 E.05348
G2 X182.985 Y200.757 I1.256 J1.319 E.0115
G1 X181.974 Y199.746 E.04296
G1 X181.974 Y200.284 E.01618
G1 X182.772 Y201.082 E.03393
G2 X182.605 Y201.453 I1.235 J.779 E.01228
G1 X181.974 Y200.823 E.02682
G1 X181.974 Y201.361 E.01618
M73 P48 R10
G1 X182.48 Y201.867 E.02151
G2 X182.407 Y202.332 I1.548 J.482 E.0142
G1 X181.974 Y201.899 E.0184
G1 X181.974 Y202.437 E.01618
G1 X182.429 Y202.892 E.01931
G2 X182.649 Y203.651 I2.559 J-.333 E.02386
G1 X181.974 Y202.976 E.02871
G1 X181.974 Y203.514 E.01618
G1 X186.711 Y208.251 E.2014
G1 X187.249 Y208.251 E.01618
G1 X184.153 Y205.154 E.13165
G2 X184.909 Y205.372 I1.107 J-2.423 E.02373
G1 X187.788 Y208.251 E.1224
G1 X188.151 Y208.251 E.01091
G1 X188.151 Y208.075 E.00527
G1 X185.465 Y205.39 E.11419
G2 X185.94 Y205.327 I-.091 J-2.518 E.01444
G1 X188.151 Y207.537 E.09398
G1 X188.151 Y206.999 E.01618
G1 X186.352 Y205.201 E.07646
G2 X186.718 Y205.028 I-1.094 J-2.783 E.01216
G1 X188.151 Y206.461 E.06092
G1 X188.151 Y205.922 E.01618
G1 X187.041 Y204.812 E.0472
G2 X187.334 Y204.568 I-.692 J-1.13 E.01153
G1 X188.151 Y205.384 E.03471
G1 X188.151 Y204.846 E.01618
G1 X187.586 Y204.282 E.024
G2 X187.743 Y204.061 I-.991 J-.869 E.00816
G1 X187.938 Y204.095 E.00595
G1 X188.32 Y204.477 E.01627
M204 S10000
G1 X188.039 Y203.774 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.435835
G1 F9162.291
M204 S8000
G1 X188.075 Y203.57 E.00643
; LINE_WIDTH: 0.398361
G1 F10128.263
G1 X188.113 Y203.349 E.00631
; LINE_WIDTH: 0.35915
G1 F11384.149
G1 X188.131 Y203.205 E.00363
; LINE_WIDTH: 0.322055
G1 F12897.01
G1 X188.15 Y203.047 E.00351
; LINE_WIDTH: 0.282816
G1 F15000
G1 X188.17 Y202.753 E.00558
; LINE_WIDTH: 0.258236
G1 X188.168 Y202.198 E.00944
; LINE_WIDTH: 0.288278
G1 F14672.439
G1 X188.147 Y201.923 E.00533
; LINE_WIDTH: 0.326649
G1 F12688.173
G1 X188.13 Y201.786 E.00311
; LINE_WIDTH: 0.362886
G1 F11251.219
G1 X188.11 Y201.631 E.00395
; LINE_WIDTH: 0.400696
G1 F10062.186
G1 X188.075 Y201.428 E.00581
; LINE_WIDTH: 0.436245
G1 F9152.735
G1 X188.039 Y201.225 E.00639
; WIPE_START
G1 X188.075 Y201.428 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X186.343 Y208.42 Z1 F60000
G1 Z.6
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42352
G1 F9458.749
M204 S8000
G1 X181.974 Y204.052 E.18573
G1 X181.974 Y204.59 E.01618
G1 X185.635 Y208.251 E.15563
G1 X185.096 Y208.251 E.01618
G1 X181.974 Y205.129 E.13274
G1 X181.974 Y205.667 E.01618
G1 X184.558 Y208.251 E.10986
G1 X184.02 Y208.251 E.01618
G1 X181.974 Y206.205 E.08697
G1 X181.974 Y206.743 E.01618
G1 X183.482 Y208.251 E.06408
G1 X182.943 Y208.251 E.01618
G1 X181.974 Y207.282 E.0412
G1 X181.974 Y207.82 E.01618
G1 X182.575 Y208.42 E.02553
; WIPE_START
G1 X181.974 Y207.82 E-.32267
G1 X181.974 Y207.282 E-.20454
G1 X182.408 Y207.715 E-.2328
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X183.033 Y200.108 Z1 F60000
G1 X188.32 Y135.844 Z1
G1 Z.6
G1 E.8 F1800
; LINE_WIDTH: 0.42088
G1 F9524.817
M204 S8000
G1 X187.726 Y135.249 E.0251
G1 X187.191 Y135.249 E.01596
G1 X188.151 Y136.209 E.0405
G1 X188.151 Y136.743 E.01596
G1 X186.657 Y135.249 E.06307
G1 X186.122 Y135.249 E.01596
G1 X187.674 Y136.801 E.0655
G1 X187.139 Y136.801 E.01596
G1 X185.588 Y135.249 E.0655
G1 X185.053 Y135.249 E.01596
G1 X186.605 Y136.801 E.0655
G1 X186.07 Y136.801 E.01596
G1 X184.519 Y135.249 E.0655
G1 X183.984 Y135.249 E.01596
G1 X185.536 Y136.801 E.0655
G1 X185.001 Y136.801 E.01596
G1 X183.45 Y135.249 E.0655
G1 X182.915 Y135.249 E.01596
G1 X184.466 Y136.801 E.0655
G1 X183.932 Y136.801 E.01596
G1 X182.381 Y135.249 E.0655
G1 X181.846 Y135.249 E.01596
G1 X183.397 Y136.801 E.0655
G1 X182.863 Y136.801 E.01596
G1 X181.312 Y135.249 E.0655
G1 X180.777 Y135.249 E.01596
G1 X182.328 Y136.801 E.0655
G1 X181.794 Y136.801 E.01596
G1 X180.243 Y135.249 E.0655
G1 X179.708 Y135.249 E.01596
G1 X181.259 Y136.801 E.0655
G1 X180.725 Y136.801 E.01596
G1 X179.174 Y135.249 E.0655
G1 X178.639 Y135.249 E.01596
G1 X180.19 Y136.801 E.0655
G1 X179.656 Y136.801 E.01596
G1 X178.105 Y135.249 E.0655
G1 X177.57 Y135.249 E.01596
G1 X179.121 Y136.801 E.0655
G1 X178.587 Y136.801 E.01596
G1 X177.036 Y135.249 E.0655
G1 X176.501 Y135.249 E.01596
G1 X178.052 Y136.801 E.0655
G1 X177.518 Y136.801 E.01596
G1 X175.966 Y135.249 E.0655
G1 X175.551 Y135.249 E.01242
G1 X175.551 Y134.834 E.01242
G1 X170.309 Y129.592 E.2213
G1 X170.309 Y129.249 E.01024
G1 X170.501 Y129.249 E.00572
G1 X175.551 Y134.299 E.21321
G1 X175.551 Y133.764 E.01596
G1 X171.036 Y129.249 E.19064
G1 X171.57 Y129.249 E.01596
G1 X175.551 Y133.23 E.16807
G1 X175.551 Y132.695 E.01596
G1 X172.105 Y129.249 E.1455
G1 X172.639 Y129.249 E.01596
G1 X175.551 Y132.161 E.12293
G1 X175.551 Y131.626 E.01596
G1 X173.174 Y129.249 E.10037
G1 X173.708 Y129.249 E.01596
G1 X175.551 Y131.092 E.0778
G1 X175.551 Y130.557 E.01596
G1 X174.243 Y129.249 E.05523
G1 X174.777 Y129.249 E.01596
G1 X175.551 Y130.023 E.03266
G1 X175.551 Y129.488 E.01596
G1 X175.142 Y129.08 E.01725
M204 S10000
G1 X176.087 Y129.025 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.66758
G1 F5763.136
M204 S8000
G1 X188.687 Y129.025 E.62173
; COOLING_NODE: 13
; WIPE_START
G1 X186.687 Y129.025 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X179.58 Y126.243 Z1 F60000
G1 X166.884 Y121.274 Z1
G1 Z.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X160.916 Y121.274 E.1919
G1 X160.916 Y111.416 E.31698
G1 X166.884 Y111.416 E.1919
G1 X166.884 Y116.247 E.15533
G1 X166.657 Y116.263 E.00732
G2 X166.658 Y116.74 I-2.555 J.243 E.50324
G1 X166.884 Y116.757 E.00729
G1 X166.884 Y121.214 E.14331
; COOLING_NODE: 13
; WIPE_START
G1 X164.884 Y121.234 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X164.978 Y114.533 Z1 F60000
G1 Z.6
G1 E.8 F1800
G1 F8843.478
M204 S8000
G1 X165.298 Y114.704 E.01166
G3 X163.872 Y114.352 I-1.2 J1.795 E.38807
G1 X164.088 Y114.34 E.00695
G3 X164.909 Y114.498 I.01 J2.159 E.02704
G1 X164.924 Y114.506 E.00056
; COOLING_NODE: 13
M204 S10000
G1 X164.788 Y114.891 F60000
G1 F8843.478
M204 S8000
G1 X165.072 Y115.043 E.01035
G3 X163.916 Y114.757 I-.973 J1.456 E.31486
G1 X164.091 Y114.747 E.00565
G3 X164.734 Y114.866 I.008 J1.752 E.02114
; COOLING_NODE: 13
M204 S250
G1 X164.609 Y115.239 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G3 X163.957 Y115.147 I-.51 J1.26 E.23462
G1 X164.094 Y115.14 E.00407
G3 X164.553 Y115.218 I.006 J1.359 E.01396
; COOLING_NODE: 13
; WIPE_START
M204 S8000
G1 X164.855 Y115.369 E-.12833
G1 X165.062 Y115.538 E-.10151
G1 X165.157 Y115.644 E-.05395
G1 X165.311 Y115.881 E-.10772
G1 X165.406 Y116.119 E-.09715
G1 X165.454 Y116.375 E-.0991
G1 X165.453 Y116.641 E-.10114
G1 X165.417 Y116.825 E-.0711
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X167.291 Y121.681 Z1 F60000
G1 Z.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X160.509 Y121.681 E.21808
G1 X160.509 Y111.009 E.34316
G1 X167.291 Y111.009 E.21808
G1 X167.291 Y121.621 E.34123
; COOLING_NODE: 13
M204 S10000
G1 X168.09 Y121.292 F60000
G1 F8843.478
M204 S8000
G1 X168.098 Y121.292 E.00025
G1 X168.098 Y122.088 E.02559
G1 X160.102 Y122.088 E.25712
G1 X160.102 Y110.602 E.36934
G1 X167.698 Y110.602 E.24426
G1 X167.698 Y121.292 E.34375
G1 X168.03 Y121.292 E.01068
; COOLING_NODE: 12
M204 S250
G1 X168.09 Y120.9 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2356
M204 S5000
G1 X168.49 Y120.9 E.01191
G1 X168.49 Y122.48 E.04706
G1 X159.71 Y122.48 E.26153
G1 X159.71 Y110.21 E.36548
G1 X168.09 Y110.21 E.24961
G1 X168.09 Y120.84 E.31663
; WIPE_START
G1 F9547.055
M204 S8000
G1 X168.49 Y120.9 E-.1537
G1 X168.49 Y122.48 E-.60041
G1 X168.474 Y122.48 E-.00589
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X166.488 Y117.949 Z1 F60000
G1 Z.6
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.125094
G1 F15000
M204 S8000
G1 X166.68 Y117.673 E.00218
; WIPE_START
G1 X166.488 Y117.949 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X166.524 Y116.501 Z1 F60000
G1 Z.6
G1 E.8 F1800
; LINE_WIDTH: 0.11409
G1 F15000
M204 S8000
G1 X166.806 Y116.502 E.00158
; LINE_WIDTH: 0.148427
G1 X167.087 Y116.502 E.00235
; WIPE_START
G1 X166.806 Y116.502 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X166.68 Y115.327 Z1 F60000
G1 Z.6
G1 E.8 F1800
; LINE_WIDTH: 0.125032
G1 F15000
M204 S8000
G1 X166.488 Y115.051 E.00218
M204 S10000
G1 X166.388 Y114.639 F60000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F9547.299
M204 S8000
G1 X166.492 Y114.544 E.00419
G1 X166.492 Y111.808 E.0815
G1 X161.308 Y111.808 E.15439
G1 X161.308 Y114.766 E.08811
G1 X161.618 Y114.654 E.00981
G1 X161.741 Y114.737 E.00444
G1 X162.015 Y114.4 E.01294
G1 X162.433 Y114.054 E.01614
G1 X162.879 Y113.808 E.01519
G1 X163.469 Y113.608 E.01854
G1 X163.811 Y113.554 E.01032
G1 X164.346 Y113.55 E.01593
G1 X164.9 Y113.651 E.01679
G1 X165.474 Y113.879 E.0184
G1 X165.949 Y114.189 E.01687
G3 X166.35 Y114.593 I-2.027 J2.41 E.01698
M204 S10000
G1 X166.115 Y113.846 F60000
G1 F9547.299
M204 S8000
G1 X166.115 Y112.185 E.04947
G1 X161.685 Y112.185 E.13193
G1 X161.689 Y114.19 E.05972
G1 X162.192 Y113.764 E.01964
G1 X162.7 Y113.477 E.01737
G1 X163.356 Y113.249 E.0207
G3 X164.97 Y113.28 I.736 J3.646 E.04846
G1 X165.616 Y113.529 E.02062
G1 X166.064 Y113.814 E.01582
M204 S10000
G1 X165.709 Y113.13 F60000
; LINE_WIDTH: 0.47686
G1 F8296.077
M204 S8000
G1 X165.709 Y112.591 E.01847
; LINE_WIDTH: 0.459268
G1 F8646.623
G1 X165.39 Y112.573 E.0105
; LINE_WIDTH: 0.424083
G1 F9444.791
G1 X165.072 Y112.556 E.00961
; LINE_WIDTH: 0.3819
G1 F10620.096
G1 X164.543 Y112.531 E.01418
; LINE_WIDTH: 0.363138
G1 F11242.351
G2 X163.194 Y112.552 I-.442 J15.284 E.03413
; LINE_WIDTH: 0.418598
G1 F9582.687
G1 X162.93 Y112.572 E.00785
; LINE_WIDTH: 0.458933
G1 F8653.586
G1 X162.666 Y112.592 E.0087
; LINE_WIDTH: 0.494735
G1 F7967.863
G1 X162.395 Y112.608 E.0097
; LINE_WIDTH: 0.536115
G1 F7299.35
G1 X162.123 Y112.623 E.01059
G1 X162.123 Y113.291 E.02603
G1 X162.547 Y113.07 E.01862
; LINE_WIDTH: 0.505272
G1 F7786.281
G1 X162.78 Y113.013 E.00877
; LINE_WIDTH: 0.462535
G1 F8579.292
G1 X163.014 Y112.956 E.00796
; LINE_WIDTH: 0.419799
G1 F9552.154
G1 X163.247 Y112.899 E.00715
; LINE_WIDTH: 0.374395
G1 F10860.548
G1 X163.805 Y112.835 E.01471
; LINE_WIDTH: 0.349265
G1 F11751.457
G1 X164.346 Y112.832 E.01308
; LINE_WIDTH: 0.36275
G1 F11255.979
G1 X164.692 Y112.874 E.00881
; LINE_WIDTH: 0.39191
G1 F10315.482
G1 X165.038 Y112.916 E.00962
; LINE_WIDTH: 0.424083
G1 F9444.791
G1 X165.224 Y112.963 E.00578
; LINE_WIDTH: 0.469416
G1 F8440.881
G3 X165.654 Y113.107 I-.298 J1.593 E.0153
; WIPE_START
G1 X165.411 Y113.009 E-.43841
G1 X165.224 Y112.963 E-.32159
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X161.599 Y115.289 Z1 F60000
G1 Z.6
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.387894
G1 F10435.574
M204 S8000
G1 X161.357 Y115.41 E.00737
; LINE_WIDTH: 0.415228
G1 F9669.432
G1 X161.341 Y115.419 E.00054
; LINE_WIDTH: 0.440391
G1 F9057.273
G1 X161.325 Y115.427 E.00058
; LINE_WIDTH: 0.432155
G1 F9248.916
G1 X161.304 Y115.552 E.00388
; LINE_WIDTH: 0.387969
G1 F10433.317
G1 X161.281 Y115.692 E.00387
; LINE_WIDTH: 0.350521
G1 F11703.471
G1 X161.266 Y115.817 E.00305
; LINE_WIDTH: 0.319726
G1 F13005.525
G1 X161.25 Y115.953 E.00299
; LINE_WIDTH: 0.284888
G1 F14878.018
G1 X161.231 Y116.212 E.00496
; LINE_WIDTH: 0.258284
G1 F15000
G1 X161.231 Y116.773 E.00954
; LINE_WIDTH: 0.285159
G1 F14861.357
G1 X161.251 Y117.062 E.00554
; LINE_WIDTH: 0.32375
G1 F12819.149
G1 X161.269 Y117.204 E.00318
; LINE_WIDTH: 0.360772
G1 F11326.04
G1 X161.289 Y117.363 E.00402
; LINE_WIDTH: 0.399113
G1 F10106.9
G1 X161.324 Y117.569 E.00588
; LINE_WIDTH: 0.435238
G1 F9176.243
G1 X161.36 Y117.774 E.00648
; WIPE_START
G1 X161.324 Y117.569 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X163.344 Y120.132 Z1 F60000
G1 Z.6
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.39296
G1 F10284.539
M204 S8000
G1 X163.677 Y120.15 E.0092
; LINE_WIDTH: 0.359915
G1 F11356.655
G2 X164.713 Y120.144 I.483 J-5.622 E.02599
; LINE_WIDTH: 0.39209
G1 F10310.164
G1 X164.726 Y120.143 E.00036
; WIPE_START
G1 X164.713 Y120.144 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X163.344 Y120.132 Z1 F60000
G1 Z.6
G1 E.8 F1800
; LINE_WIDTH: 0.419303
G1 F9564.731
M204 S8000
G3 X162.063 Y119.591 I.857 J-3.824 E.04158
G1 X162.063 Y120.127 E.01593
G3 X163.284 Y120.131 I.42 J61.523 E.03633
; WIPE_START
G1 X162.063 Y120.127 E-.46429
G1 X162.063 Y119.591 E-.20366
G1 X162.27 Y119.717 E-.09205
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X165.772 Y120.162 Z1 F60000
G1 Z.6
G1 E.8 F1800
; LINE_WIDTH: 0.361347
G1 F11305.593
M204 S8000
G1 X165.772 Y119.774 E.00975
G3 X164.852 Y120.143 I-5.457 J-12.281 E.02493
G2 X165.712 Y120.162 I.813 J-17.194 E.02163
M204 S10000
G1 X166.115 Y120.505 F60000
; LINE_WIDTH: 0.41999
G1 F9547.299
M204 S8000
G1 X166.115 Y119.149 E.04039
G1 X165.614 Y119.472 E.01774
G3 X164.15 Y119.835 I-1.598 J-3.307 E.04525
G1 X163.516 Y119.784 E.01895
G3 X162.04 Y119.123 I.745 J-3.643 E.04856
G1 X161.687 Y118.803 E.01418
G2 X161.685 Y120.505 I222.83 J1.107 E.05067
G1 X166.055 Y120.505 E.13014
M204 S10000
G1 X166.492 Y120.882 F60000
G1 F9547.299
M204 S8000
G1 X166.492 Y118.43 E.07303
G1 X166.385 Y118.381 E.00349
G1 X166.014 Y118.757 E.01574
G1 X165.504 Y119.106 E.01841
G1 X164.983 Y119.325 E.01684
G3 X163.553 Y119.409 I-.91 J-3.287 E.04298
G1 X163.215 Y119.324 E.01038
G1 X162.722 Y119.12 E.01589
G1 X162.249 Y118.809 E.01686
G1 X161.988 Y118.573 E.0105
G1 X161.643 Y118.123 E.01687
G1 X161.308 Y118.181 E.01011
G1 X161.308 Y120.882 E.08043
G1 X166.432 Y120.882 E.15261
; CHANGE_LAYER
; Z_HEIGHT: 0.75
; LAYER_HEIGHT: 0.15
; WIPE_START
G1 F9547.299
G1 X164.432 Y120.882 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 5/37
; update layer progress
M73 L5
M991 S0 P4 ;notify layer change

M106 S102
; OBJECT_ID: 15
M204 S10000
G17
G3 Z1 I-.893 J.827 P1  F60000
G1 X168.512 Y125.287 Z1
G1 Z.75
G1 E.8 F1800
; FEATURE: Support
; LINE_WIDTH: 0.42
; LAYER_HEIGHT: 0.275
G1 F7252.893
M204 S8000
G1 X168.512 Y123.229 E.08069
G1 X159.688 Y123.229 E.34594
G1 X159.688 Y125.475 E.08809
G1 X168.512 Y125.475 E.34594
G1 X168.512 Y126.961 E.05828
G1 X168.337 Y126.961 E.00685
G1 X168.021 Y127.277 E.01749
G1 X168.021 Y128.352 E.04216
G1 X159.688 Y128.352 E.32672
G1 X159.688 Y130.971 E.1027
G1 X168.021 Y130.971 E.32672
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

G1 X168.021 Y128.541 E.0953
; CHANGE_LAYER
; Z_HEIGHT: 0.8
; LAYER_HEIGHT: 0.05
; WIPE_START
G1 X168.021 Y130.541 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 6/37
; update layer progress
M73 L6
M991 S0 P5 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z1.15 I-.771 J.942 P1  F60000
G1 X188.525 Y147.313 Z1.15
M73 P49 R10
G1 Z.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
; LAYER_HEIGHT: 0.2
G1 F8843.478
M204 S8000
G1 X188.917 Y147.313 E.01261
G1 X188.917 Y181.697 E1.10567
G1 X182.473 Y181.697 E.20722
G1 X182.473 Y147.313 E1.10567
G1 X188.465 Y147.313 E.19268
; COOLING_NODE: 0
M204 S250
G1 X188.525 Y147.705 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X188.525 Y181.305 E1.00083
G1 X182.865 Y181.305 E.16859
G1 X182.865 Y147.705 E1.00083
G1 X188.465 Y147.705 E.1668
; COOLING_NODE: 0
; WIPE_START
M204 S8000
G1 X188.469 Y149.705 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X181.081 Y151.625 Z1.2 F60000
G1 X167.23 Y155.224 Z1.2
G1 Z.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X166.431 Y155.224 E.0257
G1 X166.431 Y150.766 E.14336
G1 X175.969 Y150.766 E.30672
G1 X175.969 Y155.224 E.14336
G1 X167.29 Y155.224 E.27909
; COOLING_NODE: 0
M204 S10000
G1 X167.23 Y154.817 F60000
G1 F8843.478
M204 S8000
G1 X166.838 Y154.817 E.01261
G1 X166.838 Y151.173 E.11718
G1 X175.562 Y151.173 E.28054
G1 X175.562 Y154.817 E.11718
G1 X167.29 Y154.817 E.266
; COOLING_NODE: 1
M204 S250
G1 X167.23 Y154.425 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X167.23 Y151.565 E.08519
G1 X175.17 Y151.565 E.23651
G1 X175.17 Y154.425 E.08519
G1 X167.29 Y154.425 E.23472
; COOLING_NODE: 1
; WIPE_START
M204 S8000
G1 X167.248 Y152.425 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X166.194 Y144.866 Z1.2 F60000
G1 X166.059 Y143.9 Z1.2
G1 Z.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X166.059 Y152.899 E.28938
G1 X161.341 Y152.899 E.15172
G1 X161.341 Y143.101 E.31508
G1 X166.059 Y143.101 E.15172
G1 X166.059 Y143.84 E.02377
; COOLING_NODE: 1
M204 S10000
G1 X165.652 Y143.9 F60000
G1 F8843.478
M204 S8000
G1 X165.652 Y152.492 E.27629
G1 X161.748 Y152.492 E.12554
G1 X161.748 Y143.508 E.2889
G1 X165.652 Y143.508 E.12554
G1 X165.652 Y143.84 E.01068
; COOLING_NODE: 2
M204 S250
G1 X165.26 Y143.9 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X165.26 Y152.1 E.24425
G1 X162.14 Y152.1 E.09293
G1 X162.14 Y143.9 E.24425
G1 X165.2 Y143.9 E.09115
; COOLING_NODE: 2
; WIPE_START
M204 S8000
G1 X165.215 Y145.9 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X161.834 Y142.694 Z1.2 F60000
G1 Z.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X160.916 Y142.694 E.02951
G1 X160.916 Y132.926 E.31409
G1 X161.834 Y132.926 E.02951
G1 X161.834 Y142.634 E.31216
; COOLING_NODE: 2
; WIPE_START
G1 X160.916 Y142.694 E-.34943
G1 X160.916 Y141.613 E-.41057
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X168.548 Y141.661 Z1.2 F60000
G1 X176.291 Y141.71 Z1.2
G1 Z.8
G1 E.8 F1800
G1 F8843.478
M204 S8000
G1 X176.291 Y137.541 E.13406
G1 X188.509 Y137.541 E.3929
G1 X188.509 Y142.509 E.15976
G1 X176.291 Y142.509 E.3929
G1 X176.291 Y141.77 E.02377
; COOLING_NODE: 2
M204 S10000
G1 X176.698 Y141.71 F60000
G1 F8843.478
M204 S8000
G1 X176.698 Y137.948 E.12097
G1 X188.102 Y137.948 E.36672
G1 X188.102 Y142.102 E.13358
G1 X176.698 Y142.102 E.36672
G1 X176.698 Y141.77 E.01068
; COOLING_NODE: 3
M204 S250
G1 X177.09 Y141.71 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X177.09 Y138.34 E.10038
G1 X187.71 Y138.34 E.31633
G1 X187.71 Y141.71 E.10038
G1 X177.15 Y141.71 E.31455
; COOLING_NODE: 3
; WIPE_START
M204 S8000
G1 X177.114 Y139.71 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X176 Y147.261 Z1.2 F60000
G1 X174.709 Y156.009 Z1.2
G1 Z.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X181.191 Y156.009 E.20845
G1 X181.191 Y160.991 E.16022
G1 X174.709 Y160.991 E.20845
G1 X174.709 Y156.069 E.15829
; COOLING_NODE: 3
; WIPE_START
G1 X176.709 Y156.05 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X180.784 Y159.785 Z1.2 F60000
G1 Z.8
G1 E.8 F1800
G1 F8843.478
M204 S8000
G1 X180.784 Y160.584 E.0257
G1 X175.116 Y160.584 E.18227
G1 X175.116 Y156.416 E.13404
G1 X180.784 Y156.416 E.18227
G1 X180.784 Y159.725 E.10641
; COOLING_NODE: 3
M204 S10000
G1 X180.377 Y159.785 F60000
G1 F8843.478
M204 S8000
G1 X180.377 Y160.177 E.01261
G1 X175.523 Y160.177 E.15609
G1 X175.523 Y156.823 E.10786
G1 X180.377 Y156.823 E.15609
G1 X180.377 Y159.725 E.09332
; COOLING_NODE: 4
M204 S250
G1 X179.985 Y159.785 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X175.915 Y159.785 E.12123
G1 X175.915 Y157.215 E.07655
G1 X179.985 Y157.215 E.12123
G1 X179.985 Y159.725 E.07476
; COOLING_NODE: 4
; WIPE_START
M204 S8000
G1 X177.985 Y159.754 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X179.055 Y167.312 Z1.2 F60000
G1 X183.749 Y200.465 Z1.2
G1 Z.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X184.056 Y200.253 E.012
G3 X185.026 Y199.947 I1.243 J2.245 E.03295
G1 X185.269 Y199.932 E.00783
G3 X183.645 Y200.536 I.029 J2.566 E.46167
G1 X183.699 Y200.499 E.0021
; COOLING_NODE: 4
M204 S10000
G1 X183.979 Y200.799 F60000
G1 F8843.478
M204 S8000
G1 X184.253 Y200.61 E.01071
G3 X185.07 Y200.352 I1.046 J1.889 E.02774
G1 X185.274 Y200.34 E.00656
G3 X183.909 Y200.847 I.025 J2.159 E.38843
G1 X183.929 Y200.833 E.00081
; COOLING_NODE: 4
M204 S10000
G1 X184.209 Y201.133 F60000
G1 F8843.478
M204 S8000
G1 X184.451 Y200.967 E.00943
G3 X185.114 Y200.757 I.849 J1.532 E.02253
G1 X185.278 Y200.747 E.00528
G3 X184.16 Y201.168 I.021 J1.752 E.31471
; COOLING_NODE: 5
M204 S250
G1 X184.431 Y201.455 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X184.641 Y201.31 E.00759
G3 X185.157 Y201.147 I.659 J1.189 E.01623
G1 X185.283 Y201.14 E.00376
G3 X184.385 Y201.494 I.017 J1.359 E.22502
; COOLING_NODE: 5
; WIPE_START
M204 S8000
G1 X184.641 Y201.31 E-.11956
G1 X184.881 Y201.206 E-.09959
G1 X185.157 Y201.147 E-.10712
G1 X185.283 Y201.14 E-.04793
G1 X185.559 Y201.165 E-.10547
G1 X185.809 Y201.239 E-.09894
G1 X186.041 Y201.359 E-.09936
G1 X186.21 Y201.494 E-.08203
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X186.382 Y193.863 Z1.2 F60000
G1 X187.71 Y134.916 Z1.2
G1 Z.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X188.484 Y134.916 E.02488
G1 X188.484 Y137.134 E.07131
G1 X175.884 Y137.134 E.40517
G1 X175.884 Y142.916 E.18594
G1 X188.484 Y142.916 E.40517
G1 X188.484 Y146.499 E.1152
G1 X181.659 Y146.499 E.21947
G1 X181.659 Y182.511 E1.15803
G1 X188.484 Y182.511 E.21947
G1 X188.484 Y208.584 E.8384
G1 X181.641 Y208.584 E.22003
G1 X181.641 Y192.784 E.50807
G1 X176.911 Y192.784 E.1521
G1 X176.911 Y186.889 E.18956
G1 X170.239 Y186.889 E.21456
G1 X170.239 Y192.784 E.18956
G1 X166.466 Y192.784 E.12131
G1 X166.466 Y177.459 E.4928
G1 X160.916 Y177.459 E.17847
G1 X160.916 Y168.566 E.28595
G1 X170.731 Y168.566 E.31561
G1 X170.731 Y159.234 E.3001
G1 X160.916 Y159.234 E.31561
G1 X160.916 Y153.306 E.19061
G1 X166.024 Y153.306 E.16424
G1 X166.024 Y155.631 E.07476
G1 X176.376 Y155.631 E.3329
G1 X176.376 Y150.359 E.16954
G1 X166.466 Y150.359 E.31867
G1 X166.466 Y142.806 E.24286
G1 X167.366 Y142.806 E.02894
G1 X167.366 Y132.926 E.3177
G1 X169.976 Y132.926 E.08393
G1 X169.976 Y128.916 E.12895
G1 X175.884 Y128.916 E.18997
G1 X175.884 Y134.916 E.19294
G1 X187.65 Y134.916 E.37836
; COOLING_NODE: 5
; WIPE_START
G1 X188.484 Y134.916 E-.31685
G1 X188.484 Y136.082 E-.44315
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X187.71 Y129.541 Z1.2 F60000
G1 Z.8
G1 E.8 F1800
G1 F8843.478
M204 S8000
G1 X188.509 Y129.541 E.0257
G1 X188.509 Y134.509 E.15976
G1 X176.291 Y134.509 E.3929
G1 X176.291 Y129.541 E.15976
G1 X187.65 Y129.541 E.36527
; COOLING_NODE: 5
M204 S10000
G1 X187.71 Y129.948 F60000
G1 F8843.478
M204 S8000
G1 X188.102 Y129.948 E.01261
G1 X188.102 Y134.102 E.13358
G1 X176.698 Y134.102 E.36672
G1 X176.698 Y129.948 E.13358
G1 X187.65 Y129.948 E.35218
; COOLING_NODE: 6
M204 S250
G1 X187.71 Y130.34 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X187.71 Y133.71 E.10038
G1 X177.09 Y133.71 E.31633
G1 X177.09 Y130.34 E.10038
G1 X187.65 Y130.34 E.31455
; COOLING_NODE: 6
; WIPE_START
M204 S8000
G1 X187.686 Y132.34 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X184.295 Y139.178 Z1.2 F60000
G1 X170.324 Y167.36 Z1.2
G1 Z.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X170.324 Y168.159 E.0257
G1 X161.065 Y168.159 E.29774
G1 X161.065 Y159.641 E.27392
G1 X170.324 Y159.641 E.29774
G1 X170.324 Y167.3 E.24629
; COOLING_NODE: 6
M204 S10000
G1 X169.917 Y167.36 F60000
G1 F8843.478
M204 S8000
G1 X169.917 Y167.752 E.01261
G1 X161.472 Y167.752 E.27156
G1 X161.472 Y160.048 E.24774
G1 X169.917 Y160.048 E.27156
G1 X169.917 Y167.3 E.2332
; COOLING_NODE: 7
M204 S250
G1 X169.525 Y167.36 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X161.864 Y167.36 E.22819
G1 X161.864 Y160.44 E.20612
G1 X169.525 Y160.44 E.22819
G1 X169.525 Y167.3 E.20434
; COOLING_NODE: 7
; WIPE_START
M204 S8000
G1 X167.525 Y167.316 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X166.87 Y174.92 Z1.2 F60000
G1 X166.059 Y184.325 Z1.2
G1 Z.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X166.059 Y185.124 E.0257
G1 X161.341 Y185.124 E.15172
G1 X161.341 Y177.866 E.2334
G1 X166.059 Y177.866 E.15172
G1 X166.059 Y184.265 E.20577
; COOLING_NODE: 7
M204 S10000
G1 X165.652 Y184.325 F60000
G1 F8843.478
M204 S8000
G1 X165.652 Y184.717 E.01261
M73 P50 R10
G1 X161.748 Y184.717 E.12554
G1 X161.748 Y178.273 E.20722
G1 X165.652 Y178.273 E.12554
G1 X165.652 Y184.265 E.19268
; COOLING_NODE: 8
M204 S250
G1 X165.26 Y184.325 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X162.14 Y184.325 E.09293
G1 X162.14 Y178.665 E.16859
G1 X165.26 Y178.665 E.09293
G1 X165.26 Y184.265 E.1668
; COOLING_NODE: 8
; WIPE_START
M204 S8000
G1 X163.26 Y184.303 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X167.533 Y177.979 Z1.2 F60000
G1 X188.525 Y146.906 Z1.2
G1 Z.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X182.066 Y146.906 E.2077
G1 X182.066 Y182.104 E1.13185
G1 X188.891 Y182.104 E.21947
G1 X188.891 Y208.991 E.86458
G1 X181.234 Y208.991 E.24621
G1 X181.234 Y193.191 E.50807
G1 X176.504 Y193.191 E.1521
G1 X176.504 Y187.296 E.18956
G1 X170.646 Y187.296 E.18838
G1 X170.646 Y193.191 E.18956
G1 X166.059 Y193.191 E.14749
G1 X166.059 Y185.866 E.23555
G1 X161.341 Y185.866 E.15172
G1 X161.341 Y193.191 E.23555
G1 X160.509 Y193.191 E.02675
G1 X160.509 Y132.519 E1.95098
G1 X162.241 Y132.519 E.05569
G1 X162.241 Y142.399 E.3177
G1 X166.959 Y142.399 E.15172
G1 X166.959 Y132.519 E.3177
G1 X169.569 Y132.519 E.08393
G1 X169.569 Y128.509 E.12895
G1 X188.891 Y128.509 E.62132
G1 X188.891 Y146.906 E.59157
G1 X188.585 Y146.906 E.00984
; COOLING_NODE: 8
; WIPE_START
G1 X186.585 Y146.906 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X179.164 Y145.121 Z1.2 F60000
G1 X166.16 Y141.992 Z1.2
G1 Z.8
G1 E.8 F1800
G1 F8843.478
M204 S8000
G1 X162.648 Y141.992 E.11294
G1 X162.648 Y133.008 E.2889
G1 X166.552 Y133.008 E.12554
G1 X166.552 Y141.992 E.2889
G1 X166.22 Y141.992 E.01068
; COOLING_NODE: 9
M204 S250
G1 X166.16 Y141.6 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X163.04 Y141.6 E.09293
G1 X163.04 Y133.4 E.24425
G1 X166.16 Y133.4 E.09293
G1 X166.16 Y141.54 E.24246
; COOLING_NODE: 9
; WIPE_START
M204 S8000
G1 X164.16 Y141.578 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X163.798 Y149.202 Z1.2 F60000
G1 X161.748 Y192.325 Z1.2
G1 Z.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X161.748 Y186.273 E.19461
G1 X165.652 Y186.273 E.12554
G1 X165.652 Y192.717 E.20722
G1 X161.748 Y192.717 E.12554
G1 X161.748 Y192.385 E.01068
; COOLING_NODE: 10
M204 S250
G1 X162.14 Y192.325 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X162.14 Y186.665 E.16859
G1 X165.26 Y186.665 E.09293
G1 X165.26 Y192.325 E.16859
G1 X162.2 Y192.325 E.09115
; COOLING_NODE: 10
; WIPE_START
M204 S8000
G1 X162.179 Y190.325 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X169.672 Y188.873 Z1.2 F60000
G1 X175.705 Y187.703 Z1.2
G1 Z.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X176.097 Y187.703 E.01261
G1 X176.097 Y192.697 E.16059
G1 X171.053 Y192.697 E.1622
G1 X171.053 Y187.703 E.16059
G1 X175.645 Y187.703 E.14766
; COOLING_NODE: 11
M204 S250
G1 X175.705 Y188.095 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X175.705 Y192.305 E.1254
G1 X171.445 Y192.305 E.12689
G1 X171.445 Y188.095 E.1254
G1 X175.645 Y188.095 E.1251
; COOLING_NODE: 11
; WIPE_START
M204 S8000
G1 X175.673 Y190.095 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X174.822 Y182.51 Z1.2 F60000
G1 X169.162 Y132.112 Z1.2
G1 Z.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X169.162 Y128.102 E.12895
G1 X189.298 Y128.102 E.6475
G1 X189.298 Y146.502 E.59168
G1 X189.898 Y146.502 E.01929
G1 X189.898 Y182.498 E1.1575
G1 X189.298 Y182.498 E.01929
G1 X189.298 Y209.398 E.86501
G1 X180.827 Y209.398 E.27239
G1 X180.827 Y193.598 E.50807
G1 X160.102 Y193.598 E.66644
G1 X160.102 Y132.112 E1.97716
G1 X169.102 Y132.112 E.28941
; COOLING_NODE: 12
M204 S250
G1 X168.77 Y131.72 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2252
M204 S5000
G1 X168.77 Y127.71 E.11944
G1 X189.69 Y127.71 E.62314
G1 X189.69 Y146.11 E.54807
G1 X190.29 Y146.11 E.01787
G1 X190.29 Y182.89 E1.09555
G1 X189.69 Y182.89 E.01787
G1 X189.69 Y209.79 E.80126
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

G1 X180.435 Y209.79 E.27568
G1 X180.435 Y193.99 E.47063
G1 X159.71 Y193.99 E.61733
G1 X159.71 Y131.72 E1.85481
G1 X168.71 Y131.72 E.26808
; WIPE_START
G1 F9547.055
M204 S8000
G1 X168.74 Y129.72 E-.76
; WIPE_END
M73 P51 R10
G1 E-.04 F1800
M204 S10000
G1 X167.965 Y133.09 Z1.2 F60000
G1 Z.8
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.4213
G1 F9514.245
M204 S8000
G1 X167.699 Y133.356 E.01124
G1 X167.699 Y133.891 E.01599
G1 X168.331 Y133.259 E.02668
G1 X168.866 Y133.259 E.01599
G1 X167.699 Y134.426 E.0493
G1 X167.699 Y134.961 E.01599
G1 X169.401 Y133.259 E.07192
G1 X169.936 Y133.259 E.01599
G1 X167.699 Y135.496 E.09454
G1 X167.699 Y136.031 E.01599
G1 X174.481 Y129.249 E.28666
G1 X175.016 Y129.249 E.01599
G1 X167.699 Y136.566 E.30928
G1 X167.699 Y137.101 E.01599
G1 X175.551 Y129.25 E.33187
G1 X175.551 Y129.785 E.01599
G1 X167.699 Y137.636 E.33187
G1 X167.699 Y138.172 E.01599
G1 X175.551 Y130.32 E.33187
G1 X175.551 Y130.855 E.01599
G1 X167.699 Y138.707 E.33187
G1 X167.699 Y139.242 E.01599
G1 X175.551 Y131.39 E.33187
G1 X175.551 Y131.926 E.01599
G1 X167.699 Y139.777 E.33187
G1 X167.699 Y140.312 E.01599
G1 X175.551 Y132.461 E.33187
G1 X175.551 Y132.996 E.01599
G1 X167.699 Y140.847 E.33187
G1 X167.699 Y141.382 E.01599
G1 X175.551 Y133.531 E.33187
G1 X175.551 Y134.066 E.01599
G1 X167.699 Y141.917 E.33187
G1 X167.699 Y142.452 E.01599
G1 X175.551 Y134.601 E.33187
G1 X175.551 Y135.136 E.01599
G1 X166.799 Y143.888 E.36992
G1 X166.799 Y144.423 E.01599
G1 X175.973 Y135.249 E.38775
G1 X176.508 Y135.249 E.01599
G1 X166.63 Y145.127 E.41754
; WIPE_START
G1 X168.044 Y143.713 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X167.182 Y142.97 Z1.2 F60000
G1 Z.8
G1 E.8 F1800
G1 F9514.245
M204 S8000
G1 X166.63 Y143.522 E.02335
M204 S10000
G1 X166.263 Y142.75 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.33758
G1 F12217.47
M204 S8000
G1 X162.037 Y142.75 E.09834
; WIPE_START
G1 X164.037 Y142.75 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X162.578 Y150.242 Z1.2 F60000
G1 X160.787 Y159.437 Z1.2
G1 Z.8
G1 E.8 F1800
; LINE_WIDTH: 0.19158
G1 F15000
M204 S8000
G1 X160.787 Y168.363 E.10481
M204 S10000
G1 X161.08 Y169.192 F60000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42065
G1 F9530.617
M204 S8000
G1 X161.372 Y168.899 E.01234
G1 X161.906 Y168.899 E.01594
G1 X161.249 Y169.556 E.02772
G1 X161.249 Y170.091 E.01594
G1 X162.441 Y168.899 E.05026
G1 X162.975 Y168.899 E.01594
G1 X161.249 Y170.625 E.07281
G1 X161.249 Y171.159 E.01594
G1 X163.509 Y168.899 E.09535
G1 X164.043 Y168.899 E.01594
G1 X161.249 Y171.693 E.11789
G1 X161.249 Y172.227 E.01594
G1 X164.577 Y168.899 E.14043
G1 X165.111 Y168.899 E.01594
G1 X161.249 Y172.761 E.16297
G1 X161.249 Y173.296 E.01594
G1 X165.646 Y168.899 E.18551
G1 X166.18 Y168.899 E.01594
G1 X161.249 Y173.83 E.20805
G1 X161.249 Y174.364 E.01594
G1 X166.714 Y168.899 E.23059
G1 X167.248 Y168.899 E.01594
G1 X161.249 Y174.898 E.25314
G1 X161.249 Y175.432 E.01594
G1 X167.782 Y168.899 E.27568
G1 X168.317 Y168.899 E.01594
G1 X161.249 Y175.967 E.29822
G1 X161.249 Y176.501 E.01594
G1 X168.851 Y168.899 E.32076
G1 X169.385 Y168.899 E.01594
G1 X161.249 Y177.035 E.3433
G1 X161.249 Y177.126 E.0027
G1 X161.693 Y177.126 E.01323
G1 X169.919 Y168.899 E.34713
G1 X170.453 Y168.899 E.01594
G1 X162.057 Y177.295 E.35429
; WIPE_START
G1 X163.472 Y175.881 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X160.925 Y177.662 Z1.2 F60000
G1 Z.8
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.467762
G1 F8473.752
M204 S8000
G1 X160.925 Y185.328 E.25724
G1 X160.941 Y185.411 E.00286
; LINE_WIDTH: 0.51702
G1 F7593.335
G1 X160.958 Y185.495 E.00319
; WIPE_START
G1 X160.941 Y185.411 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X165.03 Y191.856 Z1.2 F60000
G1 X165.855 Y193.158 Z1.2
G1 Z.8
G1 E.8 F1800
; LINE_WIDTH: 0.51671
G1 F7598.303
M204 S8000
G1 X161.544 Y193.158 E.16134
M204 S10000
G1 X160.925 Y192.987 F60000
; LINE_WIDTH: 0.46758
G1 F8477.369
M204 S8000
G1 X160.925 Y185.662 E.24572
; LINE_WIDTH: 0.503353
G1 F7818.736
G1 X160.958 Y185.495 E.0062
G1 X161.003 Y185.495 E.00163
; LINE_WIDTH: 0.475038
G1 F8331.074
G1 X161.048 Y185.495 E.00153
; LINE_WIDTH: 0.436047
G1 F9157.362
G1 X161.092 Y185.495 E.00139
; LINE_WIDTH: 0.397056
G1 F10165.602
G1 X161.137 Y185.495 E.00125
; LINE_WIDTH: 0.37757
G1 F10757.508
G1 X166.263 Y185.495 E.13549
; WIPE_START
G1 X164.263 Y185.495 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X166.63 Y189.283 Z1.2 F60000
G1 Z.8
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42065
G1 F9530.617
M204 S8000
G1 X181.326 Y174.587 E.62013
G1 X181.326 Y174.053 E.01594
G1 X166.799 Y188.579 E.61297
G1 X166.799 Y188.045 E.01594
G1 X181.326 Y173.519 E.61297
G1 X181.326 Y172.984 E.01594
G1 X166.799 Y187.511 E.61297
G1 X166.799 Y186.977 E.01594
G1 X181.326 Y172.45 E.61297
G1 X181.326 Y171.916 E.01594
G1 X166.799 Y186.442 E.61297
G1 X166.799 Y185.908 E.01594
G1 X181.326 Y171.382 E.61297
G1 X181.326 Y170.848 E.01594
G1 X166.799 Y185.374 E.61297
G1 X166.799 Y184.84 E.01594
G1 X181.326 Y170.314 E.61297
G1 X181.326 Y169.779 E.01594
G1 X166.799 Y184.306 E.61297
G1 X166.799 Y183.771 E.01594
G1 X181.326 Y169.245 E.61297
G1 X181.326 Y168.711 E.01594
G1 X166.799 Y183.237 E.61297
G1 X166.799 Y182.703 E.01594
G1 X181.326 Y168.177 E.61297
G1 X181.326 Y167.643 E.01594
G1 X166.799 Y182.169 E.61297
G1 X166.799 Y181.635 E.01594
G1 X181.326 Y167.108 E.61297
G1 X181.326 Y166.574 E.01594
G1 X166.799 Y181.1 E.61297
G1 X166.799 Y180.566 E.01594
G1 X181.326 Y166.04 E.61297
G1 X181.326 Y165.506 E.01594
G1 X166.799 Y180.032 E.61297
G1 X166.799 Y179.498 E.01594
G1 X181.326 Y164.972 E.61297
G1 X181.326 Y164.437 E.01594
G1 X166.799 Y178.964 E.61297
G1 X166.799 Y178.429 E.01594
G1 X181.326 Y163.903 E.61297
G1 X181.326 Y163.369 E.01594
G1 X166.799 Y177.895 E.61297
G1 X166.799 Y177.361 E.01594
G1 X181.326 Y162.835 E.61297
G1 X181.326 Y162.301 E.01594
G1 X166.501 Y177.126 E.62557
G1 X165.966 Y177.126 E.01594
G1 X181.326 Y161.766 E.64812
G1 X181.326 Y161.528 E.00712
G1 X181.04 Y161.518 E.00853
G1 X165.432 Y177.126 E.65861
G1 X164.898 Y177.126 E.01594
G1 X180.699 Y161.324 E.66677
G1 X180.165 Y161.324 E.01594
G1 X164.364 Y177.126 E.66677
G1 X163.83 Y177.126 E.01594
G1 X179.631 Y161.324 E.66677
G1 X179.097 Y161.324 E.01594
G1 X163.295 Y177.126 E.66677
G1 X162.761 Y177.126 E.01594
G1 X178.563 Y161.324 E.66677
G1 X178.028 Y161.324 E.01594
G1 X171.064 Y168.288 E.29386
G1 X171.064 Y167.754 E.01594
G1 X177.494 Y161.324 E.27132
G1 X176.96 Y161.324 E.01594
G1 X171.064 Y167.22 E.24878
G1 X171.064 Y166.686 E.01594
G1 X176.426 Y161.324 E.22624
G1 X175.892 Y161.324 E.01594
G1 X171.064 Y166.152 E.2037
G1 X171.064 Y165.617 E.01594
G1 X175.357 Y161.324 E.18116
G1 X174.823 Y161.324 E.01594
G1 X171.064 Y165.083 E.15862
G1 X171.064 Y164.549 E.01594
G1 X174.376 Y161.238 E.13973
G1 X174.376 Y160.704 E.01594
G1 X171.064 Y164.015 E.13973
G1 X171.064 Y163.481 E.01594
G1 X174.376 Y160.169 E.13973
G1 X174.376 Y159.635 E.01594
G1 X171.064 Y162.946 E.13973
G1 X171.064 Y162.412 E.01594
G1 X174.376 Y159.101 E.13973
G1 X174.376 Y158.567 E.01594
G1 X171.064 Y161.878 E.13973
G1 X171.064 Y161.344 E.01594
G1 X174.376 Y158.033 E.13973
G1 X174.376 Y157.498 E.01594
G1 X171.064 Y160.81 E.13973
G1 X171.064 Y160.276 E.01594
G1 X174.376 Y156.964 E.13973
G1 X174.376 Y156.43 E.01594
G1 X171.064 Y159.741 E.13973
G1 X171.064 Y159.207 E.01594
G1 X174.307 Y155.964 E.13684
G1 X173.773 Y155.964 E.01594
G1 X170.837 Y158.901 E.1239
G1 X170.302 Y158.901 E.01594
G1 X173.239 Y155.964 E.1239
G1 X172.705 Y155.964 E.01594
G1 X169.768 Y158.901 E.1239
G1 X169.234 Y158.901 E.01594
G1 X172.17 Y155.964 E.1239
G1 X171.636 Y155.964 E.01594
G1 X168.7 Y158.901 E.1239
G1 X168.166 Y158.901 E.01594
G1 X171.102 Y155.964 E.1239
G1 X170.568 Y155.964 E.01594
G1 X167.632 Y158.901 E.1239
G1 X167.097 Y158.901 E.01594
G1 X170.034 Y155.964 E.1239
G1 X169.499 Y155.964 E.01594
G1 X166.563 Y158.901 E.1239
G1 X166.029 Y158.901 E.01594
G1 X168.965 Y155.964 E.1239
G1 X168.431 Y155.964 E.01594
G1 X165.495 Y158.901 E.1239
G1 X164.961 Y158.901 E.01594
G1 X167.897 Y155.964 E.1239
G1 X167.363 Y155.964 E.01594
G1 X164.426 Y158.901 E.1239
G1 X163.892 Y158.901 E.01594
G1 X166.828 Y155.964 E.1239
G1 X166.294 Y155.964 E.01594
G1 X163.358 Y158.901 E.1239
G1 X162.824 Y158.901 E.01594
G1 X165.76 Y155.964 E.1239
G1 X165.691 Y155.964 E.00207
G1 X165.691 Y155.5 E.01387
G1 X162.29 Y158.901 E.14351
G1 X161.755 Y158.901 E.01594
G1 X165.691 Y154.965 E.16605
G1 X165.691 Y154.431 E.01594
G1 X161.249 Y158.873 E.18741
G1 X161.249 Y158.338 E.01594
G1 X165.691 Y153.897 E.18741
G1 X165.691 Y153.639 E.00769
G1 X165.414 Y153.639 E.00825
G1 X161.249 Y157.804 E.17574
G1 X161.249 Y157.27 E.01594
G1 X164.88 Y153.639 E.1532
G1 X164.346 Y153.639 E.01594
G1 X161.249 Y156.736 E.13066
G1 X161.249 Y156.202 E.01594
G1 X163.812 Y153.639 E.10812
M73 P52 R10
G1 X163.277 Y153.639 E.01594
G1 X161.249 Y155.667 E.08558
G1 X161.249 Y155.133 E.01594
G1 X162.743 Y153.639 E.06304
G1 X162.209 Y153.639 E.01594
G1 X161.249 Y154.599 E.04049
G1 X161.249 Y154.065 E.01594
G1 X161.844 Y153.47 E.02511
M204 S10000
G1 X160.925 Y153.103 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.46758
G1 F8477.369
M204 S8000
G1 X160.925 Y142.897 E.34233
M204 S10000
G1 X161.375 Y142.49 F60000
; LINE_WIDTH: 0.55344
G1 F7051.634
M204 S8000
G1 X161.375 Y133.13 E.37749
; WIPE_START
G1 X161.375 Y135.13 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X162.444 Y132.56 Z1.2 F60000
G1 Z.8
G1 E.8 F1800
; LINE_WIDTH: 0.53172
G1 F7364.976
M204 S8000
G1 X166.755 Y132.56 E.16645
; WIPE_START
G1 X164.755 Y132.56 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X170.14 Y133.056 Z1.2 F60000
G1 Z.8
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.4213
G1 F9514.245
M204 S8000
G1 X173.946 Y129.249 E.16089
G1 X173.411 Y129.249 E.01599
G1 X170.309 Y132.351 E.1311
G1 X170.309 Y131.816 E.01599
G1 X172.876 Y129.249 E.10848
G1 X172.341 Y129.249 E.01599
G1 X170.309 Y131.281 E.08586
G1 X170.309 Y130.746 E.01599
G1 X171.806 Y129.249 E.06324
G1 X171.27 Y129.249 E.01599
G1 X170.309 Y130.21 E.04062
G1 X170.309 Y129.675 E.01599
G1 X170.905 Y129.08 E.02518
; WIPE_START
G1 X170.309 Y129.675 E-.3201
G1 X170.309 Y130.21 E-.20334
G1 X170.75 Y129.77 E-.23656
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X176.087 Y129.025 Z1.2 F60000
G1 Z.8
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.66758
G1 F5763.136
M204 S8000
G1 X188.687 Y129.025 E.62173
; WIPE_START
G1 X186.687 Y129.025 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X187.586 Y136.604 Z1.2 F60000
G1 X187.629 Y136.97 Z1.2
G1 Z.8
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.4213
G1 F9514.245
M204 S8000
G1 X188.151 Y136.449 E.02203
G1 X188.151 Y135.914 E.01599
G1 X187.264 Y136.801 E.03748
G1 X186.729 Y136.801 E.01599
G1 X188.151 Y135.379 E.0601
G1 X188.151 Y135.249 E.00387
G1 X187.745 Y135.249 E.01212
G1 X186.194 Y136.801 E.06557
G1 X185.659 Y136.801 E.01599
G1 X187.21 Y135.249 E.06557
G1 X186.675 Y135.249 E.01599
G1 X185.124 Y136.801 E.06557
G1 X184.588 Y136.801 E.01599
G1 X186.14 Y135.249 E.06557
G1 X185.605 Y135.249 E.01599
G1 X184.053 Y136.801 E.06557
G1 X183.518 Y136.801 E.01599
G1 X185.07 Y135.249 E.06557
G1 X184.534 Y135.249 E.01599
G1 X182.983 Y136.801 E.06557
G1 X182.448 Y136.801 E.01599
G1 X183.999 Y135.249 E.06557
G1 X183.464 Y135.249 E.01599
G1 X181.913 Y136.801 E.06557
G1 X181.378 Y136.801 E.01599
G1 X182.929 Y135.249 E.06557
G1 X182.394 Y135.249 E.01599
G1 X180.843 Y136.801 E.06557
G1 X180.308 Y136.801 E.01599
G1 X181.859 Y135.249 E.06557
G1 X181.324 Y135.249 E.01599
G1 X179.772 Y136.801 E.06557
G1 X179.237 Y136.801 E.01599
G1 X180.789 Y135.249 E.06557
G1 X180.254 Y135.249 E.01599
G1 X178.702 Y136.801 E.06557
G1 X178.167 Y136.801 E.01599
G1 X179.718 Y135.249 E.06557
G1 X179.183 Y135.249 E.01599
G1 X177.632 Y136.801 E.06557
G1 X177.097 Y136.801 E.01599
G1 X178.648 Y135.249 E.06557
G1 X178.113 Y135.249 E.01599
G1 X176.562 Y136.801 E.06557
G1 X176.027 Y136.801 E.01599
G1 X177.578 Y135.249 E.06557
G1 X177.043 Y135.249 E.01599
G1 X166.799 Y145.493 E.43299
G1 X166.799 Y146.028 E.01599
G1 X175.551 Y137.277 E.36992
G1 X175.551 Y137.812 E.01599
G1 X166.799 Y146.563 E.36992
G1 X166.799 Y147.098 E.01599
G1 X175.551 Y138.347 E.36992
G1 X175.551 Y138.882 E.01599
G1 X166.799 Y147.633 E.36992
G1 X166.799 Y148.168 E.01599
G1 X175.551 Y139.417 E.36992
G1 X175.551 Y139.952 E.01599
G1 X166.799 Y148.704 E.36992
G1 X166.799 Y149.239 E.01599
G1 X175.551 Y140.487 E.36992
G1 X175.551 Y141.022 E.01599
G1 X166.799 Y149.774 E.36992
G1 X166.799 Y150.026 E.00753
G1 X167.083 Y150.026 E.00846
G1 X175.551 Y141.558 E.35794
G1 X175.551 Y142.093 E.01599
G1 X167.618 Y150.026 E.33533
G1 X168.153 Y150.026 E.01599
G1 X175.551 Y142.628 E.31271
G1 X175.551 Y143.163 E.01599
G1 X168.688 Y150.026 E.29009
G1 X169.223 Y150.026 E.01599
G1 X175.999 Y143.249 E.28643
G1 X176.534 Y143.249 E.01599
G1 X169.758 Y150.026 E.28643
G1 X170.293 Y150.026 E.01599
G1 X177.069 Y143.249 E.28643
G1 X177.605 Y143.249 E.01599
G1 X170.828 Y150.026 E.28643
G1 X171.363 Y150.026 E.01599
G1 X178.14 Y143.249 E.28643
G1 X178.675 Y143.249 E.01599
G1 X171.899 Y150.026 E.28643
G1 X172.434 Y150.026 E.01599
G1 X179.21 Y143.249 E.28643
G1 X179.745 Y143.249 E.01599
G1 X172.969 Y150.026 E.28643
G1 X173.504 Y150.026 E.01599
G1 X180.28 Y143.249 E.28643
G1 X180.815 Y143.249 E.01599
G1 X174.039 Y150.026 E.28643
G1 X174.574 Y150.026 E.01599
G1 X181.35 Y143.249 E.28643
G1 X181.885 Y143.249 E.01599
G1 X175.109 Y150.026 E.28643
G1 X175.644 Y150.026 E.01599
G1 X182.421 Y143.249 E.28643
G1 X182.956 Y143.249 E.01599
G1 X176.179 Y150.026 E.28643
G1 X176.709 Y150.031 E.01584
G1 X183.491 Y143.249 E.28665
G1 X184.026 Y143.249 E.01599
G1 X176.54 Y150.736 E.31644
; WIPE_START
G1 X177.954 Y149.321 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X180.096 Y156.647 Z1.2 F60000
G1 X181.425 Y161.195 Z1.2
G1 Z.8
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.10344
G1 F15000
M204 S8000
G1 X181.425 Y155.805 E.02576
M204 S10000
G1 X180.527 Y155.845 F60000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.4213
G1 F9514.245
M204 S8000
G1 X181.326 Y155.047 E.03377
G1 X181.326 Y154.511 E.01599
G1 X180.161 Y155.676 E.04921
G1 X179.626 Y155.676 E.01599
G1 X181.326 Y153.976 E.07183
G1 X181.326 Y153.441 E.01599
G1 X179.091 Y155.676 E.09445
G1 X178.556 Y155.676 E.01599
G1 X181.326 Y152.906 E.11707
G1 X181.326 Y152.371 E.01599
G1 X178.021 Y155.676 E.13969
G1 X177.486 Y155.676 E.01599
G1 X181.326 Y151.836 E.16231
G1 X181.326 Y151.301 E.01599
G1 X176.951 Y155.676 E.18493
G1 X176.709 Y155.676 E.00722
G1 X176.709 Y155.382 E.00878
G1 X181.326 Y150.766 E.19513
G1 X181.326 Y150.231 E.01599
G1 X176.709 Y154.847 E.19513
G1 X176.709 Y154.312 E.01599
G1 X181.326 Y149.695 E.19513
G1 X181.326 Y149.16 E.01599
G1 X176.709 Y153.777 E.19513
G1 X176.709 Y153.241 E.01599
G1 X181.326 Y148.625 E.19513
G1 X181.326 Y148.09 E.01599
G1 X176.709 Y152.706 E.19513
G1 X176.709 Y152.171 E.01599
G1 X181.326 Y147.555 E.19513
G1 X181.326 Y147.02 E.01599
G1 X176.709 Y151.636 E.19513
G1 X176.709 Y151.101 E.01599
G1 X184.561 Y143.249 E.33189
G1 X185.096 Y143.249 E.01599
G1 X182.18 Y146.166 E.12327
G1 X182.715 Y146.166 E.01599
G1 X185.631 Y143.249 E.12327
G1 X186.166 Y143.249 E.01599
G1 X183.25 Y146.166 E.12327
G1 X183.785 Y146.166 E.01599
G1 X186.701 Y143.249 E.12327
G1 X187.237 Y143.249 E.01599
G1 X184.32 Y146.166 E.12327
G1 X184.855 Y146.166 E.01599
G1 X187.772 Y143.249 E.12327
G1 X188.151 Y143.249 E.01133
G1 X188.151 Y143.406 E.00467
G1 X185.391 Y146.166 E.11667
G1 X185.926 Y146.166 E.01599
G1 X188.151 Y143.941 E.09405
G1 X188.151 Y144.476 E.01599
G1 X186.461 Y146.166 E.07143
G1 X186.996 Y146.166 E.01599
G1 X188.151 Y145.011 E.04881
G1 X188.151 Y145.546 E.01599
G1 X187.531 Y146.166 E.02619
G1 X188.066 Y146.166 E.01599
G1 X188.32 Y145.911 E.01075
; WIPE_START
G1 X188.066 Y146.166 E-.13662
G1 X187.531 Y146.166 E-.20334
G1 X188.151 Y145.546 E-.33301
G1 X188.151 Y145.317 E-.08703
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X189.095 Y147.093 Z1.2 F60000
G1 Z.8
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.118631
G1 F15000
M204 S8000
G1 X189.12 Y147.083 E.00016
; LINE_WIDTH: 0.165653
G1 X189.146 Y147.074 E.00027
; LINE_WIDTH: 0.212674
G1 X189.172 Y147.065 E.00037
; LINE_WIDTH: 0.259695
G1 X189.198 Y147.055 E.00047
; LINE_WIDTH: 0.306717
G1 F13646.879
G1 X189.224 Y147.046 E.00057
; LINE_WIDTH: 0.353738
G1 F11582.34
G1 X189.25 Y147.037 E.00068
; LINE_WIDTH: 0.40076
G1 F10060.376
G1 X189.276 Y147.028 E.00078
; LINE_WIDTH: 0.447781
G1 F8891.942
G1 X189.302 Y147.018 E.00088
; LINE_WIDTH: 0.494803
G1 F7966.675
G1 X189.327 Y147.009 E.00098
; LINE_WIDTH: 0.541824
G1 F7215.819
G1 X189.353 Y147 E.00108
; LINE_WIDTH: 0.588846
G1 F6594.309
G1 X189.379 Y146.99 E.00119
; LINE_WIDTH: 0.616778
G1 F6273.336
G1 X189.398 Y147.002 E.001
G1 X189.408 Y147.109 E.00487
G1 X189.408 Y181.901 E1.57711
G1 X189.399 Y181.999 E.00448
G1 X189.371 Y182.018 E.00153
; LINE_WIDTH: 0.573214
G1 F6788.692
G1 X189.346 Y182.009 E.00112
; LINE_WIDTH: 0.527681
G1 F7426.342
G1 X189.321 Y182 E.00102
; LINE_WIDTH: 0.482149
G1 F8196.196
G1 X189.296 Y181.99 E.00093
; LINE_WIDTH: 0.436616
G1 F9144.123
G1 X189.27 Y181.981 E.00083
; LINE_WIDTH: 0.391083
G1 F10339.991
G1 X189.245 Y181.972 E.00074
; LINE_WIDTH: 0.34555
G1 F11895.715
G1 X189.22 Y181.963 E.00064
; LINE_WIDTH: 0.300018
G1 F14002.483
G1 X189.195 Y181.954 E.00054
; LINE_WIDTH: 0.254485
G1 F15000
G1 X189.17 Y181.945 E.00045
; LINE_WIDTH: 0.208952
G1 X189.145 Y181.936 E.00035
; LINE_WIDTH: 0.163419
G1 X189.12 Y181.926 E.00025
; LINE_WIDTH: 0.117887
G1 X189.095 Y181.917 E.00016
; WIPE_START
G1 X189.12 Y181.926 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X183.377 Y186.953 Z1.2 F60000
G1 X176.301 Y193.148 Z1.2
G1 Z.8
G1 E.8 F1800
; LINE_WIDTH: 0.53672
G1 F7290.401
M204 S8000
G1 X170.849 Y193.148 E.21263
; WIPE_START
G1 X172.849 Y193.148 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X170.075 Y192.248 Z1.2 F60000
G1 Z.8
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42065
G1 F9530.617
M204 S8000
G1 X169.872 Y192.451 E.00857
G1 X169.338 Y192.451 E.01594
G1 X169.906 Y191.883 E.02395
G1 X169.906 Y191.349 E.01594
G1 X168.804 Y192.451 E.04649
G1 X168.27 Y192.451 E.01594
G1 X169.906 Y190.815 E.06903
G1 X169.906 Y190.281 E.01594
G1 X167.736 Y192.451 E.09157
G1 X167.201 Y192.451 E.01594
G1 X169.906 Y189.746 E.11411
G1 X169.906 Y189.212 E.01594
G1 X166.799 Y192.318 E.13108
G1 X166.799 Y191.784 E.01594
G1 X169.906 Y188.678 E.13108
G1 X169.906 Y188.144 E.01594
G1 X166.799 Y191.25 E.13108
G1 X166.799 Y190.716 E.01594
G1 X169.906 Y187.61 E.13108
G1 X169.906 Y187.075 E.01594
G1 X166.799 Y190.182 E.13108
G1 X166.799 Y189.648 E.01594
G1 X181.326 Y175.121 E.61297
G1 X181.326 Y175.655 E.01594
G1 X170.425 Y186.556 E.45996
G1 X170.96 Y186.556 E.01594
G1 X181.326 Y176.19 E.43742
G1 X181.326 Y176.724 E.01594
G1 X171.494 Y186.556 E.41488
G1 X172.028 Y186.556 E.01594
G1 X181.326 Y177.258 E.39234
G1 X181.326 Y177.792 E.01594
G1 X172.562 Y186.556 E.36979
G1 X173.096 Y186.556 E.01594
G1 X181.326 Y178.326 E.34725
G1 X181.326 Y178.861 E.01594
G1 X173.631 Y186.556 E.32471
G1 X174.165 Y186.556 E.01594
G1 X181.326 Y179.395 E.30217
G1 X181.326 Y179.929 E.01594
G1 X174.699 Y186.556 E.27963
G1 X175.233 Y186.556 E.01594
G1 X181.326 Y180.463 E.25709
G1 X181.326 Y180.997 E.01594
G1 X175.767 Y186.556 E.23455
G1 X176.302 Y186.556 E.01594
G1 X181.326 Y181.532 E.212
G1 X181.326 Y182.066 E.01594
G1 X176.836 Y186.556 E.18946
G1 X177.244 Y186.556 E.01219
G1 X177.244 Y186.681 E.00375
G1 X181.326 Y182.6 E.17222
G1 X181.326 Y182.844 E.00729
G1 X181.615 Y182.844 E.00864
G1 X177.244 Y187.215 E.18444
G1 X177.244 Y187.75 E.01594
G1 X182.15 Y182.844 E.20699
G1 X182.684 Y182.844 E.01594
G1 X177.244 Y188.284 E.22953
G1 X177.244 Y188.818 E.01594
G1 X183.218 Y182.844 E.25207
G1 X183.752 Y182.844 E.01594
G1 X177.244 Y189.352 E.27461
G1 X177.244 Y189.886 E.01594
G1 X184.286 Y182.844 E.29715
G1 X184.82 Y182.844 E.01594
G1 X177.244 Y190.421 E.31969
G1 X177.244 Y190.955 E.01594
G1 X185.355 Y182.844 E.34223
G1 X185.889 Y182.844 E.01594
G1 X177.244 Y191.489 E.36477
G1 X177.244 Y192.023 E.01594
G1 X186.423 Y182.844 E.38732
G1 X186.957 Y182.844 E.01594
G1 X177.351 Y192.451 E.40536
G1 X177.885 Y192.451 E.01594
G1 X187.491 Y182.844 E.40536
G1 X188.026 Y182.844 E.01594
G1 X178.419 Y192.451 E.40536
G1 X178.954 Y192.451 E.01594
G1 X188.151 Y183.254 E.38809
G1 X188.151 Y183.788 E.01594
G1 X179.488 Y192.451 E.36555
G1 X180.022 Y192.451 E.01594
G1 X188.151 Y184.322 E.34301
G1 X188.151 Y184.856 E.01594
G1 X180.556 Y192.451 E.32047
G1 X181.09 Y192.451 E.01594
M73 P52 R9
G1 X188.151 Y185.39 E.29793
G1 X188.151 Y185.925 E.01594
G1 X181.625 Y192.451 E.27538
G1 X181.974 Y192.451 E.01044
G1 X181.974 Y192.635 E.0055
G1 X188.151 Y186.459 E.26062
G1 X188.151 Y186.993 E.01594
G1 X181.974 Y193.169 E.26062
G1 X181.974 Y193.703 E.01594
G1 X188.151 Y187.527 E.26062
G1 X188.151 Y188.061 E.01594
G1 X181.974 Y194.238 E.26062
G1 X181.974 Y194.772 E.01594
M73 P53 R9
G1 X188.151 Y188.595 E.26062
G1 X188.151 Y189.13 E.01594
G1 X181.974 Y195.306 E.26062
G1 X181.974 Y195.84 E.01594
G1 X188.151 Y189.664 E.26062
G1 X188.151 Y190.198 E.01594
G1 X181.974 Y196.374 E.26062
G1 X181.974 Y196.909 E.01594
G1 X188.151 Y190.732 E.26062
G1 X188.151 Y191.266 E.01594
G1 X181.974 Y197.443 E.26062
G1 X181.974 Y197.977 E.01594
G1 X188.151 Y191.801 E.26062
G1 X188.151 Y192.335 E.01594
G1 X181.974 Y198.511 E.26062
G1 X181.974 Y199.045 E.01594
G1 X188.151 Y192.869 E.26062
G1 X188.151 Y193.403 E.01594
G1 X181.974 Y199.579 E.26062
G1 X181.974 Y200.114 E.01594
G1 X188.151 Y193.937 E.26062
G1 X188.151 Y194.472 E.01594
G1 X181.974 Y200.648 E.26062
G1 X181.974 Y201.182 E.01594
G1 X188.151 Y195.006 E.26062
G1 X188.151 Y195.54 E.01594
G1 X181.805 Y201.886 E.26778
; WIPE_START
G1 X183.219 Y200.472 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X187.802 Y203.712 Z1.2 F60000
G1 Z.8
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.433869
G1 F9208.362
M204 S8000
G1 X188.076 Y203.573 E.00947
G1 X188.097 Y203.441 E.00412
; LINE_WIDTH: 0.387287
G1 F10453.961
G1 X188.119 Y203.31 E.00363
; LINE_WIDTH: 0.347034
G1 F11837.694
G1 X188.137 Y203.152 E.00381
; LINE_WIDTH: 0.312892
G1 F13334.752
G1 X188.153 Y203.01 E.00305
; LINE_WIDTH: 0.265442
G1 F15000
G1 X188.172 Y202.712 E.00526
G1 X188.166 Y202.162 E.00967
; LINE_WIDTH: 0.293187
G1 F14384.676
G1 X188.144 Y201.896 E.00527
; LINE_WIDTH: 0.333907
G1 F12371.714
G1 X188.125 Y201.749 E.00342
; LINE_WIDTH: 0.370734
G1 F10981.835
G1 X188.108 Y201.614 E.00351
; LINE_WIDTH: 0.407197
G1 F9882.6
G1 X188.072 Y201.411 E.00593
; LINE_WIDTH: 0.438989
G1 F9089.335
G1 X188.038 Y201.225 E.00592
; WIPE_START
G1 X188.072 Y201.411 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X188.32 Y200.178 Z1.2 F60000
G1 Z.8
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42065
G1 F9530.617
M204 S8000
G1 X187.662 Y200.836 E.02778
G2 X187.426 Y200.538 I-.883 J.456 E.01142
G1 X188.151 Y199.813 E.03058
G1 X188.151 Y199.279 E.01594
G1 X187.156 Y200.274 E.04197
G2 X186.848 Y200.048 I-2.339 J2.86 E.01141
G1 X188.151 Y198.745 E.05497
G1 X188.151 Y198.211 E.01594
G1 X186.496 Y199.866 E.06984
G1 X186.113 Y199.714 E.01228
G1 X188.151 Y197.677 E.08598
G1 X188.151 Y197.143 E.01594
G1 X185.664 Y199.629 E.10492
G1 X185.555 Y199.608 E.00331
G1 X185.147 Y199.612 E.0122
G1 X188.151 Y196.608 E.12676
G1 X188.151 Y196.074 E.01594
G1 X184.514 Y199.711 E.15345
G1 X184.403 Y199.74 E.00343
G1 X183.894 Y199.96 E.01656
G2 X182.691 Y201.229 I1.481 J2.608 E.05294
G1 X182.507 Y201.717 E.01556
G1 X181.974 Y202.25 E.02249
G1 X181.974 Y202.785 E.01594
G1 X182.407 Y202.352 E.01824
G1 X182.423 Y202.87 E.01546
G1 X181.974 Y203.319 E.01892
G1 X181.974 Y203.853 E.01594
G1 X182.52 Y203.307 E.02302
G2 X182.668 Y203.693 I1.059 J-.186 E.01241
G1 X181.974 Y204.387 E.02929
G1 X181.974 Y204.921 E.01594
G1 X182.854 Y204.042 E.03711
G1 X183.072 Y204.358 E.01146
G1 X181.974 Y205.456 E.04632
G1 X181.974 Y205.99 E.01594
G1 X183.334 Y204.63 E.05736
G2 X183.63 Y204.869 I1.388 J-1.422 E.01135
G1 X181.974 Y206.524 E.06985
G1 X181.974 Y207.058 E.01594
G1 X183.96 Y205.072 E.08379
G1 X184.34 Y205.227 E.01223
G1 X181.974 Y207.592 E.09982
G1 X181.974 Y208.127 E.01594
G1 X184.753 Y205.348 E.11726
G2 X185.238 Y205.398 I.582 J-3.282 E.01454
G1 X182.384 Y208.251 E.12039
G1 X182.919 Y208.251 E.01594
G1 X185.818 Y205.351 E.12235
G2 X186.632 Y205.071 I-.504 J-2.788 E.02579
G1 X183.453 Y208.251 E.13417
G1 X183.987 Y208.251 E.01594
G1 X188.019 Y204.218 E.17016
G1 X188.151 Y204.152 E.00439
G1 X188.151 Y204.621 E.01401
G1 X184.521 Y208.251 E.15315
G1 X185.055 Y208.251 E.01594
G1 X188.151 Y205.155 E.13061
G1 X188.151 Y205.69 E.01594
G1 X185.59 Y208.251 E.10807
G1 X186.124 Y208.251 E.01594
G1 X188.151 Y206.224 E.08553
G1 X188.151 Y206.758 E.01594
G1 X186.658 Y208.251 E.06299
G1 X187.192 Y208.251 E.01594
G1 X188.151 Y207.292 E.04045
G1 X188.151 Y207.826 E.01594
G1 X187.557 Y208.42 E.02506
; COOLING_NODE: 13
; WIPE_START
G1 X188.151 Y207.826 E-.3192
G1 X188.151 Y207.292 E-.20299
G1 X187.708 Y207.735 E-.23781
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X185.928 Y200.313 Z1.2 F60000
G1 X166.884 Y120.9 Z1.2
G1 Z.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X166.884 Y121.274 E.01202
G1 X160.916 Y121.274 E.1919
G1 X160.916 Y111.416 E.31698
G1 X166.884 Y111.416 E.1919
G1 X166.884 Y116.237 E.15501
G1 X166.66 Y116.255 E.00723
G2 X166.57 Y117.203 I-2.556 J.236 E.48778
G2 X166.654 Y116.74 I-2.169 J-.636 E.01518
G1 X166.884 Y116.754 E.00739
G1 X166.884 Y120.84 E.1314
; COOLING_NODE: 13
; WIPE_START
G1 X166.884 Y121.274 E-.16484
G1 X165.318 Y121.274 E-.59516
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X164.973 Y114.53 Z1.2 F60000
G1 Z.8
G1 E.8 F1800
G1 F8843.478
M204 S8000
G1 X165.273 Y114.687 E.0109
G3 X163.871 Y114.352 I-1.175 J1.811 E.38894
G1 X164.074 Y114.34 E.00653
G3 X164.906 Y114.496 I.025 J2.159 E.0274
G1 X164.919 Y114.503 E.00048
; COOLING_NODE: 13
M204 S10000
G1 X164.786 Y114.891 F60000
G1 F8843.478
M204 S8000
G1 X165.053 Y115.03 E.00966
G3 X163.915 Y114.757 I-.953 J1.469 E.31556
G1 X164.078 Y114.747 E.00526
G3 X164.732 Y114.866 I.021 J1.752 E.02148
; COOLING_NODE: 13
M204 S250
G1 X164.609 Y115.239 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G3 X163.957 Y115.147 I-.509 J1.26 E.23461
G1 X164.083 Y115.14 E.00374
G3 X164.553 Y115.218 I.017 J1.359 E.01427
; COOLING_NODE: 13
; WIPE_START
M204 S8000
G1 X164.84 Y115.359 E-.12167
G1 X165.045 Y115.522 E-.09948
G1 X165.215 Y115.72 E-.09915
G1 X165.345 Y115.953 E-.10131
G1 X165.43 Y116.216 E-.10532
G1 X165.46 Y116.475 E-.09891
G1 X165.44 Y116.736 E-.09956
G1 X165.415 Y116.824 E-.03459
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X167.291 Y120.9 Z1.2 F60000
G1 Z.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X167.291 Y121.681 E.02511
G1 X160.509 Y121.681 E.21808
G1 X160.509 Y111.009 E.34316
G1 X167.291 Y111.009 E.21808
G1 X167.291 Y120.84 E.31613
; COOLING_NODE: 13
M204 S10000
G1 X167.698 Y120.9 F60000
G1 F8843.478
M204 S8000
G1 X167.698 Y121.292 E.01261
G1 X168.098 Y121.292 E.01286
G1 X168.098 Y122.088 E.02559
G1 X160.102 Y122.088 E.25712
G1 X160.102 Y110.602 E.36934
G1 X167.698 Y110.602 E.24426
G1 X167.698 Y120.84 E.32921
; COOLING_NODE: 12
M204 S250
G1 X168.09 Y120.9 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2252
M204 S5000
G1 X168.49 Y120.9 E.01191
G1 X168.49 Y122.48 E.04706
G1 X159.71 Y122.48 E.26153
G1 X159.71 Y110.21 E.36548
G1 X168.09 Y110.21 E.24961
G1 X168.09 Y120.84 E.31663
; WIPE_START
G1 F9547.055
M204 S8000
G1 X168.49 Y120.9 E-.1537
G1 X168.49 Y122.48 E-.60041
G1 X168.474 Y122.48 E-.00589
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X166.499 Y117.93 Z1.2 F60000
G1 Z.8
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.122323
G1 F15000
M204 S8000
G1 X166.68 Y117.666 E.00201
; WIPE_START
G1 X166.499 Y117.93 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X166.783 Y116.496 Z1.2 F60000
G1 Z.8
G1 E.8 F1800
; LINE_WIDTH: 0.115498
G1 F15000
M204 S8000
G1 X166.479 Y116.5 E.00174
M204 S10000
G1 X166.783 Y116.496 F60000
; LINE_WIDTH: 0.152656
G1 F15000
M204 S8000
G1 X167.087 Y116.493 E.00264
; WIPE_START
G1 X166.783 Y116.496 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X166.68 Y115.312 Z1.2 F60000
G1 Z.8
G1 E.8 F1800
; LINE_WIDTH: 0.138523
G1 F15000
M204 S8000
G1 X166.554 Y115.13 E.00167
; LINE_WIDTH: 0.108877
G1 X166.462 Y115.01 E.00079
; WIPE_START
G1 X166.554 Y115.13 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X165.712 Y113.137 Z1.2 F60000
G1 Z.8
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.47146
G1 F8400.616
M204 S8000
G1 X165.712 Y112.588 E.01857
; LINE_WIDTH: 0.451325
G1 F8814.78
G1 X165.326 Y112.568 E.01245
; LINE_WIDTH: 0.411055
G1 F9779.021
G1 X164.941 Y112.548 E.01123
; LINE_WIDTH: 0.359943
G1 F11355.658
G2 X163.801 Y112.528 I-.836 J15.005 E.02856
; LINE_WIDTH: 0.36859
G1 F11054.134
G1 X163.406 Y112.546 E.01017
; LINE_WIDTH: 0.40471
G1 F9950.523
G1 X163.011 Y112.564 E.0113
; LINE_WIDTH: 0.442784
G1 F9003.077
G1 X162.798 Y112.584 E.00673
; LINE_WIDTH: 0.48281
G1 F8183.864
G1 X162.586 Y112.604 E.00741
; LINE_WIDTH: 0.540056
G1 F7241.482
G3 X162.124 Y112.624 I-.337 J-2.442 E.0182
G1 X162.124 Y113.291 E.02621
G1 X162.473 Y113.103 E.01557
; LINE_WIDTH: 0.522837
G1 F7501.302
G1 X162.665 Y113.049 E.00758
; LINE_WIDTH: 0.48281
G1 F8183.864
G1 X162.858 Y112.994 E.00695
; LINE_WIDTH: 0.442784
G1 F9003.077
G1 X163.05 Y112.94 E.00632
; LINE_WIDTH: 0.407625
G1 F9870.991
G1 X163.335 Y112.894 E.00832
; LINE_WIDTH: 0.364409
G1 F11197.91
G1 X163.621 Y112.849 E.00734
G1 X164.331 Y112.832 E.01804
G1 X164.892 Y112.889 E.01432
; LINE_WIDTH: 0.409888
G1 F9810.133
G1 X165.149 Y112.945 E.00764
; LINE_WIDTH: 0.458676
G1 F8658.931
G3 X165.657 Y113.112 I-.151 J1.314 E.01768
M204 S10000
G1 X166.115 Y113.855 F60000
; LINE_WIDTH: 0.41999
G1 F9547.299
M204 S8000
G1 X166.115 Y112.185 E.04973
G1 X161.685 Y112.185 E.13193
G1 X161.685 Y114.218 E.06054
G1 X161.997 Y113.911 E.01302
G1 X162.436 Y113.609 E.01588
G1 X163.022 Y113.344 E.01914
G1 X163.693 Y113.19 E.02052
G1 X164.334 Y113.173 E.0191
G3 X166.066 Y113.819 I-.223 J3.24 E.05585
M204 S10000
G1 X166.35 Y114.601 F60000
G1 F9547.299
M204 S8000
G1 X166.438 Y114.535 E.00326
G1 X166.492 Y114.543 E.00164
G1 X166.492 Y111.808 E.08147
G1 X161.308 Y111.808 E.15439
G1 X161.308 Y114.811 E.08944
G1 X161.633 Y114.879 E.00988
G1 X161.78 Y114.663 E.00777
G1 X162.182 Y114.246 E.01727
G1 X162.65 Y113.919 E.017
G1 X163.171 Y113.69 E.01696
G1 X163.771 Y113.559 E.0183
G1 X164.337 Y113.55 E.01686
G3 X165.688 Y114.003 I-.387 J3.396 E.04275
G1 X166.144 Y114.36 E.01725
G1 X166.311 Y114.555 E.00767
; WIPE_START
G1 X166.144 Y114.36 E-.09785
G1 X165.688 Y114.003 E-.22006
G1 X165.192 Y113.748 E-.21195
G1 X164.683 Y113.598 E-.20172
G1 X164.608 Y113.588 E-.02842
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X161.367 Y115.224 Z1.2 F60000
G1 Z.8
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.451924
G1 F8801.886
M204 S8000
G1 X161.32 Y115.447 E.00737
; LINE_WIDTH: 0.42284
G1 F9475.677
G1 X161.299 Y115.583 E.00412
; LINE_WIDTH: 0.377277
G1 F10766.958
G1 X161.275 Y115.733 E.00402
; LINE_WIDTH: 0.339397
G1 F12142.615
G1 X161.261 Y115.865 E.0031
; LINE_WIDTH: 0.308923
G1 F13533.723
G1 X161.245 Y116.009 E.00304
; LINE_WIDTH: 0.264937
G1 F15000
G1 X161.224 Y116.553 E.00956
G1 X161.235 Y116.858 E.00534
; LINE_WIDTH: 0.286276
G1 F14793.163
G1 X161.248 Y117.002 E.00279
; LINE_WIDTH: 0.312858
G1 F13336.435
G1 X161.262 Y117.161 E.0034
; LINE_WIDTH: 0.346766
G1 F11848.13
G1 X161.281 Y117.299 E.00335
; LINE_WIDTH: 0.387802
G1 F10438.371
G1 X161.303 Y117.455 E.00428
; LINE_WIDTH: 0.432326
G1 F9244.85
G1 X161.364 Y117.775 E.01001
; WIPE_START
G1 X161.303 Y117.455 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X163.214 Y120.116 Z1.2 F60000
G1 Z.8
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.420675
G1 F9529.986
M204 S8000
G1 X163.473 Y120.138 E.00777
; LINE_WIDTH: 0.360047
G1 F11351.92
G2 X164.536 Y120.157 I.742 J-12.026 E.02662
; WIPE_START
G1 X163.733 Y120.16 E-.57387
G1 X163.473 Y120.138 E-.18613
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X163.214 Y120.116 Z1.2 F60000
G1 Z.8
G1 E.8 F1800
; LINE_WIDTH: 0.427157
G1 F9369.238
M204 S8000
G1 X162.551 Y119.874 E.02142
G1 X162.063 Y119.603 E.01692
G1 X162.063 Y120.127 E.01588
G2 X163.154 Y120.118 I.329 J-26.871 E.0331
; WIPE_START
G1 X162.063 Y120.127 E-.41438
G1 X162.063 Y119.603 E-.19884
G1 X162.401 Y119.791 E-.14679
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X165.772 Y120.162 Z1.2 F60000
G1 Z.8
G1 E.8 F1800
; LINE_WIDTH: 0.35438
G1 F11558.471
M204 S8000
G1 X165.772 Y119.772 E.00961
G1 X165.195 Y120.009 E.01536
G3 X164.595 Y120.154 I-4.335 J-16.661 E.01517
G2 X165.712 Y120.162 I.867 J-41.638 E.02748
M204 S10000
G1 X166.115 Y120.505 F60000
; LINE_WIDTH: 0.41999
G1 F9547.299
M204 S8000
G1 X166.115 Y119.15 E.04036
G3 X165.221 Y119.641 I-1.893 J-2.381 E.03052
G1 X164.563 Y119.803 E.02017
G1 X163.899 Y119.829 E.0198
G1 X163.28 Y119.733 E.01867
G1 X162.684 Y119.52 E.01884
G1 X162.283 Y119.296 E.01369
G1 X161.828 Y118.941 E.01719
G1 X161.685 Y118.786 E.00627
G1 X161.685 Y120.505 E.05118
G1 X166.055 Y120.505 E.13014
M204 S10000
G1 X166.492 Y120.882 F60000
G1 F9547.299
M204 S8000
G1 X166.492 Y118.397 E.07402
G1 X166.408 Y118.353 E.0028
G1 X166.023 Y118.751 E.01649
G1 X165.557 Y119.076 E.01692
G1 X165.068 Y119.297 E.01597
G1 X164.479 Y119.435 E.01803
G1 X163.891 Y119.452 E.01754
G1 X163.343 Y119.362 E.01653
G1 X162.817 Y119.167 E.01671
G1 X162.515 Y118.999 E.0103
G1 X162.06 Y118.644 E.01719
G3 X161.642 Y118.121 I24.858 J-20.288 E.01994
G1 X161.308 Y118.184 E.01012
G1 X161.308 Y120.882 E.08035
G1 X166.432 Y120.882 E.15261
; CHANGE_LAYER
; Z_HEIGHT: 1
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9547.299
G1 X164.432 Y120.882 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 7/37
; update layer progress
M73 L7
M991 S0 P6 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z1.2 I-.899 J.82 P1  F60000
G1 X188.525 Y147.313 Z1.2
G1 Z1
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X188.917 Y147.313 E.01261
G1 X188.917 Y181.697 E1.10567
G1 X182.473 Y181.697 E.20722
G1 X182.473 Y147.313 E1.10567
G1 X188.465 Y147.313 E.19268
; COOLING_NODE: 0
M204 S250
G1 X188.525 Y147.705 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X188.525 Y181.305 E1.00083
G1 X182.865 Y181.305 E.16859
G1 X182.865 Y147.705 E1.00083
G1 X188.465 Y147.705 E.1668
; COOLING_NODE: 0
; WIPE_START
M204 S8000
G1 X188.469 Y149.705 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X181.081 Y151.625 Z1.4 F60000
G1 X167.23 Y155.224 Z1.4
G1 Z1
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X166.431 Y155.224 E.0257
G1 X166.431 Y150.766 E.14336
G1 X175.969 Y150.766 E.30672
G1 X175.969 Y155.224 E.14336
G1 X167.29 Y155.224 E.27909
; COOLING_NODE: 0
M204 S10000
G1 X167.23 Y154.817 F60000
G1 F8843.478
M204 S8000
G1 X166.838 Y154.817 E.01261
G1 X166.838 Y151.173 E.11718
G1 X175.562 Y151.173 E.28054
G1 X175.562 Y154.817 E.11718
G1 X167.29 Y154.817 E.266
; COOLING_NODE: 1
M204 S250
G1 X167.23 Y154.425 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X167.23 Y151.565 E.08519
G1 X175.17 Y151.565 E.23651
G1 X175.17 Y154.425 E.08519
G1 X167.29 Y154.425 E.23472
; COOLING_NODE: 1
; WIPE_START
M204 S8000
G1 X167.248 Y152.425 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X166.194 Y144.866 Z1.4 F60000
G1 X166.059 Y143.9 Z1.4
G1 Z1
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X166.059 Y152.899 E.28938
G1 X161.341 Y152.899 E.15172
G1 X161.341 Y143.101 E.31508
G1 X166.059 Y143.101 E.15172
G1 X166.059 Y143.84 E.02377
; COOLING_NODE: 1
M204 S10000
G1 X165.652 Y143.9 F60000
G1 F8843.478
M204 S8000
G1 X165.652 Y152.492 E.27629
G1 X161.748 Y152.492 E.12554
G1 X161.748 Y143.508 E.2889
G1 X165.652 Y143.508 E.12554
G1 X165.652 Y143.84 E.01068
; COOLING_NODE: 2
M204 S250
G1 X165.26 Y143.9 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X165.26 Y152.1 E.24425
G1 X162.14 Y152.1 E.09293
G1 X162.14 Y143.9 E.24425
G1 X165.2 Y143.9 E.09115
; COOLING_NODE: 2
; WIPE_START
M204 S8000
G1 X165.215 Y145.9 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X161.834 Y142.694 Z1.4 F60000
G1 Z1
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X160.916 Y142.694 E.02951
G1 X160.916 Y132.926 E.31409
G1 X161.834 Y132.926 E.02951
G1 X161.834 Y142.634 E.31216
; COOLING_NODE: 2
; WIPE_START
G1 X160.916 Y142.694 E-.34943
M73 P54 R9
G1 X160.916 Y141.613 E-.41057
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X168.548 Y141.661 Z1.4 F60000
G1 X176.291 Y141.71 Z1.4
G1 Z1
G1 E.8 F1800
G1 F8843.478
M204 S8000
G1 X176.291 Y137.541 E.13406
G1 X188.509 Y137.541 E.3929
G1 X188.509 Y142.509 E.15976
G1 X176.291 Y142.509 E.3929
G1 X176.291 Y141.77 E.02377
; COOLING_NODE: 2
M204 S10000
G1 X176.698 Y141.71 F60000
G1 F8843.478
M204 S8000
G1 X176.698 Y137.948 E.12097
G1 X188.102 Y137.948 E.36672
G1 X188.102 Y142.102 E.13358
G1 X176.698 Y142.102 E.36672
G1 X176.698 Y141.77 E.01068
; COOLING_NODE: 3
M204 S250
G1 X177.09 Y141.71 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X177.09 Y138.34 E.10038
G1 X187.71 Y138.34 E.31633
G1 X187.71 Y141.71 E.10038
G1 X177.15 Y141.71 E.31455
; COOLING_NODE: 3
; WIPE_START
M204 S8000
G1 X177.114 Y139.71 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X176 Y147.261 Z1.4 F60000
G1 X174.709 Y156.009 Z1.4
G1 Z1
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X181.191 Y156.009 E.20845
G1 X181.191 Y160.991 E.16022
G1 X174.709 Y160.991 E.20845
G1 X174.709 Y156.069 E.15829
; COOLING_NODE: 3
; WIPE_START
G1 X176.709 Y156.05 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X180.784 Y159.785 Z1.4 F60000
G1 Z1
G1 E.8 F1800
G1 F8843.478
M204 S8000
G1 X180.784 Y160.584 E.0257
G1 X175.116 Y160.584 E.18227
G1 X175.116 Y156.416 E.13404
G1 X180.784 Y156.416 E.18227
G1 X180.784 Y159.725 E.10641
; COOLING_NODE: 3
M204 S10000
G1 X180.377 Y159.785 F60000
G1 F8843.478
M204 S8000
G1 X180.377 Y160.177 E.01261
G1 X175.523 Y160.177 E.15609
G1 X175.523 Y156.823 E.10786
G1 X180.377 Y156.823 E.15609
G1 X180.377 Y159.725 E.09332
; COOLING_NODE: 4
M204 S250
G1 X179.985 Y159.785 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X175.915 Y159.785 E.12123
G1 X175.915 Y157.215 E.07655
G1 X179.985 Y157.215 E.12123
G1 X179.985 Y159.725 E.07476
; COOLING_NODE: 4
; WIPE_START
M204 S8000
G1 X177.985 Y159.754 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X179.03 Y167.315 Z1.4 F60000
G1 X183.625 Y200.557 Z1.4
G1 Z1
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X183.672 Y200.512 E.00208
G3 X185.029 Y199.946 I1.625 J1.986 E.04796
G1 X185.285 Y199.932 E.00825
G3 X183.482 Y200.684 I.012 J2.566 E.45409
G1 X183.58 Y200.597 E.00422
; COOLING_NODE: 4
M204 S10000
G1 X183.871 Y200.889 F60000
G1 F8843.478
M204 S8000
G1 X183.931 Y200.828 E.00276
G3 X185.072 Y200.352 I1.367 J1.671 E.04034
G1 X185.288 Y200.34 E.00695
G3 X183.621 Y201.139 I.01 J2.159 E.37478
G1 X183.829 Y200.931 E.00946
; COOLING_NODE: 4
M204 S10000
G1 X184.158 Y201.175 F60000
G1 F8843.478
M204 S8000
G1 X184.19 Y201.143 E.00144
G3 X185.116 Y200.757 I1.109 J1.356 E.03272
G1 X185.291 Y200.747 E.00565
G3 X183.938 Y201.396 I.008 J1.752 E.30407
G1 X184.116 Y201.218 E.00811
; COOLING_NODE: 5
M204 S250
G1 X184.435 Y201.451 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X184.439 Y201.447 E.00017
G3 X185.157 Y201.147 I.86 J1.053 E.02351
G1 X185.294 Y201.14 E.00407
G3 X184.243 Y201.643 I.006 J1.359 E.21858
G1 X184.393 Y201.493 E.00631
; COOLING_NODE: 5
; WIPE_START
M204 S8000
G1 X184.439 Y201.447 E-.02494
G1 X184.661 Y201.299 E-.10117
G1 X184.901 Y201.2 E-.09893
G1 X185.157 Y201.147 E-.0993
G1 X185.294 Y201.14 E-.05193
G1 X185.559 Y201.165 E-.10134
G1 X185.81 Y201.239 E-.09952
G1 X186.055 Y201.369 E-.10536
G1 X186.213 Y201.498 E-.0775
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X186.385 Y193.868 Z1.4 F60000
G1 X187.71 Y134.916 Z1.4
G1 Z1
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X188.484 Y134.916 E.02488
G1 X188.484 Y137.134 E.07131
G1 X175.884 Y137.134 E.40517
G1 X175.884 Y142.916 E.18594
G1 X188.484 Y142.916 E.40517
G1 X188.484 Y146.499 E.1152
G1 X181.659 Y146.499 E.21947
G1 X181.659 Y182.511 E1.15803
G1 X188.484 Y182.511 E.21947
G1 X188.484 Y208.584 E.8384
G1 X181.641 Y208.584 E.22003
G1 X181.641 Y192.784 E.50807
G1 X176.911 Y192.784 E.1521
G1 X176.911 Y186.889 E.18956
G1 X170.239 Y186.889 E.21456
G1 X170.239 Y192.784 E.18956
G1 X166.466 Y192.784 E.12131
G1 X166.466 Y177.459 E.4928
G1 X160.916 Y177.459 E.17847
G1 X160.916 Y168.566 E.28595
G1 X170.731 Y168.566 E.31561
G1 X170.731 Y159.234 E.3001
G1 X160.916 Y159.234 E.31561
G1 X160.916 Y153.306 E.19061
G1 X166.024 Y153.306 E.16424
G1 X166.024 Y155.631 E.07476
G1 X176.376 Y155.631 E.3329
G1 X176.376 Y150.359 E.16954
G1 X166.466 Y150.359 E.31867
G1 X166.466 Y142.806 E.24286
G1 X167.366 Y142.806 E.02894
G1 X167.366 Y132.926 E.3177
G1 X169.976 Y132.926 E.08393
G1 X169.976 Y128.916 E.12895
G1 X175.884 Y128.916 E.18997
G1 X175.884 Y134.916 E.19294
G1 X187.65 Y134.916 E.37836
; COOLING_NODE: 5
; WIPE_START
G1 X188.484 Y134.916 E-.31685
G1 X188.484 Y136.082 E-.44315
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X187.71 Y129.541 Z1.4 F60000
G1 Z1
G1 E.8 F1800
G1 F8843.478
M204 S8000
G1 X188.509 Y129.541 E.0257
G1 X188.509 Y134.509 E.15976
G1 X176.291 Y134.509 E.3929
G1 X176.291 Y129.541 E.15976
G1 X187.65 Y129.541 E.36527
; COOLING_NODE: 5
M204 S10000
G1 X187.71 Y129.948 F60000
G1 F8843.478
M204 S8000
G1 X188.102 Y129.948 E.01261
G1 X188.102 Y134.102 E.13358
G1 X176.698 Y134.102 E.36672
G1 X176.698 Y129.948 E.13358
G1 X187.65 Y129.948 E.35218
; COOLING_NODE: 6
M204 S250
G1 X187.71 Y130.34 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X187.71 Y133.71 E.10038
G1 X177.09 Y133.71 E.31633
G1 X177.09 Y130.34 E.10038
G1 X187.65 Y130.34 E.31455
; COOLING_NODE: 6
; WIPE_START
M204 S8000
G1 X187.686 Y132.34 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X184.295 Y139.178 Z1.4 F60000
G1 X170.324 Y167.36 Z1.4
G1 Z1
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X170.324 Y168.159 E.0257
G1 X161.065 Y168.159 E.29774
G1 X161.065 Y159.641 E.27392
G1 X170.324 Y159.641 E.29774
G1 X170.324 Y167.3 E.24629
; COOLING_NODE: 6
M204 S10000
G1 X169.917 Y167.36 F60000
G1 F8843.478
M204 S8000
G1 X169.917 Y167.752 E.01261
G1 X161.472 Y167.752 E.27156
G1 X161.472 Y160.048 E.24774
G1 X169.917 Y160.048 E.27156
G1 X169.917 Y167.3 E.2332
; COOLING_NODE: 7
M204 S250
G1 X169.525 Y167.36 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X161.864 Y167.36 E.22819
G1 X161.864 Y160.44 E.20612
G1 X169.525 Y160.44 E.22819
G1 X169.525 Y167.3 E.20434
; COOLING_NODE: 7
; WIPE_START
M204 S8000
G1 X167.525 Y167.316 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X166.87 Y174.92 Z1.4 F60000
G1 X166.059 Y184.325 Z1.4
G1 Z1
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X166.059 Y185.124 E.0257
G1 X161.341 Y185.124 E.15172
G1 X161.341 Y177.866 E.2334
G1 X166.059 Y177.866 E.15172
G1 X166.059 Y184.265 E.20577
; COOLING_NODE: 7
M204 S10000
G1 X165.652 Y184.325 F60000
G1 F8843.478
M204 S8000
G1 X165.652 Y184.717 E.01261
G1 X161.748 Y184.717 E.12554
G1 X161.748 Y178.273 E.20722
G1 X165.652 Y178.273 E.12554
G1 X165.652 Y184.265 E.19268
; COOLING_NODE: 8
M204 S250
G1 X165.26 Y184.325 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X162.14 Y184.325 E.09293
G1 X162.14 Y178.665 E.16859
G1 X165.26 Y178.665 E.09293
G1 X165.26 Y184.265 E.1668
; COOLING_NODE: 8
; WIPE_START
M204 S8000
G1 X163.26 Y184.303 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X167.533 Y177.979 Z1.4 F60000
G1 X188.525 Y146.906 Z1.4
G1 Z1
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X182.066 Y146.906 E.2077
G1 X182.066 Y182.104 E1.13185
G1 X188.891 Y182.104 E.21947
G1 X188.891 Y208.991 E.86458
G1 X181.234 Y208.991 E.24621
G1 X181.234 Y193.191 E.50807
G1 X176.504 Y193.191 E.1521
G1 X176.504 Y187.296 E.18956
G1 X170.646 Y187.296 E.18838
G1 X170.646 Y193.191 E.18956
G1 X166.059 Y193.191 E.14749
G1 X166.059 Y185.866 E.23555
G1 X161.341 Y185.866 E.15172
G1 X161.341 Y193.191 E.23555
G1 X160.509 Y193.191 E.02675
G1 X160.509 Y132.519 E1.95098
G1 X162.241 Y132.519 E.05569
G1 X162.241 Y142.399 E.3177
G1 X166.959 Y142.399 E.15172
G1 X166.959 Y132.519 E.3177
G1 X169.569 Y132.519 E.08393
G1 X169.569 Y128.509 E.12895
G1 X188.891 Y128.509 E.62132
G1 X188.891 Y146.906 E.59157
G1 X188.585 Y146.906 E.00984
; COOLING_NODE: 8
; WIPE_START
G1 X186.585 Y146.906 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X179.164 Y145.121 Z1.4 F60000
G1 X166.16 Y141.992 Z1.4
G1 Z1
G1 E.8 F1800
G1 F8843.478
M204 S8000
G1 X162.648 Y141.992 E.11294
G1 X162.648 Y133.008 E.2889
G1 X166.552 Y133.008 E.12554
G1 X166.552 Y141.992 E.2889
G1 X166.22 Y141.992 E.01068
; COOLING_NODE: 9
M204 S250
G1 X166.16 Y141.6 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X163.04 Y141.6 E.09293
G1 X163.04 Y133.4 E.24425
G1 X166.16 Y133.4 E.09293
G1 X166.16 Y141.54 E.24246
; COOLING_NODE: 9
; WIPE_START
M204 S8000
G1 X164.16 Y141.578 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X163.798 Y149.202 Z1.4 F60000
M73 P55 R9
G1 X161.748 Y192.325 Z1.4
G1 Z1
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X161.748 Y186.273 E.19461
G1 X165.652 Y186.273 E.12554
G1 X165.652 Y192.717 E.20722
G1 X161.748 Y192.717 E.12554
G1 X161.748 Y192.385 E.01068
; COOLING_NODE: 10
M204 S250
G1 X162.14 Y192.325 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X162.14 Y186.665 E.16859
G1 X165.26 Y186.665 E.09293
G1 X165.26 Y192.325 E.16859
G1 X162.2 Y192.325 E.09115
; COOLING_NODE: 10
; WIPE_START
M204 S8000
G1 X162.179 Y190.325 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X169.672 Y188.873 Z1.4 F60000
G1 X175.705 Y187.703 Z1.4
G1 Z1
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X176.097 Y187.703 E.01261
G1 X176.097 Y192.697 E.16059
G1 X171.053 Y192.697 E.1622
G1 X171.053 Y187.703 E.16059
G1 X175.645 Y187.703 E.14766
; COOLING_NODE: 11
M204 S250
G1 X175.705 Y188.095 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X175.705 Y192.305 E.1254
G1 X171.445 Y192.305 E.12689
G1 X171.445 Y188.095 E.1254
G1 X175.645 Y188.095 E.1251
; COOLING_NODE: 11
; WIPE_START
M204 S8000
G1 X175.673 Y190.095 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X174.822 Y182.51 Z1.4 F60000
G1 X169.162 Y132.112 Z1.4
G1 Z1
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X169.162 Y128.102 E.12895
G1 X189.298 Y128.102 E.6475
G1 X189.298 Y146.502 E.59168
G1 X189.898 Y146.502 E.01929
G1 X189.898 Y182.498 E1.1575
G1 X189.298 Y182.498 E.01929
G1 X189.298 Y209.398 E.86501
G1 X180.827 Y209.398 E.27239
G1 X180.827 Y193.598 E.50807
G1 X160.102 Y193.598 E.66644
G1 X160.102 Y132.112 E1.97716
G1 X169.102 Y132.112 E.28941
; COOLING_NODE: 12
M204 S250
G1 X168.77 Y131.72 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2159
M204 S5000
G1 X168.77 Y127.71 E.11944
G1 X189.69 Y127.71 E.62314
G1 X189.69 Y146.11 E.54807
G1 X190.29 Y146.11 E.01787
G1 X190.29 Y182.89 E1.09555
G1 X189.69 Y182.89 E.01787
G1 X189.69 Y209.79 E.80126
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

G1 X180.435 Y209.79 E.27568
G1 X180.435 Y193.99 E.47063
G1 X159.71 Y193.99 E.61733
G1 X159.71 Y131.72 E1.85481
G1 X168.71 Y131.72 E.26808
; WIPE_START
G1 F9547.055
M204 S8000
G1 X168.74 Y129.72 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X166.755 Y132.56 Z1.4 F60000
G1 Z1
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.53172
G1 F7364.976
M204 S8000
G1 X162.444 Y132.56 E.16645
; WIPE_START
G1 X164.444 Y132.56 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X161.375 Y133.13 Z1.4 F60000
G1 Z1
G1 E.8 F1800
; LINE_WIDTH: 0.55344
G1 F7051.634
M204 S8000
G1 X161.375 Y142.49 E.37749
M204 S10000
G1 X160.925 Y142.897 F60000
; LINE_WIDTH: 0.46758
G1 F8477.369
M204 S8000
G1 X160.925 Y153.103 E.34233
; WIPE_START
G1 X160.925 Y151.103 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X161.933 Y143.537 Z1.4 F60000
G1 X162.037 Y142.75 Z1.4
G1 Z1
G1 E.8 F1800
; LINE_WIDTH: 0.33758
G1 F12217.47
M204 S8000
G1 X166.263 Y142.75 E.09834
; WIPE_START
G1 X164.263 Y142.75 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X167.449 Y135.814 Z1.4 F60000
G1 X170.14 Y129.957 Z1.4
G1 Z1
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42088
G1 F9524.817
M204 S8000
G1 X176.983 Y136.801 E.28896
G1 X176.449 Y136.801 E.01596
G1 X170.309 Y130.661 E.25922
G1 X170.309 Y131.196 E.01596
G1 X175.914 Y136.801 E.23665
G1 X175.551 Y136.801 E.01086
G1 X175.551 Y136.972 E.0051
G1 X170.309 Y131.73 E.2213
G1 X170.309 Y132.265 E.01596
G1 X175.551 Y137.506 E.2213
G1 X175.551 Y138.041 E.01596
G1 X170.309 Y132.799 E.2213
G1 X170.309 Y133.259 E.01374
G1 X170.235 Y133.259 E.00222
G1 X175.551 Y138.575 E.22445
G1 X175.551 Y139.11 E.01596
G1 X169.7 Y133.259 E.24702
G1 X169.166 Y133.259 E.01596
G1 X175.551 Y139.644 E.26958
G1 X175.551 Y140.179 E.01596
G1 X168.631 Y133.259 E.29215
G1 X168.097 Y133.259 E.01596
G1 X175.551 Y140.713 E.31472
G1 X175.551 Y141.248 E.01596
G1 X167.699 Y133.396 E.3315
G1 X167.699 Y133.931 E.01596
G1 X175.551 Y141.782 E.3315
G1 X175.551 Y142.317 E.01596
G1 X167.699 Y134.465 E.3315
G1 X167.699 Y135 E.01596
G1 X175.551 Y142.851 E.3315
G1 X175.551 Y143.249 E.01189
G1 X175.949 Y143.249 E.01189
G1 X181.326 Y148.626 E.22703
G1 X181.326 Y148.092 E.01596
G1 X176.483 Y143.249 E.20446
G1 X177.018 Y143.249 E.01596
G1 X181.326 Y147.557 E.18189
G1 X181.326 Y147.023 E.01596
G1 X177.552 Y143.249 E.15932
G1 X178.087 Y143.249 E.01596
G1 X181.326 Y146.488 E.13675
G1 X181.326 Y146.166 E.00963
G1 X181.538 Y146.166 E.00633
G1 X178.621 Y143.249 E.12313
G1 X179.156 Y143.249 E.01596
G1 X182.072 Y146.166 E.12313
G1 X182.607 Y146.166 E.01596
G1 X179.69 Y143.249 E.12313
G1 X180.225 Y143.249 E.01596
G1 X183.141 Y146.166 E.12313
G1 X183.676 Y146.166 E.01596
G1 X180.759 Y143.249 E.12313
G1 X181.294 Y143.249 E.01596
G1 X184.21 Y146.166 E.12313
G1 X184.745 Y146.166 E.01596
M73 P56 R9
G1 X181.828 Y143.249 E.12313
G1 X182.363 Y143.249 E.01596
G1 X185.279 Y146.166 E.12313
G1 X185.814 Y146.166 E.01596
G1 X182.897 Y143.249 E.12313
G1 X183.432 Y143.249 E.01596
G1 X186.348 Y146.166 E.12313
G1 X186.883 Y146.166 E.01596
G1 X183.966 Y143.249 E.12313
G1 X184.501 Y143.249 E.01596
G1 X187.417 Y146.166 E.12313
G1 X187.952 Y146.166 E.01596
G1 X185.036 Y143.249 E.12313
G1 X185.57 Y143.249 E.01596
G1 X188.151 Y145.83 E.10896
G1 X188.151 Y145.295 E.01596
G1 X186.105 Y143.249 E.08639
G1 X186.639 Y143.249 E.01596
G1 X188.151 Y144.761 E.06382
G1 X188.151 Y144.226 E.01596
G1 X187.174 Y143.249 E.04125
G1 X187.708 Y143.249 E.01596
G1 X188.32 Y143.862 E.02585
; WIPE_START
G1 X187.708 Y143.249 E-.32901
G1 X187.174 Y143.249 E-.20312
G1 X187.598 Y143.673 E-.22788
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X189.095 Y147.093 Z1.4 F60000
G1 Z1
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.118631
G1 F15000
M204 S8000
G1 X189.12 Y147.083 E.00016
; LINE_WIDTH: 0.165653
G1 X189.146 Y147.074 E.00027
; LINE_WIDTH: 0.212674
G1 X189.172 Y147.065 E.00037
; LINE_WIDTH: 0.259695
G1 X189.198 Y147.055 E.00047
; LINE_WIDTH: 0.306717
G1 F13646.879
G1 X189.224 Y147.046 E.00057
; LINE_WIDTH: 0.353738
G1 F11582.34
G1 X189.25 Y147.037 E.00068
; LINE_WIDTH: 0.40076
G1 F10060.376
G1 X189.276 Y147.028 E.00078
; LINE_WIDTH: 0.447781
G1 F8891.942
G1 X189.302 Y147.018 E.00088
; LINE_WIDTH: 0.494803
G1 F7966.675
G1 X189.327 Y147.009 E.00098
; LINE_WIDTH: 0.541824
G1 F7215.819
G1 X189.353 Y147 E.00108
; LINE_WIDTH: 0.588846
G1 F6594.309
G1 X189.379 Y146.99 E.00119
; LINE_WIDTH: 0.616778
G1 F6273.336
G1 X189.398 Y147.002 E.001
G1 X189.408 Y147.109 E.00487
G1 X189.408 Y181.901 E1.57711
G1 X189.399 Y181.999 E.00448
G1 X189.371 Y182.018 E.00153
; LINE_WIDTH: 0.573214
G1 F6788.692
G1 X189.346 Y182.009 E.00112
; LINE_WIDTH: 0.527681
G1 F7426.342
G1 X189.321 Y182 E.00102
; LINE_WIDTH: 0.482149
G1 F8196.196
G1 X189.296 Y181.99 E.00093
; LINE_WIDTH: 0.436616
G1 F9144.123
G1 X189.27 Y181.981 E.00083
; LINE_WIDTH: 0.391083
G1 F10339.991
G1 X189.245 Y181.972 E.00074
; LINE_WIDTH: 0.34555
G1 F11895.715
G1 X189.22 Y181.963 E.00064
; LINE_WIDTH: 0.300018
G1 F14002.483
G1 X189.195 Y181.954 E.00054
; LINE_WIDTH: 0.254485
G1 F15000
G1 X189.17 Y181.945 E.00045
; LINE_WIDTH: 0.208952
G1 X189.145 Y181.936 E.00035
; LINE_WIDTH: 0.163419
G1 X189.12 Y181.926 E.00025
; LINE_WIDTH: 0.117887
G1 X189.095 Y181.917 E.00016
; WIPE_START
G1 X189.12 Y181.926 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X187.509 Y182.675 Z1.4 F60000
G1 Z1
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42352
G1 F9458.749
M204 S8000
G1 X188.151 Y183.316 E.02726
G1 X188.151 Y183.854 E.01618
G1 X187.141 Y182.844 E.04294
G1 X186.603 Y182.844 E.01618
G1 X188.151 Y184.392 E.06582
G1 X188.151 Y184.931 E.01618
G1 X186.064 Y182.844 E.08871
G1 X185.526 Y182.844 E.01618
G1 X188.151 Y185.469 E.11159
G1 X188.151 Y186.007 E.01618
G1 X184.988 Y182.844 E.13448
G1 X184.45 Y182.844 E.01618
G1 X188.151 Y186.545 E.15736
G1 X188.151 Y187.084 E.01618
G1 X183.911 Y182.844 E.18025
G1 X183.373 Y182.844 E.01618
G1 X188.151 Y187.622 E.20313
G1 X188.151 Y188.16 E.01618
G1 X182.835 Y182.844 E.22602
G1 X182.297 Y182.844 E.01618
G1 X188.151 Y188.698 E.2489
G1 X188.151 Y189.237 E.01618
G1 X181.758 Y182.844 E.27179
G1 X181.326 Y182.844 E.01301
G1 X181.326 Y182.412 E.01301
G1 X167.813 Y168.899 E.57451
G1 X168.352 Y168.899 E.01618
G1 X181.326 Y181.873 E.55163
G1 X181.326 Y181.335 E.01618
G1 X168.89 Y168.899 E.52874
G1 X169.428 Y168.899 E.01618
G1 X181.326 Y180.797 E.50586
G1 X181.326 Y180.259 E.01618
G1 X169.966 Y168.899 E.48297
G1 X170.505 Y168.899 E.01618
G1 X181.326 Y179.72 E.46009
G1 X181.326 Y179.182 E.01618
G1 X171.043 Y168.899 E.4372
G1 X171.064 Y168.899 E.00065
G1 X171.064 Y168.383 E.01554
G1 X181.326 Y178.644 E.43629
G1 X181.326 Y178.106 E.01618
G1 X171.064 Y167.844 E.43629
G1 X171.064 Y167.306 E.01618
G1 X181.326 Y177.567 E.43629
G1 X181.326 Y177.029 E.01618
G1 X171.064 Y166.768 E.43629
G1 X171.064 Y166.23 E.01618
G1 X181.326 Y176.491 E.43629
G1 X181.326 Y175.953 E.01618
G1 X171.064 Y165.691 E.43629
G1 X171.064 Y165.153 E.01618
G1 X181.326 Y175.414 E.43629
G1 X181.326 Y174.876 E.01618
G1 X171.064 Y164.615 E.43629
G1 X171.064 Y164.077 E.01618
G1 X181.326 Y174.338 E.43629
G1 X181.326 Y173.8 E.01618
G1 X171.064 Y163.538 E.43629
G1 X171.064 Y163 E.01618
G1 X181.326 Y173.261 E.43629
G1 X181.326 Y172.723 E.01618
G1 X171.064 Y162.462 E.43629
G1 X171.064 Y161.924 E.01618
G1 X181.326 Y172.185 E.43629
G1 X181.326 Y171.647 E.01618
G1 X171.064 Y161.385 E.43629
G1 X171.064 Y160.847 E.01618
G1 X181.326 Y171.108 E.43629
G1 X181.326 Y170.57 E.01618
G1 X171.064 Y160.309 E.43629
G1 X171.064 Y159.771 E.01618
G1 X181.326 Y170.032 E.43629
G1 X181.326 Y169.494 E.01618
G1 X167.796 Y155.964 E.57524
G1 X168.335 Y155.964 E.01618
G1 X181.495 Y169.125 E.55957
; WIPE_START
G1 X180.081 Y167.711 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X176.651 Y160.893 Z1.4 F60000
G1 X174.086 Y155.795 Z1.4
G1 Z1
G1 E.8 F1800
G1 F9458.749
M204 S8000
G1 X174.376 Y156.085 E.01233
G1 X174.376 Y156.623 E.01618
G1 X173.717 Y155.964 E.028
G1 X173.179 Y155.964 E.01618
G1 X174.376 Y157.161 E.05089
G1 X174.376 Y157.699 E.01618
G1 X172.641 Y155.964 E.07377
G1 X172.102 Y155.964 E.01618
G1 X174.376 Y158.238 E.09666
G1 X174.376 Y158.776 E.01618
G1 X171.564 Y155.964 E.11954
G1 X171.026 Y155.964 E.01618
G1 X174.376 Y159.314 E.14243
G1 X174.376 Y159.852 E.01618
G1 X170.488 Y155.964 E.16531
G1 X169.949 Y155.964 E.01618
G1 X174.376 Y160.391 E.1882
G1 X174.376 Y160.929 E.01618
G1 X169.411 Y155.964 E.21108
G1 X168.873 Y155.964 E.01618
G1 X181.326 Y168.417 E.52947
G1 X181.326 Y167.879 E.01618
G1 X174.771 Y161.324 E.27869
G1 X175.309 Y161.324 E.01618
G1 X181.326 Y167.341 E.2558
G1 X181.326 Y166.802 E.01618
G1 X175.848 Y161.324 E.23292
G1 X176.386 Y161.324 E.01618
G1 X181.326 Y166.264 E.21003
G1 X181.326 Y165.726 E.01618
G1 X176.924 Y161.324 E.18715
G1 X177.462 Y161.324 E.01618
G1 X181.326 Y165.188 E.16426
G1 X181.326 Y164.649 E.01618
G1 X178.001 Y161.324 E.14138
G1 X178.539 Y161.324 E.01618
G1 X181.326 Y164.111 E.11849
G1 X181.326 Y163.573 E.01618
G1 X179.077 Y161.324 E.0956
G1 X179.615 Y161.324 E.01618
G1 X181.326 Y163.035 E.07272
G1 X181.326 Y162.496 E.01618
G1 X180.154 Y161.324 E.04983
G1 X180.692 Y161.324 E.01618
G1 X181.495 Y162.128 E.03416
M204 S10000
G1 X181.425 Y161.195 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.10344
G1 F15000
M204 S8000
G1 X181.425 Y155.805 E.02576
M204 S10000
G1 X181.495 Y155.21 F60000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42088
G1 F9524.817
M204 S8000
G1 X176.709 Y150.424 E.20208
G1 X176.709 Y150.959 E.01596
G1 X181.223 Y155.472 E.19057
G1 X181.04 Y155.472 E.00546
G1 X181.04 Y155.676 E.00607
G1 X180.892 Y155.676 E.00443
G1 X176.709 Y151.493 E.17659
G1 X176.709 Y152.028 E.01596
G1 X180.357 Y155.676 E.15403
G1 X179.823 Y155.676 E.01596
G1 X176.709 Y152.562 E.13146
G1 X176.709 Y153.097 E.01596
G1 X179.288 Y155.676 E.10889
G1 X178.754 Y155.676 E.01596
G1 X176.709 Y153.631 E.08632
G1 X176.709 Y154.166 E.01596
G1 X178.219 Y155.676 E.06375
G1 X177.685 Y155.676 E.01596
G1 X176.709 Y154.7 E.04118
G1 X176.709 Y155.235 E.01596
G1 X177.32 Y155.845 E.02578
; WIPE_START
G1 X176.709 Y155.235 E-.32809
G1 X176.709 Y154.7 E-.20312
G1 X177.135 Y155.126 E-.2288
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X181.495 Y149.33 Z1.4 F60000
G1 Z1
G1 E.8 F1800
G1 F9524.817
M204 S8000
G1 X167.699 Y135.534 E.58251
G1 X167.699 Y136.069 E.01596
G1 X181.326 Y149.695 E.57534
G1 X181.326 Y150.23 E.01596
G1 X167.699 Y136.604 E.57534
G1 X167.699 Y137.138 E.01596
G1 X181.326 Y150.764 E.57534
G1 X181.326 Y151.299 E.01596
G1 X167.699 Y137.673 E.57534
G1 X167.699 Y138.207 E.01596
G1 X181.326 Y151.833 E.57534
G1 X181.326 Y152.368 E.01596
G1 X167.699 Y138.742 E.57534
G1 X167.699 Y139.276 E.01596
G1 X181.326 Y152.902 E.57534
G1 X181.326 Y153.437 E.01596
G1 X167.699 Y139.811 E.57534
G1 X167.699 Y140.345 E.01596
G1 X181.326 Y153.971 E.57534
G1 X181.326 Y154.506 E.01596
G1 X167.699 Y140.88 E.57534
G1 X167.699 Y141.414 E.01596
G1 X176.311 Y150.026 E.3636
G1 X175.776 Y150.026 E.01596
G1 X167.699 Y141.949 E.34103
G1 X167.699 Y142.483 E.01596
G1 X175.242 Y150.026 E.31846
G1 X174.707 Y150.026 E.01596
G1 X167.699 Y143.018 E.29589
G1 X167.699 Y143.139 E.00363
G1 X167.286 Y143.139 E.01233
G1 X174.173 Y150.026 E.29076
G1 X173.638 Y150.026 E.01596
G1 X166.799 Y143.187 E.28876
G1 X166.799 Y143.721 E.01596
G1 X173.104 Y150.026 E.26619
G1 X172.569 Y150.026 E.01596
G1 X166.799 Y144.256 E.24362
G1 X166.799 Y144.79 E.01596
G1 X172.035 Y150.026 E.22105
G1 X171.5 Y150.026 E.01596
G1 X166.799 Y145.325 E.19848
G1 X166.799 Y145.859 E.01596
G1 X170.966 Y150.026 E.17591
G1 X170.431 Y150.026 E.01596
G1 X166.799 Y146.394 E.15335
G1 X166.799 Y146.928 E.01596
G1 X169.897 Y150.026 E.13078
G1 X169.362 Y150.026 E.01596
G1 X166.799 Y147.463 E.10821
G1 X166.799 Y147.997 E.01596
G1 X168.828 Y150.026 E.08564
G1 X168.293 Y150.026 E.01596
G1 X166.799 Y148.532 E.06307
G1 X166.799 Y149.066 E.01596
G1 X167.759 Y150.026 E.0405
G1 X167.224 Y150.026 E.01596
G1 X166.63 Y149.431 E.0251
; WIPE_START
G1 X167.224 Y150.026 E-.31942
G1 X167.759 Y150.026 E-.20311
G1 X167.317 Y149.584 E-.23746
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X165.86 Y154.028 Z1.4 F60000
G1 Z1
G1 E.8 F1800
; LINE_WIDTH: 0.42352
G1 F9458.749
M204 S8000
G1 X165.471 Y153.639 E.01654
G1 X164.933 Y153.639 E.01618
G1 X165.691 Y154.397 E.03221
G1 X165.691 Y154.935 E.01618
G1 X164.395 Y153.639 E.0551
G1 X163.857 Y153.639 E.01618
G1 X165.691 Y155.473 E.07798
G1 X165.691 Y155.964 E.01476
G1 X166.182 Y155.964 E.01476
G1 X169.118 Y158.901 E.12484
G1 X169.656 Y158.901 E.01618
G1 X166.72 Y155.964 E.12484
G1 X167.258 Y155.964 E.01618
G1 X170.364 Y159.07 E.13206
; WIPE_START
G1 X168.95 Y157.656 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X168.749 Y159.07 Z1.4 F60000
G1 Z1
G1 E.8 F1800
G1 F9458.749
M204 S8000
G1 X163.318 Y153.639 E.23091
G1 X162.78 Y153.639 E.01618
G1 X168.041 Y158.901 E.2237
G1 X167.503 Y158.901 E.01618
G1 X162.242 Y153.639 E.2237
G1 X161.704 Y153.639 E.01618
G1 X166.965 Y158.901 E.2237
G1 X166.427 Y158.901 E.01618
G1 X161.249 Y153.723 E.22013
G1 X161.249 Y154.262 E.01618
G1 X165.888 Y158.901 E.19724
G1 X165.35 Y158.901 E.01618
G1 X161.249 Y154.8 E.17435
G1 X161.249 Y155.338 E.01618
G1 X164.812 Y158.901 E.15147
G1 X164.274 Y158.901 E.01618
G1 X161.249 Y155.876 E.12858
G1 X161.249 Y156.415 E.01618
G1 X163.735 Y158.901 E.1057
G1 X163.197 Y158.901 E.01618
G1 X161.249 Y156.953 E.08281
G1 X161.249 Y157.491 E.01618
G1 X162.659 Y158.901 E.05993
G1 X162.121 Y158.901 E.01618
G1 X161.249 Y158.029 E.03704
G1 X161.249 Y158.568 E.01618
G1 X161.752 Y159.07 E.02137
; WIPE_START
G1 X161.249 Y158.568 E-.27014
G1 X161.249 Y158.029 E-.20454
G1 X161.78 Y158.56 E-.28533
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X160.787 Y159.437 Z1.4 F60000
G1 Z1
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.19158
G1 F15000
M204 S8000
G1 X160.787 Y168.363 E.10481
; WIPE_START
G1 X160.787 Y166.363 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X166.584 Y171.328 Z1.4 F60000
G1 X188.32 Y189.945 Z1.4
M73 P57 R9
G1 Z1
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42352
G1 F9458.749
M204 S8000
G1 X167.275 Y168.899 E.8948
G1 X166.737 Y168.899 E.01618
G1 X188.151 Y190.313 E.91047
G1 X188.151 Y190.851 E.01618
G1 X166.199 Y168.899 E.93335
G1 X165.66 Y168.899 E.01618
G1 X188.151 Y191.39 E.95624
G1 X188.151 Y191.928 E.01618
G1 X165.122 Y168.899 E.97913
G1 X164.584 Y168.899 E.01618
G1 X188.151 Y192.466 E1.00201
G1 X188.151 Y193.004 E.01618
G1 X164.046 Y168.899 E1.0249
G1 X163.507 Y168.899 E.01618
G1 X188.151 Y193.543 E1.04778
G1 X188.151 Y194.081 E.01618
G1 X162.969 Y168.899 E1.07067
G1 X162.431 Y168.899 E.01618
G1 X188.151 Y194.619 E1.09355
G1 X188.151 Y195.157 E.01618
G1 X161.893 Y168.899 E1.11644
G1 X161.354 Y168.899 E.01618
G1 X188.151 Y195.696 E1.13932
G1 X188.151 Y196.234 E.01618
G1 X161.249 Y169.333 E1.14379
G1 X161.249 Y169.871 E.01618
G1 X188.151 Y196.772 E1.14379
G1 X188.151 Y197.31 E.01618
G1 X161.249 Y170.409 E1.14379
G1 X161.249 Y170.947 E.01618
G1 X176.858 Y186.556 E.66363
G1 X176.319 Y186.556 E.01618
G1 X161.249 Y171.486 E.64074
G1 X161.249 Y172.024 E.01618
G1 X166.351 Y177.126 E.21692
G1 X165.813 Y177.126 E.01618
G1 X161.249 Y172.562 E.19403
G1 X161.249 Y173.1 E.01618
G1 X165.275 Y177.126 E.17115
G1 X164.736 Y177.126 E.01618
G1 X161.249 Y173.639 E.14826
G1 X161.249 Y174.177 E.01618
G1 X164.198 Y177.126 E.12537
G1 X163.66 Y177.126 E.01618
G1 X161.249 Y174.715 E.10249
G1 X161.249 Y175.253 E.01618
G1 X163.122 Y177.126 E.0796
G1 X162.583 Y177.126 E.01618
G1 X161.249 Y175.792 E.05672
G1 X161.249 Y176.33 E.01618
G1 X162.045 Y177.126 E.03383
G1 X161.507 Y177.126 E.01618
G1 X161.08 Y176.698 E.01816
M204 S10000
G1 X160.925 Y177.662 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.467762
G1 F8473.752
M204 S8000
G1 X160.925 Y185.328 E.25724
G1 X160.941 Y185.411 E.00286
; LINE_WIDTH: 0.51702
G1 F7593.335
G1 X160.958 Y185.495 E.00319
; WIPE_START
G1 X160.941 Y185.411 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X166.263 Y185.495 Z1.4 F60000
G1 Z1
G1 E.8 F1800
; LINE_WIDTH: 0.37757
G1 F10757.508
M204 S8000
G1 X161.137 Y185.495 E.13549
; LINE_WIDTH: 0.397056
G1 F10165.602
G1 X161.092 Y185.495 E.00125
; LINE_WIDTH: 0.436047
G1 F9157.362
G1 X161.048 Y185.495 E.00139
; LINE_WIDTH: 0.475038
G1 F8331.074
G1 X161.003 Y185.495 E.00153
; LINE_WIDTH: 0.503353
G1 F7818.736
G1 X160.958 Y185.495 E.00163
G1 X160.925 Y185.662 E.0062
; LINE_WIDTH: 0.46758
G1 F8477.369
G1 X160.925 Y192.987 E.24572
M204 S10000
G1 X161.544 Y193.158 F60000
; LINE_WIDTH: 0.51671
G1 F7598.303
M204 S8000
G1 X165.855 Y193.158 E.16134
; WIPE_START
G1 X163.855 Y193.158 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X167.313 Y192.62 Z1.4 F60000
G1 Z1
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42352
G1 F9458.749
M204 S8000
G1 X166.799 Y192.107 E.02184
G1 X166.799 Y191.568 E.01618
G1 X167.682 Y192.451 E.03751
G1 X168.22 Y192.451 E.01618
G1 X166.799 Y191.03 E.0604
G1 X166.799 Y190.492 E.01618
G1 X168.758 Y192.451 E.08328
G1 X169.296 Y192.451 E.01618
G1 X166.799 Y189.954 E.10617
G1 X166.799 Y189.415 E.01618
G1 X169.835 Y192.451 E.12905
G1 X169.906 Y192.451 E.00214
G1 X169.906 Y191.983 E.01405
G1 X166.799 Y188.877 E.13207
G1 X166.799 Y188.339 E.01618
G1 X169.906 Y191.445 E.13207
G1 X169.906 Y190.907 E.01618
G1 X166.799 Y187.801 E.13207
G1 X166.799 Y187.262 E.01618
G1 X169.906 Y190.369 E.13207
G1 X169.906 Y189.83 E.01618
G1 X166.799 Y186.724 E.13207
G1 X166.799 Y186.186 E.01618
G1 X169.906 Y189.292 E.13207
G1 X169.906 Y188.754 E.01618
G1 X166.799 Y185.648 E.13207
G1 X166.799 Y185.109 E.01618
G1 X169.906 Y188.216 E.13207
G1 X169.906 Y187.677 E.01618
G1 X166.799 Y184.571 E.13207
G1 X166.799 Y184.033 E.01618
G1 X169.906 Y187.139 E.13207
G1 X169.906 Y186.601 E.01618
G1 X166.799 Y183.495 E.13207
G1 X166.799 Y182.956 E.01618
G1 X170.399 Y186.556 E.15303
G1 X170.937 Y186.556 E.01618
G1 X166.799 Y182.418 E.17592
G1 X166.799 Y181.88 E.01618
G1 X171.475 Y186.556 E.1988
G1 X172.013 Y186.556 E.01618
G1 X166.799 Y181.342 E.22169
G1 X166.799 Y180.803 E.01618
G1 X172.552 Y186.556 E.24457
G1 X173.09 Y186.556 E.01618
G1 X166.799 Y180.265 E.26746
G1 X166.799 Y179.727 E.01618
G1 X173.628 Y186.556 E.29034
G1 X174.166 Y186.556 E.01618
G1 X166.799 Y179.189 E.31323
G1 X166.799 Y178.65 E.01618
G1 X174.705 Y186.556 E.33611
G1 X175.243 Y186.556 E.01618
G1 X166.799 Y178.112 E.359
G1 X166.799 Y177.574 E.01618
G1 X175.951 Y186.725 E.3891
; WIPE_START
G1 X174.537 Y185.311 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.287 Y192.217 Z1.4 F60000
G1 X170.849 Y193.148 Z1.4
G1 Z1
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.53672
G1 F7290.401
M204 S8000
G1 X176.301 Y193.148 E.21263
; WIPE_START
G1 X174.301 Y193.148 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X177.075 Y192.155 Z1.4 F60000
G1 Z1
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42352
G1 F9458.749
M204 S8000
G1 X177.37 Y192.451 E.01256
G1 X177.908 Y192.451 E.01618
G1 X177.244 Y191.787 E.02823
G1 X177.244 Y191.248 E.01618
G1 X178.447 Y192.451 E.05112
G1 X178.985 Y192.451 E.01618
G1 X177.244 Y190.71 E.074
G1 X177.244 Y190.172 E.01618
G1 X179.523 Y192.451 E.09689
G1 X180.061 Y192.451 E.01618
G1 X177.244 Y189.634 E.11977
G1 X177.244 Y189.095 E.01618
G1 X180.6 Y192.451 E.14266
G1 X181.138 Y192.451 E.01618
G1 X177.244 Y188.557 E.16554
G1 X177.244 Y188.019 E.01618
G1 X188.151 Y198.925 E.46371
G1 X188.151 Y198.387 E.01618
G1 X177.244 Y187.481 E.46371
G1 X177.244 Y186.942 E.01618
G1 X188.32 Y198.018 E.47093
; WIPE_START
G1 X186.906 Y196.604 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X188.32 Y199.633 Z1.4 F60000
M73 P57 R8
G1 Z1
G1 E.8 F1800
G1 F9458.749
M204 S8000
G1 X181.974 Y193.287 E.26982
G1 X181.974 Y193.825 E.01618
G1 X188.151 Y200.002 E.2626
G1 X188.151 Y200.54 E.01618
G1 X181.974 Y194.364 E.2626
G1 X181.974 Y194.902 E.01618
G1 X187.972 Y200.899 E.25499
G1 X187.734 Y200.941 E.00727
G2 X187.124 Y200.243 I-2.363 J1.448 E.02798
G1 X186.661 Y199.936 E.01671
G1 X186.337 Y199.802 E.01055
G1 X181.974 Y195.44 E.18548
G1 X181.974 Y195.978 E.01618
G1 X185.614 Y199.618 E.15474
G1 X185.07 Y199.613 E.01634
G1 X181.974 Y196.517 E.13164
G1 X181.974 Y197.055 E.01618
G1 X184.612 Y199.692 E.11213
G2 X184.207 Y199.826 I.14 J1.106 E.01289
G1 X181.974 Y197.593 E.09492
G1 X181.974 Y198.131 E.01618
G1 X183.84 Y199.997 E.07931
G2 X183.518 Y200.213 I.938 J1.74 E.01168
G1 X181.974 Y198.67 E.06564
G1 X181.974 Y199.208 E.01618
G1 X183.232 Y200.466 E.05348
G2 X182.985 Y200.757 I1.256 J1.319 E.0115
G1 X181.974 Y199.746 E.04296
G1 X181.974 Y200.284 E.01618
G1 X182.772 Y201.082 E.03393
G2 X182.605 Y201.453 I1.235 J.779 E.01228
G1 X181.974 Y200.823 E.02682
G1 X181.974 Y201.361 E.01618
G1 X182.48 Y201.867 E.02151
G2 X182.407 Y202.332 I1.548 J.482 E.0142
G1 X181.974 Y201.899 E.0184
G1 X181.974 Y202.437 E.01618
G1 X182.429 Y202.892 E.01931
G2 X182.649 Y203.651 I2.559 J-.333 E.02386
G1 X181.974 Y202.976 E.02871
G1 X181.974 Y203.514 E.01618
G1 X186.711 Y208.251 E.2014
G1 X187.249 Y208.251 E.01618
G1 X184.153 Y205.154 E.13165
G2 X184.909 Y205.372 I1.107 J-2.423 E.02373
G1 X187.788 Y208.251 E.1224
G1 X188.151 Y208.251 E.01091
G1 X188.151 Y208.075 E.00527
G1 X185.465 Y205.39 E.11419
G2 X185.94 Y205.327 I-.091 J-2.518 E.01444
G1 X188.151 Y207.537 E.09398
G1 X188.151 Y206.999 E.01618
G1 X186.352 Y205.201 E.07646
G2 X186.718 Y205.028 I-1.094 J-2.783 E.01216
G1 X188.151 Y206.461 E.06092
G1 X188.151 Y205.922 E.01618
G1 X187.041 Y204.812 E.0472
G2 X187.334 Y204.568 I-.692 J-1.13 E.01153
G1 X188.151 Y205.384 E.03471
G1 X188.151 Y204.846 E.01618
G1 X187.586 Y204.282 E.024
G2 X187.743 Y204.061 I-.991 J-.869 E.00816
G1 X187.938 Y204.095 E.00595
G1 X188.32 Y204.477 E.01627
M204 S10000
G1 X188.039 Y203.774 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.435835
G1 F9162.291
M204 S8000
G1 X188.075 Y203.57 E.00643
; LINE_WIDTH: 0.398361
G1 F10128.263
G1 X188.113 Y203.349 E.00631
; LINE_WIDTH: 0.35915
G1 F11384.149
G1 X188.131 Y203.205 E.00363
; LINE_WIDTH: 0.322055
G1 F12897.01
G1 X188.15 Y203.047 E.00351
; LINE_WIDTH: 0.282816
G1 F15000
G1 X188.17 Y202.753 E.00558
; LINE_WIDTH: 0.258236
G1 X188.168 Y202.198 E.00944
; LINE_WIDTH: 0.288278
G1 F14672.439
G1 X188.147 Y201.923 E.00533
; LINE_WIDTH: 0.326649
G1 F12688.173
G1 X188.13 Y201.786 E.00311
; LINE_WIDTH: 0.362886
G1 F11251.219
G1 X188.11 Y201.631 E.00395
; LINE_WIDTH: 0.400696
G1 F10062.186
G1 X188.075 Y201.428 E.00581
; LINE_WIDTH: 0.436245
G1 F9152.735
G1 X188.039 Y201.225 E.00639
; WIPE_START
G1 X188.075 Y201.428 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X186.343 Y208.42 Z1.4 F60000
G1 Z1
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42352
G1 F9458.749
M204 S8000
G1 X181.974 Y204.052 E.18573
G1 X181.974 Y204.59 E.01618
G1 X185.635 Y208.251 E.15563
G1 X185.096 Y208.251 E.01618
G1 X181.974 Y205.129 E.13274
G1 X181.974 Y205.667 E.01618
G1 X184.558 Y208.251 E.10986
G1 X184.02 Y208.251 E.01618
G1 X181.974 Y206.205 E.08697
G1 X181.974 Y206.743 E.01618
G1 X183.482 Y208.251 E.06408
G1 X182.943 Y208.251 E.01618
G1 X181.974 Y207.282 E.0412
G1 X181.974 Y207.82 E.01618
G1 X182.575 Y208.42 E.02553
; WIPE_START
G1 X181.974 Y207.82 E-.32267
G1 X181.974 Y207.282 E-.20454
G1 X182.408 Y207.715 E-.2328
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X183.033 Y200.108 Z1.4 F60000
G1 X188.32 Y135.844 Z1.4
G1 Z1
G1 E.8 F1800
; LINE_WIDTH: 0.42088
G1 F9524.817
M204 S8000
G1 X187.726 Y135.249 E.0251
G1 X187.191 Y135.249 E.01596
G1 X188.151 Y136.209 E.0405
G1 X188.151 Y136.743 E.01596
G1 X186.657 Y135.249 E.06307
G1 X186.122 Y135.249 E.01596
G1 X187.674 Y136.801 E.0655
G1 X187.139 Y136.801 E.01596
G1 X185.588 Y135.249 E.0655
G1 X185.053 Y135.249 E.01596
G1 X186.605 Y136.801 E.0655
G1 X186.07 Y136.801 E.01596
G1 X184.519 Y135.249 E.0655
G1 X183.984 Y135.249 E.01596
G1 X185.536 Y136.801 E.0655
G1 X185.001 Y136.801 E.01596
G1 X183.45 Y135.249 E.0655
G1 X182.915 Y135.249 E.01596
G1 X184.466 Y136.801 E.0655
G1 X183.932 Y136.801 E.01596
G1 X182.381 Y135.249 E.0655
G1 X181.846 Y135.249 E.01596
G1 X183.397 Y136.801 E.0655
G1 X182.863 Y136.801 E.01596
G1 X181.312 Y135.249 E.0655
G1 X180.777 Y135.249 E.01596
G1 X182.328 Y136.801 E.0655
G1 X181.794 Y136.801 E.01596
G1 X180.243 Y135.249 E.0655
G1 X179.708 Y135.249 E.01596
G1 X181.259 Y136.801 E.0655
G1 X180.725 Y136.801 E.01596
G1 X179.174 Y135.249 E.0655
G1 X178.639 Y135.249 E.01596
G1 X180.19 Y136.801 E.0655
G1 X179.656 Y136.801 E.01596
G1 X178.105 Y135.249 E.0655
G1 X177.57 Y135.249 E.01596
G1 X179.121 Y136.801 E.0655
G1 X178.587 Y136.801 E.01596
G1 X177.036 Y135.249 E.0655
G1 X176.501 Y135.249 E.01596
G1 X178.052 Y136.801 E.0655
G1 X177.518 Y136.801 E.01596
G1 X175.966 Y135.249 E.0655
G1 X175.551 Y135.249 E.01242
G1 X175.551 Y134.834 E.01242
G1 X170.309 Y129.592 E.2213
G1 X170.309 Y129.249 E.01024
G1 X170.501 Y129.249 E.00572
G1 X175.551 Y134.299 E.21321
G1 X175.551 Y133.764 E.01596
G1 X171.036 Y129.249 E.19064
G1 X171.57 Y129.249 E.01596
G1 X175.551 Y133.23 E.16807
G1 X175.551 Y132.695 E.01596
G1 X172.105 Y129.249 E.1455
G1 X172.639 Y129.249 E.01596
G1 X175.551 Y132.161 E.12293
G1 X175.551 Y131.626 E.01596
G1 X173.174 Y129.249 E.10037
G1 X173.708 Y129.249 E.01596
G1 X175.551 Y131.092 E.0778
G1 X175.551 Y130.557 E.01596
G1 X174.243 Y129.249 E.05523
G1 X174.777 Y129.249 E.01596
G1 X175.551 Y130.023 E.03266
G1 X175.551 Y129.488 E.01596
M73 P58 R8
G1 X175.142 Y129.08 E.01725
M204 S10000
G1 X176.087 Y129.025 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.66758
G1 F5763.136
M204 S8000
G1 X188.687 Y129.025 E.62173
; COOLING_NODE: 13
; WIPE_START
G1 X186.687 Y129.025 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X179.58 Y126.243 Z1.4 F60000
G1 X166.884 Y121.274 Z1.4
G1 Z1
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X160.916 Y121.274 E.1919
G1 X160.916 Y111.416 E.31698
G1 X166.884 Y111.416 E.1919
G1 X166.884 Y116.247 E.15533
G1 X166.657 Y116.263 E.00732
G2 X166.658 Y116.74 I-2.555 J.243 E.50324
G1 X166.884 Y116.757 E.00729
G1 X166.884 Y121.214 E.14331
; COOLING_NODE: 13
; WIPE_START
G1 X164.884 Y121.234 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X164.979 Y114.534 Z1.4 F60000
G1 Z1
G1 E.8 F1800
G1 F8843.478
M204 S8000
G1 X165.298 Y114.704 E.0116
G3 X163.872 Y114.352 I-1.2 J1.795 E.38807
G1 X164.088 Y114.34 E.00695
G3 X164.909 Y114.498 I.01 J2.159 E.02704
G1 X164.926 Y114.507 E.00062
; COOLING_NODE: 13
M204 S10000
G1 X164.79 Y114.892 F60000
G1 F8843.478
M204 S8000
G1 X165.072 Y115.043 E.01029
G3 X163.916 Y114.757 I-.973 J1.456 E.31486
G1 X164.091 Y114.747 E.00565
G3 X164.735 Y114.867 I.008 J1.752 E.02121
; COOLING_NODE: 13
M204 S250
G1 X164.609 Y115.239 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G3 X163.957 Y115.147 I-.51 J1.26 E.23462
G1 X164.094 Y115.14 E.00407
G3 X164.553 Y115.218 I.006 J1.359 E.01396
; COOLING_NODE: 13
; WIPE_START
M204 S8000
G1 X164.855 Y115.369 E-.12833
G1 X165.062 Y115.538 E-.10151
G1 X165.157 Y115.644 E-.05395
G1 X165.311 Y115.881 E-.10772
G1 X165.406 Y116.119 E-.09715
G1 X165.454 Y116.375 E-.0991
G1 X165.453 Y116.641 E-.10114
G1 X165.417 Y116.825 E-.0711
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X167.291 Y121.681 Z1.4 F60000
G1 Z1
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X160.509 Y121.681 E.21808
G1 X160.509 Y111.009 E.34316
G1 X167.291 Y111.009 E.21808
G1 X167.291 Y121.621 E.34123
; COOLING_NODE: 13
M204 S10000
G1 X168.09 Y121.292 F60000
G1 F8843.478
M204 S8000
G1 X168.098 Y121.292 E.00025
G1 X168.098 Y122.088 E.02559
G1 X160.102 Y122.088 E.25712
G1 X160.102 Y110.602 E.36934
G1 X167.698 Y110.602 E.24426
G1 X167.698 Y121.292 E.34375
G1 X168.03 Y121.292 E.01068
; COOLING_NODE: 12
M204 S250
G1 X168.09 Y120.9 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2159
M204 S5000
G1 X168.49 Y120.9 E.01191
G1 X168.49 Y122.48 E.04706
G1 X159.71 Y122.48 E.26153
G1 X159.71 Y110.21 E.36548
G1 X168.09 Y110.21 E.24961
G1 X168.09 Y120.84 E.31663
; WIPE_START
G1 F9547.055
M204 S8000
G1 X168.49 Y120.9 E-.1537
G1 X168.49 Y122.48 E-.60041
G1 X168.474 Y122.48 E-.00589
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X166.488 Y117.949 Z1.4 F60000
G1 Z1
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.125094
G1 F15000
M204 S8000
G1 X166.68 Y117.673 E.00218
; WIPE_START
G1 X166.488 Y117.949 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X166.524 Y116.501 Z1.4 F60000
G1 Z1
G1 E.8 F1800
; LINE_WIDTH: 0.11409
G1 F15000
M204 S8000
G1 X166.806 Y116.502 E.00158
; LINE_WIDTH: 0.148427
G1 X167.087 Y116.502 E.00235
; WIPE_START
G1 X166.806 Y116.502 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X166.68 Y115.327 Z1.4 F60000
G1 Z1
G1 E.8 F1800
; LINE_WIDTH: 0.125032
G1 F15000
M204 S8000
G1 X166.488 Y115.051 E.00218
M204 S10000
G1 X166.388 Y114.639 F60000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F9547.299
M204 S8000
G1 X166.492 Y114.544 E.00419
G1 X166.492 Y111.808 E.0815
G1 X161.308 Y111.808 E.15439
G1 X161.308 Y114.766 E.08811
G1 X161.618 Y114.654 E.00981
G1 X161.741 Y114.737 E.00444
G1 X162.015 Y114.4 E.01294
G1 X162.433 Y114.054 E.01614
G1 X162.879 Y113.808 E.01519
G1 X163.469 Y113.608 E.01854
G1 X163.811 Y113.554 E.01032
G1 X164.346 Y113.55 E.01593
G1 X164.9 Y113.651 E.01679
G1 X165.474 Y113.879 E.0184
G1 X165.949 Y114.189 E.01687
G3 X166.35 Y114.593 I-2.027 J2.41 E.01698
M204 S10000
G1 X166.115 Y113.846 F60000
G1 F9547.299
M204 S8000
G1 X166.115 Y112.185 E.04947
G1 X161.685 Y112.185 E.13193
G1 X161.689 Y114.19 E.05972
G1 X162.192 Y113.764 E.01964
G1 X162.7 Y113.477 E.01737
G1 X163.356 Y113.249 E.0207
G3 X164.97 Y113.28 I.736 J3.646 E.04846
G1 X165.616 Y113.529 E.02062
G1 X166.064 Y113.814 E.01582
M204 S10000
G1 X165.709 Y113.13 F60000
; LINE_WIDTH: 0.47686
G1 F8296.077
M204 S8000
G1 X165.709 Y112.591 E.01847
; LINE_WIDTH: 0.459268
G1 F8646.623
G1 X165.39 Y112.573 E.0105
; LINE_WIDTH: 0.424083
G1 F9444.791
G1 X165.072 Y112.556 E.00961
; LINE_WIDTH: 0.3819
G1 F10620.096
G1 X164.543 Y112.531 E.01418
; LINE_WIDTH: 0.363138
G1 F11242.351
G2 X163.194 Y112.552 I-.442 J15.284 E.03413
; LINE_WIDTH: 0.418598
G1 F9582.687
G1 X162.93 Y112.572 E.00785
; LINE_WIDTH: 0.458933
G1 F8653.586
G1 X162.666 Y112.592 E.0087
; LINE_WIDTH: 0.494735
G1 F7967.863
G1 X162.395 Y112.608 E.0097
; LINE_WIDTH: 0.536115
G1 F7299.35
G1 X162.123 Y112.623 E.01059
G1 X162.123 Y113.291 E.02603
G1 X162.547 Y113.07 E.01862
; LINE_WIDTH: 0.505272
G1 F7786.281
G1 X162.78 Y113.013 E.00877
; LINE_WIDTH: 0.462535
G1 F8579.292
G1 X163.014 Y112.956 E.00796
; LINE_WIDTH: 0.419799
G1 F9552.154
G1 X163.247 Y112.899 E.00715
; LINE_WIDTH: 0.374395
G1 F10860.548
G1 X163.805 Y112.835 E.01471
; LINE_WIDTH: 0.349265
G1 F11751.457
G1 X164.346 Y112.832 E.01308
; LINE_WIDTH: 0.36275
G1 F11255.979
G1 X164.692 Y112.874 E.00881
; LINE_WIDTH: 0.39191
G1 F10315.482
G1 X165.038 Y112.916 E.00962
; LINE_WIDTH: 0.424083
G1 F9444.791
G1 X165.224 Y112.963 E.00578
; LINE_WIDTH: 0.469416
G1 F8440.881
G3 X165.654 Y113.107 I-.298 J1.593 E.0153
; WIPE_START
G1 X165.411 Y113.009 E-.43841
G1 X165.224 Y112.963 E-.32159
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X161.599 Y115.289 Z1.4 F60000
G1 Z1
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.387894
G1 F10435.574
M204 S8000
G1 X161.357 Y115.41 E.00737
; LINE_WIDTH: 0.415228
G1 F9669.432
G1 X161.341 Y115.419 E.00054
; LINE_WIDTH: 0.440391
G1 F9057.273
G1 X161.325 Y115.427 E.00058
; LINE_WIDTH: 0.432155
G1 F9248.916
G1 X161.304 Y115.552 E.00388
; LINE_WIDTH: 0.387969
G1 F10433.317
G1 X161.281 Y115.692 E.00387
; LINE_WIDTH: 0.350521
G1 F11703.471
G1 X161.266 Y115.817 E.00305
; LINE_WIDTH: 0.319726
G1 F13005.525
G1 X161.25 Y115.953 E.00299
; LINE_WIDTH: 0.284888
G1 F14878.018
G1 X161.231 Y116.212 E.00496
; LINE_WIDTH: 0.258284
G1 F15000
G1 X161.231 Y116.773 E.00954
; LINE_WIDTH: 0.285159
G1 F14861.357
G1 X161.251 Y117.062 E.00554
; LINE_WIDTH: 0.32375
G1 F12819.149
G1 X161.269 Y117.204 E.00318
; LINE_WIDTH: 0.360772
G1 F11326.04
G1 X161.289 Y117.363 E.00402
; LINE_WIDTH: 0.399113
G1 F10106.9
G1 X161.324 Y117.569 E.00588
; LINE_WIDTH: 0.435238
G1 F9176.243
G1 X161.36 Y117.774 E.00648
; WIPE_START
G1 X161.324 Y117.569 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X163.344 Y120.132 Z1.4 F60000
G1 Z1
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.39296
G1 F10284.539
M204 S8000
G1 X163.677 Y120.15 E.0092
; LINE_WIDTH: 0.359915
G1 F11356.655
G2 X164.713 Y120.144 I.483 J-5.622 E.02599
; LINE_WIDTH: 0.39209
G1 F10310.164
G1 X164.726 Y120.143 E.00036
; WIPE_START
G1 X164.713 Y120.144 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X163.344 Y120.132 Z1.4 F60000
G1 Z1
G1 E.8 F1800
; LINE_WIDTH: 0.419303
G1 F9564.731
M204 S8000
G3 X162.063 Y119.591 I.857 J-3.824 E.04158
G1 X162.063 Y120.127 E.01593
G3 X163.284 Y120.131 I.42 J61.523 E.03633
; WIPE_START
G1 X162.063 Y120.127 E-.46429
G1 X162.063 Y119.591 E-.20366
G1 X162.27 Y119.717 E-.09205
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X165.772 Y120.162 Z1.4 F60000
G1 Z1
G1 E.8 F1800
; LINE_WIDTH: 0.361347
G1 F11305.593
M204 S8000
G1 X165.772 Y119.774 E.00975
G3 X164.852 Y120.143 I-5.457 J-12.281 E.02493
G2 X165.712 Y120.162 I.813 J-17.194 E.02163
M204 S10000
G1 X166.115 Y120.505 F60000
; LINE_WIDTH: 0.41999
G1 F9547.299
M204 S8000
G1 X166.115 Y119.149 E.04039
G1 X165.614 Y119.472 E.01774
G3 X164.15 Y119.835 I-1.598 J-3.307 E.04525
G1 X163.516 Y119.784 E.01895
G3 X162.04 Y119.123 I.745 J-3.643 E.04856
G1 X161.687 Y118.803 E.01418
G2 X161.685 Y120.505 I222.83 J1.107 E.05067
G1 X166.055 Y120.505 E.13014
M204 S10000
G1 X166.492 Y120.882 F60000
G1 F9547.299
M204 S8000
G1 X166.492 Y118.43 E.07303
G1 X166.385 Y118.381 E.00349
G1 X166.014 Y118.757 E.01574
G1 X165.504 Y119.106 E.01841
G1 X164.983 Y119.325 E.01684
G3 X163.553 Y119.409 I-.91 J-3.287 E.04298
G1 X163.215 Y119.324 E.01038
G1 X162.722 Y119.12 E.01589
G1 X162.249 Y118.809 E.01686
G1 X161.988 Y118.573 E.0105
G1 X161.643 Y118.123 E.01687
G1 X161.308 Y118.181 E.01011
G1 X161.308 Y120.882 E.08043
G1 X166.432 Y120.882 E.15261
; CHANGE_LAYER
; Z_HEIGHT: 1.025
; LAYER_HEIGHT: 0.025
; WIPE_START
G1 F9547.299
G1 X164.432 Y120.882 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 8/37
; update layer progress
M73 L8
M991 S0 P7 ;notify layer change

; OBJECT_ID: 15
M204 S10000
G17
G3 Z1.4 I-.893 J.827 P1  F60000
G1 X168.512 Y125.287 Z1.4
G1 Z1.025
G1 E.8 F1800
; FEATURE: Support
; LINE_WIDTH: 0.42
; LAYER_HEIGHT: 0.275
G1 F7252.893
M204 S8000
G1 X168.512 Y123.229 E.08069
G1 X159.688 Y123.229 E.34594
G1 X159.688 Y125.475 E.08809
G1 X168.512 Y125.475 E.34594
G1 X168.512 Y126.961 E.05828
G1 X168.337 Y126.961 E.00685
G1 X168.021 Y127.277 E.01749
G1 X168.021 Y128.352 E.04216
G1 X159.688 Y128.352 E.32672
G1 X159.688 Y130.971 E.1027
G1 X168.021 Y130.971 E.32672
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

G1 X168.021 Y128.541 E.0953
; CHANGE_LAYER
; Z_HEIGHT: 1.2
; LAYER_HEIGHT: 0.175
; WIPE_START
G1 X168.021 Y130.541 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 9/37
; update layer progress
M73 L9
M991 S0 P8 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z1.425 I-.771 J.942 P1  F60000
G1 X188.525 Y147.313 Z1.425
G1 Z1.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
; LAYER_HEIGHT: 0.2
G1 F8843.478
M204 S8000
G1 X188.917 Y147.313 E.01261
G1 X188.917 Y181.697 E1.10567
G1 X182.473 Y181.697 E.20722
G1 X182.473 Y147.313 E1.10567
G1 X188.465 Y147.313 E.19268
; COOLING_NODE: 0
M204 S250
G1 X188.525 Y147.705 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X188.525 Y181.305 E1.00083
G1 X182.865 Y181.305 E.16859
G1 X182.865 Y147.705 E1.00083
G1 X188.465 Y147.705 E.1668
; COOLING_NODE: 0
; WIPE_START
M204 S8000
G1 X188.469 Y149.705 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X181.081 Y151.625 Z1.6 F60000
G1 X167.23 Y155.224 Z1.6
G1 Z1.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X166.431 Y155.224 E.0257
G1 X166.431 Y150.766 E.14336
G1 X175.969 Y150.766 E.30672
G1 X175.969 Y155.224 E.14336
G1 X167.29 Y155.224 E.27909
; COOLING_NODE: 0
M204 S10000
G1 X167.23 Y154.817 F60000
G1 F8843.478
M204 S8000
G1 X166.838 Y154.817 E.01261
G1 X166.838 Y151.173 E.11718
G1 X175.562 Y151.173 E.28054
G1 X175.562 Y154.817 E.11718
G1 X167.29 Y154.817 E.266
; COOLING_NODE: 1
M204 S250
G1 X167.23 Y154.425 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X167.23 Y151.565 E.08519
G1 X175.17 Y151.565 E.23651
G1 X175.17 Y154.425 E.08519
G1 X167.29 Y154.425 E.23472
; COOLING_NODE: 1
; WIPE_START
M204 S8000
G1 X167.248 Y152.425 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X166.194 Y144.866 Z1.6 F60000
G1 X166.059 Y143.9 Z1.6
G1 Z1.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X166.059 Y152.899 E.28938
G1 X161.341 Y152.899 E.15172
G1 X161.341 Y143.101 E.31508
G1 X166.059 Y143.101 E.15172
G1 X166.059 Y143.84 E.02377
; COOLING_NODE: 1
M204 S10000
G1 X165.652 Y143.9 F60000
G1 F8843.478
M204 S8000
G1 X165.652 Y152.492 E.27629
G1 X161.748 Y152.492 E.12554
G1 X161.748 Y143.508 E.2889
G1 X165.652 Y143.508 E.12554
G1 X165.652 Y143.84 E.01068
; COOLING_NODE: 2
M204 S250
G1 X165.26 Y143.9 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X165.26 Y152.1 E.24425
G1 X162.14 Y152.1 E.09293
G1 X162.14 Y143.9 E.24425
G1 X165.2 Y143.9 E.09115
; COOLING_NODE: 2
; WIPE_START
M204 S8000
G1 X165.215 Y145.9 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X161.834 Y142.694 Z1.6 F60000
G1 Z1.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X160.916 Y142.694 E.02951
G1 X160.916 Y132.926 E.31409
G1 X161.834 Y132.926 E.02951
G1 X161.834 Y142.634 E.31216
; COOLING_NODE: 2
; WIPE_START
G1 X160.916 Y142.694 E-.34943
G1 X160.916 Y141.613 E-.41057
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X168.548 Y141.661 Z1.6 F60000
G1 X176.291 Y141.71 Z1.6
G1 Z1.2
G1 E.8 F1800
G1 F8843.478
M204 S8000
G1 X176.291 Y137.541 E.13406
G1 X188.509 Y137.541 E.3929
G1 X188.509 Y142.509 E.15976
G1 X176.291 Y142.509 E.3929
G1 X176.291 Y141.77 E.02377
; COOLING_NODE: 2
M204 S10000
G1 X176.698 Y141.71 F60000
G1 F8843.478
M204 S8000
G1 X176.698 Y137.948 E.12097
G1 X188.102 Y137.948 E.36672
G1 X188.102 Y142.102 E.13358
G1 X176.698 Y142.102 E.36672
G1 X176.698 Y141.77 E.01068
; COOLING_NODE: 3
M204 S250
G1 X177.09 Y141.71 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X177.09 Y138.34 E.10038
G1 X187.71 Y138.34 E.31633
G1 X187.71 Y141.71 E.10038
G1 X177.15 Y141.71 E.31455
; COOLING_NODE: 3
; WIPE_START
M204 S8000
G1 X177.114 Y139.71 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X176 Y147.261 Z1.6 F60000
G1 X174.709 Y156.009 Z1.6
G1 Z1.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X181.191 Y156.009 E.20845
G1 X181.191 Y160.991 E.16022
G1 X174.709 Y160.991 E.20845
G1 X174.709 Y156.069 E.15829
; COOLING_NODE: 3
; WIPE_START
G1 X176.709 Y156.05 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X180.784 Y159.785 Z1.6 F60000
G1 Z1.2
G1 E.8 F1800
G1 F8843.478
M204 S8000
G1 X180.784 Y160.584 E.0257
G1 X175.116 Y160.584 E.18227
G1 X175.116 Y156.416 E.13404
G1 X180.784 Y156.416 E.18227
G1 X180.784 Y159.725 E.10641
; COOLING_NODE: 3
M204 S10000
G1 X180.377 Y159.785 F60000
G1 F8843.478
M204 S8000
G1 X180.377 Y160.177 E.01261
G1 X175.523 Y160.177 E.15609
G1 X175.523 Y156.823 E.10786
G1 X180.377 Y156.823 E.15609
G1 X180.377 Y159.725 E.09332
; COOLING_NODE: 4
M204 S250
G1 X179.985 Y159.785 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X175.915 Y159.785 E.12123
G1 X175.915 Y157.215 E.07655
G1 X179.985 Y157.215 E.12123
G1 X179.985 Y159.725 E.07476
; COOLING_NODE: 4
; WIPE_START
M204 S8000
G1 X177.985 Y159.754 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X179.055 Y167.312 Z1.6 F60000
G1 X183.749 Y200.464 Z1.6
M73 P59 R8
G1 Z1.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X184.056 Y200.253 E.01197
G3 X185.026 Y199.947 I1.243 J2.245 E.03294
G1 X185.269 Y199.932 E.00783
G3 X183.646 Y200.536 I.029 J2.566 E.46168
G1 X183.7 Y200.498 E.00212
; COOLING_NODE: 4
M204 S10000
G1 X183.98 Y200.798 F60000
G1 F8843.478
M204 S8000
G1 X184.253 Y200.61 E.01069
G3 X185.07 Y200.352 I1.046 J1.889 E.02774
G1 X185.274 Y200.34 E.00656
G3 X183.909 Y200.847 I.025 J2.159 E.38843
G1 X183.93 Y200.832 E.00084
; COOLING_NODE: 4
M204 S10000
G1 X184.21 Y201.132 F60000
G1 F8843.478
M204 S8000
G1 X184.451 Y200.967 E.00941
G3 X185.114 Y200.757 I.849 J1.532 E.02253
G1 X185.278 Y200.747 E.00528
G3 X184.161 Y201.167 I.021 J1.751 E.31474
; COOLING_NODE: 5
M204 S250
G1 X184.431 Y201.454 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X184.641 Y201.31 E.00757
G3 X185.157 Y201.147 I.659 J1.189 E.01623
G1 X185.283 Y201.14 E.00376
G3 X184.385 Y201.493 I.017 J1.359 E.22504
; COOLING_NODE: 5
; WIPE_START
M204 S8000
G1 X184.641 Y201.31 E-.11928
G1 X184.881 Y201.206 E-.09959
G1 X185.157 Y201.147 E-.10712
G1 X185.283 Y201.14 E-.04794
G1 X185.559 Y201.165 E-.10547
G1 X185.808 Y201.238 E-.09878
G1 X186.041 Y201.359 E-.09952
G1 X186.21 Y201.494 E-.0823
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X186.382 Y193.864 Z1.6 F60000
G1 X187.71 Y134.916 Z1.6
G1 Z1.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X188.484 Y134.916 E.02488
G1 X188.484 Y137.134 E.07131
G1 X175.884 Y137.134 E.40517
G1 X175.884 Y142.916 E.18594
G1 X188.484 Y142.916 E.40517
G1 X188.484 Y146.499 E.1152
G1 X181.659 Y146.499 E.21947
G1 X181.659 Y182.511 E1.15803
G1 X188.484 Y182.511 E.21947
G1 X188.484 Y208.584 E.8384
G1 X181.641 Y208.584 E.22003
G1 X181.641 Y192.784 E.50807
G1 X176.911 Y192.784 E.1521
G1 X176.911 Y186.889 E.18956
G1 X170.239 Y186.889 E.21456
G1 X170.239 Y192.784 E.18956
G1 X166.466 Y192.784 E.12131
G1 X166.466 Y177.459 E.4928
G1 X160.916 Y177.459 E.17847
G1 X160.916 Y168.566 E.28595
G1 X170.731 Y168.566 E.31561
G1 X170.731 Y159.234 E.3001
G1 X160.916 Y159.234 E.31561
G1 X160.916 Y153.306 E.19061
G1 X166.024 Y153.306 E.16424
G1 X166.024 Y155.631 E.07476
G1 X176.376 Y155.631 E.3329
G1 X176.376 Y150.359 E.16954
G1 X166.466 Y150.359 E.31867
G1 X166.466 Y142.806 E.24286
G1 X167.366 Y142.806 E.02894
G1 X167.366 Y132.926 E.3177
G1 X169.976 Y132.926 E.08393
G1 X169.976 Y128.916 E.12895
G1 X175.884 Y128.916 E.18997
G1 X175.884 Y134.916 E.19294
G1 X187.65 Y134.916 E.37836
; COOLING_NODE: 5
; WIPE_START
G1 X188.484 Y134.916 E-.31685
G1 X188.484 Y136.082 E-.44315
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X187.71 Y129.541 Z1.6 F60000
G1 Z1.2
G1 E.8 F1800
G1 F8843.478
M204 S8000
G1 X188.509 Y129.541 E.0257
G1 X188.509 Y134.509 E.15976
G1 X176.291 Y134.509 E.3929
G1 X176.291 Y129.541 E.15976
G1 X187.65 Y129.541 E.36527
; COOLING_NODE: 5
M204 S10000
G1 X187.71 Y129.948 F60000
G1 F8843.478
M204 S8000
G1 X188.102 Y129.948 E.01261
G1 X188.102 Y134.102 E.13358
G1 X176.698 Y134.102 E.36672
G1 X176.698 Y129.948 E.13358
G1 X187.65 Y129.948 E.35218
; COOLING_NODE: 6
M204 S250
G1 X187.71 Y130.34 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X187.71 Y133.71 E.10038
G1 X177.09 Y133.71 E.31633
G1 X177.09 Y130.34 E.10038
G1 X187.65 Y130.34 E.31455
; COOLING_NODE: 6
; WIPE_START
M204 S8000
G1 X187.686 Y132.34 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X184.295 Y139.178 Z1.6 F60000
G1 X170.324 Y167.36 Z1.6
G1 Z1.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X170.324 Y168.159 E.0257
G1 X161.065 Y168.159 E.29774
G1 X161.065 Y159.641 E.27392
G1 X170.324 Y159.641 E.29774
G1 X170.324 Y167.3 E.24629
; COOLING_NODE: 6
M204 S10000
G1 X169.917 Y167.36 F60000
G1 F8843.478
M204 S8000
G1 X169.917 Y167.752 E.01261
G1 X161.472 Y167.752 E.27156
G1 X161.472 Y160.048 E.24774
G1 X169.917 Y160.048 E.27156
G1 X169.917 Y167.3 E.2332
; COOLING_NODE: 7
M204 S250
G1 X169.525 Y167.36 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X161.864 Y167.36 E.22819
G1 X161.864 Y160.44 E.20612
G1 X169.525 Y160.44 E.22819
G1 X169.525 Y167.3 E.20434
; COOLING_NODE: 7
; WIPE_START
M204 S8000
G1 X167.525 Y167.316 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X166.87 Y174.92 Z1.6 F60000
G1 X166.059 Y184.325 Z1.6
G1 Z1.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X166.059 Y185.124 E.0257
G1 X161.341 Y185.124 E.15172
G1 X161.341 Y177.866 E.2334
G1 X166.059 Y177.866 E.15172
G1 X166.059 Y184.265 E.20577
; COOLING_NODE: 7
M204 S10000
G1 X165.652 Y184.325 F60000
G1 F8843.478
M204 S8000
G1 X165.652 Y184.717 E.01261
G1 X161.748 Y184.717 E.12554
G1 X161.748 Y178.273 E.20722
G1 X165.652 Y178.273 E.12554
G1 X165.652 Y184.265 E.19268
; COOLING_NODE: 8
M204 S250
G1 X165.26 Y184.325 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X162.14 Y184.325 E.09293
G1 X162.14 Y178.665 E.16859
G1 X165.26 Y178.665 E.09293
G1 X165.26 Y184.265 E.1668
; COOLING_NODE: 8
; WIPE_START
M204 S8000
G1 X163.26 Y184.303 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X167.533 Y177.979 Z1.6 F60000
G1 X188.525 Y146.906 Z1.6
G1 Z1.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X182.066 Y146.906 E.2077
G1 X182.066 Y182.104 E1.13185
G1 X188.891 Y182.104 E.21947
G1 X188.891 Y208.991 E.86458
G1 X181.234 Y208.991 E.24621
G1 X181.234 Y193.191 E.50807
G1 X176.504 Y193.191 E.1521
G1 X176.504 Y187.296 E.18956
G1 X170.646 Y187.296 E.18838
G1 X170.646 Y193.191 E.18956
G1 X166.059 Y193.191 E.14749
G1 X166.059 Y185.866 E.23555
G1 X161.341 Y185.866 E.15172
G1 X161.341 Y193.191 E.23555
G1 X160.509 Y193.191 E.02675
G1 X160.509 Y132.519 E1.95098
G1 X162.241 Y132.519 E.05569
G1 X162.241 Y142.399 E.3177
G1 X166.959 Y142.399 E.15172
G1 X166.959 Y132.519 E.3177
G1 X169.569 Y132.519 E.08393
G1 X169.569 Y128.509 E.12895
G1 X188.891 Y128.509 E.62132
G1 X188.891 Y146.906 E.59157
G1 X188.585 Y146.906 E.00984
; COOLING_NODE: 8
; WIPE_START
G1 X186.585 Y146.906 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X179.164 Y145.121 Z1.6 F60000
G1 X166.16 Y141.992 Z1.6
G1 Z1.2
G1 E.8 F1800
G1 F8843.478
M204 S8000
G1 X162.648 Y141.992 E.11294
G1 X162.648 Y133.008 E.2889
G1 X166.552 Y133.008 E.12554
G1 X166.552 Y141.992 E.2889
G1 X166.22 Y141.992 E.01068
; COOLING_NODE: 9
M204 S250
G1 X166.16 Y141.6 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X163.04 Y141.6 E.09293
G1 X163.04 Y133.4 E.24425
G1 X166.16 Y133.4 E.09293
G1 X166.16 Y141.54 E.24246
; COOLING_NODE: 9
; WIPE_START
M204 S8000
G1 X164.16 Y141.578 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X163.798 Y149.202 Z1.6 F60000
G1 X161.748 Y192.325 Z1.6
G1 Z1.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X161.748 Y186.273 E.19461
G1 X165.652 Y186.273 E.12554
G1 X165.652 Y192.717 E.20722
G1 X161.748 Y192.717 E.12554
G1 X161.748 Y192.385 E.01068
; COOLING_NODE: 10
M204 S250
G1 X162.14 Y192.325 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X162.14 Y186.665 E.16859
G1 X165.26 Y186.665 E.09293
G1 X165.26 Y192.325 E.16859
G1 X162.2 Y192.325 E.09115
; COOLING_NODE: 10
; WIPE_START
M204 S8000
G1 X162.179 Y190.325 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X169.672 Y188.873 Z1.6 F60000
G1 X175.705 Y187.703 Z1.6
G1 Z1.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X176.097 Y187.703 E.01261
G1 X176.097 Y192.697 E.16059
G1 X171.053 Y192.697 E.1622
G1 X171.053 Y187.703 E.16059
G1 X175.645 Y187.703 E.14766
; COOLING_NODE: 11
M204 S250
G1 X175.705 Y188.095 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X175.705 Y192.305 E.1254
G1 X171.445 Y192.305 E.12689
G1 X171.445 Y188.095 E.1254
G1 X175.645 Y188.095 E.1251
; COOLING_NODE: 11
; WIPE_START
M204 S8000
G1 X175.673 Y190.095 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X174.822 Y182.51 Z1.6 F60000
G1 X169.162 Y132.112 Z1.6
G1 Z1.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X169.162 Y128.102 E.12895
G1 X189.298 Y128.102 E.6475
G1 X189.298 Y146.502 E.59168
G1 X189.898 Y146.502 E.01929
G1 X189.898 Y182.498 E1.1575
G1 X189.298 Y182.498 E.01929
G1 X189.298 Y209.398 E.86501
G1 X180.827 Y209.398 E.27239
G1 X180.827 Y193.598 E.50807
G1 X160.102 Y193.598 E.66644
M73 P60 R8
G1 X160.102 Y132.112 E1.97716
G1 X169.102 Y132.112 E.28941
; COOLING_NODE: 12
M204 S250
G1 X168.77 Y131.72 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2045
M204 S5000
G1 X168.77 Y127.71 E.11944
G1 X189.69 Y127.71 E.62314
G1 X189.69 Y146.11 E.54807
G1 X190.29 Y146.11 E.01787
G1 X190.29 Y182.89 E1.09555
G1 X189.69 Y182.89 E.01787
G1 X189.69 Y209.79 E.80126
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

G1 X180.435 Y209.79 E.27568
G1 X180.435 Y193.99 E.47063
G1 X159.71 Y193.99 E.61733
G1 X159.71 Y131.72 E1.85481
G1 X168.71 Y131.72 E.26808
; WIPE_START
G1 F9547.055
M204 S8000
G1 X168.74 Y129.72 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X167.965 Y133.09 Z1.6 F60000
G1 Z1.2
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.4213
G1 F9514.245
M204 S8000
G1 X167.699 Y133.356 E.01124
G1 X167.699 Y133.891 E.01599
G1 X168.331 Y133.259 E.02668
G1 X168.866 Y133.259 E.01599
G1 X167.699 Y134.426 E.0493
G1 X167.699 Y134.961 E.01599
G1 X169.401 Y133.259 E.07192
G1 X169.936 Y133.259 E.01599
G1 X167.699 Y135.496 E.09454
G1 X167.699 Y136.031 E.01599
G1 X174.481 Y129.249 E.28666
G1 X175.016 Y129.249 E.01599
G1 X167.699 Y136.566 E.30928
G1 X167.699 Y137.101 E.01599
G1 X175.551 Y129.25 E.33187
G1 X175.551 Y129.785 E.01599
G1 X167.699 Y137.636 E.33187
G1 X167.699 Y138.172 E.01599
G1 X175.551 Y130.32 E.33187
G1 X175.551 Y130.855 E.01599
G1 X167.699 Y138.707 E.33187
G1 X167.699 Y139.242 E.01599
G1 X175.551 Y131.39 E.33187
G1 X175.551 Y131.926 E.01599
G1 X167.699 Y139.777 E.33187
G1 X167.699 Y140.312 E.01599
G1 X175.551 Y132.461 E.33187
G1 X175.551 Y132.996 E.01599
G1 X167.699 Y140.847 E.33187
G1 X167.699 Y141.382 E.01599
G1 X175.551 Y133.531 E.33187
G1 X175.551 Y134.066 E.01599
G1 X167.699 Y141.917 E.33187
G1 X167.699 Y142.452 E.01599
G1 X175.551 Y134.601 E.33187
G1 X175.551 Y135.136 E.01599
G1 X166.799 Y143.888 E.36992
G1 X166.799 Y144.423 E.01599
G1 X175.973 Y135.249 E.38775
G1 X176.508 Y135.249 E.01599
G1 X166.63 Y145.127 E.41754
; WIPE_START
G1 X168.044 Y143.713 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X167.182 Y142.97 Z1.6 F60000
G1 Z1.2
G1 E.8 F1800
G1 F9514.245
M204 S8000
G1 X166.63 Y143.522 E.02335
M204 S10000
G1 X166.263 Y142.75 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.33758
G1 F12217.47
M204 S8000
G1 X162.037 Y142.75 E.09834
; WIPE_START
G1 X164.037 Y142.75 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X162.578 Y150.242 Z1.6 F60000
G1 X160.787 Y159.437 Z1.6
G1 Z1.2
G1 E.8 F1800
; LINE_WIDTH: 0.19158
G1 F15000
M204 S8000
G1 X160.787 Y168.363 E.10481
M204 S10000
G1 X161.08 Y169.192 F60000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42065
G1 F9530.617
M204 S8000
G1 X161.372 Y168.899 E.01234
G1 X161.906 Y168.899 E.01594
G1 X161.249 Y169.556 E.02772
G1 X161.249 Y170.091 E.01594
G1 X162.441 Y168.899 E.05026
G1 X162.975 Y168.899 E.01594
G1 X161.249 Y170.625 E.07281
G1 X161.249 Y171.159 E.01594
G1 X163.509 Y168.899 E.09535
G1 X164.043 Y168.899 E.01594
G1 X161.249 Y171.693 E.11789
G1 X161.249 Y172.227 E.01594
G1 X164.577 Y168.899 E.14043
G1 X165.111 Y168.899 E.01594
G1 X161.249 Y172.761 E.16297
G1 X161.249 Y173.296 E.01594
G1 X165.646 Y168.899 E.18551
G1 X166.18 Y168.899 E.01594
G1 X161.249 Y173.83 E.20805
G1 X161.249 Y174.364 E.01594
G1 X166.714 Y168.899 E.23059
G1 X167.248 Y168.899 E.01594
G1 X161.249 Y174.898 E.25314
G1 X161.249 Y175.432 E.01594
G1 X167.782 Y168.899 E.27568
G1 X168.317 Y168.899 E.01594
G1 X161.249 Y175.967 E.29822
G1 X161.249 Y176.501 E.01594
G1 X168.851 Y168.899 E.32076
G1 X169.385 Y168.899 E.01594
G1 X161.249 Y177.035 E.3433
G1 X161.249 Y177.126 E.0027
G1 X161.693 Y177.126 E.01323
G1 X169.919 Y168.899 E.34713
G1 X170.453 Y168.899 E.01594
G1 X162.057 Y177.295 E.35429
; WIPE_START
G1 X163.472 Y175.881 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X160.925 Y177.662 Z1.6 F60000
G1 Z1.2
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.467762
G1 F8473.752
M204 S8000
G1 X160.925 Y185.328 E.25724
G1 X160.941 Y185.411 E.00286
; LINE_WIDTH: 0.51702
G1 F7593.335
G1 X160.958 Y185.495 E.00319
; WIPE_START
G1 X160.941 Y185.411 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X165.03 Y191.856 Z1.6 F60000
G1 X165.855 Y193.158 Z1.6
G1 Z1.2
G1 E.8 F1800
; LINE_WIDTH: 0.51671
G1 F7598.303
M204 S8000
G1 X161.544 Y193.158 E.16134
M204 S10000
G1 X160.925 Y192.987 F60000
; LINE_WIDTH: 0.46758
G1 F8477.369
M204 S8000
G1 X160.925 Y185.662 E.24572
; LINE_WIDTH: 0.503353
G1 F7818.736
G1 X160.958 Y185.495 E.0062
G1 X161.003 Y185.495 E.00163
; LINE_WIDTH: 0.475038
G1 F8331.074
G1 X161.048 Y185.495 E.00153
; LINE_WIDTH: 0.436047
G1 F9157.362
G1 X161.092 Y185.495 E.00139
; LINE_WIDTH: 0.397056
G1 F10165.602
G1 X161.137 Y185.495 E.00125
; LINE_WIDTH: 0.37757
G1 F10757.508
G1 X166.263 Y185.495 E.13549
; WIPE_START
G1 X164.263 Y185.495 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X166.63 Y189.283 Z1.6 F60000
G1 Z1.2
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42065
G1 F9530.617
M204 S8000
G1 X181.326 Y174.587 E.62013
G1 X181.326 Y174.053 E.01594
G1 X166.799 Y188.579 E.61297
G1 X166.799 Y188.045 E.01594
G1 X181.326 Y173.519 E.61297
G1 X181.326 Y172.984 E.01594
G1 X166.799 Y187.511 E.61297
G1 X166.799 Y186.977 E.01594
G1 X181.326 Y172.45 E.61297
G1 X181.326 Y171.916 E.01594
M73 P61 R8
G1 X166.799 Y186.442 E.61297
G1 X166.799 Y185.908 E.01594
G1 X181.326 Y171.382 E.61297
G1 X181.326 Y170.848 E.01594
G1 X166.799 Y185.374 E.61297
G1 X166.799 Y184.84 E.01594
G1 X181.326 Y170.314 E.61297
G1 X181.326 Y169.779 E.01594
G1 X166.799 Y184.306 E.61297
G1 X166.799 Y183.771 E.01594
G1 X181.326 Y169.245 E.61297
G1 X181.326 Y168.711 E.01594
G1 X166.799 Y183.237 E.61297
G1 X166.799 Y182.703 E.01594
G1 X181.326 Y168.177 E.61297
G1 X181.326 Y167.643 E.01594
G1 X166.799 Y182.169 E.61297
G1 X166.799 Y181.635 E.01594
G1 X181.326 Y167.108 E.61297
G1 X181.326 Y166.574 E.01594
G1 X166.799 Y181.1 E.61297
G1 X166.799 Y180.566 E.01594
G1 X181.326 Y166.04 E.61297
G1 X181.326 Y165.506 E.01594
G1 X166.799 Y180.032 E.61297
G1 X166.799 Y179.498 E.01594
G1 X181.326 Y164.972 E.61297
G1 X181.326 Y164.437 E.01594
G1 X166.799 Y178.964 E.61297
G1 X166.799 Y178.429 E.01594
G1 X181.326 Y163.903 E.61297
G1 X181.326 Y163.369 E.01594
G1 X166.799 Y177.895 E.61297
G1 X166.799 Y177.361 E.01594
G1 X181.326 Y162.835 E.61297
G1 X181.326 Y162.301 E.01594
G1 X166.501 Y177.126 E.62557
G1 X165.966 Y177.126 E.01594
G1 X181.326 Y161.766 E.64812
G1 X181.326 Y161.528 E.00712
G1 X181.04 Y161.518 E.00853
G1 X165.432 Y177.126 E.65861
G1 X164.898 Y177.126 E.01594
G1 X180.699 Y161.324 E.66677
G1 X180.165 Y161.324 E.01594
G1 X164.364 Y177.126 E.66677
G1 X163.83 Y177.126 E.01594
G1 X179.631 Y161.324 E.66677
G1 X179.097 Y161.324 E.01594
G1 X163.295 Y177.126 E.66677
G1 X162.761 Y177.126 E.01594
G1 X178.563 Y161.324 E.66677
G1 X178.028 Y161.324 E.01594
G1 X171.064 Y168.288 E.29386
G1 X171.064 Y167.754 E.01594
G1 X177.494 Y161.324 E.27132
G1 X176.96 Y161.324 E.01594
G1 X171.064 Y167.22 E.24878
G1 X171.064 Y166.686 E.01594
G1 X176.426 Y161.324 E.22624
G1 X175.892 Y161.324 E.01594
G1 X171.064 Y166.152 E.2037
G1 X171.064 Y165.617 E.01594
G1 X175.357 Y161.324 E.18116
G1 X174.823 Y161.324 E.01594
G1 X171.064 Y165.083 E.15862
G1 X171.064 Y164.549 E.01594
G1 X174.376 Y161.238 E.13973
G1 X174.376 Y160.704 E.01594
G1 X171.064 Y164.015 E.13973
G1 X171.064 Y163.481 E.01594
G1 X174.376 Y160.169 E.13973
G1 X174.376 Y159.635 E.01594
G1 X171.064 Y162.946 E.13973
G1 X171.064 Y162.412 E.01594
G1 X174.376 Y159.101 E.13973
G1 X174.376 Y158.567 E.01594
G1 X171.064 Y161.878 E.13973
G1 X171.064 Y161.344 E.01594
G1 X174.376 Y158.033 E.13973
G1 X174.376 Y157.498 E.01594
G1 X171.064 Y160.81 E.13973
G1 X171.064 Y160.276 E.01594
G1 X174.376 Y156.964 E.13973
G1 X174.376 Y156.43 E.01594
G1 X171.064 Y159.741 E.13973
G1 X171.064 Y159.207 E.01594
G1 X174.307 Y155.964 E.13684
G1 X173.773 Y155.964 E.01594
G1 X170.837 Y158.901 E.1239
G1 X170.302 Y158.901 E.01594
G1 X173.239 Y155.964 E.1239
G1 X172.705 Y155.964 E.01594
G1 X169.768 Y158.901 E.1239
G1 X169.234 Y158.901 E.01594
G1 X172.17 Y155.964 E.1239
G1 X171.636 Y155.964 E.01594
G1 X168.7 Y158.901 E.1239
G1 X168.166 Y158.901 E.01594
G1 X171.102 Y155.964 E.1239
G1 X170.568 Y155.964 E.01594
G1 X167.632 Y158.901 E.1239
G1 X167.097 Y158.901 E.01594
G1 X170.034 Y155.964 E.1239
G1 X169.499 Y155.964 E.01594
G1 X166.563 Y158.901 E.1239
G1 X166.029 Y158.901 E.01594
G1 X168.965 Y155.964 E.1239
G1 X168.431 Y155.964 E.01594
G1 X165.495 Y158.901 E.1239
G1 X164.961 Y158.901 E.01594
G1 X167.897 Y155.964 E.1239
G1 X167.363 Y155.964 E.01594
G1 X164.426 Y158.901 E.1239
G1 X163.892 Y158.901 E.01594
G1 X166.828 Y155.964 E.1239
G1 X166.294 Y155.964 E.01594
G1 X163.358 Y158.901 E.1239
G1 X162.824 Y158.901 E.01594
G1 X165.76 Y155.964 E.1239
G1 X165.691 Y155.964 E.00207
G1 X165.691 Y155.5 E.01387
G1 X162.29 Y158.901 E.14351
G1 X161.755 Y158.901 E.01594
G1 X165.691 Y154.965 E.16605
G1 X165.691 Y154.431 E.01594
G1 X161.249 Y158.873 E.18741
G1 X161.249 Y158.338 E.01594
G1 X165.691 Y153.897 E.18741
G1 X165.691 Y153.639 E.00769
G1 X165.414 Y153.639 E.00825
G1 X161.249 Y157.804 E.17574
G1 X161.249 Y157.27 E.01594
G1 X164.88 Y153.639 E.1532
G1 X164.346 Y153.639 E.01594
G1 X161.249 Y156.736 E.13066
G1 X161.249 Y156.202 E.01594
G1 X163.812 Y153.639 E.10812
G1 X163.277 Y153.639 E.01594
G1 X161.249 Y155.667 E.08558
G1 X161.249 Y155.133 E.01594
G1 X162.743 Y153.639 E.06304
G1 X162.209 Y153.639 E.01594
G1 X161.249 Y154.599 E.04049
G1 X161.249 Y154.065 E.01594
G1 X161.844 Y153.47 E.02511
M204 S10000
G1 X160.925 Y153.103 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.46758
G1 F8477.369
M204 S8000
G1 X160.925 Y142.897 E.34233
M204 S10000
G1 X161.375 Y142.49 F60000
; LINE_WIDTH: 0.55344
G1 F7051.634
M204 S8000
G1 X161.375 Y133.13 E.37749
; WIPE_START
G1 X161.375 Y135.13 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X162.444 Y132.56 Z1.6 F60000
G1 Z1.2
G1 E.8 F1800
; LINE_WIDTH: 0.53172
G1 F7364.976
M204 S8000
G1 X166.755 Y132.56 E.16645
; WIPE_START
G1 X164.755 Y132.56 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X170.14 Y133.056 Z1.6 F60000
G1 Z1.2
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.4213
G1 F9514.245
M204 S8000
G1 X173.946 Y129.249 E.16089
G1 X173.411 Y129.249 E.01599
G1 X170.309 Y132.351 E.1311
G1 X170.309 Y131.816 E.01599
G1 X172.876 Y129.249 E.10848
G1 X172.341 Y129.249 E.01599
G1 X170.309 Y131.281 E.08586
G1 X170.309 Y130.746 E.01599
G1 X171.806 Y129.249 E.06324
G1 X171.27 Y129.249 E.01599
G1 X170.309 Y130.21 E.04062
G1 X170.309 Y129.675 E.01599
G1 X170.905 Y129.08 E.02518
; WIPE_START
G1 X170.309 Y129.675 E-.3201
G1 X170.309 Y130.21 E-.20334
G1 X170.75 Y129.77 E-.23656
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X176.087 Y129.025 Z1.6 F60000
G1 Z1.2
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.66758
G1 F5763.136
M204 S8000
G1 X188.687 Y129.025 E.62173
; WIPE_START
G1 X186.687 Y129.025 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X187.586 Y136.604 Z1.6 F60000
G1 X187.629 Y136.97 Z1.6
G1 Z1.2
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.4213
G1 F9514.245
M204 S8000
G1 X188.151 Y136.449 E.02203
G1 X188.151 Y135.914 E.01599
G1 X187.264 Y136.801 E.03748
G1 X186.729 Y136.801 E.01599
G1 X188.151 Y135.379 E.0601
G1 X188.151 Y135.249 E.00387
G1 X187.745 Y135.249 E.01212
G1 X186.194 Y136.801 E.06557
G1 X185.659 Y136.801 E.01599
G1 X187.21 Y135.249 E.06557
G1 X186.675 Y135.249 E.01599
G1 X185.124 Y136.801 E.06557
G1 X184.588 Y136.801 E.01599
G1 X186.14 Y135.249 E.06557
G1 X185.605 Y135.249 E.01599
G1 X184.053 Y136.801 E.06557
G1 X183.518 Y136.801 E.01599
G1 X185.07 Y135.249 E.06557
G1 X184.534 Y135.249 E.01599
G1 X182.983 Y136.801 E.06557
G1 X182.448 Y136.801 E.01599
G1 X183.999 Y135.249 E.06557
G1 X183.464 Y135.249 E.01599
G1 X181.913 Y136.801 E.06557
G1 X181.378 Y136.801 E.01599
G1 X182.929 Y135.249 E.06557
G1 X182.394 Y135.249 E.01599
G1 X180.843 Y136.801 E.06557
G1 X180.308 Y136.801 E.01599
G1 X181.859 Y135.249 E.06557
G1 X181.324 Y135.249 E.01599
G1 X179.772 Y136.801 E.06557
G1 X179.237 Y136.801 E.01599
G1 X180.789 Y135.249 E.06557
G1 X180.254 Y135.249 E.01599
G1 X178.702 Y136.801 E.06557
G1 X178.167 Y136.801 E.01599
G1 X179.718 Y135.249 E.06557
G1 X179.183 Y135.249 E.01599
G1 X177.632 Y136.801 E.06557
G1 X177.097 Y136.801 E.01599
G1 X178.648 Y135.249 E.06557
G1 X178.113 Y135.249 E.01599
G1 X176.562 Y136.801 E.06557
G1 X176.027 Y136.801 E.01599
G1 X177.578 Y135.249 E.06557
G1 X177.043 Y135.249 E.01599
G1 X166.799 Y145.493 E.43299
G1 X166.799 Y146.028 E.01599
G1 X175.551 Y137.277 E.36992
G1 X175.551 Y137.812 E.01599
G1 X166.799 Y146.563 E.36992
G1 X166.799 Y147.098 E.01599
G1 X175.551 Y138.347 E.36992
G1 X175.551 Y138.882 E.01599
G1 X166.799 Y147.633 E.36992
G1 X166.799 Y148.168 E.01599
G1 X175.551 Y139.417 E.36992
G1 X175.551 Y139.952 E.01599
G1 X166.799 Y148.704 E.36992
G1 X166.799 Y149.239 E.01599
G1 X175.551 Y140.487 E.36992
G1 X175.551 Y141.022 E.01599
G1 X166.799 Y149.774 E.36992
G1 X166.799 Y150.026 E.00753
G1 X167.083 Y150.026 E.00846
G1 X175.551 Y141.558 E.35794
G1 X175.551 Y142.093 E.01599
G1 X167.618 Y150.026 E.33533
G1 X168.153 Y150.026 E.01599
G1 X175.551 Y142.628 E.31271
G1 X175.551 Y143.163 E.01599
G1 X168.688 Y150.026 E.29009
G1 X169.223 Y150.026 E.01599
G1 X175.999 Y143.249 E.28643
G1 X176.534 Y143.249 E.01599
G1 X169.758 Y150.026 E.28643
G1 X170.293 Y150.026 E.01599
G1 X177.069 Y143.249 E.28643
G1 X177.605 Y143.249 E.01599
G1 X170.828 Y150.026 E.28643
G1 X171.363 Y150.026 E.01599
G1 X178.14 Y143.249 E.28643
G1 X178.675 Y143.249 E.01599
G1 X171.899 Y150.026 E.28643
G1 X172.434 Y150.026 E.01599
G1 X179.21 Y143.249 E.28643
G1 X179.745 Y143.249 E.01599
G1 X172.969 Y150.026 E.28643
G1 X173.504 Y150.026 E.01599
G1 X180.28 Y143.249 E.28643
G1 X180.815 Y143.249 E.01599
G1 X174.039 Y150.026 E.28643
G1 X174.574 Y150.026 E.01599
G1 X181.35 Y143.249 E.28643
G1 X181.885 Y143.249 E.01599
G1 X175.109 Y150.026 E.28643
G1 X175.644 Y150.026 E.01599
G1 X182.421 Y143.249 E.28643
G1 X182.956 Y143.249 E.01599
G1 X176.179 Y150.026 E.28643
G1 X176.709 Y150.031 E.01584
G1 X183.491 Y143.249 E.28665
G1 X184.026 Y143.249 E.01599
G1 X176.54 Y150.736 E.31644
; WIPE_START
G1 X177.954 Y149.321 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X180.096 Y156.647 Z1.6 F60000
G1 X181.425 Y161.195 Z1.6
G1 Z1.2
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.10344
M73 P62 R8
G1 F15000
M204 S8000
G1 X181.425 Y155.805 E.02576
M204 S10000
G1 X180.527 Y155.845 F60000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.4213
G1 F9514.245
M204 S8000
G1 X181.326 Y155.047 E.03377
G1 X181.326 Y154.511 E.01599
G1 X180.161 Y155.676 E.04921
G1 X179.626 Y155.676 E.01599
G1 X181.326 Y153.976 E.07183
G1 X181.326 Y153.441 E.01599
G1 X179.091 Y155.676 E.09445
G1 X178.556 Y155.676 E.01599
G1 X181.326 Y152.906 E.11707
G1 X181.326 Y152.371 E.01599
G1 X178.021 Y155.676 E.13969
G1 X177.486 Y155.676 E.01599
G1 X181.326 Y151.836 E.16231
G1 X181.326 Y151.301 E.01599
G1 X176.951 Y155.676 E.18493
G1 X176.709 Y155.676 E.00722
G1 X176.709 Y155.382 E.00878
G1 X181.326 Y150.766 E.19513
G1 X181.326 Y150.231 E.01599
G1 X176.709 Y154.847 E.19513
G1 X176.709 Y154.312 E.01599
G1 X181.326 Y149.695 E.19513
G1 X181.326 Y149.16 E.01599
G1 X176.709 Y153.777 E.19513
G1 X176.709 Y153.241 E.01599
G1 X181.326 Y148.625 E.19513
G1 X181.326 Y148.09 E.01599
G1 X176.709 Y152.706 E.19513
G1 X176.709 Y152.171 E.01599
G1 X181.326 Y147.555 E.19513
G1 X181.326 Y147.02 E.01599
G1 X176.709 Y151.636 E.19513
G1 X176.709 Y151.101 E.01599
G1 X184.561 Y143.249 E.33189
G1 X185.096 Y143.249 E.01599
G1 X182.18 Y146.166 E.12327
G1 X182.715 Y146.166 E.01599
G1 X185.631 Y143.249 E.12327
G1 X186.166 Y143.249 E.01599
G1 X183.25 Y146.166 E.12327
G1 X183.785 Y146.166 E.01599
G1 X186.701 Y143.249 E.12327
G1 X187.237 Y143.249 E.01599
G1 X184.32 Y146.166 E.12327
G1 X184.855 Y146.166 E.01599
G1 X187.772 Y143.249 E.12327
G1 X188.151 Y143.249 E.01133
G1 X188.151 Y143.406 E.00467
G1 X185.391 Y146.166 E.11667
G1 X185.926 Y146.166 E.01599
G1 X188.151 Y143.941 E.09405
G1 X188.151 Y144.476 E.01599
G1 X186.461 Y146.166 E.07143
G1 X186.996 Y146.166 E.01599
G1 X188.151 Y145.011 E.04881
G1 X188.151 Y145.546 E.01599
G1 X187.531 Y146.166 E.02619
G1 X188.066 Y146.166 E.01599
G1 X188.32 Y145.911 E.01075
; WIPE_START
G1 X188.066 Y146.166 E-.13662
G1 X187.531 Y146.166 E-.20334
G1 X188.151 Y145.546 E-.33301
G1 X188.151 Y145.317 E-.08703
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X189.095 Y147.093 Z1.6 F60000
G1 Z1.2
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.118631
G1 F15000
M204 S8000
G1 X189.12 Y147.083 E.00016
; LINE_WIDTH: 0.165653
G1 X189.146 Y147.074 E.00027
; LINE_WIDTH: 0.212674
G1 X189.172 Y147.065 E.00037
; LINE_WIDTH: 0.259695
G1 X189.198 Y147.055 E.00047
; LINE_WIDTH: 0.306717
G1 F13646.879
G1 X189.224 Y147.046 E.00057
; LINE_WIDTH: 0.353738
G1 F11582.34
G1 X189.25 Y147.037 E.00068
; LINE_WIDTH: 0.40076
G1 F10060.376
G1 X189.276 Y147.028 E.00078
; LINE_WIDTH: 0.447781
G1 F8891.942
G1 X189.302 Y147.018 E.00088
; LINE_WIDTH: 0.494803
G1 F7966.675
G1 X189.327 Y147.009 E.00098
; LINE_WIDTH: 0.541824
G1 F7215.819
G1 X189.353 Y147 E.00108
; LINE_WIDTH: 0.588846
G1 F6594.309
G1 X189.379 Y146.99 E.00119
; LINE_WIDTH: 0.616778
G1 F6273.336
G1 X189.398 Y147.002 E.001
G1 X189.408 Y147.109 E.00487
G1 X189.408 Y181.901 E1.57711
G1 X189.399 Y181.999 E.00448
G1 X189.371 Y182.018 E.00153
; LINE_WIDTH: 0.573214
G1 F6788.692
G1 X189.346 Y182.009 E.00112
; LINE_WIDTH: 0.527681
G1 F7426.342
G1 X189.321 Y182 E.00102
; LINE_WIDTH: 0.482149
G1 F8196.196
G1 X189.296 Y181.99 E.00093
; LINE_WIDTH: 0.436616
G1 F9144.123
G1 X189.27 Y181.981 E.00083
; LINE_WIDTH: 0.391083
G1 F10339.991
G1 X189.245 Y181.972 E.00074
; LINE_WIDTH: 0.34555
G1 F11895.715
G1 X189.22 Y181.963 E.00064
; LINE_WIDTH: 0.300018
G1 F14002.483
G1 X189.195 Y181.954 E.00054
; LINE_WIDTH: 0.254485
G1 F15000
G1 X189.17 Y181.945 E.00045
; LINE_WIDTH: 0.208952
G1 X189.145 Y181.936 E.00035
; LINE_WIDTH: 0.163419
G1 X189.12 Y181.926 E.00025
; LINE_WIDTH: 0.117887
G1 X189.095 Y181.917 E.00016
; WIPE_START
G1 X189.12 Y181.926 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X183.377 Y186.953 Z1.6 F60000
G1 X176.301 Y193.148 Z1.6
G1 Z1.2
G1 E.8 F1800
; LINE_WIDTH: 0.53672
G1 F7290.401
M204 S8000
G1 X170.849 Y193.148 E.21263
; WIPE_START
G1 X172.849 Y193.148 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X170.075 Y192.248 Z1.6 F60000
G1 Z1.2
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42065
G1 F9530.617
M204 S8000
G1 X169.872 Y192.451 E.00857
G1 X169.338 Y192.451 E.01594
G1 X169.906 Y191.883 E.02395
G1 X169.906 Y191.349 E.01594
G1 X168.804 Y192.451 E.04649
G1 X168.27 Y192.451 E.01594
G1 X169.906 Y190.815 E.06903
G1 X169.906 Y190.281 E.01594
G1 X167.736 Y192.451 E.09157
G1 X167.201 Y192.451 E.01594
G1 X169.906 Y189.746 E.11411
G1 X169.906 Y189.212 E.01594
G1 X166.799 Y192.318 E.13108
G1 X166.799 Y191.784 E.01594
G1 X169.906 Y188.678 E.13108
G1 X169.906 Y188.144 E.01594
G1 X166.799 Y191.25 E.13108
G1 X166.799 Y190.716 E.01594
G1 X169.906 Y187.61 E.13108
G1 X169.906 Y187.075 E.01594
G1 X166.799 Y190.182 E.13108
G1 X166.799 Y189.648 E.01594
G1 X181.326 Y175.121 E.61297
G1 X181.326 Y175.655 E.01594
G1 X170.425 Y186.556 E.45996
G1 X170.96 Y186.556 E.01594
G1 X181.326 Y176.19 E.43742
G1 X181.326 Y176.724 E.01594
G1 X171.494 Y186.556 E.41488
G1 X172.028 Y186.556 E.01594
G1 X181.326 Y177.258 E.39234
G1 X181.326 Y177.792 E.01594
G1 X172.562 Y186.556 E.36979
G1 X173.096 Y186.556 E.01594
G1 X181.326 Y178.326 E.34725
G1 X181.326 Y178.861 E.01594
G1 X173.631 Y186.556 E.32471
G1 X174.165 Y186.556 E.01594
G1 X181.326 Y179.395 E.30217
G1 X181.326 Y179.929 E.01594
G1 X174.699 Y186.556 E.27963
G1 X175.233 Y186.556 E.01594
G1 X181.326 Y180.463 E.25709
G1 X181.326 Y180.997 E.01594
G1 X175.767 Y186.556 E.23455
G1 X176.302 Y186.556 E.01594
G1 X181.326 Y181.532 E.212
G1 X181.326 Y182.066 E.01594
M73 P62 R7
G1 X176.836 Y186.556 E.18946
G1 X177.244 Y186.556 E.01219
G1 X177.244 Y186.681 E.00375
G1 X181.326 Y182.6 E.17222
G1 X181.326 Y182.844 E.00729
G1 X181.615 Y182.844 E.00864
G1 X177.244 Y187.215 E.18444
G1 X177.244 Y187.75 E.01594
G1 X182.15 Y182.844 E.20699
G1 X182.684 Y182.844 E.01594
G1 X177.244 Y188.284 E.22953
G1 X177.244 Y188.818 E.01594
G1 X183.218 Y182.844 E.25207
G1 X183.752 Y182.844 E.01594
G1 X177.244 Y189.352 E.27461
G1 X177.244 Y189.886 E.01594
G1 X184.286 Y182.844 E.29715
G1 X184.82 Y182.844 E.01594
G1 X177.244 Y190.421 E.31969
G1 X177.244 Y190.955 E.01594
G1 X185.355 Y182.844 E.34223
G1 X185.889 Y182.844 E.01594
G1 X177.244 Y191.489 E.36477
G1 X177.244 Y192.023 E.01594
G1 X186.423 Y182.844 E.38732
G1 X186.957 Y182.844 E.01594
G1 X177.351 Y192.451 E.40536
G1 X177.885 Y192.451 E.01594
G1 X187.491 Y182.844 E.40536
G1 X188.026 Y182.844 E.01594
G1 X178.419 Y192.451 E.40536
G1 X178.954 Y192.451 E.01594
G1 X188.151 Y183.254 E.38809
G1 X188.151 Y183.788 E.01594
G1 X179.488 Y192.451 E.36555
G1 X180.022 Y192.451 E.01594
G1 X188.151 Y184.322 E.34301
G1 X188.151 Y184.856 E.01594
G1 X180.556 Y192.451 E.32047
G1 X181.09 Y192.451 E.01594
G1 X188.151 Y185.39 E.29793
G1 X188.151 Y185.925 E.01594
G1 X181.625 Y192.451 E.27538
G1 X181.974 Y192.451 E.01044
G1 X181.974 Y192.635 E.0055
G1 X188.151 Y186.459 E.26062
G1 X188.151 Y186.993 E.01594
G1 X181.974 Y193.169 E.26062
G1 X181.974 Y193.703 E.01594
G1 X188.151 Y187.527 E.26062
G1 X188.151 Y188.061 E.01594
G1 X181.974 Y194.238 E.26062
G1 X181.974 Y194.772 E.01594
G1 X188.151 Y188.595 E.26062
G1 X188.151 Y189.13 E.01594
G1 X181.974 Y195.306 E.26062
G1 X181.974 Y195.84 E.01594
G1 X188.151 Y189.664 E.26062
G1 X188.151 Y190.198 E.01594
G1 X181.974 Y196.374 E.26062
G1 X181.974 Y196.909 E.01594
G1 X188.151 Y190.732 E.26062
G1 X188.151 Y191.266 E.01594
G1 X181.974 Y197.443 E.26062
G1 X181.974 Y197.977 E.01594
G1 X188.151 Y191.801 E.26062
G1 X188.151 Y192.335 E.01594
G1 X181.974 Y198.511 E.26062
G1 X181.974 Y199.045 E.01594
G1 X188.151 Y192.869 E.26062
G1 X188.151 Y193.403 E.01594
G1 X181.974 Y199.579 E.26062
G1 X181.974 Y200.114 E.01594
G1 X188.151 Y193.937 E.26062
G1 X188.151 Y194.472 E.01594
G1 X181.974 Y200.648 E.26062
G1 X181.974 Y201.182 E.01594
G1 X188.151 Y195.006 E.26062
G1 X188.151 Y195.54 E.01594
G1 X181.805 Y201.886 E.26778
; WIPE_START
G1 X183.219 Y200.472 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X187.802 Y203.712 Z1.6 F60000
G1 Z1.2
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.433574
G1 F9215.323
M204 S8000
G1 X188.076 Y203.573 E.00946
G1 X188.097 Y203.442 E.00409
; LINE_WIDTH: 0.387638
G1 F10443.343
G1 X188.119 Y203.312 E.00361
; LINE_WIDTH: 0.347403
G1 F11823.334
G1 X188.137 Y203.154 E.00383
; LINE_WIDTH: 0.313132
G1 F13322.911
G1 X188.153 Y203.011 E.00305
; LINE_WIDTH: 0.265468
G1 F15000
G1 X188.172 Y202.712 E.00528
G1 X188.166 Y202.162 E.00966
; LINE_WIDTH: 0.293245
G1 F14381.319
G1 X188.144 Y201.895 E.0053
; LINE_WIDTH: 0.334696
G1 F12338.233
G1 X188.124 Y201.744 E.00351
; LINE_WIDTH: 0.37269
G1 F10916.697
G1 X188.106 Y201.606 E.00363
; LINE_WIDTH: 0.409177
G1 F9829.164
G1 X188.071 Y201.407 E.00584
; LINE_WIDTH: 0.439636
G1 F9074.498
G1 X188.038 Y201.225 E.00579
; WIPE_START
G1 X188.071 Y201.407 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X188.32 Y200.178 Z1.6 F60000
G1 Z1.2
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42065
G1 F9530.617
M204 S8000
G1 X187.662 Y200.836 E.02778
G2 X187.426 Y200.538 I-.883 J.456 E.01142
G1 X188.151 Y199.813 E.03058
G1 X188.151 Y199.279 E.01594
G1 X187.156 Y200.274 E.04197
G2 X186.848 Y200.048 I-2.34 J2.861 E.01141
G1 X188.151 Y198.745 E.05497
G1 X188.151 Y198.211 E.01594
G1 X186.496 Y199.866 E.06984
G1 X186.113 Y199.714 E.01228
G1 X188.151 Y197.677 E.08598
G1 X188.151 Y197.143 E.01594
G1 X185.664 Y199.629 E.10492
G1 X185.555 Y199.608 E.00331
G1 X185.147 Y199.612 E.0122
G1 X188.151 Y196.608 E.12676
G1 X188.151 Y196.074 E.01594
G1 X184.514 Y199.711 E.15344
G1 X184.403 Y199.74 E.00343
G1 X183.894 Y199.96 E.01655
G1 X183.437 Y200.275 E.01657
G2 X182.506 Y201.719 I1.937 J2.27 E.05197
G1 X181.974 Y202.25 E.02244
G1 X181.974 Y202.785 E.01594
G1 X182.407 Y202.352 E.01824
G1 X182.423 Y202.87 E.01546
G1 X181.974 Y203.319 E.01892
G1 X181.974 Y203.853 E.01594
G1 X182.52 Y203.307 E.02302
G2 X182.668 Y203.693 I1.059 J-.186 E.01241
G1 X181.974 Y204.387 E.02929
G1 X181.974 Y204.921 E.01594
G1 X182.854 Y204.042 E.03711
G1 X183.072 Y204.358 E.01146
G1 X181.974 Y205.456 E.04632
G1 X181.974 Y205.99 E.01594
G1 X183.334 Y204.63 E.05736
G2 X183.63 Y204.869 I1.388 J-1.422 E.01135
G1 X181.974 Y206.524 E.06985
G1 X181.974 Y207.058 E.01594
G1 X183.96 Y205.072 E.08379
G1 X184.34 Y205.227 E.01223
G1 X181.974 Y207.592 E.09982
G1 X181.974 Y208.127 E.01594
G1 X184.753 Y205.348 E.11726
G2 X185.244 Y205.391 I.474 J-2.555 E.01472
G1 X182.384 Y208.251 E.12066
G1 X182.919 Y208.251 E.01594
G1 X185.827 Y205.342 E.12273
G1 X186.196 Y205.261 E.01126
G1 X186.633 Y205.071 E.01423
G1 X183.453 Y208.251 E.13419
G1 X183.987 Y208.251 E.01594
G1 X188.02 Y204.218 E.17018
G1 X188.151 Y204.152 E.00437
G1 X188.151 Y204.621 E.01401
G1 X184.521 Y208.251 E.15315
G1 X185.055 Y208.251 E.01594
G1 X188.151 Y205.155 E.13061
G1 X188.151 Y205.69 E.01594
G1 X185.59 Y208.251 E.10807
G1 X186.124 Y208.251 E.01594
G1 X188.151 Y206.224 E.08553
G1 X188.151 Y206.758 E.01594
G1 X186.658 Y208.251 E.06299
G1 X187.192 Y208.251 E.01594
G1 X188.151 Y207.292 E.04045
G1 X188.151 Y207.826 E.01594
G1 X187.557 Y208.42 E.02506
; COOLING_NODE: 13
; WIPE_START
G1 X188.151 Y207.826 E-.3192
G1 X188.151 Y207.292 E-.20299
G1 X187.708 Y207.735 E-.23781
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X185.928 Y200.313 Z1.6 F60000
G1 X166.884 Y120.9 Z1.6
G1 Z1.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X166.884 Y121.274 E.01202
G1 X160.916 Y121.274 E.1919
G1 X160.916 Y111.416 E.31698
G1 X166.884 Y111.416 E.1919
G1 X166.884 Y116.237 E.15501
G1 X166.66 Y116.255 E.00723
G2 X166.57 Y117.204 I-2.556 J.236 E.48775
G2 X166.654 Y116.739 I-2.169 J-.637 E.01522
G1 X166.884 Y116.754 E.00739
G1 X166.884 Y120.84 E.13141
; COOLING_NODE: 13
; WIPE_START
G1 X166.884 Y121.274 E-.16484
G1 X165.318 Y121.274 E-.59516
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X164.975 Y114.531 Z1.6 F60000
G1 Z1.2
G1 E.8 F1800
G1 F8843.478
M204 S8000
G1 X165.273 Y114.687 E.01084
G3 X163.871 Y114.352 I-1.175 J1.811 E.38893
G1 X164.074 Y114.34 E.00654
G3 X164.906 Y114.496 I.025 J2.159 E.0274
G1 X164.921 Y114.504 E.00054
; COOLING_NODE: 13
M204 S10000
G1 X164.788 Y114.891 F60000
G1 F8843.478
M204 S8000
G1 X165.053 Y115.03 E.0096
G3 X163.915 Y114.757 I-.954 J1.469 E.31556
G1 X164.078 Y114.747 E.00526
G3 X164.734 Y114.866 I.021 J1.752 E.02155
; COOLING_NODE: 13
M204 S250
G1 X164.609 Y115.239 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G3 X163.957 Y115.147 I-.509 J1.26 E.23461
G1 X164.083 Y115.14 E.00374
G3 X164.553 Y115.218 I.017 J1.359 E.01427
; COOLING_NODE: 13
; WIPE_START
M204 S8000
G1 X164.84 Y115.359 E-.12167
G1 X165.045 Y115.522 E-.09948
G1 X165.215 Y115.72 E-.09916
G1 X165.345 Y115.953 E-.10131
G1 X165.43 Y116.216 E-.10532
G1 X165.46 Y116.475 E-.09891
G1 X165.44 Y116.736 E-.09965
G1 X165.415 Y116.824 E-.0345
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X167.291 Y120.9 Z1.6 F60000
G1 Z1.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X167.291 Y121.681 E.02511
G1 X160.509 Y121.681 E.21808
G1 X160.509 Y111.009 E.34316
G1 X167.291 Y111.009 E.21808
G1 X167.291 Y120.84 E.31613
; COOLING_NODE: 13
M204 S10000
G1 X167.698 Y120.9 F60000
G1 F8843.478
M204 S8000
G1 X167.698 Y121.292 E.01261
G1 X168.098 Y121.292 E.01286
G1 X168.098 Y122.088 E.02559
G1 X160.102 Y122.088 E.25712
G1 X160.102 Y110.602 E.36934
G1 X167.698 Y110.602 E.24426
G1 X167.698 Y120.84 E.32921
; COOLING_NODE: 12
M204 S250
G1 X168.09 Y120.9 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2045
M204 S5000
G1 X168.49 Y120.9 E.01191
G1 X168.49 Y122.48 E.04706
G1 X159.71 Y122.48 E.26153
G1 X159.71 Y110.21 E.36548
G1 X168.09 Y110.21 E.24961
G1 X168.09 Y120.84 E.31663
; WIPE_START
M73 P63 R7
G1 F9547.055
M204 S8000
G1 X168.49 Y120.9 E-.1537
G1 X168.49 Y122.48 E-.60041
G1 X168.474 Y122.48 E-.00589
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X166.499 Y117.93 Z1.6 F60000
G1 Z1.2
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.122358
G1 F15000
M204 S8000
G1 X166.68 Y117.666 E.00201
; WIPE_START
G1 X166.499 Y117.93 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X166.784 Y116.496 Z1.6 F60000
G1 Z1.2
G1 E.8 F1800
; LINE_WIDTH: 0.152592
G1 F15000
M204 S8000
G1 X167.087 Y116.493 E.00263
M204 S10000
G1 X166.784 Y116.496 F60000
; LINE_WIDTH: 0.115477
G1 F15000
M204 S8000
G1 X166.48 Y116.5 E.00174
; WIPE_START
G1 X166.784 Y116.496 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X166.68 Y115.312 Z1.6 F60000
G1 Z1.2
G1 E.8 F1800
; LINE_WIDTH: 0.13862
G1 F15000
M204 S8000
G1 X166.555 Y115.131 E.00167
; LINE_WIDTH: 0.108967
G1 X166.462 Y115.01 E.0008
; WIPE_START
G1 X166.555 Y115.131 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X165.712 Y113.137 Z1.6 F60000
G1 Z1.2
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.47146
G1 F8400.616
M204 S8000
G1 X165.712 Y112.588 E.01856
; LINE_WIDTH: 0.451308
G1 F8815.157
G1 X165.326 Y112.568 E.01247
; LINE_WIDTH: 0.411003
G1 F9780.415
G1 X164.94 Y112.548 E.01124
; LINE_WIDTH: 0.359915
G1 F11356.654
G2 X163.8 Y112.528 I-.836 J15.009 E.02855
; LINE_WIDTH: 0.375085
G1 F10837.986
G1 X163.183 Y112.552 E.01621
; LINE_WIDTH: 0.42008
G1 F9545.02
G1 X162.919 Y112.573 E.00789
; LINE_WIDTH: 0.46098
G1 F8611.204
G1 X162.655 Y112.593 E.00875
; LINE_WIDTH: 0.496113
G1 F7943.644
G1 X162.389 Y112.608 E.00954
; LINE_WIDTH: 0.53311
G1 F7344.098
G1 X162.122 Y112.622 E.01032
G1 X162.122 Y113.294 E.026
G1 X162.581 Y113.059 E.01995
; LINE_WIDTH: 0.496255
G1 F7941.147
G1 X162.8 Y113.006 E.00805
; LINE_WIDTH: 0.457605
G1 F8681.288
G1 X163.018 Y112.953 E.00736
; LINE_WIDTH: 0.418955
G1 F9573.577
G1 X163.237 Y112.901 E.00668
; LINE_WIDTH: 0.375085
G1 F10837.986
G1 X163.802 Y112.835 E.01492
; LINE_WIDTH: 0.359685
G1 F11364.905
G3 X164.891 Y112.889 I.3 J5.02 E.02734
; LINE_WIDTH: 0.409848
G1 F9811.202
G1 X165.149 Y112.945 E.00766
; LINE_WIDTH: 0.458683
G1 F8658.782
G3 X165.657 Y113.112 I-.151 J1.314 E.01769
M204 S10000
G1 X166.115 Y113.855 F60000
; LINE_WIDTH: 0.41999
G1 F9547.299
M204 S8000
G1 X166.115 Y112.185 E.04973
G1 X161.685 Y112.185 E.13193
G1 X161.685 Y114.218 E.06054
G1 X161.997 Y113.911 E.01303
G3 X165.294 Y113.385 I2.113 J2.649 E.10398
G1 X165.862 Y113.668 E.01889
G1 X166.066 Y113.819 E.00759
M204 S10000
G1 X166.35 Y114.601 F60000
G1 F9547.299
M204 S8000
G1 X166.438 Y114.534 E.00327
G1 X166.492 Y114.543 E.00164
G1 X166.492 Y111.808 E.08147
G1 X161.308 Y111.808 E.15439
G1 X161.308 Y114.811 E.08945
G1 X161.633 Y114.879 E.00988
G1 X161.78 Y114.663 E.00777
G1 X162.182 Y114.246 E.01727
G1 X162.646 Y113.922 E.01686
G3 X165.688 Y114.003 I1.451 J2.664 E.09494
G1 X166.144 Y114.359 E.01724
G1 X166.311 Y114.555 E.00767
; WIPE_START
G1 X166.144 Y114.359 E-.09791
G1 X165.688 Y114.003 E-.21994
G1 X165.192 Y113.748 E-.21184
G1 X164.682 Y113.598 E-.20207
G1 X164.608 Y113.588 E-.02824
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X161.367 Y115.224 Z1.6 F60000
G1 Z1.2
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.451712
G1 F8806.446
M204 S8000
G1 X161.32 Y115.448 E.0074
; LINE_WIDTH: 0.422527
G1 F9483.497
G1 X161.299 Y115.584 E.0041
; LINE_WIDTH: 0.377157
G1 F10770.802
G1 X161.275 Y115.733 E.00401
; LINE_WIDTH: 0.339457
G1 F12140.148
G1 X161.261 Y115.864 E.00308
; LINE_WIDTH: 0.309115
G1 F13523.956
G1 X161.245 Y116.007 E.00303
; LINE_WIDTH: 0.264919
G1 F15000
G1 X161.224 Y116.553 E.00958
G1 X161.235 Y116.85 E.0052
; LINE_WIDTH: 0.295315
G1 F14263.382
G1 X161.257 Y117.118 E.00537
; LINE_WIDTH: 0.336725
G1 F12253.034
G1 X161.276 Y117.259 E.00329
; LINE_WIDTH: 0.376099
G1 F10805.007
G1 X161.297 Y117.417 E.00421
; LINE_WIDTH: 0.412018
G1 F9753.529
G1 X161.33 Y117.596 E.0053
; LINE_WIDTH: 0.440393
G1 F9057.232
G1 X161.363 Y117.775 E.0057
; WIPE_START
G1 X161.33 Y117.596 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X163.429 Y120.14 Z1.6 F60000
G1 Z1.2
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.38032
G1 F10669.828
M204 S8000
G1 X163.758 Y120.155 E.00878
; LINE_WIDTH: 0.362445
G1 F11266.736
G2 X164.781 Y120.138 I.418 J-5.594 E.02585
; WIPE_START
G1 X164.087 Y120.17 E-.51557
G1 X163.758 Y120.155 E-.24443
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X163.429 Y120.14 Z1.6 F60000
G1 Z1.2
G1 E.8 F1800
; LINE_WIDTH: 0.419051
G1 F9571.155
M204 S8000
G3 X162.063 Y119.603 I.698 J-3.783 E.04387
G1 X162.063 Y120.127 E.01555
G3 X163.369 Y120.138 I.481 J19.581 E.03881
; WIPE_START
G1 X162.063 Y120.127 E-.49623
G1 X162.063 Y119.603 E-.19884
G1 X162.213 Y119.686 E-.06494
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X165.772 Y120.162 Z1.6 F60000
G1 Z1.2
G1 E.8 F1800
; LINE_WIDTH: 0.352243
G1 F11638.323
M204 S8000
G1 X165.772 Y119.772 E.00953
G1 X165.197 Y120.014 E.01524
; LINE_WIDTH: 0.36779
G1 F11081.355
G1 X165.019 Y120.074 E.00483
; LINE_WIDTH: 0.383703
G1 F10563.906
G1 X164.841 Y120.133 E.00506
G1 X165.366 Y120.162 E.01416
; LINE_WIDTH: 0.35132
G1 F11673.151
G1 X165.712 Y120.162 E.00843
M204 S10000
G1 X166.115 Y120.505 F60000
; LINE_WIDTH: 0.41999
G1 F9547.299
M204 S8000
G1 X166.115 Y119.15 E.04036
G3 X164.221 Y119.834 I-2.012 J-2.607 E.06095
G1 X163.587 Y119.796 E.0189
G3 X162.283 Y119.296 I.699 J-3.78 E.04185
G1 X161.828 Y118.941 E.01719
G1 X161.685 Y118.786 E.00626
G1 X161.685 Y120.505 E.05118
G1 X166.055 Y120.505 E.13014
M204 S10000
G1 X166.492 Y120.882 F60000
G1 F9547.299
M204 S8000
G1 X166.492 Y118.397 E.07402
G1 X166.408 Y118.353 E.0028
G1 X166.023 Y118.751 E.01649
G1 X165.557 Y119.077 E.01693
G1 X165.037 Y119.308 E.01695
G3 X163.616 Y119.42 I-.973 J-3.275 E.04276
G3 X162.515 Y118.999 I.735 J-3.578 E.03527
G1 X162.06 Y118.644 E.01719
G3 X161.643 Y118.122 I24.826 J-20.269 E.01991
G1 X161.308 Y118.183 E.01013
G1 X161.308 Y120.882 E.08037
G1 X166.432 Y120.882 E.15261
; CHANGE_LAYER
; Z_HEIGHT: 1.3
; LAYER_HEIGHT: 0.0999999
; WIPE_START
G1 F9547.299
G1 X164.432 Y120.882 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 10/37
; update layer progress
M73 L10
M991 S0 P9 ;notify layer change

; OBJECT_ID: 15
M204 S10000
G17
G3 Z1.6 I-.893 J.827 P1  F60000
G1 X168.512 Y125.287 Z1.6
G1 Z1.3
G1 E.8 F1800
; FEATURE: Support
; LINE_WIDTH: 0.42
; LAYER_HEIGHT: 0.275
G1 F7252.893
M204 S8000
G1 X168.512 Y123.229 E.08069
G1 X159.688 Y123.229 E.34594
G1 X159.688 Y125.475 E.08809
G1 X168.512 Y125.475 E.34594
G1 X168.512 Y126.961 E.05828
G1 X168.337 Y126.961 E.00685
G1 X168.021 Y127.277 E.01749
G1 X168.021 Y128.352 E.04216
G1 X159.688 Y128.352 E.32672
G1 X159.688 Y130.971 E.1027
G1 X168.021 Y130.971 E.32672
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

G1 X168.021 Y128.541 E.0953
; CHANGE_LAYER
; Z_HEIGHT: 1.4
; LAYER_HEIGHT: 0.1
; WIPE_START
G1 X168.021 Y130.541 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 11/37
; update layer progress
M73 L11
M991 S0 P10 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z1.7 I-.771 J.942 P1  F60000
G1 X188.525 Y147.313 Z1.7
G1 Z1.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
; LAYER_HEIGHT: 0.2
G1 F8843.478
M204 S8000
G1 X188.917 Y147.313 E.01261
G1 X188.917 Y181.697 E1.10567
G1 X182.473 Y181.697 E.20722
G1 X182.473 Y147.313 E1.10567
G1 X188.465 Y147.313 E.19268
; COOLING_NODE: 0
M204 S250
G1 X188.525 Y147.705 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X188.525 Y181.305 E1.00083
G1 X182.865 Y181.305 E.16859
G1 X182.865 Y147.705 E1.00083
G1 X188.465 Y147.705 E.1668
; COOLING_NODE: 0
; WIPE_START
M204 S8000
G1 X188.469 Y149.705 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X181.081 Y151.625 Z1.8 F60000
G1 X167.23 Y155.224 Z1.8
G1 Z1.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X166.431 Y155.224 E.0257
G1 X166.431 Y150.766 E.14336
G1 X175.969 Y150.766 E.30672
G1 X175.969 Y155.224 E.14336
G1 X167.29 Y155.224 E.27909
; COOLING_NODE: 0
M204 S10000
G1 X167.23 Y154.817 F60000
G1 F8843.478
M204 S8000
G1 X166.838 Y154.817 E.01261
G1 X166.838 Y151.173 E.11718
G1 X175.562 Y151.173 E.28054
G1 X175.562 Y154.817 E.11718
G1 X167.29 Y154.817 E.266
; COOLING_NODE: 1
M204 S250
G1 X167.23 Y154.425 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X167.23 Y151.565 E.08519
G1 X175.17 Y151.565 E.23651
G1 X175.17 Y154.425 E.08519
G1 X167.29 Y154.425 E.23472
; COOLING_NODE: 1
; WIPE_START
M204 S8000
G1 X167.248 Y152.425 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X166.194 Y144.866 Z1.8 F60000
G1 X166.059 Y143.9 Z1.8
G1 Z1.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X166.059 Y152.899 E.28938
G1 X161.341 Y152.899 E.15172
G1 X161.341 Y143.101 E.31508
G1 X166.059 Y143.101 E.15172
G1 X166.059 Y143.84 E.02377
; COOLING_NODE: 1
M204 S10000
G1 X165.652 Y143.9 F60000
G1 F8843.478
M204 S8000
G1 X165.652 Y152.492 E.27629
G1 X161.748 Y152.492 E.12554
G1 X161.748 Y143.508 E.2889
G1 X165.652 Y143.508 E.12554
G1 X165.652 Y143.84 E.01068
; COOLING_NODE: 2
M204 S250
G1 X165.26 Y143.9 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X165.26 Y152.1 E.24425
G1 X162.14 Y152.1 E.09293
G1 X162.14 Y143.9 E.24425
G1 X165.2 Y143.9 E.09115
; COOLING_NODE: 2
; WIPE_START
M204 S8000
G1 X165.215 Y145.9 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X161.834 Y142.694 Z1.8 F60000
G1 Z1.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X160.916 Y142.694 E.02951
G1 X160.916 Y132.926 E.31409
G1 X161.834 Y132.926 E.02951
G1 X161.834 Y142.634 E.31216
; COOLING_NODE: 2
; WIPE_START
G1 X160.916 Y142.694 E-.34943
G1 X160.916 Y141.613 E-.41057
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X168.548 Y141.661 Z1.8 F60000
G1 X176.291 Y141.71 Z1.8
G1 Z1.4
G1 E.8 F1800
G1 F8843.478
M204 S8000
G1 X176.291 Y137.541 E.13406
G1 X188.509 Y137.541 E.3929
G1 X188.509 Y142.509 E.15976
G1 X176.291 Y142.509 E.3929
G1 X176.291 Y141.77 E.02377
; COOLING_NODE: 2
M204 S10000
G1 X176.698 Y141.71 F60000
G1 F8843.478
M204 S8000
G1 X176.698 Y137.948 E.12097
G1 X188.102 Y137.948 E.36672
G1 X188.102 Y142.102 E.13358
G1 X176.698 Y142.102 E.36672
G1 X176.698 Y141.77 E.01068
; COOLING_NODE: 3
M204 S250
G1 X177.09 Y141.71 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X177.09 Y138.34 E.10038
G1 X187.71 Y138.34 E.31633
G1 X187.71 Y141.71 E.10038
G1 X177.15 Y141.71 E.31455
; COOLING_NODE: 3
; WIPE_START
M204 S8000
G1 X177.114 Y139.71 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X176 Y147.261 Z1.8 F60000
G1 X174.709 Y156.009 Z1.8
G1 Z1.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X181.191 Y156.009 E.20845
G1 X181.191 Y160.991 E.16022
G1 X174.709 Y160.991 E.20845
G1 X174.709 Y156.069 E.15829
; COOLING_NODE: 3
; WIPE_START
G1 X176.709 Y156.05 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X180.784 Y159.785 Z1.8 F60000
G1 Z1.4
G1 E.8 F1800
G1 F8843.478
M204 S8000
G1 X180.784 Y160.584 E.0257
G1 X175.116 Y160.584 E.18227
G1 X175.116 Y156.416 E.13404
G1 X180.784 Y156.416 E.18227
G1 X180.784 Y159.725 E.10641
; COOLING_NODE: 3
M204 S10000
G1 X180.377 Y159.785 F60000
G1 F8843.478
M204 S8000
G1 X180.377 Y160.177 E.01261
G1 X175.523 Y160.177 E.15609
G1 X175.523 Y156.823 E.10786
G1 X180.377 Y156.823 E.15609
G1 X180.377 Y159.725 E.09332
; COOLING_NODE: 4
M204 S250
G1 X179.985 Y159.785 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X175.915 Y159.785 E.12123
G1 X175.915 Y157.215 E.07655
G1 X179.985 Y157.215 E.12123
G1 X179.985 Y159.725 E.07476
; COOLING_NODE: 4
; WIPE_START
M204 S8000
G1 X177.985 Y159.754 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X179.03 Y167.315 Z1.8 F60000
G1 X183.624 Y200.558 Z1.8
G1 Z1.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X183.672 Y200.512 E.00214
G3 X185.029 Y199.946 I1.625 J1.986 E.04796
G1 X185.285 Y199.932 E.00825
G3 X183.482 Y200.684 I.012 J2.566 E.45409
G1 X183.579 Y200.598 E.00416
; COOLING_NODE: 4
M204 S10000
G1 X183.869 Y200.891 F60000
G1 F8843.478
M204 S8000
G1 X183.931 Y200.828 E.00284
G3 X185.072 Y200.352 I1.367 J1.671 E.04034
G1 X185.288 Y200.34 E.00695
G3 X183.623 Y201.136 I.01 J2.159 E.37493
G1 X183.827 Y200.933 E.00922
; COOLING_NODE: 4
M204 S10000
G1 X184.156 Y201.177 F60000
G1 F8843.478
M204 S8000
G1 X184.19 Y201.143 E.00154
G3 X185.116 Y200.757 I1.109 J1.356 E.03272
G1 X185.291 Y200.747 E.00565
G3 X183.939 Y201.394 I.008 J1.752 E.30416
G1 X184.114 Y201.22 E.00793
; COOLING_NODE: 5
M204 S250
G1 X184.433 Y201.453 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X184.439 Y201.447 E.00026
G3 X185.157 Y201.147 I.86 J1.053 E.02351
G1 X185.294 Y201.14 E.00407
G3 X184.244 Y201.643 I.006 J1.359 E.2186
G1 X184.391 Y201.496 E.00619
; COOLING_NODE: 5
; WIPE_START
M204 S8000
G1 X184.439 Y201.447 E-.02612
G1 X184.661 Y201.299 E-.10117
G1 X184.901 Y201.2 E-.09893
G1 X185.157 Y201.147 E-.09931
G1 X185.294 Y201.14 E-.05193
G1 X185.559 Y201.165 E-.10134
G1 X185.81 Y201.239 E-.09961
G1 X186.055 Y201.369 E-.10527
G1 X186.211 Y201.496 E-.07631
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X186.382 Y193.866 Z1.8 F60000
G1 X187.71 Y134.916 Z1.8
G1 Z1.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X188.484 Y134.916 E.02488
G1 X188.484 Y137.134 E.07131
G1 X175.884 Y137.134 E.40517
G1 X175.884 Y142.916 E.18594
G1 X188.484 Y142.916 E.40517
G1 X188.484 Y146.499 E.1152
G1 X181.659 Y146.499 E.21947
G1 X181.659 Y182.511 E1.15803
G1 X188.484 Y182.511 E.21947
G1 X188.484 Y208.584 E.8384
G1 X181.641 Y208.584 E.22003
G1 X181.641 Y192.784 E.50807
G1 X176.911 Y192.784 E.1521
G1 X176.911 Y186.889 E.18956
G1 X170.239 Y186.889 E.21456
G1 X170.239 Y192.784 E.18956
G1 X166.466 Y192.784 E.12131
G1 X166.466 Y177.459 E.4928
G1 X160.916 Y177.459 E.17847
M73 P64 R7
G1 X160.916 Y168.566 E.28595
G1 X170.731 Y168.566 E.31561
G1 X170.731 Y159.234 E.3001
G1 X160.916 Y159.234 E.31561
G1 X160.916 Y153.306 E.19061
G1 X166.024 Y153.306 E.16424
G1 X166.024 Y155.631 E.07476
G1 X176.376 Y155.631 E.3329
G1 X176.376 Y150.359 E.16954
G1 X166.466 Y150.359 E.31867
G1 X166.466 Y142.806 E.24286
G1 X167.366 Y142.806 E.02894
G1 X167.366 Y132.926 E.3177
G1 X169.976 Y132.926 E.08393
G1 X169.976 Y128.916 E.12895
G1 X175.884 Y128.916 E.18997
G1 X175.884 Y134.916 E.19294
G1 X187.65 Y134.916 E.37836
; COOLING_NODE: 5
; WIPE_START
G1 X188.484 Y134.916 E-.31685
G1 X188.484 Y136.082 E-.44315
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X187.71 Y129.541 Z1.8 F60000
G1 Z1.4
G1 E.8 F1800
G1 F8843.478
M204 S8000
G1 X188.509 Y129.541 E.0257
G1 X188.509 Y134.509 E.15976
G1 X176.291 Y134.509 E.3929
G1 X176.291 Y129.541 E.15976
G1 X187.65 Y129.541 E.36527
; COOLING_NODE: 5
M204 S10000
G1 X187.71 Y129.948 F60000
G1 F8843.478
M204 S8000
G1 X188.102 Y129.948 E.01261
G1 X188.102 Y134.102 E.13358
G1 X176.698 Y134.102 E.36672
G1 X176.698 Y129.948 E.13358
G1 X187.65 Y129.948 E.35218
; COOLING_NODE: 6
M204 S250
G1 X187.71 Y130.34 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X187.71 Y133.71 E.10038
G1 X177.09 Y133.71 E.31633
G1 X177.09 Y130.34 E.10038
G1 X187.65 Y130.34 E.31455
; COOLING_NODE: 6
; WIPE_START
M204 S8000
G1 X187.686 Y132.34 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X184.295 Y139.178 Z1.8 F60000
G1 X170.324 Y167.36 Z1.8
G1 Z1.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X170.324 Y168.159 E.0257
G1 X161.065 Y168.159 E.29774
G1 X161.065 Y159.641 E.27392
G1 X170.324 Y159.641 E.29774
G1 X170.324 Y167.3 E.24629
; COOLING_NODE: 6
M204 S10000
G1 X169.917 Y167.36 F60000
G1 F8843.478
M204 S8000
G1 X169.917 Y167.752 E.01261
G1 X161.472 Y167.752 E.27156
G1 X161.472 Y160.048 E.24774
G1 X169.917 Y160.048 E.27156
G1 X169.917 Y167.3 E.2332
; COOLING_NODE: 7
M204 S250
G1 X169.525 Y167.36 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X161.864 Y167.36 E.22819
G1 X161.864 Y160.44 E.20612
G1 X169.525 Y160.44 E.22819
G1 X169.525 Y167.3 E.20434
; COOLING_NODE: 7
; WIPE_START
M204 S8000
G1 X167.525 Y167.316 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X166.87 Y174.92 Z1.8 F60000
G1 X166.059 Y184.325 Z1.8
G1 Z1.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X166.059 Y185.124 E.0257
G1 X161.341 Y185.124 E.15172
G1 X161.341 Y177.866 E.2334
G1 X166.059 Y177.866 E.15172
G1 X166.059 Y184.265 E.20577
; COOLING_NODE: 7
M204 S10000
G1 X165.652 Y184.325 F60000
G1 F8843.478
M204 S8000
G1 X165.652 Y184.717 E.01261
G1 X161.748 Y184.717 E.12554
G1 X161.748 Y178.273 E.20722
G1 X165.652 Y178.273 E.12554
G1 X165.652 Y184.265 E.19268
; COOLING_NODE: 8
M204 S250
G1 X165.26 Y184.325 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X162.14 Y184.325 E.09293
G1 X162.14 Y178.665 E.16859
G1 X165.26 Y178.665 E.09293
G1 X165.26 Y184.265 E.1668
; COOLING_NODE: 8
; WIPE_START
M204 S8000
G1 X163.26 Y184.303 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X167.533 Y177.979 Z1.8 F60000
G1 X188.525 Y146.906 Z1.8
G1 Z1.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X182.066 Y146.906 E.2077
G1 X182.066 Y182.104 E1.13185
G1 X188.891 Y182.104 E.21947
G1 X188.891 Y208.991 E.86458
G1 X181.234 Y208.991 E.24621
G1 X181.234 Y193.191 E.50807
G1 X176.504 Y193.191 E.1521
G1 X176.504 Y187.296 E.18956
G1 X170.646 Y187.296 E.18838
G1 X170.646 Y193.191 E.18956
G1 X166.059 Y193.191 E.14749
G1 X166.059 Y185.866 E.23555
G1 X161.341 Y185.866 E.15172
G1 X161.341 Y193.191 E.23555
G1 X160.509 Y193.191 E.02675
G1 X160.509 Y132.519 E1.95098
G1 X162.241 Y132.519 E.05569
G1 X162.241 Y142.399 E.3177
G1 X166.959 Y142.399 E.15172
G1 X166.959 Y132.519 E.3177
G1 X169.569 Y132.519 E.08393
G1 X169.569 Y128.509 E.12895
G1 X188.891 Y128.509 E.62132
G1 X188.891 Y146.906 E.59157
G1 X188.585 Y146.906 E.00984
; COOLING_NODE: 8
; WIPE_START
G1 X186.585 Y146.906 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X179.164 Y145.121 Z1.8 F60000
G1 X166.16 Y141.992 Z1.8
G1 Z1.4
G1 E.8 F1800
G1 F8843.478
M204 S8000
G1 X162.648 Y141.992 E.11294
G1 X162.648 Y133.008 E.2889
G1 X166.552 Y133.008 E.12554
G1 X166.552 Y141.992 E.2889
G1 X166.22 Y141.992 E.01068
; COOLING_NODE: 9
M204 S250
G1 X166.16 Y141.6 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X163.04 Y141.6 E.09293
G1 X163.04 Y133.4 E.24425
G1 X166.16 Y133.4 E.09293
G1 X166.16 Y141.54 E.24246
; COOLING_NODE: 9
; WIPE_START
M204 S8000
G1 X164.16 Y141.578 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X163.798 Y149.202 Z1.8 F60000
G1 X161.748 Y192.325 Z1.8
G1 Z1.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X161.748 Y186.273 E.19461
G1 X165.652 Y186.273 E.12554
G1 X165.652 Y192.717 E.20722
G1 X161.748 Y192.717 E.12554
G1 X161.748 Y192.385 E.01068
; COOLING_NODE: 10
M204 S250
G1 X162.14 Y192.325 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X162.14 Y186.665 E.16859
G1 X165.26 Y186.665 E.09293
G1 X165.26 Y192.325 E.16859
G1 X162.2 Y192.325 E.09115
; COOLING_NODE: 10
; WIPE_START
M204 S8000
G1 X162.179 Y190.325 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X169.672 Y188.873 Z1.8 F60000
G1 X175.705 Y187.703 Z1.8
G1 Z1.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X176.097 Y187.703 E.01261
G1 X176.097 Y192.697 E.16059
G1 X171.053 Y192.697 E.1622
G1 X171.053 Y187.703 E.16059
G1 X175.645 Y187.703 E.14766
; COOLING_NODE: 11
M204 S250
G1 X175.705 Y188.095 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X175.705 Y192.305 E.1254
G1 X171.445 Y192.305 E.12689
G1 X171.445 Y188.095 E.1254
G1 X175.645 Y188.095 E.1251
; COOLING_NODE: 11
; WIPE_START
M204 S8000
G1 X175.673 Y190.095 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X174.822 Y182.51 Z1.8 F60000
G1 X169.162 Y132.112 Z1.8
G1 Z1.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X169.162 Y128.102 E.12895
G1 X189.298 Y128.102 E.6475
G1 X189.298 Y146.502 E.59168
G1 X189.898 Y146.502 E.01929
G1 X189.898 Y182.498 E1.1575
G1 X189.298 Y182.498 E.01929
G1 X189.298 Y209.398 E.86501
G1 X180.827 Y209.398 E.27239
G1 X180.827 Y193.598 E.50807
G1 X160.102 Y193.598 E.66644
G1 X160.102 Y132.112 E1.97716
G1 X169.102 Y132.112 E.28941
; COOLING_NODE: 12
M204 S250
G1 X168.77 Y131.72 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1914
M204 S5000
G1 X168.77 Y127.71 E.11944
G1 X189.69 Y127.71 E.62314
G1 X189.69 Y146.11 E.54807
G1 X190.29 Y146.11 E.01787
G1 X190.29 Y182.89 E1.09555
G1 X189.69 Y182.89 E.01787
G1 X189.69 Y209.79 E.80126
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

G1 X180.435 Y209.79 E.27568
M73 P65 R7
G1 X180.435 Y193.99 E.47063
G1 X159.71 Y193.99 E.61733
G1 X159.71 Y131.72 E1.85481
G1 X168.71 Y131.72 E.26808
; WIPE_START
G1 F9547.055
M204 S8000
G1 X168.74 Y129.72 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X166.755 Y132.56 Z1.8 F60000
G1 Z1.4
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.53172
G1 F7364.976
M204 S8000
G1 X162.444 Y132.56 E.16645
; WIPE_START
G1 X164.444 Y132.56 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X161.375 Y133.13 Z1.8 F60000
G1 Z1.4
G1 E.8 F1800
; LINE_WIDTH: 0.55344
G1 F7051.634
M204 S8000
G1 X161.375 Y142.49 E.37749
M204 S10000
G1 X160.925 Y142.897 F60000
; LINE_WIDTH: 0.46758
G1 F8477.369
M204 S8000
G1 X160.925 Y153.103 E.34233
; WIPE_START
G1 X160.925 Y151.103 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X161.933 Y143.537 Z1.8 F60000
G1 X162.037 Y142.75 Z1.8
G1 Z1.4
G1 E.8 F1800
; LINE_WIDTH: 0.33758
G1 F12217.47
M204 S8000
G1 X166.263 Y142.75 E.09834
; WIPE_START
G1 X164.263 Y142.75 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X167.449 Y135.814 Z1.8 F60000
G1 X170.14 Y129.957 Z1.8
G1 Z1.4
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42088
G1 F9524.817
M204 S8000
G1 X176.983 Y136.801 E.28896
G1 X176.449 Y136.801 E.01596
G1 X170.309 Y130.661 E.25922
G1 X170.309 Y131.196 E.01596
G1 X175.914 Y136.801 E.23665
G1 X175.551 Y136.801 E.01086
G1 X175.551 Y136.972 E.0051
G1 X170.309 Y131.73 E.2213
G1 X170.309 Y132.265 E.01596
G1 X175.551 Y137.506 E.2213
G1 X175.551 Y138.041 E.01596
G1 X170.309 Y132.799 E.2213
G1 X170.309 Y133.259 E.01374
G1 X170.235 Y133.259 E.00222
G1 X175.551 Y138.575 E.22445
G1 X175.551 Y139.11 E.01596
G1 X169.7 Y133.259 E.24702
G1 X169.166 Y133.259 E.01596
G1 X175.551 Y139.644 E.26958
G1 X175.551 Y140.179 E.01596
G1 X168.631 Y133.259 E.29215
G1 X168.097 Y133.259 E.01596
G1 X175.551 Y140.713 E.31472
G1 X175.551 Y141.248 E.01596
G1 X167.699 Y133.396 E.3315
G1 X167.699 Y133.931 E.01596
G1 X175.551 Y141.782 E.3315
G1 X175.551 Y142.317 E.01596
G1 X167.699 Y134.465 E.3315
G1 X167.699 Y135 E.01596
G1 X175.551 Y142.851 E.3315
G1 X175.551 Y143.249 E.01189
G1 X175.949 Y143.249 E.01189
G1 X181.326 Y148.626 E.22703
G1 X181.326 Y148.092 E.01596
G1 X176.483 Y143.249 E.20446
G1 X177.018 Y143.249 E.01596
G1 X181.326 Y147.557 E.18189
G1 X181.326 Y147.023 E.01596
G1 X177.552 Y143.249 E.15932
G1 X178.087 Y143.249 E.01596
G1 X181.326 Y146.488 E.13675
G1 X181.326 Y146.166 E.00963
G1 X181.538 Y146.166 E.00633
G1 X178.621 Y143.249 E.12313
G1 X179.156 Y143.249 E.01596
G1 X182.072 Y146.166 E.12313
G1 X182.607 Y146.166 E.01596
G1 X179.69 Y143.249 E.12313
G1 X180.225 Y143.249 E.01596
G1 X183.141 Y146.166 E.12313
G1 X183.676 Y146.166 E.01596
G1 X180.759 Y143.249 E.12313
G1 X181.294 Y143.249 E.01596
G1 X184.21 Y146.166 E.12313
G1 X184.745 Y146.166 E.01596
G1 X181.828 Y143.249 E.12313
G1 X182.363 Y143.249 E.01596
G1 X185.279 Y146.166 E.12313
G1 X185.814 Y146.166 E.01596
G1 X182.897 Y143.249 E.12313
G1 X183.432 Y143.249 E.01596
G1 X186.348 Y146.166 E.12313
G1 X186.883 Y146.166 E.01596
G1 X183.966 Y143.249 E.12313
G1 X184.501 Y143.249 E.01596
G1 X187.417 Y146.166 E.12313
G1 X187.952 Y146.166 E.01596
G1 X185.036 Y143.249 E.12313
G1 X185.57 Y143.249 E.01596
G1 X188.151 Y145.83 E.10896
G1 X188.151 Y145.295 E.01596
G1 X186.105 Y143.249 E.08639
G1 X186.639 Y143.249 E.01596
G1 X188.151 Y144.761 E.06382
G1 X188.151 Y144.226 E.01596
G1 X187.174 Y143.249 E.04125
G1 X187.708 Y143.249 E.01596
G1 X188.32 Y143.862 E.02585
; WIPE_START
G1 X187.708 Y143.249 E-.32901
G1 X187.174 Y143.249 E-.20312
G1 X187.598 Y143.673 E-.22788
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X189.095 Y147.093 Z1.8 F60000
G1 Z1.4
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.118631
G1 F15000
M204 S8000
G1 X189.12 Y147.083 E.00016
; LINE_WIDTH: 0.165653
G1 X189.146 Y147.074 E.00027
; LINE_WIDTH: 0.212674
G1 X189.172 Y147.065 E.00037
; LINE_WIDTH: 0.259695
G1 X189.198 Y147.055 E.00047
; LINE_WIDTH: 0.306717
G1 F13646.879
G1 X189.224 Y147.046 E.00057
; LINE_WIDTH: 0.353738
G1 F11582.34
G1 X189.25 Y147.037 E.00068
; LINE_WIDTH: 0.40076
G1 F10060.376
G1 X189.276 Y147.028 E.00078
; LINE_WIDTH: 0.447781
G1 F8891.942
G1 X189.302 Y147.018 E.00088
; LINE_WIDTH: 0.494803
G1 F7966.675
G1 X189.327 Y147.009 E.00098
; LINE_WIDTH: 0.541824
G1 F7215.819
G1 X189.353 Y147 E.00108
; LINE_WIDTH: 0.588846
G1 F6594.309
G1 X189.379 Y146.99 E.00119
; LINE_WIDTH: 0.616778
G1 F6273.336
G1 X189.398 Y147.002 E.001
G1 X189.408 Y147.109 E.00487
G1 X189.408 Y181.901 E1.57711
G1 X189.399 Y181.999 E.00448
G1 X189.371 Y182.018 E.00153
; LINE_WIDTH: 0.573214
G1 F6788.692
G1 X189.346 Y182.009 E.00112
; LINE_WIDTH: 0.527681
G1 F7426.342
G1 X189.321 Y182 E.00102
; LINE_WIDTH: 0.482149
G1 F8196.196
G1 X189.296 Y181.99 E.00093
; LINE_WIDTH: 0.436616
G1 F9144.123
G1 X189.27 Y181.981 E.00083
; LINE_WIDTH: 0.391083
G1 F10339.991
G1 X189.245 Y181.972 E.00074
; LINE_WIDTH: 0.34555
G1 F11895.715
G1 X189.22 Y181.963 E.00064
; LINE_WIDTH: 0.300018
G1 F14002.483
G1 X189.195 Y181.954 E.00054
; LINE_WIDTH: 0.254485
G1 F15000
G1 X189.17 Y181.945 E.00045
; LINE_WIDTH: 0.208952
G1 X189.145 Y181.936 E.00035
; LINE_WIDTH: 0.163419
G1 X189.12 Y181.926 E.00025
; LINE_WIDTH: 0.117887
G1 X189.095 Y181.917 E.00016
; WIPE_START
G1 X189.12 Y181.926 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X187.509 Y182.675 Z1.8 F60000
G1 Z1.4
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42352
G1 F9458.749
M204 S8000
G1 X188.151 Y183.316 E.02726
G1 X188.151 Y183.854 E.01618
G1 X187.141 Y182.844 E.04294
G1 X186.603 Y182.844 E.01618
G1 X188.151 Y184.392 E.06582
G1 X188.151 Y184.931 E.01618
G1 X186.064 Y182.844 E.08871
G1 X185.526 Y182.844 E.01618
G1 X188.151 Y185.469 E.11159
G1 X188.151 Y186.007 E.01618
G1 X184.988 Y182.844 E.13448
G1 X184.45 Y182.844 E.01618
G1 X188.151 Y186.545 E.15736
G1 X188.151 Y187.084 E.01618
G1 X183.911 Y182.844 E.18025
G1 X183.373 Y182.844 E.01618
G1 X188.151 Y187.622 E.20313
G1 X188.151 Y188.16 E.01618
G1 X182.835 Y182.844 E.22602
G1 X182.297 Y182.844 E.01618
G1 X188.151 Y188.698 E.2489
G1 X188.151 Y189.237 E.01618
G1 X181.758 Y182.844 E.27179
G1 X181.326 Y182.844 E.01301
G1 X181.326 Y182.412 E.01301
G1 X167.813 Y168.899 E.57451
G1 X168.352 Y168.899 E.01618
G1 X181.326 Y181.873 E.55163
G1 X181.326 Y181.335 E.01618
G1 X168.89 Y168.899 E.52874
G1 X169.428 Y168.899 E.01618
G1 X181.326 Y180.797 E.50586
G1 X181.326 Y180.259 E.01618
G1 X169.966 Y168.899 E.48297
G1 X170.505 Y168.899 E.01618
G1 X181.326 Y179.72 E.46009
G1 X181.326 Y179.182 E.01618
G1 X171.043 Y168.899 E.4372
G1 X171.064 Y168.899 E.00065
G1 X171.064 Y168.383 E.01554
G1 X181.326 Y178.644 E.43629
G1 X181.326 Y178.106 E.01618
G1 X171.064 Y167.844 E.43629
G1 X171.064 Y167.306 E.01618
G1 X181.326 Y177.567 E.43629
G1 X181.326 Y177.029 E.01618
G1 X171.064 Y166.768 E.43629
G1 X171.064 Y166.23 E.01618
G1 X181.326 Y176.491 E.43629
G1 X181.326 Y175.953 E.01618
G1 X171.064 Y165.691 E.43629
G1 X171.064 Y165.153 E.01618
G1 X181.326 Y175.414 E.43629
G1 X181.326 Y174.876 E.01618
G1 X171.064 Y164.615 E.43629
G1 X171.064 Y164.077 E.01618
G1 X181.326 Y174.338 E.43629
G1 X181.326 Y173.8 E.01618
M73 P66 R7
G1 X171.064 Y163.538 E.43629
G1 X171.064 Y163 E.01618
G1 X181.326 Y173.261 E.43629
G1 X181.326 Y172.723 E.01618
G1 X171.064 Y162.462 E.43629
G1 X171.064 Y161.924 E.01618
G1 X181.326 Y172.185 E.43629
G1 X181.326 Y171.647 E.01618
G1 X171.064 Y161.385 E.43629
G1 X171.064 Y160.847 E.01618
G1 X181.326 Y171.108 E.43629
G1 X181.326 Y170.57 E.01618
G1 X171.064 Y160.309 E.43629
G1 X171.064 Y159.771 E.01618
G1 X181.326 Y170.032 E.43629
G1 X181.326 Y169.494 E.01618
G1 X167.796 Y155.964 E.57524
G1 X168.335 Y155.964 E.01618
G1 X181.495 Y169.125 E.55957
; WIPE_START
G1 X180.081 Y167.711 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X176.651 Y160.893 Z1.8 F60000
G1 X174.086 Y155.795 Z1.8
G1 Z1.4
G1 E.8 F1800
G1 F9458.749
M204 S8000
G1 X174.376 Y156.085 E.01233
G1 X174.376 Y156.623 E.01618
G1 X173.717 Y155.964 E.028
G1 X173.179 Y155.964 E.01618
G1 X174.376 Y157.161 E.05089
G1 X174.376 Y157.699 E.01618
G1 X172.641 Y155.964 E.07377
G1 X172.102 Y155.964 E.01618
G1 X174.376 Y158.238 E.09666
G1 X174.376 Y158.776 E.01618
G1 X171.564 Y155.964 E.11954
G1 X171.026 Y155.964 E.01618
G1 X174.376 Y159.314 E.14243
G1 X174.376 Y159.852 E.01618
G1 X170.488 Y155.964 E.16531
G1 X169.949 Y155.964 E.01618
G1 X174.376 Y160.391 E.1882
G1 X174.376 Y160.929 E.01618
G1 X169.411 Y155.964 E.21108
G1 X168.873 Y155.964 E.01618
G1 X181.326 Y168.417 E.52947
G1 X181.326 Y167.879 E.01618
G1 X174.771 Y161.324 E.27869
G1 X175.309 Y161.324 E.01618
G1 X181.326 Y167.341 E.2558
G1 X181.326 Y166.802 E.01618
G1 X175.848 Y161.324 E.23292
G1 X176.386 Y161.324 E.01618
G1 X181.326 Y166.264 E.21003
G1 X181.326 Y165.726 E.01618
G1 X176.924 Y161.324 E.18715
G1 X177.462 Y161.324 E.01618
G1 X181.326 Y165.188 E.16426
G1 X181.326 Y164.649 E.01618
G1 X178.001 Y161.324 E.14138
G1 X178.539 Y161.324 E.01618
G1 X181.326 Y164.111 E.11849
G1 X181.326 Y163.573 E.01618
G1 X179.077 Y161.324 E.0956
G1 X179.615 Y161.324 E.01618
G1 X181.326 Y163.035 E.07272
G1 X181.326 Y162.496 E.01618
G1 X180.154 Y161.324 E.04983
G1 X180.692 Y161.324 E.01618
G1 X181.495 Y162.128 E.03416
M204 S10000
G1 X181.425 Y161.195 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.10344
G1 F15000
M204 S8000
G1 X181.425 Y155.805 E.02576
M204 S10000
G1 X181.495 Y155.21 F60000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42088
G1 F9524.817
M204 S8000
G1 X176.709 Y150.424 E.20208
G1 X176.709 Y150.959 E.01596
G1 X181.223 Y155.472 E.19057
G1 X181.04 Y155.472 E.00546
G1 X181.04 Y155.676 E.00607
G1 X180.892 Y155.676 E.00443
G1 X176.709 Y151.493 E.17659
G1 X176.709 Y152.028 E.01596
G1 X180.357 Y155.676 E.15403
G1 X179.823 Y155.676 E.01596
G1 X176.709 Y152.562 E.13146
G1 X176.709 Y153.097 E.01596
G1 X179.288 Y155.676 E.10889
G1 X178.754 Y155.676 E.01596
G1 X176.709 Y153.631 E.08632
G1 X176.709 Y154.166 E.01596
G1 X178.219 Y155.676 E.06375
G1 X177.685 Y155.676 E.01596
G1 X176.709 Y154.7 E.04118
G1 X176.709 Y155.235 E.01596
G1 X177.32 Y155.845 E.02578
; WIPE_START
G1 X176.709 Y155.235 E-.32809
G1 X176.709 Y154.7 E-.20312
G1 X177.135 Y155.126 E-.2288
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X181.495 Y149.33 Z1.8 F60000
G1 Z1.4
G1 E.8 F1800
G1 F9524.817
M204 S8000
G1 X167.699 Y135.534 E.58251
G1 X167.699 Y136.069 E.01596
G1 X181.326 Y149.695 E.57534
G1 X181.326 Y150.23 E.01596
G1 X167.699 Y136.604 E.57534
G1 X167.699 Y137.138 E.01596
G1 X181.326 Y150.764 E.57534
G1 X181.326 Y151.299 E.01596
G1 X167.699 Y137.673 E.57534
G1 X167.699 Y138.207 E.01596
G1 X181.326 Y151.833 E.57534
G1 X181.326 Y152.368 E.01596
G1 X167.699 Y138.742 E.57534
G1 X167.699 Y139.276 E.01596
G1 X181.326 Y152.902 E.57534
G1 X181.326 Y153.437 E.01596
G1 X167.699 Y139.811 E.57534
G1 X167.699 Y140.345 E.01596
G1 X181.326 Y153.971 E.57534
G1 X181.326 Y154.506 E.01596
G1 X167.699 Y140.88 E.57534
G1 X167.699 Y141.414 E.01596
G1 X176.311 Y150.026 E.3636
G1 X175.776 Y150.026 E.01596
G1 X167.699 Y141.949 E.34103
G1 X167.699 Y142.483 E.01596
G1 X175.242 Y150.026 E.31846
G1 X174.707 Y150.026 E.01596
G1 X167.699 Y143.018 E.29589
G1 X167.699 Y143.139 E.00363
G1 X167.286 Y143.139 E.01233
G1 X174.173 Y150.026 E.29076
G1 X173.638 Y150.026 E.01596
G1 X166.799 Y143.187 E.28876
G1 X166.799 Y143.721 E.01596
G1 X173.104 Y150.026 E.26619
G1 X172.569 Y150.026 E.01596
G1 X166.799 Y144.256 E.24362
G1 X166.799 Y144.79 E.01596
G1 X172.035 Y150.026 E.22105
G1 X171.5 Y150.026 E.01596
G1 X166.799 Y145.325 E.19848
G1 X166.799 Y145.859 E.01596
G1 X170.966 Y150.026 E.17591
G1 X170.431 Y150.026 E.01596
G1 X166.799 Y146.394 E.15335
G1 X166.799 Y146.928 E.01596
G1 X169.897 Y150.026 E.13078
G1 X169.362 Y150.026 E.01596
G1 X166.799 Y147.463 E.10821
G1 X166.799 Y147.997 E.01596
G1 X168.828 Y150.026 E.08564
G1 X168.293 Y150.026 E.01596
G1 X166.799 Y148.532 E.06307
G1 X166.799 Y149.066 E.01596
G1 X167.759 Y150.026 E.0405
G1 X167.224 Y150.026 E.01596
G1 X166.63 Y149.431 E.0251
; WIPE_START
G1 X167.224 Y150.026 E-.31942
G1 X167.759 Y150.026 E-.20311
G1 X167.317 Y149.584 E-.23746
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X165.86 Y154.028 Z1.8 F60000
G1 Z1.4
G1 E.8 F1800
; LINE_WIDTH: 0.42352
G1 F9458.749
M204 S8000
G1 X165.471 Y153.639 E.01654
G1 X164.933 Y153.639 E.01618
G1 X165.691 Y154.397 E.03221
G1 X165.691 Y154.935 E.01618
G1 X164.395 Y153.639 E.0551
G1 X163.857 Y153.639 E.01618
G1 X165.691 Y155.473 E.07798
G1 X165.691 Y155.964 E.01476
G1 X166.182 Y155.964 E.01476
G1 X169.118 Y158.901 E.12484
G1 X169.656 Y158.901 E.01618
G1 X166.72 Y155.964 E.12484
G1 X167.258 Y155.964 E.01618
G1 X170.364 Y159.07 E.13206
; WIPE_START
G1 X168.95 Y157.656 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X168.749 Y159.07 Z1.8 F60000
G1 Z1.4
G1 E.8 F1800
G1 F9458.749
M204 S8000
G1 X163.318 Y153.639 E.23091
G1 X162.78 Y153.639 E.01618
G1 X168.041 Y158.901 E.2237
G1 X167.503 Y158.901 E.01618
G1 X162.242 Y153.639 E.2237
G1 X161.704 Y153.639 E.01618
G1 X166.965 Y158.901 E.2237
G1 X166.427 Y158.901 E.01618
G1 X161.249 Y153.723 E.22013
G1 X161.249 Y154.262 E.01618
G1 X165.888 Y158.901 E.19724
G1 X165.35 Y158.901 E.01618
G1 X161.249 Y154.8 E.17435
G1 X161.249 Y155.338 E.01618
G1 X164.812 Y158.901 E.15147
G1 X164.274 Y158.901 E.01618
G1 X161.249 Y155.876 E.12858
G1 X161.249 Y156.415 E.01618
G1 X163.735 Y158.901 E.1057
G1 X163.197 Y158.901 E.01618
G1 X161.249 Y156.953 E.08281
G1 X161.249 Y157.491 E.01618
G1 X162.659 Y158.901 E.05993
G1 X162.121 Y158.901 E.01618
G1 X161.249 Y158.029 E.03704
G1 X161.249 Y158.568 E.01618
G1 X161.752 Y159.07 E.02137
; WIPE_START
G1 X161.249 Y158.568 E-.27014
G1 X161.249 Y158.029 E-.20454
G1 X161.78 Y158.56 E-.28533
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X160.787 Y159.437 Z1.8 F60000
G1 Z1.4
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.19158
G1 F15000
M204 S8000
G1 X160.787 Y168.363 E.10481
; WIPE_START
G1 X160.787 Y166.363 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X166.584 Y171.328 Z1.8 F60000
G1 X188.32 Y189.945 Z1.8
G1 Z1.4
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42352
G1 F9458.749
M204 S8000
G1 X167.275 Y168.899 E.8948
G1 X166.737 Y168.899 E.01618
G1 X188.151 Y190.313 E.91047
G1 X188.151 Y190.851 E.01618
G1 X166.199 Y168.899 E.93335
G1 X165.66 Y168.899 E.01618
G1 X188.151 Y191.39 E.95624
G1 X188.151 Y191.928 E.01618
G1 X165.122 Y168.899 E.97913
G1 X164.584 Y168.899 E.01618
G1 X188.151 Y192.466 E1.00201
G1 X188.151 Y193.004 E.01618
G1 X164.046 Y168.899 E1.0249
G1 X163.507 Y168.899 E.01618
G1 X188.151 Y193.543 E1.04778
G1 X188.151 Y194.081 E.01618
G1 X162.969 Y168.899 E1.07067
G1 X162.431 Y168.899 E.01618
G1 X188.151 Y194.619 E1.09355
G1 X188.151 Y195.157 E.01618
G1 X161.893 Y168.899 E1.11644
G1 X161.354 Y168.899 E.01618
G1 X188.151 Y195.696 E1.13932
G1 X188.151 Y196.234 E.01618
G1 X161.249 Y169.333 E1.14379
G1 X161.249 Y169.871 E.01618
G1 X188.151 Y196.772 E1.14379
G1 X188.151 Y197.31 E.01618
G1 X161.249 Y170.409 E1.14379
G1 X161.249 Y170.947 E.01618
G1 X176.858 Y186.556 E.66363
G1 X176.319 Y186.556 E.01618
G1 X161.249 Y171.486 E.64074
G1 X161.249 Y172.024 E.01618
M73 P67 R7
G1 X166.351 Y177.126 E.21692
G1 X165.813 Y177.126 E.01618
G1 X161.249 Y172.562 E.19403
G1 X161.249 Y173.1 E.01618
G1 X165.275 Y177.126 E.17115
G1 X164.736 Y177.126 E.01618
G1 X161.249 Y173.639 E.14826
G1 X161.249 Y174.177 E.01618
G1 X164.198 Y177.126 E.12537
G1 X163.66 Y177.126 E.01618
G1 X161.249 Y174.715 E.10249
G1 X161.249 Y175.253 E.01618
G1 X163.122 Y177.126 E.0796
G1 X162.583 Y177.126 E.01618
G1 X161.249 Y175.792 E.05672
G1 X161.249 Y176.33 E.01618
G1 X162.045 Y177.126 E.03383
G1 X161.507 Y177.126 E.01618
G1 X161.08 Y176.698 E.01816
M204 S10000
G1 X160.925 Y177.662 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.467762
G1 F8473.752
M204 S8000
G1 X160.925 Y185.328 E.25724
G1 X160.941 Y185.411 E.00286
; LINE_WIDTH: 0.51702
G1 F7593.335
G1 X160.958 Y185.495 E.00319
; WIPE_START
G1 X160.941 Y185.411 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X166.263 Y185.495 Z1.8 F60000
G1 Z1.4
G1 E.8 F1800
; LINE_WIDTH: 0.37757
G1 F10757.508
M204 S8000
G1 X161.137 Y185.495 E.13549
; LINE_WIDTH: 0.397056
M73 P67 R6
G1 F10165.602
G1 X161.092 Y185.495 E.00125
; LINE_WIDTH: 0.436047
G1 F9157.362
G1 X161.048 Y185.495 E.00139
; LINE_WIDTH: 0.475038
G1 F8331.074
G1 X161.003 Y185.495 E.00153
; LINE_WIDTH: 0.503353
G1 F7818.736
G1 X160.958 Y185.495 E.00163
G1 X160.925 Y185.662 E.0062
; LINE_WIDTH: 0.46758
G1 F8477.369
G1 X160.925 Y192.987 E.24572
M204 S10000
G1 X161.544 Y193.158 F60000
; LINE_WIDTH: 0.51671
G1 F7598.303
M204 S8000
G1 X165.855 Y193.158 E.16134
; WIPE_START
G1 X163.855 Y193.158 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X167.313 Y192.62 Z1.8 F60000
G1 Z1.4
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42352
G1 F9458.749
M204 S8000
G1 X166.799 Y192.107 E.02184
G1 X166.799 Y191.568 E.01618
G1 X167.682 Y192.451 E.03751
G1 X168.22 Y192.451 E.01618
G1 X166.799 Y191.03 E.0604
G1 X166.799 Y190.492 E.01618
G1 X168.758 Y192.451 E.08328
G1 X169.296 Y192.451 E.01618
G1 X166.799 Y189.954 E.10617
G1 X166.799 Y189.415 E.01618
G1 X169.835 Y192.451 E.12905
G1 X169.906 Y192.451 E.00214
G1 X169.906 Y191.983 E.01405
G1 X166.799 Y188.877 E.13207
G1 X166.799 Y188.339 E.01618
G1 X169.906 Y191.445 E.13207
G1 X169.906 Y190.907 E.01618
G1 X166.799 Y187.801 E.13207
G1 X166.799 Y187.262 E.01618
G1 X169.906 Y190.369 E.13207
G1 X169.906 Y189.83 E.01618
G1 X166.799 Y186.724 E.13207
G1 X166.799 Y186.186 E.01618
G1 X169.906 Y189.292 E.13207
G1 X169.906 Y188.754 E.01618
G1 X166.799 Y185.648 E.13207
G1 X166.799 Y185.109 E.01618
G1 X169.906 Y188.216 E.13207
G1 X169.906 Y187.677 E.01618
G1 X166.799 Y184.571 E.13207
G1 X166.799 Y184.033 E.01618
G1 X169.906 Y187.139 E.13207
G1 X169.906 Y186.601 E.01618
G1 X166.799 Y183.495 E.13207
G1 X166.799 Y182.956 E.01618
G1 X170.399 Y186.556 E.15303
G1 X170.937 Y186.556 E.01618
G1 X166.799 Y182.418 E.17592
G1 X166.799 Y181.88 E.01618
G1 X171.475 Y186.556 E.1988
G1 X172.013 Y186.556 E.01618
G1 X166.799 Y181.342 E.22169
G1 X166.799 Y180.803 E.01618
G1 X172.552 Y186.556 E.24457
G1 X173.09 Y186.556 E.01618
G1 X166.799 Y180.265 E.26746
G1 X166.799 Y179.727 E.01618
G1 X173.628 Y186.556 E.29034
G1 X174.166 Y186.556 E.01618
G1 X166.799 Y179.189 E.31323
G1 X166.799 Y178.65 E.01618
G1 X174.705 Y186.556 E.33611
G1 X175.243 Y186.556 E.01618
G1 X166.799 Y178.112 E.359
G1 X166.799 Y177.574 E.01618
G1 X175.951 Y186.725 E.3891
; WIPE_START
G1 X174.537 Y185.311 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.287 Y192.217 Z1.8 F60000
G1 X170.849 Y193.148 Z1.8
G1 Z1.4
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.53672
G1 F7290.401
M204 S8000
G1 X176.301 Y193.148 E.21263
; WIPE_START
G1 X174.301 Y193.148 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X177.075 Y192.155 Z1.8 F60000
G1 Z1.4
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42352
G1 F9458.749
M204 S8000
G1 X177.37 Y192.451 E.01256
G1 X177.908 Y192.451 E.01618
G1 X177.244 Y191.787 E.02823
G1 X177.244 Y191.248 E.01618
G1 X178.447 Y192.451 E.05112
G1 X178.985 Y192.451 E.01618
G1 X177.244 Y190.71 E.074
G1 X177.244 Y190.172 E.01618
G1 X179.523 Y192.451 E.09689
G1 X180.061 Y192.451 E.01618
G1 X177.244 Y189.634 E.11977
G1 X177.244 Y189.095 E.01618
G1 X180.6 Y192.451 E.14266
G1 X181.138 Y192.451 E.01618
G1 X177.244 Y188.557 E.16554
G1 X177.244 Y188.019 E.01618
G1 X188.151 Y198.925 E.46371
G1 X188.151 Y198.387 E.01618
G1 X177.244 Y187.481 E.46371
G1 X177.244 Y186.942 E.01618
G1 X188.32 Y198.018 E.47093
; WIPE_START
G1 X186.906 Y196.604 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X188.32 Y199.633 Z1.8 F60000
G1 Z1.4
G1 E.8 F1800
G1 F9458.749
M204 S8000
G1 X181.974 Y193.287 E.26982
G1 X181.974 Y193.825 E.01618
G1 X188.151 Y200.002 E.2626
G1 X188.151 Y200.54 E.01618
G1 X181.974 Y194.364 E.2626
G1 X181.974 Y194.902 E.01618
G1 X187.972 Y200.899 E.25499
G1 X187.734 Y200.941 E.00727
G2 X187.125 Y200.243 I-2.364 J1.449 E.02797
G1 X186.661 Y199.936 E.01671
G1 X186.337 Y199.803 E.01056
G1 X181.974 Y195.44 E.18548
G1 X181.974 Y195.978 E.01618
G1 X185.614 Y199.618 E.15474
G1 X185.07 Y199.613 E.01634
G1 X181.974 Y196.517 E.13164
G1 X181.974 Y197.055 E.01618
G1 X184.612 Y199.692 E.11213
G2 X184.207 Y199.826 I.14 J1.106 E.01289
G1 X181.974 Y197.593 E.09492
G1 X181.974 Y198.131 E.01618
G1 X183.84 Y199.997 E.07931
G2 X183.518 Y200.213 I.936 J1.737 E.01168
G1 X181.974 Y198.67 E.06564
G1 X181.974 Y199.208 E.01618
G1 X183.232 Y200.466 E.05348
G2 X182.988 Y200.76 I.875 J.977 E.01153
G1 X181.974 Y199.746 E.04309
G1 X181.974 Y200.284 E.01618
G1 X182.773 Y201.083 E.03395
G1 X182.606 Y201.454 E.01224
G1 X181.974 Y200.823 E.02686
G1 X181.974 Y201.361 E.01618
G1 X182.48 Y201.867 E.02152
G2 X182.407 Y202.332 I1.537 J.481 E.0142
G1 X181.974 Y201.899 E.0184
G1 X181.974 Y202.437 E.01618
G1 X182.432 Y202.895 E.01947
G2 X182.627 Y203.628 I3.354 J-.498 E.02284
G1 X181.974 Y202.976 E.02774
G1 X181.974 Y203.514 E.01618
G1 X186.711 Y208.251 E.2014
G1 X187.249 Y208.251 E.01618
G1 X184.151 Y205.152 E.13173
G2 X184.904 Y205.367 I.942 J-1.877 E.02368
G1 X187.788 Y208.251 E.1226
G1 X188.151 Y208.251 E.01091
G1 X188.151 Y208.075 E.00527
G1 X185.465 Y205.39 E.11419
G2 X185.94 Y205.327 I-.091 J-2.518 E.01444
G1 X188.151 Y207.537 E.09398
G1 X188.151 Y206.999 E.01618
G1 X186.346 Y205.194 E.07674
G1 X186.717 Y205.027 E.01224
G1 X188.151 Y206.461 E.06095
G1 X188.151 Y205.922 E.01618
G1 X187.04 Y204.812 E.04721
G2 X187.334 Y204.568 I-.68 J-1.116 E.01153
G1 X188.151 Y205.384 E.03471
G1 X188.151 Y204.846 E.01618
G1 X187.586 Y204.282 E.024
G2 X187.743 Y204.061 I-.991 J-.869 E.00816
G1 X187.938 Y204.095 E.00595
G1 X188.32 Y204.477 E.01627
M204 S10000
G1 X188.039 Y203.774 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.435756
G1 F9164.138
M204 S8000
G1 X188.075 Y203.57 E.00644
; LINE_WIDTH: 0.398178
G1 F10133.485
G1 X188.113 Y203.348 E.00631
; LINE_WIDTH: 0.359311
G1 F11378.343
G1 X188.131 Y203.207 E.00356
; LINE_WIDTH: 0.323073
G1 F12850.129
G1 X188.149 Y203.053 E.00344
; LINE_WIDTH: 0.284806
G1 F14883.051
G1 X188.169 Y202.78 E.00523
; LINE_WIDTH: 0.258108
G1 F15000
G1 X188.169 Y202.227 E.00939
; LINE_WIDTH: 0.285148
G1 F14862.037
G1 X188.149 Y201.939 E.00554
; LINE_WIDTH: 0.324026
G1 F12806.589
G1 X188.131 Y201.794 E.00324
; LINE_WIDTH: 0.361779
G1 F11290.269
G1 X188.11 Y201.631 E.00412
; LINE_WIDTH: 0.400444
G1 F10069.252
G1 X188.075 Y201.429 E.00582
; LINE_WIDTH: 0.436148
G1 F9154.994
G1 X188.039 Y201.226 E.0064
; WIPE_START
G1 X188.075 Y201.429 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X186.343 Y208.42 Z1.8 F60000
G1 Z1.4
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42352
G1 F9458.749
M204 S8000
G1 X181.974 Y204.052 E.18573
G1 X181.974 Y204.59 E.01618
G1 X185.635 Y208.251 E.15563
G1 X185.096 Y208.251 E.01618
G1 X181.974 Y205.129 E.13274
G1 X181.974 Y205.667 E.01618
G1 X184.558 Y208.251 E.10986
G1 X184.02 Y208.251 E.01618
G1 X181.974 Y206.205 E.08697
G1 X181.974 Y206.743 E.01618
G1 X183.482 Y208.251 E.06408
G1 X182.943 Y208.251 E.01618
G1 X181.974 Y207.282 E.0412
G1 X181.974 Y207.82 E.01618
G1 X182.575 Y208.42 E.02553
; WIPE_START
G1 X181.974 Y207.82 E-.32267
G1 X181.974 Y207.282 E-.20454
G1 X182.408 Y207.715 E-.2328
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X183.033 Y200.108 Z1.8 F60000
G1 X188.32 Y135.844 Z1.8
G1 Z1.4
G1 E.8 F1800
; LINE_WIDTH: 0.42088
G1 F9524.817
M204 S8000
G1 X187.726 Y135.249 E.0251
G1 X187.191 Y135.249 E.01596
G1 X188.151 Y136.209 E.0405
G1 X188.151 Y136.743 E.01596
G1 X186.657 Y135.249 E.06307
G1 X186.122 Y135.249 E.01596
G1 X187.674 Y136.801 E.0655
G1 X187.139 Y136.801 E.01596
G1 X185.588 Y135.249 E.0655
G1 X185.053 Y135.249 E.01596
G1 X186.605 Y136.801 E.0655
G1 X186.07 Y136.801 E.01596
G1 X184.519 Y135.249 E.0655
G1 X183.984 Y135.249 E.01596
G1 X185.536 Y136.801 E.0655
G1 X185.001 Y136.801 E.01596
G1 X183.45 Y135.249 E.0655
G1 X182.915 Y135.249 E.01596
G1 X184.466 Y136.801 E.0655
G1 X183.932 Y136.801 E.01596
G1 X182.381 Y135.249 E.0655
G1 X181.846 Y135.249 E.01596
G1 X183.397 Y136.801 E.0655
G1 X182.863 Y136.801 E.01596
G1 X181.312 Y135.249 E.0655
G1 X180.777 Y135.249 E.01596
G1 X182.328 Y136.801 E.0655
G1 X181.794 Y136.801 E.01596
G1 X180.243 Y135.249 E.0655
G1 X179.708 Y135.249 E.01596
G1 X181.259 Y136.801 E.0655
G1 X180.725 Y136.801 E.01596
G1 X179.174 Y135.249 E.0655
G1 X178.639 Y135.249 E.01596
G1 X180.19 Y136.801 E.0655
G1 X179.656 Y136.801 E.01596
G1 X178.105 Y135.249 E.0655
G1 X177.57 Y135.249 E.01596
G1 X179.121 Y136.801 E.0655
G1 X178.587 Y136.801 E.01596
G1 X177.036 Y135.249 E.0655
G1 X176.501 Y135.249 E.01596
G1 X178.052 Y136.801 E.0655
G1 X177.518 Y136.801 E.01596
G1 X175.966 Y135.249 E.0655
G1 X175.551 Y135.249 E.01242
G1 X175.551 Y134.834 E.01242
G1 X170.309 Y129.592 E.2213
G1 X170.309 Y129.249 E.01024
G1 X170.501 Y129.249 E.00572
G1 X175.551 Y134.299 E.21321
G1 X175.551 Y133.764 E.01596
G1 X171.036 Y129.249 E.19064
G1 X171.57 Y129.249 E.01596
G1 X175.551 Y133.23 E.16807
G1 X175.551 Y132.695 E.01596
G1 X172.105 Y129.249 E.1455
G1 X172.639 Y129.249 E.01596
G1 X175.551 Y132.161 E.12293
G1 X175.551 Y131.626 E.01596
G1 X173.174 Y129.249 E.10037
G1 X173.708 Y129.249 E.01596
G1 X175.551 Y131.092 E.0778
G1 X175.551 Y130.557 E.01596
G1 X174.243 Y129.249 E.05523
G1 X174.777 Y129.249 E.01596
G1 X175.551 Y130.023 E.03266
G1 X175.551 Y129.488 E.01596
G1 X175.142 Y129.08 E.01725
M204 S10000
G1 X176.087 Y129.025 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.66758
G1 F5763.136
M204 S8000
G1 X188.687 Y129.025 E.62173
; COOLING_NODE: 13
; WIPE_START
G1 X186.687 Y129.025 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X179.626 Y126.128 Z1.8 F60000
G1 X166.884 Y120.9 Z1.8
G1 Z1.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X166.884 Y121.274 E.01202
G1 X160.916 Y121.274 E.1919
G1 X160.916 Y111.416 E.31698
G1 X166.884 Y111.416 E.1919
G1 X166.884 Y116.247 E.15533
G1 X166.657 Y116.263 E.00732
G2 X166.657 Y116.739 I-2.555 J.241 E.50327
G1 X166.884 Y116.756 E.0073
G1 X166.884 Y120.84 E.13133
; COOLING_NODE: 13
; WIPE_START
G1 X166.884 Y121.274 E-.16484
G1 X165.318 Y121.274 E-.59516
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X164.981 Y114.535 Z1.8 F60000
G1 Z1.4
G1 E.8 F1800
G1 F8843.478
M204 S8000
G1 X165.297 Y114.704 E.01153
G3 X163.872 Y114.352 I-1.2 J1.795 E.38808
G1 X164.088 Y114.34 E.00695
G3 X164.909 Y114.498 I.01 J2.159 E.02704
G1 X164.928 Y114.508 E.00069
; COOLING_NODE: 13
M204 S10000
G1 X164.792 Y114.893 F60000
G1 F8843.478
M204 S8000
G1 X165.072 Y115.043 E.01022
G3 X163.916 Y114.757 I-.973 J1.456 E.31486
G1 X164.091 Y114.747 E.00565
G3 X164.737 Y114.868 I.008 J1.752 E.02127
; COOLING_NODE: 13
M204 S250
G1 X164.609 Y115.239 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G3 X163.957 Y115.147 I-.51 J1.26 E.23462
G1 X164.094 Y115.14 E.00407
G3 X164.553 Y115.218 I.006 J1.359 E.01396
; COOLING_NODE: 13
; WIPE_START
M204 S8000
G1 X164.855 Y115.369 E-.12833
G1 X165.062 Y115.538 E-.10143
G1 X165.228 Y115.74 E-.09936
G1 X165.353 Y115.97 E-.09932
G1 X165.401 Y116.102 E-.05363
G1 X165.454 Y116.375 E-.1057
G1 X165.453 Y116.636 E-.09906
G1 X165.416 Y116.825 E-.07318
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X167.291 Y120.9 Z1.8 F60000
G1 Z1.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X167.291 Y121.681 E.02511
G1 X160.509 Y121.681 E.21808
G1 X160.509 Y111.009 E.34316
G1 X167.291 Y111.009 E.21808
G1 X167.291 Y120.84 E.31613
; COOLING_NODE: 13
M204 S10000
G1 X167.698 Y120.9 F60000
G1 F8843.478
M204 S8000
G1 X167.698 Y121.292 E.01261
G1 X168.098 Y121.292 E.01286
G1 X168.098 Y122.088 E.02559
G1 X160.102 Y122.088 E.25712
G1 X160.102 Y110.602 E.36934
G1 X167.698 Y110.602 E.24426
G1 X167.698 Y120.84 E.32921
; COOLING_NODE: 12
M204 S250
G1 X168.09 Y120.9 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1914
M204 S5000
G1 X168.49 Y120.9 E.01191
G1 X168.49 Y122.48 E.04706
G1 X159.71 Y122.48 E.26153
G1 X159.71 Y110.21 E.36548
G1 X168.09 Y110.21 E.24961
G1 X168.09 Y120.84 E.31663
; WIPE_START
G1 F9547.055
M204 S8000
G1 X168.49 Y120.9 E-.1537
G1 X168.49 Y122.48 E-.60041
G1 X168.474 Y122.48 E-.00589
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X166.473 Y117.973 Z1.8 F60000
G1 Z1.4
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.112395
G1 F15000
M204 S8000
G1 X166.581 Y117.827 E.001
; LINE_WIDTH: 0.139892
G1 X166.68 Y117.681 E.00135
; WIPE_START
G1 X166.581 Y117.827 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X167.087 Y116.501 Z1.8 F60000
G1 Z1.4
G1 E.8 F1800
; LINE_WIDTH: 0.147248
G1 F15000
M204 S8000
G1 X166.809 Y116.501 E.00229
; LINE_WIDTH: 0.113696
G1 X166.531 Y116.501 E.00155
; WIPE_START
G1 X166.809 Y116.501 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X166.68 Y115.325 Z1.8 F60000
G1 Z1.4
G1 E.8 F1800
; LINE_WIDTH: 0.134214
G1 F15000
M204 S8000
M73 P68 R6
G1 X166.573 Y115.165 E.00139
; LINE_WIDTH: 0.10849
G1 X166.485 Y115.047 E.00077
M204 S10000
G1 X166.384 Y114.633 F60000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F9547.299
M204 S8000
G1 X166.492 Y114.583 E.00354
G1 X166.492 Y111.808 E.08265
G1 X161.308 Y111.808 E.15439
G1 X161.308 Y114.818 E.08966
G1 X161.64 Y114.853 E.00994
G1 X162.181 Y114.248 E.02417
G1 X162.463 Y114.034 E.01055
G1 X162.931 Y113.78 E.01587
G1 X163.469 Y113.609 E.0168
G1 X163.811 Y113.554 E.01032
G1 X164.346 Y113.55 E.01594
G1 X164.901 Y113.651 E.01679
G1 X165.226 Y113.763 E.01026
G1 X165.725 Y114.027 E.0168
G1 X166.178 Y114.393 E.01736
G1 X166.345 Y114.588 E.00763
M204 S10000
G1 X166.115 Y113.854 F60000
G1 F9547.299
M204 S8000
G1 X166.115 Y112.185 E.04969
G1 X161.685 Y112.185 E.13193
G1 X161.685 Y114.235 E.06104
G3 X162.752 Y113.449 I2.239 J1.922 E.0398
G1 X163.356 Y113.249 E.01896
G3 X164.97 Y113.28 I.736 J3.647 E.04848
G3 X166.067 Y113.818 I-1.103 J3.636 E.03653
M204 S10000
G1 X165.712 Y113.138 F60000
; LINE_WIDTH: 0.47159
G1 F8398.068
M204 S8000
G1 X165.712 Y112.588 E.0186
; LINE_WIDTH: 0.455325
G1 F8729.283
G1 X165.392 Y112.572 E.01043
; LINE_WIDTH: 0.422795
G1 F9476.801
G1 X165.072 Y112.556 E.00961
; LINE_WIDTH: 0.38194
G1 F10618.842
G1 X164.543 Y112.531 E.01418
; LINE_WIDTH: 0.363151
G1 F11241.888
G2 X163.193 Y112.552 I-.442 J15.307 E.03415
; LINE_WIDTH: 0.418625
G1 F9581.985
G1 X162.93 Y112.572 E.00785
; LINE_WIDTH: 0.458955
G1 F8653.118
G1 X162.666 Y112.592 E.0087
; LINE_WIDTH: 0.49475
G1 F7967.598
G1 X162.394 Y112.608 E.0097
; LINE_WIDTH: 0.536122
G1 F7299.252
G1 X162.123 Y112.623 E.01059
G1 X162.123 Y113.291 E.02603
G1 X162.547 Y113.07 E.01861
; LINE_WIDTH: 0.505302
G1 F7785.776
G1 X162.78 Y113.013 E.00877
; LINE_WIDTH: 0.462565
G1 F8578.679
G1 X163.013 Y112.956 E.00796
; LINE_WIDTH: 0.419829
G1 F9551.394
G1 X163.247 Y112.899 E.00715
; LINE_WIDTH: 0.374405
G1 F10860.22
G1 X163.805 Y112.835 E.01472
; LINE_WIDTH: 0.349275
G1 F11751.072
G1 X164.346 Y112.832 E.01309
; LINE_WIDTH: 0.362783
G1 F11254.836
G1 X164.692 Y112.874 E.00881
; LINE_WIDTH: 0.391948
G1 F10314.373
G1 X165.039 Y112.916 E.00962
; LINE_WIDTH: 0.422795
G1 F9476.801
G1 X165.246 Y112.965 E.00639
; LINE_WIDTH: 0.463706
G1 F8555.423
G3 X165.658 Y113.112 I-.131 J1.019 E.01464
; WIPE_START
G1 X165.453 Y113.014 E-.3916
G1 X165.246 Y112.965 E-.3684
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X161.361 Y115.226 Z1.8 F60000
G1 Z1.4
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.435838
G1 F9162.227
M204 S8000
G1 X161.325 Y115.43 E.00643
; LINE_WIDTH: 0.398376
G1 F10127.857
G1 X161.287 Y115.651 E.0063
; LINE_WIDTH: 0.359461
G1 F11372.965
G1 X161.269 Y115.793 E.00358
; LINE_WIDTH: 0.323048
G1 F12851.293
G1 X161.251 Y115.948 E.00345
; LINE_WIDTH: 0.284744
G1 F14886.912
G1 X161.231 Y116.221 E.00522
; LINE_WIDTH: 0.257911
G1 F15000
G1 X161.23 Y116.763 E.00921
; LINE_WIDTH: 0.284108
G1 F14926.162
G1 X161.251 Y117.054 E.00556
; LINE_WIDTH: 0.320815
G1 F12954.553
G1 X161.267 Y117.186 E.00291
; LINE_WIDTH: 0.354172
G1 F11566.199
G1 X161.285 Y117.333 E.00364
; LINE_WIDTH: 0.392554
G1 F10296.488
G1 X161.305 Y117.452 E.00334
; LINE_WIDTH: 0.428282
G1 F9341.879
G1 X161.325 Y117.572 E.00368
G1 X161.37 Y117.595 E.00156
; LINE_WIDTH: 0.367869
G1 F11078.686
G1 X161.599 Y117.708 E.00655
; WIPE_START
G1 X161.37 Y117.595 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X163.344 Y120.132 Z1.8 F60000
G1 Z1.4
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.39298
G1 F10283.951
M204 S8000
G1 X163.677 Y120.15 E.0092
; LINE_WIDTH: 0.359984
G1 F11354.184
G2 X164.714 Y120.144 I.483 J-5.62 E.02602
; LINE_WIDTH: 0.39225
G1 F10305.442
G1 X164.727 Y120.143 E.00036
; WIPE_START
G1 X164.714 Y120.144 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X163.344 Y120.132 Z1.8 F60000
G1 Z1.4
G1 E.8 F1800
; LINE_WIDTH: 0.419315
G1 F9564.43
M204 S8000
G3 X162.063 Y119.591 I.857 J-3.824 E.04158
G1 X162.063 Y120.127 E.01594
G3 X163.284 Y120.131 I.421 J61.736 E.03633
; WIPE_START
G1 X162.063 Y120.127 E-.46426
G1 X162.063 Y119.591 E-.20367
G1 X162.27 Y119.717 E-.09208
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X165.772 Y120.162 Z1.8 F60000
G1 Z1.4
G1 E.8 F1800
; LINE_WIDTH: 0.361371
G1 F11304.727
M204 S8000
G1 X165.772 Y119.774 E.00975
G3 X164.853 Y120.143 I-5.51 J-12.411 E.02492
G2 X165.712 Y120.162 I.812 J-17.096 E.02162
M204 S10000
G1 X166.115 Y120.505 F60000
; LINE_WIDTH: 0.41999
G1 F9547.299
M204 S8000
G1 X166.115 Y119.149 E.04039
G1 X165.614 Y119.472 E.01775
G3 X164.15 Y119.835 I-1.598 J-3.307 E.04524
G1 X163.516 Y119.784 E.01895
G3 X162.04 Y119.123 I.745 J-3.643 E.04856
G1 X161.687 Y118.803 E.01418
G2 X161.685 Y120.505 I222.838 J1.107 E.05067
G1 X166.055 Y120.505 E.13014
M204 S10000
G1 X166.492 Y120.882 F60000
G1 F9547.299
M204 S8000
G1 X166.492 Y118.436 E.07286
G1 X166.363 Y118.38 E.00418
G1 X166.018 Y118.753 E.01515
G1 X165.504 Y119.106 E.01857
G1 X164.983 Y119.325 E.01684
G3 X163.553 Y119.409 I-.91 J-3.289 E.04298
G1 X163.215 Y119.324 E.01038
G1 X162.722 Y119.12 E.01589
G1 X162.249 Y118.809 E.01686
G3 X161.743 Y118.253 I1.893 J-2.232 E.02246
G1 X161.621 Y118.334 E.00435
G1 X161.308 Y118.235 E.00977
G1 X161.308 Y120.882 E.07883
G1 X166.432 Y120.882 E.15261
; CHANGE_LAYER
; Z_HEIGHT: 1.575
; LAYER_HEIGHT: 0.175
; WIPE_START
G1 F9547.299
G1 X164.432 Y120.882 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 12/37
; update layer progress
M73 L12
M991 S0 P11 ;notify layer change

; OBJECT_ID: 15
M204 S10000
G17
G3 Z1.8 I-.893 J.827 P1  F60000
G1 X168.512 Y125.287 Z1.8
G1 Z1.575
G1 E.8 F1800
; FEATURE: Support
; LINE_WIDTH: 0.42
; LAYER_HEIGHT: 0.275
G1 F7252.893
M204 S8000
G1 X168.512 Y123.229 E.08069
G1 X159.688 Y123.229 E.34594
G1 X159.688 Y125.475 E.08809
G1 X168.512 Y125.475 E.34594
G1 X168.512 Y126.961 E.05828
G1 X168.337 Y126.961 E.00685
G1 X168.021 Y127.277 E.01749
G1 X168.021 Y128.352 E.04216
G1 X159.688 Y128.352 E.32672
G1 X159.688 Y130.971 E.1027
G1 X168.021 Y130.971 E.32672
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

G1 X168.021 Y128.541 E.0953
; CHANGE_LAYER
; Z_HEIGHT: 1.6
; LAYER_HEIGHT: 0.025
; WIPE_START
G1 X168.021 Y130.541 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 13/37
; update layer progress
M73 L13
M991 S0 P12 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z1.975 I-.771 J.942 P1  F60000
G1 X188.525 Y147.313 Z1.975
G1 Z1.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
; LAYER_HEIGHT: 0.2
G1 F8843.478
M204 S8000
G1 X188.917 Y147.313 E.01261
G1 X188.917 Y181.697 E1.10567
G1 X182.473 Y181.697 E.20722
G1 X182.473 Y147.313 E1.10567
G1 X188.465 Y147.313 E.19268
; COOLING_NODE: 0
M204 S250
G1 X188.525 Y147.705 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X188.525 Y181.305 E1.00083
G1 X182.865 Y181.305 E.16859
G1 X182.865 Y147.705 E1.00083
G1 X188.465 Y147.705 E.1668
; COOLING_NODE: 0
; WIPE_START
M204 S8000
G1 X188.469 Y149.705 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X181.081 Y151.625 Z2 F60000
G1 X167.23 Y155.224 Z2
G1 Z1.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X166.431 Y155.224 E.0257
G1 X166.431 Y150.766 E.14336
G1 X175.969 Y150.766 E.30672
G1 X175.969 Y155.224 E.14336
G1 X167.29 Y155.224 E.27909
; COOLING_NODE: 0
M204 S10000
G1 X167.23 Y154.817 F60000
G1 F8843.478
M204 S8000
G1 X166.838 Y154.817 E.01261
G1 X166.838 Y151.173 E.11718
G1 X175.562 Y151.173 E.28054
G1 X175.562 Y154.817 E.11718
G1 X167.29 Y154.817 E.266
; COOLING_NODE: 1
M204 S250
G1 X167.23 Y154.425 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X167.23 Y151.565 E.08519
G1 X175.17 Y151.565 E.23651
G1 X175.17 Y154.425 E.08519
G1 X167.29 Y154.425 E.23472
; COOLING_NODE: 1
; WIPE_START
M204 S8000
G1 X167.248 Y152.425 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X166.194 Y144.866 Z2 F60000
G1 X166.059 Y143.9 Z2
G1 Z1.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X166.059 Y152.899 E.28938
G1 X161.341 Y152.899 E.15172
G1 X161.341 Y143.101 E.31508
G1 X166.059 Y143.101 E.15172
G1 X166.059 Y143.84 E.02377
; COOLING_NODE: 1
M204 S10000
G1 X165.652 Y143.9 F60000
G1 F8843.478
M204 S8000
G1 X165.652 Y152.492 E.27629
G1 X161.748 Y152.492 E.12554
G1 X161.748 Y143.508 E.2889
G1 X165.652 Y143.508 E.12554
G1 X165.652 Y143.84 E.01068
; COOLING_NODE: 2
M204 S250
G1 X165.26 Y143.9 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X165.26 Y152.1 E.24425
G1 X162.14 Y152.1 E.09293
G1 X162.14 Y143.9 E.24425
G1 X165.2 Y143.9 E.09115
; COOLING_NODE: 2
; WIPE_START
M204 S8000
G1 X165.215 Y145.9 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X161.834 Y142.694 Z2 F60000
G1 Z1.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X160.916 Y142.694 E.02951
G1 X160.916 Y132.926 E.31409
G1 X161.834 Y132.926 E.02951
G1 X161.834 Y142.634 E.31216
; COOLING_NODE: 2
; WIPE_START
G1 X160.916 Y142.694 E-.34943
G1 X160.916 Y141.613 E-.41057
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X168.548 Y141.661 Z2 F60000
G1 X176.291 Y141.71 Z2
G1 Z1.6
G1 E.8 F1800
G1 F8843.478
M204 S8000
G1 X176.291 Y137.541 E.13406
G1 X188.509 Y137.541 E.3929
G1 X188.509 Y142.509 E.15976
G1 X176.291 Y142.509 E.3929
G1 X176.291 Y141.77 E.02377
; COOLING_NODE: 2
M204 S10000
G1 X176.698 Y141.71 F60000
G1 F8843.478
M204 S8000
G1 X176.698 Y137.948 E.12097
G1 X188.102 Y137.948 E.36672
G1 X188.102 Y142.102 E.13358
G1 X176.698 Y142.102 E.36672
G1 X176.698 Y141.77 E.01068
; COOLING_NODE: 3
M204 S250
G1 X177.09 Y141.71 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X177.09 Y138.34 E.10038
G1 X187.71 Y138.34 E.31633
G1 X187.71 Y141.71 E.10038
G1 X177.15 Y141.71 E.31455
; COOLING_NODE: 3
; WIPE_START
M204 S8000
G1 X177.114 Y139.71 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X176 Y147.261 Z2 F60000
G1 X174.709 Y156.009 Z2
G1 Z1.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X181.191 Y156.009 E.20845
G1 X181.191 Y160.991 E.16022
G1 X174.709 Y160.991 E.20845
G1 X174.709 Y156.069 E.15829
; COOLING_NODE: 3
; WIPE_START
G1 X176.709 Y156.05 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X180.784 Y159.785 Z2 F60000
G1 Z1.6
G1 E.8 F1800
G1 F8843.478
M204 S8000
G1 X180.784 Y160.584 E.0257
G1 X175.116 Y160.584 E.18227
G1 X175.116 Y156.416 E.13404
G1 X180.784 Y156.416 E.18227
G1 X180.784 Y159.725 E.10641
; COOLING_NODE: 3
M204 S10000
G1 X180.377 Y159.785 F60000
G1 F8843.478
M204 S8000
G1 X180.377 Y160.177 E.01261
G1 X175.523 Y160.177 E.15609
G1 X175.523 Y156.823 E.10786
G1 X180.377 Y156.823 E.15609
G1 X180.377 Y159.725 E.09332
; COOLING_NODE: 4
M204 S250
G1 X179.985 Y159.785 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X175.915 Y159.785 E.12123
G1 X175.915 Y157.215 E.07655
G1 X179.985 Y157.215 E.12123
G1 X179.985 Y159.725 E.07476
; COOLING_NODE: 4
; WIPE_START
M204 S8000
G1 X177.985 Y159.754 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X179.055 Y167.312 Z2 F60000
G1 X183.75 Y200.464 Z2
G1 Z1.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X184.056 Y200.253 E.01195
G3 X185.026 Y199.947 I1.243 J2.245 E.03294
G1 X185.269 Y199.932 E.00783
G3 X183.646 Y200.536 I.029 J2.566 E.46168
G1 X183.701 Y200.498 E.00214
; COOLING_NODE: 4
M204 S10000
G1 X183.98 Y200.798 F60000
G1 F8843.478
M204 S8000
G1 X184.253 Y200.61 E.01067
G3 X185.07 Y200.352 I1.046 J1.889 E.02774
G1 X185.274 Y200.34 E.00656
G3 X183.909 Y200.847 I.025 J2.159 E.38843
G1 X183.931 Y200.832 E.00086
; COOLING_NODE: 4
M204 S10000
G1 X184.21 Y201.132 F60000
G1 F8843.478
M204 S8000
G1 X184.451 Y200.967 E.00938
G3 X185.114 Y200.757 I.849 J1.532 E.02253
G1 X185.278 Y200.747 E.00528
G3 X184.162 Y201.167 I.021 J1.751 E.31476
; COOLING_NODE: 5
M204 S250
G1 X184.432 Y201.454 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X184.641 Y201.31 E.00755
G3 X185.157 Y201.147 I.659 J1.189 E.01623
G1 X185.283 Y201.14 E.00376
G3 X184.386 Y201.493 I.017 J1.359 E.22506
; COOLING_NODE: 5
; WIPE_START
M204 S8000
G1 X184.641 Y201.31 E-.11903
G1 X184.881 Y201.206 E-.09959
G1 X185.157 Y201.147 E-.10712
G1 X185.283 Y201.14 E-.04794
G1 X185.559 Y201.165 E-.10547
G1 X185.808 Y201.238 E-.09878
G1 X186.041 Y201.359 E-.09952
G1 X186.211 Y201.494 E-.08255
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X186.383 Y193.864 Z2 F60000
G1 X187.71 Y134.916 Z2
G1 Z1.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X188.484 Y134.916 E.02488
G1 X188.484 Y137.134 E.07131
G1 X175.884 Y137.134 E.40517
G1 X175.884 Y142.916 E.18594
G1 X188.484 Y142.916 E.40517
G1 X188.484 Y146.499 E.1152
G1 X181.659 Y146.499 E.21947
G1 X181.659 Y182.511 E1.15803
G1 X188.484 Y182.511 E.21947
G1 X188.484 Y208.584 E.8384
G1 X181.641 Y208.584 E.22003
G1 X181.641 Y192.784 E.50807
G1 X176.911 Y192.784 E.1521
G1 X176.911 Y186.889 E.18956
G1 X170.239 Y186.889 E.21456
G1 X170.239 Y192.784 E.18956
G1 X166.466 Y192.784 E.12131
G1 X166.466 Y177.459 E.4928
G1 X160.916 Y177.459 E.17847
G1 X160.916 Y168.566 E.28595
G1 X170.731 Y168.566 E.31561
G1 X170.731 Y159.234 E.3001
G1 X160.916 Y159.234 E.31561
G1 X160.916 Y153.306 E.19061
G1 X166.024 Y153.306 E.16424
G1 X166.024 Y155.631 E.07476
G1 X176.376 Y155.631 E.3329
G1 X176.376 Y150.359 E.16954
G1 X166.466 Y150.359 E.31867
G1 X166.466 Y142.806 E.24286
G1 X167.366 Y142.806 E.02894
G1 X167.366 Y132.926 E.3177
G1 X169.976 Y132.926 E.08393
G1 X169.976 Y128.916 E.12895
G1 X175.884 Y128.916 E.18997
G1 X175.884 Y134.916 E.19294
G1 X187.65 Y134.916 E.37836
; COOLING_NODE: 5
; WIPE_START
G1 X188.484 Y134.916 E-.31685
G1 X188.484 Y136.082 E-.44315
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X187.71 Y129.541 Z2 F60000
G1 Z1.6
G1 E.8 F1800
G1 F8843.478
M204 S8000
G1 X188.509 Y129.541 E.0257
G1 X188.509 Y134.509 E.15976
M73 P69 R6
G1 X176.291 Y134.509 E.3929
G1 X176.291 Y129.541 E.15976
G1 X187.65 Y129.541 E.36527
; COOLING_NODE: 5
M204 S10000
G1 X187.71 Y129.948 F60000
G1 F8843.478
M204 S8000
G1 X188.102 Y129.948 E.01261
G1 X188.102 Y134.102 E.13358
G1 X176.698 Y134.102 E.36672
G1 X176.698 Y129.948 E.13358
G1 X187.65 Y129.948 E.35218
; COOLING_NODE: 6
M204 S250
G1 X187.71 Y130.34 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X187.71 Y133.71 E.10038
G1 X177.09 Y133.71 E.31633
G1 X177.09 Y130.34 E.10038
G1 X187.65 Y130.34 E.31455
; COOLING_NODE: 6
; WIPE_START
M204 S8000
G1 X187.686 Y132.34 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X184.295 Y139.178 Z2 F60000
G1 X170.324 Y167.36 Z2
G1 Z1.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X170.324 Y168.159 E.0257
G1 X161.065 Y168.159 E.29774
G1 X161.065 Y159.641 E.27392
G1 X170.324 Y159.641 E.29774
G1 X170.324 Y167.3 E.24629
; COOLING_NODE: 6
M204 S10000
G1 X169.917 Y167.36 F60000
G1 F8843.478
M204 S8000
G1 X169.917 Y167.752 E.01261
G1 X161.472 Y167.752 E.27156
G1 X161.472 Y160.048 E.24774
G1 X169.917 Y160.048 E.27156
G1 X169.917 Y167.3 E.2332
; COOLING_NODE: 7
M204 S250
G1 X169.525 Y167.36 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X161.864 Y167.36 E.22819
G1 X161.864 Y160.44 E.20612
G1 X169.525 Y160.44 E.22819
G1 X169.525 Y167.3 E.20434
; COOLING_NODE: 7
; WIPE_START
M204 S8000
G1 X167.525 Y167.316 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X166.87 Y174.92 Z2 F60000
G1 X166.059 Y184.325 Z2
G1 Z1.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X166.059 Y185.124 E.0257
G1 X161.341 Y185.124 E.15172
G1 X161.341 Y177.866 E.2334
G1 X166.059 Y177.866 E.15172
G1 X166.059 Y184.265 E.20577
; COOLING_NODE: 7
M204 S10000
G1 X165.652 Y184.325 F60000
G1 F8843.478
M204 S8000
G1 X165.652 Y184.717 E.01261
G1 X161.748 Y184.717 E.12554
G1 X161.748 Y178.273 E.20722
G1 X165.652 Y178.273 E.12554
G1 X165.652 Y184.265 E.19268
; COOLING_NODE: 8
M204 S250
G1 X165.26 Y184.325 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X162.14 Y184.325 E.09293
G1 X162.14 Y178.665 E.16859
G1 X165.26 Y178.665 E.09293
G1 X165.26 Y184.265 E.1668
; COOLING_NODE: 8
; WIPE_START
M204 S8000
G1 X163.26 Y184.303 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X167.533 Y177.979 Z2 F60000
G1 X188.525 Y146.906 Z2
G1 Z1.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X182.066 Y146.906 E.2077
G1 X182.066 Y182.104 E1.13185
G1 X188.891 Y182.104 E.21947
G1 X188.891 Y208.991 E.86458
G1 X181.234 Y208.991 E.24621
G1 X181.234 Y193.191 E.50807
G1 X176.504 Y193.191 E.1521
G1 X176.504 Y187.296 E.18956
G1 X170.646 Y187.296 E.18838
G1 X170.646 Y193.191 E.18956
G1 X166.059 Y193.191 E.14749
G1 X166.059 Y185.866 E.23555
G1 X161.341 Y185.866 E.15172
G1 X161.341 Y193.191 E.23555
G1 X160.509 Y193.191 E.02675
G1 X160.509 Y132.519 E1.95098
G1 X162.241 Y132.519 E.05569
G1 X162.241 Y142.399 E.3177
G1 X166.959 Y142.399 E.15172
G1 X166.959 Y132.519 E.3177
G1 X169.569 Y132.519 E.08393
G1 X169.569 Y128.509 E.12895
G1 X188.891 Y128.509 E.62132
G1 X188.891 Y146.906 E.59157
G1 X188.585 Y146.906 E.00984
; COOLING_NODE: 8
; WIPE_START
G1 X186.585 Y146.906 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X179.164 Y145.121 Z2 F60000
G1 X166.16 Y141.992 Z2
G1 Z1.6
G1 E.8 F1800
G1 F8843.478
M204 S8000
G1 X162.648 Y141.992 E.11294
G1 X162.648 Y133.008 E.2889
G1 X166.552 Y133.008 E.12554
G1 X166.552 Y141.992 E.2889
G1 X166.22 Y141.992 E.01068
; COOLING_NODE: 9
M204 S250
G1 X166.16 Y141.6 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X163.04 Y141.6 E.09293
G1 X163.04 Y133.4 E.24425
G1 X166.16 Y133.4 E.09293
G1 X166.16 Y141.54 E.24246
; COOLING_NODE: 9
; WIPE_START
M204 S8000
G1 X164.16 Y141.578 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X163.798 Y149.202 Z2 F60000
G1 X161.748 Y192.325 Z2
G1 Z1.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X161.748 Y186.273 E.19461
G1 X165.652 Y186.273 E.12554
G1 X165.652 Y192.717 E.20722
G1 X161.748 Y192.717 E.12554
G1 X161.748 Y192.385 E.01068
; COOLING_NODE: 10
M204 S250
G1 X162.14 Y192.325 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X162.14 Y186.665 E.16859
G1 X165.26 Y186.665 E.09293
G1 X165.26 Y192.325 E.16859
G1 X162.2 Y192.325 E.09115
; COOLING_NODE: 10
; WIPE_START
M204 S8000
G1 X162.179 Y190.325 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X169.672 Y188.873 Z2 F60000
G1 X175.705 Y187.703 Z2
G1 Z1.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X176.097 Y187.703 E.01261
G1 X176.097 Y192.697 E.16059
G1 X171.053 Y192.697 E.1622
G1 X171.053 Y187.703 E.16059
G1 X175.645 Y187.703 E.14766
; COOLING_NODE: 11
M204 S250
G1 X175.705 Y188.095 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X175.705 Y192.305 E.1254
G1 X171.445 Y192.305 E.12689
G1 X171.445 Y188.095 E.1254
G1 X175.645 Y188.095 E.1251
; COOLING_NODE: 11
; WIPE_START
M204 S8000
G1 X175.673 Y190.095 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X174.822 Y182.51 Z2 F60000
G1 X169.162 Y132.112 Z2
G1 Z1.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X169.162 Y128.102 E.12895
G1 X189.298 Y128.102 E.6475
G1 X189.298 Y146.502 E.59168
G1 X189.898 Y146.502 E.01929
G1 X189.898 Y182.498 E1.1575
G1 X189.298 Y182.498 E.01929
G1 X189.298 Y209.398 E.86501
G1 X180.827 Y209.398 E.27239
G1 X180.827 Y193.598 E.50807
G1 X160.102 Y193.598 E.66644
G1 X160.102 Y132.112 E1.97716
G1 X169.102 Y132.112 E.28941
; COOLING_NODE: 12
M204 S250
G1 X168.77 Y131.72 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1771
M204 S5000
G1 X168.77 Y127.71 E.11944
G1 X189.69 Y127.71 E.62314
G1 X189.69 Y146.11 E.54807
G1 X190.29 Y146.11 E.01787
G1 X190.29 Y182.89 E1.09555
G1 X189.69 Y182.89 E.01787
G1 X189.69 Y209.79 E.80126
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

G1 X180.435 Y209.79 E.27568
G1 X180.435 Y193.99 E.47063
G1 X159.71 Y193.99 E.61733
M73 P70 R6
G1 X159.71 Y131.72 E1.85481
G1 X168.71 Y131.72 E.26808
; WIPE_START
G1 F9547.055
M204 S8000
G1 X168.74 Y129.72 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X167.965 Y133.09 Z2 F60000
G1 Z1.6
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.4213
G1 F9514.245
M204 S8000
G1 X167.699 Y133.356 E.01124
G1 X167.699 Y133.891 E.01599
G1 X168.331 Y133.259 E.02668
G1 X168.866 Y133.259 E.01599
G1 X167.699 Y134.426 E.0493
G1 X167.699 Y134.961 E.01599
G1 X169.401 Y133.259 E.07192
G1 X169.936 Y133.259 E.01599
G1 X167.699 Y135.496 E.09454
G1 X167.699 Y136.031 E.01599
G1 X174.481 Y129.249 E.28666
G1 X175.016 Y129.249 E.01599
G1 X167.699 Y136.566 E.30928
G1 X167.699 Y137.101 E.01599
G1 X175.551 Y129.25 E.33187
G1 X175.551 Y129.785 E.01599
G1 X167.699 Y137.636 E.33187
G1 X167.699 Y138.172 E.01599
G1 X175.551 Y130.32 E.33187
G1 X175.551 Y130.855 E.01599
G1 X167.699 Y138.707 E.33187
G1 X167.699 Y139.242 E.01599
G1 X175.551 Y131.39 E.33187
G1 X175.551 Y131.926 E.01599
G1 X167.699 Y139.777 E.33187
G1 X167.699 Y140.312 E.01599
G1 X175.551 Y132.461 E.33187
G1 X175.551 Y132.996 E.01599
G1 X167.699 Y140.847 E.33187
G1 X167.699 Y141.382 E.01599
G1 X175.551 Y133.531 E.33187
G1 X175.551 Y134.066 E.01599
G1 X167.699 Y141.917 E.33187
G1 X167.699 Y142.452 E.01599
G1 X175.551 Y134.601 E.33187
G1 X175.551 Y135.136 E.01599
G1 X166.799 Y143.888 E.36992
G1 X166.799 Y144.423 E.01599
G1 X175.973 Y135.249 E.38775
G1 X176.508 Y135.249 E.01599
G1 X166.63 Y145.127 E.41754
; WIPE_START
G1 X168.044 Y143.713 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X167.182 Y142.97 Z2 F60000
G1 Z1.6
G1 E.8 F1800
G1 F9514.245
M204 S8000
G1 X166.63 Y143.522 E.02335
M204 S10000
G1 X166.263 Y142.75 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.33758
G1 F12217.47
M204 S8000
G1 X162.037 Y142.75 E.09834
; WIPE_START
G1 X164.037 Y142.75 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X162.578 Y150.242 Z2 F60000
G1 X160.787 Y159.437 Z2
G1 Z1.6
G1 E.8 F1800
; LINE_WIDTH: 0.19158
G1 F15000
M204 S8000
G1 X160.787 Y168.363 E.10481
M204 S10000
G1 X161.08 Y169.192 F60000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42065
G1 F9530.617
M204 S8000
G1 X161.372 Y168.899 E.01234
G1 X161.906 Y168.899 E.01594
G1 X161.249 Y169.556 E.02772
G1 X161.249 Y170.091 E.01594
G1 X162.441 Y168.899 E.05026
G1 X162.975 Y168.899 E.01594
G1 X161.249 Y170.625 E.07281
G1 X161.249 Y171.159 E.01594
G1 X163.509 Y168.899 E.09535
G1 X164.043 Y168.899 E.01594
G1 X161.249 Y171.693 E.11789
G1 X161.249 Y172.227 E.01594
G1 X164.577 Y168.899 E.14043
G1 X165.111 Y168.899 E.01594
G1 X161.249 Y172.761 E.16297
G1 X161.249 Y173.296 E.01594
G1 X165.646 Y168.899 E.18551
G1 X166.18 Y168.899 E.01594
G1 X161.249 Y173.83 E.20805
G1 X161.249 Y174.364 E.01594
G1 X166.714 Y168.899 E.23059
G1 X167.248 Y168.899 E.01594
G1 X161.249 Y174.898 E.25314
G1 X161.249 Y175.432 E.01594
G1 X167.782 Y168.899 E.27568
G1 X168.317 Y168.899 E.01594
G1 X161.249 Y175.967 E.29822
G1 X161.249 Y176.501 E.01594
G1 X168.851 Y168.899 E.32076
G1 X169.385 Y168.899 E.01594
G1 X161.249 Y177.035 E.3433
G1 X161.249 Y177.126 E.0027
G1 X161.693 Y177.126 E.01323
G1 X169.919 Y168.899 E.34713
G1 X170.453 Y168.899 E.01594
G1 X162.057 Y177.295 E.35429
; WIPE_START
G1 X163.472 Y175.881 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X160.925 Y177.662 Z2 F60000
G1 Z1.6
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.467762
G1 F8473.752
M204 S8000
G1 X160.925 Y185.328 E.25724
G1 X160.941 Y185.411 E.00286
; LINE_WIDTH: 0.51702
G1 F7593.335
G1 X160.958 Y185.495 E.00319
; WIPE_START
G1 X160.941 Y185.411 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X165.03 Y191.856 Z2 F60000
G1 X165.855 Y193.158 Z2
G1 Z1.6
G1 E.8 F1800
; LINE_WIDTH: 0.51671
G1 F7598.303
M204 S8000
G1 X161.544 Y193.158 E.16134
M204 S10000
G1 X160.925 Y192.987 F60000
; LINE_WIDTH: 0.46758
G1 F8477.369
M204 S8000
G1 X160.925 Y185.662 E.24572
; LINE_WIDTH: 0.503353
G1 F7818.736
G1 X160.958 Y185.495 E.0062
G1 X161.003 Y185.495 E.00163
; LINE_WIDTH: 0.475038
G1 F8331.074
G1 X161.048 Y185.495 E.00153
; LINE_WIDTH: 0.436047
G1 F9157.362
G1 X161.092 Y185.495 E.00139
; LINE_WIDTH: 0.397056
G1 F10165.602
G1 X161.137 Y185.495 E.00125
; LINE_WIDTH: 0.37757
G1 F10757.508
G1 X166.263 Y185.495 E.13549
; WIPE_START
G1 X164.263 Y185.495 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X166.63 Y189.283 Z2 F60000
G1 Z1.6
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42065
G1 F9530.617
M204 S8000
G1 X181.326 Y174.587 E.62013
G1 X181.326 Y174.053 E.01594
G1 X166.799 Y188.579 E.61297
G1 X166.799 Y188.045 E.01594
G1 X181.326 Y173.519 E.61297
G1 X181.326 Y172.984 E.01594
G1 X166.799 Y187.511 E.61297
G1 X166.799 Y186.977 E.01594
G1 X181.326 Y172.45 E.61297
G1 X181.326 Y171.916 E.01594
G1 X166.799 Y186.442 E.61297
G1 X166.799 Y185.908 E.01594
G1 X181.326 Y171.382 E.61297
G1 X181.326 Y170.848 E.01594
G1 X166.799 Y185.374 E.61297
G1 X166.799 Y184.84 E.01594
G1 X181.326 Y170.314 E.61297
G1 X181.326 Y169.779 E.01594
G1 X166.799 Y184.306 E.61297
G1 X166.799 Y183.771 E.01594
G1 X181.326 Y169.245 E.61297
G1 X181.326 Y168.711 E.01594
G1 X166.799 Y183.237 E.61297
G1 X166.799 Y182.703 E.01594
G1 X181.326 Y168.177 E.61297
G1 X181.326 Y167.643 E.01594
G1 X166.799 Y182.169 E.61297
G1 X166.799 Y181.635 E.01594
G1 X181.326 Y167.108 E.61297
G1 X181.326 Y166.574 E.01594
G1 X166.799 Y181.1 E.61297
G1 X166.799 Y180.566 E.01594
G1 X181.326 Y166.04 E.61297
G1 X181.326 Y165.506 E.01594
G1 X166.799 Y180.032 E.61297
G1 X166.799 Y179.498 E.01594
G1 X181.326 Y164.972 E.61297
G1 X181.326 Y164.437 E.01594
G1 X166.799 Y178.964 E.61297
G1 X166.799 Y178.429 E.01594
G1 X181.326 Y163.903 E.61297
G1 X181.326 Y163.369 E.01594
G1 X166.799 Y177.895 E.61297
G1 X166.799 Y177.361 E.01594
G1 X181.326 Y162.835 E.61297
G1 X181.326 Y162.301 E.01594
M73 P71 R6
G1 X166.501 Y177.126 E.62557
G1 X165.966 Y177.126 E.01594
G1 X181.326 Y161.766 E.64812
G1 X181.326 Y161.528 E.00712
G1 X181.04 Y161.518 E.00853
G1 X165.432 Y177.126 E.65861
G1 X164.898 Y177.126 E.01594
G1 X180.699 Y161.324 E.66677
G1 X180.165 Y161.324 E.01594
G1 X164.364 Y177.126 E.66677
G1 X163.83 Y177.126 E.01594
G1 X179.631 Y161.324 E.66677
G1 X179.097 Y161.324 E.01594
G1 X163.295 Y177.126 E.66677
G1 X162.761 Y177.126 E.01594
G1 X178.563 Y161.324 E.66677
G1 X178.028 Y161.324 E.01594
G1 X171.064 Y168.288 E.29386
G1 X171.064 Y167.754 E.01594
G1 X177.494 Y161.324 E.27132
G1 X176.96 Y161.324 E.01594
G1 X171.064 Y167.22 E.24878
G1 X171.064 Y166.686 E.01594
G1 X176.426 Y161.324 E.22624
G1 X175.892 Y161.324 E.01594
G1 X171.064 Y166.152 E.2037
G1 X171.064 Y165.617 E.01594
G1 X175.357 Y161.324 E.18116
G1 X174.823 Y161.324 E.01594
G1 X171.064 Y165.083 E.15862
G1 X171.064 Y164.549 E.01594
G1 X174.376 Y161.238 E.13973
G1 X174.376 Y160.704 E.01594
G1 X171.064 Y164.015 E.13973
G1 X171.064 Y163.481 E.01594
G1 X174.376 Y160.169 E.13973
G1 X174.376 Y159.635 E.01594
G1 X171.064 Y162.946 E.13973
G1 X171.064 Y162.412 E.01594
G1 X174.376 Y159.101 E.13973
G1 X174.376 Y158.567 E.01594
G1 X171.064 Y161.878 E.13973
G1 X171.064 Y161.344 E.01594
G1 X174.376 Y158.033 E.13973
G1 X174.376 Y157.498 E.01594
G1 X171.064 Y160.81 E.13973
G1 X171.064 Y160.276 E.01594
G1 X174.376 Y156.964 E.13973
G1 X174.376 Y156.43 E.01594
G1 X171.064 Y159.741 E.13973
G1 X171.064 Y159.207 E.01594
G1 X174.307 Y155.964 E.13684
G1 X173.773 Y155.964 E.01594
G1 X170.837 Y158.901 E.1239
G1 X170.302 Y158.901 E.01594
G1 X173.239 Y155.964 E.1239
G1 X172.705 Y155.964 E.01594
G1 X169.768 Y158.901 E.1239
G1 X169.234 Y158.901 E.01594
G1 X172.17 Y155.964 E.1239
G1 X171.636 Y155.964 E.01594
G1 X168.7 Y158.901 E.1239
G1 X168.166 Y158.901 E.01594
G1 X171.102 Y155.964 E.1239
G1 X170.568 Y155.964 E.01594
G1 X167.632 Y158.901 E.1239
G1 X167.097 Y158.901 E.01594
G1 X170.034 Y155.964 E.1239
G1 X169.499 Y155.964 E.01594
G1 X166.563 Y158.901 E.1239
G1 X166.029 Y158.901 E.01594
G1 X168.965 Y155.964 E.1239
G1 X168.431 Y155.964 E.01594
G1 X165.495 Y158.901 E.1239
G1 X164.961 Y158.901 E.01594
G1 X167.897 Y155.964 E.1239
G1 X167.363 Y155.964 E.01594
G1 X164.426 Y158.901 E.1239
G1 X163.892 Y158.901 E.01594
G1 X166.828 Y155.964 E.1239
G1 X166.294 Y155.964 E.01594
G1 X163.358 Y158.901 E.1239
G1 X162.824 Y158.901 E.01594
G1 X165.76 Y155.964 E.1239
G1 X165.691 Y155.964 E.00207
G1 X165.691 Y155.5 E.01387
G1 X162.29 Y158.901 E.14351
G1 X161.755 Y158.901 E.01594
G1 X165.691 Y154.965 E.16605
G1 X165.691 Y154.431 E.01594
G1 X161.249 Y158.873 E.18741
G1 X161.249 Y158.338 E.01594
G1 X165.691 Y153.897 E.18741
G1 X165.691 Y153.639 E.00769
G1 X165.414 Y153.639 E.00825
G1 X161.249 Y157.804 E.17574
G1 X161.249 Y157.27 E.01594
G1 X164.88 Y153.639 E.1532
G1 X164.346 Y153.639 E.01594
G1 X161.249 Y156.736 E.13066
G1 X161.249 Y156.202 E.01594
G1 X163.812 Y153.639 E.10812
G1 X163.277 Y153.639 E.01594
G1 X161.249 Y155.667 E.08558
G1 X161.249 Y155.133 E.01594
G1 X162.743 Y153.639 E.06304
G1 X162.209 Y153.639 E.01594
G1 X161.249 Y154.599 E.04049
G1 X161.249 Y154.065 E.01594
G1 X161.844 Y153.47 E.02511
M204 S10000
G1 X160.925 Y153.103 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.46758
G1 F8477.369
M204 S8000
G1 X160.925 Y142.897 E.34233
M204 S10000
G1 X161.375 Y142.49 F60000
; LINE_WIDTH: 0.55344
G1 F7051.634
M204 S8000
G1 X161.375 Y133.13 E.37749
; WIPE_START
G1 X161.375 Y135.13 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X162.444 Y132.56 Z2 F60000
G1 Z1.6
G1 E.8 F1800
; LINE_WIDTH: 0.53172
G1 F7364.976
M204 S8000
G1 X166.755 Y132.56 E.16645
; WIPE_START
G1 X164.755 Y132.56 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X170.14 Y133.056 Z2 F60000
G1 Z1.6
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.4213
G1 F9514.245
M204 S8000
G1 X173.946 Y129.249 E.16089
G1 X173.411 Y129.249 E.01599
G1 X170.309 Y132.351 E.1311
G1 X170.309 Y131.816 E.01599
G1 X172.876 Y129.249 E.10848
G1 X172.341 Y129.249 E.01599
G1 X170.309 Y131.281 E.08586
G1 X170.309 Y130.746 E.01599
G1 X171.806 Y129.249 E.06324
G1 X171.27 Y129.249 E.01599
G1 X170.309 Y130.21 E.04062
G1 X170.309 Y129.675 E.01599
G1 X170.905 Y129.08 E.02518
; WIPE_START
G1 X170.309 Y129.675 E-.3201
G1 X170.309 Y130.21 E-.20334
G1 X170.75 Y129.77 E-.23656
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X176.087 Y129.025 Z2 F60000
G1 Z1.6
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.66758
G1 F5763.136
M204 S8000
G1 X188.687 Y129.025 E.62173
; WIPE_START
G1 X186.687 Y129.025 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X187.586 Y136.604 Z2 F60000
G1 X187.629 Y136.97 Z2
G1 Z1.6
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.4213
G1 F9514.245
M204 S8000
G1 X188.151 Y136.449 E.02203
G1 X188.151 Y135.914 E.01599
G1 X187.264 Y136.801 E.03748
G1 X186.729 Y136.801 E.01599
G1 X188.151 Y135.379 E.0601
G1 X188.151 Y135.249 E.00387
G1 X187.745 Y135.249 E.01212
G1 X186.194 Y136.801 E.06557
G1 X185.659 Y136.801 E.01599
G1 X187.21 Y135.249 E.06557
G1 X186.675 Y135.249 E.01599
G1 X185.124 Y136.801 E.06557
G1 X184.588 Y136.801 E.01599
G1 X186.14 Y135.249 E.06557
G1 X185.605 Y135.249 E.01599
G1 X184.053 Y136.801 E.06557
G1 X183.518 Y136.801 E.01599
G1 X185.07 Y135.249 E.06557
G1 X184.534 Y135.249 E.01599
G1 X182.983 Y136.801 E.06557
G1 X182.448 Y136.801 E.01599
G1 X183.999 Y135.249 E.06557
G1 X183.464 Y135.249 E.01599
G1 X181.913 Y136.801 E.06557
G1 X181.378 Y136.801 E.01599
G1 X182.929 Y135.249 E.06557
G1 X182.394 Y135.249 E.01599
G1 X180.843 Y136.801 E.06557
G1 X180.308 Y136.801 E.01599
G1 X181.859 Y135.249 E.06557
G1 X181.324 Y135.249 E.01599
G1 X179.772 Y136.801 E.06557
G1 X179.237 Y136.801 E.01599
G1 X180.789 Y135.249 E.06557
G1 X180.254 Y135.249 E.01599
G1 X178.702 Y136.801 E.06557
G1 X178.167 Y136.801 E.01599
G1 X179.718 Y135.249 E.06557
G1 X179.183 Y135.249 E.01599
G1 X177.632 Y136.801 E.06557
G1 X177.097 Y136.801 E.01599
G1 X178.648 Y135.249 E.06557
G1 X178.113 Y135.249 E.01599
G1 X176.562 Y136.801 E.06557
G1 X176.027 Y136.801 E.01599
G1 X177.578 Y135.249 E.06557
G1 X177.043 Y135.249 E.01599
G1 X166.799 Y145.493 E.43299
G1 X166.799 Y146.028 E.01599
G1 X175.551 Y137.277 E.36992
G1 X175.551 Y137.812 E.01599
G1 X166.799 Y146.563 E.36992
G1 X166.799 Y147.098 E.01599
G1 X175.551 Y138.347 E.36992
G1 X175.551 Y138.882 E.01599
G1 X166.799 Y147.633 E.36992
G1 X166.799 Y148.168 E.01599
G1 X175.551 Y139.417 E.36992
G1 X175.551 Y139.952 E.01599
G1 X166.799 Y148.704 E.36992
G1 X166.799 Y149.239 E.01599
G1 X175.551 Y140.487 E.36992
G1 X175.551 Y141.022 E.01599
G1 X166.799 Y149.774 E.36992
G1 X166.799 Y150.026 E.00753
G1 X167.083 Y150.026 E.00846
G1 X175.551 Y141.558 E.35794
G1 X175.551 Y142.093 E.01599
G1 X167.618 Y150.026 E.33533
G1 X168.153 Y150.026 E.01599
G1 X175.551 Y142.628 E.31271
G1 X175.551 Y143.163 E.01599
G1 X168.688 Y150.026 E.29009
G1 X169.223 Y150.026 E.01599
G1 X175.999 Y143.249 E.28643
G1 X176.534 Y143.249 E.01599
G1 X169.758 Y150.026 E.28643
G1 X170.293 Y150.026 E.01599
G1 X177.069 Y143.249 E.28643
G1 X177.605 Y143.249 E.01599
G1 X170.828 Y150.026 E.28643
G1 X171.363 Y150.026 E.01599
G1 X178.14 Y143.249 E.28643
G1 X178.675 Y143.249 E.01599
G1 X171.899 Y150.026 E.28643
G1 X172.434 Y150.026 E.01599
G1 X179.21 Y143.249 E.28643
G1 X179.745 Y143.249 E.01599
G1 X172.969 Y150.026 E.28643
G1 X173.504 Y150.026 E.01599
G1 X180.28 Y143.249 E.28643
G1 X180.815 Y143.249 E.01599
G1 X174.039 Y150.026 E.28643
G1 X174.574 Y150.026 E.01599
G1 X181.35 Y143.249 E.28643
G1 X181.885 Y143.249 E.01599
G1 X175.109 Y150.026 E.28643
G1 X175.644 Y150.026 E.01599
G1 X182.421 Y143.249 E.28643
G1 X182.956 Y143.249 E.01599
G1 X176.179 Y150.026 E.28643
G1 X176.709 Y150.031 E.01584
G1 X183.491 Y143.249 E.28665
G1 X184.026 Y143.249 E.01599
G1 X176.54 Y150.736 E.31644
; WIPE_START
G1 X177.954 Y149.321 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X180.096 Y156.647 Z2 F60000
G1 X181.425 Y161.195 Z2
G1 Z1.6
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.10344
G1 F15000
M204 S8000
G1 X181.425 Y155.805 E.02576
M204 S10000
G1 X180.527 Y155.845 F60000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.4213
G1 F9514.245
M204 S8000
G1 X181.326 Y155.047 E.03377
G1 X181.326 Y154.511 E.01599
G1 X180.161 Y155.676 E.04921
G1 X179.626 Y155.676 E.01599
M73 P71 R5
G1 X181.326 Y153.976 E.07183
G1 X181.326 Y153.441 E.01599
G1 X179.091 Y155.676 E.09445
G1 X178.556 Y155.676 E.01599
G1 X181.326 Y152.906 E.11707
G1 X181.326 Y152.371 E.01599
G1 X178.021 Y155.676 E.13969
G1 X177.486 Y155.676 E.01599
G1 X181.326 Y151.836 E.16231
G1 X181.326 Y151.301 E.01599
G1 X176.951 Y155.676 E.18493
G1 X176.709 Y155.676 E.00722
G1 X176.709 Y155.382 E.00878
G1 X181.326 Y150.766 E.19513
G1 X181.326 Y150.231 E.01599
G1 X176.709 Y154.847 E.19513
G1 X176.709 Y154.312 E.01599
G1 X181.326 Y149.695 E.19513
G1 X181.326 Y149.16 E.01599
G1 X176.709 Y153.777 E.19513
G1 X176.709 Y153.241 E.01599
G1 X181.326 Y148.625 E.19513
G1 X181.326 Y148.09 E.01599
G1 X176.709 Y152.706 E.19513
G1 X176.709 Y152.171 E.01599
G1 X181.326 Y147.555 E.19513
G1 X181.326 Y147.02 E.01599
G1 X176.709 Y151.636 E.19513
G1 X176.709 Y151.101 E.01599
G1 X184.561 Y143.249 E.33189
G1 X185.096 Y143.249 E.01599
G1 X182.18 Y146.166 E.12327
G1 X182.715 Y146.166 E.01599
G1 X185.631 Y143.249 E.12327
G1 X186.166 Y143.249 E.01599
G1 X183.25 Y146.166 E.12327
G1 X183.785 Y146.166 E.01599
G1 X186.701 Y143.249 E.12327
G1 X187.237 Y143.249 E.01599
G1 X184.32 Y146.166 E.12327
G1 X184.855 Y146.166 E.01599
G1 X187.772 Y143.249 E.12327
G1 X188.151 Y143.249 E.01133
G1 X188.151 Y143.406 E.00467
G1 X185.391 Y146.166 E.11667
G1 X185.926 Y146.166 E.01599
G1 X188.151 Y143.941 E.09405
G1 X188.151 Y144.476 E.01599
G1 X186.461 Y146.166 E.07143
G1 X186.996 Y146.166 E.01599
G1 X188.151 Y145.011 E.04881
G1 X188.151 Y145.546 E.01599
G1 X187.531 Y146.166 E.02619
G1 X188.066 Y146.166 E.01599
G1 X188.32 Y145.911 E.01075
; WIPE_START
G1 X188.066 Y146.166 E-.13662
G1 X187.531 Y146.166 E-.20334
G1 X188.151 Y145.546 E-.33301
G1 X188.151 Y145.317 E-.08703
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X189.095 Y147.093 Z2 F60000
G1 Z1.6
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.118631
G1 F15000
M204 S8000
G1 X189.12 Y147.083 E.00016
; LINE_WIDTH: 0.165653
G1 X189.146 Y147.074 E.00027
; LINE_WIDTH: 0.212674
G1 X189.172 Y147.065 E.00037
; LINE_WIDTH: 0.259695
G1 X189.198 Y147.055 E.00047
; LINE_WIDTH: 0.306717
G1 F13646.879
G1 X189.224 Y147.046 E.00057
; LINE_WIDTH: 0.353738
G1 F11582.34
G1 X189.25 Y147.037 E.00068
; LINE_WIDTH: 0.40076
G1 F10060.376
G1 X189.276 Y147.028 E.00078
; LINE_WIDTH: 0.447781
G1 F8891.942
G1 X189.302 Y147.018 E.00088
; LINE_WIDTH: 0.494803
G1 F7966.675
G1 X189.327 Y147.009 E.00098
; LINE_WIDTH: 0.541824
G1 F7215.819
G1 X189.353 Y147 E.00108
; LINE_WIDTH: 0.588846
G1 F6594.309
G1 X189.379 Y146.99 E.00119
; LINE_WIDTH: 0.616778
G1 F6273.336
G1 X189.398 Y147.002 E.001
G1 X189.408 Y147.109 E.00487
G1 X189.408 Y181.901 E1.57711
G1 X189.399 Y181.999 E.00448
G1 X189.371 Y182.018 E.00153
; LINE_WIDTH: 0.573214
G1 F6788.692
G1 X189.346 Y182.009 E.00112
; LINE_WIDTH: 0.527681
G1 F7426.342
G1 X189.321 Y182 E.00102
; LINE_WIDTH: 0.482149
G1 F8196.196
G1 X189.296 Y181.99 E.00093
; LINE_WIDTH: 0.436616
G1 F9144.123
G1 X189.27 Y181.981 E.00083
; LINE_WIDTH: 0.391083
G1 F10339.991
G1 X189.245 Y181.972 E.00074
; LINE_WIDTH: 0.34555
G1 F11895.715
G1 X189.22 Y181.963 E.00064
; LINE_WIDTH: 0.300018
G1 F14002.483
G1 X189.195 Y181.954 E.00054
; LINE_WIDTH: 0.254485
G1 F15000
G1 X189.17 Y181.945 E.00045
; LINE_WIDTH: 0.208952
G1 X189.145 Y181.936 E.00035
; LINE_WIDTH: 0.163419
G1 X189.12 Y181.926 E.00025
; LINE_WIDTH: 0.117887
G1 X189.095 Y181.917 E.00016
; WIPE_START
G1 X189.12 Y181.926 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X183.377 Y186.953 Z2 F60000
G1 X176.301 Y193.148 Z2
G1 Z1.6
G1 E.8 F1800
; LINE_WIDTH: 0.53672
G1 F7290.401
M204 S8000
G1 X170.849 Y193.148 E.21263
; WIPE_START
G1 X172.849 Y193.148 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X170.075 Y192.248 Z2 F60000
G1 Z1.6
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42065
G1 F9530.617
M204 S8000
G1 X169.872 Y192.451 E.00857
G1 X169.338 Y192.451 E.01594
G1 X169.906 Y191.883 E.02395
G1 X169.906 Y191.349 E.01594
G1 X168.804 Y192.451 E.04649
G1 X168.27 Y192.451 E.01594
M73 P72 R5
G1 X169.906 Y190.815 E.06903
G1 X169.906 Y190.281 E.01594
G1 X167.736 Y192.451 E.09157
G1 X167.201 Y192.451 E.01594
G1 X169.906 Y189.746 E.11411
G1 X169.906 Y189.212 E.01594
G1 X166.799 Y192.318 E.13108
G1 X166.799 Y191.784 E.01594
G1 X169.906 Y188.678 E.13108
G1 X169.906 Y188.144 E.01594
G1 X166.799 Y191.25 E.13108
G1 X166.799 Y190.716 E.01594
G1 X169.906 Y187.61 E.13108
G1 X169.906 Y187.075 E.01594
G1 X166.799 Y190.182 E.13108
G1 X166.799 Y189.648 E.01594
G1 X181.326 Y175.121 E.61297
G1 X181.326 Y175.655 E.01594
G1 X170.425 Y186.556 E.45996
G1 X170.96 Y186.556 E.01594
G1 X181.326 Y176.19 E.43742
G1 X181.326 Y176.724 E.01594
G1 X171.494 Y186.556 E.41488
G1 X172.028 Y186.556 E.01594
G1 X181.326 Y177.258 E.39234
G1 X181.326 Y177.792 E.01594
G1 X172.562 Y186.556 E.36979
G1 X173.096 Y186.556 E.01594
G1 X181.326 Y178.326 E.34725
G1 X181.326 Y178.861 E.01594
G1 X173.631 Y186.556 E.32471
G1 X174.165 Y186.556 E.01594
G1 X181.326 Y179.395 E.30217
G1 X181.326 Y179.929 E.01594
G1 X174.699 Y186.556 E.27963
G1 X175.233 Y186.556 E.01594
G1 X181.326 Y180.463 E.25709
G1 X181.326 Y180.997 E.01594
G1 X175.767 Y186.556 E.23455
G1 X176.302 Y186.556 E.01594
G1 X181.326 Y181.532 E.212
G1 X181.326 Y182.066 E.01594
G1 X176.836 Y186.556 E.18946
G1 X177.244 Y186.556 E.01219
G1 X177.244 Y186.681 E.00375
G1 X181.326 Y182.6 E.17222
G1 X181.326 Y182.844 E.00729
G1 X181.615 Y182.844 E.00864
G1 X177.244 Y187.215 E.18444
G1 X177.244 Y187.75 E.01594
G1 X182.15 Y182.844 E.20699
G1 X182.684 Y182.844 E.01594
G1 X177.244 Y188.284 E.22953
G1 X177.244 Y188.818 E.01594
G1 X183.218 Y182.844 E.25207
G1 X183.752 Y182.844 E.01594
G1 X177.244 Y189.352 E.27461
G1 X177.244 Y189.886 E.01594
G1 X184.286 Y182.844 E.29715
G1 X184.82 Y182.844 E.01594
G1 X177.244 Y190.421 E.31969
G1 X177.244 Y190.955 E.01594
G1 X185.355 Y182.844 E.34223
G1 X185.889 Y182.844 E.01594
G1 X177.244 Y191.489 E.36477
G1 X177.244 Y192.023 E.01594
G1 X186.423 Y182.844 E.38732
G1 X186.957 Y182.844 E.01594
G1 X177.351 Y192.451 E.40536
G1 X177.885 Y192.451 E.01594
G1 X187.491 Y182.844 E.40536
G1 X188.026 Y182.844 E.01594
G1 X178.419 Y192.451 E.40536
G1 X178.954 Y192.451 E.01594
G1 X188.151 Y183.254 E.38809
G1 X188.151 Y183.788 E.01594
G1 X179.488 Y192.451 E.36555
G1 X180.022 Y192.451 E.01594
G1 X188.151 Y184.322 E.34301
G1 X188.151 Y184.856 E.01594
G1 X180.556 Y192.451 E.32047
G1 X181.09 Y192.451 E.01594
G1 X188.151 Y185.39 E.29793
G1 X188.151 Y185.925 E.01594
G1 X181.625 Y192.451 E.27538
G1 X181.974 Y192.451 E.01044
G1 X181.974 Y192.635 E.0055
G1 X188.151 Y186.459 E.26062
G1 X188.151 Y186.993 E.01594
G1 X181.974 Y193.169 E.26062
G1 X181.974 Y193.703 E.01594
G1 X188.151 Y187.527 E.26062
G1 X188.151 Y188.061 E.01594
G1 X181.974 Y194.238 E.26062
G1 X181.974 Y194.772 E.01594
G1 X188.151 Y188.595 E.26062
G1 X188.151 Y189.13 E.01594
G1 X181.974 Y195.306 E.26062
G1 X181.974 Y195.84 E.01594
G1 X188.151 Y189.664 E.26062
G1 X188.151 Y190.198 E.01594
G1 X181.974 Y196.374 E.26062
G1 X181.974 Y196.909 E.01594
G1 X188.151 Y190.732 E.26062
G1 X188.151 Y191.266 E.01594
G1 X181.974 Y197.443 E.26062
G1 X181.974 Y197.977 E.01594
G1 X188.151 Y191.801 E.26062
G1 X188.151 Y192.335 E.01594
G1 X181.974 Y198.511 E.26062
G1 X181.974 Y199.045 E.01594
G1 X188.151 Y192.869 E.26062
G1 X188.151 Y193.403 E.01594
G1 X181.974 Y199.579 E.26062
G1 X181.974 Y200.114 E.01594
G1 X188.151 Y193.937 E.26062
G1 X188.151 Y194.472 E.01594
G1 X181.974 Y200.648 E.26062
G1 X181.974 Y201.182 E.01594
G1 X188.151 Y195.006 E.26062
G1 X188.151 Y195.54 E.01594
G1 X181.805 Y201.886 E.26778
; WIPE_START
G1 X183.219 Y200.472 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X187.802 Y203.712 Z2 F60000
G1 Z1.6
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.433574
G1 F9215.323
M204 S8000
G1 X188.076 Y203.573 E.00946
G1 X188.097 Y203.442 E.00409
; LINE_WIDTH: 0.387638
G1 F10443.343
G1 X188.119 Y203.312 E.00361
; LINE_WIDTH: 0.347403
G1 F11823.334
G1 X188.137 Y203.154 E.00383
; LINE_WIDTH: 0.313132
G1 F13322.911
G1 X188.153 Y203.011 E.00305
; LINE_WIDTH: 0.265468
G1 F15000
G1 X188.172 Y202.712 E.00528
G1 X188.166 Y202.162 E.00966
; LINE_WIDTH: 0.293245
G1 F14381.319
G1 X188.144 Y201.895 E.0053
; LINE_WIDTH: 0.334696
G1 F12338.233
G1 X188.124 Y201.744 E.00351
; LINE_WIDTH: 0.37269
G1 F10916.697
G1 X188.106 Y201.606 E.00363
; LINE_WIDTH: 0.409177
G1 F9829.164
G1 X188.071 Y201.407 E.00584
; LINE_WIDTH: 0.439636
G1 F9074.498
G1 X188.038 Y201.225 E.00579
; WIPE_START
G1 X188.071 Y201.407 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X188.32 Y200.178 Z2 F60000
G1 Z1.6
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42065
G1 F9530.617
M204 S8000
G1 X187.662 Y200.836 E.02778
G2 X187.426 Y200.538 I-.883 J.456 E.01142
G1 X188.151 Y199.813 E.03058
G1 X188.151 Y199.279 E.01594
G1 X187.156 Y200.274 E.04197
G2 X186.848 Y200.048 I-2.34 J2.861 E.01141
G1 X188.151 Y198.745 E.05497
G1 X188.151 Y198.211 E.01594
G1 X186.496 Y199.866 E.06984
G1 X186.113 Y199.714 E.01228
G1 X188.151 Y197.677 E.08598
G1 X188.151 Y197.143 E.01594
G1 X185.664 Y199.629 E.10492
G1 X185.555 Y199.608 E.00331
G1 X185.147 Y199.612 E.0122
G1 X188.151 Y196.608 E.12676
G1 X188.151 Y196.074 E.01594
G1 X184.514 Y199.711 E.15344
G1 X184.403 Y199.74 E.00343
G1 X183.894 Y199.96 E.01655
G1 X183.437 Y200.275 E.01657
G2 X182.506 Y201.719 I1.937 J2.27 E.05197
G1 X181.974 Y202.25 E.02244
G1 X181.974 Y202.785 E.01594
G1 X182.407 Y202.352 E.01824
G1 X182.423 Y202.87 E.01546
G1 X181.974 Y203.319 E.01892
G1 X181.974 Y203.853 E.01594
G1 X182.52 Y203.307 E.02302
G2 X182.668 Y203.693 I1.059 J-.186 E.01241
G1 X181.974 Y204.387 E.02929
G1 X181.974 Y204.921 E.01594
G1 X182.854 Y204.042 E.03711
G1 X183.072 Y204.358 E.01146
G1 X181.974 Y205.456 E.04632
G1 X181.974 Y205.99 E.01594
G1 X183.334 Y204.63 E.05736
G2 X183.63 Y204.869 I1.388 J-1.422 E.01135
G1 X181.974 Y206.524 E.06985
G1 X181.974 Y207.058 E.01594
G1 X183.96 Y205.072 E.08379
G1 X184.34 Y205.227 E.01223
G1 X181.974 Y207.592 E.09982
G1 X181.974 Y208.127 E.01594
G1 X184.753 Y205.348 E.11726
G2 X185.244 Y205.391 I.474 J-2.555 E.01472
G1 X182.384 Y208.251 E.12066
G1 X182.919 Y208.251 E.01594
G1 X185.827 Y205.342 E.12273
G1 X186.196 Y205.261 E.01126
G1 X186.633 Y205.071 E.01423
G1 X183.453 Y208.251 E.13419
G1 X183.987 Y208.251 E.01594
G1 X188.02 Y204.218 E.17018
G1 X188.151 Y204.152 E.00437
G1 X188.151 Y204.621 E.01401
G1 X184.521 Y208.251 E.15315
G1 X185.055 Y208.251 E.01594
G1 X188.151 Y205.155 E.13061
G1 X188.151 Y205.69 E.01594
G1 X185.59 Y208.251 E.10807
G1 X186.124 Y208.251 E.01594
G1 X188.151 Y206.224 E.08553
G1 X188.151 Y206.758 E.01594
G1 X186.658 Y208.251 E.06299
G1 X187.192 Y208.251 E.01594
G1 X188.151 Y207.292 E.04045
G1 X188.151 Y207.826 E.01594
G1 X187.557 Y208.42 E.02506
; COOLING_NODE: 13
; WIPE_START
G1 X188.151 Y207.826 E-.3192
G1 X188.151 Y207.292 E-.20299
G1 X187.708 Y207.735 E-.23781
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X185.928 Y200.313 Z2 F60000
G1 X166.884 Y120.9 Z2
G1 Z1.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X166.884 Y121.274 E.01202
G1 X160.916 Y121.274 E.1919
G1 X160.916 Y111.416 E.31698
G1 X166.884 Y111.416 E.1919
G1 X166.884 Y116.237 E.15501
G1 X166.66 Y116.255 E.00723
G2 X166.57 Y117.204 I-2.556 J.236 E.48775
G2 X166.654 Y116.739 I-2.169 J-.637 E.01522
G1 X166.884 Y116.754 E.00739
G1 X166.884 Y120.84 E.13141
; COOLING_NODE: 13
; WIPE_START
G1 X166.884 Y121.274 E-.16484
G1 X165.318 Y121.274 E-.59516
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X164.976 Y114.532 Z2 F60000
G1 Z1.6
G1 E.8 F1800
G1 F8843.478
M204 S8000
G1 X165.273 Y114.687 E.01078
G3 X163.871 Y114.352 I-1.175 J1.811 E.38893
G1 X164.074 Y114.34 E.00654
G3 X164.906 Y114.496 I.025 J2.159 E.0274
G1 X164.923 Y114.505 E.0006
; COOLING_NODE: 13
M204 S10000
G1 X164.79 Y114.892 F60000
G1 F8843.478
M204 S8000
G1 X165.053 Y115.03 E.00954
G3 X163.915 Y114.757 I-.954 J1.469 E.31556
G1 X164.078 Y114.747 E.00526
G3 X164.735 Y114.867 I.021 J1.752 E.0216
; COOLING_NODE: 13
M204 S250
G1 X164.61 Y115.239 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X164.84 Y115.359 E.00774
G3 X163.957 Y115.147 I-.741 J1.14 E.22684
G1 X164.083 Y115.14 E.00374
G3 X164.554 Y115.218 I.017 J1.359 E.01429
; COOLING_NODE: 13
; WIPE_START
M204 S8000
G1 X164.84 Y115.359 E-.12132
G1 X165.045 Y115.522 E-.09946
G1 X165.215 Y115.72 E-.09916
G1 X165.345 Y115.953 E-.10131
G1 X165.43 Y116.216 E-.10532
G1 X165.46 Y116.475 E-.09891
G1 X165.44 Y116.736 E-.09965
G1 X165.415 Y116.825 E-.03487
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X167.291 Y120.9 Z2 F60000
G1 Z1.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X167.291 Y121.681 E.02511
G1 X160.509 Y121.681 E.21808
G1 X160.509 Y111.009 E.34316
G1 X167.291 Y111.009 E.21808
G1 X167.291 Y120.84 E.31613
; COOLING_NODE: 13
M204 S10000
G1 X167.698 Y120.9 F60000
G1 F8843.478
M204 S8000
G1 X167.698 Y121.292 E.01261
G1 X168.098 Y121.292 E.01286
G1 X168.098 Y122.088 E.02559
G1 X160.102 Y122.088 E.25712
G1 X160.102 Y110.602 E.36934
G1 X167.698 Y110.602 E.24426
G1 X167.698 Y120.84 E.32921
; COOLING_NODE: 12
M204 S250
G1 X168.09 Y120.9 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1771
M204 S5000
G1 X168.49 Y120.9 E.01191
G1 X168.49 Y122.48 E.04706
G1 X159.71 Y122.48 E.26153
G1 X159.71 Y110.21 E.36548
G1 X168.09 Y110.21 E.24961
G1 X168.09 Y120.84 E.31663
; WIPE_START
G1 F9547.055
M204 S8000
G1 X168.49 Y120.9 E-.1537
G1 X168.49 Y122.48 E-.60041
G1 X168.474 Y122.48 E-.00589
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X166.499 Y117.93 Z2 F60000
G1 Z1.6
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.122358
G1 F15000
M204 S8000
G1 X166.68 Y117.666 E.00201
; WIPE_START
G1 X166.499 Y117.93 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X166.784 Y116.496 Z2 F60000
G1 Z1.6
G1 E.8 F1800
; LINE_WIDTH: 0.152592
G1 F15000
M204 S8000
G1 X167.087 Y116.493 E.00263
M204 S10000
G1 X166.784 Y116.496 F60000
; LINE_WIDTH: 0.115477
G1 F15000
M204 S8000
G1 X166.48 Y116.5 E.00174
; WIPE_START
G1 X166.784 Y116.496 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X166.68 Y115.312 Z2 F60000
G1 Z1.6
G1 E.8 F1800
; LINE_WIDTH: 0.13862
G1 F15000
M204 S8000
G1 X166.555 Y115.131 E.00167
; LINE_WIDTH: 0.108967
G1 X166.462 Y115.01 E.0008
; WIPE_START
G1 X166.555 Y115.131 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X165.712 Y113.137 Z2 F60000
G1 Z1.6
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.47146
G1 F8400.616
M204 S8000
G1 X165.712 Y112.588 E.01856
; LINE_WIDTH: 0.451308
G1 F8815.157
G1 X165.326 Y112.568 E.01247
; LINE_WIDTH: 0.411003
G1 F9780.415
G1 X164.94 Y112.548 E.01124
; LINE_WIDTH: 0.359915
G1 F11356.654
G2 X163.8 Y112.528 I-.836 J15.009 E.02855
; LINE_WIDTH: 0.375085
G1 F10837.986
G1 X163.183 Y112.552 E.01621
; LINE_WIDTH: 0.42008
G1 F9545.02
G1 X162.919 Y112.573 E.00789
; LINE_WIDTH: 0.46098
G1 F8611.204
G1 X162.655 Y112.593 E.00875
; LINE_WIDTH: 0.496113
G1 F7943.644
G1 X162.389 Y112.608 E.00954
; LINE_WIDTH: 0.53311
G1 F7344.098
G1 X162.122 Y112.622 E.01032
G1 X162.122 Y113.294 E.026
G1 X162.581 Y113.059 E.01995
; LINE_WIDTH: 0.496255
G1 F7941.147
G1 X162.8 Y113.006 E.00805
; LINE_WIDTH: 0.457605
G1 F8681.288
G1 X163.018 Y112.953 E.00736
; LINE_WIDTH: 0.418955
G1 F9573.577
G1 X163.237 Y112.901 E.00668
; LINE_WIDTH: 0.375085
G1 F10837.986
G1 X163.802 Y112.835 E.01492
; LINE_WIDTH: 0.359685
G1 F11364.905
G3 X164.891 Y112.889 I.3 J5.02 E.02734
; LINE_WIDTH: 0.409848
G1 F9811.202
G1 X165.149 Y112.945 E.00766
; LINE_WIDTH: 0.458683
G1 F8658.782
G3 X165.657 Y113.112 I-.151 J1.314 E.01769
M204 S10000
G1 X166.115 Y113.855 F60000
; LINE_WIDTH: 0.41999
G1 F9547.299
M204 S8000
G1 X166.115 Y112.185 E.04973
G1 X161.685 Y112.185 E.13193
G1 X161.685 Y114.218 E.06054
G1 X161.997 Y113.911 E.01303
G3 X165.294 Y113.385 I2.113 J2.649 E.10398
G1 X165.862 Y113.668 E.01889
G1 X166.066 Y113.819 E.00759
M204 S10000
G1 X166.35 Y114.601 F60000
G1 F9547.299
M204 S8000
G1 X166.438 Y114.534 E.00327
G1 X166.492 Y114.543 E.00164
G1 X166.492 Y111.808 E.08147
G1 X161.308 Y111.808 E.15439
G1 X161.308 Y114.811 E.08945
G1 X161.633 Y114.879 E.00988
G1 X161.78 Y114.663 E.00777
G1 X162.182 Y114.246 E.01727
G1 X162.646 Y113.922 E.01686
G3 X165.688 Y114.003 I1.451 J2.664 E.09494
G1 X166.144 Y114.359 E.01724
G1 X166.311 Y114.555 E.00767
; WIPE_START
G1 X166.144 Y114.359 E-.09791
G1 X165.688 Y114.003 E-.21994
G1 X165.192 Y113.748 E-.21184
G1 X164.682 Y113.598 E-.20207
G1 X164.608 Y113.588 E-.02824
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X161.367 Y115.224 Z2 F60000
G1 Z1.6
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.451712
G1 F8806.446
M204 S8000
G1 X161.32 Y115.448 E.0074
; LINE_WIDTH: 0.422527
G1 F9483.497
G1 X161.299 Y115.584 E.0041
; LINE_WIDTH: 0.377157
G1 F10770.802
G1 X161.275 Y115.733 E.00401
; LINE_WIDTH: 0.339457
G1 F12140.148
G1 X161.261 Y115.864 E.00308
; LINE_WIDTH: 0.309115
G1 F13523.956
G1 X161.245 Y116.007 E.00303
; LINE_WIDTH: 0.264919
G1 F15000
G1 X161.224 Y116.553 E.00958
G1 X161.235 Y116.85 E.0052
; LINE_WIDTH: 0.295315
G1 F14263.382
G1 X161.257 Y117.118 E.00537
; LINE_WIDTH: 0.336725
G1 F12253.034
G1 X161.276 Y117.259 E.00329
; LINE_WIDTH: 0.376099
G1 F10805.007
G1 X161.297 Y117.417 E.00421
; LINE_WIDTH: 0.412018
G1 F9753.529
G1 X161.33 Y117.596 E.0053
; LINE_WIDTH: 0.440393
G1 F9057.232
G1 X161.363 Y117.775 E.0057
; WIPE_START
G1 X161.33 Y117.596 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X163.429 Y120.14 Z2 F60000
G1 Z1.6
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.38032
G1 F10669.828
M204 S8000
G1 X163.758 Y120.155 E.00878
; LINE_WIDTH: 0.362445
G1 F11266.736
G2 X164.781 Y120.138 I.418 J-5.594 E.02585
; WIPE_START
G1 X164.087 Y120.17 E-.51557
G1 X163.758 Y120.155 E-.24443
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X163.429 Y120.14 Z2 F60000
G1 Z1.6
G1 E.8 F1800
; LINE_WIDTH: 0.419051
G1 F9571.155
M204 S8000
G3 X162.063 Y119.603 I.698 J-3.783 E.04387
G1 X162.063 Y120.127 E.01555
G3 X163.369 Y120.138 I.481 J19.581 E.03881
; WIPE_START
G1 X162.063 Y120.127 E-.49623
G1 X162.063 Y119.603 E-.19884
M73 P73 R5
G1 X162.213 Y119.686 E-.06494
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X165.772 Y120.162 Z2 F60000
G1 Z1.6
G1 E.8 F1800
; LINE_WIDTH: 0.352243
G1 F11638.323
M204 S8000
G1 X165.772 Y119.772 E.00953
G1 X165.197 Y120.014 E.01524
; LINE_WIDTH: 0.36779
G1 F11081.355
G1 X165.019 Y120.074 E.00483
; LINE_WIDTH: 0.383703
G1 F10563.906
G1 X164.841 Y120.133 E.00506
G1 X165.366 Y120.162 E.01416
; LINE_WIDTH: 0.35132
G1 F11673.151
G1 X165.712 Y120.162 E.00843
M204 S10000
G1 X166.115 Y120.505 F60000
; LINE_WIDTH: 0.41999
G1 F9547.299
M204 S8000
G1 X166.115 Y119.15 E.04036
G3 X164.221 Y119.834 I-2.012 J-2.607 E.06095
G1 X163.587 Y119.796 E.0189
G3 X162.283 Y119.296 I.699 J-3.78 E.04185
G1 X161.828 Y118.941 E.01719
G1 X161.685 Y118.786 E.00626
G1 X161.685 Y120.505 E.05118
G1 X166.055 Y120.505 E.13014
M204 S10000
G1 X166.492 Y120.882 F60000
G1 F9547.299
M204 S8000
G1 X166.492 Y118.397 E.07402
G1 X166.408 Y118.353 E.0028
G1 X166.023 Y118.751 E.01649
G1 X165.557 Y119.077 E.01693
G1 X165.037 Y119.308 E.01695
G3 X163.616 Y119.42 I-.973 J-3.275 E.04276
G3 X162.515 Y118.999 I.735 J-3.578 E.03527
G1 X162.06 Y118.644 E.01719
G3 X161.643 Y118.122 I24.826 J-20.269 E.01991
G1 X161.308 Y118.183 E.01013
G1 X161.308 Y120.882 E.08037
G1 X166.432 Y120.882 E.15261
; CHANGE_LAYER
; Z_HEIGHT: 1.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9547.299
G1 X164.432 Y120.882 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 14/37
; update layer progress
M73 L14
M991 S0 P13 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z2 I-.899 J.82 P1  F60000
G1 X188.525 Y147.313 Z2
G1 Z1.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X188.917 Y147.313 E.01261
G1 X188.917 Y181.697 E1.10567
G1 X182.473 Y181.697 E.20722
G1 X182.473 Y147.313 E1.10567
G1 X188.465 Y147.313 E.19268
; COOLING_NODE: 0
M204 S250
G1 X188.525 Y147.705 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X188.525 Y181.305 E1.00083
G1 X182.865 Y181.305 E.16859
G1 X182.865 Y147.705 E1.00083
G1 X188.465 Y147.705 E.1668
; COOLING_NODE: 0
; WIPE_START
M204 S8000
G1 X188.469 Y149.705 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X181.081 Y151.625 Z2.2 F60000
G1 X167.23 Y155.224 Z2.2
G1 Z1.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X166.431 Y155.224 E.0257
G1 X166.431 Y150.766 E.14336
G1 X175.969 Y150.766 E.30672
G1 X175.969 Y155.224 E.14336
G1 X167.29 Y155.224 E.27909
; COOLING_NODE: 0
M204 S10000
G1 X167.23 Y154.817 F60000
G1 F8843.478
M204 S8000
G1 X166.838 Y154.817 E.01261
G1 X166.838 Y151.173 E.11718
G1 X175.562 Y151.173 E.28054
G1 X175.562 Y154.817 E.11718
G1 X167.29 Y154.817 E.266
; COOLING_NODE: 1
M204 S250
G1 X167.23 Y154.425 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X167.23 Y151.565 E.08519
G1 X175.17 Y151.565 E.23651
G1 X175.17 Y154.425 E.08519
G1 X167.29 Y154.425 E.23472
; COOLING_NODE: 1
; WIPE_START
M204 S8000
G1 X167.248 Y152.425 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X166.194 Y144.866 Z2.2 F60000
G1 X166.059 Y143.9 Z2.2
G1 Z1.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X166.059 Y152.899 E.28938
G1 X161.341 Y152.899 E.15172
G1 X161.341 Y143.101 E.31508
G1 X166.059 Y143.101 E.15172
G1 X166.059 Y143.84 E.02377
; COOLING_NODE: 1
M204 S10000
G1 X165.652 Y143.9 F60000
G1 F8843.478
M204 S8000
G1 X165.652 Y152.492 E.27629
G1 X161.748 Y152.492 E.12554
G1 X161.748 Y143.508 E.2889
G1 X165.652 Y143.508 E.12554
G1 X165.652 Y143.84 E.01068
; COOLING_NODE: 2
M204 S250
G1 X165.26 Y143.9 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X165.26 Y152.1 E.24425
G1 X162.14 Y152.1 E.09293
G1 X162.14 Y143.9 E.24425
G1 X165.2 Y143.9 E.09115
; COOLING_NODE: 2
; WIPE_START
M204 S8000
G1 X165.215 Y145.9 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X161.834 Y142.694 Z2.2 F60000
G1 Z1.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X160.916 Y142.694 E.02951
G1 X160.916 Y132.926 E.31409
G1 X161.834 Y132.926 E.02951
G1 X161.834 Y142.634 E.31216
; COOLING_NODE: 2
; WIPE_START
G1 X160.916 Y142.694 E-.34943
G1 X160.916 Y141.613 E-.41057
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X168.548 Y141.661 Z2.2 F60000
G1 X176.291 Y141.71 Z2.2
G1 Z1.8
G1 E.8 F1800
G1 F8843.478
M204 S8000
G1 X176.291 Y137.541 E.13406
G1 X188.509 Y137.541 E.3929
G1 X188.509 Y142.509 E.15976
G1 X176.291 Y142.509 E.3929
G1 X176.291 Y141.77 E.02377
; COOLING_NODE: 2
M204 S10000
G1 X176.698 Y141.71 F60000
G1 F8843.478
M204 S8000
G1 X176.698 Y137.948 E.12097
G1 X188.102 Y137.948 E.36672
G1 X188.102 Y142.102 E.13358
G1 X176.698 Y142.102 E.36672
G1 X176.698 Y141.77 E.01068
; COOLING_NODE: 3
M204 S250
G1 X177.09 Y141.71 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X177.09 Y138.34 E.10038
G1 X187.71 Y138.34 E.31633
G1 X187.71 Y141.71 E.10038
G1 X177.15 Y141.71 E.31455
; COOLING_NODE: 3
; WIPE_START
M204 S8000
G1 X177.114 Y139.71 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X176 Y147.261 Z2.2 F60000
G1 X174.709 Y156.009 Z2.2
G1 Z1.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X181.191 Y156.009 E.20845
G1 X181.191 Y160.991 E.16022
G1 X174.709 Y160.991 E.20845
G1 X174.709 Y156.069 E.15829
; COOLING_NODE: 3
; WIPE_START
G1 X176.709 Y156.05 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X180.784 Y159.785 Z2.2 F60000
G1 Z1.8
G1 E.8 F1800
G1 F8843.478
M204 S8000
G1 X180.784 Y160.584 E.0257
G1 X175.116 Y160.584 E.18227
G1 X175.116 Y156.416 E.13404
G1 X180.784 Y156.416 E.18227
G1 X180.784 Y159.725 E.10641
; COOLING_NODE: 3
M204 S10000
G1 X180.377 Y159.785 F60000
G1 F8843.478
M204 S8000
G1 X180.377 Y160.177 E.01261
G1 X175.523 Y160.177 E.15609
G1 X175.523 Y156.823 E.10786
G1 X180.377 Y156.823 E.15609
G1 X180.377 Y159.725 E.09332
; COOLING_NODE: 4
M204 S250
G1 X179.985 Y159.785 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X175.915 Y159.785 E.12123
G1 X175.915 Y157.215 E.07655
G1 X179.985 Y157.215 E.12123
G1 X179.985 Y159.725 E.07476
; COOLING_NODE: 4
; WIPE_START
M204 S8000
G1 X177.985 Y159.754 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X179.03 Y167.315 Z2.2 F60000
G1 X183.622 Y200.559 Z2.2
G1 Z1.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X183.672 Y200.512 E.0022
G3 X185.029 Y199.946 I1.625 J1.986 E.04796
G1 X185.285 Y199.932 E.00825
G3 X183.482 Y200.684 I.012 J2.566 E.45409
G1 X183.578 Y200.599 E.0041
; COOLING_NODE: 4
M204 S10000
G1 X183.867 Y200.893 F60000
G1 F8843.478
M204 S8000
G1 X183.931 Y200.828 E.00293
G3 X185.072 Y200.352 I1.367 J1.671 E.04034
G1 X185.288 Y200.34 E.00695
G3 X183.623 Y201.136 I.01 J2.159 E.37493
G1 X183.825 Y200.935 E.00913
; COOLING_NODE: 4
M204 S10000
G1 X184.154 Y201.179 F60000
G1 F8843.478
M204 S8000
G1 X184.19 Y201.143 E.00163
G3 X185.116 Y200.757 I1.109 J1.356 E.03272
G1 X185.291 Y200.747 E.00565
G3 X183.939 Y201.394 I.008 J1.752 E.30416
G1 X184.112 Y201.222 E.00784
; COOLING_NODE: 5
M204 S250
G1 X184.431 Y201.455 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X184.439 Y201.447 E.00034
G3 X185.157 Y201.147 I.86 J1.053 E.02351
G1 X185.294 Y201.14 E.00407
G3 X184.244 Y201.643 I.006 J1.359 E.2186
G1 X184.389 Y201.498 E.00611
; COOLING_NODE: 5
; WIPE_START
M204 S8000
G1 X184.439 Y201.447 E-.02718
G1 X184.661 Y201.299 E-.10117
G1 X184.901 Y201.2 E-.09893
G1 X185.157 Y201.147 E-.09931
G1 X185.294 Y201.14 E-.05193
G1 X185.559 Y201.165 E-.10134
G1 X185.81 Y201.239 E-.09961
G1 X186.055 Y201.369 E-.10527
G1 X186.208 Y201.494 E-.07525
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X186.381 Y193.864 Z2.2 F60000
G1 X187.71 Y134.916 Z2.2
G1 Z1.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X188.484 Y134.916 E.02488
G1 X188.484 Y137.134 E.07131
G1 X175.884 Y137.134 E.40517
G1 X175.884 Y142.916 E.18594
G1 X188.484 Y142.916 E.40517
G1 X188.484 Y146.499 E.1152
G1 X181.659 Y146.499 E.21947
G1 X181.659 Y182.511 E1.15803
G1 X188.484 Y182.511 E.21947
G1 X188.484 Y208.584 E.8384
G1 X181.641 Y208.584 E.22003
G1 X181.641 Y192.784 E.50807
G1 X176.911 Y192.784 E.1521
G1 X176.911 Y186.889 E.18956
G1 X170.239 Y186.889 E.21456
G1 X170.239 Y192.784 E.18956
G1 X166.466 Y192.784 E.12131
G1 X166.466 Y177.459 E.4928
G1 X160.916 Y177.459 E.17847
G1 X160.916 Y168.566 E.28595
G1 X170.731 Y168.566 E.31561
G1 X170.731 Y159.234 E.3001
G1 X160.916 Y159.234 E.31561
G1 X160.916 Y153.306 E.19061
G1 X166.024 Y153.306 E.16424
G1 X166.024 Y155.631 E.07476
G1 X176.376 Y155.631 E.3329
G1 X176.376 Y150.359 E.16954
G1 X166.466 Y150.359 E.31867
G1 X166.466 Y142.806 E.24286
G1 X167.366 Y142.806 E.02894
G1 X167.366 Y132.926 E.3177
G1 X169.976 Y132.926 E.08393
G1 X169.976 Y128.916 E.12895
G1 X175.884 Y128.916 E.18997
G1 X175.884 Y134.916 E.19294
G1 X187.65 Y134.916 E.37836
; COOLING_NODE: 5
; WIPE_START
G1 X188.484 Y134.916 E-.31685
G1 X188.484 Y136.082 E-.44315
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X187.71 Y129.541 Z2.2 F60000
G1 Z1.8
G1 E.8 F1800
G1 F8843.478
M204 S8000
G1 X188.509 Y129.541 E.0257
G1 X188.509 Y134.509 E.15976
G1 X176.291 Y134.509 E.3929
G1 X176.291 Y129.541 E.15976
G1 X187.65 Y129.541 E.36527
; COOLING_NODE: 5
M204 S10000
G1 X187.71 Y129.948 F60000
G1 F8843.478
M204 S8000
G1 X188.102 Y129.948 E.01261
G1 X188.102 Y134.102 E.13358
G1 X176.698 Y134.102 E.36672
G1 X176.698 Y129.948 E.13358
G1 X187.65 Y129.948 E.35218
; COOLING_NODE: 6
M204 S250
G1 X187.71 Y130.34 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X187.71 Y133.71 E.10038
G1 X177.09 Y133.71 E.31633
G1 X177.09 Y130.34 E.10038
G1 X187.65 Y130.34 E.31455
; COOLING_NODE: 6
; WIPE_START
M204 S8000
G1 X187.686 Y132.34 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X184.295 Y139.178 Z2.2 F60000
G1 X170.324 Y167.36 Z2.2
G1 Z1.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X170.324 Y168.159 E.0257
G1 X161.065 Y168.159 E.29774
G1 X161.065 Y159.641 E.27392
G1 X170.324 Y159.641 E.29774
G1 X170.324 Y167.3 E.24629
; COOLING_NODE: 6
M204 S10000
G1 X169.917 Y167.36 F60000
G1 F8843.478
M204 S8000
G1 X169.917 Y167.752 E.01261
G1 X161.472 Y167.752 E.27156
G1 X161.472 Y160.048 E.24774
G1 X169.917 Y160.048 E.27156
G1 X169.917 Y167.3 E.2332
; COOLING_NODE: 7
M204 S250
G1 X169.525 Y167.36 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X161.864 Y167.36 E.22819
G1 X161.864 Y160.44 E.20612
G1 X169.525 Y160.44 E.22819
G1 X169.525 Y167.3 E.20434
; COOLING_NODE: 7
; WIPE_START
M204 S8000
G1 X167.525 Y167.316 E-.76
; WIPE_END
M73 P74 R5
G1 E-.04 F1800
M204 S10000
G1 X166.87 Y174.92 Z2.2 F60000
G1 X166.059 Y184.325 Z2.2
G1 Z1.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X166.059 Y185.124 E.0257
G1 X161.341 Y185.124 E.15172
G1 X161.341 Y177.866 E.2334
G1 X166.059 Y177.866 E.15172
G1 X166.059 Y184.265 E.20577
; COOLING_NODE: 7
M204 S10000
G1 X165.652 Y184.325 F60000
G1 F8843.478
M204 S8000
G1 X165.652 Y184.717 E.01261
G1 X161.748 Y184.717 E.12554
G1 X161.748 Y178.273 E.20722
G1 X165.652 Y178.273 E.12554
G1 X165.652 Y184.265 E.19268
; COOLING_NODE: 8
M204 S250
G1 X165.26 Y184.325 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X162.14 Y184.325 E.09293
G1 X162.14 Y178.665 E.16859
G1 X165.26 Y178.665 E.09293
G1 X165.26 Y184.265 E.1668
; COOLING_NODE: 8
; WIPE_START
M204 S8000
G1 X163.26 Y184.303 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X167.533 Y177.979 Z2.2 F60000
G1 X188.525 Y146.906 Z2.2
G1 Z1.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X182.066 Y146.906 E.2077
G1 X182.066 Y182.104 E1.13185
G1 X188.891 Y182.104 E.21947
G1 X188.891 Y208.991 E.86458
G1 X181.234 Y208.991 E.24621
G1 X181.234 Y193.191 E.50807
G1 X176.504 Y193.191 E.1521
G1 X176.504 Y187.296 E.18956
G1 X170.646 Y187.296 E.18838
G1 X170.646 Y193.191 E.18956
G1 X166.059 Y193.191 E.14749
G1 X166.059 Y185.866 E.23555
G1 X161.341 Y185.866 E.15172
G1 X161.341 Y193.191 E.23555
G1 X160.509 Y193.191 E.02675
G1 X160.509 Y132.519 E1.95098
G1 X162.241 Y132.519 E.05569
G1 X162.241 Y142.399 E.3177
G1 X166.959 Y142.399 E.15172
G1 X166.959 Y132.519 E.3177
G1 X169.569 Y132.519 E.08393
G1 X169.569 Y128.509 E.12895
G1 X188.891 Y128.509 E.62132
G1 X188.891 Y146.906 E.59157
G1 X188.585 Y146.906 E.00984
; COOLING_NODE: 8
; WIPE_START
G1 X186.585 Y146.906 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X179.164 Y145.121 Z2.2 F60000
G1 X166.16 Y141.992 Z2.2
G1 Z1.8
G1 E.8 F1800
G1 F8843.478
M204 S8000
G1 X162.648 Y141.992 E.11294
G1 X162.648 Y133.008 E.2889
G1 X166.552 Y133.008 E.12554
G1 X166.552 Y141.992 E.2889
G1 X166.22 Y141.992 E.01068
; COOLING_NODE: 9
M204 S250
G1 X166.16 Y141.6 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X163.04 Y141.6 E.09293
G1 X163.04 Y133.4 E.24425
G1 X166.16 Y133.4 E.09293
G1 X166.16 Y141.54 E.24246
; COOLING_NODE: 9
; WIPE_START
M204 S8000
G1 X164.16 Y141.578 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X163.798 Y149.202 Z2.2 F60000
G1 X161.748 Y192.325 Z2.2
G1 Z1.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X161.748 Y186.273 E.19461
G1 X165.652 Y186.273 E.12554
G1 X165.652 Y192.717 E.20722
G1 X161.748 Y192.717 E.12554
G1 X161.748 Y192.385 E.01068
; COOLING_NODE: 10
M204 S250
G1 X162.14 Y192.325 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X162.14 Y186.665 E.16859
G1 X165.26 Y186.665 E.09293
G1 X165.26 Y192.325 E.16859
G1 X162.2 Y192.325 E.09115
; COOLING_NODE: 10
; WIPE_START
M204 S8000
G1 X162.179 Y190.325 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X169.672 Y188.873 Z2.2 F60000
G1 X175.705 Y187.703 Z2.2
G1 Z1.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X176.097 Y187.703 E.01261
G1 X176.097 Y192.697 E.16059
G1 X171.053 Y192.697 E.1622
G1 X171.053 Y187.703 E.16059
G1 X175.645 Y187.703 E.14766
; COOLING_NODE: 11
M204 S250
G1 X175.705 Y188.095 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X175.705 Y192.305 E.1254
G1 X171.445 Y192.305 E.12689
G1 X171.445 Y188.095 E.1254
G1 X175.645 Y188.095 E.1251
; COOLING_NODE: 11
; WIPE_START
M204 S8000
G1 X175.673 Y190.095 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X174.822 Y182.51 Z2.2 F60000
G1 X169.162 Y132.112 Z2.2
G1 Z1.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X169.162 Y128.102 E.12895
G1 X189.298 Y128.102 E.6475
G1 X189.298 Y146.502 E.59168
G1 X189.898 Y146.502 E.01929
G1 X189.898 Y182.498 E1.1575
G1 X189.298 Y182.498 E.01929
G1 X189.298 Y209.398 E.86501
G1 X180.827 Y209.398 E.27239
G1 X180.827 Y193.598 E.50807
G1 X160.102 Y193.598 E.66644
G1 X160.102 Y132.112 E1.97716
G1 X169.102 Y132.112 E.28941
; COOLING_NODE: 12
M204 S250
G1 X168.77 Y131.72 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1623
M204 S5000
G1 X168.77 Y127.71 E.11944
G1 X189.69 Y127.71 E.62314
G1 X189.69 Y146.11 E.54807
G1 X190.29 Y146.11 E.01787
G1 X190.29 Y182.89 E1.09555
G1 X189.69 Y182.89 E.01787
G1 X189.69 Y209.79 E.80126
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

G1 X180.435 Y209.79 E.27568
G1 X180.435 Y193.99 E.47063
G1 X159.71 Y193.99 E.61733
G1 X159.71 Y131.72 E1.85481
G1 X168.71 Y131.72 E.26808
; WIPE_START
M73 P75 R5
G1 F9547.055
M204 S8000
G1 X168.74 Y129.72 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X166.755 Y132.56 Z2.2 F60000
G1 Z1.8
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.53172
G1 F7364.976
M204 S8000
G1 X162.444 Y132.56 E.16645
; WIPE_START
G1 X164.444 Y132.56 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X161.375 Y133.13 Z2.2 F60000
G1 Z1.8
G1 E.8 F1800
; LINE_WIDTH: 0.55344
G1 F7051.634
M204 S8000
G1 X161.375 Y142.49 E.37749
M204 S10000
G1 X160.925 Y142.897 F60000
; LINE_WIDTH: 0.46758
G1 F8477.369
M204 S8000
G1 X160.925 Y153.103 E.34233
; WIPE_START
G1 X160.925 Y151.103 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X161.933 Y143.537 Z2.2 F60000
G1 X162.037 Y142.75 Z2.2
G1 Z1.8
G1 E.8 F1800
; LINE_WIDTH: 0.33758
G1 F12217.47
M204 S8000
G1 X166.263 Y142.75 E.09834
; WIPE_START
G1 X164.263 Y142.75 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X167.449 Y135.814 Z2.2 F60000
G1 X170.14 Y129.957 Z2.2
G1 Z1.8
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42088
G1 F9524.817
M204 S8000
G1 X176.983 Y136.801 E.28896
G1 X176.449 Y136.801 E.01596
G1 X170.309 Y130.661 E.25922
G1 X170.309 Y131.196 E.01596
G1 X175.914 Y136.801 E.23665
G1 X175.551 Y136.801 E.01086
G1 X175.551 Y136.972 E.0051
G1 X170.309 Y131.73 E.2213
G1 X170.309 Y132.265 E.01596
G1 X175.551 Y137.506 E.2213
G1 X175.551 Y138.041 E.01596
G1 X170.309 Y132.799 E.2213
G1 X170.309 Y133.259 E.01374
G1 X170.235 Y133.259 E.00222
G1 X175.551 Y138.575 E.22445
G1 X175.551 Y139.11 E.01596
G1 X169.7 Y133.259 E.24702
G1 X169.166 Y133.259 E.01596
G1 X175.551 Y139.644 E.26958
G1 X175.551 Y140.179 E.01596
G1 X168.631 Y133.259 E.29215
G1 X168.097 Y133.259 E.01596
G1 X175.551 Y140.713 E.31472
G1 X175.551 Y141.248 E.01596
G1 X167.699 Y133.396 E.3315
G1 X167.699 Y133.931 E.01596
G1 X175.551 Y141.782 E.3315
G1 X175.551 Y142.317 E.01596
G1 X167.699 Y134.465 E.3315
G1 X167.699 Y135 E.01596
G1 X175.551 Y142.851 E.3315
G1 X175.551 Y143.249 E.01189
G1 X175.949 Y143.249 E.01189
G1 X181.326 Y148.626 E.22703
G1 X181.326 Y148.092 E.01596
G1 X176.483 Y143.249 E.20446
G1 X177.018 Y143.249 E.01596
G1 X181.326 Y147.557 E.18189
G1 X181.326 Y147.023 E.01596
G1 X177.552 Y143.249 E.15932
G1 X178.087 Y143.249 E.01596
G1 X181.326 Y146.488 E.13675
G1 X181.326 Y146.166 E.00963
G1 X181.538 Y146.166 E.00633
G1 X178.621 Y143.249 E.12313
G1 X179.156 Y143.249 E.01596
G1 X182.072 Y146.166 E.12313
G1 X182.607 Y146.166 E.01596
G1 X179.69 Y143.249 E.12313
G1 X180.225 Y143.249 E.01596
G1 X183.141 Y146.166 E.12313
G1 X183.676 Y146.166 E.01596
G1 X180.759 Y143.249 E.12313
G1 X181.294 Y143.249 E.01596
G1 X184.21 Y146.166 E.12313
G1 X184.745 Y146.166 E.01596
G1 X181.828 Y143.249 E.12313
G1 X182.363 Y143.249 E.01596
G1 X185.279 Y146.166 E.12313
G1 X185.814 Y146.166 E.01596
G1 X182.897 Y143.249 E.12313
G1 X183.432 Y143.249 E.01596
G1 X186.348 Y146.166 E.12313
G1 X186.883 Y146.166 E.01596
G1 X183.966 Y143.249 E.12313
G1 X184.501 Y143.249 E.01596
G1 X187.417 Y146.166 E.12313
G1 X187.952 Y146.166 E.01596
G1 X185.036 Y143.249 E.12313
G1 X185.57 Y143.249 E.01596
G1 X188.151 Y145.83 E.10896
G1 X188.151 Y145.295 E.01596
G1 X186.105 Y143.249 E.08639
G1 X186.639 Y143.249 E.01596
G1 X188.151 Y144.761 E.06382
G1 X188.151 Y144.226 E.01596
G1 X187.174 Y143.249 E.04125
G1 X187.708 Y143.249 E.01596
G1 X188.32 Y143.862 E.02585
; WIPE_START
G1 X187.708 Y143.249 E-.32901
G1 X187.174 Y143.249 E-.20312
G1 X187.598 Y143.673 E-.22788
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X189.095 Y147.093 Z2.2 F60000
G1 Z1.8
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.118631
G1 F15000
M204 S8000
G1 X189.12 Y147.083 E.00016
; LINE_WIDTH: 0.165653
G1 X189.146 Y147.074 E.00027
; LINE_WIDTH: 0.212674
G1 X189.172 Y147.065 E.00037
; LINE_WIDTH: 0.259695
G1 X189.198 Y147.055 E.00047
; LINE_WIDTH: 0.306717
G1 F13646.879
G1 X189.224 Y147.046 E.00057
; LINE_WIDTH: 0.353738
G1 F11582.34
G1 X189.25 Y147.037 E.00068
; LINE_WIDTH: 0.40076
G1 F10060.376
G1 X189.276 Y147.028 E.00078
; LINE_WIDTH: 0.447781
G1 F8891.942
G1 X189.302 Y147.018 E.00088
; LINE_WIDTH: 0.494803
G1 F7966.675
G1 X189.327 Y147.009 E.00098
; LINE_WIDTH: 0.541824
G1 F7215.819
G1 X189.353 Y147 E.00108
; LINE_WIDTH: 0.588846
G1 F6594.309
G1 X189.379 Y146.99 E.00119
; LINE_WIDTH: 0.616778
G1 F6273.336
G1 X189.398 Y147.002 E.001
G1 X189.408 Y147.109 E.00487
G1 X189.408 Y181.901 E1.57711
G1 X189.399 Y181.999 E.00448
G1 X189.371 Y182.018 E.00153
; LINE_WIDTH: 0.573214
G1 F6788.692
G1 X189.346 Y182.009 E.00112
; LINE_WIDTH: 0.527681
G1 F7426.342
G1 X189.321 Y182 E.00102
; LINE_WIDTH: 0.482149
G1 F8196.196
G1 X189.296 Y181.99 E.00093
; LINE_WIDTH: 0.436616
G1 F9144.123
G1 X189.27 Y181.981 E.00083
; LINE_WIDTH: 0.391083
G1 F10339.991
G1 X189.245 Y181.972 E.00074
; LINE_WIDTH: 0.34555
G1 F11895.715
G1 X189.22 Y181.963 E.00064
; LINE_WIDTH: 0.300018
G1 F14002.483
G1 X189.195 Y181.954 E.00054
; LINE_WIDTH: 0.254485
G1 F15000
G1 X189.17 Y181.945 E.00045
; LINE_WIDTH: 0.208952
G1 X189.145 Y181.936 E.00035
; LINE_WIDTH: 0.163419
G1 X189.12 Y181.926 E.00025
; LINE_WIDTH: 0.117887
G1 X189.095 Y181.917 E.00016
; WIPE_START
G1 X189.12 Y181.926 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X187.509 Y182.675 Z2.2 F60000
G1 Z1.8
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42352
G1 F9458.749
M204 S8000
G1 X188.151 Y183.316 E.02726
G1 X188.151 Y183.854 E.01618
G1 X187.141 Y182.844 E.04294
G1 X186.603 Y182.844 E.01618
G1 X188.151 Y184.392 E.06582
G1 X188.151 Y184.931 E.01618
G1 X186.064 Y182.844 E.08871
G1 X185.526 Y182.844 E.01618
G1 X188.151 Y185.469 E.11159
G1 X188.151 Y186.007 E.01618
G1 X184.988 Y182.844 E.13448
G1 X184.45 Y182.844 E.01618
G1 X188.151 Y186.545 E.15736
G1 X188.151 Y187.084 E.01618
G1 X183.911 Y182.844 E.18025
G1 X183.373 Y182.844 E.01618
G1 X188.151 Y187.622 E.20313
G1 X188.151 Y188.16 E.01618
G1 X182.835 Y182.844 E.22602
G1 X182.297 Y182.844 E.01618
G1 X188.151 Y188.698 E.2489
G1 X188.151 Y189.237 E.01618
G1 X181.758 Y182.844 E.27179
G1 X181.326 Y182.844 E.01301
G1 X181.326 Y182.412 E.01301
G1 X167.813 Y168.899 E.57451
G1 X168.352 Y168.899 E.01618
G1 X181.326 Y181.873 E.55163
G1 X181.326 Y181.335 E.01618
G1 X168.89 Y168.899 E.52874
G1 X169.428 Y168.899 E.01618
G1 X181.326 Y180.797 E.50586
G1 X181.326 Y180.259 E.01618
G1 X169.966 Y168.899 E.48297
G1 X170.505 Y168.899 E.01618
G1 X181.326 Y179.72 E.46009
G1 X181.326 Y179.182 E.01618
G1 X171.043 Y168.899 E.4372
G1 X171.064 Y168.899 E.00065
G1 X171.064 Y168.383 E.01554
G1 X181.326 Y178.644 E.43629
G1 X181.326 Y178.106 E.01618
G1 X171.064 Y167.844 E.43629
G1 X171.064 Y167.306 E.01618
G1 X181.326 Y177.567 E.43629
G1 X181.326 Y177.029 E.01618
G1 X171.064 Y166.768 E.43629
G1 X171.064 Y166.23 E.01618
G1 X181.326 Y176.491 E.43629
G1 X181.326 Y175.953 E.01618
G1 X171.064 Y165.691 E.43629
G1 X171.064 Y165.153 E.01618
G1 X181.326 Y175.414 E.43629
G1 X181.326 Y174.876 E.01618
G1 X171.064 Y164.615 E.43629
G1 X171.064 Y164.077 E.01618
G1 X181.326 Y174.338 E.43629
G1 X181.326 Y173.8 E.01618
G1 X171.064 Y163.538 E.43629
G1 X171.064 Y163 E.01618
G1 X181.326 Y173.261 E.43629
G1 X181.326 Y172.723 E.01618
G1 X171.064 Y162.462 E.43629
G1 X171.064 Y161.924 E.01618
G1 X181.326 Y172.185 E.43629
G1 X181.326 Y171.647 E.01618
G1 X171.064 Y161.385 E.43629
G1 X171.064 Y160.847 E.01618
G1 X181.326 Y171.108 E.43629
G1 X181.326 Y170.57 E.01618
G1 X171.064 Y160.309 E.43629
G1 X171.064 Y159.771 E.01618
G1 X181.326 Y170.032 E.43629
G1 X181.326 Y169.494 E.01618
G1 X167.796 Y155.964 E.57524
G1 X168.335 Y155.964 E.01618
G1 X181.495 Y169.125 E.55957
; WIPE_START
G1 X180.081 Y167.711 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X176.651 Y160.893 Z2.2 F60000
G1 X174.086 Y155.795 Z2.2
G1 Z1.8
G1 E.8 F1800
G1 F9458.749
M204 S8000
G1 X174.376 Y156.085 E.01233
G1 X174.376 Y156.623 E.01618
G1 X173.717 Y155.964 E.028
G1 X173.179 Y155.964 E.01618
G1 X174.376 Y157.161 E.05089
G1 X174.376 Y157.699 E.01618
G1 X172.641 Y155.964 E.07377
G1 X172.102 Y155.964 E.01618
G1 X174.376 Y158.238 E.09666
G1 X174.376 Y158.776 E.01618
G1 X171.564 Y155.964 E.11954
G1 X171.026 Y155.964 E.01618
G1 X174.376 Y159.314 E.14243
G1 X174.376 Y159.852 E.01618
G1 X170.488 Y155.964 E.16531
G1 X169.949 Y155.964 E.01618
G1 X174.376 Y160.391 E.1882
G1 X174.376 Y160.929 E.01618
G1 X169.411 Y155.964 E.21108
G1 X168.873 Y155.964 E.01618
G1 X181.326 Y168.417 E.52947
G1 X181.326 Y167.879 E.01618
G1 X174.771 Y161.324 E.27869
G1 X175.309 Y161.324 E.01618
M73 P76 R5
G1 X181.326 Y167.341 E.2558
G1 X181.326 Y166.802 E.01618
G1 X175.848 Y161.324 E.23292
G1 X176.386 Y161.324 E.01618
G1 X181.326 Y166.264 E.21003
G1 X181.326 Y165.726 E.01618
G1 X176.924 Y161.324 E.18715
G1 X177.462 Y161.324 E.01618
G1 X181.326 Y165.188 E.16426
G1 X181.326 Y164.649 E.01618
G1 X178.001 Y161.324 E.14138
G1 X178.539 Y161.324 E.01618
G1 X181.326 Y164.111 E.11849
G1 X181.326 Y163.573 E.01618
G1 X179.077 Y161.324 E.0956
G1 X179.615 Y161.324 E.01618
G1 X181.326 Y163.035 E.07272
G1 X181.326 Y162.496 E.01618
G1 X180.154 Y161.324 E.04983
G1 X180.692 Y161.324 E.01618
G1 X181.495 Y162.128 E.03416
M204 S10000
G1 X181.425 Y161.195 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.10344
G1 F15000
M204 S8000
G1 X181.425 Y155.805 E.02576
M204 S10000
G1 X181.495 Y155.21 F60000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42088
G1 F9524.817
M204 S8000
G1 X176.709 Y150.424 E.20208
G1 X176.709 Y150.959 E.01596
G1 X181.223 Y155.472 E.19057
G1 X181.04 Y155.472 E.00546
G1 X181.04 Y155.676 E.00607
G1 X180.892 Y155.676 E.00443
G1 X176.709 Y151.493 E.17659
G1 X176.709 Y152.028 E.01596
G1 X180.357 Y155.676 E.15403
G1 X179.823 Y155.676 E.01596
G1 X176.709 Y152.562 E.13146
G1 X176.709 Y153.097 E.01596
G1 X179.288 Y155.676 E.10889
G1 X178.754 Y155.676 E.01596
G1 X176.709 Y153.631 E.08632
G1 X176.709 Y154.166 E.01596
G1 X178.219 Y155.676 E.06375
G1 X177.685 Y155.676 E.01596
G1 X176.709 Y154.7 E.04118
G1 X176.709 Y155.235 E.01596
G1 X177.32 Y155.845 E.02578
; WIPE_START
G1 X176.709 Y155.235 E-.32809
G1 X176.709 Y154.7 E-.20312
G1 X177.135 Y155.126 E-.2288
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X181.495 Y149.33 Z2.2 F60000
G1 Z1.8
G1 E.8 F1800
G1 F9524.817
M204 S8000
G1 X167.699 Y135.534 E.58251
G1 X167.699 Y136.069 E.01596
G1 X181.326 Y149.695 E.57534
G1 X181.326 Y150.23 E.01596
G1 X167.699 Y136.604 E.57534
G1 X167.699 Y137.138 E.01596
G1 X181.326 Y150.764 E.57534
G1 X181.326 Y151.299 E.01596
G1 X167.699 Y137.673 E.57534
G1 X167.699 Y138.207 E.01596
G1 X181.326 Y151.833 E.57534
G1 X181.326 Y152.368 E.01596
G1 X167.699 Y138.742 E.57534
G1 X167.699 Y139.276 E.01596
G1 X181.326 Y152.902 E.57534
G1 X181.326 Y153.437 E.01596
G1 X167.699 Y139.811 E.57534
G1 X167.699 Y140.345 E.01596
G1 X181.326 Y153.971 E.57534
G1 X181.326 Y154.506 E.01596
G1 X167.699 Y140.88 E.57534
G1 X167.699 Y141.414 E.01596
G1 X176.311 Y150.026 E.3636
G1 X175.776 Y150.026 E.01596
G1 X167.699 Y141.949 E.34103
G1 X167.699 Y142.483 E.01596
G1 X175.242 Y150.026 E.31846
G1 X174.707 Y150.026 E.01596
G1 X167.699 Y143.018 E.29589
G1 X167.699 Y143.139 E.00363
G1 X167.286 Y143.139 E.01233
G1 X174.173 Y150.026 E.29076
G1 X173.638 Y150.026 E.01596
G1 X166.799 Y143.187 E.28876
G1 X166.799 Y143.721 E.01596
G1 X173.104 Y150.026 E.26619
G1 X172.569 Y150.026 E.01596
G1 X166.799 Y144.256 E.24362
G1 X166.799 Y144.79 E.01596
G1 X172.035 Y150.026 E.22105
G1 X171.5 Y150.026 E.01596
G1 X166.799 Y145.325 E.19848
G1 X166.799 Y145.859 E.01596
G1 X170.966 Y150.026 E.17591
G1 X170.431 Y150.026 E.01596
G1 X166.799 Y146.394 E.15335
G1 X166.799 Y146.928 E.01596
G1 X169.897 Y150.026 E.13078
G1 X169.362 Y150.026 E.01596
G1 X166.799 Y147.463 E.10821
G1 X166.799 Y147.997 E.01596
G1 X168.828 Y150.026 E.08564
G1 X168.293 Y150.026 E.01596
G1 X166.799 Y148.532 E.06307
G1 X166.799 Y149.066 E.01596
G1 X167.759 Y150.026 E.0405
G1 X167.224 Y150.026 E.01596
G1 X166.63 Y149.431 E.0251
; WIPE_START
G1 X167.224 Y150.026 E-.31942
G1 X167.759 Y150.026 E-.20311
G1 X167.317 Y149.584 E-.23746
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X165.86 Y154.028 Z2.2 F60000
G1 Z1.8
G1 E.8 F1800
; LINE_WIDTH: 0.42352
G1 F9458.749
M204 S8000
G1 X165.471 Y153.639 E.01654
G1 X164.933 Y153.639 E.01618
G1 X165.691 Y154.397 E.03221
G1 X165.691 Y154.935 E.01618
G1 X164.395 Y153.639 E.0551
G1 X163.857 Y153.639 E.01618
G1 X165.691 Y155.473 E.07798
G1 X165.691 Y155.964 E.01476
G1 X166.182 Y155.964 E.01476
G1 X169.118 Y158.901 E.12484
G1 X169.656 Y158.901 E.01618
G1 X166.72 Y155.964 E.12484
G1 X167.258 Y155.964 E.01618
G1 X170.364 Y159.07 E.13206
; WIPE_START
G1 X168.95 Y157.656 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X168.749 Y159.07 Z2.2 F60000
G1 Z1.8
G1 E.8 F1800
G1 F9458.749
M204 S8000
G1 X163.318 Y153.639 E.23091
G1 X162.78 Y153.639 E.01618
G1 X168.041 Y158.901 E.2237
G1 X167.503 Y158.901 E.01618
G1 X162.242 Y153.639 E.2237
G1 X161.704 Y153.639 E.01618
G1 X166.965 Y158.901 E.2237
G1 X166.427 Y158.901 E.01618
G1 X161.249 Y153.723 E.22013
G1 X161.249 Y154.262 E.01618
G1 X165.888 Y158.901 E.19724
G1 X165.35 Y158.901 E.01618
G1 X161.249 Y154.8 E.17435
G1 X161.249 Y155.338 E.01618
G1 X164.812 Y158.901 E.15147
G1 X164.274 Y158.901 E.01618
G1 X161.249 Y155.876 E.12858
G1 X161.249 Y156.415 E.01618
G1 X163.735 Y158.901 E.1057
G1 X163.197 Y158.901 E.01618
G1 X161.249 Y156.953 E.08281
G1 X161.249 Y157.491 E.01618
G1 X162.659 Y158.901 E.05993
G1 X162.121 Y158.901 E.01618
G1 X161.249 Y158.029 E.03704
G1 X161.249 Y158.568 E.01618
G1 X161.752 Y159.07 E.02137
; WIPE_START
G1 X161.249 Y158.568 E-.27014
G1 X161.249 Y158.029 E-.20454
G1 X161.78 Y158.56 E-.28533
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X160.787 Y159.437 Z2.2 F60000
G1 Z1.8
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.19158
G1 F15000
M204 S8000
G1 X160.787 Y168.363 E.10481
; WIPE_START
M73 P76 R4
G1 X160.787 Y166.363 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X166.584 Y171.328 Z2.2 F60000
G1 X188.32 Y189.945 Z2.2
G1 Z1.8
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42352
G1 F9458.749
M204 S8000
G1 X167.275 Y168.899 E.8948
G1 X166.737 Y168.899 E.01618
G1 X188.151 Y190.313 E.91047
G1 X188.151 Y190.851 E.01618
G1 X166.199 Y168.899 E.93335
G1 X165.66 Y168.899 E.01618
G1 X188.151 Y191.39 E.95624
G1 X188.151 Y191.928 E.01618
G1 X165.122 Y168.899 E.97913
G1 X164.584 Y168.899 E.01618
G1 X188.151 Y192.466 E1.00201
G1 X188.151 Y193.004 E.01618
G1 X164.046 Y168.899 E1.0249
G1 X163.507 Y168.899 E.01618
G1 X188.151 Y193.543 E1.04778
G1 X188.151 Y194.081 E.01618
G1 X162.969 Y168.899 E1.07067
G1 X162.431 Y168.899 E.01618
G1 X188.151 Y194.619 E1.09355
G1 X188.151 Y195.157 E.01618
G1 X161.893 Y168.899 E1.11644
G1 X161.354 Y168.899 E.01618
G1 X188.151 Y195.696 E1.13932
G1 X188.151 Y196.234 E.01618
G1 X161.249 Y169.333 E1.14379
G1 X161.249 Y169.871 E.01618
G1 X188.151 Y196.772 E1.14379
G1 X188.151 Y197.31 E.01618
G1 X161.249 Y170.409 E1.14379
G1 X161.249 Y170.947 E.01618
G1 X176.858 Y186.556 E.66363
G1 X176.319 Y186.556 E.01618
G1 X161.249 Y171.486 E.64074
G1 X161.249 Y172.024 E.01618
G1 X166.351 Y177.126 E.21692
G1 X165.813 Y177.126 E.01618
G1 X161.249 Y172.562 E.19403
G1 X161.249 Y173.1 E.01618
G1 X165.275 Y177.126 E.17115
G1 X164.736 Y177.126 E.01618
G1 X161.249 Y173.639 E.14826
G1 X161.249 Y174.177 E.01618
G1 X164.198 Y177.126 E.12537
G1 X163.66 Y177.126 E.01618
G1 X161.249 Y174.715 E.10249
G1 X161.249 Y175.253 E.01618
G1 X163.122 Y177.126 E.0796
G1 X162.583 Y177.126 E.01618
G1 X161.249 Y175.792 E.05672
G1 X161.249 Y176.33 E.01618
G1 X162.045 Y177.126 E.03383
G1 X161.507 Y177.126 E.01618
G1 X161.08 Y176.698 E.01816
M204 S10000
G1 X160.925 Y177.662 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.467762
G1 F8473.752
M204 S8000
G1 X160.925 Y185.328 E.25724
G1 X160.941 Y185.411 E.00286
; LINE_WIDTH: 0.51702
G1 F7593.335
G1 X160.958 Y185.495 E.00319
; WIPE_START
G1 X160.941 Y185.411 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X166.263 Y185.495 Z2.2 F60000
G1 Z1.8
G1 E.8 F1800
; LINE_WIDTH: 0.37757
G1 F10757.508
M204 S8000
G1 X161.137 Y185.495 E.13549
; LINE_WIDTH: 0.397056
G1 F10165.602
G1 X161.092 Y185.495 E.00125
; LINE_WIDTH: 0.436047
G1 F9157.362
G1 X161.048 Y185.495 E.00139
; LINE_WIDTH: 0.475038
G1 F8331.074
G1 X161.003 Y185.495 E.00153
; LINE_WIDTH: 0.503353
G1 F7818.736
G1 X160.958 Y185.495 E.00163
G1 X160.925 Y185.662 E.0062
; LINE_WIDTH: 0.46758
G1 F8477.369
G1 X160.925 Y192.987 E.24572
M204 S10000
G1 X161.544 Y193.158 F60000
; LINE_WIDTH: 0.51671
G1 F7598.303
M204 S8000
G1 X165.855 Y193.158 E.16134
; WIPE_START
G1 X163.855 Y193.158 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X167.313 Y192.62 Z2.2 F60000
G1 Z1.8
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42352
G1 F9458.749
M204 S8000
G1 X166.799 Y192.107 E.02184
G1 X166.799 Y191.568 E.01618
G1 X167.682 Y192.451 E.03751
G1 X168.22 Y192.451 E.01618
G1 X166.799 Y191.03 E.0604
G1 X166.799 Y190.492 E.01618
G1 X168.758 Y192.451 E.08328
G1 X169.296 Y192.451 E.01618
G1 X166.799 Y189.954 E.10617
G1 X166.799 Y189.415 E.01618
G1 X169.835 Y192.451 E.12905
G1 X169.906 Y192.451 E.00214
G1 X169.906 Y191.983 E.01405
G1 X166.799 Y188.877 E.13207
G1 X166.799 Y188.339 E.01618
G1 X169.906 Y191.445 E.13207
G1 X169.906 Y190.907 E.01618
G1 X166.799 Y187.801 E.13207
G1 X166.799 Y187.262 E.01618
G1 X169.906 Y190.369 E.13207
G1 X169.906 Y189.83 E.01618
G1 X166.799 Y186.724 E.13207
G1 X166.799 Y186.186 E.01618
G1 X169.906 Y189.292 E.13207
G1 X169.906 Y188.754 E.01618
G1 X166.799 Y185.648 E.13207
G1 X166.799 Y185.109 E.01618
G1 X169.906 Y188.216 E.13207
G1 X169.906 Y187.677 E.01618
G1 X166.799 Y184.571 E.13207
G1 X166.799 Y184.033 E.01618
G1 X169.906 Y187.139 E.13207
G1 X169.906 Y186.601 E.01618
G1 X166.799 Y183.495 E.13207
G1 X166.799 Y182.956 E.01618
M73 P77 R4
G1 X170.399 Y186.556 E.15303
G1 X170.937 Y186.556 E.01618
G1 X166.799 Y182.418 E.17592
G1 X166.799 Y181.88 E.01618
G1 X171.475 Y186.556 E.1988
G1 X172.013 Y186.556 E.01618
G1 X166.799 Y181.342 E.22169
G1 X166.799 Y180.803 E.01618
G1 X172.552 Y186.556 E.24457
G1 X173.09 Y186.556 E.01618
G1 X166.799 Y180.265 E.26746
G1 X166.799 Y179.727 E.01618
G1 X173.628 Y186.556 E.29034
G1 X174.166 Y186.556 E.01618
G1 X166.799 Y179.189 E.31323
G1 X166.799 Y178.65 E.01618
G1 X174.705 Y186.556 E.33611
G1 X175.243 Y186.556 E.01618
G1 X166.799 Y178.112 E.359
G1 X166.799 Y177.574 E.01618
G1 X175.951 Y186.725 E.3891
; WIPE_START
G1 X174.537 Y185.311 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.287 Y192.217 Z2.2 F60000
G1 X170.849 Y193.148 Z2.2
G1 Z1.8
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.53672
G1 F7290.401
M204 S8000
G1 X176.301 Y193.148 E.21263
; WIPE_START
G1 X174.301 Y193.148 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X177.075 Y192.155 Z2.2 F60000
G1 Z1.8
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42352
G1 F9458.749
M204 S8000
G1 X177.37 Y192.451 E.01256
G1 X177.908 Y192.451 E.01618
G1 X177.244 Y191.787 E.02823
G1 X177.244 Y191.248 E.01618
G1 X178.447 Y192.451 E.05112
G1 X178.985 Y192.451 E.01618
G1 X177.244 Y190.71 E.074
G1 X177.244 Y190.172 E.01618
G1 X179.523 Y192.451 E.09689
G1 X180.061 Y192.451 E.01618
G1 X177.244 Y189.634 E.11977
G1 X177.244 Y189.095 E.01618
G1 X180.6 Y192.451 E.14266
G1 X181.138 Y192.451 E.01618
G1 X177.244 Y188.557 E.16554
G1 X177.244 Y188.019 E.01618
G1 X188.151 Y198.925 E.46371
G1 X188.151 Y198.387 E.01618
G1 X177.244 Y187.481 E.46371
G1 X177.244 Y186.942 E.01618
G1 X188.32 Y198.018 E.47093
; WIPE_START
G1 X186.906 Y196.604 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X188.32 Y199.633 Z2.2 F60000
G1 Z1.8
G1 E.8 F1800
G1 F9458.749
M204 S8000
G1 X181.974 Y193.287 E.26982
G1 X181.974 Y193.825 E.01618
G1 X188.151 Y200.002 E.2626
G1 X188.151 Y200.54 E.01618
G1 X181.974 Y194.364 E.2626
G1 X181.974 Y194.902 E.01618
G1 X187.972 Y200.899 E.25499
G1 X187.734 Y200.941 E.00727
G2 X187.125 Y200.243 I-2.364 J1.449 E.02797
G1 X186.661 Y199.936 E.01671
G1 X186.337 Y199.803 E.01056
G1 X181.974 Y195.44 E.18548
G1 X181.974 Y195.978 E.01618
G1 X185.614 Y199.618 E.15474
G1 X185.07 Y199.613 E.01634
G1 X181.974 Y196.517 E.13164
G1 X181.974 Y197.055 E.01618
G1 X184.612 Y199.692 E.11213
G2 X184.207 Y199.826 I.14 J1.106 E.01289
G1 X181.974 Y197.593 E.09492
G1 X181.974 Y198.131 E.01618
G1 X183.84 Y199.997 E.07931
G2 X183.518 Y200.213 I.936 J1.737 E.01168
G1 X181.974 Y198.67 E.06564
G1 X181.974 Y199.208 E.01618
G1 X183.232 Y200.466 E.05348
G2 X182.988 Y200.76 I.875 J.977 E.01153
G1 X181.974 Y199.746 E.04309
G1 X181.974 Y200.284 E.01618
G1 X182.773 Y201.083 E.03395
G1 X182.606 Y201.454 E.01224
G1 X181.974 Y200.823 E.02686
G1 X181.974 Y201.361 E.01618
G1 X182.48 Y201.867 E.02152
G2 X182.407 Y202.332 I1.537 J.481 E.0142
G1 X181.974 Y201.899 E.0184
G1 X181.974 Y202.437 E.01618
G1 X182.432 Y202.895 E.01947
G2 X182.627 Y203.628 I3.354 J-.498 E.02284
G1 X181.974 Y202.976 E.02774
G1 X181.974 Y203.514 E.01618
G1 X186.711 Y208.251 E.2014
G1 X187.249 Y208.251 E.01618
G1 X184.151 Y205.152 E.13173
G2 X184.904 Y205.367 I.942 J-1.877 E.02368
G1 X187.788 Y208.251 E.1226
G1 X188.151 Y208.251 E.01091
G1 X188.151 Y208.075 E.00527
G1 X185.465 Y205.39 E.11419
G2 X185.94 Y205.327 I-.091 J-2.518 E.01444
G1 X188.151 Y207.537 E.09398
G1 X188.151 Y206.999 E.01618
G1 X186.346 Y205.194 E.07674
G1 X186.717 Y205.027 E.01224
G1 X188.151 Y206.461 E.06095
G1 X188.151 Y205.922 E.01618
G1 X187.04 Y204.812 E.04721
G2 X187.334 Y204.568 I-.68 J-1.116 E.01153
G1 X188.151 Y205.384 E.03471
G1 X188.151 Y204.846 E.01618
G1 X187.586 Y204.282 E.024
G2 X187.743 Y204.061 I-.991 J-.869 E.00816
G1 X187.938 Y204.095 E.00595
G1 X188.32 Y204.477 E.01627
M204 S10000
G1 X188.039 Y203.774 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.435756
G1 F9164.138
M204 S8000
G1 X188.075 Y203.57 E.00644
; LINE_WIDTH: 0.398178
G1 F10133.485
G1 X188.113 Y203.348 E.00631
; LINE_WIDTH: 0.359311
G1 F11378.343
G1 X188.131 Y203.207 E.00356
; LINE_WIDTH: 0.323073
G1 F12850.129
G1 X188.149 Y203.053 E.00344
; LINE_WIDTH: 0.284806
G1 F14883.051
G1 X188.169 Y202.78 E.00523
; LINE_WIDTH: 0.258108
G1 F15000
G1 X188.169 Y202.227 E.00939
; LINE_WIDTH: 0.285148
G1 F14862.037
G1 X188.149 Y201.939 E.00554
; LINE_WIDTH: 0.324026
G1 F12806.589
G1 X188.131 Y201.794 E.00324
; LINE_WIDTH: 0.361779
G1 F11290.269
G1 X188.11 Y201.631 E.00412
; LINE_WIDTH: 0.400444
G1 F10069.252
G1 X188.075 Y201.429 E.00582
; LINE_WIDTH: 0.436148
G1 F9154.994
G1 X188.039 Y201.226 E.0064
; WIPE_START
G1 X188.075 Y201.429 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X186.343 Y208.42 Z2.2 F60000
G1 Z1.8
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42352
G1 F9458.749
M204 S8000
G1 X181.974 Y204.052 E.18573
G1 X181.974 Y204.59 E.01618
G1 X185.635 Y208.251 E.15563
G1 X185.096 Y208.251 E.01618
G1 X181.974 Y205.129 E.13274
G1 X181.974 Y205.667 E.01618
G1 X184.558 Y208.251 E.10986
G1 X184.02 Y208.251 E.01618
G1 X181.974 Y206.205 E.08697
G1 X181.974 Y206.743 E.01618
G1 X183.482 Y208.251 E.06408
G1 X182.943 Y208.251 E.01618
G1 X181.974 Y207.282 E.0412
G1 X181.974 Y207.82 E.01618
G1 X182.575 Y208.42 E.02553
; WIPE_START
G1 X181.974 Y207.82 E-.32267
G1 X181.974 Y207.282 E-.20454
G1 X182.408 Y207.715 E-.2328
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X183.033 Y200.108 Z2.2 F60000
G1 X188.32 Y135.844 Z2.2
G1 Z1.8
G1 E.8 F1800
; LINE_WIDTH: 0.42088
G1 F9524.817
M204 S8000
G1 X187.726 Y135.249 E.0251
G1 X187.191 Y135.249 E.01596
G1 X188.151 Y136.209 E.0405
G1 X188.151 Y136.743 E.01596
G1 X186.657 Y135.249 E.06307
G1 X186.122 Y135.249 E.01596
G1 X187.674 Y136.801 E.0655
G1 X187.139 Y136.801 E.01596
G1 X185.588 Y135.249 E.0655
G1 X185.053 Y135.249 E.01596
G1 X186.605 Y136.801 E.0655
G1 X186.07 Y136.801 E.01596
G1 X184.519 Y135.249 E.0655
G1 X183.984 Y135.249 E.01596
G1 X185.536 Y136.801 E.0655
G1 X185.001 Y136.801 E.01596
G1 X183.45 Y135.249 E.0655
G1 X182.915 Y135.249 E.01596
G1 X184.466 Y136.801 E.0655
G1 X183.932 Y136.801 E.01596
G1 X182.381 Y135.249 E.0655
G1 X181.846 Y135.249 E.01596
G1 X183.397 Y136.801 E.0655
G1 X182.863 Y136.801 E.01596
G1 X181.312 Y135.249 E.0655
G1 X180.777 Y135.249 E.01596
G1 X182.328 Y136.801 E.0655
G1 X181.794 Y136.801 E.01596
G1 X180.243 Y135.249 E.0655
G1 X179.708 Y135.249 E.01596
G1 X181.259 Y136.801 E.0655
G1 X180.725 Y136.801 E.01596
G1 X179.174 Y135.249 E.0655
G1 X178.639 Y135.249 E.01596
G1 X180.19 Y136.801 E.0655
G1 X179.656 Y136.801 E.01596
G1 X178.105 Y135.249 E.0655
G1 X177.57 Y135.249 E.01596
G1 X179.121 Y136.801 E.0655
G1 X178.587 Y136.801 E.01596
G1 X177.036 Y135.249 E.0655
G1 X176.501 Y135.249 E.01596
G1 X178.052 Y136.801 E.0655
G1 X177.518 Y136.801 E.01596
G1 X175.966 Y135.249 E.0655
G1 X175.551 Y135.249 E.01242
G1 X175.551 Y134.834 E.01242
G1 X170.309 Y129.592 E.2213
G1 X170.309 Y129.249 E.01024
G1 X170.501 Y129.249 E.00572
G1 X175.551 Y134.299 E.21321
G1 X175.551 Y133.764 E.01596
G1 X171.036 Y129.249 E.19064
G1 X171.57 Y129.249 E.01596
G1 X175.551 Y133.23 E.16807
G1 X175.551 Y132.695 E.01596
G1 X172.105 Y129.249 E.1455
G1 X172.639 Y129.249 E.01596
G1 X175.551 Y132.161 E.12293
G1 X175.551 Y131.626 E.01596
G1 X173.174 Y129.249 E.10037
G1 X173.708 Y129.249 E.01596
G1 X175.551 Y131.092 E.0778
G1 X175.551 Y130.557 E.01596
G1 X174.243 Y129.249 E.05523
G1 X174.777 Y129.249 E.01596
G1 X175.551 Y130.023 E.03266
G1 X175.551 Y129.488 E.01596
G1 X175.142 Y129.08 E.01725
M204 S10000
G1 X176.087 Y129.025 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.66758
G1 F5763.136
M204 S8000
G1 X188.687 Y129.025 E.62173
; COOLING_NODE: 13
; WIPE_START
G1 X186.687 Y129.025 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X179.626 Y126.128 Z2.2 F60000
G1 X166.884 Y120.9 Z2.2
G1 Z1.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X166.884 Y121.274 E.01202
G1 X160.916 Y121.274 E.1919
G1 X160.916 Y111.416 E.31698
G1 X166.884 Y111.416 E.1919
G1 X166.884 Y116.247 E.15533
G1 X166.657 Y116.263 E.00732
G2 X166.657 Y116.739 I-2.555 J.241 E.50327
G1 X166.884 Y116.756 E.0073
G1 X166.884 Y120.84 E.13133
; COOLING_NODE: 13
; WIPE_START
G1 X166.884 Y121.274 E-.16484
G1 X165.318 Y121.274 E-.59516
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X164.983 Y114.536 Z2.2 F60000
G1 Z1.8
G1 E.8 F1800
G1 F8843.478
M204 S8000
G1 X165.297 Y114.704 E.01147
G3 X163.872 Y114.352 I-1.2 J1.795 E.38808
G1 X164.088 Y114.34 E.00695
G3 X164.909 Y114.498 I.01 J2.159 E.02704
G1 X164.929 Y114.508 E.00075
; COOLING_NODE: 13
M204 S10000
G1 X164.793 Y114.894 F60000
G1 F8843.478
M204 S8000
G1 X165.072 Y115.043 E.01016
G3 X163.916 Y114.757 I-.973 J1.456 E.31486
G1 X164.091 Y114.747 E.00565
G3 X164.739 Y114.869 I.008 J1.752 E.02133
; COOLING_NODE: 13
M204 S250
G1 X164.608 Y115.238 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X164.609 Y115.239 E.00005
G3 X163.957 Y115.147 I-.51 J1.26 E.23462
G1 X164.094 Y115.14 E.00407
G3 X164.359 Y115.165 I.006 J1.359 E.00794
G1 X164.55 Y115.221 E.00595
; COOLING_NODE: 13
; WIPE_START
M204 S8000
G1 X164.609 Y115.239 E-.02343
G1 X164.855 Y115.369 E-.1057
G1 X165.062 Y115.538 E-.10143
G1 X165.228 Y115.74 E-.09936
G1 X165.353 Y115.97 E-.09932
G1 X165.401 Y116.102 E-.05363
G1 X165.454 Y116.375 E-.1057
G1 X165.453 Y116.636 E-.09906
G1 X165.416 Y116.823 E-.07238
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X167.291 Y120.9 Z2.2 F60000
G1 Z1.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X167.291 Y121.681 E.02511
G1 X160.509 Y121.681 E.21808
G1 X160.509 Y111.009 E.34316
G1 X167.291 Y111.009 E.21808
G1 X167.291 Y120.84 E.31613
; COOLING_NODE: 13
M204 S10000
G1 X167.698 Y120.9 F60000
G1 F8843.478
M204 S8000
G1 X167.698 Y121.292 E.01261
G1 X168.098 Y121.292 E.01286
G1 X168.098 Y122.088 E.02559
G1 X160.102 Y122.088 E.25712
G1 X160.102 Y110.602 E.36934
G1 X167.698 Y110.602 E.24426
G1 X167.698 Y120.84 E.32921
; COOLING_NODE: 12
M204 S250
G1 X168.09 Y120.9 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1623
M204 S5000
G1 X168.49 Y120.9 E.01191
G1 X168.49 Y122.48 E.04706
G1 X159.71 Y122.48 E.26153
G1 X159.71 Y110.21 E.36548
G1 X168.09 Y110.21 E.24961
G1 X168.09 Y120.84 E.31663
; WIPE_START
G1 F9547.055
M204 S8000
G1 X168.49 Y120.9 E-.1537
G1 X168.49 Y122.48 E-.60041
G1 X168.474 Y122.48 E-.00589
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X166.473 Y117.973 Z2.2 F60000
G1 Z1.8
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.112395
G1 F15000
M204 S8000
G1 X166.581 Y117.827 E.001
; LINE_WIDTH: 0.139892
G1 X166.68 Y117.681 E.00135
; WIPE_START
G1 X166.581 Y117.827 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X167.087 Y116.501 Z2.2 F60000
G1 Z1.8
G1 E.8 F1800
; LINE_WIDTH: 0.147248
G1 F15000
M204 S8000
G1 X166.809 Y116.501 E.00229
; LINE_WIDTH: 0.113696
G1 X166.531 Y116.501 E.00155
; WIPE_START
G1 X166.809 Y116.501 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X166.68 Y115.325 Z2.2 F60000
G1 Z1.8
G1 E.8 F1800
; LINE_WIDTH: 0.134214
G1 F15000
M204 S8000
G1 X166.573 Y115.165 E.00139
; LINE_WIDTH: 0.10849
G1 X166.485 Y115.047 E.00077
M204 S10000
G1 X166.384 Y114.633 F60000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F9547.299
M204 S8000
G1 X166.492 Y114.583 E.00354
G1 X166.492 Y111.808 E.08265
G1 X161.308 Y111.808 E.15439
G1 X161.308 Y114.818 E.08966
G1 X161.64 Y114.853 E.00994
G1 X162.181 Y114.248 E.02417
G1 X162.463 Y114.034 E.01055
G1 X162.931 Y113.78 E.01587
G1 X163.469 Y113.609 E.0168
G1 X163.811 Y113.554 E.01032
G1 X164.346 Y113.55 E.01594
G1 X164.901 Y113.651 E.01679
G1 X165.226 Y113.763 E.01026
G1 X165.725 Y114.027 E.0168
G1 X166.178 Y114.393 E.01736
G1 X166.345 Y114.588 E.00763
M204 S10000
G1 X166.115 Y113.854 F60000
G1 F9547.299
M204 S8000
G1 X166.115 Y112.185 E.04969
G1 X161.685 Y112.185 E.13193
G1 X161.685 Y114.235 E.06104
G3 X162.752 Y113.449 I2.239 J1.922 E.0398
G1 X163.356 Y113.249 E.01896
G3 X164.97 Y113.28 I.736 J3.647 E.04848
G3 X166.067 Y113.818 I-1.103 J3.636 E.03653
M204 S10000
G1 X165.712 Y113.138 F60000
; LINE_WIDTH: 0.47159
G1 F8398.068
M204 S8000
G1 X165.712 Y112.588 E.0186
; LINE_WIDTH: 0.455325
G1 F8729.283
G1 X165.392 Y112.572 E.01043
; LINE_WIDTH: 0.422795
G1 F9476.801
G1 X165.072 Y112.556 E.00961
; LINE_WIDTH: 0.38194
G1 F10618.842
G1 X164.543 Y112.531 E.01418
; LINE_WIDTH: 0.363151
G1 F11241.888
G2 X163.193 Y112.552 I-.442 J15.307 E.03415
; LINE_WIDTH: 0.418625
G1 F9581.985
G1 X162.93 Y112.572 E.00785
; LINE_WIDTH: 0.458955
G1 F8653.118
G1 X162.666 Y112.592 E.0087
; LINE_WIDTH: 0.49475
G1 F7967.598
G1 X162.394 Y112.608 E.0097
; LINE_WIDTH: 0.536122
G1 F7299.252
G1 X162.123 Y112.623 E.01059
G1 X162.123 Y113.291 E.02603
G1 X162.547 Y113.07 E.01861
; LINE_WIDTH: 0.505302
G1 F7785.776
G1 X162.78 Y113.013 E.00877
; LINE_WIDTH: 0.462565
G1 F8578.679
G1 X163.013 Y112.956 E.00796
; LINE_WIDTH: 0.419829
G1 F9551.394
G1 X163.247 Y112.899 E.00715
; LINE_WIDTH: 0.374405
G1 F10860.22
G1 X163.805 Y112.835 E.01472
; LINE_WIDTH: 0.349275
G1 F11751.072
G1 X164.346 Y112.832 E.01309
; LINE_WIDTH: 0.362783
G1 F11254.836
G1 X164.692 Y112.874 E.00881
; LINE_WIDTH: 0.391948
G1 F10314.373
G1 X165.039 Y112.916 E.00962
; LINE_WIDTH: 0.422795
G1 F9476.801
G1 X165.246 Y112.965 E.00639
; LINE_WIDTH: 0.463706
G1 F8555.423
G3 X165.658 Y113.112 I-.131 J1.019 E.01464
; WIPE_START
G1 X165.453 Y113.014 E-.3916
G1 X165.246 Y112.965 E-.3684
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X161.361 Y115.226 Z2.2 F60000
G1 Z1.8
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.435838
G1 F9162.227
M204 S8000
G1 X161.325 Y115.43 E.00643
; LINE_WIDTH: 0.398376
G1 F10127.857
G1 X161.287 Y115.651 E.0063
; LINE_WIDTH: 0.359461
G1 F11372.965
G1 X161.269 Y115.793 E.00358
; LINE_WIDTH: 0.323048
G1 F12851.293
G1 X161.251 Y115.948 E.00345
; LINE_WIDTH: 0.284744
G1 F14886.912
G1 X161.231 Y116.221 E.00522
; LINE_WIDTH: 0.257911
G1 F15000
G1 X161.23 Y116.763 E.00921
; LINE_WIDTH: 0.284108
G1 F14926.162
G1 X161.251 Y117.054 E.00556
; LINE_WIDTH: 0.320815
G1 F12954.553
G1 X161.267 Y117.186 E.00291
; LINE_WIDTH: 0.354172
G1 F11566.199
G1 X161.285 Y117.333 E.00364
; LINE_WIDTH: 0.392554
G1 F10296.488
G1 X161.305 Y117.452 E.00334
; LINE_WIDTH: 0.428282
G1 F9341.879
G1 X161.325 Y117.572 E.00368
G1 X161.37 Y117.595 E.00156
; LINE_WIDTH: 0.367869
G1 F11078.686
G1 X161.599 Y117.708 E.00655
; WIPE_START
G1 X161.37 Y117.595 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X163.344 Y120.132 Z2.2 F60000
G1 Z1.8
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.39298
G1 F10283.951
M204 S8000
G1 X163.677 Y120.15 E.0092
; LINE_WIDTH: 0.359984
G1 F11354.184
G2 X164.714 Y120.144 I.483 J-5.62 E.02602
; LINE_WIDTH: 0.39225
G1 F10305.442
G1 X164.727 Y120.143 E.00036
; WIPE_START
G1 X164.714 Y120.144 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X163.344 Y120.132 Z2.2 F60000
G1 Z1.8
G1 E.8 F1800
; LINE_WIDTH: 0.419315
G1 F9564.43
M204 S8000
G3 X162.063 Y119.591 I.857 J-3.824 E.04158
G1 X162.063 Y120.127 E.01594
G3 X163.284 Y120.131 I.421 J61.736 E.03633
; WIPE_START
G1 X162.063 Y120.127 E-.46426
G1 X162.063 Y119.591 E-.20367
G1 X162.27 Y119.717 E-.09208
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X165.772 Y120.162 Z2.2 F60000
G1 Z1.8
G1 E.8 F1800
; LINE_WIDTH: 0.361371
G1 F11304.727
M204 S8000
G1 X165.772 Y119.774 E.00975
G3 X164.853 Y120.143 I-5.51 J-12.411 E.02492
G2 X165.712 Y120.162 I.812 J-17.096 E.02162
M204 S10000
G1 X166.115 Y120.505 F60000
; LINE_WIDTH: 0.41999
G1 F9547.299
M204 S8000
G1 X166.115 Y119.149 E.04039
G1 X165.614 Y119.472 E.01775
G3 X164.15 Y119.835 I-1.598 J-3.307 E.04524
G1 X163.516 Y119.784 E.01895
G3 X162.04 Y119.123 I.745 J-3.643 E.04856
G1 X161.687 Y118.803 E.01418
G2 X161.685 Y120.505 I222.838 J1.107 E.05067
G1 X166.055 Y120.505 E.13014
M204 S10000
G1 X166.492 Y120.882 F60000
G1 F9547.299
M204 S8000
G1 X166.492 Y118.436 E.07286
G1 X166.363 Y118.38 E.00418
G1 X166.018 Y118.753 E.01515
G1 X165.504 Y119.106 E.01857
G1 X164.983 Y119.325 E.01684
G3 X163.553 Y119.409 I-.91 J-3.289 E.04298
G1 X163.215 Y119.324 E.01038
G1 X162.722 Y119.12 E.01589
G1 X162.249 Y118.809 E.01686
G3 X161.743 Y118.253 I1.893 J-2.232 E.02246
G1 X161.621 Y118.334 E.00435
G1 X161.308 Y118.235 E.00977
G1 X161.308 Y120.882 E.07883
G1 X166.432 Y120.882 E.15261
; CHANGE_LAYER
; Z_HEIGHT: 1.85
; LAYER_HEIGHT: 0.0500001
; WIPE_START
G1 F9547.299
G1 X164.432 Y120.882 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 15/37
; update layer progress
M73 L15
M991 S0 P14 ;notify layer change

; OBJECT_ID: 15
M204 S10000
G17
G3 Z2.2 I-.893 J.827 P1  F60000
G1 X168.512 Y125.287 Z2.2
G1 Z1.85
G1 E.8 F1800
; FEATURE: Support
; LINE_WIDTH: 0.42
; LAYER_HEIGHT: 0.275
G1 F7252.893
M204 S8000
G1 X168.512 Y123.229 E.08069
M73 P78 R4
G1 X159.688 Y123.229 E.34594
G1 X159.688 Y125.475 E.08809
G1 X168.512 Y125.475 E.34594
G1 X168.512 Y126.961 E.05828
G1 X168.337 Y126.961 E.00685
G1 X168.021 Y127.277 E.01749
G1 X168.021 Y128.352 E.04216
G1 X159.688 Y128.352 E.32672
G1 X159.688 Y130.971 E.1027
G1 X168.021 Y130.971 E.32672
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

G1 X168.021 Y128.541 E.0953
; CHANGE_LAYER
; Z_HEIGHT: 2
; LAYER_HEIGHT: 0.15
; WIPE_START
G1 X168.021 Y130.541 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 16/37
; update layer progress
M73 L16
M991 S0 P15 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 4
M204 S10000
G17
G3 Z2.25 I-1.126 J.461 P1  F60000
G1 X179.985 Y159.785 Z2.25
G1 Z2
G1 E.8 F1800
; FEATURE: Outer wall
; LAYER_HEIGHT: 0.2
G1 F9547.055
M204 S5000
G1 X175.915 Y159.785 E.12123
G1 X175.915 Y157.215 E.07655
G1 X179.985 Y157.215 E.12123
G1 X179.985 Y159.725 E.07476
; COOLING_NODE: 1
; WIPE_START
M204 S8000
G1 X177.985 Y159.754 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.146 Y156.366 Z2.4 F60000
G1 X167.23 Y154.425 Z2.4
G1 Z2
G1 E.8 F1800
G1 F9547.055
M204 S5000
G1 X167.23 Y151.565 E.08519
G1 X175.17 Y151.565 E.23651
G1 X175.17 Y154.425 E.08519
G1 X167.29 Y154.425 E.23472
; COOLING_NODE: 2
; WIPE_START
M204 S8000
G1 X167.248 Y152.425 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X165.515 Y144.992 Z2.4 F60000
G1 X165.26 Y143.9 Z2.4
G1 Z2
G1 E.8 F1800
G1 F9547.055
M204 S5000
G1 X165.26 Y152.1 E.24425
G1 X162.14 Y152.1 E.09293
G1 X162.14 Y143.9 E.24425
G1 X165.2 Y143.9 E.09115
; COOLING_NODE: 9
; WIPE_START
M204 S8000
G1 X165.215 Y145.9 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X166.16 Y141.6 Z2.4 F60000
G1 Z2
G1 E.8 F1800
G1 F9547.055
M204 S5000
G1 X163.04 Y141.6 E.09293
G1 X163.04 Y133.4 E.24425
G1 X166.16 Y133.4 E.09293
G1 X166.16 Y141.54 E.24246
; COOLING_NODE: 6
; WIPE_START
M204 S8000
G1 X164.16 Y141.578 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.049 Y138.291 Z2.4 F60000
G1 X187.71 Y130.34 Z2.4
G1 Z2
G1 E.8 F1800
G1 F9547.055
M204 S5000
G1 X187.71 Y133.71 E.10038
G1 X177.09 Y133.71 E.31633
G1 X177.09 Y130.34 E.10038
G1 X187.65 Y130.34 E.31455
; COOLING_NODE: 3
; WIPE_START
M204 S8000
G1 X187.686 Y132.34 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X181.968 Y137.396 Z2.4 F60000
G1 X177.09 Y141.71 Z2.4
G1 Z2
G1 E.8 F1800
G1 F9547.055
M204 S5000
G1 X177.09 Y138.34 E.10038
G1 X187.71 Y138.34 E.31633
G1 X187.71 Y141.71 E.10038
G1 X177.15 Y141.71 E.31455
; COOLING_NODE: 0
; WIPE_START
M204 S8000
G1 X177.114 Y139.71 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X183.365 Y144.09 Z2.4 F60000
G1 X188.525 Y147.705 Z2.4
G1 Z2
G1 E.8 F1800
G1 F9547.055
M204 S5000
G1 X188.525 Y181.305 E1.00083
G1 X182.865 Y181.305 E.16859
G1 X182.865 Y147.705 E1.00083
G1 X188.465 Y147.705 E.1668
; COOLING_NODE: 7
; WIPE_START
M204 S8000
G1 X188.469 Y149.705 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X182.885 Y154.909 Z2.4 F60000
G1 X169.525 Y167.36 Z2.4
G1 Z2
G1 E.8 F1800
G1 F9547.055
M204 S5000
G1 X161.864 Y167.36 E.22819
G1 X161.864 Y160.44 E.20612
G1 X169.525 Y160.44 E.22819
G1 X169.525 Y167.3 E.20434
; COOLING_NODE: 8
; WIPE_START
M204 S8000
G1 X167.525 Y167.316 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X166.518 Y174.881 Z2.4 F60000
G1 X165.26 Y184.325 Z2.4
G1 Z2
G1 E.8 F1800
G1 F9547.055
M204 S5000
G1 X162.14 Y184.325 E.09293
G1 X162.14 Y178.665 E.16859
G1 X165.26 Y178.665 E.09293
G1 X165.26 Y184.265 E.1668
; COOLING_NODE: 10
; WIPE_START
M204 S8000
G1 X163.26 Y184.303 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X162.205 Y191.863 Z2.4 F60000
G1 X162.14 Y192.325 Z2.4
G1 Z2
G1 E.8 F1800
G1 F9547.055
M204 S5000
G1 X162.14 Y186.665 E.16859
G1 X165.26 Y186.665 E.09293
G1 X165.26 Y192.325 E.16859
G1 X162.2 Y192.325 E.09115
; COOLING_NODE: 11
; WIPE_START
M204 S8000
G1 X162.179 Y190.325 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X169.71 Y189.083 Z2.4 F60000
G1 X175.705 Y188.095 Z2.4
G1 Z2
G1 E.8 F1800
G1 F9547.055
M204 S5000
G1 X175.705 Y192.305 E.1254
G1 X171.445 Y192.305 E.12689
G1 X171.445 Y188.095 E.1254
G1 X175.645 Y188.095 E.1251
; COOLING_NODE: 5
; WIPE_START
M204 S8000
G1 X175.673 Y190.095 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X180.334 Y196.139 Z2.4 F60000
G1 X184.432 Y201.454 Z2.4
G1 Z2
G1 E.8 F1800
G1 F9547.055
M204 S5000
G1 X184.641 Y201.31 E.00753
G3 X185.157 Y201.147 I.659 J1.189 E.01623
G1 X185.283 Y201.14 E.00376
G3 X184.386 Y201.492 I.017 J1.359 E.22508
; COOLING_NODE: 12
; WIPE_START
M204 S8000
G1 X184.641 Y201.31 E-.11881
G1 X184.881 Y201.206 E-.09959
G1 X185.157 Y201.147 E-.10712
G1 X185.283 Y201.14 E-.04794
G1 X185.559 Y201.165 E-.10547
G1 X185.808 Y201.238 E-.09878
G1 X186.041 Y201.359 E-.09952
G1 X186.211 Y201.495 E-.08277
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X184.36 Y194.09 Z2.4 F60000
G1 X168.77 Y131.72 Z2.4
G1 Z2
G1 E.8 F1800
G1 F1483
M204 S5000
G1 X168.77 Y127.71 E.11944
G1 X189.69 Y127.71 E.62314
G1 X189.69 Y146.11 E.54807
G1 X190.29 Y146.11 E.01787
G1 X190.29 Y182.89 E1.09555
G1 X189.69 Y182.89 E.01787
G1 X189.69 Y209.79 E.80126
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

G1 X180.435 Y209.79 E.27568
G1 X180.435 Y193.99 E.47063
G1 X159.71 Y193.99 E.61733
G1 X159.71 Y131.72 E1.85481
G1 X168.71 Y131.72 E.26808
; WIPE_START
G1 F9547.055
M204 S8000
M73 P79 R4
G1 X168.74 Y129.72 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X166.95 Y132.028 Z2.4 F60000
G1 Z2
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.26667
G1 F15000
M204 S8000
G1 X159.906 Y132.028 E.12449
; WIPE_START
G1 X161.906 Y132.028 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X164.435 Y139.229 Z2.4 F60000
G1 X189.142 Y209.583 Z2.4
G1 Z2
G1 E.8 F1800
; FEATURE: Top surface
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S2000
G1 X189.483 Y209.242 E.01437
G1 X189.616 Y209.108
G1 X189.616 Y208.575
G1 X189.483 Y208.708
G1 X188.608 Y209.583 E.03683
G1 X188.475 Y209.716
G1 X187.941 Y209.716
G1 X188.075 Y209.583
G1 X189.483 Y208.175 E.05929
G1 X189.616 Y208.041
G1 X189.616 Y207.508
G1 X189.483 Y207.642
G1 X187.542 Y209.583 E.08176
G1 X187.408 Y209.716
G1 X186.875 Y209.716
G1 X187.009 Y209.583
G1 X189.483 Y207.109 E.10422
G1 X189.616 Y206.975
G1 X189.616 Y206.442
G1 X189.483 Y206.575
G1 X186.475 Y209.583 E.12668
G1 X186.342 Y209.716
G1 X185.808 Y209.716
G1 X185.942 Y209.583
G1 X189.483 Y206.042 E.14915
G1 X189.616 Y205.908
G1 X189.616 Y205.375
G1 X189.483 Y205.509
G1 X185.409 Y209.583 E.17161
G1 X185.275 Y209.716
G1 X184.742 Y209.716
G1 X184.876 Y209.583
G1 X189.483 Y204.976 E.19407
G1 X189.616 Y204.842
G1 X189.616 Y204.309
G1 X189.483 Y204.442
G1 X184.342 Y209.583 E.21654
G1 X184.209 Y209.716
G1 X183.675 Y209.716
G1 X183.809 Y209.583
G1 X189.483 Y203.909 E.239
G1 X189.616 Y203.775
G1 X189.616 Y203.242
G1 X189.483 Y203.376
G1 X183.276 Y209.583 E.26146
G1 X183.142 Y209.716
G1 X182.609 Y209.716
G1 X182.742 Y209.583
G1 X189.483 Y202.842 E.28393
G1 X189.616 Y202.709
G1 X189.616 Y202.176
G1 X189.483 Y202.309
G1 X182.209 Y209.583 E.30639
G1 X182.076 Y209.716
G1 X181.542 Y209.716
G1 X181.676 Y209.583
G1 X189.483 Y201.776 E.32885
G1 X189.616 Y201.642
G1 X189.616 Y201.109
G1 X189.483 Y201.243
G1 X181.143 Y209.583 E.35132
G1 X181.009 Y209.716
G1 X180.509 Y209.683
G1 X180.642 Y209.55
G1 X189.483 Y200.709 E.37239
G1 X189.616 Y200.576
G1 X189.616 Y200.043
G1 X189.483 Y200.176
G1 X186.831 Y202.827 E.11168
G1 X186.698 Y202.961
G1 X186.717 Y202.409
G1 X186.85 Y202.275
G1 X189.483 Y199.643 E.11088
G1 X189.616 Y199.509
G1 X189.616 Y198.976
G1 X189.483 Y199.11
G1 X186.731 Y201.862 E.11592
G1 X186.597 Y201.995
G1 X186.396 Y201.663
G1 X186.53 Y201.529
G1 X189.483 Y198.576 E.1244
G1 X189.616 Y198.443
G1 X189.616 Y197.91
G1 X189.483 Y198.043
G1 X186.262 Y201.264 E.13566
G1 X186.129 Y201.397
G1 X185.794 Y201.198
G1 X185.928 Y201.065
G1 X189.483 Y197.51 E.14975
G1 X189.616 Y197.376
G1 X189.616 Y196.843
G1 X189.483 Y196.977
G1 X185.511 Y200.948 E.16731
G1 X185.377 Y201.082
G1 X184.821 Y201.105
G1 X184.955 Y200.972
G1 X189.483 Y196.443 E.19074
; WIPE_START
M204 S8000
G1 X188.068 Y197.858 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X185.625 Y204.034 Z2.4 F60000
G1 Z2
G1 E.8 F1800
G1 F9547.055
M204 S2000
G1 X180.642 Y209.016 E.2099
G1 X180.509 Y209.15
G1 X180.509 Y208.617
G1 X180.642 Y208.483
G1 X185.076 Y204.05 E.18674
G1 X185.209 Y203.916
G1 X184.796 Y203.796
G1 X184.662 Y203.93
G1 X180.642 Y207.95 E.16933
G1 X180.509 Y208.084
G1 X180.509 Y207.55
G1 X180.642 Y207.417
G1 X184.328 Y203.731 E.15528
G1 X184.462 Y203.597
G1 X184.197 Y203.328
G1 X184.064 Y203.462
G1 X180.642 Y206.883 E.14413
G1 X180.509 Y207.017
G1 X180.509 Y206.484
G1 X180.642 Y206.35
G1 X183.864 Y203.128 E.13571
G1 X183.998 Y202.995
G1 X183.881 Y202.578
G1 X183.747 Y202.712
G1 X180.642 Y205.817 E.1308
G1 X180.509 Y205.951
G1 X180.509 Y205.417
G1 X180.642 Y205.284
G1 X183.773 Y202.153 E.13186
; WIPE_START
M204 S8000
G1 X182.358 Y203.568 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X180.642 Y204.75 Z2.4 F60000
G1 Z2
G1 E.8 F1800
G1 F9547.055
M204 S2000
G1 X189.483 Y195.91 E.37239
G1 X189.616 Y195.777
G1 X189.616 Y195.243
G1 X189.483 Y195.377
G1 X180.642 Y204.217 E.37239
G1 X180.509 Y204.351
G1 X180.509 Y203.817
G1 X180.642 Y203.684
G1 X189.483 Y194.844 E.37239
G1 X189.616 Y194.71
G1 X189.616 Y194.177
G1 X189.483 Y194.31
G1 X180.642 Y203.151 E.37239
G1 X180.509 Y203.284
G1 X180.509 Y202.751
G1 X180.642 Y202.617
G1 X189.483 Y193.777 E.37239
G1 X189.616 Y193.643
G1 X189.616 Y193.11
G1 X189.483 Y193.244
G1 X180.642 Y202.084 E.37239
G1 X180.509 Y202.218
G1 X180.509 Y201.684
G1 X180.642 Y201.551
G1 X189.483 Y192.711 E.37239
G1 X189.616 Y192.577
G1 X189.616 Y192.044
G1 X189.483 Y192.177
G1 X180.642 Y201.018 E.37239
G1 X180.509 Y201.151
G1 X180.509 Y200.618
G1 X180.642 Y200.484
G1 X189.483 Y191.644 E.37239
G1 X189.616 Y191.51
G1 X189.616 Y190.977
G1 X189.483 Y191.111
G1 X180.642 Y199.951 E.37239
G1 X180.509 Y200.085
G1 X180.509 Y199.551
G1 X180.642 Y199.418
G1 X189.483 Y190.578 E.37239
G1 X189.616 Y190.444
G1 X189.616 Y189.911
G1 X189.483 Y190.044
G1 X180.642 Y198.885 E.37239
G1 X180.509 Y199.018
G1 X180.509 Y198.485
G1 X180.642 Y198.351
G1 X189.483 Y189.511 E.37239
G1 X189.616 Y189.377
G1 X189.616 Y188.844
G1 X189.483 Y188.978
G1 X180.642 Y197.818 E.37239
G1 X180.509 Y197.952
G1 X180.509 Y197.418
G1 X180.642 Y197.285
G1 X189.483 Y188.445 E.37239
G1 X189.616 Y188.311
G1 X189.616 Y187.778
G1 X189.483 Y187.911
G1 X180.642 Y196.752 E.37239
G1 X180.509 Y196.885
G1 X180.509 Y196.352
G1 X180.642 Y196.218
G1 X189.483 Y187.378 E.37239
G1 X189.616 Y187.244
G1 X189.616 Y186.711
G1 X189.483 Y186.845
G1 X180.642 Y195.685 E.37239
G1 X180.509 Y195.819
G1 X180.509 Y195.285
G1 X180.642 Y195.152
G1 X189.483 Y186.312 E.37239
G1 X189.616 Y186.178
G1 X189.616 Y185.645
G1 X189.483 Y185.778
G1 X180.642 Y194.618 E.37239
G1 X180.509 Y194.752
G1 X180.509 Y194.219
G1 X180.642 Y194.085
G1 X189.483 Y185.245 E.37239
G1 X189.616 Y185.111
G1 X189.616 Y184.578
G1 X189.483 Y184.712
G1 X180.412 Y193.783 E.38211
G1 X180.278 Y193.916
G1 X179.745 Y193.916
G1 X179.878 Y193.783
G1 X189.483 Y184.178 E.40457
G1 X189.616 Y184.045
G1 X189.616 Y183.512
G1 X189.483 Y183.645
G1 X179.345 Y193.783 E.42703
G1 X179.212 Y193.916
G1 X178.678 Y193.916
G1 X178.812 Y193.783
G1 X189.483 Y183.112 E.4495
; WIPE_START
M204 S8000
G1 X188.068 Y184.526 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X190.083 Y181.979 Z2.4 F60000
G1 Z2
G1 E.8 F1800
G1 F9547.055
M204 S2000
G1 X178.279 Y193.783 E.49723
G1 X178.145 Y193.916
G1 X177.612 Y193.916
G1 X177.745 Y193.783
G1 X190.083 Y181.445 E.5197
G1 X190.216 Y181.312
G1 X190.216 Y180.779
G1 X190.083 Y180.912
G1 X177.212 Y193.783 E.54216
G1 X177.079 Y193.916
G1 X176.545 Y193.916
G1 X176.679 Y193.783
G1 X190.083 Y180.379 E.56462
G1 X190.216 Y180.245
G1 X190.216 Y179.712
G1 X190.083 Y179.846
G1 X188.732 Y181.196 E.05688
G1 X188.599 Y181.33
G1 X188.599 Y180.796
G1 X188.732 Y180.663
G1 X190.083 Y179.312 E.05688
G1 X190.216 Y179.179
G1 X190.216 Y178.646
G1 X190.083 Y178.779
G1 X188.732 Y180.129 E.05688
G1 X188.599 Y180.263
G1 X188.599 Y179.73
G1 X188.732 Y179.596
G1 X190.083 Y178.246 E.05688
G1 X190.216 Y178.112
G1 X190.216 Y177.579
G1 X190.083 Y177.713
G1 X188.732 Y179.063 E.05688
G1 X188.599 Y179.197
G1 X188.599 Y178.663
G1 X188.732 Y178.53
G1 X190.083 Y177.179 E.05688
G1 X190.216 Y177.046
G1 X190.216 Y176.512
G1 X190.083 Y176.646
G1 X188.732 Y177.996 E.05688
G1 X188.599 Y178.13
G1 X188.599 Y177.597
G1 X188.732 Y177.463
G1 X190.083 Y176.113 E.05688
G1 X190.216 Y175.979
G1 X190.216 Y175.446
G1 X190.083 Y175.58
G1 X188.732 Y176.93 E.05688
G1 X188.599 Y177.063
G1 X188.599 Y176.53
G1 X188.732 Y176.397
G1 X190.083 Y175.046 E.05688
G1 X190.216 Y174.913
G1 X190.216 Y174.379
G1 X190.083 Y174.513
G1 X188.732 Y175.863 E.05688
G1 X188.599 Y175.997
G1 X188.599 Y175.464
G1 X188.732 Y175.33
G1 X190.083 Y173.98 E.05688
G1 X190.216 Y173.846
G1 X190.216 Y173.313
G1 X190.083 Y173.447
G1 X188.732 Y174.797 E.05688
G1 X188.599 Y174.93
G1 X188.599 Y174.397
G1 X188.732 Y174.264
G1 X190.083 Y172.913 E.05688
M73 P80 R4
G1 X190.216 Y172.78
G1 X190.216 Y172.246
G1 X190.083 Y172.38
G1 X188.732 Y173.73 E.05688
G1 X188.599 Y173.864
G1 X188.599 Y173.331
G1 X188.732 Y173.197
G1 X190.083 Y171.847 E.05688
G1 X190.216 Y171.713
G1 X190.216 Y171.18
G1 X190.083 Y171.314
G1 X188.732 Y172.664 E.05688
G1 X188.599 Y172.797
G1 X188.599 Y172.264
G1 X188.732 Y172.131
G1 X190.083 Y170.78 E.05688
G1 X190.216 Y170.647
G1 X190.216 Y170.113
G1 X190.083 Y170.247
G1 X188.732 Y171.597 E.05688
G1 X188.599 Y171.731
G1 X188.599 Y171.198
G1 X188.732 Y171.064
G1 X190.083 Y169.714 E.05688
G1 X190.216 Y169.58
G1 X190.216 Y169.047
G1 X190.083 Y169.181
G1 X188.732 Y170.531 E.05688
G1 X188.599 Y170.664
G1 X188.599 Y170.131
G1 X188.732 Y169.998
G1 X190.083 Y168.647 E.05688
G1 X190.216 Y168.514
G1 X190.216 Y167.98
G1 X190.083 Y168.114
G1 X188.732 Y169.464 E.05688
G1 X188.599 Y169.598
G1 X188.599 Y169.065
G1 X188.732 Y168.931
G1 X190.083 Y167.581 E.05688
G1 X190.216 Y167.447
G1 X190.216 Y166.914
G1 X190.083 Y167.048
G1 X188.732 Y168.398 E.05688
G1 X188.599 Y168.531
G1 X188.599 Y167.998
G1 X188.732 Y167.864
G1 X190.083 Y166.514 E.05688
G1 X190.216 Y166.381
G1 X190.216 Y165.847
G1 X190.083 Y165.981
G1 X188.732 Y167.331 E.05688
G1 X188.599 Y167.465
G1 X188.599 Y166.932
G1 X188.732 Y166.798
G1 X190.083 Y165.448 E.05688
G1 X190.216 Y165.314
G1 X190.216 Y164.781
G1 X190.083 Y164.914
G1 X188.732 Y166.265 E.05688
G1 X188.599 Y166.398
G1 X188.599 Y165.865
G1 X188.732 Y165.731
G1 X190.083 Y164.381 E.05688
G1 X190.216 Y164.248
G1 X190.216 Y163.714
G1 X190.083 Y163.848
G1 X188.732 Y165.198 E.05688
G1 X188.599 Y165.332
G1 X188.599 Y164.799
G1 X188.732 Y164.665
G1 X190.083 Y163.315 E.05688
G1 X190.216 Y163.181
G1 X190.216 Y162.648
G1 X190.083 Y162.781
G1 X188.732 Y164.132 E.05688
G1 X188.599 Y164.265
G1 X188.599 Y163.732
G1 X188.732 Y163.598
G1 X190.083 Y162.248 E.05688
G1 X190.216 Y162.115
G1 X190.216 Y161.581
G1 X190.083 Y161.715
G1 X188.732 Y163.065 E.05688
G1 X188.599 Y163.199
G1 X188.599 Y162.666
G1 X188.732 Y162.532
G1 X190.083 Y161.182 E.05688
G1 X190.216 Y161.048
G1 X190.216 Y160.515
G1 X190.083 Y160.648
G1 X188.732 Y161.999 E.05688
G1 X188.599 Y162.132
G1 X188.599 Y161.599
G1 X188.732 Y161.465
G1 X190.083 Y160.115 E.05688
G1 X190.216 Y159.982
G1 X190.216 Y159.448
G1 X190.083 Y159.582
G1 X188.732 Y160.932 E.05688
G1 X188.599 Y161.066
G1 X188.599 Y160.533
G1 X188.732 Y160.399
G1 X190.083 Y159.049 E.05688
G1 X190.216 Y158.915
G1 X190.216 Y158.382
G1 X190.083 Y158.515
G1 X188.732 Y159.866 E.05688
G1 X188.599 Y159.999
G1 X188.599 Y159.466
G1 X188.732 Y159.332
G1 X190.083 Y157.982 E.05688
G1 X190.216 Y157.848
G1 X190.216 Y157.315
G1 X190.083 Y157.449
G1 X188.732 Y158.799 E.05688
G1 X188.599 Y158.933
G1 X188.599 Y158.399
G1 X188.732 Y158.266
G1 X190.083 Y156.916 E.05688
G1 X190.216 Y156.782
G1 X190.216 Y156.249
G1 X190.083 Y156.382
G1 X188.732 Y157.733 E.05688
G1 X188.599 Y157.866
G1 X188.599 Y157.333
G1 X188.732 Y157.199
G1 X190.083 Y155.849 E.05688
G1 X190.216 Y155.715
G1 X190.216 Y155.182
G1 X190.083 Y155.316
G1 X188.732 Y156.666 E.05688
G1 X188.599 Y156.8
G1 X188.599 Y156.266
G1 X188.732 Y156.133
G1 X190.083 Y154.783 E.05688
G1 X190.216 Y154.649
G1 X190.216 Y154.116
G1 X190.083 Y154.249
G1 X188.732 Y155.6 E.05688
G1 X188.599 Y155.733
G1 X188.599 Y155.2
G1 X188.732 Y155.066
G1 X190.083 Y153.716 E.05688
G1 X190.216 Y153.582
G1 X190.216 Y153.049
G1 X190.083 Y153.183
G1 X188.732 Y154.533 E.05688
G1 X188.599 Y154.667
G1 X188.599 Y154.133
G1 X188.732 Y154
G1 X190.083 Y152.65 E.05688
G1 X190.216 Y152.516
G1 X190.216 Y151.983
G1 X190.083 Y152.116
G1 X188.732 Y153.467 E.05688
G1 X188.599 Y153.6
G1 X188.599 Y153.067
G1 X188.732 Y152.933
G1 X190.083 Y151.583 E.05688
G1 X190.216 Y151.449
G1 X190.216 Y150.916
G1 X190.083 Y151.05
G1 X188.732 Y152.4 E.05688
G1 X188.599 Y152.534
G1 X188.599 Y152
G1 X188.732 Y151.867
G1 X190.083 Y150.517 E.05688
G1 X190.216 Y150.383
G1 X190.216 Y149.85
G1 X190.083 Y149.983
G1 X188.732 Y151.333 E.05688
G1 X188.599 Y151.467
G1 X188.599 Y150.934
G1 X188.732 Y150.8
G1 X190.083 Y149.45 E.05688
G1 X190.216 Y149.316
G1 X190.216 Y148.783
G1 X190.083 Y148.917
G1 X188.732 Y150.267 E.05688
G1 X188.599 Y150.401
G1 X188.599 Y149.867
G1 X188.732 Y149.734
G1 X190.083 Y148.383 E.05688
G1 X190.216 Y148.25
G1 X190.216 Y147.717
G1 X190.083 Y147.85
G1 X188.732 Y149.2 E.05688
G1 X188.599 Y149.334
G1 X188.599 Y148.801
G1 X188.732 Y148.667
G1 X190.083 Y147.317 E.05688
G1 X190.216 Y147.183
G1 X190.216 Y146.65
G1 X190.083 Y146.784
G1 X188.732 Y148.134 E.05688
G1 X188.599 Y148.268
G1 X188.599 Y147.734
G1 X188.732 Y147.601
G1 X190.016 Y146.317 E.05406
G1 X190.149 Y146.184
G1 X189.616 Y146.184
G1 X189.483 Y146.317
G1 X188.302 Y147.498 E.04972
G1 X188.169 Y147.631
G1 X187.635 Y147.631
G1 X187.769 Y147.498
G1 X189.483 Y145.784 E.07219
G1 X189.616 Y145.65
G1 X189.616 Y145.117
G1 X189.483 Y145.251
G1 X187.236 Y147.498 E.09465
G1 X187.102 Y147.631
G1 X186.569 Y147.631
G1 X186.702 Y147.498
G1 X189.483 Y144.717 E.11711
G1 X189.616 Y144.584
G1 X189.616 Y144.051
G1 X189.483 Y144.184
G1 X186.169 Y147.498 E.13958
G1 X186.036 Y147.631
G1 X185.502 Y147.631
G1 X185.636 Y147.498
G1 X189.483 Y143.651 E.16204
G1 X189.616 Y143.517
G1 X189.616 Y142.984
G1 X189.483 Y143.118
G1 X185.103 Y147.498 E.1845
G1 X184.969 Y147.631
G1 X184.436 Y147.631
G1 X184.569 Y147.498
G1 X189.483 Y142.584 E.20697
G1 X189.616 Y142.451
G1 X189.616 Y141.918
G1 X189.483 Y142.051
G1 X184.036 Y147.498 E.22943
G1 X183.903 Y147.631
G1 X183.369 Y147.631
G1 X183.503 Y147.498
G1 X189.483 Y141.518 E.25189
G1 X189.616 Y141.384
G1 X189.616 Y140.851
G1 X189.483 Y140.985
G1 X182.97 Y147.498 E.27436
; WIPE_START
M204 S8000
G1 X184.384 Y146.083 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X185.247 Y153.667 Z2.4 F60000
G1 X188.416 Y181.512 Z2.4
G1 Z2
G1 E.8 F1800
G1 F9547.055
M204 S2000
G1 X176.146 Y193.783 E.51688
G1 X176.012 Y193.916
G1 X175.479 Y193.916
G1 X175.612 Y193.783
G1 X187.883 Y181.512 E.51688
G1 X188.016 Y181.379
G1 X187.483 Y181.379
G1 X187.349 Y181.512
G1 X175.079 Y193.783 E.51688
G1 X174.946 Y193.916
G1 X174.412 Y193.916
G1 X174.546 Y193.783
G1 X175.816 Y192.512 E.05351
G1 X175.95 Y192.379
G1 X175.417 Y192.379
G1 X175.283 Y192.512
G1 X174.013 Y193.783 E.05351
G1 X173.879 Y193.916
G1 X173.346 Y193.916
G1 X173.479 Y193.783
G1 X174.75 Y192.512 E.05351
G1 X174.883 Y192.379
G1 X174.35 Y192.379
G1 X174.216 Y192.512
G1 X172.946 Y193.783 E.05351
G1 X172.812 Y193.916
G1 X172.279 Y193.916
G1 X172.413 Y193.783
G1 X173.683 Y192.512 E.05351
G1 X173.817 Y192.379
G1 X173.283 Y192.379
G1 X173.15 Y192.512
G1 X171.88 Y193.783 E.05351
G1 X171.746 Y193.916
G1 X171.213 Y193.916
G1 X171.346 Y193.783
G1 X172.617 Y192.512 E.05351
G1 X172.75 Y192.379
G1 X172.217 Y192.379
G1 X172.083 Y192.512
G1 X170.813 Y193.783 E.05351
G1 X170.679 Y193.916
G1 X170.146 Y193.916
G1 X170.28 Y193.783
G1 X171.55 Y192.512 E.05351
G1 X171.684 Y192.379
G1 X171.371 Y192.158
G1 X171.238 Y192.292
G1 X169.747 Y193.783 E.06281
G1 X169.613 Y193.916
G1 X169.08 Y193.916
G1 X169.213 Y193.783
G1 X171.238 Y191.758 E.08527
G1 X171.371 Y191.625
G1 X171.371 Y191.091
G1 X171.238 Y191.225
G1 X168.68 Y193.783 E.10774
G1 X168.546 Y193.916
G1 X168.013 Y193.916
G1 X168.147 Y193.783
G1 X171.238 Y190.692 E.1302
G1 X171.371 Y190.558
G1 X171.371 Y190.025
G1 X171.238 Y190.159
G1 X167.614 Y193.783 E.15266
G1 X167.48 Y193.916
G1 X166.947 Y193.916
G1 X167.08 Y193.783
G1 X171.238 Y189.625 E.17512
G1 X171.371 Y189.492
G1 X171.371 Y188.958
G1 X171.238 Y189.092
G1 X166.547 Y193.783 E.19759
G1 X166.413 Y193.916
G1 X165.88 Y193.916
G1 X166.014 Y193.783
G1 X171.238 Y188.559 E.22005
G1 X171.371 Y188.425
G1 X171.371 Y187.892
G1 X171.238 Y188.026
G1 X165.481 Y193.783 E.24251
; WIPE_START
M204 S8000
G1 X166.895 Y192.368 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X174.527 Y192.409 Z2.4 F60000
G1 X175.912 Y192.416 Z2.4
G1 Z2
G1 E.8 F1800
G1 F9547.055
M204 S2000
G1 X186.816 Y181.512 E.45932
G1 X186.95 Y181.379
G1 X186.417 Y181.379
G1 X186.283 Y181.512
G1 X175.912 Y191.883 E.43685
G1 X175.779 Y192.017
G1 X175.779 Y191.483
G1 X175.912 Y191.35
G1 X185.75 Y181.512 E.41439
G1 X185.883 Y181.379
G1 X185.35 Y181.379
G1 X185.216 Y181.512
G1 X175.912 Y190.816 E.39193
G1 X175.779 Y190.95
G1 X175.779 Y190.417
G1 X175.912 Y190.283
G1 X184.683 Y181.512 E.36946
G1 X184.817 Y181.379
G1 X184.283 Y181.379
G1 X184.15 Y181.512
G1 X175.912 Y189.75 E.347
G1 X175.779 Y189.883
G1 X175.779 Y189.35
G1 X175.912 Y189.217
G1 X183.617 Y181.512 E.32454
G1 X183.75 Y181.379
G1 X183.217 Y181.379
G1 X183.083 Y181.512
G1 X175.912 Y188.683 E.30207
G1 X175.779 Y188.817
G1 X175.779 Y188.284
G1 X175.912 Y188.15
G1 X182.658 Y181.405 E.28414
G1 X182.791 Y181.271
G1 X182.791 Y180.738
G1 X182.658 Y180.872
G1 X175.642 Y187.888 E.29555
G1 X175.508 Y188.021
G1 X174.975 Y188.021
G1 X175.108 Y187.888
G1 X182.658 Y180.338 E.31801
G1 X182.791 Y180.205
G1 X182.791 Y179.671
G1 X182.658 Y179.805
G1 X174.575 Y187.888 E.34047
G1 X174.441 Y188.021
G1 X173.908 Y188.021
G1 X174.042 Y187.888
G1 X182.658 Y179.272 E.36294
G1 X182.791 Y179.138
G1 X182.791 Y178.605
G1 X182.658 Y178.739
G1 X173.509 Y187.888 E.3854
G1 X173.375 Y188.021
G1 X172.842 Y188.021
G1 X172.975 Y187.888
G1 X182.658 Y178.205 E.40786
G1 X182.791 Y178.072
G1 X182.791 Y177.538
G1 X182.658 Y177.672
G1 X172.442 Y187.888 E.43033
G1 X172.308 Y188.021
G1 X171.775 Y188.021
G1 X171.909 Y187.888
G1 X182.658 Y177.139 E.45279
G1 X182.791 Y177.005
G1 X182.791 Y176.472
G1 X182.658 Y176.606
G1 X171.376 Y187.888 E.47525
; WIPE_START
M204 S8000
G1 X172.79 Y186.473 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X167.206 Y191.677 Z2.4 F60000
G1 X164.947 Y193.783 Z2.4
G1 Z2
G1 E.8 F1800
G1 F9547.055
M204 S2000
G1 X182.658 Y176.072 E.74604
G1 X182.791 Y175.939
G1 X182.791 Y175.405
G1 X182.658 Y175.539
G1 X164.414 Y193.783 E.7685
G1 X164.28 Y193.916
G1 X163.747 Y193.916
G1 X163.881 Y193.783
G1 X165.131 Y192.532 E.05267
G1 X165.265 Y192.399
G1 X164.731 Y192.399
G1 X164.598 Y192.532
G1 X163.347 Y193.783 E.05267
G1 X163.214 Y193.916
G1 X162.681 Y193.916
G1 X162.814 Y193.783
G1 X164.064 Y192.532 E.05267
G1 X164.198 Y192.399
G1 X163.665 Y192.399
G1 X163.531 Y192.532
G1 X162.281 Y193.783 E.05267
G1 X162.147 Y193.916
G1 X161.614 Y193.916
G1 X161.748 Y193.783
G1 X162.998 Y192.532 E.05267
G1 X163.132 Y192.399
G1 X162.598 Y192.399
G1 X162.465 Y192.532
G1 X161.214 Y193.783 E.05267
G1 X161.081 Y193.916
G1 X160.548 Y193.916
G1 X160.681 Y193.783
G1 X161.933 Y192.531 E.05272
G1 X162.066 Y192.398
G1 X162.066 Y191.864
G1 X161.933 Y191.998
G1 X160.148 Y193.783 E.07518
G1 X160.014 Y193.916
G1 X159.784 Y193.614
G1 X159.917 Y193.48
G1 X161.933 Y191.465 E.08489
G1 X162.066 Y191.331
G1 X162.066 Y190.798
G1 X161.933 Y190.931
G1 X159.917 Y192.947 E.08489
G1 X159.784 Y193.08
G1 X159.784 Y192.547
G1 X159.917 Y192.413
G1 X161.933 Y190.398 E.08489
G1 X162.066 Y190.265
G1 X162.066 Y189.731
G1 X161.933 Y189.865
G1 X159.917 Y191.88 E.08489
G1 X159.784 Y192.014
G1 X159.784 Y191.481
G1 X159.917 Y191.347
G1 X161.933 Y189.332 E.08489
G1 X162.066 Y189.198
G1 X162.066 Y188.665
G1 X161.933 Y188.798
G1 X159.917 Y190.814 E.08489
G1 X159.784 Y190.947
G1 X159.784 Y190.414
G1 X159.917 Y190.28
G1 X161.933 Y188.265 E.08489
G1 X162.066 Y188.132
G1 X162.066 Y187.598
G1 X161.933 Y187.732
G1 X159.917 Y189.747 E.08489
G1 X159.784 Y189.881
G1 X159.784 Y189.348
G1 X159.917 Y189.214
G1 X161.933 Y187.199 E.08489
G1 X162.066 Y187.065
G1 X162.066 Y186.532
G1 X161.933 Y186.665
G1 X159.917 Y188.681 E.08489
; WIPE_START
M204 S8000
G1 X161.332 Y187.266 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X165.467 Y192.196 Z2.4 F60000
G1 Z2
G1 E.8 F1800
G1 F9547.055
M204 S2000
G1 X182.658 Y175.006 E.72413
G1 X182.791 Y174.872
G1 X182.791 Y174.339
G1 X182.658 Y174.472
G1 X165.467 Y191.663 E.72413
G1 X165.334 Y191.796
G1 X165.334 Y191.263
G1 X165.467 Y191.129
G1 X182.658 Y173.939 E.72413
G1 X182.791 Y173.806
G1 X182.791 Y173.272
M73 P81 R4
G1 X182.658 Y173.406
G1 X165.467 Y190.596 E.72413
G1 X165.334 Y190.73
G1 X165.334 Y190.197
G1 X165.467 Y190.063
G1 X182.658 Y172.873 E.72413
G1 X182.791 Y172.739
G1 X182.791 Y172.206
G1 X182.658 Y172.339
G1 X165.467 Y189.53 E.72413
G1 X165.334 Y189.663
G1 X165.334 Y189.13
G1 X165.467 Y188.996
G1 X182.658 Y171.806 E.72413
G1 X182.791 Y171.673
G1 X182.791 Y171.139
G1 X182.658 Y171.273
G1 X165.467 Y188.463 E.72413
G1 X165.334 Y188.597
G1 X165.334 Y188.064
G1 X165.467 Y187.93
G1 X182.658 Y170.74 E.72413
G1 X182.791 Y170.606
G1 X182.791 Y170.073
G1 X182.658 Y170.206
G1 X165.467 Y187.397 E.72413
G1 X165.334 Y187.53
G1 X165.334 Y186.997
G1 X165.467 Y186.863
G1 X182.658 Y169.673 E.72413
G1 X182.791 Y169.54
G1 X182.791 Y169.006
G1 X182.658 Y169.14
G1 X165.34 Y186.458 E.7295
G1 X165.206 Y186.591
G1 X164.673 Y186.591
G1 X164.807 Y186.458
G1 X182.658 Y168.607 E.75196
G1 X182.791 Y168.473
G1 X182.791 Y167.94
G1 X182.658 Y168.073
G1 X164.273 Y186.458 E.77443
G1 X164.14 Y186.591
G1 X163.606 Y186.591
G1 X163.74 Y186.458
M73 P81 R3
G1 X182.658 Y167.54 E.79689
G1 X182.791 Y167.407
G1 X182.791 Y166.873
G1 X182.658 Y167.007
G1 X165.467 Y184.197 E.72413
G1 X165.334 Y184.331
G1 X165.334 Y183.798
G1 X165.467 Y183.664
G1 X182.658 Y166.474 E.72413
G1 X182.791 Y166.34
G1 X182.791 Y165.807
G1 X182.658 Y165.94
G1 X165.467 Y183.131 E.72413
G1 X165.334 Y183.264
G1 X165.334 Y182.731
G1 X165.467 Y182.597
G1 X182.658 Y165.407 E.72413
G1 X182.791 Y165.273
G1 X182.791 Y164.74
G1 X182.658 Y164.874
G1 X165.467 Y182.064 E.72413
G1 X165.334 Y182.198
G1 X165.334 Y181.664
G1 X165.467 Y181.531
G1 X182.658 Y164.341 E.72413
G1 X182.791 Y164.207
G1 X182.791 Y163.674
G1 X182.658 Y163.807
G1 X165.467 Y180.998 E.72413
G1 X165.334 Y181.131
G1 X165.334 Y180.598
G1 X165.467 Y180.464
G1 X182.658 Y163.274 E.72413
G1 X182.791 Y163.14
G1 X182.791 Y162.607
G1 X182.658 Y162.741
G1 X165.467 Y179.931 E.72413
G1 X165.334 Y180.065
G1 X165.334 Y179.531
G1 X165.467 Y179.398
G1 X182.658 Y162.208 E.72413
G1 X182.791 Y162.074
G1 X182.791 Y161.541
G1 X182.658 Y161.674
G1 X165.467 Y178.865 E.72413
G1 X165.334 Y178.998
G1 X165.207 Y178.591
G1 X165.341 Y178.458
G1 X182.658 Y161.141 E.72945
G1 X182.791 Y161.007
G1 X182.791 Y160.474
G1 X182.658 Y160.608
G1 X164.808 Y178.458 E.75192
G1 X164.674 Y178.591
G1 X164.141 Y178.591
G1 X164.275 Y178.458
G1 X182.658 Y160.075 E.77438
G1 X182.791 Y159.941
G1 X182.791 Y159.408
G1 X182.658 Y159.541
G1 X163.741 Y178.458 E.79684
G1 X163.608 Y178.591
G1 X163.074 Y178.591
G1 X163.208 Y178.458
G1 X182.658 Y159.008 E.81931
G1 X182.791 Y158.874
G1 X182.791 Y158.341
G1 X182.658 Y158.475
G1 X162.675 Y178.458 E.84177
G1 X162.541 Y178.591
G1 X162.008 Y178.591
G1 X162.141 Y178.458
G1 X182.658 Y157.942 E.86423
G1 X182.791 Y157.808
G1 X182.791 Y157.275
G1 X182.658 Y157.408
G1 X180.192 Y159.873 E.10385
G1 X180.059 Y160.007
G1 X180.059 Y159.474
G1 X180.192 Y159.34
G1 X182.658 Y156.875 E.10385
G1 X182.791 Y156.741
G1 X182.791 Y156.208
G1 X182.658 Y156.342
G1 X180.192 Y158.807 E.10385
G1 X180.059 Y158.941
G1 X180.059 Y158.407
G1 X180.192 Y158.274
G1 X182.658 Y155.808 E.10385
G1 X182.791 Y155.675
G1 X182.791 Y155.142
G1 X182.658 Y155.275
G1 X180.192 Y157.74 E.10385
G1 X180.059 Y157.874
G1 X180.059 Y157.341
G1 X180.192 Y157.207
G1 X182.658 Y154.742 E.10385
G1 X182.791 Y154.608
G1 X182.791 Y154.075
G1 X182.658 Y154.209
G1 X179.859 Y157.008 E.1179
G1 X179.725 Y157.141
G1 X179.192 Y157.141
G1 X179.325 Y157.008
G1 X182.658 Y153.675 E.14037
G1 X182.791 Y153.542
G1 X182.791 Y153.009
G1 X182.658 Y153.142
G1 X178.792 Y157.008 E.16283
G1 X178.659 Y157.141
G1 X178.125 Y157.141
G1 X178.259 Y157.008
G1 X182.658 Y152.609 E.18529
G1 X182.791 Y152.475
G1 X182.791 Y151.942
G1 X182.658 Y152.076
G1 X177.726 Y157.008 E.20776
G1 X177.592 Y157.141
G1 X177.059 Y157.141
G1 X177.192 Y157.008
G1 X182.658 Y151.542 E.23022
G1 X182.791 Y151.409
G1 X182.791 Y150.876
G1 X182.658 Y151.009
G1 X176.659 Y157.008 E.25268
G1 X176.526 Y157.141
G1 X175.992 Y157.141
G1 X176.126 Y157.008
G1 X182.658 Y150.476 E.27515
; WIPE_START
M204 S8000
G1 X181.243 Y151.89 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X177.865 Y158.734 Z2.4 F60000
G1 X165.132 Y184.532 Z2.4
G1 Z2
G1 E.8 F1800
G1 F9547.055
M204 S2000
G1 X163.207 Y186.458 E.0811
G1 X163.073 Y186.591
G1 X162.54 Y186.591
G1 X162.674 Y186.458
G1 X164.599 Y184.532 E.0811
G1 X164.732 Y184.399
G1 X164.199 Y184.399
G1 X164.066 Y184.532
G1 X162.14 Y186.458 E.0811
; WIPE_START
M204 S8000
G1 X163.555 Y185.043 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X163.532 Y184.532 Z2.4 F60000
G1 Z2
G1 E.8 F1800
G1 F9547.055
M204 S2000
G1 X159.917 Y188.147 E.15228
G1 X159.784 Y188.281
G1 X159.784 Y187.748
G1 X159.917 Y187.614
G1 X162.999 Y184.532 E.12981
G1 X163.133 Y184.399
G1 X162.599 Y184.399
G1 X162.466 Y184.532
G1 X159.917 Y187.081 E.10735
G1 X159.784 Y187.214
G1 X159.784 Y186.681
G1 X159.917 Y186.548
G1 X161.933 Y184.532 E.08489
G1 X162.066 Y184.399
G1 X162.066 Y183.865
G1 X161.933 Y183.999
G1 X159.917 Y186.014 E.08489
G1 X159.784 Y186.148
G1 X159.784 Y185.615
G1 X159.917 Y185.481
G1 X161.933 Y183.466 E.08489
G1 X162.066 Y183.332
G1 X162.066 Y182.799
G1 X161.933 Y182.933
G1 X159.917 Y184.948 E.08489
G1 X159.784 Y185.081
G1 X159.784 Y184.548
G1 X159.917 Y184.415
G1 X161.933 Y182.399 E.08489
G1 X162.066 Y182.266
G1 X162.066 Y181.732
G1 X161.933 Y181.866
G1 X159.917 Y183.881 E.08489
G1 X159.784 Y184.015
G1 X159.784 Y183.482
G1 X159.917 Y183.348
G1 X161.933 Y181.333 E.08489
G1 X162.066 Y181.199
G1 X162.066 Y180.666
G1 X161.933 Y180.8
G1 X159.917 Y182.815 E.08489
G1 X159.784 Y182.948
G1 X159.784 Y182.415
G1 X159.917 Y182.282
G1 X161.933 Y180.266 E.08489
G1 X162.066 Y180.133
G1 X162.066 Y179.599
G1 X161.933 Y179.733
G1 X159.917 Y181.748 E.08489
G1 X159.784 Y181.882
G1 X159.784 Y181.349
G1 X159.917 Y181.215
G1 X161.933 Y179.2 E.08489
G1 X162.066 Y179.066
G1 X162.066 Y178.533
G1 X161.933 Y178.667
G1 X159.917 Y180.682 E.08489
G1 X159.784 Y180.815
G1 X159.784 Y180.282
G1 X159.917 Y180.148
G1 X180.073 Y159.992 E.84907
G1 X180.207 Y159.859
G1 X179.674 Y159.859
G1 X179.54 Y159.992
G1 X159.917 Y179.615 E.8266
G1 X159.784 Y179.749
G1 X159.784 Y179.216
G1 X159.917 Y179.082
G1 X179.007 Y159.992 E.80414
G1 X179.141 Y159.859
G1 X178.607 Y159.859
G1 X178.474 Y159.992
G1 X159.917 Y178.549 E.78168
G1 X159.784 Y178.682
G1 X159.784 Y178.149
G1 X159.917 Y178.015
G1 X177.94 Y159.992 E.75921
G1 X178.074 Y159.859
G1 X177.541 Y159.859
G1 X177.407 Y159.992
G1 X159.917 Y177.482 E.73675
G1 X159.784 Y177.616
G1 X159.784 Y177.083
G1 X159.917 Y176.949
G1 X169.299 Y167.567 E.39519
G1 X169.433 Y167.434
G1 X168.899 Y167.434
G1 X168.766 Y167.567
G1 X159.917 Y176.416 E.37273
G1 X159.784 Y176.549
G1 X159.784 Y176.016
G1 X159.917 Y175.882
G1 X168.232 Y167.567 E.35027
G1 X168.366 Y167.434
G1 X167.833 Y167.434
G1 X167.699 Y167.567
G1 X159.917 Y175.349 E.3278
G1 X159.784 Y175.483
G1 X159.784 Y174.95
G1 X159.917 Y174.816
G1 X167.166 Y167.567 E.30534
G1 X167.3 Y167.434
G1 X166.766 Y167.434
G1 X166.633 Y167.567
G1 X159.917 Y174.283 E.28288
G1 X159.784 Y174.416
G1 X159.784 Y173.883
G1 X159.917 Y173.749
G1 X166.099 Y167.567 E.26041
G1 X166.233 Y167.434
G1 X165.7 Y167.434
G1 X165.566 Y167.567
G1 X159.917 Y173.216 E.23795
G1 X159.784 Y173.35
G1 X159.784 Y172.817
G1 X159.917 Y172.683
M73 P82 R3
G1 X165.033 Y167.567 E.21549
G1 X165.167 Y167.434
G1 X164.633 Y167.434
G1 X164.5 Y167.567
G1 X159.917 Y172.15 E.19302
G1 X159.784 Y172.283
G1 X159.784 Y171.75
G1 X159.917 Y171.616
G1 X163.966 Y167.567 E.17056
G1 X164.1 Y167.434
G1 X163.567 Y167.434
G1 X163.433 Y167.567
G1 X159.917 Y171.083 E.1481
G1 X159.784 Y171.217
G1 X159.784 Y170.683
G1 X159.917 Y170.55
G1 X162.9 Y167.567 E.12563
G1 X163.033 Y167.434
G1 X162.5 Y167.434
G1 X162.367 Y167.567
G1 X159.917 Y170.017 E.10317
G1 X159.784 Y170.15
G1 X159.784 Y169.617
G1 X159.917 Y169.483
G1 X161.833 Y167.567 E.08071
G1 X161.967 Y167.434
G1 X161.79 Y167.077
G1 X161.657 Y167.211
G1 X159.917 Y168.95 E.07326
G1 X159.784 Y169.084
G1 X159.784 Y168.55
G1 X159.917 Y168.417
G1 X161.657 Y166.678 E.07326
G1 X161.79 Y166.544
G1 X161.79 Y166.011
G1 X161.657 Y166.144
G1 X159.917 Y167.884 E.07326
G1 X159.784 Y168.017
G1 X159.784 Y167.484
G1 X159.917 Y167.35
G1 X161.657 Y165.611 E.07326
G1 X161.79 Y165.477
G1 X161.79 Y164.944
G1 X161.657 Y165.078
G1 X159.917 Y166.817 E.07326
G1 X159.784 Y166.951
G1 X159.784 Y166.417
G1 X159.917 Y166.284
G1 X161.657 Y164.545 E.07326
G1 X161.79 Y164.411
G1 X161.79 Y163.878
G1 X161.657 Y164.011
G1 X159.917 Y165.751 E.07326
G1 X159.784 Y165.884
G1 X159.784 Y165.351
G1 X159.917 Y165.217
G1 X161.657 Y163.478 E.07326
G1 X161.79 Y163.344
G1 X161.79 Y162.811
G1 X161.657 Y162.945
G1 X159.917 Y164.684 E.07326
G1 X159.784 Y164.818
G1 X159.784 Y164.284
G1 X159.917 Y164.151
G1 X161.657 Y162.412 E.07326
G1 X161.79 Y162.278
G1 X161.79 Y161.745
G1 X161.657 Y161.878
G1 X159.917 Y163.618 E.07326
G1 X159.784 Y163.751
G1 X159.784 Y163.218
G1 X159.917 Y163.084
G1 X161.657 Y161.345 E.07326
G1 X161.79 Y161.211
G1 X161.79 Y160.678
G1 X161.657 Y160.812
G1 X159.917 Y162.551 E.07326
G1 X159.784 Y162.685
G1 X159.784 Y162.151
G1 X159.917 Y162.018
G1 X161.657 Y160.279 E.07326
; WIPE_START
M204 S8000
G1 X160.242 Y161.693 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X166.864 Y165.489 Z2.4 F60000
G1 X169.732 Y167.134 Z2.4
G1 Z2
G1 E.8 F1800
G1 F9547.055
M204 S2000
G1 X176.874 Y159.992 E.30084
G1 X177.008 Y159.859
G1 X176.474 Y159.859
G1 X176.341 Y159.992
G1 X169.732 Y166.601 E.27837
G1 X169.599 Y166.734
G1 X169.599 Y166.201
G1 X169.732 Y166.067
G1 X175.807 Y159.992 E.25591
G1 X175.941 Y159.859
G1 X175.841 Y159.425
G1 X175.708 Y159.559
G1 X169.732 Y165.534 E.2517
G1 X169.599 Y165.668
G1 X169.599 Y165.135
G1 X169.732 Y165.001
G1 X175.708 Y159.026 E.2517
G1 X175.841 Y158.892
G1 X175.841 Y158.359
G1 X175.708 Y158.492
G1 X169.732 Y164.468 E.2517
G1 X169.599 Y164.601
G1 X169.599 Y164.068
G1 X169.732 Y163.934
G1 X175.708 Y157.959 E.2517
G1 X175.841 Y157.826
G1 X175.841 Y157.292
G1 X175.708 Y157.426
G1 X169.732 Y163.401 E.2517
G1 X169.599 Y163.535
G1 X169.599 Y163.002
G1 X169.732 Y162.868
G1 X182.658 Y149.943 E.54447
G1 X182.791 Y149.809
G1 X182.791 Y149.276
G1 X182.658 Y149.409
G1 X169.732 Y162.335 E.54447
G1 X169.599 Y162.468
G1 X169.599 Y161.935
G1 X169.732 Y161.801
G1 X182.658 Y148.876 E.54447
G1 X182.791 Y148.743
G1 X182.791 Y148.209
G1 X182.658 Y148.343
G1 X169.732 Y161.268 E.54447
G1 X169.599 Y161.402
G1 X169.599 Y160.868
G1 X169.732 Y160.735
G1 X182.658 Y147.81 E.54447
; WIPE_START
M204 S8000
G1 X181.243 Y149.224 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.596 Y154.358 Z2.4 F60000
G1 X175.377 Y154.557 Z2.4
G1 Z2
G1 E.8 F1800
G1 F9547.055
M204 S2000
G1 X189.483 Y140.451 E.59418
G1 X189.616 Y140.318
G1 X189.616 Y139.784
G1 X189.483 Y139.918
G1 X187.917 Y141.483 E.06593
G1 X187.784 Y141.617
G1 X187.784 Y141.084
G1 X187.917 Y140.95
G1 X189.483 Y139.385 E.06593
G1 X189.616 Y139.251
G1 X189.616 Y138.718
G1 X189.483 Y138.852
G1 X187.917 Y140.417 E.06593
G1 X187.784 Y140.55
G1 X187.784 Y140.017
G1 X187.917 Y139.884
G1 X189.483 Y138.318 E.06593
G1 X189.616 Y138.185
G1 X189.616 Y137.651
G1 X189.483 Y137.785
G1 X187.917 Y139.35 E.06593
G1 X187.784 Y139.484
G1 X187.784 Y138.951
G1 X187.917 Y138.817
G1 X189.483 Y137.252 E.06593
G1 X189.616 Y137.118
G1 X189.616 Y136.585
G1 X189.483 Y136.719
G1 X187.917 Y138.284 E.06593
G1 X187.784 Y138.417
G1 X187.402 Y138.266
G1 X187.535 Y138.133
G1 X189.483 Y136.185 E.08203
G1 X189.616 Y136.052
G1 X189.616 Y135.518
G1 X189.483 Y135.652
G1 X187.002 Y138.133 E.10449
G1 X186.868 Y138.266
G1 X186.335 Y138.266
G1 X186.469 Y138.133
G1 X189.483 Y135.119 E.12696
G1 X189.616 Y134.985
G1 X189.616 Y134.452
G1 X189.483 Y134.586
G1 X185.936 Y138.133 E.14942
G1 X185.802 Y138.266
G1 X185.269 Y138.266
G1 X185.402 Y138.133
G1 X189.483 Y134.052 E.17188
G1 X189.616 Y133.919
G1 X189.616 Y133.385
G1 X189.483 Y133.519
G1 X184.869 Y138.133 E.19435
G1 X184.735 Y138.266
G1 X184.202 Y138.266
G1 X184.336 Y138.133
G1 X189.483 Y132.986 E.21681
G1 X189.616 Y132.852
G1 X189.616 Y132.319
G1 X189.483 Y132.453
G1 X183.803 Y138.133 E.23927
G1 X183.669 Y138.266
G1 X183.136 Y138.266
G1 X183.269 Y138.133
G1 X187.484 Y133.917 E.17757
G1 X187.618 Y133.784
G1 X187.085 Y133.784
G1 X186.951 Y133.917
G1 X182.736 Y138.133 E.17756
G1 X182.602 Y138.266
G1 X182.069 Y138.266
G1 X182.203 Y138.133
G1 X186.418 Y133.917 E.17756
G1 X186.552 Y133.784
G1 X186.018 Y133.784
G1 X185.885 Y133.917
G1 X181.669 Y138.133 E.17757
G1 X181.536 Y138.266
G1 X181.003 Y138.266
G1 X181.136 Y138.133
G1 X185.351 Y133.917 E.17757
G1 X185.485 Y133.784
G1 X184.952 Y133.784
G1 X184.818 Y133.917
G1 X180.603 Y138.133 E.17756
G1 X180.469 Y138.266
G1 X179.936 Y138.266
G1 X180.07 Y138.133
G1 X184.285 Y133.917 E.17756
G1 X184.419 Y133.784
G1 X183.885 Y133.784
G1 X183.752 Y133.917
G1 X179.536 Y138.133 E.17757
G1 X179.403 Y138.266
G1 X178.87 Y138.266
G1 X179.003 Y138.133
G1 X183.218 Y133.917 E.17757
G1 X183.352 Y133.784
G1 X182.819 Y133.784
G1 X182.685 Y133.917
G1 X178.47 Y138.133 E.17756
G1 X178.336 Y138.266
G1 X177.803 Y138.266
G1 X177.937 Y138.133
G1 X182.152 Y133.917 E.17756
G1 X182.286 Y133.784
G1 X181.752 Y133.784
G1 X181.619 Y133.917
G1 X177.403 Y138.133 E.17756
; WIPE_START
M204 S8000
G1 X178.818 Y136.718 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X185.363 Y140.645 Z2.4 F60000
G1 X187.483 Y141.917 Z2.4
G1 Z2
G1 E.8 F1800
G1 F9547.055
M204 S2000
G1 X175.377 Y154.023 E.50996
G1 X175.244 Y154.157
G1 X175.244 Y153.624
G1 X175.377 Y153.49
G1 X186.95 Y141.917 E.48749
G1 X187.084 Y141.784
G1 X186.55 Y141.784
G1 X186.417 Y141.917
G1 X175.377 Y152.957 E.46503
G1 X175.244 Y153.09
G1 X175.244 Y152.557
G1 X175.377 Y152.424
G1 X185.884 Y141.917 E.44257
G1 X186.017 Y141.784
G1 X185.484 Y141.784
G1 X185.35 Y141.917
G1 X175.377 Y151.89 E.4201
G1 X175.244 Y152.024
G1 X175.243 Y151.491
G1 X175.377 Y151.358
G1 X184.817 Y141.917 E.39767
G1 X184.951 Y141.784
G1 X184.417 Y141.784
G1 X184.284 Y141.917
G1 X174.844 Y151.358 E.39767
G1 X174.71 Y151.491
G1 X174.177 Y151.491
G1 X174.31 Y151.358
G1 X183.751 Y141.917 E.39767
G1 X183.884 Y141.784
G1 X183.351 Y141.784
G1 X183.217 Y141.917
G1 X173.777 Y151.358 E.39767
G1 X173.643 Y151.491
G1 X173.11 Y151.491
G1 X173.244 Y151.358
G1 X182.684 Y141.917 E.39767
G1 X182.818 Y141.784
G1 X182.284 Y141.784
G1 X182.151 Y141.917
G1 X172.711 Y151.358 E.39767
G1 X172.577 Y151.491
G1 X172.044 Y151.491
G1 X172.177 Y151.358
G1 X181.618 Y141.917 E.39767
G1 X181.751 Y141.784
G1 X181.218 Y141.784
G1 X181.084 Y141.917
G1 X171.644 Y151.358 E.39767
G1 X171.51 Y151.491
G1 X170.977 Y151.491
G1 X171.111 Y151.358
G1 X180.551 Y141.917 E.39767
G1 X180.685 Y141.784
G1 X180.151 Y141.784
G1 X180.018 Y141.917
G1 X170.578 Y151.358 E.39767
G1 X170.444 Y151.491
G1 X169.911 Y151.491
G1 X170.044 Y151.358
G1 X179.484 Y141.917 E.39767
G1 X179.618 Y141.784
G1 X179.085 Y141.784
G1 X178.951 Y141.917
G1 X169.511 Y151.358 E.39767
G1 X169.377 Y151.491
G1 X168.844 Y151.491
G1 X168.978 Y151.358
G1 X178.418 Y141.917 E.39767
G1 X178.552 Y141.784
G1 X178.018 Y141.784
G1 X177.885 Y141.917
G1 X168.444 Y151.358 E.39767
G1 X168.311 Y151.491
G1 X167.778 Y151.491
G1 X167.911 Y151.358
G1 X177.351 Y141.917 E.39767
G1 X177.485 Y141.784
G1 X177.016 Y141.719
G1 X176.883 Y141.853
G1 X167.378 Y151.358 E.40038
; WIPE_START
M204 S8000
G1 X168.792 Y149.943 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X169.464 Y157.546 Z2.4 F60000
G1 X169.701 Y160.233 Z2.4
G1 Z2
G1 E.8 F1800
G1 F9547.055
M204 S2000
G1 X175.302 Y154.632 E.23591
G1 X175.435 Y154.499
G1 X174.902 Y154.499
G1 X174.768 Y154.632
G1 X169.168 Y160.233 E.23591
G1 X169.034 Y160.366
G1 X168.501 Y160.366
G1 X168.635 Y160.233
G1 X174.235 Y154.632 E.23591
G1 X174.369 Y154.499
G1 X173.835 Y154.499
G1 X173.702 Y154.632
G1 X168.102 Y160.233 E.23591
G1 X167.968 Y160.366
G1 X167.435 Y160.366
G1 X167.568 Y160.233
G1 X173.169 Y154.632 E.23591
G1 X173.302 Y154.499
G1 X172.769 Y154.499
G1 X172.635 Y154.632
G1 X167.035 Y160.233 E.23591
G1 X166.901 Y160.366
G1 X166.368 Y160.366
G1 X166.502 Y160.233
G1 X172.102 Y154.632 E.23591
G1 X172.236 Y154.499
G1 X171.702 Y154.499
G1 X171.569 Y154.632
G1 X165.969 Y160.233 E.23591
G1 X165.835 Y160.366
G1 X165.302 Y160.366
G1 X165.435 Y160.233
G1 X171.036 Y154.632 E.23591
G1 X171.169 Y154.499
G1 X170.636 Y154.499
G1 X170.502 Y154.632
G1 X164.902 Y160.233 E.23591
G1 X164.768 Y160.366
G1 X164.235 Y160.366
G1 X164.369 Y160.233
G1 X169.969 Y154.632 E.23591
G1 X170.103 Y154.499
G1 X169.569 Y154.499
G1 X169.436 Y154.632
G1 X163.836 Y160.233 E.23591
G1 X163.702 Y160.366
G1 X163.169 Y160.366
G1 X163.302 Y160.233
G1 X168.903 Y154.632 E.23591
G1 X169.036 Y154.499
G1 X168.503 Y154.499
G1 X168.369 Y154.632
G1 X162.769 Y160.233 E.23591
G1 X162.635 Y160.366
G1 X162.102 Y160.366
G1 X162.236 Y160.233
G1 X167.836 Y154.632 E.23591
G1 X167.97 Y154.499
G1 X167.436 Y154.499
G1 X167.303 Y154.632
G1 X161.702 Y160.233 E.23591
; WIPE_START
M204 S8000
G1 X163.117 Y158.818 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X159.917 Y161.484 Z2.4 F60000
G1 Z2
G1 E.8 F1800
G1 F9547.055
M204 S2000
G1 X167.023 Y154.379 E.2993
G1 X167.156 Y154.246
G1 X167.156 Y153.712
G1 X167.023 Y153.846
M73 P83 R3
G1 X159.917 Y160.951 E.2993
G1 X159.784 Y161.085
G1 X159.784 Y160.552
G1 X159.917 Y160.418
G1 X167.023 Y153.313 E.2993
G1 X167.156 Y153.179
G1 X167.156 Y152.646
G1 X167.023 Y152.779
G1 X159.917 Y159.885 E.2993
G1 X159.784 Y160.018
G1 X159.784 Y159.485
G1 X159.917 Y159.351
G1 X167.023 Y152.246 E.2993
G1 X167.156 Y152.113
G1 X167.156 Y151.579
G1 X167.023 Y151.713
G1 X159.917 Y158.818 E.2993
G1 X159.784 Y158.952
G1 X159.784 Y158.419
G1 X159.917 Y158.285
G1 X176.883 Y141.32 E.71465
G1 X177.016 Y141.186
G1 X177.016 Y140.653
G1 X176.883 Y140.786
G1 X165.467 Y152.202 E.48086
G1 X165.334 Y152.335
G1 X165.334 Y151.802
G1 X165.467 Y151.668
G1 X176.883 Y140.253 E.48086
G1 X177.016 Y140.12
G1 X177.016 Y139.586
G1 X176.883 Y139.72
G1 X165.467 Y151.135 E.48086
G1 X165.334 Y151.269
G1 X165.334 Y150.736
G1 X165.467 Y150.602
G1 X176.883 Y139.187 E.48086
G1 X177.016 Y139.053
G1 X177.016 Y138.52
G1 X176.883 Y138.653
G1 X165.467 Y150.069 E.48086
G1 X165.334 Y150.202
G1 X165.334 Y149.669
G1 X165.467 Y149.535
G1 X181.085 Y133.917 E.6579
G1 X181.219 Y133.784
G1 X180.686 Y133.784
G1 X180.552 Y133.917
G1 X165.467 Y149.002 E.63544
G1 X165.334 Y149.136
G1 X165.334 Y148.603
G1 X165.467 Y148.469
G1 X180.019 Y133.917 E.61298
G1 X180.153 Y133.784
G1 X179.619 Y133.784
G1 X179.486 Y133.917
G1 X165.467 Y147.936 E.59051
G1 X165.334 Y148.069
G1 X165.334 Y147.536
G1 X165.467 Y147.402
G1 X178.952 Y133.917 E.56805
G1 X179.086 Y133.784
G1 X178.553 Y133.784
G1 X178.419 Y133.917
G1 X165.467 Y146.869 E.54559
G1 X165.334 Y147.003
G1 X165.334 Y146.469
G1 X165.467 Y146.336
G1 X177.886 Y133.917 E.52312
G1 X178.019 Y133.784
G1 X177.486 Y133.784
G1 X177.353 Y133.917
G1 X165.467 Y145.803 E.50066
G1 X165.334 Y145.936
G1 X165.334 Y145.403
G1 X165.467 Y145.269
G1 X176.883 Y133.854 E.48086
G1 X177.016 Y133.72
G1 X177.016 Y133.187
G1 X176.883 Y133.321
G1 X165.467 Y144.736 E.48086
G1 X165.334 Y144.87
G1 X165.334 Y144.336
G1 X165.467 Y144.203
G1 X176.883 Y132.788 E.48086
G1 X177.016 Y132.654
G1 X177.016 Y132.121
G1 X176.883 Y132.254
G1 X165.444 Y143.693 E.48183
G1 X165.311 Y143.826
G1 X164.777 Y143.826
G1 X164.911 Y143.693
G1 X176.883 Y131.721 E.5043
G1 X177.016 Y131.587
G1 X177.016 Y131.054
G1 X176.883 Y131.188
G1 X166.367 Y141.703 E.44295
G1 X166.234 Y141.837
G1 X166.234 Y141.303
G1 X166.367 Y141.17
G1 X176.883 Y130.655 E.44295
; WIPE_START
M204 S8000
G1 X175.468 Y132.069 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X183.052 Y132.931 Z2.4 F60000
G1 X187.917 Y133.484 Z2.4
G1 Z2
G1 E.8 F1800
G1 F9547.055
M204 S2000
G1 X189.483 Y131.919 E.06593
G1 X189.616 Y131.786
G1 X189.616 Y131.252
G1 X189.483 Y131.386
G1 X187.917 Y132.951 E.06593
G1 X187.784 Y133.085
G1 X187.784 Y132.552
G1 X187.917 Y132.418
G1 X189.483 Y130.853 E.06593
G1 X189.616 Y130.719
G1 X189.616 Y130.186
G1 X189.483 Y130.319
G1 X187.917 Y131.885 E.06593
G1 X187.784 Y132.018
G1 X187.784 Y131.485
G1 X187.917 Y131.351
G1 X189.483 Y129.786 E.06593
G1 X189.616 Y129.653
G1 X189.616 Y129.119
G1 X189.483 Y129.253
G1 X187.917 Y130.818 E.06593
G1 X187.784 Y130.952
G1 X187.784 Y130.419
G1 X187.917 Y130.285
G1 X189.483 Y128.72 E.06593
G1 X189.616 Y128.586
G1 X189.616 Y128.053
G1 X189.483 Y128.186
G1 X187.536 Y130.133 E.08198
G1 X187.403 Y130.266
G1 X186.87 Y130.266
G1 X187.003 Y130.133
G1 X189.218 Y127.917 E.09332
G1 X189.352 Y127.784
G1 X188.819 Y127.784
G1 X188.685 Y127.917
G1 X186.47 Y130.133 E.09332
G1 X186.336 Y130.266
G1 X185.803 Y130.266
G1 X185.937 Y130.133
G1 X188.152 Y127.917 E.09332
G1 X188.286 Y127.784
G1 X187.752 Y127.784
G1 X187.619 Y127.917
G1 X185.403 Y130.133 E.09332
G1 X185.27 Y130.266
G1 X184.737 Y130.266
G1 X184.87 Y130.133
G1 X187.085 Y127.917 E.09332
G1 X187.219 Y127.784
G1 X186.686 Y127.784
G1 X186.552 Y127.917
G1 X184.337 Y130.133 E.09332
G1 X184.203 Y130.266
G1 X183.67 Y130.266
G1 X183.804 Y130.133
G1 X186.019 Y127.917 E.09332
G1 X186.153 Y127.784
G1 X185.619 Y127.784
G1 X185.486 Y127.917
G1 X183.27 Y130.133 E.09332
G1 X183.137 Y130.266
G1 X182.603 Y130.266
G1 X182.737 Y130.133
G1 X184.952 Y127.917 E.09332
G1 X185.086 Y127.784
G1 X184.553 Y127.784
G1 X184.419 Y127.917
G1 X182.204 Y130.133 E.09332
G1 X182.07 Y130.266
G1 X181.537 Y130.266
G1 X181.671 Y130.133
G1 X183.886 Y127.917 E.09332
G1 X184.019 Y127.784
G1 X183.486 Y127.784
G1 X183.353 Y127.917
G1 X181.137 Y130.133 E.09332
G1 X181.004 Y130.266
G1 X180.47 Y130.266
G1 X180.604 Y130.133
G1 X182.819 Y127.917 E.09332
G1 X182.953 Y127.784
G1 X182.42 Y127.784
G1 X182.286 Y127.917
G1 X180.071 Y130.133 E.09332
G1 X179.937 Y130.266
G1 X179.404 Y130.266
G1 X179.538 Y130.133
G1 X181.753 Y127.917 E.09332
G1 X181.886 Y127.784
G1 X181.353 Y127.784
G1 X181.22 Y127.917
G1 X179.004 Y130.133 E.09332
G1 X178.871 Y130.266
G1 X178.337 Y130.266
G1 X178.471 Y130.133
G1 X180.686 Y127.917 E.09332
G1 X180.82 Y127.784
G1 X180.287 Y127.784
G1 X180.153 Y127.917
G1 X177.938 Y130.133 E.09332
G1 X177.804 Y130.266
G1 X177.271 Y130.266
G1 X177.405 Y130.133
G1 X179.62 Y127.917 E.09332
G1 X179.753 Y127.784
G1 X179.22 Y127.784
G1 X179.087 Y127.917
G1 X166.367 Y140.637 E.53579
G1 X166.234 Y140.77
G1 X166.234 Y140.237
G1 X166.367 Y140.103
G1 X178.553 Y127.917 E.51333
G1 X178.687 Y127.784
G1 X178.154 Y127.784
G1 X178.02 Y127.917
G1 X166.367 Y139.57 E.49086
G1 X166.234 Y139.704
G1 X166.234 Y139.17
G1 X166.367 Y139.037
G1 X177.487 Y127.917 E.4684
G1 X177.62 Y127.784
G1 X177.087 Y127.784
G1 X176.954 Y127.917
G1 X166.367 Y138.504 E.44594
G1 X166.234 Y138.637
G1 X166.234 Y138.104
G1 X166.367 Y137.97
G1 X176.42 Y127.917 E.42347
G1 X176.554 Y127.784
G1 X176.021 Y127.784
G1 X175.887 Y127.917
G1 X166.367 Y137.437 E.40101
G1 X166.234 Y137.571
G1 X166.234 Y137.037
G1 X166.367 Y136.904
G1 X175.354 Y127.917 E.37855
G1 X175.487 Y127.784
G1 X174.954 Y127.784
G1 X174.82 Y127.917
G1 X166.367 Y136.37 E.35608
G1 X166.234 Y136.504
G1 X166.234 Y135.971
G1 X166.367 Y135.837
G1 X174.287 Y127.917 E.33362
G1 X174.421 Y127.784
G1 X173.888 Y127.784
G1 X173.754 Y127.917
G1 X166.367 Y135.304 E.31116
G1 X166.234 Y135.438
G1 X166.234 Y134.904
G1 X166.367 Y134.771
G1 X173.221 Y127.917 E.28869
G1 X173.354 Y127.784
G1 X172.821 Y127.784
G1 X172.687 Y127.917
G1 X168.977 Y131.627 E.15628
G1 X168.844 Y131.761
G1 X168.844 Y131.228
G1 X168.977 Y131.094
G1 X172.154 Y127.917 E.13382
G1 X172.288 Y127.784
G1 X171.755 Y127.784
G1 X171.621 Y127.917
G1 X168.977 Y130.561 E.11136
G1 X168.844 Y130.695
G1 X168.844 Y130.161
G1 X168.977 Y130.028
G1 X171.088 Y127.917 E.0889
G1 X171.221 Y127.784
G1 X170.688 Y127.784
G1 X170.554 Y127.917
G1 X168.977 Y129.494 E.06643
G1 X168.844 Y129.628
G1 X168.844 Y129.095
G1 X168.977 Y128.961
G1 X170.021 Y127.917 E.04397
G1 X170.155 Y127.784
G1 X169.622 Y127.784
G1 X169.488 Y127.917
G1 X168.977 Y128.428 E.02151
; WIPE_START
M204 S8000
G1 X169.488 Y127.917 E-.27435
G1 X169.622 Y127.784 E-.07182
G1 X170.155 Y127.784 E-.20264
G1 X170.021 Y127.917 E-.07182
G1 X169.762 Y128.177 E-.13937
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z2.4 I-1.169 J-.338 P1  F60000
G1 X168.677 Y131.927 Z2.4
G1 Z2
G1 E.8 F1800
G1 F9547.055
M204 S2000
G1 X166.367 Y134.237 E.09731
G1 X166.234 Y134.371
G1 X166.234 Y133.838
G1 X166.367 Y133.704
G1 X168.144 Y131.927 E.07485
G1 X168.278 Y131.794
G1 X167.745 Y131.794
G1 X167.611 Y131.927
G1 X166.346 Y133.193 E.0533
G1 X166.212 Y133.326
G1 X165.679 Y133.326
G1 X165.812 Y133.193
G1 X166.839 Y132.166 E.04324
G1 X166.972 Y132.033
G1 X166.439 Y132.033
G1 X166.306 Y132.166
G1 X165.279 Y133.193 E.04324
G1 X165.146 Y133.326
G1 X164.612 Y133.326
G1 X164.746 Y133.193
G1 X165.772 Y132.166 E.04324
G1 X165.906 Y132.033
G1 X165.373 Y132.033
G1 X165.239 Y132.166
G1 X164.213 Y133.193 E.04324
G1 X164.079 Y133.326
G1 X163.546 Y133.326
G1 X163.679 Y133.193
G1 X164.706 Y132.166 E.04324
G1 X164.839 Y132.033
G1 X164.306 Y132.033
G1 X164.173 Y132.166
G1 X163.146 Y133.193 E.04324
; WIPE_START
M204 S8000
G1 X164.173 Y132.166 E-.55157
G1 X164.306 Y132.033 E-.07182
G1 X164.666 Y132.033 E-.13661
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X165.897 Y139.565 Z2.4 F60000
G1 X166.263 Y141.807 Z2.4
G1 Z2
G1 E.8 F1800
G1 F9547.055
M204 S2000
G1 X164.378 Y143.693 E.07941
G1 X164.244 Y143.826
G1 X163.711 Y143.826
G1 X163.845 Y143.693
G1 X165.73 Y141.807 E.07941
G1 X165.863 Y141.674
G1 X165.33 Y141.674
G1 X165.197 Y141.807
G1 X163.311 Y143.693 E.07941
G1 X163.178 Y143.826
G1 X162.644 Y143.826
G1 X162.778 Y143.693
G1 X164.663 Y141.807 E.07941
G1 X164.797 Y141.674
G1 X164.264 Y141.674
G1 X164.13 Y141.807
G1 X162.245 Y143.693 E.07941
; WIPE_START
M204 S8000
G1 X163.659 Y142.278 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X164.937 Y149.803 Z2.4 F60000
G1 X165.362 Y152.307 Z2.4
G1 Z2
G1 E.8 F1800
G1 F9547.055
M204 S2000
G1 X159.917 Y157.752 E.22934
G1 X159.784 Y157.885
G1 X159.784 Y157.352
G1 X159.917 Y157.218
G1 X164.828 Y152.307 E.20688
G1 X164.962 Y152.174
G1 X164.429 Y152.174
G1 X164.295 Y152.307
G1 X159.917 Y156.685 E.18441
G1 X159.784 Y156.819
G1 X159.784 Y156.286
G1 X159.917 Y156.152
G1 X163.762 Y152.307 E.16195
G1 X163.896 Y152.174
G1 X163.362 Y152.174
G1 X163.229 Y152.307
G1 X159.917 Y155.619 E.13949
G1 X159.784 Y155.752
G1 X159.784 Y155.219
G1 X159.917 Y155.085
G1 X162.695 Y152.307 E.11702
G1 X162.829 Y152.174
G1 X162.296 Y152.174
G1 X162.162 Y152.307
G1 X159.917 Y154.552 E.09456
G1 X159.784 Y154.686
G1 X159.784 Y154.153
G1 X159.917 Y154.019
G1 X161.933 Y152.004 E.08489
G1 X162.066 Y151.87
G1 X162.066 Y151.337
G1 X161.933 Y151.47
G1 X159.917 Y153.486 E.08489
G1 X159.784 Y153.619
G1 X159.784 Y153.086
G1 X159.917 Y152.952
G1 X161.933 Y150.937 E.08489
G1 X162.066 Y150.803
G1 X162.066 Y150.27
G1 X161.933 Y150.404
G1 X159.917 Y152.419 E.08489
G1 X159.784 Y152.553
G1 X159.784 Y152.019
G1 X159.917 Y151.886
G1 X161.933 Y149.871 E.08489
G1 X162.066 Y149.737
G1 X162.066 Y149.204
G1 X161.933 Y149.337
G1 X159.917 Y151.353 E.08489
G1 X159.784 Y151.486
G1 X159.784 Y150.953
G1 X159.917 Y150.819
G1 X161.933 Y148.804 E.08489
G1 X162.066 Y148.67
G1 X162.066 Y148.137
G1 X161.933 Y148.271
G1 X159.917 Y150.286 E.08489
G1 X159.784 Y150.42
G1 X159.784 Y149.886
G1 X159.917 Y149.753
G1 X161.933 Y147.738 E.08489
G1 X162.066 Y147.604
G1 X162.066 Y147.071
G1 X161.933 Y147.204
G1 X159.917 Y149.22 E.08489
G1 X159.784 Y149.353
G1 X159.784 Y148.82
G1 X159.917 Y148.686
G1 X161.933 Y146.671 E.08489
G1 X162.066 Y146.537
G1 X162.066 Y146.004
G1 X161.933 Y146.138
G1 X159.917 Y148.153 E.08489
G1 X159.784 Y148.287
G1 X159.784 Y147.753
G1 X159.917 Y147.62
G1 X161.933 Y145.605 E.08489
G1 X162.066 Y145.471
G1 X162.066 Y144.938
G1 X161.933 Y145.071
M73 P84 R3
G1 X159.917 Y147.087 E.08489
G1 X159.784 Y147.22
G1 X159.784 Y146.687
G1 X159.917 Y146.553
G1 X161.933 Y144.538 E.08489
G1 X162.066 Y144.404
G1 X162.066 Y143.871
G1 X161.933 Y144.005
G1 X159.917 Y146.02 E.08489
G1 X159.784 Y146.154
G1 X159.784 Y145.62
G1 X159.917 Y145.487
G1 X163.597 Y141.807 E.15499
G1 X163.73 Y141.674
G1 X163.197 Y141.674
G1 X163.063 Y141.807
G1 X159.917 Y144.953 E.13253
G1 X159.784 Y145.087
G1 X159.784 Y144.554
G1 X159.917 Y144.42
G1 X162.833 Y141.505 E.1228
G1 X162.966 Y141.371
G1 X162.966 Y140.838
G1 X162.833 Y140.972
G1 X159.917 Y143.887 E.1228
G1 X159.784 Y144.021
G1 X159.784 Y143.487
G1 X159.917 Y143.354
G1 X162.833 Y140.439 E.1228
G1 X162.966 Y140.305
G1 X162.966 Y139.772
G1 X162.833 Y139.905
G1 X159.917 Y142.82 E.1228
G1 X159.784 Y142.954
G1 X159.784 Y142.421
G1 X159.917 Y142.287
G1 X162.833 Y139.372 E.1228
G1 X162.966 Y139.238
G1 X162.966 Y138.705
G1 X162.833 Y138.839
G1 X159.917 Y141.754 E.1228
G1 X159.784 Y141.888
G1 X159.784 Y141.354
G1 X159.917 Y141.221
G1 X162.833 Y138.305 E.1228
G1 X162.966 Y138.172
G1 X162.966 Y137.639
G1 X162.833 Y137.772
G1 X159.917 Y140.687 E.1228
G1 X159.784 Y140.821
G1 X159.784 Y140.288
G1 X159.917 Y140.154
G1 X162.833 Y137.239 E.1228
G1 X162.966 Y137.105
G1 X162.966 Y136.572
G1 X162.833 Y136.706
G1 X159.917 Y139.621 E.1228
G1 X159.784 Y139.755
G1 X159.784 Y139.221
G1 X159.917 Y139.088
G1 X162.833 Y136.172 E.1228
G1 X162.966 Y136.039
G1 X162.966 Y135.506
G1 X162.833 Y135.639
G1 X159.917 Y138.554 E.1228
G1 X159.784 Y138.688
G1 X159.784 Y138.155
G1 X159.917 Y138.021
G1 X162.833 Y135.106 E.1228
G1 X162.966 Y134.972
G1 X162.966 Y134.439
G1 X162.833 Y134.573
G1 X159.917 Y137.488 E.1228
G1 X159.784 Y137.622
G1 X159.784 Y137.088
G1 X159.917 Y136.955
G1 X162.833 Y134.039 E.1228
G1 X162.966 Y133.906
G1 X162.966 Y133.373
G1 X162.833 Y133.506
G1 X159.917 Y136.421 E.1228
G1 X159.784 Y136.555
G1 X159.784 Y136.022
G1 X159.917 Y135.888
G1 X163.639 Y132.166 E.15678
G1 X163.773 Y132.033
G1 X163.24 Y132.033
G1 X163.106 Y132.166
G1 X159.917 Y135.355 E.13432
G1 X159.784 Y135.489
G1 X159.784 Y134.955
G1 X159.917 Y134.822
G1 X162.573 Y132.166 E.11186
G1 X162.706 Y132.033
G1 X162.173 Y132.033
G1 X162.039 Y132.166
G1 X159.917 Y134.288 E.08939
G1 X159.784 Y134.422
G1 X159.784 Y133.889
G1 X159.917 Y133.755
G1 X161.506 Y132.166 E.06693
G1 X161.64 Y132.033
G1 X161.107 Y132.033
G1 X160.973 Y132.166
G1 X159.917 Y133.222 E.04447
G1 X159.784 Y133.355
G1 X159.784 Y132.822
G1 X159.917 Y132.689
G1 X160.44 Y132.166 E.022
; WIPE_START
M204 S8000
G1 X159.917 Y132.689 E-.28071
G1 X159.784 Y132.822 E-.07182
G1 X159.784 Y133.355 E-.20264
G1 X159.917 Y133.222 E-.07182
G1 X160.165 Y132.974 E-.13302
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X162.777 Y140.146 Z2.4 F60000
G1 X186 Y203.912 Z2.4
G1 Z2
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.177136
G1 F15000
M204 S8000
G3 X185.69 Y204.098 I-3.818 J-6.008 E.00384
M204 S10000
G1 X185.995 Y203.904 F60000
; LINE_WIDTH: 0.102862
G1 F15000
M204 S8000
G3 X185.699 Y204.108 I-4.608 J-6.354 E.0017
; WIPE_START
G1 X185.995 Y203.904 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X183.724 Y201.935 Z2.4 F60000
G1 Z2
G1 E.8 F1800
; LINE_WIDTH: 0.132681
G1 F15000
M204 S8000
G1 X183.785 Y202.166 E.00169
M204 S10000
G1 X183.909 Y201.778 F60000
; LINE_WIDTH: 0.090459
G1 F15000
M204 S8000
G1 X183.885 Y201.81 E.00015
; LINE_WIDTH: 0.106371
G1 X183.846 Y201.868 E.00035
; LINE_WIDTH: 0.142949
G2 X183.704 Y202.084 I4.448 J3.069 E.00204
; WIPE_START
G1 X183.846 Y201.868 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X180.256 Y195.133 Z2.4 F60000
G1 X161.653 Y160.229 Z2.4
G1 Z2
G1 E.8 F1800
; LINE_WIDTH: 0.107827
G1 F15000
M204 S8000
G1 X161.546 Y160.122 E.00077
; WIPE_START
G1 X161.653 Y160.229 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X163.539 Y152.833 Z2.4 F60000
G1 X168.848 Y132.024 Z2.4
G1 Z2
G1 E.8 F1800
; LINE_WIDTH: 0.109223
G1 F15000
M204 S8000
G1 X168.702 Y131.926 E.00092
; COOLING_NODE: 13
; WIPE_START
G1 X168.848 Y132.024 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z2.4 I1.18 J-.298 P1  F60000
G1 X164.611 Y115.24 Z2.4
G1 Z2
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X164.84 Y115.359 E.00769
G3 X163.957 Y115.147 I-.741 J1.14 E.22684
G1 X164.083 Y115.14 E.00374
G3 X164.555 Y115.218 I.017 J1.359 E.01434
; COOLING_NODE: 12
; WIPE_START
M204 S8000
G1 X164.84 Y115.359 E-.12076
G1 X165.045 Y115.522 E-.09946
G1 X165.215 Y115.72 E-.09916
G1 X165.345 Y115.953 E-.10131
G1 X165.43 Y116.216 E-.10532
G1 X165.46 Y116.475 E-.09891
G1 X165.44 Y116.736 E-.09965
G1 X165.414 Y116.826 E-.03543
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X168.09 Y120.9 Z2.4 F60000
G1 Z2
G1 E.8 F1800
G1 F1483
M204 S5000
G1 X168.49 Y120.9 E.01191
G1 X168.49 Y122.48 E.04706
G1 X159.71 Y122.48 E.26153
G1 X159.71 Y110.21 E.36548
G1 X168.09 Y110.21 E.24961
G1 X168.09 Y120.84 E.31663
M204 S10000
G1 X168.283 Y121.657 F60000
; FEATURE: Top surface
G1 F9547.055
M204 S2000
G1 X167.906 Y122.034 E.01587
G1 X167.772 Y122.167
G1 X167.239 Y122.167
G1 X167.373 Y122.034
G1 X168.283 Y121.124 E.03833
G1 X168.416 Y120.99
G1 X168.016 Y120.857
G1 X167.883 Y120.991
G1 X166.839 Y122.034 E.04395
G1 X166.706 Y122.167
G1 X166.172 Y122.167
G1 X166.306 Y122.034
G1 X167.883 Y120.457 E.06641
G1 X168.016 Y120.324
G1 X168.016 Y119.79
G1 X167.883 Y119.924
G1 X165.773 Y122.034 E.08887
G1 X165.639 Y122.167
G1 X165.106 Y122.167
G1 X165.24 Y122.034
G1 X167.883 Y119.391 E.11133
G1 X168.016 Y119.257
G1 X168.016 Y118.724
G1 X167.883 Y118.858
G1 X164.706 Y122.034 E.1338
G1 X164.573 Y122.167
G1 X164.039 Y122.167
G1 X164.173 Y122.034
G1 X167.883 Y118.324 E.15626
G1 X168.016 Y118.191
G1 X168.016 Y117.657
G1 X167.883 Y117.791
G1 X163.64 Y122.034 E.17872
G1 X163.506 Y122.167
G1 X162.973 Y122.167
G1 X163.107 Y122.034
G1 X167.883 Y117.258 E.20119
G1 X168.016 Y117.124
G1 X168.016 Y116.591
G1 X167.883 Y116.724
G1 X162.573 Y122.034 E.22365
G1 X162.44 Y122.167
G1 X161.906 Y122.167
G1 X162.04 Y122.034
G1 X167.883 Y116.191 E.24611
G1 X168.016 Y116.058
G1 X168.016 Y115.524
G1 X167.883 Y115.658
G1 X161.507 Y122.034 E.26858
G1 X161.373 Y122.167
G1 X160.84 Y122.167
G1 X160.974 Y122.034
G1 X167.883 Y115.125 E.29104
G1 X168.016 Y114.991
G1 X168.016 Y114.458
G1 X167.883 Y114.591
G1 X165.627 Y116.847 E.09502
G1 X165.493 Y116.981
G1 X165.519 Y116.422
G1 X165.653 Y116.288
G1 X167.883 Y114.058 E.09394
G1 X168.016 Y113.925
G1 X168.016 Y113.391
G1 X167.883 Y113.525
G1 X165.536 Y115.871 E.09884
G1 X165.403 Y116.005
G1 X165.203 Y115.672
G1 X165.336 Y115.538
G1 X167.883 Y112.992 E.10727
G1 X168.016 Y112.858
G1 X168.016 Y112.325
G1 X167.883 Y112.458
G1 X165.072 Y115.269 E.11841
G1 X164.938 Y115.403
G1 X164.605 Y115.203
G1 X164.738 Y115.07
G1 X167.883 Y111.925 E.13246
G1 X168.016 Y111.792
G1 X168.016 Y111.258
G1 X167.883 Y111.392
G1 X164.324 Y114.95 E.1499
G1 X164.191 Y115.084
G1 X163.641 Y115.1
G1 X163.775 Y114.966
G1 X167.883 Y110.859 E.17303
; WIPE_START
M204 S8000
G1 X166.468 Y112.273 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X164.446 Y118.028 Z2.4 F60000
G1 Z2
G1 E.8 F1800
G1 F9547.055
M204 S2000
G1 X160.44 Y122.034 E.16872
G1 X160.307 Y122.167
G1 X159.784 Y122.157
G1 X159.917 Y122.023
G1 X163.889 Y118.052 E.16731
G1 X164.023 Y117.918
G1 X163.606 Y117.801
G1 X163.472 Y117.935
G1 X159.917 Y121.49 E.14976
G1 X159.784 Y121.624
G1 X159.784 Y121.091
G1 X159.917 Y120.957
G1 X163.137 Y117.737 E.13563
G1 X163.271 Y117.604
G1 X163.005 Y117.336
G1 X162.871 Y117.47
G1 X159.917 Y120.424 E.12442
G1 X159.784 Y120.557
G1 X159.784 Y120.024
G1 X159.917 Y119.89
G1 X162.669 Y117.139 E.1159
G1 X162.802 Y117.005
G1 X162.683 Y116.591
G1 X162.55 Y116.725
G1 X159.917 Y119.357 E.11088
G1 X159.784 Y119.491
G1 X159.784 Y118.958
G1 X159.917 Y118.824
G1 X162.568 Y116.173 E.11167
; WIPE_START
M204 S8000
G1 X161.154 Y117.587 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X159.917 Y118.291 Z2.4 F60000
G1 Z2
G1 E.8 F1800
G1 F9547.055
M204 S2000
G1 X167.791 Y110.417 E.33166
G1 X167.924 Y110.284
G1 X167.391 Y110.284
G1 X167.257 Y110.417
G1 X159.917 Y117.757 E.30919
G1 X159.784 Y117.891
G1 X159.784 Y117.358
G1 X159.917 Y117.224
G1 X166.724 Y110.417 E.28673
G1 X166.858 Y110.284
G1 X166.324 Y110.284
G1 X166.191 Y110.417
G1 X159.917 Y116.691 E.26427
G1 X159.784 Y116.824
G1 X159.784 Y116.291
G1 X159.917 Y116.158
G1 X165.658 Y110.417 E.2418
G1 X165.791 Y110.284
G1 X165.258 Y110.284
G1 X165.124 Y110.417
G1 X159.917 Y115.624 E.21934
G1 X159.784 Y115.758
G1 X159.784 Y115.225
G1 X159.917 Y115.091
G1 X164.591 Y110.417 E.19688
G1 X164.725 Y110.284
G1 X164.191 Y110.284
G1 X164.058 Y110.417
G1 X159.917 Y114.558 E.17441
G1 X159.784 Y114.691
G1 X159.784 Y114.158
G1 X159.917 Y114.025
G1 X163.525 Y110.417 E.15195
G1 X163.658 Y110.284
G1 X163.125 Y110.284
G1 X162.991 Y110.417
G1 X159.917 Y113.491 E.12949
G1 X159.784 Y113.625
G1 X159.784 Y113.092
G1 X159.917 Y112.958
G1 X162.458 Y110.417 E.10702
G1 X162.592 Y110.284
G1 X162.058 Y110.284
G1 X161.925 Y110.417
G1 X159.917 Y112.425 E.08456
G1 X159.784 Y112.558
G1 X159.784 Y112.025
G1 X159.917 Y111.892
G1 X161.392 Y110.417 E.0621
G1 X161.525 Y110.284
G1 X160.992 Y110.284
G1 X160.858 Y110.417
G1 X159.917 Y111.358 E.03963
G1 X159.784 Y111.492
G1 X159.784 Y110.959
G1 X159.917 Y110.825
G1 X160.325 Y110.417 E.01717
; WIPE_START
M204 S8000
G1 X159.917 Y110.825 E-.21906
G1 X159.784 Y110.959 E-.07182
G1 X159.784 Y111.492 E-.20264
G1 X159.917 Y111.358 E-.07182
G1 X160.28 Y110.996 E-.19466
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X162.694 Y115.806 Z2.4 F60000
G1 Z2
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.125325
G1 F15000
M204 S8000
G2 X162.498 Y116.103 I5.968 J4.163 E.00231
; WIPE_START
G1 X162.694 Y115.806 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X164.832 Y117.899 Z2.4 F60000
G1 Z2
G1 E.8 F1800
; LINE_WIDTH: 0.186013
G1 F15000
M204 S8000
G3 X164.51 Y118.093 I-4.127 J-6.49 E.00425
M204 S10000
G1 X164.825 Y117.889 F60000
; LINE_WIDTH: 0.110013
G1 F15000
M204 S8000
G3 X164.518 Y118.101 I-4.477 J-6.135 E.00198
; WIPE_START
G1 X164.825 Y117.889 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X168.294 Y122.172 Z2.4 F60000
G1 Z2
G1 E.8 F1800
; LINE_WIDTH: 0.26666
G1 F15000
M204 S8000
G1 X159.906 Y122.172 E.14825
; CHANGE_LAYER
; Z_HEIGHT: 2.125
; LAYER_HEIGHT: 0.125
; WIPE_START
G1 F15000
G1 X161.906 Y122.172 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 17/37
; update layer progress
M73 L17
M991 S0 P16 ;notify layer change

M106 S229.5
; OBJECT_ID: 15
M204 S10000
G17
G3 Z2.4 I-.519 J1.101 P1  F60000
G1 X168.512 Y125.287 Z2.4
G1 Z2.125
G1 E.8 F1800
; FEATURE: Support
; LINE_WIDTH: 0.42
; LAYER_HEIGHT: 0.275
G1 F1200
M204 S8000
G1 X168.512 Y123.229 E.08069
G1 X159.688 Y123.229 E.34594
G1 X159.688 Y125.475 E.08809
G1 X168.512 Y125.475 E.34594
G1 X168.512 Y126.961 E.05828
G1 X168.337 Y126.961 E.00685
G1 X168.021 Y127.277 E.01749
G1 X168.021 Y128.352 E.04216
G1 X159.688 Y128.352 E.32672
G1 X159.688 Y130.971 E.1027
G1 X168.021 Y130.971 E.32672
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

G1 X168.021 Y128.541 E.0953
; CHANGE_LAYER
; Z_HEIGHT: 2.2
; LAYER_HEIGHT: 0.075
; WIPE_START
M73 P85 R3
G1 F7252.893
G1 X168.021 Y130.541 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 18/37
; update layer progress
M73 L18
M991 S0 P17 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 12
M204 S10000
G17
G3 Z2.525 I-1.216 J.059 P1  F60000
G1 X168.098 Y132.112 Z2.525
G1 Z2.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
; LAYER_HEIGHT: 0.2
G1 F1200
M204 S8000
G1 X168.098 Y132.908 E.02559
G1 X160.102 Y132.908 E.25712
G1 X160.102 Y132.112 E.02559
G1 X168.038 Y132.112 E.25519
; COOLING_NODE: 12
M204 S250
G1 X168.49 Y131.72 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X168.49 Y133.3 E.04706
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

G1 X159.71 Y133.3 E.26153
G1 X159.71 Y131.72 E.04706
G1 X168.43 Y131.72 E.25974
M204 S10000
G1 X167.894 Y132.51 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1200
M204 S8000
G1 X160.306 Y132.51 E.23307
; COOLING_NODE: 12
; WIPE_START
G1 F9259.259
G1 X162.306 Y132.51 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z2.6 I1.081 J.558 P1  F60000
G1 X168.098 Y121.292 Z2.6
G1 Z2.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X168.098 Y122.088 E.02559
G1 X160.102 Y122.088 E.25712
G1 X160.102 Y121.292 E.02559
G1 X168.038 Y121.292 E.25519
; COOLING_NODE: 12
M204 S250
G1 X168.49 Y120.9 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X168.49 Y122.48 E.04706
G1 X159.71 Y122.48 E.26153
G1 X159.71 Y120.9 E.04706
G1 X168.43 Y120.9 E.25974
M204 S10000
G1 X167.894 Y121.69 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1200
M204 S8000
G1 X160.306 Y121.69 E.23307
; CHANGE_LAYER
; Z_HEIGHT: 2.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.259
G1 X162.306 Y121.69 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 19/37
; update layer progress
M73 L19
M991 S0 P18 ;notify layer change

; OBJECT_ID: 15
M204 S10000
G17
G3 Z2.6 I-.61 J1.053 P1  F60000
G1 X168.512 Y125.287 Z2.6
G1 Z2.4
G1 E.8 F1800
; FEATURE: Support
; LINE_WIDTH: 0.42
; LAYER_HEIGHT: 0.275
G1 F1200
M204 S8000
G1 X168.512 Y123.229 E.08069
G1 X159.688 Y123.229 E.34594
G1 X159.688 Y125.475 E.08809
G1 X168.512 Y125.475 E.34594
G1 X168.512 Y127.111 E.06416
G1 X168.399 Y127.111 E.00441
G1 X168.171 Y127.339 E.01262
G1 X168.171 Y128.352 E.03972
G1 X159.688 Y128.352 E.33261
G1 X159.688 Y130.971 E.1027
G1 X168.171 Y130.971 E.33261
G1 X168.171 Y128.541 E.0953
; WIPE_START
G1 F7252.893
G1 X168.171 Y130.541 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z2.8 I1.165 J.35 P1  F60000
G1 X169.101 Y127.447 Z2.8
G1 Z2.4
G1 E.8 F1800
; FEATURE: Support interface
; LAYER_HEIGHT: 0.2
G1 F1200
M204 S8000
G1 X168.328 Y128.22 E.03256
G1 X168.328 Y129.461 E.03695
G1 X168.932 Y128.857 E.02541
G1 X168.932 Y130.098 E.03695
G1 X168.159 Y130.871 E.03256
; COOLING_NODE: 12
; WIPE_START
G1 F4800
G1 X168.932 Y130.098 E-.41535
G1 X168.932 Y129.191 E-.34465
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z2.8 I-1.17 J-.334 P1  F60000
G1 X168.098 Y132.112 Z2.8
G1 Z2.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X168.098 Y132.908 E.02559
G1 X160.102 Y132.908 E.25712
G1 X160.102 Y132.112 E.02559
G1 X168.038 Y132.112 E.25519
; COOLING_NODE: 12
M204 S250
G1 X168.49 Y131.72 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X168.49 Y133.3 E.04706
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

G1 X159.71 Y133.3 E.26153
G1 X159.71 Y131.72 E.04706
G1 X168.43 Y131.72 E.25974
M204 S10000
G1 X167.894 Y132.51 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1200
M204 S8000
G1 X160.306 Y132.51 E.23307
; COOLING_NODE: 12
; WIPE_START
G1 F9259.259
G1 X162.306 Y132.51 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
M73 P85 R2
G3 Z2.8 I1.081 J.558 P1  F60000
G1 X168.098 Y121.292 Z2.8
G1 Z2.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X168.098 Y122.088 E.02559
G1 X160.102 Y122.088 E.25712
G1 X160.102 Y121.292 E.02559
G1 X168.038 Y121.292 E.25519
; COOLING_NODE: 12
M204 S250
G1 X168.49 Y120.9 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X168.49 Y122.48 E.04706
M73 P86 R2
G1 X159.71 Y122.48 E.26153
G1 X159.71 Y120.9 E.04706
G1 X168.43 Y120.9 E.25974
M204 S10000
G1 X167.894 Y121.69 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1200
M204 S8000
G1 X160.306 Y121.69 E.23307
; CHANGE_LAYER
; Z_HEIGHT: 2.6
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.259
G1 X162.306 Y121.69 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 20/37
; update layer progress
M73 L20
M991 S0 P19 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 12
M204 S10000
G17
G3 Z2.8 I-1.064 J.591 P1  F60000
G1 X168.098 Y132.112 Z2.8
G1 Z2.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X168.098 Y132.908 E.02559
G1 X160.102 Y132.908 E.25712
G1 X160.102 Y132.112 E.02559
G1 X168.038 Y132.112 E.25519
; COOLING_NODE: 12
M204 S250
G1 X168.49 Y131.72 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X168.49 Y133.3 E.04706
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

G1 X159.71 Y133.3 E.26153
G1 X159.71 Y131.72 E.04706
G1 X168.43 Y131.72 E.25974
M204 S10000
G1 X167.894 Y132.51 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1200
M204 S8000
G1 X160.306 Y132.51 E.23307
; COOLING_NODE: 12
; WIPE_START
G1 F9259.259
G1 X162.306 Y132.51 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z3 I1.081 J.558 P1  F60000
G1 X168.098 Y121.292 Z3
G1 Z2.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X168.098 Y122.088 E.02559
G1 X160.102 Y122.088 E.25712
G1 X160.102 Y121.292 E.02559
G1 X168.038 Y121.292 E.25519
; COOLING_NODE: 12
M204 S250
G1 X168.49 Y120.9 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X168.49 Y122.48 E.04706
G1 X159.71 Y122.48 E.26153
G1 X159.71 Y120.9 E.04706
G1 X168.43 Y120.9 E.25974
M204 S10000
G1 X167.894 Y121.69 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1200
M204 S8000
G1 X160.306 Y121.69 E.23307
; CHANGE_LAYER
; Z_HEIGHT: 2.65
; LAYER_HEIGHT: 0.0500002
; WIPE_START
G1 F9259.259
G1 X162.306 Y121.69 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 21/37
; update layer progress
M73 L21
M991 S0 P20 ;notify layer change

; OBJECT_ID: 15
M204 S10000
G17
G3 Z3 I-.35 J1.166 P1  F60000
G1 X168.512 Y123.554 Z3
G1 Z2.65
G1 E.8 F1800
; FEATURE: Support transition
; LINE_WIDTH: 0.42
; LAYER_HEIGHT: 0.25
G1 F1200
M204 S8000
G1 X168.512 Y123.228 E.01179
G1 X167.997 Y123.228 E.01861
G1 X168.512 Y123.743 E.02632
G1 X168.512 Y124.983 E.04487
G1 X166.757 Y123.228 E.08977
G1 X165.516 Y123.228 E.04487
G1 X168.303 Y126.015 E.14253
G2 X167.503 Y126.456 I.117 J1.156 E.03394
G1 X164.276 Y123.228 E.1651
G1 X163.036 Y123.228 E.04487
G1 X167.075 Y127.267 E.20662
G1 X167.075 Y128.508 E.04487
G1 X161.795 Y123.228 E.27007
G1 X160.555 Y123.228 E.04487
G1 X167.075 Y129.748 E.33352
G1 X167.058 Y130.972 E.04427
G1 X159.688 Y123.602 E.377
G1 X159.688 Y124.843 E.04487
G1 X165.817 Y130.972 E.31355
G1 X164.577 Y130.972 E.04487
G1 X159.688 Y126.083 E.25009
G1 X159.688 Y127.323 E.04487
G1 X163.337 Y130.972 E.18664
G1 X162.096 Y130.972 E.04487
G1 X159.688 Y128.564 E.12319
G1 X159.688 Y129.804 E.04487
G1 X160.856 Y130.972 E.05973
G1 X159.688 Y130.972 E.04224
G1 X159.688 Y129.993 E.03542
; WIPE_START
G1 F3000
G1 X159.688 Y130.972 E-.37204
G1 X160.709 Y130.972 E-.38796
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z3.05 I-.027 J1.217 P1  F60000
G1 X168.468 Y131.141 Z3.05
G1 Z2.65
G1 E.8 F1800
; FEATURE: Support interface
G1 F1200
M204 S8000
G1 X167.451 Y130.125 E.052
G1 X167.451 Y128.884 E.04487
G1 X168.512 Y129.945 E.05424
G1 X168.512 Y128.704 E.04487
G1 X167.451 Y127.644 E.05424
G3 X167.77 Y126.722 I.872 J-.215 E.03729
G1 X168.681 Y127.634 E.04663
; WIPE_START
G1 F4800
G1 X167.77 Y126.722 E-.48981
G1 X167.556 Y126.936 E-.11483
G1 X167.451 Y127.189 E-.10411
G1 X167.451 Y127.324 E-.05125
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z3.05 I1.217 J0 P1  F60000
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
            

            
                M9711 M0 E1 X258 Y133 Z2.65 S11 C10 O0 T3000
            

            
        M623

        M622 J1
            

            
                M9711 M0 E1 U258 V133 Z2.65 S11 C10 O0 T3000
            

            
        M623
    
    
    
        M993 A3 B3 C3
    
M623
; SKIPPABLE_END

G1 Z3.050
; CHANGE_LAYER
; Z_HEIGHT: 2.8
; LAYER_HEIGHT: 0.15
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 22/37
; update layer progress
M73 L22
M991 S0 P21 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 12
G1 X168.098 Y132.112
G1 Z2.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
; LAYER_HEIGHT: 0.2
G1 F1200
M204 S8000
G1 X168.098 Y132.908 E.02559
G1 X160.102 Y132.908 E.25712
G1 X160.102 Y132.112 E.02559
G1 X168.038 Y132.112 E.25519
; COOLING_NODE: 12
M204 S250
G1 X168.49 Y131.72 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
M73 P87 R2
G1 F1200
M204 S5000
G1 X168.49 Y133.3 E.04706
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

G1 X159.71 Y133.3 E.26153
G1 X159.71 Y131.72 E.04706
G1 X168.43 Y131.72 E.25974
M204 S10000
G1 X167.894 Y132.51 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1200
M204 S8000
G1 X160.306 Y132.51 E.23307
; COOLING_NODE: 12
; WIPE_START
G1 F9259.259
G1 X162.306 Y132.51 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z3.2 I1.081 J.558 P1  F60000
G1 X168.098 Y121.292 Z3.2
G1 Z2.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X168.098 Y122.088 E.02559
G1 X160.102 Y122.088 E.25712
G1 X160.102 Y121.292 E.02559
G1 X168.038 Y121.292 E.25519
; COOLING_NODE: 12
M204 S250
G1 X168.49 Y120.9 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X168.49 Y122.48 E.04706
G1 X159.71 Y122.48 E.26153
G1 X159.71 Y120.9 E.04706
G1 X168.43 Y120.9 E.25974
M204 S10000
G1 X167.894 Y121.69 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1200
M204 S8000
G1 X160.306 Y121.69 E.23307
; CHANGE_LAYER
; Z_HEIGHT: 2.9
; LAYER_HEIGHT: 0.1
; WIPE_START
G1 F9259.259
G1 X162.306 Y121.69 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 23/37
; update layer progress
M73 L23
M991 S0 P22 ;notify layer change

; OBJECT_ID: 15
M204 S10000
G17
G3 Z3.2 I-.909 J-.809 P1  F60000
G1 X161.086 Y123.059 Z3.2
G1 Z2.9
G1 E.8 F1800
; FEATURE: Support interface
; LINE_WIDTH: 0.42
; LAYER_HEIGHT: 0.25
G1 F1200
M204 S8000
G1 X159.688 Y124.457 E.07152
G1 X159.688 Y125.697 E.04487
G1 X162.157 Y123.228 E.12629
G1 X163.397 Y123.228 E.04487
G1 X159.688 Y126.937 E.18974
G1 X159.688 Y128.178 E.04487
G1 X164.638 Y123.228 E.2532
G1 X165.878 Y123.228 E.04487
G1 X159.688 Y129.418 E.31665
G1 X159.688 Y130.659 E.04487
G1 X167.118 Y123.228 E.38011
G1 X168.359 Y123.228 E.04487
G1 X160.616 Y130.972 E.39612
G1 X161.856 Y130.972 E.04487
G1 X168.512 Y124.316 E.34048
G1 X168.512 Y125.556 E.04487
G1 X163.096 Y130.972 E.27703
G1 X164.337 Y130.972 E.04487
G1 X168.512 Y126.797 E.21358
G1 X168.512 Y128.037 E.04487
G1 X165.577 Y130.972 E.15012
G1 X166.817 Y130.972 E.04487
G1 X168.512 Y129.277 E.08667
G1 X168.512 Y130.518 E.04487
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

G1 X167.888 Y131.141 E.0319
; CHANGE_LAYER
; Z_HEIGHT: 3
; LAYER_HEIGHT: 0.0999999
; WIPE_START
G1 F4800
G1 X168.512 Y130.518 E-.33506
G1 X168.512 Y129.4 E-.42494
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 24/37
; update layer progress
M73 L24
M991 S0 P23 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 12
M204 S10000
G17
G3 Z3.3 I-1.203 J-.183 P1  F60000
G1 X168.098 Y132.112 Z3.3
G1 Z3
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
; LAYER_HEIGHT: 0.2
G1 F1200
M204 S8000
G1 X168.098 Y132.908 E.02559
G1 X160.102 Y132.908 E.25712
G1 X160.102 Y132.112 E.02559
G1 X168.038 Y132.112 E.25519
; COOLING_NODE: 12
M204 S250
G1 X168.49 Y131.72 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X168.49 Y133.3 E.04706
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

G1 X159.71 Y133.3 E.26153
G1 X159.71 Y131.72 E.04706
G1 X168.43 Y131.72 E.25974
M204 S10000
G1 X167.894 Y132.51 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1200
M204 S8000
G1 X160.306 Y132.51 E.23307
; COOLING_NODE: 12
; WIPE_START
G1 F9259.259
G1 X162.306 Y132.51 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z3.4 I1.081 J.558 P1  F60000
G1 X168.098 Y121.292 Z3.4
G1 Z3
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X168.098 Y122.088 E.02559
G1 X160.102 Y122.088 E.25712
G1 X160.102 Y121.292 E.02559
G1 X168.038 Y121.292 E.25519
; COOLING_NODE: 12
M204 S250
G1 X168.49 Y120.9 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X168.49 Y122.48 E.04706
M73 P88 R2
G1 X159.71 Y122.48 E.26153
G1 X159.71 Y120.9 E.04706
G1 X168.43 Y120.9 E.25974
M204 S10000
G1 X167.894 Y121.69 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1200
M204 S8000
G1 X160.306 Y121.69 E.23307
; CHANGE_LAYER
; Z_HEIGHT: 3.15
; LAYER_HEIGHT: 0.15
; WIPE_START
G1 F9259.259
G1 X162.306 Y121.69 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 25/37
; update layer progress
M73 L25
M991 S0 P24 ;notify layer change

; OBJECT_ID: 15
M204 S10000
G17
G3 Z3.4 I-.401 J1.149 P1  F60000
G1 X168.681 Y123.913 Z3.4
G1 Z3.15
G1 E.8 F1800
; FEATURE: Support interface
; LINE_WIDTH: 0.42
; LAYER_HEIGHT: 0.25
G1 F1200
M204 S8000
G1 X167.997 Y123.228 E.035
G1 X166.757 Y123.228 E.04487
G1 X168.512 Y124.983 E.08977
G1 X168.512 Y126.224 E.04487
G1 X165.516 Y123.228 E.15323
G1 X164.276 Y123.228 E.04487
G1 X168.512 Y127.464 E.21668
G1 X168.512 Y128.704 E.04487
G1 X163.036 Y123.228 E.28014
G1 X161.795 Y123.228 E.04487
G1 X168.512 Y129.945 E.34359
G1 X168.512 Y130.972 E.03714
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

G1 X168.298 Y130.972 E.00772
G1 X160.555 Y123.228 E.39612
G1 X159.688 Y123.228 E.03135
G1 X159.688 Y123.602 E.01352
G1 X167.058 Y130.972 E.377
G1 X165.817 Y130.972 E.04487
G1 X159.688 Y124.843 E.31355
G1 X159.688 Y126.083 E.04487
G1 X164.577 Y130.972 E.25009
G1 X163.337 Y130.972 E.04487
G1 X159.688 Y127.323 E.18664
G1 X159.688 Y128.564 E.04487
G1 X162.096 Y130.972 E.12319
G1 X160.856 Y130.972 E.04487
G1 X159.519 Y129.634 E.06841
; CHANGE_LAYER
; Z_HEIGHT: 3.2
; LAYER_HEIGHT: 0.05
; WIPE_START
G1 F4800
G1 X160.856 Y130.972 E-.71866
G1 X160.965 Y130.972 E-.04135
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 26/37
; update layer progress
M73 L26
M991 S0 P25 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 12
M204 S10000
G17
G3 Z3.55 I-.192 J1.202 P1  F60000
G1 X168.098 Y132.112 Z3.55
G1 Z3.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
; LAYER_HEIGHT: 0.2
G1 F1200
M204 S8000
G1 X168.098 Y132.908 E.02559
G1 X160.102 Y132.908 E.25712
G1 X160.102 Y132.112 E.02559
G1 X168.038 Y132.112 E.25519
; COOLING_NODE: 12
M204 S250
G1 X168.49 Y131.72 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X168.49 Y133.3 E.04706
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

G1 X159.71 Y133.3 E.26153
G1 X159.71 Y131.72 E.04706
G1 X168.43 Y131.72 E.25974
M204 S10000
G1 X167.894 Y132.51 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1200
M204 S8000
G1 X160.306 Y132.51 E.23307
; COOLING_NODE: 12
; WIPE_START
G1 F9259.259
G1 X162.306 Y132.51 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X165.807 Y125.728 Z3.6 F60000
G1 X168.098 Y121.292 Z3.6
G1 Z3.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X168.098 Y122.088 E.02559
G1 X160.102 Y122.088 E.25712
G1 X160.102 Y121.292 E.02559
G1 X168.038 Y121.292 E.25519
; COOLING_NODE: 12
M204 S250
G1 X168.49 Y120.9 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X168.49 Y122.48 E.04706
G1 X159.71 Y122.48 E.26153
G1 X159.71 Y120.9 E.04706
G1 X168.43 Y120.9 E.25974
M204 S10000
G1 X167.894 Y121.69 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1200
M204 S8000
G1 X160.306 Y121.69 E.23307
; CHANGE_LAYER
; Z_HEIGHT: 3.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.259
G1 X162.306 Y121.69 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 27/37
; update layer progress
M73 L27
M991 S0 P26 ;notify layer change

; OBJECT_ID: 15
M204 S10000
G17
G3 Z3.6 I-.909 J-.809 P1  F60000
G1 X161.086 Y123.059 Z3.6
G1 Z3.4
G1 E.8 F1800
; FEATURE: Support interface
; LINE_WIDTH: 0.42
; LAYER_HEIGHT: 0.25
G1 F1200
M204 S8000
G1 X159.688 Y124.457 E.07151
G1 X159.688 Y125.697 E.04487
G1 X162.157 Y123.228 E.12629
G1 X163.397 Y123.228 E.04487
G1 X159.688 Y126.937 E.18974
G1 X159.688 Y128.178 E.04487
G1 X164.638 Y123.228 E.25319
G1 X165.878 Y123.228 E.04487
G1 X159.688 Y129.418 E.31665
M73 P89 R2
G1 X159.688 Y130.658 E.04487
G1 X167.118 Y123.228 E.3801
G1 X168.359 Y123.228 E.04487
G1 X160.616 Y130.972 E.39612
G1 X161.856 Y130.972 E.04487
G1 X168.512 Y124.316 E.34048
G1 X168.512 Y125.556 E.04487
G1 X163.096 Y130.972 E.27703
G1 X164.337 Y130.972 E.04487
G1 X168.512 Y126.797 E.21357
G1 X168.512 Y128.037 E.04487
G1 X165.577 Y130.972 E.15012
G1 X166.817 Y130.972 E.04487
G1 X168.512 Y129.278 E.08666
G1 X168.512 Y130.518 E.04487
G1 X167.888 Y131.141 E.03189
; COOLING_NODE: 12
M204 S10000
G1 X168.098 Y132.112 F60000
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
; LAYER_HEIGHT: 0.2
G1 F1200
M204 S8000
G1 X168.098 Y132.908 E.02559
G1 X160.102 Y132.908 E.25712
G1 X160.102 Y132.112 E.02559
G1 X168.038 Y132.112 E.25519
; COOLING_NODE: 12
M204 S250
G1 X168.49 Y131.72 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X168.49 Y133.3 E.04706
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

G1 X159.71 Y133.3 E.26153
G1 X159.71 Y131.72 E.04706
G1 X168.43 Y131.72 E.25974
M204 S10000
G1 X167.894 Y132.51 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1200
M204 S8000
G1 X160.306 Y132.51 E.23307
; COOLING_NODE: 12
; WIPE_START
G1 F9259.259
G1 X162.306 Y132.51 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X165.807 Y125.728 Z3.8 F60000
G1 X168.098 Y121.292 Z3.8
G1 Z3.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X168.098 Y122.088 E.02559
G1 X160.102 Y122.088 E.25712
G1 X160.102 Y121.292 E.02559
G1 X168.038 Y121.292 E.25519
; COOLING_NODE: 12
M204 S250
G1 X168.49 Y120.9 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X168.49 Y122.48 E.04706
G1 X159.71 Y122.48 E.26153
G1 X159.71 Y120.9 E.04706
G1 X168.43 Y120.9 E.25974
M204 S10000
G1 X167.894 Y121.69 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1200
M204 S8000
G1 X160.306 Y121.69 E.23307
; CHANGE_LAYER
; Z_HEIGHT: 3.6
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.259
G1 X162.306 Y121.69 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 28/37
; update layer progress
M73 L28
M991 S0 P27 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 12
M204 S10000
G17
G3 Z3.8 I-1.064 J.591 P1  F60000
G1 X168.098 Y132.112 Z3.8
G1 Z3.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X168.098 Y132.908 E.02559
G1 X160.102 Y132.908 E.25712
G1 X160.102 Y132.112 E.02559
G1 X168.038 Y132.112 E.25519
; COOLING_NODE: 12
M204 S250
G1 X168.49 Y131.72 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X168.49 Y133.3 E.04706
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

G1 X159.71 Y133.3 E.26153
G1 X159.71 Y131.72 E.04706
G1 X168.43 Y131.72 E.25974
M204 S10000
G1 X167.894 Y132.51 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43171
G1 F1200
M204 S8000
G1 X160.306 Y132.51 E.23307
; COOLING_NODE: 12
; WIPE_START
G1 F9259.497
G1 X162.306 Y132.51 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X165.807 Y125.728 Z4 F60000
G1 X168.098 Y121.292 Z4
G1 Z3.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X168.098 Y122.088 E.02559
G1 X160.102 Y122.088 E.25712
G1 X160.102 Y121.292 E.02559
G1 X168.038 Y121.292 E.25519
; COOLING_NODE: 12
M204 S250
G1 X168.49 Y120.9 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X168.49 Y122.48 E.04706
G1 X159.71 Y122.48 E.26153
G1 X159.71 Y120.9 E.04706
G1 X168.43 Y120.9 E.25974
M204 S10000
G1 X167.894 Y121.69 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43173
M73 P90 R2
G1 F1200
M204 S8000
G1 X160.306 Y121.69 E.23308
; CHANGE_LAYER
; Z_HEIGHT: 3.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.021
G1 X162.306 Y121.69 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 29/37
; update layer progress
M73 L29
M991 S0 P28 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 12
M204 S10000
G17
G3 Z4 I-1.098 J.525 P1  F60000
G1 X167.284 Y132.094 Z4
G1 Z3.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X164.116 Y132.094 E.10186
G1 X163.716 Y132.094 E.01286
G1 X163.316 Y132.094 E.01286
G1 X162.916 Y132.094 E.01286
G1 X162.516 Y132.094 E.01286
G1 X162.116 Y132.094 E.01286
G1 X161.716 Y132.094 E.01286
G1 X161.316 Y132.094 E.01286
G1 X160.916 Y132.094 E.01286
G1 X160.916 Y131.693 E.0129
G1 X160.916 Y131.31 E.0123
; FEATURE: Overhang wall
G1 F3000
M204 S5000
G1 X160.916 Y122.89 E.27076
; FEATURE: Inner wall
G1 F1200
M204 S8000
G1 X160.916 Y122.508 E.0123
G1 X160.916 Y122.106 E.0129
G1 X161.316 Y122.106 E.01286
G1 X161.716 Y122.106 E.01286
G1 X162.116 Y122.106 E.01286
G1 X162.516 Y122.106 E.01286
G1 X162.916 Y122.106 E.01286
G1 X163.316 Y122.106 E.01286
G1 X163.716 Y122.106 E.01286
G1 X164.116 Y122.106 E.01286
G1 X164.484 Y122.106 E.01182
G1 X164.884 Y122.106 E.01286
G1 X165.284 Y122.106 E.01286
G1 X165.684 Y122.106 E.01286
G1 X166.084 Y122.106 E.01286
G1 X166.484 Y122.106 E.01286
G1 X166.884 Y122.106 E.01286
G1 X167.284 Y122.106 E.01286
G1 X167.284 Y122.508 E.0129
G1 X167.284 Y122.89 E.0123
; FEATURE: Overhang wall
G1 F3000
M204 S5000
G1 X167.284 Y131.31 E.27076
; FEATURE: Inner wall
G1 F1200
M204 S8000
G1 X167.284 Y131.693 E.0123
G1 X167.284 Y132.034 E.01097
; COOLING_NODE: 12
M204 S10000
G1 X167.691 Y132.501 F60000
G1 F1200
M204 S8000
G1 X163.309 Y132.501 E.1409
G1 X162.909 Y132.501 E.01286
G1 X162.509 Y132.501 E.01286
G1 X162.109 Y132.501 E.01286
G1 X161.709 Y132.501 E.01286
G1 X161.309 Y132.501 E.01286
G1 X160.909 Y132.501 E.01286
G1 X160.509 Y132.501 E.01286
G1 X160.509 Y132.093 E.01313
G1 X160.509 Y131.693 E.01286
G1 X160.509 Y131.31 E.0123
; FEATURE: Overhang wall
G1 F3000
M204 S5000
G1 X160.509 Y122.89 E.27076
; FEATURE: Inner wall
G1 F1200
M204 S8000
G1 X160.509 Y122.508 E.0123
G1 X160.509 Y122.108 E.01286
G1 X160.509 Y121.699 E.01313
G1 X160.909 Y121.699 E.01286
G1 X161.309 Y121.699 E.01286
G1 X161.709 Y121.699 E.01286
G1 X162.109 Y121.699 E.01286
G1 X162.509 Y121.699 E.01286
G1 X162.909 Y121.699 E.01286
G1 X163.309 Y121.699 E.01286
G1 X164.891 Y121.699 E.05086
G1 X165.291 Y121.699 E.01286
G1 X165.691 Y121.699 E.01286
G1 X166.091 Y121.699 E.01286
G1 X166.491 Y121.699 E.01286
G1 X166.891 Y121.699 E.01286
G1 X167.291 Y121.699 E.01286
G1 X167.691 Y121.699 E.01286
G1 X167.691 Y122.108 E.01313
G1 X167.691 Y122.508 E.01286
G1 X167.691 Y122.89 E.0123
; FEATURE: Overhang wall
G1 F3000
M204 S5000
G1 X167.691 Y131.31 E.27076
; FEATURE: Inner wall
G1 F1200
M204 S8000
G1 X167.691 Y131.693 E.0123
G1 X167.691 Y132.093 E.01286
G1 X167.691 Y132.441 E.0112
; COOLING_NODE: 12
M204 S10000
G1 X168.098 Y132.908 F60000
G1 F1200
M204 S8000
G1 X162.502 Y132.908 E.17994
G1 X162.102 Y132.908 E.01286
G1 X161.702 Y132.908 E.01286
G1 X161.302 Y132.908 E.01286
G1 X160.902 Y132.908 E.01286
G1 X160.502 Y132.908 E.01286
G1 X160.102 Y132.908 E.01286
G1 X160.102 Y132.493 E.01336
G1 X160.102 Y132.093 E.01286
G1 X160.102 Y131.693 E.01286
G1 X160.102 Y131.31 E.0123
; FEATURE: Overhang wall
G1 F3000
M204 S5000
G1 X160.102 Y122.89 E.27076
; FEATURE: Inner wall
G1 F1200
M204 S8000
G1 X160.102 Y122.508 E.0123
G1 X160.102 Y122.108 E.01286
G1 X160.102 Y121.708 E.01286
G1 X160.102 Y121.292 E.01336
G1 X160.502 Y121.292 E.01286
G1 X160.902 Y121.292 E.01286
G1 X161.302 Y121.292 E.01286
G1 X161.702 Y121.292 E.01286
G1 X162.102 Y121.292 E.01286
G1 X162.502 Y121.292 E.01286
G1 X165.698 Y121.292 E.10277
G1 X166.098 Y121.292 E.01286
G1 X166.498 Y121.292 E.01286
G1 X166.898 Y121.292 E.01286
G1 X167.298 Y121.292 E.01286
G1 X167.698 Y121.292 E.01286
G1 X168.098 Y121.292 E.01286
G1 X168.098 Y121.708 E.01336
G1 X168.098 Y122.108 E.01286
G1 X168.098 Y122.508 E.01286
G1 X168.098 Y122.89 E.0123
; FEATURE: Overhang wall
G1 F3000
M204 S5000
G1 X168.098 Y131.31 E.27076
; FEATURE: Inner wall
G1 F1200
M204 S8000
G1 X168.098 Y131.693 E.0123
G1 X168.098 Y132.093 E.01286
G1 X168.098 Y132.493 E.01286
G1 X168.098 Y132.848 E.01143
; COOLING_NODE: 12
M204 S250
G1 X168.49 Y133.3 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X161.71 Y133.3 E.20195
G1 X161.31 Y133.3 E.01191
G1 X160.91 Y133.3 E.01191
G1 X160.51 Y133.3 E.01191
G1 X160.11 Y133.3 E.01191
G1 X159.71 Y133.3 E.01191
G1 X159.71 Y132.879 E.01254
G1 X159.71 Y132.479 E.01191
G1 X159.71 Y132.079 E.01191
G1 X159.71 Y131.679 E.01191
G1 X159.71 Y131.31 E.01099
; FEATURE: Overhang wall
; LINE_WIDTH: 0.45
G1 F3000
G1 X159.71 Y122.89 E.27076
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
G1 X159.71 Y122.521 E.01099
G1 X159.71 Y122.121 E.01191
G1 X159.71 Y121.721 E.01191
G1 X159.71 Y121.321 E.01191
G1 X159.71 Y120.9 E.01254
G1 X160.11 Y120.9 E.01191
G1 X160.51 Y120.9 E.01191
G1 X160.91 Y120.9 E.01191
G1 X161.31 Y120.9 E.01191
G1 X161.71 Y120.9 E.01191
G1 X166.49 Y120.9 E.14238
G1 X166.89 Y120.9 E.01191
G1 X167.29 Y120.9 E.01191
G1 X167.69 Y120.9 E.01191
G1 X168.09 Y120.9 E.01191
G1 X168.49 Y120.9 E.01191
G1 X168.49 Y121.321 E.01254
G1 X168.49 Y121.721 E.01191
G1 X168.49 Y122.121 E.01191
G1 X168.49 Y122.521 E.01191
G1 X168.49 Y122.89 E.01099
; FEATURE: Overhang wall
; LINE_WIDTH: 0.45
G1 F3000
G1 X168.49 Y131.31 E.27076
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
G1 X168.49 Y131.679 E.01099
G1 X168.49 Y132.079 E.01191
G1 X168.49 Y132.479 E.01191
G1 X168.49 Y132.879 E.01191
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

G1 X168.49 Y133.24 E.01075
; WIPE_START
G1 F4436.78
M204 S8000
G1 X166.49 Y133.258 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X166.949 Y131.93 Z4.2 F60000
G1 Z3.8
G1 E.8 F1800
; FEATURE: Bridge
; LINE_WIDTH: 0.4228
G1 F3000
M204 S8000
G1 X166.949 Y122.439 E.2848
G1 X166.569 Y122.439 E.0114
G1 X166.569 Y131.761 E.2797
G1 X166.189 Y131.761 E.0114
G1 X166.189 Y122.439 E.2797
G1 X165.809 Y122.439 E.0114
G1 X165.809 Y131.761 E.2797
G1 X165.43 Y131.761 E.0114
G1 X165.43 Y122.439 E.2797
G1 X165.05 Y122.439 E.0114
M73 P90 R1
G1 X165.05 Y131.761 E.2797
G1 X164.67 Y131.761 E.0114
G1 X164.67 Y122.439 E.2797
G1 X164.29 Y122.439 E.0114
G1 X164.29 Y131.761 E.2797
G1 X163.91 Y131.761 E.0114
G1 X163.91 Y122.439 E.2797
G1 X163.53 Y122.439 E.0114
G1 X163.53 Y131.761 E.2797
G1 X163.15 Y131.761 E.0114
G1 X163.15 Y122.439 E.2797
G1 X162.77 Y122.439 E.0114
G1 X162.77 Y131.761 E.2797
G1 X162.391 Y131.761 E.0114
G1 X162.391 Y122.439 E.2797
G1 X162.011 Y122.439 E.0114
G1 X162.011 Y131.761 E.2797
G1 X161.631 Y131.761 E.0114
G1 X161.631 Y122.439 E.2797
G1 X161.251 Y122.439 E.0114
G1 X161.251 Y131.93 E.2848
; CHANGE_LAYER
; Z_HEIGHT: 4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F3000
G1 X161.251 Y129.93 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 30/37
; update layer progress
M73 L30
M991 S0 P29 ;notify layer change

M106 S224.4
; OBJECT_ID: 15
; COOLING_NODE: 12
M204 S10000
G17
G3 Z4.2 I-.411 J1.146 P1  F60000
G1 X167.284 Y132.094 Z4.2
G1 Z4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1543
M204 S8000
G1 X160.916 Y132.094 E.20476
G1 X160.916 Y122.106 E.32116
G1 X167.284 Y122.106 E.20476
G1 X167.284 Y132.034 E.31924
; COOLING_NODE: 12
M204 S10000
G1 X167.691 Y132.501 F60000
G1 F1543
M204 S8000
G1 X160.509 Y132.501 E.23094
G1 X160.509 Y121.699 E.34734
G1 X167.691 Y121.699 E.23094
G1 X167.691 Y132.441 E.34542
; COOLING_NODE: 12
M204 S10000
G1 X168.098 Y132.908 F60000
G1 F1543
M204 S8000
M73 P91 R1
G1 X160.102 Y132.908 E.25712
G1 X160.102 Y121.292 E.37352
G1 X168.098 Y121.292 E.25712
G1 X168.098 Y132.848 E.37159
; COOLING_NODE: 12
M204 S250
G1 X168.49 Y133.3 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1215
M204 S5000
G1 X159.71 Y133.3 E.26153
G1 X159.71 Y120.9 E.36935
G1 X168.49 Y120.9 E.26153
G1 X168.49 Y133.24 E.36757
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
G1 X166.49 Y133.254 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X166.342 Y131.93 Z4.4 F60000
G1 Z4
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42759
G1 F1543
M204 S8000
G1 X166.951 Y131.322 E.02616
G1 X166.951 Y130.778 E.01653
G1 X165.968 Y131.761 E.04224
G1 X165.424 Y131.761 E.01653
G1 X166.951 Y130.233 E.06562
G1 X166.951 Y129.69 E.01653
G1 X164.879 Y131.761 E.089
G1 X164.335 Y131.761 E.01653
G1 X166.951 Y129.145 E.11237
G1 X166.951 Y128.601 E.01653
G1 X163.791 Y131.761 E.13575
G1 X163.247 Y131.761 E.01653
G1 X166.951 Y128.057 E.15913
G1 X166.951 Y127.513 E.01653
G1 X162.703 Y131.761 E.18251
G1 X162.159 Y131.761 E.01653
G1 X166.951 Y126.969 E.20588
G1 X166.951 Y126.425 E.01653
G1 X161.615 Y131.761 E.22926
G1 X161.249 Y131.761 E.01112
G1 X161.249 Y131.583 E.00541
G1 X166.951 Y125.881 E.24499
G1 X166.951 Y125.337 E.01653
G1 X161.249 Y131.039 E.24499
G1 X161.249 Y130.495 E.01653
G1 X166.951 Y124.793 E.24499
G1 X166.951 Y124.249 E.01653
G1 X161.249 Y129.951 E.24499
G1 X161.249 Y129.407 E.01653
G1 X166.951 Y123.705 E.24499
G1 X166.951 Y123.161 E.01653
G1 X161.249 Y128.863 E.24499
G1 X161.249 Y128.319 E.01653
G1 X166.951 Y122.617 E.24499
G1 X166.951 Y122.439 E.00541
G1 X166.584 Y122.439 E.01112
G1 X161.249 Y127.774 E.22926
G1 X161.249 Y127.23 E.01653
G1 X166.04 Y122.439 E.20588
G1 X165.496 Y122.439 E.01653
G1 X161.249 Y126.686 E.18251
G1 X161.249 Y126.142 E.01653
G1 X164.952 Y122.439 E.15913
G1 X164.408 Y122.439 E.01653
G1 X161.249 Y125.598 E.13575
G1 X161.249 Y125.054 E.01653
G1 X163.864 Y122.439 E.11237
G1 X163.32 Y122.439 E.01653
G1 X161.249 Y124.51 E.089
G1 X161.249 Y123.966 E.01653
G1 X162.776 Y122.439 E.06562
G1 X162.232 Y122.439 E.01653
G1 X161.249 Y123.422 E.04224
G1 X161.249 Y122.878 E.01653
G1 X161.858 Y122.27 E.02616
; CHANGE_LAYER
; Z_HEIGHT: 4.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9358.671
G1 X161.249 Y122.878 E-.3271
G1 X161.249 Y123.422 E-.20672
G1 X161.67 Y123.002 E-.22618
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 31/37
; update layer progress
M73 L31
M991 S0 P30 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 12
M204 S10000
G17
G3 Z4.4 I-1.036 J.639 P1  F60000
G1 X167.284 Y132.094 Z4.4
G1 Z4.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1541
M204 S8000
G1 X160.916 Y132.094 E.20476
G1 X160.916 Y122.106 E.32116
G1 X167.284 Y122.106 E.20476
G1 X167.284 Y132.034 E.31924
; COOLING_NODE: 12
M204 S10000
G1 X167.691 Y132.501 F60000
G1 F1541
M204 S8000
G1 X160.509 Y132.501 E.23094
G1 X160.509 Y121.699 E.34734
G1 X167.691 Y121.699 E.23094
G1 X167.691 Y132.441 E.34542
; COOLING_NODE: 12
M204 S10000
G1 X168.098 Y132.908 F60000
G1 F1541
M204 S8000
M73 P92 R1
G1 X160.102 Y132.908 E.25712
G1 X160.102 Y121.292 E.37352
G1 X168.098 Y121.292 E.25712
G1 X168.098 Y132.848 E.37159
; COOLING_NODE: 12
M204 S250
G1 X168.49 Y133.3 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1221
M204 S5000
G1 X159.71 Y133.3 E.26153
G1 X159.71 Y120.9 E.36935
G1 X168.49 Y120.9 E.26153
G1 X168.49 Y133.24 E.36757
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
G1 X166.49 Y133.254 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z4.6 I.441 J-1.134 P1  F60000
G1 X161.08 Y131.152 Z4.6
G1 Z4.2
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42759
G1 F1541
M204 S8000
G1 X161.688 Y131.761 E.02616
G1 X162.232 Y131.761 E.01653
G1 X161.249 Y130.778 E.04224
G1 X161.249 Y130.234 E.01653
G1 X162.776 Y131.761 E.06562
G1 X163.32 Y131.761 E.01653
G1 X161.249 Y129.69 E.089
G1 X161.249 Y129.146 E.01653
G1 X163.864 Y131.761 E.11237
G1 X164.408 Y131.761 E.01653
G1 X161.249 Y128.602 E.13575
G1 X161.249 Y128.058 E.01653
G1 X164.952 Y131.761 E.15913
G1 X165.496 Y131.761 E.01653
G1 X161.249 Y127.514 E.18251
G1 X161.249 Y126.969 E.01653
G1 X166.04 Y131.761 E.20588
G1 X166.584 Y131.761 E.01653
G1 X161.249 Y126.425 E.22926
G1 X161.249 Y125.881 E.01653
G1 X166.951 Y131.583 E.24499
G1 X166.951 Y131.039 E.01653
G1 X161.249 Y125.337 E.24499
G1 X161.249 Y124.793 E.01653
G1 X166.951 Y130.495 E.24499
G1 X166.951 Y129.951 E.01653
G1 X161.249 Y124.249 E.24499
G1 X161.249 Y123.705 E.01653
G1 X166.951 Y129.407 E.24499
G1 X166.951 Y128.863 E.01653
G1 X161.249 Y123.161 E.24499
G1 X161.249 Y122.617 E.01653
G1 X166.951 Y128.319 E.24499
G1 X166.951 Y127.775 E.01653
G1 X161.615 Y122.439 E.22926
G1 X162.159 Y122.439 E.01653
G1 X166.951 Y127.231 E.20588
G1 X166.951 Y126.687 E.01653
G1 X162.703 Y122.439 E.18251
G1 X163.247 Y122.439 E.01653
G1 X166.951 Y126.143 E.15913
G1 X166.951 Y125.599 E.01653
G1 X163.791 Y122.439 E.13575
G1 X164.335 Y122.439 E.01653
G1 X166.951 Y125.054 E.11237
G1 X166.951 Y124.51 E.01653
G1 X164.879 Y122.439 E.089
G1 X165.424 Y122.439 E.01653
G1 X166.951 Y123.966 E.06562
G1 X166.951 Y123.422 E.01653
G1 X165.968 Y122.439 E.04224
G1 X166.512 Y122.439 E.01653
G1 X167.12 Y123.048 E.02616
; CHANGE_LAYER
; Z_HEIGHT: 4.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9358.671
G1 X166.512 Y122.439 E-.32711
G1 X165.968 Y122.439 E-.20672
G1 X166.388 Y122.86 E-.22617
; WIPE_END
G1 E-.03999 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 32/37
; update layer progress
M73 L32
M991 S0 P31 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 12
M204 S10000
G17
G3 Z4.6 I-1.211 J.117 P1  F60000
G1 X167.284 Y132.094 Z4.6
G1 Z4.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1539
M204 S8000
G1 X160.916 Y132.094 E.20476
G1 X160.916 Y122.106 E.32116
G1 X167.284 Y122.106 E.20476
G1 X167.284 Y132.034 E.31924
; COOLING_NODE: 12
M204 S10000
G1 X167.691 Y132.501 F60000
G1 F1539
M204 S8000
G1 X160.509 Y132.501 E.23094
G1 X160.509 Y121.699 E.34734
G1 X167.691 Y121.699 E.23094
G1 X167.691 Y132.441 E.34542
; COOLING_NODE: 12
M204 S10000
G1 X168.098 Y132.908 F60000
M73 P93 R1
G1 F1539
M204 S8000
G1 X160.102 Y132.908 E.25712
G1 X160.102 Y121.292 E.37352
G1 X168.098 Y121.292 E.25712
G1 X168.098 Y132.848 E.37159
; COOLING_NODE: 12
M204 S250
G1 X168.49 Y133.3 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1228
M204 S5000
G1 X159.71 Y133.3 E.26153
G1 X159.71 Y120.9 E.36935
G1 X168.49 Y120.9 E.26153
G1 X168.49 Y133.24 E.36757
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
G1 X166.49 Y133.254 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X166.342 Y131.93 Z4.8 F60000
G1 Z4.4
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42759
G1 F1539
M204 S8000
G1 X166.951 Y131.322 E.02616
G1 X166.951 Y130.778 E.01653
G1 X165.968 Y131.761 E.04224
G1 X165.424 Y131.761 E.01653
G1 X166.951 Y130.233 E.06562
G1 X166.951 Y129.69 E.01653
G1 X164.879 Y131.761 E.089
G1 X164.335 Y131.761 E.01653
G1 X166.951 Y129.145 E.11237
G1 X166.951 Y128.601 E.01653
G1 X163.791 Y131.761 E.13575
G1 X163.247 Y131.761 E.01653
G1 X166.951 Y128.057 E.15913
G1 X166.951 Y127.513 E.01653
G1 X162.703 Y131.761 E.18251
G1 X162.159 Y131.761 E.01653
G1 X166.951 Y126.969 E.20588
G1 X166.951 Y126.425 E.01653
G1 X161.615 Y131.761 E.22926
G1 X161.249 Y131.761 E.01112
G1 X161.249 Y131.583 E.00541
G1 X166.951 Y125.881 E.24499
G1 X166.951 Y125.337 E.01653
G1 X161.249 Y131.039 E.24499
G1 X161.249 Y130.495 E.01653
G1 X166.951 Y124.793 E.24499
G1 X166.951 Y124.249 E.01653
G1 X161.249 Y129.951 E.24499
G1 X161.249 Y129.407 E.01653
G1 X166.951 Y123.705 E.24499
G1 X166.951 Y123.161 E.01653
G1 X161.249 Y128.863 E.24499
G1 X161.249 Y128.319 E.01653
G1 X166.951 Y122.617 E.24499
G1 X166.951 Y122.439 E.00541
G1 X166.584 Y122.439 E.01112
G1 X161.249 Y127.774 E.22926
G1 X161.249 Y127.23 E.01653
G1 X166.04 Y122.439 E.20588
G1 X165.496 Y122.439 E.01653
G1 X161.249 Y126.686 E.18251
G1 X161.249 Y126.142 E.01653
G1 X164.952 Y122.439 E.15913
G1 X164.408 Y122.439 E.01653
G1 X161.249 Y125.598 E.13575
G1 X161.249 Y125.054 E.01653
G1 X163.864 Y122.439 E.11237
G1 X163.32 Y122.439 E.01653
G1 X161.249 Y124.51 E.089
G1 X161.249 Y123.966 E.01653
G1 X162.776 Y122.439 E.06562
G1 X162.232 Y122.439 E.01653
G1 X161.249 Y123.422 E.04224
G1 X161.249 Y122.878 E.01653
G1 X161.858 Y122.27 E.02616
; CHANGE_LAYER
; Z_HEIGHT: 4.6
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9358.671
G1 X161.249 Y122.878 E-.3271
G1 X161.249 Y123.422 E-.20672
G1 X161.67 Y123.002 E-.22618
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 33/37
; update layer progress
M73 L33
M991 S0 P32 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 12
M204 S10000
G17
G3 Z4.8 I-1.036 J.639 P1  F60000
G1 X167.284 Y132.094 Z4.8
G1 Z4.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1540
M204 S8000
G1 X160.916 Y132.094 E.20476
G1 X160.916 Y122.106 E.32116
G1 X167.284 Y122.106 E.20476
G1 X167.284 Y132.034 E.31924
; COOLING_NODE: 12
M204 S10000
G1 X167.691 Y132.501 F60000
G1 F1540
M204 S8000
G1 X160.509 Y132.501 E.23094
G1 X160.509 Y121.699 E.34734
G1 X167.691 Y121.699 E.23094
G1 X167.691 Y132.441 E.34542
; COOLING_NODE: 12
M204 S10000
G1 X168.098 Y132.908 F60000
M73 P94 R1
G1 F1540
M204 S8000
G1 X160.102 Y132.908 E.25712
G1 X160.102 Y121.292 E.37352
G1 X168.098 Y121.292 E.25712
G1 X168.098 Y132.848 E.37159
; COOLING_NODE: 12
M204 S250
G1 X168.49 Y133.3 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1234
M204 S5000
G1 X159.71 Y133.3 E.26153
G1 X159.71 Y120.9 E.36935
G1 X168.49 Y120.9 E.26153
G1 X168.49 Y133.24 E.36757
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
G1 X166.49 Y133.254 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X161.08 Y131.152 Z5 F60000
G1 Z4.6
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42759
G1 F1540
M204 S8000
G1 X161.688 Y131.761 E.02616
G1 X162.232 Y131.761 E.01653
G1 X161.249 Y130.778 E.04224
G1 X161.249 Y130.234 E.01653
G1 X162.776 Y131.761 E.06562
G1 X163.32 Y131.761 E.01653
G1 X161.249 Y129.69 E.089
G1 X161.249 Y129.146 E.01653
G1 X163.864 Y131.761 E.11237
G1 X164.408 Y131.761 E.01653
G1 X161.249 Y128.602 E.13575
G1 X161.249 Y128.058 E.01653
G1 X164.952 Y131.761 E.15913
G1 X165.496 Y131.761 E.01653
G1 X161.249 Y127.514 E.18251
G1 X161.249 Y126.969 E.01653
G1 X166.04 Y131.761 E.20588
G1 X166.584 Y131.761 E.01653
G1 X161.249 Y126.425 E.22926
G1 X161.249 Y125.881 E.01653
G1 X166.951 Y131.583 E.24499
G1 X166.951 Y131.039 E.01653
G1 X161.249 Y125.337 E.24499
G1 X161.249 Y124.793 E.01653
G1 X166.951 Y130.495 E.24499
G1 X166.951 Y129.951 E.01653
G1 X161.249 Y124.249 E.24499
G1 X161.249 Y123.705 E.01653
G1 X166.951 Y129.407 E.24499
G1 X166.951 Y128.863 E.01653
G1 X161.249 Y123.161 E.24499
G1 X161.249 Y122.617 E.01653
G1 X166.951 Y128.319 E.24499
G1 X166.951 Y127.775 E.01653
G1 X161.615 Y122.439 E.22926
G1 X162.159 Y122.439 E.01653
G1 X166.951 Y127.231 E.20588
G1 X166.951 Y126.687 E.01653
G1 X162.703 Y122.439 E.18251
G1 X163.247 Y122.439 E.01653
G1 X166.951 Y126.143 E.15913
G1 X166.951 Y125.599 E.01653
G1 X163.791 Y122.439 E.13575
G1 X164.335 Y122.439 E.01653
G1 X166.951 Y125.054 E.11237
G1 X166.951 Y124.51 E.01653
G1 X164.879 Y122.439 E.089
G1 X165.424 Y122.439 E.01653
G1 X166.951 Y123.966 E.06562
G1 X166.951 Y123.422 E.01653
G1 X165.968 Y122.439 E.04224
G1 X166.512 Y122.439 E.01653
G1 X167.12 Y123.048 E.02616
; CHANGE_LAYER
; Z_HEIGHT: 4.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9358.671
G1 X166.512 Y122.439 E-.32711
G1 X165.968 Y122.439 E-.20672
G1 X166.388 Y122.86 E-.22617
; WIPE_END
G1 E-.03999 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 34/37
; update layer progress
M73 L34
M991 S0 P33 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 12
M204 S10000
G17
G3 Z5 I-1.211 J.117 P1  F60000
G1 X167.284 Y132.094 Z5
G1 Z4.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1539
M204 S8000
G1 X160.916 Y132.094 E.20476
G1 X160.916 Y122.106 E.32116
G1 X167.284 Y122.106 E.20476
G1 X167.284 Y132.034 E.31924
; COOLING_NODE: 12
M204 S10000
G1 X167.691 Y132.501 F60000
G1 F1539
M204 S8000
G1 X160.509 Y132.501 E.23094
G1 X160.509 Y121.699 E.34734
G1 X167.691 Y121.699 E.23094
G1 X167.691 Y132.441 E.34542
; COOLING_NODE: 12
M204 S10000
G1 X168.098 Y132.908 F60000
M73 P95 R1
G1 F1539
M204 S8000
G1 X160.102 Y132.908 E.25712
G1 X160.102 Y121.292 E.37352
G1 X168.098 Y121.292 E.25712
G1 X168.098 Y132.848 E.37159
; COOLING_NODE: 12
M204 S250
G1 X168.49 Y133.3 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1239
M204 S5000
G1 X159.71 Y133.3 E.26153
G1 X159.71 Y120.9 E.36935
G1 X168.49 Y120.9 E.26153
G1 X168.49 Y133.24 E.36757
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
G1 X166.49 Y133.254 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
M73 P95 R0
G1 X166.342 Y131.93 Z5.2 F60000
G1 Z4.8
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42759
G1 F1539
M204 S8000
G1 X166.951 Y131.322 E.02616
G1 X166.951 Y130.778 E.01653
G1 X165.968 Y131.761 E.04224
G1 X165.424 Y131.761 E.01653
G1 X166.951 Y130.233 E.06562
G1 X166.951 Y129.69 E.01653
G1 X164.879 Y131.761 E.089
G1 X164.335 Y131.761 E.01653
G1 X166.951 Y129.145 E.11237
G1 X166.951 Y128.601 E.01653
G1 X163.791 Y131.761 E.13575
G1 X163.247 Y131.761 E.01653
G1 X166.951 Y128.057 E.15913
G1 X166.951 Y127.513 E.01653
G1 X162.703 Y131.761 E.18251
G1 X162.159 Y131.761 E.01653
G1 X166.951 Y126.969 E.20588
G1 X166.951 Y126.425 E.01653
G1 X161.615 Y131.761 E.22926
G1 X161.249 Y131.761 E.01112
G1 X161.249 Y131.583 E.00541
G1 X166.951 Y125.881 E.24499
G1 X166.951 Y125.337 E.01653
G1 X161.249 Y131.039 E.24499
G1 X161.249 Y130.495 E.01653
G1 X166.951 Y124.793 E.24499
G1 X166.951 Y124.249 E.01653
G1 X161.249 Y129.951 E.24499
G1 X161.249 Y129.407 E.01653
G1 X166.951 Y123.705 E.24499
G1 X166.951 Y123.161 E.01653
G1 X161.249 Y128.863 E.24499
G1 X161.249 Y128.319 E.01653
G1 X166.951 Y122.617 E.24499
G1 X166.951 Y122.439 E.00541
G1 X166.584 Y122.439 E.01112
G1 X161.249 Y127.774 E.22926
G1 X161.249 Y127.23 E.01653
G1 X166.04 Y122.439 E.20588
G1 X165.496 Y122.439 E.01653
G1 X161.249 Y126.686 E.18251
G1 X161.249 Y126.142 E.01653
G1 X164.952 Y122.439 E.15913
G1 X164.408 Y122.439 E.01653
G1 X161.249 Y125.598 E.13575
G1 X161.249 Y125.054 E.01653
G1 X163.864 Y122.439 E.11237
G1 X163.32 Y122.439 E.01653
G1 X161.249 Y124.51 E.089
G1 X161.249 Y123.966 E.01653
G1 X162.776 Y122.439 E.06562
G1 X162.232 Y122.439 E.01653
G1 X161.249 Y123.422 E.04224
G1 X161.249 Y122.878 E.01653
G1 X161.858 Y122.27 E.02616
; CHANGE_LAYER
; Z_HEIGHT: 5
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9358.671
G1 X161.249 Y122.878 E-.3271
G1 X161.249 Y123.422 E-.20672
G1 X161.67 Y123.002 E-.22618
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 35/37
; update layer progress
M73 L35
M991 S0 P34 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 12
M204 S10000
G17
G3 Z5.2 I-1.036 J.639 P1  F60000
G1 X167.284 Y132.094 Z5.2
G1 Z5
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1540
M204 S8000
G1 X160.916 Y132.094 E.20476
G1 X160.916 Y122.106 E.32116
G1 X167.284 Y122.106 E.20476
G1 X167.284 Y132.034 E.31924
; COOLING_NODE: 12
M204 S10000
G1 X167.691 Y132.501 F60000
G1 F1540
M204 S8000
G1 X160.509 Y132.501 E.23094
G1 X160.509 Y121.699 E.34734
G1 X167.691 Y121.699 E.23094
G1 X167.691 Y132.441 E.34542
; COOLING_NODE: 12
M204 S10000
G1 X168.098 Y132.908 F60000
M73 P96 R0
G1 F1540
M204 S8000
G1 X160.102 Y132.908 E.25712
G1 X160.102 Y121.292 E.37352
G1 X168.098 Y121.292 E.25712
G1 X168.098 Y132.848 E.37159
; COOLING_NODE: 12
M204 S250
G1 X168.49 Y133.3 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1243
M204 S5000
G1 X159.71 Y133.3 E.26153
G1 X159.71 Y120.9 E.36935
G1 X168.49 Y120.9 E.26153
G1 X168.49 Y133.24 E.36757
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
G1 X166.49 Y133.254 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X161.08 Y131.152 Z5.4 F60000
G1 Z5
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42759
G1 F1540
M204 S8000
G1 X161.688 Y131.761 E.02616
G1 X162.232 Y131.761 E.01653
G1 X161.249 Y130.778 E.04224
G1 X161.249 Y130.234 E.01653
G1 X162.776 Y131.761 E.06562
G1 X163.32 Y131.761 E.01653
G1 X161.249 Y129.69 E.089
G1 X161.249 Y129.146 E.01653
G1 X163.864 Y131.761 E.11237
G1 X164.408 Y131.761 E.01653
G1 X161.249 Y128.602 E.13575
G1 X161.249 Y128.058 E.01653
G1 X164.952 Y131.761 E.15913
G1 X165.496 Y131.761 E.01653
G1 X161.249 Y127.514 E.18251
G1 X161.249 Y126.969 E.01653
G1 X166.04 Y131.761 E.20588
G1 X166.584 Y131.761 E.01653
G1 X161.249 Y126.425 E.22926
G1 X161.249 Y125.881 E.01653
G1 X166.951 Y131.583 E.24499
G1 X166.951 Y131.039 E.01653
G1 X161.249 Y125.337 E.24499
G1 X161.249 Y124.793 E.01653
G1 X166.951 Y130.495 E.24499
G1 X166.951 Y129.951 E.01653
G1 X161.249 Y124.249 E.24499
G1 X161.249 Y123.705 E.01653
G1 X166.951 Y129.407 E.24499
G1 X166.951 Y128.863 E.01653
G1 X161.249 Y123.161 E.24499
G1 X161.249 Y122.617 E.01653
G1 X166.951 Y128.319 E.24499
G1 X166.951 Y127.775 E.01653
G1 X161.615 Y122.439 E.22926
G1 X162.159 Y122.439 E.01653
G1 X166.951 Y127.231 E.20588
G1 X166.951 Y126.687 E.01653
G1 X162.703 Y122.439 E.18251
G1 X163.247 Y122.439 E.01653
G1 X166.951 Y126.143 E.15913
G1 X166.951 Y125.599 E.01653
G1 X163.791 Y122.439 E.13575
G1 X164.335 Y122.439 E.01653
G1 X166.951 Y125.054 E.11237
G1 X166.951 Y124.51 E.01653
G1 X164.879 Y122.439 E.089
G1 X165.424 Y122.439 E.01653
G1 X166.951 Y123.966 E.06562
G1 X166.951 Y123.422 E.01653
G1 X165.968 Y122.439 E.04224
G1 X166.512 Y122.439 E.01653
G1 X167.12 Y123.048 E.02616
; CHANGE_LAYER
; Z_HEIGHT: 5.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9358.671
G1 X166.512 Y122.439 E-.32711
G1 X165.968 Y122.439 E-.20672
G1 X166.388 Y122.86 E-.22617
; WIPE_END
G1 E-.03999 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 36/37
; update layer progress
M73 L36
M991 S0 P35 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 12
M204 S10000
G17
G3 Z5.4 I-1.211 J.117 P1  F60000
G1 X167.284 Y132.094 Z5.4
G1 Z5.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1539
M204 S8000
G1 X160.916 Y132.094 E.20476
G1 X160.916 Y122.106 E.32116
G1 X167.284 Y122.106 E.20476
G1 X167.284 Y132.034 E.31924
; COOLING_NODE: 12
M204 S10000
G1 X167.691 Y132.501 F60000
G1 F1539
M204 S8000
G1 X160.509 Y132.501 E.23094
G1 X160.509 Y121.699 E.34734
G1 X167.691 Y121.699 E.23094
G1 X167.691 Y132.441 E.34542
; COOLING_NODE: 12
M204 S10000
G1 X168.098 Y132.908 F60000
M73 P97 R0
G1 F1539
M204 S8000
G1 X160.102 Y132.908 E.25712
G1 X160.102 Y121.292 E.37352
G1 X168.098 Y121.292 E.25712
G1 X168.098 Y132.848 E.37159
; COOLING_NODE: 12
M204 S250
G1 X168.49 Y133.3 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1246
M204 S5000
G1 X159.71 Y133.3 E.26153
G1 X159.71 Y120.9 E.36935
G1 X168.49 Y120.9 E.26153
G1 X168.49 Y133.24 E.36757
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
G1 X166.49 Y133.254 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X166.342 Y131.93 Z5.6 F60000
G1 Z5.2
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42759
G1 F1539
M204 S8000
G1 X166.951 Y131.322 E.02616
G1 X166.951 Y130.778 E.01653
G1 X165.968 Y131.761 E.04224
G1 X165.424 Y131.761 E.01653
G1 X166.951 Y130.233 E.06562
G1 X166.951 Y129.69 E.01653
G1 X164.879 Y131.761 E.089
G1 X164.335 Y131.761 E.01653
G1 X166.951 Y129.145 E.11237
G1 X166.951 Y128.601 E.01653
G1 X163.791 Y131.761 E.13575
G1 X163.247 Y131.761 E.01653
G1 X166.951 Y128.057 E.15913
G1 X166.951 Y127.513 E.01653
G1 X162.703 Y131.761 E.18251
G1 X162.159 Y131.761 E.01653
G1 X166.951 Y126.969 E.20588
G1 X166.951 Y126.425 E.01653
G1 X161.615 Y131.761 E.22926
G1 X161.249 Y131.761 E.01112
G1 X161.249 Y131.583 E.00541
G1 X166.951 Y125.881 E.24499
G1 X166.951 Y125.337 E.01653
G1 X161.249 Y131.039 E.24499
G1 X161.249 Y130.495 E.01653
G1 X166.951 Y124.793 E.24499
G1 X166.951 Y124.249 E.01653
G1 X161.249 Y129.951 E.24499
G1 X161.249 Y129.407 E.01653
G1 X166.951 Y123.705 E.24499
G1 X166.951 Y123.161 E.01653
G1 X161.249 Y128.863 E.24499
G1 X161.249 Y128.319 E.01653
G1 X166.951 Y122.617 E.24499
G1 X166.951 Y122.439 E.00541
G1 X166.584 Y122.439 E.01112
G1 X161.249 Y127.774 E.22926
G1 X161.249 Y127.23 E.01653
G1 X166.04 Y122.439 E.20588
G1 X165.496 Y122.439 E.01653
G1 X161.249 Y126.686 E.18251
G1 X161.249 Y126.142 E.01653
G1 X164.952 Y122.439 E.15913
G1 X164.408 Y122.439 E.01653
G1 X161.249 Y125.598 E.13575
G1 X161.249 Y125.054 E.01653
G1 X163.864 Y122.439 E.11237
G1 X163.32 Y122.439 E.01653
G1 X161.249 Y124.51 E.089
G1 X161.249 Y123.966 E.01653
G1 X162.776 Y122.439 E.06562
G1 X162.232 Y122.439 E.01653
G1 X161.249 Y123.422 E.04224
G1 X161.249 Y122.878 E.01653
G1 X161.858 Y122.27 E.02616
; CHANGE_LAYER
; Z_HEIGHT: 5.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9358.671
G1 X161.249 Y122.878 E-.3271
G1 X161.249 Y123.422 E-.20672
G1 X161.67 Y123.002 E-.22618
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 37/37
; update layer progress
M73 L37
M991 S0 P36 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 12
M204 S10000
G17
G3 Z5.6 I-1.015 J.672 P1  F60000
G1 X168.49 Y133.3 Z5.6
G1 Z5.4
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1248
M204 S5000
G1 X159.71 Y133.3 E.26153
G1 X159.71 Y120.9 E.36935
G1 X168.49 Y120.9 E.26153
G1 X168.49 Y133.24 E.36757
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
G1 X166.49 Y133.254 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
M73 P98 R0
G1 X167.646 Y125.709 Z5.8 F60000
G1 X168.283 Y121.554 Z5.8
G1 Z5.4
G1 E.8 F1800
; FEATURE: Top surface
G1 F1805
M204 S2000
G1 X167.836 Y121.107 E.01881
G1 X167.702 Y120.974
G1 X167.169 Y120.974
G1 X167.303 Y121.107
G1 X168.283 Y122.087 E.04127
G1 X168.416 Y122.221
G1 X168.416 Y122.754
G1 X168.283 Y122.62
G1 X166.77 Y121.107 E.06373
G1 X166.636 Y120.974
G1 X166.103 Y120.974
G1 X166.236 Y121.107
G1 X168.283 Y123.154 E.0862
G1 X168.416 Y123.287
G1 X168.416 Y123.821
G1 X168.283 Y123.687
G1 X165.703 Y121.107 E.10866
G1 X165.569 Y120.974
G1 X165.036 Y120.974
G1 X165.17 Y121.107
G1 X168.283 Y124.22 E.13113
G1 X168.416 Y124.354
G1 X168.416 Y124.887
G1 X168.283 Y124.753
G1 X164.637 Y121.107 E.15359
G1 X164.503 Y120.974
G1 X163.97 Y120.974
G1 X164.103 Y121.107
G1 X168.283 Y125.287 E.17605
G1 X168.416 Y125.42
G1 X168.416 Y125.954
G1 X168.283 Y125.82
G1 X163.57 Y121.107 E.19851
G1 X163.436 Y120.974
G1 X162.903 Y120.974
G1 X163.037 Y121.107
G1 X168.283 Y126.353 E.22098
G1 X168.416 Y126.487
G1 X168.416 Y127.02
G1 X168.283 Y126.886
G1 X162.504 Y121.107 E.24344
G1 X162.37 Y120.974
G1 X161.837 Y120.974
G1 X161.97 Y121.107
G1 X168.283 Y127.42 E.2659
G1 X168.416 Y127.553
G1 X168.416 Y128.087
G1 X168.283 Y127.953
G1 X161.437 Y121.107 E.28837
G1 X161.303 Y120.974
G1 X160.77 Y120.974
G1 X160.904 Y121.107
G1 X168.283 Y128.486 E.31083
G1 X168.416 Y128.62
G1 X168.416 Y129.153
G1 X168.283 Y129.019
G1 X160.371 Y121.107 E.33329
G1 X160.237 Y120.974
G1 X159.784 Y121.054
G1 X159.917 Y121.187
G1 X168.283 Y129.553 E.35238
G1 X168.416 Y129.686
G1 X168.416 Y130.22
G1 X168.283 Y130.086
G1 X159.917 Y121.721 E.35238
G1 X159.784 Y121.587
G1 X159.784 Y122.12
G1 X159.917 Y122.254
G1 X168.283 Y130.619 E.35238
G1 X168.416 Y130.753
G1 X168.416 Y131.286
G1 X168.283 Y131.153
G1 X159.917 Y122.787 E.35238
G1 X159.784 Y122.654
G1 X159.784 Y123.187
G1 X159.917 Y123.321
G1 X168.283 Y131.686 E.35238
G1 X168.416 Y131.819
G1 X168.416 Y132.353
G1 X168.283 Y132.219
G1 X159.917 Y123.854 E.35238
G1 X159.784 Y123.72
G1 X159.784 Y124.253
G1 X159.917 Y124.387
G1 X168.283 Y132.752 E.35238
G1 X168.416 Y132.886
G1 X168.223 Y133.226
G1 X168.09 Y133.093
G1 X159.917 Y124.92 E.34426
G1 X159.784 Y124.787
G1 X159.784 Y125.32
G1 X159.917 Y125.454
G1 X167.556 Y133.093 E.32179
G1 X167.69 Y133.226
G1 X167.157 Y133.226
G1 X167.023 Y133.093
G1 X159.917 Y125.987 E.29933
G1 X159.784 Y125.853
M73 P99 R0
G1 X159.784 Y126.386
G1 X159.917 Y126.52
G1 X166.49 Y133.093 E.27687
G1 X166.624 Y133.226
G1 X166.09 Y133.226
G1 X165.957 Y133.093
G1 X159.917 Y127.053 E.2544
G1 X159.784 Y126.92
G1 X159.784 Y127.453
G1 X159.917 Y127.587
G1 X165.423 Y133.093 E.23194
G1 X165.557 Y133.226
G1 X165.024 Y133.226
G1 X164.89 Y133.093
G1 X159.917 Y128.12 E.20948
G1 X159.784 Y127.986
G1 X159.784 Y128.519
G1 X159.917 Y128.653
G1 X164.357 Y133.093 E.18701
G1 X164.491 Y133.226
G1 X163.957 Y133.226
G1 X163.824 Y133.093
G1 X159.917 Y129.186 E.16455
G1 X159.784 Y129.053
G1 X159.784 Y129.586
G1 X159.917 Y129.72
G1 X163.29 Y133.093 E.14209
G1 X163.424 Y133.226
G1 X162.891 Y133.226
G1 X162.757 Y133.093
G1 X159.917 Y130.253 E.11962
G1 X159.784 Y130.119
G1 X159.784 Y130.652
G1 X159.917 Y130.786
G1 X162.224 Y133.093 E.09716
G1 X162.358 Y133.226
G1 X161.824 Y133.226
G1 X161.691 Y133.093
G1 X159.917 Y131.319 E.0747
G1 X159.784 Y131.186
G1 X159.784 Y131.719
G1 X159.917 Y131.853
G1 X161.157 Y133.093 E.05223
G1 X161.291 Y133.226
G1 X160.758 Y133.226
G1 X160.624 Y133.093
G1 X159.917 Y132.386 E.02977
; close powerlost recovery
M1003 S0
; WIPE_START
G1 F9547.055
M204 S8000
G1 X160.624 Y133.093 E-.3798
G1 X160.758 Y133.226 E-.07182
G1 X161.291 Y133.226 E-.20264
G1 X161.157 Y133.093 E-.07182
G1 X161.094 Y133.029 E-.03393
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z5.8 I1.217 J0 P1  F60000
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
G1 Z5.8 F900 ; lower z a little
M1002 judge_flag timelapse_record_flag
M622 J1
    G150.3
    M400 ; wait all motion done
    M991 S0 P-1 ;end smooth timelapse at safe pos
    M400 S5 ;wait for last picture to be taken
M623  ;end of "timelapse_record_flag"

G90
G1 Z15.4 F900 ; lower z a little

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

    
        G1 Z102.7 F600
        G1 Z100.7
    

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

