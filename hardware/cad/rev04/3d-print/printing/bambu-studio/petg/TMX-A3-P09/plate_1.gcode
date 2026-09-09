; HEADER_BLOCK_START
; BambuStudio 02.08.02.61
; model printing time: 4m 54s; total estimated time: 10m 22s
; total layer number: 29
; total filament length [mm] : 212.17
; total filament volume [cm^3] : 510.34
; total filament weight [g] : 0.65
; filament_density: 1.27
; filament_diameter: 1.75
; max_z_height: 4.40
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
M73 P0 R10
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
M73 P7 R9
G1 Z5 F1200
G90
G1 X175 Y160 F30000

M622 J1
    M1002 gcode_claim_action : 1
    G29.20 A3
    G29 A1 O X161.193 Y150.693 I27.6131 J18.6131 R
    M400
M623

M622 J2
    M1002 gcode_claim_action : 1
    
        G29.20 A4
        G29 A2 O X161.193 Y150.693 I27.6131 J18.6131 R
    
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
M73 P49 R5
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
M73 P50 R5
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
; layer num/total_layer_count: 1/29
; update layer progress
M73 L1
M991 S0 P0 ;notify layer change

M106 S0
M106 P2 S0
; OBJECT_ID: 15
M73 P51 R5
G1 X181.05 Y162.55 F60000
M204 S6000
M73 P52 R4
G1 Z.4
G1 Z.2
G1 E.8 F1800
; FEATURE: Support
; LINE_WIDTH: 0.5
G1 F3000
M204 S500
G1 X168.95 Y162.55 E.43688
G1 X168.95 Y156.45 E.22025
G1 X181.05 Y156.45 E.43688
G1 X181.05 Y162.481 E.21777
M204 S6000
G1 X171.802 Y159.8 F60000
G1 F3000
M204 S500
G1 X171.801 Y159.2 E.02165
G1 X178.198 Y159.2 E.23099
G1 X178.199 Y159.8 E.02165
G1 X171.87 Y159.8 E.22852
M204 S6000
G1 X180.586 Y162.344 F60000
G1 F3000
M204 S500
G1 X180.586 Y156.861 E.19797
G1 X180.079 Y156.861 E.01834
G1 X180.079 Y162.139 E.19054
G1 X179.571 Y162.139 E.01834
G1 X179.571 Y156.861 E.19054
G1 X179.063 Y156.861 E.01834
G1 X179.063 Y162.139 E.19054
G1 X178.555 Y162.139 E.01834
G1 X178.555 Y156.861 E.19054
G1 X178.047 Y156.861 E.01834
G1 X178.047 Y158.789 E.0696
G1 X177.539 Y158.789 E.01834
M73 P53 R4
G1 X177.539 Y156.861 E.0696
G1 X177.031 Y156.861 E.01834
G1 X177.031 Y158.789 E.06959
G1 X176.524 Y158.789 E.01834
G1 X176.524 Y156.861 E.06959
G1 X176.016 Y156.861 E.01834
G1 X176.016 Y158.789 E.06959
G1 X175.508 Y158.789 E.01834
G1 X175.508 Y156.861 E.06959
G1 X175 Y156.861 E.01834
G1 X175 Y158.789 E.06959
G1 X174.492 Y158.789 E.01834
G1 X174.492 Y156.861 E.06959
G1 X173.984 Y156.861 E.01834
G1 X173.984 Y158.789 E.06959
G1 X173.476 Y158.789 E.01834
G1 X173.476 Y156.861 E.06959
G1 X172.969 Y156.861 E.01834
G1 X172.969 Y158.789 E.06959
G1 X172.461 Y158.789 E.01834
G1 X172.461 Y156.861 E.06959
G1 X171.953 Y156.861 E.01834
G1 X171.953 Y158.994 E.07701
; WIPE_START
G1 X171.953 Y156.994 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X177.689 Y162.03 Z.6 F60000
G1 X178.047 Y162.344 Z.6
G1 Z.2
G1 E.8 F1800
G1 F3000
M204 S500
G1 X178.047 Y160.211 E.07701
G1 X177.539 Y160.211 E.01834
G1 X177.539 Y162.139 E.06959
G1 X177.031 Y162.139 E.01834
G1 X177.031 Y160.211 E.06959
G1 X176.524 Y160.211 E.01834
G1 X176.524 Y162.139 E.06959
G1 X176.016 Y162.139 E.01834
G1 X176.016 Y160.211 E.06959
G1 X175.508 Y160.211 E.01834
G1 X175.508 Y162.139 E.06959
G1 X175 Y162.139 E.01834
G1 X175 Y160.211 E.06959
G1 X174.492 Y160.211 E.01834
G1 X174.492 Y162.139 E.06959
G1 X173.984 Y162.139 E.01834
G1 X173.984 Y160.211 E.06959
G1 X173.476 Y160.211 E.01834
G1 X173.476 Y162.139 E.06959
G1 X172.969 Y162.139 E.01834
G1 X172.969 Y160.211 E.06959
G1 X172.461 Y160.211 E.01834
G1 X172.461 Y162.139 E.0696
G1 X171.953 Y162.139 E.01834
G1 X171.953 Y160.005 E.07702
M204 S6000
G1 X171.445 Y162.344 F60000
G1 F3000
M204 S500
G1 X171.445 Y156.861 E.19797
G1 X170.937 Y156.861 E.01834
G1 X170.937 Y162.139 E.19054
G1 X170.429 Y162.139 E.01834
G1 X170.429 Y156.861 E.19054
G1 X169.921 Y156.861 E.01834
G1 X169.921 Y162.139 E.19054
G1 X169.414 Y162.139 E.01834
G1 X169.414 Y156.656 E.19797
; WIPE_START
G1 X169.414 Y158.656 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X169.414 Y151.023 Z.6 F60000
G1 X169.414 Y150.922 Z.6
G1 Z.2
G1 E.8 F1800
; FEATURE: Brim
G1 F3000
M204 S500
G1 X184.991 Y150.922 E.56243
G1 X185.56 Y150.969 E.02062
G1 X186.375 Y151.211 E.03072
G1 X186.98 Y151.526 E.0246
G1 X187.426 Y151.872 E.02039
G1 X187.81 Y152.288 E.02045
G1 X188.122 Y152.762 E.02048
G1 X188.339 Y153.243 E.01907
G1 X188.502 Y153.787 E.0205
G1 X188.578 Y154.512 E.02632
G1 X188.578 Y165.491 E.39639
G1 X188.531 Y166.06 E.02062
G1 X188.289 Y166.875 E.03072
G1 X187.974 Y167.48 E.0246
G1 X187.628 Y167.926 E.02039
G1 X187.212 Y168.31 E.02045
G1 X186.738 Y168.622 E.02048
G1 X186.257 Y168.839 E.01907
G1 X185.713 Y169.002 E.0205
G1 X184.988 Y169.078 E.02632
G1 X165.009 Y169.078 E.72134
G1 X164.44 Y169.031 E.02062
G1 X163.529 Y168.748 E.03446
G1 X163.022 Y168.475 E.02079
G1 X162.574 Y168.128 E.02045
M73 P54 R4
G1 X162.19 Y167.712 E.02045
G1 X161.878 Y167.238 E.02048
G1 X161.661 Y166.757 E.01907
G1 X161.498 Y166.213 E.0205
G1 X161.422 Y165.488 E.02632
G1 X161.422 Y154.509 E.3964
G1 X161.469 Y153.94 E.02062
G1 X161.752 Y153.029 E.03446
G1 X162.025 Y152.522 E.02079
G1 X162.372 Y152.074 E.02045
G1 X162.788 Y151.69 E.02045
G1 X163.262 Y151.378 E.02048
G1 X163.743 Y151.161 E.01907
G1 X164.287 Y150.998 E.0205
G1 X165.012 Y150.922 E.02632
G1 X169.354 Y150.922 E.15676
M204 S6000
G1 X169.354 Y151.379 F60000
G1 F3000
M204 S500
G1 X184.977 Y151.38 E.56412
G1 X185.489 Y151.425 E.01853
G1 X186.191 Y151.633 E.02644
G1 X186.721 Y151.906 E.02155
G1 X187.107 Y152.203 E.01757
G1 X187.441 Y152.562 E.0177
G1 X187.714 Y152.974 E.01784
G1 X187.912 Y153.412 E.01739
G1 X188.053 Y153.89 E.01798
G1 X188.121 Y154.543 E.0237
G1 X188.12 Y165.477 E.39479
G1 X188.075 Y165.989 E.01853
G1 X187.857 Y166.715 E.02739
G1 X187.58 Y167.242 E.02149
G1 X187.282 Y167.624 E.0175
G1 X186.921 Y167.955 E.0177
G1 X186.508 Y168.224 E.0178
G1 X186.088 Y168.412 E.01661
G1 X185.61 Y168.553 E.01798
G1 X184.957 Y168.621 E.0237
G1 X165.034 Y168.621 E.71934
G1 X164.514 Y168.575 E.01887
G1 X163.695 Y168.318 E.03099
G1 X163.263 Y168.084 E.01774
G1 X162.893 Y167.797 E.0169
G1 X162.545 Y167.421 E.01852
G1 X162.276 Y167.008 E.0178
G1 X162.088 Y166.588 E.01661
G1 X161.947 Y166.11 E.01798
G1 X161.879 Y165.457 E.0237
G1 X161.879 Y154.534 E.39439
G1 X161.925 Y154.014 E.01886
G1 X162.182 Y153.195 E.03099
G1 X162.416 Y152.763 E.01774
G1 X162.703 Y152.393 E.0169
G1 X163.079 Y152.045 E.01852
G1 X163.492 Y151.776 E.0178
G1 X163.912 Y151.588 E.01661
G1 X164.39 Y151.447 E.01798
G1 X165.043 Y151.379 E.0237
G1 X169.294 Y151.379 E.15347
M204 S6000
G1 X169.293 Y151.836 F60000
G1 F3000
M204 S500
G1 X184.951 Y151.837 E.56534
G1 X185.416 Y151.88 E.01685
G1 X186.007 Y152.055 E.02227
G1 X186.464 Y152.288 E.01853
G1 X186.789 Y152.535 E.01474
G1 X187.073 Y152.837 E.01496
G1 X187.306 Y153.186 E.01516
G1 X187.486 Y153.581 E.01565
G1 X187.604 Y153.992 E.01543
G1 X187.664 Y154.574 E.02113
G1 X187.663 Y165.463 E.39317
G1 X187.62 Y165.915 E.0164
G1 X187.426 Y166.553 E.02407
G1 X187.187 Y167.003 E.01838
G1 X186.937 Y167.32 E.01461
G1 X186.63 Y167.599 E.01496
G1 X186.278 Y167.826 E.01512
G1 X185.92 Y167.985 E.01415
G1 X185.508 Y168.104 E.01547
G1 X184.926 Y168.164 E.02113
G1 X165.06 Y168.164 E.71728
G1 X164.589 Y168.12 E.01709
G1 X163.862 Y167.889 E.02753
G1 X163.523 Y167.705 E.01392
G1 X163.212 Y167.466 E.01418
G1 X162.9 Y167.129 E.01657
G1 X162.674 Y166.778 E.01508
G1 X162.515 Y166.42 E.01415
G1 X162.396 Y166.008 E.01547
G1 X162.336 Y165.426 E.02113
G1 X162.336 Y154.56 E.39234
G1 X162.38 Y154.089 E.01709
G1 X162.611 Y153.362 E.02753
G1 X162.795 Y153.023 E.01392
G1 X163.034 Y152.712 E.01418
G1 X163.371 Y152.4 E.01657
G1 X163.722 Y152.174 E.01508
G1 X164.08 Y152.015 E.01415
G1 X164.492 Y151.896 E.01547
G1 X165.074 Y151.836 E.02113
G1 X169.233 Y151.836 E.1502
M204 S6000
G1 X169.233 Y152.293 F60000
G1 F3000
M204 S500
G1 X184.923 Y152.294 E.5665
G1 X185.342 Y152.335 E.01517
G1 X185.825 Y152.478 E.0182
G1 X186.21 Y152.671 E.01555
G1 X186.49 Y152.884 E.01273
G1 X186.72 Y153.132 E.0122
G1 X186.899 Y153.4 E.01163
G1 X187.052 Y153.731 E.01315
G1 X187.155 Y154.091 E.01354
G1 X187.206 Y154.59 E.0181
G1 X187.205 Y165.448 E.39203
G1 X187.165 Y165.839 E.01421
G1 X186.995 Y166.389 E.02078
G1 X186.795 Y166.761 E.01526
G1 X186.593 Y167.015 E.01171
G1 X186.341 Y167.242 E.01223
G1 X186.05 Y167.427 E.01245
G1 X185.754 Y167.558 E.01169
G1 X185.409 Y167.655 E.01295
G1 X184.896 Y167.707 E.01861
G1 X165.088 Y167.707 E.71518
G1 X164.666 Y167.665 E.0153
G1 X164.03 Y167.46 E.02412
G1 X163.764 Y167.314 E.01096
G1 X163.53 Y167.134 E.01066
G1 X163.257 Y166.838 E.01457
G1 X163.073 Y166.55 E.01232
G1 X162.942 Y166.254 E.01169
G1 X162.845 Y165.909 E.01295
G1 X162.793 Y165.396 E.01861
G1 X162.793 Y154.588 E.39024
G1 X162.835 Y154.166 E.0153
G1 X163.04 Y153.53 E.02412
G1 X163.186 Y153.264 E.01096
G1 X163.366 Y153.03 E.01066
G1 X163.662 Y152.757 E.01457
G1 X163.95 Y152.573 E.01232
G1 X164.246 Y152.442 E.01169
G1 X164.591 Y152.345 E.01295
G1 X165.104 Y152.293 E.01861
G1 X169.173 Y152.293 E.14693
M204 S6000
G1 X169.173 Y152.75 F60000
G1 F3000
M204 S500
G1 X184.966 Y152.75 E.57021
G1 X185.483 Y152.84 E.01896
G1 X185.853 Y153.001 E.01456
G1 X186.229 Y153.282 E.01693
M73 P55 R4
G1 X186.441 Y153.543 E.01216
G1 X186.544 Y153.72 E.00738
G1 X186.633 Y153.927 E.00816
G1 X186.75 Y154.536 E.02238
G1 X186.75 Y165.466 E.39463
G1 X186.66 Y165.984 E.01896
G1 X186.499 Y166.353 E.01456
G1 X186.218 Y166.729 E.01693
G1 X185.957 Y166.941 E.01216
G1 X185.78 Y167.044 E.00738
G1 X185.573 Y167.133 E.00816
G1 X184.964 Y167.25 E.02238
G1 X165.034 Y167.25 E.71959
G1 X164.516 Y167.16 E.01896
G1 X164.147 Y166.999 E.01456
G1 X163.771 Y166.718 E.01693
G1 X163.559 Y166.457 E.01215
G1 X163.456 Y166.28 E.00739
G1 X163.367 Y166.073 E.00816
G1 X163.25 Y165.464 E.02238
G1 X163.25 Y154.53 E.39479
G1 X163.305 Y154.138 E.01428
G1 X163.404 Y153.831 E.01164
G1 X163.495 Y153.654 E.00718
G1 X163.782 Y153.271 E.01727
G1 X164.042 Y153.06 E.0121
G1 X164.296 Y152.919 E.01051
G1 X164.528 Y152.837 E.00886
G1 X165.035 Y152.75 E.01858
G1 X169.113 Y152.75 E.14726
M204 S6000
G1 X169.113 Y153.207 F60000
G1 F3000
M204 S500
G1 X184.978 Y153.207 E.5728
G1 X185.306 Y153.26 E.012
G1 X185.582 Y153.369 E.0107
G1 X185.877 Y153.573 E.01297
G1 X186.041 Y153.765 E.0091
G1 X186.154 Y153.958 E.00808
G1 X186.212 Y154.105 E.00572
G1 X186.293 Y154.523 E.01536
G1 X186.293 Y165.478 E.39553
G1 X186.239 Y165.806 E.01201
G1 X186.131 Y166.082 E.01069
G1 X185.927 Y166.377 E.01297
G1 X185.735 Y166.541 E.00911
G1 X185.542 Y166.654 E.00807
G1 X185.395 Y166.712 E.00572
G1 X184.977 Y166.793 E.01536
G1 X165.022 Y166.793 E.72048
G1 X164.694 Y166.739 E.01201
G1 X164.418 Y166.631 E.01069
G1 X164.123 Y166.427 E.01297
G1 X163.959 Y166.235 E.00911
G1 X163.846 Y166.042 E.00808
G1 X163.788 Y165.895 E.00572
G1 X163.707 Y165.477 E.01536
G1 X163.707 Y154.52 E.3956
G1 X163.739 Y154.279 E.00878
G1 X163.814 Y154.032 E.00932
G1 X163.866 Y153.922 E.00439
G1 X164.073 Y153.623 E.01314
G1 X164.265 Y153.459 E.00911
G1 X164.458 Y153.346 E.00808
G1 X164.605 Y153.288 E.00572
G1 X165.023 Y153.207 E.01536
G1 X169.053 Y153.207 E.14552
M204 S6000
G1 X169.053 Y153.664 F60000
G1 F3000
M204 S500
G1 X184.989 Y153.664 E.57537
G1 X185.155 Y153.691 E.00607
G1 X185.33 Y153.75 E.00666
G1 X185.542 Y153.883 E.00905
G1 X185.64 Y153.985 E.00513
G1 X185.765 Y154.198 E.0089
G1 X185.836 Y154.51 E.01155
G1 X185.836 Y165.489 E.3964
G1 X185.809 Y165.655 E.00607
G1 X185.75 Y165.83 E.00666
G1 X185.617 Y166.042 E.00905
G1 X185.515 Y166.14 E.00513
G1 X185.302 Y166.265 E.0089
G1 X184.99 Y166.336 E.01155
G1 X165.011 Y166.336 E.72136
G1 X164.845 Y166.309 E.00607
G1 X164.67 Y166.25 E.00666
G1 X164.458 Y166.117 E.00905
G1 X164.36 Y166.015 E.00513
G1 X164.235 Y165.802 E.0089
G1 X164.164 Y165.49 E.01155
G1 X164.164 Y154.511 E.3964
G1 X164.191 Y154.345 E.00607
G1 X164.25 Y154.17 E.00666
G1 X164.383 Y153.958 E.00905
G1 X164.485 Y153.86 E.00513
G1 X164.698 Y153.735 E.0089
G1 X165.01 Y153.664 E.01155
G1 X168.993 Y153.664 E.14382
M204 S6000
G1 X168.993 Y154.121 F60000
G1 F3000
M204 S500
G1 X185 Y154.121 E.57793
G1 X185.201 Y154.188 E.00766
G1 X185.323 Y154.314 E.00631
G1 X185.379 Y154.5 E.007
G1 X185.379 Y165.5 E.39717
G1 X185.312 Y165.701 E.00766
G1 X185.186 Y165.823 E.00631
G1 X185 Y165.879 E.007
G1 X165 Y165.879 E.72212
G1 X164.799 Y165.812 E.00766
G1 X164.677 Y165.686 E.00631
G1 X164.621 Y165.5 E.007
G1 X164.621 Y154.5 E.39717
G1 X164.688 Y154.299 E.00766
G1 X164.814 Y154.177 E.00631
G1 X165 Y154.121 E.007
G1 X168.933 Y154.121 E.14202
; WIPE_START
G1 X170.933 Y154.121 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X176.884 Y158.901 Z.6 F60000
G1 X184.6 Y165.1 Z.6
G1 Z.2
G1 E.8 F1800
; FEATURE: Outer wall
G1 F3000
M204 S500
M73 P56 R4
G1 X165.4 Y165.1 E.69324
G1 X165.4 Y154.9 E.36828
G1 X184.6 Y154.9 E.69324
G1 X184.6 Y165.04 E.36612
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
G1 X182.6 Y165.046 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X181.9 Y163.857 Z.6 F60000
G1 Z.2
G1 E.8 F1800
; FEATURE: Inner wall
G1 F3000
M204 S500
G1 X182.357 Y163.857 E.0165
G1 X182.357 Y155.357 E.3069
G1 X184.143 Y155.357 E.06448
G1 X184.143 Y164.643 E.33528
G1 X165.857 Y164.643 E.66023
G1 X165.857 Y155.357 E.33528
G1 X167.643 Y155.357 E.06448
G1 X167.643 Y163.857 E.3069
G1 X181.84 Y163.857 E.5126
; WIPE_START
G1 X182.357 Y163.857 E-.19649
G1 X182.357 Y162.374 E-.56351
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X183.686 Y164.186 Z.6 F60000
G1 Z.2
G1 E.8 F1800
G1 F3000
M204 S500
G1 X182.814 Y164.186 E.03147
G1 X182.814 Y155.814 E.30227
G1 X183.686 Y155.814 E.03147
G1 X183.686 Y164.126 E.3001
; WIPE_START
G1 X182.814 Y164.186 E-.33204
G1 X182.814 Y163.06 E-.42796
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X175.183 Y163.226 Z.6 F60000
G1 X167.186 Y163.4 Z.6
G1 Z.2
G1 E.8 F1800
G1 F3000
M204 S500
G1 X167.186 Y164.186 E.02837
G1 X166.314 Y164.186 E.03147
G1 X166.314 Y155.814 E.30227
G1 X167.186 Y155.814 E.03147
G1 X167.186 Y163.34 E.27173
; WIPE_START
G1 X167.186 Y164.186 E-.32143
G1 X166.314 Y164.186 E-.33126
G1 X166.314 Y163.903 E-.10731
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X173.943 Y163.657 Z.6 F60000
G1 X181.9 Y163.4 Z.6
G1 Z.2
G1 E.8 F1800
; FEATURE: Outer wall
G1 F3000
M204 S500
G1 X168.1 Y163.4 E.49826
G1 X168.1 Y155.6 E.28163
G1 X181.9 Y155.6 E.49826
G1 X181.9 Y163.34 E.27946
; WIPE_START
G1 X179.9 Y163.349 E-.76
; WIPE_END
M73 P57 R4
G1 E-.04 F1800
M204 S6000
G1 X182.586 Y164.25 Z.6 F60000
G1 Z.2
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.37172
G1 F3000
M204 S500
G1 X167.414 Y164.25 E.39403
M204 S6000
G1 X166.75 Y163.957 F60000
; LINE_WIDTH: 0.45758
G1 F3000
M204 S500
G1 X166.75 Y156.043 E.25925
; WIPE_START
G1 X166.75 Y158.043 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X167.872 Y155.25 Z.6 F60000
G1 Z.2
G1 E.8 F1800
; LINE_WIDTH: 0.28586
G1 F3000
M204 S500
G1 X182.128 Y155.25 E.2736
; WIPE_START
G1 X180.128 Y155.25 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X183.25 Y156.043 Z.6 F60000
G1 Z.2
G1 E.8 F1800
; LINE_WIDTH: 0.45758
G1 F3000
M204 S500
G1 X183.25 Y163.957 E.25925
; CHANGE_LAYER
; Z_HEIGHT: 0.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F3000
G1 X183.25 Y161.957 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 2/29
; update layer progress
M73 L2
M991 S0 P1 ;notify layer change

; open powerlost recovery
M1003 S1
; OBJECT_ID: 15
M204 S10000
G17
G3 Z.6 I-.888 J-.832 P1  F60000
G1 X181.71 Y163.602 Z.6
G1 Z.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1789
M204 S8000
G1 X167.898 Y163.602 E.44415
G1 X167.898 Y155.398 E.26382
G1 X182.102 Y155.398 E.45675
G1 X182.102 Y163.602 E.26382
G1 X181.77 Y163.602 E.01068
M204 S250
G1 X181.71 Y163.21 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1789
M204 S5000
G1 X168.29 Y163.21 E.39974
G1 X168.29 Y155.79 E.22102
G1 X181.71 Y155.79 E.39974
G1 X181.71 Y163.15 E.21923
; WIPE_START
G1 F9547.055
M204 S8000
G1 X179.71 Y163.159 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.078 Y163.19 Z.8 F60000
G1 X167.084 Y163.21 Z.8
G1 Z.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1789
M204 S8000
G1 X167.084 Y164.084 E.0281
G1 X166.416 Y164.084 E.02147
G1 X166.416 Y155.916 E.26264
G1 X167.084 Y155.916 E.02147
G1 X167.084 Y163.15 E.23261
; WIPE_START
G1 F8843.478
M73 P58 R4
G1 X167.084 Y164.084 E-.35484
G1 X166.416 Y164.084 E-.25368
G1 X166.416 Y163.685 E-.15147
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X174.047 Y163.862 Z.8 F60000
G1 X183.584 Y164.084 Z.8
G1 Z.4
G1 E.8 F1800
G1 F1789
M204 S8000
G1 X182.916 Y164.084 E.02147
G1 X182.916 Y155.916 E.26264
G1 X183.584 Y155.916 E.02147
G1 X183.584 Y164.024 E.26071
; WIPE_START
G1 F8843.478
G1 X182.916 Y164.084 E-.25471
G1 X182.916 Y162.754 E-.50529
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X181.71 Y164.009 Z.8 F60000
G1 Z.4
G1 E.8 F1800
G1 F1789
M204 S8000
G1 X182.509 Y164.009 E.0257
G1 X182.509 Y155.509 E.27333
G1 X183.991 Y155.509 E.04765
G1 X183.991 Y164.491 E.28882
G1 X166.009 Y164.491 E.57823
G1 X166.009 Y155.509 E.28882
G1 X167.491 Y155.509 E.04765
G1 X167.491 Y164.009 E.27333
G1 X181.65 Y164.009 E.45531
; WIPE_START
G1 F8843.478
G1 X182.509 Y164.009 E-.32647
G1 X182.509 Y162.868 E-.43353
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X184.398 Y164.898 Z.8 F60000
G1 Z.4
G1 E.8 F1800
G1 F1789
M204 S8000
G1 X165.602 Y164.898 E.60441
G1 X165.602 Y155.102 E.315
G1 X184.398 Y155.102 E.60441
G1 X184.398 Y164.838 E.31307
M204 S250
G1 X184.79 Y165.29 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1789
M204 S5000
G1 X165.21 Y165.29 E.58322
G1 X165.21 Y154.71 E.31514
G1 X184.79 Y154.71 E.58322
G1 X184.79 Y165.23 E.31336
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
M73 P59 R4
G1 F9547.055
M204 S8000
G1 X182.79 Y165.236 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X183.25 Y163.88 Z.8 F60000
G1 Z.4
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.30344
G1 F1789
M204 S8000
G1 X183.25 Y156.12 E.15971
; WIPE_START
G1 F13818.517
G1 X183.25 Y158.12 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X182.713 Y164.25 Z.8 F60000
G1 Z.4
G1 E.8 F1800
; LINE_WIDTH: 0.11758
G1 F1789
M204 S8000
G1 X167.287 Y164.25 E.09097
M204 S10000
G1 X166.75 Y163.88 F60000
; LINE_WIDTH: 0.30344
G1 F1789
M204 S8000
G1 X166.75 Y156.12 E.15971
; CHANGE_LAYER
; Z_HEIGHT: 0.475
; LAYER_HEIGHT: 0.075
; WIPE_START
G1 F13818.517
G1 X166.75 Y158.12 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 3/29
; update layer progress
M73 L3
M991 S0 P2 ;notify layer change

; OBJECT_ID: 15
M204 S10000
G17
G3 Z.8 I-.723 J.979 P1  F60000
G1 X169.039 Y159.811 Z.8
G1 Z.475
G1 E.8 F1800
; FEATURE: Support
; LINE_WIDTH: 0.42
; LAYER_HEIGHT: 0.275
G1 F2061
M204 S8000
G1 X169.039 Y157.123 E.10541
G1 X180.961 Y157.123 E.46748
G1 X180.961 Y159.811 E.10541
; WIPE_START
G1 F7252.893
G1 X180.961 Y157.811 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z.875 I-.235 J-1.194 P1  F60000
G1 X169.864 Y160 Z.875
G1 Z.475
G1 E.8 F1800
G1 F2061
M204 S8000
G1 X169.039 Y160 E.03235
G1 X169.039 Y162.461 E.09651
G1 X180.961 Y162.461 E.46748
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

G1 X180.961 Y160 E.09651
G1 X180.138 Y160 E.03228
G3 X179.966 Y160.627 I-.841 J.106 E.02615
G1 X179.029 Y161.565 E.05199
G1 X178.612 Y161.738 E.01773
G1 X171.146 Y161.738 E.29272
G1 X169.865 Y160.459 E.07099
G1 X169.864 Y160.189 E.01061
; CHANGE_LAYER
; Z_HEIGHT: 0.6
; LAYER_HEIGHT: 0.125
; WIPE_START
G1 F7252.893
G1 X169.865 Y160.459 E-.10281
G1 X171.089 Y161.681 E-.65719
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 4/29
; update layer progress
M73 L4
M991 S0 P3 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z.875 I-.217 J1.198 P1  F60000
G1 X181.71 Y163.602 Z.875
G1 Z.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
; LAYER_HEIGHT: 0.2
G1 F2061
M204 S8000
G1 X167.898 Y163.602 E.44415
G1 X167.898 Y155.398 E.26382
G1 X182.102 Y155.398 E.45675
G1 X182.102 Y163.602 E.26382
G1 X181.77 Y163.602 E.01068
; COOLING_NODE: 0
M204 S250
G1 X181.71 Y163.21 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1951
M204 S5000
M73 P60 R4
G1 X168.29 Y163.21 E.39974
G1 X168.29 Y155.79 E.22102
G1 X181.71 Y155.79 E.39974
G1 X181.71 Y163.15 E.21923
; COOLING_NODE: 0
; WIPE_START
G1 F9547.055
M204 S8000
G1 X179.71 Y163.159 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.078 Y163.19 Z1 F60000
G1 X167.084 Y163.21 Z1
G1 Z.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2061
M204 S8000
G1 X167.084 Y164.084 E.0281
G1 X166.416 Y164.084 E.02147
G1 X166.416 Y155.916 E.26264
G1 X167.084 Y155.916 E.02147
G1 X167.084 Y163.15 E.23261
; COOLING_NODE: 0
; WIPE_START
G1 F8843.478
G1 X167.084 Y164.084 E-.35484
G1 X166.416 Y164.084 E-.25368
G1 X166.416 Y163.685 E-.15147
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X174.047 Y163.862 Z1 F60000
G1 X183.584 Y164.084 Z1
G1 Z.6
G1 E.8 F1800
G1 F2061
M204 S8000
G1 X182.916 Y164.084 E.02147
G1 X182.916 Y155.916 E.26264
G1 X183.584 Y155.916 E.02147
G1 X183.584 Y164.024 E.26071
; COOLING_NODE: 0
; WIPE_START
G1 F8843.478
G1 X182.916 Y164.084 E-.25471
G1 X182.916 Y162.754 E-.50529
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X181.71 Y164.009 Z1 F60000
G1 Z.6
G1 E.8 F1800
G1 F2061
M204 S8000
G1 X182.509 Y164.009 E.0257
G1 X182.509 Y155.509 E.27333
G1 X183.991 Y155.509 E.04765
G1 X183.991 Y164.491 E.28882
G1 X166.009 Y164.491 E.57823
G1 X166.009 Y155.509 E.28882
G1 X167.491 Y155.509 E.04765
G1 X167.491 Y164.009 E.27333
G1 X181.65 Y164.009 E.45531
; COOLING_NODE: 0
; WIPE_START
G1 F8843.478
G1 X182.509 Y164.009 E-.32647
G1 X182.509 Y162.868 E-.43353
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X184.398 Y164.898 Z1 F60000
G1 Z.6
G1 E.8 F1800
G1 F2061
M204 S8000
G1 X165.602 Y164.898 E.60441
G1 X165.602 Y155.102 E.315
G1 X184.398 Y155.102 E.60441
G1 X184.398 Y164.838 E.31307
; COOLING_NODE: 1
M204 S250
G1 X184.79 Y165.29 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
M73 P61 R4
G1 F1962
M204 S5000
G1 X165.21 Y165.29 E.58322
G1 X165.21 Y154.71 E.31514
G1 X184.79 Y154.71 E.58322
G1 X184.79 Y165.23 E.31336
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
G1 X182.79 Y165.236 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X183.25 Y163.88 Z1 F60000
G1 Z.6
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.30344
G1 F2061
M204 S8000
G1 X183.25 Y156.12 E.15971
; WIPE_START
G1 F13818.517
G1 X183.25 Y158.12 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
M73 P61 R3
G1 X182.713 Y164.25 Z1 F60000
G1 Z.6
G1 E.8 F1800
; LINE_WIDTH: 0.11758
G1 F2061
M204 S8000
G1 X167.287 Y164.25 E.09097
M204 S10000
G1 X166.75 Y163.88 F60000
; LINE_WIDTH: 0.30344
G1 F2061
M204 S8000
G1 X166.75 Y156.12 E.15971
; CHANGE_LAYER
; Z_HEIGHT: 0.75
; LAYER_HEIGHT: 0.15
; WIPE_START
G1 F13818.517
G1 X166.75 Y158.12 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 5/29
; update layer progress
M73 L5
M991 S0 P4 ;notify layer change

M106 S226.95
; OBJECT_ID: 15
M204 S10000
G17
G3 Z1 I-.723 J.979 P1  F60000
G1 X169.039 Y159.811 Z1
G1 Z.75
G1 E.8 F1800
; FEATURE: Support
; LINE_WIDTH: 0.42
; LAYER_HEIGHT: 0.275
G1 F2061
M204 S8000
G1 X169.039 Y157.123 E.10541
G1 X180.961 Y157.123 E.46748
G1 X180.961 Y159.811 E.10541
; WIPE_START
G1 F7252.893
G1 X180.961 Y157.811 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z1.15 I-.235 J-1.194 P1  F60000
G1 X169.864 Y160 Z1.15
G1 Z.75
G1 E.8 F1800
G1 F2061
M204 S8000
G1 X169.039 Y160 E.03235
G1 X169.039 Y162.461 E.09651
G1 X180.961 Y162.461 E.46748
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

G1 X180.961 Y160 E.09651
G1 X180.138 Y160 E.03228
G3 X179.966 Y160.627 I-.841 J.106 E.02615
G1 X179.029 Y161.565 E.05199
G1 X178.612 Y161.738 E.01773
G1 X171.146 Y161.738 E.29272
G1 X169.865 Y160.459 E.07099
G1 X169.864 Y160.189 E.01061
; CHANGE_LAYER
; Z_HEIGHT: 0.8
; LAYER_HEIGHT: 0.05
; WIPE_START
G1 F7252.893
G1 X169.865 Y160.459 E-.10281
G1 X171.089 Y161.681 E-.65719
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 6/29
; update layer progress
M73 L6
M991 S0 P5 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z1.15 I-.217 J1.198 P1  F60000
G1 X181.71 Y163.602 Z1.15
G1 Z.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
; LAYER_HEIGHT: 0.2
G1 F2061
M204 S8000
G1 X167.898 Y163.602 E.44415
G1 X167.898 Y155.398 E.26382
G1 X182.102 Y155.398 E.45675
G1 X182.102 Y163.602 E.26382
M73 P62 R3
G1 X181.77 Y163.602 E.01068
; COOLING_NODE: 0
M204 S250
G1 X181.71 Y163.21 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1911
M204 S5000
G1 X168.29 Y163.21 E.39974
G1 X168.29 Y155.79 E.22102
G1 X181.71 Y155.79 E.39974
G1 X181.71 Y163.15 E.21923
; COOLING_NODE: 0
; WIPE_START
G1 F9547.055
M204 S8000
G1 X179.71 Y163.159 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.078 Y163.19 Z1.2 F60000
G1 X167.084 Y163.21 Z1.2
G1 Z.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2061
M204 S8000
G1 X167.084 Y164.084 E.0281
G1 X166.416 Y164.084 E.02147
G1 X166.416 Y155.916 E.26264
G1 X167.084 Y155.916 E.02147
G1 X167.084 Y163.15 E.23261
; COOLING_NODE: 0
; WIPE_START
G1 F8843.478
G1 X167.084 Y164.084 E-.35484
G1 X166.416 Y164.084 E-.25368
G1 X166.416 Y163.685 E-.15147
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X174.047 Y163.862 Z1.2 F60000
G1 X183.584 Y164.084 Z1.2
G1 Z.8
G1 E.8 F1800
G1 F2061
M204 S8000
G1 X182.916 Y164.084 E.02147
G1 X182.916 Y155.916 E.26264
G1 X183.584 Y155.916 E.02147
G1 X183.584 Y164.024 E.26071
; COOLING_NODE: 0
; WIPE_START
G1 F8843.478
G1 X182.916 Y164.084 E-.25471
G1 X182.916 Y162.754 E-.50529
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X181.71 Y164.009 Z1.2 F60000
G1 Z.8
G1 E.8 F1800
G1 F2061
M204 S8000
G1 X182.509 Y164.009 E.0257
G1 X182.509 Y155.509 E.27333
G1 X183.991 Y155.509 E.04765
G1 X183.991 Y164.491 E.28882
G1 X166.009 Y164.491 E.57823
G1 X166.009 Y155.509 E.28882
G1 X167.491 Y155.509 E.04765
G1 X167.491 Y164.009 E.27333
G1 X181.65 Y164.009 E.45531
; COOLING_NODE: 0
; WIPE_START
G1 F8843.478
G1 X182.509 Y164.009 E-.32647
G1 X182.509 Y162.868 E-.43353
; WIPE_END
M73 P63 R3
G1 E-.04 F1800
M204 S10000
G1 X184.398 Y164.898 Z1.2 F60000
G1 Z.8
G1 E.8 F1800
G1 F2061
M204 S8000
G1 X165.602 Y164.898 E.60441
G1 X165.602 Y155.102 E.315
G1 X184.398 Y155.102 E.60441
G1 X184.398 Y164.838 E.31307
; COOLING_NODE: 1
M204 S250
G1 X184.79 Y165.29 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1936
M204 S5000
G1 X165.21 Y165.29 E.58322
G1 X165.21 Y154.71 E.31514
G1 X184.79 Y154.71 E.58322
G1 X184.79 Y165.23 E.31336
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
G1 X182.79 Y165.236 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X183.25 Y163.88 Z1.2 F60000
G1 Z.8
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.30344
G1 F2061
M204 S8000
G1 X183.25 Y156.12 E.15971
; WIPE_START
G1 F13818.517
G1 X183.25 Y158.12 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X182.713 Y164.25 Z1.2 F60000
G1 Z.8
G1 E.8 F1800
; LINE_WIDTH: 0.11758
G1 F2061
M204 S8000
G1 X167.287 Y164.25 E.09097
M204 S10000
G1 X166.75 Y163.88 F60000
; LINE_WIDTH: 0.30344
G1 F2061
M204 S8000
G1 X166.75 Y156.12 E.15971
; CHANGE_LAYER
; Z_HEIGHT: 1
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F13818.517
G1 X166.75 Y158.12 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 7/29
; update layer progress
M73 L7
M991 S0 P6 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z1.2 I-.419 J1.143 P1  F60000
G1 X181.71 Y163.602 Z1.2
G1 Z1
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1786
M204 S8000
G1 X167.898 Y163.602 E.44415
G1 X167.898 Y155.398 E.26382
G1 X182.102 Y155.398 E.45675
G1 X182.102 Y163.602 E.26382
G1 X181.77 Y163.602 E.01068
; COOLING_NODE: 0
M204 S250
G1 X181.71 Y163.21 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
M73 P64 R3
G1 F1786
M204 S5000
G1 X168.29 Y163.21 E.39974
G1 X168.29 Y155.79 E.22102
G1 X181.71 Y155.79 E.39974
G1 X181.71 Y163.15 E.21923
; COOLING_NODE: 0
; WIPE_START
G1 F9547.055
M204 S8000
G1 X179.71 Y163.159 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.078 Y163.19 Z1.4 F60000
G1 X167.084 Y163.21 Z1.4
G1 Z1
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1786
M204 S8000
G1 X167.084 Y164.084 E.0281
G1 X166.416 Y164.084 E.02147
G1 X166.416 Y155.916 E.26264
G1 X167.084 Y155.916 E.02147
G1 X167.084 Y163.15 E.23261
; COOLING_NODE: 0
; WIPE_START
G1 F8843.478
G1 X167.084 Y164.084 E-.35484
G1 X166.416 Y164.084 E-.25368
G1 X166.416 Y163.685 E-.15147
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X174.047 Y163.862 Z1.4 F60000
G1 X183.584 Y164.084 Z1.4
G1 Z1
G1 E.8 F1800
G1 F1786
M204 S8000
G1 X182.916 Y164.084 E.02147
G1 X182.916 Y155.916 E.26264
G1 X183.584 Y155.916 E.02147
G1 X183.584 Y164.024 E.26071
; COOLING_NODE: 0
; WIPE_START
G1 F8843.478
G1 X182.916 Y164.084 E-.25471
G1 X182.916 Y162.754 E-.50529
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X181.71 Y164.009 Z1.4 F60000
G1 Z1
G1 E.8 F1800
G1 F1786
M204 S8000
G1 X182.509 Y164.009 E.0257
G1 X182.509 Y155.509 E.27333
G1 X183.991 Y155.509 E.04765
G1 X183.991 Y164.491 E.28882
G1 X166.009 Y164.491 E.57823
G1 X166.009 Y155.509 E.28882
G1 X167.491 Y155.509 E.04765
G1 X167.491 Y164.009 E.27333
G1 X181.65 Y164.009 E.45531
; COOLING_NODE: 0
; WIPE_START
G1 F8843.478
G1 X182.509 Y164.009 E-.32647
G1 X182.509 Y162.868 E-.43353
; WIPE_END
M73 P65 R3
G1 E-.04 F1800
M204 S10000
G1 X184.398 Y164.898 Z1.4 F60000
G1 Z1
G1 E.8 F1800
G1 F1786
M204 S8000
G1 X165.602 Y164.898 E.60441
G1 X165.602 Y155.102 E.315
G1 X184.398 Y155.102 E.60441
G1 X184.398 Y164.838 E.31307
; COOLING_NODE: 1
M204 S250
G1 X184.79 Y165.29 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1786
M204 S5000
G1 X165.21 Y165.29 E.58322
G1 X165.21 Y154.71 E.31514
G1 X184.79 Y154.71 E.58322
G1 X184.79 Y165.23 E.31336
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
G1 X182.79 Y165.236 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X183.25 Y163.88 Z1.4 F60000
G1 Z1
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.30344
G1 F1786
M204 S8000
G1 X183.25 Y156.12 E.15971
; WIPE_START
G1 F13818.517
G1 X183.25 Y158.12 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X182.713 Y164.25 Z1.4 F60000
G1 Z1
G1 E.8 F1800
; LINE_WIDTH: 0.11758
G1 F1786
M204 S8000
G1 X167.287 Y164.25 E.09097
M204 S10000
G1 X166.75 Y163.88 F60000
; LINE_WIDTH: 0.30344
G1 F1786
M204 S8000
G1 X166.75 Y156.12 E.15971
; CHANGE_LAYER
; Z_HEIGHT: 1.025
; LAYER_HEIGHT: 0.025
; WIPE_START
G1 F13818.517
G1 X166.75 Y158.12 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 8/29
; update layer progress
M73 L8
M991 S0 P7 ;notify layer change

; OBJECT_ID: 15
M204 S10000
G17
G3 Z1.4 I-.723 J.979 P1  F60000
G1 X169.039 Y159.811 Z1.4
G1 Z1.025
G1 E.8 F1800
; FEATURE: Support
; LINE_WIDTH: 0.42
; LAYER_HEIGHT: 0.275
G1 F2061
M204 S8000
G1 X169.039 Y157.123 E.10541
G1 X180.961 Y157.123 E.46748
G1 X180.961 Y159.811 E.10541
; WIPE_START
G1 F7252.893
G1 X180.961 Y157.811 E-.76
; WIPE_END
M73 P66 R3
G1 E-.04 F1800
M204 S10000
G17
G3 Z1.425 I-.235 J-1.194 P1  F60000
G1 X169.864 Y160 Z1.425
G1 Z1.025
G1 E.8 F1800
G1 F2061
M204 S8000
G1 X169.039 Y160 E.03235
G1 X169.039 Y162.461 E.09651
G1 X180.961 Y162.461 E.46748
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

G1 X180.961 Y160 E.09651
G1 X180.138 Y160 E.03228
G3 X179.966 Y160.627 I-.841 J.106 E.02615
G1 X179.029 Y161.565 E.05199
G1 X178.612 Y161.738 E.01773
G1 X171.146 Y161.738 E.29272
G1 X169.865 Y160.459 E.07099
G1 X169.864 Y160.189 E.01061
; CHANGE_LAYER
; Z_HEIGHT: 1.2
; LAYER_HEIGHT: 0.175
; WIPE_START
G1 F7252.893
G1 X169.865 Y160.459 E-.10281
G1 X171.089 Y161.681 E-.65719
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 9/29
; update layer progress
M73 L9
M991 S0 P8 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z1.425 I-.217 J1.198 P1  F60000
G1 X181.71 Y163.602 Z1.425
G1 Z1.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
; LAYER_HEIGHT: 0.2
G1 F2061
M204 S8000
G1 X167.898 Y163.602 E.44415
G1 X167.898 Y155.398 E.26382
G1 X182.102 Y155.398 E.45675
G1 X182.102 Y163.602 E.26382
G1 X181.77 Y163.602 E.01068
; COOLING_NODE: 0
M204 S250
G1 X181.71 Y163.21 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1857
M204 S5000
G1 X168.29 Y163.21 E.39974
G1 X168.29 Y155.79 E.22102
G1 X181.71 Y155.79 E.39974
G1 X181.71 Y163.15 E.21923
; COOLING_NODE: 0
; WIPE_START
G1 F9547.055
M204 S8000
G1 X179.71 Y163.159 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.078 Y163.19 Z1.6 F60000
G1 X167.084 Y163.21 Z1.6
G1 Z1.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2061
M204 S8000
G1 X167.084 Y164.084 E.0281
G1 X166.416 Y164.084 E.02147
G1 X166.416 Y155.916 E.26264
G1 X167.084 Y155.916 E.02147
G1 X167.084 Y163.15 E.23261
; COOLING_NODE: 0
; WIPE_START
G1 F8843.478
G1 X167.084 Y164.084 E-.35484
G1 X166.416 Y164.084 E-.25368
G1 X166.416 Y163.685 E-.15147
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X174.047 Y163.862 Z1.6 F60000
G1 X183.584 Y164.084 Z1.6
G1 Z1.2
G1 E.8 F1800
G1 F2061
M204 S8000
G1 X182.916 Y164.084 E.02147
G1 X182.916 Y155.916 E.26264
G1 X183.584 Y155.916 E.02147
G1 X183.584 Y164.024 E.26071
; COOLING_NODE: 0
; WIPE_START
G1 F8843.478
G1 X182.916 Y164.084 E-.25471
G1 X182.916 Y162.754 E-.50529
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X181.71 Y164.009 Z1.6 F60000
G1 Z1.2
G1 E.8 F1800
G1 F2061
M204 S8000
G1 X182.509 Y164.009 E.0257
G1 X182.509 Y155.509 E.27333
G1 X183.991 Y155.509 E.04765
G1 X183.991 Y164.491 E.28882
G1 X166.009 Y164.491 E.57823
G1 X166.009 Y155.509 E.28882
G1 X167.491 Y155.509 E.04765
M73 P67 R3
G1 X167.491 Y164.009 E.27333
G1 X181.65 Y164.009 E.45531
; COOLING_NODE: 0
; WIPE_START
G1 F8843.478
G1 X182.509 Y164.009 E-.32647
G1 X182.509 Y162.868 E-.43353
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X184.398 Y164.898 Z1.6 F60000
G1 Z1.2
G1 E.8 F1800
G1 F2061
M204 S8000
G1 X165.602 Y164.898 E.60441
G1 X165.602 Y155.102 E.315
G1 X184.398 Y155.102 E.60441
G1 X184.398 Y164.838 E.31307
; COOLING_NODE: 1
M204 S250
G1 X184.79 Y165.29 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1940
M204 S5000
G1 X165.21 Y165.29 E.58322
G1 X165.21 Y154.71 E.31514
G1 X184.79 Y154.71 E.58322
G1 X184.79 Y165.23 E.31336
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
G1 X182.79 Y165.236 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X183.25 Y163.88 Z1.6 F60000
G1 Z1.2
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.30344
G1 F2061
M204 S8000
G1 X183.25 Y156.12 E.15971
; WIPE_START
G1 F13818.517
G1 X183.25 Y158.12 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X182.713 Y164.25 Z1.6 F60000
G1 Z1.2
G1 E.8 F1800
; LINE_WIDTH: 0.11758
G1 F2061
M204 S8000
G1 X167.287 Y164.25 E.09097
M204 S10000
G1 X166.75 Y163.88 F60000
; LINE_WIDTH: 0.30344
G1 F2061
M204 S8000
G1 X166.75 Y156.12 E.15971
; CHANGE_LAYER
; Z_HEIGHT: 1.3
; LAYER_HEIGHT: 0.0999999
; WIPE_START
M73 P68 R3
G1 F13818.517
G1 X166.75 Y158.12 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 10/29
; update layer progress
M73 L10
M991 S0 P9 ;notify layer change

; OBJECT_ID: 15
M204 S10000
G17
G3 Z1.6 I-.723 J.979 P1  F60000
G1 X169.039 Y159.811 Z1.6
G1 Z1.3
G1 E.8 F1800
; FEATURE: Support
; LINE_WIDTH: 0.42
; LAYER_HEIGHT: 0.275
G1 F2061
M204 S8000
G1 X169.039 Y157.123 E.10541
G1 X180.961 Y157.123 E.46748
G1 X180.961 Y159.811 E.10541
; WIPE_START
G1 F7252.893
G1 X180.961 Y157.811 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z1.7 I-.235 J-1.194 P1  F60000
G1 X169.864 Y160 Z1.7
G1 Z1.3
G1 E.8 F1800
G1 F2061
M204 S8000
G1 X169.039 Y160 E.03235
G1 X169.039 Y162.461 E.09651
G1 X180.961 Y162.461 E.46748
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

G1 X180.961 Y160 E.09651
G1 X180.138 Y160 E.03228
G3 X179.966 Y160.627 I-.841 J.106 E.02615
G1 X179.029 Y161.565 E.05199
G1 X178.612 Y161.738 E.01773
G1 X171.146 Y161.738 E.29272
G1 X169.865 Y160.459 E.07099
G1 X169.864 Y160.189 E.01061
; CHANGE_LAYER
; Z_HEIGHT: 1.4
; LAYER_HEIGHT: 0.1
; WIPE_START
G1 F7252.893
G1 X169.865 Y160.459 E-.10281
G1 X171.089 Y161.681 E-.65719
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 11/29
; update layer progress
M73 L11
M991 S0 P10 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z1.7 I-.217 J1.198 P1  F60000
G1 X181.71 Y163.602 Z1.7
G1 Z1.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
; LAYER_HEIGHT: 0.2
G1 F2061
M204 S8000
G1 X167.898 Y163.602 E.44415
G1 X167.898 Y155.398 E.26382
G1 X182.102 Y155.398 E.45675
G1 X182.102 Y163.602 E.26382
G1 X181.77 Y163.602 E.01068
; COOLING_NODE: 0
M204 S250
G1 X181.71 Y163.21 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1804
M204 S5000
G1 X168.29 Y163.21 E.39974
G1 X168.29 Y155.79 E.22102
G1 X181.71 Y155.79 E.39974
G1 X181.71 Y163.15 E.21923
; COOLING_NODE: 0
; WIPE_START
G1 F9547.055
M204 S8000
G1 X179.71 Y163.159 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.078 Y163.19 Z1.8 F60000
G1 X167.084 Y163.21 Z1.8
G1 Z1.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2061
M204 S8000
G1 X167.084 Y164.084 E.0281
G1 X166.416 Y164.084 E.02147
G1 X166.416 Y155.916 E.26264
G1 X167.084 Y155.916 E.02147
G1 X167.084 Y163.15 E.23261
; COOLING_NODE: 0
; WIPE_START
G1 F8843.478
G1 X167.084 Y164.084 E-.35484
G1 X166.416 Y164.084 E-.25368
G1 X166.416 Y163.685 E-.15147
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X174.047 Y163.862 Z1.8 F60000
G1 X183.584 Y164.084 Z1.8
G1 Z1.4
G1 E.8 F1800
G1 F2061
M204 S8000
G1 X182.916 Y164.084 E.02147
G1 X182.916 Y155.916 E.26264
M73 P69 R3
G1 X183.584 Y155.916 E.02147
G1 X183.584 Y164.024 E.26071
; COOLING_NODE: 0
; WIPE_START
G1 F8843.478
G1 X182.916 Y164.084 E-.25471
G1 X182.916 Y162.754 E-.50529
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X181.71 Y164.009 Z1.8 F60000
G1 Z1.4
G1 E.8 F1800
G1 F2061
M204 S8000
G1 X182.509 Y164.009 E.0257
G1 X182.509 Y155.509 E.27333
G1 X183.991 Y155.509 E.04765
G1 X183.991 Y164.491 E.28882
G1 X166.009 Y164.491 E.57823
G1 X166.009 Y155.509 E.28882
G1 X167.491 Y155.509 E.04765
G1 X167.491 Y164.009 E.27333
G1 X181.65 Y164.009 E.45531
; COOLING_NODE: 0
; WIPE_START
G1 F8843.478
G1 X182.509 Y164.009 E-.32647
G1 X182.509 Y162.868 E-.43353
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X184.398 Y164.898 Z1.8 F60000
G1 Z1.4
G1 E.8 F1800
G1 F2061
M204 S8000
G1 X165.602 Y164.898 E.60441
G1 X165.602 Y155.102 E.315
G1 X184.398 Y155.102 E.60441
G1 X184.398 Y164.838 E.31307
; COOLING_NODE: 1
M204 S250
G1 X184.79 Y165.29 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1950
M204 S5000
G1 X165.21 Y165.29 E.58322
G1 X165.21 Y154.71 E.31514
G1 X184.79 Y154.71 E.58322
G1 X184.79 Y165.23 E.31336
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
G1 X182.79 Y165.236 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
M73 P70 R3
G1 X183.25 Y163.88 Z1.8 F60000
G1 Z1.4
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.30344
G1 F2061
M204 S8000
G1 X183.25 Y156.12 E.15971
; WIPE_START
G1 F13818.517
G1 X183.25 Y158.12 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X182.713 Y164.25 Z1.8 F60000
G1 Z1.4
G1 E.8 F1800
; LINE_WIDTH: 0.11758
G1 F2061
M204 S8000
G1 X167.287 Y164.25 E.09097
M204 S10000
G1 X166.75 Y163.88 F60000
; LINE_WIDTH: 0.30344
G1 F2061
M204 S8000
G1 X166.75 Y156.12 E.15971
; CHANGE_LAYER
; Z_HEIGHT: 1.575
; LAYER_HEIGHT: 0.175
; WIPE_START
G1 F13818.517
G1 X166.75 Y158.12 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 12/29
; update layer progress
M73 L12
M991 S0 P11 ;notify layer change

M106 S224.4
; OBJECT_ID: 15
M204 S10000
G17
G3 Z1.8 I.499 J1.11 P1  F60000
G1 X169.038 Y157.09 Z1.8
G1 Z1.575
G1 E.8 F1800
; FEATURE: Support transition
; LINE_WIDTH: 0.42
; LAYER_HEIGHT: 0.275
G1 F2158
M204 S8000
G1 X169.038 Y156.538 E.02164
G1 X169.779 Y156.538 E.02904
G1 X169.038 Y157.279 E.04106
G1 X169.038 Y158.519 E.04863
G1 X171.019 Y156.538 E.10984
G1 X172.071 Y156.538 E.04124
; WIPE_START
G1 F3000
G1 X171.019 Y156.538 E-.39969
G1 X170.349 Y157.209 E-.36031
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z1.975 I-.063 J1.215 P1  F60000
G1 X180.962 Y157.76 Z1.975
G1 Z1.575
G1 E.8 F1800
G1 F2158
M204 S8000
G1 X180.135 Y158.586 E.04581
G1 X179.537 Y157.944 E.03441
G1 X180.942 Y156.538 E.07792
G1 X179.702 Y156.538 E.04863
G1 X178.916 Y157.324 E.04357
G1 X178.854 Y157.262 E.00345
G1 X177.738 Y157.262 E.04375
G1 X178.462 Y156.538 E.04012
G1 X177.221 Y156.538 E.04863
G1 X176.498 Y157.262 E.04011
G1 X175.257 Y157.262 E.04863
G1 X175.981 Y156.538 E.04011
G1 X174.74 Y156.538 E.04863
G1 X174.017 Y157.262 E.04011
G1 X172.777 Y157.262 E.04863
G1 X173.5 Y156.538 E.0401
G1 X172.26 Y156.538 E.04863
G1 X171.537 Y157.262 E.0401
G2 X170.971 Y157.435 I-.074 J.769 E.02381
G1 X170.034 Y158.373 E.05199
G2 X169.862 Y158.936 I.593 J.489 E.02369
G1 X169.038 Y159.76 E.04565
G1 X169.038 Y161 E.04863
G1 X169.864 Y160.174 E.04578
G1 X169.865 Y160.459 E.01116
G1 X170.343 Y160.936 E.02648
G1 X169.038 Y162.24 E.07232
G1 X169.038 Y162.462 E.00867
G1 X170.058 Y162.462 E.03996
G1 X170.963 Y161.556 E.05022
G1 X171.146 Y161.738 E.01011
G1 X172.022 Y161.738 E.03433
G1 X171.298 Y162.462 E.04012
G1 X172.538 Y162.462 E.04863
G1 X173.262 Y161.738 E.04011
G1 X174.502 Y161.738 E.04863
G1 X173.779 Y162.462 E.04011
G1 X175.019 Y162.462 E.04863
G1 X175.742 Y161.738 E.04011
G1 X176.983 Y161.738 E.04863
G1 X176.26 Y162.462 E.04011
G1 X177.5 Y162.462 E.04863
G1 X178.223 Y161.738 E.0401
G2 X179.029 Y161.565 I.194 J-1.058 E.03318
G1 X179.966 Y160.627 E.05199
G2 X180.138 Y159.824 I-.882 J-.608 E.03304
G1 X180.962 Y159 E.04568
G1 X180.962 Y160.24 E.04863
G1 X178.74 Y162.462 E.12317
G1 X179.981 Y162.462 E.04863
G1 X180.962 Y161.481 E.05439
G1 X180.962 Y162.462 E.03846
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

G1 X180.169 Y162.462 E.03107
; CHANGE_LAYER
; Z_HEIGHT: 1.6
; LAYER_HEIGHT: 0.025
; WIPE_START
G1 F3000
G1 X180.962 Y162.462 E-.30113
G1 X180.962 Y161.481 E-.37277
G1 X180.801 Y161.641 E-.08611
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 13/29
; update layer progress
M73 L13
M991 S0 P12 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z1.975 I-1.104 J.512 P1  F60000
G1 X181.71 Y163.602 Z1.975
G1 Z1.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
; LAYER_HEIGHT: 0.2
G1 F2158
M204 S8000
G1 X167.898 Y163.602 E.44415
G1 X167.898 Y155.398 E.26382
G1 X182.102 Y155.398 E.45675
G1 X182.102 Y163.602 E.26382
G1 X181.77 Y163.602 E.01068
; COOLING_NODE: 0
M204 S250
G1 X181.71 Y163.21 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1725
M204 S5000
G1 X168.29 Y163.21 E.39974
G1 X168.29 Y155.79 E.22102
G1 X181.71 Y155.79 E.39974
G1 X181.71 Y163.15 E.21923
; COOLING_NODE: 0
; WIPE_START
G1 F9547.055
M204 S8000
G1 X179.71 Y163.159 E-.76
; WIPE_END
M73 P71 R3
G1 E-.04 F1800
M204 S10000
G1 X172.078 Y163.19 Z2 F60000
G1 X167.084 Y163.21 Z2
G1 Z1.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2158
M204 S8000
G1 X167.084 Y164.084 E.0281
G1 X166.416 Y164.084 E.02147
G1 X166.416 Y155.916 E.26264
G1 X167.084 Y155.916 E.02147
M73 P71 R2
G1 X167.084 Y163.15 E.23261
; COOLING_NODE: 0
; WIPE_START
G1 F8843.478
G1 X167.084 Y164.084 E-.35484
G1 X166.416 Y164.084 E-.25368
G1 X166.416 Y163.685 E-.15147
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X174.047 Y163.862 Z2 F60000
G1 X183.584 Y164.084 Z2
G1 Z1.6
G1 E.8 F1800
G1 F2158
M204 S8000
G1 X182.916 Y164.084 E.02147
G1 X182.916 Y155.916 E.26264
G1 X183.584 Y155.916 E.02147
G1 X183.584 Y164.024 E.26071
; COOLING_NODE: 0
; WIPE_START
G1 F8843.478
G1 X182.916 Y164.084 E-.25471
G1 X182.916 Y162.754 E-.50529
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X181.71 Y164.009 Z2 F60000
G1 Z1.6
G1 E.8 F1800
G1 F2158
M204 S8000
G1 X182.509 Y164.009 E.0257
G1 X182.509 Y155.509 E.27333
G1 X183.991 Y155.509 E.04765
G1 X183.991 Y164.491 E.28882
G1 X166.009 Y164.491 E.57823
G1 X166.009 Y155.509 E.28882
G1 X167.491 Y155.509 E.04765
G1 X167.491 Y164.009 E.27333
G1 X181.65 Y164.009 E.45531
; COOLING_NODE: 0
; WIPE_START
G1 F8843.478
G1 X182.509 Y164.009 E-.32647
G1 X182.509 Y162.868 E-.43353
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X184.398 Y164.898 Z2 F60000
G1 Z1.6
G1 E.8 F1800
G1 F2158
M204 S8000
G1 X165.602 Y164.898 E.60441
G1 X165.602 Y155.102 E.315
G1 X184.398 Y155.102 E.60441
G1 X184.398 Y164.838 E.31307
; COOLING_NODE: 1
M204 S250
G1 X184.79 Y165.29 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1966
M204 S5000
G1 X165.21 Y165.29 E.58322
G1 X165.21 Y154.71 E.31514
G1 X184.79 Y154.71 E.58322
G1 X184.79 Y165.23 E.31336
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
M73 P72 R2
G1 F9547.055
M204 S8000
G1 X182.79 Y165.236 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X183.25 Y163.88 Z2 F60000
G1 Z1.6
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.30344
G1 F2158
M204 S8000
G1 X183.25 Y156.12 E.15971
; WIPE_START
G1 F13818.517
G1 X183.25 Y158.12 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X182.713 Y164.25 Z2 F60000
G1 Z1.6
G1 E.8 F1800
; LINE_WIDTH: 0.11758
G1 F2158
M204 S8000
G1 X167.287 Y164.25 E.09097
M204 S10000
G1 X166.75 Y163.88 F60000
; LINE_WIDTH: 0.30344
G1 F2158
M204 S8000
G1 X166.75 Y156.12 E.15971
; CHANGE_LAYER
; Z_HEIGHT: 1.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F13818.517
G1 X166.75 Y158.12 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 14/29
; update layer progress
M73 L14
M991 S0 P13 ;notify layer change

M106 S226.95
; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z2 I-.419 J1.143 P1  F60000
G1 X181.71 Y163.602 Z2
G1 Z1.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1786
M204 S8000
G1 X167.898 Y163.602 E.44415
G1 X167.898 Y155.398 E.26382
G1 X182.102 Y155.398 E.45675
G1 X182.102 Y163.602 E.26382
G1 X181.77 Y163.602 E.01068
; COOLING_NODE: 0
M204 S250
G1 X181.71 Y163.21 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1619
M204 S5000
G1 X168.29 Y163.21 E.39974
G1 X168.29 Y155.79 E.22102
G1 X181.71 Y155.79 E.39974
G1 X181.71 Y163.15 E.21923
; COOLING_NODE: 0
; WIPE_START
G1 F9547.055
M204 S8000
G1 X179.71 Y163.159 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
M73 P73 R2
G1 X172.078 Y163.19 Z2.2 F60000
G1 X167.084 Y163.21 Z2.2
G1 Z1.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1786
M204 S8000
G1 X167.084 Y164.084 E.0281
G1 X166.416 Y164.084 E.02147
G1 X166.416 Y155.916 E.26264
G1 X167.084 Y155.916 E.02147
G1 X167.084 Y163.15 E.23261
; COOLING_NODE: 0
; WIPE_START
G1 F8843.478
G1 X167.084 Y164.084 E-.35484
G1 X166.416 Y164.084 E-.25368
G1 X166.416 Y163.685 E-.15147
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X174.047 Y163.862 Z2.2 F60000
G1 X183.584 Y164.084 Z2.2
G1 Z1.8
G1 E.8 F1800
G1 F1786
M204 S8000
G1 X182.916 Y164.084 E.02147
G1 X182.916 Y155.916 E.26264
G1 X183.584 Y155.916 E.02147
G1 X183.584 Y164.024 E.26071
; COOLING_NODE: 0
; WIPE_START
G1 F8843.478
G1 X182.916 Y164.084 E-.25471
G1 X182.916 Y162.754 E-.50529
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X181.71 Y164.009 Z2.2 F60000
G1 Z1.8
G1 E.8 F1800
G1 F1786
M204 S8000
G1 X182.509 Y164.009 E.0257
G1 X182.509 Y155.509 E.27333
G1 X183.991 Y155.509 E.04765
G1 X183.991 Y164.491 E.28882
G1 X166.009 Y164.491 E.57823
G1 X166.009 Y155.509 E.28882
G1 X167.491 Y155.509 E.04765
G1 X167.491 Y164.009 E.27333
G1 X181.65 Y164.009 E.45531
; COOLING_NODE: 0
; WIPE_START
G1 F8843.478
G1 X182.509 Y164.009 E-.32647
G1 X182.509 Y162.868 E-.43353
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X184.398 Y164.898 Z2.2 F60000
G1 Z1.8
G1 E.8 F1800
G1 F1786
M204 S8000
G1 X165.602 Y164.898 E.60441
G1 X165.602 Y155.102 E.315
G1 X184.398 Y155.102 E.60441
G1 X184.398 Y164.838 E.31307
; COOLING_NODE: 1
M204 S250
G1 X184.79 Y165.29 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1786
M204 S5000
G1 X165.21 Y165.29 E.58322
M73 P74 R2
G1 X165.21 Y154.71 E.31514
G1 X184.79 Y154.71 E.58322
G1 X184.79 Y165.23 E.31336
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
G1 X182.79 Y165.236 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X183.25 Y163.88 Z2.2 F60000
G1 Z1.8
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.30344
G1 F1786
M204 S8000
G1 X183.25 Y156.12 E.15971
; WIPE_START
G1 F13818.517
G1 X183.25 Y158.12 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X182.713 Y164.25 Z2.2 F60000
G1 Z1.8
G1 E.8 F1800
; LINE_WIDTH: 0.11758
G1 F1786
M204 S8000
G1 X167.287 Y164.25 E.09097
M204 S10000
G1 X166.75 Y163.88 F60000
; LINE_WIDTH: 0.30344
G1 F1786
M204 S8000
G1 X166.75 Y156.12 E.15971
; CHANGE_LAYER
; Z_HEIGHT: 1.85
; LAYER_HEIGHT: 0.0500001
; WIPE_START
G1 F13818.517
G1 X166.75 Y158.12 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 15/29
; update layer progress
M73 L15
M991 S0 P14 ;notify layer change

M106 S221.85
; OBJECT_ID: 15
M204 S10000
G17
G3 Z2.2 I.367 J1.16 P1  F60000
G1 X168.869 Y157.449 Z2.2
G1 Z1.85
G1 E.8 F1800
; FEATURE: Support interface
; LINE_WIDTH: 0.42
; LAYER_HEIGHT: 0.275
G1 F2517
M204 S8000
G1 X169.949 Y156.369 E.05988
; WIPE_START
G1 F4800
G1 X168.869 Y157.449 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z2.25 I-.136 J1.209 P1  F60000
G1 X181.131 Y158.83 Z2.25
G1 Z1.85
G1 E.8 F1800
G1 F2517
M204 S8000
G1 X180.138 Y159.824 E.05509
G1 X180.135 Y158.586 E.04854
G1 X180.962 Y157.76 E.04581
G1 X180.962 Y156.538 E.04788
G1 X179.537 Y157.944 E.07846
G1 X178.916 Y157.324 E.03439
G1 X179.702 Y156.538 E.04357
G1 X178.462 Y156.538 E.04863
G1 X177.738 Y157.262 E.04012
G1 X176.498 Y157.262 E.04863
G1 X177.221 Y156.538 E.04011
G1 X175.981 Y156.538 E.04863
G1 X175.257 Y157.262 E.04011
G1 X174.017 Y157.262 E.04863
G1 X174.74 Y156.538 E.04011
G1 X173.5 Y156.538 E.04863
G1 X172.777 Y157.262 E.04011
G1 X171.536 Y157.262 E.04863
G1 X172.26 Y156.538 E.0401
G1 X171.019 Y156.538 E.04863
G1 X169.038 Y158.519 E.10984
G1 X169.038 Y159.76 E.04863
G1 X169.862 Y158.936 E.04565
G1 X169.864 Y160.174 E.04854
G1 X169.038 Y161 E.04578
G1 X169.038 Y162.24 E.04863
G1 X170.343 Y160.936 E.07232
G1 X170.963 Y161.556 E.03439
G1 X170.058 Y162.462 E.05022
G1 X171.298 Y162.462 E.04863
G1 X172.022 Y161.738 E.04012
G1 X173.262 Y161.738 E.04863
G1 X172.538 Y162.462 E.04011
G1 X173.779 Y162.462 E.04863
G1 X174.502 Y161.738 E.04011
G1 X175.742 Y161.738 E.04863
G1 X175.019 Y162.462 E.04011
G1 X176.26 Y162.462 E.04863
G1 X176.983 Y161.738 E.04011
G1 X178.223 Y161.738 E.04863
G1 X177.5 Y162.462 E.0401
G1 X178.74 Y162.462 E.04863
G1 X180.962 Y160.24 E.12317
G1 X180.962 Y161.481 E.04863
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

G1 X179.811 Y162.631 E.0638
; CHANGE_LAYER
; Z_HEIGHT: 2
; LAYER_HEIGHT: 0.15
; WIPE_START
G1 F4800
G1 X180.962 Y161.481 E-.61836
G1 X180.962 Y161.108 E-.14164
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 16/29
; update layer progress
M73 L16
M991 S0 P15 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z2.25 I-1.146 J.408 P1  F60000
G1 X181.71 Y163.21 Z2.25
G1 Z2
G1 E.8 F1800
; FEATURE: Outer wall
; LAYER_HEIGHT: 0.2
G1 F1498
M204 S5000
G1 X168.29 Y163.21 E.39974
G1 X168.29 Y155.79 E.22102
G1 X181.71 Y155.79 E.39974
G1 X181.71 Y163.15 E.21923
; COOLING_NODE: 1
; WIPE_START
M73 P75 R2
G1 F9547.055
M204 S8000
G1 X179.71 Y163.159 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X184.79 Y165.29 Z2.4 F60000
G1 Z2
G1 E.8 F1800
G1 F2032
M204 S5000
G1 X165.21 Y165.29 E.58322
G1 X165.21 Y154.71 E.31514
G1 X184.79 Y154.71 E.58322
G1 X184.79 Y165.23 E.31336
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
G1 X184.583 Y164.549 F60000
; FEATURE: Top surface
G1 F2517
M204 S2000
G1 X184.049 Y165.083 E.02249
G1 X183.915 Y165.216
G1 X183.382 Y165.216
G1 X183.515 Y165.083
G1 X184.583 Y164.015 E.04496
G1 X184.716 Y163.882
G1 X184.716 Y163.348
G1 X184.583 Y163.482
G1 X182.982 Y165.083 E.06742
G1 X182.848 Y165.216
G1 X182.315 Y165.216
G1 X182.449 Y165.083
G1 X184.583 Y162.949 E.08988
G1 X184.716 Y162.815
G1 X184.716 Y162.282
G1 X184.583 Y162.416
G1 X181.916 Y165.083 E.11235
G1 X181.782 Y165.216
G1 X181.249 Y165.216
G1 X181.382 Y165.083
G1 X184.583 Y161.882 E.13481
G1 X184.716 Y161.749
G1 X184.716 Y161.215
G1 X184.583 Y161.349
G1 X180.849 Y165.083 E.15727
G1 X180.715 Y165.216
G1 X180.182 Y165.216
G1 X180.316 Y165.083
G1 X184.583 Y160.816 E.17974
G1 X184.716 Y160.682
G1 X184.716 Y160.149
G1 X184.583 Y160.283
G1 X181.917 Y162.948 E.11227
G1 X181.784 Y163.081
G1 X181.784 Y162.548
G1 X181.917 Y162.415
G1 X184.583 Y159.749 E.11227
G1 X184.716 Y159.616
G1 X184.716 Y159.082
G1 X184.583 Y159.216
G1 X181.917 Y161.881 E.11227
G1 X181.784 Y162.015
G1 X181.784 Y161.482
G1 X181.917 Y161.348
G1 X184.583 Y158.683 E.11227
G1 X184.716 Y158.549
G1 X184.716 Y158.016
G1 X184.583 Y158.15
G1 X181.917 Y160.815 E.11227
G1 X181.784 Y160.948
G1 X181.784 Y160.415
G1 X181.917 Y160.282
G1 X184.583 Y157.616 E.11227
G1 X184.716 Y157.483
G1 X184.716 Y156.949
G1 X184.583 Y157.083
G1 X181.917 Y159.748 E.11227
G1 X181.784 Y159.882
G1 X181.784 Y159.349
G1 X181.917 Y159.215
G1 X184.583 Y156.55 E.11227
G1 X184.716 Y156.416
G1 X184.716 Y155.883
G1 X184.583 Y156.017
G1 X181.917 Y158.682 E.11227
G1 X181.784 Y158.815
G1 X181.784 Y158.282
G1 X181.917 Y158.148
G1 X184.583 Y155.483 E.11227
G1 X184.716 Y155.35
G1 X184.716 Y154.816
G1 X184.583 Y154.95
G1 X181.917 Y157.615 E.11227
G1 X181.784 Y157.749
G1 X181.784 Y157.216
G1 X181.917 Y157.082
G1 X184.082 Y154.917 E.09118
G1 X184.216 Y154.784
G1 X183.682 Y154.784
G1 X183.549 Y154.917
G1 X181.917 Y156.549 E.06872
G1 X181.784 Y156.682
G1 X181.784 Y156.149
G1 X181.917 Y156.015
G1 X183.015 Y154.917 E.04626
G1 X183.149 Y154.784
G1 X182.616 Y154.784
G1 X182.482 Y154.917
G1 X181.817 Y155.583 E.02802
G1 X181.683 Y155.716
G1 X181.15 Y155.716
G1 X181.284 Y155.583
G1 X181.949 Y154.917 E.02802
G1 X182.083 Y154.784
G1 X181.549 Y154.784
G1 X181.416 Y154.917
G1 X180.75 Y155.583 E.02802
G1 X180.617 Y155.716
G1 X180.084 Y155.716
G1 X180.217 Y155.583
G1 X180.882 Y154.917 E.02802
G1 X181.016 Y154.784
G1 X180.483 Y154.784
G1 X180.349 Y154.917
G1 X179.684 Y155.583 E.02802
G1 X179.55 Y155.716
G1 X179.017 Y155.716
G1 X179.151 Y155.583
M73 P76 R2
G1 X179.816 Y154.917 E.02802
G1 X179.95 Y154.784
G1 X179.416 Y154.784
G1 X179.283 Y154.917
G1 X178.617 Y155.583 E.02802
G1 X178.484 Y155.716
G1 X177.951 Y155.716
G1 X178.084 Y155.583
G1 X178.749 Y154.917 E.02802
G1 X178.883 Y154.784
G1 X178.35 Y154.784
G1 X178.216 Y154.917
G1 X177.551 Y155.583 E.02802
G1 X177.417 Y155.716
G1 X176.884 Y155.716
G1 X177.018 Y155.583
G1 X177.683 Y154.917 E.02802
G1 X177.817 Y154.784
G1 X177.283 Y154.784
G1 X177.15 Y154.917
G1 X176.484 Y155.583 E.02802
G1 X176.351 Y155.716
G1 X175.818 Y155.716
G1 X175.951 Y155.583
G1 X176.616 Y154.917 E.02802
G1 X176.75 Y154.784
G1 X176.217 Y154.784
G1 X176.083 Y154.917
G1 X175.418 Y155.583 E.02802
G1 X175.284 Y155.716
G1 X174.751 Y155.716
G1 X174.885 Y155.583
G1 X175.55 Y154.917 E.02802
G1 X175.684 Y154.784
G1 X175.15 Y154.784
G1 X175.017 Y154.917
G1 X174.351 Y155.583 E.02802
G1 X174.218 Y155.716
G1 X173.684 Y155.716
G1 X173.818 Y155.583
G1 X174.483 Y154.917 E.02802
G1 X174.617 Y154.784
G1 X174.084 Y154.784
G1 X173.95 Y154.917
G1 X173.285 Y155.583 E.02802
G1 X173.151 Y155.716
G1 X172.618 Y155.716
G1 X172.752 Y155.583
G1 X173.417 Y154.917 E.02802
G1 X173.55 Y154.784
G1 X173.017 Y154.784
G1 X172.884 Y154.917
G1 X172.218 Y155.583 E.02802
G1 X172.085 Y155.716
G1 X171.551 Y155.716
G1 X171.685 Y155.583
G1 X172.35 Y154.917 E.02802
G1 X172.484 Y154.784
G1 X171.951 Y154.784
G1 X171.817 Y154.917
G1 X171.152 Y155.583 E.02802
G1 X171.018 Y155.716
G1 X170.485 Y155.716
G1 X170.619 Y155.583
G1 X171.284 Y154.917 E.02802
G1 X171.417 Y154.784
G1 X170.884 Y154.784
G1 X170.751 Y154.917
G1 X170.085 Y155.583 E.02802
G1 X169.952 Y155.716
G1 X169.418 Y155.716
G1 X169.552 Y155.583
G1 X170.217 Y154.917 E.02802
G1 X170.351 Y154.784
G1 X169.818 Y154.784
G1 X169.684 Y154.917
G1 X169.019 Y155.583 E.02802
G1 X168.885 Y155.716
G1 X168.352 Y155.716
G1 X168.486 Y155.583
G1 X169.151 Y154.917 E.02802
; WIPE_START
G1 F9547.055
M204 S8000
G1 X168.486 Y155.583 E-.35749
G1 X168.352 Y155.716 E-.07182
G1 X168.885 Y155.716 E-.20264
G1 X169.019 Y155.583 E-.07182
G1 X169.123 Y155.478 E-.05624
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z2.4 I-.815 J.904 P1  F60000
G1 X179.783 Y165.083 Z2.4
G1 Z2
G1 E.8 F1800
G1 F2517
M204 S2000
G1 X181.448 Y163.417 E.07015
G1 X181.581 Y163.284
G1 X181.048 Y163.284
G1 X180.915 Y163.417
G1 X179.249 Y165.083 E.07015
G1 X179.116 Y165.216
G1 X178.582 Y165.216
G1 X178.716 Y165.083
G1 X180.381 Y163.417 E.07015
G1 X180.515 Y163.284
G1 X179.982 Y163.284
G1 X179.848 Y163.417
G1 X178.183 Y165.083 E.07015
G1 X178.049 Y165.216
G1 X177.516 Y165.216
G1 X177.65 Y165.083
G1 X179.315 Y163.417 E.07015
G1 X179.448 Y163.284
G1 X178.915 Y163.284
G1 X178.782 Y163.417
G1 X177.116 Y165.083 E.07015
G1 X176.983 Y165.216
G1 X176.449 Y165.216
G1 X176.583 Y165.083
G1 X178.248 Y163.417 E.07015
G1 X178.382 Y163.284
G1 X177.849 Y163.284
G1 X177.715 Y163.417
G1 X176.05 Y165.083 E.07015
G1 X175.916 Y165.216
G1 X175.383 Y165.216
G1 X175.517 Y165.083
G1 X177.182 Y163.417 E.07015
G1 X177.315 Y163.284
G1 X176.782 Y163.284
G1 X176.648 Y163.417
G1 X174.983 Y165.083 E.07015
G1 X174.85 Y165.216
G1 X174.316 Y165.216
G1 X174.45 Y165.083
G1 X176.115 Y163.417 E.07015
G1 X176.249 Y163.284
G1 X175.716 Y163.284
G1 X175.582 Y163.417
G1 X173.917 Y165.083 E.07015
G1 X173.783 Y165.216
G1 X173.25 Y165.216
G1 X173.383 Y165.083
G1 X175.049 Y163.417 E.07015
G1 X175.182 Y163.284
G1 X174.649 Y163.284
G1 X174.515 Y163.417
G1 X172.85 Y165.083 E.07015
G1 X172.717 Y165.216
G1 X172.183 Y165.216
G1 X172.317 Y165.083
G1 X173.982 Y163.417 E.07015
G1 X174.116 Y163.284
G1 X173.583 Y163.284
G1 X173.449 Y163.417
G1 X171.784 Y165.083 E.07015
G1 X171.65 Y165.216
G1 X171.117 Y165.216
G1 X171.25 Y165.083
G1 X172.916 Y163.417 E.07015
G1 X173.049 Y163.284
G1 X172.516 Y163.284
G1 X172.382 Y163.417
G1 X170.717 Y165.083 E.07015
G1 X170.584 Y165.216
G1 X170.05 Y165.216
G1 X170.184 Y165.083
G1 X171.849 Y163.417 E.07015
G1 X171.983 Y163.284
G1 X171.45 Y163.284
G1 X171.316 Y163.417
G1 X169.651 Y165.083 E.07015
G1 X169.517 Y165.216
G1 X168.984 Y165.216
G1 X169.117 Y165.083
G1 X170.783 Y163.417 E.07015
G1 X170.916 Y163.284
G1 X170.383 Y163.284
G1 X170.249 Y163.417
G1 X168.584 Y165.083 E.07015
G1 X168.451 Y165.216
G1 X167.917 Y165.216
G1 X168.051 Y165.083
G1 X169.716 Y163.417 E.07015
G1 X169.85 Y163.284
G1 X169.317 Y163.284
G1 X169.183 Y163.417
G1 X167.518 Y165.083 E.07015
G1 X167.384 Y165.216
G1 X166.851 Y165.216
G1 X166.984 Y165.083
G1 X168.65 Y163.417 E.07015
G1 X168.783 Y163.284
G1 X168.25 Y163.284
G1 X168.116 Y163.417
G1 X166.451 Y165.083 E.07015
G1 X166.317 Y165.216
G1 X165.784 Y165.216
G1 X165.918 Y165.083
G1 X168.083 Y162.918 E.09119
G1 X168.216 Y162.784
G1 X168.216 Y162.251
G1 X168.083 Y162.385
G1 X165.417 Y165.05 E.11227
G1 X165.284 Y165.183
G1 X165.284 Y164.65
G1 X165.417 Y164.517
G1 X168.083 Y161.851 E.11227
G1 X168.216 Y161.718
G1 X168.216 Y161.184
G1 X168.083 Y161.318
G1 X165.417 Y163.983 E.11227
G1 X165.284 Y164.117
G1 X165.284 Y163.584
G1 X165.417 Y163.45
G1 X168.083 Y160.785 E.11227
G1 X168.216 Y160.651
G1 X168.216 Y160.118
G1 X168.083 Y160.252
G1 X165.417 Y162.917 E.11227
G1 X165.284 Y163.05
G1 X165.284 Y162.517
G1 X165.417 Y162.384
G1 X168.083 Y159.718 E.11227
G1 X168.216 Y159.585
G1 X168.216 Y159.051
G1 X168.083 Y159.185
G1 X165.417 Y161.85 E.11227
G1 X165.284 Y161.984
G1 X165.284 Y161.451
G1 X165.417 Y161.317
G1 X168.083 Y158.652 E.11227
G1 X168.216 Y158.518
G1 X168.216 Y157.985
G1 X168.083 Y158.119
G1 X165.417 Y160.784 E.11227
G1 X165.284 Y160.917
G1 X165.284 Y160.384
G1 X165.417 Y160.251
G1 X168.083 Y157.585 E.11227
G1 X168.216 Y157.452
G1 X168.216 Y156.918
G1 X168.083 Y157.052
G1 X165.417 Y159.717 E.11227
G1 X165.284 Y159.851
G1 X165.284 Y159.318
G1 X165.417 Y159.184
G1 X168.083 Y156.519 E.11227
G1 X168.216 Y156.385
G1 X168.216 Y155.852
G1 X168.083 Y155.986
G1 X165.417 Y158.651 E.11227
G1 X165.284 Y158.784
G1 X165.284 Y158.251
G1 X165.417 Y158.118
G1 X168.618 Y154.917 E.1348
G1 X168.751 Y154.784
G1 X168.218 Y154.784
G1 X168.084 Y154.917
G1 X165.417 Y157.584 E.11234
G1 X165.284 Y157.718
G1 X165.284 Y157.185
M73 P77 R2
G1 X165.417 Y157.051
G1 X167.551 Y154.917 E.08988
G1 X167.685 Y154.784
G1 X167.151 Y154.784
G1 X167.018 Y154.917
G1 X165.417 Y156.518 E.06741
G1 X165.284 Y156.651
G1 X165.284 Y156.118
G1 X165.417 Y155.984
G1 X166.484 Y154.917 E.04495
G1 X166.618 Y154.784
G1 X166.085 Y154.784
G1 X165.951 Y154.917
G1 X165.417 Y155.451 E.02249
; CHANGE_LAYER
; Z_HEIGHT: 2.125
; LAYER_HEIGHT: 0.125
; WIPE_START
G1 F9547.055
M204 S8000
G1 X165.951 Y154.917 E-.28688
G1 X166.085 Y154.784 E-.07182
G1 X166.618 Y154.784 E-.20264
G1 X166.484 Y154.917 E-.07182
G1 X166.248 Y155.153 E-.12685
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 17/29
; update layer progress
M73 L17
M991 S0 P16 ;notify layer change

M106 S229.5
; OBJECT_ID: 15
M204 S10000
G17
G3 Z2.4 I-1.12 J.477 P1  F60000
G1 X168.869 Y161.311 Z2.4
G1 Z2.125
G1 E.8 F1800
; FEATURE: Support interface
; LAYER_HEIGHT: 0.275
G1 F1200
M204 S8000
G1 X170.189 Y162.631 E.07321
; WIPE_START
G1 F4800
G1 X168.869 Y161.311 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z2.525 I.601 J1.058 P1  F60000
G1 X177.571 Y156.369 Z2.525
G1 Z2.125
G1 E.8 F1800
G1 F1200
M204 S8000
G1 X178.464 Y157.262 E.04953
G1 X177.223 Y157.262 E.04864
G1 X176.5 Y156.538 E.04011
G1 X175.26 Y156.538 E.04863
G1 X175.983 Y157.262 E.04011
G1 X174.743 Y157.262 E.04863
G1 X174.019 Y156.538 E.04011
G1 X172.779 Y156.538 E.04863
G1 X173.502 Y157.262 E.04011
G1 X172.262 Y157.262 E.04863
G1 X171.538 Y156.538 E.0401
G1 X170.298 Y156.538 E.04863
G1 X171.129 Y157.369 E.04607
G1 X170.971 Y157.435 E.00672
G1 X170.463 Y157.944 E.02818
G1 X169.038 Y156.538 E.07845
G1 X169.038 Y157.76 E.04788
G1 X169.922 Y158.644 E.04902
G1 X169.861 Y158.791 E.00627
G1 X169.863 Y159.825 E.04053
G1 X169.038 Y159 E.04575
G1 X169.038 Y160.24 E.04863
G1 X171.26 Y162.462 E.12317
G1 X172.5 Y162.462 E.04863
G1 X171.777 Y161.738 E.04012
G1 X173.017 Y161.738 E.04863
G1 X173.74 Y162.462 E.04011
G1 X174.981 Y162.462 E.04863
G1 X174.257 Y161.738 E.04011
G1 X175.498 Y161.738 E.04863
G1 X176.221 Y162.462 E.04011
G1 X177.462 Y162.462 E.04863
G1 X176.738 Y161.738 E.04011
G1 X177.979 Y161.738 E.04863
G1 X178.702 Y162.462 E.0401
G1 X179.942 Y162.462 E.04863
G1 X179.038 Y161.557 E.05016
G1 X179.657 Y160.936 E.03439
G1 X180.962 Y162.24 E.07233
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

G1 X180.962 Y161 E.04863
G1 X180.138 Y160.177 E.04564
G1 X180.136 Y158.934 E.04873
G1 X180.962 Y159.76 E.04577
G1 X180.962 Y158.519 E.04863
G1 X178.981 Y156.538 E.10984
G1 X180.221 Y156.538 E.04863
G1 X181.131 Y157.449 E.05047
; CHANGE_LAYER
; Z_HEIGHT: 2.2
; LAYER_HEIGHT: 0.075
; WIPE_START
G1 F4800
G1 X180.221 Y156.538 E-.48918
G1 X179.508 Y156.538 E-.27082
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 18/29
; update layer progress
M73 L18
M991 S0 P17 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z2.525 I-1.166 J.347 P1  F60000
G1 X181.496 Y163.21 Z2.525
G1 Z2.2
G1 E.8 F1800
; FEATURE: Outer wall
; LAYER_HEIGHT: 0.2
G1 F1200
M204 S5000
G3 X181.194 Y163.29 I-.341 J-.678 E.00935
G1 X168.795 Y163.29 E.36933
G3 X168.505 Y163.21 I.051 J-.753 E.00903
G1 X181.436 Y163.21 E.38517
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

; COOLING_NODE: 0
; WIPE_START
G1 F9547.055
M204 S8000
G1 X181.353 Y163.269 E-.0387
G1 X181.194 Y163.29 E-.06076
G1 X179.456 Y163.29 E-.66054
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X181.711 Y156.006 Z2.6 F60000
G1 Z2.2
G1 E.8 F1800
G1 F1200
M204 S5000
G3 X181.789 Y156.269 I-.542 J.303 E.00825
G1 X181.789 Y162.73 E.19245
G3 X181.71 Y162.994 I-.776 J-.088 E.00825
G1 X181.711 Y156.066 E.20637
; COOLING_NODE: 0
M204 S250
G1 X181.495 Y155.79 F60000
G1 F1200
M204 S5000
G1 X168.504 Y155.79 E.38695
M73 P78 R2
G3 X168.806 Y155.71 I.341 J.678 E.00935
G1 X181.263 Y155.714 E.37104
G3 X181.442 Y155.763 I-.067 J.596 E.00556
; COOLING_NODE: 0
; WIPE_START
G1 F9547.055
M204 S8000
G1 X179.442 Y155.767 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X173.037 Y159.918 Z2.6 F60000
G1 X168.29 Y162.996 Z2.6
G1 Z2.2
G1 E.8 F1800
G1 F1200
M204 S5000
G1 X168.289 Y162.994 E.00005
G3 X168.21 Y162.705 I.683 J-.342 E.00898
G1 X168.21 Y156.282 E.19131
G3 X168.29 Y156.005 I.806 J.082 E.00863
G1 X168.29 Y162.936 E.20643
; CHANGE_LAYER
; Z_HEIGHT: 2.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9547.055
M204 S8000
G1 X168.289 Y162.994 E-.02224
G1 X168.233 Y162.862 E-.05431
G1 X168.21 Y162.705 E-.06047
G1 X168.21 Y161.066 E-.62298
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 19/29
; update layer progress
M73 L19
M991 S0 P18 ;notify layer change

; OBJECT_ID: 15
M204 S10000
G17
G3 Z2.6 I1.197 J.218 P1  F60000
G1 X168.869 Y157.449 Z2.6
G1 Z2.4
G1 E.8 F1800
; FEATURE: Support interface
; LAYER_HEIGHT: 0.275
G1 F1200
M204 S8000
G1 X169.949 Y156.369 E.05988
; WIPE_START
G1 F4800
G1 X168.869 Y157.449 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X176.453 Y158.303 Z2.8 F60000
G1 X181.131 Y158.83 Z2.8
G1 Z2.4
G1 E.8 F1800
G1 F1200
M204 S8000
G1 X180.138 Y159.824 E.05508
G1 X180.136 Y158.586 E.04854
G1 X180.962 Y157.76 E.0458
G1 X180.962 Y156.538 E.04788
G1 X179.537 Y157.944 E.07845
G1 X178.916 Y157.324 E.03439
G1 X179.702 Y156.538 E.04356
G1 X178.462 Y156.538 E.04863
G1 X177.738 Y157.262 E.04011
G1 X176.498 Y157.262 E.04863
G1 X177.221 Y156.538 E.04011
G1 X175.981 Y156.538 E.04863
G1 X175.258 Y157.262 E.04011
G1 X174.017 Y157.262 E.04863
G1 X174.74 Y156.538 E.0401
G1 X173.5 Y156.538 E.04863
G1 X172.777 Y157.262 E.0401
G1 X171.537 Y157.262 E.04863
G1 X172.26 Y156.538 E.0401
G1 X171.019 Y156.538 E.04863
G1 X169.038 Y158.519 E.10984
G1 X169.038 Y159.76 E.04863
G1 X169.862 Y158.936 E.04565
G1 X169.864 Y160.175 E.04854
G1 X169.038 Y161 E.04578
G1 X169.038 Y162.24 E.04863
G1 X170.343 Y160.936 E.07231
G1 X170.963 Y161.556 E.03439
G1 X170.058 Y162.462 E.05022
G1 X171.298 Y162.462 E.04863
G1 X172.021 Y161.738 E.04011
G1 X173.262 Y161.738 E.04863
G1 X172.538 Y162.462 E.04011
G1 X173.779 Y162.462 E.04863
G1 X174.502 Y161.738 E.04011
G1 X175.742 Y161.738 E.04863
G1 X175.019 Y162.462 E.0401
G1 X176.26 Y162.462 E.04863
G1 X176.983 Y161.738 E.0401
G1 X178.223 Y161.738 E.04863
G1 X177.5 Y162.462 E.0401
G1 X178.74 Y162.462 E.04863
G1 X180.962 Y160.24 E.12317
G1 X180.962 Y161.481 E.04863
G1 X179.811 Y162.631 E.0638
; COOLING_NODE: 0
; WIPE_START
G1 F4800
G1 X180.962 Y161.481 E-.61836
G1 X180.962 Y161.108 E-.14164
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X181.496 Y163.21 Z2.8 F60000
G1 Z2.4
G1 E.8 F1800
; FEATURE: Outer wall
; LAYER_HEIGHT: 0.2
G1 F1200
M204 S5000
G3 X181.196 Y163.29 I-.338 J-.666 E.0093
G1 X168.795 Y163.29 E.36938
G3 X168.504 Y163.21 I.017 J-.629 E.00907
G1 X181.436 Y163.21 E.38518
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

; COOLING_NODE: 0
; WIPE_START
G1 F9547.055
M204 S8000
M73 P79 R2
G1 X181.352 Y163.27 E-.03886
G1 X181.196 Y163.29 E-.05995
G1 X179.456 Y163.29 E-.66118
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X181.716 Y156.015 Z2.8 F60000
G1 Z2.4
G1 E.8 F1800
G1 F1200
M204 S5000
G3 X181.789 Y156.27 I-.536 J.291 E.00795
G1 X181.789 Y162.73 E.19243
G3 X181.71 Y162.994 I-.817 J-.1 E.00825
G1 X181.716 Y156.075 E.2061
; COOLING_NODE: 0
M204 S250
G1 X181.495 Y155.79 F60000
G1 F1200
M204 S5000
G1 X168.504 Y155.79 E.38695
G3 X168.804 Y155.71 I.338 J.666 E.00931
G1 X181.262 Y155.714 E.37109
G3 X181.442 Y155.763 I-.067 J.597 E.00556
; COOLING_NODE: 0
; WIPE_START
G1 F9547.055
M204 S8000
G1 X179.442 Y155.767 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X173.037 Y159.919 Z2.8 F60000
G1 X168.29 Y162.996 Z2.8
G1 Z2.4
G1 E.8 F1800
G1 F1200
M204 S5000
G1 X168.289 Y162.995 E.00003
G3 X168.21 Y162.705 I.683 J-.343 E.00901
G1 X168.21 Y156.283 E.1913
G3 X168.29 Y156.006 I.756 J.067 E.00864
G1 X168.29 Y162.936 E.20643
; CHANGE_LAYER
; Z_HEIGHT: 2.6
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9547.055
M204 S8000
G1 X168.289 Y162.995 E-.02246
G1 X168.233 Y162.863 E-.0546
G1 X168.21 Y162.705 E-.06052
G1 X168.21 Y161.067 E-.62242
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 20/29
; update layer progress
M73 L20
M991 S0 P19 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z2.8 I-.194 J1.201 P1  F60000
G1 X181.495 Y163.211 Z2.8
G1 Z2.6
G1 E.8 F1800
G1 F1200
M204 S5000
G3 X181.193 Y163.29 I-.357 J-.745 E.00934
G1 X168.795 Y163.29 E.3693
G3 X168.505 Y163.21 I.05 J-.746 E.00902
G1 X181.435 Y163.211 E.38513
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

; COOLING_NODE: 0
; WIPE_START
G1 F9547.055
M204 S8000
G1 X181.353 Y163.269 E-.03826
G1 X181.193 Y163.29 E-.06113
G1 X179.455 Y163.29 E-.66061
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X181.71 Y156.004 Z3 F60000
G1 Z2.6
G1 E.8 F1800
G1 F1200
M204 S5000
G3 X181.789 Y156.269 I-.53 J.301 E.00829
G1 X181.789 Y162.73 E.19245
G3 X181.71 Y162.995 I-.781 J-.089 E.00827
G1 X181.71 Y156.064 E.20643
; COOLING_NODE: 0
M204 S250
G1 X181.494 Y155.79 F60000
G1 F1200
M204 S5000
G1 X168.504 Y155.79 E.38693
M73 P80 R2
G3 X168.802 Y155.71 I.339 J.669 E.00924
G1 X181.262 Y155.713 E.37114
G3 X181.441 Y155.763 I-.066 J.593 E.00555
; COOLING_NODE: 0
; WIPE_START
G1 F9547.055
M204 S8000
G1 X179.441 Y155.767 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X173.037 Y159.919 Z3 F60000
G1 X168.29 Y162.996 Z3
G1 Z2.6
G1 E.8 F1800
G1 F1200
M204 S5000
G1 X168.289 Y162.995 E.00004
G3 X168.21 Y162.706 I.725 J-.354 E.00897
G1 X168.21 Y156.282 E.19134
G3 X168.29 Y156.005 I.805 J.081 E.00863
G1 X168.29 Y162.936 E.20643
; CHANGE_LAYER
; Z_HEIGHT: 2.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9547.055
M204 S8000
G1 X168.289 Y162.995 E-.02239
G1 X168.231 Y162.856 E-.05722
G1 X168.21 Y162.706 E-.05744
G1 X168.21 Y161.067 E-.62295
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 21/29
; update layer progress
M73 L21
M991 S0 P20 ;notify layer change

M106 S206.55
; OBJECT_ID: 15
; COOLING_NODE: 2
M204 S10000
G17
G3 Z3 I-.043 J1.216 P1  F60000
G1 X179.933 Y161.479 Z3
G1 Z2.8
G1 E.8 F1800
; FEATURE: Overhang wall
; LINE_WIDTH: 0.45
M106 S229.5
G1 F600
M204 S5000
G3 X178.366 Y162.152 I-1.586 J-1.532 E.05632
G1 X171.603 Y162.152 E.21745
G3 X169.45 Y160.063 I.047 J-2.203 E.1061
G1 X169.448 Y159.007 E.03397
G3 X171.423 Y156.859 I2.208 J.048 E.10248
G1 X178.397 Y156.848 E.22426
G3 X180.55 Y158.939 I-.064 J2.22 E.10598
G1 X180.552 Y159.996 E.03398
G3 X179.974 Y161.436 I-2.205 J-.049 E.05097
M106 S206.55
; COOLING_NODE: 2
M204 S250
M73 P80 R1
G1 X179.651 Y161.207 F60000
M106 S229.5
G1 F600
M204 S5000
G3 X178.355 Y161.76 I-1.304 J-1.26 E.04653
G1 X171.615 Y161.76 E.21673
G3 X169.842 Y160.044 I.06 J-1.837 E.08698
G1 X169.84 Y159.016 E.03304
G3 X171.462 Y157.25 I1.815 J.038 E.08424
M73 P81 R1
G1 X178.385 Y157.24 E.22261
G3 X180.158 Y158.957 I-.049 J1.825 E.08715
G1 X180.16 Y159.984 E.03304
G3 X179.692 Y161.163 I-1.812 J-.037 E.04166
M106 S206.55
; COOLING_NODE: 2
; WIPE_START
M204 S8000
G1 X179.362 Y161.451 E-.16618
G1 X179.028 Y161.628 E-.14374
G1 X178.665 Y161.733 E-.14379
G1 X178.355 Y161.76 E-.11801
G1 X177.86 Y161.76 E-.18828
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z3.2 I.692 J-1.001 P1  F60000
G1 X170.526 Y156.693 Z3.2
G1 Z2.8
G1 E.8 F1800
M106 S229.5
G1 F600
M204 S5000
G2 X169.208 Y158.134 I1.146 J2.371 E.06431
G1 X169.01 Y158.096 E.00651
G1 X169.01 Y156.509 E.05104
G1 X170.479 Y156.509 E.04725
G1 X170.511 Y156.635 E.00418
M106 S206.55
; COOLING_NODE: 2
; WIPE_START
M204 S8000
G1 X170.116 Y156.938 E-.18927
G1 X169.773 Y157.237 E-.17273
G1 X169.486 Y157.59 E-.17285
G1 X169.367 Y157.784 E-.08654
G1 X169.216 Y158.116 E-.13861
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z3.2 I-1.162 J.363 P1  F60000
G1 X170.526 Y162.308 Z3.2
G1 Z2.8
G1 E.8 F1800
M106 S229.5
G1 F600
M204 S5000
G1 X170.479 Y162.491 E.00608
G1 X169.009 Y162.491 E.04725
G1 X169.009 Y160.908 E.05088
G1 X169.201 Y160.866 E.0063
G1 X169.345 Y161.175 E.01097
G2 X170.472 Y162.281 I2.333 J-1.251 E.05157
M106 S206.55
; COOLING_NODE: 2
; WIPE_START
M204 S8000
G1 X170.479 Y162.491 E-.07975
G1 X169.009 Y162.491 E-.5584
G1 X169.009 Y162.17 E-.12185
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z3.2 I-.033 J1.217 P1  F60000
G1 X180.99 Y162.491 Z3.2
G1 Z2.8
G1 E.8 F1800
M106 S229.5
G1 F600
M204 S5000
G1 X179.521 Y162.491 E.04722
G1 X179.475 Y162.306 E.00614
G2 X180.792 Y160.868 I-1.143 J-2.369 E.06424
G1 X180.99 Y160.906 E.00647
G1 X180.99 Y162.431 E.04903
M106 S206.55
; COOLING_NODE: 2
; WIPE_START
M204 S8000
G1 X179.521 Y162.491 E-.55852
G1 X179.475 Y162.306 E-.07251
G1 X179.769 Y162.137 E-.12897
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z3.2 I1.179 J.301 P1  F60000
G1 X180.79 Y158.132 Z3.2
G1 Z2.8
G1 E.8 F1800
M106 S229.5
G1 F600
M204 S5000
G2 X179.475 Y156.694 I-2.461 J.93 E.06418
G1 X179.521 Y156.509 E.00614
G1 X180.99 Y156.509 E.04722
G1 X180.99 Y158.095 E.051
G1 X180.849 Y158.121 E.0046
M106 S206.55
; COOLING_NODE: 2
; WIPE_START
M204 S8000
G1 X180.589 Y157.71 E-.18474
G1 X180.401 Y157.436 E-.12639
G1 X180.236 Y157.246 E-.09543
G1 X179.986 Y157.016 E-.12943
G1 X179.782 Y156.868 E-.0958
G1 X179.488 Y156.702 E-.12822
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z3.2 I-1.166 J.347 P1  F60000
G1 X181.318 Y162.857 Z3.2
G1 Z2.8
G1 E.8 F1800
; FEATURE: Inner wall
M106 S229.5
G1 F600
M204 S8000
G1 X181.301 Y162.869 E.00068
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

M106 S206.55
M106 S229.5
G1 X181.271 Y162.883 E.00105
M106 S206.55
M106 S229.5
G1 X181.222 Y162.895 E.00165
M106 S206.55
M106 S229.5
G1 F720
G3 X180.581 Y162.898 I-.34 J-5.223 E.0206
G1 X169.411 Y162.898 E.35921
G3 X168.772 Y162.895 I-.3 J-3.898 E.02054
M106 S206.55
M106 S229.5
G1 F600
G1 X168.744 Y162.889 E.00093
M106 S206.55
M106 S229.5
M73 P82 R1
G1 X168.724 Y162.881 E.00069
M106 S206.55
M106 S229.5
G1 X168.701 Y162.87 E.00081
M106 S206.55
M106 S229.5
G1 X168.677 Y162.854 E.00094
M106 S206.55
M106 S229.5
G1 X168.647 Y162.823 E.0014
M106 S206.55
M106 S229.5
G1 X168.628 Y162.796 E.00105
M106 S206.55
M106 S229.5
G1 X168.619 Y162.777 E.00068
M106 S206.55
M106 S229.5
G1 X168.611 Y162.754 E.00078
M106 S206.55
M106 S229.5
G1 X168.606 Y162.733 E.00069
M106 S206.55
M106 S229.5
G1 F720
G1 X168.605 Y156.272 E.20778
M106 S206.55
M106 S229.5
G1 F600
G1 X168.613 Y156.24 E.00105
M106 S206.55
M106 S229.5
G1 X168.62 Y156.22 E.00069
M106 S206.55
M106 S229.5
G1 X168.63 Y156.201 E.00069
M106 S206.55
M106 S229.5
G1 X168.649 Y156.174 E.00106
M106 S206.55
M106 S229.5
G1 X168.663 Y156.159 E.00067
M106 S206.55
M106 S229.5
G1 X168.682 Y156.143 E.00078
M106 S206.55
M106 S229.5
G1 X168.699 Y156.131 E.00069
M106 S206.55
M106 S229.5
G1 X168.729 Y156.117 E.00105
M106 S206.55
M106 S229.5
G1 X168.779 Y156.105 E.00164
M106 S206.55
M106 S229.5
G1 F720
G3 X169.419 Y156.102 I.34 J5.216 E.0206
G1 X181.191 Y156.102 E.37855
M106 S206.55
M106 S229.5
G1 X181.222 Y156.104 E.001
M106 S206.55
M106 S229.5
G1 F600
G1 X181.266 Y156.114 E.00145
M106 S206.55
M106 S229.5
G1 X181.3 Y156.13 E.00122
M106 S206.55
M106 S229.5
G1 X181.326 Y156.148 E.00104
M106 S206.55
M106 S229.5
G1 X181.348 Y156.17 E.00098
M106 S206.55
M106 S229.5
G1 X181.36 Y156.184 E.0006
M106 S206.55
M106 S229.5
G1 X181.372 Y156.203 E.00071
M106 S206.55
M106 S229.5
G1 X181.379 Y156.217 E.00052
M106 S206.55
M106 S229.5
G1 X181.384 Y156.23 E.00045
M106 S206.55
M106 S229.5
G1 X181.397 Y156.289 E.00196
M106 S206.55
M106 S229.5
G1 F720
G1 X181.397 Y162.708 E.20638
M106 S206.55
M106 S229.5
G1 F600
G1 X181.388 Y162.757 E.0016
M106 S206.55
M106 S229.5
G1 X181.379 Y162.78 E.00082
M106 S206.55
M106 S229.5
G1 X181.366 Y162.806 E.00092
M106 S206.55
M106 S229.5
G1 X181.36 Y162.814 E.00034
M106 S206.55
; COOLING_NODE: 0
M204 S250
G1 X181.556 Y163.17 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1284
M204 S5000
G1 X181.555 Y163.171 E.00004
G3 X181.193 Y163.29 I-.363 J-.495 E.01152
G1 X168.795 Y163.29 E.36932
G3 X168.444 Y163.169 I.013 J-.608 E.01123
G1 X168.436 Y163.164 E.00026
G3 X168.336 Y163.064 I.359 J-.459 E.00425
G1 X168.331 Y163.056 E.00026
G3 X168.21 Y162.705 I.487 J-.364 E.01124
G1 X168.21 Y156.282 E.19132
G3 X168.331 Y155.945 I.601 J.024 E.01084
G1 X168.343 Y155.928 E.0006
G1 X168.39 Y155.876 E.0021
G1 X168.443 Y155.831 E.00206
G1 X168.445 Y155.829 E.00009
G3 X168.807 Y155.71 I.363 J.495 E.01152
G1 X181.202 Y155.71 E.36922
G3 X181.556 Y155.831 I-.005 J.594 E.01135
G1 X181.572 Y155.843 E.00058
G1 X181.61 Y155.876 E.00149
M106 S229.5
G1 X181.645 Y155.913 E.00152
M106 S206.55
G1 X181.669 Y155.943 E.00116
G1 X181.679 Y155.956 E.00048
G3 X181.789 Y156.269 I-.549 J.369 E.00999
G1 X181.789 Y162.73 E.19245
G3 X181.669 Y163.056 I-.607 J-.038 E.0105
G1 X181.658 Y163.071 E.00056
G1 X181.61 Y163.124 E.00212
G1 X181.601 Y163.131 E.00033
; WIPE_START
G1 F9547.055
M204 S8000
G1 X181.555 Y163.171 E-.02337
G1 X181.353 Y163.269 E-.08516
G1 X181.193 Y163.29 E-.06131
G1 X179.64 Y163.29 E-.59017
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z3.2 I1.129 J-.454 P1  F60000
G1 X179.299 Y162.442 Z3.2
G1 Z2.8
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.472624
G1 F8377.858
M204 S8000
G1 X178.975 Y162.487 E.01111
; LINE_WIDTH: 0.438227
G1 F9106.844
G1 X178.795 Y162.506 E.00566
; LINE_WIDTH: 0.383632
G1 F10566.125
G1 X178.371 Y162.525 E.01141
G1 X171.597 Y162.525 E.18231
G1 X171.157 Y162.502 E.01186
; LINE_WIDTH: 0.45065
G1 F8829.372
G1 X170.96 Y162.479 E.00638
; LINE_WIDTH: 0.479411
G1 F8247.596
G1 X170.702 Y162.439 E.00899
; WIPE_START
G1 X170.96 Y162.479 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z3.2 I.161 J-1.206 P1  F60000
G1 X169.527 Y162.287 Z3.2
G1 Z2.8
G1 E.8 F1800
; LINE_WIDTH: 0.36116
G1 F11312.214
M204 S8000
G1 X169.214 Y161.427 E.02301
M204 S10000
G1 X169.229 Y161.423 F60000
; LINE_WIDTH: 0.156754
G1 F15000
M204 S8000
G1 X169.493 Y162.287 E.00813
M204 S10000
G1 X169.213 Y161.991 F60000
; LINE_WIDTH: 0.177142
G1 F15000
M204 S8000
G1 X170.027 Y162.272 E.00913
M204 S10000
G1 X170.019 Y162.287 F60000
; LINE_WIDTH: 0.407716
G1 F9868.549
M204 S8000
G1 X169.213 Y161.961 E.02505
; WIPE_START
G1 X170.019 Y162.287 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z3.2 I1.047 J-.62 P1  F60000
G1 X169.071 Y160.686 Z3.2
G1 Z2.8
G1 E.8 F1800
; LINE_WIDTH: 0.496204
G1 F7942.055
M204 S8000
G3 X169.071 Y158.315 I12.491 J-1.186 E.08502
; WIPE_START
G1 X169.025 Y159.002 E-.26157
G1 X169.027 Y160.094 E-.41505
G1 X169.043 Y160.313 E-.08338
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z3.2 I1.092 J.537 P1  F60000
G1 X170.765 Y156.808 Z3.2
G1 Z2.8
G1 E.8 F1800
; LINE_WIDTH: 0.480098
G1 F8234.644
M204 S8000
G1 X170.936 Y156.524 E.01145
; LINE_WIDTH: 0.455372
G1 F8728.29
G1 X171.145 Y156.499 E.00688
; LINE_WIDTH: 0.383915
G1 F10557.359
G1 X171.629 Y156.475 E.01304
G1 X178.403 Y156.475 E.18246
G1 X178.828 Y156.497 E.01146
; LINE_WIDTH: 0.44702
G1 F8908.703
G1 X179.023 Y156.519 E.00626
; LINE_WIDTH: 0.479123
G1 F8253.044
G1 X179.299 Y156.561 E.00962
M204 S10000
G1 X179.996 Y156.713 F60000
; LINE_WIDTH: 0.505374
G1 F7784.565
M204 S8000
G1 X180.553 Y156.946 E.02205
G1 X180.786 Y157.546 E.02353
M204 S10000
G1 X180.926 Y158.314 F60000
; LINE_WIDTH: 0.497103
G1 F7926.334
M204 S8000
G1 X180.973 Y158.911 E.02149
G3 X180.951 Y160.445 I-13.198 J.582 E.05506
G1 X180.665 Y160.636 E.01236
; CHANGE_LAYER
; Z_HEIGHT: 3
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F7926.334
G1 X180.951 Y160.445 E-.1309
G1 X180.974 Y160.002 E-.16866
G1 X180.973 Y158.911 E-.4144
G1 X180.963 Y158.79 E-.04604
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 22/29
; update layer progress
M73 L22
M991 S0 P21 ;notify layer change

M106 S229.5
; OBJECT_ID: 15
; COOLING_NODE: 2
M204 S10000
G17
G3 Z3.2 I-1.066 J-.587 P1  F60000
M73 P83 R1
G1 X179.212 Y161.973 Z3.2
G1 Z3
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X179.175 Y161.991 E.00132
G3 X178.366 Y162.152 I-.828 J-2.044 E.02669
G1 X171.603 Y162.152 E.21745
G3 X169.45 Y160.063 I.048 J-2.204 E.1061
G1 X169.448 Y159.008 E.03393
G3 X171.458 Y156.856 I2.207 J.047 E.10363
G1 X178.397 Y156.848 E.22313
G3 X180.55 Y158.941 I-.056 J2.212 E.10613
G1 X180.552 Y159.996 E.03392
G3 X179.581 Y161.775 I-2.205 J-.049 E.0677
G1 X179.264 Y161.944 E.01155
; COOLING_NODE: 2
M204 S250
G1 X179.028 Y161.627 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G3 X178.355 Y161.76 I-.681 J-1.68 E.02055
G1 X171.615 Y161.76 E.20076
G3 X169.842 Y160.044 I.06 J-1.836 E.08059
G1 X169.84 Y159.017 E.03059
G3 X171.492 Y157.247 I1.815 J.038 E.07894
G1 X178.385 Y157.24 E.20531
G3 X180.158 Y158.958 I-.042 J1.818 E.08083
G1 X180.16 Y159.984 E.03058
G3 X179.083 Y161.604 I-1.812 J-.037 E.06114
; COOLING_NODE: 2
; WIPE_START
G1 F9547.055
M204 S8000
G1 X178.664 Y161.733 E-.16655
G1 X178.355 Y161.76 E-.11788
G1 X177.104 Y161.76 E-.47558
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z3.4 I.743 J-.964 P1  F60000
G1 X170.526 Y156.693 Z3.4
G1 Z3
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G2 X169.208 Y158.134 I1.147 J2.371 E.06431
G1 X169.01 Y158.096 E.0065
G1 X169.01 Y156.509 E.05104
G1 X170.479 Y156.509 E.04725
G1 X170.511 Y156.635 E.00418
; COOLING_NODE: 2
; WIPE_START
G1 F8843.478
G1 X170.115 Y156.939 E-.18947
G1 X169.772 Y157.237 E-.17271
G1 X169.486 Y157.59 E-.17268
G1 X169.367 Y157.784 E-.08651
G1 X169.216 Y158.116 E-.13864
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z3.4 I-1.162 J.363 P1  F60000
G1 X170.526 Y162.308 Z3.4
G1 Z3
G1 E.8 F1800
G1 F1200
M204 S8000
G1 X170.479 Y162.491 E.00608
G1 X169.009 Y162.491 E.04725
G1 X169.009 Y160.909 E.05088
G1 X169.201 Y160.866 E.0063
G1 X169.345 Y161.175 E.01096
G2 X170.472 Y162.281 I2.333 J-1.251 E.05157
; COOLING_NODE: 2
; WIPE_START
G1 F8843.478
G1 X170.479 Y162.491 E-.07975
G1 X169.009 Y162.491 E-.5584
G1 X169.009 Y162.17 E-.12185
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z3.4 I-.016 J1.217 P1  F60000
G1 X179.475 Y162.306 Z3.4
G1 Z3
G1 E.8 F1800
G1 F1200
M204 S8000
G2 X180.792 Y160.868 I-1.143 J-2.369 E.06424
G1 X180.99 Y160.906 E.00647
G1 X180.99 Y162.491 E.05096
G1 X179.521 Y162.491 E.04722
G1 X179.49 Y162.364 E.00421
; COOLING_NODE: 2
; WIPE_START
G1 F8843.478
G1 X179.81 Y162.113 E-.15442
G1 X179.957 Y162.006 E-.06934
G1 X180.227 Y161.763 E-.13816
G1 X180.462 Y161.483 E-.13857
G1 X180.563 Y161.333 E-.06908
G1 X180.655 Y161.175 E-.06934
G1 X180.785 Y160.884 E-.12109
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z3.4 I1.217 J.004 P1  F60000
G1 X180.794 Y158.133 Z3.4
G1 Z3
G1 E.8 F1800
G1 F1200
M204 S8000
G2 X179.477 Y156.69 I-2.493 J.953 E.06433
G1 X179.525 Y156.509 E.00603
G1 X180.99 Y156.509 E.0471
G1 X180.99 Y158.093 E.05094
G1 X180.853 Y158.121 E.00449
; COOLING_NODE: 2
; WIPE_START
G1 F8843.478
G1 X180.588 Y157.706 E-.18719
G1 X180.441 Y157.488 E-.09991
G1 X180.229 Y157.239 E-.12432
G1 X179.985 Y157.016 E-.12546
G1 X179.771 Y156.86 E-.10064
G1 X179.492 Y156.699 E-.12249
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z3.4 I-1.165 J.351 P1  F60000
G1 X181.336 Y162.83 Z3.4
G1 Z3
G1 E.8 F1800
G1 F1200
M204 S8000
G1 X181.279 Y162.88 E.00243
G3 X181.181 Y162.898 I-.096 J-.247 E.00322
G1 X168.812 Y162.898 E.39775
G3 X168.602 Y162.69 I-.006 J-.204 E.01061
G1 X168.603 Y156.301 E.20546
G3 X168.819 Y156.102 I.205 J.006 E.01053
G1 X181.193 Y156.102 E.3979
G1 X181.287 Y156.123 E.00311
G1 X181.368 Y156.196 E.00351
G3 X181.397 Y156.287 I-.239 J.127 E.00308
M73 P84 R1
G1 X181.397 Y162.707 E.20645
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

G1 X181.373 Y162.786 E.00263
; COOLING_NODE: 0
M204 S250
G1 X181.602 Y163.129 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X181.43 Y163.239 E.00607
G3 X181.193 Y163.29 I-.243 J-.553 E.00725
G1 X168.795 Y163.29 E.3693
G3 X168.21 Y162.706 I.017 J-.602 E.02714
G1 X168.21 Y156.282 E.19134
G3 X168.807 Y155.71 I.603 J.032 E.02711
G1 X181.204 Y155.71 E.36928
G3 X181.789 Y156.269 I-.01 J.596 E.02648
G1 X181.789 Y162.729 E.19245
G3 X181.64 Y163.084 I-.603 J-.044 E.01166
; WIPE_START
G1 F9547.055
M204 S8000
G1 X181.43 Y163.239 E-.09933
G1 X181.193 Y163.29 E-.09185
G1 X179.696 Y163.29 E-.56883
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z3.4 I1.102 J-.516 P1  F60000
G1 X179.299 Y162.442 Z3.4
G1 Z3
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.472729
G1 F1200
M204 S8000
G1 X178.976 Y162.487 E.01109
; LINE_WIDTH: 0.438274
G1 X178.794 Y162.506 E.00571
; LINE_WIDTH: 0.383551
G1 X178.371 Y162.525 E.01139
G1 X171.597 Y162.525 E.18227
G1 X171.169 Y162.503 E.01153
; LINE_WIDTH: 0.449369
G1 X170.961 Y162.479 E.00674
; LINE_WIDTH: 0.479281
G1 X170.702 Y162.439 E.00901
; WIPE_START
G1 F8250.054
G1 X170.961 Y162.479 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z3.4 I.161 J-1.206 P1  F60000
G1 X169.527 Y162.287 Z3.4
G1 Z3
G1 E.8 F1800
; LINE_WIDTH: 0.362027
G1 F1200
M204 S8000
G1 X169.214 Y161.427 E.02307
M204 S10000
G1 X169.229 Y161.423 F60000
; LINE_WIDTH: 0.156824
G1 F1200
M204 S8000
G1 X169.494 Y162.287 E.00813
M204 S10000
G1 X169.213 Y161.991 F60000
; LINE_WIDTH: 0.177142
G1 F1200
M204 S8000
G1 X170.027 Y162.272 E.00913
M204 S10000
G1 X170.019 Y162.287 F60000
; LINE_WIDTH: 0.407315
G1 F1200
M204 S8000
G1 X169.213 Y161.961 E.02503
; WIPE_START
G1 F9879.403
G1 X170.019 Y162.287 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z3.4 I1.047 J-.621 P1  F60000
G1 X169.07 Y160.687 Z3.4
G1 Z3
G1 E.8 F1800
; LINE_WIDTH: 0.496183
G1 F1200
M204 S8000
G3 X169.073 Y158.316 I12.347 J-1.171 E.08502
; WIPE_START
G1 F7942.422
G1 X169.025 Y159.003 E-.26196
G1 X169.027 Y160.094 E-.41438
G1 X169.043 Y160.313 E-.08366
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z3.4 I1.113 J.492 P1  F60000
G1 X170.702 Y156.561 Z3.4
G1 Z3
G1 E.8 F1800
; LINE_WIDTH: 0.478577
G1 F1200
M204 S8000
G3 X170.981 Y156.518 I1.142 J6.563 E.00971
; LINE_WIDTH: 0.445009
G1 X171.191 Y156.495 E.00671
; LINE_WIDTH: 0.383561
G1 X171.632 Y156.475 E.01189
G1 X178.403 Y156.475 E.18218
G1 X178.816 Y156.496 E.01113
; LINE_WIDTH: 0.445745
G1 X179.021 Y156.519 E.00658
; LINE_WIDTH: 0.479132
G1 X179.3 Y156.561 E.00972
; WIPE_START
G1 F8252.88
G1 X179.021 Y156.519 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z3.4 I-.835 J.885 P1  F60000
G1 X180.926 Y158.314 Z3.4
G1 Z3
G1 E.8 F1800
; LINE_WIDTH: 0.497006
G1 F1200
M204 S8000
G1 X180.954 Y158.581 E.00962
G3 X180.974 Y160.015 I-12.956 J.902 E.05148
G1 X180.924 Y160.686 E.02412
; CHANGE_LAYER
; Z_HEIGHT: 3.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F7928.012
G1 X180.974 Y160.015 E-.25551
G1 X180.973 Y158.932 E-.41171
G1 X180.96 Y158.688 E-.09278
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 23/29
; update layer progress
M73 L23
M991 S0 P22 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 2
M204 S10000
G17
G3 Z3.4 I-1.074 J-.572 P1  F60000
G1 X179.211 Y161.973 Z3.4
G1 Z3.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X179.175 Y161.991 E.00132
G3 X178.366 Y162.152 I-.827 J-2.044 E.02669
G1 X171.603 Y162.152 E.21744
G3 X169.45 Y160.063 I.047 J-2.203 E.10612
G1 X169.448 Y159.009 E.03389
G3 X171.458 Y156.856 I2.207 J.046 E.10369
G1 X178.397 Y156.848 E.22311
G3 X180.55 Y158.94 I-.064 J2.22 E.106
G1 X180.552 Y159.989 E.03372
M73 P85 R1
G3 X179.581 Y161.775 I-2.205 J-.041 E.06794
G1 X179.264 Y161.944 E.01155
; COOLING_NODE: 2
M204 S250
G1 X179.028 Y161.628 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G3 X178.355 Y161.76 I-.68 J-1.68 E.02054
G1 X171.616 Y161.76 E.20075
G3 X169.842 Y160.044 I.06 J-1.836 E.08059
G1 X169.84 Y159.017 E.03057
G3 X171.492 Y157.247 I1.815 J.037 E.07897
G1 X178.384 Y157.24 E.20529
G3 X180.158 Y158.957 I-.049 J1.825 E.08074
G1 X180.16 Y159.979 E.03042
G3 X179.083 Y161.604 I-1.812 J-.031 E.06133
; COOLING_NODE: 2
; WIPE_START
G1 F9547.055
M204 S8000
G1 X178.664 Y161.733 E-.16649
G1 X178.355 Y161.76 E-.11778
G1 X177.103 Y161.76 E-.47573
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z3.6 I.743 J-.964 P1  F60000
G1 X170.527 Y156.694 Z3.6
G1 Z3.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G2 X169.208 Y158.134 I1.135 J2.365 E.06435
G1 X169.01 Y158.096 E.0065
G1 X169.01 Y156.509 E.05104
G1 X170.481 Y156.509 E.04732
G1 X170.513 Y156.636 E.00421
; COOLING_NODE: 2
; WIPE_START
G1 F8843.478
G1 X170.116 Y156.938 E-.18967
G1 X169.772 Y157.237 E-.17291
G1 X169.486 Y157.59 E-.17277
G1 X169.368 Y157.784 E-.08633
G1 X169.217 Y158.115 E-.13832
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z3.6 I-1.162 J.363 P1  F60000
G1 X170.526 Y162.308 Z3.6
G1 Z3.2
G1 E.8 F1800
G1 F1200
M204 S8000
G1 X170.479 Y162.491 E.00608
G1 X169.009 Y162.491 E.04725
G1 X169.009 Y160.908 E.05088
G1 X169.201 Y160.866 E.0063
G1 X169.345 Y161.175 E.01096
G2 X170.472 Y162.281 I2.333 J-1.251 E.05157
; COOLING_NODE: 2
; WIPE_START
G1 F8843.478
G1 X170.479 Y162.491 E-.07975
G1 X169.009 Y162.491 E-.55841
G1 X169.009 Y162.17 E-.12185
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z3.6 I-.016 J1.217 P1  F60000
G1 X179.475 Y162.306 Z3.6
G1 Z3.2
G1 E.8 F1800
G1 F1200
M204 S8000
G2 X180.792 Y160.868 I-1.143 J-2.369 E.06424
G1 X180.99 Y160.906 E.00647
G1 X180.99 Y162.491 E.05096
G1 X179.521 Y162.491 E.04722
G1 X179.49 Y162.364 E.00421
; COOLING_NODE: 2
; WIPE_START
G1 F8843.478
G1 X179.81 Y162.113 E-.15439
G1 X179.957 Y162.006 E-.0692
G1 X180.227 Y161.763 E-.1383
G1 X180.35 Y161.627 E-.06947
G1 X180.563 Y161.333 E-.13796
G1 X180.655 Y161.175 E-.06957
G1 X180.785 Y160.884 E-.1211
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z3.6 I1.217 J.002 P1  F60000
G1 X180.79 Y158.132 Z3.6
G1 Z3.2
G1 E.8 F1800
G1 F1200
M204 S8000
G2 X179.475 Y156.694 I-2.461 J.931 E.06418
G1 X179.521 Y156.509 E.00614
G1 X180.99 Y156.509 E.04722
G1 X180.99 Y158.095 E.05099
G1 X180.849 Y158.121 E.0046
; COOLING_NODE: 2
; WIPE_START
G1 F8843.478
G1 X180.589 Y157.71 E-.18475
G1 X180.401 Y157.436 E-.12638
G1 X180.236 Y157.246 E-.09554
G1 X179.99 Y157.02 E-.12699
G1 X179.783 Y156.869 E-.0974
G1 X179.488 Y156.702 E-.12894
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z3.6 I-1.165 J.352 P1  F60000
G1 X181.34 Y162.827 Z3.6
G1 Z3.2
G1 E.8 F1800
G1 F1200
M204 S8000
G1 X181.279 Y162.88 E.0026
G3 X181.181 Y162.898 I-.096 J-.248 E.00322
G1 X168.812 Y162.898 E.39775
G3 X168.602 Y162.69 I-.005 J-.204 E.0106
G1 X168.603 Y156.301 E.20546
G1 X168.649 Y156.174 E.00435
G1 X168.747 Y156.111 E.00374
G3 X168.819 Y156.102 I.069 J.268 E.00234
G1 X181.194 Y156.102 E.39796
G1 X181.307 Y156.135 E.00378
G3 X181.397 Y156.288 I-.109 J.166 E.00593
G1 X181.397 Y162.708 E.20642
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

G1 X181.375 Y162.781 E.00245
; COOLING_NODE: 0
M204 S250
G1 X181.604 Y163.126 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X181.43 Y163.239 E.00619
G3 X181.193 Y163.29 I-.243 J-.553 E.00725
M73 P86 R1
G1 X168.795 Y163.29 E.3693
G3 X168.21 Y162.706 I.018 J-.603 E.02712
G1 X168.21 Y156.282 E.19134
G3 X168.807 Y155.71 I.601 J.03 E.02713
G1 X181.206 Y155.71 E.36934
G3 X181.789 Y156.269 I-.014 J.597 E.02641
G1 X181.789 Y162.73 E.19245
G3 X181.644 Y163.081 I-.602 J-.044 E.01151
; WIPE_START
G1 F9547.055
M204 S8000
G1 X181.43 Y163.239 E-.10103
G1 X181.193 Y163.29 E-.09189
G1 X179.701 Y163.29 E-.56708
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z3.6 I1.1 J-.521 P1  F60000
G1 X179.299 Y162.442 Z3.6
G1 Z3.2
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.472636
G1 F1200
M204 S8000
G1 X178.975 Y162.487 E.01111
; LINE_WIDTH: 0.438161
G1 X178.794 Y162.506 E.00569
; LINE_WIDTH: 0.383698
G1 X178.371 Y162.525 E.01139
G1 X171.597 Y162.525 E.18234
G1 X171.145 Y162.501 E.01218
; LINE_WIDTH: 0.454854
G1 X170.939 Y162.476 E.00675
; LINE_WIDTH: 0.483935
G1 X170.703 Y162.439 E.00835
; WIPE_START
G1 F8162.993
G1 X170.939 Y162.476 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z3.6 I.161 J-1.206 P1  F60000
G1 X169.527 Y162.287 Z3.6
G1 Z3.2
G1 E.8 F1800
; LINE_WIDTH: 0.361893
G1 F1200
M204 S8000
G1 X169.214 Y161.427 E.02306
M204 S10000
G1 X169.229 Y161.423 F60000
; LINE_WIDTH: 0.15683
G1 F1200
M204 S8000
G1 X169.494 Y162.287 E.00813
M204 S10000
G1 X169.213 Y161.992 F60000
; LINE_WIDTH: 0.177019
G1 F1200
M204 S8000
G1 X170.027 Y162.272 E.00912
M204 S10000
G1 X170.019 Y162.287 F60000
; LINE_WIDTH: 0.407174
G1 F1200
M204 S8000
G1 X169.213 Y161.961 E.02501
; WIPE_START
G1 F9883.232
G1 X170.019 Y162.287 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z3.6 I1.047 J-.62 P1  F60000
G1 X169.071 Y160.686 Z3.6
G1 Z3.2
G1 E.8 F1800
; LINE_WIDTH: 0.496191
G1 F1200
M204 S8000
G3 X169.072 Y158.315 I12.476 J-1.184 E.08501
; WIPE_START
G1 F7942.278
G1 X169.025 Y159.005 E-.26252
G1 X169.027 Y160.094 E-.41389
G1 X169.043 Y160.313 E-.08359
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z3.6 I1.113 J.492 P1  F60000
G1 X170.704 Y156.56 Z3.6
G1 Z3.2
G1 E.8 F1800
; LINE_WIDTH: 0.478281
G1 F1200
M204 S8000
G3 X170.982 Y156.518 I1.126 J6.462 E.00966
; LINE_WIDTH: 0.444882
G1 X171.191 Y156.495 E.0067
; LINE_WIDTH: 0.383766
G1 X171.633 Y156.475 E.01189
G1 X178.403 Y156.475 E.18228
G1 X178.855 Y156.499 E.01218
; LINE_WIDTH: 0.45486
G1 X179.061 Y156.524 E.00675
; LINE_WIDTH: 0.484101
G1 X179.299 Y156.561 E.00839
M204 S10000
G1 X179.996 Y156.713 F60000
; LINE_WIDTH: 0.505383
G1 F1200
M204 S8000
G1 X180.553 Y156.946 E.02206
G1 X180.786 Y157.547 E.02356
M204 S10000
G1 X180.665 Y158.362 F60000
; LINE_WIDTH: 0.497285
G1 F1200
M204 S8000
G1 X180.951 Y158.555 E.01239
G3 X180.925 Y160.686 I-12.112 J.913 E.07658
; CHANGE_LAYER
; Z_HEIGHT: 3.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F7923.16
G1 X180.974 Y159.993 E-.26396
G1 X180.973 Y158.93 E-.40389
G1 X180.959 Y158.688 E-.09216
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 24/29
; update layer progress
M73 L24
M991 S0 P23 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 2
M204 S10000
G17
G3 Z3.6 I-1.066 J-.586 P1  F60000
G1 X179.136 Y162.003 Z3.6
G1 Z3.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X178.733 Y162.118 E.01348
G3 X178.366 Y162.152 I-.385 J-2.171 E.01187
G1 X171.603 Y162.152 E.21745
G3 X169.45 Y160.063 I.047 J-2.203 E.1061
G1 X169.448 Y159.007 E.03397
G3 X171.423 Y156.859 I2.208 J.048 E.10248
G1 X178.397 Y156.848 E.22426
G3 X180.55 Y158.939 I-.064 J2.22 E.10598
G1 X180.552 Y159.99 E.0338
G3 X179.193 Y161.984 I-2.205 J-.043 E.08209
; COOLING_NODE: 2
M204 S250
G1 X179.028 Y161.627 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G3 X178.355 Y161.76 I-.68 J-1.68 E.02055
G1 X171.615 Y161.76 E.20076
G3 X169.842 Y160.044 I.06 J-1.837 E.08057
G1 X169.84 Y159.016 E.03061
G3 X171.462 Y157.25 I1.815 J.038 E.07803
M73 P87 R1
G1 X178.385 Y157.24 E.20621
G3 X180.158 Y158.957 I-.049 J1.825 E.08072
G1 X180.16 Y159.981 E.0305
G3 X179.083 Y161.604 I-1.812 J-.033 E.06125
; COOLING_NODE: 2
; WIPE_START
G1 F9547.055
M204 S8000
G1 X178.665 Y161.733 E-.16636
G1 X178.355 Y161.76 E-.11801
G1 X177.104 Y161.76 E-.47563
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.057 Y157.102 Z3.8 F60000
G1 X170.526 Y156.693 Z3.8
G1 Z3.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G2 X169.208 Y158.134 I1.146 J2.371 E.06431
G1 X169.01 Y158.096 E.00651
G1 X169.01 Y156.509 E.05104
G1 X170.479 Y156.509 E.04725
G1 X170.511 Y156.635 E.00418
; COOLING_NODE: 2
; WIPE_START
G1 F8843.478
G1 X170.116 Y156.938 E-.18927
G1 X169.773 Y157.237 E-.17273
G1 X169.486 Y157.59 E-.17285
G1 X169.367 Y157.784 E-.08654
G1 X169.216 Y158.116 E-.13862
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X170.526 Y162.308 Z3.8 F60000
G1 Z3.4
G1 E.8 F1800
G1 F1200
M204 S8000
G1 X170.479 Y162.491 E.00608
G1 X169.009 Y162.491 E.04725
G1 X169.009 Y160.908 E.05088
G1 X169.201 Y160.866 E.0063
G1 X169.345 Y161.175 E.01097
G2 X170.472 Y162.281 I2.333 J-1.251 E.05157
; COOLING_NODE: 2
; WIPE_START
G1 F8843.478
G1 X170.479 Y162.491 E-.07975
G1 X169.009 Y162.491 E-.55839
G1 X169.009 Y162.17 E-.12186
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X176.641 Y162.269 Z3.8 F60000
G1 X179.475 Y162.306 Z3.8
G1 Z3.4
G1 E.8 F1800
G1 F1200
M204 S8000
G2 X180.792 Y160.868 I-1.143 J-2.369 E.06423
G1 X180.99 Y160.906 E.00647
G1 X180.99 Y162.491 E.05095
G1 X179.521 Y162.491 E.04722
G1 X179.49 Y162.364 E.00421
; COOLING_NODE: 2
; WIPE_START
G1 F8843.478
G1 X179.809 Y162.114 E-.15435
G1 X179.957 Y162.006 E-.06929
G1 X180.227 Y161.763 E-.13814
G1 X180.349 Y161.628 E-.0692
G1 X180.563 Y161.333 E-.13844
G1 X180.655 Y161.175 E-.06952
G1 X180.785 Y160.884 E-.12106
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X180.79 Y158.132 Z3.8 F60000
G1 Z3.4
G1 E.8 F1800
G1 F1200
M204 S8000
G2 X179.475 Y156.694 I-2.461 J.93 E.06417
G1 X179.521 Y156.509 E.00614
G1 X180.99 Y156.509 E.04722
G1 X180.99 Y158.095 E.051
G1 X180.849 Y158.121 E.0046
; COOLING_NODE: 2
; WIPE_START
G1 F8843.478
G1 X180.589 Y157.71 E-.18474
G1 X180.401 Y157.436 E-.12639
G1 X180.236 Y157.246 E-.09543
G1 X179.986 Y157.016 E-.12943
G1 X179.782 Y156.868 E-.0958
G1 X179.488 Y156.702 E-.12822
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X181.353 Y162.824 Z3.8 F60000
G1 Z3.4
G1 E.8 F1800
G1 F1200
M204 S8000
G1 X181.253 Y162.889 E.00382
G3 X181.181 Y162.898 I-.069 J-.269 E.00233
G1 X168.81 Y162.898 E.39781
G3 X168.602 Y162.688 I-.005 J-.204 E.01064
G1 X168.603 Y156.301 E.20538
G3 X168.819 Y156.102 I.204 J.004 E.01055
G1 X181.194 Y156.102 E.39796
G1 X181.235 Y156.106 E.00132
G3 X181.397 Y156.289 I-.039 J.197 E.00846
G1 X181.397 Y162.708 E.20638
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

G1 X181.374 Y162.768 E.00208
; COOLING_NODE: 0
M204 S250
G1 X181.599 Y163.131 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X181.419 Y163.244 E.00633
G3 X181.193 Y163.29 I-.231 J-.556 E.0069
G1 X168.794 Y163.29 E.36932
G3 X168.21 Y162.705 I.017 J-.602 E.02715
G1 X168.21 Y156.282 E.19131
G3 X168.807 Y155.71 I.601 J.03 E.02713
G1 X181.206 Y155.71 E.36934
G3 X181.789 Y156.269 I-.012 J.596 E.02642
G1 X181.789 Y162.73 E.19245
G3 X181.639 Y163.087 I-.601 J-.042 E.01174
; WIPE_START
M73 P88 R1
G1 F9547.055
M204 S8000
G1 X181.419 Y163.244 E-.10282
G1 X181.193 Y163.29 E-.08746
G1 X179.694 Y163.29 E-.56973
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X179.299 Y162.442 Z3.8 F60000
G1 Z3.4
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.472624
G1 F1200
M204 S8000
G1 X178.975 Y162.487 E.01111
; LINE_WIDTH: 0.438227
G1 X178.795 Y162.506 E.00566
; LINE_WIDTH: 0.38363
G1 X178.371 Y162.525 E.01141
G1 X171.597 Y162.525 E.18231
G1 X171.157 Y162.502 E.01186
; LINE_WIDTH: 0.450641
G1 X170.96 Y162.479 E.00638
; LINE_WIDTH: 0.479416
G1 X170.702 Y162.439 E.009
; WIPE_START
G1 F8247.508
G1 X170.96 Y162.479 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X169.527 Y162.287 Z3.8 F60000
G1 Z3.4
G1 E.8 F1800
; LINE_WIDTH: 0.36116
G1 F1200
M204 S8000
G1 X169.214 Y161.427 E.02301
M204 S10000
G1 X169.229 Y161.423 F60000
; LINE_WIDTH: 0.156754
G1 F1200
M204 S8000
G1 X169.493 Y162.287 E.00813
M204 S10000
G1 X169.213 Y161.992 F60000
; LINE_WIDTH: 0.177135
G1 F1200
M204 S8000
G1 X170.027 Y162.272 E.00913
M204 S10000
G1 X170.019 Y162.287 F60000
; LINE_WIDTH: 0.407709
G1 F1200
M204 S8000
G1 X169.213 Y161.961 E.02505
; WIPE_START
G1 F9868.733
G1 X170.019 Y162.287 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X169.071 Y160.686 Z3.8 F60000
G1 Z3.4
G1 E.8 F1800
; LINE_WIDTH: 0.496204
G1 F1200
M204 S8000
G3 X169.071 Y158.315 I12.491 J-1.186 E.08502
; WIPE_START
G1 F7942.055
G1 X169.025 Y159.002 E-.26157
G1 X169.027 Y160.094 E-.41505
G1 X169.043 Y160.313 E-.08338
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X170.765 Y156.809 Z3.8 F60000
G1 Z3.4
G1 E.8 F1800
; LINE_WIDTH: 0.480112
G1 F1200
M204 S8000
G1 X170.936 Y156.524 E.01146
; LINE_WIDTH: 0.45536
G1 X171.145 Y156.499 E.00688
; LINE_WIDTH: 0.383884
G1 X171.629 Y156.475 E.01304
G1 X178.403 Y156.475 E.18245
G1 X178.828 Y156.497 E.01146
; LINE_WIDTH: 0.446999
G1 X179.023 Y156.519 E.00626
; LINE_WIDTH: 0.479096
G1 X179.299 Y156.561 E.00962
M204 S10000
G1 X179.995 Y156.713 F60000
; LINE_WIDTH: 0.505349
G1 F1200
M204 S8000
G1 X180.553 Y156.946 E.02209
G1 X180.786 Y157.548 E.02358
M204 S10000
G1 X180.926 Y158.314 F60000
; LINE_WIDTH: 0.496867
G1 F1200
M204 S8000
G3 X180.925 Y160.686 I-11.628 J1.182 E.0852
; CHANGE_LAYER
; Z_HEIGHT: 3.6
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F7930.443
G1 X180.974 Y159.995 E-.26326
G1 X180.973 Y158.911 E-.41194
G1 X180.955 Y158.689 E-.0848
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 25/29
; update layer progress
M73 L25
M991 S0 P24 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 2
M204 S10000
G17
G3 Z3.8 I-1.075 J-.571 P1  F60000
G1 X179.212 Y161.973 Z3.8
G1 Z3.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X179.175 Y161.991 E.00131
G3 X178.366 Y162.152 I-.828 J-2.044 E.02669
G1 X171.603 Y162.152 E.21745
G3 X169.45 Y160.063 I.048 J-2.204 E.1061
G1 X169.448 Y159.008 E.03393
G3 X171.458 Y156.856 I2.207 J.047 E.10363
G1 X178.397 Y156.848 E.22313
G3 X180.55 Y158.941 I-.056 J2.212 E.10613
G1 X180.552 Y159.996 E.03392
G3 X179.581 Y161.775 I-2.205 J-.049 E.0677
G1 X179.264 Y161.944 E.01155
; COOLING_NODE: 2
M204 S250
G1 X179.028 Y161.627 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G3 X178.355 Y161.76 I-.681 J-1.68 E.02055
G1 X171.615 Y161.76 E.20076
G3 X169.842 Y160.044 I.06 J-1.836 E.08059
G1 X169.84 Y159.017 E.03059
G3 X171.492 Y157.247 I1.815 J.038 E.07894
G1 X178.385 Y157.24 E.20531
G3 X180.158 Y158.958 I-.042 J1.818 E.08083
G1 X180.16 Y159.984 E.03058
G3 X179.083 Y161.604 I-1.812 J-.037 E.06114
; COOLING_NODE: 2
; WIPE_START
G1 F9547.055
M204 S8000
G1 X178.664 Y161.733 E-.16655
G1 X178.355 Y161.76 E-.11788
G1 X177.104 Y161.76 E-.47558
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.057 Y157.103 Z4 F60000
G1 X170.526 Y156.693 Z4
G1 Z3.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G2 X169.208 Y158.134 I1.147 J2.371 E.06431
G1 X169.01 Y158.096 E.0065
G1 X169.01 Y156.509 E.05104
G1 X170.479 Y156.509 E.04725
G1 X170.511 Y156.635 E.00418
; COOLING_NODE: 2
; WIPE_START
G1 F8843.478
G1 X170.115 Y156.939 E-.18947
M73 P89 R1
G1 X169.772 Y157.237 E-.17271
G1 X169.486 Y157.59 E-.17268
G1 X169.367 Y157.784 E-.08651
G1 X169.216 Y158.116 E-.13864
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X170.526 Y162.308 Z4 F60000
G1 Z3.6
G1 E.8 F1800
G1 F1200
M204 S8000
G1 X170.479 Y162.491 E.00608
G1 X169.009 Y162.491 E.04725
G1 X169.009 Y160.909 E.05088
G1 X169.201 Y160.866 E.0063
G1 X169.345 Y161.175 E.01096
G2 X170.472 Y162.281 I2.333 J-1.251 E.05157
; COOLING_NODE: 2
; WIPE_START
G1 F8843.478
G1 X170.479 Y162.491 E-.07975
G1 X169.009 Y162.491 E-.55841
G1 X169.009 Y162.17 E-.12184
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X176.641 Y162.269 Z4 F60000
G1 X179.475 Y162.306 Z4
G1 Z3.6
G1 E.8 F1800
G1 F1200
M204 S8000
G2 X180.792 Y160.868 I-1.143 J-2.369 E.06424
G1 X180.99 Y160.906 E.00647
G1 X180.99 Y162.491 E.05096
G1 X179.521 Y162.491 E.04722
G1 X179.49 Y162.364 E.00421
; COOLING_NODE: 2
; WIPE_START
G1 F8843.478
G1 X179.81 Y162.113 E-.15442
G1 X179.957 Y162.006 E-.06934
G1 X180.227 Y161.763 E-.13816
G1 X180.462 Y161.483 E-.13857
G1 X180.563 Y161.333 E-.06908
G1 X180.655 Y161.175 E-.06934
G1 X180.785 Y160.884 E-.12109
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X180.794 Y158.133 Z4 F60000
G1 Z3.6
G1 E.8 F1800
G1 F1200
M204 S8000
G2 X179.477 Y156.69 I-2.493 J.953 E.06433
G1 X179.525 Y156.509 E.00603
G1 X180.99 Y156.509 E.0471
G1 X180.99 Y158.093 E.05094
G1 X180.853 Y158.121 E.00449
; COOLING_NODE: 2
; WIPE_START
G1 F8843.478
G1 X180.588 Y157.706 E-.18719
G1 X180.441 Y157.488 E-.09991
G1 X180.229 Y157.239 E-.12432
G1 X179.985 Y157.016 E-.12546
G1 X179.771 Y156.86 E-.10064
G1 X179.492 Y156.699 E-.12249
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X181.334 Y162.832 Z4 F60000
G1 Z3.6
G1 E.8 F1800
G1 F1200
M204 S8000
G1 X181.279 Y162.88 E.00233
G3 X181.181 Y162.898 I-.096 J-.247 E.00322
G1 X168.812 Y162.898 E.39775
G3 X168.602 Y162.69 I-.006 J-.204 E.01061
G1 X168.603 Y156.301 E.20546
G3 X168.819 Y156.102 I.205 J.006 E.01053
G1 X181.193 Y156.102 E.3979
G1 X181.287 Y156.123 E.00311
G1 X181.368 Y156.196 E.00351
G3 X181.397 Y156.287 I-.239 J.127 E.00308
G1 X181.397 Y162.707 E.20645
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

G1 X181.373 Y162.788 E.00272
; COOLING_NODE: 0
M204 S250
G1 X181.597 Y163.132 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X181.43 Y163.239 E.00591
G3 X181.193 Y163.29 I-.243 J-.553 E.00725
G1 X168.795 Y163.29 E.3693
G3 X168.21 Y162.706 I.017 J-.602 E.02714
G1 X168.21 Y156.282 E.19134
G3 X168.807 Y155.71 I.603 J.032 E.02711
G1 X181.204 Y155.71 E.36928
G3 X181.789 Y156.269 I-.01 J.596 E.02648
G1 X181.789 Y162.729 E.19245
G3 X181.637 Y163.088 I-.603 J-.044 E.01181
; WIPE_START
G1 F9547.055
M204 S8000
G1 X181.43 Y163.239 E-.09747
G1 X181.193 Y163.29 E-.09185
G1 X179.692 Y163.29 E-.57068
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X179.299 Y162.442 Z4 F60000
G1 Z3.6
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.472729
G1 F1200
M204 S8000
G1 X178.976 Y162.487 E.01109
; LINE_WIDTH: 0.438274
G1 X178.794 Y162.506 E.00571
; LINE_WIDTH: 0.383551
G1 X178.371 Y162.525 E.01139
G1 X171.597 Y162.525 E.18227
G1 X171.169 Y162.503 E.01153
; LINE_WIDTH: 0.449396
G1 X170.961 Y162.479 E.00674
; LINE_WIDTH: 0.479315
G1 X170.702 Y162.439 E.00901
; WIPE_START
G1 F8249.413
G1 X170.961 Y162.479 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X169.527 Y162.287 Z4 F60000
G1 Z3.6
G1 E.8 F1800
; LINE_WIDTH: 0.362027
G1 F1200
M204 S8000
M73 P90 R1
G1 X169.214 Y161.427 E.02307
M204 S10000
G1 X169.229 Y161.423 F60000
; LINE_WIDTH: 0.156824
G1 F1200
M204 S8000
G1 X169.494 Y162.287 E.00813
M204 S10000
G1 X169.213 Y161.991 F60000
; LINE_WIDTH: 0.177142
G1 F1200
M204 S8000
G1 X170.027 Y162.272 E.00913
M204 S10000
G1 X170.019 Y162.287 F60000
; LINE_WIDTH: 0.407315
G1 F1200
M204 S8000
G1 X169.213 Y161.961 E.02503
; WIPE_START
G1 F9879.403
G1 X170.019 Y162.287 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X169.07 Y160.687 Z4 F60000
G1 Z3.6
G1 E.8 F1800
; LINE_WIDTH: 0.496183
G1 F1200
M204 S8000
G3 X169.073 Y158.316 I12.347 J-1.171 E.08502
; WIPE_START
G1 F7942.422
G1 X169.025 Y159.003 E-.26196
G1 X169.027 Y160.094 E-.41438
G1 X169.043 Y160.313 E-.08366
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X170.702 Y156.561 Z4 F60000
G1 Z3.6
G1 E.8 F1800
; LINE_WIDTH: 0.478577
G1 F1200
M204 S8000
G3 X170.981 Y156.518 I1.142 J6.563 E.00971
; LINE_WIDTH: 0.445009
G1 X171.191 Y156.495 E.00671
; LINE_WIDTH: 0.383561
G1 X171.632 Y156.475 E.01189
G1 X178.403 Y156.475 E.18218
G1 X178.816 Y156.496 E.01113
; LINE_WIDTH: 0.445745
G1 X179.021 Y156.519 E.00658
; LINE_WIDTH: 0.479132
G1 X179.3 Y156.561 E.00972
; WIPE_START
G1 F8252.88
G1 X179.021 Y156.519 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X180.926 Y158.314 Z4 F60000
G1 Z3.6
G1 E.8 F1800
; LINE_WIDTH: 0.497006
G1 F1200
M204 S8000
G1 X180.954 Y158.581 E.00962
G3 X180.974 Y160.015 I-12.956 J.902 E.05148
G1 X180.924 Y160.686 E.02412
; CHANGE_LAYER
; Z_HEIGHT: 3.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F7928.012
G1 X180.974 Y160.015 E-.25551
G1 X180.973 Y158.932 E-.41171
G1 X180.96 Y158.688 E-.09278
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 26/29
; update layer progress
M73 L26
M991 S0 P25 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 2
M204 S10000
G17
G3 Z4 I-1.074 J-.572 P1  F60000
G1 X179.211 Y161.973 Z4
G1 Z3.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X179.175 Y161.991 E.00132
G3 X178.366 Y162.152 I-.827 J-2.044 E.02669
G1 X171.603 Y162.152 E.21744
G3 X169.45 Y160.063 I.047 J-2.203 E.10612
G1 X169.448 Y159.009 E.03389
G3 X171.458 Y156.856 I2.207 J.046 E.10369
G1 X178.396 Y156.848 E.22311
G3 X180.55 Y158.94 I-.064 J2.22 E.106
G1 X180.552 Y159.98 E.03345
G3 X179.581 Y161.775 I-2.205 J-.033 E.06821
M73 P90 R0
G1 X179.264 Y161.944 E.01155
; COOLING_NODE: 2
M204 S250
G1 X179.028 Y161.628 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G3 X178.355 Y161.76 I-.68 J-1.68 E.02054
G1 X171.616 Y161.76 E.20075
G3 X169.842 Y160.044 I.06 J-1.836 E.08059
G1 X169.84 Y159.017 E.03057
G3 X171.492 Y157.247 I1.815 J.037 E.07897
G1 X178.384 Y157.24 E.20529
G3 X180.158 Y158.957 I-.049 J1.825 E.08074
G1 X180.16 Y159.971 E.0302
G3 X179.083 Y161.604 I-1.812 J-.024 E.06155
; COOLING_NODE: 2
; WIPE_START
G1 F9547.055
M204 S8000
G1 X178.664 Y161.733 E-.16649
G1 X178.355 Y161.76 E-.11778
G1 X177.103 Y161.76 E-.47573
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.057 Y157.102 Z4.2 F60000
G1 X170.527 Y156.694 Z4.2
G1 Z3.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G2 X169.208 Y158.134 I1.135 J2.365 E.06435
G1 X169.01 Y158.096 E.0065
G1 X169.01 Y156.509 E.05104
G1 X170.481 Y156.509 E.04733
G1 X170.513 Y156.636 E.00421
; COOLING_NODE: 2
; WIPE_START
G1 F8843.478
G1 X170.116 Y156.938 E-.18967
G1 X169.772 Y157.237 E-.17291
G1 X169.486 Y157.59 E-.17277
G1 X169.368 Y157.784 E-.08633
G1 X169.217 Y158.115 E-.13832
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X170.526 Y162.308 Z4.2 F60000
G1 Z3.8
G1 E.8 F1800
G1 F1200
M204 S8000
G1 X170.479 Y162.491 E.00608
G1 X169.009 Y162.491 E.04725
G1 X169.009 Y160.908 E.05088
G1 X169.201 Y160.866 E.0063
G1 X169.345 Y161.175 E.01096
G2 X170.472 Y162.281 I2.333 J-1.251 E.05157
; COOLING_NODE: 2
; WIPE_START
G1 F8843.478
G1 X170.479 Y162.491 E-.07975
G1 X169.009 Y162.491 E-.55841
G1 X169.009 Y162.17 E-.12184
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X176.641 Y162.269 Z4.2 F60000
G1 X179.475 Y162.306 Z4.2
G1 Z3.8
G1 E.8 F1800
G1 F1200
M204 S8000
G2 X180.792 Y160.868 I-1.143 J-2.369 E.06424
G1 X180.99 Y160.906 E.00647
G1 X180.99 Y162.491 E.05096
G1 X179.521 Y162.491 E.04722
G1 X179.49 Y162.364 E.00421
; COOLING_NODE: 2
; WIPE_START
G1 F8843.478
G1 X179.81 Y162.113 E-.15439
G1 X179.957 Y162.006 E-.0692
G1 X180.227 Y161.763 E-.1383
G1 X180.35 Y161.627 E-.06947
G1 X180.563 Y161.333 E-.13796
G1 X180.655 Y161.175 E-.06957
G1 X180.785 Y160.884 E-.1211
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X180.79 Y158.132 Z4.2 F60000
G1 Z3.8
G1 E.8 F1800
G1 F1200
M204 S8000
G2 X179.475 Y156.694 I-2.461 J.931 E.06418
G1 X179.521 Y156.509 E.00614
G1 X180.99 Y156.509 E.04722
G1 X180.99 Y158.095 E.051
G1 X180.849 Y158.121 E.0046
; COOLING_NODE: 2
; WIPE_START
G1 F8843.478
G1 X180.589 Y157.71 E-.18475
M73 P91 R0
G1 X180.401 Y157.436 E-.12638
G1 X180.236 Y157.246 E-.09554
G1 X179.99 Y157.02 E-.12699
G1 X179.783 Y156.869 E-.0974
G1 X179.488 Y156.702 E-.12894
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X181.338 Y162.829 Z4.2 F60000
G1 Z3.8
G1 E.8 F1800
G1 F1200
M204 S8000
G1 X181.279 Y162.88 E.0025
G3 X181.181 Y162.898 I-.096 J-.248 E.00322
G1 X168.812 Y162.898 E.39774
G3 X168.602 Y162.69 I-.006 J-.205 E.0106
G1 X168.603 Y156.301 E.20546
G1 X168.649 Y156.174 E.00435
G1 X168.747 Y156.111 E.00374
G3 X168.819 Y156.102 I.069 J.268 E.00234
G1 X181.191 Y156.102 E.39784
G1 X181.307 Y156.135 E.00389
G3 X181.397 Y156.288 I-.109 J.166 E.00593
G1 X181.397 Y162.708 E.20642
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

G1 X181.374 Y162.784 E.00254
; COOLING_NODE: 0
M204 S250
G1 X181.599 Y163.129 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X181.43 Y163.239 E.00603
G3 X181.193 Y163.29 I-.243 J-.553 E.00725
G1 X168.795 Y163.29 E.3693
G3 X168.21 Y162.706 I.018 J-.603 E.02712
G1 X168.21 Y156.282 E.19134
G3 X168.807 Y155.71 I.601 J.03 E.02713
G1 X181.202 Y155.71 E.36921
G3 X181.789 Y156.269 I-.009 J.597 E.02653
G1 X181.789 Y162.73 E.19245
G3 X181.64 Y163.085 I-.602 J-.044 E.01166
; WIPE_START
G1 F9547.055
M204 S8000
G1 X181.43 Y163.239 E-.09919
G1 X181.193 Y163.29 E-.09189
G1 X179.696 Y163.29 E-.56893
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X179.299 Y162.442 Z4.2 F60000
G1 Z3.8
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.472637
G1 F1200
M204 S8000
G1 X178.975 Y162.487 E.01111
; LINE_WIDTH: 0.438161
G1 X178.794 Y162.506 E.00569
; LINE_WIDTH: 0.383699
G1 X178.371 Y162.525 E.01139
G1 X171.597 Y162.525 E.18234
G1 X171.145 Y162.501 E.01218
; LINE_WIDTH: 0.454873
G1 X170.939 Y162.476 E.00675
; LINE_WIDTH: 0.483947
G1 X170.702 Y162.441 E.00836
; WIPE_START
G1 F8162.767
G1 X170.939 Y162.476 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X169.527 Y162.287 Z4.2 F60000
G1 Z3.8
G1 E.8 F1800
; LINE_WIDTH: 0.361893
G1 F1200
M204 S8000
G1 X169.214 Y161.427 E.02306
M204 S10000
G1 X169.229 Y161.423 F60000
; LINE_WIDTH: 0.15683
G1 F1200
M204 S8000
G1 X169.494 Y162.287 E.00813
M204 S10000
G1 X169.213 Y161.992 F60000
; LINE_WIDTH: 0.176977
G1 F1200
M204 S8000
G1 X170.027 Y162.272 E.00912
M204 S10000
G1 X170.019 Y162.287 F60000
; LINE_WIDTH: 0.407188
G1 F1200
M204 S8000
G1 X169.213 Y161.961 E.02502
; WIPE_START
G1 F9882.849
G1 X170.019 Y162.287 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X169.071 Y160.686 Z4.2 F60000
G1 Z3.8
G1 E.8 F1800
; LINE_WIDTH: 0.49619
G1 F1200
M204 S8000
G3 X169.072 Y158.315 I12.476 J-1.184 E.08501
; WIPE_START
G1 F7942.286
G1 X169.025 Y159.005 E-.26252
G1 X169.027 Y160.094 E-.41389
G1 X169.043 Y160.313 E-.08359
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X170.704 Y156.56 Z4.2 F60000
G1 Z3.8
G1 E.8 F1800
; LINE_WIDTH: 0.478291
G1 F1200
M204 S8000
G3 X170.982 Y156.518 I1.101 J6.294 E.00966
; LINE_WIDTH: 0.444902
G1 X171.191 Y156.495 E.0067
; LINE_WIDTH: 0.383797
G1 X171.633 Y156.475 E.01189
G1 X178.403 Y156.475 E.1823
G1 X178.855 Y156.499 E.01219
; LINE_WIDTH: 0.454899
G1 X179.061 Y156.524 E.00675
; LINE_WIDTH: 0.484118
G1 X179.299 Y156.561 E.00839
M204 S10000
G1 X179.996 Y156.713 F60000
; LINE_WIDTH: 0.505404
G1 F1200
M204 S8000
G1 X180.553 Y156.946 E.02205
G1 X180.786 Y157.547 E.02357
M204 S10000
G1 X180.665 Y158.362 F60000
; LINE_WIDTH: 0.497276
G1 F1200
M204 S8000
G1 X180.951 Y158.555 E.01239
G3 X180.925 Y160.686 I-12.107 J.913 E.07658
; CHANGE_LAYER
; Z_HEIGHT: 4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F7923.303
G1 X180.974 Y159.995 E-.26311
G1 X180.973 Y158.93 E-.40473
M73 P92 R0
G1 X180.959 Y158.688 E-.09215
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 27/29
; update layer progress
M73 L27
M991 S0 P26 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 2
M204 S10000
G17
G3 Z4.2 I-1.066 J-.586 P1  F60000
G1 X179.136 Y162.003 Z4.2
G1 Z4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X178.733 Y162.118 E.01348
G3 X178.366 Y162.152 I-.385 J-2.171 E.01187
G1 X171.603 Y162.152 E.21745
G3 X169.45 Y160.063 I.047 J-2.203 E.1061
G1 X169.448 Y159.007 E.03397
G3 X171.423 Y156.859 I2.208 J.048 E.10248
G1 X178.397 Y156.848 E.22426
G3 X180.55 Y158.939 I-.064 J2.22 E.10598
G1 X180.552 Y159.988 E.03372
G3 X179.192 Y161.984 I-2.205 J-.041 E.08217
; COOLING_NODE: 2
M204 S250
G1 X179.028 Y161.627 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G3 X178.355 Y161.76 I-.68 J-1.68 E.02055
G1 X171.615 Y161.76 E.20076
G3 X169.842 Y160.044 I.06 J-1.837 E.08057
G1 X169.84 Y159.016 E.03061
G3 X171.462 Y157.25 I1.815 J.038 E.07803
G1 X178.385 Y157.24 E.20621
G3 X180.158 Y158.957 I-.049 J1.825 E.08072
G1 X180.16 Y159.978 E.03043
G3 X179.083 Y161.604 I-1.812 J-.031 E.06132
; COOLING_NODE: 2
; WIPE_START
G1 F9547.055
M204 S8000
G1 X178.665 Y161.733 E-.16636
G1 X178.355 Y161.76 E-.11801
G1 X177.104 Y161.76 E-.47563
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.057 Y157.102 Z4.4 F60000
G1 X170.526 Y156.693 Z4.4
G1 Z4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G2 X169.208 Y158.134 I1.146 J2.371 E.06431
G1 X169.01 Y158.096 E.00651
G1 X169.01 Y156.509 E.05104
G1 X170.479 Y156.509 E.04725
G1 X170.511 Y156.635 E.00418
; COOLING_NODE: 2
; WIPE_START
G1 F8843.478
G1 X170.116 Y156.938 E-.18924
G1 X169.773 Y157.237 E-.17273
G1 X169.486 Y157.59 E-.17285
G1 X169.367 Y157.784 E-.08654
G1 X169.216 Y158.116 E-.13864
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X170.526 Y162.308 Z4.4 F60000
G1 Z4
G1 E.8 F1800
G1 F1200
M204 S8000
G1 X170.479 Y162.491 E.00608
G1 X169.009 Y162.491 E.04725
G1 X169.009 Y160.908 E.05088
G1 X169.201 Y160.866 E.0063
G1 X169.345 Y161.175 E.01097
G2 X170.472 Y162.281 I2.333 J-1.251 E.05157
; COOLING_NODE: 2
; WIPE_START
G1 F8843.478
G1 X170.479 Y162.491 E-.07975
G1 X169.009 Y162.491 E-.55839
G1 X169.009 Y162.17 E-.12186
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X176.641 Y162.269 Z4.4 F60000
G1 X179.475 Y162.306 Z4.4
G1 Z4
G1 E.8 F1800
G1 F1200
M204 S8000
G2 X180.792 Y160.868 I-1.143 J-2.369 E.06423
G1 X180.99 Y160.906 E.00647
G1 X180.99 Y162.491 E.05095
G1 X179.521 Y162.491 E.04722
G1 X179.49 Y162.364 E.00421
; COOLING_NODE: 2
; WIPE_START
G1 F8843.478
G1 X179.809 Y162.114 E-.15435
G1 X179.957 Y162.006 E-.06929
G1 X180.227 Y161.763 E-.13814
G1 X180.349 Y161.628 E-.0692
G1 X180.563 Y161.333 E-.13844
G1 X180.655 Y161.175 E-.06952
G1 X180.785 Y160.884 E-.12106
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X180.79 Y158.132 Z4.4 F60000
G1 Z4
G1 E.8 F1800
G1 F1200
M204 S8000
G2 X179.475 Y156.694 I-2.461 J.93 E.06418
G1 X179.521 Y156.509 E.00614
G1 X180.99 Y156.509 E.04722
G1 X180.99 Y158.095 E.051
G1 X180.849 Y158.121 E.0046
; COOLING_NODE: 2
; WIPE_START
G1 F8843.478
G1 X180.589 Y157.71 E-.18474
G1 X180.401 Y157.436 E-.12639
G1 X180.236 Y157.246 E-.09543
G1 X179.986 Y157.016 E-.12943
G1 X179.782 Y156.868 E-.0958
G1 X179.488 Y156.702 E-.12822
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X181.353 Y162.824 Z4.4 F60000
G1 Z4
G1 E.8 F1800
G1 F1200
M204 S8000
G1 X181.253 Y162.889 E.00382
G3 X181.181 Y162.898 I-.069 J-.269 E.00233
G1 X168.812 Y162.898 E.39775
G3 X168.602 Y162.688 I-.006 J-.204 E.01069
G1 X168.603 Y156.301 E.20538
G3 X168.816 Y156.102 I.204 J.004 E.01047
G1 X181.222 Y156.104 E.39893
G1 X181.235 Y156.106 E.00042
G3 X181.397 Y156.289 I-.039 J.197 E.00846
G1 X181.397 Y162.708 E.20638
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

M73 P93 R0
G1 X181.374 Y162.768 E.00208
; COOLING_NODE: 0
M204 S250
G1 X181.594 Y163.134 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X181.419 Y163.244 E.00617
G3 X181.193 Y163.29 I-.231 J-.556 E.0069
G1 X168.795 Y163.29 E.36931
G3 X168.21 Y162.705 I.017 J-.602 E.02716
G1 X168.21 Y156.282 E.19132
G3 X168.802 Y155.71 I.601 J.03 E.02699
G1 X181.262 Y155.714 E.37115
G3 X181.789 Y156.269 I-.064 J.588 E.02479
G1 X181.789 Y162.73 E.19245
G3 X181.636 Y163.091 I-.601 J-.042 E.01189
; WIPE_START
G1 F9547.055
M204 S8000
G1 X181.419 Y163.244 E-.10096
G1 X181.193 Y163.29 E-.08745
G1 X179.689 Y163.29 E-.57159
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X179.299 Y162.442 Z4.4 F60000
G1 Z4
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.472624
G1 F1200
M204 S8000
G1 X178.975 Y162.487 E.01111
; LINE_WIDTH: 0.438227
G1 X178.795 Y162.506 E.00566
; LINE_WIDTH: 0.38363
G1 X178.371 Y162.525 E.01141
G1 X171.597 Y162.525 E.18231
G1 X171.157 Y162.502 E.01186
; LINE_WIDTH: 0.450641
G1 X170.96 Y162.479 E.00638
; LINE_WIDTH: 0.479416
G1 X170.702 Y162.439 E.009
; WIPE_START
G1 F8247.508
G1 X170.96 Y162.479 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X169.527 Y162.287 Z4.4 F60000
G1 Z4
G1 E.8 F1800
; LINE_WIDTH: 0.36116
G1 F1200
M204 S8000
G1 X169.214 Y161.427 E.02301
M204 S10000
G1 X169.229 Y161.423 F60000
; LINE_WIDTH: 0.156754
G1 F1200
M204 S8000
G1 X169.493 Y162.287 E.00813
M204 S10000
G1 X169.213 Y161.992 F60000
; LINE_WIDTH: 0.177135
G1 F1200
M204 S8000
G1 X170.027 Y162.272 E.00913
M204 S10000
G1 X170.019 Y162.287 F60000
; LINE_WIDTH: 0.407709
G1 F1200
M204 S8000
G1 X169.213 Y161.961 E.02505
; WIPE_START
G1 F9868.733
G1 X170.019 Y162.287 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X169.071 Y160.686 Z4.4 F60000
G1 Z4
G1 E.8 F1800
; LINE_WIDTH: 0.496204
G1 F1200
M204 S8000
G3 X169.071 Y158.315 I12.491 J-1.186 E.08502
; WIPE_START
G1 F7942.055
G1 X169.025 Y159.002 E-.26157
G1 X169.027 Y160.094 E-.41505
G1 X169.043 Y160.313 E-.08338
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X170.765 Y156.808 Z4.4 F60000
G1 Z4
G1 E.8 F1800
; LINE_WIDTH: 0.480169
G1 F1200
M204 S8000
G1 X170.936 Y156.524 E.01145
; LINE_WIDTH: 0.455332
G1 X171.145 Y156.499 E.00688
; LINE_WIDTH: 0.3839
G1 X171.629 Y156.475 E.01304
G1 X178.403 Y156.475 E.18245
G1 X178.828 Y156.497 E.01146
; LINE_WIDTH: 0.447036
G1 X179.023 Y156.519 E.00626
; LINE_WIDTH: 0.479125
G1 X179.299 Y156.561 E.00962
M204 S10000
G1 X179.995 Y156.713 F60000
; LINE_WIDTH: 0.505384
G1 F1200
M204 S8000
G1 X180.553 Y156.946 E.02209
G1 X180.786 Y157.547 E.02356
M204 S10000
G1 X180.926 Y158.314 F60000
; LINE_WIDTH: 0.496865
G1 F1200
M204 S8000
G3 X180.925 Y160.686 I-11.654 J1.182 E.0852
; CHANGE_LAYER
; Z_HEIGHT: 4.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F7930.485
G1 X180.974 Y159.993 E-.26424
G1 X180.973 Y158.911 E-.41096
G1 X180.955 Y158.689 E-.08479
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 28/29
; update layer progress
M73 L28
M991 S0 P27 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 2
M204 S10000
G17
G3 Z4.4 I-1.067 J-.586 P1  F60000
G1 X179.136 Y162.003 Z4.4
G1 Z4.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X178.732 Y162.118 E.0135
G3 X178.366 Y162.152 I-.385 J-2.171 E.01185
G1 X171.603 Y162.152 E.21745
G3 X169.45 Y160.063 I.048 J-2.204 E.1061
G1 X169.448 Y159.008 E.03393
G3 X171.458 Y156.856 I2.207 J.047 E.10363
G1 X178.397 Y156.848 E.22313
G3 X180.55 Y158.941 I-.056 J2.212 E.10613
G1 X180.552 Y159.996 E.03392
G3 X179.192 Y161.984 I-2.205 J-.049 E.08192
; COOLING_NODE: 2
M204 S250
G1 X179.028 Y161.627 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
M73 P94 R0
G1 F1200
M204 S5000
G3 X178.355 Y161.76 I-.681 J-1.68 E.02055
G1 X171.615 Y161.76 E.20076
G3 X169.842 Y160.044 I.06 J-1.836 E.08059
G1 X169.84 Y159.017 E.03059
G3 X171.492 Y157.247 I1.815 J.038 E.07894
G1 X178.385 Y157.24 E.20531
G3 X180.158 Y158.958 I-.042 J1.818 E.08083
G1 X180.16 Y159.984 E.03058
G3 X179.083 Y161.604 I-1.812 J-.037 E.06114
; COOLING_NODE: 2
; WIPE_START
G1 F9547.055
M204 S8000
G1 X178.664 Y161.733 E-.16655
G1 X178.355 Y161.76 E-.11788
G1 X177.104 Y161.76 E-.47558
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.057 Y157.103 Z4.6 F60000
G1 X170.526 Y156.693 Z4.6
G1 Z4.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G2 X169.208 Y158.134 I1.147 J2.371 E.06431
G1 X169.01 Y158.096 E.0065
G1 X169.01 Y156.509 E.05104
G1 X170.479 Y156.509 E.04725
G1 X170.511 Y156.635 E.00418
; COOLING_NODE: 2
; WIPE_START
G1 F8843.478
G1 X170.115 Y156.939 E-.18945
G1 X169.772 Y157.237 E-.17271
G1 X169.486 Y157.59 E-.17268
G1 X169.367 Y157.784 E-.08651
G1 X169.216 Y158.116 E-.13865
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X170.526 Y162.308 Z4.6 F60000
G1 Z4.2
G1 E.8 F1800
G1 F1200
M204 S8000
G1 X170.479 Y162.491 E.00608
G1 X169.009 Y162.491 E.04725
G1 X169.009 Y160.909 E.05088
G1 X169.201 Y160.866 E.0063
G1 X169.345 Y161.175 E.01096
G2 X170.472 Y162.281 I2.332 J-1.25 E.05157
; COOLING_NODE: 2
; WIPE_START
G1 F8843.478
G1 X170.479 Y162.491 E-.07975
G1 X169.009 Y162.491 E-.55841
G1 X169.009 Y162.17 E-.12184
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X176.641 Y162.269 Z4.6 F60000
G1 X179.475 Y162.306 Z4.6
G1 Z4.2
G1 E.8 F1800
G1 F1200
M204 S8000
G2 X180.792 Y160.868 I-1.143 J-2.369 E.06424
G1 X180.99 Y160.906 E.00647
G1 X180.99 Y162.491 E.05096
G1 X179.521 Y162.491 E.04722
G1 X179.49 Y162.364 E.00421
; COOLING_NODE: 2
; WIPE_START
G1 F8843.478
G1 X179.81 Y162.113 E-.1544
G1 X179.957 Y162.006 E-.06934
G1 X180.227 Y161.763 E-.13816
G1 X180.462 Y161.483 E-.13857
G1 X180.563 Y161.333 E-.06908
G1 X180.655 Y161.175 E-.06934
G1 X180.785 Y160.884 E-.12111
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X180.794 Y158.133 Z4.6 F60000
G1 Z4.2
G1 E.8 F1800
G1 F1200
M204 S8000
G2 X179.477 Y156.69 I-2.493 J.953 E.06433
G1 X179.525 Y156.509 E.00603
G1 X180.99 Y156.509 E.0471
G1 X180.99 Y158.093 E.05095
G1 X180.853 Y158.121 E.00449
; COOLING_NODE: 2
; WIPE_START
G1 F8843.478
G1 X180.588 Y157.706 E-.18719
G1 X180.441 Y157.488 E-.09991
G1 X180.229 Y157.239 E-.12432
G1 X179.985 Y157.016 E-.12546
G1 X179.771 Y156.86 E-.10064
G1 X179.492 Y156.699 E-.12249
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X181.356 Y162.819 Z4.6 F60000
G1 Z4.2
G1 E.8 F1800
G1 F1200
M204 S8000
G1 X181.248 Y162.891 E.00417
G3 X181.182 Y162.898 I-.061 J-.25 E.00215
G1 X168.812 Y162.898 E.39777
G3 X168.602 Y162.69 I-.006 J-.204 E.01061
G1 X168.603 Y156.301 E.20546
G3 X168.818 Y156.102 I.205 J.006 E.01051
G1 X181.222 Y156.104 E.39888
G1 X181.307 Y156.135 E.0029
G1 X181.368 Y156.196 E.00278
G3 X181.397 Y156.287 I-.239 J.127 E.00308
G1 X181.397 Y162.707 E.20645
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

G1 X181.377 Y162.763 E.0019
; COOLING_NODE: 0
M204 S250
G1 X181.593 Y163.135 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X181.43 Y163.239 E.00576
G3 X181.196 Y163.29 I-.243 J-.553 E.00717
G1 X168.795 Y163.29 E.36938
G3 X168.21 Y162.706 I.017 J-.602 E.02713
G1 X168.21 Y156.282 E.19134
G3 X168.804 Y155.71 I.603 J.032 E.02703
G1 X181.262 Y155.714 E.37108
G3 X181.789 Y156.269 I-.064 J.588 E.02479
M73 P95 R0
G1 X181.789 Y162.729 E.19245
G3 X181.634 Y163.092 I-.603 J-.044 E.01195
; WIPE_START
G1 F9547.055
M204 S8000
G1 X181.43 Y163.239 E-.09571
G1 X181.196 Y163.29 E-.09088
G1 X179.687 Y163.29 E-.57342
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X179.299 Y162.442 Z4.6 F60000
G1 Z4.2
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.47272
G1 F1200
M204 S8000
G1 X178.976 Y162.487 E.01109
; LINE_WIDTH: 0.438245
G1 X178.794 Y162.506 E.00571
; LINE_WIDTH: 0.383534
G1 X178.371 Y162.525 E.01139
G1 X171.597 Y162.525 E.18226
G1 X171.169 Y162.503 E.01153
; LINE_WIDTH: 0.449393
G1 X170.961 Y162.479 E.00674
; LINE_WIDTH: 0.479316
G1 X170.702 Y162.439 E.00901
; WIPE_START
G1 F8249.396
G1 X170.961 Y162.479 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X169.527 Y162.287 Z4.6 F60000
G1 Z4.2
G1 E.8 F1800
; LINE_WIDTH: 0.362027
G1 F1200
M204 S8000
G1 X169.214 Y161.427 E.02307
M204 S10000
G1 X169.229 Y161.423 F60000
; LINE_WIDTH: 0.156824
G1 F1200
M204 S8000
G1 X169.494 Y162.287 E.00813
M204 S10000
G1 X169.213 Y161.991 F60000
; LINE_WIDTH: 0.177142
G1 F1200
M204 S8000
G1 X170.027 Y162.272 E.00913
M204 S10000
G1 X170.019 Y162.287 F60000
; LINE_WIDTH: 0.407315
G1 F1200
M204 S8000
G1 X169.213 Y161.961 E.02503
; WIPE_START
G1 F9879.403
G1 X170.019 Y162.287 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X169.07 Y160.687 Z4.6 F60000
G1 Z4.2
G1 E.8 F1800
; LINE_WIDTH: 0.496183
G1 F1200
M204 S8000
G3 X169.073 Y158.316 I12.347 J-1.171 E.08502
; WIPE_START
G1 F7942.422
G1 X169.025 Y159.003 E-.26196
G1 X169.027 Y160.094 E-.41438
G1 X169.043 Y160.313 E-.08366
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X170.702 Y156.561 Z4.6 F60000
G1 Z4.2
G1 E.8 F1800
; LINE_WIDTH: 0.478575
G1 F1200
M204 S8000
G3 X170.981 Y156.518 I1.109 J6.33 E.00971
; LINE_WIDTH: 0.44499
G1 X171.191 Y156.495 E.00671
; LINE_WIDTH: 0.383578
G1 X171.632 Y156.475 E.01189
G1 X178.403 Y156.475 E.18219
G1 X178.816 Y156.496 E.01113
; LINE_WIDTH: 0.445789
G1 X179.021 Y156.519 E.00658
; LINE_WIDTH: 0.479169
G1 X179.3 Y156.561 E.00972
; WIPE_START
G1 F8252.167
G1 X179.021 Y156.519 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X180.926 Y158.314 Z4.6 F60000
G1 Z4.2
G1 E.8 F1800
; LINE_WIDTH: 0.497006
G1 F1200
M204 S8000
G1 X180.954 Y158.581 E.00962
G3 X180.974 Y160.015 I-12.956 J.902 E.05148
G1 X180.924 Y160.686 E.02412
; CHANGE_LAYER
; Z_HEIGHT: 4.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F7928.012
G1 X180.974 Y160.015 E-.25551
G1 X180.973 Y158.932 E-.41171
G1 X180.96 Y158.688 E-.09278
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 29/29
; update layer progress
M73 L29
M991 S0 P28 ;notify layer change

M106 S226.95
; OBJECT_ID: 15
; COOLING_NODE: 2
M204 S10000
G17
G3 Z4.6 I-1.017 J-.668 P1  F60000
G1 X179.028 Y161.628 Z4.6
G1 Z4.4
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1299
M204 S5000
G3 X178.355 Y161.76 I-.68 J-1.68 E.02054
G1 X171.616 Y161.76 E.20075
G3 X169.842 Y160.044 I.06 J-1.836 E.08059
G1 X169.84 Y159.017 E.03057
G3 X171.492 Y157.247 I1.815 J.037 E.07897
G1 X178.384 Y157.24 E.20529
G3 X180.158 Y158.957 I-.049 J1.825 E.08074
G1 X180.16 Y159.984 E.03059
G3 X179.083 Y161.604 I-1.812 J-.037 E.06116
; COOLING_NODE: 0
; WIPE_START
G1 F9547.055
M204 S8000
G1 X178.664 Y161.733 E-.16649
G1 X178.355 Y161.76 E-.11778
G1 X177.103 Y161.76 E-.47573
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X181.596 Y163.131 Z4.8 F60000
G1 Z4.4
G1 E.8 F1800
G1 F1222
M204 S5000
G1 X181.43 Y163.239 E.0059
G3 X181.195 Y163.29 I-.243 J-.553 E.0072
G1 X168.795 Y163.29 E.36935
G3 X168.21 Y162.706 I.018 J-.603 E.02712
G1 X168.21 Y156.283 E.19132
G3 X168.805 Y155.71 I.601 J.029 E.02711
G1 X181.262 Y155.714 E.37106
G3 X181.789 Y156.269 I-.065 J.589 E.02479
G1 X181.789 Y162.73 E.19245
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

G3 X181.637 Y163.088 I-.602 J-.044 E.01179
M204 S10000
M73 P96 R0
G1 X180.716 Y163.083 F60000
; FEATURE: Top surface
G1 F1299
M204 S2000
G1 X181.582 Y162.217 E.03646
G1 X181.715 Y162.084
G1 X181.715 Y161.55
G1 X181.582 Y161.684
G1 X180.183 Y163.083 E.05892
G1 X180.049 Y163.216
G1 X179.516 Y163.216
G1 X179.65 Y163.083
G1 X181.582 Y161.151 E.08138
G1 X181.715 Y161.017
G1 X181.715 Y160.484
G1 X181.582 Y160.617
G1 X179.116 Y163.083 E.10385
G1 X178.983 Y163.216
G1 X178.449 Y163.216
G1 X178.583 Y163.083
G1 X181.582 Y160.084 E.12631
G1 X181.715 Y159.95
G1 X181.715 Y159.417
G1 X181.582 Y159.551
G1 X179.911 Y161.221 E.07035
G1 X179.778 Y161.355
G1 X180.208 Y160.392
G1 X180.341 Y160.258
G1 X181.582 Y159.018 E.05225
G1 X181.715 Y158.884
G1 X181.715 Y158.351
G1 X181.582 Y158.484
G1 X180.367 Y159.699 E.05118
G1 X180.233 Y159.833
G1 X180.232 Y159.301
G1 X180.366 Y159.167
G1 X181.582 Y157.951 E.05122
G1 X181.715 Y157.817
G1 X181.715 Y157.284
G1 X181.582 Y157.418
G1 X180.331 Y158.668 E.05267
G1 X180.198 Y158.802
G1 X180.065 Y158.402
G1 X180.198 Y158.268
G1 X181.582 Y156.885 E.05827
G1 X181.715 Y156.751
G1 X181.715 Y156.218
G1 X181.582 Y156.351
G1 X180.012 Y157.921 E.06612
G1 X179.878 Y158.055
G1 X179.641 Y157.759
G1 X179.775 Y157.625
G1 X181.411 Y155.989 E.06893
G1 X181.545 Y155.855
G1 X181.079 Y155.787
G1 X180.946 Y155.921
G1 X179.483 Y157.384 E.06162
G1 X179.349 Y157.517
G1 X179 Y157.333
G1 X179.134 Y157.199
G1 X180.412 Y155.921 E.05386
G1 X180.546 Y155.787
G1 X180.013 Y155.787
G1 X179.879 Y155.92
G1 X178.731 Y157.068 E.04835
G1 X178.598 Y157.202
G1 X178.1 Y157.167
G1 X178.234 Y157.033
G1 X179.346 Y155.92 E.04687
G1 X179.48 Y155.787
G1 X178.947 Y155.787
G1 X178.813 Y155.92
G1 X177.7 Y157.034 E.0469
G1 X177.566 Y157.167
G1 X177.032 Y157.168
G1 X177.166 Y157.034
G1 X178.28 Y155.92 E.04693
G1 X178.414 Y155.786
G1 X177.881 Y155.786
G1 X177.747 Y155.92
G1 X176.632 Y157.035 E.04695
G1 X176.499 Y157.168
G1 X175.965 Y157.169
G1 X176.099 Y157.035
G1 X177.214 Y155.92 E.04698
G1 X177.347 Y155.786
G1 X176.814 Y155.786
G1 X176.681 Y155.92
G1 X175.565 Y157.035 E.04701
G1 X175.431 Y157.169
G1 X174.897 Y157.17
G1 X175.031 Y157.036
G1 X176.148 Y155.919 E.04703
G1 X176.281 Y155.786
G1 X175.748 Y155.786
G1 X175.614 Y155.919
G1 X174.497 Y157.036 E.04706
G1 X174.364 Y157.17
G1 X173.83 Y157.171
G1 X173.964 Y157.037
G1 X175.081 Y155.919 E.04709
G1 X175.215 Y155.786
G1 X174.682 Y155.785
G1 X174.548 Y155.919
G1 X173.43 Y157.037 E.04712
G1 X173.296 Y157.171
G1 X172.762 Y157.172
G1 X172.896 Y157.038
G1 X174.015 Y155.919 E.04714
G1 X174.149 Y155.785
G1 X173.616 Y155.785
G1 X173.482 Y155.919
G1 X172.362 Y157.038 E.04717
G1 X172.229 Y157.172
G1 X171.695 Y157.173
G1 X171.828 Y157.039
G1 X172.949 Y155.919 E.0472
G1 X173.083 Y155.785
G1 X172.549 Y155.785
G1 X172.416 Y155.918
G1 X171.257 Y157.078 E.04883
; WIPE_START
G1 F9547.055
M204 S8000
G1 X172.416 Y155.918 E-.62298
G1 X172.549 Y155.785 E-.07182
G1 X172.721 Y155.785 E-.0652
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X177.222 Y161.949 Z4.8 F60000
G1 X178.05 Y163.083 Z4.8
G1 Z4.4
G1 E.8 F1800
G1 F1299
M204 S2000
G1 X179.592 Y161.541 E.06495
G1 X179.725 Y161.407
G1 X178.793 Y161.806
G1 X178.66 Y161.94
G1 X177.517 Y163.083 E.04815
G1 X177.383 Y163.216
G1 X176.85 Y163.216
G1 X176.983 Y163.083
G1 X178.107 Y161.958 E.04735
G1 X178.241 Y161.825
G1 X177.707 Y161.825
G1 X177.573 Y161.959
G1 X176.45 Y163.083 E.04732
G1 X176.316 Y163.216
G1 X175.783 Y163.216
G1 X175.917 Y163.083
G1 X177.04 Y161.96 E.04729
G1 X177.173 Y161.826
G1 X176.639 Y161.827
G1 X176.506 Y161.961
G1 X175.384 Y163.083 E.04726
G1 X175.25 Y163.216
G1 X174.717 Y163.216
G1 X174.85 Y163.083
G1 X175.972 Y161.961 E.04723
G1 X176.105 Y161.828
G1 X175.571 Y161.828
G1 X175.438 Y161.962
G1 X174.317 Y163.083 E.0472
G1 X174.183 Y163.216
G1 X173.65 Y163.216
G1 X173.784 Y163.083
G1 X174.904 Y161.963 E.04717
G1 X175.037 Y161.829
G1 X174.503 Y161.83
G1 X174.37 Y161.963
G1 X173.251 Y163.083 E.04714
G1 X173.117 Y163.216
G1 X172.584 Y163.216
G1 X172.717 Y163.083
M73 P97 R0
G1 X173.836 Y161.964 E.04711
G1 X173.969 Y161.831
G1 X173.435 Y161.831
G1 X173.302 Y161.965
G1 X172.184 Y163.083 E.04708
G1 X172.05 Y163.216
G1 X171.517 Y163.216
G1 X171.651 Y163.083
G1 X172.768 Y161.966 E.04705
G1 X172.901 Y161.832
G1 X172.367 Y161.833
G1 X172.234 Y161.966
G1 X171.118 Y163.083 E.04702
G1 X170.984 Y163.216
G1 X170.451 Y163.216
G1 X170.584 Y163.083
G1 X171.7 Y161.967 E.04699
G1 X171.833 Y161.833
G1 X171.35 Y161.784
G1 X171.216 Y161.918
G1 X170.051 Y163.083 E.04907
G1 X169.917 Y163.216
G1 X169.384 Y163.216
G1 X169.518 Y163.083
G1 X170.821 Y161.779 E.05489
G1 X170.954 Y161.646
G1 X170.615 Y161.452
G1 X170.482 Y161.585
G1 X168.985 Y163.082 E.06307
G1 X168.851 Y163.216
G1 X168.416 Y163.118
G1 X168.55 Y162.984
G1 X170.195 Y161.339 E.06929
G1 X170.328 Y161.205
G1 X170.091 Y160.91
G1 X169.957 Y161.043
G1 X168.418 Y162.583 E.06487
G1 X168.284 Y162.717
G1 X168.284 Y162.183
M73 P98 R0
G1 X168.418 Y162.05
G1 X169.775 Y160.693 E.05716
G1 X169.908 Y160.559
G1 X169.798 Y160.136
G1 X169.664 Y160.27
G1 X168.418 Y161.516 E.05252
G1 X168.284 Y161.65
G1 X168.284 Y161.117
G1 X168.418 Y160.983
G1 X169.635 Y159.765 E.0513
G1 X169.769 Y159.632
G1 X169.77 Y159.097
G1 X169.637 Y159.231
G1 X168.418 Y160.45 E.05135
G1 X168.284 Y160.583
G1 X168.284 Y160.05
G1 X168.418 Y159.917
G1 X169.674 Y158.66 E.05293
; WIPE_START
G1 F9547.055
M204 S8000
G1 X168.418 Y159.917 E-.6753
G1 X168.284 Y160.05 E-.07182
G1 X168.284 Y160.084 E-.01289
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X168.418 Y159.383 Z4.8 F60000
G1 Z4.4
G1 E.8 F1800
G1 F1299
M204 S2000
G1 X171.883 Y155.918 E.14596
G1 X172.016 Y155.785
G1 X171.483 Y155.784
G1 X171.35 Y155.918
G1 X168.418 Y158.85 E.1235
G1 X168.284 Y158.984
G1 X168.284 Y158.45
G1 X168.418 Y158.317
G1 X170.816 Y155.918 E.10105
G1 X170.95 Y155.784
G1 X170.417 Y155.784
G1 X170.283 Y155.918
G1 X168.418 Y157.783 E.07859
G1 X168.284 Y157.917
G1 X168.284 Y157.384
G1 X168.418 Y157.25
G1 X169.75 Y155.918 E.05613
G1 X169.884 Y155.784
G1 X169.351 Y155.784
G1 X169.217 Y155.917
G1 X168.418 Y156.717 E.03367
M204 S10000
G1 X168.886 Y155.899 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.258096
G1 F1299
M204 S8000
G2 X168.399 Y156.38 I.531 J1.025 E.01182
; WIPE_START
G1 F15000
G1 X168.606 Y156.097 E-.38394
G1 X168.886 Y155.899 E-.37606
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.191 Y157.012 Z4.8 F60000
G1 Z4.4
G1 E.8 F1800
; LINE_WIDTH: 0.183504
G1 F1299
M204 S8000
G2 X170.907 Y157.171 I1.662 J3.287 E.00361
; WIPE_START
G1 F15000
G1 X171.191 Y157.012 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X169.622 Y158.446 Z4.8 F60000
G1 Z4.4
G1 E.8 F1800
; LINE_WIDTH: 0.133372
G1 F1299
M204 S8000
G1 X169.685 Y158.67 E.00167
; WIPE_START
G1 F15000
G1 X169.622 Y158.446 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X176.837 Y160.935 Z4.8 F60000
G1 X181.6 Y162.579 Z4.8
G1 Z4.4
G1 E.8 F1800
; LINE_WIDTH: 0.313176
G1 F1299
M204 S8000
G3 X181.132 Y163.101 I-1.365 J-.751 E.01512
; close powerlost recovery
M1003 S0
; WIPE_START
G1 F13320.705
G1 X181.384 Y162.881 E-.35994
G1 X181.6 Y162.579 E-.40006
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z4.8 I1.217 J0 P1  F60000
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
G1 Z4.8 F900 ; lower z a little
M1002 judge_flag timelapse_record_flag
M622 J1
    G150.3
    M400 ; wait all motion done
    M991 S0 P-1 ;end smooth timelapse at safe pos
    M400 S5 ;wait for last picture to be taken
M623  ;end of "timelapse_record_flag"

G90
G1 Z14.4 F900 ; lower z a little

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

    
        G1 Z102.2 F600
        G1 Z100.2
    

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

