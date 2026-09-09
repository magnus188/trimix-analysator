; HEADER_BLOCK_START
; BambuStudio 02.08.02.61
; model printing time: 4m 22s; total estimated time: 9m 49s
; total layer number: 19
; total filament length [mm] : 226.02
; total filament volume [cm^3] : 543.64
; total filament weight [g] : 0.69
; filament_density: 1.27
; filament_diameter: 1.75
; max_z_height: 3.80
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
M73 P0 R9
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
M73 P4 R9
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
M73 P8 R9
G1 Z5 F1200
G90
G1 X175 Y160 F30000

M622 J1
    M1002 gcode_claim_action : 1
    G29.20 A3
    G29 A1 O X161.094 Y146.095 I27.8106 J27.8104 R
    M400
M623

M622 J2
    M1002 gcode_claim_action : 1
    
        G29.20 A4
        G29 A2 O X161.094 Y146.095 I27.8106 J27.8104 R
    
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
M73 P52 R4
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
M73 P53 R4
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
; layer num/total_layer_count: 1/19
; update layer progress
M73 L1
M991 S0 P0 ;notify layer change

M106 S0
M106 P2 S0
; OBJECT_ID: 15
G1 X164.936 Y150.737 F60000
M204 S6000
M73 P55 R4
G1 Z.4
G1 Z.2
G1 E.8 F1800
; FEATURE: Brim
; LINE_WIDTH: 0.5
G1 F3000
M204 S500
G1 X165.433 Y150.225 E.02579
G1 X165.959 Y149.736 E.02591
G1 X166.434 Y149.337 E.02241
G1 X167.03 Y148.884 E.02704
G1 X167.504 Y148.559 E.02074
G1 X168.084 Y148.199 E.02466
G1 X168.71 Y147.854 E.02578
G1 X169.353 Y147.542 E.02582
G1 X169.925 Y147.299 E.02245
G1 X170.598 Y147.05 E.02592
G1 X171.177 Y146.868 E.02189
G1 X171.837 Y146.693 E.02467
G1 X172.534 Y146.546 E.02572
G1 X173.242 Y146.436 E.02588
G1 X173.86 Y146.37 E.02242
G1 X174.609 Y146.328 E.02708
G1 X175.189 Y146.324 E.02095
G1 X175.865 Y146.35 E.02444
G1 X176.577 Y146.413 E.02579
G1 X177.285 Y146.514 E.02582
G1 X177.895 Y146.632 E.02244
G1 X178.623 Y146.811 E.02704
G1 X179.277 Y147.008 E.02466
G1 X179.953 Y147.251 E.02595
G1 X181.045 Y147.731 E.04305
G1 X181.582 Y148.011 E.02189
G1 X182.173 Y148.354 E.02465
G1 X182.771 Y148.744 E.02579
G1 X183.274 Y149.109 E.02245
G1 X183.749 Y149.487 E.02191
G1 X184.262 Y149.936 E.02462
G1 X184.775 Y150.433 E.0258
G1 X185.262 Y150.958 E.02585
G1 X185.663 Y151.433 E.02245
G1 X186.116 Y152.03 E.02705
G1 X186.441 Y152.504 E.02074
G1 X186.8 Y153.083 E.02459
G1 X187.146 Y153.71 E.02586
G1 X187.471 Y154.382 E.02695
G1 X187.714 Y154.955 E.02248
G1 X187.914 Y155.494 E.02076
G1 X188.132 Y156.174 E.02578
G1 X188.307 Y156.836 E.02473
G1 X188.459 Y157.565 E.02689
G1 X188.556 Y158.181 E.0225
G1 X188.62 Y158.747 E.02055
G1 X188.666 Y159.432 E.02481
G1 X188.676 Y160.179 E.02695
G1 X188.654 Y160.807 E.0227
G1 X188.593 Y161.522 E.02589
G1 X188.519 Y162.079 E.02031
G1 X188.397 Y162.755 E.02481
G1 X188.235 Y163.453 E.02586
G1 X188.064 Y164.05 E.02243
G1 X187.884 Y164.593 E.02063
G1 X187.614 Y165.289 E.02696
G1 X187.333 Y165.915 E.02478
G1 X187.007 Y166.551 E.0258
G1 X186.697 Y167.09 E.02245
G1 X186.37 Y167.602 E.02194
G1 X185.976 Y168.161 E.02469
G1 X185.536 Y168.722 E.02576
G1 X185.066 Y169.261 E.02582
G1 X184.567 Y169.775 E.02584
G1 X184.019 Y170.283 E.02701
G1 X183.537 Y170.687 E.02271
G1 X182.965 Y171.119 E.02587
G1 X182.501 Y171.437 E.02031
G1 X181.792 Y171.872 E.03004
G1 X180.835 Y172.37 E.03893
G1 X180.178 Y172.66 E.02594
G1 X179.598 Y172.882 E.02243
G1 X178.917 Y173.105 E.02585
G1 X178.226 Y173.292 E.02584
G1 X177.558 Y173.436 E.0247
G1 X176.85 Y173.552 E.02588
G1 X176.285 Y173.617 E.02054
G1 X175.423 Y173.671 E.03119
G1 X174.854 Y173.677 E.02055
G1 X174.232 Y173.656 E.02248
G1 X173.63 Y173.609 E.02178
G1 X173.012 Y173.533 E.02248
G1 X172.243 Y173.397 E.02822
G1 X171.518 Y173.227 E.02687
G1 X170.919 Y173.055 E.02249
G1 X170.38 Y172.873 E.02056
G1 X169.709 Y172.613 E.02597
G1 X169.142 Y172.36 E.02241
G1 X168.503 Y172.036 E.02587
G1 X167.828 Y171.647 E.02812
G1 X167.307 Y171.309 E.02241
G1 X166.725 Y170.891 E.02589
G1 X166.279 Y170.537 E.02055
G1 X165.739 Y170.066 E.02589
G1 X165.225 Y169.567 E.02586
G1 X164.717 Y169.018 E.027
G1 X164.317 Y168.541 E.02249
G1 X163.884 Y167.97 E.02587
G1 X163.559 Y167.496 E.02074
G1 X163.199 Y166.915 E.02467
G1 X162.841 Y166.263 E.02688
G1 X162.568 Y165.703 E.0225
G1 X162.298 Y165.073 E.02472
G1 X162.086 Y164.506 E.02188
G1 X161.868 Y163.826 E.02578
G1 X161.693 Y163.163 E.02474
G1 X161.546 Y162.466 E.02574
G1 X161.448 Y161.85 E.0225
G1 X161.379 Y161.247 E.02192
G1 X161.334 Y160.568 E.0246
G1 X161.323 Y159.853 E.02579
G1 X161.349 Y159.137 E.02588
G1 X161.403 Y158.518 E.02243
G1 X161.504 Y157.775 E.02709
G1 X161.633 Y157.104 E.02466
G1 X161.811 Y156.378 E.02701
G1 X162.008 Y155.723 E.0247
G1 X162.211 Y155.15 E.02193
G1 X162.443 Y154.577 E.02232
G1 X162.731 Y153.955 E.02473
G1 X163.011 Y153.417 E.0219
G1 X163.32 Y152.882 E.02233
G1 X163.691 Y152.307 E.02472
G1 X164.022 Y151.842 E.02059
G1 X164.484 Y151.255 E.02697
G1 X164.896 Y150.783 E.02264
M204 S6000
G1 X165.24 Y151.083 F60000
G1 F3000
M204 S500
G1 X165.27 Y151.05 E.00161
G1 X165.755 Y150.549 E.02519
G1 X166.259 Y150.081 E.02481
G1 X166.717 Y149.696 E.02159
G1 X167.295 Y149.257 E.02623
G1 X167.751 Y148.944 E.01996
G1 X168.319 Y148.592 E.02411
G1 X168.917 Y148.262 E.02467
G1 X169.539 Y147.96 E.02498
G1 X170.091 Y147.725 E.02164
G1 X170.743 Y147.484 E.02512
G1 X171.301 Y147.308 E.0211
G1 X171.946 Y147.137 E.0241
G1 X172.613 Y146.997 E.02461
G1 X173.299 Y146.889 E.02505
G1 X173.894 Y146.826 E.02162
G1 X174.62 Y146.785 E.02625
G1 X175.185 Y146.781 E.02041
G1 X175.84 Y146.806 E.02366
G1 X176.521 Y146.867 E.02468
G1 X177.206 Y146.965 E.02499
G1 X177.794 Y147.078 E.02163
G1 X178.506 Y147.253 E.02645
G1 X179.137 Y147.444 E.0238
G1 X179.788 Y147.678 E.025
G1 X180.843 Y148.141 E.04159
G1 X181.359 Y148.41 E.02102
G1 X181.936 Y148.745 E.02407
G1 X182.509 Y149.119 E.02471
G1 X183 Y149.475 E.0219
G1 X183.459 Y149.84 E.02117
G1 X183.955 Y150.274 E.02382
G1 X184.451 Y150.755 E.02494
G1 X184.918 Y151.258 E.02476
G1 X185.303 Y151.716 E.02163
G1 X185.743 Y152.295 E.02623
G1 X186.059 Y152.757 E.02021
G1 X186.407 Y153.317 E.02381
G1 X186.738 Y153.917 E.02473
G1 X187.053 Y154.568 E.02612
G1 X187.288 Y155.122 E.02172
G1 X187.483 Y155.647 E.02023
G1 X187.694 Y156.306 E.02499
G1 X187.863 Y156.945 E.02387
G1 X188.009 Y157.645 E.0258
G1 X188.103 Y158.239 E.02174
G1 X188.165 Y158.791 E.02003
G1 X188.209 Y159.454 E.02402
G1 X188.219 Y160.177 E.02609
G1 X188.197 Y160.783 E.02189
G1 X188.139 Y161.469 E.02485
G1 X188.066 Y162.012 E.01979
G1 X187.949 Y162.667 E.02402
G1 X187.791 Y163.344 E.02513
G1 X187.456 Y164.432 E.04108
G1 X187.19 Y165.116 E.02649
G1 X186.919 Y165.72 E.02392
G1 X186.607 Y166.329 E.02471
G1 X186.307 Y166.85 E.02169
G1 X185.989 Y167.35 E.02142
G1 X185.608 Y167.891 E.02388
G1 X185.181 Y168.433 E.02491
G1 X184.727 Y168.954 E.02496
G1 X184.245 Y169.45 E.02497
G1 X183.719 Y169.938 E.0259
G1 X183.254 Y170.327 E.02188
G1 X182.7 Y170.746 E.02508
G1 X182.255 Y171.052 E.0195
G1 X181.562 Y171.476 E.02934
G1 X180.641 Y171.956 E.03748
G1 X180.001 Y172.238 E.02528
G1 X179.441 Y172.452 E.02163
G1 X178.783 Y172.668 E.02501
G1 X178.122 Y172.847 E.02473
G1 X177.476 Y172.986 E.02385
G1 X176.79 Y173.099 E.02509
G1 X176.241 Y173.162 E.01997
G1 X175.41 Y173.214 E.03006
G1 X174.856 Y173.22 E.02
G1 X174.254 Y173.199 E.02174
G1 X173.673 Y173.154 E.02104
G1 X173.076 Y173.08 E.02171
G1 X172.331 Y172.948 E.02733
G1 X171.637 Y172.785 E.02573
G1 X171.058 Y172.619 E.02173
G1 X170.532 Y172.442 E.02003
G1 X169.882 Y172.189 E.02519
G1 X169.336 Y171.946 E.0216
G1 X168.717 Y171.632 E.02502
G1 X168.07 Y171.259 E.02699
G1 X167.568 Y170.934 E.02159
G1 X167.004 Y170.528 E.0251
G1 X166.569 Y170.184 E.02001
G1 X166.051 Y169.732 E.02482
G1 X165.549 Y169.245 E.02524
G1 X165.062 Y168.719 E.02589
G1 X164.676 Y168.259 E.02168
G1 X164.257 Y167.705 E.02507
G1 X163.944 Y167.249 E.01998
G1 X163.592 Y166.681 E.02411
G1 X163.248 Y166.055 E.02579
G1 X162.982 Y165.509 E.02193
G1 X162.724 Y164.906 E.02369
G1 X162.517 Y164.353 E.02134
G1 X162.306 Y163.694 E.02497
G1 X162.137 Y163.054 E.0239
G1 X161.997 Y162.386 E.02465
G1 X161.901 Y161.786 E.02195
M73 P56 R4
G1 X161.835 Y161.203 E.02117
G1 X161.791 Y160.545 E.0238
G1 X161.78 Y159.855 E.02493
G1 X161.806 Y159.169 E.02479
G1 X161.858 Y158.566 E.02185
G1 X161.955 Y157.852 E.026
G1 X162.079 Y157.205 E.0238
G1 X162.251 Y156.502 E.02614
G1 X162.442 Y155.868 E.02389
G1 X162.638 Y155.315 E.02118
G1 X162.861 Y154.762 E.02154
G1 X163.14 Y154.16 E.02395
G1 X163.413 Y153.635 E.02138
G1 X163.712 Y153.118 E.02156
G1 X164.071 Y152.561 E.02394
G1 X164.39 Y152.113 E.01983
G1 X164.838 Y151.544 E.02616
G1 X165.201 Y151.129 E.01991
M204 S6000
G1 X165.545 Y151.429 F60000
G1 F3000
M204 S500
G1 X165.604 Y151.362 E.00322
G1 X166.078 Y150.873 E.02459
G1 X166.559 Y150.426 E.02372
G1 X167 Y150.056 E.02078
G1 X167.56 Y149.629 E.02542
G1 X168.004 Y149.325 E.01942
G1 X168.553 Y148.985 E.02332
G1 X169.124 Y148.67 E.02357
G1 X169.726 Y148.377 E.02415
G1 X170.257 Y148.151 E.02083
G1 X170.888 Y147.917 E.02432
G1 X171.431 Y147.746 E.02055
G1 X172.048 Y147.583 E.02305
G1 X172.692 Y147.447 E.02375
G1 X173.355 Y147.343 E.02422
G1 X173.928 Y147.282 E.0208
G1 X174.631 Y147.242 E.02543
G1 X175.181 Y147.238 E.01986
G1 X175.814 Y147.263 E.02287
G1 X176.465 Y147.321 E.02359
G1 X177.127 Y147.415 E.02416
G1 X177.693 Y147.524 E.02082
G1 X178.388 Y147.695 E.02585
G1 X178.996 Y147.879 E.02293
G1 X179.623 Y148.104 E.02406
G1 X180.641 Y148.552 E.04014
G1 X181.136 Y148.809 E.02014
G1 X181.699 Y149.136 E.0235
G1 X182.247 Y149.494 E.02363
G1 X182.721 Y149.837 E.02114
G1 X183.168 Y150.193 E.02064
G1 X183.648 Y150.613 E.02302
G1 X184.126 Y151.078 E.02409
G1 X184.573 Y151.558 E.02367
G1 X184.944 Y152 E.02083
G1 X185.37 Y152.56 E.02541
G1 X185.675 Y153.004 E.01943
G1 X186.014 Y153.551 E.02326
G1 X186.33 Y154.123 E.02359
G1 X186.639 Y154.763 E.02564
G1 X187.049 Y155.79 E.03994
G1 X187.254 Y156.431 E.02428
G1 X187.419 Y157.054 E.02328
G1 X187.558 Y157.724 E.02471
G1 X187.649 Y158.297 E.02096
G1 X187.71 Y158.835 E.01952
G1 X187.752 Y159.476 E.02323
G1 X187.762 Y160.175 E.02524
G1 X187.741 Y160.759 E.02107
G1 X187.684 Y161.422 E.02405
G1 X187.614 Y161.944 E.01901
G1 X187.5 Y162.578 E.02325
G1 X187.348 Y163.229 E.02416
G1 X187.025 Y164.277 E.03958
G1 X186.767 Y164.943 E.02578
G1 X186.508 Y165.519 E.02281
G1 X186.207 Y166.108 E.0239
G1 X185.918 Y166.61 E.02092
G1 X185.607 Y167.098 E.02088
G1 X185.239 Y167.621 E.02309
G1 X184.827 Y168.144 E.02405
G1 X184.388 Y168.647 E.02409
G1 X183.923 Y169.126 E.0241
G1 X183.419 Y169.592 E.0248
G1 X182.972 Y169.967 E.02106
G1 X182.436 Y170.374 E.02429
G1 X182.003 Y170.67 E.01893
G1 X181.333 Y171.08 E.02839
G1 X180.447 Y171.542 E.03604
G1 X179.83 Y171.814 E.02437
G1 X179.292 Y172.02 E.02081
G1 X178.655 Y172.229 E.02417
G1 X178.017 Y172.401 E.02387
G1 X177.387 Y172.538 E.02327
G1 X176.73 Y172.645 E.02404
G1 X176.197 Y172.707 E.01939
G1 X175.397 Y172.757 E.02893
G1 X174.286 Y172.743 E.04011
G1 X173.716 Y172.698 E.02064
G1 X173.14 Y172.627 E.02094
G1 X172.427 Y172.501 E.02617
G1 X171.756 Y172.344 E.02488
G1 X170.685 Y172.011 E.04047
G1 X170.061 Y171.769 E.02417
G1 X169.535 Y171.534 E.02079
G1 X168.932 Y171.228 E.02442
G1 X168.312 Y170.87 E.02586
G1 X167.823 Y170.554 E.02102
G1 X167.282 Y170.165 E.02407
G1 X166.859 Y169.83 E.01947
G1 X166.364 Y169.397 E.02374
G1 X165.874 Y168.922 E.02464
G1 X165.407 Y168.419 E.02478
G1 X165.036 Y167.976 E.02086
G1 X164.63 Y167.44 E.02428
G1 X164.325 Y166.996 E.01944
G1 X163.985 Y166.448 E.02332
G1 X163.656 Y165.848 E.02469
G1 X163.397 Y165.316 E.02137
G1 X163.15 Y164.739 E.02266
G1 X162.948 Y164.2 E.02079
G1 X162.744 Y163.563 E.02415
G1 X162.581 Y162.945 E.02306
G1 X162.447 Y162.306 E.02358
G1 X162.354 Y161.727 E.02118
G1 X162.29 Y161.159 E.02065
G1 X162.247 Y160.523 E.023
G1 X162.238 Y159.856 E.02407
G1 X162.262 Y159.2 E.02371
G1 X162.313 Y158.613 E.02128
G1 X162.406 Y157.93 E.0249
G1 X162.525 Y157.306 E.02293
G1 X162.691 Y156.626 E.02528
G1 X162.875 Y156.014 E.02307
G1 X163.066 Y155.474 E.02066
G1 X163.28 Y154.947 E.02054
G1 X163.549 Y154.364 E.02317
G1 X163.815 Y153.852 E.02085
G1 X164.104 Y153.354 E.0208
G1 X164.452 Y152.815 E.02316
G1 X164.758 Y152.384 E.01907
G1 X165.192 Y151.833 E.02533
G1 X165.506 Y151.475 E.0172
M204 S6000
G1 X165.85 Y151.776 F60000
G1 F3000
M204 S500
G1 X165.943 Y151.669 E.00509
G1 X166.4 Y151.198 E.02373
G1 X166.86 Y150.771 E.02264
G1 X167.283 Y150.415 E.01997
G1 X167.825 Y150.002 E.0246
G1 X168.256 Y149.707 E.01887
G1 X168.781 Y149.381 E.02229
G1 X169.332 Y149.077 E.02272
G1 X169.912 Y148.795 E.02332
G1 X170.423 Y148.577 E.02003
G1 X171.033 Y148.351 E.02351
G1 X171.562 Y148.184 E.02001
G1 X172.157 Y148.027 E.02225
G1 X172.771 Y147.898 E.02265
G1 X173.411 Y147.797 E.02339
G1 X173.961 Y147.738 E.01998
G1 X174.642 Y147.699 E.02461
G1 X175.177 Y147.696 E.01931
G1 X175.781 Y147.719 E.02183
G1 X176.408 Y147.775 E.02274
G1 X177.048 Y147.866 E.02333
G1 X177.592 Y147.97 E.01999
G1 X178.271 Y148.137 E.02525
G1 X178.856 Y148.314 E.02206
G1 X179.458 Y148.531 E.02312
G1 X180.439 Y148.962 E.03869
G1 X180.913 Y149.208 E.01926
G1 X181.456 Y149.523 E.02267
G1 X181.985 Y149.868 E.0228
G1 X182.442 Y150.199 E.02037
G1 X182.877 Y150.546 E.02011
G1 X183.34 Y150.952 E.02222
G1 X183.802 Y151.4 E.02323
G1 X184.228 Y151.859 E.0226
G1 X184.585 Y152.283 E.02001
G1 X184.998 Y152.825 E.0246
G1 X185.29 Y153.251 E.01865
G1 X185.618 Y153.779 E.02247
G1 X185.922 Y154.33 E.0227
G1 X186.222 Y154.951 E.02492
G1 X186.616 Y155.94 E.03844
G1 X186.814 Y156.555 E.02332
G1 X186.974 Y157.163 E.02268
G1 X187.108 Y157.803 E.02363
G1 X187.255 Y158.878 E.03918
G1 X187.296 Y159.498 E.02243
G1 X187.304 Y160.174 E.02439
G1 X187.284 Y160.734 E.02025
G1 X187.23 Y161.369 E.02301
G1 X187.162 Y161.876 E.01848
G1 X187.052 Y162.488 E.02245
G1 X186.905 Y163.114 E.02321
G1 X186.594 Y164.122 E.03808
G1 X186.344 Y164.77 E.02507
G1 X186.095 Y165.324 E.02194
G1 X185.806 Y165.887 E.02284
G1 X185.528 Y166.371 E.02014
G1 X185.226 Y166.846 E.02035
G1 X184.87 Y167.35 E.02228
G1 X184.472 Y167.855 E.0232
G1 X184.049 Y168.34 E.02322
G1 X183.601 Y168.801 E.02323
G1 X183.119 Y169.247 E.0237
G1 X182.69 Y169.608 E.02024
G1 X182.171 Y170.001 E.02349
G1 X181.751 Y170.288 E.01837
G1 X181.103 Y170.685 E.02743
G1 X180.254 Y171.127 E.03459
G1 X179.659 Y171.39 E.02348
G1 X179.142 Y171.588 E.01999
G1 X178.528 Y171.789 E.02333
G1 X177.913 Y171.956 E.02301
G1 X177.299 Y172.089 E.02268
G1 X176.67 Y172.192 E.02299
G1 X176.152 Y172.252 E.01882
G1 X175.391 Y172.299 E.02756
G1 X174.311 Y172.286 E.03898
G1 X173.205 Y172.174 E.04014
G1 X172.522 Y172.054 E.02502
G1 X171.88 Y171.903 E.02381
G1 X170.831 Y171.578 E.03965
G1 X170.24 Y171.348 E.02289
G1 X169.735 Y171.123 E.01997
G1 X169.146 Y170.824 E.02383
G1 X168.553 Y170.482 E.02473
G1 X168.078 Y170.174 E.02044
G1 X167.56 Y169.802 E.02304
G1 X167.149 Y169.476 E.01894
G1 X166.671 Y169.059 E.02292
G1 X166.198 Y168.6 E.02377
G1 X165.753 Y168.119 E.02368
G1 X165.396 Y167.694 E.02005
G1 X165.003 Y167.176 E.02348
G1 X164.707 Y166.744 E.01889
G1 X164.378 Y166.214 E.02252
G1 X164.063 Y165.641 E.02361
G1 X163.811 Y165.123 E.02081
G1 X163.573 Y164.566 E.02185
G1 X163.379 Y164.047 E.02001
G1 X163.182 Y163.431 E.02334
G1 X163.025 Y162.836 E.02222
G1 X162.897 Y162.226 E.02251
G1 X162.808 Y161.668 E.0204
G1 X162.745 Y161.114 E.02013
G1 X162.704 Y160.501 E.02219
G1 X162.695 Y159.858 E.02323
G1 X162.718 Y159.232 E.02262
G1 X162.768 Y158.66 E.02071
G1 X162.857 Y158.007 E.02381
G1 X162.971 Y157.406 E.02207
G1 X163.131 Y156.749 E.02442
G1 X163.309 Y156.159 E.02226
G1 X163.698 Y155.132 E.03967
G1 X163.962 Y154.56 E.02273
G1 X164.491 Y153.598 E.03966
G1 X165.12 Y152.664 E.04065
G1 X165.546 Y152.123 E.02487
G1 X165.81 Y151.821 E.01448
M204 S6000
G1 X166.154 Y152.121 F60000
G1 F3000
M204 S500
G1 X166.277 Y151.981 E.00673
G1 X166.658 Y151.585 E.01987
G1 X167.109 Y151.161 E.02232
G1 X167.576 Y150.765 E.02212
G1 X168.516 Y150.083 E.04194
G1 X169.031 Y149.764 E.02187
G1 X169.547 Y149.48 E.02128
G1 X170.067 Y149.227 E.02086
G1 X170.599 Y148.999 E.02093
G1 X171.698 Y148.621 E.04194
G1 X172.253 Y148.474 E.02074
G1 X172.79 Y148.359 E.0198
G1 X173.4 Y148.26 E.02233
G1 X174.009 Y148.193 E.02211
G1 X175.019 Y148.152 E.0365
G1 X175.668 Y148.17 E.02344
G1 X176.288 Y148.221 E.02247
G1 X176.904 Y148.305 E.02243
G1 X177.508 Y148.42 E.02221
G1 X178.114 Y148.568 E.02253
G1 X178.701 Y148.744 E.02213
G1 X179.639 Y149.098 E.03619
G1 X180.711 Y149.618 E.04303
G1 X181.198 Y149.901 E.02031
G1 X181.664 Y150.203 E.02007
G1 X182.587 Y150.899 E.04174
G1 X182.998 Y151.258 E.0197
G1 X183.415 Y151.659 E.02088
G1 X183.839 Y152.109 E.02231
G1 X184.234 Y152.575 E.02209
G1 X184.917 Y153.515 E.04194
G1 X185.221 Y154.006 E.02086
G1 X185.506 Y154.521 E.02125
G1 X185.764 Y155.046 E.02112
G1 X186 Y155.596 E.0216
G1 X186.377 Y156.689 E.04174
G1 X186.52 Y157.226 E.02006
G1 X186.64 Y157.786 E.02068
G1 X186.8 Y158.924 E.0415
G1 X186.838 Y159.493 E.02059
G1 X186.849 Y160.048 E.02003
G1 X186.788 Y161.195 E.04149
G1 X186.716 Y161.772 E.02098
G1 X186.613 Y162.354 E.02136
G1 X186.477 Y162.945 E.02189
G1 X186.319 Y163.505 E.02098
G1 X185.924 Y164.59 E.04169
G1 X185.692 Y165.108 E.0205
G1 X185.442 Y165.6 E.01993
G1 X184.844 Y166.595 E.04193
G1 X184.511 Y167.066 E.02082
G1 X184.147 Y167.532 E.02135
G1 X183.749 Y167.991 E.02192
G1 X183.346 Y168.411 E.02104
G1 X182.491 Y169.18 E.04152
G1 X182.055 Y169.52 E.01996
G1 X181.59 Y169.847 E.02052
G1 X180.601 Y170.441 E.04166
G1 X180.054 Y170.717 E.02213
G1 X179.482 Y170.969 E.02254
G1 X178.936 Y171.176 E.0211
G1 X178.358 Y171.363 E.02192
G1 X177.79 Y171.516 E.02123
G1 X177.216 Y171.64 E.02121
G1 X176.599 Y171.741 E.02259
G1 X175.99 Y171.807 E.02212
G1 X174.986 Y171.848 E.03628
G1 X173.803 Y171.788 E.04276
G1 X173.229 Y171.716 E.0209
G1 X172.646 Y171.613 E.02137
G1 X172.054 Y171.477 E.02194
G1 X171.495 Y171.319 E.02096
G1 X170.409 Y170.923 E.04174
G1 X169.853 Y170.673 E.02203
G1 X169.339 Y170.409 E.02085
G1 X168.828 Y170.115 E.02129
G1 X168.34 Y169.8 E.02096
G1 X167.418 Y169.105 E.0417
G1 X166.987 Y168.729 E.02063
G1 X166.585 Y168.342 E.02016
G1 X166.156 Y167.885 E.02264
G1 X165.764 Y167.423 E.02187
G1 X165.083 Y166.484 E.04187
G1 X164.779 Y165.994 E.02083
G1 X164.493 Y165.477 E.02134
G1 X164.236 Y164.952 E.02109
G1 X163.998 Y164.4 E.02172
G1 X163.622 Y163.307 E.04171
G1 X163.48 Y162.774 E.01992
G1 X163.36 Y162.215 E.02067
G1 X163.2 Y161.071 E.0417
G1 X163.161 Y160.495 E.02083
G1 X163.151 Y159.948 E.01976
G1 X163.17 Y159.33 E.02232
G1 X163.221 Y158.711 E.02246
G1 X163.304 Y158.099 E.02227
G1 X163.42 Y157.492 E.02234
G1 X163.567 Y156.888 E.02242
G1 X163.744 Y156.299 E.02221
G1 X164.099 Y155.361 E.03623
G1 X164.618 Y154.289 E.043
G1 X164.892 Y153.817 E.01969
G1 X165.204 Y153.334 E.02076
G1 X165.895 Y152.417 E.04146
G1 X166.114 Y152.167 E.01202
M204 S6000
G1 X166.458 Y152.467 F60000
G1 F3000
M204 S500
G1 X166.604 Y152.301 E.00797
G1 X166.99 Y151.9 E.0201
G1 X167.424 Y151.492 E.0215
G1 X167.875 Y151.111 E.0213
G1 X168.752 Y150.474 E.03917
G1 X169.249 Y150.166 E.02109
G1 X169.745 Y149.892 E.02047
G1 X170.244 Y149.648 E.02003
G1 X170.784 Y149.417 E.02123
G1 X171.811 Y149.064 E.0392
G1 X172.346 Y148.921 E.01999
G1 X172.889 Y148.805 E.02005
G1 X173.476 Y148.71 E.02149
G1 X174.063 Y148.647 E.0213
G1 X175.041 Y148.609 E.03535
G1 X175.658 Y148.627 E.02229
G1 X176.253 Y148.677 E.02157
G1 X176.845 Y148.758 E.02156
G1 X177.425 Y148.869 E.02135
G1 X178.008 Y149.012 E.02167
G1 X178.573 Y149.183 E.02131
G1 X179.482 Y149.528 E.03509
G1 X180.478 Y150.011 E.03996
G1 X180.947 Y150.283 E.01957
G1 X181.42 Y150.589 E.02037
G1 X182.283 Y151.24 E.03902
G1 X182.7 Y151.604 E.01999
G1 X183.101 Y151.99 E.02008
G1 X183.508 Y152.424 E.02148
G1 X183.888 Y152.874 E.02128
G1 X184.526 Y153.752 E.03919
G1 X184.82 Y154.225 E.0201
G1 X185.094 Y154.719 E.02041
G1 X185.355 Y155.251 E.02137
G1 X185.582 Y155.78 E.02081
G1 X185.934 Y156.802 E.039
G1 X186.079 Y157.347 E.02036
G1 X186.194 Y157.886 E.01992
G1 X186.344 Y158.95 E.0388
G1 X186.381 Y159.499 E.01984
G1 X186.392 Y160.061 E.02032
G1 X186.336 Y161.133 E.03876
G1 X186.262 Y161.718 E.02127
G1 X186.162 Y162.278 E.02053
G1 X186.031 Y162.846 E.02105
G1 X185.878 Y163.384 E.02022
G1 X185.509 Y164.399 E.03898
G1 X185.285 Y164.898 E.01975
G1 X185.032 Y165.398 E.02023
G1 X184.473 Y166.328 E.03917
G1 X184.136 Y166.806 E.02112
G1 X183.785 Y167.252 E.0205
G1 X183.402 Y167.693 E.02109
G1 X183.013 Y168.098 E.02026
G1 X182.214 Y168.817 E.03881
G1 X181.771 Y169.161 E.02026
G1 X181.323 Y169.476 E.01977
G1 X180.399 Y170.031 E.03892
M73 P57 R4
G1 X179.872 Y170.298 E.02132
G1 X179.322 Y170.54 E.02171
G1 X178.798 Y170.74 E.02027
G1 X178.242 Y170.921 E.02109
G1 X177.697 Y171.068 E.02039
G1 X177.116 Y171.194 E.02146
G1 X176.522 Y171.29 E.02173
G1 X175.936 Y171.354 E.02129
G1 X174.962 Y171.391 E.03518
G1 X173.865 Y171.335 E.03968
G1 X173.311 Y171.266 E.02015
G1 X172.751 Y171.168 E.02052
G1 X172.181 Y171.038 E.02109
G1 X171.615 Y170.877 E.02127
G1 X170.601 Y170.508 E.03896
G1 X170.063 Y170.267 E.02126
G1 X169.569 Y170.014 E.02003
G1 X169.078 Y169.732 E.02045
G1 X168.583 Y169.413 E.02126
G1 X167.722 Y168.764 E.03896
G1 X167.307 Y168.402 E.01987
G1 X166.9 Y168.01 E.0204
G1 X166.487 Y167.57 E.02179
G1 X166.11 Y167.124 E.02106
G1 X165.474 Y166.248 E.03911
G1 X165.166 Y165.75 E.02113
G1 X164.891 Y165.253 E.0205
G1 X164.645 Y164.749 E.02027
G1 X164.416 Y164.215 E.02095
G1 X164.065 Y163.195 E.03897
G1 X163.921 Y162.654 E.02021
G1 X163.806 Y162.114 E.01991
G1 X163.656 Y161.045 E.03899
G1 X163.618 Y160.49 E.02008
G1 X163.608 Y159.936 E.01999
G1 X163.627 Y159.342 E.02149
G1 X163.677 Y158.746 E.02159
G1 X163.758 Y158.158 E.02141
G1 X163.869 Y157.574 E.02148
G1 X164.012 Y156.994 E.02155
G1 X164.183 Y156.427 E.02139
G1 X164.528 Y155.517 E.03514
G1 X165.011 Y154.523 E.03992
G1 X165.289 Y154.044 E.01999
G1 X165.59 Y153.579 E.02001
G1 X166.236 Y152.721 E.03875
G1 X166.419 Y152.512 E.01003
M204 S6000
G1 X166.764 Y152.812 F60000
G1 F3000
M204 S500
G1 X166.931 Y152.62 E.00918
G1 X167.321 Y152.214 E.02034
G1 X167.739 Y151.823 E.02065
G1 X168.173 Y151.458 E.02049
G1 X168.99 Y150.865 E.03646
G1 X169.467 Y150.568 E.0203
G1 X169.943 Y150.304 E.01965
G1 X170.447 Y150.057 E.02026
G1 X170.968 Y149.835 E.02044
G1 X171.923 Y149.507 E.03647
G1 X172.466 Y149.362 E.02029
G1 X172.987 Y149.252 E.01922
G1 X173.552 Y149.161 E.02066
G1 X174.116 Y149.101 E.02048
G1 X175.062 Y149.065 E.03419
G1 X175.647 Y149.084 E.02112
G1 X176.218 Y149.133 E.02067
G1 X176.785 Y149.211 E.0207
G1 X177.343 Y149.319 E.02049
G1 X177.902 Y149.457 E.02081
G1 X178.445 Y149.622 E.02049
G1 X179.325 Y149.957 E.034
G1 X180.244 Y150.404 E.03691
G1 X180.72 Y150.68 E.01987
G1 X181.176 Y150.976 E.0196
G1 X181.979 Y151.581 E.03632
G1 X182.402 Y151.951 E.0203
G1 X182.786 Y152.321 E.01924
G1 X183.176 Y152.739 E.02065
G1 X183.542 Y153.172 E.02048
G1 X184.135 Y153.99 E.03647
G1 X184.434 Y154.469 E.02039
G1 X184.696 Y154.944 E.01957
G1 X184.946 Y155.454 E.02053
G1 X185.163 Y155.964 E.02001
G1 X185.491 Y156.915 E.03632
G1 X185.631 Y157.439 E.01957
G1 X185.748 Y157.987 E.02022
G1 X185.887 Y158.977 E.0361
G1 X185.925 Y159.533 E.02015
G1 X185.935 Y160.074 E.01953
G1 X185.883 Y161.072 E.03608
G1 X185.812 Y161.635 E.02048
G1 X185.717 Y162.172 E.0197
G1 X185.592 Y162.717 E.02019
G1 X185.437 Y163.264 E.02051
G1 X185.093 Y164.208 E.03627
G1 X184.867 Y164.715 E.02004
G1 X184.623 Y165.195 E.01945
G1 X184.102 Y166.061 E.03648
G1 X183.778 Y166.521 E.02031
G1 X183.424 Y166.973 E.02075
G1 X183.055 Y167.395 E.02024
G1 X182.681 Y167.784 E.01948
G1 X181.937 Y168.453 E.03614
G1 X181.511 Y168.785 E.01948
G1 X181.057 Y169.105 E.02006
G1 X180.197 Y169.621 E.03622
G1 X179.69 Y169.878 E.02051
G1 X179.163 Y170.112 E.02084
G1 X178.631 Y170.315 E.02052
G1 X178.098 Y170.487 E.02023
G1 X177.575 Y170.628 E.01956
G1 X177.017 Y170.748 E.02062
G1 X176.446 Y170.839 E.02086
G1 X175.883 Y170.9 E.02048
G1 X174.939 Y170.935 E.03408
G1 X173.926 Y170.882 E.03663
G1 X173.364 Y170.812 E.02046
G1 X172.827 Y170.717 E.01967
G1 X172.28 Y170.592 E.02026
G1 X171.735 Y170.436 E.02048
G1 X170.792 Y170.093 E.03624
G1 X170.275 Y169.862 E.02046
G1 X169.774 Y169.606 E.02028
G1 X169.304 Y169.335 E.01961
G1 X168.828 Y169.027 E.02048
G1 X168.026 Y168.422 E.03625
G1 X167.605 Y168.055 E.02017
G1 X167.214 Y167.679 E.01957
G1 X166.818 Y167.255 E.02094
G1 X166.457 Y166.826 E.02025
G1 X165.865 Y166.01 E.0364
G1 X165.567 Y165.532 E.02034
G1 X165.303 Y165.055 E.01967
G1 X165.054 Y164.545 E.02051
G1 X164.835 Y164.031 E.02015
G1 X164.508 Y163.081 E.03628
G1 X164.369 Y162.561 E.01944
G1 X164.252 Y162.014 E.0202
G1 X164.112 Y161.018 E.03631
G1 X164.075 Y160.485 E.0193
G1 X164.065 Y159.924 E.02024
G1 X164.084 Y159.353 E.02064
G1 X164.133 Y158.781 E.02072
G1 X164.211 Y158.218 E.02055
G1 X164.319 Y157.657 E.02063
G1 X164.456 Y157.101 E.02068
G1 X164.622 Y156.555 E.02058
G1 X164.957 Y155.674 E.03404
G1 X165.404 Y154.756 E.03688
G1 X165.671 Y154.295 E.01921
G1 X165.977 Y153.823 E.02032
G1 X166.578 Y153.025 E.03607
G1 X166.724 Y152.857 E.00804
M204 S6000
G1 X167.069 Y153.157 F60000
G1 F3000
M204 S500
G1 X167.278 Y152.917 E.01148
G1 X167.652 Y152.529 E.01948
G1 X168.053 Y152.155 E.0198
G1 X168.47 Y151.805 E.01967
G1 X169.228 Y151.255 E.03379
G1 X169.686 Y150.969 E.01949
G1 X170.168 Y150.702 E.0199
G1 X170.651 Y150.467 E.0194
G1 X171.151 Y150.254 E.01964
G1 X172.037 Y149.949 E.0338
G1 X172.558 Y149.81 E.01949
G1 X173.085 Y149.698 E.01947
G1 X173.627 Y149.612 E.01981
G1 X174.169 Y149.555 E.01966
G1 X175.083 Y149.522 E.03303
G1 X175.635 Y149.541 E.01994
G1 X176.181 Y149.588 E.0198
G1 X176.725 Y149.665 E.01983
G1 X177.259 Y149.768 E.01963
G1 X177.795 Y149.901 E.01994
G1 X178.316 Y150.06 E.01967
G1 X179.167 Y150.386 E.03289
G1 X180.011 Y150.798 E.03392
G1 X180.469 Y151.062 E.01907
G1 X180.931 Y151.362 E.0199
G1 X181.675 Y151.923 E.03365
G1 X182.082 Y152.278 E.0195
G1 X182.471 Y152.652 E.01948
G1 X182.845 Y153.053 E.01979
G1 X183.195 Y153.47 E.01967
G1 X183.745 Y154.228 E.0338
G1 X184.032 Y154.688 E.01958
G1 X184.298 Y155.168 E.01982
G1 X184.536 Y155.658 E.01966
G1 X184.744 Y156.147 E.01921
G1 X185.048 Y157.028 E.03365
G1 X185.19 Y157.56 E.01987
G1 X185.302 Y158.086 E.01941
G1 X185.431 Y159.004 E.03346
G1 X185.468 Y159.538 E.01934
G1 X185.478 Y160.087 E.01982
G1 X185.43 Y161.012 E.03343
G1 X185.363 Y161.552 E.01966
G1 X185.267 Y162.096 E.01995
G1 X185.146 Y162.618 E.01933
G1 X184.996 Y163.142 E.0197
G1 X184.678 Y164.018 E.03363
G1 X184.461 Y164.504 E.01923
G1 X184.213 Y164.992 E.01976
G1 X183.731 Y165.794 E.0338
G1 X183.42 Y166.237 E.01951
G1 X183.081 Y166.67 E.01988
G1 X182.729 Y167.076 E.01938
G1 X182.348 Y167.47 E.01978
G1 X181.659 Y168.09 E.03347
G1 X181.227 Y168.427 E.01978
G1 X180.791 Y168.733 E.01925
G1 X179.994 Y169.212 E.03357
G1 X179.508 Y169.459 E.01969
G1 X179.002 Y169.684 E.01997
G1 X178.493 Y169.879 E.01968
G1 X177.983 Y170.045 E.01937
G1 X177.453 Y170.187 E.01982
G1 X176.918 Y170.301 E.01975
G1 X176.371 Y170.388 E.01999
G1 X175.83 Y170.446 E.01966
G1 X174.917 Y170.478 E.03298
G1 X173.987 Y170.429 E.03363
G1 X173.447 Y170.363 E.01966
G1 X172.904 Y170.267 E.01991
G1 X172.38 Y170.146 E.01941
G1 X171.856 Y169.996 E.01968
G1 X170.982 Y169.678 E.03357
G1 X170.485 Y169.456 E.01965
G1 X170.006 Y169.212 E.01943
G1 X169.529 Y168.937 E.01985
G1 X169.072 Y168.641 E.01967
G1 X168.329 Y168.081 E.0336
G1 X167.924 Y167.729 E.01936
G1 X167.529 Y167.348 E.01982
G1 X167.15 Y166.941 E.02007
G1 X166.804 Y166.529 E.01944
G1 X166.255 Y165.772 E.03374
G1 X165.969 Y165.314 E.01952
G1 X165.702 Y164.831 E.01992
G1 X165.463 Y164.342 E.01965
G1 X165.254 Y163.849 E.01934
G1 X164.951 Y162.968 E.03363
G1 X164.81 Y162.44 E.01974
G1 X164.698 Y161.915 E.01939
G1 X164.569 Y160.991 E.03366
G1 X164.531 Y160.45 E.01959
G1 X164.522 Y159.913 E.01938
G1 X164.541 Y159.366 E.01978
G1 X164.588 Y158.818 E.01986
G1 X164.664 Y158.278 E.01969
G1 X164.768 Y157.74 E.01976
G1 X164.901 Y157.207 E.01982
G1 X165.06 Y156.684 E.01976
G1 X165.386 Y155.832 E.03293
G1 X165.798 Y154.989 E.03388
G1 X166.068 Y154.521 E.01951
G1 X166.362 Y154.068 E.01951
G1 X166.92 Y153.329 E.03342
G1 X167.03 Y153.203 E.00604
; WIPE_START
G1 X167.278 Y152.917 E-.14364
G1 X167.652 Y152.529 E-.20497
G1 X168.053 Y152.155 E-.20837
G1 X168.462 Y151.812 E-.20301
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X176.03 Y152.802 Z.6 F60000
G1 X182.308 Y153.624 Z.6
G1 Z.2
G1 E.8 F1800
; FEATURE: Outer wall
G1 F3000
M204 S500
G1 X182.592 Y153.961 E.01593
G3 X175.089 Y150.301 I-7.59 J6.039 E1.88889
G1 X175.424 Y150.309 E.0121
G3 X182.266 Y153.573 I-.422 J9.691 E.28121
G1 X182.27 Y153.577 E.0002
M204 S6000
G1 X181.958 Y153.917 F60000
; FEATURE: Inner wall
G1 F3000
M204 S500
G1 X182.234 Y154.245 E.0155
G3 X175.085 Y150.758 I-7.233 J5.754 E1.79987
G1 X175.404 Y150.766 E.01153
G3 X181.92 Y153.871 I-.402 J9.234 E.26772
; WIPE_START
G1 X182.234 Y154.245 E-.18593
M73 P58 R4
G1 X182.522 Y154.629 E-.18241
G1 X182.963 Y155.308 E-.30749
G1 X183.071 Y155.502 E-.08418
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X181.998 Y163.058 Z.6 F60000
G1 X181.783 Y164.576 Z.6
G1 Z.2
G1 E.8 F1800
; FEATURE: Outer wall
G1 F3000
M204 S500
G3 X175.363 Y167.915 I-6.58 J-4.807 E.27071
G3 X167.107 Y159.378 I-.334 J-7.939 E.48434
G3 X174.971 Y151.681 I8.121 J.431 E.43636
G1 X175.238 Y151.676 E.00965
G3 X180.129 Y153.252 I.114 J8.024 E.18889
G3 X183.333 Y159.215 I-4.742 J6.39 E.25245
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

G3 X181.818 Y164.527 I-8.13 J.553 E.20348
M204 S6000
G1 X182.138 Y164.86 F60000
; FEATURE: Inner wall
G1 F3000
M204 S500
G1 X181.632 Y165.489 E.02915
G3 X175.371 Y168.372 I-6.429 J-5.721 E.25605
G3 X166.651 Y159.343 I-.341 J-8.397 E.51178
G3 X174.955 Y151.224 I8.577 J.466 E.46047
G1 X175.238 Y151.218 E.01021
G3 X180.406 Y152.888 I.114 J8.481 E.19964
G3 X183.789 Y159.187 I-5.019 J6.754 E.26663
G3 X182.175 Y164.813 I-8.587 J.581 E.21563
M204 S6000
G1 X182.635 Y164.663 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.157111
G1 F3000
M204 S500
G2 X183.285 Y163.432 I-7.732 J-4.866 E.01257
; LINE_WIDTH: 0.119032
G2 X183.652 Y162.42 I-8.483 J-3.654 E.00647
; WIPE_START
G1 X183.459 Y163 E-.43162
G1 X183.285 Y163.432 E-.32838
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X182.635 Y164.663 Z.6 F60000
G1 Z.2
G1 E.8 F1800
; LINE_WIDTH: 0.20066
G1 F3000
M204 S500
G3 X181.886 Y165.681 I-8.045 J-5.137 E.01576
G1 X181.786 Y165.795 E.00188
; LINE_WIDTH: 0.246883
G3 X180.658 Y166.87 I-6.559 J-5.752 E.02515
; LINE_WIDTH: 0.294407
G3 X179.507 Y167.649 I-5.504 J-6.892 E.02763
G1 X179.367 Y167.728 E.00319
; LINE_WIDTH: 0.34031
G3 X178.288 Y168.225 I-4.53 J-8.416 E.02793
G1 X178.096 Y168.295 E.0048
; LINE_WIDTH: 0.386116
G3 X176.604 Y168.684 I-2.98 J-8.371 E.04186
; LINE_WIDTH: 0.451961
G1 X176.463 Y168.706 E.00461
G3 X166.339 Y158.337 I-1.416 J-8.744 E.54831
; LINE_WIDTH: 0.408673
G3 X166.639 Y157.133 I9.023 J1.612 E.0359
G1 X166.725 Y156.881 E.00768
; LINE_WIDTH: 0.359839
G3 X167.398 Y155.434 I8.544 J3.091 E.04
; LINE_WIDTH: 0.310385
G3 X168.339 Y154.107 I7.998 J4.679 E.03442
; LINE_WIDTH: 0.265162
G3 X169.211 Y153.224 I7.043 J6.078 E.02181
G1 X169.245 Y153.194 E.00079
; LINE_WIDTH: 0.21949
G3 X170.597 Y152.22 I5.981 J6.885 E.02327
; LINE_WIDTH: 0.171947
G3 X171.861 Y151.607 I4.584 J7.833 E.01433
; LINE_WIDTH: 0.125589
G3 X173.059 Y151.232 I3.463 J8.964 E.00821
G1 X173.403 Y151.158 E.00229
; CHANGE_LAYER
; Z_HEIGHT: 0.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F3000
G1 X173.059 Y151.232 E-.16602
G1 X172.456 Y151.399 E-.29579
G1 X171.861 Y151.607 E-.29819
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 2/19
; update layer progress
M73 L2
M991 S0 P1 ;notify layer change

; open powerlost recovery
M1003 S1
; OBJECT_ID: 15
M204 S10000
G17
G3 Z.6 I-1.213 J-.094 P1  F60000
G1 X170.657 Y167.072 Z.6
G1 Z.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1849
M204 S8000
G1 X170.339 Y166.852 E.01243
G3 X167.416 Y162.925 I4.944 J-6.729 E.15976
G3 X170.004 Y153.599 I7.648 J-2.9 E.33302
G3 X174.788 Y151.834 I5.297 J6.992 E.16636
G3 X183.36 Y158.206 I.447 J8.352 E.37255
G3 X183.153 Y162.974 I-7.864 J2.046 E.15575
G3 X178.461 Y167.845 I-7.673 J-2.696 E.22429
G3 X170.98 Y167.279 I-3.179 J-7.722 E.25021
G1 X170.707 Y167.104 E.01041
M204 S250
G1 X170.872 Y166.746 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1849
M204 S5000
G3 X167.849 Y162.968 I4.415 J-6.633 E.14644
G3 X167.537 Y158.002 I7.305 J-2.952 E.1508
G1 X167.599 Y157.776 E.00697
G1 X167.722 Y157.401 E.01176
M73 P59 R4
G1 X167.851 Y157.065 E.01075
G1 X167.923 Y156.897 E.00543
G1 X168.018 Y156.687 E.00686
G1 X168.179 Y156.367 E.01068
G1 X168.355 Y156.055 E.01067
G1 X168.449 Y155.9 E.00539
G1 X168.574 Y155.708 E.00682
G1 X168.781 Y155.412 E.01075
G1 X169.025 Y155.099 E.01183
G1 X169.259 Y154.827 E.01067
G1 X169.382 Y154.694 E.0054
G1 X169.549 Y154.522 E.00714
G1 X169.831 Y154.255 E.01158
G1 X170.103 Y154.022 E.01066
G1 X170.245 Y153.909 E.0054
G1 X170.442 Y153.76 E.00736
G1 F1680
G1 X170.739 Y153.553 E.01076
G1 F1560
G1 X171.06 Y153.352 E.01129
G1 F1440
G1 X171.373 Y153.176 E.0107
G1 F1200
G1 X171.693 Y153.016 E.01066
G1 F1080
G1 X171.858 Y152.94 E.0054
G1 F960
G1 X172.097 Y152.838 E.00775
G1 F840
G1 X172.44 Y152.708 E.01092
G1 F720
G1 X172.612 Y152.65 E.00541
G1 F600
G1 X172.866 Y152.573 E.00792
G1 X173.216 Y152.481 E.01077
G1 X173.736 Y152.366 E.01587
G3 X174.811 Y152.226 I1.661 J8.55 E.03229
G3 X175.445 Y152.213 I.466 J7.83 E.0189
G1 X175.628 Y152.22 E.00546
G3 X178.793 Y153.046 I-.396 J7.99 E.09814
G1 X178.96 Y153.132 E.00557
G1 X179.28 Y153.312 E.01096
G1 X179.595 Y153.508 E.01104
G1 X179.899 Y153.718 E.01101
G1 F720
G3 X180.229 Y153.972 I-4.59 J6.328 E.0124
G1 F840
G1 X180.41 Y154.122 E.00699
G1 F960
G1 X180.551 Y154.246 E.00561
G1 F1080
G1 X180.821 Y154.501 E.01107
G1 F1200
G1 X181.08 Y154.769 E.01108
G1 F1320
G1 X181.206 Y154.909 E.00562
G1 F1440
G1 X181.361 Y155.091 E.00713
G1 F1560
G1 X181.504 Y155.268 E.00677
G1 F1680
G1 X181.618 Y155.418 E.00563
G1 F1800
G1 X181.835 Y155.724 E.01114
G1 F1849
G1 X182.037 Y156.039 E.01118
G3 X182.256 Y156.421 I-6.819 J4.15 E.01311
G1 X182.357 Y156.616 E.00655
G1 X182.44 Y156.787 E.00566
G1 X182.593 Y157.131 E.0112
G1 X182.698 Y157.395 E.00845
G1 X182.763 Y157.575 E.00571
G1 X182.88 Y157.934 E.01124
G1 X182.98 Y158.3 E.01131
G1 X183.023 Y158.495 E.00593
G1 X183.129 Y159.048 E.01677
G1 X183.177 Y159.426 E.01135
G1 X183.2 Y159.825 E.01191
G1 X183.229 Y160.189 E.01088
G3 X182.671 Y163.132 I-7.673 J.071 E.08981
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

G3 X178.665 Y167.33 I-7.135 J-2.8 E.17726
G3 X170.922 Y166.779 I-3.377 J-7.217 E.24148
; WIPE_START
G1 F9547.055
M204 S8000
G1 X170.275 Y166.319 E-.30194
G1 X169.658 Y165.768 E-.31419
G1 X169.402 Y165.489 E-.14387
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.014 Y160.316 Z.8 F60000
G1 X181.845 Y154.019 Z.8
G1 Z.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1849
M204 S8000
M73 P59 R3
G1 X182.113 Y154.341 E.01348
G3 X182.489 Y154.849 I-7.117 J5.664 E.02034
G1 X182.296 Y154.989 E.00766
G2 X173.029 Y151.704 I-7.041 J5.147 E.33591
G2 X167.032 Y163.058 I1.985 J8.309 E.46721
G2 X174.452 Y168.832 I8.234 J-2.926 E.31925
G1 X174.431 Y169.073 E.00776
G3 X175.396 Y150.918 I.571 J-9.073 E.9127
G3 X181.805 Y153.974 I-.401 J9.087 E.23454
M204 S10000
G1 X182.157 Y153.758 F60000
G1 F1849
M204 S8000
G1 X182.434 Y154.086 E.01382
G3 X175.096 Y150.503 I-7.431 J5.914 E1.64741
G1 X175.414 Y150.511 E.01023
G3 X182.116 Y153.707 I-.411 J9.488 E.2453
G1 X182.119 Y153.711 E.00016
M204 S250
M73 P60 R3
G1 X182.457 Y153.506 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1849
M204 S5000
G1 X182.741 Y153.841 E.01311
G3 X175.1 Y150.111 I-7.738 J6.158 E1.589
G1 X175.431 Y150.119 E.00987
G3 X182.409 Y153.446 I-.428 J9.88 E.23656
G1 X182.42 Y153.459 E.0005
; WIPE_START
G1 F9547.055
M204 S8000
G1 X182.741 Y153.841 E-.18998
G1 X183.051 Y154.256 E-.19659
G1 X183.521 Y154.98 E-.32812
G1 X183.578 Y155.085 E-.04531
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X182.513 Y155.083 Z.8 F60000
G1 Z.4
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.655503
G1 F1849
M204 S8000
G3 X183.374 Y156.7 I-7.85 J5.216 E.08878
; LINE_WIDTH: 0.605818
G1 X183.412 Y156.793 E.00445
G3 X183.821 Y158.098 I-8.477 J3.375 E.06086
; LINE_WIDTH: 0.560323
G3 X184.038 Y159.609 I-8.72 J2.023 E.06248
; LINE_WIDTH: 0.513801
G1 X184.047 Y159.764 E.00579
G3 X183.999 Y161.131 I-9.04 J.37 E.0509
; LINE_WIDTH: 0.4622
G3 X180.461 Y167.239 I-8.814 J-1.028 E.24044
; LINE_WIDTH: 0.516612
G3 X179.318 Y167.95 I-5.262 J-7.183 E.05042
; LINE_WIDTH: 0.561614
G1 X179.013 Y168.103 E.01397
G3 X177.838 Y168.564 I-4.059 J-8.607 E.05174
; LINE_WIDTH: 0.607537
G3 X176.478 Y168.878 I-2.76 J-8.85 E.06234
; LINE_WIDTH: 0.654511
G1 X176.17 Y168.92 E.015
G3 X174.961 Y168.978 I-1.067 J-9.668 E.05852
G1 X174.673 Y168.652 E.02101
; WIPE_START
G1 F5886.29
G1 X174.961 Y168.978 E-.16892
G1 X175.705 Y168.961 E-.2893
G1 X176.17 Y168.92 E-.18117
G1 X176.478 Y168.878 E-.12061
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X169.342 Y166.169 Z.8 F60000
G1 X168.271 Y165.762 Z.8
G1 Z.4
G1 E.8 F1800
; LINE_WIDTH: 0.107557
G1 F1849
M204 S8000
G1 X167.883 Y165.259 E.00325
; LINE_WIDTH: 0.13888
G3 X167.167 Y164.072 I7.25 J-5.181 E.01051
; LINE_WIDTH: 0.198298
G1 X167.104 Y163.942 E.00177
G3 X173.523 Y151.311 I7.94 J-3.912 E.20163
; LINE_WIDTH: 0.165694
G3 X174.747 Y151.17 I1.634 J8.845 E.01195
G1 X175.09 Y151.163 E.00333
; LINE_WIDTH: 0.118518
G3 X176.509 Y151.269 I.06 J8.76 E.00851
; CHANGE_LAYER
; Z_HEIGHT: 0.6
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F15000
G1 X175.694 Y151.18 E-.43757
G1 X175.09 Y151.163 E-.32243
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 3/19
; update layer progress
M73 L3
M991 S0 P2 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z.8 I-1.201 J-.198 P1  F60000
G1 X172.273 Y168.238 Z.8
G1 Z.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1847
M204 S8000
G1 X171.446 Y167.913 E.02858
G3 X168.858 Y166.001 I3.433 J-7.353 E.10415
G3 X169.597 Y153.912 I6.129 J-5.693 E.4355
G3 X174.557 Y151.892 I5.506 J6.423 E.17521
G3 X181.743 Y155.475 I.432 J8.13 E.27002
G3 X179.271 Y167.408 I-6.861 J4.801 E.43882
G3 X174.673 Y168.672 I-4.363 J-6.876 E.15564
G3 X172.327 Y168.263 I.206 J-8.113 E.07686
; COOLING_NODE: 0
M204 S250
G1 X172.413 Y167.878 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
M73 P61 R3
G1 F1846
M204 S5000
G3 X169.148 Y165.736 I2.466 J-7.318 E.11761
G3 X169.845 Y154.215 I5.84 J-5.428 E.38441
G3 X174.041 Y152.337 I5.258 J6.121 E.13884
G1 X174.578 Y152.284 E.01607
G1 X174.621 Y152.283 E.00128
G1 X174.97 Y152.272 E.01043
G1 X175.332 Y152.279 E.01077
G1 X175.692 Y152.303 E.01075
G1 X175.922 Y152.327 E.00689
G1 X176.102 Y152.351 E.0054
G1 X176.455 Y152.41 E.01066
G1 X176.805 Y152.486 E.01067
G1 X176.981 Y152.53 E.0054
G1 X177.202 Y152.593 E.00685
G1 X177.581 Y152.716 E.01186
G1 X177.916 Y152.844 E.0107
G1 X178.245 Y152.986 E.01067
G1 X178.408 Y153.064 E.0054
G1 X178.622 Y153.174 E.00716
G1 X178.96 Y153.364 E.01155
G1 X179.265 Y153.556 E.01072
G1 X179.558 Y153.76 E.01066
G1 F1800
G1 X179.704 Y153.869 E.0054
G1 F1680
G1 X179.9 Y154.024 E.00746
G1 F1440
G1 X180.186 Y154.271 E.01125
G1 F1320
G1 X180.446 Y154.517 E.01067
G1 F1200
G1 X180.573 Y154.646 E.0054
G1 F1080
G1 X180.749 Y154.836 E.00769
G1 F960
G1 X180.984 Y155.11 E.01076
G1 F840
G1 X181.21 Y155.4 E.01095
G1 F600
G1 X181.417 Y155.694 E.0107
G1 X181.609 Y155.996 E.01066
G1 X181.835 Y156.378 E.01322
G3 X182.85 Y159.646 I-6.834 J3.913 E.10274
G1 X182.862 Y159.83 E.00551
G3 X182.82 Y161.204 I-11.446 J.336 E.04098
G1 X182.796 Y161.389 E.00556
G3 X182.658 Y162.113 I-7.822 J-1.114 E.02194
G1 X182.613 Y162.293 E.00554
G1 X182.552 Y162.51 E.00671
G1 X182.482 Y162.737 E.00708
G1 F720
G1 X182.421 Y162.915 E.00559
G1 F840
G1 X182.29 Y163.261 E.01102
G1 F960
G1 X182.142 Y163.602 E.01107
G1 F1080
G1 X182.02 Y163.854 E.00833
G1 F1200
G1 X181.933 Y164.021 E.00561
G1 F1320
G1 X181.75 Y164.345 E.01111
G1 F1560
G1 X181.551 Y164.662 E.01114
G1 F1680
G1 X181.337 Y164.97 E.01117
G1 F1800
G1 X181.109 Y165.268 E.01119
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

G1 F1846
G1 X180.866 Y165.555 E.0112
G1 X180.61 Y165.832 E.01124
G1 X180.341 Y166.096 E.0112
G1 X180.201 Y166.224 E.00566
G1 X180.007 Y166.392 E.00764
G1 X179.84 Y166.529 E.00643
G1 X179.69 Y166.646 E.00569
G1 X179.383 Y166.867 E.01128
G1 X179.065 Y167.075 E.01131
G1 X178.919 Y167.161 E.00506
G1 X178.4 Y167.446 E.01763
G1 X178.054 Y167.608 E.01136
G1 X177.681 Y167.752 E.01191
G1 X177.343 Y167.889 E.01087
G3 X174.686 Y168.28 I-2.437 J-7.338 E.08042
G3 X172.47 Y167.897 I.193 J-7.72 E.06722
; COOLING_NODE: 0
; WIPE_START
G1 F9547.055
M204 S8000
G1 X171.606 Y167.559 E-.35265
G1 X171.3 Y167.414 E-.12833
G1 X170.918 Y167.194 E-.16779
G1 X170.676 Y167.03 E-.11124
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.651 Y161.242 Z1 F60000
G1 X181.85 Y154.032 Z1
G1 Z.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1847
M204 S8000
G1 X182.11 Y154.344 E.01306
G3 X182.191 Y165.559 I-7.119 J5.659 E.38864
G1 X181.998 Y165.419 E.00767
G2 X182.29 Y155.577 I-7.043 J-5.134 E.33644
G2 X169.641 Y153.358 I-7.298 J4.439 E.46733
G2 X166.439 Y162.239 I5.315 J6.934 E.32071
G1 X166.204 Y162.296 E.00779
G3 X175.4 Y150.918 I8.803 J-2.29 E.54656
G3 X181.698 Y153.861 I-.409 J9.085 E.22936
G1 X181.81 Y153.987 E.00544
; COOLING_NODE: 0
M204 S10000
G1 X182.152 Y153.765 F60000
G1 F1847
M204 S8000
G1 X182.638 Y154.347 E.02437
G3 X175.105 Y150.503 I-7.631 J5.65 E1.63657
G1 X175.417 Y150.511 E.01002
G3 X182.005 Y153.58 I-.41 J9.486 E.23982
G1 X182.115 Y153.718 E.00569
; COOLING_NODE: 1
M204 S250
M73 P62 R3
G1 X182.46 Y153.51 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1846
M204 S5000
G1 X182.538 Y153.592 E.00337
G3 X175.109 Y150.111 I-7.532 J6.405 E1.59841
G1 X175.432 Y150.119 E.00962
G3 X182.294 Y153.316 I-.426 J9.878 E.23137
G1 X182.421 Y153.464 E.00584
; WIPE_START
G1 F9547.055
M204 S8000
G1 X182.538 Y153.592 E-.06575
G1 X182.95 Y154.117 E-.25339
G1 X183.151 Y154.399 E-.13161
G1 X183.522 Y154.981 E-.26219
G1 X183.58 Y155.09 E-.04706
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X182.768 Y155.839 Z1 F60000
G1 Z.6
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.168849
G1 F1847
M204 S8000
G3 X183.384 Y157.212 I-7.793 J4.326 E.01499
; LINE_WIDTH: 0.120617
G3 X183.717 Y158.439 I-8.878 J3.063 E.00781
G1 X183.774 Y158.766 E.00204
; WIPE_START
G1 F15000
G1 X183.717 Y158.439 E-.15755
G1 X183.604 Y157.939 E-.24257
G1 X183.384 Y157.212 E-.35989
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X182.768 Y155.839 Z1 F60000
G1 Z.6
G1 E.8 F1800
; LINE_WIDTH: 0.198284
G1 F1847
M204 S8000
G2 X168.999 Y153.534 I-7.778 J4.182 E.19758
G2 X168.708 Y153.809 I4.71 J5.288 E.00492
; LINE_WIDTH: 0.136682
G1 X168.483 Y154.036 E.00237
G2 X167.707 Y154.982 I6.55 J6.167 E.00907
; LINE_WIDTH: 0.104702
G1 X167.643 Y155.075 E.00055
G2 X167.42 Y155.412 I10.613 J7.247 E.00198
; WIPE_START
G1 F15000
G1 X167.643 Y155.075 E-.59496
G1 X167.707 Y154.982 E-.16504
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X166.367 Y162.466 Z1 F60000
G1 Z.6
G1 E.8 F1800
; LINE_WIDTH: 0.660964
G1 F1847
M204 S8000
G2 X166.838 Y163.779 I9.316 J-2.6 E.06819
; LINE_WIDTH: 0.620256
G2 X167.483 Y164.978 I8.347 J-3.723 E.06215
G1 X167.491 Y164.989 E.00061
; LINE_WIDTH: 0.573968
G2 X168.518 Y166.304 I7.63 J-4.904 E.0701
; LINE_WIDTH: 0.523789
G2 X169.721 Y167.37 I6.72 J-6.37 E.06113
; LINE_WIDTH: 0.461713
G2 X176.372 Y168.971 I5.237 J-7.141 E.23235
G1 X176.481 Y168.952 E.00365
; LINE_WIDTH: 0.508017
G2 X177.999 Y168.539 I-1.609 J-8.916 E.05787
; LINE_WIDTH: 0.555879
G2 X179.15 Y168.021 I-3.401 J-9.096 E.05119
G1 X179.425 Y167.866 E.01279
; LINE_WIDTH: 0.601412
G2 X180.212 Y167.351 I-4.834 J-8.251 E.04148
G1 X180.609 Y167.043 E.02217
; LINE_WIDTH: 0.652937
G2 X181.975 Y165.654 I-6.116 J-7.377 E.09406
; CHANGE_LAYER
; Z_HEIGHT: 0.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F5901.481
G1 X181.304 Y166.408 E-.39317
G1 X180.96 Y166.74 E-.186
G1 X180.609 Y167.043 E-.18084
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 4/19
; update layer progress
M73 L4
M991 S0 P3 ;notify layer change

M106 S226.95
; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z1 I.536 J-1.093 P1  F60000
G1 X166.323 Y160.034 Z1
G1 Z.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1854
M204 S8000
G1 X166.355 Y159.245 E.02538
G3 X174.399 Y151.715 I8.405 J.918 E.3859
G3 X179.294 Y153.093 I.313 J8.276 E.1662
G3 X182.767 Y162.366 I-4.35 J6.917 E.34209
G3 X179.327 Y166.96 I-8.352 J-2.669 E.18802
M73 P63 R3
G3 X167.302 Y163.947 I-4.627 J-7.04 E.448
G3 X166.315 Y160.092 I7.214 J-3.899 E.12926
; COOLING_NODE: 0
M204 S250
G1 X166.707 Y160.049 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1845
M204 S5000
G3 X166.745 Y159.279 I7.763 J.003 E.02298
G3 X174.414 Y152.107 I8.015 J.884 E.34057
G3 X179.075 Y153.418 I.299 J7.88 E.14662
G3 X181.933 Y156.599 I-4.264 J6.706 E.12895
G1 X182.034 Y156.816 E.00714
G1 X182.194 Y157.183 E.01191
G1 X182.247 Y157.316 E.00426
G1 X182.374 Y157.688 E.01172
G1 X182.474 Y158.035 E.01076
G1 X182.529 Y158.261 E.00692
M106 S229.5
G1 X182.568 Y158.438 E.0054
M106 S226.95
M106 S229.5
G1 X182.632 Y158.789 E.01063
M106 S226.95
M106 S229.5
G1 X182.659 Y158.968 E.00541
M106 S226.95
M106 S229.5
G1 X182.685 Y159.191 E.00669
M106 S226.95
M106 S229.5
G1 X182.706 Y159.414 E.00667
M106 S226.95
M106 S229.5
G1 X182.717 Y159.595 E.00539
M106 S226.95
M106 S229.5
G1 X182.728 Y159.952 E.01064
M106 S226.95
M106 S229.5
G3 X182.719 Y160.367 I-7.778 J.047 E.01236
M106 S226.95
M106 S229.5
G1 X182.69 Y160.758 E.0117
M106 S226.95
M106 S229.5
G1 X182.67 Y160.939 E.00541
M106 S226.95
M106 S229.5
G1 X182.638 Y161.176 E.00712
M106 S226.95
M106 S229.5
G1 X182.575 Y161.531 E.01075
M106 S226.95
M106 S229.5
G1 X182.488 Y161.909 E.01154
M106 S226.95
M106 S229.5
G1 X182.392 Y162.254 E.01068
M106 S226.95
M106 S229.5
G1 F1800
G1 X182.337 Y162.427 E.00539
M106 S226.95
M106 S229.5
G1 F1680
G1 X182.255 Y162.662 E.00743
M106 S226.95
M106 S229.5
G1 F1560
G1 X182.116 Y163.014 E.01128
M106 S226.95
M106 S229.5
G1 F1440
G1 X181.968 Y163.341 E.01069
M106 S226.95
M106 S229.5
G1 F1320
G1 X181.854 Y163.57 E.00762
M106 S226.95
M106 S229.5
G1 F1200
G1 X181.767 Y163.731 E.00544
M106 S226.95
M106 S229.5
G1 F1080
G1 X181.581 Y164.051 E.01103
M106 S226.95
M106 S229.5
G1 F840
G1 X181.385 Y164.353 E.0107
M106 S226.95
M106 S229.5
G1 F720
G1 X181.176 Y164.645 E.0107
M106 S226.95
M106 S229.5
G1 F600
G3 X180.838 Y165.064 I-6.181 J-4.649 E.01604
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

M106 S226.95
M106 S229.5
G1 X180.544 Y165.396 E.01321
M106 S226.95
M106 S229.5
G1 X180.297 Y165.656 E.01069
M106 S226.95
M106 S229.5
G1 X180.103 Y165.845 E.00807
M106 S226.95
M106 S229.5
G3 X178.79 Y166.837 I-5.56 J-5.993 E.04909
M106 S226.95
M106 S229.5
G3 X178.405 Y167.054 I-4.01 J-6.664 E.01318
M106 S226.95
M106 S229.5
G3 X177.489 Y167.464 I-4.141 J-8.025 E.0299
M106 S226.95
M106 S229.5
G1 X177.315 Y167.526 E.0055
M106 S226.95
M106 S229.5
G3 X175.521 Y167.921 I-2.655 J-7.788 E.05482
M106 S226.95
M106 S229.5
G1 X175.152 Y167.95 E.01103
M106 S226.95
M106 S229.5
G1 X174.782 Y167.961 E.01102
M106 S226.95
M106 S229.5
G1 X174.595 Y167.96 E.00557
M106 S226.95
M106 S229.5
G1 F720
G1 X174.367 Y167.953 E.00681
M106 S226.95
M106 S229.5
G1 F840
G1 X174.132 Y167.939 E.007
M106 S226.95
M106 S229.5
G1 F960
G1 X173.945 Y167.923 E.00559
M106 S226.95
M106 S229.5
G1 F1080
G1 X173.576 Y167.878 E.01107
M106 S226.95
M106 S229.5
G1 F1200
G1 X173.209 Y167.816 E.01111
M106 S226.95
M106 S229.5
G1 F1320
G1 X172.844 Y167.737 E.01111
M106 S226.95
M106 S229.5
G1 F1560
G3 X172.428 Y167.624 I1.856 J-7.676 E.01283
M106 S226.95
M106 S229.5
G1 F1680
G1 X172.213 Y167.557 E.00673
M106 S226.95
M106 S229.5
G1 F1800
G1 X172.034 Y167.495 E.00563
M106 S226.95
M106 S229.5
G1 F1845
G1 X171.684 Y167.361 E.01116
M106 S226.95
M106 S229.5
G1 X171.34 Y167.211 E.01118
M106 S226.95
M106 S229.5
G1 X171.169 Y167.128 E.00566
M106 S226.95
M106 S229.5
G1 X170.944 Y167.013 E.00753
M106 S226.95
M106 S229.5
G1 X170.753 Y166.907 E.00651
M106 S226.95
M106 S229.5
G1 X170.589 Y166.811 E.00567
M106 S226.95
M106 S229.5
G1 X170.269 Y166.61 E.01125
M106 S226.95
M106 S229.5
G1 X169.959 Y166.392 E.01129
M106 S226.95
G1 X169.659 Y166.161 E.0113
G1 X169.408 Y165.947 E.00981
G1 X169.12 Y165.669 E.01191
G1 X168.825 Y165.383 E.01227
G1 X168.516 Y165.032 E.0139
G1 X168.273 Y164.721 E.01176
G3 X167.839 Y164.089 I6.747 J-5.105 E.02285
G3 X166.707 Y160.109 I6.631 J-4.037 E.12476
; COOLING_NODE: 0
; WIPE_START
G1 F9547.055
M204 S8000
G1 X166.745 Y159.279 E-.31584
G1 X166.838 Y158.603 E-.2594
G1 X166.958 Y158.132 E-.18476
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X174.317 Y156.105 Z1.2 F60000
G1 X181.853 Y154.029 Z1.2
G1 Z.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1854
M204 S8000
G1 X182.114 Y154.34 E.01306
G3 X171.965 Y168.568 I-7.113 J5.659 E.75511
G1 X172.041 Y168.34 E.00771
G2 X181.573 Y165.432 I2.665 J-8.34 E.34089
G2 X179.52 Y152.754 I-6.622 J-5.433 E.46691
G2 X170.19 Y152.57 I-4.81 J7.247 E.31674
G1 X170.066 Y152.364 E.00775
G3 X175.4 Y150.918 I4.952 J7.71 E.18053
G3 X181.812 Y153.979 I-.4 J9.081 E.23471
G1 X181.814 Y153.983 E.00014
; COOLING_NODE: 0
M204 S10000
G1 X182.163 Y153.777 F60000
M73 P64 R3
G1 F1854
M204 S8000
G1 X182.437 Y154.083 E.01321
G3 X175.114 Y150.503 I-7.429 J5.915 E1.64775
G1 X175.416 Y150.511 E.00972
G3 X181.891 Y153.456 I-.408 J9.487 E.23445
G1 X182.124 Y153.731 E.0116
; COOLING_NODE: 1
M204 S250
G1 X182.459 Y153.52 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1845
M204 S5000
G1 X182.744 Y153.84 E.01276
G3 X175.118 Y150.111 I-7.736 J6.159 E1.5893
G1 X175.432 Y150.119 E.00936
G3 X182.176 Y153.188 I-.425 J9.879 E.22622
G1 X182.42 Y153.474 E.0112
; WIPE_START
G1 F9547.055
M204 S8000
G1 X182.744 Y153.84 E-.18556
G1 X183.151 Y154.398 E-.26256
G1 X183.433 Y154.833 E-.19675
G1 X183.582 Y155.096 E-.11512
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X178.767 Y152.013 Z1.2 F60000
G1 Z.8
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.19784
G1 F1854
M204 S8000
G1 X179.097 Y152.184 E.00454
G3 X181.339 Y166.122 I-4.142 J7.816 E.20004
; LINE_WIDTH: 0.166007
G3 X180.374 Y167.011 I-6.743 J-6.353 E.01277
G1 X180.112 Y167.209 E.00319
; LINE_WIDTH: 0.118597
G3 X179.071 Y167.866 I-5.158 J-7.027 E.00736
G1 X178.928 Y167.941 E.00097
; WIPE_START
G1 F15000
G1 X179.071 Y167.866 E-.08849
G1 X179.619 Y167.545 E-.3464
G1 X180.112 Y167.209 E-.3251
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.555 Y168.283 Z1.2 F60000
G1 X171.81 Y168.389 Z1.2
G1 Z.8
G1 E.8 F1800
; LINE_WIDTH: 0.65784
G1 F1854
M204 S8000
G3 X170.317 Y167.684 I3.187 J-8.684 E.08032
; LINE_WIDTH: 0.611488
G3 X169.118 Y166.839 I4.495 J-7.658 E.06597
; LINE_WIDTH: 0.566447
G3 X168.21 Y165.968 I6.199 J-7.371 E.05205
G1 X168.064 Y165.803 E.00911
; LINE_WIDTH: 0.520035
G3 X167.142 Y164.525 I7.018 J-6.033 E.05948
; LINE_WIDTH: 0.46154
G3 X166.136 Y158.039 I7.647 J-4.508 E.22232
G1 X166.216 Y157.729 E.01059
; LINE_WIDTH: 0.505946
G3 X166.701 Y156.387 I9.019 J2.5 E.05222
; LINE_WIDTH: 0.551768
G3 X167.338 Y155.219 I8.679 J3.978 E.05356
G1 X167.475 Y155.013 E.00991
; LINE_WIDTH: 0.599754
G3 X168.436 Y153.835 I7.518 J5.157 E.06696
G1 X168.466 Y153.805 E.00184
; LINE_WIDTH: 0.648697
G3 X169.66 Y152.781 I6.372 J6.219 E.07541
G3 X169.715 Y152.759 I.038 J.015 E.0032
; LINE_WIDTH: 0.629321
G1 X170.119 Y152.847 E.01914
; WIPE_START
G1 F6139.144
M73 P65 R3
G1 X169.715 Y152.759 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X177.029 Y151.375 Z1.2 F60000
G1 Z.8
G1 E.8 F1800
; LINE_WIDTH: 0.101165
G1 F1854
M204 S8000
G3 X177.326 Y151.456 I-3.082 J11.965 E.00142
; LINE_WIDTH: 0.130479
G3 X178.767 Y152.013 I-2.608 J8.884 E.0107
; CHANGE_LAYER
; Z_HEIGHT: 1
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F15000
G1 X178.121 Y151.727 E-.3473
G1 X177.326 Y151.456 E-.4127
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 5/19
; update layer progress
M73 L5
M991 S0 P4 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z1.2 I-.259 J-1.189 P1  F60000
G1 X169.726 Y153.109 Z1.2
G1 Z1
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1840
M204 S8000
G1 X170.288 Y152.714 E.02208
G3 X174.186 Y151.379 I4.558 J6.953 E.13388
G3 X176.58 Y151.565 I.456 J9.675 E.07744
G3 X182.838 Y162.146 I-1.741 J8.17 E.44422
G3 X176.298 Y168.015 I-7.854 J-2.174 E.29842
G3 X175.414 Y168.109 I-1.589 J-10.661 E.02859
G3 X169.325 Y165.937 I-.327 J-8.703 E.21296
G3 X169.093 Y153.665 I5.673 J-6.246 E.44196
G3 X169.683 Y153.15 I5.753 J6.002 E.02521
; COOLING_NODE: 0
M204 S250
G1 X169.956 Y153.434 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1840
M204 S5000
G3 X174.21 Y151.771 I4.89 J6.233 E.13802
G3 X176.496 Y151.948 I.435 J9.235 E.06846
G3 X182.561 Y161.686 I-1.657 J7.791 E.38154
G3 X180.252 Y165.661 I-7.803 J-1.875 E.13889
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

G1 X179.886 Y165.984 E.01453
G1 X179.681 Y166.148 E.00782
G1 X179.49 Y166.289 E.00707
G1 X179.342 Y166.393 E.00539
G1 X179.041 Y166.587 E.01067
M106 S229.5
G1 X178.732 Y166.767 E.01066
M106 S226.95
M106 S229.5
G1 X178.572 Y166.853 E.0054
M106 S226.95
M106 S229.5
G1 X178.373 Y166.953 E.00665
M106 S226.95
M106 S229.5
G1 X178.169 Y167.048 E.00671
M106 S226.95
M106 S229.5
G1 X178.002 Y167.121 E.00541
M106 S226.95
M106 S229.5
G1 X177.669 Y167.252 E.01066
M106 S226.95
M106 S229.5
G1 X177.33 Y167.368 E.01067
M106 S226.95
M106 S229.5
G1 X177.157 Y167.421 E.00539
M106 S226.95
M106 S229.5
G1 X176.931 Y167.483 E.00699
M106 S226.95
M106 S229.5
G1 X176.548 Y167.571 E.01172
M106 S226.95
M106 S229.5
G1 X176.194 Y167.635 E.01069
M106 S226.95
M106 S229.5
G1 X175.956 Y167.668 E.00718
M106 S226.95
M106 S229.5
G1 X175.774 Y167.689 E.00543
M106 S226.95
M106 S229.5
G1 X175.391 Y167.718 E.01144
M106 S226.95
M106 S229.5
G1 X175.21 Y167.725 E.00541
M106 S226.95
M106 S229.5
G1 F1800
G1 X174.962 Y167.728 E.00738
M106 S226.95
M106 S229.5
G1 F1680
G1 X174.601 Y167.717 E.01076
M106 S226.95
M106 S229.5
G1 F1560
G1 X174.224 Y167.689 E.01127
M106 S226.95
M106 S229.5
G1 F1320
G3 X173.689 Y167.616 I.779 J-7.702 E.01607
M106 S226.95
M106 S229.5
G1 F1200
G1 X173.436 Y167.568 E.00769
M106 S226.95
M106 S229.5
G1 F960
G1 X173.084 Y167.487 E.01075
M106 S226.95
M106 S229.5
G1 F840
G1 X172.736 Y167.389 E.01078
M106 S226.95
M106 S229.5
G1 F600
G1 X172.388 Y167.273 E.0109
M106 S226.95
M106 S229.5
G1 X172.054 Y167.144 E.01068
M106 S226.95
M106 S229.5
G3 X170.688 Y166.466 I4.543 J-10.872 E.04545
M106 S226.95
M106 S229.5
G1 X170.467 Y166.325 E.00782
M106 S226.95
M106 S229.5
G3 X169.586 Y165.644 I4.863 J-7.202 E.03319
M106 S226.95
M106 S229.5
G1 X169.397 Y165.469 E.00767
M106 S226.95
M106 S229.5
G3 X168.317 Y164.192 I5.719 J-5.928 E.04989
M106 S226.95
M106 S229.5
G1 X168.181 Y163.984 E.00739
M106 S226.95
M106 S229.5
G3 X167.568 Y162.806 I7.258 J-4.523 E.0396
M106 S226.95
M106 S229.5
G1 X167.479 Y162.583 E.00715
M106 S226.95
M106 S229.5
G1 X167.414 Y162.408 E.00557
M106 S226.95
M106 S229.5
G1 X167.298 Y162.057 E.01102
M106 S226.95
M106 S229.5
G1 F720
G1 X167.199 Y161.7 E.01103
M106 S226.95
M106 S229.5
G1 F960
G1 X167.155 Y161.517 E.0056
M106 S226.95
M106 S229.5
G1 F1080
G1 X167.097 Y161.244 E.0083
M106 S226.95
M106 S229.5
G1 F1200
G1 X167.035 Y160.877 E.0111
M106 S226.95
M106 S229.5
G1 F1320
G1 X166.99 Y160.506 E.01114
M106 S226.95
M106 S229.5
G1 F1440
G1 X166.962 Y160.134 E.01111
M106 S226.95
M106 S229.5
G1 F1560
G1 X166.955 Y159.945 E.00561
M106 S226.95
M106 S229.5
G1 F1680
G1 X166.952 Y159.702 E.00726
M106 S226.95
M106 S229.5
G1 F1800
G1 X166.956 Y159.477 E.00669
M106 S226.95
M106 S229.5
G1 F1840
G1 X166.964 Y159.288 E.00564
M106 S226.95
M106 S229.5
G1 X166.993 Y158.914 E.01119
M106 S226.95
M106 S229.5
G1 X167.039 Y158.54 E.01121
M106 S226.95
M106 S229.5
G1 X167.103 Y158.17 E.0112
M106 S226.95
M106 S229.5
G1 X167.142 Y157.983 E.00568
M106 S226.95
M106 S229.5
G1 X167.202 Y157.732 E.00768
M106 S226.95
M106 S229.5
G1 X167.311 Y157.343 E.01203
M106 S226.95
M106 S229.5
G1 X167.431 Y156.983 E.0113
M106 S226.95
G1 X167.568 Y156.63 E.0113
G1 X167.606 Y156.541 E.00285
G1 X167.779 Y156.181 E.01191
G1 X167.937 Y155.855 E.01078
G1 X168.144 Y155.513 E.01191
G1 X168.339 Y155.206 E.01084
G3 X169.37 Y153.943 I7.226 J4.841 E.04864
G3 X169.909 Y153.472 I5.476 J5.725 E.02133
; COOLING_NODE: 0
; WIPE_START
G1 F9547.055
M204 S8000
G1 X170.502 Y153.041 E-.27837
G1 X171.084 Y152.698 E-.25686
G1 X171.603 Y152.442 E-.21993
G1 X171.615 Y152.437 E-.00483
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X179.155 Y153.623 Z1.4 F60000
G1 X181.865 Y154.05 Z1.4
G1 Z1
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1840
M204 S8000
G1 X182.039 Y154.249 E.00849
G3 X165.913 Y159.737 I-7.041 J5.748 E1.12663
G1 X166.153 Y159.738 E.00774
G2 X171.75 Y167.884 I8.711 J.01 E.33793
G2 X183.227 Y162.265 I3.246 J-7.902 E.46421
G2 X180.585 Y153.135 I-8.362 J-2.527 E.32316
G1 X180.742 Y152.951 E.00777
M73 P66 R3
G1 X180.899 Y153.083 E.0066
G3 X181.618 Y153.768 I-5.901 J6.913 E.03192
G1 X181.826 Y154.005 E.01015
; COOLING_NODE: 0
M204 S10000
G1 X182.163 Y153.781 F60000
G1 F1840
M204 S8000
G1 X182.541 Y154.212 E.01843
G3 X175.123 Y150.503 I-7.53 J5.787 E1.64291
G1 X175.416 Y150.511 E.00944
G3 X181.92 Y153.484 I-.406 J9.489 E.23576
G1 X182.125 Y153.735 E.01041
; COOLING_NODE: 1
M204 S250
G1 X182.462 Y153.527 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1840
M204 S5000
G1 X182.851 Y153.974 E.01767
G3 X175.127 Y150.111 I-7.842 J6.025 E1.58463
G1 X175.432 Y150.119 E.00908
G3 X182.206 Y153.217 I-.423 J9.88 E.22748
G1 X182.423 Y153.481 E.01019
; WIPE_START
G1 F9547.055
M204 S8000
G1 X182.851 Y153.974 E-.24821
G1 X183.052 Y154.257 E-.13171
G1 X183.433 Y154.833 E-.26245
G1 X183.583 Y155.104 E-.11764
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X180.506 Y152.914 Z1.4 F60000
G1 Z1
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.654279
G1 F1840
M204 S8000
G2 X179.015 Y151.943 I-5.676 J7.09 E.08608
; LINE_WIDTH: 0.605199
G2 X177.596 Y151.357 I-4.089 J7.884 E.06824
; LINE_WIDTH: 0.559468
G1 X177.489 Y151.323 E.00459
G2 X176.181 Y151.031 I-2.715 J9.071 E.05474
; LINE_WIDTH: 0.513294
G1 X175.84 Y150.987 E.01275
G2 X174.608 Y150.937 I-1.007 J9.724 E.04585
; LINE_WIDTH: 0.462425
G1 X174.581 Y150.938 E.00089
G2 X168.212 Y153.989 I.324 J8.85 E.24071
; LINE_WIDTH: 0.521936
G1 X167.879 Y154.402 E.0201
G2 X167.311 Y155.241 I7.368 J5.592 E.03836
; LINE_WIDTH: 0.570072
G1 X167.187 Y155.456 E.01033
G2 X166.609 Y156.694 I8.021 J4.493 E.05695
; LINE_WIDTH: 0.618385
G2 X166.195 Y158.169 I8.366 J3.149 E.06971
; LINE_WIDTH: 0.653333
G1 X166.15 Y158.416 E.0121
G2 X166.064 Y159.228 I5.67 J1.009 E.03944
G1 X166.353 Y159.535 E.0203
; WIPE_START
G1 F5897.647
G1 X166.064 Y159.228 E-.21478
G1 X166.092 Y158.83 E-.20391
M73 P67 R3
G1 X166.15 Y158.416 E-.21326
G1 X166.195 Y158.169 E-.12805
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X168.426 Y165.468 Z1.4 F60000
G1 X168.64 Y166.169 Z1.4
G1 Z1
G1 E.8 F1800
; LINE_WIDTH: 0.101786
G1 F1840
M204 S8000
G1 X168.898 Y166.417 E.00166
; LINE_WIDTH: 0.131105
G2 X169.87 Y167.194 I6.066 J-6.593 E.00867
G1 X170.093 Y167.342 E.00187
; LINE_WIDTH: 0.197732
G1 X170.391 Y167.526 E.00428
G2 X183.49 Y162.358 I4.582 J-7.571 E.19914
G1 X183.574 Y162.053 E.00386
; LINE_WIDTH: 0.163933
G2 X183.805 Y160.749 I-8.904 J-2.252 E.01267
; LINE_WIDTH: 0.120054
G2 X183.843 Y159.509 I-8.621 J-.884 E.00756
G1 X183.831 Y159.293 E.00132
; CHANGE_LAYER
; Z_HEIGHT: 1.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F15000
G1 X183.843 Y159.509 E-.11285
G1 X183.843 Y160.222 E-.37173
G1 X183.805 Y160.749 E-.27542
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 6/19
; update layer progress
M73 L6
M991 S0 P5 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z1.4 I1.186 J-.274 P1  F60000
G1 X182.711 Y156.02 Z1.4
G1 Z1.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1862
M204 S8000
G1 X182.952 Y156.584 E.01972
G3 X183.523 Y159.031 I-7.56 J3.052 E.08113
G3 X175.362 Y168.117 I-8.319 J.736 E.44045
G3 X166.899 Y159.45 I-.352 J-8.123 E.43952
G3 X174.77 Y151.488 I8.335 J.369 E.39464
G3 X180.184 Y153.04 I.541 J8.332 E.18474
G3 X182.676 Y155.973 I-4.791 J6.596 E.12493
; COOLING_NODE: 0
M204 S250
G1 X182.342 Y156.182 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1844
M204 S5000
G3 X183.132 Y159.065 I-6.949 J3.455 E.0896
G3 X175.715 Y167.713 I-7.934 J.7 E.37816
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

G3 X170.803 Y166.488 I-.619 J-7.974 E.15341
G1 X170.536 Y166.308 E.00959
G1 X170.248 Y166.094 E.01072
G1 X169.94 Y165.841 E.01184
M106 S229.5
G1 X169.673 Y165.598 E.01078
M106 S226.95
M106 S229.5
G1 X169.417 Y165.343 E.01074
M106 S226.95
M106 S229.5
G1 X169.263 Y165.177 E.00675
M106 S226.95
M106 S229.5
G1 X169.143 Y165.041 E.0054
M106 S226.95
M106 S229.5
G1 X168.916 Y164.765 E.01066
M106 S226.95
M106 S229.5
G1 X168.701 Y164.477 E.01071
M106 S226.95
M106 S229.5
G1 X168.5 Y164.179 E.0107
M106 S226.95
M106 S229.5
G1 X168.313 Y163.874 E.01066
M106 S226.95
M106 S229.5
G1 X168.224 Y163.716 E.00541
M106 S226.95
M106 S229.5
G1 X168.112 Y163.504 E.00713
M106 S226.95
M106 S229.5
G1 X167.945 Y163.153 E.01158
M106 S226.95
M106 S229.5
G3 X167.742 Y162.654 I7.062 J-3.155 E.01606
M106 S226.95
M106 S229.5
G1 X167.661 Y162.42 E.00737
M106 S226.95
M106 S229.5
G1 F1800
G1 X167.556 Y162.075 E.01075
M106 S226.95
M106 S229.5
G1 F1560
G1 X167.463 Y161.707 E.0113
M106 S226.95
M106 S229.5
G1 F1440
G1 X167.392 Y161.355 E.01069
M106 S226.95
M106 S229.5
G1 F1200
G3 X167.327 Y160.921 I7.635 J-1.359 E.01307
M106 S226.95
M106 S229.5
G1 F1080
G1 X167.293 Y160.562 E.01074
M106 S226.95
M106 S229.5
G1 F840
G1 X167.275 Y160.201 E.01078
M106 S226.95
M106 S229.5
G1 F720
G1 X167.274 Y159.835 E.01091
M106 S226.95
M106 S229.5
G1 F600
G1 X167.29 Y159.476 E.0107
M106 S226.95
M106 S229.5
G1 X167.338 Y158.944 E.0159
M106 S226.95
M106 S229.5
G3 X169.952 Y153.871 I7.903 J.863 E.17386
M106 S226.95
M106 S229.5
G1 X170.121 Y153.727 E.00663
M106 S226.95
M106 S229.5
G3 X170.455 Y153.462 I5.016 J5.999 E.01269
M106 S226.95
M106 S229.5
G1 X170.756 Y153.248 E.01102
M106 S226.95
M106 S229.5
G1 F840
G1 X171.068 Y153.047 E.01104
M106 S226.95
M106 S229.5
G1 F960
G1 X171.23 Y152.95 E.00561
M106 S226.95
M106 S229.5
G1 F1080
G1 X171.433 Y152.837 E.00695
M106 S226.95
M106 S229.5
G1 F1200
G3 X171.808 Y152.646 I3.762 J6.934 E.01252
M106 S226.95
M106 S229.5
G1 F1320
G1 X172.148 Y152.494 E.0111
M106 S226.95
M106 S229.5
G1 F1560
G1 X172.495 Y152.358 E.0111
M106 S226.95
M106 S229.5
G1 F1680
G1 X172.674 Y152.294 E.00565
M106 S226.95
M106 S229.5
G1 F1800
G1 X172.906 Y152.22 E.00726
M106 S226.95
M106 S229.5
G1 F1844
G3 X173.305 Y152.109 I2.324 J7.57 E.01234
M106 S226.95
M106 S229.5
G1 X173.67 Y152.026 E.01117
M106 S226.95
M106 S229.5
G1 X174.042 Y151.96 E.01123
M106 S226.95
M106 S229.5
G1 X174.415 Y151.911 E.01123
M106 S226.95
M106 S229.5
G1 X174.793 Y151.88 E.01129
M106 S226.95
M106 S229.5
G1 X175.194 Y151.866 E.01195
M106 S226.95
M106 S229.5
G1 X175.455 Y151.867 E.00776
M106 S226.95
G1 X175.647 Y151.874 E.00572
G1 X176.007 Y151.899 E.01076
G1 X176.402 Y151.944 E.01185
G1 X176.796 Y152.015 E.01191
G1 X177.059 Y152.063 E.00797
G1 X177.615 Y152.205 E.01709
G3 X179.951 Y153.356 I-2.272 J7.558 E.07793
G3 X182.315 Y156.128 I-4.559 J6.28 E.10953
; COOLING_NODE: 0
; WIPE_START
G1 F9547.055
M204 S8000
G1 X182.59 Y156.725 E-.24987
G1 X182.839 Y157.459 E-.29434
G1 X182.967 Y158.012 E-.21579
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X183.231 Y163.258 Z1.6 F60000
G1 Z1.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1862
M204 S8000
G1 X183.449 Y163.355 E.00767
G3 X172.411 Y151.288 I-8.448 J-3.354 E1.18247
G1 X172.484 Y151.514 E.00764
G2 X166.492 Y159.422 I2.73 J8.292 E.33933
G2 X175.369 Y168.525 I8.518 J.572 E.46118
M73 P68 R3
G2 X183.207 Y163.313 I-.142 J-8.714 E.31973
; COOLING_NODE: 0
; WIPE_START
G1 F8843.478
G1 X183.449 Y163.355 E-.09327
G1 X183.254 Y163.809 E-.18791
G1 X182.965 Y164.38 E-.24311
G1 X182.669 Y164.881 E-.221
G1 X182.647 Y164.913 E-.01471
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X182.322 Y157.287 Z1.6 F60000
G1 X182.173 Y153.788 Z1.6
G1 Z1.2
G1 E.8 F1800
G1 F1862
M204 S8000
G1 X182.431 Y154.086 E.01268
G3 X174.748 Y150.505 I-7.431 J5.914 E1.6363
G3 X175.416 Y150.511 I.247 J10.114 E.02148
G3 X181.889 Y153.462 I-.416 J9.488 E.23448
G1 X182.133 Y153.743 E.01197
; COOLING_NODE: 1
M204 S250
G1 X182.468 Y153.531 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1844
M204 S5000
G1 X182.739 Y153.843 E.01231
G3 X174.74 Y150.113 I-7.739 J6.156 E1.5783
G3 X175.432 Y150.119 I.255 J10.48 E.02061
G3 X182.173 Y153.192 I-.432 J9.88 E.2262
G1 X182.429 Y153.486 E.01159
; WIPE_START
G1 F9547.055
M204 S8000
G1 X182.739 Y153.843 E-.17983
G1 X183.08 Y154.297 E-.21576
G1 X183.34 Y154.685 E-.17739
G1 X183.586 Y155.111 E-.18702
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X183.546 Y156.969 Z1.6 F60000
G1 Z1.2
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.46296
G1 F1862
M204 S8000
M73 P69 R3
G1 X183.495 Y156.818 E.0053
G2 X178.615 Y151.685 I-8.332 J3.036 E.24173
; LINE_WIDTH: 0.521754
G2 X177.153 Y151.217 I-3.505 J8.432 E.05813
; LINE_WIDTH: 0.570192
G1 X176.927 Y151.168 E.00962
G2 X175.545 Y150.998 I-1.806 J8.979 E.05804
; LINE_WIDTH: 0.620248
G1 X175.468 Y150.995 E.00353
G2 X173.898 Y151.075 I-.323 J9.1 E.07178
; LINE_WIDTH: 0.663663
G2 X172.64 Y151.336 I1.455 J10.185 E.06304
; WIPE_START
G1 F5799.503
G1 X173.368 Y151.165 E-.4421
G1 X173.898 Y151.075 E-.3179
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X167.675 Y155.494 Z1.6 F60000
G1 X167.172 Y155.852 Z1.6
G1 Z1.2
G1 E.8 F1800
; LINE_WIDTH: 0.118864
G1 F1862
M204 S8000
G1 X167.106 Y155.981 E.00087
G2 X166.608 Y157.232 I7.795 J3.83 E.00808
; LINE_WIDTH: 0.163127
G2 X166.304 Y158.553 I8.806 J2.721 E.01288
; LINE_WIDTH: 0.197799
G2 X176.186 Y168.744 I8.733 J1.418 E.20155
G2 X176.603 Y168.684 I-1.943 J-15.015 E.00515
; LINE_WIDTH: 0.131854
G2 X178.096 Y168.295 I-1.545 J-8.986 E.01085
; LINE_WIDTH: 0.101169
G1 X178.447 Y168.163 E.00173
; WIPE_START
G1 F15000
G1 X178.096 Y168.295 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X183.712 Y163.237 Z1.6 F60000
G1 Z1.2
G1 E.8 F1800
; LINE_WIDTH: 0.651389
G1 F1862
M204 S8000
G1 X183.524 Y162.819 E.02203
G1 X183.686 Y162.304 E.02597
G2 X183.902 Y161.335 I-9.23 J-2.565 E.04774
; LINE_WIDTH: 0.604663
G1 X183.923 Y161.199 E.00612
G2 X184.022 Y159.764 I-9.096 J-1.347 E.06389
; LINE_WIDTH: 0.558725
G1 X184.016 Y159.506 E.01052
G2 X183.896 Y158.356 I-9.03 J.363 E.04712
; LINE_WIDTH: 0.515375
G1 X183.857 Y158.139 E.00824
G2 X183.546 Y156.969 I-8.814 J1.711 E.04521
; CHANGE_LAYER
; Z_HEIGHT: 1.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F7619.779
G1 X183.716 Y157.529 E-.3106
G1 X183.857 Y158.139 E-.33222
G1 X183.896 Y158.356 E-.11718
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 7/19
; update layer progress
M73 L7
M991 S0 P6 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z1.6 I-1.198 J-.216 P1  F60000
G1 X182.995 Y163.352 Z1.6
G1 Z1.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1838
M204 S8000
G1 X182.844 Y163.726 E.01298
G3 X178.456 Y167.847 I-7.382 J-3.465 E.19824
G3 X167.416 Y162.923 I-3.172 J-7.727 E.43463
G3 X169.913 Y153.671 I7.618 J-2.906 E.32937
G3 X174.984 Y151.825 I5.386 J6.906 E.17643
G3 X183.257 Y157.827 I.253 J8.353 E.35363
G3 X183.144 Y162.998 I-7.859 J2.415 E.16921
G1 X183.018 Y163.297 E.01041
; COOLING_NODE: 0
M204 S250
G1 X182.648 Y163.206 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
M73 P69 R2
G1 F1838
M204 S5000
G3 X178.66 Y167.332 I-7.183 J-2.952 E.17507
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

G3 X167.912 Y163.132 I-3.372 J-7.224 E.38432
G3 X167.542 Y157.979 I7.383 J-3.12 E.15668
G1 X167.559 Y157.913 E.00203
G1 X167.627 Y157.685 E.00708
G1 X167.742 Y157.346 E.01069
G1 X167.889 Y156.976 E.01185
M106 S229.5
G1 X168.038 Y156.647 E.01076
M106 S226.95
M106 S229.5
G1 X168.14 Y156.442 E.00682
M106 S226.95
M106 S229.5
G1 X168.225 Y156.283 E.00539
M106 S226.95
M106 S229.5
G1 X168.404 Y155.974 E.01063
M106 S226.95
M106 S229.5
G1 X168.5 Y155.82 E.0054
M106 S226.95
M106 S229.5
G1 X168.627 Y155.629 E.00685
M106 S226.95
M106 S229.5
G1 X168.861 Y155.306 E.01186
M106 S226.95
M106 S229.5
G1 X169.085 Y155.027 E.01068
M106 S226.95
M106 S229.5
G1 X169.204 Y154.889 E.0054
M106 S226.95
M106 S229.5
G1 X169.363 Y154.714 E.00707
M106 S226.95
M106 S229.5
G1 X169.616 Y154.456 E.01075
M106 S226.95
M106 S229.5
G1 X169.882 Y154.21 E.01078
M106 S226.95
M106 S229.5
G1 X170.158 Y153.977 E.01077
M106 S226.95
M106 S229.5
G1 X170.463 Y153.744 E.01144
M106 S226.95
M106 S229.5
G1 F1680
G1 X170.758 Y153.54 E.01068
M106 S226.95
M106 S229.5
G1 F1560
G3 X171.128 Y153.312 I4.255 J6.481 E.01293
M106 S226.95
M106 S229.5
G1 F1320
G1 X171.444 Y153.139 E.01075
M106 S226.95
M106 S229.5
G1 F1200
G1 X171.78 Y152.975 E.01113
M106 S226.95
M106 S229.5
G1 F960
G3 X172.278 Y152.768 I3.228 J7.046 E.01606
M106 S226.95
M106 S229.5
G1 F840
G1 X172.525 Y152.679 E.00784
M106 S226.95
M106 S229.5
G1 F600
G1 X172.874 Y152.57 E.01087
M106 S226.95
M106 S229.5
G1 X173.221 Y152.48 E.01068
M106 S226.95
M106 S229.5
G1 X173.741 Y152.365 E.01588
M106 S226.95
M106 S229.5
G3 X174.815 Y152.225 I1.656 J8.554 E.03226
M106 S226.95
M106 S229.5
G1 X174.997 Y152.217 E.00544
M106 S226.95
M106 S229.5
G3 X176.374 Y152.289 I.112 J10.94 E.0411
M106 S226.95
M106 S229.5
G1 X176.627 Y152.33 E.00764
M106 S226.95
M106 S229.5
G3 X177.186 Y152.449 I-1.346 J7.669 E.01701
M106 S226.95
M106 S229.5
G1 X177.429 Y152.514 E.00751
M106 S226.95
M106 S229.5
G3 X178.295 Y152.818 I-2.68 J9.034 E.02735
M106 S226.95
M106 S229.5
G1 X178.466 Y152.891 E.00553
M106 S226.95
M106 S229.5
G1 X178.662 Y152.982 E.00645
M106 S226.95
M106 S229.5
G3 X179.045 Y153.178 I-3.371 J7.057 E.0128
M106 S226.95
M106 S229.5
G1 X179.364 Y153.362 E.01098
M106 S226.95
M106 S229.5
G1 X179.675 Y153.562 E.01101
M106 S226.95
M106 S229.5
G3 X180.012 Y153.802 I-4.371 J6.483 E.01233
M106 S226.95
M106 S229.5
G1 F720
G1 X180.199 Y153.947 E.00703
M106 S226.95
M106 S229.5
G1 F840
G1 X180.344 Y154.066 E.00558
M106 S226.95
M106 S229.5
G1 F960
G1 X180.622 Y154.311 E.01105
M106 S226.95
M106 S229.5
G1 F1080
G1 X180.89 Y154.57 E.01111
M106 S226.95
M106 S229.5
G1 F1320
G1 X181.147 Y154.842 E.01113
M106 S226.95
M106 S229.5
G1 F1440
G1 X181.33 Y155.054 E.00836
M106 S226.95
M106 S229.5
G1 F1560
G1 X181.45 Y155.2 E.00561
M106 S226.95
M106 S229.5
G1 F1680
G1 X181.676 Y155.497 E.01113
M106 S226.95
M106 S229.5
G1 F1800
G1 X181.89 Y155.806 E.0112
M106 S226.95
M106 S229.5
G1 F1838
G1 X182.088 Y156.124 E.01116
M106 S226.95
M106 S229.5
G1 X182.183 Y156.289 E.00564
M106 S226.95
M106 S229.5
G1 X182.302 Y156.51 E.00749
M106 S226.95
M106 S229.5
G1 X182.401 Y156.706 E.00653
M106 S226.95
M106 S229.5
G1 X182.482 Y156.878 E.00567
M106 S226.95
M106 S229.5
G1 X182.631 Y157.224 E.01122
M106 S226.95
M106 S229.5
G1 X182.764 Y157.578 E.01128
M106 S226.95
M106 S229.5
G1 X182.881 Y157.939 E.0113
M106 S226.95
G1 X182.981 Y158.304 E.01128
G1 X183.015 Y158.45 E.00447
G1 X183.087 Y158.844 E.01191
G1 X183.143 Y159.147 E.00918
G1 X183.187 Y159.526 E.01136
G1 X183.213 Y159.908 E.01141
G1 X183.214 Y160.308 E.01191
G1 X183.216 Y160.578 E.00804
G3 X182.877 Y162.571 I-7.924 J-.323 E.0604
G3 X182.671 Y163.15 I-7.412 J-2.317 E.01832
; COOLING_NODE: 0
; WIPE_START
G1 F9547.055
M204 S8000
G1 X182.485 Y163.555 E-.16935
M73 P70 R2
G1 X182.121 Y164.236 E-.29314
G1 X181.697 Y164.879 E-.29279
G1 X181.689 Y164.889 E-.00472
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X181.811 Y157.257 Z1.8 F60000
G1 X181.862 Y154.041 Z1.8
G1 Z1.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1838
M204 S8000
G1 X182.213 Y154.469 E.01778
G3 X182.514 Y154.884 I-7.223 J5.547 E.0165
G1 X182.321 Y155.024 E.00766
G2 X173.034 Y151.703 I-7.07 J5.124 E.33703
G2 X167.032 Y163.058 I1.976 J8.308 E.46744
G2 X174.441 Y168.832 I8.222 J-2.91 E.31897
G1 X174.419 Y169.072 E.00774
G3 X175.399 Y150.918 I.583 J-9.072 E.91241
G3 X181.806 Y153.976 I-.41 J9.098 E.23448
G1 X181.823 Y153.996 E.00085
; COOLING_NODE: 0
M204 S10000
G1 X182.173 Y153.792 F60000
G1 F1838
M204 S8000
G1 X182.536 Y154.219 E.01802
G3 X174.748 Y150.505 I-7.535 J5.779 E1.63067
G3 X175.416 Y150.511 I.246 J10.175 E.02149
G3 X181.928 Y153.503 I-.416 J9.487 E.23628
G1 X182.134 Y153.746 E.01026
; COOLING_NODE: 1
M204 S250
G1 X182.472 Y153.538 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1838
M204 S5000
G1 X182.846 Y153.98 E.01723
G3 X174.74 Y150.113 I-7.846 J6.019 E1.57297
G3 X175.432 Y150.119 I.254 J10.546 E.02062
G3 X182.214 Y153.235 I-.432 J9.879 E.22796
G1 X182.433 Y153.493 E.01006
; WIPE_START
M73 P71 R2
G1 F9547.055
M204 S8000
G1 X182.846 Y153.98 E-.24266
G1 X183.085 Y154.305 E-.15345
G1 X183.433 Y154.833 E-.24035
G1 X183.591 Y155.117 E-.12354
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X182.538 Y155.118 Z1.8 F60000
G1 Z1.4
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.656934
G1 F1838
M204 S8000
G3 X183.314 Y156.556 I-8.194 J5.35 E.07935
; LINE_WIDTH: 0.61182
G3 X183.769 Y157.887 I-8.174 J3.538 E.06329
; LINE_WIDTH: 0.570741
G1 X183.82 Y158.096 E.00895
G3 X183.997 Y159.128 I-8.373 J1.97 E.0437
; LINE_WIDTH: 0.529352
G1 X184.029 Y159.454 E.01257
G3 X184.042 Y160.609 I-9.484 J.685 E.04439
; LINE_WIDTH: 0.483361
G1 X184.024 Y160.874 E.00924
G3 X183.836 Y162.117 I-9.163 J-.753 E.04377
; LINE_WIDTH: 0.460539
G1 X183.756 Y162.433 E.01077
G3 X180.396 Y167.285 I-8.565 J-2.342 E.19847
; LINE_WIDTH: 0.523246
G1 X180.109 Y167.483 E.01323
G3 X179.008 Y168.105 I-5.015 J-7.6 E.04804
; LINE_WIDTH: 0.571083
G3 X177.562 Y168.646 I-3.856 J-8.107 E.06449
; LINE_WIDTH: 0.620621
G1 X177.429 Y168.682 E.00627
G3 X175.885 Y168.949 I-2.308 J-8.776 E.07159
; LINE_WIDTH: 0.661469
G1 X175.665 Y168.964 E.01078
G3 X174.95 Y168.977 I-.502 J-8.09 E.03494
; LINE_WIDTH: 0.661807
G1 X174.783 Y169.131 E.01112
; LINE_WIDTH: 0.632613
G1 X174.615 Y169.285 E.01059
; WIPE_START
G1 F6104.875
G1 X174.783 Y169.131 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X168.285 Y165.78 Z1.8 F60000
G1 Z1.4
G1 E.8 F1800
; LINE_WIDTH: 0.105369
G1 F1838
M204 S8000
G3 X168.051 Y165.486 I7.396 J-6.148 E.00186
G1 X167.947 Y165.347 E.00085
; LINE_WIDTH: 0.135765
G3 X167.318 Y164.361 I7.558 J-5.512 E.00858
G1 X167.217 Y164.169 E.00159
; LINE_WIDTH: 0.197972
G1 X167.101 Y163.936 E.00318
G3 X173.529 Y151.31 I7.943 J-3.906 E.20121
; LINE_WIDTH: 0.167379
G3 X174.746 Y151.171 I1.684 J9.349 E.01204
G1 X174.962 Y151.165 E.00212
; LINE_WIDTH: 0.120584
G3 X176.517 Y151.27 I.174 J8.946 E.00958
; CHANGE_LAYER
; Z_HEIGHT: 1.6
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F15000
G1 X175.68 Y151.179 E-.41001
G1 X174.962 Y151.165 E-.34999
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 8/19
; update layer progress
M73 L8
M991 S0 P7 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z1.8 I-1.201 J-.196 P1  F60000
G1 X172.175 Y168.205 Z1.8
G1 Z1.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1847
M204 S8000
G1 X171.441 Y167.911 E.02544
G3 X168.855 Y165.997 I3.436 J-7.346 E.10415
G3 X169.6 Y153.909 I6.132 J-5.689 E.43547
G3 X174.748 Y151.884 I5.479 J6.374 E.18126
G3 X181.745 Y155.48 I.233 J8.152 E.26397
G3 X179.601 Y167.193 I-6.863 J4.797 E.42599
G3 X174.668 Y168.672 I-4.708 J-6.737 E.16844
G3 X172.229 Y168.23 I.209 J-8.107 E.08001
; COOLING_NODE: 0
M204 S250
G1 X172.317 Y167.846 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1844
M204 S5000
G3 X169.144 Y165.732 I2.56 J-7.281 E.11475
G3 X169.849 Y154.212 I5.843 J-5.424 E.3844
G3 X174.135 Y152.325 I5.232 J6.075 E.14155
G1 X174.621 Y152.282 E.01451
G1 X174.761 Y152.276 E.00419
G1 X174.943 Y152.272 E.0054
G1 X175.3 Y152.278 E.01066
G1 X175.697 Y152.304 E.01182
M106 S229.5
G1 X175.927 Y152.328 E.00689
M106 S226.95
M106 S229.5
G1 X176.106 Y152.352 E.00539
M106 S226.95
M106 S229.5
G1 X176.459 Y152.411 E.01066
M106 S226.95
M106 S229.5
G1 X176.809 Y152.487 E.01067
M106 S226.95
M106 S229.5
G1 X176.985 Y152.532 E.00541
M106 S226.95
M106 S229.5
G1 X177.206 Y152.594 E.00684
M106 S226.95
M106 S229.5
G1 X177.585 Y152.717 E.01186
M106 S226.95
M106 S229.5
G1 X177.92 Y152.845 E.01069
M106 S226.95
M106 S229.5
G1 X178.138 Y152.938 E.00704
M106 S226.95
M106 S229.5
G1 X178.303 Y153.014 E.00543
M106 S226.95
M106 S229.5
G1 X178.626 Y153.176 E.01075
M106 S226.95
M106 S229.5
G1 X178.941 Y153.353 E.01077
M106 S226.95
M106 S229.5
G1 X179.268 Y153.558 E.0115
M106 S226.95
M106 S229.5
G1 X179.562 Y153.763 E.01067
M106 S226.95
M106 S229.5
G1 F1800
G1 X179.707 Y153.871 E.0054
M106 S226.95
M106 S229.5
G1 F1680
G1 X179.904 Y154.027 E.00746
M106 S226.95
M106 S229.5
G1 F1440
G1 X180.189 Y154.274 E.01125
M106 S226.95
M106 S229.5
G1 F1320
G1 X180.45 Y154.522 E.01072
M106 S226.95
M106 S229.5
G1 F1200
G1 X180.698 Y154.78 E.01067
M106 S226.95
M106 S229.5
G1 F1080
G1 X180.87 Y154.974 E.00773
M106 S226.95
M106 S229.5
G1 F960
G1 X180.988 Y155.115 E.00545
M106 S226.95
M106 S229.5
G1 F840
G1 X181.213 Y155.404 E.01093
M106 S226.95
M106 S229.5
G1 F600
G1 X181.42 Y155.698 E.01069
M106 S226.95
M106 S229.5
G1 X181.612 Y156 E.01067
M106 S226.95
M106 S229.5
G1 X181.837 Y156.381 E.0132
M106 S226.95
M106 S229.5
G3 X182.575 Y158.128 I-7.942 J4.385 E.05657
M106 S226.95
M106 S229.5
G1 X182.623 Y158.304 E.00545
M106 S226.95
M106 S229.5
G3 X182.812 Y159.287 I-8.913 J2.225 E.02982
M106 S226.95
M106 S229.5
G1 X182.834 Y159.47 E.0055
M106 S226.95
M106 S229.5
G3 X182.855 Y160.842 I-10.982 J.854 E.04091
M106 S226.95
M106 S229.5
G1 X182.839 Y161.028 E.00554
M106 S226.95
M106 S229.5
G3 X182.657 Y162.117 I-8.847 J-.916 E.03292
M106 S226.95
M106 S229.5
G1 X182.611 Y162.298 E.00558
M106 S226.95
M106 S229.5
M73 P72 R2
G1 X182.551 Y162.515 E.0067
M106 S226.95
M106 S229.5
G1 X182.48 Y162.742 E.00707
M106 S226.95
M106 S229.5
G1 F720
G1 X182.42 Y162.919 E.00558
M106 S226.95
M106 S229.5
G1 F840
G1 X182.288 Y163.265 E.01104
M106 S226.95
M106 S229.5
G1 F960
G1 X182.14 Y163.606 E.01106
M106 S226.95
M106 S229.5
G1 F1080
G1 X182.059 Y163.775 E.0056
M106 S226.95
M106 S229.5
G1 F1200
G1 X181.952 Y163.985 E.00703
M106 S226.95
M106 S229.5
G1 F1320
G1 X181.841 Y164.188 E.00687
M106 S226.95
M106 S229.5
G1 F1440
G1 X181.747 Y164.35 E.0056
M106 S226.95
M106 S229.5
G1 F1560
G1 X181.548 Y164.667 E.01113
M106 S226.95
M106 S229.5
G1 F1680
G1 X181.334 Y164.974 E.01117
M106 S226.95
M106 S229.5
G1 F1800
G1 X181.105 Y165.272 E.01118
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

M106 S226.95
M106 S229.5
G1 F1844
G1 X180.862 Y165.559 E.01121
M106 S226.95
M106 S229.5
G1 X180.607 Y165.835 E.0112
M106 S226.95
M106 S229.5
G1 X180.406 Y166.034 E.00843
M106 S226.95
M106 S229.5
G1 X180.267 Y166.165 E.00568
M106 S226.95
M106 S229.5
G1 X179.983 Y166.413 E.01122
M106 S226.95
M106 S229.5
G1 X179.686 Y166.648 E.01128
M106 S226.95
M106 S229.5
G1 X179.379 Y166.87 E.01128
M106 S226.95
G1 X179.061 Y167.077 E.01133
G1 X178.918 Y167.161 E.00493
G1 X178.396 Y167.448 E.01774
G1 X178.05 Y167.609 E.01137
G1 X177.677 Y167.753 E.01191
G1 X177.338 Y167.89 E.01089
G3 X174.68 Y168.28 I-2.439 J-7.367 E.08041
G3 X172.374 Y167.865 I.196 J-7.715 E.07008
; COOLING_NODE: 0
; WIPE_START
G1 F9547.055
M204 S8000
G1 X171.601 Y167.557 E-.31634
G1 X171.3 Y167.414 E-.12629
G1 X170.913 Y167.191 E-.16994
G1 X170.592 Y166.973 E-.14743
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.623 Y161.233 Z2 F60000
G1 X181.895 Y154.077 Z2
G1 Z1.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1847
M204 S8000
G1 X181.907 Y154.095 E.00069
G3 X182.18 Y165.577 I-6.913 J5.909 E.39974
G1 X181.986 Y165.436 E.00771
G2 X182.293 Y155.582 I-7.038 J-5.152 E.33695
G2 X169.645 Y153.355 I-7.301 J4.435 E.46732
G2 X166.436 Y162.223 I5.256 J6.917 E.32059
G1 X166.201 Y162.28 E.00776
G3 X175.399 Y150.918 I8.808 J-2.274 E.54597
G3 X181.482 Y153.631 I-.406 J9.085 E.21927
G1 X181.854 Y154.033 E.01761
; COOLING_NODE: 0
M204 S10000
G1 X182.184 Y153.79 F60000
G1 F1847
M204 S8000
G1 X182.433 Y154.087 E.01247
G3 X174.748 Y150.505 I-7.433 J5.913 E1.63634
G3 X175.416 Y150.511 I.246 J10.22 E.02148
G3 X182.115 Y153.708 I-.415 J9.489 E.24523
G1 X182.145 Y153.744 E.00151
; COOLING_NODE: 1
M204 S250
G1 X182.484 Y153.538 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1844
M204 S5000
G1 X182.74 Y153.843 E.01186
G3 X174.74 Y150.113 I-7.74 J6.157 E1.57839
G3 X175.432 Y150.119 I.254 J10.581 E.02062
G3 X182.408 Y153.447 I-.432 J9.88 E.23652
G1 X182.445 Y153.492 E.00175
; WIPE_START
M73 P73 R2
G1 F9547.055
M204 S8000
G1 X182.74 Y153.843 E-.17409
G1 X183.051 Y154.256 E-.19648
G1 X183.521 Y154.98 E-.32803
G1 X183.6 Y155.121 E-.0614
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X182.77 Y155.844 Z2 F60000
G1 Z1.6
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.170088
G1 F1847
M204 S8000
G3 X183.363 Y157.153 I-7.638 J4.248 E.01445
; LINE_WIDTH: 0.121244
G3 X183.718 Y158.445 I-8.26 J2.962 E.0083
G1 X183.775 Y158.775 E.00207
; WIPE_START
G1 F15000
G1 X183.718 Y158.445 E-.15178
G1 X183.565 Y157.79 E-.30499
G1 X183.363 Y157.153 E-.30323
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X182.77 Y155.844 Z2 F60000
G1 Z1.6
G1 E.8 F1800
; LINE_WIDTH: 0.198241
G1 F1847
M204 S8000
G2 X169.003 Y153.53 I-7.78 J4.179 E.19751
G2 X168.707 Y153.809 I4.656 J5.237 E.005
; LINE_WIDTH: 0.136549
G1 X168.484 Y154.036 E.00236
G2 X167.704 Y154.988 I6.397 J6.038 E.0091
; LINE_WIDTH: 0.104638
G1 X167.65 Y155.064 E.00046
G2 X167.42 Y155.412 I11.948 J8.146 E.00203
; WIPE_START
G1 F15000
G1 X167.65 Y155.064 E-.62074
G1 X167.704 Y154.988 E-.13926
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X166.367 Y162.449 Z2 F60000
G1 Z1.6
G1 E.8 F1800
; LINE_WIDTH: 0.662179
G1 F1847
M204 S8000
G2 X166.662 Y163.356 I9.341 J-2.543 E.04664
G1 X166.816 Y163.731 E.01982
; LINE_WIDTH: 0.61731
G2 X167.48 Y164.974 I8.502 J-3.743 E.06402
G1 X167.622 Y165.187 E.01163
; LINE_WIDTH: 0.570316
G2 X168.515 Y166.3 I7.408 J-5.027 E.05948
; LINE_WIDTH: 0.524402
G2 X169.686 Y167.344 I6.673 J-6.311 E.05975
; LINE_WIDTH: 0.461998
G2 X176.26 Y168.989 I5.277 J-7.13 E.23017
G1 X176.502 Y168.948 E.00815
; LINE_WIDTH: 0.507739
G2 X177.993 Y168.541 I-1.769 J-9.409 E.05682
; LINE_WIDTH: 0.557128
G2 X179.511 Y167.815 I-3.214 J-8.671 E.0684
; LINE_WIDTH: 0.605271
G2 X180.543 Y167.096 I-5.05 J-8.349 E.05594
G1 X180.723 Y166.947 E.01037
; LINE_WIDTH: 0.654022
G2 X181.964 Y165.672 I-6.248 J-7.324 E.08602
; CHANGE_LAYER
; Z_HEIGHT: 1.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F5890.997
G1 X181.545 Y166.154 E-.27245
G1 X181.257 Y166.455 E-.17775
G1 X180.723 Y166.947 E-.30979
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 9/19
; update layer progress
M73 L9
M991 S0 P8 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z2 I.373 J-1.158 P1  F60000
G1 X166.667 Y162.419 Z2
G1 Z1.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1852
M204 S8000
G1 X166.474 Y161.653 E.0254
G3 X166.355 Y159.24 I8.044 J-1.606 E.07797
G3 X174.404 Y151.715 I8.405 J.923 E.38591
G3 X179.301 Y153.097 I.314 J8.252 E.16632
G3 X182.867 Y162.01 I-4.363 J6.916 E.32993
G3 X179.323 Y166.963 I-8.4 J-2.267 E.20008
G3 X167.299 Y163.943 I-4.622 J-7.043 E.448
G3 X166.683 Y162.477 I7.219 J-3.895 E.05121
; COOLING_NODE: 0
M204 S250
G1 X167.047 Y162.327 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1844
M204 S5000
G3 X166.746 Y159.275 I7.424 J-2.275 E.09197
G3 X174.418 Y152.107 I8.016 J.891 E.34056
G3 X178.928 Y153.322 I.261 J8.007 E.14115
G3 X181.882 Y156.499 I-4.153 J6.824 E.13089
G1 X182.028 Y156.812 E.01026
G1 X182.191 Y157.177 E.01191
G1 X182.259 Y157.35 E.00554
M73 P74 R2
G1 X182.375 Y157.692 E.01076
G1 X182.442 Y157.917 E.00699
G1 X182.489 Y158.092 E.0054
M106 S229.5
G1 X182.569 Y158.441 E.01066
M106 S226.95
M106 S229.5
G1 X182.633 Y158.793 E.01067
M106 S226.95
M106 S229.5
G1 X182.659 Y158.973 E.0054
M106 S226.95
M106 S229.5
G1 X182.686 Y159.196 E.00669
M106 S226.95
M106 S229.5
G1 X182.706 Y159.419 E.00667
M106 S226.95
M106 S229.5
G1 X182.717 Y159.6 E.0054
M106 S226.95
M106 S229.5
G3 X182.727 Y160.137 I-7.699 J.4 E.01602
M106 S226.95
M106 S229.5
G1 X182.719 Y160.371 E.00696
M106 S226.95
M106 S229.5
G1 X182.69 Y160.764 E.01175
M106 S226.95
M106 S229.5
G1 X182.646 Y161.12 E.01068
M106 S226.95
M106 S229.5
G1 X182.618 Y161.299 E.00539
M106 S226.95
M106 S229.5
G1 X182.573 Y161.537 E.0072
M106 S226.95
M106 S229.5
G1 X182.487 Y161.913 E.01151
M106 S226.95
M106 S229.5
G1 X182.39 Y162.259 E.01069
M106 S226.95
M106 S229.5
G1 F1800
G1 X182.314 Y162.495 E.00739
M106 S226.95
M106 S229.5
G1 F1680
G1 X182.253 Y162.667 E.00544
M106 S226.95
M106 S229.5
G1 F1560
G1 X182.114 Y163.019 E.01126
M106 S226.95
M106 S229.5
G1 F1440
G1 X181.966 Y163.345 E.01067
M106 S226.95
M106 S229.5
G1 F1320
G1 X181.886 Y163.508 E.0054
M106 S226.95
M106 S229.5
G1 F1200
G1 X181.766 Y163.733 E.00759
M106 S226.95
M106 S229.5
G1 F1080
G1 X181.582 Y164.05 E.01093
M106 S226.95
M106 S229.5
G1 F840
G1 X181.383 Y164.356 E.01087
M106 S226.95
M106 S229.5
G1 F720
G1 X181.173 Y164.649 E.01073
M106 S226.95
M106 S229.5
G1 F600
G3 X180.834 Y165.068 I-6.147 J-4.628 E.01606
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

M106 S226.95
M106 S229.5
G1 X180.541 Y165.399 E.01318
M106 S226.95
M106 S229.5
G3 X180.033 Y165.909 I-5.719 J-5.187 E.02144
M106 S226.95
M106 S229.5
G1 X179.897 Y166.031 E.00544
M106 S226.95
M106 S229.5
G3 X178.786 Y166.839 I-6.956 J-8.392 E.04096
M106 S226.95
M106 S229.5
G3 X178.4 Y167.056 I-4.029 J-6.707 E.01318
M106 S226.95
M106 S229.5
G3 X177.138 Y167.586 I-5.004 J-10.17 E.0408
M106 S226.95
M106 S229.5
G1 X176.961 Y167.64 E.00551
M106 S226.95
M106 S229.5
G3 X175.516 Y167.922 I-2.738 J-10.181 E.04388
M106 S226.95
M106 S229.5
G1 X175.147 Y167.95 E.01103
M106 S226.95
M106 S229.5
G1 X174.776 Y167.961 E.01104
M106 S226.95
M106 S229.5
G1 F720
G1 X174.406 Y167.955 E.01104
M106 S226.95
M106 S229.5
G1 F840
G1 X174.034 Y167.932 E.01108
M106 S226.95
M106 S229.5
G1 F960
G1 X173.665 Y167.891 E.01108
M106 S226.95
M106 S229.5
G1 F1200
G1 X173.388 Y167.849 E.00833
M106 S226.95
M106 S229.5
G1 F1320
G1 X173.202 Y167.815 E.00562
M106 S226.95
M106 S229.5
G1 F1440
G1 X172.839 Y167.736 E.01108
M106 S226.95
M106 S229.5
G1 F1560
G1 X172.656 Y167.689 E.00562
M106 S226.95
M106 S229.5
G1 F1680
G3 X172.208 Y167.555 I2.169 J-8.066 E.01393
M106 S226.95
M106 S229.5
G1 F1800
G1 X172.029 Y167.493 E.00565
M106 S226.95
M106 S229.5
G1 F1844
G1 X171.679 Y167.359 E.01115
M106 S226.95
M106 S229.5
G1 X171.334 Y167.208 E.01122
M106 S226.95
M106 S229.5
G1 X170.997 Y167.041 E.01123
M106 S226.95
M106 S229.5
G1 X170.667 Y166.858 E.01121
M106 S226.95
M106 S229.5
G1 X170.504 Y166.76 E.00568
M106 S226.95
M106 S229.5
G1 X170.286 Y166.62 E.0077
M106 S226.95
M106 S229.5
G1 X169.956 Y166.39 E.01201
M106 S226.95
G1 X169.655 Y166.157 E.01132
G1 X169.406 Y165.946 E.00972
G1 X169.119 Y165.668 E.01191
G1 X168.811 Y165.368 E.01281
G1 X168.504 Y165.018 E.01385
G1 X168.264 Y164.699 E.01191
G1 X168.046 Y164.406 E.01086
G3 X167.836 Y164.085 I6.97 J-4.787 E.01143
G3 X167.065 Y162.384 I6.636 J-4.033 E.05576
; COOLING_NODE: 0
; WIPE_START
G1 F9547.055
M204 S8000
G1 X166.948 Y161.954 E-.16949
G1 X166.801 Y161.197 E-.29297
G1 X166.725 Y160.43 E-.29277
G1 X166.725 Y160.418 E-.00477
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X173.764 Y157.469 Z2.2 F60000
G1 X181.88 Y154.069 Z2.2
G1 Z1.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1852
M204 S8000
G1 X182.113 Y154.34 E.01148
G3 X171.951 Y168.565 I-7.114 J5.66 E.75556
G1 X172.027 Y168.336 E.00775
G2 X181.571 Y165.435 I2.693 J-8.289 E.3415
G2 X179.529 Y152.76 I-6.612 J-5.437 E.46675
G2 X170.231 Y152.542 I-4.822 J7.245 E.31552
G1 X170.109 Y152.337 E.00768
G3 X175.4 Y150.918 I4.897 J7.686 E.17889
G3 X181.645 Y153.798 I-.401 J9.082 E.22679
G1 X181.841 Y154.024 E.00963
; COOLING_NODE: 0
M204 S10000
G1 X182.195 Y153.804 F60000
G1 F1852
M204 S8000
G1 X182.27 Y153.888 E.0036
G3 X174.747 Y150.505 I-7.269 J6.112 E1.64449
G3 X175.416 Y150.511 I.247 J10.227 E.0215
G3 X181.942 Y153.518 I-.416 J9.488 E.23695
G1 X182.155 Y153.759 E.01037
; COOLING_NODE: 1
M204 S250
G1 X182.488 Y153.544 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1844
M204 S5000
M73 P75 R2
G1 X182.57 Y153.636 E.00365
G3 X174.74 Y150.113 I-7.57 J6.363 E1.58627
G3 X175.432 Y150.119 I.254 J10.595 E.02062
G3 X182.227 Y153.249 I-.432 J9.88 E.22853
G1 X182.449 Y153.499 E.00996
; WIPE_START
G1 F9547.055
M204 S8000
G1 X182.57 Y153.636 E-.06941
G1 X182.95 Y154.118 E-.23332
G1 X183.432 Y154.832 E-.32722
G1 X183.597 Y155.132 E-.13005
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X178.799 Y152.029 Z2.2 F60000
G1 Z1.8
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.131342
G1 F1852
M204 S8000
G2 X177.362 Y151.466 I-4.013 J8.132 E.01079
; LINE_WIDTH: 0.101605
G1 X177.239 Y151.431 E.00059
G2 X176.98 Y151.364 I-3.005 J11.093 E.00124
; WIPE_START
G1 F15000
G1 X177.239 Y151.431 E-.5133
G1 X177.362 Y151.466 E-.2467
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X178.799 Y152.029 Z2.2 F60000
G1 Z1.8
G1 E.8 F1800
; LINE_WIDTH: 0.197669
G1 F1852
M204 S8000
G1 X179.14 Y152.207 E.0047
G3 X181.183 Y166.284 I-4.177 J7.793 E.20202
; LINE_WIDTH: 0.161723
G3 X180.757 Y166.689 I-6.58 J-6.487 E.00552
G1 X180.077 Y167.235 E.00818
; LINE_WIDTH: 0.117365
G3 X179.067 Y167.868 I-5.17 J-7.125 E.00702
G1 X178.9 Y167.956 E.00111
; WIPE_START
G1 F15000
G1 X179.067 Y167.868 E-.10349
G1 X179.618 Y167.547 E-.35115
G1 X180.077 Y167.235 E-.30535
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.517 Y168.284 Z2.2 F60000
G1 X171.797 Y168.384 Z2.2
G1 Z1.8
G1 E.8 F1800
; LINE_WIDTH: 0.663611
G1 F1852
M204 S8000
G3 X170.997 Y168.046 I3.348 J-9.048 E.04257
G1 X170.644 Y167.867 E.01942
; LINE_WIDTH: 0.619982
G3 X169.443 Y167.098 I4.264 J-7.982 E.06503
G1 X169.26 Y166.955 E.0106
; LINE_WIDTH: 0.571927
G3 X168.195 Y165.951 I5.592 J-7.001 E.06125
; LINE_WIDTH: 0.523959
G3 X167.363 Y164.878 I6.73 J-6.074 E.05162
G1 X167.188 Y164.6 E.01251
; LINE_WIDTH: 0.462335
G3 X166.246 Y157.619 I7.604 J-4.579 E.23997
; LINE_WIDTH: 0.51051
G3 X166.725 Y156.335 I8.961 J2.609 E.05066
G1 X166.797 Y156.183 E.0062
; LINE_WIDTH: 0.557068
G3 X167.508 Y154.965 I8.065 J3.89 E.05734
G1 X167.561 Y154.889 E.00376
; LINE_WIDTH: 0.602731
G3 X168.44 Y153.832 I7.447 J5.298 E.06089
G1 X168.519 Y153.753 E.00491
; LINE_WIDTH: 0.654234
G3 X169.712 Y152.744 I6.273 J6.21 E.07558
G1 X169.998 Y152.549 E.01672
; CHANGE_LAYER
; Z_HEIGHT: 2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F5888.962
G1 X169.712 Y152.744 E-.13771
G1 X169.051 Y153.257 E-.33309
G1 X168.519 Y153.753 E-.2892
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 10/19
; update layer progress
M73 L10
M991 S0 P9 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z2.2 I.397 J1.151 P1  F60000
G1 X175.379 Y151.388 Z2.2
G1 Z2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1842
M204 S8000
G1 X175.397 Y151.391 E.00059
G3 X176.974 Y151.662 I-.69 J8.759 E.05152
G3 X182.837 Y162.149 I-2.124 J8.07 E.43131
G3 X175.405 Y168.11 I-7.859 J-2.186 E.32713
G3 X169.621 Y166.189 I-.314 J-8.724 E.20021
G3 X168.956 Y153.804 I5.366 J-6.498 E.44817
G3 X174.191 Y151.379 I5.864 J5.796 E.18954
G3 X174.599 Y151.365 I.516 J8.771 E.01311
G1 X175.319 Y151.387 E.02317
; COOLING_NODE: 0
M204 S250
G1 X175.366 Y151.789 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1842
M204 S5000
G3 X176.5 Y151.949 I-.721 J9.216 E.03416
G3 X182.56 Y161.691 I-1.662 J7.789 E.38154
M73 P76 R2
G3 X179.882 Y165.989 I-7.809 J-1.882 E.15346
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

G1 X179.632 Y166.186 E.0095
G1 X179.339 Y166.395 E.01071
G1 X179.004 Y166.609 E.01184
M106 S229.5
G1 X178.688 Y166.791 E.01086
M106 S226.95
M106 S229.5
G1 X178.489 Y166.896 E.00671
M106 S226.95
M106 S229.5
G1 X178.327 Y166.975 E.00537
M106 S226.95
M106 S229.5
G1 X178.164 Y167.05 E.00535
M106 S226.95
M106 S229.5
G1 X177.956 Y167.14 E.00673
M106 S226.95
M106 S229.5
G1 X177.619 Y167.271 E.01079
M106 S226.95
M106 S229.5
G1 X177.275 Y167.385 E.01078
M106 S226.95
M106 S229.5
G1 X176.893 Y167.492 E.01183
M106 S226.95
M106 S229.5
G1 X176.542 Y167.572 E.01072
M106 S226.95
M106 S229.5
G1 X176.366 Y167.606 E.00535
M106 S226.95
M106 S229.5
G1 X176.142 Y167.643 E.00676
M106 S226.95
M106 S229.5
G1 X175.771 Y167.689 E.01113
M106 S226.95
M106 S229.5
G1 X175.385 Y167.718 E.01151
M106 S226.95
M106 S229.5
G1 X175.027 Y167.728 E.01069
M106 S226.95
M106 S229.5
G1 F1800
G1 X174.798 Y167.725 E.00682
M106 S226.95
M106 S229.5
G1 F1680
G1 X174.596 Y167.717 E.00603
M106 S226.95
M106 S229.5
G1 F1560
G1 X174.219 Y167.688 E.01126
M106 S226.95
M106 S229.5
G1 F1320
G1 X173.859 Y167.643 E.0108
M106 S226.95
M106 S229.5
G1 F1200
G3 X173.458 Y167.572 I1.154 J-7.717 E.01212
M106 S226.95
M106 S229.5
G1 F960
G1 X173.079 Y167.485 E.01158
M106 S226.95
M106 S229.5
G1 F840
G1 X172.731 Y167.387 E.01078
M106 S226.95
M106 S229.5
G1 F600
G1 X172.388 Y167.273 E.01078
M106 S226.95
M106 S229.5
G1 X172.049 Y167.142 E.01082
M106 S226.95
M106 S229.5
G3 X170.014 Y166 I3.378 J-8.404 E.06971
M106 S226.95
M106 S229.5
G1 X169.87 Y165.886 E.00548
M106 S226.95
M106 S229.5
G3 X169.315 Y165.39 I4.888 J-6.028 E.02219
M106 S226.95
M106 S229.5
G1 X169.135 Y165.208 E.00761
M106 S226.95
M106 S229.5
G3 X168.544 Y164.51 I6.856 J-6.409 E.02726
M106 S226.95
M106 S229.5
G1 X168.382 Y164.287 E.0082
M106 S226.95
M106 S229.5
G3 X167.582 Y162.838 I6.845 J-4.728 E.0494
M106 S226.95
M106 S229.5
G1 X167.511 Y162.664 E.00558
M106 S226.95
M106 S229.5
G1 X167.431 Y162.454 E.00668
M106 S226.95
M106 S229.5
G1 X167.353 Y162.229 E.0071
M106 S226.95
M106 S229.5
G1 F720
G3 X167.197 Y161.694 I7.568 J-2.494 E.01661
M106 S226.95
M106 S229.5
G1 F960
G1 X167.115 Y161.332 E.01105
M106 S226.95
M106 S229.5
G1 F1080
G1 X167.079 Y161.148 E.00558
M106 S226.95
M106 S229.5
G1 F1200
G1 X167.041 Y160.916 E.00701
M106 S226.95
M106 S229.5
G1 F1320
G1 X167.01 Y160.687 E.00686
M106 S226.95
M106 S229.5
G1 F1440
G3 X166.962 Y160.128 I7.981 J-.964 E.01673
M106 S226.95
M106 S229.5
G1 F1680
G1 X166.952 Y159.754 E.01114
M106 S226.95
M106 S229.5
G1 F1800
G1 X166.954 Y159.565 E.00564
M106 S226.95
M106 S229.5
G1 F1842
G1 X166.962 Y159.319 E.00731
M106 S226.95
M106 S229.5
G3 X166.994 Y158.907 I7.923 J.393 E.01231
M106 S226.95
M106 S229.5
G1 X167.04 Y158.537 E.01113
M106 S226.95
M106 S229.5
G1 X167.07 Y158.349 E.00567
M106 S226.95
M106 S229.5
G1 X167.123 Y158.07 E.00844
M106 S226.95
M106 S229.5
G1 X167.209 Y157.702 E.01126
M106 S226.95
M106 S229.5
G1 X167.313 Y157.338 E.01126
M106 S226.95
M106 S229.5
G1 X167.433 Y156.979 E.0113
M106 S226.95
G1 X167.57 Y156.625 E.0113
G1 X167.605 Y156.542 E.0027
G1 X167.779 Y156.181 E.01191
G1 X167.939 Y155.851 E.01094
G1 X168.146 Y155.508 E.01191
G1 X168.335 Y155.197 E.01083
G1 X168.574 Y154.877 E.01191
G1 X168.855 Y154.51 E.01379
G3 X169.238 Y154.077 I6.648 J5.489 E.0172
G3 X174.215 Y151.771 I5.594 J5.549 E.1669
G3 X175.306 Y151.784 I.429 J9.235 E.03251
; COOLING_NODE: 0
; WIPE_START
G1 F9547.055
M204 S8000
G1 X175.748 Y151.819 E-.16839
G1 X176.5 Y151.949 E-.29031
G1 X177.236 Y152.148 E-.28955
G1 X177.265 Y152.159 E-.01176
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X181.882 Y154.063 Z2.4 F60000
G1 Z2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1842
M204 S8000
G1 X182.117 Y154.345 E.01179
G3 X165.913 Y159.749 I-7.118 J5.653 E1.12249
G1 X166.152 Y159.747 E.00771
G2 X171.745 Y167.881 I8.72 J-.005 E.33744
G2 X183.226 Y162.268 I3.254 J-7.893 E.46438
G2 X180.607 Y153.155 I-8.36 J-2.53 E.3223
G1 X180.763 Y152.971 E.00774
G1 X180.904 Y153.088 E.00589
G3 X181.811 Y153.98 I-5.905 J6.91 E.04094
G1 X181.843 Y154.018 E.00159
; COOLING_NODE: 0
M204 S10000
G1 X182.194 Y153.802 F60000
G1 F1842
M204 S8000
G1 X182.44 Y154.086 E.01207
G3 X175.166 Y150.504 I-7.431 J5.914 E1.64939
G1 X175.581 Y150.52 E.01337
G3 X182.12 Y153.704 I-.572 J9.48 E.24
G1 X182.157 Y153.754 E.00201
; COOLING_NODE: 1
M204 S250
M73 P77 R2
G1 X182.494 Y153.55 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1842
M204 S5000
G1 X182.745 Y153.84 E.01143
G3 X175.172 Y150.112 I-7.736 J6.159 E1.59098
G1 X175.604 Y150.128 E.01287
G3 X182.412 Y153.443 I-.595 J9.871 E.23146
G1 X182.458 Y153.503 E.00222
; WIPE_START
G1 F9547.055
M204 S8000
G1 X182.745 Y153.84 E-.16859
G1 X183.052 Y154.257 E-.19671
G1 X183.387 Y154.759 E-.22934
G1 X183.608 Y155.13 E-.16391
G1 X183.609 Y155.133 E-.00146
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X180.531 Y152.93 Z2.4 F60000
G1 Z2
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.653549
G1 F1842
M204 S8000
G2 X178.946 Y151.909 I-5.747 J7.183 E.0911
; LINE_WIDTH: 0.603899
G1 X178.67 Y151.775 E.01357
G2 X177.639 Y151.371 I-4.216 J9.247 E.04911
; LINE_WIDTH: 0.561117
G1 X177.494 Y151.326 E.00621
G2 X176.26 Y151.042 I-2.625 J8.599 E.05186
; LINE_WIDTH: 0.513933
G2 X174.608 Y150.937 I-1.412 J9.166 E.06167
; LINE_WIDTH: 0.462056
G1 X174.587 Y150.938 E.0007
G2 X168.207 Y153.996 I.325 J8.863 E.24096
; LINE_WIDTH: 0.520279
G2 X167.374 Y155.137 I7.237 J6.154 E.05332
; LINE_WIDTH: 0.562902
G1 X167.19 Y155.45 E.01493
G2 X166.727 Y156.398 I7.993 J4.482 E.04335
; LINE_WIDTH: 0.609083
G1 X166.609 Y156.696 E.01431
G2 X166.252 Y157.892 I9.338 J3.438 E.05586
; LINE_WIDTH: 0.656467
G2 X166.03 Y159.544 I9.931 J2.173 E.08089
; WIPE_START
G1 F5867.52
G1 X166.112 Y158.672 E-.39876
G1 X166.252 Y157.892 E-.36124
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X168.378 Y165.222 Z2.4 F60000
G1 X168.657 Y166.184 Z2.4
G1 Z2
G1 E.8 F1800
; LINE_WIDTH: 0.106851
G1 F1842
M204 S8000
G2 X168.904 Y166.422 I5.761 J-5.739 E.00173
G1 X169.143 Y166.634 E.00161
; LINE_WIDTH: 0.138673
G2 X170.254 Y167.444 I5.791 J-6.775 E.01041
; LINE_WIDTH: 0.198272
G1 X170.589 Y167.64 E.00477
G2 X183.492 Y162.35 I4.395 J-7.661 E.19724
; LINE_WIDTH: 0.169983
G2 X183.795 Y160.852 I-8.478 J-2.494 E.01535
; LINE_WIDTH: 0.12179
G2 X183.831 Y159.294 I-9.189 J-.996 E.00972
; CHANGE_LAYER
; Z_HEIGHT: 2.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F15000
G1 X183.85 Y159.808 E-.25018
G1 X183.843 Y160.23 E-.20583
G1 X183.795 Y160.852 E-.304
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 11/19
; update layer progress
M73 L11
M991 S0 P10 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z2.4 I1.086 J-.549 P1  F60000
G1 X179.665 Y152.683 Z2.4
G1 Z2.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1863
M204 S8000
G1 X179.93 Y152.866 E.01036
G3 X180.419 Y153.222 I-4.554 J6.771 E.01945
G3 X183.53 Y159.137 I-5.013 J6.413 E.22147
G3 X175.448 Y168.116 I-8.328 J.631 E.43428
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

G3 X166.906 Y159.354 I-.433 J-8.123 E.44537
G3 X174.974 Y151.479 I8.321 J.454 E.39818
G3 X175.668 Y151.482 I.303 J8.607 E.02233
G3 X179.612 Y152.662 I-.291 J8.155 E.13381
; COOLING_NODE: 0
M204 S250
M73 P78 R2
G1 X179.443 Y153.018 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1844
M204 S5000
G3 X180.174 Y153.528 I-4.047 J6.588 E.02655
G3 X183.139 Y159.165 I-4.768 J6.106 E.19553
G3 X175.62 Y167.718 I-7.943 J.599 E.37791
G3 X170.77 Y166.467 I-.552 J-7.885 E.15183
G1 X170.606 Y166.357 E.00587
G1 X170.458 Y166.252 E.0054
G1 X170.174 Y166.035 E.01067
G1 X169.899 Y165.805 E.01069
M106 S229.5
G1 X169.635 Y165.562 E.01067
M106 S226.95
M106 S229.5
G1 X169.506 Y165.435 E.0054
M106 S226.95
M106 S229.5
G1 X169.351 Y165.273 E.00666
M106 S226.95
M106 S229.5
G1 X169.2 Y165.107 E.00669
M106 S226.95
M106 S229.5
G1 X169.082 Y164.969 E.0054
M106 S226.95
M106 S229.5
G1 X168.858 Y164.69 E.01066
M106 S226.95
M106 S229.5
G1 X168.647 Y164.4 E.01069
M106 S226.95
M106 S229.5
G1 X168.449 Y164.1 E.0107
M106 S226.95
M106 S229.5
G1 X168.266 Y163.791 E.01067
M106 S226.95
M106 S229.5
G1 X168.179 Y163.632 E.0054
M106 S226.95
M106 S229.5
G1 X168.07 Y163.419 E.00714
M106 S226.95
M106 S229.5
G1 X167.907 Y163.067 E.01156
M106 S226.95
M106 S229.5
G1 X167.772 Y162.735 E.01068
M106 S226.95
M106 S229.5
G1 X167.71 Y162.564 E.0054
M106 S226.95
M106 S229.5
G1 F1800
G1 X167.632 Y162.329 E.00738
M106 S226.95
M106 S229.5
G1 F1680
G1 X167.531 Y161.983 E.01075
M106 S226.95
M106 S229.5
G1 F1560
G1 X167.443 Y161.614 E.01128
M106 S226.95
M106 S229.5
G1 F1320
G1 X167.376 Y161.261 E.01071
M106 S226.95
M106 S229.5
G1 F1200
G1 X167.326 Y160.906 E.01068
M106 S226.95
M106 S229.5
G1 F1080
G1 X167.299 Y160.648 E.00772
M106 S226.95
M106 S229.5
G1 F960
G1 X167.286 Y160.466 E.00544
M106 S226.95
M106 S229.5
G1 F840
G1 X167.273 Y160.099 E.01093
M106 S226.95
M106 S229.5
G1 F600
G1 X167.277 Y159.74 E.01069
M106 S226.95
M106 S229.5
G1 X167.297 Y159.384 E.01063
M106 S226.95
M106 S229.5
G3 X168.159 Y156.176 I8.04 J.441 E.09965
M106 S226.95
M106 S229.5
G1 X168.245 Y156.013 E.00549
M106 S226.95
M106 S229.5
G3 X169.817 Y153.993 I7.34 J4.092 E.07654
M106 S226.95
M106 S229.5
G3 X170.238 Y153.63 I5.391 J5.826 E.01655
M106 S226.95
M106 S229.5
G1 X170.532 Y153.405 E.01104
M106 S226.95
M106 S229.5
G1 F720
G1 X170.837 Y153.194 E.01104
M106 S226.95
M106 S229.5
G1 F840
G1 X170.995 Y153.092 E.0056
M106 S226.95
M106 S229.5
G1 F960
G1 X171.234 Y152.948 E.00831
M106 S226.95
M106 S229.5
G1 F1080
G1 X171.56 Y152.769 E.01108
M106 S226.95
M106 S229.5
G1 F1200
G1 X171.895 Y152.605 E.01112
M106 S226.95
M106 S229.5
G1 F1440
G1 X172.239 Y152.456 E.01115
M106 S226.95
M106 S229.5
G1 F1560
G1 X172.589 Y152.324 E.01116
M106 S226.95
M106 S229.5
G1 F1680
G1 X172.946 Y152.207 E.01117
M106 S226.95
M106 S229.5
G1 F1844
G1 X173.308 Y152.108 E.01119
M106 S226.95
M106 S229.5
G1 X173.675 Y152.025 E.0112
M106 S226.95
M106 S229.5
G1 X174.046 Y151.959 E.01122
M106 S226.95
M106 S229.5
G1 X174.42 Y151.911 E.01125
M106 S226.95
M106 S229.5
G1 X174.796 Y151.88 E.01124
M106 S226.95
M106 S229.5
G1 X174.987 Y151.871 E.00568
M106 S226.95
M106 S229.5
G1 X175.248 Y151.866 E.00777
M106 S226.95
M106 S229.5
G1 X175.65 Y151.874 E.01199
M106 S226.95
G1 X176.008 Y151.899 E.01068
G1 X176.486 Y151.956 E.01433
G1 X176.878 Y152.034 E.01191
G1 X177.25 Y152.108 E.01129
G1 X177.714 Y152.23 E.0143
G3 X179.392 Y152.987 I-2.318 J7.376 E.05495
; COOLING_NODE: 0
; WIPE_START
G1 F9547.055
M204 S8000
G1 X180.174 Y153.528 E-.36129
G1 X180.684 Y153.971 E-.25675
G1 X180.95 Y154.233 E-.14196
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X173.686 Y151.889 Z2.6 F60000
G1 X172.509 Y151.509 Z2.6
G1 Z2.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1863
M204 S8000
G2 X166.5 Y159.323 I2.688 J8.285 E.33692
G2 X175.456 Y168.523 I8.515 J.67 E.46721
G2 X183.219 Y163.274 I-.223 J-8.694 E.31821
G1 X183.442 Y163.368 E.00778
G3 X172.437 Y151.279 I-8.441 J-3.369 E1.1827
G1 X172.491 Y151.452 E.00583
; COOLING_NODE: 0
; WIPE_START
G1 F8843.478
G1 X171.938 Y151.715 E-.23261
G1 X171.192 Y152.059 E-.31228
G1 X170.701 Y152.34 E-.21511
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X178.271 Y153.315 Z2.6 F60000
G1 X182.214 Y153.822 Z2.6
G1 Z2.2
G1 E.8 F1800
G1 F1863
M204 S8000
G1 X182.215 Y153.835 E.00041
G3 X174.752 Y150.505 I-7.224 J6.163 E1.647
G3 X175.172 Y150.504 I.236 J8.857 E.0135
G3 X181.65 Y153.229 I-.181 J9.494 E.23149
G1 X182.172 Y153.779 E.0244
; COOLING_NODE: 1
M204 S250
M73 P79 R2
G1 X182.5 Y153.555 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1844
M204 S5000
G1 X182.514 Y153.581 E.00089
G3 X174.741 Y150.113 I-7.523 J6.417 E1.58854
G3 X175.18 Y150.112 I.248 J9.277 E.01308
G3 X181.926 Y152.95 I-.19 J9.886 E.2233
G1 X182.459 Y153.512 E.02305
; WIPE_START
G1 F9547.055
M204 S8000
G1 X182.514 Y153.581 E-.03387
G1 X182.846 Y153.979 E-.19687
G1 X183.151 Y154.399 E-.19725
G1 X183.608 Y155.13 E-.3275
G1 X183.613 Y155.14 E-.00451
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X183.547 Y156.969 Z2.6 F60000
G1 Z2.2
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.462766
G1 F1863
M204 S8000
G1 X183.532 Y156.923 E.0016
G2 X178.618 Y151.688 I-8.373 J2.936 E.24514
; LINE_WIDTH: 0.523399
G1 X178.352 Y151.581 E.0109
G2 X177.038 Y151.192 I-3.254 J8.562 E.05206
; LINE_WIDTH: 0.571629
G2 X175.553 Y150.999 I-1.886 J8.748 E.06261
; LINE_WIDTH: 0.619841
G1 X175.243 Y150.99 E.0141
G2 X173.903 Y151.074 I-.102 J9.105 E.06124
; LINE_WIDTH: 0.662867
G2 X172.666 Y151.331 I1.512 J10.411 E.0619
; WIPE_START
G1 F5806.949
G1 X173.213 Y151.198 E-.33813
G1 X173.903 Y151.074 E-.42187
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X167.676 Y155.487 Z2.6 F60000
G1 X167.177 Y155.84 Z2.6
G1 Z2.2
G1 E.8 F1800
; LINE_WIDTH: 0.118675
G1 F1863
M204 S8000
G1 X167.111 Y155.97 E.00087
G2 X166.62 Y157.193 I8.43 J4.096 E.00789
; LINE_WIDTH: 0.165878
M73 P79 R1
G2 X166.279 Y158.728 I8.646 J2.726 E.01529
; LINE_WIDTH: 0.197358
G2 X176.152 Y168.748 I8.75 J1.253 E.19846
G2 X176.767 Y168.654 I-.897 J-7.966 E.00759
; LINE_WIDTH: 0.127451
G1 X176.904 Y168.628 E.00093
G2 X178.178 Y168.266 I-1.869 J-8.99 E.00885
; LINE_WIDTH: 0.0995984
G1 X178.489 Y168.145 E.00149
; WIPE_START
G1 F15000
G1 X178.178 Y168.266 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X183.708 Y163.246 Z2.6 F60000
G1 Z2.2
G1 E.8 F1800
; LINE_WIDTH: 0.654154
G1 F1863
M204 S8000
G1 X183.518 Y162.835 E.02184
G1 X183.582 Y162.645 E.00969
G2 X183.902 Y161.334 I-9.506 J-3.016 E.06521
; LINE_WIDTH: 0.604621
G1 X183.926 Y161.179 E.00699
G2 X184.022 Y159.769 I-8.912 J-1.314 E.06276
; LINE_WIDTH: 0.561229
G1 X184.019 Y159.616 E.00626
G2 X183.921 Y158.513 I-8.631 J.214 E.04535
; LINE_WIDTH: 0.517776
G1 X183.877 Y158.248 E.01008
G2 X183.547 Y156.969 I-8.879 J1.605 E.04962
; CHANGE_LAYER
; Z_HEIGHT: 2.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F7581.248
G1 X183.744 Y157.636 E-.33233
G1 X183.877 Y158.248 E-.29936
G1 X183.921 Y158.513 E-.12831
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 12/19
; update layer progress
M73 L12
M991 S0 P11 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z2.6 I-1.187 J-.269 P1  F60000
G1 X182.67 Y164.034 Z2.6
G1 Z2.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1840
M204 S8000
G1 X182.462 Y164.449 E.01492
G3 X178.451 Y167.849 I-6.987 J-4.177 E.17215
G3 X167.414 Y162.917 I-3.169 J-7.725 E.43469
G3 X169.863 Y153.711 I7.616 J-2.902 E.32715
G3 X174.798 Y151.833 I5.432 J6.851 E.17248
G3 X183.169 Y157.549 I.441 J8.341 E.35022
M73 P80 R1
G3 X183.183 Y162.889 I-7.828 J2.692 E.17486
G3 X182.887 Y163.637 I-7.708 J-2.617 E.02587
G1 X182.699 Y163.981 E.01262
; COOLING_NODE: 0
M204 S250
G1 X182.339 Y163.86 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1840
M204 S5000
G3 X178.656 Y167.334 I-6.851 J-3.573 E.15365
G3 X167.876 Y163.04 I-3.368 J-7.222 E.38715
G3 X167.537 Y158.002 I7.398 J-3.028 E.15302
G1 X167.602 Y157.767 E.00726
G1 X167.726 Y157.392 E.01176
G1 X167.855 Y157.056 E.01075
M106 S229.5
G1 X167.947 Y156.843 E.0069
M106 S226.95
M106 S229.5
G1 X168.023 Y156.678 E.0054
M106 S226.95
M106 S229.5
G1 X168.184 Y156.358 E.01068
M106 S226.95
M106 S229.5
G1 X168.36 Y156.047 E.01066
M106 S226.95
M106 S229.5
G1 X168.455 Y155.892 E.00541
M106 S226.95
M106 S229.5
G1 X168.579 Y155.7 E.00682
M106 S226.95
M106 S229.5
G1 X168.81 Y155.374 E.01188
M106 S226.95
M106 S229.5
G3 X169.147 Y154.954 I6.189 J4.626 E.01607
M106 S226.95
M106 S229.5
G1 X169.305 Y154.776 E.00706
M106 S226.95
M106 S229.5
G1 X169.555 Y154.516 E.01075
M106 S226.95
M106 S229.5
G1 X169.838 Y154.249 E.0116
M106 S226.95
M106 S229.5
G1 X170.111 Y154.015 E.01071
M106 S226.95
M106 S229.5
G1 X170.394 Y153.795 E.01069
M106 S226.95
M106 S229.5
G1 F1800
G1 X170.596 Y153.65 E.0074
M106 S226.95
M106 S229.5
G1 F1680
G1 X170.747 Y153.548 E.00543
M106 S226.95
M106 S229.5
G1 F1560
G1 X171.068 Y153.347 E.01125
M106 S226.95
M106 S229.5
G1 F1440
G1 X171.38 Y153.172 E.01067
M106 S226.95
M106 S229.5
G1 F1320
G1 X171.542 Y153.089 E.0054
M106 S226.95
M106 S229.5
G1 F1200
G1 X171.774 Y152.978 E.00767
M106 S226.95
M106 S229.5
G1 F960
G1 X172.105 Y152.835 E.01076
M106 S226.95
M106 S229.5
G1 F840
G1 X172.45 Y152.705 E.01095
M106 S226.95
M106 S229.5
G1 F720
G1 X172.622 Y152.647 E.00541
M106 S226.95
M106 S229.5
G1 F600
G1 X172.876 Y152.57 E.00791
M106 S226.95
M106 S229.5
G1 X173.224 Y152.479 E.01072
M106 S226.95
M106 S229.5
G1 X173.748 Y152.363 E.016
M106 S226.95
M106 S229.5
G3 X174.821 Y152.225 I1.651 J8.572 E.03224
M106 S226.95
M106 S229.5
G3 X175.454 Y152.214 I.455 J7.825 E.01888
M106 S226.95
M106 S229.5
G1 X175.638 Y152.22 E.00548
M106 S226.95
M106 S229.5
G3 X176.99 Y152.402 I-.783 J10.92 E.04066
M106 S226.95
M106 S229.5
G1 X177.17 Y152.445 E.0055
M106 S226.95
M106 S229.5
G3 X178.469 Y152.893 I-2.935 J10.619 E.04097
M106 S226.95
M106 S229.5
G1 X178.639 Y152.971 E.00554
M106 S226.95
M106 S229.5
G3 X179.289 Y153.317 I-3.388 J7.146 E.02197
M106 S226.95
M106 S229.5
G1 X179.602 Y153.513 E.01099
M106 S226.95
M106 S229.5
G1 X179.757 Y153.618 E.00557
M106 S226.95
M106 S229.5
G1 X179.941 Y153.749 E.00675
M106 S226.95
M106 S229.5
G1 F720
G1 X180.13 Y153.892 E.00704
M106 S226.95
M106 S229.5
G1 F840
G1 X180.276 Y154.01 E.0056
M106 S226.95
M106 S229.5
G1 F960
G1 X180.557 Y154.251 E.01103
M106 S226.95
M106 S229.5
G1 F1080
G1 X180.828 Y154.508 E.01112
M106 S226.95
M106 S229.5
G1 F1200
G1 X181.086 Y154.776 E.01107
M106 S226.95
M106 S229.5
G1 F1440
G3 X181.368 Y155.099 I-5.81 J5.346 E.01277
M106 S226.95
M106 S229.5
G1 F1560
G1 X181.51 Y155.276 E.00678
M106 S226.95
M106 S229.5
G1 F1680
G1 X181.624 Y155.426 E.00561
M106 S226.95
M106 S229.5
G1 F1800
G1 X181.84 Y155.731 E.01111
M106 S226.95
M106 S229.5
G1 F1840
G1 X181.944 Y155.889 E.00565
M106 S226.95
M106 S229.5
G1 X182.074 Y156.101 E.00739
M106 S226.95
M106 S229.5
G1 X182.185 Y156.292 E.0066
M106 S226.95
M106 S229.5
G1 X182.276 Y156.459 E.00566
M106 S226.95
M106 S229.5
G1 X182.444 Y156.796 E.01122
M106 S226.95
M106 S229.5
G1 X182.597 Y157.141 E.01124
M106 S226.95
M106 S229.5
G1 X182.734 Y157.492 E.01124
M106 S226.95
M106 S229.5
G1 X182.797 Y157.673 E.0057
M106 S226.95
M106 S229.5
G1 X182.876 Y157.923 E.00782
M106 S226.95
G1 X182.982 Y158.31 E.01195
G1 X183.021 Y158.485 E.00532
G1 X183.13 Y159.057 E.01736
G1 X183.178 Y159.436 E.01138
G1 X183.2 Y159.835 E.01191
G1 X183.227 Y160.2 E.01088
G3 X182.677 Y163.12 I-7.705 J.058 E.08906
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

G3 X182.366 Y163.806 I-7.189 J-2.833 E.02246
; COOLING_NODE: 0
; WIPE_START
G1 F9547.055
M204 S8000
G1 X181.914 Y164.567 E-.33615
G1 X181.46 Y165.19 E-.29296
G1 X181.235 Y165.45 E-.13089
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X181.688 Y157.831 Z2.8 F60000
G1 X181.91 Y154.093 Z2.8
G1 Z2.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1840
M204 S8000
G3 X182.497 Y154.858 I-6.913 J5.915 E.03103
G1 X182.304 Y154.999 E.0077
G2 X173.037 Y151.702 I-7.046 J5.131 E.33606
G2 X167.029 Y163.051 I1.976 J8.311 E.46723
G2 X174.469 Y168.834 I8.211 J-2.885 E.32019
G1 X174.449 Y169.074 E.00775
G3 X175.172 Y150.911 I.551 J-9.074 E.90613
G3 X181.871 Y154.048 I-.175 J9.097 E.24494
; COOLING_NODE: 0
M204 S10000
G1 X182.215 Y153.835 F60000
G1 F1840
M204 S8000
M73 P81 R1
G3 X174.752 Y150.505 I-7.224 J6.164 E1.647
G3 X175.181 Y150.504 I.237 J8.926 E.0138
G3 X182.176 Y153.789 I-.19 J9.494 E.25592
; COOLING_NODE: 1
M204 S250
G1 X182.505 Y153.561 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1840
M204 S5000
G1 X182.514 Y153.581 E.00066
G3 X174.741 Y150.113 I-7.523 J6.417 E1.58853
G3 X175.19 Y150.112 I.249 J9.366 E.01336
G3 X181.926 Y152.95 I-.198 J9.886 E.22302
G1 X182.464 Y153.517 E.02329
; WIPE_START
G1 F9547.055
M204 S8000
G1 X182.514 Y153.581 E-.03083
G1 X182.846 Y153.979 E-.1966
G1 X183.15 Y154.397 E-.19674
G1 X183.432 Y154.832 E-.19697
G1 X183.615 Y155.149 E-.13886
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X182.518 Y155.095 Z2.8 F60000
G1 Z2.4
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.652441
G1 F1840
M204 S8000
G1 X182.713 Y155.405 E.01762
G3 X183.434 Y156.848 I-7.552 J4.674 E.07778
; LINE_WIDTH: 0.601713
G3 X183.843 Y158.196 I-8.55 J3.329 E.06224
; LINE_WIDTH: 0.556578
G1 X183.909 Y158.52 E.01344
G3 X184.047 Y159.768 I-10.001 J1.74 E.05095
; LINE_WIDTH: 0.508086
G1 X184.047 Y159.775 E.00027
G3 X183.973 Y161.343 I-9.157 J.351 E.05775
; LINE_WIDTH: 0.462222
G1 X183.94 Y161.564 E.0074
G3 X180.314 Y167.343 I-8.746 J-1.461 E.23196
; LINE_WIDTH: 0.526522
G1 X180.105 Y167.486 E.00966
G3 X178.894 Y168.158 I-4.999 J-7.588 E.05297
; LINE_WIDTH: 0.575504
G1 X178.598 Y168.288 E.01356
G3 X177.423 Y168.684 I-3.708 J-9.051 E.05221
; LINE_WIDTH: 0.620986
G3 X176.023 Y168.935 I-2.322 J-8.92 E.06504
; LINE_WIDTH: 0.659172
G1 X175.769 Y168.957 E.01238
G3 X174.978 Y168.978 I-.61 J-8.346 E.03857
; LINE_WIDTH: 0.657112
G1 X174.962 Y168.961 E.00111
; LINE_WIDTH: 0.623795
G1 X174.947 Y168.944 E.00105
; LINE_WIDTH: 0.593708
G1 X174.688 Y168.652 E.01697
; WIPE_START
G1 F6536.094
G1 X174.947 Y168.944 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X168.304 Y165.803 Z2.8 F60000
G1 Z2.4
G1 E.8 F1800
; LINE_WIDTH: 0.103226
G1 F1840
M204 S8000
G3 X168.053 Y165.489 I9.93 J-8.21 E.00192
; LINE_WIDTH: 0.131226
G3 X167.365 Y164.446 I7.292 J-5.555 E.00872
G1 X167.271 Y164.271 E.00139
; LINE_WIDTH: 0.197279
G1 X167.098 Y163.931 E.00466
G3 X173.536 Y151.308 I7.944 J-3.902 E.20033
G1 X173.854 Y151.256 E.00392
; LINE_WIDTH: 0.159233
G3 X175.166 Y151.162 I1.279 J8.622 E.0121
; LINE_WIDTH: 0.117066
G3 X176.509 Y151.269 I-.046 J9.075 E.0079
; CHANGE_LAYER
; Z_HEIGHT: 2.6
; LAYER_HEIGHT: 0.2
; WIPE_START
M73 P82 R1
G1 F15000
G1 X175.854 Y151.192 E-.37197
G1 X175.166 Y151.162 E-.38803
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 13/19
; update layer progress
M73 L13
M991 S0 P12 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z2.8 I-1.182 J-.289 P1  F60000
G1 X171.104 Y167.754 Z2.8
G1 Z2.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1850
M204 S8000
G1 X170.703 Y167.518 E.01494
G3 X168.852 Y165.993 I4.173 J-6.954 E.07743
G3 X169.605 Y153.905 I6.135 J-5.685 E.43549
G3 X174.753 Y151.884 I5.489 J6.413 E.18121
G3 X181.748 Y155.484 I.236 J8.138 E.26403
G3 X180 Y166.902 I-6.864 J4.792 E.40989
G3 X174.662 Y168.672 I-5.109 J-6.473 E.18455
G3 X171.16 Y167.773 I.214 J-8.107 E.11726
; COOLING_NODE: 0
M204 S250
G1 X171.304 Y167.406 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1846
M204 S5000
G3 X169.141 Y165.729 I3.572 J-6.842 E.08197
G3 X169.853 Y154.209 I5.846 J-5.421 E.38441
G3 X174.14 Y152.325 I5.243 J6.114 E.14152
G1 X174.621 Y152.282 E.01438
G1 X174.766 Y152.276 E.00433
G1 X174.948 Y152.272 E.00541
G1 X175.342 Y152.28 E.01174
G1 X175.702 Y152.304 E.01076
M106 S229.5
G1 X175.932 Y152.329 E.00688
M106 S226.95
M106 S229.5
G1 X176.111 Y152.353 E.0054
M106 S226.95
M106 S229.5
G1 X176.464 Y152.412 E.01066
M106 S226.95
M106 S229.5
G1 X176.814 Y152.488 E.01067
M106 S226.95
M106 S229.5
G1 X176.989 Y152.533 E.0054
M106 S226.95
M106 S229.5
G1 X177.211 Y152.595 E.00686
M106 S226.95
M106 S229.5
G1 X177.589 Y152.719 E.01185
M106 S226.95
M106 S229.5
G1 X177.925 Y152.847 E.01072
M106 S226.95
M106 S229.5
G1 X178.253 Y152.99 E.01065
M106 S226.95
M106 S229.5
G1 X178.417 Y153.069 E.00541
M106 S226.95
M106 S229.5
G1 X178.631 Y153.178 E.00716
M106 S226.95
M106 S229.5
G1 X178.969 Y153.369 E.01155
M106 S226.95
M106 S229.5
G1 X179.273 Y153.561 E.01071
M106 S226.95
M106 S229.5
G1 X179.566 Y153.765 E.01065
M106 S226.95
M106 S229.5
G1 F1800
G1 X179.711 Y153.874 E.0054
M106 S226.95
M106 S229.5
G1 F1680
G1 X179.907 Y154.03 E.00747
M106 S226.95
M106 S229.5
G1 F1440
G1 X180.193 Y154.277 E.01124
M106 S226.95
M106 S229.5
G1 F1320
G1 X180.453 Y154.524 E.01067
M106 S226.95
M106 S229.5
G1 F1200
G1 X180.58 Y154.653 E.0054
M106 S226.95
M106 S229.5
G1 F1080
G1 X180.755 Y154.843 E.0077
M106 S226.95
M106 S229.5
G1 F960
G1 X180.99 Y155.117 E.01076
M106 S226.95
M106 S229.5
G1 F840
G1 X181.215 Y155.408 E.01095
M106 S226.95
M106 S229.5
G1 F600
G1 X181.422 Y155.702 E.01072
M106 S226.95
M106 S229.5
G1 X181.613 Y156.002 E.0106
M106 S226.95
M106 S229.5
G1 X181.84 Y156.386 E.01327
M106 S226.95
M106 S229.5
G3 X182.85 Y159.656 I-6.803 J3.893 E.10277
M106 S226.95
M106 S229.5
G1 X182.863 Y159.84 E.00549
M106 S226.95
M106 S229.5
G3 X182.819 Y161.214 I-11.444 J.322 E.04098
M106 S226.95
M106 S229.5
G1 X182.795 Y161.398 E.00554
M106 S226.95
M106 S229.5
G3 X182.697 Y161.943 I-7.848 J-1.128 E.0165
M106 S226.95
M106 S229.5
G3 X182.586 Y162.392 I-8 J-1.734 E.01376
M106 S226.95
M106 S229.5
G3 X182.419 Y162.922 I-7.663 J-2.126 E.01657
M106 S226.95
M106 S229.5
G1 F840
G1 X182.286 Y163.27 E.01109
M106 S226.95
M106 S229.5
G1 F960
G1 X182.138 Y163.611 E.01106
M106 S226.95
M106 S229.5
G1 F1080
G1 X182.057 Y163.78 E.00559
M106 S226.95
M106 S229.5
G1 F1200
G1 X181.929 Y164.029 E.00834
M106 S226.95
M106 S229.5
G1 F1320
G1 X181.745 Y164.354 E.01113
M106 S226.95
M106 S229.5
G1 F1560
G1 X181.545 Y164.671 E.01115
M106 S226.95
M106 S229.5
G1 F1680
G1 X181.331 Y164.978 E.01117
M106 S226.95
M106 S229.5
G1 F1800
G1 X181.102 Y165.276 E.01117
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

M106 S226.95
M106 S229.5
G1 F1846
G1 X180.859 Y165.563 E.0112
M106 S226.95
M106 S229.5
G1 X180.603 Y165.839 E.01122
M106 S226.95
M106 S229.5
G1 X180.334 Y166.103 E.01124
M106 S226.95
M106 S229.5
G1 X180.052 Y166.355 E.01126
M106 S226.95
M106 S229.5
G1 X179.759 Y166.593 E.01125
M106 S226.95
M106 S229.5
G1 X179.606 Y166.708 E.00568
M106 S226.95
M106 S229.5
G1 X179.392 Y166.86 E.00782
M106 S226.95
G1 X179.056 Y167.08 E.01196
G1 X178.917 Y167.162 E.0048
G1 X178.567 Y167.354 E.01191
G1 X178.391 Y167.45 E.00597
G1 X178.045 Y167.612 E.01137
G1 X177.672 Y167.755 E.01191
G1 X177.332 Y167.89 E.01087
G3 X174.675 Y168.28 I-2.443 J-7.405 E.0804
G3 X171.358 Y167.433 I.202 J-7.716 E.10284
; COOLING_NODE: 0
; WIPE_START
G1 F9547.055
M204 S8000
G1 X170.909 Y167.188 E-.19434
G1 X170.274 Y166.757 E-.29174
G1 X169.718 Y166.298 E-.27392
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.105 Y160.89 Z3 F60000
G1 X181.892 Y154.077 Z3
G1 Z2.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1850
M204 S8000
G1 X182.208 Y154.462 E.01602
G3 X182.205 Y165.544 I-7.209 J5.539 E.38318
G1 X182.009 Y165.403 E.00776
G2 X182.295 Y155.585 I-7.052 J-5.119 E.33556
G2 X169.651 Y153.351 I-7.302 J4.431 E.46722
G2 X166.418 Y162.167 I5.273 J6.934 E.3189
G1 X166.186 Y162.216 E.00763
G3 X175.181 Y150.911 I8.819 J-2.214 E.53686
G3 X181.811 Y153.98 I-.182 J9.09 E.24176
M73 P83 R1
G1 X181.853 Y154.031 E.00214
; COOLING_NODE: 0
M204 S10000
G1 X182.215 Y153.835 F60000
G1 F1850
M204 S8000
G3 X174.752 Y150.505 I-7.224 J6.164 E1.647
G3 X175.19 Y150.504 I.238 J8.97 E.01409
G3 X182.176 Y153.789 I-.199 J9.494 E.25563
; COOLING_NODE: 1
M204 S250
G1 X182.511 Y153.567 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1846
M204 S5000
G1 X182.515 Y153.581 E.00044
G3 X174.741 Y150.113 I-7.523 J6.417 E1.58852
G3 X175.199 Y150.112 I.249 J9.402 E.01363
G3 X181.927 Y152.95 I-.207 J9.886 E.22276
G1 X182.47 Y153.523 E.02352
; WIPE_START
G1 F9547.055
M204 S8000
G1 X182.515 Y153.581 E-.02792
G1 X182.845 Y153.978 E-.19642
G1 X183.15 Y154.398 E-.197
G1 X183.433 Y154.833 E-.19704
G1 X183.619 Y155.155 E-.14163
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X182.747 Y155.801 Z3 F60000
G1 Z2.6
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.19779
G1 F1850
M204 S8000
G2 X168.79 Y153.729 I-7.763 J4.251 E.19977
G2 X168.597 Y153.92 I7.16 J7.408 E.00332
; LINE_WIDTH: 0.131121
G1 X168.5 Y154.019 E.00097
G2 X167.614 Y155.117 I6.728 J6.34 E.00984
; LINE_WIDTH: 0.102423
G1 X167.433 Y155.392 E.00155
; WIPE_START
G1 F15000
G1 X167.614 Y155.117 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X166.664 Y162.322 Z3 F60000
G1 Z2.6
G1 E.8 F1800
; LINE_WIDTH: 0.659503
G1 F1850
M204 S8000
G1 X166.436 Y162.695 E.02126
G2 X166.833 Y163.769 I8.997 J-2.709 E.05581
M73 P84 R1
G1 X166.948 Y164.016 E.01327
; LINE_WIDTH: 0.61039
G2 X167.702 Y165.304 I8.371 J-4.041 E.06696
; LINE_WIDTH: 0.562522
G2 X168.775 Y166.565 I7.472 J-5.268 E.06805
; LINE_WIDTH: 0.517086
G2 X169.776 Y167.411 I6.227 J-6.351 E.04916
; LINE_WIDTH: 0.46253
G2 X176.565 Y168.936 I5.181 J-7.192 E.23701
G1 X176.78 Y168.892 E.00726
; LINE_WIDTH: 0.515054
G2 X177.989 Y168.542 I-1.879 J-8.749 E.04697
G1 X178.167 Y168.474 E.00713
; LINE_WIDTH: 0.559971
G2 X179.506 Y167.818 I-3.299 J-8.433 E.06097
; LINE_WIDTH: 0.605318
G2 X180.621 Y167.033 I-4.563 J-7.662 E.06062
G1 X180.728 Y166.943 E.00621
; LINE_WIDTH: 0.65153
G2 X181.784 Y165.881 I-5.759 J-6.781 E.0721
G1 X181.781 Y165.855 E.00127
; LINE_WIDTH: 0.615855
G1 X181.777 Y165.828 E.00119
; LINE_WIDTH: 0.583156
G1 X181.726 Y165.451 E.01625
; WIPE_START
G1 F6663.759
G1 X181.777 Y165.828 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X183.774 Y158.769 Z3 F60000
G1 Z2.6
G1 E.8 F1800
; LINE_WIDTH: 0.121212
G1 F1850
M204 S8000
G2 X183.363 Y157.152 I-9.013 J1.431 E.01034
; LINE_WIDTH: 0.170793
G2 X182.747 Y155.801 I-8.39 J3.01 E.01501
; CHANGE_LAYER
; Z_HEIGHT: 2.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F15000
G1 X183.094 Y156.489 E-.39432
G1 X183.363 Y157.152 E-.36568
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 14/19
; update layer progress
M73 L14
M991 S0 P13 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z3 I-.421 J-1.142 P1  F60000
G1 X166.94 Y163.213 Z3
G1 Z2.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1852
M204 S8000
G1 X166.939 Y163.186 E.00085
G3 X166.355 Y159.234 I7.581 J-3.139 E.12976
G3 X174.409 Y151.715 I8.406 J.931 E.38587
G3 X179.303 Y153.099 I.303 J8.275 E.16622
G3 X182.765 Y162.375 I-4.354 J6.909 E.34207
G3 X179.32 Y166.965 I-8.347 J-2.677 E.18801
G3 X167.296 Y163.938 I-4.619 J-7.045 E.44804
G1 X166.967 Y163.267 E.02405
; COOLING_NODE: 0
M204 S250
G1 X167.303 Y163.036 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1850
M204 S5000
G3 X166.746 Y159.269 I7.171 J-2.984 E.11458
G3 X174.423 Y152.107 I8.016 J.896 E.34054
G3 X178.856 Y153.277 I.303 J7.834 E.13859
G3 X181.936 Y156.608 I-4.146 J6.921 E.13698
G1 X182.035 Y156.819 E.00695
G1 X182.195 Y157.186 E.01191
G1 X182.25 Y157.325 E.00444
G1 X182.376 Y157.696 E.0117
G1 X182.443 Y157.922 E.007
G1 X182.49 Y158.097 E.0054
M106 S229.5
G1 X182.57 Y158.446 E.01067
M106 S226.95
M106 S229.5
G1 X182.634 Y158.798 E.01067
M106 S226.95
M106 S229.5
G1 X182.66 Y158.977 E.0054
M106 S226.95
M106 S229.5
G1 X182.686 Y159.201 E.0067
M106 S226.95
M106 S229.5
G1 X182.706 Y159.423 E.00666
M106 S226.95
M106 S229.5
G1 X182.718 Y159.605 E.00541
M106 S226.95
M106 S229.5
G1 X182.728 Y159.961 E.01063
M106 S226.95
M106 S229.5
G3 X182.719 Y160.376 I-7.747 J.038 E.01236
M106 S226.95
M106 S229.5
G1 X182.689 Y160.769 E.01173
M106 S226.95
M106 S229.5
G1 X182.645 Y161.125 E.01067
M106 S226.95
M106 S229.5
G1 X182.617 Y161.304 E.00541
M106 S226.95
M106 S229.5
G1 X182.572 Y161.541 E.00719
M106 S226.95
M106 S229.5
G1 X182.486 Y161.918 E.01151
M106 S226.95
M106 S229.5
G1 X182.389 Y162.263 E.01067
M106 S226.95
M106 S229.5
G1 F1800
G1 X182.334 Y162.436 E.00541
M106 S226.95
M106 S229.5
G1 F1680
G1 X182.251 Y162.671 E.00743
M106 S226.95
M106 S229.5
G1 F1560
G1 X182.112 Y163.022 E.01123
M106 S226.95
M106 S229.5
G1 F1440
G1 X182.039 Y163.188 E.00541
M106 S226.95
M106 S229.5
G1 F1320
G1 X181.931 Y163.418 E.00759
M106 S226.95
M106 S229.5
G1 F1200
G1 X181.763 Y163.738 E.01075
M106 S226.95
M106 S229.5
G1 F1080
G1 X181.576 Y164.059 E.01107
M106 S226.95
M106 S229.5
G1 F840
G1 X181.38 Y164.36 E.0107
M106 S226.95
M106 S229.5
G1 F720
G1 X181.17 Y164.652 E.0107
M106 S226.95
M106 S229.5
G1 F600
G1 X180.947 Y164.935 E.01072
M106 S226.95
M106 S229.5
G1 X180.538 Y165.402 E.01851
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

M106 S226.95
M106 S229.5
G1 X180.291 Y165.663 E.01069
M106 S226.95
M106 S229.5
G1 X180.157 Y165.794 E.00559
M106 S226.95
M106 S229.5
G3 X178.463 Y167.023 I-5.997 J-6.482 E.06248
M106 S226.95
M106 S229.5
G3 X178.069 Y167.221 I-3.69 J-6.86 E.01312
M106 S226.95
M106 S229.5
G3 X177.133 Y167.587 I-3.761 J-8.233 E.02996
M106 S226.95
M106 S229.5
G1 X176.956 Y167.641 E.00553
M106 S226.95
M106 S229.5
G3 X175.511 Y167.922 I-2.731 J-10.181 E.04387
M106 S226.95
M106 S229.5
G1 X175.143 Y167.95 E.01101
M106 S226.95
M106 S229.5
G1 X174.771 Y167.961 E.01106
M106 S226.95
M106 S229.5
G1 F720
G1 X174.402 Y167.955 E.01101
M106 S226.95
M106 S229.5
G1 F840
G1 X174.214 Y167.945 E.0056
M106 S226.95
M106 S229.5
G1 F960
G3 X173.752 Y167.902 I.539 J-8.265 E.01384
M106 S226.95
M106 S229.5
G1 F1080
G1 X173.565 Y167.877 E.00559
M106 S226.95
M106 S229.5
G1 F1200
G1 X173.2 Y167.814 E.01106
M106 S226.95
M106 S229.5
G1 F1320
G1 X173.015 Y167.776 E.00561
M106 S226.95
M106 S229.5
G1 F1440
G1 X172.782 Y167.721 E.00714
M106 S226.95
M106 S229.5
G1 F1560
G1 X172.562 Y167.663 E.00679
M106 S226.95
M106 S229.5
G1 F1680
G1 X172.38 Y167.61 E.00563
M106 S226.95
M106 S229.5
G1 F1800
G1 X172.026 Y167.492 E.01113
M106 S226.95
M106 S229.5
G1 F1850
G1 X171.676 Y167.358 E.01117
M106 S226.95
M106 S229.5
G1 X171.501 Y167.283 E.00567
M106 S226.95
M106 S229.5
G1 X171.245 Y167.165 E.0084
M106 S226.95
M106 S229.5
G1 X170.909 Y166.994 E.01122
M106 S226.95
M106 S229.5
G1 X170.581 Y166.807 E.01126
M106 S226.95
M106 S229.5
G1 X170.262 Y166.604 E.01127
M106 S226.95
M106 S229.5
G1 X169.951 Y166.386 E.01131
M106 S226.95
G1 X169.651 Y166.154 E.01131
G1 X169.405 Y165.945 E.00961
G1 X169.118 Y165.666 E.01191
G1 X168.818 Y165.375 E.01245
G1 X168.51 Y165.025 E.0139
G1 X168.267 Y164.714 E.01174
G3 X167.833 Y164.081 I6.747 J-5.093 E.02287
G3 X167.326 Y163.091 I6.641 J-4.029 E.03316
; COOLING_NODE: 0
; WIPE_START
G1 F9547.055
M204 S8000
G1 X167.046 Y162.322 E-.31115
G1 X166.946 Y161.949 E-.14652
G1 X166.8 Y161.193 E-.29277
G1 X166.798 Y161.167 E-.00956
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X173.71 Y157.932 Z3.2 F60000
G1 X181.908 Y154.094 Z3.2
G1 Z2.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1852
M204 S8000
G3 X171.968 Y168.57 I-6.911 J5.905 E.76517
G1 X172.04 Y168.343 E.00767
G2 X181.562 Y165.446 I2.672 J-8.312 E.34052
G2 X179.531 Y152.761 I-6.603 J-5.448 E.46716
M73 P85 R1
G2 X170.21 Y152.559 I-4.821 J7.275 E.31629
G1 X170.086 Y152.351 E.00777
G3 X175.19 Y150.912 I4.933 J7.721 E.17301
G3 X181.869 Y154.049 I-.192 J9.088 E.24435
; COOLING_NODE: 0
M204 S10000
G1 X182.216 Y153.834 F60000
G1 F1852
M204 S8000
G3 X174.752 Y150.505 I-7.224 J6.164 E1.64699
G3 X175.199 Y150.505 I.239 J9.029 E.01438
G3 X182.176 Y153.789 I-.207 J9.494 E.25535
; COOLING_NODE: 1
M204 S250
G1 X182.516 Y153.572 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1850
M204 S5000
G1 X182.515 Y153.58 E.00025
G3 X174.741 Y150.113 I-7.522 J6.418 E1.58852
G3 X175.208 Y150.113 I.251 J9.468 E.01391
G3 X181.927 Y152.949 I-.216 J9.886 E.22248
G1 X182.475 Y153.529 E.02376
; WIPE_START
G1 F9547.055
M204 S8000
G1 X182.515 Y153.58 E-.0249
G1 X182.846 Y153.979 E-.19701
G1 X183.151 Y154.399 E-.19708
G1 X183.608 Y155.13 E-.32768
G1 X183.624 Y155.161 E-.01333
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X178.763 Y152.012 Z3.2 F60000
G1 Z2.8
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.130436
G1 F1852
M204 S8000
G1 X178.508 Y151.89 E.00195
M73 P86 R1
G2 X177.337 Y151.459 I-3.682 J8.183 E.00863
; LINE_WIDTH: 0.101945
G2 X177.047 Y151.38 I-3.454 J12.184 E.0014
; WIPE_START
G1 F15000
G1 X177.337 Y151.459 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X178.763 Y152.012 Z3.2 F60000
G1 Z2.8
G1 E.8 F1800
; LINE_WIDTH: 0.197753
G1 F1852
M204 S8000
G3 X179.173 Y152.225 I-3.187 J6.6 E.00565
G3 X181.335 Y166.127 I-4.214 J7.774 E.19896
; LINE_WIDTH: 0.166221
G3 X180.352 Y167.028 I-6.485 J-6.085 E.013
G1 X180.128 Y167.198 E.00274
; LINE_WIDTH: 0.118862
G3 X178.901 Y167.955 I-5.174 J-7.006 E.00866
; WIPE_START
G1 F15000
G1 X179.663 Y167.518 E-.46287
G1 X180.128 Y167.198 E-.29713
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.572 Y168.28 Z3.2 F60000
G1 X171.812 Y168.389 Z3.2
G1 Z2.8
G1 E.8 F1800
; LINE_WIDTH: 0.66207
G1 F1852
M204 S8000
G3 X171.341 Y168.201 I4.039 J-10.831 E.02481
G1 X170.571 Y167.828 E.04185
; LINE_WIDTH: 0.621804
G3 X169.438 Y167.094 I4.356 J-7.971 E.06179
G1 X169.427 Y167.086 E.00059
; LINE_WIDTH: 0.575995
G3 X168.203 Y165.96 I5.401 J-7.105 E.07014
; LINE_WIDTH: 0.524251
G3 X167.36 Y164.874 I6.759 J-6.108 E.05233
G1 X167.186 Y164.597 E.01242
; LINE_WIDTH: 0.463203
G3 X166.248 Y157.611 I7.58 J-4.574 E.2407
G1 X166.304 Y157.429 E.00631
; LINE_WIDTH: 0.517737
G3 X166.905 Y155.964 I8.712 J2.724 E.05946
; LINE_WIDTH: 0.562925
G3 X167.572 Y154.874 I8.376 J4.372 E.05253
G1 X167.626 Y154.799 E.0038
; LINE_WIDTH: 0.605794
G3 X168.445 Y153.827 I7.076 J5.13 E.05656
G1 X168.578 Y153.694 E.00839
; LINE_WIDTH: 0.652032
G3 X169.715 Y152.742 I6.535 J6.649 E.07142
G1 X170.137 Y152.835 E.02082
; CHANGE_LAYER
; Z_HEIGHT: 3
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F5910.245
G1 X169.715 Y152.742 E-.17158
G1 X169.066 Y153.244 E-.32537
G1 X168.578 Y153.694 E-.26306
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 15/19
; update layer progress
M73 L15
M991 S0 P14 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z3.2 I.502 J1.109 P1  F60000
G1 X173.549 Y151.445 Z3.2
G1 Z3
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1841
M204 S8000
G1 X173.574 Y151.451 E.00083
G3 X174.196 Y151.379 I1.271 J8.217 E.02013
G3 X176.979 Y151.663 I.51 J8.773 E.09033
G3 X182.835 Y162.155 I-2.135 J8.072 E.43127
G3 X175.4 Y168.11 I-7.842 J-2.172 E.32723
G3 X169.328 Y165.94 I-.312 J-8.707 E.2124
G3 X169.097 Y153.661 I5.668 J-6.248 E.44232
G3 X172.69 Y151.638 I5.748 J6.007 E.13398
G1 X173.491 Y151.458 E.0264
; COOLING_NODE: 0
M204 S250
G1 X173.636 Y151.838 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1841
M204 S5000
G3 X174.22 Y151.77 I1.21 J7.83 E.01753
G3 X176.506 Y151.95 I.424 J9.233 E.06846
G3 X182.559 Y161.695 I-1.671 J7.79 E.38147
G3 X180.245 Y165.668 I-7.799 J-1.883 E.1389
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

G1 X179.888 Y165.983 E.0142
G1 X179.674 Y166.154 E.00816
G1 X179.483 Y166.295 E.00706
G1 X179.334 Y166.398 E.00539
G1 X179.033 Y166.592 E.01066
M106 S229.5
G1 X178.723 Y166.772 E.01067
M106 S226.95
M106 S229.5
G1 X178.526 Y166.876 E.00664
M106 S226.95
M106 S229.5
G1 X178.364 Y166.957 E.0054
M106 S226.95
M106 S229.5
G1 X178.16 Y167.052 E.0067
M106 S226.95
M106 S229.5
G1 X177.993 Y167.124 E.00541
M106 S226.95
M106 S229.5
G1 X177.661 Y167.255 E.01066
M106 S226.95
M106 S229.5
G1 X177.321 Y167.371 E.01067
M106 S226.95
M106 S229.5
G1 X177.148 Y167.423 E.0054
M106 S226.95
M106 S229.5
G1 X176.922 Y167.485 E.00698
M106 S226.95
M106 S229.5
G1 X176.538 Y167.573 E.01171
M106 S226.95
M106 S229.5
G3 X176.006 Y167.662 I-1.535 J-7.56 E.01608
M106 S226.95
M106 S229.5
G1 X175.765 Y167.69 E.00721
M106 S226.95
M106 S229.5
G1 X175.38 Y167.718 E.0115
M106 S226.95
M106 S229.5
G1 X175.022 Y167.728 E.01067
M106 S226.95
M106 S229.5
G1 F1800
G1 X174.841 Y167.726 E.00541
M106 S226.95
M106 S229.5
G1 F1680
G1 X174.591 Y167.717 E.00744
M106 S226.95
M106 S229.5
G1 F1560
G1 X174.214 Y167.688 E.01126
M106 S226.95
M106 S229.5
G1 F1320
G1 X173.859 Y167.643 E.01066
M106 S226.95
M106 S229.5
G1 F1200
G3 X173.427 Y167.566 I1.146 J-7.677 E.01308
M106 S226.95
M106 S229.5
G1 F960
G1 X173.075 Y167.484 E.01076
M106 S226.95
M106 S229.5
G1 F840
G1 X172.727 Y167.386 E.01077
M106 S226.95
M106 S229.5
G1 F600
G1 X172.383 Y167.271 E.01078
M106 S226.95
M106 S229.5
G1 X172.045 Y167.14 E.01082
M106 S226.95
M106 S229.5
G3 X170.68 Y166.462 I4.524 J-10.807 E.04543
M106 S226.95
M106 S229.5
G1 X170.459 Y166.32 E.00783
M106 S226.95
M106 S229.5
G3 X169.311 Y165.386 I5.879 J-8.401 E.0441
M106 S226.95
M106 S229.5
G1 X169.132 Y165.204 E.00763
M106 S226.95
M106 S229.5
G3 X168.112 Y163.873 I6.005 J-5.655 E.05003
M106 S226.95
M106 S229.5
G1 X167.987 Y163.66 E.00735
M106 S226.95
M106 S229.5
G3 X167.58 Y162.833 I8.285 J-4.593 E.02746
M106 S226.95
M106 S229.5
G1 X167.509 Y162.66 E.00556
M106 S226.95
M106 S229.5
G1 X167.43 Y162.45 E.0067
M106 S226.95
M106 S229.5
G1 X167.352 Y162.225 E.00708
M106 S226.95
M106 S229.5
G1 F720
G3 X167.196 Y161.69 I7.578 J-2.492 E.01659
M106 S226.95
M106 S229.5
G1 F960
G1 X167.133 Y161.419 E.00831
M106 S226.95
M106 S229.5
G1 F1080
G1 X167.095 Y161.234 E.00562
M106 S226.95
M106 S229.5
G1 F1200
G1 X167.034 Y160.867 E.01107
M106 S226.95
M106 S229.5
G1 F1320
G1 X166.989 Y160.496 E.01113
M106 S226.95
M106 S229.5
G1 F1440
G1 X166.962 Y160.124 E.01111
M106 S226.95
M106 S229.5
G1 F1560
G1 X166.955 Y159.935 E.00563
M106 S226.95
M106 S229.5
G1 F1680
G1 X166.952 Y159.692 E.00724
M106 S226.95
M106 S229.5
G1 F1800
G1 X166.956 Y159.467 E.00669
M106 S226.95
M106 S229.5
G1 F1841
G1 X166.964 Y159.278 E.00564
M106 S226.95
M106 S229.5
G1 X166.994 Y158.904 E.01117
M106 S226.95
M106 S229.5
G1 X167.041 Y158.53 E.01122
M106 S226.95
M106 S229.5
G1 X167.105 Y158.159 E.01122
M106 S226.95
M106 S229.5
G1 X167.144 Y157.973 E.00566
M106 S226.95
M106 S229.5
G1 X167.204 Y157.722 E.00768
M106 S226.95
M106 S229.5
G1 X167.314 Y157.334 E.01203
M106 S226.95
M106 S229.5
G1 X167.435 Y156.974 E.0113
M106 S226.95
G1 X167.572 Y156.62 E.01131
G1 X167.608 Y156.536 E.00273
G1 X167.782 Y156.176 E.01191
G1 X167.942 Y155.846 E.0109
G1 X168.151 Y155.505 E.01191
G1 X168.394 Y155.116 E.01369
G3 X169.375 Y153.938 I6.897 J4.744 E.04572
G3 X173.577 Y151.848 I5.471 J5.731 E.1419
; COOLING_NODE: 0
; WIPE_START
G1 F9547.055
M204 S8000
G1 X174.22 Y151.77 E-.24634
G1 X174.61 Y151.756 E-.14808
M73 P87 R1
G1 X175.371 Y151.78 E-.28965
G1 X175.57 Y151.801 E-.07593
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X181.901 Y154.088 Z3.4 F60000
G1 Z3
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1841
M204 S8000
G1 X182.209 Y154.462 E.01558
G3 X165.912 Y159.79 I-7.209 J5.537 E1.11648
G1 X166.154 Y159.79 E.00778
G2 X171.74 Y167.879 I8.711 J-.042 E.3359
G2 X183.224 Y162.273 I3.255 J-7.897 E.46427
G2 X180.592 Y153.141 I-8.31 J-2.55 E.32334
G1 X180.749 Y152.958 E.00776
G1 X180.902 Y153.086 E.0064
G3 X181.811 Y153.98 I-5.902 J6.914 E.04104
G1 X181.863 Y154.042 E.00261
; COOLING_NODE: 0
M204 S10000
G1 X182.218 Y153.831 F60000
G1 F1841
M204 S8000
G1 X182.428 Y154.094 E.01081
G3 X174.914 Y150.502 I-7.438 J5.905 E1.6416
G1 X175.208 Y150.505 E.00945
G3 X182.109 Y153.714 I-.218 J9.495 E.2518
G1 X182.178 Y153.787 E.00324
; COOLING_NODE: 1
M204 S250
G1 X182.519 Y153.58 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1841
M204 S5000
G1 X182.734 Y153.849 E.01027
G3 X174.912 Y150.11 I-7.744 J6.151 E1.58349
G1 X175.217 Y150.113 E.00909
G3 X182.402 Y153.452 I-.227 J9.887 E.24281
G1 X182.478 Y153.535 E.00336
; WIPE_START
M73 P88 R1
G1 F9547.055
M204 S8000
G1 X182.734 Y153.849 E-.15377
G1 X183.247 Y154.541 E-.32723
G1 X183.625 Y155.17 E-.279
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X180.515 Y152.918 Z3.4 F60000
G1 Z3
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.651964
G1 F1841
M204 S8000
G2 X178.845 Y151.859 I-5.691 J7.125 E.09536
; LINE_WIDTH: 0.598897
G1 X178.676 Y151.777 E.00824
G2 X177.408 Y151.3 I-3.837 J8.265 E.05954
; LINE_WIDTH: 0.551653
G2 X175.863 Y150.989 I-2.552 J8.696 E.06341
; LINE_WIDTH: 0.503472
G1 X175.852 Y150.988 E.00041
G2 X174.284 Y150.953 I-.987 J9.082 E.05714
; LINE_WIDTH: 0.461285
G1 X174.166 Y150.96 E.00391
G2 X168.221 Y153.98 I.753 J8.844 E.22588
; LINE_WIDTH: 0.51978
G2 X167.373 Y155.139 I7.057 J6.054 E.05417
; LINE_WIDTH: 0.567934
G2 X166.618 Y156.672 I7.75 J4.767 E.07097
; LINE_WIDTH: 0.615904
G1 X166.613 Y156.684 E.00058
G2 X166.217 Y158.052 I8.478 J3.198 E.06454
; LINE_WIDTH: 0.655559
G2 X166.052 Y159.27 I9.041 J1.843 E.05949
G1 X165.716 Y159.576 E.02202
; WIPE_START
G1 F5876.219
G1 X166.052 Y159.27 E-.20532
G1 X166.113 Y158.669 E-.27239
G1 X166.217 Y158.052 E-.2823
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X168.39 Y165.369 Z3.4 F60000
G1 X168.622 Y166.151 Z3.4
G1 Z3
G1 E.8 F1800
; LINE_WIDTH: 0.101449
G1 F1841
M204 S8000
G1 X168.899 Y166.418 E.00178
; LINE_WIDTH: 0.131414
G2 X170.12 Y167.36 I6.151 J-6.717 E.01079
; LINE_WIDTH: 0.197857
G2 X170.304 Y167.474 I3.12 J-4.79 E.00265
G1 X170.557 Y167.622 E.00358
G2 X183.49 Y162.356 I4.427 J-7.643 E.19709
G1 X183.491 Y162.353 E.00003
; LINE_WIDTH: 0.168574
G2 X183.805 Y160.745 I-8.374 J-2.475 E.01629
; LINE_WIDTH: 0.119991
G2 X183.831 Y159.295 I-9.193 J-.89 E.00884
; CHANGE_LAYER
; Z_HEIGHT: 3.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F15000
G1 X183.849 Y159.916 E-.32537
G1 X183.805 Y160.745 E-.43463
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 16/19
; update layer progress
M73 L16
M991 S0 P15 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z3.4 I1.185 J-.277 P1  F60000
G1 X182.69 Y155.981 Z3.4
G1 Z3.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1862
M204 S8000
G1 X182.692 Y156.006 E.00082
G3 X183.531 Y159.142 I-7.3 J3.633 E.10509
G3 X175.442 Y168.116 I-8.328 J.626 E.43429
G3 X166.906 Y159.349 I-.417 J-8.133 E.44518
G3 X174.979 Y151.478 I8.321 J.459 E.3982
G3 X175.673 Y151.482 I.297 J8.623 E.02232
G3 X180.265 Y153.101 I-.304 J8.185 E.15895
G3 X182.306 Y155.317 I-4.872 J6.538 E.09744
G1 X182.66 Y155.929 E.02274
; COOLING_NODE: 0
M204 S250
G1 X182.341 Y156.182 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1862
M204 S5000
G3 X183.05 Y158.396 I-6.931 J3.44 E.06951
G3 X175.975 Y167.694 I-7.867 J1.355 E.39044
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

G3 X171.451 Y166.856 I-.842 J-8.079 E.13892
G1 X171.135 Y166.681 E.01076
G1 X170.79 Y166.48 E.01191
G1 X170.603 Y166.355 E.00671
G1 X170.455 Y166.25 E.0054
G1 X170.17 Y166.032 E.01067
G1 X169.896 Y165.802 E.01067
M106 S229.5
G1 X169.761 Y165.681 E.0054
M106 S226.95
M106 S229.5
G1 X169.6 Y165.528 E.00662
M106 S226.95
M106 S229.5
G1 X169.348 Y165.27 E.01075
M106 S226.95
M106 S229.5
G1 X169.107 Y164.999 E.01077
M106 S226.95
M106 S229.5
G1 X168.88 Y164.718 E.01078
M106 S226.95
M106 S229.5
G1 X168.644 Y164.396 E.01189
M106 S226.95
M106 S229.5
G1 X168.447 Y164.095 E.01071
M106 S226.95
M106 S229.5
G1 X168.264 Y163.788 E.01065
M106 S226.95
M106 S229.5
G1 X168.177 Y163.628 E.00541
M106 S226.95
M106 S229.5
G1 X168.068 Y163.415 E.00715
M106 S226.95
M106 S229.5
G1 X167.905 Y163.062 E.01156
M106 S226.95
M106 S229.5
G1 X167.77 Y162.729 E.01071
M106 S226.95
M106 S229.5
G1 X167.652 Y162.392 E.01066
M106 S226.95
M106 S229.5
G1 F1800
G1 X167.597 Y162.218 E.00541
M106 S226.95
M106 S229.5
G1 F1680
G1 X167.53 Y161.977 E.00745
M106 S226.95
M106 S229.5
G1 F1560
G1 X167.442 Y161.61 E.01126
M106 S226.95
M106 S229.5
G1 F1320
G1 X167.375 Y161.258 E.01067
M106 S226.95
M106 S229.5
G1 F1200
G3 X167.316 Y160.822 I7.653 J-1.262 E.01309
M106 S226.95
M106 S229.5
G1 F960
G1 X167.286 Y160.463 E.01075
M106 S226.95
M106 S229.5
G1 F840
G1 X167.273 Y160.095 E.01097
M106 S226.95
M106 S229.5
G1 F600
G1 X167.277 Y159.74 E.01057
M106 S226.95
M106 S229.5
G1 X167.297 Y159.379 E.01075
M106 S226.95
M106 S229.5
G1 X167.348 Y158.847 E.01593
M106 S226.95
M106 S229.5
G3 X168.731 Y155.233 I7.954 J.971 E.1164
M106 S226.95
M106 S229.5
G1 X168.877 Y155.032 E.00742
M106 S226.95
M106 S229.5
G3 X170.029 Y153.804 I6.596 J5.033 E.05022
M106 S226.95
M106 S229.5
G1 X170.2 Y153.661 E.00665
M106 S226.95
M106 S229.5
G1 X170.388 Y153.513 E.00712
M106 S226.95
M106 S229.5
G1 X170.537 Y153.401 E.00556
M106 S226.95
M106 S229.5
M73 P89 R1
G1 F720
G1 X170.842 Y153.19 E.01103
M106 S226.95
M106 S229.5
G1 F840
G1 X171.156 Y152.994 E.01104
M106 S226.95
M106 S229.5
G1 F960
G1 X171.319 Y152.899 E.0056
M106 S226.95
M106 S229.5
G1 F1080
G1 X171.525 Y152.788 E.00697
M106 S226.95
M106 S229.5
G1 F1200
G1 X171.731 Y152.683 E.00689
M106 S226.95
M106 S229.5
G1 F1320
G1 X171.901 Y152.602 E.00561
M106 S226.95
M106 S229.5
G1 F1440
G1 X172.243 Y152.454 E.01111
M106 S226.95
M106 S229.5
G1 F1560
G1 X172.594 Y152.322 E.01115
M106 S226.95
M106 S229.5
G1 F1680
G1 X172.951 Y152.206 E.01119
M106 S226.95
M106 S229.5
G1 F1862
G1 X173.313 Y152.106 E.01119
M106 S226.95
M106 S229.5
G1 X173.68 Y152.024 E.0112
M106 S226.95
M106 S229.5
G1 X174.051 Y151.958 E.01124
M106 S226.95
M106 S229.5
G1 X174.426 Y151.91 E.01125
M106 S226.95
M106 S229.5
G1 X174.802 Y151.879 E.01123
M106 S226.95
M106 S229.5
G1 X174.992 Y151.87 E.00568
M106 S226.95
M106 S229.5
G1 X175.253 Y151.866 E.00777
M106 S226.95
M106 S229.5
G1 X175.655 Y151.874 E.01199
M106 S226.95
G1 X176.009 Y151.899 E.01055
G1 X176.405 Y151.956 E.01191
G1 X176.882 Y152.025 E.01437
G1 X177.441 Y152.158 E.01711
G1 X177.822 Y152.28 E.01191
G1 X178.079 Y152.359 E.00803
G3 X180.026 Y153.413 I-2.723 J7.362 E.06616
G3 X182.314 Y156.128 I-4.617 J6.21 E.10671
; COOLING_NODE: 0
; WIPE_START
G1 F9547.055
M204 S8000
G1 X182.484 Y156.468 E-.1445
G1 X182.755 Y157.187 E-.29185
G1 X182.937 Y157.833 E-.25499
G1 X182.972 Y158.01 E-.06866
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X183.231 Y163.245 Z3.6 F60000
G1 Z3.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1862
M204 S8000
G1 X183.454 Y163.339 E.00778
G3 X172.442 Y151.276 I-8.454 J-3.34 E1.18408
G1 X172.515 Y151.507 E.00779
G2 X166.5 Y159.318 I2.684 J8.288 E.33696
G2 X175.451 Y168.523 I8.525 J.665 E.46701
G2 X183.207 Y163.3 I-.234 J-8.719 E.31735
; COOLING_NODE: 0
; WIPE_START
G1 F8843.478
G1 X183.454 Y163.339 E-.09499
G1 X183.066 Y164.194 E-.35662
G1 X182.835 Y164.61 E-.1807
G1 X182.653 Y164.892 E-.12768
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X182.351 Y157.265 Z3.6 F60000
G1 X182.215 Y153.834 Z3.6
G1 Z3.2
G1 E.8 F1800
G1 F1862
M204 S8000
G3 X174.914 Y150.502 I-7.224 J6.165 E1.65241
G1 X175.217 Y150.505 E.00972
G3 X182.176 Y153.788 I-.225 J9.494 E.25477
; COOLING_NODE: 1
M204 S250
G1 X182.525 Y153.583 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1862
M204 S5000
G1 X182.841 Y153.983 E.01516
G3 X174.912 Y150.11 I-7.848 J6.017 E1.57838
G1 X175.226 Y150.113 E.00936
G3 X182.483 Y153.543 I-.234 J9.886 E.24617
; WIPE_START
G1 F9547.055
M204 S8000
M73 P90 R0
G1 X182.841 Y153.983 E-.21549
G1 X183.15 Y154.398 E-.19692
G1 X183.608 Y155.13 E-.32799
G1 X183.632 Y155.176 E-.01962
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X183.498 Y156.828 Z3.6 F60000
G1 Z3.2
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.462452
G1 F1862
M204 S8000
G1 X183.384 Y156.522 E.01081
G2 X178.617 Y151.687 I-8.218 J3.334 E.23092
; LINE_WIDTH: 0.523697
G1 X178.356 Y151.583 E.01066
G2 X177.042 Y151.193 I-3.205 J8.39 E.0521
; LINE_WIDTH: 0.571871
G2 X175.551 Y150.999 I-1.878 J8.641 E.0629
; LINE_WIDTH: 0.619832
G1 X175.249 Y150.99 E.0138
G2 X173.909 Y151.074 I-.098 J9.202 E.06122
; LINE_WIDTH: 0.662663
G2 X172.672 Y151.329 I1.528 J10.511 E.06187
; WIPE_START
G1 F5808.865
G1 X173.183 Y151.205 E-.31599
G1 X173.909 Y151.074 E-.44401
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X167.694 Y155.504 Z3.6 F60000
G1 X167.151 Y155.891 Z3.6
G1 Z3.2
G1 E.8 F1800
; LINE_WIDTH: 0.118077
G1 F1862
M204 S8000
G1 X167.061 Y156.073 E.00121
G2 X166.642 Y157.124 I8.834 J4.132 E.00672
; LINE_WIDTH: 0.159466
G2 X166.328 Y158.399 I8.563 J2.783 E.0121
; LINE_WIDTH: 0.198089
G2 X176.147 Y168.748 I8.702 J1.577 E.20343
G1 X176.477 Y168.704 E.00407
; LINE_WIDTH: 0.138431
G1 X176.781 Y168.652 E.00233
G2 X177.803 Y168.394 I-1.804 J-9.305 E.00796
; LINE_WIDTH: 0.106624
G2 X178.45 Y168.161 I-2.852 J-8.919 E.00346
; WIPE_START
G1 F15000
G1 X177.803 Y168.394 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X183.361 Y163.164 Z3.6 F60000
G1 X183.423 Y163.105 Z3.6
G1 Z3.2
G1 E.8 F1800
; LINE_WIDTH: 0.656406
G1 F1862
M204 S8000
G2 X183.891 Y161.396 I-8.801 J-3.326 E.08603
; LINE_WIDTH: 0.605355
G2 X184.022 Y159.769 I-9.301 J-1.565 E.07261
; LINE_WIDTH: 0.557365
G1 X184.019 Y159.621 E.00599
G2 X183.88 Y158.265 I-9.049 J.243 E.05547
; LINE_WIDTH: 0.511801
G1 X183.878 Y158.254 E.00042
G2 X183.498 Y156.828 I-9.047 J1.649 E.0547
; CHANGE_LAYER
; Z_HEIGHT: 3.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F7677.864
G1 X183.687 Y157.423 E-.31876
G1 X183.878 Y158.254 E-.43542
G1 X183.88 Y158.265 E-.00582
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 17/19
; update layer progress
M73 L17
M991 S0 P16 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z3.6 I-1.191 J-.249 P1  F60000
G1 X182.668 Y164.061 Z3.6
G1 Z3.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1840
M204 S8000
G1 X182.243 Y164.79 E.02715
G3 X178.814 Y167.693 I-6.755 J-4.503 E.14637
G3 X167.442 Y162.998 I-3.527 J-7.578 E.44461
G3 X170.162 Y153.479 I7.589 J-2.98 E.34212
G3 X174.803 Y151.833 I5.147 J7.148 E.16048
G3 X183.451 Y158.611 I.425 J8.363 E.38535
G3 X183.038 Y163.272 I-7.878 J1.652 E.15269
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

G3 X182.702 Y164.012 I-7.55 J-2.985 E.02615
; COOLING_NODE: 0
M204 S250
G1 X182.336 Y163.864 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1840
M204 S5000
G3 X178.651 Y167.336 I-6.848 J-3.577 E.15364
G3 X167.811 Y162.866 I-3.364 J-7.221 E.39252
G3 X167.412 Y158.546 I7.294 J-2.853 E.13092
G1 X167.456 Y158.35 E.00598
G1 X167.547 Y157.961 E.01191
G1 X167.553 Y157.936 E.00076
G1 X167.604 Y157.762 E.00541
G1 X167.715 Y157.421 E.01066
G1 X167.857 Y157.05 E.01183
M106 S229.5
G1 X168.003 Y156.72 E.01076
M106 S226.95
M106 S229.5
G1 X168.103 Y156.514 E.00682
M106 S226.95
M106 S229.5
M73 P91 R0
G1 X168.186 Y156.354 E.00536
M106 S226.95
M106 S229.5
G1 X168.273 Y156.196 E.00537
M106 S226.95
M106 S229.5
G1 X168.387 Y156.001 E.00674
M106 S226.95
M106 S229.5
G1 X168.581 Y155.698 E.01072
M106 S226.95
M106 S229.5
G1 X168.707 Y155.515 E.0066
M106 S226.95
M106 S229.5
G1 X168.813 Y155.369 E.00539
M106 S226.95
M106 S229.5
G1 X169.034 Y155.088 E.01066
M106 S226.95
M106 S229.5
G1 X169.268 Y154.817 E.01067
M106 S226.95
M106 S229.5
G1 X169.392 Y154.684 E.0054
M106 S226.95
M106 S229.5
G1 X169.559 Y154.512 E.00714
M106 S226.95
M106 S229.5
G1 X169.842 Y154.246 E.01157
M106 S226.95
M106 S229.5
G1 X170.115 Y154.012 E.01071
M106 S226.95
M106 S229.5
G1 X170.398 Y153.792 E.01067
M106 S226.95
M106 S229.5
G1 F1800
G1 X170.545 Y153.686 E.0054
M106 S226.95
M106 S229.5
G1 F1680
G1 X170.751 Y153.545 E.00744
M106 S226.95
M106 S229.5
G1 F1560
G1 X171.072 Y153.345 E.01127
M106 S226.95
M106 S229.5
G1 F1440
G1 X171.386 Y153.17 E.01071
M106 S226.95
M106 S229.5
G1 F1200
G1 X171.707 Y153.009 E.01069
M106 S226.95
M106 S229.5
G1 F1080
G1 X171.943 Y152.903 E.00771
M106 S226.95
M106 S229.5
G1 F960
G1 X172.111 Y152.833 E.00543
M106 S226.95
M106 S229.5
G1 F840
G1 X172.455 Y152.703 E.01093
M106 S226.95
M106 S229.5
G1 F720
G1 X172.706 Y152.621 E.00787
M106 S226.95
M106 S229.5
G1 F600
G1 X172.88 Y152.569 E.00543
M106 S226.95
M106 S229.5
G1 X173.23 Y152.478 E.01075
M106 S226.95
M106 S229.5
G1 X173.751 Y152.363 E.01591
M106 S226.95
M106 S229.5
G3 X174.826 Y152.225 I1.646 J8.564 E.03228
M106 S226.95
M106 S229.5
G3 X175.459 Y152.214 I.45 J7.829 E.01888
M106 S226.95
M106 S229.5
G1 X175.643 Y152.22 E.00548
M106 S226.95
M106 S229.5
G3 X178.418 Y152.871 I-.388 J7.905 E.08537
M106 S226.95
M106 S229.5
G1 X178.642 Y152.972 E.00732
M106 S226.95
M106 S229.5
G3 X179.293 Y153.32 I-3.398 J7.155 E.022
M106 S226.95
M106 S229.5
G1 X179.607 Y153.516 E.01101
M106 S226.95
M106 S229.5
G1 X179.911 Y153.727 E.01105
M106 S226.95
M106 S229.5
G1 F720
G1 X180.134 Y153.895 E.0083
M106 S226.95
M106 S229.5
G1 F840
G1 X180.28 Y154.013 E.00559
M106 S226.95
M106 S229.5
G1 F960
G1 X180.561 Y154.255 E.01105
M106 S226.95
M106 S229.5
G1 F1080
G1 X180.832 Y154.511 E.0111
M106 S226.95
M106 S229.5
G1 F1200
G1 X181.09 Y154.78 E.01108
M106 S226.95
M106 S229.5
G1 F1440
G3 X181.371 Y155.103 I-5.802 J5.333 E.01275
M106 S226.95
M106 S229.5
G1 F1560
G1 X181.513 Y155.28 E.00678
M106 S226.95
M106 S229.5
G1 F1680
G1 X181.628 Y155.431 E.00563
M106 S226.95
M106 S229.5
G1 F1800
G1 X181.843 Y155.736 E.01114
M106 S226.95
M106 S229.5
G1 F1840
G1 X182.045 Y156.052 E.01115
M106 S226.95
M106 S229.5
G1 X182.141 Y156.216 E.00567
M106 S226.95
M106 S229.5
G1 X182.263 Y156.435 E.00745
M106 S226.95
M106 S229.5
G1 X182.364 Y156.63 E.00656
M106 S226.95
M106 S229.5
G1 X182.447 Y156.801 E.00565
M106 S226.95
M106 S229.5
G1 X182.599 Y157.145 E.01122
M106 S226.95
M106 S229.5
G1 X182.736 Y157.498 E.01125
M106 S226.95
M106 S229.5
G1 X182.798 Y157.678 E.00568
M106 S226.95
M106 S229.5
G1 X182.878 Y157.928 E.00782
M106 S226.95
G1 X182.983 Y158.315 E.01196
G1 X183.021 Y158.485 E.00518
G1 X183.131 Y159.062 E.01751
G1 X183.179 Y159.441 E.01137
G1 X183.201 Y159.841 E.01191
G1 X183.227 Y160.204 E.01086
G3 X182.675 Y163.124 I-7.712 J.053 E.08908
G3 X182.364 Y163.811 I-7.186 J-2.837 E.02246
; COOLING_NODE: 0
; WIPE_START
G1 F9547.055
M204 S8000
G1 X181.911 Y164.571 E-.33617
G1 X181.457 Y165.193 E-.2929
G1 X181.228 Y165.451 E-.13093
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X181.687 Y157.832 Z3.8 F60000
G1 X181.913 Y154.097 Z3.8
G1 Z3.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1840
M204 S8000
G3 X182.498 Y154.859 I-6.918 J5.914 E.03091
G1 X182.304 Y155 E.0077
G2 X173.043 Y151.701 I-7.054 J5.153 E.33578
G2 X167.059 Y163.135 I1.975 J8.317 E.47032
G2 X174.492 Y168.837 I8.183 J-2.973 E.31806
G1 X174.471 Y169.076 E.00772
G3 X175.216 Y150.912 I.531 J-9.075 E.90819
G3 X181.874 Y154.051 I-.221 J9.099 E.24368
; COOLING_NODE: 0
M204 S10000
G1 X182.225 Y153.835 F60000
G1 F1840
M204 S8000
G1 X182.517 Y154.203 E.01512
G3 X174.914 Y150.502 I-7.524 J5.796 E1.63704
G1 X175.226 Y150.505 E.01002
G3 X182.184 Y153.795 I-.233 J9.494 E.25482
; COOLING_NODE: 1
M204 S250
G1 X182.529 Y153.588 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1840
M204 S5000
G1 X182.828 Y153.964 E.01431
M73 P92 R0
G3 X174.912 Y150.11 I-7.834 J6.035 E1.57902
G1 X175.236 Y150.113 E.00964
G3 X182.487 Y153.546 I-.242 J9.886 E.24607
; WIPE_START
G1 F9547.055
M204 S8000
G1 X182.828 Y153.964 E-.20506
G1 X183.15 Y154.397 E-.20505
G1 X183.608 Y155.129 E-.32805
G1 X183.634 Y155.18 E-.02184
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X182.519 Y155.095 Z3.8 F60000
G1 Z3.4
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.657737
G1 F1840
M204 S8000
G3 X183.306 Y156.54 I-7.685 J5.123 E.08
; LINE_WIDTH: 0.609326
G1 X183.42 Y156.812 E.0132
G3 X183.81 Y158.051 I-8.334 J3.304 E.05814
; LINE_WIDTH: 0.563717
G1 X183.825 Y158.114 E.00268
G3 X184.027 Y159.443 I-8.879 J2.029 E.05536
; LINE_WIDTH: 0.52039
G1 X184.047 Y159.781 E.01278
G3 X184.025 Y160.866 I-10.487 J.325 E.04094
; LINE_WIDTH: 0.463551
G1 X183.996 Y161.162 E.00987
G3 X180.408 Y167.277 I-8.799 J-1.053 E.24237
; LINE_WIDTH: 0.523217
G3 X178.998 Y168.11 I-5.55 J-7.784 E.0622
; LINE_WIDTH: 0.573788
G3 X177.43 Y168.682 I-3.888 J-8.22 E.07009
; LINE_WIDTH: 0.618553
G1 X177.418 Y168.685 E.00059
G3 X176.175 Y168.92 I-2.375 J-9.182 E.05756
; LINE_WIDTH: 0.660124
G3 X174.684 Y168.974 I-1.126 J-10.426 E.07279
; WIPE_START
G1 F5832.754
G1 X175.388 Y168.976 E-.3582
G1 X176.175 Y168.92 E-.4018
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X169.08 Y166.107 Z3.8 F60000
G1 X168.3 Y165.798 Z3.8
G1 Z3.4
G1 E.8 F1800
; LINE_WIDTH: 0.104834
G1 F1840
M204 S8000
G3 X168.042 Y165.475 I9.266 J-7.674 E.00202
G1 X167.974 Y165.384 E.00055
; LINE_WIDTH: 0.134271
G3 X167.363 Y164.441 I7.677 J-5.647 E.00811
G1 X167.242 Y164.217 E.00183
; LINE_WIDTH: 0.197664
G3 X167.038 Y163.802 I7.658 J-4.019 E.00565
G3 X173.54 Y151.308 I7.991 J-3.781 E.1992
G1 X173.848 Y151.257 E.00382
; LINE_WIDTH: 0.159015
G3 X175.182 Y151.162 I1.284 J8.616 E.01228
; LINE_WIDTH: 0.11715
G3 X176.511 Y151.269 I-.057 J9.002 E.00782
; CHANGE_LAYER
; Z_HEIGHT: 3.6
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F15000
G1 X175.854 Y151.192 E-.37689
G1 X175.182 Y151.162 E-.38311
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 18/19
; update layer progress
M73 L18
M991 S0 P17 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z3.8 I-1.215 J-.068 P1  F60000
G1 X174.201 Y168.629 Z3.8
G1 Z3.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1847
M204 S8000
G1 X173.744 Y168.595 E.01474
G3 X168.848 Y165.989 I1.133 J-8.032 E.18203
G3 X169.606 Y153.904 I6.139 J-5.681 E.43538
G3 X174.758 Y151.884 I5.486 J6.413 E.1813
G3 X181.749 Y155.485 I.23 J8.138 E.26388
G3 X179.592 Y167.199 I-6.863 J4.792 E.42616
G3 X174.657 Y168.671 I-4.692 J-6.718 E.16846
G1 X174.261 Y168.635 E.0128
; COOLING_NODE: 0
M204 S250
G1 X174.237 Y168.239 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1847
M204 S5000
G1 X173.803 Y168.207 E.01297
G3 X169.137 Y165.725 I1.074 J-7.644 E.16067
G3 X169.854 Y154.208 I5.849 J-5.417 E.3843
G3 X174.145 Y152.325 I5.241 J6.114 E.14161
G1 X174.62 Y152.282 E.01422
M73 P93 R0
G1 X174.77 Y152.276 E.00448
G1 X174.952 Y152.272 E.00541
G1 X175.346 Y152.28 E.01174
G1 X175.706 Y152.305 E.01075
M106 S229.5
G1 X175.936 Y152.329 E.00688
M106 S226.95
M106 S229.5
G1 X176.115 Y152.353 E.00539
M106 S226.95
M106 S229.5
G1 X176.469 Y152.413 E.01067
M106 S226.95
M106 S229.5
G1 X176.819 Y152.489 E.01068
M106 S226.95
M106 S229.5
G1 X177.04 Y152.546 E.00681
M106 S226.95
M106 S229.5
G1 X177.216 Y152.597 E.00543
M106 S226.95
M106 S229.5
G1 X177.594 Y152.72 E.01184
M106 S226.95
M106 S229.5
G1 X177.929 Y152.849 E.01071
M106 S226.95
M106 S229.5
G1 X178.257 Y152.992 E.01067
M106 S226.95
M106 S229.5
G1 X178.421 Y153.071 E.00541
M106 S226.95
M106 S229.5
G1 X178.635 Y153.181 E.00716
M106 S226.95
M106 S229.5
G1 X178.972 Y153.371 E.01154
M106 S226.95
M106 S229.5
G1 X179.275 Y153.563 E.01067
M106 S226.95
M106 S229.5
G1 X179.425 Y153.665 E.0054
M106 S226.95
M106 S229.5
G1 F1800
G1 X179.626 Y153.81 E.0074
M106 S226.95
M106 S229.5
G1 F1680
G1 X179.91 Y154.033 E.01075
M106 S226.95
M106 S229.5
G1 F1440
G1 X180.196 Y154.28 E.01127
M106 S226.95
M106 S229.5
G1 F1320
G1 X180.456 Y154.528 E.0107
M106 S226.95
M106 S229.5
G1 F1200
G1 X180.635 Y154.712 E.00765
M106 S226.95
M106 S229.5
G1 F1080
G1 X180.759 Y154.847 E.00544
M106 S226.95
M106 S229.5
G1 F960
G1 X180.993 Y155.121 E.01074
M106 S226.95
M106 S229.5
G1 F840
G1 X181.215 Y155.407 E.01077
M106 S226.95
M106 S229.5
G1 F600
G1 X181.423 Y155.703 E.01077
M106 S226.95
M106 S229.5
G1 X181.617 Y156.008 E.01077
M106 S226.95
M106 S229.5
G1 X181.842 Y156.39 E.01321
M106 S226.95
M106 S229.5
G3 X182.348 Y157.449 I-10.996 J5.899 E.03497
M106 S226.95
M106 S229.5
G1 X182.412 Y157.62 E.00544
M106 S226.95
M106 S229.5
G3 X182.851 Y159.66 I-8.411 J2.878 E.06231
M106 S226.95
M106 S229.5
G1 X182.863 Y159.845 E.00553
M106 S226.95
M106 S229.5
G3 X182.818 Y161.219 I-11.453 J.314 E.04096
M106 S226.95
M106 S229.5
G1 X182.794 Y161.404 E.00556
M106 S226.95
M106 S229.5
G3 X182.655 Y162.127 I-7.827 J-1.129 E.02194
M106 S226.95
M106 S229.5
G1 X182.609 Y162.307 E.00555
M106 S226.95
M106 S229.5
G1 X182.548 Y162.524 E.00671
M106 S226.95
M106 S229.5
G1 X182.477 Y162.751 E.00707
M106 S226.95
M106 S229.5
G1 F720
G1 X182.416 Y162.929 E.00559
M106 S226.95
M106 S229.5
G1 F840
G1 X182.284 Y163.274 E.01102
M106 S226.95
M106 S229.5
G1 F960
G1 X182.135 Y163.616 E.01111
M106 S226.95
M106 S229.5
G1 F1080
G1 X181.97 Y163.951 E.01111
M106 S226.95
M106 S229.5
G1 F1320
G1 X181.791 Y164.277 E.01109
M106 S226.95
M106 S229.5
G1 F1440
G1 X181.694 Y164.438 E.00561
M106 S226.95
M106 S229.5
G1 F1560
G1 X181.565 Y164.641 E.00718
M106 S226.95
M106 S229.5
G1 F1680
G1 X181.437 Y164.829 E.00676
M106 S226.95
M106 S229.5
G1 F1800
G3 X181.099 Y165.279 I-6.618 J-4.62 E.01677
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

M106 S226.95
M106 S229.5
G1 F1847
G1 X180.856 Y165.567 E.01121
M106 S226.95
M106 S229.5
G1 X180.599 Y165.843 E.01122
M106 S226.95
M106 S229.5
G1 X180.33 Y166.107 E.01124
M106 S226.95
M106 S229.5
G1 X180.049 Y166.357 E.01122
M106 S226.95
M106 S229.5
G1 X179.902 Y166.479 E.00568
M106 S226.95
M106 S229.5
G1 X179.697 Y166.64 E.00775
M106 S226.95
M106 S229.5
G1 X179.371 Y166.876 E.012
M106 S226.95
G1 X179.052 Y167.083 E.01132
G1 X178.917 Y167.162 E.00466
G1 X178.566 Y167.354 E.01191
G1 X178.387 Y167.452 E.00608
G1 X178.041 Y167.614 E.01138
G1 X177.667 Y167.757 E.01191
G1 X177.329 Y167.893 E.01087
G3 X174.67 Y168.28 I-2.427 J-7.362 E.08042
G1 X174.297 Y168.245 E.01117
; COOLING_NODE: 0
; WIPE_START
G1 F9547.055
M204 S8000
G1 X173.803 Y168.207 E-.18826
G1 X173.049 Y168.053 E-.29247
G1 X172.343 Y167.847 E-.27927
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X176.71 Y161.587 Z4 F60000
G1 X181.922 Y154.115 Z4
G1 Z3.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1847
M204 S8000
G1 X182.116 Y154.345 E.00967
G3 X182.237 Y165.5 I-7.118 J5.656 E.38623
G1 X182.042 Y165.362 E.00769
G2 X182.087 Y155.258 I-7.164 J-5.084 E.34617
G2 X169.653 Y153.348 I-7.096 J4.768 E.45455
G2 X166.422 Y162.171 I5.251 J6.926 E.3192
G1 X166.187 Y162.225 E.00777
G3 X175.225 Y150.912 I8.815 J-2.224 E.53864
G3 X181.698 Y153.856 I-.226 J9.088 E.23494
G1 X181.883 Y154.07 E.00909
; COOLING_NODE: 0
M204 S10000
G1 X182.232 Y153.86 F60000
G1 F1847
M204 S8000
G1 X182.432 Y154.092 E.00985
G3 X174.914 Y150.502 I-7.436 J5.907 E1.64152
G1 X175.235 Y150.505 E.01032
G3 X181.774 Y153.347 I-.239 J9.494 E.235
G1 X182.192 Y153.815 E.02019
; COOLING_NODE: 1
M204 S250
M73 P94 R0
G1 X182.533 Y153.593 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1847
M204 S5000
G1 X182.738 Y153.846 E.0097
G3 X174.912 Y150.11 I-7.742 J6.153 E1.58343
G1 X175.245 Y150.113 E.00991
G3 X182.492 Y153.549 I-.249 J9.886 E.24599
; WIPE_START
G1 F9547.055
M204 S8000
G1 X182.738 Y153.846 E-.14639
G1 X183.052 Y154.257 E-.19659
G1 X183.341 Y154.687 E-.19681
G1 X183.636 Y155.186 E-.2202
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X182.737 Y155.784 Z4 F60000
G1 Z3.6
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.170046
G1 F1847
M204 S8000
G3 X183.331 Y157.064 I-7.652 J4.327 E.01419
G1 X183.381 Y157.201 E.00146
; LINE_WIDTH: 0.120886
G3 X183.774 Y158.77 I-8.596 J2.99 E.00998
; WIPE_START
G1 F15000
G1 X183.632 Y158.051 E-.34383
G1 X183.381 Y157.201 E-.41617
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X182.737 Y155.784 Z4 F60000
G1 Z3.6
G1 E.8 F1800
; LINE_WIDTH: 0.198056
G1 F1847
M204 S8000
G2 X168.927 Y153.599 I-7.749 J4.246 E.19766
G1 X168.79 Y153.728 E.0023
G2 X168.599 Y153.918 I7.111 J7.362 E.0033
; LINE_WIDTH: 0.132823
G1 X168.503 Y154.016 E.00097
G2 X167.656 Y155.056 I6.69 J6.322 E.00954
; LINE_WIDTH: 0.103551
G2 X167.422 Y155.409 I10.907 J7.48 E.00203
; WIPE_START
G1 F15000
G1 X167.656 Y155.056 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X166.349 Y162.397 Z4 F60000
G1 Z3.6
G1 E.8 F1800
; LINE_WIDTH: 0.662327
G1 F1847
M204 S8000
G2 X166.831 Y163.763 I9.622 J-2.623 E.07095
; LINE_WIDTH: 0.62079
G2 X167.474 Y164.964 I8.312 J-3.684 E.06223
G1 X167.482 Y164.975 E.00061
; LINE_WIDTH: 0.574436
G2 X168.507 Y166.292 I7.709 J-4.944 E.07017
; LINE_WIDTH: 0.523685
G2 X169.738 Y167.383 I6.741 J-6.367 E.06257
; LINE_WIDTH: 0.461731
G2 X176.245 Y168.992 I5.226 J-7.177 E.22736
G1 X176.498 Y168.949 E.00849
; LINE_WIDTH: 0.508354
G2 X177.983 Y168.544 I-1.679 J-9.089 E.05667
G1 X178.024 Y168.529 E.00161
; LINE_WIDTH: 0.557481
G2 X179.501 Y167.822 I-3.226 J-8.629 E.06666
; LINE_WIDTH: 0.605413
G2 X180.221 Y167.345 I-5.126 J-8.524 E.03838
G1 X180.729 Y166.942 E.0288
; LINE_WIDTH: 0.654286
G2 X181.804 Y165.858 I-5.796 J-6.821 E.07383
G1 X181.818 Y165.841 E.00107
G1 X182.27 Y165.788 E.02196
; CHANGE_LAYER
; Z_HEIGHT: 3.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F5888.453
G1 X181.818 Y165.841 E-.17283
G1 X181.804 Y165.858 E-.00838
G1 X181.248 Y166.465 E-.3128
G1 X180.733 Y166.939 E-.26599
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 19/19
; update layer progress
M73 L19
M991 S0 P18 ;notify layer change

M106 S224.4
; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z4 I.049 J-1.216 P1  F60000
G1 X170.129 Y166.514 Z4
G1 Z3.8
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
M106 S229.5
G1 F2069
M204 S5000
G1 X169.948 Y166.384 E.00664
M106 S224.4
G1 X169.645 Y166.15 E.0114
G1 X169.403 Y165.943 E.00948
G3 X167.835 Y164.084 I5.765 J-6.452 E.07269
G3 X166.747 Y159.265 I6.64 J-4.033 E.14977
G3 X174.453 Y152.106 I8.017 J.903 E.34128
G3 X178.792 Y153.237 I.271 J7.844 E.13543
G3 X182.207 Y157.212 I-4.101 J6.978 E.15896
G1 X182.252 Y157.33 E.00375
G1 X182.367 Y157.667 E.01063
G1 X182.422 Y157.847 E.0056
G1 X182.484 Y158.075 E.00704
M106 S229.5
G1 X182.571 Y158.45 E.01148
M106 S224.4
M106 S229.5
G1 X182.639 Y158.83 E.01149
M106 S224.4
M106 S229.5
G1 X182.683 Y159.173 E.01031
M106 S224.4
M106 S229.5
G1 X182.715 Y159.558 E.01149
M106 S224.4
M106 S229.5
G1 X182.728 Y159.943 E.01148
M106 S224.4
M106 S229.5
G1 X182.721 Y160.325 E.01138
M106 S224.4
M106 S229.5
G1 X182.71 Y160.526 E.00601
M106 S224.4
M106 S229.5
G1 X182.691 Y160.753 E.00677
M106 S224.4
M106 S229.5
G1 X182.645 Y161.13 E.01131
M106 S224.4
M106 S229.5
G1 X182.612 Y161.334 E.00616
M106 S224.4
M106 S229.5
G1 X182.57 Y161.554 E.00666
M106 S224.4
M106 S229.5
G1 X182.485 Y161.922 E.01126
M106 S224.4
M106 S229.5
G1 F2040
G1 X182.429 Y162.128 E.00636
M106 S224.4
M106 S229.5
G1 F1920
G1 X182.366 Y162.338 E.00653
M106 S224.4
M106 S229.5
G1 F1680
G1 X182.243 Y162.694 E.0112
M106 S224.4
M106 S229.5
G1 F1560
G1 X182.104 Y163.041 E.01114
M106 S224.4
M106 S229.5
G1 F1440
G1 X182.013 Y163.247 E.00671
M106 S224.4
M106 S229.5
G1 F1320
G1 X181.922 Y163.436 E.00626
M106 S224.4
M106 S229.5
G1 F1200
G1 X181.75 Y163.763 E.01101
M106 S224.4
M106 S229.5
G1 F1080
G1 X181.631 Y163.968 E.00705
M106 S224.4
M106 S229.5
G1 F960
M73 P95 R0
G1 X181.525 Y164.14 E.00602
M106 S224.4
M106 S229.5
G1 F840
G1 X181.335 Y164.426 E.01023
M106 S224.4
M106 S229.5
G1 F600
G1 X181.116 Y164.723 E.01099
M106 S224.4
M106 S229.5
G1 X180.887 Y165.006 E.01086
M106 S224.4
M106 S229.5
G1 X180.535 Y165.406 E.01587
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

M106 S224.4
M106 S229.5
G1 X180.287 Y165.667 E.01071
M106 S224.4
M106 S229.5
G3 X179.957 Y165.978 I-5.485 J-5.476 E.0135
M106 S224.4
M106 S229.5
G3 X178.778 Y166.844 I-6.664 J-7.836 E.04364
M106 S224.4
M106 S229.5
G3 X178.392 Y167.061 I-4.004 J-6.682 E.01318
M106 S224.4
M106 S229.5
G3 X175.582 Y167.915 I-3.808 J-7.478 E.08792
M106 S224.4
M106 S229.5
G1 X175.169 Y167.949 E.01235
M106 S224.4
M106 S229.5
G1 X174.786 Y167.961 E.01142
M106 S224.4
M106 S229.5
G1 F720
G1 X174.403 Y167.955 E.01141
M106 S224.4
M106 S229.5
G1 F840
G1 X174.021 Y167.93 E.0114
M106 S224.4
M106 S229.5
G1 F960
G1 X173.641 Y167.888 E.01137
M106 S224.4
M106 S229.5
G1 F1200
G1 X173.413 Y167.853 E.00687
M106 S224.4
M106 S229.5
G1 F1320
G1 X173.224 Y167.819 E.00571
M106 S224.4
M106 S229.5
G1 F1440
G1 X172.851 Y167.738 E.01139
M106 S224.4
M106 S229.5
G1 F1560
G1 X172.48 Y167.64 E.01141
M106 S224.4
M106 S229.5
G1 F1680
G1 X172.117 Y167.524 E.01137
M106 S224.4
M106 S229.5
G1 F1920
G3 X171.716 Y167.374 I2.643 J-7.66 E.01276
M106 S224.4
M106 S229.5
G1 F2040
G1 X171.364 Y167.222 E.0114
M106 S224.4
M106 S229.5
G1 F2069
G1 X171.02 Y167.053 E.01143
M106 S224.4
M106 S229.5
G1 X170.684 Y166.868 E.01142
M106 S224.4
M106 S229.5
G1 X170.492 Y166.752 E.00669
M106 S224.4
M106 S229.5
G1 X170.305 Y166.633 E.00661
M106 S224.4
M106 S229.5
G1 X170.178 Y166.547 E.00454
M106 S224.4
; COOLING_NODE: 1
; WIPE_START
G1 F3669.062
M204 S8000
G1 X169.948 Y166.384 E-.10744
G1 X169.645 Y166.15 E-.14541
G1 X169.403 Y165.943 E-.12088
G1 X169.074 Y165.639 E-.17015
G1 X168.688 Y165.222 E-.21612
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X174.534 Y160.315 Z4.2 F60000
G1 X182.535 Y153.599 Z4.2
G1 Z3.8
G1 E.8 F1800
G1 F2069
M204 S5000
G1 X182.629 Y153.709 E.00431
G3 X174.912 Y150.11 I-7.631 J6.29 E1.58862
G1 X175.254 Y150.113 E.01018
G3 X182.29 Y153.319 I-.256 J9.886 E.23662
G1 X182.496 Y153.554 E.00929
; WIPE_START
G1 F9547.055
M204 S8000
G1 X182.629 Y153.709 E-.07772
G1 X183.245 Y154.538 E-.39246
G1 X183.607 Y155.129 E-.26357
G1 X183.64 Y155.19 E-.02625
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X183.566 Y155.502 Z4.2 F60000
G1 Z3.8
G1 E.8 F1800
; FEATURE: Top surface
G1 F2463
M204 S2000
G1 X179.489 Y151.425 E.17175
G1 X179.356 Y151.291
G1 X178.389 Y150.857
G1 X178.522 Y150.991
G1 X184.021 Y156.49 E.23163
G1 X184.155 Y156.623
G1 X184.427 Y157.429
G1 X184.294 Y157.296
G1 X177.703 Y150.705 E.27763
G1 X177.57 Y150.571
G1 X176.858 Y150.393
G1 X176.992 Y150.527
G1 X184.464 Y157.999 E.31476
G1 X184.598 Y158.133
G1 X184.719 Y158.787
G1 X184.585 Y158.653
G1 X181.725 Y155.793 E.1205
G1 X181.591 Y155.659
G1 X182.157 Y156.758
G1 X182.29 Y156.892
G1 X184.651 Y159.252 E.09943
G1 X184.784 Y159.386
G1 X184.805 Y159.94
G1 X184.671 Y159.806
G1 X182.593 Y157.728 E.08754
G1 X182.46 Y157.594
G1 X182.637 Y158.305
G1 X182.77 Y158.438
G1 X184.675 Y160.343 E.08022
G1 X184.808 Y160.476
G1 X184.777 Y160.979
G1 X184.644 Y160.845
G1 X182.873 Y159.074 E.0746
G1 X182.739 Y158.94
G1 X182.79 Y159.524
G1 X182.923 Y159.658
G1 X184.589 Y161.324 E.07017
G1 X184.723 Y161.457
G1 X184.643 Y161.911
G1 X184.509 Y161.777
G1 X182.927 Y160.195 E.06663
G1 X182.794 Y160.062
G1 X182.761 Y160.562
G1 X182.894 Y160.695
G1 X184.419 Y162.221 E.06425
G1 X184.553 Y162.354
G1 X184.44 Y162.775
G1 X184.307 Y162.641
G1 X182.846 Y161.18 E.06153
G1 X182.712 Y161.047
G1 X182.623 Y161.491
G1 X182.757 Y161.624
G1 X184.186 Y163.053 E.0602
G1 X184.319 Y163.187
G1 X184.18 Y163.581
G1 X184.047 Y163.447
G1 X182.659 Y162.06 E.05845
G1 X182.525 Y161.926
G1 X182.398 Y162.332
G1 X182.532 Y162.466
G1 X183.893 Y163.827 E.05734
G1 X184.027 Y163.961
G1 X183.859 Y164.326
G1 X183.725 Y164.192
G1 X182.981 Y163.448 E.03134
; WIPE_START
G1 F9547.055
M204 S8000
G1 X183.725 Y164.192 E-.39984
G1 X183.859 Y164.326 E-.07182
G1 X184.027 Y163.961 E-.15275
G1 X183.893 Y163.827 E-.07182
G1 X183.774 Y163.709 E-.06377
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z4.2 I1.114 J-.49 P1  F60000
G1 X179.176 Y153.244 Z4.2
G1 Z3.8
G1 E.8 F1800
G1 F2463
M204 S2000
G1 X176.347 Y150.415 E.11919
G1 X176.213 Y150.281
G1 X175.621 Y150.222
G1 X175.754 Y150.356
G1 X177.983 Y152.585 E.09389
G1 X178.117 Y152.719
M73 P96 R0
G1 X177.268 Y152.403
G1 X177.135 Y152.269
G1 X175.186 Y150.321 E.08209
G1 X175.052 Y150.187
G1 X174.524 Y150.192
G1 X174.657 Y150.325
G1 X176.412 Y152.08 E.07391
G1 X176.546 Y152.214
G1 X175.896 Y152.098
G1 X175.763 Y151.964
G1 X174.155 Y150.356 E.06772
G1 X174.021 Y150.223
G1 X173.542 Y150.276
G1 X173.675 Y150.41
G1 X175.175 Y151.909 E.06316
G1 X175.308 Y152.043
G1 X174.765 Y152.033
G1 X174.632 Y151.899
G1 X173.216 Y150.484 E.05962
G1 X173.083 Y150.351
G1 X172.649 Y150.451
G1 X172.783 Y150.584
G1 X174.121 Y151.922 E.05634
G1 X174.254 Y152.055
G1 X173.769 Y152.103
G1 X173.635 Y151.969
G1 X172.353 Y150.688 E.05399
G1 X172.22 Y150.554
G1 X171.811 Y150.679
G1 X171.945 Y150.813
G1 X173.181 Y152.048 E.05205
G1 X173.314 Y152.182
G1 X172.875 Y152.276
G1 X172.741 Y152.142
G1 X171.553 Y150.954 E.05005
G1 X171.42 Y150.82
G1 X171.045 Y150.979
G1 X171.179 Y151.113
G1 X172.324 Y152.259 E.04827
G1 X172.458 Y152.392
G1 X172.058 Y152.525
G1 X171.924 Y152.392
G1 X170.81 Y151.277 E.04695
G1 X170.676 Y151.143
G1 X170.32 Y151.321
G1 X170.454 Y151.455
G1 X171.548 Y152.549 E.04609
G1 X171.682 Y152.683
G1 X171.309 Y152.843
G1 X171.175 Y152.709
G1 X170.111 Y151.645 E.04481
G1 X169.978 Y151.512
G1 X169.645 Y151.713
G1 X169.779 Y151.846
G1 X170.828 Y152.895 E.04418
G1 X170.962 Y153.029
G1 X170.617 Y153.217
G1 X170.483 Y153.084
G1 X169.461 Y152.061 E.04307
G1 X169.327 Y151.927
G1 X169.019 Y152.153
G1 X169.153 Y152.286
G1 X170.164 Y153.297 E.04258
G1 X170.297 Y153.431
G1 X169.979 Y153.646
G1 X169.845 Y153.512
G1 X168.856 Y152.523 E.04165
G1 X168.723 Y152.39
G1 X168.438 Y152.638
G1 X168.571 Y152.771
G1 X169.551 Y153.751 E.04128
G1 X169.685 Y153.885
G1 X169.391 Y154.125
G1 X169.258 Y153.991
G1 X168.289 Y153.022 E.04081
G1 X168.155 Y152.889
G1 X167.889 Y153.155
G1 X168.022 Y153.289
G1 X168.989 Y154.255 E.04071
G1 X169.122 Y154.389
G1 X168.855 Y154.655
G1 X168.721 Y154.521
G1 X167.767 Y153.567 E.04017
G1 X167.634 Y153.434
G1 X167.39 Y153.724
G1 X167.524 Y153.857
G1 X168.474 Y154.808 E.04004
G1 X168.608 Y154.941
G1 X168.367 Y155.234
G1 X168.234 Y155.1
G1 X167.29 Y154.157 E.03975
G1 X167.156 Y154.023
G1 X166.927 Y154.327
G1 X167.061 Y154.461
G1 X168.006 Y155.406 E.0398
G1 X168.14 Y155.539
G1 X167.926 Y155.859
G1 X167.792 Y155.725
G1 X166.846 Y154.779 E.03985
G1 X166.713 Y154.646
G1 X166.512 Y154.978
G1 X166.645 Y155.111
G1 X167.59 Y156.056 E.03981
G1 X167.724 Y156.19
G1 X167.537 Y156.536
G1 X167.403 Y156.403
G1 X166.455 Y155.454 E.03995
G1 X166.321 Y155.321
G1 X166.141 Y155.674
G1 X166.275 Y155.808
G1 X167.229 Y156.762 E.04019
G1 X167.363 Y156.896
G1 X167.205 Y157.271
G1 X167.072 Y157.138
G1 X166.107 Y156.173 E.04064
G1 X165.973 Y156.039
G1 X165.82 Y156.419
G1 X165.953 Y156.553
G1 X166.924 Y157.523 E.04087
G1 X167.057 Y157.656
G1 X166.932 Y158.064
G1 X166.798 Y157.931
G1 X165.814 Y156.947 E.04144
G1 X165.681 Y156.813
G1 X165.56 Y157.225
G1 X165.693 Y157.359
G1 X166.686 Y158.351 E.0418
G1 X166.819 Y158.485
G1 X166.729 Y158.928
G1 X166.595 Y158.794
G1 X165.581 Y157.78 E.04273
G1 X165.447 Y157.646
G1 X165.352 Y158.085
G1 X165.486 Y158.218
G1 X166.548 Y159.281 E.04475
G1 X166.682 Y159.414
G1 X166.648 Y159.914
G1 X166.514 Y159.78
G1 X165.412 Y158.677 E.04646
G1 X165.278 Y158.543
G1 X165.228 Y159.027
G1 X165.362 Y159.161
G1 X166.517 Y160.316 E.04865
G1 X166.65 Y160.449
G1 X166.696 Y161.028
G1 X166.562 Y160.894
G1 X165.327 Y159.659 E.05204
G1 X165.193 Y159.525
G1 X165.195 Y160.06
G1 X165.329 Y160.194
G1 X166.652 Y161.517 E.05573
G1 X166.785 Y161.651
G1 X166.938 Y162.337
G1 X166.805 Y162.203
G1 X165.349 Y160.748 E.06131
G1 X165.216 Y160.614
G1 X165.281 Y161.213
G1 X165.415 Y161.347
G1 X167.049 Y162.981 E.06883
G1 X167.182 Y163.114
G1 X167.707 Y164.172
G1 X167.573 Y164.038
G1 X165.527 Y161.992 E.0862
; WIPE_START
G1 F9547.055
M204 S8000
G1 X166.941 Y163.406 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.613 Y167.545 Z4.2 F60000
G1 Z3.8
G1 E.8 F1800
G1 F2463
M204 S2000
G1 X172.842 Y168.773 E.05174
G1 X172.975 Y168.907
G1 X173.142 Y169.607
G1 X173.008 Y169.473
G1 X170.585 Y167.05 E.10208
; WIPE_START
G1 F9547.055
M204 S8000
G1 X171.999 Y168.464 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.297 Y169.295 Z4.2 F60000
G1 Z3.8
G1 E.8 F1800
G1 F2463
M204 S2000
G1 X165.708 Y162.707 E.27752
G1 X165.575 Y162.573
G1 X165.845 Y163.377
G1 X165.979 Y163.511
G1 X171.492 Y169.024 E.23223
G1 X171.626 Y169.157
G1 X170.65 Y168.715
G1 X170.517 Y168.582
G1 X166.425 Y164.49 E.17238
; WIPE_START
G1 F9547.055
M204 S8000
G1 X167.839 Y165.904 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.648 Y159.977 Z4.2 F60000
G1 X178.456 Y152.818 Z4.2
G1 Z3.8
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.102325
G1 F2463
M204 S8000
G1 X178.334 Y152.729 E.00071
; WIPE_START
G1 F15000
G1 X178.456 Y152.818 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z4.2 I-.674 J1.013 P1  F60000
G1 X180.037 Y153.869 Z4.2
G1 Z3.8
G1 E.8 F1800
; LINE_WIDTH: 0.0976706
G1 F2463
M204 S8000
G1 X179.874 Y153.721 E.00095
; LINE_WIDTH: 0.131914
G1 X179.632 Y153.514 E.00224
; LINE_WIDTH: 0.181251
G1 X179.39 Y153.307 E.00348
; LINE_WIDTH: 0.217165
G1 X179.237 Y153.184 E.0027
; WIPE_START
G1 F15000
G1 X179.39 Y153.307 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X183.161 Y154.801 Z4.2 F60000
G1 Z3.8
G1 E.8 F1800
; LINE_WIDTH: 0.11258
G1 F2463
M204 S8000
G1 X183 Y154.603 E.0014
; LINE_WIDTH: 0.161389
G1 X182.838 Y154.406 E.00239
; LINE_WIDTH: 0.210769
G1 X182.618 Y154.15 E.00448
; LINE_WIDTH: 0.248771
G1 X182.451 Y153.965 E.00406
; LINE_WIDTH: 0.274874
G1 X182.284 Y153.779 E.00458
; LINE_WIDTH: 0.305435
G2 X181.222 Y152.717 I-15.739 J14.676 E.03115
; LINE_WIDTH: 0.270812
G1 X181.011 Y152.531 E.00506
; LINE_WIDTH: 0.236485
G1 X180.801 Y152.345 E.00429
; LINE_WIDTH: 0.202158
G1 X180.591 Y152.159 E.00353
; LINE_WIDTH: 0.160775
G1 X180.395 Y151.999 E.00235
; LINE_WIDTH: 0.11237
G1 X180.199 Y151.839 E.00139
; WIPE_START
G1 F15000
G1 X180.395 Y151.999 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X181.553 Y155.453 Z4.2 F60000
G1 Z3.8
G1 E.8 F1800
; LINE_WIDTH: 0.156496
G1 F2463
M204 S8000
G1 X181.435 Y155.311 E.00166
; LINE_WIDTH: 0.128227
G1 X181.315 Y155.167 E.00127
; LINE_WIDTH: 0.101086
G1 X181.079 Y154.911 E.0016
; WIPE_START
G1 F15000
G1 X181.315 Y155.167 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z4.2 I-.378 J1.157 P1  F60000
G1 X183.806 Y155.981 Z4.2
G1 Z3.8
G1 E.8 F1800
; LINE_WIDTH: 0.106252
G1 F2463
M204 S8000
G1 X183.742 Y155.89 E.00056
; LINE_WIDTH: 0.142435
G1 X183.678 Y155.798 E.00088
; LINE_WIDTH: 0.178617
G1 X183.614 Y155.707 E.0012
; LINE_WIDTH: 0.209213
G1 X183.505 Y155.563 E.00237
; WIPE_START
G1 F15000
G1 X183.614 Y155.707 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X182.982 Y163.313 Z4.2 F60000
G1 X182.97 Y163.459 Z4.2
G1 Z3.8
G1 E.8 F1800
; LINE_WIDTH: 0.220242
G1 F2463
M204 S8000
G1 X182.978 Y163.315 E.00203
G1 X182.619 Y162.957 E.00711
; LINE_WIDTH: 0.260005
M73 P97 R0
G1 X182.406 Y162.792 E.00461
; WIPE_START
G1 F15000
G1 X182.619 Y162.957 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z4.2 I-1.038 J.636 P1  F60000
G1 X183.579 Y164.523 Z4.2
G1 Z3.8
G1 E.8 F1800
; LINE_WIDTH: 0.166489
G1 F2463
M204 S8000
G1 X183.302 Y164.058 E.00528
M204 S10000
G1 X183.574 Y164.532 F60000
; LINE_WIDTH: 0.194122
G1 F2463
M204 S8000
G1 X183.307 Y164.055 E.00653
M204 S10000
G1 X183.571 Y164.538 F60000
; LINE_WIDTH: 0.253797
G1 F2463
M204 S8000
G1 X183.313 Y164.051 E.00917
M204 S10000
G1 X183.316 Y164.05 F60000
; LINE_WIDTH: 0.286275
G1 F2463
M204 S8000
G1 X183.501 Y164.408 E.00776
G1 X183.438 Y164.759 E.00685
; WIPE_START
G1 F14793.253
G1 X183.501 Y164.408 E-.35625
G1 X183.316 Y164.05 E-.40375
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z4.2 I-.402 J-1.149 P1  F60000
G1 X172.5 Y167.832 Z4.2
G1 Z3.8
G1 E.8 F1800
; LINE_WIDTH: 0.208193
G1 F2463
M204 S8000
G1 X172.733 Y168.387 E.00786
M204 S10000
G1 X172.514 Y167.837 F60000
; LINE_WIDTH: 0.318143
G1 F2463
M204 S8000
G1 X172.724 Y168.389 E.01284
M204 S10000
G1 X172.738 Y168.384 F60000
; LINE_WIDTH: 0.137161
G1 F2463
M204 S8000
G1 X172.477 Y167.826 E.00459
M204 S10000
G1 X171.545 Y167.614 F60000
; LINE_WIDTH: 0.106803
G1 F2463
M204 S8000
G3 X171.198 Y167.369 I5.222 J-7.764 E.00214
M204 S10000
G1 X170.524 Y167.111 F60000
; LINE_WIDTH: 0.205305
G1 F2463
M204 S8000
G1 X170.316 Y166.941 E.00345
; LINE_WIDTH: 0.15845
G1 X170.107 Y166.771 E.00245
; LINE_WIDTH: 0.111595
G1 X169.899 Y166.602 E.00146
; WIPE_START
G1 F15000
G1 X170.107 Y166.771 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X169.786 Y168.146 Z4.2 F60000
G1 Z3.8
G1 E.8 F1800
; LINE_WIDTH: 0.112374
G1 F2463
M204 S8000
G1 X169.597 Y167.993 E.00133
; LINE_WIDTH: 0.160768
G1 X169.409 Y167.841 E.00226
; LINE_WIDTH: 0.202106
G1 X169.198 Y167.655 E.00353
; LINE_WIDTH: 0.236427
G1 X168.988 Y167.469 E.00429
; LINE_WIDTH: 0.270749
G1 X168.778 Y167.283 E.00505
; LINE_WIDTH: 0.305372
G3 X167.717 Y166.222 I14.676 J-15.738 E.03112
; LINE_WIDTH: 0.274775
G1 X167.549 Y166.035 E.0046
; LINE_WIDTH: 0.248501
G1 X167.381 Y165.849 E.00408
; LINE_WIDTH: 0.210839
G1 X167.195 Y165.627 E.00383
; LINE_WIDTH: 0.161773
G1 X167.009 Y165.406 E.00271
; LINE_WIDTH: 0.112708
G1 X166.824 Y165.185 E.00159
; WIPE_START
G1 F15000
M73 P98 R0
G1 X167.009 Y165.406 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X168.013 Y164.716 Z4.2 F60000
G1 Z3.8
G1 E.8 F1800
; LINE_WIDTH: 0.104702
G1 F2463
M204 S8000
G1 X167.875 Y164.549 E.00106
; LINE_WIDTH: 0.137756
G1 X167.737 Y164.383 E.00162
; WIPE_START
G1 F15000
G1 X167.875 Y164.549 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X166.486 Y164.428 Z4.2 F60000
G1 Z3.8
G1 E.8 F1800
; LINE_WIDTH: 0.208745
G1 F2463
M204 S8000
G1 X166.388 Y164.295 E.00217
; LINE_WIDTH: 0.179296
G1 X166.323 Y164.203 E.00121
; LINE_WIDTH: 0.142842
G1 X166.259 Y164.111 E.00089
; LINE_WIDTH: 0.106388
G1 X166.194 Y164.019 E.00056
; WIPE_START
G1 F15000
G1 X166.259 Y164.111 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.593 Y168.369 Z4.2 F60000
G1 X172.802 Y168.51 Z4.2
G1 Z3.8
G1 E.8 F1800
; FEATURE: Bridge
; LINE_WIDTH: 0.42751
M106 S229.5
G1 F3000
M204 S8000
G1 X173.434 Y168.175 E.02174
G2 X174.111 Y168.251 I.726 J-3.401 E.02072
G1 X173.078 Y168.799 E.03552
G2 X173.24 Y169.13 I3.541 J-1.533 E.01119
G1 X173.249 Y169.144 E.00051
G1 X174.892 Y168.272 E.0565
G2 X175.317 Y168.256 I.131 J-2.164 E.01295
G1 X175.849 Y168.199 E.01625
G1 X173.495 Y169.449 E.08095
G2 X174.171 Y169.525 I.887 J-4.798 E.02067
G1 X183.225 Y164.718 E.31144
G2 X183.169 Y164.329 I-2.321 J.136 E.01195
G1 X183.165 Y164.314 E.00046
G1 X180.83 Y165.554 E.08033
G2 X181.468 Y164.78 I-7.988 J-7.236 E.0305
G1 X183.03 Y163.951 E.05372
G2 X182.843 Y163.614 I-3.55 J1.754 E.01169
G1 X181.91 Y164.11 E.03208
G1 X182.245 Y163.497 E.02122
G1 X182.753 Y163.227 E.01747
M106 S224.4
; WIPE_START
G1 X182.245 Y163.497 E-.21852
G1 X181.91 Y164.11 E-.26546
G1 X182.552 Y163.769 E-.27602
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X183.279 Y165.125 Z4.2 F60000
G1 Z3.8
G1 E.8 F1800
M106 S229.5
G1 F3000
M204 S8000
G1 X174.92 Y169.563 E.28751
G2 X175.797 Y169.533 I.224 J-6.276 E.02667
G1 X182.44 Y166.006 E.22849
G3 X181.688 Y166.84 I-6.581 J-5.171 E.03413
G1 X176.92 Y169.372 E.16401
G2 X179.204 Y168.595 I-2.238 J-10.32 E.07345
G1 X181.104 Y167.586 E.06537
M106 S224.4
; close powerlost recovery
M1003 S0
; WIPE_START
G1 F3000
G1 X179.338 Y168.524 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z4.2 I1.217 J0 P1  F60000
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
G1 Z4.2 F900 ; lower z a little
M1002 judge_flag timelapse_record_flag
M622 J1
    G150.3
    M400 ; wait all motion done
    M991 S0 P-1 ;end smooth timelapse at safe pos
    M400 S5 ;wait for last picture to be taken
M623  ;end of "timelapse_record_flag"

G90
G1 Z13.8 F900 ; lower z a little

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

    
        G1 Z101.9 F600
        G1 Z99.9
    

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

