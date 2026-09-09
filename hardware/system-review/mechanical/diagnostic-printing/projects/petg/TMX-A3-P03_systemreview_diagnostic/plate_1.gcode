; HEADER_BLOCK_START
; BambuStudio 02.08.02.61
; model printing time: 15m 34s; total estimated time: 21m 1s
; total layer number: 37
; total filament length [mm] : 1767.25
; total filament volume [cm^3] : 4250.75
; total filament weight [g] : 5.40
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
M73 P24 R15
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
M73 P25 R15
G1 X159.05 Y122.876 F60000
M204 S6000
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
M73 P26 R15
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
G1 X159.121 Y196.75 E2.28773
G1 X159.177 Y196.936 E.007
G1 X159.299 Y197.062 E.00631
G1 X159.5 Y197.129 E.00766
G1 X179.846 Y197.129 E.73463
G1 X179.846 Y210 E.46474
G1 X179.902 Y210.186 E.007
G1 X180.024 Y210.312 E.00631
G1 X180.225 Y210.379 E.00766
G1 X189.9 Y210.379 E.34933
G1 X190.086 Y210.323 E.007
G1 X190.212 Y210.201 E.00631
G1 X190.259 Y210.091 E.00433
G1 X190.279 Y210 E.00337
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
M73 P27 R15
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
G1 X190.613 Y213.502 E.0205
G1 X189.888 Y213.578 E.02632
G1 X180.234 Y213.578 E.34855
G1 X179.665 Y213.531 E.02062
G1 X178.85 Y213.289 E.03072
G1 X178.245 Y212.974 E.0246
G1 X177.799 Y212.628 E.02039
G1 X177.415 Y212.212 E.02045
G1 X177.103 Y211.737 E.02053
G1 X176.925 Y211.356 E.01517
G1 X176.723 Y210.712 E.02439
G1 X176.647 Y209.988 E.02627
G1 X176.647 Y200.557 E.34053
G1 X176.598 Y200.416 E.00538
G1 X176.418 Y200.328 E.00722
G1 X159.509 Y200.328 E.61052
G1 X158.94 Y200.281 E.02062
G1 X158.029 Y199.998 E.03446
G1 X157.522 Y199.725 E.02079
G1 X157.074 Y199.378 E.02045
G1 X156.69 Y198.962 E.02045
G1 X156.378 Y198.488 E.02048
G1 X156.161 Y198.007 E.01907
G1 X155.998 Y197.463 E.0205
G1 X155.922 Y196.738 E.02632
G1 X155.922 Y131.519 E2.35479
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
G1 X158.664 Y196.74 E2.26592
G1 X158.735 Y197.052 E.01155
G1 X158.86 Y197.265 E.0089
G1 X158.958 Y197.367 E.00513
G1 X159.17 Y197.5 E.00905
G1 X159.345 Y197.559 E.00666
G1 X159.511 Y197.586 E.00607
G1 X179.252 Y197.586 E.71278
G1 X179.356 Y197.633 E.00413
G1 X179.389 Y197.723 E.00344
G1 X179.389 Y209.99 E.44292
G1 X179.46 Y210.302 E.01155
G1 X179.585 Y210.515 E.0089
G1 X179.683 Y210.617 E.00513
G1 X179.895 Y210.75 E.00905
G1 X180.07 Y210.809 E.00666
G1 X180.236 Y210.836 E.00607
G1 X189.89 Y210.836 E.34856
G1 X190.202 Y210.765 E.01155
G1 X190.415 Y210.64 E.0089
G1 X190.519 Y210.54 E.00524
G1 X190.636 Y210.372 E.00739
G1 X190.674 Y210.283 E.00348
G1 X190.736 Y209.993 E.01072
G1 X190.736 Y183.982 E.93914
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
M73 P28 R15
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
G1 X180.248 Y213.12 E.34695
G1 X179.736 Y213.075 E.01853
G1 X179.034 Y212.867 E.02644
G1 X178.504 Y212.594 E.02155
G1 X178.101 Y212.282 E.01838
G1 X177.77 Y211.921 E.0177
G1 X177.499 Y211.505 E.01792
G1 X177.35 Y211.182 E.01285
G1 X177.171 Y210.605 E.02181
G1 X177.104 Y209.957 E.02351
G1 X177.104 Y200.568 E.339
G1 X177.035 Y200.28 E.0107
G1 X176.932 Y200.107 E.00726
G1 X176.787 Y199.999 E.00654
G1 X176.633 Y199.924 E.0062
G1 X176.403 Y199.871 E.00851
G1 X159.534 Y199.871 E.60906
G1 X159.043 Y199.831 E.0178
G1 X158.195 Y199.568 E.03206
G1 X157.763 Y199.334 E.01774
G1 X157.376 Y199.032 E.01771
G1 X157.045 Y198.671 E.0177
G1 X156.786 Y198.276 E.01702
G1 X156.594 Y197.855 E.01673
G1 X156.452 Y197.385 E.01771
G1 X156.379 Y196.707 E.02462
G1 X156.379 Y131.544 E2.35278
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
G1 X158.207 Y196.727 E2.24894
G1 X158.288 Y197.145 E.01536
G1 X158.345 Y197.289 E.00561
G1 X158.537 Y197.588 E.01283
G1 X158.723 Y197.758 E.00908
G1 X159.037 Y197.938 E.01307
G1 X159.279 Y198.011 E.00913
G1 X159.52 Y198.043 E.00878
G1 X178.795 Y198.043 E.69595
G1 X178.899 Y198.09 E.00413
G1 X178.932 Y198.18 E.00344
G1 X178.932 Y209.977 E.42594
G1 X179.013 Y210.395 E.01536
G1 X179.071 Y210.542 E.00572
G1 X179.184 Y210.735 E.00808
G1 X179.351 Y210.931 E.0093
G1 X179.444 Y211.006 E.00431
G1 X179.762 Y211.188 E.01322
G1 X180.004 Y211.261 E.00913
G1 X180.245 Y211.293 E.00878
G1 X189.877 Y211.293 E.34776
G1 X190.295 Y211.212 E.01536
G1 X190.442 Y211.154 E.00572
G1 X190.639 Y211.039 E.00822
G1 X190.735 Y210.966 E.00438
G1 X190.9 Y210.792 E.00865
G1 X191.006 Y210.641 E.00666
G1 X191.089 Y210.473 E.00675
G1 X191.193 Y209.986 E.01799
G1 X191.193 Y184.242 E.92951
G1 X191.24 Y184.138 E.00412
G1 X191.426 Y183.977 E.00888
G1 X191.631 Y183.682 E.01299
G1 X191.739 Y183.406 E.01069
G1 X191.793 Y183.078 E.01201
G1 X191.793 Y145.923 E1.34151
G1 X191.712 Y145.505 E.01536
G1 X191.655 Y145.361 E.00561
G1 X191.463 Y145.063 E.01278
M73 P28 R14
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
G1 X180.262 Y212.663 E.34529
G1 X179.809 Y212.62 E.01641
G1 X179.218 Y212.445 E.02227
G1 X178.762 Y212.212 E.01849
G1 X178.404 Y211.936 E.01633
G1 X178.126 Y211.63 E.01492
G1 X177.896 Y211.274 E.01531
G1 X177.775 Y211.009 E.01052
G1 X177.62 Y210.499 E.01923
G1 X177.561 Y209.926 E.0208
G1 X177.561 Y200.576 E.3376
G1 X177.482 Y200.183 E.01446
G1 X177.422 Y200.037 E.00572
G1 X177.331 Y199.885 E.0064
G1 X177.194 Y199.733 E.0074
M73 P29 R14
G1 X177.068 Y199.639 E.00568
G1 X176.842 Y199.518 E.00927
G1 X176.51 Y199.427 E.01241
G1 X176.395 Y199.414 E.00419
G1 X159.558 Y199.414 E.6079
G1 X159.145 Y199.38 E.01498
G1 X158.361 Y199.139 E.02962
G1 X158.005 Y198.943 E.01465
G1 X157.68 Y198.687 E.01497
G1 X157.414 Y198.397 E.01418
G1 X157.193 Y198.064 E.01444
G1 X157.026 Y197.701 E.0144
G1 X156.905 Y197.306 E.01493
G1 X156.836 Y196.675 E.02291
G1 X156.836 Y134.301 E2.25208
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
G1 X157.75 Y196.715 E2.23237
G1 X157.837 Y197.222 E.01858
G1 X157.917 Y197.448 E.00865
G1 X158.15 Y197.83 E.01613
G1 X158.233 Y197.928 E.00466
G1 X158.506 Y198.16 E.01292
G1 X158.916 Y198.378 E.01678
G1 X159.228 Y198.465 E.01167
G1 X159.528 Y198.5 E.01093
G1 X178.338 Y198.5 E.67915
G1 X178.442 Y198.547 E.00413
G1 X178.475 Y198.637 E.00344
G1 X178.475 Y209.965 E.40902
G1 X178.562 Y210.472 E.01858
G1 X178.644 Y210.704 E.00886
G1 X178.785 Y210.958 E.01051
G1 X178.998 Y211.22 E.01217
G1 X179.226 Y211.407 E.01066
G1 X179.641 Y211.628 E.01698
G1 X179.953 Y211.715 E.01167
G1 X180.253 Y211.75 E.01093
G1 X189.865 Y211.75 E.34705
G1 X190.372 Y211.663 E.01858
G1 X190.603 Y211.582 E.00882
G1 X190.919 Y211.399 E.01318
G1 X191.071 Y211.275 E.00709
G1 X191.28 Y211.047 E.01117
G1 X191.416 Y210.841 E.00889
G1 X191.539 Y210.556 E.01123
G1 X191.65 Y209.973 E.02143
G1 X191.65 Y184.451 E.92149
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
G1 X180.29 Y212.206 E.3431
G1 X179.91 Y212.17 E.01378
G1 X179.377 Y212.013 E.02007
G1 X179.019 Y211.83 E.01451
G1 X178.707 Y211.59 E.01422
G1 X178.483 Y211.341 E.01209
G1 X178.293 Y211.045 E.0127
G1 X178.2 Y210.838 E.00817
G1 X178.069 Y210.396 E.01667
G1 X178.018 Y209.896 E.01813
G1 X178.018 Y200.588 E.33607
G1 X177.932 Y200.104 E.01777
G1 X177.81 Y199.796 E.01195
G1 X177.664 Y199.57 E.0097
G1 X177.541 Y199.434 E.00662
G1 X177.348 Y199.278 E.00897
G1 X176.949 Y199.073 E.01619
G1 X176.641 Y198.989 E.01154
G1 X176.386 Y198.957 E.00925
G1 X159.582 Y198.957 E.60673
G1 X159.247 Y198.93 E.01216
G1 X158.528 Y198.709 E.02716
G1 X158.25 Y198.554 E.0115
G1 X158 Y198.357 E.01146
G1 X157.783 Y198.123 E.01156
G1 X157.6 Y197.849 E.01188
G1 X157.458 Y197.546 E.01207
G1 X157.359 Y197.226 E.01213
G1 X157.293 Y196.643 E.02118
G1 X157.293 Y134.883 E2.22991
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
M73 P30 R14
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
G1 X180.625 Y196.35 E.4784
G1 X159.9 Y196.35 E.7483
G1 X159.9 Y131.91 E2.32667
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
G1 X181.082 Y195.893 E.4784
G1 X160.357 Y195.893 E.7483
G1 X160.357 Y132.367 E2.29367
G1 X169.357 Y132.367 E.32495
; WIPE_START
G1 X169.387 Y130.367 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X168.904 Y137.984 Z.6 F60000
M73 P31 R14
G1 X165.45 Y192.515 Z.6
G1 Z.2
G1 E.8 F1800
; FEATURE: Outer wall
G1 F3000
M204 S500
G1 X161.95 Y192.515 E.12637
G1 X161.95 Y186.475 E.21808
G1 X165.45 Y186.475 E.12637
G1 X165.45 Y192.455 E.21591
M204 S6000
G1 X165.907 Y192.515 F60000
; FEATURE: Inner wall
G1 F3000
M204 S500
G1 X165.907 Y192.972 E.0165
G1 X161.493 Y192.972 E.15938
G1 X161.493 Y186.018 E.25109
G1 X165.907 Y186.018 E.15938
G1 X165.907 Y192.455 E.23242
; WIPE_START
G1 X165.907 Y192.972 E-.19649
G1 X164.424 Y192.972 E-.56351
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X165.343 Y185.395 Z.6 F60000
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
G1 X163.234 Y177.433 Z.6 F60000
G1 X161.674 Y167.55 Z.6
G1 Z.2
G1 E.8 F1800
; FEATURE: Outer wall
G1 F3000
M204 S500
G1 X161.674 Y160.25 E.26357
G1 X169.715 Y160.25 E.29033
G1 X169.715 Y167.55 E.26357
G1 X161.734 Y167.55 E.28816
M204 S6000
G1 X161.674 Y168.007 F60000
; FEATURE: Inner wall
G1 F3000
M204 S500
G1 X161.217 Y168.007 E.0165
G1 X161.217 Y159.793 E.29658
G1 X170.172 Y159.793 E.32333
G1 X170.172 Y168.007 E.29658
G1 X161.734 Y168.007 E.30466
; WIPE_START
G1 X161.217 Y168.007 E-.19649
G1 X161.217 Y166.524 E-.56351
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X165.659 Y160.317 Z.6 F60000
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
G1 X181.539 Y195.436 E.4784
G1 X160.814 Y195.436 E.7483
G1 X160.814 Y193.429 E.07245
G1 X166.364 Y193.429 E.20039
G1 X166.364 Y177.561 E.57294
G1 X160.814 Y177.561 E.20039
G1 X160.814 Y168.464 E.32845
G1 X170.629 Y168.464 E.35438
G1 X170.629 Y159.336 E.32959
G1 X160.814 Y159.336 E.35438
G1 X160.814 Y153.204 E.22139
G1 X166.126 Y153.204 E.19179
G1 X166.126 Y155.529 E.08395
M73 P32 R14
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
G1 E-.04 F1800
M204 S6000
G1 X185.832 Y136.867 Z.6 F60000
G1 X184.709 Y203.927 Z.6
G1 Z.2
G1 E.8 F1800
; FEATURE: Outer wall
G1 F3000
M204 S500
G1 X184.595 Y203.88 E.00446
G3 X185.137 Y200.958 I.704 J-1.38 E.14352
G1 X185.292 Y200.95 E.00562
G3 X184.849 Y203.982 I.007 J1.55 E.19249
G1 X184.765 Y203.949 E.00327
M204 S6000
G1 X184.538 Y204.349 F60000
; FEATURE: Inner wall
G1 F3000
M204 S500
G1 X184.385 Y204.286 E.00598
G3 X185.089 Y200.503 I.913 J-1.787 E.18584
G1 X185.289 Y200.492 E.00726
G3 X184.718 Y204.42 I.009 J2.007 E.24925
G1 X184.594 Y204.371 E.00478
M204 S6000
G1 X184.368 Y204.772 F60000
G1 F3000
M204 S500
G1 X184.176 Y204.693 E.00749
G3 X185.04 Y200.048 I1.122 J-2.194 E.22817
G1 X185.286 Y200.034 E.0089
G3 X184.586 Y204.858 I.011 J2.464 E.30601
G1 X184.424 Y204.794 E.0063
; WIPE_START
G1 X184.176 Y204.693 E-.1016
G1 X183.957 Y204.568 E-.09569
G1 X183.748 Y204.416 E-.09815
G1 X183.407 Y204.08 E-.18207
G1 X183.256 Y203.879 E-.09561
G1 X183.123 Y203.659 E-.0977
G1 X183.034 Y203.442 E-.08918
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X183.577 Y195.829 Z.6 F60000
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
G1 X181.304 Y182.866 E1.3259
G1 X188.129 Y182.866 E.24642
G1 X188.129 Y201.148 E.66009
G1 X187.928 Y201.204 E.00752
G2 X187.928 Y203.795 I-2.622 J1.295 E.56662
G1 X188.129 Y203.851 E.00753
G1 X188.129 Y208.229 E.15807
G1 X181.996 Y208.229 E.22142
G1 X181.996 Y194.979 E.4784
G1 X161.271 Y194.979 E.7483
G1 X161.271 Y193.886 E.03945
G1 X166.821 Y193.886 E.20039
G1 X166.821 Y177.104 E.60595
G1 X161.271 Y177.104 E.20039
G1 X161.271 Y168.921 E.29544
G1 X171.086 Y168.921 E.35438
G1 X171.086 Y158.879 E.36259
G1 X161.271 Y158.879 E.35438
G1 X161.271 Y153.661 E.18839
G1 X165.669 Y153.661 E.15878
G1 X165.669 Y155.986 E.08395
G1 X176.731 Y155.986 E.39942
G1 X176.731 Y150.004 E.216
G1 X166.821 Y150.004 E.35781
G1 X166.821 Y143.161 E.24706
G1 X167.721 Y143.161 E.0325
G1 X167.721 Y133.281 E.35673
G1 X170.331 Y133.281 E.09424
G1 X170.331 Y129.271 E.14479
G1 X175.529 Y129.271 E.18766
G1 X175.529 Y135.271 E.21664
M73 P33 R14
G1 X187.84 Y135.271 E.44451
; WIPE_START
G1 X188.129 Y135.271 E-.10974
G1 X188.129 Y136.779 E-.57288
G1 X187.925 Y136.779 E-.07737
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X187.9 Y130.15 Z.6 F60000
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
G1 X188.032 Y138.801 Z.6 F60000
G1 X187.9 Y141.9 Z.6
G1 Z.2
G1 E.8 F1800
; FEATURE: Outer wall
G1 F3000
M204 S500
G1 X176.9 Y141.9 E.39717
G1 X176.9 Y138.15 E.1354
G1 X187.9 Y138.15 E.39717
G1 X187.9 Y141.84 E.13323
M204 S6000
G1 X188.357 Y141.9 F60000
; FEATURE: Inner wall
G1 F3000
M204 S500
G1 X188.357 Y142.357 E.0165
G1 X176.443 Y142.357 E.43017
G1 X176.443 Y137.693 E.1684
G1 X188.357 Y137.693 E.43017
G1 X188.357 Y141.84 E.14973
; WIPE_START
G1 X188.357 Y142.357 E-.19648
G1 X186.874 Y142.357 E-.56352
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X188.715 Y147.515 Z.6 F60000
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
M73 P33 R13
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
M73 P34 R13
G1 X165.907 Y143.253 E.0165
G1 X165.907 Y152.747 E.3428
G1 X161.493 Y152.747 E.15938
G1 X161.493 Y143.253 E.3428
G1 X165.39 Y143.253 E.14071
; WIPE_START
G1 X165.907 Y143.253 E-.19649
G1 X165.907 Y144.736 E-.56351
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X172.153 Y149.123 Z.6 F60000
G1 X175.36 Y151.375 Z.6
G1 Z.2
G1 E.8 F1800
; FEATURE: Outer wall
G1 F3000
M204 S500
G1 X175.36 Y154.615 E.11698
G1 X167.04 Y154.615 E.3004
G1 X167.04 Y151.375 E.11698
G1 X175.3 Y151.375 E.29824
M204 S6000
G1 X175.36 Y150.918 F60000
; FEATURE: Inner wall
G1 F3000
M204 S500
G1 X175.817 Y150.918 E.0165
G1 X175.817 Y155.072 E.14999
G1 X166.583 Y155.072 E.33341
G1 X166.583 Y150.918 E.14999
G1 X175.3 Y150.918 E.31474
; WIPE_START
G1 X175.817 Y150.918 E-.19649
G1 X175.817 Y152.401 E-.56351
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X168.304 Y151.058 Z.6 F60000
G1 X166.245 Y150.689 Z.6
G1 Z.2
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.26172
G1 F3000
M204 S500
G1 X166.245 Y152.975 E.03951
; WIPE_START
G1 X166.245 Y150.975 E-.76
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
G1 X162.645 Y150.235 Z.6 F60000
G1 X160.787 Y159.565 Z.6
G1 Z.2
G1 E.8 F1800
; LINE_WIDTH: 0.44572
G1 F3000
M204 S500
G1 X160.787 Y168.236 E.2759
; WIPE_START
G1 X160.787 Y166.236 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X160.878 Y173.867 Z.6 F60000
G1 X160.925 Y177.79 Z.6
G1 Z.2
G1 E.8 F1800
; LINE_WIDTH: 0.722005
G1 F3000
M204 S500
G1 X160.925 Y185.201 E.39755
G1 X160.946 Y185.299 E.00539
; LINE_WIDTH: 0.78556
G1 X160.968 Y185.397 E.00589
; LINE_WIDTH: 0.82812
G1 X160.989 Y185.495 E.00623
; LINE_WIDTH: 0.828113
G1 X160.968 Y185.593 E.00623
; LINE_WIDTH: 0.785556
G1 X160.946 Y185.691 E.00589
; LINE_WIDTH: 0.722005
G1 X160.925 Y185.789 E.00539
G1 X160.925 Y193.201 E.39755
; WIPE_START
G1 X160.925 Y191.201 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X161.5 Y194.433 Z.6 F60000
G1 Z.2
G1 E.8 F1800
; LINE_WIDTH: 0.67843
G1 F3000
M204 S500
G1 X167.05 Y194.433 E.27861
; WIPE_START
G1 X165.05 Y194.433 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X165.97 Y186.856 Z.6 F60000
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
; WIPE_START
G1 X161.044 Y185.495 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X167.22 Y189.98 Z.6 F60000
G1 X182.449 Y201.039 Z.6
G1 Z.2
G1 E.8 F1800
; LINE_WIDTH: 0.124587
G1 F3000
M204 S500
G1 X182.588 Y200.847 E.00153
M204 S6000
G1 X182.449 Y201.039 F60000
; LINE_WIDTH: 0.165307
G1 F3000
M204 S500
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
G3 X185.644 Y205.792 I-.817 J-2.681 E.02195
G1 X187.692 Y207.84 E.10971
G1 X187.014 Y207.84 E.02569
G1 X184.969 Y205.795 E.10956
G3 X184.07 Y205.574 I.428 J-3.678 E.03518
G1 X186.336 Y207.84 E.12141
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
G1 X188.106 Y194.153 Z.6 F60000
G1 X187.946 Y144.205 Z.6
G1 Z.2
G1 E.8 F1800
; FEATURE: Bottom surface
; LINE_WIDTH: 0.50367
G1 F6300
M204 S500
G1 X187.401 Y143.66 E.02806
G1 X186.749 Y143.66 E.02372
G1 X187.74 Y144.651 E.05102
G1 X187.74 Y145.302 E.02372
G1 X186.098 Y143.66 E.08456
G1 X185.446 Y143.66 E.02372
G1 X187.542 Y145.755 E.10787
G1 X186.89 Y145.755 E.02372
G1 X184.794 Y143.66 E.10787
G1 X184.143 Y143.66 E.02372
G1 X186.239 Y145.755 E.10787
G1 X185.587 Y145.755 E.02372
G1 X183.491 Y143.66 E.10787
G1 X182.84 Y143.66 E.02372
G1 X184.935 Y145.755 E.10787
G1 X184.284 Y145.755 E.02372
G1 X182.188 Y143.66 E.10787
G1 X181.536 Y143.66 E.02372
G1 X183.632 Y145.755 E.10787
G1 X182.981 Y145.755 E.02372
G1 X180.885 Y143.66 E.10787
G1 X180.233 Y143.66 E.02372
G1 X182.329 Y145.755 E.10787
G1 X181.677 Y145.755 E.02372
G1 X179.582 Y143.66 E.10787
G1 X178.93 Y143.66 E.02372
G1 X181.026 Y145.755 E.10787
G1 X180.915 Y145.755 E.00402
G1 X180.915 Y146.297 E.0197
G1 X178.278 Y143.66 E.13573
G1 X177.627 Y143.66 E.02372
G1 X180.915 Y146.948 E.16927
G1 X180.915 Y147.6 E.02372
G1 X176.975 Y143.66 E.20281
G1 X176.324 Y143.66 E.02372
G1 X181.121 Y148.457 E.24693
; WIPE_START
G1 X179.707 Y147.043 E-.76
; WIPE_END
M73 P35 R13
G1 E-.04 F1800
M204 S6000
G1 X184.375 Y141.005 Z.6 F60000
G1 X187.946 Y136.386 Z.6
G1 Z.2
G1 E.8 F1800
G1 F6300
M204 S500
G1 X187.22 Y135.66 E.03737
G1 X186.568 Y135.66 E.02372
G1 X187.299 Y136.39 E.03761
G1 X186.648 Y136.39 E.02372
G1 X185.917 Y135.66 E.03761
G1 X185.265 Y135.66 E.02372
G1 X185.996 Y136.39 E.03761
G1 X185.344 Y136.39 E.02372
G1 X184.614 Y135.66 E.03761
G1 X183.962 Y135.66 E.02372
G1 X184.693 Y136.39 E.03761
G1 X184.041 Y136.39 E.02372
G1 X183.31 Y135.66 E.03761
G1 X182.659 Y135.66 E.02372
G1 X183.39 Y136.39 E.03761
G1 X182.738 Y136.39 E.02372
G1 X182.007 Y135.66 E.03761
G1 X181.356 Y135.66 E.02372
G1 X182.086 Y136.39 E.03761
G1 X181.435 Y136.39 E.02372
G1 X180.704 Y135.66 E.03761
G1 X180.052 Y135.66 E.02372
G1 X180.783 Y136.39 E.03761
G1 X180.132 Y136.39 E.02372
G1 X179.401 Y135.66 E.03761
G1 X178.749 Y135.66 E.02372
G1 X179.48 Y136.39 E.03761
G1 X178.828 Y136.39 E.02372
G1 X178.098 Y135.66 E.03761
G1 X177.446 Y135.66 E.02372
G1 X178.177 Y136.39 E.03761
G1 X177.525 Y136.39 E.02372
G1 X176.794 Y135.66 E.03761
G1 X176.143 Y135.66 E.02372
G1 X177.079 Y136.596 E.0482
; WIPE_START
G1 X176.143 Y135.66 E-.50325
G1 X176.794 Y135.66 E-.24761
G1 X176.811 Y135.677 E-.00914
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X175.346 Y130.302 Z.6 F60000
G1 Z.2
G1 E.8 F1800
G1 F6300
M204 S500
G1 X174.704 Y129.66 E.03305
G1 X174.052 Y129.66 E.02372
G1 X175.14 Y130.748 E.056
G1 X175.14 Y131.399 E.02372
G1 X173.401 Y129.66 E.08954
G1 X172.749 Y129.66 E.02372
G1 X175.14 Y132.051 E.12308
G1 X175.14 Y132.702 E.02372
G1 X172.098 Y129.66 E.15662
G1 X171.446 Y129.66 E.02372
G1 X175.14 Y133.354 E.19016
G1 X175.14 Y134.006 E.02372
G1 X170.794 Y129.66 E.22369
G1 X170.72 Y129.66 E.00272
G1 X170.72 Y130.236 E.02099
G1 X175.346 Y134.863 E.23813
; WIPE_START
G1 X173.932 Y133.449 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X176.428 Y136.596 Z.6 F60000
G1 Z.2
G1 E.8 F1800
G1 F6300
M204 S500
G1 X170.72 Y130.888 E.2938
G1 X170.72 Y131.54 E.02372
G1 X175.57 Y136.39 E.24968
G1 X175.14 Y136.39 E.01565
G1 X175.14 Y136.612 E.00807
G1 X170.72 Y132.191 E.22754
G1 X170.72 Y132.843 E.02372
G1 X175.14 Y137.264 E.22755
G1 X175.14 Y137.915 E.02372
G1 X170.72 Y133.494 E.22755
G1 X170.72 Y133.67 E.00638
G1 X170.243 Y133.67 E.01734
G1 X175.14 Y138.567 E.25207
G1 X175.14 Y139.218 E.02372
G1 X169.592 Y133.67 E.2856
G1 X168.94 Y133.67 E.02372
G1 X175.14 Y139.87 E.31914
G1 X175.14 Y140.522 E.02372
G1 X168.288 Y133.67 E.35268
G1 X168.11 Y133.67 E.00651
G1 X168.11 Y134.142 E.01721
G1 X175.14 Y141.173 E.36189
G1 X175.14 Y141.825 E.02372
G1 X168.11 Y134.794 E.36189
G1 X168.11 Y135.446 E.02372
G1 X175.346 Y142.682 E.37247
; WIPE_START
G1 X173.932 Y141.268 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X168.236 Y136.188 Z.6 F60000
G1 X167.904 Y135.892 Z.6
G1 Z.2
G1 E.8 F1800
G1 F6300
M204 S500
G1 X175.14 Y143.128 E.37247
G1 X175.14 Y143.66 E.01935
G1 X175.672 Y143.66 E.01935
G1 X180.915 Y148.903 E.26988
G1 X180.915 Y149.555 E.02372
G1 X168.11 Y136.749 E.65913
G1 X168.11 Y137.4 E.02372
G1 X180.915 Y150.206 E.65913
G1 X180.915 Y150.858 E.02372
G1 X168.11 Y138.052 E.65913
G1 X168.11 Y138.704 E.02372
G1 X180.915 Y151.509 E.65913
G1 X180.915 Y152.161 E.02372
G1 X168.11 Y139.355 E.65913
G1 X168.11 Y140.007 E.02372
G1 X180.915 Y152.813 E.65913
G1 X180.915 Y153.464 E.02372
G1 X168.11 Y140.658 E.65913
G1 X168.11 Y141.31 E.02372
G1 X176.415 Y149.615 E.42749
G1 X175.763 Y149.615 E.02372
G1 X168.11 Y141.962 E.39395
G1 X168.11 Y142.613 E.02372
G1 X175.112 Y149.615 E.36041
G1 X174.46 Y149.615 E.02372
G1 X168.11 Y143.265 E.32688
G1 X168.11 Y143.55 E.01037
G1 X167.743 Y143.55 E.01335
G1 X173.809 Y149.615 E.31222
G1 X173.157 Y149.615 E.02372
G1 X167.21 Y143.668 E.30612
G1 X167.21 Y144.32 E.02372
M73 P36 R13
G1 X172.505 Y149.615 E.27258
G1 X171.854 Y149.615 E.02372
G1 X167.21 Y144.971 E.23904
G1 X167.21 Y145.623 E.02372
G1 X171.202 Y149.615 E.2055
G1 X170.551 Y149.615 E.02372
G1 X167.21 Y146.274 E.17197
G1 X167.21 Y146.926 E.02372
G1 X169.899 Y149.615 E.13843
G1 X169.247 Y149.615 E.02372
G1 X167.21 Y147.578 E.10489
G1 X167.21 Y148.229 E.02372
G1 X168.596 Y149.615 E.07135
G1 X167.944 Y149.615 E.02372
G1 X167.21 Y148.881 E.03781
G1 X167.21 Y149.532 E.02372
G1 X167.498 Y149.821 E.01486
; WIPE_START
G1 X167.21 Y149.532 E-.15514
G1 X167.21 Y148.881 E-.24761
G1 X167.874 Y149.546 E-.35725
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X165.005 Y153.844 Z.6 F60000
G1 Z.2
G1 E.8 F1800
G1 F6300
M204 S500
G1 X165.28 Y154.119 E.01416
G1 X165.28 Y154.771 E.02372
G1 X164.559 Y154.05 E.03712
G1 X163.908 Y154.05 E.02372
G1 X165.486 Y155.628 E.08124
; WIPE_START
G1 X164.072 Y154.214 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X171.343 Y151.893 Z.6 F60000
G1 X176.914 Y150.114 Z.6
G1 Z.2
G1 E.8 F1800
G1 F6300
M204 S500
G1 X180.915 Y154.116 E.20596
G1 X180.915 Y154.767 E.02372
G1 X177.12 Y150.972 E.19537
G1 X177.12 Y151.623 E.02372
G1 X180.915 Y155.419 E.19537
G1 X180.915 Y156.071 E.02372
G1 X177.12 Y152.275 E.19537
G1 X177.12 Y152.926 E.02372
G1 X180.915 Y156.722 E.19537
G1 X180.915 Y157.374 E.02372
G1 X177.12 Y153.578 E.19537
G1 X177.12 Y154.23 E.02372
G1 X180.915 Y158.025 E.19537
G1 X180.915 Y158.677 E.02372
G1 X177.12 Y154.881 E.19537
G1 X177.12 Y155.533 E.02372
G1 X180.915 Y159.329 E.19537
G1 X180.915 Y159.98 E.02372
G1 X177.12 Y156.184 E.19537
G1 X177.12 Y156.375 E.00692
G1 X176.658 Y156.375 E.01679
G1 X180.915 Y160.632 E.21912
G1 X180.915 Y161.283 E.02372
G1 X176.007 Y156.375 E.25266
G1 X175.355 Y156.375 E.02372
G1 X180.915 Y161.935 E.2862
G1 X180.915 Y162.587 E.02372
G1 X174.703 Y156.375 E.31974
G1 X174.052 Y156.375 E.02372
G1 X180.915 Y163.238 E.35328
G1 X180.915 Y163.89 E.02372
G1 X173.4 Y156.375 E.38682
G1 X172.749 Y156.375 E.02372
G1 X180.915 Y164.541 E.42036
G1 X180.915 Y165.193 E.02372
G1 X172.097 Y156.375 E.45389
G1 X171.445 Y156.375 E.02372
G1 X180.915 Y165.845 E.48743
G1 X180.915 Y166.496 E.02372
G1 X170.794 Y156.375 E.52097
G1 X170.142 Y156.375 E.02372
G1 X180.915 Y167.148 E.55451
G1 X180.915 Y167.799 E.02372
G1 X169.491 Y156.375 E.58805
G1 X168.839 Y156.375 E.02372
G1 X170.955 Y158.49 E.1089
G1 X171.475 Y158.49 E.01892
G1 X171.475 Y159.01 E.01892
G1 X181.121 Y168.657 E.49652
; WIPE_START
G1 X179.707 Y167.242 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X174.115 Y162.047 Z.6 F60000
G1 X170.509 Y158.696 Z.6
G1 Z.2
G1 E.8 F1800
G1 F6300
M204 S500
G1 X168.187 Y156.375 E.11949
G1 X167.536 Y156.375 E.02372
G1 X169.652 Y158.49 E.1089
G1 X169 Y158.49 E.02372
G1 X166.884 Y156.375 E.1089
G1 X166.233 Y156.375 E.02372
G1 X168.348 Y158.49 E.1089
G1 X167.697 Y158.49 E.02372
G1 X163.256 Y154.05 E.22857
G1 X162.604 Y154.05 E.02372
G1 X167.045 Y158.49 E.22857
G1 X166.394 Y158.49 E.02372
G1 X161.953 Y154.05 E.22857
G1 X161.66 Y154.05 E.01067
G1 X161.66 Y154.408 E.01304
G1 X165.742 Y158.49 E.21013
G1 X165.09 Y158.49 E.02372
G1 X161.66 Y155.06 E.17659
G1 X161.66 Y155.711 E.02372
G1 X164.439 Y158.49 E.14305
G1 X163.787 Y158.49 E.02372
G1 X161.66 Y156.363 E.10951
G1 X161.66 Y157.014 E.02372
G1 X163.136 Y158.49 E.07597
G1 X162.484 Y158.49 E.02372
G1 X161.66 Y157.666 E.04243
G1 X161.66 Y158.318 E.02372
G1 X162.038 Y158.696 E.01948
; WIPE_START
G1 X161.66 Y158.318 E-.20342
G1 X161.66 Y157.666 E-.24761
G1 X162.235 Y158.241 E-.30898
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X169.799 Y159.258 Z.6 F60000
G1 X171.269 Y159.456 Z.6
G1 Z.2
G1 E.8 F1800
G1 F6300
M204 S500
G1 X180.915 Y169.103 E.49652
G1 X180.915 Y169.754 E.02372
G1 X171.475 Y160.313 E.48593
G1 X171.475 Y160.965 E.02372
G1 X180.915 Y170.406 E.48593
M73 P37 R13
G1 X180.915 Y171.057 E.02372
G1 X171.475 Y161.617 E.48593
G1 X171.475 Y162.268 E.02372
G1 X180.915 Y171.709 E.48593
G1 X180.915 Y172.361 E.02372
G1 X171.475 Y162.92 E.48593
G1 X171.475 Y163.571 E.02372
G1 X180.915 Y173.012 E.48593
G1 X180.915 Y173.664 E.02372
G1 X171.475 Y164.223 E.48593
G1 X171.475 Y164.875 E.02372
G1 X180.915 Y174.315 E.48593
G1 X180.915 Y174.967 E.02372
G1 X171.475 Y165.526 E.48593
G1 X171.475 Y166.178 E.02372
G1 X180.915 Y175.619 E.48593
G1 X180.915 Y176.27 E.02372
G1 X171.475 Y166.829 E.48593
G1 X171.475 Y167.481 E.02372
G1 X180.915 Y176.922 E.48593
G1 X180.915 Y177.573 E.02372
G1 X171.475 Y168.133 E.48593
G1 X171.475 Y168.784 E.02372
G1 X180.915 Y178.225 E.48593
G1 X180.915 Y178.877 E.02372
G1 X171.348 Y169.31 E.49242
G1 X170.697 Y169.31 E.02372
G1 X180.915 Y179.528 E.52596
G1 X180.915 Y180.18 E.02372
G1 X170.045 Y169.31 E.5595
G1 X169.394 Y169.31 E.02372
G1 X180.915 Y180.831 E.59304
G1 X180.915 Y181.483 E.02372
G1 X168.742 Y169.31 E.62658
G1 X168.09 Y169.31 E.02372
G1 X181.121 Y182.34 E.6707
; WIPE_START
G1 X179.707 Y180.926 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X187.038 Y183.048 Z.6 F60000
G1 X187.043 Y183.049 Z.6
G1 Z.2
G1 E.8 F1800
G1 F6300
M204 S500
G1 X187.74 Y183.747 E.03592
G1 X187.74 Y184.398 E.02372
G1 X186.597 Y183.255 E.05887
G1 X185.945 Y183.255 E.02372
G1 X187.74 Y185.05 E.09241
G1 X187.74 Y185.702 E.02372
G1 X185.293 Y183.255 E.12595
G1 X184.642 Y183.255 E.02372
G1 X187.74 Y186.353 E.15948
G1 X187.74 Y187.005 E.02372
G1 X183.99 Y183.255 E.19302
G1 X183.339 Y183.255 E.02372
G1 X187.74 Y187.656 E.22656
G1 X187.74 Y188.308 E.02372
G1 X182.687 Y183.255 E.2601
G1 X182.035 Y183.255 E.02372
G1 X187.74 Y188.96 E.29364
G1 X187.74 Y189.611 E.02372
G1 X181.384 Y183.255 E.32718
G1 X180.915 Y183.255 E.01705
G1 X180.915 Y182.786 E.01705
G1 X167.439 Y169.31 E.69366
G1 X166.787 Y169.31 E.02372
G1 X187.74 Y190.263 E1.07849
G1 X187.74 Y190.914 E.02372
G1 X166.136 Y169.31 E1.11203
G1 X165.484 Y169.31 E.02372
G1 X187.74 Y191.566 E1.14557
G1 X187.74 Y192.218 E.02372
G1 X164.832 Y169.31 E1.17911
G1 X164.181 Y169.31 E.02372
G1 X187.74 Y192.869 E1.21264
G1 X187.74 Y193.521 E.02372
G1 X163.529 Y169.31 E1.24618
G1 X162.878 Y169.31 E.02372
G1 X187.74 Y194.172 E1.27972
G1 X187.74 Y194.824 E.02372
M73 P38 R13
G1 X162.226 Y169.31 E1.31326
G1 X161.66 Y169.31 E.02062
G1 X161.66 Y169.395 E.0031
G1 X187.74 Y195.476 E1.34242
G1 X187.74 Y196.127 E.02372
G1 X161.66 Y170.046 E1.34242
G1 X161.66 Y170.698 E.02372
G1 X187.74 Y196.779 E1.34242
G1 X187.74 Y197.43 E.02372
G1 X161.66 Y171.35 E1.34242
G1 X161.66 Y172.001 E.02372
M73 P38 R12
G1 X166.374 Y176.715 E.24265
G1 X165.722 Y176.715 E.02372
G1 X161.66 Y172.653 E.20911
G1 X161.66 Y173.304 E.02372
G1 X165.071 Y176.715 E.17557
G1 X164.419 Y176.715 E.02372
G1 X161.66 Y173.956 E.14203
G1 X161.66 Y174.608 E.02372
G1 X163.767 Y176.715 E.1085
G1 X163.116 Y176.715 E.02372
G1 X161.66 Y175.259 E.07496
G1 X161.66 Y175.911 E.02372
G1 X162.464 Y176.715 E.04142
G1 X161.813 Y176.715 E.02372
G1 X161.454 Y176.357 E.01846
; WIPE_START
G1 X161.813 Y176.715 E-.19279
G1 X162.464 Y176.715 E-.24761
G1 X161.87 Y176.121 E-.31961
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X167.004 Y177.345 Z.6 F60000
G1 Z.2
G1 E.8 F1800
G1 F6300
M204 S500
G1 X187.74 Y198.082 E1.06734
G1 X187.74 Y198.733 E.02372
G1 X167.21 Y178.203 E1.05675
G1 X167.21 Y178.854 E.02372
G1 X187.74 Y199.385 E1.05675
G1 X187.74 Y200.037 E.02372
G1 X167.21 Y179.506 E1.05675
G1 X167.21 Y180.158 E.02372
G1 X181.642 Y194.59 E.74288
G1 X180.991 Y194.59 E.02372
G1 X167.21 Y180.809 E.70934
G1 X167.21 Y181.461 E.02372
G1 X180.339 Y194.59 E.67581
G1 X179.688 Y194.59 E.02372
G1 X167.21 Y182.112 E.64227
G1 X167.21 Y182.764 E.02372
G1 X179.036 Y194.59 E.60873
G1 X178.384 Y194.59 E.02372
G1 X167.21 Y183.416 E.57519
G1 X167.21 Y184.067 E.02372
G1 X177.733 Y194.59 E.54165
G1 X177.081 Y194.59 E.02372
G1 X167.21 Y184.719 E.50811
G1 X167.21 Y185.37 E.02372
G1 X176.43 Y194.59 E.47457
G1 X175.778 Y194.59 E.02372
G1 X167.21 Y186.022 E.44103
G1 X167.21 Y186.674 E.02372
G1 X175.126 Y194.59 E.40749
G1 X174.475 Y194.59 E.02372
G1 X167.21 Y187.325 E.37396
G1 X167.21 Y187.977 E.02372
G1 X173.823 Y194.59 E.34042
G1 X173.172 Y194.59 E.02372
G1 X167.21 Y188.628 E.30688
G1 X167.21 Y189.28 E.02372
G1 X172.52 Y194.59 E.27334
G1 X171.868 Y194.59 E.02372
G1 X167.21 Y189.932 E.2398
G1 X167.21 Y190.583 E.02372
G1 X171.217 Y194.59 E.20626
G1 X170.565 Y194.59 E.02372
G1 X167.21 Y191.235 E.17272
G1 X167.21 Y191.886 E.02372
M73 P39 R12
G1 X169.914 Y194.59 E.13918
G1 X169.262 Y194.59 E.02372
G1 X167.21 Y192.538 E.10564
G1 X167.21 Y193.19 E.02372
G1 X168.61 Y194.59 E.07211
G1 X167.959 Y194.59 E.02372
G1 X167.004 Y193.635 E.04915
; WIPE_START
G1 X167.959 Y194.59 E-.5132
G1 X168.608 Y194.59 E-.2468
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X176.235 Y194.892 Z.6 F60000
G1 X182.179 Y195.127 Z.6
G1 Z.2
G1 E.8 F1800
G1 F6300
M204 S500
G1 X186.449 Y199.397 E.2198
G2 X185.602 Y199.202 I-1.22 J3.358 E.0317
G1 X182.385 Y195.984 E.16563
G1 X182.385 Y196.636 E.02372
G1 X184.955 Y199.206 E.13229
G2 X184.41 Y199.313 I.672 J4.86 E.02021
G1 X182.385 Y197.287 E.10425
G1 X182.385 Y197.939 E.02372
G1 X183.932 Y199.487 E.07967
G2 X183.51 Y199.716 I.978 J2.303 E.01751
G1 X182.385 Y198.591 E.05794
G1 X182.385 Y199.242 E.02372
G1 X183.138 Y199.995 E.03876
G2 X182.811 Y200.32 I1.418 J1.75 E.0168
G1 X182.179 Y199.688 E.03254
; WIPE_START
G1 X182.811 Y200.32 E-.33976
G1 X183.138 Y199.995 E-.17509
G1 X182.682 Y199.539 E-.24515
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X183.484 Y191.949 Z.6 F60000
G1 X188.7 Y142.585 Z.6
G1 Z.2
G1 E.8 F1800
; FEATURE: Gap infill
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
G1 X181.87 Y128.058 Z.6 F60000
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
G1 X161.474 Y115.208 Z.6 F60000
G1 Z.2
G1 E.8 F1800
G1 F3000
M204 S500
G1 X161.271 Y115.154 E.0076
G1 X161.271 Y111.771 E.12213
G1 X166.529 Y111.771 E.18983
G1 X166.529 Y114.834 E.11058
G2 X164.913 Y113.692 I-2.627 J2.003 E.07256
G2 X161.502 Y115.155 I-.808 J2.824 E.14505
; WIPE_START
G1 X161.271 Y115.154 E-.08759
G1 X161.271 Y113.384 E-.67241
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X162.609 Y116.912 Z.6 F60000
G1 Z.2
G1 E.8 F1800
; FEATURE: Outer wall
G1 F3000
M204 S500
G1 X162.556 Y116.643 E.0099
G3 X163.937 Y114.958 I1.543 J-.143 E.08721
G1 X164.092 Y114.95 E.00562
G3 X162.623 Y116.97 I.007 J1.55 E.24664
M204 S6000
G1 X162.162 Y116.999 F60000
; FEATURE: Inner wall
G1 F3000
M204 S500
G1 X162.1 Y116.685 E.01155
G3 X163.889 Y114.503 I1.998 J-.186 E.11298
G1 X164.089 Y114.492 E.00726
G3 X162.179 Y117.085 I.009 J2.007 E.32033
G1 X162.174 Y117.058 E.00099
M204 S6000
G1 X161.721 Y117.139 F60000
G1 F3000
M204 S500
G1 X161.679 Y116.971 E.00624
G3 X163.84 Y114.048 I2.419 J-.473 E.14762
G1 X164.086 Y114.034 E.0089
G3 X161.74 Y117.217 I.011 J2.464 E.39337
G1 X161.736 Y117.197 E.00075
M204 S6000
G1 X161.472 Y117.795 F60000
G1 F3000
M204 S500
G1 X161.674 Y118.13 E.01412
G2 X166.172 Y118.562 I2.427 J-1.632 E.18649
G1 X166.529 Y118.166 E.01923
G1 X166.529 Y120.919 E.09939
G1 X161.271 Y120.919 E.18983
G1 X161.271 Y117.851 E.11077
G1 X161.414 Y117.811 E.00536
M204 S6000
G1 X161.601 Y117.522 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.519612
G1 F3000
M204 S500
G1 X161.288 Y117.355 E.01337
G1 X161.269 Y117.204 E.00573
; LINE_WIDTH: 0.478423
G1 X161.252 Y117.066 E.0048
; LINE_WIDTH: 0.439876
G3 X161.231 Y116.776 I5.651 J-.556 E.0091
; LINE_WIDTH: 0.412426
G3 X161.231 Y116.215 I8.1 J-.275 E.01637
; LINE_WIDTH: 0.438543
G3 X161.25 Y115.956 I5.416 J.263 E.00813
; LINE_WIDTH: 0.473492
G1 X161.266 Y115.817 E.00477
; LINE_WIDTH: 0.50422
G1 X161.28 Y115.696 E.00444
; LINE_WIDTH: 0.528529
G3 X161.328 Y115.406 I6.07 J.855 E.01127
M204 S6000
G1 X161.5 Y114.604 F60000
; LINE_WIDTH: 0.14633
G1 F3000
M204 S500
G1 X161.612 Y114.49 E.00131
; LINE_WIDTH: 0.118611
G1 X161.755 Y114.359 E.00116
; WIPE_START
G1 X161.612 Y114.49 E-.76
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
G1 X166.44 Y115.117 Z.6 F60000
G1 Z.2
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.116747
G1 F3000
M204 S500
G1 X166.535 Y115.248 E.00095
; LINE_WIDTH: 0.150036
G1 X166.606 Y115.356 E.00109
; LINE_WIDTH: 0.188741
G1 X166.675 Y115.461 E.00144
; LINE_WIDTH: 0.183853
G1 X166.699 Y115.6 E.00157
; LINE_WIDTH: 0.138356
G1 X166.721 Y115.731 E.001
; LINE_WIDTH: 0.109404
G1 X166.731 Y115.816 E.00045
; WIPE_START
G1 X166.721 Y115.731 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X166.731 Y117.185 Z.6 F60000
G1 Z.2
G1 E.8 F1800
; LINE_WIDTH: 0.10814
G1 F3000
M204 S500
G1 X166.722 Y117.26 E.00039
; LINE_WIDTH: 0.136287
G1 X166.699 Y117.395 E.001
; LINE_WIDTH: 0.182913
G1 X166.675 Y117.539 E.00162
; LINE_WIDTH: 0.188679
G1 X166.607 Y117.643 E.00144
; LINE_WIDTH: 0.150058
G1 X166.536 Y117.751 E.00109
; LINE_WIDTH: 0.116766
G1 X166.44 Y117.882 E.00095
; WIPE_START
G1 X166.536 Y117.751 E-.76
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
M73 P40 R12
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
G1 X180.86 Y150.312 Z.8 F60000
G1 X175.17 Y150.766 Z.8
G1 Z.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X175.969 Y150.766 E.0257
G1 X175.969 Y155.224 E.14336
G1 X166.431 Y155.224 E.30672
G1 X166.431 Y150.766 E.14336
G1 X175.11 Y150.766 E.27909
M204 S10000
G1 X175.17 Y151.173 F60000
G1 F8843.478
M204 S8000
G1 X175.562 Y151.173 E.01261
G1 X175.562 Y154.817 E.11718
G1 X166.838 Y154.817 E.28054
G1 X166.838 Y151.173 E.11718
G1 X175.11 Y151.173 E.266
M204 S250
G1 X175.17 Y151.565 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X175.17 Y154.425 E.08519
G1 X167.23 Y154.425 E.23651
G1 X167.23 Y151.565 E.08519
G1 X175.11 Y151.565 E.23472
; WIPE_START
M204 S8000
G1 X175.152 Y153.565 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X169.922 Y148.006 Z.8 F60000
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
G1 X168.544 Y141.868 Z.8 F60000
G1 X187.71 Y142.509 Z.8
G1 Z.4
G1 E.8 F1800
G1 F8843.478
M204 S8000
G1 X176.291 Y142.509 E.3672
G1 X176.291 Y137.541 E.15976
G1 X188.509 Y137.541 E.3929
G1 X188.509 Y142.509 E.15976
G1 X187.77 Y142.509 E.02377
M204 S10000
G1 X187.71 Y142.102 F60000
G1 F8843.478
M204 S8000
G1 X176.698 Y142.102 E.35411
G1 X176.698 Y137.948 E.13358
G1 X188.102 Y137.948 E.36672
G1 X188.102 Y142.102 E.13358
G1 X187.77 Y142.102 E.01068
M204 S250
G1 X187.71 Y141.71 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X177.09 Y141.71 E.31633
G1 X177.09 Y138.34 E.10038
G1 X187.71 Y138.34 E.31633
G1 X187.71 Y141.65 E.09859
; WIPE_START
M204 S8000
G1 X185.71 Y141.661 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X185.54 Y149.292 Z.8 F60000
G1 X184.305 Y204.865 Z.8
G1 Z.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X184.134 Y204.785 E.00606
G3 X185.026 Y199.947 I1.165 J-2.287 E.21162
G1 X185.269 Y199.932 E.00783
G3 X184.367 Y204.89 I.029 J2.566 E.29082
G1 X184.361 Y204.887 E.00024
M204 S10000
G1 X184.437 Y204.473 F60000
G1 F8843.478
M204 S8000
G1 X184.127 Y204.312 E.01124
G3 X185.07 Y200.352 I1.172 J-1.813 E.17092
G1 X185.274 Y200.34 E.00656
G3 X184.516 Y204.511 I.025 J2.159 E.24467
G1 X184.492 Y204.499 E.00087
M204 S10000
G1 X184.622 Y204.112 F60000
G1 F8843.478
M204 S8000
G1 X184.348 Y203.97 E.00993
G3 X185.114 Y200.757 I.951 J-1.471 E.13866
G1 X185.278 Y200.747 E.00528
G3 X184.677 Y204.136 I.021 J1.752 E.19808
M204 S250
G1 X184.8 Y203.764 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X184.56 Y203.64 E.00804
G3 X185.157 Y201.147 I.739 J-1.141 E.09967
G1 X185.283 Y201.14 E.00376
G3 X184.857 Y203.784 I.017 J1.359 E.14114
; WIPE_START
M204 S8000
G1 X184.56 Y203.64 E-.12513
G1 X184.355 Y203.478 E-.09941
G1 X184.185 Y203.279 E-.09932
G1 X184.057 Y203.052 E-.09906
G1 X183.973 Y202.8 E-.10119
G1 X183.94 Y202.525 E-.10519
G1 X183.96 Y202.265 E-.09901
G1 X183.982 Y202.185 E-.03168
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X184.405 Y194.564 Z.8 F60000
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
G1 X181.641 Y195.334 E.42607
G1 X160.916 Y195.334 E.66644
G1 X160.916 Y193.531 E.05796
G1 X166.466 Y193.531 E.17847
G1 X166.466 Y177.459 E.51683
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
G1 X183.222 Y138.531 Z.8 F60000
G1 X161.864 Y168.159 Z.8
G1 Z.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X161.065 Y168.159 E.0257
G1 X161.065 Y159.641 E.27392
G1 X170.324 Y159.641 E.29774
G1 X170.324 Y168.159 E.27392
G1 X161.924 Y168.159 E.27012
M204 S10000
G1 X161.864 Y167.752 F60000
G1 F8843.478
M204 S8000
G1 X161.472 Y167.752 E.01261
G1 X161.472 Y160.048 E.24774
G1 X169.917 Y160.048 E.27156
G1 X169.917 Y167.752 E.24774
G1 X161.924 Y167.752 E.25703
M204 S250
G1 X161.864 Y167.36 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X161.864 Y160.44 E.20612
G1 X169.525 Y160.44 E.22819
G1 X169.525 Y167.36 E.20612
G1 X161.924 Y167.36 E.22641
; WIPE_START
M204 S8000
G1 X161.907 Y165.36 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X163.539 Y172.816 Z.8 F60000
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
G1 X165.775 Y191.51 Z.8 F60000
G1 X166.059 Y192.325 Z.8
G1 Z.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
M73 P41 R12
G1 F8843.478
M204 S8000
G1 X166.059 Y193.124 E.0257
G1 X161.341 Y193.124 E.15172
G1 X161.341 Y185.866 E.2334
G1 X166.059 Y185.866 E.15172
G1 X166.059 Y192.265 E.20577
M204 S10000
G1 X165.652 Y192.325 F60000
G1 F8843.478
M204 S8000
G1 X165.652 Y192.717 E.01261
G1 X161.748 Y192.717 E.12554
G1 X161.748 Y186.273 E.20722
G1 X165.652 Y186.273 E.12554
G1 X165.652 Y192.265 E.19268
M204 S250
G1 X165.26 Y192.325 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X162.14 Y192.325 E.09293
G1 X162.14 Y186.665 E.16859
G1 X165.26 Y186.665 E.09293
G1 X165.26 Y192.265 E.1668
; WIPE_START
M204 S8000
G1 X163.26 Y192.303 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X166.972 Y185.634 Z.8 F60000
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
G1 X181.234 Y195.741 E.42607
G1 X160.509 Y195.741 E.66644
G1 X160.509 Y132.519 E2.03298
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
G1 X167.726 Y134.83 Z.8 F60000
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
G1 X180.827 Y196.148 E.42607
G1 X160.102 Y196.148 E.66644
G1 X160.102 Y132.112 E2.05916
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
G1 X180.435 Y196.54 E.39467
G1 X159.71 Y196.54 E.61733
G1 X159.71 Y131.72 E1.93077
G1 X168.71 Y131.72 E.26808
; WIPE_START
M204 S8000
G1 X168.74 Y129.72 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X167.959 Y133.09 Z.8 F60000
G1 Z.4
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42003
G1 F9546.286
M204 S8000
G1 X167.699 Y133.349 E.01093
G1 X167.699 Y133.882 E.01589
G1 X168.322 Y133.259 E.02625
G1 X168.856 Y133.259 E.01589
G1 X167.699 Y134.416 E.04871
G1 X167.699 Y134.949 E.01589
G1 X169.389 Y133.259 E.07118
G1 X169.922 Y133.259 E.01589
G1 X167.53 Y135.652 E.1008
; WIPE_START
G1 X168.944 Y134.238 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X166.755 Y132.56 Z.8 F60000
G1 Z.4
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
G1 X161.375 Y133.13 Z.8 F60000
G1 Z.4
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
M204 S10000
G1 X161.445 Y153.47 F60000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42003
G1 F9546.286
M204 S8000
G1 X161.249 Y153.665 E.00824
G1 X161.249 Y154.199 E.01589
G1 X161.809 Y153.639 E.02356
G1 X162.342 Y153.639 E.01589
G1 X161.249 Y154.732 E.04602
G1 X161.249 Y155.265 E.01589
G1 X162.875 Y153.639 E.06849
G1 X163.408 Y153.639 E.01589
G1 X161.249 Y155.798 E.09096
G1 X161.249 Y156.332 E.01589
G1 X163.942 Y153.639 E.11343
G1 X164.475 Y153.639 E.01589
G1 X161.249 Y156.865 E.13589
G1 X161.249 Y157.398 E.01589
G1 X165.008 Y153.639 E.15836
G1 X165.542 Y153.639 E.01589
G1 X161.249 Y157.932 E.18083
G1 X161.249 Y158.465 E.01589
G1 X165.691 Y154.024 E.1871
G1 X165.691 Y154.557 E.01589
G1 X161.347 Y158.901 E.18299
G1 X161.88 Y158.901 E.01589
G1 X165.691 Y155.09 E.16052
G1 X165.691 Y155.624 E.01589
G1 X162.414 Y158.901 E.13805
G1 X162.947 Y158.901 E.01589
G1 X165.883 Y155.964 E.1237
G1 X166.417 Y155.964 E.01589
G1 X163.48 Y158.901 E.1237
G1 X164.014 Y158.901 E.01589
G1 X166.95 Y155.964 E.1237
G1 X167.483 Y155.964 E.01589
G1 X164.547 Y158.901 E.1237
G1 X165.08 Y158.901 E.01589
G1 X168.017 Y155.964 E.1237
G1 X168.55 Y155.964 E.01589
G1 X165.614 Y158.901 E.1237
G1 X166.147 Y158.901 E.01589
G1 X169.083 Y155.964 E.1237
G1 X169.616 Y155.964 E.01589
G1 X166.68 Y158.901 E.1237
G1 X167.214 Y158.901 E.01589
G1 X170.15 Y155.964 E.1237
G1 X170.683 Y155.964 E.01589
G1 X167.747 Y158.901 E.1237
G1 X168.28 Y158.901 E.01589
G1 X171.216 Y155.964 E.1237
G1 X171.75 Y155.964 E.01589
G1 X168.813 Y158.901 E.1237
G1 X169.347 Y158.901 E.01589
G1 X172.283 Y155.964 E.1237
G1 X172.816 Y155.964 E.01589
G1 X169.88 Y158.901 E.1237
G1 X170.413 Y158.901 E.01589
G1 X173.35 Y155.964 E.1237
G1 X173.883 Y155.964 E.01589
G1 X170.947 Y158.901 E.1237
G1 X171.064 Y158.901 E.0035
G1 X171.064 Y159.316 E.01238
G1 X174.416 Y155.964 E.14121
G1 X174.95 Y155.964 E.01589
G1 X171.064 Y159.85 E.16368
G1 X171.064 Y160.383 E.01589
G1 X175.483 Y155.964 E.18615
G1 X176.016 Y155.964 E.01589
G1 X171.064 Y160.916 E.20861
G1 X171.064 Y161.45 E.01589
G1 X181.326 Y151.188 E.43229
G1 X181.326 Y151.722 E.01589
G1 X171.064 Y161.983 E.43229
G1 X171.064 Y162.516 E.01589
G1 X181.326 Y152.255 E.43229
G1 X181.326 Y152.788 E.01589
G1 X171.064 Y163.05 E.43229
G1 X171.064 Y163.583 E.01589
G1 X181.326 Y153.322 E.43229
G1 X181.326 Y153.855 E.01589
G1 X171.064 Y164.116 E.43229
G1 X171.064 Y164.649 E.01589
G1 X181.326 Y154.388 E.43229
G1 X181.326 Y154.921 E.01589
G1 X171.064 Y165.183 E.43229
G1 X171.064 Y165.716 E.01589
G1 X181.326 Y155.455 E.43229
G1 X181.326 Y155.988 E.01589
G1 X171.064 Y166.249 E.43229
G1 X171.064 Y166.783 E.01589
G1 X181.326 Y156.521 E.43229
G1 X181.326 Y157.055 E.01589
G1 X171.064 Y167.316 E.43229
G1 X171.064 Y167.849 E.01589
G1 X181.326 Y157.588 E.43229
G1 X181.326 Y158.121 E.01589
G1 X170.895 Y168.552 E.43944
; WIPE_START
G1 X172.309 Y167.138 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X166.704 Y172.319 Z.8 F60000
G1 X160.925 Y177.662 Z.8
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
G1 X166.263 Y185.495 Z.8 F60000
G1 Z.4
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
G1 X160.925 Y193.328 E.25713
; WIPE_START
G1 X160.925 Y191.328 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X161.08 Y194.367 Z.8 F60000
G1 Z.4
M73 P42 R12
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42003
G1 F9546.286
M204 S8000
G1 X161.582 Y193.864 E.02116
G1 X162.115 Y193.864 E.01589
G1 X161.249 Y194.73 E.03648
G1 X161.249 Y195.001 E.00805
G1 X161.512 Y195.001 E.00784
G1 X162.649 Y193.864 E.04787
G1 X163.182 Y193.864 E.01589
G1 X162.046 Y195.001 E.04787
G1 X162.579 Y195.001 E.01589
G1 X163.715 Y193.864 E.04787
G1 X164.249 Y193.864 E.01589
G1 X163.112 Y195.001 E.04787
G1 X163.646 Y195.001 E.01589
G1 X164.782 Y193.864 E.04787
G1 X165.315 Y193.864 E.01589
G1 X164.179 Y195.001 E.04787
G1 X164.712 Y195.001 E.01589
G1 X165.849 Y193.864 E.04787
G1 X166.382 Y193.864 E.01589
G1 X165.076 Y195.17 E.05502
; WIPE_START
G1 X166.382 Y193.864 E-.70182
G1 X166.229 Y193.864 E-.05818
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X173.166 Y197.047 Z.8 F60000
G1 X182.786 Y201.46 Z.8
G1 Z.4
G1 E.8 F1800
G1 F9546.286
M204 S8000
G1 X181.974 Y202.271 E.03418
G1 X181.974 Y202.804 E.01589
G1 X182.407 Y202.372 E.01823
G1 X182.426 Y202.886 E.01533
G1 X181.974 Y203.338 E.01903
G1 X181.974 Y203.871 E.01589
G1 X182.523 Y203.322 E.02312
G1 X182.541 Y203.401 E.00241
G1 X182.674 Y203.705 E.00988
G1 X181.974 Y204.404 E.02946
G1 X181.974 Y204.938 E.01589
G1 X182.86 Y204.052 E.03732
G1 X183.079 Y204.367 E.01142
G1 X181.974 Y205.471 E.04652
G1 X181.974 Y206.004 E.01589
G1 X183.341 Y204.637 E.05759
G2 X183.638 Y204.874 I1.383 J-1.423 E.01132
G1 X181.974 Y206.538 E.07007
G1 X181.974 Y207.071 E.01589
G1 X183.968 Y205.077 E.08399
G1 X184.348 Y205.23 E.01221
G1 X181.974 Y207.604 E.10001
G1 X181.974 Y208.137 E.01589
G1 X184.762 Y205.35 E.11744
G2 X185.247 Y205.398 I.583 J-3.411 E.01454
G1 X182.395 Y208.251 E.12018
G1 X182.928 Y208.251 E.01589
G1 X185.829 Y205.349 E.12223
G2 X186.647 Y205.064 I-.525 J-2.826 E.02591
G1 X183.461 Y208.251 E.13423
G1 X183.994 Y208.251 E.01589
G1 X188.035 Y204.211 E.1702
G1 X188.151 Y204.152 E.00388
G1 X188.151 Y204.628 E.01418
G1 X184.528 Y208.251 E.15262
G1 X185.061 Y208.251 E.01589
G1 X188.151 Y205.161 E.13016
G1 X188.151 Y205.694 E.01589
G1 X185.594 Y208.251 E.10769
G1 X186.128 Y208.251 E.01589
G1 X188.151 Y206.228 E.08522
G1 X188.151 Y206.761 E.01589
G1 X186.661 Y208.251 E.06275
G1 X187.194 Y208.251 E.01589
G1 X188.151 Y207.294 E.04029
G1 X188.151 Y207.828 E.01589
G1 X187.558 Y208.42 E.02497
; WIPE_START
G1 X188.151 Y207.828 E-.31849
G1 X188.151 Y207.294 E-.20266
G1 X187.706 Y207.739 E-.23885
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
M204 S10000
G1 X187.546 Y200.966 F60000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42003
G1 F9546.286
M204 S8000
G1 X188.151 Y200.361 E.02549
G1 X188.151 Y199.828 E.01589
G1 X187.433 Y200.545 E.03022
G1 X187.164 Y200.282 E.01123
G1 X188.151 Y199.295 E.04158
G1 X188.151 Y198.761 E.01589
G1 X186.858 Y200.054 E.05444
G2 X186.508 Y199.871 I-.797 J1.101 E.01182
G1 X188.151 Y198.228 E.06921
G1 X188.151 Y197.695 E.01589
G1 X186.126 Y199.719 E.0853
G1 X185.68 Y199.632 E.01353
G1 X188.151 Y197.161 E.10408
G1 X188.151 Y196.628 E.01589
G1 X185.167 Y199.612 E.12571
G2 X184.542 Y199.703 I.033 J2.418 E.01884
G1 X188.151 Y196.095 E.15201
G1 X188.151 Y195.561 E.01589
G1 X181.974 Y201.738 E.26019
G1 X181.974 Y201.204 E.01589
G1 X188.151 Y195.028 E.26019
G1 X188.151 Y194.495 E.01589
G1 X181.974 Y200.671 E.26019
G1 X181.974 Y200.138 E.01589
G1 X188.151 Y193.962 E.26019
G1 X188.151 Y193.428 E.01589
G1 X181.974 Y199.604 E.26019
G1 X181.974 Y199.071 E.01589
G1 X188.151 Y192.895 E.26019
G1 X188.151 Y192.362 E.01589
G1 X181.974 Y198.538 E.26019
G1 X181.974 Y198.005 E.01589
G1 X188.151 Y191.828 E.26019
G1 X188.151 Y191.295 E.01589
G1 X181.974 Y197.471 E.26019
G1 X181.974 Y196.938 E.01589
G1 X188.151 Y190.762 E.26019
G1 X188.151 Y190.228 E.01589
G1 X181.974 Y196.405 E.26019
G1 X181.974 Y195.871 E.01589
G1 X188.151 Y189.695 E.26019
G1 X188.151 Y189.162 E.01589
G1 X181.974 Y195.338 E.26019
G1 X181.974 Y195.001 E.01005
G1 X181.778 Y195.001 E.00584
G1 X188.151 Y188.628 E.26845
G1 X188.151 Y188.095 E.01589
G1 X181.245 Y195.001 E.29092
G1 X180.712 Y195.001 E.01589
G1 X188.151 Y187.562 E.31339
G1 X188.151 Y187.028 E.01589
G1 X180.178 Y195.001 E.33585
G1 X179.645 Y195.001 E.01589
G1 X188.151 Y186.495 E.35832
G1 X188.151 Y185.962 E.01589
G1 X179.112 Y195.001 E.38079
G1 X178.578 Y195.001 E.01589
G1 X188.151 Y185.428 E.40326
G1 X188.151 Y184.895 E.01589
G1 X178.045 Y195.001 E.42572
G1 X177.512 Y195.001 E.01589
G1 X188.151 Y184.362 E.44819
G1 X188.151 Y183.829 E.01589
G1 X176.979 Y195.001 E.47066
G1 X176.445 Y195.001 E.01589
G1 X188.151 Y183.295 E.49313
G1 X188.151 Y182.844 E.01343
G1 X188.068 Y182.844 E.00246
G1 X175.912 Y195.001 E.51212
G1 X175.379 Y195.001 E.01589
G1 X187.535 Y182.844 E.51212
G1 X187.002 Y182.844 E.01589
G1 X174.845 Y195.001 E.51212
G1 X174.312 Y195.001 E.01589
G1 X186.468 Y182.844 E.51212
G1 X185.935 Y182.844 E.01589
G1 X173.779 Y195.001 E.51212
G1 X173.245 Y195.001 E.01589
G1 X185.402 Y182.844 E.51212
G1 X184.868 Y182.844 E.01589
G1 X172.712 Y195.001 E.51212
G1 X172.179 Y195.001 E.01589
G1 X184.335 Y182.844 E.51212
G1 X183.802 Y182.844 E.01589
G1 X171.645 Y195.001 E.51212
G1 X171.112 Y195.001 E.01589
G1 X183.268 Y182.844 E.51212
G1 X182.735 Y182.844 E.01589
G1 X170.579 Y195.001 E.51212
G1 X170.045 Y195.001 E.01589
G1 X182.202 Y182.844 E.51212
G1 X181.668 Y182.844 E.01589
G1 X169.512 Y195.001 E.51212
G1 X168.979 Y195.001 E.01589
G1 X181.326 Y182.654 E.52015
G1 X181.326 Y182.121 E.01589
G1 X168.445 Y195.001 E.54261
G1 X167.912 Y195.001 E.01589
G1 X181.326 Y181.587 E.56508
G1 X181.326 Y181.054 E.01589
G1 X167.379 Y195.001 E.58755
G1 X166.846 Y195.001 E.01589
G1 X181.326 Y180.521 E.61002
G1 X181.326 Y179.987 E.01589
G1 X166.312 Y195.001 E.63248
G1 X165.779 Y195.001 E.01589
G1 X181.326 Y179.454 E.65495
G1 X181.326 Y178.921 E.01589
G1 X166.799 Y193.447 E.61196
G1 X166.799 Y192.914 E.01589
G1 X181.326 Y178.387 E.61196
G1 X181.326 Y177.854 E.01589
G1 X166.799 Y192.38 E.61196
G1 X166.799 Y191.847 E.01589
G1 X181.326 Y177.321 E.61196
G1 X181.326 Y176.787 E.01589
G1 X166.799 Y191.314 E.61196
G1 X166.799 Y190.78 E.01589
G1 X181.326 Y176.254 E.61196
G1 X181.326 Y175.721 E.01589
G1 X166.799 Y190.247 E.61196
G1 X166.799 Y189.714 E.01589
G1 X181.326 Y175.187 E.61196
G1 X181.326 Y174.654 E.01589
G1 X166.799 Y189.18 E.61196
G1 X166.799 Y188.647 E.01589
G1 X181.326 Y174.121 E.61196
G1 X181.326 Y173.587 E.01589
G1 X166.799 Y188.114 E.61196
G1 X166.799 Y187.58 E.01589
G1 X181.326 Y173.054 E.61196
G1 X181.326 Y172.521 E.01589
G1 X166.799 Y187.047 E.61196
G1 X166.799 Y186.514 E.01589
G1 X181.326 Y171.988 E.61196
G1 X181.326 Y171.454 E.01589
G1 X166.799 Y185.981 E.61196
G1 X166.799 Y185.447 E.01589
G1 X181.326 Y170.921 E.61196
G1 X181.326 Y170.388 E.01589
G1 X166.799 Y184.914 E.61196
G1 X166.799 Y184.381 E.01589
G1 X181.326 Y169.854 E.61196
G1 X181.326 Y169.321 E.01589
G1 X166.799 Y183.847 E.61196
G1 X166.799 Y183.314 E.01589
G1 X181.326 Y168.788 E.61196
G1 X181.326 Y168.254 E.01589
G1 X166.799 Y182.781 E.61196
G1 X166.799 Y182.247 E.01589
G1 X181.326 Y167.721 E.61196
G1 X181.326 Y167.188 E.01589
G1 X166.799 Y181.714 E.61196
G1 X166.799 Y181.181 E.01589
G1 X181.326 Y166.654 E.61196
G1 X181.326 Y166.121 E.01589
G1 X166.799 Y180.647 E.61196
G1 X166.799 Y180.114 E.01589
G1 X181.326 Y165.588 E.61196
G1 X181.326 Y165.054 E.01589
G1 X166.799 Y179.581 E.61196
G1 X166.799 Y179.047 E.01589
G1 X181.326 Y164.521 E.61196
G1 X181.326 Y163.988 E.01589
G1 X166.799 Y178.514 E.61196
G1 X166.799 Y177.981 E.01589
M73 P42 R11
G1 X181.326 Y163.455 E.61196
G1 X181.326 Y162.921 E.01589
G1 X166.799 Y177.447 E.61196
G1 X166.799 Y177.126 E.00959
G1 X166.588 Y177.126 E.0063
G1 X181.326 Y162.388 E.62087
M73 P43 R11
G1 X181.326 Y161.855 E.01589
G1 X166.055 Y177.126 E.64334
G1 X165.521 Y177.126 E.01589
G1 X181.326 Y161.321 E.66581
G1 X181.326 Y160.788 E.01589
G1 X164.988 Y177.126 E.68827
G1 X164.455 Y177.126 E.01589
G1 X181.326 Y160.255 E.71074
G1 X181.326 Y159.721 E.01589
G1 X163.921 Y177.126 E.73321
G1 X163.388 Y177.126 E.01589
G1 X181.326 Y159.188 E.75568
G1 X181.326 Y158.655 E.01589
G1 X162.855 Y177.126 E.77814
G1 X162.321 Y177.126 E.01589
G1 X170.548 Y168.899 E.34656
G1 X170.014 Y168.899 E.01589
G1 X161.788 Y177.126 E.34656
G1 X161.255 Y177.126 E.01589
G1 X169.481 Y168.899 E.34656
G1 X168.948 Y168.899 E.01589
G1 X161.249 Y176.598 E.32432
G1 X161.249 Y176.064 E.01589
G1 X168.414 Y168.899 E.30185
G1 X167.881 Y168.899 E.01589
G1 X161.249 Y175.531 E.27938
G1 X161.249 Y174.998 E.01589
G1 X167.348 Y168.899 E.25691
G1 X166.814 Y168.899 E.01589
G1 X161.249 Y174.464 E.23445
G1 X161.249 Y173.931 E.01589
G1 X166.281 Y168.899 E.21198
G1 X165.748 Y168.899 E.01589
G1 X161.249 Y173.398 E.18951
G1 X161.249 Y172.865 E.01589
G1 X165.214 Y168.899 E.16704
G1 X164.681 Y168.899 E.01589
G1 X161.249 Y172.331 E.14458
G1 X161.249 Y171.798 E.01589
G1 X164.148 Y168.899 E.12211
G1 X163.615 Y168.899 E.01589
G1 X161.249 Y171.265 E.09964
G1 X161.249 Y170.731 E.01589
G1 X163.081 Y168.899 E.07717
G1 X162.548 Y168.899 E.01589
G1 X161.249 Y170.198 E.05471
G1 X161.249 Y169.665 E.01589
G1 X162.015 Y168.899 E.03224
G1 X161.481 Y168.899 E.01589
G1 X161.08 Y169.301 E.01692
M204 S10000
G1 X160.787 Y168.363 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.19158
G1 F15000
M204 S8000
G1 X160.787 Y159.437 E.10481
; WIPE_START
G1 X160.787 Y161.437 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X161.297 Y153.822 Z.8 F60000
G1 X162.037 Y142.75 Z.8
G1 Z.4
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
G1 X166.63 Y145.618 Z.8 F60000
G1 Z.4
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42003
G1 F9546.286
M204 S8000
G1 X176.999 Y135.249 E.43682
G1 X176.465 Y135.249 E.01589
G1 X166.799 Y144.915 E.40721
G1 X166.799 Y144.382 E.01589
G1 X175.932 Y135.249 E.38474
G1 X175.551 Y135.249 E.01136
G1 X175.551 Y135.097 E.00453
G1 X166.799 Y143.849 E.36867
G1 X166.799 Y143.315 E.01589
G1 X167.145 Y142.97 E.01456
M204 S10000
G1 X167.53 Y142.585 F60000
G1 F9546.286
M204 S8000
G1 X175.551 Y134.564 E.33791
G1 X175.551 Y134.031 E.01589
G1 X167.699 Y141.882 E.33076
G1 X167.699 Y141.349 E.01589
G1 X175.551 Y133.497 E.33076
G1 X175.551 Y132.964 E.01589
G1 X167.699 Y140.815 E.33076
G1 X167.699 Y140.282 E.01589
G1 X175.551 Y132.431 E.33076
G1 X175.551 Y131.898 E.01589
G1 X167.699 Y139.749 E.33076
G1 X167.699 Y139.216 E.01589
G1 X175.551 Y131.364 E.33076
G1 X175.551 Y130.831 E.01589
G1 X167.699 Y138.682 E.33076
G1 X167.699 Y138.149 E.01589
G1 X175.551 Y130.298 E.33076
G1 X175.551 Y129.764 E.01589
G1 X167.699 Y137.616 E.33076
G1 X167.699 Y137.082 E.01589
G1 X175.532 Y129.249 E.32998
G1 X174.999 Y129.249 E.01589
G1 X167.699 Y136.549 E.30752
G1 X167.699 Y136.016 E.01589
G1 X174.466 Y129.249 E.28505
G1 X173.932 Y129.249 E.01589
G1 X170.309 Y132.872 E.15263
G1 X170.309 Y132.339 E.01589
G1 X173.399 Y129.249 E.13016
G1 X172.866 Y129.249 E.01589
G1 X170.309 Y131.806 E.10769
G1 X170.309 Y131.272 E.01589
G1 X172.332 Y129.249 E.08523
G1 X171.799 Y129.249 E.01589
G1 X170.309 Y130.739 E.06276
G1 X170.309 Y130.206 E.01589
G1 X171.266 Y129.249 E.04029
G1 X170.732 Y129.249 E.01589
G1 X170.14 Y129.842 E.02497
; WIPE_START
G1 X170.732 Y129.249 E-.31854
G1 X171.266 Y129.249 E-.20266
G1 X170.821 Y129.694 E-.2388
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
G1 X188.32 Y136.194 Z.8 F60000
G1 Z.4
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42003
G1 F9546.286
M204 S8000
G1 X187.714 Y136.801 E.02556
G1 X187.18 Y136.801 E.01589
G1 X188.151 Y135.83 E.04088
G1 X188.151 Y135.297 E.01589
G1 X186.647 Y136.801 E.06335
G1 X186.114 Y136.801 E.01589
G1 X187.665 Y135.249 E.06535
G1 X187.132 Y135.249 E.01589
G1 X185.58 Y136.801 E.06535
G1 X185.047 Y136.801 E.01589
G1 X186.598 Y135.249 E.06535
G1 X186.065 Y135.249 E.01589
G1 X184.514 Y136.801 E.06535
G1 X183.98 Y136.801 E.01589
G1 X185.532 Y135.249 E.06535
G1 X184.998 Y135.249 E.01589
G1 X183.447 Y136.801 E.06535
G1 X182.914 Y136.801 E.01589
G1 X184.465 Y135.249 E.06535
G1 X183.932 Y135.249 E.01589
G1 X182.38 Y136.801 E.06535
G1 X181.847 Y136.801 E.01589
G1 X183.398 Y135.249 E.06535
G1 X182.865 Y135.249 E.01589
G1 X181.314 Y136.801 E.06535
G1 X180.781 Y136.801 E.01589
G1 X182.332 Y135.249 E.06535
G1 X181.798 Y135.249 E.01589
G1 X180.247 Y136.801 E.06535
G1 X179.714 Y136.801 E.01589
G1 X181.265 Y135.249 E.06535
G1 X180.732 Y135.249 E.01589
G1 X179.181 Y136.801 E.06535
G1 X178.647 Y136.801 E.01589
G1 X180.199 Y135.249 E.06535
G1 X179.665 Y135.249 E.01589
G1 X178.114 Y136.801 E.06535
G1 X177.581 Y136.801 E.01589
G1 X179.132 Y135.249 E.06535
G1 X178.599 Y135.249 E.01589
G1 X177.047 Y136.801 E.06535
G1 X176.514 Y136.801 E.01589
G1 X178.065 Y135.249 E.06535
G1 X177.532 Y135.249 E.01589
G1 X175.981 Y136.801 E.06535
G1 X175.551 Y136.801 E.01281
G1 X175.551 Y137.231 E.01281
G1 X166.799 Y145.982 E.36867
G1 X166.799 Y146.515 E.01589
G1 X175.551 Y137.764 E.36867
G1 X175.551 Y138.297 E.01589
G1 X166.799 Y147.049 E.36867
G1 X166.799 Y147.582 E.01589
G1 X175.551 Y138.831 E.36867
G1 X175.551 Y139.364 E.01589
G1 X166.799 Y148.115 E.36867
G1 X166.799 Y148.649 E.01589
G1 X175.551 Y139.897 E.36867
G1 X175.551 Y140.431 E.01589
G1 X166.799 Y149.182 E.36867
G1 X166.799 Y149.715 E.01589
G1 X175.551 Y140.964 E.36867
G1 X175.551 Y141.497 E.01589
G1 X167.022 Y150.026 E.35929
G1 X167.556 Y150.026 E.01589
G1 X175.551 Y142.03 E.33682
G1 X175.551 Y142.564 E.01589
G1 X168.089 Y150.026 E.31435
G1 X168.622 Y150.026 E.01589
G1 X175.551 Y143.097 E.29188
G1 X175.551 Y143.249 E.00454
G1 X175.932 Y143.249 E.01135
G1 X169.155 Y150.026 E.28547
G1 X169.689 Y150.026 E.01589
G1 X176.465 Y143.249 E.28547
G1 X176.998 Y143.249 E.01589
G1 X170.222 Y150.026 E.28547
G1 X170.755 Y150.026 E.01589
G1 X177.532 Y143.249 E.28547
G1 X178.065 Y143.249 E.01589
G1 X171.289 Y150.026 E.28547
G1 X171.822 Y150.026 E.01589
G1 X178.598 Y143.249 E.28547
G1 X179.132 Y143.249 E.01589
G1 X172.355 Y150.026 E.28547
G1 X172.889 Y150.026 E.01589
G1 X179.665 Y143.249 E.28547
G1 X180.198 Y143.249 E.01589
G1 X173.422 Y150.026 E.28547
G1 X173.955 Y150.026 E.01589
G1 X180.732 Y143.249 E.28547
G1 X181.265 Y143.249 E.01589
G1 X174.489 Y150.026 E.28547
G1 X175.022 Y150.026 E.01589
G1 X181.798 Y143.249 E.28547
G1 X182.331 Y143.249 E.01589
G1 X175.555 Y150.026 E.28547
G1 X176.089 Y150.026 E.01589
G1 X182.865 Y143.249 E.28547
G1 X183.398 Y143.249 E.01589
G1 X176.622 Y150.026 E.28547
G1 X176.709 Y150.026 E.00261
G1 X176.709 Y150.471 E.01328
G1 X183.931 Y143.249 E.30425
G1 X184.465 Y143.249 E.01589
G1 X176.709 Y151.005 E.32672
G1 X176.709 Y151.538 E.01589
G1 X181.326 Y146.922 E.19447
G1 X181.326 Y147.455 E.01589
G1 X176.709 Y152.071 E.19447
G1 X176.709 Y152.605 E.01589
G1 X181.326 Y147.988 E.19447
G1 X181.326 Y148.522 E.01589
G1 X176.709 Y153.138 E.19447
G1 X176.709 Y153.671 E.01589
G1 X181.326 Y149.055 E.19447
G1 X181.326 Y149.588 E.01589
G1 X176.709 Y154.205 E.19447
G1 X176.709 Y154.738 E.01589
G1 X181.326 Y150.122 E.19447
G1 X181.326 Y150.655 E.01589
G1 X176.54 Y155.441 E.20162
; WIPE_START
G1 X177.954 Y154.027 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X181.446 Y147.24 Z.8 F60000
G1 X181.912 Y146.335 Z.8
G1 Z.4
G1 E.8 F1800
G1 F9546.286
M204 S8000
G1 X184.998 Y143.249 E.13
G1 X185.531 Y143.249 E.01589
G1 X182.615 Y146.166 E.12286
G1 X183.148 Y146.166 E.01589
G1 X186.065 Y143.249 E.12286
G1 X186.598 Y143.249 E.01589
G1 X183.682 Y146.166 E.12286
G1 X184.215 Y146.166 E.01589
G1 X187.131 Y143.249 E.12286
G1 X187.665 Y143.249 E.01589
G1 X184.748 Y146.166 E.12286
G1 X185.282 Y146.166 E.01589
G1 X188.151 Y143.297 E.12086
G1 X188.151 Y143.83 E.01589
G1 X185.815 Y146.166 E.0984
G1 X186.348 Y146.166 E.01589
G1 X188.151 Y144.363 E.07593
G1 X188.151 Y144.897 E.01589
G1 X186.882 Y146.166 E.05346
G1 X187.415 Y146.166 E.01589
G1 X188.151 Y145.43 E.03099
G1 X188.151 Y145.963 E.01589
G1 X187.779 Y146.335 E.01567
; WIPE_START
G1 X188.151 Y145.963 E-.19996
G1 X188.151 Y145.43 E-.20266
G1 X187.486 Y146.095 E-.35739
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
G1 X186.492 Y174.76 Z.8 F60000
G1 X166.884 Y121.274 Z.8
G1 Z.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X160.916 Y121.274 E.1919
G1 X160.916 Y111.416 E.31698
G1 X166.884 Y111.416 E.1919
G1 X166.884 Y116.237 E.15501
G1 X166.66 Y116.255 E.00723
G2 X166.57 Y117.203 I-2.556 J.236 E.48778
G2 X166.654 Y116.74 I-2.169 J-.636 E.01518
G1 X166.884 Y116.754 E.00739
G1 X166.884 Y121.214 E.14342
; WIPE_START
G1 X164.884 Y121.234 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X162.036 Y117.109 Z.8 F60000
G1 Z.4
G1 E.8 F1800
G1 F8843.478
M204 S8000
G1 X161.995 Y116.985 E.00418
G3 X163.871 Y114.352 I2.103 J-.486 E.1175
M73 P44 R11
G1 X164.074 Y114.34 E.00653
G3 X162.127 Y117.378 I.025 J2.159 E.29884
G1 X162.055 Y117.165 E.0072
M204 S10000
G1 X162.421 Y116.98 F60000
G1 F8843.478
M204 S8000
G1 X162.393 Y116.894 E.00291
G3 X163.915 Y114.757 I1.707 J-.395 E.09536
G1 X164.078 Y114.747 E.00526
G3 X162.499 Y117.212 I.021 J1.752 E.24248
G1 X162.44 Y117.037 E.00596
M204 S250
G1 X162.791 Y116.856 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X162.775 Y116.806 E.00156
G3 X163.957 Y115.147 I1.324 J-.307 E.06858
G1 X164.083 Y115.14 E.00374
G3 X162.858 Y117.053 I.017 J1.359 E.17431
G1 X162.81 Y116.912 E.00442
; WIPE_START
M204 S8000
G1 X162.775 Y116.806 E-.04268
G1 X162.74 Y116.525 E-.10751
G1 X162.76 Y116.265 E-.09918
G1 X162.83 Y116.013 E-.09938
G1 X162.947 Y115.779 E-.09927
G1 X163.121 Y115.555 E-.10798
G1 X163.225 Y115.459 E-.05376
G1 X163.441 Y115.31 E-.09948
G1 X163.563 Y115.257 E-.05076
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X167.291 Y121.681 Z.8 F60000
G1 Z.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X160.509 Y121.681 E.21808
G1 X160.509 Y111.009 E.34316
G1 X167.291 Y111.009 E.21808
G1 X167.291 Y121.621 E.34123
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
G1 X180.86 Y150.312 Z1 F60000
G1 X175.17 Y150.766 Z1
G1 Z.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X175.969 Y150.766 E.0257
G1 X175.969 Y155.224 E.14336
G1 X166.431 Y155.224 E.30672
G1 X166.431 Y150.766 E.14336
G1 X175.11 Y150.766 E.27909
; COOLING_NODE: 0
M204 S10000
G1 X175.17 Y151.173 F60000
G1 F8843.478
M204 S8000
G1 X175.562 Y151.173 E.01261
G1 X175.562 Y154.817 E.11718
G1 X166.838 Y154.817 E.28054
G1 X166.838 Y151.173 E.11718
G1 X175.11 Y151.173 E.266
; COOLING_NODE: 1
M204 S250
G1 X175.17 Y151.565 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X175.17 Y154.425 E.08519
G1 X167.23 Y154.425 E.23651
G1 X167.23 Y151.565 E.08519
G1 X175.11 Y151.565 E.23472
; COOLING_NODE: 1
; WIPE_START
M204 S8000
G1 X175.152 Y153.565 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X169.922 Y148.006 Z1 F60000
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
G1 X168.544 Y141.868 Z1 F60000
G1 X187.71 Y142.509 Z1
G1 Z.6
G1 E.8 F1800
G1 F8843.478
M204 S8000
G1 X176.291 Y142.509 E.3672
G1 X176.291 Y137.541 E.15976
G1 X188.509 Y137.541 E.3929
G1 X188.509 Y142.509 E.15976
G1 X187.77 Y142.509 E.02377
; COOLING_NODE: 2
M204 S10000
G1 X187.71 Y142.102 F60000
G1 F8843.478
M204 S8000
G1 X176.698 Y142.102 E.35411
G1 X176.698 Y137.948 E.13358
G1 X188.102 Y137.948 E.36672
G1 X188.102 Y142.102 E.13358
G1 X187.77 Y142.102 E.01068
; COOLING_NODE: 3
M204 S250
G1 X187.71 Y141.71 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X177.09 Y141.71 E.31633
G1 X177.09 Y138.34 E.10038
G1 X187.71 Y138.34 E.31633
G1 X187.71 Y141.65 E.09859
; COOLING_NODE: 3
; WIPE_START
M204 S8000
G1 X185.71 Y141.661 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X185.547 Y149.292 Z1 F60000
G1 X184.363 Y204.88 Z1
G1 Z.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X184.129 Y204.784 E.00813
G3 X185.029 Y199.946 I1.168 J-2.285 E.21165
G1 X185.285 Y199.932 E.00825
G3 X184.556 Y204.956 I.012 J2.566 E.2838
G1 X184.419 Y204.902 E.00475
; COOLING_NODE: 3
M204 S10000
G1 X184.515 Y204.503 F60000
G1 F8843.478
M204 S8000
G1 X184.316 Y204.422 E.00693
G3 X185.072 Y200.352 I.982 J-1.923 E.17807
G1 X185.288 Y200.34 E.00695
G3 X184.674 Y204.566 I.01 J2.159 E.23879
G1 X184.571 Y204.525 E.00355
; COOLING_NODE: 3
M204 S10000
G1 X184.667 Y204.127 F60000
G1 F8843.478
M204 S8000
G1 X184.502 Y204.059 E.00573
G3 X185.116 Y200.757 I.796 J-1.56 E.14449
G1 X185.291 Y200.747 E.00565
G3 X184.791 Y204.176 I.008 J1.752 E.19378
G1 X184.723 Y204.149 E.00235
; COOLING_NODE: 4
M204 S250
G1 X184.813 Y203.765 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X184.682 Y203.711 E.00423
G3 X185.157 Y201.147 I.617 J-1.211 E.10389
G1 X185.294 Y201.14 E.00407
G3 X184.904 Y203.8 I.006 J1.359 E.13934
G1 X184.869 Y203.787 E.00111
; COOLING_NODE: 4
; WIPE_START
M204 S8000
G1 X184.682 Y203.711 E-.07682
G1 X184.444 Y203.557 E-.10762
G1 X184.257 Y203.373 E-.09962
G1 X184.099 Y203.139 E-.10751
G1 X183.999 Y202.897 E-.09921
G1 X183.946 Y202.625 E-.10552
G1 X183.947 Y202.359 E-.10116
G1 X183.98 Y202.197 E-.06253
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X184.402 Y194.577 Z1 F60000
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
G1 X181.641 Y195.334 E.42607
G1 X160.916 Y195.334 E.66644
G1 X160.916 Y193.531 E.05796
G1 X166.466 Y193.531 E.17847
G1 X166.466 Y177.459 E.51683
G1 X160.916 Y177.459 E.17847
G1 X160.916 Y168.566 E.28595
G1 X170.731 Y168.566 E.31561
G1 X170.731 Y159.234 E.3001
G1 X160.916 Y159.234 E.31561
M73 P45 R11
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
; COOLING_NODE: 4
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
; COOLING_NODE: 4
M204 S10000
G1 X187.71 Y129.948 F60000
G1 F8843.478
M204 S8000
G1 X188.102 Y129.948 E.01261
G1 X188.102 Y134.102 E.13358
G1 X176.698 Y134.102 E.36672
G1 X176.698 Y129.948 E.13358
G1 X187.65 Y129.948 E.35218
; COOLING_NODE: 5
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
; COOLING_NODE: 5
; WIPE_START
M204 S8000
G1 X187.686 Y132.34 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X183.222 Y138.531 Z1 F60000
G1 X161.864 Y168.159 Z1
G1 Z.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X161.065 Y168.159 E.0257
G1 X161.065 Y159.641 E.27392
G1 X170.324 Y159.641 E.29774
G1 X170.324 Y168.159 E.27392
G1 X161.924 Y168.159 E.27012
; COOLING_NODE: 5
M204 S10000
G1 X161.864 Y167.752 F60000
G1 F8843.478
M204 S8000
G1 X161.472 Y167.752 E.01261
G1 X161.472 Y160.048 E.24774
G1 X169.917 Y160.048 E.27156
G1 X169.917 Y167.752 E.24774
G1 X161.924 Y167.752 E.25703
; COOLING_NODE: 6
M204 S250
G1 X161.864 Y167.36 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X161.864 Y160.44 E.20612
G1 X169.525 Y160.44 E.22819
G1 X169.525 Y167.36 E.20612
G1 X161.924 Y167.36 E.22641
; COOLING_NODE: 6
; WIPE_START
M204 S8000
G1 X161.907 Y165.36 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X163.539 Y172.816 Z1 F60000
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
; COOLING_NODE: 6
M204 S10000
G1 X165.652 Y184.325 F60000
G1 F8843.478
M204 S8000
G1 X165.652 Y184.717 E.01261
G1 X161.748 Y184.717 E.12554
G1 X161.748 Y178.273 E.20722
G1 X165.652 Y178.273 E.12554
G1 X165.652 Y184.265 E.19268
; COOLING_NODE: 7
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
; COOLING_NODE: 7
; WIPE_START
M204 S8000
G1 X163.26 Y184.303 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X165.775 Y191.51 Z1 F60000
G1 X166.059 Y192.325 Z1
G1 Z.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X166.059 Y193.124 E.0257
G1 X161.341 Y193.124 E.15172
G1 X161.341 Y185.866 E.2334
G1 X166.059 Y185.866 E.15172
G1 X166.059 Y192.265 E.20577
; COOLING_NODE: 7
M204 S10000
G1 X165.652 Y192.325 F60000
G1 F8843.478
M204 S8000
G1 X165.652 Y192.717 E.01261
G1 X161.748 Y192.717 E.12554
G1 X161.748 Y186.273 E.20722
G1 X165.652 Y186.273 E.12554
G1 X165.652 Y192.265 E.19268
; COOLING_NODE: 8
M204 S250
G1 X165.26 Y192.325 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X162.14 Y192.325 E.09293
G1 X162.14 Y186.665 E.16859
G1 X165.26 Y186.665 E.09293
G1 X165.26 Y192.265 E.1668
; COOLING_NODE: 8
; WIPE_START
M204 S8000
G1 X163.26 Y192.303 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X166.972 Y185.634 Z1 F60000
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
G1 X181.234 Y195.741 E.42607
G1 X160.509 Y195.741 E.66644
G1 X160.509 Y132.519 E2.03298
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
G1 X167.726 Y134.83 Z1 F60000
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
G1 X180.827 Y196.148 E.42607
G1 X160.102 Y196.148 E.66644
G1 X160.102 Y132.112 E2.05916
G1 X169.102 Y132.112 E.28941
; COOLING_NODE: 10
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
G1 X180.435 Y196.54 E.39467
G1 X159.71 Y196.54 E.61733
M73 P46 R11
G1 X159.71 Y131.72 E1.93077
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
G1 X166.236 Y156.584 Z1 F60000
G1 X168.646 Y159.07 Z1
G1 Z.6
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42209
G1 F9494.421
M204 S8000
G1 X163.215 Y153.639 E.23005
G1 X162.679 Y153.639 E.01606
G1 X167.94 Y158.901 E.22286
G1 X167.404 Y158.901 E.01606
G1 X162.143 Y153.639 E.22286
G1 X161.606 Y153.639 E.01606
G1 X166.868 Y158.901 E.22286
G1 X166.331 Y158.901 E.01606
G1 X161.249 Y153.819 E.21527
G1 X161.249 Y154.355 E.01606
G1 X165.795 Y158.901 E.19256
G1 X165.259 Y158.901 E.01606
G1 X161.249 Y154.891 E.16984
G1 X161.249 Y155.427 E.01606
G1 X164.723 Y158.901 E.14713
G1 X164.187 Y158.901 E.01606
G1 X161.249 Y155.963 E.12441
G1 X161.249 Y156.5 E.01606
G1 X163.65 Y158.901 E.1017
G1 X163.114 Y158.901 E.01606
G1 X161.249 Y157.036 E.07899
G1 X161.249 Y157.572 E.01606
G1 X162.578 Y158.901 E.05627
G1 X162.042 Y158.901 E.01606
G1 X161.249 Y158.108 E.03356
G1 X161.249 Y158.645 E.01606
G1 X161.675 Y159.07 E.01803
M204 S10000
G1 X160.787 Y159.437 F60000
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
G1 X164.319 Y173.129 Z1 F60000
G1 X166.494 Y177.295 Z1
G1 Z.6
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42209
G1 F9494.421
M204 S8000
G1 X161.249 Y172.05 E.22217
G1 X161.249 Y172.586 E.01606
G1 X165.789 Y177.126 E.19227
G1 X165.252 Y177.126 E.01606
G1 X161.249 Y173.123 E.16956
G1 X161.249 Y173.659 E.01606
G1 X164.716 Y177.126 E.14684
G1 X164.18 Y177.126 E.01606
G1 X161.249 Y174.195 E.12413
G1 X161.249 Y174.731 E.01606
G1 X163.644 Y177.126 E.10142
G1 X163.107 Y177.126 E.01606
G1 X161.249 Y175.268 E.0787
G1 X161.249 Y175.804 E.01606
G1 X162.571 Y177.126 E.05599
G1 X162.035 Y177.126 E.01606
G1 X161.249 Y176.34 E.03328
G1 X161.249 Y176.876 E.01606
G1 X161.668 Y177.295 E.01775
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
G1 X160.925 Y193.328 E.25713
; WIPE_START
G1 X160.925 Y191.328 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X161.08 Y194.402 Z1 F60000
G1 Z.6
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42209
G1 F9494.421
M204 S8000
G1 X161.678 Y195.001 E.02535
G1 X162.214 Y195.001 E.01606
G1 X161.249 Y194.036 E.04088
G1 X161.249 Y193.864 E.00513
G1 X161.614 Y193.864 E.01093
G1 X162.751 Y195.001 E.04813
G1 X163.287 Y195.001 E.01606
G1 X162.151 Y193.864 E.04813
G1 X162.687 Y193.864 E.01606
G1 X163.823 Y195.001 E.04813
G1 X164.359 Y195.001 E.01606
G1 X163.223 Y193.864 E.04813
G1 X163.759 Y193.864 E.01606
G1 X164.896 Y195.001 E.04813
G1 X165.432 Y195.001 E.01606
G1 X164.296 Y193.864 E.04813
G1 X164.832 Y193.864 E.01606
G1 X165.968 Y195.001 E.04813
G1 X166.504 Y195.001 E.01606
G1 X165.368 Y193.864 E.04813
G1 X165.904 Y193.864 E.01606
G1 X167.04 Y195.001 E.04813
G1 X167.577 Y195.001 E.01606
G1 X166.44 Y193.864 E.04813
G1 X166.799 Y193.864 E.01075
G1 X166.799 Y193.687 E.00531
G1 X168.113 Y195.001 E.05564
G1 X168.649 Y195.001 E.01606
G1 X166.799 Y193.151 E.07835
G1 X166.799 Y192.615 E.01606
G1 X169.185 Y195.001 E.10107
G1 X169.722 Y195.001 E.01606
G1 X166.799 Y192.078 E.12378
G1 X166.799 Y191.542 E.01606
G1 X170.258 Y195.001 E.14649
G1 X170.794 Y195.001 E.01606
G1 X166.799 Y191.006 E.16921
G1 X166.799 Y190.47 E.01606
G1 X171.33 Y195.001 E.19192
G1 X171.867 Y195.001 E.01606
G1 X166.799 Y189.933 E.21464
G1 X166.799 Y189.397 E.01606
G1 X172.403 Y195.001 E.23735
G1 X172.939 Y195.001 E.01606
G1 X166.799 Y188.861 E.26006
G1 X166.799 Y188.325 E.01606
G1 X173.475 Y195.001 E.28278
G1 X174.011 Y195.001 E.01606
G1 X166.799 Y187.789 E.30549
G1 X166.799 Y187.252 E.01606
G1 X174.548 Y195.001 E.3282
G1 X175.084 Y195.001 E.01606
G1 X166.799 Y186.716 E.35092
G1 X166.799 Y186.18 E.01606
G1 X175.62 Y195.001 E.37363
G1 X176.156 Y195.001 E.01606
G1 X166.799 Y185.644 E.39634
G1 X166.799 Y185.107 E.01606
G1 X176.693 Y195.001 E.41906
G1 X177.229 Y195.001 E.01606
G1 X166.799 Y184.571 E.44177
G1 X166.799 Y184.035 E.01606
G1 X177.765 Y195.001 E.46448
G1 X178.301 Y195.001 E.01606
G1 X166.799 Y183.499 E.4872
G1 X166.799 Y182.963 E.01606
G1 X178.837 Y195.001 E.50991
G1 X179.374 Y195.001 E.01606
G1 X166.799 Y182.426 E.53263
G1 X166.799 Y181.89 E.01606
G1 X179.91 Y195.001 E.55534
G1 X180.446 Y195.001 E.01606
G1 X166.799 Y181.354 E.57805
G1 X166.799 Y180.818 E.01606
G1 X180.982 Y195.001 E.60077
G1 X181.519 Y195.001 E.01606
G1 X166.799 Y180.281 E.62348
G1 X166.799 Y179.745 E.01606
G1 X187.956 Y200.902 E.89616
G1 X188.151 Y200.867 E.00592
G1 X188.151 Y200.56 E.0092
G1 X166.799 Y179.209 E.9044
G1 X166.799 Y178.673 E.01606
G1 X188.151 Y200.024 E.9044
G1 X188.151 Y199.488 E.01606
G1 X166.799 Y178.136 E.9044
G1 X166.799 Y177.6 E.01606
G1 X188.151 Y198.952 E.9044
G1 X188.151 Y198.415 E.01606
G1 X161.249 Y171.514 E1.13949
G1 X161.249 Y170.978 E.01606
G1 X188.151 Y197.879 E1.13949
G1 X188.151 Y197.343 E.01606
G1 X161.249 Y170.442 E1.13949
G1 X161.249 Y169.905 E.01606
G1 X188.151 Y196.807 E1.13949
G1 X188.151 Y196.27 E.01606
G1 X161.249 Y169.369 E1.13949
G1 X161.249 Y168.899 E.01407
G1 X161.316 Y168.899 E.00199
G1 X188.151 Y195.734 E1.13667
G1 X188.151 Y195.198 E.01606
G1 X161.852 Y168.899 E1.11396
G1 X162.388 Y168.899 E.01606
G1 X188.151 Y194.662 E1.09124
G1 X188.151 Y194.125 E.01606
G1 X162.925 Y168.899 E1.06853
G1 X163.461 Y168.899 E.01606
M73 P47 R11
G1 X188.151 Y193.589 E1.04582
G1 X188.151 Y193.053 E.01606
G1 X163.997 Y168.899 E1.0231
G1 X164.533 Y168.899 E.01606
G1 X188.151 Y192.517 E1.00039
G1 X188.151 Y191.981 E.01606
G1 X165.069 Y168.899 E.97768
G1 X165.606 Y168.899 E.01606
G1 X188.151 Y191.444 E.95496
G1 X188.151 Y190.908 E.01606
G1 X166.142 Y168.899 E.93225
G1 X166.678 Y168.899 E.01606
G1 X188.32 Y190.542 E.91672
; WIPE_START
G1 X186.906 Y189.127 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X186.729 Y196.758 Z1 F60000
G1 X186.651 Y200.133 Z1
G1 Z.6
G1 E.8 F1800
G1 F9494.421
M204 S8000
G1 X181.974 Y195.456 E.19808
G1 X181.974 Y195.993 E.01606
G1 X185.597 Y199.616 E.15346
G1 X185.058 Y199.613 E.01614
G1 X181.974 Y196.529 E.13063
G1 X181.974 Y197.065 E.01606
G1 X184.603 Y199.694 E.11135
G2 X184.201 Y199.828 I.143 J1.099 E.01277
G1 X181.974 Y197.601 E.09432
G1 X181.974 Y198.138 E.01606
G1 X183.836 Y199.999 E.07885
G2 X183.516 Y200.215 I.936 J1.732 E.01159
G1 X181.974 Y198.674 E.06529
G1 X181.974 Y199.21 E.01606
G1 X183.231 Y200.467 E.05324
G2 X182.985 Y200.757 I1.251 J1.314 E.01141
G1 X181.974 Y199.746 E.0428
G1 X181.974 Y200.282 E.01606
G1 X182.773 Y201.081 E.03383
G2 X182.606 Y201.451 I1.23 J.777 E.01218
G1 X181.974 Y200.819 E.02677
G1 X181.974 Y201.355 E.01606
G1 X182.481 Y201.862 E.02147
G2 X182.407 Y202.324 I1.539 J.483 E.01408
G1 X181.974 Y201.891 E.01834
G1 X181.974 Y202.427 E.01606
G1 X182.427 Y202.88 E.01917
G2 X182.641 Y203.63 I2.535 J-.318 E.02346
G1 X181.974 Y202.964 E.02824
G1 X181.974 Y203.5 E.01606
G1 X186.725 Y208.251 E.20124
G1 X187.261 Y208.251 E.01606
G1 X184.173 Y205.162 E.13081
G2 X184.921 Y205.374 I1.083 J-2.405 E.02334
G1 X187.798 Y208.251 E.12187
G1 X188.151 Y208.251 E.01057
G1 X188.151 Y208.067 E.00549
G1 X185.473 Y205.39 E.11342
G2 X185.945 Y205.326 I-.105 J-2.546 E.01429
G1 X188.151 Y207.531 E.09342
G1 X188.151 Y206.995 E.01606
G1 X186.355 Y205.2 E.07605
G2 X186.719 Y205.027 I-1.092 J-2.77 E.01206
G1 X188.151 Y206.459 E.06064
G1 X188.151 Y205.922 E.01606
G1 X187.04 Y204.812 E.04702
G2 X187.333 Y204.569 I-.69 J-1.126 E.01144
G1 X188.151 Y205.386 E.03463
G1 X188.151 Y204.85 E.01606
G1 X187.584 Y204.284 E.02398
G2 X187.743 Y204.061 I-1.002 J-.879 E.00821
G1 X187.93 Y204.093 E.0057
G1 X188.32 Y204.483 E.01652
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
G1 X186.359 Y208.42 Z1 F60000
G1 Z.6
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42209
G1 F9494.421
M204 S8000
G1 X181.974 Y204.036 E.18571
G1 X181.974 Y204.572 E.01606
G1 X185.653 Y208.251 E.15581
G1 X185.117 Y208.251 E.01606
G1 X181.974 Y205.109 E.1331
G1 X181.974 Y205.645 E.01606
G1 X184.58 Y208.251 E.11038
G1 X184.044 Y208.251 E.01606
G1 X181.974 Y206.181 E.08767
G1 X181.974 Y206.717 E.01606
G1 X183.508 Y208.251 E.06495
G1 X182.972 Y208.251 E.01606
G1 X181.974 Y207.253 E.04224
G1 X181.974 Y207.79 E.01606
G1 X182.605 Y208.42 E.02671
; WIPE_START
G1 X181.974 Y207.79 E-.33893
G1 X181.974 Y207.253 E-.20377
G1 X182.379 Y207.658 E-.2173
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X180.096 Y200.375 Z1 F60000
G1 X162.037 Y142.75 Z1
G1 Z.6
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.33758
G1 F12217.47
M204 S8000
G1 X166.263 Y142.75 E.09834
; WIPE_START
G1 X164.263 Y142.75 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X167.457 Y135.818 Z1 F60000
G1 X170.14 Y129.999 Z1
G1 Z.6
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42209
G1 F9494.421
M204 S8000
G1 X176.941 Y136.801 E.28811
G1 X176.405 Y136.801 E.01606
G1 X170.309 Y130.705 E.2582
G1 X170.309 Y131.241 E.01606
G1 X175.869 Y136.801 E.23549
G1 X175.551 Y136.801 E.00953
G1 X175.551 Y137.019 E.00653
G1 X170.309 Y131.777 E.22201
G1 X170.309 Y132.314 E.01606
G1 X175.551 Y137.555 E.22201
G1 X175.551 Y138.091 E.01606
G1 X170.309 Y132.85 E.22201
G1 X170.309 Y133.259 E.01227
G1 X170.183 Y133.259 E.00379
G1 X175.551 Y138.627 E.22738
G1 X175.551 Y139.164 E.01606
G1 X169.646 Y133.259 E.25009
G1 X169.11 Y133.259 E.01606
G1 X175.551 Y139.7 E.2728
G1 X175.551 Y140.236 E.01606
G1 X168.574 Y133.259 E.29552
G1 X168.038 Y133.259 E.01606
G1 X175.551 Y140.772 E.31823
G1 X175.551 Y141.308 E.01606
G1 X167.699 Y133.457 E.33257
G1 X167.699 Y133.993 E.01606
G1 X175.551 Y141.845 E.33257
G1 X175.551 Y142.381 E.01606
G1 X167.699 Y134.53 E.33257
G1 X167.699 Y135.066 E.01606
G1 X181.326 Y148.692 E.57718
G1 X181.326 Y148.156 E.01606
G1 X176.419 Y143.249 E.20783
G1 X176.955 Y143.249 E.01606
G1 X181.326 Y147.62 E.18512
G1 X181.326 Y147.083 E.01606
G1 X177.492 Y143.249 E.1624
G1 X178.028 Y143.249 E.01606
G1 X181.326 Y146.547 E.13969
G1 X181.326 Y146.166 E.01143
G1 X181.48 Y146.166 E.00463
G1 X178.564 Y143.249 E.12353
G1 X179.1 Y143.249 E.01606
G1 X182.017 Y146.166 E.12353
G1 X182.553 Y146.166 E.01606
G1 X179.636 Y143.249 E.12353
G1 X180.173 Y143.249 E.01606
G1 X183.089 Y146.166 E.12353
G1 X183.625 Y146.166 E.01606
G1 X180.709 Y143.249 E.12353
G1 X181.245 Y143.249 E.01606
G1 X184.161 Y146.166 E.12353
G1 X184.698 Y146.166 E.01606
G1 X181.781 Y143.249 E.12353
G1 X182.318 Y143.249 E.01606
G1 X185.234 Y146.166 E.12353
G1 X185.77 Y146.166 E.01606
G1 X182.854 Y143.249 E.12353
G1 X183.39 Y143.249 E.01606
G1 X186.306 Y146.166 E.12353
G1 X186.843 Y146.166 E.01606
G1 X183.926 Y143.249 E.12353
G1 X184.463 Y143.249 E.01606
G1 X187.379 Y146.166 E.12353
G1 X187.915 Y146.166 E.01606
G1 X184.999 Y143.249 E.12353
G1 X185.535 Y143.249 E.01606
G1 X188.151 Y145.865 E.1108
G1 X188.151 Y145.329 E.01606
G1 X186.071 Y143.249 E.08808
G1 X186.607 Y143.249 E.01606
G1 X188.151 Y144.793 E.06537
G1 X188.151 Y144.256 E.01606
G1 X187.144 Y143.249 E.04265
G1 X187.68 Y143.249 E.01606
G1 X188.32 Y143.89 E.02713
; WIPE_START
G1 X187.68 Y143.249 E-.34418
G1 X187.144 Y143.249 E-.20377
G1 X187.538 Y143.644 E-.21206
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
G1 X187.961 Y182.675 Z1 F60000
G1 Z.6
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42209
G1 F9494.421
M204 S8000
G1 X188.151 Y182.865 E.00805
G1 X188.151 Y183.401 E.01606
G1 X187.594 Y182.844 E.02358
G1 X187.058 Y182.844 E.01606
G1 X188.151 Y183.937 E.04629
G1 X188.151 Y184.473 E.01606
G1 X186.522 Y182.844 E.069
G1 X185.985 Y182.844 E.01606
G1 X188.151 Y185.01 E.09172
G1 X188.151 Y185.546 E.01606
G1 X185.449 Y182.844 E.11443
G1 X184.913 Y182.844 E.01606
G1 X188.151 Y186.082 E.13714
G1 X188.151 Y186.618 E.01606
G1 X184.377 Y182.844 E.15986
G1 X183.84 Y182.844 E.01606
G1 X188.151 Y187.155 E.18257
G1 X188.151 Y187.691 E.01606
G1 X183.304 Y182.844 E.20528
G1 X182.768 Y182.844 E.01606
G1 X188.151 Y188.227 E.228
G1 X188.151 Y188.763 E.01606
G1 X182.232 Y182.844 E.25071
G1 X181.696 Y182.844 E.01606
G1 X188.151 Y189.299 E.27342
G1 X188.151 Y189.836 E.01606
G1 X167.214 Y168.899 E.88682
G1 X167.751 Y168.899 E.01606
G1 X181.326 Y182.474 E.57501
G1 X181.326 Y181.938 E.01606
G1 X168.287 Y168.899 E.5523
G1 X168.823 Y168.899 E.01606
G1 X181.326 Y181.402 E.52959
G1 X181.326 Y180.866 E.01606
M73 P47 R10
G1 X169.359 Y168.899 E.50687
G1 X169.895 Y168.899 E.01606
G1 X181.326 Y180.33 E.48416
G1 X181.326 Y179.793 E.01606
G1 X170.432 Y168.899 E.46145
G1 X170.968 Y168.899 E.01606
G1 X181.326 Y179.257 E.43873
G1 X181.326 Y178.721 E.01606
G1 X171.064 Y168.46 E.43465
G1 X171.064 Y167.923 E.01606
G1 X181.326 Y178.185 E.43465
G1 X181.326 Y177.648 E.01606
G1 X171.064 Y167.387 E.43465
G1 X171.064 Y166.851 E.01606
G1 X181.326 Y177.112 E.43465
G1 X181.326 Y176.576 E.01606
G1 X171.064 Y166.315 E.43465
G1 X171.064 Y165.778 E.01606
G1 X181.326 Y176.04 E.43465
G1 X181.326 Y175.503 E.01606
G1 X171.064 Y165.242 E.43465
G1 X171.064 Y164.706 E.01606
G1 X181.326 Y174.967 E.43465
G1 X181.326 Y174.431 E.01606
G1 X171.064 Y164.17 E.43465
G1 X171.064 Y163.634 E.01606
G1 X181.326 Y173.895 E.43465
G1 X181.326 Y173.359 E.01606
G1 X171.064 Y163.097 E.43465
G1 X171.064 Y162.561 E.01606
G1 X181.326 Y172.822 E.43465
G1 X181.326 Y172.286 E.01606
G1 X171.064 Y162.025 E.43465
G1 X171.064 Y161.489 E.01606
G1 X181.326 Y171.75 E.43465
G1 X181.326 Y171.214 E.01606
G1 X171.064 Y160.952 E.43465
G1 X171.064 Y160.416 E.01606
G1 X181.326 Y170.677 E.43465
G1 X181.326 Y170.141 E.01606
G1 X171.064 Y159.88 E.43465
G1 X171.064 Y159.344 E.01606
G1 X181.495 Y169.775 E.44184
; WIPE_START
G1 X180.081 Y168.36 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X180.903 Y160.772 Z1 F60000
G1 X181.495 Y155.297 Z1
G1 Z.6
G1 E.8 F1800
G1 F9494.421
M204 S8000
G1 X176.709 Y150.511 E.20272
G1 X176.709 Y151.047 E.01606
G1 X181.326 Y155.663 E.19554
G1 X181.326 Y156.199 E.01606
G1 X176.709 Y151.583 E.19554
G1 X176.709 Y152.119 E.01606
G1 X181.326 Y156.736 E.19554
G1 X181.326 Y157.272 E.01606
G1 X176.709 Y152.655 E.19554
G1 X176.709 Y153.192 E.01606
G1 X181.326 Y157.808 E.19554
G1 X181.326 Y158.344 E.01606
M73 P48 R10
G1 X176.709 Y153.728 E.19554
G1 X176.709 Y154.264 E.01606
G1 X181.326 Y158.88 E.19554
G1 X181.326 Y159.417 E.01606
G1 X176.709 Y154.8 E.19554
G1 X176.709 Y155.337 E.01606
G1 X181.326 Y159.953 E.19554
G1 X181.326 Y160.489 E.01606
G1 X176.709 Y155.873 E.19554
G1 X176.709 Y155.964 E.00274
G1 X176.265 Y155.964 E.01332
G1 X181.326 Y161.025 E.21437
G1 X181.326 Y161.562 E.01606
G1 X175.728 Y155.964 E.23709
G1 X175.192 Y155.964 E.01606
G1 X181.326 Y162.098 E.2598
G1 X181.326 Y162.634 E.01606
G1 X174.656 Y155.964 E.28251
G1 X174.12 Y155.964 E.01606
G1 X181.326 Y163.17 E.30523
G1 X181.326 Y163.706 E.01606
G1 X173.584 Y155.964 E.32794
G1 X173.047 Y155.964 E.01606
G1 X181.326 Y164.243 E.35066
G1 X181.326 Y164.779 E.01606
G1 X172.511 Y155.964 E.37337
G1 X171.975 Y155.964 E.01606
G1 X181.326 Y165.315 E.39608
G1 X181.326 Y165.851 E.01606
G1 X171.439 Y155.964 E.4188
G1 X170.902 Y155.964 E.01606
G1 X181.326 Y166.388 E.44151
G1 X181.326 Y166.924 E.01606
G1 X170.366 Y155.964 E.46422
G1 X169.83 Y155.964 E.01606
G1 X181.326 Y167.46 E.48694
G1 X181.326 Y167.996 E.01606
G1 X169.294 Y155.964 E.50965
G1 X168.757 Y155.964 E.01606
G1 X181.326 Y168.533 E.53236
G1 X181.326 Y169.069 E.01606
G1 X168.221 Y155.964 E.55508
G1 X167.685 Y155.964 E.01606
G1 X170.621 Y158.901 E.12438
G1 X170.085 Y158.901 E.01606
G1 X167.149 Y155.964 E.12438
G1 X166.613 Y155.964 E.01606
G1 X169.549 Y158.901 E.12438
G1 X169.013 Y158.901 E.01606
G1 X166.076 Y155.964 E.12438
G1 X165.691 Y155.964 E.01155
G1 X165.691 Y155.579 E.01155
G1 X163.751 Y153.639 E.08214
G1 X164.288 Y153.639 E.01606
G1 X165.691 Y155.042 E.05943
G1 X165.691 Y154.506 E.01606
G1 X164.824 Y153.639 E.03672
G1 X165.36 Y153.639 E.01606
G1 X165.86 Y154.14 E.02119
; WIPE_START
G1 X165.36 Y153.639 E-.26886
G1 X164.824 Y153.639 E-.20377
G1 X165.359 Y154.174 E-.28738
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X166.63 Y149.547 Z1 F60000
G1 Z.6
G1 E.8 F1800
G1 F9494.421
M204 S8000
G1 X167.109 Y150.026 E.02028
G1 X167.645 Y150.026 E.01606
G1 X166.799 Y149.18 E.03581
G1 X166.799 Y148.644 E.01606
G1 X168.181 Y150.026 E.05852
G1 X168.717 Y150.026 E.01606
G1 X166.799 Y148.108 E.08124
G1 X166.799 Y147.572 E.01606
G1 X169.253 Y150.026 E.10395
G1 X169.79 Y150.026 E.01606
G1 X166.799 Y147.035 E.12667
G1 X166.799 Y146.499 E.01606
G1 X170.326 Y150.026 E.14938
G1 X170.862 Y150.026 E.01606
G1 X166.799 Y145.963 E.17209
G1 X166.799 Y145.427 E.01606
G1 X171.398 Y150.026 E.19481
G1 X171.935 Y150.026 E.01606
G1 X166.799 Y144.89 E.21752
G1 X166.799 Y144.354 E.01606
G1 X172.471 Y150.026 E.24023
G1 X173.007 Y150.026 E.01606
G1 X166.799 Y143.818 E.26295
G1 X166.799 Y143.282 E.01606
G1 X173.543 Y150.026 E.28566
G1 X174.08 Y150.026 E.01606
G1 X167.193 Y143.139 E.29169
G1 X167.699 Y143.139 E.01516
G1 X167.699 Y143.109 E.0009
G1 X174.616 Y150.026 E.29296
G1 X175.152 Y150.026 E.01606
G1 X167.699 Y142.573 E.31568
G1 X167.699 Y142.037 E.01606
G1 X175.688 Y150.026 E.33839
G1 X176.224 Y150.026 E.01606
G1 X167.699 Y141.501 E.36111
G1 X167.699 Y140.964 E.01606
G1 X181.326 Y154.591 E.57718
G1 X181.326 Y154.054 E.01606
G1 X167.699 Y140.428 E.57718
G1 X167.699 Y139.892 E.01606
G1 X181.326 Y153.518 E.57718
G1 X181.326 Y152.982 E.01606
G1 X167.699 Y139.356 E.57718
G1 X167.699 Y138.819 E.01606
G1 X181.326 Y152.446 E.57718
G1 X181.326 Y151.909 E.01606
G1 X167.699 Y138.283 E.57718
G1 X167.699 Y137.747 E.01606
G1 X181.326 Y151.373 E.57718
G1 X181.326 Y150.837 E.01606
G1 X167.699 Y137.211 E.57718
G1 X167.699 Y136.675 E.01606
G1 X181.326 Y150.301 E.57718
G1 X181.326 Y149.765 E.01606
G1 X167.699 Y136.138 E.57718
G1 X167.699 Y135.602 E.01606
G1 X181.495 Y149.398 E.58437
; WIPE_START
G1 X180.081 Y147.984 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X184.368 Y141.669 Z1 F60000
G1 X188.32 Y135.846 Z1
G1 Z.6
G1 E.8 F1800
G1 F9494.421
M204 S8000
G1 X187.723 Y135.249 E.02529
G1 X187.187 Y135.249 E.01606
G1 X188.151 Y136.213 E.04082
G1 X188.151 Y136.749 E.01606
G1 X186.651 Y135.249 E.06353
G1 X186.115 Y135.249 E.01606
G1 X187.666 Y136.801 E.06571
G1 X187.13 Y136.801 E.01606
G1 X185.578 Y135.249 E.06571
G1 X185.042 Y135.249 E.01606
G1 X186.593 Y136.801 E.06571
G1 X186.057 Y136.801 E.01606
G1 X184.506 Y135.249 E.06571
G1 X183.97 Y135.249 E.01606
G1 X185.521 Y136.801 E.06571
G1 X184.985 Y136.801 E.01606
G1 X183.433 Y135.249 E.06571
G1 X182.897 Y135.249 E.01606
G1 X184.449 Y136.801 E.06571
G1 X183.912 Y136.801 E.01606
G1 X182.361 Y135.249 E.06571
G1 X181.825 Y135.249 E.01606
G1 X183.376 Y136.801 E.06571
G1 X182.84 Y136.801 E.01606
G1 X181.289 Y135.249 E.06571
G1 X180.752 Y135.249 E.01606
G1 X182.304 Y136.801 E.06571
G1 X181.767 Y136.801 E.01606
G1 X180.216 Y135.249 E.06571
G1 X179.68 Y135.249 E.01606
G1 X181.231 Y136.801 E.06571
G1 X180.695 Y136.801 E.01606
G1 X179.144 Y135.249 E.06571
G1 X178.607 Y135.249 E.01606
G1 X180.159 Y136.801 E.06571
G1 X179.622 Y136.801 E.01606
G1 X178.071 Y135.249 E.06571
G1 X177.535 Y135.249 E.01606
G1 X179.086 Y136.801 E.06571
G1 X178.55 Y136.801 E.01606
G1 X176.999 Y135.249 E.06571
G1 X176.463 Y135.249 E.01606
G1 X178.014 Y136.801 E.06571
G1 X177.478 Y136.801 E.01606
G1 X175.926 Y135.249 E.06571
G1 X175.551 Y135.249 E.01125
G1 X175.551 Y134.874 E.01125
G1 X170.309 Y129.632 E.22201
G1 X170.309 Y129.249 E.01147
G1 X170.463 Y129.249 E.00459
G1 X175.551 Y134.337 E.21552
G1 X175.551 Y133.801 E.01606
G1 X170.999 Y129.249 E.19281
G1 X171.535 Y129.249 E.01606
G1 X175.551 Y133.265 E.1701
G1 X175.551 Y132.729 E.01606
G1 X172.071 Y129.249 E.14738
G1 X172.607 Y129.249 E.01606
G1 X175.551 Y132.193 E.12467
G1 X175.551 Y131.656 E.01606
G1 X173.144 Y129.249 E.10196
G1 X173.68 Y129.249 E.01606
G1 X175.551 Y131.12 E.07924
G1 X175.551 Y130.584 E.01606
G1 X174.216 Y129.249 E.05653
G1 X174.752 Y129.249 E.01606
G1 X175.551 Y130.048 E.03381
G1 X175.551 Y129.511 E.01606
G1 X175.119 Y129.08 E.01829
M204 S10000
G1 X176.087 Y129.025 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.66758
G1 F5763.136
M204 S8000
G1 X188.687 Y129.025 E.62173
; COOLING_NODE: 11
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
; COOLING_NODE: 11
; WIPE_START
G1 X164.884 Y121.234 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X162.011 Y117.016 Z1 F60000
G1 Z.6
G1 E.8 F1800
G1 F8843.478
M204 S8000
G1 X161.948 Y116.7 E.01038
G3 X163.872 Y114.352 I2.15 J-.201 E.10827
G1 X164.088 Y114.34 E.00695
G3 X162.033 Y117.129 I.01 J2.159 E.30693
G1 X162.022 Y117.075 E.00176
; COOLING_NODE: 11
M204 S10000
G1 X162.409 Y116.938 F60000
G1 F8843.478
M204 S8000
G1 X162.354 Y116.662 E.00907
G3 X163.916 Y114.757 I1.744 J-.163 E.08782
G1 X164.091 Y114.747 E.00565
G3 X162.423 Y117.011 I.008 J1.752 E.249
G1 X162.421 Y116.997 E.00045
; COOLING_NODE: 11
M204 S250
G1 X162.792 Y116.863 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X162.746 Y116.625 E.00723
G3 X163.957 Y115.147 I1.354 J-.126 E.06311
G1 X164.094 Y115.14 E.00407
G3 X162.807 Y116.921 I.006 J1.359 E.17822
; COOLING_NODE: 11
; WIPE_START
M204 S8000
G1 X162.746 Y116.625 E-.11496
G1 X162.747 Y116.359 E-.10113
G1 X162.793 Y116.124 E-.09079
G1 X162.889 Y115.881 E-.09924
G1 X163.043 Y115.644 E-.10737
G1 X163.227 Y115.457 E-.09983
G1 X163.456 Y115.302 E-.10509
G1 X163.557 Y115.26 E-.04159
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
; COOLING_NODE: 11
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
; COOLING_NODE: 10
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
M73 P49 R10
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
G1 X180.86 Y150.312 Z1.2 F60000
G1 X175.17 Y150.766 Z1.2
G1 Z.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X175.969 Y150.766 E.0257
G1 X175.969 Y155.224 E.14336
G1 X166.431 Y155.224 E.30672
G1 X166.431 Y150.766 E.14336
G1 X175.11 Y150.766 E.27909
; COOLING_NODE: 0
M204 S10000
G1 X175.17 Y151.173 F60000
G1 F8843.478
M204 S8000
G1 X175.562 Y151.173 E.01261
G1 X175.562 Y154.817 E.11718
G1 X166.838 Y154.817 E.28054
G1 X166.838 Y151.173 E.11718
G1 X175.11 Y151.173 E.266
; COOLING_NODE: 1
M204 S250
G1 X175.17 Y151.565 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X175.17 Y154.425 E.08519
G1 X167.23 Y154.425 E.23651
G1 X167.23 Y151.565 E.08519
G1 X175.11 Y151.565 E.23472
; COOLING_NODE: 1
; WIPE_START
M204 S8000
G1 X175.152 Y153.565 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X169.922 Y148.006 Z1.2 F60000
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
G1 X168.544 Y141.868 Z1.2 F60000
G1 X187.71 Y142.509 Z1.2
G1 Z.8
G1 E.8 F1800
G1 F8843.478
M204 S8000
G1 X176.291 Y142.509 E.3672
G1 X176.291 Y137.541 E.15976
G1 X188.509 Y137.541 E.3929
G1 X188.509 Y142.509 E.15976
G1 X187.77 Y142.509 E.02377
; COOLING_NODE: 2
M204 S10000
G1 X187.71 Y142.102 F60000
G1 F8843.478
M204 S8000
G1 X176.698 Y142.102 E.35411
G1 X176.698 Y137.948 E.13358
G1 X188.102 Y137.948 E.36672
G1 X188.102 Y142.102 E.13358
G1 X187.77 Y142.102 E.01068
; COOLING_NODE: 3
M204 S250
G1 X187.71 Y141.71 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X177.09 Y141.71 E.31633
G1 X177.09 Y138.34 E.10038
G1 X187.71 Y138.34 E.31633
G1 X187.71 Y141.65 E.09859
; COOLING_NODE: 3
; WIPE_START
M204 S8000
G1 X185.71 Y141.661 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X185.555 Y149.292 Z1.2 F60000
G1 X184.429 Y204.913 Z1.2
G1 Z.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X184.367 Y204.89 E.00211
G3 X185.026 Y199.947 I.931 J-2.391 E.21985
G1 X185.269 Y199.932 E.00783
G3 X184.597 Y204.967 I.029 J2.566 E.28302
G1 X184.486 Y204.931 E.00377
; COOLING_NODE: 3
M204 S10000
G1 X184.598 Y204.536 F60000
G1 F8843.478
M204 S8000
G1 X184.516 Y204.511 E.00275
G3 X185.07 Y200.352 I.783 J-2.012 E.18498
G1 X185.274 Y200.34 E.00656
G3 X184.925 Y204.625 I.025 J2.159 E.231
G1 X184.655 Y204.552 E.00897
; COOLING_NODE: 3
M204 S10000
G1 X184.707 Y204.145 F60000
G1 F8843.478
M204 S8000
G1 X184.664 Y204.131 E.00146
G3 X185.114 Y200.757 I.635 J-1.633 E.15011
G1 X185.278 Y200.747 E.00528
G3 X184.996 Y204.224 I.021 J1.752 E.18743
G1 X184.765 Y204.161 E.00768
; COOLING_NODE: 4
M204 S250
G1 X184.813 Y203.769 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X184.807 Y203.766 E.00019
G3 X185.157 Y201.147 I.492 J-1.267 E.10794
G1 X185.283 Y201.14 E.00376
G3 X185.064 Y203.838 I.017 J1.359 E.13475
G1 X184.871 Y203.785 E.00597
; COOLING_NODE: 4
; WIPE_START
M204 S8000
G1 X184.807 Y203.766 E-.0252
G1 X184.56 Y203.641 E-.10534
G1 X184.355 Y203.478 E-.09946
G1 X184.185 Y203.279 E-.09932
G1 X184.057 Y203.052 E-.09906
G1 X183.973 Y202.8 E-.10119
G1 X183.94 Y202.525 E-.10519
G1 X183.96 Y202.265 E-.09901
G1 X183.979 Y202.199 E-.02622
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X184.401 Y194.578 Z1.2 F60000
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
G1 X181.641 Y195.334 E.42607
G1 X160.916 Y195.334 E.66644
G1 X160.916 Y193.531 E.05796
G1 X166.466 Y193.531 E.17847
G1 X166.466 Y177.459 E.51683
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
; COOLING_NODE: 4
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
; COOLING_NODE: 4
M204 S10000
G1 X187.71 Y129.948 F60000
G1 F8843.478
M204 S8000
G1 X188.102 Y129.948 E.01261
G1 X188.102 Y134.102 E.13358
G1 X176.698 Y134.102 E.36672
G1 X176.698 Y129.948 E.13358
G1 X187.65 Y129.948 E.35218
; COOLING_NODE: 5
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
; COOLING_NODE: 5
; WIPE_START
M204 S8000
G1 X187.686 Y132.34 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X183.222 Y138.531 Z1.2 F60000
G1 X161.864 Y168.159 Z1.2
G1 Z.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X161.065 Y168.159 E.0257
G1 X161.065 Y159.641 E.27392
G1 X170.324 Y159.641 E.29774
G1 X170.324 Y168.159 E.27392
G1 X161.924 Y168.159 E.27012
; COOLING_NODE: 5
M204 S10000
G1 X161.864 Y167.752 F60000
G1 F8843.478
M204 S8000
G1 X161.472 Y167.752 E.01261
G1 X161.472 Y160.048 E.24774
G1 X169.917 Y160.048 E.27156
G1 X169.917 Y167.752 E.24774
G1 X161.924 Y167.752 E.25703
; COOLING_NODE: 6
M204 S250
G1 X161.864 Y167.36 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X161.864 Y160.44 E.20612
G1 X169.525 Y160.44 E.22819
G1 X169.525 Y167.36 E.20612
G1 X161.924 Y167.36 E.22641
; COOLING_NODE: 6
; WIPE_START
M204 S8000
G1 X161.907 Y165.36 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X163.539 Y172.816 Z1.2 F60000
G1 X166.059 Y184.325 Z1.2
G1 Z.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
M73 P50 R10
G1 F8843.478
M204 S8000
G1 X166.059 Y185.124 E.0257
G1 X161.341 Y185.124 E.15172
G1 X161.341 Y177.866 E.2334
G1 X166.059 Y177.866 E.15172
G1 X166.059 Y184.265 E.20577
; COOLING_NODE: 6
M204 S10000
G1 X165.652 Y184.325 F60000
G1 F8843.478
M204 S8000
G1 X165.652 Y184.717 E.01261
G1 X161.748 Y184.717 E.12554
G1 X161.748 Y178.273 E.20722
G1 X165.652 Y178.273 E.12554
G1 X165.652 Y184.265 E.19268
; COOLING_NODE: 7
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
; COOLING_NODE: 7
; WIPE_START
M204 S8000
G1 X163.26 Y184.303 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X165.775 Y191.51 Z1.2 F60000
G1 X166.059 Y192.325 Z1.2
G1 Z.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X166.059 Y193.124 E.0257
G1 X161.341 Y193.124 E.15172
G1 X161.341 Y185.866 E.2334
G1 X166.059 Y185.866 E.15172
G1 X166.059 Y192.265 E.20577
; COOLING_NODE: 7
M204 S10000
G1 X165.652 Y192.325 F60000
G1 F8843.478
M204 S8000
G1 X165.652 Y192.717 E.01261
G1 X161.748 Y192.717 E.12554
G1 X161.748 Y186.273 E.20722
G1 X165.652 Y186.273 E.12554
G1 X165.652 Y192.265 E.19268
; COOLING_NODE: 8
M204 S250
G1 X165.26 Y192.325 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X162.14 Y192.325 E.09293
G1 X162.14 Y186.665 E.16859
G1 X165.26 Y186.665 E.09293
G1 X165.26 Y192.265 E.1668
; COOLING_NODE: 8
; WIPE_START
M204 S8000
G1 X163.26 Y192.303 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X166.972 Y185.634 Z1.2 F60000
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
G1 X181.234 Y195.741 E.42607
G1 X160.509 Y195.741 E.66644
G1 X160.509 Y132.519 E2.03298
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
G1 X167.726 Y134.83 Z1.2 F60000
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
G1 X180.827 Y196.148 E.42607
G1 X160.102 Y196.148 E.66644
G1 X160.102 Y132.112 E2.05916
G1 X169.102 Y132.112 E.28941
; COOLING_NODE: 10
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
G1 X180.435 Y196.54 E.39467
G1 X159.71 Y196.54 E.61733
G1 X159.71 Y131.72 E1.93077
G1 X168.71 Y131.72 E.26808
; WIPE_START
G1 F9547.055
M204 S8000
G1 X168.74 Y129.72 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
M73 P51 R10
G1 X167.959 Y133.09 Z1.2 F60000
G1 Z.8
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42003
G1 F9546.286
M204 S8000
G1 X167.699 Y133.349 E.01093
G1 X167.699 Y133.882 E.01589
G1 X168.322 Y133.259 E.02625
G1 X168.856 Y133.259 E.01589
G1 X167.699 Y134.416 E.04871
G1 X167.699 Y134.949 E.01589
G1 X169.389 Y133.259 E.07118
G1 X169.922 Y133.259 E.01589
G1 X167.53 Y135.652 E.1008
; WIPE_START
G1 X168.944 Y134.238 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X166.755 Y132.56 Z1.2 F60000
G1 Z.8
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
G1 X161.375 Y133.13 Z1.2 F60000
G1 Z.8
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
M204 S10000
G1 X161.445 Y153.47 F60000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42003
G1 F9546.286
M204 S8000
G1 X161.249 Y153.665 E.00824
G1 X161.249 Y154.199 E.01589
G1 X161.809 Y153.639 E.02356
G1 X162.342 Y153.639 E.01589
G1 X161.249 Y154.732 E.04602
G1 X161.249 Y155.265 E.01589
G1 X162.875 Y153.639 E.06849
G1 X163.408 Y153.639 E.01589
G1 X161.249 Y155.798 E.09096
G1 X161.249 Y156.332 E.01589
G1 X163.942 Y153.639 E.11343
G1 X164.475 Y153.639 E.01589
G1 X161.249 Y156.865 E.13589
G1 X161.249 Y157.398 E.01589
G1 X165.008 Y153.639 E.15836
G1 X165.542 Y153.639 E.01589
G1 X161.249 Y157.932 E.18083
G1 X161.249 Y158.465 E.01589
G1 X165.691 Y154.024 E.1871
G1 X165.691 Y154.557 E.01589
G1 X161.347 Y158.901 E.18299
G1 X161.88 Y158.901 E.01589
G1 X165.691 Y155.09 E.16052
G1 X165.691 Y155.624 E.01589
G1 X162.414 Y158.901 E.13805
G1 X162.947 Y158.901 E.01589
G1 X165.883 Y155.964 E.1237
G1 X166.417 Y155.964 E.01589
G1 X163.48 Y158.901 E.1237
G1 X164.014 Y158.901 E.01589
G1 X166.95 Y155.964 E.1237
G1 X167.483 Y155.964 E.01589
G1 X164.547 Y158.901 E.1237
G1 X165.08 Y158.901 E.01589
G1 X168.017 Y155.964 E.1237
G1 X168.55 Y155.964 E.01589
G1 X165.614 Y158.901 E.1237
G1 X166.147 Y158.901 E.01589
G1 X169.083 Y155.964 E.1237
G1 X169.616 Y155.964 E.01589
G1 X166.68 Y158.901 E.1237
G1 X167.214 Y158.901 E.01589
G1 X170.15 Y155.964 E.1237
G1 X170.683 Y155.964 E.01589
G1 X167.747 Y158.901 E.1237
G1 X168.28 Y158.901 E.01589
G1 X171.216 Y155.964 E.1237
G1 X171.75 Y155.964 E.01589
G1 X168.813 Y158.901 E.1237
G1 X169.347 Y158.901 E.01589
G1 X172.283 Y155.964 E.1237
G1 X172.816 Y155.964 E.01589
G1 X169.88 Y158.901 E.1237
G1 X170.413 Y158.901 E.01589
G1 X173.35 Y155.964 E.1237
G1 X173.883 Y155.964 E.01589
G1 X170.947 Y158.901 E.1237
G1 X171.064 Y158.901 E.0035
G1 X171.064 Y159.316 E.01238
G1 X174.416 Y155.964 E.14121
G1 X174.95 Y155.964 E.01589
G1 X171.064 Y159.85 E.16368
G1 X171.064 Y160.383 E.01589
G1 X175.483 Y155.964 E.18615
G1 X176.016 Y155.964 E.01589
G1 X171.064 Y160.916 E.20861
G1 X171.064 Y161.45 E.01589
G1 X181.326 Y151.188 E.43229
G1 X181.326 Y151.722 E.01589
G1 X171.064 Y161.983 E.43229
G1 X171.064 Y162.516 E.01589
G1 X181.326 Y152.255 E.43229
G1 X181.326 Y152.788 E.01589
G1 X171.064 Y163.05 E.43229
G1 X171.064 Y163.583 E.01589
G1 X181.326 Y153.322 E.43229
G1 X181.326 Y153.855 E.01589
G1 X171.064 Y164.116 E.43229
G1 X171.064 Y164.649 E.01589
G1 X181.326 Y154.388 E.43229
G1 X181.326 Y154.921 E.01589
G1 X171.064 Y165.183 E.43229
G1 X171.064 Y165.716 E.01589
G1 X181.326 Y155.455 E.43229
G1 X181.326 Y155.988 E.01589
G1 X171.064 Y166.249 E.43229
G1 X171.064 Y166.783 E.01589
G1 X181.326 Y156.521 E.43229
G1 X181.326 Y157.055 E.01589
G1 X171.064 Y167.316 E.43229
G1 X171.064 Y167.849 E.01589
G1 X181.326 Y157.588 E.43229
G1 X181.326 Y158.121 E.01589
G1 X170.895 Y168.552 E.43944
; WIPE_START
G1 X172.309 Y167.138 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X166.704 Y172.319 Z1.2 F60000
G1 X160.925 Y177.662 Z1.2
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
G1 X166.263 Y185.495 Z1.2 F60000
G1 Z.8
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
G1 X160.925 Y193.328 E.25713
; WIPE_START
G1 X160.925 Y191.328 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X161.08 Y194.367 Z1.2 F60000
G1 Z.8
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42003
G1 F9546.286
M204 S8000
G1 X161.582 Y193.864 E.02116
G1 X162.115 Y193.864 E.01589
G1 X161.249 Y194.73 E.03648
G1 X161.249 Y195.001 E.00805
G1 X161.512 Y195.001 E.00784
G1 X162.649 Y193.864 E.04787
G1 X163.182 Y193.864 E.01589
G1 X162.046 Y195.001 E.04787
G1 X162.579 Y195.001 E.01589
G1 X163.715 Y193.864 E.04787
G1 X164.249 Y193.864 E.01589
G1 X163.112 Y195.001 E.04787
G1 X163.646 Y195.001 E.01589
G1 X164.782 Y193.864 E.04787
G1 X165.315 Y193.864 E.01589
G1 X164.179 Y195.001 E.04787
G1 X164.712 Y195.001 E.01589
G1 X165.849 Y193.864 E.04787
G1 X166.382 Y193.864 E.01589
G1 X165.076 Y195.17 E.05502
; WIPE_START
G1 X166.382 Y193.864 E-.70182
G1 X166.229 Y193.864 E-.05818
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X173.166 Y197.047 Z1.2 F60000
G1 X182.786 Y201.46 Z1.2
G1 Z.8
G1 E.8 F1800
G1 F9546.286
M204 S8000
G1 X181.974 Y202.271 E.03418
G1 X181.974 Y202.804 E.01589
G1 X182.407 Y202.372 E.01823
G1 X182.426 Y202.886 E.01533
G1 X181.974 Y203.338 E.01903
G1 X181.974 Y203.871 E.01589
G1 X182.523 Y203.322 E.02312
G1 X182.541 Y203.401 E.00241
G1 X182.674 Y203.705 E.00988
G1 X181.974 Y204.404 E.02946
G1 X181.974 Y204.938 E.01589
G1 X182.86 Y204.052 E.03732
G1 X183.079 Y204.367 E.01142
G1 X181.974 Y205.471 E.04652
G1 X181.974 Y206.004 E.01589
G1 X183.341 Y204.637 E.05759
G2 X183.638 Y204.874 I1.383 J-1.423 E.01132
G1 X181.974 Y206.538 E.07007
G1 X181.974 Y207.071 E.01589
G1 X183.968 Y205.077 E.08399
G1 X184.348 Y205.23 E.01221
G1 X181.974 Y207.604 E.10001
G1 X181.974 Y208.137 E.01589
G1 X184.762 Y205.35 E.11744
G2 X185.247 Y205.398 I.583 J-3.411 E.01454
G1 X182.395 Y208.251 E.12018
G1 X182.928 Y208.251 E.01589
G1 X185.829 Y205.349 E.12223
G2 X186.647 Y205.064 I-.525 J-2.826 E.02591
G1 X183.461 Y208.251 E.13423
G1 X183.994 Y208.251 E.01589
G1 X188.035 Y204.211 E.1702
G1 X188.151 Y204.152 E.00388
G1 X188.151 Y204.628 E.01418
G1 X184.528 Y208.251 E.15262
G1 X185.061 Y208.251 E.01589
G1 X188.151 Y205.161 E.13016
G1 X188.151 Y205.694 E.01589
G1 X185.594 Y208.251 E.10769
G1 X186.128 Y208.251 E.01589
G1 X188.151 Y206.228 E.08522
G1 X188.151 Y206.761 E.01589
G1 X186.661 Y208.251 E.06275
G1 X187.194 Y208.251 E.01589
G1 X188.151 Y207.294 E.04029
G1 X188.151 Y207.828 E.01589
G1 X187.558 Y208.42 E.02497
; WIPE_START
G1 X188.151 Y207.828 E-.31849
G1 X188.151 Y207.294 E-.20266
G1 X187.706 Y207.739 E-.23885
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
M204 S10000
G1 X187.546 Y200.966 F60000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42003
G1 F9546.286
M204 S8000
G1 X188.151 Y200.361 E.02549
G1 X188.151 Y199.828 E.01589
G1 X187.433 Y200.545 E.03022
G1 X187.164 Y200.282 E.01123
G1 X188.151 Y199.295 E.04158
G1 X188.151 Y198.761 E.01589
G1 X186.858 Y200.054 E.05444
G2 X186.508 Y199.871 I-.797 J1.101 E.01182
G1 X188.151 Y198.228 E.06921
G1 X188.151 Y197.695 E.01589
G1 X186.126 Y199.719 E.0853
G1 X185.68 Y199.632 E.01353
G1 X188.151 Y197.161 E.10408
G1 X188.151 Y196.628 E.01589
G1 X185.167 Y199.612 E.12571
G2 X184.542 Y199.703 I.033 J2.418 E.01884
G1 X188.151 Y196.095 E.15201
G1 X188.151 Y195.561 E.01589
G1 X181.974 Y201.738 E.26019
G1 X181.974 Y201.204 E.01589
G1 X188.151 Y195.028 E.26019
G1 X188.151 Y194.495 E.01589
G1 X181.974 Y200.671 E.26019
G1 X181.974 Y200.138 E.01589
G1 X188.151 Y193.962 E.26019
G1 X188.151 Y193.428 E.01589
G1 X181.974 Y199.604 E.26019
G1 X181.974 Y199.071 E.01589
G1 X188.151 Y192.895 E.26019
G1 X188.151 Y192.362 E.01589
G1 X181.974 Y198.538 E.26019
G1 X181.974 Y198.005 E.01589
G1 X188.151 Y191.828 E.26019
G1 X188.151 Y191.295 E.01589
G1 X181.974 Y197.471 E.26019
G1 X181.974 Y196.938 E.01589
G1 X188.151 Y190.762 E.26019
G1 X188.151 Y190.228 E.01589
G1 X181.974 Y196.405 E.26019
G1 X181.974 Y195.871 E.01589
G1 X188.151 Y189.695 E.26019
G1 X188.151 Y189.162 E.01589
G1 X181.974 Y195.338 E.26019
G1 X181.974 Y195.001 E.01005
G1 X181.778 Y195.001 E.00584
G1 X188.151 Y188.628 E.26845
G1 X188.151 Y188.095 E.01589
G1 X181.245 Y195.001 E.29092
G1 X180.712 Y195.001 E.01589
G1 X188.151 Y187.562 E.31339
G1 X188.151 Y187.028 E.01589
G1 X180.178 Y195.001 E.33585
G1 X179.645 Y195.001 E.01589
G1 X188.151 Y186.495 E.35832
G1 X188.151 Y185.962 E.01589
G1 X179.112 Y195.001 E.38079
G1 X178.578 Y195.001 E.01589
G1 X188.151 Y185.428 E.40326
G1 X188.151 Y184.895 E.01589
G1 X178.045 Y195.001 E.42572
G1 X177.512 Y195.001 E.01589
G1 X188.151 Y184.362 E.44819
G1 X188.151 Y183.829 E.01589
G1 X176.979 Y195.001 E.47066
G1 X176.445 Y195.001 E.01589
G1 X188.151 Y183.295 E.49313
G1 X188.151 Y182.844 E.01343
G1 X188.068 Y182.844 E.00246
G1 X175.912 Y195.001 E.51212
G1 X175.379 Y195.001 E.01589
G1 X187.535 Y182.844 E.51212
G1 X187.002 Y182.844 E.01589
G1 X174.845 Y195.001 E.51212
G1 X174.312 Y195.001 E.01589
G1 X186.468 Y182.844 E.51212
G1 X185.935 Y182.844 E.01589
G1 X173.779 Y195.001 E.51212
G1 X173.245 Y195.001 E.01589
G1 X185.402 Y182.844 E.51212
G1 X184.868 Y182.844 E.01589
G1 X172.712 Y195.001 E.51212
G1 X172.179 Y195.001 E.01589
G1 X184.335 Y182.844 E.51212
G1 X183.802 Y182.844 E.01589
G1 X171.645 Y195.001 E.51212
G1 X171.112 Y195.001 E.01589
G1 X183.268 Y182.844 E.51212
G1 X182.735 Y182.844 E.01589
G1 X170.579 Y195.001 E.51212
G1 X170.045 Y195.001 E.01589
G1 X182.202 Y182.844 E.51212
G1 X181.668 Y182.844 E.01589
G1 X169.512 Y195.001 E.51212
G1 X168.979 Y195.001 E.01589
G1 X181.326 Y182.654 E.52015
G1 X181.326 Y182.121 E.01589
G1 X168.445 Y195.001 E.54261
G1 X167.912 Y195.001 E.01589
G1 X181.326 Y181.587 E.56508
G1 X181.326 Y181.054 E.01589
G1 X167.379 Y195.001 E.58755
G1 X166.846 Y195.001 E.01589
G1 X181.326 Y180.521 E.61002
G1 X181.326 Y179.987 E.01589
G1 X166.312 Y195.001 E.63248
G1 X165.779 Y195.001 E.01589
M73 P52 R10
G1 X181.326 Y179.454 E.65495
G1 X181.326 Y178.921 E.01589
G1 X166.799 Y193.447 E.61196
G1 X166.799 Y192.914 E.01589
G1 X181.326 Y178.387 E.61196
G1 X181.326 Y177.854 E.01589
G1 X166.799 Y192.38 E.61196
G1 X166.799 Y191.847 E.01589
G1 X181.326 Y177.321 E.61196
G1 X181.326 Y176.787 E.01589
G1 X166.799 Y191.314 E.61196
G1 X166.799 Y190.78 E.01589
G1 X181.326 Y176.254 E.61196
G1 X181.326 Y175.721 E.01589
G1 X166.799 Y190.247 E.61196
G1 X166.799 Y189.714 E.01589
G1 X181.326 Y175.187 E.61196
G1 X181.326 Y174.654 E.01589
G1 X166.799 Y189.18 E.61196
G1 X166.799 Y188.647 E.01589
G1 X181.326 Y174.121 E.61196
G1 X181.326 Y173.587 E.01589
G1 X166.799 Y188.114 E.61196
G1 X166.799 Y187.58 E.01589
G1 X181.326 Y173.054 E.61196
G1 X181.326 Y172.521 E.01589
G1 X166.799 Y187.047 E.61196
G1 X166.799 Y186.514 E.01589
G1 X181.326 Y171.988 E.61196
G1 X181.326 Y171.454 E.01589
G1 X166.799 Y185.981 E.61196
G1 X166.799 Y185.447 E.01589
G1 X181.326 Y170.921 E.61196
G1 X181.326 Y170.388 E.01589
G1 X166.799 Y184.914 E.61196
G1 X166.799 Y184.381 E.01589
G1 X181.326 Y169.854 E.61196
G1 X181.326 Y169.321 E.01589
G1 X166.799 Y183.847 E.61196
G1 X166.799 Y183.314 E.01589
G1 X181.326 Y168.788 E.61196
G1 X181.326 Y168.254 E.01589
G1 X166.799 Y182.781 E.61196
G1 X166.799 Y182.247 E.01589
G1 X181.326 Y167.721 E.61196
G1 X181.326 Y167.188 E.01589
G1 X166.799 Y181.714 E.61196
G1 X166.799 Y181.181 E.01589
G1 X181.326 Y166.654 E.61196
G1 X181.326 Y166.121 E.01589
G1 X166.799 Y180.647 E.61196
G1 X166.799 Y180.114 E.01589
G1 X181.326 Y165.588 E.61196
G1 X181.326 Y165.054 E.01589
G1 X166.799 Y179.581 E.61196
G1 X166.799 Y179.047 E.01589
G1 X181.326 Y164.521 E.61196
G1 X181.326 Y163.988 E.01589
G1 X166.799 Y178.514 E.61196
G1 X166.799 Y177.981 E.01589
G1 X181.326 Y163.455 E.61196
G1 X181.326 Y162.921 E.01589
G1 X166.799 Y177.447 E.61196
G1 X166.799 Y177.126 E.00959
G1 X166.588 Y177.126 E.0063
G1 X181.326 Y162.388 E.62087
G1 X181.326 Y161.855 E.01589
G1 X166.055 Y177.126 E.64334
G1 X165.521 Y177.126 E.01589
G1 X181.326 Y161.321 E.66581
G1 X181.326 Y160.788 E.01589
G1 X164.988 Y177.126 E.68827
G1 X164.455 Y177.126 E.01589
G1 X181.326 Y160.255 E.71074
G1 X181.326 Y159.721 E.01589
M73 P52 R9
G1 X163.921 Y177.126 E.73321
G1 X163.388 Y177.126 E.01589
G1 X181.326 Y159.188 E.75568
G1 X181.326 Y158.655 E.01589
G1 X162.855 Y177.126 E.77814
G1 X162.321 Y177.126 E.01589
G1 X170.548 Y168.899 E.34656
G1 X170.014 Y168.899 E.01589
G1 X161.788 Y177.126 E.34656
G1 X161.255 Y177.126 E.01589
G1 X169.481 Y168.899 E.34656
G1 X168.948 Y168.899 E.01589
G1 X161.249 Y176.598 E.32432
G1 X161.249 Y176.064 E.01589
G1 X168.414 Y168.899 E.30185
G1 X167.881 Y168.899 E.01589
G1 X161.249 Y175.531 E.27938
G1 X161.249 Y174.998 E.01589
G1 X167.348 Y168.899 E.25691
G1 X166.814 Y168.899 E.01589
G1 X161.249 Y174.464 E.23445
G1 X161.249 Y173.931 E.01589
G1 X166.281 Y168.899 E.21198
G1 X165.748 Y168.899 E.01589
G1 X161.249 Y173.398 E.18951
G1 X161.249 Y172.865 E.01589
G1 X165.214 Y168.899 E.16704
G1 X164.681 Y168.899 E.01589
G1 X161.249 Y172.331 E.14458
G1 X161.249 Y171.798 E.01589
G1 X164.148 Y168.899 E.12211
G1 X163.615 Y168.899 E.01589
G1 X161.249 Y171.265 E.09964
G1 X161.249 Y170.731 E.01589
G1 X163.081 Y168.899 E.07717
G1 X162.548 Y168.899 E.01589
G1 X161.249 Y170.198 E.05471
G1 X161.249 Y169.665 E.01589
G1 X162.015 Y168.899 E.03224
G1 X161.481 Y168.899 E.01589
G1 X161.08 Y169.301 E.01692
M204 S10000
G1 X160.787 Y168.363 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.19158
G1 F15000
M204 S8000
G1 X160.787 Y159.437 E.10481
; WIPE_START
G1 X160.787 Y161.437 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X161.297 Y153.822 Z1.2 F60000
G1 X162.037 Y142.75 Z1.2
G1 Z.8
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
G1 X166.63 Y145.618 Z1.2 F60000
G1 Z.8
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42003
G1 F9546.286
M204 S8000
G1 X176.999 Y135.249 E.43682
G1 X176.465 Y135.249 E.01589
G1 X166.799 Y144.915 E.40721
G1 X166.799 Y144.382 E.01589
G1 X175.932 Y135.249 E.38474
G1 X175.551 Y135.249 E.01136
G1 X175.551 Y135.097 E.00453
G1 X166.799 Y143.849 E.36867
G1 X166.799 Y143.315 E.01589
G1 X167.145 Y142.97 E.01456
M204 S10000
G1 X167.53 Y142.585 F60000
G1 F9546.286
M204 S8000
G1 X175.551 Y134.564 E.33791
G1 X175.551 Y134.031 E.01589
G1 X167.699 Y141.882 E.33076
G1 X167.699 Y141.349 E.01589
G1 X175.551 Y133.497 E.33076
G1 X175.551 Y132.964 E.01589
G1 X167.699 Y140.815 E.33076
G1 X167.699 Y140.282 E.01589
G1 X175.551 Y132.431 E.33076
G1 X175.551 Y131.898 E.01589
G1 X167.699 Y139.749 E.33076
G1 X167.699 Y139.216 E.01589
G1 X175.551 Y131.364 E.33076
G1 X175.551 Y130.831 E.01589
G1 X167.699 Y138.682 E.33076
G1 X167.699 Y138.149 E.01589
G1 X175.551 Y130.298 E.33076
G1 X175.551 Y129.764 E.01589
G1 X167.699 Y137.616 E.33076
G1 X167.699 Y137.082 E.01589
G1 X175.532 Y129.249 E.32998
G1 X174.999 Y129.249 E.01589
G1 X167.699 Y136.549 E.30752
G1 X167.699 Y136.016 E.01589
G1 X174.466 Y129.249 E.28505
G1 X173.932 Y129.249 E.01589
G1 X170.309 Y132.872 E.15263
G1 X170.309 Y132.339 E.01589
G1 X173.399 Y129.249 E.13016
G1 X172.866 Y129.249 E.01589
G1 X170.309 Y131.806 E.10769
G1 X170.309 Y131.272 E.01589
G1 X172.332 Y129.249 E.08523
G1 X171.799 Y129.249 E.01589
G1 X170.309 Y130.739 E.06276
G1 X170.309 Y130.206 E.01589
G1 X171.266 Y129.249 E.04029
G1 X170.732 Y129.249 E.01589
G1 X170.14 Y129.842 E.02497
; WIPE_START
G1 X170.732 Y129.249 E-.31854
G1 X171.266 Y129.249 E-.20266
G1 X170.821 Y129.694 E-.2388
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
G1 X188.32 Y136.194 Z1.2 F60000
G1 Z.8
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42003
G1 F9546.286
M204 S8000
G1 X187.714 Y136.801 E.02556
G1 X187.18 Y136.801 E.01589
G1 X188.151 Y135.83 E.04088
G1 X188.151 Y135.297 E.01589
G1 X186.647 Y136.801 E.06335
G1 X186.114 Y136.801 E.01589
G1 X187.665 Y135.249 E.06535
G1 X187.132 Y135.249 E.01589
G1 X185.58 Y136.801 E.06535
G1 X185.047 Y136.801 E.01589
G1 X186.598 Y135.249 E.06535
G1 X186.065 Y135.249 E.01589
G1 X184.514 Y136.801 E.06535
G1 X183.98 Y136.801 E.01589
G1 X185.532 Y135.249 E.06535
G1 X184.998 Y135.249 E.01589
G1 X183.447 Y136.801 E.06535
G1 X182.914 Y136.801 E.01589
G1 X184.465 Y135.249 E.06535
G1 X183.932 Y135.249 E.01589
G1 X182.38 Y136.801 E.06535
G1 X181.847 Y136.801 E.01589
G1 X183.398 Y135.249 E.06535
G1 X182.865 Y135.249 E.01589
G1 X181.314 Y136.801 E.06535
G1 X180.781 Y136.801 E.01589
G1 X182.332 Y135.249 E.06535
G1 X181.798 Y135.249 E.01589
G1 X180.247 Y136.801 E.06535
G1 X179.714 Y136.801 E.01589
G1 X181.265 Y135.249 E.06535
G1 X180.732 Y135.249 E.01589
G1 X179.181 Y136.801 E.06535
G1 X178.647 Y136.801 E.01589
G1 X180.199 Y135.249 E.06535
G1 X179.665 Y135.249 E.01589
G1 X178.114 Y136.801 E.06535
G1 X177.581 Y136.801 E.01589
G1 X179.132 Y135.249 E.06535
G1 X178.599 Y135.249 E.01589
G1 X177.047 Y136.801 E.06535
G1 X176.514 Y136.801 E.01589
G1 X178.065 Y135.249 E.06535
G1 X177.532 Y135.249 E.01589
G1 X175.981 Y136.801 E.06535
G1 X175.551 Y136.801 E.01281
G1 X175.551 Y137.231 E.01281
G1 X166.799 Y145.982 E.36867
G1 X166.799 Y146.515 E.01589
G1 X175.551 Y137.764 E.36867
G1 X175.551 Y138.297 E.01589
G1 X166.799 Y147.049 E.36867
G1 X166.799 Y147.582 E.01589
G1 X175.551 Y138.831 E.36867
G1 X175.551 Y139.364 E.01589
G1 X166.799 Y148.115 E.36867
G1 X166.799 Y148.649 E.01589
M73 P53 R9
G1 X175.551 Y139.897 E.36867
G1 X175.551 Y140.431 E.01589
G1 X166.799 Y149.182 E.36867
G1 X166.799 Y149.715 E.01589
G1 X175.551 Y140.964 E.36867
G1 X175.551 Y141.497 E.01589
G1 X167.022 Y150.026 E.35929
G1 X167.556 Y150.026 E.01589
G1 X175.551 Y142.03 E.33682
G1 X175.551 Y142.564 E.01589
G1 X168.089 Y150.026 E.31435
G1 X168.622 Y150.026 E.01589
G1 X175.551 Y143.097 E.29188
G1 X175.551 Y143.249 E.00454
G1 X175.932 Y143.249 E.01135
G1 X169.155 Y150.026 E.28547
G1 X169.689 Y150.026 E.01589
G1 X176.465 Y143.249 E.28547
G1 X176.998 Y143.249 E.01589
G1 X170.222 Y150.026 E.28547
G1 X170.755 Y150.026 E.01589
G1 X177.532 Y143.249 E.28547
G1 X178.065 Y143.249 E.01589
G1 X171.289 Y150.026 E.28547
G1 X171.822 Y150.026 E.01589
G1 X178.598 Y143.249 E.28547
G1 X179.132 Y143.249 E.01589
G1 X172.355 Y150.026 E.28547
G1 X172.889 Y150.026 E.01589
G1 X179.665 Y143.249 E.28547
G1 X180.198 Y143.249 E.01589
G1 X173.422 Y150.026 E.28547
G1 X173.955 Y150.026 E.01589
G1 X180.732 Y143.249 E.28547
G1 X181.265 Y143.249 E.01589
G1 X174.489 Y150.026 E.28547
G1 X175.022 Y150.026 E.01589
G1 X181.798 Y143.249 E.28547
G1 X182.331 Y143.249 E.01589
G1 X175.555 Y150.026 E.28547
G1 X176.089 Y150.026 E.01589
G1 X182.865 Y143.249 E.28547
G1 X183.398 Y143.249 E.01589
G1 X176.622 Y150.026 E.28547
G1 X176.709 Y150.026 E.00261
G1 X176.709 Y150.471 E.01328
G1 X183.931 Y143.249 E.30425
G1 X184.465 Y143.249 E.01589
G1 X176.709 Y151.005 E.32672
G1 X176.709 Y151.538 E.01589
G1 X181.326 Y146.922 E.19447
G1 X181.326 Y147.455 E.01589
G1 X176.709 Y152.071 E.19447
G1 X176.709 Y152.605 E.01589
G1 X181.326 Y147.988 E.19447
G1 X181.326 Y148.522 E.01589
G1 X176.709 Y153.138 E.19447
G1 X176.709 Y153.671 E.01589
G1 X181.326 Y149.055 E.19447
G1 X181.326 Y149.588 E.01589
G1 X176.709 Y154.205 E.19447
G1 X176.709 Y154.738 E.01589
G1 X181.326 Y150.122 E.19447
G1 X181.326 Y150.655 E.01589
G1 X176.54 Y155.441 E.20162
; WIPE_START
G1 X177.954 Y154.027 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X181.446 Y147.24 Z1.2 F60000
G1 X181.912 Y146.335 Z1.2
G1 Z.8
G1 E.8 F1800
G1 F9546.286
M204 S8000
G1 X184.998 Y143.249 E.13
G1 X185.531 Y143.249 E.01589
G1 X182.615 Y146.166 E.12286
G1 X183.148 Y146.166 E.01589
G1 X186.065 Y143.249 E.12286
G1 X186.598 Y143.249 E.01589
G1 X183.682 Y146.166 E.12286
G1 X184.215 Y146.166 E.01589
G1 X187.131 Y143.249 E.12286
G1 X187.665 Y143.249 E.01589
G1 X184.748 Y146.166 E.12286
G1 X185.282 Y146.166 E.01589
G1 X188.151 Y143.297 E.12086
G1 X188.151 Y143.83 E.01589
G1 X185.815 Y146.166 E.0984
G1 X186.348 Y146.166 E.01589
G1 X188.151 Y144.363 E.07593
G1 X188.151 Y144.897 E.01589
G1 X186.882 Y146.166 E.05346
G1 X187.415 Y146.166 E.01589
G1 X188.151 Y145.43 E.03099
G1 X188.151 Y145.963 E.01589
G1 X187.779 Y146.335 E.01567
; WIPE_START
G1 X188.151 Y145.963 E-.19996
G1 X188.151 Y145.43 E-.20266
G1 X187.486 Y146.095 E-.35739
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
; COOLING_NODE: 11
; WIPE_START
G1 X189.12 Y181.926 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X186.492 Y174.76 Z1.2 F60000
G1 X166.884 Y121.274 Z1.2
G1 Z.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X160.916 Y121.274 E.1919
G1 X160.916 Y111.416 E.31698
G1 X166.884 Y111.416 E.1919
G1 X166.884 Y116.237 E.15501
G1 X166.66 Y116.255 E.00723
G2 X166.57 Y117.203 I-2.556 J.236 E.48778
G2 X166.654 Y116.74 I-2.169 J-.636 E.01518
G1 X166.884 Y116.754 E.00739
G1 X166.884 Y121.214 E.14342
; COOLING_NODE: 11
; WIPE_START
G1 X164.884 Y121.234 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X162.033 Y117.099 Z1.2 F60000
G1 Z.8
G1 E.8 F1800
G1 F8843.478
M204 S8000
G1 X161.995 Y116.985 E.00386
G3 X163.871 Y114.352 I2.103 J-.486 E.1175
G1 X164.074 Y114.34 E.00653
G3 X162.127 Y117.378 I.025 J2.159 E.29884
G1 X162.052 Y117.156 E.00752
; COOLING_NODE: 11
M204 S10000
G1 X162.418 Y116.97 F60000
G1 F8843.478
M204 S8000
G1 X162.393 Y116.894 E.00258
G3 X163.915 Y114.757 I1.707 J-.395 E.09536
G1 X164.078 Y114.747 E.00526
G3 X162.499 Y117.212 I.021 J1.752 E.24248
G1 X162.437 Y117.027 E.00628
; COOLING_NODE: 11
M204 S250
G1 X162.788 Y116.846 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X162.775 Y116.806 E.00126
G3 X163.957 Y115.147 I1.324 J-.307 E.06858
G1 X164.083 Y115.14 E.00374
G3 X162.858 Y117.053 I.017 J1.359 E.17431
G1 X162.807 Y116.903 E.00472
; COOLING_NODE: 11
; WIPE_START
M204 S8000
G1 X162.775 Y116.806 E-.03887
G1 X162.74 Y116.525 E-.10751
G1 X162.76 Y116.265 E-.09918
G1 X162.83 Y116.013 E-.09938
G1 X162.947 Y115.779 E-.09927
G1 X163.121 Y115.555 E-.10798
G1 X163.225 Y115.459 E-.05376
G1 X163.441 Y115.31 E-.09948
G1 X163.572 Y115.253 E-.05456
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X167.291 Y121.681 Z1.2 F60000
G1 Z.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X160.509 Y121.681 E.21808
G1 X160.509 Y111.009 E.34316
G1 X167.291 Y111.009 E.21808
G1 X167.291 Y121.621 E.34123
; COOLING_NODE: 11
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
; COOLING_NODE: 10
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
G1 X180.86 Y150.312 Z1.4 F60000
G1 X175.17 Y150.766 Z1.4
G1 Z1
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X175.969 Y150.766 E.0257
G1 X175.969 Y155.224 E.14336
G1 X166.431 Y155.224 E.30672
G1 X166.431 Y150.766 E.14336
G1 X175.11 Y150.766 E.27909
; COOLING_NODE: 0
M204 S10000
G1 X175.17 Y151.173 F60000
G1 F8843.478
M204 S8000
G1 X175.562 Y151.173 E.01261
G1 X175.562 Y154.817 E.11718
G1 X166.838 Y154.817 E.28054
G1 X166.838 Y151.173 E.11718
G1 X175.11 Y151.173 E.266
; COOLING_NODE: 1
M204 S250
G1 X175.17 Y151.565 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X175.17 Y154.425 E.08519
G1 X167.23 Y154.425 E.23651
G1 X167.23 Y151.565 E.08519
G1 X175.11 Y151.565 E.23472
; COOLING_NODE: 1
; WIPE_START
M204 S8000
G1 X175.152 Y153.565 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X169.922 Y148.006 Z1.4 F60000
M73 P54 R9
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
G1 X160.916 Y141.613 E-.41057
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X168.544 Y141.868 Z1.4 F60000
G1 X187.71 Y142.509 Z1.4
G1 Z1
G1 E.8 F1800
G1 F8843.478
M204 S8000
G1 X176.291 Y142.509 E.3672
G1 X176.291 Y137.541 E.15976
G1 X188.509 Y137.541 E.3929
G1 X188.509 Y142.509 E.15976
G1 X187.77 Y142.509 E.02377
; COOLING_NODE: 2
M204 S10000
G1 X187.71 Y142.102 F60000
G1 F8843.478
M204 S8000
G1 X176.698 Y142.102 E.35411
G1 X176.698 Y137.948 E.13358
G1 X188.102 Y137.948 E.36672
G1 X188.102 Y142.102 E.13358
G1 X187.77 Y142.102 E.01068
; COOLING_NODE: 3
M204 S250
G1 X187.71 Y141.71 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X177.09 Y141.71 E.31633
G1 X177.09 Y138.34 E.10038
G1 X187.71 Y138.34 E.31633
G1 X187.71 Y141.65 E.09859
; COOLING_NODE: 3
; WIPE_START
M204 S8000
G1 X185.71 Y141.661 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X185.55 Y149.292 Z1.4 F60000
G1 X184.385 Y204.888 Z1.4
G1 Z1
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X184.129 Y204.784 E.00888
G3 X185.029 Y199.946 I1.168 J-2.285 E.21165
G1 X185.285 Y199.932 E.00825
G3 X184.556 Y204.956 I.012 J2.566 E.2838
G1 X184.44 Y204.91 E.00401
; COOLING_NODE: 3
M204 S10000
G1 X184.537 Y204.512 F60000
G1 F8843.478
M204 S8000
G1 X184.316 Y204.422 E.00767
G3 X185.072 Y200.352 I.982 J-1.923 E.17807
G1 X185.288 Y200.34 E.00695
G3 X184.674 Y204.566 I.01 J2.159 E.23879
G1 X184.592 Y204.534 E.00281
; COOLING_NODE: 3
M204 S10000
G1 X184.689 Y204.136 F60000
G1 F8843.478
M204 S8000
G1 X184.502 Y204.059 E.00647
G3 X185.116 Y200.757 I.796 J-1.56 E.14449
G1 X185.291 Y200.747 E.00565
G3 X184.791 Y204.176 I.008 J1.752 E.19378
G1 X184.744 Y204.158 E.00161
; COOLING_NODE: 4
M204 S250
G1 X184.835 Y203.773 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X184.682 Y203.711 E.00492
G3 X185.157 Y201.147 I.617 J-1.211 E.10389
G1 X185.294 Y201.14 E.00407
G3 X184.904 Y203.8 I.006 J1.359 E.13934
G1 X184.891 Y203.795 E.00042
; COOLING_NODE: 4
; WIPE_START
M204 S8000
G1 X184.682 Y203.711 E-.08561
G1 X184.444 Y203.557 E-.10762
G1 X184.257 Y203.373 E-.09962
G1 X184.099 Y203.139 E-.10751
G1 X183.999 Y202.897 E-.09921
G1 X183.946 Y202.625 E-.10552
G1 X183.947 Y202.359 E-.10116
G1 X183.975 Y202.22 E-.05374
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X184.398 Y194.599 Z1.4 F60000
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
G1 X181.641 Y195.334 E.42607
G1 X160.916 Y195.334 E.66644
G1 X160.916 Y193.531 E.05796
G1 X166.466 Y193.531 E.17847
G1 X166.466 Y177.459 E.51683
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
; COOLING_NODE: 4
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
; COOLING_NODE: 4
M204 S10000
G1 X187.71 Y129.948 F60000
G1 F8843.478
M204 S8000
G1 X188.102 Y129.948 E.01261
G1 X188.102 Y134.102 E.13358
G1 X176.698 Y134.102 E.36672
G1 X176.698 Y129.948 E.13358
G1 X187.65 Y129.948 E.35218
; COOLING_NODE: 5
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
; COOLING_NODE: 5
; WIPE_START
M204 S8000
G1 X187.686 Y132.34 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X183.222 Y138.531 Z1.4 F60000
G1 X161.864 Y168.159 Z1.4
G1 Z1
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X161.065 Y168.159 E.0257
G1 X161.065 Y159.641 E.27392
G1 X170.324 Y159.641 E.29774
G1 X170.324 Y168.159 E.27392
G1 X161.924 Y168.159 E.27012
; COOLING_NODE: 5
M204 S10000
G1 X161.864 Y167.752 F60000
G1 F8843.478
M204 S8000
G1 X161.472 Y167.752 E.01261
G1 X161.472 Y160.048 E.24774
G1 X169.917 Y160.048 E.27156
G1 X169.917 Y167.752 E.24774
G1 X161.924 Y167.752 E.25703
; COOLING_NODE: 6
M204 S250
G1 X161.864 Y167.36 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X161.864 Y160.44 E.20612
G1 X169.525 Y160.44 E.22819
G1 X169.525 Y167.36 E.20612
G1 X161.924 Y167.36 E.22641
; COOLING_NODE: 6
; WIPE_START
M204 S8000
G1 X161.907 Y165.36 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X163.539 Y172.816 Z1.4 F60000
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
; COOLING_NODE: 6
M204 S10000
G1 X165.652 Y184.325 F60000
G1 F8843.478
M204 S8000
G1 X165.652 Y184.717 E.01261
G1 X161.748 Y184.717 E.12554
G1 X161.748 Y178.273 E.20722
G1 X165.652 Y178.273 E.12554
G1 X165.652 Y184.265 E.19268
; COOLING_NODE: 7
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
; COOLING_NODE: 7
; WIPE_START
M204 S8000
G1 X163.26 Y184.303 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X165.775 Y191.51 Z1.4 F60000
G1 X166.059 Y192.325 Z1.4
G1 Z1
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X166.059 Y193.124 E.0257
G1 X161.341 Y193.124 E.15172
G1 X161.341 Y185.866 E.2334
G1 X166.059 Y185.866 E.15172
G1 X166.059 Y192.265 E.20577
; COOLING_NODE: 7
M204 S10000
G1 X165.652 Y192.325 F60000
G1 F8843.478
M204 S8000
G1 X165.652 Y192.717 E.01261
G1 X161.748 Y192.717 E.12554
G1 X161.748 Y186.273 E.20722
G1 X165.652 Y186.273 E.12554
G1 X165.652 Y192.265 E.19268
; COOLING_NODE: 8
M204 S250
G1 X165.26 Y192.325 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X162.14 Y192.325 E.09293
G1 X162.14 Y186.665 E.16859
G1 X165.26 Y186.665 E.09293
G1 X165.26 Y192.265 E.1668
; COOLING_NODE: 8
; WIPE_START
M204 S8000
G1 X163.26 Y192.303 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X166.972 Y185.634 Z1.4 F60000
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
G1 X181.234 Y195.741 E.42607
G1 X160.509 Y195.741 E.66644
G1 X160.509 Y132.519 E2.03298
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
M73 P55 R9
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
G1 X167.726 Y134.83 Z1.4 F60000
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
G1 X180.827 Y196.148 E.42607
G1 X160.102 Y196.148 E.66644
G1 X160.102 Y132.112 E2.05916
G1 X169.102 Y132.112 E.28941
; COOLING_NODE: 10
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
G1 X180.435 Y196.54 E.39467
G1 X159.71 Y196.54 E.61733
G1 X159.71 Y131.72 E1.93077
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
G1 X166.236 Y156.584 Z1.4 F60000
G1 X168.646 Y159.07 Z1.4
G1 Z1
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42209
G1 F9494.421
M204 S8000
G1 X163.215 Y153.639 E.23005
G1 X162.679 Y153.639 E.01606
G1 X167.94 Y158.901 E.22286
G1 X167.404 Y158.901 E.01606
G1 X162.143 Y153.639 E.22286
G1 X161.606 Y153.639 E.01606
G1 X166.868 Y158.901 E.22286
G1 X166.331 Y158.901 E.01606
G1 X161.249 Y153.819 E.21527
G1 X161.249 Y154.355 E.01606
G1 X165.795 Y158.901 E.19256
G1 X165.259 Y158.901 E.01606
G1 X161.249 Y154.891 E.16984
G1 X161.249 Y155.427 E.01606
G1 X164.723 Y158.901 E.14713
G1 X164.187 Y158.901 E.01606
G1 X161.249 Y155.963 E.12441
G1 X161.249 Y156.5 E.01606
G1 X163.65 Y158.901 E.1017
G1 X163.114 Y158.901 E.01606
G1 X161.249 Y157.036 E.07899
G1 X161.249 Y157.572 E.01606
G1 X162.578 Y158.901 E.05627
G1 X162.042 Y158.901 E.01606
G1 X161.249 Y158.108 E.03356
G1 X161.249 Y158.645 E.01606
G1 X161.675 Y159.07 E.01803
M204 S10000
G1 X160.787 Y159.437 F60000
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
G1 X164.319 Y173.129 Z1.4 F60000
G1 X166.494 Y177.295 Z1.4
G1 Z1
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42209
G1 F9494.421
M204 S8000
G1 X161.249 Y172.05 E.22217
G1 X161.249 Y172.586 E.01606
G1 X165.789 Y177.126 E.19227
G1 X165.252 Y177.126 E.01606
G1 X161.249 Y173.123 E.16956
G1 X161.249 Y173.659 E.01606
G1 X164.716 Y177.126 E.14684
G1 X164.18 Y177.126 E.01606
G1 X161.249 Y174.195 E.12413
G1 X161.249 Y174.731 E.01606
G1 X163.644 Y177.126 E.10142
G1 X163.107 Y177.126 E.01606
G1 X161.249 Y175.268 E.0787
G1 X161.249 Y175.804 E.01606
G1 X162.571 Y177.126 E.05599
G1 X162.035 Y177.126 E.01606
G1 X161.249 Y176.34 E.03328
G1 X161.249 Y176.876 E.01606
G1 X161.668 Y177.295 E.01775
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
G1 X160.925 Y193.328 E.25713
; WIPE_START
G1 X160.925 Y191.328 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X161.08 Y194.402 Z1.4 F60000
G1 Z1
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42209
G1 F9494.421
M204 S8000
G1 X161.678 Y195.001 E.02535
G1 X162.214 Y195.001 E.01606
G1 X161.249 Y194.036 E.04088
G1 X161.249 Y193.864 E.00513
G1 X161.614 Y193.864 E.01093
G1 X162.751 Y195.001 E.04813
G1 X163.287 Y195.001 E.01606
G1 X162.151 Y193.864 E.04813
G1 X162.687 Y193.864 E.01606
G1 X163.823 Y195.001 E.04813
G1 X164.359 Y195.001 E.01606
G1 X163.223 Y193.864 E.04813
G1 X163.759 Y193.864 E.01606
G1 X164.896 Y195.001 E.04813
G1 X165.432 Y195.001 E.01606
G1 X164.296 Y193.864 E.04813
G1 X164.832 Y193.864 E.01606
G1 X165.968 Y195.001 E.04813
G1 X166.504 Y195.001 E.01606
G1 X165.368 Y193.864 E.04813
G1 X165.904 Y193.864 E.01606
G1 X167.04 Y195.001 E.04813
G1 X167.577 Y195.001 E.01606
G1 X166.44 Y193.864 E.04813
G1 X166.799 Y193.864 E.01075
G1 X166.799 Y193.687 E.00531
G1 X168.113 Y195.001 E.05564
G1 X168.649 Y195.001 E.01606
G1 X166.799 Y193.151 E.07835
G1 X166.799 Y192.615 E.01606
G1 X169.185 Y195.001 E.10107
G1 X169.722 Y195.001 E.01606
G1 X166.799 Y192.078 E.12378
G1 X166.799 Y191.542 E.01606
M73 P56 R9
G1 X170.258 Y195.001 E.14649
G1 X170.794 Y195.001 E.01606
G1 X166.799 Y191.006 E.16921
G1 X166.799 Y190.47 E.01606
G1 X171.33 Y195.001 E.19192
G1 X171.867 Y195.001 E.01606
G1 X166.799 Y189.933 E.21464
G1 X166.799 Y189.397 E.01606
G1 X172.403 Y195.001 E.23735
G1 X172.939 Y195.001 E.01606
G1 X166.799 Y188.861 E.26006
G1 X166.799 Y188.325 E.01606
G1 X173.475 Y195.001 E.28278
G1 X174.011 Y195.001 E.01606
G1 X166.799 Y187.789 E.30549
G1 X166.799 Y187.252 E.01606
G1 X174.548 Y195.001 E.3282
G1 X175.084 Y195.001 E.01606
G1 X166.799 Y186.716 E.35092
G1 X166.799 Y186.18 E.01606
G1 X175.62 Y195.001 E.37363
G1 X176.156 Y195.001 E.01606
G1 X166.799 Y185.644 E.39634
G1 X166.799 Y185.107 E.01606
G1 X176.693 Y195.001 E.41906
G1 X177.229 Y195.001 E.01606
G1 X166.799 Y184.571 E.44177
G1 X166.799 Y184.035 E.01606
G1 X177.765 Y195.001 E.46448
G1 X178.301 Y195.001 E.01606
G1 X166.799 Y183.499 E.4872
G1 X166.799 Y182.963 E.01606
G1 X178.837 Y195.001 E.50991
G1 X179.374 Y195.001 E.01606
G1 X166.799 Y182.426 E.53263
G1 X166.799 Y181.89 E.01606
G1 X179.91 Y195.001 E.55534
G1 X180.446 Y195.001 E.01606
G1 X166.799 Y181.354 E.57805
G1 X166.799 Y180.818 E.01606
G1 X180.982 Y195.001 E.60077
G1 X181.519 Y195.001 E.01606
G1 X166.799 Y180.281 E.62348
G1 X166.799 Y179.745 E.01606
G1 X187.956 Y200.902 E.89616
G1 X188.151 Y200.867 E.00592
G1 X188.151 Y200.56 E.0092
G1 X166.799 Y179.209 E.9044
G1 X166.799 Y178.673 E.01606
G1 X188.151 Y200.024 E.9044
G1 X188.151 Y199.488 E.01606
G1 X166.799 Y178.136 E.9044
G1 X166.799 Y177.6 E.01606
G1 X188.151 Y198.952 E.9044
G1 X188.151 Y198.415 E.01606
G1 X161.249 Y171.514 E1.13949
G1 X161.249 Y170.978 E.01606
G1 X188.151 Y197.879 E1.13949
G1 X188.151 Y197.343 E.01606
G1 X161.249 Y170.442 E1.13949
G1 X161.249 Y169.905 E.01606
G1 X188.151 Y196.807 E1.13949
G1 X188.151 Y196.27 E.01606
G1 X161.249 Y169.369 E1.13949
G1 X161.249 Y168.899 E.01407
G1 X161.316 Y168.899 E.00199
G1 X188.151 Y195.734 E1.13667
G1 X188.151 Y195.198 E.01606
G1 X161.852 Y168.899 E1.11396
G1 X162.388 Y168.899 E.01606
G1 X188.151 Y194.662 E1.09124
G1 X188.151 Y194.125 E.01606
G1 X162.925 Y168.899 E1.06853
G1 X163.461 Y168.899 E.01606
G1 X188.151 Y193.589 E1.04582
G1 X188.151 Y193.053 E.01606
G1 X163.997 Y168.899 E1.0231
G1 X164.533 Y168.899 E.01606
G1 X188.151 Y192.517 E1.00039
G1 X188.151 Y191.981 E.01606
G1 X165.069 Y168.899 E.97768
G1 X165.606 Y168.899 E.01606
G1 X188.151 Y191.444 E.95496
G1 X188.151 Y190.908 E.01606
G1 X166.142 Y168.899 E.93225
G1 X166.678 Y168.899 E.01606
G1 X188.32 Y190.542 E.91672
; WIPE_START
G1 X186.906 Y189.127 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X186.729 Y196.758 Z1.4 F60000
G1 X186.651 Y200.133 Z1.4
G1 Z1
G1 E.8 F1800
G1 F9494.421
M204 S8000
G1 X181.974 Y195.456 E.19808
G1 X181.974 Y195.993 E.01606
G1 X185.597 Y199.616 E.15346
G1 X185.058 Y199.613 E.01614
G1 X181.974 Y196.529 E.13063
G1 X181.974 Y197.065 E.01606
G1 X184.603 Y199.694 E.11135
G2 X184.201 Y199.828 I.143 J1.099 E.01277
G1 X181.974 Y197.601 E.09432
G1 X181.974 Y198.138 E.01606
G1 X183.836 Y199.999 E.07885
G2 X183.516 Y200.215 I.936 J1.732 E.01159
G1 X181.974 Y198.674 E.06529
G1 X181.974 Y199.21 E.01606
G1 X183.231 Y200.467 E.05324
G2 X182.985 Y200.757 I1.251 J1.314 E.01141
G1 X181.974 Y199.746 E.0428
G1 X181.974 Y200.282 E.01606
G1 X182.773 Y201.081 E.03383
G2 X182.606 Y201.451 I1.23 J.777 E.01218
G1 X181.974 Y200.819 E.02677
G1 X181.974 Y201.355 E.01606
G1 X182.481 Y201.862 E.02147
G2 X182.407 Y202.324 I1.539 J.483 E.01408
G1 X181.974 Y201.891 E.01834
G1 X181.974 Y202.427 E.01606
G1 X182.427 Y202.88 E.01917
G2 X182.641 Y203.63 I2.535 J-.318 E.02346
G1 X181.974 Y202.964 E.02824
G1 X181.974 Y203.5 E.01606
G1 X186.725 Y208.251 E.20124
G1 X187.261 Y208.251 E.01606
G1 X184.173 Y205.162 E.13081
G2 X184.921 Y205.374 I1.083 J-2.405 E.02334
G1 X187.798 Y208.251 E.12187
G1 X188.151 Y208.251 E.01057
G1 X188.151 Y208.067 E.00549
G1 X185.473 Y205.39 E.11342
G2 X185.945 Y205.326 I-.105 J-2.546 E.01429
G1 X188.151 Y207.531 E.09342
G1 X188.151 Y206.995 E.01606
G1 X186.355 Y205.2 E.07605
G2 X186.719 Y205.027 I-1.092 J-2.77 E.01206
G1 X188.151 Y206.459 E.06064
G1 X188.151 Y205.922 E.01606
G1 X187.04 Y204.812 E.04702
G2 X187.333 Y204.569 I-.69 J-1.126 E.01144
G1 X188.151 Y205.386 E.03463
G1 X188.151 Y204.85 E.01606
G1 X187.584 Y204.284 E.02398
G2 X187.743 Y204.061 I-1.002 J-.879 E.00821
G1 X187.93 Y204.093 E.0057
G1 X188.32 Y204.483 E.01652
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
G1 X186.359 Y208.42 Z1.4 F60000
G1 Z1
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42209
G1 F9494.421
M204 S8000
G1 X181.974 Y204.036 E.18571
G1 X181.974 Y204.572 E.01606
G1 X185.653 Y208.251 E.15581
G1 X185.117 Y208.251 E.01606
G1 X181.974 Y205.109 E.1331
G1 X181.974 Y205.645 E.01606
G1 X184.58 Y208.251 E.11038
G1 X184.044 Y208.251 E.01606
G1 X181.974 Y206.181 E.08767
G1 X181.974 Y206.717 E.01606
G1 X183.508 Y208.251 E.06495
G1 X182.972 Y208.251 E.01606
G1 X181.974 Y207.253 E.04224
G1 X181.974 Y207.79 E.01606
G1 X182.605 Y208.42 E.02671
; WIPE_START
G1 X181.974 Y207.79 E-.33893
G1 X181.974 Y207.253 E-.20377
G1 X182.379 Y207.658 E-.2173
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X180.096 Y200.375 Z1.4 F60000
G1 X162.037 Y142.75 Z1.4
G1 Z1
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.33758
G1 F12217.47
M204 S8000
G1 X166.263 Y142.75 E.09834
; WIPE_START
G1 X164.263 Y142.75 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X167.457 Y135.818 Z1.4 F60000
G1 X170.14 Y129.999 Z1.4
G1 Z1
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42209
G1 F9494.421
M204 S8000
G1 X176.941 Y136.801 E.28811
G1 X176.405 Y136.801 E.01606
G1 X170.309 Y130.705 E.2582
G1 X170.309 Y131.241 E.01606
G1 X175.869 Y136.801 E.23549
G1 X175.551 Y136.801 E.00953
G1 X175.551 Y137.019 E.00653
G1 X170.309 Y131.777 E.22201
G1 X170.309 Y132.314 E.01606
G1 X175.551 Y137.555 E.22201
G1 X175.551 Y138.091 E.01606
G1 X170.309 Y132.85 E.22201
G1 X170.309 Y133.259 E.01227
G1 X170.183 Y133.259 E.00379
G1 X175.551 Y138.627 E.22738
G1 X175.551 Y139.164 E.01606
G1 X169.646 Y133.259 E.25009
G1 X169.11 Y133.259 E.01606
G1 X175.551 Y139.7 E.2728
G1 X175.551 Y140.236 E.01606
G1 X168.574 Y133.259 E.29552
G1 X168.038 Y133.259 E.01606
G1 X175.551 Y140.772 E.31823
G1 X175.551 Y141.308 E.01606
G1 X167.699 Y133.457 E.33257
G1 X167.699 Y133.993 E.01606
G1 X175.551 Y141.845 E.33257
G1 X175.551 Y142.381 E.01606
G1 X167.699 Y134.53 E.33257
G1 X167.699 Y135.066 E.01606
G1 X181.326 Y148.692 E.57718
G1 X181.326 Y148.156 E.01606
G1 X176.419 Y143.249 E.20783
G1 X176.955 Y143.249 E.01606
G1 X181.326 Y147.62 E.18512
G1 X181.326 Y147.083 E.01606
G1 X177.492 Y143.249 E.1624
G1 X178.028 Y143.249 E.01606
G1 X181.326 Y146.547 E.13969
G1 X181.326 Y146.166 E.01143
G1 X181.48 Y146.166 E.00463
G1 X178.564 Y143.249 E.12353
G1 X179.1 Y143.249 E.01606
G1 X182.017 Y146.166 E.12353
G1 X182.553 Y146.166 E.01606
G1 X179.636 Y143.249 E.12353
G1 X180.173 Y143.249 E.01606
G1 X183.089 Y146.166 E.12353
G1 X183.625 Y146.166 E.01606
G1 X180.709 Y143.249 E.12353
G1 X181.245 Y143.249 E.01606
G1 X184.161 Y146.166 E.12353
G1 X184.698 Y146.166 E.01606
G1 X181.781 Y143.249 E.12353
G1 X182.318 Y143.249 E.01606
G1 X185.234 Y146.166 E.12353
G1 X185.77 Y146.166 E.01606
G1 X182.854 Y143.249 E.12353
G1 X183.39 Y143.249 E.01606
G1 X186.306 Y146.166 E.12353
G1 X186.843 Y146.166 E.01606
G1 X183.926 Y143.249 E.12353
G1 X184.463 Y143.249 E.01606
G1 X187.379 Y146.166 E.12353
M73 P57 R9
G1 X187.915 Y146.166 E.01606
G1 X184.999 Y143.249 E.12353
G1 X185.535 Y143.249 E.01606
G1 X188.151 Y145.865 E.1108
G1 X188.151 Y145.329 E.01606
G1 X186.071 Y143.249 E.08808
G1 X186.607 Y143.249 E.01606
G1 X188.151 Y144.793 E.06537
G1 X188.151 Y144.256 E.01606
G1 X187.144 Y143.249 E.04265
G1 X187.68 Y143.249 E.01606
G1 X188.32 Y143.89 E.02713
; WIPE_START
G1 X187.68 Y143.249 E-.34418
G1 X187.144 Y143.249 E-.20377
G1 X187.538 Y143.644 E-.21206
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
G1 X187.961 Y182.675 Z1.4 F60000
G1 Z1
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42209
G1 F9494.421
M204 S8000
G1 X188.151 Y182.865 E.00805
G1 X188.151 Y183.401 E.01606
G1 X187.594 Y182.844 E.02358
G1 X187.058 Y182.844 E.01606
G1 X188.151 Y183.937 E.04629
G1 X188.151 Y184.473 E.01606
G1 X186.522 Y182.844 E.069
G1 X185.985 Y182.844 E.01606
G1 X188.151 Y185.01 E.09172
G1 X188.151 Y185.546 E.01606
G1 X185.449 Y182.844 E.11443
G1 X184.913 Y182.844 E.01606
G1 X188.151 Y186.082 E.13714
G1 X188.151 Y186.618 E.01606
G1 X184.377 Y182.844 E.15986
G1 X183.84 Y182.844 E.01606
G1 X188.151 Y187.155 E.18257
G1 X188.151 Y187.691 E.01606
G1 X183.304 Y182.844 E.20528
G1 X182.768 Y182.844 E.01606
G1 X188.151 Y188.227 E.228
G1 X188.151 Y188.763 E.01606
G1 X182.232 Y182.844 E.25071
G1 X181.696 Y182.844 E.01606
G1 X188.151 Y189.299 E.27342
G1 X188.151 Y189.836 E.01606
G1 X167.214 Y168.899 E.88682
G1 X167.751 Y168.899 E.01606
G1 X181.326 Y182.474 E.57501
G1 X181.326 Y181.938 E.01606
G1 X168.287 Y168.899 E.5523
G1 X168.823 Y168.899 E.01606
G1 X181.326 Y181.402 E.52959
G1 X181.326 Y180.866 E.01606
G1 X169.359 Y168.899 E.50687
G1 X169.895 Y168.899 E.01606
G1 X181.326 Y180.33 E.48416
G1 X181.326 Y179.793 E.01606
G1 X170.432 Y168.899 E.46145
G1 X170.968 Y168.899 E.01606
G1 X181.326 Y179.257 E.43873
G1 X181.326 Y178.721 E.01606
G1 X171.064 Y168.46 E.43465
G1 X171.064 Y167.923 E.01606
M73 P57 R8
G1 X181.326 Y178.185 E.43465
G1 X181.326 Y177.648 E.01606
G1 X171.064 Y167.387 E.43465
G1 X171.064 Y166.851 E.01606
G1 X181.326 Y177.112 E.43465
G1 X181.326 Y176.576 E.01606
G1 X171.064 Y166.315 E.43465
G1 X171.064 Y165.778 E.01606
G1 X181.326 Y176.04 E.43465
G1 X181.326 Y175.503 E.01606
G1 X171.064 Y165.242 E.43465
G1 X171.064 Y164.706 E.01606
G1 X181.326 Y174.967 E.43465
G1 X181.326 Y174.431 E.01606
G1 X171.064 Y164.17 E.43465
G1 X171.064 Y163.634 E.01606
G1 X181.326 Y173.895 E.43465
G1 X181.326 Y173.359 E.01606
G1 X171.064 Y163.097 E.43465
G1 X171.064 Y162.561 E.01606
G1 X181.326 Y172.822 E.43465
G1 X181.326 Y172.286 E.01606
G1 X171.064 Y162.025 E.43465
G1 X171.064 Y161.489 E.01606
G1 X181.326 Y171.75 E.43465
G1 X181.326 Y171.214 E.01606
G1 X171.064 Y160.952 E.43465
G1 X171.064 Y160.416 E.01606
G1 X181.326 Y170.677 E.43465
G1 X181.326 Y170.141 E.01606
G1 X171.064 Y159.88 E.43465
G1 X171.064 Y159.344 E.01606
G1 X181.495 Y169.775 E.44184
; WIPE_START
G1 X180.081 Y168.36 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X180.903 Y160.772 Z1.4 F60000
G1 X181.495 Y155.297 Z1.4
G1 Z1
G1 E.8 F1800
G1 F9494.421
M204 S8000
G1 X176.709 Y150.511 E.20272
G1 X176.709 Y151.047 E.01606
G1 X181.326 Y155.663 E.19554
G1 X181.326 Y156.199 E.01606
G1 X176.709 Y151.583 E.19554
G1 X176.709 Y152.119 E.01606
G1 X181.326 Y156.736 E.19554
G1 X181.326 Y157.272 E.01606
G1 X176.709 Y152.655 E.19554
G1 X176.709 Y153.192 E.01606
G1 X181.326 Y157.808 E.19554
G1 X181.326 Y158.344 E.01606
G1 X176.709 Y153.728 E.19554
G1 X176.709 Y154.264 E.01606
G1 X181.326 Y158.88 E.19554
G1 X181.326 Y159.417 E.01606
G1 X176.709 Y154.8 E.19554
G1 X176.709 Y155.337 E.01606
G1 X181.326 Y159.953 E.19554
G1 X181.326 Y160.489 E.01606
G1 X176.709 Y155.873 E.19554
G1 X176.709 Y155.964 E.00274
G1 X176.265 Y155.964 E.01332
G1 X181.326 Y161.025 E.21437
G1 X181.326 Y161.562 E.01606
G1 X175.728 Y155.964 E.23709
G1 X175.192 Y155.964 E.01606
G1 X181.326 Y162.098 E.2598
G1 X181.326 Y162.634 E.01606
G1 X174.656 Y155.964 E.28251
G1 X174.12 Y155.964 E.01606
G1 X181.326 Y163.17 E.30523
G1 X181.326 Y163.706 E.01606
G1 X173.584 Y155.964 E.32794
G1 X173.047 Y155.964 E.01606
G1 X181.326 Y164.243 E.35066
G1 X181.326 Y164.779 E.01606
G1 X172.511 Y155.964 E.37337
G1 X171.975 Y155.964 E.01606
G1 X181.326 Y165.315 E.39608
G1 X181.326 Y165.851 E.01606
G1 X171.439 Y155.964 E.4188
G1 X170.902 Y155.964 E.01606
G1 X181.326 Y166.388 E.44151
G1 X181.326 Y166.924 E.01606
G1 X170.366 Y155.964 E.46422
G1 X169.83 Y155.964 E.01606
G1 X181.326 Y167.46 E.48694
G1 X181.326 Y167.996 E.01606
G1 X169.294 Y155.964 E.50965
G1 X168.757 Y155.964 E.01606
G1 X181.326 Y168.533 E.53236
G1 X181.326 Y169.069 E.01606
G1 X168.221 Y155.964 E.55508
G1 X167.685 Y155.964 E.01606
G1 X170.621 Y158.901 E.12438
G1 X170.085 Y158.901 E.01606
G1 X167.149 Y155.964 E.12438
G1 X166.613 Y155.964 E.01606
G1 X169.549 Y158.901 E.12438
G1 X169.013 Y158.901 E.01606
G1 X166.076 Y155.964 E.12438
G1 X165.691 Y155.964 E.01155
G1 X165.691 Y155.579 E.01155
G1 X163.751 Y153.639 E.08214
G1 X164.288 Y153.639 E.01606
G1 X165.691 Y155.042 E.05943
G1 X165.691 Y154.506 E.01606
G1 X164.824 Y153.639 E.03672
G1 X165.36 Y153.639 E.01606
G1 X165.86 Y154.14 E.02119
; WIPE_START
G1 X165.36 Y153.639 E-.26886
G1 X164.824 Y153.639 E-.20377
G1 X165.359 Y154.174 E-.28738
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X166.63 Y149.547 Z1.4 F60000
G1 Z1
G1 E.8 F1800
G1 F9494.421
M204 S8000
G1 X167.109 Y150.026 E.02028
G1 X167.645 Y150.026 E.01606
G1 X166.799 Y149.18 E.03581
G1 X166.799 Y148.644 E.01606
G1 X168.181 Y150.026 E.05852
G1 X168.717 Y150.026 E.01606
G1 X166.799 Y148.108 E.08124
G1 X166.799 Y147.572 E.01606
G1 X169.253 Y150.026 E.10395
G1 X169.79 Y150.026 E.01606
G1 X166.799 Y147.035 E.12667
G1 X166.799 Y146.499 E.01606
G1 X170.326 Y150.026 E.14938
G1 X170.862 Y150.026 E.01606
G1 X166.799 Y145.963 E.17209
G1 X166.799 Y145.427 E.01606
G1 X171.398 Y150.026 E.19481
G1 X171.935 Y150.026 E.01606
G1 X166.799 Y144.89 E.21752
G1 X166.799 Y144.354 E.01606
G1 X172.471 Y150.026 E.24023
G1 X173.007 Y150.026 E.01606
G1 X166.799 Y143.818 E.26295
G1 X166.799 Y143.282 E.01606
G1 X173.543 Y150.026 E.28566
G1 X174.08 Y150.026 E.01606
G1 X167.193 Y143.139 E.29169
G1 X167.699 Y143.139 E.01516
G1 X167.699 Y143.109 E.0009
G1 X174.616 Y150.026 E.29296
G1 X175.152 Y150.026 E.01606
G1 X167.699 Y142.573 E.31568
G1 X167.699 Y142.037 E.01606
G1 X175.688 Y150.026 E.33839
G1 X176.224 Y150.026 E.01606
G1 X167.699 Y141.501 E.36111
G1 X167.699 Y140.964 E.01606
G1 X181.326 Y154.591 E.57718
G1 X181.326 Y154.054 E.01606
G1 X167.699 Y140.428 E.57718
G1 X167.699 Y139.892 E.01606
G1 X181.326 Y153.518 E.57718
G1 X181.326 Y152.982 E.01606
G1 X167.699 Y139.356 E.57718
G1 X167.699 Y138.819 E.01606
G1 X181.326 Y152.446 E.57718
G1 X181.326 Y151.909 E.01606
G1 X167.699 Y138.283 E.57718
G1 X167.699 Y137.747 E.01606
G1 X181.326 Y151.373 E.57718
G1 X181.326 Y150.837 E.01606
G1 X167.699 Y137.211 E.57718
G1 X167.699 Y136.675 E.01606
G1 X181.326 Y150.301 E.57718
G1 X181.326 Y149.765 E.01606
G1 X167.699 Y136.138 E.57718
G1 X167.699 Y135.602 E.01606
G1 X181.495 Y149.398 E.58437
; WIPE_START
G1 X180.081 Y147.984 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X184.368 Y141.669 Z1.4 F60000
G1 X188.32 Y135.846 Z1.4
G1 Z1
G1 E.8 F1800
G1 F9494.421
M204 S8000
G1 X187.723 Y135.249 E.02529
G1 X187.187 Y135.249 E.01606
G1 X188.151 Y136.213 E.04082
G1 X188.151 Y136.749 E.01606
G1 X186.651 Y135.249 E.06353
G1 X186.115 Y135.249 E.01606
G1 X187.666 Y136.801 E.06571
G1 X187.13 Y136.801 E.01606
G1 X185.578 Y135.249 E.06571
G1 X185.042 Y135.249 E.01606
G1 X186.593 Y136.801 E.06571
G1 X186.057 Y136.801 E.01606
G1 X184.506 Y135.249 E.06571
G1 X183.97 Y135.249 E.01606
G1 X185.521 Y136.801 E.06571
G1 X184.985 Y136.801 E.01606
G1 X183.433 Y135.249 E.06571
G1 X182.897 Y135.249 E.01606
G1 X184.449 Y136.801 E.06571
G1 X183.912 Y136.801 E.01606
G1 X182.361 Y135.249 E.06571
G1 X181.825 Y135.249 E.01606
G1 X183.376 Y136.801 E.06571
G1 X182.84 Y136.801 E.01606
G1 X181.289 Y135.249 E.06571
G1 X180.752 Y135.249 E.01606
G1 X182.304 Y136.801 E.06571
G1 X181.767 Y136.801 E.01606
G1 X180.216 Y135.249 E.06571
G1 X179.68 Y135.249 E.01606
G1 X181.231 Y136.801 E.06571
G1 X180.695 Y136.801 E.01606
G1 X179.144 Y135.249 E.06571
G1 X178.607 Y135.249 E.01606
G1 X180.159 Y136.801 E.06571
G1 X179.622 Y136.801 E.01606
G1 X178.071 Y135.249 E.06571
G1 X177.535 Y135.249 E.01606
M73 P58 R8
G1 X179.086 Y136.801 E.06571
G1 X178.55 Y136.801 E.01606
G1 X176.999 Y135.249 E.06571
G1 X176.463 Y135.249 E.01606
G1 X178.014 Y136.801 E.06571
G1 X177.478 Y136.801 E.01606
G1 X175.926 Y135.249 E.06571
G1 X175.551 Y135.249 E.01125
G1 X175.551 Y134.874 E.01125
G1 X170.309 Y129.632 E.22201
G1 X170.309 Y129.249 E.01147
G1 X170.463 Y129.249 E.00459
G1 X175.551 Y134.337 E.21552
G1 X175.551 Y133.801 E.01606
G1 X170.999 Y129.249 E.19281
G1 X171.535 Y129.249 E.01606
G1 X175.551 Y133.265 E.1701
G1 X175.551 Y132.729 E.01606
G1 X172.071 Y129.249 E.14738
G1 X172.607 Y129.249 E.01606
G1 X175.551 Y132.193 E.12467
G1 X175.551 Y131.656 E.01606
G1 X173.144 Y129.249 E.10196
G1 X173.68 Y129.249 E.01606
G1 X175.551 Y131.12 E.07924
G1 X175.551 Y130.584 E.01606
G1 X174.216 Y129.249 E.05653
G1 X174.752 Y129.249 E.01606
G1 X175.551 Y130.048 E.03381
G1 X175.551 Y129.511 E.01606
G1 X175.119 Y129.08 E.01829
M204 S10000
G1 X176.087 Y129.025 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.66758
G1 F5763.136
M204 S8000
G1 X188.687 Y129.025 E.62173
; COOLING_NODE: 11
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
; COOLING_NODE: 11
; WIPE_START
G1 X164.884 Y121.234 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X162.009 Y117.003 Z1.4 F60000
G1 Z1
G1 E.8 F1800
G1 F8843.478
M204 S8000
G1 X161.948 Y116.7 E.00995
G3 X163.872 Y114.352 I2.15 J-.201 E.10827
G1 X164.088 Y114.34 E.00695
G3 X162.033 Y117.129 I.01 J2.159 E.30693
G1 X162.02 Y117.062 E.00219
; COOLING_NODE: 11
M204 S10000
G1 X162.407 Y116.925 F60000
G1 F8843.478
M204 S8000
G1 X162.354 Y116.662 E.00864
G3 X163.916 Y114.757 I1.744 J-.163 E.08782
G1 X164.091 Y114.747 E.00565
G3 X162.423 Y117.011 I.008 J1.752 E.249
G1 X162.418 Y116.984 E.00088
; COOLING_NODE: 11
M204 S250
G1 X162.79 Y116.85 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X162.746 Y116.625 E.00684
G3 X163.957 Y115.147 I1.354 J-.126 E.06311
G1 X164.094 Y115.14 E.00407
G3 X162.803 Y116.909 I.006 J1.359 E.17862
; COOLING_NODE: 11
; WIPE_START
M204 S8000
G1 X162.746 Y116.625 E-.10997
G1 X162.747 Y116.359 E-.10113
G1 X162.793 Y116.124 E-.09079
G1 X162.889 Y115.881 E-.09924
G1 X163.043 Y115.644 E-.10737
G1 X163.227 Y115.457 E-.09983
G1 X163.456 Y115.302 E-.10509
G1 X163.569 Y115.255 E-.04658
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
; COOLING_NODE: 11
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
; COOLING_NODE: 10
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
G1 X180.86 Y150.312 Z1.6 F60000
G1 X175.17 Y150.766 Z1.6
G1 Z1.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X175.969 Y150.766 E.0257
G1 X175.969 Y155.224 E.14336
G1 X166.431 Y155.224 E.30672
G1 X166.431 Y150.766 E.14336
G1 X175.11 Y150.766 E.27909
; COOLING_NODE: 0
M204 S10000
G1 X175.17 Y151.173 F60000
G1 F8843.478
M204 S8000
G1 X175.562 Y151.173 E.01261
G1 X175.562 Y154.817 E.11718
G1 X166.838 Y154.817 E.28054
G1 X166.838 Y151.173 E.11718
G1 X175.11 Y151.173 E.266
; COOLING_NODE: 1
M204 S250
G1 X175.17 Y151.565 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X175.17 Y154.425 E.08519
G1 X167.23 Y154.425 E.23651
G1 X167.23 Y151.565 E.08519
G1 X175.11 Y151.565 E.23472
; COOLING_NODE: 1
; WIPE_START
M204 S8000
G1 X175.152 Y153.565 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X169.922 Y148.006 Z1.6 F60000
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
G1 X168.544 Y141.868 Z1.6 F60000
G1 X187.71 Y142.509 Z1.6
G1 Z1.2
G1 E.8 F1800
G1 F8843.478
M204 S8000
G1 X176.291 Y142.509 E.3672
G1 X176.291 Y137.541 E.15976
G1 X188.509 Y137.541 E.3929
G1 X188.509 Y142.509 E.15976
G1 X187.77 Y142.509 E.02377
; COOLING_NODE: 2
M204 S10000
G1 X187.71 Y142.102 F60000
G1 F8843.478
M204 S8000
G1 X176.698 Y142.102 E.35411
G1 X176.698 Y137.948 E.13358
G1 X188.102 Y137.948 E.36672
G1 X188.102 Y142.102 E.13358
G1 X187.77 Y142.102 E.01068
; COOLING_NODE: 3
M204 S250
G1 X187.71 Y141.71 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X177.09 Y141.71 E.31633
G1 X177.09 Y138.34 E.10038
G1 X187.71 Y138.34 E.31633
G1 X187.71 Y141.65 E.09859
; COOLING_NODE: 3
; WIPE_START
M204 S8000
G1 X185.71 Y141.661 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X185.558 Y149.292 Z1.6 F60000
G1 X184.452 Y204.921 Z1.6
G1 Z1.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X184.367 Y204.89 E.00291
M73 P59 R8
G3 X185.026 Y199.947 I.931 J-2.391 E.21984
G1 X185.269 Y199.932 E.00783
G3 X184.597 Y204.967 I.029 J2.566 E.28303
G1 X184.509 Y204.939 E.00296
; COOLING_NODE: 3
M204 S10000
G1 X184.623 Y204.543 F60000
G1 F8843.478
M204 S8000
G1 X184.516 Y204.511 E.00359
G3 X185.07 Y200.352 I.783 J-2.012 E.18497
G1 X185.274 Y200.34 E.00656
G3 X184.925 Y204.625 I.025 J2.159 E.23097
G1 X184.68 Y204.559 E.00816
; COOLING_NODE: 3
M204 S10000
G1 X184.732 Y204.152 F60000
G1 F8843.478
M204 S8000
G1 X184.664 Y204.131 E.00229
G3 X185.114 Y200.757 I.635 J-1.632 E.15011
G1 X185.278 Y200.747 E.00528
G3 X184.996 Y204.224 I.021 J1.751 E.18742
G1 X184.79 Y204.168 E.00686
; COOLING_NODE: 4
M204 S250
G1 X184.838 Y203.776 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X184.807 Y203.766 E.00096
G3 X185.157 Y201.147 I.492 J-1.267 E.10794
G1 X185.283 Y201.14 E.00376
G3 X185.064 Y203.838 I.017 J1.359 E.13475
G1 X184.896 Y203.792 E.0052
; COOLING_NODE: 4
; WIPE_START
M204 S8000
G1 X184.807 Y203.766 E-.03505
G1 X184.56 Y203.641 E-.10534
G1 X184.355 Y203.478 E-.09946
G1 X184.185 Y203.279 E-.09933
G1 X184.057 Y203.052 E-.09906
G1 X183.973 Y202.8 E-.10119
G1 X183.94 Y202.525 E-.10519
G1 X183.96 Y202.264 E-.09945
G1 X183.972 Y202.224 E-.01594
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X184.395 Y194.603 Z1.6 F60000
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
G1 X181.641 Y195.334 E.42607
G1 X160.916 Y195.334 E.66644
G1 X160.916 Y193.531 E.05796
G1 X166.466 Y193.531 E.17847
G1 X166.466 Y177.459 E.51683
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
; COOLING_NODE: 4
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
; COOLING_NODE: 4
M204 S10000
G1 X187.71 Y129.948 F60000
G1 F8843.478
M204 S8000
G1 X188.102 Y129.948 E.01261
G1 X188.102 Y134.102 E.13358
G1 X176.698 Y134.102 E.36672
G1 X176.698 Y129.948 E.13358
G1 X187.65 Y129.948 E.35218
; COOLING_NODE: 5
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
; COOLING_NODE: 5
; WIPE_START
M204 S8000
G1 X187.686 Y132.34 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X183.222 Y138.531 Z1.6 F60000
G1 X161.864 Y168.159 Z1.6
G1 Z1.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X161.065 Y168.159 E.0257
G1 X161.065 Y159.641 E.27392
G1 X170.324 Y159.641 E.29774
G1 X170.324 Y168.159 E.27392
G1 X161.924 Y168.159 E.27012
; COOLING_NODE: 5
M204 S10000
G1 X161.864 Y167.752 F60000
G1 F8843.478
M204 S8000
G1 X161.472 Y167.752 E.01261
G1 X161.472 Y160.048 E.24774
G1 X169.917 Y160.048 E.27156
G1 X169.917 Y167.752 E.24774
G1 X161.924 Y167.752 E.25703
; COOLING_NODE: 6
M204 S250
G1 X161.864 Y167.36 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X161.864 Y160.44 E.20612
G1 X169.525 Y160.44 E.22819
G1 X169.525 Y167.36 E.20612
G1 X161.924 Y167.36 E.22641
; COOLING_NODE: 6
; WIPE_START
M204 S8000
G1 X161.907 Y165.36 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X163.539 Y172.816 Z1.6 F60000
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
; COOLING_NODE: 6
M204 S10000
G1 X165.652 Y184.325 F60000
G1 F8843.478
M204 S8000
G1 X165.652 Y184.717 E.01261
G1 X161.748 Y184.717 E.12554
G1 X161.748 Y178.273 E.20722
G1 X165.652 Y178.273 E.12554
G1 X165.652 Y184.265 E.19268
; COOLING_NODE: 7
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
; COOLING_NODE: 7
; WIPE_START
M204 S8000
G1 X163.26 Y184.303 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X165.775 Y191.51 Z1.6 F60000
G1 X166.059 Y192.325 Z1.6
G1 Z1.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X166.059 Y193.124 E.0257
G1 X161.341 Y193.124 E.15172
G1 X161.341 Y185.866 E.2334
G1 X166.059 Y185.866 E.15172
G1 X166.059 Y192.265 E.20577
; COOLING_NODE: 7
M204 S10000
G1 X165.652 Y192.325 F60000
G1 F8843.478
M204 S8000
G1 X165.652 Y192.717 E.01261
G1 X161.748 Y192.717 E.12554
G1 X161.748 Y186.273 E.20722
G1 X165.652 Y186.273 E.12554
G1 X165.652 Y192.265 E.19268
; COOLING_NODE: 8
M204 S250
G1 X165.26 Y192.325 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X162.14 Y192.325 E.09293
G1 X162.14 Y186.665 E.16859
G1 X165.26 Y186.665 E.09293
G1 X165.26 Y192.265 E.1668
; COOLING_NODE: 8
; WIPE_START
M204 S8000
G1 X163.26 Y192.303 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X166.972 Y185.634 Z1.6 F60000
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
G1 X181.234 Y195.741 E.42607
G1 X160.509 Y195.741 E.66644
G1 X160.509 Y132.519 E2.03298
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
G1 X167.726 Y134.83 Z1.6 F60000
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
G1 X180.827 Y196.148 E.42607
G1 X160.102 Y196.148 E.66644
G1 X160.102 Y132.112 E2.05916
G1 X169.102 Y132.112 E.28941
; COOLING_NODE: 10
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
M73 P60 R8
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
G1 X180.435 Y196.54 E.39467
G1 X159.71 Y196.54 E.61733
G1 X159.71 Y131.72 E1.93077
G1 X168.71 Y131.72 E.26808
; WIPE_START
G1 F9547.055
M204 S8000
G1 X168.74 Y129.72 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X167.959 Y133.09 Z1.6 F60000
G1 Z1.2
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42003
G1 F9546.286
M204 S8000
G1 X167.699 Y133.349 E.01093
G1 X167.699 Y133.882 E.01589
G1 X168.322 Y133.259 E.02625
G1 X168.856 Y133.259 E.01589
G1 X167.699 Y134.416 E.04871
G1 X167.699 Y134.949 E.01589
G1 X169.389 Y133.259 E.07118
G1 X169.922 Y133.259 E.01589
G1 X167.53 Y135.652 E.1008
; WIPE_START
G1 X168.944 Y134.238 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X166.755 Y132.56 Z1.6 F60000
G1 Z1.2
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
G1 X161.375 Y133.13 Z1.6 F60000
G1 Z1.2
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
M204 S10000
G1 X161.445 Y153.47 F60000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42003
G1 F9546.286
M204 S8000
G1 X161.249 Y153.665 E.00824
G1 X161.249 Y154.199 E.01589
G1 X161.809 Y153.639 E.02356
G1 X162.342 Y153.639 E.01589
G1 X161.249 Y154.732 E.04602
G1 X161.249 Y155.265 E.01589
G1 X162.875 Y153.639 E.06849
G1 X163.408 Y153.639 E.01589
G1 X161.249 Y155.798 E.09096
G1 X161.249 Y156.332 E.01589
G1 X163.942 Y153.639 E.11343
G1 X164.475 Y153.639 E.01589
G1 X161.249 Y156.865 E.13589
G1 X161.249 Y157.398 E.01589
G1 X165.008 Y153.639 E.15836
G1 X165.542 Y153.639 E.01589
G1 X161.249 Y157.932 E.18083
G1 X161.249 Y158.465 E.01589
G1 X165.691 Y154.024 E.1871
G1 X165.691 Y154.557 E.01589
G1 X161.347 Y158.901 E.18299
G1 X161.88 Y158.901 E.01589
G1 X165.691 Y155.09 E.16052
G1 X165.691 Y155.624 E.01589
G1 X162.414 Y158.901 E.13805
G1 X162.947 Y158.901 E.01589
G1 X165.883 Y155.964 E.1237
G1 X166.417 Y155.964 E.01589
G1 X163.48 Y158.901 E.1237
G1 X164.014 Y158.901 E.01589
G1 X166.95 Y155.964 E.1237
G1 X167.483 Y155.964 E.01589
G1 X164.547 Y158.901 E.1237
G1 X165.08 Y158.901 E.01589
G1 X168.017 Y155.964 E.1237
G1 X168.55 Y155.964 E.01589
G1 X165.614 Y158.901 E.1237
G1 X166.147 Y158.901 E.01589
G1 X169.083 Y155.964 E.1237
G1 X169.616 Y155.964 E.01589
G1 X166.68 Y158.901 E.1237
G1 X167.214 Y158.901 E.01589
G1 X170.15 Y155.964 E.1237
G1 X170.683 Y155.964 E.01589
G1 X167.747 Y158.901 E.1237
G1 X168.28 Y158.901 E.01589
G1 X171.216 Y155.964 E.1237
G1 X171.75 Y155.964 E.01589
G1 X168.813 Y158.901 E.1237
G1 X169.347 Y158.901 E.01589
G1 X172.283 Y155.964 E.1237
G1 X172.816 Y155.964 E.01589
G1 X169.88 Y158.901 E.1237
G1 X170.413 Y158.901 E.01589
G1 X173.35 Y155.964 E.1237
G1 X173.883 Y155.964 E.01589
G1 X170.947 Y158.901 E.1237
G1 X171.064 Y158.901 E.0035
G1 X171.064 Y159.316 E.01238
G1 X174.416 Y155.964 E.14121
G1 X174.95 Y155.964 E.01589
G1 X171.064 Y159.85 E.16368
G1 X171.064 Y160.383 E.01589
G1 X175.483 Y155.964 E.18615
G1 X176.016 Y155.964 E.01589
G1 X171.064 Y160.916 E.20861
G1 X171.064 Y161.45 E.01589
G1 X181.326 Y151.188 E.43229
G1 X181.326 Y151.722 E.01589
G1 X171.064 Y161.983 E.43229
G1 X171.064 Y162.516 E.01589
G1 X181.326 Y152.255 E.43229
G1 X181.326 Y152.788 E.01589
G1 X171.064 Y163.05 E.43229
G1 X171.064 Y163.583 E.01589
G1 X181.326 Y153.322 E.43229
G1 X181.326 Y153.855 E.01589
G1 X171.064 Y164.116 E.43229
G1 X171.064 Y164.649 E.01589
G1 X181.326 Y154.388 E.43229
G1 X181.326 Y154.921 E.01589
G1 X171.064 Y165.183 E.43229
G1 X171.064 Y165.716 E.01589
G1 X181.326 Y155.455 E.43229
G1 X181.326 Y155.988 E.01589
G1 X171.064 Y166.249 E.43229
G1 X171.064 Y166.783 E.01589
G1 X181.326 Y156.521 E.43229
G1 X181.326 Y157.055 E.01589
G1 X171.064 Y167.316 E.43229
G1 X171.064 Y167.849 E.01589
G1 X181.326 Y157.588 E.43229
G1 X181.326 Y158.121 E.01589
G1 X170.895 Y168.552 E.43944
; WIPE_START
G1 X172.309 Y167.138 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X166.704 Y172.319 Z1.6 F60000
G1 X160.925 Y177.662 Z1.6
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
G1 X166.263 Y185.495 Z1.6 F60000
G1 Z1.2
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
G1 X160.925 Y193.328 E.25713
; WIPE_START
G1 X160.925 Y191.328 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X161.08 Y194.367 Z1.6 F60000
G1 Z1.2
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42003
G1 F9546.286
M204 S8000
G1 X161.582 Y193.864 E.02116
G1 X162.115 Y193.864 E.01589
G1 X161.249 Y194.73 E.03648
G1 X161.249 Y195.001 E.00805
G1 X161.512 Y195.001 E.00784
G1 X162.649 Y193.864 E.04787
G1 X163.182 Y193.864 E.01589
G1 X162.046 Y195.001 E.04787
G1 X162.579 Y195.001 E.01589
G1 X163.715 Y193.864 E.04787
G1 X164.249 Y193.864 E.01589
G1 X163.112 Y195.001 E.04787
G1 X163.646 Y195.001 E.01589
G1 X164.782 Y193.864 E.04787
G1 X165.315 Y193.864 E.01589
G1 X164.179 Y195.001 E.04787
G1 X164.712 Y195.001 E.01589
G1 X165.849 Y193.864 E.04787
G1 X166.382 Y193.864 E.01589
G1 X165.076 Y195.17 E.05502
; WIPE_START
G1 X166.382 Y193.864 E-.70182
G1 X166.229 Y193.864 E-.05818
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X173.166 Y197.047 Z1.6 F60000
G1 X182.785 Y201.46 Z1.6
G1 Z1.2
G1 E.8 F1800
G1 F9546.286
M204 S8000
G1 X181.974 Y202.271 E.03417
G1 X181.974 Y202.804 E.01589
G1 X182.407 Y202.372 E.01823
G1 X182.426 Y202.886 E.01533
G1 X181.974 Y203.338 E.01903
G1 X181.974 Y203.871 E.01589
G1 X182.523 Y203.322 E.02312
G1 X182.541 Y203.401 E.00241
G1 X182.674 Y203.705 E.00988
G1 X181.974 Y204.404 E.02946
G1 X181.974 Y204.938 E.01589
G1 X182.86 Y204.052 E.03732
G1 X183.079 Y204.367 E.01142
M73 P61 R8
G1 X181.974 Y205.471 E.04652
G1 X181.974 Y206.004 E.01589
G1 X183.342 Y204.637 E.0576
G2 X183.638 Y204.874 I1.383 J-1.424 E.01132
G1 X181.974 Y206.538 E.07007
G1 X181.974 Y207.071 E.01589
G1 X183.968 Y205.077 E.08399
G1 X184.348 Y205.23 E.01221
G1 X181.974 Y207.604 E.10001
G1 X181.974 Y208.137 E.01589
G1 X184.762 Y205.35 E.11744
G2 X185.254 Y205.391 I.466 J-2.603 E.01473
G1 X182.395 Y208.251 E.12047
G1 X182.928 Y208.251 E.01589
G1 X185.839 Y205.34 E.12264
G1 X186.196 Y205.261 E.01088
G1 X186.648 Y205.064 E.01468
G1 X183.461 Y208.251 E.13424
G1 X183.994 Y208.251 E.01589
G1 X188.035 Y204.21 E.17022
G1 X188.151 Y204.152 E.00386
G1 X188.151 Y204.628 E.01419
G1 X184.528 Y208.251 E.15262
G1 X185.061 Y208.251 E.01589
G1 X188.151 Y205.161 E.13016
G1 X188.151 Y205.694 E.01589
G1 X185.594 Y208.251 E.10769
G1 X186.128 Y208.251 E.01589
G1 X188.151 Y206.228 E.08522
G1 X188.151 Y206.761 E.01589
G1 X186.661 Y208.251 E.06275
G1 X187.194 Y208.251 E.01589
G1 X188.151 Y207.294 E.04029
G1 X188.151 Y207.828 E.01589
G1 X187.558 Y208.42 E.02497
; WIPE_START
G1 X188.151 Y207.828 E-.31849
G1 X188.151 Y207.294 E-.20266
G1 X187.706 Y207.739 E-.23885
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
M204 S10000
G1 X187.546 Y200.966 F60000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42003
G1 F9546.286
M204 S8000
G1 X188.151 Y200.361 E.02549
G1 X188.151 Y199.828 E.01589
G1 X187.433 Y200.545 E.03022
G1 X187.164 Y200.282 E.01123
G1 X188.151 Y199.295 E.04158
G1 X188.151 Y198.761 E.01589
G1 X186.858 Y200.054 E.05444
G2 X186.508 Y199.871 I-.797 J1.102 E.01182
G1 X188.151 Y198.228 E.06921
G1 X188.151 Y197.695 E.01589
G1 X186.126 Y199.719 E.0853
G1 X185.68 Y199.632 E.01353
G1 X188.151 Y197.161 E.10408
G1 X188.151 Y196.628 E.01589
G1 X185.167 Y199.612 E.12572
G2 X184.542 Y199.703 I.034 J2.423 E.01884
G1 X188.151 Y196.095 E.15201
G1 X188.151 Y195.561 E.01589
G1 X181.974 Y201.738 E.26019
G1 X181.974 Y201.204 E.01589
G1 X188.151 Y195.028 E.26019
G1 X188.151 Y194.495 E.01589
G1 X181.974 Y200.671 E.26019
G1 X181.974 Y200.138 E.01589
G1 X188.151 Y193.961 E.26019
G1 X188.151 Y193.428 E.01589
G1 X181.974 Y199.604 E.26019
G1 X181.974 Y199.071 E.01589
G1 X188.151 Y192.895 E.26019
G1 X188.151 Y192.362 E.01589
G1 X181.974 Y198.538 E.26019
G1 X181.974 Y198.005 E.01589
G1 X188.151 Y191.828 E.26019
G1 X188.151 Y191.295 E.01589
G1 X181.974 Y197.471 E.26019
G1 X181.974 Y196.938 E.01589
G1 X188.151 Y190.762 E.26019
G1 X188.151 Y190.228 E.01589
G1 X181.974 Y196.405 E.26019
G1 X181.974 Y195.871 E.01589
G1 X188.151 Y189.695 E.26019
G1 X188.151 Y189.162 E.01589
G1 X181.974 Y195.338 E.26019
G1 X181.974 Y195.001 E.01005
G1 X181.778 Y195.001 E.00584
G1 X188.151 Y188.628 E.26845
G1 X188.151 Y188.095 E.01589
G1 X181.245 Y195.001 E.29092
G1 X180.712 Y195.001 E.01589
G1 X188.151 Y187.562 E.31339
G1 X188.151 Y187.028 E.01589
G1 X180.178 Y195.001 E.33585
G1 X179.645 Y195.001 E.01589
G1 X188.151 Y186.495 E.35832
G1 X188.151 Y185.962 E.01589
G1 X179.112 Y195.001 E.38079
G1 X178.578 Y195.001 E.01589
G1 X188.151 Y185.428 E.40326
G1 X188.151 Y184.895 E.01589
G1 X178.045 Y195.001 E.42572
G1 X177.512 Y195.001 E.01589
G1 X188.151 Y184.362 E.44819
G1 X188.151 Y183.829 E.01589
G1 X176.979 Y195.001 E.47066
G1 X176.445 Y195.001 E.01589
G1 X188.151 Y183.295 E.49313
G1 X188.151 Y182.844 E.01343
G1 X188.068 Y182.844 E.00246
G1 X175.912 Y195.001 E.51212
G1 X175.379 Y195.001 E.01589
G1 X187.535 Y182.844 E.51212
G1 X187.002 Y182.844 E.01589
G1 X174.845 Y195.001 E.51212
G1 X174.312 Y195.001 E.01589
G1 X186.468 Y182.844 E.51212
G1 X185.935 Y182.844 E.01589
G1 X173.779 Y195.001 E.51212
G1 X173.245 Y195.001 E.01589
G1 X185.402 Y182.844 E.51212
G1 X184.868 Y182.844 E.01589
G1 X172.712 Y195.001 E.51212
G1 X172.179 Y195.001 E.01589
G1 X184.335 Y182.844 E.51212
G1 X183.802 Y182.844 E.01589
G1 X171.645 Y195.001 E.51212
G1 X171.112 Y195.001 E.01589
G1 X183.268 Y182.844 E.51212
G1 X182.735 Y182.844 E.01589
G1 X170.579 Y195.001 E.51212
G1 X170.045 Y195.001 E.01589
G1 X182.202 Y182.844 E.51212
G1 X181.668 Y182.844 E.01589
G1 X169.512 Y195.001 E.51212
G1 X168.979 Y195.001 E.01589
G1 X181.326 Y182.654 E.52015
G1 X181.326 Y182.121 E.01589
G1 X168.445 Y195.001 E.54261
G1 X167.912 Y195.001 E.01589
G1 X181.326 Y181.587 E.56508
G1 X181.326 Y181.054 E.01589
G1 X167.379 Y195.001 E.58755
G1 X166.846 Y195.001 E.01589
G1 X181.326 Y180.521 E.61002
G1 X181.326 Y179.987 E.01589
G1 X166.312 Y195.001 E.63248
G1 X165.779 Y195.001 E.01589
G1 X181.326 Y179.454 E.65495
G1 X181.326 Y178.921 E.01589
G1 X166.799 Y193.447 E.61196
G1 X166.799 Y192.914 E.01589
G1 X181.326 Y178.387 E.61196
G1 X181.326 Y177.854 E.01589
G1 X166.799 Y192.38 E.61196
G1 X166.799 Y191.847 E.01589
G1 X181.326 Y177.321 E.61196
G1 X181.326 Y176.787 E.01589
G1 X166.799 Y191.314 E.61196
G1 X166.799 Y190.78 E.01589
G1 X181.326 Y176.254 E.61196
G1 X181.326 Y175.721 E.01589
G1 X166.799 Y190.247 E.61196
G1 X166.799 Y189.714 E.01589
G1 X181.326 Y175.187 E.61196
G1 X181.326 Y174.654 E.01589
G1 X166.799 Y189.18 E.61196
G1 X166.799 Y188.647 E.01589
G1 X181.326 Y174.121 E.61196
G1 X181.326 Y173.587 E.01589
G1 X166.799 Y188.114 E.61196
G1 X166.799 Y187.58 E.01589
G1 X181.326 Y173.054 E.61196
G1 X181.326 Y172.521 E.01589
G1 X166.799 Y187.047 E.61196
G1 X166.799 Y186.514 E.01589
G1 X181.326 Y171.988 E.61196
G1 X181.326 Y171.454 E.01589
G1 X166.799 Y185.981 E.61196
G1 X166.799 Y185.447 E.01589
G1 X181.326 Y170.921 E.61196
G1 X181.326 Y170.388 E.01589
G1 X166.799 Y184.914 E.61196
G1 X166.799 Y184.381 E.01589
G1 X181.326 Y169.854 E.61196
G1 X181.326 Y169.321 E.01589
G1 X166.799 Y183.847 E.61196
G1 X166.799 Y183.314 E.01589
G1 X181.326 Y168.788 E.61196
G1 X181.326 Y168.254 E.01589
G1 X166.799 Y182.781 E.61196
G1 X166.799 Y182.247 E.01589
G1 X181.326 Y167.721 E.61196
G1 X181.326 Y167.188 E.01589
G1 X166.799 Y181.714 E.61196
G1 X166.799 Y181.181 E.01589
G1 X181.326 Y166.654 E.61196
G1 X181.326 Y166.121 E.01589
G1 X166.799 Y180.647 E.61196
G1 X166.799 Y180.114 E.01589
G1 X181.326 Y165.588 E.61196
G1 X181.326 Y165.054 E.01589
G1 X166.799 Y179.581 E.61196
G1 X166.799 Y179.047 E.01589
G1 X181.326 Y164.521 E.61196
G1 X181.326 Y163.988 E.01589
G1 X166.799 Y178.514 E.61196
G1 X166.799 Y177.981 E.01589
G1 X181.326 Y163.455 E.61196
G1 X181.326 Y162.921 E.01589
G1 X166.799 Y177.447 E.61196
G1 X166.799 Y177.126 E.00959
G1 X166.588 Y177.126 E.0063
G1 X181.326 Y162.388 E.62087
G1 X181.326 Y161.855 E.01589
G1 X166.055 Y177.126 E.64334
G1 X165.521 Y177.126 E.01589
G1 X181.326 Y161.321 E.66581
G1 X181.326 Y160.788 E.01589
G1 X164.988 Y177.126 E.68827
G1 X164.455 Y177.126 E.01589
G1 X181.326 Y160.255 E.71074
G1 X181.326 Y159.721 E.01589
M73 P61 R7
G1 X163.921 Y177.126 E.73321
G1 X163.388 Y177.126 E.01589
M73 P62 R7
G1 X181.326 Y159.188 E.75568
G1 X181.326 Y158.655 E.01589
G1 X162.855 Y177.126 E.77814
G1 X162.321 Y177.126 E.01589
G1 X170.548 Y168.899 E.34656
G1 X170.014 Y168.899 E.01589
G1 X161.788 Y177.126 E.34656
G1 X161.255 Y177.126 E.01589
G1 X169.481 Y168.899 E.34656
G1 X168.948 Y168.899 E.01589
G1 X161.249 Y176.598 E.32432
G1 X161.249 Y176.064 E.01589
G1 X168.414 Y168.899 E.30185
G1 X167.881 Y168.899 E.01589
G1 X161.249 Y175.531 E.27938
G1 X161.249 Y174.998 E.01589
G1 X167.348 Y168.899 E.25691
G1 X166.814 Y168.899 E.01589
G1 X161.249 Y174.464 E.23445
G1 X161.249 Y173.931 E.01589
G1 X166.281 Y168.899 E.21198
G1 X165.748 Y168.899 E.01589
G1 X161.249 Y173.398 E.18951
G1 X161.249 Y172.865 E.01589
G1 X165.214 Y168.899 E.16704
G1 X164.681 Y168.899 E.01589
G1 X161.249 Y172.331 E.14458
G1 X161.249 Y171.798 E.01589
G1 X164.148 Y168.899 E.12211
G1 X163.615 Y168.899 E.01589
G1 X161.249 Y171.265 E.09964
G1 X161.249 Y170.731 E.01589
G1 X163.081 Y168.899 E.07717
G1 X162.548 Y168.899 E.01589
G1 X161.249 Y170.198 E.05471
G1 X161.249 Y169.665 E.01589
G1 X162.015 Y168.899 E.03224
G1 X161.481 Y168.899 E.01589
G1 X161.08 Y169.301 E.01692
M204 S10000
G1 X160.787 Y168.363 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.19158
G1 F15000
M204 S8000
G1 X160.787 Y159.437 E.10481
; WIPE_START
G1 X160.787 Y161.437 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X161.297 Y153.822 Z1.6 F60000
G1 X162.037 Y142.75 Z1.6
G1 Z1.2
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
G1 X166.63 Y145.618 Z1.6 F60000
G1 Z1.2
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42003
G1 F9546.286
M204 S8000
G1 X176.999 Y135.249 E.43682
G1 X176.465 Y135.249 E.01589
G1 X166.799 Y144.915 E.40721
G1 X166.799 Y144.382 E.01589
G1 X175.932 Y135.249 E.38474
G1 X175.551 Y135.249 E.01136
G1 X175.551 Y135.097 E.00453
G1 X166.799 Y143.849 E.36867
G1 X166.799 Y143.315 E.01589
G1 X167.145 Y142.97 E.01456
M204 S10000
G1 X167.53 Y142.585 F60000
G1 F9546.286
M204 S8000
G1 X175.551 Y134.564 E.33791
G1 X175.551 Y134.031 E.01589
G1 X167.699 Y141.882 E.33076
G1 X167.699 Y141.349 E.01589
G1 X175.551 Y133.497 E.33076
G1 X175.551 Y132.964 E.01589
G1 X167.699 Y140.815 E.33076
G1 X167.699 Y140.282 E.01589
G1 X175.551 Y132.431 E.33076
G1 X175.551 Y131.898 E.01589
G1 X167.699 Y139.749 E.33076
G1 X167.699 Y139.216 E.01589
G1 X175.551 Y131.364 E.33076
G1 X175.551 Y130.831 E.01589
G1 X167.699 Y138.682 E.33076
G1 X167.699 Y138.149 E.01589
G1 X175.551 Y130.298 E.33076
G1 X175.551 Y129.764 E.01589
G1 X167.699 Y137.616 E.33076
G1 X167.699 Y137.082 E.01589
G1 X175.532 Y129.249 E.32998
G1 X174.999 Y129.249 E.01589
G1 X167.699 Y136.549 E.30752
G1 X167.699 Y136.016 E.01589
G1 X174.466 Y129.249 E.28505
G1 X173.932 Y129.249 E.01589
G1 X170.309 Y132.872 E.15263
G1 X170.309 Y132.339 E.01589
G1 X173.399 Y129.249 E.13016
G1 X172.866 Y129.249 E.01589
G1 X170.309 Y131.806 E.10769
G1 X170.309 Y131.272 E.01589
G1 X172.332 Y129.249 E.08523
G1 X171.799 Y129.249 E.01589
G1 X170.309 Y130.739 E.06276
G1 X170.309 Y130.206 E.01589
G1 X171.266 Y129.249 E.04029
G1 X170.732 Y129.249 E.01589
G1 X170.14 Y129.842 E.02497
; WIPE_START
G1 X170.732 Y129.249 E-.31854
G1 X171.266 Y129.249 E-.20266
G1 X170.821 Y129.694 E-.2388
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
G1 X188.32 Y136.194 Z1.6 F60000
G1 Z1.2
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42003
G1 F9546.286
M204 S8000
G1 X187.714 Y136.801 E.02556
G1 X187.18 Y136.801 E.01589
G1 X188.151 Y135.83 E.04088
G1 X188.151 Y135.297 E.01589
G1 X186.647 Y136.801 E.06335
G1 X186.114 Y136.801 E.01589
G1 X187.665 Y135.249 E.06535
G1 X187.132 Y135.249 E.01589
G1 X185.58 Y136.801 E.06535
G1 X185.047 Y136.801 E.01589
G1 X186.598 Y135.249 E.06535
G1 X186.065 Y135.249 E.01589
G1 X184.514 Y136.801 E.06535
G1 X183.98 Y136.801 E.01589
G1 X185.532 Y135.249 E.06535
G1 X184.998 Y135.249 E.01589
G1 X183.447 Y136.801 E.06535
G1 X182.914 Y136.801 E.01589
G1 X184.465 Y135.249 E.06535
G1 X183.932 Y135.249 E.01589
G1 X182.38 Y136.801 E.06535
G1 X181.847 Y136.801 E.01589
G1 X183.398 Y135.249 E.06535
G1 X182.865 Y135.249 E.01589
G1 X181.314 Y136.801 E.06535
G1 X180.781 Y136.801 E.01589
G1 X182.332 Y135.249 E.06535
G1 X181.798 Y135.249 E.01589
G1 X180.247 Y136.801 E.06535
G1 X179.714 Y136.801 E.01589
G1 X181.265 Y135.249 E.06535
G1 X180.732 Y135.249 E.01589
G1 X179.181 Y136.801 E.06535
G1 X178.647 Y136.801 E.01589
G1 X180.199 Y135.249 E.06535
G1 X179.665 Y135.249 E.01589
G1 X178.114 Y136.801 E.06535
G1 X177.581 Y136.801 E.01589
G1 X179.132 Y135.249 E.06535
G1 X178.599 Y135.249 E.01589
G1 X177.047 Y136.801 E.06535
G1 X176.514 Y136.801 E.01589
G1 X178.065 Y135.249 E.06535
G1 X177.532 Y135.249 E.01589
G1 X175.981 Y136.801 E.06535
G1 X175.551 Y136.801 E.01281
G1 X175.551 Y137.231 E.01281
G1 X166.799 Y145.982 E.36867
G1 X166.799 Y146.515 E.01589
G1 X175.551 Y137.764 E.36867
G1 X175.551 Y138.297 E.01589
G1 X166.799 Y147.049 E.36867
G1 X166.799 Y147.582 E.01589
G1 X175.551 Y138.831 E.36867
G1 X175.551 Y139.364 E.01589
G1 X166.799 Y148.115 E.36867
G1 X166.799 Y148.649 E.01589
G1 X175.551 Y139.897 E.36867
G1 X175.551 Y140.431 E.01589
G1 X166.799 Y149.182 E.36867
G1 X166.799 Y149.715 E.01589
G1 X175.551 Y140.964 E.36867
G1 X175.551 Y141.497 E.01589
G1 X167.022 Y150.026 E.35929
G1 X167.556 Y150.026 E.01589
G1 X175.551 Y142.03 E.33682
G1 X175.551 Y142.564 E.01589
G1 X168.089 Y150.026 E.31435
G1 X168.622 Y150.026 E.01589
G1 X175.551 Y143.097 E.29188
G1 X175.551 Y143.249 E.00454
G1 X175.932 Y143.249 E.01135
G1 X169.155 Y150.026 E.28547
G1 X169.689 Y150.026 E.01589
G1 X176.465 Y143.249 E.28547
G1 X176.998 Y143.249 E.01589
G1 X170.222 Y150.026 E.28547
G1 X170.755 Y150.026 E.01589
G1 X177.532 Y143.249 E.28547
G1 X178.065 Y143.249 E.01589
G1 X171.289 Y150.026 E.28547
G1 X171.822 Y150.026 E.01589
G1 X178.598 Y143.249 E.28547
G1 X179.132 Y143.249 E.01589
G1 X172.355 Y150.026 E.28547
G1 X172.889 Y150.026 E.01589
G1 X179.665 Y143.249 E.28547
G1 X180.198 Y143.249 E.01589
G1 X173.422 Y150.026 E.28547
G1 X173.955 Y150.026 E.01589
G1 X180.732 Y143.249 E.28547
G1 X181.265 Y143.249 E.01589
G1 X174.489 Y150.026 E.28547
G1 X175.022 Y150.026 E.01589
G1 X181.798 Y143.249 E.28547
G1 X182.331 Y143.249 E.01589
G1 X175.555 Y150.026 E.28547
G1 X176.089 Y150.026 E.01589
G1 X182.865 Y143.249 E.28547
G1 X183.398 Y143.249 E.01589
G1 X176.622 Y150.026 E.28547
G1 X176.709 Y150.026 E.00261
G1 X176.709 Y150.471 E.01328
G1 X183.931 Y143.249 E.30425
G1 X184.465 Y143.249 E.01589
G1 X176.709 Y151.005 E.32672
G1 X176.709 Y151.538 E.01589
G1 X181.326 Y146.922 E.19447
G1 X181.326 Y147.455 E.01589
G1 X176.709 Y152.071 E.19447
G1 X176.709 Y152.605 E.01589
G1 X181.326 Y147.988 E.19447
G1 X181.326 Y148.522 E.01589
G1 X176.709 Y153.138 E.19447
G1 X176.709 Y153.671 E.01589
G1 X181.326 Y149.055 E.19447
G1 X181.326 Y149.588 E.01589
G1 X176.709 Y154.205 E.19447
G1 X176.709 Y154.738 E.01589
G1 X181.326 Y150.122 E.19447
G1 X181.326 Y150.655 E.01589
G1 X176.54 Y155.441 E.20162
; WIPE_START
G1 X177.954 Y154.027 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X181.446 Y147.24 Z1.6 F60000
G1 X181.912 Y146.335 Z1.6
G1 Z1.2
G1 E.8 F1800
G1 F9546.286
M204 S8000
G1 X184.998 Y143.249 E.13
G1 X185.531 Y143.249 E.01589
G1 X182.615 Y146.166 E.12286
G1 X183.148 Y146.166 E.01589
G1 X186.065 Y143.249 E.12286
G1 X186.598 Y143.249 E.01589
G1 X183.682 Y146.166 E.12286
G1 X184.215 Y146.166 E.01589
G1 X187.131 Y143.249 E.12286
G1 X187.665 Y143.249 E.01589
G1 X184.748 Y146.166 E.12286
G1 X185.282 Y146.166 E.01589
G1 X188.151 Y143.297 E.12086
G1 X188.151 Y143.83 E.01589
G1 X185.815 Y146.166 E.0984
G1 X186.348 Y146.166 E.01589
G1 X188.151 Y144.363 E.07593
G1 X188.151 Y144.897 E.01589
G1 X186.882 Y146.166 E.05346
G1 X187.415 Y146.166 E.01589
G1 X188.151 Y145.43 E.03099
G1 X188.151 Y145.963 E.01589
G1 X187.779 Y146.335 E.01567
; WIPE_START
G1 X188.151 Y145.963 E-.19996
G1 X188.151 Y145.43 E-.20266
G1 X187.486 Y146.095 E-.35739
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
; COOLING_NODE: 11
; WIPE_START
G1 X189.12 Y181.926 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X186.492 Y174.76 Z1.6 F60000
G1 X166.884 Y121.274 Z1.6
G1 Z1.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X160.916 Y121.274 E.1919
G1 X160.916 Y111.416 E.31698
G1 X166.884 Y111.416 E.1919
G1 X166.884 Y116.237 E.15501
G1 X166.66 Y116.255 E.00723
G2 X166.57 Y117.204 I-2.556 J.236 E.48775
G2 X166.654 Y116.739 I-2.169 J-.637 E.01522
G1 X166.884 Y116.754 E.00739
G1 X166.884 Y121.214 E.14343
; COOLING_NODE: 11
; WIPE_START
G1 X164.884 Y121.234 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X162.028 Y117.078 Z1.6 F60000
G1 Z1.2
G1 E.8 F1800
G1 F8843.478
M204 S8000
G1 X161.988 Y116.953 E.00423
G3 X163.871 Y114.352 I2.111 J-.454 E.11645
G1 X164.074 Y114.34 E.00654
G3 X162.122 Y117.368 I.025 J2.159 E.29919
G1 X162.047 Y117.135 E.00785
; COOLING_NODE: 11
M204 S10000
G1 X162.414 Y116.954 F60000
G1 F8843.478
M204 S8000
G1 X162.386 Y116.867 E.00293
G3 X163.915 Y114.757 I1.713 J-.368 E.09447
G1 X164.078 Y114.747 E.00526
G3 X162.496 Y117.204 I.021 J1.752 E.24275
G1 X162.433 Y117.011 E.00655
; COOLING_NODE: 11
M204 S250
G1 X162.786 Y116.834 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X162.77 Y116.784 E.00156
G3 X163.957 Y115.147 I1.329 J-.284 E.0679
G1 X164.083 Y115.14 E.00374
G3 X162.855 Y117.047 I.017 J1.359 E.1745
G1 X162.804 Y116.891 E.0049
; COOLING_NODE: 11
; WIPE_START
M204 S8000
G1 X162.77 Y116.784 E-.04275
G1 X162.74 Y116.525 E-.09889
G1 X162.76 Y116.264 E-.09954
G1 X162.83 Y116.013 E-.09877
G1 X162.947 Y115.779 E-.09952
G1 X163.121 Y115.555 E-.10798
G1 X163.225 Y115.459 E-.05376
G1 X163.441 Y115.31 E-.09948
G1 X163.584 Y115.248 E-.05931
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X167.291 Y121.681 Z1.6 F60000
G1 Z1.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X160.509 Y121.681 E.21808
G1 X160.509 Y111.009 E.34316
G1 X167.291 Y111.009 E.21808
G1 X167.291 Y121.621 E.34123
; COOLING_NODE: 11
M204 S10000
G1 X168.09 Y121.292 F60000
G1 F8843.478
M204 S8000
G1 X168.098 Y121.292 E.00025
G1 X168.098 Y122.088 E.02559
M73 P63 R7
G1 X160.102 Y122.088 E.25712
G1 X160.102 Y110.602 E.36934
G1 X167.698 Y110.602 E.24426
G1 X167.698 Y121.292 E.34375
G1 X168.03 Y121.292 E.01068
; COOLING_NODE: 10
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
G1 X180.86 Y150.312 Z1.8 F60000
G1 X175.17 Y150.766 Z1.8
G1 Z1.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X175.969 Y150.766 E.0257
G1 X175.969 Y155.224 E.14336
G1 X166.431 Y155.224 E.30672
G1 X166.431 Y150.766 E.14336
G1 X175.11 Y150.766 E.27909
; COOLING_NODE: 0
M204 S10000
G1 X175.17 Y151.173 F60000
G1 F8843.478
M204 S8000
G1 X175.562 Y151.173 E.01261
G1 X175.562 Y154.817 E.11718
G1 X166.838 Y154.817 E.28054
G1 X166.838 Y151.173 E.11718
G1 X175.11 Y151.173 E.266
; COOLING_NODE: 1
M204 S250
G1 X175.17 Y151.565 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X175.17 Y154.425 E.08519
G1 X167.23 Y154.425 E.23651
G1 X167.23 Y151.565 E.08519
G1 X175.11 Y151.565 E.23472
; COOLING_NODE: 1
; WIPE_START
M204 S8000
G1 X175.152 Y153.565 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X169.922 Y148.006 Z1.8 F60000
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
G1 X168.544 Y141.868 Z1.8 F60000
G1 X187.71 Y142.509 Z1.8
G1 Z1.4
G1 E.8 F1800
G1 F8843.478
M204 S8000
G1 X176.291 Y142.509 E.3672
G1 X176.291 Y137.541 E.15976
G1 X188.509 Y137.541 E.3929
G1 X188.509 Y142.509 E.15976
G1 X187.77 Y142.509 E.02377
; COOLING_NODE: 2
M204 S10000
G1 X187.71 Y142.102 F60000
G1 F8843.478
M204 S8000
G1 X176.698 Y142.102 E.35411
G1 X176.698 Y137.948 E.13358
G1 X188.102 Y137.948 E.36672
G1 X188.102 Y142.102 E.13358
G1 X187.77 Y142.102 E.01068
; COOLING_NODE: 3
M204 S250
G1 X187.71 Y141.71 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X177.09 Y141.71 E.31633
G1 X177.09 Y138.34 E.10038
G1 X187.71 Y138.34 E.31633
G1 X187.71 Y141.65 E.09859
; COOLING_NODE: 3
; WIPE_START
M204 S8000
G1 X185.71 Y141.661 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X185.554 Y149.292 Z1.8 F60000
G1 X184.416 Y204.899 Z1.8
G1 Z1.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X184.129 Y204.784 E.00992
G3 X185.029 Y199.946 I1.168 J-2.285 E.21165
G1 X185.285 Y199.932 E.00825
G3 X184.587 Y204.965 I.012 J2.566 E.28279
G1 X184.471 Y204.92 E.00397
; COOLING_NODE: 3
M204 S10000
G1 X184.565 Y204.522 F60000
G1 F8843.478
M204 S8000
G1 X184.316 Y204.422 E.00865
G3 X185.072 Y200.352 I.982 J-1.923 E.17807
G1 X185.288 Y200.34 E.00695
G3 X184.701 Y204.574 I.01 J2.159 E.23789
G1 X184.621 Y204.543 E.00273
; COOLING_NODE: 3
M204 S10000
G1 X184.715 Y204.145 F60000
G1 F8843.478
M204 S8000
G1 X184.502 Y204.059 E.00737
G3 X185.116 Y200.757 I.796 J-1.56 E.14449
G1 X185.291 Y200.747 E.00565
G3 X184.815 Y204.183 I.008 J1.752 E.19299
G1 X184.771 Y204.166 E.0015
; COOLING_NODE: 4
M204 S250
G1 X184.859 Y203.782 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X184.682 Y203.711 E.00568
G3 X185.157 Y201.147 I.617 J-1.211 E.10389
G1 X185.294 Y201.14 E.00407
G3 X184.925 Y203.806 I.006 J1.359 E.1387
G1 X184.915 Y203.803 E.0003
; COOLING_NODE: 4
; WIPE_START
M204 S8000
G1 X184.682 Y203.711 E-.09522
G1 X184.444 Y203.557 E-.10762
G1 X184.257 Y203.373 E-.09962
G1 X184.102 Y203.144 E-.1051
G1 X183.999 Y202.898 E-.10137
G1 X183.947 Y202.642 E-.09929
G1 X183.947 Y202.359 E-.10768
G1 X183.97 Y202.245 E-.04409
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X184.393 Y194.624 Z1.8 F60000
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
G1 X181.641 Y195.334 E.42607
G1 X160.916 Y195.334 E.66644
G1 X160.916 Y193.531 E.05796
G1 X166.466 Y193.531 E.17847
G1 X166.466 Y177.459 E.51683
G1 X160.916 Y177.459 E.17847
G1 X160.916 Y168.566 E.28595
G1 X170.731 Y168.566 E.31561
G1 X170.731 Y159.234 E.3001
G1 X160.916 Y159.234 E.31561
G1 X160.916 Y153.306 E.19061
M73 P64 R7
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
; COOLING_NODE: 4
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
; COOLING_NODE: 4
M204 S10000
G1 X187.71 Y129.948 F60000
G1 F8843.478
M204 S8000
G1 X188.102 Y129.948 E.01261
G1 X188.102 Y134.102 E.13358
G1 X176.698 Y134.102 E.36672
G1 X176.698 Y129.948 E.13358
G1 X187.65 Y129.948 E.35218
; COOLING_NODE: 5
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
; COOLING_NODE: 5
; WIPE_START
M204 S8000
G1 X187.686 Y132.34 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X183.222 Y138.531 Z1.8 F60000
G1 X161.864 Y168.159 Z1.8
G1 Z1.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X161.065 Y168.159 E.0257
G1 X161.065 Y159.641 E.27392
G1 X170.324 Y159.641 E.29774
G1 X170.324 Y168.159 E.27392
G1 X161.924 Y168.159 E.27012
; COOLING_NODE: 5
M204 S10000
G1 X161.864 Y167.752 F60000
G1 F8843.478
M204 S8000
G1 X161.472 Y167.752 E.01261
G1 X161.472 Y160.048 E.24774
G1 X169.917 Y160.048 E.27156
G1 X169.917 Y167.752 E.24774
G1 X161.924 Y167.752 E.25703
; COOLING_NODE: 6
M204 S250
G1 X161.864 Y167.36 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X161.864 Y160.44 E.20612
G1 X169.525 Y160.44 E.22819
G1 X169.525 Y167.36 E.20612
G1 X161.924 Y167.36 E.22641
; COOLING_NODE: 6
; WIPE_START
M204 S8000
G1 X161.907 Y165.36 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X163.539 Y172.816 Z1.8 F60000
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
; COOLING_NODE: 6
M204 S10000
G1 X165.652 Y184.325 F60000
G1 F8843.478
M204 S8000
G1 X165.652 Y184.717 E.01261
G1 X161.748 Y184.717 E.12554
G1 X161.748 Y178.273 E.20722
G1 X165.652 Y178.273 E.12554
G1 X165.652 Y184.265 E.19268
; COOLING_NODE: 7
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
; COOLING_NODE: 7
; WIPE_START
M204 S8000
G1 X163.26 Y184.303 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X165.775 Y191.51 Z1.8 F60000
G1 X166.059 Y192.325 Z1.8
G1 Z1.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X166.059 Y193.124 E.0257
G1 X161.341 Y193.124 E.15172
G1 X161.341 Y185.866 E.2334
G1 X166.059 Y185.866 E.15172
G1 X166.059 Y192.265 E.20577
; COOLING_NODE: 7
M204 S10000
G1 X165.652 Y192.325 F60000
G1 F8843.478
M204 S8000
G1 X165.652 Y192.717 E.01261
G1 X161.748 Y192.717 E.12554
G1 X161.748 Y186.273 E.20722
G1 X165.652 Y186.273 E.12554
G1 X165.652 Y192.265 E.19268
; COOLING_NODE: 8
M204 S250
G1 X165.26 Y192.325 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X162.14 Y192.325 E.09293
G1 X162.14 Y186.665 E.16859
G1 X165.26 Y186.665 E.09293
G1 X165.26 Y192.265 E.1668
; COOLING_NODE: 8
; WIPE_START
M204 S8000
G1 X163.26 Y192.303 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X166.972 Y185.634 Z1.8 F60000
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
G1 X181.234 Y195.741 E.42607
G1 X160.509 Y195.741 E.66644
G1 X160.509 Y132.519 E2.03298
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
G1 X167.726 Y134.83 Z1.8 F60000
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
G1 X180.827 Y196.148 E.42607
G1 X160.102 Y196.148 E.66644
G1 X160.102 Y132.112 E2.05916
G1 X169.102 Y132.112 E.28941
; COOLING_NODE: 10
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
G1 X180.435 Y196.54 E.39467
G1 X159.71 Y196.54 E.61733
M73 P65 R7
G1 X159.71 Y131.72 E1.93077
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
G1 X166.236 Y156.584 Z1.8 F60000
G1 X168.646 Y159.07 Z1.8
G1 Z1.4
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42209
G1 F9494.421
M204 S8000
G1 X163.215 Y153.639 E.23005
G1 X162.679 Y153.639 E.01606
G1 X167.94 Y158.901 E.22286
G1 X167.404 Y158.901 E.01606
G1 X162.143 Y153.639 E.22286
G1 X161.606 Y153.639 E.01606
G1 X166.868 Y158.901 E.22286
G1 X166.331 Y158.901 E.01606
G1 X161.249 Y153.819 E.21527
G1 X161.249 Y154.355 E.01606
G1 X165.795 Y158.901 E.19256
G1 X165.259 Y158.901 E.01606
G1 X161.249 Y154.891 E.16984
G1 X161.249 Y155.427 E.01606
G1 X164.723 Y158.901 E.14713
G1 X164.187 Y158.901 E.01606
G1 X161.249 Y155.963 E.12441
G1 X161.249 Y156.5 E.01606
G1 X163.65 Y158.901 E.1017
G1 X163.114 Y158.901 E.01606
G1 X161.249 Y157.036 E.07899
G1 X161.249 Y157.572 E.01606
G1 X162.578 Y158.901 E.05627
G1 X162.042 Y158.901 E.01606
G1 X161.249 Y158.108 E.03356
G1 X161.249 Y158.645 E.01606
G1 X161.675 Y159.07 E.01803
M204 S10000
G1 X160.787 Y159.437 F60000
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
G1 X164.319 Y173.129 Z1.8 F60000
G1 X166.494 Y177.295 Z1.8
G1 Z1.4
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42209
G1 F9494.421
M204 S8000
G1 X161.249 Y172.05 E.22217
G1 X161.249 Y172.586 E.01606
G1 X165.789 Y177.126 E.19227
G1 X165.252 Y177.126 E.01606
G1 X161.249 Y173.123 E.16956
G1 X161.249 Y173.659 E.01606
G1 X164.716 Y177.126 E.14684
G1 X164.18 Y177.126 E.01606
G1 X161.249 Y174.195 E.12413
G1 X161.249 Y174.731 E.01606
G1 X163.644 Y177.126 E.10142
G1 X163.107 Y177.126 E.01606
G1 X161.249 Y175.268 E.0787
G1 X161.249 Y175.804 E.01606
G1 X162.571 Y177.126 E.05599
G1 X162.035 Y177.126 E.01606
G1 X161.249 Y176.34 E.03328
G1 X161.249 Y176.876 E.01606
G1 X161.668 Y177.295 E.01775
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
G1 X160.925 Y193.328 E.25713
; WIPE_START
G1 X160.925 Y191.328 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X161.08 Y194.402 Z1.8 F60000
G1 Z1.4
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42209
G1 F9494.421
M204 S8000
G1 X161.678 Y195.001 E.02535
G1 X162.214 Y195.001 E.01606
G1 X161.249 Y194.036 E.04088
G1 X161.249 Y193.864 E.00513
G1 X161.614 Y193.864 E.01093
G1 X162.751 Y195.001 E.04813
G1 X163.287 Y195.001 E.01606
G1 X162.151 Y193.864 E.04813
G1 X162.687 Y193.864 E.01606
G1 X163.823 Y195.001 E.04813
G1 X164.359 Y195.001 E.01606
G1 X163.223 Y193.864 E.04813
G1 X163.759 Y193.864 E.01606
G1 X164.896 Y195.001 E.04813
G1 X165.432 Y195.001 E.01606
G1 X164.296 Y193.864 E.04813
G1 X164.832 Y193.864 E.01606
G1 X165.968 Y195.001 E.04813
G1 X166.504 Y195.001 E.01606
G1 X165.368 Y193.864 E.04813
G1 X165.904 Y193.864 E.01606
G1 X167.04 Y195.001 E.04813
G1 X167.577 Y195.001 E.01606
G1 X166.44 Y193.864 E.04813
G1 X166.799 Y193.864 E.01075
G1 X166.799 Y193.687 E.00531
G1 X168.113 Y195.001 E.05564
G1 X168.649 Y195.001 E.01606
G1 X166.799 Y193.151 E.07835
G1 X166.799 Y192.615 E.01606
G1 X169.185 Y195.001 E.10107
G1 X169.722 Y195.001 E.01606
G1 X166.799 Y192.078 E.12378
G1 X166.799 Y191.542 E.01606
G1 X170.258 Y195.001 E.14649
G1 X170.794 Y195.001 E.01606
G1 X166.799 Y191.006 E.16921
G1 X166.799 Y190.47 E.01606
G1 X171.33 Y195.001 E.19192
G1 X171.867 Y195.001 E.01606
G1 X166.799 Y189.933 E.21464
G1 X166.799 Y189.397 E.01606
G1 X172.403 Y195.001 E.23735
G1 X172.939 Y195.001 E.01606
G1 X166.799 Y188.861 E.26006
G1 X166.799 Y188.325 E.01606
G1 X173.475 Y195.001 E.28278
G1 X174.011 Y195.001 E.01606
G1 X166.799 Y187.789 E.30549
G1 X166.799 Y187.252 E.01606
G1 X174.548 Y195.001 E.3282
G1 X175.084 Y195.001 E.01606
G1 X166.799 Y186.716 E.35092
G1 X166.799 Y186.18 E.01606
G1 X175.62 Y195.001 E.37363
G1 X176.156 Y195.001 E.01606
G1 X166.799 Y185.644 E.39634
G1 X166.799 Y185.107 E.01606
G1 X176.693 Y195.001 E.41906
G1 X177.229 Y195.001 E.01606
G1 X166.799 Y184.571 E.44177
G1 X166.799 Y184.035 E.01606
G1 X177.765 Y195.001 E.46448
G1 X178.301 Y195.001 E.01606
G1 X166.799 Y183.499 E.4872
G1 X166.799 Y182.963 E.01606
G1 X178.837 Y195.001 E.50991
G1 X179.374 Y195.001 E.01606
G1 X166.799 Y182.426 E.53263
G1 X166.799 Y181.89 E.01606
G1 X179.91 Y195.001 E.55534
G1 X180.446 Y195.001 E.01606
G1 X166.799 Y181.354 E.57805
G1 X166.799 Y180.818 E.01606
G1 X180.982 Y195.001 E.60077
G1 X181.519 Y195.001 E.01606
G1 X166.799 Y180.281 E.62348
G1 X166.799 Y179.745 E.01606
G1 X187.956 Y200.902 E.89616
G1 X188.151 Y200.868 E.00592
G1 X188.151 Y200.56 E.0092
G1 X166.799 Y179.209 E.9044
G1 X166.799 Y178.673 E.01606
G1 X188.151 Y200.024 E.9044
G1 X188.151 Y199.488 E.01606
G1 X166.799 Y178.136 E.9044
G1 X166.799 Y177.6 E.01606
G1 X188.151 Y198.952 E.9044
G1 X188.151 Y198.415 E.01606
G1 X161.249 Y171.514 E1.13949
G1 X161.249 Y170.978 E.01606
G1 X188.151 Y197.879 E1.13949
G1 X188.151 Y197.343 E.01606
G1 X161.249 Y170.442 E1.13949
G1 X161.249 Y169.905 E.01606
G1 X188.151 Y196.807 E1.13949
G1 X188.151 Y196.27 E.01606
G1 X161.249 Y169.369 E1.13949
G1 X161.249 Y168.899 E.01407
M73 P66 R7
G1 X161.316 Y168.899 E.00199
G1 X188.151 Y195.734 E1.13667
G1 X188.151 Y195.198 E.01606
G1 X161.852 Y168.899 E1.11396
G1 X162.388 Y168.899 E.01606
G1 X188.151 Y194.662 E1.09124
G1 X188.151 Y194.125 E.01606
G1 X162.925 Y168.899 E1.06853
G1 X163.461 Y168.899 E.01606
G1 X188.151 Y193.589 E1.04582
G1 X188.151 Y193.053 E.01606
G1 X163.997 Y168.899 E1.0231
G1 X164.533 Y168.899 E.01606
G1 X188.151 Y192.517 E1.00039
G1 X188.151 Y191.981 E.01606
G1 X165.069 Y168.899 E.97768
G1 X165.606 Y168.899 E.01606
G1 X188.151 Y191.444 E.95496
G1 X188.151 Y190.908 E.01606
G1 X166.142 Y168.899 E.93225
G1 X166.678 Y168.899 E.01606
G1 X188.32 Y190.542 E.91672
; WIPE_START
G1 X186.906 Y189.127 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X186.729 Y196.758 Z1.8 F60000
G1 X186.651 Y200.133 Z1.8
G1 Z1.4
G1 E.8 F1800
G1 F9494.421
M204 S8000
G1 X181.974 Y195.456 E.19808
G1 X181.974 Y195.993 E.01606
G1 X185.597 Y199.616 E.15346
G1 X185.058 Y199.613 E.01614
G1 X181.974 Y196.529 E.13063
G1 X181.974 Y197.065 E.01606
G1 X184.603 Y199.694 E.11135
G2 X184.201 Y199.828 I.143 J1.099 E.01277
G1 X181.974 Y197.601 E.09432
G1 X181.974 Y198.138 E.01606
G1 X183.836 Y199.999 E.07885
G2 X183.516 Y200.215 I.935 J1.73 E.01159
G1 X181.974 Y198.674 E.06529
G1 X181.974 Y199.21 E.01606
G1 X183.231 Y200.467 E.05324
G2 X182.988 Y200.76 I.872 J.973 E.01145
G1 X181.974 Y199.746 E.04293
G1 X181.974 Y200.282 E.01606
G1 X182.774 Y201.082 E.03385
G1 X182.607 Y201.451 E.01215
G1 X181.974 Y200.819 E.0268
G1 X181.974 Y201.355 E.01606
G1 X182.481 Y201.862 E.02148
G2 X182.407 Y202.324 I1.528 J.482 E.01407
G1 X181.974 Y201.891 E.01834
G1 X181.974 Y202.427 E.01606
G1 X182.43 Y202.883 E.01929
G2 X182.62 Y203.609 I2.515 J-.27 E.02257
G1 X181.974 Y202.964 E.02734
G1 X181.974 Y203.5 E.01606
G1 X186.725 Y208.251 E.20124
G1 X187.261 Y208.251 E.01606
G1 X184.171 Y205.16 E.1309
G2 X184.917 Y205.37 I.924 J-1.86 E.02332
G1 X187.798 Y208.251 E.12204
G1 X188.151 Y208.251 E.01057
G1 X188.151 Y208.067 E.00549
G1 X185.473 Y205.39 E.11342
G2 X185.945 Y205.326 I-.105 J-2.546 E.01429
G1 X188.151 Y207.531 E.09342
G1 X188.151 Y206.995 E.01606
G1 X186.348 Y205.193 E.07634
G1 X186.718 Y205.026 E.01215
G1 X188.151 Y206.459 E.06067
G1 X188.151 Y205.922 E.01606
G1 X187.04 Y204.812 E.04703
G2 X187.333 Y204.569 I-.677 J-1.112 E.01145
G1 X188.151 Y205.386 E.03463
G1 X188.151 Y204.85 E.01606
G1 X187.584 Y204.284 E.02398
G2 X187.743 Y204.061 I-1.002 J-.879 E.00821
G1 X187.93 Y204.093 E.0057
G1 X188.32 Y204.483 E.01652
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
G1 X186.359 Y208.42 Z1.8 F60000
G1 Z1.4
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42209
G1 F9494.421
M204 S8000
G1 X181.974 Y204.036 E.18571
G1 X181.974 Y204.572 E.01606
G1 X185.653 Y208.251 E.15581
G1 X185.117 Y208.251 E.01606
G1 X181.974 Y205.109 E.1331
G1 X181.974 Y205.645 E.01606
G1 X184.58 Y208.251 E.11038
G1 X184.044 Y208.251 E.01606
G1 X181.974 Y206.181 E.08767
G1 X181.974 Y206.717 E.01606
G1 X183.508 Y208.251 E.06495
G1 X182.972 Y208.251 E.01606
G1 X181.974 Y207.253 E.04224
G1 X181.974 Y207.79 E.01606
G1 X182.605 Y208.42 E.02671
; WIPE_START
G1 X181.974 Y207.79 E-.33893
G1 X181.974 Y207.253 E-.20377
G1 X182.379 Y207.658 E-.2173
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X180.096 Y200.375 Z1.8 F60000
G1 X162.037 Y142.75 Z1.8
G1 Z1.4
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.33758
G1 F12217.47
M204 S8000
G1 X166.263 Y142.75 E.09834
; WIPE_START
G1 X164.263 Y142.75 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X167.457 Y135.818 Z1.8 F60000
G1 X170.14 Y129.999 Z1.8
G1 Z1.4
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42209
G1 F9494.421
M204 S8000
G1 X176.941 Y136.801 E.28811
G1 X176.405 Y136.801 E.01606
G1 X170.309 Y130.705 E.2582
G1 X170.309 Y131.241 E.01606
G1 X175.869 Y136.801 E.23549
G1 X175.551 Y136.801 E.00953
G1 X175.551 Y137.019 E.00653
G1 X170.309 Y131.777 E.22201
G1 X170.309 Y132.314 E.01606
G1 X175.551 Y137.555 E.22201
G1 X175.551 Y138.091 E.01606
G1 X170.309 Y132.85 E.22201
G1 X170.309 Y133.259 E.01227
G1 X170.183 Y133.259 E.00379
G1 X175.551 Y138.627 E.22738
G1 X175.551 Y139.164 E.01606
G1 X169.646 Y133.259 E.25009
G1 X169.11 Y133.259 E.01606
G1 X175.551 Y139.7 E.2728
G1 X175.551 Y140.236 E.01606
G1 X168.574 Y133.259 E.29552
G1 X168.038 Y133.259 E.01606
G1 X175.551 Y140.772 E.31823
G1 X175.551 Y141.308 E.01606
G1 X167.699 Y133.457 E.33257
G1 X167.699 Y133.993 E.01606
G1 X175.551 Y141.845 E.33257
G1 X175.551 Y142.381 E.01606
G1 X167.699 Y134.53 E.33257
G1 X167.699 Y135.066 E.01606
G1 X181.326 Y148.692 E.57718
G1 X181.326 Y148.156 E.01606
G1 X176.419 Y143.249 E.20783
G1 X176.955 Y143.249 E.01606
G1 X181.326 Y147.62 E.18512
G1 X181.326 Y147.083 E.01606
G1 X177.492 Y143.249 E.1624
G1 X178.028 Y143.249 E.01606
G1 X181.326 Y146.547 E.13969
G1 X181.326 Y146.166 E.01143
G1 X181.48 Y146.166 E.00463
G1 X178.564 Y143.249 E.12353
G1 X179.1 Y143.249 E.01606
G1 X182.017 Y146.166 E.12353
G1 X182.553 Y146.166 E.01606
G1 X179.636 Y143.249 E.12353
G1 X180.173 Y143.249 E.01606
G1 X183.089 Y146.166 E.12353
G1 X183.625 Y146.166 E.01606
G1 X180.709 Y143.249 E.12353
G1 X181.245 Y143.249 E.01606
G1 X184.161 Y146.166 E.12353
G1 X184.698 Y146.166 E.01606
G1 X181.781 Y143.249 E.12353
G1 X182.318 Y143.249 E.01606
G1 X185.234 Y146.166 E.12353
G1 X185.77 Y146.166 E.01606
G1 X182.854 Y143.249 E.12353
G1 X183.39 Y143.249 E.01606
G1 X186.306 Y146.166 E.12353
G1 X186.843 Y146.166 E.01606
G1 X183.926 Y143.249 E.12353
G1 X184.463 Y143.249 E.01606
G1 X187.379 Y146.166 E.12353
G1 X187.915 Y146.166 E.01606
G1 X184.999 Y143.249 E.12353
G1 X185.535 Y143.249 E.01606
G1 X188.151 Y145.865 E.1108
G1 X188.151 Y145.329 E.01606
G1 X186.071 Y143.249 E.08808
G1 X186.607 Y143.249 E.01606
G1 X188.151 Y144.793 E.06537
G1 X188.151 Y144.256 E.01606
G1 X187.144 Y143.249 E.04265
G1 X187.68 Y143.249 E.01606
G1 X188.32 Y143.89 E.02713
; WIPE_START
G1 X187.68 Y143.249 E-.34418
G1 X187.144 Y143.249 E-.20377
G1 X187.538 Y143.644 E-.21206
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
G1 X187.961 Y182.675 Z1.8 F60000
G1 Z1.4
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42209
G1 F9494.421
M204 S8000
G1 X188.151 Y182.865 E.00805
G1 X188.151 Y183.401 E.01606
G1 X187.594 Y182.844 E.02358
G1 X187.058 Y182.844 E.01606
G1 X188.151 Y183.937 E.04629
G1 X188.151 Y184.473 E.01606
G1 X186.522 Y182.844 E.069
G1 X185.985 Y182.844 E.01606
G1 X188.151 Y185.01 E.09172
G1 X188.151 Y185.546 E.01606
G1 X185.449 Y182.844 E.11443
G1 X184.913 Y182.844 E.01606
G1 X188.151 Y186.082 E.13714
G1 X188.151 Y186.618 E.01606
G1 X184.377 Y182.844 E.15986
G1 X183.84 Y182.844 E.01606
G1 X188.151 Y187.155 E.18257
M73 P66 R6
G1 X188.151 Y187.691 E.01606
G1 X183.304 Y182.844 E.20528
G1 X182.768 Y182.844 E.01606
G1 X188.151 Y188.227 E.228
G1 X188.151 Y188.763 E.01606
G1 X182.232 Y182.844 E.25071
G1 X181.696 Y182.844 E.01606
G1 X188.151 Y189.299 E.27342
G1 X188.151 Y189.836 E.01606
G1 X167.214 Y168.899 E.88682
G1 X167.751 Y168.899 E.01606
G1 X181.326 Y182.474 E.57501
G1 X181.326 Y181.938 E.01606
G1 X168.287 Y168.899 E.5523
G1 X168.823 Y168.899 E.01606
G1 X181.326 Y181.402 E.52959
G1 X181.326 Y180.866 E.01606
G1 X169.359 Y168.899 E.50687
G1 X169.895 Y168.899 E.01606
G1 X181.326 Y180.33 E.48416
G1 X181.326 Y179.793 E.01606
G1 X170.432 Y168.899 E.46145
G1 X170.968 Y168.899 E.01606
G1 X181.326 Y179.257 E.43873
G1 X181.326 Y178.721 E.01606
G1 X171.064 Y168.46 E.43465
G1 X171.064 Y167.923 E.01606
G1 X181.326 Y178.185 E.43465
G1 X181.326 Y177.648 E.01606
G1 X171.064 Y167.387 E.43465
G1 X171.064 Y166.851 E.01606
G1 X181.326 Y177.112 E.43465
G1 X181.326 Y176.576 E.01606
G1 X171.064 Y166.315 E.43465
G1 X171.064 Y165.778 E.01606
G1 X181.326 Y176.04 E.43465
G1 X181.326 Y175.503 E.01606
G1 X171.064 Y165.242 E.43465
G1 X171.064 Y164.706 E.01606
G1 X181.326 Y174.967 E.43465
G1 X181.326 Y174.431 E.01606
G1 X171.064 Y164.17 E.43465
G1 X171.064 Y163.634 E.01606
G1 X181.326 Y173.895 E.43465
G1 X181.326 Y173.359 E.01606
G1 X171.064 Y163.097 E.43465
G1 X171.064 Y162.561 E.01606
G1 X181.326 Y172.822 E.43465
G1 X181.326 Y172.286 E.01606
G1 X171.064 Y162.025 E.43465
G1 X171.064 Y161.489 E.01606
G1 X181.326 Y171.75 E.43465
G1 X181.326 Y171.214 E.01606
M73 P67 R6
G1 X171.064 Y160.952 E.43465
G1 X171.064 Y160.416 E.01606
G1 X181.326 Y170.677 E.43465
G1 X181.326 Y170.141 E.01606
G1 X171.064 Y159.88 E.43465
G1 X171.064 Y159.344 E.01606
G1 X181.495 Y169.775 E.44184
; WIPE_START
G1 X180.081 Y168.36 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X180.903 Y160.772 Z1.8 F60000
G1 X181.495 Y155.297 Z1.8
G1 Z1.4
G1 E.8 F1800
G1 F9494.421
M204 S8000
G1 X176.709 Y150.511 E.20272
G1 X176.709 Y151.047 E.01606
G1 X181.326 Y155.663 E.19554
G1 X181.326 Y156.199 E.01606
G1 X176.709 Y151.583 E.19554
G1 X176.709 Y152.119 E.01606
G1 X181.326 Y156.736 E.19554
G1 X181.326 Y157.272 E.01606
G1 X176.709 Y152.655 E.19554
G1 X176.709 Y153.192 E.01606
G1 X181.326 Y157.808 E.19554
G1 X181.326 Y158.344 E.01606
G1 X176.709 Y153.728 E.19554
G1 X176.709 Y154.264 E.01606
G1 X181.326 Y158.88 E.19554
G1 X181.326 Y159.417 E.01606
G1 X176.709 Y154.8 E.19554
G1 X176.709 Y155.337 E.01606
G1 X181.326 Y159.953 E.19554
G1 X181.326 Y160.489 E.01606
G1 X176.709 Y155.873 E.19554
G1 X176.709 Y155.964 E.00274
G1 X176.265 Y155.964 E.01332
G1 X181.326 Y161.025 E.21437
G1 X181.326 Y161.562 E.01606
G1 X175.728 Y155.964 E.23709
G1 X175.192 Y155.964 E.01606
G1 X181.326 Y162.098 E.2598
G1 X181.326 Y162.634 E.01606
G1 X174.656 Y155.964 E.28251
G1 X174.12 Y155.964 E.01606
G1 X181.326 Y163.17 E.30523
G1 X181.326 Y163.706 E.01606
G1 X173.584 Y155.964 E.32794
G1 X173.047 Y155.964 E.01606
G1 X181.326 Y164.243 E.35066
G1 X181.326 Y164.779 E.01606
G1 X172.511 Y155.964 E.37337
G1 X171.975 Y155.964 E.01606
G1 X181.326 Y165.315 E.39608
G1 X181.326 Y165.851 E.01606
G1 X171.439 Y155.964 E.4188
G1 X170.902 Y155.964 E.01606
G1 X181.326 Y166.388 E.44151
G1 X181.326 Y166.924 E.01606
G1 X170.366 Y155.964 E.46422
G1 X169.83 Y155.964 E.01606
G1 X181.326 Y167.46 E.48694
G1 X181.326 Y167.996 E.01606
G1 X169.294 Y155.964 E.50965
G1 X168.757 Y155.964 E.01606
G1 X181.326 Y168.533 E.53236
G1 X181.326 Y169.069 E.01606
G1 X168.221 Y155.964 E.55508
G1 X167.685 Y155.964 E.01606
G1 X170.621 Y158.901 E.12438
G1 X170.085 Y158.901 E.01606
G1 X167.149 Y155.964 E.12438
G1 X166.613 Y155.964 E.01606
G1 X169.549 Y158.901 E.12438
G1 X169.013 Y158.901 E.01606
G1 X166.076 Y155.964 E.12438
G1 X165.691 Y155.964 E.01155
G1 X165.691 Y155.579 E.01155
G1 X163.751 Y153.639 E.08214
G1 X164.288 Y153.639 E.01606
G1 X165.691 Y155.042 E.05943
G1 X165.691 Y154.506 E.01606
G1 X164.824 Y153.639 E.03672
G1 X165.36 Y153.639 E.01606
G1 X165.86 Y154.14 E.02119
; WIPE_START
G1 X165.36 Y153.639 E-.26886
G1 X164.824 Y153.639 E-.20377
G1 X165.359 Y154.174 E-.28738
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X166.63 Y149.547 Z1.8 F60000
G1 Z1.4
G1 E.8 F1800
G1 F9494.421
M204 S8000
G1 X167.109 Y150.026 E.02028
G1 X167.645 Y150.026 E.01606
G1 X166.799 Y149.18 E.03581
G1 X166.799 Y148.644 E.01606
G1 X168.181 Y150.026 E.05852
G1 X168.717 Y150.026 E.01606
G1 X166.799 Y148.108 E.08124
G1 X166.799 Y147.572 E.01606
G1 X169.253 Y150.026 E.10395
G1 X169.79 Y150.026 E.01606
G1 X166.799 Y147.035 E.12667
G1 X166.799 Y146.499 E.01606
G1 X170.326 Y150.026 E.14938
G1 X170.862 Y150.026 E.01606
G1 X166.799 Y145.963 E.17209
G1 X166.799 Y145.427 E.01606
G1 X171.398 Y150.026 E.19481
G1 X171.935 Y150.026 E.01606
G1 X166.799 Y144.89 E.21752
G1 X166.799 Y144.354 E.01606
G1 X172.471 Y150.026 E.24023
G1 X173.007 Y150.026 E.01606
G1 X166.799 Y143.818 E.26295
G1 X166.799 Y143.282 E.01606
G1 X173.543 Y150.026 E.28566
G1 X174.08 Y150.026 E.01606
G1 X167.193 Y143.139 E.29169
G1 X167.699 Y143.139 E.01516
G1 X167.699 Y143.109 E.0009
G1 X174.616 Y150.026 E.29296
G1 X175.152 Y150.026 E.01606
G1 X167.699 Y142.573 E.31568
G1 X167.699 Y142.037 E.01606
G1 X175.688 Y150.026 E.33839
G1 X176.224 Y150.026 E.01606
G1 X167.699 Y141.501 E.36111
G1 X167.699 Y140.964 E.01606
G1 X181.326 Y154.591 E.57718
G1 X181.326 Y154.054 E.01606
G1 X167.699 Y140.428 E.57718
G1 X167.699 Y139.892 E.01606
G1 X181.326 Y153.518 E.57718
G1 X181.326 Y152.982 E.01606
G1 X167.699 Y139.356 E.57718
G1 X167.699 Y138.819 E.01606
G1 X181.326 Y152.446 E.57718
G1 X181.326 Y151.909 E.01606
G1 X167.699 Y138.283 E.57718
G1 X167.699 Y137.747 E.01606
G1 X181.326 Y151.373 E.57718
G1 X181.326 Y150.837 E.01606
G1 X167.699 Y137.211 E.57718
G1 X167.699 Y136.675 E.01606
G1 X181.326 Y150.301 E.57718
G1 X181.326 Y149.765 E.01606
G1 X167.699 Y136.138 E.57718
G1 X167.699 Y135.602 E.01606
G1 X181.495 Y149.398 E.58437
; WIPE_START
G1 X180.081 Y147.984 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X184.368 Y141.669 Z1.8 F60000
G1 X188.32 Y135.846 Z1.8
G1 Z1.4
G1 E.8 F1800
G1 F9494.421
M204 S8000
G1 X187.723 Y135.249 E.02529
G1 X187.187 Y135.249 E.01606
G1 X188.151 Y136.213 E.04082
G1 X188.151 Y136.749 E.01606
G1 X186.651 Y135.249 E.06353
G1 X186.115 Y135.249 E.01606
G1 X187.666 Y136.801 E.06571
G1 X187.13 Y136.801 E.01606
G1 X185.578 Y135.249 E.06571
G1 X185.042 Y135.249 E.01606
G1 X186.593 Y136.801 E.06571
G1 X186.057 Y136.801 E.01606
G1 X184.506 Y135.249 E.06571
G1 X183.97 Y135.249 E.01606
G1 X185.521 Y136.801 E.06571
G1 X184.985 Y136.801 E.01606
G1 X183.433 Y135.249 E.06571
G1 X182.897 Y135.249 E.01606
G1 X184.449 Y136.801 E.06571
G1 X183.912 Y136.801 E.01606
G1 X182.361 Y135.249 E.06571
G1 X181.825 Y135.249 E.01606
G1 X183.376 Y136.801 E.06571
G1 X182.84 Y136.801 E.01606
G1 X181.289 Y135.249 E.06571
G1 X180.752 Y135.249 E.01606
G1 X182.304 Y136.801 E.06571
G1 X181.767 Y136.801 E.01606
G1 X180.216 Y135.249 E.06571
G1 X179.68 Y135.249 E.01606
G1 X181.231 Y136.801 E.06571
G1 X180.695 Y136.801 E.01606
G1 X179.144 Y135.249 E.06571
G1 X178.607 Y135.249 E.01606
G1 X180.159 Y136.801 E.06571
G1 X179.622 Y136.801 E.01606
G1 X178.071 Y135.249 E.06571
G1 X177.535 Y135.249 E.01606
G1 X179.086 Y136.801 E.06571
G1 X178.55 Y136.801 E.01606
G1 X176.999 Y135.249 E.06571
G1 X176.463 Y135.249 E.01606
G1 X178.014 Y136.801 E.06571
G1 X177.478 Y136.801 E.01606
G1 X175.926 Y135.249 E.06571
G1 X175.551 Y135.249 E.01125
G1 X175.551 Y134.874 E.01125
G1 X170.309 Y129.632 E.22201
G1 X170.309 Y129.249 E.01147
G1 X170.463 Y129.249 E.00459
G1 X175.551 Y134.337 E.21552
G1 X175.551 Y133.801 E.01606
G1 X170.999 Y129.249 E.19281
G1 X171.535 Y129.249 E.01606
G1 X175.551 Y133.265 E.1701
G1 X175.551 Y132.729 E.01606
G1 X172.071 Y129.249 E.14738
G1 X172.607 Y129.249 E.01606
G1 X175.551 Y132.193 E.12467
G1 X175.551 Y131.656 E.01606
G1 X173.144 Y129.249 E.10196
G1 X173.68 Y129.249 E.01606
G1 X175.551 Y131.12 E.07924
G1 X175.551 Y130.584 E.01606
G1 X174.216 Y129.249 E.05653
G1 X174.752 Y129.249 E.01606
G1 X175.551 Y130.048 E.03381
G1 X175.551 Y129.511 E.01606
G1 X175.119 Y129.08 E.01829
M204 S10000
G1 X176.087 Y129.025 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.66758
G1 F5763.136
M204 S8000
G1 X188.687 Y129.025 E.62173
; COOLING_NODE: 11
; WIPE_START
G1 X186.687 Y129.025 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X179.58 Y126.243 Z1.8 F60000
G1 X166.884 Y121.274 Z1.8
G1 Z1.4
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
G2 X166.657 Y116.739 I-2.555 J.241 E.50327
G1 X166.884 Y116.756 E.0073
G1 X166.884 Y121.214 E.14335
; COOLING_NODE: 11
; WIPE_START
G1 X164.884 Y121.234 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X162.003 Y116.984 Z1.8 F60000
G1 Z1.4
G1 E.8 F1800
G1 F8843.478
M204 S8000
G1 X161.947 Y116.692 E.00955
G3 X163.872 Y114.352 I2.15 J-.193 E.10802
G1 X164.088 Y114.34 E.00695
G3 X162.026 Y117.107 I.01 J2.159 E.30768
G1 X162.014 Y117.043 E.0021
; COOLING_NODE: 11
M204 S10000
G1 X162.402 Y116.908 F60000
G1 F8843.478
M204 S8000
G1 X162.354 Y116.655 E.00829
G3 X163.916 Y114.757 I1.745 J-.156 E.0876
G1 X164.091 Y114.747 E.00565
G3 X162.418 Y116.992 I.008 J1.752 E.24965
G1 X162.413 Y116.967 E.00081
; COOLING_NODE: 11
M204 S250
G1 X162.786 Y116.836 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X162.745 Y116.619 E.00657
G3 X163.957 Y115.147 I1.354 J-.12 E.06293
G1 X164.094 Y115.14 E.00407
G3 X162.798 Y116.894 I.006 J1.359 E.17907
; COOLING_NODE: 11
; WIPE_START
M204 S8000
G1 X162.745 Y116.619 E-.10653
G1 X162.747 Y116.364 E-.09683
G1 X162.799 Y116.103 E-.1014
G1 X162.899 Y115.861 E-.09951
G1 X163.054 Y115.631 E-.10534
G1 X163.227 Y115.457 E-.09306
G1 X163.456 Y115.302 E-.10509
G1 X163.583 Y115.249 E-.05224
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X167.291 Y121.681 Z1.8 F60000
G1 Z1.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X160.509 Y121.681 E.21808
G1 X160.509 Y111.009 E.34316
G1 X167.291 Y111.009 E.21808
G1 X167.291 Y121.621 E.34123
; COOLING_NODE: 11
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
; COOLING_NODE: 10
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
M73 P68 R6
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
G1 X180.86 Y150.312 Z2 F60000
G1 X175.17 Y150.766 Z2
G1 Z1.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X175.969 Y150.766 E.0257
G1 X175.969 Y155.224 E.14336
G1 X166.431 Y155.224 E.30672
G1 X166.431 Y150.766 E.14336
G1 X175.11 Y150.766 E.27909
; COOLING_NODE: 0
M204 S10000
G1 X175.17 Y151.173 F60000
G1 F8843.478
M204 S8000
G1 X175.562 Y151.173 E.01261
G1 X175.562 Y154.817 E.11718
G1 X166.838 Y154.817 E.28054
G1 X166.838 Y151.173 E.11718
G1 X175.11 Y151.173 E.266
; COOLING_NODE: 1
M204 S250
G1 X175.17 Y151.565 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X175.17 Y154.425 E.08519
G1 X167.23 Y154.425 E.23651
G1 X167.23 Y151.565 E.08519
G1 X175.11 Y151.565 E.23472
; COOLING_NODE: 1
; WIPE_START
M204 S8000
G1 X175.152 Y153.565 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X169.922 Y148.006 Z2 F60000
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
G1 X168.544 Y141.868 Z2 F60000
G1 X187.71 Y142.509 Z2
G1 Z1.6
G1 E.8 F1800
G1 F8843.478
M204 S8000
G1 X176.291 Y142.509 E.3672
G1 X176.291 Y137.541 E.15976
G1 X188.509 Y137.541 E.3929
G1 X188.509 Y142.509 E.15976
G1 X187.77 Y142.509 E.02377
; COOLING_NODE: 2
M204 S10000
G1 X187.71 Y142.102 F60000
G1 F8843.478
M204 S8000
G1 X176.698 Y142.102 E.35411
G1 X176.698 Y137.948 E.13358
G1 X188.102 Y137.948 E.36672
G1 X188.102 Y142.102 E.13358
G1 X187.77 Y142.102 E.01068
; COOLING_NODE: 3
M204 S250
G1 X187.71 Y141.71 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X177.09 Y141.71 E.31633
G1 X177.09 Y138.34 E.10038
G1 X187.71 Y138.34 E.31633
G1 X187.71 Y141.65 E.09859
; COOLING_NODE: 3
; WIPE_START
M204 S8000
G1 X185.71 Y141.661 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X185.561 Y149.292 Z2 F60000
G1 X184.475 Y204.929 Z2
G1 Z1.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X184.367 Y204.89 E.00368
G3 X185.026 Y199.947 I.931 J-2.391 E.21984
G1 X185.269 Y199.932 E.00783
G3 X184.597 Y204.967 I.029 J2.566 E.28303
G1 X184.532 Y204.947 E.00218
; COOLING_NODE: 3
M204 S10000
G1 X184.647 Y204.55 F60000
G1 F8843.478
M204 S8000
G1 X184.516 Y204.511 E.00439
G3 X185.07 Y200.352 I.783 J-2.012 E.18497
G1 X185.274 Y200.34 E.00656
G3 X184.925 Y204.625 I.025 J2.159 E.23097
G1 X184.705 Y204.565 E.00736
; COOLING_NODE: 3
M204 S10000
G1 X184.756 Y204.159 F60000
G1 F8843.478
M204 S8000
G1 X184.664 Y204.131 E.0031
G3 X185.114 Y200.757 I.635 J-1.632 E.15011
G1 X185.278 Y200.747 E.00528
G3 X184.996 Y204.224 I.021 J1.751 E.18742
G1 X184.814 Y204.175 E.00606
; COOLING_NODE: 4
M204 S250
G1 X184.862 Y203.783 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X184.807 Y203.766 E.00171
G3 X185.157 Y201.147 I.492 J-1.267 E.10794
G1 X185.283 Y201.14 E.00376
G3 X185.064 Y203.838 I.017 J1.359 E.13475
G1 X184.92 Y203.799 E.00445
; COOLING_NODE: 4
; WIPE_START
M204 S8000
G1 X184.807 Y203.766 E-.04456
G1 X184.56 Y203.641 E-.10534
G1 X184.355 Y203.478 E-.09946
G1 X184.185 Y203.279 E-.09933
G1 X184.057 Y203.052 E-.09906
G1 X183.973 Y202.8 E-.10119
G1 X183.94 Y202.525 E-.10519
G1 X183.96 Y202.264 E-.09945
G1 X183.965 Y202.248 E-.00642
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X184.389 Y194.627 Z2 F60000
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
G1 X181.641 Y195.334 E.42607
G1 X160.916 Y195.334 E.66644
G1 X160.916 Y193.531 E.05796
G1 X166.466 Y193.531 E.17847
G1 X166.466 Y177.459 E.51683
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
; COOLING_NODE: 4
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
G1 X176.291 Y134.509 E.3929
G1 X176.291 Y129.541 E.15976
G1 X187.65 Y129.541 E.36527
; COOLING_NODE: 4
M204 S10000
G1 X187.71 Y129.948 F60000
G1 F8843.478
M204 S8000
G1 X188.102 Y129.948 E.01261
G1 X188.102 Y134.102 E.13358
G1 X176.698 Y134.102 E.36672
G1 X176.698 Y129.948 E.13358
G1 X187.65 Y129.948 E.35218
; COOLING_NODE: 5
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
; COOLING_NODE: 5
; WIPE_START
M204 S8000
G1 X187.686 Y132.34 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
M73 P69 R6
G1 X183.222 Y138.531 Z2 F60000
G1 X161.864 Y168.159 Z2
G1 Z1.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X161.065 Y168.159 E.0257
G1 X161.065 Y159.641 E.27392
G1 X170.324 Y159.641 E.29774
G1 X170.324 Y168.159 E.27392
G1 X161.924 Y168.159 E.27012
; COOLING_NODE: 5
M204 S10000
G1 X161.864 Y167.752 F60000
G1 F8843.478
M204 S8000
G1 X161.472 Y167.752 E.01261
G1 X161.472 Y160.048 E.24774
G1 X169.917 Y160.048 E.27156
G1 X169.917 Y167.752 E.24774
G1 X161.924 Y167.752 E.25703
; COOLING_NODE: 6
M204 S250
G1 X161.864 Y167.36 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X161.864 Y160.44 E.20612
G1 X169.525 Y160.44 E.22819
G1 X169.525 Y167.36 E.20612
G1 X161.924 Y167.36 E.22641
; COOLING_NODE: 6
; WIPE_START
M204 S8000
G1 X161.907 Y165.36 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X163.539 Y172.816 Z2 F60000
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
; COOLING_NODE: 6
M204 S10000
G1 X165.652 Y184.325 F60000
G1 F8843.478
M204 S8000
G1 X165.652 Y184.717 E.01261
G1 X161.748 Y184.717 E.12554
G1 X161.748 Y178.273 E.20722
G1 X165.652 Y178.273 E.12554
G1 X165.652 Y184.265 E.19268
; COOLING_NODE: 7
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
; COOLING_NODE: 7
; WIPE_START
M204 S8000
G1 X163.26 Y184.303 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X165.775 Y191.51 Z2 F60000
G1 X166.059 Y192.325 Z2
G1 Z1.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X166.059 Y193.124 E.0257
G1 X161.341 Y193.124 E.15172
G1 X161.341 Y185.866 E.2334
G1 X166.059 Y185.866 E.15172
G1 X166.059 Y192.265 E.20577
; COOLING_NODE: 7
M204 S10000
G1 X165.652 Y192.325 F60000
G1 F8843.478
M204 S8000
G1 X165.652 Y192.717 E.01261
G1 X161.748 Y192.717 E.12554
G1 X161.748 Y186.273 E.20722
G1 X165.652 Y186.273 E.12554
G1 X165.652 Y192.265 E.19268
; COOLING_NODE: 8
M204 S250
G1 X165.26 Y192.325 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X162.14 Y192.325 E.09293
G1 X162.14 Y186.665 E.16859
G1 X165.26 Y186.665 E.09293
G1 X165.26 Y192.265 E.1668
; COOLING_NODE: 8
; WIPE_START
M204 S8000
G1 X163.26 Y192.303 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X166.972 Y185.634 Z2 F60000
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
G1 X181.234 Y195.741 E.42607
G1 X160.509 Y195.741 E.66644
G1 X160.509 Y132.519 E2.03298
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
G1 X167.726 Y134.83 Z2 F60000
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
G1 X180.827 Y196.148 E.42607
G1 X160.102 Y196.148 E.66644
G1 X160.102 Y132.112 E2.05916
G1 X169.102 Y132.112 E.28941
; COOLING_NODE: 10
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
G1 X180.435 Y196.54 E.39467
G1 X159.71 Y196.54 E.61733
G1 X159.71 Y131.72 E1.93077
G1 X168.71 Y131.72 E.26808
; WIPE_START
G1 F9547.055
M204 S8000
M73 P70 R6
G1 X168.74 Y129.72 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X167.959 Y133.09 Z2 F60000
G1 Z1.6
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42003
G1 F9546.286
M204 S8000
G1 X167.699 Y133.349 E.01093
G1 X167.699 Y133.882 E.01589
G1 X168.322 Y133.259 E.02625
G1 X168.856 Y133.259 E.01589
G1 X167.699 Y134.416 E.04871
G1 X167.699 Y134.949 E.01589
G1 X169.389 Y133.259 E.07118
G1 X169.922 Y133.259 E.01589
G1 X167.53 Y135.652 E.1008
; WIPE_START
G1 X168.944 Y134.238 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X166.755 Y132.56 Z2 F60000
G1 Z1.6
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
G1 X161.375 Y133.13 Z2 F60000
G1 Z1.6
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
M204 S10000
G1 X161.445 Y153.47 F60000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42003
G1 F9546.286
M204 S8000
G1 X161.249 Y153.665 E.00824
G1 X161.249 Y154.199 E.01589
G1 X161.809 Y153.639 E.02356
G1 X162.342 Y153.639 E.01589
G1 X161.249 Y154.732 E.04602
G1 X161.249 Y155.265 E.01589
G1 X162.875 Y153.639 E.06849
G1 X163.408 Y153.639 E.01589
G1 X161.249 Y155.798 E.09096
G1 X161.249 Y156.332 E.01589
G1 X163.942 Y153.639 E.11343
G1 X164.475 Y153.639 E.01589
G1 X161.249 Y156.865 E.13589
G1 X161.249 Y157.398 E.01589
G1 X165.008 Y153.639 E.15836
G1 X165.542 Y153.639 E.01589
G1 X161.249 Y157.932 E.18083
G1 X161.249 Y158.465 E.01589
G1 X165.691 Y154.024 E.1871
G1 X165.691 Y154.557 E.01589
G1 X161.347 Y158.901 E.18299
G1 X161.88 Y158.901 E.01589
G1 X165.691 Y155.09 E.16052
G1 X165.691 Y155.624 E.01589
G1 X162.414 Y158.901 E.13805
G1 X162.947 Y158.901 E.01589
G1 X165.883 Y155.964 E.1237
G1 X166.417 Y155.964 E.01589
G1 X163.48 Y158.901 E.1237
G1 X164.014 Y158.901 E.01589
G1 X166.95 Y155.964 E.1237
G1 X167.483 Y155.964 E.01589
G1 X164.547 Y158.901 E.1237
G1 X165.08 Y158.901 E.01589
G1 X168.017 Y155.964 E.1237
G1 X168.55 Y155.964 E.01589
G1 X165.614 Y158.901 E.1237
G1 X166.147 Y158.901 E.01589
G1 X169.083 Y155.964 E.1237
G1 X169.616 Y155.964 E.01589
G1 X166.68 Y158.901 E.1237
G1 X167.214 Y158.901 E.01589
G1 X170.15 Y155.964 E.1237
G1 X170.683 Y155.964 E.01589
G1 X167.747 Y158.901 E.1237
G1 X168.28 Y158.901 E.01589
G1 X171.216 Y155.964 E.1237
G1 X171.75 Y155.964 E.01589
G1 X168.813 Y158.901 E.1237
G1 X169.347 Y158.901 E.01589
G1 X172.283 Y155.964 E.1237
G1 X172.816 Y155.964 E.01589
G1 X169.88 Y158.901 E.1237
G1 X170.413 Y158.901 E.01589
G1 X173.35 Y155.964 E.1237
G1 X173.883 Y155.964 E.01589
G1 X170.947 Y158.901 E.1237
G1 X171.064 Y158.901 E.0035
G1 X171.064 Y159.316 E.01238
G1 X174.416 Y155.964 E.14121
G1 X174.95 Y155.964 E.01589
G1 X171.064 Y159.85 E.16368
G1 X171.064 Y160.383 E.01589
G1 X175.483 Y155.964 E.18615
G1 X176.016 Y155.964 E.01589
G1 X171.064 Y160.916 E.20861
G1 X171.064 Y161.45 E.01589
G1 X181.326 Y151.188 E.43229
G1 X181.326 Y151.722 E.01589
G1 X171.064 Y161.983 E.43229
G1 X171.064 Y162.516 E.01589
G1 X181.326 Y152.255 E.43229
G1 X181.326 Y152.788 E.01589
G1 X171.064 Y163.05 E.43229
G1 X171.064 Y163.583 E.01589
G1 X181.326 Y153.322 E.43229
G1 X181.326 Y153.855 E.01589
G1 X171.064 Y164.116 E.43229
G1 X171.064 Y164.649 E.01589
G1 X181.326 Y154.388 E.43229
G1 X181.326 Y154.921 E.01589
G1 X171.064 Y165.183 E.43229
G1 X171.064 Y165.716 E.01589
G1 X181.326 Y155.455 E.43229
G1 X181.326 Y155.988 E.01589
G1 X171.064 Y166.249 E.43229
G1 X171.064 Y166.783 E.01589
G1 X181.326 Y156.521 E.43229
G1 X181.326 Y157.055 E.01589
G1 X171.064 Y167.316 E.43229
G1 X171.064 Y167.849 E.01589
G1 X181.326 Y157.588 E.43229
G1 X181.326 Y158.121 E.01589
G1 X170.895 Y168.552 E.43944
; WIPE_START
G1 X172.309 Y167.138 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X166.704 Y172.319 Z2 F60000
G1 X160.925 Y177.662 Z2
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
G1 X166.263 Y185.495 Z2 F60000
G1 Z1.6
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
G1 X160.925 Y193.328 E.25713
; WIPE_START
G1 X160.925 Y191.328 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X161.08 Y194.367 Z2 F60000
G1 Z1.6
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42003
G1 F9546.286
M204 S8000
G1 X161.582 Y193.864 E.02116
G1 X162.115 Y193.864 E.01589
G1 X161.249 Y194.73 E.03648
G1 X161.249 Y195.001 E.00805
G1 X161.512 Y195.001 E.00784
G1 X162.649 Y193.864 E.04787
G1 X163.182 Y193.864 E.01589
G1 X162.046 Y195.001 E.04787
G1 X162.579 Y195.001 E.01589
G1 X163.715 Y193.864 E.04787
G1 X164.249 Y193.864 E.01589
G1 X163.112 Y195.001 E.04787
G1 X163.646 Y195.001 E.01589
G1 X164.782 Y193.864 E.04787
G1 X165.315 Y193.864 E.01589
G1 X164.179 Y195.001 E.04787
G1 X164.712 Y195.001 E.01589
G1 X165.849 Y193.864 E.04787
G1 X166.382 Y193.864 E.01589
G1 X165.076 Y195.17 E.05502
; WIPE_START
G1 X166.382 Y193.864 E-.70182
G1 X166.229 Y193.864 E-.05818
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X173.166 Y197.047 Z2 F60000
G1 X182.785 Y201.46 Z2
G1 Z1.6
G1 E.8 F1800
G1 F9546.286
M204 S8000
G1 X181.974 Y202.271 E.03417
G1 X181.974 Y202.804 E.01589
G1 X182.407 Y202.372 E.01823
G1 X182.426 Y202.886 E.01533
G1 X181.974 Y203.338 E.01903
G1 X181.974 Y203.871 E.01589
G1 X182.523 Y203.322 E.02312
G1 X182.541 Y203.401 E.00241
G1 X182.674 Y203.705 E.00988
G1 X181.974 Y204.404 E.02946
G1 X181.974 Y204.938 E.01589
G1 X182.86 Y204.052 E.03732
G1 X183.079 Y204.367 E.01142
G1 X181.974 Y205.471 E.04652
G1 X181.974 Y206.004 E.01589
G1 X183.342 Y204.637 E.0576
G2 X183.638 Y204.874 I1.383 J-1.424 E.01132
G1 X181.974 Y206.538 E.07007
G1 X181.974 Y207.071 E.01589
G1 X183.968 Y205.077 E.08399
G1 X184.348 Y205.23 E.01221
G1 X181.974 Y207.604 E.10001
G1 X181.974 Y208.137 E.01589
G1 X184.762 Y205.35 E.11744
G2 X185.254 Y205.391 I.466 J-2.603 E.01473
G1 X182.395 Y208.251 E.12047
G1 X182.928 Y208.251 E.01589
G1 X185.839 Y205.34 E.12264
G1 X186.196 Y205.261 E.01088
G1 X186.648 Y205.064 E.01468
G1 X183.461 Y208.251 E.13424
G1 X183.994 Y208.251 E.01589
G1 X188.035 Y204.21 E.17022
G1 X188.151 Y204.152 E.00386
G1 X188.151 Y204.628 E.01419
G1 X184.528 Y208.251 E.15262
G1 X185.061 Y208.251 E.01589
G1 X188.151 Y205.161 E.13016
G1 X188.151 Y205.694 E.01589
G1 X185.594 Y208.251 E.10769
G1 X186.128 Y208.251 E.01589
G1 X188.151 Y206.228 E.08522
G1 X188.151 Y206.761 E.01589
G1 X186.661 Y208.251 E.06275
G1 X187.194 Y208.251 E.01589
G1 X188.151 Y207.294 E.04029
G1 X188.151 Y207.828 E.01589
G1 X187.558 Y208.42 E.02497
; WIPE_START
G1 X188.151 Y207.828 E-.31849
G1 X188.151 Y207.294 E-.20266
G1 X187.706 Y207.739 E-.23885
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
M204 S10000
G1 X187.546 Y200.966 F60000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42003
G1 F9546.286
M204 S8000
G1 X188.151 Y200.361 E.02549
G1 X188.151 Y199.828 E.01589
G1 X187.433 Y200.545 E.03022
G1 X187.164 Y200.282 E.01123
G1 X188.151 Y199.295 E.04158
G1 X188.151 Y198.761 E.01589
G1 X186.858 Y200.054 E.05444
G2 X186.508 Y199.871 I-.797 J1.102 E.01182
G1 X188.151 Y198.228 E.06921
G1 X188.151 Y197.695 E.01589
G1 X186.126 Y199.719 E.0853
G1 X185.68 Y199.632 E.01353
G1 X188.151 Y197.161 E.10408
G1 X188.151 Y196.628 E.01589
G1 X185.167 Y199.612 E.12572
G2 X184.542 Y199.703 I.034 J2.423 E.01884
G1 X188.151 Y196.095 E.15201
G1 X188.151 Y195.561 E.01589
G1 X181.974 Y201.738 E.26019
G1 X181.974 Y201.204 E.01589
G1 X188.151 Y195.028 E.26019
G1 X188.151 Y194.495 E.01589
G1 X181.974 Y200.671 E.26019
G1 X181.974 Y200.138 E.01589
G1 X188.151 Y193.961 E.26019
G1 X188.151 Y193.428 E.01589
G1 X181.974 Y199.604 E.26019
G1 X181.974 Y199.071 E.01589
G1 X188.151 Y192.895 E.26019
G1 X188.151 Y192.362 E.01589
G1 X181.974 Y198.538 E.26019
G1 X181.974 Y198.005 E.01589
G1 X188.151 Y191.828 E.26019
G1 X188.151 Y191.295 E.01589
G1 X181.974 Y197.471 E.26019
G1 X181.974 Y196.938 E.01589
G1 X188.151 Y190.762 E.26019
G1 X188.151 Y190.228 E.01589
G1 X181.974 Y196.405 E.26019
G1 X181.974 Y195.871 E.01589
G1 X188.151 Y189.695 E.26019
G1 X188.151 Y189.162 E.01589
G1 X181.974 Y195.338 E.26019
G1 X181.974 Y195.001 E.01005
G1 X181.778 Y195.001 E.00584
G1 X188.151 Y188.628 E.26845
G1 X188.151 Y188.095 E.01589
G1 X181.245 Y195.001 E.29092
G1 X180.712 Y195.001 E.01589
G1 X188.151 Y187.562 E.31339
G1 X188.151 Y187.028 E.01589
G1 X180.178 Y195.001 E.33585
G1 X179.645 Y195.001 E.01589
G1 X188.151 Y186.495 E.35832
G1 X188.151 Y185.962 E.01589
G1 X179.112 Y195.001 E.38079
G1 X178.578 Y195.001 E.01589
G1 X188.151 Y185.428 E.40326
G1 X188.151 Y184.895 E.01589
G1 X178.045 Y195.001 E.42572
G1 X177.512 Y195.001 E.01589
G1 X188.151 Y184.362 E.44819
G1 X188.151 Y183.829 E.01589
M73 P71 R6
G1 X176.979 Y195.001 E.47066
G1 X176.445 Y195.001 E.01589
G1 X188.151 Y183.295 E.49313
G1 X188.151 Y182.844 E.01343
G1 X188.068 Y182.844 E.00246
G1 X175.912 Y195.001 E.51212
G1 X175.379 Y195.001 E.01589
G1 X187.535 Y182.844 E.51212
G1 X187.002 Y182.844 E.01589
G1 X174.845 Y195.001 E.51212
G1 X174.312 Y195.001 E.01589
G1 X186.468 Y182.844 E.51212
G1 X185.935 Y182.844 E.01589
G1 X173.779 Y195.001 E.51212
G1 X173.245 Y195.001 E.01589
G1 X185.402 Y182.844 E.51212
G1 X184.868 Y182.844 E.01589
G1 X172.712 Y195.001 E.51212
G1 X172.179 Y195.001 E.01589
G1 X184.335 Y182.844 E.51212
G1 X183.802 Y182.844 E.01589
G1 X171.645 Y195.001 E.51212
G1 X171.112 Y195.001 E.01589
G1 X183.268 Y182.844 E.51212
G1 X182.735 Y182.844 E.01589
G1 X170.579 Y195.001 E.51212
G1 X170.045 Y195.001 E.01589
G1 X182.202 Y182.844 E.51212
G1 X181.668 Y182.844 E.01589
G1 X169.512 Y195.001 E.51212
G1 X168.979 Y195.001 E.01589
G1 X181.326 Y182.654 E.52015
G1 X181.326 Y182.121 E.01589
G1 X168.445 Y195.001 E.54261
G1 X167.912 Y195.001 E.01589
G1 X181.326 Y181.587 E.56508
G1 X181.326 Y181.054 E.01589
G1 X167.379 Y195.001 E.58755
G1 X166.846 Y195.001 E.01589
G1 X181.326 Y180.521 E.61002
G1 X181.326 Y179.987 E.01589
G1 X166.312 Y195.001 E.63248
G1 X165.779 Y195.001 E.01589
G1 X181.326 Y179.454 E.65495
G1 X181.326 Y178.921 E.01589
G1 X166.799 Y193.447 E.61196
G1 X166.799 Y192.914 E.01589
G1 X181.326 Y178.387 E.61196
G1 X181.326 Y177.854 E.01589
G1 X166.799 Y192.38 E.61196
G1 X166.799 Y191.847 E.01589
G1 X181.326 Y177.321 E.61196
G1 X181.326 Y176.787 E.01589
G1 X166.799 Y191.314 E.61196
G1 X166.799 Y190.78 E.01589
G1 X181.326 Y176.254 E.61196
G1 X181.326 Y175.721 E.01589
G1 X166.799 Y190.247 E.61196
G1 X166.799 Y189.714 E.01589
G1 X181.326 Y175.187 E.61196
G1 X181.326 Y174.654 E.01589
G1 X166.799 Y189.18 E.61196
G1 X166.799 Y188.647 E.01589
G1 X181.326 Y174.121 E.61196
G1 X181.326 Y173.587 E.01589
G1 X166.799 Y188.114 E.61196
G1 X166.799 Y187.58 E.01589
G1 X181.326 Y173.054 E.61196
G1 X181.326 Y172.521 E.01589
G1 X166.799 Y187.047 E.61196
G1 X166.799 Y186.514 E.01589
G1 X181.326 Y171.988 E.61196
G1 X181.326 Y171.454 E.01589
G1 X166.799 Y185.981 E.61196
G1 X166.799 Y185.447 E.01589
G1 X181.326 Y170.921 E.61196
G1 X181.326 Y170.388 E.01589
G1 X166.799 Y184.914 E.61196
G1 X166.799 Y184.381 E.01589
G1 X181.326 Y169.854 E.61196
G1 X181.326 Y169.321 E.01589
G1 X166.799 Y183.847 E.61196
G1 X166.799 Y183.314 E.01589
G1 X181.326 Y168.788 E.61196
G1 X181.326 Y168.254 E.01589
M73 P71 R5
G1 X166.799 Y182.781 E.61196
G1 X166.799 Y182.247 E.01589
G1 X181.326 Y167.721 E.61196
G1 X181.326 Y167.188 E.01589
G1 X166.799 Y181.714 E.61196
G1 X166.799 Y181.181 E.01589
G1 X181.326 Y166.654 E.61196
G1 X181.326 Y166.121 E.01589
G1 X166.799 Y180.647 E.61196
G1 X166.799 Y180.114 E.01589
G1 X181.326 Y165.588 E.61196
G1 X181.326 Y165.054 E.01589
G1 X166.799 Y179.581 E.61196
G1 X166.799 Y179.047 E.01589
G1 X181.326 Y164.521 E.61196
G1 X181.326 Y163.988 E.01589
G1 X166.799 Y178.514 E.61196
G1 X166.799 Y177.981 E.01589
G1 X181.326 Y163.455 E.61196
G1 X181.326 Y162.921 E.01589
G1 X166.799 Y177.447 E.61196
G1 X166.799 Y177.126 E.00959
G1 X166.588 Y177.126 E.0063
G1 X181.326 Y162.388 E.62087
G1 X181.326 Y161.855 E.01589
G1 X166.055 Y177.126 E.64334
G1 X165.521 Y177.126 E.01589
G1 X181.326 Y161.321 E.66581
G1 X181.326 Y160.788 E.01589
G1 X164.988 Y177.126 E.68827
G1 X164.455 Y177.126 E.01589
G1 X181.326 Y160.255 E.71074
G1 X181.326 Y159.721 E.01589
G1 X163.921 Y177.126 E.73321
G1 X163.388 Y177.126 E.01589
G1 X181.326 Y159.188 E.75568
G1 X181.326 Y158.655 E.01589
G1 X162.855 Y177.126 E.77814
G1 X162.321 Y177.126 E.01589
G1 X170.548 Y168.899 E.34656
G1 X170.014 Y168.899 E.01589
G1 X161.788 Y177.126 E.34656
G1 X161.255 Y177.126 E.01589
G1 X169.481 Y168.899 E.34656
G1 X168.948 Y168.899 E.01589
G1 X161.249 Y176.598 E.32432
G1 X161.249 Y176.064 E.01589
G1 X168.414 Y168.899 E.30185
G1 X167.881 Y168.899 E.01589
G1 X161.249 Y175.531 E.27938
G1 X161.249 Y174.998 E.01589
G1 X167.348 Y168.899 E.25691
G1 X166.814 Y168.899 E.01589
G1 X161.249 Y174.464 E.23445
G1 X161.249 Y173.931 E.01589
G1 X166.281 Y168.899 E.21198
G1 X165.748 Y168.899 E.01589
G1 X161.249 Y173.398 E.18951
G1 X161.249 Y172.865 E.01589
G1 X165.214 Y168.899 E.16704
G1 X164.681 Y168.899 E.01589
G1 X161.249 Y172.331 E.14458
G1 X161.249 Y171.798 E.01589
G1 X164.148 Y168.899 E.12211
G1 X163.615 Y168.899 E.01589
G1 X161.249 Y171.265 E.09964
G1 X161.249 Y170.731 E.01589
G1 X163.081 Y168.899 E.07717
G1 X162.548 Y168.899 E.01589
G1 X161.249 Y170.198 E.05471
G1 X161.249 Y169.665 E.01589
G1 X162.015 Y168.899 E.03224
G1 X161.481 Y168.899 E.01589
G1 X161.08 Y169.301 E.01692
M204 S10000
G1 X160.787 Y168.363 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.19158
G1 F15000
M204 S8000
G1 X160.787 Y159.437 E.10481
; WIPE_START
G1 X160.787 Y161.437 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X161.297 Y153.822 Z2 F60000
G1 X162.037 Y142.75 Z2
G1 Z1.6
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
G1 X166.63 Y145.618 Z2 F60000
G1 Z1.6
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42003
G1 F9546.286
M204 S8000
G1 X176.999 Y135.249 E.43682
G1 X176.465 Y135.249 E.01589
G1 X166.799 Y144.915 E.40721
G1 X166.799 Y144.382 E.01589
G1 X175.932 Y135.249 E.38474
G1 X175.551 Y135.249 E.01136
G1 X175.551 Y135.097 E.00453
G1 X166.799 Y143.849 E.36867
G1 X166.799 Y143.315 E.01589
G1 X167.145 Y142.97 E.01456
M204 S10000
G1 X167.53 Y142.585 F60000
G1 F9546.286
M204 S8000
G1 X175.551 Y134.564 E.33791
G1 X175.551 Y134.031 E.01589
G1 X167.699 Y141.882 E.33076
G1 X167.699 Y141.349 E.01589
G1 X175.551 Y133.497 E.33076
G1 X175.551 Y132.964 E.01589
G1 X167.699 Y140.815 E.33076
G1 X167.699 Y140.282 E.01589
G1 X175.551 Y132.431 E.33076
G1 X175.551 Y131.898 E.01589
G1 X167.699 Y139.749 E.33076
G1 X167.699 Y139.216 E.01589
M73 P72 R5
G1 X175.551 Y131.364 E.33076
G1 X175.551 Y130.831 E.01589
G1 X167.699 Y138.682 E.33076
G1 X167.699 Y138.149 E.01589
G1 X175.551 Y130.298 E.33076
G1 X175.551 Y129.764 E.01589
G1 X167.699 Y137.616 E.33076
G1 X167.699 Y137.082 E.01589
G1 X175.532 Y129.249 E.32998
G1 X174.999 Y129.249 E.01589
G1 X167.699 Y136.549 E.30752
G1 X167.699 Y136.016 E.01589
G1 X174.466 Y129.249 E.28505
G1 X173.932 Y129.249 E.01589
G1 X170.309 Y132.872 E.15263
G1 X170.309 Y132.339 E.01589
G1 X173.399 Y129.249 E.13016
G1 X172.866 Y129.249 E.01589
G1 X170.309 Y131.806 E.10769
G1 X170.309 Y131.272 E.01589
G1 X172.332 Y129.249 E.08523
G1 X171.799 Y129.249 E.01589
G1 X170.309 Y130.739 E.06276
G1 X170.309 Y130.206 E.01589
G1 X171.266 Y129.249 E.04029
G1 X170.732 Y129.249 E.01589
G1 X170.14 Y129.842 E.02497
; WIPE_START
G1 X170.732 Y129.249 E-.31854
G1 X171.266 Y129.249 E-.20266
G1 X170.821 Y129.694 E-.2388
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
G1 X188.32 Y136.194 Z2 F60000
G1 Z1.6
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42003
G1 F9546.286
M204 S8000
G1 X187.714 Y136.801 E.02556
G1 X187.18 Y136.801 E.01589
G1 X188.151 Y135.83 E.04088
G1 X188.151 Y135.297 E.01589
G1 X186.647 Y136.801 E.06335
G1 X186.114 Y136.801 E.01589
G1 X187.665 Y135.249 E.06535
G1 X187.132 Y135.249 E.01589
G1 X185.58 Y136.801 E.06535
G1 X185.047 Y136.801 E.01589
G1 X186.598 Y135.249 E.06535
G1 X186.065 Y135.249 E.01589
G1 X184.514 Y136.801 E.06535
G1 X183.98 Y136.801 E.01589
G1 X185.532 Y135.249 E.06535
G1 X184.998 Y135.249 E.01589
G1 X183.447 Y136.801 E.06535
G1 X182.914 Y136.801 E.01589
G1 X184.465 Y135.249 E.06535
G1 X183.932 Y135.249 E.01589
G1 X182.38 Y136.801 E.06535
G1 X181.847 Y136.801 E.01589
G1 X183.398 Y135.249 E.06535
G1 X182.865 Y135.249 E.01589
G1 X181.314 Y136.801 E.06535
G1 X180.781 Y136.801 E.01589
G1 X182.332 Y135.249 E.06535
G1 X181.798 Y135.249 E.01589
G1 X180.247 Y136.801 E.06535
G1 X179.714 Y136.801 E.01589
G1 X181.265 Y135.249 E.06535
G1 X180.732 Y135.249 E.01589
G1 X179.181 Y136.801 E.06535
G1 X178.647 Y136.801 E.01589
G1 X180.199 Y135.249 E.06535
G1 X179.665 Y135.249 E.01589
G1 X178.114 Y136.801 E.06535
G1 X177.581 Y136.801 E.01589
G1 X179.132 Y135.249 E.06535
G1 X178.599 Y135.249 E.01589
G1 X177.047 Y136.801 E.06535
G1 X176.514 Y136.801 E.01589
G1 X178.065 Y135.249 E.06535
G1 X177.532 Y135.249 E.01589
G1 X175.981 Y136.801 E.06535
G1 X175.551 Y136.801 E.01281
G1 X175.551 Y137.231 E.01281
G1 X166.799 Y145.982 E.36867
G1 X166.799 Y146.515 E.01589
G1 X175.551 Y137.764 E.36867
G1 X175.551 Y138.297 E.01589
G1 X166.799 Y147.049 E.36867
G1 X166.799 Y147.582 E.01589
G1 X175.551 Y138.831 E.36867
G1 X175.551 Y139.364 E.01589
G1 X166.799 Y148.115 E.36867
G1 X166.799 Y148.649 E.01589
G1 X175.551 Y139.897 E.36867
G1 X175.551 Y140.431 E.01589
G1 X166.799 Y149.182 E.36867
G1 X166.799 Y149.715 E.01589
G1 X175.551 Y140.964 E.36867
G1 X175.551 Y141.497 E.01589
G1 X167.022 Y150.026 E.35929
G1 X167.556 Y150.026 E.01589
G1 X175.551 Y142.03 E.33682
G1 X175.551 Y142.564 E.01589
G1 X168.089 Y150.026 E.31435
G1 X168.622 Y150.026 E.01589
G1 X175.551 Y143.097 E.29188
G1 X175.551 Y143.249 E.00454
G1 X175.932 Y143.249 E.01135
G1 X169.155 Y150.026 E.28547
G1 X169.689 Y150.026 E.01589
G1 X176.465 Y143.249 E.28547
G1 X176.998 Y143.249 E.01589
G1 X170.222 Y150.026 E.28547
G1 X170.755 Y150.026 E.01589
G1 X177.532 Y143.249 E.28547
G1 X178.065 Y143.249 E.01589
G1 X171.289 Y150.026 E.28547
G1 X171.822 Y150.026 E.01589
G1 X178.598 Y143.249 E.28547
G1 X179.132 Y143.249 E.01589
G1 X172.355 Y150.026 E.28547
G1 X172.889 Y150.026 E.01589
G1 X179.665 Y143.249 E.28547
G1 X180.198 Y143.249 E.01589
G1 X173.422 Y150.026 E.28547
G1 X173.955 Y150.026 E.01589
G1 X180.732 Y143.249 E.28547
G1 X181.265 Y143.249 E.01589
G1 X174.489 Y150.026 E.28547
G1 X175.022 Y150.026 E.01589
G1 X181.798 Y143.249 E.28547
G1 X182.331 Y143.249 E.01589
G1 X175.555 Y150.026 E.28547
G1 X176.089 Y150.026 E.01589
G1 X182.865 Y143.249 E.28547
G1 X183.398 Y143.249 E.01589
G1 X176.622 Y150.026 E.28547
G1 X176.709 Y150.026 E.00261
G1 X176.709 Y150.471 E.01328
G1 X183.931 Y143.249 E.30425
G1 X184.465 Y143.249 E.01589
G1 X176.709 Y151.005 E.32672
G1 X176.709 Y151.538 E.01589
G1 X181.326 Y146.922 E.19447
G1 X181.326 Y147.455 E.01589
G1 X176.709 Y152.071 E.19447
G1 X176.709 Y152.605 E.01589
G1 X181.326 Y147.988 E.19447
G1 X181.326 Y148.522 E.01589
G1 X176.709 Y153.138 E.19447
G1 X176.709 Y153.671 E.01589
G1 X181.326 Y149.055 E.19447
G1 X181.326 Y149.588 E.01589
G1 X176.709 Y154.205 E.19447
G1 X176.709 Y154.738 E.01589
G1 X181.326 Y150.122 E.19447
G1 X181.326 Y150.655 E.01589
G1 X176.54 Y155.441 E.20162
; WIPE_START
G1 X177.954 Y154.027 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X181.446 Y147.24 Z2 F60000
G1 X181.912 Y146.335 Z2
G1 Z1.6
G1 E.8 F1800
G1 F9546.286
M204 S8000
G1 X184.998 Y143.249 E.13
G1 X185.531 Y143.249 E.01589
G1 X182.615 Y146.166 E.12286
G1 X183.148 Y146.166 E.01589
G1 X186.065 Y143.249 E.12286
G1 X186.598 Y143.249 E.01589
G1 X183.682 Y146.166 E.12286
G1 X184.215 Y146.166 E.01589
G1 X187.131 Y143.249 E.12286
G1 X187.665 Y143.249 E.01589
G1 X184.748 Y146.166 E.12286
G1 X185.282 Y146.166 E.01589
G1 X188.151 Y143.297 E.12086
G1 X188.151 Y143.83 E.01589
G1 X185.815 Y146.166 E.0984
G1 X186.348 Y146.166 E.01589
G1 X188.151 Y144.363 E.07593
G1 X188.151 Y144.897 E.01589
G1 X186.882 Y146.166 E.05346
G1 X187.415 Y146.166 E.01589
G1 X188.151 Y145.43 E.03099
G1 X188.151 Y145.963 E.01589
G1 X187.779 Y146.335 E.01567
; WIPE_START
G1 X188.151 Y145.963 E-.19996
G1 X188.151 Y145.43 E-.20266
G1 X187.486 Y146.095 E-.35739
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
; COOLING_NODE: 11
; WIPE_START
G1 X189.12 Y181.926 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X186.492 Y174.76 Z2 F60000
G1 X166.884 Y121.274 Z2
G1 Z1.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X160.916 Y121.274 E.1919
G1 X160.916 Y111.416 E.31698
G1 X166.884 Y111.416 E.1919
G1 X166.884 Y116.237 E.15501
G1 X166.66 Y116.255 E.00723
G2 X166.57 Y117.204 I-2.556 J.236 E.48775
G2 X166.654 Y116.739 I-2.169 J-.637 E.01522
G1 X166.884 Y116.754 E.00739
G1 X166.884 Y121.214 E.14343
; COOLING_NODE: 11
; WIPE_START
G1 X164.884 Y121.234 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X162.025 Y117.068 Z2 F60000
G1 Z1.6
G1 E.8 F1800
G1 F8843.478
M204 S8000
G1 X161.988 Y116.953 E.00388
G3 X163.871 Y114.352 I2.111 J-.454 E.11645
G1 X164.074 Y114.34 E.00654
G3 X162.122 Y117.368 I.025 J2.159 E.29919
G1 X162.043 Y117.125 E.0082
; COOLING_NODE: 11
M204 S10000
G1 X162.411 Y116.943 F60000
G1 F8843.478
M204 S8000
G1 X162.386 Y116.867 E.00258
G3 X163.915 Y114.757 I1.713 J-.368 E.09447
G1 X164.078 Y114.747 E.00526
G3 X162.496 Y117.204 I.021 J1.752 E.24275
G1 X162.429 Y117 E.0069
; COOLING_NODE: 11
M204 S250
G1 X162.782 Y116.823 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X162.77 Y116.784 E.00124
G3 X163.957 Y115.147 I1.329 J-.284 E.0679
G1 X164.083 Y115.14 E.00374
G3 X162.855 Y117.047 I.017 J1.359 E.1745
G1 X162.801 Y116.88 E.00523
; COOLING_NODE: 11
; WIPE_START
M204 S8000
G1 X162.77 Y116.784 E-.03858
G1 X162.74 Y116.525 E-.09889
G1 X162.76 Y116.264 E-.09954
G1 X162.83 Y116.013 E-.09877
G1 X162.947 Y115.779 E-.09952
G1 X163.121 Y115.555 E-.10798
G1 X163.225 Y115.459 E-.05376
G1 X163.441 Y115.31 E-.09948
G1 X163.594 Y115.244 E-.06347
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X167.291 Y121.681 Z2 F60000
G1 Z1.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X160.509 Y121.681 E.21808
G1 X160.509 Y111.009 E.34316
G1 X167.291 Y111.009 E.21808
G1 X167.291 Y121.621 E.34123
; COOLING_NODE: 11
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
; COOLING_NODE: 10
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
M73 P73 R5
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
G1 X180.86 Y150.312 Z2.2 F60000
G1 X175.17 Y150.766 Z2.2
G1 Z1.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X175.969 Y150.766 E.0257
G1 X175.969 Y155.224 E.14336
G1 X166.431 Y155.224 E.30672
G1 X166.431 Y150.766 E.14336
G1 X175.11 Y150.766 E.27909
; COOLING_NODE: 0
M204 S10000
G1 X175.17 Y151.173 F60000
G1 F8843.478
M204 S8000
G1 X175.562 Y151.173 E.01261
G1 X175.562 Y154.817 E.11718
G1 X166.838 Y154.817 E.28054
G1 X166.838 Y151.173 E.11718
G1 X175.11 Y151.173 E.266
; COOLING_NODE: 1
M204 S250
G1 X175.17 Y151.565 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X175.17 Y154.425 E.08519
G1 X167.23 Y154.425 E.23651
G1 X167.23 Y151.565 E.08519
G1 X175.11 Y151.565 E.23472
; COOLING_NODE: 1
; WIPE_START
M204 S8000
G1 X175.152 Y153.565 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X169.922 Y148.006 Z2.2 F60000
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
G1 X168.544 Y141.868 Z2.2 F60000
G1 X187.71 Y142.509 Z2.2
G1 Z1.8
G1 E.8 F1800
G1 F8843.478
M204 S8000
G1 X176.291 Y142.509 E.3672
G1 X176.291 Y137.541 E.15976
G1 X188.509 Y137.541 E.3929
G1 X188.509 Y142.509 E.15976
G1 X187.77 Y142.509 E.02377
; COOLING_NODE: 2
M204 S10000
G1 X187.71 Y142.102 F60000
G1 F8843.478
M204 S8000
G1 X176.698 Y142.102 E.35411
G1 X176.698 Y137.948 E.13358
G1 X188.102 Y137.948 E.36672
G1 X188.102 Y142.102 E.13358
G1 X187.77 Y142.102 E.01068
; COOLING_NODE: 3
M204 S250
G1 X187.71 Y141.71 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X177.09 Y141.71 E.31633
G1 X177.09 Y138.34 E.10038
G1 X187.71 Y138.34 E.31633
G1 X187.71 Y141.65 E.09859
; COOLING_NODE: 3
; WIPE_START
M204 S8000
G1 X185.71 Y141.661 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X185.556 Y149.292 Z2.2 F60000
G1 X184.436 Y204.907 Z2.2
G1 Z1.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X184.129 Y204.784 E.01062
G3 X185.029 Y199.946 I1.168 J-2.285 E.21165
G1 X185.285 Y199.932 E.00825
G3 X184.587 Y204.965 I.012 J2.566 E.28279
G1 X184.492 Y204.928 E.00327
; COOLING_NODE: 3
M204 S10000
G1 X184.586 Y204.53 F60000
G1 F8843.478
M204 S8000
G1 X184.316 Y204.422 E.00935
G3 X185.072 Y200.352 I.982 J-1.923 E.17807
G1 X185.288 Y200.34 E.00695
G3 X184.701 Y204.574 I.01 J2.159 E.23789
G1 X184.642 Y204.551 E.00203
; COOLING_NODE: 3
M204 S10000
G1 X184.735 Y204.153 F60000
G1 F8843.478
M204 S8000
G1 X184.502 Y204.059 E.00807
G3 X185.116 Y200.757 I.796 J-1.56 E.14449
G1 X185.291 Y200.747 E.00565
G3 X184.815 Y204.183 I.008 J1.752 E.19299
G1 X184.791 Y204.174 E.0008
; COOLING_NODE: 4
M204 S250
G1 X184.879 Y203.789 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X184.682 Y203.711 E.00632
G3 X185.157 Y201.147 I.617 J-1.211 E.10389
G1 X185.294 Y201.14 E.00407
G3 X184.936 Y203.809 I.006 J1.359 E.13836
; COOLING_NODE: 4
; WIPE_START
M204 S8000
G1 X184.682 Y203.711 E-.10343
G1 X184.444 Y203.557 E-.10762
G1 X184.257 Y203.373 E-.09962
G1 X184.102 Y203.144 E-.1051
G1 X183.999 Y202.898 E-.10137
G1 X183.947 Y202.642 E-.09929
G1 X183.947 Y202.359 E-.10768
G1 X183.966 Y202.266 E-.03588
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X184.39 Y194.645 Z2.2 F60000
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
G1 X181.641 Y195.334 E.42607
G1 X160.916 Y195.334 E.66644
G1 X160.916 Y193.531 E.05796
G1 X166.466 Y193.531 E.17847
G1 X166.466 Y177.459 E.51683
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
; COOLING_NODE: 4
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
; COOLING_NODE: 4
M204 S10000
G1 X187.71 Y129.948 F60000
G1 F8843.478
M204 S8000
G1 X188.102 Y129.948 E.01261
G1 X188.102 Y134.102 E.13358
G1 X176.698 Y134.102 E.36672
G1 X176.698 Y129.948 E.13358
G1 X187.65 Y129.948 E.35218
; COOLING_NODE: 5
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
; COOLING_NODE: 5
; WIPE_START
M204 S8000
G1 X187.686 Y132.34 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X183.222 Y138.531 Z2.2 F60000
G1 X161.864 Y168.159 Z2.2
G1 Z1.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X161.065 Y168.159 E.0257
G1 X161.065 Y159.641 E.27392
G1 X170.324 Y159.641 E.29774
G1 X170.324 Y168.159 E.27392
G1 X161.924 Y168.159 E.27012
; COOLING_NODE: 5
M204 S10000
G1 X161.864 Y167.752 F60000
G1 F8843.478
M204 S8000
G1 X161.472 Y167.752 E.01261
G1 X161.472 Y160.048 E.24774
G1 X169.917 Y160.048 E.27156
G1 X169.917 Y167.752 E.24774
G1 X161.924 Y167.752 E.25703
; COOLING_NODE: 6
M204 S250
G1 X161.864 Y167.36 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X161.864 Y160.44 E.20612
G1 X169.525 Y160.44 E.22819
G1 X169.525 Y167.36 E.20612
G1 X161.924 Y167.36 E.22641
; COOLING_NODE: 6
; WIPE_START
M204 S8000
G1 X161.907 Y165.36 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X163.539 Y172.816 Z2.2 F60000
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
; COOLING_NODE: 6
M204 S10000
G1 X165.652 Y184.325 F60000
G1 F8843.478
M204 S8000
G1 X165.652 Y184.717 E.01261
G1 X161.748 Y184.717 E.12554
G1 X161.748 Y178.273 E.20722
G1 X165.652 Y178.273 E.12554
G1 X165.652 Y184.265 E.19268
; COOLING_NODE: 7
M204 S250
G1 X165.26 Y184.325 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X162.14 Y184.325 E.09293
G1 X162.14 Y178.665 E.16859
M73 P74 R5
G1 X165.26 Y178.665 E.09293
G1 X165.26 Y184.265 E.1668
; COOLING_NODE: 7
; WIPE_START
M204 S8000
G1 X163.26 Y184.303 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X165.775 Y191.51 Z2.2 F60000
G1 X166.059 Y192.325 Z2.2
G1 Z1.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X166.059 Y193.124 E.0257
G1 X161.341 Y193.124 E.15172
G1 X161.341 Y185.866 E.2334
G1 X166.059 Y185.866 E.15172
G1 X166.059 Y192.265 E.20577
; COOLING_NODE: 7
M204 S10000
G1 X165.652 Y192.325 F60000
G1 F8843.478
M204 S8000
G1 X165.652 Y192.717 E.01261
G1 X161.748 Y192.717 E.12554
G1 X161.748 Y186.273 E.20722
G1 X165.652 Y186.273 E.12554
G1 X165.652 Y192.265 E.19268
; COOLING_NODE: 8
M204 S250
G1 X165.26 Y192.325 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X162.14 Y192.325 E.09293
G1 X162.14 Y186.665 E.16859
G1 X165.26 Y186.665 E.09293
G1 X165.26 Y192.265 E.1668
; COOLING_NODE: 8
; WIPE_START
M204 S8000
G1 X163.26 Y192.303 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X166.972 Y185.634 Z2.2 F60000
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
G1 X181.234 Y195.741 E.42607
G1 X160.509 Y195.741 E.66644
G1 X160.509 Y132.519 E2.03298
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
G1 X167.726 Y134.83 Z2.2 F60000
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
G1 X180.827 Y196.148 E.42607
G1 X160.102 Y196.148 E.66644
G1 X160.102 Y132.112 E2.05916
G1 X169.102 Y132.112 E.28941
; COOLING_NODE: 10
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
G1 X180.435 Y196.54 E.39467
G1 X159.71 Y196.54 E.61733
G1 X159.71 Y131.72 E1.93077
G1 X168.71 Y131.72 E.26808
; WIPE_START
G1 F9547.055
M204 S8000
G1 X168.74 Y129.72 E-.76
; WIPE_END
M73 P75 R5
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
G1 X166.236 Y156.584 Z2.2 F60000
G1 X168.646 Y159.07 Z2.2
G1 Z1.8
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42209
G1 F9494.421
M204 S8000
G1 X163.215 Y153.639 E.23005
G1 X162.679 Y153.639 E.01606
G1 X167.94 Y158.901 E.22286
G1 X167.404 Y158.901 E.01606
G1 X162.143 Y153.639 E.22286
G1 X161.606 Y153.639 E.01606
G1 X166.868 Y158.901 E.22286
G1 X166.331 Y158.901 E.01606
G1 X161.249 Y153.819 E.21527
G1 X161.249 Y154.355 E.01606
G1 X165.795 Y158.901 E.19256
G1 X165.259 Y158.901 E.01606
G1 X161.249 Y154.891 E.16984
G1 X161.249 Y155.427 E.01606
G1 X164.723 Y158.901 E.14713
G1 X164.187 Y158.901 E.01606
G1 X161.249 Y155.963 E.12441
G1 X161.249 Y156.5 E.01606
G1 X163.65 Y158.901 E.1017
G1 X163.114 Y158.901 E.01606
G1 X161.249 Y157.036 E.07899
G1 X161.249 Y157.572 E.01606
G1 X162.578 Y158.901 E.05627
G1 X162.042 Y158.901 E.01606
G1 X161.249 Y158.108 E.03356
G1 X161.249 Y158.645 E.01606
G1 X161.675 Y159.07 E.01803
M204 S10000
G1 X160.787 Y159.437 F60000
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
G1 X164.319 Y173.129 Z2.2 F60000
G1 X166.494 Y177.295 Z2.2
G1 Z1.8
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42209
G1 F9494.421
M204 S8000
G1 X161.249 Y172.05 E.22217
G1 X161.249 Y172.586 E.01606
G1 X165.789 Y177.126 E.19227
G1 X165.252 Y177.126 E.01606
G1 X161.249 Y173.123 E.16956
G1 X161.249 Y173.659 E.01606
G1 X164.716 Y177.126 E.14684
G1 X164.18 Y177.126 E.01606
G1 X161.249 Y174.195 E.12413
G1 X161.249 Y174.731 E.01606
G1 X163.644 Y177.126 E.10142
G1 X163.107 Y177.126 E.01606
G1 X161.249 Y175.268 E.0787
G1 X161.249 Y175.804 E.01606
G1 X162.571 Y177.126 E.05599
G1 X162.035 Y177.126 E.01606
G1 X161.249 Y176.34 E.03328
G1 X161.249 Y176.876 E.01606
G1 X161.668 Y177.295 E.01775
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
G1 X160.925 Y193.328 E.25713
; WIPE_START
G1 X160.925 Y191.328 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X161.08 Y194.402 Z2.2 F60000
G1 Z1.8
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42209
G1 F9494.421
M204 S8000
G1 X161.678 Y195.001 E.02535
G1 X162.214 Y195.001 E.01606
G1 X161.249 Y194.036 E.04088
G1 X161.249 Y193.864 E.00513
G1 X161.614 Y193.864 E.01093
G1 X162.751 Y195.001 E.04813
G1 X163.287 Y195.001 E.01606
G1 X162.151 Y193.864 E.04813
G1 X162.687 Y193.864 E.01606
G1 X163.823 Y195.001 E.04813
G1 X164.359 Y195.001 E.01606
G1 X163.223 Y193.864 E.04813
G1 X163.759 Y193.864 E.01606
G1 X164.896 Y195.001 E.04813
G1 X165.432 Y195.001 E.01606
G1 X164.296 Y193.864 E.04813
G1 X164.832 Y193.864 E.01606
G1 X165.968 Y195.001 E.04813
G1 X166.504 Y195.001 E.01606
G1 X165.368 Y193.864 E.04813
G1 X165.904 Y193.864 E.01606
G1 X167.04 Y195.001 E.04813
G1 X167.577 Y195.001 E.01606
G1 X166.44 Y193.864 E.04813
G1 X166.799 Y193.864 E.01075
G1 X166.799 Y193.687 E.00531
G1 X168.113 Y195.001 E.05564
G1 X168.649 Y195.001 E.01606
G1 X166.799 Y193.151 E.07835
G1 X166.799 Y192.615 E.01606
G1 X169.185 Y195.001 E.10107
G1 X169.722 Y195.001 E.01606
G1 X166.799 Y192.078 E.12378
G1 X166.799 Y191.542 E.01606
G1 X170.258 Y195.001 E.14649
G1 X170.794 Y195.001 E.01606
G1 X166.799 Y191.006 E.16921
G1 X166.799 Y190.47 E.01606
G1 X171.33 Y195.001 E.19192
G1 X171.867 Y195.001 E.01606
G1 X166.799 Y189.933 E.21464
G1 X166.799 Y189.397 E.01606
G1 X172.403 Y195.001 E.23735
G1 X172.939 Y195.001 E.01606
G1 X166.799 Y188.861 E.26006
G1 X166.799 Y188.325 E.01606
G1 X173.475 Y195.001 E.28278
G1 X174.011 Y195.001 E.01606
G1 X166.799 Y187.789 E.30549
G1 X166.799 Y187.252 E.01606
G1 X174.548 Y195.001 E.3282
G1 X175.084 Y195.001 E.01606
G1 X166.799 Y186.716 E.35092
G1 X166.799 Y186.18 E.01606
G1 X175.62 Y195.001 E.37363
G1 X176.156 Y195.001 E.01606
G1 X166.799 Y185.644 E.39634
G1 X166.799 Y185.107 E.01606
G1 X176.693 Y195.001 E.41906
G1 X177.229 Y195.001 E.01606
G1 X166.799 Y184.571 E.44177
G1 X166.799 Y184.035 E.01606
G1 X177.765 Y195.001 E.46448
G1 X178.301 Y195.001 E.01606
G1 X166.799 Y183.499 E.4872
G1 X166.799 Y182.963 E.01606
G1 X178.837 Y195.001 E.50991
G1 X179.374 Y195.001 E.01606
G1 X166.799 Y182.426 E.53263
G1 X166.799 Y181.89 E.01606
G1 X179.91 Y195.001 E.55534
G1 X180.446 Y195.001 E.01606
G1 X166.799 Y181.354 E.57805
G1 X166.799 Y180.818 E.01606
G1 X180.982 Y195.001 E.60077
G1 X181.519 Y195.001 E.01606
G1 X166.799 Y180.281 E.62348
G1 X166.799 Y179.745 E.01606
G1 X187.956 Y200.902 E.89616
G1 X188.151 Y200.868 E.00592
G1 X188.151 Y200.56 E.0092
G1 X166.799 Y179.209 E.9044
G1 X166.799 Y178.673 E.01606
G1 X188.151 Y200.024 E.9044
G1 X188.151 Y199.488 E.01606
G1 X166.799 Y178.136 E.9044
G1 X166.799 Y177.6 E.01606
G1 X188.151 Y198.952 E.9044
G1 X188.151 Y198.415 E.01606
G1 X161.249 Y171.514 E1.13949
G1 X161.249 Y170.978 E.01606
G1 X188.151 Y197.879 E1.13949
G1 X188.151 Y197.343 E.01606
G1 X161.249 Y170.442 E1.13949
G1 X161.249 Y169.905 E.01606
G1 X188.151 Y196.807 E1.13949
G1 X188.151 Y196.27 E.01606
G1 X161.249 Y169.369 E1.13949
G1 X161.249 Y168.899 E.01407
G1 X161.316 Y168.899 E.00199
G1 X188.151 Y195.734 E1.13667
G1 X188.151 Y195.198 E.01606
G1 X161.852 Y168.899 E1.11396
G1 X162.388 Y168.899 E.01606
G1 X188.151 Y194.662 E1.09124
G1 X188.151 Y194.125 E.01606
G1 X162.925 Y168.899 E1.06853
G1 X163.461 Y168.899 E.01606
G1 X188.151 Y193.589 E1.04582
G1 X188.151 Y193.053 E.01606
G1 X163.997 Y168.899 E1.0231
G1 X164.533 Y168.899 E.01606
G1 X188.151 Y192.517 E1.00039
G1 X188.151 Y191.981 E.01606
G1 X165.069 Y168.899 E.97768
G1 X165.606 Y168.899 E.01606
G1 X188.151 Y191.444 E.95496
G1 X188.151 Y190.908 E.01606
G1 X166.142 Y168.899 E.93225
G1 X166.678 Y168.899 E.01606
M73 P76 R5
G1 X188.32 Y190.542 E.91672
; WIPE_START
G1 X186.906 Y189.127 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X186.729 Y196.758 Z2.2 F60000
G1 X186.651 Y200.133 Z2.2
G1 Z1.8
G1 E.8 F1800
G1 F9494.421
M204 S8000
G1 X181.974 Y195.456 E.19808
G1 X181.974 Y195.993 E.01606
G1 X185.597 Y199.616 E.15346
G1 X185.058 Y199.613 E.01614
G1 X181.974 Y196.529 E.13063
G1 X181.974 Y197.065 E.01606
G1 X184.603 Y199.694 E.11135
G2 X184.201 Y199.828 I.143 J1.099 E.01277
G1 X181.974 Y197.601 E.09432
G1 X181.974 Y198.138 E.01606
G1 X183.836 Y199.999 E.07885
G2 X183.516 Y200.215 I.935 J1.73 E.01159
G1 X181.974 Y198.674 E.06529
G1 X181.974 Y199.21 E.01606
G1 X183.231 Y200.467 E.05324
G2 X182.988 Y200.76 I.872 J.973 E.01145
G1 X181.974 Y199.746 E.04293
G1 X181.974 Y200.282 E.01606
G1 X182.774 Y201.082 E.03385
G1 X182.607 Y201.451 E.01215
G1 X181.974 Y200.819 E.0268
G1 X181.974 Y201.355 E.01606
G1 X182.481 Y201.862 E.02148
G2 X182.407 Y202.324 I1.528 J.482 E.01407
G1 X181.974 Y201.891 E.01834
G1 X181.974 Y202.427 E.01606
G1 X182.43 Y202.883 E.01929
G2 X182.62 Y203.609 I2.515 J-.27 E.02257
G1 X181.974 Y202.964 E.02734
G1 X181.974 Y203.5 E.01606
G1 X186.725 Y208.251 E.20124
G1 X187.261 Y208.251 E.01606
G1 X184.171 Y205.16 E.1309
G2 X184.917 Y205.37 I.924 J-1.86 E.02332
G1 X187.798 Y208.251 E.12204
G1 X188.151 Y208.251 E.01057
G1 X188.151 Y208.067 E.00549
G1 X185.473 Y205.39 E.11342
G2 X185.945 Y205.326 I-.105 J-2.546 E.01429
G1 X188.151 Y207.531 E.09342
G1 X188.151 Y206.995 E.01606
G1 X186.348 Y205.193 E.07634
G1 X186.718 Y205.026 E.01215
G1 X188.151 Y206.459 E.06067
G1 X188.151 Y205.922 E.01606
G1 X187.04 Y204.812 E.04703
G2 X187.333 Y204.569 I-.677 J-1.112 E.01145
G1 X188.151 Y205.386 E.03463
G1 X188.151 Y204.85 E.01606
G1 X187.584 Y204.284 E.02398
G2 X187.743 Y204.061 I-1.002 J-.879 E.00821
G1 X187.93 Y204.093 E.0057
G1 X188.32 Y204.483 E.01652
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
G1 X186.359 Y208.42 Z2.2 F60000
G1 Z1.8
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42209
G1 F9494.421
M204 S8000
G1 X181.974 Y204.036 E.18571
G1 X181.974 Y204.572 E.01606
G1 X185.653 Y208.251 E.15581
G1 X185.117 Y208.251 E.01606
G1 X181.974 Y205.109 E.1331
G1 X181.974 Y205.645 E.01606
G1 X184.58 Y208.251 E.11038
G1 X184.044 Y208.251 E.01606
G1 X181.974 Y206.181 E.08767
G1 X181.974 Y206.717 E.01606
G1 X183.508 Y208.251 E.06495
G1 X182.972 Y208.251 E.01606
G1 X181.974 Y207.253 E.04224
G1 X181.974 Y207.79 E.01606
G1 X182.605 Y208.42 E.02671
; WIPE_START
G1 X181.974 Y207.79 E-.33893
G1 X181.974 Y207.253 E-.20377
G1 X182.379 Y207.658 E-.2173
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X180.096 Y200.375 Z2.2 F60000
G1 X162.037 Y142.75 Z2.2
G1 Z1.8
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.33758
G1 F12217.47
M204 S8000
G1 X166.263 Y142.75 E.09834
; WIPE_START
G1 X164.263 Y142.75 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X167.457 Y135.818 Z2.2 F60000
G1 X170.14 Y129.999 Z2.2
G1 Z1.8
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42209
G1 F9494.421
M204 S8000
G1 X176.941 Y136.801 E.28811
G1 X176.405 Y136.801 E.01606
G1 X170.309 Y130.705 E.2582
G1 X170.309 Y131.241 E.01606
G1 X175.869 Y136.801 E.23549
G1 X175.551 Y136.801 E.00953
G1 X175.551 Y137.019 E.00653
G1 X170.309 Y131.777 E.22201
M73 P76 R4
G1 X170.309 Y132.314 E.01606
G1 X175.551 Y137.555 E.22201
G1 X175.551 Y138.091 E.01606
G1 X170.309 Y132.85 E.22201
G1 X170.309 Y133.259 E.01227
G1 X170.183 Y133.259 E.00379
G1 X175.551 Y138.627 E.22738
G1 X175.551 Y139.164 E.01606
G1 X169.646 Y133.259 E.25009
G1 X169.11 Y133.259 E.01606
G1 X175.551 Y139.7 E.2728
G1 X175.551 Y140.236 E.01606
G1 X168.574 Y133.259 E.29552
G1 X168.038 Y133.259 E.01606
G1 X175.551 Y140.772 E.31823
G1 X175.551 Y141.308 E.01606
G1 X167.699 Y133.457 E.33257
G1 X167.699 Y133.993 E.01606
G1 X175.551 Y141.845 E.33257
G1 X175.551 Y142.381 E.01606
G1 X167.699 Y134.53 E.33257
G1 X167.699 Y135.066 E.01606
G1 X181.326 Y148.692 E.57718
G1 X181.326 Y148.156 E.01606
G1 X176.419 Y143.249 E.20783
G1 X176.955 Y143.249 E.01606
G1 X181.326 Y147.62 E.18512
G1 X181.326 Y147.083 E.01606
G1 X177.492 Y143.249 E.1624
G1 X178.028 Y143.249 E.01606
G1 X181.326 Y146.547 E.13969
G1 X181.326 Y146.166 E.01143
G1 X181.48 Y146.166 E.00463
G1 X178.564 Y143.249 E.12353
G1 X179.1 Y143.249 E.01606
G1 X182.017 Y146.166 E.12353
G1 X182.553 Y146.166 E.01606
G1 X179.636 Y143.249 E.12353
G1 X180.173 Y143.249 E.01606
G1 X183.089 Y146.166 E.12353
G1 X183.625 Y146.166 E.01606
G1 X180.709 Y143.249 E.12353
G1 X181.245 Y143.249 E.01606
G1 X184.161 Y146.166 E.12353
G1 X184.698 Y146.166 E.01606
G1 X181.781 Y143.249 E.12353
G1 X182.318 Y143.249 E.01606
G1 X185.234 Y146.166 E.12353
G1 X185.77 Y146.166 E.01606
G1 X182.854 Y143.249 E.12353
G1 X183.39 Y143.249 E.01606
G1 X186.306 Y146.166 E.12353
G1 X186.843 Y146.166 E.01606
G1 X183.926 Y143.249 E.12353
G1 X184.463 Y143.249 E.01606
G1 X187.379 Y146.166 E.12353
G1 X187.915 Y146.166 E.01606
G1 X184.999 Y143.249 E.12353
G1 X185.535 Y143.249 E.01606
G1 X188.151 Y145.865 E.1108
G1 X188.151 Y145.329 E.01606
G1 X186.071 Y143.249 E.08808
G1 X186.607 Y143.249 E.01606
G1 X188.151 Y144.793 E.06537
G1 X188.151 Y144.256 E.01606
G1 X187.144 Y143.249 E.04265
G1 X187.68 Y143.249 E.01606
G1 X188.32 Y143.89 E.02713
; WIPE_START
G1 X187.68 Y143.249 E-.34418
G1 X187.144 Y143.249 E-.20377
G1 X187.538 Y143.644 E-.21206
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
G1 X187.961 Y182.675 Z2.2 F60000
G1 Z1.8
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42209
G1 F9494.421
M204 S8000
G1 X188.151 Y182.865 E.00805
G1 X188.151 Y183.401 E.01606
G1 X187.594 Y182.844 E.02358
G1 X187.058 Y182.844 E.01606
G1 X188.151 Y183.937 E.04629
G1 X188.151 Y184.473 E.01606
G1 X186.522 Y182.844 E.069
G1 X185.985 Y182.844 E.01606
G1 X188.151 Y185.01 E.09172
G1 X188.151 Y185.546 E.01606
G1 X185.449 Y182.844 E.11443
G1 X184.913 Y182.844 E.01606
G1 X188.151 Y186.082 E.13714
G1 X188.151 Y186.618 E.01606
G1 X184.377 Y182.844 E.15986
G1 X183.84 Y182.844 E.01606
G1 X188.151 Y187.155 E.18257
G1 X188.151 Y187.691 E.01606
G1 X183.304 Y182.844 E.20528
G1 X182.768 Y182.844 E.01606
G1 X188.151 Y188.227 E.228
G1 X188.151 Y188.763 E.01606
G1 X182.232 Y182.844 E.25071
G1 X181.696 Y182.844 E.01606
G1 X188.151 Y189.299 E.27342
G1 X188.151 Y189.836 E.01606
G1 X167.214 Y168.899 E.88682
G1 X167.751 Y168.899 E.01606
G1 X181.326 Y182.474 E.57501
G1 X181.326 Y181.938 E.01606
G1 X168.287 Y168.899 E.5523
G1 X168.823 Y168.899 E.01606
G1 X181.326 Y181.402 E.52959
G1 X181.326 Y180.866 E.01606
G1 X169.359 Y168.899 E.50687
G1 X169.895 Y168.899 E.01606
G1 X181.326 Y180.33 E.48416
G1 X181.326 Y179.793 E.01606
G1 X170.432 Y168.899 E.46145
G1 X170.968 Y168.899 E.01606
G1 X181.326 Y179.257 E.43873
G1 X181.326 Y178.721 E.01606
G1 X171.064 Y168.46 E.43465
G1 X171.064 Y167.923 E.01606
G1 X181.326 Y178.185 E.43465
G1 X181.326 Y177.648 E.01606
G1 X171.064 Y167.387 E.43465
G1 X171.064 Y166.851 E.01606
G1 X181.326 Y177.112 E.43465
G1 X181.326 Y176.576 E.01606
G1 X171.064 Y166.315 E.43465
G1 X171.064 Y165.778 E.01606
G1 X181.326 Y176.04 E.43465
G1 X181.326 Y175.503 E.01606
G1 X171.064 Y165.242 E.43465
G1 X171.064 Y164.706 E.01606
G1 X181.326 Y174.967 E.43465
G1 X181.326 Y174.431 E.01606
G1 X171.064 Y164.17 E.43465
G1 X171.064 Y163.634 E.01606
G1 X181.326 Y173.895 E.43465
G1 X181.326 Y173.359 E.01606
G1 X171.064 Y163.097 E.43465
G1 X171.064 Y162.561 E.01606
G1 X181.326 Y172.822 E.43465
G1 X181.326 Y172.286 E.01606
G1 X171.064 Y162.025 E.43465
G1 X171.064 Y161.489 E.01606
G1 X181.326 Y171.75 E.43465
G1 X181.326 Y171.214 E.01606
G1 X171.064 Y160.952 E.43465
G1 X171.064 Y160.416 E.01606
G1 X181.326 Y170.677 E.43465
G1 X181.326 Y170.141 E.01606
G1 X171.064 Y159.88 E.43465
G1 X171.064 Y159.344 E.01606
G1 X181.495 Y169.775 E.44184
; WIPE_START
G1 X180.081 Y168.36 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X180.903 Y160.772 Z2.2 F60000
G1 X181.495 Y155.297 Z2.2
G1 Z1.8
G1 E.8 F1800
G1 F9494.421
M204 S8000
G1 X176.709 Y150.511 E.20272
G1 X176.709 Y151.047 E.01606
G1 X181.326 Y155.663 E.19554
G1 X181.326 Y156.199 E.01606
G1 X176.709 Y151.583 E.19554
G1 X176.709 Y152.119 E.01606
G1 X181.326 Y156.736 E.19554
G1 X181.326 Y157.272 E.01606
G1 X176.709 Y152.655 E.19554
G1 X176.709 Y153.192 E.01606
G1 X181.326 Y157.808 E.19554
G1 X181.326 Y158.344 E.01606
G1 X176.709 Y153.728 E.19554
G1 X176.709 Y154.264 E.01606
G1 X181.326 Y158.88 E.19554
G1 X181.326 Y159.417 E.01606
G1 X176.709 Y154.8 E.19554
G1 X176.709 Y155.337 E.01606
G1 X181.326 Y159.953 E.19554
G1 X181.326 Y160.489 E.01606
G1 X176.709 Y155.873 E.19554
G1 X176.709 Y155.964 E.00274
G1 X176.265 Y155.964 E.01332
G1 X181.326 Y161.025 E.21437
G1 X181.326 Y161.562 E.01606
G1 X175.728 Y155.964 E.23709
G1 X175.192 Y155.964 E.01606
G1 X181.326 Y162.098 E.2598
G1 X181.326 Y162.634 E.01606
G1 X174.656 Y155.964 E.28251
G1 X174.12 Y155.964 E.01606
G1 X181.326 Y163.17 E.30523
G1 X181.326 Y163.706 E.01606
G1 X173.584 Y155.964 E.32794
G1 X173.047 Y155.964 E.01606
G1 X181.326 Y164.243 E.35066
G1 X181.326 Y164.779 E.01606
G1 X172.511 Y155.964 E.37337
G1 X171.975 Y155.964 E.01606
G1 X181.326 Y165.315 E.39608
G1 X181.326 Y165.851 E.01606
G1 X171.439 Y155.964 E.4188
G1 X170.902 Y155.964 E.01606
G1 X181.326 Y166.388 E.44151
G1 X181.326 Y166.924 E.01606
G1 X170.366 Y155.964 E.46422
G1 X169.83 Y155.964 E.01606
M73 P77 R4
G1 X181.326 Y167.46 E.48694
G1 X181.326 Y167.996 E.01606
G1 X169.294 Y155.964 E.50965
G1 X168.757 Y155.964 E.01606
G1 X181.326 Y168.533 E.53236
G1 X181.326 Y169.069 E.01606
G1 X168.221 Y155.964 E.55508
G1 X167.685 Y155.964 E.01606
G1 X170.621 Y158.901 E.12438
G1 X170.085 Y158.901 E.01606
G1 X167.149 Y155.964 E.12438
G1 X166.613 Y155.964 E.01606
G1 X169.549 Y158.901 E.12438
G1 X169.013 Y158.901 E.01606
G1 X166.076 Y155.964 E.12438
G1 X165.691 Y155.964 E.01155
G1 X165.691 Y155.579 E.01155
G1 X163.751 Y153.639 E.08214
G1 X164.288 Y153.639 E.01606
G1 X165.691 Y155.042 E.05943
G1 X165.691 Y154.506 E.01606
G1 X164.824 Y153.639 E.03672
G1 X165.36 Y153.639 E.01606
G1 X165.86 Y154.14 E.02119
; WIPE_START
G1 X165.36 Y153.639 E-.26886
G1 X164.824 Y153.639 E-.20377
G1 X165.359 Y154.174 E-.28738
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X166.63 Y149.547 Z2.2 F60000
G1 Z1.8
G1 E.8 F1800
G1 F9494.421
M204 S8000
G1 X167.109 Y150.026 E.02028
G1 X167.645 Y150.026 E.01606
G1 X166.799 Y149.18 E.03581
G1 X166.799 Y148.644 E.01606
G1 X168.181 Y150.026 E.05852
G1 X168.717 Y150.026 E.01606
G1 X166.799 Y148.108 E.08124
G1 X166.799 Y147.572 E.01606
G1 X169.253 Y150.026 E.10395
G1 X169.79 Y150.026 E.01606
G1 X166.799 Y147.035 E.12667
G1 X166.799 Y146.499 E.01606
G1 X170.326 Y150.026 E.14938
G1 X170.862 Y150.026 E.01606
G1 X166.799 Y145.963 E.17209
G1 X166.799 Y145.427 E.01606
G1 X171.398 Y150.026 E.19481
G1 X171.935 Y150.026 E.01606
G1 X166.799 Y144.89 E.21752
G1 X166.799 Y144.354 E.01606
G1 X172.471 Y150.026 E.24023
G1 X173.007 Y150.026 E.01606
G1 X166.799 Y143.818 E.26295
G1 X166.799 Y143.282 E.01606
G1 X173.543 Y150.026 E.28566
G1 X174.08 Y150.026 E.01606
G1 X167.193 Y143.139 E.29169
G1 X167.699 Y143.139 E.01516
G1 X167.699 Y143.109 E.0009
G1 X174.616 Y150.026 E.29296
G1 X175.152 Y150.026 E.01606
G1 X167.699 Y142.573 E.31568
G1 X167.699 Y142.037 E.01606
G1 X175.688 Y150.026 E.33839
G1 X176.224 Y150.026 E.01606
G1 X167.699 Y141.501 E.36111
G1 X167.699 Y140.964 E.01606
G1 X181.326 Y154.591 E.57718
G1 X181.326 Y154.054 E.01606
G1 X167.699 Y140.428 E.57718
G1 X167.699 Y139.892 E.01606
G1 X181.326 Y153.518 E.57718
G1 X181.326 Y152.982 E.01606
G1 X167.699 Y139.356 E.57718
G1 X167.699 Y138.819 E.01606
G1 X181.326 Y152.446 E.57718
G1 X181.326 Y151.909 E.01606
G1 X167.699 Y138.283 E.57718
G1 X167.699 Y137.747 E.01606
G1 X181.326 Y151.373 E.57718
G1 X181.326 Y150.837 E.01606
G1 X167.699 Y137.211 E.57718
G1 X167.699 Y136.675 E.01606
G1 X181.326 Y150.301 E.57718
G1 X181.326 Y149.765 E.01606
G1 X167.699 Y136.138 E.57718
G1 X167.699 Y135.602 E.01606
G1 X181.495 Y149.398 E.58437
; WIPE_START
G1 X180.081 Y147.984 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X184.368 Y141.669 Z2.2 F60000
G1 X188.32 Y135.846 Z2.2
G1 Z1.8
G1 E.8 F1800
G1 F9494.421
M204 S8000
G1 X187.723 Y135.249 E.02529
G1 X187.187 Y135.249 E.01606
G1 X188.151 Y136.213 E.04082
G1 X188.151 Y136.749 E.01606
G1 X186.651 Y135.249 E.06353
G1 X186.115 Y135.249 E.01606
G1 X187.666 Y136.801 E.06571
G1 X187.13 Y136.801 E.01606
G1 X185.578 Y135.249 E.06571
G1 X185.042 Y135.249 E.01606
G1 X186.593 Y136.801 E.06571
G1 X186.057 Y136.801 E.01606
G1 X184.506 Y135.249 E.06571
G1 X183.97 Y135.249 E.01606
G1 X185.521 Y136.801 E.06571
G1 X184.985 Y136.801 E.01606
G1 X183.433 Y135.249 E.06571
G1 X182.897 Y135.249 E.01606
G1 X184.449 Y136.801 E.06571
G1 X183.912 Y136.801 E.01606
G1 X182.361 Y135.249 E.06571
G1 X181.825 Y135.249 E.01606
G1 X183.376 Y136.801 E.06571
G1 X182.84 Y136.801 E.01606
G1 X181.289 Y135.249 E.06571
G1 X180.752 Y135.249 E.01606
G1 X182.304 Y136.801 E.06571
G1 X181.767 Y136.801 E.01606
G1 X180.216 Y135.249 E.06571
G1 X179.68 Y135.249 E.01606
G1 X181.231 Y136.801 E.06571
G1 X180.695 Y136.801 E.01606
G1 X179.144 Y135.249 E.06571
G1 X178.607 Y135.249 E.01606
G1 X180.159 Y136.801 E.06571
G1 X179.622 Y136.801 E.01606
G1 X178.071 Y135.249 E.06571
G1 X177.535 Y135.249 E.01606
G1 X179.086 Y136.801 E.06571
G1 X178.55 Y136.801 E.01606
G1 X176.999 Y135.249 E.06571
G1 X176.463 Y135.249 E.01606
G1 X178.014 Y136.801 E.06571
G1 X177.478 Y136.801 E.01606
G1 X175.926 Y135.249 E.06571
G1 X175.551 Y135.249 E.01125
G1 X175.551 Y134.874 E.01125
G1 X170.309 Y129.632 E.22201
G1 X170.309 Y129.249 E.01147
G1 X170.463 Y129.249 E.00459
G1 X175.551 Y134.337 E.21552
G1 X175.551 Y133.801 E.01606
G1 X170.999 Y129.249 E.19281
G1 X171.535 Y129.249 E.01606
G1 X175.551 Y133.265 E.1701
G1 X175.551 Y132.729 E.01606
G1 X172.071 Y129.249 E.14738
G1 X172.607 Y129.249 E.01606
G1 X175.551 Y132.193 E.12467
G1 X175.551 Y131.656 E.01606
G1 X173.144 Y129.249 E.10196
G1 X173.68 Y129.249 E.01606
G1 X175.551 Y131.12 E.07924
G1 X175.551 Y130.584 E.01606
G1 X174.216 Y129.249 E.05653
G1 X174.752 Y129.249 E.01606
G1 X175.551 Y130.048 E.03381
G1 X175.551 Y129.511 E.01606
G1 X175.119 Y129.08 E.01829
M204 S10000
G1 X176.087 Y129.025 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.66758
G1 F5763.136
M204 S8000
G1 X188.687 Y129.025 E.62173
; COOLING_NODE: 11
; WIPE_START
G1 X186.687 Y129.025 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X179.58 Y126.243 Z2.2 F60000
G1 X166.884 Y121.274 Z2.2
G1 Z1.8
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
G2 X166.657 Y116.739 I-2.555 J.241 E.50327
G1 X166.884 Y116.756 E.0073
G1 X166.884 Y121.214 E.14335
; COOLING_NODE: 11
; WIPE_START
G1 X164.884 Y121.234 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X162.001 Y116.971 Z2.2 F60000
G1 Z1.8
G1 E.8 F1800
G1 F8843.478
M204 S8000
G1 X161.947 Y116.692 E.00915
G3 X163.872 Y114.352 I2.15 J-.193 E.10802
G1 X164.088 Y114.34 E.00695
G3 X162.026 Y117.107 I.01 J2.159 E.30768
G1 X162.012 Y117.03 E.0025
; COOLING_NODE: 11
M204 S10000
G1 X162.4 Y116.896 F60000
G1 F8843.478
M204 S8000
G1 X162.354 Y116.655 E.00789
G3 X163.916 Y114.757 I1.745 J-.156 E.0876
G1 X164.091 Y114.747 E.00565
G3 X162.418 Y116.992 I.008 J1.752 E.24965
G1 X162.411 Y116.955 E.00121
; COOLING_NODE: 11
M204 S250
G1 X162.783 Y116.823 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X162.745 Y116.619 E.00619
G3 X163.957 Y115.147 I1.354 J-.12 E.06293
G1 X164.094 Y115.14 E.00407
G3 X162.795 Y116.882 I.006 J1.359 E.17944
; COOLING_NODE: 11
; WIPE_START
M204 S8000
G1 X162.745 Y116.619 E-.10183
G1 X162.747 Y116.364 E-.09683
G1 X162.799 Y116.103 E-.1014
G1 X162.899 Y115.861 E-.09951
G1 X163.054 Y115.631 E-.10534
G1 X163.227 Y115.457 E-.09306
G1 X163.456 Y115.302 E-.10509
G1 X163.594 Y115.244 E-.05695
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X167.291 Y121.681 Z2.2 F60000
G1 Z1.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X160.509 Y121.681 E.21808
G1 X160.509 Y111.009 E.34316
G1 X167.291 Y111.009 E.21808
G1 X167.291 Y121.621 E.34123
; COOLING_NODE: 11
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
; COOLING_NODE: 10
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
G1 X159.688 Y123.229 E.34594
G1 X159.688 Y125.475 E.08809
G1 X168.512 Y125.475 E.34594
G1 X168.512 Y126.961 E.05828
G1 X168.337 Y126.961 E.00685
G1 X168.021 Y127.277 E.01749
M73 P78 R4
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
; COOLING_NODE: 1
M204 S10000
G17
G3 Z2.25 I-1.152 J.392 P1  F60000
G1 X175.17 Y151.565 Z2.25
G1 Z2
G1 E.8 F1800
; FEATURE: Outer wall
; LAYER_HEIGHT: 0.2
G1 F9547.055
M204 S5000
G1 X175.17 Y154.425 E.08519
G1 X167.23 Y154.425 E.23651
G1 X167.23 Y151.565 E.08519
G1 X175.11 Y151.565 E.23472
; COOLING_NODE: 2
; WIPE_START
M204 S8000
G1 X175.152 Y153.565 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X169.693 Y148.231 Z2.4 F60000
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
; COOLING_NODE: 5
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
G1 X187.705 Y139.972 Z2.4 F60000
G1 X187.71 Y141.71 Z2.4
G1 Z2
G1 E.8 F1800
G1 F9547.055
M204 S5000
G1 X177.09 Y141.71 E.31633
G1 X177.09 Y138.34 E.10038
G1 X187.71 Y138.34 E.31633
G1 X187.71 Y141.65 E.09859
; COOLING_NODE: 0
; WIPE_START
M204 S8000
G1 X185.71 Y141.661 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X188.525 Y147.705 Z2.4 F60000
G1 Z2
G1 E.8 F1800
G1 F9547.055
M204 S5000
G1 X188.525 Y181.305 E1.00083
G1 X182.865 Y181.305 E.16859
G1 X182.865 Y147.705 E1.00083
G1 X188.465 Y147.705 E.1668
; COOLING_NODE: 6
; WIPE_START
M204 S8000
G1 X188.469 Y149.705 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X182.109 Y153.925 Z2.4 F60000
G1 X161.864 Y167.36 Z2.4
G1 Z2
G1 E.8 F1800
G1 F9547.055
M204 S5000
G1 X161.864 Y160.44 E.20612
G1 X169.525 Y160.44 E.22819
G1 X169.525 Y167.36 E.20612
G1 X161.924 Y167.36 E.22641
; COOLING_NODE: 7
; WIPE_START
M204 S8000
G1 X161.907 Y165.36 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X163.236 Y172.876 Z2.4 F60000
G1 X165.26 Y184.325 Z2.4
G1 Z2
G1 E.8 F1800
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
G1 X165.106 Y191.709 Z2.4 F60000
G1 X165.26 Y192.325 Z2.4
G1 Z2
G1 E.8 F1800
G1 F9547.055
M204 S5000
G1 X162.14 Y192.325 E.09293
G1 X162.14 Y186.665 E.16859
G1 X165.26 Y186.665 E.09293
G1 X165.26 Y192.265 E.1668
; COOLING_NODE: 4
; WIPE_START
M204 S8000
G1 X163.26 Y192.303 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X170.001 Y195.884 Z2.4 F60000
G1 X184.882 Y203.789 Z2.4
G1 Z2
G1 E.8 F1800
G1 F9547.055
M204 S5000
G1 X184.807 Y203.766 E.00232
G3 X185.157 Y201.147 I.492 J-1.267 E.10794
G1 X185.283 Y201.14 E.00376
G3 X185.064 Y203.838 I.017 J1.359 E.13475
G1 X184.94 Y203.804 E.00384
; COOLING_NODE: 10
; WIPE_START
M204 S8000
G1 X184.807 Y203.766 E-.05244
G1 X184.56 Y203.641 E-.10534
G1 X184.355 Y203.478 E-.09946
G1 X184.185 Y203.279 E-.09933
G1 X184.057 Y203.052 E-.09906
G1 X183.973 Y202.8 E-.10119
G1 X183.94 Y202.525 E-.10519
G1 X183.96 Y202.268 E-.098
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X182.353 Y194.806 Z2.4 F60000
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
G1 X180.435 Y196.54 E.39467
G1 X159.71 Y196.54 E.61733
G1 X159.71 Y131.72 E1.93077
G1 X168.71 Y131.72 E.26808
; WIPE_START
G1 F9547.055
M204 S8000
G1 X168.74 Y129.72 E-.76
; WIPE_END
M73 P79 R4
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
G1 X164.473 Y139.216 Z2.4 F60000
G1 X189.483 Y209.242 Z2.4
G1 Z2
G1 E.8 F1800
; FEATURE: Top surface
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S2000
G1 X189.142 Y209.583 E.01437
G1 X189.008 Y209.716
G1 X188.475 Y209.716
G1 X188.608 Y209.583
G1 X189.483 Y208.708 E.03683
G1 X189.616 Y208.575
G1 X189.616 Y208.041
G1 X189.483 Y208.175
G1 X188.075 Y209.583 E.05929
G1 X187.941 Y209.716
G1 X187.408 Y209.716
G1 X187.542 Y209.583
G1 X189.483 Y207.642 E.08176
G1 X189.616 Y207.508
G1 X189.616 Y206.975
G1 X189.483 Y207.109
G1 X187.009 Y209.583 E.10422
G1 X186.875 Y209.716
G1 X186.342 Y209.716
G1 X186.475 Y209.583
G1 X189.483 Y206.575 E.12668
G1 X189.616 Y206.442
G1 X189.616 Y205.908
G1 X189.483 Y206.042
G1 X185.942 Y209.583 E.14915
G1 X185.808 Y209.716
G1 X185.275 Y209.716
G1 X185.409 Y209.583
G1 X189.483 Y205.509 E.17161
G1 X189.616 Y205.375
G1 X189.616 Y204.842
G1 X189.483 Y204.976
G1 X184.876 Y209.583 E.19407
G1 X184.742 Y209.716
G1 X184.209 Y209.716
G1 X184.342 Y209.583
G1 X189.483 Y204.442 E.21654
G1 X189.616 Y204.309
G1 X189.616 Y203.775
G1 X189.483 Y203.909
G1 X183.809 Y209.583 E.239
G1 X183.675 Y209.716
G1 X183.142 Y209.716
G1 X183.276 Y209.583
G1 X189.483 Y203.376 E.26146
G1 X189.616 Y203.242
G1 X189.616 Y202.709
G1 X189.483 Y202.842
G1 X182.742 Y209.583 E.28393
G1 X182.609 Y209.716
G1 X182.076 Y209.716
G1 X182.209 Y209.583
G1 X189.483 Y202.309 E.30639
G1 X189.616 Y202.176
G1 X189.616 Y201.642
G1 X189.483 Y201.776
G1 X181.676 Y209.583 E.32885
G1 X181.542 Y209.716
G1 X181.009 Y209.716
G1 X181.143 Y209.583
G1 X189.483 Y201.243 E.35132
G1 X189.616 Y201.109
G1 X189.616 Y200.576
G1 X189.483 Y200.709
G1 X180.642 Y209.55 E.37239
G1 X180.509 Y209.683
G1 X180.509 Y209.15
G1 X180.642 Y209.016
G1 X185.625 Y204.034 E.2099
G1 X185.759 Y203.9
G1 X185.209 Y203.916
G1 X185.076 Y204.05
G1 X180.642 Y208.483 E.18674
G1 X180.509 Y208.617
G1 X180.509 Y208.084
G1 X180.642 Y207.95
G1 X184.662 Y203.93 E.16933
G1 X184.796 Y203.796
G1 X184.462 Y203.597
G1 X184.328 Y203.731
G1 X180.642 Y207.417 E.15528
G1 X180.509 Y207.55
G1 X180.509 Y207.017
G1 X180.642 Y206.883
G1 X184.064 Y203.462 E.14413
G1 X184.197 Y203.328
G1 X183.998 Y202.995
G1 X183.864 Y203.128
G1 X180.642 Y206.35 E.13571
G1 X180.509 Y206.484
G1 X180.509 Y205.951
G1 X180.642 Y205.817
G1 X183.747 Y202.712 E.1308
G1 X183.881 Y202.578
G1 X183.906 Y202.02
G1 X183.773 Y202.153
G1 X180.642 Y205.284 E.13186
; WIPE_START
M204 S8000
G1 X182.057 Y203.869 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X188.891 Y200.471 Z2.4 F60000
G1 X189.483 Y200.176 Z2.4
G1 Z2
G1 E.8 F1800
G1 F9547.055
M204 S2000
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
G1 X189.616 Y196.31
G1 X189.616 Y195.777
G1 X189.483 Y195.91
G1 X180.642 Y204.75 E.37239
G1 X180.509 Y204.884
G1 X180.509 Y204.351
G1 X180.642 Y204.217
G1 X189.483 Y195.377 E.37239
G1 X189.616 Y195.243
G1 X189.616 Y194.71
G1 X189.483 Y194.844
G1 X180.642 Y203.684 E.37239
G1 X180.509 Y203.817
G1 X180.509 Y203.284
G1 X180.642 Y203.151
G1 X189.483 Y194.31 E.37239
G1 X189.616 Y194.177
G1 X189.616 Y193.643
G1 X189.483 Y193.777
G1 X180.642 Y202.617 E.37239
G1 X180.509 Y202.751
G1 X180.509 Y202.218
G1 X180.642 Y202.084
G1 X189.483 Y193.244 E.37239
G1 X189.616 Y193.11
G1 X189.616 Y192.577
G1 X189.483 Y192.711
G1 X180.642 Y201.551 E.37239
G1 X180.509 Y201.684
G1 X180.509 Y201.151
G1 X180.642 Y201.018
G1 X189.483 Y192.177 E.37239
G1 X189.616 Y192.044
G1 X189.616 Y191.51
G1 X189.483 Y191.644
G1 X180.642 Y200.484 E.37239
G1 X180.509 Y200.618
G1 X180.509 Y200.085
G1 X180.642 Y199.951
G1 X189.483 Y191.111 E.37239
G1 X189.616 Y190.977
G1 X189.616 Y190.444
G1 X189.483 Y190.578
G1 X180.642 Y199.418 E.37239
G1 X180.509 Y199.551
G1 X180.509 Y199.018
G1 X180.642 Y198.885
G1 X189.483 Y190.044 E.37239
G1 X189.616 Y189.911
G1 X189.616 Y189.377
G1 X189.483 Y189.511
G1 X180.642 Y198.351 E.37239
G1 X180.509 Y198.485
G1 X180.509 Y197.952
G1 X180.642 Y197.818
G1 X189.483 Y188.978 E.37239
G1 X189.616 Y188.844
G1 X189.616 Y188.311
G1 X189.483 Y188.445
G1 X180.642 Y197.285 E.37239
G1 X180.509 Y197.418
G1 X180.509 Y196.885
G1 X180.642 Y196.752
G1 X189.483 Y187.911 E.37239
G1 X189.616 Y187.778
G1 X189.616 Y187.244
G1 X189.483 Y187.378
G1 X180.528 Y196.333 E.37721
G1 X180.394 Y196.466
G1 X179.861 Y196.466
G1 X179.995 Y196.333
G1 X189.483 Y186.845 E.39967
G1 X189.616 Y186.711
G1 X189.616 Y186.178
G1 X189.483 Y186.312
G1 X179.461 Y196.333 E.42214
G1 X179.328 Y196.466
G1 X178.795 Y196.466
G1 X178.928 Y196.333
G1 X189.483 Y185.778 E.4446
G1 X189.616 Y185.645
G1 X189.616 Y185.111
G1 X189.483 Y185.245
G1 X178.395 Y196.333 E.46706
G1 X178.261 Y196.466
G1 X177.728 Y196.466
G1 X177.862 Y196.333
G1 X189.483 Y184.712 E.48953
G1 X189.616 Y184.578
G1 X189.616 Y184.045
G1 X189.483 Y184.178
G1 X177.328 Y196.333 E.51199
G1 X177.195 Y196.466
G1 X176.662 Y196.466
G1 X176.795 Y196.333
G1 X189.483 Y183.645 E.53445
G1 X189.616 Y183.512
G1 X189.616 Y182.978
G1 X189.483 Y183.112
G1 X176.262 Y196.333 E.55691
G1 X176.128 Y196.466
G1 X175.595 Y196.466
G1 X175.729 Y196.333
G1 X190.083 Y181.979 E.60465
G1 X190.216 Y181.845
G1 X190.216 Y181.312
G1 X190.083 Y181.445
G1 X175.195 Y196.333 E.62712
G1 X175.062 Y196.466
G1 X174.529 Y196.466
G1 X174.662 Y196.333
G1 X190.083 Y180.912 E.64958
G1 X190.216 Y180.779
G1 X190.216 Y180.245
G1 X190.083 Y180.379
G1 X174.129 Y196.333 E.67204
G1 X173.995 Y196.466
G1 X173.462 Y196.466
G1 X173.596 Y196.333
G1 X188.416 Y181.512 E.6243
G1 X188.55 Y181.379
G1 X188.016 Y181.379
G1 X187.883 Y181.512
G1 X173.062 Y196.333 E.6243
G1 X172.929 Y196.466
G1 X172.396 Y196.466
G1 X172.529 Y196.333
G1 X187.349 Y181.512 E.6243
G1 X187.483 Y181.379
G1 X186.95 Y181.379
G1 X186.816 Y181.512
G1 X171.996 Y196.333 E.6243
G1 X171.862 Y196.466
G1 X171.329 Y196.466
G1 X171.463 Y196.333
G1 X186.283 Y181.512 E.6243
G1 X186.417 Y181.379
G1 X185.883 Y181.379
G1 X185.75 Y181.512
G1 X170.929 Y196.333 E.6243
G1 X170.796 Y196.466
G1 X170.262 Y196.466
G1 X170.396 Y196.333
G1 X185.216 Y181.512 E.6243
G1 X185.35 Y181.379
G1 X184.817 Y181.379
G1 X184.683 Y181.512
G1 X169.863 Y196.333 E.6243
G1 X169.729 Y196.466
G1 X169.196 Y196.466
G1 X169.33 Y196.333
G1 X184.15 Y181.512 E.6243
G1 X184.283 Y181.379
G1 X183.75 Y181.379
G1 X183.617 Y181.512
G1 X168.796 Y196.333 E.6243
G1 X168.663 Y196.466
G1 X168.129 Y196.466
G1 X168.263 Y196.333
M73 P80 R4
G1 X183.083 Y181.512 E.6243
G1 X183.217 Y181.379
G1 X182.791 Y181.271
G1 X182.658 Y181.405
G1 X167.73 Y196.333 E.62883
G1 X167.596 Y196.466
G1 X167.063 Y196.466
G1 X167.197 Y196.333
G1 X182.658 Y180.872 E.65129
G1 X182.791 Y180.738
G1 X182.791 Y180.205
G1 X182.658 Y180.338
G1 X166.663 Y196.333 E.67375
G1 X166.53 Y196.466
G1 X165.996 Y196.466
G1 X166.13 Y196.333
G1 X182.658 Y179.805 E.69622
G1 X182.791 Y179.671
G1 X182.791 Y179.138
G1 X182.658 Y179.272
G1 X165.597 Y196.333 E.71868
G1 X165.463 Y196.466
G1 X164.93 Y196.466
G1 X165.064 Y196.333
G1 X182.658 Y178.739 E.74114
G1 X182.791 Y178.605
G1 X182.791 Y178.072
G1 X182.658 Y178.205
G1 X164.53 Y196.333 E.76361
G1 X164.397 Y196.466
G1 X163.863 Y196.466
G1 X163.997 Y196.333
G1 X182.658 Y177.672 E.78607
G1 X182.791 Y177.538
G1 X182.791 Y177.005
G1 X182.658 Y177.139
G1 X163.464 Y196.333 E.80853
G1 X163.33 Y196.466
G1 X162.797 Y196.466
G1 X162.931 Y196.333
G1 X182.658 Y176.606 E.831
G1 X182.791 Y176.472
G1 X182.791 Y175.939
G1 X182.658 Y176.072
G1 X162.397 Y196.333 E.85346
G1 X162.264 Y196.466
G1 X161.73 Y196.466
G1 X161.864 Y196.333
G1 X182.658 Y175.539 E.87592
G1 X182.791 Y175.405
G1 X182.791 Y174.872
G1 X182.658 Y175.006
G1 X165.467 Y192.196 E.72413
G1 X165.334 Y192.33
G1 X165.334 Y191.796
G1 X165.467 Y191.663
G1 X182.658 Y174.472 E.72413
G1 X182.791 Y174.339
G1 X182.791 Y173.806
G1 X182.658 Y173.939
G1 X165.467 Y191.129 E.72413
G1 X165.334 Y191.263
G1 X165.334 Y190.73
G1 X165.467 Y190.596
G1 X182.658 Y173.406 E.72413
G1 X182.791 Y173.272
G1 X182.791 Y172.739
G1 X182.658 Y172.873
G1 X165.467 Y190.063 E.72413
G1 X165.334 Y190.197
G1 X165.334 Y189.663
G1 X165.467 Y189.53
G1 X182.658 Y172.339 E.72413
G1 X182.791 Y172.206
G1 X182.791 Y171.673
G1 X182.658 Y171.806
G1 X165.467 Y188.996 E.72413
G1 X165.334 Y189.13
G1 X165.334 Y188.597
G1 X165.467 Y188.463
G1 X182.658 Y171.273 E.72413
G1 X182.791 Y171.139
G1 X182.791 Y170.606
G1 X182.658 Y170.74
G1 X165.467 Y187.93 E.72413
G1 X165.334 Y188.064
G1 X165.334 Y187.53
G1 X165.467 Y187.397
G1 X182.658 Y170.206 E.72413
G1 X182.791 Y170.073
G1 X182.791 Y169.54
G1 X182.658 Y169.673
G1 X165.467 Y186.863 E.72413
G1 X165.334 Y186.997
G1 X165.206 Y186.591
G1 X165.34 Y186.458
G1 X182.658 Y169.14 E.7295
G1 X182.791 Y169.006
G1 X182.791 Y168.473
G1 X182.658 Y168.607
G1 X164.807 Y186.458 E.75196
G1 X164.673 Y186.591
G1 X164.14 Y186.591
G1 X164.273 Y186.458
G1 X182.658 Y168.073 E.77443
G1 X182.791 Y167.94
G1 X182.791 Y167.407
G1 X182.658 Y167.54
G1 X163.74 Y186.458 E.79689
G1 X163.606 Y186.591
G1 X163.073 Y186.591
G1 X163.207 Y186.458
G1 X165.132 Y184.532 E.0811
G1 X165.266 Y184.399
G1 X164.732 Y184.399
G1 X164.599 Y184.532
G1 X162.674 Y186.458 E.0811
G1 X162.54 Y186.591
G1 X162.007 Y186.591
G1 X162.14 Y186.458
G1 X164.066 Y184.532 E.0811
; WIPE_START
M204 S8000
G1 X162.651 Y185.947 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X165.467 Y184.197 Z2.4 F60000
G1 Z2
G1 E.8 F1800
G1 F9547.055
M204 S2000
G1 X182.658 Y167.007 E.72413
G1 X182.791 Y166.873
G1 X182.791 Y166.34
G1 X182.658 Y166.474
G1 X165.467 Y183.664 E.72413
G1 X165.334 Y183.798
G1 X165.334 Y183.264
G1 X165.467 Y183.131
G1 X182.658 Y165.94 E.72413
G1 X182.791 Y165.807
G1 X182.791 Y165.273
G1 X182.658 Y165.407
G1 X165.467 Y182.597 E.72413
G1 X165.334 Y182.731
G1 X165.334 Y182.198
G1 X165.467 Y182.064
G1 X182.658 Y164.874 E.72413
G1 X182.791 Y164.74
G1 X182.791 Y164.207
G1 X182.658 Y164.341
G1 X165.467 Y181.531 E.72413
G1 X165.334 Y181.664
G1 X165.334 Y181.131
G1 X165.467 Y180.998
G1 X182.658 Y163.807 E.72413
G1 X182.791 Y163.674
G1 X182.791 Y163.14
G1 X182.658 Y163.274
G1 X165.467 Y180.464 E.72413
G1 X165.334 Y180.598
G1 X165.334 Y180.065
G1 X165.467 Y179.931
G1 X182.658 Y162.741 E.72413
G1 X182.791 Y162.607
G1 X182.791 Y162.074
G1 X182.658 Y162.208
G1 X165.467 Y179.398 E.72413
G1 X165.334 Y179.531
G1 X165.334 Y178.998
G1 X165.467 Y178.865
G1 X182.658 Y161.674 E.72413
G1 X182.791 Y161.541
G1 X182.791 Y161.007
G1 X182.658 Y161.141
G1 X165.341 Y178.458 E.72945
G1 X165.207 Y178.591
G1 X164.674 Y178.591
G1 X164.808 Y178.458
G1 X182.658 Y160.608 E.75192
G1 X182.791 Y160.474
G1 X182.791 Y159.941
G1 X182.658 Y160.075
G1 X164.275 Y178.458 E.77438
G1 X164.141 Y178.591
G1 X163.608 Y178.591
G1 X163.741 Y178.458
G1 X182.658 Y159.541 E.79684
G1 X182.791 Y159.408
G1 X182.791 Y158.874
G1 X182.658 Y159.008
G1 X163.208 Y178.458 E.81931
G1 X163.074 Y178.591
G1 X162.541 Y178.591
G1 X162.675 Y178.458
G1 X182.658 Y158.475 E.84177
G1 X182.791 Y158.341
G1 X182.791 Y157.808
G1 X182.658 Y157.942
G1 X162.141 Y178.458 E.86423
; WIPE_START
M204 S8000
G1 X163.556 Y177.043 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X164.328 Y184.637 Z2.4 F60000
G1 X165.131 Y192.532 Z2.4
G1 Z2
G1 E.8 F1800
G1 F9547.055
M204 S2000
G1 X161.331 Y196.333 E.16008
G1 X161.197 Y196.466
G1 X160.664 Y196.466
G1 X160.797 Y196.333
G1 X164.598 Y192.532 E.16008
G1 X164.731 Y192.399
G1 X164.198 Y192.399
G1 X164.064 Y192.532
G1 X160.264 Y196.333 E.16008
G1 X160.131 Y196.466
G1 X159.784 Y196.28
G1 X159.917 Y196.146
G1 X163.531 Y192.532 E.15223
G1 X163.665 Y192.399
G1 X163.132 Y192.399
G1 X162.998 Y192.532
G1 X159.917 Y195.613 E.12977
G1 X159.784 Y195.747
G1 X159.784 Y195.213
G1 X159.917 Y195.08
G1 X162.465 Y192.532 E.1073
G1 X162.598 Y192.399
G1 X162.066 Y192.398
G1 X161.933 Y192.531
G1 X159.917 Y194.546 E.08489
G1 X159.784 Y194.68
G1 X159.784 Y194.147
G1 X159.917 Y194.013
G1 X161.933 Y191.998 E.08489
G1 X162.066 Y191.864
G1 X162.066 Y191.331
G1 X161.933 Y191.465
G1 X159.917 Y193.48 E.08489
G1 X159.784 Y193.614
G1 X159.784 Y193.08
G1 X159.917 Y192.947
G1 X161.933 Y190.931 E.08489
G1 X162.066 Y190.798
G1 X162.066 Y190.265
G1 X161.933 Y190.398
G1 X159.917 Y192.413 E.08489
G1 X159.784 Y192.547
G1 X159.784 Y192.014
G1 X159.917 Y191.88
G1 X161.933 Y189.865 E.08489
G1 X162.066 Y189.731
G1 X162.066 Y189.198
G1 X161.933 Y189.332
G1 X159.917 Y191.347 E.08489
G1 X159.784 Y191.481
G1 X159.784 Y190.947
G1 X159.917 Y190.814
G1 X161.933 Y188.798 E.08489
G1 X162.066 Y188.665
G1 X162.066 Y188.132
G1 X161.933 Y188.265
G1 X159.917 Y190.28 E.08489
G1 X159.784 Y190.414
G1 X159.784 Y189.881
G1 X159.917 Y189.747
G1 X161.933 Y187.732 E.08489
G1 X162.066 Y187.598
G1 X162.066 Y187.065
G1 X161.933 Y187.199
G1 X159.917 Y189.214 E.08489
G1 X159.784 Y189.348
G1 X159.784 Y188.814
G1 X159.917 Y188.681
M73 P81 R4
G1 X161.933 Y186.665 E.08489
; WIPE_START
M204 S8000
G1 X160.518 Y188.08 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X159.917 Y188.147 Z2.4 F60000
G1 Z2
G1 E.8 F1800
G1 F9547.055
M204 S2000
G1 X163.532 Y184.532 E.15228
M73 P81 R3
G1 X163.666 Y184.399
G1 X163.133 Y184.399
G1 X162.999 Y184.532
G1 X159.917 Y187.614 E.12981
G1 X159.784 Y187.748
G1 X159.784 Y187.214
G1 X159.917 Y187.081
G1 X162.466 Y184.532 E.10735
G1 X162.599 Y184.399
G1 X162.066 Y184.399
G1 X161.933 Y184.532
G1 X159.917 Y186.548 E.08489
G1 X159.784 Y186.681
G1 X159.784 Y186.148
G1 X159.917 Y186.014
G1 X161.933 Y183.999 E.08489
G1 X162.066 Y183.865
G1 X162.066 Y183.332
G1 X161.933 Y183.466
G1 X159.917 Y185.481 E.08489
G1 X159.784 Y185.615
G1 X159.784 Y185.081
G1 X159.917 Y184.948
G1 X161.933 Y182.933 E.08489
G1 X162.066 Y182.799
G1 X162.066 Y182.266
G1 X161.933 Y182.399
G1 X159.917 Y184.415 E.08489
G1 X159.784 Y184.548
G1 X159.784 Y184.015
G1 X159.917 Y183.881
G1 X161.933 Y181.866 E.08489
G1 X162.066 Y181.732
G1 X162.066 Y181.199
G1 X161.933 Y181.333
G1 X159.917 Y183.348 E.08489
G1 X159.784 Y183.482
G1 X159.784 Y182.948
G1 X159.917 Y182.815
G1 X161.933 Y180.8 E.08489
G1 X162.066 Y180.666
G1 X162.066 Y180.133
G1 X161.933 Y180.266
G1 X159.917 Y182.282 E.08489
G1 X159.784 Y182.415
G1 X159.784 Y181.882
G1 X159.917 Y181.748
G1 X161.933 Y179.733 E.08489
G1 X162.066 Y179.599
G1 X162.066 Y179.066
G1 X161.933 Y179.2
G1 X159.917 Y181.215 E.08489
G1 X159.784 Y181.349
G1 X159.784 Y180.815
G1 X159.917 Y180.682
G1 X161.933 Y178.667 E.08489
; WIPE_START
M204 S8000
G1 X160.518 Y180.081 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X159.917 Y180.148 Z2.4 F60000
G1 Z2
G1 E.8 F1800
G1 F9547.055
M204 S2000
G1 X182.658 Y157.408 E.95792
G1 X182.791 Y157.275
G1 X182.791 Y156.741
G1 X182.658 Y156.875
G1 X159.917 Y179.615 E.95792
G1 X159.784 Y179.749
G1 X159.784 Y179.216
G1 X159.917 Y179.082
G1 X182.658 Y156.342 E.95792
G1 X182.791 Y156.208
G1 X182.791 Y155.675
G1 X182.658 Y155.808
G1 X159.917 Y178.549 E.95792
G1 X159.784 Y178.682
G1 X159.784 Y178.149
G1 X159.917 Y178.015
G1 X182.658 Y155.275 E.95792
G1 X182.791 Y155.142
G1 X182.791 Y154.608
G1 X182.658 Y154.742
G1 X159.917 Y177.482 E.95792
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
G1 X182.658 Y154.209 E.54447
G1 X182.791 Y154.075
G1 X182.791 Y153.542
G1 X182.658 Y153.675
G1 X169.732 Y166.601 E.54447
G1 X169.599 Y166.734
G1 X169.599 Y166.201
G1 X169.732 Y166.067
G1 X182.658 Y153.142 E.54447
G1 X182.791 Y153.009
G1 X182.791 Y152.475
G1 X182.658 Y152.609
G1 X169.732 Y165.534 E.54447
G1 X169.599 Y165.668
G1 X169.599 Y165.135
G1 X169.732 Y165.001
G1 X182.658 Y152.076 E.54447
G1 X182.791 Y151.942
G1 X182.791 Y151.409
G1 X182.658 Y151.542
G1 X169.732 Y164.468 E.54447
G1 X169.599 Y164.601
G1 X169.599 Y164.068
G1 X169.732 Y163.934
G1 X182.658 Y151.009 E.54447
G1 X182.791 Y150.876
G1 X182.791 Y150.342
G1 X182.658 Y150.476
G1 X169.732 Y163.401 E.54447
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
G1 X175.599 Y154.362 Z2.4 F60000
G1 X175.302 Y154.632 Z2.4
G1 Z2
G1 E.8 F1800
G1 F9547.055
M204 S2000
G1 X169.701 Y160.233 E.23591
G1 X169.568 Y160.366
G1 X169.034 Y160.366
G1 X169.168 Y160.233
G1 X174.768 Y154.632 E.23591
G1 X174.902 Y154.499
G1 X174.369 Y154.499
G1 X174.235 Y154.632
G1 X168.635 Y160.233 E.23591
G1 X168.501 Y160.366
G1 X167.968 Y160.366
G1 X168.102 Y160.233
G1 X173.702 Y154.632 E.23591
G1 X173.835 Y154.499
G1 X173.302 Y154.499
G1 X173.169 Y154.632
G1 X167.568 Y160.233 E.23591
G1 X167.435 Y160.366
G1 X166.901 Y160.366
G1 X167.035 Y160.233
G1 X172.635 Y154.632 E.23591
G1 X172.769 Y154.499
G1 X172.236 Y154.499
G1 X172.102 Y154.632
G1 X166.502 Y160.233 E.23591
G1 X166.368 Y160.366
G1 X165.835 Y160.366
G1 X165.969 Y160.233
G1 X171.569 Y154.632 E.23591
G1 X171.702 Y154.499
G1 X171.169 Y154.499
G1 X171.036 Y154.632
G1 X165.435 Y160.233 E.23591
G1 X165.302 Y160.366
G1 X164.768 Y160.366
G1 X164.902 Y160.233
G1 X170.502 Y154.632 E.23591
G1 X170.636 Y154.499
G1 X170.103 Y154.499
G1 X169.969 Y154.632
G1 X164.369 Y160.233 E.23591
G1 X164.235 Y160.366
G1 X163.702 Y160.366
G1 X163.836 Y160.233
G1 X169.436 Y154.632 E.23591
G1 X169.569 Y154.499
G1 X169.036 Y154.499
G1 X168.903 Y154.632
G1 X163.302 Y160.233 E.23591
G1 X163.169 Y160.366
G1 X162.635 Y160.366
G1 X162.769 Y160.233
G1 X168.369 Y154.632 E.23591
G1 X168.503 Y154.499
G1 X167.97 Y154.499
G1 X167.836 Y154.632
G1 X162.236 Y160.233 E.23591
G1 X162.102 Y160.366
G1 X161.569 Y160.366
G1 X161.702 Y160.233
G1 X167.303 Y154.632 E.23591
G1 X167.436 Y154.499
G1 X167.156 Y154.246
G1 X167.023 Y154.379
G1 X159.917 Y161.484 E.2993
G1 X159.784 Y161.618
G1 X159.784 Y161.085
G1 X159.917 Y160.951
G1 X167.023 Y153.846 E.2993
G1 X167.156 Y153.712
G1 X167.156 Y153.179
G1 X167.023 Y153.313
G1 X159.917 Y160.418 E.2993
G1 X159.784 Y160.552
G1 X159.784 Y160.018
G1 X159.917 Y159.885
G1 X167.023 Y152.779 E.2993
G1 X167.156 Y152.646
G1 X167.156 Y152.113
G1 X167.023 Y152.246
G1 X159.917 Y159.351 E.2993
G1 X159.784 Y159.485
G1 X159.784 Y158.952
G1 X159.917 Y158.818
G1 X167.023 Y151.713 E.2993
; WIPE_START
M204 S8000
G1 X165.608 Y153.127 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X170.764 Y158.755 Z2.4 F60000
G1 X190.083 Y179.846 Z2.4
G1 Z2
G1 E.8 F1800
G1 F9547.055
M204 S2000
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
M73 P82 R3
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
G1 X189.483 Y140.451 Z2.4 F60000
G1 Z2
G1 E.8 F1800
G1 F9547.055
M204 S2000
G1 X175.377 Y154.557 E.59418
G1 X175.244 Y154.69
G1 X175.244 Y154.157
G1 X175.377 Y154.023
G1 X187.483 Y141.917 E.50996
G1 X187.617 Y141.784
G1 X187.084 Y141.784
G1 X186.95 Y141.917
G1 X175.377 Y153.49 E.48749
G1 X175.244 Y153.624
G1 X175.244 Y153.09
G1 X175.377 Y152.957
G1 X186.417 Y141.917 E.46503
G1 X186.55 Y141.784
G1 X186.017 Y141.784
G1 X185.884 Y141.917
G1 X175.377 Y152.424 E.44257
G1 X175.244 Y152.557
G1 X175.244 Y152.024
G1 X175.377 Y151.89
G1 X185.35 Y141.917 E.4201
G1 X185.484 Y141.784
G1 X184.951 Y141.784
G1 X184.817 Y141.917
G1 X175.377 Y151.358 E.39767
G1 X175.243 Y151.491
G1 X174.71 Y151.491
G1 X174.844 Y151.358
G1 X184.284 Y141.917 E.39767
G1 X184.417 Y141.784
G1 X183.884 Y141.784
G1 X183.751 Y141.917
G1 X174.31 Y151.358 E.39767
G1 X174.177 Y151.491
G1 X173.643 Y151.491
G1 X173.777 Y151.358
G1 X183.217 Y141.917 E.39767
G1 X183.351 Y141.784
G1 X182.818 Y141.784
G1 X182.684 Y141.917
G1 X173.244 Y151.358 E.39767
G1 X173.11 Y151.491
G1 X172.577 Y151.491
G1 X172.711 Y151.358
G1 X182.151 Y141.917 E.39767
G1 X182.284 Y141.784
G1 X181.751 Y141.784
G1 X181.618 Y141.917
G1 X172.177 Y151.358 E.39767
G1 X172.044 Y151.491
G1 X171.51 Y151.491
G1 X171.644 Y151.358
G1 X181.084 Y141.917 E.39767
G1 X181.218 Y141.784
G1 X180.685 Y141.784
G1 X180.551 Y141.917
G1 X171.111 Y151.358 E.39767
G1 X170.977 Y151.491
G1 X170.444 Y151.491
G1 X170.578 Y151.358
G1 X180.018 Y141.917 E.39767
G1 X180.151 Y141.784
G1 X179.618 Y141.784
G1 X179.484 Y141.917
G1 X170.044 Y151.358 E.39767
G1 X169.911 Y151.491
G1 X169.377 Y151.491
G1 X169.511 Y151.358
G1 X178.951 Y141.917 E.39767
G1 X179.085 Y141.784
G1 X178.552 Y141.784
G1 X178.418 Y141.917
G1 X168.978 Y151.358 E.39767
G1 X168.844 Y151.491
G1 X168.311 Y151.491
G1 X168.444 Y151.358
G1 X177.885 Y141.917 E.39767
G1 X178.018 Y141.784
G1 X177.485 Y141.784
G1 X177.351 Y141.917
G1 X167.911 Y151.358 E.39767
G1 X167.778 Y151.491
G1 X167.244 Y151.491
G1 X167.378 Y151.358
G1 X176.883 Y141.853 E.40038
G1 X177.016 Y141.719
G1 X177.016 Y141.186
G1 X176.883 Y141.32
G1 X159.917 Y158.285 E.71465
G1 X159.784 Y158.419
G1 X159.784 Y157.885
G1 X159.917 Y157.752
G1 X165.362 Y152.307 E.22934
G1 X165.495 Y152.174
G1 X164.962 Y152.174
G1 X164.828 Y152.307
G1 X159.917 Y157.218 E.20688
G1 X159.784 Y157.352
G1 X159.784 Y156.819
G1 X159.917 Y156.685
G1 X164.295 Y152.307 E.18441
G1 X164.429 Y152.174
G1 X163.896 Y152.174
G1 X163.762 Y152.307
G1 X159.917 Y156.152 E.16195
G1 X159.784 Y156.286
G1 X159.784 Y155.752
G1 X159.917 Y155.619
G1 X163.229 Y152.307 E.13949
G1 X163.362 Y152.174
G1 X162.829 Y152.174
G1 X162.695 Y152.307
G1 X159.917 Y155.085 E.11702
G1 X159.784 Y155.219
G1 X159.784 Y154.686
G1 X159.917 Y154.552
G1 X162.162 Y152.307 E.09456
G1 X162.296 Y152.174
G1 X162.066 Y151.87
G1 X161.933 Y152.004
G1 X159.917 Y154.019 E.08489
G1 X159.784 Y154.153
G1 X159.784 Y153.619
G1 X159.917 Y153.486
G1 X161.933 Y151.47 E.08489
G1 X162.066 Y151.337
G1 X162.066 Y150.803
G1 X161.933 Y150.937
G1 X159.917 Y152.952 E.08489
G1 X159.784 Y153.086
G1 X159.784 Y152.553
G1 X159.917 Y152.419
G1 X161.933 Y150.404 E.08489
G1 X162.066 Y150.27
G1 X162.066 Y149.737
G1 X161.933 Y149.871
G1 X159.917 Y151.886 E.08489
G1 X159.784 Y152.019
G1 X159.784 Y151.486
G1 X159.917 Y151.353
G1 X161.933 Y149.337 E.08489
G1 X162.066 Y149.204
G1 X162.066 Y148.67
G1 X161.933 Y148.804
G1 X159.917 Y150.819 E.08489
G1 X159.784 Y150.953
G1 X159.784 Y150.42
G1 X159.917 Y150.286
G1 X161.933 Y148.271 E.08489
G1 X162.066 Y148.137
G1 X162.066 Y147.604
G1 X161.933 Y147.738
G1 X159.917 Y149.753 E.08489
G1 X159.784 Y149.886
G1 X159.784 Y149.353
G1 X159.917 Y149.22
G1 X161.933 Y147.204 E.08489
G1 X162.066 Y147.071
G1 X162.066 Y146.537
G1 X161.933 Y146.671
G1 X159.917 Y148.686 E.08489
G1 X159.784 Y148.82
G1 X159.784 Y148.287
G1 X159.917 Y148.153
G1 X161.933 Y146.138 E.08489
G1 X162.066 Y146.004
G1 X162.066 Y145.471
G1 X161.933 Y145.605
G1 X159.917 Y147.62 E.08489
G1 X159.784 Y147.753
G1 X159.784 Y147.22
G1 X159.917 Y147.087
G1 X161.933 Y145.071 E.08489
G1 X162.066 Y144.938
G1 X162.066 Y144.404
G1 X161.933 Y144.538
G1 X159.917 Y146.553 E.08489
G1 X159.784 Y146.687
G1 X159.784 Y146.154
G1 X159.917 Y146.02
G1 X161.933 Y144.005 E.08489
; WIPE_START
M204 S8000
G1 X160.518 Y145.419 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X165.017 Y151.585 Z2.4 F60000
G1 X165.467 Y152.202 Z2.4
G1 Z2
G1 E.8 F1800
G1 F9547.055
M204 S2000
G1 X176.883 Y140.786 E.48086
G1 X177.016 Y140.653
G1 X177.016 Y140.12
G1 X176.883 Y140.253
G1 X165.467 Y151.668 E.48086
G1 X165.334 Y151.802
G1 X165.334 Y151.269
G1 X165.467 Y151.135
G1 X176.883 Y139.72 E.48086
G1 X177.016 Y139.586
G1 X177.016 Y139.053
G1 X176.883 Y139.187
G1 X165.467 Y150.602 E.48086
G1 X165.334 Y150.736
G1 X165.334 Y150.202
G1 X165.467 Y150.069
G1 X176.883 Y138.653 E.48086
; WIPE_START
M204 S8000
G1 X175.468 Y140.068 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X183.052 Y140.93 Z2.4 F60000
G1 X187.917 Y141.483 Z2.4
G1 Z2
G1 E.8 F1800
G1 F9547.055
M204 S2000
G1 X189.483 Y139.918 E.06593
G1 X189.616 Y139.784
G1 X189.616 Y139.251
G1 X189.483 Y139.385
G1 X187.917 Y140.95 E.06593
G1 X187.784 Y141.084
G1 X187.784 Y140.55
G1 X187.917 Y140.417
G1 X189.483 Y138.852 E.06593
G1 X189.616 Y138.718
G1 X189.616 Y138.185
G1 X189.483 Y138.318
G1 X187.917 Y139.884 E.06593
G1 X187.784 Y140.017
G1 X187.784 Y139.484
G1 X187.917 Y139.35
G1 X189.483 Y137.785 E.06593
G1 X189.616 Y137.651
G1 X189.616 Y137.118
G1 X189.483 Y137.252
G1 X187.917 Y138.817 E.06593
G1 X187.784 Y138.951
G1 X187.784 Y138.417
G1 X187.917 Y138.284
M73 P83 R3
G1 X189.483 Y136.719 E.06593
G1 X189.616 Y136.585
G1 X189.616 Y136.052
G1 X189.483 Y136.185
G1 X187.535 Y138.133 E.08203
G1 X187.402 Y138.266
G1 X186.868 Y138.266
G1 X187.002 Y138.133
G1 X189.483 Y135.652 E.10449
G1 X189.616 Y135.518
G1 X189.616 Y134.985
G1 X189.483 Y135.119
G1 X186.469 Y138.133 E.12696
G1 X186.335 Y138.266
G1 X185.802 Y138.266
G1 X185.936 Y138.133
G1 X189.483 Y134.586 E.14942
G1 X189.616 Y134.452
G1 X189.616 Y133.919
G1 X189.483 Y134.052
G1 X185.402 Y138.133 E.17188
G1 X185.269 Y138.266
G1 X184.735 Y138.266
G1 X184.869 Y138.133
G1 X189.483 Y133.519 E.19435
G1 X189.616 Y133.385
G1 X189.616 Y132.852
G1 X189.483 Y132.986
G1 X184.336 Y138.133 E.21681
G1 X184.202 Y138.266
G1 X183.669 Y138.266
G1 X183.803 Y138.133
G1 X189.483 Y132.453 E.23927
G1 X189.616 Y132.319
G1 X189.616 Y131.786
G1 X189.483 Y131.919
G1 X187.917 Y133.484 E.06593
G1 X187.784 Y133.618
G1 X187.784 Y133.085
G1 X187.917 Y132.951
G1 X189.483 Y131.386 E.06593
G1 X189.616 Y131.252
G1 X189.616 Y130.719
G1 X189.483 Y130.853
G1 X187.917 Y132.418 E.06593
G1 X187.784 Y132.552
G1 X187.784 Y132.018
G1 X187.917 Y131.885
G1 X189.483 Y130.319 E.06593
G1 X189.616 Y130.186
G1 X189.616 Y129.653
G1 X189.483 Y129.786
G1 X187.917 Y131.351 E.06593
G1 X187.784 Y131.485
G1 X187.784 Y130.952
G1 X187.917 Y130.818
G1 X189.483 Y129.253 E.06593
G1 X189.616 Y129.119
G1 X189.616 Y128.586
G1 X189.483 Y128.72
G1 X187.917 Y130.285 E.06593
G1 X187.784 Y130.419
G1 X187.403 Y130.266
G1 X187.536 Y130.133
G1 X189.483 Y128.186 E.08198
G1 X189.616 Y128.053
G1 X189.352 Y127.784
G1 X189.218 Y127.917
G1 X187.003 Y130.133 E.09332
G1 X186.87 Y130.266
G1 X186.336 Y130.266
G1 X186.47 Y130.133
G1 X188.685 Y127.917 E.09332
G1 X188.819 Y127.784
G1 X188.286 Y127.784
G1 X188.152 Y127.917
G1 X185.937 Y130.133 E.09332
G1 X185.803 Y130.266
G1 X185.27 Y130.266
G1 X185.403 Y130.133
G1 X187.619 Y127.917 E.09332
G1 X187.752 Y127.784
G1 X187.219 Y127.784
G1 X187.085 Y127.917
G1 X184.87 Y130.133 E.09332
G1 X184.737 Y130.266
G1 X184.203 Y130.266
G1 X184.337 Y130.133
G1 X186.552 Y127.917 E.09332
G1 X186.686 Y127.784
G1 X186.153 Y127.784
G1 X186.019 Y127.917
G1 X183.804 Y130.133 E.09332
G1 X183.67 Y130.266
G1 X183.137 Y130.266
G1 X183.27 Y130.133
G1 X185.486 Y127.917 E.09332
G1 X185.619 Y127.784
G1 X185.086 Y127.784
G1 X184.952 Y127.917
G1 X182.737 Y130.133 E.09332
G1 X182.603 Y130.266
G1 X182.07 Y130.266
G1 X182.204 Y130.133
G1 X184.419 Y127.917 E.09332
G1 X184.553 Y127.784
G1 X184.019 Y127.784
G1 X183.886 Y127.917
G1 X181.671 Y130.133 E.09332
G1 X181.537 Y130.266
G1 X181.004 Y130.266
G1 X181.137 Y130.133
G1 X183.353 Y127.917 E.09332
G1 X183.486 Y127.784
G1 X182.953 Y127.784
G1 X182.819 Y127.917
G1 X180.604 Y130.133 E.09332
G1 X180.47 Y130.266
G1 X179.937 Y130.266
G1 X180.071 Y130.133
G1 X182.286 Y127.917 E.09332
G1 X182.42 Y127.784
G1 X181.886 Y127.784
G1 X181.753 Y127.917
G1 X179.538 Y130.133 E.09332
G1 X179.404 Y130.266
G1 X178.871 Y130.266
G1 X179.004 Y130.133
G1 X181.22 Y127.917 E.09332
G1 X181.353 Y127.784
G1 X180.82 Y127.784
G1 X180.686 Y127.917
G1 X178.471 Y130.133 E.09332
G1 X178.337 Y130.266
G1 X177.804 Y130.266
G1 X177.938 Y130.133
G1 X180.153 Y127.917 E.09332
G1 X180.287 Y127.784
G1 X179.753 Y127.784
G1 X179.62 Y127.917
G1 X177.405 Y130.133 E.09332
; WIPE_START
M204 S8000
G1 X178.819 Y128.718 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X182.081 Y135.619 Z2.4 F60000
G1 X183.269 Y138.133 Z2.4
G1 Z2
G1 E.8 F1800
G1 F9547.055
M204 S2000
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
G1 X181.085 Y133.917 Z2.4 F60000
G1 Z2
G1 E.8 F1800
G1 F9547.055
M204 S2000
G1 X165.467 Y149.535 E.6579
G1 X165.334 Y149.669
G1 X165.334 Y149.136
G1 X165.467 Y149.002
G1 X180.552 Y133.917 E.63544
G1 X180.686 Y133.784
G1 X180.153 Y133.784
G1 X180.019 Y133.917
G1 X165.467 Y148.469 E.61298
G1 X165.334 Y148.603
G1 X165.334 Y148.069
G1 X165.467 Y147.936
G1 X179.486 Y133.917 E.59051
G1 X179.619 Y133.784
G1 X179.086 Y133.784
G1 X178.952 Y133.917
G1 X165.467 Y147.402 E.56805
G1 X165.334 Y147.536
G1 X165.334 Y147.003
G1 X165.467 Y146.869
G1 X178.419 Y133.917 E.54559
G1 X178.553 Y133.784
G1 X178.019 Y133.784
G1 X177.886 Y133.917
G1 X165.467 Y146.336 E.52312
G1 X165.334 Y146.469
G1 X165.334 Y145.936
G1 X165.467 Y145.803
G1 X177.353 Y133.917 E.50066
G1 X177.486 Y133.784
G1 X177.016 Y133.72
G1 X176.883 Y133.854
G1 X165.467 Y145.269 E.48086
G1 X165.334 Y145.403
G1 X165.334 Y144.87
G1 X165.467 Y144.736
G1 X176.883 Y133.321 E.48086
G1 X177.016 Y133.187
G1 X177.016 Y132.654
G1 X176.883 Y132.788
G1 X165.467 Y144.203 E.48086
G1 X165.334 Y144.336
G1 X165.311 Y143.826
G1 X165.444 Y143.693
G1 X176.883 Y132.254 E.48183
G1 X177.016 Y132.121
G1 X177.016 Y131.587
G1 X176.883 Y131.721
G1 X164.911 Y143.693 E.5043
G1 X164.777 Y143.826
G1 X164.244 Y143.826
G1 X164.378 Y143.693
G1 X166.263 Y141.807 E.07941
G1 X166.397 Y141.674
G1 X165.863 Y141.674
G1 X165.73 Y141.807
G1 X163.845 Y143.693 E.07941
G1 X163.711 Y143.826
G1 X163.178 Y143.826
G1 X163.311 Y143.693
G1 X165.197 Y141.807 E.07941
G1 X165.33 Y141.674
G1 X164.797 Y141.674
G1 X164.663 Y141.807
G1 X162.778 Y143.693 E.07941
G1 X162.644 Y143.826
G1 X162.111 Y143.826
G1 X162.245 Y143.693
G1 X164.13 Y141.807 E.07941
G1 X164.264 Y141.674
G1 X163.73 Y141.674
G1 X163.597 Y141.807
G1 X159.917 Y145.487 E.15499
G1 X159.784 Y145.62
G1 X159.784 Y145.087
G1 X159.917 Y144.953
G1 X163.063 Y141.807 E.13253
G1 X163.197 Y141.674
G1 X162.966 Y141.371
G1 X162.833 Y141.505
G1 X159.917 Y144.42 E.1228
G1 X159.784 Y144.554
G1 X159.784 Y144.021
G1 X159.917 Y143.887
G1 X162.833 Y140.972 E.1228
G1 X162.966 Y140.838
G1 X162.966 Y140.305
G1 X162.833 Y140.439
G1 X159.917 Y143.354 E.1228
G1 X159.784 Y143.487
G1 X159.784 Y142.954
G1 X159.917 Y142.82
G1 X162.833 Y139.905 E.1228
G1 X162.966 Y139.772
G1 X162.966 Y139.238
G1 X162.833 Y139.372
G1 X159.917 Y142.287 E.1228
G1 X159.784 Y142.421
G1 X159.784 Y141.888
G1 X159.917 Y141.754
G1 X162.833 Y138.839 E.1228
G1 X162.966 Y138.705
G1 X162.966 Y138.172
G1 X162.833 Y138.305
G1 X159.917 Y141.221 E.1228
G1 X159.784 Y141.354
G1 X159.784 Y140.821
G1 X159.917 Y140.687
G1 X162.833 Y137.772 E.1228
G1 X162.966 Y137.639
G1 X162.966 Y137.105
G1 X162.833 Y137.239
G1 X159.917 Y140.154 E.1228
G1 X159.784 Y140.288
G1 X159.784 Y139.755
G1 X159.917 Y139.621
G1 X162.833 Y136.706 E.1228
G1 X162.966 Y136.572
G1 X162.966 Y136.039
G1 X162.833 Y136.172
G1 X159.917 Y139.088 E.1228
G1 X159.784 Y139.221
G1 X159.784 Y138.688
G1 X159.917 Y138.554
G1 X162.833 Y135.639 E.1228
G1 X162.966 Y135.506
G1 X162.966 Y134.972
G1 X162.833 Y135.106
G1 X159.917 Y138.021 E.1228
G1 X159.784 Y138.155
G1 X159.784 Y137.622
G1 X159.917 Y137.488
G1 X162.833 Y134.573 E.1228
G1 X162.966 Y134.439
G1 X162.966 Y133.906
G1 X162.833 Y134.039
G1 X159.917 Y136.955 E.1228
G1 X159.784 Y137.088
G1 X159.784 Y136.555
G1 X159.917 Y136.421
G1 X162.833 Y133.506 E.1228
; WIPE_START
M204 S8000
G1 X161.418 Y134.92 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X165.917 Y141.086 Z2.4 F60000
G1 X166.367 Y141.703 Z2.4
G1 Z2
G1 E.8 F1800
G1 F9547.055
M204 S2000
G1 X176.883 Y131.188 E.44295
G1 X177.016 Y131.054
G1 X177.016 Y130.521
G1 X176.883 Y130.655
G1 X166.367 Y141.17 E.44295
G1 X166.234 Y141.303
G1 X166.234 Y140.77
G1 X166.367 Y140.637
G1 X179.087 Y127.917 E.53579
G1 X179.22 Y127.784
G1 X178.687 Y127.784
G1 X178.553 Y127.917
G1 X166.367 Y140.103 E.51333
G1 X166.234 Y140.237
G1 X166.234 Y139.704
G1 X166.367 Y139.57
G1 X178.02 Y127.917 E.49086
G1 X178.154 Y127.784
G1 X177.62 Y127.784
G1 X177.487 Y127.917
G1 X166.367 Y139.037 E.4684
G1 X166.234 Y139.17
G1 X166.234 Y138.637
G1 X166.367 Y138.504
G1 X176.954 Y127.917 E.44594
G1 X177.087 Y127.784
G1 X176.554 Y127.784
G1 X176.42 Y127.917
G1 X166.367 Y137.97 E.42347
G1 X166.234 Y138.104
G1 X166.234 Y137.571
G1 X166.367 Y137.437
G1 X175.887 Y127.917 E.40101
G1 X176.021 Y127.784
G1 X175.487 Y127.784
G1 X175.354 Y127.917
G1 X166.367 Y136.904 E.37855
G1 X166.234 Y137.037
G1 X166.234 Y136.504
G1 X166.367 Y136.37
G1 X174.82 Y127.917 E.35608
G1 X174.954 Y127.784
G1 X174.421 Y127.784
G1 X174.287 Y127.917
G1 X166.367 Y135.837 E.33362
G1 X166.234 Y135.971
G1 X166.234 Y135.438
G1 X166.367 Y135.304
G1 X173.754 Y127.917 E.31116
G1 X173.888 Y127.784
G1 X173.354 Y127.784
G1 X173.221 Y127.917
G1 X166.367 Y134.771 E.28869
G1 X166.234 Y134.904
G1 X166.234 Y134.371
G1 X166.367 Y134.237
G1 X168.677 Y131.927 E.09731
G1 X168.811 Y131.794
G1 X168.278 Y131.794
G1 X168.144 Y131.927
G1 X166.367 Y133.704 E.07485
G1 X166.234 Y133.838
G1 X166.212 Y133.326
G1 X166.346 Y133.193
G1 X167.611 Y131.927 E.0533
G1 X167.745 Y131.794
G1 X166.972 Y132.033
G1 X166.839 Y132.166
G1 X165.812 Y133.193 E.04324
G1 X165.679 Y133.326
G1 X165.146 Y133.326
G1 X165.279 Y133.193
G1 X166.306 Y132.166 E.04324
G1 X166.439 Y132.033
G1 X165.906 Y132.033
G1 X165.772 Y132.166
G1 X164.746 Y133.193 E.04324
G1 X164.612 Y133.326
G1 X164.079 Y133.326
G1 X164.213 Y133.193
G1 X165.239 Y132.166 E.04324
G1 X165.373 Y132.033
G1 X164.839 Y132.033
G1 X164.706 Y132.166
G1 X163.679 Y133.193 E.04324
G1 X163.546 Y133.326
G1 X163.013 Y133.326
G1 X163.146 Y133.193
G1 X164.173 Y132.166 E.04324
G1 X164.306 Y132.033
G1 X163.773 Y132.033
G1 X163.639 Y132.166
G1 X159.917 Y135.888 E.15678
G1 X159.784 Y136.022
G1 X159.784 Y135.489
G1 X159.917 Y135.355
G1 X163.106 Y132.166 E.13432
G1 X163.24 Y132.033
G1 X162.706 Y132.033
G1 X162.573 Y132.166
G1 X159.917 Y134.822 E.11186
G1 X159.784 Y134.955
G1 X159.784 Y134.422
G1 X159.917 Y134.288
G1 X162.039 Y132.166 E.08939
G1 X162.173 Y132.033
G1 X161.64 Y132.033
G1 X161.506 Y132.166
M73 P84 R3
G1 X159.917 Y133.755 E.06693
G1 X159.784 Y133.889
G1 X159.784 Y133.355
G1 X159.917 Y133.222
G1 X160.973 Y132.166 E.04447
G1 X161.107 Y132.033
G1 X160.573 Y132.033
G1 X160.44 Y132.166
G1 X159.917 Y132.689 E.022
; WIPE_START
M204 S8000
G1 X160.44 Y132.166 E-.28071
G1 X160.573 Y132.033 E-.07182
G1 X161.107 Y132.033 E-.20264
G1 X160.973 Y132.166 E-.07182
G1 X160.725 Y132.414 E-.13302
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X168.323 Y131.69 Z2.4 F60000
G1 X168.977 Y131.627 Z2.4
G1 Z2
G1 E.8 F1800
G1 F9547.055
M204 S2000
G1 X172.687 Y127.917 E.15628
G1 X172.821 Y127.784
G1 X172.288 Y127.784
G1 X172.154 Y127.917
G1 X168.977 Y131.094 E.13382
G1 X168.844 Y131.228
G1 X168.844 Y130.695
G1 X168.977 Y130.561
G1 X171.621 Y127.917 E.11136
G1 X171.755 Y127.784
G1 X171.221 Y127.784
G1 X171.088 Y127.917
G1 X168.977 Y130.028 E.0889
G1 X168.844 Y130.161
G1 X168.844 Y129.628
G1 X168.977 Y129.494
G1 X170.554 Y127.917 E.06643
G1 X170.688 Y127.784
G1 X170.155 Y127.784
G1 X170.021 Y127.917
G1 X168.977 Y128.961 E.04397
G1 X168.844 Y129.095
G1 X168.844 Y128.562
G1 X168.977 Y128.428
G1 X169.488 Y127.917 E.02151
; WIPE_START
M204 S8000
G1 X168.977 Y128.428 E-.27435
G1 X168.844 Y128.562 E-.07182
G1 X168.844 Y129.095 E-.20264
G1 X168.977 Y128.961 E-.07182
G1 X169.237 Y128.702 E-.13937
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z2.4 I-1.204 J-.175 P1  F60000
G1 X162.036 Y178.352 Z2.4
G1 Z2
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.121861
G1 F15000
M204 S8000
G1 X161.827 Y178.561 E.00184
; WIPE_START
G1 X162.036 Y178.352 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X163.177 Y170.806 Z2.4 F60000
G1 X169.074 Y131.798 Z2.4
G1 Z2
G1 E.8 F1800
; LINE_WIDTH: 0.109219
G1 F15000
M204 S8000
G1 X168.976 Y131.652 E.00092
; COOLING_NODE: 11
; WIPE_START
G1 X169.074 Y131.798 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z2.4 I1.122 J-.471 P1  F60000
G1 X162.78 Y116.815 Z2.4
G1 Z2
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X162.77 Y116.784 E.00097
G3 X163.957 Y115.147 I1.329 J-.284 E.0679
G1 X164.083 Y115.14 E.00374
G3 X162.855 Y117.047 I.017 J1.359 E.1745
G1 X162.798 Y116.872 E.0055
; COOLING_NODE: 10
; WIPE_START
M204 S8000
G1 X162.77 Y116.784 E-.03513
G1 X162.74 Y116.525 E-.09889
G1 X162.76 Y116.264 E-.09954
G1 X162.83 Y116.013 E-.09877
G1 X162.947 Y115.779 E-.09952
G1 X163.121 Y115.555 E-.10798
G1 X163.225 Y115.459 E-.05376
G1 X163.441 Y115.31 E-.09948
G1 X163.602 Y115.24 E-.06692
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
; COOLING_NODE: 10
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
; COOLING_NODE: 10
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

M73 P85 R3
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
; COOLING_NODE: 10
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
; COOLING_NODE: 10
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
; COOLING_NODE: 10
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
; COOLING_NODE: 10
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
; COOLING_NODE: 10
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
; COOLING_NODE: 10
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
; COOLING_NODE: 10
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
M73 P86 R2
G1 X160.102 Y132.112 E.02559
G1 X168.038 Y132.112 E.25519
; COOLING_NODE: 10
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
; COOLING_NODE: 10
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
; COOLING_NODE: 10
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
; COOLING_NODE: 10
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
; COOLING_NODE: 10
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
; COOLING_NODE: 10
; WIPE_START
G1 F9259.259
G1 X162.306 Y132.51 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
M73 P87 R2
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
; COOLING_NODE: 10
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
; COOLING_NODE: 10
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
; COOLING_NODE: 10
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
; COOLING_NODE: 10
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
; COOLING_NODE: 10
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
M73 P88 R2
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
; COOLING_NODE: 10
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
; COOLING_NODE: 10
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
; COOLING_NODE: 10
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
; COOLING_NODE: 10
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
G1 X159.688 Y130.658 E.04487
G1 X167.118 Y123.228 E.3801
G1 X168.359 Y123.228 E.04487
G1 X160.616 Y130.972 E.39612
G1 X161.856 Y130.972 E.04487
M73 P89 R2
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
; COOLING_NODE: 10
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
; COOLING_NODE: 10
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
; COOLING_NODE: 10
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
; COOLING_NODE: 10
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
; COOLING_NODE: 10
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
; COOLING_NODE: 10
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
; COOLING_NODE: 10
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
; COOLING_NODE: 10
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
; COOLING_NODE: 10
M204 S10000
G17
M73 P90 R2
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
; COOLING_NODE: 10
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
; COOLING_NODE: 10
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
; COOLING_NODE: 10
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
; COOLING_NODE: 10
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
; COOLING_NODE: 10
M204 S10000
G1 X167.691 Y132.501 F60000
G1 F1543
M204 S8000
G1 X160.509 Y132.501 E.23094
G1 X160.509 Y121.699 E.34734
G1 X167.691 Y121.699 E.23094
G1 X167.691 Y132.441 E.34542
; COOLING_NODE: 10
M204 S10000
G1 X168.098 Y132.908 F60000
G1 F1543
M204 S8000
G1 X160.102 Y132.908 E.25712
G1 X160.102 Y121.292 E.37352
G1 X168.098 Y121.292 E.25712
G1 X168.098 Y132.848 E.37159
; COOLING_NODE: 10
M204 S250
G1 X168.49 Y133.3 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
M73 P91 R1
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
; COOLING_NODE: 10
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
; COOLING_NODE: 10
M204 S10000
G1 X167.691 Y132.501 F60000
G1 F1541
M204 S8000
G1 X160.509 Y132.501 E.23094
G1 X160.509 Y121.699 E.34734
G1 X167.691 Y121.699 E.23094
G1 X167.691 Y132.441 E.34542
; COOLING_NODE: 10
M204 S10000
G1 X168.098 Y132.908 F60000
G1 F1541
M204 S8000
G1 X160.102 Y132.908 E.25712
G1 X160.102 Y121.292 E.37352
G1 X168.098 Y121.292 E.25712
G1 X168.098 Y132.848 E.37159
; COOLING_NODE: 10
M204 S250
G1 X168.49 Y133.3 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
M73 P92 R1
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
; COOLING_NODE: 10
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
; COOLING_NODE: 10
M204 S10000
G1 X167.691 Y132.501 F60000
G1 F1539
M204 S8000
G1 X160.509 Y132.501 E.23094
G1 X160.509 Y121.699 E.34734
G1 X167.691 Y121.699 E.23094
G1 X167.691 Y132.441 E.34542
; COOLING_NODE: 10
M204 S10000
G1 X168.098 Y132.908 F60000
G1 F1539
M204 S8000
G1 X160.102 Y132.908 E.25712
G1 X160.102 Y121.292 E.37352
G1 X168.098 Y121.292 E.25712
G1 X168.098 Y132.848 E.37159
; COOLING_NODE: 10
M204 S250
M73 P93 R1
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
; COOLING_NODE: 10
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
; COOLING_NODE: 10
M204 S10000
G1 X167.691 Y132.501 F60000
G1 F1540
M204 S8000
G1 X160.509 Y132.501 E.23094
G1 X160.509 Y121.699 E.34734
G1 X167.691 Y121.699 E.23094
G1 X167.691 Y132.441 E.34542
; COOLING_NODE: 10
M204 S10000
G1 X168.098 Y132.908 F60000
G1 F1540
M204 S8000
G1 X160.102 Y132.908 E.25712
G1 X160.102 Y121.292 E.37352
M73 P94 R1
G1 X168.098 Y121.292 E.25712
G1 X168.098 Y132.848 E.37159
; COOLING_NODE: 10
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
; COOLING_NODE: 10
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
; COOLING_NODE: 10
M204 S10000
G1 X167.691 Y132.501 F60000
G1 F1539
M204 S8000
G1 X160.509 Y132.501 E.23094
G1 X160.509 Y121.699 E.34734
G1 X167.691 Y121.699 E.23094
G1 X167.691 Y132.441 E.34542
; COOLING_NODE: 10
M204 S10000
G1 X168.098 Y132.908 F60000
G1 F1539
M204 S8000
G1 X160.102 Y132.908 E.25712
M73 P95 R1
G1 X160.102 Y121.292 E.37352
G1 X168.098 Y121.292 E.25712
G1 X168.098 Y132.848 E.37159
; COOLING_NODE: 10
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
; COOLING_NODE: 10
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
; COOLING_NODE: 10
M204 S10000
G1 X167.691 Y132.501 F60000
G1 F1540
M204 S8000
G1 X160.509 Y132.501 E.23094
G1 X160.509 Y121.699 E.34734
G1 X167.691 Y121.699 E.23094
G1 X167.691 Y132.441 E.34542
; COOLING_NODE: 10
M204 S10000
G1 X168.098 Y132.908 F60000
G1 F1540
M204 S8000
G1 X160.102 Y132.908 E.25712
M73 P96 R0
G1 X160.102 Y121.292 E.37352
G1 X168.098 Y121.292 E.25712
G1 X168.098 Y132.848 E.37159
; COOLING_NODE: 10
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
; COOLING_NODE: 10
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
; COOLING_NODE: 10
M204 S10000
G1 X167.691 Y132.501 F60000
G1 F1539
M204 S8000
G1 X160.509 Y132.501 E.23094
G1 X160.509 Y121.699 E.34734
G1 X167.691 Y121.699 E.23094
G1 X167.691 Y132.441 E.34542
; COOLING_NODE: 10
M204 S10000
G1 X168.098 Y132.908 F60000
G1 F1539
M204 S8000
G1 X160.102 Y132.908 E.25712
M73 P97 R0
G1 X160.102 Y121.292 E.37352
G1 X168.098 Y121.292 E.25712
G1 X168.098 Y132.848 E.37159
; COOLING_NODE: 10
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
; COOLING_NODE: 10
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
G1 X167.646 Y125.709 Z5.8 F60000
G1 X168.283 Y121.554 Z5.8
G1 Z5.4
G1 E.8 F1800
; FEATURE: Top surface
G1 F1805
M204 S2000
G1 X167.836 Y121.107 E.01881
M73 P98 R0
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
G1 X159.784 Y126.386
G1 X159.917 Y126.52
M73 P99 R0
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

