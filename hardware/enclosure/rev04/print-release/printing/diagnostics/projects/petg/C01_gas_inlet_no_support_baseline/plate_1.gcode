; HEADER_BLOCK_START
; BambuStudio 02.08.02.61
; model printing time: 22m 38s; total estimated time: 28m 5s
; total layer number: 165
; total filament length [mm] : 815.19
; total filament volume [cm^3] : 1960.76
; total filament weight [g] : 2.49
; filament_density: 1.27
; filament_diameter: 1.75
; max_z_height: 33.00
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
M73 P0 R28
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
M73 P1 R27
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
M73 P2 R27
G1 Z5 F1200
G90
G1 X175 Y160 F30000

M622 J1
    M1002 gcode_claim_action : 1
    G29.20 A3
    G29 A1 O X160.193 Y152.193 I25.8066 J17.1131 R
    M400
M623

M622 J2
    M1002 gcode_claim_action : 1
    
        G29.20 A4
        G29 A2 O X160.193 Y152.193 I25.8066 J17.1131 R
    
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
M73 P18 R22
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
; layer num/total_layer_count: 1/165
; update layer progress
M73 L1
M991 S0 P0 ;notify layer change

M106 S0
M106 P2 S0
; OBJECT_ID: 15
G1 X161.372 Y153.574 F60000
M204 S6000
M73 P19 R22
G1 Z.4
G1 Z.2
G1 E.8 F1800
; FEATURE: Brim
; LINE_WIDTH: 0.5
G1 F3000
M204 S500
G1 X161.788 Y153.19 E.02045
G1 X162.263 Y152.878 E.02053
G1 X162.644 Y152.7 E.01517
G1 X163.288 Y152.498 E.02439
G1 X164.012 Y152.422 E.02627
G1 X176.491 Y152.422 E.45056
G1 X177.06 Y152.469 E.02062
G1 X177.971 Y152.752 E.03446
G1 X178.478 Y153.025 E.02079
G1 X178.926 Y153.372 E.02045
G1 X179.31 Y153.788 E.02045
G1 X179.622 Y154.262 E.02048
G1 X179.839 Y154.743 E.01907
G1 X180.002 Y155.287 E.0205
G1 X180.078 Y156.012 E.02632
G1 X180.078 Y165.491 E.34223
G1 X180.031 Y166.06 E.02062
G1 X179.789 Y166.875 E.03072
G1 X179.474 Y167.48 E.0246
G1 X179.128 Y167.926 E.02039
G1 X178.712 Y168.31 E.02045
G1 X178.237 Y168.622 E.02053
G1 X177.856 Y168.8 E.01517
G1 X177.212 Y169.002 E.02439
G1 X176.488 Y169.078 E.02627
G1 X164.009 Y169.078 E.45055
G1 X163.44 Y169.031 E.02062
G1 X162.625 Y168.789 E.03072
G1 X162.02 Y168.474 E.0246
G1 X161.574 Y168.128 E.02039
G1 X161.19 Y167.712 E.02045
G1 X160.878 Y167.237 E.02053
G1 X160.7 Y166.856 E.01517
G1 X160.498 Y166.212 E.02439
G1 X160.422 Y165.488 E.02627
G1 X160.422 Y156.009 E.34224
G1 X160.469 Y155.44 E.02062
G1 X160.713 Y154.617 E.031
G1 X161.025 Y154.022 E.02426
G1 X161.335 Y153.621 E.01828
M204 S6000
G1 X161.698 Y153.902 F60000
G1 F3000
M204 S500
G1 X161.718 Y153.876 E.0012
G1 X162.079 Y153.545 E.0177
G1 X162.478 Y153.283 E.0172
G1 X162.801 Y153.131 E.01291
G1 X163.395 Y152.946 E.02246
G1 X164.029 Y152.88 E.023
G1 X176.477 Y152.88 E.44947
G1 X176.986 Y152.925 E.01845
G1 X177.781 Y153.171 E.03004
G1 X178.218 Y153.404 E.01788
G1 X178.607 Y153.703 E.01771
G1 X178.941 Y154.062 E.0177
G1 X179.214 Y154.474 E.01784
G1 X179.412 Y154.912 E.01739
G1 X179.553 Y155.39 E.01798
G1 X179.621 Y156.043 E.0237
G1 X179.62 Y165.477 E.34063
G1 X179.575 Y165.989 E.01853
G1 X179.367 Y166.691 E.02644
G1 X179.094 Y167.221 E.02155
G1 X178.782 Y167.624 E.01838
G1 X178.421 Y167.955 E.0177
G1 X178.022 Y168.217 E.0172
G1 X177.699 Y168.369 E.01291
G1 X177.105 Y168.554 E.02246
G1 X176.457 Y168.621 E.02351
G1 X164.023 Y168.62 E.44895
G1 X163.511 Y168.575 E.01853
G1 X162.809 Y168.367 E.02644
G1 X162.279 Y168.094 E.02155
G1 X161.876 Y167.782 E.01838
G1 X161.545 Y167.421 E.0177
G1 X161.283 Y167.022 E.0172
G1 X161.131 Y166.699 E.01291
G1 X160.946 Y166.105 E.02246
G1 X160.879 Y165.457 E.02351
G1 X160.88 Y156.023 E.34064
G1 X160.925 Y155.511 E.01853
G1 X161.135 Y154.802 E.02671
G1 X161.405 Y154.28 E.02122
G1 X161.661 Y153.95 E.01509
M204 S6000
G1 X162.024 Y154.231 F60000
G1 F3000
M204 S500
G1 X162.064 Y154.179 E.00236
G1 X162.37 Y153.901 E.01493
G1 X162.694 Y153.689 E.01396
G1 X162.959 Y153.562 E.01061
G1 X163.475 Y153.4 E.01953
G1 X164.045 Y153.338 E.02072
G1 X176.463 Y153.337 E.44835
G1 X176.911 Y153.38 E.01626
G1 X177.592 Y153.591 E.02574
G1 X177.96 Y153.784 E.01499
G1 X178.289 Y154.035 E.01496
G1 X178.573 Y154.337 E.01496
G1 X178.806 Y154.686 E.01516
G1 X178.986 Y155.081 E.01565
G1 X179.104 Y155.492 E.01543
G1 X179.164 Y156.074 E.02113
G1 X179.163 Y165.463 E.33901
G1 X179.12 Y165.916 E.01641
G1 X178.945 Y166.507 E.02227
G1 X178.712 Y166.963 E.01849
G1 X178.436 Y167.321 E.01633
G1 X178.13 Y167.599 E.01493
G1 X177.806 Y167.811 E.01396
G1 X177.541 Y167.938 E.01061
G1 X176.999 Y168.105 E.02049
G1 X176.426 Y168.164 E.02078
G1 X164.037 Y168.163 E.44733
G1 X163.584 Y168.12 E.01641
G1 X162.993 Y167.945 E.02227
G1 X162.537 Y167.712 E.01849
G1 X162.179 Y167.436 E.01633
G1 X161.901 Y167.13 E.01493
G1 X161.689 Y166.806 E.01396
G1 X161.562 Y166.541 E.01061
G1 X161.395 Y165.999 E.02049
G1 X161.336 Y165.426 E.02078
G1 X161.337 Y156.037 E.33902
G1 X161.38 Y155.584 E.01641
G1 X161.557 Y154.986 E.02252
G1 X161.786 Y154.538 E.01816
G1 X161.988 Y154.278 E.01188
M204 S6000
G1 X162.351 Y154.559 F60000
G1 F3000
M204 S500
G1 X162.41 Y154.482 E.0035
G1 X162.66 Y154.257 E.01214
G1 X162.91 Y154.093 E.01081
G1 X163.118 Y153.993 E.00831
G1 X163.582 Y153.848 E.01757
G1 X164.078 Y153.795 E.01799
G1 X176.448 Y153.795 E.44663
G1 X176.834 Y153.835 E.01403
G1 X177.405 Y154.012 E.02157
G1 X177.703 Y154.166 E.01212
G1 X177.973 Y154.369 E.0122
G1 X178.206 Y154.614 E.01222
G1 X178.399 Y154.9 E.01245
G1 X178.552 Y155.231 E.01315
G1 X178.655 Y155.591 E.01354
G1 X178.707 Y156.104 E.01861
G1 X178.705 Y165.448 E.33737
G1 X178.665 Y165.841 E.01427
G1 X178.522 Y166.325 E.01822
G1 X178.33 Y166.706 E.01541
G1 X178.09 Y167.018 E.01422
G1 X177.84 Y167.243 E.01214
G1 X177.589 Y167.407 E.01081
G1 X177.384 Y167.507 E.00826
G1 X176.894 Y167.657 E.0185
G1 X176.396 Y167.707 E.01806
G1 X164.065 Y167.706 E.44522
G1 X163.659 Y167.665 E.01474
G1 X163.175 Y167.522 E.01822
G1 X162.794 Y167.33 E.01541
G1 X162.482 Y167.09 E.01422
G1 X162.257 Y166.84 E.01214
G1 X162.093 Y166.589 E.01081
G1 X161.993 Y166.384 E.00826
G1 X161.843 Y165.894 E.0185
G1 X161.793 Y165.396 E.01806
G1 X161.795 Y156.052 E.33738
G1 X161.835 Y155.659 E.01427
G1 X161.98 Y155.169 E.01845
G1 X162.168 Y154.796 E.01509
G1 X162.314 Y154.606 E.00865
M204 S6000
G1 X162.666 Y154.912 F60000
G1 F3000
M204 S500
G1 X162.821 Y154.734 E.00855
G1 X162.92 Y154.65 E.0047
G1 X163.302 Y154.417 E.01613
G1 X163.528 Y154.337 E.00865
G1 X164.035 Y154.25 E.01858
G1 X176.47 Y154.25 E.449
G1 X176.862 Y154.305 E.01428
G1 X177.169 Y154.404 E.01164
G1 X177.346 Y154.495 E.00718
G1 X177.63 Y154.693 E.01251
G1 X177.729 Y154.782 E.00479
G1 X177.94 Y155.042 E.0121
G1 X178.081 Y155.296 E.01051
G1 X178.163 Y155.528 E.00886
G1 X178.25 Y156.035 E.01858
G1 X178.25 Y165.472 E.34073
G1 X178.215 Y165.772 E.01093
G1 X178.128 Y166.084 E.01167
G1 X177.906 Y166.502 E.01708
G1 X177.79 Y166.656 E.00697
G1 X177.54 Y166.881 E.01217
G1 X177.202 Y167.082 E.01417
G1 X176.972 Y167.163 E.00879
G1 X176.465 Y167.25 E.01858
G1 X164.028 Y167.25 E.44905
G1 X163.728 Y167.215 E.01093
G1 X163.416 Y167.128 E.01167
G1 X162.998 Y166.906 E.01708
G1 X162.844 Y166.79 E.00696
G1 X162.619 Y166.54 E.01217
G1 X162.418 Y166.202 E.01418
G1 X162.337 Y165.972 E.00879
G1 X162.25 Y165.465 E.01859
G1 X162.269 Y155.832 E.3478
G1 X162.338 Y155.519 E.01159
G1 X162.44 Y155.258 E.0101
G1 X162.599 Y154.988 E.01131
G1 X162.626 Y154.957 E.00149
M204 S6000
G1 X162.99 Y155.225 F60000
G1 F3000
M204 S500
G1 X163.162 Y155.038 E.00919
G1 X163.461 Y154.845 E.01284
G1 X163.605 Y154.788 E.00561
G1 X164.023 Y154.707 E.01536
G1 X176.48 Y154.707 E.44976
G1 X176.721 Y154.739 E.00878
G1 X176.968 Y154.814 E.00932
G1 X177.078 Y154.866 E.00439
G1 X177.377 Y155.073 E.01314
G1 X177.541 Y155.265 E.0091
G1 X177.654 Y155.458 E.00808
G1 X177.712 Y155.605 E.00572
G1 X177.793 Y156.023 E.01536
G1 X177.793 Y165.48 E.34144
G1 X177.761 Y165.721 E.00878
G1 X177.688 Y165.963 E.00913
G1 X177.506 Y166.281 E.01322
G1 X177.431 Y166.374 E.00431
G1 X177.235 Y166.541 E.0093
G1 X177.042 Y166.654 E.00807
G1 X176.895 Y166.712 E.00572
G1 X176.477 Y166.793 E.01536
G1 X164.02 Y166.793 E.44976
G1 X163.779 Y166.761 E.00878
G1 X163.537 Y166.688 E.00913
G1 X163.219 Y166.506 E.01322
G1 X163.126 Y166.431 E.00431
G1 X162.959 Y166.235 E.0093
G1 X162.846 Y166.042 E.00808
G1 X162.788 Y165.895 E.00572
G1 X162.707 Y165.477 E.01536
G1 X162.715 Y155.929 E.34473
G1 X162.76 Y155.696 E.00857
G1 X162.87 Y155.415 E.01088
G1 X162.958 Y155.276 E.00597
M204 S6000
G1 X163.345 Y155.519 F60000
G1 F3000
M204 S500
G1 X163.383 Y155.458 E.00261
G1 X163.485 Y155.36 E.00513
G1 X163.698 Y155.235 E.0089
G1 X164.01 Y155.164 E.01155
G1 X176.489 Y155.164 E.45056
G1 X176.655 Y155.191 E.00607
G1 X176.83 Y155.25 E.00666
G1 X177.042 Y155.383 E.00905
G1 X177.14 Y155.485 E.00513
G1 X177.265 Y155.698 E.0089
G1 X177.336 Y156.01 E.01155
G1 X177.336 Y165.489 E.34224
G1 X177.309 Y165.655 E.00607
G1 X177.25 Y165.83 E.00666
G1 X177.117 Y166.042 E.00905
G1 X177.015 Y166.14 E.00513
G1 X176.802 Y166.265 E.0089
G1 X176.49 Y166.336 E.01155
G1 X164.011 Y166.336 E.45056
G1 X163.845 Y166.309 E.00607
G1 X163.67 Y166.25 E.00666
G1 X163.458 Y166.117 E.00905
G1 X163.36 Y166.015 E.00513
G1 X163.235 Y165.802 E.0089
G1 X163.164 Y165.49 E.01155
G1 X163.164 Y156.011 E.34224
G1 X163.191 Y155.845 E.00607
G1 X163.25 Y155.67 E.00666
G1 X163.313 Y155.57 E.00427
M204 S6000
G1 X163.688 Y155.799 F60000
G1 F3000
M204 S500
G1 X163.814 Y155.677 E.00631
G1 X164 Y155.621 E.007
G1 X176.5 Y155.621 E.45133
G1 X176.701 Y155.688 E.00766
G1 X176.823 Y155.814 E.00631
G1 X176.879 Y156 E.007
G1 X176.879 Y165.5 E.34301
G1 X176.812 Y165.701 E.00766
G1 X176.686 Y165.823 E.00631
G1 X176.5 Y165.879 E.007
G1 X164 Y165.879 E.45133
G1 X163.799 Y165.812 E.00766
G1 X163.677 Y165.686 E.00631
G1 X163.621 Y165.5 E.007
G1 X163.621 Y156 E.34301
G1 X163.669 Y155.856 E.00549
; WIPE_START
M73 P20 R22
G1 X163.814 Y155.677 E-.08729
G1 X164 Y155.621 E-.07367
G1 X165.576 Y155.621 E-.59903
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X171.248 Y160.729 Z.6 F60000
G1 X176.1 Y165.1 Z.6
G1 Z.2
G1 E.8 F1800
; FEATURE: Outer wall
G1 F3000
M204 S500
G1 X164.4 Y165.1 E.42244
G1 X164.4 Y156.4 E.31412
G1 X176.1 Y156.4 E.42244
G1 X176.1 Y165.04 E.31196
;======== H2D 20260731========
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
G1 X175.643 Y164.643 F60000
; FEATURE: Inner wall
G1 F3000
M204 S500
G1 X164.857 Y164.643 E.38944
G1 X164.857 Y156.857 E.28112
G1 X175.643 Y156.857 E.38944
G1 X175.643 Y164.583 E.27895
M204 S6000
G1 X175.186 Y164.186 F60000
G1 F3000
M204 S500
G1 X165.314 Y164.186 E.35643
G1 X165.314 Y157.314 E.24811
G1 X175.186 Y157.314 E.35643
G1 X175.186 Y164.126 E.24594
M204 S6000
G1 X174.729 Y163.729 F60000
G1 F3000
M204 S500
G1 X165.771 Y163.729 E.32342
G1 X165.771 Y157.771 E.21511
G1 X174.729 Y157.771 E.32342
G1 X174.729 Y163.669 E.21294
; WIPE_START
G1 X172.729 Y163.682 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X173.618 Y157.954 Z.6 F60000
G1 Z.2
G1 E.8 F1800
; FEATURE: Bottom surface
; LINE_WIDTH: 0.50174
G1 F6300
M204 S500
G1 X174.34 Y158.676 E.03701
G1 X174.34 Y159.325 E.02352
G1 X173.175 Y158.16 E.05972
G1 X172.526 Y158.16 E.02352
G1 X174.34 Y159.974 E.09298
G1 X174.34 Y160.623 E.02352
G1 X171.877 Y158.16 E.12624
G1 X171.228 Y158.16 E.02352
G1 X174.34 Y161.271 E.1595
G1 X174.34 Y161.92 E.02352
G1 X170.58 Y158.16 E.19276
G1 X169.931 Y158.16 E.02352
G1 X174.34 Y162.569 E.22601
G1 X174.34 Y163.218 E.02352
G1 X169.282 Y158.16 E.25927
G1 X168.633 Y158.16 E.02352
G1 X173.814 Y163.34 E.26554
G1 X173.165 Y163.34 E.02352
G1 X167.984 Y158.16 E.26554
G1 X167.335 Y158.16 E.02352
G1 X172.516 Y163.34 E.26554
G1 X171.867 Y163.34 E.02352
G1 X166.686 Y158.16 E.26554
G1 X166.16 Y158.16 E.01909
G1 X166.16 Y158.282 E.00443
G1 X171.218 Y163.34 E.25927
G1 X170.569 Y163.34 E.02352
G1 X166.16 Y158.931 E.22602
G1 X166.16 Y159.58 E.02352
G1 X169.92 Y163.34 E.19276
G1 X169.272 Y163.34 E.02352
G1 X166.16 Y160.228 E.1595
G1 X166.16 Y160.877 E.02352
G1 X168.623 Y163.34 E.12624
G1 X167.974 Y163.34 E.02352
G1 X166.16 Y161.526 E.09298
G1 X166.16 Y162.175 E.02352
G1 X167.325 Y163.34 E.05972
G1 X166.676 Y163.34 E.02352
G1 X165.954 Y162.618 E.03701
; CHANGE_LAYER
; Z_HEIGHT: 0.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F6300
G1 X166.676 Y163.34 E-.388
G1 X167.325 Y163.34 E-.24657
G1 X167.092 Y163.107 E-.12543
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 2/165
; update layer progress
M73 L2
M991 S0 P1 ;notify layer change

; open powerlost recovery
M1003 S1
; OBJECT_ID: 15
M204 S10000
G17
G3 Z.6 I-.148 J1.208 P1  F60000
G1 X175.084 Y164.084 Z.6
G1 Z.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1549
M204 S8000
G1 X165.416 Y164.084 E.31087
G1 X165.416 Y157.416 E.21441
G1 X175.084 Y157.416 E.31087
G1 X175.084 Y164.024 E.21248
M204 S10000
G1 X175.491 Y164.491 F60000
G1 F1549
M204 S8000
G1 X165.009 Y164.491 E.33705
G1 X165.009 Y157.009 E.24059
G1 X175.491 Y157.009 E.33705
G1 X175.491 Y164.431 E.23866
M204 S10000
G1 X175.898 Y164.898 F60000
G1 F1549
M204 S8000
G1 X164.602 Y164.898 E.36323
G1 X164.602 Y156.602 E.26677
G1 X175.898 Y156.602 E.36323
G1 X175.898 Y164.838 E.26484
M204 S250
G1 X176.29 Y165.29 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1549
M204 S5000
G1 X164.21 Y165.29 E.35982
G1 X164.21 Y156.21 E.27046
G1 X176.29 Y156.21 E.35982
G1 X176.29 Y165.23 E.26868
;======== H2D 20260731========
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
G1 X174.29 Y165.24 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X174.143 Y163.92 Z.8 F60000
G1 Z.4
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.4271
G1 F1549
M204 S8000
G1 X174.751 Y163.313 E.02608
G1 X174.751 Y162.769 E.01649
G1 X173.769 Y163.751 E.04212
G1 X173.226 Y163.751 E.01649
G1 X174.751 Y162.226 E.06543
G1 X174.751 Y161.683 E.01649
G1 X172.683 Y163.751 E.08875
G1 X172.139 Y163.751 E.01649
G1 X174.751 Y161.139 E.11207
G1 X174.751 Y160.596 E.01649
G1 X171.596 Y163.751 E.13539
G1 X171.053 Y163.751 E.01649
G1 X174.751 Y160.053 E.1587
G1 X174.751 Y159.509 E.01649
G1 X170.509 Y163.751 E.18202
G1 X169.966 Y163.751 E.01649
G1 X174.751 Y158.966 E.20534
G1 X174.751 Y158.423 E.01649
G1 X169.423 Y163.751 E.22866
G1 X168.879 Y163.751 E.01649
G1 X174.751 Y157.879 E.25197
G1 X174.751 Y157.749 E.00394
G1 X174.337 Y157.749 E.01254
G1 X168.336 Y163.751 E.25755
M73 P21 R22
G1 X167.793 Y163.751 E.01649
G1 X173.794 Y157.749 E.25755
G1 X173.251 Y157.749 E.01649
G1 X167.249 Y163.751 E.25755
G1 X166.706 Y163.751 E.01649
G1 X172.707 Y157.749 E.25755
G1 X172.164 Y157.749 E.01649
G1 X166.163 Y163.751 E.25755
G1 X165.749 Y163.751 E.01255
G1 X165.749 Y163.621 E.00394
G1 X171.621 Y157.749 E.25198
G1 X171.077 Y157.749 E.01649
G1 X165.749 Y163.077 E.22866
G1 X165.749 Y162.534 E.01649
G1 X170.534 Y157.749 E.20534
G1 X169.991 Y157.749 E.01649
G1 X165.749 Y161.991 E.18202
G1 X165.749 Y161.447 E.01649
G1 X169.447 Y157.749 E.15871
G1 X168.904 Y157.749 E.01649
G1 X165.749 Y160.904 E.13539
G1 X165.749 Y160.361 E.01649
G1 X168.361 Y157.749 E.11207
G1 X167.817 Y157.749 E.01649
G1 X165.749 Y159.817 E.08875
G1 X165.749 Y159.274 E.01649
G1 X167.274 Y157.749 E.06544
G1 X166.731 Y157.749 E.01649
G1 X165.749 Y158.731 E.04212
G1 X165.749 Y158.188 E.01649
G1 X166.357 Y157.58 E.02608
; CHANGE_LAYER
; Z_HEIGHT: 0.6
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9370.607
G1 X165.749 Y158.188 E-.32659
G1 X165.749 Y158.731 E-.20646
G1 X166.172 Y158.309 E-.22694
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 3/165
; update layer progress
M73 L3
M991 S0 P2 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z.8 I-.662 J1.021 P1  F60000
G1 X175.084 Y164.084 Z.8
G1 Z.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1550
M204 S8000
G1 X165.416 Y164.084 E.31087
G1 X165.416 Y157.416 E.21441
G1 X175.084 Y157.416 E.31087
G1 X175.084 Y164.024 E.21248
; COOLING_NODE: 0
M204 S10000
G1 X175.491 Y164.491 F60000
G1 F1550
M204 S8000
G1 X165.009 Y164.491 E.33705
G1 X165.009 Y157.009 E.24059
G1 X175.491 Y157.009 E.33705
G1 X175.491 Y164.431 E.23866
; COOLING_NODE: 0
M204 S10000
G1 X175.898 Y164.898 F60000
G1 F1550
M204 S8000
G1 X164.602 Y164.898 E.36323
G1 X164.602 Y156.602 E.26677
G1 X175.898 Y156.602 E.36323
G1 X175.898 Y164.838 E.26484
; COOLING_NODE: 0
M204 S250
G1 X176.29 Y165.29 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1549
M204 S5000
G1 X164.21 Y165.29 E.35982
G1 X164.21 Y156.21 E.27046
G1 X176.29 Y156.21 E.35982
G1 X176.29 Y165.23 E.26868
;======== H2D 20260731========
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
G1 X174.29 Y165.24 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X174.92 Y158.357 Z1 F60000
G1 Z.6
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.4271
G1 F1550
M204 S8000
G1 X174.313 Y157.749 E.02608
G1 X173.769 Y157.749 E.01649
G1 X174.751 Y158.731 E.04211
G1 X174.751 Y159.274 E.01649
G1 X173.226 Y157.749 E.06543
G1 X172.683 Y157.749 E.01649
G1 X174.751 Y159.817 E.08875
G1 X174.751 Y160.361 E.01649
G1 X172.139 Y157.749 E.11207
G1 X171.596 Y157.749 E.01649
G1 X174.751 Y160.904 E.13539
G1 X174.751 Y161.447 E.01649
G1 X171.053 Y157.749 E.1587
G1 X170.509 Y157.749 E.01649
G1 X174.751 Y161.991 E.18202
G1 X174.751 Y162.534 E.01649
G1 X169.966 Y157.749 E.20534
G1 X169.423 Y157.749 E.01649
G1 X174.751 Y163.077 E.22866
G1 X174.751 Y163.621 E.01649
G1 X168.879 Y157.749 E.25197
G1 X168.336 Y157.749 E.01649
M73 P21 R21
G1 X174.337 Y163.751 E.25755
G1 X173.794 Y163.751 E.01649
G1 X167.793 Y157.749 E.25755
G1 X167.249 Y157.749 E.01649
G1 X173.251 Y163.751 E.25755
G1 X172.707 Y163.751 E.01649
G1 X166.706 Y157.749 E.25755
G1 X166.163 Y157.749 E.01649
G1 X172.164 Y163.751 E.25755
G1 X171.621 Y163.751 E.01649
G1 X165.749 Y157.879 E.25198
G1 X165.749 Y158.423 E.01649
G1 X171.077 Y163.751 E.22866
G1 X170.534 Y163.751 E.01649
G1 X165.749 Y158.966 E.20534
G1 X165.749 Y159.509 E.01649
G1 X169.991 Y163.751 E.18202
G1 X169.447 Y163.751 E.01649
G1 X165.749 Y160.053 E.15871
G1 X165.749 Y160.596 E.01649
G1 X168.904 Y163.751 E.13539
G1 X168.361 Y163.751 E.01649
G1 X165.749 Y161.139 E.11207
G1 X165.749 Y161.683 E.01649
G1 X167.817 Y163.751 E.08875
G1 X167.274 Y163.751 E.01649
G1 X165.749 Y162.226 E.06544
G1 X165.749 Y162.769 E.01649
G1 X166.731 Y163.751 E.04212
G1 X166.188 Y163.751 E.01649
G1 X165.58 Y163.143 E.02608
; CHANGE_LAYER
; Z_HEIGHT: 0.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9370.607
G1 X166.188 Y163.751 E-.32659
G1 X166.731 Y163.751 E-.20646
G1 X166.309 Y163.328 E-.22695
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 4/165
; update layer progress
M73 L4
M991 S0 P3 ;notify layer change

M106 S226.95
; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z1 I-.104 J1.212 P1  F60000
G1 X175.084 Y164.084 Z1
G1 Z.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1549
M204 S8000
G1 X165.416 Y164.084 E.31087
G1 X165.416 Y157.416 E.21441
G1 X175.084 Y157.416 E.31087
G1 X175.084 Y164.024 E.21248
; COOLING_NODE: 0
M204 S10000
M73 P22 R21
G1 X175.491 Y164.491 F60000
G1 F1549
M204 S8000
G1 X165.009 Y164.491 E.33705
G1 X165.009 Y157.009 E.24059
G1 X175.491 Y157.009 E.33705
G1 X175.491 Y164.431 E.23866
; COOLING_NODE: 0
M204 S10000
G1 X175.898 Y164.898 F60000
G1 F1549
M204 S8000
G1 X164.602 Y164.898 E.36323
G1 X164.602 Y156.602 E.26677
G1 X175.898 Y156.602 E.36323
G1 X175.898 Y164.838 E.26484
; COOLING_NODE: 0
M204 S250
G1 X176.29 Y165.29 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1549
M204 S5000
G1 X164.21 Y165.29 E.35982
G1 X164.21 Y156.21 E.27046
G1 X176.29 Y156.21 E.35982
G1 X176.29 Y165.23 E.26868
;======== H2D 20260731========
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
G1 X174.29 Y165.24 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X174.143 Y163.92 Z1.2 F60000
G1 Z.8
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.4271
G1 F1549
M204 S8000
G1 X174.751 Y163.313 E.02608
G1 X174.751 Y162.769 E.01649
G1 X173.769 Y163.751 E.04212
G1 X173.226 Y163.751 E.01649
G1 X174.751 Y162.226 E.06543
G1 X174.751 Y161.683 E.01649
G1 X172.683 Y163.751 E.08875
G1 X172.139 Y163.751 E.01649
G1 X174.751 Y161.139 E.11207
G1 X174.751 Y160.596 E.01649
G1 X171.596 Y163.751 E.13539
G1 X171.053 Y163.751 E.01649
G1 X174.751 Y160.053 E.1587
G1 X174.751 Y159.509 E.01649
G1 X170.509 Y163.751 E.18202
G1 X169.966 Y163.751 E.01649
G1 X174.751 Y158.966 E.20534
G1 X174.751 Y158.423 E.01649
G1 X169.423 Y163.751 E.22866
G1 X168.879 Y163.751 E.01649
G1 X174.751 Y157.879 E.25197
G1 X174.751 Y157.749 E.00394
G1 X174.337 Y157.749 E.01254
G1 X168.336 Y163.751 E.25755
G1 X167.793 Y163.751 E.01649
G1 X173.794 Y157.749 E.25755
G1 X173.251 Y157.749 E.01649
G1 X167.249 Y163.751 E.25755
G1 X166.706 Y163.751 E.01649
G1 X172.707 Y157.749 E.25755
G1 X172.164 Y157.749 E.01649
G1 X166.163 Y163.751 E.25755
G1 X165.749 Y163.751 E.01255
G1 X165.749 Y163.621 E.00394
G1 X171.621 Y157.749 E.25198
G1 X171.077 Y157.749 E.01649
G1 X165.749 Y163.077 E.22866
G1 X165.749 Y162.534 E.01649
G1 X170.534 Y157.749 E.20534
G1 X169.991 Y157.749 E.01649
G1 X165.749 Y161.991 E.18202
G1 X165.749 Y161.447 E.01649
G1 X169.447 Y157.749 E.15871
G1 X168.904 Y157.749 E.01649
G1 X165.749 Y160.904 E.13539
G1 X165.749 Y160.361 E.01649
G1 X168.361 Y157.749 E.11207
G1 X167.817 Y157.749 E.01649
G1 X165.749 Y159.817 E.08875
G1 X165.749 Y159.274 E.01649
G1 X167.274 Y157.749 E.06544
G1 X166.731 Y157.749 E.01649
G1 X165.749 Y158.731 E.04212
G1 X165.749 Y158.188 E.01649
G1 X166.357 Y157.58 E.02608
; CHANGE_LAYER
; Z_HEIGHT: 1
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9370.607
G1 X165.749 Y158.188 E-.32659
G1 X165.749 Y158.731 E-.20646
G1 X166.172 Y158.309 E-.22694
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 5/165
; update layer progress
M73 L5
M991 S0 P4 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z1.2 I-.662 J1.021 P1  F60000
G1 X175.084 Y164.084 Z1.2
G1 Z1
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1550
M204 S8000
G1 X165.416 Y164.084 E.31087
G1 X165.416 Y157.416 E.21441
G1 X175.084 Y157.416 E.31087
G1 X175.084 Y164.024 E.21248
; COOLING_NODE: 0
M204 S10000
G1 X175.491 Y164.491 F60000
G1 F1550
M204 S8000
G1 X165.009 Y164.491 E.33705
G1 X165.009 Y157.009 E.24059
G1 X175.491 Y157.009 E.33705
G1 X175.491 Y164.431 E.23866
; COOLING_NODE: 0
M204 S10000
G1 X175.898 Y164.898 F60000
G1 F1550
M204 S8000
G1 X164.602 Y164.898 E.36323
G1 X164.602 Y156.602 E.26677
G1 X175.898 Y156.602 E.36323
G1 X175.898 Y164.838 E.26484
; COOLING_NODE: 0
M204 S250
G1 X176.29 Y165.29 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1550
M204 S5000
G1 X164.21 Y165.29 E.35982
G1 X164.21 Y156.21 E.27046
G1 X176.29 Y156.21 E.35982
G1 X176.29 Y165.23 E.26868
;======== H2D 20260731========
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
M73 P23 R21
G1 F9547.055
M204 S8000
G1 X174.29 Y165.24 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X174.92 Y158.357 Z1.4 F60000
G1 Z1
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.4271
G1 F1550
M204 S8000
G1 X174.313 Y157.749 E.02608
G1 X173.769 Y157.749 E.01649
G1 X174.751 Y158.731 E.04211
G1 X174.751 Y159.274 E.01649
G1 X173.226 Y157.749 E.06543
G1 X172.683 Y157.749 E.01649
G1 X174.751 Y159.817 E.08875
G1 X174.751 Y160.361 E.01649
G1 X172.139 Y157.749 E.11207
G1 X171.596 Y157.749 E.01649
G1 X174.751 Y160.904 E.13539
G1 X174.751 Y161.447 E.01649
G1 X171.053 Y157.749 E.1587
G1 X170.509 Y157.749 E.01649
G1 X174.751 Y161.991 E.18202
G1 X174.751 Y162.534 E.01649
G1 X169.966 Y157.749 E.20534
G1 X169.423 Y157.749 E.01649
G1 X174.751 Y163.077 E.22866
G1 X174.751 Y163.621 E.01649
G1 X168.879 Y157.749 E.25197
G1 X168.336 Y157.749 E.01649
G1 X174.337 Y163.751 E.25755
G1 X173.794 Y163.751 E.01649
G1 X167.793 Y157.749 E.25755
G1 X167.249 Y157.749 E.01649
G1 X173.251 Y163.751 E.25755
G1 X172.707 Y163.751 E.01649
G1 X166.706 Y157.749 E.25755
G1 X166.163 Y157.749 E.01649
G1 X172.164 Y163.751 E.25755
G1 X171.621 Y163.751 E.01649
G1 X165.749 Y157.879 E.25198
G1 X165.749 Y158.423 E.01649
G1 X171.077 Y163.751 E.22866
G1 X170.534 Y163.751 E.01649
G1 X165.749 Y158.966 E.20534
G1 X165.749 Y159.509 E.01649
G1 X169.991 Y163.751 E.18202
G1 X169.447 Y163.751 E.01649
G1 X165.749 Y160.053 E.15871
G1 X165.749 Y160.596 E.01649
G1 X168.904 Y163.751 E.13539
G1 X168.361 Y163.751 E.01649
G1 X165.749 Y161.139 E.11207
G1 X165.749 Y161.683 E.01649
G1 X167.817 Y163.751 E.08875
G1 X167.274 Y163.751 E.01649
G1 X165.749 Y162.226 E.06544
G1 X165.749 Y162.769 E.01649
G1 X166.731 Y163.751 E.04212
G1 X166.188 Y163.751 E.01649
G1 X165.58 Y163.143 E.02608
; CHANGE_LAYER
; Z_HEIGHT: 1.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9370.607
G1 X166.188 Y163.751 E-.32659
G1 X166.731 Y163.751 E-.20646
G1 X166.309 Y163.328 E-.22695
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 6/165
; update layer progress
M73 L6
M991 S0 P5 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z1.4 I-.104 J1.212 P1  F60000
G1 X175.084 Y164.084 Z1.4
G1 Z1.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1549
M204 S8000
G1 X165.416 Y164.084 E.31087
G1 X165.416 Y157.416 E.21441
G1 X175.084 Y157.416 E.31087
G1 X175.084 Y164.024 E.21248
; COOLING_NODE: 0
M204 S10000
G1 X175.491 Y164.491 F60000
G1 F1549
M204 S8000
G1 X165.009 Y164.491 E.33705
G1 X165.009 Y157.009 E.24059
G1 X175.491 Y157.009 E.33705
G1 X175.491 Y164.431 E.23866
; COOLING_NODE: 0
M204 S10000
G1 X175.898 Y164.898 F60000
G1 F1549
M204 S8000
G1 X164.602 Y164.898 E.36323
G1 X164.602 Y156.602 E.26677
G1 X175.898 Y156.602 E.36323
G1 X175.898 Y164.838 E.26484
; COOLING_NODE: 0
M204 S250
G1 X176.29 Y165.29 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1549
M204 S5000
G1 X164.21 Y165.29 E.35982
G1 X164.21 Y156.21 E.27046
G1 X176.29 Y156.21 E.35982
G1 X176.29 Y165.23 E.26868
;======== H2D 20260731========
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
G1 X174.29 Y165.24 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X174.143 Y163.92 Z1.6 F60000
G1 Z1.2
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.4271
G1 F1549
M204 S8000
G1 X174.751 Y163.313 E.02608
G1 X174.751 Y162.769 E.01649
G1 X173.769 Y163.751 E.04212
G1 X173.226 Y163.751 E.01649
G1 X174.751 Y162.226 E.06543
G1 X174.751 Y161.683 E.01649
G1 X172.683 Y163.751 E.08875
G1 X172.139 Y163.751 E.01649
G1 X174.751 Y161.139 E.11207
G1 X174.751 Y160.596 E.01649
G1 X171.596 Y163.751 E.13539
G1 X171.053 Y163.751 E.01649
G1 X174.751 Y160.053 E.1587
G1 X174.751 Y159.509 E.01649
G1 X170.509 Y163.751 E.18202
G1 X169.966 Y163.751 E.01649
G1 X174.751 Y158.966 E.20534
G1 X174.751 Y158.423 E.01649
G1 X169.423 Y163.751 E.22866
G1 X168.879 Y163.751 E.01649
G1 X174.751 Y157.879 E.25197
G1 X174.751 Y157.749 E.00394
G1 X174.337 Y157.749 E.01254
G1 X168.336 Y163.751 E.25755
G1 X167.793 Y163.751 E.01649
G1 X173.794 Y157.749 E.25755
G1 X173.251 Y157.749 E.01649
G1 X167.249 Y163.751 E.25755
G1 X166.706 Y163.751 E.01649
G1 X172.707 Y157.749 E.25755
G1 X172.164 Y157.749 E.01649
M73 P24 R21
G1 X166.163 Y163.751 E.25755
G1 X165.749 Y163.751 E.01255
G1 X165.749 Y163.621 E.00394
G1 X171.621 Y157.749 E.25198
G1 X171.077 Y157.749 E.01649
G1 X165.749 Y163.077 E.22866
G1 X165.749 Y162.534 E.01649
G1 X170.534 Y157.749 E.20534
G1 X169.991 Y157.749 E.01649
G1 X165.749 Y161.991 E.18202
G1 X165.749 Y161.447 E.01649
G1 X169.447 Y157.749 E.15871
G1 X168.904 Y157.749 E.01649
G1 X165.749 Y160.904 E.13539
G1 X165.749 Y160.361 E.01649
G1 X168.361 Y157.749 E.11207
G1 X167.817 Y157.749 E.01649
G1 X165.749 Y159.817 E.08875
G1 X165.749 Y159.274 E.01649
G1 X167.274 Y157.749 E.06544
G1 X166.731 Y157.749 E.01649
G1 X165.749 Y158.731 E.04212
G1 X165.749 Y158.188 E.01649
G1 X166.357 Y157.58 E.02608
; CHANGE_LAYER
; Z_HEIGHT: 1.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9370.607
G1 X165.749 Y158.188 E-.32659
G1 X165.749 Y158.731 E-.20646
G1 X166.172 Y158.309 E-.22694
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 7/165
; update layer progress
M73 L7
M991 S0 P6 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z1.6 I-.662 J1.021 P1  F60000
G1 X175.084 Y164.084 Z1.6
G1 Z1.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1550
M204 S8000
G1 X165.416 Y164.084 E.31087
G1 X165.416 Y157.416 E.21441
G1 X175.084 Y157.416 E.31087
G1 X175.084 Y164.024 E.21248
; COOLING_NODE: 0
M204 S10000
G1 X175.491 Y164.491 F60000
G1 F1550
M204 S8000
G1 X165.009 Y164.491 E.33705
G1 X165.009 Y157.009 E.24059
G1 X175.491 Y157.009 E.33705
G1 X175.491 Y164.431 E.23866
; COOLING_NODE: 0
M204 S10000
G1 X175.898 Y164.898 F60000
G1 F1550
M204 S8000
G1 X164.602 Y164.898 E.36323
G1 X164.602 Y156.602 E.26677
G1 X175.898 Y156.602 E.36323
G1 X175.898 Y164.838 E.26484
; COOLING_NODE: 0
M204 S250
G1 X176.29 Y165.29 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1550
M204 S5000
G1 X164.21 Y165.29 E.35982
G1 X164.21 Y156.21 E.27046
G1 X176.29 Y156.21 E.35982
G1 X176.29 Y165.23 E.26868
;======== H2D 20260731========
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
G1 X174.29 Y165.24 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X174.92 Y158.357 Z1.8 F60000
G1 Z1.4
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.4271
G1 F1550
M204 S8000
G1 X174.313 Y157.749 E.02608
G1 X173.769 Y157.749 E.01649
G1 X174.751 Y158.731 E.04211
G1 X174.751 Y159.274 E.01649
G1 X173.226 Y157.749 E.06543
G1 X172.683 Y157.749 E.01649
G1 X174.751 Y159.817 E.08875
G1 X174.751 Y160.361 E.01649
G1 X172.139 Y157.749 E.11207
G1 X171.596 Y157.749 E.01649
G1 X174.751 Y160.904 E.13539
G1 X174.751 Y161.447 E.01649
G1 X171.053 Y157.749 E.1587
G1 X170.509 Y157.749 E.01649
G1 X174.751 Y161.991 E.18202
G1 X174.751 Y162.534 E.01649
G1 X169.966 Y157.749 E.20534
G1 X169.423 Y157.749 E.01649
G1 X174.751 Y163.077 E.22866
G1 X174.751 Y163.621 E.01649
G1 X168.879 Y157.749 E.25197
G1 X168.336 Y157.749 E.01649
G1 X174.337 Y163.751 E.25755
G1 X173.794 Y163.751 E.01649
G1 X167.793 Y157.749 E.25755
G1 X167.249 Y157.749 E.01649
G1 X173.251 Y163.751 E.25755
G1 X172.707 Y163.751 E.01649
G1 X166.706 Y157.749 E.25755
G1 X166.163 Y157.749 E.01649
G1 X172.164 Y163.751 E.25755
G1 X171.621 Y163.751 E.01649
G1 X165.749 Y157.879 E.25198
G1 X165.749 Y158.423 E.01649
G1 X171.077 Y163.751 E.22866
G1 X170.534 Y163.751 E.01649
G1 X165.749 Y158.966 E.20534
G1 X165.749 Y159.509 E.01649
G1 X169.991 Y163.751 E.18202
G1 X169.447 Y163.751 E.01649
G1 X165.749 Y160.053 E.15871
G1 X165.749 Y160.596 E.01649
G1 X168.904 Y163.751 E.13539
G1 X168.361 Y163.751 E.01649
G1 X165.749 Y161.139 E.11207
G1 X165.749 Y161.683 E.01649
G1 X167.817 Y163.751 E.08875
G1 X167.274 Y163.751 E.01649
G1 X165.749 Y162.226 E.06544
G1 X165.749 Y162.769 E.01649
G1 X166.731 Y163.751 E.04212
G1 X166.188 Y163.751 E.01649
G1 X165.58 Y163.143 E.02608
; CHANGE_LAYER
; Z_HEIGHT: 1.6
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9370.607
G1 X166.188 Y163.751 E-.32659
G1 X166.731 Y163.751 E-.20646
G1 X166.309 Y163.328 E-.22695
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 8/165
; update layer progress
M73 L8
M991 S0 P7 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z1.8 I-.104 J1.212 P1  F60000
G1 X175.084 Y164.084 Z1.8
G1 Z1.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1549
M204 S8000
G1 X165.416 Y164.084 E.31087
G1 X165.416 Y157.416 E.21441
G1 X175.084 Y157.416 E.31087
G1 X175.084 Y164.024 E.21248
; COOLING_NODE: 0
M204 S10000
G1 X175.491 Y164.491 F60000
G1 F1549
M204 S8000
G1 X165.009 Y164.491 E.33705
M73 P25 R21
G1 X165.009 Y157.009 E.24059
G1 X175.491 Y157.009 E.33705
G1 X175.491 Y164.431 E.23866
; COOLING_NODE: 0
M204 S10000
G1 X175.898 Y164.898 F60000
G1 F1549
M204 S8000
G1 X164.602 Y164.898 E.36323
G1 X164.602 Y156.602 E.26677
G1 X175.898 Y156.602 E.36323
G1 X175.898 Y164.838 E.26484
; COOLING_NODE: 0
M204 S250
G1 X176.29 Y165.29 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1549
M204 S5000
G1 X164.21 Y165.29 E.35982
G1 X164.21 Y156.21 E.27046
G1 X176.29 Y156.21 E.35982
G1 X176.29 Y165.23 E.26868
;======== H2D 20260731========
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
G1 X174.29 Y165.24 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X174.143 Y163.92 Z2 F60000
G1 Z1.6
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.4271
G1 F1549
M204 S8000
M73 P25 R20
G1 X174.751 Y163.313 E.02608
G1 X174.751 Y162.769 E.01649
G1 X173.769 Y163.751 E.04212
G1 X173.226 Y163.751 E.01649
G1 X174.751 Y162.226 E.06543
G1 X174.751 Y161.683 E.01649
G1 X172.683 Y163.751 E.08875
G1 X172.139 Y163.751 E.01649
G1 X174.751 Y161.139 E.11207
G1 X174.751 Y160.596 E.01649
G1 X171.596 Y163.751 E.13539
G1 X171.053 Y163.751 E.01649
G1 X174.751 Y160.053 E.1587
G1 X174.751 Y159.509 E.01649
G1 X170.509 Y163.751 E.18202
G1 X169.966 Y163.751 E.01649
G1 X174.751 Y158.966 E.20534
G1 X174.751 Y158.423 E.01649
G1 X169.423 Y163.751 E.22866
G1 X168.879 Y163.751 E.01649
G1 X174.751 Y157.879 E.25197
G1 X174.751 Y157.749 E.00394
G1 X174.337 Y157.749 E.01254
G1 X168.336 Y163.751 E.25755
G1 X167.793 Y163.751 E.01649
G1 X173.794 Y157.749 E.25755
G1 X173.251 Y157.749 E.01649
G1 X167.249 Y163.751 E.25755
G1 X166.706 Y163.751 E.01649
G1 X172.707 Y157.749 E.25755
G1 X172.164 Y157.749 E.01649
G1 X166.163 Y163.751 E.25755
G1 X165.749 Y163.751 E.01255
G1 X165.749 Y163.621 E.00394
G1 X171.621 Y157.749 E.25198
G1 X171.077 Y157.749 E.01649
G1 X165.749 Y163.077 E.22866
G1 X165.749 Y162.534 E.01649
G1 X170.534 Y157.749 E.20534
G1 X169.991 Y157.749 E.01649
G1 X165.749 Y161.991 E.18202
G1 X165.749 Y161.447 E.01649
G1 X169.447 Y157.749 E.15871
G1 X168.904 Y157.749 E.01649
G1 X165.749 Y160.904 E.13539
G1 X165.749 Y160.361 E.01649
G1 X168.361 Y157.749 E.11207
G1 X167.817 Y157.749 E.01649
G1 X165.749 Y159.817 E.08875
G1 X165.749 Y159.274 E.01649
G1 X167.274 Y157.749 E.06544
G1 X166.731 Y157.749 E.01649
G1 X165.749 Y158.731 E.04212
G1 X165.749 Y158.188 E.01649
G1 X166.357 Y157.58 E.02608
; CHANGE_LAYER
; Z_HEIGHT: 1.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9370.607
G1 X165.749 Y158.188 E-.32659
G1 X165.749 Y158.731 E-.20646
G1 X166.172 Y158.309 E-.22694
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 9/165
; update layer progress
M73 L9
M991 S0 P8 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z2 I-.662 J1.021 P1  F60000
G1 X175.084 Y164.084 Z2
G1 Z1.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1550
M204 S8000
G1 X165.416 Y164.084 E.31087
G1 X165.416 Y157.416 E.21441
G1 X175.084 Y157.416 E.31087
G1 X175.084 Y164.024 E.21248
; COOLING_NODE: 0
M204 S10000
G1 X175.491 Y164.491 F60000
G1 F1550
M204 S8000
G1 X165.009 Y164.491 E.33705
G1 X165.009 Y157.009 E.24059
G1 X175.491 Y157.009 E.33705
G1 X175.491 Y164.431 E.23866
; COOLING_NODE: 0
M204 S10000
G1 X175.898 Y164.898 F60000
G1 F1550
M204 S8000
G1 X164.602 Y164.898 E.36323
G1 X164.602 Y156.602 E.26677
G1 X175.898 Y156.602 E.36323
G1 X175.898 Y164.838 E.26484
; COOLING_NODE: 0
M204 S250
G1 X176.29 Y165.29 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1523
M204 S5000
G1 X164.21 Y165.29 E.35982
G1 X164.21 Y156.21 E.27046
G1 X176.29 Y156.21 E.35982
G1 X176.29 Y165.23 E.26868
;======== H2D 20260731========
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
G1 X174.29 Y165.24 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
M73 P26 R20
G1 X174.92 Y158.357 Z2.2 F60000
G1 Z1.8
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.4271
G1 F1550
M204 S8000
G1 X174.313 Y157.749 E.02608
G1 X173.769 Y157.749 E.01649
G1 X174.751 Y158.731 E.04211
G1 X174.751 Y159.274 E.01649
G1 X173.226 Y157.749 E.06543
G1 X172.683 Y157.749 E.01649
G1 X174.751 Y159.817 E.08875
G1 X174.751 Y160.361 E.01649
G1 X172.139 Y157.749 E.11207
G1 X171.596 Y157.749 E.01649
G1 X174.751 Y160.904 E.13539
G1 X174.751 Y161.447 E.01649
G1 X171.053 Y157.749 E.1587
G1 X170.509 Y157.749 E.01649
G1 X174.751 Y161.991 E.18202
G1 X174.751 Y162.534 E.01649
G1 X169.966 Y157.749 E.20534
G1 X169.423 Y157.749 E.01649
G1 X174.751 Y163.077 E.22866
G1 X174.751 Y163.621 E.01649
G1 X168.879 Y157.749 E.25197
G1 X168.336 Y157.749 E.01649
G1 X174.337 Y163.751 E.25755
G1 X173.794 Y163.751 E.01649
G1 X167.793 Y157.749 E.25755
G1 X167.249 Y157.749 E.01649
G1 X173.251 Y163.751 E.25755
G1 X172.707 Y163.751 E.01649
G1 X166.706 Y157.749 E.25755
G1 X166.163 Y157.749 E.01649
G1 X172.164 Y163.751 E.25755
G1 X171.621 Y163.751 E.01649
G1 X165.749 Y157.879 E.25198
G1 X165.749 Y158.423 E.01649
G1 X171.077 Y163.751 E.22866
G1 X170.534 Y163.751 E.01649
G1 X165.749 Y158.966 E.20534
G1 X165.749 Y159.509 E.01649
G1 X169.991 Y163.751 E.18202
G1 X169.447 Y163.751 E.01649
G1 X165.749 Y160.053 E.15871
G1 X165.749 Y160.596 E.01649
G1 X168.904 Y163.751 E.13539
G1 X168.361 Y163.751 E.01649
G1 X165.749 Y161.139 E.11207
G1 X165.749 Y161.683 E.01649
G1 X167.817 Y163.751 E.08875
G1 X167.274 Y163.751 E.01649
G1 X165.749 Y162.226 E.06544
G1 X165.749 Y162.769 E.01649
G1 X166.731 Y163.751 E.04212
G1 X166.188 Y163.751 E.01649
G1 X165.58 Y163.143 E.02608
; CHANGE_LAYER
; Z_HEIGHT: 2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9370.607
G1 X166.188 Y163.751 E-.32659
G1 X166.731 Y163.751 E-.20646
G1 X166.309 Y163.328 E-.22695
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 10/165
; update layer progress
M73 L10
M991 S0 P9 ;notify layer change

M106 S224.4
; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z2.2 I-.235 J1.194 P1  F60000
G1 X176.29 Y165.29 Z2.2
G1 Z2
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1463
M204 S5000
G1 X164.21 Y165.29 E.35982
G1 X164.21 Y156.21 E.27046
G1 X176.29 Y156.21 E.35982
G1 X176.29 Y165.23 E.26868
;======== H2D 20260731========
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
G1 X175.982 Y165.094 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.266851
G1 F1838
M204 S8000
G1 X175.982 Y156.63 E.14972
G1 X175.963 Y156.537 E.00167
G1 X175.87 Y156.518 E.00167
G1 X164.406 Y156.518 E.20279
; WIPE_START
G1 F15000
G1 X166.406 Y156.518 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.807 Y161.911 Z2.4 F60000
G1 X174.983 Y165.083 Z2.4
G1 Z2
G1 E.8 F1800
; FEATURE: Top surface
; LINE_WIDTH: 0.42
G1 F1838
M204 S2000
G1 X175.844 Y164.222 E.03625
G1 X175.977 Y164.088
G1 X175.977 Y163.555
G1 X175.844 Y163.689
G1 X174.45 Y165.083 E.05871
G1 X174.316 Y165.216
G1 X173.783 Y165.216
G1 X173.917 Y165.083
G1 X175.844 Y163.156 E.08117
G1 X175.977 Y163.022
G1 X175.977 Y162.489
G1 X175.844 Y162.622
G1 X173.383 Y165.083 E.10364
G1 X173.25 Y165.216
G1 X172.717 Y165.216
G1 X172.85 Y165.083
G1 X175.844 Y162.089 E.1261
G1 X175.977 Y161.955
G1 X175.977 Y161.422
G1 X175.844 Y161.556
G1 X172.317 Y165.083 E.14856
G1 X172.183 Y165.216
G1 X171.65 Y165.216
G1 X171.784 Y165.083
G1 X175.844 Y161.023 E.17103
G1 X175.977 Y160.889
G1 X175.977 Y160.356
G1 X175.844 Y160.489
G1 X171.25 Y165.083 E.19349
G1 X171.117 Y165.216
G1 X170.584 Y165.216
G1 X170.717 Y165.083
G1 X175.844 Y159.956 E.21595
G1 X175.977 Y159.822
G1 X175.977 Y159.289
G1 X175.844 Y159.423
G1 X170.184 Y165.083 E.23842
G1 X170.05 Y165.216
G1 X169.517 Y165.216
G1 X169.651 Y165.083
G1 X175.844 Y158.89 E.26088
G1 X175.977 Y158.756
G1 X175.977 Y158.223
G1 X175.844 Y158.356
G1 X169.117 Y165.083 E.28334
G1 X168.984 Y165.216
G1 X168.451 Y165.216
G1 X168.584 Y165.083
G1 X175.844 Y157.823 E.30581
G1 X175.977 Y157.689
G1 X175.977 Y157.156
G1 X175.844 Y157.29
G1 X168.051 Y165.083 E.32827
G1 X167.917 Y165.216
G1 X167.384 Y165.216
G1 X167.518 Y165.083
G1 X175.844 Y156.757 E.35073
G1 X175.977 Y156.623
G1 X175.544 Y156.523
G1 X175.411 Y156.656
G1 X166.984 Y165.083 E.35496
G1 X166.851 Y165.216
G1 X166.317 Y165.216
G1 X166.451 Y165.083
G1 X174.878 Y156.656 E.35496
G1 X175.011 Y156.523
G1 X174.478 Y156.523
G1 X174.344 Y156.656
G1 X165.918 Y165.083 E.35496
G1 X165.784 Y165.216
G1 X165.251 Y165.216
G1 X165.385 Y165.083
G1 X173.811 Y156.656 E.35496
G1 X173.945 Y156.523
G1 X173.411 Y156.523
G1 X173.278 Y156.656
G1 X164.851 Y165.083 E.35496
G1 X164.718 Y165.216
G1 X164.284 Y165.117
G1 X164.417 Y164.983
G1 X172.745 Y156.656 E.35078
G1 X172.878 Y156.523
G1 X172.345 Y156.523
G1 X172.211 Y156.656
G1 X164.417 Y164.45 E.32831
G1 X164.284 Y164.584
G1 X164.284 Y164.05
G1 X164.417 Y163.917
G1 X171.678 Y156.656 E.30585
G1 X171.812 Y156.523
G1 X171.278 Y156.523
G1 X171.145 Y156.656
G1 X164.417 Y163.384 E.28339
G1 X164.284 Y163.517
G1 X164.284 Y162.984
G1 X164.417 Y162.85
G1 X170.611 Y156.656 E.26092
G1 X170.745 Y156.523
G1 X170.212 Y156.523
G1 X170.078 Y156.656
M73 P27 R20
G1 X164.417 Y162.317 E.23846
G1 X164.284 Y162.451
G1 X164.284 Y161.917
G1 X164.417 Y161.784
G1 X169.545 Y156.656 E.216
G1 X169.679 Y156.523
G1 X169.145 Y156.523
G1 X169.012 Y156.656
G1 X164.417 Y161.251 E.19353
G1 X164.284 Y161.384
G1 X164.284 Y160.851
G1 X164.417 Y160.717
G1 X168.478 Y156.656 E.17107
G1 X168.612 Y156.523
G1 X168.079 Y156.523
G1 X167.945 Y156.656
G1 X164.417 Y160.184 E.14861
G1 X164.284 Y160.318
G1 X164.284 Y159.784
G1 X164.417 Y159.651
G1 X167.412 Y156.656 E.12614
G1 X167.546 Y156.523
G1 X167.012 Y156.523
G1 X166.879 Y156.656
G1 X164.417 Y159.118 E.10368
G1 X164.284 Y159.251
G1 X164.284 Y158.718
G1 X164.417 Y158.584
G1 X166.345 Y156.656 E.08122
G1 X166.479 Y156.523
G1 X165.946 Y156.523
G1 X165.812 Y156.656
G1 X164.417 Y158.051 E.05875
G1 X164.284 Y158.185
G1 X164.284 Y157.651
G1 X164.417 Y157.518
G1 X165.279 Y156.656 E.03629
; CHANGE_LAYER
; Z_HEIGHT: 2.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9547.055
M204 S8000
G1 X164.417 Y157.518 E-.46298
G1 X164.284 Y157.651 E-.07182
G1 X164.284 Y158.185 E-.20264
G1 X164.326 Y158.143 E-.02257
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 11/165
; update layer progress
M73 L11
M991 S0 P10 ;notify layer change

M106 S229.5
; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z2.4 I.084 J1.214 P1  F60000
G1 X175.102 Y157.398 Z2.4
G1 Z2.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X164.602 Y157.398 E.33764
G1 X164.602 Y156.602 E.02559
G1 X175.898 Y156.602 E.36323
G1 X175.898 Y164.898 E.26677
G1 X175.102 Y164.898 E.02559
G1 X175.102 Y157.458 E.23924
; COOLING_NODE: 0
M204 S250
G1 X174.71 Y157.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X164.21 Y157.79 E.31276
G1 X164.21 Y156.21 E.04706
G1 X176.29 Y156.21 E.35982
G1 X176.29 Y165.29 E.27046
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X174.71 Y165.29 E.04706
G1 X174.71 Y157.85 E.22161
; WIPE_START
G1 F9547.055
M204 S8000
G1 X172.71 Y157.839 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.5 Y157.194 Z2.6 F60000
G1 Z2.2
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.4484
G1 F1200
M204 S8000
G1 X175.483 Y157.114 E.00263
; LINE_WIDTH: 0.470635
G1 X175.467 Y157.033 E.00278
G1 X175.306 Y157 E.00556
; LINE_WIDTH: 0.43172
G1 X164.806 Y157 E.32248
; WIPE_START
G1 F9259.259
G1 X166.806 Y157 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X174.436 Y157.171 Z2.6 F60000
G1 X175.5 Y157.194 Z2.6
G1 Z2.2
G1 E.8 F1800
; LINE_WIDTH: 0.43173
G1 F1200
M204 S8000
G1 X175.5 Y164.694 E.23035
; CHANGE_LAYER
; Z_HEIGHT: 2.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.021
G1 X175.5 Y162.694 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 12/165
; update layer progress
M73 L12
M991 S0 P11 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z2.6 I1.214 J-.091 P1  F60000
G1 X175.102 Y157.398 Z2.6
G1 Z2.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X164.602 Y157.398 E.33764
G1 X164.602 Y156.602 E.02559
G1 X175.898 Y156.602 E.36323
G1 X175.898 Y164.898 E.26677
G1 X175.102 Y164.898 E.02559
G1 X175.102 Y157.458 E.23924
; COOLING_NODE: 0
M204 S250
G1 X174.71 Y157.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X164.21 Y157.79 E.31276
G1 X164.21 Y156.21 E.04706
G1 X176.29 Y156.21 E.35982
G1 X176.29 Y165.29 E.27046
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X174.71 Y165.29 E.04706
G1 X174.71 Y157.85 E.22161
; WIPE_START
G1 F9547.055
M204 S8000
G1 X172.71 Y157.839 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.5 Y157.194 Z2.8 F60000
G1 Z2.4
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.4484
G1 F1200
M204 S8000
G1 X175.483 Y157.114 E.00263
; LINE_WIDTH: 0.470635
G1 X175.467 Y157.033 E.00278
G1 X175.306 Y157 E.00556
; LINE_WIDTH: 0.43172
G1 X164.806 Y157 E.32248
; WIPE_START
G1 F9259.259
G1 X166.806 Y157 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X174.436 Y157.171 Z2.8 F60000
G1 X175.5 Y157.194 Z2.8
G1 Z2.4
G1 E.8 F1800
; LINE_WIDTH: 0.43173
G1 F1200
M204 S8000
G1 X175.5 Y164.694 E.23035
; CHANGE_LAYER
; Z_HEIGHT: 2.6
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.021
G1 X175.5 Y162.694 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 13/165
; update layer progress
M73 L13
M991 S0 P12 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z2.8 I1.214 J-.091 P1  F60000
G1 X175.102 Y157.398 Z2.8
G1 Z2.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X164.602 Y157.398 E.33764
G1 X164.602 Y156.602 E.02559
G1 X175.898 Y156.602 E.36323
G1 X175.898 Y164.898 E.26677
G1 X175.102 Y164.898 E.02559
G1 X175.102 Y157.458 E.23924
; COOLING_NODE: 0
M204 S250
G1 X174.71 Y157.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X164.21 Y157.79 E.31276
G1 X164.21 Y156.21 E.04706
G1 X176.29 Y156.21 E.35982
G1 X176.29 Y165.29 E.27046
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X174.71 Y165.29 E.04706
G1 X174.71 Y157.85 E.22161
; WIPE_START
G1 F9547.055
M204 S8000
M73 P28 R20
G1 X172.71 Y157.839 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.5 Y157.194 Z3 F60000
G1 Z2.6
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.4484
G1 F1200
M204 S8000
G1 X175.483 Y157.114 E.00263
; LINE_WIDTH: 0.470635
G1 X175.467 Y157.033 E.00278
G1 X175.306 Y157 E.00556
; LINE_WIDTH: 0.43172
G1 X164.806 Y157 E.32248
; WIPE_START
G1 F9259.259
G1 X166.806 Y157 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X174.436 Y157.171 Z3 F60000
G1 X175.5 Y157.194 Z3
G1 Z2.6
G1 E.8 F1800
; LINE_WIDTH: 0.43173
G1 F1200
M204 S8000
G1 X175.5 Y164.694 E.23035
; CHANGE_LAYER
; Z_HEIGHT: 2.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.021
G1 X175.5 Y162.694 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 14/165
; update layer progress
M73 L14
M991 S0 P13 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z3 I1.214 J-.091 P1  F60000
G1 X175.102 Y157.398 Z3
G1 Z2.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X164.602 Y157.398 E.33764
G1 X164.602 Y156.602 E.02559
G1 X175.898 Y156.602 E.36323
G1 X175.898 Y164.898 E.26677
G1 X175.102 Y164.898 E.02559
G1 X175.102 Y157.458 E.23924
; COOLING_NODE: 0
M204 S250
G1 X174.71 Y157.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X164.21 Y157.79 E.31276
G1 X164.21 Y156.21 E.04706
G1 X176.29 Y156.21 E.35982
G1 X176.29 Y165.29 E.27046
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X174.71 Y165.29 E.04706
G1 X174.71 Y157.85 E.22161
; WIPE_START
G1 F9547.055
M204 S8000
G1 X172.71 Y157.839 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.5 Y157.194 Z3.2 F60000
G1 Z2.8
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.4484
G1 F1200
M204 S8000
G1 X175.483 Y157.114 E.00263
; LINE_WIDTH: 0.470635
G1 X175.467 Y157.033 E.00278
G1 X175.306 Y157 E.00556
; LINE_WIDTH: 0.43172
G1 X164.806 Y157 E.32248
; WIPE_START
G1 F9259.259
G1 X166.806 Y157 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X174.436 Y157.171 Z3.2 F60000
G1 X175.5 Y157.194 Z3.2
G1 Z2.8
G1 E.8 F1800
; LINE_WIDTH: 0.43173
G1 F1200
M204 S8000
G1 X175.5 Y164.694 E.23035
; CHANGE_LAYER
; Z_HEIGHT: 3
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.021
G1 X175.5 Y162.694 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 15/165
; update layer progress
M73 L15
M991 S0 P14 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z3.2 I1.214 J-.091 P1  F60000
G1 X175.102 Y157.398 Z3.2
G1 Z3
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X164.602 Y157.398 E.33764
G1 X164.602 Y156.602 E.02559
G1 X175.898 Y156.602 E.36323
G1 X175.898 Y164.898 E.26677
G1 X175.102 Y164.898 E.02559
G1 X175.102 Y157.458 E.23924
; COOLING_NODE: 0
M204 S250
G1 X174.71 Y157.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X164.21 Y157.79 E.31276
G1 X164.21 Y156.21 E.04706
G1 X176.29 Y156.21 E.35982
G1 X176.29 Y165.29 E.27046
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X174.71 Y165.29 E.04706
G1 X174.71 Y157.85 E.22161
; WIPE_START
G1 F9547.055
M204 S8000
G1 X172.71 Y157.839 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.5 Y157.194 Z3.4 F60000
G1 Z3
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.4484
G1 F1200
M204 S8000
G1 X175.483 Y157.114 E.00263
; LINE_WIDTH: 0.470635
G1 X175.467 Y157.033 E.00278
G1 X175.306 Y157 E.00556
; LINE_WIDTH: 0.43172
G1 X164.806 Y157 E.32248
; WIPE_START
G1 F9259.259
G1 X166.806 Y157 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X174.436 Y157.171 Z3.4 F60000
G1 X175.5 Y157.194 Z3.4
G1 Z3
G1 E.8 F1800
; LINE_WIDTH: 0.43173
G1 F1200
M204 S8000
G1 X175.5 Y164.694 E.23035
; CHANGE_LAYER
; Z_HEIGHT: 3.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.021
G1 X175.5 Y162.694 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 16/165
; update layer progress
M73 L16
M991 S0 P15 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z3.4 I1.214 J-.091 P1  F60000
G1 X175.102 Y157.398 Z3.4
G1 Z3.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X164.602 Y157.398 E.33764
G1 X164.602 Y156.602 E.02559
G1 X175.898 Y156.602 E.36323
G1 X175.898 Y164.898 E.26677
G1 X175.102 Y164.898 E.02559
G1 X175.102 Y157.458 E.23924
; COOLING_NODE: 0
M204 S250
M73 P28 R19
G1 X174.71 Y157.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X164.21 Y157.79 E.31276
G1 X164.21 Y156.21 E.04706
G1 X176.29 Y156.21 E.35982
G1 X176.29 Y165.29 E.27046
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X174.71 Y165.29 E.04706
G1 X174.71 Y157.85 E.22161
; WIPE_START
G1 F9547.055
M204 S8000
M73 P29 R19
G1 X172.71 Y157.839 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.5 Y157.194 Z3.6 F60000
G1 Z3.2
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.4484
G1 F1200
M204 S8000
G1 X175.483 Y157.114 E.00263
; LINE_WIDTH: 0.470635
G1 X175.467 Y157.033 E.00278
G1 X175.306 Y157 E.00556
; LINE_WIDTH: 0.43172
G1 X164.806 Y157 E.32248
; WIPE_START
G1 F9259.259
G1 X166.806 Y157 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X174.436 Y157.171 Z3.6 F60000
G1 X175.5 Y157.194 Z3.6
G1 Z3.2
G1 E.8 F1800
; LINE_WIDTH: 0.43173
G1 F1200
M204 S8000
G1 X175.5 Y164.694 E.23035
; CHANGE_LAYER
; Z_HEIGHT: 3.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.021
G1 X175.5 Y162.694 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 17/165
; update layer progress
M73 L17
M991 S0 P16 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z3.6 I1.214 J-.091 P1  F60000
G1 X175.102 Y157.398 Z3.6
G1 Z3.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X164.602 Y157.398 E.33764
G1 X164.602 Y156.602 E.02559
G1 X175.898 Y156.602 E.36323
G1 X175.898 Y164.898 E.26677
G1 X175.102 Y164.898 E.02559
G1 X175.102 Y157.458 E.23924
; COOLING_NODE: 0
M204 S250
G1 X174.71 Y157.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X164.21 Y157.79 E.31276
G1 X164.21 Y156.21 E.04706
G1 X176.29 Y156.21 E.35982
G1 X176.29 Y165.29 E.27046
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X174.71 Y165.29 E.04706
G1 X174.71 Y157.85 E.22161
; WIPE_START
G1 F9547.055
M204 S8000
G1 X172.71 Y157.839 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.5 Y157.194 Z3.8 F60000
G1 Z3.4
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.4484
G1 F1200
M204 S8000
G1 X175.483 Y157.114 E.00263
; LINE_WIDTH: 0.470635
G1 X175.467 Y157.033 E.00278
G1 X175.306 Y157 E.00556
; LINE_WIDTH: 0.43172
G1 X164.806 Y157 E.32248
; WIPE_START
G1 F9259.259
G1 X166.806 Y157 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X174.436 Y157.171 Z3.8 F60000
G1 X175.5 Y157.194 Z3.8
G1 Z3.4
G1 E.8 F1800
; LINE_WIDTH: 0.43173
G1 F1200
M204 S8000
G1 X175.5 Y164.694 E.23035
; CHANGE_LAYER
; Z_HEIGHT: 3.6
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.021
G1 X175.5 Y162.694 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 18/165
; update layer progress
M73 L18
M991 S0 P17 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z3.8 I1.214 J-.091 P1  F60000
G1 X175.102 Y157.398 Z3.8
G1 Z3.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X164.602 Y157.398 E.33764
G1 X164.602 Y156.602 E.02559
G1 X175.898 Y156.602 E.36323
G1 X175.898 Y164.898 E.26677
G1 X175.102 Y164.898 E.02559
G1 X175.102 Y157.458 E.23924
; COOLING_NODE: 0
M204 S250
G1 X174.71 Y157.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X164.21 Y157.79 E.31276
G1 X164.21 Y156.21 E.04706
G1 X176.29 Y156.21 E.35982
G1 X176.29 Y165.29 E.27046
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X174.71 Y165.29 E.04706
G1 X174.71 Y157.85 E.22161
; WIPE_START
G1 F9547.055
M204 S8000
G1 X172.71 Y157.839 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.5 Y157.194 Z4 F60000
G1 Z3.6
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.4484
G1 F1200
M204 S8000
G1 X175.483 Y157.114 E.00263
; LINE_WIDTH: 0.470635
G1 X175.467 Y157.033 E.00278
G1 X175.306 Y157 E.00556
; LINE_WIDTH: 0.43172
G1 X164.806 Y157 E.32248
; WIPE_START
G1 F9259.259
G1 X166.806 Y157 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X174.436 Y157.171 Z4 F60000
G1 X175.5 Y157.194 Z4
G1 Z3.6
G1 E.8 F1800
; LINE_WIDTH: 0.43173
G1 F1200
M204 S8000
G1 X175.5 Y164.694 E.23035
; CHANGE_LAYER
; Z_HEIGHT: 3.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.021
G1 X175.5 Y162.694 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 19/165
; update layer progress
M73 L19
M991 S0 P18 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z4 I1.214 J-.091 P1  F60000
G1 X175.102 Y157.398 Z4
G1 Z3.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X164.602 Y157.398 E.33764
G1 X164.602 Y156.602 E.02559
G1 X175.898 Y156.602 E.36323
G1 X175.898 Y164.898 E.26677
G1 X175.102 Y164.898 E.02559
G1 X175.102 Y157.458 E.23924
; COOLING_NODE: 0
M204 S250
G1 X174.71 Y157.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X164.21 Y157.79 E.31276
G1 X164.21 Y156.21 E.04706
G1 X176.29 Y156.21 E.35982
G1 X176.29 Y165.29 E.27046
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X174.71 Y165.29 E.04706
G1 X174.71 Y157.85 E.22161
; WIPE_START
G1 F9547.055
M204 S8000
M73 P30 R19
G1 X172.71 Y157.839 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.5 Y157.194 Z4.2 F60000
G1 Z3.8
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.4484
G1 F1200
M204 S8000
G1 X175.483 Y157.114 E.00263
; LINE_WIDTH: 0.470635
G1 X175.467 Y157.033 E.00278
G1 X175.306 Y157 E.00556
; LINE_WIDTH: 0.43172
G1 X164.806 Y157 E.32248
; WIPE_START
G1 F9259.259
G1 X166.806 Y157 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X174.436 Y157.171 Z4.2 F60000
G1 X175.5 Y157.194 Z4.2
G1 Z3.8
G1 E.8 F1800
; LINE_WIDTH: 0.43173
G1 F1200
M204 S8000
G1 X175.5 Y164.694 E.23035
; CHANGE_LAYER
; Z_HEIGHT: 4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.021
G1 X175.5 Y162.694 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 20/165
; update layer progress
M73 L20
M991 S0 P19 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z4.2 I1.214 J-.091 P1  F60000
G1 X175.102 Y157.398 Z4.2
G1 Z4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X164.602 Y157.398 E.33764
G1 X164.602 Y156.602 E.02559
G1 X175.898 Y156.602 E.36323
G1 X175.898 Y164.898 E.26677
G1 X175.102 Y164.898 E.02559
G1 X175.102 Y157.458 E.23924
; COOLING_NODE: 0
M204 S250
G1 X174.71 Y157.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X164.21 Y157.79 E.31276
G1 X164.21 Y156.21 E.04706
G1 X176.29 Y156.21 E.35982
G1 X176.29 Y165.29 E.27046
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X174.71 Y165.29 E.04706
G1 X174.71 Y157.85 E.22161
; WIPE_START
G1 F9547.055
M204 S8000
G1 X172.71 Y157.839 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.5 Y157.194 Z4.4 F60000
G1 Z4
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.4484
G1 F1200
M204 S8000
G1 X175.483 Y157.114 E.00263
; LINE_WIDTH: 0.470635
G1 X175.467 Y157.033 E.00278
G1 X175.306 Y157 E.00556
; LINE_WIDTH: 0.43172
G1 X164.806 Y157 E.32248
; WIPE_START
G1 F9259.259
G1 X166.806 Y157 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X174.436 Y157.171 Z4.4 F60000
G1 X175.5 Y157.194 Z4.4
G1 Z4
G1 E.8 F1800
; LINE_WIDTH: 0.43173
G1 F1200
M204 S8000
G1 X175.5 Y164.694 E.23035
; CHANGE_LAYER
; Z_HEIGHT: 4.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.021
G1 X175.5 Y162.694 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 21/165
; update layer progress
M73 L21
M991 S0 P20 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z4.4 I1.214 J-.091 P1  F60000
G1 X175.102 Y157.398 Z4.4
G1 Z4.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X164.602 Y157.398 E.33764
G1 X164.602 Y156.602 E.02559
G1 X175.898 Y156.602 E.36323
G1 X175.898 Y164.898 E.26677
G1 X175.102 Y164.898 E.02559
G1 X175.102 Y157.458 E.23924
; COOLING_NODE: 0
M204 S250
G1 X174.71 Y157.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X164.21 Y157.79 E.31276
G1 X164.21 Y156.21 E.04706
G1 X176.29 Y156.21 E.35982
G1 X176.29 Y165.29 E.27046
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X174.71 Y165.29 E.04706
G1 X174.71 Y157.85 E.22161
; WIPE_START
G1 F9547.055
M204 S8000
G1 X172.71 Y157.839 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.5 Y157.194 Z4.6 F60000
G1 Z4.2
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.4484
G1 F1200
M204 S8000
G1 X175.483 Y157.114 E.00263
; LINE_WIDTH: 0.470635
G1 X175.467 Y157.033 E.00278
G1 X175.306 Y157 E.00556
; LINE_WIDTH: 0.43172
G1 X164.806 Y157 E.32248
; WIPE_START
G1 F9259.259
G1 X166.806 Y157 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X174.436 Y157.171 Z4.6 F60000
G1 X175.5 Y157.194 Z4.6
G1 Z4.2
G1 E.8 F1800
; LINE_WIDTH: 0.43173
G1 F1200
M204 S8000
G1 X175.5 Y164.694 E.23035
; CHANGE_LAYER
; Z_HEIGHT: 4.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.021
G1 X175.5 Y162.694 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 22/165
; update layer progress
M73 L22
M991 S0 P21 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z4.6 I1.214 J-.091 P1  F60000
G1 X175.102 Y157.398 Z4.6
G1 Z4.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X164.602 Y157.398 E.33764
G1 X164.602 Y156.602 E.02559
G1 X175.898 Y156.602 E.36323
G1 X175.898 Y164.898 E.26677
G1 X175.102 Y164.898 E.02559
G1 X175.102 Y157.458 E.23924
; COOLING_NODE: 0
M204 S250
G1 X174.71 Y157.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X164.21 Y157.79 E.31276
G1 X164.21 Y156.21 E.04706
G1 X176.29 Y156.21 E.35982
G1 X176.29 Y165.29 E.27046
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X174.71 Y165.29 E.04706
G1 X174.71 Y157.85 E.22161
; WIPE_START
G1 F9547.055
M204 S8000
M73 P31 R19
G1 X172.71 Y157.839 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.5 Y157.194 Z4.8 F60000
G1 Z4.4
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.4484
G1 F1200
M204 S8000
G1 X175.483 Y157.114 E.00263
; LINE_WIDTH: 0.470635
G1 X175.467 Y157.033 E.00278
G1 X175.306 Y157 E.00556
; LINE_WIDTH: 0.43172
G1 X164.806 Y157 E.32248
; WIPE_START
G1 F9259.259
G1 X166.806 Y157 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X174.436 Y157.171 Z4.8 F60000
G1 X175.5 Y157.194 Z4.8
G1 Z4.4
G1 E.8 F1800
; LINE_WIDTH: 0.43173
G1 F1200
M204 S8000
G1 X175.5 Y164.694 E.23035
; CHANGE_LAYER
; Z_HEIGHT: 4.6
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.021
G1 X175.5 Y162.694 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 23/165
; update layer progress
M73 L23
M991 S0 P22 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z4.8 I1.214 J-.091 P1  F60000
G1 X175.102 Y157.398 Z4.8
G1 Z4.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X164.602 Y157.398 E.33764
G1 X164.602 Y156.602 E.02559
G1 X175.898 Y156.602 E.36323
G1 X175.898 Y164.898 E.26677
G1 X175.102 Y164.898 E.02559
G1 X175.102 Y157.458 E.23924
; COOLING_NODE: 0
M204 S250
G1 X174.71 Y157.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X164.21 Y157.79 E.31276
G1 X164.21 Y156.21 E.04706
G1 X176.29 Y156.21 E.35982
G1 X176.29 Y165.29 E.27046
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X174.71 Y165.29 E.04706
G1 X174.71 Y157.85 E.22161
; WIPE_START
G1 F9547.055
M204 S8000
G1 X172.71 Y157.839 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.5 Y157.194 Z5 F60000
G1 Z4.6
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.4484
G1 F1200
M204 S8000
G1 X175.483 Y157.114 E.00263
; LINE_WIDTH: 0.470635
G1 X175.467 Y157.033 E.00278
G1 X175.306 Y157 E.00556
; LINE_WIDTH: 0.43172
G1 X164.806 Y157 E.32248
; WIPE_START
G1 F9259.259
G1 X166.806 Y157 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X174.436 Y157.171 Z5 F60000
G1 X175.5 Y157.194 Z5
G1 Z4.6
G1 E.8 F1800
; LINE_WIDTH: 0.43173
G1 F1200
M204 S8000
G1 X175.5 Y164.694 E.23035
; CHANGE_LAYER
; Z_HEIGHT: 4.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.021
G1 X175.5 Y162.694 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 24/165
; update layer progress
M73 L24
M991 S0 P23 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z5 I1.214 J-.091 P1  F60000
G1 X175.102 Y157.398 Z5
G1 Z4.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X164.602 Y157.398 E.33764
G1 X164.602 Y156.602 E.02559
G1 X175.898 Y156.602 E.36323
G1 X175.898 Y164.898 E.26677
G1 X175.102 Y164.898 E.02559
G1 X175.102 Y157.458 E.23924
; COOLING_NODE: 0
M204 S250
G1 X174.71 Y157.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X164.21 Y157.79 E.31276
G1 X164.21 Y156.21 E.04706
G1 X176.29 Y156.21 E.35982
G1 X176.29 Y165.29 E.27046
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X174.71 Y165.29 E.04706
G1 X174.71 Y157.85 E.22161
; WIPE_START
G1 F9547.055
M204 S8000
G1 X172.71 Y157.839 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.5 Y157.194 Z5.2 F60000
G1 Z4.8
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.4484
G1 F1200
M204 S8000
G1 X175.483 Y157.114 E.00263
; LINE_WIDTH: 0.470635
G1 X175.467 Y157.033 E.00278
G1 X175.306 Y157 E.00556
; LINE_WIDTH: 0.43172
G1 X164.806 Y157 E.32248
; WIPE_START
G1 F9259.259
G1 X166.806 Y157 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X174.436 Y157.171 Z5.2 F60000
G1 X175.5 Y157.194 Z5.2
G1 Z4.8
G1 E.8 F1800
; LINE_WIDTH: 0.43173
G1 F1200
M204 S8000
G1 X175.5 Y164.694 E.23035
; CHANGE_LAYER
; Z_HEIGHT: 5
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.021
G1 X175.5 Y162.694 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 25/165
; update layer progress
M73 L25
M991 S0 P24 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z5.2 I1.203 J-.185 P1  F60000
G1 X175.102 Y160.102 Z5.2
G1 Z5
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X175.102 Y157.398 E.08696
G1 X164.602 Y157.398 E.33764
G1 X164.602 Y156.602 E.02559
G1 X175.898 Y156.602 E.36323
G1 X175.898 Y164.898 E.26677
G1 X175.102 Y164.898 E.02559
G1 X175.102 Y164.498 E.01286
G1 X175.102 Y164.098 E.01286
G1 X175.102 Y163.698 E.01286
G1 X175.102 Y163.298 E.01286
G1 X175.102 Y162.898 E.01286
G1 X175.102 Y162.498 E.01286
G1 X175.102 Y162.098 E.01286
G1 X175.102 Y161.698 E.01286
G1 X175.102 Y161.298 E.01286
G1 X175.102 Y160.898 E.01286
G1 X174.682 Y160.898 E.01349
G1 F925.411
G1 X174.3 Y160.898 E.0123
; FEATURE: Overhang wall
G1 F600
M204 S5000
G1 X172.602 Y160.898 E.0546
G1 X172.602 Y160.102 E.02559
G1 X174.3 Y160.102 E.0546
; FEATURE: Inner wall
G1 F925.411
M204 S8000
G1 X174.682 Y160.102 E.0123
G1 F1200
G1 X175.042 Y160.102 E.01156
; COOLING_NODE: 0
M204 S250
G1 X174.71 Y159.71 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X174.71 Y157.79 E.05719
G1 X164.21 Y157.79 E.31276
G1 X164.21 Y156.21 E.04706
G1 X176.29 Y156.21 E.35982
G1 X176.29 Y165.29 E.27046
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X175.11 Y165.29 E.03515
G1 X174.71 Y165.29 E.01191
G1 X174.71 Y164.89 E.01191
M73 P32 R19
G1 X174.71 Y164.49 E.01191
G1 X174.71 Y164.09 E.01191
G1 X174.71 Y163.69 E.01191
G1 X174.71 Y163.29 E.01191
G1 X174.71 Y162.89 E.01191
G1 X174.71 Y162.49 E.01191
G1 X174.71 Y162.09 E.01191
G1 X174.71 Y161.69 E.01191
G1 X174.71 Y161.29 E.01191
G1 F951.503
G1 X174.669 Y161.29 E.00122
G1 F912.73
G1 X174.3 Y161.29 E.01099
; FEATURE: Overhang wall
; LINE_WIDTH: 0.45
G1 F600
G1 X172.21 Y161.29 E.06721
G1 X172.21 Y159.71 E.05081
G1 X174.3 Y159.71 E.06721
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F895.022
G1 X174.65 Y159.71 E.01043
; WIPE_START
M204 S8000
G1 X174.71 Y157.79 E-.72995
G1 X174.631 Y157.79 E-.03005
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.306 Y160.5 Z5.4 F60000
G1 Z5
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.43174
G1 F1200
M204 S8000
G1 X172.806 Y160.5 E.07679
; WIPE_START
G1 F9258.782
G1 X174.806 Y160.5 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z5.4 I-1.201 J.199 P1  F60000
G1 X175.5 Y164.694 Z5.4
G1 Z5
G1 E.8 F1800
; LINE_WIDTH: 0.43173
G1 F1200
M204 S8000
G1 X175.5 Y160.694 E.12285
; LINE_WIDTH: 0.456025
G1 X175.476 Y160.597 E.00327
; LINE_WIDTH: 0.490229
G1 X175.451 Y160.5 E.00354
G1 X175.306 Y160.5 E.00515
M204 S10000
G1 X175.451 Y160.5 F60000
; LINE_WIDTH: 0.504625
G1 F1200
M204 S8000
G1 X175.476 Y160.403 E.00365
; LINE_WIDTH: 0.432489
G1 X175.5 Y160.306 E.00308
G1 X175.5 Y157.194 E.09574
; LINE_WIDTH: 0.4484
G1 X175.483 Y157.114 E.00263
; LINE_WIDTH: 0.470635
G1 X175.467 Y157.033 E.00278
G1 X175.306 Y157 E.00556
; LINE_WIDTH: 0.43172
G1 X164.806 Y157 E.32248
; CHANGE_LAYER
; Z_HEIGHT: 5.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.259
G1 X166.806 Y157 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 26/165
; update layer progress
M73 L26
M991 S0 P25 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z5.4 I-.426 J1.14 P1  F60000
G1 X175.102 Y160.102 Z5.4
G1 Z5.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X175.102 Y157.398 E.08696
G1 X164.602 Y157.398 E.33764
G1 X164.602 Y156.602 E.02559
G1 X175.898 Y156.602 E.36323
G1 X175.898 Y164.898 E.26677
G1 X175.102 Y164.898 E.02559
G1 X175.102 Y160.898 E.12863
G1 X172.602 Y160.898 E.08039
G1 X172.602 Y160.102 E.02559
G1 X175.042 Y160.102 E.07846
; COOLING_NODE: 0
M204 S250
G1 X174.71 Y159.71 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X174.71 Y157.79 E.05719
G1 X164.21 Y157.79 E.31276
G1 X164.21 Y156.21 E.04706
G1 X176.29 Y156.21 E.35982
G1 X176.29 Y165.29 E.27046
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X174.71 Y165.29 E.04706
G1 X174.71 Y161.29 E.11915
G1 X172.21 Y161.29 E.07447
M73 P32 R18
G1 X172.21 Y159.71 E.04706
G1 X174.65 Y159.71 E.07268
; WIPE_START
G1 F9547.055
M204 S8000
G1 X174.71 Y157.79 E-.72995
G1 X174.631 Y157.79 E-.03005
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.306 Y160.5 Z5.6 F60000
G1 Z5.2
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.43174
G1 F1200
M204 S8000
G1 X172.806 Y160.5 E.07679
; WIPE_START
G1 F9258.782
G1 X174.806 Y160.5 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z5.6 I-1.201 J.199 P1  F60000
G1 X175.5 Y164.694 Z5.6
G1 Z5.2
G1 E.8 F1800
; LINE_WIDTH: 0.43173
G1 F1200
M204 S8000
G1 X175.5 Y160.694 E.12285
; LINE_WIDTH: 0.456025
G1 X175.476 Y160.597 E.00327
; LINE_WIDTH: 0.490229
G1 X175.451 Y160.5 E.00354
G1 X175.306 Y160.5 E.00515
M204 S10000
G1 X175.451 Y160.5 F60000
; LINE_WIDTH: 0.504625
G1 F1200
M204 S8000
G1 X175.476 Y160.403 E.00365
; LINE_WIDTH: 0.432489
G1 X175.5 Y160.306 E.00308
G1 X175.5 Y157.194 E.09574
; LINE_WIDTH: 0.4484
G1 X175.483 Y157.114 E.00263
; LINE_WIDTH: 0.470635
G1 X175.467 Y157.033 E.00278
G1 X175.306 Y157 E.00556
; LINE_WIDTH: 0.43172
G1 X164.806 Y157 E.32248
; CHANGE_LAYER
; Z_HEIGHT: 5.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.259
G1 X166.806 Y157 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 27/165
; update layer progress
M73 L27
M991 S0 P26 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z5.6 I-.426 J1.14 P1  F60000
G1 X175.102 Y160.102 Z5.6
G1 Z5.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X175.102 Y157.398 E.08696
G1 X164.602 Y157.398 E.33764
G1 X164.602 Y156.602 E.02559
G1 X175.898 Y156.602 E.36323
G1 X175.898 Y164.898 E.26677
G1 X175.102 Y164.898 E.02559
G1 X175.102 Y160.898 E.12863
G1 X172.602 Y160.898 E.08039
G1 X172.602 Y160.102 E.02559
G1 X175.042 Y160.102 E.07846
; COOLING_NODE: 0
M204 S250
G1 X174.71 Y159.71 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X174.71 Y157.79 E.05719
G1 X164.21 Y157.79 E.31276
G1 X164.21 Y156.21 E.04706
G1 X176.29 Y156.21 E.35982
G1 X176.29 Y165.29 E.27046
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X174.71 Y165.29 E.04706
G1 X174.71 Y161.29 E.11915
G1 X172.21 Y161.29 E.07447
G1 X172.21 Y159.71 E.04706
G1 X174.65 Y159.71 E.07268
; WIPE_START
G1 F9547.055
M204 S8000
G1 X174.71 Y157.79 E-.72995
G1 X174.631 Y157.79 E-.03005
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.306 Y160.5 Z5.8 F60000
G1 Z5.4
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.43174
G1 F1200
M204 S8000
G1 X172.806 Y160.5 E.07679
; WIPE_START
G1 F9258.782
G1 X174.806 Y160.5 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z5.8 I-1.201 J.199 P1  F60000
G1 X175.5 Y164.694 Z5.8
G1 Z5.4
G1 E.8 F1800
; LINE_WIDTH: 0.43173
G1 F1200
M204 S8000
G1 X175.5 Y160.694 E.12285
; LINE_WIDTH: 0.456025
G1 X175.476 Y160.597 E.00327
; LINE_WIDTH: 0.490229
G1 X175.451 Y160.5 E.00354
G1 X175.306 Y160.5 E.00515
M204 S10000
G1 X175.451 Y160.5 F60000
; LINE_WIDTH: 0.504625
G1 F1200
M204 S8000
G1 X175.476 Y160.403 E.00365
; LINE_WIDTH: 0.432489
G1 X175.5 Y160.306 E.00308
G1 X175.5 Y157.194 E.09574
; LINE_WIDTH: 0.4484
G1 X175.483 Y157.114 E.00263
; LINE_WIDTH: 0.470635
G1 X175.467 Y157.033 E.00278
G1 X175.306 Y157 E.00556
; LINE_WIDTH: 0.43172
G1 X164.806 Y157 E.32248
; CHANGE_LAYER
; Z_HEIGHT: 5.6
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.259
G1 X166.806 Y157 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 28/165
; update layer progress
M73 L28
M991 S0 P27 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z5.8 I-.426 J1.14 P1  F60000
G1 X175.102 Y160.102 Z5.8
G1 Z5.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X175.102 Y157.398 E.08696
G1 X164.602 Y157.398 E.33764
G1 X164.602 Y156.602 E.02559
G1 X175.898 Y156.602 E.36323
G1 X175.898 Y164.898 E.26677
G1 X175.102 Y164.898 E.02559
G1 X175.102 Y160.898 E.12863
M73 P33 R18
G1 X172.602 Y160.898 E.08039
G1 X172.602 Y160.102 E.02559
G1 X175.042 Y160.102 E.07846
; COOLING_NODE: 0
M204 S250
G1 X174.71 Y159.71 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X174.71 Y157.79 E.05719
G1 X164.21 Y157.79 E.31276
G1 X164.21 Y156.21 E.04706
G1 X176.29 Y156.21 E.35982
G1 X176.29 Y165.29 E.27046
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X174.71 Y165.29 E.04706
G1 X174.71 Y161.29 E.11915
G1 X172.21 Y161.29 E.07447
G1 X172.21 Y159.71 E.04706
G1 X174.65 Y159.71 E.07268
; WIPE_START
G1 F9547.055
M204 S8000
G1 X174.71 Y157.79 E-.72995
G1 X174.631 Y157.79 E-.03005
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.306 Y160.5 Z6 F60000
G1 Z5.6
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.43174
G1 F1200
M204 S8000
G1 X172.806 Y160.5 E.07679
; WIPE_START
G1 F9258.782
G1 X174.806 Y160.5 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.5 Y164.694 Z6 F60000
G1 Z5.6
G1 E.8 F1800
; LINE_WIDTH: 0.43173
G1 F1200
M204 S8000
G1 X175.5 Y160.694 E.12285
; LINE_WIDTH: 0.456025
G1 X175.476 Y160.597 E.00327
; LINE_WIDTH: 0.490229
G1 X175.451 Y160.5 E.00354
G1 X175.306 Y160.5 E.00515
M204 S10000
G1 X175.451 Y160.5 F60000
; LINE_WIDTH: 0.504625
G1 F1200
M204 S8000
G1 X175.476 Y160.403 E.00365
; LINE_WIDTH: 0.432489
G1 X175.5 Y160.306 E.00308
G1 X175.5 Y157.194 E.09574
; LINE_WIDTH: 0.4484
G1 X175.483 Y157.114 E.00263
; LINE_WIDTH: 0.470635
G1 X175.467 Y157.033 E.00278
G1 X175.306 Y157 E.00556
; LINE_WIDTH: 0.43172
G1 X164.806 Y157 E.32248
; CHANGE_LAYER
; Z_HEIGHT: 5.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.259
G1 X166.806 Y157 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 29/165
; update layer progress
M73 L29
M991 S0 P28 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z6 I-.426 J1.14 P1  F60000
G1 X175.102 Y160.102 Z6
G1 Z5.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X175.102 Y157.398 E.08696
G1 X164.602 Y157.398 E.33764
G1 X164.602 Y156.602 E.02559
G1 X175.898 Y156.602 E.36323
G1 X175.898 Y164.898 E.26677
G1 X175.102 Y164.898 E.02559
G1 X175.102 Y160.898 E.12863
G1 X172.602 Y160.898 E.08039
G1 X172.602 Y160.102 E.02559
G1 X175.042 Y160.102 E.07846
; COOLING_NODE: 0
M204 S250
G1 X174.71 Y159.71 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X174.71 Y157.79 E.05719
G1 X164.21 Y157.79 E.31276
G1 X164.21 Y156.21 E.04706
G1 X176.29 Y156.21 E.35982
G1 X176.29 Y165.29 E.27046
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X174.71 Y165.29 E.04706
G1 X174.71 Y161.29 E.11915
G1 X172.21 Y161.29 E.07447
G1 X172.21 Y159.71 E.04706
G1 X174.65 Y159.71 E.07268
; WIPE_START
G1 F9547.055
M204 S8000
G1 X174.71 Y157.79 E-.72995
G1 X174.631 Y157.79 E-.03005
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.306 Y160.5 Z6.2 F60000
G1 Z5.8
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.43174
G1 F1200
M204 S8000
G1 X172.806 Y160.5 E.07679
; WIPE_START
G1 F9258.782
G1 X174.806 Y160.5 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.5 Y164.694 Z6.2 F60000
G1 Z5.8
G1 E.8 F1800
; LINE_WIDTH: 0.43173
G1 F1200
M204 S8000
G1 X175.5 Y160.694 E.12285
; LINE_WIDTH: 0.456025
G1 X175.476 Y160.597 E.00327
; LINE_WIDTH: 0.490229
G1 X175.451 Y160.5 E.00354
G1 X175.306 Y160.5 E.00515
M204 S10000
G1 X175.451 Y160.5 F60000
; LINE_WIDTH: 0.504625
G1 F1200
M204 S8000
G1 X175.476 Y160.403 E.00365
; LINE_WIDTH: 0.432489
G1 X175.5 Y160.306 E.00308
G1 X175.5 Y157.194 E.09574
; LINE_WIDTH: 0.4484
G1 X175.483 Y157.114 E.00263
; LINE_WIDTH: 0.470635
G1 X175.467 Y157.033 E.00278
G1 X175.306 Y157 E.00556
; LINE_WIDTH: 0.43172
G1 X164.806 Y157 E.32248
; CHANGE_LAYER
; Z_HEIGHT: 6
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.259
G1 X166.806 Y157 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 30/165
; update layer progress
M73 L30
M991 S0 P29 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z6.2 I-.426 J1.14 P1  F60000
G1 X175.102 Y160.102 Z6.2
G1 Z6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X175.102 Y157.398 E.08696
G1 X164.602 Y157.398 E.33764
G1 X164.602 Y156.602 E.02559
G1 X175.898 Y156.602 E.36323
G1 X175.898 Y164.898 E.26677
G1 X175.102 Y164.898 E.02559
G1 X175.102 Y160.898 E.12863
G1 X172.602 Y160.898 E.08039
G1 X172.602 Y160.102 E.02559
G1 X175.042 Y160.102 E.07846
; COOLING_NODE: 0
M204 S250
G1 X174.71 Y159.71 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X174.71 Y157.79 E.05719
G1 X164.21 Y157.79 E.31276
G1 X164.21 Y156.21 E.04706
G1 X176.29 Y156.21 E.35982
G1 X176.29 Y165.29 E.27046
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X174.71 Y165.29 E.04706
G1 X174.71 Y161.29 E.11915
G1 X172.21 Y161.29 E.07447
G1 X172.21 Y159.71 E.04706
G1 X174.65 Y159.71 E.07268
; WIPE_START
G1 F9547.055
M204 S8000
G1 X174.71 Y157.79 E-.72995
G1 X174.631 Y157.79 E-.03005
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.306 Y160.5 Z6.4 F60000
G1 Z6
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.43174
G1 F1200
M204 S8000
G1 X172.806 Y160.5 E.07679
; WIPE_START
G1 F9258.782
G1 X174.806 Y160.5 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.5 Y164.694 Z6.4 F60000
G1 Z6
G1 E.8 F1800
; LINE_WIDTH: 0.43173
G1 F1200
M204 S8000
G1 X175.5 Y160.694 E.12285
; LINE_WIDTH: 0.456025
G1 X175.476 Y160.597 E.00327
; LINE_WIDTH: 0.490229
G1 X175.451 Y160.5 E.00354
G1 X175.306 Y160.5 E.00515
M204 S10000
G1 X175.451 Y160.5 F60000
; LINE_WIDTH: 0.504625
G1 F1200
M204 S8000
G1 X175.476 Y160.403 E.00365
; LINE_WIDTH: 0.432489
G1 X175.5 Y160.306 E.00308
G1 X175.5 Y157.194 E.09574
; LINE_WIDTH: 0.4484
G1 X175.483 Y157.114 E.00263
; LINE_WIDTH: 0.470635
G1 X175.467 Y157.033 E.00278
G1 X175.306 Y157 E.00556
; LINE_WIDTH: 0.43172
G1 X164.806 Y157 E.32248
; CHANGE_LAYER
; Z_HEIGHT: 6.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.259
G1 X166.806 Y157 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 31/165
; update layer progress
M73 L31
M991 S0 P30 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
M73 P34 R18
G3 Z6.4 I-.426 J1.14 P1  F60000
G1 X175.102 Y160.102 Z6.4
G1 Z6.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X175.102 Y157.398 E.08696
G1 X164.602 Y157.398 E.33764
G1 X164.602 Y156.602 E.02559
G1 X175.898 Y156.602 E.36323
G1 X175.898 Y164.898 E.26677
G1 X175.102 Y164.898 E.02559
G1 X175.102 Y160.898 E.12863
G1 X172.602 Y160.898 E.08039
G1 X172.602 Y160.102 E.02559
G1 X175.042 Y160.102 E.07846
; COOLING_NODE: 0
M204 S250
G1 X174.71 Y159.71 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X174.71 Y157.79 E.05719
G1 X164.21 Y157.79 E.31276
G1 X164.21 Y156.21 E.04706
G1 X176.29 Y156.21 E.35982
G1 X176.29 Y165.29 E.27046
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X174.71 Y165.29 E.04706
G1 X174.71 Y161.29 E.11915
G1 X172.21 Y161.29 E.07447
G1 X172.21 Y159.71 E.04706
G1 X174.65 Y159.71 E.07268
; WIPE_START
G1 F9547.055
M204 S8000
G1 X174.71 Y157.79 E-.72995
G1 X174.631 Y157.79 E-.03005
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.306 Y160.5 Z6.6 F60000
G1 Z6.2
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.43174
G1 F1200
M204 S8000
G1 X172.806 Y160.5 E.07679
; WIPE_START
G1 F9258.782
G1 X174.806 Y160.5 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.5 Y164.694 Z6.6 F60000
G1 Z6.2
G1 E.8 F1800
; LINE_WIDTH: 0.43173
G1 F1200
M204 S8000
G1 X175.5 Y160.694 E.12285
; LINE_WIDTH: 0.456025
G1 X175.476 Y160.597 E.00327
; LINE_WIDTH: 0.490229
G1 X175.451 Y160.5 E.00354
G1 X175.306 Y160.5 E.00515
M204 S10000
G1 X175.451 Y160.5 F60000
; LINE_WIDTH: 0.504625
G1 F1200
M204 S8000
G1 X175.476 Y160.403 E.00365
; LINE_WIDTH: 0.432489
G1 X175.5 Y160.306 E.00308
G1 X175.5 Y157.194 E.09574
; LINE_WIDTH: 0.4484
G1 X175.483 Y157.114 E.00263
; LINE_WIDTH: 0.470635
G1 X175.467 Y157.033 E.00278
G1 X175.306 Y157 E.00556
; LINE_WIDTH: 0.43172
G1 X164.806 Y157 E.32248
; CHANGE_LAYER
; Z_HEIGHT: 6.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.259
G1 X166.806 Y157 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 32/165
; update layer progress
M73 L32
M991 S0 P31 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z6.6 I-.426 J1.14 P1  F60000
G1 X175.102 Y160.102 Z6.6
G1 Z6.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X175.102 Y157.398 E.08696
G1 X164.602 Y157.398 E.33764
G1 X164.602 Y156.602 E.02559
G1 X175.898 Y156.602 E.36323
G1 X175.898 Y164.898 E.26677
G1 X175.102 Y164.898 E.02559
G1 X175.102 Y160.898 E.12863
G1 X172.602 Y160.898 E.08039
G1 X172.602 Y160.102 E.02559
G1 X175.042 Y160.102 E.07846
; COOLING_NODE: 0
M204 S250
G1 X174.71 Y159.71 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X174.71 Y157.79 E.05719
G1 X164.21 Y157.79 E.31276
G1 X164.21 Y156.21 E.04706
G1 X176.29 Y156.21 E.35982
G1 X176.29 Y165.29 E.27046
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X174.71 Y165.29 E.04706
G1 X174.71 Y161.29 E.11915
G1 X172.21 Y161.29 E.07447
G1 X172.21 Y159.71 E.04706
G1 X174.65 Y159.71 E.07268
; WIPE_START
G1 F9547.055
M204 S8000
G1 X174.71 Y157.79 E-.72995
G1 X174.631 Y157.79 E-.03005
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.306 Y160.5 Z6.8 F60000
G1 Z6.4
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.43174
G1 F1200
M204 S8000
G1 X172.806 Y160.5 E.07679
; WIPE_START
G1 F9258.782
G1 X174.806 Y160.5 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.5 Y164.694 Z6.8 F60000
G1 Z6.4
G1 E.8 F1800
; LINE_WIDTH: 0.43173
G1 F1200
M204 S8000
G1 X175.5 Y160.694 E.12285
; LINE_WIDTH: 0.456025
G1 X175.476 Y160.597 E.00327
; LINE_WIDTH: 0.490229
G1 X175.451 Y160.5 E.00354
G1 X175.306 Y160.5 E.00515
M204 S10000
G1 X175.451 Y160.5 F60000
; LINE_WIDTH: 0.504625
G1 F1200
M204 S8000
G1 X175.476 Y160.403 E.00365
; LINE_WIDTH: 0.432489
G1 X175.5 Y160.306 E.00308
G1 X175.5 Y157.194 E.09574
; LINE_WIDTH: 0.4484
G1 X175.483 Y157.114 E.00263
; LINE_WIDTH: 0.470635
G1 X175.467 Y157.033 E.00278
G1 X175.306 Y157 E.00556
; LINE_WIDTH: 0.43172
G1 X164.806 Y157 E.32248
; CHANGE_LAYER
; Z_HEIGHT: 6.6
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.259
G1 X166.806 Y157 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 33/165
; update layer progress
M73 L33
M991 S0 P32 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z6.8 I-.426 J1.14 P1  F60000
G1 X175.102 Y160.102 Z6.8
G1 Z6.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X175.102 Y157.398 E.08696
G1 X164.602 Y157.398 E.33764
G1 X164.602 Y156.602 E.02559
G1 X175.898 Y156.602 E.36323
G1 X175.898 Y164.898 E.26677
G1 X175.102 Y164.898 E.02559
G1 X175.102 Y160.898 E.12863
G1 X172.602 Y160.898 E.08039
G1 X172.602 Y160.102 E.02559
G1 X175.042 Y160.102 E.07846
; COOLING_NODE: 0
M204 S250
G1 X174.71 Y159.71 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X174.71 Y157.79 E.05719
G1 X164.21 Y157.79 E.31276
G1 X164.21 Y156.21 E.04706
G1 X176.29 Y156.21 E.35982
G1 X176.29 Y165.29 E.27046
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X174.71 Y165.29 E.04706
G1 X174.71 Y161.29 E.11915
G1 X172.21 Y161.29 E.07447
M73 P35 R18
G1 X172.21 Y159.71 E.04706
G1 X174.65 Y159.71 E.07268
; WIPE_START
G1 F9547.055
M204 S8000
G1 X174.71 Y157.79 E-.72995
G1 X174.631 Y157.79 E-.03005
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.306 Y160.5 Z7 F60000
G1 Z6.6
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.43174
G1 F1200
M204 S8000
G1 X172.806 Y160.5 E.07679
; WIPE_START
G1 F9258.782
G1 X174.806 Y160.5 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.5 Y164.694 Z7 F60000
G1 Z6.6
G1 E.8 F1800
; LINE_WIDTH: 0.43173
G1 F1200
M204 S8000
G1 X175.5 Y160.694 E.12285
; LINE_WIDTH: 0.456025
G1 X175.476 Y160.597 E.00327
; LINE_WIDTH: 0.490229
G1 X175.451 Y160.5 E.00354
G1 X175.306 Y160.5 E.00515
M204 S10000
G1 X175.451 Y160.5 F60000
; LINE_WIDTH: 0.504625
G1 F1200
M204 S8000
G1 X175.476 Y160.403 E.00365
; LINE_WIDTH: 0.432489
G1 X175.5 Y160.306 E.00308
G1 X175.5 Y157.194 E.09574
; LINE_WIDTH: 0.4484
G1 X175.483 Y157.114 E.00263
; LINE_WIDTH: 0.470635
G1 X175.467 Y157.033 E.00278
G1 X175.306 Y157 E.00556
; LINE_WIDTH: 0.43172
G1 X164.806 Y157 E.32248
; CHANGE_LAYER
; Z_HEIGHT: 6.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.259
G1 X166.806 Y157 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 34/165
; update layer progress
M73 L34
M991 S0 P33 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z7 I-.093 J1.213 P1  F60000
G1 X175.898 Y157.694 Z7
G1 Z6.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X175.102 Y157.694 E.02559
G1 X175.102 Y157.398 E.00951
G1 X164.602 Y157.398 E.33764
G1 X164.602 Y156.602 E.02559
G1 X175.898 Y156.602 E.36323
G1 X175.898 Y157.634 E.03317
; COOLING_NODE: 0
; WIPE_START
G1 F8843.478
G1 X175.102 Y157.694 E-.30329
G1 X175.102 Y157.398 E-.11237
G1 X174.196 Y157.398 E-.34434
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.898 Y163.328 Z7.2 F60000
G1 Z6.8
G1 E.8 F1800
G1 F1200
M204 S8000
G1 X175.898 Y164.898 E.0505
G1 X175.102 Y164.898 E.02559
G1 X175.102 Y163.306 E.05118
G1 X175.859 Y163.306 E.02435
; COOLING_NODE: 0
; WIPE_START
G1 F8843.478
G1 X175.898 Y164.898 E-.60498
G1 X175.49 Y164.898 E-.15502
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X174.71 Y159.71 Z7.2 F60000
G1 Z6.8
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X174.71 Y157.79 E.05719
G1 X164.21 Y157.79 E.31276
G1 X164.21 Y156.21 E.04706
G1 X176.29 Y156.21 E.35982
G1 X176.29 Y165.29 E.27046
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X174.71 Y165.29 E.04706
G1 X174.71 Y161.29 E.11915
G1 X172.21 Y161.29 E.07447
G1 X172.21 Y159.71 E.04706
G1 X174.65 Y159.71 E.07268
; WIPE_START
G1 F9547.055
M204 S8000
G1 X174.71 Y157.79 E-.72995
G1 X174.631 Y157.79 E-.03005
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.982 Y157.89 Z7.2 F60000
G1 Z6.8
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.26667
G1 F1200
M204 S8000
G1 X175.982 Y163.11 E.09227
; WIPE_START
G1 F15000
G1 X175.982 Y161.11 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.5 Y164.694 Z7.2 F60000
G1 Z6.8
G1 E.8 F1800
; LINE_WIDTH: 0.43173
G1 F1200
M204 S8000
G1 X175.5 Y163.51 E.03638
M204 S10000
G1 X175.382 Y163.084 F60000
; FEATURE: Top surface
; LINE_WIDTH: 0.42
G1 F1200
M204 S2000
G1 X175.844 Y162.622 E.01944
G1 X175.977 Y162.489
G1 X175.977 Y161.955
G1 X175.844 Y162.089
G1 X174.917 Y163.015 E.03902
G1 X174.784 Y163.149
G1 X174.784 Y162.616
G1 X174.917 Y162.482
G1 X175.844 Y161.556 E.03902
G1 X175.977 Y161.422
G1 X175.977 Y160.889
G1 X175.844 Y161.023
G1 X174.917 Y161.949 E.03902
G1 X174.784 Y162.083
G1 X174.784 Y161.549
G1 X174.917 Y161.416
G1 X175.844 Y160.489 E.03902
G1 X175.977 Y160.356
G1 X175.977 Y159.822
G1 X175.844 Y159.956
G1 X174.717 Y161.083 E.04746
G1 X174.584 Y161.216
G1 X174.05 Y161.216
G1 X174.184 Y161.083
G1 X175.844 Y159.423 E.06992
G1 X175.977 Y159.289
G1 X175.977 Y158.756
G1 X175.844 Y158.89
G1 X174.917 Y159.816 E.03902
G1 X174.784 Y159.95
G1 X174.784 Y159.416
G1 X174.917 Y159.283
G1 X175.844 Y158.356 E.03902
G1 X175.977 Y158.223
G1 X175.868 Y157.799
G1 X175.734 Y157.933
G1 X174.917 Y158.749 E.0344
G1 X174.784 Y158.883
G1 X174.95 Y159.784
G1 X174.816 Y159.917
G1 X173.651 Y161.083 E.04909
G1 X173.517 Y161.216
G1 X172.984 Y161.216
G1 X173.117 Y161.083
G1 X174.283 Y159.917 E.04909
G1 X174.416 Y159.784
G1 X173.883 Y159.784
G1 X173.749 Y159.917
G1 X172.584 Y161.083 E.04909
G1 X172.451 Y161.216
G1 X172.284 Y160.85
G1 X172.417 Y160.716
G1 X173.216 Y159.917 E.03365
; WIPE_START
G1 F9547.055
M204 S8000
G1 X172.417 Y160.716 E-.42926
G1 X172.284 Y160.85 E-.07182
G1 X172.451 Y161.216 E-.153
G1 X172.584 Y161.083 E-.07182
G1 X172.648 Y161.019 E-.0341
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.5 Y157.49 Z7.2 F60000
G1 Z6.8
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.43174
G1 F1200
M204 S8000
G1 X175.5 Y157.194 E.00908
; LINE_WIDTH: 0.448415
G1 X175.483 Y157.114 E.00263
; LINE_WIDTH: 0.470641
G1 X175.467 Y157.033 E.00278
G1 X175.306 Y157 E.00556
; LINE_WIDTH: 0.43172
G1 X164.806 Y157 E.32248
; CHANGE_LAYER
; Z_HEIGHT: 7
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.259
G1 X166.806 Y157 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 35/165
; update layer progress
M73 L35
M991 S0 P34 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z7.2 I-.058 J1.216 P1  F60000
G1 X175.102 Y157.398 Z7.2
G1 Z7
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X164.602 Y157.398 E.33764
G1 X164.602 Y156.602 E.02559
G1 X175.898 Y156.602 E.36323
G1 X175.898 Y164.898 E.26677
G1 X175.102 Y164.898 E.02559
G1 X175.102 Y157.458 E.23924
; COOLING_NODE: 0
M204 S250
G1 X174.71 Y157.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X164.21 Y157.79 E.31276
G1 X164.21 Y156.21 E.04706
G1 X176.29 Y156.21 E.35982
G1 X176.29 Y165.29 E.27046
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X174.71 Y165.29 E.04706
G1 X174.71 Y157.85 E.22161
; WIPE_START
G1 F9547.055
M204 S8000
G1 X172.71 Y157.839 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.5 Y157.194 Z7.4 F60000
G1 Z7
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.4484
G1 F1200
M204 S8000
G1 X175.483 Y157.114 E.00263
; LINE_WIDTH: 0.470635
G1 X175.467 Y157.033 E.00278
G1 X175.306 Y157 E.00556
; LINE_WIDTH: 0.43172
G1 X164.806 Y157 E.32248
; WIPE_START
G1 F9259.259
G1 X166.806 Y157 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X174.436 Y157.171 Z7.4 F60000
G1 X175.5 Y157.194 Z7.4
G1 Z7
G1 E.8 F1800
; LINE_WIDTH: 0.43173
G1 F1200
M204 S8000
G1 X175.5 Y164.694 E.23035
; CHANGE_LAYER
; Z_HEIGHT: 7.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.021
G1 X175.5 Y162.694 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 36/165
; update layer progress
M73 L36
M991 S0 P35 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z7.4 I1.214 J-.091 P1  F60000
G1 X175.102 Y157.398 Z7.4
G1 Z7.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X164.602 Y157.398 E.33764
G1 X164.602 Y156.602 E.02559
G1 X175.898 Y156.602 E.36323
G1 X175.898 Y164.898 E.26677
G1 X175.102 Y164.898 E.02559
G1 X175.102 Y157.458 E.23924
; COOLING_NODE: 0
M204 S250
M73 P35 R17
G1 X174.71 Y157.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
M73 P36 R17
G1 F1200
M204 S5000
G1 X164.21 Y157.79 E.31276
G1 X164.21 Y156.21 E.04706
G1 X176.29 Y156.21 E.35982
G1 X176.29 Y165.29 E.27046
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X174.71 Y165.29 E.04706
G1 X174.71 Y157.85 E.22161
; WIPE_START
G1 F9547.055
M204 S8000
G1 X172.71 Y157.839 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.5 Y157.194 Z7.6 F60000
G1 Z7.2
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.4484
G1 F1200
M204 S8000
G1 X175.483 Y157.114 E.00263
; LINE_WIDTH: 0.470635
G1 X175.467 Y157.033 E.00278
G1 X175.306 Y157 E.00556
; LINE_WIDTH: 0.43172
G1 X164.806 Y157 E.32248
; WIPE_START
G1 F9259.259
G1 X166.806 Y157 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X174.436 Y157.171 Z7.6 F60000
G1 X175.5 Y157.194 Z7.6
G1 Z7.2
G1 E.8 F1800
; LINE_WIDTH: 0.43173
G1 F1200
M204 S8000
G1 X175.5 Y164.694 E.23035
; CHANGE_LAYER
; Z_HEIGHT: 7.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.021
G1 X175.5 Y162.694 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 37/165
; update layer progress
M73 L37
M991 S0 P36 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z7.6 I1.214 J-.091 P1  F60000
G1 X175.102 Y157.398 Z7.6
G1 Z7.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X164.602 Y157.398 E.33764
G1 X164.602 Y156.602 E.02559
G1 X175.898 Y156.602 E.36323
G1 X175.898 Y164.898 E.26677
G1 X175.102 Y164.898 E.02559
G1 X175.102 Y157.458 E.23924
; COOLING_NODE: 0
M204 S250
G1 X174.71 Y157.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X164.21 Y157.79 E.31276
G1 X164.21 Y156.21 E.04706
G1 X176.29 Y156.21 E.35982
G1 X176.29 Y165.29 E.27046
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X174.71 Y165.29 E.04706
G1 X174.71 Y157.85 E.22161
; WIPE_START
G1 F9547.055
M204 S8000
G1 X172.71 Y157.839 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.5 Y157.194 Z7.8 F60000
G1 Z7.4
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.4484
G1 F1200
M204 S8000
G1 X175.483 Y157.114 E.00263
; LINE_WIDTH: 0.470635
G1 X175.467 Y157.033 E.00278
G1 X175.306 Y157 E.00556
; LINE_WIDTH: 0.43172
G1 X164.806 Y157 E.32248
; WIPE_START
G1 F9259.259
G1 X166.806 Y157 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X174.436 Y157.171 Z7.8 F60000
G1 X175.5 Y157.194 Z7.8
G1 Z7.4
G1 E.8 F1800
; LINE_WIDTH: 0.43173
G1 F1200
M204 S8000
G1 X175.5 Y164.694 E.23035
; CHANGE_LAYER
; Z_HEIGHT: 7.6
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.021
G1 X175.5 Y162.694 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 38/165
; update layer progress
M73 L38
M991 S0 P37 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z7.8 I1.214 J-.091 P1  F60000
G1 X175.102 Y157.398 Z7.8
G1 Z7.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X164.602 Y157.398 E.33764
G1 X164.602 Y156.602 E.02559
G1 X175.898 Y156.602 E.36323
G1 X175.898 Y164.898 E.26677
G1 X175.102 Y164.898 E.02559
G1 X175.102 Y157.458 E.23924
; COOLING_NODE: 0
M204 S250
G1 X174.71 Y157.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X164.21 Y157.79 E.31276
G1 X164.21 Y156.21 E.04706
G1 X176.29 Y156.21 E.35982
G1 X176.29 Y165.29 E.27046
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X174.71 Y165.29 E.04706
G1 X174.71 Y157.85 E.22161
; WIPE_START
G1 F9547.055
M204 S8000
G1 X172.71 Y157.839 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.5 Y157.194 Z8 F60000
G1 Z7.6
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.4484
G1 F1200
M204 S8000
G1 X175.483 Y157.114 E.00263
; LINE_WIDTH: 0.470635
G1 X175.467 Y157.033 E.00278
G1 X175.306 Y157 E.00556
; LINE_WIDTH: 0.43172
G1 X164.806 Y157 E.32248
; WIPE_START
G1 F9259.259
G1 X166.806 Y157 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X174.436 Y157.171 Z8 F60000
G1 X175.5 Y157.194 Z8
G1 Z7.6
G1 E.8 F1800
; LINE_WIDTH: 0.43173
G1 F1200
M204 S8000
G1 X175.5 Y164.694 E.23035
; CHANGE_LAYER
; Z_HEIGHT: 7.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.021
G1 X175.5 Y162.694 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 39/165
; update layer progress
M73 L39
M991 S0 P38 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z8 I1.214 J-.091 P1  F60000
G1 X175.102 Y157.398 Z8
G1 Z7.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X164.602 Y157.398 E.33764
G1 X164.602 Y156.602 E.02559
G1 X175.898 Y156.602 E.36323
G1 X175.898 Y164.898 E.26677
G1 X175.102 Y164.898 E.02559
G1 X175.102 Y157.458 E.23924
; COOLING_NODE: 0
M204 S250
G1 X174.71 Y157.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
M73 P37 R17
G1 F1200
M204 S5000
G1 X164.21 Y157.79 E.31276
G1 X164.21 Y156.21 E.04706
G1 X176.29 Y156.21 E.35982
G1 X176.29 Y165.29 E.27046
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X174.71 Y165.29 E.04706
G1 X174.71 Y157.85 E.22161
; WIPE_START
G1 F9547.055
M204 S8000
G1 X172.71 Y157.839 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.5 Y157.194 Z8.2 F60000
G1 Z7.8
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.4484
G1 F1200
M204 S8000
G1 X175.483 Y157.114 E.00263
; LINE_WIDTH: 0.470635
G1 X175.467 Y157.033 E.00278
G1 X175.306 Y157 E.00556
; LINE_WIDTH: 0.43172
G1 X164.806 Y157 E.32248
; WIPE_START
G1 F9259.259
G1 X166.806 Y157 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X174.436 Y157.171 Z8.2 F60000
G1 X175.5 Y157.194 Z8.2
G1 Z7.8
G1 E.8 F1800
; LINE_WIDTH: 0.43173
G1 F1200
M204 S8000
G1 X175.5 Y164.694 E.23035
; CHANGE_LAYER
; Z_HEIGHT: 8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.021
G1 X175.5 Y162.694 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 40/165
; update layer progress
M73 L40
M991 S0 P39 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z8.2 I1.214 J-.091 P1  F60000
G1 X175.102 Y157.398 Z8.2
G1 Z8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X164.602 Y157.398 E.33764
G1 X164.602 Y156.602 E.02559
G1 X175.898 Y156.602 E.36323
G1 X175.898 Y164.898 E.26677
G1 X175.102 Y164.898 E.02559
G1 X175.102 Y157.458 E.23924
; COOLING_NODE: 0
M204 S250
G1 X174.71 Y157.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X164.21 Y157.79 E.31276
G1 X164.21 Y156.21 E.04706
G1 X176.29 Y156.21 E.35982
G1 X176.29 Y165.29 E.27046
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X174.71 Y165.29 E.04706
G1 X174.71 Y157.85 E.22161
; WIPE_START
G1 F9547.055
M204 S8000
G1 X172.71 Y157.839 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.5 Y157.194 Z8.4 F60000
G1 Z8
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.4484
G1 F1200
M204 S8000
G1 X175.483 Y157.114 E.00263
; LINE_WIDTH: 0.470635
G1 X175.467 Y157.033 E.00278
G1 X175.306 Y157 E.00556
; LINE_WIDTH: 0.43172
G1 X164.806 Y157 E.32248
; WIPE_START
G1 F9259.259
G1 X166.806 Y157 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X174.436 Y157.171 Z8.4 F60000
G1 X175.5 Y157.194 Z8.4
G1 Z8
G1 E.8 F1800
; LINE_WIDTH: 0.43173
G1 F1200
M204 S8000
G1 X175.5 Y164.694 E.23035
; CHANGE_LAYER
; Z_HEIGHT: 8.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.021
G1 X175.5 Y162.694 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 41/165
; update layer progress
M73 L41
M991 S0 P40 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z8.4 I1.214 J-.091 P1  F60000
G1 X175.102 Y157.398 Z8.4
G1 Z8.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X164.602 Y157.398 E.33764
G1 X164.602 Y156.602 E.02559
G1 X175.898 Y156.602 E.36323
G1 X175.898 Y164.898 E.26677
G1 X175.102 Y164.898 E.02559
G1 X175.102 Y157.458 E.23924
; COOLING_NODE: 0
M204 S250
G1 X174.71 Y157.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X164.21 Y157.79 E.31276
G1 X164.21 Y156.21 E.04706
G1 X176.29 Y156.21 E.35982
G1 X176.29 Y165.29 E.27046
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X174.71 Y165.29 E.04706
G1 X174.71 Y157.85 E.22161
; WIPE_START
G1 F9547.055
M204 S8000
G1 X172.71 Y157.839 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.5 Y157.194 Z8.6 F60000
G1 Z8.2
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.4484
G1 F1200
M204 S8000
G1 X175.483 Y157.114 E.00263
; LINE_WIDTH: 0.470635
G1 X175.467 Y157.033 E.00278
G1 X175.306 Y157 E.00556
; LINE_WIDTH: 0.43172
G1 X164.806 Y157 E.32248
; WIPE_START
G1 F9259.259
G1 X166.806 Y157 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X174.436 Y157.171 Z8.6 F60000
G1 X175.5 Y157.194 Z8.6
G1 Z8.2
G1 E.8 F1800
; LINE_WIDTH: 0.43173
G1 F1200
M204 S8000
G1 X175.5 Y164.694 E.23035
; CHANGE_LAYER
; Z_HEIGHT: 8.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.021
G1 X175.5 Y162.694 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 42/165
; update layer progress
M73 L42
M991 S0 P41 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z8.6 I1.214 J-.091 P1  F60000
G1 X175.102 Y157.398 Z8.6
G1 Z8.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X164.602 Y157.398 E.33764
G1 X164.602 Y156.602 E.02559
G1 X175.898 Y156.602 E.36323
G1 X175.898 Y164.898 E.26677
G1 X175.102 Y164.898 E.02559
G1 X175.102 Y157.458 E.23924
; COOLING_NODE: 0
M204 S250
G1 X174.71 Y157.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X164.21 Y157.79 E.31276
M73 P38 R17
G1 X164.21 Y156.21 E.04706
G1 X176.29 Y156.21 E.35982
G1 X176.29 Y165.29 E.27046
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X174.71 Y165.29 E.04706
G1 X174.71 Y157.85 E.22161
; WIPE_START
G1 F9547.055
M204 S8000
G1 X172.71 Y157.839 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.5 Y157.194 Z8.8 F60000
G1 Z8.4
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.4484
G1 F1200
M204 S8000
G1 X175.483 Y157.114 E.00263
; LINE_WIDTH: 0.470635
G1 X175.467 Y157.033 E.00278
G1 X175.306 Y157 E.00556
; LINE_WIDTH: 0.43172
G1 X164.806 Y157 E.32248
; WIPE_START
G1 F9259.259
G1 X166.806 Y157 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X174.436 Y157.171 Z8.8 F60000
G1 X175.5 Y157.194 Z8.8
G1 Z8.4
G1 E.8 F1800
; LINE_WIDTH: 0.43173
G1 F1200
M204 S8000
G1 X175.5 Y164.694 E.23035
; CHANGE_LAYER
; Z_HEIGHT: 8.6
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F9259.021
G1 X175.5 Y162.694 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 43/165
; update layer progress
M73 L43
M991 S0 P42 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z8.8 I1.214 J-.091 P1  F60000
G1 X175.102 Y157.398 Z8.8
G1 Z8.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X164.602 Y157.398 E.33764
G1 X164.602 Y156.602 E.02559
G1 X175.898 Y156.602 E.36323
G1 X175.898 Y164.898 E.26677
G1 X175.102 Y164.898 E.02559
G1 X175.102 Y157.458 E.23924
; COOLING_NODE: 0
M204 S250
G1 X174.71 Y157.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X164.21 Y157.79 E.31276
G1 X164.21 Y156.21 E.04706
G1 X176.29 Y156.21 E.35982
G1 X176.29 Y165.29 E.27046
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X174.71 Y165.29 E.04706
G1 X174.71 Y157.85 E.22161
; WIPE_START
G1 F9547.055
M204 S8000
G1 X172.71 Y157.839 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.5 Y157.194 Z9 F60000
G1 Z8.6
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.4484
G1 F1200
M204 S8000
G1 X175.483 Y157.114 E.00263
; LINE_WIDTH: 0.470635
G1 X175.467 Y157.033 E.00278
G1 X175.306 Y157 E.00556
; LINE_WIDTH: 0.43172
G1 X164.806 Y157 E.32248
; WIPE_START
G1 F9259.259
G1 X166.806 Y157 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X174.436 Y157.171 Z9 F60000
G1 X175.5 Y157.194 Z9
G1 Z8.6
G1 E.8 F1800
; LINE_WIDTH: 0.43173
G1 F1200
M204 S8000
G1 X175.5 Y164.694 E.23035
; CHANGE_LAYER
; Z_HEIGHT: 8.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.021
G1 X175.5 Y162.694 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 44/165
; update layer progress
M73 L44
M991 S0 P43 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z9 I1.214 J-.091 P1  F60000
G1 X175.102 Y157.398 Z9
G1 Z8.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X164.602 Y157.398 E.33764
G1 X164.602 Y156.602 E.02559
G1 X175.898 Y156.602 E.36323
G1 X175.898 Y164.898 E.26677
G1 X175.102 Y164.898 E.02559
G1 X175.102 Y157.458 E.23924
; COOLING_NODE: 0
M204 S250
G1 X174.71 Y157.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X164.21 Y157.79 E.31276
G1 X164.21 Y156.21 E.04706
G1 X176.29 Y156.21 E.35982
G1 X176.29 Y165.29 E.27046
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X174.71 Y165.29 E.04706
G1 X174.71 Y157.85 E.22161
; WIPE_START
G1 F9547.055
M204 S8000
G1 X172.71 Y157.839 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.5 Y157.194 Z9.2 F60000
G1 Z8.8
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.4484
G1 F1200
M204 S8000
G1 X175.483 Y157.114 E.00263
; LINE_WIDTH: 0.470635
G1 X175.467 Y157.033 E.00278
G1 X175.306 Y157 E.00556
; LINE_WIDTH: 0.43172
G1 X164.806 Y157 E.32248
; WIPE_START
G1 F9259.259
G1 X166.806 Y157 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X174.436 Y157.171 Z9.2 F60000
G1 X175.5 Y157.194 Z9.2
G1 Z8.8
G1 E.8 F1800
; LINE_WIDTH: 0.43173
G1 F1200
M204 S8000
G1 X175.5 Y164.694 E.23035
; CHANGE_LAYER
; Z_HEIGHT: 9
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.021
G1 X175.5 Y162.694 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 45/165
; update layer progress
M73 L45
M991 S0 P44 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z9.2 I1.214 J-.091 P1  F60000
G1 X175.102 Y157.398 Z9.2
G1 Z9
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X164.602 Y157.398 E.33764
G1 X164.602 Y156.602 E.02559
G1 X175.898 Y156.602 E.36323
G1 X175.898 Y164.898 E.26677
G1 X175.102 Y164.898 E.02559
G1 X175.102 Y157.458 E.23924
; COOLING_NODE: 0
M204 S250
G1 X174.71 Y157.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X164.21 Y157.79 E.31276
M73 P39 R17
G1 X164.21 Y156.21 E.04706
G1 X176.29 Y156.21 E.35982
G1 X176.29 Y165.29 E.27046
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X174.71 Y165.29 E.04706
G1 X174.71 Y157.85 E.22161
; WIPE_START
G1 F9547.055
M204 S8000
G1 X172.71 Y157.839 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.5 Y157.194 Z9.4 F60000
G1 Z9
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.4484
G1 F1200
M204 S8000
G1 X175.483 Y157.114 E.00263
; LINE_WIDTH: 0.470635
G1 X175.467 Y157.033 E.00278
G1 X175.306 Y157 E.00556
; LINE_WIDTH: 0.43172
G1 X164.806 Y157 E.32248
; WIPE_START
G1 F9259.259
G1 X166.806 Y157 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X174.436 Y157.171 Z9.4 F60000
G1 X175.5 Y157.194 Z9.4
G1 Z9
G1 E.8 F1800
; LINE_WIDTH: 0.43173
G1 F1200
M204 S8000
G1 X175.5 Y164.694 E.23035
; CHANGE_LAYER
; Z_HEIGHT: 9.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.021
G1 X175.5 Y162.694 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 46/165
; update layer progress
M73 L46
M991 S0 P45 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z9.4 I1.214 J-.091 P1  F60000
G1 X175.102 Y157.398 Z9.4
G1 Z9.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X164.602 Y157.398 E.33764
G1 X164.602 Y156.602 E.02559
G1 X175.898 Y156.602 E.36323
G1 X175.898 Y164.898 E.26677
G1 X175.102 Y164.898 E.02559
G1 X175.102 Y157.458 E.23924
; COOLING_NODE: 0
M204 S250
G1 X174.71 Y157.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X164.21 Y157.79 E.31276
G1 X164.21 Y156.21 E.04706
G1 X176.29 Y156.21 E.35982
G1 X176.29 Y165.29 E.27046
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X174.71 Y165.29 E.04706
G1 X174.71 Y157.85 E.22161
; WIPE_START
G1 F9547.055
M204 S8000
G1 X172.71 Y157.839 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.5 Y157.194 Z9.6 F60000
G1 Z9.2
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.4484
G1 F1200
M204 S8000
G1 X175.483 Y157.114 E.00263
; LINE_WIDTH: 0.470635
G1 X175.467 Y157.033 E.00278
G1 X175.306 Y157 E.00556
; LINE_WIDTH: 0.43172
G1 X164.806 Y157 E.32248
; WIPE_START
G1 F9259.259
G1 X166.806 Y157 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X174.436 Y157.171 Z9.6 F60000
G1 X175.5 Y157.194 Z9.6
G1 Z9.2
G1 E.8 F1800
; LINE_WIDTH: 0.43173
G1 F1200
M204 S8000
G1 X175.5 Y164.694 E.23035
; CHANGE_LAYER
; Z_HEIGHT: 9.4
; LAYER_HEIGHT: 0.2
; WIPE_START
M73 P39 R16
G1 F9259.021
G1 X175.5 Y162.694 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 47/165
; update layer progress
M73 L47
M991 S0 P46 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z9.6 I1.214 J-.091 P1  F60000
G1 X175.102 Y157.398 Z9.6
G1 Z9.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X164.602 Y157.398 E.33764
G1 X164.602 Y156.602 E.02559
G1 X175.898 Y156.602 E.36323
G1 X175.898 Y164.898 E.26677
G1 X175.102 Y164.898 E.02559
G1 X175.102 Y157.458 E.23924
; COOLING_NODE: 0
M204 S250
G1 X174.71 Y157.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X164.21 Y157.79 E.31276
G1 X164.21 Y156.21 E.04706
G1 X176.29 Y156.21 E.35982
G1 X176.29 Y165.29 E.27046
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X174.71 Y165.29 E.04706
G1 X174.71 Y157.85 E.22161
; WIPE_START
G1 F9547.055
M204 S8000
G1 X172.71 Y157.839 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.5 Y157.194 Z9.8 F60000
G1 Z9.4
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.4484
G1 F1200
M204 S8000
G1 X175.483 Y157.114 E.00263
; LINE_WIDTH: 0.470635
G1 X175.467 Y157.033 E.00278
G1 X175.306 Y157 E.00556
; LINE_WIDTH: 0.43172
G1 X164.806 Y157 E.32248
; WIPE_START
G1 F9259.259
G1 X166.806 Y157 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X174.436 Y157.171 Z9.8 F60000
G1 X175.5 Y157.194 Z9.8
G1 Z9.4
G1 E.8 F1800
; LINE_WIDTH: 0.43173
G1 F1200
M204 S8000
G1 X175.5 Y164.694 E.23035
; CHANGE_LAYER
; Z_HEIGHT: 9.6
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F9259.021
G1 X175.5 Y162.694 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 48/165
; update layer progress
M73 L48
M991 S0 P47 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z9.8 I1.214 J-.091 P1  F60000
G1 X175.102 Y157.398 Z9.8
G1 Z9.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X164.602 Y157.398 E.33764
G1 X164.602 Y156.602 E.02559
G1 X175.898 Y156.602 E.36323
G1 X175.898 Y164.898 E.26677
G1 X175.102 Y164.898 E.02559
G1 X175.102 Y157.458 E.23924
; COOLING_NODE: 0
M204 S250
G1 X174.71 Y157.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X164.21 Y157.79 E.31276
M73 P40 R16
G1 X164.21 Y156.21 E.04706
G1 X176.29 Y156.21 E.35982
G1 X176.29 Y165.29 E.27046
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X174.71 Y165.29 E.04706
G1 X174.71 Y157.85 E.22161
; WIPE_START
G1 F9547.055
M204 S8000
G1 X172.71 Y157.839 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.5 Y157.194 Z10 F60000
G1 Z9.6
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.4484
G1 F1200
M204 S8000
G1 X175.483 Y157.114 E.00263
; LINE_WIDTH: 0.470635
G1 X175.467 Y157.033 E.00278
G1 X175.306 Y157 E.00556
; LINE_WIDTH: 0.43172
G1 X164.806 Y157 E.32248
; WIPE_START
G1 F9259.259
G1 X166.806 Y157 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X174.436 Y157.171 Z10 F60000
G1 X175.5 Y157.194 Z10
G1 Z9.6
G1 E.8 F1800
; LINE_WIDTH: 0.43173
G1 F1200
M204 S8000
G1 X175.5 Y164.694 E.23035
; CHANGE_LAYER
; Z_HEIGHT: 9.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.021
G1 X175.5 Y162.694 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 49/165
; update layer progress
M73 L49
M991 S0 P48 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z10 I1.214 J-.091 P1  F60000
G1 X175.102 Y157.398 Z10
G1 Z9.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X164.602 Y157.398 E.33764
G1 X164.602 Y156.602 E.02559
G1 X175.898 Y156.602 E.36323
G1 X175.898 Y164.898 E.26677
G1 X175.102 Y164.898 E.02559
G1 X175.102 Y157.458 E.23924
; COOLING_NODE: 0
M204 S250
G1 X174.71 Y157.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X164.21 Y157.79 E.31276
G1 X164.21 Y156.21 E.04706
G1 X176.29 Y156.21 E.35982
G1 X176.29 Y165.29 E.27046
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X174.71 Y165.29 E.04706
G1 X174.71 Y157.85 E.22161
; WIPE_START
G1 F9547.055
M204 S8000
G1 X172.71 Y157.839 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.5 Y157.194 Z10.2 F60000
G1 Z9.8
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.4484
G1 F1200
M204 S8000
G1 X175.483 Y157.114 E.00263
; LINE_WIDTH: 0.470635
G1 X175.467 Y157.033 E.00278
G1 X175.306 Y157 E.00556
; LINE_WIDTH: 0.43172
G1 X164.806 Y157 E.32248
; WIPE_START
G1 F9259.259
G1 X166.806 Y157 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X174.436 Y157.171 Z10.2 F60000
G1 X175.5 Y157.194 Z10.2
G1 Z9.8
G1 E.8 F1800
; LINE_WIDTH: 0.43173
G1 F1200
M204 S8000
G1 X175.5 Y164.694 E.23035
; CHANGE_LAYER
; Z_HEIGHT: 10
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.021
G1 X175.5 Y162.694 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 50/165
; update layer progress
M73 L50
M991 S0 P49 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z10.2 I1.214 J-.091 P1  F60000
G1 X175.102 Y157.398 Z10.2
G1 Z10
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X164.602 Y157.398 E.33764
G1 X164.602 Y156.602 E.02559
G1 X175.898 Y156.602 E.36323
G1 X175.898 Y164.898 E.26677
G1 X175.102 Y164.898 E.02559
G1 X175.102 Y157.458 E.23924
; COOLING_NODE: 0
M204 S250
G1 X174.71 Y157.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X164.21 Y157.79 E.31276
G1 X164.21 Y156.21 E.04706
G1 X176.29 Y156.21 E.35982
G1 X176.29 Y165.29 E.27046
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X174.71 Y165.29 E.04706
G1 X174.71 Y157.85 E.22161
; WIPE_START
G1 F9547.055
M204 S8000
G1 X172.71 Y157.839 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.5 Y157.194 Z10.4 F60000
G1 Z10
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.4484
G1 F1200
M204 S8000
G1 X175.483 Y157.114 E.00263
; LINE_WIDTH: 0.470635
G1 X175.467 Y157.033 E.00278
G1 X175.306 Y157 E.00556
; LINE_WIDTH: 0.43172
G1 X164.806 Y157 E.32248
; WIPE_START
G1 F9259.259
G1 X166.806 Y157 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X174.436 Y157.171 Z10.4 F60000
G1 X175.5 Y157.194 Z10.4
G1 Z10
G1 E.8 F1800
; LINE_WIDTH: 0.43173
G1 F1200
M204 S8000
G1 X175.5 Y164.694 E.23035
; CHANGE_LAYER
; Z_HEIGHT: 10.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.021
G1 X175.5 Y162.694 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 51/165
; update layer progress
M73 L51
M991 S0 P50 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z10.4 I1.214 J-.091 P1  F60000
G1 X175.102 Y157.398 Z10.4
G1 Z10.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X164.602 Y157.398 E.33764
G1 X164.602 Y156.602 E.02559
G1 X175.898 Y156.602 E.36323
G1 X175.898 Y164.898 E.26677
G1 X175.102 Y164.898 E.02559
G1 X175.102 Y157.458 E.23924
; COOLING_NODE: 0
M204 S250
G1 X174.71 Y157.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X164.21 Y157.79 E.31276
G1 X164.21 Y156.21 E.04706
G1 X176.29 Y156.21 E.35982
G1 X176.29 Y165.29 E.27046
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

M73 P41 R16
G1 X174.71 Y165.29 E.04706
G1 X174.71 Y157.85 E.22161
; WIPE_START
G1 F9547.055
M204 S8000
G1 X172.71 Y157.839 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.5 Y157.194 Z10.6 F60000
G1 Z10.2
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.4484
G1 F1200
M204 S8000
G1 X175.483 Y157.114 E.00263
; LINE_WIDTH: 0.470635
G1 X175.467 Y157.033 E.00278
G1 X175.306 Y157 E.00556
; LINE_WIDTH: 0.43172
G1 X164.806 Y157 E.32248
; WIPE_START
G1 F9259.259
G1 X166.806 Y157 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X174.436 Y157.171 Z10.6 F60000
G1 X175.5 Y157.194 Z10.6
G1 Z10.2
G1 E.8 F1800
; LINE_WIDTH: 0.43173
G1 F1200
M204 S8000
G1 X175.5 Y164.694 E.23035
; CHANGE_LAYER
; Z_HEIGHT: 10.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.021
G1 X175.5 Y162.694 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 52/165
; update layer progress
M73 L52
M991 S0 P51 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z10.6 I1.214 J-.091 P1  F60000
G1 X175.102 Y157.398 Z10.6
G1 Z10.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X164.602 Y157.398 E.33764
G1 X164.602 Y156.602 E.02559
G1 X175.898 Y156.602 E.36323
G1 X175.898 Y164.898 E.26677
G1 X175.102 Y164.898 E.02559
G1 X175.102 Y157.458 E.23924
; COOLING_NODE: 0
M204 S250
G1 X174.71 Y157.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X164.21 Y157.79 E.31276
G1 X164.21 Y156.21 E.04706
G1 X176.29 Y156.21 E.35982
G1 X176.29 Y165.29 E.27046
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X174.71 Y165.29 E.04706
G1 X174.71 Y157.85 E.22161
; WIPE_START
G1 F9547.055
M204 S8000
G1 X172.71 Y157.839 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.5 Y157.194 Z10.8 F60000
G1 Z10.4
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.4484
G1 F1200
M204 S8000
G1 X175.483 Y157.114 E.00263
; LINE_WIDTH: 0.470635
G1 X175.467 Y157.033 E.00278
G1 X175.306 Y157 E.00556
; LINE_WIDTH: 0.43172
G1 X164.806 Y157 E.32248
; WIPE_START
G1 F9259.259
G1 X166.806 Y157 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X174.436 Y157.171 Z10.8 F60000
G1 X175.5 Y157.194 Z10.8
G1 Z10.4
G1 E.8 F1800
; LINE_WIDTH: 0.43173
G1 F1200
M204 S8000
G1 X175.5 Y164.694 E.23035
; CHANGE_LAYER
; Z_HEIGHT: 10.6
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F9259.021
G1 X175.5 Y162.694 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 53/165
; update layer progress
M73 L53
M991 S0 P52 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z10.8 I1.214 J-.091 P1  F60000
G1 X175.102 Y157.398 Z10.8
G1 Z10.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X164.602 Y157.398 E.33764
G1 X164.602 Y156.602 E.02559
G1 X175.898 Y156.602 E.36323
G1 X175.898 Y164.898 E.26677
G1 X175.102 Y164.898 E.02559
G1 X175.102 Y157.458 E.23924
; COOLING_NODE: 0
M204 S250
G1 X174.71 Y157.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X164.21 Y157.79 E.31276
G1 X164.21 Y156.21 E.04706
G1 X176.29 Y156.21 E.35982
G1 X176.29 Y165.29 E.27046
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X174.71 Y165.29 E.04706
G1 X174.71 Y157.85 E.22161
; WIPE_START
G1 F9547.055
M204 S8000
G1 X172.71 Y157.839 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.5 Y157.194 Z11 F60000
G1 Z10.6
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.4484
G1 F1200
M204 S8000
G1 X175.483 Y157.114 E.00263
; LINE_WIDTH: 0.470635
G1 X175.467 Y157.033 E.00278
G1 X175.306 Y157 E.00556
; LINE_WIDTH: 0.43172
G1 X164.806 Y157 E.32248
; WIPE_START
G1 F9259.259
G1 X166.806 Y157 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X174.436 Y157.171 Z11 F60000
G1 X175.5 Y157.194 Z11
G1 Z10.6
G1 E.8 F1800
; LINE_WIDTH: 0.43173
G1 F1200
M204 S8000
G1 X175.5 Y164.694 E.23035
; CHANGE_LAYER
; Z_HEIGHT: 10.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.021
G1 X175.5 Y162.694 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 54/165
; update layer progress
M73 L54
M991 S0 P53 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z11 I1.214 J-.091 P1  F60000
G1 X175.102 Y157.398 Z11
G1 Z10.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X164.602 Y157.398 E.33764
G1 X164.602 Y156.602 E.02559
G1 X175.898 Y156.602 E.36323
G1 X175.898 Y164.898 E.26677
G1 X175.102 Y164.898 E.02559
G1 X175.102 Y157.458 E.23924
; COOLING_NODE: 0
M204 S250
G1 X174.71 Y157.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X164.21 Y157.79 E.31276
G1 X164.21 Y156.21 E.04706
G1 X176.29 Y156.21 E.35982
G1 X176.29 Y165.29 E.27046
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

M73 P42 R16
G1 X174.71 Y165.29 E.04706
G1 X174.71 Y157.85 E.22161
; WIPE_START
G1 F9547.055
M204 S8000
G1 X172.71 Y157.839 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.5 Y157.194 Z11.2 F60000
G1 Z10.8
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.4484
G1 F1200
M204 S8000
G1 X175.483 Y157.114 E.00263
; LINE_WIDTH: 0.470635
G1 X175.467 Y157.033 E.00278
G1 X175.306 Y157 E.00556
; LINE_WIDTH: 0.43172
G1 X164.806 Y157 E.32248
; WIPE_START
G1 F9259.259
G1 X166.806 Y157 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X174.436 Y157.171 Z11.2 F60000
G1 X175.5 Y157.194 Z11.2
G1 Z10.8
G1 E.8 F1800
; LINE_WIDTH: 0.43173
G1 F1200
M204 S8000
G1 X175.5 Y164.694 E.23035
; CHANGE_LAYER
; Z_HEIGHT: 11
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.021
G1 X175.5 Y162.694 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 55/165
; update layer progress
M73 L55
M991 S0 P54 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z11.2 I1.214 J-.091 P1  F60000
G1 X175.102 Y157.398 Z11.2
G1 Z11
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X164.602 Y157.398 E.33764
G1 X164.602 Y156.602 E.02559
G1 X175.898 Y156.602 E.36323
G1 X175.898 Y164.898 E.26677
G1 X175.102 Y164.898 E.02559
G1 X175.102 Y157.458 E.23924
; COOLING_NODE: 0
M204 S250
G1 X174.71 Y157.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X164.21 Y157.79 E.31276
G1 X164.21 Y156.21 E.04706
G1 X176.29 Y156.21 E.35982
G1 X176.29 Y165.29 E.27046
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X174.71 Y165.29 E.04706
G1 X174.71 Y157.85 E.22161
; WIPE_START
G1 F9547.055
M204 S8000
G1 X172.71 Y157.839 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.5 Y157.194 Z11.4 F60000
G1 Z11
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.4484
G1 F1200
M204 S8000
G1 X175.483 Y157.114 E.00263
; LINE_WIDTH: 0.470635
G1 X175.467 Y157.033 E.00278
G1 X175.306 Y157 E.00556
; LINE_WIDTH: 0.43172
G1 X164.806 Y157 E.32248
; WIPE_START
G1 F9259.259
G1 X166.806 Y157 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X174.436 Y157.171 Z11.4 F60000
G1 X175.5 Y157.194 Z11.4
G1 Z11
G1 E.8 F1800
; LINE_WIDTH: 0.43173
G1 F1200
M204 S8000
G1 X175.5 Y164.694 E.23035
; CHANGE_LAYER
; Z_HEIGHT: 11.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.021
G1 X175.5 Y162.694 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 56/165
; update layer progress
M73 L56
M991 S0 P55 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z11.4 I1.214 J-.091 P1  F60000
G1 X175.102 Y157.398 Z11.4
G1 Z11.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X164.602 Y157.398 E.33764
G1 X164.602 Y156.602 E.02559
G1 X175.898 Y156.602 E.36323
G1 X175.898 Y164.898 E.26677
G1 X175.102 Y164.898 E.02559
G1 X175.102 Y157.458 E.23924
; COOLING_NODE: 0
M204 S250
G1 X174.71 Y157.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X164.21 Y157.79 E.31276
G1 X164.21 Y156.21 E.04706
G1 X176.29 Y156.21 E.35982
G1 X176.29 Y165.29 E.27046
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X174.71 Y165.29 E.04706
G1 X174.71 Y157.85 E.22161
; WIPE_START
G1 F9547.055
M204 S8000
G1 X172.71 Y157.839 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.5 Y157.194 Z11.6 F60000
G1 Z11.2
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.4484
G1 F1200
M204 S8000
G1 X175.483 Y157.114 E.00263
; LINE_WIDTH: 0.470635
G1 X175.467 Y157.033 E.00278
G1 X175.306 Y157 E.00556
; LINE_WIDTH: 0.43172
G1 X164.806 Y157 E.32248
; WIPE_START
G1 F9259.259
G1 X166.806 Y157 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X174.436 Y157.171 Z11.6 F60000
G1 X175.5 Y157.194 Z11.6
G1 Z11.2
G1 E.8 F1800
; LINE_WIDTH: 0.43173
G1 F1200
M204 S8000
G1 X175.5 Y164.694 E.23035
; CHANGE_LAYER
; Z_HEIGHT: 11.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.021
G1 X175.5 Y162.694 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 57/165
; update layer progress
M73 L57
M991 S0 P56 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z11.6 I1.214 J-.091 P1  F60000
G1 X175.102 Y157.398 Z11.6
G1 Z11.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X164.602 Y157.398 E.33764
G1 X164.602 Y156.602 E.02559
G1 X175.898 Y156.602 E.36323
G1 X175.898 Y164.898 E.26677
G1 X175.102 Y164.898 E.02559
G1 X175.102 Y157.458 E.23924
; COOLING_NODE: 0
M204 S250
G1 X174.71 Y157.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X164.21 Y157.79 E.31276
G1 X164.21 Y156.21 E.04706
G1 X176.29 Y156.21 E.35982
G1 X176.29 Y165.29 E.27046
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

M73 P43 R16
G1 X174.71 Y165.29 E.04706
G1 X174.71 Y157.85 E.22161
; WIPE_START
G1 F9547.055
M204 S8000
M73 P43 R15
G1 X172.71 Y157.839 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.5 Y157.194 Z11.8 F60000
G1 Z11.4
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.4484
G1 F1200
M204 S8000
G1 X175.483 Y157.114 E.00263
; LINE_WIDTH: 0.470635
G1 X175.467 Y157.033 E.00278
G1 X175.306 Y157 E.00556
; LINE_WIDTH: 0.43172
G1 X164.806 Y157 E.32248
; WIPE_START
G1 F9259.259
G1 X166.806 Y157 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X174.436 Y157.171 Z11.8 F60000
G1 X175.5 Y157.194 Z11.8
G1 Z11.4
G1 E.8 F1800
; LINE_WIDTH: 0.43173
G1 F1200
M204 S8000
G1 X175.5 Y164.694 E.23035
; CHANGE_LAYER
; Z_HEIGHT: 11.6
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F9259.021
G1 X175.5 Y162.694 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 58/165
; update layer progress
M73 L58
M991 S0 P57 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z11.8 I1.214 J-.091 P1  F60000
G1 X175.102 Y157.398 Z11.8
G1 Z11.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X164.602 Y157.398 E.33764
G1 X164.602 Y156.602 E.02559
G1 X175.898 Y156.602 E.36323
G1 X175.898 Y164.898 E.26677
G1 X175.102 Y164.898 E.02559
G1 X175.102 Y157.458 E.23924
; COOLING_NODE: 0
M204 S250
G1 X174.71 Y157.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X164.21 Y157.79 E.31276
G1 X164.21 Y156.21 E.04706
G1 X176.29 Y156.21 E.35982
G1 X176.29 Y165.29 E.27046
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X174.71 Y165.29 E.04706
G1 X174.71 Y157.85 E.22161
; WIPE_START
G1 F9547.055
M204 S8000
G1 X172.71 Y157.839 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.5 Y157.194 Z12 F60000
G1 Z11.6
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.4484
G1 F1200
M204 S8000
G1 X175.483 Y157.114 E.00263
; LINE_WIDTH: 0.470635
G1 X175.467 Y157.033 E.00278
G1 X175.306 Y157 E.00556
; LINE_WIDTH: 0.43172
G1 X164.806 Y157 E.32248
; WIPE_START
G1 F9259.259
G1 X166.806 Y157 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X174.436 Y157.171 Z12 F60000
G1 X175.5 Y157.194 Z12
G1 Z11.6
G1 E.8 F1800
; LINE_WIDTH: 0.43173
G1 F1200
M204 S8000
G1 X175.5 Y164.694 E.23035
; CHANGE_LAYER
; Z_HEIGHT: 11.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.021
G1 X175.5 Y162.694 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 59/165
; update layer progress
M73 L59
M991 S0 P58 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z12 I1.214 J-.091 P1  F60000
G1 X175.102 Y157.398 Z12
G1 Z11.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X164.602 Y157.398 E.33764
G1 X164.602 Y156.602 E.02559
G1 X175.898 Y156.602 E.36323
G1 X175.898 Y164.898 E.26677
G1 X175.102 Y164.898 E.02559
G1 X175.102 Y157.458 E.23924
; COOLING_NODE: 0
M204 S250
G1 X174.71 Y157.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X164.21 Y157.79 E.31276
G1 X164.21 Y156.21 E.04706
G1 X176.29 Y156.21 E.35982
G1 X176.29 Y165.29 E.27046
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X174.71 Y165.29 E.04706
G1 X174.71 Y157.85 E.22161
; WIPE_START
G1 F9547.055
M204 S8000
G1 X172.71 Y157.839 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.5 Y157.194 Z12.2 F60000
G1 Z11.8
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.4484
G1 F1200
M204 S8000
G1 X175.483 Y157.114 E.00263
; LINE_WIDTH: 0.470635
G1 X175.467 Y157.033 E.00278
G1 X175.306 Y157 E.00556
; LINE_WIDTH: 0.43172
G1 X164.806 Y157 E.32248
; WIPE_START
G1 F9259.259
G1 X166.806 Y157 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X174.436 Y157.171 Z12.2 F60000
G1 X175.5 Y157.194 Z12.2
G1 Z11.8
G1 E.8 F1800
; LINE_WIDTH: 0.43173
G1 F1200
M204 S8000
G1 X175.5 Y164.694 E.23035
; CHANGE_LAYER
; Z_HEIGHT: 12
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.021
G1 X175.5 Y162.694 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 60/165
; update layer progress
M73 L60
M991 S0 P59 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z12.2 I1.214 J-.091 P1  F60000
G1 X175.102 Y157.398 Z12.2
G1 Z12
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X164.602 Y157.398 E.33764
G1 X164.602 Y156.602 E.02559
G1 X175.898 Y156.602 E.36323
G1 X175.898 Y164.898 E.26677
G1 X175.102 Y164.898 E.02559
G1 X175.102 Y157.458 E.23924
; COOLING_NODE: 0
M204 S250
G1 X174.71 Y157.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X164.21 Y157.79 E.31276
G1 X164.21 Y156.21 E.04706
G1 X176.29 Y156.21 E.35982
G1 X176.29 Y165.29 E.27046
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

M73 P44 R15
G1 X174.71 Y165.29 E.04706
G1 X174.71 Y157.85 E.22161
; WIPE_START
G1 F9547.055
M204 S8000
G1 X172.71 Y157.839 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.5 Y157.194 Z12.4 F60000
G1 Z12
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.4484
G1 F1200
M204 S8000
G1 X175.483 Y157.114 E.00263
; LINE_WIDTH: 0.470635
G1 X175.467 Y157.033 E.00278
G1 X175.306 Y157 E.00556
; LINE_WIDTH: 0.43172
G1 X164.806 Y157 E.32248
; WIPE_START
G1 F9259.259
G1 X166.806 Y157 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X174.436 Y157.171 Z12.4 F60000
G1 X175.5 Y157.194 Z12.4
G1 Z12
G1 E.8 F1800
; LINE_WIDTH: 0.43173
G1 F1200
M204 S8000
G1 X175.5 Y164.694 E.23035
; CHANGE_LAYER
; Z_HEIGHT: 12.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.021
G1 X175.5 Y162.694 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 61/165
; update layer progress
M73 L61
M991 S0 P60 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z12.4 I1.214 J-.091 P1  F60000
G1 X175.102 Y157.398 Z12.4
G1 Z12.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X164.602 Y157.398 E.33764
G1 X164.602 Y156.602 E.02559
G1 X175.898 Y156.602 E.36323
G1 X175.898 Y164.898 E.26677
G1 X175.102 Y164.898 E.02559
G1 X175.102 Y157.458 E.23924
; COOLING_NODE: 0
M204 S250
G1 X174.71 Y157.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X164.21 Y157.79 E.31276
G1 X164.21 Y156.21 E.04706
G1 X176.29 Y156.21 E.35982
G1 X176.29 Y165.29 E.27046
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X174.71 Y165.29 E.04706
G1 X174.71 Y157.85 E.22161
; WIPE_START
G1 F9547.055
M204 S8000
G1 X172.71 Y157.839 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.5 Y157.194 Z12.6 F60000
G1 Z12.2
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.4484
G1 F1200
M204 S8000
G1 X175.483 Y157.114 E.00263
; LINE_WIDTH: 0.470635
G1 X175.467 Y157.033 E.00278
G1 X175.306 Y157 E.00556
; LINE_WIDTH: 0.43172
G1 X164.806 Y157 E.32248
; WIPE_START
G1 F9259.259
G1 X166.806 Y157 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X174.436 Y157.171 Z12.6 F60000
G1 X175.5 Y157.194 Z12.6
G1 Z12.2
G1 E.8 F1800
; LINE_WIDTH: 0.43173
G1 F1200
M204 S8000
G1 X175.5 Y164.694 E.23035
; CHANGE_LAYER
; Z_HEIGHT: 12.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.021
G1 X175.5 Y162.694 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 62/165
; update layer progress
M73 L62
M991 S0 P61 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z12.6 I1.214 J-.091 P1  F60000
G1 X175.102 Y157.398 Z12.6
G1 Z12.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X164.602 Y157.398 E.33764
G1 X164.602 Y156.602 E.02559
G1 X175.898 Y156.602 E.36323
G1 X175.898 Y164.898 E.26677
G1 X175.102 Y164.898 E.02559
G1 X175.102 Y157.458 E.23924
; COOLING_NODE: 0
M204 S250
G1 X174.71 Y157.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X164.21 Y157.79 E.31276
G1 X164.21 Y156.21 E.04706
G1 X176.29 Y156.21 E.35982
G1 X176.29 Y165.29 E.27046
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X174.71 Y165.29 E.04706
G1 X174.71 Y157.85 E.22161
; WIPE_START
G1 F9547.055
M204 S8000
G1 X172.71 Y157.839 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.5 Y157.194 Z12.8 F60000
G1 Z12.4
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.4484
G1 F1200
M204 S8000
G1 X175.483 Y157.114 E.00263
; LINE_WIDTH: 0.470635
G1 X175.467 Y157.033 E.00278
G1 X175.306 Y157 E.00556
; LINE_WIDTH: 0.43172
G1 X164.806 Y157 E.32248
; WIPE_START
G1 F9259.259
G1 X166.806 Y157 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X174.436 Y157.171 Z12.8 F60000
G1 X175.5 Y157.194 Z12.8
G1 Z12.4
G1 E.8 F1800
; LINE_WIDTH: 0.43173
G1 F1200
M204 S8000
G1 X175.5 Y164.694 E.23035
; CHANGE_LAYER
; Z_HEIGHT: 12.6
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F9259.021
G1 X175.5 Y162.694 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 63/165
; update layer progress
M73 L63
M991 S0 P62 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z12.8 I1.214 J-.091 P1  F60000
G1 X175.102 Y157.398 Z12.8
G1 Z12.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X164.602 Y157.398 E.33764
G1 X164.602 Y156.602 E.02559
G1 X175.898 Y156.602 E.36323
G1 X175.898 Y164.898 E.26677
G1 X175.102 Y164.898 E.02559
G1 X175.102 Y157.458 E.23924
; COOLING_NODE: 0
M204 S250
G1 X174.71 Y157.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X164.21 Y157.79 E.31276
G1 X164.21 Y156.21 E.04706
G1 X176.29 Y156.21 E.35982
G1 X176.29 Y165.29 E.27046
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X174.71 Y165.29 E.04706
M73 P45 R15
G1 X174.71 Y157.85 E.22161
; WIPE_START
G1 F9547.055
M204 S8000
G1 X172.71 Y157.839 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.5 Y157.194 Z13 F60000
G1 Z12.6
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.4484
G1 F1200
M204 S8000
G1 X175.483 Y157.114 E.00263
; LINE_WIDTH: 0.470635
G1 X175.467 Y157.033 E.00278
G1 X175.306 Y157 E.00556
; LINE_WIDTH: 0.43172
G1 X164.806 Y157 E.32248
; WIPE_START
G1 F9259.259
G1 X166.806 Y157 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X174.436 Y157.171 Z13 F60000
G1 X175.5 Y157.194 Z13
G1 Z12.6
G1 E.8 F1800
; LINE_WIDTH: 0.43173
G1 F1200
M204 S8000
G1 X175.5 Y164.694 E.23035
; CHANGE_LAYER
; Z_HEIGHT: 12.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.021
G1 X175.5 Y162.694 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 64/165
; update layer progress
M73 L64
M991 S0 P63 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z13 I1.214 J-.091 P1  F60000
G1 X175.102 Y157.398 Z13
G1 Z12.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X164.602 Y157.398 E.33764
G1 X164.602 Y156.602 E.02559
G1 X175.898 Y156.602 E.36323
G1 X175.898 Y164.898 E.26677
G1 X175.102 Y164.898 E.02559
G1 X175.102 Y157.458 E.23924
; COOLING_NODE: 0
M204 S250
G1 X174.71 Y157.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X164.21 Y157.79 E.31276
G1 X164.21 Y156.21 E.04706
G1 X176.29 Y156.21 E.35982
G1 X176.29 Y165.29 E.27046
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X174.71 Y165.29 E.04706
G1 X174.71 Y157.85 E.22161
; WIPE_START
G1 F9547.055
M204 S8000
G1 X172.71 Y157.839 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.5 Y157.194 Z13.2 F60000
G1 Z12.8
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.4484
G1 F1200
M204 S8000
G1 X175.483 Y157.114 E.00263
; LINE_WIDTH: 0.470635
G1 X175.467 Y157.033 E.00278
G1 X175.306 Y157 E.00556
; LINE_WIDTH: 0.43172
G1 X164.806 Y157 E.32248
; WIPE_START
G1 F9259.259
G1 X166.806 Y157 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X174.436 Y157.171 Z13.2 F60000
G1 X175.5 Y157.194 Z13.2
G1 Z12.8
G1 E.8 F1800
; LINE_WIDTH: 0.43173
G1 F1200
M204 S8000
G1 X175.5 Y164.694 E.23035
; CHANGE_LAYER
; Z_HEIGHT: 13
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.021
G1 X175.5 Y162.694 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 65/165
; update layer progress
M73 L65
M991 S0 P64 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z13.2 I1.214 J-.091 P1  F60000
G1 X175.102 Y157.398 Z13.2
G1 Z13
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X164.602 Y157.398 E.33764
G1 X164.602 Y156.602 E.02559
G1 X175.898 Y156.602 E.36323
G1 X175.898 Y164.898 E.26677
G1 X175.102 Y164.898 E.02559
G1 X175.102 Y157.458 E.23924
; COOLING_NODE: 0
M204 S250
G1 X174.71 Y157.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X164.21 Y157.79 E.31276
G1 X164.21 Y156.21 E.04706
G1 X176.29 Y156.21 E.35982
G1 X176.29 Y165.29 E.27046
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X174.71 Y165.29 E.04706
G1 X174.71 Y157.85 E.22161
; WIPE_START
G1 F9547.055
M204 S8000
G1 X172.71 Y157.839 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.5 Y157.194 Z13.4 F60000
G1 Z13
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.4484
G1 F1200
M204 S8000
G1 X175.483 Y157.114 E.00263
; LINE_WIDTH: 0.470635
G1 X175.467 Y157.033 E.00278
G1 X175.306 Y157 E.00556
; LINE_WIDTH: 0.43172
G1 X164.806 Y157 E.32248
; WIPE_START
G1 F9259.259
G1 X166.806 Y157 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X174.436 Y157.171 Z13.4 F60000
G1 X175.5 Y157.194 Z13.4
G1 Z13
G1 E.8 F1800
; LINE_WIDTH: 0.43173
G1 F1200
M204 S8000
G1 X175.5 Y164.694 E.23035
; CHANGE_LAYER
; Z_HEIGHT: 13.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.021
G1 X175.5 Y162.694 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 66/165
; update layer progress
M73 L66
M991 S0 P65 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z13.4 I1.214 J-.091 P1  F60000
G1 X175.102 Y157.398 Z13.4
G1 Z13.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X164.602 Y157.398 E.33764
G1 X164.602 Y156.602 E.02559
G1 X175.898 Y156.602 E.36323
G1 X175.898 Y164.898 E.26677
G1 X175.102 Y164.898 E.02559
G1 X175.102 Y157.458 E.23924
; COOLING_NODE: 0
M204 S250
G1 X174.71 Y157.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X164.21 Y157.79 E.31276
G1 X164.21 Y156.21 E.04706
G1 X176.29 Y156.21 E.35982
G1 X176.29 Y165.29 E.27046
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X174.71 Y165.29 E.04706
G1 X174.71 Y157.85 E.22161
; WIPE_START
M73 P46 R15
G1 F9547.055
M204 S8000
G1 X172.71 Y157.839 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.5 Y157.194 Z13.6 F60000
G1 Z13.2
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.4484
G1 F1200
M204 S8000
G1 X175.483 Y157.114 E.00263
; LINE_WIDTH: 0.470635
G1 X175.467 Y157.033 E.00278
G1 X175.306 Y157 E.00556
; LINE_WIDTH: 0.43172
G1 X164.806 Y157 E.32248
; WIPE_START
G1 F9259.259
G1 X166.806 Y157 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X174.436 Y157.171 Z13.6 F60000
G1 X175.5 Y157.194 Z13.6
G1 Z13.2
G1 E.8 F1800
; LINE_WIDTH: 0.43173
G1 F1200
M204 S8000
G1 X175.5 Y164.694 E.23035
; CHANGE_LAYER
; Z_HEIGHT: 13.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.021
G1 X175.5 Y162.694 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 67/165
; update layer progress
M73 L67
M991 S0 P66 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z13.6 I1.214 J-.091 P1  F60000
G1 X175.102 Y157.398 Z13.6
G1 Z13.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X164.602 Y157.398 E.33764
G1 X164.602 Y156.602 E.02559
G1 X175.898 Y156.602 E.36323
G1 X175.898 Y164.898 E.26677
G1 X175.102 Y164.898 E.02559
G1 X175.102 Y157.458 E.23924
; COOLING_NODE: 0
M204 S250
G1 X174.71 Y157.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X164.21 Y157.79 E.31276
G1 X164.21 Y156.21 E.04706
G1 X176.29 Y156.21 E.35982
G1 X176.29 Y165.29 E.27046
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X174.71 Y165.29 E.04706
G1 X174.71 Y157.85 E.22161
; WIPE_START
G1 F9547.055
M204 S8000
G1 X172.71 Y157.839 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.5 Y157.194 Z13.8 F60000
G1 Z13.4
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.4484
G1 F1200
M204 S8000
G1 X175.483 Y157.114 E.00263
; LINE_WIDTH: 0.470635
G1 X175.467 Y157.033 E.00278
G1 X175.306 Y157 E.00556
; LINE_WIDTH: 0.43172
G1 X164.806 Y157 E.32248
; WIPE_START
G1 F9259.259
G1 X166.806 Y157 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X174.436 Y157.171 Z13.8 F60000
G1 X175.5 Y157.194 Z13.8
G1 Z13.4
G1 E.8 F1800
; LINE_WIDTH: 0.43173
G1 F1200
M204 S8000
G1 X175.5 Y164.694 E.23035
; CHANGE_LAYER
; Z_HEIGHT: 13.6
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F9259.021
G1 X175.5 Y162.694 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 68/165
; update layer progress
M73 L68
M991 S0 P67 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z13.8 I1.214 J-.091 P1  F60000
G1 X175.102 Y157.398 Z13.8
G1 Z13.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X164.602 Y157.398 E.33764
G1 X164.602 Y156.602 E.02559
G1 X175.898 Y156.602 E.36323
G1 X175.898 Y164.898 E.26677
G1 X175.102 Y164.898 E.02559
G1 X175.102 Y157.458 E.23924
; COOLING_NODE: 0
M204 S250
G1 X174.71 Y157.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X164.21 Y157.79 E.31276
G1 X164.21 Y156.21 E.04706
G1 X176.29 Y156.21 E.35982
G1 X176.29 Y165.29 E.27046
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

M73 P46 R14
G1 X174.71 Y165.29 E.04706
G1 X174.71 Y157.85 E.22161
; WIPE_START
G1 F9547.055
M204 S8000
G1 X172.71 Y157.839 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.5 Y157.194 Z14 F60000
G1 Z13.6
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.4484
G1 F1200
M204 S8000
G1 X175.483 Y157.114 E.00263
; LINE_WIDTH: 0.470635
G1 X175.467 Y157.033 E.00278
G1 X175.306 Y157 E.00556
; LINE_WIDTH: 0.43172
G1 X164.806 Y157 E.32248
; WIPE_START
G1 F9259.259
G1 X166.806 Y157 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X174.436 Y157.171 Z14 F60000
G1 X175.5 Y157.194 Z14
G1 Z13.6
G1 E.8 F1800
; LINE_WIDTH: 0.43173
G1 F1200
M204 S8000
G1 X175.5 Y164.694 E.23035
; CHANGE_LAYER
; Z_HEIGHT: 13.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.021
G1 X175.5 Y162.694 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 69/165
; update layer progress
M73 L69
M991 S0 P68 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z14 I1.214 J-.091 P1  F60000
G1 X175.102 Y157.398 Z14
G1 Z13.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X164.602 Y157.398 E.33764
G1 X164.602 Y156.602 E.02559
G1 X175.898 Y156.602 E.36323
G1 X175.898 Y164.898 E.26677
G1 X175.102 Y164.898 E.02559
G1 X175.102 Y157.458 E.23924
; COOLING_NODE: 0
M204 S250
G1 X174.71 Y157.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X164.21 Y157.79 E.31276
G1 X164.21 Y156.21 E.04706
G1 X176.29 Y156.21 E.35982
G1 X176.29 Y165.29 E.27046
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X174.71 Y165.29 E.04706
G1 X174.71 Y157.85 E.22161
; WIPE_START
M73 P47 R14
G1 F9547.055
M204 S8000
G1 X172.71 Y157.839 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.5 Y157.194 Z14.2 F60000
G1 Z13.8
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.4484
G1 F1200
M204 S8000
G1 X175.483 Y157.114 E.00263
; LINE_WIDTH: 0.470635
G1 X175.467 Y157.033 E.00278
G1 X175.306 Y157 E.00556
; LINE_WIDTH: 0.43172
G1 X164.806 Y157 E.32248
; WIPE_START
G1 F9259.259
G1 X166.806 Y157 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X174.436 Y157.171 Z14.2 F60000
G1 X175.5 Y157.194 Z14.2
G1 Z13.8
G1 E.8 F1800
; LINE_WIDTH: 0.43173
G1 F1200
M204 S8000
G1 X175.5 Y164.694 E.23035
; CHANGE_LAYER
; Z_HEIGHT: 14
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.021
G1 X175.5 Y162.694 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 70/165
; update layer progress
M73 L70
M991 S0 P69 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z14.2 I1.214 J-.091 P1  F60000
G1 X175.102 Y157.398 Z14.2
G1 Z14
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X164.602 Y157.398 E.33764
G1 X164.602 Y156.602 E.02559
G1 X175.898 Y156.602 E.36323
G1 X175.898 Y164.898 E.26677
G1 X175.102 Y164.898 E.02559
G1 X175.102 Y157.458 E.23924
; COOLING_NODE: 0
M204 S250
G1 X174.71 Y157.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X164.21 Y157.79 E.31276
G1 X164.21 Y156.21 E.04706
G1 X176.29 Y156.21 E.35982
G1 X176.29 Y165.29 E.27046
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X174.71 Y165.29 E.04706
G1 X174.71 Y157.85 E.22161
; WIPE_START
G1 F9547.055
M204 S8000
G1 X172.71 Y157.839 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.5 Y157.194 Z14.4 F60000
G1 Z14
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.4484
G1 F1200
M204 S8000
G1 X175.483 Y157.114 E.00263
; LINE_WIDTH: 0.470635
G1 X175.467 Y157.033 E.00278
G1 X175.306 Y157 E.00556
; LINE_WIDTH: 0.43172
G1 X164.806 Y157 E.32248
; WIPE_START
G1 F9259.259
G1 X166.806 Y157 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X174.436 Y157.171 Z14.4 F60000
G1 X175.5 Y157.194 Z14.4
G1 Z14
G1 E.8 F1800
; LINE_WIDTH: 0.43173
G1 F1200
M204 S8000
G1 X175.5 Y164.694 E.23035
; CHANGE_LAYER
; Z_HEIGHT: 14.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.021
G1 X175.5 Y162.694 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 71/165
; update layer progress
M73 L71
M991 S0 P70 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z14.4 I1.214 J-.091 P1  F60000
G1 X175.102 Y157.398 Z14.4
G1 Z14.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X164.602 Y157.398 E.33764
G1 X164.602 Y156.602 E.02559
G1 X175.898 Y156.602 E.36323
G1 X175.898 Y164.898 E.26677
G1 X175.102 Y164.898 E.02559
G1 X175.102 Y157.458 E.23924
; COOLING_NODE: 0
M204 S250
G1 X174.71 Y157.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X164.21 Y157.79 E.31276
G1 X164.21 Y156.21 E.04706
G1 X176.29 Y156.21 E.35982
G1 X176.29 Y165.29 E.27046
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X174.71 Y165.29 E.04706
G1 X174.71 Y157.85 E.22161
; WIPE_START
G1 F9547.055
M204 S8000
G1 X172.71 Y157.839 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.5 Y157.194 Z14.6 F60000
G1 Z14.2
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.4484
G1 F1200
M204 S8000
G1 X175.483 Y157.114 E.00263
; LINE_WIDTH: 0.470635
G1 X175.467 Y157.033 E.00278
G1 X175.306 Y157 E.00556
; LINE_WIDTH: 0.43172
G1 X164.806 Y157 E.32248
; WIPE_START
G1 F9259.259
G1 X166.806 Y157 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X174.436 Y157.171 Z14.6 F60000
G1 X175.5 Y157.194 Z14.6
G1 Z14.2
G1 E.8 F1800
; LINE_WIDTH: 0.43173
G1 F1200
M204 S8000
G1 X175.5 Y164.694 E.23035
; CHANGE_LAYER
; Z_HEIGHT: 14.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.021
G1 X175.5 Y162.694 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 72/165
; update layer progress
M73 L72
M991 S0 P71 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z14.6 I1.214 J-.091 P1  F60000
G1 X175.102 Y157.398 Z14.6
G1 Z14.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X164.602 Y157.398 E.33764
G1 X164.602 Y156.602 E.02559
G1 X175.898 Y156.602 E.36323
G1 X175.898 Y164.898 E.26677
G1 X175.102 Y164.898 E.02559
G1 X175.102 Y157.458 E.23924
; COOLING_NODE: 0
M204 S250
G1 X174.71 Y157.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X164.21 Y157.79 E.31276
G1 X164.21 Y156.21 E.04706
G1 X176.29 Y156.21 E.35982
G1 X176.29 Y165.29 E.27046
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X174.71 Y165.29 E.04706
G1 X174.71 Y157.85 E.22161
; WIPE_START
M73 P48 R14
G1 F9547.055
M204 S8000
G1 X172.71 Y157.839 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.5 Y157.194 Z14.8 F60000
G1 Z14.4
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.4484
G1 F1200
M204 S8000
G1 X175.483 Y157.114 E.00263
; LINE_WIDTH: 0.470635
G1 X175.467 Y157.033 E.00278
G1 X175.306 Y157 E.00556
; LINE_WIDTH: 0.43172
G1 X164.806 Y157 E.32248
; WIPE_START
G1 F9259.259
G1 X166.806 Y157 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X174.436 Y157.171 Z14.8 F60000
G1 X175.5 Y157.194 Z14.8
G1 Z14.4
G1 E.8 F1800
; LINE_WIDTH: 0.43173
G1 F1200
M204 S8000
G1 X175.5 Y164.694 E.23035
; CHANGE_LAYER
; Z_HEIGHT: 14.6
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F9259.021
G1 X175.5 Y162.694 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 73/165
; update layer progress
M73 L73
M991 S0 P72 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z14.8 I1.214 J-.091 P1  F60000
G1 X175.102 Y157.398 Z14.8
G1 Z14.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X164.602 Y157.398 E.33764
G1 X164.602 Y156.602 E.02559
G1 X175.898 Y156.602 E.36323
G1 X175.898 Y164.898 E.26677
G1 X175.102 Y164.898 E.02559
G1 X175.102 Y157.458 E.23924
; COOLING_NODE: 0
M204 S250
G1 X174.71 Y157.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X164.21 Y157.79 E.31276
G1 X164.21 Y156.21 E.04706
G1 X176.29 Y156.21 E.35982
G1 X176.29 Y165.29 E.27046
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X174.71 Y165.29 E.04706
G1 X174.71 Y157.85 E.22161
; WIPE_START
G1 F9547.055
M204 S8000
G1 X172.71 Y157.839 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.5 Y157.194 Z15 F60000
G1 Z14.6
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.4484
G1 F1200
M204 S8000
G1 X175.483 Y157.114 E.00263
; LINE_WIDTH: 0.470635
G1 X175.467 Y157.033 E.00278
G1 X175.306 Y157 E.00556
; LINE_WIDTH: 0.43172
G1 X164.806 Y157 E.32248
; WIPE_START
G1 F9259.259
G1 X166.806 Y157 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X174.436 Y157.171 Z15 F60000
G1 X175.5 Y157.194 Z15
G1 Z14.6
G1 E.8 F1800
; LINE_WIDTH: 0.43173
G1 F1200
M204 S8000
G1 X175.5 Y164.694 E.23035
; CHANGE_LAYER
; Z_HEIGHT: 14.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.021
G1 X175.5 Y162.694 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 74/165
; update layer progress
M73 L74
M991 S0 P73 ;notify layer change

M106 S226.95
; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z15 I1.105 J-.51 P1  F60000
G1 X174.446 Y160.409 Z15
G1 Z14.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
M106 S229.5
G1 F1320
M204 S8000
G1 X174.451 Y160.397 E.00043
M106 S226.95
M106 S229.5
G1 F1379
G1 X174.463 Y160.367 E.00103
M106 S226.95
M106 S229.5
G1 X174.478 Y160.338 E.00103
M106 S226.95
M106 S229.5
G1 X174.484 Y160.327 E.00041
M106 S226.95
M106 S229.5
G1 X174.506 Y160.298 E.00116
M106 S226.95
M106 S229.5
G1 X174.515 Y160.288 E.00044
M106 S226.95
M106 S229.5
G1 X174.54 Y160.262 E.00117
M106 S226.95
M106 S229.5
G1 X174.554 Y160.251 E.00057
M106 S226.95
M106 S229.5
G1 X174.572 Y160.238 E.00071
M106 S226.95
M106 S229.5
G1 X174.59 Y160.226 E.00071
M106 S226.95
M106 S229.5
G1 X174.615 Y160.213 E.00089
M106 S226.95
G1 X174.682 Y160.182 E.00241
G1 X175.045 Y160.013 E.01286
G1 X175.491 Y159.806 E.01581
G1 X175.491 Y160.206 E.01286
G1 X175.491 Y160.606 E.01286
G1 X175.491 Y161.002 E.01273
G1 X175.072 Y160.902 E.01385
G1 X174.682 Y160.81 E.01286
G1 X174.673 Y160.807 E.0003
G1 X174.641 Y160.797 E.00108
M106 S229.5
G1 X174.616 Y160.787 E.00088
M106 S226.95
M106 S229.5
G1 X174.591 Y160.774 E.00089
M106 S226.95
M106 S229.5
G1 X174.568 Y160.759 E.00089
M106 S226.95
M106 S229.5
G1 X174.543 Y160.74 E.00102
M106 S226.95
M106 S229.5
G1 X174.533 Y160.73 E.00044
M106 S226.95
M106 S229.5
G1 X174.511 Y160.708 E.001
M106 S226.95
M106 S229.5
G1 X174.494 Y160.686 E.0009
M106 S226.95
M106 S229.5
G1 X174.479 Y160.663 E.00089
M106 S226.95
M106 S229.5
G1 X174.466 Y160.639 E.00088
M106 S226.95
M106 S229.5
G1 X174.455 Y160.614 E.00089
M106 S226.95
M106 S229.5
G1 F1320
G1 X174.444 Y160.583 E.00102
M106 S226.95
M106 S229.5
G1 F1200
G1 X174.433 Y160.507 E.00248
M106 S226.95
M106 S229.5
G1 F1080
G1 X174.433 Y160.494 E.00041
M106 S226.95
M106 S229.5
G1 F1200
G1 X174.437 Y160.469 E.00083
M106 S226.95
; COOLING_NODE: 0
; WIPE_START
G1 X174.451 Y160.397 E-.02787
G1 X174.463 Y160.367 E-.01215
G1 X174.478 Y160.338 E-.01222
G1 X174.484 Y160.327 E-.00489
G1 X174.506 Y160.298 E-.01369
G1 X174.515 Y160.288 E-.00517
G1 X174.54 Y160.262 E-.01382
G1 X174.554 Y160.251 E-.00669
G1 X174.572 Y160.238 E-.00837
G1 X174.59 Y160.226 E-.00844
G1 X174.615 Y160.213 E-.01047
G1 X174.682 Y160.182 E-.02844
G1 X175.045 Y160.013 E-.152
G1 X175.491 Y159.806 E-.18678
G1 X175.491 Y160.206 E-.152
G1 X175.491 Y160.514 E-.117
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X174.837 Y157.941 Z15.2 F60000
G1 Z14.8
G1 E.8 F1800
G1 F1379
M204 S8000
G1 X174.809 Y157.416 E.01691
G1 X175.084 Y157.416 E.00883
G1 X175.084 Y158.056 E.02058
G1 X174.892 Y157.967 E.00681
; COOLING_NODE: 0
M204 S10000
G1 X174.467 Y158.143 F60000
M106 S229.5
G1 F1379
M204 S8000
G1 X174.46 Y158.128 E.00056
M106 S226.95
M106 S229.5
G1 X174.449 Y158.097 E.00104
M106 S226.95
M106 S229.5
G1 F1320
G1 X174.44 Y158.067 E.00102
M106 S226.95
M106 S229.5
G1 F1200
G1 X174.437 Y158.049 E.00057
M106 S226.95
M106 S229.5
G1 F1379
G1 X174.434 Y158.026 E.00075
M106 S226.95
M106 S229.5
G1 X174.423 Y157.817 E.00673
M106 S226.95
G1 X174.402 Y157.418 E.01286
G1 X174.38 Y157.009 E.01317
G1 X174.78 Y157.009 E.01286
G1 X175.18 Y157.009 E.01286
G1 X175.491 Y157.009 E.01001
G1 X175.491 Y157.283 E.00881
G1 X175.491 Y157.683 E.01286
G1 X175.918 Y157.683 E.01372
G1 F1340.829
G1 X176.317 Y157.683 E.01286
M106 S229.5
G1 F925.411
G1 X176.7 Y157.683 E.0123
M106 S226.95
; FEATURE: Overhang wall
M106 S229.5
G1 F600
M204 S5000
G1 X184.991 Y157.683 E.2666
G1 X184.991 Y158.317 E.0204
G1 X176.7 Y158.317 E.2666
M106 S226.95
; FEATURE: Inner wall
M106 S229.5
G1 F925.411
M204 S8000
G1 X176.317 Y158.317 E.0123
M106 S226.95
G1 F1340.829
G1 X175.918 Y158.317 E.01286
G1 F1379
G1 X175.491 Y158.317 E.01372
G1 X175.491 Y158.694 E.01211
G1 X174.682 Y158.318 E.02866
G1 X174.615 Y158.287 E.00238
M106 S229.5
G1 X174.59 Y158.274 E.00092
M106 S226.95
M106 S229.5
G1 X174.572 Y158.262 E.0007
M106 S226.95
M106 S229.5
G1 X174.554 Y158.249 E.0007
M106 S226.95
M106 S229.5
G1 X174.537 Y158.235 E.00071
M106 S226.95
M106 S229.5
G1 X174.524 Y158.222 E.00058
M106 S226.95
M106 S229.5
G1 X174.501 Y158.195 E.00116
M106 S226.95
M106 S229.5
G1 X174.5 Y158.194 E.00005
M106 S226.95
; COOLING_NODE: 0
M204 S10000
G1 X174.036 Y158.118 F60000
M106 S229.5
G1 F600
M204 S8000
G1 X174.035 Y158.113 E.00015
M106 S226.95
M106 S229.5
G1 F840
G1 X174.028 Y158.062 E.00165
M106 S226.95
M106 S229.5
G1 F1074.275
G1 X174.015 Y157.817 E.00787
M106 S226.95
G1 F1379
G1 X173.993 Y157.398 E.0135
G1 X173.593 Y157.398 E.01286
G1 X173.193 Y157.398 E.01286
G1 X172.793 Y157.398 E.01286
G1 X172.393 Y157.398 E.01286
G1 X171.993 Y157.398 E.01286
G1 X171.593 Y157.398 E.01286
G1 X171.193 Y157.398 E.01286
G1 X170.793 Y157.398 E.01286
G1 X170.393 Y157.398 E.01286
G1 X164.602 Y157.398 E.18621
G1 X164.602 Y156.602 E.02559
G1 X172.698 Y156.602 E.26033
G1 X173.098 Y156.602 E.01286
G1 X173.498 Y156.602 E.01286
G1 X173.898 Y156.602 E.01286
G1 X174.298 Y156.602 E.01286
G1 X174.698 Y156.602 E.01286
G1 X175.098 Y156.602 E.01286
G1 X175.498 Y156.602 E.01286
G1 X175.898 Y156.602 E.01286
G1 X175.898 Y156.876 E.00881
G1 X175.898 Y157.276 E.01286
G1 F1363.113
G1 X176.317 Y157.276 E.01349
M106 S229.5
G1 F925.411
G1 X176.7 Y157.276 E.0123
M106 S226.95
; FEATURE: Overhang wall
M106 S229.5
G1 F600
M204 S5000
G1 X185.398 Y157.276 E.27969
G1 X185.398 Y158.724 E.04658
G1 X176.7 Y158.724 E.27969
M106 S226.95
; FEATURE: Inner wall
M106 S229.5
G1 F925.411
M204 S8000
G1 X176.317 Y158.724 E.0123
M106 S226.95
G1 F1363.113
G1 X175.898 Y158.724 E.01349
G1 F1379
G1 X175.898 Y159.124 E.01286
G1 X175.898 Y159.524 E.01286
G1 X175.898 Y159.924 E.01286
G1 X175.898 Y160.324 E.01286
G1 X175.898 Y160.724 E.01286
G1 X175.898 Y161.124 E.01286
G1 X175.898 Y161.524 E.01286
G1 X175.898 Y161.924 E.01286
G1 X175.898 Y162.324 E.01286
G1 X175.898 Y162.724 E.01286
G1 X175.898 Y164.898 E.0699
G1 X175.102 Y164.898 E.02559
G1 X175.102 Y164.528 E.01191
G1 X175.102 Y164.128 E.01286
G1 X175.102 Y163.728 E.01286
G1 X175.102 Y163.328 E.01286
G1 X175.102 Y162.928 E.01286
G1 X175.102 Y162.528 E.01286
G1 X175.102 Y162.128 E.01286
G1 X175.102 Y161.728 E.01286
G1 X175.102 Y161.328 E.01286
G1 X174.682 Y161.228 E.01387
M106 S229.5
G1 F1215.877
G1 X174.565 Y161.2 E.0039
M106 S226.95
M106 S229.5
G1 F1088.388
G1 X174.501 Y161.18 E.00214
M106 S226.95
M106 S229.5
G1 F1021.327
G1 X174.443 Y161.156 E.00202
M106 S226.95
M106 S229.5
G1 F960
G1 X174.387 Y161.126 E.00203
M106 S226.95
M106 S229.5
G1 F600
G1 X174.334 Y161.092 E.00203
M106 S226.95
M106 S229.5
G1 X174.3 Y161.066 E.00137
M106 S226.95
; FEATURE: Overhang wall
M106 S229.5

M204 S5000
G1 X174.282 Y161.052 E.00074
G3 X174.3 Y159.933 I.474 J-.552 E.04108
M106 S226.95
; FEATURE: Inner wall
M106 S229.5
M204 S8000
G1 X174.302 Y159.931 E.00008
M106 S226.95
M106 S229.5
G1 X174.342 Y159.902 E.00161
M106 S226.95
M106 S229.5
G1 X174.385 Y159.874 E.00163
M106 S226.95
M106 S229.5
G1 F840
G1 X174.432 Y159.849 E.00172
M106 S226.95
M106 S229.5
G1 F1106.15
G1 X174.682 Y159.733 E.00888
M106 S226.95
G1 F1379
G1 X175.045 Y159.564 E.01286
G1 X175.408 Y159.395 E.01286
G1 X175.721 Y159.25 E.0111
G1 X175.408 Y159.104 E.0111
G1 X175.045 Y158.936 E.01286
G1 F1281.323
G1 X174.682 Y158.767 E.01286
M106 S229.5
G1 F876.089
G1 X174.433 Y158.651 E.00884
M106 S226.95
M106 S229.5
G1 F642.165
G1 X174.385 Y158.626 E.00176
M106 S226.95
M106 S229.5
G1 F600
G1 X174.343 Y158.599 E.00161
M106 S226.95
M106 S229.5
G1 X174.302 Y158.569 E.00161
M106 S226.95
M106 S229.5
G1 X174.3 Y158.567 E.0001
M106 S226.95
; FEATURE: Overhang wall
M106 S229.5

M204 S5000
G3 X174.055 Y158.2 I.45 J-.566 E.01443
M106 S226.95
; FEATURE: Inner wall
M106 S229.5
M204 S8000
G1 X174.048 Y158.176 E.00079
M106 S226.95
; COOLING_NODE: 0
M204 S250
G1 X173.623 Y157.831 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1284
M204 S5000
G1 X173.621 Y157.79 E.00122
G1 X164.21 Y157.79 E.28033
G1 X164.21 Y156.21 E.04706
G1 X172.29 Y156.21 E.24068
G1 X172.69 Y156.21 E.01191
G1 X173.09 Y156.21 E.01191
G1 X173.49 Y156.21 E.01191
G1 X173.89 Y156.21 E.01191
G1 X174.29 Y156.21 E.01191
G1 X174.69 Y156.21 E.01191
G1 X175.09 Y156.21 E.01191
G1 X175.49 Y156.21 E.01191
G1 X175.89 Y156.21 E.01191
G1 X176.29 Y156.21 E.01191
G1 X176.29 Y156.484 E.00816
G1 X176.29 Y156.884 E.01191
G1 F951.503
G1 X176.331 Y156.884 E.00122
M106 S229.5
G1 F912.73
G1 X176.7 Y156.884 E.01099
M106 S226.95
; FEATURE: Overhang wall
; LINE_WIDTH: 0.45
M106 S229.5
G1 F600
G1 X185.79 Y156.884 E.2923
G1 X185.79 Y159.116 E.0718
G1 X176.7 Y159.116 E.2923
M106 S226.95
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
M106 S229.5
G1 F912.73
G1 X176.331 Y159.116 E.01099
M106 S226.95
M73 P49 R14
G1 F951.503
G1 X176.29 Y159.116 E.00122
G1 F1284
G1 X176.29 Y159.516 E.01191
G1 X176.29 Y159.916 E.01191
G1 X176.29 Y160.316 E.01191
G1 X176.29 Y160.716 E.01191
G1 X176.29 Y161.116 E.01191
G1 X176.29 Y161.516 E.01191
G1 X176.29 Y161.916 E.01191
G1 X176.29 Y162.316 E.01191
G1 X176.29 Y162.716 E.01191
G1 X176.29 Y163.116 E.01191
G1 X176.29 Y163.516 E.01191
G1 X176.29 Y165.29 E.05283
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X175.51 Y165.29 E.02323
G1 X175.11 Y165.29 E.01191
G1 X174.71 Y165.29 E.01191
G1 X174.71 Y164.838 E.01348
G1 X174.71 Y164.438 E.01191
G1 X174.71 Y164.038 E.01191
G1 X174.71 Y163.638 E.01191
G1 X174.71 Y163.238 E.01191
G1 X174.71 Y162.838 E.01191
G1 X174.71 Y162.438 E.01191
G1 X174.71 Y162.038 E.01191
G1 X174.71 Y161.638 E.01191
G1 F900.156
G1 X174.669 Y161.628 E.00125
M106 S229.5
G1 F861.417
G1 X174.46 Y161.578 E.00641
M106 S226.95
M106 S229.5
G1 F676.893
G1 X174.366 Y161.548 E.00293
M106 S226.95
M106 S229.5
G1 F600
G1 X174.3 Y161.521 E.00213
M106 S226.95
; FEATURE: Overhang wall
; LINE_WIDTH: 0.45
M106 S229.5

G3 X174.3 Y159.478 I.455 J-1.021 E.08281
M106 S226.95
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
M106 S229.5
G1 F948.602
G1 X174.669 Y159.307 E.01212
M106 S226.95
G1 F1081.221
G1 X174.791 Y159.25 E.004
G1 X174.669 Y159.193 E.004
M106 S229.5
G1 F1284
G1 X174.3 Y159.022 E.01212
M106 S226.95
; FEATURE: Overhang wall
; LINE_WIDTH: 0.45
M106 S229.5
G1 F600
G3 X173.652 Y158.2 I.472 J-1.039 E.03496
M106 S226.95
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
M106 S229.5
G1 X173.647 Y158.174 E.00078
M106 S226.95
M106 S229.5
G1 X173.638 Y158.096 E.00233
M106 S226.95
M106 S229.5
G1 F766.308
G1 X173.627 Y157.891 E.00613
M106 S226.95
; WIPE_START
M204 S8000
G1 X173.621 Y157.79 E-.03833
G1 X171.722 Y157.79 E-.72167
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X174.175 Y157 Z15.2 F60000
G1 Z14.8
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.431856
G1 F1379
M204 S8000
G1 X164.806 Y157 E.28786
; WIPE_START
G1 F9256.03
G1 X166.806 Y157 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.521 Y162.058 Z15.2 F60000
G1 X175.5 Y164.694 Z15.2
G1 Z14.8
G1 E.8 F1800
; LINE_WIDTH: 0.43173
G1 F1379
M204 S8000
G1 X175.5 Y161.213 E.10692
M204 S10000
G1 X175.287 Y160.41 F60000
; LINE_WIDTH: 0.274122
G1 F1379
M204 S8000
G1 X174.75 Y160.499 E.00995
G1 X174.655 Y160.558 E.00204
; WIPE_START
G1 F15000
G1 X174.75 Y160.499 E-.12925
G1 X175.287 Y160.41 E-.63075
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.287 Y158 Z15.2 F60000
G1 Z14.8
G1 E.8 F1800
; LINE_WIDTH: 0.270143
G1 F1379
M204 S8000
G1 X184.787 Y158 E.17051
; CHANGE_LAYER
; Z_HEIGHT: 15
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F15000
G1 X182.787 Y158 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 75/165
; update layer progress
M73 L75
M991 S0 P74 ;notify layer change

M106 S229.5
; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z15.2 I-.34 J-1.169 P1  F60000
G1 X174.32 Y160.463 Z15.2
G1 Z15
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X174.347 Y160.33 E.00436
G1 X174.412 Y160.222 E.00407
G1 X175.189 Y159.311 E.0385
G1 X175.188 Y160.319 E.03242
G3 X175.17 Y160.622 I-.829 J.103 E.00981
G1 X175.052 Y160.995 E.01257
G3 X174.551 Y160.889 I.07 J-1.582 E.01655
G1 X174.415 Y160.781 E.00561
G1 X174.339 Y160.65 E.00486
G1 X174.316 Y160.522 E.00417
; COOLING_NODE: 0
; WIPE_START
G1 F8843.478
G1 X174.347 Y160.33 E-.07378
G1 X174.412 Y160.222 E-.04805
G1 X175.189 Y159.311 E-.455
G1 X175.188 Y159.793 E-.18318
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z15.4 I1.082 J-.557 P1  F60000
G1 X174.395 Y158.253 Z15.4
G1 Z15
G1 E.8 F1800
G1 F1200
M204 S8000
G1 X174.346 Y158.167 E.00316
G3 X174.314 Y158.031 I.386 J-.161 E.00454
G1 X174.285 Y157.416 E.01978
G1 X175.084 Y157.416 E.02568
G1 X175.084 Y157.562 E.00467
G1 X184.584 Y157.562 E.30549
G1 X184.584 Y158.438 E.02818
G1 X175.189 Y158.438 E.30209
G1 X175.189 Y159.219 E.02509
G1 X174.432 Y158.3 E.03829
; COOLING_NODE: 0
M204 S10000
G1 X173.964 Y158.309 F60000
G1 F1200
M204 S8000
G3 X173.908 Y158.068 I.777 J-.306 E.00799
G1 X173.859 Y157.009 E.03409
G1 X175.491 Y157.009 E.05249
G1 X175.491 Y157.155 E.00467
G1 X184.991 Y157.155 E.30549
G1 X184.991 Y158.845 E.05436
G1 X175.596 Y158.846 E.3021
G1 X175.595 Y160.319 E.04738
G3 X175.491 Y160.958 I-1.381 J.102 E.02101
G1 X175.491 Y161.481 E.01683
G1 X174.59 Y161.33 E.02938
G3 X174.094 Y159.968 I.164 J-.831 E.05591
G1 X174.693 Y159.265 E.02969
G1 X174.696 Y159.261 E.00018
G1 X174.663 Y159.221 E.00167
G1 X174.074 Y158.505 E.02982
G3 X173.988 Y158.364 I.667 J-.502 E.00532
; COOLING_NODE: 0
M204 S10000
G1 X173.507 Y158.129 F60000
G1 F1200
M204 S8000
G1 X173.497 Y158.107 E.0008
G3 X173.489 Y157.818 I1.415 J-.181 E.00931
G1 X173.469 Y157.398 E.01351
G1 X173.069 Y157.398 E.01286
G1 X172.669 Y157.398 E.01286
G1 X172.269 Y157.398 E.01286
G1 X171.869 Y157.398 E.01286
G1 X171.469 Y157.398 E.01286
G1 X171.069 Y157.398 E.01286
G1 X164.602 Y157.398 E.20796
G1 X164.602 Y156.602 E.02559
G1 X173.498 Y156.602 E.28606
G1 X173.898 Y156.602 E.01286
G1 X174.298 Y156.602 E.01286
G1 X174.698 Y156.602 E.01286
G1 X175.098 Y156.602 E.01286
G1 X175.498 Y156.602 E.01286
G1 X175.898 Y156.602 E.01286
G1 X175.898 Y156.747 E.00468
G1 X176.317 Y156.747 E.01349
G1 X185.398 Y156.748 E.29199
G1 X185.398 Y156.856 E.00349
G1 X185.398 Y157.256 E.01286
G1 X185.398 Y157.656 E.01286
G1 X185.398 Y158.056 E.01286
G1 X185.398 Y158.344 E.00925
G1 X185.398 Y158.744 E.01286
G1 X185.398 Y159.144 E.01286
G1 X185.398 Y159.252 E.00349
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X176.317 Y159.253 E.29199
G1 X176.003 Y159.253 E.01011
G1 X176.003 Y159.653 E.01286
G1 X176.002 Y160.053 E.01286
G1 X176.002 Y160.319 E.00858
G1 X175.989 Y160.682 E.01165
G1 X175.898 Y161.021 E.01129
G1 X175.898 Y161.421 E.01286
G1 X175.898 Y161.821 E.01286
G1 X175.898 Y164.898 E.09896
G1 X175.102 Y164.898 E.02559
G1 X175.102 Y164.229 E.02152
G1 X175.102 Y163.829 E.01286
G1 X175.102 Y163.429 E.01286
G1 X175.102 Y163.029 E.01286
G1 X175.102 Y162.629 E.01286
G1 X175.102 Y162.229 E.01286
G1 X175.102 Y161.829 E.01286
G1 X174.682 Y161.758 E.01368
G1 X174.51 Y161.729 E.00564
G3 X173.634 Y159.935 I.246 J-1.231 E.0742
G1 X173.776 Y159.713 E.00846
G1 X174.165 Y159.257 E.01931
G1 X173.748 Y158.75 E.02111
G3 X173.548 Y158.344 I1.164 J-.825 E.01461
G1 X173.518 Y158.188 E.00511
; COOLING_NODE: 0
M204 S250
G1 X173.097 Y157.831 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X173.095 Y157.79 E.00123
G1 X164.21 Y157.79 E.26466
G1 X164.21 Y156.21 E.04706
G1 X171.89 Y156.21 E.22876
G1 X172.29 Y156.21 E.01191
G1 X172.69 Y156.21 E.01191
G1 X173.09 Y156.21 E.01191
G1 X173.49 Y156.21 E.01191
G1 X173.89 Y156.21 E.01191
G1 X174.29 Y156.21 E.01191
G1 X174.69 Y156.21 E.01191
G1 X175.09 Y156.21 E.01191
G1 X175.49 Y156.21 E.01191
G1 X175.89 Y156.21 E.01191
G1 X176.29 Y156.21 E.01191
G1 F1095.541
G1 X176.29 Y156.355 E.00433
G1 F951.503
G1 X176.331 Y156.355 E.00122
G1 F912.73
G1 X176.7 Y156.355 E.01099
; FEATURE: Overhang wall
; LINE_WIDTH: 0.45
G1 F600
G1 X185.79 Y156.356 E.2923
G1 X185.79 Y156.474 E.00379
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F912.73
G1 X185.79 Y156.843 E.01099
G1 F1200
G1 X185.79 Y157.243 E.01191
G1 X185.79 Y157.643 E.01191
G1 X185.79 Y158.043 E.01191
G1 X185.79 Y158.357 E.00937
G1 X185.79 Y158.757 E.01191
G1 X185.79 Y159.157 E.01191
G1 F912.73
G1 X185.79 Y159.526 E.01099
; FEATURE: Overhang wall
; LINE_WIDTH: 0.45
G1 F600
G1 X185.79 Y159.644 E.00379
G1 X176.7 Y159.645 E.2923
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F853.995
G1 X176.395 Y159.645 E.00909
G1 F1200
G1 X176.392 Y160.045 E.01191
G1 X176.388 Y160.642 E.01779
G1 X176.377 Y160.739 E.0029
G1 X176.359 Y160.837 E.00298
G1 X176.332 Y160.948 E.00338
G1 X176.331 Y160.951 E.00011
G1 X176.29 Y161.081 E.00406
G1 X176.29 Y161.481 E.01191
G1 X176.29 Y161.881 E.01191
G1 X176.29 Y162.281 E.01191
G1 X176.29 Y162.681 E.01191
G1 X176.29 Y163.081 E.01191
G1 X176.29 Y163.481 E.01191
G1 X176.29 Y163.881 E.01191
G1 X176.29 Y164.281 E.01191
G1 X176.29 Y165.29 E.03006
G1 X175.91 Y165.29 E.01132
G1 X175.51 Y165.29 E.01191
G1 X175.11 Y165.29 E.01191
G1 X174.71 Y165.29 E.01191
G1 X174.71 Y164.96 E.00982
G1 X174.71 Y164.56 E.01191
G1 X174.71 Y164.16 E.01191
G1 X174.71 Y163.76 E.01191
G1 X174.71 Y163.36 E.01191
G1 X174.71 Y162.96 E.01191
G1 X174.71 Y162.56 E.01191
G1 X174.71 Y162.16 E.01191
G1 F832.831
G1 X174.669 Y162.153 E.00124
G1 F796.076
G1 X174.432 Y162.113 E.00715
G1 F600
G1 X174.32 Y162.087 E.00343
G1 X174.3 Y162.081 E.00063
; FEATURE: Overhang wall
; LINE_WIDTH: 0.45

G3 X173.469 Y159.469 I.451 J-1.582 E.10419
G1 X173.654 Y159.252 E.00914
G3 X173.12 Y158.2 I1.249 J-1.295 E.03865
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 X173.112 Y158.142 E.00175
G1 F805.693
G1 X173.1 Y157.891 E.00748
; WIPE_START
M204 S8000
G1 X173.095 Y157.79 E-.03847
G1 X171.197 Y157.79 E-.72153
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X173.654 Y157 Z15.4 F60000
G1 Z15
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1200
M204 S8000
G1 X164.806 Y157 E.27176
; WIPE_START
G1 F9259.259
G1 X166.806 Y157 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.521 Y162.058 Z15.4 F60000
G1 X175.5 Y164.694 Z15.4
G1 Z15
G1 E.8 F1800
; LINE_WIDTH: 0.43173
G1 F1200
M204 S8000
G1 X175.5 Y161.689 E.09229
; WIPE_START
G1 F9259.021
G1 X175.5 Y163.689 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X174.531 Y158.077 Z15.4 F60000
G1 Z15
G1 E.8 F1800
; LINE_WIDTH: 0.533721
G1 F1200
M204 S8000
G1 X174.765 Y157.994 E.00965
; LINE_WIDTH: 0.560327
G1 X174.769 Y157.992 E.00018
G2 X174.88 Y158.012 I.064 J-.04 E.00518
; LINE_WIDTH: 0.512681
G1 X184.38 Y158 E.35252
; CHANGE_LAYER
; Z_HEIGHT: 15.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F7663.483
G1 X182.38 Y158.003 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 76/165
; update layer progress
M73 L76
M991 S0 P75 ;notify layer change

M106 S226.95
; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z15.4 I-.057 J-1.216 P1  F60000
G1 X174.023 Y158.395 Z15.4
G1 Z15.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1351
M204 S8000
G3 X173.926 Y158.075 I.823 J-.424 E.01079
G1 X173.895 Y157.416 E.02122
G1 X174.037 Y157.416 E.00457
G3 X174.565 Y157.193 I1.128 J1.932 E.01848
G3 X174.781 Y157.172 I.225 J1.172 E.00699
G1 X184.584 Y157.171 E.31522
G1 X184.584 Y158.829 E.0533
G1 X175.58 Y158.829 E.28954
G1 X175.578 Y160.496 E.0536
G3 X175.447 Y160.946 I-.869 J-.008 E.01528
G1 X175.12 Y161.395 E.01787
M73 P50 R14
G3 X174.54 Y161.3 I.351 J-3.978 E.01893
G3 X174.039 Y160.076 I.211 J-.801 E.04929
G1 X174.552 Y159.264 E.03089
G1 X174.054 Y158.446 E.03081
; COOLING_NODE: 0
M204 S10000
G1 X173.571 Y158.359 F60000
G1 F1351
M204 S8000
G3 X173.52 Y158.11 I1.324 J-.403 E.0082
G1 X173.469 Y157.009 E.03542
G1 X173.949 Y157.009 E.01545
G3 X174.772 Y156.764 I.898 J1.514 E.02789
G1 X184.991 Y156.764 E.3286
G1 X184.991 Y159.236 E.07948
G1 X175.987 Y159.236 E.28955
G1 X175.985 Y160.508 E.04092
G3 X175.785 Y161.175 I-1.278 J-.021 E.02267
G1 X175.491 Y161.577 E.01603
G1 X175.491 Y161.865 E.00927
G1 X174.508 Y161.711 E.03198
G3 X173.689 Y159.867 I.247 J-1.214 E.07584
G1 X174.073 Y159.26 E.0231
G1 X173.667 Y158.593 E.02512
G3 X173.59 Y158.416 I1.229 J-.637 E.0062
; COOLING_NODE: 0
M204 S10000
G1 X173.114 Y158.144 F60000
G1 F1351
M204 S8000
G1 X173.079 Y157.398 E.02401
G1 X164.602 Y157.398 E.27259
G1 X164.602 Y156.602 E.02559
G1 X173.861 Y156.602 E.29773
G3 X174.763 Y156.357 I.917 J1.594 E.0304
G1 X185.398 Y156.357 E.34197
G1 X185.398 Y159.643 E.10566
G1 X176.393 Y159.643 E.28956
G3 X176.384 Y160.669 I-8.613 J.432 E.03303
M73 P50 R13
G3 X175.898 Y161.71 I-1.923 J-.264 E.03749
G1 X175.898 Y164.898 E.10251
G1 X175.102 Y164.898 E.02559
G1 X175.102 Y162.216 E.08623
G3 X174.323 Y162.086 I.493 J-5.332 E.02542
G3 X173.34 Y159.658 I.428 J-1.586 E.09747
G1 X173.536 Y159.349 E.01179
G1 X173.594 Y159.256 E.00352
G1 X173.518 Y159.131 E.00471
G3 X173.123 Y158.203 I1.713 J-1.277 E.03273
; COOLING_NODE: 0
M204 S250
G1 X172.707 Y157.831 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1351
M204 S5000
G1 X172.705 Y157.79 E.00122
G1 X164.21 Y157.79 E.25304
G1 X164.21 Y156.21 E.04706
G1 X170.976 Y156.21 E.20154
G1 X171.376 Y156.21 E.01191
G1 X171.776 Y156.21 E.01191
G1 X172.176 Y156.21 E.01191
G1 X172.576 Y156.21 E.01191
G1 X172.976 Y156.21 E.01191
G1 X173.376 Y156.21 E.01191
G1 X173.776 Y156.21 E.01191
G1 X173.866 Y156.169 E.00295
G1 X173.994 Y156.111 E.00417
M106 S229.5
G1 X174.091 Y156.075 E.0031
M106 S226.95
M106 S229.5
G1 X174.193 Y156.043 E.00317
M106 S226.95
M106 S229.5
G1 X174.295 Y156.017 E.00316
M106 S226.95
M106 S229.5
G1 X174.397 Y155.996 E.00309
M106 S226.95
M106 S229.5
G1 X174.574 Y155.973 E.00531
M106 S226.95
M106 S229.5
G1 X174.755 Y155.965 E.0054
M106 S226.95
M106 S229.5
G1 X175.355 Y155.965 E.01787
M106 S226.95
M106 S229.5
G1 X175.97 Y155.965 E.01831
M106 S226.95
M106 S229.5
G1 F1320
G1 X176.584 Y155.965 E.01831
M106 S226.95
M106 S229.5
G1 F1200
G1 X177.199 Y155.965 E.01831
M106 S226.95
M106 S229.5
G1 F1080
G1 X177.814 Y155.965 E.01831
M106 S226.95
M106 S229.5
G1 F960
G1 X178.428 Y155.965 E.01831
M106 S226.95
M106 S229.5
G1 F840
G1 X179.658 Y155.965 E.03662
M106 S226.95
M106 S229.5
G1 F720
G1 X180.272 Y155.965 E.01831
M106 S226.95
M106 S229.5
G1 F600
G1 X180.887 Y155.965 E.01831
M106 S226.95
M106 S229.5
G1 X181.502 Y155.965 E.01831
M106 S226.95
M106 S229.5
G1 X182.117 Y155.965 E.01831
M106 S226.95
M106 S229.5
G1 X182.731 Y155.965 E.01831
M106 S226.95
M106 S229.5
G1 X183.346 Y155.965 E.01831
M106 S226.95
M106 S229.5
G1 X183.961 Y155.965 E.01831
M106 S226.95
M106 S229.5
G1 X184.575 Y155.965 E.01831
M106 S226.95
M106 S229.5
G1 X185.79 Y155.965 E.03618
M106 S226.95
M106 S229.5
G1 F894.624
G1 X185.79 Y156.315 E.01041
M106 S226.95
G1 F1303.718
G1 X185.79 Y156.715 E.01191
G1 F1351
G1 X185.79 Y157.115 E.01191
G1 X185.79 Y157.515 E.01191
G1 X185.79 Y157.915 E.01191
G1 X185.79 Y158.315 E.01191
G1 X185.79 Y158.885 E.017
G1 X185.79 Y159.285 E.01191
G1 F1303.695
G1 X185.79 Y159.685 E.01191
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

M106 S229.5
G1 F894.605
G1 X185.79 Y160.035 E.01041
M106 S226.95
M106 S229.5
G1 F600
G1 X176.785 Y160.035 E.26823
G3 X176.699 Y161.085 I-3.446 J.246 E.03151
M106 S226.95
M106 S229.5
G1 X176.639 Y161.256 E.00539
M106 S226.95
M106 S229.5
G1 X176.599 Y161.35 E.00303
M106 S226.95
M106 S229.5
G1 F1080
G1 X176.553 Y161.444 E.00313
M106 S226.95
M106 S229.5
G1 F1351
G1 X176.502 Y161.536 E.00313
M106 S226.95
M106 S229.5
G1 X176.447 Y161.623 E.00306
M106 S226.95
M106 S229.5
G1 X176.331 Y161.782 E.00585
M106 S226.95
G1 X176.29 Y161.838 E.00207
G1 X176.29 Y162.238 E.01191
G1 X176.29 Y162.638 E.01191
G1 X176.29 Y163.038 E.01191
G1 X176.29 Y163.438 E.01191
G1 X176.29 Y163.838 E.01191
G1 X176.29 Y164.238 E.01191
G1 X176.29 Y164.638 E.01191
G1 X176.29 Y165.038 E.01191
G1 X176.29 Y165.29 E.00751
G1 X175.91 Y165.29 E.01132
G1 X175.51 Y165.29 E.01191
G1 X175.11 Y165.29 E.01191
G1 X174.71 Y165.29 E.01191
G1 X174.71 Y164.952 E.01008
G1 X174.71 Y164.552 E.01191
G1 X174.71 Y164.152 E.01191
G1 X174.71 Y163.752 E.01191
G1 X174.71 Y163.352 E.01191
G1 X174.71 Y162.952 E.01191
G1 F1314.212
G1 X174.71 Y162.552 E.01191
G1 F903.321
G1 X174.669 Y162.545 E.00124
M106 S229.5
G1 F865.095
G1 X174.355 Y162.496 E.00946
M106 S226.95
M106 S229.5
G1 F600
G3 X173.133 Y159.252 I.404 J-2.005 E.12323
G3 X172.723 Y158.177 I1.77 J-1.29 E.03468
M106 S226.95
M106 S229.5
G1 F836.844
G1 X172.71 Y157.891 E.00852
M106 S226.95
; WIPE_START
M204 S8000
G1 X172.705 Y157.79 E-.0384
G1 X170.806 Y157.79 E-.7216
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X173.264 Y157 Z15.6 F60000
G1 Z15.2
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1351
M204 S8000
G1 X164.806 Y157 E.25979
; WIPE_START
G1 F9259.259
G1 X166.806 Y157 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X174.371 Y158.012 Z15.6 F60000
G1 X174.915 Y158.085 Z15.6
G1 Z15.2
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.68794
G1 F1351
M204 S8000
G1 X175.03 Y158.064 E.00598
; LINE_WIDTH: 0.64534
G1 X175.146 Y158.043 E.00558
; LINE_WIDTH: 0.60274
G1 X175.261 Y158.021 E.00519
; LINE_WIDTH: 0.539245
G1 X175.376 Y158 E.0046
G1 X183.695 Y158 E.32614
; WIPE_START
G1 F7253.316
G1 X181.695 Y158 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.083 Y159.267 Z15.6 F60000
G1 Z15.2
G1 E.8 F1800
; LINE_WIDTH: 0.607271
G1 F1351
M204 S8000
G1 X175.104 Y159.138 E.0058
; LINE_WIDTH: 0.565653
G1 X175.125 Y159.01 E.00537
; LINE_WIDTH: 0.524035
G1 X175.146 Y158.882 E.00494
; LINE_WIDTH: 0.482417
G1 X175.167 Y158.753 E.00451
; LINE_WIDTH: 0.420118
G3 X175.254 Y158.482 I.533 J.021 E.0086
G1 X175.376 Y158.437 E.00389
G1 X184.192 Y158.437 E.26266
G1 X184.192 Y157.563 E.02602
G1 X174.797 Y157.564 E.27992
G2 X174.309 Y157.728 I.163 J1.293 E.01545
G1 X174.352 Y158.159 E.0129
G1 X174.707 Y158.757 E.02074
; LINE_WIDTH: 0.440799
G1 X174.775 Y158.849 E.00361
; LINE_WIDTH: 0.482417
G1 X174.843 Y158.941 E.00398
; LINE_WIDTH: 0.524035
G1 X174.911 Y159.034 E.00436
; LINE_WIDTH: 0.565653
G1 X174.98 Y159.126 E.00474
; LINE_WIDTH: 0.607271
G1 X175.048 Y159.218 E.00511
; WIPE_START
G1 F6379.009
G1 X174.98 Y159.126 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.186 Y160.406 Z15.6 F60000
G1 Z15.2
G1 E.8 F1800
; LINE_WIDTH: 0.44493
G1 F1351
M204 S8000
G1 X175.162 Y160.082 E.01031
; LINE_WIDTH: 0.49481
G1 X175.137 Y159.758 E.01159
; LINE_WIDTH: 0.54469
G1 X175.112 Y159.434 E.01287
; LINE_WIDTH: 0.585348
G1 X175.097 Y159.376 E.00258
; LINE_WIDTH: 0.616783
G1 X175.081 Y159.318 E.00273
; LINE_WIDTH: 0.611249
G1 X174.952 Y159.492 E.00974
; LINE_WIDTH: 0.568747
G1 X174.823 Y159.667 E.00901
; LINE_WIDTH: 0.526245
G1 X174.694 Y159.841 E.00829
; LINE_WIDTH: 0.483743
G1 X174.565 Y160.016 E.00756
; LINE_WIDTH: 0.422325
G2 X174.323 Y160.443 I.86 J.77 E.01484
G2 X174.433 Y160.789 I.42 J.056 E.01122
G1 X174.729 Y160.934 E.00988
G1 X174.944 Y160.969 E.00652
G1 X175.127 Y160.677 E.01033
G1 X175.174 Y160.464 E.00653
M204 S10000
G1 X174.776 Y160.433 F60000
; LINE_WIDTH: 0.50158
G1 F1351
M204 S8000
G2 X174.773 Y160.532 I-.029 J.049 E.00852
; WIPE_START
G1 F7848.951
G1 X174.718 Y160.532 E-.18332
G1 X174.69 Y160.482 E-.19223
G1 X174.718 Y160.433 E-.19225
G1 X174.776 Y160.433 E-.1922
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.5 Y162.073 Z15.6 F60000
G1 Z15.2
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.43173
G1 F1351
M204 S8000
G1 X175.5 Y164.694 E.08052
; CHANGE_LAYER
; Z_HEIGHT: 15.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.021
G1 X175.5 Y162.694 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 77/165
; update layer progress
M73 L77
M991 S0 P76 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z15.6 I1.143 J-.417 P1  F60000
G1 X173.584 Y157.443 Z15.6
G1 Z15.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1519
M204 S8000
G3 X174.21 Y156.991 I2.854 J3.297 E.02487
G3 X174.749 Y156.856 I.543 J1.02 E.01803
G1 X184.584 Y156.855 E.31627
G1 X184.584 Y159.145 E.07362
G1 X175.963 Y159.145 E.27721
G1 X175.892 Y160.575 E.04603
G3 X175.565 Y161.303 I-1.149 J-.078 E.02623
G1 X175.151 Y161.709 E.01865
G3 X174.471 Y161.609 I.322 J-4.574 E.02212
G3 X173.731 Y159.979 I.28 J-1.11 E.06609
G1 X174.114 Y159.257 E.02628
G3 X173.686 Y158.421 I6.514 J-3.861 E.0302
G3 X173.609 Y158.076 I1.08 J-.425 E.01142
G1 X173.586 Y157.503 E.01845
; COOLING_NODE: 0
M204 S10000
G1 X173.16 Y157.036 F60000
G1 F1519
M204 S8000
G1 X173.159 Y157.009 E.00087
G1 X173.485 Y157.009 E.01047
G3 X174.373 Y156.495 I1.632 J1.795 E.03324
G3 X174.736 Y156.449 I.402 J1.692 E.01181
G1 X184.991 Y156.448 E.32975
G1 X184.991 Y159.552 E.0998
G1 X176.35 Y159.552 E.27784
G3 X176.29 Y160.687 I-12.569 J-.097 E.03655
G3 X175.857 Y161.588 I-1.577 J-.204 E.0327
G1 X175.491 Y161.945 E.01646
G1 X175.491 Y162.167 E.00712
G1 X174.474 Y162.026 E.03301
G3 X173.367 Y159.796 I.283 J-1.53 E.0928
G1 X173.654 Y159.255 E.01971
G3 X173.284 Y158.507 I3.932 J-2.413 E.02686
G3 X173.202 Y158.106 I1.856 J-.586 E.01321
G1 X173.163 Y157.096 E.03249
; COOLING_NODE: 0
M204 S10000
G1 X172.377 Y157.398 F60000
G1 F1519
M204 S8000
G1 X164.602 Y157.398 E.25002
G1 X164.602 Y156.602 E.02559
G1 X173.35 Y156.602 E.2813
G3 X174.724 Y156.041 I1.446 J1.581 E.04872
G1 X185.398 Y156.041 E.34324
G1 X185.398 Y159.959 E.12598
G1 X176.738 Y159.959 E.27848
G3 X176.661 Y160.93 I-4.924 J.098 E.03137
G3 X175.898 Y162.117 I-2.114 J-.52 E.04621
G1 X175.898 Y164.898 E.08944
G1 X175.102 Y164.898 E.02559
G1 X175.102 Y162.524 E.07634
G3 X174.271 Y162.399 I.416 J-5.595 E.02703
G3 X173.003 Y159.614 I.48 J-1.9 E.11293
G1 X173.195 Y159.253 E.01313
G3 X172.796 Y158.135 I2.322 J-1.458 E.03847
G1 X172.767 Y157.398 E.02372
G1 X172.437 Y157.398 E.01061
; COOLING_NODE: 0
M204 S250
G1 X172.392 Y157.831 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1423
M204 S5000
G1 X172.39 Y157.79 E.00122
G1 X164.21 Y157.79 E.24366
G1 X164.21 Y156.21 E.04706
G1 X168.82 Y156.21 E.13731
G1 X169.22 Y156.21 E.01191
M73 P51 R13
G1 X169.62 Y156.21 E.01191
G1 X170.02 Y156.21 E.01191
G1 X170.42 Y156.21 E.01191
G1 X170.82 Y156.21 E.01191
G1 X171.22 Y156.21 E.01191
G1 X171.62 Y156.21 E.01191
G1 X172.02 Y156.21 E.01191
G1 X172.42 Y156.21 E.01191
G1 X172.82 Y156.21 E.01191
G1 X173.22 Y156.21 E.01191
G1 F1216.688
G1 X173.275 Y156.169 E.00204
M106 S229.5
G1 F1143.659
G1 X173.408 Y156.07 E.00495
M106 S226.95
M106 S229.5
G1 F976.135
G1 X173.547 Y155.98 E.00491
M106 S226.95
M106 S229.5
G1 F822.957
G1 X173.651 Y155.922 E.00357
M106 S226.95
M106 S229.5
G1 F720
G3 X174.712 Y155.649 I1.106 J2.106 E.03291
G1 X185.79 Y155.649 E.32998
M106 S226.95
M106 S229.5
G1 F966.867
G1 X185.79 Y155.924 E.00819
M106 S226.95
G1 F1390.638
G1 X185.79 Y156.324 E.01191
G1 F1423
G1 X185.79 Y156.724 E.01191
G1 X185.79 Y157.124 E.01191
G1 X185.79 Y157.524 E.01191
G1 X185.79 Y157.924 E.01191
G1 X185.79 Y158.324 E.01191
G1 X185.79 Y158.876 E.01644
G1 X185.79 Y159.276 E.01191
G1 X185.79 Y159.676 E.01191
G1 F1390.673
G1 X185.79 Y160.076 E.01191
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

M106 S229.5
G1 F966.896
G1 X185.79 Y160.351 E.00819
M106 S226.95
M106 S229.5
G1 F720
G1 X177.511 Y160.351 E.24661
M106 S226.95
M106 S229.5
G1 X177.111 Y160.351 E.01191
M106 S226.95
M106 S229.5
G1 F600
G1 X177.095 Y160.661 E.00925
M106 S226.95
M106 S229.5
G1 F720
G3 X176.59 Y161.963 I-2.362 J-.168 E.04223
M106 S226.95
M106 S229.5
G1 F824.116
G1 X176.512 Y162.056 E.0036
M106 S226.95
M106 S229.5
G1 F936.552
G1 X176.429 Y162.146 E.00364
M106 S226.95
M106 S229.5
G1 F1071.042
G1 X176.331 Y162.242 E.00408
M106 S226.95
G1 F1129.977
G1 X176.29 Y162.282 E.00171
G1 F1423
G1 X176.29 Y162.682 E.01191
G1 X176.29 Y163.082 E.01191
G1 X176.29 Y163.482 E.01191
G1 X176.29 Y163.882 E.01191
G1 X176.29 Y164.282 E.01191
G1 X176.29 Y164.682 E.01191
G1 X176.29 Y165.082 E.01191
G1 X176.29 Y165.29 E.00621
G1 X175.89 Y165.29 E.01191
G1 X175.49 Y165.29 E.01191
G1 X175.11 Y165.29 E.01132
G1 X174.71 Y165.29 E.01191
G1 X174.71 Y164.866 E.01264
G1 X174.71 Y164.466 E.01191
G1 X174.71 Y164.066 E.01191
G1 X174.71 Y163.666 E.01191
G1 X174.71 Y163.266 E.01191
G1 X174.71 Y162.866 E.01191
G1 F1069.076
G1 X174.669 Y162.86 E.00123
M106 S229.5
G1 F1027.568
G1 X174.335 Y162.814 E.01004
M106 S226.95
M106 S229.5
G1 F720
G3 X172.752 Y159.251 I.422 J-2.321 E.13669
G3 X172.405 Y158.163 I2.159 J-1.288 E.03432
M106 S226.95
M106 S229.5
G1 F964.055
G1 X172.394 Y157.891 E.00811
M106 S226.95
; WIPE_START
M204 S8000
G1 X172.39 Y157.79 E-.03839
G1 X170.491 Y157.79 E-.72161
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.955 Y157 Z15.8 F60000
G1 Z15.4
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1519
M204 S8000
G1 X164.806 Y157 E.25029
; WIPE_START
G1 F9259.259
G1 X166.806 Y157 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X174.389 Y157.868 Z15.8 F60000
G1 X175.606 Y158.007 Z15.8
G1 Z15.4
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.417119
G1 F1519
M204 S8000
G1 X183.379 Y158 E.22976
; WIPE_START
G1 F9620.567
G1 X181.379 Y158.002 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.01 Y158.533 Z15.8 F60000
G1 Z15.4
G1 E.8 F1800
; LINE_WIDTH: 0.396825
G1 F1519
M204 S8000
G1 X175.125 Y158.278 E.00783
G1 X175.606 Y158.007 E.01542
G2 X174.752 Y157.993 I-.528 J5.913 E.02389
G1 X174.984 Y158.479 E.01505
; WIPE_START
G1 F10172.244
G1 X174.752 Y157.993 E-.20455
G1 X175.006 Y157.984 E-.09653
G1 X175.606 Y158.007 E-.22812
G1 X175.125 Y158.278 E-.20961
G1 X175.102 Y158.329 E-.02119
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.182 Y159.603 Z15.8 F60000
G1 Z15.4
G1 E.8 F1800
; LINE_WIDTH: 0.417939
G1 F1519
M204 S8000
G1 X175.206 Y158.919 E.02028
G1 X175.376 Y158.536 E.01243
G1 X175.672 Y158.384 E.00986
G1 X183.815 Y158.376 E.24121
G1 X183.815 Y157.624 E.02225
G1 X174.797 Y157.625 E.26714
G1 X174.58 Y157.673 E.00658
G1 X174.368 Y157.825 E.00773
G1 X174.44 Y158.216 E.01175
G1 X174.842 Y158.991 E.02588
G1 X174.873 Y159.379 E.01154
G1 X174.456 Y160.278 E.02935
G1 X174.389 Y160.525 E.00758
G1 X174.491 Y160.74 E.00703
G1 X174.74 Y160.876 E.00841
G1 X174.864 Y160.893 E.0037
G1 X175.068 Y160.671 E.00895
G1 X175.125 Y160.458 E.00652
G1 X175.178 Y159.663 E.02359
M204 S10000
G1 X175.502 Y160.477 F60000
; LINE_WIDTH: 0.41999
G1 F1519
M204 S8000
G1 X175.582 Y158.932 E.0461
G1 X175.638 Y158.806 E.0041
G1 X175.77 Y158.753 E.00422
G1 X184.192 Y158.753 E.25085
G1 X184.192 Y157.247 E.04484
G1 X174.773 Y157.248 E.28054
G1 X174.399 Y157.339 E.01148
G1 X173.984 Y157.638 E.01524
G1 X174.016 Y158.092 E.01357
G1 X174.127 Y158.431 E.01062
G1 X174.511 Y159.171 E.02482
G1 X174.512 Y159.344 E.00515
G1 X174.041 Y160.262 E.03074
G1 X174.005 Y160.563 E.00901
G1 X174.108 Y160.881 E.00997
G1 X174.319 Y161.11 E.00924
G1 X174.713 Y161.253 E.01249
G1 X175.007 Y161.293 E.00886
G1 X175.401 Y160.866 E.01731
G1 X175.487 Y160.535 E.01017
; WIPE_START
G1 F9547.309
G1 X175.401 Y160.866 E-.12977
G1 X175.007 Y161.293 E-.22084
G1 X174.713 Y161.253 E-.11298
G1 X174.319 Y161.11 E-.15928
G1 X174.108 Y160.881 E-.11792
G1 X174.093 Y160.833 E-.01922
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.5 Y162.374 Z15.8 F60000
G1 Z15.4
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.43173
G1 F1519
M204 S8000
G1 X175.5 Y164.694 E.07128
; CHANGE_LAYER
; Z_HEIGHT: 15.6
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F9259.021
G1 X175.5 Y162.694 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 78/165
; update layer progress
M73 L78
M991 S0 P77 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z15.8 I1.091 J-.538 P1  F60000
G1 X173.425 Y158.487 Z15.8
G1 Z15.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1431
M204 S8000
G3 X173.34 Y158.073 I1.351 J-.492 E.01361
G1 X173.322 Y157.402 E.02161
G3 X173.905 Y156.87 I4.03 J3.836 E.0254
G3 X174.695 Y156.59 I.875 J1.213 E.02732
G1 X184.584 Y156.588 E.31798
G1 X184.584 Y159.412 E.09081
G1 X176.325 Y159.412 E.26557
G1 X176.145 Y160.715 E.04232
G3 X175.666 Y161.574 I-1.424 J-.232 E.03227
G1 X175.18 Y161.976 E.02027
G3 X174.429 Y161.874 I.358 J-5.471 E.02439
G3 X173.461 Y159.924 I.324 J-1.376 E.07991
G1 X173.772 Y159.255 E.02371
G3 X173.447 Y158.542 I6.931 J-3.586 E.0252
; COOLING_NODE: 0
M204 S10000
G1 X172.977 Y158.407 F60000
G1 F1431
M204 S8000
G3 X172.934 Y158.097 I1.935 J-.429 E.01008
G1 X172.903 Y157.009 E.035
G1 X173.146 Y157.009 E.00781
G3 X173.873 Y156.407 I2.518 J2.3 E.03046
G3 X174.683 Y156.183 I.913 J1.723 E.02722
G1 X184.991 Y156.181 E.33147
G1 X184.991 Y159.819 E.11699
G1 X176.68 Y159.819 E.26725
G3 X176.53 Y160.873 I-12.07 J-1.176 E.03424
G3 X175.932 Y161.882 I-1.791 J-.379 E.03841
G1 X175.491 Y162.247 E.01842
G1 X175.491 Y162.425 E.00573
G1 X174.46 Y162.295 E.03341
G3 X173.088 Y159.761 I.298 J-1.8 E.10684
G1 X173.323 Y159.254 E.01798
G3 X172.994 Y158.465 I3.516 J-1.932 E.02755
; COOLING_NODE: 0
M204 S10000
G1 X172.532 Y158.164 F60000
G1 F1431
M204 S8000
G1 X172.527 Y158.121 E.0014
G1 X172.507 Y157.398 E.02325
G1 X164.602 Y157.398 E.25419
G1 X164.602 Y156.602 E.02559
G1 X172.986 Y156.602 E.26961
G3 X174.67 Y155.776 I1.848 J1.636 E.06187
G1 X185.398 Y155.774 E.34496
G1 X185.398 Y160.226 E.14318
G1 X177.035 Y160.226 E.26893
G3 X176.832 Y161.287 I-4.453 J-.3 E.03483
G3 X175.898 Y162.439 I-2.368 J-.966 E.04838
G1 X175.898 Y164.898 E.07907
G1 X175.102 Y164.898 E.02559
G1 X175.102 Y162.787 E.06789
G3 X174.244 Y162.667 I.43 J-6.251 E.02789
G3 X172.715 Y159.598 I.51 J-2.169 E.12583
G1 X172.875 Y159.252 E.01225
G3 X172.562 Y158.384 I2.419 J-1.363 E.02981
G1 X172.54 Y158.223 E.00522
; COOLING_NODE: 0
M204 S250
G1 X172.127 Y157.831 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1431
M204 S5000
G1 X172.126 Y157.79 E.00122
G1 X164.21 Y157.79 E.23579
G1 X164.21 Y156.21 E.04706
G1 X169.233 Y156.21 E.14961
G1 X169.633 Y156.21 E.01191
G1 X170.033 Y156.21 E.01191
G1 X170.433 Y156.21 E.01191
G1 X170.833 Y156.21 E.01191
G1 X171.233 Y156.21 E.01191
G1 X171.633 Y156.21 E.01191
G1 X172.033 Y156.21 E.01191
G1 X172.433 Y156.21 E.01191
G1 X172.833 Y156.21 E.01191
G1 X172.877 Y156.169 E.0018
M106 S229.5
G1 X173.041 Y156.016 E.00668
M106 S226.95
M106 S229.5
G1 X173.182 Y155.903 E.00539
M106 S226.95
M106 S229.5
G1 F1320
G3 X174.658 Y155.384 I1.617 J2.238 E.04726
G1 X185.79 Y155.382 E.33157
M106 S226.95
M106 S229.5
G1 F1431
G1 X185.79 Y155.608 E.00674
M106 S226.95
G1 X185.79 Y156.008 E.01191
G1 X185.79 Y156.408 E.01191
G1 X185.79 Y156.808 E.01191
G1 X185.79 Y157.208 E.01191
G1 X185.79 Y157.608 E.01191
G1 X185.79 Y158.008 E.01191
G1 X185.79 Y158.392 E.01144
G1 X185.79 Y158.792 E.01191
G1 X185.79 Y159.192 E.01191
G1 X185.79 Y159.592 E.01191
G1 X185.79 Y159.992 E.01191
G1 X185.79 Y160.392 E.01191
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

M106 S229.5
G1 X185.79 Y160.618 E.00674
M106 S226.95
M106 S229.5
G1 F1320
G1 X177.376 Y160.618 E.25061
G3 X176.556 Y162.396 I-2.731 J-.182 E.05963
M106 S226.95
M106 S229.5
G1 F1431
G1 X176.455 Y162.487 E.00405
M106 S226.95
M106 S229.5
G1 X176.331 Y162.59 E.0048
M106 S226.95
G1 X176.29 Y162.623 E.00158
G1 X176.29 Y163.023 E.01191
G1 X176.29 Y163.423 E.01191
G1 X176.29 Y163.823 E.01191
G1 X176.29 Y164.223 E.01191
G1 X176.29 Y164.623 E.01191
G1 X176.29 Y165.023 E.01191
G1 X176.29 Y165.29 E.00794
G1 X175.89 Y165.29 E.01191
G1 X175.49 Y165.29 E.01191
G1 X175.11 Y165.29 E.01132
G1 X174.71 Y165.29 E.01191
G1 X174.71 Y164.732 E.01661
G1 X174.71 Y164.332 E.01191
G1 X174.71 Y163.932 E.01191
G1 X174.71 Y163.532 E.01191
G1 X174.71 Y163.132 E.01191
G1 X174.669 Y163.127 E.00123
M106 S229.5
G1 X174.333 Y163.085 E.0101
M106 S226.95
M106 S229.5
G1 F1320
G3 X172.444 Y159.251 I.425 J-2.592 E.14871
G3 X172.136 Y158.143 I2.444 J-1.276 E.03449
M106 S226.95
M106 S229.5
G1 F1431
G1 X172.129 Y157.891 E.00752
M106 S226.95
; WIPE_START
G1 F1619.466
M204 S8000
G1 X172.126 Y157.79 E-.03839
G1 X170.227 Y157.79 E-.72161
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.699 Y157 Z16 F60000
G1 Z15.6
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1431
M204 S8000
G1 X164.806 Y157 E.24243
; WIPE_START
G1 F9259.259
G1 X166.806 Y157 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X174.365 Y158.056 Z16 F60000
G1 X175.14 Y158.165 Z16
G1 Z15.6
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.6455
G1 F1431
M204 S8000
G2 X175.147 Y158.282 I-.034 J.061 E.01435
; WIPE_START
G1 F5974.31
G1 X175.064 Y158.295 E-.20602
G1 X175.027 Y158.23 E-.18466
G1 X175.064 Y158.165 E-.18466
G1 X175.14 Y158.165 E-.18466
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.152 Y159.704 Z16 F60000
G1 Z15.6
G1 E.8 F1800
; LINE_WIDTH: 0.389815
G1 F1431
M204 S8000
G3 X175.279 Y158.858 I6.464 J.541 E.02347
G1 X175.46 Y158.564 E.00944
; LINE_WIDTH: 0.44093
G1 X175.719 Y158.402 E.00962
; LINE_WIDTH: 0.495562
G1 X175.978 Y158.239 E.01094
G1 X176.148 Y158.228 E.00612
G1 X183.399 Y158.227 E.25926
G1 X183.399 Y157.773 E.01623
G1 X176.148 Y157.777 E.25926
; LINE_WIDTH: 0.475963
G1 X175.625 Y157.758 E.01791
; LINE_WIDTH: 0.422491
M73 P52 R13
G2 X174.679 Y157.756 I-.486 J6.402 E.02839
G1 X174.482 Y157.889 E.00712
G1 X174.551 Y158.201 E.00959
G1 X174.848 Y158.867 E.02188
; LINE_WIDTH: 0.377719
G1 X174.902 Y159.087 E.00599
G1 X174.864 Y159.537 E.01194
; LINE_WIDTH: 0.378945
G1 X174.767 Y159.816 E.00784
; LINE_WIDTH: 0.418055
G1 X174.67 Y160.095 E.00875
; LINE_WIDTH: 0.471602
G2 X174.53 Y160.559 I2.187 J.914 E.01644
G1 X174.633 Y160.69 E.00565
G1 X174.82 Y160.747 E.0066
G1 X174.984 Y160.519 E.00951
; LINE_WIDTH: 0.458962
G1 X175.036 Y160.267 E.00845
; LINE_WIDTH: 0.423445
G1 X175.088 Y160.015 E.00773
; LINE_WIDTH: 0.387929
G1 X175.14 Y159.763 E.00701
M204 S10000
G1 X175.379 Y160.617 F60000
; LINE_WIDTH: 0.41999
G1 F1431
M204 S8000
G1 X175.588 Y159.13 E.04474
G3 X175.735 Y158.822 I.56 J.079 E.01032
G1 X176.05 Y158.651 E.01067
G1 X176.148 Y158.643 E.00293
G1 X183.815 Y158.643 E.22835
G1 X183.815 Y157.358 E.03828
G1 X174.705 Y157.363 E.27133
G1 X174.449 Y157.454 E.0081
G1 X174.1 Y157.728 E.01321
G1 X174.162 Y158.223 E.01484
G1 X174.51 Y159.022 E.02595
G1 X174.556 Y159.335 E.00943
G1 X174.201 Y160.215 E.02826
G1 X174.114 Y160.522 E.00951
G1 X174.21 Y160.837 E.00981
G1 X174.409 Y161.028 E.00822
G2 X174.944 Y161.171 I.538 J-.941 E.01669
G1 X175.202 Y160.931 E.01048
G1 X175.35 Y160.669 E.00896
M204 S10000
G1 X175.763 Y160.598 F60000
G1 F1431
M204 S8000
G1 X175.962 Y159.182 E.0426
G1 X176.011 Y159.08 E.00339
G1 X176.148 Y159.02 E.00447
G1 X184.192 Y159.02 E.23958
G1 X184.192 Y156.98 E.06075
G1 X174.662 Y156.986 E.28385
G1 X174.394 Y157.048 E.00818
G2 X173.718 Y157.568 I1.215 J2.279 E.02552
G1 X173.75 Y158.114 E.01627
G1 X173.864 Y158.514 E.0124
G1 X174.167 Y159.178 E.02174
G1 X174.169 Y159.33 E.00454
G1 X173.753 Y160.301 E.03146
G1 X173.754 Y160.663 E.01076
G1 X173.888 Y161.039 E.01188
G2 X174.682 Y161.518 I.934 J-.651 E.02847
G1 X175.06 Y161.566 E.01134
G1 X175.508 Y161.152 E.01814
G1 X175.685 Y160.9 E.00919
G1 X175.748 Y160.656 E.00749
; WIPE_START
G1 F9547.299
G1 X175.685 Y160.9 E-.09556
G1 X175.508 Y161.152 E-.11723
G1 X175.06 Y161.566 E-.23149
G1 X174.682 Y161.518 E-.14463
G1 X174.319 Y161.421 E-.14271
G1 X174.257 Y161.38 E-.02839
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.5 Y162.632 Z16 F60000
G1 Z15.6
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.43173
G1 F1431
M204 S8000
G1 X175.5 Y164.694 E.06335
; CHANGE_LAYER
; Z_HEIGHT: 15.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.021
G1 X175.5 Y162.694 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 79/165
; update layer progress
M73 L79
M991 S0 P78 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z16 I1.066 J-.586 P1  F60000
G1 X173.192 Y158.496 Z16
G1 Z15.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1542
M204 S8000
G1 X173.163 Y158.424 E.00251
G3 X173.11 Y158.086 I2.129 J-.509 E.01101
G1 X173.091 Y157.371 E.023
G3 X173.678 Y156.756 I4.542 J3.749 E.02736
G3 X174.687 Y156.359 I1.083 J1.272 E.0355
G1 X184.584 Y156.357 E.31825
G1 X184.584 Y159.643 E.10566
G1 X176.607 Y159.643 E.25652
G1 X176.353 Y160.86 E.03996
G3 X175.754 Y161.8 I-1.623 J-.373 E.03656
G1 X175.198 Y162.208 E.02219
G3 X174.376 Y162.099 I.342 J-5.718 E.02666
G3 X173.227 Y159.884 I.375 J-1.6 E.09113
G1 X173.493 Y159.256 E.02191
G1 X173.214 Y158.552 E.02435
; COOLING_NODE: 0
M204 S10000
G1 X172.757 Y158.429 F60000
G1 F1542
M204 S8000
G1 X172.711 Y158.213 E.0071
G1 X172.675 Y157.009 E.03873
G1 X172.872 Y157.009 E.00635
G3 X173.577 Y156.319 I3.409 J2.777 E.03178
G3 X174.675 Y155.952 I1.189 J1.729 E.03771
G1 X184.991 Y155.95 E.33173
G1 X184.991 Y160.05 E.13185
G1 X176.938 Y160.05 E.25896
G3 X176.723 Y161.057 I-11.467 J-1.921 E.03312
G3 X176.003 Y162.122 I-1.984 J-.565 E.04202
G1 X175.491 Y162.498 E.02043
G1 X175.491 Y162.654 E.00503
G1 X174.422 Y162.523 E.03462
G3 X172.849 Y159.734 I.337 J-2.028 E.11806
G1 X173.051 Y159.254 E.01673
G3 X172.804 Y158.63 I3.102 J-1.59 E.02162
G1 X172.771 Y158.488 E.00471
; COOLING_NODE: 0
M204 S10000
G1 X172.301 Y158.169 F60000
G1 F1542
M204 S8000
G1 X172.296 Y158.128 E.00131
G1 X172.278 Y157.398 E.0235
G1 X164.602 Y157.398 E.24682
G1 X164.602 Y156.602 E.02559
G1 X172.696 Y156.602 E.26026
G3 X173.936 Y155.682 I2.355 J1.879 E.05022
G3 X174.662 Y155.545 I.833 J2.417 E.02384
G1 X185.398 Y155.543 E.34522
G1 X185.398 Y160.457 E.15803
G1 X177.269 Y160.457 E.26141
G3 X176.864 Y161.753 I-3.899 J-.507 E.04386
G3 X175.898 Y162.704 I-2.529 J-1.602 E.04398
G1 X175.898 Y164.898 E.07054
G1 X175.102 Y164.898 E.02559
G1 X175.102 Y163.017 E.06049
G3 X174.191 Y162.892 I.402 J-6.343 E.0296
G3 X172.47 Y159.583 I.561 J-2.394 E.13614
G1 X172.61 Y159.253 E.01155
G3 X172.325 Y158.383 I2.546 J-1.317 E.02956
G1 X172.307 Y158.228 E.005
; COOLING_NODE: 0
M204 S250
G1 X171.897 Y157.831 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1539
M204 S5000
G1 X171.895 Y157.79 E.00122
G1 X164.21 Y157.79 E.22892
G1 X164.21 Y156.21 E.04706
G1 X168.926 Y156.21 E.14047
G1 X169.326 Y156.21 E.01191
G1 X169.726 Y156.21 E.01191
G1 X170.126 Y156.21 E.01191
G1 X170.526 Y156.21 E.01191
G1 X170.926 Y156.21 E.01191
G1 X171.326 Y156.21 E.01191
G1 X171.726 Y156.21 E.01191
G1 X172.126 Y156.21 E.01191
G1 X172.526 Y156.21 E.01191
G1 X172.564 Y156.169 E.00167
M106 S229.5
G1 X172.745 Y155.976 E.00787
M106 S226.95
M106 S229.5
G3 X174.65 Y155.153 I2.053 J2.133 E.06317
G1 X185.79 Y155.151 E.33181
M106 S226.95
M106 S229.5
G1 X185.79 Y155.341 E.00566
M106 S226.95
G1 X185.79 Y155.741 E.01191
G1 X185.79 Y156.141 E.01191
G1 X185.79 Y156.541 E.01191
G1 X185.79 Y156.941 E.01191
G1 X185.79 Y157.341 E.01191
G1 X185.79 Y157.741 E.01191
G1 X185.79 Y158.141 E.01191
G1 X185.79 Y158.659 E.01545
G1 X185.79 Y159.059 E.01191
G1 X185.79 Y159.459 E.01191
G1 X185.79 Y159.859 E.01191
G1 X185.79 Y160.259 E.01191
G1 X185.79 Y160.659 E.01191
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

M106 S229.5
G1 X185.79 Y160.849 E.00566
M106 S226.95
M106 S229.5
G1 X177.587 Y160.849 E.24433
G3 X176.492 Y162.755 I-2.885 J-.391 E.06712
M106 S226.95
M106 S229.5
G1 X176.331 Y162.873 E.00596
M106 S226.95
G1 X176.29 Y162.903 E.00151
G1 X176.29 Y163.303 E.01191
G1 X176.29 Y163.703 E.01191
G1 X176.29 Y164.103 E.01191
G1 X176.29 Y164.503 E.01191
G1 X176.29 Y164.903 E.01191
G1 X176.29 Y165.29 E.01153
G1 X175.89 Y165.29 E.01191
G1 X175.49 Y165.29 E.01191
G1 X175.11 Y165.29 E.01132
G1 X174.71 Y165.29 E.01191
G1 X174.71 Y164.964 E.00972
G1 X174.71 Y164.564 E.01191
G1 X174.71 Y164.164 E.01191
G1 X174.71 Y163.764 E.01191
G1 X174.71 Y163.364 E.01191
G1 X174.669 Y163.359 E.00123
M106 S229.5
G3 X172.185 Y159.251 I.106 J-2.869 E.16932
G3 X171.905 Y158.149 I2.719 J-1.279 E.03408
M106 S226.95
M106 S229.5
G1 X171.898 Y157.891 E.00768
M106 S226.95
; WIPE_START
G1 F2160
M204 S8000
G1 X171.895 Y157.79 E-.03839
G1 X169.997 Y157.79 E-.72161
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.471 Y157 Z16.2 F60000
G1 Z15.8
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1542
M204 S8000
G1 X164.806 Y157 E.23542
; WIPE_START
G1 F9259.259
G1 X166.806 Y157 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z16.2 I-.487 J1.115 P1  F60000
G1 X174.757 Y160.468 Z16.2
G1 Z15.8
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.615734
G1 F1542
M204 S8000
G1 X174.828 Y160.242 E.01075
; LINE_WIDTH: 0.57336
G1 X174.899 Y160.015 E.00995
; LINE_WIDTH: 0.528718
G1 X174.97 Y159.788 E.00912
G1 X175.08 Y159.205 E.02279
; WIPE_START
G1 F7410.491
G1 X174.97 Y159.788 E-.54282
G1 X174.899 Y160.015 E-.21718
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.969 Y160.732 Z16.2 F60000
G1 Z15.8
G1 E.8 F1800
; LINE_WIDTH: 0.41999
G1 F1542
M204 S8000
G1 X176.258 Y159.4 E.04061
G1 X176.363 Y159.269 E.00499
G1 X176.443 Y159.251 E.00243
G1 X184.192 Y159.251 E.23081
G1 X184.192 Y156.749 E.07451
G1 X174.64 Y156.756 E.2845
G1 X174.168 Y156.897 E.0147
G2 X173.487 Y157.521 I1.867 J2.715 E.0276
G1 X173.501 Y158.048 E.01569
G1 X173.635 Y158.574 E.01616
G1 X173.888 Y159.185 E.0197
G1 X173.887 Y159.33 E.00433
G1 X173.598 Y160.014 E.02212
G1 X173.511 Y160.398 E.01172
G1 X173.545 Y160.823 E.0127
G2 X174.143 Y161.59 I1.338 J-.427 E.02958
G2 X175.093 Y161.799 I1.084 J-2.669 E.0291
G1 X175.498 Y161.502 E.01495
G1 X175.826 Y161.132 E.01474
G1 X175.949 Y160.788 E.01086
M204 S10000
G1 X175.751 Y159.958 F60000
; LINE_WIDTH: 0.41999
G1 F1542
M204 S8000
G1 X175.89 Y159.319 E.01947
G1 X176.024 Y159.059 E.00871
G1 X176.204 Y158.927 E.00666
G1 X176.443 Y158.874 E.00728
G1 X183.815 Y158.874 E.21958
G1 X183.815 Y157.127 E.05204
G1 X174.668 Y157.133 E.27243
G1 X174.347 Y157.232 E.01001
G2 X173.868 Y157.666 I1.263 J1.877 E.01932
G1 X173.914 Y158.181 E.01538
G2 X174.277 Y159.211 I285.737 J-99.954 E.03255
G1 X174.234 Y159.477 E.00802
G1 X173.954 Y160.14 E.02144
G1 X173.881 Y160.507 E.01114
G1 X173.95 Y160.819 E.00952
G1 X174.136 Y161.112 E.01035
G1 X174.438 Y161.3 E.0106
G1 X174.992 Y161.405 E.01679
G1 X175.349 Y161.101 E.01395
G1 X175.544 Y160.842 E.00967
G1 X175.737 Y160.016 E.02526
M204 S10000
G1 X175.383 Y159.878 F60000
; LINE_WIDTH: 0.41999
G1 F1542
M204 S8000
G1 X175.521 Y159.239 E.01947
G3 X175.745 Y158.806 I.921 J.2 E.01469
G1 X176.045 Y158.585 E.0111
G1 X176.443 Y158.497 E.01214
G1 X183.438 Y158.497 E.20835
G1 X183.438 Y157.504 E.02957
G1 X174.696 Y157.51 E.26037
G1 X174.471 Y157.61 E.00734
G1 X174.249 Y157.811 E.00893
G1 X174.312 Y158.238 E.01284
G1 X174.584 Y158.897 E.02124
G1 X174.653 Y159.181 E.00872
G1 X174.586 Y159.613 E.01302
G1 X174.31 Y160.266 E.0211
G1 X174.266 Y160.533 E.00806
G1 X174.322 Y160.732 E.00618
G1 X174.514 Y160.925 E.00809
G1 X174.892 Y161.011 E.01154
G1 X175.188 Y160.715 E.01249
G1 X175.369 Y159.936 E.0238
M204 S10000
G1 X175.092 Y159.146 F60000
; LINE_WIDTH: 0.524849
G1 F1542
M204 S8000
G1 X175.161 Y159.023 E.00538
; LINE_WIDTH: 0.482905
G1 X175.231 Y158.9 E.00492
; LINE_WIDTH: 0.422704
G3 X175.466 Y158.553 I1.628 J.845 E.0126
G1 X175.886 Y158.244 E.01565
; LINE_WIDTH: 0.400968
G1 X176.164 Y158.2 E.00796
; LINE_WIDTH: 0.350018
G1 X176.442 Y158.156 E.00683
G1 X183.095 Y158.155 E.1614
G1 X183.095 Y157.847 E.00747
G1 X176.443 Y157.85 E.16138
; LINE_WIDTH: 0.366083
G1 X176.124 Y157.868 E.00813
; LINE_WIDTH: 0.416728
G2 X174.695 Y157.913 I3.071 J118.188 E.04224
G1 X174.638 Y157.955 E.00209
G1 X174.802 Y158.437 E.01504
; LINE_WIDTH: 0.432838
G1 X174.911 Y158.684 E.00832
; LINE_WIDTH: 0.458533
G1 X175.019 Y158.932 E.00886
; LINE_WIDTH: 0.48999
G1 X175.046 Y159.01 E.00293
; LINE_WIDTH: 0.52721
G1 X175.072 Y159.089 E.00318
M204 S10000
G1 X175.197 Y158.239 F60000
; LINE_WIDTH: 0.46262
G1 F1542
M204 S8000
G2 X175.189 Y158.33 I-.026 J.044 E.00684
; WIPE_START
G1 F8577.555
G1 X175.144 Y158.33 E-.16873
G1 X175.118 Y158.285 E-.19709
G1 X175.144 Y158.239 E-.19709
G1 X175.197 Y158.239 E-.19709
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.5 Y162.861 Z16.2 F60000
G1 Z15.8
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.431739
G1 F1542
M204 S8000
G1 X175.5 Y164.694 E.05632
; CHANGE_LAYER
; Z_HEIGHT: 16
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9258.807
G1 X175.5 Y162.861 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 80/165
; update layer progress
M73 L80
M991 S0 P79 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z16.2 I1.1 J-.521 P1  F60000
G1 X172.888 Y157.35 Z16.2
G1 Z16
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1591
M204 S8000
G1 X173.387 Y156.757 E.02493
G3 X174.769 Y156.154 I1.371 J1.259 E.0499
G1 X176.357 Y156.155 E.05108
G1 X184.584 Y156.155 E.26454
G1 X184.584 Y159.845 E.11868
G1 X176.826 Y159.845 E.24946
G1 X176.526 Y160.999 E.03834
G3 X175.797 Y162.019 I-1.813 J-.525 E.04111
G1 X175.213 Y162.408 E.02255
M73 P53 R13
G3 X174.361 Y162.303 I.387 J-6.643 E.02763
G3 X173.015 Y159.871 I.39 J-1.804 E.10121
G1 X173.256 Y159.25 E.02142
G3 X172.939 Y158.351 I4.348 J-2.039 E.0307
G3 X172.907 Y158.096 I1.821 J-.352 E.00827
G1 X172.89 Y157.41 E.02206
; COOLING_NODE: 0
M204 S10000
G1 X172.472 Y157.03 F60000
G1 F1591
M204 S8000
G1 X172.472 Y157.009 E.00068
G1 X172.643 Y157.009 E.0055
G3 X173.247 Y156.323 I4.171 J3.061 E.02945
G3 X174.763 Y155.747 I1.506 J1.683 E.05335
G1 X176.357 Y155.747 E.05125
G1 X184.991 Y155.747 E.27763
G1 X184.991 Y160.253 E.14487
G1 X177.141 Y160.252 E.25242
G3 X176.883 Y161.224 I-10.454 J-2.259 E.03234
G3 X176.03 Y162.353 I-2.145 J-.733 E.04627
G1 X175.491 Y162.713 E.02084
G1 X175.491 Y162.849 E.0044
G1 X174.433 Y162.73 E.03425
G3 X172.632 Y159.733 I.328 J-2.236 E.1285
G1 X172.819 Y159.25 E.01668
G3 X172.501 Y158.117 I3.156 J-1.498 E.03802
G1 X172.474 Y157.09 E.03303
; COOLING_NODE: 0
M204 S10000
G1 X171.677 Y157.398 F60000
G1 F1591
M204 S8000
G1 X164.602 Y157.398 E.22752
G1 X164.602 Y156.602 E.02559
G1 X172.453 Y156.602 E.25247
G3 X173.591 Y155.607 I2.699 J1.936 E.04904
G3 X174.758 Y155.34 I1.207 J2.6 E.03879
G1 X176.357 Y155.34 E.05142
G1 X185.398 Y155.34 E.29072
G1 X185.398 Y160.66 E.17105
G1 X177.456 Y160.659 E.25539
G3 X176.992 Y161.93 I-3.995 J-.738 E.04371
G3 X175.898 Y162.931 I-2.666 J-1.819 E.04809
G1 X175.898 Y164.898 E.06327
G1 X175.102 Y164.898 E.02559
G1 X175.102 Y163.215 E.05411
G3 X174.19 Y163.1 I.438 J-7.115 E.0296
G3 X172.249 Y159.596 I.563 J-2.601 E.1458
G1 X172.383 Y159.25 E.01193
G3 X172.094 Y158.138 I2.757 J-1.309 E.03715
G1 X172.075 Y157.398 E.02381
G1 X171.737 Y157.398 E.01085
; COOLING_NODE: 0
M204 S250
G1 X171.694 Y157.831 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1591
M204 S5000
G1 X171.693 Y157.79 E.00122
G1 X164.21 Y157.79 E.22289
G1 X164.21 Y156.21 E.04706
G1 X169.071 Y156.21 E.14479
G1 X169.471 Y156.21 E.01191
G1 X169.871 Y156.21 E.01191
G1 X170.271 Y156.21 E.01191
G1 X170.671 Y156.21 E.01191
G1 X171.071 Y156.21 E.01191
G1 X171.471 Y156.21 E.01191
G1 X171.871 Y156.21 E.01191
G1 X172.271 Y156.21 E.01191
G1 X172.305 Y156.169 E.0016
M106 S229.5
G1 X172.493 Y155.946 E.00867
M106 S226.95
M106 S229.5
G3 X174.753 Y154.948 I2.266 J2.074 E.07574
G1 X176.357 Y154.948 E.04778
M106 S226.95
M106 S229.5
G1 X185.79 Y154.948 E.28097
M106 S226.95
M106 S229.5
G1 X185.79 Y155.11 E.00481
M106 S226.95
G1 X185.79 Y155.51 E.01191
G1 X185.79 Y155.91 E.01191
G1 X185.79 Y156.31 E.01191
G1 X185.79 Y156.71 E.01191
G1 X185.79 Y157.11 E.01191
G1 X185.79 Y157.51 E.01191
G1 X185.79 Y157.91 E.01191
G1 X185.79 Y158.31 E.01191
G1 X185.79 Y158.89 E.01729
G1 X185.79 Y159.29 E.01191
G1 X185.79 Y159.69 E.01191
G1 X185.79 Y160.09 E.01191
G1 X185.79 Y160.49 E.01191
G1 X185.79 Y160.89 E.01191
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

M106 S229.5
G1 X185.79 Y161.052 E.00481
M106 S226.95
M106 S229.5
G1 X177.759 Y161.052 E.23922
G3 X176.488 Y163.008 I-3.055 J-.593 E.07124
M106 S226.95
M106 S229.5
G1 X176.331 Y163.113 E.00562
M106 S226.95
G1 X176.29 Y163.14 E.00147
G1 X176.29 Y163.54 E.01191
G1 X176.29 Y163.94 E.01191
G1 X176.29 Y164.34 E.01191
G1 X176.29 Y164.74 E.01191
G1 X176.29 Y165.29 E.01637
G1 X175.89 Y165.29 E.01191
G1 X175.49 Y165.29 E.01191
G1 X175.11 Y165.29 E.01132
G1 X174.71 Y165.29 E.01191
G1 X174.71 Y164.765 E.01563
G1 X174.71 Y164.365 E.01191
G1 X174.71 Y163.965 E.01191
G1 X174.71 Y163.565 E.01191
G1 X174.669 Y163.561 E.00123
M106 S229.5
G3 X171.962 Y159.25 I.107 J-3.072 E.17862
G3 X171.693 Y157.891 I3.193 J-1.339 E.04155
M106 S226.95
; WIPE_START
G1 F2160
M204 S8000
G1 X171.693 Y157.79 E-.03835
G1 X169.794 Y157.79 E-.72165
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.268 Y157 Z16.4 F60000
G1 Z16
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1591
M204 S8000
G1 X164.806 Y157 E.22918
; WIPE_START
G1 F9259.259
G1 X166.806 Y157 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z16.4 I-.259 J1.189 P1  F60000
G1 X175.149 Y158.817 Z16.4
G1 Z16
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.49593
G1 F1591
M204 S8000
G1 X175.386 Y158.474 E.01491
G1 X175.901 Y158.095 E.02291
G1 X174.887 Y158.096 E.03628
G3 X175.132 Y158.76 I-3.794 J1.773 E.02535
; WIPE_START
G1 F7946.844
G1 X174.887 Y158.096 E-.26886
G1 X175.901 Y158.095 E-.38528
G1 X175.677 Y158.26 E-.10586
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X174.362 Y159.566 Z16.4 F60000
G1 Z16
G1 E.8 F1800
; LINE_WIDTH: 0.41999
G1 F1591
M204 S8000
G1 X174.069 Y160.386 E.02593
G1 X174.115 Y160.752 E.011
G1 X174.342 Y161.059 E.01138
G2 X174.907 Y161.216 I.54 J-.851 E.01772
G1 X175.264 Y160.956 E.01314
G1 X175.433 Y160.647 E.01049
G1 X175.756 Y159.405 E.03824
G1 X175.898 Y159.099 E.01004
G1 X176.271 Y158.787 E.01449
G1 X176.669 Y158.699 E.01212
G1 X183.438 Y158.699 E.20161
G1 X183.438 Y157.301 E.04165
G1 X174.765 Y157.303 E.25832
G1 X174.411 Y157.402 E.01095
G1 X174.045 Y157.755 E.01515
G1 X174.118 Y158.302 E.01642
G1 X174.353 Y158.909 E.0194
G1 X174.417 Y159.24 E.01004
G1 X174.372 Y159.507 E.00806
M204 S10000
G1 X175.206 Y159.845 F60000
; LINE_WIDTH: 0.52273
G1 F1591
M204 S8000
G1 X175.336 Y159.295 E.02142
; LINE_WIDTH: 0.516057
G1 X175.455 Y159.115 E.00808
; LINE_WIDTH: 0.47763
G1 X175.574 Y158.934 E.00742
; LINE_WIDTH: 0.425624
G1 X175.693 Y158.754 E.00654
G1 X176.112 Y158.445 E.01576
; LINE_WIDTH: 0.44414
G1 X176.218 Y158.387 E.00381
; LINE_WIDTH: 0.49244
G1 X176.323 Y158.329 E.00427
; LINE_WIDTH: 0.553058
G1 X176.428 Y158.271 E.00484
G1 X176.669 Y158.256 E.00973
G1 X182.994 Y158.255 E.25488
G1 X182.994 Y157.745 E.02057
G1 X176.383 Y157.753 E.26641
; LINE_WIDTH: 0.54074
G1 X176.236 Y157.728 E.00584
; LINE_WIDTH: 0.49244
G1 X176.09 Y157.704 E.00527
; LINE_WIDTH: 0.421339
G1 X175.943 Y157.68 E.00444
G1 X174.803 Y157.681 E.03409
G1 X174.562 Y157.764 E.00761
G1 X174.426 Y157.888 E.00552
G1 X174.493 Y158.227 E.01031
G1 X174.705 Y158.773 E.01751
; LINE_WIDTH: 0.439204
G1 X174.754 Y158.927 E.00507
; LINE_WIDTH: 0.47763
G1 X174.802 Y159.081 E.00556
; LINE_WIDTH: 0.528373
G1 X174.851 Y159.236 E.00621
G1 X174.76 Y159.708 E.01845
G1 X174.546 Y160.35 E.02594
G1 X174.516 Y160.538 E.00732
G1 X174.602 Y160.705 E.00719
G1 X174.79 Y160.761 E.00749
G1 X174.993 Y160.573 E.01061
G1 X175.189 Y159.903 E.02679
M204 S10000
G1 X175.979 Y160.046 F60000
; LINE_WIDTH: 0.41999
G1 F1591
M204 S8000
G1 X176.121 Y159.499 E.01683
G1 X176.25 Y159.261 E.00807
G1 X176.43 Y159.129 E.00665
G1 X176.669 Y159.076 E.00727
G1 X183.815 Y159.076 E.21285
G1 X183.815 Y156.924 E.06411
G1 X174.727 Y156.926 E.27068
G1 X174.232 Y157.062 E.01528
G2 X173.664 Y157.622 I1.508 J2.098 E.02385
G1 X173.715 Y158.214 E.01772
G3 X174.04 Y159.244 I-16.092 J5.637 E.03215
G1 X174.007 Y159.439 E.00591
G1 X173.697 Y160.307 E.02742
G2 X173.76 Y160.895 I1.58 J.131 E.01773
G1 X174.055 Y161.308 E.01511
G1 X174.312 Y161.478 E.00919
G2 X175.009 Y161.608 I.822 J-2.463 E.02119
G1 X175.535 Y161.224 E.0194
G1 X175.754 Y160.863 E.01259
G1 X175.963 Y160.104 E.02344
M204 S10000
G1 X176.174 Y160.796 F60000
G1 F1591
M204 S8000
G1 X176.486 Y159.594 E.03697
G1 X176.589 Y159.471 E.00479
G1 X176.669 Y159.453 E.00242
G1 X184.192 Y159.453 E.22408
G1 X184.192 Y156.547 E.08658
G1 X174.689 Y156.549 E.28303
G1 X174.139 Y156.689 E.01692
G1 X173.67 Y157.03 E.01727
G1 X173.284 Y157.489 E.01785
G1 X173.299 Y158.059 E.017
G2 X173.65 Y159.181 I4.406 J-.762 E.03512
G1 X173.652 Y159.313 E.00392
G1 X173.326 Y160.227 E.02891
G1 X173.301 Y160.542 E.00942
G1 X173.404 Y161.038 E.01508
G1 X173.676 Y161.474 E.01532
G1 X174.035 Y161.753 E.01353
G1 X174.447 Y161.919 E.01323
G1 X175.111 Y162.001 E.01992
G1 X175.807 Y161.493 E.02565
G1 X176.037 Y161.171 E.0118
G1 X176.153 Y160.852 E.01011
; WIPE_START
G1 F9547.299
G1 X176.037 Y161.171 E-.12898
G1 X175.807 Y161.493 E-.15054
G1 X175.111 Y162.001 E-.32729
G1 X174.711 Y161.951 E-.15319
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.5 Y163.055 Z16.4 F60000
G1 Z16
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.43173
G1 F1591
M204 S8000
G1 X175.5 Y164.694 E.05034
; CHANGE_LAYER
; Z_HEIGHT: 16.2
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F9259.021
G1 X175.5 Y163.055 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 81/165
; update layer progress
M73 L81
M991 S0 P80 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z16.4 I1.093 J-.534 P1  F60000
G1 X172.709 Y157.346 Z16.4
G1 Z16.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1709
M204 S8000
G3 X173.317 Y156.571 I5.013 J3.304 E.03172
G3 X174.775 Y155.975 I1.443 J1.452 E.05199
G1 X184.584 Y155.975 E.31542
G1 X184.584 Y160.025 E.13021
G1 X177.004 Y160.024 E.24373
G3 X176.643 Y161.217 I-13.145 J-3.331 E.04009
G3 X175.84 Y162.206 I-1.905 J-.726 E.04165
G1 X175.224 Y162.586 E.02328
M73 P53 R12
G3 X174.326 Y162.479 I.346 J-6.709 E.02911
G3 X172.823 Y159.881 I.428 J-1.981 E.10867
G1 X173.05 Y159.243 E.02177
G3 X172.736 Y158.207 I3.714 J-1.688 E.03492
G3 X172.708 Y157.406 I8.417 J-.7 E.02578
; COOLING_NODE: 0
M204 S10000
G1 X172.293 Y157.03 F60000
G1 F1709
M204 S8000
G1 X172.293 Y157.009 E.00067
G1 X172.453 Y157.009 E.00515
G3 X173.169 Y156.153 I3.879 J2.516 E.03599
G3 X174.768 Y155.568 I1.587 J1.863 E.05589
G1 X184.991 Y155.568 E.32873
G1 X184.991 Y160.432 E.15639
G1 X177.308 Y160.431 E.24707
G3 X176.977 Y161.477 I-7.473 J-1.791 E.03529
G3 X176.062 Y162.547 I-2.266 J-1.01 E.04591
G1 X175.491 Y162.9 E.02158
G1 X175.491 Y163.025 E.00401
G1 X174.404 Y162.906 E.03516
G3 X172.436 Y159.755 I.361 J-2.416 E.13574
G1 X172.617 Y159.245 E.01741
G3 X172.322 Y158.127 I3.006 J-1.391 E.03737
G1 X172.295 Y157.09 E.03337
; COOLING_NODE: 0
M204 S10000
G1 X171.499 Y157.398 F60000
G1 F1709
M204 S8000
G1 X164.602 Y157.398 E.22177
G1 X164.602 Y156.602 E.02559
G1 X172.25 Y156.602 E.24594
G3 X173.69 Y155.367 I2.769 J1.771 E.06188
G3 X174.761 Y155.161 I1.123 J2.957 E.03524
G1 X185.398 Y155.161 E.34205
G1 X185.398 Y160.839 E.18257
G1 X177.611 Y160.838 E.2504
G3 X177.002 Y162.228 I-3.878 J-.871 E.04908
G3 X175.898 Y163.127 I-2.665 J-2.145 E.04613
G1 X175.898 Y164.898 E.05694
G1 X175.102 Y164.898 E.02559
G1 X175.102 Y163.392 E.04843
G3 X174.159 Y163.276 I.386 J-7.037 E.03056
G3 X172.048 Y159.63 I.595 J-2.779 E.15262
G1 X172.184 Y159.247 E.01305
G3 X171.915 Y158.148 I2.926 J-1.298 E.03657
G1 X171.896 Y157.398 E.02414
G1 X171.559 Y157.398 E.01084
; COOLING_NODE: 0
M204 S250
G1 X171.515 Y157.831 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1653
M204 S5000
G1 X171.514 Y157.79 E.00122
G1 X164.21 Y157.79 E.21756
G1 X164.21 Y156.21 E.04706
G1 X168.855 Y156.21 E.13835
G1 X169.255 Y156.21 E.01191
G1 X169.655 Y156.21 E.01191
M73 P54 R12
G1 X170.055 Y156.21 E.01191
G1 X170.455 Y156.21 E.01191
G1 X170.855 Y156.21 E.01191
G1 X171.255 Y156.21 E.01191
G1 X171.655 Y156.21 E.01191
G1 X172.055 Y156.21 E.01191
G1 X172.086 Y156.169 E.00153
M106 S229.5
G1 X172.216 Y155.996 E.00645
M106 S226.95
M106 S229.5
G1 X172.286 Y155.911 E.00328
M106 S226.95
M106 S229.5
G1 X172.399 Y155.784 E.00507
M106 S226.95
M106 S229.5
G1 X172.475 Y155.706 E.00324
M106 S226.95
M106 S229.5
G1 X172.642 Y155.551 E.00679
M106 S226.95
M106 S229.5
G3 X172.861 Y155.379 I2.096 J2.434 E.00831
M106 S226.95
M106 S229.5
G3 X173.392 Y155.069 I2.759 J4.109 E.01831
M106 S226.95
M106 S229.5
G1 X173.546 Y155.002 E.00499
M106 S226.95
M106 S229.5
G3 X174.754 Y154.769 I1.275 J3.364 E.03684
G1 X185.79 Y154.769 E.32872
M106 S226.95
M106 S229.5
G1 X185.79 Y154.907 E.00412
M106 S226.95
G1 X185.79 Y155.307 E.01191
G1 X185.79 Y155.707 E.01191
G1 X185.79 Y156.107 E.01191
G1 X185.79 Y156.507 E.01191
G1 X185.79 Y156.907 E.01191
G1 X185.79 Y157.307 E.01191
G1 X185.79 Y157.707 E.01191
G1 X185.79 Y158.107 E.01191
G1 X185.79 Y158.693 E.01743
G1 X185.79 Y159.093 E.01191
G1 X185.79 Y159.493 E.01191
G1 X185.79 Y159.893 E.01191
G1 X185.79 Y160.293 E.01191
G1 X185.79 Y160.693 E.01191
G1 X185.79 Y161.093 E.01191
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

M106 S229.5
G1 X185.79 Y161.231 E.00412
M106 S226.95
M106 S229.5
G1 X178.303 Y161.231 E.22301
M106 S226.95
M106 S229.5
G1 X177.903 Y161.231 E.01191
M106 S226.95
M106 S229.5
G1 X177.827 Y161.486 E.00794
M106 S226.95
M106 S229.5
G3 X177.472 Y162.24 I-3.202 J-1.044 E.0249
M106 S226.95
M106 S229.5
G1 X177.411 Y162.332 E.00327
M106 S226.95
M106 S229.5
G3 X176.497 Y163.218 I-2.827 J-2.002 E.03814
M106 S226.95
M106 S229.5
G1 X176.331 Y163.32 E.00581
M106 S226.95
G1 X176.29 Y163.346 E.00144
G1 X176.29 Y163.746 E.01191
G1 X176.29 Y164.146 E.01191
G1 X176.29 Y164.546 E.01191
G1 X176.29 Y164.946 E.01191
G1 X176.29 Y165.29 E.01025
G1 X175.89 Y165.29 E.01191
G1 X175.49 Y165.29 E.01191
G1 X175.11 Y165.29 E.01132
G1 X174.71 Y165.29 E.01191
G1 X174.71 Y164.944 E.01032
G1 X174.71 Y164.544 E.01191
G1 X174.71 Y164.144 E.01191
G1 X174.71 Y163.744 E.01191
G1 X174.669 Y163.739 E.00123
M106 S229.5
G3 X174.079 Y163.66 I.289 J-4.402 E.01774
M106 S226.95
M106 S229.5
G1 X173.906 Y163.619 E.0053
M106 S226.95
M106 S229.5
G3 X171.767 Y159.249 I.851 J-3.125 E.16394
M106 S226.95
M106 S229.5
G1 X171.694 Y159.048 E.00637
M106 S226.95
M106 S229.5
G3 X171.604 Y158.735 I3.044 J-1.044 E.00972
M106 S226.95
M106 S229.5
G1 X171.578 Y158.615 E.00365
M106 S226.95
M106 S229.5
G3 X171.515 Y157.891 I4.447 J-.754 E.02167
M106 S226.95
; WIPE_START
G1 F2520
M204 S8000
G1 X171.514 Y157.79 E-.03837
G1 X169.615 Y157.79 E-.72163
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.089 Y157 Z16.6 F60000
G1 Z16.2
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1709
M204 S8000
G1 X164.806 Y157 E.22369
; WIPE_START
G1 F9259.259
G1 X166.806 Y157 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X174.351 Y158.147 Z16.6 F60000
G1 X175.289 Y158.289 Z16.6
G1 Z16.2
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.6166
G1 F1709
M204 S8000
G2 X175.295 Y158.403 I-.032 J.059 E.01288
; WIPE_START
G1 F6275.276
G1 X175.217 Y158.413 E-.20266
G1 X175.181 Y158.351 E-.18578
G1 X175.217 Y158.289 E-.18579
G1 X175.289 Y158.289 E-.18577
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X174.509 Y159.685 Z16.6 F60000
G1 Z16.2
G1 E.8 F1800
; LINE_WIDTH: 0.41999
G1 F1709
M204 S8000
G1 X174.297 Y160.282 E.01889
G1 X174.283 Y160.603 E.00955
G1 X174.359 Y160.784 E.00584
G1 X174.533 Y160.937 E.0069
G1 X174.854 Y161.008 E.00981
G1 X175.143 Y160.791 E.01075
G1 X175.264 Y160.528 E.00864
G1 X175.588 Y159.443 E.03372
G1 X175.818 Y159.001 E.01485
G1 X176.3 Y158.622 E.01824
G3 X176.853 Y158.501 I.553 J1.198 E.017
G1 X183.061 Y158.501 E.18491
G1 X183.061 Y157.499 E.02986
G1 X174.821 Y157.499 E.24541
G1 X174.513 Y157.574 E.00945
G2 X174.246 Y157.841 I.606 J.875 E.01131
G1 X174.322 Y158.288 E.01351
G1 X174.506 Y158.789 E.01591
G1 X174.585 Y159.282 E.01485
G1 X174.521 Y159.626 E.01043
M204 S10000
G1 X175.105 Y159.888 F60000
; LINE_WIDTH: 0.35175
G1 F1709
M204 S8000
G1 X175.252 Y159.343 E.01378
; LINE_WIDTH: 0.379595
G1 X175.305 Y159.181 E.00453
; LINE_WIDTH: 0.417806
G1 X175.358 Y159.019 E.00505
G1 X175.603 Y158.673 E.01256
G1 X176.142 Y158.28 E.01974
; LINE_WIDTH: 0.407325
G1 X176.353 Y158.227 E.00626
; LINE_WIDTH: 0.356213
G3 X176.853 Y158.156 I.443 J1.321 E.01257
G1 X182.716 Y158.156 E.1451
G1 X182.716 Y157.844 E.00774
G1 X176.853 Y157.844 E.1451
; LINE_WIDTH: 0.371645
G1 X176.453 Y157.86 E.01039
; LINE_WIDTH: 0.417637
G3 X174.833 Y157.876 I-1.01 J-20.104 E.04797
G1 X174.675 Y157.92 E.00484
G1 X174.635 Y157.958 E.00164
G3 X174.937 Y158.951 I-53.177 J16.726 E.03074
; LINE_WIDTH: 0.405585
G1 X174.936 Y159.122 E.00488
; LINE_WIDTH: 0.379595
G1 X174.935 Y159.292 E.00453
; LINE_WIDTH: 0.347144
G3 X174.642 Y160.334 I-4.667 J-.75 E.02607
G1 X174.625 Y160.568 E.00565
G1 X174.754 Y160.652 E.00369
G1 X174.874 Y160.563 E.00358
G1 X175.086 Y159.945 E.0157
M204 S10000
G1 X175.605 Y160.705 F60000
; LINE_WIDTH: 0.41999
G1 F1709
M204 S8000
G1 X175.949 Y159.551 E.03587
G1 X176.114 Y159.235 E.01061
G1 X176.458 Y158.965 E.01303
G1 X176.853 Y158.878 E.01205
G1 X183.438 Y158.878 E.19614
G1 X183.438 Y157.122 E.05233
G1 X174.81 Y157.122 E.25698
G1 X174.419 Y157.195 E.01184
G1 X174.106 Y157.42 E.01148
G1 X173.865 Y157.718 E.01142
G1 X173.92 Y158.236 E.0155
G3 X174.195 Y159.08 I-27.931 J9.534 E.02646
G1 X174.169 Y159.512 E.01288
G2 X173.885 Y160.437 I3.92 J1.712 E.02889
G1 X173.964 Y160.853 E.0126
G1 X174.158 Y161.134 E.01016
G1 X174.465 Y161.313 E.01061
G1 X174.947 Y161.399 E.01457
G1 X175.397 Y161.073 E.01657
G1 X175.575 Y160.757 E.01079
M204 S10000
G1 X175.987 Y160.744 F60000
G1 F1709
M204 S8000
G1 X176.311 Y159.659 E.03372
G1 X176.436 Y159.438 E.00757
G1 X176.616 Y159.307 E.00662
G1 X176.853 Y159.255 E.00723
G1 X183.815 Y159.255 E.20737
G1 X183.815 Y156.745 E.07479
G1 X174.798 Y156.745 E.26856
G1 X174.279 Y156.842 E.01576
G1 X173.908 Y157.088 E.01324
G1 X173.485 Y157.596 E.01969
G1 X173.512 Y158.111 E.01537
G2 X173.797 Y159.048 I4.007 J-.708 E.02925
G1 X173.831 Y159.259 E.00637
G2 X173.504 Y160.424 I7.174 J2.646 E.03608
G1 X173.553 Y160.852 E.01282
G1 X173.678 Y161.141 E.00939
G1 X173.898 Y161.412 E.01039
G1 X174.183 Y161.613 E.01038
G2 X175.039 Y161.79 I.97 J-2.533 E.02616
G1 X175.586 Y161.429 E.01952
G1 X175.776 Y161.214 E.00853
G1 X175.962 Y160.798 E.01358
M204 S10000
G1 X176.348 Y160.851 F60000
G1 F1709
M204 S8000
G1 X176.672 Y159.767 E.03372
G1 X176.774 Y159.65 E.00462
G1 X176.853 Y159.632 E.00241
G1 X184.192 Y159.632 E.2186
G1 X184.192 Y156.367 E.09725
G1 X174.787 Y156.368 E.28013
G1 X174.325 Y156.441 E.01394
G1 X173.969 Y156.582 E.01141
G2 X173.396 Y157.089 I.98 J1.685 E.02292
G1 X173.104 Y157.473 E.01438
G1 X173.12 Y158.071 E.01779
G2 X173.443 Y159.178 I4.619 J-.748 E.03444
G1 X173.444 Y159.306 E.00381
G1 X173.201 Y159.988 E.02157
G1 X173.123 Y160.411 E.01281
G1 X173.184 Y160.951 E.01618
G1 X173.353 Y161.338 E.01259
G1 X173.638 Y161.69 E.01349
G1 X174.008 Y161.951 E.01348
G1 X174.409 Y162.094 E.01271
G1 X175.132 Y162.18 E.02166
G1 X175.836 Y161.716 E.02512
G1 X176.092 Y161.426 E.01153
G1 X176.324 Y160.906 E.01694
; WIPE_START
G1 F9547.299
G1 X176.092 Y161.426 E-.2161
G1 X175.836 Y161.716 E-.14715
G1 X175.132 Y162.18 E-.32052
G1 X174.932 Y162.157 E-.07622
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.5 Y163.231 Z16.6 F60000
G1 Z16.2
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.431732
G1 F1709
M204 S8000
G1 X175.5 Y164.694 E.04495
; CHANGE_LAYER
; Z_HEIGHT: 16.4
; LAYER_HEIGHT: 0.199999
; WIPE_START
G1 F9258.989
G1 X175.5 Y163.231 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 82/165
; update layer progress
M73 L82
M991 S0 P81 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z16.6 I1.037 J-.637 P1  F60000
G1 X172.648 Y158.584 Z16.6
G1 Z16.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1728
M204 S8000
G1 X172.646 Y158.562 E.00073
G3 X172.57 Y158.12 I3.793 J-.878 E.01443
G1 X172.55 Y157.336 E.02522
G3 X173.106 Y156.563 I6.04 J3.765 E.03063
G3 X174.101 Y155.916 I1.665 J1.473 E.03864
G1 X184.584 Y155.916 E.33708
G1 X184.584 Y160.184 E.13723
G1 X177.174 Y160.184 E.23828
G1 X176.792 Y161.272 E.03707
G3 X175.898 Y162.357 I-2.087 J-.808 E.046
G1 X175.244 Y162.741 E.02441
G3 X174.328 Y162.642 I.345 J-7.42 E.02964
G3 X172.66 Y159.87 I.422 J-2.142 E.11717
G1 X172.871 Y159.243 E.02127
G1 X172.667 Y158.641 E.02043
; COOLING_NODE: 0
M204 S10000
G1 X172.202 Y158.447 F60000
G1 F1728
M204 S8000
G3 X172.163 Y158.139 I3.39 J-.582 E.00999
G1 X172.134 Y157.009 E.03635
G1 X172.281 Y157.009 E.00474
G3 X173.059 Y156.038 I3.976 J2.385 E.04013
G3 X174.039 Y155.509 I1.709 J1.995 E.03608
G1 X184.991 Y155.509 E.35218
G1 X184.991 Y160.591 E.16341
G1 X177.462 Y160.591 E.24209
G3 X177.087 Y161.618 I-7.963 J-2.329 E.03519
G3 X176.113 Y162.703 I-2.405 J-1.179 E.04749
G1 X175.491 Y163.068 E.02319
G1 X175.491 Y163.175 E.00342
G1 X174.43 Y163.07 E.03427
G3 X172.27 Y159.751 I.328 J-2.576 E.14485
G1 X172.441 Y159.245 E.01716
G3 X172.212 Y158.506 I3.151 J-1.379 E.02491
; COOLING_NODE: 0
M204 S10000
G1 X171.757 Y158.164 F60000
G1 F1728
M204 S8000
G1 X171.756 Y158.158 E.00016
G1 X171.737 Y157.398 E.02446
G1 X164.602 Y157.398 E.22943
G1 X164.602 Y156.602 E.02559
G1 X172.07 Y156.602 E.24013
G3 X173.678 Y155.201 I2.907 J1.712 E.0698
G3 X173.986 Y155.102 I1.238 J3.337 E.01039
G1 X185.398 Y155.102 E.36697
G1 X185.398 Y160.998 E.18959
G1 X177.751 Y160.998 E.2459
G3 X177.063 Y162.406 I-4.042 J-1.102 E.05069
G3 X175.898 Y163.301 I-2.763 J-2.391 E.04758
G1 X175.898 Y164.898 E.05134
G1 X175.102 Y164.898 E.02559
G1 X175.102 Y163.546 E.04349
G3 X173.767 Y163.332 I.168 J-5.322 E.04359
G3 X171.881 Y159.631 I.986 J-2.833 E.14751
G1 X172.011 Y159.247 E.01305
G3 X171.817 Y158.619 I3.072 J-1.291 E.02118
G1 X171.765 Y158.223 E.01283
; COOLING_NODE: 0
M204 S250
G1 X171.356 Y157.831 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1652
M204 S5000
G1 X171.355 Y157.79 E.00122
G1 X164.21 Y157.79 E.21282
G1 X164.21 Y156.21 E.04706
G1 X169.066 Y156.21 E.14464
G1 X169.466 Y156.21 E.01191
G1 X169.866 Y156.21 E.01191
G1 X170.266 Y156.21 E.01191
G1 X170.666 Y156.21 E.01191
G1 X171.066 Y156.21 E.01191
G1 X171.466 Y156.21 E.01191
G1 X171.866 Y156.21 E.01191
G1 X171.895 Y156.169 E.00149
M106 S229.5
G1 X172.019 Y155.992 E.00644
M106 S226.95
M106 S229.5
G3 X173.935 Y154.71 I2.739 J2.02 E.07007
M106 S226.95
M106 S229.5
G1 X174.335 Y154.71 E.01191
M106 S226.95
M106 S229.5
G1 X174.535 Y154.71 E.00596
M106 S226.95
M106 S229.5
G1 X174.935 Y154.71 E.01191
M106 S226.95
M106 S229.5
G1 X175.246 Y154.71 E.00924
M106 S226.95
M106 S229.5
G1 X175.646 Y154.71 E.01191
M106 S226.95
M106 S229.5
G1 X176.046 Y154.71 E.01191
M106 S226.95
M106 S229.5
G1 X176.446 Y154.71 E.01191
M106 S226.95
M106 S229.5
G1 X176.666 Y154.71 E.00657
M106 S226.95
M106 S229.5
G1 X177.066 Y154.71 E.01191
M106 S226.95
M106 S229.5
G1 X178.087 Y154.71 E.0304
M106 S226.95
M106 S229.5
G1 X178.797 Y154.71 E.02116
M106 S226.95
G1 X180.218 Y154.71 E.04232
G1 X181.638 Y154.71 E.04232
G1 X182.349 Y154.71 E.02116
G1 X183.769 Y154.71 E.04232
G1 X184.48 Y154.71 E.02116
G1 X185.79 Y154.71 E.03903
G1 X185.79 Y154.728 E.00054
G1 X185.79 Y161.272 E.19491
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

M106 S229.5
G1 X185.79 Y161.39 E.00352
M106 S226.95
M106 S229.5
G1 X178.029 Y161.39 E.23117
G3 X176.535 Y163.382 I-3.329 J-.941 E.07588
M106 S226.95
M106 S229.5
G1 X176.331 Y163.502 E.00703
M106 S226.95
G1 X176.29 Y163.526 E.00142
G1 X176.29 Y163.926 E.01191
G1 X176.29 Y164.326 E.01191
G1 X176.29 Y164.726 E.01191
G1 X176.29 Y165.29 E.01681
G1 X175.89 Y165.29 E.01191
G1 X175.49 Y165.29 E.01191
G1 X175.11 Y165.29 E.01132
G1 X174.71 Y165.29 E.01191
G1 X174.71 Y164.701 E.01754
G1 X174.71 Y164.301 E.01191
G1 X174.71 Y163.901 E.01191
G1 X174.669 Y163.897 E.00123
M106 S229.5
G3 X171.596 Y159.249 I.102 J-3.407 E.19428
G3 X171.355 Y157.891 I3.503 J-1.323 E.04132
M106 S226.95
; WIPE_START
G1 F2760
M204 S8000
G1 X171.355 Y157.79 E-.03835
G1 X169.456 Y157.79 E-.72165
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.93 Y157 Z16.8 F60000
G1 Z16.4
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1728
M204 S8000
G1 X164.806 Y157 E.21881
; WIPE_START
G1 F9259.259
G1 X166.806 Y157 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X174.015 Y159.506 Z16.8 F60000
G1 X174.35 Y159.622 Z16.8
G1 Z16.4
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F1728
M204 S8000
G1 X174.104 Y160.44 E.02545
G1 X174.143 Y160.709 E.00808
G1 X174.316 Y160.984 E.00968
G1 X174.539 Y161.105 E.00756
G1 X174.88 Y161.175 E.01038
G1 X175.254 Y160.915 E.01356
G1 X175.388 Y160.672 E.00827
G1 X175.784 Y159.543 E.03563
G1 X176.035 Y159.112 E.01488
G1 X176.459 Y158.79 E.01585
G1 X176.801 Y158.68 E.0107
G1 X177.029 Y158.66 E.00682
G1 X183.061 Y158.66 E.17964
G1 X183.061 Y157.439 E.03637
G1 X174.431 Y157.439 E.25705
G1 X174.154 Y157.702 E.01136
G1 X174.085 Y157.799 E.00354
G1 X174.148 Y158.277 E.01437
G1 X174.333 Y158.808 E.01674
G1 X174.405 Y159.285 E.01438
G1 X174.36 Y159.563 E.00838
M204 S10000
G1 X175.172 Y159.002 F60000
; LINE_WIDTH: 0.48613
G1 F1728
M204 S8000
G1 X175.443 Y158.594 E.01713
G1 X175.926 Y158.227 E.02126
G1 X174.964 Y158.227 E.03369
G1 X175.168 Y158.942 E.02604
M204 S10000
G1 X175.21 Y159.892 F60000
; LINE_WIDTH: 0.49376
G1 F1728
M204 S8000
G1 X175.319 Y159.655 E.00928
; LINE_WIDTH: 0.424021
G3 X175.568 Y159.118 I78.075 J35.833 E.01784
G1 X175.751 Y158.864 E.00942
G1 X176.296 Y158.45 E.0206
; LINE_WIDTH: 0.434863
G1 X176.514 Y158.365 E.00723
; LINE_WIDTH: 0.465034
G1 X176.731 Y158.28 E.00778
G1 X177.029 Y158.261 E.00997
G1 X182.661 Y158.261 E.18778
G1 X182.661 Y157.839 E.01407
G1 X177.029 Y157.839 E.18778
; LINE_WIDTH: 0.425315
G2 X174.561 Y157.817 I-1.672 J48.232 E.07456
G1 X174.466 Y157.928 E.00442
G2 X174.689 Y158.684 I2.837 J-.424 E.02389
G1 X174.761 Y158.966 E.0088
; LINE_WIDTH: 0.44458
G1 X174.759 Y159.356 E.01235
; LINE_WIDTH: 0.505232
G1 X174.758 Y159.745 E.01422
M73 P55 R12
G1 X174.524 Y160.539 E.03022
G1 X174.63 Y160.697 E.00696
G1 X174.788 Y160.74 E.00599
G1 X174.969 Y160.591 E.00855
G1 X175.19 Y159.949 E.0248
M204 S10000
G1 X175.968 Y160.158 F60000
; LINE_WIDTH: 0.41999
G1 F1728
M204 S8000
G1 X176.14 Y159.668 E.01545
G1 X176.319 Y159.36 E.01063
G1 X176.622 Y159.13 E.01132
G1 X177.029 Y159.037 E.01244
G1 X183.438 Y159.037 E.19087
G1 X183.438 Y157.062 E.05883
G1 X174.327 Y157.062 E.27138
G1 X174.074 Y157.236 E.00915
G1 X173.705 Y157.684 E.01727
G1 X173.768 Y158.298 E.01837
G1 X173.967 Y158.904 E.01899
G1 X174.028 Y159.273 E.01115
G2 X173.725 Y160.488 I12.072 J3.662 E.03731
G1 X173.755 Y160.767 E.00836
G1 X173.882 Y161.05 E.00925
G1 X174.136 Y161.321 E.01106
G1 X174.361 Y161.448 E.00771
G2 X174.971 Y161.563 I.709 J-2.093 E.01853
G1 X175.42 Y161.283 E.01577
G1 X175.664 Y160.982 E.01154
G1 X175.947 Y160.214 E.02437
M204 S10000
G1 X176.1 Y160.922 F60000
G1 F1728
M204 S8000
G1 X176.496 Y159.793 E.03563
G3 X177.029 Y159.415 I.575 J.245 E.02051
G1 X183.815 Y159.415 E.2021
G1 X183.815 Y156.685 E.08129
G1 X174.24 Y156.685 E.2852
G1 X173.89 Y156.884 E.01197
G2 X173.325 Y157.57 I2.302 J2.473 E.02654
G1 X173.354 Y158.136 E.0169
G2 X173.62 Y159.056 I4.149 J-.702 E.02858
G1 X173.652 Y159.26 E.00616
G3 X173.353 Y160.317 I-23.089 J-5.948 E.0327
G1 X173.366 Y160.728 E.01226
G2 X174.264 Y161.812 I1.446 J-.283 E.04371
G2 X175.062 Y161.951 I.917 J-2.918 E.02419
G1 X175.656 Y161.58 E.02088
G1 X175.929 Y161.263 E.01246
G1 X176.073 Y160.975 E.00956
M204 S10000
G1 X176.456 Y161.047 F60000
G1 F1728
M204 S8000
G1 X176.851 Y159.918 E.03563
G1 X176.948 Y159.81 E.00431
G1 X177.029 Y159.792 E.00249
G1 X184.192 Y159.792 E.21334
G1 X184.192 Y156.308 E.10376
G1 X174.172 Y156.308 E.29846
G1 X173.654 Y156.586 E.01749
G1 X173.296 Y156.955 E.01533
G1 X172.945 Y157.455 E.01819
G1 X172.961 Y158.085 E.01879
G2 X173.264 Y159.18 I4.792 J-.738 E.0339
G1 X173.267 Y159.296 E.00347
G1 X172.978 Y160.255 E.02984
G1 X172.994 Y160.791 E.01597
G2 X173.235 Y161.451 I2.776 J-.639 E.02097
G1 X173.528 Y161.806 E.01371
G1 X173.926 Y162.084 E.01449
G1 X174.431 Y162.248 E.01581
G1 X175.152 Y162.338 E.02164
G1 X175.893 Y161.877 E.02599
G1 X176.237 Y161.481 E.01562
G1 X176.429 Y161.1 E.0127
; WIPE_START
G1 F9547.299
G1 X176.237 Y161.481 E-.16206
G1 X175.893 Y161.877 E-.19925
G1 X175.152 Y162.338 E-.33163
G1 X174.977 Y162.317 E-.06706
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.5 Y163.38 Z16.8 F60000
G1 Z16.4
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.43173
G1 F1728
M204 S8000
G1 X175.5 Y164.694 E.04036
; CHANGE_LAYER
; Z_HEIGHT: 16.6
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F9259.021
G1 X175.5 Y163.38 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 83/165
; update layer progress
M73 L83
M991 S0 P82 ;notify layer change

M106 S224.4
; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z16.8 I.079 J-1.214 P1  F60000
G1 X173.204 Y163.231 Z16.8
G1 Z16.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2105
M204 S8000
G1 X173.25 Y163.046 E.00612
G1 X174.94 Y163.046 E.05434
G2 X177.296 Y160.546 I-.204 J-2.553 E.12108
G1 X185.398 Y160.546 E.26053
G1 X185.398 Y161.139 E.01908
G1 X177.863 Y161.139 E.24229
G3 X177.137 Y162.539 I-4.16 J-1.27 E.05102
G3 X175.898 Y163.455 I-2.863 J-2.576 E.04987
G1 X175.898 Y164.898 E.04639
G1 X175.102 Y164.898 E.02559
G1 X175.102 Y163.687 E.03893
G3 X173.721 Y163.466 I.175 J-5.502 E.0451
G3 X173.256 Y163.26 I1.105 J-3.121 E.01637
; COOLING_NODE: 0
; WIPE_START
G1 F8843.478
G1 X173.25 Y163.046 E-.08122
G1 X174.94 Y163.046 E-.64218
G1 X175.035 Y163.031 E-.0366
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.61 Y157.954 Z17 F60000
G1 Z16.6
G1 E.8 F1800
G1 F2105
M204 S8000
G1 X171.595 Y157.398 E.01789
G1 X164.602 Y157.398 E.22487
G1 X164.602 Y156.602 E.02559
G1 X171.906 Y156.602 E.23485
G3 X173.002 Y155.393 I3.409 J1.988 E.05286
G3 X173.549 Y155.102 I1.899 J2.913 E.01995
G1 X185.398 Y155.102 E.38103
G1 X185.398 Y155.454 E.01132
G1 X174.578 Y155.454 E.34792
G2 X172.204 Y157.954 I.178 J2.547 E.12171
G1 X171.67 Y157.954 E.01719
; COOLING_NODE: 0
M204 S250
G1 X171.214 Y157.831 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1595
M204 S5000
G1 X171.213 Y157.79 E.00122
G1 X164.21 Y157.79 E.2086
G1 X164.21 Y156.21 E.04706
G1 X168.899 Y156.21 E.13966
G1 X169.299 Y156.21 E.01191
G1 X169.699 Y156.21 E.01191
G1 X170.099 Y156.21 E.01191
G1 X170.499 Y156.21 E.01191
G1 X170.899 Y156.21 E.01191
G1 X171.299 Y156.21 E.01191
G1 X171.699 Y156.21 E.01191
G1 X171.727 Y156.169 E.00148
M106 S229.5
G3 X173.47 Y154.71 I3.045 J1.867 E.06891
M106 S224.4
M106 S229.5
G1 X173.779 Y154.71 E.00923
M106 S224.4
G1 X174.179 Y154.71 E.01191
G1 X174.579 Y154.71 E.01191
G1 X174.979 Y154.71 E.01191
G1 X175.379 Y154.71 E.01191
G1 X175.779 Y154.71 E.01191
G1 X176.179 Y154.71 E.01191
G1 X176.579 Y154.71 E.01191
G1 X185.79 Y154.71 E.27435
G1 X185.79 Y158.631 E.11679
G1 X185.79 Y159.031 E.01191
G1 X185.79 Y159.431 E.01191
G1 X185.79 Y159.831 E.01191
G1 X185.79 Y160.231 E.01191
G1 X185.79 Y160.631 E.01191
G1 X185.79 Y161.031 E.01191
G1 X185.79 Y161.431 E.01191
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

M106 S229.5
G1 X185.79 Y161.531 E.003
M106 S224.4
M106 S229.5
G1 X178.535 Y161.531 E.21611
M106 S224.4
M106 S229.5
G1 X178.135 Y161.531 E.01191
M106 S224.4
M106 S229.5
G1 X178.031 Y161.806 E.00874
M106 S224.4
M106 S229.5
G3 X176.331 Y163.661 I-3.307 J-1.323 E.07662
M106 S224.4
G1 X176.29 Y163.684 E.0014
G1 X176.29 Y164.084 E.01191
G1 X176.29 Y164.484 E.01191
G1 X176.29 Y164.884 E.01191
G1 X176.29 Y165.29 E.01208
G1 X175.89 Y165.29 E.01191
G1 X175.49 Y165.29 E.01191
G1 X175.11 Y165.29 E.01132
G1 X174.71 Y165.29 E.01191
G1 X174.71 Y164.843 E.01332
G1 X174.71 Y164.443 E.01191
G1 X174.71 Y164.043 E.01191
G1 X174.669 Y164.039 E.00123
M106 S229.5
G3 X171.444 Y159.249 I.107 J-3.552 E.20075
G3 X171.214 Y157.891 I3.836 J-1.35 E.04123
M106 S224.4
M204 S10000
G1 X171.907 Y157.75 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.283874
G1 F2105
M204 S8000
G1 X171.931 Y157.392 E.00683
; LINE_WIDTH: 0.322225
G1 X171.944 Y157.283 E.00242
; LINE_WIDTH: 0.352614
G1 X171.955 Y157.19 E.0023
; LINE_WIDTH: 0.386442
G1 X171.95 Y157.136 E.00147
; LINE_WIDTH: 0.425987
G1 X171.945 Y157.082 E.00164
; LINE_WIDTH: 0.465532
G1 X171.939 Y157.028 E.00181
; LINE_WIDTH: 0.467262
G1 X172.282 Y156.785 E.01409
M204 S10000
G1 X172.206 Y156.704 F60000
; LINE_WIDTH: 0.265419
G1 F2105
M204 S8000
G1 X172.113 Y156.874 E.0034
; LINE_WIDTH: 0.301218
G1 X172.006 Y156.984 E.00313
; LINE_WIDTH: 0.335155
G1 X171.9 Y157.094 E.00354
; LINE_WIDTH: 0.369092
G1 X171.794 Y157.205 E.00395
M204 S10000
G1 X171.866 Y157.014 F60000
; LINE_WIDTH: 0.472589
G1 F2105
M204 S8000
G1 X171.939 Y157.027 E.00251
M204 S10000
G1 X171.866 Y157.014 F60000
; LINE_WIDTH: 0.431863
G1 F2105
M204 S8000
G1 X171.793 Y157 E.00227
G1 X164.806 Y157 E.21469
; WIPE_START
G1 F9255.859
G1 X166.806 Y157 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.206 Y156.704 Z17 F60000
G1 Z16.6
G1 E.8 F1800
; LINE_WIDTH: 0.229535
G1 F2105
M204 S8000
G3 X173.631 Y155.391 I2.571 J1.36 E.02912
; LINE_WIDTH: 0.192183
G1 X173.762 Y155.368 E.00157
; LINE_WIDTH: 0.152953
G1 X173.882 Y155.348 E.00105
; LINE_WIDTH: 0.115602
G1 X174.001 Y155.328 E.0007
; WIPE_START
G1 F15000
G1 X173.882 Y155.348 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X177.663 Y160.861 Z17 F60000
G1 Z16.6
G1 E.8 F1800
; LINE_WIDTH: 0.280989
G1 F2105
M204 S8000
G1 X177.604 Y160.88 E.00117
G1 X177.543 Y161.108 E.00444
; LINE_WIDTH: 0.230725
G1 X177.45 Y161.395 E.00447
G3 X175.867 Y163.124 I-2.747 J-.927 E.03581
; LINE_WIDTH: 0.263708
G1 X175.632 Y163.233 E.00451
; LINE_WIDTH: 0.306259
G1 X175.591 Y163.267 E.00113
; LINE_WIDTH: 0.350839
G1 X175.549 Y163.302 E.00132
; LINE_WIDTH: 0.39542
G1 X175.507 Y163.336 E.00151
; LINE_WIDTH: 0.431938
G1 X175.493 Y163.355 E.00072
; LINE_WIDTH: 0.434312
G1 X175.479 Y163.374 E.00072
G1 X175.5 Y163.503 E.00405
G1 X175.5 Y164.694 E.03685
; WIPE_START
G1 F9197.947
G1 X175.5 Y163.503 E-.67289
G1 X175.479 Y163.374 E-.07389
G1 X175.493 Y163.355 E-.01322
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.479 Y163.374 Z17 F60000
G1 Z16.6
G1 E.8 F1800
; LINE_WIDTH: 0.449597
G1 F2105
M204 S8000
G1 X175.425 Y163.362 E.00175
; LINE_WIDTH: 0.399603
G1 X175.372 Y163.351 E.00154
; LINE_WIDTH: 0.362333
G1 X175.321 Y163.349 E.0013
; LINE_WIDTH: 0.330481
G1 X175.147 Y163.354 E.00395
; LINE_WIDTH: 0.284308
G3 X174.956 Y163.359 I-.16 J-2.442 E.00364
; LINE_WIDTH: 0.247753
G1 X174.676 Y163.345 E.00453
; LINE_WIDTH: 0.220531
G1 X174.397 Y163.332 E.00393
; LINE_WIDTH: 0.190749
G1 X174.195 Y163.315 E.00236
; LINE_WIDTH: 0.151406
G1 X173.994 Y163.292 E.00173
; LINE_WIDTH: 0.112589
G1 X173.863 Y163.272 E.00073
; WIPE_START
G1 F15000
G1 X173.994 Y163.292 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X177.663 Y160.861 Z17 F60000
G1 Z16.6
G1 E.8 F1800
; LINE_WIDTH: 0.247715
G1 F2105
M204 S8000
G1 X177.723 Y160.842 E.001
; LINE_WIDTH: 0.229063
G1 X185.194 Y160.843 E.10987
; WIPE_START
G1 F15000
G1 X183.194 Y160.843 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X185.583 Y156.451 Z17 F60000
G1 Z16.6
G1 E.8 F1800
; FEATURE: Top surface
; LINE_WIDTH: 0.42
G1 F2105
M204 S2000
G1 X184.808 Y155.676 E.03264
G1 X184.674 Y155.543
G1 X184.141 Y155.543
G1 X184.274 Y155.676
G1 X185.583 Y156.985 E.0551
G1 X185.716 Y157.118
G1 X185.716 Y157.652
G1 X185.583 Y157.518
G1 X183.741 Y155.676 E.07757
G1 X183.608 Y155.543
G1 X183.074 Y155.543
G1 X183.208 Y155.676
G1 X185.583 Y158.051 E.10003
G1 X185.716 Y158.185
G1 X185.716 Y158.718
G1 X185.583 Y158.584
G1 X182.675 Y155.676 E.12249
G1 X182.541 Y155.543
G1 X182.008 Y155.543
G1 X182.141 Y155.676
G1 X185.583 Y159.118 E.14496
G1 X185.716 Y159.251
G1 X185.716 Y159.785
G1 X185.583 Y159.651
G1 X181.608 Y155.676 E.16742
G1 X181.475 Y155.543
G1 X180.941 Y155.543
G1 X181.075 Y155.676
G1 X185.583 Y160.184 E.18988
G1 X185.716 Y160.318
G1 X185.322 Y160.457
G1 X185.189 Y160.324
G1 X180.542 Y155.676 E.19575
G1 X180.408 Y155.543
G1 X179.875 Y155.543
G1 X180.008 Y155.676
G1 X184.655 Y160.324 E.19575
G1 X184.789 Y160.457
G1 X184.256 Y160.457
G1 X184.122 Y160.324
G1 X179.475 Y155.676 E.19575
G1 X179.342 Y155.543
G1 X178.808 Y155.543
G1 X178.942 Y155.676
G1 X183.589 Y160.324 E.19575
G1 X183.723 Y160.457
G1 X183.189 Y160.457
G1 X183.056 Y160.324
G1 X178.409 Y155.676 E.19575
G1 X178.275 Y155.543
G1 X177.742 Y155.543
G1 X177.875 Y155.676
G1 X182.522 Y160.324 E.19575
G1 X182.656 Y160.457
G1 X182.123 Y160.457
G1 X181.989 Y160.324
G1 X177.342 Y155.676 E.19575
G1 X177.209 Y155.543
G1 X176.675 Y155.543
G1 X176.809 Y155.676
G1 X181.456 Y160.324 E.19575
G1 X181.59 Y160.457
G1 X181.056 Y160.457
G1 X180.923 Y160.323
G1 X176.276 Y155.676 E.19575
G1 X176.142 Y155.543
G1 X175.609 Y155.543
G1 X175.742 Y155.676
G1 X180.389 Y160.323 E.19575
G1 X180.523 Y160.457
G1 X179.99 Y160.457
G1 X179.856 Y160.323
G1 X175.209 Y155.676 E.19575
G1 X175.075 Y155.543
G1 X174.542 Y155.543
G1 X174.676 Y155.676
G1 X179.323 Y160.323 E.19575
G1 X179.456 Y160.457
G1 X178.923 Y160.457
G1 X178.79 Y160.323
G1 X174.208 Y155.741 E.19302
G1 X174.074 Y155.608
G1 X173.674 Y155.741
G1 X173.808 Y155.875
G1 X178.256 Y160.323 E.1874
G1 X178.39 Y160.457
G1 X177.857 Y160.457
G1 X177.723 Y160.323
G1 X173.465 Y156.066 E.17935
G1 X173.332 Y155.932
G1 X173.034 Y156.168
G1 X173.168 Y156.302
G1 X177.19 Y160.323 E.16942
G1 X177.323 Y160.457
G1 X177.198 Y160.865
G1 X177.064 Y160.731
G1 X172.913 Y156.58 E.17487
G1 X172.779 Y156.446
G1 X172.568 Y156.768
G1 X172.702 Y156.902
G1 X176.973 Y161.173 E.17994
G1 X177.107 Y161.307
G1 X176.953 Y161.687
G1 X176.82 Y161.553
G1 X172.542 Y157.275 E.18019
G1 X172.408 Y157.142
G1 X172.311 Y157.578
G1 X172.445 Y157.712
G1 X176.618 Y161.884 E.17578
G1 X176.751 Y162.018
G1 X176.5 Y162.3
G1 X176.367 Y162.167
G1 X172.377 Y158.177 E.16809
G1 X172.243 Y158.043
G1 X171.71 Y158.043
G1 X171.843 Y158.177
G1 X176.077 Y162.41 E.17833
G1 X176.21 Y162.543
G1 X175.87 Y162.736
G1 X175.736 Y162.603
G1 X171.44 Y158.307 E.18097
G1 X171.307 Y158.173
G1 X171.437 Y158.837
G1 X171.571 Y158.971
G1 X175.345 Y162.745 E.15898
G1 X175.479 Y162.878
G1 X175.024 Y162.957
G1 X174.891 Y162.823
G1 X171.578 Y159.511 E.13953
G1 X171.445 Y159.378
G1 X171.34 Y159.806
G1 X171.474 Y159.94
G1 X174.357 Y162.823 E.12147
G1 X174.491 Y162.957
G1 X173.958 Y162.957
G1 X173.824 Y162.823
G1 X171.427 Y160.426 E.10098
G1 X171.293 Y160.293
G1 X171.331 Y160.864
G1 X171.465 Y160.997
G1 X173.291 Y162.823 E.07693
G1 X173.424 Y162.957
M73 P56 R12
G1 X172.891 Y162.957
G1 X172.757 Y162.823
G1 X171.661 Y161.727 E.04619
; WIPE_START
G1 F9547.055
M204 S8000
G1 X172.757 Y162.823 E-.58928
G1 X172.891 Y162.957 E-.07182
G1 X173.151 Y162.957 E-.09891
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.435 Y162.842 Z17 F60000
G1 Z16.6
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.133201
G1 F2105
M204 S8000
G3 X172.107 Y162.489 I5.686 J-5.609 E.00344
; LINE_WIDTH: 0.100395
G1 X172.002 Y162.364 E.00074
; CHANGE_LAYER
; Z_HEIGHT: 16.8
; LAYER_HEIGHT: 0.199999
; WIPE_START
G1 F15000
G1 X172.107 Y162.489 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 84/165
; update layer progress
M73 L84
M991 S0 P83 ;notify layer change

M106 S226.95
; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z17 I.578 J1.071 P1  F60000
G1 X176.739 Y159.989 Z17
G1 Z16.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1404
M204 S8000
G1 X184.991 Y159.989 E.26535
G1 X184.991 Y160.858 E.02796
G1 X177.684 Y160.858 E.23497
G3 X177.201 Y161.971 I-6.427 J-2.127 E.03907
G3 X176.169 Y162.981 I-2.463 J-1.483 E.04693
G1 X175.491 Y163.347 E.02479
G1 X175.491 Y163.435 E.00283
G3 X174.352 Y163.33 I.887 J-15.84 E.03677
G3 X172.686 Y162.49 I.444 J-2.954 E.06105
G1 X175.859 Y162.489 E.10205
G1 X175.859 Y162.156 E.01071
G2 X176.399 Y161.609 I-1.664 J-2.183 E.02478
G1 X176.739 Y161.609 E.01094
G1 X176.739 Y160.049 E.05017
; COOLING_NODE: 0
M204 S10000
G1 X176.332 Y159.582 F60000
G1 F1404
M204 S8000
G1 X185.398 Y159.582 E.29154
G1 X185.398 Y161.266 E.05414
G1 X177.96 Y161.265 E.23919
G3 X177.198 Y162.662 I-3.892 J-1.217 E.0515
G3 X175.898 Y163.59 I-2.912 J-2.701 E.05171
G1 X175.898 Y164.898 E.04205
G1 X175.102 Y164.898 E.02559
G1 X175.102 Y163.809 E.035
G3 X173.573 Y163.546 I.112 J-5.22 E.05008
G3 X171.894 Y162.083 I1.181 J-3.05 E.07307
G1 X175.452 Y162.082 E.11441
G1 X175.452 Y161.923 E.0051
G2 X176.166 Y161.202 I-.853 J-1.559 E.03309
G1 X176.332 Y161.202 E.00533
G1 X176.332 Y159.642 E.05017
; COOLING_NODE: 0
M204 S250
G1 X175.94 Y159.19 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1404
M204 S5000
G1 X185.762 Y159.19 E.29259
G1 X185.79 Y159.19 E.00082
G1 X185.79 Y159.572 E.0114
G1 X185.79 Y159.972 E.01191
G1 X185.79 Y160.372 E.01191
G1 X185.79 Y160.772 E.01191
G1 X185.79 Y161.172 E.01191
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X185.79 Y161.572 E.01191
M106 S229.5
G1 X185.79 Y161.658 E.00254
M106 S226.95
M106 S229.5
G1 X178.226 Y161.657 E.22532
G3 X176.331 Y163.802 I-3.564 J-1.239 E.08744
M106 S226.95
G1 X176.29 Y163.824 E.00139
G1 X176.29 Y164.224 E.01191
G1 X176.29 Y164.624 E.01191
G1 X176.29 Y165.024 E.01191
G1 X176.29 Y165.29 E.00792
G1 X175.89 Y165.29 E.01191
G1 X175.51 Y165.29 E.01132
G1 X175.11 Y165.29 E.01191
G1 X174.71 Y165.29 E.01191
G1 X174.71 Y164.968 E.00959
G1 X174.71 Y164.568 E.01191
G1 X174.71 Y164.168 E.01191
G1 X174.669 Y164.164 E.00123
M106 S229.5
G1 X174.232 Y164.121 E.01308
M106 S226.95
M106 S229.5
G1 X173.978 Y164.075 E.00769
M106 S226.95
M106 S229.5
G1 X173.856 Y164.047 E.00373
M106 S226.95
M106 S229.5
G1 X173.432 Y163.91 E.01326
M106 S226.95
M106 S229.5
G3 X172.66 Y163.499 I1.368 J-3.501 E.02611
M106 S226.95
M106 S229.5
G1 X172.251 Y163.171 E.01562
M106 S226.95
M106 S229.5
G1 X172.161 Y163.084 E.00372
M106 S226.95
M106 S229.5
G1 X171.87 Y162.745 E.01332
M106 S226.95
M106 S229.5
G3 X171.291 Y161.69 I3.136 J-2.405 E.03599
M106 S226.95
M106 S229.5
G1 X171.382 Y161.69 E.0027
M106 S226.95
G1 X171.782 Y161.69 E.01191
G1 X172.182 Y161.69 E.01191
G1 X172.582 Y161.69 E.01191
G1 X172.982 Y161.69 E.01191
G1 X173.382 Y161.69 E.01191
G1 X175.06 Y161.69 E.04999
G1 X175.06 Y161.647 E.00126
G2 X175.897 Y160.81 I-.31 J-1.147 E.03692
G1 X175.94 Y160.81 E.00127
G1 X175.94 Y159.25 E.04648
; WIPE_START
G1 F9547.055
M204 S8000
G1 X177.94 Y159.237 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X177.255 Y160.538 Z17.2 F60000
G1 Z16.8
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.645961
G1 F1404
M204 S8000
G1 X177.222 Y160.711 E.00838
; LINE_WIDTH: 0.601441
G1 X177.189 Y160.884 E.00777
; LINE_WIDTH: 0.556921
G1 X177.156 Y161.057 E.00715
; LINE_WIDTH: 0.512401
G1 X177.123 Y161.23 E.00653
; LINE_WIDTH: 0.467881
G1 X177.089 Y161.403 E.00591
; LINE_WIDTH: 0.423361
G1 X177.056 Y161.576 E.00529
; LINE_WIDTH: 0.378842
G1 X177.023 Y161.749 E.00467
; LINE_WIDTH: 0.334322
G1 X176.99 Y161.921 E.00405
M204 S10000
G1 X176.807 Y161.813 F60000
; LINE_WIDTH: 0.504331
G1 F1404
M204 S8000
G3 X175.887 Y162.692 I-3.161 J-2.386 E.04659
M204 S10000
G1 X175.756 Y162.973 F60000
; LINE_WIDTH: 0.54235
G1 F1404
M204 S8000
G1 X175.122 Y162.945 E.02504
; LINE_WIDTH: 0.505851
G3 X174.416 Y162.912 I.552 J-19.572 E.02582
; LINE_WIDTH: 0.464515
G1 X174.221 Y162.895 E.00653
; LINE_WIDTH: 0.427033
G3 X174.056 Y162.874 I.472 J-4.413 E.00504
; LINE_WIDTH: 0.385651
G1 X173.929 Y162.854 E.00347
; LINE_WIDTH: 0.349935
G1 X173.631 Y162.799 E.00736
; LINE_WIDTH: 0.318025
G1 X173.333 Y162.743 E.0066
; WIPE_START
G1 F13085.906
G1 X173.631 Y162.799 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.5 Y163.641 Z17.2 F60000
G1 Z16.8
G1 E.8 F1800
; LINE_WIDTH: 0.43173
G1 F1404
M204 S8000
G1 X175.5 Y164.694 E.03236
; WIPE_START
G1 F9259.021
G1 X175.5 Y163.641 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X177.255 Y160.538 Z17.2 F60000
G1 Z16.8
G1 E.8 F1800
; LINE_WIDTH: 0.662479
G1 F1404
M204 S8000
G1 X177.261 Y160.511 E.00138
G1 X177.332 Y160.489 E.00364
; LINE_WIDTH: 0.614219
G1 X177.403 Y160.467 E.00336
; LINE_WIDTH: 0.570356
G1 X177.474 Y160.445 E.0031
; LINE_WIDTH: 0.526492
G1 X177.546 Y160.423 E.00284
; LINE_WIDTH: 0.504938
G1 X184.787 Y160.424 E.2643
; COOLING_NODE: 0
; WIPE_START
G1 F7791.918
G1 X182.787 Y160.424 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.271 Y159.099 Z17.2 F60000
G1 X171.935 Y158.511 Z17.2
G1 Z16.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1404
M204 S8000
G3 X171.896 Y158.153 I3.41 J-.555 E.01159
G1 X171.866 Y157.009 E.03679
G1 X171.995 Y157.009 E.00416
G3 X172.777 Y155.932 I4.45 J2.407 E.04292
G3 X173.347 Y155.509 I2.915 J3.336 E.02285
G1 X184.991 Y155.509 E.37443
G1 X184.991 Y156.011 E.01614
G1 X173.641 Y156.011 E.36498
G1 X173.641 Y156.351 E.01094
G2 X173.092 Y156.891 I1.254 J1.826 E.02487
G1 X172.761 Y156.891 E.01064
G1 X172.761 Y158.511 E.0521
G1 X171.995 Y158.511 E.02464
; COOLING_NODE: 0
M204 S10000
G1 X171.489 Y158.172 F60000
G1 F1404
M204 S8000
G1 X171.469 Y157.398 E.02491
G1 X164.602 Y157.398 E.22081
G1 X164.602 Y156.602 E.02559
G1 X171.771 Y156.602 E.23053
G3 X173.131 Y155.164 I3.348 J1.804 E.06437
G1 X173.244 Y155.102 E.00415
G1 X185.398 Y155.102 E.39084
G1 X185.398 Y156.418 E.04232
G1 X174.048 Y156.418 E.36498
G1 X174.048 Y156.585 E.00537
G2 X173.329 Y157.298 I.732 J1.458 E.0331
G1 X173.168 Y157.298 E.00517
G1 X173.168 Y158.918 E.0521
G1 X171.616 Y158.918 E.04992
G3 X171.493 Y158.232 I3.244 J-.935 E.02245
; COOLING_NODE: 0
M204 S250
G1 X171.088 Y157.831 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1404
M204 S5000
G1 X171.087 Y157.79 E.00122
G1 X164.21 Y157.79 E.20484
G1 X164.21 Y156.21 E.04706
G1 X169.155 Y156.21 E.14729
G1 X169.555 Y156.21 E.01191
G1 X169.955 Y156.21 E.01191
G1 X170.355 Y156.21 E.01191
G1 X170.755 Y156.21 E.01191
G1 X171.155 Y156.21 E.01191
G1 X171.555 Y156.21 E.01191
G1 X171.581 Y156.169 E.00144
M106 S229.5
G1 X171.694 Y155.99 E.00632
M106 S226.95
M106 S229.5
G1 X171.765 Y155.886 E.00373
M106 S226.95
M106 S229.5
G1 X172.089 Y155.492 E.0152
M106 S226.95
M106 S229.5
G3 X173.154 Y154.71 I2.698 J2.554 E.03955
M106 S226.95
M106 S229.5
G1 X173.364 Y154.71 E.00626
M106 S226.95
G1 X173.764 Y154.71 E.01191
G1 X174.164 Y154.71 E.01191
G1 X174.564 Y154.71 E.01191
G1 X174.964 Y154.71 E.01191
G1 X175.364 Y154.71 E.01191
G1 X185.79 Y154.71 E.31056
G1 X185.79 Y156.81 E.06256
G1 X174.44 Y156.81 E.33808
G1 X174.435 Y156.852 E.00127
G2 X173.603 Y157.69 I.375 J1.204 E.03658
G1 X173.56 Y157.69 E.00128
G1 X173.56 Y158.91 E.03635
G1 X173.56 Y159.31 E.01191
G1 X172.982 Y159.31 E.01724
G1 X172.582 Y159.31 E.01191
G1 X172.182 Y159.31 E.01191
G1 X171.782 Y159.31 E.01191
G1 X171.382 Y159.31 E.01191
M106 S229.5
G1 X171.291 Y159.31 E.0027
M106 S226.95
M106 S229.5
G1 X171.309 Y159.249 E.00192
M106 S226.95
M106 S229.5
G1 X171.2 Y158.882 E.0114
M106 S226.95
M106 S229.5
G1 X171.138 Y158.572 E.00943
M106 S226.95
M106 S229.5
G3 X171.087 Y157.891 I3.925 J-.636 E.02036
M106 S226.95
; WIPE_START
G1 F4800
M204 S8000
G1 X171.087 Y157.79 E-.03836
G1 X169.188 Y157.79 E-.72164
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.662 Y157 Z17.2 F60000
G1 Z16.8
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1404
M204 S8000
G1 X164.806 Y157 E.21058
; WIPE_START
G1 F9259.259
G1 X166.806 Y157 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.331 Y158.308 Z17.2 F60000
G1 Z16.8
G1 E.8 F1800
; LINE_WIDTH: 0.512803
G1 F1404
M204 S8000
G1 X172.318 Y157.329 E.03634
; LINE_WIDTH: 0.499143
G1 X172.294 Y157.322 E.00088
; LINE_WIDTH: 0.452289
G1 X172.271 Y157.316 E.00079
; LINE_WIDTH: 0.405832
G1 X172.243 Y157.304 E.00087
; LINE_WIDTH: 0.359775
G1 X172.215 Y157.291 E.00076
; LINE_WIDTH: 0.313718
G1 X172.187 Y157.279 E.00065
; LINE_WIDTH: 0.267661
G1 X172.159 Y157.267 E.00054
; LINE_WIDTH: 0.221603
G1 X172.131 Y157.255 E.00043
; LINE_WIDTH: 0.175546
G1 X172.103 Y157.243 E.00032
; LINE_WIDTH: 0.129489
G1 X172.075 Y157.23 E.00021
M204 S10000
G1 X172.467 Y156.644 F60000
; LINE_WIDTH: 0.502216
G1 F1404
M204 S8000
G1 X172.884 Y156.455 E.01663
G3 X173.208 Y156.13 I1.582 J1.25 E.01669
G1 X173.221 Y156.136 E.00052
; LINE_WIDTH: 0.456669
G1 X173.293 Y156.17 E.0026
; LINE_WIDTH: 0.420166
G1 X173.365 Y156.204 E.00237
; LINE_WIDTH: 0.383663
G1 X173.437 Y156.238 E.00214
M204 S10000
G1 X173.373 Y155.808 F60000
; LINE_WIDTH: 0.137957
G1 F1404
M204 S8000
G3 X173.437 Y155.76 I.061 J.015 E.00065
G1 X184.787 Y155.76 E.08521
; CHANGE_LAYER
; Z_HEIGHT: 17
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F15000
G1 X182.787 Y155.76 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 85/165
; update layer progress
M73 L85
M991 S0 P84 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z17.2 I-.767 J-.945 P1  F60000
G1 X177.115 Y160.365 Z17.2
G1 Z17
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1247
M204 S8000
G1 X184.991 Y160.366 E.25324
G1 X184.991 Y160.971 E.01946
G1 X177.767 Y160.97 E.2323
G3 X177.333 Y161.967 I-6.436 J-2.208 E.03503
G3 X176.18 Y163.104 I-2.633 J-1.519 E.05269
G1 X175.491 Y163.462 E.02497
G1 X175.491 Y163.547 E.00275
G3 X174.337 Y163.442 I.88 J-15.931 E.03728
G3 X173.221 Y163.048 I.569 J-3.392 E.03821
G1 X173.269 Y162.865 E.00608
G1 X175.859 Y162.865 E.08329
G1 X175.859 Y162.588 E.00893
G2 X176.845 Y161.609 I-1.313 J-2.308 E.04519
G1 X177.115 Y161.609 E.0087
G1 X177.115 Y160.425 E.03806
; COOLING_NODE: 0
M204 S10000
G1 X176.708 Y159.958 F60000
G1 F1247
M204 S8000
G1 X185.398 Y159.958 E.27942
G1 X185.398 Y161.378 E.04564
G1 X178.04 Y161.377 E.23661
G3 X176.769 Y163.208 I-3.64 J-1.17 E.07273
G3 X175.898 Y163.709 I-3.211 J-4.573 E.03235
G1 X175.898 Y164.898 E.03823
G1 X175.102 Y164.898 E.02559
G1 X175.102 Y163.922 E.0314
G3 X173.588 Y163.671 I.123 J-5.445 E.04953
G3 X171.997 Y162.458 I1.193 J-3.215 E.06527
G1 X175.452 Y162.458 E.11111
G1 X175.452 Y162.329 E.00417
G2 X176.576 Y161.202 I-.713 J-1.836 E.05269
G1 X176.708 Y161.202 E.00425
G1 X176.708 Y160.018 E.03806
; COOLING_NODE: 0
M204 S250
G1 X176.316 Y159.566 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1247
M204 S5000
G1 X185.79 Y159.566 E.28219
G1 X185.79 Y160.499 E.02777
G1 X185.79 Y160.899 E.01191
G1 X185.79 Y161.299 E.01191
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

M73 P57 R12
G1 X185.79 Y161.699 E.01191
G1 X185.79 Y161.77 E.00212
M106 S229.5
G1 X178.303 Y161.769 E.22302
G3 X176.566 Y163.803 I-3.573 J-1.291 E.08143
M106 S226.95
M106 S229.5
G1 X176.331 Y163.926 E.00789
M106 S226.95
G1 X176.29 Y163.947 E.00138
G1 X176.29 Y164.347 E.01191
G1 X176.29 Y164.747 E.01191
G1 X176.29 Y165.29 E.01617
G1 X175.11 Y165.29 E.03515
G1 X174.71 Y165.29 E.01191
G1 X174.71 Y165.08 E.00624
G1 X174.71 Y164.68 E.01191
G1 X174.71 Y164.28 E.01191
G1 X174.669 Y164.277 E.00123
M106 S229.5
G3 X173.956 Y164.185 I.274 J-4.957 E.02143
M106 S226.95
M106 S229.5
G1 X173.456 Y164.031 E.0156
M106 S226.95
M106 S229.5
G3 X172.972 Y163.824 I1.73 J-4.718 E.01567
M106 S226.95
M106 S229.5
G3 X172.037 Y163.118 I1.895 J-3.48 E.03505
M106 S226.95
M106 S229.5
G1 X171.86 Y162.921 E.00789
M106 S226.95
M106 S229.5
G1 X171.552 Y162.497 E.01561
M106 S226.95
M106 S229.5
G1 X171.421 Y162.269 E.00781
M106 S226.95
M106 S229.5
G1 X171.322 Y162.066 E.00673
M106 S226.95
G1 X171.4 Y162.066 E.00231
G1 X171.8 Y162.066 E.01191
G1 X172.2 Y162.066 E.01191
G1 X175.06 Y162.066 E.08519
G1 X175.06 Y162.034 E.00095
G2 X176.285 Y160.81 I-.315 J-1.54 E.05464
G1 X176.316 Y160.81 E.00094
G1 X176.316 Y159.626 E.03526
; WIPE_START
G1 F9547.055
M204 S8000
G1 X178.316 Y159.614 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X177.476 Y160.726 Z17.4 F60000
G1 Z17
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.343123
G1 F1247
M204 S8000
G1 X177.498 Y160.712 E.00062
; LINE_WIDTH: 0.306359
G1 X177.564 Y160.69 E.00145
; LINE_WIDTH: 0.26204
G1 X177.63 Y160.668 E.00121
; LINE_WIDTH: 0.240374
G1 X184.787 Y160.668 E.11163
; WIPE_START
G1 F15000
G1 X182.787 Y160.668 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X177.476 Y160.726 Z17.4 F60000
G1 Z17
G1 E.8 F1800
; LINE_WIDTH: 0.33601
G1 F1247
M204 S8000
G1 X177.454 Y160.841 E.00271
; LINE_WIDTH: 0.292539
G1 X177.431 Y160.956 E.00231
; LINE_WIDTH: 0.249068
G1 X177.409 Y161.071 E.0019
; LINE_WIDTH: 0.205597
G1 X177.386 Y161.185 E.0015
; LINE_WIDTH: 0.162126
G1 X177.363 Y161.3 E.0011
; LINE_WIDTH: 0.118655
G1 X177.341 Y161.415 E.0007
M204 S10000
G1 X177.073 Y161.813 F60000
; LINE_WIDTH: 0.239992
G1 F1247
M204 S8000
G3 X176.161 Y162.765 I-2.362 J-1.35 E.02074
G1 X176.074 Y162.93 E.00289
; WIPE_START
G1 F15000
G1 X176.161 Y162.765 E-.09311
G1 X176.387 Y162.607 E-.13796
G1 X176.658 Y162.363 E-.18291
G1 X176.93 Y162.038 E-.21233
G1 X177.073 Y161.813 E-.13369
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.5 Y164.694 Z17.4 F60000
G1 Z17
G1 E.8 F1800
; LINE_WIDTH: 0.431726
G1 F1247
M204 S8000
G1 X175.5 Y163.753 E.02892
M204 S10000
G1 X175.538 Y163.208 F60000
; LINE_WIDTH: 0.279856
G1 F1247
M204 S8000
G1 X175 Y163.184 E.01009
; LINE_WIDTH: 0.240382
G3 X174.38 Y163.155 I.481 J-16.958 E.00967
; LINE_WIDTH: 0.197435
G1 X174.182 Y163.137 E.00243
; LINE_WIDTH: 0.156386
G1 X173.993 Y163.114 E.0017
; LINE_WIDTH: 0.11497
G1 X173.854 Y163.092 E.00081
; COOLING_NODE: 0
; WIPE_START
G1 F15000
G1 X173.993 Y163.114 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.785 Y158.135 Z17.4 F60000
G1 Z17
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1247
M204 S8000
G1 X171.745 Y157.009 E.03621
G1 X171.876 Y157.009 E.00421
G3 X172.553 Y156.002 I5.01 J2.632 E.0391
G3 X173.135 Y155.509 I2.867 J2.799 E.02456
G1 X173.641 Y155.509 E.01627
G1 X173.641 Y155.913 E.013
G2 X172.663 Y156.891 I1.034 J2.012 E.04517
G1 X172.385 Y156.891 E.00897
G1 X172.385 Y158.135 E.03999
G1 X171.845 Y158.135 E.01736
; COOLING_NODE: 0
M204 S10000
G1 X171.379 Y158.197 F60000
G1 F1247
M204 S8000
G1 X171.352 Y157.398 E.0257
G1 X164.602 Y157.398 E.21704
G1 X164.602 Y156.602 E.02559
G1 X171.647 Y156.602 E.22655
G3 X173.017 Y155.102 I3.476 J1.799 E.06608
G1 X185.398 Y155.102 E.39811
G1 X185.398 Y156.042 E.03021
G1 X174.048 Y156.042 E.36498
G1 X174.048 Y156.174 E.00427
G2 X172.923 Y157.298 I.679 J1.804 E.0527
G1 X172.792 Y157.298 E.00423
G1 X172.792 Y158.542 E.03999
G1 X171.413 Y158.542 E.04433
G3 X171.383 Y158.257 I8.186 J-1.012 E.00922
; COOLING_NODE: 0
M204 S250
G1 X170.974 Y157.831 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1247
M204 S5000
G1 X170.973 Y157.79 E.00122
G1 X164.21 Y157.79 E.20144
G1 X164.21 Y156.21 E.04706
G1 X170.627 Y156.21 E.19114
G1 X171.027 Y156.21 E.01191
M73 P57 R11
G1 X171.427 Y156.21 E.01191
G1 X171.452 Y156.169 E.00143
M106 S229.5
G1 X171.565 Y155.983 E.0065
M106 S226.95
M106 S229.5
G3 X171.961 Y155.464 I3.809 J2.494 E.01946
M106 S226.95
M106 S229.5
G1 X172.345 Y155.109 E.01557
M106 S226.95
M106 S229.5
G3 X172.763 Y154.796 I3.208 J3.856 E.01557
M106 S226.95
M106 S229.5
G1 X172.912 Y154.71 E.00511
M106 S226.95
G1 X173.062 Y154.71 E.00445
G1 X173.462 Y154.71 E.01191
G1 X173.862 Y154.71 E.01191
G1 X174.262 Y154.71 E.01191
G1 X185.79 Y154.71 E.34339
G1 X185.79 Y156.434 E.05134
G1 X174.44 Y156.434 E.33808
G1 X174.44 Y156.465 E.00092
G2 X173.216 Y157.69 I.318 J1.542 E.05463
G1 X173.184 Y157.69 E.00096
G1 X173.184 Y158.934 E.03704
G1 X172.372 Y158.934 E.02419
G1 X171.972 Y158.934 E.01191
G1 X171.572 Y158.934 E.01191
G1 X171.172 Y158.934 E.01191
G1 X171.098 Y158.934 E.00219
M106 S229.5
G3 X171.062 Y158.782 I1.797 J-.506 E.00464
M106 S226.95
M106 S229.5
G1 X171.017 Y158.522 E.00786
M106 S226.95
M106 S229.5
G3 X170.974 Y157.891 I4.945 J-.649 E.01887
M106 S226.95
; WIPE_START
G1 F6600
M204 S8000
G1 X170.973 Y157.79 E-.03835
G1 X169.074 Y157.79 E-.72165
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.541 Y157 Z17.4 F60000
G1 Z17
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1247
M204 S8000
G1 X164.806 Y157 E.20687
; WIPE_START
G1 F9259.259
G1 X166.806 Y157 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.081 Y157.931 Z17.4 F60000
G1 Z17
G1 E.8 F1800
; LINE_WIDTH: 0.255965
G1 F1247
M204 S8000
G1 X172.07 Y157.29 E.01078
G1 X172.179 Y156.975 E.00561
M204 S10000
G1 X172.423 Y156.687 F60000
; LINE_WIDTH: 0.240588
G1 F1247
M204 S8000
G3 X173.37 Y155.713 I2.409 J1.393 E.02144
M204 S10000
G1 X173.437 Y155.75 F60000
; LINE_WIDTH: 0.159461
G1 F1247
M204 S8000
G2 X172.971 Y155.881 I1.904 J7.639 E.00446
M204 S10000
G1 X173.844 Y155.572 F60000
; LINE_WIDTH: 0.575381
G1 F1247
M204 S8000
G1 X185.194 Y155.572 E.47738
; CHANGE_LAYER
; Z_HEIGHT: 17.2
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F6761.06
G1 X183.194 Y155.572 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 86/165
; update layer progress
M73 L86
M991 S0 P85 ;notify layer change

M106 S229.5
; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z17.4 I-.799 J-.918 P1  F60000
G1 X177.381 Y160.634 Z17.4
G1 Z17.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X184.991 Y160.634 E.24472
G1 X184.991 Y161.07 E.01403
G1 X177.856 Y161.069 E.22944
G3 X177.392 Y162.062 I-7.072 J-2.696 E.03527
G3 X176.18 Y163.216 I-2.694 J-1.616 E.05447
G1 X175.491 Y163.562 E.0248
G1 X175.491 Y163.651 E.00285
G1 X174.368 Y163.546 E.03626
G3 X173.571 Y163.333 I.652 J-4.045 E.02656
G1 X173.609 Y163.134 E.00652
G1 X174.846 Y163.134 E.03978
G2 X177.377 Y160.694 I-.103 J-2.64 E.1237
; COOLING_NODE: 0
M204 S10000
G1 X176.977 Y160.227 F60000
G1 F1200
M204 S8000
G1 X185.398 Y160.227 E.2708
G1 X185.398 Y161.477 E.04021
G1 X178.12 Y161.476 E.23403
G3 X177.186 Y162.981 I-4.137 J-1.526 E.05735
G3 X175.898 Y163.813 I-2.926 J-3.117 E.04956
G1 X175.898 Y164.898 E.03488
G1 X175.102 Y164.898 E.02559
G1 X175.102 Y164.023 E.02813
G3 X174.076 Y163.911 I.325 J-7.713 E.0332
G3 X172.063 Y162.727 I.73 J-3.544 E.07647
G1 X174.828 Y162.727 E.08891
G2 X176.982 Y160.286 I-.115 J-2.272 E.11663
; COOLING_NODE: 0
M204 S250
G1 X176.585 Y159.835 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X185.79 Y159.835 E.2742
G1 X185.79 Y161.811 E.05886
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X185.79 Y161.869 E.00174
G1 X178.374 Y161.868 E.22089
G3 X176.331 Y164.035 I-3.699 J-1.443 E.09092
G1 X176.29 Y164.055 E.00137
G1 X176.29 Y165.29 E.03678
G1 X174.71 Y165.29 E.04706
G1 X174.71 Y164.38 E.0271
G1 X174.669 Y164.376 E.00123
G3 X171.346 Y162.335 I.109 J-3.903 E.12164
G1 X171.412 Y162.335 E.00196
G1 X174.812 Y162.335 E.10127
G2 X176.585 Y160.56 I-.068 J-1.841 E.08219
G1 X176.585 Y159.895 E.01982
; WIPE_START
G1 F9547.055
M204 S8000
G1 X178.585 Y159.882 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X177.648 Y160.837 Z17.6 F60000
G1 Z17.2
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.171204
G1 F1200
M204 S8000
G1 X177.603 Y160.994 E.00165
; LINE_WIDTH: 0.135007
G1 X177.535 Y161.204 E.00161
; LINE_WIDTH: 0.104389
G1 X177.488 Y161.333 E.00066
; WIPE_START
G1 F15000
G1 X177.535 Y161.204 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X174.854 Y163.362 Z17.6 F60000
G1 Z17.2
G1 E.8 F1800
; LINE_WIDTH: 0.118173
G1 F1200
M204 S8000
G1 X175.12 Y163.363 E.00158
; LINE_WIDTH: 0.164301
G2 X175.409 Y163.316 I.008 J-.865 E.00282
; LINE_WIDTH: 0.135621
G1 X175.557 Y163.258 E.00116
; LINE_WIDTH: 0.109657
G1 X175.7 Y163.202 E.00081
M204 S10000
G1 X175.5 Y163.856 F60000
; LINE_WIDTH: 0.43173
G1 F1200
M204 S8000
G1 X175.5 Y164.694 E.02575
; COOLING_NODE: 0
; WIPE_START
G1 F9259.021
G1 X175.5 Y163.856 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.751 Y157.208 Z17.6 F60000
G1 X171.655 Y157.039 Z17.6
G1 Z17.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X171.654 Y157.009 E.00096
G1 X171.767 Y157.009 E.00363
G3 X172.409 Y156.015 I5.548 J2.877 E.03812
G3 X172.959 Y155.509 I2.883 J2.583 E.02405
G1 X173.435 Y155.509 E.01533
G1 X173.484 Y155.691 E.00605
G2 X172.119 Y157.866 I1.321 J2.344 E.08607
G1 X171.677 Y157.866 E.01423
G1 X171.657 Y157.099 E.02468
; COOLING_NODE: 0
M204 S10000
G1 X170.867 Y157.398 F60000
G1 F1200
M204 S8000
G1 X164.602 Y157.398 E.20144
G1 X164.602 Y156.602 E.02559
G1 X171.536 Y156.602 E.22298
G3 X172.573 Y155.289 I3.859 J1.982 E.05414
G3 X172.832 Y155.102 I1.481 J1.78 E.01029
G1 X185.398 Y155.102 E.40406
G1 X185.398 Y155.773 E.02158
G1 X174.674 Y155.773 E.34484
G2 X172.523 Y158.273 I.108 J2.268 E.11868
G1 X171.28 Y158.273 E.03997
G1 X171.257 Y157.398 E.02816
M73 P58 R11
G1 X170.927 Y157.398 E.01064
; COOLING_NODE: 0
M204 S250
G1 X170.876 Y157.831 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X170.875 Y157.79 E.00122
G1 X164.21 Y157.79 E.19854
G1 X164.21 Y156.21 E.04706
G1 X171.314 Y156.21 E.2116
G1 X171.338 Y156.169 E.00142
G3 X172.717 Y154.71 I3.58 J2.001 E.0604
G1 X172.83 Y154.71 E.00338
G1 X185.79 Y154.71 E.38603
G1 X185.79 Y156.165 E.04335
G1 X174.689 Y156.165 E.33065
G2 X172.915 Y157.939 I.089 J1.863 E.08196
G1 X172.915 Y158.665 E.02163
G1 X171.4 Y158.665 E.04514
G1 X171 Y158.665 E.01191
G1 X170.94 Y158.665 E.00179
G1 X170.928 Y158.603 E.0019
G1 X170.887 Y158.202 E.012
G3 X170.876 Y157.891 I5.1 J-.325 E.00927
; WIPE_START
G1 F9300
M204 S8000
G1 X170.875 Y157.79 E-.03837
G1 X168.976 Y157.79 E-.72163
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.904 Y157.663 Z17.6 F60000
G1 Z17.2
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.123523
G1 F1200
M204 S8000
G1 X171.918 Y157.434 E.00146
; LINE_WIDTH: 0.166837
G1 X171.937 Y157.261 E.00171
G1 X171.985 Y157.148 E.0012
; LINE_WIDTH: 0.13765
G1 X172.055 Y157.001 E.00122
; LINE_WIDTH: 0.110336
G1 X172.123 Y156.859 E.00084
M204 S10000
G1 X171.45 Y157 F60000
; LINE_WIDTH: 0.43172
G1 F1200
M204 S8000
G1 X164.806 Y157 E.20408
; WIPE_START
G1 F9259.259
G1 X166.806 Y157 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X173.721 Y155.791 Z17.6 F60000
G1 Z17.2
G1 E.8 F1800
; LINE_WIDTH: 0.405741
G1 F1200
M204 S8000
G1 X173.849 Y155.542 E.00802
; LINE_WIDTH: 0.44091
G1 X173.864 Y155.514 E.00099
G1 X173.98 Y155.495 E.00372
; LINE_WIDTH: 0.404856
G1 X174.115 Y155.478 E.00387
; LINE_WIDTH: 0.373157
G1 X174.234 Y155.463 E.00314
; LINE_WIDTH: 0.356745
G1 X174.249 Y155.462 E.00037
; LINE_WIDTH: 0.307823
G1 X174.666 Y155.438 E.00874
G1 X185.194 Y155.438 E.22031
; CHANGE_LAYER
; Z_HEIGHT: 17.4
; LAYER_HEIGHT: 0.199999
; WIPE_START
G1 F13589.917
G1 X183.194 Y155.438 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 87/165
; update layer progress
M73 L87
M991 S0 P86 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z17.6 I-.843 J-.877 P1  F60000
G1 X177.573 Y160.842 Z17.6
G1 Z17.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X184.991 Y160.842 E.23855
G1 X184.991 Y161.157 E.01013
G1 X177.922 Y161.157 E.22732
G3 X177.383 Y162.242 I-6.766 J-2.683 E.03899
G3 X176.171 Y163.319 I-2.656 J-1.767 E.05271
G1 X175.491 Y163.649 E.02432
G1 X175.491 Y163.738 E.00288
G1 X174.348 Y163.631 E.0369
G3 X173.967 Y163.56 I.532 J-3.921 E.01247
G1 X173.991 Y163.342 E.00706
G1 X174.85 Y163.342 E.02764
G2 X177.565 Y160.901 I-.107 J-2.849 E.12739
; COOLING_NODE: 0
M204 S10000
G1 X177.185 Y160.435 F60000
G1 F1200
M204 S8000
G1 X185.398 Y160.435 E.2641
G1 X185.398 Y161.564 E.03631
G1 X178.183 Y161.564 E.23201
G3 X176.931 Y163.319 I-3.868 J-1.435 E.07014
G3 X175.898 Y163.904 I-2.81 J-3.761 E.03827
G1 X175.898 Y164.898 E.03197
G1 X175.102 Y164.898 E.02559
G1 X175.102 Y164.111 E.02532
G3 X173.939 Y163.971 I.245 J-6.945 E.0377
G3 X172.14 Y162.935 I.856 J-3.568 E.06769
G1 X174.833 Y162.935 E.08659
G2 X177.185 Y160.495 I-.112 J-2.462 E.12018
; COOLING_NODE: 0
M204 S250
G1 X176.793 Y160.043 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X185.79 Y160.043 E.26799
G1 X185.79 Y161.91 E.05562
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X185.79 Y161.956 E.00138
G1 X178.434 Y161.956 E.2191
G3 X176.331 Y164.13 I-3.756 J-1.53 E.09232
G1 X176.29 Y164.15 E.00136
G1 X176.29 Y165.29 E.03397
G1 X174.71 Y165.29 E.04706
G1 X174.71 Y164.468 E.02449
G1 X174.669 Y164.464 E.00123
G3 X172.42 Y163.697 I.126 J-4.054 E.07184
G1 X172.311 Y163.615 E.00404
G3 X171.468 Y162.71 I2.587 J-3.253 E.03698
G1 X171.394 Y162.595 E.00407
G1 X171.363 Y162.543 E.00182
G1 X171.417 Y162.543 E.00163
G1 X174.816 Y162.543 E.10125
G2 X176.793 Y160.567 I-.075 J-2.052 E.09155
G1 X176.793 Y160.103 E.01383
; WIPE_START
G1 F9547.055
M204 S8000
G1 X178.793 Y160.09 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X173.777 Y163.424 Z17.8 F60000
G1 Z17.4
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.5179
G1 F1200
M204 S8000
G1 X172.796 Y163.232 E.03752
; COOLING_NODE: 0
; WIPE_START
G1 F7579.276
G1 X173.777 Y163.424 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.568 Y157.019 Z17.8 F60000
G1 Z17.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X171.567 Y157.009 E.00032
G1 X171.671 Y157.009 E.00333
G3 X172.202 Y156.135 I6.593 J3.413 E.03291
G3 X172.812 Y155.509 I2.647 J1.967 E.02819
G1 X173.058 Y155.509 E.00791
G1 X173.115 Y155.674 E.0056
G2 X171.929 Y157.658 I1.665 J2.342 E.07651
G1 X171.584 Y157.658 E.01108
G1 X171.569 Y157.079 E.01862
; COOLING_NODE: 0
M204 S10000
G1 X170.77 Y157.398 F60000
G1 F1200
M204 S8000
G1 X164.602 Y157.398 E.19835
G1 X164.602 Y156.602 E.02559
G1 X171.439 Y156.602 E.21984
G3 X172.614 Y155.147 I3.941 J1.982 E.06061
G1 X172.679 Y155.102 E.00253
G1 X185.398 Y155.102 E.40901
G1 X185.398 Y155.565 E.01489
G1 X174.669 Y155.565 E.34499
G2 X172.315 Y158.065 I.09 J2.443 E.12243
G1 X171.188 Y158.065 E.03625
G1 X171.17 Y157.398 E.02147
G1 X170.83 Y157.398 E.01093
; COOLING_NODE: 0
M204 S250
G1 X170.789 Y157.831 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X170.788 Y157.79 E.00122
G1 X164.21 Y157.79 E.19594
G1 X164.21 Y156.21 E.04706
G1 X171.215 Y156.21 E.20865
G1 X171.239 Y156.169 E.00142
G3 X172.556 Y154.71 I3.572 J1.9 E.05913
G1 X172.641 Y154.71 E.00255
G1 X185.79 Y154.71 E.39165
G1 X185.79 Y155.957 E.03715
G1 X174.684 Y155.957 E.3308
G2 X172.707 Y157.933 I.097 J2.075 E.09135
G1 X172.707 Y158.457 E.0156
G1 X170.868 Y158.457 E.05479
G1 X170.82 Y158.457 E.00141
G3 X170.789 Y157.891 I5.322 J-.579 E.01691
; WIPE_START
G1 F9547.055
M204 S8000
G1 X170.788 Y157.79 E-.03835
G1 X168.889 Y157.79 E-.72165
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.363 Y157 Z17.8 F60000
G1 Z17.4
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1200
M204 S8000
G1 X164.806 Y157 E.20141
; WIPE_START
G1 F9259.259
G1 X166.806 Y157 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X173.278 Y155.523 Z17.8 F60000
G1 Z17.4
G1 E.8 F1800
; LINE_WIDTH: 0.321418
G1 F1200
M204 S8000
G1 X173.665 Y155.443 E.00869
; LINE_WIDTH: 0.294085
G1 X173.802 Y155.419 E.00276
; LINE_WIDTH: 0.245374
G1 X173.939 Y155.395 E.00222
; LINE_WIDTH: 0.202543
G1 X174.084 Y155.376 E.00184
; LINE_WIDTH: 0.167618
G1 X174.219 Y155.359 E.00134
; LINE_WIDTH: 0.132653
G1 X174.452 Y155.342 E.00166
; LINE_WIDTH: 0.098915
G1 X185.194 Y155.334 E.04751
; CHANGE_LAYER
; Z_HEIGHT: 17.6
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F15000
G1 X183.194 Y155.335 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 88/165
; update layer progress
M73 L88
M991 S0 P87 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z17.8 I-.875 J-.845 P1  F60000
G1 X177.716 Y161.009 Z17.8
G1 Z17.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X178.092 Y161.009 E.0121
G1 X177.765 Y161.69 E.02429
G1 X177.55 Y161.598 E.00752
G2 X177.705 Y161.068 I-2.866 J-1.124 E.01777
; COOLING_NODE: 0
; WIPE_START
G1 F8843.478
G1 X178.092 Y161.009 E-.15403
G1 X177.765 Y161.69 E-.29688
G1 X177.55 Y161.598 E-.09189
G1 X177.67 Y161.231 E-.15189
G1 X177.705 Y161.068 E-.06531
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.844 Y163.306 Z18 F60000
G1 Z17.6
G1 E.8 F1800
G1 F1200
M204 S8000
G1 X175.931 Y163.519 E.00739
G1 X175.491 Y163.73 E.0157
G1 X175.491 Y163.814 E.0027
G1 X174.718 Y163.742 E.02497
G1 X174.729 Y163.509 E.0075
G2 X175.788 Y163.326 I-.005 J-3.189 E.03474
; COOLING_NODE: 0
; WIPE_START
G1 F8843.478
G1 X175.931 Y163.519 E-.09108
G1 X175.491 Y163.73 E-.18552
G1 X175.491 Y163.814 E-.03192
G1 X174.718 Y163.742 E-.29505
G1 X174.729 Y163.509 E-.0886
G1 X174.907 Y163.499 E-.06783
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X177.35 Y160.602 Z18 F60000
G1 Z17.6
G1 E.8 F1800
G1 F1200
M204 S8000
G1 X185.398 Y160.602 E.25878
G1 X185.398 Y161.64 E.03339
G1 X178.24 Y161.641 E.23017
G3 X177.073 Y163.303 I-3.997 J-1.566 E.06595
M73 P59 R11
G3 X175.898 Y163.986 I-2.962 J-3.743 E.04385
G1 X175.898 Y164.898 E.02933
G1 X175.102 Y164.898 E.02559
G1 X175.102 Y164.186 E.02288
G3 X174.049 Y164.072 I.291 J-7.588 E.03407
G3 X172.381 Y163.266 I.713 J-3.602 E.06023
G1 X172.439 Y163.102 E.00557
G1 X174.83 Y163.102 E.07691
G2 X177.347 Y160.662 I-.088 J-2.608 E.12359
; COOLING_NODE: 0
M204 S250
G1 X176.96 Y160.21 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X185.79 Y160.21 E.26302
G1 X185.79 Y161.997 E.05324
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X185.79 Y162.032 E.00104
G1 X178.487 Y162.033 E.21754
G3 X176.331 Y164.213 I-3.818 J-1.619 E.09355
G1 X176.29 Y164.233 E.00135
G1 X176.29 Y165.29 E.03149
G1 X174.71 Y165.29 E.04706
G1 X174.71 Y164.544 E.02223
G1 X174.669 Y164.54 E.00123
G3 X171.378 Y162.71 I.107 J-4.066 E.11662
G1 X171.42 Y162.71 E.00124
G1 X174.815 Y162.71 E.10113
G2 X176.96 Y160.563 I-.072 J-2.217 E.09956
G1 X176.96 Y160.27 E.00873
; WIPE_START
G1 F9547.055
M204 S8000
G1 X178.96 Y160.256 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X178.264 Y161.121 Z18 F60000
G1 Z17.6
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.674328
G1 F1200
M204 S8000
G1 X185.194 Y161.121 E.34566
; WIPE_START
G1 F5701.547
G1 X183.194 Y161.121 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X177.583 Y161.834 Z18 F60000
G1 Z17.6
G1 E.8 F1800
; LINE_WIDTH: 0.674423
G1 F1200
M204 S8000
G3 X176.078 Y163.34 I-3.018 J-1.511 E.10807
; WIPE_START
G1 F5700.689
G1 X176.528 Y163.064 E-.20041
G1 X176.942 Y162.721 E-.20442
G1 X177.249 Y162.369 E-.17748
G1 X177.497 Y161.972 E-.17769
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X174.519 Y163.622 Z18 F60000
G1 Z17.6
G1 E.8 F1800
; LINE_WIDTH: 0.621869
G1 F1200
M204 S8000
G1 X174.145 Y163.592 E.01717
; LINE_WIDTH: 0.592649
G1 X173.946 Y163.569 E.00871
; LINE_WIDTH: 0.556206
G1 X173.85 Y163.555 E.00394
; LINE_WIDTH: 0.528543
G1 X173.754 Y163.541 E.00373
; LINE_WIDTH: 0.497341
G1 X173.323 Y163.466 E.01568
; LINE_WIDTH: 0.462613
G1 X172.893 Y163.39 E.01448
; COOLING_NODE: 0
; WIPE_START
G1 F8577.705
G1 X173.323 Y163.466 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.491 Y157.009 Z18 F60000
G1 Z17.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X171.593 Y157.009 E.00328
G1 X171.819 Y156.616 E.01458
G1 X172.024 Y156.714 E.00731
G2 X171.786 Y157.491 I3.896 J1.615 E.02616
G1 X171.504 Y157.491 E.00908
G1 X171.493 Y157.069 E.01358
; COOLING_NODE: 0
M204 S10000
G1 X170.699 Y157.398 F60000
G1 F1200
M204 S8000
G1 X164.602 Y157.398 E.19606
G1 X164.602 Y156.602 E.02559
G1 X171.357 Y156.602 E.21723
G3 X172.545 Y155.102 I3.906 J1.873 E.06204
G1 X185.398 Y155.102 E.41329
G1 X185.398 Y155.398 E.00952
G1 X174.672 Y155.398 E.34491
G2 X172.15 Y157.898 I.089 J2.612 E.12555
G1 X171.107 Y157.898 E.03352
G1 X171.094 Y157.398 E.0161
G1 X170.759 Y157.398 E.01077
; COOLING_NODE: 0
M204 S250
G1 X170.713 Y157.831 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X170.712 Y157.79 E.00122
G1 X164.21 Y157.79 E.19368
G1 X164.21 Y156.21 E.04706
G1 X171.13 Y156.21 E.20612
G1 X171.154 Y156.169 E.00141
G3 X172.421 Y154.71 I3.627 J1.871 E.05812
G1 X172.484 Y154.71 E.00187
G1 X185.79 Y154.71 E.39634
G1 X185.79 Y155.79 E.03217
G1 X174.686 Y155.79 E.33074
G2 X172.54 Y157.935 I.074 J2.22 E.0995
G1 X172.54 Y158.29 E.01057
G1 X170.764 Y158.29 E.05291
G1 X170.73 Y158.29 E.00101
G3 X170.712 Y157.891 I3.854 J-.371 E.01192
; WIPE_START
G1 F9547.055
M204 S8000
G1 X170.712 Y157.79 E-.03836
G1 X168.813 Y157.79 E-.72164
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.287 Y157 Z18 F60000
G1 Z17.6
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1200
M204 S8000
G1 X164.806 Y157 E.19907
; WIPE_START
G1 F9259.259
G1 X166.806 Y157 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.296 Y156.62 Z18 F60000
G1 Z17.6
G1 E.8 F1800
; LINE_WIDTH: 0.580843
G1 F1200
M204 S8000
G1 X172.201 Y156.266 E.01556
; LINE_WIDTH: 0.616195
G1 X172.195 Y156.242 E.00113
; LINE_WIDTH: 0.654439
G1 X172.189 Y156.218 E.00121
; LINE_WIDTH: 0.67363
G3 X172.355 Y155.999 I2.693 J1.874 E.01369
G1 X172.591 Y155.746 E.01723
G1 X173.114 Y155.306 E.03409
; CHANGE_LAYER
; Z_HEIGHT: 17.8
; LAYER_HEIGHT: 0.199999
; WIPE_START
G1 F5707.853
G1 X172.591 Y155.746 E-.39858
G1 X172.355 Y155.999 E-.20139
G1 X172.189 Y156.218 E-.16004
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 89/165
; update layer progress
M73 L89
M991 S0 P88 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z18 I-1.109 J.501 P1  F60000
G1 X175.506 Y163.559 Z18
G1 Z17.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X175.57 Y163.762 E.00684
G1 X175.491 Y163.799 E.00282
G1 X175.491 Y163.879 E.00257
G1 X175.103 Y163.843 E.01252
G1 X175.095 Y163.629 E.00689
G1 X175.447 Y163.569 E.01148
; COOLING_NODE: 0
; WIPE_START
G1 F8843.478
G1 X175.57 Y163.762 E-.12821
G1 X175.491 Y163.799 E-.04911
G1 X175.491 Y163.879 E-.04469
G1 X175.103 Y163.843 E-.21812
G1 X175.095 Y163.629 E-.11994
G1 X175.447 Y163.569 E-.19993
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X177.476 Y160.737 Z18.2 F60000
G1 Z17.8
G1 E.8 F1800
G1 F1200
M204 S8000
G1 X185.398 Y160.737 E.25474
G1 X185.398 Y161.706 E.03115
G1 X178.286 Y161.706 E.2287
G3 X177.352 Y163.138 I-4.134 J-1.674 E.05532
G3 X175.898 Y164.056 I-3.261 J-3.554 E.0556
G1 X175.898 Y164.898 E.02706
G1 X175.102 Y164.898 E.02559
G1 X175.102 Y164.252 E.02077
G3 X173.906 Y164.109 I.24 J-7.057 E.03878
G3 X172.448 Y163.403 I.861 J-3.64 E.05251
G1 X172.504 Y163.237 E.00562
G1 X174.827 Y163.237 E.07468
G2 X177.47 Y160.797 I-.083 J-2.742 E.12616
; COOLING_NODE: 0
M204 S250
G1 X177.095 Y160.345 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X185.79 Y160.345 E.25898
G1 X185.79 Y162.073 E.05148
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X185.79 Y162.098 E.00073
G1 X178.53 Y162.098 E.21626
G3 X176.331 Y164.285 I-3.877 J-1.699 E.09456
G1 X176.29 Y164.304 E.00135
G1 X176.29 Y165.29 E.02937
G1 X174.71 Y165.29 E.04706
G1 X174.71 Y164.609 E.02027
G1 X174.669 Y164.606 E.00123
G3 X171.39 Y162.845 I.117 J-4.153 E.11495
G1 X171.42 Y162.845 E.00091
G1 X174.811 Y162.845 E.10101
G2 X177.098 Y160.405 I-.071 J-2.358 E.11072
; WIPE_START
G1 F9547.055
M204 S8000
G1 X179.098 Y160.391 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X177.881 Y161.369 Z18.2 F60000
G1 Z17.8
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.677197
G1 F1200
M204 S8000
G3 X177.927 Y161.27 I.783 J.299 E.00546
G1 X178.043 Y161.246 E.00595
; LINE_WIDTH: 0.628302
G1 X178.159 Y161.222 E.00549
; LINE_WIDTH: 0.60433
G1 X185.194 Y161.222 E.312
; WIPE_START
G1 F6412.428
G1 X183.194 Y161.222 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X177.881 Y161.369 Z18.2 F60000
G1 Z17.8
G1 E.8 F1800
; LINE_WIDTH: 0.639304
G1 F1200
M204 S8000
G3 X177.78 Y161.62 I-6.52 J-2.495 E.01276
; LINE_WIDTH: 0.605282
G1 X177.684 Y161.832 E.01035
G3 X175.728 Y163.585 I-3.014 J-1.396 E.11995
M204 S10000
G1 X174.895 Y163.734 F60000
; LINE_WIDTH: 0.590585
G1 F1200
M204 S8000
G1 X174.34 Y163.708 E.02402
; LINE_WIDTH: 0.560287
G1 X174.12 Y163.691 E.00902
; LINE_WIDTH: 0.529669
G1 X174.008 Y163.678 E.00434
; LINE_WIDTH: 0.503829
G1 X173.896 Y163.665 E.00411
; LINE_WIDTH: 0.47811
G1 X173.808 Y163.652 E.00304
; LINE_WIDTH: 0.452513
G1 X173.721 Y163.639 E.00286
; LINE_WIDTH: 0.4245
G1 X173.339 Y163.573 E.01167
; LINE_WIDTH: 0.394101
G1 X172.958 Y163.507 E.01074
; COOLING_NODE: 0
; WIPE_START
G1 F10251.143
G1 X173.339 Y163.573 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.669 Y157.355 Z18.2 F60000
G1 Z17.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X171.44 Y157.355 E.00736
G1 X171.434 Y157.009 E.01114
G1 X171.523 Y157.009 E.00286
G1 X171.554 Y156.954 E.00205
G1 X171.753 Y157.034 E.0069
G1 X171.684 Y157.297 E.00875
; COOLING_NODE: 0
M204 S10000
G1 X172.024 Y157.763 F60000
G1 F1200
M204 S8000
G1 X171.04 Y157.763 E.03163
G1 X171.034 Y157.398 E.01173
G1 X164.602 Y157.398 E.20681
G1 X164.602 Y156.602 E.02559
G1 X171.286 Y156.602 E.21492
G3 X172.44 Y155.102 I4.136 J1.988 E.0613
G1 X174.179 Y155.102 E.05593
G1 X174.203 Y155.319 E.00703
G2 X172.03 Y157.703 I.551 J2.685 E.1109
; COOLING_NODE: 0
M204 S250
G1 X172.405 Y158.155 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X170.681 Y158.155 E.05135
G1 X170.655 Y158.155 E.00076
G3 X170.649 Y157.831 I3.854 J-.236 E.00964
G1 X170.648 Y157.79 E.00122
G1 X164.21 Y157.79 E.19178
G1 X164.21 Y156.21 E.04706
G1 X171.057 Y156.21 E.20394
G1 X171.08 Y156.169 E.0014
G3 X172.309 Y154.71 I3.798 J1.952 E.0573
M73 P60 R11
G1 X172.351 Y154.71 E.00126
G1 X185.79 Y154.71 E.40029
G1 X185.79 Y155.655 E.02814
G1 X174.689 Y155.655 E.33065
G2 X172.402 Y158.095 I.071 J2.359 E.11072
; WIPE_START
G1 F9547.055
M204 S8000
G1 X170.681 Y158.155 E-.65446
G1 X170.655 Y158.155 E-.00964
G1 X170.65 Y157.902 E-.0959
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.738 Y156.808 Z18.2 F60000
G1 Z17.8
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.597867
G1 F1200
M204 S8000
G3 X172.497 Y155.698 I3.332 J1.465 E.05929
G1 X172.617 Y155.586 E.0072
G3 X173.367 Y155.306 I10.732 J27.532 E.03508
M204 S10000
G1 X173.431 Y155.306 F60000
; LINE_WIDTH: 0.459411
G1 F1200
M204 S8000
G1 X172.048 Y155.774 E.04802
; WIPE_START
G1 F8643.657
G1 X173.431 Y155.306 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.23 Y157 Z18.2 F60000
G1 Z17.8
G1 E.8 F1800
; LINE_WIDTH: 0.43172
G1 F1200
M204 S8000
G1 X164.806 Y157 E.19731
; WIPE_START
G1 F9259.259
G1 X166.806 Y157 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X174.29 Y155.503 Z18.2 F60000
G1 X174.418 Y155.477 Z18.2
G1 Z17.8
G1 E.8 F1800
; LINE_WIDTH: 0.595539
G1 F1200
M204 S8000
G1 X174.664 Y155.183 E.01674
G1 X185.594 Y155.182 E.47714
; CHANGE_LAYER
; Z_HEIGHT: 18
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F6514.435
G1 X183.594 Y155.182 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 90/165
; update layer progress
M73 L90
M991 S0 P89 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z18.2 I-.834 J-.886 P1  F60000
G1 X177.579 Y160.847 Z18.2
G1 Z18
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X185.398 Y160.847 E.25143
G1 X185.398 Y161.761 E.0294
G1 X178.324 Y161.761 E.22747
G3 X176.839 Y163.628 I-3.96 J-1.626 E.07774
G3 X175.898 Y164.112 I-3.322 J-5.296 E.03408
G1 X175.898 Y164.898 E.02526
G1 X175.102 Y164.898 E.02559
G1 X175.102 Y164.297 E.01934
G3 X173.396 Y164.009 I.061 J-5.565 E.05585
G3 X172.503 Y163.515 I1.345 J-3.483 E.03294
G1 X172.558 Y163.347 E.00568
G1 X174.822 Y163.347 E.07278
G2 X177.571 Y160.906 I-.082 J-2.861 E.12838
; COOLING_NODE: 0
M204 S250
G1 X177.205 Y160.455 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X185.79 Y160.455 E.25572
G1 X185.79 Y162.139 E.05016
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X185.79 Y162.153 E.00043
G1 X178.566 Y162.153 E.21516
G1 X178.43 Y162.426 E.00909
G3 X178.211 Y162.797 I-3.688 J-1.93 E.01283
G3 X178.045 Y163.028 I-3.426 J-2.272 E.00848
G3 X177.666 Y163.458 I-3.499 J-2.708 E.01708
G1 X177.563 Y163.555 E.00422
G3 X176.331 Y164.344 I-2.929 J-3.22 E.04379
G1 X176.29 Y164.363 E.00135
G1 X176.29 Y165.29 E.02761
G1 X174.71 Y165.29 E.04706
G1 X174.71 Y164.661 E.01874
G1 X174.669 Y164.658 E.00122
G1 X174.375 Y164.636 E.00878
G1 X174.232 Y164.621 E.00429
G3 X173.664 Y164.509 I.655 J-4.817 E.01725
G1 X173.525 Y164.469 E.00431
G1 X173.388 Y164.424 E.00431
G1 X173.253 Y164.374 E.00427
G3 X172.076 Y163.678 I1.595 J-4.041 E.04091
G3 X171.81 Y163.434 I2.72 J-3.227 E.01075
G3 X171.4 Y162.955 I3.394 J-3.321 E.0188
G1 X171.418 Y162.955 E.00054
G1 X174.811 Y162.955 E.10105
G2 X177.205 Y160.515 I-.081 J-2.474 E.1124
; WIPE_START
G1 F9547.055
M204 S8000
G1 X179.205 Y160.501 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X177.942 Y161.447 Z18.4 F60000
G1 Z18
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.580892
G1 F1200
M204 S8000
G3 X177.834 Y161.705 I-6.086 J-2.399 E.01189
; LINE_WIDTH: 0.55227
G3 X175.713 Y163.677 I-3.173 J-1.287 E.12027
; LINE_WIDTH: 0.593868
G1 X175.576 Y163.726 E.00635
; LINE_WIDTH: 0.628058
G1 X175.473 Y163.776 E.0053
; LINE_WIDTH: 0.668907
G1 X175.423 Y163.806 E.00287
; LINE_WIDTH: 0.668392
G1 X175.434 Y163.841 E.00183
; LINE_WIDTH: 0.624773
G1 X175.446 Y163.876 E.0017
; LINE_WIDTH: 0.581154
G1 X175.457 Y163.912 E.00158
; LINE_WIDTH: 0.537535
G1 X175.468 Y163.947 E.00145
; LINE_WIDTH: 0.493916
G1 X175.48 Y163.982 E.00132
; LINE_WIDTH: 0.435318
G1 X175.5 Y164.107 E.00393
G1 X175.5 Y164.694 E.01819
M204 S10000
G1 X175.423 Y163.806 F60000
; LINE_WIDTH: 0.671566
G1 F1200
M204 S8000
G1 X175.328 Y163.803 E.00472
; LINE_WIDTH: 0.633961
G1 X175.171 Y163.811 E.00732
; LINE_WIDTH: 0.600314
G1 X174.996 Y163.813 E.00774
; LINE_WIDTH: 0.557727
G1 X174.451 Y163.797 E.02215
; LINE_WIDTH: 0.518447
G3 X174.162 Y163.778 I.303 J-6.641 E.01088
; LINE_WIDTH: 0.479437
G1 X173.986 Y163.76 E.00612
; LINE_WIDTH: 0.446014
G1 X173.87 Y163.744 E.00372
; LINE_WIDTH: 0.415202
G1 X173.754 Y163.729 E.00343
; LINE_WIDTH: 0.380106
G1 X173.384 Y163.667 E.00999
; LINE_WIDTH: 0.340704
G1 X173.014 Y163.604 E.00883
; WIPE_START
G1 F12089.307
G1 X173.384 Y163.667 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X177.942 Y161.447 Z18.4 F60000
G1 Z18
G1 E.8 F1800
; LINE_WIDTH: 0.616235
G1 F1200
M204 S8000
G1 X177.987 Y161.348 E.00496
G1 X178.093 Y161.326 E.00488
; LINE_WIDTH: 0.571556
G1 X178.198 Y161.304 E.0045
; LINE_WIDTH: 0.549833
G1 X185.194 Y161.304 E.28014
; COOLING_NODE: 0
; WIPE_START
G1 F7101.811
G1 X183.194 Y161.304 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.933 Y158.952 Z18.4 F60000
G1 X171.925 Y157.653 Z18.4
G1 Z18
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X170.979 Y157.653 E.03042
G1 X170.971 Y157.398 E.00821
G1 X164.602 Y157.398 E.2048
G1 X164.602 Y156.602 E.02559
G1 X171.227 Y156.602 E.21305
G3 X172.352 Y155.102 I4.246 J2.012 E.06069
G1 X173.798 Y155.102 E.0465
G1 X173.836 Y155.3 E.00649
G2 X171.933 Y157.594 I.955 J2.729 E.10067
; COOLING_NODE: 0
M204 S250
G1 X172.295 Y158.045 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X170.612 Y158.045 E.05014
G1 X170.598 Y158.045 E.00041
G1 X170.592 Y157.831 E.00639
G1 X170.59 Y157.79 E.00122
G1 X164.21 Y157.79 E.19005
G1 X164.21 Y156.21 E.04706
G1 X170.996 Y156.21 E.20213
G1 X171.018 Y156.169 E.00139
G3 X172.217 Y154.71 I3.948 J2.022 E.05668
G1 X172.241 Y154.71 E.00071
G1 X185.79 Y154.71 E.40358
G1 X185.79 Y155.545 E.02487
G1 X174.688 Y155.545 E.3307
G2 X172.295 Y157.985 I.066 J2.458 E.11256
; WIPE_START
G1 F9547.055
M204 S8000
G1 X170.612 Y158.045 E-.63993
G1 X170.598 Y158.045 E-.00522
G1 X170.592 Y157.831 E-.08147
G1 X170.59 Y157.79 E-.01559
G1 X170.544 Y157.79 E-.01778
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.393 Y157.23 Z18.4 F60000
G1 Z18
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.67857
G1 F1200
M204 S8000
G1 X171.489 Y157.121 E.00731
; LINE_WIDTH: 0.692779
G3 X171.519 Y157.065 I.054 J-.007 E.00347
; LINE_WIDTH: 0.653322
G1 X171.548 Y157.023 E.00246
; LINE_WIDTH: 0.62895
G1 X171.562 Y157.001 E.00121
; LINE_WIDTH: 0.594972
G2 X171.672 Y156.766 I-1.921 J-1.045 E.01132
; LINE_WIDTH: 0.551099
G3 X172.361 Y155.718 I3.343 J1.447 E.05061
G1 X172.811 Y155.306 E.02449
; WIPE_START
G1 F7084.126
G1 X172.361 Y155.718 E-.24799
G1 X172.184 Y155.919 E-.10909
G1 X171.988 Y156.187 E-.13472
G1 X171.672 Y156.766 E-.26819
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X174.011 Y155.168 Z18.4 F60000
G1 Z18
G1 E.8 F1800
; LINE_WIDTH: 0.487214
G1 F1200
M204 S8000
G3 X174.447 Y155.135 I1.013 J10.556 E.01537
G1 X185.594 Y155.128 E.39121
; WIPE_START
G1 F8102.752
G1 X183.594 Y155.129 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X176.092 Y156.534 Z18.4 F60000
G1 X171.201 Y157.45 Z18.4
G1 Z18
G1 E.8 F1800
; LINE_WIDTH: 0.590843
G1 F1200
M204 S8000
G1 X171.297 Y157.34 E.0063
; LINE_WIDTH: 0.634707
G1 X171.393 Y157.23 E.00681
M204 S10000
G1 X171.489 Y157.106 F60000
; LINE_WIDTH: 0.683503
G1 F1200
M204 S8000
G1 X171.454 Y157.09 E.00197
; LINE_WIDTH: 0.635114
G1 X171.418 Y157.074 E.00182
; LINE_WIDTH: 0.586724
G1 X171.383 Y157.057 E.00167
; LINE_WIDTH: 0.538335
G1 X171.348 Y157.041 E.00152
; LINE_WIDTH: 0.493546
G1 X171.258 Y157.021 E.00327
; LINE_WIDTH: 0.432014
G1 X171.169 Y157 E.00282
G1 X164.806 Y157 E.19557
; CHANGE_LAYER
; Z_HEIGHT: 18.2
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F9252.281
G1 X166.806 Y157 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 91/165
; update layer progress
M73 L91
M991 S0 P90 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z18.4 I-.415 J1.144 P1  F60000
G1 X177.657 Y160.934 Z18.4
G1 Z18.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X185.398 Y160.934 E.24892
G1 X185.398 Y161.807 E.02805
G1 X178.35 Y161.806 E.22662
G3 X176.696 Y163.772 I-3.892 J-1.596 E.08396
G3 X175.898 Y164.161 I-3.458 J-6.08 E.02857
G1 X175.898 Y164.898 E.02371
G1 X175.102 Y164.898 E.02559
G1 X175.102 Y164.353 E.01754
G3 X174.08 Y164.247 I.368 J-8.576 E.03306
G3 X172.55 Y163.61 I.709 J-3.857 E.0537
G1 X172.601 Y163.434 E.00589
G1 X174.823 Y163.434 E.07145
M73 P60 R10
G2 X177.647 Y160.993 I-.109 J-2.979 E.12968
; COOLING_NODE: 0
M204 S250
G1 X177.292 Y160.542 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X185.79 Y160.542 E.25312
G1 X185.79 Y162.194 E.04921
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X185.79 Y162.199 E.00013
G1 X178.594 Y162.198 E.21436
G3 X178.167 Y162.94 I-5.608 J-2.73 E.0255
G1 X178.036 Y163.114 E.00649
G3 X176.331 Y164.393 I-3.331 J-2.663 E.06419
G1 X176.29 Y164.412 E.00134
G1 X176.29 Y165.29 E.02615
G1 X174.71 Y165.29 E.04706
G1 X174.71 Y164.71 E.01727
G1 X174.669 Y164.707 E.00123
G1 X174.225 Y164.666 E.01328
G3 X173.76 Y164.58 I.519 J-4.122 E.01408
G1 X173.511 Y164.512 E.00769
G3 X172.773 Y164.204 I1.372 J-4.332 E.02386
G3 X172.396 Y163.977 I1.987 J-3.72 E.01311
G3 X171.41 Y163.042 I2.406 J-3.527 E.04064
G1 X171.415 Y163.042 E.00015
G1 X174.812 Y163.042 E.10121
G2 X177.291 Y160.602 I-.068 J-2.547 E.11402
; WIPE_START
G1 F9547.055
M204 S8000
G1 X179.29 Y160.588 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
M73 P61 R10
G1 X178.129 Y161.39 Z18.6 F60000
G1 Z18.2
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.52678
G1 F1200
M204 S8000
G1 X178.224 Y161.37 E.0037
; LINE_WIDTH: 0.507773
G1 X185.194 Y161.371 E.25594
; WIPE_START
G1 F7744.386
G1 X183.194 Y161.37 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X178.129 Y161.39 Z18.6 F60000
G1 Z18.2
G1 E.8 F1800
; LINE_WIDTH: 0.560597
G1 F1200
M204 S8000
G2 X177.995 Y161.489 I-.029 J.101 E.00787
G1 X177.962 Y161.573 E.00371
; LINE_WIDTH: 0.511222
G1 X177.737 Y162.061 E.01989
G3 X175.74 Y163.737 I-3.065 J-1.624 E.09886
; LINE_WIDTH: 0.551099
G1 X175.585 Y163.793 E.0066
; LINE_WIDTH: 0.586173
G1 X175.486 Y163.84 E.00474
; LINE_WIDTH: 0.615599
G1 X175.463 Y163.854 E.0012
; LINE_WIDTH: 0.643329
G1 X175.423 Y163.88 E.00226
; LINE_WIDTH: 0.643783
G1 X175.332 Y163.877 E.00433
; LINE_WIDTH: 0.605079
G1 X175.178 Y163.883 E.00685
; LINE_WIDTH: 0.568665
G1 X175.001 Y163.883 E.00736
; LINE_WIDTH: 0.53935
G1 X174.829 Y163.88 E.00674
; LINE_WIDTH: 0.503964
G1 X174.324 Y163.857 E.01842
; LINE_WIDTH: 0.467945
G1 X174.153 Y163.844 E.00573
; LINE_WIDTH: 0.433189
G1 X173.944 Y163.822 E.00649
; LINE_WIDTH: 0.396794
G1 X173.836 Y163.808 E.00304
; LINE_WIDTH: 0.367758
G1 X173.729 Y163.793 E.00279
; LINE_WIDTH: 0.333583
G1 X173.392 Y163.736 E.00785
; LINE_WIDTH: 0.294248
G1 X173.055 Y163.679 E.00678
; WIPE_START
G1 F14323.93
G1 X173.392 Y163.736 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.423 Y163.88 Z18.6 F60000
G1 Z18.2
G1 E.8 F1800
; LINE_WIDTH: 0.639604
G1 F1200
M204 S8000
G1 X175.436 Y163.918 E.00187
; LINE_WIDTH: 0.593942
G1 X175.45 Y163.955 E.00173
; LINE_WIDTH: 0.548279
G1 X175.463 Y163.993 E.00159
; LINE_WIDTH: 0.502617
G1 X175.476 Y164.03 E.00144
; LINE_WIDTH: 0.436741
G1 X175.5 Y164.167 E.00432
G1 X175.5 Y164.694 E.01641
; COOLING_NODE: 0
; WIPE_START
G1 F9141.223
G1 X175.5 Y164.167 E-.60169
G1 X175.476 Y164.03 E-.15831
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.849 Y157.566 Z18.6 F60000
G1 Z18.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X170.935 Y157.566 E.02941
G1 X170.932 Y157.398 E.0054
G1 X164.602 Y157.398 E.20354
G1 X164.602 Y156.602 E.02559
G1 X171.178 Y156.602 E.21145
G3 X172.281 Y155.102 I4.319 J2.02 E.06026
G1 X173.572 Y155.102 E.04153
G1 X173.615 Y155.292 E.00627
G2 X171.859 Y157.506 I1.16 J2.724 E.09474
; COOLING_NODE: 0
M204 S250
G1 X172.208 Y157.958 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X170.554 Y157.958 E.04924
G1 X170.548 Y157.831 E.00378
G1 X170.547 Y157.79 E.00122
G1 X164.21 Y157.79 E.18876
G1 X164.21 Y156.21 E.04706
G1 X170.945 Y156.21 E.20062
G1 X170.968 Y156.169 E.00139
G3 X172.008 Y154.82 I3.899 J1.931 E.05109
G1 X172.151 Y154.71 E.00536
G1 X185.79 Y154.71 E.40626
G1 X185.79 Y155.458 E.02227
G1 X174.686 Y155.458 E.33075
G2 X172.21 Y157.898 I.071 J2.549 E.11395
M204 S10000
G1 X171.672 Y157.362 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.543566
G1 F1200
M204 S8000
G1 X171.472 Y157.102 E.01297
; LINE_WIDTH: 0.612046
G1 X171.445 Y157.065 E.0021
G1 X171.483 Y157.002 E.0033
; LINE_WIDTH: 0.581848
G1 X171.521 Y156.939 E.00313
; LINE_WIDTH: 0.542936
G1 X171.637 Y156.687 E.01095
; LINE_WIDTH: 0.508819
G3 X172.699 Y155.306 I3.46 J1.561 E.06472
; WIPE_START
G1 F7727.011
G1 X172.355 Y155.629 E-.2044
G1 X172.064 Y155.965 E-.19213
G1 X171.843 Y156.295 E-.17175
G1 X171.637 Y156.687 E-.19172
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X173.787 Y155.161 Z18.6 F60000
G1 Z18.2
G1 E.8 F1800
; LINE_WIDTH: 0.481143
G1 F1200
M204 S8000
G1 X174.113 Y155.119 E.01139
; LINE_WIDTH: 0.452497
G1 X174.273 Y155.103 E.00521
; LINE_WIDTH: 0.399092
G1 X174.679 Y155.084 E.01143
G1 X185.594 Y155.084 E.30709
; WIPE_START
G1 F10107.479
G1 X183.594 Y155.084 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X176.061 Y156.314 Z18.6 F60000
G1 X171.392 Y157.076 Z18.6
G1 Z18.2
G1 E.8 F1800
; LINE_WIDTH: 0.596627
G1 F1200
M204 S8000
G1 X171.361 Y157.063 E.00149
; LINE_WIDTH: 0.559312
G1 X171.329 Y157.049 E.00139
; LINE_WIDTH: 0.521998
G1 X171.298 Y157.036 E.00129
; LINE_WIDTH: 0.485445
G1 X171.215 Y157.018 E.00298
; LINE_WIDTH: 0.431959
G1 X171.131 Y157 E.00262
G1 X164.806 Y157 E.1944
; CHANGE_LAYER
; Z_HEIGHT: 18.4
; LAYER_HEIGHT: 0.199999
; WIPE_START
G1 F9253.585
G1 X166.806 Y157 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 92/165
; update layer progress
M73 L92
M991 S0 P91 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z18.6 I-.419 J1.143 P1  F60000
G1 X177.714 Y161.002 Z18.6
G1 Z18.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X185.398 Y161.002 E.24708
G1 X185.398 Y161.843 E.02705
G1 X178.378 Y161.842 E.22574
G3 X176.885 Y163.696 I-3.965 J-1.666 E.07756
G3 X175.898 Y164.199 I-3.526 J-5.692 E.03566
G1 X175.898 Y164.898 E.02248
G1 X175.102 Y164.898 E.02559
G1 X175.102 Y164.378 E.01671
G3 X173.367 Y164.085 I.062 J-5.65 E.05682
G3 X172.587 Y163.68 I1.997 J-4.79 E.0283
G1 X172.637 Y163.502 E.00594
G1 X174.823 Y163.502 E.07027
G2 X177.703 Y161.061 I-.102 J-3.041 E.13098
; COOLING_NODE: 0
M204 S250
G1 X177.357 Y160.61 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X185.79 Y160.61 E.2512
G1 X185.79 Y162.235 E.04841
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X178.618 Y162.234 E.21363
G3 X176.29 Y164.451 I-3.952 J-1.819 E.09808
G1 X176.29 Y165.29 E.02499
G1 X174.71 Y165.29 E.04706
G1 X174.71 Y164.743 E.0163
G3 X171.416 Y163.11 I.07 J-4.279 E.11319
G1 X174.812 Y163.11 E.10115
G2 X177.353 Y160.67 I-.083 J-2.63 E.11498
; WIPE_START
G1 F9547.055
M204 S8000
G1 X179.353 Y160.656 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X178.163 Y161.441 Z18.8 F60000
G1 Z18.4
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.494591
G1 F1200
M204 S8000
G1 X178.253 Y161.422 E.00329
; LINE_WIDTH: 0.47631
G1 X185.194 Y161.422 E.23762
; WIPE_START
G1 F8306.606
G1 X183.194 Y161.422 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X178.163 Y161.441 Z18.8 F60000
G1 Z18.4
G1 E.8 F1800
; LINE_WIDTH: 0.526154
G1 F1200
M204 S8000
G2 X178.038 Y161.529 I-.028 J.093 E.00669
G1 X177.988 Y161.651 E.00505
; LINE_WIDTH: 0.479427
G3 X175.756 Y163.786 I-3.333 J-1.25 E.11016
; LINE_WIDTH: 0.519353
G1 X175.592 Y163.845 E.00655
; LINE_WIDTH: 0.554389
G1 X175.496 Y163.891 E.0043
; LINE_WIDTH: 0.582713
G1 X175.475 Y163.904 E.00106
; LINE_WIDTH: 0.609111
G1 X175.438 Y163.929 E.00202
M204 S10000
G1 X175.5 Y164.694 F60000
; LINE_WIDTH: 0.435413
G1 F1200
M204 S8000
G1 X175.5 Y164.189 E.01566
G1 X175.481 Y164.068 E.0038
; LINE_WIDTH: 0.489188
G1 X175.47 Y164.033 E.00129
; LINE_WIDTH: 0.528663
G1 X175.459 Y163.998 E.0014
; LINE_WIDTH: 0.568138
G1 X175.449 Y163.963 E.00152
; LINE_WIDTH: 0.607613
G1 X175.438 Y163.929 E.00163
; LINE_WIDTH: 0.602445
G1 X175.325 Y163.923 E.00498
; LINE_WIDTH: 0.560811
G1 X175.187 Y163.929 E.00566
; LINE_WIDTH: 0.528818
G1 X175.005 Y163.931 E.00699
; LINE_WIDTH: 0.502002
G1 X174.828 Y163.93 E.0064
; LINE_WIDTH: 0.472487
G3 X174.331 Y163.91 I.334 J-14.471 E.01689
; LINE_WIDTH: 0.436732
G1 X174.142 Y163.895 E.00591
; LINE_WIDTH: 0.402957
G1 X173.951 Y163.876 E.00544
; LINE_WIDTH: 0.369711
G1 X173.841 Y163.862 E.00287
; LINE_WIDTH: 0.337427
G1 X173.718 Y163.844 E.00289
; LINE_WIDTH: 0.300381
G1 X173.595 Y163.825 E.00253
; LINE_WIDTH: 0.260961
G1 X173.11 Y163.739 E.00848
; COOLING_NODE: 0
; WIPE_START
G1 F15000
G1 X173.595 Y163.825 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.792 Y157.498 Z18.8 F60000
G1 Z18.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X170.901 Y157.498 E.02865
G1 X170.9 Y157.398 E.00322
G1 X164.602 Y157.398 E.20252
G1 X164.602 Y156.602 E.02559
G1 X171.138 Y156.602 E.21017
G3 X172.228 Y155.102 I4.342 J2.01 E.06001
G1 X173.414 Y155.102 E.03814
G1 X173.459 Y155.29 E.00622
G2 X171.803 Y157.439 I1.29 J2.707 E.09052
; COOLING_NODE: 0
M204 S250
G1 X172.142 Y157.89 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X170.514 Y157.89 E.04852
G1 X170.512 Y157.79 E.00298
G1 X164.21 Y157.79 E.18773
G1 X164.21 Y156.21 E.04706
G1 X170.905 Y156.21 E.19942
G3 X172.086 Y154.71 I4.084 J2.001 E.05729
G1 X185.79 Y154.71 E.4082
G1 X185.79 Y155.39 E.02026
G1 X174.686 Y155.39 E.33074
G2 X172.146 Y157.83 I.071 J2.617 E.11509
M204 S10000
G1 X171.618 Y157.294 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.560854
G1 F1200
M204 S8000
G1 X171.415 Y157.025 E.01382
G1 X171.473 Y156.922 E.00485
; LINE_WIDTH: 0.526016
G1 X171.497 Y156.868 E.00226
; LINE_WIDTH: 0.480615
G3 X172.368 Y155.543 I3.595 J1.415 E.05521
G1 X172.624 Y155.306 E.01207
M204 S10000
G1 X172.948 Y155.311 F60000
; LINE_WIDTH: 0.356907
G1 F1200
M204 S8000
G1 X171.939 Y155.689 E.02672
; WIPE_START
G1 F11465.466
G1 X172.948 Y155.311 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.299 Y157.048 Z18.8 F60000
G1 Z18.4
G1 E.8 F1800
; LINE_WIDTH: 0.515264
G1 F1200
M204 S8000
G1 X171.259 Y157.032 E.00164
; LINE_WIDTH: 0.479492
G1 X171.18 Y157.016 E.00277
; LINE_WIDTH: 0.431921
G1 X171.101 Y157 E.00247
G1 X164.806 Y157 E.19346
; WIPE_START
G1 F9254.487
G1 X166.806 Y157 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X173.629 Y155.157 Z18.8 F60000
G1 Z18.4
G1 E.8 F1800
; LINE_WIDTH: 0.462165
G1 F1200
M204 S8000
G1 X173.987 Y155.101 E.01201
; LINE_WIDTH: 0.416437
G1 X174.107 Y155.085 E.00356
; LINE_WIDTH: 0.385302
G1 X174.269 Y155.07 E.00441
; LINE_WIDTH: 0.331502
G1 X174.68 Y155.05 E.00936
G1 X185.594 Y155.05 E.2488
; CHANGE_LAYER
; Z_HEIGHT: 18.6
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F12474.824
G1 X183.594 Y155.05 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 93/165
; update layer progress
M73 L93
M991 S0 P92 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z18.8 I-.872 J-.849 P1  F60000
G1 X177.755 Y161.052 Z18.8
G1 Z18.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X185.398 Y161.051 E.24577
G1 X185.398 Y161.87 E.02632
G1 X178.396 Y161.869 E.22515
G3 X176.742 Y163.817 I-3.954 J-1.68 E.08345
G3 X175.898 Y164.228 I-3.375 J-5.867 E.03021
G1 X175.898 Y164.898 E.02154
M73 P62 R10
G1 X175.102 Y164.898 E.02559
G1 X175.102 Y164.406 E.01582
G3 X173.417 Y164.133 I.08 J-5.824 E.0551
G3 X172.617 Y163.729 I1.359 J-3.683 E.02886
G1 X172.668 Y163.551 E.00593
G1 X174.824 Y163.551 E.06934
G2 X177.743 Y161.11 I-.1 J-3.085 E.13184
; COOLING_NODE: 0
M204 S250
G1 X177.405 Y160.659 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X185.79 Y160.659 E.24978
G1 X185.79 Y162.262 E.04774
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X178.635 Y162.261 E.21311
G3 X176.29 Y164.48 I-3.972 J-1.849 E.0985
G1 X176.29 Y165.29 E.02412
G1 X174.71 Y165.29 E.04706
G1 X174.71 Y164.77 E.01549
G3 X171.421 Y163.159 I.083 J-4.333 E.11261
G1 X174.814 Y163.159 E.10104
G2 X177.4 Y160.719 I-.086 J-2.682 E.11577
M204 S10000
G1 X177.921 Y161.255 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.468002
G1 F1200
M204 S8000
G1 X178.089 Y161.479 E.00939
; LINE_WIDTH: 0.507059
G1 X178.101 Y161.496 E.00078
G1 X178.187 Y161.478 E.00321
; LINE_WIDTH: 0.471261
G1 X178.272 Y161.46 E.00296
; LINE_WIDTH: 0.453802
G1 X185.194 Y161.461 E.22467
; WIPE_START
G1 F8761.651
G1 X183.194 Y161.461 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X178.101 Y161.496 Z19 F60000
G1 Z18.6
G1 E.8 F1800
; LINE_WIDTH: 0.495506
G1 F1200
M204 S8000
G2 X177.996 Y161.731 I3.546 J1.731 E.0092
; LINE_WIDTH: 0.456623
G1 X177.881 Y161.975 E.00881
G3 X175.768 Y163.822 I-3.205 J-1.533 E.09431
; LINE_WIDTH: 0.497193
G1 X175.597 Y163.883 E.00652
; LINE_WIDTH: 0.532206
G1 X175.504 Y163.928 E.00397
; LINE_WIDTH: 0.559577
G1 X175.484 Y163.94 E.00097
; LINE_WIDTH: 0.588363
G1 X175.442 Y163.969 E.0022
; LINE_WIDTH: 0.595805
G1 X175.383 Y163.965 E.00257
; LINE_WIDTH: 0.568777
G1 X175.325 Y163.962 E.00244
; LINE_WIDTH: 0.539165
G1 X175.192 Y163.968 E.00519
; LINE_WIDTH: 0.507512
G1 X175.008 Y163.97 E.00677
; LINE_WIDTH: 0.480232
G1 X174.83 Y163.968 E.00615
; LINE_WIDTH: 0.449756
G3 X174.32 Y163.947 I.363 J-15.115 E.01639
; LINE_WIDTH: 0.413266
G1 X174.134 Y163.933 E.00546
; LINE_WIDTH: 0.380886
G1 X173.955 Y163.915 E.00481
; LINE_WIDTH: 0.347586
G1 X173.841 Y163.9 E.00277
; LINE_WIDTH: 0.31752
G1 X173.727 Y163.885 E.0025
; LINE_WIDTH: 0.285663
G1 X173.623 Y163.868 E.00201
; LINE_WIDTH: 0.252015
G1 X173.52 Y163.851 E.00173
; LINE_WIDTH: 0.217094
G1 X173.335 Y163.816 E.00258
; LINE_WIDTH: 0.180909
G1 X173.151 Y163.781 E.00205
; WIPE_START
G1 F15000
G1 X173.335 Y163.816 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.442 Y163.969 Z19 F60000
G1 Z18.6
G1 E.8 F1800
; LINE_WIDTH: 0.585885
G1 F1200
M204 S8000
G1 X175.455 Y164.012 E.00192
; LINE_WIDTH: 0.539017
G1 X175.468 Y164.054 E.00175
; LINE_WIDTH: 0.492149
G1 X175.482 Y164.097 E.00159
; LINE_WIDTH: 0.435478
G1 X175.5 Y164.217 E.00376
G1 X175.5 Y164.694 E.0148
; COOLING_NODE: 0
; WIPE_START
G1 F9170.637
G1 X175.5 Y164.217 E-.60598
G1 X175.482 Y164.097 E-.15402
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.745 Y157.449 Z19 F60000
G1 Z18.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X170.876 Y157.449 E.02794
G1 X170.875 Y157.398 E.00163
G1 X164.602 Y157.398 E.20173
G1 X164.602 Y156.602 E.02559
G1 X171.108 Y156.602 E.20922
G3 X172.185 Y155.102 I4.426 J2.04 E.05973
G1 X173.307 Y155.102 E.03609
G1 X173.355 Y155.284 E.00605
G2 X171.757 Y157.39 I1.436 J2.75 E.08782
; COOLING_NODE: 0
M204 S250
G1 X172.096 Y157.841 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X170.487 Y157.841 E.04793
G1 X170.486 Y157.79 E.00151
G1 X164.21 Y157.79 E.18695
G1 X164.21 Y156.21 E.04706
G1 X170.875 Y156.21 E.19853
G3 X172.043 Y154.71 I4.132 J2.013 E.05704
G1 X185.79 Y154.71 E.40947
G1 X185.79 Y155.341 E.01878
G1 X174.685 Y155.341 E.33079
G2 X172.101 Y157.781 I.092 J2.686 E.11567
; WIPE_START
G1 F9547.055
M204 S8000
G1 X170.487 Y157.841 E-.61374
G1 X170.486 Y157.79 E-.01928
G1 X170.152 Y157.79 E-.12698
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.405 Y156.974 Z19 F60000
G1 Z18.6
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.506249
G1 F1200
M204 S8000
G2 X171.483 Y156.806 I-1.306 J-.706 E.00677
; LINE_WIDTH: 0.455552
G3 X172.339 Y155.518 I3.65 J1.497 E.05075
G1 X172.86 Y155.311 E.01826
M204 S10000
G1 X173.585 Y155.387 F60000
; LINE_WIDTH: 0.3934
G1 F1200
M204 S8000
G1 X173.709 Y155.148 E.00743
; LINE_WIDTH: 0.436373
G1 X173.727 Y155.113 E.00124
G1 X173.846 Y155.094 E.00373
; LINE_WIDTH: 0.396711
G1 X174.004 Y155.072 E.00448
; LINE_WIDTH: 0.356715
G1 X174.165 Y155.054 E.00401
; LINE_WIDTH: 0.319073
G1 X174.418 Y155.034 E.00554
; LINE_WIDTH: 0.281674
G1 X185.594 Y155.025 E.21077
; WIPE_START
G1 F15000
G1 X183.594 Y155.027 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X176.057 Y156.231 Z19 F60000
G1 X171.405 Y156.974 Z19
G1 Z18.6
G1 E.8 F1800
; LINE_WIDTH: 0.515831
G1 F1200
M204 S8000
G1 X171.393 Y156.995 E.00092
G1 X171.229 Y157.025 E.00621
; LINE_WIDTH: 0.482385
G1 X171.218 Y157.025 E.0004
M204 S10000
G1 X171.102 Y157.245 F60000
; LINE_WIDTH: 0.16914
G1 F1200
M204 S8000
G1 X171.118 Y157.214 E.00035
; LINE_WIDTH: 0.217332
G1 X171.135 Y157.182 E.00049
; LINE_WIDTH: 0.265525
G1 X171.151 Y157.151 E.00062
; LINE_WIDTH: 0.313718
G1 X171.168 Y157.119 E.00076
; LINE_WIDTH: 0.361911
G1 X171.185 Y157.088 E.00089
; LINE_WIDTH: 0.410104
G1 X171.201 Y157.057 E.00103
; LINE_WIDTH: 0.458296
G1 X171.218 Y157.025 E.00117
; LINE_WIDTH: 0.469721
G1 X171.148 Y157.013 E.0024
; LINE_WIDTH: 0.431863
G1 X171.077 Y157 E.00219
G1 X164.806 Y157 E.1927
; CHANGE_LAYER
; Z_HEIGHT: 18.8
; LAYER_HEIGHT: 0.199999
; WIPE_START
G1 F9255.868
G1 X166.806 Y157 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 94/165
; update layer progress
M73 L94
M991 S0 P93 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z19 I-.425 J1.14 P1  F60000
G1 X177.776 Y161.084 Z19
G1 Z18.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X185.398 Y161.084 E.2451
G1 X185.398 Y161.888 E.02585
G1 X178.41 Y161.887 E.22469
G3 X176.779 Y163.816 I-4.007 J-1.735 E.08242
G3 X175.898 Y164.247 I-3.315 J-5.658 E.03156
G1 X175.898 Y164.898 E.02093
G1 X175.102 Y164.898 E.02559
G1 X175.102 Y164.424 E.01524
G3 X173.41 Y164.149 I.08 J-5.846 E.05533
G3 X172.635 Y163.762 I1.441 J-3.847 E.02791
G1 X172.685 Y163.584 E.00594
G1 X174.826 Y163.584 E.06882
G2 X177.764 Y161.143 I-.08 J-3.085 E.13246
; COOLING_NODE: 0
M204 S250
G1 X177.435 Y160.692 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X185.79 Y160.692 E.24887
G1 X185.79 Y162.28 E.0473
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X178.648 Y162.279 E.21273
G3 X176.29 Y164.5 I-4.003 J-1.889 E.09877
G1 X176.29 Y165.29 E.02354
G1 X174.71 Y165.29 E.04706
G1 X174.71 Y164.788 E.01495
G3 X171.424 Y163.192 I.093 J-4.371 E.11225
G1 X174.815 Y163.192 E.10099
G2 X177.43 Y160.752 I-.07 J-2.696 E.11647
; WIPE_START
G1 F9547.055
M204 S8000
G1 X179.43 Y160.737 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X178.089 Y161.581 Z19.2 F60000
G1 Z18.8
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.454961
G1 F1200
M204 S8000
G1 X177.811 Y162.167 E.02113
; LINE_WIDTH: 0.441259
G1 X177.762 Y162.254 E.00314
G3 X175.776 Y163.846 I-3.094 J-1.824 E.08188
; LINE_WIDTH: 0.48262
G1 X175.6 Y163.909 E.00648
; LINE_WIDTH: 0.517803
G1 X175.509 Y163.953 E.0038
; LINE_WIDTH: 0.544874
G1 X175.489 Y163.965 E.00091
; LINE_WIDTH: 0.57501
G1 X175.445 Y163.995 E.00226
; LINE_WIDTH: 0.583154
G1 X175.384 Y163.991 E.00259
; LINE_WIDTH: 0.554578
G1 X175.324 Y163.987 E.00245
; LINE_WIDTH: 0.524667
G1 X175.196 Y163.993 E.00489
; LINE_WIDTH: 0.493328
G1 X175.009 Y163.995 E.00662
; LINE_WIDTH: 0.465875
G1 X174.831 Y163.993 E.00596
; LINE_WIDTH: 0.435234
G3 X174.317 Y163.972 I.367 J-15.279 E.01594
; LINE_WIDTH: 0.398268
G1 X174.127 Y163.958 E.00535
; LINE_WIDTH: 0.371123
G1 X174.008 Y163.945 E.00312
; LINE_WIDTH: 0.345613
G1 X173.888 Y163.932 E.00288
; LINE_WIDTH: 0.319866
G1 X173.793 Y163.919 E.00209
; LINE_WIDTH: 0.29387
G1 X173.699 Y163.906 E.00189
; LINE_WIDTH: 0.265303
G1 X173.604 Y163.891 E.00169
; LINE_WIDTH: 0.23416
G1 X173.509 Y163.875 E.00145
; LINE_WIDTH: 0.195912
G1 X173.18 Y163.814 E.00405
; WIPE_START
G1 F15000
G1 X173.509 Y163.875 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.445 Y163.995 Z19.2 F60000
G1 Z18.8
G1 E.8 F1800
; LINE_WIDTH: 0.575896
G1 F1200
M204 S8000
G1 X175.457 Y164.036 E.00177
; LINE_WIDTH: 0.532775
G1 X175.469 Y164.076 E.00163
; LINE_WIDTH: 0.489654
G1 X175.482 Y164.116 E.00149
; LINE_WIDTH: 0.435511
G1 X175.5 Y164.235 E.00373
G1 X175.5 Y164.694 E.01425
; WIPE_START
G1 F9169.864
G1 X175.5 Y164.235 E-.6023
G1 X175.482 Y164.116 E-.1577
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X178.089 Y161.581 Z19.2 F60000
G1 Z18.8
G1 E.8 F1800
; LINE_WIDTH: 0.49464
G1 F1200
M204 S8000
G1 X178.12 Y161.521 E.00239
G1 X178.203 Y161.503 E.00305
; LINE_WIDTH: 0.45692
G1 X178.287 Y161.486 E.0028
; LINE_WIDTH: 0.439448
G1 X185.194 Y161.486 E.21636
; COOLING_NODE: 0
; WIPE_START
G1 F9078.815
G1 X183.194 Y161.486 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X176.001 Y158.934 Z19.2 F60000
G1 X171.722 Y157.416 Z19.2
G1 Z18.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X170.856 Y157.416 E.02786
G1 X170.856 Y157.398 E.00059
G1 X164.602 Y157.398 E.2011
G1 X164.602 Y156.602 E.02559
G1 X171.096 Y156.602 E.20883
G3 X172.159 Y155.102 I4.17 J1.827 E.05952
G1 X173.244 Y155.102 E.03491
G1 X173.292 Y155.284 E.00605
G2 X171.735 Y157.357 I1.475 J2.73 E.08604
; COOLING_NODE: 0
M204 S250
G1 X172.066 Y157.808 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X170.468 Y157.808 E.0476
G1 X170.468 Y157.79 E.00055
G1 X164.21 Y157.79 E.1864
G1 X164.21 Y156.21 E.04706
G1 X170.858 Y156.21 E.19802
G3 X172.015 Y154.71 I3.979 J1.872 E.05687
G1 X185.79 Y154.71 E.41032
G1 X185.79 Y155.308 E.01782
G1 X174.684 Y155.308 E.33082
G2 X172.071 Y157.748 I.073 J2.697 E.11639
M204 S10000
G1 X171.554 Y157.213 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.425495
G1 F1200
M204 S8000
G1 X171.405 Y157.012 E.00754
; LINE_WIDTH: 0.492258
M73 P63 R10
G1 X171.38 Y156.978 E.00152
G1 X171.417 Y156.908 E.00281
; LINE_WIDTH: 0.4444
G3 X172.521 Y155.306 I3.751 J1.403 E.06234
M204 S10000
G1 X171.919 Y155.643 F60000
; LINE_WIDTH: 0.243719
G1 F1200
M204 S8000
G1 X172.808 Y155.319 E.015
M204 S10000
G1 X172.805 Y155.309 F60000
; LINE_WIDTH: 0.384905
G1 F1200
M204 S8000
G1 X171.895 Y155.672 E.02646
; WIPE_START
G1 F10526.781
G1 X172.805 Y155.309 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.142 Y157.009 Z19.2 F60000
G1 Z18.8
G1 E.8 F1800
; LINE_WIDTH: 0.431843
G1 F1200
M204 S8000
G1 X164.806 Y157 E.19466
; WIPE_START
G1 F9256.34
G1 X166.806 Y157.003 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X173.521 Y155.382 Z19.2 F60000
G1 Z18.8
G1 E.8 F1800
; LINE_WIDTH: 0.379069
G1 F1200
M204 S8000
G1 X173.648 Y155.13 E.00749
; LINE_WIDTH: 0.432696
G1 X173.659 Y155.109 E.00072
; LINE_WIDTH: 0.432996
G1 X173.745 Y155.093 E.00271
; LINE_WIDTH: 0.393877
G1 X173.898 Y155.07 E.00429
; LINE_WIDTH: 0.35352
G1 X174.033 Y155.053 E.00333
; LINE_WIDTH: 0.322501
G1 X174.156 Y155.038 E.00274
; LINE_WIDTH: 0.28723
G1 X174.417 Y155.018 E.00505
; LINE_WIDTH: 0.249216
G1 X185.594 Y155.009 E.18214
; CHANGE_LAYER
; Z_HEIGHT: 19
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F15000
G1 X183.594 Y155.011 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 95/165
; update layer progress
M73 L95
M991 S0 P94 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z19.2 I-.881 J-.839 P1  F60000
G1 X177.795 Y161.1 Z19.2
G1 Z19
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X185.398 Y161.1 E.24447
G1 X185.398 Y161.897 E.02562
G1 X178.416 Y161.897 E.22452
G3 X176.863 Y163.774 I-4.026 J-1.749 E.07937
G3 X175.898 Y164.252 I-3.527 J-5.901 E.03469
G1 X175.898 Y164.898 E.02076
G1 X175.102 Y164.898 E.02559
G1 X175.102 Y164.437 E.01483
G3 X173.669 Y164.243 I.135 J-6.407 E.0466
G3 X172.644 Y163.778 I1.163 J-3.919 E.03631
G1 X172.694 Y163.6 E.00594
G1 X174.823 Y163.6 E.06846
G2 X177.783 Y161.159 I-.1 J-3.135 E.13275
; COOLING_NODE: 0
M204 S250
G1 X177.45 Y160.708 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X185.79 Y160.708 E.24842
G1 X185.79 Y162.289 E.04709
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X178.653 Y162.289 E.21257
G3 X176.29 Y164.508 I-4.002 J-1.895 E.09886
G1 X176.29 Y165.29 E.0233
G1 X174.71 Y165.29 E.04706
G1 X174.71 Y164.798 E.01465
G3 X171.426 Y163.208 I.077 J-4.345 E.11217
G1 X174.813 Y163.208 E.10088
G2 X177.444 Y160.768 I-.081 J-2.727 E.11667
M204 S10000
G1 X177.953 Y161.304 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.497165
G1 F1200
M204 S8000
G1 X178.129 Y161.533 E.01036
G1 X178.211 Y161.516 E.003
; LINE_WIDTH: 0.449661
G1 X178.293 Y161.498 E.00269
; LINE_WIDTH: 0.432512
G1 X185.194 Y161.498 E.2124
; WIPE_START
G1 F9240.456
G1 X183.194 Y161.498 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X178.129 Y161.533 Z19.4 F60000
G1 Z19
G1 E.8 F1800
; LINE_WIDTH: 0.4721
G1 F1200
M204 S8000
G1 X178.12 Y161.548 E.0006
G2 X178.018 Y161.778 I7.128 J3.319 E.00853
; LINE_WIDTH: 0.434531
G1 X177.89 Y162.044 E.00912
G3 X175.779 Y163.856 I-3.219 J-1.613 E.08837
; LINE_WIDTH: 0.470854
G1 X175.605 Y163.917 E.00624
; LINE_WIDTH: 0.505663
G1 X175.511 Y163.963 E.00381
; LINE_WIDTH: 0.533403
G1 X175.492 Y163.975 E.00087
; LINE_WIDTH: 0.554206
G1 X175.467 Y163.992 E.00124
; LINE_WIDTH: 0.580459
G1 X175.442 Y164.01 E.0013
M204 S10000
G1 X175.5 Y164.694 F60000
; LINE_WIDTH: 0.436636
G1 F1200
M204 S8000
G1 X175.5 Y164.249 E.01384
G1 X175.478 Y164.12 E.00408
; LINE_WIDTH: 0.494595
G1 X175.466 Y164.083 E.00138
; LINE_WIDTH: 0.534192
G1 X175.454 Y164.047 E.0015
; LINE_WIDTH: 0.57379
G1 X175.442 Y164.01 E.00162
; LINE_WIDTH: 0.579891
G1 X175.384 Y164.006 E.00247
; LINE_WIDTH: 0.552471
G1 X175.326 Y164.002 E.00234
; LINE_WIDTH: 0.522673
G1 X175.197 Y164.008 E.00487
; LINE_WIDTH: 0.490072
G1 X175.01 Y164.009 E.00661
; LINE_WIDTH: 0.460985
G1 X174.829 Y164.007 E.00599
; LINE_WIDTH: 0.430375
G1 X174.373 Y163.988 E.01398
; LINE_WIDTH: 0.390258
G3 X174.066 Y163.965 I.377 J-7.029 E.00843
; LINE_WIDTH: 0.352857
G1 X173.947 Y163.952 E.00293
; LINE_WIDTH: 0.316297
G1 X173.761 Y163.928 E.00405
; LINE_WIDTH: 0.273223
G1 X173.641 Y163.909 E.00222
; LINE_WIDTH: 0.234861
G1 X173.52 Y163.89 E.00185
; LINE_WIDTH: 0.196755
G1 X173.358 Y163.859 E.002
; LINE_WIDTH: 0.158887
G1 X173.196 Y163.829 E.00151
; COOLING_NODE: 0
; WIPE_START
G1 F15000
G1 X173.358 Y163.859 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.709 Y157.4 Z19.4 F60000
G1 Z19
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X164.602 Y157.398 E.22855
G1 X164.602 Y156.602 E.0256
G1 X171.083 Y156.602 E.2084
G3 X172.146 Y155.102 I4.192 J1.844 E.05953
G1 X173.212 Y155.102 E.03428
G1 X173.26 Y155.284 E.00605
G2 X171.722 Y157.341 I1.498 J2.724 E.08515
; COOLING_NODE: 0
M204 S250
G1 X172.051 Y157.792 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X164.21 Y157.79 E.23355
G1 X164.21 Y156.21 E.04706
G1 X170.847 Y156.21 E.19768
G3 X172 Y154.71 I4.011 J1.89 E.05679
G1 X185.79 Y154.71 E.41077
G1 X185.79 Y155.292 E.01734
G1 X174.686 Y155.292 E.33076
G2 X172.056 Y157.732 I.071 J2.714 E.11673
; WIPE_START
G1 F9547.055
M204 S8000
G1 X170.056 Y157.747 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.371 Y156.966 Z19.4 F60000
G1 Z19
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.476626
G1 F1200
M204 S8000
G2 X171.473 Y156.741 I-1.534 J-.829 E.00845
; LINE_WIDTH: 0.43455
G3 X172.5 Y155.306 I3.678 J1.548 E.05506
M204 S10000
G1 X172.777 Y155.311 F60000
; LINE_WIDTH: 0.371528
G1 F1200
M204 S8000
G1 X171.891 Y155.664 E.02476
; WIPE_START
G1 F10955.307
G1 X172.777 Y155.311 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.371 Y156.966 Z19.4 F60000
G1 Z19
G1 E.8 F1800
; LINE_WIDTH: 0.486517
G1 F1200
M204 S8000
G1 X171.288 Y156.983 E.00298
; LINE_WIDTH: 0.432979
G1 X171.205 Y157.001 E.00262
G1 X164.806 Y157 E.19719
; WIPE_START
G1 F9229.378
G1 X166.806 Y157 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X173.426 Y155.143 Z19.4 F60000
G1 Z19
G1 E.8 F1800
; LINE_WIDTH: 0.424732
G1 F1200
M204 S8000
G1 X173.741 Y155.086 E.00967
; LINE_WIDTH: 0.378492
G1 X173.896 Y155.062 E.00415
; LINE_WIDTH: 0.337817
G1 X174.031 Y155.045 E.00317
; LINE_WIDTH: 0.306584
G1 X174.155 Y155.03 E.00261
; LINE_WIDTH: 0.271194
G1 X174.416 Y155.01 E.00472
; LINE_WIDTH: 0.233117
G1 X185.594 Y155.001 E.16793
; CHANGE_LAYER
; Z_HEIGHT: 19.2
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F15000
G1 X183.594 Y155.003 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 96/165
; update layer progress
M73 L96
M991 S0 P95 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z19.4 I-.881 J-.839 P1  F60000
G1 X177.789 Y161.1 Z19.4
G1 Z19.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X185.398 Y161.1 E.24467
G1 X185.398 Y161.897 E.02562
G1 X178.416 Y161.897 E.22452
G3 X176.917 Y163.739 I-4.045 J-1.761 E.07733
G3 X175.898 Y164.256 I-3.317 J-5.268 E.03679
G1 X175.898 Y164.898 E.02064
G1 X175.102 Y164.898 E.02559
G1 X175.102 Y164.433 E.01496
G3 X173.407 Y164.158 I.078 J-5.844 E.05541
G3 X172.644 Y163.778 I1.358 J-3.682 E.02747
G1 X172.694 Y163.6 E.00594
G1 X174.825 Y163.6 E.06853
G2 X177.777 Y161.159 I-.08 J-3.101 E.13274
; COOLING_NODE: 0
M204 S250
G1 X177.45 Y160.708 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X185.79 Y160.708 E.24843
G1 X185.79 Y162.289 E.04709
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X178.653 Y162.289 E.21258
G3 X176.29 Y164.509 I-4.012 J-1.903 E.09888
G1 X176.29 Y165.29 E.02326
G1 X174.71 Y165.29 E.04706
G1 X174.71 Y164.797 E.01469
G3 X171.426 Y163.208 I.071 J-4.336 E.11216
G1 X174.815 Y163.208 E.10095
G2 X177.444 Y160.768 I-.083 J-2.727 E.1166
; WIPE_START
G1 F9547.055
M204 S8000
G1 X179.444 Y160.753 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X178.211 Y161.516 Z19.6 F60000
G1 Z19.2
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.449691
G1 F1200
M204 S8000
G1 X178.293 Y161.498 E.00269
; LINE_WIDTH: 0.432503
G1 X185.194 Y161.498 E.2124
; WIPE_START
G1 F9240.658
G1 X183.194 Y161.498 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X178.211 Y161.516 Z19.6 F60000
G1 Z19.2
G1 E.8 F1800
; LINE_WIDTH: 0.475063
G1 F1200
M204 S8000
G1 X178.129 Y161.533 E.00286
G1 X178.119 Y161.55 E.00068
G2 X178.018 Y161.777 I7.701 J3.564 E.00845
; LINE_WIDTH: 0.434677
G1 X177.9 Y162.024 E.00848
G3 X175.779 Y163.858 I-3.237 J-1.599 E.08911
; LINE_WIDTH: 0.475054
G1 X175.602 Y163.921 E.00642
; LINE_WIDTH: 0.510173
G1 X175.511 Y163.965 E.00371
; LINE_WIDTH: 0.537039
G1 X175.492 Y163.977 E.00089
; LINE_WIDTH: 0.56804
G1 X175.446 Y164.008 E.00231
M204 S10000
G1 X175.5 Y164.694 F60000
; LINE_WIDTH: 0.435542
G1 F1200
M204 S8000
G1 X175.5 Y164.244 E.01398
G1 X175.482 Y164.125 E.00372
; LINE_WIDTH: 0.48855
G1 X175.47 Y164.086 E.00143
; LINE_WIDTH: 0.52971
G1 X175.458 Y164.047 E.00156
; LINE_WIDTH: 0.57087
G1 X175.446 Y164.008 E.0017
; LINE_WIDTH: 0.576775
G1 X175.385 Y164.004 E.00259
; LINE_WIDTH: 0.547391
G1 X175.324 Y163.999 E.00245
; LINE_WIDTH: 0.517364
G1 X175.197 Y164.005 E.00474
; LINE_WIDTH: 0.486225
G1 X175.011 Y164.008 E.00654
; LINE_WIDTH: 0.458667
G1 X174.831 Y164.006 E.00589
; LINE_WIDTH: 0.427971
G3 X174.316 Y163.985 I.362 J-15.194 E.01568
; LINE_WIDTH: 0.391172
G1 X174.128 Y163.971 E.00518
; LINE_WIDTH: 0.358228
G1 X173.945 Y163.952 E.00459
; LINE_WIDTH: 0.326093
G1 X173.842 Y163.938 E.00232
; LINE_WIDTH: 0.299236
G1 X173.739 Y163.925 E.0021
; LINE_WIDTH: 0.267034
G1 X173.622 Y163.906 E.00209
; LINE_WIDTH: 0.229481
G1 X173.505 Y163.887 E.00174
; LINE_WIDTH: 0.192558
G1 X173.349 Y163.857 E.00189
; LINE_WIDTH: 0.156227
G1 X173.192 Y163.828 E.00143
; COOLING_NODE: 0
; WIPE_START
G1 F15000
G1 X173.349 Y163.857 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.709 Y157.4 Z19.6 F60000
G1 Z19.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X164.602 Y157.398 E.22854
G1 X164.602 Y156.602 E.0256
G1 X171.083 Y156.602 E.2084
G3 X172.146 Y155.102 I4.185 J1.84 E.05953
G1 X173.207 Y155.102 E.03411
G1 X173.257 Y155.28 E.00594
G2 X171.722 Y157.341 I1.533 J2.744 E.08515
; COOLING_NODE: 0
M204 S250
G1 X172.051 Y157.792 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X164.21 Y157.79 E.23356
M73 P64 R10
G1 X164.21 Y156.21 E.04706
G1 X170.847 Y156.21 E.19769
G3 X172 Y154.71 I4.01 J1.889 E.05679
G1 X185.79 Y154.71 E.41077
G1 X185.79 Y155.292 E.01734
G1 X174.684 Y155.292 E.33082
G2 X172.056 Y157.732 I.073 J2.713 E.11666
; WIPE_START
G1 F9547.055
M204 S8000
G1 X170.056 Y157.747 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.372 Y156.965 Z19.6 F60000
G1 Z19.2
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.491266
G1 F1200
M204 S8000
G1 X171.406 Y156.894 E.00281
; LINE_WIDTH: 0.437334
G3 X172.501 Y155.306 I3.803 J1.449 E.06067
M204 S10000
G1 X172.78 Y155.311 F60000
; LINE_WIDTH: 0.364729
G1 F1200
M204 S8000
G1 X171.894 Y155.661 E.02421
; WIPE_START
G1 F11186.77
G1 X172.78 Y155.311 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.372 Y156.965 Z19.6 F60000
G1 Z19.2
G1 E.8 F1800
; LINE_WIDTH: 0.486918
G1 F1200
M204 S8000
G1 X171.289 Y156.983 E.00299
; LINE_WIDTH: 0.432972
G1 X171.205 Y157.001 E.00263
G1 X164.806 Y157 E.19719
; WIPE_START
G1 F9229.538
G1 X166.806 Y157 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X173.423 Y155.144 Z19.6 F60000
G1 Z19.2
G1 E.8 F1800
; LINE_WIDTH: 0.42519
G1 F1200
M204 S8000
G1 X173.741 Y155.086 E.00978
; LINE_WIDTH: 0.378477
G1 X173.896 Y155.062 E.00415
; LINE_WIDTH: 0.337807
G1 X174.031 Y155.045 E.00316
; LINE_WIDTH: 0.306682
G1 X174.155 Y155.03 E.0026
; LINE_WIDTH: 0.271274
G1 X174.417 Y155.01 E.00474
; LINE_WIDTH: 0.233176
G1 X185.594 Y155.001 E.16798
; CHANGE_LAYER
; Z_HEIGHT: 19.4
; LAYER_HEIGHT: 0.199999
; WIPE_START
G1 F15000
G1 X183.594 Y155.003 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 97/165
; update layer progress
M73 L97
M991 S0 P96 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z19.6 I-.879 J-.841 P1  F60000
G1 X177.776 Y161.084 Z19.6
G1 Z19.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X185.398 Y161.084 E.2451
G1 X185.398 Y161.888 E.02585
G1 X178.411 Y161.887 E.22469
G3 X176.912 Y163.731 I-4.044 J-1.756 E.07737
G3 X175.898 Y164.247 I-3.302 J-5.242 E.03662
G1 X175.898 Y164.898 E.02095
G1 X175.102 Y164.898 E.02559
G1 X175.102 Y164.423 E.01527
G3 X173.412 Y164.15 I.068 J-5.79 E.05525
G3 X172.633 Y163.763 I1.433 J-3.858 E.02803
G1 X172.683 Y163.584 E.00597
G1 X174.822 Y163.584 E.0688
G2 X177.764 Y161.143 I-.076 J-3.085 E.13256
; COOLING_NODE: 0
M204 S250
G1 X177.435 Y160.692 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X185.79 Y160.692 E.24887
G1 X185.79 Y162.28 E.0473
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X178.648 Y162.279 E.21273
G3 X176.29 Y164.499 I-3.975 J-1.86 E.09881
G1 X176.29 Y165.29 E.02355
G1 X174.71 Y165.29 E.04706
G1 X174.71 Y164.788 E.01497
G3 X171.424 Y163.192 I.075 J-4.335 E.1123
G1 X174.809 Y163.192 E.10082
G2 X177.43 Y160.752 I-.066 J-2.698 E.11662
; WIPE_START
G1 F9547.055
M204 S8000
G1 X179.43 Y160.737 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
M73 P64 R9
G1 X178.204 Y161.503 Z19.8 F60000
G1 Z19.4
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.48392
G1 F1200
M204 S8000
G1 X178.12 Y161.521 E.00298
G1 X178.106 Y161.547 E.00101
G2 X178.014 Y161.756 I2.445 J1.202 E.00797
; LINE_WIDTH: 0.442623
G1 X177.902 Y161.992 E.00826
G3 X175.712 Y163.87 I-3.251 J-1.577 E.09369
; LINE_WIDTH: 0.486877
G1 X175.601 Y163.908 E.00412
; LINE_WIDTH: 0.519673
G1 X175.528 Y163.948 E.00314
; LINE_WIDTH: 0.563412
G1 X175.455 Y163.989 E.00343
; LINE_WIDTH: 0.590153
G1 X175.446 Y163.996 E.00049
M204 S10000
G1 X175.5 Y164.694 F60000
; LINE_WIDTH: 0.435459
G1 F1200
M204 S8000
G1 X175.5 Y164.234 E.01428
G1 X175.482 Y164.115 E.00371
; LINE_WIDTH: 0.488989
G1 X175.47 Y164.075 E.00147
; LINE_WIDTH: 0.531398
G1 X175.458 Y164.036 E.00161
; LINE_WIDTH: 0.573808
G1 X175.446 Y163.996 E.00175
; LINE_WIDTH: 0.590225
G1 X175.431 Y163.993 E.00062
; LINE_WIDTH: 0.562115
G1 X175.324 Y163.986 E.00443
; LINE_WIDTH: 0.516426
G1 X175.124 Y163.994 E.00746
; LINE_WIDTH: 0.474177
G1 X174.829 Y163.993 E.01006
; LINE_WIDTH: 0.434929
G3 X174.317 Y163.972 I.335 J-14.654 E.01587
; LINE_WIDTH: 0.398466
G1 X174.13 Y163.958 E.00528
; LINE_WIDTH: 0.365193
G1 X173.943 Y163.939 E.00477
; LINE_WIDTH: 0.330741
G1 X173.827 Y163.924 E.00267
; LINE_WIDTH: 0.299869
G1 X173.71 Y163.908 E.00238
; LINE_WIDTH: 0.268257
G1 X173.611 Y163.892 E.00179
; LINE_WIDTH: 0.235905
G1 X173.512 Y163.876 E.00153
; LINE_WIDTH: 0.201662
G1 X173.346 Y163.844 E.00212
; LINE_WIDTH: 0.16553
G1 X173.18 Y163.812 E.00164
; WIPE_START
G1 F15000
G1 X173.346 Y163.844 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X178.204 Y161.503 Z19.8 F60000
G1 Z19.4
G1 E.8 F1800
; LINE_WIDTH: 0.456971
G1 F1200
M204 S8000
G1 X178.287 Y161.486 E.0028
; LINE_WIDTH: 0.43947
G1 X185.194 Y161.486 E.21636
; COOLING_NODE: 0
; WIPE_START
G1 F9078.319
G1 X183.194 Y161.486 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X176.001 Y158.934 Z19.8 F60000
G1 X171.722 Y157.416 Z19.8
G1 Z19.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X170.856 Y157.416 E.02786
G1 X170.856 Y157.398 E.00059
G1 X164.602 Y157.398 E.20109
G1 X164.602 Y156.602 E.02559
G1 X171.096 Y156.602 E.20883
G3 X172.159 Y155.102 I4.17 J1.828 E.05952
G1 X173.244 Y155.102 E.03491
G1 X173.292 Y155.284 E.00605
G2 X171.734 Y157.357 I1.456 J2.716 E.08608
; COOLING_NODE: 0
M204 S250
G1 X172.066 Y157.808 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X170.468 Y157.808 E.04759
G1 X170.468 Y157.79 E.00055
G1 X164.21 Y157.79 E.1864
G1 X164.21 Y156.21 E.04706
G1 X170.858 Y156.21 E.19802
G3 X172.015 Y154.71 I3.978 J1.872 E.05687
G1 X185.79 Y154.71 E.41032
G1 X185.79 Y155.308 E.01782
G1 X174.691 Y155.308 E.3306
G2 X172.071 Y157.748 I.066 J2.697 E.11662
M204 S10000
G1 X171.554 Y157.213 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.428462
G1 F1200
M204 S8000
G1 X171.403 Y157.011 E.00766
; LINE_WIDTH: 0.492979
G1 X171.38 Y156.978 E.00145
G1 X171.417 Y156.908 E.00282
; LINE_WIDTH: 0.444445
G3 X172.521 Y155.306 I3.747 J1.401 E.06234
M204 S10000
G1 X171.919 Y155.644 F60000
; LINE_WIDTH: 0.243009
G1 F1200
M204 S8000
G1 X172.808 Y155.319 E.01496
M204 S10000
G1 X172.805 Y155.309 F60000
; LINE_WIDTH: 0.385254
G1 F1200
M204 S8000
G1 X171.895 Y155.672 E.02649
; WIPE_START
G1 F10516.058
G1 X172.805 Y155.309 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.141 Y157.009 Z19.8 F60000
G1 Z19.4
G1 E.8 F1800
; LINE_WIDTH: 0.431843
G1 F1200
M204 S8000
G1 X164.806 Y157 E.19465
; WIPE_START
G1 F9256.337
G1 X166.806 Y157.003 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X173.52 Y155.379 Z19.8 F60000
G1 Z19.4
G1 E.8 F1800
; LINE_WIDTH: 0.408956
G1 F1200
M204 S8000
G1 X173.65 Y155.126 E.00822
; LINE_WIDTH: 0.430194
G1 X173.659 Y155.109 E.00058
G1 X173.775 Y155.09 E.00361
; LINE_WIDTH: 0.391018
G1 X173.892 Y155.07 E.00325
; LINE_WIDTH: 0.354523
G1 X174.031 Y155.053 E.00345
; LINE_WIDTH: 0.322681
G1 X174.156 Y155.038 E.00279
; LINE_WIDTH: 0.287149
G1 X174.418 Y155.018 E.00506
; LINE_WIDTH: 0.24921
G1 X185.594 Y155.009 E.18212
; CHANGE_LAYER
; Z_HEIGHT: 19.6
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F15000
G1 X183.594 Y155.011 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 98/165
; update layer progress
M73 L98
M991 S0 P97 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z19.8 I-.875 J-.846 P1  F60000
G1 X177.754 Y161.052 Z19.8
G1 Z19.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X185.398 Y161.051 E.2458
G1 X185.398 Y161.87 E.02632
G1 X178.396 Y161.869 E.22515
G3 X176.728 Y163.826 I-3.95 J-1.677 E.08398
G3 X175.898 Y164.228 I-3.445 J-6.054 E.02968
G1 X175.898 Y164.898 E.02154
G1 X175.102 Y164.898 E.02559
G1 X175.102 Y164.406 E.01582
G3 X173.418 Y164.133 I.078 J-5.82 E.05505
G3 X172.616 Y163.729 I2.049 J-5.063 E.0289
G1 X172.667 Y163.551 E.00594
G1 X174.824 Y163.552 E.06936
G2 X177.742 Y161.11 I-.104 J-3.089 E.1318
; COOLING_NODE: 0
M204 S250
G1 X177.405 Y160.659 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X185.79 Y160.659 E.24978
G1 X185.79 Y162.262 E.04774
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X178.635 Y162.261 E.21311
G3 X176.29 Y164.48 I-3.966 J-1.843 E.09851
G1 X176.29 Y165.29 E.02412
G1 X174.71 Y165.29 E.04706
G1 X174.71 Y164.77 E.01549
G3 X171.421 Y163.159 I.097 J-4.36 E.11256
G1 X174.813 Y163.159 E.10102
G2 X177.4 Y160.719 I-.081 J-2.677 E.11584
M204 S10000
G1 X177.92 Y161.255 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.455046
G1 F1200
M204 S8000
M73 P65 R9
G1 X178.083 Y161.472 E.00883
; LINE_WIDTH: 0.505254
G1 X178.101 Y161.496 E.00109
G1 X178.186 Y161.478 E.00319
; LINE_WIDTH: 0.471266
G1 X178.272 Y161.46 E.00296
; LINE_WIDTH: 0.453823
G1 X185.194 Y161.461 E.22469
; WIPE_START
G1 F8761.206
G1 X183.194 Y161.461 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X178.101 Y161.496 Z20 F60000
G1 Z19.6
G1 E.8 F1800
; LINE_WIDTH: 0.497292
G1 F1200
M204 S8000
G2 X178.008 Y161.704 I2.814 J1.388 E.00819
; LINE_WIDTH: 0.456751
G1 X177.788 Y162.157 E.01646
G3 X175.768 Y163.822 I-3.118 J-1.724 E.08762
; LINE_WIDTH: 0.49721
G1 X175.597 Y163.883 E.00653
; LINE_WIDTH: 0.532392
G1 X175.504 Y163.928 E.00399
; LINE_WIDTH: 0.559954
G1 X175.484 Y163.941 E.00097
; LINE_WIDTH: 0.588517
G1 X175.442 Y163.969 E.00217
; LINE_WIDTH: 0.595701
G1 X175.383 Y163.965 E.00257
; LINE_WIDTH: 0.568642
G1 X175.325 Y163.962 E.00244
; LINE_WIDTH: 0.539091
G1 X175.193 Y163.968 E.00517
; LINE_WIDTH: 0.507464
G1 X175.008 Y163.97 E.00679
; LINE_WIDTH: 0.480085
G1 X174.829 Y163.968 E.00617
; LINE_WIDTH: 0.449631
G3 X174.32 Y163.947 I.363 J-15.112 E.01636
; LINE_WIDTH: 0.41344
G1 X174.137 Y163.933 E.00539
; LINE_WIDTH: 0.377411
G1 X173.925 Y163.911 E.00563
; LINE_WIDTH: 0.340428
G1 X173.815 Y163.896 E.00262
; LINE_WIDTH: 0.310646
G1 X173.704 Y163.881 E.00236
; LINE_WIDTH: 0.280785
G1 X173.613 Y163.866 E.00174
; LINE_WIDTH: 0.25085
G1 X173.521 Y163.852 E.00152
; LINE_WIDTH: 0.218141
G1 X173.338 Y163.816 E.00259
; LINE_WIDTH: 0.182681
G1 X173.154 Y163.781 E.00206
; WIPE_START
G1 F15000
G1 X173.338 Y163.816 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.442 Y163.969 Z20 F60000
G1 Z19.6
G1 E.8 F1800
; LINE_WIDTH: 0.585795
G1 F1200
M204 S8000
G1 X175.455 Y164.012 E.00192
; LINE_WIDTH: 0.538921
G1 X175.468 Y164.054 E.00175
; LINE_WIDTH: 0.492048
G1 X175.482 Y164.097 E.00159
; LINE_WIDTH: 0.435468
G1 X175.5 Y164.217 E.00376
G1 X175.5 Y164.694 E.01481
; COOLING_NODE: 0
; WIPE_START
G1 F9170.859
G1 X175.5 Y164.217 E-.6062
G1 X175.482 Y164.097 E-.1538
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.745 Y157.449 Z20 F60000
G1 Z19.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X170.878 Y157.449 E.02788
G1 X170.878 Y157.398 E.00163
G1 X164.602 Y157.398 E.2018
G1 X164.602 Y156.602 E.02559
G1 X171.108 Y156.602 E.20922
G3 X172.185 Y155.102 I4.42 J2.036 E.05973
G1 X173.307 Y155.102 E.0361
G1 X173.355 Y155.285 E.00608
G2 X171.757 Y157.39 I1.429 J2.744 E.08779
; COOLING_NODE: 0
M204 S250
G1 X172.096 Y157.841 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X170.487 Y157.841 E.04791
G1 X170.487 Y157.79 E.00151
G1 X164.21 Y157.79 E.18698
G1 X164.21 Y156.21 E.04706
G1 X170.875 Y156.21 E.19853
G3 X172.043 Y154.71 I4.13 J2.011 E.05704
G1 X185.79 Y154.71 E.40947
G1 X185.79 Y155.341 E.01878
G1 X174.685 Y155.341 E.33077
G2 X172.1 Y157.781 I.072 J2.666 E.1159
; WIPE_START
G1 F9547.055
M204 S8000
G1 X170.487 Y157.841 E-.6133
G1 X170.487 Y157.79 E-.01929
G1 X170.152 Y157.79 E-.12741
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.405 Y156.974 Z20 F60000
G1 Z19.6
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.505468
G1 F1200
M204 S8000
G2 X171.486 Y156.8 I-1.341 J-.725 E.00699
; LINE_WIDTH: 0.472561
G1 X171.611 Y156.537 E.00992
; LINE_WIDTH: 0.449473
G3 X172.36 Y155.505 I3.027 J1.41 E.04119
G1 X172.859 Y155.306 E.01725
M204 S10000
G1 X172.864 Y155.315 F60000
; LINE_WIDTH: 0.31383
G1 F1200
M204 S8000
G1 X171.924 Y155.666 E.02149
; WIPE_START
G1 F13288.582
G1 X172.864 Y155.315 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X173.522 Y155.15 Z20 F60000
G1 Z19.6
G1 E.8 F1800
; LINE_WIDTH: 0.440184
G1 F1200
M204 S8000
G1 X173.838 Y155.095 E.01007
; LINE_WIDTH: 0.397926
G1 X174.003 Y155.072 E.00465
; LINE_WIDTH: 0.361059
G1 X174.125 Y155.058 E.0031
; LINE_WIDTH: 0.333809
G1 X174.266 Y155.045 E.00325
; LINE_WIDTH: 0.282028
G1 X174.679 Y155.025 E.0078
G1 X185.594 Y155.025 E.20617
; WIPE_START
G1 F15000
G1 X183.594 Y155.025 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X176.079 Y156.361 Z20 F60000
G1 X171.104 Y157.245 Z20
G1 Z19.6
G1 E.8 F1800
; LINE_WIDTH: 0.168822
G1 F1200
M204 S8000
G1 X171.121 Y157.214 E.00035
; LINE_WIDTH: 0.217062
G1 X171.138 Y157.182 E.00049
; LINE_WIDTH: 0.265303
G1 X171.154 Y157.151 E.00062
; LINE_WIDTH: 0.313544
G1 X171.171 Y157.12 E.00076
; LINE_WIDTH: 0.361785
G1 X171.187 Y157.088 E.00089
; LINE_WIDTH: 0.410026
G1 X171.204 Y157.057 E.00103
; LINE_WIDTH: 0.458267
G1 X171.221 Y157.025 E.00117
M204 S10000
G1 X171.405 Y156.974 F60000
; LINE_WIDTH: 0.515744
G1 F1200
M204 S8000
G1 X171.393 Y156.995 E.00092
G1 X171.23 Y157.025 E.0062
; LINE_WIDTH: 0.482393
G1 X171.221 Y157.025 E.00031
; LINE_WIDTH: 0.469719
G1 X171.151 Y157.013 E.0024
; LINE_WIDTH: 0.431863
G1 X171.08 Y157 E.00219
G1 X164.806 Y157 E.19278
; CHANGE_LAYER
; Z_HEIGHT: 19.8
; LAYER_HEIGHT: 0.199999
; WIPE_START
G1 F9255.87
G1 X166.806 Y157 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 99/165
; update layer progress
M73 L99
M991 S0 P98 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z20 I-.419 J1.142 P1  F60000
G1 X177.712 Y161.002 Z20
G1 Z19.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X185.398 Y161.002 E.24716
G1 X185.398 Y161.843 E.02705
G1 X178.378 Y161.842 E.22573
G3 X176.885 Y163.695 I-3.963 J-1.665 E.07755
G3 X175.898 Y164.199 I-3.293 J-5.237 E.03567
G1 X175.898 Y164.898 E.02248
G1 X175.102 Y164.898 E.02559
G1 X175.102 Y164.378 E.01671
G3 X173.367 Y164.086 I.061 J-5.647 E.0568
G3 X172.587 Y163.677 I1.501 J-3.813 E.02839
G1 X172.639 Y163.502 E.00586
G1 X174.824 Y163.502 E.07027
G2 X177.701 Y161.061 I-.103 J-3.037 E.1309
; COOLING_NODE: 0
M204 S250
G1 X177.357 Y160.61 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X185.79 Y160.61 E.2512
G1 X185.79 Y160.618 E.00025
G1 X185.79 Y162.235 E.04816
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X178.618 Y162.234 E.21363
G3 X176.29 Y164.451 I-3.939 J-1.805 E.0981
G1 X176.29 Y165.29 E.02499
G1 X174.71 Y165.29 E.04706
G1 X174.71 Y164.743 E.0163
G3 X171.423 Y163.118 I.07 J-4.279 E.11287
G1 X171.416 Y163.11 E.00032
G1 X174.213 Y163.11 E.08331
G2 X175.521 Y162.994 I.3 J-4.038 E.03929
G2 X177.353 Y160.67 I-.805 J-2.518 E.09354
; WIPE_START
G1 F9547.055
M204 S8000
G1 X179.353 Y160.656 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X178.163 Y161.441 Z20.2 F60000
G1 Z19.8
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.494706
G1 F1200
M204 S8000
G1 X178.254 Y161.422 E.00329
; LINE_WIDTH: 0.476362
G1 X185.194 Y161.422 E.23764
; WIPE_START
G1 F8305.616
G1 X183.194 Y161.422 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X178.163 Y161.441 Z20.2 F60000
G1 Z19.8
G1 E.8 F1800
; LINE_WIDTH: 0.525236
G1 F1200
M204 S8000
G2 X178.038 Y161.528 I-.028 J.094 E.00668
G1 X177.979 Y161.671 E.00588
; LINE_WIDTH: 0.479437
G1 X177.754 Y162.14 E.01795
G3 X175.756 Y163.786 I-3.085 J-1.709 E.09138
; LINE_WIDTH: 0.519245
G1 X175.593 Y163.844 E.00653
; LINE_WIDTH: 0.554361
G1 X175.496 Y163.891 E.00432
; LINE_WIDTH: 0.582826
G1 X175.475 Y163.904 E.00106
; LINE_WIDTH: 0.609129
G1 X175.438 Y163.929 E.00201
M204 S10000
G1 X175.5 Y164.694 F60000
; LINE_WIDTH: 0.435426
G1 F1200
M204 S8000
G1 X175.5 Y164.189 E.01567
G1 X175.481 Y164.068 E.0038
; LINE_WIDTH: 0.489249
G1 X175.47 Y164.033 E.00129
; LINE_WIDTH: 0.528686
G1 X175.459 Y163.998 E.0014
; LINE_WIDTH: 0.568123
G1 X175.448 Y163.963 E.00151
; LINE_WIDTH: 0.607561
G1 X175.438 Y163.929 E.00163
; LINE_WIDTH: 0.602365
G1 X175.325 Y163.923 E.00498
; LINE_WIDTH: 0.56079
G1 X175.187 Y163.929 E.00565
; LINE_WIDTH: 0.528837
G1 X175.005 Y163.931 E.00701
; LINE_WIDTH: 0.502085
G1 X174.829 Y163.93 E.00635
; LINE_WIDTH: 0.472382
G3 X174.325 Y163.909 I.336 J-14.573 E.01712
; LINE_WIDTH: 0.436524
G1 X174.142 Y163.895 E.00573
; LINE_WIDTH: 0.403474
G1 X173.955 Y163.876 E.00535
; LINE_WIDTH: 0.370257
G1 X173.841 Y163.862 E.00296
; LINE_WIDTH: 0.337572
G1 X173.718 Y163.844 E.0029
; LINE_WIDTH: 0.300435
G1 X173.595 Y163.825 E.00253
; LINE_WIDTH: 0.261111
G1 X173.11 Y163.739 E.00848
; COOLING_NODE: 0
; WIPE_START
G1 F15000
G1 X173.595 Y163.825 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.792 Y157.498 Z20.2 F60000
G1 Z19.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X170.901 Y157.498 E.02865
G1 X170.9 Y157.398 E.00322
G1 X164.602 Y157.398 E.20252
G1 X164.602 Y156.602 E.02559
G1 X171.138 Y156.602 E.21017
G3 X172.228 Y155.102 I4.342 J2.01 E.06001
G1 X173.41 Y155.102 E.03801
G1 X173.458 Y155.284 E.00605
G2 X171.803 Y157.439 I1.316 J2.724 E.09063
; COOLING_NODE: 0
M204 S250
G1 X172.142 Y157.89 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X170.514 Y157.89 E.04852
G1 X170.513 Y157.882 E.00025
G1 X170.512 Y157.79 E.00273
G1 X164.21 Y157.79 E.18773
G1 X164.21 Y156.21 E.04706
G1 X170.905 Y156.21 E.19942
G3 X172.086 Y154.71 I4.084 J2.001 E.0573
G1 X185.79 Y154.71 E.4082
G1 X185.79 Y155.382 E.02
G1 X185.79 Y155.39 E.00025
G1 X175.285 Y155.39 E.3129
G2 X173.798 Y155.569 I-.3 J3.77 E.04492
G2 X172.146 Y157.83 I.958 J2.434 E.08802
M204 S10000
G1 X171.618 Y157.294 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.561822
G1 F1200
M204 S8000
G1 X171.415 Y157.025 E.01383
G1 X171.473 Y156.922 E.00485
; LINE_WIDTH: 0.526741
G1 X171.494 Y156.874 E.00201
; LINE_WIDTH: 0.49861
G1 X171.65 Y156.544 E.01313
; LINE_WIDTH: 0.465724
G3 X172.39 Y155.522 I3.166 J1.513 E.04238
G3 X172.945 Y155.306 I6.439 J15.677 E.01988
M204 S10000
G1 X173.628 Y155.157 F60000
; LINE_WIDTH: 0.458202
G1 F1200
M204 S8000
G1 X174.011 Y155.096 E.01274
; LINE_WIDTH: 0.405616
G1 X174.169 Y155.079 E.00455
; LINE_WIDTH: 0.368414
G1 X174.42 Y155.059 E.00647
; LINE_WIDTH: 0.331172
G1 X185.594 Y155.05 E.25443
; WIPE_START
G1 F12489.1
G1 X183.594 Y155.052 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X176.06 Y156.275 Z20.2 F60000
G1 X171.299 Y157.048 Z20.2
G1 Z19.8
G1 E.8 F1800
; LINE_WIDTH: 0.515385
G1 F1200
M204 S8000
G1 X171.259 Y157.032 E.00163
; LINE_WIDTH: 0.479665
G1 X171.18 Y157.016 E.00277
; LINE_WIDTH: 0.431922
G1 X171.101 Y157 E.00247
G1 X164.806 Y157 E.19345
; CHANGE_LAYER
; Z_HEIGHT: 20
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F9254.461
G1 X166.806 Y157 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 100/165
; update layer progress
M73 L100
M991 S0 P99 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z20.2 I-.415 J1.144 P1  F60000
G1 X177.656 Y160.934 Z20.2
G1 Z20
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X185.398 Y160.934 E.24895
G1 X185.398 Y161.807 E.02805
G1 X178.351 Y161.806 E.22661
G3 X176.757 Y163.735 I-3.905 J-1.604 E.0817
G3 X175.898 Y164.161 I-3.289 J-5.555 E.03085
G1 X175.898 Y164.898 E.02371
M73 P66 R9
G1 X175.102 Y164.898 E.02559
G1 X175.102 Y164.343 E.01784
G3 X173.502 Y164.096 I.088 J-5.887 E.05223
G3 X172.55 Y163.61 I1.504 J-4.118 E.03446
G1 X172.601 Y163.434 E.00589
G1 X174.824 Y163.434 E.07147
G2 X177.646 Y160.993 I-.098 J-2.966 E.12975
; COOLING_NODE: 0
M204 S250
G1 X177.292 Y160.542 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X185.79 Y160.542 E.25312
G1 X185.79 Y160.569 E.00079
G1 X185.79 Y162.199 E.04855
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X178.594 Y162.198 E.21435
G3 X176.29 Y164.412 I-3.941 J-1.795 E.09748
G1 X176.29 Y165.29 E.02615
G1 X174.71 Y165.29 E.04706
G1 X174.71 Y164.707 E.01737
G3 X171.429 Y163.069 I.076 J-4.257 E.11292
G1 X171.41 Y163.042 E.00098
G1 X174.213 Y163.042 E.0835
G2 X175.502 Y162.929 I.3 J-3.969 E.03871
G2 X177.291 Y160.602 I-.786 J-2.456 E.09299
; WIPE_START
G1 F9547.055
M204 S8000
G1 X179.291 Y160.588 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X178.13 Y161.39 Z20.4 F60000
G1 Z20
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.526845
G1 F1200
M204 S8000
G1 X178.225 Y161.37 E.00371
; LINE_WIDTH: 0.507784
G1 X185.194 Y161.371 E.25594
; WIPE_START
G1 F7744.212
G1 X183.194 Y161.37 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X178.13 Y161.39 Z20.4 F60000
G1 Z20
G1 E.8 F1800
; LINE_WIDTH: 0.561075
G1 F1200
M204 S8000
G2 X177.995 Y161.489 I-.029 J.101 E.00787
G1 X177.963 Y161.57 E.00359
; LINE_WIDTH: 0.51142
G1 X177.737 Y162.061 E.02
G3 X175.741 Y163.737 I-3.065 J-1.624 E.09889
; LINE_WIDTH: 0.551035
G1 X175.586 Y163.793 E.00662
; LINE_WIDTH: 0.585903
G1 X175.486 Y163.84 E.00471
; LINE_WIDTH: 0.629479
G1 X175.431 Y163.875 E.00304
; LINE_WIDTH: 0.632827
G1 X175.327 Y163.871 E.00485
; LINE_WIDTH: 0.593238
G1 X175.18 Y163.877 E.00636
; LINE_WIDTH: 0.560267
G1 X175.001 Y163.88 E.00735
; LINE_WIDTH: 0.533737
G1 X174.83 Y163.878 E.00663
; LINE_WIDTH: 0.504082
G3 X174.332 Y163.858 I.358 J-14.82 E.01814
; LINE_WIDTH: 0.4684
G1 X174.15 Y163.844 E.00613
; LINE_WIDTH: 0.43625
G1 X173.97 Y163.825 E.00562
; LINE_WIDTH: 0.402161
G1 X173.852 Y163.81 E.00338
; LINE_WIDTH: 0.370736
G1 X173.734 Y163.794 E.00308
; LINE_WIDTH: 0.334973
G1 X173.395 Y163.737 E.00792
; LINE_WIDTH: 0.294881
G1 X173.057 Y163.68 E.00683
; WIPE_START
G1 F14287.944
G1 X173.395 Y163.737 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.431 Y163.875 Z20.4 F60000
G1 Z20
G1 E.8 F1800
; LINE_WIDTH: 0.631702
G1 F1200
M204 S8000
G1 X175.443 Y163.914 E.00189
; LINE_WIDTH: 0.585866
G1 X175.455 Y163.953 E.00175
; LINE_WIDTH: 0.540029
G1 X175.468 Y163.991 E.0016
; LINE_WIDTH: 0.494192
G1 X175.48 Y164.03 E.00145
; LINE_WIDTH: 0.435458
G1 X175.5 Y164.154 E.00389
G1 X175.5 Y164.694 E.01675
; COOLING_NODE: 0
; WIPE_START
G1 F9171.09
G1 X175.5 Y164.154 E-.61669
G1 X175.48 Y164.03 E-.14331
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.844 Y157.566 Z20.4 F60000
G1 Z20
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X170.935 Y157.566 E.02924
G1 X170.932 Y157.398 E.0054
G1 X164.602 Y157.398 E.20354
G1 X164.602 Y156.602 E.02559
G1 X171.177 Y156.602 E.21143
G3 X172.281 Y155.102 I4.334 J2.033 E.06027
G1 X173.572 Y155.102 E.04153
G1 X173.616 Y155.292 E.00627
G2 X171.854 Y157.507 I1.163 J2.733 E.09484
; COOLING_NODE: 0
M204 S250
G1 X172.208 Y157.937 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X172.208 Y157.958 E.00061
G1 X170.55 Y157.958 E.04937
G1 X170.55 Y157.931 E.0008
G1 X170.547 Y157.79 E.0042
G1 X164.21 Y157.79 E.18876
G1 X164.21 Y156.21 E.04706
G1 X170.945 Y156.21 E.20061
G3 X172.144 Y154.71 I3.868 J1.862 E.05768
G1 X185.79 Y154.71 E.40648
G1 X185.79 Y155.431 E.02148
G1 X185.79 Y155.458 E.00079
G1 X175.285 Y155.458 E.3129
G2 X173.998 Y155.571 I-.3 J3.95 E.03866
G1 X173.873 Y155.614 E.00393
G2 X172.67 Y156.538 I.889 J2.402 E.04589
G1 X172.596 Y156.649 E.00398
G2 X172.272 Y157.43 I2.212 J1.374 E.02529
G1 X172.248 Y157.548 E.00359
G1 X172.228 Y157.678 E.00392
G1 X172.215 Y157.81 E.00394
G1 X172.211 Y157.877 E.00201
; WIPE_START
G1 F9547.055
M204 S8000
G1 X172.208 Y157.958 E-.03059
G1 X170.55 Y157.958 E-.62982
G1 X170.55 Y157.931 E-.01021
G1 X170.547 Y157.79 E-.05361
G1 X170.453 Y157.79 E-.03577
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.479 Y157.011 Z20.4 F60000
G1 Z20
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.624451
G1 F1200
M204 S8000
G3 X171.392 Y157.076 I-.075 J-.01 E.00557
M204 S10000
G1 X171.479 Y157.011 F60000
; LINE_WIDTH: 0.586812
G1 F1200
M204 S8000
G1 X171.512 Y156.958 E.00268
; LINE_WIDTH: 0.551905
G1 X171.591 Y156.784 E.00769
; LINE_WIDTH: 0.510132
G3 X172.158 Y155.846 I3.706 J1.599 E.04059
G1 X172.409 Y155.575 E.01362
G1 X172.709 Y155.306 E.01488
; WIPE_START
G1 F7705.283
G1 X172.409 Y155.575 E-.16372
G1 X172.158 Y155.846 E-.1499
G1 X171.843 Y156.295 E-.22298
G1 X171.591 Y156.784 E-.2234
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X173.787 Y155.162 Z20.4 F60000
G1 Z20
G1 E.8 F1800
; LINE_WIDTH: 0.484961
G1 F1200
M204 S8000
G1 X174.16 Y155.114 E.01314
; LINE_WIDTH: 0.437368
G1 X174.42 Y155.093 E.00813
; LINE_WIDTH: 0.398763
G1 X185.594 Y155.084 E.31408
; WIPE_START
G1 F10116.827
G1 X183.594 Y155.085 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X176.087 Y156.461 Z20.4 F60000
G1 X171.169 Y157.362 Z20.4
G1 Z20
G1 E.8 F1800
; LINE_WIDTH: 0.408145
G1 F1200
M204 S8000
G1 X171.214 Y157.305 E.00209
; LINE_WIDTH: 0.454229
G1 X171.258 Y157.248 E.00236
; LINE_WIDTH: 0.500314
G1 X171.303 Y157.19 E.00262
; LINE_WIDTH: 0.546398
G1 X171.347 Y157.133 E.00288
; LINE_WIDTH: 0.592482
G1 X171.392 Y157.076 E.00315
; LINE_WIDTH: 0.596738
G1 X171.361 Y157.062 E.0015
; LINE_WIDTH: 0.559171
G1 X171.329 Y157.049 E.0014
; LINE_WIDTH: 0.521604
G1 X171.298 Y157.036 E.00129
; LINE_WIDTH: 0.485041
G1 X171.215 Y157.018 E.00297
; LINE_WIDTH: 0.431956
G1 X171.131 Y157 E.00261
G1 X164.806 Y157 E.1944
; CHANGE_LAYER
; Z_HEIGHT: 20.2
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F9253.649
G1 X166.806 Y157 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 101/165
; update layer progress
M73 L101
M991 S0 P100 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z20.4 I-.409 J1.146 P1  F60000
G1 X177.579 Y160.847 Z20.4
G1 Z20.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X185.398 Y160.847 E.25143
G1 X185.398 Y161.761 E.0294
G1 X178.324 Y161.761 E.22747
G3 X176.841 Y163.626 I-3.959 J-1.625 E.07766
G3 X175.898 Y164.112 I-3.33 J-5.304 E.03416
G1 X175.898 Y164.898 E.02526
G1 X175.102 Y164.898 E.02559
G1 X175.102 Y164.307 E.019
G3 X174.086 Y164.202 I.369 J-8.549 E.03285
G3 X172.503 Y163.515 I.711 J-3.803 E.05598
G1 X172.558 Y163.347 E.00568
G1 X174.823 Y163.347 E.07281
G2 X177.571 Y160.906 I-.082 J-2.86 E.12835
; COOLING_NODE: 0
M204 S250
G1 X177.205 Y160.455 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X185.79 Y160.455 E.25572
G1 X185.79 Y160.501 E.00138
G1 X185.79 Y162.153 E.04921
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X178.566 Y162.153 E.21517
G3 X176.29 Y164.363 I-3.904 J-1.744 E.09682
G1 X176.29 Y165.29 E.02761
G1 X174.71 Y165.29 E.04706
G1 X174.71 Y164.665 E.01863
G3 X171.435 Y163.001 I.093 J-4.238 E.11316
G1 X171.4 Y162.955 E.00173
G1 X174.212 Y162.955 E.08374
G2 X175.473 Y162.846 I.3 J-3.889 E.03789
G2 X177.205 Y160.515 I-.754 J-2.369 E.09237
; WIPE_START
G1 F9547.055
M204 S8000
G1 X179.205 Y160.501 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X178.092 Y161.326 Z20.6 F60000
G1 Z20.2
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.571586
G1 F1200
M204 S8000
G1 X178.198 Y161.304 E.00451
; LINE_WIDTH: 0.54978
G1 X185.194 Y161.304 E.28011
; WIPE_START
G1 F7102.558
G1 X183.194 Y161.304 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X178.092 Y161.326 Z20.6 F60000
G1 Z20.2
G1 E.8 F1800
; LINE_WIDTH: 0.613456
G1 F1200
M204 S8000
G1 X177.987 Y161.348 E.00487
G2 X177.925 Y161.489 I1.231 J.62 E.00693
; LINE_WIDTH: 0.554102
G1 X177.714 Y161.96 E.02083
G3 X175.713 Y163.677 I-3.04 J-1.517 E.10937
; LINE_WIDTH: 0.593929
G1 X175.576 Y163.726 E.00632
; LINE_WIDTH: 0.628023
G1 X175.473 Y163.775 E.0053
; LINE_WIDTH: 0.67298
G1 X175.414 Y163.812 E.00342
M204 S10000
G1 X175.5 Y164.694 F60000
; LINE_WIDTH: 0.436651
G1 F1200
M204 S8000
G1 X175.5 Y164.121 E.01783
G1 X175.475 Y163.982 E.0044
; LINE_WIDTH: 0.50324
G1 X175.463 Y163.948 E.00132
; LINE_WIDTH: 0.546715
G1 X175.451 Y163.914 E.00144
; LINE_WIDTH: 0.590189
G1 X175.439 Y163.88 E.00156
; LINE_WIDTH: 0.633664
G1 X175.426 Y163.846 E.00169
; LINE_WIDTH: 0.677139
G1 X175.414 Y163.812 E.00181
; LINE_WIDTH: 0.683538
G1 X175.334 Y163.81 E.00405
; LINE_WIDTH: 0.647014
G1 X175.172 Y163.816 E.00777
; LINE_WIDTH: 0.609613
G1 X174.996 Y163.817 E.00786
; LINE_WIDTH: 0.580708
G1 X174.828 Y163.813 E.00712
; LINE_WIDTH: 0.546012
G1 X174.332 Y163.791 E.01974
; LINE_WIDTH: 0.510422
G1 X174.162 Y163.778 E.00628
; LINE_WIDTH: 0.479488
G1 X173.985 Y163.76 E.00614
; LINE_WIDTH: 0.445985
G1 X173.87 Y163.744 E.00372
; LINE_WIDTH: 0.415185
G1 X173.754 Y163.729 E.00343
; LINE_WIDTH: 0.380085
G1 X173.385 Y163.667 E.00995
; LINE_WIDTH: 0.340693
G1 X173.017 Y163.605 E.00879
; COOLING_NODE: 0
; WIPE_START
G1 F12089.746
G1 X173.385 Y163.667 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.925 Y157.653 Z20.6 F60000
G1 Z20.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X170.979 Y157.653 E.03042
G1 X170.971 Y157.398 E.00821
G1 X164.602 Y157.398 E.20481
G1 X164.602 Y156.602 E.02559
G1 X171.227 Y156.602 E.21305
G3 X172.352 Y155.102 I4.244 J2.01 E.06069
G1 X173.798 Y155.102 E.04651
G1 X173.836 Y155.3 E.00649
G2 X171.933 Y157.594 I.955 J2.729 E.10068
; COOLING_NODE: 0
M204 S250
G1 X172.295 Y158.045 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X170.598 Y158.045 E.05055
G1 X170.597 Y157.999 E.00138
G1 X170.59 Y157.79 E.00623
G1 X164.21 Y157.79 E.19005
G1 X164.21 Y156.21 E.04706
G1 X170.996 Y156.21 E.20213
G3 X172.217 Y154.71 I3.974 J1.988 E.05808
G1 X185.79 Y154.71 E.40429
G1 X185.79 Y155.499 E.02349
G1 X185.79 Y155.545 E.00138
G1 X175.287 Y155.545 E.31285
G2 X174.025 Y155.655 I-.3 J3.87 E.0379
G2 X172.295 Y157.985 I.735 J2.353 E.09244
; WIPE_START
G1 F9547.055
M204 S8000
M73 P67 R9
G1 X170.598 Y158.045 E-.64521
G1 X170.597 Y157.999 E-.01764
G1 X170.59 Y157.79 E-.07942
G1 X170.544 Y157.79 E-.01773
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.393 Y157.23 Z20.6 F60000
G1 Z20.2
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.678884
G1 F1200
M204 S8000
G1 X171.489 Y157.121 E.00732
; LINE_WIDTH: 0.694132
G3 X171.517 Y157.069 I.05 J-.007 E.00322
; LINE_WIDTH: 0.657196
G1 X171.544 Y157.031 E.00226
; LINE_WIDTH: 0.634484
G1 X171.556 Y157.012 E.00104
; LINE_WIDTH: 0.60528
G2 X171.628 Y156.861 I-1.036 J-.592 E.00745
; LINE_WIDTH: 0.553489
G3 X172.808 Y155.306 I3.515 J1.441 E.07963
; WIPE_START
G1 F7050.956
G1 X172.415 Y155.664 E-.20508
G1 X172.12 Y156.001 E-.17243
G1 X171.899 Y156.33 E-.15265
G1 X171.628 Y156.861 E-.22984
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X174.011 Y155.168 Z20.6 F60000
G1 Z20.2
G1 E.8 F1800
; LINE_WIDTH: 0.48726
G1 F1200
M204 S8000
G3 X174.444 Y155.136 I1.027 J10.695 E.01523
G1 X185.594 Y155.128 E.39138
; WIPE_START
G1 F8101.913
G1 X183.594 Y155.129 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X176.092 Y156.534 Z20.6 F60000
G1 X171.202 Y157.45 Z20.6
G1 Z20.2
G1 E.8 F1800
; LINE_WIDTH: 0.59089
G1 F1200
M204 S8000
G1 X171.297 Y157.34 E.00631
; LINE_WIDTH: 0.634887
G1 X171.393 Y157.23 E.00681
M204 S10000
G1 X171.489 Y157.106 F60000
; LINE_WIDTH: 0.683683
G1 F1200
M204 S8000
G1 X171.454 Y157.09 E.00197
; LINE_WIDTH: 0.635242
G1 X171.419 Y157.074 E.00182
; LINE_WIDTH: 0.586801
G1 X171.383 Y157.058 E.00167
; LINE_WIDTH: 0.538361
G1 X171.348 Y157.041 E.00153
; LINE_WIDTH: 0.493534
G1 X171.258 Y157.021 E.00327
; LINE_WIDTH: 0.432014
G1 X171.169 Y157 E.00282
G1 X164.806 Y157 E.19557
; CHANGE_LAYER
; Z_HEIGHT: 20.4
; LAYER_HEIGHT: 0.199999
; WIPE_START
G1 F9252.282
G1 X166.806 Y157 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 102/165
; update layer progress
M73 L102
M991 S0 P101 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z20.6 I-.733 J.972 P1  F60000
G1 X175.503 Y163.559 Z20.6
G1 Z20.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X175.567 Y163.762 E.00685
G1 X175.491 Y163.798 E.0027
G1 X175.491 Y163.878 E.00257
G1 X175.105 Y163.843 E.01245
G1 X175.097 Y163.629 E.00689
G1 X175.443 Y163.569 E.01131
; COOLING_NODE: 0
; WIPE_START
G1 F8843.478
G1 X175.567 Y163.762 E-.12928
G1 X175.491 Y163.798 E-.04748
G1 X175.491 Y163.878 E-.04515
G1 X175.105 Y163.843 E-.21861
G1 X175.097 Y163.629 E-.12093
G1 X175.443 Y163.569 E-.19855
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X177.476 Y160.737 Z20.8 F60000
G1 Z20.4
G1 E.8 F1800
G1 F1200
M204 S8000
G1 X185.398 Y160.737 E.25475
G1 X185.398 Y161.706 E.03115
G1 X178.285 Y161.706 E.22872
G3 X177.261 Y163.225 I-4.312 J-1.801 E.0593
G3 X175.898 Y164.056 I-3.009 J-3.405 E.05161
G1 X175.898 Y164.898 E.02708
G1 X175.102 Y164.898 E.02559
G1 X175.102 Y164.251 E.02079
G3 X174.033 Y164.136 I.278 J-7.574 E.03462
G3 X172.448 Y163.403 I.72 J-3.637 E.05666
G1 X172.505 Y163.237 E.00563
G1 X174.828 Y163.237 E.07472
G2 X177.47 Y160.797 I-.085 J-2.741 E.12611
; COOLING_NODE: 0
M204 S250
G1 X177.095 Y160.345 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X185.79 Y160.345 E.25898
G1 X185.79 Y160.414 E.00204
G1 X185.79 Y160.814 E.01191
G1 X185.79 Y161.214 E.01191
G1 X185.79 Y162.098 E.02633
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X178.529 Y162.098 E.21627
G3 X176.29 Y164.304 I-3.854 J-1.673 E.09596
G1 X176.29 Y165.29 E.02938
G1 X174.71 Y165.29 E.04706
G1 X174.71 Y164.609 E.02028
G3 X171.959 Y163.497 I.082 J-4.162 E.09038
G1 X171.613 Y163.137 E.01486
G1 X171.439 Y162.914 E.00843
G1 X171.392 Y162.849 E.00239
G1 X174.413 Y162.846 E.08998
G1 X174.813 Y162.845 E.01191
G1 X175.046 Y162.827 E.00697
G2 X175.484 Y162.728 I-.344 J-2.538 E.01339
G1 X175.672 Y162.657 E.006
G1 X175.994 Y162.483 E.01089
G2 X177.098 Y160.405 I-1.296 J-2.02 E.07324
; WIPE_START
G1 F7500
M204 S8000
G1 X179.098 Y160.391 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X177.881 Y161.368 Z20.8 F60000
G1 Z20.4
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.676924
G1 F1200
M204 S8000
G3 X177.926 Y161.27 I.779 J.298 E.00542
G1 X178.043 Y161.246 E.00594
; LINE_WIDTH: 0.628217
G1 X178.159 Y161.222 E.00548
; LINE_WIDTH: 0.60433
G1 X185.194 Y161.222 E.31202
; WIPE_START
G1 F6412.425
G1 X183.194 Y161.222 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X177.881 Y161.368 Z20.8 F60000
G1 Z20.4
G1 E.8 F1800
; LINE_WIDTH: 0.639002
G1 F1200
M204 S8000
G3 X177.779 Y161.62 I-6.409 J-2.446 E.0128
; LINE_WIDTH: 0.605349
G1 X177.684 Y161.832 E.01035
G3 X175.725 Y163.587 I-3.018 J-1.397 E.12012
M204 S10000
G1 X174.897 Y163.734 F60000
; LINE_WIDTH: 0.590541
G1 F1200
M204 S8000
G1 X174.34 Y163.708 E.02414
; LINE_WIDTH: 0.560228
G1 X174.12 Y163.691 E.00899
; LINE_WIDTH: 0.529671
G1 X174.008 Y163.678 E.00435
; LINE_WIDTH: 0.503797
G1 X173.896 Y163.665 E.00412
; LINE_WIDTH: 0.478101
G1 X173.808 Y163.652 E.00303
; LINE_WIDTH: 0.452625
G1 X173.721 Y163.639 E.00285
; LINE_WIDTH: 0.424636
G1 X173.34 Y163.573 E.01168
; LINE_WIDTH: 0.394128
G1 X172.958 Y163.507 E.01075
; COOLING_NODE: 0
; WIPE_START
G1 F10250.341
G1 X173.34 Y163.573 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.669 Y157.355 Z20.8 F60000
G1 Z20.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X171.44 Y157.355 E.00736
G1 X171.434 Y157.009 E.01114
G1 X171.523 Y157.009 E.00285
G1 X171.555 Y156.952 E.00211
G1 X171.754 Y157.033 E.0069
G1 X171.684 Y157.297 E.0088
; COOLING_NODE: 0
M204 S10000
G1 X172.024 Y157.763 F60000
G1 F1200
M204 S8000
G1 X171.04 Y157.763 E.03163
G1 X171.034 Y157.398 E.01173
G1 X164.602 Y157.398 E.20681
G1 X164.602 Y156.602 E.02559
G1 X171.285 Y156.602 E.21491
G3 X172.44 Y155.102 I4.145 J1.996 E.0613
G1 X174.179 Y155.102 E.05593
G1 X174.203 Y155.319 E.00703
G2 X172.03 Y157.703 I.55 J2.685 E.11091
; COOLING_NODE: 0
M204 S250
G1 X172.405 Y158.155 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X170.655 Y158.155 E.05211
G1 X170.654 Y158.143 E.00036
G1 X170.653 Y158.086 E.00168
G1 X170.648 Y157.79 E.00883
G1 X170.248 Y157.79 E.01191
G1 X164.21 Y157.79 E.17986
G1 X164.21 Y156.21 E.04706
G1 X171.057 Y156.21 E.20394
G3 X172.309 Y154.71 I3.808 J1.906 E.05873
G1 X185.79 Y154.71 E.40155
G1 X185.79 Y155.186 E.01418
G1 X185.79 Y155.586 E.01191
G1 X185.79 Y155.655 E.00204
G1 X175.288 Y155.655 E.31281
G2 X174.137 Y155.736 I-.292 J4.05 E.0345
G2 X172.402 Y158.095 I.631 J2.282 E.09403
; WIPE_START
G1 F7500
M204 S8000
G1 X170.655 Y158.155 E-.66415
G1 X170.654 Y158.143 E-.00458
G1 X170.653 Y158.086 E-.02139
G1 X170.65 Y157.902 E-.06989
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.738 Y156.807 Z20.8 F60000
G1 Z20.4
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.597862
G1 F1200
M204 S8000
G3 X172.48 Y155.715 I3.355 J1.481 E.05819
G1 X172.617 Y155.586 E.00824
G3 X173.366 Y155.306 I11.08 J28.439 E.03505
M204 S10000
G1 X173.422 Y155.306 F60000
; LINE_WIDTH: 0.466048
G1 F1200
M204 S8000
G1 X172.044 Y155.78 E.0487
; WIPE_START
G1 F8508.081
G1 X173.422 Y155.306 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.23 Y157 Z20.8 F60000
G1 Z20.4
G1 E.8 F1800
; LINE_WIDTH: 0.43172
G1 F1200
M204 S8000
G1 X164.806 Y157 E.19731
; WIPE_START
G1 F9259.259
G1 X166.806 Y157 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X174.29 Y155.502 Z20.8 F60000
G1 X174.418 Y155.476 Z20.8
G1 Z20.4
G1 E.8 F1800
; LINE_WIDTH: 0.595476
G1 F1200
M204 S8000
G1 X174.664 Y155.183 E.01671
G1 X185.594 Y155.182 E.47709
; CHANGE_LAYER
; Z_HEIGHT: 20.6
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F6515.178
G1 X183.594 Y155.182 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 103/165
; update layer progress
M73 L103
M991 S0 P102 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z20.8 I-.857 J-.864 P1  F60000
G1 X177.716 Y161.009 Z20.8
G1 Z20.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X178.09 Y161.009 E.01204
G1 X177.768 Y161.682 E.02399
G1 X177.553 Y161.59 E.00752
G2 X177.704 Y161.068 I-2.987 J-1.15 E.01751
; COOLING_NODE: 0
; WIPE_START
G1 F8843.478
G1 X178.09 Y161.009 E-.15488
G1 X177.768 Y161.682 E-.29617
G1 X177.553 Y161.59 E-.09287
G1 X177.679 Y161.192 E-.1657
G1 X177.704 Y161.068 E-.05038
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.844 Y163.306 Z21 F60000
G1 Z20.6
G1 E.8 F1800
G1 F1200
M204 S8000
G1 X175.931 Y163.518 E.00739
G1 X175.491 Y163.73 E.01571
G1 X175.491 Y163.814 E.0027
G1 X174.718 Y163.742 E.02496
G1 X174.729 Y163.509 E.0075
G2 X175.788 Y163.326 I-.005 J-3.186 E.03473
; COOLING_NODE: 0
; WIPE_START
G1 F8843.478
G1 X175.931 Y163.518 E-.09113
G1 X175.491 Y163.73 E-.18561
G1 X175.491 Y163.814 E-.03185
G1 X174.718 Y163.742 E-.29492
G1 X174.729 Y163.509 E-.08861
G1 X174.907 Y163.499 E-.06789
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X177.35 Y160.602 Z21 F60000
G1 Z20.6
G1 E.8 F1800
G1 F1200
M204 S8000
G1 X185.398 Y160.602 E.25879
G1 X185.398 Y161.64 E.03339
G1 X178.239 Y161.641 E.2302
G3 X177.075 Y163.301 I-3.981 J-1.553 E.06585
G3 X175.898 Y163.986 I-2.961 J-3.735 E.04393
G1 X175.898 Y164.898 E.02933
G1 X175.102 Y164.898 E.02559
G1 X175.102 Y164.186 E.02288
G3 X173.922 Y164.045 I.24 J-6.991 E.03827
G3 X172.382 Y163.266 I.842 J-3.576 E.05601
G1 X172.439 Y163.102 E.00558
G1 X174.83 Y163.102 E.07688
G2 X177.347 Y160.662 I-.087 J-2.608 E.12361
; COOLING_NODE: 0
M204 S250
G1 X176.96 Y160.21 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X185.79 Y160.21 E.26302
G1 X185.79 Y160.304 E.00281
G1 X185.79 Y160.704 E.01191
G1 X185.79 Y161.104 E.01191
G1 X185.79 Y161.504 E.01191
G1 X185.79 Y162.032 E.01573
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X185.39 Y162.032 E.01191
G1 X184.99 Y162.032 E.01191
G1 X184.59 Y162.032 E.01191
G1 X178.486 Y162.033 E.18181
G3 X176.29 Y164.233 I-3.836 J-1.633 E.09489
G1 X176.29 Y165.29 E.03149
G1 X174.71 Y165.29 E.04706
G1 X174.71 Y164.544 E.02223
G3 X173.696 Y164.396 I.077 J-4.086 E.03061
G1 X173.295 Y164.261 E.01259
G1 X172.912 Y164.089 E.01252
G1 X172.549 Y163.879 E.01248
G1 X172.365 Y163.737 E.00693
G1 X172.048 Y163.493 E.01191
G1 X171.799 Y163.248 E.01041
G1 X171.442 Y162.804 E.01696
G1 X171.406 Y162.753 E.00185
G1 X171.378 Y162.71 E.00154
G1 X174.214 Y162.71 E.08448
G2 X175.407 Y162.61 I.283 J-3.794 E.03581
G2 X176.965 Y160.269 I-.718 J-2.167 E.09024
; WIPE_START
G1 F3000
M204 S8000
G1 X178.965 Y160.256 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X178.262 Y161.121 Z21 F60000
G1 Z20.6
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.674328
G1 F1200
M204 S8000
G1 X185.194 Y161.121 E.34576
; WIPE_START
M73 P67 R8
G1 F5701.544
G1 X183.194 Y161.121 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
M73 P68 R8
G1 X177.588 Y161.827 Z21 F60000
G1 Z20.6
G1 E.8 F1800
; LINE_WIDTH: 0.674156
G1 F1200
M204 S8000
G3 X176.079 Y163.341 I-3.042 J-1.524 E.10843
; WIPE_START
G1 F5703.098
G1 X176.611 Y163.005 E-.23923
G1 X176.94 Y162.723 E-.16457
G1 X177.261 Y162.353 E-.1861
G1 X177.497 Y161.973 E-.1701
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X174.483 Y163.925 Z21 F60000
G1 Z20.6
G1 E.8 F1800
; LINE_WIDTH: 0.608263
G1 F1200
M204 S8000
G1 X174.227 Y163.599 E.01849
G1 X174.028 Y163.579 E.00892
; LINE_WIDTH: 0.577736
G1 X173.924 Y163.566 E.00444
; LINE_WIDTH: 0.539847
G1 X173.754 Y163.541 E.00677
; LINE_WIDTH: 0.500137
G1 X173.327 Y163.468 E.01565
; LINE_WIDTH: 0.470624
G1 X172.9 Y163.394 E.01464
; COOLING_NODE: 0
; WIPE_START
G1 F8417.051
G1 X173.327 Y163.468 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.786 Y157.491 Z21 F60000
G1 Z20.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X171.504 Y157.491 E.00908
G1 X171.491 Y157.009 E.0155
G1 X171.593 Y157.009 E.00329
G1 X171.819 Y156.616 E.01458
G1 X172.024 Y156.714 E.00732
G2 X171.799 Y157.432 I3.896 J1.616 E.02423
; COOLING_NODE: 0
M204 S10000
G1 X172.15 Y157.898 F60000
G1 F1200
M204 S8000
G1 X171.107 Y157.898 E.03353
G1 X171.094 Y157.398 E.01609
G1 X164.602 Y157.398 E.20876
G1 X164.602 Y156.602 E.02559
G1 X171.357 Y156.602 E.21723
G3 X172.545 Y155.102 I3.906 J1.874 E.06204
G1 X185.398 Y155.102 E.41329
G1 X185.398 Y155.398 E.00952
G1 X174.673 Y155.398 E.34488
G2 X172.153 Y157.838 I.088 J2.612 E.12364
; COOLING_NODE: 0
M204 S250
G1 X172.54 Y158.29 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X170.73 Y158.29 E.05392
G1 X170.723 Y158.21 E.00239
G1 X170.723 Y158.196 E.00044
G1 X170.712 Y157.79 E.01209
G1 X170.312 Y157.79 E.01191
G1 X169.912 Y157.79 E.01191
G1 X169.512 Y157.79 E.01191
G1 X169.112 Y157.79 E.01191
G1 X168.712 Y157.79 E.01191
G1 X168.312 Y157.79 E.01191
G1 X164.21 Y157.79 E.12219
G1 X164.21 Y156.21 E.04706
G1 X171.13 Y156.21 E.20613
G3 X172.421 Y154.71 I3.73 J1.904 E.05951
G1 X183.79 Y154.71 E.33864
G1 X184.19 Y154.71 E.01191
G1 X184.59 Y154.71 E.01191
G1 X184.99 Y154.71 E.01191
G1 X185.39 Y154.71 E.01191
G1 X185.79 Y154.71 E.01191
G1 X185.79 Y155.296 E.01745
G1 X185.79 Y155.696 E.01191
G1 X185.79 Y155.79 E.00281
G1 X175.287 Y155.79 E.31285
G2 X174.172 Y155.867 I-.294 J3.864 E.03342
G2 X172.535 Y158.23 I.64 J2.192 E.09263
; WIPE_START
G1 F3000
M204 S8000
G1 X170.73 Y158.29 E-.68623
G1 X170.723 Y158.21 E-.03048
G1 X170.723 Y158.196 E-.0056
G1 X170.72 Y158.096 E-.0377
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.287 Y157 Z21 F60000
G1 Z20.6
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1200
M204 S8000
G1 X164.806 Y157 E.19906
; WIPE_START
G1 F9259.259
G1 X166.806 Y157 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.008 Y156.481 Z21 F60000
G1 Z20.6
G1 E.8 F1800
; LINE_WIDTH: 0.673663
G1 F1200
M204 S8000
G3 X173.114 Y155.306 I3.366 J2.061 E.08099
; CHANGE_LAYER
; Z_HEIGHT: 20.8
; LAYER_HEIGHT: 0.199999
; WIPE_START
G1 F5707.556
G1 X172.707 Y155.64 E-.24666
G1 X172.462 Y155.878 E-.15972
G1 X172.265 Y156.113 E-.1438
G1 X172.008 Y156.481 E-.20983
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 104/165
; update layer progress
M73 L104
M991 S0 P103 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z21 I-.751 J.958 P1  F60000
G1 X177.573 Y160.842 Z21
G1 Z20.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X184.991 Y160.842 E.23853
G1 X184.991 Y161.157 E.01013
G1 X177.922 Y161.157 E.22732
G3 X177.381 Y162.245 I-6.362 J-2.485 E.03913
G3 X176.207 Y163.3 I-2.648 J-1.764 E.05129
G1 X175.491 Y163.653 E.02567
G1 X175.491 Y163.738 E.00272
G1 X174.348 Y163.631 E.0369
G3 X173.967 Y163.56 I.531 J-3.913 E.01247
G1 X173.991 Y163.342 E.00706
G1 X174.843 Y163.342 E.02742
G2 X177.565 Y160.901 I-.099 J-2.849 E.12761
; COOLING_NODE: 0
M204 S10000
G1 X177.185 Y160.435 F60000
G1 F1200
M204 S8000
G1 X185.398 Y160.435 E.2641
G1 X185.398 Y161.564 E.03631
G1 X178.183 Y161.564 E.23201
G3 X176.929 Y163.321 I-3.866 J-1.434 E.07022
G3 X175.898 Y163.906 I-2.849 J-3.814 E.03823
G1 X175.898 Y164.898 E.03189
G1 X175.102 Y164.898 E.02559
G1 X175.102 Y164.11 E.02533
G3 X173.939 Y163.971 I.239 J-6.907 E.03771
G3 X172.129 Y162.935 I.904 J-3.679 E.06793
G1 X174.827 Y162.935 E.08675
G2 X177.185 Y160.495 I-.105 J-2.461 E.12037
; COOLING_NODE: 0
M204 S250
G1 X176.793 Y160.043 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X185.79 Y160.043 E.26799
G1 X185.79 Y160.169 E.00375
G1 X185.79 Y160.569 E.01191
G1 X185.79 Y160.969 E.01191
G1 X185.79 Y161.369 E.01191
G1 X185.79 Y161.956 E.0175
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X185.39 Y161.956 E.01191
G1 X184.99 Y161.956 E.01191
G1 X184.59 Y161.956 E.01191
G1 X178.434 Y161.956 E.18336
G3 X176.29 Y164.15 I-3.776 J-1.545 E.09368
G1 X176.29 Y165.29 E.03395
G1 X174.71 Y165.29 E.04706
G1 X174.71 Y164.468 E.0245
G3 X173.715 Y164.323 I.074 J-4.003 E.03002
G1 X173.196 Y164.138 E.01642
G1 X172.764 Y163.922 E.01438
G1 X172.42 Y163.697 E.01226
G1 X172.048 Y163.39 E.01435
G1 X171.762 Y163.094 E.01227
G1 X171.442 Y162.669 E.01585
G1 X171.394 Y162.595 E.00261
G1 X171.363 Y162.543 E.00182
G1 X174.211 Y162.543 E.08484
G2 X175.42 Y162.43 I.285 J-3.481 E.03636
G2 X176.793 Y160.561 I-.707 J-1.958 E.07327
G1 X176.793 Y160.103 E.01364
; WIPE_START
G1 F2640
M204 S8000
G1 X178.793 Y160.09 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X173.777 Y163.424 Z21.2 F60000
G1 Z20.8
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.517838
G1 F1200
M204 S8000
G1 X172.795 Y163.232 E.03754
; COOLING_NODE: 0
; WIPE_START
G1 F7580.255
G1 X173.777 Y163.424 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.93 Y157.658 Z21.2 F60000
G1 Z20.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X171.584 Y157.658 E.01111
G1 X171.567 Y157.009 E.02087
G1 X171.671 Y157.009 E.00334
G3 X172.209 Y156.127 I6.923 J3.616 E.03326
G3 X172.812 Y155.509 I2.729 J2.062 E.02783
G1 X173.058 Y155.509 E.00791
G1 X173.115 Y155.674 E.0056
G2 X171.938 Y157.598 I1.655 J2.335 E.07458
; COOLING_NODE: 0
M204 S10000
G1 X172.315 Y158.065 F60000
G1 F1200
M204 S8000
G1 X171.188 Y158.065 E.03625
G1 X171.17 Y157.398 E.02146
G1 X164.602 Y157.398 E.21121
G1 X164.602 Y156.602 E.02559
G1 X171.439 Y156.602 E.21984
G3 X172.614 Y155.147 I3.95 J1.988 E.06063
G1 X172.678 Y155.102 E.00251
G1 X185.398 Y155.102 E.40901
G1 X185.398 Y155.565 E.01489
G1 X174.675 Y155.565 E.3448
G2 X172.314 Y158.005 I.083 J2.443 E.1207
; COOLING_NODE: 0
M204 S250
G1 X172.707 Y158.457 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X170.82 Y158.457 E.05619
G1 X170.809 Y158.346 E.00332
G1 X170.808 Y158.331 E.00044
G1 X170.788 Y157.79 E.01613
G1 X170.388 Y157.79 E.01191
G1 X169.988 Y157.79 E.01191
G1 X169.588 Y157.79 E.01191
G1 X169.188 Y157.79 E.01191
G1 X168.788 Y157.79 E.01191
G1 X168.388 Y157.79 E.01191
G1 X164.21 Y157.79 E.12445
G1 X164.21 Y156.21 E.04706
G1 X171.215 Y156.21 E.20865
G3 X172.556 Y154.71 I3.587 J1.857 E.06057
G1 X183.79 Y154.71 E.33463
G1 X184.19 Y154.71 E.01191
G1 X184.59 Y154.71 E.01191
G1 X184.99 Y154.71 E.01191
G1 X185.39 Y154.71 E.01191
G1 X185.79 Y154.71 E.01191
G1 X185.79 Y155.031 E.00956
G1 X185.79 Y155.431 E.01191
G1 X185.79 Y155.831 E.01191
G1 X185.79 Y155.957 E.00375
G1 X175.29 Y155.957 E.31276
G2 X174.352 Y155.996 I-.306 J3.952 E.02804
G2 X172.707 Y157.941 I.439 J2.039 E.0816
G1 X172.707 Y158.397 E.01359
; WIPE_START
G1 F2640
M204 S8000
M73 P69 R8
G1 X170.82 Y158.457 E-.71725
G1 X170.809 Y158.346 E-.04241
G1 X170.809 Y158.345 E-.00034
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.363 Y157 Z21.2 F60000
G1 Z20.8
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1200
M204 S8000
G1 X164.806 Y157 E.2014
; WIPE_START
G1 F9259.259
G1 X166.806 Y157 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X173.278 Y155.522 Z21.2 F60000
G1 Z20.8
G1 E.8 F1800
; LINE_WIDTH: 0.321613
G1 F1200
M204 S8000
G1 X173.665 Y155.443 E.00869
; LINE_WIDTH: 0.294234
G1 X173.802 Y155.419 E.00277
; LINE_WIDTH: 0.245382
G1 X173.939 Y155.395 E.00223
; LINE_WIDTH: 0.202462
G1 X174.084 Y155.376 E.00184
; LINE_WIDTH: 0.167533
G1 X174.22 Y155.359 E.00134
; LINE_WIDTH: 0.13254
G1 X174.454 Y155.341 E.00166
; LINE_WIDTH: 0.0989673
G1 X185.194 Y155.334 E.04755
; CHANGE_LAYER
; Z_HEIGHT: 21
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F15000
G1 X183.194 Y155.335 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 105/165
; update layer progress
M73 L105
M991 S0 P104 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z21.2 I-.822 J-.898 P1  F60000
G1 X177.395 Y160.645 Z21.2
G1 Z21
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X184.991 Y160.645 E.24427
G1 X184.991 Y161.07 E.01368
G1 X177.848 Y161.069 E.2297
G3 X177.306 Y162.2 I-5.91 J-2.135 E.04038
G3 X176.179 Y163.217 I-2.567 J-1.712 E.04932
G1 X175.491 Y163.564 E.02479
G1 X175.491 Y163.65 E.00277
G1 X174.368 Y163.546 E.03626
G3 X173.598 Y163.344 I.658 J-4.074 E.02563
G1 X173.636 Y163.144 E.00652
G1 X174.839 Y163.144 E.03869
G2 X177.39 Y160.704 I-.122 J-2.681 E.12387
; COOLING_NODE: 0
M204 S10000
G1 X176.988 Y160.238 F60000
G1 F1200
M204 S8000
G1 X185.398 Y160.238 E.27045
G1 X185.398 Y161.477 E.03986
G1 X178.115 Y161.476 E.23419
G3 X176.778 Y163.325 I-3.716 J-1.281 E.07443
G3 X175.898 Y163.815 I-3.559 J-5.352 E.03242
G1 X175.898 Y164.898 E.03483
G1 X175.102 Y164.898 E.02559
G1 X175.102 Y164.023 E.02813
G3 X174.077 Y163.911 I.325 J-7.714 E.0332
G3 X172.074 Y162.737 I.726 J-3.535 E.07599
G1 X174.823 Y162.737 E.08839
G2 X176.993 Y160.297 I-.109 J-2.281 E.11696
; COOLING_NODE: 0
M204 S250
G1 X176.596 Y159.846 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X185.79 Y159.846 E.27387
G1 X185.79 Y160.002 E.00466
G1 X185.79 Y160.402 E.01191
G1 X185.79 Y160.802 E.01191
G1 X185.79 Y161.202 E.01191
G1 X185.79 Y161.602 E.01191
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X185.79 Y161.869 E.00796
G1 X185.39 Y161.869 E.01191
G1 X184.99 Y161.869 E.01191
G1 X184.59 Y161.869 E.01191
G1 X184.19 Y161.869 E.01191
G1 X178.373 Y161.868 E.17328
G3 X176.29 Y164.056 I-3.703 J-1.44 E.09229
G1 X176.29 Y165.29 E.03676
G1 X174.71 Y165.29 E.04706
G1 X174.71 Y164.38 E.0271
G3 X174.267 Y164.343 I.11 J-3.977 E.01326
G1 X173.739 Y164.235 E.01605
G1 X173.23 Y164.058 E.01604
G1 X172.752 Y163.813 E.01602
G1 X172.311 Y163.503 E.01604
G1 X172.108 Y163.326 E.00802
G1 X171.741 Y162.932 E.01603
G1 X171.44 Y162.502 E.01565
G1 X171.433 Y162.492 E.00036
G1 X171.352 Y162.345 E.00499
G1 X173.808 Y162.345 E.07314
G1 X174.208 Y162.345 E.01191
G1 X174.808 Y162.345 E.01787
G2 X175.354 Y162.244 I-.101 J-2.086 E.0166
G1 X175.532 Y162.172 E.00571
G2 X175.817 Y162.006 I-.784 J-1.675 E.00985
G2 X176.46 Y161.195 I-1.253 J-1.653 E.03116
G2 X176.572 Y160.792 I-1.933 J-.757 E.01247
G2 X176.596 Y160.504 I-1.803 J-.29 E.00862
G1 X176.596 Y159.906 E.01782
; WIPE_START
G1 F2280
M204 S8000
G1 X178.595 Y159.892 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X177.646 Y160.848 Z21.4 F60000
G1 Z21
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.156939
G1 F1200
M204 S8000
G1 X177.616 Y160.959 E.00103
; LINE_WIDTH: 0.12714
G1 X177.554 Y161.157 E.00138
; LINE_WIDTH: 0.101002
G1 X177.526 Y161.236 E.00039
; WIPE_START
G1 F15000
G1 X177.554 Y161.157 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X174.912 Y163.367 Z21.4 F60000
G1 Z21
G1 E.8 F1800
; LINE_WIDTH: 0.111556
G1 F1200
M204 S8000
G1 X175.11 Y163.369 E.00108
; LINE_WIDTH: 0.153811
G2 X175.406 Y163.324 I.009 J-.938 E.00263
; LINE_WIDTH: 0.119063
G1 X175.653 Y163.227 E.0016
M204 S10000
G1 X175.5 Y163.856 F60000
; LINE_WIDTH: 0.431733
G1 F1200
M204 S8000
G1 X175.5 Y164.694 E.02575
; COOLING_NODE: 0
; WIPE_START
G1 F9258.967
G1 X175.5 Y163.856 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.111 Y157.855 Z21.4 F60000
G1 Z21
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X171.677 Y157.855 E.01398
G1 X171.654 Y157.009 E.02722
G1 X171.762 Y157.009 E.00345
G3 X172.276 Y156.182 I6.997 J3.784 E.03134
G3 X172.959 Y155.509 I2.542 J1.893 E.03094
G1 X173.412 Y155.509 E.01459
G1 X173.464 Y155.684 E.00585
G2 X172.116 Y157.796 I1.361 J2.356 E.08374
; COOLING_NODE: 0
M204 S10000
G1 X172.513 Y158.262 F60000
G1 F1200
M204 S8000
G1 X171.28 Y158.262 E.03963
G1 X171.257 Y157.398 E.02781
G1 X164.602 Y157.398 E.21401
G1 X164.602 Y156.602 E.02559
G1 X171.533 Y156.602 E.22287
G3 X172.766 Y155.145 I3.787 J1.955 E.06193
G1 X172.832 Y155.102 E.00252
G1 X185.398 Y155.102 E.40406
G1 X185.398 Y155.762 E.02123
G1 X174.737 Y155.762 E.34282
G2 X172.507 Y158.203 I.034 J2.27 E.11906
; COOLING_NODE: 0
M204 S250
G1 X172.905 Y158.654 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X170.938 Y158.654 E.05858
G1 X170.929 Y158.607 E.00144
G1 X170.914 Y158.498 E.00327
G1 X170.892 Y158.099 E.01191
G1 X170.875 Y157.79 E.00921
G1 X170.475 Y157.79 E.01191
G1 X170.075 Y157.79 E.01191
G1 X169.675 Y157.79 E.01191
G1 X169.275 Y157.79 E.01191
G1 X168.875 Y157.79 E.01191
G1 X168.475 Y157.79 E.01191
G1 X164.21 Y157.79 E.12705
G1 X164.21 Y156.21 E.04706
G1 X171.313 Y156.21 E.21156
G3 X172.717 Y154.71 I3.683 J2.04 E.06183
G1 X183.79 Y154.71 E.32983
G1 X184.19 Y154.71 E.01191
G1 X184.59 Y154.71 E.01191
G1 X184.99 Y154.71 E.01191
G1 X185.39 Y154.71 E.01191
G1 X185.79 Y154.71 E.01191
G1 X185.79 Y155.198 E.01454
G1 X185.79 Y155.598 E.01191
G1 X185.79 Y155.998 E.01191
G1 X185.79 Y156.154 E.00466
G1 X175.145 Y156.154 E.31706
G1 X174.745 Y156.154 E.01191
G2 X174.393 Y156.189 I.001 J1.822 E.01055
G2 X173.489 Y156.652 I.387 J1.869 E.03064
G1 X173.359 Y156.787 E.00557
G2 X173.224 Y156.962 I1.408 J1.227 E.00658
G2 X172.905 Y157.969 I1.709 J1.096 E.03186
G1 X172.905 Y158.594 E.01862
; WIPE_START
G1 F2280
M204 S8000
G1 X170.938 Y158.654 E-.74773
G1 X170.932 Y158.623 E-.01227
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.899 Y157.646 Z21.4 F60000
G1 Z21
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.11787
G1 F1200
M204 S8000
G1 X171.916 Y157.397 E.00148
; LINE_WIDTH: 0.160789
G3 X171.977 Y157.147 I.727 J.044 E.00241
G1 X171.979 Y157.142 E.00004
; LINE_WIDTH: 0.121351
G1 X172.095 Y156.9 E.00166
M204 S10000
G1 X171.45 Y157 F60000
; LINE_WIDTH: 0.43172
G1 F1200
M204 S8000
G1 X164.806 Y157 E.20408
; WIPE_START
G1 F9259.259
G1 X166.806 Y157 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X173.636 Y155.548 Z21.4 F60000
G1 Z21
G1 E.8 F1800
; LINE_WIDTH: 0.436016
G1 F1200
M204 S8000
G1 X173.968 Y155.491 E.01044
; LINE_WIDTH: 0.396034
G1 X174.112 Y155.473 E.00405
; LINE_WIDTH: 0.361894
G1 X174.24 Y155.457 E.00326
; LINE_WIDTH: 0.297021
G3 X174.509 Y155.437 I.501 J5.025 E.00541
G1 X185.194 Y155.432 E.21448
; CHANGE_LAYER
; Z_HEIGHT: 21.2
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F14167.62
G1 X183.194 Y155.433 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 106/165
; update layer progress
M73 L106
M991 S0 P105 ;notify layer change

M106 S226.95
; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z21.4 I-.859 J-.862 P1  F60000
G1 X176.826 Y161.782 Z21.4
G1 Z21.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1246
M204 S8000
G1 X176.864 Y161.724 E.00222
G2 X177.193 Y160.445 I-2.118 J-1.226 E.04302
G1 X184.991 Y160.445 E.25076
G1 X184.991 Y160.971 E.01691
G1 X177.766 Y160.97 E.23232
G3 X177.332 Y161.968 I-6.365 J-2.172 E.03504
G3 X176.181 Y163.103 I-2.661 J-1.547 E.05263
G1 X175.491 Y163.461 E.02498
G1 X175.491 Y163.547 E.00278
G3 X174.337 Y163.442 I.876 J-15.892 E.03728
G3 X173.378 Y163.133 I.45 J-3.042 E.03253
G1 X173.422 Y162.944 E.00624
G1 X174.841 Y162.944 E.04566
G2 X176.591 Y162.106 I-.096 J-2.446 E.06415
G1 X176.791 Y161.83 E.01093
; COOLING_NODE: 0
M204 S10000
G1 X176.505 Y161.518 F60000
G1 F1246
M204 S8000
G1 X176.595 Y161.35 E.00612
G2 X176.785 Y160.605 I-1.871 J-.876 E.02487
G1 X176.786 Y160.038 E.01824
G1 X185.398 Y160.038 E.27691
G1 X185.398 Y161.378 E.04309
G1 X178.04 Y161.377 E.23662
G3 X176.676 Y163.275 I-3.61 J-1.154 E.07638
G3 X175.898 Y163.708 I-3.173 J-4.779 E.02869
G1 X175.898 Y164.898 E.03825
G1 X175.102 Y164.898 E.02559
G1 X175.102 Y163.922 E.03139
G3 X173.587 Y163.671 I.123 J-5.444 E.04955
G3 X172.053 Y162.537 I1.305 J-3.369 E.06206
G1 X174.824 Y162.537 E.08908
G2 X176.397 Y161.685 I-.1 J-2.064 E.05951
G1 X176.473 Y161.568 E.00447
; COOLING_NODE: 0
M204 S250
G1 X176.357 Y160.818 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
M106 S229.5
G1 F1246
M204 S5000
G1 X176.393 Y160.587 E.00697
G1 X176.395 Y159.646 E.02805
G1 X185.79 Y159.646 E.27984
M106 S226.95
M106 S229.5
G1 X185.79 Y159.805 E.00474
M106 S226.95
G1 X185.79 Y160.205 E.01191
G1 X185.79 Y160.605 E.01191
M73 P70 R8
G1 X185.79 Y161.005 E.01191
G1 X185.79 Y161.405 E.01191
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X185.79 Y161.77 E.01088
G1 X185.39 Y161.77 E.01191
G1 X184.99 Y161.77 E.01191
G1 X184.59 Y161.77 E.01191
G1 X178.303 Y161.769 E.18728
G3 X176.29 Y163.947 I-3.625 J-1.331 E.09066
G1 X176.29 Y165.29 E.04001
G1 X174.71 Y165.29 E.04706
G1 X174.71 Y164.28 E.03007
G3 X174.216 Y164.235 I.102 J-3.859 E.01479
G1 X173.702 Y164.121 E.01568
G1 X173.209 Y163.941 E.01562
G1 X172.747 Y163.694 E.01562
G1 X172.323 Y163.385 E.01562
G1 X171.946 Y163.02 E.01562
G1 X171.624 Y162.607 E.01562
G1 X171.442 Y162.304 E.0105
M106 S229.5
G1 X171.361 Y162.151 E.00518
M106 S226.95
M106 S229.5
G1 X171.358 Y162.145 E.00018
M106 S226.95
M106 S229.5
G1 X174.207 Y162.145 E.08484
G2 X174.981 Y162.13 I.299 J-4.465 E.02308
G2 X176.338 Y160.927 I-.236 J-1.635 E.0572
G1 X176.347 Y160.877 E.00149
M106 S226.95
; WIPE_START
G1 F2160
M204 S8000
G1 X176.393 Y160.587 E-.11173
G1 X176.395 Y159.646 E-.35784
G1 X177.159 Y159.646 E-.29043
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X177.382 Y160.79 Z21.6 F60000
G1 Z21.2
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.20058
G1 F1246
M204 S8000
G1 X177.506 Y160.749 E.00163
; LINE_WIDTH: 0.17402
G1 X177.63 Y160.707 E.00135
; LINE_WIDTH: 0.161232
G1 X184.787 Y160.708 E.06689
; WIPE_START
G1 F15000
G1 X182.787 Y160.707 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X177.531 Y160.648 Z21.6 F60000
G1 Z21.2
G1 E.8 F1800
; LINE_WIDTH: 0.267487
G1 F1246
M204 S8000
G1 X177.484 Y160.842 E.00353
; LINE_WIDTH: 0.233401
G1 X177.432 Y161.026 E.00288
; LINE_WIDTH: 0.176538
G1 X177.229 Y161.588 E.0063
; LINE_WIDTH: 0.162524
G1 X177.209 Y161.635 E.00048
G3 X175.678 Y163.056 I-2.521 J-1.18 E.02023
; LINE_WIDTH: 0.194757
G1 X175.549 Y163.109 E.00167
; LINE_WIDTH: 0.220875
G1 X175.411 Y163.165 E.0021
; LINE_WIDTH: 0.252562
G3 X175.129 Y163.217 I-.279 J-.719 E.00478
; LINE_WIDTH: 0.205641
G1 X174.85 Y163.217 E.00358
; LINE_WIDTH: 0.160126
G3 X174.375 Y163.194 I.379 J-13.026 E.00441
; LINE_WIDTH: 0.115794
G1 X174.132 Y163.171 E.0014
; WIPE_START
G1 F15000
G1 X174.375 Y163.194 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.5 Y163.753 Z21.6 F60000
G1 Z21.2
G1 E.8 F1800
; LINE_WIDTH: 0.43173
G1 F1246
M204 S8000
G1 X175.5 Y164.694 E.02892
; COOLING_NODE: 0
; WIPE_START
G1 F9259.021
G1 X175.5 Y163.753 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.351 Y157.577 Z21.6 F60000
G1 Z21.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1246
M204 S8000
G1 X172.312 Y157.794 E.00708
G2 X172.302 Y158.055 I2.457 J.226 E.00843
G1 X171.782 Y158.055 E.01673
G1 X171.745 Y157.009 E.03366
G1 X171.876 Y157.009 E.00422
G3 X172.553 Y156.001 I5.01 J2.633 E.03911
G3 X173.135 Y155.509 I2.87 J2.803 E.02454
G1 X173.868 Y155.509 E.02357
G1 X173.905 Y155.708 E.00651
G2 X172.39 Y157.365 I.864 J2.311 E.07498
G1 X172.362 Y157.518 E.00498
; COOLING_NODE: 0
M204 S10000
G1 X172.74 Y157.673 F60000
G1 F1246
M204 S8000
G1 X172.712 Y157.987 E.01014
G1 X172.712 Y158.462 E.01527
G1 X171.405 Y158.462 E.04205
G3 X171.351 Y157.398 I7.564 J-.912 E.0343
G1 X164.602 Y157.398 E.21704
G1 X164.602 Y156.602 E.02559
G1 X171.647 Y156.602 E.22655
G3 X173.017 Y155.102 I3.476 J1.799 E.06608
G1 X185.398 Y155.102 E.39811
G1 X185.398 Y155.962 E.02767
G1 X174.735 Y155.962 E.34289
G2 X172.752 Y157.614 I.032 J2.055 E.08973
; COOLING_NODE: 0
M204 S250
G1 X173.111 Y157.927 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
M106 S229.5
G1 F1246
M204 S5000
G1 X173.104 Y157.996 E.00207
G1 X173.104 Y158.854 E.02558
G1 X171.08 Y158.854 E.06031
M106 S226.95
M106 S229.5
G1 X171.063 Y158.786 E.00211
M106 S226.95
M106 S229.5
G1 X171.047 Y158.695 E.00273
M106 S226.95
G1 X170.989 Y158.264 E.01298
G1 X170.973 Y157.79 E.01412
G1 X170.573 Y157.79 E.01191
G1 X170.173 Y157.79 E.01191
G1 X169.773 Y157.79 E.01191
G1 X169.373 Y157.79 E.01191
G1 X168.973 Y157.79 E.01191
G1 X164.21 Y157.79 E.14187
G1 X164.21 Y156.21 E.04706
G1 X171.427 Y156.21 E.21497
G3 X172.912 Y154.71 I3.39 J1.871 E.06368
G1 X183.79 Y154.71 E.32401
G1 X184.19 Y154.71 E.01191
G1 X184.59 Y154.71 E.01191
G1 X184.99 Y154.71 E.01191
G1 X185.39 Y154.71 E.01191
G1 X185.79 Y154.71 E.01191
G1 X185.79 Y154.995 E.0085
G1 X185.79 Y155.395 E.01191
G1 X185.79 Y155.795 E.01191
G1 X185.79 Y156.195 E.01191
M106 S229.5
G1 X185.79 Y156.354 E.00474
M106 S226.95
M106 S229.5
G1 X175.345 Y156.354 E.31113
G2 X174.33 Y156.409 I-.299 J3.906 E.03035
G2 X173.13 Y157.714 I.422 J1.593 E.05576
G1 X173.116 Y157.867 E.00459
M106 S226.95
; WIPE_START
G1 F2160
M204 S8000
G1 X173.104 Y157.996 E-.04916
G1 X173.104 Y158.854 E-.32631
G1 X172.093 Y158.854 E-.38453
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.043 Y157.852 Z21.6 F60000
G1 Z21.2
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.192429
G1 F1246
M204 S8000
G1 X172.054 Y157.528 E.00382
; LINE_WIDTH: 0.232586
G1 X172.065 Y157.407 E.00183
; LINE_WIDTH: 0.262526
G1 X172.076 Y157.293 E.00198
; LINE_WIDTH: 0.257278
G1 X172.133 Y157.169 E.00231
; LINE_WIDTH: 0.227214
G1 X172.18 Y157.067 E.00164
; LINE_WIDTH: 0.19551
G1 X172.285 Y156.858 E.00282
; LINE_WIDTH: 0.160814
G3 X173.233 Y155.765 I2.504 J1.214 E.01363
G1 X173.345 Y155.73 E.00109
M204 S10000
G1 X174.086 Y155.568 F60000
; LINE_WIDTH: 0.497214
G1 F1246
M204 S8000
G3 X174.718 Y155.532 I.706 J6.817 E.02272
G1 X185.194 Y155.532 E.37595
; WIPE_START
G1 F7924.394
G1 X183.194 Y155.532 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.622 Y156.486 Z21.6 F60000
G1 X171.541 Y157 Z21.6
G1 Z21.2
G1 E.8 F1800
; LINE_WIDTH: 0.43172
G1 F1246
M204 S8000
G1 X164.806 Y157 E.20686
; CHANGE_LAYER
; Z_HEIGHT: 21.4
; LAYER_HEIGHT: 0.199999
; WIPE_START
G1 F9259.259
G1 X166.806 Y157 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 107/165
; update layer progress
M73 L107
M991 S0 P106 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z21.6 I-.527 J1.097 P1  F60000
G1 X176.632 Y161.722 Z21.6
G1 Z21.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1319
M204 S8000
G1 X176.733 Y161.554 E.00628
G2 X176.994 Y160.245 I-1.998 J-1.079 E.04359
G1 X184.991 Y160.245 E.25715
G1 X184.991 Y160.858 E.01974
G1 X177.683 Y160.858 E.235
G3 X177.213 Y161.951 I-6.673 J-2.221 E.03832
G3 X176.17 Y162.981 I-2.483 J-1.472 E.04765
G1 X175.491 Y163.347 E.0248
G1 X175.491 Y163.435 E.00284
G3 X174.353 Y163.331 I.869 J-15.72 E.03676
G3 X173.237 Y162.923 I.419 J-2.877 E.03847
G1 X173.287 Y162.744 E.00597
G1 X174.837 Y162.744 E.04986
G2 X176.599 Y161.772 I-.102 J-2.269 E.06704
; COOLING_NODE: 0
M204 S10000
G1 X176.292 Y161.494 F60000
G1 F1319
M204 S8000
G1 X176.448 Y161.186 E.01111
G2 X176.587 Y160.573 I-1.724 J-.713 E.02032
G1 X176.587 Y159.838 E.02364
G1 X185.398 Y159.838 E.28332
G1 X185.398 Y161.266 E.04592
G1 X177.959 Y161.265 E.2392
G3 X177.082 Y162.786 I-3.79 J-1.172 E.05692
G3 X175.898 Y163.59 I-2.841 J-2.91 E.04628
G1 X175.898 Y164.898 E.04207
G1 X175.102 Y164.898 E.02559
G1 X175.102 Y163.809 E.03501
G3 X173.626 Y163.566 I.117 J-5.309 E.04825
G3 X172.045 Y162.337 I1.179 J-3.151 E.0654
G1 X174.819 Y162.337 E.08923
G2 X176.254 Y161.541 I-.096 J-1.863 E.05463
; COOLING_NODE: 0
M204 S250
G1 X176.15 Y160.829 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
M106 S229.5
G1 F1310
M204 S5000
G1 X176.177 Y160.726 E.00319
G2 X176.195 Y160.554 I-1.434 J-.231 E.00515
G1 X176.195 Y159.446 E.03301
G1 X185.79 Y159.446 E.28579
M106 S226.95
M106 S229.5
G1 X185.79 Y159.605 E.00474
M106 S226.95
G1 X185.79 Y160.005 E.01191
G1 X185.79 Y160.405 E.01191
G1 X185.79 Y160.805 E.01191
G1 X185.79 Y161.205 E.01191
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X185.79 Y161.658 E.0135
G1 X185.39 Y161.658 E.01191
G1 X184.99 Y161.658 E.01191
G1 X184.59 Y161.658 E.01191
G1 X178.225 Y161.657 E.18958
G3 X176.29 Y163.824 I-3.557 J-1.229 E.08885
G1 X176.29 Y165.29 E.04367
G1 X174.71 Y165.29 E.04706
G1 X174.71 Y164.168 E.03342
G3 X174.232 Y164.125 I.096 J-3.735 E.01432
G1 X173.733 Y164.013 E.01522
G1 X173.254 Y163.838 E.01519
G1 X172.753 Y163.564 E.01702
G1 X172.345 Y163.256 E.0152
G1 X172.03 Y162.945 E.01321
G1 X171.79 Y162.648 E.01137
G1 X171.647 Y162.436 E.0076
G1 X171.465 Y162.104 E.01128
M106 S229.5
G1 X171.391 Y161.945 E.00523
M106 S226.95
M106 S229.5
G1 X174.202 Y161.945 E.08375
G2 X174.952 Y161.932 I.299 J-4.305 E.02236
G2 X176.089 Y161.041 I-.208 J-1.437 E.04503
G1 X176.133 Y160.887 E.00478
M106 S226.95
; WIPE_START
G1 F2160
M204 S8000
G1 X176.177 Y160.726 E-.06346
G1 X176.195 Y160.554 E-.06565
G1 X176.195 Y159.446 E-.42111
G1 X176.747 Y159.446 E-.20978
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X177.209 Y161.206 Z21.8 F60000
G1 Z21.4
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.250584
G1 F1319
M204 S8000
G1 X177.106 Y161.48 E.00481
G3 X175.663 Y162.894 I-2.414 J-1.02 E.03402
; LINE_WIDTH: 0.292425
G1 X175.421 Y162.998 E.0052
; LINE_WIDTH: 0.337637
G1 X175.406 Y163.004 E.00037
G3 X175.108 Y163.061 I-.293 J-.728 E.00712
; LINE_WIDTH: 0.290966
G1 X174.846 Y163.06 E.00513
; LINE_WIDTH: 0.2482
G3 X174.397 Y163.039 I.365 J-12.447 E.00728
; LINE_WIDTH: 0.208695
G1 X174.206 Y163.022 E.00251
; LINE_WIDTH: 0.169352
G1 X174.027 Y163 E.00181
; LINE_WIDTH: 0.134495
G1 X173.935 Y162.985 E.00067
; LINE_WIDTH: 0.109438
G1 X173.843 Y162.97 E.00049
; WIPE_START
G1 F15000
G1 X173.935 Y162.985 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.5 Y163.64 Z21.8 F60000
G1 Z21.4
G1 E.8 F1800
; LINE_WIDTH: 0.43173
G1 F1319
M204 S8000
G1 X175.5 Y164.694 E.03238
; WIPE_START
G1 F9259.021
G1 X175.5 Y163.64 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X177.209 Y161.206 Z21.8 F60000
G1 Z21.4
G1 E.8 F1800
; LINE_WIDTH: 0.283489
G1 F1319
M204 S8000
G2 X177.3 Y160.912 I-5.071 J-1.724 E.00585
; LINE_WIDTH: 0.329143
G1 X177.337 Y160.759 E.00355
; LINE_WIDTH: 0.370906
G1 X177.37 Y160.622 E.00365
M204 S10000
G1 X177.205 Y160.448 F60000
; LINE_WIDTH: 0.367352
G1 F1319
M204 S8000
G1 X177.37 Y160.622 E.00615
G1 X177.405 Y160.599 E.00107
; LINE_WIDTH: 0.319855
G1 X177.475 Y160.575 E.00161
; LINE_WIDTH: 0.272405
G1 X177.545 Y160.551 E.00134
; LINE_WIDTH: 0.249118
G1 X184.787 Y160.552 E.11797
; COOLING_NODE: 0
; WIPE_START
G1 F15000
G1 X182.787 Y160.551 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.472 Y158.373 Z21.8 F60000
G1 X172.566 Y157.508 Z21.8
G1 Z21.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1319
M204 S8000
G1 X172.523 Y157.688 E.00597
G2 X172.507 Y158.255 I2.257 J.351 E.01829
G1 X171.898 Y158.255 E.01956
G1 X171.866 Y157.009 E.04009
G1 X171.995 Y157.009 E.00416
G3 X172.775 Y155.934 I4.455 J2.409 E.04282
G3 X173.347 Y155.509 I2.903 J3.313 E.02295
G1 X184.991 Y155.509 E.37442
G1 X184.991 Y155.755 E.00792
G1 X174.727 Y155.755 E.33004
G2 X172.606 Y157.341 I.053 J2.283 E.09084
G1 X172.58 Y157.449 E.00358
; COOLING_NODE: 0
M204 S10000
G1 X172.953 Y157.622 F60000
G1 F1319
M204 S8000
M73 P71 R8
G1 X172.914 Y157.907 E.00923
G1 X172.913 Y158.662 E.02431
G1 X171.554 Y158.662 E.04369
G3 X171.489 Y158.173 I3.739 J-.748 E.01587
G1 X171.469 Y157.398 E.02495
G1 X164.602 Y157.398 E.22081
G1 X164.602 Y156.602 E.02559
G1 X171.771 Y156.602 E.23053
G3 X173.131 Y155.164 I3.347 J1.804 E.06438
G1 X173.244 Y155.102 E.00415
G1 X185.398 Y155.102 E.39083
G1 X185.398 Y156.162 E.0341
G1 X174.736 Y156.162 E.34283
G2 X172.965 Y157.564 I.016 J1.841 E.07819
; COOLING_NODE: 0
M204 S250
G1 X173.306 Y157.933 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
M106 S229.5
G1 F1310
M204 S5000
G1 X173.305 Y159.054 E.03341
G1 X171.249 Y159.054 E.06125
M106 S226.95
M106 S229.5
G1 X171.235 Y159.011 E.00136
M106 S226.95
M106 S229.5
G1 X171.205 Y158.895 E.00356
M106 S226.95
G1 X171.138 Y158.573 E.0098
G1 X171.106 Y158.318 E.00767
G1 X171.087 Y157.79 E.01574
G1 X170.687 Y157.79 E.01191
G1 X170.287 Y157.79 E.01191
G1 X169.887 Y157.79 E.01191
G1 X169.487 Y157.79 E.01191
G1 X169.087 Y157.79 E.01191
G1 X164.21 Y157.79 E.14527
G1 X164.21 Y156.21 E.04706
G1 X171.555 Y156.21 E.21878
G3 X173.154 Y154.71 I3.255 J1.867 E.06626
G1 X184.19 Y154.71 E.32873
G1 X184.59 Y154.71 E.01191
G1 X184.99 Y154.71 E.01191
G1 X185.39 Y154.71 E.01191
G1 X185.79 Y154.71 E.01191
G1 X185.79 Y155.195 E.01446
G1 X185.79 Y155.595 E.01191
G1 X185.79 Y155.995 E.01191
G1 X185.79 Y156.395 E.01191
M106 S229.5
G1 X185.79 Y156.554 E.00474
M106 S226.95
M106 S229.5
G1 X175.345 Y156.554 E.31111
G2 X174.473 Y156.581 I-.3 J4.51 E.02603
G2 X173.31 Y157.873 I.286 J1.427 E.0555
M106 S226.95
; WIPE_START
G1 F2160
M204 S8000
G1 X173.305 Y159.054 E-.44897
G1 X172.486 Y159.054 E-.31103
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.2 Y158.052 Z21.8 F60000
G1 Z21.4
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.261444
G1 F1319
M204 S8000
G1 X172.206 Y157.649 E.00696
; LINE_WIDTH: 0.303443
G1 X172.222 Y157.435 E.00442
; LINE_WIDTH: 0.345998
G3 X172.241 Y157.297 I1.467 J.132 E.00332
G1 X172.27 Y157.231 E.00174
; LINE_WIDTH: 0.312768
G1 X172.367 Y157.032 E.00472
; LINE_WIDTH: 0.252198
G3 X173.391 Y155.84 I2.529 J1.139 E.02633
G1 X173.61 Y155.713 E.00419
; WIPE_START
G1 F15000
G1 X173.391 Y155.84 E-.10457
G1 X173.044 Y156.103 E-.17946
G1 X172.83 Y156.32 E-.12551
G1 X172.62 Y156.597 E-.1432
G1 X172.367 Y157.032 E-.20725
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.662 Y157 Z21.8 F60000
G1 Z21.4
G1 E.8 F1800
; LINE_WIDTH: 0.43172
G1 F1319
M204 S8000
G1 X164.806 Y157 E.21058
; CHANGE_LAYER
; Z_HEIGHT: 21.6
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F9259.259
G1 X166.806 Y157 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 108/165
; update layer progress
M73 L108
M991 S0 P107 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z21.8 I-.532 J1.094 P1  F60000
G1 X176.418 Y161.673 Z21.8
G1 Z21.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1336
M204 S8000
G1 X176.604 Y161.364 E.01159
G2 X176.795 Y160.549 I-1.853 J-.863 E.0271
G1 X176.795 Y160.045 E.01623
G1 X184.991 Y160.045 E.26356
G1 X184.991 Y160.732 E.02211
G1 X177.582 Y160.732 E.23825
G3 X177.171 Y161.767 I-7.595 J-2.416 E.03585
G3 X176.148 Y162.848 I-2.469 J-1.313 E.04842
G1 X175.491 Y163.217 E.02423
G1 X175.491 Y163.309 E.00297
G3 X174.37 Y163.206 I.877 J-15.639 E.0362
G3 X173.153 Y162.721 I.499 J-3.025 E.04246
G1 X173.204 Y162.544 E.00591
G1 X174.833 Y162.544 E.0524
G2 X176.375 Y161.743 I-.082 J-2.042 E.05772
G1 X176.387 Y161.724 E.00069
; COOLING_NODE: 0
M204 S10000
G1 X176.073 Y161.46 F60000
G1 F1336
M204 S8000
G1 X176.228 Y161.189 E.01003
G2 X176.387 Y160.536 I-1.503 J-.714 E.02178
G1 X176.388 Y159.638 E.02888
G1 X185.398 Y159.638 E.28974
G1 X185.398 Y161.139 E.04829
G1 X177.863 Y161.139 E.24228
G3 X177.136 Y162.54 I-4.155 J-1.267 E.05103
G3 X175.898 Y163.455 I-2.839 J-2.547 E.04986
G1 X175.898 Y164.898 E.04641
G1 X175.102 Y164.898 E.02559
G1 X175.102 Y163.683 E.03907
G3 X173.618 Y163.428 I.104 J-5.053 E.0486
G3 X172.062 Y162.137 I1.171 J-2.995 E.06612
G1 X174.814 Y162.137 E.0885
G2 X176.033 Y161.504 I-.09 J-1.662 E.04551
; COOLING_NODE: 0
M204 S250
G1 X175.951 Y160.818 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
M106 S229.5
G1 F1336
M204 S5000
G1 X175.963 Y160.78 E.00118
G2 X175.995 Y160.522 I-1.219 J-.286 E.00776
G1 X175.996 Y159.246 E.03803
G1 X185.79 Y159.246 E.29174
M106 S226.95
M106 S229.5
G1 X185.79 Y159.405 E.00474
M106 S226.95
G1 X185.79 Y159.805 E.01191
G1 X185.79 Y160.205 E.01191
G1 X185.79 Y160.605 E.01191
G1 X185.79 Y161.005 E.01191
G1 X185.79 Y161.531 E.0157
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X185.39 Y161.531 E.01191
G1 X184.99 Y161.531 E.01191
G1 X184.59 Y161.531 E.01191
G1 X178.135 Y161.531 E.19228
G3 X176.29 Y163.684 I-3.472 J-1.107 E.08674
G1 X176.29 Y165.29 E.04783
G1 X174.71 Y165.29 E.04706
M73 P71 R7
G1 X174.71 Y164.041 E.03719
G3 X174.249 Y164.003 I.066 J-3.561 E.0138
G1 X173.711 Y163.875 E.01646
G1 X173.25 Y163.697 E.01472
G1 X172.769 Y163.424 E.01647
G1 X172.337 Y163.079 E.01647
G1 X171.966 Y162.672 E.01641
G1 X171.691 Y162.264 E.01466
G1 X171.512 Y161.904 E.01196
M106 S229.5
G1 X171.453 Y161.765 E.00452
M106 S226.95
M106 S229.5
G1 X171.446 Y161.745 E.00061
M106 S226.95
M106 S229.5
G1 X174.196 Y161.745 E.08192
G2 X174.937 Y161.732 I.299 J-3.983 E.0221
G2 X175.878 Y161.026 I-.193 J-1.237 E.03647
G1 X175.931 Y160.875 E.00477
M106 S226.95
; WIPE_START
G1 F2160
M204 S8000
G1 X175.963 Y160.78 E-.03789
G1 X175.995 Y160.522 E-.09887
G1 X175.996 Y159.246 E-.48511
G1 X176.359 Y159.246 E-.13813
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X177.086 Y161.048 Z22 F60000
G1 Z21.6
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.324936
G1 F1336
M204 S8000
G1 X177.007 Y161.285 E.00557
G3 X175.608 Y162.743 I-2.325 J-.83 E.04637
; LINE_WIDTH: 0.370582
G1 X175.384 Y162.841 E.00632
; LINE_WIDTH: 0.411928
G1 X175.366 Y162.849 E.00056
G3 X175.102 Y162.897 I-.256 J-.656 E.00787
; LINE_WIDTH: 0.364418
G1 X174.843 Y162.897 E.00659
; LINE_WIDTH: 0.322308
G3 X174.42 Y162.877 I.345 J-11.693 E.00934
; LINE_WIDTH: 0.284726
G1 X174.237 Y162.86 E.00352
; LINE_WIDTH: 0.255851
G1 X174.138 Y162.848 E.00166
; LINE_WIDTH: 0.230805
G1 X174.04 Y162.835 E.00147
; LINE_WIDTH: 0.202953
G1 X173.862 Y162.805 E.00228
; LINE_WIDTH: 0.17233
G1 X173.684 Y162.775 E.00185
; WIPE_START
G1 F15000
G1 X173.862 Y162.805 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.5 Y163.514 Z22 F60000
G1 Z21.6
G1 E.8 F1800
; LINE_WIDTH: 0.43173
G1 F1336
M204 S8000
G1 X175.5 Y164.694 E.03625
; WIPE_START
G1 F9259.021
G1 X175.5 Y163.514 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X177.086 Y161.048 Z22 F60000
G1 Z21.6
G1 E.8 F1800
; LINE_WIDTH: 0.364269
G1 F1336
M204 S8000
G1 X177.153 Y160.804 E.00643
; LINE_WIDTH: 0.405464
G1 X177.181 Y160.678 E.00369
; LINE_WIDTH: 0.440108
G1 X177.204 Y160.57 E.00345
; LINE_WIDTH: 0.473694
G1 X177.222 Y160.472 E.00339
G1 X177.247 Y160.455 E.00102
; LINE_WIDTH: 0.43486
G1 X177.312 Y160.433 E.00212
; LINE_WIDTH: 0.39014
G1 X177.376 Y160.411 E.00188
; LINE_WIDTH: 0.34542
G1 X177.441 Y160.388 E.00163
; LINE_WIDTH: 0.323272
G1 X184.787 Y160.388 E.16269
; COOLING_NODE: 0
; WIPE_START
G1 F12841.017
G1 X182.787 Y160.388 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.423 Y158.384 Z22 F60000
G1 X172.747 Y157.655 Z22
G1 Z21.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1336
M204 S8000
G1 X172.706 Y157.928 E.00888
G1 X172.706 Y158.455 E.01694
G1 X172.057 Y158.455 E.02088
G3 X172.022 Y158.147 I2.816 J-.474 E.00998
G1 X171.992 Y157.009 E.03661
G1 X172.121 Y157.009 E.00415
G3 X172.698 Y156.197 I5.328 J3.171 E.03207
G3 X173.631 Y155.509 I2.135 J1.92 E.03753
G1 X184.991 Y155.509 E.3653
G1 X184.991 Y155.955 E.01435
G1 X174.724 Y155.955 E.33015
G2 X172.774 Y157.473 I.026 J2.044 E.08533
G1 X172.755 Y157.596 E.00398
; COOLING_NODE: 0
M204 S10000
G1 X173.147 Y157.717 F60000
G1 F1336
M204 S8000
G1 X173.113 Y157.943 E.00733
G1 X173.113 Y158.862 E.02957
G1 X171.73 Y158.862 E.04446
G3 X171.615 Y158.167 I3.307 J-.904 E.02271
G1 X171.595 Y157.398 E.02473
G1 X164.602 Y157.398 E.22487
G1 X164.602 Y156.602 E.02559
G1 X171.906 Y156.602 E.23487
G3 X173.047 Y155.363 I3.371 J1.959 E.05461
G3 X173.549 Y155.102 I1.908 J3.06 E.0182
G1 X185.398 Y155.102 E.38103
G1 X185.398 Y156.362 E.04053
G1 X174.734 Y156.362 E.3429
G2 X173.167 Y157.578 I.015 J1.637 E.0685
G1 X173.155 Y157.658 E.00261
; COOLING_NODE: 0
M204 S250
G1 X173.507 Y157.943 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
M106 S229.5
G1 F1336
M204 S5000
G1 X173.505 Y157.957 E.00041
G1 X173.505 Y159.254 E.03866
G1 X171.443 Y159.254 E.06142
M106 S226.95
M106 S229.5
G1 X171.444 Y159.249 E.00017
M106 S226.95
M106 S229.5
G1 X171.394 Y159.095 E.00481
M106 S226.95
G1 X171.31 Y158.797 E.00923
G1 X171.246 Y158.438 E.01088
G1 X171.226 Y158.038 E.01191
G1 X171.213 Y157.79 E.0074
G1 X170.813 Y157.79 E.01191
G1 X170.413 Y157.79 E.01191
G1 X170.013 Y157.79 E.01191
G1 X169.613 Y157.79 E.01191
G1 X169.213 Y157.79 E.01191
G1 X164.21 Y157.79 E.14902
G1 X164.21 Y156.21 E.04706
G1 X171.699 Y156.21 E.22307
G3 X173.47 Y154.71 I3.075 J1.835 E.0704
G1 X184.19 Y154.71 E.31932
G1 X184.59 Y154.71 E.01191
G1 X184.99 Y154.71 E.01191
G1 X185.39 Y154.71 E.01191
G1 X185.79 Y154.71 E.01191
G1 X185.79 Y154.995 E.0085
G1 X185.79 Y155.395 E.01191
G1 X185.79 Y155.795 E.01191
G1 X185.79 Y156.195 E.01191
G1 X185.79 Y156.595 E.01191
M106 S229.5
G1 X185.79 Y156.754 E.00474
M106 S226.95
M106 S229.5
G1 X175.345 Y156.754 E.31113
G2 X174.513 Y156.777 I-.3 J4.281 E.02482
G2 X173.528 Y157.776 I.272 J1.253 E.04423
G1 X173.514 Y157.883 E.00322
M106 S226.95
; WIPE_START
M73 P72 R7
G1 F2160
M204 S8000
G1 X173.505 Y157.957 E-.028
G1 X173.505 Y159.254 E-.49321
G1 X172.876 Y159.254 E-.23879
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.361 Y157.921 Z22 F60000
G1 Z21.6
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.313104
G1 F1336
M204 S8000
G1 X172.363 Y158.113 E.00409
G1 X172.234 Y158.246 E.00397
M204 S10000
G1 X172.361 Y157.921 F60000
; LINE_WIDTH: 0.345621
G1 F1336
M204 S8000
G1 X172.375 Y157.57 E.0084
; LINE_WIDTH: 0.395192
G1 X172.393 Y157.38 E.00531
; LINE_WIDTH: 0.426579
G3 X172.449 Y157.214 I.346 J.023 E.00536
; LINE_WIDTH: 0.388427
G1 X172.528 Y157.063 E.00465
; LINE_WIDTH: 0.338383
G1 X172.766 Y156.67 E.01073
; LINE_WIDTH: 0.321119
G3 X173.692 Y155.859 I1.986 J1.332 E.02736
G1 X173.795 Y155.833 E.00234
; LINE_WIDTH: 0.267102
G1 X173.883 Y155.816 E.00158
; LINE_WIDTH: 0.232317
G1 X173.97 Y155.799 E.00133
; LINE_WIDTH: 0.200395
G1 X174.065 Y155.784 E.00119
; LINE_WIDTH: 0.173295
G1 X174.151 Y155.771 E.0009
; LINE_WIDTH: 0.141326
G1 X174.317 Y155.752 E.0013
; LINE_WIDTH: 0.10959
G1 X174.515 Y155.738 E.00105
; WIPE_START
G1 F15000
G1 X174.317 Y155.752 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.788 Y157 Z22 F60000
G1 Z21.6
G1 E.8 F1800
; LINE_WIDTH: 0.43172
G1 F1336
M204 S8000
G1 X164.806 Y157 E.21445
; CHANGE_LAYER
; Z_HEIGHT: 21.8
; LAYER_HEIGHT: 0.199999
; WIPE_START
G1 F9259.259
G1 X166.806 Y157 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 109/165
; update layer progress
M73 L109
M991 S0 P108 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z22 I-.54 J1.091 P1  F60000
G1 X176.188 Y161.646 Z22
G1 Z21.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1405
M204 S8000
G1 X176.359 Y161.384 E.01007
G2 X176.595 Y160.522 I-1.638 J-.911 E.02901
G1 X176.595 Y159.845 E.02178
G1 X184.991 Y159.845 E.26999
G1 X184.991 Y160.591 E.02399
G1 X177.461 Y160.591 E.24214
G3 X177.122 Y161.541 I-9.297 J-2.779 E.03245
G3 X176.113 Y162.703 I-2.387 J-1.054 E.05023
G1 X175.491 Y163.068 E.0232
G1 X175.491 Y163.182 E.00368
G1 X174.377 Y163.063 E.03603
G3 X173.117 Y162.509 I.387 J-2.589 E.04479
G1 X173.174 Y162.344 E.0056
G1 X174.828 Y162.344 E.05319
G2 X176.132 Y161.707 I-.107 J-1.872 E.04792
G1 X176.147 Y161.69 E.00073
; COOLING_NODE: 0
M204 S10000
G1 X175.858 Y161.411 F60000
G1 F1405
M204 S8000
G1 X176.003 Y161.189 E.00851
G2 X176.188 Y160.513 I-1.277 J-.711 E.02276
G1 X176.188 Y159.438 E.03458
G1 X185.398 Y159.438 E.29617
G1 X185.398 Y160.998 E.05017
G1 X177.75 Y160.998 E.24593
G3 X177.065 Y162.404 I-4.009 J-1.082 E.0506
G3 X175.898 Y163.301 I-2.774 J-2.402 E.04766
G1 X175.898 Y164.898 E.05135
G1 X175.102 Y164.898 E.02559
G1 X175.102 Y163.55 E.04334
G3 X174.07 Y163.42 I.306 J-6.561 E.03349
G3 X172.106 Y161.937 I.709 J-2.981 E.08141
G1 X174.808 Y161.937 E.08688
G2 X175.816 Y161.453 I-.081 J-1.459 E.03689
; COOLING_NODE: 0
M204 S250
G1 X175.737 Y160.831 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
M106 S229.5
G1 F1405
M204 S5000
G1 X175.779 Y160.682 E.00462
G2 X175.796 Y160.504 I-1.034 J-.185 E.00531
G1 X175.796 Y159.046 E.04345
G1 X185.79 Y159.046 E.2977
M106 S226.95
M106 S229.5
G1 X185.79 Y159.205 E.00474
M106 S226.95
G1 X185.79 Y159.605 E.01191
G1 X185.79 Y160.005 E.01191
G1 X185.79 Y160.405 E.01191
G1 X185.79 Y160.805 E.01191
G1 X185.79 Y161.39 E.01744
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X185.39 Y161.39 E.01191
G1 X184.99 Y161.39 E.01191
G1 X184.59 Y161.39 E.01191
G1 X178.029 Y161.39 E.19544
G3 X176.29 Y163.526 I-3.363 J-.962 E.08431
G1 X176.29 Y165.29 E.05256
G1 X174.71 Y165.29 E.04706
G1 X174.71 Y163.903 E.04132
G3 X174.092 Y163.831 I.085 J-3.445 E.01854
G1 X173.696 Y163.722 E.01224
G1 X173.257 Y163.543 E.01414
G1 X173 Y163.403 E.00871
G1 X172.755 Y163.241 E.00875
G1 X172.391 Y162.934 E.01418
G1 X172.19 Y162.722 E.00871
G1 X172.007 Y162.492 E.00875
G1 X171.73 Y162.039 E.01581
G1 X171.582 Y161.704 E.0109
G1 X171.565 Y161.66 E.00143
M106 S229.5
G1 X171.526 Y161.549 E.0035
M106 S226.95
M106 S229.5
G1 X174.189 Y161.545 E.07931
G2 X174.915 Y161.533 I.299 J-3.755 E.02167
G2 X175.718 Y160.892 I-.17 J-1.036 E.03198
G1 X175.719 Y160.888 E.00011
M106 S226.95
; WIPE_START
G1 F2160
M204 S8000
G1 X175.779 Y160.682 E-.08177
G1 X175.796 Y160.504 E-.06767
G1 X175.796 Y159.046 E-.55437
G1 X175.943 Y159.046 E-.05619
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X176.945 Y160.901 Z22.2 F60000
G1 Z21.8
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.426076
G1 F1405
M204 S8000
G1 X176.992 Y160.705 E.00611
; LINE_WIDTH: 0.470895
G1 X177.024 Y160.536 E.0058
; LINE_WIDTH: 0.515398
G1 X177.044 Y160.419 E.00443
; LINE_WIDTH: 0.55332
G1 X177.062 Y160.312 E.00438
; LINE_WIDTH: 0.562201
G1 X177.075 Y160.303 E.00065
; LINE_WIDTH: 0.531578
G1 X177.136 Y160.282 E.00247
; LINE_WIDTH: 0.488813
G1 X177.196 Y160.26 E.00225
; LINE_WIDTH: 0.446048
G1 X177.256 Y160.239 E.00203
; LINE_WIDTH: 0.403283
G1 X177.316 Y160.218 E.00182
; LINE_WIDTH: 0.381949
G1 X184.787 Y160.218 E.20008
; WIPE_START
G1 F10618.572
G1 X182.787 Y160.218 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X176.945 Y160.901 Z22.2 F60000
G1 Z21.8
G1 E.8 F1800
; LINE_WIDTH: 0.383269
G1 F1405
M204 S8000
G1 X176.881 Y161.12 E.00613
G3 X175.61 Y162.555 I-2.19 J-.658 E.05318
; LINE_WIDTH: 0.422871
G1 X175.382 Y162.661 E.00754
; LINE_WIDTH: 0.47225
G3 X175.093 Y162.729 I-.294 J-.607 E.01017
; LINE_WIDTH: 0.428927
G1 X174.855 Y162.728 E.00724
; LINE_WIDTH: 0.38119
G3 X174.428 Y162.705 I.241 J-8.712 E.01144
; LINE_WIDTH: 0.341294
G1 X174.244 Y162.688 E.00436
; LINE_WIDTH: 0.311188
G1 X174.148 Y162.675 E.00205
; LINE_WIDTH: 0.285127
G1 X174.052 Y162.662 E.00185
; LINE_WIDTH: 0.257068
G1 X173.825 Y162.622 E.0039
; LINE_WIDTH: 0.227044
G1 X173.597 Y162.582 E.00336
; WIPE_START
G1 F15000
G1 X173.825 Y162.622 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.5 Y163.388 Z22.2 F60000
G1 Z21.8
G1 E.8 F1800
; LINE_WIDTH: 0.431732
G1 F1405
M204 S8000
G1 X175.5 Y164.694 E.04012
; COOLING_NODE: 0
; WIPE_START
G1 F9258.986
G1 X175.5 Y163.388 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.965 Y157.535 Z22.2 F60000
G1 Z21.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1405
M204 S8000
G1 X172.926 Y157.717 E.00596
G2 X172.905 Y157.942 I1.819 J.279 E.00727
G1 X172.905 Y158.655 E.02295
G1 X172.244 Y158.655 E.02126
G3 X172.163 Y158.14 I2.518 J-.66 E.01681
G1 X172.133 Y157.009 E.03637
G1 X172.282 Y157.009 E.00477
G3 X173.059 Y156.038 I3.951 J2.364 E.04012
G3 X174.039 Y155.509 I1.709 J1.994 E.03608
G1 X184.991 Y155.509 E.35219
G1 X184.991 Y156.155 E.02078
G1 X174.728 Y156.155 E.33002
G2 X172.979 Y157.477 I.017 J1.84 E.07552
; COOLING_NODE: 0
M204 S10000
G1 X173.36 Y157.649 F60000
G1 F1405
M204 S8000
G1 X173.313 Y157.959 E.0101
G1 X173.312 Y159.062 E.03547
G1 X171.946 Y159.062 E.04394
G3 X171.756 Y158.16 I2.868 J-1.073 E.02978
G1 X171.736 Y157.398 E.0245
G1 X164.602 Y157.398 E.22942
G1 X164.602 Y156.602 E.02559
G1 X172.07 Y156.602 E.24014
G3 X173.631 Y155.219 I2.871 J1.668 E.06823
G3 X173.985 Y155.102 I1.243 J3.176 E.01199
G1 X185.398 Y155.102 E.36698
G1 X185.398 Y156.562 E.04696
G1 X174.737 Y156.562 E.34282
G2 X173.371 Y157.59 I.01 J1.435 E.05889
; COOLING_NODE: 0
M204 S250
G1 X173.71 Y157.944 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
M106 S229.5
G1 F1405
M204 S5000
G1 X173.705 Y157.976 E.00098
G1 X173.704 Y159.454 E.04402
G1 X171.526 Y159.454 E.06488
M106 S226.95
M106 S229.5
G1 X171.58 Y159.295 E.005
M106 S226.95
G1 X171.596 Y159.249 E.00145
G1 X171.476 Y158.879 E.01158
G1 X171.412 Y158.59 E.00884
G1 X171.373 Y158.295 E.00884
G1 X171.355 Y157.79 E.01507
G1 X170.955 Y157.79 E.01191
G1 X170.555 Y157.79 E.01191
G1 X170.155 Y157.79 E.01191
G1 X169.755 Y157.79 E.01191
G1 X169.355 Y157.79 E.01191
G1 X164.21 Y157.79 E.15324
G1 X164.21 Y156.21 E.04706
G1 X171.866 Y156.21 E.22805
G3 X173.935 Y154.71 I2.931 J1.866 E.07795
G1 X184.59 Y154.71 E.31738
G1 X184.99 Y154.71 E.01191
G1 X185.39 Y154.71 E.01191
G1 X185.79 Y154.71 E.01191
G1 X185.79 Y155.195 E.01446
G1 X185.79 Y155.595 E.01191
G1 X185.79 Y155.995 E.01191
G1 X185.79 Y156.395 E.01191
G1 X185.79 Y156.795 E.01191
M106 S229.5
G1 X185.79 Y156.954 E.00474
M106 S226.95
M106 S229.5
G1 X175.346 Y156.954 E.3111
G2 X174.565 Y156.971 I-.3 J4.375 E.02327
G2 X173.751 Y157.713 I.219 J1.059 E.03445
G1 X173.72 Y157.885 E.0052
M106 S226.95
; WIPE_START
G1 F2160
M204 S8000
G1 X173.705 Y157.976 E-.03536
G1 X173.704 Y159.454 E-.56164
G1 X173.276 Y159.454 E-.163
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.539 Y157.67 Z22.2 F60000
G1 Z21.8
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.390789
G1 F1405
M204 S8000
G1 X172.534 Y158.12 E.01237
; LINE_WIDTH: 0.37004
G1 X172.543 Y158.292 E.00447
; LINE_WIDTH: 0.347524
G1 X172.474 Y158.368 E.00246
; LINE_WIDTH: 0.319492
G1 X172.405 Y158.444 E.00224
M204 S10000
G1 X172.539 Y157.67 F60000
; LINE_WIDTH: 0.430147
G1 F1405
M204 S8000
G3 X172.553 Y157.514 I2.385 J.138 E.00478
; LINE_WIDTH: 0.465116
G1 X172.566 Y157.383 E.0044
; LINE_WIDTH: 0.478466
G1 X172.635 Y157.221 E.00604
; LINE_WIDTH: 0.440148
G1 X172.698 Y157.101 E.00427
; LINE_WIDTH: 0.401439
G3 X172.861 Y156.833 I3.904 J2.194 E.00889
; LINE_WIDTH: 0.379741
G3 X172.964 Y156.688 I2.127 J1.395 E.00472
G3 X174.22 Y155.866 I1.615 J1.097 E.04101
; LINE_WIDTH: 0.333618
G1 X174.345 Y155.85 E.00288
; LINE_WIDTH: 0.282534
G1 X174.724 Y155.832 E.00718
G1 X184.787 Y155.832 E.19049
; WIPE_START
G1 F15000
G1 X182.787 Y155.832 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.199 Y156.648 Z22.2 F60000
G1 X171.929 Y157 Z22.2
G1 Z21.8
G1 E.8 F1800
; LINE_WIDTH: 0.43172
G1 F1405
M204 S8000
G1 X164.806 Y157 E.21879
; CHANGE_LAYER
; Z_HEIGHT: 22
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F9259.259
G1 X166.806 Y157 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 110/165
; update layer progress
M73 L110
M991 S0 P109 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z22.2 I-.537 J1.092 P1  F60000
G1 X176.023 Y161.528 Z22.2
G1 Z22
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1417
M204 S8000
G1 X176.136 Y161.384 E.00589
G2 X176.395 Y160.531 I-1.39 J-.887 E.02902
G1 X176.395 Y159.645 E.02849
G1 X184.991 Y159.645 E.27642
G1 X184.991 Y160.432 E.02531
G1 X177.317 Y160.432 E.24675
G3 X177.008 Y161.402 I-9.69 J-2.558 E.03277
G3 X176.062 Y162.547 I-2.272 J-.914 E.0485
G1 X175.491 Y162.9 E.02161
G1 X175.491 Y163.014 E.00366
G3 X174.371 Y162.902 I.773 J-13.295 E.0362
G3 X172.934 Y162.145 I.445 J-2.588 E.0531
G1 X174.805 Y162.145 E.06018
G2 X175.912 Y161.662 I-.059 J-1.648 E.03974
G1 X175.985 Y161.574 E.00368
; COOLING_NODE: 0
M204 S10000
G1 X175.708 Y161.274 F60000
G1 F1417
M204 S8000
G1 X175.793 Y161.165 E.00445
G2 X175.988 Y160.518 I-1.046 J-.668 E.02199
G1 X175.988 Y159.238 E.04118
G1 X185.398 Y159.238 E.3026
G1 X185.398 Y160.839 E.05149
G1 X177.617 Y160.839 E.25021
G3 X177.003 Y162.227 I-3.954 J-.919 E.0491
G3 X175.898 Y163.127 I-2.67 J-2.149 E.04617
G1 X175.898 Y164.898 E.05694
G1 X175.102 Y164.898 E.02559
G1 X175.102 Y163.385 E.04864
G3 X173.866 Y163.198 I.153 J-5.166 E.04029
G3 X172.187 Y161.738 I.93 J-2.766 E.07342
G1 X174.788 Y161.737 E.08364
G2 X175.624 Y161.375 I-.041 J-1.24 E.03004
G1 X175.67 Y161.32 E.00228
; COOLING_NODE: 0
M204 S250
G1 X175.541 Y160.795 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
M106 S229.5
G1 F1417
M204 S5000
M73 P73 R7
G1 X175.541 Y160.788 E.00022
G2 X175.596 Y160.506 I-.808 J-.301 E.00858
G1 X175.596 Y158.846 E.04947
G1 X185.79 Y158.846 E.30366
M106 S226.95
M106 S229.5
G1 X185.79 Y159.005 E.00474
M106 S226.95
G1 X185.79 Y159.405 E.01191
G1 X185.79 Y159.805 E.01191
G1 X185.79 Y160.205 E.01191
G1 X185.79 Y160.605 E.01191
G1 X185.79 Y161.005 E.01191
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X185.79 Y161.231 E.00674
G1 X185.39 Y161.231 E.01191
G1 X184.99 Y161.231 E.01191
G1 X184.59 Y161.231 E.01191
G1 X177.905 Y161.231 E.19912
G3 X176.29 Y163.346 I-3.241 J-.801 E.08153
G1 X176.29 Y165.29 E.05791
G1 X174.71 Y165.29 E.04706
G1 X174.71 Y163.741 E.04614
G3 X173.996 Y163.647 I.065 J-3.259 E.02149
G1 X173.639 Y163.534 E.01117
G1 X173.228 Y163.35 E.01339
G1 X172.802 Y163.077 E.01509
G1 X172.585 Y162.898 E.00838
G1 X172.386 Y162.702 E.00831
G1 X172.135 Y162.397 E.01177
G1 X171.925 Y162.067 E.01165
G1 X171.815 Y161.849 E.00727
G1 X171.68 Y161.504 E.01103
G1 X171.673 Y161.484 E.00063
M106 S229.5
G1 X171.632 Y161.346 E.00431
M106 S226.95
M106 S229.5
G1 X174.17 Y161.345 E.07561
G2 X174.882 Y161.336 I.3 J-4.067 E.02123
G2 X175.403 Y161.029 I-.149 J-.849 E.01841
G1 X175.511 Y160.847 E.0063
M106 S226.95
; WIPE_START
G1 F2160
M204 S8000
G1 X175.541 Y160.788 E-.02526
G1 X175.596 Y160.506 E-.10894
G1 X175.596 Y158.859 E-.6258
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X176.788 Y160.76 Z22.4 F60000
G1 Z22
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.475795
G1 F1417
M204 S8000
G2 X176.827 Y160.551 I-3.512 J-.766 E.00726
; LINE_WIDTH: 0.523101
G1 X176.849 Y160.405 E.0056
; LINE_WIDTH: 0.565418
G1 X176.869 Y160.273 E.00551
; LINE_WIDTH: 0.605617
G1 X176.89 Y160.141 E.00593
; LINE_WIDTH: 0.606314
G1 X176.945 Y160.119 E.00267
; LINE_WIDTH: 0.565152
G1 X177.001 Y160.099 E.00244
; LINE_WIDTH: 0.52448
G1 X177.057 Y160.079 E.00225
; LINE_WIDTH: 0.483808
G1 X177.112 Y160.058 E.00206
; LINE_WIDTH: 0.443136
G1 X177.168 Y160.038 E.00187
; LINE_WIDTH: 0.422848
G1 X184.787 Y160.038 E.22868
; WIPE_START
G1 F9475.486
G1 X182.787 Y160.038 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X176.788 Y160.76 Z22.4 F60000
G1 Z22
G1 E.8 F1800
; LINE_WIDTH: 0.424399
G1 F1417
M204 S8000
G3 X175.574 Y162.376 I-2.132 J-.337 E.06341
; LINE_WIDTH: 0.464754
G1 X175.353 Y162.484 E.00818
; LINE_WIDTH: 0.510941
G3 X175.087 Y162.546 I-.257 J-.5 E.0102
; LINE_WIDTH: 0.463817
G3 X174.832 Y162.546 I-.124 J-3.752 E.00848
; LINE_WIDTH: 0.419939
G3 X174.435 Y162.526 I.998 J-23.378 E.01183
; LINE_WIDTH: 0.380834
G1 X174.262 Y162.508 E.00466
; LINE_WIDTH: 0.341278
G1 X174.1 Y162.486 E.00384
; LINE_WIDTH: 0.301683
G1 X173.835 Y162.438 E.0055
; LINE_WIDTH: 0.267136
G1 X173.571 Y162.389 E.00477
; WIPE_START
G1 F15000
G1 X173.835 Y162.438 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.5 Y163.22 Z22.4 F60000
G1 Z22
G1 E.8 F1800
; LINE_WIDTH: 0.43173
G1 F1417
M204 S8000
G1 X175.5 Y164.694 E.04529
; COOLING_NODE: 0
; WIPE_START
G1 F9259.021
G1 X175.5 Y163.22 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X173.224 Y157.388 Z22.4 F60000
G1 Z22
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1417
M204 S8000
G1 X173.202 Y157.438 E.00175
G2 X173.105 Y157.974 I1.542 J.556 E.0176
G1 X173.105 Y158.855 E.02833
G1 X172.471 Y158.855 E.02039
G3 X172.322 Y158.132 I2.753 J-.945 E.02382
G1 X172.293 Y157.009 E.03611
G1 X172.454 Y157.009 E.00518
G3 X173.264 Y156.076 I3.614 J2.318 E.03988
G3 X174.768 Y155.568 I1.498 J1.959 E.05196
G1 X184.991 Y155.568 E.32874
G1 X184.991 Y156.355 E.02531
G1 X174.724 Y156.355 E.33015
G2 X173.298 Y157.223 I.021 J1.639 E.05631
G1 X173.248 Y157.333 E.00389
; COOLING_NODE: 0
M204 S10000
G1 X173.596 Y157.552 F60000
G1 F1417
M204 S8000
G1 X173.586 Y157.577 E.00088
G2 X173.512 Y157.985 I1.161 J.42 E.01339
G1 X173.512 Y159.262 E.04109
G1 X172.19 Y159.262 E.04253
G3 X171.915 Y158.151 I3 J-1.33 E.037
G1 X171.896 Y157.398 E.02423
G1 X164.602 Y157.398 E.23454
G1 X164.602 Y156.602 E.02559
G1 X172.251 Y156.602 E.24595
G3 X174.07 Y155.244 I2.656 J1.661 E.07469
G3 X174.761 Y155.161 I.796 J3.712 E.02241
G1 X185.398 Y155.161 E.34205
G1 X185.398 Y156.762 E.05149
G1 X174.734 Y156.762 E.3429
G2 X173.657 Y157.416 I.012 J1.234 E.04252
G1 X173.621 Y157.497 E.00285
; COOLING_NODE: 0
M204 S250
G1 X173.916 Y157.88 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
M106 S229.5
G1 F1417
M204 S5000
G1 X173.904 Y157.995 E.00344
G1 X173.904 Y159.654 E.04944
G1 X171.633 Y159.654 E.06767
M106 S226.95
M106 S229.5
G1 X171.648 Y159.595 E.00182
M106 S226.95
M106 S229.5
G1 X171.68 Y159.495 E.00312
M106 S226.95
G1 X171.768 Y159.25 E.00776
G1 X171.645 Y158.892 E.01127
G1 X171.579 Y158.618 E.0084
G1 X171.532 Y158.282 E.01012
G1 X171.514 Y157.79 E.01465
G1 X171.114 Y157.79 E.01191
G1 X170.714 Y157.79 E.01191
G1 X170.314 Y157.79 E.01191
G1 X169.914 Y157.79 E.01191
G1 X164.21 Y157.79 E.1699
G1 X164.21 Y156.21 E.04706
G1 X172.055 Y156.21 E.23367
G3 X174.754 Y154.769 I2.725 J1.856 E.09477
G1 X184.59 Y154.769 E.29298
G1 X184.99 Y154.769 E.01191
G1 X185.39 Y154.769 E.01191
G1 X185.79 Y154.769 E.01191
G1 X185.79 Y154.995 E.00674
G1 X185.79 Y155.395 E.01191
G1 X185.79 Y155.795 E.01191
G1 X185.79 Y156.195 E.01191
G1 X185.79 Y156.595 E.01191
G1 X185.79 Y156.995 E.01191
M106 S229.5
G1 X185.79 Y157.154 E.00474
M106 S226.95
M106 S229.5
G1 X175.345 Y157.154 E.31113
G2 X174.661 Y157.159 I-.3 J6.532 E.02036
G2 X173.925 Y157.82 I.094 J.846 E.03148
M106 S226.95
; WIPE_START
G1 F2160
M204 S8000
G1 X173.904 Y157.995 E-.0667
G1 X173.904 Y159.654 E-.63069
G1 X173.74 Y159.654 E-.06261
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.714 Y157.8 Z22.4 F60000
G1 Z22
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.420311
G1 F1417
M204 S8000
G1 X172.712 Y157.969 E.00504
G2 X172.722 Y158.287 I4.447 J.012 E.00949
; LINE_WIDTH: 0.383747
G2 X172.742 Y158.492 I3.92 J-.273 E.00554
; LINE_WIDTH: 0.344895
G1 X172.619 Y158.646 E.0047
M204 S10000
G1 X172.714 Y157.8 F60000
; LINE_WIDTH: 0.457109
G1 F1417
M204 S8000
G3 X172.729 Y157.556 I11.257 J.605 E.008
; LINE_WIDTH: 0.514183
G1 X172.754 Y157.362 E.00728
G1 X172.782 Y157.304 E.00238
; LINE_WIDTH: 0.494597
G3 X172.866 Y157.159 I2.028 J1.077 E.00598
; LINE_WIDTH: 0.460465
G1 X172.934 Y157.044 E.0044
; LINE_WIDTH: 0.4228
G3 X174.708 Y155.963 I1.823 J.995 E.06531
G1 X184.787 Y155.962 E.30244
; WIPE_START
G1 F9476.694
G1 X182.787 Y155.962 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.191 Y156.699 Z22.4 F60000
G1 X172.089 Y157 Z22.4
G1 Z22
G1 E.8 F1800
; LINE_WIDTH: 0.43172
G1 F1417
M204 S8000
G1 X164.806 Y157 E.22368
; CHANGE_LAYER
; Z_HEIGHT: 22.2
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F9259.259
G1 X166.806 Y157 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 111/165
; update layer progress
M73 L111
M991 S0 P110 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z22.4 I-.542 J1.089 P1  F60000
G1 X175.803 Y161.478 Z22.4
G1 Z22.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1428
M204 S8000
G1 X175.916 Y161.353 E.00542
G2 X176.193 Y160.609 I-1.171 J-.86 E.02587
G1 X176.194 Y159.445 E.03743
G1 X184.991 Y159.445 E.28288
G1 X184.991 Y160.253 E.02598
G1 X177.145 Y160.253 E.2523
G3 X176.842 Y161.334 I-8.015 J-1.66 E.03612
G3 X176.03 Y162.353 I-2.13 J-.863 E.0425
G1 X175.491 Y162.712 E.02084
G1 X175.491 Y162.857 E.00464
G1 X174.38 Y162.722 E.03597
G3 X172.986 Y161.945 I.509 J-2.554 E.05218
G1 X174.802 Y161.945 E.0584
G2 X175.694 Y161.592 I-.057 J-1.452 E.03144
G1 X175.762 Y161.522 E.00314
; COOLING_NODE: 0
M204 S10000
G1 X175.506 Y161.202 F60000
G1 F1428
M204 S8000
G1 X175.587 Y161.112 E.00389
G2 X175.786 Y160.58 I-.841 J-.617 E.01849
G1 X175.787 Y159.038 E.0496
G1 X185.398 Y159.038 E.30905
G1 X185.398 Y160.66 E.05216
G1 X177.458 Y160.66 E.25531
G3 X176.992 Y161.93 I-4.099 J-.783 E.04371
G3 X175.898 Y162.93 I-2.663 J-1.815 E.0481
G1 X175.898 Y164.898 E.06327
G1 X175.102 Y164.898 E.02559
G1 X175.102 Y163.22 E.05397
G3 X174.238 Y163.11 I.541 J-7.715 E.02802
G3 X172.288 Y161.538 I.542 J-2.667 E.08369
G1 X174.784 Y161.538 E.08025
G2 X175.429 Y161.284 I-.038 J-1.042 E.0227
G1 X175.465 Y161.245 E.00171
; COOLING_NODE: 0
M204 S250
G1 X175.346 Y160.743 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
M106 S229.5
G1 F1428
M204 S5000
G1 X175.36 Y160.703 E.00125
G2 X175.394 Y160.553 I-.626 J-.218 E.00461
G1 X175.395 Y158.646 E.05681
G1 X185.79 Y158.646 E.30962
M106 S226.95
M106 S229.5
G1 X185.79 Y158.805 E.00474
M106 S226.95
G1 X185.79 Y159.205 E.01191
G1 X185.79 Y159.605 E.01191
G1 X185.79 Y160.005 E.01191
G1 X185.79 Y160.405 E.01191
G1 X185.79 Y160.805 E.01191
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X185.79 Y161.052 E.00736
G1 X185.39 Y161.052 E.01191
G1 X184.99 Y161.052 E.01191
G1 X184.59 Y161.052 E.01191
G1 X177.76 Y161.052 E.20344
G3 X176.29 Y163.14 I-3.097 J-.618 E.07832
G1 X176.29 Y165.29 E.06403
G1 X174.71 Y165.29 E.04706
G1 X174.71 Y163.567 E.05133
G3 X174.159 Y163.498 I.11 J-3.138 E.01655
G1 X173.749 Y163.383 E.01269
G1 X173.372 Y163.223 E.0122
G1 X172.952 Y162.966 E.01466
G1 X172.552 Y162.617 E.01582
G1 X172.219 Y162.205 E.0158
G1 X171.985 Y161.79 E.01417
G1 X171.832 Y161.394 E.01265
G1 X171.807 Y161.305 E.00276
G1 X171.789 Y161.239 E.00201
M106 S229.5
G1 X171.768 Y161.146 E.00287
M106 S226.95
M106 S229.5
G1 X174.167 Y161.145 E.07147
G2 X174.852 Y161.138 I.3 J-3.923 E.02043
G2 X175.309 Y160.817 I-.117 J-.652 E.01717
G1 X175.319 Y160.796 E.00068
M106 S226.95
; WIPE_START
G1 F2160
M204 S8000
G1 X175.36 Y160.703 E-.0387
G1 X175.394 Y160.553 E-.05865
G1 X175.395 Y158.809 E-.66265
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X176.608 Y160.653 Z22.6 F60000
G1 Z22.2
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.44504
G1 F1428
M204 S8000
G3 X175.552 Y162.177 I-1.936 J-.213 E.06139
; LINE_WIDTH: 0.483348
G1 X175.342 Y162.288 E.00825
; LINE_WIDTH: 0.512306
G1 X175.311 Y162.303 E.0013
; LINE_WIDTH: 0.539729
G3 X175.069 Y162.361 I-.2 J-.298 E.00997
; LINE_WIDTH: 0.5128
G1 X175.034 Y162.362 E.00131
; LINE_WIDTH: 0.484668
G1 X174.811 Y162.358 E.00779
; LINE_WIDTH: 0.439873
G1 X174.441 Y162.335 E.0116
; LINE_WIDTH: 0.401394
G1 X174.287 Y162.319 E.0044
; LINE_WIDTH: 0.361727
G1 X174.127 Y162.296 E.00407
; LINE_WIDTH: 0.322691
G1 X173.865 Y162.246 E.00588
; LINE_WIDTH: 0.291816
G1 X173.604 Y162.196 E.00523
; WIPE_START
G1 F14463.899
G1 X173.865 Y162.246 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.5 Y163.063 Z22.6 F60000
G1 Z22.2
G1 E.8 F1800
; LINE_WIDTH: 0.43173
G1 F1428
M204 S8000
G1 X175.5 Y164.694 E.05011
; WIPE_START
G1 F9259.021
G1 X175.5 Y163.063 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X176.608 Y160.653 Z22.6 F60000
G1 Z22.2
G1 E.8 F1800
; LINE_WIDTH: 0.492777
G1 F1428
M204 S8000
G2 X176.634 Y160.46 I-2.759 J-.472 E.00689
; LINE_WIDTH: 0.538603
G1 X176.655 Y160.298 E.00642
; LINE_WIDTH: 0.580751
G1 X176.676 Y160.135 E.00697
; LINE_WIDTH: 0.622899
G1 X176.698 Y159.972 E.00752
; LINE_WIDTH: 0.633872
G1 X176.701 Y159.952 E.00097
G1 X176.758 Y159.931 E.00285
; LINE_WIDTH: 0.588166
G1 X176.816 Y159.911 E.00263
; LINE_WIDTH: 0.54693
G1 X176.873 Y159.89 E.00243
; LINE_WIDTH: 0.505694
G1 X176.931 Y159.869 E.00223
; LINE_WIDTH: 0.464458
G1 X176.988 Y159.849 E.00203
; LINE_WIDTH: 0.443802
G1 X184.787 Y159.849 E.24698
; COOLING_NODE: 0
; WIPE_START
G1 F8980.196
G1 X182.787 Y159.849 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.357 Y158.104 Z22.6 F60000
G1 X173.353 Y157.633 Z22.6
G1 Z22.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1428
M204 S8000
G1 X173.319 Y157.794 E.00529
G2 X173.305 Y157.965 I1.425 J.199 E.0055
G1 X173.305 Y159.055 E.03506
G1 X172.744 Y159.055 E.01803
G3 X172.501 Y158.118 I2.321 J-1.104 E.03134
G1 X172.472 Y157.009 E.03566
G1 X172.643 Y157.009 E.00551
G3 X173.193 Y156.373 I4.599 J3.421 E.02707
G3 X174.763 Y155.747 I1.581 J1.685 E.05564
G1 X176.357 Y155.747 E.05125
G1 X184.991 Y155.747 E.27763
G1 X184.991 Y156.555 E.02598
G1 X174.698 Y156.555 E.33099
G2 X173.367 Y157.575 I.047 J1.439 E.05753
; COOLING_NODE: 0
M204 S10000
G1 X173.748 Y157.749 F60000
G1 F1428
M204 S8000
M73 P74 R7
G1 X173.712 Y157.979 E.00749
G1 X173.712 Y159.462 E.0477
G1 X172.3 Y159.462 E.0454
G1 X172.382 Y159.247 E.00742
G3 X172.094 Y158.139 I2.741 J-1.304 E.03703
G1 X172.075 Y157.398 E.02384
G1 X164.602 Y157.398 E.24029
G1 X164.602 Y156.602 E.02559
G1 X172.454 Y156.602 E.25248
G3 X173.591 Y155.607 I2.697 J1.934 E.04903
G3 X174.758 Y155.34 I1.208 J2.601 E.03879
G1 X176.357 Y155.34 E.05142
G1 X185.398 Y155.34 E.29072
G1 X185.398 Y156.962 E.05216
G1 X174.719 Y156.962 E.3434
G2 X173.759 Y157.69 I.028 J1.034 E.04135
; COOLING_NODE: 0
M204 S250
G1 X174.116 Y157.919 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
M106 S229.5
G1 F1428
M204 S5000
G1 X174.104 Y157.993 E.00223
G1 X174.104 Y159.854 E.05545
G1 X171.769 Y159.854 E.06958
M106 S226.95
M106 S229.5
G1 X171.806 Y159.696 E.00485
M106 S226.95
G1 X171.806 Y159.695 E.00001
G1 X171.962 Y159.249 E.01409
G1 X171.832 Y158.895 E.01123
G1 X171.755 Y158.583 E.00955
G1 X171.703 Y158.16 E.01272
G1 X171.693 Y157.79 E.01101
G1 X171.293 Y157.79 E.01191
G1 X170.893 Y157.79 E.01191
G1 X170.493 Y157.79 E.01191
G1 X164.21 Y157.79 E.18714
G1 X164.21 Y156.21 E.04706
G1 X172.271 Y156.21 E.24011
G3 X174.753 Y154.948 I2.517 J1.88 E.08592
G1 X176.357 Y154.948 E.04778
G1 X184.59 Y154.948 E.24523
G1 X184.99 Y154.948 E.01191
G1 X185.39 Y154.948 E.01191
G1 X185.79 Y154.948 E.01191
G1 X185.79 Y155.195 E.00736
G1 X185.79 Y155.595 E.01191
G1 X185.79 Y155.995 E.01191
G1 X185.79 Y156.395 E.01191
G1 X185.79 Y156.795 E.01191
G1 X185.79 Y157.195 E.01191
M106 S229.5
G1 X185.79 Y157.354 E.00474
M106 S226.95
M106 S229.5
G1 X174.739 Y157.354 E.32916
G2 X174.137 Y157.812 I.03 J.665 E.02397
G1 X174.127 Y157.86 E.00145
M106 S226.95
; WIPE_START
G1 F2160
M204 S8000
G1 X174.104 Y157.993 E-.05124
G1 X174.104 Y159.854 E-.70741
G1 X174.101 Y159.854 E-.00135
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.905 Y157.75 Z22.6 F60000
G1 Z22.2
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.48122
G1 F1428
M204 S8000
G3 X172.92 Y157.591 I2.143 J.111 E.00553
; LINE_WIDTH: 0.516152
G1 X172.932 Y157.463 E.00479
; LINE_WIDTH: 0.538113
G1 X173.01 Y156.889 E.02269
M204 S10000
G1 X172.905 Y157.75 F60000
; LINE_WIDTH: 0.446541
G1 F1428
M204 S8000
G1 X172.901 Y157.958 E.00662
G2 X172.907 Y158.196 I4.56 J.01 E.00759
; LINE_WIDTH: 0.412228
G2 X172.93 Y158.455 I3.778 J-.202 E.00758
; LINE_WIDTH: 0.373823
G1 X172.943 Y158.554 E.00262
; LINE_WIDTH: 0.343575
G1 X172.96 Y158.656 E.00246
; LINE_WIDTH: 0.314481
G1 X172.997 Y158.852 E.00427
; WIPE_START
G1 F13256.689
G1 X172.96 Y158.656 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X165.48 Y157.137 Z22.6 F60000
G1 X164.806 Y157 Z22.6
G1 Z22.2
G1 E.8 F1800
; LINE_WIDTH: 0.43172
G1 F1428
M204 S8000
G1 X172.268 Y157 E.22918
M204 S10000
G1 X172.681 Y157.239 F60000
; LINE_WIDTH: 0.178451
G1 F1428
M204 S8000
G1 X172.714 Y157.256 E.0004
; LINE_WIDTH: 0.227234
G1 X172.747 Y157.273 E.00054
; LINE_WIDTH: 0.276016
G1 X172.78 Y157.29 E.00068
; LINE_WIDTH: 0.324798
G1 X172.813 Y157.307 E.00082
; LINE_WIDTH: 0.37358
G1 X172.845 Y157.324 E.00097
; LINE_WIDTH: 0.422362
G1 X172.878 Y157.341 E.00111
; LINE_WIDTH: 0.471144
G1 X172.911 Y157.358 E.00125
; LINE_WIDTH: 0.544683
G1 X172.947 Y157.371 E.0015
G1 X172.998 Y157.284 E.00401
; LINE_WIDTH: 0.517184
G1 X173.05 Y157.197 E.00379
; LINE_WIDTH: 0.49662
G1 X173.069 Y157.169 E.00122
; LINE_WIDTH: 0.471125
G1 X173.208 Y156.97 E.00819
; LINE_WIDTH: 0.443509
G3 X174.656 Y156.154 I1.548 J1.053 E.05452
G3 X176.357 Y156.151 I.9 J33.557 E.05383
G1 X184.787 Y156.151 E.26676
; CHANGE_LAYER
; Z_HEIGHT: 22.4
; LAYER_HEIGHT: 0.199999
; WIPE_START
G1 F8986.777
G1 X182.787 Y156.151 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 112/165
; update layer progress
M73 L112
M991 S0 P111 ;notify layer change

M106 S221.85
; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z22.6 I-.715 J-.984 P1  F60000
G1 X175.706 Y161.298 Z22.6
G1 Z22.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2123
M204 S8000
G1 X175.766 Y161.236 E.00279
G1 X175.93 Y160.927 E.01122
G1 X175.994 Y160.622 E.01004
G1 X175.994 Y159.245 E.04428
G1 X184.991 Y159.245 E.28929
G1 X184.991 Y160.055 E.02605
G1 X176.948 Y160.055 E.25864
G3 X176.72 Y161.085 I-10.459 J-1.777 E.03393
G3 X176.408 Y161.712 I-1.982 J-.593 E.02264
G1 X176.229 Y161.926 E.00898
G1 X175.989 Y162.139 E.0103
G1 X175.74 Y162.32 E.00988
G1 X175.417 Y162.555 E.01286
G1 X174.857 Y162.555 E.01801
G1 X174.457 Y162.555 E.01286
G1 X174.057 Y162.555 E.01286
G1 X173.657 Y162.555 E.01286
G1 X173.257 Y162.555 E.01286
G1 F1981.086
G1 X172.857 Y162.555 E.01286
G1 F1467.857
G1 X172.457 Y162.555 E.01286
M106 S229.5
G1 F1031.427
G1 X171.965 Y162.555 E.01582
M106 S221.85
; FEATURE: Overhang wall
M106 S229.5
G1 F600
M204 S5000
G1 X169.909 Y162.555 E.06611
G1 X169.909 Y161.745 E.02605
G1 X171.521 Y161.745 E.05182
M106 S221.85
; FEATURE: Inner wall
M106 S229.5
G1 F955.349
M204 S8000
G1 X171.935 Y161.745 E.01331
M106 S221.85
G1 F1376.817
G1 X172.335 Y161.745 E.01286
G1 F1875.086
G1 X172.735 Y161.745 E.01286
G1 F2123
G1 X173.135 Y161.745 E.01286
G1 X173.535 Y161.745 E.01286
G1 X173.935 Y161.745 E.01286
G1 X174.335 Y161.745 E.01286
G1 X174.798 Y161.745 E.0149
G1 X174.988 Y161.726 E.00614
G1 X175.24 Y161.652 E.00846
G1 X175.525 Y161.487 E.01059
G1 X175.665 Y161.341 E.00648
; COOLING_NODE: 0
M204 S10000
G1 X175.453 Y160.957 F60000
G1 F2123
M204 S8000
G1 X175.542 Y160.787 E.00618
G2 X175.587 Y160.579 I-.78 J-.277 E.00685
G1 X175.587 Y158.838 E.056
G1 X185.398 Y158.838 E.31547
G1 X185.398 Y160.462 E.05223
G1 X177.276 Y160.462 E.26117
G3 X176.936 Y161.631 I-4.201 J-.587 E.0393
G3 X175.898 Y162.708 I-2.49 J-1.362 E.04868
G1 X175.898 Y164.898 E.07041
G1 X175.102 Y164.898 E.02559
G1 X175.102 Y164.562 E.01081
G1 X175.102 Y164.162 E.01286
G1 X175.102 Y163.762 E.01286
G1 X175.102 Y163.362 E.01286
G1 X175.102 Y162.962 E.01286
G1 X174.901 Y162.962 E.00646
G1 X174.501 Y162.962 E.01286
G1 X174.101 Y162.962 E.01286
G1 X173.701 Y162.962 E.01286
G1 F2109.181
G1 X173.301 Y162.962 E.01286
G1 F1578.397
G1 X172.901 Y162.962 E.01286
M106 S229.5
G1 F1124.413
G1 X172.318 Y162.962 E.01876
M106 S221.85
; FEATURE: Overhang wall
M106 S229.5
G1 F600
M204 S5000
G1 X169.502 Y162.962 E.09055
G1 X169.502 Y161.338 E.05223
G1 X171.391 Y161.338 E.06075
M106 S221.85
; FEATURE: Inner wall
M106 S229.5
G1 F938.995
M204 S8000
G1 X171.788 Y161.338 E.01276
M106 S221.85
G1 F1357.171
G1 X172.188 Y161.338 E.01286
G1 F1852.147
G1 X172.588 Y161.338 E.01286
G1 F2123
G1 X172.988 Y161.338 E.01286
G1 X173.388 Y161.338 E.01286
G1 X173.788 Y161.338 E.01286
G1 X174.188 Y161.338 E.01286
G1 X174.779 Y161.338 E.01899
G1 X174.91 Y161.325 E.00425
G1 X175.078 Y161.275 E.00563
G1 X175.271 Y161.163 E.00718
G1 X175.423 Y161.009 E.00697
; COOLING_NODE: 0
M204 S250
G1 X175.112 Y160.763 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
M106 S229.5
G1 F1577
M204 S5000
G2 X175.195 Y160.538 I-.358 J-.259 E.00721
G1 X175.195 Y158.446 E.06233
G1 X185.79 Y158.446 E.31558
M106 S221.85
M106 S229.5
G1 X185.79 Y158.605 E.00474
M106 S221.85
G1 X185.79 Y159.005 E.01191
G1 X185.79 Y159.405 E.01191
G1 X185.79 Y159.805 E.01191
G1 X185.79 Y160.205 E.01191
G1 X185.79 Y160.605 E.01191
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X185.79 Y160.854 E.00743
G1 X185.39 Y160.854 E.01191
G1 X184.99 Y160.854 E.01191
G1 X184.59 Y160.854 E.01191
G1 X177.593 Y160.854 E.20843
G3 X176.29 Y162.908 I-2.943 J-.426 E.07464
G1 X176.29 Y165.29 E.07095
G1 X175.91 Y165.29 E.01132
G1 X175.51 Y165.29 E.01191
G1 X175.11 Y165.29 E.01191
G1 X174.71 Y165.29 E.01191
G1 X174.71 Y164.954 E.01001
G1 X174.71 Y164.554 E.01191
G1 X174.71 Y164.154 E.01191
G1 X174.71 Y163.754 E.01191
G1 X174.71 Y163.354 E.01191
G1 X174.359 Y163.354 E.01044
G1 X173.959 Y163.354 E.01191
G1 X173.559 Y163.354 E.01191
M106 S229.5
G1 F1323.268
G1 X173.192 Y163.354 E.01093
M106 S221.85
M106 S229.5
G1 F941.979
G1 X172.792 Y163.354 E.01191
M106 S221.85
; FEATURE: Overhang wall
; LINE_WIDTH: 0.45
M106 S229.5
G1 F600
G1 X169.11 Y163.354 E.11842
G1 X169.11 Y160.946 E.07745
G1 X171.316 Y160.946 E.07094
M106 S221.85
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
M106 S229.5
G1 F941.979
G1 X171.716 Y160.946 E.01191
M106 S221.85
M106 S229.5
G1 F1141.768
G1 X171.916 Y160.946 E.00596
M106 S221.85
M106 S229.5
G1 F1577
G1 X172.316 Y160.946 E.01191
M106 S221.85
M106 S229.5
G1 X172.664 Y160.946 E.01036
M106 S221.85
M106 S229.5
G1 X173.412 Y160.946 E.02228
M106 S221.85
M106 S229.5
G1 X174.76 Y160.946 E.04015
G2 X175.074 Y160.809 I-.006 J-.442 E.01048
M106 S221.85
; WIPE_START
G1 F2160
M204 S8000
G1 X175.171 Y160.652 E-.06994
G1 X175.195 Y160.538 E-.04432
G1 X175.195 Y158.839 E-.64574
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.43 Y162.027 Z22.8 F60000
G1 Z22.4
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.480628
G1 F2123
M204 S8000
G1 X175.384 Y162.053 E.00181
; LINE_WIDTH: 0.504589
G3 X175.088 Y162.135 I-.274 J-.414 E.01138
; LINE_WIDTH: 0.446743
G3 X174.808 Y162.15 I-.589 J-8.414 E.00897
G1 X170.113 Y162.15 E.14977
; WIPE_START
G1 F8914.804
G1 X172.113 Y162.15 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z22.8 I-.731 J.973 P1  F60000
G1 X175.5 Y164.694 Z22.8
G1 Z22.4
G1 E.8 F1800
; LINE_WIDTH: 0.43173
G1 F2123
M204 S8000
G1 X175.5 Y162.952 E.05351
; LINE_WIDTH: 0.411321
G1 X175.565 Y162.861 E.00325
; LINE_WIDTH: 0.370489
G1 X175.63 Y162.77 E.00289
; LINE_WIDTH: 0.329656
G1 X175.694 Y162.679 E.00253
M204 S10000
G1 X175.43 Y162.027 F60000
; LINE_WIDTH: 0.445462
G1 F2123
M204 S8000
G2 X176.403 Y160.643 I-.788 J-1.588 E.05607
; LINE_WIDTH: 0.475684
G1 X176.425 Y160.429 E.00734
; LINE_WIDTH: 0.52129
G1 X176.448 Y160.216 E.00812
; LINE_WIDTH: 0.566896
G1 X176.471 Y160.002 E.00889
; LINE_WIDTH: 0.612503
G1 X176.494 Y159.789 E.00966
; LINE_WIDTH: 0.631935
G1 X176.499 Y159.75 E.00183
G1 X176.556 Y159.73 E.0028
; LINE_WIDTH: 0.586152
G1 X176.613 Y159.71 E.00258
; LINE_WIDTH: 0.54612
G1 X176.67 Y159.69 E.00239
; LINE_WIDTH: 0.506088
G1 X176.727 Y159.67 E.0022
; LINE_WIDTH: 0.466056
G1 X176.784 Y159.65 E.00201
; LINE_WIDTH: 0.44602
G1 X184.787 Y159.65 E.25486
; COOLING_NODE: 0
; WIPE_START
G1 F8930.787
G1 X182.787 Y159.65 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.354 Y157.917 Z22.8 F60000
G1 X173.205 Y157.416 Z22.8
G1 Z22.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2123
M204 S8000
G1 X173.148 Y157.576 E.00546
G1 X173.099 Y157.855 E.00911
G1 X173.099 Y158.448 E.01907
G1 X173.099 Y158.848 E.01286
G1 X172.591 Y158.848 E.01633
G1 F1852.36
G1 X172.191 Y158.848 E.01286
G1 F1357.353
G1 X171.791 Y158.848 E.01286
M106 S229.5
G1 F939.147
G1 X171.394 Y158.848 E.01277
M106 S221.85
; FEATURE: Overhang wall
M106 S229.5
G1 F600
M204 S5000
G1 X170.316 Y158.848 E.03466
G1 X170.316 Y158.2 E.02085
M106 S221.85
; FEATURE: Inner wall
M106 S229.5
G1 F925.411
M204 S8000
G1 X170.316 Y157.817 E.0123
M106 S221.85
G1 F1342.305
G1 X170.316 Y157.416 E.0129
G1 F1834.773
G1 X170.716 Y157.416 E.01286
G1 F2123
G1 X171.116 Y157.416 E.01286
G1 X171.516 Y157.416 E.01286
G1 X171.916 Y157.416 E.01286
G1 X172.316 Y157.416 E.01286
G1 X172.716 Y157.416 E.01286
G1 X173.145 Y157.416 E.01379
; COOLING_NODE: 0
M204 S10000
G1 X173.594 Y157.537 F60000
G1 F2123
M204 S8000
G1 X173.545 Y157.681 E.00491
G1 X173.506 Y157.891 E.00687
G1 X173.506 Y158.455 E.01815
G1 X173.506 Y158.855 E.01286
G1 X173.506 Y159.255 E.01286
G1 X173.13 Y159.255 E.01207
G1 X172.73 Y159.255 E.01286
G1 F1868.517
G1 X172.33 Y159.255 E.01286
G1 F1371.189
G1 X171.93 Y159.255 E.01286
M106 S229.5
G1 F950.662
G1 X171.521 Y159.255 E.01316
M106 S221.85
; FEATURE: Overhang wall
M106 S229.5
G1 F600
M204 S5000
G1 X169.909 Y159.255 E.05184
G1 X169.909 Y158.2 E.03394
M106 S221.85
; FEATURE: Inner wall
M106 S229.5
G1 F925.411
M204 S8000
G1 X169.909 Y157.817 E.0123
M106 S221.85
G1 F1340.829
G1 X169.909 Y157.417 E.01286
G1 F1844.168
G1 X169.909 Y157.009 E.01313
G1 F2123
G1 X170.309 Y157.009 E.01286
G1 X170.709 Y157.009 E.01286
G1 X171.109 Y157.009 E.01286
G1 X171.509 Y157.009 E.01286
G1 X171.909 Y157.009 E.01286
G1 X172.309 Y157.009 E.01286
G1 X172.878 Y157.009 E.0183
G1 X173.149 Y156.714 E.01286
G1 X173.34 Y156.513 E.00894
G3 X173.734 Y156.214 I2.254 J2.562 E.0159
G3 X174.762 Y155.945 I1.04 J1.874 E.03454
G1 X184.991 Y155.945 E.32891
G1 X184.991 Y156.756 E.02606
G1 X174.607 Y156.758 E.3339
G2 X173.618 Y157.481 I.159 J1.256 E.04115
; COOLING_NODE: 0
M204 S10000
G1 X173.971 Y157.707 F60000
G1 F2123
M204 S8000
G1 X173.913 Y157.927 E.00729
G1 X173.913 Y158.462 E.01723
G1 X173.913 Y158.862 E.01286
G1 X173.913 Y159.262 E.01286
G1 X173.913 Y159.662 E.01286
G1 X173.388 Y159.662 E.01688
G1 X172.988 Y159.662 E.01286
G1 X172.588 Y159.662 E.01286
G1 F1849.681
G1 X172.188 Y159.662 E.01286
G1 F1355.06
G1 X171.788 Y159.662 E.01286
M106 S229.5
G1 F937.239
G1 X171.393 Y159.662 E.0127
M106 S221.85
; FEATURE: Overhang wall
M106 S229.5
G1 F600
M204 S5000
G1 X169.502 Y159.662 E.0608
G1 X169.502 Y158.2 E.04703
M106 S221.85
; FEATURE: Inner wall
M106 S229.5
G1 F925.411
M204 S8000
G1 X169.502 Y157.817 E.0123
M106 S221.85
G1 F1363.124
G1 X169.502 Y157.398 E.01349
G1 F1859.1
G1 X169.102 Y157.398 E.01286
G1 F2123
G1 X168.702 Y157.398 E.01286
G1 X168.302 Y157.398 E.01286
G1 X167.902 Y157.398 E.01286
G1 X167.502 Y157.398 E.01286
G1 X167.102 Y157.398 E.01286
G1 X166.702 Y157.398 E.01286
G1 X166.302 Y157.398 E.01286
G1 X165.902 Y157.398 E.01286
G1 X165.502 Y157.398 E.01286
G1 X164.602 Y157.398 E.02894
G1 X164.602 Y156.602 E.02559
G1 X172.697 Y156.602 E.26031
G3 X174.757 Y155.538 I2.118 J1.575 E.07719
G1 X185.398 Y155.538 E.34216
G1 X185.398 Y157.163 E.05224
G1 X174.652 Y157.165 E.34556
G2 X173.988 Y157.65 I.108 J.844 E.02759
; COOLING_NODE: 0
M204 S250
G1 X174.333 Y157.853 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
M106 S229.5
G1 F1577
M204 S5000
G1 X174.305 Y157.961 E.00331
G1 X174.305 Y160.054 E.06235
G1 X173.705 Y160.054 E.01787
M106 S221.85
M106 S229.5
G1 X172.81 Y160.054 E.02663
M106 S221.85
M106 S229.5
G1 X172.516 Y160.054 E.00876
M106 S221.85
M106 S229.5
G1 X172.116 Y160.054 E.01191
M106 S221.85
M106 S229.5
G1 F1360.757
G1 X171.716 Y160.054 E.01191
M106 S221.85
M106 S229.5
G1 F941.979
G1 X171.316 Y160.054 E.01191
M106 S221.85
; FEATURE: Overhang wall
; LINE_WIDTH: 0.45
M106 S229.5
G1 F600
G1 X169.11 Y160.054 E.07094
G1 X169.11 Y158.2 E.05963
M106 S221.85
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
M106 S229.5
G1 F912.73
G1 X169.11 Y157.831 E.01099
M106 S221.85
G1 F951.512
G1 X169.11 Y157.79 E.00122
G1 F1372.211
G1 X168.71 Y157.79 E.01191
G1 F1577
G1 X168.31 Y157.79 E.01191
G1 X167.91 Y157.79 E.01191
G1 X167.51 Y157.79 E.01191
G1 X167.11 Y157.79 E.01191
G1 X166.71 Y157.79 E.01191
G1 X166.31 Y157.79 E.01191
G1 X165.91 Y157.79 E.01191
G1 X165.51 Y157.79 E.01191
G1 X165.11 Y157.79 E.01191
G1 X164.71 Y157.79 E.01191
G1 X164.21 Y157.79 E.01489
G1 X164.21 Y156.21 E.04706
G1 X172.523 Y156.21 E.2476
G3 X174.753 Y155.146 I2.236 J1.817 E.07607
G1 X184.59 Y155.146 E.29302
G1 X184.99 Y155.146 E.01191
M73 P75 R7
G1 X185.39 Y155.146 E.01191
G1 X185.79 Y155.146 E.01191
G1 X185.79 Y155.395 E.00743
G1 X185.79 Y155.795 E.01191
G1 X185.79 Y156.195 E.01191
G1 X185.79 Y156.595 E.01191
G1 X185.79 Y156.995 E.01191
G1 X185.79 Y157.395 E.01191
M106 S229.5
G1 X185.79 Y157.555 E.00474
M106 S221.85
M106 S229.5
G1 X174.695 Y157.557 E.33049
G2 X174.358 Y157.799 I.079 J.466 E.01279
M106 S221.85
; WIPE_START
G1 F2160
M204 S8000
G1 X174.305 Y157.961 E-.06482
G1 X174.305 Y159.791 E-.69518
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X173.257 Y157.213 Z22.8 F60000
G1 Z22.4
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.446804
G1 F2123
M204 S8000
G1 X173.533 Y156.884 E.01368
G3 X174.767 Y156.351 I1.223 J1.136 E.04416
G1 X184.787 Y156.35 E.31968
; WIPE_START
G1 F8913.458
G1 X182.787 Y156.351 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.231 Y157.427 Z22.8 F60000
G1 X172.951 Y157.751 Z22.8
G1 Z22.4
G1 E.8 F1800
; FEATURE: Bridge
; LINE_WIDTH: 0.42378
M106 S229.5
M73 P75 R6
G1 F3000
M204 S8000
G1 X170.649 Y157.751 E.06926
G1 X170.649 Y158.132 E.01146
G1 X172.766 Y158.132 E.06367
G1 X172.766 Y158.513 E.01146
G1 X170.48 Y158.513 E.06877
M106 S221.85
; WIPE_START
G1 X172.48 Y158.513 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z22.8 I.583 J-1.068 P1  F60000
G1 X169.705 Y157 Z22.8
G1 Z22.4
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F2123
M204 S8000
G1 X164.806 Y157 E.15049
; CHANGE_LAYER
; Z_HEIGHT: 22.6
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F9259.259
G1 X166.806 Y157 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 113/165
; update layer progress
M73 L113
M991 S0 P112 ;notify layer change

M106 S226.95
; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z22.8 I-.143 J1.209 P1  F60000
G1 X170.316 Y157.416 Z22.8
G1 Z22.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1370
M204 S8000
G1 X173.273 Y157.416 E.09508
G3 X173.866 Y156.854 I4.04 J3.668 E.02628
G3 X174.766 Y156.552 I.895 J1.176 E.03109
G1 X182.184 Y156.552 E.23853
G1 X182.584 Y156.552 E.01286
G1 X182.984 Y156.552 E.01286
G1 X183.384 Y156.552 E.01286
G1 X183.784 Y156.552 E.01286
G1 X184.184 Y156.552 E.01286
G1 X184.584 Y156.552 E.01286
G1 X184.584 Y156.782 E.0074
G1 X184.584 Y157.182 E.01286
G1 X184.584 Y157.582 E.01286
M106 S229.5
G1 X184.584 Y157.965 E.0123
M106 S226.95
; FEATURE: Overhang wall
M106 S229.5
G1 F3000
M204 S5000
G1 X184.584 Y158.036 E.00228
M106 S226.95
; FEATURE: Inner wall
M106 S229.5
G1 F1370
M204 S8000
G1 X184.584 Y158.418 E.0123
M106 S226.95
G1 X184.584 Y158.818 E.01286
G1 X184.584 Y159.218 E.01286
G1 X184.584 Y159.448 E.00739
G1 X184.184 Y159.448 E.01286
G1 X183.784 Y159.448 E.01286
G1 X183.384 Y159.448 E.01286
G1 X182.984 Y159.448 E.01286
G1 X182.584 Y159.448 E.01286
G1 X182.184 Y159.448 E.01286
G1 X176.388 Y159.448 E.18637
G1 X176.172 Y160.769 E.04305
G3 X175.684 Y161.606 I-1.454 J-.287 E.03173
G1 X175.262 Y161.948 E.01747
G1 X172.716 Y161.948 E.08186
G1 X172.316 Y161.948 E.01286
G1 X171.916 Y161.948 E.01286
G1 X171.516 Y161.948 E.01286
G1 X171.116 Y161.948 E.01286
G1 X170.716 Y161.948 E.01286
G1 X170.316 Y161.948 E.01286
G1 X170.316 Y161.718 E.00739
G1 X170.316 Y161.318 E.01286
G1 X170.316 Y160.918 E.01286
M106 S229.5
G1 X170.316 Y160.536 E.0123
M106 S226.95
; FEATURE: Overhang wall
M106 S229.5
G1 F3000
M204 S5000
G1 X170.316 Y160.464 E.00229
M106 S226.95
; FEATURE: Inner wall
M106 S229.5
G1 F1370
M204 S8000
G1 X170.316 Y160.082 E.0123
M106 S226.95
G1 X170.316 Y159.682 E.01286
G1 X170.316 Y159.282 E.01286
G1 X170.316 Y158.882 E.01286
G1 X170.316 Y158.482 E.01286
G1 X170.316 Y158.082 E.01286
G1 X170.316 Y157.682 E.01286
G1 X170.316 Y157.476 E.00662
; COOLING_NODE: 0
M204 S10000
G1 X169.909 Y157.009 F60000
G1 F1370
M204 S8000
G1 X173.108 Y157.009 E.10287
G3 X173.988 Y156.309 I2.3 J1.989 E.03637
G3 X174.761 Y156.145 I.77 J1.727 E.02561
G1 X182.991 Y156.145 E.26463
G1 X183.391 Y156.145 E.01286
G1 X183.791 Y156.145 E.01286
G1 X184.191 Y156.145 E.01286
G1 X184.591 Y156.145 E.01286
G1 X184.991 Y156.145 E.01286
G1 X184.991 Y156.382 E.00762
G1 X184.991 Y156.782 E.01286
G1 X184.991 Y157.182 E.01286
G1 X184.991 Y157.582 E.01286
M106 S229.5
G1 X184.991 Y157.965 E.0123
M106 S226.95
; FEATURE: Overhang wall
M106 S229.5
G1 F3000
M204 S5000
G1 X184.991 Y158.036 E.00228
M106 S226.95
; FEATURE: Inner wall
M106 S229.5
G1 F1370
M204 S8000
G1 X184.991 Y158.418 E.0123
M106 S226.95
G1 X184.991 Y158.818 E.01286
G1 X184.991 Y159.218 E.01286
G1 X184.991 Y159.618 E.01286
G1 X184.991 Y159.855 E.00761
G1 X184.591 Y159.855 E.01286
G1 X184.191 Y159.855 E.01286
G1 X183.791 Y159.855 E.01286
G1 X183.391 Y159.855 E.01286
G1 X182.991 Y159.855 E.01286
G1 X176.734 Y159.855 E.2012
G3 X176.555 Y160.925 I-11.609 J-1.389 E.03489
G3 X175.947 Y161.916 I-1.817 J-.432 E.03803
G1 X175.491 Y162.286 E.01889
G1 X175.491 Y162.355 E.00221
G1 X171.909 Y162.355 E.11518
G1 X171.509 Y162.355 E.01286
G1 X171.109 Y162.355 E.01286
G1 X170.709 Y162.355 E.01286
G1 X170.309 Y162.355 E.01286
G1 X169.909 Y162.355 E.01286
G1 X169.909 Y162.118 E.00761
G1 X169.909 Y161.718 E.01286
G1 X169.909 Y161.318 E.01286
G1 X169.909 Y160.918 E.01286
M106 S229.5
G1 X169.909 Y160.536 E.0123
M106 S226.95
; FEATURE: Overhang wall
M106 S229.5
G1 F3000
M204 S5000
G1 X169.909 Y160.464 E.00229
M106 S226.95
; FEATURE: Inner wall
M106 S229.5
G1 F1370
M204 S8000
G1 X169.909 Y160.082 E.0123
M106 S226.95
G1 X169.909 Y159.682 E.01286
G1 X169.909 Y159.282 E.01286
G1 X169.909 Y158.882 E.01286
G1 X169.909 Y158.482 E.01286
G1 X169.909 Y158.082 E.01286
G1 X169.909 Y157.682 E.01286
G1 X169.909 Y157.282 E.01286
G1 X169.909 Y157.069 E.00684
; COOLING_NODE: 0
M204 S10000
G1 X169.502 Y157.398 F60000
G1 F1370
M204 S8000
G1 X164.602 Y157.398 E.15757
G1 X164.602 Y156.602 E.02559
G1 X172.943 Y156.602 E.26823
G3 X174.757 Y155.738 I1.878 J1.606 E.06652
G1 X183.798 Y155.738 E.29073
G1 X184.198 Y155.738 E.01286
G1 X184.598 Y155.738 E.01286
G1 X184.998 Y155.738 E.01286
G1 X185.398 Y155.738 E.01286
G1 X185.398 Y155.982 E.00785
G1 X185.398 Y156.382 E.01286
G1 X185.398 Y156.782 E.01286
G1 X185.398 Y157.182 E.01286
G1 X185.398 Y157.582 E.01286
M106 S229.5
G1 X185.398 Y157.965 E.0123
M106 S226.95
; FEATURE: Overhang wall
M106 S229.5
G1 F3000
M204 S5000
G1 X185.398 Y158.036 E.00228
M106 S226.95
; FEATURE: Inner wall
M106 S229.5
G1 F1370
M204 S8000
G1 X185.398 Y158.418 E.0123
M106 S226.95
G1 X185.398 Y158.818 E.01286
G1 X185.398 Y159.218 E.01286
G1 X185.398 Y159.618 E.01286
G1 X185.398 Y160.018 E.01286
G1 X185.398 Y160.262 E.00784
G1 X184.998 Y160.262 E.01286
G1 X184.598 Y160.262 E.01286
G1 X184.198 Y160.262 E.01286
G1 X183.798 Y160.262 E.01286
G1 X177.08 Y160.262 E.21603
G3 X176.859 Y161.316 I-4.647 J-.422 E.03472
G3 X175.898 Y162.48 I-2.394 J-.998 E.04926
G1 X175.898 Y164.898 E.07774
G1 X175.102 Y164.898 E.02559
G1 X175.102 Y162.762 E.06869
G1 X171.102 Y162.762 E.12863
G1 X170.702 Y162.762 E.01286
G1 X170.302 Y162.762 E.01286
G1 X169.902 Y162.762 E.01286
G1 X169.502 Y162.762 E.01286
G1 X169.502 Y162.518 E.00784
G1 X169.502 Y162.118 E.01286
G1 X169.502 Y161.718 E.01286
G1 X169.502 Y161.318 E.01286
G1 X169.502 Y160.918 E.01286
M106 S229.5
G1 X169.502 Y160.536 E.0123
M106 S226.95
; FEATURE: Overhang wall
M106 S229.5
G1 F3000
M204 S5000
G1 X169.502 Y160.464 E.00229
M106 S226.95
; FEATURE: Inner wall
M106 S229.5
G1 F1370
M204 S8000
G1 X169.502 Y160.082 E.0123
M106 S226.95
G1 X169.502 Y159.682 E.01286
G1 X169.502 Y159.282 E.01286
G1 X169.502 Y158.882 E.01286
G1 X169.502 Y158.482 E.01286
G1 X169.502 Y158.082 E.01286
G1 X169.502 Y157.682 E.01286
G1 X169.502 Y157.458 E.0072
; COOLING_NODE: 0
M204 S250
G1 X169.11 Y157.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1370
M204 S5000
G1 X164.21 Y157.79 E.14595
G1 X164.21 Y156.21 E.04706
G1 X172.785 Y156.21 E.25541
G3 X174.753 Y155.346 I1.974 J1.824 E.06586
G1 X184.19 Y155.346 E.28111
G1 X184.59 Y155.346 E.01191
G1 X184.99 Y155.346 E.01191
G1 X185.39 Y155.346 E.01191
G1 X185.79 Y155.346 E.01191
G1 X185.79 Y155.596 E.00743
G1 X185.79 Y155.996 E.01191
G1 X185.79 Y156.396 E.01191
G1 X185.79 Y156.796 E.01191
G1 X185.79 Y157.196 E.01191
G1 X185.79 Y157.596 E.01191
M106 S229.5
G1 X185.79 Y157.965 E.01099
M106 S226.95
; FEATURE: Overhang wall
; LINE_WIDTH: 0.45
M106 S229.5
G1 F3000
G1 X185.79 Y158.036 E.00228
M106 S226.95
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
M106 S229.5
G1 F1370
G1 X185.79 Y158.405 E.01099
M106 S226.95
G1 X185.79 Y158.805 E.01191
G1 X185.79 Y159.205 E.01191
G1 X185.79 Y159.605 E.01191
G1 X185.79 Y160.005 E.01191
G1 X185.79 Y160.405 E.01191
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X185.79 Y160.654 E.00743
G1 X185.39 Y160.654 E.01191
G1 X184.99 Y160.654 E.01191
G1 X184.59 Y160.654 E.01191
G1 X184.19 Y160.654 E.01191
G1 X177.413 Y160.654 E.20186
G3 X176.29 Y162.667 I-2.775 J-.228 E.0708
G1 X176.29 Y165.29 E.07813
G1 X174.71 Y165.29 E.04706
G1 X174.71 Y163.154 E.06363
G1 X170.71 Y163.154 E.11915
G1 X170.31 Y163.154 E.01191
G1 X169.91 Y163.154 E.01191
G1 X169.51 Y163.154 E.01191
G1 X169.11 Y163.154 E.01191
G1 X169.11 Y162.905 E.00743
G1 X169.11 Y162.505 E.01191
G1 X169.11 Y162.105 E.01191
G1 X169.11 Y161.705 E.01191
G1 X169.11 Y161.305 E.01191
G1 X169.11 Y160.905 E.01191
M106 S229.5
G1 X169.11 Y160.536 E.01099
M106 S226.95
; FEATURE: Overhang wall
; LINE_WIDTH: 0.45
M106 S229.5
G1 F3000
G1 X169.11 Y160.464 E.00229
M106 S226.95
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
M106 S229.5
G1 F1370
G1 X169.11 Y160.095 E.01099
M106 S226.95
G1 X169.11 Y159.695 E.01191
G1 X169.11 Y159.295 E.01191
G1 X169.11 Y158.895 E.01191
G1 X169.11 Y158.495 E.01191
G1 X169.11 Y158.095 E.01191
G1 X169.11 Y157.85 E.00731
; WIPE_START
G1 F5961.859
M204 S8000
G1 X167.11 Y157.826 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X169.705 Y157 Z23 F60000
G1 Z22.6
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1370
M204 S8000
G1 X164.806 Y157 E.15049
; WIPE_START
G1 F9259.259
G1 X166.806 Y157 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X170.65 Y157.726 Z23 F60000
G1 Z22.6
G1 E.8 F1800
; FEATURE: Bridge
; LINE_WIDTH: 0.4207
M106 S229.5
G1 F3000
M204 S8000
G1 X170.65 Y161.614 E.11604
G1 X171.028 Y161.614 E.01127
G1 X171.028 Y157.896 E.11097
G1 X171.406 Y157.896 E.01127
G1 X171.406 Y161.614 E.11097
G1 X171.783 Y161.614 E.01127
G1 X171.783 Y157.896 E.11097
G1 X172.132 Y157.896 E.0104
G1 X172.161 Y157.749 E.00445
G1 X172.161 Y161.614 E.11534
G1 X172.539 Y161.614 E.01127
G1 X172.539 Y157.749 E.11534
G1 X172.917 Y157.749 E.01127
G1 X172.917 Y161.614 E.11534
G1 X173.295 Y161.614 E.01127
G1 X173.295 Y157.749 E.11534
G1 X173.408 Y157.749 E.00338
G1 X173.672 Y157.493 E.01099
G1 X173.672 Y161.614 E.12298
G1 X174.05 Y161.614 E.01127
G1 X174.05 Y157.137 E.13361
G3 X174.428 Y156.94 I.867 J1.204 E.01275
G1 X174.428 Y161.614 E.13948
G1 X174.806 Y161.614 E.01127
G1 X174.806 Y156.885 E.14112
G1 X175.183 Y156.885 E.01127
G1 X175.183 Y161.579 E.14006
G1 X175.561 Y161.259 E.01477
G1 X175.561 Y156.885 E.13052
G1 X175.939 Y156.885 E.01127
G1 X175.939 Y160.129 E.09679
G1 X176.105 Y159.114 E.03067
G1 X176.317 Y159.114 E.00633
G1 X176.317 Y156.885 E.06652
G1 X176.695 Y156.885 E.01127
G1 X176.695 Y159.114 E.06652
G1 X177.072 Y159.114 E.01127
G1 X177.072 Y156.885 E.06652
G1 X177.45 Y156.885 E.01127
G1 X177.45 Y159.114 E.06652
G1 X177.828 Y159.114 E.01127
G1 X177.828 Y156.885 E.06652
G1 X178.206 Y156.885 E.01127
G1 X178.206 Y159.114 E.06652
G1 X178.583 Y159.114 E.01127
G1 X178.583 Y156.885 E.06652
G1 X178.961 Y156.885 E.01127
G1 X178.961 Y159.114 E.06652
G1 X179.339 Y159.114 E.01127
G1 X179.339 Y156.885 E.06652
G1 X179.717 Y156.885 E.01127
G1 X179.717 Y159.114 E.06652
G1 X180.095 Y159.114 E.01127
G1 X180.095 Y156.885 E.06652
G1 X180.472 Y156.885 E.01127
G1 X180.472 Y159.114 E.06652
G1 X180.85 Y159.114 E.01127
G1 X180.85 Y156.885 E.06652
G1 X181.228 Y156.885 E.01127
G1 X181.228 Y159.114 E.06652
G1 X181.606 Y159.114 E.01127
G1 X181.606 Y156.885 E.06652
G1 X181.983 Y156.885 E.01127
G1 X181.983 Y159.114 E.06652
G1 X182.361 Y159.114 E.01127
G1 X182.361 Y156.885 E.06652
G1 X182.739 Y156.885 E.01127
G1 X182.739 Y159.114 E.06652
G1 X183.117 Y159.114 E.01127
G1 X183.117 Y156.885 E.06652
G1 X183.495 Y156.885 E.01127
G1 X183.495 Y159.114 E.06652
G1 X183.872 Y159.114 E.01127
G1 X183.872 Y156.885 E.06652
G1 X184.25 Y156.885 E.01127
G1 X184.25 Y159.284 E.07158
M106 S226.95
; WIPE_START
G1 X184.25 Y157.284 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X177.713 Y161.224 Z23 F60000
G1 X175.5 Y162.558 Z23
G1 Z22.6
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.43174
G1 F1370
M204 S8000
G1 X175.5 Y164.694 E.0656
; CHANGE_LAYER
; Z_HEIGHT: 22.8
; LAYER_HEIGHT: 0.199999
; WIPE_START
G1 F9258.782
G1 X175.5 Y162.694 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 114/165
; update layer progress
M73 L114
M991 S0 P113 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z23 I.868 J-.853 P1  F60000
G1 X170.316 Y157.416 Z23
G1 Z22.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1580
M204 S8000
G1 X173.513 Y157.416 E.1028
G3 X174.1 Y156.936 I2.677 J2.676 E.02443
G3 X174.721 Y156.753 I.696 J1.218 E.02101
G1 X184.584 Y156.752 E.31714
G1 X184.584 Y159.248 E.08024
G1 X176.109 Y159.248 E.27252
G1 X175.99 Y160.637 E.04483
G3 X175.622 Y161.392 I-1.266 J-.15 E.02753
G1 X175.236 Y161.748 E.01688
G1 X170.316 Y161.748 E.1582
G1 X170.316 Y157.476 E.13736
; COOLING_NODE: 0
M204 S10000
G1 X169.909 Y157.009 F60000
G1 F1580
M204 S8000
G1 X173.363 Y157.009 E.11106
M73 P76 R6
G3 X174.278 Y156.415 I1.791 J1.757 E.03535
G3 X174.706 Y156.346 I.508 J1.803 E.014
G1 X184.991 Y156.345 E.33071
G1 X184.991 Y159.655 E.10642
G1 X176.483 Y159.655 E.2736
G3 X176.383 Y160.765 I-11.244 J-.447 E.03585
G3 X175.906 Y161.684 I-1.643 J-.27 E.03387
G1 X175.491 Y162.066 E.01814
G1 X175.491 Y162.155 E.00285
G1 X169.909 Y162.155 E.17949
G1 X169.909 Y157.069 E.16354
; COOLING_NODE: 0
M204 S10000
G1 X169.502 Y157.398 F60000
G1 F1580
M204 S8000
G1 X164.602 Y157.398 E.15757
G1 X164.602 Y156.602 E.02559
G1 X173.213 Y156.602 E.27689
G3 X174.692 Y155.939 I1.573 J1.528 E.05337
G1 X185.398 Y155.938 E.34428
G1 X185.398 Y160.062 E.1326
G1 X176.856 Y160.062 E.27467
G3 X176.743 Y161.026 I-4.839 J-.077 E.03126
G3 X175.898 Y162.245 I-2.312 J-.701 E.04848
G1 X175.898 Y164.898 E.08532
G1 X175.102 Y164.898 E.02559
G1 X175.102 Y162.562 E.07512
G1 X169.502 Y162.562 E.18008
G1 X169.502 Y157.458 E.16413
; COOLING_NODE: 0
M204 S250
G1 X169.11 Y157.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1474
M204 S5000
G1 X164.21 Y157.79 E.14595
G1 X164.21 Y156.21 E.04706
G1 X173.068 Y156.21 E.26385
G3 X174.677 Y155.547 I1.701 J1.844 E.05293
G1 X185.79 Y155.546 E.33102
G1 X185.79 Y160.454 E.14619
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X177.216 Y160.454 E.25539
G3 X176.29 Y162.417 I-2.572 J-.014 E.06673
G1 X176.29 Y165.29 E.08559
G1 X174.71 Y165.29 E.04706
G1 X174.71 Y162.954 E.06958
G1 X169.11 Y162.954 E.1668
G1 X169.11 Y157.85 E.15203
; WIPE_START
G1 F9547.055
M204 S8000
G1 X167.11 Y157.826 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X169.705 Y157 Z23.2 F60000
G1 Z22.8
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1580
M204 S8000
G1 X164.806 Y157 E.15049
; WIPE_START
G1 F9259.259
G1 X166.806 Y157 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X174.39 Y157.856 Z23.2 F60000
G1 X175.74 Y158.008 Z23.2
G1 Z22.8
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.622592
G1 F1580
M204 S8000
G1 X183.276 Y158 E.34507
; WIPE_START
G1 F6210.413
G1 X181.276 Y158.002 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z23.2 I-.297 J-1.18 P1  F60000
G1 X174.109 Y159.803 Z23.2
G1 Z22.8
G1 E.8 F1800
; LINE_WIDTH: 0.500085
G1 F1580
M204 S8000
G1 X174.159 Y159.228 E.02085
G1 X173.859 Y159.34 E.01155
G1 X173.588 Y159.355 E.0098
G1 X172.255 Y159.355 E.04814
G1 X172.255 Y159.809 E.01639
G2 X174.049 Y159.804 I.667 J-77.778 E.0648
M204 S10000
G1 X174.496 Y160.224 F60000
; LINE_WIDTH: 0.41999
G1 F1580
M204 S8000
G1 X174.607 Y158.931 E.03865
G1 X174.638 Y158.741 E.00575
G1 X174.834 Y158.294 E.01454
G3 X174.29 Y158.738 I-3.464 J-3.693 E.02094
G1 X173.794 Y158.923 E.01578
G1 X173.588 Y158.939 E.00614
G1 X171.839 Y158.939 E.05209
G1 X171.839 Y160.224 E.03828
G1 X174.436 Y160.224 E.07735
M204 S10000
G1 X174.86 Y160.397 F60000
G1 F1580
M204 S8000
G1 X175.005 Y158.828 E.04695
G1 X175.174 Y158.471 E.01176
; LINE_WIDTH: 0.441775
G1 X175.287 Y158.378 E.00461
; LINE_WIDTH: 0.485345
G1 X175.4 Y158.286 E.00511
; LINE_WIDTH: 0.528915
G1 X175.514 Y158.193 E.00561
; LINE_WIDTH: 0.572485
G1 X175.627 Y158.101 E.00612
; LINE_WIDTH: 0.616055
G1 X175.74 Y158.008 E.00662
G1 X175.571 Y157.987 E.00774
; LINE_WIDTH: 0.572485
G1 X175.401 Y157.965 E.00715
; LINE_WIDTH: 0.528915
G1 X175.231 Y157.943 E.00657
; LINE_WIDTH: 0.485345
G1 X175.062 Y157.921 E.00598
; LINE_WIDTH: 0.42039
G1 X174.892 Y157.9 E.0051
G1 X174.637 Y157.964 E.00784
G3 X174.089 Y158.418 I-3.375 J-3.51 E.02124
G1 X173.735 Y158.551 E.01128
G1 X173.588 Y158.562 E.00439
G1 X171.462 Y158.562 E.06338
G1 X171.462 Y160.602 E.0608
G1 X174.778 Y160.602 E.09885
G1 X174.838 Y160.453 E.00478
M204 S10000
G1 X175.236 Y160.429 F60000
; LINE_WIDTH: 0.41999
G1 F1580
M204 S8000
G1 X175.358 Y158.996 E.04285
G1 X175.473 Y158.7 E.00945
G1 X175.824 Y158.487 E.01223
G1 X183.815 Y158.479 E.238
G1 X183.815 Y157.522 E.02851
G1 X174.802 Y157.523 E.26844
G1 X174.444 Y157.638 E.01121
G1 X173.955 Y158.05 E.01904
G1 X173.676 Y158.178 E.00916
G1 X171.085 Y158.185 E.07717
G1 X171.085 Y160.979 E.0832
G1 X174.928 Y160.979 E.11447
G1 X175.157 Y160.726 E.01015
G1 X175.22 Y160.487 E.00737
M204 S10000
G1 X175.602 Y160.568 F60000
G1 F1580
M204 S8000
G1 X175.734 Y159.028 E.04604
G1 X175.772 Y158.93 E.00315
G1 X175.922 Y158.856 E.00497
G1 X184.192 Y158.856 E.24632
G1 X184.192 Y157.145 E.05097
G1 X174.756 Y157.146 E.28104
G1 X174.36 Y157.244 E.01216
G1 X173.711 Y157.763 E.02477
G1 X173.588 Y157.808 E.00389
G1 X170.708 Y157.808 E.08578
G1 X170.708 Y161.356 E.10566
G1 X175.079 Y161.356 E.13019
G1 X175.443 Y160.991 E.01534
G1 X175.581 Y160.624 E.01168
; WIPE_START
G1 F9547.299
G1 X175.443 Y160.991 E-.149
G1 X175.079 Y161.356 E-.19577
G1 X173.986 Y161.356 E-.41523
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.5 Y162.358 Z23.2 F60000
G1 Z22.8
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.43173
G1 F1580
M204 S8000
G1 X175.5 Y164.694 E.07174
; CHANGE_LAYER
; Z_HEIGHT: 23
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F9259.021
G1 X175.5 Y162.694 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 115/165
; update layer progress
M73 L115
M991 S0 P114 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z23.2 I.868 J-.853 P1  F60000
G1 X170.316 Y157.416 Z23.2
G1 Z23
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1564
M204 S8000
G1 X173.74 Y157.416 E.11011
G3 X174.269 Y157.071 I2.558 J3.335 E.02032
G3 X174.757 Y156.952 I.515 J1.061 E.01627
G1 X184.584 Y156.952 E.31601
G1 X184.584 Y159.048 E.06738
G1 X175.819 Y159.048 E.28184
G1 X175.797 Y160.532 E.04773
G3 X175.531 Y161.198 I-1.098 J-.053 E.0235
G1 X175.2 Y161.548 E.01547
G1 X170.316 Y161.548 E.15704
G1 X170.316 Y157.476 E.13093
; COOLING_NODE: 0
M204 S10000
G1 X169.909 Y157.009 F60000
G1 F1564
M204 S8000
G1 X173.617 Y157.009 E.11923
G3 X174.507 Y156.566 I1.395 J1.689 E.03226
G3 X174.745 Y156.545 I.254 J1.532 E.00769
G1 X184.991 Y156.545 E.32946
G1 X184.991 Y159.455 E.09356
G1 X176.22 Y159.455 E.28204
G3 X176.199 Y160.627 I-12.778 J.356 E.0377
G3 X175.834 Y161.47 I-1.457 J-.13 E.03006
G1 X175.491 Y161.833 E.01605
G1 X175.491 Y161.955 E.00393
G1 X169.909 Y161.955 E.17949
G1 X169.909 Y157.069 E.15711
; COOLING_NODE: 0
M204 S10000
G1 X169.502 Y157.398 F60000
G1 F1564
M204 S8000
G1 X164.602 Y157.398 E.15757
G1 X164.602 Y156.602 E.02559
G1 X173.494 Y156.602 E.28592
G3 X174.734 Y156.138 I1.317 J1.633 E.04333
G1 X185.398 Y156.138 E.34291
G1 X185.398 Y159.862 E.11974
G1 X176.621 Y159.862 E.28223
G3 X176.594 Y160.758 I-5.79 J.271 E.02886
G3 X175.898 Y161.995 I-2.029 J-.328 E.04658
G1 X175.898 Y164.898 E.09336
G1 X175.102 Y164.898 E.02559
G1 X175.102 Y162.362 E.08155
G1 X169.502 Y162.362 E.18008
G1 X169.502 Y157.458 E.15769
; COOLING_NODE: 0
M204 S250
G1 X169.11 Y157.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1429
M204 S5000
G1 X164.21 Y157.79 E.14595
G1 X164.21 Y156.21 E.04706
G1 X173.375 Y156.21 E.27299
G3 X174.723 Y155.746 I1.429 J1.963 E.04311
M73 P77 R6
G1 X185.79 Y155.746 E.32964
G1 X185.79 Y160.254 E.13428
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X177.007 Y160.254 E.2616
G3 X176.29 Y162.151 I-2.399 J.176 E.06235
G1 X176.29 Y165.29 E.09351
G1 X174.71 Y165.29 E.04706
G1 X174.71 Y162.754 E.07554
G1 X169.11 Y162.754 E.1668
G1 X169.11 Y157.85 E.14607
; WIPE_START
G1 F9547.055
M204 S8000
G1 X167.11 Y157.826 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X169.705 Y157 Z23.4 F60000
G1 Z23
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1564
M204 S8000
G1 X164.806 Y157 E.15049
; WIPE_START
G1 F9259.259
G1 X166.806 Y157 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X174.226 Y157.36 Z23.4 F60000
G1 Z23
G1 E.8 F1800
; FEATURE: Top surface
; LINE_WIDTH: 0.42
G1 F1564
M204 S2000
G1 X175.024 Y158.158 E.03364
G1 X175.158 Y158.292
G1 X175.11 Y158.777
G1 X174.977 Y158.644
G1 X173.906 Y157.573 E.0451
G1 X173.772 Y157.439
G1 X173.305 Y157.505
G1 X173.438 Y157.639
G1 X174.857 Y159.057 E.05975
G1 X174.99 Y159.191
G1 X174.832 Y159.566
G1 X174.698 Y159.432
G1 X172.905 Y157.639 E.07554
G1 X172.772 Y157.505
G1 X172.238 Y157.505
G1 X172.372 Y157.639
G1 X174.498 Y159.765 E.08956
G1 X174.632 Y159.898
G1 X174.389 Y160.189
G1 X174.256 Y160.056
G1 X171.839 Y157.639 E.10182
G1 X171.705 Y157.505
G1 X171.172 Y157.505
G1 X171.305 Y157.639
G1 X173.955 Y160.288 E.11161
G1 X174.088 Y160.422
G1 X173.747 Y160.613
G1 X173.613 Y160.48
G1 X170.772 Y157.639 E.11968
G1 X170.638 Y157.505
G1 X170.405 Y157.805
G1 X170.539 Y157.938
G1 X173.235 Y160.635 E.1136
G1 X173.369 Y160.769
G1 X172.944 Y160.877
G1 X172.81 Y160.743
G1 X170.539 Y158.472 E.09569
G1 X170.405 Y158.338
G1 X170.405 Y158.871
G1 X170.539 Y159.005
G1 X172.308 Y160.774 E.07455
G1 X172.442 Y160.908
G1 X171.909 Y160.908
G1 X171.775 Y160.774
G1 X170.539 Y159.538 E.05208
G1 X170.405 Y159.404
G1 X170.405 Y159.938
G1 X170.539 Y160.071
G1 X171.242 Y160.774 E.02962
M204 S10000
G1 X170.796 Y161.068 F60000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.59666
G1 F1564
M204 S8000
G1 X172.594 Y161.066 E.07865
; WIPE_START
G1 F6501.246
G1 X170.796 Y161.068 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X174.613 Y159.959 Z23.4 F60000
G1 Z23
G1 E.8 F1800
; LINE_WIDTH: 0.41999
G1 F1564
M204 S8000
G1 X174.245 Y160.336 E.01568
G1 X173.75 Y160.644 E.01738
G1 X173.252 Y160.849 E.01602
; LINE_WIDTH: 0.442502
G1 X173.104 Y160.902 E.00497
; LINE_WIDTH: 0.487524
G1 X172.956 Y160.956 E.00553
; LINE_WIDTH: 0.532547
G1 X172.808 Y161.01 E.00609
; LINE_WIDTH: 0.577569
G1 X172.66 Y161.064 E.00665
G1 X172.807 Y161.087 E.00628
; LINE_WIDTH: 0.532547
G1 X172.954 Y161.11 E.00575
; LINE_WIDTH: 0.487524
G1 X173.101 Y161.133 E.00522
; LINE_WIDTH: 0.420913
G1 X173.248 Y161.156 E.00444
G1 X175.028 Y161.156 E.05315
G1 X175.337 Y160.784 E.01444
G1 X175.408 Y160.342 E.01337
G1 X175.419 Y159.575 E.02289
; LINE_WIDTH: 0.418581
G3 X175.456 Y158.812 I8.537 J.026 E.02269
G1 X175.59 Y158.658 E.00606
G1 X184.192 Y158.656 E.25526
G1 X184.192 Y157.344 E.03891
G1 X175.123 Y157.345 E.2691
G1 X175.217 Y157.78 E.01321
G1 X175.227 Y158.352 E.01698
G1 X175.096 Y158.966 E.01863
G1 X174.908 Y159.472 E.01602
G1 X174.644 Y159.908 E.01513
M204 S10000
G1 X175.038 Y159.983 F60000
; LINE_WIDTH: 0.415548
G1 F1564
M204 S8000
G1 X174.783 Y160.327 E.01261
G1 X174.406 Y160.683 E.01528
G1 X174.246 Y160.781 E.0055
G1 X174.863 Y160.781 E.01815
G1 X174.995 Y160.601 E.00656
G2 X175.037 Y160.043 I-3.441 J-.54 E.01651
; WIPE_START
G1 F9661.13
G1 X174.995 Y160.601 E-.21295
G1 X174.863 Y160.781 E-.08467
G1 X174.246 Y160.781 E-.23427
G1 X174.406 Y160.683 E-.07096
G1 X174.706 Y160.399 E-.15714
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.647 Y158.234 Z23.4 F60000
G1 Z23
G1 E.8 F1800
; LINE_WIDTH: 0.510019
G1 F1564
M204 S8000
G1 X183.77 Y158.234 E.2997
G1 X183.77 Y157.766 E.01724
G1 X175.639 Y157.773 E.29999
G1 X175.646 Y158.174 E.0148
; WIPE_START
G1 F7707.145
G1 X175.639 Y157.773 E-.15242
G1 X177.238 Y157.771 E-.60758
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.5 Y162.158 Z23.4 F60000
G1 Z23
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.43173
G1 F1564
M204 S8000
G1 X175.5 Y164.694 E.07789
; CHANGE_LAYER
; Z_HEIGHT: 23.2
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F9259.021
G1 X175.5 Y162.694 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 116/165
; update layer progress
M73 L116
M991 S0 P115 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z23.4 I1.186 J-.274 P1  F60000
G1 X174.254 Y157.3 Z23.4
G1 Z23.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1419
M204 S8000
G1 X174.401 Y157.228 E.00526
G3 X174.593 Y157.168 I.721 J1.953 E.00648
G3 X174.751 Y157.152 I.17 J.947 E.00513
G1 X184.584 Y157.152 E.31618
G1 X184.584 Y158.848 E.05452
G1 X175.603 Y158.848 E.2888
G1 X175.597 Y160.519 E.05374
G3 X175.43 Y161.005 I-.861 J-.023 E.01678
G1 X175.165 Y161.348 E.01395
G1 X170.316 Y161.348 E.1559
G1 X170.316 Y159.652 E.05452
G1 X173.902 Y159.652 E.11531
G1 X173.902 Y157.416 E.0719
G1 X174.018 Y157.416 E.00372
G1 X174.2 Y157.327 E.00653
; COOLING_NODE: 0
M204 S10000
G1 X173.495 Y157.009 F60000
G1 F1419
M204 S8000
G1 X173.923 Y157.009 E.01377
G3 X174.742 Y156.745 I.911 J1.425 E.02797
G1 X184.991 Y156.745 E.32957
G1 X184.991 Y159.255 E.0807
G1 X176.008 Y159.255 E.28884
G1 X176.004 Y160.534 E.04113
G3 X175.758 Y161.247 I-1.282 J-.043 E.02463
G1 X175.491 Y161.591 E.014
G1 X175.491 Y161.755 E.00526
G1 X169.909 Y161.755 E.17949
G1 X169.909 Y159.245 E.0807
G1 X173.495 Y159.245 E.11531
G1 X173.495 Y157.069 E.06997
; COOLING_NODE: 0
M204 S10000
G1 X173.088 Y157.398 F60000
G1 F1419
M204 S8000
G1 X164.602 Y157.398 E.27288
G1 X164.602 Y156.602 E.02559
G1 X173.829 Y156.602 E.2967
G3 X174.733 Y156.338 I.967 J1.634 E.03059
G1 X185.398 Y156.338 E.34296
G1 X185.398 Y159.662 E.10688
G1 X176.414 Y159.662 E.28889
G1 X176.411 Y160.549 E.02851
G3 X175.898 Y161.731 I-1.842 J-.097 E.04232
G1 X175.898 Y164.898 E.10185
G1 X175.102 Y164.898 E.02559
G1 X175.102 Y162.162 E.08798
G1 X169.502 Y162.162 E.18008
G1 X169.502 Y158.838 E.10688
G1 X173.088 Y158.838 E.11531
G1 X173.088 Y157.458 E.04438
; COOLING_NODE: 0
M204 S250
G1 X172.696 Y157.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1365
M204 S5000
G1 X164.21 Y157.79 E.25277
G1 X164.21 Y156.21 E.04706
G1 X173.738 Y156.21 E.2838
G3 X174.724 Y155.946 I1.051 J1.956 E.03067
G1 X185.79 Y155.946 E.32963
G1 X185.79 Y160.054 E.12236
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X176.805 Y160.054 E.26764
G3 X176.643 Y161.296 I-2.983 J.244 E.0376
G3 X176.29 Y161.865 I-2.081 J-.899 E.02
G1 X176.29 Y165.29 E.10203
G1 X174.71 Y165.29 E.04706
G1 X174.71 Y162.554 E.0815
G1 X169.11 Y162.554 E.1668
G1 X169.11 Y158.446 E.12236
G1 X172.696 Y158.446 E.10682
G1 X172.696 Y157.85 E.01775
; WIPE_START
G1 F9547.055
M204 S8000
G1 X170.696 Y157.836 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X173.292 Y157 Z23.6 F60000
G1 Z23.2
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1419
M204 S8000
G1 X164.806 Y157 E.26062
; WIPE_START
M73 P78 R6
G1 F9259.259
G1 X166.806 Y157 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.521 Y162.058 Z23.6 F60000
G1 X175.5 Y164.694 Z23.6
G1 Z23.2
G1 E.8 F1800
; LINE_WIDTH: 0.431767
G1 F1419
M204 S8000
G1 X175.5 Y161.958 E.08404
; WIPE_START
G1 F9258.154
G1 X175.5 Y163.958 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.164 Y160.5 Z23.6 F60000
G1 Z23.2
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.577326
G1 F1419
M204 S8000
G1 X174.158 Y160.498 E.12639
; WIPE_START
G1 F6736.462
G1 X172.158 Y160.499 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.201 Y159.977 Z23.6 F60000
G1 Z23.2
G1 E.8 F1800
; LINE_WIDTH: 0.41999
G1 F1419
M204 S8000
G1 X175.213 Y158.643 E.03975
G1 X175.267 Y158.512 E.00422
G1 X175.401 Y158.456 E.00433
G1 X184.192 Y158.456 E.26184
G1 X184.192 Y157.544 E.02715
G1 X174.77 Y157.545 E.28064
G1 X174.294 Y157.723 E.01513
G1 X174.294 Y159.857 E.06358
G1 X174.238 Y159.99 E.00429
G1 X174.106 Y160.044 E.00426
G1 X170.708 Y160.044 E.1012
G1 X170.708 Y160.956 E.02715
G1 X174.97 Y160.956 E.12693
G1 X175.168 Y160.646 E.01096
G1 X175.198 Y160.037 E.01815
M204 S10000
G1 X174.742 Y159.973 F60000
; LINE_WIDTH: 0.578686
G1 F1419
M204 S8000
G2 X174.753 Y158.699 I-13.964 J-.757 E.05396
; WIPE_START
G1 F6719.355
G1 X174.742 Y159.973 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X174.742 Y159.973 Z23.2 F60000
G1 E.8 F1800
; LINE_WIDTH: 0.562478
G1 F1419
M204 S8000
G1 X174.682 Y160.044 E.00383
; LINE_WIDTH: 0.521233
G1 X174.622 Y160.116 E.00352
; LINE_WIDTH: 0.479988
G1 X174.562 Y160.187 E.00322
; LINE_WIDTH: 0.438743
G1 X174.502 Y160.258 E.00291
; LINE_WIDTH: 0.43923
G1 X174.431 Y160.317 E.00289
; LINE_WIDTH: 0.48145
G1 X174.36 Y160.377 E.0032
; LINE_WIDTH: 0.52367
G1 X174.289 Y160.436 E.00351
; LINE_WIDTH: 0.56589
G1 X174.218 Y160.495 E.00382
G1 X174.345 Y160.516 E.00531
; LINE_WIDTH: 0.52367
G1 X174.472 Y160.537 E.00488
; LINE_WIDTH: 0.48145
G1 X174.598 Y160.558 E.00445
; LINE_WIDTH: 0.425473
G2 X174.802 Y160.551 I.095 J-.181 E.00646
G1 X174.821 Y160.394 E.00478
; LINE_WIDTH: 0.438743
G1 X174.804 Y160.303 E.00287
; LINE_WIDTH: 0.479988
G1 X174.787 Y160.213 E.00317
; LINE_WIDTH: 0.521233
G1 X174.77 Y160.122 E.00347
; LINE_WIDTH: 0.562478
G1 X174.753 Y160.032 E.00377
; WIPE_START
G1 F6928.973
G1 X174.77 Y160.122 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X174.753 Y158.639 Z23.6 F60000
G1 Z23.2
G1 E.8 F1800
; LINE_WIDTH: 0.56387
G1 F1419
M204 S8000
G1 X174.814 Y158.54 E.00476
; LINE_WIDTH: 0.52349
G1 X174.875 Y158.442 E.00439
; LINE_WIDTH: 0.48311
G1 X174.937 Y158.344 E.00402
; LINE_WIDTH: 0.44273
G1 X174.998 Y158.246 E.00365
; LINE_WIDTH: 0.443075
G1 X175.07 Y158.186 E.00299
; LINE_WIDTH: 0.484145
G1 X175.143 Y158.125 E.00329
; LINE_WIDTH: 0.525215
G1 X175.216 Y158.065 E.0036
; LINE_WIDTH: 0.566285
G1 X175.289 Y158.005 E.00391
G1 X175.164 Y157.984 E.00522
; LINE_WIDTH: 0.525215
G1 X175.04 Y157.964 E.00481
; LINE_WIDTH: 0.484145
G1 X174.915 Y157.943 E.0044
; LINE_WIDTH: 0.432799
G2 X174.673 Y157.97 I-.099 J.213 E.00789
; LINE_WIDTH: 0.44273
G1 X174.691 Y158.122 E.00484
; LINE_WIDTH: 0.48311
G1 X174.709 Y158.275 E.00533
; LINE_WIDTH: 0.52349
G1 X174.728 Y158.427 E.00582
; LINE_WIDTH: 0.56387
G1 X174.746 Y158.579 E.00631
M204 S10000
G1 X175.289 Y158.005 F60000
; LINE_WIDTH: 0.577185
G1 F1419
M204 S8000
G1 X183.676 Y158 E.35396
; CHANGE_LAYER
; Z_HEIGHT: 23.4
; LAYER_HEIGHT: 0.199999
; WIPE_START
G1 F6738.237
G1 X181.676 Y158.001 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 117/165
; update layer progress
M73 L117
M991 S0 P116 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z23.6 I.094 J-1.213 P1  F60000
G1 X174.102 Y157.416 Z23.6
G1 Z23.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1304
M204 S8000
G2 X174.671 Y157.358 I.072 J-2.098 E.01844
G3 X174.772 Y157.352 I.096 J.833 E.00325
G1 X184.584 Y157.352 E.31552
G1 X184.584 Y158.648 E.04166
G1 X175.405 Y158.648 E.29516
G1 X175.395 Y160.538 E.06079
G3 X175.33 Y160.786 I-.697 J-.052 E.00828
G1 X175.127 Y161.148 E.01335
G1 X170.316 Y161.148 E.15468
G1 X170.316 Y159.852 E.04166
G1 X174.102 Y159.852 E.12175
G1 X174.102 Y157.476 E.0764
; COOLING_NODE: 0
M204 S10000
G1 X173.695 Y157.009 F60000
G1 F1304
M204 S8000
G1 X174.349 Y157.009 E.02102
G3 X174.766 Y156.945 I.463 J1.626 E.01359
G1 X184.991 Y156.945 E.32881
G1 X184.991 Y159.055 E.06784
G1 X175.81 Y159.055 E.29523
G1 X175.802 Y160.558 E.04832
G3 X175.694 Y160.969 I-1.12 J-.076 E.01378
G1 X175.491 Y161.33 E.01332
G1 X175.491 Y161.555 E.00722
G1 X169.909 Y161.555 E.17949
G1 X169.909 Y159.445 E.06784
G1 X173.695 Y159.445 E.12175
G1 X173.695 Y157.069 E.0764
; COOLING_NODE: 0
M204 S10000
G1 X173.288 Y157.398 F60000
G1 F1304
M204 S8000
G1 X164.602 Y157.398 E.27931
G1 X164.602 Y156.602 E.02559
G1 X174.305 Y156.602 E.31202
G3 X174.759 Y156.538 I.509 J1.969 E.01479
G1 X185.398 Y156.538 E.34209
G1 X185.398 Y159.462 E.09402
G1 X176.215 Y159.462 E.29529
G1 X176.209 Y160.577 E.03585
G3 X175.898 Y161.437 I-1.81 J-.169 E.02973
G1 X175.898 Y164.898 E.1113
G1 X175.102 Y164.898 E.02559
G1 X175.102 Y161.962 E.09441
G1 X169.502 Y161.962 E.18008
G1 X169.502 Y159.038 E.09402
G1 X173.288 Y159.038 E.12175
G1 X173.288 Y157.458 E.05081
; COOLING_NODE: 0
M204 S250
G1 X172.896 Y157.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1304
M204 S5000
G1 X164.21 Y157.79 E.25873
G1 X164.21 Y156.21 E.04706
G1 X174.263 Y156.21 E.29944
G3 X174.753 Y156.146 I.557 J2.36 E.01476
G1 X185.79 Y156.146 E.32874
G1 X185.79 Y159.854 E.11045
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X176.605 Y159.854 E.27359
G1 X176.601 Y160.596 E.02209
M73 P78 R5
G3 X176.29 Y161.539 I-2.134 J-.18 E.02988
G1 X176.29 Y165.29 E.11172
G1 X174.71 Y165.29 E.04706
G1 X174.71 Y162.354 E.08745
G1 X169.11 Y162.354 E.1668
G1 X169.11 Y158.646 E.11045
G1 X172.896 Y158.646 E.11277
G1 X172.896 Y157.85 E.02371
; WIPE_START
G1 F9547.055
M204 S8000
G1 X170.896 Y157.836 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X173.492 Y157 Z23.8 F60000
G1 Z23.4
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1304
M204 S8000
G1 X164.806 Y157 E.26677
; WIPE_START
G1 F9259.259
G1 X166.806 Y157 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X173.953 Y159.677 Z23.8 F60000
G1 X174.97 Y160.057 Z23.8
G1 Z23.4
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.488575
G1 F1304
M204 S8000
G1 X174.978 Y158.443 E.05684
; LINE_WIDTH: 0.509998
G1 X174.997 Y158.352 E.00341
; LINE_WIDTH: 0.533263
G1 X175.016 Y158.261 E.00358
G1 X175.203 Y158.222 E.0074
; LINE_WIDTH: 0.487145
G1 X184.158 Y158.222 E.31425
G1 X184.158 Y157.778 E.01559
G1 X175.203 Y157.778 E.31425
; LINE_WIDTH: 0.506825
G1 X174.885 Y157.813 E.01172
; LINE_WIDTH: 0.534764
G1 X174.567 Y157.849 E.01242
G1 X174.53 Y158.441 E.02306
; LINE_WIDTH: 0.488575
G1 X174.527 Y160.056 E.05684
; LINE_WIDTH: 0.50478
G1 X174.508 Y160.148 E.00345
; LINE_WIDTH: 0.530652
G1 X174.488 Y160.241 E.00364
G1 X174.306 Y160.278 E.00716
; LINE_WIDTH: 0.48715
G1 X170.742 Y160.278 E.12506
G1 X170.742 Y160.722 E.01559
G1 X174.306 Y160.722 E.12506
; LINE_WIDTH: 0.505815
G1 X174.573 Y160.703 E.00981
; LINE_WIDTH: 0.552546
G1 X174.841 Y160.685 E.0108
G1 X174.929 Y160.427 E.01096
; LINE_WIDTH: 0.5428
G1 X174.946 Y160.272 E.00616
; LINE_WIDTH: 0.50478
G1 X174.964 Y160.117 E.00569
; WIPE_START
G1 F7794.57
G1 X174.946 Y160.272 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.5 Y161.758 Z23.8 F60000
G1 Z23.4
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.43173
G1 F1304
M204 S8000
G1 X175.5 Y164.694 E.09017
; CHANGE_LAYER
; Z_HEIGHT: 23.6
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F9259.021
G1 X175.5 Y162.694 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 118/165
; update layer progress
M73 L118
M991 S0 P117 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z23.8 I1.187 J-.269 P1  F60000
G1 X174.302 Y157.416 Z23.8
G1 Z23.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1226
M204 S8000
G1 X175.084 Y157.416 E.02513
G1 X175.084 Y157.552 E.00437
G1 X184.584 Y157.552 E.30549
G1 X184.584 Y158.448 E.0288
G1 X175.198 Y158.448 E.30181
G1 X175.186 Y160.598 E.06915
G3 X175.073 Y160.948 I-2.719 J-.686 E.01182
G1 X170.316 Y160.948 E.15296
M73 P79 R5
G1 X170.316 Y160.052 E.0288
G1 X174.302 Y160.052 E.12818
G1 X174.302 Y157.476 E.08284
; COOLING_NODE: 0
M204 S10000
G1 X173.895 Y157.009 F60000
G1 F1226
M204 S8000
G1 X175.491 Y157.009 E.05131
G1 X175.491 Y157.145 E.00437
G1 X184.991 Y157.145 E.30549
G1 X184.991 Y158.855 E.05498
G1 X175.605 Y158.855 E.30181
G1 X175.605 Y160.5 E.05291
G3 X175.491 Y160.98 I-1.26 J-.045 E.01597
G1 X175.491 Y161.355 E.01204
G1 X169.909 Y161.355 E.17949
G1 X169.909 Y159.645 E.05498
G1 X173.895 Y159.645 E.12818
G1 X173.895 Y157.069 E.08284
; COOLING_NODE: 0
M204 S10000
G1 X173.488 Y157.398 F60000
G1 F1226
M204 S8000
G1 X164.602 Y157.398 E.28574
G1 X164.602 Y156.602 E.02559
G1 X175.898 Y156.602 E.36323
G1 X175.898 Y156.738 E.00437
G1 X185.398 Y156.738 E.30549
G1 X185.398 Y159.262 E.08116
G1 X176.012 Y159.262 E.30182
G1 X176.012 Y160.51 E.04014
G3 X175.898 Y161.045 I-1.504 J-.04 E.0177
G1 X175.898 Y164.898 E.12388
G1 X175.102 Y164.898 E.02559
G1 X175.102 Y161.762 E.10084
G1 X169.502 Y161.762 E.18008
G1 X169.502 Y159.238 E.08116
G1 X173.488 Y159.238 E.12818
G1 X173.488 Y157.458 E.05724
; COOLING_NODE: 0
M204 S250
G1 X173.096 Y157.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1226
M204 S5000
G1 X164.21 Y157.79 E.26468
G1 X164.21 Y156.21 E.04706
G1 X176.29 Y156.21 E.35982
G1 X176.29 Y156.346 E.00405
G1 X185.79 Y156.346 E.28297
G1 X185.79 Y159.654 E.09853
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X176.404 Y159.654 E.27958
G3 X176.398 Y160.64 I-10.214 J.43 E.02938
G3 X176.29 Y161.108 I-2.207 J-.262 E.01435
G1 X176.29 Y165.29 E.12456
G1 X174.71 Y165.29 E.04706
G1 X174.71 Y162.154 E.09341
G1 X169.11 Y162.154 E.1668
G1 X169.11 Y158.846 E.09853
G1 X173.096 Y158.846 E.11873
G1 X173.096 Y157.85 E.02967
; WIPE_START
G1 F9547.055
M204 S8000
G1 X171.096 Y157.836 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X173.692 Y157 Z24 F60000
G1 Z23.6
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1226
M204 S8000
G1 X164.806 Y157 E.27291
; WIPE_START
G1 F9259.259
G1 X166.806 Y157 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.521 Y162.058 Z24 F60000
G1 X175.5 Y164.694 Z24
G1 Z23.6
G1 E.8 F1800
; LINE_WIDTH: 0.43173
G1 F1226
M204 S8000
G1 X175.5 Y161.558 E.09631
; WIPE_START
G1 F9259.021
G1 X175.5 Y163.558 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X170.52 Y160.5 Z24 F60000
G1 Z23.6
G1 E.8 F1800
; LINE_WIDTH: 0.531898
G1 F1226
M204 S8000
G1 X174.506 Y160.5 E.15396
G1 X174.607 Y160.479 E.00399
; LINE_WIDTH: 0.594135
G1 X174.708 Y160.458 E.00449
M204 S10000
G1 X174.931 Y160.728 F60000
; LINE_WIDTH: 0.525329
G1 F1226
M204 S8000
G2 X174.738 Y160.489 I-1.679 J1.161 E.0117
; LINE_WIDTH: 0.56631
G1 X174.726 Y160.476 E.00075
; LINE_WIDTH: 0.594744
G1 X174.708 Y160.458 E.00109
G1 X174.729 Y160.357 E.0045
; LINE_WIDTH: 0.552201
G1 X174.75 Y160.256 E.00416
; LINE_WIDTH: 0.532735
G1 X174.75 Y158.244 E.07783
G1 X174.773 Y158.139 E.00417
; LINE_WIDTH: 0.600177
G1 X174.796 Y158.033 E.00475
; LINE_WIDTH: 0.606752
G1 X174.838 Y158.023 E.00193
; LINE_WIDTH: 0.574374
G1 X174.88 Y158.013 E.00182
; LINE_WIDTH: 0.531523
G1 X174.995 Y158 E.00445
G1 X184.38 Y158 E.36225
; CHANGE_LAYER
; Z_HEIGHT: 23.8
; LAYER_HEIGHT: 0.199999
; WIPE_START
G1 F7367.951
G1 X182.38 Y158 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 119/165
; update layer progress
M73 L119
M991 S0 P118 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z24 I.09 J-1.214 P1  F60000
G1 X174.502 Y157.416 Z24
G1 Z23.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1232
M204 S8000
G1 X175.084 Y157.416 E.0187
G1 X175.084 Y157.752 E.01081
G1 X184.584 Y157.752 E.30549
G1 X184.584 Y158.248 E.01593
G1 X175.084 Y158.248 E.30549
G1 X175.084 Y160.748 E.08039
G1 X170.316 Y160.748 E.15331
G1 X170.316 Y160.252 E.01593
G1 X174.502 Y160.252 E.13461
G1 X174.502 Y157.476 E.08927
; COOLING_NODE: 0
M204 S10000
G1 X174.095 Y157.009 F60000
G1 F1232
M204 S8000
G1 X175.491 Y157.009 E.04488
G1 X175.491 Y157.345 E.01081
G1 X184.991 Y157.345 E.30549
G1 X184.991 Y158.655 E.04211
G1 X175.491 Y158.655 E.30549
G1 X175.491 Y161.155 E.08039
G1 X169.909 Y161.155 E.17949
G1 X169.909 Y159.845 E.04211
G1 X174.095 Y159.845 E.13461
G1 X174.095 Y157.069 E.08927
; COOLING_NODE: 0
M204 S10000
G1 X173.688 Y157.398 F60000
G1 F1232
M204 S8000
G1 X164.602 Y157.398 E.29217
G1 X164.602 Y156.602 E.02559
G1 X175.898 Y156.602 E.36323
G1 X175.898 Y156.938 E.01081
G1 X185.398 Y156.938 E.30549
G1 X185.398 Y159.062 E.06829
G1 X175.898 Y159.062 E.30549
G1 X175.898 Y164.898 E.18767
G1 X175.102 Y164.898 E.02559
M73 P80 R5
G1 X175.102 Y161.562 E.10727
G1 X169.502 Y161.562 E.18008
G1 X169.502 Y159.438 E.06829
G1 X173.688 Y159.438 E.13461
G1 X173.688 Y157.458 E.06368
; COOLING_NODE: 0
M204 S250
G1 X173.296 Y157.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1232
M204 S5000
G1 X164.21 Y157.79 E.27064
G1 X164.21 Y156.21 E.04706
G1 X176.29 Y156.21 E.35982
G1 X176.29 Y156.546 E.01001
G1 X185.79 Y156.546 E.28297
G1 X185.79 Y159.454 E.08662
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X176.29 Y159.454 E.28297
G1 X176.29 Y165.29 E.17384
G1 X174.71 Y165.29 E.04706
G1 X174.71 Y161.954 E.09937
G1 X169.11 Y161.954 E.1668
G1 X169.11 Y159.046 E.08662
G1 X173.296 Y159.046 E.12469
G1 X173.296 Y157.85 E.03563
; WIPE_START
G1 F9547.055
M204 S8000
G1 X171.296 Y157.837 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X173.892 Y157 Z24.2 F60000
G1 Z23.8
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1232
M204 S8000
G1 X164.806 Y157 E.27905
; WIPE_START
G1 F9259.259
G1 X166.806 Y157 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.521 Y162.058 Z24.2 F60000
G1 X175.5 Y164.694 Z24.2
G1 Z23.8
G1 E.8 F1800
; LINE_WIDTH: 0.43173
G1 F1232
M204 S8000
G1 X175.5 Y161.358 E.10246
; WIPE_START
G1 F9259.021
G1 X175.5 Y163.358 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X170.52 Y160.5 Z24.2 F60000
G1 Z23.8
G1 E.8 F1800
; LINE_WIDTH: 0.131617
G1 F1232
M204 S8000
G1 X174.706 Y160.5 E.02933
G1 X174.749 Y160.478 E.00034
; LINE_WIDTH: 0.195905
G1 X174.793 Y160.457 E.00059
; LINE_WIDTH: 0.217522
G1 X174.799 Y158 E.03389
M204 S10000
G1 X174.793 Y157.62 F60000
; LINE_WIDTH: 0.216742
G1 F1232
M204 S8000
G2 X174.799 Y158 I1.505 J.168 E.00524
G1 X174.839 Y158 E.00056
; LINE_WIDTH: 0.155676
G1 X174.88 Y158 E.00036
; LINE_WIDTH: 0.13136
G1 X184.38 Y158 E.06637
; CHANGE_LAYER
; Z_HEIGHT: 24
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F15000
G1 X182.38 Y158 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 120/165
; update layer progress
M73 L120
M991 S0 P119 ;notify layer change

M106 S229.5
; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z24.2 I.092 J-1.213 P1  F60000
G1 X174.702 Y157.416 Z24.2
G1 Z24
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X175.084 Y157.416 E.01227
G1 X175.084 Y160.548 E.1007
G1 X174.702 Y160.548 E.01227
G1 X174.702 Y157.476 E.09877
; COOLING_NODE: 0
M204 S10000
G1 X174.295 Y157.009 F60000
G1 F1200
M204 S8000
G1 X175.491 Y157.009 E.03845
G1 X175.491 Y157.545 E.01724
G1 X184.991 Y157.545 E.30549
G1 X184.991 Y158.455 E.02925
G1 X175.491 Y158.455 E.30549
G1 X175.491 Y160.955 E.08039
G1 X169.909 Y160.955 E.17949
G1 X169.909 Y160.045 E.02925
G1 X174.295 Y160.045 E.14104
G1 X174.295 Y157.069 E.0957
; COOLING_NODE: 0
M204 S10000
G1 X173.888 Y157.398 F60000
G1 F1200
M204 S8000
G1 X164.602 Y157.398 E.29861
G1 X164.602 Y156.602 E.02559
G1 X175.898 Y156.602 E.36323
G1 X175.898 Y157.138 E.01724
G1 X185.398 Y157.138 E.30549
G1 X185.398 Y158.862 E.05543
G1 X175.898 Y158.862 E.30549
G1 X175.898 Y164.898 E.1941
G1 X175.102 Y164.898 E.02559
G1 X175.102 Y161.362 E.11371
G1 X169.502 Y161.362 E.18008
G1 X169.502 Y159.638 E.05543
G1 X173.888 Y159.638 E.14104
G1 X173.888 Y157.458 E.07011
; COOLING_NODE: 0
M204 S250
G1 X173.496 Y157.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X164.21 Y157.79 E.2766
G1 X164.21 Y156.21 E.04706
G1 X176.29 Y156.21 E.35982
G1 X176.29 Y156.746 E.01597
G1 X185.79 Y156.746 E.28297
G1 X185.79 Y159.254 E.0747
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X176.29 Y159.254 E.28297
G1 X176.29 Y165.29 E.17979
G1 X174.71 Y165.29 E.04706
G1 X174.71 Y161.754 E.10533
G1 X169.11 Y161.754 E.1668
G1 X169.11 Y159.246 E.0747
G1 X173.496 Y159.246 E.13065
G1 X173.496 Y157.85 E.04158
; WIPE_START
G1 F9547.055
M204 S8000
G1 X171.496 Y157.837 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X174.092 Y157 Z24.4 F60000
G1 Z24
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1200
M204 S8000
G1 X164.806 Y157 E.28519
; WIPE_START
G1 F9259.259
G1 X166.806 Y157 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
M73 P81 R5
G1 X172.521 Y162.058 Z24.4 F60000
G1 X175.5 Y164.694 Z24.4
G1 Z24
G1 E.8 F1800
; LINE_WIDTH: 0.43173
G1 F1200
M204 S8000
G1 X175.5 Y161.158 E.1086
; WIPE_START
G1 F9259.021
G1 X175.5 Y163.158 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X174.499 Y160.5 Z24.4 F60000
G1 Z24
G1 E.8 F1800
; LINE_WIDTH: 0.54551
G1 F1200
M204 S8000
G1 X170.113 Y160.5 E.17413
; WIPE_START
G1 F7162.897
G1 X172.113 Y160.5 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.287 Y158 Z24.4 F60000
G1 Z24
G1 E.8 F1800
; LINE_WIDTH: 0.5455
G1 F1200
M204 S8000
G1 X184.787 Y158 E.37715
; CHANGE_LAYER
; Z_HEIGHT: 24.2
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F7163.039
G1 X182.787 Y158 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 121/165
; update layer progress
M73 L121
M991 S0 P120 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z24.4 I.144 J-1.208 P1  F60000
G1 X174.495 Y157.009 Z24.4
G1 Z24.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X175.491 Y157.009 E.03202
G1 X175.491 Y157.745 E.02367
G1 X184.991 Y157.745 E.30549
G1 X184.991 Y158.255 E.01639
G1 X175.491 Y158.255 E.30549
G1 X175.491 Y160.755 E.08039
G1 X169.909 Y160.755 E.17949
G1 X169.909 Y160.245 E.01639
G1 X174.495 Y160.245 E.14747
G1 X174.495 Y157.069 E.10213
; COOLING_NODE: 0
M204 S10000
G1 X174.088 Y157.398 F60000
G1 F1200
M204 S8000
G1 X164.602 Y157.398 E.30504
G1 X164.602 Y156.602 E.02559
G1 X175.898 Y156.602 E.36323
G1 X175.898 Y157.338 E.02367
G1 X185.398 Y157.338 E.30549
G1 X185.398 Y158.662 E.04257
G1 X175.898 Y158.662 E.30549
G1 X175.898 Y164.898 E.20053
G1 X175.102 Y164.898 E.02559
G1 X175.102 Y161.162 E.12014
G1 X169.502 Y161.162 E.18008
G1 X169.502 Y159.838 E.04257
G1 X174.088 Y159.838 E.14747
G1 X174.088 Y157.458 E.07654
; COOLING_NODE: 0
M204 S250
G1 X173.696 Y157.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X164.21 Y157.79 E.28256
G1 X164.21 Y156.21 E.04706
G1 X176.29 Y156.21 E.35982
G1 X176.29 Y156.946 E.02192
G1 X185.79 Y156.946 E.28297
G1 X185.79 Y159.054 E.06279
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X176.29 Y159.054 E.28297
G1 X176.29 Y165.29 E.18575
G1 X174.71 Y165.29 E.04706
G1 X174.71 Y161.554 E.11128
G1 X169.11 Y161.554 E.1668
G1 X169.11 Y159.446 E.06279
G1 X173.696 Y159.446 E.1366
G1 X173.696 Y157.85 E.04754
; WIPE_START
G1 F9547.055
M204 S8000
G1 X171.696 Y157.837 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X174.292 Y157 Z24.6 F60000
G1 Z24.2
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1200
M204 S8000
G1 X164.806 Y157 E.29134
; WIPE_START
G1 F9259.259
G1 X166.806 Y157 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.521 Y162.058 Z24.6 F60000
G1 X175.5 Y164.694 Z24.6
G1 Z24.2
G1 E.8 F1800
; LINE_WIDTH: 0.43173
G1 F1200
M204 S8000
G1 X175.5 Y160.958 E.11474
; WIPE_START
G1 F9259.021
G1 X175.5 Y162.958 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X170.113 Y160.5 Z24.6 F60000
G1 Z24.2
G1 E.8 F1800
; LINE_WIDTH: 0.146291
G1 F1200
M204 S8000
G1 X174.699 Y160.5 E.03745
G1 X174.895 Y160.402 E.00179
; LINE_WIDTH: 0.1968
G1 X175.091 Y160.304 E.00267
; LINE_WIDTH: 0.231
G1 X175.287 Y160.206 E.00326
M204 S10000
G1 X174.993 Y160.551 F60000
; LINE_WIDTH: 0.631378
G1 F1200
M204 S8000
G1 X174.993 Y158.051 E.11621
G1 X174.995 Y158 E.00239
G1 X175.024 Y158 E.00136
; LINE_WIDTH: 0.562458
G1 X175.054 Y158 E.0012
; LINE_WIDTH: 0.513404
G1 X175.083 Y158 E.00109
; LINE_WIDTH: 0.46435
G1 X175.112 Y158 E.00097
; LINE_WIDTH: 0.415296
G1 X175.141 Y158 E.00086
; LINE_WIDTH: 0.366242
G1 X175.17 Y158 E.00075
; LINE_WIDTH: 0.317189
G1 X175.2 Y158 E.00063
; LINE_WIDTH: 0.268135
G1 X175.229 Y158 E.00052
; LINE_WIDTH: 0.219081
G1 X175.258 Y158 E.00041
; LINE_WIDTH: 0.170027
G1 X175.287 Y158 E.00029
; LINE_WIDTH: 0.1455
G1 X184.787 Y158 E.07698
; CHANGE_LAYER
; Z_HEIGHT: 24.4
; LAYER_HEIGHT: 0.199999
; WIPE_START
G1 F15000
G1 X182.787 Y158 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 122/165
; update layer progress
M73 L122
M991 S0 P121 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z24.6 I.148 J-1.208 P1  F60000
G1 X174.695 Y157.009 Z24.6
G1 Z24.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X175.491 Y157.009 E.02559
G1 X175.491 Y160.555 E.11402
G1 X174.695 Y160.555 E.02559
G1 X174.695 Y157.069 E.11209
; COOLING_NODE: 0
M204 S10000
G1 X174.288 Y157.398 F60000
G1 F1200
M204 S8000
G1 X164.602 Y157.398 E.31147
G1 X164.602 Y156.602 E.02559
G1 X175.898 Y156.602 E.36323
G1 X175.898 Y157.538 E.0301
G1 X185.398 Y157.538 E.30549
G1 X185.398 Y158.462 E.02971
G1 X175.898 Y158.462 E.30549
G1 X175.898 Y164.898 E.20696
G1 X175.102 Y164.898 E.02559
G1 X175.102 Y160.962 E.12657
G1 X169.502 Y160.962 E.18008
G1 X169.502 Y160.038 E.02971
G1 X174.288 Y160.038 E.1539
G1 X174.288 Y157.458 E.08297
; COOLING_NODE: 0
M204 S250
G1 X173.896 Y157.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X164.21 Y157.79 E.28851
G1 X164.21 Y156.21 E.04706
M73 P82 R5
G1 X176.29 Y156.21 E.35982
G1 X176.29 Y157.146 E.02788
G1 X185.79 Y157.146 E.28297
G1 X185.79 Y158.854 E.05087
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X176.29 Y158.854 E.28297
G1 X176.29 Y165.29 E.19171
G1 X174.71 Y165.29 E.04706
G1 X174.71 Y161.354 E.11724
G1 X169.11 Y161.354 E.1668
G1 X169.11 Y159.646 E.05087
G1 X173.896 Y159.646 E.14256
G1 X173.896 Y157.85 E.0535
; WIPE_START
G1 F9547.055
M204 S8000
G1 X171.896 Y157.838 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X174.492 Y157 Z24.8 F60000
G1 Z24.4
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1200
M204 S8000
G1 X164.806 Y157 E.29748
; WIPE_START
G1 F9259.259
G1 X166.806 Y157 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
M73 P82 R4
G1 X169.706 Y160.5 Z24.8 F60000
G1 Z24.4
G1 E.8 F1800
; LINE_WIDTH: 0.55965
G1 F1200
M204 S8000
G1 X174.492 Y160.5 E.19535
; WIPE_START
G1 F6966.888
G1 X172.492 Y160.5 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.5 Y164.694 Z24.8 F60000
G1 Z24.4
G1 E.8 F1800
; LINE_WIDTH: 0.43173
G1 F1200
M204 S8000
G1 X175.5 Y160.758 E.12089
M204 S10000
G1 X175.093 Y160.351 F60000
; LINE_WIDTH: 0.43156
G1 F1200
M204 S8000
G1 X175.093 Y157.213 E.09636
M204 S10000
G1 X175.695 Y158 F60000
; LINE_WIDTH: 0.55964
G1 F1200
M204 S8000
G1 X185.194 Y158 E.38776
; CHANGE_LAYER
; Z_HEIGHT: 24.6
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F6967.023
G1 X183.194 Y158 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 123/165
; update layer progress
M73 L123
M991 S0 P122 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z24.8 I.144 J-1.208 P1  F60000
G1 X174.895 Y157.009 Z24.8
G1 Z24.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X175.491 Y157.009 E.01916
G1 X175.491 Y160.355 E.10759
G1 X174.895 Y160.355 E.01916
G1 X174.895 Y157.069 E.10566
; COOLING_NODE: 0
M204 S10000
G1 X174.488 Y157.398 F60000
G1 F1200
M204 S8000
G1 X164.602 Y157.398 E.3179
G1 X164.602 Y156.602 E.02559
G1 X175.898 Y156.602 E.36323
G1 X175.898 Y157.738 E.03653
G1 X185.398 Y157.738 E.30549
G1 X185.398 Y158.262 E.01684
G1 X175.898 Y158.262 E.30549
G1 X175.898 Y164.898 E.21339
G1 X175.102 Y164.898 E.02559
G1 X175.102 Y160.762 E.133
G1 X169.502 Y160.762 E.18008
G1 X169.502 Y160.238 E.01684
G1 X174.488 Y160.238 E.16033
G1 X174.488 Y157.458 E.0894
; COOLING_NODE: 0
M204 S250
G1 X174.096 Y157.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X164.21 Y157.79 E.29447
G1 X164.21 Y156.21 E.04706
G1 X176.29 Y156.21 E.35982
G1 X176.29 Y157.346 E.03384
G1 X185.79 Y157.346 E.28297
G1 X185.79 Y158.654 E.03896
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X176.29 Y158.654 E.28297
G1 X176.29 Y165.29 E.19767
G1 X174.71 Y165.29 E.04706
G1 X174.71 Y161.154 E.1232
G1 X169.11 Y161.154 E.1668
G1 X169.11 Y159.846 E.03896
G1 X174.096 Y159.846 E.14852
G1 X174.096 Y157.85 E.05945
; WIPE_START
G1 F9547.055
M204 S8000
G1 X172.096 Y157.838 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X174.692 Y157 Z25 F60000
G1 Z24.6
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1200
M204 S8000
G1 X164.806 Y157 E.30362
; WIPE_START
G1 F9259.259
G1 X166.806 Y157 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X169.706 Y160.5 Z25 F60000
G1 Z24.6
G1 E.8 F1800
; LINE_WIDTH: 0.15965
G1 F1200
M204 S8000
G1 X174.692 Y160.5 E.04597
; WIPE_START
G1 F15000
G1 X172.692 Y160.5 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.5 Y164.694 Z25 F60000
G1 Z24.6
G1 E.8 F1800
; LINE_WIDTH: 0.43173
G1 F1200
M204 S8000
G1 X175.5 Y160.558 E.12703
M204 S10000
G1 X175.193 Y160.151 F60000
; LINE_WIDTH: 0.23155
G1 F1200
M204 S8000
G1 X175.193 Y157.213 E.04379
M204 S10000
G1 X175.695 Y158 F60000
; LINE_WIDTH: 0.15964
G1 F1200
M204 S8000
G1 X185.194 Y158 E.08759
; CHANGE_LAYER
; Z_HEIGHT: 24.8
; LAYER_HEIGHT: 0.199999
; WIPE_START
G1 F15000
G1 X183.194 Y158 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 124/165
; update layer progress
M73 L124
M991 S0 P123 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z25 I.148 J-1.208 P1  F60000
G1 X175.095 Y157.009 Z25
G1 Z24.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X175.491 Y157.009 E.01272
G1 X175.491 Y160.155 E.10115
G1 X175.095 Y160.155 E.01272
G1 X175.095 Y157.069 E.09922
; COOLING_NODE: 0
M204 S10000
G1 X174.688 Y157.398 F60000
G1 F1200
M204 S8000
G1 X164.602 Y157.398 E.32433
G1 X164.602 Y156.602 E.02559
G1 X175.898 Y156.602 E.36323
G1 X175.898 Y164.898 E.26677
G1 X175.102 Y164.898 E.02559
G1 X175.102 Y160.562 E.13943
M73 P83 R4
G1 X174.688 Y160.562 E.01331
G1 X174.688 Y157.458 E.09981
; COOLING_NODE: 0
M204 S250
G1 X174.296 Y157.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X164.21 Y157.79 E.30043
G1 X164.21 Y156.21 E.04706
G1 X176.29 Y156.21 E.35982
G1 X176.29 Y157.546 E.0398
G1 X185.79 Y157.546 E.28297
G1 X185.79 Y158.454 E.02704
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X176.29 Y158.454 E.28297
G1 X176.29 Y165.29 E.20362
G1 X174.71 Y165.29 E.04706
G1 X174.71 Y160.954 E.12916
G1 X169.11 Y160.954 E.1668
G1 X169.11 Y160.046 E.02704
G1 X174.296 Y160.046 E.15447
G1 X174.296 Y157.85 E.06541
; WIPE_START
G1 F9547.055
M204 S8000
G1 X172.296 Y157.838 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X174.892 Y157 Z25.2 F60000
G1 Z24.8
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1200
M204 S8000
G1 X164.806 Y157 E.30976
; WIPE_START
G1 F9259.259
G1 X166.806 Y157 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X169.306 Y160.5 Z25.2 F60000
G1 Z24.8
G1 E.8 F1800
; LINE_WIDTH: 0.55878
G1 F1200
M204 S8000
G1 X174.492 Y160.5 E.21132
; WIPE_START
G1 F6978.638
G1 X172.492 Y160.5 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.5 Y160.358 Z25.2 F60000
G1 Z24.8
G1 E.8 F1800
; LINE_WIDTH: 0.43173
G1 F1200
M204 S8000
G1 X175.5 Y164.694 E.13317
; WIPE_START
G1 F9259.021
G1 X175.5 Y162.694 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X176.094 Y158 Z25.2 F60000
G1 Z24.8
G1 E.8 F1800
; LINE_WIDTH: 0.55878
G1 F1200
M204 S8000
G1 X185.594 Y158 E.38711
; CHANGE_LAYER
; Z_HEIGHT: 25
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F6978.638
G1 X183.594 Y158 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 125/165
; update layer progress
M73 L125
M991 S0 P124 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z25.2 I.084 J-1.214 P1  F60000
G1 X174.888 Y157.398 Z25.2
G1 Z25
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X164.602 Y157.398 E.33076
G1 X164.602 Y156.602 E.02559
G1 X175.898 Y156.602 E.36323
G1 X175.898 Y164.898 E.26677
G1 X175.102 Y164.898 E.02559
G1 X175.102 Y160.362 E.14586
G1 X174.888 Y160.362 E.00688
G1 X174.888 Y157.458 E.09338
; COOLING_NODE: 0
M204 S250
G1 X174.496 Y157.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X164.21 Y157.79 E.30639
G1 X164.21 Y156.21 E.04706
G1 X176.29 Y156.21 E.35982
G1 X176.29 Y157.746 E.04575
G1 X185.79 Y157.746 E.28297
G1 X185.79 Y158.254 E.01513
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X176.29 Y158.254 E.28297
G1 X176.29 Y165.29 E.20958
G1 X174.71 Y165.29 E.04706
G1 X174.71 Y160.754 E.13511
G1 X169.11 Y160.754 E.1668
G1 X169.11 Y160.246 E.01513
G1 X174.496 Y160.246 E.16043
G1 X174.496 Y157.85 E.07137
; WIPE_START
G1 F9547.055
M204 S8000
G1 X172.496 Y157.838 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.151 Y157.022 Z25.4 F60000
G1 Z25
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.431858
G1 F1200
M204 S8000
G1 X175.092 Y157 E.00194
G1 X164.806 Y157 E.31602
; WIPE_START
G1 F9255.982
G1 X166.806 Y157 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X169.306 Y160.5 Z25.4 F60000
G1 Z25
G1 E.8 F1800
; LINE_WIDTH: 0.15878
G1 F1200
M204 S8000
G1 X174.692 Y160.5 E.04929
; WIPE_START
G1 F15000
G1 X172.692 Y160.5 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.5 Y164.694 Z25.4 F60000
G1 Z25
G1 E.8 F1800
; LINE_WIDTH: 0.43174
G1 F1200
M204 S8000
G1 X175.5 Y160.158 E.13932
; LINE_WIDTH: 0.453136
G1 X175.479 Y160.101 E.00199
; LINE_WIDTH: 0.495928
G1 X175.457 Y160.043 E.0022
; LINE_WIDTH: 0.53872
G1 X175.436 Y159.985 E.00241
; LINE_WIDTH: 0.581512
G1 X175.414 Y159.928 E.00262
; LINE_WIDTH: 0.624304
G1 X175.393 Y159.87 E.00283
M204 S10000
G1 X175.092 Y160.127 F60000
; LINE_WIDTH: 0.492678
G1 F1200
M204 S8000
G1 X175.167 Y160.062 E.00352
; LINE_WIDTH: 0.536393
G1 X175.242 Y159.998 E.00386
; LINE_WIDTH: 0.580108
G1 X175.318 Y159.934 E.0042
; LINE_WIDTH: 0.623823
G1 X175.393 Y159.87 E.00454
; LINE_WIDTH: 0.645855
G1 X175.387 Y157.113 E.13133
; LINE_WIDTH: 0.634305
G1 X175.328 Y157.09 E.00296
; LINE_WIDTH: 0.589286
G1 X175.269 Y157.068 E.00273
; LINE_WIDTH: 0.544267
G1 X175.21 Y157.045 E.00251
; LINE_WIDTH: 0.499249
G1 X175.151 Y157.022 E.00228
; WIPE_START
G1 F7889.059
G1 X175.21 Y157.045 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X176.094 Y158 Z25.4 F60000
G1 Z25
G1 E.8 F1800
; LINE_WIDTH: 0.15878
G1 F1200
M204 S8000
G1 X185.594 Y158 E.08694
; CHANGE_LAYER
; Z_HEIGHT: 25.2
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F15000
G1 X183.594 Y158 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 126/165
; update layer progress
M73 L126
M991 S0 P125 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z25.4 I.086 J-1.214 P1  F60000
G1 X175.088 Y157.398 Z25.4
G1 Z25.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X164.602 Y157.398 E.33719
G1 X164.602 Y156.602 E.02559
G1 X175.898 Y156.602 E.36323
G1 X175.898 Y164.898 E.26677
G1 X175.102 Y164.898 E.02559
G1 X175.088 Y157.458 E.23924
; COOLING_NODE: 0
M204 S250
G1 X174.696 Y157.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X164.21 Y157.79 E.31234
M73 P84 R4
G1 X164.21 Y156.21 E.04706
G1 X176.29 Y156.21 E.35982
G1 X176.29 Y157.946 E.05171
G1 X185.79 Y157.946 E.28297
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X185.79 Y158.054 E.00321
G1 X176.29 Y158.054 E.28297
G1 X176.29 Y165.29 E.21554
G1 X174.71 Y165.29 E.04706
G1 X174.71 Y160.554 E.14107
G1 X169.11 Y160.554 E.1668
G1 X169.11 Y160.446 E.00321
G1 X174.696 Y160.446 E.16639
G1 X174.696 Y157.85 E.07733
; WIPE_START
G1 F9547.055
M204 S8000
G1 X172.696 Y157.839 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.493 Y157.194 Z25.6 F60000
G1 Z25.2
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.44569
G1 F1200
M204 S8000
G1 X175.493 Y159.885 E.0856
; LINE_WIDTH: 0.431848
G1 X175.5 Y164.694 E.14777
; WIPE_START
G1 F9256.227
G1 X175.497 Y162.694 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.292 Y159.949 Z25.6 F60000
G1 Z25.2
G1 E.8 F1800
; LINE_WIDTH: 0.0942492
G1 F1200
M204 S8000
G1 X175.317 Y159.941 E.00011
; LINE_WIDTH: 0.141107
G1 X175.342 Y159.933 E.0002
; LINE_WIDTH: 0.187965
G1 X175.367 Y159.925 E.0003
; LINE_WIDTH: 0.234823
G1 X175.392 Y159.917 E.0004
; LINE_WIDTH: 0.28168
G1 X175.417 Y159.909 E.0005
; LINE_WIDTH: 0.328538
G1 X175.443 Y159.901 E.0006
; LINE_WIDTH: 0.375396
G1 X175.468 Y159.893 E.00069
; LINE_WIDTH: 0.422254
G1 X175.493 Y159.885 E.00079
; WIPE_START
G1 F9490.337
G1 X175.468 Y159.893 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.493 Y157.194 Z25.6 F60000
G1 Z25.2
G1 E.8 F1800
; LINE_WIDTH: 0.460955
G1 F1200
M204 S8000
G1 X175.478 Y157.116 E.00264
; LINE_WIDTH: 0.476234
G1 X175.462 Y157.038 E.00274
G1 X175.292 Y157 E.00599
; LINE_WIDTH: 0.43172
G1 X164.806 Y157 E.32205
; CHANGE_LAYER
; Z_HEIGHT: 25.4
; LAYER_HEIGHT: 0.199999
; WIPE_START
G1 F9259.259
G1 X166.806 Y157 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 127/165
; update layer progress
M73 L127
M991 S0 P126 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z25.6 I-.058 J1.216 P1  F60000
G1 X175.102 Y157.398 Z25.6
G1 Z25.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X164.602 Y157.398 E.33764
G1 X164.602 Y156.602 E.02559
G1 X175.898 Y156.602 E.36323
G1 X175.898 Y164.898 E.26677
G1 X175.102 Y164.898 E.02559
G1 X175.102 Y157.458 E.23924
; COOLING_NODE: 0
M204 S250
G1 X174.71 Y157.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X164.21 Y157.79 E.31276
G1 X164.21 Y156.21 E.04706
G1 X176.29 Y156.21 E.35982
G1 X176.29 Y165.29 E.27046
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X174.71 Y165.29 E.04706
G1 X174.71 Y157.85 E.22161
; WIPE_START
G1 F9547.055
M204 S8000
G1 X172.71 Y157.839 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.5 Y157.194 Z25.8 F60000
G1 Z25.4
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.4484
G1 F1200
M204 S8000
G1 X175.483 Y157.114 E.00263
; LINE_WIDTH: 0.470635
G1 X175.467 Y157.033 E.00278
G1 X175.306 Y157 E.00556
; LINE_WIDTH: 0.43172
G1 X164.806 Y157 E.32248
; WIPE_START
G1 F9259.259
G1 X166.806 Y157 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X174.436 Y157.171 Z25.8 F60000
G1 X175.5 Y157.194 Z25.8
G1 Z25.4
G1 E.8 F1800
; LINE_WIDTH: 0.43173
G1 F1200
M204 S8000
G1 X175.5 Y164.694 E.23035
; CHANGE_LAYER
; Z_HEIGHT: 25.6
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F9259.021
G1 X175.5 Y162.694 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 128/165
; update layer progress
M73 L128
M991 S0 P127 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z25.8 I1.214 J-.091 P1  F60000
G1 X175.102 Y157.398 Z25.8
G1 Z25.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X164.602 Y157.398 E.33764
G1 X164.602 Y156.602 E.02559
G1 X175.898 Y156.602 E.36323
G1 X175.898 Y164.898 E.26677
G1 X175.102 Y164.898 E.02559
G1 X175.102 Y157.458 E.23924
; COOLING_NODE: 0
M204 S250
G1 X174.71 Y157.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X164.21 Y157.79 E.31276
G1 X164.21 Y156.21 E.04706
G1 X176.29 Y156.21 E.35982
G1 X176.29 Y165.29 E.27046
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X174.71 Y165.29 E.04706
G1 X174.71 Y157.85 E.22161
; WIPE_START
G1 F9547.055
M204 S8000
G1 X172.71 Y157.839 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.5 Y157.194 Z26 F60000
G1 Z25.6
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.4484
G1 F1200
M204 S8000
G1 X175.483 Y157.114 E.00263
; LINE_WIDTH: 0.470635
G1 X175.467 Y157.033 E.00278
G1 X175.306 Y157 E.00556
; LINE_WIDTH: 0.43172
G1 X164.806 Y157 E.32248
; WIPE_START
G1 F9259.259
G1 X166.806 Y157 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X174.436 Y157.171 Z26 F60000
G1 X175.5 Y157.194 Z26
G1 Z25.6
G1 E.8 F1800
; LINE_WIDTH: 0.43173
G1 F1200
M204 S8000
G1 X175.5 Y164.694 E.23035
; CHANGE_LAYER
; Z_HEIGHT: 25.8
; LAYER_HEIGHT: 0.199999
; WIPE_START
G1 F9259.021
G1 X175.5 Y162.694 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 129/165
; update layer progress
M73 L129
M991 S0 P128 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z26 I1.214 J-.091 P1  F60000
G1 X175.102 Y157.398 Z26
G1 Z25.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X164.602 Y157.398 E.33764
G1 X164.602 Y156.602 E.02559
G1 X175.898 Y156.602 E.36323
G1 X175.898 Y164.898 E.26677
M73 P85 R4
G1 X175.102 Y164.898 E.02559
G1 X175.102 Y157.458 E.23924
; COOLING_NODE: 0
M204 S250
G1 X174.71 Y157.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X164.21 Y157.79 E.31276
G1 X164.21 Y156.21 E.04706
G1 X176.29 Y156.21 E.35982
G1 X176.29 Y165.29 E.27046
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X174.71 Y165.29 E.04706
G1 X174.71 Y157.85 E.22161
; WIPE_START
G1 F9547.055
M204 S8000
G1 X172.71 Y157.839 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.5 Y157.194 Z26.2 F60000
G1 Z25.8
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.4484
G1 F1200
M204 S8000
G1 X175.483 Y157.114 E.00263
; LINE_WIDTH: 0.470635
G1 X175.467 Y157.033 E.00278
G1 X175.306 Y157 E.00556
; LINE_WIDTH: 0.43172
G1 X164.806 Y157 E.32248
; WIPE_START
G1 F9259.259
G1 X166.806 Y157 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X174.436 Y157.171 Z26.2 F60000
G1 X175.5 Y157.194 Z26.2
G1 Z25.8
G1 E.8 F1800
; LINE_WIDTH: 0.43173
G1 F1200
M204 S8000
G1 X175.5 Y164.694 E.23035
; CHANGE_LAYER
; Z_HEIGHT: 26
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F9259.021
G1 X175.5 Y162.694 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 130/165
; update layer progress
M73 L130
M991 S0 P129 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z26.2 I1.214 J-.091 P1  F60000
G1 X175.102 Y157.398 Z26.2
G1 Z26
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X164.602 Y157.398 E.33764
G1 X164.602 Y156.602 E.02559
G1 X175.898 Y156.602 E.36323
G1 X175.898 Y164.898 E.26677
G1 X175.102 Y164.898 E.02559
G1 X175.102 Y157.458 E.23924
; COOLING_NODE: 0
M204 S250
G1 X174.71 Y157.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X164.21 Y157.79 E.31276
G1 X164.21 Y156.21 E.04706
G1 X176.29 Y156.21 E.35982
G1 X176.29 Y165.29 E.27046
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X174.71 Y165.29 E.04706
G1 X174.71 Y157.85 E.22161
; WIPE_START
G1 F9547.055
M204 S8000
G1 X172.71 Y157.839 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.5 Y157.194 Z26.4 F60000
G1 Z26
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.4484
G1 F1200
M204 S8000
G1 X175.483 Y157.114 E.00263
; LINE_WIDTH: 0.470635
G1 X175.467 Y157.033 E.00278
G1 X175.306 Y157 E.00556
; LINE_WIDTH: 0.43172
G1 X164.806 Y157 E.32248
; WIPE_START
G1 F9259.259
G1 X166.806 Y157 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X174.436 Y157.171 Z26.4 F60000
G1 X175.5 Y157.194 Z26.4
G1 Z26
G1 E.8 F1800
; LINE_WIDTH: 0.43173
G1 F1200
M204 S8000
G1 X175.5 Y164.694 E.23035
; CHANGE_LAYER
; Z_HEIGHT: 26.2
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F9259.021
G1 X175.5 Y162.694 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 131/165
; update layer progress
M73 L131
M991 S0 P130 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z26.4 I1.214 J-.091 P1  F60000
G1 X175.102 Y157.398 Z26.4
G1 Z26.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X164.602 Y157.398 E.33764
G1 X164.602 Y156.602 E.02559
G1 X175.898 Y156.602 E.36323
G1 X175.898 Y164.898 E.26677
G1 X175.102 Y164.898 E.02559
G1 X175.102 Y157.458 E.23924
; COOLING_NODE: 0
M204 S250
G1 X174.71 Y157.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X164.21 Y157.79 E.31276
G1 X164.21 Y156.21 E.04706
G1 X176.29 Y156.21 E.35982
G1 X176.29 Y165.29 E.27046
;======== H2D 20260731========
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
G1 X174.71 Y165.29 E.04706
G1 X174.71 Y157.85 E.22161
; WIPE_START
G1 F9547.055
M204 S8000
G1 X172.71 Y157.839 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.5 Y157.194 Z26.6 F60000
G1 Z26.2
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.4484
G1 F1200
M204 S8000
G1 X175.483 Y157.114 E.00263
; LINE_WIDTH: 0.470635
G1 X175.467 Y157.033 E.00278
G1 X175.306 Y157 E.00556
; LINE_WIDTH: 0.43172
G1 X164.806 Y157 E.32248
; WIPE_START
G1 F9259.259
G1 X166.806 Y157 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X174.436 Y157.171 Z26.6 F60000
G1 X175.5 Y157.194 Z26.6
G1 Z26.2
G1 E.8 F1800
; LINE_WIDTH: 0.43173
G1 F1200
M204 S8000
G1 X175.5 Y164.694 E.23035
; CHANGE_LAYER
; Z_HEIGHT: 26.4
; LAYER_HEIGHT: 0.199999
; WIPE_START
G1 F9259.021
G1 X175.5 Y162.694 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 132/165
; update layer progress
M73 L132
M991 S0 P131 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z26.6 I1.214 J-.091 P1  F60000
G1 X175.102 Y157.398 Z26.6
G1 Z26.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X164.602 Y157.398 E.33764
G1 X164.602 Y156.602 E.02559
G1 X175.898 Y156.602 E.36323
G1 X175.898 Y164.898 E.26677
M73 P86 R3
G1 X175.102 Y164.898 E.02559
G1 X175.102 Y157.458 E.23924
; COOLING_NODE: 0
M204 S250
G1 X174.71 Y157.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X164.21 Y157.79 E.31276
G1 X164.21 Y156.21 E.04706
G1 X176.29 Y156.21 E.35982
G1 X176.29 Y165.29 E.27046
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X174.71 Y165.29 E.04706
G1 X174.71 Y157.85 E.22161
; WIPE_START
G1 F9547.055
M204 S8000
G1 X172.71 Y157.839 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.5 Y157.194 Z26.8 F60000
G1 Z26.4
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.4484
G1 F1200
M204 S8000
G1 X175.483 Y157.114 E.00263
; LINE_WIDTH: 0.470635
G1 X175.467 Y157.033 E.00278
G1 X175.306 Y157 E.00556
; LINE_WIDTH: 0.43172
G1 X164.806 Y157 E.32248
; WIPE_START
G1 F9259.259
G1 X166.806 Y157 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X174.436 Y157.171 Z26.8 F60000
G1 X175.5 Y157.194 Z26.8
G1 Z26.4
G1 E.8 F1800
; LINE_WIDTH: 0.43173
G1 F1200
M204 S8000
G1 X175.5 Y164.694 E.23035
; CHANGE_LAYER
; Z_HEIGHT: 26.6
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F9259.021
G1 X175.5 Y162.694 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 133/165
; update layer progress
M73 L133
M991 S0 P132 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z26.8 I1.214 J-.091 P1  F60000
G1 X175.102 Y157.398 Z26.8
G1 Z26.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X164.602 Y157.398 E.33764
G1 X164.602 Y156.602 E.02559
G1 X175.898 Y156.602 E.36323
G1 X175.898 Y164.898 E.26677
G1 X175.102 Y164.898 E.02559
G1 X175.102 Y157.458 E.23924
; COOLING_NODE: 0
M204 S250
G1 X174.71 Y157.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X164.21 Y157.79 E.31276
G1 X164.21 Y156.21 E.04706
G1 X176.29 Y156.21 E.35982
G1 X176.29 Y165.29 E.27046
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X174.71 Y165.29 E.04706
G1 X174.71 Y157.85 E.22161
; WIPE_START
G1 F9547.055
M204 S8000
G1 X172.71 Y157.839 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.5 Y157.194 Z27 F60000
G1 Z26.6
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.4484
G1 F1200
M204 S8000
G1 X175.483 Y157.114 E.00263
; LINE_WIDTH: 0.470635
G1 X175.467 Y157.033 E.00278
G1 X175.306 Y157 E.00556
; LINE_WIDTH: 0.43172
G1 X164.806 Y157 E.32248
; WIPE_START
G1 F9259.259
G1 X166.806 Y157 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X174.436 Y157.171 Z27 F60000
G1 X175.5 Y157.194 Z27
G1 Z26.6
G1 E.8 F1800
; LINE_WIDTH: 0.43173
G1 F1200
M204 S8000
G1 X175.5 Y164.694 E.23035
; CHANGE_LAYER
; Z_HEIGHT: 26.8
; LAYER_HEIGHT: 0.199999
; WIPE_START
G1 F9259.021
G1 X175.5 Y162.694 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 134/165
; update layer progress
M73 L134
M991 S0 P133 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z27 I1.214 J-.091 P1  F60000
G1 X175.102 Y157.398 Z27
G1 Z26.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X164.602 Y157.398 E.33764
G1 X164.602 Y156.602 E.02559
G1 X175.898 Y156.602 E.36323
G1 X175.898 Y164.898 E.26677
G1 X175.102 Y164.898 E.02559
G1 X175.102 Y157.458 E.23924
; COOLING_NODE: 0
M204 S250
G1 X174.71 Y157.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X164.21 Y157.79 E.31276
G1 X164.21 Y156.21 E.04706
G1 X176.29 Y156.21 E.35982
G1 X176.29 Y165.29 E.27046
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X174.71 Y165.29 E.04706
G1 X174.71 Y157.85 E.22161
; WIPE_START
G1 F9547.055
M204 S8000
G1 X172.71 Y157.839 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.5 Y157.194 Z27.2 F60000
G1 Z26.8
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.4484
G1 F1200
M204 S8000
G1 X175.483 Y157.114 E.00263
; LINE_WIDTH: 0.470635
G1 X175.467 Y157.033 E.00278
G1 X175.306 Y157 E.00556
; LINE_WIDTH: 0.43172
G1 X164.806 Y157 E.32248
; WIPE_START
G1 F9259.259
G1 X166.806 Y157 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X174.436 Y157.171 Z27.2 F60000
G1 X175.5 Y157.194 Z27.2
G1 Z26.8
G1 E.8 F1800
; LINE_WIDTH: 0.43173
G1 F1200
M204 S8000
G1 X175.5 Y164.694 E.23035
; CHANGE_LAYER
; Z_HEIGHT: 27
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F9259.021
G1 X175.5 Y162.694 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 135/165
; update layer progress
M73 L135
M991 S0 P134 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z27.2 I1.214 J-.091 P1  F60000
G1 X175.102 Y157.398 Z27.2
G1 Z27
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X164.602 Y157.398 E.33764
G1 X164.602 Y156.602 E.02559
G1 X175.898 Y156.602 E.36323
G1 X175.898 Y164.898 E.26677
M73 P87 R3
G1 X175.102 Y164.898 E.02559
G1 X175.102 Y157.458 E.23924
; COOLING_NODE: 0
M204 S250
G1 X174.71 Y157.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X164.21 Y157.79 E.31276
G1 X164.21 Y156.21 E.04706
G1 X176.29 Y156.21 E.35982
G1 X176.29 Y165.29 E.27046
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X174.71 Y165.29 E.04706
G1 X174.71 Y157.85 E.22161
; WIPE_START
G1 F9547.055
M204 S8000
G1 X172.71 Y157.839 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.5 Y157.194 Z27.4 F60000
G1 Z27
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.4484
G1 F1200
M204 S8000
G1 X175.483 Y157.114 E.00263
; LINE_WIDTH: 0.470635
G1 X175.467 Y157.033 E.00278
G1 X175.306 Y157 E.00556
; LINE_WIDTH: 0.43172
G1 X164.806 Y157 E.32248
; WIPE_START
G1 F9259.259
G1 X166.806 Y157 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X174.436 Y157.171 Z27.4 F60000
G1 X175.5 Y157.194 Z27.4
G1 Z27
G1 E.8 F1800
; LINE_WIDTH: 0.43173
G1 F1200
M204 S8000
G1 X175.5 Y164.694 E.23035
; CHANGE_LAYER
; Z_HEIGHT: 27.2
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F9259.021
G1 X175.5 Y162.694 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 136/165
; update layer progress
M73 L136
M991 S0 P135 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 1
M204 S10000
G17
G3 Z27.4 I-1.119 J-.479 P1  F60000
G1 X174.388 Y165.29 Z27.4
G1 Z27.2
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F600
M204 S5000
G1 X174.3 Y165.29 E.00262
; FEATURE: Overhang wall
; LINE_WIDTH: 0.45

G1 X169.617 Y165.29 E.15058
G3 X172.129 Y164.313 I2.402 J2.457 E.08907

G3 X174.3 Y165.21 I-.157 J3.454 E.07707
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 X174.343 Y165.25 E.00175
; COOLING_NODE: 1
; WIPE_START
M204 S8000
G1 X174.3 Y165.29 E-.02251
G1 X172.359 Y165.29 E-.73749
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z27.6 I1.15 J.4 P1  F60000
G1 X175.102 Y157.398 Z27.6
G1 Z27.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X164.602 Y157.398 E.33764
G1 X164.602 Y156.602 E.02559
G1 X175.898 Y156.602 E.36323
G1 X175.898 Y164.898 E.26677
G1 X175.102 Y164.898 E.02559
G1 X175.102 Y157.458 E.23924
; COOLING_NODE: 0
M204 S250
G1 X174.71 Y157.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X164.21 Y157.79 E.31276
G1 X164.21 Y156.21 E.04706
G1 X176.29 Y156.21 E.35982
G1 X176.29 Y165.29 E.27046
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X174.71 Y165.29 E.04706
G1 X174.71 Y157.85 E.22161
; WIPE_START
G1 F9547.055
M204 S8000
G1 X172.71 Y157.839 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.5 Y157.194 Z27.6 F60000
G1 Z27.2
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.4484
G1 F1200
M204 S8000
G1 X175.483 Y157.114 E.00263
; LINE_WIDTH: 0.470635
G1 X175.467 Y157.033 E.00278
G1 X175.306 Y157 E.00556
; LINE_WIDTH: 0.43172
G1 X164.806 Y157 E.32248
; WIPE_START
G1 F9259.259
G1 X166.806 Y157 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X169.834 Y164.006 Z27.6 F60000
G1 X170.271 Y165.017 Z27.6
G1 Z27.2
G1 E.8 F1800
; LINE_WIDTH: 0.431301
G1 F1200
M204 S8000
G1 X170.658 Y164.948 E.01205
; LINE_WIDTH: 0.459167
G1 X171.044 Y164.879 E.01291
; LINE_WIDTH: 0.496475
G1 X171.198 Y164.856 E.00559
; LINE_WIDTH: 0.539062
G1 X171.352 Y164.836 E.00608
; LINE_WIDTH: 0.573301
G1 X171.504 Y164.821 E.0064
; LINE_WIDTH: 0.619357
G3 X172.262 Y164.806 I.5 J6.032 E.03451
; LINE_WIDTH: 0.599115
G3 X172.566 Y164.828 I-.261 J5.808 E.0134
; LINE_WIDTH: 0.558494
G1 X172.719 Y164.845 E.00626
; LINE_WIDTH: 0.520519
G1 X172.872 Y164.866 E.00584
; LINE_WIDTH: 0.486776
G1 X172.95 Y164.878 E.00276
; LINE_WIDTH: 0.461339
G1 X173.028 Y164.891 E.0026
; LINE_WIDTH: 0.433653
G1 X173.388 Y164.96 E.01133
; LINE_WIDTH: 0.403738
G1 X173.749 Y165.029 E.01046
; WIPE_START
G1 F9977.339
G1 X173.388 Y164.96 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z27.6 I.152 J1.207 P1  F60000
G1 X175.5 Y164.694 Z27.6
G1 Z27.2
G1 E.8 F1800
; LINE_WIDTH: 0.43173
G1 F1200
M204 S8000
G1 X175.5 Y157.194 E.23035
; CHANGE_LAYER
; Z_HEIGHT: 27.4
; LAYER_HEIGHT: 0.199999
; WIPE_START
G1 F9259.021
G1 X175.5 Y159.194 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 137/165
; update layer progress
M73 L137
M991 S0 P136 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 1
M204 S10000
G17
G3 Z27.6 I-1.197 J-.218 P1  F60000
G1 X174.388 Y165.29 Z27.6
G1 Z27.4
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F859
M204 S5000
G1 X169.617 Y165.29 E.1421
G3 X172.127 Y164.312 I2.402 J2.456 E.08243
G3 X174.345 Y165.249 I-.159 J3.472 E.07322
; COOLING_NODE: 1
; WIPE_START
G1 F9547.055
M204 S8000
G1 X172.345 Y165.266 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z27.8 I1.148 J.402 P1  F60000
G1 X175.102 Y157.398 Z27.8
G1 Z27.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X164.602 Y157.398 E.33764
G1 X164.602 Y156.602 E.02559
G1 X175.898 Y156.602 E.36323
G1 X175.898 Y164.898 E.26677
G1 X175.102 Y164.898 E.02559
G1 X175.102 Y157.458 E.23924
; COOLING_NODE: 0
M204 S250
G1 X174.71 Y157.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X164.21 Y157.79 E.31276
G1 X164.21 Y156.21 E.04706
G1 X176.29 Y156.21 E.35982
G1 X176.29 Y165.29 E.27046
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X174.71 Y165.29 E.04706
G1 X174.71 Y157.85 E.22161
; WIPE_START
G1 F9547.055
M204 S8000
M73 P88 R3
G1 X172.71 Y157.839 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.5 Y157.194 Z27.8 F60000
G1 Z27.4
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.4484
G1 F1200
M204 S8000
G1 X175.483 Y157.114 E.00263
; LINE_WIDTH: 0.470635
G1 X175.467 Y157.033 E.00278
G1 X175.306 Y157 E.00556
; LINE_WIDTH: 0.43172
G1 X164.806 Y157 E.32248
; WIPE_START
G1 F9259.259
G1 X166.806 Y157 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X169.833 Y164.006 Z27.8 F60000
G1 X170.27 Y165.017 Z27.8
G1 Z27.4
G1 E.8 F1800
; LINE_WIDTH: 0.430226
G1 F1200
M204 S8000
G1 X170.655 Y164.948 E.01198
; LINE_WIDTH: 0.458089
G1 X171.041 Y164.879 E.01284
; LINE_WIDTH: 0.495575
G1 X171.196 Y164.856 E.0056
; LINE_WIDTH: 0.538349
G1 X171.349 Y164.837 E.00605
; LINE_WIDTH: 0.572722
G1 X171.502 Y164.822 E.00643
; LINE_WIDTH: 0.619265
G3 X172.26 Y164.806 I.503 J6.027 E.03453
; LINE_WIDTH: 0.599375
G3 X172.564 Y164.828 I-.26 J5.812 E.0134
; LINE_WIDTH: 0.558897
G1 X172.717 Y164.844 E.00627
; LINE_WIDTH: 0.520921
G1 X172.871 Y164.866 E.00587
; LINE_WIDTH: 0.487132
G1 X172.949 Y164.878 E.00276
; LINE_WIDTH: 0.461751
G1 X173.026 Y164.891 E.0026
; LINE_WIDTH: 0.434124
G1 X173.387 Y164.96 E.01136
; LINE_WIDTH: 0.404215
G1 X173.748 Y165.028 E.01049
; WIPE_START
G1 F9964.168
G1 X173.387 Y164.96 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z27.8 I.152 J1.207 P1  F60000
G1 X175.5 Y164.694 Z27.8
G1 Z27.4
G1 E.8 F1800
; LINE_WIDTH: 0.43173
G1 F1200
M204 S8000
G1 X175.5 Y157.194 E.23035
; CHANGE_LAYER
; Z_HEIGHT: 27.6
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F9259.021
G1 X175.5 Y159.194 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 138/165
; update layer progress
M73 L138
M991 S0 P137 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 1
M204 S10000
G17
G3 Z27.8 I-1.197 J-.218 P1  F60000
G1 X174.388 Y165.29 Z27.8
G1 Z27.6
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F935
M204 S5000
G1 X169.618 Y165.29 E.14207
G3 X172.124 Y164.312 I2.401 J2.453 E.08233
G3 X174.345 Y165.249 I-.156 J3.472 E.0733
; COOLING_NODE: 1
; WIPE_START
G1 F9547.055
M204 S8000
G1 X172.345 Y165.266 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X174.869 Y158.063 Z28 F60000
G1 X175.102 Y157.398 Z28
G1 Z27.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X164.602 Y157.398 E.33764
G1 X164.602 Y156.602 E.02559
G1 X175.898 Y156.602 E.36323
G1 X175.898 Y164.898 E.26677
G1 X175.102 Y164.898 E.02559
G1 X175.102 Y157.458 E.23924
; COOLING_NODE: 0
M204 S250
G1 X174.71 Y157.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X164.21 Y157.79 E.31276
G1 X164.21 Y156.21 E.04706
G1 X176.29 Y156.21 E.35982
G1 X176.29 Y165.29 E.27046
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X174.71 Y165.29 E.04706
G1 X174.71 Y157.85 E.22161
; WIPE_START
G1 F9547.055
M204 S8000
G1 X172.71 Y157.839 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.5 Y157.194 Z28 F60000
G1 Z27.6
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.4484
G1 F1200
M204 S8000
G1 X175.483 Y157.114 E.00263
; LINE_WIDTH: 0.470635
G1 X175.467 Y157.033 E.00278
G1 X175.306 Y157 E.00556
; LINE_WIDTH: 0.43172
G1 X164.806 Y157 E.32248
; WIPE_START
G1 F9259.259
G1 X166.806 Y157 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X169.831 Y164.007 Z28 F60000
G1 X170.267 Y165.018 Z28
G1 Z27.6
G1 E.8 F1800
; LINE_WIDTH: 0.429049
G1 F1200
M204 S8000
G1 X170.653 Y164.949 E.01194
; LINE_WIDTH: 0.457057
G1 X171.038 Y164.88 E.0128
; LINE_WIDTH: 0.494717
G1 X171.193 Y164.856 E.0056
; LINE_WIDTH: 0.537685
G1 X171.347 Y164.837 E.00605
; LINE_WIDTH: 0.572264
G1 X171.5 Y164.822 E.00645
; LINE_WIDTH: 0.619176
G3 X172.258 Y164.806 I.505 J6.032 E.03454
; LINE_WIDTH: 0.599623
G3 X172.562 Y164.827 I-.258 J5.813 E.0134
; LINE_WIDTH: 0.559212
G1 X172.716 Y164.844 E.0063
; LINE_WIDTH: 0.521238
G1 X172.87 Y164.865 E.00588
; LINE_WIDTH: 0.487471
G1 X172.948 Y164.878 E.00277
; LINE_WIDTH: 0.462064
G1 X173.025 Y164.891 E.00261
; LINE_WIDTH: 0.434436
G1 X173.387 Y164.96 E.01137
; LINE_WIDTH: 0.404612
G1 X173.748 Y165.028 E.01051
; WIPE_START
G1 F9953.227
G1 X173.387 Y164.96 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.5 Y164.694 Z28 F60000
G1 Z27.6
G1 E.8 F1800
; LINE_WIDTH: 0.43173
G1 F1200
M204 S8000
G1 X175.5 Y157.194 E.23035
; CHANGE_LAYER
; Z_HEIGHT: 27.8
; LAYER_HEIGHT: 0.199999
; WIPE_START
G1 F9259.021
G1 X175.5 Y159.194 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 139/165
; update layer progress
M73 L139
M991 S0 P138 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 1
M204 S10000
G17
G3 Z28 I-1.197 J-.218 P1  F60000
G1 X174.388 Y165.29 Z28
G1 Z27.8
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1003
M204 S5000
G1 X169.618 Y165.29 E.14209
G3 X172.123 Y164.312 I2.402 J2.456 E.08229
G3 X174.345 Y165.249 I-.155 J3.472 E.07335
; COOLING_NODE: 1
; WIPE_START
G1 F9547.055
M204 S8000
G1 X172.345 Y165.266 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X174.869 Y158.063 Z28.2 F60000
G1 X175.102 Y157.398 Z28.2
G1 Z27.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X164.602 Y157.398 E.33764
G1 X164.602 Y156.602 E.02559
G1 X175.898 Y156.602 E.36323
G1 X175.898 Y164.898 E.26677
G1 X175.102 Y164.898 E.02559
G1 X175.102 Y157.458 E.23924
; COOLING_NODE: 0
M204 S250
G1 X174.71 Y157.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X164.21 Y157.79 E.31276
G1 X164.21 Y156.21 E.04706
G1 X176.29 Y156.21 E.35982
G1 X176.29 Y165.29 E.27046
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X174.71 Y165.29 E.04706
G1 X174.71 Y157.85 E.22161
; WIPE_START
G1 F9547.055
M204 S8000
G1 X172.71 Y157.839 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.5 Y157.194 Z28.2 F60000
G1 Z27.8
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.4484
G1 F1200
M204 S8000
G1 X175.483 Y157.114 E.00263
; LINE_WIDTH: 0.470635
G1 X175.467 Y157.033 E.00278
G1 X175.306 Y157 E.00556
; LINE_WIDTH: 0.43172
G1 X164.806 Y157 E.32248
; WIPE_START
G1 F9259.259
G1 X166.806 Y157 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X169.83 Y164.008 Z28.2 F60000
G1 X170.267 Y165.019 Z28.2
G1 Z27.8
G1 E.8 F1800
; LINE_WIDTH: 0.427843
G1 F1200
M204 S8000
G1 X170.651 Y164.949 E.01187
; LINE_WIDTH: 0.456041
G1 X171.035 Y164.88 E.01274
; LINE_WIDTH: 0.493926
G1 X171.191 Y164.857 E.00561
; LINE_WIDTH: 0.537109
G1 X171.344 Y164.837 E.00604
; LINE_WIDTH: 0.571804
G1 X171.498 Y164.822 E.00643
; LINE_WIDTH: 0.619065
G3 X172.257 Y164.806 I.507 J6.03 E.03458
; LINE_WIDTH: 0.599843
G3 X172.561 Y164.827 I-.256 J5.8 E.01342
; LINE_WIDTH: 0.559548
G1 X172.714 Y164.844 E.0063
; LINE_WIDTH: 0.521614
G1 X172.869 Y164.865 E.0059
; LINE_WIDTH: 0.487854
G1 X172.946 Y164.878 E.00277
; LINE_WIDTH: 0.462498
G1 X173.024 Y164.891 E.00261
; LINE_WIDTH: 0.434893
G1 X173.386 Y164.959 E.0114
; LINE_WIDTH: 0.405031
G1 X173.748 Y165.028 E.01054
; WIPE_START
G1 F9941.706
G1 X173.386 Y164.959 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.5 Y164.694 Z28.2 F60000
G1 Z27.8
G1 E.8 F1800
; LINE_WIDTH: 0.43173
G1 F1200
M204 S8000
G1 X175.5 Y157.194 E.23035
; CHANGE_LAYER
; Z_HEIGHT: 28
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F9259.021
G1 X175.5 Y159.194 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 140/165
; update layer progress
M73 L140
M991 S0 P139 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 1
M204 S10000
G17
G3 Z28.2 I-1.197 J-.218 P1  F60000
G1 X174.388 Y165.29 Z28.2
G1 Z28
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1058
M204 S5000
G1 X169.618 Y165.29 E.14209
G3 X172.12 Y164.312 I2.402 J2.456 E.08223
G3 X174.345 Y165.249 I-.152 J3.472 E.07342
; COOLING_NODE: 1
; WIPE_START
G1 F9547.055
M204 S8000
G1 X172.345 Y165.266 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X174.869 Y158.063 Z28.4 F60000
G1 X175.102 Y157.398 Z28.4
G1 Z28
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X164.602 Y157.398 E.33764
G1 X164.602 Y156.602 E.02559
G1 X175.898 Y156.602 E.36323
G1 X175.898 Y164.898 E.26677
M73 P89 R3
G1 X175.102 Y164.898 E.02559
G1 X175.102 Y157.458 E.23924
; COOLING_NODE: 0
M204 S250
G1 X174.71 Y157.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X164.21 Y157.79 E.31276
G1 X164.21 Y156.21 E.04706
G1 X176.29 Y156.21 E.35982
G1 X176.29 Y165.29 E.27046
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X174.71 Y165.29 E.04706
G1 X174.71 Y157.85 E.22161
; WIPE_START
G1 F9547.055
M204 S8000
G1 X172.71 Y157.839 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.5 Y157.194 Z28.4 F60000
G1 Z28
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.4484
G1 F1200
M204 S8000
G1 X175.483 Y157.114 E.00263
; LINE_WIDTH: 0.470635
G1 X175.467 Y157.033 E.00278
G1 X175.306 Y157 E.00556
; LINE_WIDTH: 0.43172
G1 X164.806 Y157 E.32248
; WIPE_START
G1 F9259.259
G1 X166.806 Y157 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X169.83 Y164.008 Z28.4 F60000
G1 X170.266 Y165.019 Z28.4
G1 Z28
G1 E.8 F1800
; LINE_WIDTH: 0.42689
G1 F1200
M204 S8000
G1 X170.649 Y164.95 E.0118
; LINE_WIDTH: 0.455017
G1 X171.032 Y164.881 E.01266
; LINE_WIDTH: 0.492986
G1 X171.188 Y164.857 E.0056
; LINE_WIDTH: 0.536414
G1 X171.342 Y164.837 E.00606
; LINE_WIDTH: 0.57129
G1 X171.495 Y164.822 E.00641
; LINE_WIDTH: 0.618948
G3 X172.255 Y164.806 I.51 J6.03 E.03461
; LINE_WIDTH: 0.600065
G3 X172.559 Y164.827 I-.258 J5.857 E.01344
; LINE_WIDTH: 0.559881
G1 X172.713 Y164.844 E.0063
; LINE_WIDTH: 0.522029
G1 X172.867 Y164.865 E.00591
; LINE_WIDTH: 0.488239
G1 X172.945 Y164.878 E.00278
; LINE_WIDTH: 0.462773
G1 X173.023 Y164.89 E.00262
; LINE_WIDTH: 0.435126
G1 X173.386 Y164.959 E.01142
; LINE_WIDTH: 0.405309
G1 X173.748 Y165.028 E.01055
; WIPE_START
G1 F9934.086
G1 X173.386 Y164.959 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.5 Y164.694 Z28.4 F60000
G1 Z28
G1 E.8 F1800
; LINE_WIDTH: 0.43173
G1 F1200
M204 S8000
G1 X175.5 Y157.194 E.23035
; CHANGE_LAYER
; Z_HEIGHT: 28.2
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F9259.021
G1 X175.5 Y159.194 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 141/165
; update layer progress
M73 L141
M991 S0 P140 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 1
M204 S10000
G17
G3 Z28.4 I-1.197 J-.218 P1  F60000
G1 X174.388 Y165.29 Z28.4
G1 Z28.2
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1099
M204 S5000
G1 X169.618 Y165.29 E.14209
G3 X172.118 Y164.312 I2.402 J2.456 E.08217
G3 X174.345 Y165.249 I-.15 J3.472 E.07348
; COOLING_NODE: 1
; WIPE_START
G1 F9547.055
M204 S8000
M73 P89 R2
G1 X172.345 Y165.266 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X174.869 Y158.063 Z28.6 F60000
G1 X175.102 Y157.398 Z28.6
G1 Z28.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X164.602 Y157.398 E.33764
G1 X164.602 Y156.602 E.02559
G1 X175.898 Y156.602 E.36323
G1 X175.898 Y164.898 E.26677
G1 X175.102 Y164.898 E.02559
G1 X175.102 Y157.458 E.23924
; COOLING_NODE: 0
M204 S250
G1 X174.71 Y157.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X164.21 Y157.79 E.31276
G1 X164.21 Y156.21 E.04706
G1 X176.29 Y156.21 E.35982
G1 X176.29 Y165.29 E.27046
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X174.71 Y165.29 E.04706
G1 X174.71 Y157.85 E.22161
; WIPE_START
G1 F9547.055
M204 S8000
G1 X172.71 Y157.839 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.5 Y157.194 Z28.6 F60000
G1 Z28.2
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.4484
G1 F1200
M204 S8000
G1 X175.483 Y157.114 E.00263
; LINE_WIDTH: 0.470635
G1 X175.467 Y157.033 E.00278
G1 X175.306 Y157 E.00556
; LINE_WIDTH: 0.43172
G1 X164.806 Y157 E.32248
; WIPE_START
G1 F9259.259
G1 X166.806 Y157 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X169.829 Y164.008 Z28.6 F60000
G1 X170.265 Y165.02 Z28.6
G1 Z28.2
G1 E.8 F1800
; LINE_WIDTH: 0.42566
G1 F1200
M204 S8000
G1 X170.647 Y164.95 E.01174
; LINE_WIDTH: 0.4541
G1 X171.03 Y164.881 E.01262
; LINE_WIDTH: 0.492153
G1 X171.185 Y164.857 E.00556
; LINE_WIDTH: 0.535651
G1 X171.339 Y164.838 E.00606
; LINE_WIDTH: 0.570763
G1 X171.493 Y164.822 E.00644
; LINE_WIDTH: 0.618855
G3 X172.253 Y164.806 I.513 J6.034 E.03462
; LINE_WIDTH: 0.600287
G3 X172.558 Y164.827 I-.252 J5.801 E.01348
; LINE_WIDTH: 0.560117
G1 X172.712 Y164.844 E.00631
; LINE_WIDTH: 0.522219
G1 X172.867 Y164.865 E.00593
; LINE_WIDTH: 0.488506
G1 X172.944 Y164.877 E.00276
; LINE_WIDTH: 0.463276
G1 X173.022 Y164.89 E.00261
; LINE_WIDTH: 0.435718
G1 X173.384 Y164.959 E.01146
; LINE_WIDTH: 0.405799
G1 X173.747 Y165.028 E.01058
; WIPE_START
G1 F9920.659
G1 X173.384 Y164.959 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.5 Y164.694 Z28.6 F60000
G1 Z28.2
G1 E.8 F1800
; LINE_WIDTH: 0.43173
G1 F1200
M204 S8000
G1 X175.5 Y157.194 E.23035
; CHANGE_LAYER
; Z_HEIGHT: 28.4
; LAYER_HEIGHT: 0.199999
; WIPE_START
G1 F9259.021
G1 X175.5 Y159.194 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 142/165
; update layer progress
M73 L142
M991 S0 P141 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 1
M204 S10000
G17
G3 Z28.6 I-1.197 J-.218 P1  F60000
G1 X174.388 Y165.29 Z28.6
G1 Z28.4
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1128
M204 S5000
G1 X169.618 Y165.29 E.14209
G3 X172.117 Y164.312 I2.402 J2.456 E.08212
G3 X174.344 Y165.249 I-.148 J3.471 E.07352
; COOLING_NODE: 1
; WIPE_START
G1 F9547.055
M204 S8000
G1 X172.345 Y165.266 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X174.869 Y158.063 Z28.8 F60000
G1 X175.102 Y157.398 Z28.8
G1 Z28.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X164.602 Y157.398 E.33764
G1 X164.602 Y156.602 E.02559
G1 X175.898 Y156.602 E.36323
G1 X175.898 Y164.898 E.26677
G1 X175.102 Y164.898 E.02559
G1 X175.102 Y157.458 E.23924
; COOLING_NODE: 0
M204 S250
G1 X174.71 Y157.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X164.21 Y157.79 E.31276
G1 X164.21 Y156.21 E.04706
G1 X176.29 Y156.21 E.35982
G1 X176.29 Y165.29 E.27046
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X174.71 Y165.29 E.04706
G1 X174.71 Y157.85 E.22161
; WIPE_START
G1 F9547.055
M204 S8000
G1 X172.71 Y157.839 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
M73 P90 R2
G1 X175.5 Y157.194 Z28.8 F60000
G1 Z28.4
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.4484
G1 F1200
M204 S8000
G1 X175.483 Y157.114 E.00263
; LINE_WIDTH: 0.470635
G1 X175.467 Y157.033 E.00278
G1 X175.306 Y157 E.00556
; LINE_WIDTH: 0.43172
G1 X164.806 Y157 E.32248
; WIPE_START
G1 F9259.259
G1 X166.806 Y157 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X169.829 Y164.008 Z28.8 F60000
G1 X170.265 Y165.02 Z28.8
G1 Z28.4
G1 E.8 F1800
; LINE_WIDTH: 0.425007
G1 F1200
M204 S8000
G1 X170.647 Y164.951 E.0117
; LINE_WIDTH: 0.453483
G1 X171.028 Y164.882 E.01257
; LINE_WIDTH: 0.491667
G1 X171.183 Y164.858 E.00557
; LINE_WIDTH: 0.535283
G1 X171.338 Y164.838 E.00605
; LINE_WIDTH: 0.570499
G1 X171.491 Y164.822 E.00644
; LINE_WIDTH: 0.618805
G3 X172.252 Y164.806 I.514 J6.032 E.03462
; LINE_WIDTH: 0.600427
G3 X172.557 Y164.827 I-.255 J5.859 E.01349
; LINE_WIDTH: 0.560358
G1 X172.711 Y164.844 E.00631
; LINE_WIDTH: 0.522541
G1 X172.865 Y164.865 E.00592
; LINE_WIDTH: 0.488819
G1 X172.943 Y164.877 E.00278
; LINE_WIDTH: 0.463473
G1 X173.021 Y164.89 E.00262
; LINE_WIDTH: 0.435815
G1 X173.384 Y164.959 E.01146
; LINE_WIDTH: 0.405872
G1 X173.747 Y165.028 E.01059
; WIPE_START
G1 F9918.681
G1 X173.384 Y164.959 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.5 Y164.694 Z28.8 F60000
G1 Z28.4
G1 E.8 F1800
; LINE_WIDTH: 0.43173
G1 F1200
M204 S8000
G1 X175.5 Y157.194 E.23035
; CHANGE_LAYER
; Z_HEIGHT: 28.6
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F9259.021
G1 X175.5 Y159.194 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 143/165
; update layer progress
M73 L143
M991 S0 P142 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 1
M204 S10000
G17
G3 Z28.8 I-1.197 J-.218 P1  F60000
G1 X174.388 Y165.29 Z28.8
G1 Z28.6
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1149
M204 S5000
G1 X169.618 Y165.29 E.14209
G3 X172.117 Y164.312 I2.402 J2.456 E.08212
G3 X174.345 Y165.249 I-.149 J3.472 E.07352
; COOLING_NODE: 1
; WIPE_START
G1 F9547.055
M204 S8000
G1 X172.345 Y165.266 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X174.869 Y158.063 Z29 F60000
G1 X175.102 Y157.398 Z29
G1 Z28.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X164.602 Y157.398 E.33764
G1 X164.602 Y156.602 E.02559
G1 X175.898 Y156.602 E.36323
G1 X175.898 Y164.898 E.26677
G1 X175.102 Y164.898 E.02559
G1 X175.102 Y157.458 E.23924
; COOLING_NODE: 0
M204 S250
G1 X174.71 Y157.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X164.21 Y157.79 E.31276
G1 X164.21 Y156.21 E.04706
G1 X176.29 Y156.21 E.35982
G1 X176.29 Y165.29 E.27046
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X174.71 Y165.29 E.04706
G1 X174.71 Y157.85 E.22161
; WIPE_START
G1 F9547.055
M204 S8000
G1 X172.71 Y157.839 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.5 Y157.194 Z29 F60000
G1 Z28.6
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.4484
G1 F1200
M204 S8000
G1 X175.483 Y157.114 E.00263
; LINE_WIDTH: 0.470635
G1 X175.467 Y157.033 E.00278
G1 X175.306 Y157 E.00556
; LINE_WIDTH: 0.43172
G1 X164.806 Y157 E.32248
; WIPE_START
G1 F9259.259
G1 X166.806 Y157 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X169.829 Y164.008 Z29 F60000
G1 X170.265 Y165.02 Z29
G1 Z28.6
G1 E.8 F1800
; LINE_WIDTH: 0.425184
G1 F1200
M204 S8000
G1 X170.647 Y164.951 E.01171
; LINE_WIDTH: 0.453582
G1 X171.028 Y164.882 E.01258
; LINE_WIDTH: 0.491653
G1 X171.183 Y164.858 E.00555
; LINE_WIDTH: 0.535306
G1 X171.338 Y164.838 E.00608
; LINE_WIDTH: 0.570555
G1 X171.492 Y164.822 E.00644
; LINE_WIDTH: 0.618812
G3 X172.252 Y164.806 I.514 J6.032 E.03461
; LINE_WIDTH: 0.600429
G3 X172.557 Y164.827 I-.253 J5.833 E.01348
; LINE_WIDTH: 0.560326
G1 X172.711 Y164.844 E.00633
; LINE_WIDTH: 0.522544
G1 X172.865 Y164.865 E.0059
; LINE_WIDTH: 0.488839
G1 X172.944 Y164.877 E.00279
; LINE_WIDTH: 0.463347
G1 X173.022 Y164.89 E.00263
; LINE_WIDTH: 0.435714
G1 X173.384 Y164.959 E.01145
; LINE_WIDTH: 0.405905
G1 X173.747 Y165.028 E.01058
; WIPE_START
G1 F9917.782
G1 X173.384 Y164.959 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.5 Y164.694 Z29 F60000
G1 Z28.6
G1 E.8 F1800
; LINE_WIDTH: 0.43173
G1 F1200
M204 S8000
G1 X175.5 Y157.194 E.23035
; CHANGE_LAYER
; Z_HEIGHT: 28.8
; LAYER_HEIGHT: 0.199999
; WIPE_START
G1 F9259.021
G1 X175.5 Y159.194 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 144/165
; update layer progress
M73 L144
M991 S0 P143 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 1
M204 S10000
G17
G3 Z29 I-1.197 J-.218 P1  F60000
G1 X174.388 Y165.29 Z29
G1 Z28.8
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1164
M204 S5000
G1 X169.618 Y165.29 E.1421
G3 X172.117 Y164.312 I2.402 J2.457 E.08212
G3 X174.345 Y165.249 I-.149 J3.472 E.07352
; COOLING_NODE: 1
; WIPE_START
G1 F9547.055
M204 S8000
G1 X172.345 Y165.266 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X174.869 Y158.063 Z29.2 F60000
G1 X175.102 Y157.398 Z29.2
G1 Z28.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X164.602 Y157.398 E.33764
G1 X164.602 Y156.602 E.02559
G1 X175.898 Y156.602 E.36323
G1 X175.898 Y164.898 E.26677
G1 X175.102 Y164.898 E.02559
G1 X175.102 Y157.458 E.23924
; COOLING_NODE: 0
M204 S250
G1 X174.71 Y157.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X164.21 Y157.79 E.31276
G1 X164.21 Y156.21 E.04706
G1 X176.29 Y156.21 E.35982
G1 X176.29 Y165.29 E.27046
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X174.71 Y165.29 E.04706
G1 X174.71 Y157.85 E.22161
; WIPE_START
G1 F9547.055
M204 S8000
G1 X172.71 Y157.839 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.5 Y157.194 Z29.2 F60000
G1 Z28.8
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.4484
G1 F1200
M204 S8000
G1 X175.483 Y157.114 E.00263
; LINE_WIDTH: 0.470635
G1 X175.467 Y157.033 E.00278
G1 X175.306 Y157 E.00556
; LINE_WIDTH: 0.43172
G1 X164.806 Y157 E.32248
; WIPE_START
G1 F9259.259
G1 X166.806 Y157 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X169.829 Y164.008 Z29.2 F60000
G1 X170.265 Y165.02 Z29.2
G1 Z28.8
G1 E.8 F1800
; LINE_WIDTH: 0.42509
G1 F1200
M204 S8000
G1 X170.646 Y164.951 E.0117
; LINE_WIDTH: 0.45347
G1 X171.028 Y164.882 E.01257
; LINE_WIDTH: 0.491708
G1 X171.184 Y164.858 E.00559
; LINE_WIDTH: 0.535362
G1 X171.337 Y164.838 E.00603
; LINE_WIDTH: 0.570512
G1 X171.492 Y164.822 E.00645
; LINE_WIDTH: 0.618811
G3 X172.252 Y164.806 I.514 J6.032 E.03461
; LINE_WIDTH: 0.600453
G3 X172.557 Y164.827 I-.254 J5.842 E.01347
; LINE_WIDTH: 0.560365
G1 X172.711 Y164.844 E.00633
; LINE_WIDTH: 0.522468
G1 X172.866 Y164.865 E.00593
; LINE_WIDTH: 0.488717
G1 X172.944 Y164.877 E.00278
; LINE_WIDTH: 0.463386
G1 X173.021 Y164.89 E.00262
; LINE_WIDTH: 0.435834
G1 X173.384 Y164.959 E.01146
; LINE_WIDTH: 0.406025
G1 X173.747 Y165.028 E.01059
; WIPE_START
G1 F9914.503
G1 X173.384 Y164.959 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.5 Y164.694 Z29.2 F60000
G1 Z28.8
G1 E.8 F1800
; LINE_WIDTH: 0.43173
G1 F1200
M204 S8000
G1 X175.5 Y157.194 E.23035
; CHANGE_LAYER
; Z_HEIGHT: 29
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F9259.021
G1 X175.5 Y159.194 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 145/165
; update layer progress
M73 L145
M991 S0 P144 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 1
M204 S10000
G17
G3 Z29.2 I-1.197 J-.218 P1  F60000
G1 X174.388 Y165.29 Z29.2
G1 Z29
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1175
M204 S5000
G1 X169.618 Y165.29 E.14209
G3 X172.117 Y164.312 I2.402 J2.456 E.08212
G3 X174.345 Y165.249 I-.149 J3.471 E.07352
; COOLING_NODE: 1
; WIPE_START
G1 F9547.055
M204 S8000
G1 X172.345 Y165.266 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X174.869 Y158.063 Z29.4 F60000
G1 X175.102 Y157.398 Z29.4
G1 Z29
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X164.602 Y157.398 E.33764
G1 X164.602 Y156.602 E.02559
G1 X175.898 Y156.602 E.36323
G1 X175.898 Y164.898 E.26677
G1 X175.102 Y164.898 E.02559
G1 X175.102 Y157.458 E.23924
; COOLING_NODE: 0
M204 S250
M73 P91 R2
G1 X174.71 Y157.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X164.21 Y157.79 E.31276
G1 X164.21 Y156.21 E.04706
G1 X176.29 Y156.21 E.35982
G1 X176.29 Y165.29 E.27046
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X174.71 Y165.29 E.04706
G1 X174.71 Y157.85 E.22161
; WIPE_START
G1 F9547.055
M204 S8000
G1 X172.71 Y157.839 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.5 Y157.194 Z29.4 F60000
G1 Z29
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.4484
G1 F1200
M204 S8000
G1 X175.483 Y157.114 E.00263
; LINE_WIDTH: 0.470635
G1 X175.467 Y157.033 E.00278
G1 X175.306 Y157 E.00556
; LINE_WIDTH: 0.43172
G1 X164.806 Y157 E.32248
; WIPE_START
G1 F9259.259
G1 X166.806 Y157 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X169.829 Y164.008 Z29.4 F60000
G1 X170.265 Y165.02 Z29.4
G1 Z29
G1 E.8 F1800
; LINE_WIDTH: 0.42499
G1 F1200
M204 S8000
G1 X170.646 Y164.951 E.0117
; LINE_WIDTH: 0.453437
G1 X171.028 Y164.882 E.01257
; LINE_WIDTH: 0.491606
G1 X171.183 Y164.858 E.00557
; LINE_WIDTH: 0.535287
G1 X171.338 Y164.838 E.00607
; LINE_WIDTH: 0.570535
G1 X171.491 Y164.822 E.00644
; LINE_WIDTH: 0.618809
G3 X172.252 Y164.806 I.514 J6.032 E.03462
; LINE_WIDTH: 0.600434
G3 X172.557 Y164.827 I-.254 J5.844 E.01348
; LINE_WIDTH: 0.560316
G1 X172.711 Y164.844 E.00633
; LINE_WIDTH: 0.522499
G1 X172.865 Y164.865 E.00591
; LINE_WIDTH: 0.488784
G1 X172.944 Y164.877 E.00279
; LINE_WIDTH: 0.463382
G1 X173.022 Y164.89 E.00263
; LINE_WIDTH: 0.435769
G1 X173.384 Y164.959 E.01146
; LINE_WIDTH: 0.405937
G1 X173.747 Y165.028 E.01059
; WIPE_START
G1 F9916.911
G1 X173.384 Y164.959 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.5 Y164.694 Z29.4 F60000
G1 Z29
G1 E.8 F1800
; LINE_WIDTH: 0.43173
G1 F1200
M204 S8000
G1 X175.5 Y157.194 E.23035
; CHANGE_LAYER
; Z_HEIGHT: 29.2
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F9259.021
G1 X175.5 Y159.194 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 146/165
; update layer progress
M73 L146
M991 S0 P145 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 1
M204 S10000
G17
G3 Z29.4 I-1.197 J-.218 P1  F60000
G1 X174.388 Y165.29 Z29.4
G1 Z29.2
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1183
M204 S5000
G1 X169.618 Y165.29 E.14209
G3 X172.117 Y164.312 I2.402 J2.456 E.08213
G3 X174.345 Y165.249 I-.149 J3.471 E.07352
; COOLING_NODE: 1
; WIPE_START
G1 F9547.055
M204 S8000
G1 X172.345 Y165.266 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X174.869 Y158.063 Z29.6 F60000
G1 X175.102 Y157.398 Z29.6
G1 Z29.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X164.602 Y157.398 E.33764
G1 X164.602 Y156.602 E.02559
G1 X175.898 Y156.602 E.36323
G1 X175.898 Y164.898 E.26677
G1 X175.102 Y164.898 E.02559
G1 X175.102 Y157.458 E.23924
; COOLING_NODE: 0
M204 S250
G1 X174.71 Y157.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X164.21 Y157.79 E.31276
G1 X164.21 Y156.21 E.04706
G1 X176.29 Y156.21 E.35982
G1 X176.29 Y165.29 E.27046
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X174.71 Y165.29 E.04706
G1 X174.71 Y157.85 E.22161
; WIPE_START
G1 F9547.055
M204 S8000
G1 X172.71 Y157.839 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.5 Y157.194 Z29.6 F60000
G1 Z29.2
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.4484
G1 F1200
M204 S8000
G1 X175.483 Y157.114 E.00263
; LINE_WIDTH: 0.470635
G1 X175.467 Y157.033 E.00278
G1 X175.306 Y157 E.00556
; LINE_WIDTH: 0.43172
G1 X164.806 Y157 E.32248
; WIPE_START
G1 F9259.259
G1 X166.806 Y157 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X169.829 Y164.008 Z29.6 F60000
G1 X170.265 Y165.02 Z29.6
G1 Z29.2
G1 E.8 F1800
; LINE_WIDTH: 0.425052
G1 F1200
M204 S8000
G1 X170.646 Y164.951 E.01169
; LINE_WIDTH: 0.453378
G1 X171.027 Y164.882 E.01256
; LINE_WIDTH: 0.491667
G1 X171.184 Y164.858 E.00561
; LINE_WIDTH: 0.535393
G1 X171.338 Y164.838 E.00604
; LINE_WIDTH: 0.570503
G1 X171.491 Y164.822 E.00643
; LINE_WIDTH: 0.618791
G3 X172.252 Y164.806 I.514 J6.031 E.03462
; LINE_WIDTH: 0.600435
G3 X172.557 Y164.827 I-.252 J5.824 E.01349
; LINE_WIDTH: 0.560336
G1 X172.711 Y164.844 E.00632
; LINE_WIDTH: 0.522526
G1 X172.865 Y164.865 E.00591
; LINE_WIDTH: 0.488798
G1 X172.944 Y164.877 E.00279
; LINE_WIDTH: 0.46336
G1 X173.022 Y164.89 E.00263
; LINE_WIDTH: 0.435716
G1 X173.385 Y164.959 E.01145
; LINE_WIDTH: 0.405906
G1 X173.747 Y165.028 E.01059
; WIPE_START
G1 F9917.755
G1 X173.385 Y164.959 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.5 Y164.694 Z29.6 F60000
G1 Z29.2
G1 E.8 F1800
; LINE_WIDTH: 0.43173
G1 F1200
M204 S8000
G1 X175.5 Y157.194 E.23035
; CHANGE_LAYER
; Z_HEIGHT: 29.4
; LAYER_HEIGHT: 0.199999
; WIPE_START
G1 F9259.021
G1 X175.5 Y159.194 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 147/165
; update layer progress
M73 L147
M991 S0 P146 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 1
M204 S10000
G17
G3 Z29.6 I-1.197 J-.218 P1  F60000
G1 X174.388 Y165.29 Z29.6
G1 Z29.4
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1188
M204 S5000
G1 X169.618 Y165.29 E.14209
G3 X172.117 Y164.312 I2.402 J2.456 E.08212
G3 X174.345 Y165.249 I-.149 J3.471 E.07352
; COOLING_NODE: 1
; WIPE_START
G1 F9547.055
M204 S8000
G1 X172.345 Y165.266 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X174.869 Y158.063 Z29.8 F60000
G1 X175.102 Y157.398 Z29.8
G1 Z29.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X164.602 Y157.398 E.33764
G1 X164.602 Y156.602 E.02559
G1 X175.898 Y156.602 E.36323
G1 X175.898 Y164.898 E.26677
G1 X175.102 Y164.898 E.02559
G1 X175.102 Y157.458 E.23924
; COOLING_NODE: 0
M204 S250
G1 X174.71 Y157.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X164.21 Y157.79 E.31276
G1 X164.21 Y156.21 E.04706
G1 X176.29 Y156.21 E.35982
G1 X176.29 Y165.29 E.27046
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X174.71 Y165.29 E.04706
G1 X174.71 Y157.85 E.22161
; WIPE_START
G1 F9547.055
M204 S8000
G1 X172.71 Y157.839 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.5 Y157.194 Z29.8 F60000
G1 Z29.4
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.4484
G1 F1200
M204 S8000
G1 X175.483 Y157.114 E.00263
; LINE_WIDTH: 0.470635
G1 X175.467 Y157.033 E.00278
G1 X175.306 Y157 E.00556
; LINE_WIDTH: 0.43172
G1 X164.806 Y157 E.32248
; WIPE_START
G1 F9259.259
G1 X166.806 Y157 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
M73 P92 R2
G1 X169.829 Y164.008 Z29.8 F60000
G1 X170.265 Y165.02 Z29.8
G1 Z29.4
G1 E.8 F1800
; LINE_WIDTH: 0.425108
G1 F1200
M204 S8000
G1 X170.646 Y164.951 E.0117
; LINE_WIDTH: 0.45345
G1 X171.028 Y164.882 E.01257
; LINE_WIDTH: 0.491666
G1 X171.184 Y164.858 E.00559
; LINE_WIDTH: 0.535383
G1 X171.338 Y164.838 E.00605
; LINE_WIDTH: 0.570536
G1 X171.491 Y164.822 E.00643
; LINE_WIDTH: 0.618811
G3 X172.252 Y164.806 I.514 J6.031 E.03462
; LINE_WIDTH: 0.600432
G3 X172.557 Y164.827 I-.253 J5.826 E.01348
; LINE_WIDTH: 0.560328
G1 X172.711 Y164.844 E.00633
; LINE_WIDTH: 0.522496
G1 X172.865 Y164.865 E.00591
; LINE_WIDTH: 0.488819
G1 X172.943 Y164.877 E.00278
; LINE_WIDTH: 0.46346
G1 X173.021 Y164.89 E.00262
; LINE_WIDTH: 0.435821
G1 X173.384 Y164.959 E.01146
; LINE_WIDTH: 0.405927
G1 X173.747 Y165.028 E.01059
; WIPE_START
G1 F9917.166
G1 X173.384 Y164.959 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.5 Y164.694 Z29.8 F60000
G1 Z29.4
G1 E.8 F1800
; LINE_WIDTH: 0.43173
G1 F1200
M204 S8000
G1 X175.5 Y157.194 E.23035
; CHANGE_LAYER
; Z_HEIGHT: 29.6
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F9259.021
G1 X175.5 Y159.194 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 148/165
; update layer progress
M73 L148
M991 S0 P147 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 1
M204 S10000
G17
G3 Z29.8 I-1.197 J-.218 P1  F60000
G1 X174.388 Y165.29 Z29.8
G1 Z29.6
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1192
M204 S5000
G1 X169.618 Y165.29 E.14209
G3 X172.117 Y164.312 I2.402 J2.456 E.08212
G3 X174.344 Y165.249 I-.148 J3.471 E.07352
; COOLING_NODE: 1
; WIPE_START
G1 F9547.055
M204 S8000
G1 X172.345 Y165.266 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X174.869 Y158.063 Z30 F60000
G1 X175.102 Y157.398 Z30
G1 Z29.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X164.602 Y157.398 E.33764
G1 X164.602 Y156.602 E.02559
G1 X175.898 Y156.602 E.36323
G1 X175.898 Y164.898 E.26677
G1 X175.102 Y164.898 E.02559
G1 X175.102 Y157.458 E.23924
; COOLING_NODE: 0
M204 S250
G1 X174.71 Y157.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X164.21 Y157.79 E.31276
G1 X164.21 Y156.21 E.04706
G1 X176.29 Y156.21 E.35982
G1 X176.29 Y165.29 E.27046
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X174.71 Y165.29 E.04706
G1 X174.71 Y157.85 E.22161
; WIPE_START
G1 F9547.055
M204 S8000
G1 X172.71 Y157.839 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.5 Y157.194 Z30 F60000
G1 Z29.6
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.4484
G1 F1200
M204 S8000
G1 X175.483 Y157.114 E.00263
; LINE_WIDTH: 0.470635
G1 X175.467 Y157.033 E.00278
G1 X175.306 Y157 E.00556
; LINE_WIDTH: 0.43172
G1 X164.806 Y157 E.32248
; WIPE_START
G1 F9259.259
G1 X166.806 Y157 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X169.829 Y164.008 Z30 F60000
G1 X170.265 Y165.02 Z30
G1 Z29.6
G1 E.8 F1800
; LINE_WIDTH: 0.425007
G1 F1200
M204 S8000
G1 X170.647 Y164.951 E.0117
; LINE_WIDTH: 0.453483
G1 X171.028 Y164.882 E.01257
; LINE_WIDTH: 0.491667
G1 X171.183 Y164.858 E.00557
; LINE_WIDTH: 0.535283
G1 X171.338 Y164.838 E.00605
; LINE_WIDTH: 0.570499
G1 X171.491 Y164.822 E.00644
; LINE_WIDTH: 0.618805
G3 X172.252 Y164.806 I.514 J6.032 E.03462
; LINE_WIDTH: 0.600427
G3 X172.557 Y164.827 I-.255 J5.859 E.01349
; LINE_WIDTH: 0.560358
G1 X172.711 Y164.844 E.00631
; LINE_WIDTH: 0.522541
G1 X172.865 Y164.865 E.00592
; LINE_WIDTH: 0.488819
G1 X172.943 Y164.877 E.00278
; LINE_WIDTH: 0.463473
G1 X173.021 Y164.89 E.00262
; LINE_WIDTH: 0.435815
G1 X173.384 Y164.959 E.01146
; LINE_WIDTH: 0.405872
G1 X173.747 Y165.028 E.01059
; WIPE_START
G1 F9918.681
G1 X173.384 Y164.959 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.5 Y164.694 Z30 F60000
G1 Z29.6
G1 E.8 F1800
; LINE_WIDTH: 0.43173
G1 F1200
M204 S8000
G1 X175.5 Y157.194 E.23035
; CHANGE_LAYER
; Z_HEIGHT: 29.8
; LAYER_HEIGHT: 0.199999
; WIPE_START
G1 F9259.021
G1 X175.5 Y159.194 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 149/165
; update layer progress
M73 L149
M991 S0 P148 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 1
M204 S10000
G17
G3 Z30 I-1.197 J-.218 P1  F60000
G1 X174.388 Y165.29 Z30
G1 Z29.8
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1194
M204 S5000
G1 X169.618 Y165.29 E.14209
G3 X172.117 Y164.312 I2.402 J2.456 E.08212
G3 X174.345 Y165.249 I-.149 J3.472 E.07352
; COOLING_NODE: 1
; WIPE_START
G1 F9547.055
M204 S8000
G1 X172.345 Y165.266 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X174.869 Y158.063 Z30.2 F60000
G1 X175.102 Y157.398 Z30.2
G1 Z29.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X164.602 Y157.398 E.33764
G1 X164.602 Y156.602 E.02559
G1 X175.898 Y156.602 E.36323
G1 X175.898 Y164.898 E.26677
G1 X175.102 Y164.898 E.02559
G1 X175.102 Y157.458 E.23924
; COOLING_NODE: 0
M204 S250
G1 X174.71 Y157.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X164.21 Y157.79 E.31276
G1 X164.21 Y156.21 E.04706
G1 X176.29 Y156.21 E.35982
G1 X176.29 Y165.29 E.27046
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X174.71 Y165.29 E.04706
G1 X174.71 Y157.85 E.22161
; WIPE_START
G1 F9547.055
M204 S8000
G1 X172.71 Y157.839 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.5 Y157.194 Z30.2 F60000
G1 Z29.8
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.4484
G1 F1200
M204 S8000
G1 X175.483 Y157.114 E.00263
; LINE_WIDTH: 0.470635
G1 X175.467 Y157.033 E.00278
G1 X175.306 Y157 E.00556
; LINE_WIDTH: 0.43172
G1 X164.806 Y157 E.32248
; WIPE_START
G1 F9259.259
G1 X166.806 Y157 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X169.829 Y164.008 Z30.2 F60000
G1 X170.265 Y165.02 Z30.2
G1 Z29.8
G1 E.8 F1800
; LINE_WIDTH: 0.425184
G1 F1200
M204 S8000
G1 X170.647 Y164.951 E.01171
; LINE_WIDTH: 0.453582
G1 X171.028 Y164.882 E.01258
; LINE_WIDTH: 0.491653
G1 X171.183 Y164.858 E.00555
; LINE_WIDTH: 0.535306
G1 X171.338 Y164.838 E.00608
; LINE_WIDTH: 0.570555
G1 X171.492 Y164.822 E.00644
; LINE_WIDTH: 0.618812
G3 X172.252 Y164.806 I.514 J6.032 E.03461
; LINE_WIDTH: 0.600429
G3 X172.557 Y164.827 I-.253 J5.833 E.01348
; LINE_WIDTH: 0.560326
G1 X172.711 Y164.844 E.00633
; LINE_WIDTH: 0.522544
G1 X172.865 Y164.865 E.0059
; LINE_WIDTH: 0.488839
G1 X172.944 Y164.877 E.00279
; LINE_WIDTH: 0.463347
G1 X173.022 Y164.89 E.00263
; LINE_WIDTH: 0.435714
G1 X173.384 Y164.959 E.01145
; LINE_WIDTH: 0.405905
G1 X173.747 Y165.028 E.01058
; WIPE_START
G1 F9917.782
G1 X173.384 Y164.959 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.5 Y164.694 Z30.2 F60000
G1 Z29.8
G1 E.8 F1800
; LINE_WIDTH: 0.43173
G1 F1200
M204 S8000
G1 X175.5 Y157.194 E.23035
; CHANGE_LAYER
; Z_HEIGHT: 30
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F9259.021
G1 X175.5 Y159.194 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 150/165
; update layer progress
M73 L150
M991 S0 P149 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 1
M204 S10000
G17
G3 Z30.2 I-1.197 J-.218 P1  F60000
G1 X174.388 Y165.29 Z30.2
G1 Z30
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1196
M204 S5000
G1 X169.618 Y165.29 E.1421
G3 X172.117 Y164.312 I2.402 J2.457 E.08212
G3 X174.345 Y165.249 I-.149 J3.472 E.07352
; COOLING_NODE: 1
; WIPE_START
G1 F9547.055
M204 S8000
G1 X172.345 Y165.266 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X174.869 Y158.063 Z30.4 F60000
G1 X175.102 Y157.398 Z30.4
G1 Z30
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X164.602 Y157.398 E.33764
G1 X164.602 Y156.602 E.02559
G1 X175.898 Y156.602 E.36323
G1 X175.898 Y164.898 E.26677
M73 P92 R1
G1 X175.102 Y164.898 E.02559
G1 X175.102 Y157.458 E.23924
; COOLING_NODE: 0
M204 S250
G1 X174.71 Y157.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X164.21 Y157.79 E.31276
M73 P93 R1
G1 X164.21 Y156.21 E.04706
G1 X176.29 Y156.21 E.35982
G1 X176.29 Y165.29 E.27046
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X174.71 Y165.29 E.04706
G1 X174.71 Y157.85 E.22161
; WIPE_START
G1 F9547.055
M204 S8000
G1 X172.71 Y157.839 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.5 Y157.194 Z30.4 F60000
G1 Z30
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.4484
G1 F1200
M204 S8000
G1 X175.483 Y157.114 E.00263
; LINE_WIDTH: 0.470635
G1 X175.467 Y157.033 E.00278
G1 X175.306 Y157 E.00556
; LINE_WIDTH: 0.43172
G1 X164.806 Y157 E.32248
; WIPE_START
G1 F9259.259
G1 X166.806 Y157 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X169.829 Y164.008 Z30.4 F60000
G1 X170.265 Y165.02 Z30.4
G1 Z30
G1 E.8 F1800
; LINE_WIDTH: 0.42509
G1 F1200
M204 S8000
G1 X170.646 Y164.951 E.0117
; LINE_WIDTH: 0.45347
G1 X171.028 Y164.882 E.01257
; LINE_WIDTH: 0.491708
G1 X171.184 Y164.858 E.00559
; LINE_WIDTH: 0.535362
G1 X171.337 Y164.838 E.00603
; LINE_WIDTH: 0.570512
G1 X171.492 Y164.822 E.00645
; LINE_WIDTH: 0.618811
G3 X172.252 Y164.806 I.514 J6.032 E.03461
; LINE_WIDTH: 0.600453
G3 X172.557 Y164.827 I-.254 J5.842 E.01347
; LINE_WIDTH: 0.560365
G1 X172.711 Y164.844 E.00633
; LINE_WIDTH: 0.522468
G1 X172.866 Y164.865 E.00593
; LINE_WIDTH: 0.488717
G1 X172.944 Y164.877 E.00278
; LINE_WIDTH: 0.463386
G1 X173.021 Y164.89 E.00262
; LINE_WIDTH: 0.435834
G1 X173.384 Y164.959 E.01146
; LINE_WIDTH: 0.406025
G1 X173.747 Y165.028 E.01059
; WIPE_START
G1 F9914.503
G1 X173.384 Y164.959 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.5 Y164.694 Z30.4 F60000
G1 Z30
G1 E.8 F1800
; LINE_WIDTH: 0.43173
G1 F1200
M204 S8000
G1 X175.5 Y157.194 E.23035
; CHANGE_LAYER
; Z_HEIGHT: 30.2
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F9259.021
G1 X175.5 Y159.194 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 151/165
; update layer progress
M73 L151
M991 S0 P150 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 1
M204 S10000
G17
G3 Z30.4 I-1.197 J-.218 P1  F60000
G1 X174.388 Y165.29 Z30.4
G1 Z30.2
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1197
M204 S5000
G1 X169.618 Y165.29 E.14209
G3 X172.117 Y164.312 I2.402 J2.456 E.08212
G3 X174.345 Y165.249 I-.149 J3.471 E.07352
; COOLING_NODE: 1
; WIPE_START
G1 F9547.055
M204 S8000
G1 X172.345 Y165.266 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X174.869 Y158.063 Z30.6 F60000
G1 X175.102 Y157.398 Z30.6
G1 Z30.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X164.602 Y157.398 E.33764
G1 X164.602 Y156.602 E.02559
G1 X175.898 Y156.602 E.36323
G1 X175.898 Y164.898 E.26677
G1 X175.102 Y164.898 E.02559
G1 X175.102 Y157.458 E.23924
; COOLING_NODE: 0
M204 S250
G1 X174.71 Y157.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X164.21 Y157.79 E.31276
G1 X164.21 Y156.21 E.04706
G1 X176.29 Y156.21 E.35982
G1 X176.29 Y165.29 E.27046
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X174.71 Y165.29 E.04706
G1 X174.71 Y157.85 E.22161
; WIPE_START
G1 F9547.055
M204 S8000
G1 X172.71 Y157.839 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.5 Y157.194 Z30.6 F60000
G1 Z30.2
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.4484
G1 F1200
M204 S8000
G1 X175.483 Y157.114 E.00263
; LINE_WIDTH: 0.470635
G1 X175.467 Y157.033 E.00278
G1 X175.306 Y157 E.00556
; LINE_WIDTH: 0.43172
G1 X164.806 Y157 E.32248
; WIPE_START
G1 F9259.259
G1 X166.806 Y157 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X169.829 Y164.008 Z30.6 F60000
G1 X170.265 Y165.02 Z30.6
G1 Z30.2
G1 E.8 F1800
; LINE_WIDTH: 0.42499
G1 F1200
M204 S8000
G1 X170.646 Y164.951 E.0117
; LINE_WIDTH: 0.453437
G1 X171.028 Y164.882 E.01257
; LINE_WIDTH: 0.491606
G1 X171.183 Y164.858 E.00557
; LINE_WIDTH: 0.535287
G1 X171.338 Y164.838 E.00607
; LINE_WIDTH: 0.570535
G1 X171.491 Y164.822 E.00644
; LINE_WIDTH: 0.618809
G3 X172.252 Y164.806 I.514 J6.032 E.03462
; LINE_WIDTH: 0.600434
G3 X172.557 Y164.827 I-.254 J5.844 E.01348
; LINE_WIDTH: 0.560316
G1 X172.711 Y164.844 E.00633
; LINE_WIDTH: 0.522499
G1 X172.865 Y164.865 E.00591
; LINE_WIDTH: 0.488784
G1 X172.944 Y164.877 E.00279
; LINE_WIDTH: 0.463382
G1 X173.022 Y164.89 E.00263
; LINE_WIDTH: 0.435769
G1 X173.384 Y164.959 E.01146
; LINE_WIDTH: 0.405937
G1 X173.747 Y165.028 E.01059
; WIPE_START
G1 F9916.911
G1 X173.384 Y164.959 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.5 Y164.694 Z30.6 F60000
G1 Z30.2
G1 E.8 F1800
; LINE_WIDTH: 0.43173
G1 F1200
M204 S8000
G1 X175.5 Y157.194 E.23035
; CHANGE_LAYER
; Z_HEIGHT: 30.4
; LAYER_HEIGHT: 0.199999
; WIPE_START
G1 F9259.021
G1 X175.5 Y159.194 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 152/165
; update layer progress
M73 L152
M991 S0 P151 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 1
M204 S10000
G17
G3 Z30.6 I-1.197 J-.218 P1  F60000
G1 X174.388 Y165.29 Z30.6
G1 Z30.4
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1198
M204 S5000
G1 X169.618 Y165.29 E.14209
G3 X172.117 Y164.312 I2.402 J2.456 E.08213
G3 X174.345 Y165.249 I-.149 J3.472 E.07352
; COOLING_NODE: 1
; WIPE_START
G1 F9547.055
M204 S8000
G1 X172.345 Y165.266 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X174.869 Y158.063 Z30.8 F60000
G1 X175.102 Y157.398 Z30.8
G1 Z30.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X164.602 Y157.398 E.33764
G1 X164.602 Y156.602 E.02559
G1 X175.898 Y156.602 E.36323
G1 X175.898 Y164.898 E.26677
G1 X175.102 Y164.898 E.02559
G1 X175.102 Y157.458 E.23924
; COOLING_NODE: 0
M204 S250
G1 X174.71 Y157.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X164.21 Y157.79 E.31276
G1 X164.21 Y156.21 E.04706
G1 X176.29 Y156.21 E.35982
G1 X176.29 Y165.29 E.27046
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X174.71 Y165.29 E.04706
G1 X174.71 Y157.85 E.22161
; WIPE_START
G1 F9547.055
M204 S8000
G1 X172.71 Y157.839 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.5 Y157.194 Z30.8 F60000
G1 Z30.4
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.4484
G1 F1200
M204 S8000
G1 X175.483 Y157.114 E.00263
; LINE_WIDTH: 0.470635
G1 X175.467 Y157.033 E.00278
G1 X175.306 Y157 E.00556
; LINE_WIDTH: 0.43172
G1 X164.806 Y157 E.32248
; WIPE_START
G1 F9259.259
G1 X166.806 Y157 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X169.829 Y164.008 Z30.8 F60000
G1 X170.265 Y165.02 Z30.8
G1 Z30.4
G1 E.8 F1800
; LINE_WIDTH: 0.425052
G1 F1200
M204 S8000
G1 X170.646 Y164.951 E.01169
; LINE_WIDTH: 0.453378
G1 X171.027 Y164.882 E.01256
; LINE_WIDTH: 0.491667
G1 X171.184 Y164.858 E.00561
; LINE_WIDTH: 0.535393
G1 X171.338 Y164.838 E.00604
; LINE_WIDTH: 0.570503
G1 X171.491 Y164.822 E.00643
; LINE_WIDTH: 0.618791
G3 X172.252 Y164.806 I.514 J6.031 E.03462
; LINE_WIDTH: 0.600435
G3 X172.557 Y164.827 I-.252 J5.824 E.01349
; LINE_WIDTH: 0.560336
G1 X172.711 Y164.844 E.00632
; LINE_WIDTH: 0.522526
G1 X172.865 Y164.865 E.00591
; LINE_WIDTH: 0.488798
G1 X172.944 Y164.877 E.00279
; LINE_WIDTH: 0.46336
G1 X173.022 Y164.89 E.00263
; LINE_WIDTH: 0.435716
G1 X173.385 Y164.959 E.01145
; LINE_WIDTH: 0.405906
G1 X173.747 Y165.028 E.01059
; WIPE_START
G1 F9917.755
G1 X173.385 Y164.959 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.5 Y164.694 Z30.8 F60000
G1 Z30.4
G1 E.8 F1800
; LINE_WIDTH: 0.43173
G1 F1200
M204 S8000
G1 X175.5 Y157.194 E.23035
; CHANGE_LAYER
; Z_HEIGHT: 30.6
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F9259.021
M73 P94 R1
G1 X175.5 Y159.194 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 153/165
; update layer progress
M73 L153
M991 S0 P152 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 1
M204 S10000
G17
G3 Z30.8 I-1.197 J-.218 P1  F60000
G1 X174.388 Y165.29 Z30.8
G1 Z30.6
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1199
M204 S5000
G1 X169.618 Y165.29 E.14209
G3 X172.117 Y164.312 I2.402 J2.456 E.08212
G3 X174.345 Y165.249 I-.149 J3.471 E.07352
; COOLING_NODE: 1
; WIPE_START
G1 F9547.055
M204 S8000
G1 X172.345 Y165.266 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X174.869 Y158.063 Z31 F60000
G1 X175.102 Y157.398 Z31
G1 Z30.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X164.602 Y157.398 E.33764
G1 X164.602 Y156.602 E.02559
G1 X175.898 Y156.602 E.36323
G1 X175.898 Y164.898 E.26677
G1 X175.102 Y164.898 E.02559
G1 X175.102 Y157.458 E.23924
; COOLING_NODE: 0
M204 S250
G1 X174.71 Y157.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X164.21 Y157.79 E.31276
G1 X164.21 Y156.21 E.04706
G1 X176.29 Y156.21 E.35982
G1 X176.29 Y165.29 E.27046
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X174.71 Y165.29 E.04706
G1 X174.71 Y157.85 E.22161
; WIPE_START
G1 F9547.055
M204 S8000
G1 X172.71 Y157.839 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.5 Y157.194 Z31 F60000
G1 Z30.6
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.4484
G1 F1200
M204 S8000
G1 X175.483 Y157.114 E.00263
; LINE_WIDTH: 0.470635
G1 X175.467 Y157.033 E.00278
G1 X175.306 Y157 E.00556
; LINE_WIDTH: 0.43172
G1 X164.806 Y157 E.32248
; WIPE_START
G1 F9259.259
G1 X166.806 Y157 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X169.829 Y164.008 Z31 F60000
G1 X170.265 Y165.02 Z31
G1 Z30.6
G1 E.8 F1800
; LINE_WIDTH: 0.425108
G1 F1200
M204 S8000
G1 X170.646 Y164.951 E.0117
; LINE_WIDTH: 0.45345
G1 X171.028 Y164.882 E.01257
; LINE_WIDTH: 0.491666
G1 X171.184 Y164.858 E.00559
; LINE_WIDTH: 0.535383
G1 X171.338 Y164.838 E.00605
; LINE_WIDTH: 0.570536
G1 X171.491 Y164.822 E.00643
; LINE_WIDTH: 0.618811
G3 X172.252 Y164.806 I.514 J6.031 E.03462
; LINE_WIDTH: 0.600432
G3 X172.557 Y164.827 I-.253 J5.826 E.01348
; LINE_WIDTH: 0.560328
G1 X172.711 Y164.844 E.00633
; LINE_WIDTH: 0.522496
G1 X172.865 Y164.865 E.00591
; LINE_WIDTH: 0.488819
G1 X172.943 Y164.877 E.00278
; LINE_WIDTH: 0.46346
G1 X173.021 Y164.89 E.00262
; LINE_WIDTH: 0.435821
G1 X173.384 Y164.959 E.01146
; LINE_WIDTH: 0.405927
G1 X173.747 Y165.028 E.01059
; WIPE_START
G1 F9917.166
G1 X173.384 Y164.959 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.5 Y164.694 Z31 F60000
G1 Z30.6
G1 E.8 F1800
; LINE_WIDTH: 0.43173
G1 F1200
M204 S8000
G1 X175.5 Y157.194 E.23035
; CHANGE_LAYER
; Z_HEIGHT: 30.8
; LAYER_HEIGHT: 0.199999
; WIPE_START
G1 F9259.021
G1 X175.5 Y159.194 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 154/165
; update layer progress
M73 L154
M991 S0 P153 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 1
M204 S10000
G17
G3 Z31 I-1.197 J-.218 P1  F60000
G1 X174.388 Y165.29 Z31
G1 Z30.8
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1199
M204 S5000
G1 X169.618 Y165.29 E.14209
G3 X172.117 Y164.312 I2.402 J2.456 E.08212
G3 X174.344 Y165.249 I-.148 J3.471 E.07352
; COOLING_NODE: 1
; WIPE_START
G1 F9547.055
M204 S8000
G1 X172.345 Y165.266 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X174.869 Y158.063 Z31.2 F60000
G1 X175.102 Y157.398 Z31.2
G1 Z30.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X164.602 Y157.398 E.33764
G1 X164.602 Y156.602 E.02559
G1 X175.898 Y156.602 E.36323
G1 X175.898 Y164.898 E.26677
G1 X175.102 Y164.898 E.02559
G1 X175.102 Y157.458 E.23924
; COOLING_NODE: 0
M204 S250
G1 X174.71 Y157.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X164.21 Y157.79 E.31276
G1 X164.21 Y156.21 E.04706
G1 X176.29 Y156.21 E.35982
G1 X176.29 Y165.29 E.27046
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X174.71 Y165.29 E.04706
G1 X174.71 Y157.85 E.22161
; WIPE_START
G1 F9547.055
M204 S8000
G1 X172.71 Y157.839 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.5 Y157.194 Z31.2 F60000
G1 Z30.8
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.4484
G1 F1200
M204 S8000
G1 X175.483 Y157.114 E.00263
; LINE_WIDTH: 0.470635
G1 X175.467 Y157.033 E.00278
G1 X175.306 Y157 E.00556
; LINE_WIDTH: 0.43172
G1 X164.806 Y157 E.32248
; WIPE_START
G1 F9259.259
G1 X166.806 Y157 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X169.829 Y164.008 Z31.2 F60000
G1 X170.265 Y165.02 Z31.2
G1 Z30.8
G1 E.8 F1800
; LINE_WIDTH: 0.425007
G1 F1200
M204 S8000
G1 X170.647 Y164.951 E.0117
; LINE_WIDTH: 0.453483
G1 X171.028 Y164.882 E.01257
; LINE_WIDTH: 0.491667
G1 X171.183 Y164.858 E.00557
; LINE_WIDTH: 0.535283
G1 X171.338 Y164.838 E.00605
; LINE_WIDTH: 0.570499
G1 X171.491 Y164.822 E.00644
; LINE_WIDTH: 0.618805
G3 X172.252 Y164.806 I.514 J6.032 E.03462
; LINE_WIDTH: 0.600427
G3 X172.557 Y164.827 I-.255 J5.859 E.01349
; LINE_WIDTH: 0.560358
G1 X172.711 Y164.844 E.00631
; LINE_WIDTH: 0.522541
G1 X172.865 Y164.865 E.00592
; LINE_WIDTH: 0.488819
G1 X172.943 Y164.877 E.00278
; LINE_WIDTH: 0.463473
G1 X173.021 Y164.89 E.00262
; LINE_WIDTH: 0.435815
G1 X173.384 Y164.959 E.01146
; LINE_WIDTH: 0.405872
G1 X173.747 Y165.028 E.01059
; WIPE_START
G1 F9918.681
G1 X173.384 Y164.959 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.5 Y164.694 Z31.2 F60000
G1 Z30.8
G1 E.8 F1800
; LINE_WIDTH: 0.43173
G1 F1200
M204 S8000
G1 X175.5 Y157.194 E.23035
; CHANGE_LAYER
; Z_HEIGHT: 31
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F9259.021
G1 X175.5 Y159.194 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 155/165
; update layer progress
M73 L155
M991 S0 P154 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 1
M204 S10000
G17
G3 Z31.2 I-1.197 J-.218 P1  F60000
G1 X174.388 Y165.29 Z31.2
G1 Z31
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1199
M204 S5000
G1 X169.618 Y165.29 E.14209
G3 X172.117 Y164.312 I2.402 J2.456 E.08212
G3 X174.345 Y165.249 I-.149 J3.471 E.07352
; COOLING_NODE: 1
; WIPE_START
G1 F9547.055
M204 S8000
G1 X172.345 Y165.266 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X174.869 Y158.063 Z31.4 F60000
G1 X175.102 Y157.398 Z31.4
G1 Z31
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X164.602 Y157.398 E.33764
G1 X164.602 Y156.602 E.02559
G1 X175.898 Y156.602 E.36323
G1 X175.898 Y164.898 E.26677
G1 X175.102 Y164.898 E.02559
G1 X175.102 Y157.458 E.23924
; COOLING_NODE: 0
M204 S250
G1 X174.71 Y157.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X164.21 Y157.79 E.31276
G1 X164.21 Y156.21 E.04706
G1 X176.29 Y156.21 E.35982
G1 X176.29 Y165.29 E.27046
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

M73 P95 R1
G1 X174.71 Y165.29 E.04706
G1 X174.71 Y157.85 E.22161
; WIPE_START
G1 F9547.055
M204 S8000
G1 X172.71 Y157.839 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.5 Y157.194 Z31.4 F60000
G1 Z31
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.4484
G1 F1200
M204 S8000
G1 X175.483 Y157.114 E.00263
; LINE_WIDTH: 0.470635
G1 X175.467 Y157.033 E.00278
G1 X175.306 Y157 E.00556
; LINE_WIDTH: 0.43172
G1 X164.806 Y157 E.32248
; WIPE_START
G1 F9259.259
G1 X166.806 Y157 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X169.829 Y164.008 Z31.4 F60000
G1 X170.265 Y165.02 Z31.4
G1 Z31
G1 E.8 F1800
; LINE_WIDTH: 0.425184
G1 F1200
M204 S8000
G1 X170.647 Y164.951 E.01171
; LINE_WIDTH: 0.453582
G1 X171.028 Y164.882 E.01258
; LINE_WIDTH: 0.491653
G1 X171.183 Y164.858 E.00555
; LINE_WIDTH: 0.535306
G1 X171.338 Y164.838 E.00608
; LINE_WIDTH: 0.570555
G1 X171.492 Y164.822 E.00644
; LINE_WIDTH: 0.618812
G3 X172.252 Y164.806 I.514 J6.032 E.03461
; LINE_WIDTH: 0.600429
G3 X172.557 Y164.827 I-.253 J5.833 E.01348
; LINE_WIDTH: 0.560326
G1 X172.711 Y164.844 E.00633
; LINE_WIDTH: 0.522544
G1 X172.865 Y164.865 E.0059
; LINE_WIDTH: 0.488839
G1 X172.944 Y164.877 E.00279
; LINE_WIDTH: 0.463347
G1 X173.022 Y164.89 E.00263
; LINE_WIDTH: 0.435714
G1 X173.384 Y164.959 E.01145
; LINE_WIDTH: 0.405905
G1 X173.747 Y165.028 E.01058
; WIPE_START
G1 F9917.782
G1 X173.384 Y164.959 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.5 Y164.694 Z31.4 F60000
G1 Z31
G1 E.8 F1800
; LINE_WIDTH: 0.43173
G1 F1200
M204 S8000
G1 X175.5 Y157.194 E.23035
; CHANGE_LAYER
; Z_HEIGHT: 31.2
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F9259.021
G1 X175.5 Y159.194 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 156/165
; update layer progress
M73 L156
M991 S0 P155 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 1
M204 S10000
G17
G3 Z31.4 I-1.197 J-.218 P1  F60000
G1 X174.388 Y165.29 Z31.4
G1 Z31.2
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X169.618 Y165.29 E.1421
G3 X172.117 Y164.312 I2.402 J2.457 E.08212
G3 X174.345 Y165.249 I-.149 J3.472 E.07352
; COOLING_NODE: 1
; WIPE_START
G1 F9547.055
M204 S8000
G1 X172.345 Y165.266 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X174.869 Y158.063 Z31.6 F60000
G1 X175.102 Y157.398 Z31.6
G1 Z31.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X164.602 Y157.398 E.33764
G1 X164.602 Y156.602 E.02559
G1 X175.898 Y156.602 E.36323
G1 X175.898 Y164.898 E.26677
G1 X175.102 Y164.898 E.02559
G1 X175.102 Y157.458 E.23924
; COOLING_NODE: 0
M204 S250
G1 X174.71 Y157.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X164.21 Y157.79 E.31276
G1 X164.21 Y156.21 E.04706
G1 X176.29 Y156.21 E.35982
G1 X176.29 Y165.29 E.27046
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X174.71 Y165.29 E.04706
G1 X174.71 Y157.85 E.22161
; WIPE_START
G1 F9547.055
M204 S8000
G1 X172.71 Y157.839 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.5 Y157.194 Z31.6 F60000
G1 Z31.2
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.4484
G1 F1200
M204 S8000
G1 X175.483 Y157.114 E.00263
; LINE_WIDTH: 0.470635
G1 X175.467 Y157.033 E.00278
G1 X175.306 Y157 E.00556
; LINE_WIDTH: 0.43172
G1 X164.806 Y157 E.32248
; WIPE_START
G1 F9259.259
G1 X166.806 Y157 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X169.829 Y164.008 Z31.6 F60000
G1 X170.265 Y165.02 Z31.6
G1 Z31.2
G1 E.8 F1800
; LINE_WIDTH: 0.42509
G1 F1200
M204 S8000
G1 X170.646 Y164.951 E.0117
; LINE_WIDTH: 0.45347
G1 X171.028 Y164.882 E.01257
; LINE_WIDTH: 0.491708
G1 X171.184 Y164.858 E.00559
; LINE_WIDTH: 0.535362
G1 X171.337 Y164.838 E.00603
; LINE_WIDTH: 0.570512
G1 X171.492 Y164.822 E.00645
; LINE_WIDTH: 0.618811
G3 X172.252 Y164.806 I.514 J6.032 E.03461
; LINE_WIDTH: 0.600453
G3 X172.557 Y164.827 I-.254 J5.842 E.01347
; LINE_WIDTH: 0.560365
G1 X172.711 Y164.844 E.00633
; LINE_WIDTH: 0.522468
G1 X172.866 Y164.865 E.00593
; LINE_WIDTH: 0.488717
G1 X172.944 Y164.877 E.00278
; LINE_WIDTH: 0.463386
G1 X173.021 Y164.89 E.00262
; LINE_WIDTH: 0.435834
G1 X173.384 Y164.959 E.01146
; LINE_WIDTH: 0.406025
G1 X173.747 Y165.028 E.01059
; WIPE_START
G1 F9914.503
G1 X173.384 Y164.959 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.5 Y164.694 Z31.6 F60000
G1 Z31.2
G1 E.8 F1800
; LINE_WIDTH: 0.43173
G1 F1200
M204 S8000
G1 X175.5 Y157.194 E.23035
; CHANGE_LAYER
; Z_HEIGHT: 31.4
; LAYER_HEIGHT: 0.199999
; WIPE_START
G1 F9259.021
G1 X175.5 Y159.194 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 157/165
; update layer progress
M73 L157
M991 S0 P156 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 1
M204 S10000
G17
G3 Z31.6 I-1.197 J-.218 P1  F60000
G1 X174.388 Y165.29 Z31.6
G1 Z31.4
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X169.618 Y165.29 E.14209
G3 X172.117 Y164.312 I2.402 J2.456 E.08212
G3 X174.345 Y165.249 I-.149 J3.471 E.07352
; COOLING_NODE: 1
; WIPE_START
G1 F9547.055
M204 S8000
G1 X172.345 Y165.266 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X174.869 Y158.063 Z31.8 F60000
G1 X175.102 Y157.398 Z31.8
G1 Z31.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X164.602 Y157.398 E.33764
G1 X164.602 Y156.602 E.02559
G1 X175.898 Y156.602 E.36323
G1 X175.898 Y164.898 E.26677
G1 X175.102 Y164.898 E.02559
G1 X175.102 Y157.458 E.23924
; COOLING_NODE: 0
M204 S250
G1 X174.71 Y157.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X164.21 Y157.79 E.31276
G1 X164.21 Y156.21 E.04706
G1 X176.29 Y156.21 E.35982
G1 X176.29 Y165.29 E.27046
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X174.71 Y165.29 E.04706
G1 X174.71 Y157.85 E.22161
; WIPE_START
G1 F9547.055
M204 S8000
G1 X172.71 Y157.839 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.5 Y157.194 Z31.8 F60000
G1 Z31.4
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.4484
G1 F1200
M204 S8000
G1 X175.483 Y157.114 E.00263
; LINE_WIDTH: 0.470635
G1 X175.467 Y157.033 E.00278
G1 X175.306 Y157 E.00556
; LINE_WIDTH: 0.43172
G1 X164.806 Y157 E.32248
; WIPE_START
G1 F9259.259
G1 X166.806 Y157 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X169.829 Y164.008 Z31.8 F60000
G1 X170.265 Y165.02 Z31.8
G1 Z31.4
G1 E.8 F1800
; LINE_WIDTH: 0.42499
G1 F1200
M204 S8000
G1 X170.646 Y164.951 E.0117
; LINE_WIDTH: 0.453437
G1 X171.028 Y164.882 E.01257
; LINE_WIDTH: 0.491606
G1 X171.183 Y164.858 E.00557
; LINE_WIDTH: 0.535287
G1 X171.338 Y164.838 E.00607
; LINE_WIDTH: 0.570535
G1 X171.491 Y164.822 E.00644
; LINE_WIDTH: 0.618809
G3 X172.252 Y164.806 I.514 J6.032 E.03462
; LINE_WIDTH: 0.600434
G3 X172.557 Y164.827 I-.254 J5.844 E.01348
; LINE_WIDTH: 0.560316
G1 X172.711 Y164.844 E.00633
; LINE_WIDTH: 0.522499
G1 X172.865 Y164.865 E.00591
; LINE_WIDTH: 0.488784
G1 X172.944 Y164.877 E.00279
; LINE_WIDTH: 0.463382
G1 X173.022 Y164.89 E.00263
; LINE_WIDTH: 0.435769
G1 X173.384 Y164.959 E.01146
; LINE_WIDTH: 0.405937
G1 X173.747 Y165.028 E.01059
; WIPE_START
G1 F9916.911
G1 X173.384 Y164.959 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.5 Y164.694 Z31.8 F60000
G1 Z31.4
G1 E.8 F1800
; LINE_WIDTH: 0.43173
G1 F1200
M204 S8000
G1 X175.5 Y157.194 E.23035
; CHANGE_LAYER
; Z_HEIGHT: 31.6
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F9259.021
G1 X175.5 Y159.194 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 158/165
; update layer progress
M73 L158
M991 S0 P157 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 1
M204 S10000
G17
G3 Z31.8 I-1.197 J-.218 P1  F60000
G1 X174.388 Y165.29 Z31.8
G1 Z31.6
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X169.618 Y165.29 E.14209
G3 X172.117 Y164.312 I2.402 J2.456 E.08213
G3 X174.345 Y165.249 I-.149 J3.472 E.07352
; COOLING_NODE: 1
; WIPE_START
G1 F9547.055
M204 S8000
M73 P96 R1
G1 X172.345 Y165.266 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X174.869 Y158.063 Z32 F60000
G1 X175.102 Y157.398 Z32
G1 Z31.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X164.602 Y157.398 E.33764
G1 X164.602 Y156.602 E.02559
G1 X175.898 Y156.602 E.36323
G1 X175.898 Y164.898 E.26677
G1 X175.102 Y164.898 E.02559
G1 X175.102 Y157.458 E.23924
; COOLING_NODE: 0
M204 S250
G1 X174.71 Y157.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X164.21 Y157.79 E.31276
G1 X164.21 Y156.21 E.04706
G1 X176.29 Y156.21 E.35982
G1 X176.29 Y165.29 E.27046
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X174.71 Y165.29 E.04706
G1 X174.71 Y157.85 E.22161
; WIPE_START
G1 F9547.055
M204 S8000
G1 X172.71 Y157.839 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.5 Y157.194 Z32 F60000
G1 Z31.6
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.4484
G1 F1200
M204 S8000
G1 X175.483 Y157.114 E.00263
; LINE_WIDTH: 0.470635
G1 X175.467 Y157.033 E.00278
G1 X175.306 Y157 E.00556
; LINE_WIDTH: 0.43172
G1 X164.806 Y157 E.32248
; WIPE_START
G1 F9259.259
G1 X166.806 Y157 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X169.829 Y164.008 Z32 F60000
G1 X170.265 Y165.02 Z32
G1 Z31.6
G1 E.8 F1800
; LINE_WIDTH: 0.425052
G1 F1200
M204 S8000
G1 X170.646 Y164.951 E.01169
; LINE_WIDTH: 0.453378
G1 X171.027 Y164.882 E.01256
; LINE_WIDTH: 0.491667
G1 X171.184 Y164.858 E.00561
; LINE_WIDTH: 0.535393
G1 X171.338 Y164.838 E.00604
; LINE_WIDTH: 0.570503
G1 X171.491 Y164.822 E.00643
; LINE_WIDTH: 0.618791
G3 X172.252 Y164.806 I.514 J6.031 E.03462
; LINE_WIDTH: 0.600435
G3 X172.557 Y164.827 I-.252 J5.824 E.01349
; LINE_WIDTH: 0.560336
G1 X172.711 Y164.844 E.00632
; LINE_WIDTH: 0.522526
G1 X172.865 Y164.865 E.00591
; LINE_WIDTH: 0.488798
G1 X172.944 Y164.877 E.00279
; LINE_WIDTH: 0.46336
G1 X173.022 Y164.89 E.00263
; LINE_WIDTH: 0.435716
G1 X173.385 Y164.959 E.01145
; LINE_WIDTH: 0.405906
G1 X173.747 Y165.028 E.01059
; WIPE_START
G1 F9917.755
G1 X173.385 Y164.959 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.5 Y164.694 Z32 F60000
G1 Z31.6
G1 E.8 F1800
; LINE_WIDTH: 0.43173
G1 F1200
M204 S8000
G1 X175.5 Y157.194 E.23035
; CHANGE_LAYER
; Z_HEIGHT: 31.8
; LAYER_HEIGHT: 0.199999
; WIPE_START
G1 F9259.021
G1 X175.5 Y159.194 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 159/165
; update layer progress
M73 L159
M991 S0 P158 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 1
M204 S10000
G17
G3 Z32 I-1.197 J-.218 P1  F60000
G1 X174.388 Y165.29 Z32
G1 Z31.8
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X169.618 Y165.29 E.14209
G3 X172.117 Y164.312 I2.402 J2.456 E.08212
G3 X174.345 Y165.249 I-.149 J3.471 E.07352
; COOLING_NODE: 1
; WIPE_START
G1 F9547.055
M204 S8000
G1 X172.345 Y165.266 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X174.869 Y158.063 Z32.2 F60000
G1 X175.102 Y157.398 Z32.2
G1 Z31.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X164.602 Y157.398 E.33764
G1 X164.602 Y156.602 E.02559
G1 X175.898 Y156.602 E.36323
G1 X175.898 Y164.898 E.26677
G1 X175.102 Y164.898 E.02559
G1 X175.102 Y157.458 E.23924
; COOLING_NODE: 0
M204 S250
M73 P96 R0
G1 X174.71 Y157.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X164.21 Y157.79 E.31276
G1 X164.21 Y156.21 E.04706
G1 X176.29 Y156.21 E.35982
G1 X176.29 Y165.29 E.27046
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X174.71 Y165.29 E.04706
G1 X174.71 Y157.85 E.22161
; WIPE_START
G1 F9547.055
M204 S8000
G1 X172.71 Y157.839 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.5 Y157.194 Z32.2 F60000
G1 Z31.8
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.4484
G1 F1200
M204 S8000
G1 X175.483 Y157.114 E.00263
; LINE_WIDTH: 0.470635
G1 X175.467 Y157.033 E.00278
G1 X175.306 Y157 E.00556
; LINE_WIDTH: 0.43172
G1 X164.806 Y157 E.32248
; WIPE_START
G1 F9259.259
G1 X166.806 Y157 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X169.829 Y164.008 Z32.2 F60000
G1 X170.265 Y165.02 Z32.2
G1 Z31.8
G1 E.8 F1800
; LINE_WIDTH: 0.425108
G1 F1200
M204 S8000
G1 X170.646 Y164.951 E.0117
; LINE_WIDTH: 0.45345
G1 X171.028 Y164.882 E.01257
; LINE_WIDTH: 0.491666
G1 X171.184 Y164.858 E.00559
; LINE_WIDTH: 0.535383
G1 X171.338 Y164.838 E.00605
; LINE_WIDTH: 0.570536
G1 X171.491 Y164.822 E.00643
; LINE_WIDTH: 0.618811
G3 X172.252 Y164.806 I.514 J6.031 E.03462
; LINE_WIDTH: 0.600432
G3 X172.557 Y164.827 I-.253 J5.826 E.01348
; LINE_WIDTH: 0.560328
G1 X172.711 Y164.844 E.00633
; LINE_WIDTH: 0.522496
G1 X172.865 Y164.865 E.00591
; LINE_WIDTH: 0.488819
G1 X172.943 Y164.877 E.00278
; LINE_WIDTH: 0.46346
G1 X173.021 Y164.89 E.00262
; LINE_WIDTH: 0.435821
G1 X173.384 Y164.959 E.01146
; LINE_WIDTH: 0.405927
G1 X173.747 Y165.028 E.01059
; WIPE_START
G1 F9917.166
G1 X173.384 Y164.959 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.5 Y164.694 Z32.2 F60000
G1 Z31.8
G1 E.8 F1800
; LINE_WIDTH: 0.43173
G1 F1200
M204 S8000
G1 X175.5 Y157.194 E.23035
; CHANGE_LAYER
; Z_HEIGHT: 32
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F9259.021
G1 X175.5 Y159.194 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 160/165
; update layer progress
M73 L160
M991 S0 P159 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 1
M204 S10000
G17
G3 Z32.2 I-1.197 J-.218 P1  F60000
G1 X174.388 Y165.29 Z32.2
G1 Z32
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X169.618 Y165.29 E.14209
G3 X172.118 Y164.312 I2.402 J2.456 E.08217
G3 X174.345 Y165.249 I-.15 J3.472 E.07348
; COOLING_NODE: 1
; WIPE_START
G1 F9547.055
M204 S8000
G1 X172.345 Y165.266 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X174.869 Y158.063 Z32.4 F60000
G1 X175.102 Y157.398 Z32.4
G1 Z32
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X164.602 Y157.398 E.33764
G1 X164.602 Y156.602 E.02559
G1 X175.898 Y156.602 E.36323
G1 X175.898 Y164.898 E.26677
G1 X175.102 Y164.898 E.02559
G1 X175.102 Y157.458 E.23924
; COOLING_NODE: 0
M204 S250
G1 X174.71 Y157.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X164.21 Y157.79 E.31276
G1 X164.21 Y156.21 E.04706
G1 X176.29 Y156.21 E.35982
G1 X176.29 Y165.29 E.27046
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X174.71 Y165.29 E.04706
G1 X174.71 Y157.85 E.22161
; WIPE_START
G1 F9547.055
M204 S8000
M73 P97 R0
G1 X172.71 Y157.839 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.5 Y157.194 Z32.4 F60000
G1 Z32
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.4484
G1 F1200
M204 S8000
G1 X175.483 Y157.114 E.00263
; LINE_WIDTH: 0.470635
G1 X175.467 Y157.033 E.00278
G1 X175.306 Y157 E.00556
; LINE_WIDTH: 0.43172
G1 X164.806 Y157 E.32248
; WIPE_START
G1 F9259.259
G1 X166.806 Y157 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X169.829 Y164.008 Z32.4 F60000
G1 X170.265 Y165.02 Z32.4
G1 Z32
G1 E.8 F1800
; LINE_WIDTH: 0.42566
G1 F1200
M204 S8000
G1 X170.647 Y164.95 E.01174
; LINE_WIDTH: 0.4541
G1 X171.03 Y164.881 E.01262
; LINE_WIDTH: 0.492153
G1 X171.185 Y164.857 E.00556
; LINE_WIDTH: 0.535651
G1 X171.339 Y164.838 E.00606
; LINE_WIDTH: 0.570763
G1 X171.493 Y164.822 E.00644
; LINE_WIDTH: 0.618855
G3 X172.253 Y164.806 I.513 J6.034 E.03462
; LINE_WIDTH: 0.600287
G3 X172.558 Y164.827 I-.252 J5.801 E.01348
; LINE_WIDTH: 0.560117
G1 X172.712 Y164.844 E.00631
; LINE_WIDTH: 0.522219
G1 X172.867 Y164.865 E.00593
; LINE_WIDTH: 0.488506
G1 X172.944 Y164.877 E.00276
; LINE_WIDTH: 0.463276
G1 X173.022 Y164.89 E.00261
; LINE_WIDTH: 0.435718
G1 X173.384 Y164.959 E.01146
; LINE_WIDTH: 0.405799
G1 X173.747 Y165.028 E.01058
; WIPE_START
G1 F9920.659
G1 X173.384 Y164.959 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.5 Y164.694 Z32.4 F60000
G1 Z32
G1 E.8 F1800
; LINE_WIDTH: 0.43173
G1 F1200
M204 S8000
G1 X175.5 Y157.194 E.23035
; CHANGE_LAYER
; Z_HEIGHT: 32.2
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F9259.021
G1 X175.5 Y159.194 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 161/165
; update layer progress
M73 L161
M991 S0 P160 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 1
M204 S10000
G17
G3 Z32.4 I-1.197 J-.218 P1  F60000
G1 X174.388 Y165.29 Z32.4
G1 Z32.2
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X169.618 Y165.29 E.14209
G3 X172.12 Y164.312 I2.402 J2.456 E.08223
G3 X174.345 Y165.249 I-.152 J3.472 E.07341
; COOLING_NODE: 1
; WIPE_START
G1 F9547.055
M204 S8000
G1 X172.345 Y165.266 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X174.869 Y158.063 Z32.6 F60000
G1 X175.102 Y157.398 Z32.6
G1 Z32.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X164.602 Y157.398 E.33764
G1 X164.602 Y156.602 E.02559
G1 X175.898 Y156.602 E.36323
G1 X175.898 Y164.898 E.26677
G1 X175.102 Y164.898 E.02559
G1 X175.102 Y157.458 E.23924
; COOLING_NODE: 0
M204 S250
G1 X174.71 Y157.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X164.21 Y157.79 E.31276
G1 X164.21 Y156.21 E.04706
G1 X176.29 Y156.21 E.35982
G1 X176.29 Y165.29 E.27046
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X174.71 Y165.29 E.04706
G1 X174.71 Y157.85 E.22161
; WIPE_START
G1 F9547.055
M204 S8000
G1 X172.71 Y157.839 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.5 Y157.194 Z32.6 F60000
G1 Z32.2
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.4484
G1 F1200
M204 S8000
G1 X175.483 Y157.114 E.00263
; LINE_WIDTH: 0.470635
G1 X175.467 Y157.033 E.00278
G1 X175.306 Y157 E.00556
; LINE_WIDTH: 0.43172
G1 X164.806 Y157 E.32248
; WIPE_START
G1 F9259.259
G1 X166.806 Y157 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X169.83 Y164.008 Z32.6 F60000
G1 X170.266 Y165.019 Z32.6
G1 Z32.2
G1 E.8 F1800
; LINE_WIDTH: 0.426895
G1 F1200
M204 S8000
G1 X170.649 Y164.95 E.0118
; LINE_WIDTH: 0.455032
G1 X171.032 Y164.881 E.01266
; LINE_WIDTH: 0.492986
G1 X171.188 Y164.857 E.0056
; LINE_WIDTH: 0.536414
G1 X171.342 Y164.837 E.00606
; LINE_WIDTH: 0.571288
G1 X171.495 Y164.822 E.00641
; LINE_WIDTH: 0.618949
G3 X172.255 Y164.806 I.51 J6.03 E.03461
; LINE_WIDTH: 0.600065
G3 X172.559 Y164.827 I-.258 J5.857 E.01344
; LINE_WIDTH: 0.559881
G1 X172.713 Y164.844 E.0063
; LINE_WIDTH: 0.522029
G1 X172.867 Y164.865 E.00591
; LINE_WIDTH: 0.488239
G1 X172.945 Y164.878 E.00278
; LINE_WIDTH: 0.462773
G1 X173.023 Y164.89 E.00262
; LINE_WIDTH: 0.435126
G1 X173.386 Y164.959 E.01142
; LINE_WIDTH: 0.405309
G1 X173.748 Y165.028 E.01055
; WIPE_START
G1 F9934.086
G1 X173.386 Y164.959 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.5 Y164.694 Z32.6 F60000
G1 Z32.2
G1 E.8 F1800
; LINE_WIDTH: 0.43173
G1 F1200
M204 S8000
G1 X175.5 Y157.194 E.23035
; CHANGE_LAYER
; Z_HEIGHT: 32.4
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F9259.021
G1 X175.5 Y159.194 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 162/165
; update layer progress
M73 L162
M991 S0 P161 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 1
M204 S10000
G17
G3 Z32.6 I-1.197 J-.218 P1  F60000
G1 X174.388 Y165.29 Z32.6
G1 Z32.4
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X169.618 Y165.29 E.14209
G3 X172.123 Y164.312 I2.402 J2.456 E.08229
G3 X174.345 Y165.249 I-.155 J3.472 E.07335
; COOLING_NODE: 1
; WIPE_START
G1 F9547.055
M204 S8000
G1 X172.345 Y165.266 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X174.869 Y158.063 Z32.8 F60000
G1 X175.102 Y157.398 Z32.8
G1 Z32.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X164.602 Y157.398 E.33764
G1 X164.602 Y156.602 E.02559
G1 X175.898 Y156.602 E.36323
G1 X175.898 Y164.898 E.26677
G1 X175.102 Y164.898 E.02559
G1 X175.102 Y157.458 E.23924
; COOLING_NODE: 0
M204 S250
G1 X174.71 Y157.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X164.21 Y157.79 E.31276
G1 X164.21 Y156.21 E.04706
G1 X176.29 Y156.21 E.35982
G1 X176.29 Y165.29 E.27046
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X174.71 Y165.29 E.04706
G1 X174.71 Y157.85 E.22161
; WIPE_START
G1 F9547.055
M204 S8000
G1 X172.71 Y157.839 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.5 Y157.194 Z32.8 F60000
G1 Z32.4
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.4484
G1 F1200
M204 S8000
G1 X175.483 Y157.114 E.00263
; LINE_WIDTH: 0.470635
G1 X175.467 Y157.033 E.00278
G1 X175.306 Y157 E.00556
; LINE_WIDTH: 0.43172
G1 X164.806 Y157 E.32248
; WIPE_START
G1 F9259.259
G1 X166.806 Y157 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X169.83 Y164.008 Z32.8 F60000
G1 X170.267 Y165.019 Z32.8
G1 Z32.4
G1 E.8 F1800
; LINE_WIDTH: 0.427843
G1 F1200
M204 S8000
G1 X170.651 Y164.949 E.01187
; LINE_WIDTH: 0.456041
G1 X171.035 Y164.88 E.01274
; LINE_WIDTH: 0.493926
G1 X171.191 Y164.857 E.00561
; LINE_WIDTH: 0.537109
G1 X171.344 Y164.837 E.00604
; LINE_WIDTH: 0.571804
G1 X171.498 Y164.822 E.00643
; LINE_WIDTH: 0.619065
G3 X172.257 Y164.806 I.507 J6.03 E.03458
; LINE_WIDTH: 0.599843
G3 X172.561 Y164.827 I-.256 J5.8 E.01342
; LINE_WIDTH: 0.559548
G1 X172.714 Y164.844 E.0063
; LINE_WIDTH: 0.521614
G1 X172.869 Y164.865 E.0059
; LINE_WIDTH: 0.487854
G1 X172.946 Y164.878 E.00277
; LINE_WIDTH: 0.462498
G1 X173.024 Y164.891 E.00261
; LINE_WIDTH: 0.434893
G1 X173.386 Y164.959 E.0114
; LINE_WIDTH: 0.405031
G1 X173.748 Y165.028 E.01054
; WIPE_START
G1 F9941.706
G1 X173.386 Y164.959 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.5 Y164.694 Z32.8 F60000
G1 Z32.4
G1 E.8 F1800
; LINE_WIDTH: 0.43173
G1 F1200
M204 S8000
G1 X175.5 Y157.194 E.23035
; CHANGE_LAYER
; Z_HEIGHT: 32.6
; LAYER_HEIGHT: 0.199997
; WIPE_START
G1 F9259.021
G1 X175.5 Y159.194 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 163/165
; update layer progress
M73 L163
M991 S0 P162 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 1
M204 S10000
G17
G3 Z32.8 I-1.197 J-.218 P1  F60000
G1 X174.388 Y165.29 Z32.8
G1 Z32.6
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X169.618 Y165.29 E.14207
G3 X172.124 Y164.312 I2.401 J2.453 E.08233
G3 X174.345 Y165.249 I-.156 J3.472 E.0733
; COOLING_NODE: 1
; WIPE_START
G1 F9547.055
M204 S8000
G1 X172.345 Y165.266 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X174.869 Y158.063 Z33 F60000
G1 X175.102 Y157.398 Z33
G1 Z32.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X164.602 Y157.398 E.33764
G1 X164.602 Y156.602 E.02559
G1 X175.898 Y156.602 E.36323
G1 X175.898 Y164.898 E.26677
M73 P98 R0
G1 X175.102 Y164.898 E.02559
G1 X175.102 Y157.458 E.23924
; COOLING_NODE: 0
M204 S250
G1 X174.71 Y157.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X164.21 Y157.79 E.31276
G1 X164.21 Y156.21 E.04706
G1 X176.29 Y156.21 E.35982
G1 X176.29 Y165.29 E.27046
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X174.71 Y165.29 E.04706
G1 X174.71 Y157.85 E.22161
; WIPE_START
G1 F9547.055
M204 S8000
G1 X172.71 Y157.839 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.5 Y157.194 Z33 F60000
G1 Z32.6
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.4484
G1 F1200
M204 S8000
G1 X175.483 Y157.114 E.00263
; LINE_WIDTH: 0.470635
G1 X175.467 Y157.033 E.00278
G1 X175.306 Y157 E.00556
; LINE_WIDTH: 0.43172
G1 X164.806 Y157 E.32248
; WIPE_START
G1 F9259.259
G1 X166.806 Y157 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X169.831 Y164.007 Z33 F60000
G1 X170.267 Y165.018 Z33
G1 Z32.6
G1 E.8 F1800
; LINE_WIDTH: 0.429049
G1 F1200
M204 S8000
G1 X170.653 Y164.949 E.01194
; LINE_WIDTH: 0.457057
G1 X171.038 Y164.88 E.0128
; LINE_WIDTH: 0.494717
G1 X171.193 Y164.856 E.0056
; LINE_WIDTH: 0.537685
G1 X171.347 Y164.837 E.00605
; LINE_WIDTH: 0.572264
G1 X171.5 Y164.822 E.00645
; LINE_WIDTH: 0.619176
G3 X172.258 Y164.806 I.505 J6.032 E.03454
; LINE_WIDTH: 0.599623
G3 X172.562 Y164.827 I-.258 J5.813 E.0134
; LINE_WIDTH: 0.559212
G1 X172.716 Y164.844 E.0063
; LINE_WIDTH: 0.521238
G1 X172.87 Y164.865 E.00588
; LINE_WIDTH: 0.487471
G1 X172.948 Y164.878 E.00277
; LINE_WIDTH: 0.462064
G1 X173.025 Y164.891 E.00261
; LINE_WIDTH: 0.434436
G1 X173.387 Y164.96 E.01137
; LINE_WIDTH: 0.404612
G1 X173.748 Y165.028 E.01051
; WIPE_START
G1 F9953.227
G1 X173.387 Y164.96 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.5 Y164.694 Z33 F60000
G1 Z32.6
G1 E.8 F1800
; LINE_WIDTH: 0.43173
G1 F1200
M204 S8000
G1 X175.5 Y157.194 E.23035
; CHANGE_LAYER
; Z_HEIGHT: 32.8
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F9259.021
G1 X175.5 Y159.194 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 164/165
; update layer progress
M73 L164
M991 S0 P163 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 1
M204 S10000
G17
G3 Z33 I-1.197 J-.218 P1  F60000
G1 X174.388 Y165.29 Z33
G1 Z32.8
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X169.617 Y165.29 E.1421
G3 X172.127 Y164.312 I2.402 J2.456 E.08243
G3 X174.345 Y165.249 I-.159 J3.472 E.07322
; COOLING_NODE: 1
; WIPE_START
G1 F9547.055
M204 S8000
G1 X172.345 Y165.266 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X174.869 Y158.063 Z33.2 F60000
G1 X175.102 Y157.398 Z33.2
G1 Z32.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X164.602 Y157.398 E.33764
G1 X164.602 Y156.602 E.02559
G1 X175.898 Y156.602 E.36323
G1 X175.898 Y164.898 E.26677
G1 X175.102 Y164.898 E.02559
G1 X175.102 Y157.458 E.23924
; COOLING_NODE: 0
M204 S250
G1 X174.71 Y157.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X164.21 Y157.79 E.31276
G1 X164.21 Y156.21 E.04706
G1 X176.29 Y156.21 E.35982
G1 X176.29 Y165.29 E.27046
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X174.71 Y165.29 E.04706
G1 X174.71 Y157.85 E.22161
; WIPE_START
G1 F9547.055
M204 S8000
G1 X172.71 Y157.839 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.5 Y157.194 Z33.2 F60000
G1 Z32.8
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.4484
G1 F1200
M204 S8000
G1 X175.483 Y157.114 E.00263
; LINE_WIDTH: 0.470635
G1 X175.467 Y157.033 E.00278
G1 X175.306 Y157 E.00556
; LINE_WIDTH: 0.43172
G1 X164.806 Y157 E.32248
; WIPE_START
G1 F9259.259
G1 X166.806 Y157 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X169.833 Y164.006 Z33.2 F60000
G1 X170.27 Y165.017 Z33.2
G1 Z32.8
G1 E.8 F1800
; LINE_WIDTH: 0.430226
G1 F1200
M204 S8000
G1 X170.655 Y164.948 E.01198
; LINE_WIDTH: 0.458089
G1 X171.041 Y164.879 E.01284
; LINE_WIDTH: 0.495575
G1 X171.196 Y164.856 E.0056
; LINE_WIDTH: 0.538349
G1 X171.349 Y164.837 E.00605
; LINE_WIDTH: 0.572722
G1 X171.502 Y164.822 E.00643
; LINE_WIDTH: 0.619265
G3 X172.26 Y164.806 I.503 J6.027 E.03453
; LINE_WIDTH: 0.599375
G3 X172.564 Y164.828 I-.26 J5.812 E.0134
; LINE_WIDTH: 0.558897
G1 X172.717 Y164.844 E.00627
; LINE_WIDTH: 0.520921
G1 X172.871 Y164.866 E.00587
; LINE_WIDTH: 0.487132
G1 X172.949 Y164.878 E.00276
; LINE_WIDTH: 0.461751
G1 X173.026 Y164.891 E.0026
; LINE_WIDTH: 0.434124
G1 X173.387 Y164.96 E.01136
; LINE_WIDTH: 0.404215
G1 X173.748 Y165.028 E.01049
; WIPE_START
G1 F9964.168
G1 X173.387 Y164.96 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.5 Y164.694 Z33.2 F60000
G1 Z32.8
G1 E.8 F1800
; LINE_WIDTH: 0.43173
G1 F1200
M204 S8000
G1 X175.5 Y157.194 E.23035
; CHANGE_LAYER
; Z_HEIGHT: 33
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F9259.021
G1 X175.5 Y159.194 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 165/165
; update layer progress
M73 L165
M991 S0 P164 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 1
M204 S10000
G17
G3 Z33.2 I-1.197 J-.218 P1  F60000
G1 X174.388 Y165.29 Z33.2
G1 Z33
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
M73 P99 R0
G1 F1200
M204 S5000
G1 X169.617 Y165.29 E.1421
G3 X172.129 Y164.313 I2.402 J2.457 E.0825
G3 X174.345 Y165.249 I-.161 J3.471 E.07315
; COOLING_NODE: 0
; WIPE_START
G1 F9547.055
M204 S8000
G1 X172.345 Y165.266 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X174.647 Y157.989 Z33.4 F60000
G1 X174.71 Y157.79 Z33.4
G1 Z33
G1 E.8 F1800
G1 F1200
M204 S5000
G1 X164.21 Y157.79 E.31276
G1 X164.21 Y156.21 E.04706
G1 X176.29 Y156.21 E.35982
G1 X176.29 Y165.29 E.27046
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X174.71 Y165.29 E.04706
G1 X174.71 Y157.85 E.22161
; WIPE_START
G1 F9547.055
M204 S8000
G1 X172.71 Y157.839 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X176.083 Y157.083 Z33.4 F60000
G1 Z33
G1 E.8 F1800
; FEATURE: Top surface
G1 F1200
M204 S2000
G1 X175.417 Y156.417 E.02805
G1 X175.283 Y156.284
G1 X174.75 Y156.284
G1 X174.883 Y156.417
G1 X176.083 Y157.617 E.05051
G1 X176.216 Y157.75
G1 X176.216 Y158.283
G1 X176.083 Y158.15
G1 X174.35 Y156.417 E.07298
G1 X174.217 Y156.284
G1 X173.683 Y156.284
G1 X173.817 Y156.417
G1 X176.083 Y158.683 E.09544
G1 X176.216 Y158.817
G1 X176.216 Y159.35
G1 X176.083 Y159.216
G1 X174.917 Y158.051 E.04909
G1 X174.784 Y157.917
G1 X174.784 Y158.451
G1 X174.917 Y158.584
G1 X176.083 Y159.75 E.04909
G1 X176.216 Y159.883
G1 X176.216 Y160.416
G1 X176.083 Y160.283
G1 X174.917 Y159.118 E.04909
G1 X174.784 Y158.984
G1 X174.784 Y159.517
G1 X174.917 Y159.651
G1 X176.083 Y160.816 E.04909
G1 X176.216 Y160.95
G1 X176.216 Y161.483
G1 X176.083 Y161.349
G1 X174.917 Y160.184 E.04909
G1 X174.784 Y160.05
G1 X174.784 Y160.584
G1 X174.917 Y160.717
G1 X176.083 Y161.883 E.04909
G1 X176.216 Y162.016
G1 X176.216 Y162.549
G1 X176.083 Y162.416
G1 X174.917 Y161.251 E.04909
G1 X174.784 Y161.117
G1 X174.784 Y161.65
G1 X174.917 Y161.784
G1 X176.083 Y162.949 E.04909
G1 X176.216 Y163.083
G1 X176.216 Y163.616
G1 X176.083 Y163.482
G1 X174.917 Y162.317 E.04909
G1 X174.784 Y162.183
G1 X174.784 Y162.717
G1 X174.917 Y162.85
G1 X176.083 Y164.016 E.04909
G1 X176.216 Y164.149
G1 X176.216 Y164.683
G1 X176.083 Y164.549
G1 X174.917 Y163.384 E.04909
G1 X174.784 Y163.25
G1 X174.784 Y163.783
G1 X174.917 Y163.917
G1 X176.083 Y165.082 E.04909
G1 X176.216 Y165.216
G1 X175.684 Y165.216
G1 X175.55 Y165.083
G1 X174.917 Y164.45 E.02664
; WIPE_START
G1 F9547.055
M204 S8000
G1 X175.55 Y165.083 E-.33991
G1 X175.684 Y165.216 E-.07182
G1 X176.216 Y165.216 E-.20245
G1 X176.083 Y165.082 E-.07182
G1 X175.945 Y164.944 E-.07401
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X174.449 Y157.583 Z33.4 F60000
G1 Z33
G1 E.8 F1800
G1 F1200
M204 S2000
G1 X173.284 Y156.417 E.04909
G1 X173.15 Y156.284
G1 X172.617 Y156.284
G1 X172.75 Y156.417
G1 X173.916 Y157.583 E.04909
G1 X174.049 Y157.716
G1 X173.516 Y157.716
G1 X173.382 Y157.583
G1 X172.217 Y156.417 E.04909
G1 X172.084 Y156.284
G1 X171.55 Y156.284
G1 X171.684 Y156.417
G1 X172.849 Y157.583 E.04909
G1 X172.983 Y157.716
G1 X172.45 Y157.716
G1 X172.316 Y157.583
G1 X171.151 Y156.417 E.04909
G1 X171.017 Y156.284
G1 X170.484 Y156.284
G1 X170.617 Y156.417
G1 X171.783 Y157.583 E.04909
G1 X171.916 Y157.716
G1 X171.383 Y157.716
G1 X171.249 Y157.583
G1 X170.084 Y156.417 E.04909
G1 X169.951 Y156.284
G1 X169.417 Y156.284
G1 X169.551 Y156.417
G1 X170.716 Y157.583 E.04909
G1 X170.85 Y157.716
G1 X170.317 Y157.716
G1 X170.183 Y157.583
G1 X169.018 Y156.417 E.04909
G1 X168.884 Y156.284
G1 X168.351 Y156.284
G1 X168.484 Y156.417
G1 X169.65 Y157.583 E.04909
G1 X169.783 Y157.716
G1 X169.25 Y157.716
G1 X169.116 Y157.583
G1 X167.951 Y156.417 E.04909
G1 X167.817 Y156.284
G1 X167.284 Y156.284
G1 X167.418 Y156.417
G1 X168.583 Y157.583 E.04909
G1 X168.717 Y157.716
G1 X168.183 Y157.716
G1 X168.05 Y157.583
G1 X166.885 Y156.417 E.04909
G1 X166.751 Y156.284
G1 X166.218 Y156.284
G1 X166.351 Y156.417
G1 X167.517 Y157.583 E.04909
G1 X167.65 Y157.716
G1 X167.117 Y157.716
G1 X166.983 Y157.583
G1 X165.818 Y156.417 E.04909
G1 X165.684 Y156.284
G1 X165.151 Y156.284
G1 X165.285 Y156.417
G1 X166.45 Y157.583 E.04909
G1 X166.584 Y157.716
G1 X166.05 Y157.716
G1 X165.917 Y157.583
G1 X164.752 Y156.417 E.04909
G1 X164.618 Y156.284
G1 X164.284 Y156.483
G1 X164.417 Y156.616
G1 X165.384 Y157.583 E.0407
G1 X165.517 Y157.716
G1 X164.984 Y157.716
G1 X164.85 Y157.583
G1 X164.417 Y157.15 E.01824
; WIPE_START
G1 F9547.055
M204 S8000
G1 X164.85 Y157.583 E-.23267
G1 X164.984 Y157.716 E-.07182
G1 X165.517 Y157.716 E-.20264
G1 X165.384 Y157.583 E-.07182
G1 X165.047 Y157.246 E-.18106
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X169.305 Y163.58 Z33.4 F60000
G1 X170.271 Y165.017 Z33.4
G1 Z33
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.431301
G1 F1200
M204 S8000
G1 X170.658 Y164.948 E.01205
; LINE_WIDTH: 0.459167
G1 X171.044 Y164.879 E.01291
; LINE_WIDTH: 0.496475
G1 X171.198 Y164.856 E.00559
; LINE_WIDTH: 0.539062
G1 X171.352 Y164.836 E.00608
; LINE_WIDTH: 0.573301
G1 X171.504 Y164.821 E.0064
; LINE_WIDTH: 0.619357
G3 X172.262 Y164.806 I.5 J6.032 E.03451
; LINE_WIDTH: 0.599115
G3 X172.566 Y164.828 I-.261 J5.808 E.0134
; LINE_WIDTH: 0.558494
G1 X172.719 Y164.845 E.00626
; LINE_WIDTH: 0.520519
G1 X172.872 Y164.866 E.00584
; LINE_WIDTH: 0.486776
G1 X172.95 Y164.878 E.00276
; LINE_WIDTH: 0.461339
G1 X173.028 Y164.891 E.0026
; LINE_WIDTH: 0.433663
G1 X173.388 Y164.96 E.01133
; LINE_WIDTH: 0.403768
G1 X173.749 Y165.029 E.01046
; close powerlost recovery
M1003 S0
; WIPE_START
G1 F9976.508
G1 X173.388 Y164.96 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z33.4 I1.217 J0 P1  F60000
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
G1 Z33.4 F900 ; lower z a little
M1002 judge_flag timelapse_record_flag
M622 J1
    G150.3
    M400 ; wait all motion done
    M991 S0 P-1 ;end smooth timelapse at safe pos
    M400 S5 ;wait for last picture to be taken
M623  ;end of "timelapse_record_flag"

G90
G1 Z43 F900 ; lower z a little

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

    
        G1 Z116.5 F600
        G1 Z114.5
    

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

