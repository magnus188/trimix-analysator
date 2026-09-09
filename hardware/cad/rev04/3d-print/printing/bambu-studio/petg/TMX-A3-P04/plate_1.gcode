; HEADER_BLOCK_START
; BambuStudio 02.08.02.61
; model printing time: 2m 45s; total estimated time: 8m 12s
; total layer number: 32
; total filament length [mm] : 94.40
; total filament volume [cm^3] : 227.06
; total filament weight [g] : 0.29
; filament_density: 1.27
; filament_diameter: 1.75
; max_z_height: 6.40
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
M73 P0 R8
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
M73 P5 R7
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
M73 P9 R7
G1 Z5 F1200
G90
M73 P10 R7
G1 X175 Y160 F30000

M622 J1
    M1002 gcode_claim_action : 1
    G29.20 A3
    G29 A1 O X167.693 Y151.043 I14.6131 J17.9131 R
    M400
M623

M622 J2
    M1002 gcode_claim_action : 1
    
        G29.20 A4
        G29 A2 O X167.693 Y151.043 I14.6131 J17.9131 R
    
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
M73 P62 R3
G1 Z5 F1200
G1 X270 Y-0.5 F60000
G28.140 S0 ; cali pre-extrude z pos

M141 S0
M104 S255 A

;===== mech mode sweep start =====
    M1002 gcode_claim_action : 3

    G90
    G1 Z5 F1200
M73 P63 R3
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
M73 P63 R2
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
; layer num/total_layer_count: 1/32
; update layer progress
M73 L1
M991 S0 P0 ;notify layer change

M106 S0
M106 P2 S0
; OBJECT_ID: 15
M73 P64 R2
G1 X168.872 Y152.424 F60000
M204 S6000
M73 P66 R2
G1 Z.4
G1 Z.2
G1 E.8 F1800
; FEATURE: Brim
; LINE_WIDTH: 0.5
G1 F2761
M204 S500
G1 X169.288 Y152.04 E.02045
G1 X169.763 Y151.728 E.02053
G1 X170.144 Y151.55 E.01517
G1 X170.788 Y151.348 E.02439
G1 X171.512 Y151.272 E.02627
G1 X178.491 Y151.272 E.25197
G1 X179.06 Y151.319 E.02062
G1 X179.971 Y151.602 E.03446
G1 X180.478 Y151.875 E.02079
G1 X180.926 Y152.222 E.02045
G1 X181.31 Y152.638 E.02045
G1 X181.622 Y153.112 E.02048
G1 X181.839 Y153.593 E.01907
G1 X182.002 Y154.137 E.0205
G1 X182.078 Y154.862 E.02632
G1 X182.078 Y163.441 E.30974
G1 X182.031 Y164.01 E.02062
G1 X181.789 Y164.826 E.03075
G1 X181.589 Y165.217 E.01586
G1 X181.565 Y165.303 E.00319
G1 X181.531 Y165.71 E.01475
G1 X181.248 Y166.621 E.03446
G1 X180.975 Y167.128 E.02079
G1 X180.628 Y167.576 E.02045
G1 X180.212 Y167.96 E.02045
G1 X179.737 Y168.272 E.02053
G1 X179.356 Y168.45 E.01517
G1 X178.712 Y168.652 E.02439
G1 X177.988 Y168.728 E.02627
G1 X172.009 Y168.728 E.21586
G1 X171.44 Y168.681 E.02062
G1 X170.529 Y168.398 E.03446
G1 X170.022 Y168.125 E.02079
G1 X169.574 Y167.778 E.02045
G1 X169.19 Y167.362 E.02045
G1 X168.878 Y166.888 E.02048
G1 X168.661 Y166.407 E.01907
G1 X168.498 Y165.863 E.0205
G1 X168.422 Y165.258 E.02202
G1 X168.161 Y164.705 E.02208
G1 X167.998 Y164.163 E.02042
G1 X167.922 Y163.438 E.02632
G1 X167.922 Y154.859 E.30974
G1 X167.969 Y154.29 E.02062
G1 X168.252 Y153.379 E.03446
G1 X168.525 Y152.872 E.02079
G1 X168.835 Y152.471 E.01828
M204 S6000
G1 X169.196 Y152.751 F60000
G1 F2761
M204 S500
G1 X169.203 Y152.743 E.00039
G1 X169.562 Y152.409 E.0177
G1 X169.978 Y152.133 E.01802
G1 X170.301 Y151.981 E.01291
G1 X170.895 Y151.796 E.02246
G1 X171.543 Y151.729 E.02351
G1 X178.477 Y151.73 E.25037
G1 X178.986 Y151.775 E.01845
G1 X179.781 Y152.021 E.03004
G1 X180.218 Y152.254 E.01788
G1 X180.607 Y152.553 E.01771
G1 X180.941 Y152.912 E.0177
G1 X181.214 Y153.324 E.01784
G1 X181.412 Y153.762 E.01739
G1 X181.553 Y154.24 E.01798
G1 X181.621 Y154.893 E.0237
G1 X181.62 Y163.427 E.30814
G1 X181.575 Y163.939 E.01853
G1 X181.366 Y164.644 E.02656
G1 X181.148 Y165.1 E.01827
G1 X181.108 Y165.274 E.00645
G1 X181.075 Y165.636 E.01313
G1 X180.818 Y166.455 E.03099
G1 X180.584 Y166.887 E.01774
G1 X180.297 Y167.257 E.0169
G1 X179.938 Y167.591 E.0177
G1 X179.522 Y167.867 E.01802
G1 X179.199 Y168.019 E.01291
G1 X178.605 Y168.204 E.02246
G1 X177.957 Y168.271 E.02351
G1 X172.034 Y168.271 E.21385
G1 X171.514 Y168.225 E.01887
G1 X170.695 Y167.968 E.03099
G1 X170.263 Y167.734 E.01774
G1 X169.876 Y167.432 E.01771
G1 X169.545 Y167.071 E.0177
G1 X169.286 Y166.676 E.01702
G1 X169.094 Y166.255 E.01673
G1 X168.95 Y165.779 E.01794
G1 X168.877 Y165.212 E.02066
G1 X168.83 Y165.053 E.00596
G1 X168.593 Y164.55 E.02008
G1 X168.447 Y164.06 E.01847
G1 X168.379 Y163.407 E.0237
G1 X168.379 Y154.884 E.30774
G1 X168.425 Y154.364 E.01886
G1 X168.682 Y153.545 E.03099
G1 X168.916 Y153.113 E.01774
G1 X169.159 Y152.799 E.01434
M204 S6000
G1 X169.522 Y153.077 F60000
G1 F2761
M204 S500
G1 X169.535 Y153.061 E.00074
G1 X169.855 Y152.763 E.0158
G1 X170.194 Y152.538 E.01469
G1 X170.459 Y152.412 E.01059
G1 X171.001 Y152.245 E.02049
G1 X171.574 Y152.186 E.02077
G1 X178.451 Y152.187 E.24831
G1 X178.911 Y152.23 E.0167
G1 X179.592 Y152.441 E.02574
G1 X179.96 Y152.634 E.01499
G1 X180.289 Y152.885 E.01496
G1 X180.573 Y153.187 E.01496
G1 X180.806 Y153.536 E.01516
M73 P67 R2
G1 X180.986 Y153.931 E.01565
G1 X181.104 Y154.342 E.01543
G1 X181.164 Y154.924 E.02113
G1 X181.163 Y163.413 E.30652
G1 X181.12 Y163.866 E.01641
G1 X180.941 Y164.469 E.02271
G1 X180.699 Y165.011 E.02145
G1 X180.652 Y165.24 E.00843
G1 X180.62 Y165.56 E.01162
G1 X180.389 Y166.288 E.02757
G1 X180.205 Y166.627 E.01392
G1 X179.965 Y166.939 E.01422
G1 X179.645 Y167.237 E.0158
G1 X179.306 Y167.462 E.01469
G1 X179.041 Y167.588 E.01059
G1 X178.499 Y167.755 E.02049
G1 X177.926 Y167.814 E.02078
G1 X172.06 Y167.814 E.2118
G1 X171.589 Y167.77 E.01709
G1 X170.862 Y167.539 E.02753
G1 X170.505 Y167.343 E.01469
G1 X170.18 Y167.087 E.01497
G1 X169.901 Y166.78 E.01498
G1 X169.683 Y166.445 E.0144
G1 X169.52 Y166.084 E.01431
G1 X169.402 Y165.694 E.01473
G1 X169.331 Y165.161 E.01939
G1 X169.271 Y164.933 E.00852
G1 X169.025 Y164.394 E.0214
G1 X168.896 Y163.957 E.01644
G1 X168.836 Y163.376 E.02109
G1 X168.836 Y154.91 E.30568
G1 X168.88 Y154.439 E.01709
G1 X169.111 Y153.712 E.02753
G1 X169.295 Y153.373 E.01392
G1 X169.486 Y153.125 E.01131
M204 S6000
G1 X169.848 Y153.403 F60000
G1 F2761
M204 S500
G1 X169.867 Y153.379 E.00112
G1 X170.148 Y153.117 E.01386
G1 X170.412 Y152.942 E.01142
G1 X170.616 Y152.843 E.00821
G1 X171.106 Y152.693 E.0185
G1 X171.604 Y152.643 E.01806
G1 X178.423 Y152.644 E.2462
G1 X178.835 Y152.685 E.01495
G1 X179.405 Y152.862 E.02156
G1 X179.703 Y153.016 E.01212
G1 X179.973 Y153.219 E.0122
G1 X180.206 Y153.464 E.01222
G1 X180.399 Y153.75 E.01245
G1 X180.552 Y154.081 E.01315
G1 X180.655 Y154.441 E.01354
G1 X180.707 Y154.954 E.01861
G1 X180.705 Y163.398 E.30487
G1 X180.665 Y163.791 E.01427
G1 X180.509 Y164.316 E.01976
G1 X180.249 Y164.932 E.02415
G1 X180.166 Y165.481 E.02003
G1 X179.96 Y166.12 E.02424
G1 X179.814 Y166.386 E.01096
G1 X179.633 Y166.621 E.01074
G1 X179.352 Y166.883 E.01386
G1 X179.088 Y167.058 E.01142
G1 X178.884 Y167.157 E.00821
G1 X178.394 Y167.307 E.0185
G1 X177.896 Y167.357 E.01806
G1 X172.088 Y167.357 E.2097
G1 X171.666 Y167.315 E.0153
G1 X171.031 Y167.111 E.02409
G1 X170.75 Y166.954 E.01163
G1 X170.485 Y166.743 E.01223
G1 X170.258 Y166.49 E.01227
G1 X170.081 Y166.216 E.01178
G1 X169.946 Y165.914 E.01192
G1 X169.853 Y165.607 E.01159
G1 X169.785 Y165.109 E.01817
G1 X169.716 Y164.827 E.01046
G1 X169.457 Y164.241 E.02315
G1 X169.345 Y163.856 E.01447
G1 X169.293 Y163.346 E.01851
G1 X169.293 Y154.938 E.30358
G1 X169.335 Y154.516 E.0153
G1 X169.54 Y153.88 E.02412
G1 X169.686 Y153.614 E.01096
G1 X169.812 Y153.451 E.00745
M204 S6000
G1 X170.193 Y153.72 F60000
G1 F2761
M204 S500
G1 X170.282 Y153.621 E.00479
G1 X170.542 Y153.41 E.0121
G1 X170.796 Y153.269 E.01051
G1 X171.029 Y153.187 E.00891
G1 X171.424 Y153.111 E.01452
G1 X178.67 Y153.119 E.26162
G1 X179.096 Y153.225 E.01585
G1 X179.494 Y153.44 E.01635
G1 X179.767 Y153.672 E.01293
G1 X180.032 Y154.052 E.01673
G1 X180.163 Y154.38 E.01277
G1 X180.25 Y154.885 E.01849
G1 X180.231 Y163.618 E.3153
G1 X180.162 Y163.931 E.01159
G1 X180.06 Y164.192 E.0101
G1 X179.9 Y164.463 E.01137
G1 X179.78 Y164.608 E.0068
G1 X179.748 Y164.692 E.00325
G1 X179.732 Y165.316 E.02256
G1 X179.671 Y165.607 E.01072
G1 X179.58 Y165.847 E.00928
G1 X179.407 Y166.15 E.01259
G1 X179.29 Y166.306 E.00704
G1 X179.038 Y166.533 E.01223
G1 X178.781 Y166.694 E.01097
G1 X178.47 Y166.813 E.01201
G1 X177.965 Y166.9 E.01853
G1 X171.939 Y166.892 E.21754
G1 X171.611 Y166.839 E.012
G1 X171.404 Y166.775 E.00783
G1 X171.006 Y166.56 E.01635
G1 X170.733 Y166.328 E.01294
G1 X170.467 Y165.946 E.01683
G1 X170.365 Y165.716 E.00907
G1 X170.279 Y165.367 E.013
G1 X170.254 Y164.687 E.02454
G1 X170.223 Y164.605 E.00316
G1 X170.059 Y164.406 E.00929
G1 X169.919 Y164.154 E.01044
G1 X169.837 Y163.922 E.00886
G1 X169.75 Y163.415 E.01858
G1 X169.755 Y154.803 E.31096
G1 X169.804 Y154.489 E.01147
G1 X169.904 Y154.181 E.01168
G1 X169.995 Y154.004 E.00718
G1 X170.159 Y153.769 E.01034
M204 S6000
G1 X170.534 Y154.03 F60000
G1 F2761
M204 S500
G1 X170.573 Y153.973 E.00248
G1 X170.765 Y153.809 E.00911
G1 X170.958 Y153.696 E.00808
G1 X171.105 Y153.638 E.00572
G1 X171.523 Y153.557 E.01536
G1 X178.571 Y153.565 E.25447
G1 X178.808 Y153.61 E.00871
G1 X178.961 Y153.662 E.00585
G1 X179.277 Y153.842 E.01314
G1 X179.462 Y154.012 E.00908
G1 X179.655 Y154.311 E.01284
G1 X179.712 Y154.455 E.00561
G1 X179.793 Y154.873 E.01536
G1 X179.785 Y163.521 E.31224
G1 X179.74 Y163.754 E.00858
G1 X179.63 Y164.035 E.01087
G1 X179.51 Y164.225 E.00814
G1 X179.329 Y164.423 E.00968
G1 X179.293 Y164.514 E.00354
G1 X179.285 Y165.22 E.0255
G1 X179.24 Y165.458 E.00874
G1 X179.188 Y165.611 E.00584
G1 X179.006 Y165.931 E.01329
G1 X178.931 Y166.024 E.00431
G1 X178.735 Y166.191 E.0093
G1 X178.542 Y166.304 E.00807
G1 X178.395 Y166.362 E.00572
G1 X177.977 Y166.443 E.01536
G1 X171.929 Y166.435 E.21836
G1 X171.692 Y166.39 E.00871
G1 X171.539 Y166.338 E.00584
G1 X171.223 Y166.158 E.01314
G1 X171.038 Y165.988 E.00908
G1 X170.845 Y165.689 E.01283
G1 X170.787 Y165.543 E.00569
G1 X170.722 Y165.255 E.01066
G1 X170.707 Y164.511 E.02685
G1 X170.672 Y164.422 E.00345
G1 X170.458 Y164.184 E.01157
G1 X170.346 Y163.992 E.00802
G1 X170.288 Y163.845 E.00572
G1 X170.207 Y163.427 E.01536
G1 X170.207 Y154.87 E.30895
G1 X170.239 Y154.629 E.00878
G1 X170.314 Y154.382 E.00932
G1 X170.366 Y154.272 E.00439
G1 X170.5 Y154.079 E.00849
M204 S6000
G1 X170.878 Y154.317 F60000
G1 F2761
M204 S500
G1 X170.883 Y154.308 E.00038
G1 X170.985 Y154.21 E.00513
G1 X171.198 Y154.085 E.0089
G1 X171.51 Y154.014 E.01155
G1 X178.489 Y154.014 E.25198
G1 X178.655 Y154.041 E.00607
G1 X178.83 Y154.1 E.00666
G1 X179.042 Y154.233 E.00905
G1 X179.14 Y154.335 E.00513
G1 X179.265 Y154.548 E.0089
G1 X179.336 Y154.86 E.01155
G1 X179.336 Y163.439 E.30975
G1 X179.309 Y163.605 E.00607
G1 X179.25 Y163.78 E.00666
G1 X179.117 Y163.992 E.00905
G1 X179.013 Y164.092 E.00523
G1 X178.899 Y164.165 E.00489
G1 X178.836 Y164.281 E.00475
G1 X178.836 Y165.139 E.03098
M73 P68 R2
G1 X178.809 Y165.305 E.00607
G1 X178.75 Y165.48 E.00666
G1 X178.617 Y165.692 E.00905
G1 X178.515 Y165.79 E.00513
G1 X178.302 Y165.915 E.0089
G1 X177.99 Y165.986 E.01155
G1 X172.011 Y165.986 E.21587
G1 X171.845 Y165.959 E.00607
G1 X171.67 Y165.9 E.00666
G1 X171.458 Y165.767 E.00905
G1 X171.36 Y165.665 E.00513
G1 X171.235 Y165.452 E.0089
G1 X171.164 Y165.14 E.01155
G1 X171.164 Y164.283 E.03095
G1 X171.106 Y164.17 E.00459
G1 X170.96 Y164.069 E.00639
G1 X170.86 Y163.965 E.00524
G1 X170.735 Y163.752 E.0089
G1 X170.664 Y163.44 E.01155
G1 X170.664 Y154.861 E.30975
G1 X170.691 Y154.695 E.00607
G1 X170.75 Y154.52 E.00666
G1 X170.846 Y154.368 E.00651
M204 S6000
G1 X171.188 Y154.649 F60000
G1 F2761
M204 S500
G1 X171.314 Y154.527 E.00631
G1 X171.5 Y154.471 E.007
G1 X178.5 Y154.471 E.25274
G1 X178.701 Y154.538 E.00766
G1 X178.823 Y154.664 E.00631
G1 X178.879 Y154.85 E.007
G1 X178.879 Y163.45 E.31051
G1 X178.812 Y163.651 E.00766
G1 X178.686 Y163.773 E.00631
G1 X178.379 Y163.893 E.01191
G1 X178.379 Y165.15 E.04538
G1 X178.312 Y165.351 E.00766
G1 X178.186 Y165.473 E.00631
G1 X178 Y165.529 E.007
G1 X172 Y165.529 E.21664
G1 X171.799 Y165.462 E.00766
G1 X171.677 Y165.336 E.00631
G1 X171.621 Y165.15 E.007
G1 X171.621 Y163.902 E.04505
G1 X171.299 Y163.762 E.01271
G1 X171.177 Y163.636 E.00631
G1 X171.121 Y163.45 E.007
G1 X171.121 Y154.85 E.31051
G1 X171.169 Y154.706 E.00549
; WIPE_START
G1 F3000
G1 X171.314 Y154.527 E-.08729
G1 X171.5 Y154.471 E-.07367
G1 X173.076 Y154.471 E-.59903
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X172.476 Y162.08 Z.6 F60000
G1 X172.4 Y163.05 Z.6
G1 Z.2
G1 E.8 F1800
; FEATURE: Outer wall
G1 F2761
M204 S500
G1 X171.9 Y163.05 E.01805
G1 X171.9 Y155.25 E.28163
G1 X178.1 Y155.25 E.22386
G1 X178.1 Y163.05 E.28163
G1 X177.6 Y163.05 E.01805
G1 X177.6 Y164.75 E.06138
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X172.4 Y164.75 E.18775
G1 X172.4 Y163.11 E.05921
M204 S6000
G1 X172.857 Y162.593 F60000
; FEATURE: Inner wall
G1 F2761
M204 S500
G1 X172.357 Y162.593 E.01805
G1 X172.357 Y155.707 E.24862
G1 X177.643 Y155.707 E.19085
G1 X177.643 Y162.593 E.24862
G1 X177.143 Y162.593 E.01805
G1 X177.143 Y164.293 E.06138
G1 X172.857 Y164.293 E.15475
G1 X172.857 Y162.653 E.05921
; WIPE_START
G1 F3000
G1 X172.357 Y162.593 E-.19136
G1 X172.357 Y161.097 E-.56864
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X173.002 Y157.11 Z.6 F60000
G1 Z.2
G1 E.8 F1800
G1 F2761
M204 S500
G1 X172.814 Y157.048 E.00713
G1 X172.814 Y156.164 E.0319
G1 X173.799 Y156.164 E.03555
G1 X173.855 Y156.365 E.00752
G2 X173.037 Y157.062 I1.211 J2.247 E.03908
; WIPE_START
G1 F3000
G1 X172.814 Y157.048 E-.08503
G1 X172.814 Y156.164 E-.3357
G1 X173.707 Y156.164 E-.33927
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X173.771 Y159.489 Z.6 F60000
G1 Z.2
G1 E.8 F1800
; FEATURE: Outer wall
G1 F2761
M204 S500
G1 X173.631 Y159.276 E.00917
G3 X174.837 Y157.008 I1.368 J-.727 E.10936
G1 X174.992 Y157 E.00561
G3 X173.806 Y159.537 I.007 J1.549 E.22518
M204 S6000
G1 X173.39 Y159.74 F60000
; FEATURE: Inner wall
G1 F2761
M204 S500
G1 X173.226 Y159.49 E.01079
M73 P69 R2
G3 X174.789 Y156.553 I1.772 J-.941 E.14161
G1 X174.989 Y156.542 E.00726
G3 X173.44 Y159.813 I.009 J2.007 E.29238
G1 X173.424 Y159.79 E.00104
; WIPE_START
G1 F3000
G1 X173.226 Y159.49 E-.1364
G1 X173.071 Y159.107 E-.15693
G1 X173 Y158.728 E-.14665
G1 X173.002 Y158.351 E-.14344
G1 X173.079 Y157.964 E-.14967
G1 X173.106 Y157.899 E-.0269
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X176.145 Y156.367 Z.6 F60000
G1 Z.2
G1 E.8 F1800
G1 F2761
M204 S500
G1 X176.199 Y156.164 E.0076
G1 X177.186 Y156.164 E.03563
G1 X177.186 Y157.048 E.03191
G1 X176.999 Y157.11 E.00713
G2 X176.197 Y156.396 I-2.032 J1.473 E.03906
; WIPE_START
G1 F3000
G1 X176.199 Y156.164 E-.08818
G1 X177.186 Y156.164 E-.37494
G1 X177.186 Y156.945 E-.29688
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X173.08 Y160.084 Z.6 F60000
G1 Z.2
G1 E.8 F1800
G1 F2761
M204 S500
G1 X173.258 Y160.292 E.00988
G2 X176.998 Y159.99 I1.742 J-1.735 E.15413
G1 X177.186 Y160.052 E.00713
G1 X177.186 Y162.136 E.07522
G1 X176.686 Y162.136 E.01805
G1 X176.686 Y163.836 E.06138
G1 X173.314 Y163.836 E.12174
G1 X173.314 Y162.136 E.06138
G1 X172.814 Y162.136 E.01805
G1 X172.814 Y160.053 E.07519
G1 X173.003 Y159.992 E.00719
G1 X173.042 Y160.038 E.00216
; WIPE_START
G1 F3000
G1 X173.258 Y160.292 E-.12675
G1 X173.448 Y160.466 E-.09785
G1 X173.657 Y160.618 E-.09841
G1 X173.875 Y160.744 E-.09573
G1 X174.292 Y160.912 E-.17073
G1 X174.527 Y160.97 E-.09205
G1 X174.733 Y160.99 E-.07848
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X173.771 Y161.679 Z.6 F60000
G1 Z.2
G1 E.8 F1800
G1 F2761
M204 S500
G1 X173.271 Y161.679 E.01805
G1 X173.271 Y160.923 E.02728
G2 X176.729 Y160.917 I1.724 J-2.452 E.13306
G1 X176.729 Y161.679 E.02751
G1 X176.229 Y161.679 E.01805
G1 X176.229 Y163.379 E.06138
G1 X173.771 Y163.379 E.08873
G1 X173.771 Y161.739 E.05921
; WIPE_START
G1 F3000
G1 X173.271 Y161.679 E-.19136
G1 X173.271 Y160.923 E-.28713
G1 X173.666 Y161.151 E-.17312
G1 X173.93 Y161.257 E-.10839
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X173.201 Y160.588 Z.6 F60000
G1 Z.2
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.111305
G1 F2761
M204 S500
G1 X173.085 Y160.503 E.00078
G1 X173.043 Y160.403 E.00058
M204 S6000
G1 X172.831 Y159.807 F60000
; LINE_WIDTH: 0.390874
G1 F2761
M204 S500
G3 X172.741 Y159.331 I9.129 J-1.961 E.01334
; LINE_WIDTH: 0.335178
G1 X172.722 Y159.216 E.00268
; LINE_WIDTH: 0.314119
G1 X172.72 Y159.203 E.00028
; LINE_WIDTH: 0.287937
G1 X172.696 Y158.997 E.00401
; LINE_WIDTH: 0.236499
G1 X172.674 Y158.55 E.00685
G1 X172.696 Y158.104 E.00683
; LINE_WIDTH: 0.27817
G1 X172.711 Y157.979 E.00235
; LINE_WIDTH: 0.307587
G1 X172.725 Y157.864 E.00241
; LINE_WIDTH: 0.343055
G1 X172.747 Y157.738 E.00304
; LINE_WIDTH: 0.384704
G1 X172.766 Y157.626 E.00307
; LINE_WIDTH: 0.407773
G1 X172.833 Y157.295 E.00974
M204 S6000
G1 X173.043 Y156.697 F60000
; LINE_WIDTH: 0.106851
G1 F2761
M204 S500
G1 X173.169 Y156.393 E.00166
M204 S6000
G1 X173.329 Y156.413 F60000
; LINE_WIDTH: 0.122708
G1 F2761
M204 S500
G2 X173.043 Y156.514 I1.871 J5.758 E.00191
; WIPE_START
G1 F3000
G1 X173.329 Y156.413 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X174.124 Y156.48 Z.6 F60000
G1 Z.2
G1 E.8 F1800
; LINE_WIDTH: 0.484739
G1 F2761
M204 S500
G1 X174.283 Y156.189 E.01158
; LINE_WIDTH: 0.501214
G1 X174.485 Y156.152 E.00743
; LINE_WIDTH: 0.454824
G3 X174.734 Y156.132 I.549 J5.244 E.00812
; LINE_WIDTH: 0.432938
G3 X175.454 Y156.146 I.255 J5.423 E.02222
; LINE_WIDTH: 0.47832
G1 X175.588 Y156.161 E.00463
; LINE_WIDTH: 0.508095
G1 X175.7 Y156.175 E.00414
; LINE_WIDTH: 0.512884
G1 X175.877 Y156.483 E.01319
; WIPE_START
G1 F3000
G1 X175.7 Y156.175 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X176.957 Y156.513 Z.6 F60000
G1 Z.2
G1 E.8 F1800
; LINE_WIDTH: 0.113348
G1 F2761
M204 S500
G2 X176.673 Y156.413 I-2.005 J5.271 E.00168
M204 S6000
G1 X176.831 Y156.393 F60000
; LINE_WIDTH: 0.109344
G1 F2761
M204 S500
G1 X176.957 Y156.696 E.00173
M204 S6000
G1 X177.167 Y157.295 F60000
; LINE_WIDTH: 0.404608
G1 F2761
M204 S500
G3 X177.252 Y157.733 I-8.927 J1.967 E.01273
; LINE_WIDTH: 0.346968
G1 X177.272 Y157.846 E.00278
; LINE_WIDTH: 0.310608
G1 X177.288 Y157.972 E.00268
; LINE_WIDTH: 0.281184
G1 X177.302 Y158.084 E.00211
; LINE_WIDTH: 0.237137
G1 X177.326 Y158.544 E.00707
G1 X177.304 Y158.996 E.00694
; LINE_WIDTH: 0.278169
G1 X177.289 Y159.121 E.00235
; LINE_WIDTH: 0.307583
G1 X177.275 Y159.236 E.00241
; LINE_WIDTH: 0.34306
G1 X177.253 Y159.362 E.00304
; LINE_WIDTH: 0.384749
G1 X177.234 Y159.474 E.00307
; LINE_WIDTH: 0.407825
G1 X177.167 Y159.805 E.00973
M204 S6000
G1 X176.957 Y160.404 F60000
; LINE_WIDTH: 0.108531
G1 F2761
M204 S500
G1 X176.925 Y160.482 E.00044
G3 X176.84 Y160.551 I-.104 J-.04 E.00059
; WIPE_START
G1 F3000
G1 X176.925 Y160.482 E-.42932
G1 X176.957 Y160.404 E-.33068
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X176.046 Y162.409 Z.6 F60000
G1 Z.2
G1 E.8 F1800
; FEATURE: Bottom surface
; LINE_WIDTH: 0.50249
G1 F2761
M204 S500
G1 X175.463 Y161.826 E.02992
G3 X174.842 Y161.854 I-.465 J-3.358 E.02262
G1 X175.84 Y162.853 E.05127
G1 X175.84 Y162.99 E.00498
G1 X175.327 Y162.99 E.01862
G1 X174.16 Y161.823 E.05995
G1 X174.16 Y162.472 E.02359
G1 X174.883 Y163.196 E.03714
; CHANGE_LAYER
; Z_HEIGHT: 0.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F6300
G1 X174.16 Y162.472 E-.38881
G1 X174.16 Y161.823 E-.24697
G1 X174.391 Y162.054 E-.12422
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 2/32
; update layer progress
M73 L2
M991 S0 P1 ;notify layer change

; open powerlost recovery
M1003 S1
; OBJECT_ID: 15
M204 S10000
G17
G3 Z.6 I.025 J-1.217 P1  F60000
G1 X173.416 Y162.034 Z.6
G1 Z.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X172.916 Y162.034 E.01608
G1 X172.916 Y160.076 E.06296
G2 X176.045 Y160.896 I2.094 J-1.612 E.11193
G2 X177.084 Y160.062 I-1.165 J-2.514 E.04326
G1 X177.084 Y162.034 E.06341
G1 X176.584 Y162.034 E.01608
M73 P70 R2
G1 X176.584 Y163.734 E.05467
G1 X173.416 Y163.734 E.10186
G1 X173.416 Y162.094 E.05274
; WIPE_START
G1 F8843.478
G1 X172.916 Y162.034 E-.19136
G1 X172.916 Y160.537 E-.56864
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X176.453 Y156.436 Z.8 F60000
G1 Z.4
G1 E.8 F1800
G1 F1200
M204 S8000
G1 X176.508 Y156.266 E.00572
G1 X177.084 Y156.266 E.01853
G1 X177.084 Y157.024 E.02437
G2 X176.502 Y156.471 I-2.497 J2.044 E.02589
; WIPE_START
G1 F8843.478
G1 X176.508 Y156.266 E-.07778
G1 X177.084 Y156.266 E-.21898
G1 X177.084 Y157.024 E-.28798
G1 X176.785 Y156.704 E-.16652
G1 X176.767 Y156.689 E-.00874
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X173.313 Y159.885 Z.8 F60000
G1 Z.4
G1 E.8 F1800
G1 F1200
M204 S8000
G1 X173.229 Y159.785 E.00421
G3 X174.771 Y156.402 I1.77 J-1.236 E.14404
G1 X174.974 Y156.39 E.00654
G3 X173.5 Y160.103 I.025 J2.159 E.27216
G1 X173.352 Y159.931 E.00731
M204 S10000
G1 X173.622 Y159.623 F60000
G1 F1200
M204 S8000
G1 X173.564 Y159.553 E.00292
G3 X174.815 Y156.807 I1.435 J-1.004 E.11691
G1 X174.978 Y156.797 E.00527
G3 X173.783 Y159.81 I.021 J1.752 E.22083
G1 X173.661 Y159.668 E.00603
M204 S250
G1 X173.919 Y159.369 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X173.886 Y159.329 E.00155
G3 X174.857 Y157.197 I1.113 J-.78 E.0841
G1 X174.983 Y157.19 E.00375
G3 X174.056 Y159.528 I.017 J1.359 E.15876
G1 X173.958 Y159.415 E.00445
; WIPE_START
G1 F9547.055
M204 S8000
G1 X173.886 Y159.329 E-.04257
G1 X173.755 Y159.097 E-.10117
G1 X173.67 Y158.833 E-.10545
G1 X173.64 Y158.575 E-.09883
G1 X173.66 Y158.315 E-.09912
G1 X173.73 Y158.063 E-.09919
G1 X173.846 Y157.829 E-.0994
G1 X174.022 Y157.605 E-.10806
G1 X174.033 Y157.594 E-.00621
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.916 Y157.038 Z.8 F60000
G1 Z.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X172.916 Y156.266 E.02482
G1 X173.491 Y156.266 E.01848
G1 X173.547 Y156.432 E.00563
G2 X172.954 Y156.991 I1.812 J2.518 E.02629
; WIPE_START
G1 F8843.478
G1 X172.916 Y156.266 E-.27587
G1 X173.491 Y156.266 E-.21839
G1 X173.547 Y156.432 E-.06658
G1 X173.346 Y156.586 E-.09629
G1 X173.153 Y156.766 E-.10026
G1 X173.148 Y156.771 E-.00259
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X173.009 Y162.441 Z.8 F60000
G1 Z.4
G1 E.8 F1800
G1 F1200
M204 S8000
G1 X172.509 Y162.441 E.01608
G1 X172.509 Y155.859 E.21164
G1 X177.491 Y155.859 E.16019
G1 X177.491 Y162.441 E.21164
G1 X176.991 Y162.441 E.01608
G1 X176.991 Y164.141 E.05467
G1 X173.009 Y164.141 E.12804
G1 X173.009 Y162.501 E.05274
M204 S10000
G1 X172.602 Y162.848 F60000
G1 F1200
M204 S8000
G1 X172.102 Y162.848 E.01608
G1 X172.102 Y155.452 E.23782
G1 X177.898 Y155.452 E.18637
G1 X177.898 Y162.848 E.23782
G1 X177.398 Y162.848 E.01608
M73 P71 R2
G1 X177.398 Y164.548 E.05467
G1 X172.602 Y164.548 E.15422
G1 X172.602 Y162.908 E.05274
M204 S250
G1 X172.21 Y163.24 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X171.71 Y163.24 E.01489
G1 X171.71 Y155.06 E.24365
G1 X178.29 Y155.06 E.196
G1 X178.29 Y163.24 E.24365
G1 X177.79 Y163.24 E.01489
G1 X177.79 Y164.94 E.05064
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X172.21 Y164.94 E.16621
G1 X172.21 Y163.3 E.04885
; WIPE_START
G1 F9547.055
M204 S8000
G1 X171.71 Y163.24 E-.19136
G1 X171.71 Y161.744 E-.56864
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X174.748 Y162.235 Z.8 F60000
G1 Z.4
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.40063
G1 F1200
M204 S8000
G1 X174.554 Y162.221 E.0055
G1 X174.554 Y162.596 E.0106
G2 X175.448 Y162.598 I.514 J-28.444 E.02525
G1 X175.448 Y162.225 E.01053
G1 X174.808 Y162.235 E.01807
M204 S10000
G1 X175.231 Y161.876 F60000
; LINE_WIDTH: 0.41999
G1 F1200
M204 S8000
G1 X174.48 Y161.845 E.02242
G1 X174.18 Y161.782 E.00912
G3 X174.185 Y162.965 I-69.333 J.908 E.03522
G1 X175.815 Y162.965 E.04853
G1 X175.827 Y161.772 E.03552
G1 X175.291 Y161.865 E.01622
M204 S10000
G1 X174.806 Y161.492 F60000
; LINE_WIDTH: 0.429188
G1 F1200
M204 S8000
G1 X174.195 Y161.399 E.01885
G1 X173.695 Y161.225 E.01615
; LINE_WIDTH: 0.461307
G1 X173.334 Y160.995 E.01415
G1 X173.334 Y161.616 E.02053
G1 X173.692 Y161.644 E.01189
G1 X173.804 Y161.788 E.00602
; LINE_WIDTH: 0.421196
G3 X173.808 Y163.342 I-126.166 J1.09 E.04642
G1 X176.192 Y163.342 E.07122
G1 X176.192 Y161.83 E.04516
G1 X176.22 Y161.715 E.00354
G1 X176.38 Y161.621 E.00555
; LINE_WIDTH: 0.46822
G1 X176.664 Y161.614 E.00953
G1 X176.664 Y161.019 E.02
G1 X176.359 Y161.199 E.0119
G1 X175.898 Y161.376 E.01658
; LINE_WIDTH: 0.422595
G1 X175.382 Y161.485 E.01584
G1 X174.866 Y161.491 E.01548
; WIPE_START
G1 F9481.8
G1 X175.382 Y161.485 E-.37561
G1 X175.898 Y161.376 E-.38439
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.963 Y159.792 Z.8 F60000
G1 Z.4
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.103655
G1 F1200
M204 S8000
G1 X172.903 Y159.714 E.00047
; LINE_WIDTH: 0.126629
G1 X172.841 Y159.624 E.00073
; LINE_WIDTH: 0.15971
G3 X172.776 Y159.522 I.093 J-.131 E.00114
; LINE_WIDTH: 0.151325
G1 X172.755 Y159.41 E.00097
; LINE_WIDTH: 0.115054
G1 X172.735 Y159.299 E.00065
; WIPE_START
G1 F15000
G1 X172.755 Y159.41 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.79 Y157.494 Z.8 F60000
G1 Z.4
G1 E.8 F1800
; LINE_WIDTH: 0.119161
G1 F1200
M204 S8000
G2 X172.735 Y157.805 I6.492 J1.292 E.0019
M204 S10000
G1 X172.713 Y157.698 F60000
; LINE_WIDTH: 0.140791
G1 F1200
M204 S8000
G1 X172.842 Y157.494 E.00187
; LINE_WIDTH: 0.108733
G1 X172.922 Y157.379 E.00073
; WIPE_START
G1 F15000
G1 X172.842 Y157.494 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X173.713 Y156.286 Z.8 F60000
G1 Z.4
G1 E.8 F1800
; LINE_WIDTH: 0.36259
G1 F1200
M204 S8000
G3 X174.128 Y156.204 I1.877 J8.381 E.0107
; LINE_WIDTH: 0.305506
G1 X174.24 Y156.184 E.00235
; LINE_WIDTH: 0.268103
G1 X174.369 Y156.167 E.00232
; LINE_WIDTH: 0.235807
G1 X174.487 Y156.151 E.00181
; LINE_WIDTH: 0.200131
G1 X174.738 Y156.131 E.00314
; LINE_WIDTH: 0.178891
G1 X175.21 Y156.129 E.00507
G1 X175.457 Y156.146 E.00266
; LINE_WIDTH: 0.222852
G1 X175.574 Y156.16 E.00167
; LINE_WIDTH: 0.249516
G1 X175.683 Y156.172 E.00179
; LINE_WIDTH: 0.283426
G1 X175.811 Y156.194 E.00248
; LINE_WIDTH: 0.32469
G1 X175.929 Y156.213 E.00266
; LINE_WIDTH: 0.347244
G1 X176.288 Y156.282 E.00879
; WIPE_START
G1 F11829.497
G1 X175.929 Y156.213 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X177.037 Y157.308 Z.8 F60000
G1 Z.4
G1 E.8 F1800
; LINE_WIDTH: 0.115775
G1 F1200
M204 S8000
G1 X177.159 Y157.476 E.00119
; LINE_WIDTH: 0.158468
G1 X177.222 Y157.567 E.00101
; LINE_WIDTH: 0.153258
G1 X177.245 Y157.689 E.00109
; LINE_WIDTH: 0.115076
G1 X177.265 Y157.801 E.00065
; WIPE_START
G1 F15000
G1 X177.245 Y157.689 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X177.21 Y159.606 Z.8 F60000
G1 Z.4
G1 E.8 F1800
; LINE_WIDTH: 0.120457
G1 F1200
M204 S8000
G2 X177.265 Y159.295 I-5.661 J-1.158 E.00194
M204 S10000
M73 P72 R2
G1 X177.287 Y159.402 F60000
; LINE_WIDTH: 0.136201
G1 F1200
M204 S8000
G1 X177.138 Y159.637 E.00205
; LINE_WIDTH: 0.104112
G1 X177.08 Y159.719 E.00048
; CHANGE_LAYER
; Z_HEIGHT: 0.6
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F15000
G1 X177.138 Y159.637 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 3/32
; update layer progress
M73 L3
M991 S0 P2 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z.8 I-.16 J-1.206 P1  F60000
G1 X173.02 Y160.184 Z.8
G1 Z.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X173.184 Y160.366 E.00788
G2 X177.084 Y160.072 I1.821 J-1.853 E.14238
G1 X177.084 Y162.034 E.0631
G1 X176.584 Y162.034 E.01608
G1 X176.584 Y163.734 E.05467
G1 X173.416 Y163.734 E.10186
G1 X173.416 Y162.034 E.05467
G1 X172.916 Y162.034 E.01608
G1 X172.916 Y160.068 E.0632
G1 X172.98 Y160.139 E.00305
; COOLING_NODE: 0
; WIPE_START
G1 F8843.478
G1 X173.184 Y160.366 E-.11592
G1 X173.383 Y160.545 E-.10205
G1 X173.601 Y160.704 E-.10238
G1 X174.04 Y160.931 E-.18776
G1 X174.507 Y161.07 E-.18533
G1 X174.681 Y161.096 E-.06656
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.916 Y157.028 Z1 F60000
G1 Z.6
G1 E.8 F1800
G1 F1200
M204 S8000
G1 X172.916 Y156.266 E.02451
G1 X173.492 Y156.266 E.01852
G1 X173.548 Y156.434 E.00567
G2 X172.954 Y156.982 I1.891 J2.64 E.02605
; COOLING_NODE: 0
; WIPE_START
G1 F8843.478
G1 X172.916 Y156.266 E-.27247
G1 X173.492 Y156.266 E-.21883
G1 X173.548 Y156.434 E-.06703
G1 X173.187 Y156.732 E-.17797
G1 X173.144 Y156.778 E-.0237
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X173.26 Y159.817 Z1 F60000
G1 Z.6
G1 E.8 F1800
G1 F1200
M204 S8000
G1 X173.091 Y159.561 E.00986
G3 X174.772 Y156.402 I1.907 J-1.013 E.13568
G1 X174.988 Y156.39 E.00695
G3 X173.322 Y159.91 I.01 J2.159 E.28012
G1 X173.293 Y159.867 E.00164
; COOLING_NODE: 0
M204 S10000
G1 X173.599 Y159.594 F60000
G1 F1200
M204 S8000
G1 X173.452 Y159.371 E.00857
G3 X174.816 Y156.807 I1.547 J-.822 E.11009
G1 X174.991 Y156.797 E.00565
G3 X173.639 Y159.653 I.008 J1.752 E.22728
G1 X173.632 Y159.643 E.00036
; COOLING_NODE: 0
M204 S250
G1 X173.924 Y159.378 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X173.799 Y159.188 E.00679
G3 X174.857 Y157.197 I1.2 J-.638 E.07915
G1 X174.994 Y157.19 E.00407
G3 X173.961 Y159.426 I.006 J1.359 E.16259
; COOLING_NODE: 0
; WIPE_START
G1 F9547.055
M204 S8000
G1 X173.799 Y159.188 E-.10936
G1 X173.693 Y158.926 E-.10729
G1 X173.645 Y158.669 E-.09939
G1 X173.647 Y158.414 E-.09683
G1 X173.699 Y158.153 E-.10121
G1 X173.799 Y157.911 E-.09946
G1 X173.954 Y157.681 E-.10557
G1 X174.03 Y157.605 E-.0409
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X176.452 Y156.435 Z1 F60000
G1 Z.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X176.507 Y156.266 E.00571
G1 X177.084 Y156.266 E.01855
G1 X177.084 Y157.027 E.02447
G2 X176.501 Y156.47 I-2.476 J2.008 E.026
; COOLING_NODE: 0
; WIPE_START
G1 F8843.478
G1 X176.507 Y156.266 E-.07753
G1 X177.084 Y156.266 E-.21922
G1 X177.084 Y157.027 E-.28921
G1 X176.811 Y156.73 E-.15322
G1 X176.771 Y156.693 E-.02082
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X173.009 Y162.441 Z1 F60000
G1 Z.6
G1 E.8 F1800
G1 F1200
M204 S8000
G1 X172.509 Y162.441 E.01608
G1 X172.509 Y155.859 E.21164
G1 X177.491 Y155.859 E.16019
G1 X177.491 Y162.441 E.21164
G1 X176.991 Y162.441 E.01608
G1 X176.991 Y164.141 E.05467
G1 X173.009 Y164.141 E.12804
G1 X173.009 Y162.501 E.05274
; COOLING_NODE: 0
M204 S10000
G1 X172.602 Y162.848 F60000
G1 F1200
M204 S8000
M73 P73 R2
G1 X172.102 Y162.848 E.01608
G1 X172.102 Y155.452 E.23782
G1 X177.898 Y155.452 E.18637
G1 X177.898 Y162.848 E.23782
G1 X177.398 Y162.848 E.01608
G1 X177.398 Y164.548 E.05467
G1 X172.602 Y164.548 E.15422
G1 X172.602 Y162.908 E.05274
; COOLING_NODE: 1
M204 S250
G1 X172.21 Y163.24 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X171.71 Y163.24 E.01489
G1 X171.71 Y155.06 E.24365
G1 X178.29 Y155.06 E.196
G1 X178.29 Y163.24 E.24365
G1 X177.79 Y163.24 E.01489
G1 X177.79 Y164.94 E.05064
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X172.21 Y164.94 E.16621
G1 X172.21 Y163.3 E.04885
; WIPE_START
G1 F9547.055
M204 S8000
G1 X171.71 Y163.24 E-.19136
G1 X171.71 Y161.744 E-.56864
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.012 Y161.51 Z1 F60000
G1 Z.6
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.424223
G1 F1200
M204 S8000
G1 X174.445 Y161.457 E.01714
G1 X173.907 Y161.31 E.0168
; LINE_WIDTH: 0.464337
G1 X173.337 Y161.029 E.02117
G1 X173.337 Y161.613 E.01945
G1 X173.679 Y161.641 E.01145
G1 X173.733 Y161.669 E.00202
; LINE_WIDTH: 0.420842
G1 X173.808 Y161.899 E.00722
G1 X173.808 Y163.342 E.04307
G1 X176.192 Y163.342 E.07115
G1 X176.192 Y161.83 E.04512
G3 X176.303 Y161.646 I.188 J-.012 E.00685
; LINE_WIDTH: 0.467364
G1 X176.665 Y161.615 E.01218
G1 X176.665 Y161.015 E.02011
G1 X176.3 Y161.222 E.01406
; LINE_WIDTH: 0.430018
G1 X175.688 Y161.418 E.01965
G1 X175.071 Y161.502 E.01904
M204 S10000
G1 X174.788 Y161.869 F60000
; LINE_WIDTH: 0.41999
G1 F1200
M204 S8000
G1 X174.153 Y161.767 E.01916
G1 X174.185 Y162.035 E.00804
G1 X174.185 Y162.965 E.02769
G1 X175.815 Y162.965 E.04853
G1 X175.823 Y161.776 E.03541
G1 X175.32 Y161.872 E.01524
G1 X174.848 Y161.87 E.01408
M204 S10000
G1 X174.911 Y162.248 F60000
; LINE_WIDTH: 0.398987
G1 F1200
M204 S8000
G1 X174.554 Y162.217 E.01009
G1 X174.554 Y162.596 E.01066
G2 X175.448 Y162.598 I.509 J-26.887 E.02514
G1 X175.448 Y162.224 E.01052
G1 X174.971 Y162.245 E.01342
; WIPE_START
G1 F10110.479
G1 X175.448 Y162.224 E-.1813
G1 X175.448 Y162.598 E-.14214
G1 X174.554 Y162.596 E-.33968
G1 X174.554 Y162.341 E-.09688
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.941 Y159.755 Z1 F60000
G1 Z.6
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.104436
G1 F1200
M204 S8000
G1 X172.879 Y159.671 E.0005
; LINE_WIDTH: 0.126221
G1 X172.796 Y159.545 E.00099
; LINE_WIDTH: 0.154095
G1 X172.713 Y159.419 E.00133
M204 S10000
G1 X172.735 Y159.294 F60000
; LINE_WIDTH: 0.131153
G1 F1200
M204 S8000
G2 X172.797 Y159.631 I6.262 J-.967 E.00239
; WIPE_START
G1 F15000
G1 X172.735 Y159.294 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.735 Y157.805 Z1 F60000
G1 Z.6
G1 E.8 F1800
; LINE_WIDTH: 0.11077
G1 F1200
M204 S8000
G1 X172.751 Y157.712 E.0005
; LINE_WIDTH: 0.13847
G1 X172.767 Y157.62 E.00071
; LINE_WIDTH: 0.158114
G3 X172.829 Y157.5 I.214 J.035 E.00125
; LINE_WIDTH: 0.128738
G1 X172.882 Y157.422 E.00064
; LINE_WIDTH: 0.105682
G1 X172.951 Y157.328 E.00058
; WIPE_START
G1 F15000
G1 X172.882 Y157.422 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X173.713 Y156.286 Z1 F60000
G1 Z.6
M73 P74 R2
G1 E.8 F1800
; LINE_WIDTH: 0.358798
G1 F1200
M204 S8000
G3 X174.144 Y156.201 I1.889 J8.529 E.01096
; LINE_WIDTH: 0.299291
G1 X174.263 Y156.18 E.00245
; LINE_WIDTH: 0.262566
G1 X174.383 Y156.165 E.00209
; LINE_WIDTH: 0.233488
G1 X174.491 Y156.151 E.00165
; LINE_WIDTH: 0.19965
G1 X174.74 Y156.131 E.00309
; LINE_WIDTH: 0.179061
G1 X175.212 Y156.129 E.00507
G1 X175.461 Y156.146 E.00269
; LINE_WIDTH: 0.224902
G1 X175.588 Y156.161 E.00183
; LINE_WIDTH: 0.25469
G1 X175.706 Y156.176 E.00199
; LINE_WIDTH: 0.288988
G1 X175.826 Y156.196 E.00236
; LINE_WIDTH: 0.327959
G1 X175.935 Y156.214 E.00249
; LINE_WIDTH: 0.3492
G1 X176.287 Y156.283 E.0087
; WIPE_START
G1 F11753.972
G1 X175.935 Y156.214 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X177.046 Y157.323 Z1 F60000
G1 Z.6
G1 E.8 F1800
; LINE_WIDTH: 0.116538
G1 F1200
M204 S8000
G1 X177.17 Y157.498 E.00125
; LINE_WIDTH: 0.157588
G1 X177.223 Y157.576 E.00085
; LINE_WIDTH: 0.146916
G1 X177.248 Y157.709 E.00111
; LINE_WIDTH: 0.111482
G1 X177.265 Y157.804 E.00053
; WIPE_START
G1 F15000
G1 X177.248 Y157.709 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X177.265 Y159.296 Z1 F60000
G1 Z.6
G1 E.8 F1800
; LINE_WIDTH: 0.110777
G1 F1200
M204 S8000
G1 X177.249 Y159.388 E.0005
; LINE_WIDTH: 0.1456
G1 X177.223 Y159.521 E.0011
; LINE_WIDTH: 0.156687
G1 X177.171 Y159.6 E.00085
; LINE_WIDTH: 0.116035
G1 X177.049 Y159.772 E.00122
; CHANGE_LAYER
; Z_HEIGHT: 0.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F15000
G1 X177.171 Y159.6 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 4/32
; update layer progress
M73 L4
M991 S0 P3 ;notify layer change

M106 S229.5
; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z1 I-.662 J-1.021 P1  F60000
G1 X173.416 Y162.034 Z1
G1 Z.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X172.916 Y162.034 E.01608
G1 X172.916 Y160.076 E.06296
G2 X176.045 Y160.896 I2.094 J-1.612 E.11193
G2 X177.084 Y160.062 I-1.165 J-2.514 E.04326
G1 X177.084 Y162.034 E.06341
G1 X176.584 Y162.034 E.01608
G1 X176.584 Y163.734 E.05467
G1 X173.416 Y163.734 E.10186
G1 X173.416 Y162.094 E.05274
; COOLING_NODE: 0
; WIPE_START
G1 F8843.478
G1 X172.916 Y162.034 E-.19136
G1 X172.916 Y160.537 E-.56864
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X176.453 Y156.436 Z1.2 F60000
G1 Z.8
G1 E.8 F1800
G1 F1200
M204 S8000
G1 X176.508 Y156.266 E.00572
G1 X177.084 Y156.266 E.01853
G1 X177.084 Y157.024 E.02437
G2 X176.502 Y156.471 I-2.497 J2.044 E.02589
; COOLING_NODE: 0
; WIPE_START
G1 F8843.478
G1 X176.508 Y156.266 E-.07778
G1 X177.084 Y156.266 E-.21898
G1 X177.084 Y157.024 E-.28798
G1 X176.785 Y156.704 E-.16652
G1 X176.767 Y156.689 E-.00874
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X173.31 Y159.882 Z1.2 F60000
G1 Z.8
G1 E.8 F1800
G1 F1200
M204 S8000
G1 X173.229 Y159.785 E.00407
G3 X174.771 Y156.402 I1.77 J-1.236 E.14404
G1 X174.974 Y156.39 E.00654
G3 X173.5 Y160.103 I.025 J2.159 E.27216
G1 X173.349 Y159.927 E.00745
; COOLING_NODE: 0
M204 S10000
G1 X173.619 Y159.619 F60000
G1 F1200
M204 S8000
G1 X173.564 Y159.553 E.00278
G3 X174.815 Y156.807 I1.435 J-1.004 E.11691
G1 X174.978 Y156.797 E.00527
G3 X173.783 Y159.81 I.021 J1.752 E.22083
G1 X173.658 Y159.665 E.00617
; COOLING_NODE: 0
M204 S250
G1 X173.916 Y159.366 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X173.886 Y159.329 E.00142
G3 X174.857 Y157.197 I1.113 J-.78 E.0841
G1 X174.983 Y157.19 E.00375
G3 X174.056 Y159.528 I.017 J1.359 E.15876
G1 X173.955 Y159.411 E.00458
; COOLING_NODE: 0
; WIPE_START
G1 F9547.055
M204 S8000
G1 X173.886 Y159.329 E-.04088
G1 X173.755 Y159.097 E-.10117
G1 X173.67 Y158.833 E-.10545
G1 X173.64 Y158.575 E-.09883
G1 X173.66 Y158.315 E-.09912
G1 X173.73 Y158.063 E-.09919
G1 X173.846 Y157.829 E-.0994
G1 X174.022 Y157.605 E-.10806
G1 X174.037 Y157.591 E-.00789
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.916 Y157.038 Z1.2 F60000
G1 Z.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X172.916 Y156.266 E.02482
G1 X173.491 Y156.266 E.01848
G1 X173.547 Y156.432 E.00563
G2 X172.954 Y156.991 I1.812 J2.518 E.02629
; COOLING_NODE: 0
; WIPE_START
G1 F8843.478
G1 X172.916 Y156.266 E-.27587
G1 X173.491 Y156.266 E-.21839
G1 X173.547 Y156.432 E-.06658
G1 X173.346 Y156.586 E-.09629
G1 X173.153 Y156.766 E-.10026
G1 X173.148 Y156.771 E-.00259
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X173.009 Y162.441 Z1.2 F60000
G1 Z.8
G1 E.8 F1800
G1 F1200
M204 S8000
G1 X172.509 Y162.441 E.01608
G1 X172.509 Y155.859 E.21164
G1 X177.491 Y155.859 E.16019
G1 X177.491 Y162.441 E.21164
G1 X176.991 Y162.441 E.01608
G1 X176.991 Y164.141 E.05467
G1 X173.009 Y164.141 E.12804
M73 P75 R2
G1 X173.009 Y162.501 E.05274
; COOLING_NODE: 0
M204 S10000
G1 X172.602 Y162.848 F60000
G1 F1200
M204 S8000
G1 X172.102 Y162.848 E.01608
G1 X172.102 Y155.452 E.23782
G1 X177.898 Y155.452 E.18637
G1 X177.898 Y162.848 E.23782
G1 X177.398 Y162.848 E.01608
G1 X177.398 Y164.548 E.05467
G1 X172.602 Y164.548 E.15422
G1 X172.602 Y162.908 E.05274
; COOLING_NODE: 1
M204 S250
G1 X172.21 Y163.24 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X171.71 Y163.24 E.01489
G1 X171.71 Y155.06 E.24365
G1 X178.29 Y155.06 E.196
G1 X178.29 Y163.24 E.24365
G1 X177.79 Y163.24 E.01489
G1 X177.79 Y164.94 E.05064
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X172.21 Y164.94 E.16621
G1 X172.21 Y163.3 E.04885
; WIPE_START
G1 F9547.055
M204 S8000
G1 X171.71 Y163.24 E-.19136
M73 P75 R1
G1 X171.71 Y161.744 E-.56864
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X174.748 Y162.235 Z1.2 F60000
G1 Z.8
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.40063
G1 F1200
M204 S8000
G1 X174.554 Y162.221 E.0055
G1 X174.554 Y162.596 E.0106
G2 X175.448 Y162.598 I.514 J-28.444 E.02525
G1 X175.448 Y162.225 E.01053
G1 X174.808 Y162.235 E.01807
M204 S10000
G1 X175.231 Y161.876 F60000
; LINE_WIDTH: 0.41999
G1 F1200
M204 S8000
G1 X174.48 Y161.845 E.02242
G1 X174.18 Y161.782 E.00912
G3 X174.185 Y162.965 I-69.333 J.908 E.03522
G1 X175.815 Y162.965 E.04853
G1 X175.827 Y161.772 E.03552
G1 X175.291 Y161.865 E.01622
M204 S10000
G1 X174.806 Y161.492 F60000
; LINE_WIDTH: 0.429188
G1 F1200
M204 S8000
G1 X174.195 Y161.399 E.01885
G1 X173.695 Y161.225 E.01615
; LINE_WIDTH: 0.461307
G1 X173.334 Y160.995 E.01415
G1 X173.334 Y161.616 E.02053
G1 X173.692 Y161.644 E.01189
G1 X173.804 Y161.788 E.00602
; LINE_WIDTH: 0.421196
G3 X173.808 Y163.342 I-126.166 J1.09 E.04642
G1 X176.192 Y163.342 E.07122
G1 X176.192 Y161.83 E.04516
G1 X176.22 Y161.715 E.00354
G1 X176.38 Y161.621 E.00555
; LINE_WIDTH: 0.46822
G1 X176.664 Y161.614 E.00953
G1 X176.664 Y161.019 E.02
G1 X176.359 Y161.199 E.0119
G1 X175.898 Y161.376 E.01658
; LINE_WIDTH: 0.422595
M73 P76 R1
G1 X175.382 Y161.485 E.01584
G1 X174.866 Y161.491 E.01548
; WIPE_START
G1 F9481.8
G1 X175.382 Y161.485 E-.37561
G1 X175.898 Y161.376 E-.38439
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.963 Y159.792 Z1.2 F60000
G1 Z.8
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.103655
G1 F1200
M204 S8000
G1 X172.903 Y159.714 E.00047
; LINE_WIDTH: 0.126629
G1 X172.841 Y159.624 E.00073
; LINE_WIDTH: 0.15971
G3 X172.776 Y159.522 I.093 J-.131 E.00114
; LINE_WIDTH: 0.151325
G1 X172.755 Y159.41 E.00097
; LINE_WIDTH: 0.115054
G1 X172.735 Y159.299 E.00065
; WIPE_START
G1 F15000
G1 X172.755 Y159.41 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.79 Y157.494 Z1.2 F60000
G1 Z.8
G1 E.8 F1800
; LINE_WIDTH: 0.119161
G1 F1200
M204 S8000
G2 X172.735 Y157.805 I6.492 J1.292 E.0019
M204 S10000
G1 X172.713 Y157.698 F60000
; LINE_WIDTH: 0.140791
G1 F1200
M204 S8000
G1 X172.842 Y157.494 E.00187
; LINE_WIDTH: 0.108733
G1 X172.922 Y157.379 E.00073
; WIPE_START
G1 F15000
G1 X172.842 Y157.494 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X173.713 Y156.286 Z1.2 F60000
G1 Z.8
G1 E.8 F1800
; LINE_WIDTH: 0.36259
G1 F1200
M204 S8000
G3 X174.128 Y156.204 I1.877 J8.381 E.0107
; LINE_WIDTH: 0.305506
G1 X174.24 Y156.184 E.00235
; LINE_WIDTH: 0.268103
G1 X174.369 Y156.167 E.00232
; LINE_WIDTH: 0.235807
G1 X174.487 Y156.151 E.00181
; LINE_WIDTH: 0.200131
G1 X174.738 Y156.131 E.00314
; LINE_WIDTH: 0.178891
G1 X175.21 Y156.129 E.00507
G1 X175.457 Y156.146 E.00266
; LINE_WIDTH: 0.222852
G1 X175.574 Y156.16 E.00167
; LINE_WIDTH: 0.249516
G1 X175.683 Y156.172 E.00179
; LINE_WIDTH: 0.283426
G1 X175.811 Y156.194 E.00248
; LINE_WIDTH: 0.32469
G1 X175.929 Y156.213 E.00266
; LINE_WIDTH: 0.347244
G1 X176.288 Y156.282 E.00879
; WIPE_START
G1 F11829.497
G1 X175.929 Y156.213 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X177.037 Y157.308 Z1.2 F60000
G1 Z.8
G1 E.8 F1800
; LINE_WIDTH: 0.115775
G1 F1200
M204 S8000
G1 X177.159 Y157.476 E.00119
; LINE_WIDTH: 0.158468
G1 X177.222 Y157.567 E.00101
; LINE_WIDTH: 0.153258
G1 X177.245 Y157.689 E.00109
; LINE_WIDTH: 0.115076
G1 X177.265 Y157.801 E.00065
; WIPE_START
G1 F15000
G1 X177.245 Y157.689 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X177.21 Y159.606 Z1.2 F60000
G1 Z.8
G1 E.8 F1800
; LINE_WIDTH: 0.120457
G1 F1200
M204 S8000
G2 X177.265 Y159.295 I-5.661 J-1.158 E.00194
M204 S10000
G1 X177.287 Y159.402 F60000
; LINE_WIDTH: 0.136201
G1 F1200
M204 S8000
G1 X177.138 Y159.637 E.00205
; LINE_WIDTH: 0.104112
G1 X177.08 Y159.719 E.00048
; CHANGE_LAYER
; Z_HEIGHT: 1
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F15000
G1 X177.138 Y159.637 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 5/32
; update layer progress
M73 L5
M991 S0 P4 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z1.2 I-.159 J-1.207 P1  F60000
G1 X173.017 Y160.18 Z1.2
G1 Z1
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X173.184 Y160.366 E.00802
G2 X177.084 Y160.072 I1.821 J-1.853 E.14238
G1 X177.084 Y162.034 E.0631
G1 X176.584 Y162.034 E.01608
G1 X176.584 Y163.734 E.05467
G1 X173.416 Y163.734 E.10186
G1 X173.416 Y162.034 E.05467
G1 X172.916 Y162.034 E.01608
G1 X172.916 Y160.068 E.0632
G1 X172.977 Y160.136 E.00292
; COOLING_NODE: 0
; WIPE_START
G1 F8843.478
G1 X173.184 Y160.366 E-.11752
G1 X173.383 Y160.545 E-.10205
G1 X173.601 Y160.704 E-.10238
G1 X174.04 Y160.931 E-.18776
G1 X174.507 Y161.07 E-.18533
G1 X174.677 Y161.095 E-.06496
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.916 Y157.028 Z1.4 F60000
G1 Z1
G1 E.8 F1800
G1 F1200
M204 S8000
G1 X172.916 Y156.266 E.02451
G1 X173.492 Y156.266 E.01852
G1 X173.548 Y156.434 E.00567
G2 X172.954 Y156.982 I1.891 J2.64 E.02605
; COOLING_NODE: 0
; WIPE_START
G1 F8843.478
G1 X172.916 Y156.266 E-.27247
G1 X173.492 Y156.266 E-.21883
G1 X173.548 Y156.434 E-.06703
G1 X173.187 Y156.732 E-.17797
G1 X173.144 Y156.778 E-.0237
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X173.256 Y159.811 Z1.4 F60000
G1 Z1
G1 E.8 F1800
G1 F1200
M204 S8000
G1 X173.091 Y159.561 E.00963
G3 X174.772 Y156.402 I1.907 J-1.013 E.13568
G1 X174.988 Y156.39 E.00695
G3 X173.322 Y159.91 I.01 J2.159 E.28012
G1 X173.289 Y159.861 E.00187
; COOLING_NODE: 0
M204 S10000
G1 X173.595 Y159.588 F60000
G1 F1200
M204 S8000
G1 X173.452 Y159.371 E.00834
G3 X174.816 Y156.807 I1.547 J-.822 E.11009
G1 X174.991 Y156.797 E.00565
G3 X173.639 Y159.653 I.008 J1.752 E.22728
G1 X173.628 Y159.637 E.00059
; COOLING_NODE: 0
M204 S250
G1 X173.921 Y159.372 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X173.799 Y159.188 E.00658
G3 X174.857 Y157.197 I1.2 J-.638 E.07915
G1 X174.994 Y157.19 E.00407
G3 X173.956 Y159.421 I.006 J1.359 E.1628
; COOLING_NODE: 0
; WIPE_START
G1 F9547.055
M204 S8000
G1 X173.799 Y159.188 E-.10668
G1 X173.693 Y158.926 E-.10729
G1 X173.645 Y158.669 E-.09939
G1 X173.647 Y158.414 E-.09683
G1 X173.699 Y158.153 E-.10121
G1 X173.799 Y157.911 E-.09946
G1 X173.954 Y157.681 E-.10557
G1 X174.035 Y157.6 E-.04358
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X176.452 Y156.435 Z1.4 F60000
G1 Z1
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X176.507 Y156.266 E.00571
G1 X177.084 Y156.266 E.01855
G1 X177.084 Y157.027 E.02447
G2 X176.501 Y156.47 I-2.476 J2.008 E.026
; COOLING_NODE: 0
; WIPE_START
G1 F8843.478
G1 X176.507 Y156.266 E-.07753
G1 X177.084 Y156.266 E-.21922
G1 X177.084 Y157.027 E-.28921
G1 X176.811 Y156.73 E-.15322
G1 X176.771 Y156.693 E-.02082
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X173.009 Y162.441 Z1.4 F60000
G1 Z1
G1 E.8 F1800
G1 F1200
M204 S8000
G1 X172.509 Y162.441 E.01608
G1 X172.509 Y155.859 E.21164
G1 X177.491 Y155.859 E.16019
G1 X177.491 Y162.441 E.21164
G1 X176.991 Y162.441 E.01608
M73 P77 R1
G1 X176.991 Y164.141 E.05467
G1 X173.009 Y164.141 E.12804
G1 X173.009 Y162.501 E.05274
; COOLING_NODE: 0
M204 S10000
G1 X172.602 Y162.848 F60000
G1 F1200
M204 S8000
G1 X172.102 Y162.848 E.01608
G1 X172.102 Y155.452 E.23782
G1 X177.898 Y155.452 E.18637
G1 X177.898 Y162.848 E.23782
G1 X177.398 Y162.848 E.01608
G1 X177.398 Y164.548 E.05467
G1 X172.602 Y164.548 E.15422
G1 X172.602 Y162.908 E.05274
; COOLING_NODE: 1
M204 S250
G1 X172.21 Y163.24 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X171.71 Y163.24 E.01489
G1 X171.71 Y155.06 E.24365
G1 X178.29 Y155.06 E.196
G1 X178.29 Y163.24 E.24365
G1 X177.79 Y163.24 E.01489
G1 X177.79 Y164.94 E.05064
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X172.21 Y164.94 E.16621
G1 X172.21 Y163.3 E.04885
; WIPE_START
G1 F9547.055
M204 S8000
G1 X171.71 Y163.24 E-.19136
G1 X171.71 Y161.744 E-.56864
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.012 Y161.51 Z1.4 F60000
G1 Z1
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.424223
G1 F1200
M204 S8000
G1 X174.445 Y161.457 E.01714
G1 X173.907 Y161.31 E.0168
; LINE_WIDTH: 0.464337
G1 X173.337 Y161.029 E.02117
G1 X173.337 Y161.613 E.01945
G1 X173.679 Y161.641 E.01145
G1 X173.733 Y161.669 E.00202
; LINE_WIDTH: 0.420842
G1 X173.808 Y161.899 E.00722
G1 X173.808 Y163.342 E.04307
G1 X176.192 Y163.342 E.07115
G1 X176.192 Y161.83 E.04512
G3 X176.303 Y161.646 I.188 J-.012 E.00685
; LINE_WIDTH: 0.467364
G1 X176.665 Y161.615 E.01218
G1 X176.665 Y161.015 E.02011
M73 P78 R1
G1 X176.3 Y161.222 E.01406
; LINE_WIDTH: 0.430018
G1 X175.688 Y161.418 E.01965
G1 X175.071 Y161.502 E.01904
M204 S10000
G1 X174.788 Y161.869 F60000
; LINE_WIDTH: 0.41999
G1 F1200
M204 S8000
G1 X174.153 Y161.767 E.01916
G1 X174.185 Y162.035 E.00804
G1 X174.185 Y162.965 E.02769
G1 X175.815 Y162.965 E.04853
G1 X175.823 Y161.776 E.03541
G1 X175.32 Y161.872 E.01524
G1 X174.848 Y161.87 E.01408
M204 S10000
G1 X174.911 Y162.248 F60000
; LINE_WIDTH: 0.398987
G1 F1200
M204 S8000
G1 X174.554 Y162.217 E.01009
G1 X174.554 Y162.596 E.01066
G2 X175.448 Y162.598 I.509 J-26.887 E.02514
G1 X175.448 Y162.224 E.01052
G1 X174.971 Y162.245 E.01342
; WIPE_START
G1 F10110.479
G1 X175.448 Y162.224 E-.1813
G1 X175.448 Y162.598 E-.14214
G1 X174.554 Y162.596 E-.33968
G1 X174.554 Y162.341 E-.09688
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.941 Y159.755 Z1.4 F60000
G1 Z1
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.104436
G1 F1200
M204 S8000
G1 X172.879 Y159.671 E.0005
; LINE_WIDTH: 0.126221
G1 X172.796 Y159.545 E.00099
; LINE_WIDTH: 0.154095
G1 X172.713 Y159.419 E.00133
M204 S10000
G1 X172.735 Y159.294 F60000
; LINE_WIDTH: 0.131153
G1 F1200
M204 S8000
G2 X172.797 Y159.631 I6.262 J-.967 E.00239
; WIPE_START
G1 F15000
G1 X172.735 Y159.294 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.735 Y157.805 Z1.4 F60000
G1 Z1
G1 E.8 F1800
; LINE_WIDTH: 0.11077
G1 F1200
M204 S8000
G1 X172.751 Y157.712 E.0005
; LINE_WIDTH: 0.13847
G1 X172.767 Y157.62 E.00071
; LINE_WIDTH: 0.158114
G3 X172.829 Y157.5 I.214 J.035 E.00125
; LINE_WIDTH: 0.128738
G1 X172.882 Y157.422 E.00064
; LINE_WIDTH: 0.105682
G1 X172.951 Y157.328 E.00058
; WIPE_START
G1 F15000
G1 X172.882 Y157.422 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X173.713 Y156.286 Z1.4 F60000
G1 Z1
G1 E.8 F1800
; LINE_WIDTH: 0.358798
G1 F1200
M204 S8000
G3 X174.144 Y156.201 I1.889 J8.529 E.01096
; LINE_WIDTH: 0.299291
G1 X174.263 Y156.18 E.00245
; LINE_WIDTH: 0.262566
G1 X174.383 Y156.165 E.00209
; LINE_WIDTH: 0.233488
G1 X174.491 Y156.151 E.00165
; LINE_WIDTH: 0.19965
G1 X174.74 Y156.131 E.00309
; LINE_WIDTH: 0.179061
G1 X175.212 Y156.129 E.00507
G1 X175.461 Y156.146 E.00269
; LINE_WIDTH: 0.224902
G1 X175.588 Y156.161 E.00183
; LINE_WIDTH: 0.25469
G1 X175.706 Y156.176 E.00199
; LINE_WIDTH: 0.288988
G1 X175.826 Y156.196 E.00236
; LINE_WIDTH: 0.327959
G1 X175.935 Y156.214 E.00249
; LINE_WIDTH: 0.3492
G1 X176.287 Y156.283 E.0087
; WIPE_START
G1 F11753.972
G1 X175.935 Y156.214 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X177.046 Y157.323 Z1.4 F60000
G1 Z1
G1 E.8 F1800
; LINE_WIDTH: 0.116538
G1 F1200
M204 S8000
G1 X177.17 Y157.498 E.00125
; LINE_WIDTH: 0.157588
G1 X177.223 Y157.576 E.00085
; LINE_WIDTH: 0.146916
G1 X177.248 Y157.709 E.00111
; LINE_WIDTH: 0.111482
G1 X177.265 Y157.804 E.00053
; WIPE_START
G1 F15000
G1 X177.248 Y157.709 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X177.265 Y159.296 Z1.4 F60000
G1 Z1
G1 E.8 F1800
; LINE_WIDTH: 0.110777
G1 F1200
M204 S8000
G1 X177.249 Y159.388 E.0005
; LINE_WIDTH: 0.1456
G1 X177.223 Y159.521 E.0011
; LINE_WIDTH: 0.156687
G1 X177.171 Y159.6 E.00085
; LINE_WIDTH: 0.116035
G1 X177.049 Y159.772 E.00122
; CHANGE_LAYER
; Z_HEIGHT: 1.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F15000
G1 X177.171 Y159.6 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 6/32
; update layer progress
M73 L6
M991 S0 P5 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z1.4 I-.662 J-1.021 P1  F60000
G1 X173.416 Y162.034 Z1.4
G1 Z1.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X172.916 Y162.034 E.01608
G1 X172.916 Y160.076 E.06296
G2 X176.045 Y160.896 I2.094 J-1.612 E.11193
G2 X177.084 Y160.062 I-1.165 J-2.514 E.04326
G1 X177.084 Y162.034 E.06341
G1 X176.584 Y162.034 E.01608
G1 X176.584 Y163.734 E.05467
G1 X173.416 Y163.734 E.10186
G1 X173.416 Y162.094 E.05274
; COOLING_NODE: 0
; WIPE_START
G1 F8843.478
G1 X172.916 Y162.034 E-.19136
G1 X172.916 Y160.537 E-.56864
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X176.453 Y156.436 Z1.6 F60000
G1 Z1.2
G1 E.8 F1800
G1 F1200
M204 S8000
G1 X176.508 Y156.266 E.00572
G1 X177.084 Y156.266 E.01853
G1 X177.084 Y157.024 E.02437
G2 X176.502 Y156.471 I-2.497 J2.044 E.02589
; COOLING_NODE: 0
; WIPE_START
G1 F8843.478
G1 X176.508 Y156.266 E-.07778
G1 X177.084 Y156.266 E-.21898
G1 X177.084 Y157.024 E-.28798
G1 X176.785 Y156.704 E-.16652
G1 X176.767 Y156.689 E-.00874
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X173.307 Y159.878 Z1.6 F60000
G1 Z1.2
G1 E.8 F1800
G1 F1200
M204 S8000
G1 X173.229 Y159.785 E.00391
G3 X174.771 Y156.402 I1.77 J-1.236 E.14404
G1 X174.974 Y156.39 E.00654
G3 X173.5 Y160.103 I.025 J2.159 E.27216
G1 X173.346 Y159.924 E.00761
; COOLING_NODE: 0
M204 S10000
G1 X173.616 Y159.615 F60000
G1 F1200
M204 S8000
G1 X173.564 Y159.553 E.00262
G3 X174.815 Y156.807 I1.435 J-1.004 E.11691
G1 X174.978 Y156.797 E.00527
G3 X173.783 Y159.81 I.021 J1.752 E.22083
G1 X173.655 Y159.661 E.00633
; COOLING_NODE: 0
M204 S250
G1 X173.913 Y159.362 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X173.886 Y159.329 E.00127
G3 X174.857 Y157.197 I1.113 J-.78 E.0841
G1 X174.983 Y157.19 E.00375
G3 X174.056 Y159.528 I.017 J1.359 E.15876
G1 X173.952 Y159.407 E.00473
; COOLING_NODE: 0
; WIPE_START
G1 F9547.055
M204 S8000
G1 X173.886 Y159.329 E-.03901
G1 X173.755 Y159.097 E-.10117
G1 X173.67 Y158.833 E-.10545
G1 X173.64 Y158.575 E-.09883
G1 X173.66 Y158.315 E-.09912
G1 X173.73 Y158.063 E-.09919
G1 X173.846 Y157.829 E-.0994
G1 X174.022 Y157.605 E-.10806
G1 X174.04 Y157.587 E-.00977
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.916 Y157.038 Z1.6 F60000
G1 Z1.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
M73 P79 R1
G1 X172.916 Y156.266 E.02482
G1 X173.491 Y156.266 E.01848
G1 X173.547 Y156.432 E.00563
G2 X172.954 Y156.991 I1.812 J2.518 E.02629
; COOLING_NODE: 0
; WIPE_START
G1 F8843.478
G1 X172.916 Y156.266 E-.27587
G1 X173.491 Y156.266 E-.21839
G1 X173.547 Y156.432 E-.06658
G1 X173.346 Y156.586 E-.09629
G1 X173.153 Y156.766 E-.10026
G1 X173.148 Y156.771 E-.00259
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X173.009 Y162.441 Z1.6 F60000
G1 Z1.2
G1 E.8 F1800
G1 F1200
M204 S8000
G1 X172.509 Y162.441 E.01608
G1 X172.509 Y155.859 E.21164
G1 X177.491 Y155.859 E.16019
G1 X177.491 Y162.441 E.21164
G1 X176.991 Y162.441 E.01608
G1 X176.991 Y164.141 E.05467
G1 X173.009 Y164.141 E.12804
G1 X173.009 Y162.501 E.05274
; COOLING_NODE: 0
M204 S10000
G1 X172.602 Y162.848 F60000
G1 F1200
M204 S8000
G1 X172.102 Y162.848 E.01608
G1 X172.102 Y155.452 E.23782
G1 X177.898 Y155.452 E.18637
G1 X177.898 Y162.848 E.23782
G1 X177.398 Y162.848 E.01608
G1 X177.398 Y164.548 E.05467
G1 X172.602 Y164.548 E.15422
G1 X172.602 Y162.908 E.05274
; COOLING_NODE: 1
M204 S250
G1 X172.21 Y163.24 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X171.71 Y163.24 E.01489
G1 X171.71 Y155.06 E.24365
G1 X178.29 Y155.06 E.196
G1 X178.29 Y163.24 E.24365
G1 X177.79 Y163.24 E.01489
G1 X177.79 Y164.94 E.05064
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X172.21 Y164.94 E.16621
G1 X172.21 Y163.3 E.04885
; WIPE_START
G1 F9547.055
M204 S8000
G1 X171.71 Y163.24 E-.19136
G1 X171.71 Y161.744 E-.56864
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X174.748 Y162.235 Z1.6 F60000
M73 P80 R1
G1 Z1.2
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.40063
G1 F1200
M204 S8000
G1 X174.554 Y162.221 E.0055
G1 X174.554 Y162.596 E.0106
G2 X175.448 Y162.598 I.514 J-28.444 E.02525
G1 X175.448 Y162.225 E.01053
G1 X174.808 Y162.235 E.01807
M204 S10000
G1 X175.231 Y161.876 F60000
; LINE_WIDTH: 0.41999
G1 F1200
M204 S8000
G1 X174.48 Y161.845 E.02242
G1 X174.18 Y161.782 E.00912
G3 X174.185 Y162.965 I-69.333 J.908 E.03522
G1 X175.815 Y162.965 E.04853
G1 X175.827 Y161.772 E.03552
G1 X175.291 Y161.865 E.01622
M204 S10000
G1 X174.806 Y161.492 F60000
; LINE_WIDTH: 0.429188
G1 F1200
M204 S8000
G1 X174.195 Y161.399 E.01885
G1 X173.695 Y161.225 E.01615
; LINE_WIDTH: 0.461307
G1 X173.334 Y160.995 E.01415
G1 X173.334 Y161.616 E.02053
G1 X173.692 Y161.644 E.01189
G1 X173.804 Y161.788 E.00602
; LINE_WIDTH: 0.421196
G3 X173.808 Y163.342 I-126.166 J1.09 E.04642
G1 X176.192 Y163.342 E.07122
G1 X176.192 Y161.83 E.04516
G1 X176.22 Y161.715 E.00354
G1 X176.38 Y161.621 E.00555
; LINE_WIDTH: 0.46822
G1 X176.664 Y161.614 E.00953
G1 X176.664 Y161.019 E.02
G1 X176.359 Y161.199 E.0119
G1 X175.898 Y161.376 E.01658
; LINE_WIDTH: 0.422595
G1 X175.382 Y161.485 E.01584
G1 X174.866 Y161.491 E.01548
; WIPE_START
G1 F9481.8
G1 X175.382 Y161.485 E-.37561
G1 X175.898 Y161.376 E-.38439
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.963 Y159.792 Z1.6 F60000
G1 Z1.2
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.103655
G1 F1200
M204 S8000
G1 X172.903 Y159.714 E.00047
; LINE_WIDTH: 0.126629
G1 X172.841 Y159.624 E.00073
; LINE_WIDTH: 0.15971
G3 X172.776 Y159.522 I.093 J-.131 E.00114
; LINE_WIDTH: 0.151325
G1 X172.755 Y159.41 E.00097
; LINE_WIDTH: 0.115054
G1 X172.735 Y159.299 E.00065
; WIPE_START
G1 F15000
G1 X172.755 Y159.41 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.79 Y157.494 Z1.6 F60000
G1 Z1.2
G1 E.8 F1800
; LINE_WIDTH: 0.119199
G1 F1200
M204 S8000
G2 X172.735 Y157.805 I6.474 J1.289 E.0019
M204 S10000
G1 X172.713 Y157.698 F60000
; LINE_WIDTH: 0.1408
G1 F1200
M204 S8000
G1 X172.841 Y157.494 E.00187
; LINE_WIDTH: 0.108739
G1 X172.922 Y157.379 E.00073
; WIPE_START
G1 F15000
G1 X172.841 Y157.494 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X173.713 Y156.286 Z1.6 F60000
G1 Z1.2
G1 E.8 F1800
; LINE_WIDTH: 0.36259
G1 F1200
M204 S8000
G3 X174.128 Y156.204 I1.877 J8.381 E.0107
; LINE_WIDTH: 0.305506
G1 X174.24 Y156.184 E.00235
; LINE_WIDTH: 0.268103
G1 X174.369 Y156.167 E.00232
; LINE_WIDTH: 0.235807
G1 X174.487 Y156.151 E.00181
; LINE_WIDTH: 0.200131
G1 X174.738 Y156.131 E.00314
; LINE_WIDTH: 0.178891
G1 X175.21 Y156.129 E.00507
G1 X175.457 Y156.146 E.00266
; LINE_WIDTH: 0.222852
G1 X175.574 Y156.16 E.00167
; LINE_WIDTH: 0.249516
G1 X175.683 Y156.172 E.00179
; LINE_WIDTH: 0.283426
G1 X175.811 Y156.194 E.00248
; LINE_WIDTH: 0.32469
G1 X175.929 Y156.213 E.00266
; LINE_WIDTH: 0.347244
G1 X176.288 Y156.282 E.00879
; WIPE_START
G1 F11829.497
G1 X175.929 Y156.213 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X177.037 Y157.308 Z1.6 F60000
G1 Z1.2
G1 E.8 F1800
; LINE_WIDTH: 0.115763
G1 F1200
M204 S8000
G1 X177.159 Y157.476 E.00119
; LINE_WIDTH: 0.158459
G1 X177.222 Y157.567 E.00101
; LINE_WIDTH: 0.153269
G1 X177.245 Y157.689 E.00109
; LINE_WIDTH: 0.115079
G1 X177.265 Y157.801 E.00065
; WIPE_START
G1 F15000
G1 X177.245 Y157.689 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X177.21 Y159.606 Z1.6 F60000
G1 Z1.2
G1 E.8 F1800
; LINE_WIDTH: 0.120457
G1 F1200
M204 S8000
G2 X177.265 Y159.295 I-5.661 J-1.158 E.00194
M204 S10000
G1 X177.287 Y159.402 F60000
; LINE_WIDTH: 0.136201
G1 F1200
M204 S8000
G1 X177.138 Y159.637 E.00205
; LINE_WIDTH: 0.104112
G1 X177.08 Y159.719 E.00048
; CHANGE_LAYER
; Z_HEIGHT: 1.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F15000
G1 X177.138 Y159.637 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 7/32
; update layer progress
M73 L7
M991 S0 P6 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z1.6 I-.158 J-1.207 P1  F60000
G1 X173.014 Y160.177 Z1.6
G1 Z1.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X173.184 Y160.366 E.00816
G2 X177.084 Y160.072 I1.821 J-1.853 E.14238
G1 X177.084 Y162.034 E.0631
G1 X176.584 Y162.034 E.01608
G1 X176.584 Y163.734 E.05467
G1 X173.416 Y163.734 E.10186
G1 X173.416 Y162.034 E.05467
G1 X172.916 Y162.034 E.01608
G1 X172.916 Y160.068 E.0632
G1 X172.974 Y160.133 E.00278
; COOLING_NODE: 0
; WIPE_START
G1 F8843.478
G1 X173.184 Y160.366 E-.11918
G1 X173.383 Y160.545 E-.10205
G1 X173.601 Y160.704 E-.10238
G1 X174.04 Y160.931 E-.18776
G1 X174.507 Y161.07 E-.18533
G1 X174.672 Y161.094 E-.0633
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.916 Y157.028 Z1.8 F60000
G1 Z1.4
G1 E.8 F1800
G1 F1200
M204 S8000
G1 X172.916 Y156.266 E.02451
G1 X173.492 Y156.266 E.01852
G1 X173.548 Y156.434 E.00567
G2 X172.954 Y156.982 I1.891 J2.64 E.02605
; COOLING_NODE: 0
; WIPE_START
G1 F8843.478
G1 X172.916 Y156.266 E-.27247
G1 X173.492 Y156.266 E-.21883
G1 X173.548 Y156.434 E-.06703
G1 X173.187 Y156.732 E-.17797
G1 X173.144 Y156.778 E-.0237
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X173.252 Y159.805 Z1.8 F60000
G1 Z1.4
G1 E.8 F1800
G1 F1200
M204 S8000
G1 X173.091 Y159.561 E.00939
G3 X174.772 Y156.402 I1.907 J-1.013 E.13568
G1 X174.988 Y156.39 E.00695
G3 X173.322 Y159.91 I.01 J2.159 E.28012
G1 X173.285 Y159.855 E.00211
; COOLING_NODE: 0
M204 S10000
G1 X173.591 Y159.582 F60000
G1 F1200
M204 S8000
G1 X173.452 Y159.371 E.00811
G3 X174.816 Y156.807 I1.547 J-.822 E.11009
G1 X174.991 Y156.797 E.00565
G3 X173.639 Y159.653 I.008 J1.752 E.22728
G1 X173.624 Y159.631 E.00083
; COOLING_NODE: 0
M204 S250
G1 X173.916 Y159.366 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X173.799 Y159.188 E.00636
G3 X174.857 Y157.197 I1.2 J-.638 E.07915
M73 P81 R1
G1 X174.994 Y157.19 E.00407
G3 X173.951 Y159.415 I.006 J1.359 E.16302
; COOLING_NODE: 0
; WIPE_START
G1 F9547.055
M204 S8000
G1 X173.799 Y159.188 E-.10392
G1 X173.693 Y158.926 E-.10729
G1 X173.645 Y158.669 E-.09939
G1 X173.647 Y158.414 E-.09683
G1 X173.699 Y158.153 E-.10121
G1 X173.799 Y157.911 E-.09946
G1 X173.954 Y157.681 E-.10557
G1 X174.041 Y157.595 E-.04634
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X176.452 Y156.435 Z1.8 F60000
G1 Z1.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X176.507 Y156.266 E.00571
G1 X177.084 Y156.266 E.01855
G1 X177.084 Y157.027 E.02447
G2 X176.501 Y156.47 I-2.476 J2.008 E.026
; COOLING_NODE: 0
; WIPE_START
G1 F8843.478
G1 X176.507 Y156.266 E-.07753
G1 X177.084 Y156.266 E-.21922
G1 X177.084 Y157.027 E-.28921
G1 X176.811 Y156.73 E-.15322
G1 X176.771 Y156.693 E-.02082
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X173.009 Y162.441 Z1.8 F60000
G1 Z1.4
G1 E.8 F1800
G1 F1200
M204 S8000
G1 X172.509 Y162.441 E.01608
G1 X172.509 Y155.859 E.21164
G1 X177.491 Y155.859 E.16019
G1 X177.491 Y162.441 E.21164
G1 X176.991 Y162.441 E.01608
G1 X176.991 Y164.141 E.05467
G1 X173.009 Y164.141 E.12804
G1 X173.009 Y162.501 E.05274
; COOLING_NODE: 0
M204 S10000
G1 X172.602 Y162.848 F60000
G1 F1200
M204 S8000
G1 X172.102 Y162.848 E.01608
G1 X172.102 Y155.452 E.23782
G1 X177.898 Y155.452 E.18637
G1 X177.898 Y162.848 E.23782
G1 X177.398 Y162.848 E.01608
G1 X177.398 Y164.548 E.05467
G1 X172.602 Y164.548 E.15422
G1 X172.602 Y162.908 E.05274
; COOLING_NODE: 1
M204 S250
G1 X172.21 Y163.24 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X171.71 Y163.24 E.01489
G1 X171.71 Y155.06 E.24365
G1 X178.29 Y155.06 E.196
G1 X178.29 Y163.24 E.24365
G1 X177.79 Y163.24 E.01489
G1 X177.79 Y164.94 E.05064
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X172.21 Y164.94 E.16621
M73 P82 R1
G1 X172.21 Y163.3 E.04885
; WIPE_START
G1 F9547.055
M204 S8000
G1 X171.71 Y163.24 E-.19136
G1 X171.71 Y161.744 E-.56864
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.012 Y161.51 Z1.8 F60000
G1 Z1.4
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.424223
G1 F1200
M204 S8000
G1 X174.445 Y161.457 E.01714
G1 X173.907 Y161.31 E.0168
; LINE_WIDTH: 0.464337
G1 X173.337 Y161.029 E.02117
G1 X173.337 Y161.613 E.01945
G1 X173.679 Y161.641 E.01145
G1 X173.733 Y161.669 E.00202
; LINE_WIDTH: 0.420842
G1 X173.808 Y161.899 E.00722
G1 X173.808 Y163.342 E.04307
G1 X176.192 Y163.342 E.07115
G1 X176.192 Y161.83 E.04512
G3 X176.303 Y161.646 I.188 J-.012 E.00685
; LINE_WIDTH: 0.467364
G1 X176.665 Y161.615 E.01218
G1 X176.665 Y161.015 E.02011
G1 X176.3 Y161.222 E.01406
; LINE_WIDTH: 0.430018
G1 X175.688 Y161.418 E.01965
G1 X175.071 Y161.502 E.01904
M204 S10000
G1 X174.788 Y161.869 F60000
; LINE_WIDTH: 0.41999
G1 F1200
M204 S8000
G1 X174.153 Y161.767 E.01916
G1 X174.185 Y162.035 E.00804
G1 X174.185 Y162.965 E.02769
G1 X175.815 Y162.965 E.04853
G1 X175.823 Y161.776 E.03541
G1 X175.32 Y161.872 E.01524
G1 X174.848 Y161.87 E.01408
M204 S10000
G1 X174.911 Y162.248 F60000
; LINE_WIDTH: 0.398987
G1 F1200
M204 S8000
G1 X174.554 Y162.217 E.01009
G1 X174.554 Y162.596 E.01066
G2 X175.448 Y162.598 I.509 J-26.887 E.02514
G1 X175.448 Y162.224 E.01052
G1 X174.971 Y162.245 E.01342
; WIPE_START
G1 F10110.479
G1 X175.448 Y162.224 E-.1813
G1 X175.448 Y162.598 E-.14214
G1 X174.554 Y162.596 E-.33968
G1 X174.554 Y162.341 E-.09688
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.941 Y159.755 Z1.8 F60000
G1 Z1.4
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.104436
G1 F1200
M204 S8000
G1 X172.879 Y159.671 E.0005
; LINE_WIDTH: 0.126221
G1 X172.796 Y159.545 E.00099
; LINE_WIDTH: 0.154095
G1 X172.713 Y159.419 E.00133
M204 S10000
G1 X172.735 Y159.294 F60000
; LINE_WIDTH: 0.131153
G1 F1200
M204 S8000
G2 X172.797 Y159.631 I6.262 J-.967 E.00239
; WIPE_START
G1 F15000
G1 X172.735 Y159.294 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.735 Y157.805 Z1.8 F60000
G1 Z1.4
G1 E.8 F1800
; LINE_WIDTH: 0.11077
G1 F1200
M204 S8000
G1 X172.751 Y157.712 E.0005
; LINE_WIDTH: 0.13847
G1 X172.767 Y157.62 E.00071
; LINE_WIDTH: 0.158114
G3 X172.829 Y157.5 I.214 J.035 E.00125
; LINE_WIDTH: 0.128738
G1 X172.882 Y157.422 E.00064
; LINE_WIDTH: 0.105682
G1 X172.951 Y157.328 E.00058
; WIPE_START
G1 F15000
G1 X172.882 Y157.422 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X173.713 Y156.286 Z1.8 F60000
G1 Z1.4
G1 E.8 F1800
; LINE_WIDTH: 0.358798
G1 F1200
M204 S8000
G3 X174.144 Y156.201 I1.889 J8.529 E.01096
; LINE_WIDTH: 0.299291
G1 X174.263 Y156.18 E.00245
; LINE_WIDTH: 0.262566
G1 X174.383 Y156.165 E.00209
; LINE_WIDTH: 0.233488
G1 X174.491 Y156.151 E.00165
; LINE_WIDTH: 0.19965
G1 X174.74 Y156.131 E.00309
; LINE_WIDTH: 0.179061
G1 X175.212 Y156.129 E.00507
G1 X175.461 Y156.146 E.00269
; LINE_WIDTH: 0.224902
G1 X175.588 Y156.161 E.00183
; LINE_WIDTH: 0.25469
G1 X175.706 Y156.176 E.00199
; LINE_WIDTH: 0.288988
G1 X175.826 Y156.196 E.00236
; LINE_WIDTH: 0.327959
G1 X175.935 Y156.214 E.00249
; LINE_WIDTH: 0.3492
G1 X176.287 Y156.283 E.0087
; WIPE_START
G1 F11753.972
G1 X175.935 Y156.214 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X177.046 Y157.323 Z1.8 F60000
G1 Z1.4
G1 E.8 F1800
; LINE_WIDTH: 0.116538
G1 F1200
M204 S8000
G1 X177.17 Y157.498 E.00125
; LINE_WIDTH: 0.157588
G1 X177.223 Y157.576 E.00085
; LINE_WIDTH: 0.146916
G1 X177.248 Y157.709 E.00111
; LINE_WIDTH: 0.111482
G1 X177.265 Y157.804 E.00053
; WIPE_START
G1 F15000
G1 X177.248 Y157.709 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X177.265 Y159.296 Z1.8 F60000
G1 Z1.4
G1 E.8 F1800
; LINE_WIDTH: 0.110777
G1 F1200
M204 S8000
G1 X177.249 Y159.388 E.0005
; LINE_WIDTH: 0.1456
G1 X177.223 Y159.521 E.0011
; LINE_WIDTH: 0.156687
G1 X177.171 Y159.6 E.00085
; LINE_WIDTH: 0.116035
G1 X177.049 Y159.772 E.00122
; CHANGE_LAYER
; Z_HEIGHT: 1.6
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F15000
G1 X177.171 Y159.6 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 8/32
; update layer progress
M73 L8
M991 S0 P7 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z1.8 I-.662 J-1.021 P1  F60000
G1 X173.416 Y162.034 Z1.8
G1 Z1.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X172.916 Y162.034 E.01608
G1 X172.916 Y160.076 E.06296
G2 X176.045 Y160.896 I2.094 J-1.612 E.11193
G2 X177.084 Y160.062 I-1.165 J-2.514 E.04326
G1 X177.084 Y162.034 E.06341
G1 X176.584 Y162.034 E.01608
G1 X176.584 Y163.734 E.05467
G1 X173.416 Y163.734 E.10186
G1 X173.416 Y162.094 E.05274
; COOLING_NODE: 0
; WIPE_START
G1 F8843.478
G1 X172.916 Y162.034 E-.19136
G1 X172.916 Y160.537 E-.56864
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X176.453 Y156.436 Z2 F60000
G1 Z1.6
G1 E.8 F1800
G1 F1200
M204 S8000
G1 X176.508 Y156.266 E.00572
G1 X177.084 Y156.266 E.01853
G1 X177.084 Y157.024 E.02437
G2 X176.502 Y156.471 I-2.497 J2.044 E.02589
; COOLING_NODE: 0
; WIPE_START
G1 F8843.478
G1 X176.508 Y156.266 E-.07778
G1 X177.084 Y156.266 E-.21898
G1 X177.084 Y157.024 E-.28798
G1 X176.785 Y156.704 E-.16652
G1 X176.767 Y156.689 E-.00874
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X173.304 Y159.875 Z2 F60000
G1 Z1.6
G1 E.8 F1800
G1 F1200
M204 S8000
G1 X173.229 Y159.785 E.00376
G3 X174.771 Y156.402 I1.77 J-1.236 E.14404
G1 X174.974 Y156.39 E.00654
G3 X173.5 Y160.103 I.025 J2.159 E.27216
G1 X173.343 Y159.92 E.00776
; COOLING_NODE: 0
M204 S10000
G1 X173.613 Y159.612 F60000
G1 F1200
M204 S8000
G1 X173.564 Y159.553 E.00247
G3 X174.815 Y156.807 I1.435 J-1.004 E.11691
G1 X174.978 Y156.797 E.00527
G3 X173.783 Y159.81 I.021 J1.752 E.22083
G1 X173.652 Y159.657 E.00648
; COOLING_NODE: 0
M204 S250
M73 P83 R1
G1 X173.91 Y159.358 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X173.886 Y159.329 E.00113
G3 X174.857 Y157.197 I1.113 J-.78 E.0841
G1 X174.983 Y157.19 E.00375
G3 X174.056 Y159.528 I.017 J1.359 E.15876
G1 X173.949 Y159.404 E.00487
; COOLING_NODE: 0
; WIPE_START
G1 F9547.055
M204 S8000
G1 X173.886 Y159.329 E-.0372
G1 X173.755 Y159.097 E-.10117
G1 X173.67 Y158.833 E-.10545
G1 X173.64 Y158.575 E-.09883
G1 X173.66 Y158.315 E-.09912
G1 X173.73 Y158.063 E-.09919
G1 X173.846 Y157.829 E-.0994
G1 X174.022 Y157.605 E-.10806
G1 X174.044 Y157.584 E-.01158
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.916 Y157.038 Z2 F60000
G1 Z1.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X172.916 Y156.266 E.02482
G1 X173.491 Y156.266 E.01848
G1 X173.547 Y156.432 E.00563
G2 X172.954 Y156.991 I1.812 J2.518 E.02629
; COOLING_NODE: 0
; WIPE_START
G1 F8843.478
G1 X172.916 Y156.266 E-.27587
G1 X173.491 Y156.266 E-.21839
G1 X173.547 Y156.432 E-.06658
G1 X173.346 Y156.586 E-.09629
G1 X173.153 Y156.766 E-.10026
G1 X173.148 Y156.771 E-.00259
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X173.009 Y162.441 Z2 F60000
G1 Z1.6
G1 E.8 F1800
G1 F1200
M204 S8000
G1 X172.509 Y162.441 E.01608
G1 X172.509 Y155.859 E.21164
G1 X177.491 Y155.859 E.16019
G1 X177.491 Y162.441 E.21164
G1 X176.991 Y162.441 E.01608
G1 X176.991 Y164.141 E.05467
G1 X173.009 Y164.141 E.12804
G1 X173.009 Y162.501 E.05274
; COOLING_NODE: 0
M204 S10000
G1 X172.602 Y162.848 F60000
G1 F1200
M204 S8000
G1 X172.102 Y162.848 E.01608
G1 X172.102 Y155.452 E.23782
G1 X177.898 Y155.452 E.18637
G1 X177.898 Y162.848 E.23782
G1 X177.398 Y162.848 E.01608
G1 X177.398 Y164.548 E.05467
G1 X172.602 Y164.548 E.15422
G1 X172.602 Y162.908 E.05274
; COOLING_NODE: 1
M204 S250
G1 X172.21 Y163.24 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X171.71 Y163.24 E.01489
G1 X171.71 Y155.06 E.24365
G1 X178.29 Y155.06 E.196
G1 X178.29 Y163.24 E.24365
G1 X177.79 Y163.24 E.01489
G1 X177.79 Y164.94 E.05064
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

M73 P84 R1
G1 X172.21 Y164.94 E.16621
G1 X172.21 Y163.3 E.04885
; WIPE_START
G1 F9547.055
M204 S8000
G1 X171.71 Y163.24 E-.19136
G1 X171.71 Y161.744 E-.56864
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X174.748 Y162.235 Z2 F60000
G1 Z1.6
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.40063
G1 F1200
M204 S8000
G1 X174.554 Y162.221 E.0055
G1 X174.554 Y162.596 E.0106
G2 X175.448 Y162.598 I.514 J-28.444 E.02525
G1 X175.448 Y162.225 E.01053
G1 X174.808 Y162.235 E.01807
M204 S10000
G1 X175.231 Y161.876 F60000
; LINE_WIDTH: 0.41999
G1 F1200
M204 S8000
G1 X174.48 Y161.845 E.02242
G1 X174.18 Y161.782 E.00912
G3 X174.185 Y162.965 I-69.333 J.908 E.03522
G1 X175.815 Y162.965 E.04853
G1 X175.827 Y161.772 E.03552
G1 X175.291 Y161.865 E.01622
M204 S10000
G1 X174.806 Y161.492 F60000
; LINE_WIDTH: 0.429188
G1 F1200
M204 S8000
G1 X174.195 Y161.399 E.01885
G1 X173.695 Y161.225 E.01615
; LINE_WIDTH: 0.461307
G1 X173.334 Y160.995 E.01415
G1 X173.334 Y161.616 E.02053
G1 X173.692 Y161.644 E.01189
G1 X173.804 Y161.788 E.00602
; LINE_WIDTH: 0.421196
G3 X173.808 Y163.342 I-126.166 J1.09 E.04642
G1 X176.192 Y163.342 E.07122
G1 X176.192 Y161.83 E.04516
G1 X176.22 Y161.715 E.00354
G1 X176.38 Y161.621 E.00555
; LINE_WIDTH: 0.46822
G1 X176.664 Y161.614 E.00953
G1 X176.664 Y161.019 E.02
G1 X176.359 Y161.199 E.0119
G1 X175.898 Y161.376 E.01658
; LINE_WIDTH: 0.422595
G1 X175.382 Y161.485 E.01584
G1 X174.866 Y161.491 E.01548
; WIPE_START
G1 F9481.8
G1 X175.382 Y161.485 E-.37561
G1 X175.898 Y161.376 E-.38439
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.963 Y159.792 Z2 F60000
G1 Z1.6
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.103655
G1 F1200
M204 S8000
G1 X172.903 Y159.714 E.00047
; LINE_WIDTH: 0.126629
G1 X172.841 Y159.624 E.00073
; LINE_WIDTH: 0.15971
G3 X172.776 Y159.522 I.093 J-.131 E.00114
; LINE_WIDTH: 0.151325
G1 X172.755 Y159.41 E.00097
; LINE_WIDTH: 0.115054
G1 X172.735 Y159.299 E.00065
; WIPE_START
G1 F15000
G1 X172.755 Y159.41 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.79 Y157.494 Z2 F60000
G1 Z1.6
G1 E.8 F1800
; LINE_WIDTH: 0.119199
G1 F1200
M204 S8000
G2 X172.735 Y157.805 I6.474 J1.289 E.0019
M204 S10000
G1 X172.713 Y157.698 F60000
; LINE_WIDTH: 0.1408
G1 F1200
M204 S8000
G1 X172.841 Y157.494 E.00187
; LINE_WIDTH: 0.108739
G1 X172.922 Y157.379 E.00073
; WIPE_START
G1 F15000
G1 X172.841 Y157.494 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X173.713 Y156.286 Z2 F60000
G1 Z1.6
G1 E.8 F1800
; LINE_WIDTH: 0.36259
G1 F1200
M204 S8000
G3 X174.128 Y156.204 I1.877 J8.381 E.0107
; LINE_WIDTH: 0.305506
G1 X174.24 Y156.184 E.00235
; LINE_WIDTH: 0.268103
G1 X174.369 Y156.167 E.00232
; LINE_WIDTH: 0.235807
G1 X174.487 Y156.151 E.00181
; LINE_WIDTH: 0.200131
G1 X174.738 Y156.131 E.00314
; LINE_WIDTH: 0.178891
G1 X175.21 Y156.129 E.00507
G1 X175.457 Y156.146 E.00266
; LINE_WIDTH: 0.222852
G1 X175.574 Y156.16 E.00167
; LINE_WIDTH: 0.249516
G1 X175.683 Y156.172 E.00179
; LINE_WIDTH: 0.283426
G1 X175.811 Y156.194 E.00248
; LINE_WIDTH: 0.32469
G1 X175.929 Y156.213 E.00266
; LINE_WIDTH: 0.347244
G1 X176.288 Y156.282 E.00879
; WIPE_START
G1 F11829.497
G1 X175.929 Y156.213 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X177.037 Y157.308 Z2 F60000
G1 Z1.6
G1 E.8 F1800
; LINE_WIDTH: 0.115763
G1 F1200
M204 S8000
G1 X177.159 Y157.476 E.00119
; LINE_WIDTH: 0.158459
G1 X177.222 Y157.567 E.00101
; LINE_WIDTH: 0.153269
G1 X177.245 Y157.689 E.00109
; LINE_WIDTH: 0.115079
G1 X177.265 Y157.801 E.00065
; WIPE_START
G1 F15000
G1 X177.245 Y157.689 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X177.21 Y159.606 Z2 F60000
G1 Z1.6
G1 E.8 F1800
; LINE_WIDTH: 0.120457
G1 F1200
M204 S8000
G2 X177.265 Y159.295 I-5.661 J-1.158 E.00194
M204 S10000
G1 X177.287 Y159.402 F60000
; LINE_WIDTH: 0.136201
G1 F1200
M204 S8000
G1 X177.138 Y159.637 E.00205
; LINE_WIDTH: 0.104112
G1 X177.08 Y159.719 E.00048
; CHANGE_LAYER
; Z_HEIGHT: 1.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F15000
G1 X177.138 Y159.637 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 9/32
; update layer progress
M73 L9
M991 S0 P8 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z2 I-.157 J-1.207 P1  F60000
G1 X173.011 Y160.174 Z2
G1 Z1.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X173.184 Y160.366 E.00828
G2 X177.084 Y160.072 I1.821 J-1.853 E.14238
G1 X177.084 Y162.034 E.0631
G1 X176.584 Y162.034 E.01608
G1 X176.584 Y163.734 E.05467
G1 X173.416 Y163.734 E.10186
G1 X173.416 Y162.034 E.05467
G1 X172.916 Y162.034 E.01608
G1 X172.916 Y160.068 E.0632
G1 X172.971 Y160.13 E.00265
; COOLING_NODE: 0
; WIPE_START
G1 F8843.478
G1 X173.184 Y160.366 E-.12067
G1 X173.383 Y160.545 E-.10205
G1 X173.601 Y160.704 E-.10238
G1 X174.04 Y160.931 E-.18776
G1 X174.507 Y161.07 E-.18533
G1 X174.668 Y161.094 E-.0618
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.916 Y157.028 Z2.2 F60000
G1 Z1.8
G1 E.8 F1800
G1 F1200
M204 S8000
G1 X172.916 Y156.266 E.02451
G1 X173.492 Y156.266 E.01852
G1 X173.548 Y156.434 E.00567
G2 X172.954 Y156.982 I1.891 J2.64 E.02605
; COOLING_NODE: 0
; WIPE_START
G1 F8843.478
G1 X172.916 Y156.266 E-.27247
G1 X173.492 Y156.266 E-.21883
G1 X173.548 Y156.434 E-.06703
G1 X173.187 Y156.732 E-.17797
G1 X173.144 Y156.778 E-.0237
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X173.248 Y159.8 Z2.2 F60000
G1 Z1.8
G1 E.8 F1800
G1 F1200
M204 S8000
G1 X173.091 Y159.561 E.00918
G3 X174.772 Y156.402 I1.907 J-1.013 E.13568
G1 X174.988 Y156.39 E.00695
G3 X173.322 Y159.91 I.01 J2.159 E.28012
G1 X173.282 Y159.849 E.00232
; COOLING_NODE: 0
M204 S10000
M73 P85 R1
G1 X173.587 Y159.576 F60000
G1 F1200
M204 S8000
G1 X173.452 Y159.371 E.0079
G3 X174.816 Y156.807 I1.547 J-.822 E.11009
G1 X174.991 Y156.797 E.00565
G3 X173.639 Y159.653 I.008 J1.752 E.22728
G1 X173.62 Y159.626 E.00104
; COOLING_NODE: 0
M204 S250
G1 X173.913 Y159.361 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X173.799 Y159.188 E.00616
G3 X174.857 Y157.197 I1.2 J-.638 E.07915
G1 X174.994 Y157.19 E.00407
G3 X173.947 Y159.41 I.006 J1.359 E.16321
; COOLING_NODE: 0
; WIPE_START
G1 F9547.055
M204 S8000
G1 X173.799 Y159.188 E-.10143
G1 X173.693 Y158.926 E-.10729
G1 X173.645 Y158.669 E-.09939
G1 X173.647 Y158.414 E-.09683
G1 X173.699 Y158.153 E-.10121
G1 X173.799 Y157.911 E-.09946
G1 X173.954 Y157.681 E-.10557
G1 X174.045 Y157.59 E-.04883
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X176.452 Y156.435 Z2.2 F60000
G1 Z1.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X176.507 Y156.266 E.00571
G1 X177.084 Y156.266 E.01855
G1 X177.084 Y157.027 E.02447
G2 X176.501 Y156.47 I-2.476 J2.008 E.026
; COOLING_NODE: 0
; WIPE_START
G1 F8843.478
G1 X176.507 Y156.266 E-.07753
G1 X177.084 Y156.266 E-.21922
G1 X177.084 Y157.027 E-.28921
G1 X176.811 Y156.73 E-.15322
G1 X176.771 Y156.693 E-.02082
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X173.009 Y162.441 Z2.2 F60000
G1 Z1.8
G1 E.8 F1800
G1 F1200
M204 S8000
G1 X172.509 Y162.441 E.01608
G1 X172.509 Y155.859 E.21164
G1 X177.491 Y155.859 E.16019
G1 X177.491 Y162.441 E.21164
G1 X176.991 Y162.441 E.01608
G1 X176.991 Y164.141 E.05467
G1 X173.009 Y164.141 E.12804
G1 X173.009 Y162.501 E.05274
; COOLING_NODE: 0
M204 S10000
G1 X172.602 Y162.848 F60000
G1 F1200
M204 S8000
G1 X172.102 Y162.848 E.01608
G1 X172.102 Y155.452 E.23782
G1 X177.898 Y155.452 E.18637
G1 X177.898 Y162.848 E.23782
G1 X177.398 Y162.848 E.01608
G1 X177.398 Y164.548 E.05467
G1 X172.602 Y164.548 E.15422
G1 X172.602 Y162.908 E.05274
; COOLING_NODE: 1
M204 S250
G1 X172.21 Y163.24 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X171.71 Y163.24 E.01489
G1 X171.71 Y155.06 E.24365
G1 X178.29 Y155.06 E.196
G1 X178.29 Y163.24 E.24365
G1 X177.79 Y163.24 E.01489
M73 P86 R1
G1 X177.79 Y164.94 E.05064
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X172.21 Y164.94 E.16621
G1 X172.21 Y163.3 E.04885
; WIPE_START
G1 F9547.055
M204 S8000
G1 X171.71 Y163.24 E-.19136
G1 X171.71 Y161.744 E-.56864
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.012 Y161.51 Z2.2 F60000
G1 Z1.8
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.424223
G1 F1200
M204 S8000
G1 X174.445 Y161.457 E.01714
G1 X173.907 Y161.31 E.0168
; LINE_WIDTH: 0.464337
G1 X173.337 Y161.029 E.02117
G1 X173.337 Y161.613 E.01945
G1 X173.679 Y161.641 E.01145
G1 X173.733 Y161.669 E.00202
; LINE_WIDTH: 0.420842
G1 X173.808 Y161.899 E.00722
G1 X173.808 Y163.342 E.04307
G1 X176.192 Y163.342 E.07115
G1 X176.192 Y161.83 E.04512
G3 X176.303 Y161.646 I.188 J-.012 E.00685
; LINE_WIDTH: 0.467364
G1 X176.665 Y161.615 E.01218
G1 X176.665 Y161.015 E.02011
G1 X176.3 Y161.222 E.01406
; LINE_WIDTH: 0.430018
G1 X175.688 Y161.418 E.01965
G1 X175.071 Y161.502 E.01904
M204 S10000
G1 X174.788 Y161.869 F60000
; LINE_WIDTH: 0.41999
G1 F1200
M204 S8000
G1 X174.153 Y161.767 E.01916
G1 X174.185 Y162.035 E.00804
G1 X174.185 Y162.965 E.02769
G1 X175.815 Y162.965 E.04853
G1 X175.823 Y161.776 E.03541
G1 X175.32 Y161.872 E.01524
G1 X174.848 Y161.87 E.01408
M204 S10000
G1 X174.911 Y162.248 F60000
; LINE_WIDTH: 0.398987
G1 F1200
M204 S8000
G1 X174.554 Y162.217 E.01009
G1 X174.554 Y162.596 E.01066
G2 X175.448 Y162.598 I.509 J-26.887 E.02514
G1 X175.448 Y162.224 E.01052
G1 X174.971 Y162.245 E.01342
; WIPE_START
G1 F10110.479
G1 X175.448 Y162.224 E-.1813
G1 X175.448 Y162.598 E-.14214
G1 X174.554 Y162.596 E-.33968
G1 X174.554 Y162.341 E-.09688
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.941 Y159.755 Z2.2 F60000
G1 Z1.8
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.104436
G1 F1200
M204 S8000
G1 X172.879 Y159.671 E.0005
; LINE_WIDTH: 0.126221
G1 X172.796 Y159.545 E.00099
; LINE_WIDTH: 0.154095
G1 X172.713 Y159.419 E.00133
M204 S10000
G1 X172.735 Y159.294 F60000
; LINE_WIDTH: 0.131153
G1 F1200
M204 S8000
G2 X172.797 Y159.631 I6.262 J-.967 E.00239
; WIPE_START
G1 F15000
G1 X172.735 Y159.294 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.735 Y157.805 Z2.2 F60000
G1 Z1.8
G1 E.8 F1800
; LINE_WIDTH: 0.11077
G1 F1200
M204 S8000
G1 X172.751 Y157.712 E.0005
; LINE_WIDTH: 0.13847
G1 X172.767 Y157.62 E.00071
; LINE_WIDTH: 0.158114
G3 X172.829 Y157.5 I.214 J.035 E.00125
; LINE_WIDTH: 0.128738
G1 X172.882 Y157.422 E.00064
; LINE_WIDTH: 0.105682
G1 X172.951 Y157.328 E.00058
; WIPE_START
G1 F15000
G1 X172.882 Y157.422 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X173.713 Y156.286 Z2.2 F60000
G1 Z1.8
G1 E.8 F1800
; LINE_WIDTH: 0.358798
G1 F1200
M204 S8000
G3 X174.144 Y156.201 I1.889 J8.529 E.01096
; LINE_WIDTH: 0.299291
G1 X174.263 Y156.18 E.00245
; LINE_WIDTH: 0.262566
G1 X174.383 Y156.165 E.00209
; LINE_WIDTH: 0.233488
G1 X174.491 Y156.151 E.00165
; LINE_WIDTH: 0.19965
G1 X174.74 Y156.131 E.00309
; LINE_WIDTH: 0.179061
G1 X175.212 Y156.129 E.00507
G1 X175.461 Y156.146 E.00269
; LINE_WIDTH: 0.224902
G1 X175.588 Y156.161 E.00183
; LINE_WIDTH: 0.25469
G1 X175.706 Y156.176 E.00199
; LINE_WIDTH: 0.288988
G1 X175.826 Y156.196 E.00236
; LINE_WIDTH: 0.327959
G1 X175.935 Y156.214 E.00249
; LINE_WIDTH: 0.3492
G1 X176.287 Y156.283 E.0087
; WIPE_START
G1 F11753.972
G1 X175.935 Y156.214 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X177.046 Y157.323 Z2.2 F60000
G1 Z1.8
G1 E.8 F1800
; LINE_WIDTH: 0.116538
G1 F1200
M204 S8000
G1 X177.17 Y157.498 E.00125
; LINE_WIDTH: 0.157588
G1 X177.223 Y157.576 E.00085
; LINE_WIDTH: 0.146916
G1 X177.248 Y157.709 E.00111
; LINE_WIDTH: 0.111482
G1 X177.265 Y157.804 E.00053
; WIPE_START
G1 F15000
G1 X177.248 Y157.709 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X177.265 Y159.296 Z2.2 F60000
G1 Z1.8
G1 E.8 F1800
; LINE_WIDTH: 0.110777
G1 F1200
M204 S8000
G1 X177.249 Y159.388 E.0005
; LINE_WIDTH: 0.1456
G1 X177.223 Y159.521 E.0011
; LINE_WIDTH: 0.156687
G1 X177.171 Y159.6 E.00085
; LINE_WIDTH: 0.116035
G1 X177.049 Y159.772 E.00122
; CHANGE_LAYER
; Z_HEIGHT: 2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F15000
G1 X177.171 Y159.6 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 10/32
; update layer progress
M73 L10
M991 S0 P9 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z2.2 I.091 J-1.214 P1  F60000
G1 X173.907 Y159.355 Z2.2
G1 Z2
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X173.886 Y159.329 E.00101
G3 X174.857 Y157.197 I1.113 J-.78 E.0841
G1 X174.983 Y157.19 E.00375
G3 X174.056 Y159.528 I.017 J1.359 E.15876
G1 X173.947 Y159.401 E.00499
; COOLING_NODE: 1
; WIPE_START
G1 F9547.055
M204 S8000
G1 X173.886 Y159.329 E-.0357
G1 X173.755 Y159.097 E-.10117
G1 X173.67 Y158.833 E-.10545
G1 X173.64 Y158.575 E-.09883
G1 X173.66 Y158.315 E-.09912
G1 X173.73 Y158.063 E-.09919
G1 X173.846 Y157.829 E-.0994
G1 X174.022 Y157.605 E-.10806
G1 X174.047 Y157.582 E-.01308
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.21 Y163.24 Z2.4 F60000
G1 Z2
G1 E.8 F1800
G1 F1200
M204 S5000
G1 X171.71 Y163.24 E.01489
G1 X171.71 Y155.06 E.24365
G1 X178.29 Y155.06 E.196
G1 X178.29 Y163.24 E.24365
G1 X177.79 Y163.24 E.01489
M73 P87 R1
G1 X177.79 Y164.94 E.05064
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X172.21 Y164.94 E.16621
G1 X172.21 Y163.3 E.04885
; WIPE_START
G1 F9547.055
M204 S8000
G1 X171.71 Y163.24 E-.19136
G1 X171.71 Y161.744 E-.56864
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.406 Y164.632 Z2.4 F60000
G1 Z2
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.26667
G1 F1200
M204 S8000
G1 X177.594 Y164.632 E.0917
M204 S10000
G1 X177.172 Y164.494 F60000
; FEATURE: Top surface
; LINE_WIDTH: 0.42
G1 F1200
M204 S2000
G1 X177.583 Y164.083 E.0173
G1 X177.716 Y163.949
G1 X177.716 Y163.416
G1 X177.583 Y163.55
G1 X176.639 Y164.494 E.03976
G1 X176.505 Y164.627
G1 X175.972 Y164.627
G1 X176.105 Y164.494
G1 X178.083 Y162.517 E.08329
G1 X178.216 Y162.383
G1 X178.216 Y161.85
G1 X178.083 Y161.983
G1 X175.572 Y164.494 E.10575
G1 X175.438 Y164.627
G1 X174.905 Y164.627
G1 X175.039 Y164.494
G1 X178.083 Y161.45 E.12822
G1 X178.216 Y161.316
G1 X178.216 Y160.783
G1 X178.083 Y160.917
G1 X174.506 Y164.494 E.15068
G1 X174.372 Y164.627
G1 X173.839 Y164.627
G1 X173.972 Y164.494
G1 X178.083 Y160.383 E.17314
G1 X178.216 Y160.25
G1 X178.216 Y159.717
G1 X178.083 Y159.85
G1 X173.439 Y164.494 E.19561
G1 X173.305 Y164.627
G1 X172.772 Y164.627
G1 X172.906 Y164.494
G1 X178.083 Y159.317 E.21807
G1 X178.216 Y159.183
G1 X178.216 Y158.65
G1 X178.083 Y158.784
G1 X172.417 Y164.449 E.23865
G1 X172.284 Y164.583
G1 X172.284 Y164.049
G1 X172.417 Y163.916
G1 X178.083 Y158.25 E.23865
G1 X178.216 Y158.117
G1 X178.216 Y157.584
G1 X178.083 Y157.717
M73 P87 R0
G1 X172.417 Y163.382 E.23865
G1 X172.284 Y163.516
G1 X172.1 Y163.166
G1 X172.234 Y163.033
M73 P88 R0
G1 X175.158 Y160.109 E.12317
G1 X175.292 Y159.975
G1 X174.789 Y159.944
G1 X174.656 Y160.078
G1 X171.917 Y162.816 E.11535
G1 X171.784 Y162.95
G1 X171.784 Y162.416
G1 X171.917 Y162.283
G1 X174.266 Y159.934 E.09893
G1 X174.399 Y159.801
G1 X174.086 Y159.581
G1 X173.953 Y159.714
G1 X171.917 Y161.749 E.08573
G1 X171.784 Y161.883
G1 X171.784 Y161.35
G1 X171.917 Y161.216
G1 X173.704 Y159.43 E.07524
G1 X173.837 Y159.296
G1 X173.658 Y158.942
G1 X173.525 Y159.076
G1 X171.917 Y160.683 E.0677
G1 X171.784 Y160.817
G1 X171.784 Y160.283
G1 X171.917 Y160.15
G1 X173.436 Y158.631 E.06397
G1 X173.57 Y158.497
G1 X173.665 Y157.869
G1 X173.532 Y158.002
G1 X171.917 Y159.616 E.068
; WIPE_START
G1 F9547.055
M204 S8000
G1 X173.332 Y158.202 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X176.558 Y158.708 Z2.4 F60000
G1 Z2
G1 E.8 F1800
G1 F1200
M204 S2000
G1 X178.083 Y157.184 E.06421
G1 X178.216 Y157.05
G1 X178.216 Y156.517
G1 X178.083 Y156.651
G1 X176.529 Y158.205 E.06547
G1 X176.395 Y158.338
G1 X176.25 Y157.95
G1 X176.384 Y157.816
G1 X178.083 Y156.117 E.07155
G1 X178.216 Y155.984
G1 X178.216 Y155.451
G1 X178.083 Y155.584
G1 X176.164 Y157.503 E.08081
G1 X176.031 Y157.636
G1 X175.746 Y157.387
G1 X175.88 Y157.254
G1 X177.866 Y155.267 E.08367
G1 X178 Y155.134
G1 X177.467 Y155.134
G1 X177.333 Y155.267
G1 X175.525 Y157.075 E.07614
G1 X175.392 Y157.209
G1 X174.947 Y157.12
G1 X175.081 Y156.986
G1 X176.8 Y155.267 E.0724
G1 X176.933 Y155.134
G1 X176.4 Y155.134
G1 X176.266 Y155.267
G1 X174.45 Y157.083 E.0765
; WIPE_START
G1 F9547.055
M204 S8000
G1 X175.865 Y155.669 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.733 Y155.267 Z2.4 F60000
G1 Z2
G1 E.8 F1800
G1 F1200
M204 S2000
G1 X171.917 Y159.083 E.16074
G1 X171.784 Y159.217
G1 X171.784 Y158.684
G1 X171.917 Y158.55
G1 X175.2 Y155.267 E.13827
G1 X175.334 Y155.134
G1 X174.8 Y155.134
G1 X174.667 Y155.267
G1 X171.917 Y158.017 E.11581
G1 X171.784 Y158.15
G1 X171.784 Y157.617
G1 X171.917 Y157.483
G1 X174.133 Y155.267 E.09335
G1 X174.267 Y155.134
G1 X173.734 Y155.134
G1 X173.6 Y155.267
G1 X171.917 Y156.95 E.07088
G1 X171.784 Y157.084
G1 X171.784 Y156.55
G1 X171.917 Y156.417
G1 X173.067 Y155.267 E.04842
G1 X173.2 Y155.134
G1 X172.667 Y155.134
G1 X172.534 Y155.267
G1 X171.917 Y155.884 E.02596
; WIPE_START
G1 F9547.055
M204 S8000
M73 P89 R0
G1 X172.534 Y155.267 E-.33115
G1 X172.667 Y155.134 E-.07182
G1 X173.2 Y155.134 E-.20264
G1 X173.067 Y155.267 E-.07182
G1 X172.913 Y155.421 E-.08258
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X174.386 Y157.019 Z2.4 F60000
G1 Z2
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.19041
G1 F1200
M204 S8000
G1 X174.216 Y157.141 E.00244
; LINE_WIDTH: 0.151442
G1 X174.09 Y157.241 E.00137
; LINE_WIDTH: 0.117886
G1 X173.864 Y157.45 E.00183
G1 X173.674 Y157.662 E.00168
; CHANGE_LAYER
; Z_HEIGHT: 2.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F15000
G1 X173.864 Y157.45 E-.36433
G1 X174.09 Y157.241 E-.39567
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 11/32
; update layer progress
M73 L11
M991 S0 P10 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 1
M204 S10000
G17
G3 Z2.4 I-1.186 J-.271 P1  F60000
G1 X172.602 Y163.752 Z2.4
G1 Z2.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X177.398 Y163.752 E.15422
G1 X177.398 Y164.548 E.02559
G1 X172.602 Y164.548 E.15422
G1 X172.602 Y163.812 E.02366
; COOLING_NODE: 1
M204 S250
G1 X172.21 Y163.36 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X177.79 Y163.36 E.16621
G1 X177.79 Y164.94 E.04706
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X172.21 Y164.94 E.16621
G1 X172.21 Y163.42 E.04528
M204 S10000
G1 X172.806 Y164.15 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1200
M204 S8000
G1 X177.194 Y164.15 E.13479
; CHANGE_LAYER
; Z_HEIGHT: 2.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.259
G1 X175.194 Y164.15 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 12/32
; update layer progress
M73 L12
M991 S0 P11 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 1
M204 S10000
G17
G3 Z2.6 I.185 J-1.203 P1  F60000
G1 X172.602 Y163.752 Z2.6
G1 Z2.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X177.398 Y163.752 E.15422
G1 X177.398 Y164.548 E.02559
G1 X172.602 Y164.548 E.15422
G1 X172.602 Y163.812 E.02366
; COOLING_NODE: 1
M204 S250
G1 X172.21 Y163.36 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X177.79 Y163.36 E.16621
G1 X177.79 Y164.94 E.04706
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X172.21 Y164.94 E.16621
G1 X172.21 Y163.42 E.04528
M204 S10000
G1 X172.806 Y164.15 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1200
M204 S8000
G1 X177.194 Y164.15 E.13479
; CHANGE_LAYER
; Z_HEIGHT: 2.6
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.259
G1 X175.194 Y164.15 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 13/32
; update layer progress
M73 L13
M991 S0 P12 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 1
M204 S10000
G17
G3 Z2.8 I.185 J-1.203 P1  F60000
G1 X172.602 Y163.752 Z2.8
G1 Z2.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X177.398 Y163.752 E.15422
G1 X177.398 Y164.548 E.02559
G1 X172.602 Y164.548 E.15422
G1 X172.602 Y163.812 E.02366
; COOLING_NODE: 1
M204 S250
G1 X172.21 Y163.36 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X177.79 Y163.36 E.16621
G1 X177.79 Y164.94 E.04706
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X172.21 Y164.94 E.16621
G1 X172.21 Y163.42 E.04528
M204 S10000
G1 X172.806 Y164.15 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
M73 P90 R0
G1 F1200
M204 S8000
G1 X177.194 Y164.15 E.13479
; CHANGE_LAYER
; Z_HEIGHT: 2.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.259
G1 X175.194 Y164.15 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 14/32
; update layer progress
M73 L14
M991 S0 P13 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 1
M204 S10000
G17
G3 Z3 I.185 J-1.203 P1  F60000
G1 X172.602 Y163.752 Z3
G1 Z2.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X177.398 Y163.752 E.15422
G1 X177.398 Y164.548 E.02559
G1 X172.602 Y164.548 E.15422
G1 X172.602 Y163.812 E.02366
; COOLING_NODE: 1
M204 S250
G1 X172.21 Y163.36 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X177.79 Y163.36 E.16621
G1 X177.79 Y164.94 E.04706
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X172.21 Y164.94 E.16621
G1 X172.21 Y163.42 E.04528
M204 S10000
G1 X172.806 Y164.15 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1200
M204 S8000
G1 X177.194 Y164.15 E.13479
; CHANGE_LAYER
; Z_HEIGHT: 3
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.259
G1 X175.194 Y164.15 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 15/32
; update layer progress
M73 L15
M991 S0 P14 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 1
M204 S10000
G17
G3 Z3.2 I.185 J-1.203 P1  F60000
G1 X172.602 Y163.752 Z3.2
G1 Z3
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X177.398 Y163.752 E.15422
G1 X177.398 Y164.548 E.02559
G1 X172.602 Y164.548 E.15422
G1 X172.602 Y163.812 E.02366
; COOLING_NODE: 1
M204 S250
G1 X172.21 Y163.36 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X177.79 Y163.36 E.16621
G1 X177.79 Y164.94 E.04706
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X172.21 Y164.94 E.16621
G1 X172.21 Y163.42 E.04528
M204 S10000
G1 X172.806 Y164.15 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1200
M204 S8000
G1 X177.194 Y164.15 E.13479
; CHANGE_LAYER
; Z_HEIGHT: 3.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.259
G1 X175.194 Y164.15 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 16/32
; update layer progress
M73 L16
M991 S0 P15 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 1
M204 S10000
G17
G3 Z3.4 I.185 J-1.203 P1  F60000
G1 X172.602 Y163.752 Z3.4
G1 Z3.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X177.398 Y163.752 E.15422
G1 X177.398 Y164.548 E.02559
G1 X172.602 Y164.548 E.15422
G1 X172.602 Y163.812 E.02366
; COOLING_NODE: 1
M204 S250
G1 X172.21 Y163.36 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X177.79 Y163.36 E.16621
G1 X177.79 Y164.94 E.04706
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X172.21 Y164.94 E.16621
G1 X172.21 Y163.42 E.04528
M204 S10000
M73 P91 R0
G1 X172.806 Y164.15 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1200
M204 S8000
G1 X177.194 Y164.15 E.13479
; CHANGE_LAYER
; Z_HEIGHT: 3.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.259
G1 X175.194 Y164.15 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 17/32
; update layer progress
M73 L17
M991 S0 P16 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 1
M204 S10000
G17
G3 Z3.6 I.185 J-1.203 P1  F60000
G1 X172.602 Y163.752 Z3.6
G1 Z3.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X177.398 Y163.752 E.15422
G1 X177.398 Y164.548 E.02559
G1 X172.602 Y164.548 E.15422
G1 X172.602 Y163.812 E.02366
; COOLING_NODE: 1
M204 S250
G1 X172.21 Y163.36 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X177.79 Y163.36 E.16621
G1 X177.79 Y164.94 E.04706
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X172.21 Y164.94 E.16621
G1 X172.21 Y163.42 E.04528
M204 S10000
G1 X172.806 Y164.15 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1200
M204 S8000
G1 X177.194 Y164.15 E.13479
; CHANGE_LAYER
; Z_HEIGHT: 3.6
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.259
G1 X175.194 Y164.15 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 18/32
; update layer progress
M73 L18
M991 S0 P17 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 1
M204 S10000
G17
G3 Z3.8 I.185 J-1.203 P1  F60000
G1 X172.602 Y163.752 Z3.8
G1 Z3.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X177.398 Y163.752 E.15422
G1 X177.398 Y164.548 E.02559
G1 X172.602 Y164.548 E.15422
G1 X172.602 Y163.812 E.02366
; COOLING_NODE: 1
M204 S250
G1 X172.21 Y163.36 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X177.79 Y163.36 E.16621
G1 X177.79 Y164.94 E.04706
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X172.21 Y164.94 E.16621
G1 X172.21 Y163.42 E.04528
M204 S10000
G1 X172.806 Y164.15 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1200
M204 S8000
G1 X177.194 Y164.15 E.13479
; CHANGE_LAYER
; Z_HEIGHT: 3.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.259
G1 X175.194 Y164.15 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 19/32
; update layer progress
M73 L19
M991 S0 P18 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 1
M204 S10000
G17
G3 Z4 I.185 J-1.203 P1  F60000
G1 X172.602 Y163.752 Z4
G1 Z3.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X177.398 Y163.752 E.15422
G1 X177.398 Y164.548 E.02559
G1 X172.602 Y164.548 E.15422
G1 X172.602 Y163.812 E.02366
; COOLING_NODE: 1
M204 S250
G1 X172.21 Y163.36 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
M73 P92 R0
G1 X177.79 Y163.36 E.16621
G1 X177.79 Y164.94 E.04706
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X172.21 Y164.94 E.16621
G1 X172.21 Y163.42 E.04528
M204 S10000
G1 X172.806 Y164.15 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1200
M204 S8000
G1 X177.194 Y164.15 E.13479
; CHANGE_LAYER
; Z_HEIGHT: 4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.259
G1 X175.194 Y164.15 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 20/32
; update layer progress
M73 L20
M991 S0 P19 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 1
M204 S10000
G17
G3 Z4.2 I.185 J-1.203 P1  F60000
G1 X172.602 Y163.752 Z4.2
G1 Z4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X177.398 Y163.752 E.15422
G1 X177.398 Y164.548 E.02559
G1 X172.602 Y164.548 E.15422
G1 X172.602 Y163.812 E.02366
; COOLING_NODE: 1
M204 S250
G1 X172.21 Y163.36 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X177.79 Y163.36 E.16621
G1 X177.79 Y164.94 E.04706
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X172.21 Y164.94 E.16621
G1 X172.21 Y163.42 E.04528
M204 S10000
G1 X172.806 Y164.15 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1200
M204 S8000
G1 X177.194 Y164.15 E.13479
; CHANGE_LAYER
; Z_HEIGHT: 4.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.259
G1 X175.194 Y164.15 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 21/32
; update layer progress
M73 L21
M991 S0 P20 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 1
M204 S10000
G17
G3 Z4.4 I.185 J-1.203 P1  F60000
G1 X172.602 Y163.752 Z4.4
G1 Z4.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X177.398 Y163.752 E.15422
G1 X177.398 Y164.548 E.02559
G1 X172.602 Y164.548 E.15422
G1 X172.602 Y163.812 E.02366
; COOLING_NODE: 1
M204 S250
G1 X172.21 Y163.36 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X177.79 Y163.36 E.16621
G1 X177.79 Y164.94 E.04706
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X172.21 Y164.94 E.16621
G1 X172.21 Y163.42 E.04528
M204 S10000
G1 X172.806 Y164.15 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1200
M204 S8000
G1 X177.194 Y164.15 E.13479
; CHANGE_LAYER
; Z_HEIGHT: 4.4
; LAYER_HEIGHT: 0.2
; WIPE_START
M73 P93 R0
G1 F9259.259
G1 X175.194 Y164.15 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 22/32
; update layer progress
M73 L22
M991 S0 P21 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 1
M204 S10000
G17
G3 Z4.6 I.185 J-1.203 P1  F60000
G1 X172.602 Y163.752 Z4.6
G1 Z4.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
M73 P94 R0
G1 F1200
M204 S8000
G1 X177.398 Y163.752 E.15422
G1 X177.398 Y164.548 E.02559
G1 X172.602 Y164.548 E.15422
G1 X172.602 Y163.812 E.02366
; COOLING_NODE: 1
M204 S250
G1 X172.21 Y163.36 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X177.79 Y163.36 E.16621
G1 X177.79 Y164.94 E.04706
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X172.21 Y164.94 E.16621
G1 X172.21 Y163.42 E.04528
M204 S10000
G1 X172.806 Y164.15 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1200
M204 S8000
G1 X177.194 Y164.15 E.13479
; CHANGE_LAYER
; Z_HEIGHT: 4.6
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.259
G1 X175.194 Y164.15 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 23/32
; update layer progress
M73 L23
M991 S0 P22 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 1
M204 S10000
G17
G3 Z4.8 I.185 J-1.203 P1  F60000
G1 X172.602 Y163.752 Z4.8
G1 Z4.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X177.398 Y163.752 E.15422
G1 X177.398 Y164.548 E.02559
G1 X172.602 Y164.548 E.15422
G1 X172.602 Y163.812 E.02366
; COOLING_NODE: 1
M204 S250
G1 X172.21 Y163.36 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X177.79 Y163.36 E.16621
G1 X177.79 Y164.94 E.04706
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X172.21 Y164.94 E.16621
G1 X172.21 Y163.42 E.04528
M204 S10000
G1 X172.806 Y164.15 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1200
M204 S8000
G1 X177.194 Y164.15 E.13479
; CHANGE_LAYER
; Z_HEIGHT: 4.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.259
G1 X175.194 Y164.15 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 24/32
; update layer progress
M73 L24
M991 S0 P23 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 1
M204 S10000
G17
G3 Z5 I.185 J-1.203 P1  F60000
G1 X172.602 Y163.752 Z5
G1 Z4.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X177.398 Y163.752 E.15422
G1 X177.398 Y164.548 E.02559
G1 X172.602 Y164.548 E.15422
G1 X172.602 Y163.812 E.02366
; COOLING_NODE: 1
M204 S250
G1 X172.21 Y163.36 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X177.79 Y163.36 E.16621
G1 X177.79 Y164.94 E.04706
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X172.21 Y164.94 E.16621
G1 X172.21 Y163.42 E.04528
M204 S10000
G1 X172.806 Y164.15 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1200
M204 S8000
G1 X177.194 Y164.15 E.13479
; CHANGE_LAYER
; Z_HEIGHT: 5
; LAYER_HEIGHT: 0.2
; WIPE_START
M73 P95 R0
G1 F9259.259
G1 X175.194 Y164.15 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 25/32
; update layer progress
M73 L25
M991 S0 P24 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 1
M204 S10000
G17
G3 Z5.2 I.185 J-1.203 P1  F60000
G1 X172.602 Y163.752 Z5.2
G1 Z5
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X177.398 Y163.752 E.15422
G1 X177.398 Y164.548 E.02559
G1 X172.602 Y164.548 E.15422
G1 X172.602 Y163.812 E.02366
; COOLING_NODE: 1
M204 S250
G1 X172.21 Y163.36 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X177.79 Y163.36 E.16621
G1 X177.79 Y164.94 E.04706
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X172.21 Y164.94 E.16621
G1 X172.21 Y163.42 E.04528
M204 S10000
G1 X172.806 Y164.15 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1200
M204 S8000
G1 X177.194 Y164.15 E.13479
; CHANGE_LAYER
; Z_HEIGHT: 5.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.259
G1 X175.194 Y164.15 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 26/32
; update layer progress
M73 L26
M991 S0 P25 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 1
M204 S10000
G17
G3 Z5.4 I.185 J-1.203 P1  F60000
G1 X172.602 Y163.752 Z5.4
G1 Z5.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X177.398 Y163.752 E.15422
G1 X177.398 Y164.548 E.02559
G1 X172.602 Y164.548 E.15422
G1 X172.602 Y163.812 E.02366
; COOLING_NODE: 1
M204 S250
G1 X172.21 Y163.36 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X177.79 Y163.36 E.16621
G1 X177.79 Y164.94 E.04706
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X172.21 Y164.94 E.16621
G1 X172.21 Y163.42 E.04528
M204 S10000
G1 X172.806 Y164.15 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1200
M204 S8000
G1 X177.194 Y164.15 E.13479
; CHANGE_LAYER
; Z_HEIGHT: 5.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.259
G1 X175.194 Y164.15 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 27/32
; update layer progress
M73 L27
M991 S0 P26 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 1
M204 S10000
G17
G3 Z5.6 I.185 J-1.203 P1  F60000
G1 X172.602 Y163.752 Z5.6
G1 Z5.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X177.398 Y163.752 E.15422
G1 X177.398 Y164.548 E.02559
G1 X172.602 Y164.548 E.15422
G1 X172.602 Y163.812 E.02366
; COOLING_NODE: 1
M204 S250
G1 X172.21 Y163.36 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X177.79 Y163.36 E.16621
G1 X177.79 Y164.94 E.04706
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X172.21 Y164.94 E.16621
G1 X172.21 Y163.42 E.04528
M204 S10000
G1 X172.806 Y164.15 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1200
M204 S8000
M73 P96 R0
G1 X177.194 Y164.15 E.13479
; CHANGE_LAYER
; Z_HEIGHT: 5.6
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.259
G1 X175.194 Y164.15 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 28/32
; update layer progress
M73 L28
M991 S0 P27 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 1
M204 S10000
G17
G3 Z5.8 I.185 J-1.203 P1  F60000
G1 X172.602 Y163.752 Z5.8
G1 Z5.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X177.398 Y163.752 E.15422
G1 X177.398 Y164.548 E.02559
G1 X172.602 Y164.548 E.15422
G1 X172.602 Y163.812 E.02366
; COOLING_NODE: 1
M204 S250
G1 X172.21 Y163.36 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X177.79 Y163.36 E.16621
G1 X177.79 Y164.94 E.04706
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X172.21 Y164.94 E.16621
G1 X172.21 Y163.42 E.04528
M204 S10000
G1 X172.806 Y164.15 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1200
M204 S8000
G1 X177.194 Y164.15 E.13479
; CHANGE_LAYER
; Z_HEIGHT: 5.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.259
G1 X175.194 Y164.15 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 29/32
; update layer progress
M73 L29
M991 S0 P28 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 1
M204 S10000
G17
G3 Z6 I.185 J-1.203 P1  F60000
G1 X172.602 Y163.752 Z6
G1 Z5.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X177.398 Y163.752 E.15422
G1 X177.398 Y164.548 E.02559
G1 X172.602 Y164.548 E.15422
G1 X172.602 Y163.812 E.02366
; COOLING_NODE: 1
M204 S250
G1 X172.21 Y163.36 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X177.79 Y163.36 E.16621
G1 X177.79 Y164.94 E.04706
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X172.21 Y164.94 E.16621
G1 X172.21 Y163.42 E.04528
M204 S10000
G1 X172.806 Y164.15 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1200
M204 S8000
G1 X177.194 Y164.15 E.13479
; CHANGE_LAYER
; Z_HEIGHT: 6
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.259
G1 X175.194 Y164.15 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 30/32
; update layer progress
M73 L30
M991 S0 P29 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 1
M204 S10000
G17
G3 Z6.2 I.185 J-1.203 P1  F60000
G1 X172.602 Y163.752 Z6.2
G1 Z6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X177.398 Y163.752 E.15422
G1 X177.398 Y164.548 E.02559
G1 X172.602 Y164.548 E.15422
G1 X172.602 Y163.812 E.02366
; COOLING_NODE: 1
M204 S250
G1 X172.21 Y163.36 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X177.79 Y163.36 E.16621
G1 X177.79 Y164.94 E.04706
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X172.21 Y164.94 E.16621
G1 X172.21 Y163.42 E.04528
M204 S10000
M73 P97 R0
G1 X172.806 Y164.15 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1200
M204 S8000
G1 X177.194 Y164.15 E.13479
; CHANGE_LAYER
; Z_HEIGHT: 6.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.259
G1 X175.194 Y164.15 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 31/32
; update layer progress
M73 L31
M991 S0 P30 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 1
M204 S10000
G17
G3 Z6.4 I.185 J-1.203 P1  F60000
G1 X172.602 Y163.752 Z6.4
G1 Z6.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X177.398 Y163.752 E.15422
G1 X177.398 Y164.548 E.02559
G1 X172.602 Y164.548 E.15422
G1 X172.602 Y163.812 E.02366
; COOLING_NODE: 1
M204 S250
G1 X172.21 Y163.36 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X177.79 Y163.36 E.16621
G1 X177.79 Y164.94 E.04706
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X172.21 Y164.94 E.16621
G1 X172.21 Y163.42 E.04528
M204 S10000
G1 X172.806 Y164.15 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1200
M204 S8000
G1 X177.194 Y164.15 E.13479
; CHANGE_LAYER
; Z_HEIGHT: 6.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.259
G1 X175.194 Y164.15 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 32/32
; update layer progress
M73 L32
M991 S0 P31 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 1
M204 S10000
G17
G3 Z6.6 I.311 J-1.176 P1  F60000
G1 X172.21 Y163.36 Z6.6
G1 Z6.4
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X177.79 Y163.36 E.16621
G1 X177.79 Y164.94 E.04706
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X172.21 Y164.94 E.16621
G1 X172.21 Y163.42 E.04528
; WIPE_START
G1 F9547.055
M204 S8000
G1 X174.21 Y163.398 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X177.583 Y164.083 Z6.8 F60000
G1 Z6.4
G1 E.8 F1800
; FEATURE: Top surface
G1 F1200
M204 S2000
G1 X176.933 Y164.733 E.02736
G1 X176.799 Y164.866
G1 X176.266 Y164.866
G1 X176.4 Y164.733
G1 X177.565 Y163.567 E.04909
G1 X177.699 Y163.434
G1 X177.165 Y163.434
G1 X177.032 Y163.567
G1 X175.867 Y164.733 E.04909
G1 X175.733 Y164.866
G1 X175.2 Y164.866
G1 X175.333 Y164.733
G1 X176.499 Y163.567 E.04909
G1 X176.632 Y163.434
G1 X176.099 Y163.434
G1 X175.965 Y163.567
G1 X174.8 Y164.733 E.04909
G1 X174.666 Y164.866
G1 X174.133 Y164.866
G1 X174.267 Y164.733
G1 X175.432 Y163.567 E.04909
G1 X175.566 Y163.434
G1 X175.032 Y163.434
G1 X174.899 Y163.567
G1 X173.733 Y164.733 E.04909
G1 X173.6 Y164.866
G1 X173.067 Y164.866
G1 X173.2 Y164.733
G1 X174.365 Y163.567 E.04909
G1 X174.499 Y163.434
G1 X173.966 Y163.434
G1 X173.832 Y163.567
G1 X172.667 Y164.733 E.04909
G1 X172.533 Y164.866
G1 X172.284 Y164.583
G1 X172.417 Y164.449
G1 X173.299 Y163.567 E.03714
G1 X173.433 Y163.434
G1 X172.899 Y163.434
G1 X172.766 Y163.567
G1 X172.417 Y163.916 E.01467
; close powerlost recovery
M1003 S0
; WIPE_START
M73 P98 R0
G1 F9547.055
M204 S8000
G1 X172.766 Y163.567 E-.18719
G1 X172.899 Y163.434 E-.07182
G1 X173.433 Y163.434 E-.20264
G1 X173.299 Y163.567 E-.07182
G1 X172.877 Y163.989 E-.22654
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z6.8 I1.217 J0 P1  F60000
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
G1 Z6.8 F900 ; lower z a little
M1002 judge_flag timelapse_record_flag
M622 J1
    G150.3
    M400 ; wait all motion done
    M991 S0 P-1 ;end smooth timelapse at safe pos
    M400 S5 ;wait for last picture to be taken
M623  ;end of "timelapse_record_flag"

G90
G1 Z16.4 F900 ; lower z a little

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

    
        G1 Z103.2 F600
        G1 Z101.2
    

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

