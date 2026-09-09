; HEADER_BLOCK_START
; BambuStudio 02.08.02.61
; model printing time: 20m 24s; total estimated time: 25m 51s
; total layer number: 100
; total filament length [mm] : 814.62
; total filament volume [cm^3] : 1959.39
; total filament weight [g] : 2.49
; filament_density: 1.27
; filament_diameter: 1.75
; max_z_height: 20.00
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
M73 P0 R25
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
M73 P1 R25
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
M73 P3 R25
G1 Z5 F1200
G90
G1 X175 Y160 F30000

M622 J1
    M1002 gcode_claim_action : 1
    G29.20 A3
    G29 A1 O X167.469 Y146.193 I15.0625 J27.6131 R
    M400
M623

M622 J2
    M1002 gcode_claim_action : 1
    
        G29.20 A4
        G29 A2 O X167.469 Y146.193 I15.0625 J27.6131 R
    
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
M73 P19 R20
G1 Z5 F1200
G1 X270 Y-0.5 F60000
G28.140 S0 ; cali pre-extrude z pos

M141 S0
M104 S255 A

;===== mech mode sweep start =====
    M1002 gcode_claim_action : 3

    G90
    G1 Z5 F1200
M73 P20 R20
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
; layer num/total_layer_count: 1/100
; update layer progress
M73 L1
M991 S0 P0 ;notify layer change

M106 S0
M106 P2 S0
; OBJECT_ID: 15
G1 X168.647 Y147.574 F60000
M204 S6000
M73 P21 R20
G1 Z.4
G1 Z.2
G1 E.8 F1800
; FEATURE: Brim
; LINE_WIDTH: 0.5
G1 F3000
M204 S500
G1 X169.063 Y147.19 E.02045
G1 X169.539 Y146.878 E.02053
G1 X169.919 Y146.7 E.01517
G1 X170.564 Y146.498 E.02439
G1 X171.288 Y146.422 E.02627
G1 X178.716 Y146.422 E.2682
G1 X179.285 Y146.469 E.02062
G1 X180.196 Y146.752 E.03446
G1 X180.703 Y147.025 E.02079
G1 X181.151 Y147.372 E.02045
G1 X181.535 Y147.788 E.02045
G1 X181.847 Y148.262 E.02048
G1 X182.064 Y148.743 E.01907
G1 X182.227 Y149.287 E.0205
G1 X182.303 Y150.012 E.02632
G1 X182.303 Y169.991 E.72134
G1 X182.256 Y170.56 E.02062
G1 X182.014 Y171.375 E.03072
G1 X181.699 Y171.98 E.0246
G1 X181.353 Y172.426 E.02039
G1 X180.937 Y172.81 E.02045
G1 X180.462 Y173.122 E.02053
G1 X180.081 Y173.3 E.01517
G1 X179.437 Y173.502 E.02439
G1 X178.713 Y173.578 E.02627
G1 X171.285 Y173.578 E.26819
G1 X170.716 Y173.531 E.02062
G1 X169.9 Y173.289 E.03072
G1 X169.296 Y172.974 E.0246
G1 X168.85 Y172.628 E.02039
G1 X168.465 Y172.212 E.02045
G1 X168.154 Y171.738 E.02048
G1 X167.937 Y171.257 E.01907
G1 X167.774 Y170.713 E.0205
G1 X167.698 Y169.988 E.02632
G1 X167.698 Y150.009 E.72135
G1 X167.745 Y149.44 E.02062
G1 X167.987 Y148.625 E.03072
G1 X168.301 Y148.02 E.0246
G1 X168.611 Y147.621 E.01823
M204 S6000
G1 X168.972 Y147.904 F60000
G1 F3000
M204 S500
G1 X168.994 Y147.876 E.00127
G1 X169.337 Y147.559 E.01689
G1 X169.753 Y147.283 E.01802
G1 X170.077 Y147.131 E.01291
G1 X170.671 Y146.946 E.02246
G1 X171.319 Y146.879 E.02351
G1 X178.702 Y146.88 E.2666
G1 X179.211 Y146.925 E.01845
G1 X180.006 Y147.171 E.03004
G1 X180.443 Y147.404 E.01788
G1 X180.832 Y147.703 E.01771
G1 X181.166 Y148.062 E.0177
G1 X181.439 Y148.474 E.01784
G1 X181.637 Y148.912 E.01739
G1 X181.778 Y149.39 E.01798
G1 X181.846 Y150.043 E.0237
G1 X181.846 Y169.966 E.71934
G1 X181.8 Y170.489 E.01894
G1 X181.592 Y171.191 E.02644
G1 X181.305 Y171.742 E.02243
G1 X181.007 Y172.124 E.0175
G1 X180.663 Y172.441 E.01689
G1 X180.247 Y172.717 E.01802
G1 X179.924 Y172.869 E.01291
G1 X179.33 Y173.054 E.02246
G1 X178.682 Y173.121 E.02351
G1 X171.31 Y173.121 E.26618
G1 X170.787 Y173.075 E.01894
G1 X170.085 Y172.867 E.02644
G1 X169.534 Y172.58 E.02243
G1 X169.152 Y172.282 E.0175
G1 X168.82 Y171.921 E.0177
G1 X168.551 Y171.508 E.0178
G1 X168.363 Y171.088 E.01661
G1 X168.222 Y170.61 E.01798
G1 X168.155 Y169.971 E.02318
G1 X168.155 Y150.034 E.71986
G1 X168.2 Y149.511 E.01894
G1 X168.409 Y148.809 E.02644
G1 X168.695 Y148.258 E.02243
G1 X168.935 Y147.951 E.01407
M204 S6000
G1 X169.295 Y148.233 F60000
G1 F3000
M204 S500
G1 X169.324 Y148.196 E.0017
G1 X169.612 Y147.927 E.01421
G1 X169.97 Y147.688 E.01553
G1 X170.234 Y147.562 E.01059
G1 X170.777 Y147.395 E.02049
G1 X171.349 Y147.336 E.02077
G1 X178.676 Y147.337 E.26453
G1 X179.136 Y147.38 E.0167
G1 X179.817 Y147.591 E.02574
G1 X180.185 Y147.784 E.01499
G1 X180.514 Y148.035 E.01496
G1 X180.798 Y148.337 E.01496
G1 X181.031 Y148.686 E.01516
G1 X181.211 Y149.081 E.01565
G1 X181.329 Y149.492 E.01543
G1 X181.389 Y150.074 E.02113
G1 X181.389 Y169.94 E.71729
G1 X181.345 Y170.416 E.01726
G1 X181.17 Y171.006 E.02222
G1 X180.911 Y171.503 E.02024
G1 X180.676 Y171.804 E.01379
G1 X180.389 Y172.073 E.01421
G1 X180.031 Y172.312 E.01553
G1 X179.766 Y172.438 E.01059
G1 X179.224 Y172.605 E.02049
G1 X178.651 Y172.664 E.02078
G1 X171.336 Y172.664 E.26414
G1 X170.86 Y172.62 E.01726
G1 X170.27 Y172.445 E.02222
G1 X169.772 Y172.186 E.02024
G1 X169.455 Y171.937 E.01456
G1 X169.177 Y171.63 E.01496
G1 X168.95 Y171.278 E.01512
G1 X168.79 Y170.92 E.01415
G1 X168.671 Y170.508 E.01547
G1 X168.613 Y169.955 E.0201
G1 X168.612 Y150.06 E.71832
G1 X168.656 Y149.584 E.01726
G1 X168.831 Y148.994 E.02222
G1 X169.089 Y148.497 E.02024
G1 X169.258 Y148.28 E.00993
M204 S6000
G1 X169.618 Y148.564 F60000
G1 F3000
M204 S500
G1 X169.67 Y148.498 E.00304
G1 X169.889 Y148.294 E.01078
G1 X170.188 Y148.092 E.01305
G1 X170.392 Y147.993 E.00819
G1 X170.882 Y147.843 E.0185
G1 X171.38 Y147.793 E.01806
G1 X178.648 Y147.794 E.26242
G1 X179.06 Y147.835 E.01495
G1 X179.63 Y148.012 E.02156
G1 X179.928 Y148.166 E.01212
G1 X180.215 Y148.384 E.01302
G1 X180.446 Y148.632 E.01222
G1 X180.624 Y148.9 E.01163
G1 X180.777 Y149.231 E.01315
G1 X180.88 Y149.591 E.01354
G1 X180.931 Y150.09 E.0181
G1 X180.932 Y169.913 E.71571
G1 X180.89 Y170.342 E.01559
G1 X180.748 Y170.822 E.01805
G1 X180.518 Y171.265 E.01805
G1 X180.33 Y171.502 E.0109
G1 X180.112 Y171.706 E.01078
G1 X179.813 Y171.908 E.01305
G1 X179.609 Y172.007 E.00819
G1 X179.119 Y172.157 E.0185
G1 X178.621 Y172.207 E.01806
G1 X171.363 Y172.207 E.26205
G1 X170.933 Y172.165 E.01558
G1 X170.454 Y172.023 E.01805
G1 X170.011 Y171.793 E.01803
G1 X169.761 Y171.593 E.01157
G1 X169.534 Y171.341 E.01223
G1 X169.348 Y171.05 E.01245
G1 X169.218 Y170.754 E.01169
G1 X169.12 Y170.408 E.01297
G1 X169.071 Y169.938 E.01707
G1 X169.069 Y150.087 E.71672
G1 X169.111 Y149.658 E.01558
G1 X169.253 Y149.179 E.01805
G1 X169.483 Y148.735 E.01805
G1 X169.581 Y148.611 E.00569
M204 S6000
G1 X169.964 Y148.877 F60000
G1 F3000
M204 S500
G1 X169.968 Y148.87 E.0003
G1 X170.057 Y148.771 E.00479
G1 X170.317 Y148.56 E.0121
G1 X170.572 Y148.419 E.01051
G1 X170.805 Y148.337 E.00891
G1 X171.199 Y148.261 E.01452
G1 X178.894 Y148.269 E.27781
G1 X179.183 Y148.329 E.01068
G1 X179.391 Y148.402 E.00794
G1 X179.571 Y148.495 E.00731
G1 X179.855 Y148.693 E.01249
G1 X179.955 Y148.783 E.00488
G1 X180.175 Y149.059 E.01274
G1 X180.294 Y149.27 E.00876
G1 X180.384 Y149.495 E.00873
G1 X180.475 Y150.035 E.0198
G1 X180.475 Y169.972 E.71983
G1 X180.44 Y170.272 E.01093
G1 X180.353 Y170.584 E.01167
G1 X180.133 Y170.999 E.01696
G1 X180.064 Y171.093 E.00419
G1 X179.791 Y171.361 E.01384
G1 X179.473 Y171.559 E.01352
G1 X179.229 Y171.659 E.0095
G1 X178.689 Y171.75 E.01977
G1 X171.107 Y171.731 E.27377
G1 X170.819 Y171.671 E.01063
G1 X170.578 Y171.58 E.00928
G1 X170.276 Y171.407 E.01259
G1 X170.122 Y171.291 E.00695
G1 X169.825 Y170.94 E.01664
G1 X169.706 Y170.73 E.00869
G1 X169.616 Y170.505 E.00874
G1 X169.526 Y169.965 E.01979
G1 X169.531 Y149.953 E.72255
G1 X169.58 Y149.639 E.01147
G1 X169.68 Y149.331 E.01168
G1 X169.771 Y149.155 E.00718
G1 X169.93 Y148.926 E.01004
M204 S6000
G1 X170.305 Y149.186 F60000
G1 F3000
M204 S500
G1 X170.349 Y149.123 E.00278
G1 X170.541 Y148.959 E.00911
G1 X170.734 Y148.846 E.00808
G1 X170.881 Y148.788 E.00572
G1 X171.299 Y148.707 E.01536
G1 X178.796 Y148.715 E.27069
G1 X179.033 Y148.76 E.00871
G1 X179.191 Y148.813 E.00604
G1 X179.303 Y148.866 E.00445
G1 X179.602 Y149.073 E.01313
G1 X179.772 Y149.274 E.0095
G1 X179.901 Y149.503 E.00949
G1 X179.959 Y149.662 E.0061
G1 X180.018 Y150.024 E.01326
G1 X180.018 Y169.98 E.72053
G1 X179.986 Y170.221 E.00878
G1 X179.913 Y170.463 E.00913
G1 X179.733 Y170.777 E.01307
G1 X179.558 Y170.968 E.00935
G1 X179.222 Y171.176 E.01425
G1 X179.063 Y171.234 E.0061
G1 X178.701 Y171.293 E.01325
G1 X171.205 Y171.285 E.27066
G1 X170.968 Y171.24 E.00871
G1 X170.814 Y171.188 E.00584
G1 X170.495 Y171.006 E.01329
G1 X170.402 Y170.931 E.0043
G1 X170.229 Y170.726 E.00969
G1 X170.1 Y170.497 E.00949
G1 X170.042 Y170.338 E.0061
G1 X169.983 Y169.976 E.01325
G1 X169.983 Y150.02 E.72053
G1 X170.015 Y149.779 E.00878
G1 X170.09 Y149.532 E.00932
G1 X170.142 Y149.422 E.00439
G1 X170.271 Y149.236 E.00819
M204 S6000
G1 X170.649 Y149.474 F60000
G1 F3000
M204 S500
G1 X170.659 Y149.458 E.00067
G1 X170.761 Y149.36 E.00513
G1 X170.974 Y149.235 E.0089
G1 X171.286 Y149.164 E.01155
G1 X178.714 Y149.164 E.2682
G1 X178.88 Y149.191 E.00607
G1 X179.055 Y149.25 E.00666
G1 X179.267 Y149.383 E.00905
G1 X179.367 Y149.487 E.00523
G1 X179.508 Y149.737 E.01036
G1 X179.561 Y150.013 E.01013
G1 X179.561 Y169.989 E.72126
G1 X179.534 Y170.155 E.00607
G1 X179.476 Y170.33 E.00666
G1 X179.342 Y170.542 E.00905
G1 X179.238 Y170.642 E.00523
G1 X178.988 Y170.783 E.01036
G1 X178.712 Y170.836 E.01013
G1 X171.287 Y170.836 E.2681
G1 X171.121 Y170.809 E.00607
G1 X170.946 Y170.751 E.00666
G1 X170.734 Y170.617 E.00905
G1 X170.633 Y170.513 E.00523
G1 X170.492 Y170.263 E.01036
G1 X170.44 Y169.987 E.01013
G1 X170.44 Y150.011 E.72126
G1 X170.467 Y149.845 E.00607
G1 X170.525 Y149.67 E.00666
G1 X170.617 Y149.525 E.00621
M204 S6000
G1 X170.964 Y149.799 F60000
G1 F3000
M204 S500
G1 X171.09 Y149.677 E.00631
G1 X171.276 Y149.621 E.007
G1 X178.725 Y149.621 E.26897
G1 X178.926 Y149.688 E.00766
G1 X179.048 Y149.814 E.00631
G1 X179.088 Y149.916 E.00396
G1 X179.104 Y150 E.00307
G1 X179.104 Y170 E.72212
G1 X179.037 Y170.201 E.00766
G1 X178.911 Y170.323 E.00631
G1 X178.809 Y170.363 E.00396
G1 X178.725 Y170.379 E.00307
G1 X171.276 Y170.379 E.26897
G1 X171.074 Y170.312 E.00766
G1 X170.953 Y170.186 E.00631
G1 X170.913 Y170.084 E.00396
G1 X170.897 Y170 E.00307
G1 X170.897 Y150 E.72212
G1 X170.945 Y149.856 E.00549
; WIPE_START
G1 X171.09 Y149.677 E-.08729
G1 X171.276 Y149.621 E-.07367
G1 X172.852 Y149.621 E-.59903
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X174.869 Y156.983 Z.6 F60000
G1 X178.325 Y169.6 Z.6
G1 Z.2
G1 E.8 F1800
; FEATURE: Outer wall
G1 F3000
M204 S500
G1 X171.676 Y169.6 E.24008
G1 X171.676 Y150.4 E.69324
G1 X178.325 Y150.4 E.24008
G1 X178.325 Y169.54 E.69107
;======== H2D 20260731========
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
G1 X177.868 Y169.143 F60000
; FEATURE: Inner wall
G1 F3000
M204 S500
G1 X172.133 Y169.143 E.20708
G1 X172.133 Y150.857 E.66023
G1 X177.868 Y150.857 E.20708
G1 X177.868 Y169.083 E.65806
M204 S6000
G1 X177.411 Y168.686 F60000
G1 F3000
M204 S500
M73 P22 R20
G1 X172.59 Y168.686 E.17407
G1 X172.59 Y151.314 E.62722
G1 X177.411 Y151.314 E.17407
G1 X177.411 Y168.626 E.62506
M204 S6000
G1 X176.954 Y168.229 F60000
G1 F3000
M204 S500
G1 X173.047 Y168.229 E.14107
G1 X173.047 Y151.771 E.59422
G1 X176.954 Y151.771 E.14107
G1 X176.954 Y168.169 E.59205
; WIPE_START
G1 X174.954 Y168.2 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X175.854 Y160.62 Z.6 F60000
G1 X176.771 Y152.895 Z.6
G1 Z.2
G1 E.8 F1800
; FEATURE: Bottom surface
; LINE_WIDTH: 0.50783
G1 F6300
M204 S500
G1 X176.036 Y152.16 E.03817
G1 X175.379 Y152.16 E.02415
G1 X176.565 Y153.346 E.06163
G1 X176.565 Y154.004 E.02415
G1 X174.721 Y152.16 E.09578
G1 X174.064 Y152.16 E.02415
G1 X176.565 Y154.661 E.12993
G1 X176.565 Y155.319 E.02415
G1 X173.435 Y152.189 E.16256
G1 X173.435 Y152.846 E.02415
G1 X176.565 Y155.976 E.16256
G1 X176.565 Y156.634 E.02415
G1 X173.435 Y153.504 E.16256
G1 X173.435 Y154.161 E.02415
G1 X176.565 Y157.291 E.16256
G1 X176.565 Y157.949 E.02415
G1 X173.435 Y154.819 E.16256
G1 X173.435 Y155.476 E.02415
G1 X176.565 Y158.606 E.16256
G1 X176.565 Y159.264 E.02415
G1 X173.435 Y156.134 E.16256
G1 X173.435 Y156.791 E.02415
G1 X176.565 Y159.921 E.16256
G1 X176.565 Y160.579 E.02415
G1 X173.435 Y157.449 E.16256
G1 X173.435 Y158.106 E.02415
G1 X176.565 Y161.236 E.16256
G1 X176.565 Y161.894 E.02415
G1 X173.435 Y158.764 E.16256
G1 X173.435 Y159.421 E.02415
G1 X176.565 Y162.551 E.16256
G1 X176.565 Y163.209 E.02415
G1 X173.435 Y160.079 E.16256
G1 X173.435 Y160.736 E.02415
G1 X176.565 Y163.866 E.16256
G1 X176.565 Y164.524 E.02415
G1 X173.435 Y161.394 E.16256
G1 X173.435 Y162.051 E.02415
G1 X176.565 Y165.181 E.16256
G1 X176.565 Y165.839 E.02415
G1 X173.435 Y162.709 E.16256
G1 X173.435 Y163.366 E.02415
G1 X176.565 Y166.496 E.16256
G1 X176.565 Y167.154 E.02415
G1 X173.435 Y164.024 E.16256
G1 X173.435 Y164.681 E.02415
G1 X176.565 Y167.811 E.16256
G1 X176.565 Y167.84 E.00107
G1 X175.937 Y167.84 E.02307
G1 X173.435 Y165.339 E.12993
G1 X173.435 Y165.996 E.02415
G1 X175.28 Y167.84 E.09578
G1 X174.622 Y167.84 E.02415
G1 X173.435 Y166.654 E.06164
G1 X173.435 Y167.311 E.02415
G1 X174.17 Y168.046 E.03817
; CHANGE_LAYER
; Z_HEIGHT: 0.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F6300
G1 X173.435 Y167.311 E-.39497
G1 X173.435 Y166.654 E-.24984
G1 X173.65 Y166.868 E-.11518
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 2/100
; update layer progress
M73 L2
M991 S0 P1 ;notify layer change

; open powerlost recovery
M1003 S1
; OBJECT_ID: 15
M204 S10000
G17
G3 Z.6 I-.517 J1.102 P1  F60000
G1 X177.309 Y168.584 Z.6
G1 Z.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1931
M204 S8000
G1 X172.693 Y168.584 E.14843
G1 X172.693 Y151.416 E.55205
G1 X177.309 Y151.416 E.14843
G1 X177.309 Y168.524 E.55012
M204 S10000
G1 X177.716 Y168.991 F60000
G1 F1931
M204 S8000
G1 X172.286 Y168.991 E.17461
G1 X172.286 Y151.009 E.57823
G1 X177.716 Y151.009 E.17461
G1 X177.716 Y168.931 E.5763
M204 S10000
G1 X178.123 Y169.398 F60000
G1 F1931
M204 S8000
G1 X171.879 Y169.398 E.20079
M73 P22 R19
G1 X171.879 Y150.602 E.60441
G1 X178.123 Y150.602 E.20079
G1 X178.123 Y169.338 E.60248
M204 S250
G1 X178.515 Y169.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1931
M204 S5000
G1 X171.487 Y169.79 E.20935
G1 X171.487 Y150.21 E.58322
G1 X178.515 Y150.21 E.20935
G1 X178.515 Y169.73 E.58143
;======== H2D 20260731========
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
G1 X176.515 Y169.747 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.001 Y166.276 Z.8 F60000
G1 Z.4
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.4809
G1 F1931
M204 S8000
G1 X175.001 Y153.784 E.43218
M204 S10000
G1 X175.408 Y153.724 F60000
; LINE_WIDTH: 0.41999
G1 F1931
M204 S8000
G1 X175.408 Y153.317 E.01214
G1 X174.593 Y153.317 E.02428
G1 X174.593 Y166.683 E.39814
G1 X175.408 Y166.683 E.02428
G1 X175.408 Y153.784 E.38422
M204 S10000
G1 X175.786 Y153.724 F60000
M73 P23 R19
G1 F1931
M204 S8000
G1 X175.786 Y152.939 E.02337
G1 X174.216 Y152.939 E.04674
G1 X174.216 Y167.061 E.42061
G1 X175.786 Y167.061 E.04674
G1 X175.786 Y153.784 E.39545
M204 S10000
G1 X176.163 Y153.724 F60000
G1 F1931
M204 S8000
G1 X176.163 Y152.562 E.0346
G1 X173.839 Y152.562 E.0692
G1 X173.839 Y167.438 E.44307
G1 X176.163 Y167.438 E.0692
G1 X176.163 Y153.784 E.40668
M204 S10000
G1 X176.54 Y153.724 F60000
G1 F1931
M204 S8000
G1 X176.54 Y152.185 E.04583
G1 X173.462 Y152.185 E.09167
G1 X173.462 Y167.815 E.46553
G1 X176.54 Y167.815 E.09167
G1 X176.54 Y153.784 E.41791
M204 S10000
G1 X176.917 Y153.724 F60000
G1 F1931
M204 S8000
G1 X176.917 Y151.808 E.05706
G1 X173.085 Y151.808 E.11413
G1 X173.085 Y168.192 E.488
G1 X176.917 Y168.192 E.11413
G1 X176.917 Y153.784 E.42914
; CHANGE_LAYER
; Z_HEIGHT: 0.6
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9547.299
G1 X176.917 Y155.784 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 3/100
; update layer progress
M73 L3
M991 S0 P2 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z.8 I-1.216 J.037 P1  F60000
G1 X177.309 Y168.584 Z.8
G1 Z.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1932
M204 S8000
G1 X172.694 Y168.584 E.14839
G1 X172.694 Y151.416 E.55205
G1 X177.309 Y151.416 E.14839
G1 X177.309 Y168.524 E.55012
; COOLING_NODE: 0
M204 S10000
G1 X177.716 Y168.991 F60000
G1 F1932
M204 S8000
G1 X172.287 Y168.991 E.17457
G1 X172.287 Y151.009 E.57823
G1 X177.716 Y151.009 E.17457
G1 X177.716 Y168.931 E.5763
; COOLING_NODE: 0
M204 S10000
G1 X178.123 Y169.398 F60000
G1 F1932
M204 S8000
G1 X171.88 Y169.398 E.20075
G1 X171.88 Y150.602 E.60441
G1 X178.123 Y150.602 E.20075
G1 X178.123 Y169.338 E.60248
; COOLING_NODE: 0
M204 S250
G1 X178.515 Y169.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1741
M204 S5000
G1 X171.488 Y169.79 E.20931
G1 X171.488 Y150.21 E.58322
G1 X178.515 Y150.21 E.20931
G1 X178.515 Y169.73 E.58143
;======== H2D 20260731========
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
G1 X176.515 Y169.747 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.002 Y166.277 Z1 F60000
G1 Z.6
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.47968
G1 F1932
M204 S8000
G1 X175.002 Y153.783 E.43102
M204 S10000
G1 X175.408 Y153.723 F60000
; LINE_WIDTH: 0.41999
G1 F1932
M204 S8000
G1 X175.408 Y153.317 E.01212
G1 X174.595 Y153.317 E.02424
G1 X174.595 Y166.683 E.39814
G1 X175.408 Y166.683 E.02424
G1 X175.408 Y153.783 E.38424
M204 S10000
G1 X175.786 Y153.723 F60000
G1 F1932
M204 S8000
G1 X175.786 Y152.939 E.02335
G1 X174.218 Y152.939 E.0467
G1 X174.218 Y167.061 E.42061
G1 X175.786 Y167.061 E.0467
G1 X175.786 Y153.783 E.39547
M204 S10000
G1 X176.163 Y153.723 F60000
G1 F1932
M204 S8000
G1 X176.163 Y152.562 E.03458
G1 X173.84 Y152.562 E.06917
G1 X173.84 Y167.438 E.44307
G1 X176.163 Y167.438 E.06917
G1 X176.163 Y153.783 E.4067
M204 S10000
G1 X176.54 Y153.723 F60000
G1 F1932
M204 S8000
G1 X176.54 Y152.185 E.04581
G1 X173.463 Y152.185 E.09163
G1 X173.463 Y167.815 E.46553
G1 X176.54 Y167.815 E.09163
G1 X176.54 Y153.783 E.41793
M204 S10000
G1 X176.917 Y153.723 F60000
M73 P24 R19
G1 F1932
M204 S8000
G1 X176.917 Y151.808 E.05705
G1 X173.086 Y151.808 E.11409
G1 X173.086 Y168.192 E.488
G1 X176.917 Y168.192 E.11409
G1 X176.917 Y153.783 E.42916
; CHANGE_LAYER
; Z_HEIGHT: 0.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9547.299
G1 X176.917 Y155.783 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 4/100
; update layer progress
M73 L4
M991 S0 P3 ;notify layer change

M106 S224.4
; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z1 I-1.216 J.037 P1  F60000
G1 X177.309 Y168.584 Z1
G1 Z.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1932
M204 S8000
G1 X172.696 Y168.584 E.14835
G1 X172.696 Y151.416 E.55205
G1 X177.309 Y151.416 E.14835
G1 X177.309 Y168.524 E.55012
; COOLING_NODE: 0
M204 S10000
G1 X177.716 Y168.991 F60000
G1 F1932
M204 S8000
G1 X172.288 Y168.991 E.17453
G1 X172.288 Y151.009 E.57823
G1 X177.716 Y151.009 E.17453
G1 X177.716 Y168.931 E.5763
; COOLING_NODE: 0
M204 S10000
G1 X178.123 Y169.398 F60000
G1 F1932
M204 S8000
G1 X171.881 Y169.398 E.20071
G1 X171.881 Y150.602 E.60441
G1 X178.123 Y150.602 E.20071
G1 X178.123 Y169.338 E.60248
; COOLING_NODE: 0
M204 S250
G1 X178.515 Y169.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1598
M204 S5000
G1 X171.489 Y169.79 E.20927
G1 X171.489 Y150.21 E.58322
G1 X178.515 Y150.21 E.20927
G1 X178.515 Y169.73 E.58143
;======== H2D 20260731========
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
G1 X176.515 Y169.747 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.002 Y166.277 Z1.2 F60000
G1 Z.8
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.47844
G1 F1932
M204 S8000
G1 X175.002 Y153.783 E.42984
M204 S10000
G1 X175.408 Y153.723 F60000
; LINE_WIDTH: 0.41999
G1 F1932
M204 S8000
G1 X175.408 Y153.317 E.0121
G1 X174.596 Y153.317 E.0242
G1 X174.596 Y166.683 E.39814
G1 X175.408 Y166.683 E.0242
G1 X175.408 Y153.783 E.38426
M204 S10000
G1 X175.786 Y153.723 F60000
G1 F1932
M204 S8000
G1 X175.786 Y152.939 E.02333
G1 X174.219 Y152.939 E.04667
G1 X174.219 Y167.061 E.42061
G1 X175.786 Y167.061 E.04667
G1 X175.786 Y153.783 E.39549
M204 S10000
G1 X176.163 Y153.723 F60000
G1 F1932
M204 S8000
G1 X176.163 Y152.562 E.03456
G1 X173.842 Y152.562 E.06913
G1 X173.842 Y167.438 E.44307
G1 X176.163 Y167.438 E.06913
G1 X176.163 Y153.783 E.40672
M204 S10000
G1 X176.54 Y153.723 F60000
G1 F1932
M204 S8000
G1 X176.54 Y152.185 E.0458
G1 X173.465 Y152.185 E.09159
G1 X173.465 Y167.815 E.46553
G1 X176.54 Y167.815 E.09159
G1 X176.54 Y153.783 E.41795
M204 S10000
G1 X176.917 Y153.723 F60000
G1 F1932
M204 S8000
G1 X176.917 Y151.808 E.05703
G1 X173.088 Y151.808 E.11405
G1 X173.088 Y168.192 E.488
G1 X176.917 Y168.192 E.11405
G1 X176.917 Y153.783 E.42918
; CHANGE_LAYER
; Z_HEIGHT: 1
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9547.299
G1 X176.917 Y155.783 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 5/100
; update layer progress
M73 L5
M991 S0 P4 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z1.2 I-1.216 J.037 P1  F60000
G1 X177.309 Y168.584 Z1.2
G1 Z1
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1931
M204 S8000
G1 X172.697 Y168.584 E.14831
G1 X172.697 Y151.416 E.55205
G1 X177.309 Y151.416 E.14831
G1 X177.309 Y168.524 E.55012
; COOLING_NODE: 0
M204 S10000
G1 X177.716 Y168.991 F60000
M73 P25 R19
G1 F1931
M204 S8000
G1 X172.29 Y168.991 E.17449
G1 X172.29 Y151.009 E.57823
G1 X177.716 Y151.009 E.17449
G1 X177.716 Y168.931 E.5763
; COOLING_NODE: 0
M204 S10000
G1 X178.123 Y169.398 F60000
G1 F1931
M204 S8000
G1 X171.883 Y169.398 E.20067
G1 X171.883 Y150.602 E.60441
G1 X178.123 Y150.602 E.20067
G1 X178.123 Y169.338 E.60248
; COOLING_NODE: 0
M204 S250
G1 X178.515 Y169.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1475
M204 S5000
G1 X171.491 Y169.79 E.20924
G1 X171.491 Y150.21 E.58322
G1 X178.515 Y150.21 E.20924
G1 X178.515 Y169.73 E.58143
;======== H2D 20260731========
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
G1 X176.515 Y169.747 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.003 Y166.278 Z1.4 F60000
G1 Z1
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.47722
G1 F1931
M204 S8000
G1 X175.003 Y153.782 E.42868
M204 S10000
G1 X175.408 Y153.722 F60000
; LINE_WIDTH: 0.41999
G1 F1931
M204 S8000
G1 X175.408 Y153.317 E.01208
G1 X174.597 Y153.317 E.02417
G1 X174.597 Y166.683 E.39814
G1 X175.408 Y166.683 E.02417
G1 X175.408 Y153.782 E.38427
M204 S10000
G1 X175.786 Y153.722 F60000
G1 F1931
M204 S8000
G1 X175.786 Y152.939 E.02332
G1 X174.22 Y152.939 E.04663
G1 X174.22 Y167.061 E.42061
G1 X175.786 Y167.061 E.04663
G1 X175.786 Y153.782 E.39551
M204 S10000
G1 X176.163 Y153.722 F60000
G1 F1931
M204 S8000
G1 X176.163 Y152.562 E.03455
G1 X173.843 Y152.562 E.06909
G1 X173.843 Y167.438 E.44307
G1 X176.163 Y167.438 E.06909
G1 X176.163 Y153.782 E.40674
M204 S10000
G1 X176.54 Y153.722 F60000
G1 F1931
M204 S8000
G1 X176.54 Y152.185 E.04578
G1 X173.466 Y152.185 E.09156
G1 X173.466 Y167.815 E.46553
G1 X176.54 Y167.815 E.09156
G1 X176.54 Y153.782 E.41797
M204 S10000
G1 X176.917 Y153.722 F60000
G1 F1931
M204 S8000
G1 X176.917 Y151.808 E.05701
G1 X173.089 Y151.808 E.11402
G1 X173.089 Y168.192 E.488
G1 X176.917 Y168.192 E.11402
G1 X176.917 Y153.782 E.4292
; CHANGE_LAYER
; Z_HEIGHT: 1.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9547.299
G1 X176.917 Y155.782 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 6/100
; update layer progress
M73 L6
M991 S0 P5 ;notify layer change

M106 S226.95
; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z1.4 I-1.216 J.037 P1  F60000
G1 X177.309 Y168.584 Z1.4
G1 Z1.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1212
M204 S8000
G1 X172.698 Y168.584 E.14827
G1 X172.698 Y151.416 E.55205
G1 X177.309 Y151.416 E.14827
G1 X177.309 Y168.524 E.55012
; COOLING_NODE: 0
M204 S10000
G1 X177.716 Y168.991 F60000
G1 F1212
M204 S8000
G1 X172.291 Y168.991 E.17445
G1 X172.291 Y151.009 E.57823
G1 X177.716 Y151.009 E.17445
G1 X177.716 Y168.931 E.5763
; COOLING_NODE: 0
M204 S10000
G1 X178.123 Y169.398 F60000
M73 P26 R19
G1 F1212
M204 S8000
G1 X171.884 Y169.398 E.20063
G1 X171.884 Y150.602 E.60441
G1 X178.123 Y150.602 E.20063
G1 X178.123 Y169.338 E.60248
; COOLING_NODE: 0
M204 S250
G1 X178.515 Y169.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1212
M204 S5000
G1 X171.492 Y169.79 E.2092
G1 X171.492 Y150.21 E.58322
G1 X178.515 Y150.21 E.2092
G1 X178.515 Y169.73 E.58143
;======== H2D 20260731========
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
G1 X176.515 Y169.747 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X176.961 Y167.731 Z1.6 F60000
G1 Z1.2
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F1212
M204 S8000
G1 X176.961 Y166.103 E.05236
G1 X176.31 Y166.663 E.02759
G3 X174.345 Y167.005 I-1.209 J-1.133 E.06884
G2 X173.046 Y165.979 I-6.385 J6.752 E.05328
G1 X173.046 Y163.488 E.0801
G1 X173.69 Y164.042 E.02731
G2 X175.655 Y164.384 I1.209 J-1.133 E.06884
G3 X176.961 Y163.354 I6.415 J6.787 E.05354
G1 X176.961 Y160.862 E.08013
G1 X176.31 Y161.422 E.02759
G3 X174.345 Y161.763 I-1.209 J-1.133 E.06884
G2 X173.046 Y160.738 I-6.385 J6.752 E.05328
G1 X173.046 Y158.247 E.0801
G1 X173.69 Y158.801 E.02731
G2 X175.655 Y159.143 I1.209 J-1.133 E.06884
G3 X176.961 Y158.113 I6.414 J6.785 E.05354
G1 X176.961 Y155.621 E.08013
G1 X176.31 Y156.18 E.02759
G3 X174.345 Y156.522 I-1.209 J-1.133 E.06884
G2 X173.046 Y155.497 I-6.384 J6.75 E.05328
G1 X173.046 Y153.006 E.0801
G1 X173.69 Y153.56 E.02731
G2 X175.655 Y153.901 I1.209 J-1.133 E.06884
G3 X176.961 Y152.871 I6.415 J6.787 E.05354
G1 X176.961 Y151.764 E.03559
G1 X176.439 Y151.764 E.01677
; CHANGE_LAYER
; Z_HEIGHT: 1.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F8843.478
G1 X176.961 Y151.764 E-.19819
G1 X176.961 Y152.871 E-.42058
G1 X176.669 Y153.102 E-.14124
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 7/100
; update layer progress
M73 L7
M991 S0 P6 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z1.6 I-1.216 J.05 P1  F60000
G1 X177.309 Y168.584 Z1.6
G1 Z1.4
G1 E.8 F1800
; FEATURE: Inner wall
G1 F1213
M204 S8000
G1 X172.699 Y168.584 E.14823
M73 P26 R18
G1 X172.699 Y151.416 E.55205
G1 X177.309 Y151.416 E.14823
G1 X177.309 Y168.524 E.55012
; COOLING_NODE: 0
M204 S10000
G1 X177.716 Y168.991 F60000
G1 F1213
M204 S8000
G1 X172.292 Y168.991 E.17441
G1 X172.292 Y151.009 E.57823
G1 X177.716 Y151.009 E.17441
G1 X177.716 Y168.931 E.5763
; COOLING_NODE: 0
M204 S10000
G1 X178.123 Y169.398 F60000
G1 F1213
M204 S8000
G1 X171.885 Y169.398 E.20059
G1 X171.885 Y150.602 E.60441
G1 X178.123 Y150.602 E.20059
G1 X178.123 Y169.338 E.60248
; COOLING_NODE: 0
M204 S250
G1 X178.515 Y169.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1213
M204 S5000
G1 X171.493 Y169.79 E.20916
M73 P27 R18
G1 X171.493 Y150.21 E.58322
G1 X178.515 Y150.21 E.20916
G1 X178.515 Y169.73 E.58143
;======== H2D 20260731========
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
G1 X176.515 Y169.747 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X173.047 Y167.727 Z1.8 F60000
G1 Z1.4
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F1213
M204 S8000
G1 X173.047 Y166.099 E.05236
G1 X173.69 Y166.642 E.02705
G2 X175.655 Y167.016 I1.234 J-1.136 E.06893
G3 X176.961 Y165.988 I7.759 J8.511 E.05347
G1 X176.961 Y163.472 E.08091
G1 X176.31 Y164.021 E.02738
G3 X174.345 Y164.395 I-1.234 J-1.136 E.06893
G2 X173.047 Y163.373 I-7.715 J8.459 E.05316
G1 X173.047 Y160.858 E.08088
G1 X173.69 Y161.401 E.02705
G2 X175.655 Y161.774 I1.234 J-1.136 E.06893
G3 X176.961 Y160.746 I7.759 J8.511 E.05347
G1 X176.961 Y158.23 E.08091
G1 X176.31 Y158.78 E.02738
G3 X174.345 Y159.154 I-1.234 J-1.136 E.06893
G2 X173.047 Y158.132 I-7.715 J8.459 E.05316
G1 X173.047 Y155.616 E.08088
G1 X173.69 Y156.159 E.02705
G2 X175.655 Y156.533 I1.234 J-1.136 E.06893
G3 X176.961 Y155.505 I7.759 J8.511 E.05347
G1 X176.961 Y152.989 E.08091
G1 X176.31 Y153.539 E.02738
G3 X174.345 Y153.912 I-1.234 J-1.136 E.06893
G2 X173.047 Y152.89 I-7.715 J8.459 E.05316
G1 X173.047 Y151.764 E.0362
G1 X173.55 Y151.764 E.01616
; CHANGE_LAYER
; Z_HEIGHT: 1.6
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F8843.478
G1 X173.047 Y151.764 E-.19095
G1 X173.047 Y152.89 E-.42781
G1 X173.339 Y153.12 E-.14124
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 8/100
; update layer progress
M73 L8
M991 S0 P7 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z1.8 I-1.179 J.303 P1  F60000
G1 X177.309 Y168.584 Z1.8
G1 Z1.6
G1 E.8 F1800
; FEATURE: Inner wall
G1 F1211
M204 S8000
G1 X172.7 Y168.584 E.14819
G1 X172.7 Y151.416 E.55205
G1 X177.309 Y151.416 E.14819
G1 X177.309 Y168.524 E.55012
; COOLING_NODE: 0
M204 S10000
G1 X177.716 Y168.991 F60000
G1 F1211
M204 S8000
G1 X172.293 Y168.991 E.17437
G1 X172.293 Y151.009 E.57823
G1 X177.716 Y151.009 E.17437
G1 X177.716 Y168.931 E.5763
; COOLING_NODE: 0
M204 S10000
G1 X178.123 Y169.398 F60000
G1 F1211
M204 S8000
G1 X171.886 Y169.398 E.20055
G1 X171.886 Y150.602 E.60441
G1 X178.123 Y150.602 E.20055
G1 X178.123 Y169.338 E.60248
; COOLING_NODE: 0
M204 S250
G1 X178.515 Y169.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1211
M204 S5000
G1 X171.494 Y169.79 E.20913
G1 X171.494 Y150.21 E.58322
G1 X178.515 Y150.21 E.20913
G1 X178.515 Y169.73 E.58143
;======== H2D 20260731========
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
G1 X176.515 Y169.747 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X173.049 Y167.829 Z2 F60000
G1 Z1.6
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F1211
M204 S8000
G1 X173.049 Y166.2 E.05236
G2 X174.017 Y167.137 I5.159 J-4.366 E.0434
M73 P28 R18
G2 X175.655 Y166.918 I.614 J-1.645 E.05532
G1 X176.31 Y166.243 E.03025
G3 X176.961 Y165.844 I.894 J.729 E.025
G1 X176.961 Y163.57 E.07311
G3 X175.983 Y164.516 I-5.211 J-4.408 E.04382
G3 X174.345 Y164.297 I-.614 J-1.646 E.05532
G1 X173.69 Y163.622 E.03025
G2 X173.049 Y163.227 I-.885 J.717 E.02468
G1 X173.049 Y160.959 E.07292
G2 X174.017 Y161.896 I5.159 J-4.367 E.0434
G2 X175.655 Y161.676 I.614 J-1.645 E.05532
G1 X176.31 Y161.002 E.03025
G3 X176.961 Y160.603 I.894 J.729 E.025
G1 X176.961 Y158.329 E.07312
G3 X175.983 Y159.275 I-5.21 J-4.406 E.04382
G3 X174.345 Y159.056 I-.614 J-1.645 E.05532
G1 X173.69 Y158.381 E.03025
G2 X173.049 Y157.985 I-.885 J.717 E.02468
G1 X173.049 Y155.718 E.07292
G2 X174.017 Y156.654 I5.159 J-4.366 E.0434
G2 X175.655 Y156.435 I.614 J-1.645 E.05532
G1 X176.31 Y155.76 E.03025
G3 X176.961 Y155.361 I.894 J.729 E.025
G1 X176.961 Y153.088 E.07311
G3 X175.983 Y154.034 I-5.211 J-4.408 E.04382
G3 X174.345 Y153.815 I-.614 J-1.645 E.05532
G1 X173.69 Y153.14 E.03025
G2 X173.049 Y152.744 I-.885 J.717 E.02468
G1 X173.049 Y151.764 E.0315
G1 X173.697 Y151.764 E.02086
; CHANGE_LAYER
; Z_HEIGHT: 1.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F8843.478
G1 X173.049 Y151.764 E-.24648
G1 X173.049 Y152.744 E-.37229
G1 X173.362 Y152.863 E-.12743
G1 X173.39 Y152.887 E-.01381
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 9/100
; update layer progress
M73 L9
M991 S0 P8 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z2 I-1.181 J.295 P1  F60000
G1 X177.309 Y168.584 Z2
G1 Z1.8
G1 E.8 F1800
; FEATURE: Inner wall
G1 F1214
M204 S8000
G1 X172.702 Y168.584 E.14815
G1 X172.702 Y151.416 E.55205
G1 X177.309 Y151.416 E.14815
G1 X177.309 Y168.524 E.55012
; COOLING_NODE: 0
M204 S10000
G1 X177.716 Y168.991 F60000
G1 F1214
M204 S8000
G1 X172.295 Y168.991 E.17433
G1 X172.295 Y151.009 E.57823
G1 X177.716 Y151.009 E.17433
G1 X177.716 Y168.931 E.5763
; COOLING_NODE: 0
M204 S10000
G1 X178.123 Y169.398 F60000
G1 F1214
M204 S8000
G1 X171.888 Y169.398 E.20051
G1 X171.888 Y150.602 E.60441
G1 X178.123 Y150.602 E.20051
G1 X178.123 Y169.338 E.60248
; COOLING_NODE: 0
M204 S250
G1 X178.515 Y169.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1214
M204 S5000
G1 X171.495 Y169.79 E.20909
G1 X171.495 Y150.21 E.58322
G1 X178.515 Y150.21 E.20909
G1 X178.515 Y169.73 E.58143
;======== H2D 20260731========
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
G1 X176.515 Y169.747 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X173.05 Y167.92 Z2.2 F60000
G1 Z1.8
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F1214
M204 S8000
G1 X173.05 Y166.291 E.05236
G1 X173.69 Y167.159 E.03467
G1 X174.017 Y167.405 E.01318
G2 X175.655 Y166.833 I.198 J-2.062 E.05756
G1 X176.31 Y165.945 E.0355
G3 X176.961 Y165.659 I.572 J.419 E.02392
G1 X176.961 Y163.656 E.0644
G1 X176.31 Y164.538 E.03523
G1 X175.983 Y164.785 E.01318
G3 X174.345 Y164.213 I-.198 J-2.062 E.05756
G1 X173.69 Y163.324 E.0355
G2 X173.05 Y163.04 I-.565 J.41 E.02358
G1 X173.05 Y161.05 E.06399
G1 X173.69 Y161.918 E.03467
G1 X174.017 Y162.164 E.01318
G2 X175.655 Y161.592 I.198 J-2.062 E.05756
G1 X176.31 Y160.703 E.0355
G3 X176.961 Y160.418 I.572 J.419 E.02392
G1 X176.961 Y158.415 E.0644
G1 X176.31 Y159.297 E.03523
G1 X175.983 Y159.543 E.01318
G3 X174.345 Y158.971 I-.198 J-2.062 E.05756
G1 X173.69 Y158.083 E.0355
G2 X173.05 Y157.798 I-.565 J.41 E.02358
G1 X173.05 Y155.809 E.06399
G1 X173.69 Y156.676 E.03467
G1 X174.017 Y156.923 E.01318
G2 X175.655 Y156.351 I.198 J-2.062 E.05756
G1 X176.31 Y155.462 E.0355
G3 X176.961 Y155.177 I.572 J.419 E.02392
G1 X176.961 Y153.174 E.0644
G1 X176.31 Y154.056 E.03523
G1 X175.983 Y154.302 E.01318
G3 X174.345 Y153.73 I-.198 J-2.062 E.05756
G1 X173.69 Y152.841 E.0355
G2 X173.05 Y152.557 I-.565 J.41 E.02358
G1 X173.05 Y151.764 E.02549
G1 X173.886 Y151.764 E.02687
; CHANGE_LAYER
; Z_HEIGHT: 2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F8843.478
G1 X173.05 Y151.764 E-.31755
G1 X173.05 Y152.557 E-.30121
G1 X173.362 Y152.595 E-.1195
G1 X173.408 Y152.629 E-.02174
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 10/100
; update layer progress
M73 L10
M991 S0 P9 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z2.2 I-1.182 J.289 P1  F60000
G1 X177.309 Y168.584 Z2.2
G1 Z2
G1 E.8 F1800
; FEATURE: Inner wall
G1 F1296
M204 S8000
G1 X172.703 Y168.584 E.14811
G1 X172.703 Y151.416 E.55205
G1 X177.309 Y151.416 E.14811
G1 X177.309 Y168.524 E.55012
; COOLING_NODE: 0
M204 S10000
G1 X177.716 Y168.991 F60000
M73 P29 R18
G1 F1296
M204 S8000
G1 X172.296 Y168.991 E.17429
G1 X172.296 Y151.009 E.57823
G1 X177.716 Y151.009 E.17429
G1 X177.716 Y168.931 E.5763
; COOLING_NODE: 0
M204 S10000
G1 X178.123 Y169.398 F60000
G1 F1296
M204 S8000
G1 X171.889 Y169.398 E.20047
G1 X171.889 Y150.602 E.60441
G1 X178.123 Y150.602 E.20047
G1 X178.123 Y169.338 E.60248
; COOLING_NODE: 0
M204 S250
G1 X178.515 Y169.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1220
M204 S5000
G1 X171.497 Y169.79 E.20905
G1 X171.497 Y150.21 E.58322
G1 X178.515 Y150.21 E.20905
G1 X178.515 Y169.73 E.58143
;======== H2D 20260731========
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
G1 X176.515 Y169.747 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X176.961 Y167.202 Z2.4 F60000
G1 Z2
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F1296
M204 S8000
G1 X176.961 Y165.574 E.05236
G3 X176.508 Y164.914 I.648 J-.931 E.02631
G3 X176.961 Y163.745 I3.779 J.793 E.04048
G1 X176.961 Y160.333 E.10974
G3 X176.508 Y159.673 I.648 J-.931 E.02631
G3 X176.961 Y158.504 I3.779 J.793 E.04048
G1 X176.961 Y155.091 E.10974
G3 X176.508 Y154.431 I.648 J-.931 E.02631
G3 X176.961 Y153.263 I3.779 J.793 E.04048
G1 X176.961 Y151.764 E.04818
G1 X176.83 Y151.764 E.00418
; WIPE_START
G1 F8843.478
G1 X176.961 Y151.764 E-.04942
G1 X176.961 Y153.263 E-.56934
G1 X176.806 Y153.601 E-.14124
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X173.051 Y153.931 Z2.4 F60000
G1 Z2
G1 E.8 F1800
G1 F1296
M204 S8000
G1 X173.051 Y152.303 E.05236
G2 X173.483 Y151.764 I-.202 J-.605 E.02346
G1 X174.713 Y151.764 E.03954
G1 X174.025 Y152.138 E.02518
G2 X173.954 Y152.793 I.443 J.379 E.02252
G2 X174.769 Y154.104 I2.424 J-.599 E.05045
G1 X175.976 Y154.759 E.04415
G3 X176.046 Y155.414 I-.443 J.379 E.02252
G3 X175.231 Y156.724 I-2.424 J-.599 E.05045
G1 X174.025 Y157.379 E.04415
G2 X173.954 Y158.035 I.443 J.379 E.02252
G2 X174.769 Y159.345 I2.424 J-.599 E.05045
G1 X175.976 Y160 E.04415
G3 X176.046 Y160.655 I-.444 J.379 E.02252
G3 X175.231 Y161.966 I-2.424 J-.599 E.05045
G1 X174.025 Y162.621 E.04415
G2 X173.954 Y163.276 I.443 J.379 E.02252
G2 X174.769 Y164.586 I2.424 J-.599 E.05045
G1 X175.976 Y165.241 E.04415
G3 X176.046 Y165.897 I-.443 J.379 E.02252
G3 X175.231 Y167.207 I-2.424 J-.599 E.05045
G1 X174.025 Y167.862 E.04415
G1 X173.896 Y168.236 E.0127
G1 X173.051 Y168.236 E.02717
G1 X173.051 Y168.027 E.00671
G2 X173.426 Y167.207 I-.177 J-.576 E.03274
G1 X173.161 Y166.552 E.02272
G1 X173.051 Y166.421 E.00547
G1 X173.051 Y162.786 E.11691
G2 X173.426 Y161.966 I-.177 J-.576 E.03274
G1 X173.161 Y161.31 E.02272
G1 X173.051 Y161.18 E.00547
G1 X173.051 Y157.544 E.11691
G2 X173.426 Y156.724 I-.177 J-.576 E.03274
G1 X173.161 Y156.069 E.02272
G1 X173.051 Y155.939 E.00547
G1 X173.051 Y154.311 E.05236
; CHANGE_LAYER
; Z_HEIGHT: 2.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F8843.478
G1 X173.051 Y155.939 E-.61876
G1 X173.161 Y156.069 E-.06466
G1 X173.236 Y156.256 E-.07658
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 11/100
; update layer progress
M73 L11
M991 S0 P10 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z2.4 I-1.156 J.382 P1  F60000
G1 X177.309 Y168.584 Z2.4
G1 Z2.2
G1 E.8 F1800
; FEATURE: Inner wall
G1 F1258
M204 S8000
G1 X172.704 Y168.584 E.14807
G1 X172.704 Y151.416 E.55205
G1 X177.309 Y151.416 E.14807
G1 X177.309 Y168.524 E.55012
; COOLING_NODE: 0
M204 S10000
G1 X177.716 Y168.991 F60000
G1 F1258
M204 S8000
G1 X172.297 Y168.991 E.17425
G1 X172.297 Y151.009 E.57823
G1 X177.716 Y151.009 E.17425
G1 X177.716 Y168.931 E.5763
; COOLING_NODE: 0
M204 S10000
G1 X178.123 Y169.398 F60000
G1 F1258
M204 S8000
G1 X171.89 Y169.398 E.20043
M73 P30 R18
G1 X171.89 Y150.602 E.60441
G1 X178.123 Y150.602 E.20043
G1 X178.123 Y169.338 E.60248
; COOLING_NODE: 0
M204 S250
G1 X178.515 Y169.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1212
M204 S5000
G1 X171.498 Y169.79 E.20902
G1 X171.498 Y150.21 E.58322
G1 X178.515 Y150.21 E.20902
G1 X178.515 Y169.73 E.58143
;======== H2D 20260731========
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
G1 X176.515 Y169.747 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X176.961 Y166.654 Z2.6 F60000
G1 Z2.2
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F1258
M204 S8000
G1 X176.961 Y165.025 E.05236
G3 X176.797 Y164.586 I.373 J-.389 E.01559
G1 X176.961 Y163.839 E.02461
G1 X176.961 Y159.784 E.13038
G3 X176.797 Y159.345 I.373 J-.389 E.01559
G1 X176.961 Y158.597 E.02461
G1 X176.961 Y154.543 E.13038
G3 X176.797 Y154.104 I.373 J-.389 E.01559
G1 X176.961 Y153.356 E.02461
G1 X176.961 Y151.764 E.05118
G1 X174.967 Y151.764 E.0641
G2 X174.176 Y152.793 I.721 J1.373 E.04306
G2 X174.691 Y154.104 I1.909 J.006 E.04636
G3 X175.749 Y155.086 I-1.787 J2.987 E.04679
G1 X175.824 Y155.414 E.0108
G3 X175.309 Y156.724 I-1.909 J.006 E.04636
G2 X174.251 Y157.707 I1.787 J2.987 E.04679
G1 X174.176 Y158.035 E.0108
G2 X174.691 Y159.345 I1.909 J.006 E.04636
G3 X175.749 Y160.328 I-1.787 J2.987 E.04679
G1 X175.824 Y160.655 E.0108
G3 X175.309 Y161.966 I-1.909 J.006 E.04636
M73 P30 R17
G2 X174.251 Y162.948 I1.788 J2.987 E.04679
G1 X174.176 Y163.276 E.0108
G2 X174.691 Y164.586 I1.909 J.006 E.04636
G3 X175.749 Y165.569 I-1.787 J2.987 E.04679
G1 X175.824 Y165.897 E.0108
G3 X175.309 Y167.207 I-1.909 J.006 E.04636
G2 X174.251 Y168.19 I1.787 J2.987 E.04679
G1 X174.24 Y168.236 E.00151
G1 X173.052 Y168.236 E.0382
G1 X173.052 Y167.63 E.01947
G2 X173.203 Y167.207 I-.363 J-.368 E.01494
G1 X173.052 Y166.491 E.02354
G1 X173.052 Y162.389 E.1319
G2 X173.203 Y161.966 I-.363 J-.368 E.01494
G1 X173.052 Y161.249 E.02354
G1 X173.052 Y157.147 E.1319
G2 X173.203 Y156.724 I-.363 J-.368 E.01494
G1 X173.052 Y156.008 E.02354
G1 X173.052 Y154.38 E.05236
; CHANGE_LAYER
; Z_HEIGHT: 2.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F8843.478
G1 X173.052 Y156.008 E-.61876
G1 X173.129 Y156.372 E-.14124
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 12/100
; update layer progress
M73 L12
M991 S0 P11 ;notify layer change

M106 S229.5
; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z2.6 I-1.151 J.394 P1  F60000
G1 X177.309 Y168.584 Z2.6
G1 Z2.4
G1 E.8 F1800
; FEATURE: Inner wall
G1 F1200
M204 S8000
G1 X172.705 Y168.584 E.14803
G1 X172.705 Y151.416 E.55205
G1 X177.309 Y151.416 E.14803
G1 X177.309 Y168.524 E.55012
; COOLING_NODE: 0
M204 S10000
G1 X177.716 Y168.991 F60000
G1 F1200
M204 S8000
G1 X172.298 Y168.991 E.17421
G1 X172.298 Y151.009 E.57823
G1 X177.716 Y151.009 E.17421
G1 X177.716 Y168.931 E.5763
; COOLING_NODE: 0
M204 S10000
G1 X178.123 Y169.398 F60000
G1 F1200
M204 S8000
G1 X171.891 Y169.398 E.20039
G1 X171.891 Y150.602 E.60441
G1 X178.123 Y150.602 E.20039
G1 X178.123 Y169.338 E.60248
; COOLING_NODE: 0
M204 S250
G1 X178.515 Y169.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X171.499 Y169.79 E.20898
G1 X171.499 Y150.21 E.58322
G1 X178.515 Y150.21 E.20898
G1 X178.515 Y169.73 E.58143
;======== H2D 20260731========
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
M73 P31 R17
G1 F9547.055
M204 S8000
G1 X176.515 Y169.747 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X176.961 Y166.047 Z2.8 F60000
G1 Z2.4
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G2 X176.951 Y163.931 I-52.917 J-.814 E.06805
G1 X176.961 Y159.177 E.15286
G2 X176.951 Y153.448 I-143.266 J-2.621 E.18423
G1 X176.961 Y151.764 E.05415
G1 X175.129 Y151.764 E.0589
G2 X174.489 Y152.466 I6.328 J6.412 E.03053
G2 X174.602 Y154.104 I1.582 J.714 E.05499
G3 X175.511 Y155.086 I-8.866 J9.11 E.04306
G3 X175.398 Y156.724 I-1.582 J.714 E.05499
G2 X174.489 Y157.707 I8.861 J9.106 E.04306
G2 X174.602 Y159.345 I1.582 J.714 E.05499
G3 X175.511 Y160.328 I-8.863 J9.107 E.04306
G3 X175.398 Y161.966 I-1.582 J.714 E.05499
G2 X174.489 Y162.948 I8.863 J9.107 E.04306
G2 X174.602 Y164.586 I1.582 J.714 E.05499
G3 X175.511 Y165.569 I-8.866 J9.11 E.04306
G3 X175.398 Y167.207 I-1.582 J.714 E.05499
G2 X174.469 Y168.236 I4.818 J5.286 E.04464
G1 X173.054 Y168.236 E.04551
G1 X173.054 Y168.022 E.00685
; CHANGE_LAYER
; Z_HEIGHT: 2.6
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F8843.478
G1 X173.054 Y168.236 E-.08097
G1 X174.469 Y168.236 E-.53779
G1 X174.718 Y167.96 E-.14124
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 13/100
; update layer progress
M73 L13
M991 S0 P12 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z2.8 I-.285 J1.183 P1  F60000
G1 X177.309 Y168.584 Z2.8
G1 Z2.6
G1 E.8 F1800
; FEATURE: Inner wall
G1 F1200
M204 S8000
G1 X172.707 Y168.584 E.14799
G1 X172.707 Y151.416 E.55205
G1 X177.309 Y151.416 E.14799
G1 X177.309 Y168.524 E.55012
; COOLING_NODE: 0
M204 S10000
G1 X177.716 Y168.991 F60000
G1 F1200
M204 S8000
G1 X172.3 Y168.991 E.17417
G1 X172.3 Y151.009 E.57823
G1 X177.716 Y151.009 E.17417
G1 X177.716 Y168.931 E.5763
; COOLING_NODE: 0
M204 S10000
G1 X178.123 Y169.398 F60000
G1 F1200
M204 S8000
G1 X171.892 Y169.398 E.20035
G1 X171.892 Y150.602 E.60441
G1 X178.123 Y150.602 E.20035
G1 X178.123 Y169.338 E.60248
; COOLING_NODE: 0
M204 S250
G1 X178.515 Y169.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X171.5 Y169.79 E.20894
G1 X171.5 Y150.21 E.58322
G1 X178.515 Y150.21 E.20894
G1 X178.515 Y169.73 E.58143
;======== H2D 20260731========
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
G1 X176.515 Y169.747 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X173.063 Y168.236 Z3 F60000
G1 Z2.6
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X174.692 Y168.236 E.05236
G1 X174.979 Y167.862 E.01516
G2 X175.526 Y165.897 I-1.159 J-1.381 E.06972
G1 X175.021 Y165.241 E.0266
G3 X174.475 Y163.276 I1.159 J-1.381 E.06972
G1 X174.979 Y162.621 E.0266
G2 X175.526 Y160.655 I-1.159 J-1.381 E.06972
G1 X175.021 Y160 E.0266
G3 X174.475 Y158.035 I1.159 J-1.381 E.06972
G1 X174.979 Y157.379 E.0266
G2 X175.526 Y155.414 I-1.159 J-1.381 E.06972
G1 X175.021 Y154.759 E.0266
G3 X174.475 Y152.793 I1.159 J-1.381 E.06972
G3 X175.277 Y151.764 I31.568 J23.801 E.04196
M73 P32 R17
G1 X176.906 Y151.764 E.05236
; CHANGE_LAYER
; Z_HEIGHT: 2.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F8843.478
G1 X175.277 Y151.764 E-.61876
G1 X175.049 Y152.058 E-.14125
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 14/100
; update layer progress
M73 L14
M991 S0 P13 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z3 I-1.206 J.165 P1  F60000
G1 X177.309 Y168.584 Z3
G1 Z2.8
G1 E.8 F1800
; FEATURE: Inner wall
G1 F1200
M204 S8000
G1 X172.708 Y168.584 E.14795
G1 X172.708 Y151.416 E.55205
G1 X177.309 Y151.416 E.14795
G1 X177.309 Y168.524 E.55012
; COOLING_NODE: 0
M204 S10000
G1 X177.716 Y168.991 F60000
G1 F1200
M204 S8000
G1 X172.301 Y168.991 E.17413
G1 X172.301 Y151.009 E.57823
G1 X177.716 Y151.009 E.17413
G1 X177.716 Y168.931 E.5763
; COOLING_NODE: 0
M204 S10000
G1 X178.123 Y169.398 F60000
G1 F1200
M204 S8000
G1 X171.894 Y169.398 E.20031
G1 X171.894 Y150.602 E.60441
G1 X178.123 Y150.602 E.20031
G1 X178.123 Y169.338 E.60248
; COOLING_NODE: 0
M204 S250
G1 X178.515 Y169.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X171.502 Y169.79 E.2089
G1 X171.502 Y150.21 E.58322
G1 X178.515 Y150.21 E.2089
G1 X178.515 Y169.73 E.58143
;======== H2D 20260731========
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
G1 X176.515 Y169.747 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X176.469 Y168.236 Z3.2 F60000
G1 Z2.8
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X174.841 Y168.236 E.05236
G2 X175.469 Y167.535 I-13.118 J-12.391 E.03028
G2 X175.418 Y165.897 I-1.554 J-.771 E.05488
G3 X174.531 Y164.914 I18.39 J-17.491 E.04258
G3 X174.582 Y163.276 I1.554 J-.771 E.05488
G2 X175.469 Y162.293 I-18.373 J-17.476 E.04258
G2 X175.418 Y160.655 I-1.554 J-.771 E.05488
G3 X174.531 Y159.673 I18.396 J-17.496 E.04258
G3 X174.582 Y158.035 I1.554 J-.771 E.05488
G2 X175.469 Y157.052 I-18.384 J-17.486 E.04258
G2 X175.418 Y155.414 I-1.554 J-.771 E.05488
G3 X174.531 Y154.431 I18.39 J-17.491 E.04258
G3 X174.582 Y152.793 I1.554 J-.771 E.05488
G2 X175.491 Y151.764 I-6.72 J-6.856 E.04419
G1 X173.863 Y151.764 E.05236
; CHANGE_LAYER
; Z_HEIGHT: 3
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F8843.478
G1 X175.491 Y151.764 E-.61876
G1 X175.245 Y152.043 E-.14124
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 15/100
; update layer progress
M73 L15
M991 S0 P14 ;notify layer change

M106 S226.95
; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z3.2 I-1.208 J.151 P1  F60000
G1 X177.309 Y168.584 Z3.2
G1 Z3
G1 E.8 F1800
; FEATURE: Inner wall
G1 F1255
M204 S8000
G1 X172.709 Y168.584 E.14791
G1 X172.709 Y151.416 E.55205
G1 X177.309 Y151.416 E.14791
G1 X177.309 Y168.524 E.55012
; COOLING_NODE: 0
M204 S10000
G1 X177.716 Y168.991 F60000
G1 F1255
M204 S8000
G1 X172.302 Y168.991 E.17409
G1 X172.302 Y151.009 E.57823
G1 X177.716 Y151.009 E.17409
G1 X177.716 Y168.931 E.5763
; COOLING_NODE: 0
M204 S10000
G1 X178.123 Y169.398 F60000
G1 F1255
M204 S8000
G1 X171.895 Y169.398 E.20027
M73 P33 R17
G1 X171.895 Y150.602 E.60441
G1 X178.123 Y150.602 E.20027
G1 X178.123 Y169.338 E.60248
; COOLING_NODE: 0
M204 S250
G1 X178.515 Y169.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1215
M204 S5000
G1 X171.503 Y169.79 E.20887
G1 X171.503 Y150.21 E.58322
G1 X178.515 Y150.21 E.20887
G1 X178.515 Y169.73 E.58143
;======== H2D 20260731========
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
G1 X176.515 Y169.747 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X176.961 Y165.635 Z3.4 F60000
G1 Z3
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F1255
M204 S8000
G1 X176.961 Y164.006 E.05236
G1 X176.835 Y163.276 E.02383
G3 X176.961 Y162.908 I.487 J-.04 E.01287
G1 X176.961 Y158.765 E.13321
G1 X176.835 Y158.035 E.02383
G3 X176.961 Y157.666 I.487 J-.04 E.01287
G1 X176.961 Y153.524 E.13321
G1 X176.835 Y152.793 E.02383
G2 X176.961 Y151.764 I-1.733 J-.734 E.03377
G1 X175.706 Y151.764 E.04033
G3 X174.673 Y152.793 I-2.87 J-1.849 E.04725
G2 X174.307 Y154.431 I1.407 J1.175 E.05606
G2 X175.327 Y155.414 I3.367 J-2.474 E.04577
G3 X175.694 Y157.052 I-1.407 J1.175 E.05606
G3 X174.673 Y158.035 I-3.367 J-2.475 E.04577
G2 X174.307 Y159.673 I1.407 J1.175 E.05606
G2 X175.327 Y160.655 I3.367 J-2.474 E.04577
G3 X175.694 Y162.293 I-1.407 J1.175 E.05606
G3 X174.673 Y163.276 I-3.367 J-2.474 E.04577
G2 X174.307 Y164.914 I1.407 J1.175 E.05606
G2 X175.327 Y165.897 I3.367 J-2.474 E.04577
G3 X175.694 Y167.535 I-1.407 J1.175 E.05606
G3 X174.997 Y168.236 I-2.387 J-1.674 E.03193
G1 X173.057 Y168.236 E.06237
G1 X173.057 Y166.59 E.05291
G1 X173.165 Y165.897 E.02257
G2 X173.057 Y165.55 I-.453 J-.049 E.012
G1 X173.057 Y161.349 E.1351
G1 X173.165 Y160.655 E.02257
G2 X173.057 Y160.309 I-.453 J-.049 E.012
G1 X173.057 Y156.108 E.1351
G1 X173.165 Y155.414 E.02257
G2 X173.057 Y155.067 I-.453 J-.049 E.012
G1 X173.057 Y153.439 E.05236
; CHANGE_LAYER
; Z_HEIGHT: 3.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F8843.478
G1 X173.057 Y155.067 E-.61876
G1 X173.165 Y155.414 E-.13793
G1 X173.164 Y155.423 E-.00331
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 16/100
; update layer progress
M73 L16
M991 S0 P15 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z3.4 I-1.161 J.366 P1  F60000
G1 X177.309 Y168.584 Z3.4
G1 Z3.2
G1 E.8 F1800
; FEATURE: Inner wall
G1 F1289
M204 S8000
G1 X172.71 Y168.584 E.14787
G1 X172.71 Y151.416 E.55205
G1 X177.309 Y151.416 E.14787
G1 X177.309 Y168.524 E.55012
; COOLING_NODE: 0
M204 S10000
G1 X177.716 Y168.991 F60000
G1 F1289
M204 S8000
G1 X172.303 Y168.991 E.17405
G1 X172.303 Y151.009 E.57823
G1 X177.716 Y151.009 E.17405
G1 X177.716 Y168.931 E.5763
; COOLING_NODE: 0
M204 S10000
G1 X178.123 Y169.398 F60000
G1 F1289
M204 S8000
G1 X171.896 Y169.398 E.20023
G1 X171.896 Y150.602 E.60441
G1 X178.123 Y150.602 E.20023
G1 X178.123 Y169.338 E.60248
; COOLING_NODE: 0
M204 S250
G1 X178.515 Y169.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1213
M204 S5000
G1 X171.504 Y169.79 E.20883
G1 X171.504 Y150.21 E.58322
G1 X178.515 Y150.21 E.20883
G1 X178.515 Y169.73 E.58143
;======== H2D 20260731========
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
M73 P34 R17
G1 F9547.055
M204 S8000
G1 X176.515 Y169.747 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X173.11 Y168.236 Z3.6 F60000
G1 Z3.2
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F1289
M204 S8000
G1 X173.059 Y168.236 E.00166
G1 X173.059 Y166.659 E.0507
G1 X173.143 Y166.552 E.00439
G2 X173.399 Y165.569 I-1.699 J-.966 E.03303
G2 X173.059 Y165.154 I-.572 J.122 E.01792
G1 X173.059 Y161.418 E.12016
G1 X173.143 Y161.31 E.00439
G2 X173.399 Y160.328 I-1.699 J-.966 E.03303
G2 X173.059 Y159.913 I-.572 J.122 E.01792
G1 X173.059 Y156.176 E.12016
G1 X173.143 Y156.069 E.00439
G2 X173.399 Y155.086 I-1.699 J-.966 E.03303
G2 X173.059 Y154.672 I-.572 J.122 E.01792
G1 X173.059 Y153.043 E.05236
; WIPE_START
G1 F8843.478
G1 X173.059 Y154.672 E-.61876
G1 X173.201 Y154.759 E-.06332
G1 X173.307 Y154.934 E-.07793
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X176.961 Y155.243 Z3.6 F60000
G1 Z3.2
G1 E.8 F1800
G1 F1289
M204 S8000
G1 X176.961 Y153.614 E.05236
G3 X176.601 Y152.466 I2.557 J-1.43 E.03897
G2 X176.961 Y151.764 I-1.115 J-1.014 E.02563
G1 X176.016 Y151.764 E.03038
G1 X175.821 Y152.138 E.01355
G1 X174.753 Y152.793 E.04028
G2 X174.006 Y154.104 I1.541 J1.748 E.04941
G2 X174.179 Y154.759 I.546 J.206 E.02325
G1 X175.247 Y155.414 E.04028
G3 X175.995 Y156.724 I-1.541 J1.748 E.04941
G3 X175.821 Y157.379 I-.546 J.206 E.02325
G1 X174.753 Y158.035 E.04028
G2 X174.006 Y159.345 I1.541 J1.748 E.04941
G2 X174.179 Y160 I.546 J.206 E.02325
G1 X175.247 Y160.655 E.04028
G3 X175.995 Y161.966 I-1.54 J1.748 E.04941
G3 X175.821 Y162.621 I-.546 J.206 E.02325
G1 X174.753 Y163.276 E.04028
G2 X174.006 Y164.586 I1.541 J1.748 E.04941
G2 X174.179 Y165.241 I.546 J.206 E.02325
G1 X175.247 Y165.897 E.04028
G3 X175.995 Y167.207 I-1.54 J1.748 E.04941
G3 X175.821 Y167.862 I-.546 J.206 E.02325
G1 X175.213 Y168.236 E.02296
G1 X176.605 Y168.236 E.04477
G3 X176.961 Y167.636 I2.027 J.798 E.02251
G1 X176.961 Y164.097 E.11381
G3 X176.601 Y162.948 I2.557 J-1.43 E.03897
G3 X176.961 Y162.395 I3.859 J2.111 E.02124
G1 X176.961 Y158.856 E.11381
M73 P34 R16
G3 X176.601 Y157.707 I2.557 J-1.43 E.03898
G3 X176.961 Y157.154 I3.859 J2.111 E.02124
G1 X176.961 Y155.525 E.05236
; CHANGE_LAYER
; Z_HEIGHT: 3.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F8843.478
G1 X176.961 Y157.154 E-.61876
G1 X176.758 Y157.465 E-.14124
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 17/100
; update layer progress
M73 L17
M991 S0 P16 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z3.6 I-1.215 J.06 P1  F60000
G1 X177.309 Y168.584 Z3.6
G1 Z3.4
G1 E.8 F1800
; FEATURE: Inner wall
G1 F1215
M204 S8000
G1 X172.712 Y168.584 E.14783
G1 X172.712 Y151.416 E.55205
G1 X177.309 Y151.416 E.14783
G1 X177.309 Y168.524 E.55012
; COOLING_NODE: 0
M204 S10000
G1 X177.716 Y168.991 F60000
G1 F1215
M204 S8000
G1 X172.304 Y168.991 E.17401
G1 X172.304 Y151.009 E.57823
G1 X177.716 Y151.009 E.17401
G1 X177.716 Y168.931 E.5763
; COOLING_NODE: 0
M204 S10000
G1 X178.123 Y169.398 F60000
G1 F1215
M204 S8000
G1 X171.897 Y169.398 E.20019
G1 X171.897 Y150.602 E.60441
G1 X178.123 Y150.602 E.20019
G1 X178.123 Y169.338 E.60248
; COOLING_NODE: 0
M204 S250
G1 X178.515 Y169.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1211
M204 S5000
G1 X171.505 Y169.79 E.2088
G1 X171.505 Y150.21 E.58322
G1 X178.515 Y150.21 E.2088
G1 X178.515 Y169.73 E.58143
;======== H2D 20260731========
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
G1 X176.515 Y169.747 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X176.078 Y168.236 Z3.8 F60000
G1 Z3.4
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F1215
M204 S8000
G1 X176.961 Y168.236 E.02838
G1 X176.961 Y167.49 E.02398
G3 X176.31 Y167.246 I-.136 J-.626 E.0236
G1 X175.655 Y166.287 E.03735
G2 X174.345 Y165.614 I-1.588 J1.479 E.04833
G2 X173.69 Y165.858 I-.138 J.63 E.02376
G1 X173.06 Y166.78 E.03591
M73 P35 R16
G1 X173.06 Y164.868 E.06148
G2 X173.69 Y164.625 I.127 J-.609 E.02295
G1 X174.345 Y163.666 E.03735
G3 X175.655 Y162.993 I1.588 J1.479 E.04833
G3 X176.31 Y163.237 I.138 J.63 E.02376
G1 X176.961 Y164.189 E.03706
G1 X176.961 Y162.248 E.0624
G3 X176.31 Y162.004 I-.136 J-.626 E.0236
G1 X175.655 Y161.045 E.03735
G2 X174.345 Y160.372 I-1.588 J1.479 E.04833
G2 X173.69 Y160.617 I-.138 J.63 E.02376
G1 X173.06 Y161.539 E.03591
G1 X173.06 Y159.627 E.06148
G2 X173.69 Y159.384 I.127 J-.609 E.02295
G1 X174.345 Y158.425 E.03735
G3 X175.655 Y157.752 I1.588 J1.479 E.04833
G3 X176.31 Y157.996 I.138 J.63 E.02376
G1 X176.961 Y158.948 E.03706
G1 X176.961 Y157.007 E.0624
G3 X176.31 Y156.763 I-.136 J-.626 E.0236
G1 X175.655 Y155.804 E.03735
G2 X174.345 Y155.131 I-1.588 J1.479 E.04833
G2 X173.69 Y155.375 I-.138 J.63 E.02377
G1 X173.06 Y156.297 E.03591
G1 X173.06 Y154.386 E.06148
G2 X173.69 Y154.142 I.127 J-.609 E.02295
G1 X174.345 Y153.183 E.03735
G3 X175.655 Y152.51 I1.588 J1.479 E.04833
G3 X176.31 Y152.755 I.138 J.63 E.02376
G1 X176.961 Y153.706 E.03706
G1 X176.961 Y152.078 E.05236
; CHANGE_LAYER
; Z_HEIGHT: 3.6
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F8843.478
G1 X176.961 Y153.706 E-.61876
G1 X176.751 Y153.399 E-.14124
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 18/100
; update layer progress
M73 L18
M991 S0 P17 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z3.8 I-1.216 J.045 P1  F60000
G1 X177.309 Y168.584 Z3.8
G1 Z3.6
G1 E.8 F1800
; FEATURE: Inner wall
G1 F1210
M204 S8000
G1 X172.713 Y168.584 E.14779
G1 X172.713 Y151.416 E.55205
G1 X177.309 Y151.416 E.14779
G1 X177.309 Y168.524 E.55012
; COOLING_NODE: 0
M204 S10000
G1 X177.716 Y168.991 F60000
G1 F1210
M204 S8000
G1 X172.306 Y168.991 E.17397
G1 X172.306 Y151.009 E.57823
G1 X177.716 Y151.009 E.17397
G1 X177.716 Y168.931 E.5763
; COOLING_NODE: 0
M204 S10000
G1 X178.123 Y169.398 F60000
G1 F1210
M204 S8000
G1 X171.899 Y169.398 E.20015
G1 X171.899 Y150.602 E.60441
G1 X178.123 Y150.602 E.20015
G1 X178.123 Y169.338 E.60248
; COOLING_NODE: 0
M204 S250
G1 X178.515 Y169.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1210
M204 S5000
G1 X171.507 Y169.79 E.20876
G1 X171.507 Y150.21 E.58322
G1 X178.515 Y150.21 E.20876
G1 X178.515 Y169.73 E.58143
;======== H2D 20260731========
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
G1 X176.515 Y169.747 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X176.274 Y168.236 Z4 F60000
G1 Z3.6
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F1210
M204 S8000
G1 X176.961 Y168.236 E.02207
G1 X176.961 Y167.294 E.03029
G1 X176.638 Y167.185 E.01095
G3 X175.655 Y166.204 I3.243 J-4.232 E.04477
G2 X174.345 Y165.808 I-1.128 J1.366 E.04519
G1 X174.017 Y165.919 E.01112
G2 X173.061 Y166.871 I3.147 J4.117 E.04352
G1 X173.061 Y164.666 E.0709
G1 X173.362 Y164.564 E.01022
G2 X174.345 Y163.583 I-3.243 J-4.232 E.04477
G3 X175.655 Y163.187 I1.128 J1.366 E.04519
G1 X175.983 Y163.298 E.01112
G3 X176.961 Y164.273 I-3.225 J4.21 E.04453
G1 X176.961 Y162.052 E.07142
G1 X176.638 Y161.944 E.01095
G3 X175.655 Y160.963 I3.243 J-4.232 E.04477
G2 X174.345 Y160.567 I-1.128 J1.366 E.04519
G1 X174.017 Y160.677 E.01112
G2 X173.061 Y161.629 I3.147 J4.117 E.04352
G1 X173.061 Y159.424 E.0709
G1 X173.362 Y159.323 E.01022
G2 X174.345 Y158.342 I-3.243 J-4.233 E.04477
G3 X175.655 Y157.946 I1.128 J1.366 E.04519
G1 X175.983 Y158.057 E.01112
G3 X176.961 Y159.032 I-3.224 J4.21 E.04453
G1 X176.961 Y156.811 E.07142
G1 X176.638 Y156.702 E.01095
G3 X175.655 Y155.722 I3.243 J-4.232 E.04477
G2 X174.345 Y155.326 I-1.128 J1.366 E.04519
G1 X174.017 Y155.436 E.01112
G2 X173.061 Y156.388 I3.147 J4.117 E.04352
G1 X173.061 Y154.183 E.0709
G1 X173.362 Y154.082 E.01022
G2 X174.345 Y153.101 I-3.243 J-4.232 E.04477
G3 X175.655 Y152.705 I1.128 J1.366 E.04519
G1 X175.983 Y152.815 E.01112
G3 X176.961 Y153.791 I-3.224 J4.21 E.04453
G1 X176.961 Y152.162 E.05236
; CHANGE_LAYER
; Z_HEIGHT: 3.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F8843.478
G1 X176.961 Y153.791 E-.61876
G1 X176.697 Y153.528 E-.14124
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 19/100
; update layer progress
M73 L19
M991 S0 P18 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z4 I-1.216 J.049 P1  F60000
G1 X177.309 Y168.584 Z4
G1 Z3.8
G1 E.8 F1800
; FEATURE: Inner wall
G1 F1211
M204 S8000
G1 X172.714 Y168.584 E.14775
G1 X172.714 Y151.416 E.55205
G1 X177.309 Y151.416 E.14775
G1 X177.309 Y168.524 E.55012
; COOLING_NODE: 0
M204 S10000
G1 X177.716 Y168.991 F60000
M73 P36 R16
G1 F1211
M204 S8000
G1 X172.307 Y168.991 E.17393
G1 X172.307 Y151.009 E.57823
G1 X177.716 Y151.009 E.17393
G1 X177.716 Y168.931 E.5763
; COOLING_NODE: 0
M204 S10000
G1 X178.123 Y169.398 F60000
G1 F1211
M204 S8000
G1 X171.9 Y169.398 E.20011
G1 X171.9 Y150.602 E.60441
G1 X178.123 Y150.602 E.20011
G1 X178.123 Y169.338 E.60248
; COOLING_NODE: 0
M204 S250
G1 X178.515 Y169.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1211
M204 S5000
G1 X171.508 Y169.79 E.20872
G1 X171.508 Y150.21 E.58322
G1 X178.515 Y150.21 E.20872
G1 X178.515 Y169.73 E.58143
;======== H2D 20260731========
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
G1 X176.515 Y169.747 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X176.425 Y168.236 Z4.2 F60000
G1 Z3.8
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F1211
M204 S8000
G1 X176.961 Y168.236 E.01721
G1 X176.961 Y167.143 E.03515
G1 X176.31 Y166.684 E.02558
G2 X174.345 Y165.957 I-1.557 J1.189 E.0711
G2 X173.062 Y166.97 I4.1 J6.514 E.05264
G1 X173.062 Y164.506 E.07923
G1 X173.69 Y164.064 E.02468
G3 X175.655 Y163.337 I1.557 J1.189 E.0711
G3 X176.961 Y164.369 I-4.182 J6.631 E.05361
G1 X176.961 Y161.901 E.07935
G1 X176.31 Y161.443 E.02558
G2 X174.345 Y160.716 I-1.557 J1.189 E.0711
G2 X173.062 Y161.728 I4.101 J6.514 E.05264
G1 X173.062 Y159.265 E.07923
G1 X173.69 Y158.822 E.02468
G3 X175.655 Y158.095 I1.557 J1.189 E.0711
G3 X176.961 Y159.128 I-4.182 J6.63 E.05361
G1 X176.961 Y156.66 E.07935
G1 X176.31 Y156.202 E.02558
G2 X174.345 Y155.475 I-1.557 J1.189 E.0711
G2 X173.062 Y156.487 I4.1 J6.514 E.05264
G1 X173.062 Y154.023 E.07923
G1 X173.69 Y153.581 E.02468
G3 X175.655 Y152.854 I1.557 J1.189 E.0711
G3 X176.961 Y153.886 I-4.182 J6.631 E.05361
G1 X176.961 Y152.258 E.05236
; CHANGE_LAYER
; Z_HEIGHT: 4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F8843.478
G1 X176.961 Y153.886 E-.61876
G1 X176.681 Y153.641 E-.14124
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 20/100
; update layer progress
M73 L20
M991 S0 P19 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z4.2 I-1.216 J.051 P1  F60000
G1 X177.309 Y168.584 Z4.2
G1 Z4
G1 E.8 F1800
; FEATURE: Inner wall
G1 F1212
M204 S8000
G1 X172.715 Y168.584 E.14771
G1 X172.715 Y151.416 E.55205
G1 X177.309 Y151.416 E.14771
G1 X177.309 Y168.524 E.55012
; COOLING_NODE: 0
M204 S10000
G1 X177.716 Y168.991 F60000
G1 F1212
M204 S8000
G1 X172.308 Y168.991 E.17389
G1 X172.308 Y151.009 E.57823
G1 X177.716 Y151.009 E.17389
G1 X177.716 Y168.931 E.5763
; COOLING_NODE: 0
M204 S10000
G1 X178.123 Y169.398 F60000
G1 F1212
M204 S8000
G1 X171.901 Y169.398 E.20007
M73 P37 R16
G1 X171.901 Y150.602 E.60441
G1 X178.123 Y150.602 E.20007
G1 X178.123 Y169.338 E.60248
; COOLING_NODE: 0
M204 S250
G1 X178.515 Y169.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1212
M204 S5000
G1 X171.509 Y169.79 E.20869
G1 X171.509 Y150.21 E.58322
G1 X178.515 Y150.21 E.20869
G1 X178.515 Y169.73 E.58143
;======== H2D 20260731========
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
G1 X176.515 Y169.747 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X173.541 Y168.236 Z4.4 F60000
G1 Z4
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F1212
M204 S8000
G1 X173.063 Y168.236 E.01536
G1 X173.063 Y167.085 E.037
G1 X173.69 Y166.621 E.02506
G3 X175.655 Y165.997 I1.454 J1.172 E.07025
G3 X176.961 Y167.022 I-8.591 J12.28 E.0534
G1 X176.961 Y164.482 E.08169
G1 X176.31 Y164 E.02602
G2 X174.345 Y163.376 I-1.454 J1.172 E.07025
G2 X173.063 Y164.382 I8.423 J12.053 E.0524
G1 X173.063 Y161.844 E.08162
G1 X173.69 Y161.38 E.02506
G3 X175.655 Y160.756 I1.454 J1.172 E.07025
G3 X176.961 Y161.781 I-8.589 J12.278 E.0534
G1 X176.961 Y159.241 E.08169
G1 X176.31 Y158.759 E.02602
G2 X174.345 Y158.135 I-1.454 J1.172 E.07025
G2 X173.063 Y159.141 I8.423 J12.053 E.0524
G1 X173.063 Y156.602 E.08162
G1 X173.69 Y156.138 E.02506
G3 X175.655 Y155.514 I1.454 J1.172 E.07025
G3 X176.961 Y156.54 I-8.591 J12.28 E.0534
G1 X176.961 Y153.999 E.08169
G1 X176.31 Y153.518 E.02602
G2 X174.345 Y152.894 I-1.454 J1.172 E.07025
G2 X173.063 Y153.899 I8.423 J12.053 E.0524
G1 X173.063 Y152.271 E.05236
; CHANGE_LAYER
; Z_HEIGHT: 4.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F8843.478
G1 X173.063 Y153.899 E-.61876
G1 X173.356 Y153.67 E-.14124
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 21/100
; update layer progress
M73 L21
M991 S0 P20 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z4.4 I-1.176 J.312 P1  F60000
G1 X177.309 Y168.584 Z4.4
G1 Z4.2
G1 E.8 F1800
; FEATURE: Inner wall
G1 F1210
M204 S8000
G1 X172.716 Y168.584 E.14767
G1 X172.716 Y151.416 E.55205
G1 X177.309 Y151.416 E.14767
G1 X177.309 Y168.524 E.55012
; COOLING_NODE: 0
M204 S10000
G1 X177.716 Y168.991 F60000
G1 F1210
M204 S8000
G1 X172.309 Y168.991 E.17385
G1 X172.309 Y151.009 E.57823
G1 X177.716 Y151.009 E.17385
G1 X177.716 Y168.931 E.5763
; COOLING_NODE: 0
M204 S10000
G1 X178.123 Y169.398 F60000
G1 F1210
M204 S8000
G1 X171.902 Y169.398 E.20003
G1 X171.902 Y150.602 E.60441
G1 X178.123 Y150.602 E.20003
G1 X178.123 Y169.338 E.60248
; COOLING_NODE: 0
M204 S250
G1 X178.515 Y169.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1210
M204 S5000
G1 X171.51 Y169.79 E.20865
G1 X171.51 Y150.21 E.58322
G1 X178.515 Y150.21 E.20865
G1 X178.515 Y169.73 E.58143
;======== H2D 20260731========
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
M73 P38 R16
G1 X176.515 Y169.747 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X173.691 Y168.236 Z4.6 F60000
G1 Z4.2
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F1210
M204 S8000
G1 X173.065 Y168.236 E.02012
G1 X173.065 Y167.233 E.03224
G1 X173.362 Y167.114 E.0103
G2 X174.345 Y166.176 I-4.993 J-6.217 E.04373
G3 X175.655 Y165.858 I1.024 J1.361 E.04458
G1 X175.983 Y165.99 E.01135
G3 X176.961 Y166.922 I-4.964 J6.184 E.0435
G1 X176.961 Y164.622 E.07395
G1 X176.638 Y164.493 E.01117
G3 X175.655 Y163.556 I4.994 J-6.219 E.04373
G2 X174.345 Y163.238 I-1.024 J1.361 E.04458
G1 X174.017 Y163.369 E.01135
G2 X173.065 Y164.276 I4.831 J6.026 E.04235
M73 P38 R15
G1 X173.065 Y161.992 E.07346
G1 X173.362 Y161.873 E.0103
G2 X174.345 Y160.935 I-4.994 J-6.218 E.04373
G3 X175.655 Y160.617 I1.024 J1.361 E.04458
G1 X175.983 Y160.748 E.01135
G3 X176.961 Y161.681 I-4.965 J6.185 E.0435
G1 X176.961 Y159.381 E.07395
G1 X176.638 Y159.252 E.01117
G3 X175.655 Y158.314 I4.994 J-6.218 E.04373
G2 X174.345 Y157.996 I-1.024 J1.361 E.04458
G1 X174.017 Y158.128 E.01135
G2 X173.065 Y159.035 I4.831 J6.027 E.04235
G1 X173.065 Y156.75 E.07346
G1 X173.362 Y156.631 E.0103
G2 X174.345 Y155.694 I-4.993 J-6.217 E.04373
G3 X175.655 Y155.376 I1.024 J1.361 E.04458
G1 X175.983 Y155.507 E.01135
G3 X176.961 Y156.44 I-4.964 J6.183 E.0435
G1 X176.961 Y154.14 E.07395
G1 X176.638 Y154.011 E.01117
G3 X175.655 Y153.073 I4.994 J-6.219 E.04373
G2 X174.345 Y152.755 I-1.024 J1.361 E.04458
G1 X174.017 Y152.886 E.01135
G2 X173.065 Y153.794 I4.831 J6.026 E.04235
G1 X173.065 Y152.165 E.05236
; CHANGE_LAYER
; Z_HEIGHT: 4.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F8843.478
G1 X173.065 Y153.794 E-.61876
G1 X173.334 Y153.537 E-.14124
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 22/100
; update layer progress
M73 L22
M991 S0 P21 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z4.6 I-1.177 J.311 P1  F60000
G1 X177.309 Y168.584 Z4.6
G1 Z4.4
G1 E.8 F1800
; FEATURE: Inner wall
G1 F1213
M204 S8000
G1 X172.718 Y168.584 E.14763
G1 X172.718 Y151.416 E.55205
G1 X177.309 Y151.416 E.14763
G1 X177.309 Y168.524 E.55012
; COOLING_NODE: 0
M204 S10000
G1 X177.716 Y168.991 F60000
G1 F1213
M204 S8000
G1 X172.311 Y168.991 E.17381
G1 X172.311 Y151.009 E.57823
G1 X177.716 Y151.009 E.17381
G1 X177.716 Y168.931 E.5763
; COOLING_NODE: 0
M204 S10000
G1 X178.123 Y169.398 F60000
G1 F1213
M204 S8000
G1 X171.904 Y169.398 E.19999
G1 X171.904 Y150.602 E.60441
G1 X178.123 Y150.602 E.19999
G1 X178.123 Y169.338 E.60248
; COOLING_NODE: 0
M204 S250
G1 X178.515 Y169.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1213
M204 S5000
G1 X171.511 Y169.79 E.20861
G1 X171.511 Y150.21 E.58322
G1 X178.515 Y150.21 E.20861
G1 X178.515 Y169.73 E.58143
;======== H2D 20260731========
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
G1 X176.515 Y169.747 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X173.877 Y168.236 Z4.8 F60000
G1 Z4.4
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F1213
M204 S8000
G1 X173.066 Y168.236 E.02609
G1 X173.066 Y167.419 E.02627
G2 X173.69 Y167.12 I.04 J-.718 E.02319
G1 X174.345 Y166.262 E.03472
G3 X175.655 Y165.68 I1.417 J1.424 E.04715
G3 X176.31 Y165.983 I.051 J.75 E.02421
G1 X176.961 Y166.835 E.03446
G1 X176.961 Y164.802 E.06537
G3 X176.31 Y164.5 I-.049 J-.745 E.02405
G1 X175.655 Y163.641 E.03472
G2 X174.345 Y163.059 I-1.417 J1.424 E.04715
G2 X173.69 Y163.362 I-.051 J.75 E.02421
G1 X173.066 Y164.18 E.03306
G1 X173.066 Y162.177 E.06439
G2 X173.69 Y161.879 I.04 J-.718 E.02319
G1 X174.345 Y161.021 E.03472
G3 X175.655 Y160.439 I1.417 J1.424 E.04715
G3 X176.31 Y160.742 I.051 J.75 E.02421
G1 X176.961 Y161.594 E.03446
G1 X176.961 Y159.561 E.06537
G3 X176.31 Y159.258 I-.049 J-.745 E.02405
G1 X175.655 Y158.4 E.03472
G2 X174.345 Y157.818 I-1.417 J1.424 E.04715
M73 P39 R15
G2 X173.69 Y158.121 I-.051 J.749 E.02421
G1 X173.066 Y158.938 E.03306
G1 X173.066 Y156.936 E.06439
G2 X173.69 Y156.638 I.04 J-.718 E.02319
G1 X174.345 Y155.779 E.03472
G3 X175.655 Y155.197 I1.417 J1.424 E.04715
G3 X176.31 Y155.501 I.051 J.75 E.02421
G1 X176.961 Y156.352 E.03446
G1 X176.961 Y154.32 E.06537
G3 X176.31 Y154.017 I-.049 J-.745 E.02405
G1 X175.655 Y153.159 E.03472
G2 X174.345 Y152.577 I-1.417 J1.424 E.04715
G2 X173.69 Y152.88 I-.051 J.75 E.02421
G1 X173.066 Y153.697 E.03306
G1 X173.066 Y152.069 E.05236
; CHANGE_LAYER
; Z_HEIGHT: 4.6
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F8843.478
G1 X173.066 Y153.697 E-.61876
G1 X173.291 Y153.402 E-.14124
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 23/100
; update layer progress
M73 L23
M991 S0 P22 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z4.8 I-1.176 J.311 P1  F60000
G1 X177.309 Y168.584 Z4.8
G1 Z4.6
G1 E.8 F1800
; FEATURE: Inner wall
G1 F1304
M204 S8000
G1 X172.719 Y168.584 E.14759
G1 X172.719 Y151.416 E.55205
G1 X177.309 Y151.416 E.14759
G1 X177.309 Y168.524 E.55012
; COOLING_NODE: 0
M204 S10000
G1 X177.716 Y168.991 F60000
G1 F1304
M204 S8000
G1 X172.312 Y168.991 E.17377
G1 X172.312 Y151.009 E.57823
G1 X177.716 Y151.009 E.17377
G1 X177.716 Y168.931 E.5763
; COOLING_NODE: 0
M204 S10000
G1 X178.123 Y169.398 F60000
G1 F1304
M204 S8000
G1 X171.905 Y169.398 E.19995
G1 X171.905 Y150.602 E.60441
G1 X178.123 Y150.602 E.19995
G1 X178.123 Y169.338 E.60248
; COOLING_NODE: 0
M204 S250
G1 X178.515 Y169.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1216
M204 S5000
G1 X171.513 Y169.79 E.20857
G1 X171.513 Y150.21 E.58322
G1 X178.515 Y150.21 E.20857
G1 X178.515 Y169.73 E.58143
;======== H2D 20260731========
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
G1 X176.515 Y169.747 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X173.067 Y167.886 Z5 F60000
G1 Z4.6
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F1304
M204 S8000
G1 X173.067 Y168.236 E.01123
G1 X173.533 Y168.236 E.01497
G2 X173.476 Y167.862 I-.381 J-.133 E.01264
G1 X173.067 Y167.683 E.01435
G1 X173.067 Y164.05 E.11682
G1 X173.453 Y163.276 E.0278
G2 X173.476 Y162.621 I-.607 J-.35 E.02194
G1 X173.067 Y162.441 E.01435
G1 X173.067 Y158.808 E.11682
G1 X173.453 Y158.035 E.0278
G2 X173.476 Y157.379 I-.607 J-.35 E.02194
G1 X173.067 Y157.2 E.01435
G1 X173.067 Y153.567 E.11682
G1 X173.453 Y152.793 E.0278
G2 X173.476 Y152.138 I-.607 J-.35 E.02194
G1 X173.067 Y151.959 E.01435
G1 X173.067 Y151.764 E.00625
G1 X173.847 Y151.764 E.02507
G2 X173.904 Y152.138 I.381 J.133 E.01265
G1 X174.65 Y152.466 E.02621
G3 X176.073 Y154.104 I-1.251 J2.524 E.07163
G3 X176.097 Y154.759 I-.607 J.35 E.02194
G1 X175.35 Y155.086 E.02621
G2 X173.927 Y156.724 I1.251 J2.524 E.07163
G2 X173.904 Y157.379 I.607 J.35 E.02194
G1 X174.65 Y157.707 E.02621
G3 X176.073 Y159.345 I-1.251 J2.524 E.07163
G3 X176.097 Y160 I-.607 J.35 E.02194
G1 X175.35 Y160.328 E.02621
G2 X173.927 Y161.966 I1.251 J2.524 E.07163
G2 X173.904 Y162.621 I.607 J.35 E.02194
G1 X174.65 Y162.948 E.02621
G3 X176.073 Y164.586 I-1.251 J2.524 E.07163
G3 X176.097 Y165.241 I-.607 J.35 E.02194
G1 X175.35 Y165.569 E.02621
G2 X173.927 Y167.207 I1.251 J2.524 E.07163
G2 X173.904 Y167.862 I.607 J.35 E.02194
G3 X174.73 Y168.236 I-1.352 J4.096 E.02922
G1 X176.961 Y168.236 E.07172
G1 X176.961 Y166.747 E.04785
G3 X176.547 Y165.897 I2.133 J-1.561 E.03058
G3 X176.524 Y165.241 I.607 J-.35 E.02194
G1 X176.961 Y165.049 E.01534
G1 X176.961 Y161.506 E.11392
G3 X176.547 Y160.655 I2.133 J-1.561 E.03058
G3 X176.524 Y160 I.607 J-.35 E.02194
G1 X176.961 Y159.808 E.01534
G1 X176.961 Y156.265 E.11392
G3 X176.547 Y155.414 I2.133 J-1.561 E.03058
G3 X176.524 Y154.759 I.607 J-.35 E.02194
G1 X176.961 Y154.566 E.01534
G1 X176.961 Y152.938 E.05236
; CHANGE_LAYER
; Z_HEIGHT: 4.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F8843.478
G1 X176.961 Y154.566 E-.61876
G1 X176.621 Y154.716 E-.14124
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 24/100
; update layer progress
M73 L24
M991 S0 P23 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z5 I-1.215 J.06 P1  F60000
G1 X177.309 Y168.584 Z5
G1 Z4.8
G1 E.8 F1800
; FEATURE: Inner wall
G1 F1258
M204 S8000
G1 X172.72 Y168.584 E.14755
G1 X172.72 Y151.416 E.55205
G1 X177.309 Y151.416 E.14755
G1 X177.309 Y168.524 E.55012
; COOLING_NODE: 0
M204 S10000
G1 X177.716 Y168.991 F60000
G1 F1258
M204 S8000
G1 X172.313 Y168.991 E.17373
M73 P40 R15
G1 X172.313 Y151.009 E.57823
G1 X177.716 Y151.009 E.17373
G1 X177.716 Y168.931 E.5763
; COOLING_NODE: 0
M204 S10000
G1 X178.123 Y169.398 F60000
G1 F1258
M204 S8000
G1 X171.906 Y169.398 E.19991
G1 X171.906 Y150.602 E.60441
G1 X178.123 Y150.602 E.19991
G1 X178.123 Y169.338 E.60248
; COOLING_NODE: 0
M204 S250
G1 X178.515 Y169.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1211
M204 S5000
G1 X171.514 Y169.79 E.20854
G1 X171.514 Y150.21 E.58322
G1 X178.515 Y150.21 E.20854
G1 X178.515 Y169.73 E.58143
;======== H2D 20260731========
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
G1 X176.515 Y169.747 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X173.068 Y165.602 Z5.2 F60000
G1 Z4.8
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F1258
M204 S8000
G1 X173.068 Y163.974 E.05236
G1 X173.223 Y163.276 E.023
G2 X173.068 Y162.834 I-.511 J-.069 E.01562
G1 X173.068 Y158.733 E.13189
G1 X173.223 Y158.035 E.023
G2 X173.068 Y157.593 I-.511 J-.069 E.01562
G1 X173.068 Y153.491 E.13189
G1 X173.223 Y152.793 E.023
G3 X173.068 Y151.764 I2.346 J-.88 E.0337
G1 X174.212 Y151.764 E.03677
G1 X174.479 Y152.138 E.01477
G1 X175.301 Y152.793 E.0338
G3 X175.779 Y154.431 I-1.432 J1.307 E.05681
G1 X175.521 Y154.759 E.01341
G1 X174.699 Y155.414 E.0338
G2 X174.221 Y157.052 I1.432 J1.307 E.05681
G1 X174.479 Y157.379 E.01341
G1 X175.301 Y158.035 E.0338
G3 X175.779 Y159.673 I-1.432 J1.307 E.05681
G1 X175.521 Y160 E.01341
G1 X174.699 Y160.655 E.0338
G2 X174.221 Y162.293 I1.432 J1.307 E.05681
G1 X174.479 Y162.621 E.01341
G1 X175.301 Y163.276 E.0338
G3 X175.779 Y164.914 I-1.432 J1.307 E.05681
G1 X175.521 Y165.241 E.01341
G1 X174.699 Y165.897 E.0338
G2 X174.221 Y167.535 I1.432 J1.307 E.05681
G2 X174.948 Y168.236 I1.856 J-1.196 E.03275
G1 X176.961 Y168.236 E.06473
G1 X176.961 Y166.653 E.05088
G1 X176.777 Y165.897 E.02504
G3 X176.961 Y165.418 I.562 J-.059 E.0171
G1 X176.961 Y161.412 E.12883
G1 X176.777 Y160.655 E.02504
G3 X176.961 Y160.177 I.562 J-.059 E.0171
G1 X176.961 Y156.171 E.12883
G1 X176.777 Y155.414 E.02504
G3 X176.961 Y154.936 I.562 J-.059 E.0171
G1 X176.961 Y153.307 E.05236
; CHANGE_LAYER
; Z_HEIGHT: 5
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F8843.478
G1 X176.961 Y154.936 E-.61876
G1 X176.842 Y155.086 E-.07289
G1 X176.807 Y155.263 E-.06836
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 25/100
; update layer progress
M73 L25
M991 S0 P24 ;notify layer change

M106 S229.5
; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z5.2 I-1.216 J.046 P1  F60000
G1 X177.309 Y168.584 Z5.2
G1 Z5
G1 E.8 F1800
; FEATURE: Inner wall
G1 F1200
M204 S8000
G1 X172.721 Y168.584 E.14752
G1 X172.721 Y151.416 E.55205
G1 X177.309 Y151.416 E.14752
G1 X177.309 Y168.524 E.55012
; COOLING_NODE: 0
M204 S10000
G1 X177.716 Y168.991 F60000
G1 F1200
M204 S8000
G1 X172.314 Y168.991 E.17369
G1 X172.314 Y151.009 E.57823
G1 X177.716 Y151.009 E.17369
G1 X177.716 Y168.931 E.5763
; COOLING_NODE: 0
M204 S10000
G1 X178.123 Y169.398 F60000
G1 F1200
M204 S8000
G1 X171.907 Y169.398 E.19987
G1 X171.907 Y150.602 E.60441
G1 X178.123 Y150.602 E.19987
G1 X178.123 Y169.338 E.60248
; COOLING_NODE: 0
M204 S250
G1 X178.515 Y169.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
M73 P41 R15
G1 F1200
M204 S5000
G1 X171.515 Y169.79 E.2085
G1 X171.515 Y150.21 E.58322
G1 X178.515 Y150.21 E.2085
G1 X178.515 Y169.73 E.58143
;======== H2D 20260731========
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
G1 X176.515 Y169.747 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X176.728 Y162.118 Z5.4 F60000
G1 X176.961 Y153.758 Z5.4
G1 Z5
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X176.961 Y168.236 E.46556
G1 X175.113 Y168.236 E.05941
G3 X174.328 Y167.207 I1.74 J-2.142 E.042
G3 X174.612 Y165.897 I1.646 J-.329 E.04435
G2 X175.672 Y164.586 I-2.108 J-2.79 E.05474
G2 X175.388 Y163.276 I-1.646 J-.329 E.04435
G3 X174.328 Y161.966 I2.108 J-2.79 E.05474
G3 X174.612 Y160.655 I1.646 J-.329 E.04435
G2 X175.672 Y159.345 I-2.108 J-2.79 E.05474
G2 X175.388 Y158.035 I-1.646 J-.329 E.04435
G3 X174.328 Y156.724 I2.108 J-2.79 E.05474
G3 X174.612 Y155.414 I1.646 J-.329 E.04435
G2 X175.672 Y154.104 I-2.108 J-2.79 E.05474
G2 X175.388 Y152.793 I-1.646 J-.329 E.04435
G3 X174.448 Y151.764 I4.159 J-4.745 E.04491
G1 X173.07 Y151.764 E.04433
G1 X173.07 Y152.014 E.00804
; CHANGE_LAYER
; Z_HEIGHT: 5.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F8843.478
G1 X173.07 Y151.764 E-.09496
G1 X174.448 Y151.764 E-.5238
G1 X174.699 Y152.039 E-.14124
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 26/100
; update layer progress
M73 L26
M991 S0 P25 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z5.4 I-1.202 J.19 P1  F60000
G1 X177.309 Y168.584 Z5.4
G1 Z5.2
G1 E.8 F1800
; FEATURE: Inner wall
G1 F1200
M204 S8000
G1 X172.723 Y168.584 E.14748
G1 X172.723 Y151.416 E.55205
G1 X177.309 Y151.416 E.14748
G1 X177.309 Y168.524 E.55012
; COOLING_NODE: 0
M204 S10000
G1 X177.716 Y168.991 F60000
G1 F1200
M204 S8000
G1 X172.316 Y168.991 E.17366
G1 X172.316 Y151.009 E.57823
G1 X177.716 Y151.009 E.17366
G1 X177.716 Y168.931 E.5763
; COOLING_NODE: 0
M204 S10000
G1 X178.123 Y169.398 F60000
G1 F1200
M204 S8000
G1 X171.908 Y169.398 E.19984
G1 X171.908 Y150.602 E.60441
G1 X178.123 Y150.602 E.19984
G1 X178.123 Y169.338 E.60248
; COOLING_NODE: 0
M204 S250
G1 X178.515 Y169.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X171.516 Y169.79 E.20846
G1 X171.516 Y150.21 E.58322
G1 X178.515 Y150.21 E.20846
G1 X178.515 Y169.73 E.58143
;======== H2D 20260731========
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
G1 X176.515 Y169.747 E-.76
; WIPE_END
M73 P42 R15
G1 E-.04 F1800
M204 S10000
M73 P42 R14
G1 X176.89 Y168.236 Z5.6 F60000
G1 Z5.2
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X175.262 Y168.236 E.05236
G3 X174.462 Y167.207 I15.147 J-12.595 E.0419
G3 X175.041 Y165.241 I1.744 J-.554 E.06993
G1 X175.538 Y164.586 E.02643
G2 X174.959 Y162.621 I-1.744 J-.554 E.06993
G1 X174.462 Y161.966 E.02643
G3 X175.041 Y160 I1.744 J-.554 E.06993
G1 X175.538 Y159.345 E.02643
G2 X174.959 Y157.379 I-1.744 J-.554 E.06993
G1 X174.462 Y156.724 E.02643
G3 X175.041 Y154.759 I1.744 J-.554 E.06993
G1 X175.538 Y154.104 E.02643
G2 X174.959 Y152.138 I-1.744 J-.554 E.06993
G1 X174.676 Y151.764 E.01508
G1 X173.071 Y151.788 E.05161
; CHANGE_LAYER
; Z_HEIGHT: 5.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F8843.478
G1 X174.676 Y151.764 E-.60985
G1 X174.914 Y152.079 E-.15015
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 27/100
; update layer progress
M73 L27
M991 S0 P26 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z5.6 I-1.204 J.175 P1  F60000
G1 X177.309 Y168.584 Z5.6
G1 Z5.4
G1 E.8 F1800
; FEATURE: Inner wall
G1 F1200
M204 S8000
G1 X172.724 Y168.584 E.14744
G1 X172.724 Y151.416 E.55205
G1 X177.309 Y151.416 E.14744
G1 X177.309 Y168.524 E.55012
; COOLING_NODE: 0
M204 S10000
G1 X177.716 Y168.991 F60000
G1 F1200
M204 S8000
G1 X172.317 Y168.991 E.17362
G1 X172.317 Y151.009 E.57823
G1 X177.716 Y151.009 E.17362
G1 X177.716 Y168.931 E.5763
; COOLING_NODE: 0
M204 S10000
G1 X178.123 Y169.398 F60000
G1 F1200
M204 S8000
G1 X171.91 Y169.398 E.1998
G1 X171.91 Y150.602 E.60441
G1 X178.123 Y150.602 E.1998
G1 X178.123 Y169.338 E.60248
; COOLING_NODE: 0
M204 S250
G1 X178.515 Y169.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X171.518 Y169.79 E.20843
G1 X171.518 Y150.21 E.58322
G1 X178.515 Y150.21 E.20843
G1 X178.515 Y169.73 E.58143
;======== H2D 20260731========
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
G1 X176.515 Y169.747 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X176.961 Y168.096 Z5.8 F60000
G1 Z5.4
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X176.961 Y168.236 E.00449
G1 X175.472 Y168.236 E.04787
G2 X174.572 Y167.207 I-9.162 J7.109 E.04398
G1 X174.337 Y166.552 E.02238
G3 X174.838 Y165.241 I1.494 J-.18 E.04693
G2 X175.613 Y163.276 I-1.197 J-1.607 E.07155
G2 X174.572 Y161.966 I-4.315 J2.36 E.05408
G1 X174.337 Y161.31 E.02238
G3 X174.838 Y160 I1.494 J-.18 E.04693
G2 X175.613 Y158.035 I-1.197 J-1.607 E.07155
G2 X174.572 Y156.724 I-4.315 J2.36 E.05408
G1 X174.337 Y156.069 E.02238
G3 X174.838 Y154.759 I1.494 J-.18 E.04693
G2 X175.613 Y152.793 I-1.197 J-1.607 E.07155
G2 X174.825 Y151.764 I-3.398 J1.786 E.04187
G1 X173.197 Y151.764 E.05236
; CHANGE_LAYER
; Z_HEIGHT: 5.6
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F8843.478
G1 X174.825 Y151.764 E-.61876
G1 X175.072 Y152.042 E-.14124
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 28/100
; update layer progress
M73 L28
M991 S0 P27 ;notify layer change

M106 S226.95
; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z5.8 I-1.206 J.163 P1  F60000
G1 X177.309 Y168.584 Z5.8
G1 Z5.6
G1 E.8 F1800
; FEATURE: Inner wall
G1 F1253
M204 S8000
G1 X172.725 Y168.584 E.1474
G1 X172.725 Y151.416 E.55205
G1 X177.309 Y151.416 E.1474
G1 X177.309 Y168.524 E.55012
; COOLING_NODE: 0
M204 S10000
G1 X177.716 Y168.991 F60000
G1 F1253
M204 S8000
G1 X172.318 Y168.991 E.17358
M73 P43 R14
G1 X172.318 Y151.009 E.57823
G1 X177.716 Y151.009 E.17358
G1 X177.716 Y168.931 E.5763
; COOLING_NODE: 0
M204 S10000
G1 X178.123 Y169.398 F60000
G1 F1253
M204 S8000
G1 X171.911 Y169.398 E.19976
G1 X171.911 Y150.602 E.60441
G1 X178.123 Y150.602 E.19976
G1 X178.123 Y169.338 E.60248
; COOLING_NODE: 0
M204 S250
G1 X178.515 Y169.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1216
M204 S5000
G1 X171.519 Y169.79 E.20839
G1 X171.519 Y150.21 E.58322
G1 X178.515 Y150.21 E.20839
G1 X178.515 Y169.73 E.58143
;======== H2D 20260731========
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
G1 X176.515 Y169.747 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X173.073 Y166.454 Z6 F60000
G1 Z5.6
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F1253
M204 S8000
G1 X173.073 Y164.826 E.05236
G1 X173.147 Y164.586 E.00807
G1 X173.073 Y163.929 E.02126
G1 X173.073 Y159.585 E.1397
G1 X173.147 Y159.345 E.00807
G1 X173.073 Y158.688 E.02126
G1 X173.073 Y154.344 E.1397
G1 X173.147 Y154.104 E.00807
G1 X173.073 Y153.447 E.02126
G1 X173.073 Y151.764 E.05409
G1 X174.979 Y151.764 E.06129
G3 X175.767 Y152.793 I-1.002 J1.583 E.04255
G3 X175.336 Y154.104 I-1.803 J.132 E.04552
G2 X174.333 Y155.086 I2.69 J3.748 E.04532
G1 X174.233 Y155.414 E.01102
G2 X174.664 Y156.724 I1.803 J.132 E.04552
G3 X175.667 Y157.707 I-2.69 J3.748 E.04532
G1 X175.767 Y158.035 E.01102
G3 X175.336 Y159.345 I-1.803 J.132 E.04552
G2 X174.333 Y160.328 I2.69 J3.747 E.04532
G1 X174.233 Y160.655 E.01102
G2 X174.664 Y161.966 I1.803 J.132 E.04552
G3 X175.667 Y162.948 I-2.69 J3.748 E.04532
G1 X175.767 Y163.276 E.01102
G3 X175.336 Y164.586 I-1.803 J.132 E.04552
G2 X174.333 Y165.569 I2.69 J3.748 E.04532
G1 X174.233 Y165.897 E.01102
G2 X174.664 Y167.207 I1.803 J.132 E.04552
G3 X175.681 Y168.236 I-2.07 J3.062 E.04681
G1 X176.961 Y168.236 E.04114
G1 X176.961 Y167.543 E.02227
G3 X176.926 Y166.552 I1.351 J-.544 E.03254
G1 X176.961 Y162.302 E.13667
G3 X176.926 Y161.31 I1.351 J-.544 E.03254
G1 X176.961 Y157.06 E.13667
G3 X176.926 Y156.069 I1.351 J-.544 E.03254
G1 X176.961 Y154.374 E.05452
; CHANGE_LAYER
; Z_HEIGHT: 5.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F8843.478
G1 X176.926 Y156.069 E-.64429
G1 X176.892 Y156.372 E-.11571
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 29/100
; update layer progress
M73 L29
M991 S0 P28 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z6 I-1.216 J.041 P1  F60000
G1 X177.309 Y168.584 Z6
G1 Z5.8
G1 E.8 F1800
; FEATURE: Inner wall
G1 F1285
M204 S8000
G1 X172.726 Y168.584 E.14736
G1 X172.726 Y151.416 E.55205
G1 X177.309 Y151.416 E.14736
G1 X177.309 Y168.524 E.55012
; COOLING_NODE: 0
M204 S10000
G1 X177.716 Y168.991 F60000
G1 F1285
M204 S8000
G1 X172.319 Y168.991 E.17354
G1 X172.319 Y151.009 E.57823
G1 X177.716 Y151.009 E.17354
G1 X177.716 Y168.931 E.5763
; COOLING_NODE: 0
M204 S10000
G1 X178.123 Y169.398 F60000
G1 F1285
M204 S8000
G1 X171.912 Y169.398 E.19972
G1 X171.912 Y150.602 E.60441
G1 X178.123 Y150.602 E.19972
G1 X178.123 Y169.338 E.60248
; COOLING_NODE: 0
M204 S250
G1 X178.515 Y169.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
M73 P44 R14
G1 F1215
M204 S5000
G1 X171.52 Y169.79 E.20835
G1 X171.52 Y150.21 E.58322
G1 X178.515 Y150.21 E.20835
G1 X178.515 Y169.73 E.58143
;======== H2D 20260731========
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
G1 X176.515 Y169.747 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X173.075 Y166.913 Z6.2 F60000
G1 Z5.8
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F1285
M204 S8000
G1 X173.075 Y165.285 E.05236
G2 X173.349 Y164.586 I-.502 J-.601 E.02517
G1 X173.075 Y163.852 E.02521
G1 X173.075 Y160.043 E.12247
G2 X173.349 Y159.345 I-.502 J-.601 E.02517
G1 X173.075 Y158.611 E.02521
G1 X173.075 Y154.802 E.12247
G2 X173.349 Y154.104 I-.502 J-.601 E.02517
G1 X173.075 Y153.369 E.02521
G1 X173.098 Y151.764 E.05161
; WIPE_START
G1 F8843.478
G1 X173.075 Y153.369 E-.60993
G1 X173.213 Y153.739 E-.15007
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X176.961 Y159.172 Z6.2 F60000
G1 Z5.8
G1 E.8 F1800
G1 F1285
M204 S8000
G1 X176.961 Y157.544 E.05236
G2 X176.643 Y157.052 I-10.508 J6.429 E.01881
G3 X176.961 Y155.913 I2.659 J.127 E.03833
G1 X176.961 Y152.302 E.11612
G2 X176.643 Y151.811 I-10.508 J6.429 E.01881
G1 X176.644 Y151.764 E.00148
G1 X175.182 Y151.764 E.04702
G1 X175.762 Y152.138 E.02219
G1 X175.977 Y152.466 E.0126
G3 X175.255 Y154.104 I-2.404 J-.082 E.05899
G1 X174.238 Y154.759 E.0389
G1 X174.023 Y155.086 E.0126
G2 X174.746 Y156.724 I2.404 J-.082 E.05899
G1 X175.762 Y157.379 E.0389
G1 X175.977 Y157.707 E.0126
G3 X175.255 Y159.345 I-2.404 J-.082 E.05899
G1 X174.238 Y160 E.0389
G1 X174.023 Y160.328 E.0126
G2 X174.746 Y161.966 I2.404 J-.082 E.05899
G1 X175.762 Y162.621 E.0389
G1 X175.977 Y162.948 E.0126
G3 X175.255 Y164.586 I-2.404 J-.082 E.05899
G1 X174.238 Y165.241 E.0389
G1 X174.023 Y165.569 E.0126
G2 X174.746 Y167.207 I2.404 J-.082 E.05899
G1 X175.762 Y167.862 E.0389
G1 X175.976 Y168.236 E.01384
G1 X176.961 Y168.236 E.03165
G2 X176.643 Y167.535 I-.982 J.022 E.02542
G3 X176.961 Y166.396 I2.659 J.127 E.03833
G1 X176.961 Y162.785 E.11612
G2 X176.643 Y162.293 I-10.514 J6.433 E.01881
G3 X176.961 Y161.155 I2.659 J.127 E.03833
G1 X176.961 Y159.526 E.05236
; CHANGE_LAYER
; Z_HEIGHT: 6
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F8843.478
G1 X176.961 Y161.155 E-.61876
G1 X176.828 Y161.502 E-.14124
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 30/100
; update layer progress
M73 L30
M991 S0 P29 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z6.2 I-1.214 J.082 P1  F60000
G1 X177.309 Y168.584 Z6.2
G1 Z6
G1 E.8 F1800
; FEATURE: Inner wall
G1 F1236
M204 S8000
G1 X172.728 Y168.584 E.14732
G1 X172.728 Y151.416 E.55205
G1 X177.309 Y151.416 E.14732
G1 X177.309 Y168.524 E.55012
; COOLING_NODE: 0
M204 S10000
G1 X177.716 Y168.991 F60000
G1 F1236
M204 S8000
G1 X172.32 Y168.991 E.1735
G1 X172.32 Y151.009 E.57823
G1 X177.716 Y151.009 E.1735
G1 X177.716 Y168.931 E.5763
; COOLING_NODE: 0
M204 S10000
G1 X178.123 Y169.398 F60000
G1 F1236
M204 S8000
G1 X171.913 Y169.398 E.19968
G1 X171.913 Y150.602 E.60441
G1 X178.123 Y150.602 E.19968
G1 X178.123 Y169.338 E.60248
; COOLING_NODE: 0
M204 S250
G1 X178.515 Y169.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1212
M204 S5000
G1 X171.521 Y169.79 E.20832
G1 X171.521 Y150.21 E.58322
G1 X178.515 Y150.21 E.20832
G1 X178.515 Y169.73 E.58143
;======== H2D 20260731========
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
M73 P45 R14
G1 X176.515 Y169.747 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X174.97 Y168.236 Z6.4 F60000
G1 Z6
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F1236
M204 S8000
G1 X176.961 Y168.211 E.06401
G1 X176.961 Y166.302 E.06137
G1 X176.31 Y167.296 E.03818
G1 X175.983 Y167.515 E.01268
G3 X174.345 Y166.809 I.046 J-2.359 E.05882
G1 X173.69 Y165.808 E.03847
G2 X173.076 Y165.59 I-.468 J.343 E.02224
G1 X173.076 Y163.737 E.05958
G1 X173.69 Y164.675 E.03605
G1 X174.017 Y164.895 E.01268
G2 X175.655 Y164.188 I-.046 J-2.359 E.05882
G1 X176.31 Y163.187 E.03847
G3 X176.961 Y162.969 I.486 J.37 E.02341
G1 X176.961 Y161.061 E.06137
G1 X176.31 Y162.054 E.03818
G1 X175.983 Y162.274 E.01268
G3 X174.345 Y161.568 I.046 J-2.359 E.05882
G1 X173.69 Y160.567 E.03847
G2 X173.076 Y160.349 I-.468 J.344 E.02224
G1 X173.076 Y158.496 E.05958
G1 X173.69 Y159.434 E.03605
G1 X174.017 Y159.653 E.01268
G2 X175.655 Y158.947 I-.046 J-2.359 E.05882
G1 X176.31 Y157.946 E.03847
G3 X176.961 Y157.728 I.486 J.37 E.02341
G1 X176.961 Y155.82 E.06137
G1 X176.31 Y156.813 E.03818
G1 X175.983 Y157.033 E.01268
G3 X174.345 Y156.326 I.046 J-2.359 E.05882
G1 X173.69 Y155.325 E.03847
G2 X173.076 Y155.107 I-.468 J.344 E.02224
G1 X173.076 Y153.254 E.05958
G1 X173.69 Y154.192 E.03605
G1 X174.017 Y154.412 E.01268
G2 X175.655 Y153.706 I-.046 J-2.359 E.05882
G1 X176.31 Y152.705 E.03847
G3 X176.961 Y152.487 I.486 J.37 E.02341
G1 X176.961 Y151.764 E.02323
G3 X175.577 Y151.764 I-.692 J-11.746 E.04453
G1 X173.948 Y151.764 E.05236
; CHANGE_LAYER
; Z_HEIGHT: 6.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F8843.478
G1 X175.577 Y151.764 E-.61876
G1 X175.948 Y151.764 E-.14124
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 31/100
; update layer progress
M73 L31
M991 S0 P30 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z6.4 I-1.213 J.098 P1  F60000
G1 X177.309 Y168.584 Z6.4
G1 Z6.2
G1 E.8 F1800
; FEATURE: Inner wall
G1 F1208
M204 S8000
G1 X172.729 Y168.584 E.14728
G1 X172.729 Y151.416 E.55205
G1 X177.309 Y151.416 E.14728
G1 X177.309 Y168.524 E.55012
; COOLING_NODE: 0
M204 S10000
G1 X177.716 Y168.991 F60000
G1 F1208
M204 S8000
G1 X172.322 Y168.991 E.17346
G1 X172.322 Y151.009 E.57823
G1 X177.716 Y151.009 E.17346
G1 X177.716 Y168.931 E.5763
; COOLING_NODE: 0
M204 S10000
G1 X178.123 Y169.398 F60000
G1 F1208
M204 S8000
G1 X171.915 Y169.398 E.19964
G1 X171.915 Y150.602 E.60441
G1 X178.123 Y150.602 E.19964
G1 X178.123 Y169.338 E.60248
; COOLING_NODE: 0
M204 S250
G1 X178.515 Y169.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1208
M204 S5000
G1 X171.523 Y169.79 E.20828
G1 X171.523 Y150.21 E.58322
G1 X178.515 Y150.21 E.20828
G1 X178.515 Y169.73 E.58143
;======== H2D 20260731========
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
G1 X176.515 Y169.747 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
M73 P45 R13
G1 X176.961 Y167.847 Z6.6 F60000
G1 Z6.2
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F1208
M204 S8000
G1 X176.961 Y166.219 E.05236
G3 X175.983 Y167.21 I-3.837 J-2.807 E.04494
G3 X174.345 Y166.89 I-.513 J-1.727 E.05579
G1 X173.69 Y166.164 E.03146
G2 X173.077 Y165.804 I-.75 J.575 E.02343
G1 X173.077 Y163.64 E.0696
G2 X174.017 Y164.589 I3.678 J-2.701 E.04313
G2 X175.655 Y164.27 I.513 J-1.727 E.05579
G1 X176.31 Y163.543 E.03146
G3 X176.961 Y163.171 I.783 J.615 E.02469
G1 X176.961 Y160.977 E.07055
G3 X175.983 Y161.969 I-3.837 J-2.807 E.04494
G3 X174.345 Y161.649 I-.513 J-1.727 E.05579
G1 X173.69 Y160.923 E.03146
G2 X173.077 Y160.563 I-.75 J.575 E.02343
G1 X173.077 Y158.398 E.0696
G2 X174.017 Y159.348 I3.678 J-2.701 E.04313
G2 X175.655 Y159.028 I.513 J-1.727 E.05579
G1 X176.31 Y158.302 E.03146
G3 X176.961 Y157.93 I.783 J.615 E.02469
M73 P46 R13
G1 X176.961 Y155.736 E.07055
G3 X175.983 Y156.727 I-3.837 J-2.807 E.04494
G3 X174.345 Y156.408 I-.513 J-1.727 E.05579
G1 X173.69 Y155.681 E.03146
G2 X173.077 Y155.321 I-.75 J.575 E.02343
G1 X173.077 Y153.157 E.0696
G2 X174.017 Y154.107 I3.678 J-2.701 E.04313
G2 X175.655 Y153.787 I.513 J-1.727 E.05579
G1 X176.31 Y153.061 E.03146
G3 X176.961 Y152.689 I.783 J.615 E.02469
G1 X176.961 Y151.764 E.02972
G1 X176.257 Y151.764 E.02264
; CHANGE_LAYER
; Z_HEIGHT: 6.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F8843.478
G1 X176.961 Y151.764 E-.26752
G1 X176.961 Y152.689 E-.35124
G1 X176.638 Y152.79 E-.12849
G1 X176.612 Y152.812 E-.01275
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 32/100
; update layer progress
M73 L32
M991 S0 P31 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z6.6 I-1.216 J.054 P1  F60000
G1 X177.309 Y168.584 Z6.6
G1 Z6.4
G1 E.8 F1800
; FEATURE: Inner wall
G1 F1210
M204 S8000
G1 X172.73 Y168.584 E.14724
G1 X172.73 Y151.416 E.55205
G1 X177.309 Y151.416 E.14724
G1 X177.309 Y168.524 E.55012
; COOLING_NODE: 0
M204 S10000
G1 X177.716 Y168.991 F60000
G1 F1210
M204 S8000
G1 X172.323 Y168.991 E.17342
G1 X172.323 Y151.009 E.57823
G1 X177.716 Y151.009 E.17342
G1 X177.716 Y168.931 E.5763
; COOLING_NODE: 0
M204 S10000
G1 X178.123 Y169.398 F60000
G1 F1210
M204 S8000
G1 X171.916 Y169.398 E.1996
G1 X171.916 Y150.602 E.60441
G1 X178.123 Y150.602 E.1996
G1 X178.123 Y169.338 E.60248
; COOLING_NODE: 0
M204 S250
G1 X178.515 Y169.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1210
M204 S5000
G1 X171.524 Y169.79 E.20824
G1 X171.524 Y150.21 E.58322
G1 X178.515 Y150.21 E.20824
G1 X178.515 Y169.73 E.58143
;======== H2D 20260731========
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
G1 X176.515 Y169.747 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X176.961 Y167.753 Z6.8 F60000
G1 Z6.4
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F1210
M204 S8000
G1 X176.961 Y166.124 E.05236
G3 X175.655 Y167.16 I-4.814 J-4.728 E.05371
G3 X174.345 Y166.984 I-.458 J-1.555 E.04379
G2 X173.078 Y165.974 I-4.691 J4.586 E.05222
G1 X173.078 Y163.538 E.07832
G2 X174.345 Y164.539 I4.656 J-4.59 E.05204
G2 X175.655 Y164.363 I.458 J-1.555 E.04379
G3 X176.961 Y163.326 I4.819 J4.728 E.05373
G1 X176.961 Y160.883 E.07857
G3 X175.655 Y161.919 I-4.814 J-4.728 E.05371
G3 X174.345 Y161.742 I-.458 J-1.555 E.04379
G2 X173.078 Y160.733 I-4.691 J4.586 E.05222
G1 X173.078 Y158.297 E.07832
G2 X174.345 Y159.298 I4.656 J-4.59 E.05204
G2 X175.655 Y159.122 I.458 J-1.555 E.04379
G3 X176.961 Y158.085 I4.819 J4.728 E.05373
G1 X176.961 Y155.642 E.07857
G3 X175.655 Y156.677 I-4.814 J-4.728 E.05371
G3 X174.345 Y156.501 I-.458 J-1.555 E.04379
G2 X173.078 Y155.491 I-4.692 J4.587 E.05222
G1 X173.078 Y153.056 E.07832
G2 X174.345 Y154.057 I4.656 J-4.59 E.05204
G2 X175.655 Y153.88 I.458 J-1.555 E.04379
G3 X176.961 Y152.844 I4.819 J4.728 E.05373
G1 X176.961 Y151.764 E.03471
G1 X176.412 Y151.764 E.01765
; CHANGE_LAYER
; Z_HEIGHT: 6.6
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F8843.478
G1 X176.961 Y151.764 E-.20862
G1 X176.961 Y152.844 E-.41014
G1 X176.655 Y153.055 E-.14124
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 33/100
; update layer progress
M73 L33
M991 S0 P32 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z6.8 I-1.216 J.051 P1  F60000
G1 X177.309 Y168.584 Z6.8
G1 Z6.6
G1 E.8 F1800
; FEATURE: Inner wall
G1 F1211
M204 S8000
G1 X172.731 Y168.584 E.1472
G1 X172.731 Y151.416 E.55205
G1 X177.309 Y151.416 E.1472
G1 X177.309 Y168.524 E.55012
; COOLING_NODE: 0
M204 S10000
G1 X177.716 Y168.991 F60000
G1 F1211
M204 S8000
G1 X172.324 Y168.991 E.17338
M73 P47 R13
G1 X172.324 Y151.009 E.57823
G1 X177.716 Y151.009 E.17338
G1 X177.716 Y168.931 E.5763
; COOLING_NODE: 0
M204 S10000
G1 X178.123 Y169.398 F60000
G1 F1211
M204 S8000
G1 X171.917 Y169.398 E.19956
G1 X171.917 Y150.602 E.60441
G1 X178.123 Y150.602 E.19956
G1 X178.123 Y169.338 E.60248
; COOLING_NODE: 0
M204 S250
G1 X178.515 Y169.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1211
M204 S5000
G1 X171.525 Y169.79 E.20821
G1 X171.525 Y150.21 E.58322
G1 X178.515 Y150.21 E.20821
G1 X178.515 Y169.73 E.58143
;======== H2D 20260731========
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
G1 X176.515 Y169.747 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X173.08 Y167.731 Z7 F60000
G1 Z6.6
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F1211
M204 S8000
G1 X173.08 Y166.102 E.05236
G1 X173.69 Y166.6 E.02533
G2 X175.655 Y167.038 I1.286 J-1.144 E.06917
G3 X176.961 Y166.014 I13.866 J16.325 E.05337
G1 X176.961 Y163.449 E.08246
G1 X176.31 Y163.98 E.02698
G3 X174.345 Y164.417 I-1.286 J-1.144 E.06917
G2 X173.08 Y163.423 I-13.46 J15.827 E.05176
G1 X173.08 Y160.861 E.08238
G1 X173.69 Y161.359 E.02533
G2 X175.655 Y161.797 I1.286 J-1.144 E.06917
G3 X176.961 Y160.772 I13.87 J16.329 E.05337
G1 X176.961 Y158.208 E.08246
G1 X176.31 Y158.738 E.02698
G3 X174.345 Y159.176 I-1.286 J-1.144 E.06917
G2 X173.08 Y158.182 I-13.463 J15.831 E.05176
G1 X173.08 Y155.62 E.08238
G1 X173.69 Y156.118 E.02533
G2 X175.655 Y156.555 I1.286 J-1.144 E.06917
G3 X176.961 Y155.531 I13.866 J16.325 E.05337
G1 X176.961 Y152.966 E.08246
G1 X176.31 Y153.497 E.02698
G3 X174.345 Y153.935 I-1.286 J-1.144 E.06917
G2 X173.08 Y152.94 I-13.46 J15.827 E.05176
G1 X173.08 Y151.764 E.03781
G1 X173.532 Y151.764 E.01455
; CHANGE_LAYER
; Z_HEIGHT: 6.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F8843.478
G1 X173.08 Y151.764 E-.17195
G1 X173.08 Y152.94 E-.44682
G1 X173.372 Y153.17 E-.14124
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 34/100
; update layer progress
M73 L34
M991 S0 P33 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z7 I-1.179 J.301 P1  F60000
G1 X177.309 Y168.584 Z7
G1 Z6.8
G1 E.8 F1800
; FEATURE: Inner wall
G1 F1208
M204 S8000
G1 X172.732 Y168.584 E.14716
G1 X172.732 Y151.416 E.55205
G1 X177.309 Y151.416 E.14716
G1 X177.309 Y168.524 E.55012
; COOLING_NODE: 0
M204 S10000
G1 X177.716 Y168.991 F60000
G1 F1208
M204 S8000
G1 X172.325 Y168.991 E.17334
G1 X172.325 Y151.009 E.57823
G1 X177.716 Y151.009 E.17334
G1 X177.716 Y168.931 E.5763
; COOLING_NODE: 0
M204 S10000
G1 X178.123 Y169.398 F60000
G1 F1208
M204 S8000
G1 X171.918 Y169.398 E.19952
G1 X171.918 Y150.602 E.60441
G1 X178.123 Y150.602 E.19952
G1 X178.123 Y169.338 E.60248
; COOLING_NODE: 0
M204 S250
G1 X178.515 Y169.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
M73 P48 R13
G1 F1208
M204 S5000
G1 X171.526 Y169.79 E.20817
G1 X171.526 Y150.21 E.58322
G1 X178.515 Y150.21 E.20817
G1 X178.515 Y169.73 E.58143
;======== H2D 20260731========
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
G1 X176.515 Y169.747 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X173.081 Y167.841 Z7.2 F60000
G1 Z6.8
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F1208
M204 S8000
G1 X173.081 Y166.212 E.05236
G2 X174.017 Y167.092 I6.639 J-6.133 E.04134
G2 X175.655 Y166.937 I.675 J-1.605 E.0551
G1 X176.31 Y166.292 E.02957
G3 X176.961 Y165.876 I.976 J.812 E.0252
G1 X176.961 Y163.551 E.07477
G3 X175.983 Y164.471 I-6.943 J-6.4 E.0432
G3 X174.345 Y164.316 I-.675 J-1.605 E.0551
G2 X173.081 Y163.273 I-2.775 J2.075 E.05321
G1 X173.081 Y160.971 E.07403
G2 X174.017 Y161.85 I6.639 J-6.133 E.04134
G2 X175.655 Y161.695 I.675 J-1.605 E.0551
G1 X176.31 Y161.05 E.02957
G3 X176.961 Y160.635 I.976 J.812 E.0252
G1 X176.961 Y158.31 E.07477
G3 X175.983 Y159.23 I-6.943 J-6.401 E.0432
G3 X174.345 Y159.075 I-.675 J-1.605 E.0551
G2 X173.081 Y158.032 I-2.775 J2.075 E.05321
G1 X173.081 Y155.73 E.07403
G2 X174.017 Y156.609 I6.639 J-6.133 E.04134
G2 X175.655 Y156.454 I.675 J-1.605 E.0551
G1 X176.31 Y155.809 E.02957
G3 X176.961 Y155.394 I.976 J.812 E.0252
G1 X176.961 Y153.068 E.07477
G3 X175.983 Y153.988 I-6.943 J-6.4 E.0432
G3 X174.345 Y153.833 I-.675 J-1.605 E.0551
G2 X173.081 Y152.79 I-2.775 J2.075 E.05321
G1 X173.081 Y151.764 E.03299
G1 X173.683 Y151.764 E.01937
; CHANGE_LAYER
; Z_HEIGHT: 7
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F8843.478
G1 X173.081 Y151.764 E-.22892
G1 X173.081 Y152.79 E-.38985
G1 X173.362 Y152.909 E-.116
G1 X173.411 Y152.954 E-.02524
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 35/100
; update layer progress
M73 L35
M991 S0 P34 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z7.2 I-1.181 J.295 P1  F60000
G1 X177.309 Y168.584 Z7.2
G1 Z7
G1 E.8 F1800
; FEATURE: Inner wall
G1 F1210
M204 S8000
G1 X172.734 Y168.584 E.14712
G1 X172.734 Y151.416 E.55205
G1 X177.309 Y151.416 E.14712
G1 X177.309 Y168.524 E.55012
; COOLING_NODE: 0
M204 S10000
G1 X177.716 Y168.991 F60000
G1 F1210
M204 S8000
G1 X172.327 Y168.991 E.1733
G1 X172.327 Y151.009 E.57823
G1 X177.716 Y151.009 E.1733
G1 X177.716 Y168.931 E.5763
; COOLING_NODE: 0
M204 S10000
G1 X178.123 Y169.398 F60000
G1 F1210
M204 S8000
G1 X171.92 Y169.398 E.19948
G1 X171.92 Y150.602 E.60441
G1 X178.123 Y150.602 E.19948
G1 X178.123 Y169.338 E.60248
; COOLING_NODE: 0
M204 S250
G1 X178.515 Y169.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1210
M204 S5000
G1 X171.527 Y169.79 E.20813
G1 X171.527 Y150.21 E.58322
G1 X178.515 Y150.21 E.20813
G1 X178.515 Y169.73 E.58143
;======== H2D 20260731========
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
G1 X176.515 Y169.747 E-.76
; WIPE_END
M73 P49 R13
G1 E-.04 F1800
M204 S10000
G1 X173.082 Y167.942 Z7.4 F60000
G1 Z7
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F1210
M204 S8000
G1 X173.082 Y166.314 E.05236
G1 X173.69 Y167.084 E.03156
G1 X174.017 Y167.341 E.01338
G2 X175.655 Y166.85 I.314 J-1.929 E.05691
G1 X176.31 Y166.019 E.03402
G3 X176.961 Y165.702 I.631 J.468 E.02418
G1 X176.961 Y163.639 E.06632
G1 X176.31 Y164.464 E.03376
G1 X175.983 Y164.72 E.01338
G3 X174.345 Y164.229 I-.314 J-1.929 E.05691
G1 X173.69 Y163.398 E.03402
G2 X173.082 Y163.089 I-.602 J.431 E.02279
G1 X173.082 Y161.073 E.06484
G1 X173.69 Y161.843 E.03156
G1 X174.017 Y162.1 E.01338
G2 X175.655 Y161.608 I.314 J-1.929 E.05691
G1 X176.31 Y160.778 E.03402
G3 X176.961 Y160.46 I.631 J.468 E.02418
G1 X176.961 Y158.398 E.06632
G1 X176.31 Y159.222 E.03376
G1 X175.983 Y159.479 E.01338
G3 X174.345 Y158.988 I-.314 J-1.929 E.05691
G1 X173.69 Y158.157 E.03402
G2 X173.082 Y157.848 I-.602 J.431 E.02279
G1 X173.082 Y155.831 E.06484
G1 X173.69 Y156.602 E.03156
G1 X174.017 Y156.858 E.01338
G2 X175.655 Y156.367 I.314 J-1.929 E.05691
G1 X176.31 Y155.536 E.03402
G3 X176.961 Y155.219 I.631 J.468 E.02418
G1 X176.961 Y153.157 E.06632
G1 X176.31 Y153.981 E.03376
G1 X175.983 Y154.238 E.01338
G3 X174.345 Y153.747 I-.314 J-1.929 E.05691
G1 X173.69 Y152.916 E.03402
G2 X173.082 Y152.606 I-.602 J.431 E.02279
G1 X173.082 Y151.764 E.02707
G1 X173.868 Y151.764 E.02529
; CHANGE_LAYER
; Z_HEIGHT: 7.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F8843.478
G1 X173.082 Y151.764 E-.29882
G1 X173.082 Y152.606 E-.31994
G1 X173.362 Y152.659 E-.10834
G1 X173.43 Y152.713 E-.0329
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 36/100
; update layer progress
M73 L36
M991 S0 P35 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z7.4 I-1.182 J.289 P1  F60000
G1 X177.309 Y168.584 Z7.4
G1 Z7.2
G1 E.8 F1800
; FEATURE: Inner wall
G1 F1302
M204 S8000
G1 X172.735 Y168.584 E.14708
G1 X172.735 Y151.416 E.55205
G1 X177.309 Y151.416 E.14708
G1 X177.309 Y168.524 E.55012
; COOLING_NODE: 0
M204 S10000
G1 X177.716 Y168.991 F60000
G1 F1302
M204 S8000
G1 X172.328 Y168.991 E.17326
G1 X172.328 Y151.009 E.57823
G1 X177.716 Y151.009 E.17326
G1 X177.716 Y168.931 E.5763
; COOLING_NODE: 0
M204 S10000
G1 X178.123 Y169.398 F60000
G1 F1302
M204 S8000
G1 X171.921 Y169.398 E.19944
G1 X171.921 Y150.602 E.60441
G1 X178.123 Y150.602 E.19944
G1 X178.123 Y169.338 E.60248
; COOLING_NODE: 0
M204 S250
G1 X178.515 Y169.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1215
M204 S5000
G1 X171.529 Y169.79 E.2081
G1 X171.529 Y150.21 E.58322
G1 X178.515 Y150.21 E.2081
G1 X178.515 Y169.73 E.58143
;======== H2D 20260731========
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
G1 X176.515 Y169.747 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
M73 P49 R12
G1 X175.424 Y168.236 Z7.6 F60000
G1 Z7.2
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F1302
M204 S8000
G1 X173.796 Y168.236 E.05236
G1 X173.69 Y168.012 E.00795
G2 X173.083 Y168.074 I-.226 J.785 E.02009
G1 X173.083 Y167.046 E.03306
; WIPE_START
G1 F8843.478
G1 X173.083 Y168.074 E-.39063
G1 X173.362 Y167.987 E-.11112
G1 X173.69 Y168.012 E-.12486
G1 X173.796 Y168.236 E-.0939
G1 X173.899 Y168.236 E-.0395
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X173.083 Y164.789 Z7.6 F60000
G1 Z7.2
G1 E.8 F1800
G1 F1302
M204 S8000
G1 X173.083 Y166.418 E.05236
G3 X173.69 Y167.712 I-5.039 J3.151 E.04607
G1 X174.017 Y167.737 E.01057
G2 X175.328 Y167.12 I-1.352 J-4.57 E.04676
G2 X176.31 Y165.392 I-3.186 J-2.955 E.06452
G3 X176.961 Y165.467 I.231 J.846 E.02157
G1 X176.961 Y163.719 E.05622
G2 X176.31 Y165.091 I5.339 J3.37 E.04894
G1 X175.983 Y165.117 E.01057
G3 X174.672 Y164.5 I1.352 J-4.57 E.04676
G3 X173.69 Y162.771 I3.186 J-2.955 E.06452
G2 X173.083 Y162.833 I-.226 J.785 E.02009
G1 X173.083 Y164.461 E.05236
; WIPE_START
G1 F8843.478
G1 X173.083 Y162.833 E-.61876
G1 X173.362 Y162.745 E-.11112
G1 X173.441 Y162.752 E-.03013
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X173.083 Y159.548 Z7.6 F60000
G1 Z7.2
G1 E.8 F1800
G1 F1302
M204 S8000
G1 X173.083 Y161.176 E.05236
G3 X173.69 Y162.471 I-5.039 J3.151 E.04607
G1 X174.017 Y162.496 E.01057
G2 X175.328 Y161.879 I-1.352 J-4.57 E.04676
G2 X176.31 Y160.15 I-3.186 J-2.955 E.06452
G3 X176.961 Y160.226 I.231 J.846 E.02157
G1 X176.961 Y158.478 E.05622
G2 X176.31 Y159.85 I5.339 J3.37 E.04894
G1 X175.983 Y159.876 E.01057
G3 X174.672 Y159.258 I1.352 J-4.57 E.04676
G3 X173.69 Y157.53 I3.186 J-2.955 E.06452
G2 X173.083 Y157.592 I-.226 J.785 E.02009
G1 X173.083 Y159.22 E.05236
; WIPE_START
G1 F8843.478
G1 X173.083 Y157.592 E-.61876
G1 X173.362 Y157.504 E-.11112
G1 X173.441 Y157.51 E-.03012
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X173.083 Y154.307 Z7.6 F60000
G1 Z7.2
G1 E.8 F1800
G1 F1302
M204 S8000
G1 X173.083 Y155.935 E.05236
G3 X173.69 Y157.229 I-5.039 J3.151 E.04607
G1 X174.017 Y157.255 E.01057
G2 X175.328 Y156.638 I-1.352 J-4.569 E.04676
G2 X176.31 Y154.909 I-3.186 J-2.955 E.06452
G3 X176.961 Y154.985 I.231 J.846 E.02157
G1 X176.961 Y153.237 E.05622
G2 X176.31 Y154.609 I5.339 J3.37 E.04894
G1 X175.983 Y154.634 E.01057
G3 X174.672 Y154.017 I1.352 J-4.57 E.04676
M73 P50 R12
G3 X173.69 Y152.288 I3.186 J-2.955 E.06452
G2 X173.083 Y152.35 I-.226 J.785 E.02009
G1 X173.083 Y151.764 E.01884
G1 X173.598 Y151.764 E.01655
G1 X173.69 Y151.988 E.00777
G2 X174.676 Y151.764 I.164 J-1.566 E.03311
G1 X176.304 Y151.764 E.05236
; CHANGE_LAYER
; Z_HEIGHT: 7.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F8843.478
G1 X174.676 Y151.764 E-.61876
G1 X174.328 Y151.896 E-.14124
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 37/100
; update layer progress
M73 L37
M991 S0 P36 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z7.6 I-1.198 J.214 P1  F60000
G1 X177.309 Y168.584 Z7.6
G1 Z7.4
G1 E.8 F1800
; FEATURE: Inner wall
G1 F1259
M204 S8000
G1 X172.736 Y168.584 E.14704
G1 X172.736 Y151.416 E.55205
G1 X177.309 Y151.416 E.14704
G1 X177.309 Y168.524 E.55012
; COOLING_NODE: 0
M204 S10000
G1 X177.716 Y168.991 F60000
G1 F1259
M204 S8000
G1 X172.329 Y168.991 E.17322
G1 X172.329 Y151.009 E.57823
G1 X177.716 Y151.009 E.17322
G1 X177.716 Y168.931 E.5763
; COOLING_NODE: 0
M204 S10000
G1 X178.123 Y169.398 F60000
G1 F1259
M204 S8000
G1 X171.922 Y169.398 E.1994
G1 X171.922 Y150.602 E.60441
G1 X178.123 Y150.602 E.1994
G1 X178.123 Y169.338 E.60248
; COOLING_NODE: 0
M204 S250
G1 X178.515 Y169.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1210
M204 S5000
G1 X171.53 Y169.79 E.20806
G1 X171.53 Y150.21 E.58322
G1 X178.515 Y150.21 E.20806
G1 X178.515 Y169.73 E.58143
;======== H2D 20260731========
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
G1 X176.515 Y169.747 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X176.961 Y166.735 Z7.8 F60000
G1 Z7.4
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F1259
M204 S8000
G1 X176.961 Y165.107 E.05236
G3 X176.756 Y164.586 I.382 J-.451 E.01874
G1 X176.961 Y163.82 E.02549
G1 X176.961 Y159.866 E.12717
G3 X176.756 Y159.345 I.382 J-.451 E.01874
G1 X176.961 Y158.579 E.02549
G1 X176.961 Y154.624 E.12717
G3 X176.756 Y154.104 I.382 J-.451 E.01874
G1 X176.961 Y153.338 E.02549
G1 X176.961 Y151.764 E.05059
G1 X174.928 Y151.764 E.06536
G2 X174.135 Y152.793 I.556 J1.248 E.04352
G2 X174.708 Y154.104 I1.991 J-.089 E.04702
G1 X175.556 Y154.759 E.03447
G3 X175.865 Y155.414 I-.455 J.615 E.02426
G3 X175.293 Y156.724 I-1.991 J-.089 E.04702
G1 X174.444 Y157.379 E.03447
G2 X174.135 Y158.035 I.455 J.615 E.02426
G2 X174.708 Y159.345 I1.991 J-.089 E.04702
G1 X175.556 Y160 E.03447
G3 X175.865 Y160.655 I-.455 J.615 E.02426
G3 X175.293 Y161.966 I-1.991 J-.089 E.04702
G1 X174.444 Y162.621 E.03447
G2 X174.135 Y163.276 I.455 J.615 E.02426
G2 X174.708 Y164.586 I1.991 J-.089 E.04702
G1 X175.556 Y165.241 E.03447
G3 X175.865 Y165.897 I-.455 J.615 E.02426
G3 X175.293 Y167.207 I-1.991 J-.089 E.04702
G1 X174.444 Y167.862 E.03447
G1 X174.183 Y168.236 E.01466
G1 X173.084 Y168.236 E.03531
G1 X173.084 Y167.67 E.01819
G2 X173.244 Y167.207 I-.351 J-.38 E.0164
G1 X173.084 Y166.525 E.02251
G1 X173.084 Y162.428 E.13174
G2 X173.244 Y161.966 I-.351 J-.38 E.0164
G1 X173.084 Y161.284 E.02251
G1 X173.084 Y157.187 E.13174
G2 X173.244 Y156.724 I-.351 J-.38 E.0164
G1 X173.084 Y156.043 E.02251
G1 X173.084 Y154.414 E.05236
; CHANGE_LAYER
; Z_HEIGHT: 7.6
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F8843.478
G1 X173.084 Y156.043 E-.61876
G1 X173.169 Y156.405 E-.14124
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 38/100
; update layer progress
M73 L38
M991 S0 P37 ;notify layer change

M106 S229.5
; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z7.8 I-1.152 J.392 P1  F60000
G1 X177.309 Y168.584 Z7.8
G1 Z7.6
G1 E.8 F1800
; FEATURE: Inner wall
G1 F1200
M204 S8000
G1 X172.737 Y168.584 E.147
G1 X172.737 Y151.416 E.55205
G1 X177.309 Y151.416 E.147
G1 X177.309 Y168.524 E.55012
; COOLING_NODE: 0
M204 S10000
G1 X177.716 Y168.991 F60000
G1 F1200
M204 S8000
G1 X172.33 Y168.991 E.17318
G1 X172.33 Y151.009 E.57823
G1 X177.716 Y151.009 E.17318
G1 X177.716 Y168.931 E.5763
; COOLING_NODE: 0
M204 S10000
M73 P51 R12
G1 X178.123 Y169.398 F60000
G1 F1200
M204 S8000
G1 X171.923 Y169.398 E.19936
G1 X171.923 Y150.602 E.60441
G1 X178.123 Y150.602 E.19936
G1 X178.123 Y169.338 E.60248
; COOLING_NODE: 0
M204 S250
G1 X178.515 Y169.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X171.531 Y169.79 E.20802
G1 X171.531 Y150.21 E.58322
G1 X178.515 Y150.21 E.20802
G1 X178.515 Y169.73 E.58143
;======== H2D 20260731========
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
G1 X176.515 Y169.747 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X176.961 Y166.283 Z8 F60000
G1 Z7.6
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X176.961 Y151.764 E.46685
G1 X175.097 Y151.764 E.05991
G2 X174.446 Y152.466 I4.027 J4.397 E.03082
G2 X174.621 Y154.104 I1.617 J.655 E.05517
G3 X175.554 Y155.086 I-5.634 J6.284 E.04362
G3 X175.379 Y156.724 I-1.617 J.655 E.05517
G2 X174.446 Y157.707 I5.632 J6.282 E.04362
G2 X174.621 Y159.345 I1.617 J.655 E.05517
G3 X175.554 Y160.328 I-5.633 J6.283 E.04362
G3 X175.379 Y161.966 I-1.617 J.655 E.05517
G2 X174.446 Y162.948 I5.633 J6.283 E.04362
G2 X174.621 Y164.586 I1.617 J.655 E.05517
G3 X175.554 Y165.569 I-5.634 J6.284 E.04362
G3 X175.379 Y167.207 I-1.617 J.655 E.05517
G2 X174.427 Y168.236 I3.644 J4.326 E.04518
G1 X173.086 Y168.236 E.04313
G1 X173.086 Y167.949 E.00923
; CHANGE_LAYER
; Z_HEIGHT: 7.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F8843.478
G1 X173.086 Y168.236 E-.10908
G1 X174.427 Y168.236 E-.50969
G1 X174.679 Y167.963 E-.14124
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 39/100
; update layer progress
M73 L39
M991 S0 P38 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z8 I-.28 J1.184 P1  F60000
G1 X177.309 Y168.584 Z8
G1 Z7.8
G1 E.8 F1800
; FEATURE: Inner wall
G1 F1200
M204 S8000
G1 X172.739 Y168.584 E.14696
G1 X172.739 Y151.416 E.55205
G1 X177.309 Y151.416 E.14696
G1 X177.309 Y168.524 E.55012
; COOLING_NODE: 0
M204 S10000
G1 X177.716 Y168.991 F60000
G1 F1200
M204 S8000
G1 X172.332 Y168.991 E.17314
G1 X172.332 Y151.009 E.57823
G1 X177.716 Y151.009 E.17314
G1 X177.716 Y168.931 E.5763
; COOLING_NODE: 0
M204 S10000
G1 X178.123 Y169.398 F60000
G1 F1200
M204 S8000
G1 X171.924 Y169.398 E.19932
G1 X171.924 Y150.602 E.60441
G1 X178.123 Y150.602 E.19932
G1 X178.123 Y169.338 E.60248
; COOLING_NODE: 0
M204 S250
G1 X178.515 Y169.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
M73 P52 R12
G1 X171.532 Y169.79 E.20799
G1 X171.532 Y150.21 E.58322
G1 X178.515 Y150.21 E.20799
G1 X178.515 Y169.73 E.58143
;======== H2D 20260731========
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
G1 X176.515 Y169.747 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X176.288 Y168.236 Z8.2 F60000
G1 Z7.8
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X174.66 Y168.236 E.05236
G3 X175.479 Y167.207 I10.749 J7.719 E.0423
G2 X175.062 Y165.241 I-1.558 J-.697 E.06908
G1 X174.521 Y164.586 E.02732
G3 X174.938 Y162.621 I1.558 J-.697 E.06908
G1 X175.479 Y161.966 E.02732
G2 X175.062 Y160 I-1.558 J-.697 E.06908
G1 X174.521 Y159.345 E.02732
G3 X174.938 Y157.379 I1.558 J-.697 E.06908
G1 X175.479 Y156.724 E.02732
G2 X175.062 Y154.759 I-1.558 J-.697 E.06908
G1 X174.521 Y154.104 E.02732
G3 X174.938 Y152.138 I1.558 J-.697 E.06908
G1 X175.246 Y151.764 E.01558
G1 X173.618 Y151.764 E.05236
; CHANGE_LAYER
; Z_HEIGHT: 8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F8843.478
G1 X175.246 Y151.764 E-.61876
G1 X175.01 Y152.051 E-.14124
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 40/100
; update layer progress
M73 L40
M991 S0 P39 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z8.2 I-1.205 J.168 P1  F60000
G1 X177.309 Y168.584 Z8.2
G1 Z8
G1 E.8 F1800
; FEATURE: Inner wall
G1 F1200
M204 S8000
G1 X172.74 Y168.584 E.14692
G1 X172.74 Y151.416 E.55205
G1 X177.309 Y151.416 E.14692
G1 X177.309 Y168.524 E.55012
; COOLING_NODE: 0
M204 S10000
G1 X177.716 Y168.991 F60000
G1 F1200
M204 S8000
G1 X172.333 Y168.991 E.1731
G1 X172.333 Y151.009 E.57823
G1 X177.716 Y151.009 E.1731
G1 X177.716 Y168.931 E.5763
; COOLING_NODE: 0
M204 S10000
G1 X178.123 Y169.398 F60000
G1 F1200
M204 S8000
G1 X171.926 Y169.398 E.19928
G1 X171.926 Y150.602 E.60441
G1 X178.123 Y150.602 E.19928
G1 X178.123 Y169.338 E.60248
; COOLING_NODE: 0
M204 S250
G1 X178.515 Y169.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X171.534 Y169.79 E.20795
G1 X171.534 Y150.21 E.58322
G1 X178.515 Y150.21 E.20795
G1 X178.515 Y169.73 E.58143
;======== H2D 20260731========
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
G1 X176.515 Y169.747 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X176.439 Y168.236 Z8.4 F60000
G1 Z8
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X174.81 Y168.236 E.05236
G2 X175.599 Y167.207 I-4.167 J-4.013 E.04177
G2 X175.439 Y165.897 I-1.543 J-.476 E.04373
G3 X174.401 Y164.586 I5.293 J-5.258 E.05386
G3 X174.561 Y163.276 I1.543 J-.476 E.04373
G2 X175.599 Y161.966 I-5.292 J-5.257 E.05386
G2 X175.439 Y160.655 I-1.543 J-.476 E.04373
G3 X174.401 Y159.345 I5.293 J-5.258 E.05386
M73 P53 R12
G3 X174.561 Y158.035 I1.543 J-.476 E.04373
G2 X175.599 Y156.724 I-5.292 J-5.257 E.05386
G2 X175.439 Y155.414 I-1.543 J-.476 E.04373
G3 X174.401 Y154.104 I5.293 J-5.258 E.05386
G3 X174.561 Y152.793 I1.543 J-.476 E.04373
G2 X175.402 Y151.764 I-4.142 J-4.241 E.04281
G1 X173.774 Y151.764 E.05236
; CHANGE_LAYER
; Z_HEIGHT: 8.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F8843.478
G1 X175.402 Y151.764 E-.61876
G1 X175.167 Y152.052 E-.14124
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 41/100
; update layer progress
M73 L41
M991 S0 P40 ;notify layer change

M106 S226.95
; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z8.4 I-1.207 J.156 P1  F60000
G1 X177.309 Y168.584 Z8.4
G1 Z8.2
G1 E.8 F1800
; FEATURE: Inner wall
G1 F1250
M204 S8000
G1 X172.741 Y168.584 E.14688
G1 X172.741 Y151.416 E.55205
G1 X177.309 Y151.416 E.14688
G1 X177.309 Y168.524 E.55012
; COOLING_NODE: 0
M204 S10000
G1 X177.716 Y168.991 F60000
G1 F1250
M204 S8000
G1 X172.334 Y168.991 E.17306
G1 X172.334 Y151.009 E.57823
G1 X177.716 Y151.009 E.17306
G1 X177.716 Y168.931 E.5763
; COOLING_NODE: 0
M204 S10000
G1 X178.123 Y169.398 F60000
G1 F1250
M204 S8000
G1 X171.927 Y169.398 E.19924
G1 X171.927 Y150.602 E.60441
G1 X178.123 Y150.602 E.19924
G1 X178.123 Y169.338 E.60248
; COOLING_NODE: 0
M204 S250
G1 X178.515 Y169.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1215
M204 S5000
G1 X171.535 Y169.79 E.20791
G1 X171.535 Y150.21 E.58322
G1 X178.515 Y150.21 E.20791
G1 X178.515 Y169.73 E.58143
;======== H2D 20260731========
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
G1 X176.515 Y169.747 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
M73 P53 R11
G1 X176.961 Y165.618 Z8.6 F60000
G1 Z8.2
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F1250
M204 S8000
G1 X176.961 Y163.99 E.05236
G1 X176.871 Y163.276 E.02314
G1 X176.961 Y163.005 E.00918
G1 X176.961 Y158.749 E.13686
G1 X176.871 Y158.035 E.02314
G1 X176.961 Y157.763 E.00918
G1 X176.961 Y153.507 E.13686
G1 X176.871 Y152.793 E.02314
G1 X176.961 Y152.522 E.00918
G1 X176.961 Y151.764 E.02436
G1 X175.657 Y151.764 E.04192
G3 X174.656 Y152.793 I-3.323 J-2.233 E.04642
G2 X174.358 Y154.431 I1.409 J1.102 E.05568
G2 X175.345 Y155.414 I4.081 J-3.109 E.04491
G3 X175.642 Y157.052 I-1.409 J1.102 E.05568
G3 X174.656 Y158.035 I-4.081 J-3.109 E.04491
G2 X174.358 Y159.673 I1.409 J1.102 E.05568
G2 X175.345 Y160.655 I4.082 J-3.11 E.04491
G3 X175.642 Y162.293 I-1.409 J1.102 E.05568
G3 X174.656 Y163.276 I-4.081 J-3.109 E.04491
G2 X174.358 Y164.914 I1.409 J1.102 E.05568
G2 X175.345 Y165.897 I4.081 J-3.109 E.04491
G3 X175.642 Y167.535 I-1.409 J1.102 E.05568
G3 X174.963 Y168.236 I-2.899 J-2.129 E.03148
G1 X173.089 Y168.236 E.06024
G3 X173.129 Y165.897 I12.951 J-.95 E.07533
G1 X173.089 Y161.094 E.15445
G2 X173.089 Y160.535 I-.645 J-.279 E.01848
G1 X173.089 Y155.852 E.15058
G2 X173.089 Y153.665 I-21.216 J-1.094 E.07036
; CHANGE_LAYER
; Z_HEIGHT: 8.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F8843.478
G1 X173.089 Y155.665 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 42/100
; update layer progress
M73 L42
M991 S0 P41 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z8.6 I-1.157 J.378 P1  F60000
G1 X177.309 Y168.584 Z8.6
G1 Z8.4
G1 E.8 F1800
; FEATURE: Inner wall
G1 F1282
M204 S8000
G1 X172.742 Y168.584 E.14684
G1 X172.742 Y151.416 E.55205
G1 X177.309 Y151.416 E.14684
G1 X177.309 Y168.524 E.55012
; COOLING_NODE: 0
M204 S10000
G1 X177.716 Y168.991 F60000
G1 F1282
M204 S8000
G1 X172.335 Y168.991 E.17302
G1 X172.335 Y151.009 E.57823
G1 X177.716 Y151.009 E.17302
G1 X177.716 Y168.931 E.5763
; COOLING_NODE: 0
M204 S10000
M73 P54 R11
G1 X178.123 Y169.398 F60000
G1 F1282
M204 S8000
G1 X171.928 Y169.398 E.1992
G1 X171.928 Y150.602 E.60441
G1 X178.123 Y150.602 E.1992
G1 X178.123 Y169.338 E.60248
; COOLING_NODE: 0
M204 S250
G1 X178.515 Y169.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1214
M204 S5000
G1 X171.536 Y169.79 E.20788
G1 X171.536 Y150.21 E.58322
G1 X178.515 Y150.21 E.20788
G1 X178.515 Y169.73 E.58143
;======== H2D 20260731========
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
G1 X176.515 Y169.747 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X173.091 Y168.23 Z8.8 F60000
G1 Z8.4
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F1282
M204 S8000
G1 X173.127 Y166.552 E.05397
G2 X173.317 Y165.569 I-1.392 J-.779 E.03274
G1 X173.091 Y165.243 E.01278
G1 X173.127 Y161.31 E.12645
G2 X173.317 Y160.328 I-1.392 J-.779 E.03274
G1 X173.091 Y160.001 E.01278
G1 X173.127 Y156.069 E.12645
G2 X173.317 Y155.086 I-1.392 J-.779 E.03274
G1 X173.091 Y154.76 E.01278
G1 X173.091 Y153.132 E.05236
; WIPE_START
G1 F8843.478
G1 X173.091 Y154.76 E-.61876
G1 X173.303 Y155.065 E-.14124
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X176.961 Y160.464 Z8.8 F60000
G1 Z8.4
G1 E.8 F1800
G1 F1282
M204 S8000
G1 X176.961 Y158.836 E.05236
G3 X176.683 Y157.707 I2.187 J-1.136 E.03774
G2 X176.961 Y157.287 I-1.781 J-1.479 E.01622
G1 X176.961 Y153.595 E.11874
G3 X176.683 Y152.466 I2.187 J-1.136 E.03774
G2 X176.961 Y151.764 I-.477 J-.594 E.02537
G1 X175.939 Y151.764 E.03285
G1 X175.71 Y152.138 E.01409
G1 X174.738 Y152.793 E.03772
G2 X174.054 Y154.104 I1.487 J1.609 E.04848
G2 X174.29 Y154.759 I.616 J.148 E.0237
G1 X175.263 Y155.414 E.03772
G3 X175.946 Y156.724 I-1.487 J1.609 E.04848
G3 X175.71 Y157.379 I-.616 J.148 E.0237
G1 X174.738 Y158.035 E.03772
G2 X174.054 Y159.345 I1.487 J1.609 E.04848
G2 X174.29 Y160 I.616 J.148 E.0237
G1 X175.263 Y160.655 E.03772
G3 X175.946 Y161.966 I-1.487 J1.609 E.04848
G3 X175.71 Y162.621 I-.616 J.148 E.0237
G1 X174.738 Y163.276 E.03772
G2 X174.054 Y164.586 I1.487 J1.609 E.04848
G2 X174.29 Y165.241 I.616 J.148 E.0237
G1 X175.263 Y165.897 E.03772
G3 X175.938 Y167.535 I-1.605 J1.62 E.05851
G3 X175.156 Y168.236 I-1.291 J-.653 E.03456
G1 X176.682 Y168.236 E.04907
G3 X176.961 Y167.77 I3.56 J1.814 E.01747
G1 X176.961 Y164.077 E.11874
G3 X176.683 Y162.948 I2.187 J-1.136 E.03774
G2 X176.961 Y162.528 I-1.781 J-1.479 E.01622
G1 X176.961 Y160.9 E.05236
; CHANGE_LAYER
; Z_HEIGHT: 8.6
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F8843.478
G1 X176.961 Y162.528 E-.61876
G1 X176.756 Y162.838 E-.14124
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 43/100
; update layer progress
M73 L43
M991 S0 P42 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z8.8 I-1.211 J.117 P1  F60000
G1 X177.309 Y168.584 Z8.8
G1 Z8.6
G1 E.8 F1800
; FEATURE: Inner wall
G1 F1237
M204 S8000
G1 X172.744 Y168.584 E.1468
G1 X172.744 Y151.416 E.55205
G1 X177.309 Y151.416 E.1468
G1 X177.309 Y168.524 E.55012
; COOLING_NODE: 0
M204 S10000
G1 X177.716 Y168.991 F60000
G1 F1237
M204 S8000
G1 X172.336 Y168.991 E.17298
G1 X172.336 Y151.009 E.57823
G1 X177.716 Y151.009 E.17298
G1 X177.716 Y168.931 E.5763
; COOLING_NODE: 0
M204 S10000
G1 X178.123 Y169.398 F60000
G1 F1237
M204 S8000
G1 X171.929 Y169.398 E.19916
G1 X171.929 Y150.602 E.60441
G1 X178.123 Y150.602 E.19916
G1 X178.123 Y169.338 E.60248
; COOLING_NODE: 0
M204 S250
G1 X178.515 Y169.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
M73 P55 R11
G1 F1212
M204 S5000
G1 X171.537 Y169.79 E.20784
G1 X171.537 Y150.21 E.58322
G1 X178.515 Y150.21 E.20784
G1 X178.515 Y169.73 E.58143
;======== H2D 20260731========
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
G1 X176.515 Y169.747 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X173.884 Y168.236 Z9 F60000
G1 Z8.6
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F1237
M204 S8000
G1 X175.512 Y168.236 E.05236
G3 X176.091 Y168.236 I.29 J.686 E.01913
G1 X176.961 Y168.236 E.02795
G1 X176.961 Y167.538 E.02243
G3 X176.31 Y167.352 I-.193 J-.553 E.02318
G1 X175.655 Y166.302 E.03978
G2 X174.345 Y165.566 I-1.723 J1.53 E.04924
G2 X173.69 Y165.752 I-.196 J.557 E.02334
G1 X173.092 Y166.709 E.03631
G1 X173.092 Y164.92 E.05753
G2 X173.69 Y164.731 I.165 J-.518 E.0215
G1 X174.345 Y163.682 E.03978
G3 X175.655 Y162.945 I1.723 J1.53 E.04924
G3 X176.31 Y163.131 I.196 J.557 E.02334
G1 X176.961 Y164.172 E.03948
G1 X176.961 Y162.297 E.06031
G3 X176.31 Y162.111 I-.193 J-.553 E.02318
G1 X175.655 Y161.061 E.03978
G2 X174.345 Y160.324 I-1.723 J1.53 E.04924
G2 X173.69 Y160.51 I-.196 J.557 E.02334
G1 X173.092 Y161.468 E.03631
G1 X173.092 Y159.679 E.05753
G2 X173.69 Y159.49 I.165 J-.518 E.0215
G1 X174.345 Y158.44 E.03978
G3 X175.655 Y157.704 I1.723 J1.53 E.04924
G3 X176.31 Y157.89 I.196 J.557 E.02334
G1 X176.961 Y158.931 E.03948
G1 X176.961 Y157.055 E.06032
G3 X176.31 Y156.869 I-.193 J-.553 E.02318
G1 X175.655 Y155.82 E.03978
G2 X174.345 Y155.083 I-1.723 J1.53 E.04924
G2 X173.69 Y155.269 I-.196 J.557 E.02334
G1 X173.092 Y156.227 E.03631
G1 X173.092 Y154.438 E.05753
G2 X173.69 Y154.249 I.165 J-.518 E.0215
G1 X174.345 Y153.199 E.03978
G3 X175.655 Y152.463 I1.723 J1.53 E.04924
G3 X176.31 Y152.648 I.196 J.557 E.02334
G1 X176.961 Y153.69 E.03948
G1 X176.961 Y151.814 E.06031
G3 X176.529 Y151.764 I-.181 J-.33 E.01489
G1 X174.901 Y151.764 E.05236
; CHANGE_LAYER
; Z_HEIGHT: 8.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F8843.478
G1 X176.529 Y151.764 E-.61876
G1 X176.638 Y151.832 E-.04879
G1 X176.881 Y151.819 E-.09246
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 44/100
; update layer progress
M73 L44
M991 S0 P43 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z9 I-1.217 J.031 P1  F60000
G1 X177.309 Y168.584 Z9
G1 Z8.8
G1 E.8 F1800
; FEATURE: Inner wall
G1 F1208
M204 S8000
G1 X172.745 Y168.584 E.14676
G1 X172.745 Y151.416 E.55205
G1 X177.309 Y151.416 E.14676
G1 X177.309 Y168.524 E.55012
; COOLING_NODE: 0
M204 S10000
G1 X177.716 Y168.991 F60000
G1 F1208
M204 S8000
G1 X172.338 Y168.991 E.17294
G1 X172.338 Y151.009 E.57823
G1 X177.716 Y151.009 E.17294
G1 X177.716 Y168.931 E.5763
; COOLING_NODE: 0
M204 S10000
G1 X178.123 Y169.398 F60000
G1 F1208
M204 S8000
G1 X171.931 Y169.398 E.19912
G1 X171.931 Y150.602 E.60441
G1 X178.123 Y150.602 E.19912
G1 X178.123 Y169.338 E.60248
; COOLING_NODE: 0
M204 S250
G1 X178.515 Y169.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1208
M204 S5000
G1 X171.539 Y169.79 E.2078
G1 X171.539 Y150.21 E.58322
G1 X178.515 Y150.21 E.2078
G1 X178.515 Y169.73 E.58143
;======== H2D 20260731========
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
G1 X176.515 Y169.747 E-.76
; WIPE_END
M73 P56 R11
G1 E-.04 F1800
M204 S10000
G1 X176.238 Y168.236 Z9.2 F60000
G1 Z8.8
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F1208
M204 S8000
G1 X176.961 Y168.236 E.02323
G1 X176.961 Y167.33 E.02913
G1 X176.638 Y167.236 E.0108
G3 X175.655 Y166.222 I2.569 J-3.473 E.04561
G2 X174.345 Y165.772 I-1.204 J1.375 E.04569
G1 X174.017 Y165.867 E.01097
G2 X173.093 Y166.815 I2.397 J3.263 E.04275
G1 X173.093 Y164.694 E.06822
G1 X173.362 Y164.615 E.00901
G2 X174.345 Y163.601 I-2.569 J-3.473 E.04561
G3 X175.655 Y163.152 I1.204 J1.375 E.04569
G1 X175.983 Y163.247 E.01097
G3 X176.961 Y164.255 I-2.554 J3.454 E.04537
G1 X176.961 Y162.088 E.06967
G1 X176.638 Y161.995 E.0108
G3 X175.655 Y160.981 I2.569 J-3.473 E.04561
G2 X174.345 Y160.531 I-1.204 J1.375 E.04569
G1 X174.017 Y160.626 E.01097
G2 X173.093 Y161.574 I2.397 J3.263 E.04275
G1 X173.093 Y159.452 E.06822
G1 X173.362 Y159.374 E.00901
G2 X174.345 Y158.36 I-2.569 J-3.473 E.04561
G3 X175.655 Y157.91 I1.204 J1.375 E.04569
G1 X175.983 Y158.005 E.01097
G3 X176.961 Y159.014 I-2.553 J3.454 E.04537
G1 X176.961 Y156.847 E.06967
G1 X176.638 Y156.753 E.0108
G3 X175.655 Y155.739 I2.569 J-3.473 E.04561
G2 X174.345 Y155.29 I-1.204 J1.375 E.04569
G1 X174.017 Y155.385 E.01097
G2 X173.093 Y156.332 I2.397 J3.263 E.04275
G1 X173.093 Y154.211 E.06822
G1 X173.362 Y154.133 E.00901
G2 X174.345 Y153.119 I-2.569 J-3.473 E.04561
G3 X175.655 Y152.669 I1.204 J1.375 E.04569
G1 X175.983 Y152.764 E.01097
G3 X176.961 Y153.773 I-2.554 J3.454 E.04537
G1 X176.961 Y152.144 E.05236
; CHANGE_LAYER
; Z_HEIGHT: 9
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F8843.478
G1 X176.961 Y153.773 E-.61876
G1 X176.715 Y153.493 E-.14124
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 45/100
; update layer progress
M73 L45
M991 S0 P44 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z9.2 I-1.216 J.048 P1  F60000
G1 X177.309 Y168.584 Z9.2
G1 Z9
G1 E.8 F1800
; FEATURE: Inner wall
G1 F1207
M204 S8000
G1 X172.746 Y168.584 E.14672
G1 X172.746 Y151.416 E.55205
G1 X177.309 Y151.416 E.14672
G1 X177.309 Y168.524 E.55012
; COOLING_NODE: 0
M204 S10000
G1 X177.716 Y168.991 F60000
G1 F1207
M204 S8000
G1 X172.339 Y168.991 E.1729
G1 X172.339 Y151.009 E.57823
G1 X177.716 Y151.009 E.1729
G1 X177.716 Y168.931 E.5763
; COOLING_NODE: 0
M204 S10000
G1 X178.123 Y169.398 F60000
G1 F1207
M204 S8000
G1 X171.932 Y169.398 E.19908
G1 X171.932 Y150.602 E.60441
G1 X178.123 Y150.602 E.19908
G1 X178.123 Y169.338 E.60248
; COOLING_NODE: 0
M204 S250
G1 X178.515 Y169.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1207
M204 S5000
G1 X171.54 Y169.79 E.20777
G1 X171.54 Y150.21 E.58322
G1 X178.515 Y150.21 E.20777
G1 X178.515 Y169.73 E.58143
;======== H2D 20260731========
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
G1 X176.515 Y169.747 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X176.396 Y168.236 Z9.4 F60000
G1 Z9
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F1207
M204 S8000
G1 X176.961 Y168.236 E.01815
G1 X176.961 Y167.172 E.03421
G3 X176.31 Y166.728 I.499 J-1.429 E.02561
G2 X174.345 Y165.929 I-1.633 J1.201 E.07179
G2 X173.094 Y166.919 I2.063 J3.893 E.05156
G1 X173.094 Y164.524 E.077
G2 X173.69 Y164.107 I-.477 J-1.314 E.02365
G3 X175.655 Y163.309 I1.633 J1.201 E.07179
G3 X176.961 Y164.348 I-2.166 J4.06 E.05395
G1 X176.961 Y161.93 E.07774
G3 X176.31 Y161.487 I.499 J-1.429 E.02561
G2 X174.345 Y160.688 I-1.633 J1.201 E.07179
G2 X173.094 Y161.677 I2.063 J3.893 E.05156
G1 X173.094 Y159.283 E.077
G2 X173.69 Y158.866 I-.477 J-1.314 E.02365
G3 X175.655 Y158.067 I1.633 J1.201 E.07179
G3 X176.961 Y159.107 I-2.167 J4.061 E.05395
G1 X176.961 Y156.689 E.07774
G3 X176.31 Y156.245 I.499 J-1.429 E.02561
G2 X174.345 Y155.447 I-1.633 J1.201 E.07179
G2 X173.094 Y156.436 I2.063 J3.893 E.05156
G1 X173.094 Y154.042 E.077
G2 X173.69 Y153.625 I-.477 J-1.314 E.02365
G3 X175.655 Y152.826 I1.633 J1.201 E.07179
G3 X176.961 Y153.865 I-2.166 J4.06 E.05395
G1 X176.961 Y152.237 E.05236
; CHANGE_LAYER
; Z_HEIGHT: 9.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F8843.478
G1 X176.961 Y153.865 E-.61876
M73 P57 R11
G1 X176.684 Y153.617 E-.14124
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 46/100
; update layer progress
M73 L46
M991 S0 P45 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z9.4 I-1.216 J.051 P1  F60000
G1 X177.309 Y168.584 Z9.4
G1 Z9.2
G1 E.8 F1800
; FEATURE: Inner wall
G1 F1210
M204 S8000
G1 X172.747 Y168.584 E.14668
G1 X172.747 Y151.416 E.55205
G1 X177.309 Y151.416 E.14668
G1 X177.309 Y168.524 E.55012
; COOLING_NODE: 0
M204 S10000
G1 X177.716 Y168.991 F60000
G1 F1210
M204 S8000
G1 X172.34 Y168.991 E.17286
G1 X172.34 Y151.009 E.57823
G1 X177.716 Y151.009 E.17286
G1 X177.716 Y168.931 E.5763
; COOLING_NODE: 0
M204 S10000
G1 X178.123 Y169.398 F60000
G1 F1210
M204 S8000
G1 X171.933 Y169.398 E.19904
G1 X171.933 Y150.602 E.60441
G1 X178.123 Y150.602 E.19904
G1 X178.123 Y169.338 E.60248
; COOLING_NODE: 0
M204 S250
G1 X178.515 Y169.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1210
M204 S5000
G1 X171.541 Y169.79 E.20773
G1 X171.541 Y150.21 E.58322
G1 X178.515 Y150.21 E.20773
G1 X178.515 Y169.73 E.58143
;======== H2D 20260731========
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
M73 P57 R10
G1 X176.515 Y169.747 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X173.523 Y168.236 Z9.6 F60000
G1 Z9.2
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F1210
M204 S8000
G1 X173.096 Y168.236 E.01375
G1 X173.096 Y167.035 E.03861
G1 X173.69 Y166.579 E.02407
G3 X175.655 Y166.022 I1.391 J1.161 E.06979
G3 X176.961 Y167.045 I-22.408 J29.929 E.05334
G1 X176.961 Y164.457 E.08324
G1 X176.31 Y163.959 E.02634
G2 X174.345 Y163.401 I-1.391 J1.161 E.06979
G2 X173.096 Y164.38 I21.435 J28.659 E.05103
G1 X173.096 Y161.793 E.08317
G1 X173.69 Y161.338 E.02407
G3 X175.655 Y160.781 I1.391 J1.161 E.06979
G3 X176.961 Y161.804 I-22.417 J29.941 E.05334
G1 X176.961 Y159.216 E.08324
G1 X176.31 Y158.718 E.02634
G2 X174.345 Y158.16 I-1.391 J1.161 E.06979
G2 X173.096 Y159.139 I21.445 J28.671 E.05103
G1 X173.096 Y156.552 E.08317
G1 X173.69 Y156.097 E.02407
G3 X175.655 Y155.54 I1.391 J1.161 E.06979
G3 X176.961 Y156.563 I-22.408 J29.929 E.05334
G1 X176.961 Y153.974 E.08324
G1 X176.31 Y153.476 E.02634
G2 X174.345 Y152.919 I-1.391 J1.161 E.06979
G2 X173.096 Y153.897 I21.435 J28.659 E.05103
G1 X173.096 Y152.269 E.05236
; CHANGE_LAYER
; Z_HEIGHT: 9.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F8843.478
G1 X173.096 Y153.897 E-.61876
G1 X173.388 Y153.668 E-.14124
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 47/100
; update layer progress
M73 L47
M991 S0 P46 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z9.6 I-1.177 J.309 P1  F60000
G1 X177.309 Y168.584 Z9.6
G1 Z9.4
G1 E.8 F1800
; FEATURE: Inner wall
G1 F1207
M204 S8000
G1 X172.748 Y168.584 E.14664
G1 X172.748 Y151.416 E.55205
G1 X177.309 Y151.416 E.14664
G1 X177.309 Y168.524 E.55012
; COOLING_NODE: 0
M204 S10000
G1 X177.716 Y168.991 F60000
G1 F1207
M204 S8000
G1 X172.341 Y168.991 E.17282
G1 X172.341 Y151.009 E.57823
G1 X177.716 Y151.009 E.17282
G1 X177.716 Y168.931 E.5763
; COOLING_NODE: 0
M204 S10000
G1 X178.123 Y169.398 F60000
M73 P58 R10
G1 F1207
M204 S8000
G1 X171.934 Y169.398 E.199
G1 X171.934 Y150.602 E.60441
G1 X178.123 Y150.602 E.199
G1 X178.123 Y169.338 E.60248
; COOLING_NODE: 0
M204 S250
G1 X178.515 Y169.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1207
M204 S5000
G1 X171.542 Y169.79 E.20769
G1 X171.542 Y150.21 E.58322
G1 X178.515 Y150.21 E.20769
G1 X178.515 Y169.73 E.58143
;======== H2D 20260731========
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
G1 X176.515 Y169.747 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X173.676 Y168.236 Z9.8 F60000
G1 Z9.4
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F1207
M204 S8000
G1 X173.097 Y168.236 E.01863
G1 X173.097 Y167.186 E.03373
G2 X174.345 Y166.157 I-1.724 J-3.361 E.05243
G3 X175.655 Y165.89 I.961 J1.363 E.04425
G3 X176.961 Y166.942 I-1.586 J3.304 E.05439
G1 X176.961 Y164.591 E.07559
G3 X175.655 Y163.536 I1.602 J-3.318 E.05444
G2 X174.345 Y163.269 I-.961 J1.363 E.04425
G2 X173.097 Y164.266 I1.505 J3.164 E.05182
G1 X173.097 Y161.945 E.07463
G2 X174.345 Y160.916 I-1.724 J-3.361 E.05243
G3 X175.655 Y160.648 I.961 J1.363 E.04425
G3 X176.961 Y161.7 I-1.586 J3.303 E.05439
G1 X176.961 Y159.35 E.07559
G3 X175.655 Y158.295 I1.601 J-3.317 E.05444
G2 X174.345 Y158.028 I-.961 J1.363 E.04425
G2 X173.097 Y159.025 I1.505 J3.164 E.05182
G1 X173.097 Y156.704 E.07462
G2 X174.345 Y155.674 I-1.724 J-3.361 E.05243
G3 X175.655 Y155.407 I.961 J1.363 E.04425
G3 X176.961 Y156.459 I-1.586 J3.304 E.05439
G1 X176.961 Y154.108 E.07559
G3 X175.655 Y153.054 I1.601 J-3.317 E.05444
G2 X174.345 Y152.786 I-.961 J1.363 E.04425
G2 X173.097 Y153.783 I1.505 J3.164 E.05182
G1 X173.097 Y152.155 E.05236
; CHANGE_LAYER
; Z_HEIGHT: 9.6
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F8843.478
G1 X173.097 Y153.783 E-.61876
G1 X173.369 Y153.531 E-.14124
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 48/100
; update layer progress
M73 L48
M991 S0 P47 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z9.8 I-1.177 J.308 P1  F60000
G1 X177.309 Y168.584 Z9.8
G1 Z9.6
G1 E.8 F1800
; FEATURE: Inner wall
G1 F1208
M204 S8000
G1 X172.75 Y168.584 E.1466
G1 X172.75 Y151.416 E.55205
G1 X177.309 Y151.416 E.1466
G1 X177.309 Y168.524 E.55012
; COOLING_NODE: 0
M204 S10000
G1 X177.716 Y168.991 F60000
G1 F1208
M204 S8000
G1 X172.343 Y168.991 E.17278
G1 X172.343 Y151.009 E.57823
G1 X177.716 Y151.009 E.17278
G1 X177.716 Y168.931 E.5763
; COOLING_NODE: 0
M204 S10000
G1 X178.123 Y169.398 F60000
G1 F1208
M204 S8000
G1 X171.936 Y169.398 E.19896
G1 X171.936 Y150.602 E.60441
G1 X178.123 Y150.602 E.19896
G1 X178.123 Y169.338 E.60248
; COOLING_NODE: 0
M204 S250
G1 X178.515 Y169.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1208
M204 S5000
G1 X171.544 Y169.79 E.20766
M73 P59 R10
G1 X171.544 Y150.21 E.58322
G1 X178.515 Y150.21 E.20766
G1 X178.515 Y169.73 E.58143
;======== H2D 20260731========
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
G1 X176.515 Y169.747 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X173.859 Y168.236 Z10 F60000
G1 Z9.6
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F1208
M204 S8000
G1 X173.098 Y168.236 E.02449
G1 X173.098 Y167.369 E.02787
G2 X173.69 Y167.051 I-.028 J-.761 E.02237
G1 X174.345 Y166.245 E.03338
G3 X175.655 Y165.721 I1.319 J1.398 E.04647
G1 X175.983 Y165.793 E.01078
G3 X176.961 Y166.852 I-1.923 J2.756 E.04672
G1 X176.961 Y164.761 E.06725
G3 X176.31 Y164.43 I.012 J-.827 E.02429
G1 X175.655 Y163.625 E.03338
G2 X174.345 Y163.1 I-1.319 J1.398 E.04647
G1 X174.017 Y163.172 E.01078
G2 X173.098 Y164.16 I1.789 J2.587 E.04373
G1 X173.098 Y162.127 E.06535
G2 X173.69 Y161.809 I-.028 J-.761 E.02237
G1 X174.345 Y161.004 E.03338
G3 X175.655 Y160.48 I1.319 J1.398 E.04647
G1 X175.983 Y160.551 E.01078
G3 X176.961 Y161.611 I-1.923 J2.756 E.04672
G1 X176.961 Y159.52 E.06725
G3 X176.31 Y159.189 I.012 J-.827 E.02429
G1 X175.655 Y158.383 E.03338
G2 X174.345 Y157.859 I-1.319 J1.398 E.04647
G1 X174.017 Y157.931 E.01078
G2 X173.098 Y158.918 I1.789 J2.587 E.04373
G1 X173.098 Y156.886 E.06535
G2 X173.69 Y156.568 I-.028 J-.761 E.02237
G1 X174.345 Y155.763 E.03338
G3 X175.655 Y155.238 I1.319 J1.398 E.04647
G1 X175.983 Y155.31 E.01078
G3 X176.961 Y156.369 I-1.923 J2.756 E.04672
G1 X176.961 Y154.278 E.06725
G3 X176.31 Y153.947 I.012 J-.827 E.02429
G1 X175.655 Y153.142 E.03338
G2 X174.345 Y152.618 I-1.319 J1.398 E.04647
G1 X174.017 Y152.689 E.01078
G2 X173.098 Y153.677 I1.789 J2.587 E.04373
G1 X173.098 Y152.049 E.05236
; CHANGE_LAYER
; Z_HEIGHT: 9.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F8843.478
G1 X173.098 Y153.677 E-.61876
G1 X173.333 Y153.389 E-.14124
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 49/100
; update layer progress
M73 L49
M991 S0 P48 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z10 I-1.177 J.308 P1  F60000
G1 X177.309 Y168.584 Z10
G1 Z9.8
G1 E.8 F1800
; FEATURE: Inner wall
G1 F1244
M204 S8000
G1 X172.751 Y168.584 E.14656
G1 X172.751 Y151.416 E.55205
G1 X177.309 Y151.416 E.14656
G1 X177.309 Y168.524 E.55012
; COOLING_NODE: 0
M204 S10000
G1 X177.716 Y168.991 F60000
G1 F1244
M204 S8000
G1 X172.344 Y168.991 E.17274
G1 X172.344 Y151.009 E.57823
G1 X177.716 Y151.009 E.17274
G1 X177.716 Y168.931 E.5763
; COOLING_NODE: 0
M204 S10000
G1 X178.123 Y169.398 F60000
G1 F1244
M204 S8000
G1 X171.937 Y169.398 E.19892
G1 X171.937 Y150.602 E.60441
G1 X178.123 Y150.602 E.19892
G1 X178.123 Y169.338 E.60248
; COOLING_NODE: 0
M204 S250
G1 X178.515 Y169.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1211
M204 S5000
G1 X171.545 Y169.79 E.20762
G1 X171.545 Y150.21 E.58322
G1 X178.515 Y150.21 E.20762
G1 X178.515 Y169.73 E.58143
;======== H2D 20260731========
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
G1 X176.515 Y169.747 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X176.26 Y168.236 Z10.2 F60000
G1 Z9.8
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F1244
M204 S8000
M73 P60 R10
G1 X174.631 Y168.236 E.05236
G2 X173.69 Y168.162 I-.539 J.825 E.03167
G1 X173.645 Y168.236 E.00278
G1 X173.099 Y168.236 E.01755
G1 X173.099 Y167.622 E.01973
G2 X173.69 Y167.563 I.25 J-.483 E.02019
G1 X174.017 Y166.877 E.02443
G3 X175.655 Y165.496 I2.478 J1.279 E.0707
G3 X176.31 Y165.541 I.294 J.525 E.02234
G2 X176.961 Y166.772 I7.263 J-3.049 E.04482
G1 X176.961 Y164.988 E.05737
G3 X176.31 Y164.942 I-.29 J-.522 E.02217
G1 X175.983 Y164.256 E.02443
G2 X174.345 Y162.876 I-2.478 J1.278 E.0707
G2 X173.69 Y162.92 I-.294 J.525 E.02234
G3 X173.099 Y164.05 I-6.665 J-2.763 E.04106
G1 X173.099 Y162.381 E.05369
G2 X173.69 Y162.321 I.25 J-.483 E.02019
G1 X174.017 Y161.636 E.02444
G3 X175.655 Y160.255 I2.478 J1.278 E.0707
G3 X176.31 Y160.3 I.294 J.525 E.02234
G2 X176.961 Y161.53 I7.262 J-3.049 E.04482
G1 X176.961 Y159.746 E.05738
G3 X176.31 Y159.701 I-.29 J-.522 E.02217
G1 X175.983 Y159.015 E.02444
G2 X174.345 Y157.635 I-2.478 J1.278 E.0707
G2 X173.69 Y157.679 I-.294 J.525 E.02234
G3 X173.099 Y158.809 I-6.665 J-2.763 E.04106
G1 X173.099 Y157.139 E.05369
G2 X173.69 Y157.08 I.25 J-.483 E.02019
G1 X174.017 Y156.394 E.02443
G3 X175.655 Y155.014 I2.478 J1.279 E.0707
G3 X176.31 Y155.058 I.294 J.525 E.02234
G2 X176.961 Y156.289 I7.263 J-3.049 E.04482
G1 X176.961 Y154.505 E.05737
G3 X176.31 Y154.459 I-.29 J-.522 E.02217
G1 X175.983 Y153.774 E.02443
G2 X174.345 Y152.393 I-2.478 J1.278 E.0707
G2 X173.69 Y152.438 I-.294 J.525 E.02234
G3 X173.099 Y153.568 I-6.665 J-2.763 E.04106
G1 X173.099 Y151.898 E.05369
G2 X173.69 Y151.839 I.25 J-.483 E.02019
G1 X173.725 Y151.764 E.00265
G1 X175.354 Y151.764 E.05236
; CHANGE_LAYER
; Z_HEIGHT: 10
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F8843.478
G1 X173.725 Y151.764 E-.61876
G1 X173.69 Y151.839 E-.03128
G1 X173.418 Y151.938 E-.10996
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 50/100
; update layer progress
M73 L50
M991 S0 P49 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z10.2 I-1.185 J.277 P1  F60000
G1 X177.309 Y168.584 Z10.2
G1 Z10
G1 E.8 F1800
; FEATURE: Inner wall
G1 F1259
M204 S8000
G1 X172.752 Y168.584 E.14652
G1 X172.752 Y151.416 E.55205
G1 X177.309 Y151.416 E.14652
G1 X177.309 Y168.524 E.55012
; COOLING_NODE: 0
M204 S10000
G1 X177.716 Y168.991 F60000
G1 F1259
M204 S8000
G1 X172.345 Y168.991 E.1727
G1 X172.345 Y151.009 E.57823
G1 X177.716 Y151.009 E.1727
G1 X177.716 Y168.931 E.5763
; COOLING_NODE: 0
M204 S10000
G1 X178.123 Y169.398 F60000
G1 F1259
M204 S8000
G1 X171.938 Y169.398 E.19888
G1 X171.938 Y150.602 E.60441
G1 X178.123 Y150.602 E.19888
G1 X178.123 Y169.338 E.60248
; COOLING_NODE: 0
M204 S250
G1 X178.515 Y169.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1208
M204 S5000
G1 X171.546 Y169.79 E.20758
G1 X171.546 Y150.21 E.58322
G1 X178.515 Y150.21 E.20758
G1 X178.515 Y169.73 E.58143
;======== H2D 20260731========
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
G1 X176.515 Y169.747 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X173.1 Y165.571 Z10.4 F60000
G1 Z10
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F1259
M204 S8000
G1 X173.1 Y163.943 E.05236
G1 X173.265 Y163.276 E.02208
G2 X173.1 Y162.789 I-.511 J-.099 E.0173
G1 X173.1 Y158.701 E.13143
G1 X173.265 Y158.035 E.02208
G2 X173.1 Y157.547 I-.511 J-.099 E.0173
G1 X173.1 Y153.46 E.13143
G1 X173.265 Y152.793 E.02208
G2 X173.1 Y152.306 I-.511 J-.099 E.0173
G1 X173.1 Y151.764 E.01742
G1 X174.152 Y151.764 E.03381
G1 X174.406 Y152.138 E.01454
G1 X175.284 Y152.793 E.03522
G3 X175.842 Y154.431 I-1.479 J1.418 E.05744
G1 X175.594 Y154.759 E.01322
G1 X174.716 Y155.414 E.03522
G2 X174.158 Y157.052 I1.479 J1.418 E.05744
G1 X174.406 Y157.379 E.01322
G1 X175.284 Y158.035 E.03522
G3 X175.842 Y159.673 I-1.479 J1.418 E.05744
G1 X175.594 Y160 E.01322
G1 X174.716 Y160.655 E.03522
G2 X174.158 Y162.293 I1.479 J1.418 E.05744
G1 X174.406 Y162.621 E.01322
G1 X175.284 Y163.276 E.03522
G3 X175.842 Y164.914 I-1.479 J1.418 E.05744
G1 X175.594 Y165.241 E.01322
G1 X174.716 Y165.897 E.03522
G2 X174.158 Y167.535 I1.479 J1.418 E.05744
G2 X174.907 Y168.236 I1.591 J-.949 E.03342
G1 X176.961 Y168.236 E.06604
G1 X176.961 Y166.672 E.05028
G3 X176.779 Y165.569 I1.946 J-.888 E.03637
G1 X176.961 Y165.329 E.00968
G1 X176.961 Y161.431 E.12536
G3 X176.779 Y160.328 I1.946 J-.888 E.03637
G1 X176.961 Y160.088 E.00968
G1 X176.961 Y156.189 E.12536
G3 X176.779 Y155.086 I1.946 J-.888 E.03637
G1 X176.961 Y154.846 E.00968
G1 X176.961 Y153.218 E.05236
; CHANGE_LAYER
; Z_HEIGHT: 10.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F8843.478
G1 X176.961 Y154.846 E-.61876
G1 X176.779 Y155.086 E-.11443
G1 X176.769 Y155.156 E-.02681
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 51/100
; update layer progress
M73 L51
M991 S0 P50 ;notify layer change

M106 S229.5
; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z10.4 I-1.216 J.049 P1  F60000
G1 X177.309 Y168.584 Z10.4
G1 Z10.2
G1 E.8 F1800
; FEATURE: Inner wall
G1 F1200
M204 S8000
G1 X172.753 Y168.584 E.14649
G1 X172.753 Y151.416 E.55205
G1 X177.309 Y151.416 E.14649
G1 X177.309 Y168.524 E.55012
; COOLING_NODE: 0
M204 S10000
G1 X177.716 Y168.991 F60000
M73 P61 R10
G1 F1200
M204 S8000
G1 X172.346 Y168.991 E.17267
G1 X172.346 Y151.009 E.57823
G1 X177.716 Y151.009 E.17267
G1 X177.716 Y168.931 E.5763
; COOLING_NODE: 0
M204 S10000
G1 X178.123 Y169.398 F60000
G1 F1200
M204 S8000
G1 X171.939 Y169.398 E.19885
G1 X171.939 Y150.602 E.60441
G1 X178.123 Y150.602 E.19885
G1 X178.123 Y169.338 E.60248
; COOLING_NODE: 0
M204 S250
G1 X178.515 Y169.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X171.547 Y169.79 E.20755
M73 P61 R9
G1 X171.547 Y150.21 E.58322
G1 X178.515 Y150.21 E.20755
G1 X178.515 Y169.73 E.58143
;======== H2D 20260731========
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
G1 X176.515 Y169.747 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X176.727 Y162.118 Z10.6 F60000
G1 X176.961 Y153.672 Z10.6
G1 Z10.2
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X176.961 Y155.301 E.05236
G1 X176.917 Y155.414 E.00391
G1 X176.961 Y156.11 E.02243
G1 X176.961 Y160.542 E.14251
G1 X176.917 Y160.655 E.00391
G1 X176.961 Y168.236 E.24376
G1 X175.081 Y168.236 E.06043
G3 X174.296 Y167.207 I1.437 J-1.911 E.04214
G3 X174.631 Y165.897 I1.696 J-.265 E.0447
G2 X175.577 Y164.914 I-4.695 J-5.468 E.04394
G1 X175.704 Y164.586 E.0113
G2 X175.369 Y163.276 I-1.696 J-.265 E.0447
G3 X174.423 Y162.293 I4.695 J-5.468 E.04394
G1 X174.296 Y161.966 E.0113
G3 X174.631 Y160.655 I1.696 J-.265 E.0447
G2 X175.577 Y159.673 I-4.695 J-5.469 E.04394
G1 X175.704 Y159.345 E.0113
G2 X175.369 Y158.035 I-1.696 J-.265 E.0447
G3 X174.423 Y157.052 I4.695 J-5.469 E.04394
G1 X174.296 Y156.724 E.0113
G3 X174.631 Y155.414 I1.696 J-.265 E.0447
G2 X175.577 Y154.431 I-4.695 J-5.468 E.04394
G1 X175.704 Y154.104 E.0113
G2 X175.369 Y152.793 I-1.696 J-.265 E.0447
G3 X174.405 Y151.764 I3.202 J-3.967 E.04549
G1 X173.102 Y151.764 E.04191
G1 X173.102 Y152.089 E.01045
; CHANGE_LAYER
; Z_HEIGHT: 10.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F8843.478
G1 X173.102 Y151.764 E-.12348
G1 X174.405 Y151.764 E-.49528
G1 X174.635 Y152.056 E-.14124
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 52/100
; update layer progress
M73 L52
M991 S0 P51 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z10.6 I-1.201 J.194 P1  F60000
G1 X177.309 Y168.584 Z10.6
G1 Z10.4
G1 E.8 F1800
; FEATURE: Inner wall
G1 F1200
M204 S8000
G1 X172.755 Y168.584 E.14645
G1 X172.755 Y151.416 E.55205
G1 X177.309 Y151.416 E.14645
G1 X177.309 Y168.524 E.55012
; COOLING_NODE: 0
M204 S10000
G1 X177.716 Y168.991 F60000
G1 F1200
M204 S8000
G1 X172.348 Y168.991 E.17263
G1 X172.348 Y151.009 E.57823
G1 X177.716 Y151.009 E.17263
G1 X177.716 Y168.931 E.5763
; COOLING_NODE: 0
M204 S10000
G1 X178.123 Y169.398 F60000
G1 F1200
M204 S8000
G1 X171.94 Y169.398 E.19881
M73 P62 R9
G1 X171.94 Y150.602 E.60441
G1 X178.123 Y150.602 E.19881
G1 X178.123 Y169.338 E.60248
; COOLING_NODE: 0
M204 S250
G1 X178.515 Y169.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X171.548 Y169.79 E.20751
G1 X171.548 Y150.21 E.58322
G1 X178.515 Y150.21 E.20751
G1 X178.515 Y169.73 E.58143
;======== H2D 20260731========
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
G1 X176.515 Y169.747 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X176.859 Y168.236 Z10.8 F60000
G1 Z10.4
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X175.231 Y168.236 E.05236
G3 X174.437 Y167.207 I7.333 J-6.481 E.04181
G3 X175.083 Y165.241 I1.822 J-.49 E.07042
G1 X175.563 Y164.586 E.02612
G2 X174.917 Y162.621 I-1.822 J-.49 E.07042
G1 X174.437 Y161.966 E.02612
G3 X175.083 Y160 I1.822 J-.49 E.07042
G1 X175.563 Y159.345 E.02612
G2 X174.917 Y157.379 I-1.822 J-.49 E.07042
G1 X174.437 Y156.724 E.02612
G3 X175.083 Y154.759 I1.822 J-.49 E.07042
G1 X175.563 Y154.104 E.02612
G2 X174.917 Y152.138 I-1.822 J-.49 E.07042
G1 X174.643 Y151.764 E.0149
G1 X173.103 Y151.764 E.04953
G1 X173.103 Y151.853 E.00283
; CHANGE_LAYER
; Z_HEIGHT: 10.6
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F8843.478
G1 X173.103 Y151.764 E-.03345
G1 X174.643 Y151.764 E-.58531
G1 X174.863 Y152.064 E-.14124
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 53/100
; update layer progress
M73 L53
M991 S0 P52 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z10.8 I-1.204 J.178 P1  F60000
G1 X177.309 Y168.584 Z10.8
G1 Z10.6
G1 E.8 F1800
; FEATURE: Inner wall
G1 F1200
M204 S8000
G1 X172.756 Y168.584 E.14641
G1 X172.756 Y151.416 E.55205
G1 X177.309 Y151.416 E.14641
G1 X177.309 Y168.524 E.55012
; COOLING_NODE: 0
M204 S10000
G1 X177.716 Y168.991 F60000
G1 F1200
M204 S8000
G1 X172.349 Y168.991 E.17259
G1 X172.349 Y151.009 E.57823
G1 X177.716 Y151.009 E.17259
G1 X177.716 Y168.931 E.5763
; COOLING_NODE: 0
M204 S10000
G1 X178.123 Y169.398 F60000
G1 F1200
M204 S8000
G1 X171.942 Y169.398 E.19877
G1 X171.942 Y150.602 E.60441
G1 X178.123 Y150.602 E.19877
G1 X178.123 Y169.338 E.60248
; COOLING_NODE: 0
M204 S250
G1 X178.515 Y169.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X171.55 Y169.79 E.20747
G1 X171.55 Y150.21 E.58322
G1 X178.515 Y150.21 E.20747
G1 X178.515 Y169.73 E.58143
;======== H2D 20260731========
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
M73 P63 R9
G1 X176.515 Y169.747 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X176.961 Y168.183 Z11 F60000
G1 Z10.6
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X176.961 Y168.236 E.00169
G1 X175.385 Y168.236 E.05067
G1 X175.119 Y167.862 E.01475
G3 X174.415 Y165.897 I1.186 J-1.533 E.07089
G1 X174.881 Y165.241 E.02587
G2 X175.585 Y163.276 I-1.186 J-1.533 E.07089
G1 X175.119 Y162.621 E.02587
G3 X174.415 Y160.655 I1.186 J-1.533 E.07089
G1 X174.881 Y160 E.02587
G2 X175.585 Y158.035 I-1.186 J-1.533 E.07089
G1 X175.119 Y157.379 E.02587
G3 X174.415 Y155.414 I1.186 J-1.533 E.07089
G1 X174.881 Y154.759 E.02587
G2 X175.585 Y152.793 I-1.186 J-1.533 E.07089
G2 X174.795 Y151.764 I-5.794 J3.635 E.04179
G1 X173.166 Y151.764 E.05236
; CHANGE_LAYER
; Z_HEIGHT: 10.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F8843.478
G1 X174.795 Y151.764 E-.61876
G1 X175.021 Y152.059 E-.14124
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 54/100
; update layer progress
M73 L54
M991 S0 P53 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z11 I-1.205 J.167 P1  F60000
G1 X177.309 Y168.584 Z11
G1 Z10.8
G1 E.8 F1800
; FEATURE: Inner wall
G1 F1200
M204 S8000
G1 X172.757 Y168.584 E.14637
G1 X172.757 Y151.416 E.55205
G1 X177.309 Y151.416 E.14637
G1 X177.309 Y168.524 E.55012
; COOLING_NODE: 0
M204 S10000
G1 X177.716 Y168.991 F60000
G1 F1200
M204 S8000
G1 X172.35 Y168.991 E.17255
G1 X172.35 Y151.009 E.57823
G1 X177.716 Y151.009 E.17255
G1 X177.716 Y168.931 E.5763
; COOLING_NODE: 0
M204 S10000
G1 X178.123 Y169.398 F60000
G1 F1200
M204 S8000
G1 X171.943 Y169.398 E.19873
G1 X171.943 Y150.602 E.60441
G1 X178.123 Y150.602 E.19873
G1 X178.123 Y169.338 E.60248
; COOLING_NODE: 0
M204 S250
G1 X178.515 Y169.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X171.551 Y169.79 E.20744
G1 X171.551 Y150.21 E.58322
G1 X178.515 Y150.21 E.20744
G1 X178.515 Y169.73 E.58143
;======== H2D 20260731========
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
G1 X176.515 Y169.747 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X176.736 Y162.118 Z11.2 F60000
G1 X176.961 Y154.39 Z11.2
G1 Z10.8
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X176.961 Y156.018 E.05236
G1 X176.888 Y156.724 E.02283
G1 X176.961 Y156.929 E.00698
G1 X176.961 Y161.259 E.13924
G1 X176.888 Y161.966 E.02283
G1 X176.961 Y162.17 E.00698
G1 X176.961 Y166.501 E.13924
G1 X176.888 Y167.207 E.02283
G1 X176.961 Y167.412 E.00698
G1 X176.961 Y168.236 E.02649
G1 X175.633 Y168.236 E.04268
G2 X174.646 Y167.207 I-3.603 J2.469 E.04604
G3 X174.383 Y165.569 I1.415 J-1.068 E.05551
G3 X175.354 Y164.586 I4.554 J3.527 E.04452
G2 X175.617 Y162.948 I-1.415 J-1.068 E.05551
G2 X174.646 Y161.966 I-4.555 J3.528 E.04452
G3 X174.383 Y160.328 I1.415 J-1.068 E.05551
G3 X175.354 Y159.345 I4.554 J3.527 E.04452
G2 X175.617 Y157.707 I-1.415 J-1.068 E.05551
G2 X174.646 Y156.724 I-4.554 J3.527 E.04452
G3 X174.383 Y155.086 I1.415 J-1.068 E.05551
G3 X175.354 Y154.104 I4.554 J3.527 E.04452
G2 X175.617 Y152.466 I-1.415 J-1.068 E.05551
G2 X174.946 Y151.764 I-3.24 J2.429 E.03129
G1 X173.318 Y151.764 E.05236
; CHANGE_LAYER
; Z_HEIGHT: 11
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F8843.478
G1 X174.946 Y151.764 E-.61876
G1 X175.203 Y152.033 E-.14124
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 55/100
; update layer progress
M73 L55
M991 S0 P54 ;notify layer change

M106 S226.95
; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z11.2 I-1.207 J.154 P1  F60000
G1 X177.309 Y168.584 Z11.2
G1 Z11
G1 E.8 F1800
; FEATURE: Inner wall
G1 F1279
M204 S8000
G1 X172.758 Y168.584 E.14633
G1 X172.758 Y151.416 E.55205
G1 X177.309 Y151.416 E.14633
G1 X177.309 Y168.524 E.55012
; COOLING_NODE: 0
M204 S10000
G1 X177.716 Y168.991 F60000
M73 P64 R9
G1 F1279
M204 S8000
G1 X172.351 Y168.991 E.17251
G1 X172.351 Y151.009 E.57823
G1 X177.716 Y151.009 E.17251
G1 X177.716 Y168.931 E.5763
; COOLING_NODE: 0
M204 S10000
G1 X178.123 Y169.398 F60000
G1 F1279
M204 S8000
G1 X171.944 Y169.398 E.19869
G1 X171.944 Y150.602 E.60441
G1 X178.123 Y150.602 E.19869
G1 X178.123 Y169.338 E.60248
; COOLING_NODE: 0
M204 S250
G1 X178.515 Y169.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1209
M204 S5000
G1 X171.552 Y169.79 E.2074
G1 X171.552 Y150.21 E.58322
G1 X178.515 Y150.21 E.2074
G1 X178.515 Y169.73 E.58143
;======== H2D 20260731========
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
G1 X176.515 Y169.747 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X173.107 Y166.782 Z11.4 F60000
G1 Z11
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F1279
M204 S8000
G1 X173.107 Y165.154 E.05236
G2 X173.302 Y164.586 I-.357 J-.441 E.02034
G1 X173.107 Y163.913 E.02256
G1 X173.107 Y159.912 E.12863
G2 X173.302 Y159.345 I-.357 J-.441 E.02034
G1 X173.107 Y158.671 E.02256
G1 X173.107 Y154.671 E.12863
G2 X173.302 Y154.104 I-.357 J-.441 E.02034
G1 X173.107 Y153.43 E.02256
G1 X173.107 Y151.802 E.05236
; WIPE_START
G1 F8843.478
G1 X173.107 Y153.43 E-.61876
G1 X173.21 Y153.787 E-.14124
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X176.961 Y153.774 Z11.4 F60000
G1 Z11
G1 E.8 F1800
G1 F1279
M204 S8000
G1 X176.961 Y152.146 E.05236
G2 X176.72 Y151.811 I-1.016 J.475 E.01333
G1 X176.717 Y151.764 E.00149
G1 X175.131 Y151.764 E.051
G3 X175.901 Y152.466 I-.629 J1.463 E.03411
G3 X175.271 Y154.104 I-2.177 J.103 E.05808
G1 X174.336 Y154.759 E.03669
G1 X174.1 Y155.086 E.013
G2 X174.73 Y156.724 I2.177 J.103 E.05808
G1 X175.664 Y157.379 E.03669
G1 X175.901 Y157.707 E.013
G3 X175.271 Y159.345 I-2.177 J.103 E.05808
G1 X174.336 Y160 E.03669
G1 X174.1 Y160.328 E.013
G2 X174.73 Y161.966 I2.177 J.103 E.05808
G1 X175.664 Y162.621 E.03669
G1 X175.901 Y162.948 E.013
G3 X175.271 Y164.586 I-2.177 J.103 E.05808
G1 X174.336 Y165.241 E.03669
G1 X174.1 Y165.569 E.013
G2 X174.73 Y167.207 I2.177 J.103 E.05808
G1 X175.664 Y167.862 E.03669
G1 X175.904 Y168.236 E.01428
G1 X176.961 Y168.236 E.03398
G2 X176.72 Y167.535 I-.612 J-.182 E.02543
G3 X176.961 Y166.415 I2.313 J-.088 E.03719
G1 X176.961 Y162.628 E.12178
G2 X176.72 Y162.293 I-1.016 J.475 E.01333
G3 X176.961 Y161.174 I2.313 J-.088 E.03719
G1 X176.961 Y157.387 E.12178
G2 X176.72 Y157.052 I-1.016 J.475 E.01333
G3 X176.961 Y155.933 I2.313 J-.088 E.03719
G1 X176.961 Y154.305 E.05236
; CHANGE_LAYER
; Z_HEIGHT: 11.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F8843.478
G1 X176.961 Y155.933 E-.61876
G1 X176.843 Y156.286 E-.14125
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 56/100
; update layer progress
M73 L56
M991 S0 P55 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z11.4 I-1.216 J.046 P1  F60000
G1 X177.309 Y168.584 Z11.4
G1 Z11.2
G1 E.8 F1800
; FEATURE: Inner wall
G1 F1237
M204 S8000
G1 X172.76 Y168.584 E.14629
G1 X172.76 Y151.416 E.55205
G1 X177.309 Y151.416 E.14629
G1 X177.309 Y168.524 E.55012
; COOLING_NODE: 0
M204 S10000
G1 X177.716 Y168.991 F60000
G1 F1237
M204 S8000
G1 X172.352 Y168.991 E.17247
G1 X172.352 Y151.009 E.57823
G1 X177.716 Y151.009 E.17247
G1 X177.716 Y168.931 E.5763
; COOLING_NODE: 0
M204 S10000
G1 X178.123 Y169.398 F60000
G1 F1237
M204 S8000
M73 P65 R9
G1 X171.945 Y169.398 E.19865
G1 X171.945 Y150.602 E.60441
G1 X178.123 Y150.602 E.19865
G1 X178.123 Y169.338 E.60248
; COOLING_NODE: 0
M204 S250
G1 X178.515 Y169.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1207
M204 S5000
G1 X171.553 Y169.79 E.20736
G1 X171.553 Y150.21 E.58322
G1 X178.515 Y150.21 E.20736
G1 X178.515 Y169.73 E.58143
;======== H2D 20260731========
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
M73 P65 R8
G1 F9547.055
M204 S8000
G1 X176.515 Y169.747 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X174.81 Y168.236 Z11.6 F60000
G1 Z11.2
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F1237
M204 S8000
G1 X176.438 Y168.236 E.05236
G3 X176.961 Y168.161 I.313 J.324 E.01812
G1 X176.961 Y166.319 E.05923
G1 X176.31 Y167.417 E.04104
G1 X175.983 Y167.6 E.01207
G3 X174.345 Y166.793 I.3 J-2.674 E.05991
G1 X173.69 Y165.687 E.04135
G2 X173.108 Y165.532 I-.398 J.326 E.02068
G1 X173.108 Y163.813 E.05527
G1 X173.69 Y164.796 E.03673
G1 X174.017 Y164.98 E.01207
G2 X175.655 Y164.173 I-.3 J-2.674 E.05991
G1 X176.31 Y163.066 E.04135
G3 X176.961 Y162.919 I.427 J.377 E.02289
G1 X176.961 Y161.077 E.05923
G1 X176.31 Y162.176 E.04104
G1 X175.983 Y162.359 E.01207
G3 X174.345 Y161.552 I.3 J-2.674 E.05991
G1 X173.69 Y160.445 E.04135
G2 X173.108 Y160.291 I-.398 J.326 E.02068
G1 X173.108 Y158.572 E.05527
G1 X173.69 Y159.555 E.03673
G1 X174.017 Y159.738 E.01207
G2 X175.655 Y158.931 I-.3 J-2.674 E.05991
G1 X176.31 Y157.825 E.04135
G3 X176.961 Y157.678 I.427 J.377 E.02289
G1 X176.961 Y155.836 E.05923
G1 X176.31 Y156.934 E.04104
G1 X175.983 Y157.118 E.01207
G3 X174.345 Y156.311 I.3 J-2.674 E.05991
G1 X173.69 Y155.204 E.04135
G2 X173.108 Y155.05 I-.398 J.326 E.02068
G1 X173.108 Y153.331 E.05527
G1 X173.69 Y154.314 E.03673
G1 X174.017 Y154.497 E.01207
G2 X175.655 Y153.69 I-.3 J-2.674 E.05991
G1 X176.31 Y152.583 E.04135
G3 X176.961 Y152.437 I.427 J.377 E.02289
G1 X176.961 Y151.764 E.02162
G1 X176.183 Y151.764 E.02501
G3 X175.453 Y151.764 I-.365 J-.666 E.02446
G1 X173.825 Y151.764 E.05236
; CHANGE_LAYER
; Z_HEIGHT: 11.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F8843.478
G1 X175.453 Y151.764 E-.61876
G1 X175.817 Y151.841 E-.14124
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 57/100
; update layer progress
M73 L57
M991 S0 P56 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z11.6 I-1.212 J.108 P1  F60000
G1 X177.309 Y168.584 Z11.6
G1 Z11.4
G1 E.8 F1800
; FEATURE: Inner wall
G1 F1206
M204 S8000
G1 X172.761 Y168.584 E.14625
G1 X172.761 Y151.416 E.55205
G1 X177.309 Y151.416 E.14625
G1 X177.309 Y168.524 E.55012
; COOLING_NODE: 0
M204 S10000
G1 X177.716 Y168.991 F60000
G1 F1206
M204 S8000
G1 X172.354 Y168.991 E.17243
G1 X172.354 Y151.009 E.57823
G1 X177.716 Y151.009 E.17243
G1 X177.716 Y168.931 E.5763
; COOLING_NODE: 0
M204 S10000
G1 X178.123 Y169.398 F60000
G1 F1206
M204 S8000
G1 X171.947 Y169.398 E.19861
G1 X171.947 Y150.602 E.60441
G1 X178.123 Y150.602 E.19861
G1 X178.123 Y169.338 E.60248
; COOLING_NODE: 0
M204 S250
G1 X178.515 Y169.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1206
M204 S5000
G1 X171.555 Y169.79 E.20733
M73 P66 R8
G1 X171.555 Y150.21 E.58322
G1 X178.515 Y150.21 E.20733
G1 X178.515 Y169.73 E.58143
;======== H2D 20260731========
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
G1 X176.515 Y169.747 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X176.961 Y167.865 Z11.8 F60000
G1 Z11.4
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F1206
M204 S8000
G1 X176.961 Y166.237 E.05236
G3 X175.983 Y167.263 I-3.27 J-2.136 E.04584
G3 X174.345 Y166.873 I-.437 J-1.799 E.05621
G1 X173.69 Y166.106 E.03243
G2 X173.109 Y165.773 I-.66 J.48 E.02217
G1 X173.109 Y163.697 E.06676
G2 X174.017 Y164.642 I3.015 J-1.989 E.04239
G2 X175.655 Y164.252 I.437 J-1.799 E.05621
G1 X176.31 Y163.485 E.03243
G3 X176.961 Y163.134 I.716 J.548 E.02448
G1 X176.961 Y160.995 E.06878
G3 X175.983 Y162.022 I-3.27 J-2.136 E.04584
G3 X174.345 Y161.631 I-.437 J-1.799 E.05621
G1 X173.69 Y160.865 E.03243
G2 X173.109 Y160.532 I-.66 J.48 E.02217
G1 X173.109 Y158.456 E.06676
G2 X174.017 Y159.401 I3.015 J-1.988 E.04239
G2 X175.655 Y159.011 I.437 J-1.799 E.05621
G1 X176.31 Y158.244 E.03243
G3 X176.961 Y157.893 I.716 J.548 E.02448
G1 X176.961 Y155.754 E.06878
G3 X175.983 Y156.78 I-3.27 J-2.136 E.04584
G3 X174.345 Y156.39 I-.437 J-1.799 E.05621
G1 X173.69 Y155.623 E.03243
G2 X173.109 Y155.291 I-.66 J.48 E.02217
G1 X173.109 Y153.215 E.06676
G2 X174.017 Y154.16 I3.015 J-1.988 E.04239
G2 X175.655 Y153.769 I.437 J-1.799 E.05621
G1 X176.31 Y153.003 E.03243
G3 X176.961 Y152.652 I.716 J.548 E.02448
G1 X176.961 Y151.764 E.02853
G1 X176.219 Y151.764 E.02383
; CHANGE_LAYER
; Z_HEIGHT: 11.6
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F8843.478
G1 X176.961 Y151.764 E-.28161
G1 X176.961 Y152.652 E-.33715
G1 X176.638 Y152.737 E-.12681
G1 X176.608 Y152.761 E-.01444
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 58/100
; update layer progress
M73 L58
M991 S0 P57 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z11.8 I-1.216 J.054 P1  F60000
G1 X177.309 Y168.584 Z11.8
G1 Z11.6
G1 E.8 F1800
; FEATURE: Inner wall
G1 F1206
M204 S8000
G1 X172.762 Y168.584 E.14621
G1 X172.762 Y151.416 E.55205
G1 X177.309 Y151.416 E.14621
G1 X177.309 Y168.524 E.55012
; COOLING_NODE: 0
M204 S10000
G1 X177.716 Y168.991 F60000
G1 F1206
M204 S8000
G1 X172.355 Y168.991 E.17239
G1 X172.355 Y151.009 E.57823
G1 X177.716 Y151.009 E.17239
G1 X177.716 Y168.931 E.5763
; COOLING_NODE: 0
M204 S10000
G1 X178.123 Y169.398 F60000
G1 F1206
M204 S8000
G1 X171.948 Y169.398 E.19857
G1 X171.948 Y150.602 E.60441
G1 X178.123 Y150.602 E.19857
G1 X178.123 Y169.338 E.60248
; COOLING_NODE: 0
M204 S250
G1 X178.515 Y169.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1206
M204 S5000
G1 X171.556 Y169.79 E.20729
G1 X171.556 Y150.21 E.58322
G1 X178.515 Y150.21 E.20729
G1 X178.515 Y169.73 E.58143
;======== H2D 20260731========
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
G1 X176.515 Y169.747 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X176.961 Y167.773 Z12 F60000
G1 Z11.6
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F1206
M204 S8000
G1 X176.961 Y166.145 E.05236
G3 X175.983 Y167.034 I-13.272 J-13.61 E.04251
G3 X174.345 Y166.963 I-.753 J-1.563 E.05491
G2 X173.11 Y165.951 I-3.361 J2.84 E.05163
G1 X173.11 Y163.59 E.0759
G2 X174.017 Y164.414 I12.289 J-12.625 E.0394
M73 P67 R8
G2 X175.655 Y164.342 I.753 J-1.563 E.05491
G3 X176.961 Y163.297 I3.246 J2.715 E.05414
G1 X176.961 Y160.904 E.07695
G3 X175.983 Y161.793 I-13.275 J-13.613 E.04251
G3 X174.345 Y161.722 I-.753 J-1.563 E.05491
G2 X173.11 Y160.709 I-3.361 J2.84 E.05163
G1 X173.11 Y158.349 E.0759
G2 X174.017 Y159.172 I12.298 J-12.635 E.0394
G2 X175.655 Y159.101 I.753 J-1.562 E.05491
G3 X176.961 Y158.055 I3.246 J2.715 E.05414
G1 X176.961 Y155.662 E.07695
G3 X175.983 Y156.552 I-13.272 J-13.61 E.04251
G3 X174.345 Y156.481 I-.753 J-1.563 E.05491
G2 X173.11 Y155.468 I-3.361 J2.84 E.05163
G1 X173.11 Y153.108 E.0759
G2 X174.017 Y153.931 I12.295 J-12.632 E.0394
G2 X175.655 Y153.86 I.753 J-1.563 E.05491
G3 X176.961 Y152.814 I3.247 J2.715 E.05414
G1 X176.961 Y151.764 E.03375
G1 X176.382 Y151.764 E.01861
; CHANGE_LAYER
; Z_HEIGHT: 11.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F8843.478
G1 X176.961 Y151.764 E-.21993
G1 X176.961 Y152.814 E-.39883
G1 X176.638 Y152.966 E-.13549
G1 X176.627 Y152.976 E-.00575
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 59/100
; update layer progress
M73 L59
M991 S0 P58 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z12 I-1.216 J.053 P1  F60000
G1 X177.309 Y168.584 Z12
G1 Z11.8
G1 E.8 F1800
; FEATURE: Inner wall
G1 F1210
M204 S8000
G1 X172.763 Y168.584 E.14617
G1 X172.763 Y151.416 E.55205
G1 X177.309 Y151.416 E.14617
G1 X177.309 Y168.524 E.55012
; COOLING_NODE: 0
M204 S10000
G1 X177.716 Y168.991 F60000
G1 F1210
M204 S8000
G1 X172.356 Y168.991 E.17235
G1 X172.356 Y151.009 E.57823
G1 X177.716 Y151.009 E.17235
G1 X177.716 Y168.931 E.5763
; COOLING_NODE: 0
M204 S10000
G1 X178.123 Y169.398 F60000
G1 F1210
M204 S8000
G1 X171.949 Y169.398 E.19853
G1 X171.949 Y150.602 E.60441
G1 X178.123 Y150.602 E.19853
G1 X178.123 Y169.338 E.60248
; COOLING_NODE: 0
M204 S250
G1 X178.515 Y169.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1208
M204 S5000
G1 X171.557 Y169.79 E.20725
G1 X171.557 Y150.21 E.58322
G1 X178.515 Y150.21 E.20725
G1 X178.515 Y169.73 E.58143
;======== H2D 20260731========
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
G1 X176.515 Y169.747 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X173.112 Y167.731 Z12.2 F60000
G1 Z11.8
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F1210
M204 S8000
G1 X173.112 Y166.103 E.05236
G1 X173.69 Y166.559 E.02367
G2 X175.655 Y167.061 I1.341 J-1.153 E.06947
G3 X176.961 Y166.038 I91.428 J115.319 E.05333
G1 X176.961 Y163.426 E.08401
G1 X176.31 Y163.938 E.02662
G3 X174.345 Y164.44 I-1.341 J-1.153 E.06947
G2 X173.112 Y163.474 I-86.426 J108.973 E.0504
G1 X173.112 Y160.862 E.08399
G1 X173.69 Y161.318 E.02367
G2 X175.655 Y161.82 I1.341 J-1.153 E.06947
G3 X176.961 Y160.797 I91.123 J114.93 E.05333
G1 X176.961 Y158.184 E.08401
G1 X176.31 Y158.697 E.02662
G3 X174.345 Y159.199 I-1.341 J-1.152 E.06947
G2 X173.112 Y158.232 I-86.426 J108.973 E.0504
G1 X173.112 Y155.62 E.08399
G1 X173.69 Y156.076 E.02367
G2 X175.655 Y156.579 I1.341 J-1.153 E.06947
G3 X176.961 Y155.556 I91.428 J115.319 E.05333
G1 X176.961 Y152.943 E.08401
G1 X176.31 Y153.456 E.02662
G3 X174.345 Y153.958 I-1.341 J-1.153 E.06947
G2 X173.112 Y152.991 I-86.426 J108.973 E.0504
G1 X173.112 Y151.764 E.03944
G1 X173.513 Y151.764 E.01292
; CHANGE_LAYER
; Z_HEIGHT: 12
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F8843.478
G1 X173.112 Y151.764 E-.15271
G1 X173.112 Y152.991 E-.46605
G1 X173.404 Y153.22 E-.14124
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 60/100
; update layer progress
M73 L60
M991 S0 P59 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z12.2 I-1.179 J.3 P1  F60000
G1 X177.309 Y168.584 Z12.2
G1 Z12
G1 E.8 F1800
; FEATURE: Inner wall
G1 F1206
M204 S8000
G1 X172.764 Y168.584 E.14613
G1 X172.764 Y151.416 E.55205
G1 X177.309 Y151.416 E.14613
G1 X177.309 Y168.524 E.55012
; COOLING_NODE: 0
M204 S10000
G1 X177.716 Y168.991 F60000
M73 P68 R8
G1 F1206
M204 S8000
G1 X172.357 Y168.991 E.17231
G1 X172.357 Y151.009 E.57823
G1 X177.716 Y151.009 E.17231
G1 X177.716 Y168.931 E.5763
; COOLING_NODE: 0
M204 S10000
G1 X178.123 Y169.398 F60000
G1 F1206
M204 S8000
G1 X171.95 Y169.398 E.19849
G1 X171.95 Y150.602 E.60441
G1 X178.123 Y150.602 E.19849
G1 X178.123 Y169.338 E.60248
; COOLING_NODE: 0
M204 S250
G1 X178.515 Y169.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1206
M204 S5000
G1 X171.558 Y169.79 E.20722
G1 X171.558 Y150.21 E.58322
G1 X178.515 Y150.21 E.20722
G1 X178.515 Y169.73 E.58143
;======== H2D 20260731========
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
G1 X176.515 Y169.747 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X173.113 Y167.849 Z12.4 F60000
G1 Z12
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F1206
M204 S8000
G1 X173.113 Y166.221 E.05236
G2 X174.017 Y167.049 I9.886 J-9.898 E.03944
G2 X175.655 Y166.956 I.733 J-1.572 E.05495
G3 X176.961 Y165.907 I3.099 J2.519 E.05425
G1 X176.961 Y163.531 E.0764
G3 X175.983 Y164.428 I-10.704 J-10.692 E.04267
G3 X174.345 Y164.336 I-.733 J-1.572 E.05495
G2 X173.113 Y163.32 I-3.207 J2.635 E.05167
G1 X173.113 Y160.98 E.07525
G2 X174.017 Y161.807 I9.884 J-9.896 E.03944
G2 X175.655 Y161.715 I.733 J-1.572 E.05495
G3 X176.961 Y160.666 I3.098 J2.518 E.05425
G1 X176.961 Y158.29 E.0764
G3 X175.983 Y159.187 I-10.706 J-10.694 E.04267
G3 X174.345 Y159.094 I-.733 J-1.572 E.05495
G2 X173.113 Y158.079 I-3.207 J2.635 E.05167
G1 X173.113 Y155.738 E.07525
G2 X174.017 Y156.566 I9.886 J-9.898 E.03944
G2 X175.655 Y156.474 I.733 J-1.572 E.05495
G3 X176.961 Y155.425 I3.099 J2.519 E.05425
G1 X176.961 Y153.049 E.0764
G3 X175.983 Y153.945 I-10.706 J-10.694 E.04267
G3 X174.345 Y153.853 I-.733 J-1.572 E.05495
G2 X173.113 Y152.837 I-3.207 J2.636 E.05167
G1 X173.113 Y151.764 E.0345
G1 X173.668 Y151.764 E.01786
; CHANGE_LAYER
; Z_HEIGHT: 12.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F8843.478
G1 X173.113 Y151.764 E-.21106
G1 X173.113 Y152.837 E-.40771
G1 X173.362 Y152.952 E-.10425
G1 X173.434 Y153.017 E-.03699
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 61/100
; update layer progress
M73 L61
M991 S0 P60 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z12.4 I-1.181 J.294 P1  F60000
G1 X177.309 Y168.584 Z12.4
G1 Z12.2
G1 E.8 F1800
; FEATURE: Inner wall
G1 F1206
M204 S8000
G1 X172.766 Y168.584 E.14609
G1 X172.766 Y151.416 E.55205
G1 X177.309 Y151.416 E.14609
G1 X177.309 Y168.524 E.55012
; COOLING_NODE: 0
M204 S10000
G1 X177.716 Y168.991 F60000
G1 F1206
M204 S8000
G1 X172.359 Y168.991 E.17227
G1 X172.359 Y151.009 E.57823
G1 X177.716 Y151.009 E.17227
G1 X177.716 Y168.931 E.5763
; COOLING_NODE: 0
M204 S10000
G1 X178.123 Y169.398 F60000
G1 F1206
M204 S8000
G1 X171.952 Y169.398 E.19845
M73 P69 R8
G1 X171.952 Y150.602 E.60441
G1 X178.123 Y150.602 E.19845
G1 X178.123 Y169.338 E.60248
; COOLING_NODE: 0
M204 S250
G1 X178.515 Y169.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1206
M204 S5000
M73 P69 R7
G1 X171.56 Y169.79 E.20718
G1 X171.56 Y150.21 E.58322
G1 X178.515 Y150.21 E.20718
G1 X178.515 Y169.73 E.58143
;======== H2D 20260731========
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
G1 X176.515 Y169.747 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X173.114 Y167.96 Z12.6 F60000
G1 Z12.2
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F1206
M204 S8000
G1 X173.114 Y166.331 E.05236
G2 X174.017 Y167.282 I2.85 J-1.804 E.04244
G2 X175.655 Y166.867 I.408 J-1.828 E.05637
G1 X176.31 Y166.085 E.0328
G3 X176.961 Y165.742 I.694 J.526 E.02441
G1 X176.961 Y163.622 E.06816
G3 X175.983 Y164.661 I-3.111 J-1.947 E.04618
G3 X174.345 Y164.246 I-.408 J-1.828 E.05637
G1 X173.69 Y163.464 E.0328
G2 X173.114 Y163.14 I-.637 J.456 E.02195
G1 X173.114 Y161.09 E.0659
G2 X174.017 Y162.041 I2.85 J-1.803 E.04244
G2 X175.655 Y161.626 I.408 J-1.828 E.05637
G1 X176.31 Y160.844 E.0328
G3 X176.961 Y160.501 I.694 J.526 E.02441
G1 X176.961 Y158.381 E.06816
G3 X175.983 Y159.42 I-3.111 J-1.947 E.04618
G3 X174.345 Y159.005 I-.408 J-1.828 E.05637
G1 X173.69 Y158.223 E.0328
G2 X173.114 Y157.898 I-.637 J.456 E.02195
G1 X173.114 Y155.849 E.0659
G2 X174.017 Y156.8 I2.85 J-1.803 E.04244
G2 X175.655 Y156.384 I.408 J-1.828 E.05637
G1 X176.31 Y155.602 E.0328
G3 X176.961 Y155.259 I.694 J.526 E.02441
G1 X176.961 Y153.139 E.06816
G3 X175.983 Y154.179 I-3.111 J-1.947 E.04618
G3 X174.345 Y153.764 I-.408 J-1.828 E.05637
G1 X173.69 Y152.982 E.0328
G2 X173.114 Y152.657 I-.637 J.456 E.02195
G1 X173.114 Y151.764 E.0287
G1 X173.85 Y151.764 E.02366
; CHANGE_LAYER
; Z_HEIGHT: 12.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F8843.478
G1 X173.114 Y151.764 E-.27965
G1 X173.114 Y152.657 E-.33912
G1 X173.362 Y152.718 E-.09713
G1 X173.453 Y152.791 E-.04411
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 62/100
; update layer progress
M73 L62
M991 S0 P61 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z12.6 I-1.182 J.289 P1  F60000
G1 X177.309 Y168.584 Z12.6
G1 Z12.4
G1 E.8 F1800
; FEATURE: Inner wall
G1 F1238
M204 S8000
G1 X172.767 Y168.584 E.14605
G1 X172.767 Y151.416 E.55205
G1 X177.309 Y151.416 E.14605
G1 X177.309 Y168.524 E.55012
; COOLING_NODE: 0
M204 S10000
G1 X177.716 Y168.991 F60000
G1 F1238
M204 S8000
G1 X172.36 Y168.991 E.17223
G1 X172.36 Y151.009 E.57823
G1 X177.716 Y151.009 E.17223
G1 X177.716 Y168.931 E.5763
; COOLING_NODE: 0
M204 S10000
G1 X178.123 Y169.398 F60000
G1 F1238
M204 S8000
G1 X171.953 Y169.398 E.19841
G1 X171.953 Y150.602 E.60441
G1 X178.123 Y150.602 E.19841
G1 X178.123 Y169.338 E.60248
; COOLING_NODE: 0
M204 S250
G1 X178.515 Y169.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1210
M204 S5000
G1 X171.561 Y169.79 E.20714
G1 X171.561 Y150.21 E.58322
G1 X178.515 Y150.21 E.20714
G1 X178.515 Y169.73 E.58143
;======== H2D 20260731========
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
M73 P70 R7
G1 X176.515 Y169.747 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.278 Y168.236 Z12.8 F60000
G1 Z12.4
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F1238
M204 S8000
G1 X173.65 Y168.236 E.05236
G2 X173.115 Y168.131 I-.34 J.321 E.0187
G1 X173.115 Y166.458 E.05381
G1 X173.69 Y167.469 E.0374
G1 X174.017 Y167.632 E.01178
G2 X175.655 Y166.788 I-.417 J-2.819 E.06034
G1 X176.31 Y165.635 E.04265
G3 X176.961 Y165.522 I.404 J.398 E.02264
G1 X176.961 Y163.704 E.05848
G1 X176.31 Y164.848 E.04232
G1 X175.983 Y165.012 E.01178
G3 X174.345 Y164.167 I.417 J-2.819 E.06034
G1 X173.69 Y163.014 E.04265
G2 X173.115 Y162.89 I-.374 J.339 E.02017
G1 X173.115 Y161.216 E.05381
G1 X173.69 Y162.227 E.0374
G1 X174.017 Y162.391 E.01178
G2 X175.655 Y161.547 I-.417 J-2.819 E.06034
G1 X176.31 Y160.394 E.04265
G3 X176.961 Y160.281 I.404 J.398 E.02264
G1 X176.961 Y158.462 E.05848
G1 X176.31 Y159.607 E.04232
G1 X175.983 Y159.77 E.01178
G3 X174.345 Y158.926 I.417 J-2.819 E.06034
G1 X173.69 Y157.773 E.04265
G2 X173.115 Y157.648 I-.374 J.339 E.02017
G1 X173.115 Y155.975 E.05381
G1 X173.69 Y156.986 E.0374
G1 X174.017 Y157.15 E.01178
G2 X175.655 Y156.305 I-.417 J-2.819 E.06034
G1 X176.31 Y155.152 E.04265
G3 X176.961 Y155.04 I.404 J.398 E.02264
G1 X176.961 Y153.221 E.05848
G1 X176.31 Y154.365 E.04232
G1 X175.983 Y154.529 E.01178
G3 X174.345 Y153.685 I.417 J-2.819 E.06034
G1 X173.69 Y152.532 E.04265
G2 X173.115 Y152.407 I-.374 J.339 E.02017
G1 X173.115 Y151.764 E.02066
G1 X173.729 Y151.764 E.01974
G2 X174.583 Y151.764 I.427 J-.71 E.02885
G1 X176.211 Y151.764 E.05236
; CHANGE_LAYER
; Z_HEIGHT: 12.6
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F8843.478
G1 X174.583 Y151.764 E-.61876
G1 X174.223 Y151.856 E-.14124
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 63/100
; update layer progress
M73 L63
M991 S0 P62 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z12.8 I-1.197 J.221 P1  F60000
G1 X177.309 Y168.584 Z12.8
G1 Z12.6
G1 E.8 F1800
; FEATURE: Inner wall
G1 F1261
M204 S8000
G1 X172.768 Y168.584 E.14601
G1 X172.768 Y151.416 E.55205
G1 X177.309 Y151.416 E.14601
G1 X177.309 Y168.524 E.55012
; COOLING_NODE: 0
M204 S10000
G1 X177.716 Y168.991 F60000
G1 F1261
M204 S8000
G1 X172.361 Y168.991 E.17219
G1 X172.361 Y151.009 E.57823
G1 X177.716 Y151.009 E.17219
G1 X177.716 Y168.931 E.5763
; COOLING_NODE: 0
M204 S10000
G1 X178.123 Y169.398 F60000
G1 F1261
M204 S8000
G1 X171.954 Y169.398 E.19837
G1 X171.954 Y150.602 E.60441
G1 X178.123 Y150.602 E.19837
G1 X178.123 Y169.338 E.60248
; COOLING_NODE: 0
M204 S250
G1 X178.515 Y169.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1207
M204 S5000
G1 X171.562 Y169.79 E.20711
G1 X171.562 Y150.21 E.58322
G1 X178.515 Y150.21 E.20711
G1 X178.515 Y169.73 E.58143
;======== H2D 20260731========
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
G1 X176.515 Y169.747 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X176.961 Y166.834 Z13 F60000
G1 Z12.6
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F1261
M204 S8000
G1 X176.961 Y165.206 E.05236
G3 X176.713 Y164.586 I.392 J-.516 E.02255
G3 X176.961 Y163.801 I1.54 J.054 E.02679
G1 X176.961 Y159.965 E.12337
G3 X176.713 Y159.345 I.392 J-.516 E.02255
G3 X176.961 Y158.56 I1.54 J.054 E.02679
G1 X176.961 Y154.724 E.12337
G3 X176.713 Y154.104 I.392 J-.516 E.02255
G3 X176.961 Y153.319 I1.54 J.054 E.02679
G1 X176.961 Y151.764 E.04998
G1 X174.885 Y151.764 E.06674
G2 X174.124 Y152.466 I.713 J1.538 E.03382
G1 X174.092 Y152.793 E.01058
G2 X174.724 Y154.104 I2.083 J-.197 E.04777
G1 X175.634 Y154.759 E.03606
G3 X175.908 Y155.414 I-.409 J.555 E.02398
G3 X175.276 Y156.724 I-2.083 J-.197 E.04777
G1 X174.366 Y157.379 E.03606
G2 X174.092 Y158.035 I.409 J.555 E.02398
G2 X174.724 Y159.345 I2.083 J-.197 E.04777
G1 X175.634 Y160 E.03606
G3 X175.908 Y160.655 I-.409 J.555 E.02398
G3 X175.276 Y161.966 I-2.083 J-.197 E.04777
G1 X174.366 Y162.621 E.03606
M73 P71 R7
G2 X174.092 Y163.276 I.409 J.555 E.02398
G2 X174.724 Y164.586 I2.083 J-.197 E.04777
G1 X175.634 Y165.241 E.03606
G3 X175.908 Y165.897 I-.409 J.555 E.02398
G3 X175.276 Y167.207 I-2.083 J-.197 E.04777
G1 X174.366 Y167.862 E.03606
G1 X174.119 Y168.236 E.01439
G1 X173.116 Y168.236 E.03225
G1 X173.116 Y167.723 E.01649
G2 X173.287 Y167.207 I-.344 J-.4 E.01835
G1 X173.116 Y166.557 E.02161
G1 X173.116 Y162.481 E.13105
G2 X173.287 Y161.966 I-.344 J-.4 E.01835
G1 X173.116 Y161.316 E.02161
G1 X173.116 Y157.24 E.13105
G2 X173.287 Y156.724 I-.344 J-.4 E.01835
G1 X173.116 Y156.074 E.02161
G1 X173.116 Y154.446 E.05236
; CHANGE_LAYER
; Z_HEIGHT: 12.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F8843.478
G1 X173.116 Y156.074 E-.61876
G1 X173.211 Y156.434 E-.14124
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 64/100
; update layer progress
M73 L64
M991 S0 P63 ;notify layer change

M106 S229.5
; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z13 I-1.153 J.389 P1  F60000
G1 X177.309 Y168.584 Z13
G1 Z12.8
G1 E.8 F1800
; FEATURE: Inner wall
G1 F1200
M204 S8000
G1 X172.769 Y168.584 E.14597
G1 X172.769 Y151.416 E.55205
G1 X177.309 Y151.416 E.14597
G1 X177.309 Y168.524 E.55012
; COOLING_NODE: 0
M204 S10000
G1 X177.716 Y168.991 F60000
G1 F1200
M204 S8000
G1 X172.362 Y168.991 E.17215
G1 X172.362 Y151.009 E.57823
G1 X177.716 Y151.009 E.17215
G1 X177.716 Y168.931 E.5763
; COOLING_NODE: 0
M204 S10000
G1 X178.123 Y169.398 F60000
G1 F1200
M204 S8000
G1 X171.955 Y169.398 E.19833
G1 X171.955 Y150.602 E.60441
G1 X178.123 Y150.602 E.19833
G1 X178.123 Y169.338 E.60248
; COOLING_NODE: 0
M204 S250
G1 X178.515 Y169.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X171.563 Y169.79 E.20707
G1 X171.563 Y150.21 E.58322
G1 X178.515 Y150.21 E.20707
G1 X178.515 Y169.73 E.58143
;======== H2D 20260731========
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
G1 X176.515 Y169.747 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X176.961 Y166.38 Z13.2 F60000
G1 Z12.8
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X176.961 Y164.751 E.05236
G1 X176.9 Y164.586 E.00565
G1 X176.961 Y163.884 E.02266
G1 X176.961 Y159.51 E.14066
G1 X176.9 Y159.345 E.00565
G1 X176.961 Y158.643 E.02266
G1 X176.961 Y154.269 E.14066
G1 X176.9 Y154.104 E.00565
G1 X176.961 Y153.402 E.02266
G1 X176.961 Y151.764 E.05264
G1 X175.065 Y151.764 E.06094
G2 X174.4 Y152.466 I2.851 J3.374 E.03116
G2 X174.64 Y154.104 I1.661 J.593 E.05541
G3 X175.601 Y155.086 I-3.981 J4.852 E.04428
G3 X175.36 Y156.724 I-1.661 J.593 E.05541
G2 X174.4 Y157.707 I3.982 J4.852 E.04428
G2 X174.64 Y159.345 I1.661 J.593 E.05541
G3 X175.601 Y160.328 I-3.981 J4.851 E.04428
G3 X175.36 Y161.966 I-1.661 J.593 E.05541
G2 X174.4 Y162.948 I3.982 J4.852 E.04428
G2 X174.64 Y164.586 I1.661 J.593 E.05541
G3 X175.601 Y165.569 I-3.981 J4.852 E.04428
G3 X175.36 Y167.207 I-1.661 J.593 E.05541
G2 X174.383 Y168.236 I2.838 J3.675 E.0458
G1 X173.118 Y168.236 E.04068
G1 X173.118 Y167.872 E.01168
; CHANGE_LAYER
; Z_HEIGHT: 13
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F8843.478
G1 X173.118 Y168.236 E-.13806
G1 X174.383 Y168.236 E-.4807
G1 X174.612 Y167.943 E-.14124
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 65/100
; update layer progress
M73 L65
M991 S0 P64 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z13.2 I-.281 J1.184 P1  F60000
G1 X177.309 Y168.584 Z13.2
G1 Z13
G1 E.8 F1800
; FEATURE: Inner wall
G1 F1200
M204 S8000
G1 X172.771 Y168.584 E.14593
G1 X172.771 Y151.416 E.55205
G1 X177.309 Y151.416 E.14593
G1 X177.309 Y168.524 E.55012
; COOLING_NODE: 0
M204 S10000
G1 X177.716 Y168.991 F60000
G1 F1200
M204 S8000
G1 X172.364 Y168.991 E.17211
M73 P72 R7
G1 X172.364 Y151.009 E.57823
G1 X177.716 Y151.009 E.17211
G1 X177.716 Y168.931 E.5763
; COOLING_NODE: 0
M204 S10000
G1 X178.123 Y169.398 F60000
G1 F1200
M204 S8000
G1 X171.957 Y169.398 E.19829
G1 X171.957 Y150.602 E.60441
G1 X178.123 Y150.602 E.19829
G1 X178.123 Y169.338 E.60248
; COOLING_NODE: 0
M204 S250
G1 X178.515 Y169.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X171.564 Y169.79 E.20703
G1 X171.564 Y150.21 E.58322
G1 X178.515 Y150.21 E.20703
G1 X178.515 Y169.73 E.58143
;======== H2D 20260731========
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
G1 X176.515 Y169.747 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X176.255 Y168.236 Z13.4 F60000
G1 Z13
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X174.627 Y168.236 E.05236
G3 X175.457 Y167.207 I6.572 J4.453 E.04255
G2 X175.104 Y165.241 I-1.487 J-.748 E.06887
G1 X174.543 Y164.586 E.02773
G3 X174.896 Y162.621 I1.487 J-.748 E.06887
G1 X175.457 Y161.966 E.02773
G2 X175.104 Y160 I-1.487 J-.748 E.06887
G1 X174.543 Y159.345 E.02773
G3 X174.896 Y157.379 I1.487 J-.748 E.06887
G1 X175.457 Y156.724 E.02773
G2 X175.104 Y154.759 I-1.487 J-.748 E.06887
G1 X174.543 Y154.104 E.02773
G3 X174.896 Y152.138 I1.487 J-.748 E.06887
G1 X175.216 Y151.764 E.01582
G1 X173.587 Y151.764 E.05236
; CHANGE_LAYER
; Z_HEIGHT: 13.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F8843.478
G1 X175.216 Y151.764 E-.61876
G1 X174.974 Y152.047 E-.14124
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 66/100
; update layer progress
M73 L66
M991 S0 P65 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z13.4 I-1.205 J.17 P1  F60000
G1 X177.309 Y168.584 Z13.4
G1 Z13.2
G1 E.8 F1800
; FEATURE: Inner wall
G1 F1200
M204 S8000
G1 X172.772 Y168.584 E.14589
G1 X172.772 Y151.416 E.55205
G1 X177.309 Y151.416 E.14589
G1 X177.309 Y168.524 E.55012
; COOLING_NODE: 0
M204 S10000
G1 X177.716 Y168.991 F60000
G1 F1200
M204 S8000
G1 X172.365 Y168.991 E.17207
G1 X172.365 Y151.009 E.57823
G1 X177.716 Y151.009 E.17207
G1 X177.716 Y168.931 E.5763
; COOLING_NODE: 0
M204 S10000
G1 X178.123 Y169.398 F60000
G1 F1200
M204 S8000
G1 X171.958 Y169.398 E.19825
G1 X171.958 Y150.602 E.60441
G1 X178.123 Y150.602 E.19825
G1 X178.123 Y169.338 E.60248
; COOLING_NODE: 0
M204 S250
G1 X178.515 Y169.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
M73 P72 R6
G1 X171.566 Y169.79 E.207
M73 P73 R6
G1 X171.566 Y150.21 E.58322
G1 X178.515 Y150.21 E.207
G1 X178.515 Y169.73 E.58143
;======== H2D 20260731========
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
G1 X176.515 Y169.747 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X176.408 Y168.236 Z13.6 F60000
G1 Z13.2
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X174.78 Y168.236 E.05236
G1 X175.097 Y167.862 E.01577
G2 X175.46 Y165.897 I-1.135 J-1.226 E.06889
G1 X174.903 Y165.241 E.02766
G3 X174.54 Y163.276 I1.135 J-1.226 E.06889
G1 X175.097 Y162.621 E.02766
G2 X175.46 Y160.655 I-1.135 J-1.226 E.06889
G1 X174.903 Y160 E.02766
G3 X174.54 Y158.035 I1.135 J-1.226 E.06889
G1 X175.097 Y157.379 E.02766
G2 X175.46 Y155.414 I-1.135 J-1.226 E.06889
G1 X174.903 Y154.759 E.02766
G3 X174.54 Y152.793 I1.135 J-1.226 E.06889
G2 X175.368 Y151.764 I-6.168 J-5.813 E.04251
G1 X173.74 Y151.764 E.05236
; CHANGE_LAYER
; Z_HEIGHT: 13.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F8843.478
G1 X175.368 Y151.764 E-.61876
G1 X175.135 Y152.054 E-.14125
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 67/100
; update layer progress
M73 L67
M991 S0 P66 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z13.6 I-1.207 J.159 P1  F60000
G1 X177.309 Y168.584 Z13.6
G1 Z13.4
G1 E.8 F1800
; FEATURE: Inner wall
G1 F1200
M204 S8000
G1 X172.773 Y168.584 E.14585
G1 X172.773 Y151.416 E.55205
G1 X177.309 Y151.416 E.14585
G1 X177.309 Y168.524 E.55012
; COOLING_NODE: 0
M204 S10000
G1 X177.716 Y168.991 F60000
G1 F1200
M204 S8000
G1 X172.366 Y168.991 E.17203
G1 X172.366 Y151.009 E.57823
G1 X177.716 Y151.009 E.17203
G1 X177.716 Y168.931 E.5763
; COOLING_NODE: 0
M204 S10000
G1 X178.123 Y169.398 F60000
G1 F1200
M204 S8000
G1 X171.959 Y169.398 E.19821
G1 X171.959 Y150.602 E.60441
G1 X178.123 Y150.602 E.19821
G1 X178.123 Y169.338 E.60248
; COOLING_NODE: 0
M204 S250
G1 X178.515 Y169.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X171.567 Y169.79 E.20696
G1 X171.567 Y150.21 E.58322
G1 X178.515 Y150.21 E.20696
G1 X178.515 Y169.73 E.58143
;======== H2D 20260731========
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
G1 X176.515 Y169.747 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X176.961 Y165.604 Z13.8 F60000
G1 Z13.4
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X176.905 Y163.276 E.0749
G1 X176.961 Y163.128 E.00508
G1 X176.961 Y158.735 E.14127
G1 X176.905 Y158.035 E.02259
G1 X176.961 Y157.887 E.00508
G1 X176.961 Y153.494 E.14127
G1 X176.905 Y152.793 E.02259
G1 X176.961 Y152.645 E.00508
G1 X176.961 Y151.764 E.02833
G1 X175.61 Y151.764 E.04342
G3 X174.637 Y152.793 I-3.916 J-2.73 E.04571
G2 X174.285 Y154.104 I1.362 J1.069 E.04484
G1 X174.407 Y154.431 E.01124
G2 X175.363 Y155.414 I5.143 J-4.047 E.04417
M73 P74 R6
G3 X175.715 Y156.724 I-1.362 J1.069 E.04484
G1 X175.593 Y157.052 E.01124
G3 X174.637 Y158.035 I-5.143 J-4.047 E.04417
G2 X174.285 Y159.345 I1.362 J1.069 E.04484
G1 X174.407 Y159.673 E.01124
G2 X175.363 Y160.655 I5.144 J-4.047 E.04417
G3 X175.715 Y161.966 I-1.362 J1.069 E.04484
G1 X175.593 Y162.293 E.01124
G3 X174.637 Y163.276 I-5.143 J-4.046 E.04417
G2 X174.285 Y164.586 I1.362 J1.069 E.04484
G1 X174.407 Y164.914 E.01124
G2 X175.363 Y165.897 I5.143 J-4.047 E.04417
G3 X175.715 Y167.207 I-1.362 J1.069 E.04484
G3 X174.93 Y168.236 I-2.131 J-.813 E.0422
G1 X173.301 Y168.236 E.05236
; CHANGE_LAYER
; Z_HEIGHT: 13.6
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F8843.478
G1 X174.93 Y168.236 E-.61876
G1 X175.185 Y167.966 E-.14124
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 68/100
; update layer progress
M73 L68
M991 S0 P67 ;notify layer change

M106 S226.95
; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z13.8 I-.34 J1.168 P1  F60000
G1 X177.309 Y168.584 Z13.8
G1 Z13.6
G1 E.8 F1800
; FEATURE: Inner wall
G1 F1275
M204 S8000
G1 X172.774 Y168.584 E.14581
G1 X172.774 Y151.416 E.55205
G1 X177.309 Y151.416 E.14581
G1 X177.309 Y168.524 E.55012
; COOLING_NODE: 0
M204 S10000
G1 X177.716 Y168.991 F60000
G1 F1275
M204 S8000
G1 X172.367 Y168.991 E.17199
G1 X172.367 Y151.009 E.57823
G1 X177.716 Y151.009 E.17199
G1 X177.716 Y168.931 E.5763
; COOLING_NODE: 0
M204 S10000
G1 X178.123 Y169.398 F60000
G1 F1275
M204 S8000
G1 X171.96 Y169.398 E.19817
G1 X171.96 Y150.602 E.60441
G1 X178.123 Y150.602 E.19817
G1 X178.123 Y169.338 E.60248
; COOLING_NODE: 0
M204 S250
G1 X178.515 Y169.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1275
M204 S5000
G1 X171.568 Y169.79 E.20692
G1 X171.568 Y150.21 E.58322
G1 X178.515 Y150.21 E.20692
G1 X178.515 Y169.73 E.58143
;======== H2D 20260731========
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
G1 X176.515 Y169.747 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X173.123 Y168.142 Z14 F60000
G1 Z13.6
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F1275
M204 S8000
G1 X173.123 Y166.514 E.05236
G2 X173.245 Y165.569 I-1.203 J-.636 E.03129
G1 X173.123 Y165.405 E.00657
G1 X173.123 Y161.272 E.1329
G2 X173.245 Y160.328 I-1.203 J-.636 E.03129
G1 X173.123 Y160.164 E.00657
G1 X173.123 Y156.031 E.1329
G2 X173.245 Y155.086 I-1.203 J-.636 E.03129
G1 X173.123 Y154.923 E.00657
G1 X173.123 Y153.294 E.05236
; WIPE_START
G1 F8843.478
G1 X173.123 Y154.923 E-.61876
G1 X173.245 Y155.086 E-.07759
G1 X173.263 Y155.253 E-.06365
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X176.961 Y155.203 Z14 F60000
G1 Z13.6
G1 E.8 F1800
G1 F1275
M204 S8000
G1 X176.961 Y153.575 E.05236
G3 X176.72 Y152.793 I1.267 J-.818 E.02664
G1 X176.755 Y152.466 E.0106
G2 X176.961 Y151.764 I-.368 J-.488 E.02518
G1 X175.87 Y151.764 E.03506
G1 X175.621 Y152.138 E.01445
G1 X174.721 Y152.793 E.03579
G2 X174.099 Y154.104 I1.446 J1.489 E.04765
G2 X174.379 Y154.759 I.695 J.091 E.02403
G1 X175.279 Y155.414 E.03579
G3 X175.901 Y156.724 I-1.446 J1.489 E.04765
G3 X175.621 Y157.379 I-.695 J.091 E.02403
G1 X174.721 Y158.035 E.03579
G2 X174.099 Y159.345 I1.446 J1.489 E.04765
G2 X174.379 Y160 I.695 J.091 E.02403
G1 X175.279 Y160.655 E.03579
G3 X175.901 Y161.966 I-1.446 J1.489 E.04765
G3 X175.621 Y162.621 I-.695 J.091 E.02403
G1 X174.721 Y163.276 E.03579
G2 X174.099 Y164.586 I1.446 J1.489 E.04765
G2 X174.379 Y165.241 I.695 J.091 E.02403
G1 X175.279 Y165.897 E.03579
G3 X175.901 Y167.207 I-1.446 J1.489 E.04765
G1 X175.865 Y167.535 E.0106
G3 X175.108 Y168.236 I-1.51 J-.871 E.03368
G1 X176.75 Y168.236 E.05281
G1 X176.961 Y167.915 E.01233
G1 X176.961 Y164.058 E.12402
G3 X176.72 Y163.276 I1.267 J-.818 E.02664
G3 X176.961 Y162.673 I.631 J-.097 E.02189
G1 X176.961 Y158.816 E.12402
G3 X176.72 Y158.035 I1.267 J-.818 E.02664
G3 X176.961 Y157.432 I.631 J-.097 E.02189
G1 X176.961 Y155.804 E.05236
; CHANGE_LAYER
; Z_HEIGHT: 13.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F8843.478
G1 X176.961 Y157.432 E-.61876
G1 X176.755 Y157.707 E-.13037
G1 X176.752 Y157.736 E-.01088
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 69/100
; update layer progress
M73 L69
M991 S0 P68 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z14 I-1.215 J.062 P1  F60000
G1 X177.309 Y168.584 Z14
G1 Z13.8
G1 E.8 F1800
; FEATURE: Inner wall
G1 F1431
M204 S8000
G1 X172.776 Y168.584 E.14577
G1 X172.776 Y151.416 E.55205
G1 X177.309 Y151.416 E.14577
G1 X177.309 Y168.524 E.55012
; COOLING_NODE: 0
M204 S10000
G1 X177.716 Y168.991 F60000
G1 F1431
M204 S8000
G1 X172.369 Y168.991 E.17195
G1 X172.369 Y151.009 E.57823
G1 X177.716 Y151.009 E.17195
G1 X177.716 Y168.931 E.5763
; COOLING_NODE: 0
M204 S10000
M73 P75 R6
G1 X178.123 Y169.398 F60000
G1 F1431
M204 S8000
G1 X171.961 Y169.398 E.19813
G1 X171.961 Y150.602 E.60441
G1 X178.123 Y150.602 E.19813
G1 X178.123 Y169.338 E.60248
; COOLING_NODE: 0
M204 S250
G1 X178.515 Y169.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1380
M204 S5000
G1 X171.569 Y169.79 E.20689
G1 X171.569 Y150.21 E.58322
G1 X178.515 Y150.21 E.20689
G1 X178.515 Y169.73 E.58143
;======== H2D 20260731========
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
G1 X176.515 Y169.747 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.393 Y167.858 Z14.2 F60000
G1 Z13.8
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F1431
M204 S8000
G1 X175.873 Y167.858 E.01543
G1 X175.873 Y166.71 E.03693
G2 X174.345 Y165.515 I-2.021 J1.009 E.06449
G2 X173.501 Y165.947 I-.225 J.6 E.03432
G1 X173.501 Y164.963 E.03166
G1 X173.69 Y164.875 E.00669
G1 X174.345 Y163.697 E.04333
G3 X175.873 Y162.855 I2.121 J2.04 E.05698
G1 X175.873 Y161.469 E.04457
G2 X174.345 Y160.273 I-2.021 J1.009 E.06449
G2 X173.501 Y160.706 I-.225 J.6 E.03432
G1 X173.501 Y159.721 E.03166
G1 X173.69 Y159.634 E.00669
G1 X174.345 Y158.456 E.04333
G3 X175.873 Y157.613 I2.121 J2.04 E.05698
G1 X175.873 Y156.227 E.04457
G2 X174.345 Y155.032 I-2.021 J1.009 E.06449
G2 X173.501 Y155.465 I-.225 J.6 E.03432
G1 X173.501 Y154.48 E.03166
G1 X173.69 Y154.392 E.00669
G1 X174.345 Y153.215 E.04333
G3 X175.873 Y152.372 I2.121 J2.04 E.05698
G1 X175.873 Y152.142 E.00741
G1 X174.476 Y152.142 E.04495
; WIPE_START
G1 F8843.478
G1 X175.873 Y152.142 E-.53117
G1 X175.873 Y152.372 E-.08759
G1 X175.522 Y152.492 E-.14125
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X173.138 Y153.443 Z14.2 F60000
G1 Z13.8
G1 E.8 F1800
; FEATURE: Floating vertical shell
; LINE_WIDTH: 0.383912
G1 F1431
M204 S8000
G1 X173.138 Y151.938 E.04054
G1 X173.166 Y151.806 E.00363
G1 X173.298 Y151.779 E.00363
G1 X176.017 Y151.779 E.07324
; WIPE_START
G1 F10557.443
G1 X174.017 Y151.779 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.084 Y159.336 Z14.2 F60000
G1 X176.317 Y168.062 Z14.2
G1 Z13.8
G1 E.8 F1800
; LINE_WIDTH: 0.503045
G1 F1431
M204 S8000
G1 X176.246 Y168.114 E.00321
; LINE_WIDTH: 0.454995
G1 X176.175 Y168.167 E.00288
; LINE_WIDTH: 0.406945
G1 X176.105 Y168.22 E.00254
; LINE_WIDTH: 0.404702
G1 X176.226 Y168.196 E.00354
; LINE_WIDTH: 0.448264
G1 X176.348 Y168.172 E.00397
; LINE_WIDTH: 0.491827
G1 X176.469 Y168.147 E.0044
; LINE_WIDTH: 0.556758
G3 X176.848 Y168.123 I.25 J.941 E.0155
G1 X176.848 Y151.877 E.65943
G1 X176.395 Y151.866 E.01839
; LINE_WIDTH: 0.518633
G1 X176.316 Y151.844 E.0031
; LINE_WIDTH: 0.479858
G1 X176.236 Y151.823 E.00285
; LINE_WIDTH: 0.441083
G1 X176.156 Y151.801 E.0026
; LINE_WIDTH: 0.402308
G1 X176.077 Y151.779 E.00234
G1 X176.138 Y151.819 E.00208
; LINE_WIDTH: 0.441083
G1 X176.2 Y151.859 E.00231
; LINE_WIDTH: 0.479858
G1 X176.262 Y151.898 E.00253
; LINE_WIDTH: 0.518633
G1 X176.323 Y151.938 E.00276
; LINE_WIDTH: 0.556926
G1 X176.322 Y168.002 E.65223
; WIPE_START
G1 F7003.82
G1 X176.322 Y166.002 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X173.138 Y166.128 Z14.2 F60000
G1 Z13.8
G1 E.8 F1800
; LINE_WIDTH: 0.383821
G1 F1431
M204 S8000
G1 X173.138 Y168.062 E.05208
G1 X173.166 Y168.194 E.00363
G1 X173.298 Y168.221 E.00363
G1 X176.045 Y168.221 E.07397
; WIPE_START
G1 F10560.277
G1 X174.045 Y168.221 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X173.138 Y165.17 Z14.2 F60000
G1 Z13.8
G1 E.8 F1800
; Slow Down Start
; LINE_WIDTH: 0.38292
G1 F3000;_EXTRUDE_SET_SPEED
M204 S8000
G1 X173.138 Y159.968 E.13972
; Slow Down End
; WIPE_START
G1 X173.138 Y161.968 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X173.138 Y154.896 Z14.2 F60000
G1 Z13.8
G1 E.8 F1800
G1 F1431
M204 S8000
G1 X173.138 Y154.621 E.0074
; WIPE_START
G1 F10588.235
G1 X173.138 Y154.896 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X173.138 Y158.863 Z14.2 F60000
G1 Z13.8
G1 E.8 F1800
; Slow Down Start
G1 F3000;_EXTRUDE_SET_SPEED
M204 S8000
G1 X173.138 Y155.751 E.08359
; Slow Down End
; CHANGE_LAYER
; Z_HEIGHT: 14
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F3000
G1 X173.138 Y157.751 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 70/100
; update layer progress
M73 L70
M991 S0 P69 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z14.2 I-1.136 J.437 P1  F60000
G1 X177.309 Y168.584 Z14.2
G1 Z14
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1403
M204 S8000
G1 X172.777 Y168.584 E.14573
G1 X172.777 Y151.416 E.55205
G1 X177.309 Y151.416 E.14573
G1 X177.309 Y168.524 E.55012
; COOLING_NODE: 0
M204 S10000
G1 X177.716 Y168.991 F60000
G1 F1403
M204 S8000
G1 X172.37 Y168.991 E.17191
G1 X172.37 Y151.009 E.57823
G1 X177.716 Y151.009 E.17191
G1 X177.716 Y168.931 E.5763
; COOLING_NODE: 0
M204 S10000
G1 X178.123 Y169.398 F60000
G1 F1403
M204 S8000
G1 X171.963 Y169.398 E.19809
G1 X171.963 Y150.602 E.60441
G1 X178.123 Y150.602 E.19809
G1 X178.123 Y169.338 E.60248
; COOLING_NODE: 0
M204 S250
G1 X178.515 Y169.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
M73 P76 R6
G1 F1403
M204 S5000
G1 X171.571 Y169.79 E.20685
G1 X171.571 Y150.21 E.58322
G1 X178.515 Y150.21 E.20685
G1 X178.515 Y169.73 E.58143
;======== H2D 20260731========
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
G1 X176.515 Y169.747 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X176.929 Y168.204 Z14.4 F60000
G1 Z14
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.39612
G1 F1403
M204 S8000
G1 X176.929 Y151.856 E.4561
M204 S10000
G1 X176.73 Y151.789 F60000
; FEATURE: Bridge
; LINE_WIDTH: 0.40616
; LAYER_HEIGHT: 0.4
M106 S229.5
G1 F3000
M204 S8000
G1 X173.147 Y151.789 E.18336
G1 X173.147 Y152.245 E.02334
G1 X176.527 Y152.245 E.17299
G1 X176.527 Y152.702 E.02334
G1 X173.147 Y152.702 E.17299
G1 X173.147 Y153.158 E.02334
G1 X176.527 Y153.158 E.17299
G1 X176.527 Y153.614 E.02334
G1 X173.725 Y153.614 E.14338
G1 X174.473 Y153.922 E.04139
G1 X174.197 Y154.07 E.01604
G1 X176.527 Y154.07 E.11926
G1 X176.527 Y154.526 E.02334
G1 X173.344 Y154.526 E.1629
G1 X173.147 Y154.632 E.01145
G1 X173.147 Y154.824 E.00986
G1 X173.409 Y154.982 E.01569
G1 X176.527 Y154.982 E.15955
G1 X176.527 Y155.438 E.02334
G1 X173.373 Y155.438 E.16141
G1 X173.198 Y155.753 E.01841
G2 X173.147 Y155.895 I.038 J.094 E.0087
G1 X176.527 Y155.895 E.17299
G1 X176.527 Y156.351 E.02334
G1 X173.147 Y156.351 E.17299
G1 X173.147 Y156.807 E.02334
G1 X176.527 Y156.807 E.17299
G1 X176.527 Y157.263 E.02334
G1 X173.147 Y157.263 E.17299
G1 X173.147 Y157.719 E.02334
G1 X176.527 Y157.719 E.17299
G1 X176.527 Y158.175 E.02334
G1 X173.147 Y158.175 E.17299
G1 X173.147 Y158.632 E.02334
G1 X176.527 Y158.632 E.17299
G1 X176.527 Y159.088 E.02334
G1 X173.8 Y159.088 E.13956
G1 X174.242 Y159.286 E.02478
G1 X173.835 Y159.544 E.02464
G1 X176.527 Y159.544 E.13776
G1 X176.527 Y160 E.02334
G1 X173.147 Y160 E.17299
G1 X173.147 Y160.456 E.02334
G1 X176.527 Y160.456 E.17299
G1 X176.527 Y160.912 E.02334
G1 X173.147 Y160.912 E.17299
G1 X173.147 Y161.369 E.02334
G1 X176.527 Y161.369 E.17299
G1 X176.527 Y161.825 E.02334
G1 X173.147 Y161.825 E.17299
G1 X173.147 Y162.281 E.02334
G1 X176.527 Y162.281 E.17299
G1 X176.527 Y162.737 E.02334
G1 X173.147 Y162.737 E.17299
G1 X173.147 Y163.193 E.02334
G1 X176.527 Y163.193 E.17299
G1 X176.527 Y163.649 E.02334
G1 X173.147 Y163.649 E.17299
G1 X173.147 Y164.106 E.02334
G1 X176.527 Y164.106 E.17299
G1 X176.527 Y164.562 E.02334
G1 X173.147 Y164.562 E.17299
G1 X173.147 Y165.018 E.02334
G1 X176.527 Y165.018 E.17299
G1 X176.527 Y165.474 E.02334
G1 X173.956 Y165.474 E.13157
G1 X174.032 Y165.509 E.00426
G1 X173.496 Y165.93 E.03486
G1 X176.527 Y165.93 E.1551
G1 X176.527 Y166.386 E.02334
G1 X173.147 Y166.386 E.17299
G1 X173.147 Y166.842 E.02334
G1 X176.527 Y166.842 E.17299
G1 X176.527 Y167.299 E.02334
G1 X173.147 Y167.299 E.17299
G1 X173.147 Y167.755 E.02334
G1 X176.527 Y167.755 E.17299
G1 X176.527 Y168.211 E.02334
G1 X172.944 Y168.211 E.18336
M106 S226.95
; CHANGE_LAYER
; Z_HEIGHT: 14.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F3000
G1 X174.944 Y168.211 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 71/100
; update layer progress
M73 L71
M991 S0 P70 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z14.4 I-.19 J1.202 P1  F60000
G1 X177.309 Y168.584 Z14.4
G1 Z14.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1723
M204 S8000
G1 X172.778 Y168.584 E.14569
G1 X172.778 Y151.416 E.55205
G1 X177.309 Y151.416 E.14569
G1 X177.309 Y168.524 E.55012
; COOLING_NODE: 0
M204 S10000
G1 X177.716 Y168.991 F60000
G1 F1723
M204 S8000
G1 X172.371 Y168.991 E.17187
G1 X172.371 Y151.009 E.57823
G1 X177.716 Y151.009 E.17187
G1 X177.716 Y168.931 E.5763
; COOLING_NODE: 0
M204 S10000
G1 X178.123 Y169.398 F60000
G1 F1723
M204 S8000
G1 X171.964 Y169.398 E.19805
G1 X171.964 Y150.602 E.60441
G1 X178.123 Y150.602 E.19805
G1 X178.123 Y169.338 E.60248
; COOLING_NODE: 0
M204 S250
G1 X178.515 Y169.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1496
M204 S5000
G1 X171.572 Y169.79 E.20681
G1 X171.572 Y150.21 E.58322
G1 X178.515 Y150.21 E.20681
G1 X178.515 Y169.73 E.58143
;======== H2D 20260731========
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
M73 P76 R5
G1 F9547.055
M204 S8000
G1 X176.515 Y169.747 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.82 Y167.095 Z14.6 F60000
G1 Z14.2
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.35098
G1 F1723
M204 S8000
G1 X175.82 Y152.965 E.34385
M204 S10000
G1 X176.163 Y152.905 F60000
; LINE_WIDTH: 0.41999
G1 F1723
M204 S8000
G1 X176.163 Y152.562 E.0102
M73 P77 R5
G1 X175.477 Y152.562 E.02041
G1 X175.477 Y167.438 E.44307
G1 X176.163 Y167.438 E.02041
G1 X176.163 Y152.965 E.43108
M204 S10000
G1 X176.54 Y152.905 F60000
G1 F1723
M204 S8000
G1 X176.54 Y152.185 E.02144
G1 X175.1 Y152.185 E.04287
G1 X175.1 Y167.815 E.46553
G1 X176.54 Y167.815 E.04287
G1 X176.54 Y152.965 E.44231
M204 S10000
G1 X176.917 Y152.905 F60000
G1 F1723
M204 S8000
G1 X176.917 Y151.808 E.03267
G1 X174.723 Y151.808 E.06533
G1 X174.723 Y168.192 E.488
G1 X176.917 Y168.192 E.06533
G1 X176.917 Y152.965 E.45354
; WIPE_START
G1 F9547.299
G1 X176.917 Y154.965 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X174.016 Y151.764 Z14.6 F60000
G1 Z14.2
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F1723
M204 S8000
G1 X174.331 Y151.764 E.01015
G1 X174.331 Y153.077 E.04221
G1 X174.227 Y153.134 E.00383
G3 X173.126 Y154.059 I-2.695 J-2.091 E.04656
G1 X173.126 Y156.383 E.07476
G3 X174.331 Y155.441 I2.878 J2.437 E.04954
G1 X174.331 Y158.318 E.09254
G1 X174.227 Y158.376 E.00383
G3 X173.126 Y159.3 I-2.695 J-2.091 E.04656
G1 X173.126 Y161.625 E.07476
G3 X174.331 Y160.682 I2.878 J2.437 E.04954
G1 X174.331 Y163.56 E.09254
G1 X174.227 Y163.617 E.00383
G3 X173.126 Y164.541 I-2.695 J-2.091 E.04656
G1 X173.126 Y166.866 E.07476
G3 X174.331 Y165.923 I2.878 J2.437 E.04954
G1 X174.331 Y167.551 E.05236
; CHANGE_LAYER
; Z_HEIGHT: 14.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F8843.478
G1 X174.331 Y165.923 E-.61876
G1 X174.227 Y165.939 E-.04017
G1 X174.012 Y166.096 E-.10107
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 72/100
; update layer progress
M73 L72
M991 S0 P71 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z14.6 I-.733 J.971 P1  F60000
G1 X177.309 Y168.584 Z14.6
G1 Z14.4
G1 E.8 F1800
; FEATURE: Inner wall
G1 F1730
M204 S8000
G1 X172.779 Y168.584 E.14565
G1 X172.779 Y151.416 E.55205
G1 X177.309 Y151.416 E.14565
G1 X177.309 Y168.524 E.55012
; COOLING_NODE: 0
M204 S10000
G1 X177.716 Y168.991 F60000
G1 F1730
M204 S8000
G1 X172.372 Y168.991 E.17183
G1 X172.372 Y151.009 E.57823
G1 X177.716 Y151.009 E.17183
G1 X177.716 Y168.931 E.5763
; COOLING_NODE: 0
M204 S10000
G1 X178.123 Y169.398 F60000
G1 F1730
M204 S8000
G1 X171.965 Y169.398 E.19801
G1 X171.965 Y150.602 E.60441
G1 X178.123 Y150.602 E.19801
G1 X178.123 Y169.338 E.60248
; COOLING_NODE: 0
M204 S250
G1 X178.515 Y169.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1519
M204 S5000
G1 X171.573 Y169.79 E.20678
G1 X171.573 Y150.21 E.58322
G1 X178.515 Y150.21 E.20678
G1 X178.515 Y169.73 E.58143
;======== H2D 20260731========
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
G1 X176.515 Y169.747 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X174.331 Y167.685 Z14.8 F60000
G1 Z14.4
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F1730
M204 S8000
G1 X174.331 Y166.056 E.05236
G2 X173.128 Y166.984 I5.842 J8.827 E.04891
G1 X173.128 Y164.38 E.08371
G2 X174.227 Y163.489 I-9.597 J-12.964 E.04552
G1 X174.331 Y163.452 E.00357
G1 X174.331 Y160.815 E.08479
G2 X173.128 Y161.742 I5.84 J8.824 E.04891
G1 X173.128 Y159.139 E.08371
G2 X174.227 Y158.248 I-9.594 J-12.961 E.04552
G1 X174.331 Y158.21 E.00357
G1 X174.331 Y155.574 E.08479
G2 X173.128 Y156.501 I5.842 J8.827 E.04891
G1 X173.128 Y153.898 E.08371
G2 X174.227 Y153.007 I-9.597 J-12.964 E.04552
G1 X174.331 Y152.969 E.00357
G1 X174.331 Y151.764 E.03874
G1 X173.908 Y151.764 E.01362
; WIPE_START
G1 F8843.478
G1 X174.331 Y151.764 E-.161
G1 X174.331 Y152.969 E-.45776
G1 X174.227 Y153.007 E-.04221
G1 X174.024 Y153.171 E-.09903
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X176.917 Y152.905 Z14.8 F60000
G1 Z14.4
G1 E.8 F1800
; FEATURE: Floating vertical shell
; LINE_WIDTH: 0.41999
G1 F1730
M204 S8000
G1 X176.917 Y151.808 E.03267
G1 X174.723 Y151.808 E.06533
G1 X174.723 Y168.192 E.488
G1 X176.917 Y168.192 E.06533
G1 X176.917 Y152.965 E.45354
M204 S10000
G1 X176.54 Y152.905 F60000
G1 F1730
M204 S8000
G1 X176.54 Y152.185 E.02144
G1 X175.1 Y152.185 E.04287
G1 X175.1 Y167.815 E.46553
G1 X176.54 Y167.815 E.04287
G1 X176.54 Y152.965 E.44231
M204 S10000
G1 X176.163 Y152.905 F60000
G1 F1730
M204 S8000
G1 X176.163 Y152.562 E.0102
M73 P78 R5
G1 X175.477 Y152.562 E.02041
G1 X175.477 Y167.438 E.44307
G1 X176.163 Y167.438 E.02041
G1 X176.163 Y152.965 E.43108
; WIPE_START
G1 F9547.299
G1 X176.163 Y154.965 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.947 Y162.594 Z14.8 F60000
G1 X175.82 Y167.095 Z14.8
G1 Z14.4
G1 E.8 F1800
; LINE_WIDTH: 0.35098
G1 F1730
M204 S8000
G1 X175.82 Y152.965 E.34385
; CHANGE_LAYER
; Z_HEIGHT: 14.6
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F11686.035
G1 X175.82 Y154.965 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 73/100
; update layer progress
M73 L73
M991 S0 P72 ;notify layer change

M106 S224.4
; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z14.8 I-1.21 J.132 P1  F60000
G1 X177.309 Y168.584 Z14.8
G1 Z14.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1884
M204 S8000
G1 X172.781 Y168.584 E.14561
G1 X172.781 Y151.416 E.55205
G1 X177.309 Y151.416 E.14561
G1 X177.309 Y168.524 E.55012
; COOLING_NODE: 0
M204 S10000
G1 X177.716 Y168.991 F60000
G1 F1884
M204 S8000
G1 X172.373 Y168.991 E.17179
G1 X172.373 Y151.009 E.57823
G1 X177.716 Y151.009 E.17179
G1 X177.716 Y168.931 E.5763
; COOLING_NODE: 0
M204 S10000
G1 X178.123 Y169.398 F60000
G1 F1884
M204 S8000
G1 X171.966 Y169.398 E.19797
G1 X171.966 Y150.602 E.60441
G1 X178.123 Y150.602 E.19797
G1 X178.123 Y169.338 E.60248
; COOLING_NODE: 0
M204 S250
G1 X178.515 Y169.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1524
M204 S5000
G1 X171.574 Y169.79 E.20674
G1 X171.574 Y150.21 E.58322
G1 X178.515 Y150.21 E.20674
G1 X178.515 Y169.73 E.58143
;======== H2D 20260731========
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
G1 X176.515 Y169.747 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X173.661 Y168.236 Z15 F60000
G1 Z14.6
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F1884
M204 S8000
G1 X173.129 Y168.236 E.0171
G1 X173.129 Y167.139 E.03526
G2 X174.227 Y166.221 I-1.834 J-3.309 E.0463
G1 X174.331 Y166.167 E.00379
G1 X174.331 Y163.322 E.09146
G2 X173.129 Y164.259 I1.908 J3.691 E.04929
G1 X173.129 Y161.898 E.07591
G2 X174.227 Y160.98 I-1.834 J-3.309 E.0463
G1 X174.331 Y160.925 E.00379
G1 X174.331 Y158.081 E.09146
G2 X173.129 Y159.017 I1.908 J3.691 E.04929
G1 X173.129 Y156.656 E.07591
G2 X174.227 Y155.739 I-1.833 J-3.309 E.0463
G1 X174.331 Y155.684 E.00379
G1 X174.331 Y152.84 E.09146
G2 X173.129 Y153.776 I1.908 J3.692 E.04929
G1 X173.129 Y152.148 E.05236
; WIPE_START
G1 F8843.478
G1 X173.129 Y153.776 E-.61876
G1 X173.402 Y153.524 E-.14124
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X176.504 Y151.639 Z15 F60000
G1 Z14.6
G1 E.8 F1800
; FEATURE: Top surface
; LINE_WIDTH: 0.42
G1 F1884
M204 S2000
G1 X177.086 Y152.221 E.02454
G1 X177.22 Y152.355
G1 X177.22 Y152.888
G1 X177.086 Y152.754
G1 X175.971 Y151.639 E.04701
G1 X175.837 Y151.505
G1 X175.304 Y151.505
G1 X175.437 Y151.639
G1 X177.086 Y153.288 E.06947
G1 X177.22 Y153.421
G1 X177.22 Y153.955
G1 X177.086 Y153.821
G1 X174.904 Y151.639 E.09193
G1 X174.77 Y151.505
G1 X174.42 Y151.688
G1 X174.554 Y151.822
G1 X177.086 Y154.354 E.10669
G1 X177.22 Y154.488
G1 X177.22 Y155.021
G1 X177.086 Y154.888
G1 X174.554 Y152.355 E.10669
G1 X174.42 Y152.221
G1 X174.42 Y152.754
G1 X174.554 Y152.888
G1 X177.086 Y155.421 E.10669
G1 X177.22 Y155.554
G1 X177.22 Y156.088
G1 X177.086 Y155.954
G1 X174.554 Y153.421 E.10669
G1 X174.42 Y153.288
G1 X174.42 Y153.821
G1 X174.554 Y153.955
G1 X177.086 Y156.487 E.10669
G1 X177.22 Y156.621
G1 X177.22 Y157.154
G1 X177.086 Y157.021
G1 X174.554 Y154.488 E.10669
G1 X174.42 Y154.354
G1 X174.42 Y154.887
G1 X174.554 Y155.021
G1 X177.086 Y157.554 E.10669
G1 X177.22 Y157.687
G1 X177.22 Y158.221
G1 X177.086 Y158.087
G1 X174.554 Y155.554 E.10669
G1 X174.42 Y155.421
G1 X174.42 Y155.954
G1 X174.554 Y156.088
G1 X177.086 Y158.62 E.10669
G1 X177.22 Y158.754
G1 X177.22 Y159.287
G1 X177.086 Y159.154
G1 X174.554 Y156.621 E.10669
G1 X174.42 Y156.487
G1 X174.42 Y157.021
G1 X174.554 Y157.154
G1 X177.086 Y159.687 E.10669
G1 X177.22 Y159.82
G1 X177.22 Y160.354
G1 X177.086 Y160.22
G1 X174.554 Y157.687 E.10669
G1 X174.42 Y157.554
G1 X174.42 Y158.087
G1 X174.554 Y158.221
G1 X177.086 Y160.753 E.10669
G1 X177.22 Y160.887
G1 X177.22 Y161.42
G1 X177.086 Y161.287
G1 X174.554 Y158.754 E.10669
G1 X174.42 Y158.62
G1 X174.42 Y159.154
G1 X174.554 Y159.287
G1 X177.086 Y161.82 E.10669
G1 X177.22 Y161.954
G1 X177.22 Y162.487
G1 X177.086 Y162.353
G1 X174.554 Y159.82 E.10669
G1 X174.42 Y159.687
G1 X174.42 Y160.22
G1 X174.554 Y160.354
G1 X177.086 Y162.886 E.10669
G1 X177.22 Y163.02
G1 X177.22 Y163.553
G1 X177.086 Y163.42
G1 X174.554 Y160.887 E.10669
G1 X174.42 Y160.753
G1 X174.42 Y161.287
G1 X174.554 Y161.42
G1 X177.086 Y163.953 E.10669
G1 X177.22 Y164.087
G1 X177.22 Y164.62
G1 X177.086 Y164.486
G1 X174.554 Y161.953 E.10669
G1 X174.42 Y161.82
G1 X174.42 Y162.353
G1 X174.554 Y162.487
G1 X177.086 Y165.019 E.10669
G1 X177.22 Y165.153
G1 X177.22 Y165.686
G1 X177.086 Y165.553
G1 X174.554 Y163.02 E.10669
G1 X174.42 Y162.886
G1 X174.42 Y163.42
G1 X174.554 Y163.553
G1 X177.086 Y166.086 E.10669
G1 X177.22 Y166.22
G1 X177.22 Y166.753
G1 X177.086 Y166.619
G1 X174.554 Y164.087 E.10669
G1 X174.42 Y163.953
G1 X174.42 Y164.486
G1 X174.554 Y164.62
G1 X177.086 Y167.152 E.10669
G1 X177.22 Y167.286
G1 X177.22 Y167.819
G1 X177.086 Y167.686
G1 X174.554 Y165.153 E.10669
G1 X174.42 Y165.019
G1 X174.42 Y165.553
G1 X174.554 Y165.686
G1 X177.086 Y168.219 E.10669
G1 X177.22 Y168.353
G1 X176.829 Y168.495
G1 X176.696 Y168.361
G1 X174.554 Y166.22 E.09023
G1 X174.42 Y166.086
G1 X174.42 Y166.619
G1 X174.554 Y166.753
G1 X176.162 Y168.361 E.06776
G1 X176.296 Y168.495
G1 X175.763 Y168.495
G1 X175.629 Y168.361
G1 X174.554 Y167.286 E.0453
G1 X174.42 Y167.152
G1 X174.42 Y167.686
G1 X174.554 Y167.819
G1 X175.096 Y168.361 E.02284
; CHANGE_LAYER
; Z_HEIGHT: 14.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9547.055
M204 S8000
G1 X174.554 Y167.819 E-.29134
G1 X174.42 Y167.686 E-.07182
G1 X174.42 Y167.152 E-.20264
G1 X174.554 Y167.286 E-.07182
G1 X174.781 Y167.514 E-.12239
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 74/100
; update layer progress
M73 L74
M991 S0 P73 ;notify layer change

M106 S226.95
; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z15 I1.217 J-.002 P1  F60000
G1 X174.759 Y151.416 Z15
G1 Z14.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1527
M204 S8000
G1 X174.759 Y168.584 E.55205
G1 X172.782 Y168.584 E.06358
G1 X172.782 Y151.416 E.55205
G1 X174.699 Y151.416 E.06165
; COOLING_NODE: 0
M204 S10000
M73 P79 R5
G1 X175.166 Y151.009 F60000
G1 F1527
M204 S8000
G1 X175.166 Y168.991 E.57823
G1 X172.375 Y168.991 E.08976
G1 X172.375 Y151.009 E.57823
G1 X175.106 Y151.009 E.08783
; COOLING_NODE: 0
M204 S10000
G1 X175.573 Y150.602 F60000
G1 F1527
M204 S8000
G1 X175.573 Y169.398 E.60441
G1 X171.968 Y169.398 E.11594
G1 X171.968 Y150.602 E.60441
G1 X175.513 Y150.602 E.11401
; COOLING_NODE: 0
M204 S250
G1 X175.965 Y150.21 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1514
M204 S5000
G1 X175.965 Y169.79 E.58322
G1 X171.576 Y169.79 E.13075
G1 X171.576 Y150.21 E.58322
G1 X175.905 Y150.21 E.12896
; WIPE_START
G1 F9547.055
M204 S8000
G1 X175.911 Y152.21 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X173.13 Y152.033 Z15.2 F60000
G1 Z14.8
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F1527
M204 S8000
G1 X173.13 Y153.662 E.05236
G3 X174.227 Y152.673 I2.165 J1.3 E.04817
G1 X174.411 Y152.677 E.00591
G1 X174.411 Y155.723 E.09795
G1 X174.227 Y155.858 E.00733
G3 X173.362 Y156.772 I-2.741 J-1.728 E.04071
G1 X173.13 Y156.835 E.00774
G1 X173.13 Y158.903 E.06649
G3 X174.227 Y157.915 I2.165 J1.3 E.04817
G1 X174.411 Y157.919 E.00591
G1 X174.411 Y160.965 E.09795
G1 X174.227 Y161.1 E.00733
G3 X173.362 Y162.013 I-2.741 J-1.728 E.04071
G1 X173.13 Y162.077 E.00774
G1 X173.13 Y164.144 E.06649
G3 X174.227 Y163.156 I2.165 J1.3 E.04817
G1 X174.411 Y163.16 E.00591
G1 X174.411 Y166.206 E.09795
G1 X174.227 Y166.341 E.00733
G3 X173.362 Y167.254 I-2.741 J-1.728 E.04071
G1 X173.13 Y167.318 E.00774
G1 X173.13 Y168.236 E.02951
G1 X173.841 Y168.236 E.02285
; COOLING_NODE: 0
; WIPE_START
G1 F8843.478
G1 X173.13 Y168.236 E-.27004
G1 X173.13 Y167.318 E-.34873
G1 X173.362 Y167.254 E-.09145
G1 X173.464 Y167.172 E-.04979
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X177.277 Y169.398 Z15.2 F60000
G1 Z14.8
G1 E.8 F1800
; FEATURE: Inner wall
G1 F1527
M204 S8000
G1 X177.277 Y150.602 E.60441
G1 X178.073 Y150.602 E.02559
G1 X178.073 Y169.398 E.60441
G1 X177.337 Y169.398 E.02366
; COOLING_NODE: 0
M204 S250
G1 X176.885 Y169.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1514
M204 S5000
G1 X176.885 Y150.21 E.58322
G1 X178.465 Y150.21 E.04706
G1 X178.465 Y169.79 E.58322
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X176.945 Y169.79 E.04528
M204 S10000
G1 X177.675 Y169.194 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1527
M204 S8000
G1 X177.675 Y150.806 E.56476
; CHANGE_LAYER
; Z_HEIGHT: 15
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.259
G1 X177.675 Y152.806 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 75/100
; update layer progress
M73 L75
M991 S0 P74 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z15.2 I.523 J-1.099 P1  F60000
G1 X174.759 Y151.416 Z15.2
G1 Z15
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1561
M204 S8000
G1 X174.759 Y168.584 E.55205
G1 X172.783 Y168.584 E.06354
G1 X172.783 Y151.416 E.55205
G1 X174.699 Y151.416 E.06161
; COOLING_NODE: 0
M204 S10000
G1 X175.166 Y151.009 F60000
G1 F1561
M204 S8000
G1 X175.166 Y168.991 E.57823
G1 X172.376 Y168.991 E.08972
G1 X172.376 Y151.009 E.57823
G1 X175.106 Y151.009 E.08779
; COOLING_NODE: 0
M204 S10000
G1 X175.573 Y150.602 F60000
G1 F1561
M204 S8000
G1 X175.573 Y169.398 E.60441
M73 P80 R5
G1 X171.969 Y169.398 E.1159
G1 X171.969 Y150.602 E.60441
G1 X175.513 Y150.602 E.11397
; COOLING_NODE: 0
M204 S250
G1 X175.965 Y150.21 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1510
M204 S5000
G1 X175.965 Y169.79 E.58322
G1 X171.577 Y169.79 E.13071
G1 X171.577 Y150.21 E.58322
G1 X175.905 Y150.21 E.12892
; WIPE_START
G1 F9547.055
M204 S8000
G1 X175.911 Y152.21 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X173.131 Y153.328 Z15.4 F60000
G1 Z15
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F1561
M204 S8000
G1 X173.131 Y151.84 E.04786
G2 X173.53 Y151.764 I.147 J-.315 E.01393
G1 X174.411 Y151.764 E.02832
G1 X174.411 Y152.476 E.02286
G2 X173.69 Y152.605 I-.263 J.606 E.02496
G1 X173.131 Y153.532 E.0348
G1 X173.131 Y155.16 E.05236
; WIPE_START
G1 F8843.478
G1 X173.131 Y153.532 E-.61876
G1 X173.323 Y153.214 E-.14124
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X174.411 Y154.169 Z15.4 F60000
G1 Z15
G1 E.8 F1800
G1 F1561
M204 S8000
G1 X174.411 Y155.797 E.05236
G1 X174.227 Y155.982 E.00838
G1 X173.69 Y156.913 E.03456
G3 X173.131 Y157.081 I-.397 J-.304 E.02003
G1 X173.131 Y158.773 E.0544
G1 X173.69 Y157.846 E.0348
G3 X174.411 Y157.717 I.458 J.476 E.02496
G1 X174.411 Y161.038 E.10681
G1 X174.227 Y161.223 E.00838
G1 X173.69 Y162.154 E.03456
G3 X173.131 Y162.323 I-.397 J-.304 E.02003
G1 X173.131 Y164.015 E.0544
G1 X173.69 Y163.088 E.0348
G3 X174.411 Y162.958 I.458 J.476 E.02496
G1 X174.411 Y166.28 E.10681
G1 X174.227 Y166.464 E.00838
G1 X173.69 Y167.395 E.03456
G3 X173.131 Y167.564 I-.397 J-.304 E.02003
G1 X173.131 Y168.236 E.02159
G1 X173.827 Y168.236 E.02238
G3 X174.411 Y168.199 I.326 J.535 E.01955
G1 X174.411 Y166.571 E.05236
; COOLING_NODE: 0
; WIPE_START
G1 F8843.478
G1 X174.411 Y168.199 E-.61876
G1 X174.041 Y168.156 E-.14124
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X177.277 Y169.398 Z15.4 F60000
G1 Z15
G1 E.8 F1800
; FEATURE: Inner wall
G1 F1561
M204 S8000
G1 X177.277 Y150.602 E.60441
G1 X178.073 Y150.602 E.02559
G1 X178.073 Y169.398 E.60441
G1 X177.337 Y169.398 E.02366
; COOLING_NODE: 0
M204 S250
G1 X176.885 Y169.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1510
M204 S5000
G1 X176.885 Y150.21 E.58322
G1 X178.465 Y150.21 E.04706
G1 X178.465 Y169.79 E.58322
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X176.945 Y169.79 E.04528
M204 S10000
G1 X177.675 Y169.194 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1561
M204 S8000
G1 X177.675 Y150.806 E.56476
; CHANGE_LAYER
; Z_HEIGHT: 15.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.259
G1 X177.675 Y152.806 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 76/100
; update layer progress
M73 L76
M991 S0 P75 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z15.4 I.523 J-1.099 P1  F60000
G1 X174.759 Y151.416 Z15.4
G1 Z15.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1561
M204 S8000
G1 X174.759 Y168.584 E.55205
G1 X172.784 Y168.584 E.0635
G1 X172.784 Y151.416 E.55205
G1 X174.699 Y151.416 E.06157
; COOLING_NODE: 0
M204 S10000
G1 X175.166 Y151.009 F60000
G1 F1561
M204 S8000
M73 P80 R4
G1 X175.166 Y168.991 E.57823
G1 X172.377 Y168.991 E.08968
G1 X172.377 Y151.009 E.57823
G1 X175.106 Y151.009 E.08775
; COOLING_NODE: 0
M204 S10000
G1 X175.573 Y150.602 F60000
G1 F1561
M204 S8000
G1 X175.573 Y169.398 E.60441
G1 X171.97 Y169.398 E.11586
G1 X171.97 Y150.602 E.60441
G1 X175.513 Y150.602 E.11393
; COOLING_NODE: 0
M204 S250
G1 X175.965 Y150.21 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1496
M204 S5000
G1 X175.965 Y169.79 E.58322
G1 X171.578 Y169.79 E.13067
G1 X171.578 Y150.21 E.58322
G1 X175.905 Y150.21 E.12889
; WIPE_START
G1 F9547.055
M204 S8000
G1 X175.911 Y152.21 E-.76
; WIPE_END
M73 P81 R4
G1 E-.04 F1800
M204 S10000
G1 X174.352 Y159.681 Z15.6 F60000
G1 X173.132 Y165.524 Z15.6
G1 Z15.2
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F1561
M204 S8000
G1 X173.132 Y163.895 E.05236
G2 X173.291 Y162.948 I-1.285 J-.703 E.03146
G1 X173.132 Y162.726 E.00879
G1 X173.132 Y158.654 E.13094
G2 X173.291 Y157.707 I-1.285 J-.703 E.03146
G1 X173.132 Y157.485 E.00879
G1 X173.132 Y153.413 E.13094
G2 X173.291 Y152.466 I-1.285 J-.703 E.03146
G1 X173.132 Y152.243 E.00879
G1 X173.132 Y151.764 E.0154
G1 X174.085 Y151.764 E.03064
G1 X174.088 Y151.811 E.00149
G3 X174.411 Y152.269 I-8.223 J6.125 E.01803
G1 X174.411 Y155.858 E.11539
G1 X174.257 Y156.069 E.0084
G2 X174.088 Y157.052 I1.331 J.735 E.03267
G3 X174.411 Y157.511 I-8.223 J6.125 E.01803
G1 X174.411 Y161.099 E.11539
G1 X174.257 Y161.31 E.0084
G2 X174.088 Y162.293 I1.331 J.735 E.03267
G3 X174.411 Y162.752 I-8.228 J6.128 E.01804
G1 X174.411 Y166.34 E.11539
G1 X174.257 Y166.552 E.0084
G2 X174.088 Y167.535 I1.331 J.735 E.03267
G3 X174.411 Y168.236 I-.523 J.665 E.02577
G1 X173.132 Y168.236 E.0411
G1 X173.132 Y168.128 E.00347
; COOLING_NODE: 0
; WIPE_START
G1 F8843.478
G1 X173.132 Y168.236 E-.04101
G1 X174.411 Y168.236 E-.48567
G1 X174.411 Y167.993 E-.09208
G1 X174.197 Y167.689 E-.14124
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X177.277 Y169.398 Z15.6 F60000
G1 Z15.2
G1 E.8 F1800
; FEATURE: Inner wall
G1 F1561
M204 S8000
G1 X177.277 Y150.602 E.60441
G1 X178.073 Y150.602 E.02559
G1 X178.073 Y169.398 E.60441
G1 X177.337 Y169.398 E.02366
; COOLING_NODE: 0
M204 S250
G1 X176.885 Y169.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1496
M204 S5000
G1 X176.885 Y150.21 E.58322
G1 X178.465 Y150.21 E.04706
G1 X178.465 Y169.79 E.58322
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X176.945 Y169.79 E.04528
M204 S10000
G1 X177.675 Y169.194 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1561
M204 S8000
G1 X177.675 Y150.806 E.56476
; CHANGE_LAYER
; Z_HEIGHT: 15.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.259
G1 X177.675 Y152.806 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 77/100
; update layer progress
M73 L77
M991 S0 P76 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z15.6 I.523 J-1.099 P1  F60000
G1 X174.759 Y151.416 Z15.6
G1 Z15.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1467
M204 S8000
G1 X174.759 Y168.584 E.55205
G1 X172.785 Y168.584 E.06346
G1 X172.785 Y151.416 E.55205
G1 X174.699 Y151.416 E.06153
; COOLING_NODE: 0
M204 S10000
G1 X175.166 Y151.009 F60000
G1 F1467
M204 S8000
G1 X175.166 Y168.991 E.57823
G1 X172.378 Y168.991 E.08964
G1 X172.378 Y151.009 E.57823
G1 X175.106 Y151.009 E.08771
; COOLING_NODE: 0
M204 S10000
G1 X175.573 Y150.602 F60000
G1 F1467
M204 S8000
G1 X175.573 Y169.398 E.60441
G1 X171.971 Y169.398 E.11582
G1 X171.971 Y150.602 E.60441
G1 X175.513 Y150.602 E.11389
; COOLING_NODE: 0
M204 S250
G1 X175.965 Y150.21 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1467
M204 S5000
G1 X175.965 Y169.79 E.58322
G1 X171.579 Y169.79 E.13064
G1 X171.579 Y150.21 E.58322
G1 X175.905 Y150.21 E.12885
; WIPE_START
G1 F9547.055
M204 S8000
G1 X175.911 Y152.21 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X174.411 Y154.25 Z15.8 F60000
G1 Z15.4
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F1467
M204 S8000
G1 X174.411 Y155.879 E.05236
G1 X174.313 Y156.069 E.00689
G1 X174.262 Y156.724 E.02113
G2 X174.411 Y157.094 I.561 J-.01 E.01309
G1 X174.411 Y161.12 E.12946
G1 X174.313 Y161.31 E.00689
G1 X174.262 Y161.966 E.02113
G2 X174.411 Y162.335 I.561 J-.01 E.01309
G1 X174.411 Y166.361 E.12946
G1 X174.313 Y166.552 E.00689
G1 X174.262 Y167.207 E.02113
G3 X174.411 Y168.236 I-1.415 J.729 E.03404
G1 X173.441 Y168.236 E.03117
; COOLING_NODE: 0
; WIPE_START
G1 F8843.478
G1 X174.411 Y168.236 E-.36838
G1 X174.411 Y167.577 E-.25038
G1 X174.272 Y167.232 E-.14124
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X177.277 Y169.398 Z15.8 F60000
G1 Z15.4
G1 E.8 F1800
; FEATURE: Inner wall
G1 F1467
M204 S8000
G1 X177.277 Y150.602 E.60441
G1 X178.073 Y150.602 E.02559
G1 X178.073 Y169.398 E.60441
G1 X177.337 Y169.398 E.02366
; COOLING_NODE: 0
M204 S250
M73 P82 R4
G1 X176.885 Y169.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1467
M204 S5000
G1 X176.885 Y150.21 E.58322
G1 X178.465 Y150.21 E.04706
G1 X178.465 Y169.79 E.58322
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X176.945 Y169.79 E.04528
M204 S10000
G1 X177.675 Y169.194 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1467
M204 S8000
G1 X177.675 Y150.806 E.56476
; CHANGE_LAYER
; Z_HEIGHT: 15.6
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F9259.259
G1 X177.675 Y152.806 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 78/100
; update layer progress
M73 L78
M991 S0 P77 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z15.8 I.523 J-1.099 P1  F60000
G1 X174.759 Y151.416 Z15.8
G1 Z15.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1464
M204 S8000
G1 X174.759 Y168.584 E.55205
G1 X172.787 Y168.584 E.06342
G1 X172.787 Y151.416 E.55205
G1 X174.699 Y151.416 E.06149
; COOLING_NODE: 0
M204 S10000
G1 X175.166 Y151.009 F60000
G1 F1464
M204 S8000
G1 X175.166 Y168.991 E.57823
G1 X172.38 Y168.991 E.0896
G1 X172.38 Y151.009 E.57823
G1 X175.106 Y151.009 E.08767
; COOLING_NODE: 0
M204 S10000
G1 X175.573 Y150.602 F60000
G1 F1464
M204 S8000
G1 X175.573 Y169.398 E.60441
G1 X171.973 Y169.398 E.11578
G1 X171.973 Y150.602 E.60441
G1 X175.513 Y150.602 E.11385
; COOLING_NODE: 0
M204 S250
G1 X175.965 Y150.21 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1464
M204 S5000
G1 X175.965 Y169.79 E.58322
G1 X171.58 Y169.79 E.1306
G1 X171.58 Y150.21 E.58322
G1 X175.905 Y150.21 E.12881
; WIPE_START
G1 F9547.055
M204 S8000
G1 X175.911 Y152.21 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X174.411 Y154.226 Z16 F60000
G1 Z15.6
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F1464
M204 S8000
G1 X174.411 Y155.854 E.05236
G1 X174.34 Y156.069 E.00728
G1 X174.411 Y156.725 E.0212
G1 X174.411 Y161.095 E.14054
G1 X174.34 Y161.31 E.00728
G1 X174.411 Y161.966 E.0212
G1 X174.411 Y166.337 E.14054
G1 X174.34 Y166.552 E.00728
G1 X174.411 Y167.207 E.0212
G1 X174.411 Y168.236 E.03307
G1 X173.811 Y168.236 E.01929
; COOLING_NODE: 0
; WIPE_START
G1 F8843.478
G1 X174.411 Y168.236 E-.228
G1 X174.411 Y167.207 E-.39076
G1 X174.371 Y166.838 E-.14124
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X177.277 Y169.398 Z16 F60000
G1 Z15.6
G1 E.8 F1800
; FEATURE: Inner wall
G1 F1464
M204 S8000
G1 X177.277 Y150.602 E.60441
G1 X178.073 Y150.602 E.02559
G1 X178.073 Y169.398 E.60441
G1 X177.337 Y169.398 E.02366
; COOLING_NODE: 0
M204 S250
G1 X176.885 Y169.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1464
M204 S5000
G1 X176.885 Y150.21 E.58322
G1 X178.465 Y150.21 E.04706
G1 X178.465 Y169.79 E.58322
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X176.945 Y169.79 E.04528
M204 S10000
G1 X177.675 Y169.194 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1464
M204 S8000
G1 X177.675 Y150.806 E.56476
; CHANGE_LAYER
; Z_HEIGHT: 15.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.259
G1 X177.675 Y152.806 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 79/100
; update layer progress
M73 L79
M991 S0 P78 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
M73 P83 R4
G3 Z16 I.523 J-1.099 P1  F60000
G1 X174.759 Y151.416 Z16
G1 Z15.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1463
M204 S8000
G1 X174.759 Y168.584 E.55205
G1 X172.788 Y168.584 E.06338
G1 X172.788 Y151.416 E.55205
G1 X174.699 Y151.416 E.06145
; COOLING_NODE: 0
M204 S10000
G1 X175.166 Y151.009 F60000
G1 F1463
M204 S8000
G1 X175.166 Y168.991 E.57823
G1 X172.381 Y168.991 E.08956
G1 X172.381 Y151.009 E.57823
G1 X175.106 Y151.009 E.08763
; COOLING_NODE: 0
M204 S10000
G1 X175.573 Y150.602 F60000
G1 F1463
M204 S8000
G1 X175.573 Y169.398 E.60441
G1 X171.974 Y169.398 E.11574
G1 X171.974 Y150.602 E.60441
G1 X175.513 Y150.602 E.11381
; COOLING_NODE: 0
M204 S250
G1 X175.965 Y150.21 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1463
M204 S5000
G1 X175.965 Y169.79 E.58322
G1 X171.582 Y169.79 E.13057
G1 X171.582 Y150.21 E.58322
G1 X175.905 Y150.21 E.12878
; WIPE_START
G1 F9547.055
M204 S8000
G1 X175.911 Y152.21 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X174.411 Y153.99 Z16.2 F60000
G1 Z15.8
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F1463
M204 S8000
G1 X174.411 Y155.618 E.05236
G2 X174.411 Y156.307 I.762 J.344 E.02283
G1 X174.411 Y160.859 E.14639
G2 X174.411 Y161.548 I.762 J.344 E.02283
G1 X174.411 Y166.101 E.14639
G2 X174.411 Y166.789 I.762 J.344 E.02283
G1 X174.411 Y168.236 E.04651
G1 X174.228 Y168.236 E.00585
; COOLING_NODE: 0
; WIPE_START
G1 F8843.478
G1 X174.411 Y168.236 E-.06918
G1 X174.411 Y166.789 E-.54958
G1 X174.343 Y166.552 E-.09382
G1 X174.362 Y166.428 E-.04742
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X177.277 Y169.398 Z16.2 F60000
G1 Z15.8
G1 E.8 F1800
; FEATURE: Inner wall
G1 F1463
M204 S8000
G1 X177.277 Y150.602 E.60441
G1 X178.073 Y150.602 E.02559
G1 X178.073 Y169.398 E.60441
G1 X177.337 Y169.398 E.02366
; COOLING_NODE: 0
M204 S250
G1 X176.885 Y169.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1463
M204 S5000
G1 X176.885 Y150.21 E.58322
G1 X178.465 Y150.21 E.04706
G1 X178.465 Y169.79 E.58322
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X176.945 Y169.79 E.04528
M204 S10000
G1 X177.675 Y169.194 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1463
M204 S8000
G1 X177.675 Y150.806 E.56476
; CHANGE_LAYER
; Z_HEIGHT: 16
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.259
G1 X177.675 Y152.806 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 80/100
; update layer progress
M73 L80
M991 S0 P79 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z16.2 I.523 J-1.099 P1  F60000
G1 X174.759 Y151.416 Z16.2
G1 Z16
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1466
M204 S8000
G1 X174.759 Y168.584 E.55205
G1 X172.789 Y168.584 E.06334
G1 X172.789 Y151.416 E.55205
G1 X174.699 Y151.416 E.06141
; COOLING_NODE: 0
M204 S10000
G1 X175.166 Y151.009 F60000
G1 F1466
M204 S8000
G1 X175.166 Y168.991 E.57823
G1 X172.382 Y168.991 E.08952
G1 X172.382 Y151.009 E.57823
G1 X175.106 Y151.009 E.08759
; COOLING_NODE: 0
M204 S10000
G1 X175.573 Y150.602 F60000
G1 F1466
M204 S8000
M73 P84 R4
G1 X175.573 Y169.398 E.60441
G1 X171.975 Y169.398 E.1157
G1 X171.975 Y150.602 E.60441
G1 X175.513 Y150.602 E.11377
; COOLING_NODE: 0
M204 S250
G1 X175.965 Y150.21 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1459
M204 S5000
G1 X175.965 Y169.79 E.58322
G1 X171.583 Y169.79 E.13053
G1 X171.583 Y150.21 E.58322
G1 X175.905 Y150.21 E.12874
; WIPE_START
G1 F9547.055
M204 S8000
G1 X175.911 Y152.21 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X174.411 Y153.508 Z16.4 F60000
G1 Z16
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F1466
M204 S8000
G1 X174.411 Y155.136 E.05236
G1 X174.301 Y155.414 E.0096
G1 X174.322 Y156.069 E.02108
G1 X174.411 Y156.259 E.00675
G1 X174.411 Y160.378 E.13242
G1 X174.301 Y160.655 E.0096
G1 X174.322 Y161.31 E.02108
G1 X174.411 Y161.501 E.00675
G1 X174.411 Y165.619 E.13242
G1 X174.301 Y165.897 E.0096
G1 X174.322 Y166.552 E.02108
G1 X174.411 Y166.742 E.00675
G1 X174.411 Y168.236 E.04803
G1 X174.276 Y168.236 E.00433
; COOLING_NODE: 0
; WIPE_START
G1 F8843.478
G1 X174.411 Y168.236 E-.0512
G1 X174.411 Y166.742 E-.56756
G1 X174.322 Y166.552 E-.07979
G1 X174.317 Y166.39 E-.06146
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X177.277 Y169.398 Z16.4 F60000
G1 Z16
G1 E.8 F1800
; FEATURE: Inner wall
G1 F1466
M204 S8000
G1 X177.277 Y150.602 E.60441
G1 X178.073 Y150.602 E.02559
G1 X178.073 Y169.398 E.60441
G1 X177.337 Y169.398 E.02366
; COOLING_NODE: 0
M204 S250
G1 X176.885 Y169.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1459
M204 S5000
G1 X176.885 Y150.21 E.58322
G1 X178.465 Y150.21 E.04706
G1 X178.465 Y169.79 E.58322
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X176.945 Y169.79 E.04528
M204 S10000
G1 X177.675 Y169.194 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1466
M204 S8000
M73 P84 R3
G1 X177.675 Y150.806 E.56476
; CHANGE_LAYER
; Z_HEIGHT: 16.2
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F9259.259
G1 X177.675 Y152.806 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 81/100
; update layer progress
M73 L81
M991 S0 P80 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z16.4 I.523 J-1.099 P1  F60000
G1 X174.759 Y151.416 Z16.4
G1 Z16.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1559
M204 S8000
G1 X174.759 Y168.584 E.55205
G1 X172.79 Y168.584 E.0633
G1 X172.79 Y151.416 E.55205
G1 X174.699 Y151.416 E.06137
; COOLING_NODE: 0
M204 S10000
G1 X175.166 Y151.009 F60000
G1 F1559
M204 S8000
G1 X175.166 Y168.991 E.57823
G1 X172.383 Y168.991 E.08948
G1 X172.383 Y151.009 E.57823
G1 X175.106 Y151.009 E.08755
; COOLING_NODE: 0
M204 S10000
G1 X175.573 Y150.602 F60000
G1 F1559
M204 S8000
G1 X175.573 Y169.398 E.60441
G1 X171.976 Y169.398 E.11566
G1 X171.976 Y150.602 E.60441
G1 X175.513 Y150.602 E.11373
; COOLING_NODE: 0
M204 S250
G1 X175.965 Y150.21 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1438
M204 S5000
G1 X175.965 Y169.79 E.58322
G1 X171.584 Y169.79 E.13049
G1 X171.584 Y150.21 E.58322
G1 X175.905 Y150.21 E.1287
; WIPE_START
M73 P85 R3
G1 F9547.055
M204 S8000
G1 X175.911 Y152.21 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X173.139 Y151.96 Z16.6 F60000
G1 Z16.2
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F1559
M204 S8000
G1 X173.139 Y153.588 E.05236
G3 X173.139 Y154.526 I-.866 J.469 E.03145
G1 X173.139 Y158.829 E.13837
G3 X173.139 Y159.768 I-.866 J.469 E.03145
G1 X173.139 Y164.071 E.13837
G3 X173.139 Y165.009 I-.866 J.469 E.03145
G1 X173.139 Y168.236 E.10376
G1 X174.411 Y168.236 E.0409
G1 X174.411 Y166.756 E.04757
G1 X174.273 Y166.552 E.00792
G1 X174.121 Y165.897 E.02163
G3 X174.411 Y165.252 I.722 J-.063 E.02374
G1 X174.411 Y161.515 E.12017
G1 X174.273 Y161.31 E.00792
G1 X174.121 Y160.655 E.02163
G3 X174.411 Y160.011 I.722 J-.063 E.02374
G1 X174.411 Y156.274 E.12017
G1 X174.273 Y156.069 E.00792
G1 X174.121 Y155.414 E.02163
G3 X174.411 Y154.769 I.722 J-.063 E.02374
G1 X174.411 Y153.141 E.05236
; COOLING_NODE: 0
; WIPE_START
G1 F8843.478
G1 X174.411 Y154.769 E-.61876
G1 X174.185 Y155.065 E-.14124
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.794 Y162.525 Z16.6 F60000
G1 X177.277 Y169.398 Z16.6
G1 Z16.2
G1 E.8 F1800
; FEATURE: Inner wall
G1 F1559
M204 S8000
G1 X177.277 Y150.602 E.60441
G1 X178.073 Y150.602 E.02559
G1 X178.073 Y169.398 E.60441
G1 X177.337 Y169.398 E.02366
; COOLING_NODE: 0
M204 S250
G1 X176.885 Y169.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1438
M204 S5000
G1 X176.885 Y150.21 E.58322
G1 X178.465 Y150.21 E.04706
G1 X178.465 Y169.79 E.58322
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X176.945 Y169.79 E.04528
M204 S10000
G1 X177.675 Y169.194 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1559
M204 S8000
G1 X177.675 Y150.806 E.56476
; CHANGE_LAYER
; Z_HEIGHT: 16.4
; LAYER_HEIGHT: 0.199999
; WIPE_START
G1 F9259.259
G1 X177.675 Y152.806 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 82/100
; update layer progress
M73 L82
M991 S0 P81 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z16.6 I.523 J-1.099 P1  F60000
G1 X174.759 Y151.416 Z16.6
G1 Z16.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1526
M204 S8000
G1 X174.759 Y168.584 E.55205
G1 X172.792 Y168.584 E.06326
G1 X172.792 Y151.416 E.55205
G1 X174.699 Y151.416 E.06133
; COOLING_NODE: 0
M204 S10000
G1 X175.166 Y151.009 F60000
G1 F1526
M204 S8000
G1 X175.166 Y168.991 E.57823
G1 X172.385 Y168.991 E.08944
G1 X172.385 Y151.009 E.57823
G1 X175.106 Y151.009 E.08751
; COOLING_NODE: 0
M204 S10000
G1 X175.573 Y150.602 F60000
G1 F1526
M204 S8000
G1 X175.573 Y169.398 E.60441
G1 X171.977 Y169.398 E.11562
G1 X171.977 Y150.602 E.60441
G1 X175.513 Y150.602 E.11369
; COOLING_NODE: 0
M204 S250
G1 X175.965 Y150.21 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1392
M204 S5000
G1 X175.965 Y169.79 E.58322
G1 X171.585 Y169.79 E.13045
G1 X171.585 Y150.21 E.58322
G1 X175.905 Y150.21 E.12867
; WIPE_START
G1 F9547.055
M204 S8000
G1 X175.911 Y152.21 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X174.411 Y152.853 Z16.8 F60000
G1 Z16.4
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F1526
M204 S8000
G1 X174.411 Y154.481 E.05236
G3 X173.69 Y154.497 I-.375 J-.68 E.02411
G2 X173.14 Y153.403 I-5.992 J2.328 E.03941
G1 X173.14 Y154.978 E.05065
G3 X173.69 Y155.021 I.24 J.475 E.01864
G1 X174.227 Y156.124 E.03946
G1 X174.411 Y156.323 E.00871
G1 X174.411 Y159.723 E.10931
G3 X173.69 Y159.738 I-.375 J-.68 E.02411
G2 X173.14 Y158.645 I-5.992 J2.328 E.03941
G1 X173.14 Y160.22 E.05065
G3 X173.69 Y160.262 I.24 J.475 E.01864
G1 X174.227 Y161.365 E.03946
G1 X174.411 Y161.565 E.00871
G1 X174.411 Y164.964 E.10931
G3 X173.69 Y164.979 I-.375 J-.68 E.02411
G2 X173.14 Y163.886 I-5.992 J2.328 E.03941
G1 X173.14 Y165.461 E.05065
G3 X173.69 Y165.504 I.24 J.475 E.01864
G1 X174.227 Y166.607 E.03946
G1 X174.411 Y166.806 E.00871
G1 X174.411 Y168.236 E.04597
G1 X174.212 Y168.236 E.00639
; COOLING_NODE: 0
; WIPE_START
G1 F8843.478
G1 X174.411 Y168.236 E-.07548
M73 P86 R3
G1 X174.411 Y166.806 E-.54327
G1 X174.227 Y166.607 E-.10296
G1 X174.183 Y166.516 E-.03828
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X177.277 Y169.398 Z16.8 F60000
G1 Z16.4
G1 E.8 F1800
; FEATURE: Inner wall
G1 F1526
M204 S8000
G1 X177.277 Y150.602 E.60441
G1 X178.073 Y150.602 E.02559
G1 X178.073 Y169.398 E.60441
G1 X177.337 Y169.398 E.02366
; COOLING_NODE: 0
M204 S250
G1 X176.885 Y169.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1392
M204 S5000
G1 X176.885 Y150.21 E.58322
G1 X178.465 Y150.21 E.04706
G1 X178.465 Y169.79 E.58322
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X176.945 Y169.79 E.04528
M204 S10000
G1 X177.675 Y169.194 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1526
M204 S8000
G1 X177.675 Y150.806 E.56476
; CHANGE_LAYER
; Z_HEIGHT: 16.6
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F9259.259
G1 X177.675 Y152.806 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 83/100
; update layer progress
M73 L83
M991 S0 P82 ;notify layer change

M106 S221.85
; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z16.8 I.523 J-1.099 P1  F60000
G1 X174.759 Y151.416 Z16.8
G1 Z16.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1714
M204 S8000
G1 X174.759 Y168.584 E.55205
G1 X172.793 Y168.584 E.06322
G1 X172.793 Y151.416 E.55205
G1 X174.699 Y151.416 E.06129
; COOLING_NODE: 0
M204 S10000
G1 X175.166 Y151.009 F60000
G1 F1714
M204 S8000
G1 X175.166 Y168.991 E.57823
G1 X172.386 Y168.991 E.0894
G1 X172.386 Y151.009 E.57823
G1 X175.106 Y151.009 E.08747
; COOLING_NODE: 0
M204 S10000
G1 X175.573 Y150.602 F60000
G1 F1714
M204 S8000
G1 X175.573 Y169.398 E.60441
G1 X171.979 Y169.398 E.11558
G1 X171.979 Y150.602 E.60441
G1 X175.513 Y150.602 E.11365
; COOLING_NODE: 0
M204 S250
G1 X175.965 Y150.21 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1332
M204 S5000
G1 X175.965 Y169.79 E.58322
G1 X171.587 Y169.79 E.13042
G1 X171.587 Y150.21 E.58322
G1 X175.905 Y150.21 E.12863
; WIPE_START
G1 F9547.055
M204 S8000
G1 X175.911 Y152.21 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X174.411 Y152.634 Z17 F60000
G1 Z16.6
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F1714
M204 S8000
G1 X174.411 Y154.262 E.05236
G1 X174.227 Y154.276 E.00593
G1 X173.69 Y153.958 E.02007
G1 X173.141 Y153.277 E.02812
G1 X173.141 Y155.254 E.06359
G3 X173.69 Y155.56 I-.031 J.702 E.02093
G1 X174.227 Y156.252 E.02816
G1 X174.411 Y156.397 E.00754
G1 X174.411 Y159.503 E.09989
G1 X174.227 Y159.517 E.00593
G1 X173.69 Y159.199 E.02007
G1 X173.141 Y158.518 E.02812
G1 X173.141 Y160.496 E.06359
G3 X173.69 Y160.801 I-.031 J.702 E.02093
G1 X174.227 Y161.493 E.02816
G1 X174.411 Y161.638 E.00754
G1 X174.411 Y164.745 E.09989
G1 X174.227 Y164.759 E.00593
G1 X173.69 Y164.44 E.02007
G1 X173.141 Y163.759 E.02812
G1 X173.141 Y165.737 E.06359
G3 X173.69 Y166.042 I-.031 J.702 E.02093
G1 X174.227 Y166.734 E.02816
G1 X174.411 Y166.88 E.00754
G1 X174.411 Y168.236 E.0436
G1 X174.138 Y168.236 E.00876
; COOLING_NODE: 0
; WIPE_START
G1 F8843.478
G1 X174.411 Y168.236 E-.10352
G1 X174.411 Y166.88 E-.51524
G1 X174.227 Y166.734 E-.08907
G1 X174.143 Y166.626 E-.05217
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X176.885 Y169.79 Z17 F60000
G1 Z16.6
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1332
M204 S5000
G1 X176.885 Y150.21 E.58322
G1 X178.465 Y150.21 E.04706
G1 X178.465 Y169.79 E.58322
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X176.945 Y169.79 E.04528
; WIPE_START
G1 F9547.055
M204 S8000
G1 X176.939 Y167.79 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X177.546 Y160.182 Z17 F60000
G1 X178.258 Y151.259 Z17
G1 Z16.6
G1 E.8 F1800
; FEATURE: Top surface
G1 F1714
M204 S2000
G1 X177.416 Y150.417 E.03547
G1 X177.282 Y150.284
G1 X176.959 Y150.494
G1 X177.092 Y150.627
G1 X178.258 Y151.793 E.04908
G1 X178.391 Y151.926
G1 X178.391 Y152.46
G1 X178.258 Y152.326
G1 X177.092 Y151.161 E.04908
G1 X176.959 Y151.027
G1 X176.959 Y151.56
G1 X177.092 Y151.694
G1 X178.258 Y152.859 E.04908
G1 X178.391 Y152.993
G1 X178.391 Y153.526
G1 X178.258 Y153.392
G1 X177.092 Y152.227 E.04908
G1 X176.959 Y152.094
G1 X176.959 Y152.627
G1 X177.092 Y152.76
G1 X178.258 Y153.926 E.04908
G1 X178.391 Y154.059
G1 X178.391 Y154.593
G1 X178.258 Y154.459
G1 X177.092 Y153.294 E.04908
G1 X176.959 Y153.16
G1 X176.959 Y153.693
G1 X177.092 Y153.827
G1 X178.258 Y154.992 E.04908
G1 X178.391 Y155.126
G1 X178.391 Y155.659
G1 X178.258 Y155.525
G1 X177.092 Y154.36 E.04908
G1 X176.959 Y154.227
G1 X176.959 Y154.76
G1 X177.092 Y154.893
G1 X178.258 Y156.059 E.04908
G1 X178.391 Y156.192
G1 X178.391 Y156.726
G1 X178.258 Y156.592
G1 X177.092 Y155.427 E.04908
G1 X176.959 Y155.293
M73 P87 R3
G1 X176.959 Y155.826
G1 X177.092 Y155.96
G1 X178.258 Y157.125 E.04908
G1 X178.391 Y157.259
G1 X178.391 Y157.792
G1 X178.258 Y157.658
G1 X177.092 Y156.493 E.04908
G1 X176.959 Y156.36
G1 X176.959 Y156.893
G1 X177.092 Y157.027
G1 X178.258 Y158.192 E.04908
G1 X178.391 Y158.325
G1 X178.391 Y158.859
G1 X178.258 Y158.725
G1 X177.092 Y157.56 E.04908
G1 X176.959 Y157.426
G1 X176.959 Y157.959
G1 X177.092 Y158.093
G1 X178.258 Y159.258 E.04908
G1 X178.391 Y159.392
G1 X178.391 Y159.925
G1 X178.258 Y159.792
G1 X177.092 Y158.626 E.04908
G1 X176.959 Y158.493
G1 X176.959 Y159.026
G1 X177.092 Y159.16
G1 X178.258 Y160.325 E.04908
G1 X178.391 Y160.458
G1 X178.391 Y160.992
G1 X178.258 Y160.858
G1 X177.092 Y159.693 E.04908
G1 X176.959 Y159.559
G1 X176.959 Y160.092
G1 X177.092 Y160.226
G1 X178.258 Y161.391 E.04908
G1 X178.391 Y161.525
G1 X178.391 Y162.058
G1 X178.258 Y161.925
G1 X177.092 Y160.759 E.04908
G1 X176.959 Y160.626
G1 X176.959 Y161.159
G1 X177.092 Y161.293
G1 X178.258 Y162.458 E.04908
G1 X178.391 Y162.591
G1 X178.391 Y163.125
G1 X178.258 Y162.991
G1 X177.092 Y161.826 E.04908
G1 X176.959 Y161.692
G1 X176.959 Y162.225
G1 X177.092 Y162.359
G1 X178.258 Y163.524 E.04908
G1 X178.391 Y163.658
G1 X178.391 Y164.191
G1 X178.258 Y164.058
G1 X177.092 Y162.892 E.04908
G1 X176.959 Y162.759
G1 X176.959 Y163.292
G1 X177.092 Y163.426
G1 X178.258 Y164.591 E.04908
G1 X178.391 Y164.724
G1 X178.391 Y165.258
G1 X178.258 Y165.124
G1 X177.092 Y163.959 E.04908
G1 X176.959 Y163.825
G1 X176.959 Y164.358
G1 X177.092 Y164.492
G1 X178.258 Y165.657 E.04908
G1 X178.391 Y165.791
G1 X178.391 Y166.324
G1 X178.258 Y166.191
G1 X177.092 Y165.025 E.04908
G1 X176.959 Y164.892
G1 X176.959 Y165.425
G1 X177.092 Y165.559
G1 X178.258 Y166.724 E.04908
G1 X178.391 Y166.858
G1 X178.391 Y167.391
G1 X178.258 Y167.257
G1 X177.092 Y166.092 E.04908
G1 X176.959 Y165.958
G1 X176.959 Y166.492
G1 X177.092 Y166.625
G1 X178.258 Y167.79 E.04908
G1 X178.391 Y167.924
G1 X178.391 Y168.457
G1 X178.258 Y168.324
G1 X177.092 Y167.158 E.04908
G1 X176.959 Y167.025
G1 X176.959 Y167.558
G1 X177.092 Y167.692
G1 X178.258 Y168.857 E.04908
G1 X178.391 Y168.991
G1 X178.391 Y169.524
G1 X178.258 Y169.39
G1 X177.092 Y168.225 E.04908
G1 X176.959 Y168.091
G1 X176.959 Y168.625
G1 X177.092 Y168.758
G1 X177.917 Y169.583 E.03473
; CHANGE_LAYER
; Z_HEIGHT: 16.8
; LAYER_HEIGHT: 0.199999
; WIPE_START
G1 F9547.055
M204 S8000
G1 X177.092 Y168.758 E-.44306
G1 X176.959 Y168.625 E-.07182
G1 X176.959 Y168.091 E-.20264
G1 X177.038 Y168.17 E-.04248
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 84/100
; update layer progress
M73 L84
M991 S0 P83 ;notify layer change

M106 S229.5
; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z17 I1.206 J-.164 P1  F60000
G1 X174.759 Y151.416 Z17
G1 Z16.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X174.759 Y168.584 E.55205
G1 X172.794 Y168.584 E.06318
G1 X172.794 Y151.416 E.55205
G1 X174.699 Y151.416 E.06125
; COOLING_NODE: 0
M204 S10000
G1 X175.166 Y151.009 F60000
G1 F1200
M204 S8000
G1 X175.166 Y168.991 E.57823
G1 X172.387 Y168.991 E.08936
G1 X172.387 Y151.009 E.57823
G1 X175.106 Y151.009 E.08743
; COOLING_NODE: 0
M204 S10000
G1 X175.573 Y150.602 F60000
G1 F1200
M204 S8000
G1 X175.573 Y169.398 E.60441
G1 X171.98 Y169.398 E.11554
G1 X171.98 Y150.602 E.60441
G1 X175.513 Y150.602 E.11361
; COOLING_NODE: 0
M204 S250
G1 X175.965 Y150.21 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X175.965 Y169.79 E.58322
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X171.588 Y169.79 E.13038
G1 X171.588 Y150.21 E.58322
G1 X175.905 Y150.21 E.12859
; WIPE_START
G1 F9547.055
M204 S8000
G1 X175.911 Y152.21 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X174.411 Y152.475 Z17.2 F60000
G1 Z16.8
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X174.411 Y154.103 E.05236
G1 X174.227 Y154.079 E.00596
G3 X173.142 Y153.161 I2.553 J-4.118 E.04584
G1 X173.142 Y155.449 E.07356
G3 X174.227 Y156.371 I-1.483 J2.844 E.04615
G1 X174.411 Y156.475 E.0068
G1 X174.411 Y159.345 E.09227
G1 X174.227 Y159.32 E.00596
G3 X173.142 Y158.403 I2.553 J-4.118 E.04584
G1 X173.142 Y160.69 E.07356
G3 X174.227 Y161.612 I-1.483 J2.844 E.04615
G1 X174.411 Y161.717 E.0068
G1 X174.411 Y164.586 E.09227
G1 X174.227 Y164.561 E.00596
G3 X173.142 Y163.644 I2.552 J-4.118 E.04584
G1 X173.142 Y165.932 E.07356
G3 X174.227 Y166.853 I-1.483 J2.844 E.04615
G1 X174.411 Y166.958 E.0068
G1 X174.411 Y168.236 E.04108
G1 X174.06 Y168.236 E.01128
; CHANGE_LAYER
; Z_HEIGHT: 17
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F8843.478
G1 X174.411 Y168.236 E-.13326
G1 X174.411 Y166.958 E-.4855
G1 X174.227 Y166.853 E-.08035
G1 X174.111 Y166.743 E-.06089
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 85/100
; update layer progress
M73 L85
M991 S0 P84 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z17.2 I1.216 J.051 P1  F60000
G1 X174.759 Y151.416 Z17.2
G1 Z17
G1 E.8 F1800
; FEATURE: Inner wall
G1 F1200
M204 S8000
G1 X174.759 Y168.584 E.55205
G1 X172.795 Y168.584 E.06314
G1 X172.795 Y151.416 E.55205
G1 X174.699 Y151.416 E.06121
; COOLING_NODE: 0
M204 S10000
G1 X175.166 Y151.009 F60000
G1 F1200
M204 S8000
G1 X175.166 Y168.991 E.57823
G1 X172.388 Y168.991 E.08932
G1 X172.388 Y151.009 E.57823
G1 X175.106 Y151.009 E.08739
; COOLING_NODE: 0
M204 S10000
M73 P88 R3
G1 X175.573 Y150.602 F60000
G1 F1200
M204 S8000
G1 X175.573 Y169.398 E.60441
G1 X171.981 Y169.398 E.1155
G1 X171.981 Y150.602 E.60441
G1 X175.513 Y150.602 E.11357
; COOLING_NODE: 0
M204 S250
G1 X175.965 Y150.21 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X175.965 Y169.79 E.58322
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X171.589 Y169.79 E.13034
G1 X171.589 Y150.21 E.58322
G1 X175.905 Y150.21 E.12856
; WIPE_START
G1 F9547.055
M204 S8000
G1 X175.911 Y152.21 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X174.411 Y152.353 Z17.4 F60000
G1 Z17
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X174.411 Y153.982 E.05236
G1 X174.227 Y153.923 E.0062
G2 X173.144 Y153.042 I-53.081 J64.169 E.0449
G1 X173.144 Y155.619 E.08284
G3 X174.227 Y156.497 I-6.855 J9.563 E.04487
G1 X174.411 Y156.567 E.00632
G1 X174.411 Y159.223 E.08542
M73 P88 R2
G1 X174.227 Y159.165 E.0062
G2 X173.144 Y158.284 I-53.151 J64.255 E.0449
G1 X173.144 Y160.86 E.08284
G3 X174.227 Y161.738 I-6.854 J9.561 E.04487
G1 X174.411 Y161.808 E.00632
G1 X174.411 Y164.464 E.08542
G1 X174.227 Y164.406 E.0062
G2 X173.144 Y163.525 I-53.081 J64.169 E.0449
G1 X173.144 Y166.101 E.08284
G3 X174.227 Y166.98 I-6.855 J9.563 E.04487
G1 X174.411 Y167.049 E.00632
G1 X174.411 Y168.236 E.03815
G1 X173.968 Y168.236 E.01422
; CHANGE_LAYER
; Z_HEIGHT: 17.2
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F8843.478
G1 X174.411 Y168.236 E-.16798
G1 X174.411 Y167.049 E-.45078
G1 X174.227 Y166.98 E-.07469
G1 X174.091 Y166.869 E-.06655
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 86/100
; update layer progress
M73 L86
M991 S0 P85 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z17.4 I1.216 J.053 P1  F60000
G1 X174.759 Y151.416 Z17.4
G1 Z17.2
G1 E.8 F1800
; FEATURE: Inner wall
G1 F1200
M204 S8000
G1 X174.759 Y168.584 E.55205
G1 X172.797 Y168.584 E.0631
G1 X172.797 Y151.416 E.55205
G1 X174.699 Y151.416 E.06117
; COOLING_NODE: 0
M204 S10000
G1 X175.166 Y151.009 F60000
G1 F1200
M204 S8000
G1 X175.166 Y168.991 E.57823
G1 X172.389 Y168.991 E.08928
G1 X172.389 Y151.009 E.57823
G1 X175.106 Y151.009 E.08735
; COOLING_NODE: 0
M204 S10000
G1 X175.573 Y150.602 F60000
G1 F1200
M204 S8000
G1 X175.573 Y169.398 E.60441
G1 X171.982 Y169.398 E.11546
G1 X171.982 Y150.602 E.60441
G1 X175.513 Y150.602 E.11353
; COOLING_NODE: 0
M204 S250
G1 X175.965 Y150.21 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X175.965 Y169.79 E.58322
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X171.59 Y169.79 E.13031
G1 X171.59 Y150.21 E.58322
G1 X175.905 Y150.21 E.12852
; WIPE_START
G1 F9547.055
M204 S8000
M73 P89 R2
G1 X175.911 Y152.21 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X173.652 Y151.764 Z17.6 F60000
G1 Z17.2
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X173.145 Y151.764 E.01632
G1 X173.145 Y152.885 E.03604
G3 X174.227 Y153.792 I-2.097 J3.602 E.04561
G1 X174.411 Y153.884 E.00661
G1 X174.411 Y156.679 E.08987
G1 X174.227 Y156.642 E.00602
G3 X173.145 Y155.744 I4.365 J-6.36 E.04528
G1 X173.145 Y158.127 E.0766
G3 X174.227 Y159.033 I-2.097 J3.602 E.04561
G1 X174.411 Y159.125 E.00661
G1 X174.411 Y161.92 E.08987
G1 X174.227 Y161.884 E.00602
G3 X173.145 Y160.986 I4.366 J-6.361 E.04528
G1 X173.145 Y163.368 E.0766
G3 X174.227 Y164.274 I-2.097 J3.602 E.04561
G1 X174.411 Y164.367 E.00661
G1 X174.411 Y167.162 E.08987
G1 X174.227 Y167.125 E.00602
G3 X173.145 Y166.227 I4.365 J-6.36 E.04528
G1 X173.145 Y167.855 E.05236
; CHANGE_LAYER
; Z_HEIGHT: 17.4
; LAYER_HEIGHT: 0.199999
; WIPE_START
G1 F8843.478
G1 X173.145 Y166.227 E-.61876
G1 X173.431 Y166.464 E-.14124
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 87/100
; update layer progress
M73 L87
M991 S0 P86 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z17.6 I1.212 J.107 P1  F60000
G1 X174.759 Y151.416 Z17.6
G1 Z17.4
G1 E.8 F1800
; FEATURE: Inner wall
G1 F1200
M204 S8000
G1 X174.759 Y168.584 E.55205
G1 X172.798 Y168.584 E.06306
G1 X172.798 Y151.416 E.55205
G1 X174.699 Y151.416 E.06113
; COOLING_NODE: 0
M204 S10000
G1 X175.166 Y151.009 F60000
G1 F1200
M204 S8000
G1 X175.166 Y168.991 E.57823
G1 X172.391 Y168.991 E.08924
G1 X172.391 Y151.009 E.57823
G1 X175.106 Y151.009 E.08731
; COOLING_NODE: 0
M204 S10000
G1 X175.573 Y150.602 F60000
G1 F1200
M204 S8000
G1 X175.573 Y169.398 E.60441
G1 X171.984 Y169.398 E.11542
G1 X171.984 Y150.602 E.60441
G1 X175.513 Y150.602 E.11349
; COOLING_NODE: 0
M204 S250
G1 X175.965 Y150.21 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X175.965 Y169.79 E.58322
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X171.592 Y169.79 E.13027
G1 X171.592 Y150.21 E.58322
G1 X175.905 Y150.21 E.12848
; WIPE_START
G1 F9547.055
M204 S8000
G1 X175.911 Y152.21 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X173.831 Y151.764 Z17.8 F60000
G1 Z17.4
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X173.146 Y151.764 E.02202
G1 X173.146 Y152.708 E.03034
G3 X173.69 Y153.041 I-.125 J.814 E.02106
G1 X174.227 Y153.672 E.02663
G1 X174.411 Y153.802 E.00725
G1 X174.411 Y156.823 E.09714
G1 X174.227 Y156.823 E.00591
G3 X173.146 Y155.862 I1.174 J-2.41 E.04707
G1 X173.146 Y157.949 E.06711
G3 X173.69 Y158.283 I-.125 J.814 E.02106
G1 X174.227 Y158.913 E.02663
G1 X174.411 Y159.043 E.00725
G1 X174.411 Y162.064 E.09714
G1 X174.227 Y162.064 E.00591
G3 X173.146 Y161.104 I1.174 J-2.41 E.04707
G1 X173.146 Y163.191 E.06711
G3 X173.69 Y163.524 I-.125 J.814 E.02106
G1 X174.227 Y164.154 E.02663
G1 X174.411 Y164.285 E.00725
G1 X174.411 Y167.306 E.09714
G1 X174.227 Y167.305 E.00591
G3 X173.146 Y166.345 I1.174 J-2.41 E.04707
G1 X173.146 Y167.973 E.05236
; CHANGE_LAYER
; Z_HEIGHT: 17.6
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F8843.478
G1 X173.146 Y166.345 E-.61876
G1 X173.392 Y166.623 E-.14124
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 88/100
; update layer progress
M73 L88
M991 S0 P87 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z17.8 I1.212 J.109 P1  F60000
G1 X174.759 Y151.416 Z17.8
G1 Z17.6
G1 E.8 F1800
; FEATURE: Inner wall
G1 F1200
M204 S8000
G1 X174.759 Y168.584 E.55205
G1 X172.799 Y168.584 E.06302
G1 X172.799 Y151.416 E.55205
G1 X174.699 Y151.416 E.06109
; COOLING_NODE: 0
M204 S10000
G1 X175.166 Y151.009 F60000
G1 F1200
M204 S8000
G1 X175.166 Y168.991 E.57823
G1 X172.392 Y168.991 E.0892
G1 X172.392 Y151.009 E.57823
G1 X175.106 Y151.009 E.08727
; COOLING_NODE: 0
M204 S10000
M73 P90 R2
G1 X175.573 Y150.602 F60000
G1 F1200
M204 S8000
G1 X175.573 Y169.398 E.60441
G1 X171.985 Y169.398 E.11538
G1 X171.985 Y150.602 E.60441
G1 X175.513 Y150.602 E.11345
; COOLING_NODE: 0
M204 S250
G1 X175.965 Y150.21 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X175.965 Y169.79 E.58322
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X171.593 Y169.79 E.13023
G1 X171.593 Y150.21 E.58322
G1 X175.905 Y150.21 E.12845
; WIPE_START
G1 F9547.055
M204 S8000
G1 X175.911 Y152.21 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X174.411 Y153.405 Z18 F60000
G1 Z17.6
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X174.411 Y151.777 E.05236
G3 X173.147 Y151.764 I-.556 J-7.86 E.04067
G1 X173.147 Y152.466 E.02255
G3 X173.69 Y152.667 I.127 J.489 E.01981
G1 X174.227 Y153.549 E.03322
G1 X174.411 Y153.728 E.00824
G1 X174.411 Y157.018 E.10579
G3 X173.69 Y156.851 I-.235 J-.624 E.02523
G1 X173.147 Y155.995 E.03258
G1 X173.147 Y157.707 E.05505
G3 X173.69 Y157.908 I.127 J.489 E.01981
G1 X174.227 Y158.791 E.03322
G1 X174.411 Y158.969 E.00824
G1 X174.411 Y162.259 E.10579
G3 X173.69 Y162.092 I-.235 J-.624 E.02523
G1 X173.147 Y161.236 E.03258
G1 X173.147 Y162.948 E.05505
G3 X173.69 Y163.15 I.127 J.489 E.01981
G1 X174.227 Y164.032 E.03322
G1 X174.411 Y164.211 E.00824
G1 X174.411 Y167.501 E.10579
G3 X173.69 Y167.333 I-.235 J-.624 E.02523
G1 X173.147 Y166.478 E.03258
G1 X173.147 Y168.106 E.05236
; CHANGE_LAYER
; Z_HEIGHT: 17.8
; LAYER_HEIGHT: 0.199999
; WIPE_START
G1 F8843.478
G1 X173.147 Y166.478 E-.61876
G1 X173.346 Y166.792 E-.14124
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 89/100
; update layer progress
M73 L89
M991 S0 P88 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z18 I1.212 J.111 P1  F60000
G1 X174.759 Y151.416 Z18
G1 Z17.8
G1 E.8 F1800
; FEATURE: Inner wall
G1 F1200
M204 S8000
G1 X174.759 Y168.584 E.55205
G1 X172.8 Y168.584 E.06298
G1 X172.8 Y151.416 E.55205
G1 X174.699 Y151.416 E.06105
; COOLING_NODE: 0
M204 S10000
G1 X175.166 Y151.009 F60000
G1 F1200
M204 S8000
G1 X175.166 Y168.991 E.57823
G1 X172.393 Y168.991 E.08916
G1 X172.393 Y151.009 E.57823
G1 X175.106 Y151.009 E.08723
; COOLING_NODE: 0
M204 S10000
G1 X175.573 Y150.602 F60000
G1 F1200
M204 S8000
G1 X175.573 Y169.398 E.60441
G1 X171.986 Y169.398 E.11534
G1 X171.986 Y150.602 E.60441
G1 X175.513 Y150.602 E.11341
; COOLING_NODE: 0
M204 S250
G1 X175.965 Y150.21 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X175.965 Y169.79 E.58322
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X171.594 Y169.79 E.1302
G1 X171.594 Y150.21 E.58322
G1 X175.905 Y150.21 E.12841
; WIPE_START
M73 P91 R2
G1 F9547.055
M204 S8000
G1 X175.911 Y152.21 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X173.148 Y153.704 Z18.2 F60000
G1 Z17.8
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X173.148 Y152.075 E.05236
G1 X173.33 Y151.764 E.01158
G1 X174.411 Y151.764 E.03475
G3 X174.05 Y152.466 I-1.08 J-.112 E.02595
G2 X174.411 Y153.663 I2.102 J.02 E.04083
G1 X174.411 Y157.197 E.11362
G2 X174.05 Y157.707 I5.791 J4.473 E.0201
G2 X174.411 Y158.905 I2.102 J.02 E.04084
G1 X174.411 Y162.438 E.11362
G2 X174.05 Y162.948 I5.791 J4.473 E.0201
G2 X174.411 Y164.146 I2.102 J.02 E.04083
G1 X174.411 Y167.679 E.11362
G2 X174.05 Y168.236 I1.945 J1.657 E.02138
G1 X173.148 Y168.236 E.02898
G3 X173.329 Y167.535 I.603 J-.218 E.02474
G2 X173.148 Y166.612 I-1.523 J-.18 E.03072
G1 X173.148 Y162.558 E.13037
G2 X173.333 Y161.966 I-.352 J-.434 E.02115
G1 X173.148 Y161.371 E.02003
G1 X173.148 Y157.317 E.13037
G2 X173.333 Y156.724 I-.352 J-.434 E.02115
G1 X173.148 Y156.13 E.02003
G1 X173.148 Y154.501 E.05236
; CHANGE_LAYER
; Z_HEIGHT: 18
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F8843.478
G1 X173.148 Y156.13 E-.61876
G1 X173.259 Y156.485 E-.14124
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 90/100
; update layer progress
M73 L90
M991 S0 P89 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z18.2 I1.167 J.345 P1  F60000
G1 X174.759 Y151.416 Z18.2
G1 Z18
G1 E.8 F1800
; FEATURE: Inner wall
G1 F1200
M204 S8000
G1 X174.759 Y168.584 E.55205
G1 X172.801 Y168.584 E.06294
G1 X172.801 Y151.416 E.55205
G1 X174.699 Y151.416 E.06101
; COOLING_NODE: 0
M204 S10000
G1 X175.166 Y151.009 F60000
G1 F1200
M204 S8000
G1 X175.166 Y168.991 E.57823
G1 X172.394 Y168.991 E.08912
G1 X172.394 Y151.009 E.57823
G1 X175.106 Y151.009 E.08719
; COOLING_NODE: 0
M204 S10000
G1 X175.573 Y150.602 F60000
G1 F1200
M204 S8000
G1 X175.573 Y169.398 E.60441
G1 X171.987 Y169.398 E.1153
G1 X171.987 Y150.602 E.60441
G1 X175.513 Y150.602 E.11337
; COOLING_NODE: 0
M204 S250
G1 X175.965 Y150.21 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X175.965 Y169.79 E.58322
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X171.595 Y169.79 E.13016
G1 X171.595 Y150.21 E.58322
G1 X175.905 Y150.21 E.12837
; WIPE_START
G1 F9547.055
M204 S8000
G1 X175.911 Y152.21 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X173.411 Y151.764 Z18.4 F60000
G1 Z18
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X174.411 Y151.764 E.03214
G1 X174.411 Y152.393 E.02022
G2 X174.245 Y152.793 I.419 J.408 E.01427
G1 X174.308 Y153.448 E.02117
G1 X174.411 Y153.64 E.00698
G1 X174.411 Y157.635 E.12845
G2 X174.245 Y158.035 I.419 J.408 E.01427
G1 X174.308 Y158.69 E.02117
G1 X174.411 Y158.881 E.00698
G1 X174.411 Y162.876 E.12845
G2 X174.245 Y163.276 I.419 J.408 E.01427
G1 X174.308 Y163.931 E.02117
G1 X174.411 Y164.122 E.00698
G1 X174.411 Y165.751 E.05236
; CHANGE_LAYER
; Z_HEIGHT: 18.2
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F8843.478
G1 X174.411 Y164.122 E-.61876
G1 X174.308 Y163.931 E-.08244
G1 X174.293 Y163.777 E-.0588
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 91/100
; update layer progress
M73 L91
M991 S0 P90 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z18.4 I1.216 J.046 P1  F60000
G1 X174.759 Y151.416 Z18.4
G1 Z18.2
G1 E.8 F1800
; FEATURE: Inner wall
G1 F1200
M204 S8000
G1 X174.759 Y168.584 E.55205
G1 X172.803 Y168.584 E.0629
G1 X172.803 Y151.416 E.55205
G1 X174.699 Y151.416 E.06097
; COOLING_NODE: 0
M204 S10000
G1 X175.166 Y151.009 F60000
G1 F1200
M204 S8000
G1 X175.166 Y168.991 E.57823
G1 X172.396 Y168.991 E.08908
M73 P92 R2
G1 X172.396 Y151.009 E.57823
G1 X175.106 Y151.009 E.08715
; COOLING_NODE: 0
M204 S10000
G1 X175.573 Y150.602 F60000
G1 F1200
M204 S8000
G1 X175.573 Y169.398 E.60441
G1 X171.989 Y169.398 E.11526
G1 X171.989 Y150.602 E.60441
G1 X175.513 Y150.602 E.11333
; COOLING_NODE: 0
M204 S250
G1 X175.965 Y150.21 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X175.965 Y169.79 E.58322
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X171.596 Y169.79 E.13012
G1 X171.596 Y150.21 E.58322
G1 X175.905 Y150.21 E.12834
; WIPE_START
M73 P92 R1
G1 F9547.055
M204 S8000
G1 X175.911 Y152.21 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X173.786 Y151.764 Z18.6 F60000
G1 Z18.2
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X174.411 Y151.764 E.02007
G1 X174.411 Y152.769 E.03229
G1 X174.339 Y153.448 E.02199
G1 X174.411 Y153.657 E.00709
G1 X174.411 Y158.01 E.13997
G1 X174.339 Y158.69 E.02199
G1 X174.411 Y158.898 E.00709
G1 X174.411 Y163.251 E.13997
G1 X174.339 Y163.931 E.02199
G1 X174.411 Y164.14 E.00709
G1 X174.411 Y165.768 E.05236
; CHANGE_LAYER
; Z_HEIGHT: 18.4
; LAYER_HEIGHT: 0.199999
; WIPE_START
G1 F8843.478
G1 X174.411 Y164.14 E-.61876
G1 X174.339 Y163.931 E-.0838
G1 X174.355 Y163.781 E-.05745
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 92/100
; update layer progress
M73 L92
M991 S0 P91 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z18.6 I1.216 J.04 P1  F60000
G1 X174.759 Y151.416 Z18.6
G1 Z18.4
G1 E.8 F1800
; FEATURE: Inner wall
G1 F1200
M204 S8000
G1 X174.759 Y168.584 E.55205
G1 X172.804 Y168.584 E.06286
G1 X172.804 Y151.416 E.55205
G1 X174.699 Y151.416 E.06093
; COOLING_NODE: 0
M204 S10000
G1 X175.166 Y151.009 F60000
G1 F1200
M204 S8000
G1 X175.166 Y168.991 E.57823
G1 X172.397 Y168.991 E.08904
G1 X172.397 Y151.009 E.57823
G1 X175.106 Y151.009 E.08711
; COOLING_NODE: 0
M204 S10000
G1 X175.573 Y150.602 F60000
G1 F1200
M204 S8000
G1 X175.573 Y169.398 E.60441
G1 X171.99 Y169.398 E.11522
G1 X171.99 Y150.602 E.60441
G1 X175.513 Y150.602 E.11329
; COOLING_NODE: 0
M204 S250
G1 X175.965 Y150.21 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X175.965 Y169.79 E.58322
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X171.598 Y169.79 E.13009
G1 X171.598 Y150.21 E.58322
G1 X175.905 Y150.21 E.1283
; WIPE_START
G1 F9547.055
M204 S8000
G1 X175.911 Y152.21 E-.76
; WIPE_END
M73 P93 R1
G1 E-.04 F1800
M204 S10000
G1 X174.215 Y151.764 Z18.8 F60000
G1 Z18.4
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X174.411 Y151.764 E.00628
G1 X174.411 Y153.198 E.04608
G2 X174.411 Y153.846 I.715 J.324 E.02149
G1 X174.411 Y158.439 E.1477
G2 X174.411 Y159.087 I.715 J.324 E.02149
G1 X174.411 Y163.68 E.1477
G2 X174.411 Y164.328 I.715 J.324 E.02149
G1 X174.411 Y165.957 E.05236
; CHANGE_LAYER
; Z_HEIGHT: 18.6
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F8843.478
G1 X174.411 Y164.328 E-.61876
G1 X174.349 Y163.962 E-.14125
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 93/100
; update layer progress
M73 L93
M991 S0 P92 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z18.8 I1.216 J.04 P1  F60000
G1 X174.759 Y151.416 Z18.8
G1 Z18.6
G1 E.8 F1800
; FEATURE: Inner wall
G1 F1200
M204 S8000
G1 X174.759 Y168.584 E.55205
G1 X172.805 Y168.584 E.06282
G1 X172.805 Y151.416 E.55205
G1 X174.699 Y151.416 E.06089
; COOLING_NODE: 0
M204 S10000
G1 X175.166 Y151.009 F60000
G1 F1200
M204 S8000
G1 X175.166 Y168.991 E.57823
G1 X172.398 Y168.991 E.089
G1 X172.398 Y151.009 E.57823
G1 X175.106 Y151.009 E.08707
; COOLING_NODE: 0
M204 S10000
G1 X175.573 Y150.602 F60000
G1 F1200
M204 S8000
G1 X175.573 Y169.398 E.60441
G1 X171.991 Y169.398 E.11518
G1 X171.991 Y150.602 E.60441
G1 X175.513 Y150.602 E.11325
; COOLING_NODE: 0
M204 S250
G1 X175.965 Y150.21 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X175.965 Y169.79 E.58322
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X171.599 Y169.79 E.13005
G1 X171.599 Y150.21 E.58322
G1 X175.905 Y150.21 E.12826
; WIPE_START
G1 F9547.055
M204 S8000
G1 X175.911 Y152.21 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X174.275 Y151.764 Z19 F60000
G1 Z18.6
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X174.411 Y151.764 E.00435
G1 X174.411 Y153.258 E.04801
G1 X174.325 Y153.448 E.00673
G1 X174.317 Y154.104 E.02107
G1 X174.411 Y154.329 E.00785
G1 X174.411 Y158.499 E.13408
G1 X174.325 Y158.69 E.00673
G1 X174.317 Y159.345 E.02107
G1 X174.411 Y159.571 E.00785
G1 X174.411 Y163.74 E.13408
G1 X174.325 Y163.931 E.00673
G1 X174.317 Y164.586 E.02107
G1 X174.411 Y164.812 E.00785
G1 X174.411 Y166.44 E.05236
; CHANGE_LAYER
; Z_HEIGHT: 18.8
; LAYER_HEIGHT: 0.199999
; WIPE_START
G1 F8843.478
G1 X174.411 Y164.812 E-.61876
G1 X174.317 Y164.586 E-.09282
G1 X174.319 Y164.459 E-.04843
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 94/100
; update layer progress
M73 L94
M991 S0 P93 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z19 I1.216 J.041 P1  F60000
G1 X174.759 Y151.416 Z19
G1 Z18.8
G1 E.8 F1800
; FEATURE: Inner wall
G1 F1200
M204 S8000
G1 X174.759 Y168.584 E.55205
G1 X172.806 Y168.584 E.06278
G1 X172.806 Y151.416 E.55205
G1 X174.699 Y151.416 E.06085
; COOLING_NODE: 0
M204 S10000
G1 X175.166 Y151.009 F60000
G1 F1200
M204 S8000
G1 X175.166 Y168.991 E.57823
G1 X172.399 Y168.991 E.08896
G1 X172.399 Y151.009 E.57823
G1 X175.106 Y151.009 E.08703
; COOLING_NODE: 0
M204 S10000
G1 X175.573 Y150.602 F60000
G1 F1200
M204 S8000
M73 P94 R1
G1 X175.573 Y169.398 E.60441
G1 X171.992 Y169.398 E.11514
G1 X171.992 Y150.602 E.60441
G1 X175.513 Y150.602 E.11321
; COOLING_NODE: 0
M204 S250
G1 X175.965 Y150.21 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X175.965 Y169.79 E.58322
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X171.6 Y169.79 E.13001
G1 X171.6 Y150.21 E.58322
G1 X175.905 Y150.21 E.12823
; WIPE_START
G1 F9547.055
M204 S8000
G1 X175.911 Y152.21 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.131 Y159.802 Z19.2 F60000
G1 X174.411 Y166.812 Z19.2
G1 Z18.8
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X174.411 Y165.184 E.05236
G3 X174.142 Y164.586 I.431 J-.553 E.02192
G1 X174.28 Y163.931 E.02153
G1 X174.411 Y163.729 E.00773
G1 X174.411 Y159.943 E.12177
G3 X174.142 Y159.345 I.431 J-.553 E.02192
G1 X174.28 Y158.69 E.02153
G1 X174.411 Y158.488 E.00773
G1 X174.411 Y154.701 E.12177
G3 X174.142 Y154.104 I.431 J-.553 E.02192
G1 X174.28 Y153.448 E.02153
G1 X174.411 Y153.247 E.00773
G1 X174.411 Y151.764 E.04767
G1 X173.155 Y151.764 E.04039
G1 X173.155 Y155.055 E.1058
G3 X173.155 Y155.808 I-.988 J.377 E.02477
G1 X173.155 Y160.296 E.14431
G3 X173.155 Y161.05 I-.988 J.377 E.02477
G1 X173.155 Y165.537 E.14431
G3 X173.155 Y166.291 I-.988 J.377 E.02477
G1 X173.155 Y167.919 E.05236
; CHANGE_LAYER
; Z_HEIGHT: 19
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F8843.478
G1 X173.155 Y166.291 E-.61876
G1 X173.231 Y165.927 E-.14125
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 95/100
; update layer progress
M73 L95
M991 S0 P94 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z19.2 I1.21 J.127 P1  F60000
G1 X174.759 Y151.416 Z19.2
G1 Z19
G1 E.8 F1800
; FEATURE: Inner wall
G1 F1200
M204 S8000
G1 X174.759 Y168.584 E.55205
G1 X172.808 Y168.584 E.06274
G1 X172.808 Y151.416 E.55205
G1 X174.699 Y151.416 E.06081
; COOLING_NODE: 0
M204 S10000
G1 X175.166 Y151.009 F60000
G1 F1200
M204 S8000
G1 X175.166 Y168.991 E.57823
G1 X172.401 Y168.991 E.08892
G1 X172.401 Y151.009 E.57823
G1 X175.106 Y151.009 E.08699
; COOLING_NODE: 0
M204 S10000
G1 X175.573 Y150.602 F60000
G1 F1200
M204 S8000
G1 X175.573 Y169.398 E.60441
G1 X171.993 Y169.398 E.1151
G1 X171.993 Y150.602 E.60441
G1 X175.513 Y150.602 E.11317
; COOLING_NODE: 0
M204 S250
G1 X175.965 Y150.21 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X175.965 Y169.79 E.58322
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X171.601 Y169.79 E.12998
G1 X171.601 Y150.21 E.58322
G1 X175.905 Y150.21 E.12819
; WIPE_START
G1 F9547.055
M204 S8000
G1 X175.911 Y152.21 E-.76
; WIPE_END
M73 P95 R1
G1 E-.04 F1800
M204 S10000
G1 X173.156 Y152.947 Z19.4 F60000
G1 Z19
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X173.156 Y154.575 E.05236
G1 X173.69 Y154.729 E.01786
G3 X174.411 Y153.202 I3.959 J.936 E.05468
G1 X174.411 Y155.031 E.0588
G1 X173.69 Y154.789 E.02445
G3 X173.156 Y156.067 I-4.352 J-1.067 E.04473
G1 X173.156 Y159.816 E.12056
G1 X173.69 Y159.97 E.01786
G3 X174.411 Y158.444 I3.959 J.936 E.05468
G1 X174.411 Y160.272 E.0588
G1 X173.69 Y160.03 E.02445
G3 X173.156 Y161.309 I-4.353 J-1.067 E.04473
G1 X173.156 Y165.058 E.12056
G1 X173.69 Y165.211 E.01786
G3 X174.411 Y163.685 I3.959 J.936 E.05468
G1 X174.411 Y165.514 E.0588
G1 X173.69 Y165.272 E.02445
G3 X173.156 Y166.55 I-4.352 J-1.067 E.04473
G1 X173.156 Y168.178 E.05236
; CHANGE_LAYER
; Z_HEIGHT: 19.2
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F8843.478
G1 X173.156 Y166.55 E-.61876
G1 X173.335 Y166.224 E-.14125
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 96/100
; update layer progress
M73 L96
M991 S0 P95 ;notify layer change

M106 S226.95
; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z19.4 I1.211 J.116 P1  F60000
G1 X174.759 Y151.416 Z19.4
G1 Z19.2
G1 E.8 F1800
; FEATURE: Inner wall
G1 F1217
M204 S8000
G1 X174.759 Y168.584 E.55205
G1 X172.809 Y168.584 E.0627
G1 X172.809 Y151.416 E.55205
G1 X174.699 Y151.416 E.06078
; COOLING_NODE: 0
M204 S10000
G1 X175.166 Y151.009 F60000
G1 F1217
M204 S8000
G1 X175.166 Y168.991 E.57823
G1 X172.402 Y168.991 E.08888
G1 X172.402 Y151.009 E.57823
G1 X175.106 Y151.009 E.08696
; COOLING_NODE: 0
M204 S10000
G1 X175.573 Y150.602 F60000
G1 F1217
M204 S8000
G1 X175.573 Y169.398 E.60441
G1 X171.995 Y169.398 E.11506
G1 X171.995 Y150.602 E.60441
G1 X175.513 Y150.602 E.11313
; COOLING_NODE: 0
M204 S250
G1 X175.965 Y150.21 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1216
M204 S5000
G1 X175.965 Y169.79 E.58322
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X171.603 Y169.79 E.12994
G1 X171.603 Y150.21 E.58322
G1 X175.905 Y150.21 E.12815
; WIPE_START
G1 F9547.055
M204 S8000
G1 X175.911 Y152.21 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X174.367 Y151.808 Z19.6 F60000
G1 Z19.2
G1 E.8 F1800
; FEATURE: Floating vertical shell
; LINE_WIDTH: 0.41999
G1 F1217
M204 S8000
G1 X173.201 Y151.808 E.03473
G1 X173.201 Y168.192 E.488
G1 X174.367 Y168.192 E.03473
G1 X174.367 Y151.868 E.48621
M204 S10000
G1 X173.981 Y152.391 F60000
; LINE_WIDTH: 0.43732
G1 F1217
M204 S8000
G1 X173.981 Y152.194 E.00614
G1 X173.587 Y152.194 E.01229
G1 X173.587 Y167.806 E.48639
G1 X173.981 Y167.806 E.01229
G1 X173.981 Y152.451 E.47838
; CHANGE_LAYER
; Z_HEIGHT: 19.4
; LAYER_HEIGHT: 0.199999
; WIPE_START
G1 F9127.789
G1 X173.981 Y154.451 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 97/100
; update layer progress
M73 L97
M991 S0 P96 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z19.6 I1.179 J.302 P1  F60000
G1 X174.759 Y151.416 Z19.6
G1 Z19.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1216
M204 S8000
G1 X174.759 Y168.584 E.55205
G1 X172.81 Y168.584 E.06267
G1 X172.81 Y151.416 E.55205
G1 X174.699 Y151.416 E.06074
; COOLING_NODE: 0
M204 S10000
G1 X175.166 Y151.009 F60000
G1 F1216
M204 S8000
M73 P96 R1
G1 X175.166 Y168.991 E.57823
G1 X172.403 Y168.991 E.08884
G1 X172.403 Y151.009 E.57823
G1 X175.106 Y151.009 E.08692
; COOLING_NODE: 0
M204 S10000
G1 X175.573 Y150.602 F60000
G1 F1216
M204 S8000
M73 P96 R0
G1 X175.573 Y169.398 E.60441
G1 X171.996 Y169.398 E.11502
G1 X171.996 Y150.602 E.60441
G1 X175.513 Y150.602 E.1131
; COOLING_NODE: 0
M204 S250
G1 X175.965 Y150.21 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1216
M204 S5000
G1 X175.965 Y169.79 E.58322
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X171.604 Y169.79 E.1299
G1 X171.604 Y150.21 E.58322
G1 X175.905 Y150.21 E.12812
; WIPE_START
G1 F9547.055
M204 S8000
G1 X175.911 Y152.21 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X174.367 Y152.391 Z19.8 F60000
G1 Z19.4
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F1216
M204 S8000
G1 X174.367 Y151.808 E.01734
G1 X173.202 Y151.808 E.03469
G1 X173.202 Y168.192 E.488
G1 X174.367 Y168.192 E.03469
G1 X174.367 Y152.451 E.46886
M204 S10000
G1 X173.981 Y152.391 F60000
; LINE_WIDTH: 0.4367
G1 F1216
M204 S8000
G1 X173.981 Y152.194 E.00612
G1 X173.588 Y152.194 E.01225
G1 X173.588 Y167.806 E.48564
G1 X173.981 Y167.806 E.01225
G1 X173.981 Y152.451 E.47765
; CHANGE_LAYER
; Z_HEIGHT: 19.6
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F9142.16
G1 X173.981 Y154.451 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 98/100
; update layer progress
M73 L98
M991 S0 P97 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z19.8 I1.179 J.302 P1  F60000
G1 X174.759 Y151.416 Z19.8
G1 Z19.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1216
M204 S8000
G1 X174.759 Y168.584 E.55205
G1 X172.811 Y168.584 E.06263
G1 X172.811 Y151.416 E.55205
G1 X174.699 Y151.416 E.0607
; COOLING_NODE: 0
M204 S10000
G1 X175.166 Y151.009 F60000
G1 F1216
M204 S8000
G1 X175.166 Y168.991 E.57823
G1 X172.404 Y168.991 E.08881
G1 X172.404 Y151.009 E.57823
G1 X175.106 Y151.009 E.08688
; COOLING_NODE: 0
M204 S10000
G1 X175.573 Y150.602 F60000
G1 F1216
M204 S8000
G1 X175.573 Y169.398 E.60441
G1 X171.997 Y169.398 E.11499
M73 P97 R0
G1 X171.997 Y150.602 E.60441
G1 X175.513 Y150.602 E.11306
; COOLING_NODE: 0
M204 S250
G1 X175.965 Y150.21 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1216
M204 S5000
G1 X175.965 Y169.79 E.58322
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X171.605 Y169.79 E.12987
G1 X171.605 Y150.21 E.58322
G1 X175.905 Y150.21 E.12808
; WIPE_START
G1 F9547.055
M204 S8000
G1 X175.911 Y152.21 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X174.367 Y152.39 Z20 F60000
G1 Z19.6
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F1216
M204 S8000
G1 X174.367 Y151.808 E.01733
G1 X173.203 Y151.808 E.03465
G1 X173.203 Y168.192 E.488
G1 X174.367 Y168.192 E.03465
G1 X174.367 Y152.45 E.46888
M204 S10000
G1 X173.982 Y152.39 F60000
; LINE_WIDTH: 0.43609
G1 F1216
M204 S8000
G1 X173.982 Y152.193 E.00611
G1 X173.588 Y152.193 E.01221
G1 X173.588 Y167.807 E.48491
G1 X173.982 Y167.807 E.01221
G1 X173.982 Y152.45 E.47694
; CHANGE_LAYER
; Z_HEIGHT: 19.8
; LAYER_HEIGHT: 0.199999
; WIPE_START
G1 F9156.344
G1 X173.982 Y154.45 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 99/100
; update layer progress
M73 L99
M991 S0 P98 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z20 I1.179 J.302 P1  F60000
G1 X174.759 Y151.416 Z20
G1 Z19.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1216
M204 S8000
G1 X174.759 Y168.584 E.55205
G1 X172.813 Y168.584 E.06259
G1 X172.813 Y151.416 E.55205
G1 X174.699 Y151.416 E.06066
; COOLING_NODE: 0
M204 S10000
G1 X175.166 Y151.009 F60000
G1 F1216
M204 S8000
G1 X175.166 Y168.991 E.57823
G1 X172.405 Y168.991 E.08877
G1 X172.405 Y151.009 E.57823
G1 X175.106 Y151.009 E.08684
; COOLING_NODE: 0
M204 S10000
M73 P98 R0
G1 X175.573 Y150.602 F60000
G1 F1216
M204 S8000
G1 X175.573 Y169.398 E.60441
G1 X171.998 Y169.398 E.11495
G1 X171.998 Y150.602 E.60441
G1 X175.513 Y150.602 E.11302
; COOLING_NODE: 0
M204 S250
G1 X175.965 Y150.21 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1216
M204 S5000
G1 X175.965 Y169.79 E.58322
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X171.606 Y169.79 E.12983
G1 X171.606 Y150.21 E.58322
G1 X175.905 Y150.21 E.12804
; WIPE_START
G1 F9547.055
M204 S8000
G1 X175.911 Y152.21 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X174.367 Y152.389 Z20.2 F60000
G1 Z19.8
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F1216
M204 S8000
G1 X174.367 Y151.808 E.01731
G1 X173.205 Y151.808 E.03462
G1 X173.205 Y168.192 E.488
G1 X174.367 Y168.192 E.03462
G1 X174.367 Y152.449 E.4689
M204 S10000
G1 X173.982 Y152.389 F60000
; LINE_WIDTH: 0.43547
G1 F1216
M204 S8000
G1 X173.982 Y152.193 E.00609
G1 X173.589 Y152.193 E.01217
G1 X173.589 Y167.807 E.48416
G1 X173.982 Y167.807 E.01217
G1 X173.982 Y152.449 E.47622
; CHANGE_LAYER
; Z_HEIGHT: 20
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F9170.806
G1 X173.982 Y154.449 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 100/100
; update layer progress
M73 L100
M991 S0 P99 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z20.2 I1.102 J.516 P1  F60000
G1 X175.965 Y150.21 Z20.2
G1 Z20
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1320
M204 S5000
G1 X175.965 Y169.79 E.58322
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X171.608 Y169.79 E.12979
G1 X171.608 Y150.21 E.58322
G1 X175.905 Y150.21 E.12801
; WIPE_START
G1 F9547.055
M204 S8000
G1 X175.911 Y152.21 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.842 Y159.842 Z20.4 F60000
G1 X175.758 Y169.108 Z20.4
G1 Z20
G1 E.8 F1800
; FEATURE: Top surface
G1 F1506
M204 S2000
G1 X175.283 Y169.583 E.02001
G1 X175.149 Y169.716
G1 X174.616 Y169.716
G1 X174.749 Y169.583
G1 X175.758 Y168.574 E.04248
G1 X175.891 Y168.441
G1 X175.891 Y167.907
G1 X175.758 Y168.041
G1 X174.216 Y169.583 E.06494
G1 X174.082 Y169.716
G1 X173.549 Y169.716
G1 X173.683 Y169.583
G1 X175.758 Y167.508 E.0874
G1 X175.891 Y167.374
G1 X175.891 Y166.841
G1 X175.758 Y166.975
G1 X173.15 Y169.583 E.10987
G1 X173.016 Y169.716
G1 X172.483 Y169.716
G1 X172.616 Y169.583
G1 X175.758 Y166.441 E.13233
G1 X175.891 Y166.308
G1 X175.891 Y165.774
G1 X175.758 Y165.908
G1 X172.083 Y169.583 E.15479
G1 X171.949 Y169.716
G1 X171.681 Y169.451
G1 X171.815 Y169.317
G1 X175.758 Y165.375 E.16609
G1 X175.891 Y165.241
G1 X175.891 Y164.708
G1 X175.758 Y164.842
G1 X171.815 Y168.784 E.16609
G1 X171.681 Y168.918
G1 X171.681 Y168.385
G1 X171.815 Y168.251
G1 X175.758 Y164.308 E.16609
G1 X175.891 Y164.175
G1 X175.891 Y163.641
G1 X175.758 Y163.775
G1 X171.815 Y167.718 E.16609
G1 X171.681 Y167.851
G1 X171.681 Y167.318
G1 X171.815 Y167.184
G1 X175.758 Y163.242 E.16609
G1 X175.891 Y163.108
G1 X175.891 Y162.575
G1 X175.758 Y162.708
G1 X171.815 Y166.651 E.16609
G1 X171.681 Y166.785
G1 X171.681 Y166.252
G1 X171.815 Y166.118
G1 X175.758 Y162.175 E.16609
G1 X175.891 Y162.042
G1 X175.891 Y161.508
G1 X175.758 Y161.642
G1 X171.815 Y165.585 E.16609
G1 X171.681 Y165.718
G1 X171.681 Y165.185
G1 X171.815 Y165.051
G1 X175.758 Y161.109 E.16609
G1 X175.891 Y160.975
G1 X175.891 Y160.442
G1 X175.758 Y160.575
M73 P99 R0
G1 X171.815 Y164.518 E.16609
G1 X171.681 Y164.652
G1 X171.681 Y164.119
G1 X171.815 Y163.985
G1 X175.758 Y160.042 E.16609
G1 X175.891 Y159.909
G1 X175.891 Y159.375
G1 X175.758 Y159.509
G1 X171.815 Y163.452 E.16609
G1 X171.681 Y163.585
G1 X171.681 Y163.052
G1 X171.815 Y162.918
G1 X175.758 Y158.976 E.16609
G1 X175.891 Y158.842
G1 X175.891 Y158.309
G1 X175.758 Y158.442
G1 X171.815 Y162.385 E.16609
G1 X171.681 Y162.519
G1 X171.681 Y161.986
G1 X171.815 Y161.852
G1 X175.758 Y157.909 E.16609
G1 X175.891 Y157.776
G1 X175.891 Y157.242
G1 X175.758 Y157.376
G1 X171.815 Y161.319 E.16609
G1 X171.681 Y161.452
G1 X171.681 Y160.919
G1 X171.815 Y160.785
G1 X175.758 Y156.843 E.16609
G1 X175.891 Y156.709
G1 X175.891 Y156.176
G1 X175.758 Y156.309
G1 X171.815 Y160.252 E.16609
G1 X171.681 Y160.386
G1 X171.681 Y159.852
G1 X171.815 Y159.719
G1 X175.758 Y155.776 E.16609
G1 X175.891 Y155.642
G1 X175.891 Y155.109
G1 X175.758 Y155.243
G1 X171.815 Y159.186 E.16609
G1 X171.681 Y159.319
G1 X171.681 Y158.786
G1 X171.815 Y158.652
G1 X175.758 Y154.71 E.16609
G1 X175.891 Y154.576
G1 X175.891 Y154.043
G1 X175.758 Y154.176
G1 X171.815 Y158.119 E.16609
G1 X171.681 Y158.253
G1 X171.681 Y157.719
G1 X171.815 Y157.586
G1 X175.758 Y153.643 E.16609
G1 X175.891 Y153.509
G1 X175.891 Y152.976
G1 X175.758 Y153.11
G1 X171.815 Y157.053 E.16609
G1 X171.681 Y157.186
G1 X171.681 Y156.653
G1 X171.815 Y156.519
G1 X175.758 Y152.577 E.16609
G1 X175.891 Y152.443
G1 X175.891 Y151.91
G1 X175.758 Y152.043
G1 X171.815 Y155.986 E.16609
G1 X171.681 Y156.12
G1 X171.681 Y155.586
G1 X171.815 Y155.453
G1 X175.758 Y151.51 E.16609
G1 X175.891 Y151.376
G1 X175.891 Y150.843
G1 X175.758 Y150.977
G1 X171.815 Y154.92 E.16609
G1 X171.681 Y155.053
G1 X171.681 Y154.52
G1 X171.815 Y154.386
G1 X175.758 Y150.444 E.16609
G1 X175.891 Y150.31
G1 X175.384 Y150.284
G1 X175.251 Y150.417
G1 X171.815 Y153.853 E.14472
G1 X171.681 Y153.987
G1 X171.681 Y153.453
G1 X171.815 Y153.32
G1 X174.717 Y150.417 E.12226
G1 X174.851 Y150.284
G1 X174.318 Y150.284
G1 X174.184 Y150.417
G1 X171.815 Y152.787 E.0998
G1 X171.681 Y152.92
G1 X171.681 Y152.387
G1 X171.815 Y152.253
G1 X173.651 Y150.417 E.07733
G1 X173.784 Y150.284
G1 X173.251 Y150.284
G1 X173.118 Y150.417
G1 X171.815 Y151.72 E.05487
G1 X171.681 Y151.854
G1 X171.681 Y151.32
G1 X171.815 Y151.187
G1 X172.584 Y150.417 E.03241
; close powerlost recovery
M1003 S0
; WIPE_START
G1 F9547.055
M204 S8000
G1 X171.815 Y151.187 E-.41345
G1 X171.681 Y151.32 E-.07182
G1 X171.681 Y151.854 E-.20264
G1 X171.815 Y151.72 E-.07182
G1 X171.815 Y151.719 E-.00028
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z20.4 I1.217 J0 P1  F60000
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
G1 Z20.4 F900 ; lower z a little
M1002 judge_flag timelapse_record_flag
M622 J1
    G150.3
    M400 ; wait all motion done
    M991 S0 P-1 ;end smooth timelapse at safe pos
    M400 S5 ;wait for last picture to be taken
M623  ;end of "timelapse_record_flag"

G90
G1 Z30 F900 ; lower z a little

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

    
        G1 Z110 F600
        G1 Z108
    

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

