; HEADER_BLOCK_START
; BambuStudio 02.08.02.61
; model printing time: 10m 31s; total estimated time: 15m 58s
; total layer number: 54
; total filament length [mm] : 1692.42
; total filament volume [cm^3] : 4070.75
; total filament weight [g] : 5.17
; filament_density: 1.27
; filament_diameter: 1.75
; max_z_height: 10.80
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
M73 P0 R15
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
M73 P2 R15
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
M73 P5 R15
G1 Z5 F1200
G90
G1 X175 Y160 F30000

M622 J1
    M1002 gcode_claim_action : 1
    G29.20 A3
    G29 A1 O X136.443 Y132.693 I77.1131 J54.6131 R
    M400
M623

M622 J2
    M1002 gcode_claim_action : 1
    
        G29.20 A4
        G29 A2 O X136.443 Y132.693 I77.1131 J54.6131 R
    
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
M73 P32 R10
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
; layer num/total_layer_count: 1/54
; update layer progress
M73 L1
M991 S0 P0 ;notify layer change

M106 S0
M106 P2 S0
; OBJECT_ID: 15
M73 P33 R10
G1 X137.622 Y144.074 F60000
M204 S6000
M73 P34 R10
G1 Z.4
G1 Z.2
G1 E.8 F1800
; FEATURE: Brim
; LINE_WIDTH: 0.5
G1 F3000
M204 S500
G1 X138.038 Y143.69 E.02045
G1 X138.512 Y143.378 E.02048
G1 X138.993 Y143.161 E.01907
G1 X139.537 Y142.998 E.0205
G1 X140.262 Y142.922 E.02632
G1 X146.443 Y142.922 E.22319
G1 X146.584 Y142.873 E.00538
G1 X146.672 Y142.693 E.00722
G1 X146.672 Y136.509 E.22328
G1 X146.719 Y135.94 E.02062
G1 X146.961 Y135.125 E.03072
G1 X147.276 Y134.52 E.0246
G1 X147.622 Y134.074 E.02039
G1 X148.038 Y133.69 E.02045
G1 X148.512 Y133.378 E.02048
G1 X148.993 Y133.161 E.01907
G1 X149.537 Y132.998 E.0205
G1 X150.262 Y132.922 E.02632
G1 X209.741 Y132.922 E2.14754
G1 X210.31 Y132.969 E.02062
G1 X211.125 Y133.211 E.03072
G1 X211.73 Y133.526 E.0246
G1 X212.176 Y133.872 E.02039
G1 X212.56 Y134.288 E.02045
G1 X212.872 Y134.762 E.02048
G1 X213.089 Y135.243 E.01907
G1 X213.252 Y135.787 E.0205
G1 X213.328 Y136.512 E.02632
G1 X213.328 Y152.991 E.59497
G1 X213.281 Y153.56 E.02062
G1 X212.998 Y154.471 E.03446
G1 X212.725 Y154.978 E.02079
G1 X212.378 Y155.426 E.02045
G1 X211.962 Y155.81 E.02045
G1 X211.488 Y156.122 E.02048
G1 X211.007 Y156.339 E.01907
G1 X210.463 Y156.502 E.0205
G1 X209.738 Y156.578 E.02632
G1 X176.057 Y156.578 E1.2161
G1 X175.916 Y156.627 E.00538
G1 X175.828 Y156.807 E.00722
G1 X175.828 Y183.491 E.96345
G1 X175.781 Y184.06 E.02062
G1 X175.498 Y184.971 E.03446
G1 X175.225 Y185.478 E.02079
G1 X174.878 Y185.926 E.02045
G1 X174.462 Y186.31 E.02045
G1 X173.988 Y186.622 E.02048
G1 X173.507 Y186.839 E.01907
G1 X172.963 Y187.002 E.0205
G1 X172.238 Y187.078 E.02632
G1 X140.259 Y187.078 E1.15462
G1 X139.69 Y187.031 E.02062
G1 X138.779 Y186.748 E.03446
G1 X138.272 Y186.475 E.02079
G1 X137.824 Y186.128 E.02045
G1 X137.44 Y185.712 E.02045
G1 X137.128 Y185.238 E.02048
G1 X136.911 Y184.757 E.01907
G1 X136.748 Y184.213 E.0205
G1 X136.672 Y183.488 E.02632
G1 X136.672 Y146.509 E1.33515
G1 X136.719 Y145.94 E.02062
G1 X137.002 Y145.029 E.03446
G1 X137.275 Y144.522 E.02079
G1 X137.585 Y144.121 E.01828
M204 S6000
G1 X137.947 Y144.404 F60000
G1 F3000
M204 S500
G1 X137.968 Y144.376 E.00127
G1 X138.329 Y144.045 E.0177
G1 X138.724 Y143.786 E.01702
G1 X139.145 Y143.594 E.01673
G1 X139.615 Y143.452 E.01771
G1 X140.293 Y143.379 E.02462
G1 X146.432 Y143.379 E.22166
G1 X146.72 Y143.31 E.0107
G1 X146.893 Y143.207 E.00726
G1 X147.001 Y143.062 E.00654
G1 X147.076 Y142.908 E.0062
G1 X147.129 Y142.678 E.00851
G1 X147.129 Y136.534 E.22183
G1 X147.17 Y136.039 E.01793
G1 X147.383 Y135.309 E.02745
G1 X147.656 Y134.779 E.02155
G1 X147.968 Y134.376 E.01838
G1 X148.329 Y134.045 E.0177
G1 X148.742 Y133.776 E.0178
G1 X149.162 Y133.588 E.01661
G1 X149.64 Y133.447 E.01798
G1 X150.293 Y133.379 E.0237
G1 X209.727 Y133.38 E2.14594
G1 X210.239 Y133.425 E.01853
G1 X210.941 Y133.633 E.02644
G1 X211.471 Y133.906 E.02155
G1 X211.874 Y134.218 E.01838
G1 X212.205 Y134.579 E.0177
G1 X212.464 Y134.974 E.01702
G1 X212.656 Y135.395 E.01673
G1 X212.803 Y135.89 E.01864
G1 X212.87 Y136.529 E.02319
G1 X212.87 Y152.977 E.59389
G1 X212.825 Y153.486 E.01846
G1 X212.568 Y154.305 E.03099
G1 X212.334 Y154.737 E.01774
G1 X212.047 Y155.107 E.0169
G1 X211.671 Y155.455 E.01852
G1 X211.258 Y155.724 E.0178
G1 X210.838 Y155.912 E.01661
G1 X210.36 Y156.053 E.01798
G1 X209.707 Y156.121 E.0237
G1 X176.068 Y156.121 E1.21457
G1 X175.78 Y156.19 E.01069
G1 X175.607 Y156.293 E.00726
G1 X175.499 Y156.438 E.00654
G1 X175.424 Y156.592 E.00619
G1 X175.371 Y156.822 E.00851
G1 X175.37 Y183.477 E.96241
G1 X175.325 Y183.986 E.01846
G1 X175.068 Y184.805 E.03099
G1 X174.834 Y185.237 E.01774
M73 P35 R10
G1 X174.547 Y185.607 E.0169
G1 X174.171 Y185.955 E.01852
G1 X173.758 Y186.224 E.0178
G1 X173.338 Y186.412 E.01661
G1 X172.86 Y186.553 E.01798
G1 X172.207 Y186.621 E.0237
G1 X140.284 Y186.621 E1.15261
G1 X139.764 Y186.575 E.01887
G1 X138.945 Y186.318 E.03099
G1 X138.513 Y186.084 E.01774
G1 X138.143 Y185.797 E.0169
G1 X137.795 Y185.421 E.01852
G1 X137.526 Y185.008 E.0178
G1 X137.338 Y184.588 E.01661
G1 X137.197 Y184.11 E.01798
G1 X137.129 Y183.457 E.0237
G1 X137.129 Y146.534 E1.33315
G1 X137.175 Y146.014 E.01886
G1 X137.432 Y145.195 E.03099
G1 X137.666 Y144.763 E.01774
G1 X137.91 Y144.451 E.01428
M204 S6000
G1 X138.27 Y144.735 F60000
G1 F3000
M204 S500
G1 X138.313 Y144.68 E.00255
G1 X138.603 Y144.414 E.01418
G1 X138.936 Y144.193 E.01444
G1 X139.299 Y144.026 E.0144
G1 X139.694 Y143.905 E.01493
G1 X140.325 Y143.836 E.02291
G1 X146.418 Y143.836 E.22002
G1 X146.819 Y143.756 E.01474
G1 X146.963 Y143.697 E.00562
G1 X147.115 Y143.606 E.0064
G1 X147.267 Y143.469 E.00739
G1 X147.361 Y143.343 E.00568
G1 X147.484 Y143.112 E.00945
G1 X147.522 Y143.005 E.0041
G1 X147.586 Y142.665 E.0125
G1 X147.586 Y136.558 E.22049
G1 X147.62 Y136.137 E.01527
G1 X147.806 Y135.492 E.02421
G1 X148.038 Y135.037 E.01846
G1 X148.299 Y134.696 E.01549
G1 X148.62 Y134.401 E.01575
G1 X148.972 Y134.174 E.01512
G1 X149.33 Y134.015 E.01415
G1 X149.742 Y133.896 E.01547
G1 X150.324 Y133.836 E.02113
G1 X209.701 Y133.837 E2.14389
G1 X210.166 Y133.88 E.01685
G1 X210.757 Y134.055 E.02227
G1 X211.213 Y134.288 E.01849
G1 X211.571 Y134.564 E.01633
G1 X211.849 Y134.87 E.01493
G1 X212.057 Y135.186 E.01364
G1 X212.223 Y135.547 E.01435
G1 X212.354 Y135.992 E.01676
G1 X212.412 Y136.545 E.02008
G1 X212.413 Y152.963 E.59277
G1 X212.37 Y153.411 E.01625
G1 X212.15 Y154.114 E.02659
G1 X211.955 Y154.477 E.01487
G1 X211.716 Y154.788 E.01418
G1 X211.397 Y155.085 E.01574
G1 X211.047 Y155.316 E.01514
G1 X210.687 Y155.479 E.01426
G1 X210.283 Y155.599 E.01523
G1 X209.676 Y155.664 E.02203
G1 X176.082 Y155.664 E1.21297
G1 X175.681 Y155.744 E.01474
G1 X175.537 Y155.803 E.00562
G1 X175.385 Y155.894 E.0064
G1 X175.233 Y156.031 E.00739
G1 X175.139 Y156.157 E.00568
G1 X174.978 Y156.495 E.01351
G1 X174.914 Y156.835 E.0125
G1 X174.913 Y183.451 E.96099
G1 X174.87 Y183.911 E.01669
G1 X174.639 Y184.638 E.02754
G1 X174.455 Y184.977 E.01392
G1 X174.216 Y185.288 E.01418
G1 X173.879 Y185.6 E.01657
G1 X173.528 Y185.826 E.01508
G1 X173.17 Y185.985 E.01415
G1 X172.758 Y186.104 E.01547
G1 X172.176 Y186.164 E.02113
G1 X140.31 Y186.164 E1.15056
G1 X139.839 Y186.12 E.01709
G1 X139.112 Y185.889 E.02753
G1 X138.773 Y185.705 E.01392
G1 X138.462 Y185.466 E.01418
G1 X138.15 Y185.129 E.01657
G1 X137.924 Y184.778 E.01508
G1 X137.765 Y184.42 E.01415
G1 X137.646 Y184.008 E.01547
G1 X137.586 Y183.426 E.02113
G1 X137.586 Y146.56 E1.33109
G1 X137.63 Y146.089 E.01709
G1 X137.861 Y145.362 E.02753
G1 X138.057 Y145.005 E.01469
G1 X138.233 Y144.782 E.01026
M204 S6000
G1 X138.591 Y145.068 F60000
G1 F3000
M204 S500
G1 X138.658 Y144.984 E.00386
G1 X138.894 Y144.769 E.01154
G1 X139.151 Y144.6 E.0111
G1 X139.454 Y144.458 E.01207
G1 X139.774 Y144.359 E.01213
G1 X140.357 Y144.293 E.02118
G1 X146.406 Y144.293 E.21841
G1 X146.9 Y144.206 E.0181
G1 X147.13 Y144.123 E.00883
G1 X147.341 Y144.004 E.00876
G1 X147.566 Y143.815 E.01058
G1 X147.769 Y143.549 E.01208
G1 X147.917 Y143.258 E.01179
G1 X147.973 Y143.083 E.00664
G1 X148.043 Y142.654 E.01571
G1 X148.043 Y136.582 E.21922
G1 X148.071 Y136.233 E.01266
G1 X148.229 Y135.673 E.02099
G1 X148.42 Y135.293 E.01539
G1 X148.646 Y134.998 E.01341
G1 X148.91 Y134.758 E.01288
G1 X149.2 Y134.573 E.0124
G1 X149.496 Y134.442 E.01169
G1 X149.841 Y134.345 E.01295
G1 X150.354 Y134.293 E.01861
G1 X209.673 Y134.294 E2.14179
G1 X210.092 Y134.335 E.01517
G1 X210.575 Y134.478 E.0182
G1 X210.956 Y134.67 E.01541
G1 X211.268 Y134.91 E.01422
G1 X211.493 Y135.16 E.01214
G1 X211.66 Y135.418 E.01109
G1 X211.79 Y135.7 E.0112
G1 X211.906 Y136.094 E.01485
G1 X211.955 Y136.562 E.01699
G1 X211.955 Y152.948 E.59161
G1 X211.915 Y153.333 E.014
G1 X211.73 Y153.923 E.02233
G1 X211.575 Y154.218 E.01202
G1 X211.384 Y154.471 E.01144
G1 X211.122 Y154.717 E.01296
G1 X210.835 Y154.908 E.01248
G1 X210.535 Y155.046 E.01189
G1 X210.205 Y155.146 E.01246
G1 X209.645 Y155.207 E.02035
G1 X176.094 Y155.207 E1.2114
G1 X175.602 Y155.294 E.01802
G1 X175.296 Y155.415 E.01189
G1 X175.07 Y155.561 E.0097
M73 P36 R10
G1 X174.934 Y155.684 E.00662
G1 X174.778 Y155.877 E.00896
G1 X174.568 Y156.292 E.01678
G1 X174.527 Y156.418 E.00479
G1 X174.457 Y156.846 E.01568
G1 X174.456 Y183.423 E.95957
G1 X174.415 Y183.833 E.0149
G1 X174.21 Y184.47 E.02414
G1 X174.064 Y184.736 E.01096
G1 X173.884 Y184.97 E.01066
G1 X173.588 Y185.243 E.01457
G1 X173.3 Y185.427 E.01232
G1 X173.004 Y185.558 E.01169
G1 X172.659 Y185.655 E.01295
G1 X172.146 Y185.707 E.01861
G1 X140.338 Y185.707 E1.14845
G1 X139.916 Y185.665 E.0153
G1 X139.28 Y185.46 E.02412
G1 X139.014 Y185.314 E.01096
G1 X138.78 Y185.134 E.01066
G1 X138.507 Y184.838 E.01457
G1 X138.323 Y184.55 E.01232
G1 X138.192 Y184.254 E.01169
G1 X138.095 Y183.909 E.01295
G1 X138.043 Y183.396 E.01861
G1 X138.043 Y146.588 E1.32899
G1 X138.085 Y146.166 E.0153
G1 X138.289 Y145.531 E.02409
G1 X138.446 Y145.25 E.01163
G1 X138.554 Y145.115 E.00622
M204 S6000
G1 X138.895 Y145.426 F60000
G1 F3000
M204 S500
G1 X139.075 Y145.228 E.00966
G1 X139.169 Y145.151 E.00439
G1 X139.552 Y144.917 E.0162
G1 X139.78 Y144.836 E.00875
G1 X140.168 Y144.761 E.01425
G1 X148.364 Y144.75 E.29592
G1 X148.468 Y144.702 E.00413
G1 X148.501 Y144.613 E.00343
G1 X148.519 Y136.332 E.299
G1 X148.588 Y136.019 E.01159
G1 X148.69 Y135.759 E.0101
G1 X148.849 Y135.488 E.01131
G1 X149.071 Y135.233 E.01221
G1 X149.17 Y135.15 E.00469
G1 X149.552 Y134.917 E.01613
G1 X149.778 Y134.837 E.00865
G1 X150.285 Y134.75 E.01858
G1 X209.718 Y134.75 E2.14591
G1 X210.165 Y134.817 E.01632
G1 X210.288 Y134.853 E.00462
G1 X210.569 Y134.975 E.01106
G1 X210.797 Y135.121 E.00979
G1 X211.1 Y135.42 E.01537
G1 X211.283 Y135.704 E.0122
G1 X211.383 Y135.928 E.00886
G1 X211.5 Y136.536 E.02235
G1 X211.5 Y152.968 E.5933
G1 X211.433 Y153.416 E.01632
G1 X211.397 Y153.538 E.00461
G1 X211.275 Y153.819 E.01106
G1 X211.129 Y154.048 E.00979
G1 X210.83 Y154.35 E.01537
G1 X210.546 Y154.533 E.0122
G1 X210.322 Y154.633 E.00886
G1 X209.714 Y154.75 E.02235
G1 X174.137 Y154.75 E1.28454
G1 X174.033 Y154.797 E.00413
G1 X174 Y154.887 E.00344
G1 X174 Y183.47 E1.03204
G1 X173.945 Y183.861 E.01424
G1 X173.828 Y184.201 E.01298
G1 X173.661 Y184.493 E.01215
G1 X173.428 Y184.767 E.013
G1 X173.33 Y184.85 E.00466
G1 X172.948 Y185.083 E.01613
G1 X172.722 Y185.163 E.00865
G1 X172.215 Y185.25 E.01858
G1 X140.282 Y185.25 E1.153
G1 X139.834 Y185.183 E.01632
G1 X139.712 Y185.147 E.00461
G1 X139.431 Y185.025 E.01106
G1 X139.202 Y184.879 E.00979
G1 X138.9 Y184.58 E.01537
G1 X138.716 Y184.296 E.0122
G1 X138.617 Y184.072 E.00886
G1 X138.5 Y183.464 E.02235
G1 X138.5 Y146.526 E1.33367
G1 X138.534 Y146.219 E.01117
G1 X138.651 Y145.833 E.01454
G1 X138.739 Y145.65 E.00736
G1 X138.857 Y145.472 E.0077
M204 S6000
G1 X139.232 Y145.733 F60000
G1 F3000
M204 S500
G1 X139.25 Y145.708 E.0011
G1 X139.411 Y145.538 E.00846
G1 X139.711 Y145.345 E.01288
G1 X139.857 Y145.287 E.00569
G1 X140.268 Y145.207 E.01509
G1 X148.82 Y145.207 E.3088
G1 X148.924 Y145.16 E.00413
G1 X148.957 Y145.07 E.00344
G1 X148.965 Y136.429 E.312
G1 X149.01 Y136.196 E.00857
G1 X149.12 Y135.915 E.01088
G1 X149.24 Y135.725 E.00813
G1 X149.412 Y135.538 E.00919
G1 X149.711 Y135.345 E.01284
G1 X149.855 Y135.288 E.00561
G1 X150.273 Y135.207 E.01536
G1 X209.729 Y135.207 E2.1467
G1 X210.098 Y135.269 E.01352
G1 X210.397 Y135.399 E.01176
G1 X210.542 Y135.5 E.0064
M73 P37 R10
G1 X210.712 Y135.661 E.00846
G1 X210.905 Y135.961 E.01287
G1 X210.962 Y136.105 E.00561
G1 X211.043 Y136.523 E.01536
G1 X211.043 Y152.979 E.59414
G1 X210.981 Y153.348 E.01352
G1 X210.851 Y153.647 E.01176
G1 X210.75 Y153.792 E.0064
G1 X210.589 Y153.962 E.00846
G1 X210.289 Y154.155 E.01287
G1 X210.145 Y154.212 E.00561
G1 X209.727 Y154.293 E.01536
G1 X173.68 Y154.293 E1.30151
G1 X173.576 Y154.34 E.00413
G1 X173.543 Y154.43 E.00344
G1 X173.543 Y183.48 E1.04888
G1 X173.511 Y183.721 E.00878
G1 X173.438 Y183.963 E.00913
G1 X173.258 Y184.277 E.01307
G1 X173.088 Y184.462 E.00908
G1 X172.789 Y184.655 E.01283
G1 X172.645 Y184.712 E.00561
G1 X172.227 Y184.793 E.01536
G1 X140.271 Y184.793 E1.15378
G1 X139.902 Y184.731 E.01352
G1 X139.603 Y184.601 E.01176
G1 X139.458 Y184.5 E.0064
G1 X139.288 Y184.339 E.00846
G1 X139.095 Y184.039 E.01288
G1 X139.038 Y183.895 E.00561
G1 X138.957 Y183.477 E.01536
G1 X138.957 Y146.519 E1.33441
G1 X138.989 Y146.265 E.00923
G1 X139.087 Y145.97 E.01121
G1 X139.146 Y145.858 E.00459
G1 X139.198 Y145.782 E.00331
M204 S6000
G1 X139.573 Y146.043 F60000
G1 F3000
M204 S500
G1 X139.631 Y145.96 E.00364
G1 X139.735 Y145.86 E.00524
G1 X139.948 Y145.735 E.0089
G1 X140.26 Y145.664 E.01155
G1 X149.277 Y145.664 E.32558
G1 X149.381 Y145.617 E.00413
G1 X149.414 Y145.527 E.00344
G1 X149.414 Y136.511 E.32554
G1 X149.441 Y136.345 E.00607
G1 X149.499 Y136.17 E.00666
G1 X149.633 Y135.958 E.00905
G1 X149.735 Y135.86 E.00513
G1 X149.948 Y135.735 E.0089
G1 X150.26 Y135.664 E.01155
G1 X209.74 Y135.664 E2.14758
G1 X209.928 Y135.692 E.00687
G1 X210.125 Y135.766 E.00757
G1 X210.29 Y135.881 E.00726
M73 P37 R9
G1 X210.39 Y135.985 E.00524
G1 X210.515 Y136.198 E.0089
G1 X210.586 Y136.51 E.01155
G1 X210.586 Y152.99 E.59502
G1 X210.558 Y153.178 E.00687
G1 X210.484 Y153.375 E.00757
G1 X210.369 Y153.54 E.00726
G1 X210.265 Y153.64 E.00524
G1 X210.052 Y153.765 E.0089
G1 X209.74 Y153.836 E.01155
G1 X173.223 Y153.836 E1.31849
G1 X173.119 Y153.883 E.00413
G1 X173.086 Y153.973 E.00344
G1 X173.086 Y183.489 E1.06571
G1 X173.059 Y183.655 E.00607
G1 X173 Y183.83 E.00666
G1 X172.867 Y184.042 E.00905
G1 X172.765 Y184.14 E.00513
G1 X172.552 Y184.265 E.0089
G1 X172.24 Y184.336 E.01155
G1 X140.26 Y184.336 E1.15466
G1 X140.072 Y184.308 E.00687
G1 X139.875 Y184.234 E.00757
G1 X139.71 Y184.119 E.00726
G1 X139.61 Y184.015 E.00524
G1 X139.485 Y183.802 E.0089
G1 X139.414 Y183.49 E.01155
G1 X139.414 Y146.51 E1.33519
G1 X139.442 Y146.322 E.00687
G1 X139.516 Y146.125 E.00757
G1 X139.539 Y146.092 E.00146
M204 S6000
G1 X139.938 Y146.299 F60000
G1 F3000
M204 S500
G1 X140.064 Y146.177 E.00631
G1 X140.25 Y146.121 E.007
G1 X149.871 Y146.121 E.34739
G1 X149.871 Y136.5 E.34739
G1 X149.938 Y136.299 E.00766
G1 X150.064 Y136.177 E.00631
G1 X150.25 Y136.121 E.007
G1 X209.75 Y136.121 E2.14831
G1 X209.841 Y136.141 E.00337
G1 X209.951 Y136.188 E.00433
G1 X210.073 Y136.314 E.00631
M73 P38 R9
G1 X210.129 Y136.5 E.007
G1 X210.129 Y153 E.59575
G1 X210.109 Y153.091 E.00337
G1 X210.062 Y153.201 E.00433
G1 X209.936 Y153.323 E.00631
G1 X209.75 Y153.379 E.007
G1 X172.629 Y153.379 E1.34031
G1 X172.629 Y183.5 E1.08757
G1 X172.562 Y183.701 E.00766
G1 X172.436 Y183.823 E.00631
G1 X172.25 Y183.879 E.007
G1 X140.25 Y183.879 E1.15539
G1 X140.159 Y183.859 E.00337
G1 X140.049 Y183.812 E.00433
G1 X139.927 Y183.686 E.00631
G1 X139.871 Y183.5 E.007
G1 X139.871 Y146.5 E1.33592
G1 X139.891 Y146.409 E.00337
G1 X139.914 Y146.354 E.00216
; WIPE_START
G1 X140.064 Y146.177 E-.08795
G1 X140.25 Y146.121 E-.07367
G1 X141.825 Y146.121 E-.59838
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X149.428 Y146.792 Z.6 F60000
G1 X150.65 Y146.9 Z.6
G1 Z.2
G1 E.8 F1800
; FEATURE: Outer wall
G1 F3000
M204 S500
G1 X150.65 Y136.9 E.36106
G1 X209.35 Y136.9 E2.11942
G1 X209.35 Y152.6 E.56686
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X171.85 Y152.6 E1.35398
G1 X171.85 Y183.1 E1.10123
G1 X140.65 Y183.1 E1.12651
G1 X140.65 Y146.9 E1.30704
G1 X150.59 Y146.9 E.35889
M204 S6000
G1 X151.107 Y147.357 F60000
; FEATURE: Inner wall
G1 F3000
M204 S500
G1 X151.107 Y137.357 E.36106
G1 X208.893 Y137.357 E2.08642
G1 X208.893 Y152.143 E.53386
G1 X171.393 Y152.143 E1.35398
M73 P39 R9
G1 X171.393 Y182.643 E1.10123
G1 X141.107 Y182.643 E1.0935
G1 X141.107 Y147.357 E1.27403
G1 X151.047 Y147.357 E.35889
M204 S6000
G1 X151.564 Y147.814 F60000
G1 F3000
M204 S500
G1 X151.564 Y137.814 E.36106
G1 X208.436 Y137.814 E2.05341
G1 X208.436 Y151.686 E.50085
G1 X170.936 Y151.686 E1.35398
G1 X170.936 Y182.186 E1.10123
G1 X141.564 Y182.186 E1.0605
G1 X141.564 Y147.814 E1.24103
G1 X151.504 Y147.814 E.35889
; WIPE_START
G1 X151.516 Y145.814 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S6000
M73 P40 R9
G1 X159.107 Y145.021 Z.6 F60000
G1 X207.778 Y139.935 Z.6
G1 Z.2
G1 E.8 F1800
G1 F3000
M204 S500
G2 X205.93 Y138.512 I-2.535 J1.38 E.08669
G1 X205.96 Y138.271 E.00876
G1 X207.979 Y138.271 E.0729
G1 X207.979 Y139.88 E.05807
G1 X207.836 Y139.919 E.00536
; WIPE_START
G1 X207.632 Y139.693 E-.1156
G1 X207.456 Y139.459 E-.1113
G1 X207.276 Y139.262 E-.10143
G1 X207.058 Y139.066 E-.11136
G1 X206.82 Y138.894 E-.11165
G1 X206.585 Y138.756 E-.10376
G1 X206.334 Y138.639 E-.10489
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X205.052 Y142.784 Z.6 F60000
G1 Z.2
G1 E.8 F1800
; FEATURE: Outer wall
G1 F3000
M204 S500
G1 X204.81 Y142.733 E.00891
G3 X205.093 Y139.808 I.438 J-1.434 E.1484
G1 X205.243 Y139.8 E.00542
G3 X205.111 Y142.793 I.006 J1.5 E.17531
M204 S6000
G1 X204.961 Y143.23 F60000
; FEATURE: Inner wall
G1 F3000
M204 S500
G1 X204.675 Y143.17 E.01053
G3 X205.044 Y139.353 I.572 J-1.871 E.19365
G1 X205.24 Y139.342 E.00706
G3 X205.047 Y143.246 I.008 J1.957 E.22955
G1 X205.02 Y143.241 E.00099
M204 S6000
G1 X204.87 Y143.676 F60000
G1 F3000
M204 S500
G1 X204.54 Y143.607 E.01215
G3 X204.996 Y138.897 I.707 J-2.309 E.2389
G1 X205.237 Y138.884 E.00871
G3 X205 Y143.701 I.01 J2.414 E.28317
G1 X204.929 Y143.687 E.00261
M204 S6000
G1 X204.845 Y144.141 F60000
G1 F3000
M204 S500
G1 X204.952 Y144.156 E.00391
G2 X207.779 Y142.666 I.3 J-2.856 E.12235
G1 X207.979 Y142.723 E.00749
G1 X207.979 Y151.229 E.30713
G1 X170.479 Y151.229 E1.35398
G1 X170.479 Y177.077 E.93329
G1 X170.279 Y177.134 E.00749
G2 X170.279 Y179.866 I-2.527 J1.366 E.54889
G1 X170.479 Y179.923 E.00749
G1 X170.479 Y181.729 E.06522
G1 X142.021 Y181.729 E1.02749
G1 X142.021 Y148.271 E1.20802
G1 X152.021 Y148.271 E.36106
G1 X152.021 Y143.155 E.18474
G2 X153.702 Y144.121 I2.429 J-2.28 E.07102
G2 X154.932 Y138.512 I.547 J-2.819 E.32076
G1 X154.961 Y138.271 E.00877
G1 X204.541 Y138.271 E1.79015
G1 X204.572 Y138.511 E.00872
G2 X204.669 Y144.112 I.681 J2.79 E.27968
G1 X204.786 Y144.132 E.00428
; WIPE_START
G1 X204.952 Y144.156 E-.06392
G1 X205.242 Y144.173 E-.11036
G1 X205.509 Y144.162 E-.10137
G1 X205.798 Y144.121 E-.1111
G1 X206.09 Y144.048 E-.11428
G1 X206.373 Y143.945 E-.11416
G1 X206.635 Y143.817 E-.11099
G1 X206.711 Y143.771 E-.03381
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X199.2 Y145.126 Z.6 F60000
G1 X154.525 Y153.188 Z.6
G1 Z.2
G1 E.8 F1800
; FEATURE: Outer wall
G1 F3000
M204 S500
G1 X154.539 Y153.178 E.00061
G3 X155.093 Y153.008 I.71 J1.321 E.02106
G1 X155.242 Y153 E.00541
G3 X154.304 Y153.335 I.006 J1.499 E.3035
G1 X154.475 Y153.221 E.00741
M204 S6000
G1 X154.272 Y152.809 F60000
; FEATURE: Inner wall
G1 F3000
M204 S500
G1 X154.321 Y152.775 E.00214
G3 X155.044 Y152.553 I.927 J1.723 E.0275
G1 X155.24 Y152.542 E.00706
G3 X154.014 Y152.98 I.009 J1.957 E.39604
G1 X154.222 Y152.842 E.00901
M204 S6000
G1 X154.019 Y152.43 F60000
G1 F3000
M204 S500
M73 P41 R9
G1 X154.104 Y152.373 E.00369
G3 X154.996 Y152.098 I1.144 J2.126 E.03393
G1 X155.237 Y152.084 E.0087
G3 X153.725 Y152.625 I.011 J2.414 E.48858
G1 X153.969 Y152.463 E.01059
M204 S6000
G1 X153.821 Y152.01 F60000
G1 F3000
M204 S500
G1 X153.886 Y151.97 E.00277
G3 X154.948 Y151.642 I1.361 J2.529 E.04037
G1 X155.234 Y151.627 E.01034
G3 X153.648 Y152.113 I.013 J2.872 E.59069
G1 X153.769 Y152.041 E.0051
; WIPE_START
G1 X153.886 Y151.97 E-.05193
G1 X154.133 Y151.853 E-.10373
G1 X154.403 Y151.754 E-.10934
G1 X154.66 Y151.688 E-.10088
G1 X154.948 Y151.642 E-.11071
G1 X155.234 Y151.627 E-.10882
G1 X155.506 Y151.638 E-.10357
G1 X155.691 Y151.664 E-.07104
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X153.495 Y144.354 Z.6 F60000
G1 X152.021 Y139.449 Z.6
G1 Z.2
G1 E.8 F1800
G1 F3000
M204 S500
G1 X152.021 Y138.271 E.04254
G1 X153.541 Y138.271 E.05489
G1 X153.572 Y138.511 E.00872
G2 X152.062 Y139.406 I.876 J3.197 E.06413
; WIPE_START
G1 X152.021 Y138.271 E-.43151
G1 X152.886 Y138.271 E-.32849
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X154.067 Y142.785 Z.6 F60000
G1 Z.2
G1 E.8 F1800
; FEATURE: Outer wall
G1 F3000
M204 S500
G1 X153.812 Y142.734 E.00938
G3 X154.093 Y139.808 I.437 J-1.434 E.14844
G1 X154.243 Y139.8 E.00542
G3 X154.126 Y142.794 I.006 J1.499 E.17474
M204 S6000
G1 X153.98 Y143.232 F60000
; FEATURE: Inner wall
G1 F3000
M204 S500
G1 X153.679 Y143.171 E.01109
G3 X154.044 Y139.353 I.569 J-1.872 E.19375
G1 X154.24 Y139.342 E.00706
G3 X154.075 Y143.248 I.008 J1.957 E.22851
G1 X154.039 Y143.242 E.00133
M204 S6000
G1 X153.945 Y143.694 F60000
G1 F3000
M204 S500
G1 X153.79 Y143.669 E.00568
G3 X153.996 Y138.897 I.457 J-2.37 E.24815
G1 X154.237 Y138.884 E.0087
G3 X154.033 Y143.703 I.01 J2.414 E.28194
G1 X154.005 Y143.7 E.00103
; WIPE_START
G1 X153.79 Y143.669 E-.08261
G1 X153.545 Y143.611 E-.09564
G1 X153.113 Y143.431 E-.17779
G1 X152.725 Y143.173 E-.17691
G1 X152.542 Y143.008 E-.09387
G1 X152.372 Y142.82 E-.09628
G1 X152.315 Y142.741 E-.03689
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X155.6 Y149.63 Z.6 F60000
G1 X168.929 Y177.578 Z.6
G1 Z.2
G1 E.8 F1800
; FEATURE: Outer wall
G1 F3000
M204 S500
G1 X169.062 Y177.774 E.00855
G3 X167.593 Y177.008 I-1.313 J.725 E.27679
G1 X167.742 Y177 E.00541
G3 X168.893 Y177.53 I.006 J1.499 E.04723
M204 S6000
G1 X169.305 Y177.321 F60000
; FEATURE: Inner wall
G1 F3000
M204 S500
G1 X169.462 Y177.555 E.01017
G3 X167.544 Y176.553 I-1.714 J.944 E.36115
G1 X167.74 Y176.542 E.00706
G3 X169.251 Y177.246 I.009 J1.957 E.06218
G1 X169.27 Y177.272 E.00118
M204 S6000
G1 X169.681 Y177.064 F60000
G1 F3000
M204 S500
G1 X169.863 Y177.335 E.01178
G3 X167.496 Y176.098 I-2.115 J1.164 E.44551
G1 X167.737 Y176.084 E.0087
G3 X169.602 Y176.953 I.011 J2.414 E.07677
G1 X169.646 Y177.015 E.00273
M204 S6000
G1 X170.23 Y176.609 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.118433
G1 F3000
M204 S500
G2 X170.064 Y176.398 I-.343 J.1 E.00164
M204 S6000
G1 X170.43 Y177.329 F60000
; LINE_WIDTH: 0.499966
G1 F3000
M204 S500
G1 X170.487 Y177.651 E.01181
; LINE_WIDTH: 0.463563
G1 X170.507 Y177.812 E.00538
; LINE_WIDTH: 0.426814
G1 X170.524 Y177.949 E.00421
; LINE_WIDTH: 0.388918
G3 X170.544 Y178.232 I-5.448 J.538 E.00774
; LINE_WIDTH: 0.362305
G3 X170.544 Y178.783 I-7.923 J.267 E.01391
; LINE_WIDTH: 0.390967
G3 X170.522 Y179.063 I-5.487 J-.276 E.00774
; LINE_WIDTH: 0.429912
G1 X170.505 Y179.206 E.00441
; LINE_WIDTH: 0.463633
G1 X170.489 Y179.332 E.0042
; LINE_WIDTH: 0.49958
G3 X170.43 Y179.671 I-6.929 J-1.036 E.01243
; WIPE_START
G1 X170.489 Y179.332 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X170.25 Y181.073 Z.6 F60000
G1 Z.2
G1 E.8 F1800
; LINE_WIDTH: 0.507101
G1 F3000
M204 S500
G1 X168.845 Y181.5 E.05387
; WIPE_START
G1 X170.25 Y181.073 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X166.794 Y181.475 Z.6 F60000
G1 Z.2
G1 E.8 F1800
; LINE_WIDTH: 0.125134
G1 F3000
M204 S500
G1 X166.653 Y181.451 E.00093
; LINE_WIDTH: 0.170828
G1 X166.504 Y181.424 E.00153
; LINE_WIDTH: 0.202859
G1 X166.47 Y181.416 E.00044
; LINE_WIDTH: 0.190308
G1 X166.353 Y181.336 E.00166
; LINE_WIDTH: 0.148854
G1 X166.232 Y181.254 E.00123
; LINE_WIDTH: 0.11548
G1 X166.103 Y181.157 E.00092
; WIPE_START
G1 X166.232 Y181.254 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X163.587 Y174.094 Z.6 F60000
G1 X152.409 Y143.827 Z.6
G1 Z.2
G1 E.8 F1800
; LINE_WIDTH: 0.113499
G1 F3000
M204 S500
G1 X152.25 Y143.731 E.00104
M204 S6000
G1 X152.104 Y142.885 F60000
; LINE_WIDTH: 0.116943
G1 F3000
M204 S500
G1 X151.994 Y142.763 E.00096
; LINE_WIDTH: 0.146962
G1 X151.893 Y142.638 E.00131
; LINE_WIDTH: 0.178141
G1 X151.793 Y142.514 E.00171
M204 S6000
G1 X151.813 Y142.388 F60000
; LINE_WIDTH: 0.153278
G1 F3000
M204 S500
G1 X151.897 Y142.735 E.00312
; WIPE_START
G1 X151.813 Y142.388 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X151.811 Y140.213 Z.6 F60000
G1 Z.2
G1 E.8 F1800
; LINE_WIDTH: 0.171939
G1 F3000
M204 S500
G1 X151.858 Y140.027 E.00196
G3 X151.941 Y139.908 I.177 J.035 E.00152
; LINE_WIDTH: 0.135576
G1 X152.017 Y139.815 E.00088
; LINE_WIDTH: 0.110377
G1 X152.089 Y139.734 E.00057
; WIPE_START
G1 X152.017 Y139.815 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X152.25 Y138.69 Z.6 F60000
G1 Z.2
G1 E.8 F1800
; LINE_WIDTH: 0.300464
G1 F3000
M204 S500
G3 X152.818 Y138.51 I3.848 J11.184 E.01212
M204 S6000
G1 X152.821 Y138.523 F60000
; LINE_WIDTH: 0.116533
G1 F3000
M204 S500
G2 X152.25 Y138.666 I2.725 J12.1 E.00342
; WIPE_START
G1 X152.821 Y138.523 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X155.77 Y138.5 Z.6 F60000
G1 Z.2
G1 E.8 F1800
; LINE_WIDTH: 0.160045
G1 F3000
M204 S500
G1 X155.969 Y138.661 E.00237
; LINE_WIDTH: 0.12045
G1 X156.123 Y138.798 E.00126
; WIPE_START
G1 X155.969 Y138.661 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X163.602 Y138.627 Z.6 F60000
G1 X202.489 Y138.454 Z.6
G1 Z.2
G1 E.8 F1800
; FEATURE: Bottom surface
; LINE_WIDTH: 0.50141
G1 F6300
M204 S500
G1 X202.775 Y138.74 E.01464
G1 X202.971 Y138.969 E.01092
G2 X202.682 Y139.295 I2.665 J2.649 E.01581
G1 X202.046 Y138.66 E.03256
G1 X201.398 Y138.66 E.02348
G1 X202.421 Y139.683 E.05239
G2 X202.211 Y140.122 I3.121 J1.755 E.01763
G1 X200.749 Y138.66 E.07489
G1 X200.101 Y138.66 E.02348
G1 X202.062 Y140.62 E.10042
G2 X201.993 Y141.2 I3.611 J.724 E.02116
G1 X199.452 Y138.66 E.1301
G1 X198.804 Y138.66 E.02348
G1 X202.323 Y142.179 E.18026
; WIPE_START
G1 X200.909 Y140.765 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X207.109 Y143.722 Z.6 F60000
G1 Z.2
G1 E.8 F1800
G1 F6300
M204 S500
G1 X207.59 Y144.204 E.02467
G1 X207.59 Y144.852 E.02348
G1 X206.868 Y144.13 E.03699
G3 X206.428 Y144.339 I-1.857 J-3.355 E.01765
G1 X207.59 Y145.501 E.05953
G1 X207.59 Y146.149 E.02348
G1 X205.93 Y144.488 E.08506
G3 X205.35 Y144.557 I-.723 J-3.612 E.02116
G1 X207.59 Y146.798 E.11474
G1 X207.59 Y147.446 E.02348
G1 X204.37 Y144.226 E.16492
; WIPE_START
G1 X205.785 Y145.64 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X207.796 Y148.3 Z.6 F60000
G1 Z.2
G1 E.8 F1800
G1 F6300
M204 S500
G1 X198.156 Y138.66 E.49377
G1 X197.507 Y138.66 E.02348
G1 X207.59 Y148.743 E.51644
G1 X207.59 Y149.391 E.02348
G1 X196.859 Y138.66 E.54966
G1 X196.21 Y138.66 E.02348
M73 P42 R9
G1 X207.59 Y150.04 E.58287
G1 X207.59 Y150.688 E.02348
G1 X195.562 Y138.66 E.61608
G1 X194.914 Y138.66 E.02348
G1 X207.094 Y150.84 E.62388
G1 X206.446 Y150.84 E.02348
G1 X194.265 Y138.66 E.62388
G1 X193.617 Y138.66 E.02348
G1 X205.797 Y150.84 E.62388
G1 X205.149 Y150.84 E.02348
G1 X192.968 Y138.66 E.62388
G1 X192.32 Y138.66 E.02348
G1 X204.501 Y150.84 E.62388
G1 X203.852 Y150.84 E.02348
G1 X191.672 Y138.66 E.62388
G1 X191.023 Y138.66 E.02348
G1 X203.204 Y150.84 E.62388
G1 X202.555 Y150.84 E.02348
G1 X190.375 Y138.66 E.62388
G1 X189.726 Y138.66 E.02348
G1 X201.907 Y150.84 E.62388
G1 X201.259 Y150.84 E.02348
G1 X189.078 Y138.66 E.62388
G1 X188.43 Y138.66 E.02348
G1 X200.61 Y150.84 E.62388
G1 X199.962 Y150.84 E.02348
G1 X187.781 Y138.66 E.62388
G1 X187.133 Y138.66 E.02348
G1 X199.313 Y150.84 E.62388
G1 X198.665 Y150.84 E.02348
G1 X186.484 Y138.66 E.62388
G1 X185.836 Y138.66 E.02348
G1 X198.017 Y150.84 E.62388
G1 X197.368 Y150.84 E.02348
G1 X185.188 Y138.66 E.62388
G1 X184.539 Y138.66 E.02348
G1 X196.72 Y150.84 E.62388
G1 X196.071 Y150.84 E.02348
G1 X183.891 Y138.66 E.62388
G1 X183.242 Y138.66 E.02348
G1 X195.423 Y150.84 E.62388
G1 X194.775 Y150.84 E.02348
G1 X182.594 Y138.66 E.62388
G1 X181.946 Y138.66 E.02348
G1 X194.126 Y150.84 E.62388
G1 X193.478 Y150.84 E.02348
G1 X181.297 Y138.66 E.62388
G1 X180.649 Y138.66 E.02348
G1 X192.829 Y150.84 E.62388
G1 X192.181 Y150.84 E.02348
G1 X180 Y138.66 E.62388
M73 P43 R9
G1 X179.352 Y138.66 E.02348
G1 X191.533 Y150.84 E.62388
G1 X190.884 Y150.84 E.02348
G1 X178.704 Y138.66 E.62388
G1 X178.055 Y138.66 E.02348
G1 X190.236 Y150.84 E.62388
G1 X189.587 Y150.84 E.02348
G1 X177.407 Y138.66 E.62388
G1 X176.758 Y138.66 E.02348
G1 X188.939 Y150.84 E.62388
G1 X188.291 Y150.84 E.02348
G1 X176.11 Y138.66 E.62388
G1 X175.462 Y138.66 E.02348
G1 X187.642 Y150.84 E.62388
G1 X186.994 Y150.84 E.02348
G1 X174.813 Y138.66 E.62388
G1 X174.165 Y138.66 E.02348
G1 X186.345 Y150.84 E.62388
G1 X185.697 Y150.84 E.02348
G1 X173.516 Y138.66 E.62388
G1 X172.868 Y138.66 E.02348
G1 X185.048 Y150.84 E.62388
G1 X184.4 Y150.84 E.02348
G1 X172.22 Y138.66 E.62388
G1 X171.571 Y138.66 E.02348
G1 X183.752 Y150.84 E.62388
G1 X183.103 Y150.84 E.02348
G1 X170.923 Y138.66 E.62388
G1 X170.274 Y138.66 E.02348
G1 X182.455 Y150.84 E.62388
G1 X181.806 Y150.84 E.02348
G1 X169.626 Y138.66 E.62388
G1 X168.978 Y138.66 E.02348
G1 X181.158 Y150.84 E.62388
G1 X180.51 Y150.84 E.02348
G1 X168.329 Y138.66 E.62388
M73 P43 R8
G1 X167.681 Y138.66 E.02348
G1 X179.861 Y150.84 E.62388
G1 X179.213 Y150.84 E.02348
G1 X167.032 Y138.66 E.62388
G1 X166.384 Y138.66 E.02348
G1 X178.564 Y150.84 E.62388
G1 X177.916 Y150.84 E.02348
G1 X165.736 Y138.66 E.62388
G1 X165.087 Y138.66 E.02348
G1 X177.268 Y150.84 E.62388
G1 X176.619 Y150.84 E.02348
G1 X164.439 Y138.66 E.62388
G1 X163.79 Y138.66 E.02348
G1 X175.971 Y150.84 E.62388
M73 P44 R8
G1 X175.322 Y150.84 E.02348
G1 X163.142 Y138.66 E.62388
G1 X162.493 Y138.66 E.02348
G1 X174.674 Y150.84 E.62388
G1 X174.026 Y150.84 E.02348
G1 X161.845 Y138.66 E.62388
G1 X161.197 Y138.66 E.02348
G1 X173.377 Y150.84 E.62388
G1 X172.729 Y150.84 E.02348
G1 X160.548 Y138.66 E.62388
G1 X159.9 Y138.66 E.02348
G1 X172.08 Y150.84 E.62388
G1 X171.432 Y150.84 E.02348
G1 X159.251 Y138.66 E.62388
G1 X158.603 Y138.66 E.02348
G1 X170.784 Y150.84 E.62388
G1 X170.135 Y150.84 E.02348
G1 X157.955 Y138.66 E.62388
G1 X157.306 Y138.66 E.02348
G1 X170.09 Y151.444 E.65479
G1 X170.09 Y152.092 E.02348
G1 X156.658 Y138.66 E.688
G1 X156.643 Y138.66 E.00055
G1 X156.712 Y138.722 E.00337
G1 X156.509 Y138.949 E.01106
G3 X157.137 Y139.788 I-2.358 J2.423 E.03811
G1 X170.09 Y152.741 E.66343
G1 X170.09 Y153.389 E.02348
G1 X157.465 Y140.764 E.64666
G3 X157.505 Y141.452 I-3.228 J.532 E.02502
G1 X170.09 Y154.037 E.64462
G1 X170.09 Y154.686 E.02348
G1 X157.428 Y142.024 E.64853
G3 X157.274 Y142.518 I-2.58 J-.534 E.01878
G1 X170.09 Y155.334 E.65644
G1 X170.09 Y155.983 E.02348
G1 X157.06 Y142.952 E.66742
G3 X156.795 Y143.336 I-2.121 J-1.176 E.01691
G1 X170.09 Y156.631 E.68095
G1 X170.09 Y157.279 E.02348
G1 X156.484 Y143.673 E.69691
G3 X156.121 Y143.958 I-1.193 J-1.146 E.01678
G1 X170.09 Y157.928 E.71552
G1 X170.09 Y158.576 E.02348
G1 X155.722 Y144.207 E.73596
G3 X155.264 Y144.398 I-1.139 J-2.087 E.01799
G1 X170.09 Y159.225 E.75939
G1 X170.09 Y159.873 E.02348
G1 X154.739 Y144.521 E.78629
G3 X154.125 Y144.556 I-.494 J-3.28 E.02229
G1 X170.09 Y160.521 E.81772
G1 X170.09 Y161.17 E.02348
M73 P45 R8
G1 X153.355 Y144.435 E.85715
G3 X152.668 Y144.151 I.537 J-2.271 E.02705
G1 X152.576 Y144.304 E.00648
G1 X170.09 Y161.818 E.89706
G1 X170.09 Y162.467 E.02348
G1 X152.41 Y144.786 E.90558
G1 X152.41 Y145.434 E.02348
G1 X170.09 Y163.115 E.90558
G1 X170.09 Y163.763 E.02348
G1 X152.41 Y146.083 E.90558
G1 X152.41 Y146.731 E.02348
G1 X170.09 Y164.412 E.90558
G1 X170.09 Y165.06 E.02348
G1 X158.251 Y153.221 E.60638
G2 X157.75 Y152.404 I-3.34 J1.486 E.03484
G1 X157.346 Y152 E.02068
G2 X156.534 Y151.503 I-2.247 J2.765 E.0346
G1 X152.41 Y147.38 E.21122
G1 X152.41 Y148.028 E.02348
G1 X155.647 Y151.266 E.16583
G2 X154.985 Y151.251 I-.403 J3.329 E.02405
G1 X152.393 Y148.66 E.13274
G1 X151.745 Y148.66 E.02348
G1 X154.431 Y151.346 E.13759
G2 X153.947 Y151.511 I1.038 J3.835 E.01851
G1 X151.096 Y148.66 E.14603
G1 X150.448 Y148.66 E.02348
G1 X153.524 Y151.736 E.15756
G2 X153.148 Y152.008 I1.898 J3.015 E.01683
G1 X149.799 Y148.66 E.17151
G1 X149.151 Y148.66 E.02348
G1 X152.82 Y152.329 E.18794
G2 X152.544 Y152.701 I1.171 J1.16 E.01684
G1 X148.503 Y148.66 E.20698
G1 X147.854 Y148.66 E.02348
G1 X152.303 Y153.109 E.22788
G2 X152.124 Y153.578 I3.018 J1.423 E.0182
G1 X147.206 Y148.66 E.2519
G1 X146.557 Y148.66 E.02348
G1 X152.012 Y154.115 E.27939
G2 X152 Y154.751 I3.754 J.388 E.02309
G1 X145.703 Y148.454 E.32254
; WIPE_START
G1 X147.118 Y149.868 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X154.302 Y152.444 Z.6 F60000
G1 X158.235 Y153.853 Z.6
G1 Z.2
G1 E.8 F1800
G1 F6300
M204 S500
G1 X170.09 Y165.709 E.60723
G1 X170.09 Y166.357 E.02348
G1 X158.499 Y154.765 E.59371
G3 X158.404 Y155.319 I-3.502 J-.315 E.02036
G1 X170.09 Y167.005 E.59856
G1 X170.09 Y167.654 E.02348
G1 X158.239 Y155.803 E.60699
G3 X158.009 Y156.221 I-1.596 J-.608 E.01734
G1 X170.09 Y168.302 E.6188
G1 X170.09 Y168.951 E.02348
G1 X157.742 Y156.602 E.63248
G3 X157.421 Y156.93 I-1.747 J-1.389 E.01664
G1 X170.09 Y169.599 E.64891
G1 X170.09 Y170.247 E.02348
G1 X157.058 Y157.215 E.66751
G3 X156.641 Y157.446 I-1.311 J-1.87 E.0173
M73 P46 R8
G1 X170.09 Y170.896 E.68886
G1 X170.09 Y171.544 E.02348
G1 X156.174 Y157.628 E.71279
G3 X155.635 Y157.737 I-.84 J-2.75 E.01994
G1 X170.09 Y172.193 E.74039
G1 X170.09 Y172.841 E.02348
G1 X154.763 Y157.514 E.78506
; WIPE_START
G1 X156.177 Y158.928 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X150.621 Y153.695 Z.6 F60000
G1 X145.055 Y148.454 Z.6
G1 Z.2
G1 E.8 F1800
G1 F6300
M204 S500
G1 X152.173 Y155.572 E.36458
G2 X153.669 Y157.354 I3.105 J-1.088 E.08615
G2 X154.178 Y157.577 I1.315 J-2.307 E.02015
G1 X170.09 Y173.489 E.81501
G1 X170.09 Y174.138 E.02348
G1 X144.612 Y148.66 E1.30497
G1 X143.964 Y148.66 E.02348
G1 X170.09 Y174.786 E1.33818
G1 X170.09 Y175.435 E.02348
G1 X143.315 Y148.66 E1.37139
G1 X142.667 Y148.66 E.02348
G1 X169.951 Y175.944 E1.39749
G1 X169.875 Y176.029 E.00412
G2 X168.761 Y175.402 I-2.145 J2.512 E.04658
G1 X142.41 Y149.051 E1.34969
G1 X142.41 Y149.699 E.02348
G1 X167.958 Y175.247 E1.30854
G2 X167.33 Y175.268 I-.199 J3.528 E.02278
G1 X142.41 Y150.348 E1.27638
G1 X142.41 Y150.996 E.02348
G1 X166.795 Y175.381 E1.24898
G2 X166.332 Y175.566 I1.475 J4.36 E.01808
G1 X142.41 Y151.644 E1.22526
G1 X142.41 Y152.293 E.02348
G1 X165.918 Y175.801 E1.20409
G2 X165.558 Y176.089 I1.322 J2.024 E.01673
G1 X142.41 Y152.941 E1.18563
G1 X142.41 Y153.59 E.02348
G1 X165.239 Y176.419 E1.16931
G1 X164.975 Y176.803 E.01689
G1 X142.41 Y154.238 E1.15577
G1 X142.41 Y154.886 E.02348
M73 P47 R8
G1 X164.748 Y177.224 E1.14413
G2 X164.588 Y177.713 I2.482 J1.083 E.01864
G1 X142.41 Y155.535 E1.13594
G1 X142.41 Y156.183 E.02348
G1 X164.499 Y178.273 E1.1314
G2 X164.521 Y178.943 I3.369 J.224 E.02434
G1 X142.41 Y156.832 E1.13254
G1 X142.41 Y157.48 E.02348
G1 X164.787 Y179.857 E1.14614
G2 X165.25 Y180.596 I3.179 J-1.477 E.03165
G1 X165.705 Y181.039 E.02302
G1 X165.54 Y181.259 E.00996
G1 X142.41 Y158.129 E1.18471
G1 X142.41 Y158.777 E.02348
G1 X164.973 Y181.34 E1.15568
G1 X164.325 Y181.34 E.02348
G1 X142.41 Y159.425 E1.12247
G1 X142.41 Y160.074 E.02348
G1 X163.676 Y181.34 E1.08926
G1 X163.028 Y181.34 E.02348
G1 X142.41 Y160.722 E1.05604
G1 X142.41 Y161.371 E.02348
G1 X162.379 Y181.34 E1.02283
G1 X161.731 Y181.34 E.02348
G1 X142.41 Y162.019 E.98962
G1 X142.41 Y162.667 E.02348
G1 X161.083 Y181.34 E.95641
G1 X160.434 Y181.34 E.02348
G1 X142.41 Y163.316 E.9232
G1 X142.41 Y163.964 E.02348
G1 X159.786 Y181.34 E.88999
G1 X159.137 Y181.34 E.02348
G1 X142.41 Y164.613 E.85678
G1 X142.41 Y165.261 E.02348
G1 X158.489 Y181.34 E.82357
G1 X157.841 Y181.34 E.02348
G1 X142.41 Y165.909 E.79036
G1 X142.41 Y166.558 E.02348
G1 X157.192 Y181.34 E.75715
G1 X156.544 Y181.34 E.02348
M73 P48 R8
G1 X142.41 Y167.206 E.72394
G1 X142.41 Y167.855 E.02348
G1 X155.895 Y181.34 E.69073
G1 X155.247 Y181.34 E.02348
G1 X142.41 Y168.503 E.65752
G1 X142.41 Y169.151 E.02348
G1 X154.599 Y181.34 E.62431
G1 X153.95 Y181.34 E.02348
G1 X142.41 Y169.8 E.5911
G1 X142.41 Y170.448 E.02348
G1 X153.302 Y181.34 E.55789
G1 X152.653 Y181.34 E.02348
G1 X142.41 Y171.097 E.52467
G1 X142.41 Y171.745 E.02348
G1 X152.005 Y181.34 E.49146
G1 X151.357 Y181.34 E.02348
G1 X142.41 Y172.393 E.45825
G1 X142.41 Y173.042 E.02348
G1 X150.708 Y181.34 E.42504
G1 X150.06 Y181.34 E.02348
G1 X142.41 Y173.69 E.39183
G1 X142.41 Y174.339 E.02348
G1 X149.411 Y181.34 E.35862
G1 X148.763 Y181.34 E.02348
G1 X142.41 Y174.987 E.32541
G1 X142.41 Y175.635 E.02348
G1 X148.115 Y181.34 E.2922
G1 X147.466 Y181.34 E.02348
G1 X142.41 Y176.284 E.25899
G1 X142.41 Y176.932 E.02348
G1 X146.818 Y181.34 E.22578
G1 X146.169 Y181.34 E.02348
G1 X142.41 Y177.581 E.19257
G1 X142.41 Y178.229 E.02348
G1 X145.521 Y181.34 E.15936
G1 X144.873 Y181.34 E.02348
G1 X142.41 Y178.877 E.12615
G1 X142.41 Y179.526 E.02348
G1 X144.224 Y181.34 E.09294
G1 X143.576 Y181.34 E.02348
G1 X142.41 Y180.174 E.05973
G1 X142.41 Y180.823 E.02348
G1 X143.133 Y181.546 E.03705
; WIPE_START
G1 X142.41 Y180.823 E-.38873
G1 X142.41 Y180.174 E-.24639
G1 X142.642 Y180.407 E-.12487
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X148.939 Y176.093 Z.6 F60000
G1 X203.356 Y138.814 Z.6
G1 Z.2
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.11731
G1 F3000
M204 S500
G1 X203.489 Y138.692 E.00106
; LINE_WIDTH: 0.146049
G1 X203.607 Y138.595 E.00125
; LINE_WIDTH: 0.173753
G1 X203.722 Y138.5 E.00154
M204 S6000
G1 X203.82 Y138.523 F60000
; LINE_WIDTH: 0.111925
G1 F3000
M204 S500
G2 X203.512 Y138.6 I1.326 J5.974 E.00173
; WIPE_START
G1 X203.82 Y138.523 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X206.684 Y138.514 Z.6 F60000
G1 Z.2
G1 E.8 F1800
; LINE_WIDTH: 0.263353
G1 F3000
M204 S500
G1 X207.75 Y138.833 E.01938
M204 S6000
G1 X207.75 Y138.864 F60000
; LINE_WIDTH: 0.480712
G1 F3000
M204 S500
G1 X206.721 Y138.5 E.03774
M204 S6000
G1 X207.371 Y138.5 F60000
; LINE_WIDTH: 0.411263
G1 F3000
M204 S500
G1 X207.747 Y139.403 E.02847
M204 S6000
G1 X207.733 Y139.407 F60000
; LINE_WIDTH: 0.176869
G1 F3000
M204 S500
G1 X207.403 Y138.5 E.01022
; WIPE_START
G1 X207.733 Y139.407 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X207.93 Y140.13 Z.6 F60000
G1 Z.2
G1 E.8 F1800
; LINE_WIDTH: 0.505934
G1 F3000
M204 S500
G1 X207.98 Y140.41 E.01038
; LINE_WIDTH: 0.475992
G1 X208.001 Y140.566 E.0054
; LINE_WIDTH: 0.437533
G1 X208.019 Y140.701 E.00424
; LINE_WIDTH: 0.395368
G3 X208.043 Y140.998 I-5.639 J.603 E.00831
; LINE_WIDTH: 0.362936
G3 X208.044 Y141.584 I-8.113 J.306 E.01481
; LINE_WIDTH: 0.392224
G3 X208.021 Y141.877 I-5.644 J-.287 E.00811
; LINE_WIDTH: 0.434013
G1 X208.002 Y142.028 E.00471
; LINE_WIDTH: 0.470899
G1 X207.985 Y142.16 E.0045
; LINE_WIDTH: 0.503945
G3 X207.929 Y142.471 I-6.612 J-1.015 E.01151
M204 S6000
G1 X207.75 Y143.228 F60000
; LINE_WIDTH: 0.123159
G1 F3000
M204 S500
G1 X207.55 Y143.417 E.00175
; CHANGE_LAYER
; Z_HEIGHT: 0.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F3000
G1 X207.75 Y143.228 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 2/54
; update layer progress
M73 L2
M991 S0 P1 ;notify layer change

; open powerlost recovery
M1003 S1
; OBJECT_ID: 15
M204 S10000
G17
G3 Z.6 I-.004 J-1.217 P1  F60000
G1 X154.024 Y143.389 Z.6
G1 Z.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X153.886 Y143.376 E.00446
G3 X154.026 Y139.202 I.363 J-2.078 E.19416
G1 X154.225 Y139.19 E.00639
G3 X154.29 Y143.407 I.024 J2.109 E.21249
G1 X154.084 Y143.393 E.00666
M204 S10000
G1 X154.055 Y142.985 F60000
G1 F8843.478
M204 S8000
G1 X153.956 Y142.975 E.00321
G3 X154.07 Y139.607 I.293 J-1.676 E.15667
G1 X154.229 Y139.597 E.00512
G3 X154.282 Y143 I.02 J1.702 E.17149
G1 X154.115 Y142.989 E.00538
M204 S250
G1 X154.085 Y142.595 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X154.023 Y142.589 E.00187
G3 X154.113 Y139.997 I.226 J-1.29 E.11167
G1 X154.233 Y139.99 E.00361
G3 X154.274 Y142.608 I.016 J1.309 E.12227
G1 X154.145 Y142.599 E.00384
; WIPE_START
M204 S8000
G1 X154.023 Y142.589 E-.04663
G1 X153.78 Y142.523 E-.09549
G1 X153.556 Y142.411 E-.09532
G1 X153.34 Y142.243 E-.10422
G1 X153.177 Y142.052 E-.09536
G1 X153.053 Y141.832 E-.09573
G1 X152.973 Y141.593 E-.09575
G1 X152.94 Y141.323 E-.10343
G1 X152.946 Y141.25 E-.02807
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X156.19 Y148.158 Z.8 F60000
G1 X169.695 Y176.918 Z.8
G1 Z.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X169.811 Y177.057 E.00583
G3 X167.483 Y175.996 I-2.063 J1.441 E.42209
G1 X167.72 Y175.982 E.00766
G3 X169.493 Y176.686 I.028 J2.516 E.06292
G1 X169.655 Y176.873 E.00795
M204 S10000
G1 X169.387 Y177.182 F60000
G1 F8843.478
M204 S8000
G1 X169.477 Y177.291 E.00455
G3 X167.526 Y176.401 I-1.729 J1.208 E.35378
G1 X167.725 Y176.39 E.00638
G3 X169.212 Y176.98 I.024 J2.109 E.05277
G1 X169.348 Y177.137 E.00667
M204 S10000
G1 X169.079 Y177.446 F60000
G1 F8843.478
M204 S8000
G1 X169.144 Y177.524 E.00327
G3 X167.57 Y176.807 I-1.395 J.975 E.28548
G1 X167.729 Y176.797 E.00511
G3 X168.93 Y177.274 I.02 J1.702 E.04263
G1 X169.04 Y177.401 E.00539
M204 S250
G1 X168.782 Y177.7 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X168.823 Y177.749 E.00189
G3 X167.613 Y177.197 I-1.073 J.75 E.2035
G1 X167.733 Y177.19 E.0036
G3 X168.659 Y177.557 I.016 J1.309 E.03043
G1 X168.743 Y177.655 E.00383
; WIPE_START
M204 S8000
G1 X168.823 Y177.749 E-.04691
G1 X168.956 Y177.988 E-.10414
G1 X169.031 Y178.227 E-.09517
G1 X169.06 Y178.476 E-.09507
G1 X169.04 Y178.727 E-.0958
G1 X168.971 Y178.975 E-.09795
G1 X168.849 Y179.213 E-.10136
G1 X168.692 Y179.41 E-.096
G1 X168.637 Y179.457 E-.02761
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X165.048 Y172.721 Z.8 F60000
G1 X154.143 Y152.248 Z.8
G1 Z.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
M73 P49 R8
G1 X154.478 Y152.103 E.01175
G3 X154.983 Y151.996 I.77 J2.396 E.0166
G1 X155.22 Y151.982 E.00766
G3 X154.035 Y152.294 I.028 J2.516 E.46859
G1 X154.088 Y152.272 E.00185
M204 S10000
G1 X154.303 Y152.621 F60000
G1 F8843.478
M204 S8000
G1 X154.603 Y152.491 E.01048
G3 X155.026 Y152.401 I.646 J2.008 E.01395
G1 X155.225 Y152.39 E.00638
G3 X154.231 Y152.652 I.024 J2.109 E.39272
G1 X154.248 Y152.644 E.00061
M204 S10000
G1 X154.464 Y152.993 F60000
G1 F8843.478
M204 S8000
G1 X154.727 Y152.879 E.0092
G3 X155.07 Y152.807 I.522 J1.62 E.01131
G1 X155.229 Y152.797 E.00511
G3 X154.41 Y153.019 I.02 J1.702 E.31624
M204 S250
G1 X154.619 Y153.352 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X154.846 Y153.253 E.00737
G3 X155.113 Y153.197 I.403 J1.246 E.00812
G1 X155.233 Y153.19 E.0036
G3 X154.567 Y153.381 I.016 J1.309 E.22417
; WIPE_START
M204 S8000
G1 X154.846 Y153.253 E-.11666
G1 X155.113 Y153.197 E-.10339
G1 X155.233 Y153.19 E-.04594
G1 X155.5 Y153.214 E-.10167
G1 X155.741 Y153.285 E-.09561
G1 X155.963 Y153.401 E-.09506
G1 X156.16 Y153.557 E-.09571
G1 X156.324 Y153.749 E-.09584
G1 X156.337 Y153.773 E-.01011
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X163.813 Y152.239 Z.8 F60000
G1 X204.981 Y143.793 Z.8
G1 Z.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X204.818 Y143.778 E.00526
G3 X204.983 Y138.796 I.431 J-2.479 E.23174
G1 X205.22 Y138.782 E.00765
G3 X205.297 Y143.814 I.028 J2.516 E.25353
G1 X205.041 Y143.797 E.00828
M204 S10000
G1 X205.012 Y143.388 F60000
G1 F8843.478
M204 S8000
G1 X204.887 Y143.377 E.00403
G3 X205.027 Y139.201 I.362 J-2.078 E.19422
G1 X205.225 Y139.19 E.00638
G3 X205.289 Y143.407 I.024 J2.109 E.21252
G1 X205.072 Y143.393 E.00702
M204 S10000
G1 X205.043 Y142.984 F60000
G1 F8843.478
M204 S8000
G1 X204.956 Y142.975 E.0028
G3 X205.07 Y139.607 I.293 J-1.676 E.1567
G1 X205.229 Y139.597 E.00511
G3 X205.281 Y143 I.02 J1.702 E.17152
G1 X205.103 Y142.988 E.00575
M204 S250
G1 X205.073 Y142.594 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X205.023 Y142.589 E.0015
G3 X205.113 Y139.997 I.226 J-1.29 E.11168
G1 X205.233 Y139.99 E.00361
G3 X205.274 Y142.608 I.016 J1.309 E.12229
G1 X205.133 Y142.599 E.00419
; WIPE_START
M204 S8000
G1 X205.023 Y142.589 E-.04195
G1 X204.781 Y142.523 E-.09551
G1 X204.556 Y142.411 E-.09542
G1 X204.34 Y142.242 E-.10422
G1 X204.176 Y142.05 E-.09591
G1 X204.044 Y141.812 E-.10337
G1 X203.969 Y141.573 E-.09534
G1 X203.94 Y141.323 E-.09574
G1 X203.947 Y141.238 E-.03254
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X196.376 Y142.205 Z.8 F60000
G1 X151.666 Y147.916 Z.8
G1 Z.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X151.666 Y142.143 E.18563
G1 X151.866 Y142.106 E.00653
G2 X151.87 Y140.488 I2.384 J-.803 E.45537
G1 X151.666 Y140.453 E.00665
G1 X151.666 Y137.916 E.08159
G1 X208.334 Y137.916 E1.82222
G1 X208.334 Y151.584 E.4395
G1 X170.834 Y151.584 E1.20586
G1 X170.834 Y182.084 E.98077
G1 X141.666 Y182.084 E.93792
G1 X141.666 Y147.916 E1.09871
G1 X151.606 Y147.916 E.31963
M204 S10000
G1 X151.259 Y147.509 F60000
G1 F8843.478
M204 S8000
G1 X151.259 Y137.509 E.32156
G1 X208.741 Y137.509 E1.8484
G1 X208.741 Y151.991 E.46568
G1 X171.241 Y151.991 E1.20586
G1 X171.241 Y182.491 E.98077
G1 X141.259 Y182.491 E.9641
G1 X141.259 Y147.509 E1.12489
G1 X151.199 Y147.509 E.31963
M204 S10000
G1 X150.852 Y147.102 F60000
G1 F8843.478
M204 S8000
G1 X150.852 Y137.102 E.32156
G1 X209.148 Y137.102 E1.87458
G1 X209.148 Y152.398 E.49186
G1 X171.648 Y152.398 E1.20586
G1 X171.648 Y182.898 E.98077
G1 X140.852 Y182.898 E.99028
G1 X140.852 Y147.102 E1.15107
G1 X150.792 Y147.102 E.31963
M204 S250
G1 X150.46 Y146.71 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X150.46 Y136.71 E.29787
G1 X209.54 Y136.71 E1.75979
G1 X209.54 Y152.79 E.47897
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X172.04 Y152.79 E1.117
G1 X172.04 Y183.29 E.90849
G1 X140.46 Y183.29 E.94066
G1 X140.46 Y146.71 E1.08959
G1 X150.4 Y146.71 E.29608
; WIPE_START
M204 S8000
G1 X150.412 Y144.71 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X151.83 Y147.433 Z.8 F60000
G1 Z.4
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42234
G1 F9488.165
M204 S8000
G1 X155.341 Y143.921 E.14885
G3 X154.61 Y144.117 I-.911 J-1.944 E.02282
G1 X151.999 Y146.727 E.11064
G1 X151.999 Y146.19 E.01608
G1 X154.046 Y144.144 E.08676
G1 X153.586 Y144.067 E.01397
G1 X151.999 Y145.654 E.06727
G1 X151.999 Y145.117 E.01608
G1 X153.184 Y143.932 E.05022
G3 X152.818 Y143.762 I.401 J-1.343 E.01215
G1 X151.999 Y144.581 E.03469
G1 X151.999 Y144.044 E.01608
G1 X152.495 Y143.548 E.02102
G3 X152.236 Y143.316 I.968 J-1.341 E.01043
G1 X152.038 Y143.502 E.00815
G1 X152.022 Y143.485 E.00071
G1 X151.83 Y143.677 E.00814
M204 S10000
G1 X152.092 Y142.994 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.109465
G1 F15000
M204 S8000
G1 X151.988 Y142.882 E.0008
; LINE_WIDTH: 0.136352
G1 X151.87 Y142.746 E.00133
M204 S10000
G1 X151.736 Y141.923 F60000
; LINE_WIDTH: 0.531885
G1 F7362.5
M204 S8000
G3 X151.732 Y140.671 I5.614 J-.642 E.04847
M204 S10000
G1 X151.87 Y139.877 F60000
; LINE_WIDTH: 0.1164
G1 F15000
M204 S8000
G1 X152.035 Y139.682 E.00148
; WIPE_START
G1 X151.87 Y139.877 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X153.064 Y138.588 Z.8 F60000
G1 Z.4
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.56565
G1 F6886.921
M204 S8000
G1 X153.047 Y138.381 E.00856
G1 X152.131 Y138.381 E.03783
G1 X152.131 Y139.159 E.03211
G1 X152.184 Y139.158 E.0022
G1 X152.613 Y138.809 E.02283
G1 X153.01 Y138.614 E.01825
M204 S10000
G1 X153.514 Y138.39 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.521741
G1 F7518.472
M204 S8000
G3 X154.988 Y138.388 I.748 J6.761 E.05586
M204 S10000
G1 X155.125 Y138.772 F60000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42234
G1 F9488.165
M204 S8000
G1 X155.648 Y138.249 E.02214
M73 P49 R7
G1 X156.184 Y138.249 E.01608
G1 X155.621 Y138.812 E.02387
G3 X155.948 Y139.023 I-.38 J.948 E.01171
G1 X156.721 Y138.249 E.03278
G1 X157.257 Y138.249 E.01608
G1 X156.244 Y139.263 E.04295
G3 X156.493 Y139.551 I-.845 J.98 E.01144
G1 X157.794 Y138.249 E.05516
G1 X158.331 Y138.249 E.01608
G1 X156.712 Y139.868 E.06863
G3 X156.889 Y140.228 I-2.493 J1.453 E.01202
G1 X158.867 Y138.249 E.08386
G1 X159.404 Y138.249 E.01608
M73 P50 R7
G1 X157.018 Y140.635 E.10112
G1 X157.086 Y141.104 E.0142
G1 X159.94 Y138.249 E.121
G1 X160.477 Y138.249 E.01608
G1 X157.07 Y141.656 E.14439
G1 X157.06 Y141.791 E.00407
G1 X156.889 Y142.373 E.01818
G1 X161.014 Y138.249 E.1748
G1 X161.55 Y138.249 E.01608
G1 X151.83 Y147.97 E.41201
; WIPE_START
G1 X153.244 Y146.556 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X145.761 Y148.058 Z.8 F60000
G1 X141.83 Y148.848 Z.8
G1 Z.4
G1 E.8 F1800
G1 F9488.165
M204 S8000
G1 X142.428 Y148.249 E.02537
G1 X142.965 Y148.249 E.01608
G1 X141.999 Y149.215 E.04092
G1 X141.999 Y149.751 E.01608
G1 X143.501 Y148.249 E.06367
G1 X144.038 Y148.249 E.01608
G1 X141.999 Y150.288 E.08641
G1 X141.999 Y150.825 E.01608
G1 X144.575 Y148.249 E.10915
G1 X145.111 Y148.249 E.01608
G1 X141.999 Y151.361 E.1319
G1 X141.999 Y151.898 E.01608
G1 X145.648 Y148.249 E.15464
G1 X146.184 Y148.249 E.01608
G1 X141.999 Y152.434 E.17738
G1 X141.999 Y152.971 E.01608
G1 X146.721 Y148.249 E.20013
G1 X147.257 Y148.249 E.01608
G1 X141.999 Y153.507 E.22287
G1 X141.999 Y154.044 E.01608
G1 X147.794 Y148.249 E.24561
G1 X148.331 Y148.249 E.01608
G1 X141.999 Y154.581 E.26836
G1 X141.999 Y155.117 E.01608
G1 X148.867 Y148.249 E.2911
G1 X149.404 Y148.249 E.01608
G1 X141.999 Y155.654 E.31384
G1 X141.999 Y156.19 E.01608
G1 X149.94 Y148.249 E.33659
G1 X150.477 Y148.249 E.01608
G1 X141.999 Y156.727 E.35933
G1 X141.999 Y157.264 E.01608
G1 X151.014 Y148.249 E.38208
G1 X151.55 Y148.249 E.01608
G1 X141.999 Y157.8 E.40482
G1 X141.999 Y158.337 E.01608
G1 X162.087 Y138.249 E.85142
G1 X162.623 Y138.249 E.01608
G1 X141.999 Y158.873 E.87417
G1 X141.999 Y159.41 E.01608
G1 X163.16 Y138.249 E.89691
G1 X163.696 Y138.249 E.01608
G1 X141.999 Y159.946 E.91965
G1 X141.999 Y160.483 E.01608
G1 X164.233 Y138.249 E.9424
G1 X164.77 Y138.249 E.01608
G1 X141.999 Y161.02 E.96514
G1 X141.999 Y161.556 E.01608
G1 X165.306 Y138.249 E.98788
G1 X165.843 Y138.249 E.01608
G1 X141.999 Y162.093 E1.01063
G1 X141.999 Y162.629 E.01608
G1 X166.379 Y138.249 E1.03337
G1 X166.916 Y138.249 E.01608
G1 X141.83 Y163.336 E1.06331
; WIPE_START
G1 X143.244 Y161.921 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X142.116 Y169.47 Z.8 F60000
G1 X141.83 Y171.384 Z.8
G1 Z.4
G1 E.8 F1800
G1 F9488.165
M204 S8000
G1 X155.964 Y157.25 E.59908
G3 X155.328 Y157.349 I-.655 J-2.119 E.01935
G1 X141.999 Y170.678 E.56495
G1 X141.999 Y170.141 E.01608
G1 X154.824 Y157.317 E.54358
G3 X154.389 Y157.215 I.504 J-3.144 E.0134
G1 X141.999 Y169.605 E.52514
G1 X141.999 Y169.068 E.01608
G1 X154.005 Y157.063 E.50888
G3 X153.671 Y156.861 I.544 J-1.279 E.01175
G1 X141.999 Y168.532 E.49469
G1 X141.999 Y167.995 E.01608
G1 X153.362 Y156.632 E.48162
G3 X153.094 Y156.364 I1.145 J-1.411 E.01139
G1 X141.999 Y167.459 E.47026
G1 X141.999 Y166.922 E.01608
G1 X152.871 Y156.051 E.46079
G3 X152.678 Y155.706 I.77 J-.656 E.0119
G1 X141.999 Y166.385 E.45264
G1 X141.999 Y165.849 E.01608
G1 X152.524 Y155.324 E.44609
G1 X152.427 Y154.884 E.01351
G1 X141.999 Y165.312 E.442
G1 X141.999 Y164.776 E.01608
G1 X152.407 Y154.368 E.44112
G3 X152.504 Y153.734 I1.93 J-.028 E.01931
G1 X141.999 Y164.239 E.44525
G1 X141.999 Y163.703 E.01608
G1 X167.453 Y138.249 E1.07886
G1 X167.989 Y138.249 E.01608
G1 X154.481 Y151.758 E.57257
G3 X155.113 Y151.662 I.675 J2.317 E.01923
G1 X168.526 Y138.249 E.5685
G1 X169.062 Y138.249 E.01608
G1 X155.634 Y151.678 E.56919
G3 X156.077 Y151.771 I-.222 J2.162 E.01361
G1 X169.599 Y138.249 E.57314
G1 X170.135 Y138.249 E.01608
G1 X156.459 Y151.925 E.57967
G3 X156.801 Y152.121 I-.35 J1.007 E.01185
G1 X170.672 Y138.249 E.58796
G1 X171.209 Y138.249 E.01608
G1 X157.112 Y152.346 E.59748
G3 X157.383 Y152.612 I-1.134 J1.424 E.01139
G1 X171.745 Y138.249 E.60876
G1 X172.282 Y138.249 E.01608
G1 X157.61 Y152.921 E.62188
G3 X157.812 Y153.256 I-1.004 J.833 E.01176
G1 X172.818 Y138.249 E.63607
G1 X173.355 Y138.249 E.01608
G1 X157.968 Y153.637 E.65221
G1 X158.064 Y154.077 E.0135
G1 X173.891 Y138.249 E.67086
G1 X174.428 Y138.249 E.01608
G1 X158.092 Y154.585 E.69241
G3 X158.01 Y155.204 I-2.51 J-.018 E.01875
G1 X174.965 Y138.249 E.71863
G1 X175.501 Y138.249 E.01608
G1 X141.999 Y171.751 E1.42001
G1 X141.999 Y172.288 E.01608
G1 X176.038 Y138.249 E1.44276
G1 X176.574 Y138.249 E.01608
G1 X141.999 Y172.824 E1.4655
G1 X141.999 Y173.361 E.01608
G1 X177.111 Y138.249 E1.48824
G1 X177.648 Y138.249 E.01608
M73 P51 R7
G1 X141.999 Y173.898 E1.51099
G1 X141.999 Y174.434 E.01608
G1 X178.184 Y138.249 E1.53373
G1 X178.721 Y138.249 E.01608
G1 X141.999 Y174.971 E1.55647
G1 X141.999 Y175.507 E.01608
G1 X179.257 Y138.249 E1.57922
G1 X179.794 Y138.249 E.01608
G1 X141.999 Y176.044 E1.60196
G1 X141.999 Y176.58 E.01608
G1 X180.33 Y138.249 E1.6247
G1 X180.867 Y138.249 E.01608
G1 X141.999 Y177.117 E1.64745
G1 X141.999 Y177.654 E.01608
G1 X181.404 Y138.249 E1.67019
G1 X181.94 Y138.249 E.01608
G1 X141.999 Y178.19 E1.69293
G1 X141.999 Y178.727 E.01608
G1 X182.477 Y138.249 E1.71568
G1 X183.013 Y138.249 E.01608
G1 X141.83 Y179.433 E1.74561
; WIPE_START
G1 X143.244 Y178.019 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X150.796 Y179.123 Z.8 F60000
G1 X169.928 Y181.92 Z.8
G1 Z.4
G1 E.8 F1800
G1 F9488.165
M204 S8000
G1 X170.501 Y181.347 E.02429
G1 X170.501 Y180.811 E.01608
G1 X169.561 Y181.751 E.03984
G1 X169.024 Y181.751 E.01608
G1 X170.501 Y180.274 E.06259
G1 X170.501 Y180.207 E.00201
G1 X170.106 Y180.133 E.01205
G1 X168.487 Y181.751 E.06859
G1 X167.951 Y181.751 E.01608
G1 X168.448 Y181.254 E.02105
G3 X167.815 Y181.35 I-.645 J-2.11 E.01926
G1 X167.414 Y181.751 E.01697
G1 X166.878 Y181.751 E.01608
G1 X167.313 Y181.315 E.01845
G3 X166.88 Y181.212 I.528 J-3.178 E.01336
G1 X166.341 Y181.751 E.02282
G1 X165.805 Y181.751 E.01608
G1 X166.497 Y181.059 E.02933
G3 X166.163 Y180.856 I.546 J-1.274 E.01174
G1 X165.268 Y181.751 E.03793
G1 X164.731 Y181.751 E.01608
G1 X165.855 Y180.627 E.04765
G3 X165.588 Y180.357 I1.147 J-1.407 E.01139
G1 X164.195 Y181.751 E.05906
G1 X163.658 Y181.751 E.01608
G1 X165.365 Y180.043 E.07236
G3 X165.169 Y179.704 I1.024 J-.82 E.01181
G1 X163.122 Y181.751 E.08676
G1 X162.585 Y181.751 E.01608
G1 X165.021 Y179.315 E.10325
G1 X164.925 Y178.874 E.01352
G1 X162.048 Y181.751 E.12193
G1 X161.512 Y181.751 E.01608
G1 X164.906 Y178.356 E.14388
G3 X165.008 Y177.718 I2.984 J.147 E.0194
G1 X160.975 Y181.751 E.17092
G1 X160.439 Y181.751 E.01608
G1 X170.501 Y171.689 E.42648
G1 X170.501 Y171.152 E.01608
G1 X159.902 Y181.751 E.44923
G1 X159.366 Y181.751 E.01608
G1 X170.501 Y170.616 E.47197
G1 X170.501 Y170.079 E.01608
G1 X158.829 Y181.751 E.49472
G1 X158.292 Y181.751 E.01608
G1 X170.501 Y169.542 E.51746
G1 X170.501 Y169.006 E.01608
G1 X157.756 Y181.751 E.5402
G1 X157.219 Y181.751 E.01608
G1 X170.501 Y168.469 E.56295
G1 X170.501 Y167.933 E.01608
G1 X156.683 Y181.751 E.58569
G1 X156.146 Y181.751 E.01608
G1 X170.501 Y167.396 E.60843
G1 X170.501 Y166.86 E.01608
G1 X155.609 Y181.751 E.63118
G1 X155.073 Y181.751 E.01608
G1 X170.501 Y166.323 E.65392
G1 X170.501 Y165.786 E.01608
G1 X154.536 Y181.751 E.67666
G1 X154 Y181.751 E.01608
G1 X170.501 Y165.25 E.69941
G1 X170.501 Y164.713 E.01608
G1 X153.463 Y181.751 E.72215
G1 X152.927 Y181.751 E.01608
G1 X170.501 Y164.177 E.74489
G1 X170.501 Y163.64 E.01608
G1 X152.39 Y181.751 E.76764
G1 X151.853 Y181.751 E.01608
G1 X170.501 Y163.103 E.79038
G1 X170.501 Y162.567 E.01608
G1 X151.317 Y181.751 E.81312
G1 X150.78 Y181.751 E.01608
G1 X170.501 Y162.03 E.83587
G1 X170.501 Y161.494 E.01608
G1 X150.244 Y181.751 E.85861
G1 X149.707 Y181.751 E.01608
G1 X170.501 Y160.957 E.88136
G1 X170.501 Y160.421 E.01608
G1 X149.171 Y181.751 E.9041
G1 X148.634 Y181.751 E.01608
G1 X170.501 Y159.884 E.92684
G1 X170.501 Y159.347 E.01608
G1 X148.097 Y181.751 E.94959
M73 P52 R7
G1 X147.561 Y181.751 E.01608
G1 X170.501 Y158.811 E.97233
G1 X170.501 Y158.274 E.01608
G1 X147.024 Y181.751 E.99507
G1 X146.488 Y181.751 E.01608
G1 X170.501 Y157.738 E1.01782
G1 X170.501 Y157.201 E.01608
G1 X145.951 Y181.751 E1.04056
G1 X145.414 Y181.751 E.01608
G1 X170.501 Y156.664 E1.0633
G1 X170.501 Y156.128 E.01608
G1 X144.878 Y181.751 E1.08605
G1 X144.341 Y181.751 E.01608
G1 X170.501 Y155.591 E1.10879
G1 X170.501 Y155.055 E.01608
G1 X143.805 Y181.751 E1.13153
G1 X143.268 Y181.751 E.01608
G1 X170.501 Y154.518 E1.15428
G1 X170.501 Y153.982 E.01608
G1 X142.732 Y181.751 E1.17702
G1 X142.195 Y181.751 E.01608
G1 X170.501 Y153.445 E1.19976
G1 X170.501 Y152.908 E.01608
G1 X141.999 Y181.41 E1.20806
G1 X141.999 Y180.873 E.01608
G1 X170.501 Y152.372 E1.20806
G1 X170.501 Y151.835 E.01608
G1 X141.999 Y180.337 E1.20806
G1 X141.999 Y179.8 E.01608
G1 X183.55 Y138.249 E1.76116
G1 X184.087 Y138.249 E.01608
G1 X171.085 Y151.251 E.55107
G1 X171.622 Y151.251 E.01608
G1 X184.623 Y138.249 E.55107
G1 X185.16 Y138.249 E.01608
G1 X172.158 Y151.251 E.55107
G1 X172.695 Y151.251 E.01608
G1 X185.696 Y138.249 E.55107
G1 X186.233 Y138.249 E.01608
G1 X173.232 Y151.251 E.55107
G1 X173.768 Y151.251 E.01608
G1 X186.769 Y138.249 E.55107
G1 X187.306 Y138.249 E.01608
G1 X174.305 Y151.251 E.55107
G1 X174.841 Y151.251 E.01608
G1 X187.843 Y138.249 E.55107
G1 X188.379 Y138.249 E.01608
G1 X175.378 Y151.251 E.55107
G1 X175.914 Y151.251 E.01608
G1 X188.916 Y138.249 E.55107
G1 X189.452 Y138.249 E.01608
G1 X176.451 Y151.251 E.55107
G1 X176.988 Y151.251 E.01608
G1 X189.989 Y138.249 E.55107
G1 X190.525 Y138.249 E.01608
G1 X177.524 Y151.251 E.55107
G1 X178.061 Y151.251 E.01608
G1 X191.062 Y138.249 E.55107
G1 X191.599 Y138.249 E.01608
G1 X178.597 Y151.251 E.55107
G1 X179.134 Y151.251 E.01608
G1 X192.135 Y138.249 E.55107
G1 X192.672 Y138.249 E.01608
G1 X179.671 Y151.251 E.55107
G1 X180.207 Y151.251 E.01608
G1 X193.208 Y138.249 E.55107
G1 X193.745 Y138.249 E.01608
G1 X180.744 Y151.251 E.55107
G1 X181.28 Y151.251 E.01608
G1 X194.282 Y138.249 E.55107
G1 X194.818 Y138.249 E.01608
G1 X181.817 Y151.251 E.55107
G1 X182.353 Y151.251 E.01608
G1 X195.355 Y138.249 E.55107
G1 X195.891 Y138.249 E.01608
G1 X182.89 Y151.251 E.55107
G1 X183.427 Y151.251 E.01608
G1 X196.428 Y138.249 E.55107
G1 X196.964 Y138.249 E.01608
G1 X183.963 Y151.251 E.55107
G1 X184.5 Y151.251 E.01608
G1 X197.501 Y138.249 E.55107
G1 X198.038 Y138.249 E.01608
G1 X185.036 Y151.251 E.55107
G1 X185.573 Y151.251 E.01608
G1 X198.574 Y138.249 E.55107
G1 X199.111 Y138.249 E.01608
G1 X186.11 Y151.251 E.55107
G1 X186.646 Y151.251 E.01608
G1 X199.647 Y138.249 E.55107
G1 X200.184 Y138.249 E.01608
G1 X187.183 Y151.251 E.55107
G1 X187.719 Y151.251 E.01608
G1 X200.721 Y138.249 E.55107
G1 X201.257 Y138.249 E.01608
G1 X188.256 Y151.251 E.55107
G1 X188.792 Y151.251 E.01608
G1 X201.794 Y138.249 E.55107
G1 X202.33 Y138.249 E.01608
G1 X189.329 Y151.251 E.55107
G1 X189.866 Y151.251 E.01608
M73 P53 R7
G1 X202.867 Y138.249 E.55107
G1 X203.403 Y138.249 E.01608
G1 X190.402 Y151.251 E.55107
G1 X190.939 Y151.251 E.01608
G1 X203.94 Y138.249 E.55107
G1 X204.169 Y138.249 E.00686
G1 X204.192 Y138.534 E.00857
G1 X191.475 Y151.251 E.53899
G1 X192.012 Y151.251 E.01608
G1 X202.453 Y140.809 E.44257
G2 X202.402 Y141.397 I2.492 J.513 E.01772
G1 X192.548 Y151.251 E.41765
G1 X193.085 Y151.251 E.01608
G1 X202.468 Y141.868 E.3977
G2 X202.58 Y142.292 I1.533 J-.179 E.0132
G1 X193.622 Y151.251 E.37972
G1 X194.158 Y151.251 E.01608
G1 X202.746 Y142.663 E.36401
G1 X202.962 Y142.983 E.01159
G1 X194.695 Y151.251 E.35041
G1 X195.231 Y151.251 E.01608
G1 X203.202 Y143.28 E.33785
G2 X203.482 Y143.537 I1.363 J-1.204 E.0114
G1 X195.768 Y151.251 E.32697
G1 X196.305 Y151.251 E.01608
G1 X203.802 Y143.753 E.31778
G2 X204.16 Y143.932 I1.115 J-1.786 E.01201
G1 X196.841 Y151.251 E.31021
G1 X197.378 Y151.251 E.01608
G1 X204.565 Y144.064 E.30463
G1 X205.023 Y144.142 E.01393
G1 X197.914 Y151.251 E.3013
G1 X198.451 Y151.251 E.01608
G1 X205.568 Y144.133 E.30167
G2 X206.297 Y143.941 I-.114 J-1.909 E.02276
G1 X198.987 Y151.251 E.30984
G1 X199.524 Y151.251 E.01608
G1 X207.804 Y142.97 E.35098
G1 X208.001 Y143.008 E.00599
G1 X208.001 Y143.311 E.00906
G1 X200.061 Y151.251 E.33655
G1 X200.597 Y151.251 E.01608
G1 X208.001 Y143.847 E.3138
G1 X208.001 Y144.384 E.01608
G1 X201.134 Y151.251 E.29106
G1 X201.67 Y151.251 E.01608
G1 X208.001 Y144.92 E.26832
G1 X208.001 Y145.457 E.01608
G1 X202.207 Y151.251 E.24557
G1 X202.744 Y151.251 E.01608
G1 X208.001 Y145.994 E.22283
G1 X208.001 Y146.53 E.01608
G1 X203.28 Y151.251 E.20008
G1 X203.817 Y151.251 E.01608
G1 X208.001 Y147.067 E.17734
G1 X208.001 Y147.603 E.01608
G1 X204.353 Y151.251 E.1546
G1 X204.89 Y151.251 E.01608
G1 X208.001 Y148.14 E.13185
G1 X208.001 Y148.676 E.01608
G1 X205.426 Y151.251 E.10911
G1 X205.963 Y151.251 E.01608
G1 X208.001 Y149.213 E.08637
G1 X208.001 Y149.75 E.01608
G1 X206.5 Y151.251 E.06362
G1 X207.036 Y151.251 E.01608
G1 X208.001 Y150.286 E.04088
G1 X208.001 Y150.823 E.01608
G1 X207.403 Y151.42 E.02533
; WIPE_START
G1 X208.001 Y150.823 E-.32113
G1 X208.001 Y150.286 E-.2039
G1 X207.563 Y150.723 E-.23497
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X207.876 Y143.097 Z.8 F60000
G1 X207.895 Y142.648 Z.8
G1 Z.4
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.413198
G1 F9722.447
M204 S8000
G1 X207.947 Y142.379 E.00801
; LINE_WIDTH: 0.385605
G1 F10505.27
G1 X207.971 Y142.237 E.00391
; LINE_WIDTH: 0.337962
G1 F12201.665
G1 X207.995 Y142.095 E.00336
; LINE_WIDTH: 0.312178
G1 F13370.092
G1 X207.997 Y142.081 E.0003
; LINE_WIDTH: 0.294368
G1 F14317.096
G1 X208.012 Y141.942 E.00277
; LINE_WIDTH: 0.261644
G1 F15000
G1 X208.029 Y141.794 E.00258
; LINE_WIDTH: 0.215052
G1 X208.051 Y141.254 E.00734
G1 X208.041 Y140.961 E.004
; LINE_WIDTH: 0.244021
G1 X208.019 Y140.698 E.00418
; LINE_WIDTH: 0.284154
G1 F14923.283
G1 X208.001 Y140.563 E.0026
; LINE_WIDTH: 0.321711
G1 F12912.894
G1 X207.981 Y140.413 E.00332
; LINE_WIDTH: 0.364832
G1 F11183.206
G1 X207.958 Y140.288 E.00325
; LINE_WIDTH: 0.424736
G1 F9428.647
G1 X207.933 Y140.151 E.00419
G1 X207.657 Y140.025 E.00915
; WIPE_START
G1 X207.933 Y140.151 E-.52135
G1 X207.958 Y140.288 E-.23865
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X206.365 Y138.623 Z.8 F60000
G1 Z.4
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F9547.299
M204 S8000
G1 X206.602 Y138.723 E.00766
G3 X207.486 Y139.474 I-1.219 J2.332 E.03485
G1 X207.624 Y139.374 E.00505
G1 X207.942 Y139.49 E.01008
G1 X207.942 Y138.308 E.0352
G1 X206.387 Y138.308 E.04631
G1 X206.369 Y138.564 E.00762
; WIPE_START
G1 X206.387 Y138.308 E-.09724
G1 X207.942 Y138.308 E-.59083
G1 X207.942 Y138.498 E-.07193
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X207.513 Y138.712 Z.8 F60000
G1 Z.4
G1 E.8 F1800
; LINE_WIDTH: 0.59256
G1 F6549.742
M204 S8000
G2 X207.517 Y138.824 I-.03 J.057 E.01173
; WIPE_START
G1 X207.444 Y138.831 E-.19965
G1 X207.41 Y138.772 E-.18679
G1 X207.444 Y138.712 E-.18679
G1 X207.513 Y138.712 E-.18678
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X205.988 Y138.388 Z.8 F60000
G1 Z.4
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.521735
G1 F7518.569
M204 S8000
G2 X204.514 Y138.39 I-.726 J6.761 E.05586
; WIPE_START
G1 X205.227 Y138.349 E-.36733
G1 X205.988 Y138.388 E-.39267
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X200.464 Y143.654 Z.8 F60000
G1 X170.67 Y172.056 Z.8
G1 Z.4
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42234
G1 F9488.165
M204 S8000
G1 X166.964 Y175.762 E.15711
G3 X167.601 Y175.662 I.696 J2.344 E.01938
G1 X170.501 Y172.762 E.12292
G1 X170.501 Y173.298 E.01608
G1 X168.123 Y175.677 E.1008
G3 X168.567 Y175.769 I-.217 J2.166 E.01363
G1 X170.501 Y173.835 E.08196
G1 X170.501 Y174.372 E.01608
G1 X168.951 Y175.922 E.0657
G3 X169.293 Y176.116 I-.346 J1.009 E.01187
G1 X170.501 Y174.908 E.05119
G1 X170.501 Y175.445 E.01608
G1 X169.602 Y176.343 E.03807
G1 X169.877 Y176.605 E.01138
G1 X170.501 Y175.981 E.02643
G1 X170.501 Y176.518 E.01608
G1 X170.195 Y176.823 E.01293
M204 S10000
G1 X170.157 Y177.225 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.4364
G1 F9149.147
M204 S8000
G1 X170.433 Y177.351 E.00943
G1 X170.437 Y177.371 E.00063
; LINE_WIDTH: 0.404545
G1 F9955.065
G1 X170.462 Y177.51 E.00402
; LINE_WIDTH: 0.355715
G1 F11509.138
G1 X170.486 Y177.648 E.00348
; LINE_WIDTH: 0.313404
G1 F13309.493
G1 X170.504 Y177.784 E.00292
; LINE_WIDTH: 0.280581
G1 F15000
G1 X170.519 Y177.906 E.00231
; LINE_WIDTH: 0.243517
G1 X170.541 Y178.16 E.00404
; LINE_WIDTH: 0.214722
G1 X170.551 Y178.447 E.0039
G1 X170.53 Y178.984 E.0073
; LINE_WIDTH: 0.25982
G1 X170.513 Y179.135 E.0026
; LINE_WIDTH: 0.292952
G1 F14398.179
G1 X170.497 Y179.275 E.00279
; LINE_WIDTH: 0.331635
G1 F12469.049
G1 X170.474 Y179.418 E.00328
; LINE_WIDTH: 0.376092
G1 F10805.24
G1 X170.453 Y179.546 E.00344
; LINE_WIDTH: 0.400487
G1 F10068.065
G1 X170.396 Y179.848 E.00868
; CHANGE_LAYER
; Z_HEIGHT: 0.6
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F10068.065
G1 X170.453 Y179.546 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 3/54
; update layer progress
M73 L3
M991 S0 P2 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z.8 I1.107 J-.505 P1  F60000
G1 X153.943 Y143.379 Z.8
G1 Z.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X153.635 Y143.317 E.01011
G3 X154.028 Y139.201 I.613 J-2.018 E.186
G1 X154.239 Y139.19 E.00677
G3 X154.061 Y143.4 I.009 J2.109 E.21933
G1 X154.002 Y143.389 E.00194
; COOLING_NODE: 0
M204 S10000
G1 X154.02 Y142.981 F60000
G1 F8843.478
M204 S8000
G1 X153.753 Y142.927 E.00876
G3 X154.071 Y139.607 I.495 J-1.628 E.15005
G1 X154.241 Y139.597 E.00547
G3 X154.099 Y142.994 I.007 J1.702 E.17695
G1 X154.08 Y142.991 E.00062
; COOLING_NODE: 0
M204 S250
G1 X154.095 Y142.597 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X153.868 Y142.552 E.00691
G3 X154.113 Y139.997 I.382 J-1.252 E.10692
G1 X154.244 Y139.99 E.00391
G3 X154.155 Y142.605 I.005 J1.309 E.12551
; COOLING_NODE: 0
; WIPE_START
M204 S8000
G1 X153.868 Y142.552 E-.11094
G1 X153.635 Y142.457 E-.09554
G1 X153.425 Y142.318 E-.09579
G1 X153.231 Y142.124 E-.10384
G1 X153.083 Y141.896 E-.10352
G1 X152.991 Y141.662 E-.0954
G1 X152.945 Y141.42 E-.09358
G1 X152.945 Y141.259 E-.06139
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X156.195 Y148.165 Z1 F60000
G1 X169.769 Y177.012 Z1
G1 Z.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X169.952 Y177.286 E.0106
G3 X167.485 Y175.996 I-2.205 J1.213 E.41357
G1 X167.736 Y175.982 E.00806
G3 X169.681 Y176.888 I.011 J2.516 E.07127
G1 X169.734 Y176.963 E.00295
; COOLING_NODE: 0
M204 S10000
G1 X169.434 Y177.241 F60000
G1 F8843.478
M204 S8000
G1 X169.595 Y177.482 E.00933
G3 X167.528 Y176.401 I-1.847 J1.017 E.34665
G1 X167.738 Y176.39 E.00677
G3 X169.368 Y177.149 I.009 J2.109 E.05971
G1 X169.399 Y177.192 E.00171
; COOLING_NODE: 0
M204 S10000
G1 X169.099 Y177.47 F60000
G1 F8843.478
M204 S8000
G1 X169.239 Y177.677 E.00805
G3 X167.571 Y176.807 I-1.49 J.822 E.27973
G1 X167.741 Y176.797 E.00547
G3 X169.055 Y177.409 I.007 J1.702 E.04814
G1 X169.064 Y177.421 E.00048
; COOLING_NODE: 1
M204 S250
G1 X168.776 Y177.691 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X168.895 Y177.866 E.00631
G3 X167.613 Y177.197 I-1.146 J.633 E.19941
G1 X167.744 Y177.19 E.0039
G3 X168.74 Y177.643 I.005 J1.309 E.03363
; COOLING_NODE: 1
; WIPE_START
M204 S8000
G1 X168.895 Y177.866 E-.10321
G1 X169.003 Y178.117 E-.10371
G1 X169.055 Y178.38 E-.1019
G1 X169.053 Y178.636 E-.09753
G1 X169.003 Y178.884 E-.09593
G1 X168.896 Y179.134 E-.10348
G1 X168.754 Y179.342 E-.09554
G1 X168.644 Y179.45 E-.05869
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X165.008 Y172.739 Z1 F60000
G1 X153.96 Y152.347 Z1
G1 Z.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X154.055 Y152.282 E.00371
G3 X154.985 Y151.996 I1.192 J2.216 E.0315
G1 X155.236 Y151.982 E.00806
G3 X153.66 Y152.546 I.011 J2.516 E.45354
G1 X153.91 Y152.381 E.00964
; COOLING_NODE: 1
M204 S10000
G1 X154.185 Y152.685 F60000
G1 F8843.478
M204 S8000
G1 X154.249 Y152.641 E.00248
G3 X155.028 Y152.401 I.999 J1.858 E.02639
G1 X155.238 Y152.39 E.00677
G3 X153.918 Y152.862 I.009 J2.109 E.38014
G1 X154.135 Y152.718 E.00839
; COOLING_NODE: 1
M204 S10000
G1 X154.411 Y153.022 F60000
G1 F8843.478
M204 S8000
G1 X154.443 Y153 E.00126
G3 X155.071 Y152.807 I.806 J1.499 E.02129
G1 X155.241 Y152.797 E.00547
G3 X154.176 Y153.178 I.007 J1.702 E.30674
G1 X154.361 Y153.055 E.00712
; COOLING_NODE: 2
M204 S250
G1 X154.627 Y153.348 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X154.629 Y153.346 E.00008
G3 X155.113 Y153.197 I.62 J1.153 E.01516
G1 X155.244 Y153.19 E.0039
G3 X154.425 Y153.482 I.005 J1.309 E.21865
G1 X154.577 Y153.381 E.00546
; COOLING_NODE: 2
; WIPE_START
M204 S8000
G1 X154.629 Y153.346 E-.0238
G1 X154.866 Y153.247 E-.09745
G1 X155.113 Y153.197 E-.09569
G1 X155.244 Y153.19 E-.04981
G1 X155.499 Y153.214 E-.09741
G1 X155.741 Y153.285 E-.09603
G1 X155.982 Y153.413 E-.10372
G1 X156.092 Y153.496 E-.052
G1 X156.254 Y153.659 E-.08748
G1 X156.339 Y153.781 E-.05661
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X163.814 Y152.239 Z1 F60000
G1 X204.842 Y143.775 Z1
G1 Z.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X204.51 Y143.705 E.01092
G3 X204.985 Y138.796 I.737 J-2.406 E.22176
G1 X205.236 Y138.782 E.00807
G3 X204.989 Y143.802 I.011 J2.517 E.26286
G1 X204.901 Y143.786 E.00288
; COOLING_NODE: 2
M204 S10000
G1 X204.924 Y143.377 F60000
G1 F8843.478
M204 S8000
G1 X204.63 Y143.316 E.00963
G3 X205.028 Y139.201 I.617 J-2.017 E.18588
G1 X205.239 Y139.19 E.00677
G3 X205.031 Y143.397 I.009 J2.109 E.22033
G1 X204.983 Y143.388 E.00159
; COOLING_NODE: 2
M204 S10000
G1 X205.005 Y142.98 F60000
G1 F8843.478
M204 S8000
G1 X204.751 Y142.927 E.00835
G3 X205.071 Y139.607 I.498 J-1.627 E.14999
G1 X205.241 Y139.597 E.00547
G3 X205.073 Y142.992 I.007 J1.702 E.17779
G1 X205.064 Y142.99 E.00031
; COOLING_NODE: 3
M204 S250
G1 X205.083 Y142.597 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X204.867 Y142.552 E.00658
G3 X205.113 Y139.997 I.383 J-1.252 E.10691
G1 X205.244 Y139.99 E.00391
G3 X205.142 Y142.605 I.005 J1.31 E.1259
; COOLING_NODE: 3
; WIPE_START
M204 S8000
G1 X204.867 Y142.552 E-.10664
G1 X204.616 Y142.446 E-.10342
G1 X204.412 Y142.308 E-.0935
G1 X204.245 Y142.141 E-.08964
G1 X204.104 Y141.935 E-.09508
G1 X203.997 Y141.683 E-.10386
G1 X203.947 Y141.436 E-.09591
G1 X203.945 Y141.247 E-.07194
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X196.374 Y142.212 Z1 F60000
G1 X151.666 Y147.916 Z1
G1 Z.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X151.666 Y142.147 E.18553
G1 X151.87 Y142.112 E.00665
G2 X151.87 Y140.488 I2.375 J-.812 E.45404
G1 X151.666 Y140.454 E.00665
G1 X151.666 Y137.916 E.0816
G1 X208.334 Y137.916 E1.82222
G1 X208.334 Y151.584 E.4395
G1 X170.834 Y151.584 E1.20586
G1 X170.834 Y182.084 E.98077
G1 X141.666 Y182.084 E.93792
G1 X141.666 Y147.916 E1.09871
G1 X151.606 Y147.916 E.31963
; COOLING_NODE: 3
M204 S10000
G1 X151.259 Y147.509 F60000
M73 P54 R7
G1 F8843.478
M204 S8000
G1 X151.259 Y137.509 E.32156
G1 X208.741 Y137.509 E1.8484
G1 X208.741 Y151.991 E.46568
G1 X171.241 Y151.991 E1.20586
G1 X171.241 Y182.491 E.98077
G1 X141.259 Y182.491 E.9641
G1 X141.259 Y147.509 E1.12489
G1 X151.199 Y147.509 E.31963
; COOLING_NODE: 3
M204 S10000
G1 X150.852 Y147.102 F60000
G1 F8843.478
M204 S8000
G1 X150.852 Y137.102 E.32156
G1 X209.148 Y137.102 E1.87458
G1 X209.148 Y152.398 E.49186
G1 X171.648 Y152.398 E1.20586
G1 X171.648 Y182.898 E.98077
G1 X140.852 Y182.898 E.99028
G1 X140.852 Y147.102 E1.15107
G1 X150.792 Y147.102 E.31963
; COOLING_NODE: 4
M204 S250
G1 X150.46 Y146.71 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X150.46 Y136.71 E.29787
G1 X209.54 Y136.71 E1.75979
G1 X209.54 Y152.79 E.47897
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X172.04 Y152.79 E1.117
G1 X172.04 Y183.29 E.90849
G1 X140.46 Y183.29 E.94066
G1 X140.46 Y146.71 E1.08959
G1 X150.4 Y146.71 E.29608
; WIPE_START
M204 S8000
G1 X150.412 Y144.71 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X151.83 Y147.307 Z1 F60000
G1 Z.6
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42102
G1 F9521.29
M204 S8000
G1 X156.432 Y151.909 E.19438
G2 X155.68 Y151.692 I-1.089 J2.362 E.02346
G1 X151.999 Y148.011 E.15546
G1 X151.999 Y148.249 E.00711
G1 X151.703 Y148.249 E.00886
G1 X155.115 Y151.662 E.14413
G2 X154.645 Y151.726 I-.073 J1.224 E.01428
G1 X151.168 Y148.249 E.14684
G1 X150.633 Y148.249 E.01597
G1 X154.226 Y151.842 E.15175
G2 X153.862 Y152.012 I1.093 J2.812 E.01202
G1 X150.099 Y148.249 E.15895
G1 X149.564 Y148.249 E.01597
G1 X153.541 Y152.226 E.16799
G2 X153.249 Y152.469 I.689 J1.125 E.01138
G1 X149.029 Y148.249 E.17824
G1 X148.495 Y148.249 E.01597
G1 X153 Y152.755 E.19032
G1 X152.785 Y153.075 E.01151
G1 X147.96 Y148.249 E.20382
G1 X147.425 Y148.249 E.01597
G1 X152.615 Y153.439 E.21921
G2 X152.479 Y153.838 I1.305 J.668 E.01263
G1 X146.89 Y148.249 E.23606
G1 X146.356 Y148.249 E.01597
G1 X152.409 Y154.302 E.25567
G2 X152.425 Y154.853 I2.799 J.194 E.01648
G1 X145.821 Y148.249 E.27893
G1 X145.286 Y148.249 E.01597
G1 X152.61 Y155.573 E.30934
G2 X153.065 Y156.333 I2.602 J-1.043 E.02658
G1 X153.449 Y156.712 E.0161
G2 X154.177 Y157.14 I1.982 J-2.537 E.0253
G1 X170.501 Y173.464 E.68949
G1 X170.501 Y172.929 E.01597
G1 X154.898 Y157.326 E.65905
G2 X155.448 Y157.341 I.356 J-2.855 E.01646
G1 X170.501 Y172.394 E.63581
G1 X170.501 Y171.86 E.01597
G1 X155.906 Y157.264 E.61648
G2 X156.31 Y157.134 I-.132 J-1.102 E.01277
G1 X170.501 Y171.325 E.5994
G1 X170.501 Y170.79 E.01597
G1 X156.676 Y156.966 E.58393
G2 X156.996 Y156.751 I-.924 J-1.723 E.01153
G1 X170.501 Y170.255 E.57041
G1 X170.501 Y169.721 E.01597
G1 X157.281 Y156.501 E.55839
G2 X157.524 Y156.209 I-.905 J-1.002 E.01138
G1 X170.501 Y169.186 E.54813
G1 X170.501 Y168.651 E.01597
G1 X157.739 Y155.889 E.53905
G2 X157.908 Y155.524 I-3.207 J-1.708 E.01203
G1 X170.501 Y168.117 E.5319
G1 X170.501 Y167.582 E.01597
G1 X158.024 Y155.105 E.52699
G2 X158.094 Y154.641 I-1.509 J-.466 E.01408
G1 X170.501 Y167.047 E.52402
G1 X170.501 Y166.512 E.01597
G1 X158.067 Y154.078 E.52519
G2 X157.843 Y153.32 I-2.29 J.263 E.02373
G1 X170.501 Y165.978 E.53464
G1 X170.501 Y165.443 E.01597
G1 X151.999 Y146.942 E.78147
G1 X151.999 Y146.407 E.01597
G1 X170.501 Y164.908 E.78147
G1 X170.501 Y164.374 E.01597
G1 X151.999 Y145.872 E.78147
G1 X151.999 Y145.338 E.01597
G1 X170.501 Y163.839 E.78147
G1 X170.501 Y163.304 E.01597
M73 P55 R7
G1 X151.999 Y144.803 E.78147
G1 X151.999 Y144.268 E.01597
G1 X170.501 Y162.769 E.78147
G1 X170.501 Y162.235 E.01597
G1 X151.999 Y143.733 E.78147
G1 X151.999 Y143.462 E.0081
G1 X152.138 Y143.337 E.00557
G1 X170.501 Y161.7 E.77561
G1 X170.501 Y161.165 E.01597
G1 X153.326 Y143.991 E.72543
G2 X153.998 Y144.128 I.784 J-2.12 E.02057
G1 X170.501 Y160.631 E.69704
G1 X170.501 Y160.096 E.01597
G1 X154.541 Y144.136 E.6741
G2 X154.985 Y144.045 I-.369 J-2.913 E.01353
G1 X170.501 Y159.561 E.65537
G1 X170.501 Y159.026 E.01597
G1 X155.388 Y143.914 E.63834
G2 X155.734 Y143.725 I-.49 J-1.314 E.01182
G1 X170.501 Y158.492 E.62371
G1 X170.501 Y157.957 E.01597
G1 X156.053 Y143.51 E.61024
G1 X156.323 Y143.244 E.01129
G1 X170.501 Y157.422 E.59886
G1 X170.501 Y156.888 E.01597
G1 X156.562 Y142.949 E.58874
G2 X156.772 Y142.625 I-.998 J-.878 E.01159
G1 X170.501 Y156.353 E.57986
G1 X170.501 Y155.818 E.01597
G1 X156.934 Y142.252 E.57302
G2 X157.049 Y141.832 I-2.933 J-1.03 E.01301
G1 X170.501 Y155.283 E.56816
G1 X170.501 Y154.749 E.01597
G1 X157.099 Y141.347 E.56605
G1 X157.051 Y140.765 E.01746
G1 X170.501 Y154.214 E.56807
G1 X170.501 Y153.679 E.01597
G1 X155.315 Y138.493 E.64143
G1 X155.332 Y138.249 E.00731
G1 X155.605 Y138.249 E.00817
G1 X170.501 Y153.145 E.62915
G1 X170.501 Y152.61 E.01597
G1 X156.14 Y138.249 E.60657
G1 X156.675 Y138.249 E.01597
G1 X170.501 Y152.075 E.58398
G1 X170.501 Y151.54 E.01597
G1 X157.21 Y138.249 E.5614
G1 X157.744 Y138.249 E.01597
G1 X170.746 Y151.251 E.54916
G1 X171.28 Y151.251 E.01597
G1 X158.279 Y138.249 E.54916
G1 X158.814 Y138.249 E.01597
G1 X171.815 Y151.251 E.54915
G1 X172.35 Y151.251 E.01597
G1 X159.348 Y138.249 E.54916
G1 X159.883 Y138.249 E.01597
G1 X172.884 Y151.251 E.54916
G1 X173.419 Y151.251 E.01597
G1 X160.418 Y138.249 E.54916
G1 X160.953 Y138.249 E.01597
G1 X173.954 Y151.251 E.54916
G1 X174.489 Y151.251 E.01597
G1 X161.487 Y138.249 E.54916
G1 X162.022 Y138.249 E.01597
G1 X175.023 Y151.251 E.54916
G1 X175.558 Y151.251 E.01597
G1 X162.557 Y138.249 E.54915
G1 X163.091 Y138.249 E.01597
G1 X176.093 Y151.251 E.54916
G1 X176.627 Y151.251 E.01597
G1 X163.626 Y138.249 E.54916
G1 X164.161 Y138.249 E.01597
G1 X177.162 Y151.251 E.54916
G1 X177.697 Y151.251 E.01597
G1 X164.696 Y138.249 E.54916
G1 X165.23 Y138.249 E.01597
G1 X178.232 Y151.251 E.54915
G1 X178.766 Y151.251 E.01597
G1 X165.765 Y138.249 E.54916
G1 X166.3 Y138.249 E.01597
G1 X179.301 Y151.251 E.54916
G1 X179.836 Y151.251 E.01597
G1 X166.834 Y138.249 E.54916
G1 X167.369 Y138.249 E.01597
G1 X180.37 Y151.251 E.54916
G1 X180.905 Y151.251 E.01597
G1 X167.904 Y138.249 E.54916
G1 X168.439 Y138.249 E.01597
G1 X181.44 Y151.251 E.54916
G1 X181.975 Y151.251 E.01597
G1 X168.973 Y138.249 E.54915
G1 X169.508 Y138.249 E.01597
G1 X182.509 Y151.251 E.54916
G1 X183.044 Y151.251 E.01597
G1 X170.043 Y138.249 E.54916
G1 X170.577 Y138.249 E.01597
G1 X183.579 Y151.251 E.54916
G1 X184.113 Y151.251 E.01597
G1 X171.112 Y138.249 E.54916
G1 X171.647 Y138.249 E.01597
G1 X184.648 Y151.251 E.54915
G1 X185.183 Y151.251 E.01597
G1 X172.182 Y138.249 E.54916
G1 X172.716 Y138.249 E.01597
G1 X185.718 Y151.251 E.54916
G1 X186.252 Y151.251 E.01597
G1 X173.251 Y138.249 E.54916
G1 X173.786 Y138.249 E.01597
G1 X186.787 Y151.251 E.54916
G1 X187.322 Y151.251 E.01597
G1 X174.32 Y138.249 E.54916
G1 X174.855 Y138.249 E.01597
G1 X187.856 Y151.251 E.54916
G1 X188.391 Y151.251 E.01597
G1 X175.39 Y138.249 E.54915
G1 X175.925 Y138.249 E.01597
G1 X188.926 Y151.251 E.54916
G1 X189.461 Y151.251 E.01597
G1 X176.459 Y138.249 E.54916
G1 X176.994 Y138.249 E.01597
G1 X189.995 Y151.251 E.54916
G1 X190.53 Y151.251 E.01597
G1 X177.529 Y138.249 E.54916
G1 X178.063 Y138.249 E.01597
G1 X191.065 Y151.251 E.54916
M73 P56 R7
G1 X191.599 Y151.251 E.01597
G1 X178.598 Y138.249 E.54916
G1 X179.133 Y138.249 E.01597
G1 X192.134 Y151.251 E.54916
G1 X192.669 Y151.251 E.01597
G1 X179.668 Y138.249 E.54916
G1 X180.202 Y138.249 E.01597
G1 X193.204 Y151.251 E.54916
G1 X193.738 Y151.251 E.01597
G1 X180.737 Y138.249 E.54916
G1 X181.272 Y138.249 E.01597
G1 X194.273 Y151.251 E.54916
G1 X194.808 Y151.251 E.01597
G1 X181.806 Y138.249 E.54916
G1 X182.341 Y138.249 E.01597
G1 X195.342 Y151.251 E.54916
G1 X195.877 Y151.251 E.01597
G1 X182.876 Y138.249 E.54916
G1 X183.411 Y138.249 E.01597
G1 X196.412 Y151.251 E.54916
G1 X196.947 Y151.251 E.01597
G1 X183.945 Y138.249 E.54916
G1 X184.48 Y138.249 E.01597
G1 X197.481 Y151.251 E.54916
G1 X198.016 Y151.251 E.01597
G1 X185.015 Y138.249 E.54916
G1 X185.549 Y138.249 E.01597
G1 X198.551 Y151.251 E.54916
G1 X199.085 Y151.251 E.01597
G1 X186.084 Y138.249 E.54916
G1 X186.619 Y138.249 E.01597
M73 P56 R6
G1 X199.62 Y151.251 E.54916
G1 X200.155 Y151.251 E.01597
G1 X187.154 Y138.249 E.54916
G1 X187.688 Y138.249 E.01597
G1 X200.69 Y151.251 E.54916
G1 X201.224 Y151.251 E.01597
G1 X188.223 Y138.249 E.54916
G1 X188.758 Y138.249 E.01597
G1 X201.759 Y151.251 E.54916
G1 X202.294 Y151.251 E.01597
G1 X189.292 Y138.249 E.54916
G1 X189.827 Y138.249 E.01597
G1 X202.828 Y151.251 E.54916
G1 X203.363 Y151.251 E.01597
G1 X190.362 Y138.249 E.54916
G1 X190.897 Y138.249 E.01597
G1 X203.898 Y151.251 E.54916
G1 X204.433 Y151.251 E.01597
G1 X191.431 Y138.249 E.54916
G1 X191.966 Y138.249 E.01597
G1 X204.967 Y151.251 E.54916
G1 X205.502 Y151.251 E.01597
G1 X192.501 Y138.249 E.54916
G1 X193.035 Y138.249 E.01597
G1 X206.037 Y151.251 E.54916
G1 X206.571 Y151.251 E.01597
G1 X193.57 Y138.249 E.54916
G1 X194.105 Y138.249 E.01597
G1 X207.106 Y151.251 E.54916
G1 X207.641 Y151.251 E.01597
G1 X194.64 Y138.249 E.54916
G1 X195.174 Y138.249 E.01597
G1 X208.001 Y151.076 E.54177
G1 X208.001 Y150.541 E.01597
G1 X195.709 Y138.249 E.51918
G1 X196.244 Y138.249 E.01597
G1 X208.001 Y150.006 E.4966
G1 X208.001 Y149.472 E.01597
G1 X196.778 Y138.249 E.47401
G1 X197.313 Y138.249 E.01597
G1 X208.001 Y148.937 E.45143
G1 X208.001 Y148.402 E.01597
G1 X197.848 Y138.249 E.42884
G1 X198.383 Y138.249 E.01597
G1 X208.001 Y147.867 E.40626
G1 X208.001 Y147.333 E.01597
G1 X204.767 Y144.099 E.13658
G1 X204.954 Y144.137 E.00571
G1 X205.343 Y144.14 E.0116
G1 X208.001 Y146.798 E.11227
G1 X208.001 Y146.263 E.01597
G1 X205.828 Y144.091 E.09176
G2 X206.242 Y143.97 I-.369 J-2.026 E.01289
G1 X208.001 Y145.729 E.07429
G1 X208.001 Y145.194 E.01597
G1 X206.611 Y143.805 E.05868
G1 X206.933 Y143.591 E.01152
G1 X208.001 Y144.659 E.04511
G1 X208.001 Y144.124 E.01597
G1 X207.221 Y143.345 E.03293
G2 X207.48 Y143.069 I-.585 J-.809 E.01137
G1 X208.17 Y143.759 E.02916
M204 S10000
G1 X208.17 Y143.225 F60000
G1 F9521.29
M204 S8000
G1 X207.851 Y142.905 E.01349
M204 S10000
G1 X207.654 Y142.577 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.433781
G1 F9210.446
M204 S8000
G1 X207.936 Y142.436 E.00972
; LINE_WIDTH: 0.408804
G1 F9839.193
G1 X207.959 Y142.307 E.00379
; LINE_WIDTH: 0.362482
G1 F11265.447
G1 X207.982 Y142.178 E.00331
; LINE_WIDTH: 0.319105
G1 F13034.763
G1 X208.002 Y142.028 E.0033
; LINE_WIDTH: 0.281772
G1 F15000
G1 X208.02 Y141.892 E.00258
; LINE_WIDTH: 0.240284
G1 X208.043 Y141.597 E.00462
; LINE_WIDTH: 0.208761
G1 X208.044 Y141.012 E.00767
; LINE_WIDTH: 0.238944
G1 X208.021 Y140.716 E.00459
; LINE_WIDTH: 0.28136
G1 X208.001 Y140.566 E.00285
; LINE_WIDTH: 0.319352
G1 F13023.124
G1 X207.983 Y140.428 E.00305
; LINE_WIDTH: 0.361536
G1 F11298.88
G1 X207.959 Y140.292 E.00348
; LINE_WIDTH: 0.408097
G1 F9858.231
G1 X207.937 Y140.17 E.00357
; LINE_WIDTH: 0.437453
G1 F9124.719
G1 X207.889 Y139.956 E.00682
; WIPE_START
G1 X207.937 Y140.17 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X206.365 Y138.624 Z1 F60000
G1 Z.6
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F9547.299
M204 S8000
G1 X206.614 Y138.73 E.00806
G1 X207.07 Y139.029 E.01625
G1 X207.469 Y139.418 E.01658
G1 X207.616 Y139.616 E.00735
G1 X207.942 Y139.543 E.00995
G1 X207.942 Y138.308 E.03676
G1 X206.387 Y138.308 E.04631
G1 X206.369 Y138.564 E.00765
; WIPE_START
G1 X206.387 Y138.308 E-.09756
G1 X207.942 Y138.308 E-.59087
G1 X207.942 Y138.497 E-.07158
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X207.511 Y138.713 Z1 F60000
G1 Z.6
G1 E.8 F1800
; LINE_WIDTH: 0.59544
G1 F6515.602
M204 S8000
G2 X207.516 Y138.825 I-.03 J.057 E.01186
; WIPE_START
G1 X207.442 Y138.833 E-.20002
G1 X207.408 Y138.773 E-.18666
G1 X207.442 Y138.713 E-.18666
G1 X207.511 Y138.713 E-.18666
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X205.988 Y138.388 Z1 F60000
G1 Z.6
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.521733
G1 F7518.591
M204 S8000
G2 X204.514 Y138.39 I-.725 J6.774 E.05586
M204 S10000
G1 X204.289 Y138.808 F60000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42102
G1 F9521.29
M204 S8000
G1 X203.73 Y138.249 E.02361
G1 X203.195 Y138.249 E.01597
G1 X203.797 Y138.851 E.02541
G2 X203.479 Y139.068 I.879 J1.622 E.01151
G1 X202.66 Y138.249 E.03459
G1 X202.126 Y138.249 E.01597
G1 X203.206 Y139.329 E.04562
G2 X202.958 Y139.617 I.642 J.801 E.01139
G1 X201.591 Y138.249 E.05777
G1 X201.056 Y138.249 E.01597
G1 X202.745 Y139.939 E.07135
G2 X202.58 Y140.308 I1.673 J.969 E.01211
G1 X200.521 Y138.249 E.08697
G1 X199.987 Y138.249 E.01597
G1 X202.459 Y140.722 E.10443
G2 X202.41 Y141.207 I2.541 J.503 E.0146
G1 X199.452 Y138.249 E.12494
G1 X198.917 Y138.249 E.01597
G1 X202.668 Y142 E.15843
; WIPE_START
G1 X201.254 Y140.586 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X196.115 Y146.229 Z1 F60000
G1 X170.67 Y174.168 Z1
G1 Z.6
G1 E.8 F1800
G1 F9521.29
M204 S8000
G1 X144.752 Y148.249 E1.09477
G1 X144.217 Y148.249 E.01597
G1 X170.501 Y174.533 E1.11019
G1 X170.501 Y175.068 E.01597
G1 X143.682 Y148.249 E1.13278
G1 X143.147 Y148.249 E.01597
G1 X170.501 Y175.603 E1.15536
G1 X170.501 Y176.137 E.01597
G1 X142.613 Y148.249 E1.17795
G1 X142.078 Y148.249 E.01597
G1 X170.501 Y176.672 E1.20053
G1 X170.501 Y176.79 E.00353
G1 X170.161 Y176.867 E.0104
G1 X141.999 Y148.705 E1.1895
G1 X141.999 Y149.24 E.01597
G1 X168.514 Y175.754 E1.11992
G1 X168.004 Y175.659 E.01549
G1 X167.884 Y175.66 E.00358
G1 X141.999 Y149.775 E1.09333
M73 P57 R6
G1 X141.999 Y150.31 E.01597
G1 X167.369 Y175.68 E1.07159
G1 X166.926 Y175.771 E.01352
G1 X141.999 Y150.844 E1.05286
G1 X141.999 Y151.379 E.01597
G1 X166.541 Y175.921 E1.03661
G2 X166.204 Y176.118 I.518 J1.272 E.01171
G1 X141.999 Y151.914 E1.02236
G1 X141.999 Y152.448 E.01597
G1 X165.892 Y176.341 E1.00918
G2 X165.623 Y176.607 I1.156 J1.439 E.01131
G1 X141.999 Y152.983 E.99782
G1 X141.999 Y153.518 E.01597
G1 X165.394 Y176.913 E.98817
G2 X165.197 Y177.25 I.79 J.69 E.01174
G1 X141.999 Y154.053 E.97982
G1 X141.999 Y154.587 E.01597
G1 X165.036 Y177.624 E.97305
G2 X164.936 Y178.059 I3.901 J1.124 E.01333
G1 X141.999 Y155.122 E.96883
G1 X141.999 Y155.657 E.01597
G1 X164.901 Y178.559 E.96735
G2 X164.992 Y179.184 I2.112 J.013 E.01895
G1 X141.999 Y156.191 E.97118
G1 X141.999 Y156.726 E.01597
G1 X167.024 Y181.751 E1.057
G1 X167.559 Y181.751 E.01597
G1 X167.066 Y181.258 E.0208
G2 X167.691 Y181.349 I.613 J-2.033 E.01894
G1 X168.093 Y181.751 E.01698
G1 X168.628 Y181.751 E.01597
G1 X168.186 Y181.309 E.01867
G1 X168.623 Y181.211 E.01338
G1 X169.163 Y181.751 E.02279
G1 X169.697 Y181.751 E.01597
G1 X169.002 Y181.055 E.02938
G2 X169.345 Y180.863 I-1.455 J-3.007 E.01174
G1 X170.232 Y181.751 E.03748
G1 X170.501 Y181.751 E.00802
G1 X170.501 Y181.484 E.00795
G1 X169.641 Y180.624 E.03633
G1 X169.909 Y180.358 E.01129
G1 X170.501 Y180.95 E.02498
G1 X170.501 Y180.415 E.01597
G1 X170.01 Y179.925 E.02071
M204 S10000
G1 X170.389 Y179.843 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.437144
G1 F9131.867
M204 S8000
G1 X170.437 Y179.629 E.00683
; LINE_WIDTH: 0.404438
G1 F9958.034
G1 X170.462 Y179.489 E.00405
; LINE_WIDTH: 0.355146
G1 F11530.12
G1 X170.486 Y179.35 E.0035
; LINE_WIDTH: 0.328382
G1 F12611.143
G1 X170.489 Y179.336 E.00032
; LINE_WIDTH: 0.309995
G1 F13479.366
G1 X170.505 Y179.207 E.00274
; LINE_WIDTH: 0.276221
G1 F15000
G1 X170.522 Y179.067 E.00259
; LINE_WIDTH: 0.237381
G1 X170.544 Y178.786 E.00432
; LINE_WIDTH: 0.20818
G1 X170.545 Y178.235 E.00719
; LINE_WIDTH: 0.234219
G1 X170.524 Y177.953 E.00427
; LINE_WIDTH: 0.272204
G1 X170.507 Y177.811 E.00259
; LINE_WIDTH: 0.308943
G1 F13532.666
G1 X170.487 Y177.655 E.00332
; LINE_WIDTH: 0.353939
G1 F11574.852
G1 X170.462 Y177.513 E.00354
; LINE_WIDTH: 0.403913
G1 F9972.492
G1 X170.437 Y177.371 E.00411
; LINE_WIDTH: 0.437052
G1 F9134.001
G1 X170.389 Y177.157 E.00684
; WIPE_START
G1 X170.437 Y177.371 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X166.659 Y181.92 Z1 F60000
G1 Z.6
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42102
G1 F9521.29
M204 S8000
G1 X141.999 Y157.261 E1.04158
G1 X141.999 Y157.796 E.01597
G1 X165.954 Y181.751 E1.01183
G1 X165.42 Y181.751 E.01597
G1 X141.999 Y158.33 E.98924
G1 X141.999 Y158.865 E.01597
G1 X164.885 Y181.751 E.96666
G1 X164.35 Y181.751 E.01597
G1 X141.999 Y159.4 E.94407
G1 X141.999 Y159.934 E.01597
G1 X163.816 Y181.751 E.92148
G1 X163.281 Y181.751 E.01597
G1 X141.999 Y160.469 E.8989
G1 X141.999 Y161.004 E.01597
G1 X162.746 Y181.751 E.87631
G1 X162.211 Y181.751 E.01597
G1 X141.999 Y161.539 E.85373
G1 X141.999 Y162.073 E.01597
G1 X161.677 Y181.751 E.83114
G1 X161.142 Y181.751 E.01597
G1 X141.999 Y162.608 E.80856
G1 X141.999 Y163.143 E.01597
G1 X160.607 Y181.751 E.78597
G1 X160.073 Y181.751 E.01597
G1 X141.999 Y163.677 E.76339
G1 X141.999 Y164.212 E.01597
G1 X159.538 Y181.751 E.7408
G1 X159.003 Y181.751 E.01597
G1 X141.999 Y164.747 E.71821
G1 X141.999 Y165.282 E.01597
G1 X158.468 Y181.751 E.69563
G1 X157.934 Y181.751 E.01597
G1 X141.999 Y165.816 E.67304
G1 X141.999 Y166.351 E.01597
G1 X157.399 Y181.751 E.65046
G1 X156.864 Y181.751 E.01597
G1 X141.999 Y166.886 E.62787
G1 X141.999 Y167.42 E.01597
G1 X156.33 Y181.751 E.60529
G1 X155.795 Y181.751 E.01597
G1 X141.999 Y167.955 E.5827
G1 X141.999 Y168.49 E.01597
G1 X155.26 Y181.751 E.56012
G1 X154.725 Y181.751 E.01597
G1 X141.999 Y169.025 E.53753
G1 X141.999 Y169.559 E.01597
G1 X154.191 Y181.751 E.51494
G1 X153.656 Y181.751 E.01597
G1 X141.999 Y170.094 E.49236
G1 X141.999 Y170.629 E.01597
G1 X153.121 Y181.751 E.46977
G1 X152.587 Y181.751 E.01597
G1 X141.999 Y171.163 E.44719
G1 X141.999 Y171.698 E.01597
G1 X152.052 Y181.751 E.4246
G1 X151.517 Y181.751 E.01597
G1 X141.999 Y172.233 E.40202
G1 X141.999 Y172.768 E.01597
G1 X150.982 Y181.751 E.37943
G1 X150.448 Y181.751 E.01597
G1 X141.999 Y173.302 E.35685
G1 X141.999 Y173.837 E.01597
G1 X149.913 Y181.751 E.33426
G1 X149.378 Y181.751 E.01597
M73 P58 R6
G1 X141.999 Y174.372 E.31167
G1 X141.999 Y174.906 E.01597
G1 X148.844 Y181.751 E.28909
G1 X148.309 Y181.751 E.01597
G1 X141.999 Y175.441 E.2665
G1 X141.999 Y175.976 E.01597
G1 X147.774 Y181.751 E.24392
G1 X147.239 Y181.751 E.01597
G1 X141.999 Y176.511 E.22133
G1 X141.999 Y177.045 E.01597
G1 X146.705 Y181.751 E.19875
G1 X146.17 Y181.751 E.01597
G1 X141.999 Y177.58 E.17616
G1 X141.999 Y178.115 E.01597
G1 X145.635 Y181.751 E.15358
G1 X145.101 Y181.751 E.01597
G1 X141.999 Y178.649 E.13099
G1 X141.999 Y179.184 E.01597
G1 X144.566 Y181.751 E.1084
G1 X144.031 Y181.751 E.01597
G1 X141.999 Y179.719 E.08582
G1 X141.999 Y180.254 E.01597
G1 X143.496 Y181.751 E.06323
G1 X142.962 Y181.751 E.01597
G1 X141.999 Y180.788 E.04065
G1 X141.999 Y181.323 E.01597
G1 X142.597 Y181.92 E.02523
; WIPE_START
G1 X141.999 Y181.323 E-.32099
G1 X141.999 Y180.788 E-.20319
G1 X142.438 Y181.227 E-.23581
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X144.3 Y173.825 Z1 F60000
G1 X152.064 Y142.956 Z1
G1 Z.6
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.121878
G1 F15000
M204 S8000
G1 X151.87 Y142.734 E.00184
M204 S10000
G1 X151.732 Y141.929 F60000
; LINE_WIDTH: 0.531343
G1 F7370.664
M204 S8000
G3 X151.732 Y140.671 I6.005 J-.63 E.04862
M204 S10000
G1 X151.87 Y139.872 F60000
; LINE_WIDTH: 0.11784
G1 F15000
M204 S8000
G1 X152.05 Y139.662 E.00164
; WIPE_START
G1 X151.87 Y139.872 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X153.06 Y138.573 Z1 F60000
G1 Z.6
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.5705
G1 F6823.61
M204 S8000
G1 X153.045 Y138.384 E.0079
G1 X152.134 Y138.384 E.03799
G1 X152.134 Y139.129 E.03107
G1 X152.221 Y139.123 E.00365
G1 X152.811 Y138.686 E.03059
G1 X153.005 Y138.597 E.00892
M204 S10000
G1 X153.514 Y138.39 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.521725
G1 F7518.732
M204 S8000
G3 X154.988 Y138.388 I.748 J6.775 E.05585
; CHANGE_LAYER
; Z_HEIGHT: 0.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F7518.732
G1 X154.244 Y138.349 E-.38375
G1 X153.514 Y138.39 E-.37625
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 4/54
; update layer progress
M73 L4
M991 S0 P3 ;notify layer change

M106 S102
; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z1 I-1.211 J.122 P1  F60000
G1 X154.018 Y143.389 Z1
G1 Z.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X153.886 Y143.376 E.00427
G3 X154.026 Y139.202 I.363 J-2.078 E.19416
G1 X154.225 Y139.19 E.00639
G3 X154.29 Y143.407 I.024 J2.109 E.21249
G1 X154.078 Y143.393 E.00685
; COOLING_NODE: 0
M204 S10000
G1 X154.049 Y142.984 F60000
G1 F8843.478
M204 S8000
G1 X153.956 Y142.975 E.00302
G3 X154.07 Y139.607 I.293 J-1.676 E.15667
G1 X154.229 Y139.597 E.00512
G3 X154.282 Y143 I.02 J1.702 E.17149
G1 X154.109 Y142.988 E.00557
; COOLING_NODE: 0
M204 S250
G1 X154.079 Y142.595 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X154.023 Y142.589 E.00169
G3 X154.113 Y139.997 I.226 J-1.29 E.11167
G1 X154.233 Y139.99 E.00361
G3 X154.274 Y142.608 I.016 J1.309 E.12227
G1 X154.139 Y142.599 E.00401
; COOLING_NODE: 0
; WIPE_START
M204 S8000
G1 X154.023 Y142.589 E-.04439
G1 X153.78 Y142.523 E-.09575
G1 X153.537 Y142.399 E-.10344
G1 X153.34 Y142.242 E-.09585
G1 X153.177 Y142.052 E-.09535
G1 X153.053 Y141.833 E-.09547
G1 X152.973 Y141.594 E-.09572
G1 X152.94 Y141.323 E-.10371
G1 X152.946 Y141.244 E-.03031
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X156.19 Y148.152 Z1.2 F60000
G1 X169.698 Y176.922 Z1.2
G1 Z.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X169.811 Y177.057 E.00566
G3 X167.483 Y175.996 I-2.062 J1.442 E.4221
G1 X167.72 Y175.982 E.00766
G3 X169.493 Y176.686 I.028 J2.516 E.06292
G1 X169.659 Y176.876 E.00812
; COOLING_NODE: 0
M204 S10000
G1 X169.39 Y177.186 F60000
G1 F8843.478
M204 S8000
G1 X169.477 Y177.29 E.00437
G3 X167.526 Y176.401 I-1.728 J1.208 E.3538
G1 X167.725 Y176.39 E.00638
G3 X169.212 Y176.98 I.024 J2.109 E.05277
G1 X169.351 Y177.141 E.00684
; COOLING_NODE: 0
M204 S10000
G1 X169.082 Y177.45 F60000
G1 F8843.478
M204 S8000
G1 X169.144 Y177.524 E.00309
G3 X167.57 Y176.807 I-1.395 J.975 E.28549
G1 X167.729 Y176.797 E.00511
G3 X168.93 Y177.274 I.02 J1.702 E.04263
G1 X169.043 Y177.405 E.00555
; COOLING_NODE: 1
M204 S250
G1 X168.786 Y177.704 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X168.823 Y177.749 E.00173
G3 X167.613 Y177.197 I-1.073 J.75 E.20351
G1 X167.733 Y177.19 E.0036
G3 X168.659 Y177.557 I.016 J1.309 E.03043
G1 X168.746 Y177.659 E.00399
; COOLING_NODE: 1
; WIPE_START
M204 S8000
G1 X168.823 Y177.749 E-.04481
G1 X168.956 Y177.988 E-.10421
G1 X169.031 Y178.227 E-.09517
G1 X169.06 Y178.476 E-.09507
G1 X169.04 Y178.727 E-.0958
G1 X168.971 Y178.975 E-.09795
G1 X168.849 Y179.213 E-.10136
G1 X168.692 Y179.41 E-.096
G1 X168.633 Y179.461 E-.02963
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X165.045 Y172.724 Z1.2 F60000
G1 X154.144 Y152.248 Z1.2
G1 Z.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X154.478 Y152.103 E.01173
G3 X154.983 Y151.996 I.77 J2.396 E.0166
G1 X155.22 Y151.982 E.00766
G3 X154.035 Y152.294 I.028 J2.516 E.46859
G1 X154.088 Y152.271 E.00188
; COOLING_NODE: 1
M204 S10000
G1 X154.304 Y152.62 F60000
G1 F8843.478
M204 S8000
G1 X154.603 Y152.491 E.01046
G3 X155.026 Y152.401 I.646 J2.008 E.01395
G1 X155.225 Y152.39 E.00638
G3 X154.231 Y152.652 I.024 J2.109 E.39272
G1 X154.249 Y152.644 E.00063
; COOLING_NODE: 1
M204 S10000
G1 X154.465 Y152.993 F60000
G1 F8843.478
M204 S8000
G1 X154.727 Y152.879 E.00918
G3 X155.07 Y152.807 I.522 J1.62 E.01131
G1 X155.229 Y152.797 E.00511
G3 X154.411 Y153.018 I.02 J1.702 E.31626
; COOLING_NODE: 2
M204 S250
G1 X154.62 Y153.352 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X154.846 Y153.253 E.00735
G3 X155.113 Y153.197 I.403 J1.246 E.00812
G1 X155.233 Y153.19 E.0036
G3 X154.568 Y153.381 I.016 J1.309 E.22419
; COOLING_NODE: 2
; WIPE_START
M204 S8000
G1 X154.846 Y153.253 E-.1164
G1 X155.113 Y153.197 E-.10339
G1 X155.233 Y153.19 E-.04594
G1 X155.5 Y153.214 E-.10168
G1 X155.741 Y153.285 E-.0956
G1 X155.963 Y153.401 E-.09512
G1 X156.16 Y153.557 E-.09565
G1 X156.324 Y153.749 E-.09584
G1 X156.337 Y153.773 E-.01037
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X163.814 Y152.239 Z1.2 F60000
G1 X204.976 Y143.793 Z1.2
G1 Z.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X204.818 Y143.778 E.00512
G3 X204.983 Y138.796 I.431 J-2.479 E.23174
G1 X205.22 Y138.782 E.00765
G3 X205.297 Y143.814 I.028 J2.516 E.25353
G1 X205.036 Y143.797 E.00841
; COOLING_NODE: 2
M204 S10000
G1 X205.008 Y143.388 F60000
G1 F8843.478
M204 S8000
G1 X204.887 Y143.377 E.00389
G3 X205.027 Y139.201 I.362 J-2.078 E.19422
G1 X205.225 Y139.19 E.00638
G3 X205.289 Y143.407 I.024 J2.109 E.21252
G1 X205.067 Y143.392 E.00715
; COOLING_NODE: 2
M204 S10000
G1 X205.039 Y142.984 F60000
G1 F8843.478
M204 S8000
G1 X204.956 Y142.975 E.00266
G3 X205.07 Y139.607 I.293 J-1.676 E.1567
G1 X205.229 Y139.597 E.00511
G3 X205.281 Y143 I.02 J1.702 E.17152
G1 X205.099 Y142.988 E.00589
; COOLING_NODE: 3
M204 S250
G1 X205.069 Y142.594 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X205.023 Y142.589 E.00137
G3 X205.113 Y139.997 I.226 J-1.29 E.11168
G1 X205.233 Y139.99 E.00361
G3 X205.274 Y142.608 I.016 J1.309 E.12229
G1 X205.129 Y142.598 E.00432
; COOLING_NODE: 3
; WIPE_START
M204 S8000
G1 X205.023 Y142.589 E-.04033
G1 X204.781 Y142.523 E-.09551
G1 X204.556 Y142.411 E-.09542
G1 X204.34 Y142.242 E-.10421
G1 X204.176 Y142.05 E-.09596
G1 X204.044 Y141.812 E-.10332
G1 X203.969 Y141.573 E-.09533
G1 X203.94 Y141.323 E-.09574
G1 X203.947 Y141.233 E-.03417
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X196.376 Y142.201 Z1.2 F60000
G1 X151.666 Y147.916 Z1.2
G1 Z.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X151.666 Y142.145 E.18559
G1 X151.865 Y142.107 E.00651
G2 X151.87 Y140.488 I2.385 J-.803 E.45538
G1 X151.666 Y140.453 E.00665
G1 X151.666 Y137.916 E.08159
G1 X208.334 Y137.916 E1.82222
G1 X208.334 Y151.584 E.4395
G1 X170.834 Y151.584 E1.20586
G1 X170.834 Y182.084 E.98077
G1 X141.666 Y182.084 E.93792
G1 X141.666 Y147.916 E1.09871
G1 X151.606 Y147.916 E.31963
; COOLING_NODE: 3
M204 S10000
G1 X151.259 Y147.509 F60000
G1 F8843.478
M204 S8000
G1 X151.259 Y137.509 E.32156
G1 X208.741 Y137.509 E1.8484
G1 X208.741 Y151.991 E.46568
G1 X171.241 Y151.991 E1.20586
G1 X171.241 Y182.491 E.98077
G1 X141.259 Y182.491 E.9641
G1 X141.259 Y147.509 E1.12489
G1 X151.199 Y147.509 E.31963
; COOLING_NODE: 3
M204 S10000
G1 X150.852 Y147.102 F60000
G1 F8843.478
M204 S8000
G1 X150.852 Y137.102 E.32156
G1 X209.148 Y137.102 E1.87458
G1 X209.148 Y152.398 E.49186
G1 X171.648 Y152.398 E1.20586
G1 X171.648 Y182.898 E.98077
G1 X140.852 Y182.898 E.99028
G1 X140.852 Y147.102 E1.15107
G1 X150.792 Y147.102 E.31963
; COOLING_NODE: 4
M204 S250
G1 X150.46 Y146.71 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
M73 P59 R6
G1 F9547.055
M204 S5000
G1 X150.46 Y136.71 E.29787
G1 X209.54 Y136.71 E1.75979
G1 X209.54 Y152.79 E.47897
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X172.04 Y152.79 E1.117
G1 X172.04 Y183.29 E.90849
G1 X140.46 Y183.29 E.94066
G1 X140.46 Y146.71 E1.08959
G1 X150.4 Y146.71 E.29608
; WIPE_START
M204 S8000
G1 X150.412 Y144.71 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X151.83 Y147.433 Z1.2 F60000
G1 Z.8
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42234
G1 F9488.165
M204 S8000
G1 X155.341 Y143.921 E.14885
G3 X154.61 Y144.117 I-.911 J-1.944 E.02282
G1 X151.999 Y146.727 E.11064
G1 X151.999 Y146.19 E.01608
G1 X154.057 Y144.133 E.08721
G3 X153.59 Y144.063 I-.055 J-1.231 E.01424
G1 X151.999 Y145.654 E.06741
G1 X151.999 Y145.117 E.01608
G1 X153.177 Y143.94 E.04991
G3 X152.823 Y143.757 I.425 J-1.262 E.01199
G1 X151.999 Y144.581 E.03489
G1 X151.999 Y144.044 E.01608
G1 X152.494 Y143.547 E.02102
G3 X152.235 Y143.315 I.975 J-1.349 E.01044
G1 X152.037 Y143.502 E.00815
G1 X152.022 Y143.485 E.00068
G1 X151.83 Y143.677 E.00814
M204 S10000
G1 X152.092 Y142.993 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.109364
G1 F15000
M204 S8000
G1 X151.988 Y142.882 E.0008
; LINE_WIDTH: 0.13618
G1 X151.87 Y142.746 E.00133
M204 S10000
G1 X151.736 Y141.924 F60000
; LINE_WIDTH: 0.531793
G1 F7363.884
M204 S8000
G3 X151.731 Y140.671 I5.73 J-.65 E.04851
M204 S10000
G1 X151.87 Y139.877 F60000
; LINE_WIDTH: 0.116683
G1 F15000
M204 S8000
G1 X152.035 Y139.682 E.00149
; WIPE_START
G1 X151.87 Y139.877 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X153.064 Y138.588 Z1.2 F60000
G1 Z.8
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.56565
G1 F6886.921
M204 S8000
G1 X153.047 Y138.381 E.00856
G1 X152.131 Y138.381 E.03783
G1 X152.131 Y139.159 E.03213
G1 X152.184 Y139.159 E.00218
G1 X152.613 Y138.809 E.02286
G1 X153.01 Y138.614 E.01825
M204 S10000
G1 X153.514 Y138.39 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.521737
G1 F7518.542
M204 S8000
G3 X154.988 Y138.388 I.748 J6.759 E.05585
M204 S10000
G1 X155.125 Y138.772 F60000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42234
G1 F9488.165
M204 S8000
G1 X155.648 Y138.249 E.02215
G1 X156.184 Y138.249 E.01608
G1 X155.621 Y138.812 E.02387
G3 X155.948 Y139.023 I-.379 J.948 E.01171
G1 X156.721 Y138.249 E.03277
G1 X157.257 Y138.249 E.01608
G1 X156.244 Y139.263 E.04295
G3 X156.493 Y139.551 I-.846 J.982 E.01144
G1 X157.794 Y138.249 E.05516
G1 X158.331 Y138.249 E.01608
G1 X156.712 Y139.868 E.06863
G3 X156.889 Y140.228 I-2.493 J1.453 E.01202
G1 X158.867 Y138.249 E.08386
G1 X159.404 Y138.249 E.01608
G1 X157.018 Y140.635 E.10113
G1 X157.041 Y140.707 E.00226
G1 X157.085 Y141.104 E.01197
G1 X159.94 Y138.249 E.12101
G1 X160.477 Y138.249 E.01608
G1 X157.07 Y141.656 E.14439
G1 X157.06 Y141.791 E.00408
G1 X156.889 Y142.373 E.01817
G1 X161.014 Y138.249 E.1748
G1 X161.55 Y138.249 E.01608
G1 X151.83 Y147.97 E.41201
; WIPE_START
G1 X153.244 Y146.556 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X145.761 Y148.058 Z1.2 F60000
G1 X141.83 Y148.848 Z1.2
G1 Z.8
G1 E.8 F1800
G1 F9488.165
M204 S8000
G1 X142.428 Y148.249 E.02537
G1 X142.965 Y148.249 E.01608
G1 X141.999 Y149.215 E.04092
G1 X141.999 Y149.751 E.01608
G1 X143.501 Y148.249 E.06367
G1 X144.038 Y148.249 E.01608
G1 X141.999 Y150.288 E.08641
G1 X141.999 Y150.825 E.01608
G1 X144.575 Y148.249 E.10915
G1 X145.111 Y148.249 E.01608
G1 X141.999 Y151.361 E.1319
G1 X141.999 Y151.898 E.01608
G1 X145.648 Y148.249 E.15464
G1 X146.184 Y148.249 E.01608
G1 X141.999 Y152.434 E.17738
G1 X141.999 Y152.971 E.01608
G1 X146.721 Y148.249 E.20013
G1 X147.257 Y148.249 E.01608
G1 X141.999 Y153.507 E.22287
G1 X141.999 Y154.044 E.01608
G1 X147.794 Y148.249 E.24561
G1 X148.331 Y148.249 E.01608
G1 X141.999 Y154.581 E.26836
G1 X141.999 Y155.117 E.01608
G1 X148.867 Y148.249 E.2911
G1 X149.404 Y148.249 E.01608
G1 X141.999 Y155.654 E.31384
G1 X141.999 Y156.19 E.01608
G1 X149.94 Y148.249 E.33659
G1 X150.477 Y148.249 E.01608
G1 X141.999 Y156.727 E.35933
G1 X141.999 Y157.264 E.01608
G1 X151.014 Y148.249 E.38208
G1 X151.55 Y148.249 E.01608
G1 X141.999 Y157.8 E.40482
G1 X141.999 Y158.337 E.01608
G1 X162.087 Y138.249 E.85142
G1 X162.623 Y138.249 E.01608
G1 X141.999 Y158.873 E.87417
G1 X141.999 Y159.41 E.01608
G1 X163.16 Y138.249 E.89691
G1 X163.696 Y138.249 E.01608
G1 X141.999 Y159.946 E.91965
G1 X141.999 Y160.483 E.01608
G1 X164.233 Y138.249 E.9424
G1 X164.77 Y138.249 E.01608
G1 X141.999 Y161.02 E.96514
G1 X141.999 Y161.556 E.01608
G1 X165.306 Y138.249 E.98788
G1 X165.843 Y138.249 E.01608
G1 X141.999 Y162.093 E1.01063
G1 X141.999 Y162.629 E.01608
G1 X166.379 Y138.249 E1.03337
G1 X166.916 Y138.249 E.01608
G1 X141.83 Y163.336 E1.06331
; WIPE_START
G1 X143.244 Y161.921 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X142.116 Y169.47 Z1.2 F60000
G1 X141.83 Y171.384 Z1.2
G1 Z.8
G1 E.8 F1800
G1 F9488.165
M204 S8000
G1 X155.964 Y157.25 E.59908
G3 X155.328 Y157.349 I-.655 J-2.119 E.01935
G1 X141.999 Y170.678 E.56495
G1 X141.999 Y170.141 E.01608
G1 X154.824 Y157.317 E.54358
G3 X154.389 Y157.215 I.505 J-3.149 E.0134
G1 X141.999 Y169.605 E.52514
G1 X141.999 Y169.068 E.01608
G1 X154.005 Y157.063 E.50888
G3 X153.671 Y156.861 I.542 J-1.276 E.01175
G1 X141.999 Y168.532 E.49469
G1 X141.999 Y167.995 E.01608
G1 X153.362 Y156.632 E.48162
G3 X153.094 Y156.364 I1.143 J-1.409 E.01139
G1 X141.999 Y167.459 E.47026
G1 X141.999 Y166.922 E.01608
G1 X152.871 Y156.051 E.46079
G3 X152.678 Y155.706 I.771 J-.656 E.0119
G1 X141.999 Y166.385 E.45264
G1 X141.999 Y165.849 E.01608
G1 X152.524 Y155.324 E.44609
G1 X152.427 Y154.884 E.01351
G1 X141.999 Y165.312 E.442
G1 X141.999 Y164.776 E.01608
G1 X152.407 Y154.368 E.44112
G3 X152.504 Y153.734 I1.932 J-.028 E.01931
G1 X141.999 Y164.239 E.44525
G1 X141.999 Y163.703 E.01608
G1 X167.453 Y138.249 E1.07886
G1 X167.989 Y138.249 E.01608
G1 X154.481 Y151.758 E.57257
G3 X155.113 Y151.662 I.675 J2.317 E.01923
M73 P60 R6
G1 X168.526 Y138.249 E.5685
G1 X169.062 Y138.249 E.01608
G1 X155.634 Y151.678 E.56919
G3 X156.077 Y151.771 I-.223 J2.163 E.01361
G1 X169.599 Y138.249 E.57313
G1 X170.135 Y138.249 E.01608
G1 X156.459 Y151.925 E.57967
G3 X156.801 Y152.121 I-.35 J1.006 E.01185
G1 X170.672 Y138.249 E.58796
G1 X171.209 Y138.249 E.01608
G1 X157.112 Y152.346 E.59748
G3 X157.383 Y152.612 I-1.13 J1.419 E.01139
G1 X171.745 Y138.249 E.60876
G1 X172.282 Y138.249 E.01608
G1 X157.61 Y152.921 E.62188
G3 X157.812 Y153.256 I-1.004 J.833 E.01176
G1 X172.818 Y138.249 E.63607
G1 X173.355 Y138.249 E.01608
G1 X157.968 Y153.637 E.65221
G1 X158.064 Y154.077 E.0135
G1 X173.891 Y138.249 E.67086
G1 X174.428 Y138.249 E.01608
G1 X158.092 Y154.585 E.69241
G3 X158.01 Y155.204 I-2.51 J-.018 E.01875
G1 X174.965 Y138.249 E.71863
G1 X175.501 Y138.249 E.01608
G1 X141.999 Y171.751 E1.42001
G1 X141.999 Y172.288 E.01608
G1 X176.038 Y138.249 E1.44276
G1 X176.574 Y138.249 E.01608
G1 X141.999 Y172.824 E1.4655
G1 X141.999 Y173.361 E.01608
G1 X177.111 Y138.249 E1.48824
G1 X177.648 Y138.249 E.01608
G1 X141.999 Y173.898 E1.51099
G1 X141.999 Y174.434 E.01608
G1 X178.184 Y138.249 E1.53373
G1 X178.721 Y138.249 E.01608
G1 X141.999 Y174.971 E1.55647
G1 X141.999 Y175.507 E.01608
G1 X179.257 Y138.249 E1.57922
G1 X179.794 Y138.249 E.01608
G1 X141.999 Y176.044 E1.60196
G1 X141.999 Y176.58 E.01608
G1 X180.33 Y138.249 E1.6247
G1 X180.867 Y138.249 E.01608
G1 X141.999 Y177.117 E1.64745
G1 X141.999 Y177.654 E.01608
G1 X181.404 Y138.249 E1.67019
G1 X181.94 Y138.249 E.01608
G1 X141.999 Y178.19 E1.69293
G1 X141.999 Y178.727 E.01608
G1 X182.477 Y138.249 E1.71568
G1 X183.013 Y138.249 E.01608
G1 X141.83 Y179.433 E1.74561
; WIPE_START
G1 X143.244 Y178.019 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X150.796 Y179.123 Z1.2 F60000
G1 X169.928 Y181.92 Z1.2
G1 Z.8
G1 E.8 F1800
G1 F9488.165
M204 S8000
G1 X170.501 Y181.347 E.02429
G1 X170.501 Y180.811 E.01608
G1 X169.561 Y181.751 E.03984
G1 X169.024 Y181.751 E.01608
G1 X170.501 Y180.274 E.06259
G1 X170.501 Y180.207 E.00201
G1 X170.106 Y180.133 E.01205
G1 X168.487 Y181.751 E.06859
G1 X167.951 Y181.751 E.01608
G1 X168.448 Y181.254 E.02105
G3 X167.815 Y181.35 I-.645 J-2.11 E.01926
G1 X167.414 Y181.751 E.01697
G1 X166.878 Y181.751 E.01608
G1 X167.313 Y181.315 E.01845
G3 X166.88 Y181.212 I.528 J-3.178 E.01336
G1 X166.341 Y181.751 E.02282
G1 X165.805 Y181.751 E.01608
G1 X166.497 Y181.059 E.02933
G3 X166.163 Y180.856 I.546 J-1.274 E.01174
G1 X165.268 Y181.751 E.03793
G1 X164.731 Y181.751 E.01608
G1 X165.855 Y180.627 E.04765
G3 X165.588 Y180.357 I1.146 J-1.406 E.01139
G1 X164.195 Y181.751 E.05905
G1 X163.658 Y181.751 E.01608
G1 X165.365 Y180.043 E.07236
G3 X165.169 Y179.704 I1.024 J-.82 E.01181
G1 X163.122 Y181.751 E.08676
G1 X162.585 Y181.751 E.01608
G1 X165.021 Y179.315 E.10325
G1 X164.925 Y178.874 E.01352
G1 X162.048 Y181.751 E.12193
G1 X161.512 Y181.751 E.01608
G1 X164.906 Y178.356 E.14388
G3 X165.008 Y177.718 I2.984 J.147 E.0194
G1 X160.975 Y181.751 E.17092
G1 X160.439 Y181.751 E.01608
G1 X170.501 Y171.689 E.42648
G1 X170.501 Y171.152 E.01608
G1 X159.902 Y181.751 E.44923
G1 X159.366 Y181.751 E.01608
G1 X170.501 Y170.616 E.47197
G1 X170.501 Y170.079 E.01608
G1 X158.829 Y181.751 E.49472
G1 X158.292 Y181.751 E.01608
G1 X170.501 Y169.542 E.51746
G1 X170.501 Y169.006 E.01608
G1 X157.756 Y181.751 E.5402
G1 X157.219 Y181.751 E.01608
G1 X170.501 Y168.469 E.56295
G1 X170.501 Y167.933 E.01608
M73 P61 R6
G1 X156.683 Y181.751 E.58569
G1 X156.146 Y181.751 E.01608
G1 X170.501 Y167.396 E.60843
G1 X170.501 Y166.86 E.01608
G1 X155.609 Y181.751 E.63118
G1 X155.073 Y181.751 E.01608
G1 X170.501 Y166.323 E.65392
G1 X170.501 Y165.786 E.01608
G1 X154.536 Y181.751 E.67666
G1 X154 Y181.751 E.01608
G1 X170.501 Y165.25 E.69941
G1 X170.501 Y164.713 E.01608
G1 X153.463 Y181.751 E.72215
G1 X152.927 Y181.751 E.01608
G1 X170.501 Y164.177 E.74489
G1 X170.501 Y163.64 E.01608
G1 X152.39 Y181.751 E.76764
G1 X151.853 Y181.751 E.01608
G1 X170.501 Y163.103 E.79038
G1 X170.501 Y162.567 E.01608
G1 X151.317 Y181.751 E.81312
G1 X150.78 Y181.751 E.01608
G1 X170.501 Y162.03 E.83587
G1 X170.501 Y161.494 E.01608
G1 X150.244 Y181.751 E.85861
G1 X149.707 Y181.751 E.01608
G1 X170.501 Y160.957 E.88136
G1 X170.501 Y160.421 E.01608
G1 X149.171 Y181.751 E.9041
G1 X148.634 Y181.751 E.01608
G1 X170.501 Y159.884 E.92684
G1 X170.501 Y159.347 E.01608
G1 X148.097 Y181.751 E.94959
G1 X147.561 Y181.751 E.01608
G1 X170.501 Y158.811 E.97233
G1 X170.501 Y158.274 E.01608
G1 X147.024 Y181.751 E.99507
G1 X146.488 Y181.751 E.01608
G1 X170.501 Y157.738 E1.01782
G1 X170.501 Y157.201 E.01608
G1 X145.951 Y181.751 E1.04056
G1 X145.414 Y181.751 E.01608
G1 X170.501 Y156.664 E1.0633
G1 X170.501 Y156.128 E.01608
G1 X144.878 Y181.751 E1.08605
G1 X144.341 Y181.751 E.01608
G1 X170.501 Y155.591 E1.10879
G1 X170.501 Y155.055 E.01608
G1 X143.805 Y181.751 E1.13153
G1 X143.268 Y181.751 E.01608
G1 X170.501 Y154.518 E1.15428
G1 X170.501 Y153.982 E.01608
G1 X142.732 Y181.751 E1.17702
G1 X142.195 Y181.751 E.01608
G1 X170.501 Y153.445 E1.19976
G1 X170.501 Y152.908 E.01608
G1 X141.999 Y181.41 E1.20806
G1 X141.999 Y180.873 E.01608
G1 X170.501 Y152.372 E1.20806
G1 X170.501 Y151.835 E.01608
G1 X141.999 Y180.337 E1.20806
G1 X141.999 Y179.8 E.01608
G1 X183.55 Y138.249 E1.76116
G1 X184.087 Y138.249 E.01608
G1 X171.085 Y151.251 E.55107
G1 X171.622 Y151.251 E.01608
G1 X184.623 Y138.249 E.55107
G1 X185.16 Y138.249 E.01608
G1 X172.158 Y151.251 E.55107
G1 X172.695 Y151.251 E.01608
G1 X185.696 Y138.249 E.55107
G1 X186.233 Y138.249 E.01608
G1 X173.232 Y151.251 E.55107
G1 X173.768 Y151.251 E.01608
G1 X186.769 Y138.249 E.55107
G1 X187.306 Y138.249 E.01608
G1 X174.305 Y151.251 E.55107
G1 X174.841 Y151.251 E.01608
G1 X187.843 Y138.249 E.55107
G1 X188.379 Y138.249 E.01608
G1 X175.378 Y151.251 E.55107
G1 X175.914 Y151.251 E.01608
G1 X188.916 Y138.249 E.55107
G1 X189.452 Y138.249 E.01608
G1 X176.451 Y151.251 E.55107
G1 X176.988 Y151.251 E.01608
G1 X189.989 Y138.249 E.55107
G1 X190.525 Y138.249 E.01608
G1 X177.524 Y151.251 E.55107
G1 X178.061 Y151.251 E.01608
G1 X191.062 Y138.249 E.55107
G1 X191.599 Y138.249 E.01608
M73 P62 R6
G1 X178.597 Y151.251 E.55107
G1 X179.134 Y151.251 E.01608
G1 X192.135 Y138.249 E.55107
G1 X192.672 Y138.249 E.01608
G1 X179.671 Y151.251 E.55107
G1 X180.207 Y151.251 E.01608
G1 X193.208 Y138.249 E.55107
G1 X193.745 Y138.249 E.01608
G1 X180.744 Y151.251 E.55107
G1 X181.28 Y151.251 E.01608
G1 X194.282 Y138.249 E.55107
G1 X194.818 Y138.249 E.01608
G1 X181.817 Y151.251 E.55107
G1 X182.353 Y151.251 E.01608
G1 X195.355 Y138.249 E.55107
G1 X195.891 Y138.249 E.01608
G1 X182.89 Y151.251 E.55107
G1 X183.427 Y151.251 E.01608
G1 X196.428 Y138.249 E.55107
G1 X196.964 Y138.249 E.01608
G1 X183.963 Y151.251 E.55107
G1 X184.5 Y151.251 E.01608
G1 X197.501 Y138.249 E.55107
G1 X198.038 Y138.249 E.01608
G1 X185.036 Y151.251 E.55107
G1 X185.573 Y151.251 E.01608
G1 X198.574 Y138.249 E.55107
G1 X199.111 Y138.249 E.01608
G1 X186.11 Y151.251 E.55107
G1 X186.646 Y151.251 E.01608
G1 X199.647 Y138.249 E.55107
G1 X200.184 Y138.249 E.01608
G1 X187.183 Y151.251 E.55107
G1 X187.719 Y151.251 E.01608
G1 X200.721 Y138.249 E.55107
G1 X201.257 Y138.249 E.01608
G1 X188.256 Y151.251 E.55107
G1 X188.792 Y151.251 E.01608
G1 X201.794 Y138.249 E.55107
G1 X202.33 Y138.249 E.01608
G1 X189.329 Y151.251 E.55107
G1 X189.866 Y151.251 E.01608
G1 X202.867 Y138.249 E.55107
G1 X203.403 Y138.249 E.01608
G1 X190.402 Y151.251 E.55107
G1 X190.939 Y151.251 E.01608
G1 X203.94 Y138.249 E.55107
G1 X204.169 Y138.249 E.00686
G1 X204.192 Y138.534 E.00857
G1 X191.475 Y151.251 E.53899
G1 X192.012 Y151.251 E.01608
G1 X202.453 Y140.809 E.44257
G2 X202.402 Y141.397 I2.493 J.513 E.01772
G1 X192.548 Y151.251 E.41765
G1 X193.085 Y151.251 E.01608
G1 X202.468 Y141.868 E.3977
G2 X202.58 Y142.292 I1.533 J-.179 E.0132
G1 X193.622 Y151.251 E.37972
G1 X194.158 Y151.251 E.01608
G1 X202.746 Y142.663 E.36401
G1 X202.962 Y142.983 E.01159
G1 X194.695 Y151.251 E.35041
G1 X195.231 Y151.251 E.01608
G1 X203.202 Y143.28 E.33785
G2 X203.482 Y143.537 I1.365 J-1.207 E.0114
G1 X195.768 Y151.251 E.32697
G1 X196.305 Y151.251 E.01608
G1 X203.802 Y143.753 E.31778
G2 X204.16 Y143.932 I1.115 J-1.787 E.01201
M73 P62 R5
G1 X196.841 Y151.251 E.31021
G1 X197.378 Y151.251 E.01608
G1 X204.565 Y144.064 E.30463
G1 X205.023 Y144.142 E.01393
G1 X197.914 Y151.251 E.3013
G1 X198.451 Y151.251 E.01608
G1 X205.568 Y144.133 E.30167
G2 X206.297 Y143.941 I-.114 J-1.909 E.02276
G1 X198.987 Y151.251 E.30984
G1 X199.524 Y151.251 E.01608
G1 X207.805 Y142.97 E.35098
G1 X208.001 Y143.008 E.00599
G1 X208.001 Y143.311 E.00906
G1 X200.061 Y151.251 E.33655
G1 X200.597 Y151.251 E.01608
G1 X208.001 Y143.847 E.3138
G1 X208.001 Y144.384 E.01608
G1 X201.134 Y151.251 E.29106
G1 X201.67 Y151.251 E.01608
G1 X208.001 Y144.92 E.26832
G1 X208.001 Y145.457 E.01608
G1 X202.207 Y151.251 E.24557
G1 X202.744 Y151.251 E.01608
G1 X208.001 Y145.994 E.22283
G1 X208.001 Y146.53 E.01608
G1 X203.28 Y151.251 E.20008
G1 X203.817 Y151.251 E.01608
G1 X208.001 Y147.067 E.17734
G1 X208.001 Y147.603 E.01608
G1 X204.353 Y151.251 E.1546
G1 X204.89 Y151.251 E.01608
G1 X208.001 Y148.14 E.13185
G1 X208.001 Y148.676 E.01608
G1 X205.426 Y151.251 E.10911
G1 X205.963 Y151.251 E.01608
G1 X208.001 Y149.213 E.08637
G1 X208.001 Y149.75 E.01608
G1 X206.5 Y151.251 E.06362
G1 X207.036 Y151.251 E.01608
G1 X208.001 Y150.286 E.04088
G1 X208.001 Y150.823 E.01608
G1 X207.403 Y151.42 E.02533
; WIPE_START
G1 X208.001 Y150.823 E-.32113
G1 X208.001 Y150.286 E-.2039
G1 X207.563 Y150.723 E-.23497
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X207.876 Y143.097 Z1.2 F60000
G1 X207.895 Y142.648 Z1.2
G1 Z.8
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.413165
G1 F9723.296
M204 S8000
G1 X207.947 Y142.379 E.00801
; LINE_WIDTH: 0.385577
G1 F10506.142
G1 X207.971 Y142.237 E.0039
; LINE_WIDTH: 0.337953
G1 F12202.056
G1 X207.995 Y142.095 E.00336
; LINE_WIDTH: 0.312178
G1 F13370.092
G1 X207.997 Y142.081 E.0003
; LINE_WIDTH: 0.294368
G1 F14317.096
G1 X208.012 Y141.942 E.00277
; LINE_WIDTH: 0.261644
G1 F15000
G1 X208.029 Y141.794 E.00258
; LINE_WIDTH: 0.215053
G1 X208.051 Y141.254 E.00734
G1 X208.041 Y140.961 E.004
; LINE_WIDTH: 0.244021
G1 X208.019 Y140.698 E.00418
; LINE_WIDTH: 0.284154
G1 F14923.283
G1 X208.001 Y140.563 E.0026
; LINE_WIDTH: 0.321711
G1 F12912.894
G1 X207.981 Y140.413 E.00332
; LINE_WIDTH: 0.364832
G1 F11183.206
G1 X207.958 Y140.288 E.00325
; LINE_WIDTH: 0.424736
G1 F9428.647
G1 X207.933 Y140.151 E.00419
G1 X207.657 Y140.025 E.00915
; WIPE_START
G1 X207.933 Y140.151 E-.52135
G1 X207.958 Y140.288 E-.23865
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X206.365 Y138.623 Z1.2 F60000
G1 Z.8
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F9547.299
M204 S8000
G1 X206.602 Y138.723 E.00766
G3 X207.486 Y139.474 I-1.219 J2.333 E.03485
G1 X207.624 Y139.374 E.00505
G1 X207.942 Y139.49 E.01008
G1 X207.942 Y138.308 E.0352
G1 X206.387 Y138.308 E.04631
G1 X206.369 Y138.564 E.00762
; WIPE_START
G1 X206.387 Y138.308 E-.09724
G1 X207.942 Y138.308 E-.59083
G1 X207.942 Y138.498 E-.07194
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X207.513 Y138.712 Z1.2 F60000
G1 Z.8
G1 E.8 F1800
; LINE_WIDTH: 0.59258
G1 F6549.504
M204 S8000
G2 X207.517 Y138.824 I-.03 J.057 E.01173
; WIPE_START
G1 X207.444 Y138.831 E-.19965
G1 X207.41 Y138.772 E-.18679
G1 X207.444 Y138.712 E-.18679
G1 X207.513 Y138.712 E-.18678
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X205.988 Y138.388 Z1.2 F60000
G1 Z.8
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.521737
G1 F7518.536
M204 S8000
G2 X204.514 Y138.39 I-.726 J6.759 E.05586
; WIPE_START
G1 X205.227 Y138.349 E-.36734
G1 X205.988 Y138.388 E-.39266
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X200.464 Y143.654 Z1.2 F60000
G1 X170.67 Y172.056 Z1.2
G1 Z.8
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42234
G1 F9488.165
M204 S8000
G1 X166.964 Y175.762 E.15711
G3 X167.601 Y175.662 I.696 J2.344 E.01938
G1 X170.501 Y172.762 E.12292
G1 X170.501 Y173.298 E.01608
G1 X168.123 Y175.677 E.1008
G3 X168.567 Y175.769 I-.217 J2.166 E.01363
G1 X170.501 Y173.835 E.08196
G1 X170.501 Y174.372 E.01608
G1 X168.951 Y175.922 E.0657
G3 X169.293 Y176.116 I-.346 J1.009 E.01187
G1 X170.501 Y174.908 E.05119
G1 X170.501 Y175.445 E.01608
G1 X169.602 Y176.343 E.03807
G1 X169.877 Y176.605 E.01137
G1 X170.501 Y175.981 E.02643
G1 X170.501 Y176.518 E.01608
G1 X170.192 Y176.826 E.01307
M204 S10000
G1 X170.153 Y177.227 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.436345
G1 F9150.428
M204 S8000
G1 X170.433 Y177.351 E.00952
G1 X170.437 Y177.371 E.00063
; LINE_WIDTH: 0.404533
G1 F9955.395
G1 X170.462 Y177.51 E.00402
; LINE_WIDTH: 0.355719
G1 F11508.991
G1 X170.486 Y177.648 E.00348
; LINE_WIDTH: 0.313424
G1 F13308.518
G1 X170.504 Y177.784 E.00292
; LINE_WIDTH: 0.280604
G1 F15000
G1 X170.519 Y177.906 E.00231
; LINE_WIDTH: 0.243527
G1 X170.541 Y178.16 E.00404
; LINE_WIDTH: 0.214718
G1 X170.551 Y178.447 E.0039
G1 X170.53 Y178.984 E.0073
; LINE_WIDTH: 0.25982
G1 X170.513 Y179.135 E.0026
; LINE_WIDTH: 0.292952
G1 F14398.179
G1 X170.497 Y179.275 E.00279
; LINE_WIDTH: 0.331635
G1 F12469.049
G1 X170.474 Y179.418 E.00328
; LINE_WIDTH: 0.376092
G1 F10805.24
G1 X170.453 Y179.546 E.00344
; LINE_WIDTH: 0.400487
G1 F10068.065
G1 X170.396 Y179.848 E.00868
; CHANGE_LAYER
; Z_HEIGHT: 1
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F10068.065
G1 X170.453 Y179.546 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 5/54
; update layer progress
M73 L5
M991 S0 P4 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z1.2 I1.107 J-.506 P1  F60000
G1 X153.935 Y143.377 Z1.2
G1 Z1
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X153.635 Y143.317 E.00985
G3 X154.028 Y139.201 I.613 J-2.018 E.186
G1 X154.239 Y139.19 E.00677
G3 X154.061 Y143.4 I.009 J2.109 E.21933
G1 X153.994 Y143.388 E.00221
; COOLING_NODE: 0
M204 S10000
G1 X154.012 Y142.979 F60000
G1 F8843.478
M204 S8000
G1 X153.753 Y142.927 E.0085
G3 X154.071 Y139.607 I.495 J-1.628 E.15005
G1 X154.241 Y139.597 E.00547
G3 X154.099 Y142.994 I.007 J1.702 E.17696
G1 X154.071 Y142.989 E.00089
; COOLING_NODE: 0
M204 S250
G1 X154.087 Y142.596 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X153.868 Y142.552 E.00667
G3 X154.113 Y139.997 I.382 J-1.252 E.10692
G1 X154.244 Y139.99 E.00391
G3 X154.146 Y142.604 I.005 J1.309 E.12575
; COOLING_NODE: 0
; WIPE_START
M204 S8000
G1 X153.868 Y142.552 E-.10784
G1 X153.635 Y142.457 E-.09553
G1 X153.425 Y142.318 E-.09579
G1 X153.231 Y142.124 E-.10385
G1 X153.083 Y141.896 E-.10353
G1 X152.991 Y141.662 E-.09539
G1 X152.945 Y141.42 E-.09355
G1 X152.946 Y141.251 E-.06452
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X156.195 Y148.157 Z1.4 F60000
G1 X169.773 Y177.018 Z1.4
G1 Z1
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X169.952 Y177.286 E.01036
G3 X167.485 Y175.996 I-2.205 J1.213 E.41357
G1 X167.736 Y175.982 E.00806
G3 X169.681 Y176.888 I.011 J2.516 E.07127
G1 X169.738 Y176.969 E.00319
; COOLING_NODE: 0
M204 S10000
G1 X169.438 Y177.247 F60000
G1 F8843.478
M204 S8000
G1 X169.595 Y177.482 E.00909
G3 X167.528 Y176.401 I-1.847 J1.017 E.34665
G1 X167.738 Y176.39 E.00677
G3 X169.368 Y177.149 I.009 J2.109 E.05971
G1 X169.403 Y177.198 E.00195
; COOLING_NODE: 0
M204 S10000
G1 X169.103 Y177.476 F60000
G1 F8843.478
M204 S8000
G1 X169.239 Y177.677 E.00781
G3 X167.571 Y176.807 I-1.49 J.822 E.27973
G1 X167.741 Y176.797 E.00547
G3 X169.055 Y177.409 I.007 J1.702 E.04814
G1 X169.068 Y177.427 E.00072
; COOLING_NODE: 1
M204 S250
G1 X168.781 Y177.697 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X168.895 Y177.866 E.00608
G3 X167.613 Y177.197 I-1.146 J.633 E.19941
G1 X167.744 Y177.19 E.0039
G3 X168.745 Y177.649 I.005 J1.309 E.03385
; COOLING_NODE: 1
; WIPE_START
M204 S8000
G1 X168.895 Y177.866 E-.10038
G1 X169.003 Y178.117 E-.10371
G1 X169.055 Y178.38 E-.1019
G1 X169.053 Y178.636 E-.09753
G1 X169.003 Y178.884 E-.09594
G1 X168.896 Y179.134 E-.10348
G1 X168.754 Y179.342 E-.09554
G1 X168.639 Y179.455 E-.06152
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X165.004 Y172.744 Z1.4 F60000
G1 X153.958 Y152.349 Z1.4
G1 Z1
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
M73 P63 R5
G1 X154.055 Y152.282 E.00379
G3 X154.985 Y151.996 I1.192 J2.216 E.0315
G1 X155.236 Y151.982 E.00807
G3 X153.66 Y152.546 I.011 J2.516 E.45355
G1 X153.908 Y152.382 E.00955
; COOLING_NODE: 1
M204 S10000
G1 X154.183 Y152.686 F60000
G1 F8843.478
M204 S8000
G1 X154.249 Y152.641 E.00256
G3 X155.028 Y152.401 I.999 J1.858 E.02639
G1 X155.238 Y152.39 E.00677
G3 X153.918 Y152.862 I.009 J2.109 E.38014
G1 X154.133 Y152.719 E.0083
; COOLING_NODE: 1
M204 S10000
G1 X154.408 Y153.024 F60000
G1 F8843.478
M204 S8000
G1 X154.443 Y153 E.00134
G3 X155.071 Y152.807 I.806 J1.499 E.02129
G1 X155.241 Y152.797 E.00547
G3 X154.176 Y153.178 I.007 J1.702 E.30674
G1 X154.358 Y153.057 E.00704
; COOLING_NODE: 2
M204 S250
G1 X154.625 Y153.349 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X154.629 Y153.346 E.00016
G3 X155.113 Y153.197 I.62 J1.153 E.01516
G1 X155.244 Y153.19 E.0039
G3 X154.425 Y153.482 I.005 J1.309 E.21865
G1 X154.575 Y153.382 E.00538
; COOLING_NODE: 2
; WIPE_START
M204 S8000
G1 X154.629 Y153.346 E-.02479
G1 X154.866 Y153.247 E-.09742
G1 X155.113 Y153.197 E-.09573
G1 X155.244 Y153.19 E-.04981
G1 X155.499 Y153.214 E-.09741
G1 X155.741 Y153.285 E-.09603
G1 X155.982 Y153.413 E-.10371
G1 X156.091 Y153.496 E-.05187
G1 X156.254 Y153.659 E-.08761
G1 X156.337 Y153.779 E-.05561
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X163.812 Y152.237 Z1.4 F60000
G1 X204.835 Y143.773 Z1.4
G1 Z1
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X204.51 Y143.705 E.01069
G3 X204.985 Y138.796 I.737 J-2.406 E.22176
G1 X205.236 Y138.782 E.00807
G3 X204.989 Y143.802 I.011 J2.517 E.26287
G1 X204.894 Y143.784 E.0031
; COOLING_NODE: 2
M204 S10000
G1 X204.917 Y143.376 F60000
G1 F8843.478
M204 S8000
G1 X204.63 Y143.316 E.00941
G3 X205.028 Y139.201 I.617 J-2.017 E.18587
G1 X205.239 Y139.19 E.00677
G3 X205.031 Y143.397 I.009 J2.109 E.22033
G1 X204.976 Y143.387 E.00182
; COOLING_NODE: 2
M204 S10000
G1 X204.998 Y142.978 F60000
G1 F8843.478
M204 S8000
G1 X204.751 Y142.927 E.00812
G3 X205.071 Y139.607 I.498 J-1.627 E.14998
G1 X205.241 Y139.597 E.00547
G3 X205.073 Y142.992 I.007 J1.702 E.1778
G1 X205.057 Y142.989 E.00053
; COOLING_NODE: 3
M204 S250
G1 X205.076 Y142.595 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X204.867 Y142.552 E.00637
G3 X205.113 Y139.997 I.383 J-1.252 E.10691
G1 X205.244 Y139.99 E.00391
G3 X205.135 Y142.604 I.005 J1.31 E.1261
; COOLING_NODE: 3
; WIPE_START
M204 S8000
G1 X204.867 Y142.552 E-.10403
G1 X204.616 Y142.446 E-.10341
G1 X204.413 Y142.308 E-.0935
G1 X204.245 Y142.141 E-.08965
G1 X204.104 Y141.935 E-.09509
G1 X203.997 Y141.683 E-.10386
G1 X203.947 Y141.436 E-.09591
G1 X203.945 Y141.24 E-.07456
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X196.374 Y142.207 Z1.4 F60000
G1 X151.666 Y147.916 Z1.4
G1 Z1
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X151.666 Y142.147 E.18553
G1 X151.87 Y142.112 E.00665
G2 X151.87 Y140.488 I2.375 J-.812 E.45404
G1 X151.666 Y140.454 E.00665
G1 X151.666 Y137.916 E.0816
G1 X208.334 Y137.916 E1.82222
G1 X208.334 Y151.584 E.4395
G1 X170.834 Y151.584 E1.20586
G1 X170.834 Y182.084 E.98077
G1 X141.666 Y182.084 E.93792
G1 X141.666 Y147.916 E1.09871
G1 X151.606 Y147.916 E.31963
; COOLING_NODE: 3
M204 S10000
G1 X151.259 Y147.509 F60000
G1 F8843.478
M204 S8000
G1 X151.259 Y137.509 E.32156
G1 X208.741 Y137.509 E1.8484
G1 X208.741 Y151.991 E.46568
G1 X171.241 Y151.991 E1.20586
G1 X171.241 Y182.491 E.98077
G1 X141.259 Y182.491 E.9641
G1 X141.259 Y147.509 E1.12489
G1 X151.199 Y147.509 E.31963
; COOLING_NODE: 3
M204 S10000
G1 X150.852 Y147.102 F60000
G1 F8843.478
M204 S8000
G1 X150.852 Y137.102 E.32156
G1 X209.148 Y137.102 E1.87458
G1 X209.148 Y152.398 E.49186
G1 X171.648 Y152.398 E1.20586
G1 X171.648 Y182.898 E.98077
G1 X140.852 Y182.898 E.99028
G1 X140.852 Y147.102 E1.15107
G1 X150.792 Y147.102 E.31963
; COOLING_NODE: 4
M204 S250
G1 X150.46 Y146.71 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X150.46 Y136.71 E.29787
G1 X209.54 Y136.71 E1.75979
G1 X209.54 Y152.79 E.47897
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X172.04 Y152.79 E1.117
G1 X172.04 Y183.29 E.90849
G1 X140.46 Y183.29 E.94066
G1 X140.46 Y146.71 E1.08959
G1 X150.4 Y146.71 E.29608
; WIPE_START
M204 S8000
G1 X150.412 Y144.71 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X151.83 Y147.307 Z1.4 F60000
G1 Z1
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42102
G1 F9521.29
M204 S8000
G1 X156.432 Y151.909 E.19438
G2 X155.68 Y151.692 I-1.089 J2.363 E.02346
G1 X151.999 Y148.011 E.15546
G1 X151.999 Y148.249 E.00712
G1 X151.703 Y148.249 E.00885
G1 X155.115 Y151.662 E.14413
G2 X154.645 Y151.726 I-.073 J1.223 E.01428
G1 X151.168 Y148.249 E.14684
G1 X150.633 Y148.249 E.01597
G1 X154.226 Y151.842 E.15175
G2 X153.862 Y152.012 I1.095 J2.816 E.01202
G1 X150.099 Y148.249 E.15894
G1 X149.564 Y148.249 E.01597
G1 X153.541 Y152.226 E.16799
G2 X153.249 Y152.469 I.689 J1.124 E.01138
G1 X149.029 Y148.249 E.17824
G1 X148.495 Y148.249 E.01597
G1 X153 Y152.755 E.19031
G1 X152.785 Y153.075 E.01151
G1 X147.96 Y148.249 E.20382
G1 X147.425 Y148.249 E.01597
G1 X152.615 Y153.439 E.21921
G2 X152.479 Y153.838 I1.306 J.668 E.01263
G1 X146.89 Y148.249 E.23605
G1 X146.356 Y148.249 E.01597
G1 X152.409 Y154.302 E.25566
G2 X152.425 Y154.853 I2.798 J.194 E.01648
G1 X145.821 Y148.249 E.27893
M73 P64 R5
G1 X145.286 Y148.249 E.01597
G1 X152.61 Y155.573 E.30933
G2 X153.065 Y156.333 I2.602 J-1.042 E.02658
G1 X153.449 Y156.712 E.0161
G2 X154.177 Y157.14 I1.981 J-2.536 E.0253
G1 X170.501 Y173.464 E.68948
G1 X170.501 Y172.929 E.01597
G1 X154.898 Y157.326 E.65905
G2 X155.448 Y157.341 I.356 J-2.856 E.01646
G1 X170.501 Y172.394 E.63581
G1 X170.501 Y171.86 E.01597
G1 X155.906 Y157.264 E.61647
G2 X156.311 Y157.135 I-.139 J-1.132 E.01278
G1 X170.501 Y171.325 E.59936
G1 X170.501 Y170.79 E.01597
G1 X156.676 Y156.965 E.58394
G2 X156.996 Y156.751 I-.876 J-1.66 E.01154
G1 X170.501 Y170.255 E.5704
G1 X170.501 Y169.721 E.01597
G1 X157.281 Y156.501 E.55839
G2 X157.524 Y156.209 I-.904 J-1.001 E.01138
G1 X170.501 Y169.186 E.54812
G1 X170.501 Y168.651 E.01597
G1 X157.739 Y155.889 E.53905
G2 X157.908 Y155.524 I-3.208 J-1.708 E.01203
G1 X170.501 Y168.117 E.5319
G1 X170.501 Y167.582 E.01597
G1 X158.024 Y155.105 E.52699
G2 X158.094 Y154.641 I-1.509 J-.466 E.01408
G1 X170.501 Y167.047 E.52402
G1 X170.501 Y166.512 E.01597
G1 X158.067 Y154.078 E.52519
G2 X157.843 Y153.32 I-2.289 J.263 E.02373
G1 X170.501 Y165.978 E.53464
G1 X170.501 Y165.443 E.01597
G1 X151.999 Y146.942 E.78147
G1 X151.999 Y146.407 E.01597
G1 X170.501 Y164.908 E.78147
G1 X170.501 Y164.374 E.01597
G1 X151.999 Y145.872 E.78147
G1 X151.999 Y145.338 E.01597
G1 X170.501 Y163.839 E.78147
G1 X170.501 Y163.304 E.01597
G1 X151.999 Y144.803 E.78147
G1 X151.999 Y144.268 E.01597
G1 X170.501 Y162.769 E.78147
G1 X170.501 Y162.235 E.01597
G1 X151.999 Y143.733 E.78147
G1 X151.999 Y143.463 E.00809
G1 X152.138 Y143.338 E.00558
G1 X170.501 Y161.7 E.7756
G1 X170.501 Y161.165 E.01597
G1 X153.326 Y143.991 E.72543
G2 X153.998 Y144.128 I.784 J-2.121 E.02057
G1 X170.501 Y160.631 E.69704
G1 X170.501 Y160.096 E.01597
G1 X154.541 Y144.136 E.6741
G2 X154.985 Y144.045 I-.37 J-2.916 E.01353
G1 X170.501 Y159.561 E.65537
G1 X170.501 Y159.026 E.01597
G1 X155.388 Y143.914 E.63834
G2 X155.734 Y143.725 I-.47 J-1.275 E.01181
G1 X170.501 Y158.492 E.62372
G1 X170.501 Y157.957 E.01597
G1 X156.052 Y143.508 E.61031
G1 X156.323 Y143.245 E.01129
G1 X170.501 Y157.422 E.59884
G1 X170.501 Y156.888 E.01597
G1 X156.562 Y142.949 E.58874
G2 X156.772 Y142.625 I-.995 J-.876 E.01159
G1 X170.501 Y156.353 E.57986
G1 X170.501 Y155.818 E.01597
G1 X156.934 Y142.252 E.57302
G2 X157.049 Y141.832 I-2.937 J-1.031 E.01301
G1 X170.501 Y155.283 E.56816
G1 X170.501 Y154.749 E.01597
G1 X157.099 Y141.347 E.56605
G1 X157.051 Y140.765 E.01746
G1 X170.501 Y154.214 E.56807
G1 X170.501 Y153.679 E.01597
G1 X155.315 Y138.493 E.64143
G1 X155.332 Y138.249 E.00731
G1 X155.605 Y138.249 E.00817
G1 X170.501 Y153.145 E.62915
G1 X170.501 Y152.61 E.01597
G1 X156.14 Y138.249 E.60657
G1 X156.675 Y138.249 E.01597
G1 X170.501 Y152.075 E.58398
G1 X170.501 Y151.54 E.01597
G1 X157.21 Y138.249 E.56139
G1 X157.744 Y138.249 E.01597
G1 X170.746 Y151.251 E.54916
G1 X171.28 Y151.251 E.01597
G1 X158.279 Y138.249 E.54916
G1 X158.814 Y138.249 E.01597
G1 X171.815 Y151.251 E.54916
G1 X172.35 Y151.251 E.01597
G1 X159.348 Y138.249 E.54916
G1 X159.883 Y138.249 E.01597
G1 X172.884 Y151.251 E.54916
G1 X173.419 Y151.251 E.01597
G1 X160.418 Y138.249 E.54915
G1 X160.953 Y138.249 E.01597
G1 X173.954 Y151.251 E.54916
G1 X174.489 Y151.251 E.01597
G1 X161.487 Y138.249 E.54916
G1 X162.022 Y138.249 E.01597
G1 X175.023 Y151.251 E.54916
G1 X175.558 Y151.251 E.01597
G1 X162.557 Y138.249 E.54916
G1 X163.091 Y138.249 E.01597
G1 X176.093 Y151.251 E.54915
G1 X176.627 Y151.251 E.01597
G1 X163.626 Y138.249 E.54916
G1 X164.161 Y138.249 E.01597
G1 X177.162 Y151.251 E.54916
G1 X177.697 Y151.251 E.01597
G1 X164.696 Y138.249 E.54916
G1 X165.23 Y138.249 E.01597
G1 X178.232 Y151.251 E.54916
G1 X178.766 Y151.251 E.01597
G1 X165.765 Y138.249 E.54916
G1 X166.3 Y138.249 E.01597
G1 X179.301 Y151.251 E.54916
G1 X179.836 Y151.251 E.01597
M73 P65 R5
G1 X166.834 Y138.249 E.54915
G1 X167.369 Y138.249 E.01597
G1 X180.37 Y151.251 E.54916
G1 X180.905 Y151.251 E.01597
G1 X167.904 Y138.249 E.54916
G1 X168.439 Y138.249 E.01597
G1 X181.44 Y151.251 E.54916
G1 X181.975 Y151.251 E.01597
G1 X168.973 Y138.249 E.54916
G1 X169.508 Y138.249 E.01597
G1 X182.509 Y151.251 E.54915
G1 X183.044 Y151.251 E.01597
G1 X170.043 Y138.249 E.54916
G1 X170.577 Y138.249 E.01597
G1 X183.579 Y151.251 E.54916
G1 X184.113 Y151.251 E.01597
G1 X171.112 Y138.249 E.54916
G1 X171.647 Y138.249 E.01597
G1 X184.648 Y151.251 E.54916
G1 X185.183 Y151.251 E.01597
G1 X172.182 Y138.249 E.54916
G1 X172.716 Y138.249 E.01597
G1 X185.718 Y151.251 E.54916
G1 X186.252 Y151.251 E.01597
G1 X173.251 Y138.249 E.54915
G1 X173.786 Y138.249 E.01597
G1 X186.787 Y151.251 E.54916
G1 X187.322 Y151.251 E.01597
G1 X174.32 Y138.249 E.54916
G1 X174.855 Y138.249 E.01597
G1 X187.856 Y151.251 E.54916
G1 X188.391 Y151.251 E.01597
G1 X175.39 Y138.249 E.54916
G1 X175.925 Y138.249 E.01597
G1 X188.926 Y151.251 E.54915
G1 X189.461 Y151.251 E.01597
G1 X176.459 Y138.249 E.54916
G1 X176.994 Y138.249 E.01597
G1 X189.995 Y151.251 E.54916
G1 X190.53 Y151.251 E.01597
G1 X177.529 Y138.249 E.54916
G1 X178.063 Y138.249 E.01597
G1 X191.065 Y151.251 E.54916
G1 X191.599 Y151.251 E.01597
G1 X178.598 Y138.249 E.54916
G1 X179.133 Y138.249 E.01597
G1 X192.134 Y151.251 E.54916
G1 X192.669 Y151.251 E.01597
G1 X179.668 Y138.249 E.54916
G1 X180.202 Y138.249 E.01597
G1 X193.204 Y151.251 E.54916
G1 X193.738 Y151.251 E.01597
G1 X180.737 Y138.249 E.54916
G1 X181.272 Y138.249 E.01597
G1 X194.273 Y151.251 E.54916
G1 X194.808 Y151.251 E.01597
G1 X181.806 Y138.249 E.54916
G1 X182.341 Y138.249 E.01597
G1 X195.342 Y151.251 E.54916
G1 X195.877 Y151.251 E.01597
G1 X182.876 Y138.249 E.54916
G1 X183.411 Y138.249 E.01597
G1 X196.412 Y151.251 E.54916
G1 X196.947 Y151.251 E.01597
G1 X183.945 Y138.249 E.54916
G1 X184.48 Y138.249 E.01597
G1 X197.481 Y151.251 E.54916
G1 X198.016 Y151.251 E.01597
G1 X185.015 Y138.249 E.54916
G1 X185.549 Y138.249 E.01597
G1 X198.551 Y151.251 E.54916
G1 X199.085 Y151.251 E.01597
G1 X186.084 Y138.249 E.54916
G1 X186.619 Y138.249 E.01597
G1 X199.62 Y151.251 E.54916
G1 X200.155 Y151.251 E.01597
G1 X187.154 Y138.249 E.54916
G1 X187.688 Y138.249 E.01597
G1 X200.69 Y151.251 E.54916
G1 X201.224 Y151.251 E.01597
G1 X188.223 Y138.249 E.54916
G1 X188.758 Y138.249 E.01597
G1 X201.759 Y151.251 E.54916
G1 X202.294 Y151.251 E.01597
G1 X189.292 Y138.249 E.54916
G1 X189.827 Y138.249 E.01597
G1 X202.828 Y151.251 E.54916
G1 X203.363 Y151.251 E.01597
G1 X190.362 Y138.249 E.54916
G1 X190.897 Y138.249 E.01597
G1 X203.898 Y151.251 E.54916
G1 X204.433 Y151.251 E.01597
G1 X191.431 Y138.249 E.54916
G1 X191.966 Y138.249 E.01597
G1 X204.967 Y151.251 E.54916
G1 X205.502 Y151.251 E.01597
G1 X192.501 Y138.249 E.54916
G1 X193.035 Y138.249 E.01597
G1 X206.037 Y151.251 E.54916
G1 X206.571 Y151.251 E.01597
G1 X193.57 Y138.249 E.54916
G1 X194.105 Y138.249 E.01597
G1 X207.106 Y151.251 E.54916
G1 X207.641 Y151.251 E.01597
G1 X194.64 Y138.249 E.54916
G1 X195.174 Y138.249 E.01597
G1 X208.001 Y151.076 E.54177
G1 X208.001 Y150.541 E.01597
G1 X195.709 Y138.249 E.51918
G1 X196.244 Y138.249 E.01597
G1 X208.001 Y150.006 E.4966
G1 X208.001 Y149.472 E.01597
G1 X196.778 Y138.249 E.47401
G1 X197.313 Y138.249 E.01597
G1 X208.001 Y148.937 E.45142
G1 X208.001 Y148.402 E.01597
G1 X197.848 Y138.249 E.42884
G1 X198.383 Y138.249 E.01597
G1 X208.001 Y147.867 E.40625
G1 X208.001 Y147.333 E.01597
G1 X204.767 Y144.099 E.13658
G1 X204.954 Y144.137 E.0057
G1 X205.343 Y144.14 E.0116
G1 X208.001 Y146.798 E.11227
G1 X208.001 Y146.263 E.01597
G1 X205.828 Y144.091 E.09176
G2 X206.242 Y143.97 I-.372 J-2.034 E.01289
G1 X208.001 Y145.729 E.07429
G1 X208.001 Y145.194 E.01597
G1 X206.611 Y143.805 E.05868
G1 X206.933 Y143.591 E.01152
G1 X208.001 Y144.659 E.04511
G1 X208.001 Y144.124 E.01597
G1 X207.221 Y143.345 E.03293
G2 X207.48 Y143.069 I-.585 J-.809 E.01137
G1 X208.17 Y143.759 E.02916
M204 S10000
G1 X208.17 Y143.225 F60000
G1 F9521.29
M204 S8000
G1 X207.851 Y142.906 E.01348
M204 S10000
G1 X207.656 Y142.577 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.432565
G1 F9239.185
M204 S8000
G1 X207.935 Y142.438 E.00962
; LINE_WIDTH: 0.410114
G1 F9804.083
G1 X207.958 Y142.312 E.00371
; LINE_WIDTH: 0.364558
G1 F11192.708
G1 X207.981 Y142.186 E.00325
; LINE_WIDTH: 0.320977
G1 F12947.017
G1 X208.001 Y142.033 E.00339
; LINE_WIDTH: 0.28254
G1 F15000
G1 X208.02 Y141.894 E.00265
; LINE_WIDTH: 0.240401
G1 X208.043 Y141.597 E.00464
; LINE_WIDTH: 0.208761
G1 X208.044 Y141.012 E.00767
; LINE_WIDTH: 0.238944
G1 X208.021 Y140.716 E.00459
; LINE_WIDTH: 0.28136
G1 X208.001 Y140.566 E.00285
; LINE_WIDTH: 0.319352
G1 F13023.124
G1 X207.983 Y140.428 E.00305
; LINE_WIDTH: 0.361536
G1 F11298.88
G1 X207.959 Y140.292 E.00348
; LINE_WIDTH: 0.408097
G1 F9858.231
G1 X207.937 Y140.17 E.00357
; LINE_WIDTH: 0.437453
G1 F9124.719
G1 X207.889 Y139.956 E.00682
; WIPE_START
G1 X207.937 Y140.17 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X206.365 Y138.625 Z1.4 F60000
G1 Z1
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F9547.299
M204 S8000
G1 X206.625 Y138.736 E.00844
G1 X207.067 Y139.026 E.01574
G1 X207.469 Y139.418 E.01672
G1 X207.616 Y139.616 E.00735
G1 X207.942 Y139.543 E.00995
G1 X207.942 Y138.308 E.03676
G1 X206.387 Y138.308 E.04631
G1 X206.369 Y138.565 E.00766
; WIPE_START
G1 X206.387 Y138.308 E-.09769
G1 X207.942 Y138.308 E-.59086
G1 X207.942 Y138.496 E-.07145
; WIPE_END
M73 P66 R5
G1 E-.04 F1800
M204 S10000
G1 X207.511 Y138.713 Z1.4 F60000
G1 Z1
G1 E.8 F1800
; LINE_WIDTH: 0.59542
G1 F6515.837
M204 S8000
G2 X207.516 Y138.825 I-.03 J.057 E.01186
; WIPE_START
G1 X207.442 Y138.833 E-.20002
G1 X207.408 Y138.773 E-.18666
G1 X207.442 Y138.713 E-.18666
G1 X207.511 Y138.713 E-.18666
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X205.988 Y138.388 Z1.4 F60000
G1 Z1
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.521735
G1 F7518.573
M204 S8000
G2 X204.514 Y138.39 I-.726 J6.77 E.05585
M204 S10000
G1 X204.282 Y138.802 F60000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42102
G1 F9521.29
M204 S8000
G1 X203.73 Y138.249 E.02335
G1 X203.195 Y138.249 E.01597
G1 X203.796 Y138.851 E.0254
G2 X203.479 Y139.068 I.9 J1.652 E.01151
G1 X202.66 Y138.249 E.03459
G1 X202.126 Y138.249 E.01597
G1 X203.206 Y139.329 E.04562
G2 X202.958 Y139.617 I.641 J.801 E.01139
G1 X201.591 Y138.249 E.05777
G1 X201.056 Y138.249 E.01597
G1 X202.745 Y139.939 E.07135
G2 X202.58 Y140.308 I1.672 J.969 E.01211
G1 X200.521 Y138.249 E.08696
G1 X199.987 Y138.249 E.01597
G1 X202.459 Y140.722 E.10443
G2 X202.41 Y141.207 I2.541 J.503 E.0146
G1 X199.452 Y138.249 E.12494
G1 X198.917 Y138.249 E.01597
G1 X202.668 Y142 E.15842
; WIPE_START
G1 X201.254 Y140.586 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X196.115 Y146.229 Z1.4 F60000
G1 X170.67 Y174.168 Z1.4
G1 Z1
G1 E.8 F1800
G1 F9521.29
M204 S8000
G1 X144.752 Y148.249 E1.09477
G1 X144.217 Y148.249 E.01597
G1 X170.501 Y174.533 E1.11019
G1 X170.501 Y175.068 E.01597
G1 X143.682 Y148.249 E1.13277
G1 X143.147 Y148.249 E.01597
G1 X170.501 Y175.603 E1.15536
G1 X170.501 Y176.137 E.01597
G1 X142.613 Y148.249 E1.17794
G1 X142.078 Y148.249 E.01597
G1 X170.501 Y176.672 E1.20053
G1 X170.501 Y176.79 E.00353
G1 X170.161 Y176.867 E.0104
G1 X141.999 Y148.705 E1.1895
G1 X141.999 Y149.24 E.01597
G1 X168.514 Y175.754 E1.11993
G1 X168.004 Y175.659 E.01549
G1 X167.884 Y175.66 E.00358
G1 X141.999 Y149.775 E1.09334
G1 X141.999 Y150.31 E.01597
G1 X167.369 Y175.68 E1.07159
G1 X166.926 Y175.771 E.01352
G1 X141.999 Y150.844 E1.05286
G1 X141.999 Y151.379 E.01597
G1 X166.541 Y175.921 E1.03662
G2 X166.204 Y176.118 I.518 J1.273 E.01171
G1 X141.999 Y151.914 E1.02236
G1 X141.999 Y152.448 E.01597
G1 X165.892 Y176.341 E1.00918
G2 X165.623 Y176.606 I1.155 J1.438 E.01131
G1 X141.999 Y152.983 E.99782
G1 X141.999 Y153.518 E.01597
G1 X165.394 Y176.913 E.98817
G2 X165.197 Y177.25 I.79 J.69 E.01174
G1 X141.999 Y154.053 E.97982
G1 X141.999 Y154.587 E.01597
G1 X165.036 Y177.624 E.97305
G2 X164.936 Y178.059 I3.895 J1.123 E.01333
G1 X141.999 Y155.122 E.96883
G1 X141.999 Y155.657 E.01597
G1 X164.901 Y178.559 E.96735
G2 X164.992 Y179.184 I2.112 J.013 E.01894
G1 X141.999 Y156.191 E.97117
G1 X141.999 Y156.726 E.01597
G1 X167.024 Y181.751 E1.057
G1 X167.559 Y181.751 E.01597
G1 X167.066 Y181.258 E.0208
G2 X167.691 Y181.349 I.613 J-2.032 E.01894
G1 X168.093 Y181.751 E.01698
G1 X168.628 Y181.751 E.01597
G1 X168.186 Y181.309 E.01867
G1 X168.623 Y181.211 E.01338
G1 X169.163 Y181.751 E.02279
G1 X169.697 Y181.751 E.01597
G1 X169.002 Y181.055 E.02938
G2 X169.345 Y180.863 I-1.456 J-3.008 E.01174
G1 X170.232 Y181.751 E.03748
G1 X170.501 Y181.751 E.00802
G1 X170.501 Y181.484 E.00795
G1 X169.641 Y180.624 E.03633
G1 X169.909 Y180.358 E.01129
G1 X170.501 Y180.95 E.02498
G1 X170.501 Y180.415 E.01597
G1 X170.01 Y179.925 E.02071
M204 S10000
G1 X170.389 Y179.843 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.437144
G1 F9131.867
M204 S8000
G1 X170.437 Y179.629 E.00683
; LINE_WIDTH: 0.404438
G1 F9958.034
G1 X170.462 Y179.489 E.00405
; LINE_WIDTH: 0.355146
G1 F11530.12
G1 X170.486 Y179.35 E.0035
; LINE_WIDTH: 0.328382
G1 F12611.143
G1 X170.489 Y179.336 E.00032
; LINE_WIDTH: 0.309995
G1 F13479.366
G1 X170.505 Y179.207 E.00274
; LINE_WIDTH: 0.276221
G1 F15000
G1 X170.522 Y179.067 E.00259
; LINE_WIDTH: 0.237381
G1 X170.544 Y178.786 E.00432
; LINE_WIDTH: 0.20818
G1 X170.545 Y178.235 E.00719
; LINE_WIDTH: 0.234219
G1 X170.524 Y177.953 E.00427
; LINE_WIDTH: 0.272204
G1 X170.507 Y177.811 E.00259
; LINE_WIDTH: 0.308943
G1 F13532.666
G1 X170.487 Y177.655 E.00332
; LINE_WIDTH: 0.353939
G1 F11574.852
G1 X170.462 Y177.513 E.00354
; LINE_WIDTH: 0.403913
G1 F9972.492
G1 X170.437 Y177.371 E.00411
; LINE_WIDTH: 0.437052
G1 F9134.001
G1 X170.389 Y177.157 E.00684
; WIPE_START
G1 X170.437 Y177.371 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X166.659 Y181.92 Z1.4 F60000
G1 Z1
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42102
G1 F9521.29
M204 S8000
G1 X141.999 Y157.261 E1.04158
G1 X141.999 Y157.796 E.01597
G1 X165.954 Y181.751 E1.01183
G1 X165.42 Y181.751 E.01597
G1 X141.999 Y158.33 E.98924
G1 X141.999 Y158.865 E.01597
G1 X164.885 Y181.751 E.96666
G1 X164.35 Y181.751 E.01597
G1 X141.999 Y159.4 E.94407
G1 X141.999 Y159.934 E.01597
G1 X163.816 Y181.751 E.92149
G1 X163.281 Y181.751 E.01597
G1 X141.999 Y160.469 E.8989
G1 X141.999 Y161.004 E.01597
G1 X162.746 Y181.751 E.87632
G1 X162.211 Y181.751 E.01597
G1 X141.999 Y161.539 E.85373
G1 X141.999 Y162.073 E.01597
G1 X161.677 Y181.751 E.83115
G1 X161.142 Y181.751 E.01597
G1 X141.999 Y162.608 E.80856
G1 X141.999 Y163.143 E.01597
G1 X160.607 Y181.751 E.78597
G1 X160.073 Y181.751 E.01597
M73 P67 R5
G1 X141.999 Y163.677 E.76339
G1 X141.999 Y164.212 E.01597
G1 X159.538 Y181.751 E.7408
G1 X159.003 Y181.751 E.01597
G1 X141.999 Y164.747 E.71822
G1 X141.999 Y165.282 E.01597
G1 X158.468 Y181.751 E.69563
G1 X157.934 Y181.751 E.01597
G1 X141.999 Y165.816 E.67305
G1 X141.999 Y166.351 E.01597
G1 X157.399 Y181.751 E.65046
G1 X156.864 Y181.751 E.01597
G1 X141.999 Y166.886 E.62787
G1 X141.999 Y167.42 E.01597
G1 X156.33 Y181.751 E.60529
G1 X155.795 Y181.751 E.01597
G1 X141.999 Y167.955 E.5827
G1 X141.999 Y168.49 E.01597
G1 X155.26 Y181.751 E.56012
G1 X154.725 Y181.751 E.01597
G1 X141.999 Y169.025 E.53753
G1 X141.999 Y169.559 E.01597
G1 X154.191 Y181.751 E.51495
G1 X153.656 Y181.751 E.01597
G1 X141.999 Y170.094 E.49236
G1 X141.999 Y170.629 E.01597
G1 X153.121 Y181.751 E.46978
G1 X152.587 Y181.751 E.01597
G1 X141.999 Y171.163 E.44719
G1 X141.999 Y171.698 E.01597
G1 X152.052 Y181.751 E.42461
G1 X151.517 Y181.751 E.01597
G1 X141.999 Y172.233 E.40202
G1 X141.999 Y172.768 E.01597
G1 X150.982 Y181.751 E.37943
G1 X150.448 Y181.751 E.01597
G1 X141.999 Y173.302 E.35685
G1 X141.999 Y173.837 E.01597
G1 X149.913 Y181.751 E.33426
G1 X149.378 Y181.751 E.01597
G1 X141.999 Y174.372 E.31168
G1 X141.999 Y174.906 E.01597
G1 X148.844 Y181.751 E.28909
G1 X148.309 Y181.751 E.01597
G1 X141.999 Y175.441 E.26651
G1 X141.999 Y175.976 E.01597
G1 X147.774 Y181.751 E.24392
G1 X147.239 Y181.751 E.01597
G1 X141.999 Y176.511 E.22134
G1 X141.999 Y177.045 E.01597
G1 X146.705 Y181.751 E.19875
G1 X146.17 Y181.751 E.01597
G1 X141.999 Y177.58 E.17616
G1 X141.999 Y178.115 E.01597
G1 X145.635 Y181.751 E.15358
G1 X145.101 Y181.751 E.01597
G1 X141.999 Y178.649 E.13099
G1 X141.999 Y179.184 E.01597
G1 X144.566 Y181.751 E.10841
G1 X144.031 Y181.751 E.01597
G1 X141.999 Y179.719 E.08582
G1 X141.999 Y180.254 E.01597
G1 X143.496 Y181.751 E.06324
G1 X142.962 Y181.751 E.01597
G1 X141.999 Y180.788 E.04065
G1 X141.999 Y181.323 E.01597
G1 X142.597 Y181.92 E.02523
; WIPE_START
G1 X141.999 Y181.323 E-.32102
G1 X141.999 Y180.788 E-.20319
G1 X142.438 Y181.227 E-.23579
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X144.3 Y173.825 Z1.4 F60000
G1 X152.064 Y142.956 Z1.4
G1 Z1
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.121912
G1 F15000
M204 S8000
G1 X151.87 Y142.734 E.00184
M204 S10000
G1 X151.732 Y141.929 F60000
; LINE_WIDTH: 0.531552
G1 F7367.513
M204 S8000
G3 X151.733 Y140.671 I5.934 J-.627 E.04864
M204 S10000
G1 X151.87 Y139.872 F60000
; LINE_WIDTH: 0.117746
G1 F15000
M204 S8000
G1 X152.049 Y139.663 E.00163
; WIPE_START
G1 X151.87 Y139.872 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X153.06 Y138.573 Z1.4 F60000
G1 Z1
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.57051
G1 F6823.481
M204 S8000
G1 X153.045 Y138.384 E.0079
G1 X152.134 Y138.384 E.03799
G1 X152.134 Y139.13 E.0311
G1 X152.22 Y139.124 E.00361
G1 X152.811 Y138.686 E.03065
G1 X153.005 Y138.597 E.00891
M204 S10000
G1 X153.514 Y138.39 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.52173
G1 F7518.645
M204 S8000
G3 X154.988 Y138.388 I.748 J6.768 E.05585
; CHANGE_LAYER
; Z_HEIGHT: 1.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F7518.645
G1 X154.244 Y138.349 E-.38367
G1 X153.514 Y138.39 E-.37633
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 6/54
; update layer progress
M73 L6
M991 S0 P5 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z1.4 I-1.211 J.121 P1  F60000
G1 X154.012 Y143.388 Z1.4
G1 Z1.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X153.886 Y143.376 E.00408
G3 X154.026 Y139.202 I.363 J-2.078 E.19416
G1 X154.225 Y139.19 E.00639
G3 X154.29 Y143.407 I.024 J2.109 E.21249
G1 X154.072 Y143.392 E.00704
; COOLING_NODE: 0
M204 S10000
G1 X154.043 Y142.984 F60000
G1 F8843.478
M204 S8000
G1 X153.956 Y142.975 E.00283
G3 X154.07 Y139.607 I.293 J-1.676 E.15667
G1 X154.229 Y139.597 E.00512
G3 X154.282 Y143 I.02 J1.702 E.17149
G1 X154.103 Y142.988 E.00576
; COOLING_NODE: 0
M204 S250
G1 X154.074 Y142.594 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X154.023 Y142.589 E.00151
G3 X154.113 Y139.997 I.226 J-1.29 E.11167
G1 X154.233 Y139.99 E.00361
G3 X154.274 Y142.608 I.016 J1.309 E.12227
G1 X154.133 Y142.599 E.00419
; COOLING_NODE: 0
; WIPE_START
M204 S8000
G1 X154.023 Y142.589 E-.04211
G1 X153.78 Y142.523 E-.09549
G1 X153.556 Y142.411 E-.09532
G1 X153.34 Y142.243 E-.10422
G1 X153.177 Y142.052 E-.09536
G1 X153.053 Y141.832 E-.09573
G1 X152.973 Y141.593 E-.09575
G1 X152.94 Y141.323 E-.10343
G1 X152.947 Y141.238 E-.03259
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X156.191 Y148.147 Z1.6 F60000
G1 X169.702 Y176.926 Z1.6
G1 Z1.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X169.811 Y177.057 E.00547
G3 X167.483 Y175.996 I-2.063 J1.441 E.42209
G1 X167.72 Y175.982 E.00766
G3 X169.493 Y176.686 I.028 J2.516 E.06292
G1 X169.663 Y176.881 E.00831
; COOLING_NODE: 0
M204 S10000
G1 X169.394 Y177.191 F60000
G1 F8843.478
M204 S8000
G1 X169.477 Y177.291 E.00419
G3 X167.526 Y176.401 I-1.729 J1.208 E.35378
G1 X167.725 Y176.39 E.00638
G3 X169.212 Y176.98 I.024 J2.109 E.05277
G1 X169.355 Y177.145 E.00703
; COOLING_NODE: 0
M204 S10000
G1 X169.086 Y177.455 F60000
G1 F8843.478
M204 S8000
G1 X169.144 Y177.524 E.0029
G3 X167.57 Y176.807 I-1.395 J.975 E.28548
G1 X167.729 Y176.797 E.00511
G3 X168.93 Y177.274 I.02 J1.702 E.04263
G1 X169.047 Y177.409 E.00575
; COOLING_NODE: 1
M204 S250
G1 X168.789 Y177.709 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X168.823 Y177.749 E.00155
G3 X167.613 Y177.197 I-1.073 J.75 E.2035
G1 X167.733 Y177.19 E.0036
G3 X168.659 Y177.557 I.016 J1.309 E.03043
G1 X168.75 Y177.663 E.00417
; COOLING_NODE: 1
; WIPE_START
M204 S8000
G1 X168.823 Y177.749 E-.04263
G1 X168.956 Y177.988 E-.10414
G1 X169.031 Y178.227 E-.09517
G1 X169.06 Y178.476 E-.09507
G1 X169.04 Y178.727 E-.0958
G1 X168.971 Y178.975 E-.09795
G1 X168.849 Y179.213 E-.10136
G1 X168.692 Y179.41 E-.096
G1 X168.628 Y179.464 E-.03189
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X165.042 Y172.727 Z1.6 F60000
G1 X154.144 Y152.248 Z1.6
G1 Z1.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X154.478 Y152.103 E.01171
G3 X154.983 Y151.996 I.77 J2.396 E.0166
G1 X155.22 Y151.982 E.00766
G3 X154.035 Y152.294 I.028 J2.516 E.46859
G1 X154.089 Y152.271 E.0019
; COOLING_NODE: 1
M204 S10000
G1 X154.305 Y152.62 F60000
G1 F8843.478
M204 S8000
G1 X154.603 Y152.491 E.01043
G3 X155.026 Y152.401 I.646 J2.008 E.01395
G1 X155.225 Y152.39 E.00638
G3 X154.231 Y152.652 I.024 J2.109 E.39272
G1 X154.25 Y152.644 E.00066
; COOLING_NODE: 1
M204 S10000
G1 X154.466 Y152.993 F60000
G1 F8843.478
M204 S8000
G1 X154.727 Y152.879 E.00915
G3 X155.07 Y152.807 I.522 J1.62 E.01131
G1 X155.229 Y152.797 E.00511
G3 X154.411 Y153.018 I.02 J1.702 E.31629
; COOLING_NODE: 2
M204 S250
G1 X154.621 Y153.351 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X154.846 Y153.253 E.00733
G3 X155.113 Y153.197 I.403 J1.246 E.00812
G1 X155.233 Y153.19 E.0036
G3 X154.569 Y153.381 I.016 J1.309 E.22421
; COOLING_NODE: 2
; WIPE_START
M204 S8000
G1 X154.846 Y153.253 E-.11612
G1 X155.113 Y153.197 E-.10339
G1 X155.233 Y153.19 E-.04594
G1 X155.5 Y153.214 E-.10167
G1 X155.741 Y153.285 E-.09561
G1 X155.963 Y153.401 E-.09506
G1 X156.16 Y153.557 E-.09571
G1 X156.324 Y153.749 E-.09584
G1 X156.337 Y153.774 E-.01066
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X163.814 Y152.239 Z1.6 F60000
G1 X204.972 Y143.792 Z1.6
G1 Z1.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X204.818 Y143.778 E.00497
G3 X204.983 Y138.796 I.431 J-2.479 E.23174
G1 X205.22 Y138.782 E.00765
G3 X205.297 Y143.814 I.028 J2.516 E.25353
G1 X205.032 Y143.796 E.00857
; COOLING_NODE: 2
M204 S10000
G1 X205.003 Y143.388 F60000
G1 F8843.478
M204 S8000
G1 X204.887 Y143.377 E.00374
G3 X205.027 Y139.201 I.362 J-2.078 E.19422
G1 X205.225 Y139.19 E.00638
G3 X205.289 Y143.407 I.024 J2.109 E.21252
G1 X205.063 Y143.392 E.00731
; COOLING_NODE: 2
M204 S10000
G1 X205.034 Y142.983 F60000
G1 F8843.478
M204 S8000
G1 X204.956 Y142.975 E.00251
G3 X205.07 Y139.607 I.293 J-1.676 E.1567
G1 X205.229 Y139.597 E.00511
G3 X205.281 Y143 I.02 J1.702 E.17152
G1 X205.094 Y142.987 E.00604
; COOLING_NODE: 3
M204 S250
G1 X205.064 Y142.594 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X205.023 Y142.589 E.00123
G3 X205.113 Y139.997 I.226 J-1.29 E.11168
G1 X205.233 Y139.99 E.00361
G3 X205.274 Y142.608 I.016 J1.309 E.12229
G1 X205.124 Y142.598 E.00446
; COOLING_NODE: 3
; WIPE_START
M204 S8000
G1 X205.023 Y142.589 E-.03853
G1 X204.781 Y142.523 E-.09551
G1 X204.556 Y142.411 E-.09542
G1 X204.34 Y142.242 E-.10421
G1 X204.176 Y142.05 E-.09591
G1 X204.044 Y141.812 E-.10337
G1 X203.969 Y141.573 E-.09534
G1 X203.94 Y141.323 E-.09574
G1 X203.947 Y141.229 E-.03596
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X196.377 Y142.197 Z1.6 F60000
G1 X151.666 Y147.916 Z1.6
G1 Z1.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X151.666 Y142.143 E.18563
G1 X151.866 Y142.106 E.00653
G2 X151.87 Y140.488 I2.384 J-.803 E.45537
G1 X151.666 Y140.453 E.00665
G1 X151.666 Y137.916 E.08159
G1 X208.334 Y137.916 E1.82222
G1 X208.334 Y151.584 E.4395
G1 X170.834 Y151.584 E1.20586
G1 X170.834 Y182.084 E.98077
G1 X141.666 Y182.084 E.93792
G1 X141.666 Y147.916 E1.09871
G1 X151.606 Y147.916 E.31963
; COOLING_NODE: 3
M204 S10000
G1 X151.259 Y147.509 F60000
G1 F8843.478
M204 S8000
M73 P68 R5
G1 X151.259 Y137.509 E.32156
G1 X208.741 Y137.509 E1.8484
G1 X208.741 Y151.991 E.46568
G1 X171.241 Y151.991 E1.20586
G1 X171.241 Y182.491 E.98077
G1 X141.259 Y182.491 E.9641
G1 X141.259 Y147.509 E1.12489
G1 X151.199 Y147.509 E.31963
; COOLING_NODE: 3
M204 S10000
G1 X150.852 Y147.102 F60000
G1 F8843.478
M204 S8000
G1 X150.852 Y137.102 E.32156
G1 X209.148 Y137.102 E1.87458
G1 X209.148 Y152.398 E.49186
G1 X171.648 Y152.398 E1.20586
G1 X171.648 Y182.898 E.98077
G1 X140.852 Y182.898 E.99028
G1 X140.852 Y147.102 E1.15107
G1 X150.792 Y147.102 E.31963
; COOLING_NODE: 4
M204 S250
G1 X150.46 Y146.71 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X150.46 Y136.71 E.29787
G1 X209.54 Y136.71 E1.75979
G1 X209.54 Y152.79 E.47897
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X172.04 Y152.79 E1.117
G1 X172.04 Y183.29 E.90849
G1 X140.46 Y183.29 E.94066
G1 X140.46 Y146.71 E1.08959
G1 X150.4 Y146.71 E.29608
; WIPE_START
M204 S8000
G1 X150.412 Y144.71 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X151.83 Y147.433 Z1.6 F60000
G1 Z1.2
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42234
G1 F9488.165
M204 S8000
G1 X155.341 Y143.921 E.14885
G3 X154.61 Y144.117 I-.911 J-1.944 E.02282
G1 X151.999 Y146.727 E.11064
G1 X151.999 Y146.19 E.01608
G1 X154.046 Y144.144 E.08676
G1 X153.586 Y144.067 E.01397
G1 X151.999 Y145.654 E.06727
G1 X151.999 Y145.117 E.01608
G1 X153.184 Y143.932 E.05022
G3 X152.818 Y143.762 I.401 J-1.343 E.01215
G1 X151.999 Y144.581 E.03469
G1 X151.999 Y144.044 E.01608
G1 X152.495 Y143.548 E.02102
G3 X152.236 Y143.316 I.968 J-1.341 E.01043
G1 X152.038 Y143.502 E.00815
G1 X152.022 Y143.485 E.00071
G1 X151.83 Y143.677 E.00814
M204 S10000
G1 X152.092 Y142.994 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.109465
G1 F15000
M204 S8000
G1 X151.988 Y142.882 E.0008
; LINE_WIDTH: 0.136352
G1 X151.87 Y142.746 E.00133
M204 S10000
G1 X151.736 Y141.923 F60000
; LINE_WIDTH: 0.531885
G1 F7362.5
M204 S8000
G3 X151.732 Y140.671 I5.614 J-.642 E.04847
M204 S10000
G1 X151.87 Y139.877 F60000
; LINE_WIDTH: 0.1164
G1 F15000
M204 S8000
G1 X152.035 Y139.682 E.00148
; WIPE_START
G1 X151.87 Y139.877 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X153.064 Y138.588 Z1.6 F60000
G1 Z1.2
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.56565
G1 F6886.921
M204 S8000
G1 X153.047 Y138.381 E.00856
G1 X152.131 Y138.381 E.03783
G1 X152.131 Y139.159 E.03211
G1 X152.184 Y139.158 E.0022
G1 X152.613 Y138.809 E.02283
G1 X153.01 Y138.614 E.01825
M204 S10000
G1 X153.514 Y138.39 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.521741
G1 F7518.472
M204 S8000
G3 X154.988 Y138.388 I.748 J6.761 E.05586
M204 S10000
G1 X155.125 Y138.772 F60000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42234
G1 F9488.165
M204 S8000
G1 X155.648 Y138.249 E.02214
G1 X156.184 Y138.249 E.01608
G1 X155.621 Y138.812 E.02387
G3 X155.948 Y139.023 I-.38 J.948 E.01171
G1 X156.721 Y138.249 E.03278
G1 X157.257 Y138.249 E.01608
G1 X156.244 Y139.263 E.04295
G3 X156.493 Y139.551 I-.845 J.98 E.01144
G1 X157.794 Y138.249 E.05516
G1 X158.331 Y138.249 E.01608
G1 X156.712 Y139.868 E.06863
G3 X156.889 Y140.228 I-2.493 J1.453 E.01202
G1 X158.867 Y138.249 E.08386
G1 X159.404 Y138.249 E.01608
G1 X157.018 Y140.635 E.10112
G1 X157.086 Y141.104 E.0142
G1 X159.94 Y138.249 E.121
G1 X160.477 Y138.249 E.01608
G1 X157.07 Y141.656 E.14439
G1 X157.06 Y141.791 E.00407
G1 X156.889 Y142.373 E.01818
G1 X161.014 Y138.249 E.1748
G1 X161.55 Y138.249 E.01608
G1 X151.83 Y147.97 E.41201
; WIPE_START
G1 X153.244 Y146.556 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X145.761 Y148.058 Z1.6 F60000
G1 X141.83 Y148.848 Z1.6
G1 Z1.2
G1 E.8 F1800
G1 F9488.165
M204 S8000
G1 X142.428 Y148.249 E.02537
G1 X142.965 Y148.249 E.01608
G1 X141.999 Y149.215 E.04092
G1 X141.999 Y149.751 E.01608
G1 X143.501 Y148.249 E.06367
G1 X144.038 Y148.249 E.01608
G1 X141.999 Y150.288 E.08641
G1 X141.999 Y150.825 E.01608
G1 X144.575 Y148.249 E.10915
G1 X145.111 Y148.249 E.01608
G1 X141.999 Y151.361 E.1319
G1 X141.999 Y151.898 E.01608
G1 X145.648 Y148.249 E.15464
G1 X146.184 Y148.249 E.01608
G1 X141.999 Y152.434 E.17738
G1 X141.999 Y152.971 E.01608
G1 X146.721 Y148.249 E.20013
G1 X147.257 Y148.249 E.01608
G1 X141.999 Y153.507 E.22287
M73 P68 R4
G1 X141.999 Y154.044 E.01608
G1 X147.794 Y148.249 E.24561
G1 X148.331 Y148.249 E.01608
G1 X141.999 Y154.581 E.26836
G1 X141.999 Y155.117 E.01608
G1 X148.867 Y148.249 E.2911
G1 X149.404 Y148.249 E.01608
G1 X141.999 Y155.654 E.31384
G1 X141.999 Y156.19 E.01608
G1 X149.94 Y148.249 E.33659
G1 X150.477 Y148.249 E.01608
G1 X141.999 Y156.727 E.35933
G1 X141.999 Y157.264 E.01608
G1 X151.014 Y148.249 E.38208
G1 X151.55 Y148.249 E.01608
G1 X141.999 Y157.8 E.40482
G1 X141.999 Y158.337 E.01608
G1 X162.087 Y138.249 E.85142
G1 X162.623 Y138.249 E.01608
G1 X141.999 Y158.873 E.87417
G1 X141.999 Y159.41 E.01608
G1 X163.16 Y138.249 E.89691
G1 X163.696 Y138.249 E.01608
G1 X141.999 Y159.946 E.91965
G1 X141.999 Y160.483 E.01608
G1 X164.233 Y138.249 E.9424
G1 X164.77 Y138.249 E.01608
G1 X141.999 Y161.02 E.96514
G1 X141.999 Y161.556 E.01608
G1 X165.306 Y138.249 E.98788
G1 X165.843 Y138.249 E.01608
G1 X141.999 Y162.093 E1.01063
G1 X141.999 Y162.629 E.01608
M73 P69 R4
G1 X166.379 Y138.249 E1.03337
G1 X166.916 Y138.249 E.01608
G1 X141.83 Y163.336 E1.06331
; WIPE_START
G1 X143.244 Y161.921 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X142.116 Y169.47 Z1.6 F60000
G1 X141.83 Y171.384 Z1.6
G1 Z1.2
G1 E.8 F1800
G1 F9488.165
M204 S8000
G1 X155.964 Y157.25 E.59908
G3 X155.328 Y157.349 I-.655 J-2.119 E.01935
G1 X141.999 Y170.678 E.56495
G1 X141.999 Y170.141 E.01608
G1 X154.824 Y157.317 E.54358
G3 X154.389 Y157.215 I.504 J-3.144 E.0134
G1 X141.999 Y169.605 E.52514
G1 X141.999 Y169.068 E.01608
G1 X154.005 Y157.063 E.50888
G3 X153.671 Y156.861 I.544 J-1.279 E.01175
G1 X141.999 Y168.532 E.49469
G1 X141.999 Y167.995 E.01608
G1 X153.362 Y156.632 E.48162
G3 X153.094 Y156.364 I1.145 J-1.411 E.01139
G1 X141.999 Y167.459 E.47026
G1 X141.999 Y166.922 E.01608
G1 X152.871 Y156.051 E.46079
G3 X152.678 Y155.706 I.77 J-.656 E.0119
G1 X141.999 Y166.385 E.45264
G1 X141.999 Y165.849 E.01608
G1 X152.524 Y155.324 E.44609
G1 X152.427 Y154.884 E.01351
G1 X141.999 Y165.312 E.442
G1 X141.999 Y164.776 E.01608
G1 X152.407 Y154.368 E.44112
G3 X152.504 Y153.734 I1.93 J-.028 E.01931
G1 X141.999 Y164.239 E.44525
G1 X141.999 Y163.703 E.01608
G1 X167.453 Y138.249 E1.07886
G1 X167.989 Y138.249 E.01608
G1 X154.481 Y151.758 E.57257
G3 X155.113 Y151.662 I.675 J2.317 E.01923
G1 X168.526 Y138.249 E.5685
G1 X169.062 Y138.249 E.01608
G1 X155.634 Y151.678 E.56919
G3 X156.077 Y151.771 I-.222 J2.162 E.01361
G1 X169.599 Y138.249 E.57314
G1 X170.135 Y138.249 E.01608
G1 X156.459 Y151.925 E.57967
G3 X156.801 Y152.121 I-.35 J1.007 E.01185
G1 X170.672 Y138.249 E.58796
G1 X171.209 Y138.249 E.01608
G1 X157.112 Y152.346 E.59748
G3 X157.383 Y152.612 I-1.134 J1.424 E.01139
G1 X171.745 Y138.249 E.60876
G1 X172.282 Y138.249 E.01608
G1 X157.61 Y152.921 E.62188
G3 X157.812 Y153.256 I-1.004 J.833 E.01176
G1 X172.818 Y138.249 E.63607
G1 X173.355 Y138.249 E.01608
G1 X157.968 Y153.637 E.65221
G1 X158.064 Y154.077 E.0135
G1 X173.891 Y138.249 E.67086
G1 X174.428 Y138.249 E.01608
G1 X158.092 Y154.585 E.69241
G3 X158.01 Y155.204 I-2.51 J-.018 E.01875
G1 X174.965 Y138.249 E.71863
G1 X175.501 Y138.249 E.01608
G1 X141.999 Y171.751 E1.42001
G1 X141.999 Y172.288 E.01608
G1 X176.038 Y138.249 E1.44276
G1 X176.574 Y138.249 E.01608
G1 X141.999 Y172.824 E1.4655
G1 X141.999 Y173.361 E.01608
G1 X177.111 Y138.249 E1.48824
G1 X177.648 Y138.249 E.01608
G1 X141.999 Y173.898 E1.51099
G1 X141.999 Y174.434 E.01608
G1 X178.184 Y138.249 E1.53373
G1 X178.721 Y138.249 E.01608
G1 X141.999 Y174.971 E1.55647
G1 X141.999 Y175.507 E.01608
G1 X179.257 Y138.249 E1.57922
G1 X179.794 Y138.249 E.01608
G1 X141.999 Y176.044 E1.60196
G1 X141.999 Y176.58 E.01608
G1 X180.33 Y138.249 E1.6247
G1 X180.867 Y138.249 E.01608
G1 X141.999 Y177.117 E1.64745
G1 X141.999 Y177.654 E.01608
G1 X181.404 Y138.249 E1.67019
G1 X181.94 Y138.249 E.01608
G1 X141.999 Y178.19 E1.69293
G1 X141.999 Y178.727 E.01608
M73 P70 R4
G1 X182.477 Y138.249 E1.71568
G1 X183.013 Y138.249 E.01608
G1 X141.83 Y179.433 E1.74561
; WIPE_START
G1 X143.244 Y178.019 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X150.796 Y179.123 Z1.6 F60000
G1 X169.928 Y181.92 Z1.6
G1 Z1.2
G1 E.8 F1800
G1 F9488.165
M204 S8000
G1 X170.501 Y181.347 E.02429
G1 X170.501 Y180.811 E.01608
G1 X169.561 Y181.751 E.03984
G1 X169.024 Y181.751 E.01608
G1 X170.501 Y180.274 E.06259
G1 X170.501 Y180.207 E.00201
G1 X170.106 Y180.133 E.01205
G1 X168.487 Y181.751 E.06859
G1 X167.951 Y181.751 E.01608
G1 X168.448 Y181.254 E.02105
G3 X167.815 Y181.35 I-.645 J-2.11 E.01926
G1 X167.414 Y181.751 E.01697
G1 X166.878 Y181.751 E.01608
G1 X167.313 Y181.315 E.01845
G3 X166.88 Y181.212 I.528 J-3.178 E.01336
G1 X166.341 Y181.751 E.02282
G1 X165.805 Y181.751 E.01608
G1 X166.497 Y181.059 E.02933
G3 X166.163 Y180.856 I.546 J-1.274 E.01174
G1 X165.268 Y181.751 E.03793
G1 X164.731 Y181.751 E.01608
G1 X165.855 Y180.627 E.04765
G3 X165.588 Y180.357 I1.147 J-1.407 E.01139
G1 X164.195 Y181.751 E.05906
G1 X163.658 Y181.751 E.01608
G1 X165.365 Y180.043 E.07236
G3 X165.169 Y179.704 I1.024 J-.82 E.01181
G1 X163.122 Y181.751 E.08676
G1 X162.585 Y181.751 E.01608
G1 X165.021 Y179.315 E.10325
G1 X164.925 Y178.874 E.01352
G1 X162.048 Y181.751 E.12193
G1 X161.512 Y181.751 E.01608
G1 X164.906 Y178.356 E.14388
G3 X165.008 Y177.718 I2.984 J.147 E.0194
G1 X160.975 Y181.751 E.17092
G1 X160.439 Y181.751 E.01608
G1 X170.501 Y171.689 E.42648
G1 X170.501 Y171.152 E.01608
G1 X159.902 Y181.751 E.44923
G1 X159.366 Y181.751 E.01608
G1 X170.501 Y170.616 E.47197
G1 X170.501 Y170.079 E.01608
G1 X158.829 Y181.751 E.49472
G1 X158.292 Y181.751 E.01608
G1 X170.501 Y169.542 E.51746
G1 X170.501 Y169.006 E.01608
G1 X157.756 Y181.751 E.5402
G1 X157.219 Y181.751 E.01608
G1 X170.501 Y168.469 E.56295
G1 X170.501 Y167.933 E.01608
G1 X156.683 Y181.751 E.58569
G1 X156.146 Y181.751 E.01608
G1 X170.501 Y167.396 E.60843
G1 X170.501 Y166.86 E.01608
G1 X155.609 Y181.751 E.63118
G1 X155.073 Y181.751 E.01608
G1 X170.501 Y166.323 E.65392
G1 X170.501 Y165.786 E.01608
G1 X154.536 Y181.751 E.67666
G1 X154 Y181.751 E.01608
G1 X170.501 Y165.25 E.69941
G1 X170.501 Y164.713 E.01608
G1 X153.463 Y181.751 E.72215
G1 X152.927 Y181.751 E.01608
G1 X170.501 Y164.177 E.74489
G1 X170.501 Y163.64 E.01608
G1 X152.39 Y181.751 E.76764
G1 X151.853 Y181.751 E.01608
G1 X170.501 Y163.103 E.79038
G1 X170.501 Y162.567 E.01608
G1 X151.317 Y181.751 E.81312
G1 X150.78 Y181.751 E.01608
G1 X170.501 Y162.03 E.83587
G1 X170.501 Y161.494 E.01608
G1 X150.244 Y181.751 E.85861
G1 X149.707 Y181.751 E.01608
G1 X170.501 Y160.957 E.88136
G1 X170.501 Y160.421 E.01608
G1 X149.171 Y181.751 E.9041
G1 X148.634 Y181.751 E.01608
G1 X170.501 Y159.884 E.92684
G1 X170.501 Y159.347 E.01608
G1 X148.097 Y181.751 E.94959
G1 X147.561 Y181.751 E.01608
G1 X170.501 Y158.811 E.97233
G1 X170.501 Y158.274 E.01608
G1 X147.024 Y181.751 E.99507
G1 X146.488 Y181.751 E.01608
G1 X170.501 Y157.738 E1.01782
G1 X170.501 Y157.201 E.01608
G1 X145.951 Y181.751 E1.04056
G1 X145.414 Y181.751 E.01608
G1 X170.501 Y156.664 E1.0633
G1 X170.501 Y156.128 E.01608
G1 X144.878 Y181.751 E1.08605
G1 X144.341 Y181.751 E.01608
G1 X170.501 Y155.591 E1.10879
G1 X170.501 Y155.055 E.01608
G1 X143.805 Y181.751 E1.13153
G1 X143.268 Y181.751 E.01608
G1 X170.501 Y154.518 E1.15428
G1 X170.501 Y153.982 E.01608
G1 X142.732 Y181.751 E1.17702
G1 X142.195 Y181.751 E.01608
G1 X170.501 Y153.445 E1.19976
G1 X170.501 Y152.908 E.01608
G1 X141.999 Y181.41 E1.20806
G1 X141.999 Y180.873 E.01608
G1 X170.501 Y152.372 E1.20806
G1 X170.501 Y151.835 E.01608
M73 P71 R4
G1 X141.999 Y180.337 E1.20806
G1 X141.999 Y179.8 E.01608
G1 X183.55 Y138.249 E1.76116
G1 X184.087 Y138.249 E.01608
G1 X171.085 Y151.251 E.55107
G1 X171.622 Y151.251 E.01608
G1 X184.623 Y138.249 E.55107
G1 X185.16 Y138.249 E.01608
G1 X172.158 Y151.251 E.55107
G1 X172.695 Y151.251 E.01608
G1 X185.696 Y138.249 E.55107
G1 X186.233 Y138.249 E.01608
G1 X173.232 Y151.251 E.55107
G1 X173.768 Y151.251 E.01608
G1 X186.769 Y138.249 E.55107
G1 X187.306 Y138.249 E.01608
G1 X174.305 Y151.251 E.55107
G1 X174.841 Y151.251 E.01608
G1 X187.843 Y138.249 E.55107
G1 X188.379 Y138.249 E.01608
G1 X175.378 Y151.251 E.55107
G1 X175.914 Y151.251 E.01608
G1 X188.916 Y138.249 E.55107
G1 X189.452 Y138.249 E.01608
G1 X176.451 Y151.251 E.55107
G1 X176.988 Y151.251 E.01608
G1 X189.989 Y138.249 E.55107
G1 X190.525 Y138.249 E.01608
G1 X177.524 Y151.251 E.55107
G1 X178.061 Y151.251 E.01608
G1 X191.062 Y138.249 E.55107
G1 X191.599 Y138.249 E.01608
G1 X178.597 Y151.251 E.55107
G1 X179.134 Y151.251 E.01608
G1 X192.135 Y138.249 E.55107
G1 X192.672 Y138.249 E.01608
G1 X179.671 Y151.251 E.55107
G1 X180.207 Y151.251 E.01608
G1 X193.208 Y138.249 E.55107
G1 X193.745 Y138.249 E.01608
G1 X180.744 Y151.251 E.55107
G1 X181.28 Y151.251 E.01608
G1 X194.282 Y138.249 E.55107
G1 X194.818 Y138.249 E.01608
G1 X181.817 Y151.251 E.55107
G1 X182.353 Y151.251 E.01608
G1 X195.355 Y138.249 E.55107
G1 X195.891 Y138.249 E.01608
G1 X182.89 Y151.251 E.55107
G1 X183.427 Y151.251 E.01608
G1 X196.428 Y138.249 E.55107
G1 X196.964 Y138.249 E.01608
G1 X183.963 Y151.251 E.55107
G1 X184.5 Y151.251 E.01608
G1 X197.501 Y138.249 E.55107
G1 X198.038 Y138.249 E.01608
G1 X185.036 Y151.251 E.55107
G1 X185.573 Y151.251 E.01608
G1 X198.574 Y138.249 E.55107
G1 X199.111 Y138.249 E.01608
G1 X186.11 Y151.251 E.55107
G1 X186.646 Y151.251 E.01608
G1 X199.647 Y138.249 E.55107
G1 X200.184 Y138.249 E.01608
G1 X187.183 Y151.251 E.55107
G1 X187.719 Y151.251 E.01608
G1 X200.721 Y138.249 E.55107
G1 X201.257 Y138.249 E.01608
G1 X188.256 Y151.251 E.55107
G1 X188.792 Y151.251 E.01608
G1 X201.794 Y138.249 E.55107
G1 X202.33 Y138.249 E.01608
G1 X189.329 Y151.251 E.55107
G1 X189.866 Y151.251 E.01608
G1 X202.867 Y138.249 E.55107
G1 X203.403 Y138.249 E.01608
G1 X190.402 Y151.251 E.55107
G1 X190.939 Y151.251 E.01608
G1 X203.94 Y138.249 E.55107
G1 X204.169 Y138.249 E.00686
G1 X204.192 Y138.534 E.00857
G1 X191.475 Y151.251 E.53899
G1 X192.012 Y151.251 E.01608
G1 X202.453 Y140.809 E.44257
G2 X202.402 Y141.397 I2.492 J.513 E.01772
G1 X192.548 Y151.251 E.41765
G1 X193.085 Y151.251 E.01608
G1 X202.468 Y141.868 E.3977
G2 X202.58 Y142.292 I1.533 J-.179 E.0132
G1 X193.622 Y151.251 E.37972
G1 X194.158 Y151.251 E.01608
G1 X202.746 Y142.663 E.36401
G1 X202.962 Y142.983 E.01159
G1 X194.695 Y151.251 E.35041
G1 X195.231 Y151.251 E.01608
G1 X203.202 Y143.28 E.33785
G2 X203.482 Y143.537 I1.363 J-1.204 E.0114
G1 X195.768 Y151.251 E.32697
G1 X196.305 Y151.251 E.01608
G1 X203.802 Y143.753 E.31778
G2 X204.16 Y143.932 I1.115 J-1.786 E.01201
G1 X196.841 Y151.251 E.31021
G1 X197.378 Y151.251 E.01608
G1 X204.565 Y144.064 E.30463
G1 X205.023 Y144.142 E.01393
G1 X197.914 Y151.251 E.3013
G1 X198.451 Y151.251 E.01608
G1 X205.568 Y144.133 E.30167
G2 X206.297 Y143.941 I-.114 J-1.909 E.02276
G1 X198.987 Y151.251 E.30984
G1 X199.524 Y151.251 E.01608
G1 X207.804 Y142.97 E.35098
G1 X208.001 Y143.008 E.00599
G1 X208.001 Y143.311 E.00906
G1 X200.061 Y151.251 E.33655
G1 X200.597 Y151.251 E.01608
G1 X208.001 Y143.847 E.3138
G1 X208.001 Y144.384 E.01608
G1 X201.134 Y151.251 E.29106
G1 X201.67 Y151.251 E.01608
G1 X208.001 Y144.92 E.26832
G1 X208.001 Y145.457 E.01608
G1 X202.207 Y151.251 E.24557
G1 X202.744 Y151.251 E.01608
G1 X208.001 Y145.994 E.22283
G1 X208.001 Y146.53 E.01608
G1 X203.28 Y151.251 E.20008
G1 X203.817 Y151.251 E.01608
G1 X208.001 Y147.067 E.17734
G1 X208.001 Y147.603 E.01608
G1 X204.353 Y151.251 E.1546
G1 X204.89 Y151.251 E.01608
G1 X208.001 Y148.14 E.13185
G1 X208.001 Y148.676 E.01608
G1 X205.426 Y151.251 E.10911
G1 X205.963 Y151.251 E.01608
G1 X208.001 Y149.213 E.08637
G1 X208.001 Y149.75 E.01608
G1 X206.5 Y151.251 E.06362
G1 X207.036 Y151.251 E.01608
G1 X208.001 Y150.286 E.04088
G1 X208.001 Y150.823 E.01608
G1 X207.403 Y151.42 E.02533
; WIPE_START
G1 X208.001 Y150.823 E-.32113
M73 P72 R4
G1 X208.001 Y150.286 E-.2039
G1 X207.563 Y150.723 E-.23497
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X207.876 Y143.097 Z1.6 F60000
G1 X207.895 Y142.648 Z1.6
G1 Z1.2
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.413198
G1 F9722.447
M204 S8000
G1 X207.947 Y142.379 E.00801
; LINE_WIDTH: 0.385605
G1 F10505.27
G1 X207.971 Y142.237 E.00391
; LINE_WIDTH: 0.337962
G1 F12201.665
G1 X207.995 Y142.095 E.00336
; LINE_WIDTH: 0.312178
G1 F13370.092
G1 X207.997 Y142.081 E.0003
; LINE_WIDTH: 0.294368
G1 F14317.096
G1 X208.012 Y141.942 E.00277
; LINE_WIDTH: 0.261644
G1 F15000
G1 X208.029 Y141.794 E.00258
; LINE_WIDTH: 0.215052
G1 X208.051 Y141.254 E.00734
G1 X208.041 Y140.961 E.004
; LINE_WIDTH: 0.244021
G1 X208.019 Y140.698 E.00418
; LINE_WIDTH: 0.284154
G1 F14923.283
G1 X208.001 Y140.563 E.0026
; LINE_WIDTH: 0.321711
G1 F12912.894
G1 X207.981 Y140.413 E.00332
; LINE_WIDTH: 0.364832
G1 F11183.206
G1 X207.958 Y140.288 E.00325
; LINE_WIDTH: 0.424736
G1 F9428.647
G1 X207.933 Y140.151 E.00419
G1 X207.657 Y140.025 E.00915
; WIPE_START
G1 X207.933 Y140.151 E-.52135
G1 X207.958 Y140.288 E-.23865
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X206.365 Y138.623 Z1.6 F60000
G1 Z1.2
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F9547.299
M204 S8000
G1 X206.602 Y138.723 E.00766
G3 X207.486 Y139.474 I-1.219 J2.332 E.03485
G1 X207.624 Y139.374 E.00505
G1 X207.942 Y139.49 E.01008
G1 X207.942 Y138.308 E.0352
G1 X206.387 Y138.308 E.04631
G1 X206.369 Y138.564 E.00762
; WIPE_START
G1 X206.387 Y138.308 E-.09724
G1 X207.942 Y138.308 E-.59083
G1 X207.942 Y138.498 E-.07193
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X207.513 Y138.712 Z1.6 F60000
G1 Z1.2
G1 E.8 F1800
; LINE_WIDTH: 0.59256
G1 F6549.742
M204 S8000
G2 X207.517 Y138.824 I-.03 J.057 E.01173
; WIPE_START
G1 X207.444 Y138.831 E-.19965
G1 X207.41 Y138.772 E-.18679
G1 X207.444 Y138.712 E-.18679
G1 X207.513 Y138.712 E-.18678
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X205.988 Y138.388 Z1.6 F60000
G1 Z1.2
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.521735
G1 F7518.569
M204 S8000
G2 X204.514 Y138.39 I-.726 J6.761 E.05586
; WIPE_START
G1 X205.227 Y138.349 E-.36733
G1 X205.988 Y138.388 E-.39267
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X200.464 Y143.654 Z1.6 F60000
G1 X170.67 Y172.056 Z1.6
G1 Z1.2
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42234
G1 F9488.165
M204 S8000
G1 X166.964 Y175.762 E.15711
G3 X167.601 Y175.662 I.696 J2.344 E.01938
G1 X170.501 Y172.762 E.12292
G1 X170.501 Y173.298 E.01608
G1 X168.123 Y175.677 E.1008
G3 X168.567 Y175.769 I-.217 J2.166 E.01363
G1 X170.501 Y173.835 E.08196
G1 X170.501 Y174.372 E.01608
G1 X168.951 Y175.922 E.0657
G3 X169.293 Y176.116 I-.346 J1.009 E.01187
G1 X170.501 Y174.908 E.05119
G1 X170.501 Y175.445 E.01608
G1 X169.602 Y176.343 E.03807
G1 X169.877 Y176.605 E.01138
G1 X170.501 Y175.981 E.02643
G1 X170.501 Y176.518 E.01608
G1 X170.195 Y176.823 E.01293
M204 S10000
G1 X170.157 Y177.225 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.4364
G1 F9149.147
M204 S8000
G1 X170.433 Y177.351 E.00943
G1 X170.437 Y177.371 E.00063
; LINE_WIDTH: 0.404545
G1 F9955.065
G1 X170.462 Y177.51 E.00402
; LINE_WIDTH: 0.355715
G1 F11509.138
G1 X170.486 Y177.648 E.00348
; LINE_WIDTH: 0.313404
G1 F13309.493
G1 X170.504 Y177.784 E.00292
; LINE_WIDTH: 0.280581
G1 F15000
G1 X170.519 Y177.906 E.00231
; LINE_WIDTH: 0.243517
G1 X170.541 Y178.16 E.00404
; LINE_WIDTH: 0.214722
G1 X170.551 Y178.447 E.0039
G1 X170.53 Y178.984 E.0073
; LINE_WIDTH: 0.25982
G1 X170.513 Y179.135 E.0026
; LINE_WIDTH: 0.292952
G1 F14398.179
G1 X170.497 Y179.275 E.00279
; LINE_WIDTH: 0.331635
G1 F12469.049
G1 X170.474 Y179.418 E.00328
; LINE_WIDTH: 0.376092
G1 F10805.24
G1 X170.453 Y179.546 E.00344
; LINE_WIDTH: 0.400487
G1 F10068.065
G1 X170.396 Y179.848 E.00868
; CHANGE_LAYER
; Z_HEIGHT: 1.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F10068.065
G1 X170.453 Y179.546 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 7/54
; update layer progress
M73 L7
M991 S0 P6 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z1.6 I1.107 J-.506 P1  F60000
G1 X153.926 Y143.376 Z1.6
G1 Z1.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X153.635 Y143.317 E.00957
G3 X154.028 Y139.201 I.613 J-2.018 E.186
G1 X154.239 Y139.19 E.00677
G3 X154.061 Y143.4 I.009 J2.109 E.21933
G1 X153.985 Y143.386 E.00248
; COOLING_NODE: 0
M204 S10000
G1 X154.004 Y142.978 F60000
G1 F8843.478
M204 S8000
G1 X153.753 Y142.927 E.00823
G3 X154.071 Y139.607 I.495 J-1.628 E.15005
G1 X154.241 Y139.597 E.00547
G3 X154.099 Y142.994 I.007 J1.702 E.17695
G1 X154.063 Y142.988 E.00116
; COOLING_NODE: 0
M204 S250
G1 X154.079 Y142.594 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X153.868 Y142.552 E.00642
G3 X154.113 Y139.997 I.382 J-1.252 E.10692
G1 X154.244 Y139.99 E.00391
G3 X154.138 Y142.604 I.005 J1.309 E.12601
; COOLING_NODE: 0
; WIPE_START
M204 S8000
G1 X153.868 Y142.552 E-.10463
G1 X153.635 Y142.457 E-.09554
G1 X153.425 Y142.318 E-.09579
G1 X153.231 Y142.124 E-.10384
G1 X153.083 Y141.896 E-.10352
G1 X152.991 Y141.662 E-.0954
G1 X152.945 Y141.42 E-.09358
G1 X152.945 Y141.242 E-.0677
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X156.194 Y148.149 Z1.8 F60000
G1 X169.777 Y177.024 Z1.8
G1 Z1.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X169.952 Y177.286 E.01011
G3 X167.485 Y175.996 I-2.205 J1.213 E.41357
G1 X167.736 Y175.982 E.00806
G3 X169.681 Y176.888 I.011 J2.516 E.07127
G1 X169.742 Y176.976 E.00344
; COOLING_NODE: 0
M204 S10000
G1 X169.442 Y177.253 F60000
G1 F8843.478
M204 S8000
G1 X169.595 Y177.482 E.00884
G3 X167.528 Y176.401 I-1.847 J1.017 E.34665
G1 X167.738 Y176.39 E.00677
G3 X169.368 Y177.149 I.009 J2.109 E.05971
G1 X169.407 Y177.204 E.0022
; COOLING_NODE: 0
M204 S10000
G1 X169.107 Y177.482 F60000
G1 F8843.478
M204 S8000
G1 X169.239 Y177.677 E.00756
G3 X167.571 Y176.807 I-1.49 J.822 E.27973
G1 X167.741 Y176.797 E.00547
G3 X169.055 Y177.409 I.007 J1.702 E.04814
G1 X169.072 Y177.433 E.00097
; COOLING_NODE: 1
M204 S250
G1 X168.785 Y177.703 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X168.895 Y177.866 E.00585
G3 X167.613 Y177.197 I-1.146 J.633 E.19941
G1 X167.744 Y177.19 E.0039
G3 X168.75 Y177.655 I.005 J1.309 E.03408
; COOLING_NODE: 1
; WIPE_START
M204 S8000
G1 X168.895 Y177.866 E-.09746
G1 X169.003 Y178.117 E-.10371
G1 X169.055 Y178.38 E-.1019
G1 X169.053 Y178.636 E-.09753
G1 X169.003 Y178.884 E-.09594
G1 X168.896 Y179.134 E-.10348
G1 X168.754 Y179.342 E-.09554
G1 X168.633 Y179.461 E-.06444
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X165 Y172.749 Z1.8 F60000
G1 X153.955 Y152.35 Z1.8
G1 Z1.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X154.055 Y152.282 E.00388
G3 X154.985 Y151.996 I1.192 J2.216 E.0315
G1 X155.236 Y151.982 E.00806
G3 X153.66 Y152.546 I.011 J2.516 E.45354
G1 X153.905 Y152.384 E.00947
; COOLING_NODE: 1
M204 S10000
G1 X154.181 Y152.688 F60000
G1 F8843.478
M204 S8000
G1 X154.249 Y152.641 E.00265
G3 X155.028 Y152.401 I.999 J1.858 E.02639
G1 X155.238 Y152.39 E.00677
G3 X153.918 Y152.862 I.009 J2.109 E.38014
G1 X154.131 Y152.721 E.00821
; COOLING_NODE: 1
M204 S10000
G1 X154.406 Y153.025 F60000
G1 F8843.478
M204 S8000
G1 X154.443 Y153 E.00143
G3 X155.071 Y152.807 I.806 J1.499 E.02129
G1 X155.241 Y152.797 E.00547
G3 X154.176 Y153.178 I.007 J1.702 E.30674
G1 X154.356 Y153.058 E.00695
; COOLING_NODE: 2
M204 S250
G1 X154.623 Y153.35 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X154.629 Y153.346 E.00024
G3 X155.113 Y153.197 I.62 J1.153 E.01516
G1 X155.244 Y153.19 E.0039
G3 X154.425 Y153.482 I.005 J1.309 E.21865
G1 X154.573 Y153.384 E.0053
; COOLING_NODE: 2
; WIPE_START
M204 S8000
G1 X154.629 Y153.346 E-.02582
G1 X154.866 Y153.247 E-.09745
G1 X155.113 Y153.197 E-.09569
G1 X155.244 Y153.19 E-.04981
G1 X155.499 Y153.214 E-.09741
G1 X155.741 Y153.285 E-.09603
G1 X155.982 Y153.413 E-.10372
G1 X156.092 Y153.496 E-.052
G1 X156.254 Y153.659 E-.08748
G1 X156.336 Y153.777 E-.05459
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X163.811 Y152.235 Z1.8 F60000
G1 X204.828 Y143.772 Z1.8
G1 Z1.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X204.51 Y143.705 E.01046
G3 X204.985 Y138.796 I.737 J-2.406 E.22176
G1 X205.236 Y138.782 E.00807
G3 X204.989 Y143.802 I.011 J2.517 E.26286
G1 X204.887 Y143.783 E.00333
; COOLING_NODE: 2
M204 S10000
G1 X204.91 Y143.374 F60000
G1 F8843.478
M204 S8000
G1 X204.63 Y143.316 E.00918
G3 X205.028 Y139.201 I.617 J-2.017 E.18588
G1 X205.239 Y139.19 E.00677
G3 X205.031 Y143.397 I.009 J2.109 E.22033
G1 X204.969 Y143.385 E.00205
; COOLING_NODE: 2
M204 S10000
G1 X204.991 Y142.977 F60000
G1 F8843.478
M204 S8000
G1 X204.751 Y142.927 E.00789
G3 X205.071 Y139.607 I.498 J-1.627 E.14999
G1 X205.241 Y139.597 E.00547
G3 X205.073 Y142.992 I.007 J1.702 E.17779
G1 X205.05 Y142.988 E.00077
; COOLING_NODE: 3
M204 S250
G1 X205.069 Y142.594 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X204.867 Y142.552 E.00616
G3 X205.113 Y139.997 I.383 J-1.252 E.10691
G1 X205.244 Y139.99 E.00391
G3 X205.128 Y142.603 I.005 J1.31 E.12632
; COOLING_NODE: 3
; WIPE_START
M204 S8000
G1 X204.867 Y142.552 E-.10133
G1 X204.616 Y142.446 E-.10342
G1 X204.412 Y142.308 E-.0935
G1 X204.245 Y142.141 E-.08964
G1 X204.104 Y141.935 E-.09509
G1 X203.997 Y141.683 E-.10386
G1 X203.947 Y141.436 E-.09591
G1 X203.945 Y141.233 E-.07726
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X196.374 Y142.2 Z1.8 F60000
G1 X151.666 Y147.916 Z1.8
G1 Z1.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X151.666 Y142.147 E.18553
G1 X151.87 Y142.112 E.00665
G2 X151.87 Y140.488 I2.375 J-.812 E.45404
G1 X151.666 Y140.454 E.00665
G1 X151.666 Y137.916 E.0816
G1 X208.334 Y137.916 E1.82222
G1 X208.334 Y151.584 E.4395
G1 X170.834 Y151.584 E1.20586
G1 X170.834 Y182.084 E.98077
G1 X141.666 Y182.084 E.93792
G1 X141.666 Y147.916 E1.09871
G1 X151.606 Y147.916 E.31963
; COOLING_NODE: 3
M204 S10000
G1 X151.259 Y147.509 F60000
G1 F8843.478
M204 S8000
G1 X151.259 Y137.509 E.32156
G1 X208.741 Y137.509 E1.8484
G1 X208.741 Y151.991 E.46568
G1 X171.241 Y151.991 E1.20586
G1 X171.241 Y182.491 E.98077
G1 X141.259 Y182.491 E.9641
G1 X141.259 Y147.509 E1.12489
G1 X151.199 Y147.509 E.31963
; COOLING_NODE: 3
M204 S10000
G1 X150.852 Y147.102 F60000
G1 F8843.478
M204 S8000
G1 X150.852 Y137.102 E.32156
G1 X209.148 Y137.102 E1.87458
G1 X209.148 Y152.398 E.49186
G1 X171.648 Y152.398 E1.20586
G1 X171.648 Y182.898 E.98077
G1 X140.852 Y182.898 E.99028
G1 X140.852 Y147.102 E1.15107
G1 X150.792 Y147.102 E.31963
; COOLING_NODE: 4
M204 S250
G1 X150.46 Y146.71 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
M73 P73 R4
G1 F9547.055
M204 S5000
G1 X150.46 Y136.71 E.29787
G1 X209.54 Y136.71 E1.75979
G1 X209.54 Y152.79 E.47897
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X172.04 Y152.79 E1.117
G1 X172.04 Y183.29 E.90849
G1 X140.46 Y183.29 E.94066
G1 X140.46 Y146.71 E1.08959
G1 X150.4 Y146.71 E.29608
; WIPE_START
M204 S8000
G1 X150.412 Y144.71 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X151.83 Y147.307 Z1.8 F60000
G1 Z1.4
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42102
G1 F9521.29
M204 S8000
G1 X156.432 Y151.909 E.19438
G2 X155.68 Y151.692 I-1.089 J2.362 E.02346
G1 X151.999 Y148.011 E.15546
G1 X151.999 Y148.249 E.00711
G1 X151.703 Y148.249 E.00886
G1 X155.115 Y151.662 E.14413
G2 X154.645 Y151.726 I-.073 J1.224 E.01428
G1 X151.168 Y148.249 E.14684
G1 X150.633 Y148.249 E.01597
G1 X154.226 Y151.842 E.15175
G2 X153.862 Y152.012 I1.093 J2.812 E.01202
G1 X150.099 Y148.249 E.15895
G1 X149.564 Y148.249 E.01597
G1 X153.541 Y152.226 E.16799
G2 X153.249 Y152.469 I.689 J1.125 E.01138
G1 X149.029 Y148.249 E.17824
G1 X148.495 Y148.249 E.01597
G1 X153 Y152.755 E.19032
G1 X152.785 Y153.075 E.01151
G1 X147.96 Y148.249 E.20382
G1 X147.425 Y148.249 E.01597
G1 X152.615 Y153.439 E.21921
G2 X152.479 Y153.838 I1.305 J.668 E.01263
G1 X146.89 Y148.249 E.23606
G1 X146.356 Y148.249 E.01597
G1 X152.409 Y154.302 E.25567
G2 X152.425 Y154.853 I2.799 J.194 E.01648
G1 X145.821 Y148.249 E.27893
G1 X145.286 Y148.249 E.01597
G1 X152.61 Y155.573 E.30934
G2 X153.065 Y156.333 I2.602 J-1.043 E.02658
G1 X153.449 Y156.712 E.0161
G2 X154.177 Y157.14 I1.982 J-2.537 E.0253
G1 X170.501 Y173.464 E.68949
G1 X170.501 Y172.929 E.01597
G1 X154.898 Y157.326 E.65905
G2 X155.448 Y157.341 I.356 J-2.855 E.01646
G1 X170.501 Y172.394 E.63581
G1 X170.501 Y171.86 E.01597
G1 X155.906 Y157.264 E.61648
G2 X156.31 Y157.134 I-.132 J-1.102 E.01277
G1 X170.501 Y171.325 E.5994
G1 X170.501 Y170.79 E.01597
G1 X156.676 Y156.966 E.58393
G2 X156.996 Y156.751 I-.924 J-1.723 E.01153
G1 X170.501 Y170.255 E.57041
G1 X170.501 Y169.721 E.01597
G1 X157.281 Y156.501 E.55839
G2 X157.524 Y156.209 I-.905 J-1.002 E.01138
G1 X170.501 Y169.186 E.54813
G1 X170.501 Y168.651 E.01597
G1 X157.739 Y155.889 E.53905
G2 X157.908 Y155.524 I-3.207 J-1.708 E.01203
G1 X170.501 Y168.117 E.5319
G1 X170.501 Y167.582 E.01597
G1 X158.024 Y155.105 E.52699
G2 X158.094 Y154.641 I-1.509 J-.466 E.01408
G1 X170.501 Y167.047 E.52402
G1 X170.501 Y166.512 E.01597
G1 X158.067 Y154.078 E.52519
G2 X157.843 Y153.32 I-2.29 J.263 E.02373
G1 X170.501 Y165.978 E.53464
G1 X170.501 Y165.443 E.01597
G1 X151.999 Y146.942 E.78147
G1 X151.999 Y146.407 E.01597
G1 X170.501 Y164.908 E.78147
G1 X170.501 Y164.374 E.01597
G1 X151.999 Y145.872 E.78147
G1 X151.999 Y145.338 E.01597
G1 X170.501 Y163.839 E.78147
G1 X170.501 Y163.304 E.01597
G1 X151.999 Y144.803 E.78147
G1 X151.999 Y144.268 E.01597
G1 X170.501 Y162.769 E.78147
G1 X170.501 Y162.235 E.01597
G1 X151.999 Y143.733 E.78147
G1 X151.999 Y143.462 E.0081
G1 X152.138 Y143.337 E.00557
G1 X170.501 Y161.7 E.77561
G1 X170.501 Y161.165 E.01597
G1 X153.326 Y143.991 E.72543
G2 X153.998 Y144.128 I.784 J-2.12 E.02057
G1 X170.501 Y160.631 E.69704
G1 X170.501 Y160.096 E.01597
G1 X154.541 Y144.136 E.6741
G2 X154.985 Y144.045 I-.369 J-2.913 E.01353
G1 X170.501 Y159.561 E.65537
G1 X170.501 Y159.026 E.01597
G1 X155.388 Y143.914 E.63834
G2 X155.734 Y143.725 I-.49 J-1.314 E.01182
G1 X170.501 Y158.492 E.62371
G1 X170.501 Y157.957 E.01597
G1 X156.053 Y143.51 E.61024
G1 X156.323 Y143.244 E.01129
G1 X170.501 Y157.422 E.59886
G1 X170.501 Y156.888 E.01597
G1 X156.562 Y142.949 E.58874
G2 X156.772 Y142.625 I-.998 J-.878 E.01159
G1 X170.501 Y156.353 E.57986
G1 X170.501 Y155.818 E.01597
G1 X156.934 Y142.252 E.57302
G2 X157.049 Y141.832 I-2.933 J-1.03 E.01301
G1 X170.501 Y155.283 E.56816
G1 X170.501 Y154.749 E.01597
G1 X157.099 Y141.347 E.56605
G1 X157.051 Y140.765 E.01746
G1 X170.501 Y154.214 E.56807
G1 X170.501 Y153.679 E.01597
G1 X155.315 Y138.493 E.64143
G1 X155.332 Y138.249 E.00731
G1 X155.605 Y138.249 E.00817
G1 X170.501 Y153.145 E.62915
M73 P74 R4
G1 X170.501 Y152.61 E.01597
G1 X156.14 Y138.249 E.60657
G1 X156.675 Y138.249 E.01597
G1 X170.501 Y152.075 E.58398
G1 X170.501 Y151.54 E.01597
G1 X157.21 Y138.249 E.5614
G1 X157.744 Y138.249 E.01597
G1 X170.746 Y151.251 E.54916
G1 X171.28 Y151.251 E.01597
G1 X158.279 Y138.249 E.54916
G1 X158.814 Y138.249 E.01597
G1 X171.815 Y151.251 E.54915
G1 X172.35 Y151.251 E.01597
G1 X159.348 Y138.249 E.54916
G1 X159.883 Y138.249 E.01597
G1 X172.884 Y151.251 E.54916
G1 X173.419 Y151.251 E.01597
G1 X160.418 Y138.249 E.54916
G1 X160.953 Y138.249 E.01597
G1 X173.954 Y151.251 E.54916
G1 X174.489 Y151.251 E.01597
G1 X161.487 Y138.249 E.54916
G1 X162.022 Y138.249 E.01597
G1 X175.023 Y151.251 E.54916
G1 X175.558 Y151.251 E.01597
G1 X162.557 Y138.249 E.54915
G1 X163.091 Y138.249 E.01597
G1 X176.093 Y151.251 E.54916
G1 X176.627 Y151.251 E.01597
G1 X163.626 Y138.249 E.54916
G1 X164.161 Y138.249 E.01597
G1 X177.162 Y151.251 E.54916
G1 X177.697 Y151.251 E.01597
G1 X164.696 Y138.249 E.54916
G1 X165.23 Y138.249 E.01597
G1 X178.232 Y151.251 E.54915
G1 X178.766 Y151.251 E.01597
G1 X165.765 Y138.249 E.54916
G1 X166.3 Y138.249 E.01597
G1 X179.301 Y151.251 E.54916
G1 X179.836 Y151.251 E.01597
G1 X166.834 Y138.249 E.54916
G1 X167.369 Y138.249 E.01597
G1 X180.37 Y151.251 E.54916
G1 X180.905 Y151.251 E.01597
G1 X167.904 Y138.249 E.54916
G1 X168.439 Y138.249 E.01597
G1 X181.44 Y151.251 E.54916
G1 X181.975 Y151.251 E.01597
G1 X168.973 Y138.249 E.54915
G1 X169.508 Y138.249 E.01597
G1 X182.509 Y151.251 E.54916
G1 X183.044 Y151.251 E.01597
G1 X170.043 Y138.249 E.54916
G1 X170.577 Y138.249 E.01597
G1 X183.579 Y151.251 E.54916
G1 X184.113 Y151.251 E.01597
G1 X171.112 Y138.249 E.54916
G1 X171.647 Y138.249 E.01597
G1 X184.648 Y151.251 E.54915
G1 X185.183 Y151.251 E.01597
G1 X172.182 Y138.249 E.54916
G1 X172.716 Y138.249 E.01597
G1 X185.718 Y151.251 E.54916
G1 X186.252 Y151.251 E.01597
G1 X173.251 Y138.249 E.54916
G1 X173.786 Y138.249 E.01597
G1 X186.787 Y151.251 E.54916
G1 X187.322 Y151.251 E.01597
G1 X174.32 Y138.249 E.54916
G1 X174.855 Y138.249 E.01597
G1 X187.856 Y151.251 E.54916
G1 X188.391 Y151.251 E.01597
G1 X175.39 Y138.249 E.54915
G1 X175.925 Y138.249 E.01597
G1 X188.926 Y151.251 E.54916
G1 X189.461 Y151.251 E.01597
G1 X176.459 Y138.249 E.54916
G1 X176.994 Y138.249 E.01597
G1 X189.995 Y151.251 E.54916
G1 X190.53 Y151.251 E.01597
G1 X177.529 Y138.249 E.54916
G1 X178.063 Y138.249 E.01597
G1 X191.065 Y151.251 E.54916
G1 X191.599 Y151.251 E.01597
G1 X178.598 Y138.249 E.54916
G1 X179.133 Y138.249 E.01597
G1 X192.134 Y151.251 E.54916
G1 X192.669 Y151.251 E.01597
G1 X179.668 Y138.249 E.54916
G1 X180.202 Y138.249 E.01597
G1 X193.204 Y151.251 E.54916
G1 X193.738 Y151.251 E.01597
G1 X180.737 Y138.249 E.54916
G1 X181.272 Y138.249 E.01597
G1 X194.273 Y151.251 E.54916
G1 X194.808 Y151.251 E.01597
G1 X181.806 Y138.249 E.54916
G1 X182.341 Y138.249 E.01597
G1 X195.342 Y151.251 E.54916
G1 X195.877 Y151.251 E.01597
G1 X182.876 Y138.249 E.54916
G1 X183.411 Y138.249 E.01597
G1 X196.412 Y151.251 E.54916
G1 X196.947 Y151.251 E.01597
G1 X183.945 Y138.249 E.54916
G1 X184.48 Y138.249 E.01597
G1 X197.481 Y151.251 E.54916
G1 X198.016 Y151.251 E.01597
G1 X185.015 Y138.249 E.54916
G1 X185.549 Y138.249 E.01597
G1 X198.551 Y151.251 E.54916
G1 X199.085 Y151.251 E.01597
G1 X186.084 Y138.249 E.54916
G1 X186.619 Y138.249 E.01597
G1 X199.62 Y151.251 E.54916
G1 X200.155 Y151.251 E.01597
G1 X187.154 Y138.249 E.54916
G1 X187.688 Y138.249 E.01597
G1 X200.69 Y151.251 E.54916
G1 X201.224 Y151.251 E.01597
G1 X188.223 Y138.249 E.54916
G1 X188.758 Y138.249 E.01597
G1 X201.759 Y151.251 E.54916
G1 X202.294 Y151.251 E.01597
G1 X189.292 Y138.249 E.54916
G1 X189.827 Y138.249 E.01597
G1 X202.828 Y151.251 E.54916
G1 X203.363 Y151.251 E.01597
M73 P75 R4
G1 X190.362 Y138.249 E.54916
G1 X190.897 Y138.249 E.01597
M73 P75 R3
G1 X203.898 Y151.251 E.54916
G1 X204.433 Y151.251 E.01597
G1 X191.431 Y138.249 E.54916
G1 X191.966 Y138.249 E.01597
G1 X204.967 Y151.251 E.54916
G1 X205.502 Y151.251 E.01597
G1 X192.501 Y138.249 E.54916
G1 X193.035 Y138.249 E.01597
G1 X206.037 Y151.251 E.54916
G1 X206.571 Y151.251 E.01597
G1 X193.57 Y138.249 E.54916
G1 X194.105 Y138.249 E.01597
G1 X207.106 Y151.251 E.54916
G1 X207.641 Y151.251 E.01597
G1 X194.64 Y138.249 E.54916
G1 X195.174 Y138.249 E.01597
G1 X208.001 Y151.076 E.54177
G1 X208.001 Y150.541 E.01597
G1 X195.709 Y138.249 E.51918
G1 X196.244 Y138.249 E.01597
G1 X208.001 Y150.006 E.4966
G1 X208.001 Y149.472 E.01597
G1 X196.778 Y138.249 E.47401
G1 X197.313 Y138.249 E.01597
G1 X208.001 Y148.937 E.45143
G1 X208.001 Y148.402 E.01597
G1 X197.848 Y138.249 E.42884
G1 X198.383 Y138.249 E.01597
G1 X208.001 Y147.867 E.40626
G1 X208.001 Y147.333 E.01597
G1 X204.767 Y144.099 E.13658
G1 X204.954 Y144.137 E.00571
G1 X205.343 Y144.14 E.0116
G1 X208.001 Y146.798 E.11227
G1 X208.001 Y146.263 E.01597
G1 X205.828 Y144.091 E.09176
G2 X206.242 Y143.97 I-.369 J-2.026 E.01289
G1 X208.001 Y145.729 E.07429
G1 X208.001 Y145.194 E.01597
G1 X206.611 Y143.805 E.05868
G1 X206.933 Y143.591 E.01152
G1 X208.001 Y144.659 E.04511
G1 X208.001 Y144.124 E.01597
G1 X207.221 Y143.345 E.03293
G2 X207.48 Y143.069 I-.585 J-.809 E.01137
G1 X208.17 Y143.759 E.02916
M204 S10000
G1 X208.17 Y143.225 F60000
G1 F9521.29
M204 S8000
G1 X207.851 Y142.905 E.01349
M204 S10000
G1 X207.654 Y142.577 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.433781
G1 F9210.446
M204 S8000
G1 X207.936 Y142.436 E.00972
; LINE_WIDTH: 0.408804
G1 F9839.193
G1 X207.959 Y142.307 E.00379
; LINE_WIDTH: 0.362482
G1 F11265.447
G1 X207.982 Y142.178 E.00331
; LINE_WIDTH: 0.319105
G1 F13034.763
G1 X208.002 Y142.028 E.0033
; LINE_WIDTH: 0.281772
G1 F15000
G1 X208.02 Y141.892 E.00258
; LINE_WIDTH: 0.240284
G1 X208.043 Y141.597 E.00462
; LINE_WIDTH: 0.208761
G1 X208.044 Y141.012 E.00767
; LINE_WIDTH: 0.238944
G1 X208.021 Y140.716 E.00459
; LINE_WIDTH: 0.28136
G1 X208.001 Y140.566 E.00285
; LINE_WIDTH: 0.319352
G1 F13023.124
G1 X207.983 Y140.428 E.00305
; LINE_WIDTH: 0.361536
G1 F11298.88
G1 X207.959 Y140.292 E.00348
; LINE_WIDTH: 0.408097
G1 F9858.231
G1 X207.937 Y140.17 E.00357
; LINE_WIDTH: 0.437453
G1 F9124.719
G1 X207.889 Y139.956 E.00682
; WIPE_START
G1 X207.937 Y140.17 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X206.365 Y138.624 Z1.8 F60000
G1 Z1.4
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F9547.299
M204 S8000
G1 X206.614 Y138.73 E.00806
G1 X207.07 Y139.029 E.01625
G1 X207.469 Y139.418 E.01658
G1 X207.616 Y139.616 E.00735
G1 X207.942 Y139.543 E.00995
G1 X207.942 Y138.308 E.03676
G1 X206.387 Y138.308 E.04631
G1 X206.369 Y138.564 E.00765
; WIPE_START
G1 X206.387 Y138.308 E-.09756
G1 X207.942 Y138.308 E-.59087
G1 X207.942 Y138.497 E-.07158
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X207.511 Y138.713 Z1.8 F60000
G1 Z1.4
G1 E.8 F1800
; LINE_WIDTH: 0.59544
G1 F6515.602
M204 S8000
G2 X207.516 Y138.825 I-.03 J.057 E.01186
; WIPE_START
G1 X207.442 Y138.833 E-.20002
G1 X207.408 Y138.773 E-.18666
G1 X207.442 Y138.713 E-.18666
G1 X207.511 Y138.713 E-.18666
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X205.988 Y138.388 Z1.8 F60000
G1 Z1.4
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.521733
G1 F7518.591
M204 S8000
G2 X204.514 Y138.39 I-.725 J6.774 E.05586
M204 S10000
G1 X204.289 Y138.808 F60000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42102
G1 F9521.29
M204 S8000
G1 X203.73 Y138.249 E.02361
G1 X203.195 Y138.249 E.01597
G1 X203.797 Y138.851 E.02541
G2 X203.479 Y139.068 I.879 J1.622 E.01151
G1 X202.66 Y138.249 E.03459
G1 X202.126 Y138.249 E.01597
G1 X203.206 Y139.329 E.04562
G2 X202.958 Y139.617 I.642 J.801 E.01139
G1 X201.591 Y138.249 E.05777
G1 X201.056 Y138.249 E.01597
G1 X202.745 Y139.939 E.07135
G2 X202.58 Y140.308 I1.673 J.969 E.01211
G1 X200.521 Y138.249 E.08697
G1 X199.987 Y138.249 E.01597
G1 X202.459 Y140.722 E.10443
G2 X202.41 Y141.207 I2.541 J.503 E.0146
G1 X199.452 Y138.249 E.12494
G1 X198.917 Y138.249 E.01597
G1 X202.668 Y142 E.15843
; WIPE_START
G1 X201.254 Y140.586 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X196.115 Y146.229 Z1.8 F60000
G1 X170.67 Y174.168 Z1.8
G1 Z1.4
G1 E.8 F1800
G1 F9521.29
M204 S8000
G1 X144.752 Y148.249 E1.09477
G1 X144.217 Y148.249 E.01597
G1 X170.501 Y174.533 E1.11019
G1 X170.501 Y175.068 E.01597
G1 X143.682 Y148.249 E1.13278
G1 X143.147 Y148.249 E.01597
G1 X170.501 Y175.603 E1.15536
G1 X170.501 Y176.137 E.01597
G1 X142.613 Y148.249 E1.17795
G1 X142.078 Y148.249 E.01597
G1 X170.501 Y176.672 E1.20053
G1 X170.501 Y176.79 E.00353
G1 X170.161 Y176.867 E.0104
G1 X141.999 Y148.705 E1.1895
G1 X141.999 Y149.24 E.01597
G1 X168.514 Y175.754 E1.11992
G1 X168.004 Y175.659 E.01549
G1 X167.884 Y175.66 E.00358
G1 X141.999 Y149.775 E1.09333
G1 X141.999 Y150.31 E.01597
G1 X167.369 Y175.68 E1.07159
G1 X166.926 Y175.771 E.01352
G1 X141.999 Y150.844 E1.05286
G1 X141.999 Y151.379 E.01597
G1 X166.541 Y175.921 E1.03661
G2 X166.204 Y176.118 I.518 J1.272 E.01171
G1 X141.999 Y151.914 E1.02236
G1 X141.999 Y152.448 E.01597
G1 X165.892 Y176.341 E1.00918
G2 X165.623 Y176.607 I1.156 J1.439 E.01131
G1 X141.999 Y152.983 E.99782
G1 X141.999 Y153.518 E.01597
G1 X165.394 Y176.913 E.98817
G2 X165.197 Y177.25 I.79 J.69 E.01174
G1 X141.999 Y154.053 E.97982
G1 X141.999 Y154.587 E.01597
G1 X165.036 Y177.624 E.97305
G2 X164.936 Y178.059 I3.901 J1.124 E.01333
G1 X141.999 Y155.122 E.96883
G1 X141.999 Y155.657 E.01597
G1 X164.901 Y178.559 E.96735
G2 X164.992 Y179.184 I2.112 J.013 E.01895
G1 X141.999 Y156.191 E.97118
G1 X141.999 Y156.726 E.01597
G1 X167.024 Y181.751 E1.057
G1 X167.559 Y181.751 E.01597
G1 X167.066 Y181.258 E.0208
M73 P76 R3
G2 X167.691 Y181.349 I.613 J-2.033 E.01894
G1 X168.093 Y181.751 E.01698
G1 X168.628 Y181.751 E.01597
G1 X168.186 Y181.309 E.01867
G1 X168.623 Y181.211 E.01338
G1 X169.163 Y181.751 E.02279
G1 X169.697 Y181.751 E.01597
G1 X169.002 Y181.055 E.02938
G2 X169.345 Y180.863 I-1.455 J-3.007 E.01174
G1 X170.232 Y181.751 E.03748
G1 X170.501 Y181.751 E.00802
G1 X170.501 Y181.484 E.00795
G1 X169.641 Y180.624 E.03633
G1 X169.909 Y180.358 E.01129
G1 X170.501 Y180.95 E.02498
G1 X170.501 Y180.415 E.01597
G1 X170.01 Y179.925 E.02071
M204 S10000
G1 X170.389 Y179.843 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.437144
G1 F9131.867
M204 S8000
G1 X170.437 Y179.629 E.00683
; LINE_WIDTH: 0.404438
G1 F9958.034
G1 X170.462 Y179.489 E.00405
; LINE_WIDTH: 0.355146
G1 F11530.12
G1 X170.486 Y179.35 E.0035
; LINE_WIDTH: 0.328382
G1 F12611.143
G1 X170.489 Y179.336 E.00032
; LINE_WIDTH: 0.309995
G1 F13479.366
G1 X170.505 Y179.207 E.00274
; LINE_WIDTH: 0.276221
G1 F15000
G1 X170.522 Y179.067 E.00259
; LINE_WIDTH: 0.237381
G1 X170.544 Y178.786 E.00432
; LINE_WIDTH: 0.20818
G1 X170.545 Y178.235 E.00719
; LINE_WIDTH: 0.234219
G1 X170.524 Y177.953 E.00427
; LINE_WIDTH: 0.272204
G1 X170.507 Y177.811 E.00259
; LINE_WIDTH: 0.308943
G1 F13532.666
G1 X170.487 Y177.655 E.00332
; LINE_WIDTH: 0.353939
G1 F11574.852
G1 X170.462 Y177.513 E.00354
; LINE_WIDTH: 0.403913
G1 F9972.492
G1 X170.437 Y177.371 E.00411
; LINE_WIDTH: 0.437052
G1 F9134.001
G1 X170.389 Y177.157 E.00684
; WIPE_START
G1 X170.437 Y177.371 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X166.659 Y181.92 Z1.8 F60000
G1 Z1.4
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42102
G1 F9521.29
M204 S8000
G1 X141.999 Y157.261 E1.04158
G1 X141.999 Y157.796 E.01597
G1 X165.954 Y181.751 E1.01183
G1 X165.42 Y181.751 E.01597
G1 X141.999 Y158.33 E.98924
G1 X141.999 Y158.865 E.01597
G1 X164.885 Y181.751 E.96666
G1 X164.35 Y181.751 E.01597
G1 X141.999 Y159.4 E.94407
G1 X141.999 Y159.934 E.01597
G1 X163.816 Y181.751 E.92148
G1 X163.281 Y181.751 E.01597
G1 X141.999 Y160.469 E.8989
G1 X141.999 Y161.004 E.01597
G1 X162.746 Y181.751 E.87631
G1 X162.211 Y181.751 E.01597
G1 X141.999 Y161.539 E.85373
G1 X141.999 Y162.073 E.01597
G1 X161.677 Y181.751 E.83114
G1 X161.142 Y181.751 E.01597
G1 X141.999 Y162.608 E.80856
G1 X141.999 Y163.143 E.01597
G1 X160.607 Y181.751 E.78597
G1 X160.073 Y181.751 E.01597
G1 X141.999 Y163.677 E.76339
G1 X141.999 Y164.212 E.01597
G1 X159.538 Y181.751 E.7408
G1 X159.003 Y181.751 E.01597
G1 X141.999 Y164.747 E.71821
G1 X141.999 Y165.282 E.01597
G1 X158.468 Y181.751 E.69563
G1 X157.934 Y181.751 E.01597
G1 X141.999 Y165.816 E.67304
G1 X141.999 Y166.351 E.01597
G1 X157.399 Y181.751 E.65046
G1 X156.864 Y181.751 E.01597
G1 X141.999 Y166.886 E.62787
G1 X141.999 Y167.42 E.01597
G1 X156.33 Y181.751 E.60529
G1 X155.795 Y181.751 E.01597
G1 X141.999 Y167.955 E.5827
G1 X141.999 Y168.49 E.01597
G1 X155.26 Y181.751 E.56012
G1 X154.725 Y181.751 E.01597
G1 X141.999 Y169.025 E.53753
G1 X141.999 Y169.559 E.01597
G1 X154.191 Y181.751 E.51494
G1 X153.656 Y181.751 E.01597
G1 X141.999 Y170.094 E.49236
G1 X141.999 Y170.629 E.01597
G1 X153.121 Y181.751 E.46977
G1 X152.587 Y181.751 E.01597
G1 X141.999 Y171.163 E.44719
G1 X141.999 Y171.698 E.01597
G1 X152.052 Y181.751 E.4246
G1 X151.517 Y181.751 E.01597
G1 X141.999 Y172.233 E.40202
G1 X141.999 Y172.768 E.01597
G1 X150.982 Y181.751 E.37943
G1 X150.448 Y181.751 E.01597
G1 X141.999 Y173.302 E.35685
G1 X141.999 Y173.837 E.01597
G1 X149.913 Y181.751 E.33426
G1 X149.378 Y181.751 E.01597
G1 X141.999 Y174.372 E.31167
G1 X141.999 Y174.906 E.01597
G1 X148.844 Y181.751 E.28909
G1 X148.309 Y181.751 E.01597
G1 X141.999 Y175.441 E.2665
G1 X141.999 Y175.976 E.01597
G1 X147.774 Y181.751 E.24392
G1 X147.239 Y181.751 E.01597
G1 X141.999 Y176.511 E.22133
G1 X141.999 Y177.045 E.01597
G1 X146.705 Y181.751 E.19875
G1 X146.17 Y181.751 E.01597
G1 X141.999 Y177.58 E.17616
G1 X141.999 Y178.115 E.01597
G1 X145.635 Y181.751 E.15358
G1 X145.101 Y181.751 E.01597
G1 X141.999 Y178.649 E.13099
G1 X141.999 Y179.184 E.01597
G1 X144.566 Y181.751 E.1084
G1 X144.031 Y181.751 E.01597
G1 X141.999 Y179.719 E.08582
G1 X141.999 Y180.254 E.01597
G1 X143.496 Y181.751 E.06323
G1 X142.962 Y181.751 E.01597
G1 X141.999 Y180.788 E.04065
G1 X141.999 Y181.323 E.01597
G1 X142.597 Y181.92 E.02523
; WIPE_START
G1 X141.999 Y181.323 E-.32099
G1 X141.999 Y180.788 E-.20319
G1 X142.438 Y181.227 E-.23581
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X144.3 Y173.825 Z1.8 F60000
G1 X152.064 Y142.956 Z1.8
G1 Z1.4
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.121878
G1 F15000
M204 S8000
G1 X151.87 Y142.734 E.00184
M204 S10000
G1 X151.732 Y141.929 F60000
; LINE_WIDTH: 0.531343
G1 F7370.664
M204 S8000
G3 X151.732 Y140.671 I6.005 J-.63 E.04862
M204 S10000
G1 X151.87 Y139.872 F60000
; LINE_WIDTH: 0.11784
G1 F15000
M204 S8000
G1 X152.05 Y139.662 E.00164
; WIPE_START
G1 X151.87 Y139.872 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X153.06 Y138.573 Z1.8 F60000
G1 Z1.4
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.5705
G1 F6823.61
M204 S8000
G1 X153.045 Y138.384 E.0079
G1 X152.134 Y138.384 E.03799
G1 X152.134 Y139.129 E.03107
G1 X152.221 Y139.123 E.00365
G1 X152.811 Y138.686 E.03059
G1 X153.005 Y138.597 E.00892
M204 S10000
G1 X153.514 Y138.39 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.521725
G1 F7518.732
M204 S8000
G3 X154.988 Y138.388 I.748 J6.775 E.05585
; CHANGE_LAYER
; Z_HEIGHT: 1.6
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F7518.732
G1 X154.244 Y138.349 E-.38375
G1 X153.514 Y138.39 E-.37625
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 8/54
; update layer progress
M73 L8
M991 S0 P7 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z1.8 I-1.211 J.119 P1  F60000
G1 X154.006 Y143.388 Z1.8
G1 Z1.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X153.886 Y143.376 E.00387
G3 X154.026 Y139.202 I.363 J-2.078 E.19416
G1 X154.225 Y139.19 E.00639
G3 X154.29 Y143.407 I.024 J2.109 E.21249
G1 X154.066 Y143.392 E.00724
; COOLING_NODE: 0
M204 S10000
G1 X154.037 Y142.983 F60000
G1 F8843.478
M204 S8000
G1 X153.956 Y142.975 E.00263
G3 X154.07 Y139.607 I.293 J-1.676 E.15667
G1 X154.229 Y139.597 E.00512
G3 X154.282 Y143 I.02 J1.702 E.17149
G1 X154.097 Y142.988 E.00596
; COOLING_NODE: 0
M204 S250
G1 X154.067 Y142.594 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X154.023 Y142.589 E.00133
G3 X154.113 Y139.997 I.226 J-1.29 E.11167
G1 X154.233 Y139.99 E.00361
G3 X154.274 Y142.608 I.016 J1.309 E.12227
G1 X154.127 Y142.598 E.00438
; COOLING_NODE: 0
; WIPE_START
M204 S8000
G1 X154.023 Y142.589 E-.03974
G1 X153.78 Y142.523 E-.09575
G1 X153.537 Y142.399 E-.10344
G1 X153.34 Y142.242 E-.09585
G1 X153.177 Y142.052 E-.09535
G1 X153.053 Y141.833 E-.09547
G1 X152.973 Y141.594 E-.09573
G1 X152.94 Y141.323 E-.10371
G1 X152.947 Y141.231 E-.03496
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X156.191 Y148.141 Z2 F60000
G1 X169.706 Y176.931 Z2
G1 Z1.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X169.811 Y177.057 E.00528
G3 X167.483 Y175.996 I-2.062 J1.442 E.4221
G1 X167.72 Y175.982 E.00766
G3 X169.493 Y176.686 I.028 J2.516 E.06292
G1 X169.666 Y176.885 E.00849
; COOLING_NODE: 0
M204 S10000
G1 X169.398 Y177.195 F60000
G1 F8843.478
M204 S8000
G1 X169.477 Y177.29 E.00399
G3 X167.526 Y176.401 I-1.728 J1.208 E.3538
G1 X167.725 Y176.39 E.00638
G3 X169.212 Y176.98 I.024 J2.109 E.05277
G1 X169.359 Y177.149 E.00721
; COOLING_NODE: 0
M204 S10000
G1 X169.09 Y177.459 F60000
G1 F8843.478
M204 S8000
G1 X169.144 Y177.524 E.00271
G3 X167.57 Y176.807 I-1.395 J.975 E.28549
G1 X167.729 Y176.797 E.00511
G3 X168.93 Y177.274 I.02 J1.702 E.04263
G1 X169.051 Y177.414 E.00593
; COOLING_NODE: 1
M204 S250
G1 X168.793 Y177.713 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X168.823 Y177.749 E.00138
G3 X167.613 Y177.197 I-1.073 J.75 E.20351
G1 X167.733 Y177.19 E.0036
G3 X168.659 Y177.557 I.016 J1.309 E.03043
G1 X168.754 Y177.668 E.00434
; COOLING_NODE: 1
; WIPE_START
M204 S8000
G1 X168.823 Y177.749 E-.04038
G1 X168.956 Y177.988 E-.10421
G1 X169.031 Y178.227 E-.09517
G1 X169.06 Y178.476 E-.09507
G1 X169.04 Y178.727 E-.0958
G1 X168.971 Y178.975 E-.09795
G1 X168.849 Y179.213 E-.10136
G1 X168.692 Y179.41 E-.096
G1 X168.624 Y179.468 E-.03406
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X165.039 Y172.73 Z2 F60000
G1 X154.145 Y152.247 Z2
G1 Z1.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X154.478 Y152.103 E.01168
G3 X154.983 Y151.996 I.77 J2.396 E.0166
G1 X155.22 Y151.982 E.00766
G3 X154.035 Y152.294 I.028 J2.516 E.46859
G1 X154.09 Y152.271 E.00193
; COOLING_NODE: 1
M204 S10000
G1 X154.306 Y152.62 F60000
G1 F8843.478
M204 S8000
G1 X154.603 Y152.491 E.01041
G3 X155.026 Y152.401 I.646 J2.008 E.01395
M73 P77 R3
G1 X155.225 Y152.39 E.00638
G3 X154.231 Y152.652 I.024 J2.109 E.39272
G1 X154.25 Y152.643 E.00068
; COOLING_NODE: 1
M204 S10000
G1 X154.466 Y152.992 F60000
G1 F8843.478
M204 S8000
G1 X154.727 Y152.879 E.00913
G3 X155.07 Y152.807 I.522 J1.62 E.01131
G1 X155.229 Y152.797 E.00511
G3 X154.412 Y153.017 I.02 J1.702 E.31631
; COOLING_NODE: 2
M204 S250
G1 X154.621 Y153.351 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X154.846 Y153.253 E.0073
G3 X155.113 Y153.197 I.403 J1.246 E.00812
G1 X155.233 Y153.19 E.0036
G3 X154.569 Y153.38 I.016 J1.309 E.22423
; COOLING_NODE: 2
; WIPE_START
M204 S8000
G1 X154.846 Y153.253 E-.11584
G1 X155.113 Y153.197 E-.10339
G1 X155.233 Y153.19 E-.04594
G1 X155.5 Y153.214 E-.10168
G1 X155.741 Y153.285 E-.0956
G1 X155.963 Y153.401 E-.09512
G1 X156.16 Y153.557 E-.09565
G1 X156.324 Y153.749 E-.09584
G1 X156.338 Y153.774 E-.01093
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X163.814 Y152.24 Z2 F60000
G1 X204.967 Y143.792 Z2
G1 Z1.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X204.818 Y143.778 E.00483
G3 X204.983 Y138.796 I.431 J-2.479 E.23174
G1 X205.22 Y138.782 E.00765
G3 X205.297 Y143.814 I.028 J2.516 E.25353
G1 X205.027 Y143.796 E.00871
; COOLING_NODE: 2
M204 S10000
G1 X204.998 Y143.387 F60000
G1 F8843.478
M204 S8000
G1 X204.887 Y143.377 E.00359
G3 X205.027 Y139.201 I.362 J-2.078 E.19422
G1 X205.225 Y139.19 E.00638
G3 X205.289 Y143.407 I.024 J2.109 E.21252
G1 X205.058 Y143.391 E.00745
; COOLING_NODE: 2
M204 S10000
G1 X205.029 Y142.983 F60000
G1 F8843.478
M204 S8000
G1 X204.956 Y142.975 E.00236
G3 X205.07 Y139.607 I.293 J-1.676 E.1567
G1 X205.229 Y139.597 E.00511
G3 X205.281 Y143 I.02 J1.702 E.17152
G1 X205.089 Y142.987 E.00619
; COOLING_NODE: 3
M204 S250
G1 X205.06 Y142.593 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X205.023 Y142.589 E.0011
G3 X205.113 Y139.997 I.226 J-1.29 E.11168
G1 X205.233 Y139.99 E.00361
G3 X205.274 Y142.608 I.016 J1.309 E.12229
G1 X205.12 Y142.598 E.0046
; COOLING_NODE: 3
; WIPE_START
M204 S8000
G1 X205.023 Y142.589 E-.03679
G1 X204.781 Y142.523 E-.09551
G1 X204.556 Y142.411 E-.09542
G1 X204.34 Y142.242 E-.10421
G1 X204.176 Y142.05 E-.09596
G1 X204.044 Y141.812 E-.10332
G1 X203.969 Y141.573 E-.09533
G1 X203.94 Y141.323 E-.09574
G1 X203.948 Y141.224 E-.0377
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X196.377 Y142.193 Z2 F60000
G1 X151.666 Y147.916 Z2
G1 Z1.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X151.666 Y142.145 E.18559
G1 X151.865 Y142.107 E.00651
G2 X151.87 Y140.488 I2.385 J-.803 E.45538
G1 X151.666 Y140.453 E.00665
G1 X151.666 Y137.916 E.08159
G1 X208.334 Y137.916 E1.82222
G1 X208.334 Y151.584 E.4395
G1 X170.834 Y151.584 E1.20586
G1 X170.834 Y182.084 E.98077
G1 X141.666 Y182.084 E.93792
G1 X141.666 Y147.916 E1.09871
G1 X151.606 Y147.916 E.31963
; COOLING_NODE: 3
M204 S10000
G1 X151.259 Y147.509 F60000
G1 F8843.478
M204 S8000
G1 X151.259 Y137.509 E.32156
G1 X208.741 Y137.509 E1.8484
G1 X208.741 Y151.991 E.46568
G1 X171.241 Y151.991 E1.20586
G1 X171.241 Y182.491 E.98077
G1 X141.259 Y182.491 E.9641
G1 X141.259 Y147.509 E1.12489
G1 X151.199 Y147.509 E.31963
; COOLING_NODE: 3
M204 S10000
G1 X150.852 Y147.102 F60000
G1 F8843.478
M204 S8000
G1 X150.852 Y137.102 E.32156
G1 X209.148 Y137.102 E1.87458
G1 X209.148 Y152.398 E.49186
G1 X171.648 Y152.398 E1.20586
G1 X171.648 Y182.898 E.98077
G1 X140.852 Y182.898 E.99028
G1 X140.852 Y147.102 E1.15107
G1 X150.792 Y147.102 E.31963
; COOLING_NODE: 4
M204 S250
G1 X150.46 Y146.71 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X150.46 Y136.71 E.29787
G1 X209.54 Y136.71 E1.75979
G1 X209.54 Y152.79 E.47897
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X172.04 Y152.79 E1.117
G1 X172.04 Y183.29 E.90849
G1 X140.46 Y183.29 E.94066
G1 X140.46 Y146.71 E1.08959
G1 X150.4 Y146.71 E.29608
; WIPE_START
M204 S8000
G1 X150.412 Y144.71 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X151.83 Y147.433 Z2 F60000
G1 Z1.6
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42234
G1 F9488.165
M204 S8000
G1 X155.341 Y143.921 E.14885
G3 X154.61 Y144.117 I-.911 J-1.944 E.02282
G1 X151.999 Y146.727 E.11064
G1 X151.999 Y146.19 E.01608
G1 X154.057 Y144.133 E.08721
G3 X153.59 Y144.063 I-.055 J-1.231 E.01424
G1 X151.999 Y145.654 E.06741
G1 X151.999 Y145.117 E.01608
G1 X153.177 Y143.94 E.04991
G3 X152.823 Y143.757 I.425 J-1.262 E.01199
G1 X151.999 Y144.581 E.03489
G1 X151.999 Y144.044 E.01608
G1 X152.494 Y143.547 E.02102
G3 X152.235 Y143.315 I.975 J-1.349 E.01044
G1 X152.037 Y143.502 E.00815
G1 X152.022 Y143.485 E.00068
G1 X151.83 Y143.677 E.00814
M204 S10000
G1 X152.092 Y142.993 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.109364
G1 F15000
M204 S8000
G1 X151.988 Y142.882 E.0008
; LINE_WIDTH: 0.13618
G1 X151.87 Y142.746 E.00133
M204 S10000
G1 X151.736 Y141.924 F60000
; LINE_WIDTH: 0.531793
G1 F7363.884
M204 S8000
G3 X151.731 Y140.671 I5.73 J-.65 E.04851
M204 S10000
G1 X151.87 Y139.877 F60000
; LINE_WIDTH: 0.116683
G1 F15000
M204 S8000
G1 X152.035 Y139.682 E.00149
; WIPE_START
G1 X151.87 Y139.877 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X153.064 Y138.588 Z2 F60000
G1 Z1.6
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.56565
G1 F6886.921
M204 S8000
G1 X153.047 Y138.381 E.00856
G1 X152.131 Y138.381 E.03783
G1 X152.131 Y139.159 E.03213
G1 X152.184 Y139.159 E.00218
G1 X152.613 Y138.809 E.02286
G1 X153.01 Y138.614 E.01825
M204 S10000
G1 X153.514 Y138.39 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.521737
G1 F7518.542
M204 S8000
G3 X154.988 Y138.388 I.748 J6.759 E.05585
M204 S10000
G1 X155.125 Y138.772 F60000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42234
G1 F9488.165
M204 S8000
G1 X155.648 Y138.249 E.02215
G1 X156.184 Y138.249 E.01608
G1 X155.621 Y138.812 E.02387
G3 X155.948 Y139.023 I-.379 J.948 E.01171
G1 X156.721 Y138.249 E.03277
G1 X157.257 Y138.249 E.01608
G1 X156.244 Y139.263 E.04295
G3 X156.493 Y139.551 I-.846 J.982 E.01144
G1 X157.794 Y138.249 E.05516
G1 X158.331 Y138.249 E.01608
G1 X156.712 Y139.868 E.06863
G3 X156.889 Y140.228 I-2.493 J1.453 E.01202
G1 X158.867 Y138.249 E.08386
G1 X159.404 Y138.249 E.01608
G1 X157.018 Y140.635 E.10113
G1 X157.041 Y140.707 E.00226
G1 X157.085 Y141.104 E.01197
G1 X159.94 Y138.249 E.12101
G1 X160.477 Y138.249 E.01608
G1 X157.07 Y141.656 E.14439
G1 X157.06 Y141.791 E.00408
G1 X156.889 Y142.373 E.01817
G1 X161.014 Y138.249 E.1748
G1 X161.55 Y138.249 E.01608
G1 X151.83 Y147.97 E.41201
; WIPE_START
M73 P78 R3
G1 X153.244 Y146.556 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X145.761 Y148.058 Z2 F60000
G1 X141.83 Y148.848 Z2
G1 Z1.6
G1 E.8 F1800
G1 F9488.165
M204 S8000
G1 X142.428 Y148.249 E.02537
G1 X142.965 Y148.249 E.01608
G1 X141.999 Y149.215 E.04092
G1 X141.999 Y149.751 E.01608
G1 X143.501 Y148.249 E.06367
G1 X144.038 Y148.249 E.01608
G1 X141.999 Y150.288 E.08641
G1 X141.999 Y150.825 E.01608
G1 X144.575 Y148.249 E.10915
G1 X145.111 Y148.249 E.01608
G1 X141.999 Y151.361 E.1319
G1 X141.999 Y151.898 E.01608
G1 X145.648 Y148.249 E.15464
G1 X146.184 Y148.249 E.01608
G1 X141.999 Y152.434 E.17738
G1 X141.999 Y152.971 E.01608
G1 X146.721 Y148.249 E.20013
G1 X147.257 Y148.249 E.01608
G1 X141.999 Y153.507 E.22287
G1 X141.999 Y154.044 E.01608
G1 X147.794 Y148.249 E.24561
G1 X148.331 Y148.249 E.01608
G1 X141.999 Y154.581 E.26836
G1 X141.999 Y155.117 E.01608
G1 X148.867 Y148.249 E.2911
G1 X149.404 Y148.249 E.01608
G1 X141.999 Y155.654 E.31384
G1 X141.999 Y156.19 E.01608
G1 X149.94 Y148.249 E.33659
G1 X150.477 Y148.249 E.01608
G1 X141.999 Y156.727 E.35933
G1 X141.999 Y157.264 E.01608
G1 X151.014 Y148.249 E.38208
G1 X151.55 Y148.249 E.01608
G1 X141.999 Y157.8 E.40482
G1 X141.999 Y158.337 E.01608
G1 X162.087 Y138.249 E.85142
G1 X162.623 Y138.249 E.01608
G1 X141.999 Y158.873 E.87417
G1 X141.999 Y159.41 E.01608
G1 X163.16 Y138.249 E.89691
G1 X163.696 Y138.249 E.01608
G1 X141.999 Y159.946 E.91965
G1 X141.999 Y160.483 E.01608
G1 X164.233 Y138.249 E.9424
G1 X164.77 Y138.249 E.01608
G1 X141.999 Y161.02 E.96514
G1 X141.999 Y161.556 E.01608
G1 X165.306 Y138.249 E.98788
G1 X165.843 Y138.249 E.01608
G1 X141.999 Y162.093 E1.01063
G1 X141.999 Y162.629 E.01608
G1 X166.379 Y138.249 E1.03337
G1 X166.916 Y138.249 E.01608
G1 X141.83 Y163.336 E1.06331
; WIPE_START
G1 X143.244 Y161.921 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X142.116 Y169.47 Z2 F60000
G1 X141.83 Y171.384 Z2
G1 Z1.6
G1 E.8 F1800
G1 F9488.165
M204 S8000
G1 X155.964 Y157.25 E.59908
G3 X155.328 Y157.349 I-.655 J-2.119 E.01935
G1 X141.999 Y170.678 E.56495
G1 X141.999 Y170.141 E.01608
G1 X154.824 Y157.317 E.54358
G3 X154.389 Y157.215 I.505 J-3.149 E.0134
G1 X141.999 Y169.605 E.52514
G1 X141.999 Y169.068 E.01608
G1 X154.005 Y157.063 E.50888
G3 X153.671 Y156.861 I.542 J-1.276 E.01175
G1 X141.999 Y168.532 E.49469
G1 X141.999 Y167.995 E.01608
G1 X153.362 Y156.632 E.48162
G3 X153.094 Y156.364 I1.143 J-1.409 E.01139
G1 X141.999 Y167.459 E.47026
G1 X141.999 Y166.922 E.01608
G1 X152.871 Y156.051 E.46079
G3 X152.678 Y155.706 I.771 J-.656 E.0119
G1 X141.999 Y166.385 E.45264
G1 X141.999 Y165.849 E.01608
G1 X152.524 Y155.324 E.44609
G1 X152.427 Y154.884 E.01351
G1 X141.999 Y165.312 E.442
G1 X141.999 Y164.776 E.01608
G1 X152.407 Y154.368 E.44112
G3 X152.504 Y153.734 I1.932 J-.028 E.01931
G1 X141.999 Y164.239 E.44525
G1 X141.999 Y163.703 E.01608
G1 X167.453 Y138.249 E1.07886
G1 X167.989 Y138.249 E.01608
G1 X154.481 Y151.758 E.57257
G3 X155.113 Y151.662 I.675 J2.317 E.01923
G1 X168.526 Y138.249 E.5685
G1 X169.062 Y138.249 E.01608
G1 X155.634 Y151.678 E.56919
G3 X156.077 Y151.771 I-.223 J2.163 E.01361
G1 X169.599 Y138.249 E.57313
G1 X170.135 Y138.249 E.01608
G1 X156.459 Y151.925 E.57967
G3 X156.801 Y152.121 I-.35 J1.006 E.01185
G1 X170.672 Y138.249 E.58796
G1 X171.209 Y138.249 E.01608
G1 X157.112 Y152.346 E.59748
G3 X157.383 Y152.612 I-1.13 J1.419 E.01139
G1 X171.745 Y138.249 E.60876
G1 X172.282 Y138.249 E.01608
G1 X157.61 Y152.921 E.62188
G3 X157.812 Y153.256 I-1.004 J.833 E.01176
G1 X172.818 Y138.249 E.63607
G1 X173.355 Y138.249 E.01608
G1 X157.968 Y153.637 E.65221
G1 X158.064 Y154.077 E.0135
G1 X173.891 Y138.249 E.67086
G1 X174.428 Y138.249 E.01608
G1 X158.092 Y154.585 E.69241
G3 X158.01 Y155.204 I-2.51 J-.018 E.01875
G1 X174.965 Y138.249 E.71863
G1 X175.501 Y138.249 E.01608
G1 X141.999 Y171.751 E1.42001
G1 X141.999 Y172.288 E.01608
G1 X176.038 Y138.249 E1.44276
G1 X176.574 Y138.249 E.01608
G1 X141.999 Y172.824 E1.4655
G1 X141.999 Y173.361 E.01608
G1 X177.111 Y138.249 E1.48824
G1 X177.648 Y138.249 E.01608
M73 P79 R3
G1 X141.999 Y173.898 E1.51099
G1 X141.999 Y174.434 E.01608
G1 X178.184 Y138.249 E1.53373
G1 X178.721 Y138.249 E.01608
G1 X141.999 Y174.971 E1.55647
G1 X141.999 Y175.507 E.01608
G1 X179.257 Y138.249 E1.57922
G1 X179.794 Y138.249 E.01608
G1 X141.999 Y176.044 E1.60196
G1 X141.999 Y176.58 E.01608
G1 X180.33 Y138.249 E1.6247
G1 X180.867 Y138.249 E.01608
G1 X141.999 Y177.117 E1.64745
G1 X141.999 Y177.654 E.01608
G1 X181.404 Y138.249 E1.67019
G1 X181.94 Y138.249 E.01608
G1 X141.999 Y178.19 E1.69293
G1 X141.999 Y178.727 E.01608
G1 X182.477 Y138.249 E1.71568
G1 X183.013 Y138.249 E.01608
G1 X141.83 Y179.433 E1.74561
; WIPE_START
G1 X143.244 Y178.019 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X150.796 Y179.123 Z2 F60000
G1 X169.928 Y181.92 Z2
G1 Z1.6
G1 E.8 F1800
G1 F9488.165
M204 S8000
G1 X170.501 Y181.347 E.02429
G1 X170.501 Y180.811 E.01608
G1 X169.561 Y181.751 E.03984
G1 X169.024 Y181.751 E.01608
G1 X170.501 Y180.274 E.06259
G1 X170.501 Y180.207 E.00201
G1 X170.106 Y180.133 E.01205
G1 X168.487 Y181.751 E.06859
G1 X167.951 Y181.751 E.01608
G1 X168.448 Y181.254 E.02105
G3 X167.815 Y181.35 I-.645 J-2.11 E.01926
G1 X167.414 Y181.751 E.01697
G1 X166.878 Y181.751 E.01608
G1 X167.313 Y181.315 E.01845
G3 X166.88 Y181.212 I.528 J-3.178 E.01336
G1 X166.341 Y181.751 E.02282
G1 X165.805 Y181.751 E.01608
G1 X166.497 Y181.059 E.02933
G3 X166.163 Y180.856 I.546 J-1.274 E.01174
G1 X165.268 Y181.751 E.03793
G1 X164.731 Y181.751 E.01608
G1 X165.855 Y180.627 E.04765
G3 X165.588 Y180.357 I1.146 J-1.406 E.01139
G1 X164.195 Y181.751 E.05905
G1 X163.658 Y181.751 E.01608
G1 X165.365 Y180.043 E.07236
G3 X165.169 Y179.704 I1.024 J-.82 E.01181
G1 X163.122 Y181.751 E.08676
G1 X162.585 Y181.751 E.01608
G1 X165.021 Y179.315 E.10325
G1 X164.925 Y178.874 E.01352
G1 X162.048 Y181.751 E.12193
G1 X161.512 Y181.751 E.01608
G1 X164.906 Y178.356 E.14388
G3 X165.008 Y177.718 I2.984 J.147 E.0194
G1 X160.975 Y181.751 E.17092
G1 X160.439 Y181.751 E.01608
G1 X170.501 Y171.689 E.42648
G1 X170.501 Y171.152 E.01608
G1 X159.902 Y181.751 E.44923
G1 X159.366 Y181.751 E.01608
G1 X170.501 Y170.616 E.47197
G1 X170.501 Y170.079 E.01608
G1 X158.829 Y181.751 E.49472
G1 X158.292 Y181.751 E.01608
G1 X170.501 Y169.542 E.51746
G1 X170.501 Y169.006 E.01608
G1 X157.756 Y181.751 E.5402
G1 X157.219 Y181.751 E.01608
G1 X170.501 Y168.469 E.56295
G1 X170.501 Y167.933 E.01608
G1 X156.683 Y181.751 E.58569
G1 X156.146 Y181.751 E.01608
G1 X170.501 Y167.396 E.60843
G1 X170.501 Y166.86 E.01608
G1 X155.609 Y181.751 E.63118
G1 X155.073 Y181.751 E.01608
G1 X170.501 Y166.323 E.65392
G1 X170.501 Y165.786 E.01608
G1 X154.536 Y181.751 E.67666
G1 X154 Y181.751 E.01608
G1 X170.501 Y165.25 E.69941
G1 X170.501 Y164.713 E.01608
G1 X153.463 Y181.751 E.72215
G1 X152.927 Y181.751 E.01608
G1 X170.501 Y164.177 E.74489
G1 X170.501 Y163.64 E.01608
G1 X152.39 Y181.751 E.76764
G1 X151.853 Y181.751 E.01608
G1 X170.501 Y163.103 E.79038
G1 X170.501 Y162.567 E.01608
G1 X151.317 Y181.751 E.81312
G1 X150.78 Y181.751 E.01608
G1 X170.501 Y162.03 E.83587
G1 X170.501 Y161.494 E.01608
G1 X150.244 Y181.751 E.85861
G1 X149.707 Y181.751 E.01608
G1 X170.501 Y160.957 E.88136
G1 X170.501 Y160.421 E.01608
G1 X149.171 Y181.751 E.9041
G1 X148.634 Y181.751 E.01608
G1 X170.501 Y159.884 E.92684
G1 X170.501 Y159.347 E.01608
G1 X148.097 Y181.751 E.94959
G1 X147.561 Y181.751 E.01608
G1 X170.501 Y158.811 E.97233
G1 X170.501 Y158.274 E.01608
M73 P80 R3
G1 X147.024 Y181.751 E.99507
G1 X146.488 Y181.751 E.01608
G1 X170.501 Y157.738 E1.01782
G1 X170.501 Y157.201 E.01608
G1 X145.951 Y181.751 E1.04056
G1 X145.414 Y181.751 E.01608
G1 X170.501 Y156.664 E1.0633
G1 X170.501 Y156.128 E.01608
G1 X144.878 Y181.751 E1.08605
G1 X144.341 Y181.751 E.01608
G1 X170.501 Y155.591 E1.10879
G1 X170.501 Y155.055 E.01608
G1 X143.805 Y181.751 E1.13153
G1 X143.268 Y181.751 E.01608
G1 X170.501 Y154.518 E1.15428
G1 X170.501 Y153.982 E.01608
G1 X142.732 Y181.751 E1.17702
G1 X142.195 Y181.751 E.01608
G1 X170.501 Y153.445 E1.19976
G1 X170.501 Y152.908 E.01608
G1 X141.999 Y181.41 E1.20806
G1 X141.999 Y180.873 E.01608
G1 X170.501 Y152.372 E1.20806
G1 X170.501 Y151.835 E.01608
G1 X141.999 Y180.337 E1.20806
G1 X141.999 Y179.8 E.01608
G1 X183.55 Y138.249 E1.76116
G1 X184.087 Y138.249 E.01608
G1 X171.085 Y151.251 E.55107
G1 X171.622 Y151.251 E.01608
G1 X184.623 Y138.249 E.55107
G1 X185.16 Y138.249 E.01608
G1 X172.158 Y151.251 E.55107
G1 X172.695 Y151.251 E.01608
G1 X185.696 Y138.249 E.55107
G1 X186.233 Y138.249 E.01608
G1 X173.232 Y151.251 E.55107
G1 X173.768 Y151.251 E.01608
G1 X186.769 Y138.249 E.55107
G1 X187.306 Y138.249 E.01608
G1 X174.305 Y151.251 E.55107
G1 X174.841 Y151.251 E.01608
G1 X187.843 Y138.249 E.55107
G1 X188.379 Y138.249 E.01608
G1 X175.378 Y151.251 E.55107
G1 X175.914 Y151.251 E.01608
G1 X188.916 Y138.249 E.55107
G1 X189.452 Y138.249 E.01608
G1 X176.451 Y151.251 E.55107
G1 X176.988 Y151.251 E.01608
G1 X189.989 Y138.249 E.55107
G1 X190.525 Y138.249 E.01608
G1 X177.524 Y151.251 E.55107
G1 X178.061 Y151.251 E.01608
G1 X191.062 Y138.249 E.55107
G1 X191.599 Y138.249 E.01608
G1 X178.597 Y151.251 E.55107
G1 X179.134 Y151.251 E.01608
G1 X192.135 Y138.249 E.55107
G1 X192.672 Y138.249 E.01608
G1 X179.671 Y151.251 E.55107
G1 X180.207 Y151.251 E.01608
G1 X193.208 Y138.249 E.55107
G1 X193.745 Y138.249 E.01608
G1 X180.744 Y151.251 E.55107
G1 X181.28 Y151.251 E.01608
G1 X194.282 Y138.249 E.55107
G1 X194.818 Y138.249 E.01608
G1 X181.817 Y151.251 E.55107
G1 X182.353 Y151.251 E.01608
G1 X195.355 Y138.249 E.55107
G1 X195.891 Y138.249 E.01608
G1 X182.89 Y151.251 E.55107
G1 X183.427 Y151.251 E.01608
G1 X196.428 Y138.249 E.55107
G1 X196.964 Y138.249 E.01608
G1 X183.963 Y151.251 E.55107
G1 X184.5 Y151.251 E.01608
G1 X197.501 Y138.249 E.55107
G1 X198.038 Y138.249 E.01608
G1 X185.036 Y151.251 E.55107
G1 X185.573 Y151.251 E.01608
G1 X198.574 Y138.249 E.55107
G1 X199.111 Y138.249 E.01608
G1 X186.11 Y151.251 E.55107
G1 X186.646 Y151.251 E.01608
G1 X199.647 Y138.249 E.55107
G1 X200.184 Y138.249 E.01608
G1 X187.183 Y151.251 E.55107
G1 X187.719 Y151.251 E.01608
G1 X200.721 Y138.249 E.55107
G1 X201.257 Y138.249 E.01608
G1 X188.256 Y151.251 E.55107
G1 X188.792 Y151.251 E.01608
G1 X201.794 Y138.249 E.55107
G1 X202.33 Y138.249 E.01608
G1 X189.329 Y151.251 E.55107
G1 X189.866 Y151.251 E.01608
G1 X202.867 Y138.249 E.55107
G1 X203.403 Y138.249 E.01608
G1 X190.402 Y151.251 E.55107
G1 X190.939 Y151.251 E.01608
M73 P81 R3
G1 X203.94 Y138.249 E.55107
G1 X204.169 Y138.249 E.00686
G1 X204.192 Y138.534 E.00857
G1 X191.475 Y151.251 E.53899
G1 X192.012 Y151.251 E.01608
G1 X202.453 Y140.809 E.44257
G2 X202.402 Y141.397 I2.493 J.513 E.01772
G1 X192.548 Y151.251 E.41765
G1 X193.085 Y151.251 E.01608
G1 X202.468 Y141.868 E.3977
G2 X202.58 Y142.292 I1.533 J-.179 E.0132
G1 X193.622 Y151.251 E.37972
G1 X194.158 Y151.251 E.01608
G1 X202.746 Y142.663 E.36401
G1 X202.962 Y142.983 E.01159
G1 X194.695 Y151.251 E.35041
G1 X195.231 Y151.251 E.01608
G1 X203.202 Y143.28 E.33785
G2 X203.482 Y143.537 I1.365 J-1.207 E.0114
G1 X195.768 Y151.251 E.32697
G1 X196.305 Y151.251 E.01608
G1 X203.802 Y143.753 E.31778
G2 X204.16 Y143.932 I1.115 J-1.787 E.01201
G1 X196.841 Y151.251 E.31021
G1 X197.378 Y151.251 E.01608
G1 X204.565 Y144.064 E.30463
G1 X205.023 Y144.142 E.01393
G1 X197.914 Y151.251 E.3013
G1 X198.451 Y151.251 E.01608
G1 X205.568 Y144.133 E.30167
G2 X206.297 Y143.941 I-.114 J-1.909 E.02276
G1 X198.987 Y151.251 E.30984
G1 X199.524 Y151.251 E.01608
G1 X207.805 Y142.97 E.35098
G1 X208.001 Y143.008 E.00599
G1 X208.001 Y143.311 E.00906
G1 X200.061 Y151.251 E.33655
G1 X200.597 Y151.251 E.01608
G1 X208.001 Y143.847 E.3138
G1 X208.001 Y144.384 E.01608
G1 X201.134 Y151.251 E.29106
G1 X201.67 Y151.251 E.01608
G1 X208.001 Y144.92 E.26832
G1 X208.001 Y145.457 E.01608
G1 X202.207 Y151.251 E.24557
G1 X202.744 Y151.251 E.01608
G1 X208.001 Y145.994 E.22283
G1 X208.001 Y146.53 E.01608
G1 X203.28 Y151.251 E.20008
G1 X203.817 Y151.251 E.01608
M73 P81 R2
G1 X208.001 Y147.067 E.17734
G1 X208.001 Y147.603 E.01608
G1 X204.353 Y151.251 E.1546
G1 X204.89 Y151.251 E.01608
G1 X208.001 Y148.14 E.13185
G1 X208.001 Y148.676 E.01608
G1 X205.426 Y151.251 E.10911
G1 X205.963 Y151.251 E.01608
G1 X208.001 Y149.213 E.08637
G1 X208.001 Y149.75 E.01608
G1 X206.5 Y151.251 E.06362
G1 X207.036 Y151.251 E.01608
G1 X208.001 Y150.286 E.04088
G1 X208.001 Y150.823 E.01608
G1 X207.403 Y151.42 E.02533
; WIPE_START
G1 X208.001 Y150.823 E-.32113
G1 X208.001 Y150.286 E-.2039
G1 X207.563 Y150.723 E-.23497
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X207.876 Y143.097 Z2 F60000
G1 X207.895 Y142.648 Z2
G1 Z1.6
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.413165
G1 F9723.296
M204 S8000
G1 X207.947 Y142.379 E.00801
; LINE_WIDTH: 0.385577
G1 F10506.142
G1 X207.971 Y142.237 E.0039
; LINE_WIDTH: 0.337953
G1 F12202.056
G1 X207.995 Y142.095 E.00336
; LINE_WIDTH: 0.312178
G1 F13370.092
G1 X207.997 Y142.081 E.0003
; LINE_WIDTH: 0.294368
G1 F14317.096
G1 X208.012 Y141.942 E.00277
; LINE_WIDTH: 0.261644
G1 F15000
G1 X208.029 Y141.794 E.00258
; LINE_WIDTH: 0.215053
G1 X208.051 Y141.254 E.00734
G1 X208.041 Y140.961 E.004
; LINE_WIDTH: 0.244021
G1 X208.019 Y140.698 E.00418
; LINE_WIDTH: 0.284154
G1 F14923.283
G1 X208.001 Y140.563 E.0026
; LINE_WIDTH: 0.321711
G1 F12912.894
G1 X207.981 Y140.413 E.00332
; LINE_WIDTH: 0.364832
G1 F11183.206
G1 X207.958 Y140.288 E.00325
; LINE_WIDTH: 0.424736
G1 F9428.647
G1 X207.933 Y140.151 E.00419
G1 X207.657 Y140.025 E.00915
; WIPE_START
G1 X207.933 Y140.151 E-.52135
G1 X207.958 Y140.288 E-.23865
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X206.365 Y138.623 Z2 F60000
G1 Z1.6
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F9547.299
M204 S8000
G1 X206.602 Y138.723 E.00766
G3 X207.486 Y139.474 I-1.219 J2.333 E.03485
G1 X207.624 Y139.374 E.00505
G1 X207.942 Y139.49 E.01008
G1 X207.942 Y138.308 E.0352
G1 X206.387 Y138.308 E.04631
G1 X206.369 Y138.564 E.00762
; WIPE_START
G1 X206.387 Y138.308 E-.09724
G1 X207.942 Y138.308 E-.59083
G1 X207.942 Y138.498 E-.07194
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X207.513 Y138.712 Z2 F60000
G1 Z1.6
G1 E.8 F1800
; LINE_WIDTH: 0.59258
G1 F6549.504
M204 S8000
G2 X207.517 Y138.824 I-.03 J.057 E.01173
; WIPE_START
G1 X207.444 Y138.831 E-.19965
G1 X207.41 Y138.772 E-.18679
G1 X207.444 Y138.712 E-.18679
G1 X207.513 Y138.712 E-.18678
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X205.988 Y138.388 Z2 F60000
G1 Z1.6
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.521737
G1 F7518.536
M204 S8000
G2 X204.514 Y138.39 I-.726 J6.759 E.05586
; WIPE_START
G1 X205.227 Y138.349 E-.36734
G1 X205.988 Y138.388 E-.39266
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X200.464 Y143.654 Z2 F60000
G1 X170.67 Y172.056 Z2
G1 Z1.6
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42234
G1 F9488.165
M204 S8000
G1 X166.964 Y175.762 E.15711
G3 X167.601 Y175.662 I.696 J2.344 E.01938
G1 X170.501 Y172.762 E.12292
G1 X170.501 Y173.298 E.01608
G1 X168.123 Y175.677 E.1008
G3 X168.567 Y175.769 I-.217 J2.166 E.01363
G1 X170.501 Y173.835 E.08196
G1 X170.501 Y174.372 E.01608
G1 X168.951 Y175.922 E.0657
G3 X169.293 Y176.116 I-.346 J1.009 E.01187
G1 X170.501 Y174.908 E.05119
G1 X170.501 Y175.445 E.01608
G1 X169.602 Y176.343 E.03807
G1 X169.877 Y176.605 E.01137
G1 X170.501 Y175.981 E.02643
G1 X170.501 Y176.518 E.01608
G1 X170.192 Y176.826 E.01307
M204 S10000
G1 X170.153 Y177.227 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.436345
G1 F9150.428
M204 S8000
G1 X170.433 Y177.351 E.00952
G1 X170.437 Y177.371 E.00063
; LINE_WIDTH: 0.404533
G1 F9955.395
G1 X170.462 Y177.51 E.00402
; LINE_WIDTH: 0.355719
G1 F11508.991
G1 X170.486 Y177.648 E.00348
; LINE_WIDTH: 0.313424
G1 F13308.518
G1 X170.504 Y177.784 E.00292
; LINE_WIDTH: 0.280604
G1 F15000
G1 X170.519 Y177.906 E.00231
; LINE_WIDTH: 0.243527
G1 X170.541 Y178.16 E.00404
; LINE_WIDTH: 0.214718
G1 X170.551 Y178.447 E.0039
G1 X170.53 Y178.984 E.0073
; LINE_WIDTH: 0.25982
G1 X170.513 Y179.135 E.0026
; LINE_WIDTH: 0.292952
G1 F14398.179
G1 X170.497 Y179.275 E.00279
; LINE_WIDTH: 0.331635
G1 F12469.049
G1 X170.474 Y179.418 E.00328
; LINE_WIDTH: 0.376092
G1 F10805.24
G1 X170.453 Y179.546 E.00344
; LINE_WIDTH: 0.400487
G1 F10068.065
G1 X170.396 Y179.848 E.00868
; CHANGE_LAYER
; Z_HEIGHT: 1.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F10068.065
G1 X170.453 Y179.546 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 9/54
; update layer progress
M73 L9
M991 S0 P8 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z2 I1.107 J-.506 P1  F60000
G1 X153.919 Y143.374 Z2
G1 Z1.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X153.635 Y143.317 E.00933
G3 X154.028 Y139.201 I.613 J-2.018 E.186
G1 X154.239 Y139.19 E.00677
G3 X154.061 Y143.4 I.009 J2.109 E.21933
G1 X153.978 Y143.385 E.00273
; COOLING_NODE: 0
M204 S10000
G1 X153.996 Y142.976 F60000
G1 F8843.478
M204 S8000
G1 X153.753 Y142.927 E.00798
G3 X154.071 Y139.607 I.495 J-1.628 E.15005
G1 X154.241 Y139.597 E.00547
G3 X154.099 Y142.994 I.007 J1.702 E.17696
G1 X154.056 Y142.986 E.00141
; COOLING_NODE: 0
M204 S250
G1 X154.071 Y142.593 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X153.868 Y142.552 E.00619
G3 X154.113 Y139.997 I.382 J-1.252 E.10692
G1 X154.244 Y139.99 E.00391
G3 X154.135 Y142.603 I.005 J1.309 E.1261
G1 X154.13 Y142.603 E.00013
; COOLING_NODE: 0
; WIPE_START
M204 S8000
G1 X153.868 Y142.552 E-.10173
G1 X153.635 Y142.457 E-.09553
G1 X153.425 Y142.318 E-.09579
G1 X153.231 Y142.124 E-.10385
G1 X153.083 Y141.896 E-.10353
G1 X152.991 Y141.662 E-.09539
G1 X152.945 Y141.42 E-.09355
G1 X152.946 Y141.234 E-.07063
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X156.194 Y148.141 Z2.2 F60000
G1 X169.781 Y177.03 Z2.2
G1 Z1.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X169.952 Y177.286 E.00988
G3 X167.485 Y175.996 I-2.205 J1.213 E.41357
G1 X167.736 Y175.982 E.00806
G3 X169.681 Y176.888 I.011 J2.516 E.07127
G1 X169.746 Y176.981 E.00366
; COOLING_NODE: 0
M204 S10000
G1 X169.446 Y177.259 F60000
G1 F8843.478
M204 S8000
G1 X169.595 Y177.482 E.00861
G3 X167.528 Y176.401 I-1.847 J1.017 E.34665
G1 X167.738 Y176.39 E.00677
G3 X169.368 Y177.149 I.009 J2.109 E.05971
G1 X169.411 Y177.21 E.00243
; COOLING_NODE: 0
M204 S10000
G1 X169.111 Y177.488 F60000
G1 F8843.478
M204 S8000
G1 X169.239 Y177.677 E.00734
G3 X167.571 Y176.807 I-1.49 J.822 E.27973
G1 X167.741 Y176.797 E.00547
G3 X169.055 Y177.409 I.007 J1.702 E.04814
G1 X169.076 Y177.439 E.0012
; COOLING_NODE: 1
M204 S250
G1 X168.789 Y177.709 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X168.895 Y177.866 E.00565
G3 X167.613 Y177.197 I-1.146 J.633 E.19941
G1 X167.744 Y177.19 E.0039
G3 X168.754 Y177.659 I.005 J1.309 E.03426
G1 X168.754 Y177.66 E.00003
; COOLING_NODE: 1
; WIPE_START
M204 S8000
G1 X168.895 Y177.866 E-.09482
G1 X169.003 Y178.117 E-.10371
G1 X169.055 Y178.38 E-.1019
G1 X169.053 Y178.636 E-.09753
G1 X169.003 Y178.884 E-.09593
G1 X168.896 Y179.134 E-.10348
G1 X168.754 Y179.342 E-.09554
G1 X168.629 Y179.466 E-.06708
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X164.996 Y172.753 Z2.2 F60000
G1 X153.953 Y152.352 Z2.2
G1 Z1.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X154.055 Y152.282 E.00396
G3 X154.985 Y151.996 I1.192 J2.216 E.0315
G1 X155.236 Y151.982 E.00807
G3 X153.66 Y152.546 I.011 J2.516 E.45355
G1 X153.903 Y152.385 E.00938
; COOLING_NODE: 1
M204 S10000
G1 X154.179 Y152.689 F60000
G1 F8843.478
M204 S8000
G1 X154.249 Y152.641 E.00273
G3 X155.028 Y152.401 I.999 J1.858 E.02639
G1 X155.238 Y152.39 E.00677
G3 X153.918 Y152.862 I.009 J2.109 E.38014
G1 X154.129 Y152.722 E.00813
; COOLING_NODE: 1
M204 S10000
G1 X154.404 Y153.027 F60000
G1 F8843.478
M204 S8000
G1 X154.443 Y153 E.0015
G3 X155.071 Y152.807 I.806 J1.499 E.02129
G1 X155.241 Y152.797 E.00547
G3 X154.176 Y153.178 I.007 J1.702 E.30674
G1 X154.354 Y153.06 E.00687
; COOLING_NODE: 2
M204 S250
G1 X154.621 Y153.352 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X154.629 Y153.346 E.00031
G3 X155.113 Y153.197 I.62 J1.153 E.01516
G1 X155.244 Y153.19 E.0039
G3 X154.425 Y153.482 I.005 J1.309 E.21865
G1 X154.571 Y153.385 E.00523
; COOLING_NODE: 2
; WIPE_START
M204 S8000
G1 X154.629 Y153.346 E-.02674
G1 X154.866 Y153.247 E-.09742
G1 X155.113 Y153.197 E-.09573
G1 X155.244 Y153.19 E-.04981
G1 X155.499 Y153.214 E-.09741
G1 X155.741 Y153.285 E-.09603
G1 X155.982 Y153.413 E-.10371
G1 X156.091 Y153.496 E-.05187
G1 X156.254 Y153.659 E-.08761
G1 X156.334 Y153.775 E-.05367
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X163.809 Y152.233 Z2.2 F60000
G1 X204.822 Y143.77 Z2.2
G1 Z1.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X204.51 Y143.705 E.01025
G3 X204.985 Y138.796 I.737 J-2.406 E.22176
G1 X205.236 Y138.782 E.00807
G3 X204.989 Y143.802 I.011 J2.517 E.26287
G1 X204.881 Y143.782 E.00354
; COOLING_NODE: 2
M204 S10000
G1 X204.903 Y143.373 F60000
G1 F8843.478
M204 S8000
G1 X204.63 Y143.316 E.00897
G3 X205.028 Y139.201 I.617 J-2.017 E.18587
G1 X205.239 Y139.19 E.00677
G3 X205.031 Y143.397 I.009 J2.109 E.22033
G1 X204.962 Y143.384 E.00226
; COOLING_NODE: 2
M204 S10000
G1 X204.985 Y142.976 F60000
G1 F8843.478
M204 S8000
G1 X204.751 Y142.927 E.00768
G3 X205.071 Y139.607 I.498 J-1.627 E.14998
G1 X205.241 Y139.597 E.00547
G3 X205.073 Y142.992 I.007 J1.702 E.1778
G1 X205.044 Y142.987 E.00097
; COOLING_NODE: 3
M204 S250
G1 X205.063 Y142.593 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X204.867 Y142.552 E.00597
G3 X205.113 Y139.997 I.383 J-1.252 E.10691
G1 X205.244 Y139.99 E.00391
G3 X205.122 Y142.603 I.005 J1.31 E.12651
; COOLING_NODE: 3
; WIPE_START
M204 S8000
G1 X204.867 Y142.552 E-.0989
G1 X204.616 Y142.446 E-.10341
G1 X204.413 Y142.308 E-.0935
G1 X204.245 Y142.141 E-.08965
G1 X204.104 Y141.935 E-.09508
G1 X203.997 Y141.683 E-.10386
G1 X203.947 Y141.436 E-.09591
G1 X203.945 Y141.226 E-.07969
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X196.374 Y142.195 Z2.2 F60000
G1 X151.666 Y147.916 Z2.2
G1 Z1.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X151.666 Y142.147 E.18553
G1 X151.87 Y142.112 E.00665
G2 X151.87 Y140.488 I2.375 J-.812 E.45404
G1 X151.666 Y140.454 E.00665
G1 X151.666 Y137.916 E.0816
G1 X208.334 Y137.916 E1.82222
G1 X208.334 Y151.584 E.4395
G1 X170.834 Y151.584 E1.20586
G1 X170.834 Y182.084 E.98077
G1 X141.666 Y182.084 E.93792
G1 X141.666 Y147.916 E1.09871
G1 X151.606 Y147.916 E.31963
; COOLING_NODE: 3
M204 S10000
G1 X151.259 Y147.509 F60000
G1 F8843.478
M204 S8000
M73 P82 R2
G1 X151.259 Y137.509 E.32156
G1 X208.741 Y137.509 E1.8484
G1 X208.741 Y151.991 E.46568
G1 X171.241 Y151.991 E1.20586
G1 X171.241 Y182.491 E.98077
G1 X141.259 Y182.491 E.9641
G1 X141.259 Y147.509 E1.12489
G1 X151.199 Y147.509 E.31963
; COOLING_NODE: 3
M204 S10000
G1 X150.852 Y147.102 F60000
G1 F8843.478
M204 S8000
G1 X150.852 Y137.102 E.32156
G1 X209.148 Y137.102 E1.87458
G1 X209.148 Y152.398 E.49186
G1 X171.648 Y152.398 E1.20586
G1 X171.648 Y182.898 E.98077
G1 X140.852 Y182.898 E.99028
G1 X140.852 Y147.102 E1.15107
G1 X150.792 Y147.102 E.31963
; COOLING_NODE: 4
M204 S250
G1 X150.46 Y146.71 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X150.46 Y136.71 E.29787
G1 X209.54 Y136.71 E1.75979
G1 X209.54 Y152.79 E.47897
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X172.04 Y152.79 E1.117
G1 X172.04 Y183.29 E.90849
G1 X140.46 Y183.29 E.94066
G1 X140.46 Y146.71 E1.08959
G1 X150.4 Y146.71 E.29608
; WIPE_START
M204 S8000
G1 X150.412 Y144.71 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X151.83 Y147.307 Z2.2 F60000
G1 Z1.8
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42102
G1 F9521.29
M204 S8000
G1 X156.432 Y151.909 E.19438
G2 X155.68 Y151.692 I-1.089 J2.363 E.02346
G1 X151.999 Y148.011 E.15546
G1 X151.999 Y148.249 E.00712
G1 X151.703 Y148.249 E.00885
G1 X155.115 Y151.662 E.14413
G2 X154.645 Y151.726 I-.073 J1.223 E.01428
G1 X151.168 Y148.249 E.14684
G1 X150.633 Y148.249 E.01597
G1 X154.226 Y151.842 E.15175
G2 X153.862 Y152.012 I1.095 J2.816 E.01202
G1 X150.099 Y148.249 E.15894
G1 X149.564 Y148.249 E.01597
G1 X153.541 Y152.226 E.16799
G2 X153.249 Y152.469 I.689 J1.124 E.01138
G1 X149.029 Y148.249 E.17824
G1 X148.495 Y148.249 E.01597
G1 X153 Y152.755 E.19031
G1 X152.785 Y153.075 E.01151
G1 X147.96 Y148.249 E.20382
G1 X147.425 Y148.249 E.01597
G1 X152.615 Y153.439 E.21921
G2 X152.479 Y153.838 I1.306 J.668 E.01263
G1 X146.89 Y148.249 E.23605
G1 X146.356 Y148.249 E.01597
G1 X152.409 Y154.302 E.25566
G2 X152.425 Y154.853 I2.798 J.194 E.01648
G1 X145.821 Y148.249 E.27893
G1 X145.286 Y148.249 E.01597
G1 X152.61 Y155.573 E.30933
G2 X153.065 Y156.333 I2.602 J-1.042 E.02658
G1 X153.449 Y156.712 E.0161
G2 X154.177 Y157.14 I1.981 J-2.536 E.0253
G1 X170.501 Y173.464 E.68948
G1 X170.501 Y172.929 E.01597
G1 X154.898 Y157.326 E.65905
G2 X155.448 Y157.341 I.356 J-2.856 E.01646
G1 X170.501 Y172.394 E.63581
G1 X170.501 Y171.86 E.01597
G1 X155.906 Y157.264 E.61647
G2 X156.311 Y157.135 I-.139 J-1.132 E.01278
G1 X170.501 Y171.325 E.59936
G1 X170.501 Y170.79 E.01597
G1 X156.676 Y156.965 E.58394
G2 X156.996 Y156.751 I-.876 J-1.66 E.01154
G1 X170.501 Y170.255 E.5704
G1 X170.501 Y169.721 E.01597
G1 X157.281 Y156.501 E.55839
G2 X157.524 Y156.209 I-.904 J-1.001 E.01138
G1 X170.501 Y169.186 E.54812
G1 X170.501 Y168.651 E.01597
G1 X157.739 Y155.889 E.53905
G2 X157.908 Y155.524 I-3.208 J-1.708 E.01203
G1 X170.501 Y168.117 E.5319
G1 X170.501 Y167.582 E.01597
G1 X158.024 Y155.105 E.52699
G2 X158.094 Y154.641 I-1.509 J-.466 E.01408
G1 X170.501 Y167.047 E.52402
G1 X170.501 Y166.512 E.01597
G1 X158.067 Y154.078 E.52519
G2 X157.843 Y153.32 I-2.289 J.263 E.02373
G1 X170.501 Y165.978 E.53464
G1 X170.501 Y165.443 E.01597
G1 X151.999 Y146.942 E.78147
G1 X151.999 Y146.407 E.01597
G1 X170.501 Y164.908 E.78147
G1 X170.501 Y164.374 E.01597
G1 X151.999 Y145.872 E.78147
G1 X151.999 Y145.338 E.01597
G1 X170.501 Y163.839 E.78147
G1 X170.501 Y163.304 E.01597
G1 X151.999 Y144.803 E.78147
G1 X151.999 Y144.268 E.01597
M73 P83 R2
G1 X170.501 Y162.769 E.78147
G1 X170.501 Y162.235 E.01597
G1 X151.999 Y143.733 E.78147
G1 X151.999 Y143.463 E.00809
G1 X152.138 Y143.338 E.00558
G1 X170.501 Y161.7 E.7756
G1 X170.501 Y161.165 E.01597
G1 X153.326 Y143.991 E.72543
G2 X153.998 Y144.128 I.784 J-2.121 E.02057
G1 X170.501 Y160.631 E.69704
G1 X170.501 Y160.096 E.01597
G1 X154.541 Y144.136 E.6741
G2 X154.985 Y144.045 I-.37 J-2.916 E.01353
G1 X170.501 Y159.561 E.65537
G1 X170.501 Y159.026 E.01597
G1 X155.388 Y143.914 E.63834
G2 X155.734 Y143.725 I-.47 J-1.275 E.01181
G1 X170.501 Y158.492 E.62372
G1 X170.501 Y157.957 E.01597
G1 X156.052 Y143.508 E.61031
G1 X156.323 Y143.245 E.01129
G1 X170.501 Y157.422 E.59884
G1 X170.501 Y156.888 E.01597
G1 X156.562 Y142.949 E.58874
G2 X156.772 Y142.625 I-.995 J-.876 E.01159
G1 X170.501 Y156.353 E.57986
G1 X170.501 Y155.818 E.01597
G1 X156.934 Y142.252 E.57302
G2 X157.049 Y141.832 I-2.937 J-1.031 E.01301
G1 X170.501 Y155.283 E.56816
G1 X170.501 Y154.749 E.01597
G1 X157.099 Y141.347 E.56605
G1 X157.051 Y140.765 E.01746
G1 X170.501 Y154.214 E.56807
G1 X170.501 Y153.679 E.01597
G1 X155.315 Y138.493 E.64143
G1 X155.332 Y138.249 E.00731
G1 X155.605 Y138.249 E.00817
G1 X170.501 Y153.145 E.62915
G1 X170.501 Y152.61 E.01597
G1 X156.14 Y138.249 E.60657
G1 X156.675 Y138.249 E.01597
G1 X170.501 Y152.075 E.58398
G1 X170.501 Y151.54 E.01597
G1 X157.21 Y138.249 E.56139
G1 X157.744 Y138.249 E.01597
G1 X170.746 Y151.251 E.54916
G1 X171.28 Y151.251 E.01597
G1 X158.279 Y138.249 E.54916
G1 X158.814 Y138.249 E.01597
G1 X171.815 Y151.251 E.54916
G1 X172.35 Y151.251 E.01597
G1 X159.348 Y138.249 E.54916
G1 X159.883 Y138.249 E.01597
G1 X172.884 Y151.251 E.54916
G1 X173.419 Y151.251 E.01597
G1 X160.418 Y138.249 E.54915
G1 X160.953 Y138.249 E.01597
G1 X173.954 Y151.251 E.54916
G1 X174.489 Y151.251 E.01597
G1 X161.487 Y138.249 E.54916
G1 X162.022 Y138.249 E.01597
G1 X175.023 Y151.251 E.54916
G1 X175.558 Y151.251 E.01597
G1 X162.557 Y138.249 E.54916
G1 X163.091 Y138.249 E.01597
G1 X176.093 Y151.251 E.54915
G1 X176.627 Y151.251 E.01597
G1 X163.626 Y138.249 E.54916
G1 X164.161 Y138.249 E.01597
G1 X177.162 Y151.251 E.54916
G1 X177.697 Y151.251 E.01597
G1 X164.696 Y138.249 E.54916
G1 X165.23 Y138.249 E.01597
G1 X178.232 Y151.251 E.54916
G1 X178.766 Y151.251 E.01597
G1 X165.765 Y138.249 E.54916
G1 X166.3 Y138.249 E.01597
G1 X179.301 Y151.251 E.54916
G1 X179.836 Y151.251 E.01597
G1 X166.834 Y138.249 E.54915
G1 X167.369 Y138.249 E.01597
G1 X180.37 Y151.251 E.54916
G1 X180.905 Y151.251 E.01597
G1 X167.904 Y138.249 E.54916
G1 X168.439 Y138.249 E.01597
G1 X181.44 Y151.251 E.54916
G1 X181.975 Y151.251 E.01597
G1 X168.973 Y138.249 E.54916
G1 X169.508 Y138.249 E.01597
G1 X182.509 Y151.251 E.54915
G1 X183.044 Y151.251 E.01597
G1 X170.043 Y138.249 E.54916
G1 X170.577 Y138.249 E.01597
G1 X183.579 Y151.251 E.54916
G1 X184.113 Y151.251 E.01597
G1 X171.112 Y138.249 E.54916
G1 X171.647 Y138.249 E.01597
G1 X184.648 Y151.251 E.54916
G1 X185.183 Y151.251 E.01597
G1 X172.182 Y138.249 E.54916
G1 X172.716 Y138.249 E.01597
G1 X185.718 Y151.251 E.54916
G1 X186.252 Y151.251 E.01597
G1 X173.251 Y138.249 E.54915
G1 X173.786 Y138.249 E.01597
G1 X186.787 Y151.251 E.54916
G1 X187.322 Y151.251 E.01597
G1 X174.32 Y138.249 E.54916
G1 X174.855 Y138.249 E.01597
G1 X187.856 Y151.251 E.54916
G1 X188.391 Y151.251 E.01597
G1 X175.39 Y138.249 E.54916
G1 X175.925 Y138.249 E.01597
G1 X188.926 Y151.251 E.54915
G1 X189.461 Y151.251 E.01597
G1 X176.459 Y138.249 E.54916
G1 X176.994 Y138.249 E.01597
G1 X189.995 Y151.251 E.54916
G1 X190.53 Y151.251 E.01597
G1 X177.529 Y138.249 E.54916
G1 X178.063 Y138.249 E.01597
G1 X191.065 Y151.251 E.54916
G1 X191.599 Y151.251 E.01597
G1 X178.598 Y138.249 E.54916
G1 X179.133 Y138.249 E.01597
M73 P84 R2
G1 X192.134 Y151.251 E.54916
G1 X192.669 Y151.251 E.01597
G1 X179.668 Y138.249 E.54916
G1 X180.202 Y138.249 E.01597
G1 X193.204 Y151.251 E.54916
G1 X193.738 Y151.251 E.01597
G1 X180.737 Y138.249 E.54916
G1 X181.272 Y138.249 E.01597
G1 X194.273 Y151.251 E.54916
G1 X194.808 Y151.251 E.01597
G1 X181.806 Y138.249 E.54916
G1 X182.341 Y138.249 E.01597
G1 X195.342 Y151.251 E.54916
G1 X195.877 Y151.251 E.01597
G1 X182.876 Y138.249 E.54916
G1 X183.411 Y138.249 E.01597
G1 X196.412 Y151.251 E.54916
G1 X196.947 Y151.251 E.01597
G1 X183.945 Y138.249 E.54916
G1 X184.48 Y138.249 E.01597
G1 X197.481 Y151.251 E.54916
G1 X198.016 Y151.251 E.01597
G1 X185.015 Y138.249 E.54916
G1 X185.549 Y138.249 E.01597
G1 X198.551 Y151.251 E.54916
G1 X199.085 Y151.251 E.01597
G1 X186.084 Y138.249 E.54916
G1 X186.619 Y138.249 E.01597
G1 X199.62 Y151.251 E.54916
G1 X200.155 Y151.251 E.01597
G1 X187.154 Y138.249 E.54916
G1 X187.688 Y138.249 E.01597
G1 X200.69 Y151.251 E.54916
G1 X201.224 Y151.251 E.01597
G1 X188.223 Y138.249 E.54916
G1 X188.758 Y138.249 E.01597
G1 X201.759 Y151.251 E.54916
G1 X202.294 Y151.251 E.01597
G1 X189.292 Y138.249 E.54916
G1 X189.827 Y138.249 E.01597
G1 X202.828 Y151.251 E.54916
G1 X203.363 Y151.251 E.01597
G1 X190.362 Y138.249 E.54916
G1 X190.897 Y138.249 E.01597
G1 X203.898 Y151.251 E.54916
G1 X204.433 Y151.251 E.01597
G1 X191.431 Y138.249 E.54916
G1 X191.966 Y138.249 E.01597
G1 X204.967 Y151.251 E.54916
G1 X205.502 Y151.251 E.01597
G1 X192.501 Y138.249 E.54916
G1 X193.035 Y138.249 E.01597
G1 X206.037 Y151.251 E.54916
G1 X206.571 Y151.251 E.01597
G1 X193.57 Y138.249 E.54916
G1 X194.105 Y138.249 E.01597
G1 X207.106 Y151.251 E.54916
G1 X207.641 Y151.251 E.01597
G1 X194.64 Y138.249 E.54916
G1 X195.174 Y138.249 E.01597
G1 X208.001 Y151.076 E.54177
G1 X208.001 Y150.541 E.01597
G1 X195.709 Y138.249 E.51918
G1 X196.244 Y138.249 E.01597
G1 X208.001 Y150.006 E.4966
G1 X208.001 Y149.472 E.01597
G1 X196.778 Y138.249 E.47401
G1 X197.313 Y138.249 E.01597
G1 X208.001 Y148.937 E.45142
G1 X208.001 Y148.402 E.01597
G1 X197.848 Y138.249 E.42884
G1 X198.383 Y138.249 E.01597
G1 X208.001 Y147.867 E.40625
G1 X208.001 Y147.333 E.01597
G1 X204.767 Y144.099 E.13658
G1 X204.954 Y144.137 E.0057
G1 X205.343 Y144.14 E.0116
G1 X208.001 Y146.798 E.11227
G1 X208.001 Y146.263 E.01597
G1 X205.828 Y144.091 E.09176
G2 X206.242 Y143.97 I-.372 J-2.034 E.01289
G1 X208.001 Y145.729 E.07429
G1 X208.001 Y145.194 E.01597
G1 X206.611 Y143.805 E.05868
G1 X206.933 Y143.591 E.01152
G1 X208.001 Y144.659 E.04511
G1 X208.001 Y144.124 E.01597
G1 X207.221 Y143.345 E.03293
G2 X207.48 Y143.069 I-.585 J-.809 E.01137
G1 X208.17 Y143.759 E.02916
M204 S10000
G1 X208.17 Y143.225 F60000
G1 F9521.29
M204 S8000
G1 X207.851 Y142.906 E.01348
M204 S10000
G1 X207.656 Y142.577 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.432565
G1 F9239.185
M204 S8000
G1 X207.935 Y142.438 E.00962
; LINE_WIDTH: 0.410114
G1 F9804.083
G1 X207.958 Y142.312 E.00371
; LINE_WIDTH: 0.364558
G1 F11192.708
G1 X207.981 Y142.186 E.00325
; LINE_WIDTH: 0.320977
G1 F12947.017
G1 X208.001 Y142.033 E.00339
; LINE_WIDTH: 0.28254
G1 F15000
G1 X208.02 Y141.894 E.00265
; LINE_WIDTH: 0.240401
G1 X208.043 Y141.597 E.00464
; LINE_WIDTH: 0.208761
G1 X208.044 Y141.012 E.00767
; LINE_WIDTH: 0.238944
G1 X208.021 Y140.716 E.00459
; LINE_WIDTH: 0.28136
G1 X208.001 Y140.566 E.00285
; LINE_WIDTH: 0.319352
G1 F13023.124
G1 X207.983 Y140.428 E.00305
; LINE_WIDTH: 0.361536
G1 F11298.88
G1 X207.959 Y140.292 E.00348
; LINE_WIDTH: 0.408097
G1 F9858.231
G1 X207.937 Y140.17 E.00357
; LINE_WIDTH: 0.437453
G1 F9124.719
G1 X207.889 Y139.956 E.00682
; WIPE_START
G1 X207.937 Y140.17 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X206.365 Y138.625 Z2.2 F60000
G1 Z1.8
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F9547.299
M204 S8000
G1 X206.625 Y138.736 E.00844
G1 X207.067 Y139.026 E.01574
G1 X207.469 Y139.418 E.01672
G1 X207.616 Y139.616 E.00735
G1 X207.942 Y139.543 E.00995
G1 X207.942 Y138.308 E.03676
G1 X206.387 Y138.308 E.04631
G1 X206.369 Y138.565 E.00766
; WIPE_START
G1 X206.387 Y138.308 E-.09769
G1 X207.942 Y138.308 E-.59086
G1 X207.942 Y138.496 E-.07145
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X207.511 Y138.713 Z2.2 F60000
G1 Z1.8
G1 E.8 F1800
; LINE_WIDTH: 0.59542
G1 F6515.837
M204 S8000
G2 X207.516 Y138.825 I-.03 J.057 E.01186
; WIPE_START
G1 X207.442 Y138.833 E-.20002
G1 X207.408 Y138.773 E-.18666
G1 X207.442 Y138.713 E-.18666
G1 X207.511 Y138.713 E-.18666
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X205.988 Y138.388 Z2.2 F60000
G1 Z1.8
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.521735
G1 F7518.573
M204 S8000
G2 X204.514 Y138.39 I-.726 J6.77 E.05585
M204 S10000
G1 X204.282 Y138.802 F60000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42102
G1 F9521.29
M204 S8000
G1 X203.73 Y138.249 E.02335
G1 X203.195 Y138.249 E.01597
G1 X203.796 Y138.851 E.0254
G2 X203.479 Y139.068 I.9 J1.652 E.01151
G1 X202.66 Y138.249 E.03459
G1 X202.126 Y138.249 E.01597
G1 X203.206 Y139.329 E.04562
G2 X202.958 Y139.617 I.641 J.801 E.01139
G1 X201.591 Y138.249 E.05777
G1 X201.056 Y138.249 E.01597
G1 X202.745 Y139.939 E.07135
G2 X202.58 Y140.308 I1.672 J.969 E.01211
G1 X200.521 Y138.249 E.08696
G1 X199.987 Y138.249 E.01597
G1 X202.459 Y140.722 E.10443
G2 X202.41 Y141.207 I2.541 J.503 E.0146
G1 X199.452 Y138.249 E.12494
G1 X198.917 Y138.249 E.01597
G1 X202.668 Y142 E.15842
; WIPE_START
G1 X201.254 Y140.586 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X196.115 Y146.229 Z2.2 F60000
G1 X170.67 Y174.168 Z2.2
G1 Z1.8
G1 E.8 F1800
G1 F9521.29
M204 S8000
G1 X144.752 Y148.249 E1.09477
G1 X144.217 Y148.249 E.01597
G1 X170.501 Y174.533 E1.11019
G1 X170.501 Y175.068 E.01597
G1 X143.682 Y148.249 E1.13277
G1 X143.147 Y148.249 E.01597
G1 X170.501 Y175.603 E1.15536
G1 X170.501 Y176.137 E.01597
G1 X142.613 Y148.249 E1.17794
G1 X142.078 Y148.249 E.01597
G1 X170.501 Y176.672 E1.20053
G1 X170.501 Y176.79 E.00353
G1 X170.161 Y176.867 E.0104
G1 X141.999 Y148.705 E1.1895
G1 X141.999 Y149.24 E.01597
G1 X168.514 Y175.754 E1.11993
G1 X168.004 Y175.659 E.01549
G1 X167.884 Y175.66 E.00358
G1 X141.999 Y149.775 E1.09334
G1 X141.999 Y150.31 E.01597
G1 X167.369 Y175.68 E1.07159
G1 X166.926 Y175.771 E.01352
M73 P85 R2
G1 X141.999 Y150.844 E1.05286
G1 X141.999 Y151.379 E.01597
G1 X166.541 Y175.921 E1.03662
G2 X166.204 Y176.118 I.518 J1.273 E.01171
G1 X141.999 Y151.914 E1.02236
G1 X141.999 Y152.448 E.01597
G1 X165.892 Y176.341 E1.00918
G2 X165.623 Y176.606 I1.155 J1.438 E.01131
G1 X141.999 Y152.983 E.99782
G1 X141.999 Y153.518 E.01597
G1 X165.394 Y176.913 E.98817
G2 X165.197 Y177.25 I.79 J.69 E.01174
G1 X141.999 Y154.053 E.97982
G1 X141.999 Y154.587 E.01597
G1 X165.036 Y177.624 E.97305
G2 X164.936 Y178.059 I3.895 J1.123 E.01333
G1 X141.999 Y155.122 E.96883
G1 X141.999 Y155.657 E.01597
G1 X164.901 Y178.559 E.96735
G2 X164.992 Y179.184 I2.112 J.013 E.01894
G1 X141.999 Y156.191 E.97117
G1 X141.999 Y156.726 E.01597
G1 X167.024 Y181.751 E1.057
G1 X167.559 Y181.751 E.01597
G1 X167.066 Y181.258 E.0208
G2 X167.691 Y181.349 I.613 J-2.032 E.01894
G1 X168.093 Y181.751 E.01698
G1 X168.628 Y181.751 E.01597
G1 X168.186 Y181.309 E.01867
G1 X168.623 Y181.211 E.01338
G1 X169.163 Y181.751 E.02279
G1 X169.697 Y181.751 E.01597
G1 X169.002 Y181.055 E.02938
G2 X169.345 Y180.863 I-1.456 J-3.008 E.01174
G1 X170.232 Y181.751 E.03748
G1 X170.501 Y181.751 E.00802
G1 X170.501 Y181.484 E.00795
G1 X169.641 Y180.624 E.03633
G1 X169.909 Y180.358 E.01129
G1 X170.501 Y180.95 E.02498
G1 X170.501 Y180.415 E.01597
G1 X170.01 Y179.925 E.02071
M204 S10000
G1 X170.389 Y179.843 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.437144
G1 F9131.867
M204 S8000
G1 X170.437 Y179.629 E.00683
; LINE_WIDTH: 0.404438
G1 F9958.034
G1 X170.462 Y179.489 E.00405
; LINE_WIDTH: 0.355146
G1 F11530.12
G1 X170.486 Y179.35 E.0035
; LINE_WIDTH: 0.328382
G1 F12611.143
G1 X170.489 Y179.336 E.00032
; LINE_WIDTH: 0.309995
G1 F13479.366
G1 X170.505 Y179.207 E.00274
; LINE_WIDTH: 0.276221
G1 F15000
G1 X170.522 Y179.067 E.00259
; LINE_WIDTH: 0.237381
G1 X170.544 Y178.786 E.00432
; LINE_WIDTH: 0.20818
G1 X170.545 Y178.235 E.00719
; LINE_WIDTH: 0.234219
G1 X170.524 Y177.953 E.00427
; LINE_WIDTH: 0.272204
G1 X170.507 Y177.811 E.00259
; LINE_WIDTH: 0.308943
G1 F13532.666
G1 X170.487 Y177.655 E.00332
; LINE_WIDTH: 0.353939
G1 F11574.852
G1 X170.462 Y177.513 E.00354
; LINE_WIDTH: 0.403913
G1 F9972.492
G1 X170.437 Y177.371 E.00411
; LINE_WIDTH: 0.437052
G1 F9134.001
G1 X170.389 Y177.157 E.00684
; WIPE_START
G1 X170.437 Y177.371 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X166.659 Y181.92 Z2.2 F60000
G1 Z1.8
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42102
G1 F9521.29
M204 S8000
G1 X141.999 Y157.261 E1.04158
G1 X141.999 Y157.796 E.01597
G1 X165.954 Y181.751 E1.01183
G1 X165.42 Y181.751 E.01597
G1 X141.999 Y158.33 E.98924
G1 X141.999 Y158.865 E.01597
G1 X164.885 Y181.751 E.96666
G1 X164.35 Y181.751 E.01597
G1 X141.999 Y159.4 E.94407
G1 X141.999 Y159.934 E.01597
G1 X163.816 Y181.751 E.92149
G1 X163.281 Y181.751 E.01597
G1 X141.999 Y160.469 E.8989
G1 X141.999 Y161.004 E.01597
G1 X162.746 Y181.751 E.87632
G1 X162.211 Y181.751 E.01597
G1 X141.999 Y161.539 E.85373
G1 X141.999 Y162.073 E.01597
G1 X161.677 Y181.751 E.83115
G1 X161.142 Y181.751 E.01597
G1 X141.999 Y162.608 E.80856
G1 X141.999 Y163.143 E.01597
G1 X160.607 Y181.751 E.78597
G1 X160.073 Y181.751 E.01597
G1 X141.999 Y163.677 E.76339
G1 X141.999 Y164.212 E.01597
G1 X159.538 Y181.751 E.7408
G1 X159.003 Y181.751 E.01597
G1 X141.999 Y164.747 E.71822
G1 X141.999 Y165.282 E.01597
G1 X158.468 Y181.751 E.69563
G1 X157.934 Y181.751 E.01597
G1 X141.999 Y165.816 E.67305
G1 X141.999 Y166.351 E.01597
G1 X157.399 Y181.751 E.65046
G1 X156.864 Y181.751 E.01597
G1 X141.999 Y166.886 E.62787
G1 X141.999 Y167.42 E.01597
G1 X156.33 Y181.751 E.60529
G1 X155.795 Y181.751 E.01597
G1 X141.999 Y167.955 E.5827
G1 X141.999 Y168.49 E.01597
G1 X155.26 Y181.751 E.56012
G1 X154.725 Y181.751 E.01597
G1 X141.999 Y169.025 E.53753
G1 X141.999 Y169.559 E.01597
G1 X154.191 Y181.751 E.51495
G1 X153.656 Y181.751 E.01597
G1 X141.999 Y170.094 E.49236
G1 X141.999 Y170.629 E.01597
G1 X153.121 Y181.751 E.46978
G1 X152.587 Y181.751 E.01597
G1 X141.999 Y171.163 E.44719
G1 X141.999 Y171.698 E.01597
G1 X152.052 Y181.751 E.42461
G1 X151.517 Y181.751 E.01597
G1 X141.999 Y172.233 E.40202
G1 X141.999 Y172.768 E.01597
G1 X150.982 Y181.751 E.37943
G1 X150.448 Y181.751 E.01597
G1 X141.999 Y173.302 E.35685
G1 X141.999 Y173.837 E.01597
G1 X149.913 Y181.751 E.33426
G1 X149.378 Y181.751 E.01597
G1 X141.999 Y174.372 E.31168
G1 X141.999 Y174.906 E.01597
G1 X148.844 Y181.751 E.28909
G1 X148.309 Y181.751 E.01597
G1 X141.999 Y175.441 E.26651
M73 P86 R2
G1 X141.999 Y175.976 E.01597
G1 X147.774 Y181.751 E.24392
G1 X147.239 Y181.751 E.01597
G1 X141.999 Y176.511 E.22134
G1 X141.999 Y177.045 E.01597
G1 X146.705 Y181.751 E.19875
G1 X146.17 Y181.751 E.01597
G1 X141.999 Y177.58 E.17616
G1 X141.999 Y178.115 E.01597
G1 X145.635 Y181.751 E.15358
G1 X145.101 Y181.751 E.01597
G1 X141.999 Y178.649 E.13099
G1 X141.999 Y179.184 E.01597
G1 X144.566 Y181.751 E.10841
G1 X144.031 Y181.751 E.01597
G1 X141.999 Y179.719 E.08582
G1 X141.999 Y180.254 E.01597
G1 X143.496 Y181.751 E.06324
G1 X142.962 Y181.751 E.01597
G1 X141.999 Y180.788 E.04065
G1 X141.999 Y181.323 E.01597
G1 X142.597 Y181.92 E.02523
; WIPE_START
G1 X141.999 Y181.323 E-.32102
G1 X141.999 Y180.788 E-.20319
G1 X142.438 Y181.227 E-.23579
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X144.3 Y173.825 Z2.2 F60000
G1 X152.064 Y142.956 Z2.2
G1 Z1.8
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.121912
G1 F15000
M204 S8000
G1 X151.87 Y142.734 E.00184
M204 S10000
G1 X151.732 Y141.929 F60000
; LINE_WIDTH: 0.531552
G1 F7367.513
M204 S8000
G3 X151.733 Y140.671 I5.934 J-.627 E.04864
M204 S10000
G1 X151.87 Y139.872 F60000
; LINE_WIDTH: 0.117746
G1 F15000
M204 S8000
G1 X152.049 Y139.663 E.00163
; WIPE_START
G1 X151.87 Y139.872 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X153.06 Y138.573 Z2.2 F60000
G1 Z1.8
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.57051
G1 F6823.481
M204 S8000
G1 X153.045 Y138.384 E.0079
G1 X152.134 Y138.384 E.03799
G1 X152.134 Y139.13 E.0311
G1 X152.22 Y139.124 E.00361
G1 X152.811 Y138.686 E.03065
G1 X153.005 Y138.597 E.00891
M204 S10000
G1 X153.514 Y138.39 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.52173
G1 F7518.645
M204 S8000
G3 X154.988 Y138.388 I.748 J6.768 E.05585
; CHANGE_LAYER
; Z_HEIGHT: 2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F7518.645
G1 X154.244 Y138.349 E-.38367
G1 X153.514 Y138.39 E-.37633
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 10/54
; update layer progress
M73 L10
M991 S0 P9 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 1
M204 S10000
G17
G3 Z2.2 I-1.134 J.441 P1  F60000
G1 X168.796 Y177.717 Z2.2
G1 Z2
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X168.823 Y177.749 E.00124
G3 X167.613 Y177.197 I-1.073 J.75 E.20351
G1 X167.733 Y177.19 E.0036
G3 X168.659 Y177.557 I.016 J1.309 E.03043
G1 X168.757 Y177.671 E.00448
; COOLING_NODE: 2
; WIPE_START
M204 S8000
G1 X168.823 Y177.749 E-.03858
G1 X168.956 Y177.988 E-.10421
G1 X169.031 Y178.227 E-.09517
G1 X169.06 Y178.476 E-.09507
G1 X169.04 Y178.727 E-.0958
G1 X168.971 Y178.975 E-.09795
G1 X168.849 Y179.213 E-.10136
G1 X168.692 Y179.41 E-.096
G1 X168.62 Y179.471 E-.03586
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X165.015 Y172.744 Z2.4 F60000
G1 X154.622 Y153.351 Z2.4
G1 Z2
G1 E.8 F1800
G1 F9547.055
M204 S5000
G1 X154.846 Y153.253 E.00729
G3 X155.113 Y153.197 I.403 J1.246 E.00812
G1 X155.233 Y153.19 E.0036
G3 X154.57 Y153.38 I.016 J1.309 E.22425
; COOLING_NODE: 0
; WIPE_START
M204 S8000
G1 X154.846 Y153.253 E-.11561
G1 X155.113 Y153.197 E-.10339
G1 X155.233 Y153.19 E-.04594
G1 X155.5 Y153.214 E-.10168
G1 X155.741 Y153.285 E-.0956
G1 X155.963 Y153.401 E-.09512
G1 X156.16 Y153.557 E-.09565
G1 X156.324 Y153.749 E-.09584
G1 X156.338 Y153.775 E-.01116
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X154.816 Y146.296 Z2.4 F60000
G1 X154.062 Y142.593 Z2.4
G1 Z2
G1 E.8 F1800
G1 F9547.055
M204 S5000
G1 X154.023 Y142.589 E.00118
G3 X154.113 Y139.997 I.226 J-1.29 E.11167
G1 X154.233 Y139.99 E.00361
G3 X154.274 Y142.608 I.016 J1.309 E.12227
G1 X154.122 Y142.598 E.00453
; COOLING_NODE: 3
; WIPE_START
M204 S8000
G1 X154.023 Y142.589 E-.03785
G1 X153.78 Y142.523 E-.09575
G1 X153.537 Y142.399 E-.10344
G1 X153.34 Y142.242 E-.09585
G1 X153.177 Y142.052 E-.09535
G1 X153.053 Y141.833 E-.09547
G1 X152.973 Y141.594 E-.09573
G1 X152.94 Y141.323 E-.10371
G1 X152.948 Y141.227 E-.03685
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X160.577 Y141.427 Z2.4 F60000
G1 X205.056 Y142.593 Z2.4
G1 Z2
G1 E.8 F1800
G1 F9547.055
M204 S5000
G1 X205.023 Y142.589 E.00098
G3 X205.113 Y139.997 I.226 J-1.29 E.11168
G1 X205.233 Y139.99 E.00361
G3 X205.274 Y142.608 I.016 J1.309 E.12229
G1 X205.116 Y142.597 E.00471
; COOLING_NODE: 4
; WIPE_START
M204 S8000
G1 X205.023 Y142.589 E-.03534
G1 X204.781 Y142.523 E-.09551
G1 X204.556 Y142.411 E-.09542
G1 X204.34 Y142.242 E-.10421
G1 X204.176 Y142.05 E-.09596
G1 X204.044 Y141.812 E-.10332
G1 X203.969 Y141.573 E-.09533
G1 X203.94 Y141.323 E-.09574
G1 X203.948 Y141.22 E-.03915
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X196.355 Y141.999 Z2.4 F60000
G1 X150.46 Y146.71 Z2.4
G1 Z2
G1 E.8 F1800
G1 F9547.055
M204 S5000
G1 X150.46 Y136.71 E.29787
G1 X209.54 Y136.71 E1.75979
G1 X209.54 Y152.79 E.47897
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X172.04 Y152.79 E1.117
G1 X172.04 Y183.29 E.90849
G1 X140.46 Y183.29 E.94066
G1 X140.46 Y146.71 E1.08959
G1 X150.4 Y146.71 E.29608
; WIPE_START
M204 S8000
G1 X150.412 Y144.71 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X154.166 Y151.356 Z2.4 F60000
G1 X171.833 Y182.631 Z2.4
G1 Z2
G1 E.8 F1800
; FEATURE: Top surface
G1 F9547.055
M204 S2000
G1 X171.381 Y183.083 E.01902
G1 X171.248 Y183.216
G1 X170.714 Y183.216
G1 X170.848 Y183.083
G1 X171.833 Y182.098 E.04148
G1 X171.966 Y181.964
G1 X171.966 Y181.431
G1 X171.833 Y181.565
G1 X170.315 Y183.083 E.06394
G1 X170.181 Y183.216
G1 X169.648 Y183.216
G1 X169.781 Y183.083
G1 X171.833 Y181.031 E.08641
G1 X171.966 Y180.898
G1 X171.966 Y180.365
G1 X171.833 Y180.498
G1 X169.248 Y183.083 E.10887
G1 X169.115 Y183.216
G1 X168.581 Y183.216
G1 X168.715 Y183.083
G1 X171.833 Y179.965 E.13133
G1 X171.966 Y179.831
G1 X171.966 Y179.298
G1 X171.833 Y179.432
G1 X168.182 Y183.083 E.15379
G1 X168.048 Y183.216
G1 X167.515 Y183.216
G1 X167.648 Y183.083
G1 X171.833 Y178.898 E.17626
G1 X171.966 Y178.765
G1 X171.966 Y178.232
G1 X171.833 Y178.365
G1 X167.115 Y183.083 E.19872
G1 X166.981 Y183.216
G1 X166.448 Y183.216
G1 X166.582 Y183.083
G1 X171.833 Y177.832 E.22118
G1 X171.966 Y177.698
G1 X171.966 Y177.165
G1 X171.833 Y177.299
G1 X166.049 Y183.083 E.24365
G1 X165.915 Y183.216
G1 X165.382 Y183.216
G1 X165.515 Y183.083
G1 X171.833 Y176.765 E.26611
G1 X171.966 Y176.632
G1 X171.966 Y176.098
G1 X171.833 Y176.232
G1 X169.228 Y178.837 E.10972
G1 X169.094 Y178.97
G1 X169.117 Y178.414
G1 X169.251 Y178.281
G1 X171.833 Y175.699 E.10876
G1 X171.966 Y175.565
G1 X171.966 Y175.032
G1 X171.833 Y175.166
G1 X169.129 Y177.869 E.11389
G1 X168.995 Y178.003
G1 X168.791 Y177.674
G1 X168.924 Y177.541
G1 X171.833 Y174.632 E.12251
G1 X171.966 Y174.499
G1 X171.966 Y173.965
G1 X171.833 Y174.099
G1 X168.651 Y177.28 E.13401
G1 X168.518 Y177.414
G1 X168.175 Y177.223
G1 X168.309 Y177.089
G1 X171.833 Y173.566 E.14843
G1 X171.966 Y173.432
G1 X171.966 Y172.899
G1 X171.833 Y173.033
G1 X167.877 Y176.988 E.16661
G1 X167.744 Y177.121
G1 X167.138 Y177.193
G1 X167.272 Y177.06
G1 X171.833 Y172.499 E.19211
; WIPE_START
M204 S8000
G1 X170.418 Y173.914 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X168.085 Y179.98 Z2.4 F60000
G1 Z2
G1 E.8 F1800
G1 F9547.055
M204 S2000
G1 X164.982 Y183.083 E.13072
G1 X164.848 Y183.216
G1 X164.315 Y183.216
G1 X164.449 Y183.083
G1 X167.531 Y180 E.12984
G1 X167.665 Y179.867
G1 X167.253 Y179.745
G1 X167.119 Y179.879
G1 X163.916 Y183.083 E.13496
G1 X163.782 Y183.216
G1 X163.249 Y183.216
G1 X163.382 Y183.083
G1 X166.79 Y179.674 E.14357
G1 X166.924 Y179.541
G1 X166.664 Y179.268
G1 X166.53 Y179.401
G1 X162.849 Y183.083 E.15507
G1 X162.715 Y183.216
G1 X162.182 Y183.216
G1 X162.316 Y183.083
G1 X166.34 Y179.058 E.16952
G1 X166.474 Y178.925
G1 X166.373 Y178.492
G1 X166.239 Y178.626
G1 X161.783 Y183.083 E.18773
G1 X161.649 Y183.216
G1 X161.116 Y183.216
G1 X161.249 Y183.083
G1 X166.312 Y178.02 E.21325
; WIPE_START
M204 S8000
G1 X164.897 Y179.434 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X160.716 Y183.083 Z2.4 F60000
G1 Z2
G1 E.8 F1800
G1 F9547.055
M204 S2000
G1 X171.833 Y171.966 E.46828
G1 X171.966 Y171.832
G1 X171.966 Y171.299
G1 X171.833 Y171.433
G1 X160.183 Y183.083 E.49074
G1 X160.049 Y183.216
G1 X159.516 Y183.216
G1 X159.65 Y183.083
G1 X171.833 Y170.9 E.51321
G1 X171.966 Y170.766
G1 X171.966 Y170.233
G1 X171.833 Y170.366
G1 X159.116 Y183.083 E.53567
G1 X158.983 Y183.216
G1 X158.449 Y183.216
G1 X158.583 Y183.083
G1 X171.833 Y169.833 E.55813
G1 X171.966 Y169.699
G1 X171.966 Y169.166
G1 X171.833 Y169.3
G1 X158.05 Y183.083 E.5806
G1 X157.916 Y183.216
G1 X157.383 Y183.216
G1 X157.517 Y183.083
G1 X171.833 Y168.767 E.60306
G1 X171.966 Y168.633
G1 X171.966 Y168.1
G1 X171.833 Y168.233
G1 X156.983 Y183.083 E.62552
G1 X156.85 Y183.216
G1 X156.316 Y183.216
G1 X156.45 Y183.083
G1 X171.833 Y167.7 E.64799
G1 X171.966 Y167.566
G1 X171.966 Y167.033
G1 X171.833 Y167.167
M73 P87 R2
G1 X155.917 Y183.083 E.67045
G1 X155.783 Y183.216
G1 X155.25 Y183.216
G1 X155.383 Y183.083
G1 X171.833 Y166.633 E.69291
G1 X171.966 Y166.5
G1 X171.966 Y165.967
G1 X171.833 Y166.1
G1 X154.85 Y183.083 E.71538
G1 X154.717 Y183.216
G1 X154.183 Y183.216
G1 X154.317 Y183.083
G1 X171.833 Y165.567 E.73784
G1 X171.966 Y165.433
G1 X171.966 Y164.9
G1 X171.833 Y165.034
G1 X153.784 Y183.083 E.7603
G1 X153.65 Y183.216
G1 X153.117 Y183.216
G1 X153.25 Y183.083
G1 X171.833 Y164.5 E.78277
G1 X171.966 Y164.367
G1 X171.966 Y163.834
G1 X171.833 Y163.967
G1 X152.717 Y183.083 E.80523
G1 X152.584 Y183.216
G1 X152.05 Y183.216
G1 X152.184 Y183.083
G1 X171.833 Y163.434 E.82769
G1 X171.966 Y163.3
G1 X171.966 Y162.767
G1 X171.833 Y162.901
G1 X151.651 Y183.083 E.85016
G1 X151.517 Y183.216
G1 X150.984 Y183.216
G1 X151.117 Y183.083
G1 X171.833 Y162.367 E.87262
G1 X171.966 Y162.234
G1 X171.966 Y161.701
G1 X171.833 Y161.834
G1 X150.584 Y183.083 E.89508
G1 X150.451 Y183.216
G1 X149.917 Y183.216
G1 X150.051 Y183.083
G1 X171.833 Y161.301 E.91755
G1 X171.966 Y161.167
G1 X171.966 Y160.634
G1 X171.833 Y160.768
G1 X149.518 Y183.083 E.94001
G1 X149.384 Y183.216
G1 X148.851 Y183.216
G1 X148.984 Y183.083
G1 X171.833 Y160.234 E.96247
G1 X171.966 Y160.101
G1 X171.966 Y159.568
G1 X171.833 Y159.701
G1 X148.451 Y183.083 E.98494
G1 X148.317 Y183.216
G1 X147.784 Y183.216
G1 X147.918 Y183.083
G1 X171.833 Y159.168 E1.0074
G1 X171.966 Y159.034
G1 X171.966 Y158.501
G1 X171.833 Y158.635
G1 X147.385 Y183.083 E1.02986
G1 X147.251 Y183.216
G1 X146.718 Y183.216
G1 X146.851 Y183.083
G1 X171.833 Y158.101 E1.05232
G1 X171.966 Y157.968
G1 X171.966 Y157.434
G1 X171.833 Y157.568
G1 X146.318 Y183.083 E1.07479
G1 X146.184 Y183.216
G1 X145.651 Y183.216
G1 X145.785 Y183.083
G1 X171.833 Y157.035 E1.09725
G1 X171.966 Y156.901
G1 X171.966 Y156.368
G1 X171.833 Y156.502
M73 P87 R1
G1 X145.252 Y183.083 E1.11971
G1 X145.118 Y183.216
G1 X144.585 Y183.216
G1 X144.718 Y183.083
G1 X171.833 Y155.968 E1.14218
G1 X171.966 Y155.835
G1 X171.966 Y155.301
G1 X171.833 Y155.435
G1 X144.185 Y183.083 E1.16464
G1 X144.051 Y183.216
G1 X143.518 Y183.216
G1 X143.652 Y183.083
G1 X171.833 Y154.902 E1.1871
G1 X171.966 Y154.768
G1 X171.966 Y154.235
G1 X171.833 Y154.369
G1 X143.119 Y183.083 E1.20957
G1 X142.985 Y183.216
G1 X142.452 Y183.216
G1 X142.585 Y183.083
G1 X171.833 Y153.835 E1.23203
G1 X171.966 Y153.702
G1 X171.966 Y153.168
G1 X171.833 Y153.302
G1 X142.052 Y183.083 E1.25449
G1 X141.918 Y183.216
G1 X141.385 Y183.216
G1 X141.519 Y183.083
G1 X171.833 Y152.769 E1.27696
; WIPE_START
M204 S8000
G1 X170.418 Y154.183 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X178.04 Y153.768 Z2.4 F60000
G1 X209.333 Y152.064 Z2.4
G1 Z2
G1 E.8 F1800
G1 F9547.055
M204 S2000
G1 X208.814 Y152.583 E.02186
G1 X208.68 Y152.716
G1 X208.147 Y152.716
G1 X208.28 Y152.583
G1 X209.333 Y151.53 E.04433
G1 X209.466 Y151.397
G1 X209.466 Y150.863
G1 X209.333 Y150.997
G1 X207.747 Y152.583 E.06679
G1 X207.613 Y152.716
G1 X207.08 Y152.716
G1 X207.214 Y152.583
G1 X209.333 Y150.464 E.08925
G1 X209.466 Y150.33
G1 X209.466 Y149.797
G1 X209.333 Y149.931
G1 X206.681 Y152.583 E.11172
G1 X206.547 Y152.716
G1 X206.014 Y152.716
G1 X206.147 Y152.583
G1 X209.333 Y149.397 E.13418
G1 X209.466 Y149.264
G1 X209.466 Y148.73
G1 X209.333 Y148.864
G1 X205.614 Y152.583 E.15664
G1 X205.48 Y152.716
G1 X204.947 Y152.716
G1 X205.081 Y152.583
G1 X209.333 Y148.331 E.17911
G1 X209.466 Y148.197
G1 X209.466 Y147.664
G1 X209.333 Y147.797
G1 X204.548 Y152.583 E.20157
G1 X204.414 Y152.716
G1 X203.881 Y152.716
G1 X204.014 Y152.583
G1 X209.333 Y147.264 E.22403
G1 X209.466 Y147.131
G1 X209.466 Y146.597
G1 X209.333 Y146.731
G1 X203.481 Y152.583 E.2465
G1 X203.347 Y152.716
G1 X202.814 Y152.716
G1 X202.948 Y152.583
G1 X209.333 Y146.198 E.26896
G1 X209.466 Y146.064
G1 X209.466 Y145.531
G1 X209.333 Y145.664
G1 X202.414 Y152.583 E.29142
G1 X202.281 Y152.716
G1 X201.748 Y152.716
G1 X201.881 Y152.583
G1 X209.333 Y145.131 E.31389
G1 X209.466 Y144.998
G1 X209.466 Y144.464
G1 X209.333 Y144.598
G1 X201.348 Y152.583 E.33635
G1 X201.214 Y152.716
G1 X200.681 Y152.716
G1 X200.815 Y152.583
M73 P88 R1
G1 X209.333 Y144.065 E.35881
G1 X209.466 Y143.931
G1 X209.466 Y143.398
G1 X209.333 Y143.531
G1 X200.281 Y152.583 E.38128
G1 X200.148 Y152.716
G1 X199.615 Y152.716
G1 X199.748 Y152.583
G1 X209.333 Y142.998 E.40374
G1 X209.466 Y142.865
G1 X209.466 Y142.331
G1 X209.333 Y142.465
G1 X199.215 Y152.583 E.4262
G1 X199.081 Y152.716
G1 X198.548 Y152.716
G1 X198.682 Y152.583
G1 X209.333 Y141.932 E.44867
G1 X209.466 Y141.798
G1 X209.466 Y141.265
G1 X209.333 Y141.398
G1 X198.148 Y152.583 E.47113
G1 X198.015 Y152.716
G1 X197.482 Y152.716
G1 X197.615 Y152.583
G1 X209.333 Y140.865 E.49359
G1 X209.466 Y140.732
G1 X209.466 Y140.198
G1 X209.333 Y140.332
G1 X197.082 Y152.583 E.51606
G1 X196.948 Y152.716
G1 X196.415 Y152.716
G1 X196.549 Y152.583
G1 X209.333 Y139.799 E.53852
G1 X209.466 Y139.665
G1 X209.466 Y139.132
G1 X209.333 Y139.265
G1 X206.595 Y142.003 E.11534
G1 X206.461 Y142.137
G1 X206.633 Y141.432
G1 X206.767 Y141.298
G1 X209.333 Y138.732 E.10808
G1 X209.466 Y138.598
G1 X209.466 Y138.065
G1 X209.333 Y138.199
G1 X206.695 Y140.836 E.1111
G1 X206.561 Y140.97
G1 X206.389 Y140.609
G1 X206.523 Y140.476
G1 X209.333 Y137.666 E.11837
G1 X209.466 Y137.532
G1 X209.466 Y136.999
G1 X209.333 Y137.132
G1 X206.279 Y140.186 E.12863
G1 X206.145 Y140.32
G1 X205.834 Y140.097
G1 X205.968 Y139.964
G1 X209.014 Y136.917 E.12833
G1 X209.148 Y136.784
G1 X208.615 Y136.784
G1 X208.481 Y136.917
G1 X205.579 Y139.82 E.12226
G1 X205.445 Y139.953
G1 X204.938 Y139.927
G1 X205.072 Y139.793
G1 X207.948 Y136.917 E.12115
; WIPE_START
M204 S8000
G1 X206.534 Y138.332 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X205.955 Y142.643 Z2.4 F60000
G1 Z2
G1 E.8 F1800
G1 F9547.055
M204 S2000
G1 X196.015 Y152.583 E.41872
G1 X195.882 Y152.716
G1 X195.348 Y152.716
G1 X195.482 Y152.583
G1 X205.248 Y142.817 E.41138
G1 X205.382 Y142.683
G1 X204.921 Y142.61
G1 X204.788 Y142.744
G1 X194.949 Y152.583 E.41446
G1 X194.815 Y152.716
G1 X194.282 Y152.716
G1 X194.416 Y152.583
G1 X204.425 Y142.573 E.42165
G1 X204.559 Y142.439
G1 X204.27 Y142.195
G1 X204.136 Y142.329
G1 X193.882 Y152.583 E.43195
G1 X193.749 Y152.716
G1 X193.215 Y152.716
G1 X193.349 Y152.583
G1 X203.914 Y142.018 E.44503
G1 X204.047 Y141.884
G1 X203.903 Y141.496
G1 X203.769 Y141.63
G1 X192.816 Y152.583 E.46139
G1 X192.682 Y152.716
G1 X192.149 Y152.716
G1 X192.283 Y152.583
G1 X203.744 Y141.121 E.48281
; WIPE_START
M204 S8000
G1 X202.33 Y142.535 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X207.415 Y136.917 Z2.4 F60000
G1 Z2
G1 E.8 F1800
G1 F9547.055
M204 S2000
G1 X191.749 Y152.583 E.65989
G1 X191.616 Y152.716
G1 X191.082 Y152.716
G1 X191.216 Y152.583
G1 X206.881 Y136.917 E.65989
G1 X207.015 Y136.784
G1 X206.482 Y136.784
G1 X206.348 Y136.917
G1 X190.683 Y152.583 E.65989
G1 X190.549 Y152.716
G1 X190.016 Y152.716
G1 X190.15 Y152.583
G1 X205.815 Y136.917 E.65989
G1 X205.948 Y136.784
G1 X205.415 Y136.784
G1 X205.282 Y136.917
G1 X189.616 Y152.583 E.65989
G1 X189.483 Y152.716
G1 X188.949 Y152.716
G1 X189.083 Y152.583
G1 X204.748 Y136.917 E.65989
G1 X204.882 Y136.784
G1 X204.349 Y136.784
G1 X204.215 Y136.917
G1 X188.55 Y152.583 E.65989
G1 X188.416 Y152.716
G1 X187.883 Y152.716
G1 X188.017 Y152.583
G1 X203.682 Y136.917 E.65989
G1 X203.815 Y136.784
G1 X203.282 Y136.784
G1 X203.148 Y136.917
G1 X187.483 Y152.583 E.65989
G1 X187.35 Y152.716
G1 X186.816 Y152.716
G1 X186.95 Y152.583
G1 X202.615 Y136.917 E.65989
G1 X202.749 Y136.784
G1 X202.216 Y136.784
G1 X202.082 Y136.917
G1 X186.417 Y152.583 E.65989
G1 X186.283 Y152.716
G1 X185.75 Y152.716
G1 X185.883 Y152.583
G1 X201.549 Y136.917 E.65989
G1 X201.682 Y136.784
G1 X201.149 Y136.784
G1 X201.015 Y136.917
G1 X185.35 Y152.583 E.65989
G1 X185.217 Y152.716
G1 X184.683 Y152.716
G1 X184.817 Y152.583
G1 X200.482 Y136.917 E.65989
G1 X200.616 Y136.784
G1 X200.083 Y136.784
G1 X199.949 Y136.917
G1 X184.284 Y152.583 E.65989
G1 X184.15 Y152.716
G1 X183.617 Y152.716
G1 X183.75 Y152.583
G1 X199.416 Y136.917 E.65989
G1 X199.549 Y136.784
G1 X199.016 Y136.784
G1 X198.882 Y136.917
G1 X183.217 Y152.583 E.65989
G1 X183.084 Y152.716
G1 X182.55 Y152.716
G1 X182.684 Y152.583
G1 X198.349 Y136.917 E.65989
G1 X198.483 Y136.784
G1 X197.95 Y136.784
G1 X197.816 Y136.917
G1 X182.151 Y152.583 E.65989
G1 X182.017 Y152.716
G1 X181.484 Y152.716
G1 X181.617 Y152.583
G1 X197.283 Y136.917 E.65989
G1 X197.416 Y136.784
G1 X196.883 Y136.784
G1 X196.749 Y136.917
G1 X181.084 Y152.583 E.65989
G1 X180.951 Y152.716
G1 X180.417 Y152.716
G1 X180.551 Y152.583
G1 X196.216 Y136.917 E.65989
G1 X196.35 Y136.784
G1 X195.817 Y136.784
G1 X195.683 Y136.917
G1 X180.018 Y152.583 E.65989
G1 X179.884 Y152.716
G1 X179.351 Y152.716
G1 X179.484 Y152.583
G1 X195.15 Y136.917 E.65989
G1 X195.283 Y136.784
G1 X194.75 Y136.784
G1 X194.616 Y136.917
G1 X178.951 Y152.583 E.65989
G1 X178.818 Y152.716
G1 X178.284 Y152.716
G1 X178.418 Y152.583
G1 X194.083 Y136.917 E.65989
G1 X194.217 Y136.784
G1 X193.684 Y136.784
G1 X193.55 Y136.917
G1 X177.885 Y152.583 E.65989
G1 X177.751 Y152.716
G1 X177.218 Y152.716
G1 X177.351 Y152.583
G1 X193.017 Y136.917 E.65989
G1 X193.15 Y136.784
G1 X192.617 Y136.784
G1 X192.483 Y136.917
M73 P89 R1
G1 X176.818 Y152.583 E.65989
G1 X176.684 Y152.716
G1 X176.151 Y152.716
G1 X176.285 Y152.583
G1 X191.95 Y136.917 E.65989
G1 X192.084 Y136.784
G1 X191.55 Y136.784
G1 X191.417 Y136.917
G1 X175.752 Y152.583 E.65989
G1 X175.618 Y152.716
G1 X175.085 Y152.716
G1 X175.218 Y152.583
G1 X190.884 Y136.917 E.65989
G1 X191.017 Y136.784
G1 X190.484 Y136.784
G1 X190.35 Y136.917
G1 X174.685 Y152.583 E.65989
G1 X174.551 Y152.716
G1 X174.018 Y152.716
G1 X174.152 Y152.583
G1 X189.817 Y136.917 E.65989
G1 X189.951 Y136.784
G1 X189.417 Y136.784
G1 X189.284 Y136.917
G1 X173.619 Y152.583 E.65989
G1 X173.485 Y152.716
G1 X172.952 Y152.716
G1 X173.085 Y152.583
G1 X188.751 Y136.917 E.65989
G1 X188.884 Y136.784
G1 X188.351 Y136.784
G1 X188.217 Y136.917
G1 X172.552 Y152.583 E.65989
G1 X172.418 Y152.716
G1 X171.885 Y152.716
G1 X172.019 Y152.583
G1 X187.684 Y136.917 E.65989
G1 X187.818 Y136.784
G1 X187.284 Y136.784
G1 X187.151 Y136.917
G1 X140.986 Y183.083 E1.94469
G1 X140.852 Y183.216
G1 X140.534 Y183.001
G1 X140.667 Y182.867
G1 X186.618 Y136.917 E1.93563
G1 X186.751 Y136.784
G1 X186.218 Y136.784
G1 X186.084 Y136.917
G1 X140.667 Y182.334 E1.91317
G1 X140.534 Y182.468
G1 X140.534 Y181.935
G1 X140.667 Y181.801
G1 X185.551 Y136.917 E1.8907
G1 X185.685 Y136.784
G1 X185.151 Y136.784
G1 X185.018 Y136.917
G1 X140.667 Y181.268 E1.86824
G1 X140.534 Y181.401
G1 X140.534 Y180.868
G1 X140.667 Y180.734
G1 X184.484 Y136.917 E1.84578
G1 X184.618 Y136.784
G1 X184.085 Y136.784
G1 X183.951 Y136.917
G1 X140.667 Y180.201 E1.82331
G1 X140.534 Y180.335
G1 X140.534 Y179.802
G1 X140.667 Y179.668
G1 X183.418 Y136.917 E1.80085
G1 X183.552 Y136.784
G1 X183.018 Y136.784
G1 X182.885 Y136.917
G1 X140.667 Y179.135 E1.77839
G1 X140.534 Y179.268
G1 X140.534 Y178.735
G1 X140.667 Y178.601
G1 X182.351 Y136.917 E1.75592
G1 X182.485 Y136.784
G1 X181.952 Y136.784
G1 X181.818 Y136.917
G1 X140.667 Y178.068 E1.73346
G1 X140.534 Y178.202
G1 X140.534 Y177.669
G1 X140.667 Y177.535
G1 X181.285 Y136.917 E1.711
G1 X181.419 Y136.784
G1 X180.885 Y136.784
G1 X180.752 Y136.917
G1 X140.667 Y177.002 E1.68853
G1 X140.534 Y177.135
G1 X140.534 Y176.602
G1 X140.667 Y176.468
G1 X180.218 Y136.917 E1.66607
G1 X180.352 Y136.784
G1 X179.819 Y136.784
G1 X179.685 Y136.917
G1 X140.667 Y175.935 E1.64361
G1 X140.534 Y176.069
G1 X140.534 Y175.536
G1 X140.667 Y175.402
G1 X179.152 Y136.917 E1.62114
G1 X179.286 Y136.784
G1 X178.752 Y136.784
G1 X178.619 Y136.917
G1 X140.667 Y174.869 E1.59868
G1 X140.534 Y175.002
G1 X140.534 Y174.469
G1 X140.667 Y174.335
M73 P90 R1
G1 X178.085 Y136.917 E1.57622
G1 X178.219 Y136.784
G1 X177.686 Y136.784
G1 X177.552 Y136.917
G1 X140.667 Y173.802 E1.55375
G1 X140.534 Y173.936
G1 X140.534 Y173.403
G1 X140.667 Y173.269
G1 X177.019 Y136.917 E1.53129
G1 X177.153 Y136.784
G1 X176.619 Y136.784
G1 X176.486 Y136.917
G1 X140.667 Y172.736 E1.50883
G1 X140.534 Y172.869
G1 X140.534 Y172.336
G1 X140.667 Y172.202
G1 X175.952 Y136.917 E1.48637
G1 X176.086 Y136.784
G1 X175.553 Y136.784
G1 X175.419 Y136.917
G1 X140.667 Y171.669 E1.4639
G1 X140.534 Y171.803
G1 X140.534 Y171.269
G1 X140.667 Y171.136
G1 X155.966 Y155.838 E.64444
G1 X156.099 Y155.704
G1 X155.387 Y155.883
G1 X155.253 Y156.017
G1 X140.667 Y170.603 E.61441
G1 X140.534 Y170.736
G1 X140.534 Y170.203
G1 X140.667 Y170.069
G1 X154.791 Y155.945 E.59497
G1 X154.925 Y155.812
G1 X154.561 Y155.642
G1 X154.428 Y155.776
G1 X140.667 Y169.536 E.57965
G1 X140.534 Y169.67
G1 X140.534 Y169.136
G1 X140.667 Y169.003
G1 X154.139 Y155.531 E.56748
G1 X154.273 Y155.398
G1 X154.049 Y155.088
G1 X153.915 Y155.222
G1 X140.667 Y168.47 E.55806
G1 X140.534 Y168.603
G1 X140.534 Y168.07
G1 X140.667 Y167.936
G1 X153.77 Y154.834 E.55194
G1 X153.904 Y154.7
G1 X153.878 Y154.193
G1 X153.744 Y154.326
G1 X140.667 Y167.403 E.55085
; WIPE_START
M204 S8000
G1 X142.082 Y165.989 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X148.209 Y161.438 Z2.4 F60000
G1 X156.587 Y155.216 Z2.4
G1 Z2
G1 E.8 F1800
G1 F9547.055
M204 S2000
G1 X174.886 Y136.917 E.77084
G1 X175.019 Y136.784
G1 X174.486 Y136.784
G1 X174.353 Y136.917
G1 X156.767 Y154.503 E.7408
G1 X156.633 Y154.637
G1 X156.563 Y154.174
G1 X156.696 Y154.04
G1 X173.819 Y136.917 E.72129
G1 X173.953 Y136.784
G1 X173.42 Y136.784
G1 X173.286 Y136.917
G1 X156.524 Y153.679 E.70608
G1 X156.391 Y153.813
G1 X156.148 Y153.522
G1 X156.282 Y153.388
G1 X172.753 Y136.917 E.69383
G1 X172.886 Y136.784
G1 X172.353 Y136.784
G1 X172.22 Y136.917
G1 X155.971 Y153.166 E.68446
G1 X155.838 Y153.299
G1 X155.449 Y153.154
G1 X155.583 Y153.021
G1 X171.686 Y136.917 E.67835
G1 X171.82 Y136.784
G1 X171.287 Y136.784
G1 X171.153 Y136.917
G1 X155.078 Y152.992 E.67716
; WIPE_START
M204 S8000
G1 X156.492 Y151.578 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X151.003 Y156.882 Z2.4 F60000
G1 X140.667 Y166.87 Z2.4
G1 Z2
G1 E.8 F1800
G1 F9547.055
M204 S2000
G1 X170.62 Y136.917 E1.26173
G1 X170.753 Y136.784
G1 X170.22 Y136.784
G1 X170.087 Y136.917
G1 X140.667 Y166.337 E1.23927
G1 X140.534 Y166.47
G1 X140.534 Y165.937
G1 X140.667 Y165.803
G1 X169.553 Y136.917 E1.21681
G1 X169.687 Y136.784
G1 X169.154 Y136.784
G1 X169.02 Y136.917
G1 X140.667 Y165.27 E1.19434
G1 X140.534 Y165.404
G1 X140.534 Y164.87
G1 X140.667 Y164.737
G1 X168.487 Y136.917 E1.17188
G1 X168.62 Y136.784
G1 X168.087 Y136.784
G1 X167.953 Y136.917
G1 X140.667 Y164.203 E1.14942
G1 X140.534 Y164.337
G1 X140.534 Y163.804
G1 X140.667 Y163.67
G1 X167.42 Y136.917 E1.12695
G1 X167.554 Y136.784
G1 X167.021 Y136.784
G1 X166.887 Y136.917
G1 X140.667 Y163.137 E1.10449
G1 X140.534 Y163.271
G1 X140.534 Y162.737
G1 X140.667 Y162.604
G1 X166.354 Y136.917 E1.08203
G1 X166.487 Y136.784
G1 X165.954 Y136.784
G1 X165.82 Y136.917
G1 X140.667 Y162.07 E1.05956
G1 X140.534 Y162.204
G1 X140.534 Y161.671
G1 X140.667 Y161.537
G1 X165.287 Y136.917 E1.0371
G1 X165.421 Y136.784
G1 X164.888 Y136.784
G1 X164.754 Y136.917
M73 P91 R1
G1 X140.667 Y161.004 E1.01464
G1 X140.534 Y161.138
G1 X140.534 Y160.604
G1 X140.667 Y160.471
G1 X164.221 Y136.917 E.99217
G1 X164.354 Y136.784
G1 X163.821 Y136.784
G1 X163.687 Y136.917
G1 X140.667 Y159.937 E.96971
G1 X140.534 Y160.071
G1 X140.534 Y159.538
G1 X140.667 Y159.404
G1 X163.154 Y136.917 E.94725
G1 X163.288 Y136.784
G1 X162.755 Y136.784
G1 X162.621 Y136.917
G1 X140.667 Y158.871 E.92478
G1 X140.534 Y159.005
G1 X140.534 Y158.471
G1 X140.667 Y158.338
G1 X162.088 Y136.917 E.90232
G1 X162.221 Y136.784
G1 X161.688 Y136.784
G1 X161.554 Y136.917
G1 X140.667 Y157.804 E.87986
G1 X140.534 Y157.938
G1 X140.534 Y157.405
G1 X140.667 Y157.271
G1 X161.021 Y136.917 E.85739
G1 X161.155 Y136.784
G1 X160.622 Y136.784
G1 X160.488 Y136.917
G1 X155.717 Y141.689 E.20098
G1 X155.583 Y141.822
G1 X155.622 Y141.25
G1 X155.756 Y141.116
G1 X159.955 Y136.917 E.17688
G1 X160.088 Y136.784
G1 X159.555 Y136.784
G1 X159.421 Y136.917
G1 X155.642 Y140.697 E.15919
G1 X155.509 Y140.83
G1 X155.309 Y140.497
G1 X155.442 Y140.363
G1 X158.888 Y136.917 E.14515
G1 X159.022 Y136.784
G1 X158.488 Y136.784
G1 X158.355 Y136.917
G1 X155.175 Y140.097 E.13395
G1 X155.041 Y140.231
G1 X154.704 Y140.035
G1 X154.838 Y139.901
G1 X157.822 Y136.917 E.1257
G1 X157.955 Y136.784
G1 X157.422 Y136.784
G1 X157.288 Y136.917
G1 X154.414 Y139.792 E.1211
G1 X154.28 Y139.926
G1 X153.696 Y139.976
G1 X153.83 Y139.842
G1 X156.755 Y136.917 E.12321
; WIPE_START
M204 S8000
G1 X155.341 Y138.332 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X154.641 Y142.765 Z2.4 F60000
G1 Z2
G1 E.8 F1800
G1 F9547.055
M204 S2000
G1 X150.667 Y146.738 E.16737
G1 X150.534 Y146.872
G1 X150.534 Y146.338
G1 X150.667 Y146.205
G1 X154.067 Y142.805 E.14321
G1 X154.201 Y142.671
G1 X153.781 Y142.558
G1 X153.648 Y142.691
G1 X150.667 Y145.671 E.12554
G1 X150.534 Y145.805
G1 X150.534 Y145.272
G1 X150.667 Y145.138
G1 X153.312 Y142.493 E.11141
G1 X153.446 Y142.36
G1 X153.182 Y142.091
G1 X153.048 Y142.224
G1 X150.667 Y144.605 E.10028
G1 X150.534 Y144.738
G1 X150.534 Y144.205
G1 X150.667 Y144.072
G1 X152.852 Y141.887 E.09201
G1 X152.985 Y141.754
G1 X152.876 Y141.33
G1 X152.742 Y141.464
G1 X150.667 Y143.538 E.08739
G1 X150.534 Y143.672
G1 X150.534 Y143.139
G1 X150.667 Y143.005
G1 X152.791 Y140.882 E.08945
; WIPE_START
M204 S8000
G1 X151.377 Y142.296 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X150.667 Y142.472 Z2.4 F60000
G1 Z2
G1 E.8 F1800
G1 F9547.055
M204 S2000
G1 X156.222 Y136.917 E.23398
G1 X156.355 Y136.784
G1 X155.822 Y136.784
G1 X155.689 Y136.917
G1 X150.667 Y141.939 E.21152
G1 X150.534 Y142.072
G1 X150.534 Y141.539
G1 X150.667 Y141.405
G1 X155.155 Y136.917 E.18905
G1 X155.289 Y136.784
G1 X154.756 Y136.784
G1 X154.622 Y136.917
G1 X150.667 Y140.872 E.16659
G1 X150.534 Y141.006
G1 X150.534 Y140.472
G1 X150.667 Y140.339
G1 X154.089 Y136.917 E.14413
G1 X154.222 Y136.784
G1 X153.689 Y136.784
G1 X153.556 Y136.917
G1 X150.667 Y139.806 E.12166
G1 X150.534 Y139.939
G1 X150.534 Y139.406
G1 X150.667 Y139.272
G1 X153.022 Y136.917 E.0992
G1 X153.156 Y136.784
G1 X152.623 Y136.784
G1 X152.489 Y136.917
G1 X150.667 Y138.739 E.07674
G1 X150.534 Y138.873
G1 X150.534 Y138.339
G1 X150.667 Y138.206
G1 X151.956 Y136.917 E.05427
G1 X152.089 Y136.784
G1 X151.556 Y136.784
G1 X151.423 Y136.917
G1 X150.667 Y137.673 E.03181
; WIPE_START
M204 S8000
G1 X151.423 Y136.917 E-.40581
G1 X151.556 Y136.784 E-.07182
G1 X152.089 Y136.784 E-.20264
G1 X151.956 Y136.917 E-.07182
G1 X151.941 Y136.932 E-.00792
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X150.842 Y144.485 Z2.4 F60000
G1 X150.488 Y146.917 Z2.4
G1 Z2
G1 E.8 F1800
G1 F9547.055
M204 S2000
G1 X140.667 Y156.738 E.41368
G1 X140.534 Y156.872
G1 X140.534 Y156.338
G1 X140.667 Y156.205
G1 X149.955 Y146.917 E.39122
G1 X150.088 Y146.784
G1 X149.555 Y146.784
G1 X149.421 Y146.917
G1 X140.667 Y155.671 E.36876
G1 X140.534 Y155.805
G1 X140.534 Y155.272
G1 X140.667 Y155.138
G1 X148.888 Y146.917 E.3463
G1 X149.022 Y146.784
G1 X148.488 Y146.784
G1 X148.355 Y146.917
G1 X140.667 Y154.605 E.32383
G1 X140.534 Y154.738
G1 X140.534 Y154.205
G1 X140.667 Y154.072
G1 X147.822 Y146.917 E.30137
G1 X147.955 Y146.784
G1 X147.422 Y146.784
G1 X147.288 Y146.917
G1 X140.667 Y153.538 E.27891
G1 X140.534 Y153.672
G1 X140.534 Y153.139
G1 X140.667 Y153.005
G1 X146.755 Y146.917 E.25644
G1 X146.889 Y146.784
G1 X146.355 Y146.784
G1 X146.222 Y146.917
G1 X140.667 Y152.472 E.23398
G1 X140.534 Y152.605
G1 X140.534 Y152.072
G1 X140.667 Y151.939
G1 X145.689 Y146.917 E.21152
G1 X145.822 Y146.784
G1 X145.289 Y146.784
G1 X145.155 Y146.917
G1 X140.667 Y151.405 E.18905
G1 X140.534 Y151.539
G1 X140.534 Y151.006
G1 X140.667 Y150.872
G1 X144.622 Y146.917 E.16659
G1 X144.756 Y146.784
G1 X144.222 Y146.784
G1 X144.089 Y146.917
G1 X140.667 Y150.339 E.14413
G1 X140.534 Y150.472
G1 X140.534 Y149.939
G1 X140.667 Y149.806
G1 X143.556 Y146.917 E.12166
G1 X143.689 Y146.784
G1 X143.156 Y146.784
G1 X143.022 Y146.917
G1 X140.667 Y149.272 E.0992
G1 X140.534 Y149.406
G1 X140.534 Y148.873
G1 X140.667 Y148.739
G1 X142.489 Y146.917 E.07674
G1 X142.623 Y146.784
G1 X142.089 Y146.784
G1 X141.956 Y146.917
G1 X140.667 Y148.206 E.05427
G1 X140.534 Y148.339
G1 X140.534 Y147.806
G1 X140.667 Y147.673
G1 X141.423 Y146.917 E.03181
; WIPE_START
M204 S8000
G1 X140.667 Y147.673 E-.40581
G1 X140.534 Y147.806 E-.07182
G1 X140.534 Y148.339 E-.20264
G1 X140.667 Y148.206 E-.07182
G1 X140.682 Y148.191 E-.00792
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X148.284 Y147.514 Z2.4 F60000
G1 X206.429 Y142.335 Z2.4
G1 Z2
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.196032
G1 F15000
M204 S8000
G1 X206.259 Y142.504 E.0029
G1 X206.017 Y142.705 E.00379
; WIPE_START
G1 X206.259 Y142.504 E-.43082
G1 X206.429 Y142.335 E-.32918
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X200.706 Y147.386 Z2.4 F60000
G1 X166.93 Y177.196 Z2.4
G1 Z2
G1 E.8 F1800
; LINE_WIDTH: 0.101622
G1 F15000
M204 S8000
G1 X166.658 Y177.44 E.0017
G1 X166.458 Y177.664 E.00139
; LINE_WIDTH: 0.14402
G1 X166.359 Y177.794 E.00131
; LINE_WIDTH: 0.186238
G1 X166.247 Y177.956 E.00223
; WIPE_START
G1 X166.359 Y177.794 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X168.476 Y179.847 Z2.4 F60000
G1 Z2
G1 E.8 F1800
; LINE_WIDTH: 0.189386
G1 F15000
M204 S8000
G3 X168.149 Y180.044 I-4.221 J-6.649 E.00441
M204 S10000
G1 X168.468 Y179.836 F60000
; LINE_WIDTH: 0.119853
G1 F15000
M204 S8000
G3 X168.157 Y180.051 I-4.602 J-6.332 E.0023
; WIPE_START
G1 X168.468 Y179.836 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X165.158 Y172.959 Z2.4 F60000
G1 X156.648 Y155.277 Z2.4
G1 Z2
G1 E.8 F1800
; LINE_WIDTH: 0.200093
G1 F15000
M204 S8000
G1 X156.297 Y155.67 E.00654
; WIPE_START
G1 X156.648 Y155.277 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X154.83 Y147.865 Z2.4 F60000
G1 X153.007 Y140.429 Z2.4
G1 Z2
G1 E.8 F1800
; LINE_WIDTH: 0.108468
G1 F15000
M204 S8000
G1 X152.873 Y140.599 E.00112
; LINE_WIDTH: 0.160102
G1 X152.795 Y140.711 E.00127
; LINE_WIDTH: 0.19509
G1 X152.728 Y140.818 E.00152
; WIPE_START
G1 X152.795 Y140.711 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X153.486 Y139.971 Z2.4 F60000
G1 Z2
G1 E.8 F1800
; LINE_WIDTH: 0.0974202
G1 F15000
M204 S8000
G1 X153.383 Y140.052 E.00057
; WIPE_START
G1 X153.486 Y139.971 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X155.062 Y142.582 Z2.4 F60000
G1 Z2
G1 E.8 F1800
; LINE_WIDTH: 0.0956963
G1 F15000
M204 S8000
G1 X154.991 Y142.638 E.00037
; LINE_WIDTH: 0.140435
G3 X154.71 Y142.834 I-4.044 J-5.512 E.00264
; CHANGE_LAYER
; Z_HEIGHT: 2.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F15000
G1 X154.991 Y142.638 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 11/54
; update layer progress
M73 L11
M991 S0 P10 ;notify layer change

M106 S229.5
; OBJECT_ID: 15
; COOLING_NODE: 5
M204 S10000
G17
G3 Z2.4 I-.885 J.835 P1  F60000
G1 X160.148 Y148.102 Z2.4
G1 Z2.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X160.148 Y148.898 E.02559
G1 X159.352 Y148.898 E.02559
G1 X159.352 Y148.102 E.02559
G1 X160.088 Y148.102 E.02366
; COOLING_NODE: 5
M204 S250
G1 X160.54 Y147.71 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X160.54 Y149.29 E.04706
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X158.96 Y149.29 E.04706
G1 X158.96 Y147.71 E.04706
G1 X160.48 Y147.71 E.04528
; COOLING_NODE: 6
; WIPE_START
G1 F9547.055
M204 S8000
G1 X160.54 Y149.29 E-.60084
G1 X160.121 Y149.29 E-.15916
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X160.148 Y143.098 Z2.6 F60000
G1 Z2.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
M73 P92 R1
G1 X159.352 Y143.098 E.02559
G1 X159.352 Y142.302 E.02559
G1 X160.148 Y142.302 E.02559
G1 X160.148 Y143.038 E.02366
; COOLING_NODE: 6
M204 S250
G1 X160.54 Y143.49 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X158.96 Y143.49 E.04706
G1 X158.96 Y141.91 E.04706
G1 X160.54 Y141.91 E.04706
G1 X160.54 Y143.43 E.04528
; CHANGE_LAYER
; Z_HEIGHT: 2.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9547.055
M204 S8000
G1 X158.96 Y143.49 E-.60084
G1 X158.96 Y143.071 E-.15916
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 12/54
; update layer progress
M73 L12
M991 S0 P11 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 5
M204 S10000
G17
G3 Z2.6 I-1.184 J.28 P1  F60000
G1 X160.148 Y148.102 Z2.6
G1 Z2.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X160.148 Y148.898 E.02559
G1 X159.352 Y148.898 E.02559
G1 X159.352 Y148.102 E.02559
G1 X160.088 Y148.102 E.02366
; COOLING_NODE: 5
M204 S250
G1 X160.54 Y147.71 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X160.54 Y149.29 E.04706
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X158.96 Y149.29 E.04706
G1 X158.96 Y147.71 E.04706
G1 X160.48 Y147.71 E.04528
; COOLING_NODE: 6
; WIPE_START
G1 F9547.055
M204 S8000
G1 X160.54 Y149.29 E-.60084
G1 X160.121 Y149.29 E-.15916
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X160.148 Y143.098 Z2.8 F60000
G1 Z2.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X159.352 Y143.098 E.02559
G1 X159.352 Y142.302 E.02559
G1 X160.148 Y142.302 E.02559
G1 X160.148 Y143.038 E.02366
; COOLING_NODE: 6
M204 S250
G1 X160.54 Y143.49 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X158.96 Y143.49 E.04706
G1 X158.96 Y141.91 E.04706
G1 X160.54 Y141.91 E.04706
G1 X160.54 Y143.43 E.04528
; CHANGE_LAYER
; Z_HEIGHT: 2.6
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9547.055
M204 S8000
G1 X158.96 Y143.49 E-.60084
G1 X158.96 Y143.071 E-.15916
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 13/54
; update layer progress
M73 L13
M991 S0 P12 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 5
M204 S10000
G17
G3 Z2.8 I-1.184 J.28 P1  F60000
G1 X160.148 Y148.102 Z2.8
G1 Z2.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X160.148 Y148.898 E.02559
G1 X159.352 Y148.898 E.02559
G1 X159.352 Y148.102 E.02559
G1 X160.088 Y148.102 E.02366
; COOLING_NODE: 5
M204 S250
G1 X160.54 Y147.71 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X160.54 Y149.29 E.04706
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X158.96 Y149.29 E.04706
G1 X158.96 Y147.71 E.04706
G1 X160.48 Y147.71 E.04528
; COOLING_NODE: 6
; WIPE_START
G1 F9547.055
M204 S8000
G1 X160.54 Y149.29 E-.60084
G1 X160.121 Y149.29 E-.15916
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X160.148 Y143.098 Z3 F60000
G1 Z2.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X159.352 Y143.098 E.02559
G1 X159.352 Y142.302 E.02559
G1 X160.148 Y142.302 E.02559
G1 X160.148 Y143.038 E.02366
; COOLING_NODE: 6
M204 S250
G1 X160.54 Y143.49 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X158.96 Y143.49 E.04706
G1 X158.96 Y141.91 E.04706
G1 X160.54 Y141.91 E.04706
G1 X160.54 Y143.43 E.04528
; CHANGE_LAYER
; Z_HEIGHT: 2.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9547.055
M204 S8000
G1 X158.96 Y143.49 E-.60084
G1 X158.96 Y143.071 E-.15916
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 14/54
; update layer progress
M73 L14
M991 S0 P13 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 5
M204 S10000
G17
G3 Z3 I-1.184 J.28 P1  F60000
G1 X160.148 Y148.102 Z3
G1 Z2.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X160.148 Y148.898 E.02559
G1 X159.352 Y148.898 E.02559
G1 X159.352 Y148.102 E.02559
G1 X160.088 Y148.102 E.02366
; COOLING_NODE: 5
M204 S250
G1 X160.54 Y147.71 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X160.54 Y149.29 E.04706
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X158.96 Y149.29 E.04706
G1 X158.96 Y147.71 E.04706
G1 X160.48 Y147.71 E.04528
; COOLING_NODE: 6
; WIPE_START
G1 F9547.055
M204 S8000
G1 X160.54 Y149.29 E-.60084
G1 X160.121 Y149.29 E-.15916
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X160.148 Y143.098 Z3.2 F60000
G1 Z2.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X159.352 Y143.098 E.02559
G1 X159.352 Y142.302 E.02559
G1 X160.148 Y142.302 E.02559
G1 X160.148 Y143.038 E.02366
; COOLING_NODE: 6
M204 S250
G1 X160.54 Y143.49 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X158.96 Y143.49 E.04706
G1 X158.96 Y141.91 E.04706
G1 X160.54 Y141.91 E.04706
G1 X160.54 Y143.43 E.04528
; CHANGE_LAYER
; Z_HEIGHT: 3
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9547.055
M204 S8000
G1 X158.96 Y143.49 E-.60084
G1 X158.96 Y143.071 E-.15916
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 15/54
; update layer progress
M73 L15
M991 S0 P14 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 5
M204 S10000
G17
G3 Z3.2 I-1.184 J.28 P1  F60000
G1 X160.148 Y148.102 Z3.2
G1 Z3
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X160.148 Y148.898 E.02559
G1 X159.352 Y148.898 E.02559
G1 X159.352 Y148.102 E.02559
G1 X160.088 Y148.102 E.02366
; COOLING_NODE: 5
M204 S250
G1 X160.54 Y147.71 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X160.54 Y149.29 E.04706
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X158.96 Y149.29 E.04706
G1 X158.96 Y147.71 E.04706
G1 X160.48 Y147.71 E.04528
; COOLING_NODE: 6
; WIPE_START
G1 F9547.055
M204 S8000
G1 X160.54 Y149.29 E-.60084
G1 X160.121 Y149.29 E-.15916
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X160.148 Y143.098 Z3.4 F60000
G1 Z3
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X159.352 Y143.098 E.02559
G1 X159.352 Y142.302 E.02559
G1 X160.148 Y142.302 E.02559
G1 X160.148 Y143.038 E.02366
; COOLING_NODE: 6
M204 S250
G1 X160.54 Y143.49 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X158.96 Y143.49 E.04706
G1 X158.96 Y141.91 E.04706
G1 X160.54 Y141.91 E.04706
G1 X160.54 Y143.43 E.04528
; CHANGE_LAYER
; Z_HEIGHT: 3.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9547.055
M204 S8000
G1 X158.96 Y143.49 E-.60084
G1 X158.96 Y143.071 E-.15916
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 16/54
; update layer progress
M73 L16
M991 S0 P15 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 5
M204 S10000
G17
G3 Z3.4 I-1.184 J.28 P1  F60000
G1 X160.148 Y148.102 Z3.4
G1 Z3.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X160.148 Y148.898 E.02559
G1 X159.352 Y148.898 E.02559
G1 X159.352 Y148.102 E.02559
G1 X160.088 Y148.102 E.02366
; COOLING_NODE: 5
M204 S250
G1 X160.54 Y147.71 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X160.54 Y149.29 E.04706
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X158.96 Y149.29 E.04706
G1 X158.96 Y147.71 E.04706
G1 X160.48 Y147.71 E.04528
; COOLING_NODE: 6
; WIPE_START
G1 F9547.055
M204 S8000
G1 X160.54 Y149.29 E-.60084
G1 X160.121 Y149.29 E-.15916
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X160.148 Y143.098 Z3.6 F60000
G1 Z3.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X159.352 Y143.098 E.02559
G1 X159.352 Y142.302 E.02559
G1 X160.148 Y142.302 E.02559
G1 X160.148 Y143.038 E.02366
; COOLING_NODE: 6
M204 S250
G1 X160.54 Y143.49 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X158.96 Y143.49 E.04706
G1 X158.96 Y141.91 E.04706
G1 X160.54 Y141.91 E.04706
G1 X160.54 Y143.43 E.04528
; CHANGE_LAYER
; Z_HEIGHT: 3.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9547.055
M204 S8000
G1 X158.96 Y143.49 E-.60084
G1 X158.96 Y143.071 E-.15916
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 17/54
; update layer progress
M73 L17
M991 S0 P16 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 5
M204 S10000
G17
G3 Z3.6 I-1.184 J.28 P1  F60000
G1 X160.148 Y148.102 Z3.6
G1 Z3.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X160.148 Y148.898 E.02559
G1 X159.352 Y148.898 E.02559
G1 X159.352 Y148.102 E.02559
G1 X160.088 Y148.102 E.02366
; COOLING_NODE: 5
M204 S250
G1 X160.54 Y147.71 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X160.54 Y149.29 E.04706
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X158.96 Y149.29 E.04706
G1 X158.96 Y147.71 E.04706
G1 X160.48 Y147.71 E.04528
; COOLING_NODE: 6
; WIPE_START
G1 F9547.055
M204 S8000
G1 X160.54 Y149.29 E-.60084
G1 X160.121 Y149.29 E-.15916
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X160.148 Y143.098 Z3.8 F60000
G1 Z3.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X159.352 Y143.098 E.02559
G1 X159.352 Y142.302 E.02559
G1 X160.148 Y142.302 E.02559
G1 X160.148 Y143.038 E.02366
; COOLING_NODE: 6
M204 S250
G1 X160.54 Y143.49 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X158.96 Y143.49 E.04706
G1 X158.96 Y141.91 E.04706
G1 X160.54 Y141.91 E.04706
G1 X160.54 Y143.43 E.04528
; CHANGE_LAYER
; Z_HEIGHT: 3.6
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9547.055
M204 S8000
G1 X158.96 Y143.49 E-.60084
G1 X158.96 Y143.071 E-.15916
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 18/54
; update layer progress
M73 L18
M991 S0 P17 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 5
M204 S10000
G17
G3 Z3.8 I-1.184 J.28 P1  F60000
G1 X160.148 Y148.102 Z3.8
G1 Z3.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X160.148 Y148.898 E.02559
G1 X159.352 Y148.898 E.02559
G1 X159.352 Y148.102 E.02559
G1 X160.088 Y148.102 E.02366
; COOLING_NODE: 5
M204 S250
G1 X160.54 Y147.71 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X160.54 Y149.29 E.04706
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X158.96 Y149.29 E.04706
G1 X158.96 Y147.71 E.04706
G1 X160.48 Y147.71 E.04528
; COOLING_NODE: 6
; WIPE_START
M73 P93 R1
G1 F9547.055
M204 S8000
G1 X160.54 Y149.29 E-.60084
G1 X160.121 Y149.29 E-.15916
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X160.148 Y143.098 Z4 F60000
G1 Z3.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X159.352 Y143.098 E.02559
G1 X159.352 Y142.302 E.02559
G1 X160.148 Y142.302 E.02559
G1 X160.148 Y143.038 E.02366
; COOLING_NODE: 6
M204 S250
G1 X160.54 Y143.49 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X158.96 Y143.49 E.04706
G1 X158.96 Y141.91 E.04706
G1 X160.54 Y141.91 E.04706
G1 X160.54 Y143.43 E.04528
; CHANGE_LAYER
; Z_HEIGHT: 3.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9547.055
M204 S8000
G1 X158.96 Y143.49 E-.60084
G1 X158.96 Y143.071 E-.15916
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 19/54
; update layer progress
M73 L19
M991 S0 P18 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 5
M204 S10000
G17
G3 Z4 I-1.184 J.28 P1  F60000
G1 X160.148 Y148.102 Z4
G1 Z3.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X160.148 Y148.898 E.02559
G1 X159.352 Y148.898 E.02559
G1 X159.352 Y148.102 E.02559
G1 X160.088 Y148.102 E.02366
; COOLING_NODE: 5
M204 S250
G1 X160.54 Y147.71 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X160.54 Y149.29 E.04706
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X158.96 Y149.29 E.04706
G1 X158.96 Y147.71 E.04706
G1 X160.48 Y147.71 E.04528
; COOLING_NODE: 6
; WIPE_START
G1 F9547.055
M204 S8000
G1 X160.54 Y149.29 E-.60084
G1 X160.121 Y149.29 E-.15916
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X160.148 Y143.098 Z4.2 F60000
G1 Z3.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X159.352 Y143.098 E.02559
G1 X159.352 Y142.302 E.02559
G1 X160.148 Y142.302 E.02559
G1 X160.148 Y143.038 E.02366
; COOLING_NODE: 6
M204 S250
G1 X160.54 Y143.49 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X158.96 Y143.49 E.04706
G1 X158.96 Y141.91 E.04706
G1 X160.54 Y141.91 E.04706
G1 X160.54 Y143.43 E.04528
; CHANGE_LAYER
; Z_HEIGHT: 4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9547.055
M204 S8000
G1 X158.96 Y143.49 E-.60084
G1 X158.96 Y143.071 E-.15916
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 20/54
; update layer progress
M73 L20
M991 S0 P19 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 5
M204 S10000
G17
G3 Z4.2 I-1.184 J.28 P1  F60000
G1 X160.148 Y148.102 Z4.2
G1 Z4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X160.148 Y148.898 E.02559
G1 X159.352 Y148.898 E.02559
G1 X159.352 Y148.102 E.02559
G1 X160.088 Y148.102 E.02366
; COOLING_NODE: 5
M204 S250
G1 X160.54 Y147.71 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X160.54 Y149.29 E.04706
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X158.96 Y149.29 E.04706
G1 X158.96 Y147.71 E.04706
G1 X160.48 Y147.71 E.04528
; COOLING_NODE: 6
; WIPE_START
G1 F9547.055
M204 S8000
G1 X160.54 Y149.29 E-.60084
G1 X160.121 Y149.29 E-.15916
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X160.148 Y143.098 Z4.4 F60000
G1 Z4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X159.352 Y143.098 E.02559
G1 X159.352 Y142.302 E.02559
G1 X160.148 Y142.302 E.02559
G1 X160.148 Y143.038 E.02366
; COOLING_NODE: 6
M204 S250
G1 X160.54 Y143.49 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X158.96 Y143.49 E.04706
G1 X158.96 Y141.91 E.04706
G1 X160.54 Y141.91 E.04706
G1 X160.54 Y143.43 E.04528
; CHANGE_LAYER
; Z_HEIGHT: 4.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9547.055
M204 S8000
G1 X158.96 Y143.49 E-.60084
G1 X158.96 Y143.071 E-.15916
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 21/54
; update layer progress
M73 L21
M991 S0 P20 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 5
M204 S10000
G17
G3 Z4.4 I-1.184 J.28 P1  F60000
G1 X160.148 Y148.102 Z4.4
G1 Z4.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X160.148 Y148.898 E.02559
G1 X159.352 Y148.898 E.02559
G1 X159.352 Y148.102 E.02559
G1 X160.088 Y148.102 E.02366
; COOLING_NODE: 5
M204 S250
G1 X160.54 Y147.71 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X160.54 Y149.29 E.04706
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X158.96 Y149.29 E.04706
G1 X158.96 Y147.71 E.04706
G1 X160.48 Y147.71 E.04528
; COOLING_NODE: 6
; WIPE_START
G1 F9547.055
M204 S8000
G1 X160.54 Y149.29 E-.60084
G1 X160.121 Y149.29 E-.15916
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X160.148 Y143.098 Z4.6 F60000
G1 Z4.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X159.352 Y143.098 E.02559
G1 X159.352 Y142.302 E.02559
G1 X160.148 Y142.302 E.02559
G1 X160.148 Y143.038 E.02366
; COOLING_NODE: 6
M204 S250
G1 X160.54 Y143.49 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X158.96 Y143.49 E.04706
G1 X158.96 Y141.91 E.04706
G1 X160.54 Y141.91 E.04706
G1 X160.54 Y143.43 E.04528
; CHANGE_LAYER
; Z_HEIGHT: 4.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9547.055
M204 S8000
G1 X158.96 Y143.49 E-.60084
G1 X158.96 Y143.071 E-.15916
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 22/54
; update layer progress
M73 L22
M991 S0 P21 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 5
M204 S10000
G17
G3 Z4.6 I-1.184 J.28 P1  F60000
G1 X160.148 Y148.102 Z4.6
G1 Z4.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X160.148 Y148.898 E.02559
G1 X159.352 Y148.898 E.02559
G1 X159.352 Y148.102 E.02559
G1 X160.088 Y148.102 E.02366
; COOLING_NODE: 5
M204 S250
G1 X160.54 Y147.71 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X160.54 Y149.29 E.04706
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X158.96 Y149.29 E.04706
G1 X158.96 Y147.71 E.04706
G1 X160.48 Y147.71 E.04528
; COOLING_NODE: 6
; WIPE_START
G1 F9547.055
M204 S8000
G1 X160.54 Y149.29 E-.60084
G1 X160.121 Y149.29 E-.15916
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X160.148 Y143.098 Z4.8 F60000
G1 Z4.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X159.352 Y143.098 E.02559
G1 X159.352 Y142.302 E.02559
G1 X160.148 Y142.302 E.02559
G1 X160.148 Y143.038 E.02366
; COOLING_NODE: 6
M204 S250
G1 X160.54 Y143.49 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X158.96 Y143.49 E.04706
G1 X158.96 Y141.91 E.04706
G1 X160.54 Y141.91 E.04706
G1 X160.54 Y143.43 E.04528
; CHANGE_LAYER
; Z_HEIGHT: 4.6
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9547.055
M204 S8000
G1 X158.96 Y143.49 E-.60084
G1 X158.96 Y143.071 E-.15916
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 23/54
; update layer progress
M73 L23
M991 S0 P22 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 5
M204 S10000
G17
G3 Z4.8 I-1.184 J.28 P1  F60000
G1 X160.148 Y148.102 Z4.8
G1 Z4.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X160.148 Y148.898 E.02559
G1 X159.352 Y148.898 E.02559
G1 X159.352 Y148.102 E.02559
G1 X160.088 Y148.102 E.02366
; COOLING_NODE: 5
M204 S250
G1 X160.54 Y147.71 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X160.54 Y149.29 E.04706
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X158.96 Y149.29 E.04706
G1 X158.96 Y147.71 E.04706
G1 X160.48 Y147.71 E.04528
; COOLING_NODE: 6
; WIPE_START
G1 F9547.055
M204 S8000
G1 X160.54 Y149.29 E-.60084
G1 X160.121 Y149.29 E-.15916
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X160.148 Y143.098 Z5 F60000
G1 Z4.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X159.352 Y143.098 E.02559
G1 X159.352 Y142.302 E.02559
G1 X160.148 Y142.302 E.02559
G1 X160.148 Y143.038 E.02366
; COOLING_NODE: 6
M204 S250
M73 P93 R0
G1 X160.54 Y143.49 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X158.96 Y143.49 E.04706
G1 X158.96 Y141.91 E.04706
G1 X160.54 Y141.91 E.04706
G1 X160.54 Y143.43 E.04528
; CHANGE_LAYER
; Z_HEIGHT: 4.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9547.055
M204 S8000
G1 X158.96 Y143.49 E-.60084
G1 X158.96 Y143.071 E-.15916
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 24/54
; update layer progress
M73 L24
M991 S0 P23 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 5
M204 S10000
G17
G3 Z5 I-1.184 J.28 P1  F60000
G1 X160.148 Y148.102 Z5
G1 Z4.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X160.148 Y148.898 E.02559
G1 X159.352 Y148.898 E.02559
G1 X159.352 Y148.102 E.02559
G1 X160.088 Y148.102 E.02366
; COOLING_NODE: 5
M204 S250
G1 X160.54 Y147.71 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X160.54 Y149.29 E.04706
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X158.96 Y149.29 E.04706
G1 X158.96 Y147.71 E.04706
G1 X160.48 Y147.71 E.04528
; COOLING_NODE: 6
; WIPE_START
G1 F9547.055
M204 S8000
G1 X160.54 Y149.29 E-.60084
G1 X160.121 Y149.29 E-.15916
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X160.148 Y143.098 Z5.2 F60000
G1 Z4.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X159.352 Y143.098 E.02559
G1 X159.352 Y142.302 E.02559
G1 X160.148 Y142.302 E.02559
G1 X160.148 Y143.038 E.02366
; COOLING_NODE: 6
M204 S250
G1 X160.54 Y143.49 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X158.96 Y143.49 E.04706
G1 X158.96 Y141.91 E.04706
G1 X160.54 Y141.91 E.04706
G1 X160.54 Y143.43 E.04528
; CHANGE_LAYER
; Z_HEIGHT: 5
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9547.055
M204 S8000
G1 X158.96 Y143.49 E-.60084
G1 X158.96 Y143.071 E-.15916
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 25/54
; update layer progress
M73 L25
M991 S0 P24 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 5
M204 S10000
G17
G3 Z5.2 I-1.184 J.28 P1  F60000
G1 X160.148 Y148.102 Z5.2
G1 Z5
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
M73 P94 R0
G1 F1200
M204 S8000
G1 X160.148 Y148.898 E.02559
G1 X159.352 Y148.898 E.02559
G1 X159.352 Y148.102 E.02559
G1 X160.088 Y148.102 E.02366
; COOLING_NODE: 5
M204 S250
G1 X160.54 Y147.71 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X160.54 Y149.29 E.04706
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X158.96 Y149.29 E.04706
G1 X158.96 Y147.71 E.04706
G1 X160.48 Y147.71 E.04528
; COOLING_NODE: 6
; WIPE_START
G1 F9547.055
M204 S8000
G1 X160.54 Y149.29 E-.60084
G1 X160.121 Y149.29 E-.15916
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X160.148 Y143.098 Z5.4 F60000
G1 Z5
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X159.352 Y143.098 E.02559
G1 X159.352 Y142.302 E.02559
G1 X160.148 Y142.302 E.02559
G1 X160.148 Y143.038 E.02366
; COOLING_NODE: 6
M204 S250
G1 X160.54 Y143.49 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X158.96 Y143.49 E.04706
G1 X158.96 Y141.91 E.04706
G1 X160.54 Y141.91 E.04706
G1 X160.54 Y143.43 E.04528
; CHANGE_LAYER
; Z_HEIGHT: 5.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9547.055
M204 S8000
G1 X158.96 Y143.49 E-.60084
G1 X158.96 Y143.071 E-.15916
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 26/54
; update layer progress
M73 L26
M991 S0 P25 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 5
M204 S10000
G17
G3 Z5.4 I-1.184 J.28 P1  F60000
G1 X160.148 Y148.102 Z5.4
G1 Z5.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X160.148 Y148.898 E.02559
G1 X159.352 Y148.898 E.02559
G1 X159.352 Y148.102 E.02559
G1 X160.088 Y148.102 E.02366
; COOLING_NODE: 5
M204 S250
G1 X160.54 Y147.71 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X160.54 Y149.29 E.04706
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X158.96 Y149.29 E.04706
G1 X158.96 Y147.71 E.04706
G1 X160.48 Y147.71 E.04528
; COOLING_NODE: 6
; WIPE_START
G1 F9547.055
M204 S8000
G1 X160.54 Y149.29 E-.60084
G1 X160.121 Y149.29 E-.15916
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X160.148 Y143.098 Z5.6 F60000
G1 Z5.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X159.352 Y143.098 E.02559
G1 X159.352 Y142.302 E.02559
G1 X160.148 Y142.302 E.02559
G1 X160.148 Y143.038 E.02366
; COOLING_NODE: 6
M204 S250
G1 X160.54 Y143.49 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X158.96 Y143.49 E.04706
G1 X158.96 Y141.91 E.04706
G1 X160.54 Y141.91 E.04706
G1 X160.54 Y143.43 E.04528
; CHANGE_LAYER
; Z_HEIGHT: 5.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9547.055
M204 S8000
G1 X158.96 Y143.49 E-.60084
G1 X158.96 Y143.071 E-.15916
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 27/54
; update layer progress
M73 L27
M991 S0 P26 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 5
M204 S10000
G17
G3 Z5.6 I-1.184 J.28 P1  F60000
G1 X160.148 Y148.102 Z5.6
G1 Z5.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X160.148 Y148.898 E.02559
G1 X159.352 Y148.898 E.02559
G1 X159.352 Y148.102 E.02559
G1 X160.088 Y148.102 E.02366
; COOLING_NODE: 5
M204 S250
G1 X160.54 Y147.71 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X160.54 Y149.29 E.04706
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X158.96 Y149.29 E.04706
G1 X158.96 Y147.71 E.04706
G1 X160.48 Y147.71 E.04528
; COOLING_NODE: 6
; WIPE_START
G1 F9547.055
M204 S8000
G1 X160.54 Y149.29 E-.60084
G1 X160.121 Y149.29 E-.15916
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X160.148 Y143.098 Z5.8 F60000
G1 Z5.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X159.352 Y143.098 E.02559
G1 X159.352 Y142.302 E.02559
G1 X160.148 Y142.302 E.02559
G1 X160.148 Y143.038 E.02366
; COOLING_NODE: 6
M204 S250
G1 X160.54 Y143.49 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X158.96 Y143.49 E.04706
G1 X158.96 Y141.91 E.04706
G1 X160.54 Y141.91 E.04706
G1 X160.54 Y143.43 E.04528
; CHANGE_LAYER
; Z_HEIGHT: 5.6
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9547.055
M204 S8000
G1 X158.96 Y143.49 E-.60084
G1 X158.96 Y143.071 E-.15916
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 28/54
; update layer progress
M73 L28
M991 S0 P27 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 5
M204 S10000
G17
G3 Z5.8 I-1.184 J.28 P1  F60000
G1 X160.148 Y148.102 Z5.8
G1 Z5.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X160.148 Y148.898 E.02559
G1 X159.352 Y148.898 E.02559
G1 X159.352 Y148.102 E.02559
G1 X160.088 Y148.102 E.02366
; COOLING_NODE: 5
M204 S250
G1 X160.54 Y147.71 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X160.54 Y149.29 E.04706
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X158.96 Y149.29 E.04706
G1 X158.96 Y147.71 E.04706
G1 X160.48 Y147.71 E.04528
; COOLING_NODE: 6
; WIPE_START
G1 F9547.055
M204 S8000
G1 X160.54 Y149.29 E-.60084
G1 X160.121 Y149.29 E-.15916
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X160.148 Y143.098 Z6 F60000
G1 Z5.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X159.352 Y143.098 E.02559
G1 X159.352 Y142.302 E.02559
G1 X160.148 Y142.302 E.02559
G1 X160.148 Y143.038 E.02366
; COOLING_NODE: 6
M204 S250
G1 X160.54 Y143.49 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X158.96 Y143.49 E.04706
G1 X158.96 Y141.91 E.04706
G1 X160.54 Y141.91 E.04706
G1 X160.54 Y143.43 E.04528
; CHANGE_LAYER
; Z_HEIGHT: 5.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9547.055
M204 S8000
G1 X158.96 Y143.49 E-.60084
G1 X158.96 Y143.071 E-.15916
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 29/54
; update layer progress
M73 L29
M991 S0 P28 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 5
M204 S10000
G17
G3 Z6 I-1.184 J.28 P1  F60000
G1 X160.148 Y148.102 Z6
G1 Z5.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X160.148 Y148.898 E.02559
G1 X159.352 Y148.898 E.02559
G1 X159.352 Y148.102 E.02559
G1 X160.088 Y148.102 E.02366
; COOLING_NODE: 5
M204 S250
G1 X160.54 Y147.71 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X160.54 Y149.29 E.04706
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X158.96 Y149.29 E.04706
G1 X158.96 Y147.71 E.04706
G1 X160.48 Y147.71 E.04528
; COOLING_NODE: 6
; WIPE_START
G1 F9547.055
M204 S8000
G1 X160.54 Y149.29 E-.60084
G1 X160.121 Y149.29 E-.15916
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X160.148 Y143.098 Z6.2 F60000
G1 Z5.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X159.352 Y143.098 E.02559
G1 X159.352 Y142.302 E.02559
G1 X160.148 Y142.302 E.02559
G1 X160.148 Y143.038 E.02366
; COOLING_NODE: 6
M204 S250
G1 X160.54 Y143.49 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X158.96 Y143.49 E.04706
G1 X158.96 Y141.91 E.04706
G1 X160.54 Y141.91 E.04706
G1 X160.54 Y143.43 E.04528
; CHANGE_LAYER
; Z_HEIGHT: 6
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9547.055
M204 S8000
G1 X158.96 Y143.49 E-.60084
G1 X158.96 Y143.071 E-.15916
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 30/54
; update layer progress
M73 L30
M991 S0 P29 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 5
M204 S10000
G17
G3 Z6.2 I-1.184 J.28 P1  F60000
G1 X160.148 Y148.102 Z6.2
G1 Z6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X160.148 Y148.898 E.02559
G1 X159.352 Y148.898 E.02559
G1 X159.352 Y148.102 E.02559
G1 X160.088 Y148.102 E.02366
; COOLING_NODE: 5
M204 S250
G1 X160.54 Y147.71 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X160.54 Y149.29 E.04706
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X158.96 Y149.29 E.04706
G1 X158.96 Y147.71 E.04706
G1 X160.48 Y147.71 E.04528
; COOLING_NODE: 6
; WIPE_START
G1 F9547.055
M204 S8000
G1 X160.54 Y149.29 E-.60084
G1 X160.121 Y149.29 E-.15916
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X160.148 Y143.098 Z6.4 F60000
G1 Z6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X159.352 Y143.098 E.02559
G1 X159.352 Y142.302 E.02559
G1 X160.148 Y142.302 E.02559
G1 X160.148 Y143.038 E.02366
; COOLING_NODE: 6
M204 S250
G1 X160.54 Y143.49 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X158.96 Y143.49 E.04706
G1 X158.96 Y141.91 E.04706
G1 X160.54 Y141.91 E.04706
G1 X160.54 Y143.43 E.04528
; CHANGE_LAYER
; Z_HEIGHT: 6.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9547.055
M204 S8000
G1 X158.96 Y143.49 E-.60084
G1 X158.96 Y143.071 E-.15916
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 31/54
; update layer progress
M73 L31
M991 S0 P30 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 5
M204 S10000
G17
G3 Z6.4 I-1.184 J.28 P1  F60000
G1 X160.148 Y148.102 Z6.4
G1 Z6.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X160.148 Y148.898 E.02559
G1 X159.352 Y148.898 E.02559
G1 X159.352 Y148.102 E.02559
G1 X160.088 Y148.102 E.02366
; COOLING_NODE: 5
M204 S250
G1 X160.54 Y147.71 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X160.54 Y149.29 E.04706
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X158.96 Y149.29 E.04706
G1 X158.96 Y147.71 E.04706
G1 X160.48 Y147.71 E.04528
; COOLING_NODE: 6
; WIPE_START
G1 F9547.055
M204 S8000
G1 X160.54 Y149.29 E-.60084
G1 X160.121 Y149.29 E-.15916
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X160.148 Y143.098 Z6.6 F60000
G1 Z6.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X159.352 Y143.098 E.02559
G1 X159.352 Y142.302 E.02559
G1 X160.148 Y142.302 E.02559
G1 X160.148 Y143.038 E.02366
; COOLING_NODE: 6
M204 S250
G1 X160.54 Y143.49 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X158.96 Y143.49 E.04706
G1 X158.96 Y141.91 E.04706
G1 X160.54 Y141.91 E.04706
G1 X160.54 Y143.43 E.04528
; CHANGE_LAYER
; Z_HEIGHT: 6.4
; LAYER_HEIGHT: 0.2
; WIPE_START
M73 P95 R0
G1 F9547.055
M204 S8000
G1 X158.96 Y143.49 E-.60084
G1 X158.96 Y143.071 E-.15916
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 32/54
; update layer progress
M73 L32
M991 S0 P31 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 5
M204 S10000
G17
G3 Z6.6 I-1.184 J.28 P1  F60000
G1 X160.148 Y148.102 Z6.6
G1 Z6.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X160.148 Y148.898 E.02559
G1 X159.352 Y148.898 E.02559
G1 X159.352 Y148.102 E.02559
G1 X160.088 Y148.102 E.02366
; COOLING_NODE: 5
M204 S250
G1 X160.54 Y147.71 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X160.54 Y149.29 E.04706
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X158.96 Y149.29 E.04706
G1 X158.96 Y147.71 E.04706
G1 X160.48 Y147.71 E.04528
; COOLING_NODE: 6
; WIPE_START
G1 F9547.055
M204 S8000
G1 X160.54 Y149.29 E-.60084
G1 X160.121 Y149.29 E-.15916
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X160.148 Y143.098 Z6.8 F60000
G1 Z6.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X159.352 Y143.098 E.02559
G1 X159.352 Y142.302 E.02559
G1 X160.148 Y142.302 E.02559
G1 X160.148 Y143.038 E.02366
; COOLING_NODE: 6
M204 S250
G1 X160.54 Y143.49 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X158.96 Y143.49 E.04706
G1 X158.96 Y141.91 E.04706
G1 X160.54 Y141.91 E.04706
G1 X160.54 Y143.43 E.04528
; CHANGE_LAYER
; Z_HEIGHT: 6.6
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9547.055
M204 S8000
G1 X158.96 Y143.49 E-.60084
G1 X158.96 Y143.071 E-.15916
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 33/54
; update layer progress
M73 L33
M991 S0 P32 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 5
M204 S10000
G17
G3 Z6.8 I-1.184 J.28 P1  F60000
G1 X160.148 Y148.102 Z6.8
G1 Z6.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X160.148 Y148.898 E.02559
G1 X159.352 Y148.898 E.02559
G1 X159.352 Y148.102 E.02559
G1 X160.088 Y148.102 E.02366
; COOLING_NODE: 5
M204 S250
G1 X160.54 Y147.71 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X160.54 Y149.29 E.04706
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X158.96 Y149.29 E.04706
G1 X158.96 Y147.71 E.04706
G1 X160.48 Y147.71 E.04528
; COOLING_NODE: 6
; WIPE_START
G1 F9547.055
M204 S8000
G1 X160.54 Y149.29 E-.60084
G1 X160.121 Y149.29 E-.15916
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X160.148 Y143.098 Z7 F60000
G1 Z6.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X159.352 Y143.098 E.02559
G1 X159.352 Y142.302 E.02559
G1 X160.148 Y142.302 E.02559
G1 X160.148 Y143.038 E.02366
; COOLING_NODE: 6
M204 S250
G1 X160.54 Y143.49 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X158.96 Y143.49 E.04706
G1 X158.96 Y141.91 E.04706
G1 X160.54 Y141.91 E.04706
G1 X160.54 Y143.43 E.04528
; CHANGE_LAYER
; Z_HEIGHT: 6.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9547.055
M204 S8000
G1 X158.96 Y143.49 E-.60084
G1 X158.96 Y143.071 E-.15916
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 34/54
; update layer progress
M73 L34
M991 S0 P33 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 5
M204 S10000
G17
G3 Z7 I-1.184 J.28 P1  F60000
G1 X160.148 Y148.102 Z7
G1 Z6.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X160.148 Y148.898 E.02559
G1 X159.352 Y148.898 E.02559
G1 X159.352 Y148.102 E.02559
G1 X160.088 Y148.102 E.02366
; COOLING_NODE: 5
M204 S250
G1 X160.54 Y147.71 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X160.54 Y149.29 E.04706
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X158.96 Y149.29 E.04706
G1 X158.96 Y147.71 E.04706
G1 X160.48 Y147.71 E.04528
; COOLING_NODE: 6
; WIPE_START
G1 F9547.055
M204 S8000
G1 X160.54 Y149.29 E-.60084
G1 X160.121 Y149.29 E-.15916
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X160.148 Y143.098 Z7.2 F60000
G1 Z6.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X159.352 Y143.098 E.02559
G1 X159.352 Y142.302 E.02559
G1 X160.148 Y142.302 E.02559
G1 X160.148 Y143.038 E.02366
; COOLING_NODE: 6
M204 S250
G1 X160.54 Y143.49 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X158.96 Y143.49 E.04706
G1 X158.96 Y141.91 E.04706
G1 X160.54 Y141.91 E.04706
G1 X160.54 Y143.43 E.04528
; CHANGE_LAYER
; Z_HEIGHT: 7
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9547.055
M204 S8000
G1 X158.96 Y143.49 E-.60084
G1 X158.96 Y143.071 E-.15916
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 35/54
; update layer progress
M73 L35
M991 S0 P34 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 5
M204 S10000
G17
G3 Z7.2 I-1.184 J.28 P1  F60000
G1 X160.148 Y148.102 Z7.2
G1 Z7
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X160.148 Y148.898 E.02559
G1 X159.352 Y148.898 E.02559
G1 X159.352 Y148.102 E.02559
G1 X160.088 Y148.102 E.02366
; COOLING_NODE: 5
M204 S250
G1 X160.54 Y147.71 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X160.54 Y149.29 E.04706
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X158.96 Y149.29 E.04706
G1 X158.96 Y147.71 E.04706
G1 X160.48 Y147.71 E.04528
; COOLING_NODE: 6
; WIPE_START
G1 F9547.055
M204 S8000
G1 X160.54 Y149.29 E-.60084
G1 X160.121 Y149.29 E-.15916
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X160.148 Y143.098 Z7.4 F60000
G1 Z7
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X159.352 Y143.098 E.02559
G1 X159.352 Y142.302 E.02559
G1 X160.148 Y142.302 E.02559
G1 X160.148 Y143.038 E.02366
; COOLING_NODE: 6
M204 S250
G1 X160.54 Y143.49 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X158.96 Y143.49 E.04706
G1 X158.96 Y141.91 E.04706
G1 X160.54 Y141.91 E.04706
G1 X160.54 Y143.43 E.04528
; CHANGE_LAYER
; Z_HEIGHT: 7.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9547.055
M204 S8000
G1 X158.96 Y143.49 E-.60084
G1 X158.96 Y143.071 E-.15916
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 36/54
; update layer progress
M73 L36
M991 S0 P35 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 5
M204 S10000
G17
G3 Z7.4 I-1.184 J.28 P1  F60000
G1 X160.148 Y148.102 Z7.4
G1 Z7.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X160.148 Y148.898 E.02559
G1 X159.352 Y148.898 E.02559
G1 X159.352 Y148.102 E.02559
G1 X160.088 Y148.102 E.02366
; COOLING_NODE: 5
M204 S250
G1 X160.54 Y147.71 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X160.54 Y149.29 E.04706
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X158.96 Y149.29 E.04706
G1 X158.96 Y147.71 E.04706
G1 X160.48 Y147.71 E.04528
; COOLING_NODE: 6
; WIPE_START
G1 F9547.055
M204 S8000
G1 X160.54 Y149.29 E-.60084
G1 X160.121 Y149.29 E-.15916
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X160.148 Y143.098 Z7.6 F60000
G1 Z7.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X159.352 Y143.098 E.02559
G1 X159.352 Y142.302 E.02559
G1 X160.148 Y142.302 E.02559
G1 X160.148 Y143.038 E.02366
; COOLING_NODE: 6
M204 S250
G1 X160.54 Y143.49 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X158.96 Y143.49 E.04706
G1 X158.96 Y141.91 E.04706
G1 X160.54 Y141.91 E.04706
G1 X160.54 Y143.43 E.04528
; CHANGE_LAYER
; Z_HEIGHT: 7.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9547.055
M204 S8000
G1 X158.96 Y143.49 E-.60084
G1 X158.96 Y143.071 E-.15916
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 37/54
; update layer progress
M73 L37
M991 S0 P36 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 5
M204 S10000
G17
G3 Z7.6 I-1.184 J.28 P1  F60000
G1 X160.148 Y148.102 Z7.6
G1 Z7.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X160.148 Y148.898 E.02559
G1 X159.352 Y148.898 E.02559
G1 X159.352 Y148.102 E.02559
G1 X160.088 Y148.102 E.02366
; COOLING_NODE: 5
M204 S250
G1 X160.54 Y147.71 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X160.54 Y149.29 E.04706
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X158.96 Y149.29 E.04706
G1 X158.96 Y147.71 E.04706
G1 X160.48 Y147.71 E.04528
; COOLING_NODE: 6
; WIPE_START
G1 F9547.055
M204 S8000
G1 X160.54 Y149.29 E-.60084
G1 X160.121 Y149.29 E-.15916
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X160.148 Y143.098 Z7.8 F60000
G1 Z7.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X159.352 Y143.098 E.02559
G1 X159.352 Y142.302 E.02559
G1 X160.148 Y142.302 E.02559
G1 X160.148 Y143.038 E.02366
; COOLING_NODE: 6
M204 S250
G1 X160.54 Y143.49 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X158.96 Y143.49 E.04706
G1 X158.96 Y141.91 E.04706
G1 X160.54 Y141.91 E.04706
G1 X160.54 Y143.43 E.04528
; CHANGE_LAYER
; Z_HEIGHT: 7.6
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9547.055
M204 S8000
G1 X158.96 Y143.49 E-.60084
G1 X158.96 Y143.071 E-.15916
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 38/54
; update layer progress
M73 L38
M991 S0 P37 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 5
M204 S10000
G17
G3 Z7.8 I-1.184 J.28 P1  F60000
G1 X160.148 Y148.102 Z7.8
G1 Z7.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X160.148 Y148.898 E.02559
G1 X159.352 Y148.898 E.02559
G1 X159.352 Y148.102 E.02559
G1 X160.088 Y148.102 E.02366
; COOLING_NODE: 5
M204 S250
G1 X160.54 Y147.71 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X160.54 Y149.29 E.04706
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X158.96 Y149.29 E.04706
G1 X158.96 Y147.71 E.04706
G1 X160.48 Y147.71 E.04528
; COOLING_NODE: 6
; WIPE_START
G1 F9547.055
M204 S8000
G1 X160.54 Y149.29 E-.60084
G1 X160.121 Y149.29 E-.15916
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X160.148 Y143.098 Z8 F60000
G1 Z7.6
M73 P96 R0
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X159.352 Y143.098 E.02559
G1 X159.352 Y142.302 E.02559
G1 X160.148 Y142.302 E.02559
G1 X160.148 Y143.038 E.02366
; COOLING_NODE: 6
M204 S250
G1 X160.54 Y143.49 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X158.96 Y143.49 E.04706
G1 X158.96 Y141.91 E.04706
G1 X160.54 Y141.91 E.04706
G1 X160.54 Y143.43 E.04528
; CHANGE_LAYER
; Z_HEIGHT: 7.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9547.055
M204 S8000
G1 X158.96 Y143.49 E-.60084
G1 X158.96 Y143.071 E-.15916
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 39/54
; update layer progress
M73 L39
M991 S0 P38 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 5
M204 S10000
G17
G3 Z8 I-1.184 J.28 P1  F60000
G1 X160.148 Y148.102 Z8
G1 Z7.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X160.148 Y148.898 E.02559
G1 X159.352 Y148.898 E.02559
G1 X159.352 Y148.102 E.02559
G1 X160.088 Y148.102 E.02366
; COOLING_NODE: 5
M204 S250
G1 X160.54 Y147.71 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X160.54 Y149.29 E.04706
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X158.96 Y149.29 E.04706
G1 X158.96 Y147.71 E.04706
G1 X160.48 Y147.71 E.04528
; COOLING_NODE: 6
; WIPE_START
G1 F9547.055
M204 S8000
G1 X160.54 Y149.29 E-.60084
G1 X160.121 Y149.29 E-.15916
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X160.148 Y143.098 Z8.2 F60000
G1 Z7.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X159.352 Y143.098 E.02559
G1 X159.352 Y142.302 E.02559
G1 X160.148 Y142.302 E.02559
G1 X160.148 Y143.038 E.02366
; COOLING_NODE: 6
M204 S250
G1 X160.54 Y143.49 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X158.96 Y143.49 E.04706
G1 X158.96 Y141.91 E.04706
G1 X160.54 Y141.91 E.04706
G1 X160.54 Y143.43 E.04528
; CHANGE_LAYER
; Z_HEIGHT: 8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9547.055
M204 S8000
G1 X158.96 Y143.49 E-.60084
G1 X158.96 Y143.071 E-.15916
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 40/54
; update layer progress
M73 L40
M991 S0 P39 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 5
M204 S10000
G17
G3 Z8.2 I-1.184 J.28 P1  F60000
G1 X160.148 Y148.102 Z8.2
G1 Z8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X160.148 Y148.898 E.02559
G1 X159.352 Y148.898 E.02559
G1 X159.352 Y148.102 E.02559
G1 X160.088 Y148.102 E.02366
; COOLING_NODE: 5
M204 S250
G1 X160.54 Y147.71 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X160.54 Y149.29 E.04706
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X158.96 Y149.29 E.04706
G1 X158.96 Y147.71 E.04706
G1 X160.48 Y147.71 E.04528
; COOLING_NODE: 6
; WIPE_START
G1 F9547.055
M204 S8000
G1 X160.54 Y149.29 E-.60084
G1 X160.121 Y149.29 E-.15916
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X160.148 Y143.098 Z8.4 F60000
G1 Z8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X159.352 Y143.098 E.02559
G1 X159.352 Y142.302 E.02559
G1 X160.148 Y142.302 E.02559
G1 X160.148 Y143.038 E.02366
; COOLING_NODE: 6
M204 S250
G1 X160.54 Y143.49 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X158.96 Y143.49 E.04706
G1 X158.96 Y141.91 E.04706
G1 X160.54 Y141.91 E.04706
G1 X160.54 Y143.43 E.04528
; CHANGE_LAYER
; Z_HEIGHT: 8.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9547.055
M204 S8000
G1 X158.96 Y143.49 E-.60084
G1 X158.96 Y143.071 E-.15916
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 41/54
; update layer progress
M73 L41
M991 S0 P40 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 5
M204 S10000
G17
G3 Z8.4 I-1.184 J.28 P1  F60000
G1 X160.148 Y148.102 Z8.4
G1 Z8.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X160.148 Y148.898 E.02559
G1 X159.352 Y148.898 E.02559
G1 X159.352 Y148.102 E.02559
G1 X160.088 Y148.102 E.02366
; COOLING_NODE: 5
M204 S250
G1 X160.54 Y147.71 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X160.54 Y149.29 E.04706
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X158.96 Y149.29 E.04706
G1 X158.96 Y147.71 E.04706
G1 X160.48 Y147.71 E.04528
; COOLING_NODE: 6
; WIPE_START
G1 F9547.055
M204 S8000
G1 X160.54 Y149.29 E-.60084
G1 X160.121 Y149.29 E-.15916
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X160.148 Y143.098 Z8.6 F60000
G1 Z8.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X159.352 Y143.098 E.02559
G1 X159.352 Y142.302 E.02559
G1 X160.148 Y142.302 E.02559
G1 X160.148 Y143.038 E.02366
; COOLING_NODE: 6
M204 S250
G1 X160.54 Y143.49 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X158.96 Y143.49 E.04706
G1 X158.96 Y141.91 E.04706
G1 X160.54 Y141.91 E.04706
G1 X160.54 Y143.43 E.04528
; CHANGE_LAYER
; Z_HEIGHT: 8.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9547.055
M204 S8000
G1 X158.96 Y143.49 E-.60084
G1 X158.96 Y143.071 E-.15916
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 42/54
; update layer progress
M73 L42
M991 S0 P41 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 5
M204 S10000
G17
G3 Z8.6 I-1.184 J.28 P1  F60000
G1 X160.148 Y148.102 Z8.6
G1 Z8.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X160.148 Y148.898 E.02559
G1 X159.352 Y148.898 E.02559
G1 X159.352 Y148.102 E.02559
G1 X160.088 Y148.102 E.02366
; COOLING_NODE: 5
M204 S250
G1 X160.54 Y147.71 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X160.54 Y149.29 E.04706
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X158.96 Y149.29 E.04706
G1 X158.96 Y147.71 E.04706
G1 X160.48 Y147.71 E.04528
; COOLING_NODE: 6
; WIPE_START
G1 F9547.055
M204 S8000
G1 X160.54 Y149.29 E-.60084
G1 X160.121 Y149.29 E-.15916
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X160.148 Y143.098 Z8.8 F60000
G1 Z8.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X159.352 Y143.098 E.02559
G1 X159.352 Y142.302 E.02559
G1 X160.148 Y142.302 E.02559
G1 X160.148 Y143.038 E.02366
; COOLING_NODE: 6
M204 S250
G1 X160.54 Y143.49 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X158.96 Y143.49 E.04706
G1 X158.96 Y141.91 E.04706
G1 X160.54 Y141.91 E.04706
G1 X160.54 Y143.43 E.04528
; CHANGE_LAYER
; Z_HEIGHT: 8.6
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F9547.055
M204 S8000
G1 X158.96 Y143.49 E-.60084
G1 X158.96 Y143.071 E-.15916
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 43/54
; update layer progress
M73 L43
M991 S0 P42 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 5
M204 S10000
G17
G3 Z8.8 I-1.184 J.28 P1  F60000
G1 X160.148 Y148.102 Z8.8
G1 Z8.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X160.148 Y148.898 E.02559
G1 X159.352 Y148.898 E.02559
G1 X159.352 Y148.102 E.02559
G1 X160.088 Y148.102 E.02366
; COOLING_NODE: 5
M204 S250
G1 X160.54 Y147.71 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X160.54 Y149.29 E.04706
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X158.96 Y149.29 E.04706
G1 X158.96 Y147.71 E.04706
G1 X160.48 Y147.71 E.04528
; COOLING_NODE: 6
; WIPE_START
G1 F9547.055
M204 S8000
G1 X160.54 Y149.29 E-.60084
G1 X160.121 Y149.29 E-.15916
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X160.148 Y143.098 Z9 F60000
G1 Z8.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X159.352 Y143.098 E.02559
G1 X159.352 Y142.302 E.02559
G1 X160.148 Y142.302 E.02559
G1 X160.148 Y143.038 E.02366
; COOLING_NODE: 6
M204 S250
G1 X160.54 Y143.49 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X158.96 Y143.49 E.04706
G1 X158.96 Y141.91 E.04706
G1 X160.54 Y141.91 E.04706
G1 X160.54 Y143.43 E.04528
; CHANGE_LAYER
; Z_HEIGHT: 8.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9547.055
M204 S8000
G1 X158.96 Y143.49 E-.60084
G1 X158.96 Y143.071 E-.15916
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 44/54
; update layer progress
M73 L44
M991 S0 P43 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 5
M204 S10000
G17
G3 Z9 I-1.184 J.28 P1  F60000
G1 X160.148 Y148.102 Z9
G1 Z8.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X160.148 Y148.898 E.02559
G1 X159.352 Y148.898 E.02559
G1 X159.352 Y148.102 E.02559
G1 X160.088 Y148.102 E.02366
; COOLING_NODE: 5
M204 S250
G1 X160.54 Y147.71 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X160.54 Y149.29 E.04706
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X158.96 Y149.29 E.04706
G1 X158.96 Y147.71 E.04706
G1 X160.48 Y147.71 E.04528
; COOLING_NODE: 6
; WIPE_START
G1 F9547.055
M204 S8000
G1 X160.54 Y149.29 E-.60084
G1 X160.121 Y149.29 E-.15916
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X160.148 Y143.098 Z9.2 F60000
G1 Z8.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X159.352 Y143.098 E.02559
G1 X159.352 Y142.302 E.02559
G1 X160.148 Y142.302 E.02559
G1 X160.148 Y143.038 E.02366
; COOLING_NODE: 6
M204 S250
G1 X160.54 Y143.49 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X158.96 Y143.49 E.04706
G1 X158.96 Y141.91 E.04706
G1 X160.54 Y141.91 E.04706
G1 X160.54 Y143.43 E.04528
; CHANGE_LAYER
; Z_HEIGHT: 9
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9547.055
M204 S8000
G1 X158.96 Y143.49 E-.60084
G1 X158.96 Y143.071 E-.15916
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 45/54
; update layer progress
M73 L45
M991 S0 P44 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 5
M204 S10000
G17
G3 Z9.2 I-1.184 J.28 P1  F60000
G1 X160.148 Y148.102 Z9.2
G1 Z9
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X160.148 Y148.898 E.02559
G1 X159.352 Y148.898 E.02559
G1 X159.352 Y148.102 E.02559
G1 X160.088 Y148.102 E.02366
; COOLING_NODE: 5
M204 S250
G1 X160.54 Y147.71 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X160.54 Y149.29 E.04706
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X158.96 Y149.29 E.04706
M73 P97 R0
G1 X158.96 Y147.71 E.04706
G1 X160.48 Y147.71 E.04528
; COOLING_NODE: 6
; WIPE_START
G1 F9547.055
M204 S8000
G1 X160.54 Y149.29 E-.60084
G1 X160.121 Y149.29 E-.15916
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X160.148 Y143.098 Z9.4 F60000
G1 Z9
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X159.352 Y143.098 E.02559
G1 X159.352 Y142.302 E.02559
G1 X160.148 Y142.302 E.02559
G1 X160.148 Y143.038 E.02366
; COOLING_NODE: 6
M204 S250
G1 X160.54 Y143.49 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X158.96 Y143.49 E.04706
G1 X158.96 Y141.91 E.04706
G1 X160.54 Y141.91 E.04706
G1 X160.54 Y143.43 E.04528
; CHANGE_LAYER
; Z_HEIGHT: 9.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9547.055
M204 S8000
G1 X158.96 Y143.49 E-.60084
G1 X158.96 Y143.071 E-.15916
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 46/54
; update layer progress
M73 L46
M991 S0 P45 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 5
M204 S10000
G17
G3 Z9.4 I-1.184 J.28 P1  F60000
G1 X160.148 Y148.102 Z9.4
G1 Z9.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X160.148 Y148.898 E.02559
G1 X159.352 Y148.898 E.02559
G1 X159.352 Y148.102 E.02559
G1 X160.088 Y148.102 E.02366
; COOLING_NODE: 5
M204 S250
G1 X160.54 Y147.71 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X160.54 Y149.29 E.04706
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X158.96 Y149.29 E.04706
G1 X158.96 Y147.71 E.04706
G1 X160.48 Y147.71 E.04528
; COOLING_NODE: 6
; WIPE_START
G1 F9547.055
M204 S8000
G1 X160.54 Y149.29 E-.60084
G1 X160.121 Y149.29 E-.15916
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X160.148 Y143.098 Z9.6 F60000
G1 Z9.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X159.352 Y143.098 E.02559
G1 X159.352 Y142.302 E.02559
G1 X160.148 Y142.302 E.02559
G1 X160.148 Y143.038 E.02366
; COOLING_NODE: 6
M204 S250
G1 X160.54 Y143.49 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X158.96 Y143.49 E.04706
G1 X158.96 Y141.91 E.04706
G1 X160.54 Y141.91 E.04706
G1 X160.54 Y143.43 E.04528
; CHANGE_LAYER
; Z_HEIGHT: 9.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9547.055
M204 S8000
G1 X158.96 Y143.49 E-.60084
G1 X158.96 Y143.071 E-.15916
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 47/54
; update layer progress
M73 L47
M991 S0 P46 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 5
M204 S10000
G17
G3 Z9.6 I-1.184 J.28 P1  F60000
G1 X160.148 Y148.102 Z9.6
G1 Z9.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X160.148 Y148.898 E.02559
G1 X159.352 Y148.898 E.02559
G1 X159.352 Y148.102 E.02559
G1 X160.088 Y148.102 E.02366
; COOLING_NODE: 5
M204 S250
G1 X160.54 Y147.71 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X160.54 Y149.29 E.04706
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X158.96 Y149.29 E.04706
G1 X158.96 Y147.71 E.04706
G1 X160.48 Y147.71 E.04528
; COOLING_NODE: 6
; WIPE_START
G1 F9547.055
M204 S8000
G1 X160.54 Y149.29 E-.60084
G1 X160.121 Y149.29 E-.15916
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X160.148 Y143.098 Z9.8 F60000
G1 Z9.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X159.352 Y143.098 E.02559
G1 X159.352 Y142.302 E.02559
G1 X160.148 Y142.302 E.02559
G1 X160.148 Y143.038 E.02366
; COOLING_NODE: 6
M204 S250
G1 X160.54 Y143.49 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X158.96 Y143.49 E.04706
G1 X158.96 Y141.91 E.04706
G1 X160.54 Y141.91 E.04706
G1 X160.54 Y143.43 E.04528
; CHANGE_LAYER
; Z_HEIGHT: 9.6
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F9547.055
M204 S8000
G1 X158.96 Y143.49 E-.60084
G1 X158.96 Y143.071 E-.15916
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 48/54
; update layer progress
M73 L48
M991 S0 P47 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 5
M204 S10000
G17
G3 Z9.8 I-1.184 J.28 P1  F60000
G1 X160.148 Y148.102 Z9.8
G1 Z9.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X160.148 Y148.898 E.02559
G1 X159.352 Y148.898 E.02559
G1 X159.352 Y148.102 E.02559
G1 X160.088 Y148.102 E.02366
; COOLING_NODE: 5
M204 S250
G1 X160.54 Y147.71 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X160.54 Y149.29 E.04706
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X158.96 Y149.29 E.04706
G1 X158.96 Y147.71 E.04706
G1 X160.48 Y147.71 E.04528
; COOLING_NODE: 6
; WIPE_START
G1 F9547.055
M204 S8000
G1 X160.54 Y149.29 E-.60084
G1 X160.121 Y149.29 E-.15916
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X160.148 Y143.098 Z10 F60000
G1 Z9.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X159.352 Y143.098 E.02559
G1 X159.352 Y142.302 E.02559
G1 X160.148 Y142.302 E.02559
G1 X160.148 Y143.038 E.02366
; COOLING_NODE: 6
M204 S250
G1 X160.54 Y143.49 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X158.96 Y143.49 E.04706
G1 X158.96 Y141.91 E.04706
G1 X160.54 Y141.91 E.04706
G1 X160.54 Y143.43 E.04528
; CHANGE_LAYER
; Z_HEIGHT: 9.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9547.055
M204 S8000
G1 X158.96 Y143.49 E-.60084
G1 X158.96 Y143.071 E-.15916
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 49/54
; update layer progress
M73 L49
M991 S0 P48 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 5
M204 S10000
G17
G3 Z10 I-1.184 J.28 P1  F60000
G1 X160.148 Y148.102 Z10
G1 Z9.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X160.148 Y148.898 E.02559
G1 X159.352 Y148.898 E.02559
G1 X159.352 Y148.102 E.02559
G1 X160.088 Y148.102 E.02366
; COOLING_NODE: 5
M204 S250
G1 X160.54 Y147.71 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X160.54 Y149.29 E.04706
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X158.96 Y149.29 E.04706
G1 X158.96 Y147.71 E.04706
G1 X160.48 Y147.71 E.04528
; COOLING_NODE: 6
; WIPE_START
G1 F9547.055
M204 S8000
G1 X160.54 Y149.29 E-.60084
G1 X160.121 Y149.29 E-.15916
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X160.148 Y143.098 Z10.2 F60000
G1 Z9.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X159.352 Y143.098 E.02559
G1 X159.352 Y142.302 E.02559
G1 X160.148 Y142.302 E.02559
G1 X160.148 Y143.038 E.02366
; COOLING_NODE: 6
M204 S250
G1 X160.54 Y143.49 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X158.96 Y143.49 E.04706
G1 X158.96 Y141.91 E.04706
G1 X160.54 Y141.91 E.04706
G1 X160.54 Y143.43 E.04528
; CHANGE_LAYER
; Z_HEIGHT: 10
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9547.055
M204 S8000
G1 X158.96 Y143.49 E-.60084
G1 X158.96 Y143.071 E-.15916
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 50/54
; update layer progress
M73 L50
M991 S0 P49 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 5
M204 S10000
G17
G3 Z10.2 I-1.184 J.28 P1  F60000
G1 X160.148 Y148.102 Z10.2
G1 Z10
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X160.148 Y148.898 E.02559
G1 X159.352 Y148.898 E.02559
G1 X159.352 Y148.102 E.02559
G1 X160.088 Y148.102 E.02366
; COOLING_NODE: 5
M204 S250
G1 X160.54 Y147.71 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X160.54 Y149.29 E.04706
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X158.96 Y149.29 E.04706
G1 X158.96 Y147.71 E.04706
G1 X160.48 Y147.71 E.04528
; COOLING_NODE: 6
; WIPE_START
G1 F9547.055
M204 S8000
G1 X160.54 Y149.29 E-.60084
G1 X160.121 Y149.29 E-.15916
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X160.148 Y143.098 Z10.4 F60000
G1 Z10
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X159.352 Y143.098 E.02559
G1 X159.352 Y142.302 E.02559
G1 X160.148 Y142.302 E.02559
G1 X160.148 Y143.038 E.02366
; COOLING_NODE: 6
M204 S250
G1 X160.54 Y143.49 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X158.96 Y143.49 E.04706
G1 X158.96 Y141.91 E.04706
G1 X160.54 Y141.91 E.04706
G1 X160.54 Y143.43 E.04528
; CHANGE_LAYER
; Z_HEIGHT: 10.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9547.055
M204 S8000
G1 X158.96 Y143.49 E-.60084
G1 X158.96 Y143.071 E-.15916
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 51/54
; update layer progress
M73 L51
M991 S0 P50 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 5
M204 S10000
G17
G3 Z10.4 I-1.184 J.28 P1  F60000
G1 X160.148 Y148.102 Z10.4
G1 Z10.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X160.148 Y148.898 E.02559
G1 X159.352 Y148.898 E.02559
G1 X159.352 Y148.102 E.02559
G1 X160.088 Y148.102 E.02366
; COOLING_NODE: 5
M204 S250
G1 X160.54 Y147.71 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X160.54 Y149.29 E.04706
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X158.96 Y149.29 E.04706
G1 X158.96 Y147.71 E.04706
G1 X160.48 Y147.71 E.04528
; COOLING_NODE: 6
; WIPE_START
G1 F9547.055
M204 S8000
G1 X160.54 Y149.29 E-.60084
G1 X160.121 Y149.29 E-.15916
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X160.148 Y143.098 Z10.6 F60000
M73 P98 R0
G1 Z10.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X159.352 Y143.098 E.02559
G1 X159.352 Y142.302 E.02559
G1 X160.148 Y142.302 E.02559
G1 X160.148 Y143.038 E.02366
; COOLING_NODE: 6
M204 S250
G1 X160.54 Y143.49 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X158.96 Y143.49 E.04706
G1 X158.96 Y141.91 E.04706
G1 X160.54 Y141.91 E.04706
G1 X160.54 Y143.43 E.04528
; CHANGE_LAYER
; Z_HEIGHT: 10.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9547.055
M204 S8000
G1 X158.96 Y143.49 E-.60084
G1 X158.96 Y143.071 E-.15916
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 52/54
; update layer progress
M73 L52
M991 S0 P51 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 5
M204 S10000
G17
G3 Z10.6 I-1.184 J.28 P1  F60000
G1 X160.148 Y148.102 Z10.6
G1 Z10.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X160.148 Y148.898 E.02559
G1 X159.352 Y148.898 E.02559
G1 X159.352 Y148.102 E.02559
G1 X160.088 Y148.102 E.02366
; COOLING_NODE: 5
M204 S250
G1 X160.54 Y147.71 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X160.54 Y149.29 E.04706
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X158.96 Y149.29 E.04706
G1 X158.96 Y147.71 E.04706
G1 X160.48 Y147.71 E.04528
; COOLING_NODE: 6
; WIPE_START
G1 F9547.055
M204 S8000
G1 X160.54 Y149.29 E-.60084
G1 X160.121 Y149.29 E-.15916
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X160.148 Y143.098 Z10.8 F60000
G1 Z10.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X159.352 Y143.098 E.02559
G1 X159.352 Y142.302 E.02559
G1 X160.148 Y142.302 E.02559
G1 X160.148 Y143.038 E.02366
; COOLING_NODE: 6
M204 S250
G1 X160.54 Y143.49 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X158.96 Y143.49 E.04706
G1 X158.96 Y141.91 E.04706
G1 X160.54 Y141.91 E.04706
G1 X160.54 Y143.43 E.04528
; CHANGE_LAYER
; Z_HEIGHT: 10.6
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F9547.055
M204 S8000
G1 X158.96 Y143.49 E-.60084
G1 X158.96 Y143.071 E-.15916
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 53/54
; update layer progress
M73 L53
M991 S0 P52 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 5
M204 S10000
G17
G3 Z10.8 I-1.184 J.28 P1  F60000
G1 X160.148 Y148.102 Z10.8
G1 Z10.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X160.148 Y148.898 E.02559
G1 X159.352 Y148.898 E.02559
G1 X159.352 Y148.102 E.02559
G1 X160.088 Y148.102 E.02366
; COOLING_NODE: 5
M204 S250
G1 X160.54 Y147.71 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X160.54 Y149.29 E.04706
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X158.96 Y149.29 E.04706
G1 X158.96 Y147.71 E.04706
G1 X160.48 Y147.71 E.04528
; COOLING_NODE: 6
; WIPE_START
G1 F9547.055
M204 S8000
G1 X160.54 Y149.29 E-.60084
G1 X160.121 Y149.29 E-.15916
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X160.148 Y143.098 Z11 F60000
G1 Z10.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X159.352 Y143.098 E.02559
G1 X159.352 Y142.302 E.02559
G1 X160.148 Y142.302 E.02559
G1 X160.148 Y143.038 E.02366
; COOLING_NODE: 6
M204 S250
G1 X160.54 Y143.49 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X158.96 Y143.49 E.04706
G1 X158.96 Y141.91 E.04706
G1 X160.54 Y141.91 E.04706
G1 X160.54 Y143.43 E.04528
; CHANGE_LAYER
; Z_HEIGHT: 10.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9547.055
M204 S8000
G1 X158.96 Y143.49 E-.60084
G1 X158.96 Y143.071 E-.15916
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 54/54
; update layer progress
M73 L54
M991 S0 P53 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 5
M204 S10000
G17
G3 Z11 I-1.152 J.392 P1  F60000
G1 X160.54 Y147.71 Z11
G1 Z10.8
G1 E.8 F1800
G1 F1200
M204 S5000
G1 X160.54 Y149.29 E.04706
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X158.96 Y149.29 E.04706
G1 X158.96 Y147.71 E.04706
G1 X160.48 Y147.71 E.04528
; WIPE_START
G1 F9547.055
M204 S8000
G1 X160.54 Y149.29 E-.60084
G1 X160.121 Y149.29 E-.15916
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X159.521 Y149.083 Z11.2 F60000
G1 Z10.8
G1 E.8 F1800
; FEATURE: Top surface
G1 F1200
M204 S2000
G1 X160.333 Y148.271 E.03419
G1 X160.466 Y148.137
G1 X160.287 Y147.784
G1 X160.153 Y147.917
G1 X159.167 Y148.903 E.04152
G1 X159.034 Y149.037
G1 X159.034 Y148.503
G1 X159.167 Y148.37
G1 X159.62 Y147.917 E.01906
; COOLING_NODE: 6
; WIPE_START
G1 F9547.055
M204 S8000
G1 X159.167 Y148.37 E-.24313
G1 X159.034 Y148.503 E-.07182
G1 X159.034 Y149.037 E-.20264
G1 X159.167 Y148.903 E-.07182
G1 X159.485 Y148.586 E-.1706
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X160.54 Y143.49 Z11.2 F60000
G1 Z10.8
G1 E.8 F1800
; FEATURE: Outer wall
G1 F1200
M204 S5000
G1 X158.96 Y143.49 E.04706
G1 X158.96 Y141.91 E.04706
G1 X160.54 Y141.91 E.04706
G1 X160.54 Y143.43 E.04528
M204 S10000
G1 X160.333 Y142.938 F60000
; FEATURE: Top surface
G1 F1200
M204 S2000
G1 X159.988 Y143.283 E.0145
G1 X159.855 Y143.416
G1 X159.322 Y143.416
G1 X159.455 Y143.283
G1 X160.333 Y142.405 E.03696
G1 X160.466 Y142.272
G1 X160.221 Y141.984
G1 X160.087 Y142.117
G1 X159.167 Y143.037 E.03875
G1 X159.034 Y143.171
G1 X159.034 Y142.638
G1 X159.167 Y142.504
G1 X159.554 Y142.117 E.01628
; close powerlost recovery
M1003 S0
; WIPE_START
G1 F9547.055
M204 S8000
G1 X159.167 Y142.504 E-.20775
M73 P99 R0
G1 X159.034 Y142.638 E-.07182
G1 X159.034 Y143.171 E-.20264
G1 X159.167 Y143.037 E-.07182
G1 X159.551 Y142.654 E-.20597
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z11.2 I1.217 J0 P1  F60000
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
G1 Z11.2 F900 ; lower z a little
M1002 judge_flag timelapse_record_flag
M622 J1
    G150.3
    M400 ; wait all motion done
    M991 S0 P-1 ;end smooth timelapse at safe pos
    M400 S5 ;wait for last picture to be taken
M623  ;end of "timelapse_record_flag"

G90
G1 Z20.8 F900 ; lower z a little

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

    
        G1 Z105.4 F600
        G1 Z103.4
    

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

