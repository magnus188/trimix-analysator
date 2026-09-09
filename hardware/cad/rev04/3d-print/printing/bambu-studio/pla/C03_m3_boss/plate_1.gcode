; HEADER_BLOCK_START
; BambuStudio 02.08.02.61
; model printing time: 9m 18s; total estimated time: 14m 45s
; total layer number: 58
; total filament length [mm] : 516.73
; total filament volume [cm^3] : 1242.87
; total filament weight [g] : 1.54
; filament_density: 1.24
; filament_diameter: 1.75
; max_z_height: 11.60
; filament: 1
; support_material_on_wipe_tower: 0
; HEADER_BLOCK_END

; CONFIG_BLOCK_START
; accel_to_decel_enable = 0
; accel_to_decel_factor = 50%
; activate_air_filtration = 0
; additional_cooling_fan_speed = 70
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
; close_additional_fan_first_x_layers = 1
; close_fan_the_first_x_layers = 1
; compatible_printers_condition = 
; complete_print_exhaust_fan_speed = 70
; cool_plate_temp = 35
; cool_plate_temp_initial_layer = 35
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
; eng_plate_temp = 55
; eng_plate_temp_initial_layer = 55
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
; fan_cooling_layer_time = 100
; fan_direction = left
; fan_max_speed = 100
; fan_min_speed = 100
; farthest_point_timelapse = 1
; filament_adaptive_volumetric_speed = 0
; filament_adhesiveness_category = 100
; filament_bridge_speed = 25
; filament_change_length = 10
; filament_change_length_nc = 10
; filament_colour = #00AE42
; filament_cooling_before_tower = 10
; filament_cost = 20
; filament_density = 1.24
; filament_dev_ams_drying_ams_limitations = 1
; filament_dev_ams_drying_heat_distortion_temperature = 45
; filament_dev_ams_drying_temperature = 45
; filament_dev_ams_drying_time = 12
; filament_dev_chamber_drying_bed_temperature = 70
; filament_dev_chamber_drying_time = 12
; filament_dev_drying_cooling_temperature = 45
; filament_dev_drying_softening_temperature = 50
; filament_diameter = 1.75
; filament_enable_overhang_speed = 1
; filament_end_gcode = "; filament end gcode \n"
; filament_extruder_compatibility = 0
; filament_extruder_variant = "Direct Drive Standard"
; filament_flow_ratio = 0.98
; filament_flush_temp = 0
; filament_flush_temp_fast = 0
; filament_flush_volumetric_speed = 0
; filament_ids = GFL99
; filament_is_mixed = 0
; filament_is_support = 0
; filament_map = 1
; filament_map_2 = 0
; filament_map_mode = Auto For Flush
; filament_max_volumetric_speed = 12
; filament_metal_stickiness = None
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
; filament_scarf_gap = 15%
; filament_scarf_height = 10%
; filament_scarf_length = 10
; filament_scarf_seam_type = none
; filament_self_index = 1
; filament_settings_id = "Generic PLA @BBL H2D"
; filament_shrink = 100%
; filament_soluble = 0
; filament_start_gcode = "; filament start gcode\n"
; filament_tower_interface_pre_extrusion_dist = 10
; filament_tower_interface_pre_extrusion_length = 0
; filament_tower_interface_print_temp = -1
; filament_tower_interface_purge_volume = 20
; filament_tower_ironing_area = 4
; filament_type = PLA
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
; hot_plate_temp = 55
; hot_plate_temp_initial_layer = 55
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
; nozzle_temperature = 220
; nozzle_temperature_initial_layer = 220
; nozzle_temperature_range_high = 240
; nozzle_temperature_range_low = 190
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
; overhang_fan_speed = 100
; overhang_fan_threshold = 50%
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
; slow_down_layer_time = 8
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
; supertack_plate_temp = 45
; supertack_plate_temp_initial_layer = 45
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
; temperature_vitrification = 45
; template_custom_gcode = 
; textured_plate_temp = 55
; textured_plate_temp_initial_layer = 55
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
M73 P0 R14
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
    
        
            M142 P1 R30 S40 T45 U0.3 V0.5 W0.8 O45; set PLA/TPU ND0.4 chamber autocooling
        
    
    
        M145.2 P0 F1
    


;==== set airduct mode ====

;===== start to heat heatbed & hotend==========

    M1002 set_filament_type:PLA

    M104 S140 A
    M140 S55

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

M104 S220 T1 ; rise temp in advance

G151 P1 M ; plug the heat nozzle



;===== detection end =====

M400
;M73 P99

;===== prepare print temperature and material ==========
M400
M211 X0 Y0 Z0 ;turn off soft endstop
M975 S1 ; turn on input shaping

G29.2 S0 ; avoid invalid abl data


M620.10 A0 F239.471 H0.4 T240 P220 S1
M620.10 A1 F239.471 H0.4 T240 P220 S1


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
M1002 set_filament_type:PLA
M621 S0A

M104 S220
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
    M1002 set_filament_type:PLA
    M1002 gcode_claim_action : 8

    M109 S220

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
    M1002 set_filament_type:PLA
    M1002 gcode_claim_action : 8

    M109 S220

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
    M109 S220 ; wait tmpr to extrude
    M83
    
        G1 E45 F299.339
    
    G1 E-3 F1800
    M400 P500
    G150.2
    G150.1


G91
M73 P3 R14
G1 Y-16 F12000 ; move away from the trash bin
G90

M400
;M73 P99

;===== wipe right nozzle start =====

M1002 gcode_claim_action : 14
    G150 T220
    
M106 S255 ; turn on fan to cool the nozzle

;===== wipe left nozzle end =====

M400
;M73 P99



M400
;M73 P99

;===== bed leveling ==================================

M1002 judge_flag g29_before_print_flag

M190 S55; ensure bed temp
M109 S140 A
M106 S0 ; turn off fan , too noisy

G91
M73 P5 R13
G1 Z5 F1200
G90
G1 X175 Y160 F30000

M622 J1
    M1002 gcode_claim_action : 1
    G29.20 A3
    G29 A1 O X163.283 Y148.283 I23.4339 J23.4339 R
    M400
M623

M622 J2
    M1002 gcode_claim_action : 1
    
        G29.20 A4
        G29 A2 O X163.283 Y148.283 I23.4339 J23.4339 R
    
    M400
M623

M622 J0
    G28 R
M623

;===== bed leveling end ================================

;===== z ofst cali start =====

    M190 S55; ensure bed temp

    G383 O0 M2 T140

;===== z ofst cali end =====

G39.1 ; cali nozzle wrapped detection pos

G90
M73 P34 R9
G1 Z5 F1200
G1 X270 Y-0.5 F60000
G28.140 S0 ; cali pre-extrude z pos

M141 S0
M104 S220 A

;===== mech mode sweep start =====
    M1002 gcode_claim_action : 3

    G90
    G1 Z5 F1200
M73 P35 R9
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
    M620.17 T0 S220 L0
    M620.17 T1 S220 L0
    M620 D-1
    G383 O1 T220 L0
    M141 S0
M623

M622 J2
    M1002 gcode_claim_action : 39
    M141 S0
    M620.17 T0 S220 L0
    M620.17 T1 S220 L0
    M620 D-1
    G383.3 T220 L0
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
M1002 set_filament_type:PLA
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

M104 S220 ; rise to print tmpr

M140 S55
M190 S55

    ;========turn off light and fans =============
    M960 S1 P0 ; turn off laser
    M960 S2 P0 ; turn off laser
    M106 S0 ; turn off fan
    M106 P2 S0 ; turn off big fan
    ;==== set ext toodhead cooling fan ====
    
    M106 P9 S255
    
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
    M109 S220
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
; layer num/total_layer_count: 1/58
; update layer progress
M73 L1
M991 S0 P0 ;notify layer change

M106 S0
M106 P2 S0
; OBJECT_ID: 15
G1 X173.649 Y155.01 F60000
M204 S6000
M73 P36 R9
G1 Z.4
G1 Z.2
G1 E.8 F1800
; FEATURE: Support transition
; LINE_WIDTH: 0.42
G1 F3000
M204 S500
G2 X171.348 Y156.318 I1.255 J4.885 E.0823
G3 X171.399 Y157.399 I-2.773 J.674 E.03345
G1 X173.832 Y154.966 E.10572
G3 X175.189 Y154.849 I1.148 J5.378 E.04197
G1 X170.995 Y159.043 E.18226
G2 X170.925 Y160.354 I4.005 J.872 E.0405
G1 X176.43 Y154.849 E.23921
G1 X177.67 Y154.849 E.03811
G1 X171.167 Y161.352 E.28258
G3 X171.399 Y162.36 I-4.339 J1.53 E.03186
M73 P37 R9
G1 X178.422 Y155.337 E.30518
G1 X178.422 Y156.578 E.03811
G1 X171.774 Y163.226 E.2889
G3 X172.866 Y163.374 I.194 J2.661 E.0341
G1 X178.444 Y157.796 E.2424
G2 X178.788 Y158.693 I2.058 J-.274 E.02978
G1 X173.756 Y163.751 E.21924
G2 X174.802 Y163.919 I1.168 J-3.924 E.03265
G1 X178.93 Y159.791 E.17939
G1 X178.972 Y160.216 E.01311
G3 X178.678 Y161.284 I-12.211 J-2.789 E.03405
G1 X176.222 Y163.739 E.10672
G2 X177.259 Y163.389 I-.338 J-2.713 E.03388
G3 X177.979 Y163.222 I.653 J1.184 E.023
G1 X178.422 Y162.779 E.01925
G1 X178.422 Y163.222 E.01361
G1 X178.168 Y163.222 E.00782
; WIPE_START
G1 X178.422 Y163.222 E-.09668
G1 X178.422 Y162.779 E-.16832
G1 X177.979 Y163.222 E-.23805
G1 X177.321 Y163.375 E-.25695
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X172.889 Y163.85 Z.6 F60000
G1 Z.2
G1 E.8 F1800
; FEATURE: Brim
; LINE_WIDTH: 0.5
G1 F3000
M204 S500
G1 X172.889 Y167.901 E.15089
G1 X172.842 Y168.47 E.02127
G1 X172.6 Y169.286 E.03169
G1 X172.285 Y169.89 E.02537
G1 X171.939 Y170.337 E.02104
G1 X171.523 Y170.721 E.02109
G1 X171.048 Y171.033 E.02118
G1 X170.667 Y171.21 E.01565
G1 X170.022 Y171.413 E.02516
G1 X169.299 Y171.489 E.0271
G1 X167.099 Y171.489 E.08192
G1 X166.53 Y171.442 E.02127
G1 X165.618 Y171.159 E.03555
G1 X165.112 Y170.886 E.02144
G1 X164.664 Y170.539 E.02109
G1 X164.28 Y170.123 E.02109
G1 X163.968 Y169.648 E.02118
G1 X163.79 Y169.267 E.01566
G1 X163.588 Y168.622 E.02516
G1 X163.512 Y167.898 E.02711
G1 X163.513 Y159.954 E.29588
G1 X163.544 Y159.232 E.02691
G1 X163.638 Y158.39 E.03158
G1 X163.834 Y157.383 E.0382
G1 X163.986 Y156.814 E.02193
G1 X164.303 Y155.886 E.03652
G1 X164.71 Y154.963 E.03758
G1 X165.093 Y154.25 E.03015
G1 X165.639 Y153.402 E.03755
G1 X166.152 Y152.731 E.03146
G1 X166.825 Y151.983 E.03747
G1 X167.538 Y151.314 E.03643
G1 X168.396 Y150.644 E.04054
G1 X169.07 Y150.201 E.03004
G1 X169.886 Y149.748 E.03477
G1 X170.62 Y149.41 E.03006
G1 X171.643 Y149.038 E.04055
G1 X172.422 Y148.824 E.03012
G1 X172.94 Y148.714 E.01969
G1 X173.615 Y148.607 E.02546
G1 X174.139 Y148.551 E.01964
G1 X174.822 Y148.515 E.02548
G1 X182.901 Y148.512 E.3009
G1 X183.47 Y148.559 E.02128
G1 X184.293 Y148.803 E.03198
G1 X184.889 Y149.114 E.02502
G1 X185.336 Y149.461 E.02109
G1 X185.721 Y149.877 E.02109
G1 X186.032 Y150.351 E.02113
G1 X186.25 Y150.833 E.01969
G1 X186.413 Y151.377 E.02114
G1 X186.489 Y152.102 E.02716
G1 X186.489 Y154.301 E.08192
G1 X186.442 Y154.87 E.02127
G1 X186.197 Y155.694 E.03198
G1 X185.886 Y156.289 E.02502
G1 X185.539 Y156.737 E.02109
G1 X185.123 Y157.121 E.02109
G1 X184.649 Y157.432 E.02113
G1 X184.168 Y157.65 E.01967
G1 X183.624 Y157.813 E.02114
G1 X182.899 Y157.889 E.02716
G1 X178.895 Y157.889 E.14913
G1 X178.839 Y157.656 E.00892
G1 X178.839 Y154.689 E.11049
G1 X182.911 Y154.689 E.15164
G1 X183.096 Y154.633 E.00722
G1 X183.222 Y154.512 E.00651
G1 X183.289 Y154.311 E.0079
G1 X183.289 Y152.09 E.08272
G1 X183.233 Y151.904 E.00722
G1 X183.112 Y151.778 E.00652
G1 X182.911 Y151.711 E.0079
G1 X174.95 Y151.713 E.29651
G1 X174.083 Y151.772 E.03235
G1 X173.214 Y151.924 E.03286
G1 X172.371 Y152.165 E.03267
G1 X171.826 Y152.373 E.02171
G1 X171.277 Y152.629 E.02256
G1 X170.535 Y153.058 E.03193
G1 X169.813 Y153.582 E.03322
G1 X169.365 Y153.972 E.02212
G1 X168.857 Y154.491 E.02705
G1 X168.575 Y154.822 E.01621
G1 X168.223 Y155.29 E.02182
G1 X167.84 Y155.89 E.02647
G1 X167.555 Y156.426 E.02263
G1 X167.373 Y156.826 E.01637
G1 X167.166 Y157.369 E.02166
G1 X166.958 Y158.072 E.02728
G1 X166.795 Y158.914 E.03197
G1 X166.732 Y159.5 E.02194
G1 X166.713 Y159.943 E.01653
G1 X166.711 Y167.911 E.29676
G1 X166.727 Y167.994 E.00317
G1 X166.767 Y168.096 E.00409
G1 X166.889 Y168.222 E.00651
G1 X167.09 Y168.289 E.0079
G1 X169.311 Y168.289 E.08272
G1 X169.496 Y168.233 E.00722
G1 X169.622 Y168.112 E.00651
G1 X169.67 Y168.002 E.00447
G1 X169.689 Y167.911 E.00348
G1 X169.689 Y159.919 E.29765
G1 X169.729 Y159.274 E.02406
G1 X169.845 Y158.649 E.0237
G1 X170.071 Y157.953 E.02725
G1 X170.345 Y157.378 E.02372
G1 X170.662 Y156.881 E.02197
G1 X170.982 Y156.976 E.01244
G1 X170.982 Y157.654 E.02526
G1 X170.909 Y158.009 E.01351
G1 X170.753 Y158.387 E.01521
G1 X170.599 Y158.9 E.01996
G1 X170.509 Y159.428 E.01997
G1 X170.483 Y159.935 E.01891
G1 X170.495 Y160.247 E.01163
G1 X170.573 Y160.801 E.02081
G1 X170.727 Y161.361 E.02165
G1 X170.909 Y161.81 E.01804
G1 X170.982 Y162.163 E.01342
G1 X170.984 Y163.413 E.04658
G1 X171.033 Y163.554 E.00555
G1 X171.212 Y163.641 E.00742
G1 X172.263 Y163.644 E.03914
G1 X172.657 Y163.736 E.01505
G1 X172.835 Y163.824 E.00739
M204 S6000
G1 X172.416 Y164.198 F60000
G1 F3000
M204 S500
G1 X172.432 Y164.262 E.00243
G1 X172.432 Y167.877 E.13465
G1 X172.386 Y168.399 E.01954
G1 X172.168 Y169.126 E.02825
G1 X171.904 Y169.632 E.02125
G1 X171.593 Y170.034 E.01896
G1 X171.231 Y170.366 E.01826
G1 X170.833 Y170.627 E.01775
G1 X170.493 Y170.786 E.01399
G1 X169.942 Y170.959 E.02148
G1 X169.268 Y171.032 E.02527
G1 X167.124 Y171.032 E.07985
G1 X166.633 Y170.991 E.01836
G1 X165.784 Y170.729 E.03307
G1 X165.353 Y170.495 E.0183
G1 X164.983 Y170.208 E.01743
G1 X164.635 Y169.831 E.0191
G1 X164.373 Y169.433 E.01774
G1 X164.221 Y169.109 E.01333
G1 X164.036 Y168.515 E.02316
G1 X163.97 Y167.881 E.02374
G1 X163.97 Y159.967 E.29478
G1 X164.001 Y159.263 E.02625
G1 X164.092 Y158.453 E.03035
G1 X164.279 Y157.49 E.03654
G1 X164.425 Y156.943 E.02112
G1 X164.731 Y156.047 E.03526
G1 X165.118 Y155.168 E.03576
G1 X165.485 Y154.487 E.02881
G1 X166.011 Y153.67 E.0362
G1 X166.508 Y153.019 E.0305
G1 X167.148 Y152.308 E.03565
G1 X167.832 Y151.666 E.03493
G1 X168.658 Y151.019 E.03909
G1 X169.302 Y150.595 E.02873
G1 X170.088 Y150.158 E.03349
G1 X170.799 Y149.831 E.02913
G1 X171.776 Y149.475 E.03874
G1 X172.527 Y149.269 E.02899
G1 X173.027 Y149.163 E.01904
G1 X173.678 Y149.06 E.02456
G1 X174.178 Y149.007 E.01875
G1 X174.831 Y148.973 E.02433
G1 X182.887 Y148.969 E.30008
G1 X183.399 Y149.015 E.01912
G1 X184.108 Y149.225 E.02755
G1 X184.63 Y149.495 E.02189
G1 X185.017 Y149.792 E.01819
G1 X185.352 Y150.151 E.01826
G1 X185.624 Y150.563 E.0184
G1 X185.823 Y151.002 E.01796
G1 X185.964 Y151.48 E.01855
G1 X186.032 Y152.133 E.02445
G1 X186.031 Y154.288 E.08027
G1 X185.986 Y154.799 E.01912
G1 X185.776 Y155.508 E.02755
G1 X185.505 Y156.03 E.02189
G1 X185.193 Y156.435 E.01904
G1 X184.831 Y156.766 E.01826
G1 X184.437 Y157.025 E.01756
G1 X184.015 Y157.217 E.01726
G1 X183.521 Y157.364 E.01922
G1 X182.868 Y157.432 E.02445
G1 X179.434 Y157.432 E.12791
G1 X179.33 Y157.384 E.00426
G1 X179.296 Y157.295 E.00355
G1 X179.296 Y155.283 E.07491
G1 X179.344 Y155.179 E.00426
G1 X179.434 Y155.146 E.00355
G1 X182.901 Y155.146 E.12914
G1 X183.213 Y155.076 E.01191
G1 X183.425 Y154.951 E.00918
G1 X183.528 Y154.853 E.00529
G1 X183.661 Y154.641 E.00934
G1 X183.719 Y154.466 E.00687
G1 X183.746 Y154.3 E.00626
G1 X183.746 Y152.1 E.08193
G1 X183.724 Y151.948 E.00571
G1 X183.676 Y151.788 E.00624
G1 X183.551 Y151.575 E.00919
G1 X183.453 Y151.473 E.00529
G1 X183.24 Y151.339 E.00934
G1 X183.065 Y151.281 E.00687
G1 X182.9 Y151.254 E.00626
G1 X174.954 Y151.256 E.29593
G1 X174.059 Y151.316 E.03343
G1 X173.142 Y151.473 E.03463
G1 X172.251 Y151.724 E.03451
G1 X171.668 Y151.945 E.02321
G1 X171.044 Y152.236 E.02566
G1 X170.312 Y152.659 E.03145
G1 X169.508 Y153.241 E.037
G1 X169.035 Y153.656 E.02342
G1 X168.506 Y154.198 E.02822
G1 X168.207 Y154.55 E.01721
G1 X167.834 Y155.049 E.02318
G1 X167.458 Y155.639 E.02608
G1 X167.137 Y156.241 E.02539
G1 X166.945 Y156.666 E.01739
G1 X166.726 Y157.245 E.02303
G1 X166.509 Y157.99 E.02894
G1 X166.347 Y158.821 E.03152
G1 X166.278 Y159.447 E.02346
G1 X166.256 Y159.946 E.0186
G1 X166.254 Y167.901 E.2963
G1 X166.277 Y168.073 E.00646
G1 X166.339 Y168.254 E.0071
G1 X166.448 Y168.423 E.00751
G1 X166.548 Y168.528 E.00539
G1 X166.76 Y168.661 E.00934
G1 X166.935 Y168.719 E.00687
G1 X167.101 Y168.746 E.00626
G1 X169.301 Y168.746 E.08193
G1 X169.452 Y168.724 E.00571
G1 X169.613 Y168.676 E.00624
G1 X169.825 Y168.551 E.00918
G1 X169.93 Y168.45 E.0054
G1 X170.045 Y168.285 E.00749
G1 X170.118 Y168.089 E.00781
G1 X170.146 Y167.901 E.00709
G1 X170.146 Y161.848 E.22543
G1 X170.194 Y161.744 E.00426
G1 X170.304 Y161.713 E.00426
G1 X170.41 Y161.796 E.00505
G1 X170.473 Y161.955 E.00636
G1 X170.522 Y162.196 E.00915
G1 X170.527 Y163.403 E.04494
G1 X170.597 Y163.691 E.01103
G1 X170.7 Y163.863 E.00749
G1 X170.844 Y163.971 E.00671
G1 X170.998 Y164.045 E.00636
G1 X171.227 Y164.098 E.00874
G1 X172.194 Y164.101 E.03604
G1 X172.326 Y164.128 E.005
G1 X172.369 Y164.161 E.00203
M204 S6000
G1 X171.942 Y164.605 F60000
G1 F3000
M204 S500
G1 X171.975 Y164.694 E.00354
G1 X171.975 Y167.851 E.11757
G1 X171.936 Y168.299 E.01675
G1 X171.737 Y168.964 E.02588
G1 X171.523 Y169.374 E.01718
G1 X171.246 Y169.732 E.01687
G1 X170.958 Y169.997 E.01458
G1 X170.618 Y170.222 E.01518
G1 X170.318 Y170.362 E.01234
G1 X169.861 Y170.505 E.01783
G1 X169.236 Y170.575 E.02344
G1 X167.148 Y170.575 E.07775
G1 X166.735 Y170.541 E.01545
G1 X165.951 Y170.299 E.03056
G1 X165.613 Y170.116 E.01431
G1 X165.302 Y169.877 E.01462
M73 P38 R9
G1 X164.99 Y169.539 E.01711
G1 X164.778 Y169.217 E.01435
G1 X164.652 Y168.952 E.01096
G1 X164.49 Y168.436 E.02014
G1 X164.428 Y167.865 E.02139
G1 X164.427 Y159.98 E.29367
G1 X164.457 Y159.294 E.02558
G1 X164.545 Y158.517 E.02912
G1 X164.723 Y157.598 E.03488
G1 X164.864 Y157.071 E.0203
G1 X165.16 Y156.208 E.03399
G1 X165.527 Y155.374 E.03395
G1 X165.876 Y154.724 E.02746
G1 X166.382 Y153.937 E.03484
G1 X166.864 Y153.307 E.02954
G1 X167.471 Y152.632 E.03384
G1 X168.125 Y152.017 E.03342
G1 X168.921 Y151.394 E.03765
G1 X169.535 Y150.989 E.02741
G1 X170.291 Y150.569 E.0322
G1 X170.978 Y150.253 E.02819
G1 X171.91 Y149.913 E.03693
G1 X172.639 Y149.713 E.02816
G1 X173.114 Y149.612 E.01808
G1 X173.741 Y149.513 E.02367
G1 X174.218 Y149.463 E.01785
G1 X174.839 Y149.43 E.02318
G1 X182.873 Y149.427 E.29924
G1 X183.326 Y149.47 E.01693
G1 X183.924 Y149.647 E.02323
G1 X184.373 Y149.877 E.01878
G1 X184.7 Y150.125 E.01529
G1 X184.984 Y150.427 E.01543
G1 X185.217 Y150.776 E.01564
G1 X185.396 Y151.171 E.01617
G1 X185.515 Y151.581 E.01591
G1 X185.575 Y152.164 E.0218
G1 X185.574 Y154.262 E.07815
G1 X185.531 Y154.726 E.01738
G1 X185.353 Y155.324 E.02323
G1 X185.124 Y155.772 E.01874
G1 X184.846 Y156.132 E.01693
G1 X184.54 Y156.41 E.01541
G1 X184.206 Y156.628 E.01485
G1 X183.846 Y156.79 E.01473
G1 X183.418 Y156.915 E.01657
G1 X182.837 Y156.975 E.02177
G1 X179.891 Y156.975 E.10974
G1 X179.787 Y156.927 E.00426
G1 X179.754 Y156.837 E.00355
G1 X179.754 Y155.741 E.04086
G1 X179.801 Y155.637 E.00426
G1 X179.891 Y155.603 E.00355
G1 X183.009 Y155.59 E.11615
G1 X183.303 Y155.524 E.01123
G1 X183.453 Y155.465 E.00599
G1 X183.646 Y155.352 E.00833
G1 X183.837 Y155.188 E.00939
G1 X184.042 Y154.892 E.01338
G1 X184.15 Y154.617 E.01103
G1 X184.203 Y154.289 E.01239
G1 X184.203 Y152.11 E.08114
G1 X184.159 Y151.811 E.01127
G1 X184.064 Y151.546 E.01047
G1 X183.952 Y151.355 E.00826
G1 X183.788 Y151.163 E.00939
G1 X183.488 Y150.956 E.01356
G1 X183.131 Y150.829 E.01411
G1 X182.89 Y150.797 E.00905
G1 X174.959 Y150.798 E.29543
G1 X174.035 Y150.859 E.03449
G1 X173.072 Y151.021 E.03637
G1 X172.132 Y151.283 E.03633
G1 X171.511 Y151.515 E.02471
G1 X170.81 Y151.844 E.02881
G1 X170.09 Y152.259 E.03097
G1 X169.202 Y152.902 E.04082
G1 X168.705 Y153.34 E.02469
G1 X168.155 Y153.906 E.02939
G1 X167.839 Y154.28 E.01823
G1 X167.446 Y154.807 E.02449
G1 X167.052 Y155.429 E.02741
G1 X166.719 Y156.057 E.02648
G1 X166.516 Y156.508 E.01843
G1 X166.286 Y157.122 E.02442
G1 X166.059 Y157.909 E.03053
G1 X165.899 Y158.729 E.03109
G1 X165.824 Y159.394 E.02492
G1 X165.799 Y159.949 E.02072
G1 X165.797 Y167.891 E.2958
G1 X165.848 Y168.228 E.01269
G1 X165.961 Y168.512 E.01137
G1 X166.057 Y168.661 E.00663
G1 X166.212 Y168.837 E.00871
G1 X166.512 Y169.045 E.0136
G1 X166.869 Y169.171 E.01411
G1 X167.11 Y169.203 E.00905
G1 X169.372 Y169.197 E.08425
G1 X169.736 Y169.115 E.01391
G1 X170.048 Y168.95 E.01315
G1 X170.241 Y168.784 E.00949
G1 X170.413 Y168.555 E.01066
G1 X170.543 Y168.257 E.0121
G1 X170.597 Y167.975 E.0107
G1 X170.603 Y164.58 E.12643
G1 X170.651 Y164.476 E.00426
G1 X170.777 Y164.448 E.00479
G1 X171.118 Y164.542 E.0132
G1 X171.233 Y164.556 E.0043
G1 X171.838 Y164.557 E.02252
G1 X171.887 Y164.58 E.00203
M204 S6000
G1 X171.486 Y165.062 F60000
G1 F3000
M204 S500
G1 X171.518 Y165.15 E.00349
G1 X171.518 Y167.825 E.09963
G1 X171.486 Y168.199 E.01396
G1 X171.305 Y168.803 E.02351
G1 X171.129 Y169.136 E.01401
G1 X170.9 Y169.429 E.01387
G1 X170.666 Y169.641 E.01175
G1 X170.385 Y169.826 E.01256
G1 X170.143 Y169.938 E.0099
G1 X169.78 Y170.052 E.0142
G1 X169.203 Y170.118 E.02162
G1 X167.172 Y170.118 E.07563
G1 X166.837 Y170.091 E.01254
G1 X166.117 Y169.869 E.02804
G1 X165.854 Y169.725 E.01117
G1 X165.62 Y169.545 E.011
G1 X165.345 Y169.247 E.0151
G1 X165.183 Y169 E.01101
G1 X165.083 Y168.793 E.00859
G1 X164.938 Y168.328 E.01812
G1 X164.885 Y167.847 E.01802
G1 X164.884 Y159.993 E.29254
G1 X164.914 Y159.325 E.02491
G1 X164.998 Y158.581 E.02789
G1 X165.168 Y157.705 E.03323
G1 X165.303 Y157.2 E.01947
G1 X165.588 Y156.369 E.03272
G1 X165.936 Y155.579 E.03216
G1 X166.268 Y154.961 E.02612
G1 X166.753 Y154.205 E.03347
G1 X167.219 Y153.595 E.02858
G1 X167.794 Y152.956 E.03202
G1 X168.419 Y152.369 E.03193
G1 X169.183 Y151.769 E.03621
G1 X169.768 Y151.383 E.02609
G1 X170.493 Y150.979 E.0309
G1 X171.157 Y150.674 E.02724
G1 X172.044 Y150.351 E.03514
G1 X172.751 Y150.156 E.02731
G1 X173.201 Y150.061 E.01712
G1 X173.804 Y149.966 E.02276
G1 X174.257 Y149.918 E.01696
G1 X174.848 Y149.887 E.02203
G1 X182.858 Y149.885 E.29836
G1 X183.252 Y149.924 E.01472
G1 X183.741 Y150.07 E.01903
G1 X184.118 Y150.26 E.01571
G1 X184.401 Y150.474 E.01322
G1 X184.631 Y150.722 E.01259
G1 X184.81 Y150.989 E.012
G1 X184.962 Y151.321 E.01359
G1 X185.066 Y151.681 E.01397
G1 X185.117 Y152.18 E.01868
G1 X185.117 Y154.247 E.07698
G1 X185.076 Y154.652 E.01518
G1 X184.922 Y155.165 E.01995
G1 X184.729 Y155.536 E.01557
G1 X184.517 Y155.811 E.01294
G1 X184.268 Y156.04 E.01256
G1 X183.977 Y156.23 E.01297
G1 X183.677 Y156.363 E.0122
G1 X183.342 Y156.461 E.013
G1 X182.807 Y156.518 E.02006
G1 X180.348 Y156.518 E.09159
G1 X180.244 Y156.47 E.00426
G1 X180.211 Y156.38 E.00355
G1 X180.211 Y156.196 E.00688
G1 X180.258 Y156.092 E.00426
G1 X180.347 Y156.059 E.00353
G1 X182.998 Y156.048 E.09874
G1 X183.398 Y155.971 E.01516
G1 X183.614 Y155.892 E.00856
G1 X183.869 Y155.75 E.01087
G1 X184.129 Y155.539 E.01248
G1 X184.216 Y155.443 E.00485
G1 X184.471 Y155.048 E.01748
G1 X184.603 Y154.679 E.01461
G1 X184.66 Y154.279 E.01506
G1 X184.66 Y152.121 E.08037
G1 X184.585 Y151.645 E.01796
G1 X184.453 Y151.308 E.01348
G1 X184.292 Y151.05 E.01133
G1 X184.141 Y150.873 E.00868
G1 X183.756 Y150.585 E.01787
G1 X183.634 Y150.523 E.00511
G1 X183.18 Y150.375 E.01781
G1 X182.882 Y150.34 E.01115
G1 X174.963 Y150.341 E.29496
G1 X174.011 Y150.403 E.03553
G1 X173.003 Y150.569 E.03807
G1 X172.015 Y150.841 E.03816
G1 X171.355 Y151.085 E.0262
G1 X170.621 Y151.427 E.03016
G1 X169.867 Y151.86 E.03237
G1 X168.895 Y152.563 E.04469
G1 X168.374 Y153.025 E.02594
G1 X167.802 Y153.614 E.03058
G1 X167.47 Y154.01 E.01924
G1 X167.058 Y154.567 E.02579
G1 X166.646 Y155.219 E.02872
G1 X166.3 Y155.873 E.02759
G1 X166.087 Y156.351 E.01947
G1 X165.845 Y157 E.0258
G1 X165.609 Y157.828 E.03206
G1 X165.452 Y158.636 E.03067
G1 X165.371 Y159.338 E.02632
G1 X165.342 Y159.953 E.02291
G1 X165.34 Y167.882 E.29533
G1 X165.395 Y168.289 E.01532
G1 X165.426 Y168.403 E.00439
G1 X165.582 Y168.766 E.01473
G1 X165.72 Y168.97 E.00918
G1 X165.86 Y169.128 E.00786
G1 X166.246 Y169.416 E.01794
G1 X166.366 Y169.478 E.00502
G1 X166.82 Y169.626 E.0178
G1 X167.119 Y169.66 E.0112
G1 X169.36 Y169.654 E.08346
G1 X169.83 Y169.562 E.01783
G1 X169.958 Y169.515 E.00509
G1 X170.251 Y169.36 E.01234
G1 X170.531 Y169.137 E.01333
G1 X170.775 Y168.834 E.01451
G1 X170.834 Y168.732 E.00438
G1 X170.993 Y168.332 E.01603
G1 X171.054 Y167.965 E.01388
G1 X171.059 Y165.147 E.10493
G1 X171.107 Y165.044 E.00426
G1 X171.198 Y165.011 E.00361
G1 X171.382 Y165.013 E.00685
G1 X171.431 Y165.036 E.00203
; WIPE_START
G1 X171.518 Y165.15 E-.05423
G1 X171.518 Y167.007 E-.70577
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X176.425 Y161.161 Z.6 F60000
G1 X182.511 Y153.911 Z.6
G1 Z.2
G1 E.8 F1800
; FEATURE: Outer wall
G1 F3000
M204 S500
G1 X174.905 Y153.911 E.28328
G2 X168.911 Y159.907 I.008 J6.003 E.35066
G1 X168.911 Y167.511 E.28319
G1 X167.49 Y167.511 E.05292
G1 X167.491 Y159.959 E.28128
G3 X174.957 Y152.491 I7.61 J.143 E.43463
G1 X182.511 Y152.49 E.28135
G1 X182.511 Y153.851 E.05068
;======== H2D 20260731========
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
G1 X182.054 Y153.454 F60000
; FEATURE: Inner wall
G1 F3000
M204 S500
G1 X174.898 Y153.454 E.26651
G2 X168.454 Y159.903 I.015 J6.46 E.377
G1 X168.454 Y167.054 E.26632
G1 X167.947 Y167.054 E.01887
G1 X167.948 Y159.969 E.26389
G3 X174.965 Y152.948 I7.152 J.132 E.40857
G1 X182.054 Y152.947 E.26403
G1 X182.054 Y153.394 E.01663
; CHANGE_LAYER
; Z_HEIGHT: 0.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F3000
G1 X180.054 Y153.41 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 2/58
; update layer progress
M73 L2
M991 S0 P1 ;notify layer change

M106 S255
M106 P2 S178
; open powerlost recovery
M1003 S1
; OBJECT_ID: 15
M204 S10000
G17
G3 Z.6 I-.265 J-1.188 P1  F60000
G1 X174.046 Y154.752 Z.6
G1 Z.4
G1 E.8 F1800
; FEATURE: Support interface
; LINE_WIDTH: 0.42
G1 F1710
M204 S8000
G1 X171.399 Y157.399 E.11503
G1 X171.399 Y157.696 E.00913
G3 X170.995 Y159.043 I-32.809 J-9.102 E.04322
G1 X175.189 Y154.849 E.18226
G1 X176.43 Y154.849 E.03811
G1 X170.925 Y160.354 E.23921
G2 X171.167 Y161.352 I4.037 J-.452 E.03164
G1 X177.67 Y154.849 E.28258
G1 X178.422 Y154.849 E.02311
G1 X178.422 Y155.337 E.015
G1 X171.399 Y162.36 E.30518
M73 P39 R9
G1 X171.401 Y163.225 E.02657
G1 X171.774 Y163.226 E.01147
G1 X178.422 Y156.578 E.2889
G1 X178.444 Y157.796 E.03745
G1 X172.866 Y163.374 E.2424
G2 X173.735 Y163.745 I2.475 J-4.596 E.02908
M73 P39 R8
G1 X178.788 Y158.693 E.21955
G2 X178.904 Y159.539 I56.596 J-7.337 E.02625
G1 X178.93 Y159.791 E.00778
G1 X174.802 Y163.919 E.17939
G1 X175.378 Y163.935 E.01773
G2 X176.222 Y163.739 I-1.3 J-7.54 E.02662
G1 X178.678 Y161.284 E.10672
G2 X178.422 Y162.779 I2.323 J1.166 E.04732
G1 X177.786 Y163.416 E.02765
; WIPE_START
G1 F4800
G1 X178.422 Y162.779 E-.34199
G1 X178.422 Y162.121 E-.25038
G1 X178.511 Y161.688 E-.16763
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z.8 I.847 J-.874 P1  F60000
G1 X171.404 Y154.796 Z.8
G1 Z.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1710
M204 S8000
G1 X170.872 Y155.211 E.02238
G2 X168.709 Y159.906 I4.052 J4.713 E.17684
G1 X168.709 Y167.309 E.24557
G1 X167.693 Y167.309 E.03368
G1 X167.694 Y159.964 E.24363
G3 X174.962 Y152.694 I7.414 J.144 E.37674
G1 X182.309 Y152.693 E.24371
G1 X182.309 Y153.709 E.03368
G1 X174.906 Y153.709 E.24557
G2 X171.456 Y154.766 I.018 J6.215 E.12143
M204 S250
G1 X171.484 Y155.229 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1710
M204 S5000
G1 X171.127 Y155.508 E.01392
G2 X169.101 Y159.909 I3.796 J4.415 E.15355
G1 X169.101 Y167.701 E.23942
G1 X167.301 Y167.701 E.0553
G1 X167.302 Y159.956 E.23798
G3 X174.955 Y152.302 I7.807 J.154 E.36742
G1 X182.701 Y152.301 E.23801
G1 X182.701 Y154.101 E.0553
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X174.909 Y154.101 E.23941
G2 X171.644 Y155.112 I.014 J5.822 E.10659
G1 X171.532 Y155.193 E.00426
; WIPE_START
G1 F9547.055
M204 S8000
G1 X171.127 Y155.508 E-.19489
G1 X170.731 Y155.875 E-.20498
G1 X170.27 Y156.415 E-.26998
G1 X170.136 Y156.61 E-.09016
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.84 Y153.554 Z.8 F60000
G1 Z.4
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.589225
G1 F1710
M204 S8000
G1 X172.422 Y153.709 E.01984
G2 X168.297 Y158.868 I2.586 J6.297 E.307
; LINE_WIDTH: 0.648617
G2 X168.202 Y159.975 I7.054 J1.165 E.05489
G1 X168.201 Y167.105 E.35192
; WIPE_START
G1 F5943.568
G1 X168.201 Y165.105 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.045 Y158.022 Z.8 F60000
G1 X172.84 Y153.554 Z.8
G1 Z.4
G1 E.8 F1800
; LINE_WIDTH: 0.64464
G1 F1710
M204 S8000
G3 X174.899 Y153.203 I2.164 J6.475 E.10283
G1 X182.105 Y153.201 E.35334
; CHANGE_LAYER
; Z_HEIGHT: 0.6
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F5982.849
G1 X180.105 Y153.201 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 3/58
; update layer progress
M73 L3
M991 S0 P2 ;notify layer change

; OBJECT_ID: 15
M204 S10000
G17
G3 Z.8 I-1.083 J-.556 P1  F60000
G1 X178.592 Y156.15 Z.8
G1 Z.6
G1 E.8 F1800
; FEATURE: Support interface
; LINE_WIDTH: 0.42
G1 F1717
M204 S8000
G1 X177.291 Y154.849 E.05652
G1 X176.051 Y154.849 E.03811
G1 X178.422 Y157.221 E.10305
G2 X178.789 Y158.697 I2.184 J.242 E.04774
G1 X178.8 Y158.839 E.00436
G1 X174.812 Y154.851 E.1733
G2 X173.715 Y154.994 I.095 J5.02 E.03408
G1 X178.964 Y160.243 E.22808
G3 X178.7 Y161.22 I-12.579 J-2.865 E.0311
G1 X172.794 Y155.314 E.25664
G2 X172.007 Y155.766 I2.623 J5.48 E.02794
G1 X178.422 Y162.182 E.2788
G1 X178.422 Y163.222 E.03197
G1 X178.222 Y163.222 E.00615
G1 X171.355 Y156.355 E.29844
M73 P40 R8
G1 X171.399 Y157.639 E.0395
G1 X177.191 Y163.431 E.25169
G3 X176.253 Y163.734 I-1.298 J-2.42 E.03044
G1 X171.11 Y158.631 E.22263
G2 X170.909 Y159.63 I3.774 J1.278 E.03142
G1 X175.209 Y163.93 E.18684
G1 X174.914 Y163.922 E.00906
G3 X173.804 Y163.765 I.022 J-4.156 E.03457
G1 X171.056 Y161.018 E.1194
G3 X171.4 Y162.602 I-2.759 J1.428 E.05038
G1 X172.195 Y163.397 E.03454
; COOLING_NODE: 0
; WIPE_START
G1 F4800
G1 X171.4 Y162.602 E-.42715
G1 X171.399 Y162.12 E-.18313
G1 X171.319 Y161.734 E-.14972
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z1 I1.217 J.014 P1  F60000
G1 X171.399 Y154.8 Z1
G1 Z.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1717
M204 S8000
G1 X170.876 Y155.202 E.02187
G2 X168.709 Y159.903 I4.037 J4.712 E.17715
G1 X168.709 Y167.309 E.24565
G1 X167.695 Y167.309 E.03364
G1 X167.696 Y159.965 E.2436
G3 X174.963 Y152.696 I7.415 J.145 E.37672
G1 X182.309 Y152.695 E.24366
G1 X182.309 Y153.709 E.03364
G1 X174.906 Y153.709 E.24557
G2 X171.449 Y154.766 I.008 J6.205 E.12168
; COOLING_NODE: 0
M204 S250
G1 X171.481 Y155.23 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1448
M204 S5000
G1 X171.132 Y155.499 E.01357
G2 X169.101 Y159.908 I3.782 J4.414 E.15386
G1 X169.101 Y167.701 E.23944
G1 X167.302 Y167.701 E.05526
G1 X167.304 Y159.957 E.23795
G3 X174.956 Y152.304 I7.807 J.154 E.36741
G1 X182.701 Y152.302 E.23797
G1 X182.701 Y154.101 E.05526
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X174.909 Y154.101 E.23941
G2 X171.637 Y155.112 I.005 J5.813 E.10683
G1 X171.529 Y155.194 E.00415
; WIPE_START
G1 F9547.055
M204 S8000
G1 X171.132 Y155.499 E-.19056
G1 X170.732 Y155.875 E-.20839
G1 X170.395 Y156.255 E-.19293
G1 X170.132 Y156.61 E-.16812
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.84 Y153.555 Z1 F60000
G1 Z.6
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.587562
G1 F1717
M204 S8000
G1 X172.642 Y153.624 E.00931
G2 X168.298 Y158.866 I2.358 J6.376 E.31643
; LINE_WIDTH: 0.647364
G2 X168.202 Y159.976 I7.123 J1.174 E.05494
G1 X168.202 Y167.105 E.35115
; WIPE_START
G1 F5955.888
G1 X168.202 Y165.105 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.046 Y158.022 Z1 F60000
G1 X172.84 Y153.555 Z1
G1 Z.6
G1 E.8 F1800
; LINE_WIDTH: 0.643377
G1 F1717
M204 S8000
G3 X174.899 Y153.203 I2.163 J6.472 E.10259
G1 X182.105 Y153.202 E.3526
; CHANGE_LAYER
; Z_HEIGHT: 0.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F5995.441
G1 X180.105 Y153.202 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 4/58
; update layer progress
M73 L4
M991 S0 P3 ;notify layer change

; OBJECT_ID: 15
M204 S10000
G17
G3 Z1 I-.302 J-1.179 P1  F60000
G1 X174.046 Y154.752 Z1
G1 Z.8
G1 E.8 F1800
; FEATURE: Support interface
; LINE_WIDTH: 0.42
G1 F1706
M204 S8000
G1 X171.399 Y157.399 E.11502
G1 X171.399 Y157.696 E.00913
G3 X170.995 Y159.043 I-32.693 J-9.067 E.04322
G1 X175.189 Y154.849 E.18225
G1 X176.43 Y154.849 E.03811
G1 X170.925 Y160.354 E.23921
G2 X171.167 Y161.352 I4.04 J-.452 E.03164
G1 X177.67 Y154.849 E.28258
G1 X178.422 Y154.849 E.02311
G1 X178.422 Y155.337 E.015
G1 X171.4 Y162.36 E.30517
G1 X171.401 Y163.225 E.02657
G1 X171.774 Y163.226 E.01147
G1 X178.422 Y156.578 E.28889
M73 P41 R8
G1 X178.444 Y157.796 E.03745
G1 X172.866 Y163.374 E.24239
G2 X173.736 Y163.745 I2.256 J-4.081 E.02909
G1 X178.775 Y158.706 E.21899
G3 X178.906 Y159.561 I-6.95 J1.502 E.0266
G1 X178.93 Y159.791 E.00711
G1 X174.802 Y163.919 E.17939
G1 X175.518 Y163.938 E.02201
G1 X176.283 Y163.679 E.02482
G1 X178.678 Y161.284 E.10408
G2 X178.422 Y162.78 I2.323 J1.166 E.04732
G1 X177.81 Y163.392 E.02661
; COOLING_NODE: 0
; WIPE_START
G1 F4800
G1 X178.422 Y162.78 E-.32913
G1 X178.422 Y162.121 E-.2504
G1 X178.512 Y161.684 E-.16958
G1 X178.523 Y161.657 E-.01089
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z1.2 I.843 J-.877 P1  F60000
G1 X171.394 Y154.803 Z1.2
G1 Z.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1706
M204 S8000
G1 X170.883 Y155.196 E.02139
G2 X168.709 Y159.903 I4.031 J4.718 E.17744
G1 X168.709 Y167.309 E.24565
G1 X167.696 Y167.309 E.0336
G1 X167.697 Y159.966 E.24356
G3 X174.964 Y152.697 I7.408 J.139 E.37681
G1 X182.309 Y152.696 E.24362
G1 X182.309 Y153.709 E.0336
G1 X174.906 Y153.709 E.24557
G2 X171.444 Y154.77 I.008 J6.205 E.12188
; COOLING_NODE: 0
M204 S250
G1 X171.479 Y155.231 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1429
M204 S5000
G1 X171.138 Y155.494 E.01322
G2 X169.101 Y159.908 I3.776 J4.42 E.15413
G1 X169.101 Y167.701 E.23944
G1 X167.304 Y167.701 E.05522
G1 X167.305 Y159.958 E.23791
G3 X174.957 Y152.305 I7.801 J.147 E.3675
G1 X182.701 Y152.304 E.23793
G1 X182.701 Y154.101 E.05522
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X174.909 Y154.101 E.23941
G2 X171.632 Y155.116 I.005 J5.813 E.10701
G1 X171.527 Y155.195 E.00405
; WIPE_START
G1 F9547.055
M204 S8000
G1 X171.138 Y155.494 E-.18623
G1 X170.731 Y155.875 E-.21174
G1 X170.395 Y156.255 E-.1929
G1 X170.137 Y156.617 E-.16914
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.842 Y153.555 Z1.2 F60000
G1 Z.8
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.585899
G1 F1706
M204 S8000
G1 X172.648 Y153.623 E.0091
G2 X168.299 Y158.867 I2.357 J6.379 E.3157
; LINE_WIDTH: 0.64613
G1 X168.263 Y159.099 E.01154
G2 X168.203 Y159.977 I7.229 J.94 E.04328
G1 X168.202 Y167.105 E.35037
; WIPE_START
G1 F5968.07
G1 X168.202 Y165.105 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.047 Y158.023 Z1.2 F60000
G1 X172.842 Y153.555 Z1.2
G1 Z.8
G1 E.8 F1800
; LINE_WIDTH: 0.6421
G1 F1706
M204 S8000
G3 X174.899 Y153.204 I2.163 J6.474 E.1023
G1 X182.105 Y153.202 E.35185
; CHANGE_LAYER
; Z_HEIGHT: 1
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F6008.211
G1 X180.105 Y153.203 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 5/58
; update layer progress
M73 L5
M991 S0 P4 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z1.2 I-.218 J-1.197 P1  F60000
G1 X171.422 Y154.784 Z1.2
G1 Z1
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X171.405 Y154.796 E.00071
G2 X168.709 Y159.906 I3.51 J5.118 E.19933
G1 X168.709 Y167.309 E.24557
G1 X167.697 Y167.309 E.03356
G1 X167.698 Y159.967 E.24353
G3 X174.966 Y152.698 I7.415 J.145 E.37672
G1 X182.309 Y152.697 E.24358
G1 X182.309 Y153.709 E.03356
G1 X174.903 Y153.709 E.24566
M73 P42 R8
G2 X172.033 Y154.418 I.011 J6.206 E.09903
G1 X171.474 Y154.753 E.02162
; COOLING_NODE: 0
M204 S250
G1 X171.476 Y155.233 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X171.145 Y155.489 E.01287
G2 X169.101 Y159.909 I3.77 J4.426 E.15441
G1 X169.101 Y167.701 E.23941
G1 X167.305 Y167.701 E.05518
G1 X167.306 Y159.959 E.23788
G3 X174.959 Y152.306 I7.807 J.154 E.36741
G1 X182.701 Y152.305 E.23789
G1 X182.701 Y154.101 E.05518
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X174.908 Y154.101 E.23944
G2 X171.626 Y155.12 I.006 J5.814 E.10719
G1 X171.524 Y155.197 E.00393
; WIPE_START
G1 F9547.055
M204 S8000
G1 X171.145 Y155.489 E-.18201
G1 X170.731 Y155.875 E-.21506
G1 X170.395 Y156.255 E-.19284
G1 X170.129 Y156.615 E-.17009
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.843 Y153.556 Z1.4 F60000
G1 Z1
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.584288
G1 F1200
M204 S8000
G1 X172.662 Y153.619 E.00843
G2 X168.299 Y158.87 I2.342 J6.385 E.31554
; LINE_WIDTH: 0.644886
G2 X168.203 Y159.978 I7.085 J1.168 E.05461
G1 X168.203 Y167.105 E.34961
; WIPE_START
G1 F5980.403
G1 X168.203 Y165.105 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.048 Y158.023 Z1.4 F60000
G1 X172.843 Y153.556 Z1.4
G1 Z1
G1 E.8 F1800
; LINE_WIDTH: 0.640809
G1 F1200
M204 S8000
G3 X174.893 Y153.205 I2.159 J6.44 E.10171
G1 X182.105 Y153.203 E.3514
; CHANGE_LAYER
; Z_HEIGHT: 1.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F6021.186
G1 X180.105 Y153.203 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 6/58
; update layer progress
M73 L6
M991 S0 P5 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z1.4 I-.093 J-1.213 P1  F60000
G1 X173.536 Y153.709 Z1.4
G1 Z1.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X173.84 Y153.634 E.01039
G1 X174.126 Y153.594 E.00958
G1 X174.522 Y153.538 E.01327
G1 F8717.188
G1 X174.981 Y153.513 E.01525
G1 F7437.885
G1 X175.195 Y153.513 E.00707
G1 F6878.886
G1 X175.595 Y153.513 E.01327
G1 F5889.377
G1 X175.995 Y153.513 E.01327
G1 F4976.668
G1 X176.395 Y153.513 E.01327
G1 F4140.759
G1 X176.795 Y153.513 E.01327
G1 F3381.65
G1 X177.195 Y153.513 E.01327
G1 F2699.341
G1 X177.195 Y153.728 E.00713
G1 F2364.214
G1 X177.195 Y154.128 E.01327
G1 F1800
G1 X177.195 Y154.511 E.01269
; FEATURE: Overhang wall
G1 F3000
M204 S5000
G1 X177.195 Y158.26 E.12437
G1 F600
G3 X177.685 Y159.692 I-3.18 J1.89 E.05058
G3 X177.425 Y161.104 I-2.886 J.198 E.04812
G1 X177.195 Y161.561 E.01699
G1 X177.195 Y161.995 E.01437
G1 X176.826 Y161.995 E.01223
G3 X175.576 Y162.613 I-2.417 J-3.31 E.04649
G3 X173.494 Y162.306 I-.665 J-2.705 E.07158
G1 X172.996 Y161.995 E.01948
G1 X172.627 Y161.995 E.01225
G1 X172.627 Y161.562 E.01435
G3 X172.135 Y160.121 I3.182 J-1.89 E.05087
G3 X172.415 Y158.679 I2.854 J-.195 E.04928
G1 X172.627 Y158.267 E.01538
G1 X172.627 Y155.018 E.10775
; FEATURE: Inner wall
G1 F960.46
M204 S8000
G1 X172.627 Y154.599 E.01391
G1 F1382.952
G1 X172.627 Y154.199 E.01327
G1 F1629.045
G1 X172.627 Y153.994 E.00679
G1 F2431.696
G1 X173.172 Y153.801 E.01917
G1 F2938.299
G1 X173.478 Y153.724 E.01048
; COOLING_NODE: 0
M204 S10000
G1 X172.726 Y153.524 F60000
G1 F8843.478
M204 S8000
G1 X172.821 Y153.489 E.00336
G3 X174.974 Y153.106 I2.318 J6.789 E.07283
G1 X175.202 Y153.106 E.00755
G1 X175.602 Y153.106 E.01327
G1 F7964.899
G1 X176.002 Y153.106 E.01327
G1 F6897.221
G1 X176.402 Y153.106 E.01327
G1 F5906.343
G1 X176.802 Y153.106 E.01327
G1 F4992.265
G1 X177.202 Y153.106 E.01327
G1 F4154.987
G1 X177.602 Y153.106 E.01327
G1 F3394.509
G1 X177.602 Y153.328 E.00737
G1 F3005.227
G1 X177.602 Y153.728 E.01327
G1 F2364.214
G1 X177.602 Y154.128 E.01327
G1 F1800
G1 X177.602 Y154.511 E.01269
; FEATURE: Overhang wall
G1 F3000
M204 S5000
G1 X177.602 Y158.163 E.12116
G1 F600
G3 X177.602 Y161.658 I-2.844 J1.747 E.12201
G1 X177.602 Y162.402 E.02466
G1 X176.943 Y162.402 E.02186
G3 X174.641 Y163.09 I-2.093 J-2.805 E.08135
G3 X172.879 Y162.402 I.397 J-3.615 E.06347
G1 X172.22 Y162.402 E.02187
G1 X172.22 Y161.659 E.02465
M73 P43 R8
G3 X172.22 Y158.168 I2.849 J-1.745 E.12184
G1 X172.22 Y155.23 E.09745
; FEATURE: Inner wall
G1 F978.044
M204 S8000
G1 X172.22 Y154.793 E.01451
G1 F1404.037
G1 X172.22 Y154.393 E.01327
G1 F1906.829
G1 X172.22 Y153.993 E.01327
G1 F2285.598
G1 X172.22 Y153.725 E.00887
G1 F3059.566
G1 X172.67 Y153.546 E.01607
; COOLING_NODE: 0
; WIPE_START
G1 X172.821 Y153.489 E-.06132
G1 X173.523 Y153.285 E-.27793
G1 X174.244 Y153.157 E-.27811
G1 X174.618 Y153.131 E-.14264
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.813 Y154.325 Z1.6 F60000
G1 Z1.2
G1 E.8 F1800
G1 F8843.478
M204 S8000
G1 X170.468 Y155.583 E.06107
G2 X168.709 Y159.906 I4.464 J4.337 E.15869
G1 X168.709 Y167.309 E.24557
G1 X167.698 Y167.309 E.03352
G1 X167.699 Y159.969 E.24348
G3 X174.967 Y152.699 I7.412 J.143 E.37675
G1 X182.309 Y152.698 E.24354
G1 X182.309 Y153.709 E.03352
G1 X182.009 Y153.709 E.00995
G1 X181.609 Y153.709 E.01327
G1 F8591.709
G1 X181.209 Y153.709 E.01327
G1 F7481.333
G1 X180.809 Y153.709 E.01327
G1 F6447.757
G1 X180.409 Y153.709 E.01327
G1 F5490.981
G1 X180.009 Y153.709 E.01327
G1 F4611.005
G1 X179.609 Y153.709 E.01327
G1 F3807.829
G1 X179.209 Y153.709 E.01327
G1 F3081.453
G1 X178.809 Y153.709 E.01327
G1 F2431.876
G1 X178.409 Y153.709 E.01327
G1 F1859.1
G1 X178.009 Y153.709 E.01327
G1 F1363.124
G1 X178.009 Y154.128 E.01392
G1 F925.411
G1 X178.009 Y154.511 E.01269
; FEATURE: Overhang wall
G1 F600
M204 S5000
G1 X178.009 Y158.066 E.11795
G3 X178.009 Y161.755 I-3.156 J1.844 E.12825
G1 X178.009 Y162.809 E.03495
G1 X177.059 Y162.809 E.03149
G3 X172.762 Y162.809 I-2.149 J-2.966 E.15234
G1 X171.813 Y162.809 E.03149
G1 X171.813 Y161.755 E.03494
G3 X171.813 Y158.069 I3.151 J-1.843 E.12817
G1 X171.813 Y155.489 E.0856
; FEATURE: Inner wall
G1 F1000.291
M204 S8000
G1 X171.813 Y155.028 E.01527
G1 F1430.667
G1 X171.813 Y154.628 E.01327
G1 F1729.414
G1 X171.813 Y154.385 E.00806
; COOLING_NODE: 0
M204 S250
G1 X171.421 Y155.224 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1488
M204 S5000
G2 X169.983 Y156.833 I4.912 J5.837 E.06652
G2 X169.101 Y159.909 I4.976 J3.092 E.09959
G1 X169.101 Y167.701 E.23942
G1 X167.306 Y167.701 E.05514
G1 X167.307 Y159.96 E.23784
G3 X174.96 Y152.307 I7.805 J.152 E.36744
G1 X182.701 Y152.306 E.23785
G1 X182.701 Y153.701 E.04285
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X182.701 Y154.101 E.01229
G1 X182.401 Y154.101 E.00922
G1 X182.001 Y154.101 E.01229
G1 X181.601 Y154.101 E.01229
G1 X181.201 Y154.101 E.01229
G1 X180.801 Y154.101 E.01229
G1 X180.401 Y154.101 E.01229
G1 X180.001 Y154.101 E.01229
G1 X179.601 Y154.101 E.01229
G1 X179.201 Y154.101 E.01229
G1 X178.801 Y154.101 E.01229
G1 F1372.211
G1 X178.401 Y154.101 E.01229
G1 F951.512
G1 X178.401 Y154.142 E.00126
G1 F912.73
G1 X178.401 Y154.511 E.01134
; FEATURE: Overhang wall
; LINE_WIDTH: 0.45
G1 F600
G1 X178.401 Y157.973 E.11486
G3 X178.401 Y161.848 I-3.509 J1.938 E.13416
G1 X178.401 Y163.201 E.04486
G1 X177.172 Y163.201 E.04076
G3 X172.649 Y163.201 I-2.261 J-3.324 E.15933
G1 X171.421 Y163.201 E.04076
G1 X171.421 Y161.848 E.04486
G3 X171.421 Y157.974 I3.507 J-1.937 E.13413
G1 X171.421 Y155.79 E.07244
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1011.967
G1 X171.421 Y155.318 E.01451
G1 F1045.516
G1 X171.421 Y155.284 E.00104
M204 S10000
G1 X170.729 Y154.704 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.576795
G1 F6743.162
M204 S8000
G2 X168.516 Y157.967 I4.388 J5.359 E.17392
; LINE_WIDTH: 0.640047
G1 F6028.875
G2 X168.204 Y159.979 I6.592 J2.052 E.09943
G1 X168.203 Y167.105 E.34674
; WIPE_START
G1 X168.204 Y165.105 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z1.6 I.513 J1.104 P1  F60000
G1 X177.346 Y160.857 Z1.6
G1 Z1.2
G1 E.8 F1800
; FEATURE: Bridge
; LINE_WIDTH: 0.4488
G1 F3000
M204 S8000
G1 X177.346 Y159.687 E.0387
G2 X176.94 Y158.496 I-3.106 J.393 E.04191
M73 P44 R8
G1 X176.94 Y161.326 E.09361
G2 X176.861 Y161.661 I.293 J.246 E.01182
G1 X176.733 Y161.661 E.00425
G1 X176.534 Y161.781 E.00768
G1 X176.534 Y153.846 E.26244
G1 X176.128 Y153.847 E.01342
G1 X176.128 Y162.027 E.27056
G3 X175.722 Y162.213 I-.756 J-1.111 E.01484
G1 X175.722 Y153.847 E.27672
G1 X175.317 Y153.847 E.01342
G1 X175.317 Y162.318 E.28018
G3 X174.911 Y162.36 I-.489 J-2.739 E.01351
G1 X174.911 Y153.853 E.28138
G1 X174.505 Y153.881 E.01346
G1 X174.505 Y162.321 E.27915
G1 X174.099 Y162.216 E.01387
G1 X174.099 Y153.93 E.27405
G2 X173.693 Y154.009 I.366 J2.944 E.01369
G1 X173.693 Y162.031 E.2653
G1 X173.287 Y161.782 E.01574
G1 X173.287 Y154.117 E.2535
G2 X172.96 Y154.224 I.669 J2.594 E.01139
G1 X172.96 Y158.346 E.13632
G1 X172.881 Y158.502 E.00577
G1 X172.881 Y161.326 E.09341
G3 X172.475 Y160.139 I2.706 J-1.588 E.04177
G1 X172.475 Y158.959 E.03904
; WIPE_START
G1 X172.475 Y160.139 E-.44852
G1 X172.575 Y160.649 E-.19752
G1 X172.685 Y160.928 E-.11395
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z1.6 I1.161 J-.365 P1  F60000
G1 X170.729 Y154.704 Z1.6
G1 Z1.2
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.532171
G1 F7358.189
M204 S8000
G3 X171.102 Y154.392 I9.103 J10.493 E.01938
; LINE_WIDTH: 0.486215
G1 F8121.013
G1 X171.293 Y154.24 E.00884
; LINE_WIDTH: 0.444061
G1 F8974.404
G1 X171.488 Y154.091 E.008
; LINE_WIDTH: 0.40702
G1 F9887.417
G1 X171.587 Y154.018 E.00366
; LINE_WIDTH: 0.379353
G1 F10700.513
G1 X171.686 Y153.945 E.00338
; LINE_WIDTH: 0.349607
G1 F11738.381
G1 X171.787 Y153.874 E.00307
; LINE_WIDTH: 0.317774
G1 F13097.864
G1 X171.887 Y153.802 E.00275
; LINE_WIDTH: 0.300623
G1 F13969.583
G1 X172.009 Y153.599 E.00499
; WIPE_START
G1 X171.887 Y153.802 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X177.805 Y153.204 Z1.6 F60000
G1 Z1.2
G1 E.8 F1800
; LINE_WIDTH: 0.645927
G1 F5970.08
M204 S8000
G1 X182.105 Y153.203 E.21129
; CHANGE_LAYER
; Z_HEIGHT: 1.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F5970.08
G1 X180.105 Y153.204 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 7/58
; update layer progress
M73 L7
M991 S0 P6 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z1.6 I-.095 J-1.213 P1  F60000
G1 X173.503 Y153.719 Z1.6
G1 Z1.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2468
M204 S8000
G1 X173.842 Y153.636 E.01157
G3 X174.983 Y153.515 I1.264 J6.489 E.03811
G1 X177.195 Y153.514 E.07338
G1 X177.195 Y158.26 E.15742
G3 X177.686 Y159.7 I-2.972 J1.818 E.05089
G3 X177.431 Y161.093 I-2.815 J.204 E.04748
G1 X177.195 Y161.561 E.01739
G1 X177.195 Y161.995 E.01437
G1 X176.827 Y161.995 E.0122
G3 X175.577 Y162.613 I-2.419 J-3.315 E.04648
G3 X173.495 Y162.307 I-.665 J-2.715 E.07156
G1 X172.996 Y161.995 E.01954
G1 X172.627 Y161.995 E.01225
G1 X172.627 Y161.563 E.01432
G3 X172.135 Y160.121 I3.183 J-1.89 E.05091
G3 X172.415 Y158.679 I2.786 J-.208 E.04929
G1 X172.627 Y158.267 E.01538
G1 X172.627 Y153.996 E.14167
G3 X173.173 Y153.802 I2.479 J6.129 E.01921
G1 X173.445 Y153.734 E.00931
; COOLING_NODE: 0
M204 S10000
G1 X172.726 Y153.525 F60000
G1 F2468
M204 S8000
G1 X172.822 Y153.491 E.00337
G3 X174.975 Y153.108 I2.319 J6.789 E.07284
G1 X177.602 Y153.107 E.08712
G1 X177.602 Y158.163 E.16772
G3 X177.602 Y161.658 I-2.844 J1.747 E.12201
G1 X177.602 Y162.402 E.02466
G1 X176.943 Y162.402 E.02183
G3 X174.641 Y163.09 I-2.095 J-2.811 E.08137
G3 X172.879 Y162.402 I.37 J-3.546 E.0635
G1 X172.22 Y162.402 E.02187
G1 X172.22 Y161.659 E.02462
G3 X172.22 Y158.168 I2.858 J-1.746 E.12183
G1 X172.22 Y153.727 E.14731
G1 X172.671 Y153.547 E.0161
; COOLING_NODE: 0
; WIPE_START
G1 F8843.478
G1 X172.822 Y153.491 E-.06142
G1 X173.525 Y153.286 E-.27818
G1 X174.245 Y153.159 E-.27786
G1 X174.619 Y153.133 E-.14254
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.813 Y154.325 Z1.8 F60000
G1 Z1.4
G1 E.8 F1800
G1 F2468
M204 S8000
G1 X170.603 Y155.449 E.05476
G2 X168.709 Y159.906 I4.321 J4.468 E.16502
G1 X168.709 Y167.309 E.24557
G1 X167.699 Y167.309 E.03348
G1 X167.701 Y159.97 E.24345
G3 X174.968 Y152.701 I7.408 J.139 E.3768
G1 X182.309 Y152.699 E.2435
G1 X182.309 Y153.709 E.03348
G1 X178.009 Y153.709 E.14264
G1 X178.009 Y158.066 E.14456
G3 X178.009 Y161.755 I-3.168 J1.844 E.12821
G1 X178.009 Y162.809 E.03495
G1 X177.06 Y162.809 E.03147
G3 X172.762 Y162.809 I-2.149 J-2.967 E.15235
G1 X171.813 Y162.809 E.03149
G1 X171.813 Y161.756 E.03493
G3 X171.813 Y158.069 I3.152 J-1.843 E.12818
G1 X171.813 Y154.385 E.1222
; COOLING_NODE: 0
M204 S250
G1 X171.421 Y155.224 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1546
M204 S5000
G2 X169.983 Y156.833 I4.914 J5.84 E.06651
G2 X169.101 Y159.909 I4.973 J3.091 E.09961
G1 X169.101 Y167.701 E.23942
G1 X167.307 Y167.701 E.05511
G1 X167.309 Y159.961 E.23781
G3 X174.961 Y152.309 I7.801 J.148 E.36749
G1 X182.701 Y152.307 E.23782
G1 X182.701 Y154.101 E.05511
G1 X178.401 Y154.101 E.13213
G1 X178.401 Y157.973 E.11899
G3 X178.401 Y161.848 I-3.523 J1.938 E.12424
G1 X178.401 Y163.201 E.04156
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X177.172 Y163.201 E.03775
G3 X172.649 Y163.201 I-2.261 J-3.324 E.14759
G1 X171.421 Y163.201 E.03776
G1 X171.421 Y161.848 E.04155
G3 X171.421 Y157.974 I3.507 J-1.937 E.12425
G1 X171.421 Y155.284 E.08265
M204 S10000
G1 X170.73 Y154.705 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.530372
G1 F2468
M204 S8000
G3 X171.103 Y154.393 I9.135 J10.533 E.0193
; LINE_WIDTH: 0.48447
M73 P45 R8
G1 X171.294 Y154.241 E.00877
; LINE_WIDTH: 0.442306
G1 X171.489 Y154.092 E.008
; LINE_WIDTH: 0.405181
G1 X171.588 Y154.018 E.00364
; LINE_WIDTH: 0.3775
G1 X171.687 Y153.945 E.00336
; LINE_WIDTH: 0.347723
G1 X171.788 Y153.874 E.00305
; LINE_WIDTH: 0.315904
G1 X171.888 Y153.803 E.00273
; LINE_WIDTH: 0.298885
G1 X172.01 Y153.6 E.00494
M204 S10000
G1 X170.73 Y154.705 F60000
; LINE_WIDTH: 0.576997
G1 F2468
M204 S8000
G2 X168.426 Y158.284 I4.355 J5.335 E.18834
; LINE_WIDTH: 0.640215
G1 X168.362 Y158.548 E.01324
G2 X168.205 Y159.98 I6.693 J1.461 E.07024
G1 X168.204 Y167.105 E.34679
; WIPE_START
G1 F6027.176
G1 X168.204 Y165.105 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z1.8 I.987 J.712 P1  F60000
G1 X174.911 Y155.809 Z1.8
G1 Z1.4
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.433119
G1 F2468
M204 S8000
G2 X174.911 Y158.434 I779.838 J1.25 E.08346
M204 S10000
G1 X175.108 Y160.365 F60000
; LINE_WIDTH: 0.423171
G1 F2468
M204 S8000
G1 X175.277 Y160.27 E.006
G1 X175.399 Y159.994 E.00934
G1 X175.397 Y159.852 E.00439
G1 X175.308 Y159.577 E.00895
G1 X174.979 Y158.819 E.02563
G1 X174.911 Y158.494 E.01028
G1 X174.844 Y158.819 E.01028
G1 X174.516 Y159.576 E.02557
G1 X174.419 Y159.878 E.00982
G1 X174.485 Y160.188 E.00982
G1 X174.604 Y160.309 E.00525
G1 X174.823 Y160.394 E.00729
G1 X175.048 Y160.371 E.00702
M204 S10000
G1 X175.364 Y160.658 F60000
; LINE_WIDTH: 0.41999
G1 F2468
M204 S8000
G1 X175.572 Y160.532 E.00749
G1 X175.776 Y160.032 E.01659
G2 X175.707 Y159.539 I-1.222 J-.08 E.01541
G3 X175.346 Y158.726 I3.998 J-2.258 E.02738
G1 X175.294 Y158.308 E.01292
G1 X175.294 Y155.415 E.08891
G1 X174.54 Y155.451 E.02319
G1 X174.527 Y158.315 E.08802
G1 X174.477 Y158.727 E.01275
G1 X174.18 Y159.405 E.02275
G1 X174.039 Y159.885 E.01534
G1 X174.133 Y160.328 E.01392
G1 X174.231 Y160.523 E.00671
G1 X174.645 Y160.745 E.01444
G1 X175.047 Y160.774 E.01238
G1 X175.307 Y160.679 E.00851
M204 S10000
G1 X175.558 Y160.981 F60000
G1 F2468
M204 S8000
G1 X175.868 Y160.794 E.0111
G1 X176.12 Y160.234 E.01887
G2 X176.106 Y159.527 I-1.587 J-.322 E.02192
G1 X175.819 Y158.916 E.02074
G1 X175.676 Y158.426 E.01569
G1 X175.671 Y155.038 E.10409
G2 X174.15 Y155.142 I-.317 J6.521 E.04695
G1 X174.15 Y158.315 E.0975
G1 X174.111 Y158.636 E.00991
G2 X173.682 Y159.712 I5.557 J2.836 E.03566
G1 X173.666 Y159.94 E.00701
G1 X173.769 Y160.431 E.0154
G1 X173.942 Y160.788 E.0122
G1 X174.393 Y161.049 E.016
G1 X174.712 Y161.147 E.01027
G1 X175.187 Y161.13 E.01459
G1 X175.503 Y161.003 E.01045
M204 S10000
G1 X175.644 Y161.37 F60000
G1 F2468
M204 S8000
G1 X176.163 Y161.056 E.01865
G1 X176.482 Y160.35 E.0238
G2 X176.528 Y159.841 I-2.27 J-.465 E.01574
G1 X176.468 Y159.418 E.01313
G1 X176.156 Y158.746 E.02276
G1 X176.052 Y158.392 E.01133
G1 X176.048 Y154.661 E.11465
G2 X174.441 Y154.702 I-.511 J11.54 E.04945
G1 X173.773 Y154.831 E.0209
G1 X173.773 Y158.315 E.10705
G1 X173.745 Y158.544 E.00708
G2 X173.32 Y159.606 I5.305 J2.737 E.03519
G1 X173.279 Y159.898 E.00906
G1 X173.353 Y160.397 E.01551
G1 X173.654 Y161.053 E.02216
G1 X174.139 Y161.351 E.0175
G1 X174.668 Y161.524 E.01712
G1 X175.264 Y161.499 E.01831
G1 X175.587 Y161.389 E.01048
M204 S10000
G1 X176.143 Y161.949 F60000
G1 F2468
M204 S8000
G1 X176.673 Y161.63 E.019
G1 X176.802 Y161.57 E.00439
G1 X176.819 Y161.436 E.00415
G1 X177.204 Y160.582 E.02879
G2 X177.282 Y159.833 I-1.742 J-.56 E.02329
G1 X177.23 Y159.37 E.01433
G2 X176.823 Y158.393 I-3.423 J.854 E.03264
G1 X176.802 Y158.308 E.00268
G1 X176.802 Y153.906 E.13526
G1 X174.996 Y153.907 E.0555
G1 X174.342 Y153.953 E.02014
G1 X173.493 Y154.118 E.02658
G1 X173.019 Y154.273 E.01534
G1 X173.019 Y158.315 E.1242
G1 X172.738 Y158.914 E.02031
G1 X172.546 Y159.567 E.02092
G1 X172.521 Y159.928 E.01112
G1 X172.619 Y160.589 E.02054
G1 X172.999 Y161.43 E.02836
G1 X173.054 Y161.602 E.00555
G2 X174.183 Y162.187 I5.887 J-9.985 E.03909
G1 X174.58 Y162.277 E.01252
G1 X175.195 Y162.283 E.01888
G1 X175.765 Y162.133 E.01811
G1 X176.089 Y161.975 E.01109
M204 S10000
G1 X176.704 Y160.775 F60000
G1 F2468
M204 S8000
G1 X176.843 Y160.466 E.01041
G1 X176.907 Y159.979 E.0151
G2 X176.862 Y159.451 I-2.583 J-.045 E.01631
G2 X176.443 Y158.448 I-5.304 J1.625 E.03346
G1 X176.425 Y158.308 E.00431
G1 X176.425 Y154.284 E.12367
G1 X175.009 Y154.284 E.04351
G1 X174.392 Y154.327 E.01903
G1 X173.588 Y154.483 E.02514
G1 X173.396 Y154.546 E.00622
G1 X173.396 Y158.315 E.11581
G1 X173.335 Y158.572 E.00809
G1 X173.09 Y159.054 E.01661
G1 X172.919 Y159.634 E.01858
G2 X172.986 Y160.493 I2.984 J.2 E.02658
G1 X173.336 Y161.261 E.02593
G1 X173.419 Y161.352 E.00378
G1 X173.966 Y161.687 E.01973
G1 X174.445 Y161.86 E.01563
G2 X175.34 Y161.868 I.47 J-2.5 E.02766
G1 X175.812 Y161.709 E.01528
G1 X176.462 Y161.317 E.02333
G1 X176.679 Y160.83 E.01638
; WIPE_START
G1 F9547.299
G1 X176.462 Y161.317 E-.2026
G1 X175.812 Y161.709 E-.28851
G1 X175.34 Y161.868 E-.18902
G1 X175.131 Y161.886 E-.07987
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z1.8 I1.163 J.358 P1  F60000
G1 X177.805 Y153.204 Z1.8
G1 Z1.4
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.644697
G1 F2468
M204 S8000
G1 X182.105 Y153.204 E.21086
; CHANGE_LAYER
; Z_HEIGHT: 1.6
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F5982.284
G1 X180.105 Y153.204 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 8/58
; update layer progress
M73 L8
M991 S0 P7 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z1.8 I-.095 J-1.213 P1  F60000
G1 X173.504 Y153.72 Z1.8
G1 Z1.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2465
M204 S8000
G1 X173.842 Y153.637 E.01158
G3 X174.984 Y153.516 I1.264 J6.489 E.03812
G1 X177.195 Y153.516 E.07334
G1 X177.195 Y158.254 E.15717
G3 X177.689 Y159.737 I-3.135 J1.869 E.05226
G3 X177.43 Y161.094 I-2.814 J.167 E.0463
G1 X177.195 Y161.561 E.01738
G1 X177.195 Y161.995 E.01437
G1 X176.825 Y161.995 E.01224
G3 X175.581 Y162.612 I-2.407 J-3.288 E.04629
G3 X173.499 Y162.31 I-.671 J-2.703 E.07158
G1 X172.996 Y161.995 E.01968
G1 X172.627 Y161.995 E.01225
G1 X172.627 Y161.564 E.01428
G3 X172.135 Y160.12 I3.185 J-1.891 E.05095
G3 X172.415 Y158.679 I2.947 J-.177 E.04923
G1 X172.627 Y158.266 E.01538
G1 X172.627 Y153.998 E.14161
G3 X173.174 Y153.804 I2.48 J6.128 E.01925
G1 X173.445 Y153.735 E.00929
; COOLING_NODE: 0
M204 S10000
G1 X172.727 Y153.527 F60000
G1 F2465
M204 S8000
G1 X172.823 Y153.492 E.00339
G3 X174.977 Y153.109 I2.318 J6.789 E.07283
G1 X177.602 Y153.108 E.08708
G1 X177.602 Y158.159 E.16752
G3 X178.014 Y160.653 I-2.964 J1.771 E.08586
G3 X177.602 Y161.658 I-3.676 J-.92 E.03617
G1 X177.602 Y162.402 E.02466
G1 X176.942 Y162.402 E.02187
G3 X174.744 Y163.097 I-2.111 J-2.85 E.07791
G3 X172.879 Y162.402 I.255 J-3.532 E.06691
G1 X172.22 Y162.402 E.02187
G1 X172.22 Y161.66 E.0246
G3 X172.22 Y158.168 I2.863 J-1.746 E.12184
G1 X172.22 Y153.729 E.14724
G1 X172.671 Y153.549 E.01612
; COOLING_NODE: 0
; WIPE_START
G1 F8843.478
G1 X172.823 Y153.492 E-.06162
G1 X173.526 Y153.287 E-.27817
G1 X174.246 Y153.16 E-.27787
G1 X174.62 Y153.134 E-.14233
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.813 Y154.325 Z2 F60000
G1 Z1.6
G1 E.8 F1800
G1 F2465
M204 S8000
G1 X170.603 Y155.449 E.05477
G2 X168.709 Y159.906 I4.331 J4.472 E.16499
G1 X168.709 Y167.309 E.24557
G1 X167.701 Y167.309 E.03344
G1 X167.702 Y159.971 E.24341
G3 X174.969 Y152.702 I7.415 J.146 E.37671
G1 X182.309 Y152.701 E.24346
G1 X182.309 Y153.709 E.03344
G1 X178.009 Y153.709 E.14264
G1 X178.009 Y158.064 E.14446
G3 X178.009 Y161.755 I-3.161 J1.846 E.12834
G1 X178.009 Y162.809 E.03495
G1 X177.059 Y162.809 E.03149
G3 X172.762 Y162.809 I-2.149 J-2.969 E.15231
G1 X171.813 Y162.809 E.03149
G1 X171.813 Y161.756 E.03492
G3 X171.813 Y158.069 I3.174 J-1.843 E.12813
G1 X171.813 Y154.385 E.1222
; COOLING_NODE: 0
M204 S250
G1 X171.421 Y155.224 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1612
M204 S5000
G2 X169.983 Y156.833 I4.915 J5.84 E.06651
G2 X169.101 Y159.909 I4.976 J3.092 E.09961
G1 X169.101 Y167.701 E.23941
G1 X167.309 Y167.701 E.05507
G1 X167.31 Y159.963 E.23777
G3 X174.962 Y152.31 I7.807 J.154 E.36741
G1 X182.701 Y152.309 E.23778
M73 P45 R7
G1 X182.701 Y154.101 E.05507
G1 X178.401 Y154.101 E.13213
G1 X178.401 Y157.972 E.11896
G3 X178.401 Y161.848 I-3.511 J1.938 E.1243
G1 X178.401 Y163.201 E.04156
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

M73 P46 R7
G1 X177.172 Y163.201 E.03775
G3 X172.649 Y163.201 I-2.261 J-3.328 E.14757
G1 X171.421 Y163.201 E.03776
G1 X171.421 Y161.849 E.04155
G3 X171.421 Y157.974 I3.534 J-1.937 E.12419
G1 X171.421 Y155.284 E.08265
M204 S10000
G1 X170.731 Y154.705 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.528553
G1 F2465
M204 S8000
G3 X171.104 Y154.393 I9.116 J10.509 E.01924
; LINE_WIDTH: 0.482689
G1 X171.294 Y154.242 E.0087
; LINE_WIDTH: 0.440544
G1 X171.49 Y154.092 E.00798
; LINE_WIDTH: 0.403359
G1 X171.589 Y154.019 E.00362
; LINE_WIDTH: 0.37569
G1 X171.688 Y153.946 E.00335
; LINE_WIDTH: 0.345902
G1 X171.788 Y153.874 E.00304
; LINE_WIDTH: 0.314018
G1 X171.889 Y153.803 E.00272
; LINE_WIDTH: 0.29694
G1 X172.009 Y153.602 E.00484
M204 S10000
G1 X170.731 Y154.705 F60000
; LINE_WIDTH: 0.573394
G1 F2465
M204 S8000
G2 X168.518 Y157.967 I4.379 J5.354 E.17281
; LINE_WIDTH: 0.637496
G1 X168.364 Y158.544 E.0289
G2 X168.205 Y159.981 I6.766 J1.475 E.07018
G1 X168.205 Y167.105 E.34517
; WIPE_START
G1 F6054.744
G1 X168.205 Y165.105 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.671 Y158.915 Z2 F60000
G1 X174.911 Y155.81 Z2
G1 Z1.6
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.43313
G1 F2465
M204 S8000
G2 X174.911 Y158.43 I386.91 J1.249 E.0833
M204 S10000
G1 X174.948 Y159.846 F60000
; LINE_WIDTH: 0.63362
G1 F2465
M204 S8000
G2 X174.955 Y159.962 I-.033 J.06 E.01417
M204 S10000
G1 X175.279 Y160.271 F60000
; LINE_WIDTH: 0.42312
G1 F2465
M204 S8000
G1 X175.409 Y159.921 E.01157
G1 X175.311 Y159.584 E.01087
G1 X174.977 Y158.804 E.02629
G1 X174.911 Y158.49 E.00995
G3 X174.679 Y159.255 I-2.464 J-.33 E.02486
G1 X174.448 Y159.768 E.01745
G1 X174.421 Y159.977 E.00653
G1 X174.531 Y160.251 E.00916
G1 X174.839 Y160.392 E.01048
G1 X175.02 Y160.399 E.00562
G1 X175.225 Y160.298 E.00709
M204 S10000
G1 X175.243 Y160.715 F60000
; LINE_WIDTH: 0.41999
G1 F2465
M204 S8000
G1 X175.574 Y160.533 E.01161
G1 X175.779 Y160.039 E.01644
G1 X175.785 Y159.948 E.0028
G1 X175.699 Y159.544 E.01269
G3 X175.345 Y158.712 I4.636 J-2.469 E.0278
G1 X175.294 Y158.301 E.01273
G1 X175.294 Y155.416 E.08864
G1 X174.542 Y155.452 E.02314
G1 X174.527 Y155.81 E.01103
G1 X174.527 Y158.315 E.07696
G1 X174.479 Y158.715 E.01238
G1 X174.178 Y159.409 E.02323
G1 X174.04 Y159.862 E.01457
G1 X174.072 Y160.123 E.00808
G1 X174.224 Y160.509 E.01273
G1 X174.674 Y160.738 E.01551
G1 X174.925 Y160.786 E.00787
G1 X175.184 Y160.728 E.00816
M204 S10000
G1 X175.304 Y161.098 F60000
G1 F2465
M204 S8000
G1 X175.869 Y160.794 E.01971
G1 X176.116 Y160.254 E.01826
G2 X176.125 Y159.648 I-1.086 J-.318 E.01885
G2 X175.711 Y158.621 I-6.397 J1.983 E.03407
G1 X175.671 Y158.301 E.0099
G1 X175.671 Y155.039 E.10023
G2 X174.15 Y155.144 I-.316 J6.516 E.04695
G1 X174.15 Y158.315 E.09745
G1 X174.113 Y158.626 E.00963
G2 X173.673 Y159.723 I6.434 J3.217 E.03635
G1 X173.679 Y160.135 E.01264
G2 X173.937 Y160.778 I2.638 J-.685 E.02135
G1 X174.42 Y161.059 E.01717
G1 X174.903 Y161.166 E.01521
G1 X175.244 Y161.108 E.01064
M204 S10000
G1 X175.684 Y161.35 F60000
G1 F2465
M204 S8000
G1 X176.164 Y161.056 E.01729
G1 X176.475 Y160.376 E.02298
G2 X176.525 Y159.668 I-1.696 J-.474 E.02197
G2 X176.076 Y158.53 I-6.186 J1.779 E.03764
G1 X176.048 Y158.301 E.00707
G1 X176.048 Y154.662 E.11182
G2 X174.442 Y154.703 I-.51 J11.528 E.0494
G1 X173.773 Y154.833 E.02095
G1 X173.773 Y158.315 E.107
G1 X173.747 Y158.537 E.00688
G2 X173.301 Y159.652 I6.022 J3.057 E.03693
G1 X173.292 Y160.063 E.01263
G1 X173.421 Y160.559 E.01574
G1 X173.65 Y161.047 E.01657
G1 X174.272 Y161.409 E.02213
G1 X174.822 Y161.539 E.01736
G1 X175.278 Y161.501 E.01406
G1 X175.628 Y161.371 E.01145
M204 S10000
G1 X176.179 Y161.931 F60000
G1 F2465
M204 S8000
G1 X176.669 Y161.63 E.01768
G1 X176.802 Y161.568 E.00451
G1 X176.82 Y161.434 E.00414
G1 X177.193 Y160.62 E.02753
G1 X177.286 Y160.103 E.01614
G1 X177.269 Y159.525 E.01775
G1 X177.088 Y158.923 E.01932
G1 X176.822 Y158.384 E.01846
G1 X176.802 Y158.301 E.00263
G1 X176.802 Y153.908 E.13499
G1 X174.997 Y153.908 E.05546
G1 X174.344 Y153.954 E.02014
G1 X173.495 Y154.119 E.02657
G1 X173.019 Y154.275 E.01538
G1 X173.019 Y158.315 E.12415
G2 X172.555 Y159.509 I3.982 J2.233 E.03948
G1 X172.541 Y160.131 E.01912
G1 X172.566 Y160.371 E.00741
G2 X172.999 Y161.432 I3.775 J-.922 E.03533
G1 X173.054 Y161.602 E.00551
G3 X173.977 Y162.11 I-5.442 J10.984 E.03238
G1 X174.585 Y162.278 E.01939
G1 X175.129 Y162.282 E.01669
G1 X175.595 Y162.201 E.01453
G1 X176.124 Y161.956 E.01793
M204 S10000
G1 X176.691 Y160.809 F60000
G1 F2465
M204 S8000
G1 X176.872 Y160.331 E.0157
G2 X176.897 Y159.596 I-2.081 J-.438 E.0227
G2 X176.484 Y158.551 I-3.34 J.716 E.03469
G1 X176.425 Y158.301 E.0079
G1 X176.425 Y154.285 E.1234
G1 X175.011 Y154.285 E.04347
G1 X174.393 Y154.328 E.01902
G1 X173.59 Y154.484 E.02514
G1 X173.396 Y154.548 E.00627
G1 X173.396 Y158.315 E.11575
G1 X173.335 Y158.571 E.00809
G1 X173.09 Y159.052 E.01658
G1 X172.928 Y159.58 E.01697
G1 X172.916 Y160.092 E.01573
G2 X173.357 Y161.313 I3.894 J-.716 E.04005
G1 X174.125 Y161.76 E.0273
G1 X174.649 Y161.905 E.01672
G1 X175.152 Y161.902 E.01546
G1 X175.48 Y161.841 E.01023
G2 X176.462 Y161.315 I-1.719 J-4.393 E.0343
G1 X176.667 Y160.864 E.01524
; WIPE_START
G1 F9547.299
G1 X176.462 Y161.315 E-.1885
G1 X175.982 Y161.61 E-.21384
G1 X175.48 Y161.841 E-.21011
G1 X175.152 Y161.902 E-.12648
G1 X175.097 Y161.902 E-.02106
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X177.366 Y154.615 Z2 F60000
G1 X177.805 Y153.205 Z2
G1 Z1.6
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.643457
G1 F2465
M204 S8000
G1 X182.105 Y153.205 E.21042
; CHANGE_LAYER
; Z_HEIGHT: 1.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F5994.637
G1 X180.105 Y153.205 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 9/58
; update layer progress
M73 L9
M991 S0 P8 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z2 I-.095 J-1.213 P1  F60000
G1 X173.504 Y153.722 Z2
G1 Z1.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2462
M204 S8000
G1 X173.844 Y153.638 E.01161
G3 X174.985 Y153.517 I1.265 J6.49 E.03812
G1 X177.195 Y153.517 E.0733
G1 X177.195 Y158.26 E.15734
G3 X177.687 Y159.716 I-2.966 J1.814 E.05142
G3 X177.407 Y161.142 I-2.803 J.19 E.04875
G1 X177.195 Y161.555 E.01541
G1 X177.195 Y161.995 E.01458
G1 X176.832 Y161.995 E.01203
G3 X175.875 Y162.521 I-2.739 J-3.842 E.03631
G3 X173.499 Y162.31 I-.964 J-2.616 E.08177
G1 X172.996 Y161.995 E.01968
G1 X172.627 Y161.995 E.01225
G1 X172.627 Y161.561 E.01437
G3 X172.13 Y160.031 I2.937 J-1.8 E.05387
G3 X172.414 Y158.679 I2.868 J-.102 E.04628
G1 X172.627 Y158.267 E.0154
G1 X172.627 Y153.999 E.14155
G3 X173.175 Y153.805 I2.481 J6.129 E.01929
G1 X173.446 Y153.737 E.00926
; COOLING_NODE: 0
M204 S10000
G1 X172.728 Y153.528 F60000
G1 F2462
M204 S8000
G1 X172.824 Y153.493 E.00341
G3 X174.978 Y153.11 I2.319 J6.789 E.07284
G1 X177.602 Y153.11 E.08704
G1 X177.602 Y158.163 E.16763
G3 X177.602 Y161.654 I-2.847 J1.745 E.12183
G1 X177.602 Y162.402 E.02481
G1 X176.947 Y162.402 E.02172
G3 X175.287 Y163.079 I-2.25 J-3.14 E.06
G3 X173.29 Y162.659 I-.375 J-3.175 E.06891
G1 X172.879 Y162.402 E.01609
G1 X172.22 Y162.402 E.02187
G1 X172.22 Y161.658 E.02466
G3 X172.22 Y158.168 I2.855 J-1.745 E.1218
G1 X172.22 Y153.731 E.14719
G1 X172.672 Y153.55 E.01615
; COOLING_NODE: 0
; WIPE_START
G1 F8843.478
G1 X172.824 Y153.493 E-.0618
G1 X173.527 Y153.288 E-.27828
G1 X174.247 Y153.161 E-.27786
G1 X174.62 Y153.135 E-.14207
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.813 Y154.325 Z2.2 F60000
G1 Z1.8
G1 E.8 F1800
G1 F2462
M204 S8000
G1 X170.603 Y155.449 E.05478
G2 X168.709 Y159.906 I4.331 J4.471 E.16498
G1 X168.709 Y167.309 E.24557
G1 X167.702 Y167.309 E.0334
G1 X167.703 Y159.97 E.24342
G3 X174.971 Y152.703 I7.408 J.141 E.37675
G1 X182.309 Y152.702 E.24342
G1 X182.309 Y153.709 E.0334
G1 X178.009 Y153.709 E.14264
G1 X178.009 Y158.066 E.14456
G3 X178.009 Y161.752 I-3.179 J1.843 E.12808
G1 X178.009 Y162.809 E.03504
G1 X177.062 Y162.809 E.0314
G3 X172.762 Y162.809 I-2.15 J-2.971 E.15241
G1 X171.813 Y162.809 E.03149
G1 X171.813 Y161.755 E.03495
G3 X171.813 Y158.069 I3.172 J-1.843 E.1281
G1 X171.813 Y154.385 E.12221
; COOLING_NODE: 0
M204 S250
G1 X171.421 Y155.224 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1677
M204 S5000
G2 X169.983 Y156.833 I4.916 J5.841 E.06652
G2 X169.101 Y159.909 I4.977 J3.092 E.09959
G1 X169.101 Y167.701 E.23941
G1 X167.31 Y167.701 E.05503
G1 X167.311 Y159.963 E.23774
G3 X174.964 Y152.311 I7.801 J.148 E.36747
G1 X182.701 Y152.31 E.23774
G1 X182.701 Y154.101 E.05503
M73 P47 R7
G1 X178.401 Y154.101 E.13213
G1 X178.401 Y157.973 E.11899
G3 X178.401 Y161.847 I-3.54 J1.937 E.12416
G1 X178.401 Y163.201 E.04159
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X177.173 Y163.201 E.03773
G3 X172.649 Y163.201 I-2.262 J-3.327 E.14761
G1 X171.421 Y163.201 E.03776
G1 X171.421 Y161.848 E.04156
G3 X171.421 Y157.974 I3.533 J-1.937 E.12418
G1 X171.421 Y155.284 E.08265
M204 S10000
G1 X170.731 Y154.706 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.526867
G1 F2462
M204 S8000
G3 X171.104 Y154.394 I9.099 J10.487 E.01918
; LINE_WIDTH: 0.480917
G1 X171.295 Y154.242 E.00871
; LINE_WIDTH: 0.438719
G1 X171.49 Y154.093 E.00793
; LINE_WIDTH: 0.401631
G1 X171.589 Y154.02 E.00359
; LINE_WIDTH: 0.374059
G1 X171.688 Y153.947 E.00332
; LINE_WIDTH: 0.344265
G1 X171.789 Y153.875 E.00303
; LINE_WIDTH: 0.312258
G1 X171.89 Y153.803 E.00271
; LINE_WIDTH: 0.295192
G1 X172.009 Y153.604 E.00479
M204 S10000
G1 X170.731 Y154.706 F60000
; LINE_WIDTH: 0.571727
G1 F2462
M204 S8000
G2 X168.518 Y157.968 I4.389 J5.359 E.17222
; LINE_WIDTH: 0.636225
G2 X168.206 Y159.979 I6.54 J2.045 E.09879
G1 X168.205 Y167.105 E.34451
; WIPE_START
G1 F6067.707
G1 X168.205 Y165.105 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.671 Y158.916 Z2.2 F60000
G1 X174.911 Y155.812 Z2.2
G1 Z1.8
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.43312
G1 F2462
M204 S8000
G2 X174.911 Y158.434 I820.48 J1.248 E.08337
M204 S10000
G1 X175.117 Y160.362 F60000
; LINE_WIDTH: 0.423391
G1 F2462
M204 S8000
G1 X175.275 Y160.273 E.00561
G1 X175.398 Y159.982 E.00982
G2 X175.338 Y159.637 I-.704 J-.055 E.01096
G3 X174.911 Y158.494 I3.09 J-1.806 E.03801
G1 X174.855 Y158.782 E.00912
G2 X174.422 Y159.858 I13.653 J6.112 E.03595
G1 X174.472 Y160.162 E.00956
G1 X174.576 Y160.278 E.00483
G1 X174.852 Y160.395 E.00928
G1 X175.057 Y160.369 E.00641
M204 S10000
G1 X175.367 Y160.658 F60000
; LINE_WIDTH: 0.41999
G1 F2462
M204 S8000
G1 X175.569 Y160.536 E.00724
G1 X175.766 Y160.077 E.01537
G2 X175.707 Y159.54 I-1.095 J-.152 E.01675
G3 X175.339 Y158.695 I3.602 J-2.074 E.02838
G1 X175.294 Y158.308 E.01197
G1 X175.294 Y155.417 E.08883
G1 X174.543 Y155.453 E.0231
G1 X174.527 Y155.812 E.01103
G1 X174.527 Y158.315 E.07692
G1 X174.484 Y158.697 E.0118
G2 X174.045 Y159.801 I12.007 J5.414 E.03653
G1 X174.085 Y160.207 E.01253
G1 X174.225 Y160.51 E.01024
G1 X174.681 Y160.739 E.01568
G1 X175.044 Y160.774 E.01121
G1 X175.31 Y160.678 E.00871
M204 S10000
G1 X175.561 Y160.981 F60000
G1 F2462
M204 S8000
G1 X175.863 Y160.799 E.01083
G1 X176.116 Y160.247 E.01867
G1 X176.151 Y159.85 E.01225
G1 X176.104 Y159.519 E.01027
G1 X175.813 Y158.903 E.02094
G1 X175.676 Y158.426 E.01524
G1 X175.671 Y155.04 E.10402
G2 X174.15 Y155.145 I-.315 J6.51 E.04695
G1 X174.15 Y158.315 E.0974
G1 X174.116 Y158.612 E.00918
G2 X173.688 Y159.665 I15.433 J6.894 E.03495
G1 X173.67 Y160.083 E.01283
G2 X173.938 Y160.779 I2.218 J-.454 E.02303
G1 X174.413 Y161.056 E.0169
G1 X174.746 Y161.148 E.0106
G1 X175.186 Y161.13 E.01354
G1 X175.505 Y161.003 E.01054
M204 S10000
G1 X175.649 Y161.368 F60000
G1 F2462
M204 S8000
G1 X176.157 Y161.063 E.01822
G1 X176.477 Y160.365 E.02358
G2 X176.466 Y159.409 I-1.962 J-.455 E.02965
G1 X176.149 Y158.733 E.02294
G1 X176.052 Y158.392 E.01088
G1 X176.048 Y154.663 E.11458
G2 X174.443 Y154.704 I-.51 J11.522 E.04937
G1 X173.773 Y154.834 E.02098
G1 X173.773 Y158.315 E.10695
G1 X173.686 Y158.71 E.01243
G1 X173.349 Y159.441 E.02474
G1 X173.291 Y159.869 E.01327
G1 X173.336 Y160.317 E.01384
G2 X173.652 Y161.048 I3.123 J-.914 E.02453
G1 X174.266 Y161.407 E.02183
G1 X174.693 Y161.525 E.01362
G1 X175.263 Y161.499 E.01753
G1 X175.592 Y161.387 E.0107
M204 S10000
G1 X175.662 Y161.768 F60000
G1 F2462
M204 S8000
G1 X176.4 Y161.357 E.02598
G1 X176.477 Y161.271 E.00354
G1 X176.837 Y160.482 E.02664
G1 X176.907 Y159.966 E.01602
G2 X176.86 Y159.445 I-2.53 J-.036 E.01609
G2 X176.44 Y158.437 I-5.508 J1.702 E.03359
G1 X176.425 Y158.308 E.00399
G1 X176.425 Y154.286 E.12359
G1 X175.012 Y154.286 E.04343
G1 X174.394 Y154.33 E.01903
G1 X173.591 Y154.486 E.02514
G1 X173.396 Y154.55 E.0063
G1 X173.396 Y158.315 E.1157
G1 X173.314 Y158.618 E.00964
G1 X172.989 Y159.322 E.02384
G1 X172.912 Y159.691 E.01156
G1 X172.917 Y160.17 E.01471
G1 X173.052 Y160.673 E.016
G1 X173.336 Y161.258 E.02
G1 X173.423 Y161.351 E.00392
G1 X174.118 Y161.757 E.02472
G1 X174.64 Y161.901 E.01664
G1 X175.154 Y161.907 E.01581
G1 X175.604 Y161.784 E.01432
M204 S10000
G1 X176.143 Y161.951 F60000
G1 F2462
M204 S8000
G1 X176.678 Y161.629 E.01919
G1 X176.802 Y161.575 E.00416
G1 X176.82 Y161.428 E.00457
G1 X177.198 Y160.6 E.02796
G1 X177.286 Y160.173 E.01341
G2 X177.072 Y158.888 I-3.159 J-.134 E.04031
G1 X176.82 Y158.388 E.0172
G1 X176.802 Y158.308 E.0025
G1 X176.802 Y153.909 E.13518
G1 X174.999 Y153.909 E.05543
G1 X174.345 Y153.955 E.02014
G1 X173.496 Y154.12 E.02658
G1 X173.019 Y154.276 E.01542
G1 X173.019 Y158.315 E.1241
G3 X172.628 Y159.204 I-15.375 J-6.234 E.02983
G1 X172.535 Y159.654 E.01414
G1 X172.54 Y160.213 E.01718
G1 X172.701 Y160.81 E.019
G1 X172.999 Y161.428 E.02107
G1 X173.054 Y161.602 E.00562
G3 X173.97 Y162.107 I-5.891 J11.774 E.03215
G1 X174.587 Y162.278 E.01965
G1 X175.191 Y162.284 E.01857
G1 X175.77 Y162.131 E.01839
G1 X176.089 Y161.977 E.0109
; WIPE_START
G1 F9547.299
G1 X175.77 Y162.131 E-.13477
G1 X175.191 Y162.284 E-.22744
G1 X174.587 Y162.278 E-.22963
G1 X174.16 Y162.16 E-.16817
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X177.038 Y155.091 Z2.2 F60000
G1 X177.805 Y153.206 Z2.2
G1 Z1.8
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.642227
G1 F2462
M204 S8000
G1 X182.105 Y153.205 E.20999
; CHANGE_LAYER
; Z_HEIGHT: 2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F6006.942
G1 X180.105 Y153.205 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 10/58
; update layer progress
M73 L10
M991 S0 P9 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z2.2 I-.095 J-1.213 P1  F60000
G1 X173.504 Y153.723 Z2.2
G1 Z2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2462
M204 S8000
G1 X173.845 Y153.639 E.01165
G3 X174.986 Y153.518 I1.264 J6.489 E.03811
G1 X177.195 Y153.518 E.07326
G1 X177.195 Y158.267 E.15752
G3 X177.693 Y159.983 I-2.851 J1.759 E.06001
G3 X177.195 Y161.555 I-3.299 J-.182 E.05529
G1 X177.195 Y161.995 E.01458
G1 X176.832 Y161.995 E.01203
G3 X175.868 Y162.524 I-2.722 J-3.813 E.03658
G3 X173.494 Y162.307 I-.956 J-2.622 E.08168
G1 X172.996 Y161.995 E.0195
G1 X172.627 Y161.995 E.01225
G1 X172.627 Y161.561 E.01437
G3 X172.13 Y160.031 I2.937 J-1.8 E.05387
G3 X172.368 Y158.778 I2.794 J-.118 E.04271
G1 X172.627 Y158.254 E.01938
G1 X172.627 Y154.001 E.14107
G3 X173.177 Y153.806 I2.482 J6.127 E.01935
G1 X173.446 Y153.738 E.00921
; COOLING_NODE: 0
M204 S10000
G1 X172.728 Y153.53 F60000
G1 F2462
M204 S8000
G1 X172.826 Y153.494 E.00345
G3 X174.979 Y153.111 I2.318 J6.79 E.07282
G1 X177.602 Y153.111 E.087
G1 X177.602 Y158.168 E.16775
G3 X177.602 Y161.654 I-2.809 J1.743 E.12179
G1 X177.602 Y162.402 E.02481
G1 X176.947 Y162.402 E.02172
G3 X175.286 Y163.079 I-2.249 J-3.138 E.06006
G3 X173.287 Y162.657 I-.371 J-3.189 E.06896
G1 X172.879 Y162.402 E.01596
G1 X172.22 Y162.402 E.02187
G1 X172.22 Y161.658 E.02466
G3 X171.999 Y158.607 I2.834 J-1.739 E.10545
G1 X172.22 Y158.159 E.01659
G1 X172.22 Y153.733 E.14682
G1 X172.673 Y153.552 E.01617
; COOLING_NODE: 0
; WIPE_START
G1 F8843.478
G1 X172.826 Y153.494 E-.06231
G1 X173.529 Y153.289 E-.27806
G1 X174.249 Y153.162 E-.27796
G1 X174.621 Y153.136 E-.14167
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.813 Y154.325 Z2.4 F60000
G1 Z2
G1 E.8 F1800
G1 F2462
M204 S8000
G1 X170.603 Y155.449 E.05478
G2 X168.709 Y159.906 I4.331 J4.471 E.16498
G1 X168.709 Y167.309 E.24557
G1 X167.703 Y167.309 E.03335
G1 X167.704 Y159.973 E.24335
G3 X174.972 Y152.704 I7.408 J.14 E.37678
G1 X182.309 Y152.703 E.24338
G1 X182.309 Y153.709 E.03335
G1 X178.009 Y153.709 E.14264
G1 X178.009 Y158.069 E.14465
G3 X178.009 Y161.752 I-3.167 J1.841 E.12801
G1 X178.009 Y162.809 E.03504
G1 X177.062 Y162.809 E.0314
G3 X172.762 Y162.809 I-2.15 J-2.97 E.15241
G1 X171.813 Y162.809 E.03149
G1 X171.813 Y161.755 E.03495
G3 X171.813 Y158.064 I3.183 J-1.846 E.12827
G1 X171.813 Y154.385 E.12202
; COOLING_NODE: 0
M204 S250
G1 X171.421 Y155.224 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1736
M204 S5000
G2 X169.983 Y156.833 I4.913 J5.838 E.06652
G2 X169.101 Y159.909 I4.95 J3.084 E.09961
M73 P48 R7
G1 X169.101 Y167.701 E.23941
G1 X167.311 Y167.701 E.05499
G1 X167.312 Y159.965 E.23769
G3 X174.965 Y152.312 I7.801 J.148 E.36749
G1 X182.701 Y152.311 E.2377
G1 X182.701 Y154.101 E.05499
G1 X178.401 Y154.101 E.13213
G1 X178.401 Y157.974 E.11902
G3 X178.401 Y161.847 I-3.531 J1.937 E.12415
G1 X178.401 Y163.201 E.04159
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X177.173 Y163.201 E.03773
G3 X172.649 Y163.201 I-2.262 J-3.326 E.14761
G1 X171.421 Y163.201 E.03776
G1 X171.421 Y161.848 E.04156
G3 X171.421 Y157.972 I3.537 J-1.938 E.12424
G1 X171.421 Y155.284 E.08259
M204 S10000
G1 X170.732 Y154.706 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.525126
G1 F2462
M204 S8000
G3 X171.105 Y154.394 I9.136 J10.532 E.0191
; LINE_WIDTH: 0.479255
G1 X171.296 Y154.243 E.00866
; LINE_WIDTH: 0.437053
G1 X171.491 Y154.093 E.00791
; LINE_WIDTH: 0.399885
G1 X171.59 Y154.02 E.00358
; LINE_WIDTH: 0.372264
G1 X171.689 Y153.947 E.00331
; LINE_WIDTH: 0.342484
G1 X171.79 Y153.875 E.00301
; LINE_WIDTH: 0.310565
G1 X171.89 Y153.804 E.00269
; LINE_WIDTH: 0.293521
G1 X172.01 Y153.605 E.00474
M204 S10000
G1 X170.732 Y154.706 F60000
; LINE_WIDTH: 0.570704
G1 F2462
M204 S8000
G2 X168.488 Y158.071 I4.382 J5.354 E.17651
; LINE_WIDTH: 0.635417
G2 X168.206 Y159.982 I6.682 J1.96 E.09361
G1 X168.206 Y167.105 E.34389
; WIPE_START
G1 F6075.981
G1 X168.206 Y165.105 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.672 Y158.916 Z2.4 F60000
G1 X174.911 Y155.813 Z2.4
G1 Z2
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.433139
G1 F2462
M204 S8000
G3 X174.91 Y158.43 I-386.521 J1.247 E.08322
M204 S10000
G1 X175.106 Y160.366 F60000
; LINE_WIDTH: 0.423092
G1 F2462
M204 S8000
G1 X175.275 Y160.273 E.00601
G1 X175.404 Y159.962 E.01041
G1 X175.33 Y159.625 E.01071
G3 X174.91 Y158.49 I3.085 J-1.787 E.03765
G1 X174.845 Y158.804 E.00994
G1 X174.513 Y159.578 E.02608
G1 X174.43 Y159.91 E.0106
G1 X174.474 Y160.165 E.00803
G1 X174.52 Y160.257 E.00318
G1 X174.799 Y160.394 E.00965
G1 X175.046 Y160.372 E.00766
M204 S10000
G1 X175.367 Y160.658 F60000
; LINE_WIDTH: 0.41999
G1 F2462
M204 S8000
G1 X175.569 Y160.536 E.00726
G1 X175.767 Y160.071 E.01552
G1 X175.784 Y159.973 E.00305
G1 X175.688 Y159.497 E.01494
G3 X175.342 Y158.715 I2.941 J-1.769 E.02632
G1 X175.294 Y158.301 E.01282
G1 X175.294 Y155.419 E.08856
G1 X174.545 Y155.454 E.02305
G1 X174.527 Y155.813 E.01104
G1 X174.527 Y158.313 E.07681
G1 X174.477 Y158.712 E.01238
G2 X174.054 Y159.782 I5.567 J2.819 E.0354
G1 X174.08 Y160.194 E.01266
G1 X174.231 Y160.522 E.01112
G1 X174.644 Y160.745 E.0144
G1 X175.043 Y160.774 E.01229
G1 X175.31 Y160.678 E.00874
M204 S10000
G1 X175.561 Y160.981 F60000
; LINE_WIDTH: 0.41999
G1 F2462
M204 S8000
G1 X175.863 Y160.799 E.01084
G1 X176.114 Y160.252 E.01849
G1 X176.163 Y159.993 E.0081
G1 X176.066 Y159.423 E.01779
G3 X175.708 Y158.627 I3.58 J-2.089 E.02687
G1 X175.671 Y158.301 E.01007
G1 X175.671 Y155.042 E.10015
G2 X174.15 Y155.147 I-.315 J6.504 E.04696
G1 X174.15 Y158.31 E.0972
G1 X174.111 Y158.621 E.00963
G2 X173.677 Y159.727 I5.587 J2.829 E.03656
G1 X173.7 Y160.221 E.0152
G2 X173.943 Y160.788 I2.449 J-.715 E.019
G1 X174.404 Y161.054 E.01634
G1 X174.709 Y161.147 E.00982
G1 X175.186 Y161.129 E.01466
G1 X175.505 Y161.003 E.01054
M204 S10000
G1 X175.649 Y161.368 F60000
; LINE_WIDTH: 0.41999
G1 F2462
M204 S8000
G1 X176.157 Y161.062 E.01822
G1 X176.475 Y160.371 E.02339
G1 X176.54 Y160.013 E.01116
G1 X176.468 Y159.42 E.01838
G1 X176.151 Y158.742 E.02297
G1 X176.052 Y158.394 E.01112
G1 X176.048 Y154.664 E.11461
G2 X174.445 Y154.705 I-.509 J11.517 E.04932
G1 X173.773 Y154.836 E.02103
G1 X173.773 Y158.308 E.10667
G1 X173.745 Y158.53 E.00688
G2 X173.301 Y159.671 I5.414 J2.765 E.03771
G1 X173.296 Y160.141 E.01443
G2 X173.655 Y161.054 I2.681 J-.526 E.03029
G1 X174.147 Y161.355 E.01775
G1 X174.664 Y161.524 E.01671
G1 X175.263 Y161.499 E.0184
G1 X175.592 Y161.387 E.01069
M204 S10000
G1 X176.143 Y161.951 F60000
; LINE_WIDTH: 0.41999
G1 F2462
M204 S8000
G1 X176.678 Y161.629 E.01918
G1 X176.802 Y161.575 E.00416
G1 X176.82 Y161.428 E.00457
G1 X177.196 Y160.607 E.02774
G1 X177.293 Y160.053 E.01728
G2 X177.127 Y159.029 I-3.536 J.048 E.03201
G1 X176.823 Y158.401 E.02143
G1 X176.802 Y158.301 E.00313
G1 X176.802 Y153.91 E.13491
G1 X175 Y153.91 E.05539
G1 X174.346 Y153.956 E.02013
G1 X173.497 Y154.121 E.02659
G1 X173.019 Y154.278 E.01546
G1 X173.019 Y158.302 E.12365
G1 X172.732 Y158.927 E.02113
G1 X172.547 Y159.56 E.02027
G1 X172.541 Y160.219 E.02025
G1 X172.695 Y160.793 E.01823
G1 X172.999 Y161.428 E.02165
G1 X173.054 Y161.602 E.00561
G2 X174.182 Y162.187 I5.774 J-9.769 E.03906
G1 X174.574 Y162.277 E.01238
G1 X175.188 Y162.284 E.01886
G1 X175.772 Y162.13 E.01855
G1 X176.089 Y161.977 E.01083
M204 S10000
G1 X176.696 Y160.793 F60000
G1 F2462
M204 S8000
G1 X176.836 Y160.489 E.01028
G1 X176.916 Y160.033 E.01422
G1 X176.861 Y159.5 E.01648
G1 X176.74 Y159.07 E.01372
G1 X176.487 Y158.572 E.01717
G1 X176.425 Y158.301 E.00853
G1 X176.425 Y154.287 E.12333
G1 X175.013 Y154.288 E.0434
G1 X174.396 Y154.331 E.01902
G1 X173.592 Y154.487 E.02515
G1 X173.396 Y154.551 E.00634
G1 X173.396 Y158.305 E.11534
G1 X173.318 Y158.59 E.00909
G1 X173.085 Y159.064 E.01624
G1 X172.924 Y159.616 E.01766
G1 X172.919 Y160.18 E.01734
G1 X173.051 Y160.67 E.01559
G1 X173.336 Y161.258 E.02008
G1 X173.424 Y161.355 E.00402
G1 X173.975 Y161.692 E.01985
G1 X174.44 Y161.859 E.01517
G2 X175.339 Y161.868 I.474 J-2.475 E.02779
G1 X175.817 Y161.707 E.01549
G1 X176.458 Y161.322 E.02299
G1 X176.671 Y160.848 E.01596
; WIPE_START
G1 F9547.299
G1 X176.458 Y161.322 E-.19743
G1 X175.817 Y161.707 E-.28427
G1 X175.339 Y161.868 E-.19158
G1 X175.112 Y161.888 E-.08672
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X177.373 Y154.598 Z2.4 F60000
G1 X177.805 Y153.206 Z2.4
G1 Z2
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.640997
G1 F2462
M204 S8000
G1 X182.105 Y153.206 E.20956
; CHANGE_LAYER
; Z_HEIGHT: 2.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F6019.297
G1 X180.105 Y153.206 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 11/58
; update layer progress
M73 L11
M991 S0 P10 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z2.4 I-.095 J-1.213 P1  F60000
G1 X173.504 Y153.725 Z2.4
G1 Z2.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1963
M204 S8000
G1 X173.846 Y153.641 E.01168
G3 X174.987 Y153.52 I1.264 J6.489 E.03812
G1 X177.195 Y153.519 E.07321
G1 X177.195 Y158.267 E.15748
G3 X177.693 Y159.983 I-2.852 J1.759 E.06001
G3 X177.195 Y161.555 I-3.292 J-.179 E.0553
G1 X177.195 Y161.995 E.01458
G1 X176.832 Y161.995 E.01203
G3 X175.86 Y162.527 I-2.705 J-3.785 E.03684
G3 X173.499 Y162.31 I-.95 J-2.62 E.08125
G1 X172.996 Y161.995 E.01968
G1 X172.627 Y161.995 E.01225
G1 X172.627 Y161.568 E.01415
G3 X172.13 Y160.031 I3.102 J-1.852 E.05403
G3 X172.627 Y158.267 I3.323 J-.016 E.06161
G1 X172.627 Y154.003 E.14144
G3 X173.178 Y153.807 I2.483 J6.127 E.0194
G1 X173.446 Y153.739 E.00918
; COOLING_NODE: 0
M204 S10000
G1 X172.729 Y153.531 F60000
G1 F1963
M204 S8000
G1 X172.827 Y153.496 E.00346
G3 X174.98 Y153.113 I2.319 J6.789 E.07283
G1 X177.602 Y153.112 E.08696
G1 X177.602 Y158.168 E.16771
G3 X177.602 Y161.654 I-2.801 J1.743 E.12182
G1 X177.602 Y162.402 E.02481
G1 X176.947 Y162.402 E.02172
G3 X175.286 Y163.079 I-2.249 J-3.138 E.06005
G3 X173.29 Y162.659 I-.371 J-3.19 E.06884
G1 X172.879 Y162.402 E.01609
G1 X172.22 Y162.402 E.02187
G1 X172.22 Y161.663 E.02451
G3 X171.807 Y159.172 I2.966 J-1.771 E.08575
G3 X172.22 Y158.168 I3.811 J.981 E.03611
G1 X172.22 Y153.734 E.14707
G1 X172.673 Y153.553 E.01619
; COOLING_NODE: 0
; WIPE_START
G1 F8843.478
G1 X172.827 Y153.496 E-.0624
G1 X173.53 Y153.291 E-.27823
G1 X174.25 Y153.164 E-.27783
G1 X174.621 Y153.138 E-.14154
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.813 Y154.325 Z2.6 F60000
G1 Z2.2
G1 E.8 F1800
G1 F1963
M204 S8000
G1 X170.603 Y155.448 E.05476
G2 X168.709 Y159.906 I4.331 J4.472 E.16501
G1 X168.709 Y167.309 E.24557
G1 X167.704 Y167.309 E.03331
G1 X167.706 Y159.974 E.24331
G3 X174.973 Y152.706 I7.415 J.146 E.37669
G1 X182.309 Y152.704 E.24334
G1 X182.309 Y153.709 E.03331
G1 X178.009 Y153.709 E.14264
M73 P49 R7
G1 X178.009 Y158.069 E.14465
G3 X178.009 Y161.752 I-3.157 J1.842 E.12804
G1 X178.009 Y162.809 E.03504
G1 X177.062 Y162.809 E.0314
G3 X172.762 Y162.809 I-2.15 J-2.976 E.15238
G1 X171.813 Y162.809 E.03149
G1 X171.813 Y161.758 E.03486
G3 X171.813 Y158.069 I3.177 J-1.844 E.12819
G1 X171.813 Y154.385 E.1222
; COOLING_NODE: 0
M204 S250
G1 X171.421 Y155.224 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1791
M204 S5000
G2 X169.969 Y156.855 I4.89 J5.814 E.06733
G2 X169.101 Y159.909 I4.962 J3.061 E.0988
G1 X169.101 Y167.701 E.23941
G1 X167.312 Y167.701 E.05496
G1 X167.313 Y159.966 E.23766
G3 X174.966 Y152.313 I7.807 J.155 E.3674
G1 X182.701 Y152.312 E.23767
G1 X182.701 Y154.101 E.05496
G1 X178.401 Y154.101 E.13213
G1 X178.401 Y157.974 E.11902
G3 X178.401 Y161.847 I-3.52 J1.937 E.12418
G1 X178.401 Y163.201 E.04159
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X177.173 Y163.201 E.03773
G3 X172.649 Y163.201 I-2.262 J-3.333 E.14758
G1 X171.421 Y163.201 E.03776
G1 X171.421 Y161.849 E.04153
G3 X171.421 Y157.974 I3.534 J-1.938 E.12421
G1 X171.421 Y155.284 E.08265
M204 S10000
G1 X170.733 Y154.707 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.52341
G1 F1963
M204 S8000
G3 X171.106 Y154.395 I9.12 J10.513 E.01903
; LINE_WIDTH: 0.477481
G1 X171.297 Y154.243 E.00864
; LINE_WIDTH: 0.435308
G1 X171.492 Y154.094 E.00786
; LINE_WIDTH: 0.398162
G1 X171.591 Y154.02 E.00357
; LINE_WIDTH: 0.370505
G1 X171.69 Y153.947 E.00329
; LINE_WIDTH: 0.340718
G1 X171.791 Y153.876 E.00299
; LINE_WIDTH: 0.308778
G1 X171.891 Y153.804 E.00267
; LINE_WIDTH: 0.29189
G1 X172.01 Y153.607 E.00467
; WIPE_START
G1 F14459.622
G1 X171.891 Y153.804 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.975 Y154.254 Z2.6 F60000
G1 Z2.2
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F1963
M204 S8000
G1 X172.975 Y155.882 E.05401
G1 X173.09 Y156.069 E.00729
G1 X173.203 Y156.724 E.02206
G3 X172.975 Y157.244 I-.653 J.023 E.01948
G1 X172.975 Y158.35 E.03668
G2 X172.569 Y160.557 I2.448 J1.592 E.0764
G1 X172.689 Y160.655 E.00515
G1 X173.09 Y161.31 E.02548
G1 X173.154 Y161.683 E.01254
G2 X174.853 Y162.341 I1.844 J-2.24 E.06146
G2 X175.749 Y160.328 I-.96 J-1.634 E.07801
G2 X174.691 Y159.345 I-2.846 J2.004 E.04827
G3 X174.251 Y157.707 I1.419 J-1.259 E.05832
G3 X175.309 Y156.724 I2.846 J2.004 E.04827
G2 X175.749 Y155.086 I-1.419 J-1.259 E.05832
G2 X174.691 Y154.104 I-2.846 J2.004 E.04827
G1 X174.565 Y153.898 E.00799
G3 X176.838 Y153.868 I1.356 J16.282 E.07546
G2 X176.846 Y154.321 I.546 J.216 E.01543
G1 X176.846 Y158.35 E.13366
G1 X176.97 Y158.593 E.00904
G1 X176.797 Y159.345 E.0256
G2 X177.326 Y160.159 I1.251 J-.235 E.03305
G3 X176.846 Y161.472 I-4.018 J-.725 E.04659
G1 X176.846 Y161.646 E.00579
G1 X176.802 Y161.646 E.00147
; WIPE_START
G1 F8843.478
G1 X176.846 Y161.646 E-.01684
G1 X176.846 Y161.472 E-.06636
G1 X177.245 Y160.601 E-.36387
G1 X177.326 Y160.159 E-.17081
G1 X177.071 Y159.886 E-.14212
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X181.665 Y153.791 Z2.6 F60000
G1 X182.105 Y153.207 Z2.6
G1 Z2.2
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.639767
G1 F1963
M204 S8000
G1 X177.805 Y153.207 E.20913
; WIPE_START
G1 F6031.702
G1 X179.805 Y153.207 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.275 Y154.452 Z2.6 F60000
G1 X170.733 Y154.707 Z2.6
G1 Z2.2
G1 E.8 F1800
; LINE_WIDTH: 0.569018
G1 F1963
M204 S8000
G2 X168.489 Y158.071 I4.368 J5.345 E.17593
; LINE_WIDTH: 0.634147
G2 X168.207 Y159.983 I6.534 J1.939 E.09347
G1 X168.207 Y167.105 E.3431
; CHANGE_LAYER
; Z_HEIGHT: 2.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F6089.034
G1 X168.207 Y165.105 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 12/58
; update layer progress
M73 L12
M991 S0 P11 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z2.6 I1.103 J.514 P1  F60000
G1 X173.505 Y153.726 Z2.6
G1 Z2.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1930
M204 S8000
G1 X173.848 Y153.642 E.01172
G3 X174.989 Y153.521 I1.264 J6.49 E.0381
G1 X177.195 Y153.521 E.07317
G1 X177.195 Y158.254 E.15701
G3 X177.689 Y159.737 I-3.132 J1.868 E.05225
G3 X177.425 Y161.104 I-2.863 J.157 E.04667
G1 X177.195 Y161.561 E.01699
G1 X177.195 Y161.995 E.01437
G1 X176.831 Y161.995 E.01205
G3 X175.85 Y162.53 I-2.691 J-3.761 E.03718
G3 X173.454 Y162.283 I-.94 J-2.621 E.08262
G1 X173.002 Y161.995 E.0178
G1 X172.627 Y161.995 E.01243
G1 X172.627 Y161.555 E.01458
G3 X172.127 Y159.935 I2.887 J-1.777 E.05683
G3 X172.627 Y158.267 I3.367 J.099 E.05844
G1 X172.627 Y154.004 E.14138
G3 X173.179 Y153.809 I2.485 J6.128 E.01944
G1 X173.447 Y153.741 E.00915
; COOLING_NODE: 0
M204 S10000
G1 X172.73 Y153.533 F60000
G1 F1930
M204 S8000
G1 X172.828 Y153.497 E.00348
G3 X174.981 Y153.114 I2.319 J6.79 E.07283
G1 X177.602 Y153.113 E.08691
G1 X177.602 Y158.159 E.16736
G3 X178.014 Y160.654 I-2.963 J1.771 E.08589
G3 X177.602 Y161.658 I-3.779 J-.964 E.03612
G1 X177.602 Y162.402 E.02466
G1 X176.946 Y162.402 E.02173
G3 X175.294 Y163.078 I-2.205 J-3.03 E.0598
G3 X172.883 Y162.402 I-.344 J-3.409 E.08504
G1 X172.22 Y162.402 E.022
G1 X172.22 Y161.654 E.02481
G3 X172.22 Y158.168 I2.832 J-1.743 E.12171
G1 X172.22 Y153.736 E.14701
G1 X172.674 Y153.555 E.01622
; COOLING_NODE: 0
; WIPE_START
G1 F8843.478
G1 X172.828 Y153.497 E-.06261
G1 X173.531 Y153.292 E-.27803
G1 X174.251 Y153.165 E-.2781
G1 X174.622 Y153.139 E-.14126
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.813 Y154.325 Z2.8 F60000
G1 Z2.4
G1 E.8 F1800
G1 F1930
M204 S8000
G1 X170.603 Y155.449 E.05478
G2 X168.709 Y159.903 I4.324 J4.468 E.16491
G1 X168.709 Y167.309 E.24565
G1 X167.706 Y167.309 E.03327
G1 X167.707 Y159.975 E.24328
G3 X174.974 Y152.707 I7.415 J.147 E.37668
G1 X182.309 Y152.706 E.2433
G1 X182.309 Y153.709 E.03327
M73 P50 R7
G1 X178.009 Y153.709 E.14264
G1 X178.009 Y158.064 E.14447
G3 X178.009 Y161.755 I-3.194 J1.846 E.12823
G1 X178.009 Y162.809 E.03495
G1 X177.062 Y162.809 E.03141
G3 X172.764 Y162.809 I-2.149 J-2.966 E.15233
G1 X171.813 Y162.809 E.03157
G1 X171.813 Y161.752 E.03504
G3 X171.813 Y158.069 I3.193 J-1.842 E.12793
G1 X171.813 Y154.385 E.12221
; COOLING_NODE: 0
M204 S250
G1 X171.421 Y155.224 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1842
M204 S5000
G2 X169.983 Y156.833 I4.917 J5.842 E.06651
G2 X169.101 Y159.908 I4.95 J3.084 E.09959
G1 X169.101 Y167.701 E.23944
G1 X167.313 Y167.701 E.05492
G1 X167.315 Y159.967 E.23762
G3 X174.967 Y152.315 I7.807 J.155 E.3674
G1 X182.701 Y152.313 E.23763
G1 X182.701 Y154.101 E.05492
G1 X178.401 Y154.101 E.13213
G1 X178.401 Y157.972 E.11896
G3 X178.401 Y161.848 I-3.55 J1.938 E.1242
G1 X178.401 Y163.201 E.04156
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X177.173 Y163.201 E.03773
G3 X172.65 Y163.201 I-2.261 J-3.325 E.14759
G1 X171.421 Y163.201 E.03778
G1 X171.421 Y161.847 E.04159
G3 X171.421 Y157.974 I3.561 J-1.937 E.12408
G1 X171.421 Y155.284 E.08265
M204 S10000
G1 X170.733 Y154.708 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.567357
G1 F1930
M204 S8000
G2 X168.49 Y158.071 I4.376 J5.349 E.17534
; LINE_WIDTH: 0.632871
G2 X168.208 Y159.984 I6.546 J1.943 E.09329
G1 X168.207 Y167.105 E.34233
; WIPE_START
G1 F6102.207
G1 X168.207 Y165.105 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X170.605 Y157.859 Z2.8 F60000
G1 X172.011 Y153.608 Z2.8
G1 Z2.4
G1 E.8 F1800
; LINE_WIDTH: 0.290164
G1 F1930
M204 S8000
G1 X171.892 Y153.804 E.00462
; LINE_WIDTH: 0.306797
G1 X171.792 Y153.876 E.00265
; LINE_WIDTH: 0.338739
G1 X171.691 Y153.947 E.00297
; LINE_WIDTH: 0.368564
G1 X171.592 Y154.021 E.00327
; LINE_WIDTH: 0.396253
G1 X171.493 Y154.094 E.00355
; LINE_WIDTH: 0.433405
G1 X171.298 Y154.244 E.00782
; LINE_WIDTH: 0.475612
G1 X171.106 Y154.395 E.0086
; LINE_WIDTH: 0.521587
G2 X170.733 Y154.708 I8.76 J10.84 E.01898
; WIPE_START
G1 F7520.899
G1 X171.106 Y154.395 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.912 Y158.474 Z2.8 F60000
G1 Z2.4
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F1930
M204 S8000
G1 X172.975 Y158.35 E.00463
G1 X172.975 Y156.861 E.04938
G1 X173.036 Y156.724 E.00497
G1 X173.049 Y156.069 E.02174
G1 X172.975 Y155.891 E.00642
G1 X172.975 Y154.245 E.05458
G3 X174.519 Y153.903 I2.092 J5.783 E.05259
G1 X174.602 Y154.104 E.00721
G3 X175.657 Y155.414 I-2.343 J2.966 E.05627
G3 X175.398 Y156.724 I-1.623 J.36 E.04559
G2 X174.343 Y158.035 I2.343 J2.966 E.05627
G2 X174.602 Y159.345 I1.623 J.36 E.04559
G3 X175.657 Y160.655 I-2.342 J2.965 E.05627
G3 X175.044 Y162.336 I-1.889 J.263 E.06175
G3 X173.043 Y161.646 I.137 J-3.648 E.07124
G1 X173.049 Y161.31 E.01114
G1 X172.777 Y160.655 E.02353
G3 X172.477 Y159.935 I.441 J-.607 E.02724
G3 X172.736 Y158.82 I3.72 J.279 E.0381
M204 S10000
G1 X176.849 Y161.473 F60000
G1 F1930
M204 S8000
G2 X177.34 Y159.94 I-3.073 J-1.828 E.05385
G3 X176.964 Y159.345 I.804 J-.925 E.02367
G1 X176.983 Y158.612 E.02432
G1 X176.846 Y158.335 E.01025
G1 X176.846 Y157.016 E.04376
; WIPE_START
G1 F8843.478
G1 X176.846 Y158.335 E-.5013
G1 X176.983 Y158.612 E-.11745
G1 X176.973 Y158.984 E-.14124
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X177.805 Y153.207 Z2.8 F60000
G1 Z2.4
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.638537
G1 F1930
M204 S8000
G1 X182.105 Y153.207 E.2087
; CHANGE_LAYER
; Z_HEIGHT: 2.6
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F6044.159
G1 X180.105 Y153.207 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 13/58
; update layer progress
M73 L13
M991 S0 P12 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z2.8 I-.096 J-1.213 P1  F60000
G1 X173.505 Y153.728 Z2.8
G1 Z2.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1908
M204 S8000
G1 X173.849 Y153.643 E.01173
G3 X174.99 Y153.522 I1.264 J6.49 E.03812
G1 X177.195 Y153.522 E.07313
G1 X177.195 Y158.26 E.15718
G3 X177.692 Y159.79 I-2.938 J1.8 E.05386
G3 X177.45 Y161.049 I-2.88 J.101 E.04288
G1 X177.195 Y161.568 E.01918
G1 X177.195 Y161.995 E.01415
G1 X176.832 Y161.995 E.01203
G3 X175.901 Y162.512 I-2.823 J-3.984 E.0354
G3 X173.448 Y162.279 I-.99 J-2.61 E.08467
G1 X173.003 Y161.995 E.01751
G1 X172.627 Y161.995 E.01247
G1 X172.627 Y161.555 E.01458
G3 X172.127 Y159.941 I2.89 J-1.779 E.05664
G3 X172.391 Y158.728 I2.797 J-.027 E.04151
G1 X172.627 Y158.26 E.01739
G1 X172.627 Y154.006 E.14111
G3 X173.18 Y153.81 I2.486 J6.126 E.01947
G1 X173.447 Y153.742 E.00914
; COOLING_NODE: 0
M204 S10000
G1 X172.73 Y153.534 F60000
G1 F1908
M204 S8000
G1 X172.83 Y153.498 E.0035
G3 X174.983 Y153.115 I2.318 J6.789 E.07283
G1 X177.602 Y153.115 E.08687
G1 X177.602 Y158.163 E.16747
G3 X177.821 Y161.218 I-2.822 J1.738 E.10562
G1 X177.602 Y161.663 E.01644
G1 X177.602 Y162.402 E.02451
G1 X176.947 Y162.402 E.02171
G3 X175.29 Y163.079 I-2.25 J-3.14 E.05992
G3 X172.884 Y162.402 I-.349 J-3.373 E.08492
G1 X172.22 Y162.402 E.02203
G1 X172.22 Y161.654 E.02481
G3 X172.22 Y158.163 I2.836 J-1.745 E.12187
G1 X172.22 Y153.738 E.1468
G1 X172.675 Y153.556 E.01624
; COOLING_NODE: 0
; WIPE_START
G1 F8843.478
G1 X172.83 Y153.498 E-.06294
G1 X173.532 Y153.293 E-.27788
G1 X174.253 Y153.166 E-.27815
G1 X174.623 Y153.14 E-.14102
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.813 Y154.325 Z3 F60000
G1 Z2.6
G1 E.8 F1800
G1 F1908
M204 S8000
G1 X170.603 Y155.448 E.05476
G2 X168.709 Y159.906 I4.318 J4.467 E.16503
G1 X168.709 Y167.309 E.24557
G1 X167.707 Y167.309 E.03323
G1 X167.708 Y159.976 E.24325
G3 X174.976 Y152.708 I7.415 J.147 E.37667
G1 X182.309 Y152.707 E.24325
G1 X182.309 Y153.709 E.03323
M73 P51 R7
G1 X178.009 Y153.709 E.14264
G1 X178.009 Y158.066 E.14456
G3 X178.009 Y161.758 I-3.173 J1.846 E.1283
G1 X178.009 Y162.809 E.03486
G1 X177.062 Y162.809 E.0314
G3 X172.765 Y162.809 I-2.149 J-2.965 E.15233
G1 X171.813 Y162.809 E.03159
G1 X171.813 Y161.752 E.03504
G3 X171.813 Y158.066 I3.157 J-1.843 E.12815
G1 X171.813 Y154.385 E.12211
; COOLING_NODE: 0
M204 S250
G1 X171.421 Y155.224 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1891
M204 S5000
G2 X169.959 Y156.872 I4.877 J5.799 E.06793
G2 X169.101 Y159.909 I4.999 J3.052 E.09818
G1 X169.101 Y167.701 E.23941
G1 X167.315 Y167.701 E.05488
G1 X167.316 Y159.968 E.23759
G3 X174.969 Y152.316 I7.807 J.155 E.36739
G1 X182.701 Y152.315 E.23759
G1 X182.701 Y154.101 E.05488
G1 X178.401 Y154.101 E.13213
G1 X178.401 Y157.973 E.11899
G3 X178.401 Y161.849 I-3.525 J1.938 E.12427
G1 X178.401 Y163.201 E.04153
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X177.173 Y163.201 E.03773
G3 X172.65 Y163.201 I-2.261 J-3.324 E.14759
G1 X171.421 Y163.201 E.03779
G1 X171.421 Y161.847 E.04159
G3 X171.421 Y157.973 I3.514 J-1.937 E.12423
G1 X171.421 Y155.284 E.08262
M204 S10000
G1 X170.734 Y154.708 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.519856
G1 F1908
M204 S8000
G3 X171.107 Y154.396 I9.137 J10.533 E.01889
; LINE_WIDTH: 0.473873
G1 X171.299 Y154.244 E.00859
; LINE_WIDTH: 0.43167
G1 X171.494 Y154.095 E.00778
; LINE_WIDTH: 0.394562
G1 X171.593 Y154.021 E.00353
; LINE_WIDTH: 0.366901
G1 X171.692 Y153.948 E.00325
; LINE_WIDTH: 0.337077
G1 X171.793 Y153.876 E.00296
; LINE_WIDTH: 0.305088
G1 X171.893 Y153.805 E.00264
; LINE_WIDTH: 0.288167
G1 X172.009 Y153.611 E.00451
M204 S10000
G1 X170.734 Y154.708 F60000
; LINE_WIDTH: 0.565018
G1 F1908
M204 S8000
G2 X168.522 Y157.969 I4.367 J5.344 E.17
; LINE_WIDTH: 0.60943
G2 X168.21 Y159.904 I6.579 J2.054 E.09081
; LINE_WIDTH: 0.637041
G1 X168.208 Y167.105 E.34863
; WIPE_START
G1 F6059.373
G1 X168.208 Y165.105 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.46 Y158.766 Z3 F60000
G1 X172.975 Y157.998 Z3
G1 Z2.6
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F1908
M204 S8000
G1 X172.975 Y156.369 E.05401
G2 X172.975 Y155.815 I-.61 J-.277 E.01895
G1 X172.975 Y154.247 E.05204
G3 X174.453 Y153.909 I2.124 J5.888 E.0504
G1 X174.498 Y154.104 E.00664
G3 X175.526 Y155.414 I-39.148 J31.744 E.05523
G3 X174.979 Y157.379 I-1.705 J.585 E.07193
G1 X174.475 Y158.035 E.02744
G2 X175.021 Y160 I1.705 J.585 E.07193
G1 X175.526 Y160.655 E.02744
G3 X175.193 Y162.328 I-1.333 J.605 E.06041
G3 X173.103 Y161.646 I-.184 J-2.98 E.07469
G1 X172.975 Y161.646 E.00423
G2 X172.5 Y160.178 I-1.362 J-.371 E.05416
G3 X172.838 Y158.615 I2.623 J-.251 E.05388
M204 S10000
G1 X176.982 Y161.211 F60000
G1 F1908
M204 S8000
G2 X177.325 Y160.218 I-2.67 J-1.479 E.03502
G2 X177.095 Y159.345 I-.837 J-.246 E.03149
G1 X176.983 Y158.617 E.02445
G1 X176.846 Y158.342 E.01018
G1 X176.846 Y157.02 E.04384
; WIPE_START
G1 F8843.478
G1 X176.846 Y158.342 E-.50219
G1 X176.983 Y158.617 E-.11657
G1 X177.039 Y158.984 E-.14124
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X177.805 Y153.208 Z3 F60000
G1 Z2.6
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.637307
G1 F1908
M204 S8000
G1 X182.105 Y153.208 E.20827
; CHANGE_LAYER
; Z_HEIGHT: 2.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F6056.667
G1 X180.105 Y153.208 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 14/58
; update layer progress
M73 L14
M991 S0 P13 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z3 I-.096 J-1.213 P1  F60000
G1 X173.506 Y153.729 Z3
G1 Z2.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1924
M204 S8000
G1 X173.849 Y153.644 E.01174
G3 X174.991 Y153.523 I1.265 J6.489 E.03814
G1 X177.195 Y153.523 E.07309
G1 X177.195 Y158.26 E.15714
G3 X177.682 Y159.647 I-3.222 J1.911 E.04908
G3 X177.447 Y161.057 I-2.949 J.233 E.04789
G1 X177.195 Y161.567 E.01889
G1 X177.195 Y161.995 E.01418
G1 X176.826 Y161.995 E.01221
G3 X175.581 Y162.612 I-2.421 J-3.319 E.04632
G3 X173.499 Y162.31 I-.671 J-2.703 E.07156
G1 X172.996 Y161.995 E.0197
G1 X172.627 Y161.995 E.01225
G1 X172.627 Y161.563 E.01433
G3 X172.136 Y160.125 I3.182 J-1.889 E.05074
G3 X172.415 Y158.679 I2.85 J-.201 E.04942
G1 X172.627 Y158.267 E.01539
G1 X172.627 Y154.008 E.14127
G3 X173.182 Y153.811 I2.487 J6.125 E.01954
G1 X173.448 Y153.744 E.00909
; COOLING_NODE: 0
M204 S10000
G1 X172.731 Y153.535 F60000
G1 F1924
M204 S8000
G1 X172.831 Y153.499 E.00352
G3 X174.984 Y153.116 I2.318 J6.788 E.07282
G1 X177.602 Y153.116 E.08683
G1 X177.602 Y158.163 E.16743
G3 X177.817 Y161.226 I-2.845 J1.739 E.10585
G1 X177.602 Y161.662 E.01614
G1 X177.602 Y162.402 E.02452
G1 X176.943 Y162.402 E.02184
G3 X174.641 Y163.09 I-2.094 J-2.809 E.08136
G3 X172.879 Y162.402 I.369 J-3.542 E.0635
G1 X172.22 Y162.402 E.02187
G1 X172.22 Y161.659 E.02463
G3 X172.22 Y158.168 I2.849 J-1.746 E.12185
G1 X172.22 Y153.74 E.14689
G1 X172.675 Y153.558 E.01627
; COOLING_NODE: 0
; WIPE_START
G1 F8843.478
G1 X172.831 Y153.499 E-.06315
G1 X173.533 Y153.294 E-.27806
G1 X174.254 Y153.167 E-.27807
G1 X174.623 Y153.141 E-.14072
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.813 Y154.325 Z3.2 F60000
G1 Z2.8
G1 E.8 F1800
G1 F1924
M204 S8000
G1 X170.603 Y155.449 E.05478
G2 X168.709 Y159.906 I4.318 J4.466 E.16501
G1 X168.709 Y167.309 E.24557
G1 X167.708 Y167.309 E.03319
G1 X167.709 Y159.977 E.24322
G3 X174.977 Y152.709 I7.408 J.141 E.37674
G1 X182.309 Y152.708 E.24321
G1 X182.309 Y153.709 E.03319
G1 X178.009 Y153.709 E.14264
M73 P52 R7
G1 X178.009 Y158.066 E.14456
G3 X178.009 Y161.757 I-3.166 J1.846 E.12831
G1 X178.009 Y162.809 E.03487
G1 X177.06 Y162.809 E.03148
G3 X172.762 Y162.809 I-2.149 J-2.966 E.15235
G1 X171.813 Y162.809 E.03149
G1 X171.813 Y161.755 E.03494
G3 X171.813 Y158.069 I3.152 J-1.843 E.12818
G1 X171.813 Y154.385 E.12221
; COOLING_NODE: 0
M204 S250
G1 X171.421 Y155.224 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1924
M204 S5000
G2 X169.983 Y156.833 I4.918 J5.843 E.06651
G2 X169.101 Y159.909 I4.95 J3.084 E.09962
G1 X169.101 Y167.701 E.23941
G1 X167.316 Y167.701 E.05484
G1 X167.317 Y159.97 E.23756
G3 X174.97 Y152.317 I7.801 J.149 E.36747
G1 X182.701 Y152.316 E.23755
G1 X182.701 Y154.101 E.05484
G1 X178.401 Y154.101 E.13213
G1 X178.401 Y157.973 E.11899
G3 X178.401 Y161.849 I-3.517 J1.938 E.12428
G1 X178.401 Y163.201 E.04153
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X177.172 Y163.201 E.03775
G3 X172.649 Y163.201 I-2.261 J-3.323 E.1476
G1 X171.421 Y163.201 E.03776
G1 X171.421 Y161.848 E.04155
G3 X171.421 Y157.974 I3.507 J-1.937 E.12425
G1 X171.421 Y155.284 E.08265
M204 S10000
G1 X170.735 Y154.708 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.563984
G1 F1924
M204 S8000
G2 X168.492 Y158.071 I4.371 J5.346 E.17419
; LINE_WIDTH: 0.630329
G2 X168.209 Y159.986 I6.539 J1.944 E.09294
G1 X168.208 Y167.105 E.34079
; WIPE_START
G1 F6128.613
G1 X168.209 Y165.105 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X170.604 Y157.858 Z3.2 F60000
G1 X172.008 Y153.614 Z3.2
G1 Z2.8
G1 E.8 F1800
; LINE_WIDTH: 0.286492
G1 F1924
M204 S8000
G1 X171.894 Y153.805 E.00442
; LINE_WIDTH: 0.30313
G1 X171.793 Y153.877 E.00262
; LINE_WIDTH: 0.335142
G1 X171.693 Y153.948 E.00294
; LINE_WIDTH: 0.364977
G1 X171.593 Y154.022 E.00324
; LINE_WIDTH: 0.392678
G1 X171.494 Y154.095 E.00352
; LINE_WIDTH: 0.429824
G1 X171.299 Y154.244 E.00774
; LINE_WIDTH: 0.472032
G1 X171.108 Y154.396 E.00855
; LINE_WIDTH: 0.518038
G2 X170.735 Y154.708 I8.724 J10.797 E.01883
; WIPE_START
G1 F7577.069
G1 X171.108 Y154.396 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.975 Y157.881 Z3.2 F60000
G1 Z2.8
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F1924
M204 S8000
G1 X172.975 Y156.253 E.05401
G1 X173.044 Y156.069 E.0065
G1 X172.975 Y155.349 E.024
G1 X172.975 Y154.249 E.0365
G3 X174.362 Y153.916 I2.217 J6.198 E.0474
G2 X174.816 Y154.759 I1.259 J-.135 E.03256
G1 X175.418 Y155.414 E.02951
G3 X175.469 Y157.052 I-1.503 J.867 E.05661
G3 X174.582 Y158.035 I-19.271 J-16.503 E.04392
G2 X174.531 Y159.673 I1.503 J.867 E.05661
G2 X175.418 Y160.655 I19.283 J-16.514 E.04392
G3 X175.481 Y162.269 I-1.502 J.867 E.05571
G3 X173.095 Y161.646 I-.571 J-2.695 E.0848
G1 X172.975 Y161.646 E.00398
G2 X173.007 Y160.655 I-3.384 J-.603 E.033
G2 X172.478 Y159.908 I-2.356 J1.105 E.03053
G3 X172.963 Y158.374 I3.556 J.28 E.05383
M204 S10000
G1 X177.072 Y161.028 F60000
G1 F1924
M204 S8000
G2 X177.345 Y159.892 I-3.001 J-1.319 E.03898
G2 X177.203 Y159.345 I-.519 J-.157 E.01971
G2 X176.846 Y158.343 I-11.634 J3.574 E.03529
G1 X176.846 Y156.973 E.04545
; WIPE_START
G1 F8843.478
G1 X176.846 Y158.343 E-.52062
G1 X177.057 Y158.936 E-.23938
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X177.805 Y153.209 Z3.2 F60000
G1 Z2.8
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.636076
G1 F1924
M204 S8000
G1 X182.105 Y153.208 E.20783
; CHANGE_LAYER
; Z_HEIGHT: 3
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F6069.235
G1 X180.105 Y153.209 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 15/58
; update layer progress
M73 L15
M991 S0 P14 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
M73 P52 R6
G3 Z3.2 I-.096 J-1.213 P1  F60000
G1 X173.506 Y153.731 Z3.2
G1 Z3
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2019
M204 S8000
G1 X173.851 Y153.645 E.01179
G3 X174.992 Y153.525 I1.264 J6.489 E.03812
G1 X177.195 Y153.524 E.07305
G1 X177.195 Y158.26 E.1571
G3 X177.689 Y159.736 I-2.961 J1.812 E.05209
G3 X177.43 Y161.093 I-2.824 J.165 E.04629
G1 X177.195 Y161.561 E.01738
G1 X177.195 Y161.995 E.01437
G1 X176.827 Y161.995 E.01218
G3 X175.441 Y162.643 I-2.327 J-3.17 E.0511
G3 X173.494 Y162.307 I-.524 J-2.768 E.06695
G1 X172.996 Y161.995 E.0195
G1 X172.627 Y161.995 E.01225
G1 X172.627 Y161.563 E.0143
G3 X172.135 Y160.12 I3.184 J-1.891 E.05093
G3 X172.414 Y158.679 I2.785 J-.208 E.04929
G1 X172.627 Y158.267 E.01539
G1 X172.627 Y154.01 E.14121
G3 X173.182 Y153.812 I2.488 J6.125 E.01955
G1 X173.448 Y153.745 E.00909
; COOLING_NODE: 0
M204 S10000
G1 X172.731 Y153.537 F60000
G1 F2019
M204 S8000
G1 X172.832 Y153.501 E.00354
G3 X174.985 Y153.118 I2.318 J6.789 E.07283
G1 X177.602 Y153.117 E.08679
G1 X177.602 Y158.163 E.16739
G3 X177.602 Y161.658 I-2.852 J1.747 E.12198
G1 X177.602 Y162.402 E.02466
G1 X176.944 Y162.402 E.02182
G3 X174.742 Y163.097 I-2.104 J-2.829 E.07804
G3 X172.879 Y162.402 I.258 J-3.534 E.06685
G1 X172.22 Y162.402 E.02187
G1 X172.22 Y161.66 E.02461
G3 X172.22 Y158.168 I2.862 J-1.746 E.12183
G1 X172.22 Y153.741 E.14683
G1 X172.676 Y153.559 E.01629
; COOLING_NODE: 0
; WIPE_START
G1 F8843.478
G1 X172.832 Y153.501 E-.06338
G1 X173.534 Y153.296 E-.27807
G1 X174.255 Y153.169 E-.27814
G1 X174.624 Y153.143 E-.14041
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.813 Y154.325 Z3.4 F60000
G1 Z3
G1 E.8 F1800
G1 F2019
M204 S8000
G1 X170.603 Y155.449 E.05477
G2 X168.709 Y159.903 I4.331 J4.472 E.16491
G1 X168.709 Y167.309 E.24565
G1 X167.709 Y167.309 E.03315
G1 X167.71 Y159.98 E.24309
G3 X174.978 Y152.71 I7.408 J.138 E.37683
G1 X182.309 Y152.709 E.24317
G1 X182.309 Y153.709 E.03315
G1 X178.009 Y153.709 E.14264
G1 X178.009 Y158.066 E.14456
M73 P53 R6
G3 X178.009 Y161.755 I-3.177 J1.844 E.12818
G1 X178.009 Y162.809 E.03495
G1 X177.06 Y162.809 E.03146
G3 X172.762 Y162.809 I-2.149 J-2.967 E.15236
G1 X171.813 Y162.809 E.03149
G1 X171.813 Y161.756 E.03492
G3 X171.813 Y158.069 I3.174 J-1.843 E.12812
G1 X171.813 Y154.385 E.1222
; COOLING_NODE: 0
M204 S250
G1 X171.421 Y155.224 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1990
M204 S5000
G2 X169.948 Y156.889 I4.861 J5.782 E.06854
G2 X169.101 Y159.908 I5.011 J3.035 E.09754
G1 X169.101 Y167.701 E.23944
G1 X167.317 Y167.701 E.0548
G1 X167.318 Y159.972 E.23749
G3 X174.971 Y152.318 I7.801 J.147 E.3675
G1 X182.701 Y152.317 E.23751
G1 X182.701 Y154.101 E.0548
G1 X178.401 Y154.101 E.13213
G1 X178.401 Y157.973 E.11899
G3 X178.401 Y161.848 I-3.534 J1.938 E.12421
G1 X178.401 Y163.201 E.04156
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X177.172 Y163.201 E.03775
G3 X172.649 Y163.201 I-2.261 J-3.325 E.1476
G1 X171.421 Y163.201 E.03776
G1 X171.421 Y161.849 E.04155
G3 X171.421 Y157.974 I3.533 J-1.937 E.12419
G1 X171.421 Y155.284 E.08265
M204 S10000
G1 X170.735 Y154.709 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.516428
G1 F2019
M204 S8000
G3 X171.109 Y154.397 I9.112 J10.504 E.01879
; LINE_WIDTH: 0.470504
G1 X171.3 Y154.245 E.00849
; LINE_WIDTH: 0.428406
G1 X171.494 Y154.096 E.0077
; LINE_WIDTH: 0.391273
G1 X171.594 Y154.023 E.00352
; LINE_WIDTH: 0.363487
G1 X171.694 Y153.949 E.00324
; LINE_WIDTH: 0.333626
G1 X171.794 Y153.877 E.00292
; LINE_WIDTH: 0.301678
G1 X171.895 Y153.806 E.0026
; LINE_WIDTH: 0.284726
G1 X172.01 Y153.614 E.0044
M204 S10000
G1 X170.735 Y154.709 F60000
; LINE_WIDTH: 0.56158
G1 F2019
M204 S8000
G2 X168.523 Y157.969 I4.4 J5.368 E.16882
; LINE_WIDTH: 0.60782
G1 X168.428 Y158.3 E.01585
G2 X168.21 Y159.991 I6.64 J1.717 E.07872
; LINE_WIDTH: 0.634594
G1 X168.209 Y167.105 E.34298
; WIPE_START
G1 F6084.434
G1 X168.209 Y165.105 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.972 Y161.444 Z3.4 F60000
G1 Z3
G1 E.8 F1800
; FEATURE: Floating vertical shell
; LINE_WIDTH: 0.384421
G1 F2019
M204 S8000
G1 X173.054 Y161.605 E.00502
G1 X173.756 Y162.035 E.02293
G1 X174.21 Y162.224 E.01368
G1 X174.603 Y162.308 E.01117
G1 X175.165 Y162.314 E.01565
G2 X176.008 Y162.066 I-.242 J-2.375 E.0246
G1 X176.689 Y161.655 E.02213
G1 X176.807 Y161.607 E.00354
G2 X177.281 Y160.379 I-5.763 J-2.933 E.03669
G1 X177.33 Y159.876 E.01407
G2 X177.209 Y159.159 I-4.223 J.341 E.02024
G1 X176.849 Y158.38 E.02389
G1 X176.832 Y158.309 E.00205
G1 X176.832 Y154.046 E.11861
G1 X176.804 Y153.914 E.00375
G1 X176.673 Y153.887 E.00375
G1 X175.005 Y153.887 E.04641
G1 X174.349 Y153.933 E.0183
G1 X173.508 Y154.096 E.02383
G1 X173.004 Y154.276 E.01489
G1 X172.99 Y154.371 E.00269
G1 X172.99 Y158.315 E.10975
G1 X172.712 Y158.901 E.01803
G1 X172.523 Y159.535 E.01843
G1 X172.513 Y160.209 E.01873
G1 X172.674 Y160.805 E.01718
G1 X172.947 Y161.39 E.01797
M204 S10000
G1 X173.305 Y158.534 F60000
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F2019
M204 S8000
G2 X172.865 Y160.073 I2.175 J1.455 E.05396
G3 X173.127 Y160.943 I-.616 J.661 E.0316
G1 X173.327 Y161.346 E.01493
G2 X175.761 Y161.776 I1.559 J-1.72 E.08648
G1 X175.7 Y161.31 E.01558
G1 X175.327 Y160.655 E.02501
G3 X174.307 Y159.673 I2.347 J-3.457 E.04722
G3 X174.673 Y158.035 I1.773 J-.463 E.05783
G2 X175.694 Y157.052 I-2.347 J-3.457 E.04722
G2 X175.327 Y155.414 I-1.773 J-.463 E.05783
G1 X174.574 Y154.759 E.03311
G3 X174.273 Y154.312 I.364 J-.57 E.01838
G3 X175.898 Y154.25 I1.229 J10.852 E.05401
; WIPE_START
G1 F8843.478
G1 X174.273 Y154.312 E-.61809
G1 X174.482 Y154.622 E-.14192
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X177.805 Y153.209 Z3.4 F60000
G1 Z3
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.634836
G1 F2019
M204 S8000
G1 X182.105 Y153.209 E.2074
; CHANGE_LAYER
; Z_HEIGHT: 3.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F6081.943
G1 X180.105 Y153.209 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 16/58
; update layer progress
M73 L16
M991 S0 P15 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z3.4 I-.096 J-1.213 P1  F60000
G1 X173.507 Y153.732 Z3.4
G1 Z3.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2187
M204 S8000
G1 X173.852 Y153.647 E.0118
G3 X174.994 Y153.526 I1.264 J6.488 E.03812
G1 X177.195 Y153.525 E.07301
G1 X177.195 Y158.254 E.15684
G3 X177.689 Y159.737 I-3.135 J1.869 E.05226
G3 X177.407 Y161.142 I-2.86 J.158 E.04806
G1 X177.195 Y161.555 E.0154
G1 X177.195 Y161.995 E.01458
G1 X176.832 Y161.995 E.01203
G3 X175.879 Y162.52 I-2.751 J-3.864 E.03619
G3 X173.495 Y162.307 I-.968 J-2.618 E.08203
G1 X172.996 Y161.995 E.01954
G1 X172.627 Y161.995 E.01225
G1 X172.627 Y161.568 E.01415
G3 X172.132 Y160.073 I3.121 J-1.862 E.05266
G3 X172.414 Y158.679 I2.872 J-.144 E.04766
G1 X172.627 Y158.266 E.0154
G1 X172.627 Y154.011 E.14115
G3 X173.183 Y153.814 I2.489 J6.124 E.01958
G1 X173.448 Y153.747 E.00908
; COOLING_NODE: 0
M204 S10000
G1 X172.732 Y153.538 F60000
G1 F2187
M204 S8000
G1 X172.834 Y153.502 E.00357
G3 X174.986 Y153.119 I2.318 J6.788 E.07281
G1 X177.602 Y153.118 E.08675
G1 X177.602 Y158.159 E.1672
G3 X178.014 Y160.653 I-2.959 J1.77 E.08586
G3 X177.602 Y161.654 I-4.264 J-1.171 E.03599
G1 X177.602 Y162.402 E.02481
G1 X176.947 Y162.402 E.02171
G3 X175.287 Y163.079 I-2.251 J-3.142 E.06001
G3 X173.287 Y162.658 I-.372 J-3.189 E.069
G1 X172.879 Y162.402 E.01599
G1 X172.22 Y162.402 E.02187
G1 X172.22 Y161.663 E.02451
G3 X171.812 Y159.152 I2.96 J-1.769 E.08641
G3 X172.22 Y158.168 I3.916 J1.046 E.03545
G1 X172.22 Y153.743 E.14677
G1 X172.677 Y153.561 E.01632
; COOLING_NODE: 0
; WIPE_START
G1 F8843.478
G1 X172.834 Y153.502 E-.06372
G1 X173.536 Y153.297 E-.27798
G1 X174.256 Y153.17 E-.27795
G1 X174.625 Y153.144 E-.14036
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.813 Y154.325 Z3.6 F60000
G1 Z3.2
G1 E.8 F1800
G1 F2187
M204 S8000
G1 X170.602 Y155.449 E.0548
G2 X168.709 Y159.906 I4.331 J4.471 E.16497
G1 X168.709 Y167.309 E.24557
G1 X167.711 Y167.309 E.03311
G1 X167.712 Y159.979 E.24313
G3 X174.979 Y152.712 I7.415 J.147 E.37666
G1 X182.309 Y152.711 E.24313
G1 X182.309 Y153.709 E.03311
G1 X178.009 Y153.709 E.14264
G1 X178.009 Y158.064 E.14446
G3 X178.009 Y161.752 I-3.167 J1.844 E.12822
G1 X178.009 Y162.809 E.03504
G1 X177.062 Y162.809 E.0314
G3 X172.762 Y162.809 I-2.15 J-2.97 E.15242
M73 P54 R6
G1 X171.813 Y162.809 E.03149
G1 X171.813 Y161.758 E.03486
G3 X171.813 Y158.069 I3.177 J-1.844 E.12819
G1 X171.813 Y154.385 E.12221
; COOLING_NODE: 0
M204 S250
G1 X171.421 Y155.224 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2036
M204 S5000
G2 X169.983 Y156.833 I4.916 J5.841 E.06652
G2 X169.101 Y159.909 I4.977 J3.092 E.09959
G1 X169.101 Y167.701 E.23941
G1 X167.318 Y167.701 E.05477
G1 X167.32 Y159.972 E.23748
G3 X174.972 Y152.32 I7.807 J.155 E.36739
G1 X182.701 Y152.318 E.23748
G1 X182.701 Y154.101 E.05477
G1 X178.401 Y154.101 E.13213
G1 X178.401 Y157.972 E.11896
G3 X178.401 Y161.847 I-3.523 J1.938 E.12424
G1 X178.401 Y163.201 E.04159
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X177.173 Y163.201 E.03773
G3 X172.649 Y163.201 I-2.262 J-3.326 E.14762
G1 X171.421 Y163.201 E.03776
G1 X171.421 Y161.849 E.04153
G3 X171.421 Y157.974 I3.534 J-1.938 E.12421
G1 X171.421 Y155.284 E.08265
M204 S10000
G1 X170.736 Y154.709 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.514583
G1 F2187
M204 S8000
G3 X171.11 Y154.397 I9.085 J10.472 E.0187
; LINE_WIDTH: 0.468578
G1 X171.301 Y154.245 E.00847
; LINE_WIDTH: 0.42641
G1 X171.495 Y154.096 E.00766
; LINE_WIDTH: 0.389281
G1 X171.595 Y154.023 E.00349
; LINE_WIDTH: 0.361531
G1 X171.694 Y153.949 E.00321
; LINE_WIDTH: 0.331642
G1 X171.795 Y153.878 E.00291
; LINE_WIDTH: 0.299632
G1 X171.896 Y153.806 E.00259
; LINE_WIDTH: 0.283114
G1 X172.008 Y153.618 E.00429
M204 S10000
G1 X170.736 Y154.709 F60000
; LINE_WIDTH: 0.559952
G1 F2187
M204 S8000
G2 X168.525 Y157.969 I4.378 J5.352 E.16829
; LINE_WIDTH: 0.605145
G2 X168.212 Y159.904 I6.555 J2.053 E.09012
; LINE_WIDTH: 0.63334
G1 X168.21 Y167.105 E.34646
; WIPE_START
G1 F6097.354
G1 X168.21 Y165.105 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X174.185 Y162.418 Z3.6 F60000
G1 Z3.2
G1 E.8 F1800
; FEATURE: Bridge
; LINE_WIDTH: 0.41618
; LAYER_HEIGHT: 0.4
G1 F3000
M204 S8000
G1 X175.272 Y162.29 E.06067
G2 X175.994 Y162.066 I-.278 J-2.173 E.04209
G1 X176.681 Y161.654 E.04441
G1 X173.718 Y162.004 E.16537
G1 X173.078 Y161.611 E.04166
G1 X176.986 Y161.148 E.21815
G1 X177.105 Y160.914 E.01455
G1 X177.205 Y160.653 E.01549
G1 X172.842 Y161.169 E.24347
G3 X172.645 Y160.723 I2.043 J-1.173 E.02709
G1 X177.304 Y160.172 E.26005
G2 X177.311 Y159.702 I-1.706 J-.261 E.02615
G1 X172.527 Y160.267 E.267
G3 X172.507 Y159.8 I2.466 J-.338 E.02595
G1 X177.224 Y159.243 E.26324
G2 X177.049 Y158.794 I-2.486 J.712 E.02674
G1 X172.578 Y159.323 E.2495
G3 X172.754 Y158.832 I2.311 J.553 E.02893
G1 X176.83 Y158.35 E.22747
G1 X176.825 Y157.881 E.02599
G1 X172.997 Y158.334 E.21366
G1 X172.997 Y157.865 E.02602
G1 X176.825 Y157.412 E.21366
G1 X176.825 Y156.943 E.02602
G1 X172.997 Y157.395 E.21366
G1 X172.997 Y156.926 E.02602
G1 X176.825 Y156.473 E.21366
G1 X176.825 Y156.004 E.02602
G1 X172.997 Y156.456 E.21366
G1 X172.997 Y155.987 E.02602
G1 X176.825 Y155.534 E.21366
G1 X176.825 Y155.065 E.02602
G1 X172.997 Y155.518 E.21366
G1 X172.997 Y155.048 E.02602
G1 X176.825 Y154.595 E.21366
G1 X176.825 Y154.126 E.02602
G1 X172.997 Y154.579 E.21366
G1 X172.997 Y154.267 E.01729
G3 X174.149 Y153.973 I1.853 J4.861 E.06606
G1 X176.519 Y153.693 E.13225
; WIPE_START
G1 X174.532 Y153.928 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X177.805 Y153.21 Z3.6 F60000
G1 Z3.2
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.633606
; LAYER_HEIGHT: 0.2
G1 F2187
M204 S8000
G1 X182.105 Y153.21 E.20697
; CHANGE_LAYER
; Z_HEIGHT: 3.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F6094.609
G1 X180.105 Y153.21 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 17/58
; update layer progress
M73 L17
M991 S0 P16 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z3.6 I-.096 J-1.213 P1  F60000
G1 X173.507 Y153.733 Z3.6
G1 Z3.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2461
M204 S8000
G1 X173.854 Y153.648 E.01186
G3 X174.995 Y153.527 I1.264 J6.488 E.03811
G1 X177.195 Y153.527 E.07297
G1 X177.195 Y158.266 E.15723
G3 X177.694 Y159.892 I-2.886 J1.777 E.05703
G3 X177.195 Y161.555 I-3.371 J-.106 E.05825
G1 X177.195 Y161.995 E.01458
G1 X176.825 Y161.995 E.01225
G3 X175.441 Y162.643 I-2.327 J-3.166 E.05103
G3 X173.448 Y162.279 I-.524 J-2.767 E.06876
G1 X173.003 Y161.995 E.01751
G1 X172.627 Y161.995 E.01247
G1 X172.627 Y161.561 E.01437
G3 X172.133 Y160.085 I2.961 J-1.812 E.05209
G3 X172.414 Y158.679 I2.829 J-.164 E.04808
G1 X172.627 Y158.267 E.0154
G1 X172.627 Y154.013 E.14109
G3 X173.185 Y153.815 I2.491 J6.123 E.01964
G1 X173.448 Y153.748 E.00903
; COOLING_NODE: 0
M204 S10000
G1 X172.733 Y153.54 F60000
G1 F2461
M204 S8000
G1 X172.835 Y153.503 E.00359
G3 X174.988 Y153.12 I2.318 J6.79 E.07282
G1 X177.602 Y153.12 E.08671
G1 X177.602 Y158.168 E.16746
G3 X177.602 Y161.654 I-2.792 J1.743 E.12185
G1 X177.602 Y162.402 E.02481
G1 X176.942 Y162.402 E.02187
G3 X174.47 Y163.071 I-2.08 J-2.783 E.087
G3 X172.884 Y162.402 I.554 J-3.528 E.05769
G1 X172.22 Y162.402 E.02203
G1 X172.22 Y161.658 E.02466
G3 X172.22 Y158.168 I2.835 J-1.745 E.12187
G1 X172.22 Y153.745 E.14671
G1 X172.677 Y153.562 E.01633
; COOLING_NODE: 0
; WIPE_START
G1 F8843.478
G1 X172.835 Y153.503 E-.06395
G1 X173.537 Y153.298 E-.27799
G1 X174.257 Y153.171 E-.27793
G1 X174.625 Y153.145 E-.14013
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.813 Y154.325 Z3.8 F60000
G1 Z3.4
G1 E.8 F1800
G1 F2461
M204 S8000
G1 X170.603 Y155.449 E.05478
G2 X168.709 Y159.905 I4.33 J4.471 E.16498
G1 X168.709 Y167.309 E.24558
G1 X167.712 Y167.309 E.03307
G1 X167.713 Y159.981 E.24308
G3 X174.98 Y152.713 I7.415 J.147 E.37667
G1 X182.309 Y152.712 E.24309
G1 X182.309 Y153.709 E.03307
G1 X178.009 Y153.709 E.14264
G1 X178.009 Y158.069 E.14465
G3 X178.009 Y161.752 I-3.146 J1.842 E.12808
G1 X178.009 Y162.809 E.03504
G1 X177.059 Y162.809 E.03149
G3 X172.765 Y162.809 I-2.147 J-2.962 E.15224
G1 X171.813 Y162.809 E.03159
G1 X171.813 Y161.755 E.03495
G3 X171.813 Y158.069 I3.156 J-1.843 E.12815
G1 X171.813 Y154.385 E.1222
; COOLING_NODE: 0
M204 S250
G1 X171.421 Y155.224 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
M73 P55 R6
G1 F2079
M204 S5000
G2 X169.983 Y156.833 I4.911 J5.837 E.06652
G2 X169.101 Y159.909 I4.977 J3.092 E.09959
G1 X169.101 Y167.701 E.23942
G1 X167.32 Y167.701 E.05473
G1 X167.321 Y159.973 E.23744
G3 X174.973 Y152.321 I7.808 J.155 E.36739
G1 X182.701 Y152.32 E.23744
G1 X182.701 Y154.101 E.05473
G1 X178.401 Y154.101 E.13213
G1 X178.401 Y157.974 E.11902
G3 X178.401 Y161.847 I-3.505 J1.937 E.12422
G1 X178.401 Y163.201 E.04159
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X177.172 Y163.201 E.03775
G3 X172.65 Y163.201 I-2.261 J-3.323 E.14756
G1 X171.421 Y163.201 E.03779
G1 X171.421 Y161.848 E.04156
G3 X171.421 Y157.974 I3.514 J-1.937 E.12423
G1 X171.421 Y155.284 E.08265
M204 S10000
G1 X170.737 Y154.71 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.512985
G1 F2461
M204 S8000
G3 X171.11 Y154.398 I9.099 J10.489 E.01863
; LINE_WIDTH: 0.467028
G1 X171.301 Y154.246 E.00845
; LINE_WIDTH: 0.424794
G1 X171.497 Y154.097 E.00766
; LINE_WIDTH: 0.387627
G1 X171.596 Y154.023 E.00347
; LINE_WIDTH: 0.359943
G1 X171.695 Y153.95 E.00319
; LINE_WIDTH: 0.330109
G1 X171.796 Y153.878 E.00289
; LINE_WIDTH: 0.298128
G1 X171.897 Y153.807 E.00257
; LINE_WIDTH: 0.281507
G1 X172.011 Y153.618 E.00429
M204 S10000
G1 X170.737 Y154.71 F60000
; LINE_WIDTH: 0.558212
G1 F2461
M204 S8000
G2 X168.524 Y157.969 I4.387 J5.36 E.16771
; LINE_WIDTH: 0.604954
G2 X168.211 Y159.99 I6.546 J2.05 E.09401
; LINE_WIDTH: 0.632134
G1 X168.21 Y167.105 E.34163
; WIPE_START
G1 F6109.834
G1 X168.21 Y165.105 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.677 Y158.916 Z3.8 F60000
G1 X174.911 Y155.822 Z3.8
G1 Z3.4
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.433131
G1 F2461
M204 S8000
G1 X174.911 Y158.437 E.08315
M204 S10000
G1 X175.104 Y160.367 F60000
; LINE_WIDTH: 0.424506
G1 F2461
M204 S8000
G1 X175.318 Y160.22 E.00809
G1 X175.393 Y159.866 E.01126
G2 X175.342 Y159.648 I-.412 J-.019 E.00705
G1 X175.106 Y159.179 E.01631
G1 X174.911 Y158.497 E.02205
G1 X174.716 Y159.179 E.02205
G1 X174.428 Y159.808 E.0215
G1 X174.446 Y160.095 E.00894
G1 X174.51 Y160.238 E.00487
G1 X174.864 Y160.405 E.01217
G1 X175.044 Y160.377 E.00569
M204 S10000
G1 X175.305 Y160.693 F60000
; LINE_WIDTH: 0.41999
G1 F2461
M204 S8000
G1 X175.588 Y160.522 E.01013
G1 X175.768 Y160.035 E.01596
G2 X175.705 Y159.53 I-1.176 J-.109 E.01576
G3 X175.337 Y158.694 I3.214 J-1.913 E.02813
G1 X175.294 Y158.315 E.01172
G1 X175.294 Y155.427 E.08873
G1 X174.553 Y155.463 E.02279
G1 X174.527 Y155.491 E.00118
G1 X174.527 Y158.315 E.08678
G1 X174.484 Y158.694 E.01172
G2 X174.045 Y159.799 I13.285 J5.928 E.03656
G1 X174.084 Y160.205 E.01253
G1 X174.223 Y160.506 E.01019
G1 X174.674 Y160.743 E.01565
G1 X174.992 Y160.785 E.00986
G1 X175.248 Y160.71 E.00819
M204 S10000
G1 X176.083 Y160.3 F60000
; LINE_WIDTH: 0.41999
G1 F2461
M204 S8000
G2 X176.147 Y159.844 I-.772 J-.34 E.01431
G1 X176.105 Y159.522 E.01
G3 X175.705 Y158.61 I4.447 J-2.496 E.03064
G1 X175.671 Y158.315 E.00911
G1 X175.671 Y155.05 E.10032
G2 X174.15 Y155.157 I-.309 J6.478 E.04696
G1 X174.15 Y158.315 E.09704
G1 X174.117 Y158.61 E.00911
G2 X173.667 Y159.762 I8.428 J3.953 E.03804
G1 X173.704 Y160.232 E.01447
G1 X173.936 Y160.775 E.01814
G1 X174.423 Y161.061 E.01735
G1 X174.911 Y161.167 E.01535
G1 X175.272 Y161.112 E.01122
G1 X175.875 Y160.789 E.02101
G1 X176.06 Y160.355 E.0145
M204 S10000
G1 X176.413 Y160.516 F60000
; LINE_WIDTH: 0.41999
G1 F2461
M204 S8000
G1 X176.521 Y160.148 E.0118
G2 X176.467 Y159.414 I-2.625 J-.177 E.02267
G1 X176.15 Y158.742 E.02283
G1 X176.052 Y158.397 E.01102
G1 X176.048 Y154.673 E.11443
G2 X174.453 Y154.714 I-.505 J11.452 E.04907
G1 X173.773 Y154.846 E.02128
G1 X173.773 Y158.315 E.10659
G1 X173.687 Y158.708 E.01235
G1 X173.346 Y159.454 E.02521
G1 X173.291 Y159.859 E.01257
G1 X173.336 Y160.314 E.01404
G2 X173.649 Y161.043 I3.101 J-.902 E.02447
G1 X174.271 Y161.41 E.02217
G1 X174.791 Y161.535 E.01642
G1 X175.205 Y161.511 E.01275
G1 X175.642 Y161.371 E.01409
G1 X176.162 Y161.056 E.01869
G1 X176.387 Y160.571 E.01644
M204 S10000
G1 X176.144 Y161.948 F60000
G1 F2461
M204 S8000
G1 X176.671 Y161.63 E.01892
G1 X176.802 Y161.569 E.00445
G1 X176.823 Y161.421 E.00459
G1 X177.083 Y160.908 E.01767
G1 X177.274 Y160.26 E.02075
G1 X177.281 Y159.605 E.02014
G1 X177.134 Y159.045 E.01777
G1 X176.823 Y158.401 E.022
G1 X176.802 Y158.315 E.0027
G1 X176.802 Y153.919 E.13509
G1 X175.008 Y153.919 E.05512
G1 X174.354 Y153.965 E.02015
G1 X173.506 Y154.13 E.02657
G1 X173.019 Y154.29 E.01574
G1 X173.019 Y158.315 E.12368
G3 X172.624 Y159.218 I-16.303 J-6.592 E.03027
G1 X172.535 Y159.652 E.01362
G1 X172.54 Y160.208 E.01709
G1 X172.7 Y160.808 E.01907
G1 X172.999 Y161.428 E.02116
G1 X173.019 Y161.602 E.00539
G1 X173.223 Y161.668 E.00658
G1 X173.968 Y162.107 E.02657
G1 X174.508 Y162.267 E.01731
G1 X175.037 Y162.293 E.01627
G1 X175.598 Y162.2 E.01747
G1 X176.09 Y161.973 E.01663
M204 S10000
G1 X175.647 Y161.774 F60000
; LINE_WIDTH: 0.41999
G1 F2461
M204 S8000
G2 X176.46 Y161.317 I-6.191 J-11.944 E.02866
G1 X176.731 Y160.768 E.01881
G1 X176.898 Y160.204 E.01807
G2 X176.859 Y159.44 I-3.404 J-.211 E.02356
G2 X176.44 Y158.442 I-5.587 J1.759 E.03332
G1 X176.425 Y158.315 E.00391
G1 X176.425 Y154.296 E.1235
G1 X175.022 Y154.296 E.04313
G1 X174.404 Y154.339 E.01903
G1 X173.601 Y154.496 E.02513
G1 X173.396 Y154.563 E.00663
G1 X173.396 Y158.315 E.11529
G1 X173.345 Y158.551 E.00741
G1 X172.985 Y159.336 E.02653
G1 X172.914 Y159.862 E.01632
G1 X172.916 Y160.165 E.00931
G1 X173.051 Y160.67 E.01606
G1 X173.336 Y161.258 E.02008
G1 X173.415 Y161.343 E.00355
G1 X174.12 Y161.758 E.02515
G1 X174.579 Y161.894 E.01473
G1 X175.139 Y161.91 E.01721
G1 X175.589 Y161.79 E.01431
; WIPE_START
G1 F9547.302
G1 X175.139 Y161.91 E-.17696
G1 X174.579 Y161.894 E-.21278
G1 X174.12 Y161.758 E-.18217
G1 X173.693 Y161.507 E-.18809
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X177.083 Y154.668 Z3.8 F60000
G1 X177.805 Y153.211 Z3.8
G1 Z3.4
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.632376
G1 F2461
M204 S8000
G1 X182.105 Y153.21 E.20654
; CHANGE_LAYER
; Z_HEIGHT: 3.6
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F6107.327
G1 X180.105 Y153.21 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 18/58
; update layer progress
M73 L18
M991 S0 P17 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z3.8 I-.096 J-1.213 P1  F60000
G1 X173.507 Y153.735 Z3.8
G1 Z3.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2461
M204 S8000
G1 X173.855 Y153.649 E.01188
G3 X174.996 Y153.528 I1.265 J6.491 E.03812
G1 X177.195 Y153.528 E.07293
G1 X177.195 Y158.254 E.15676
G3 X177.689 Y159.736 I-3.133 J1.868 E.05225
G3 X177.407 Y161.142 I-2.813 J.167 E.04809
G1 X177.195 Y161.555 E.0154
G1 X177.195 Y161.995 E.01458
G1 X176.832 Y161.995 E.01203
G3 X175.852 Y162.53 I-2.768 J-3.901 E.03712
G3 X173.499 Y162.31 I-.941 J-2.624 E.08094
G1 X172.996 Y161.995 E.0197
G1 X172.627 Y161.995 E.01225
G1 X172.627 Y161.555 E.01458
G3 X172.127 Y159.941 I2.891 J-1.779 E.05663
G3 X172.627 Y158.267 I3.26 J.061 E.05868
G1 X172.627 Y154.015 E.14104
G3 X173.186 Y153.816 I2.492 J6.125 E.01969
G1 X173.449 Y153.75 E.00899
; COOLING_NODE: 0
M204 S10000
G1 X172.733 Y153.541 F60000
G1 F2461
M204 S8000
G1 X172.836 Y153.504 E.0036
G3 X174.989 Y153.121 I2.319 J6.79 E.07284
G1 X177.602 Y153.121 E.08667
G1 X177.602 Y158.159 E.16712
G3 X178.015 Y160.646 I-2.967 J1.771 E.08561
G3 X177.602 Y161.654 I-3.806 J-.974 E.03626
G1 X177.602 Y162.402 E.02481
G1 X176.947 Y162.402 E.02172
G3 X175.294 Y163.078 I-2.251 J-3.142 E.05978
G3 X173.291 Y162.659 I-.379 J-3.189 E.0691
G1 X172.879 Y162.402 E.01611
G1 X172.22 Y162.402 E.02187
G1 X172.22 Y161.654 E.02481
G3 X172.22 Y158.168 I2.81 J-1.743 E.12179
G1 X172.22 Y153.747 E.14666
G1 X172.678 Y153.564 E.01636
; COOLING_NODE: 0
; WIPE_START
G1 F8843.478
G1 X172.836 Y153.504 E-.06407
G1 X173.538 Y153.299 E-.27821
G1 X174.259 Y153.172 E-.2779
G1 X174.626 Y153.147 E-.13982
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.813 Y154.325 Z4 F60000
G1 Z3.6
G1 E.8 F1800
G1 F2461
M204 S8000
G1 X170.603 Y155.449 E.05478
G2 X168.709 Y159.906 I4.331 J4.471 E.16499
G1 X168.709 Y167.309 E.24557
G1 X167.713 Y167.309 E.03303
G1 X167.714 Y159.982 E.24303
G3 X174.982 Y152.714 I7.415 J.147 E.37668
G1 X182.309 Y152.713 E.24305
G1 X182.309 Y153.709 E.03303
G1 X178.009 Y153.709 E.14264
G1 X178.009 Y158.064 E.14447
G3 X178.009 Y161.752 I-3.167 J1.844 E.12821
G1 X178.009 Y162.809 E.03504
G1 X177.062 Y162.809 E.0314
M73 P56 R6
G3 X172.762 Y162.809 I-2.15 J-2.968 E.15243
G1 X171.813 Y162.809 E.03149
G1 X171.813 Y161.752 E.03504
G3 X171.813 Y158.069 I3.167 J-1.842 E.12801
G1 X171.813 Y154.385 E.1222
; COOLING_NODE: 0
M204 S250
G1 X171.421 Y155.224 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2116
M204 S5000
G2 X169.931 Y156.917 I4.841 J5.762 E.06955
G2 X169.101 Y159.909 I5.003 J3 E.09657
G1 X169.101 Y167.701 E.23941
G1 X167.321 Y167.701 E.05469
G1 X167.322 Y159.975 E.2374
G3 X174.975 Y152.322 I7.808 J.155 E.3674
G1 X182.701 Y152.321 E.2374
G1 X182.701 Y154.101 E.05469
G1 X178.401 Y154.101 E.13213
G1 X178.401 Y157.972 E.11896
G3 X178.401 Y161.847 I-3.523 J1.937 E.12424
G1 X178.401 Y163.201 E.04159
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X177.173 Y163.201 E.03773
G3 X172.649 Y163.201 I-2.262 J-3.323 E.14763
G1 X171.421 Y163.201 E.03776
G1 X171.421 Y161.847 E.04159
G3 X171.421 Y157.974 I3.531 J-1.937 E.12415
G1 X171.421 Y155.284 E.08265
M204 S10000
G1 X170.738 Y154.71 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.511177
G1 F2461
M204 S8000
G3 X171.111 Y154.398 I9.114 J10.506 E.01855
; LINE_WIDTH: 0.465148
G1 X171.303 Y154.246 E.00843
; LINE_WIDTH: 0.422907
G1 X171.498 Y154.097 E.00761
; LINE_WIDTH: 0.385811
G1 X171.597 Y154.024 E.00344
; LINE_WIDTH: 0.358192
G1 X171.696 Y153.95 E.00316
; LINE_WIDTH: 0.328344
G1 X171.797 Y153.879 E.00288
; LINE_WIDTH: 0.296288
G1 X171.898 Y153.807 E.00256
; LINE_WIDTH: 0.27958
G1 X172.009 Y153.621 E.00418
M204 S10000
G1 X170.738 Y154.71 F60000
; LINE_WIDTH: 0.55722
G1 F2461
M204 S8000
G2 X168.494 Y158.072 I4.398 J5.365 E.17187
; LINE_WIDTH: 0.604659
G2 X168.211 Y159.991 I6.668 J1.963 E.0891
; LINE_WIDTH: 0.630904
G1 X168.211 Y167.105 E.34084
; WIPE_START
G1 F6122.615
G1 X168.211 Y165.105 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.678 Y158.917 Z4 F60000
G1 X174.911 Y155.824 Z4
G1 Z3.6
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.433131
G1 F2461
M204 S8000
G2 X174.911 Y158.43 I385.121 J1.243 E.08288
M204 S10000
G1 X175.126 Y160.357 F60000
; LINE_WIDTH: 0.423162
G1 F2461
M204 S8000
G1 X175.276 Y160.273 E.00531
G1 X175.399 Y159.971 E.0101
G2 X175.348 Y159.659 I-.706 J-.046 E.00988
G1 X174.977 Y158.805 E.02887
G1 X174.911 Y158.49 E.00995
G3 X174.68 Y159.254 I-2.463 J-.33 E.02483
G1 X174.461 Y159.736 E.01641
G1 X174.416 Y159.947 E.00668
G1 X174.515 Y160.243 E.00967
G1 X174.871 Y160.407 E.01216
G1 X175.067 Y160.368 E.00618
M204 S10000
G1 X175.321 Y160.685 F60000
; LINE_WIDTH: 0.41999
G1 F2461
M204 S8000
G1 X175.57 Y160.536 E.0089
G1 X175.776 Y160.024 E.01697
G2 X175.705 Y159.53 I-1.267 J-.069 E.01545
G3 X175.345 Y158.713 I3.629 J-2.088 E.02749
G1 X175.294 Y158.301 E.01274
G1 X175.294 Y155.429 E.08827
G1 X174.555 Y155.464 E.02273
G1 X174.527 Y155.494 E.00127
G1 X174.527 Y158.315 E.08668
G1 X174.479 Y158.716 E.01239
G1 X174.178 Y159.409 E.02323
G1 X174.036 Y159.886 E.01528
G1 X174.142 Y160.342 E.01441
G1 X174.229 Y160.513 E.00587
G1 X174.684 Y160.745 E.01569
G1 X174.955 Y160.786 E.00844
G1 X175.263 Y160.701 E.00982
M204 S10000
G1 X175.568 Y160.976 F60000
G1 F2461
M204 S8000
G1 X175.863 Y160.799 E.01058
G1 X176.113 Y160.256 E.01839
G1 X176.152 Y159.862 E.01215
G1 X176.104 Y159.52 E.01062
G3 X175.711 Y158.621 I6.138 J-3.225 E.03018
G1 X175.671 Y158.301 E.00991
G1 X175.671 Y155.051 E.09985
G2 X174.15 Y155.158 I-.309 J6.47 E.04696
G1 X174.15 Y158.315 E.097
G1 X174.113 Y158.627 E.00963
G2 X173.666 Y159.766 I5.744 J2.91 E.03766
G1 X173.669 Y160.081 E.00967
G1 X173.826 Y160.552 E.01527
G1 X173.943 Y160.782 E.00792
G1 X174.415 Y161.058 E.01681
G1 X174.89 Y161.167 E.01496
G1 X175.248 Y161.119 E.01111
G1 X175.514 Y161.001 E.00892
M204 S10000
G1 X175.655 Y161.364 F60000
G1 F2461
M204 S8000
G1 X176.157 Y161.063 E.018
G1 X176.474 Y160.374 E.02328
G2 X176.529 Y159.859 I-1.76 J-.449 E.01596
G1 X176.467 Y159.413 E.01385
G1 X176.164 Y158.756 E.02222
G1 X176.052 Y158.387 E.01186
G1 X176.048 Y154.674 E.11406
G2 X174.455 Y154.715 I-.504 J11.446 E.04902
G1 X173.773 Y154.848 E.02134
G1 X173.773 Y158.315 E.10655
G1 X173.747 Y158.538 E.00688
G2 X173.331 Y159.57 I5.452 J2.797 E.03425
G1 X173.277 Y159.93 E.01118
G2 X173.657 Y161.052 I3.075 J-.416 E.03661
G1 X174.264 Y161.407 E.02161
G1 X174.784 Y161.535 E.01648
G1 X175.228 Y161.508 E.01365
G1 X175.598 Y161.383 E.01201
M204 S10000
G1 X176.151 Y161.946 F60000
G1 F2461
M204 S8000
G1 X176.678 Y161.629 E.01891
G1 X176.802 Y161.575 E.00416
G1 X176.82 Y161.427 E.00458
G1 X177.195 Y160.611 E.02761
G1 X177.286 Y160.173 E.01376
G1 X177.281 Y159.608 E.01733
G1 X177.131 Y159.036 E.0182
G1 X176.84 Y158.422 E.02085
G1 X176.802 Y158.301 E.00389
G1 X176.802 Y153.92 E.13462
G1 X175.01 Y153.92 E.05508
G1 X174.356 Y153.966 E.02013
G1 X173.507 Y154.131 E.0266
G1 X173.019 Y154.292 E.01577
G1 X173.019 Y158.315 E.12363
G1 X172.736 Y158.919 E.02048
G1 X172.546 Y159.566 E.02074
G1 X172.534 Y160.091 E.01613
G1 X172.613 Y160.496 E.01267
G2 X173.019 Y161.506 I6.355 J-1.969 E.0335
G1 X173.019 Y161.602 E.00296
G1 X173.149 Y161.628 E.00408
G1 X173.961 Y162.104 E.02892
G1 X174.51 Y162.267 E.01759
G1 X175.017 Y162.293 E.0156
G1 X175.57 Y162.207 E.01719
G1 X176.096 Y161.971 E.01773
M204 S10000
G1 X176.692 Y160.801 F60000
G1 F2461
M204 S8000
G2 X176.906 Y159.856 I-1.562 J-.85 E.03016
G1 X176.861 Y159.448 E.01262
G2 X176.442 Y158.438 I-5.191 J1.559 E.03364
G1 X176.425 Y158.301 E.00425
G1 X176.425 Y154.297 E.12303
G1 X175.023 Y154.297 E.04309
G1 X174.406 Y154.341 E.01902
G1 X173.602 Y154.497 E.02516
G1 X173.396 Y154.565 E.00666
G1 X173.396 Y158.315 E.11524
G1 X173.335 Y158.571 E.00809
G1 X173.088 Y159.058 E.01678
G1 X172.919 Y159.633 E.0184
G1 X172.924 Y160.225 E.0182
G1 X173.089 Y160.766 E.01738
G3 X173.361 Y161.315 I-2.908 J1.782 E.01884
G1 X174.113 Y161.755 E.02677
G1 X174.749 Y161.911 E.02012
G1 X175.148 Y161.909 E.01228
G1 X175.639 Y161.775 E.01563
G2 X176.458 Y161.322 I-2.019 J-4.61 E.02881
G1 X176.668 Y160.856 E.01569
; WIPE_START
G1 F9547.299
G1 X176.458 Y161.322 E-.19398
G1 X175.957 Y161.623 E-.22235
G1 X175.639 Y161.775 E-.1338
G1 X175.148 Y161.909 E-.19332
G1 X175.105 Y161.909 E-.01655
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X177.368 Y154.62 Z4 F60000
G1 X177.805 Y153.211 Z4
G1 Z3.6
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.631146
G1 F2461
M204 S8000
G1 X182.105 Y153.211 E.20611
; CHANGE_LAYER
; Z_HEIGHT: 3.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F6120.099
G1 X180.105 Y153.211 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 19/58
; update layer progress
M73 L19
M991 S0 P18 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z4 I-.097 J-1.213 P1  F60000
G1 X173.507 Y153.736 Z4
G1 Z3.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2460
M204 S8000
G1 X173.856 Y153.65 E.01192
G3 X174.997 Y153.53 I1.265 J6.491 E.03812
G1 X177.195 Y153.529 E.07289
G1 X177.195 Y158.254 E.15672
G3 X177.689 Y159.736 I-3.134 J1.868 E.05225
G3 X177.407 Y161.142 I-2.857 J.159 E.04808
G1 X177.195 Y161.555 E.01539
G1 X177.195 Y161.995 E.01458
G1 X176.831 Y161.995 E.01206
G3 X175.713 Y162.576 I-2.528 J-3.495 E.04195
G3 X173.494 Y162.306 I-.799 J-2.694 E.07626
G1 X172.996 Y161.995 E.01948
G1 X172.627 Y161.995 E.01225
G1 X172.627 Y161.555 E.01458
G3 X172.127 Y159.941 I2.889 J-1.778 E.05663
G3 X172.627 Y158.267 I3.259 J.06 E.05868
G1 X172.627 Y154.017 E.14098
G3 X173.187 Y153.817 I2.494 J6.125 E.01974
G1 X173.449 Y153.751 E.00895
; COOLING_NODE: 0
M204 S10000
G1 X172.734 Y153.543 F60000
G1 F2460
M204 S8000
G1 X172.837 Y153.506 E.00361
G3 X174.99 Y153.122 I2.319 J6.79 E.07284
G1 X177.602 Y153.122 E.08663
G1 X177.602 Y158.159 E.16707
G3 X178.015 Y160.645 I-2.963 J1.771 E.0856
G3 X177.602 Y161.654 I-3.806 J-.973 E.03627
G1 X177.602 Y162.402 E.02481
G1 X176.946 Y162.402 E.02174
G3 X175.29 Y163.079 I-2.182 J-2.974 E.05995
G3 X173.286 Y162.657 I-.375 J-3.186 E.06913
G1 X172.879 Y162.402 E.01594
G1 X172.22 Y162.402 E.02187
G1 X172.22 Y161.654 E.02481
G3 X172.22 Y158.168 I2.809 J-1.743 E.12179
G1 X172.22 Y153.749 E.1466
G1 X172.679 Y153.565 E.01639
; COOLING_NODE: 0
; WIPE_START
G1 F8843.478
G1 X172.837 Y153.506 E-.0642
G1 X173.539 Y153.301 E-.27822
G1 X174.26 Y153.173 E-.278
G1 X174.626 Y153.148 E-.13959
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.813 Y154.325 Z4.2 F60000
G1 Z3.8
G1 E.8 F1800
G1 F2460
M204 S8000
G1 X170.603 Y155.449 E.05477
G2 X168.709 Y159.906 I4.331 J4.472 E.16499
G1 X168.709 Y167.309 E.24557
G1 X167.714 Y167.309 E.03299
G1 X167.715 Y159.984 E.24299
G3 X174.983 Y152.715 I7.415 J.146 E.37669
G1 X182.309 Y152.714 E.24301
G1 X182.309 Y153.709 E.03299
G1 X178.009 Y153.709 E.14264
G1 X178.009 Y158.064 E.14446
M73 P57 R6
G3 X178.009 Y161.752 I-3.161 J1.844 E.12823
G1 X178.009 Y162.809 E.03504
G1 X177.062 Y162.809 E.03141
G3 X172.762 Y162.809 I-2.15 J-2.964 E.15243
G1 X171.813 Y162.809 E.03149
G1 X171.813 Y161.752 E.03504
G3 X171.813 Y158.069 I3.167 J-1.841 E.12801
G1 X171.813 Y154.385 E.1222
; COOLING_NODE: 0
M204 S250
G1 X171.421 Y155.224 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2149
M204 S5000
G2 X169.98 Y156.838 I4.907 J5.832 E.06671
G2 X169.101 Y159.909 I4.952 J3.079 E.09942
G1 X169.101 Y167.701 E.23942
G1 X167.322 Y167.701 E.05465
G1 X167.323 Y159.976 E.23736
G3 X174.976 Y152.323 I7.808 J.155 E.3674
G1 X182.701 Y152.322 E.23736
G1 X182.701 Y154.101 E.05465
G1 X178.401 Y154.101 E.13213
G1 X178.401 Y157.972 E.11896
G3 X178.401 Y161.847 I-3.515 J1.938 E.12426
G1 X178.401 Y163.201 E.04159
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X177.173 Y163.201 E.03773
G3 X172.649 Y163.201 I-2.262 J-3.319 E.14764
G1 X171.421 Y163.201 E.03776
G1 X171.421 Y161.847 E.04159
G3 X171.421 Y157.974 I3.531 J-1.937 E.12415
G1 X171.421 Y155.284 E.08265
M204 S10000
G1 X170.739 Y154.711 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.50942
G1 F2460
M204 S8000
G3 X171.111 Y154.399 I9.133 J10.528 E.01848
; LINE_WIDTH: 0.463466
G1 X171.303 Y154.247 E.00837
; LINE_WIDTH: 0.421243
G1 X171.498 Y154.097 E.00759
; LINE_WIDTH: 0.384066
G1 X171.597 Y154.024 E.00343
; LINE_WIDTH: 0.3564
G1 X171.697 Y153.951 E.00315
; LINE_WIDTH: 0.326518
G1 X171.798 Y153.879 E.00286
; LINE_WIDTH: 0.294464
G1 X171.898 Y153.807 E.00254
; LINE_WIDTH: 0.278089
G1 X172.011 Y153.622 E.00416
M204 S10000
G1 X170.739 Y154.711 F60000
; LINE_WIDTH: 0.555552
G1 F2460
M204 S8000
G2 X168.495 Y158.072 I4.371 J5.347 E.17131
; LINE_WIDTH: 0.602075
G2 X168.214 Y159.904 I6.594 J1.951 E.0847
; LINE_WIDTH: 0.629647
G1 X168.211 Y167.105 E.34429
; WIPE_START
G1 F6135.738
G1 X168.212 Y165.105 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.679 Y158.916 Z4.2 F60000
G1 X174.911 Y155.825 Z4.2
G1 Z3.8
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.433132
G1 F2460
M204 S8000
G2 X174.911 Y158.43 I384.783 J1.242 E.08284
M204 S10000
G1 X175.092 Y160.372 F60000
; LINE_WIDTH: 0.423139
G1 F2460
M204 S8000
G1 X175.299 Y160.258 E.00729
G1 X175.402 Y159.945 E.01023
G1 X175.332 Y159.626 E.01009
G1 X174.977 Y158.804 E.02775
G1 X174.911 Y158.49 E.00995
G3 X174.68 Y159.254 I-2.463 J-.33 E.02483
G1 X174.449 Y159.775 E.01766
G1 X174.436 Y160.061 E.00887
G1 X174.523 Y160.259 E.00669
G1 X174.839 Y160.404 E.01078
G1 X175.033 Y160.379 E.00604
M204 S10000
G1 X175.312 Y160.69 F60000
; LINE_WIDTH: 0.419989
G1 F2460
M204 S8000
G1 X175.586 Y160.526 E.00982
G1 X175.783 Y159.971 E.01809
G1 X175.689 Y159.498 E.01483
G1 X175.345 Y158.712 E.02634
G1 X175.294 Y158.301 E.01273
G1 X175.294 Y155.43 E.08822
G1 X174.557 Y155.465 E.02269
G1 X174.527 Y155.497 E.00132
G1 X174.527 Y158.315 E.0866
G1 X174.479 Y158.715 E.01238
G2 X174.054 Y159.784 I5.762 J2.914 E.0354
G1 X174.079 Y160.192 E.01256
G1 X174.235 Y160.525 E.01129
G1 X174.657 Y160.751 E.01469
G1 X174.995 Y160.784 E.01044
G1 X175.254 Y160.707 E.00832
M204 S10000
G1 X176.082 Y160.306 F60000
; LINE_WIDTH: 0.41999
G1 F2460
M204 S8000
G1 X176.16 Y159.997 E.00981
G1 X176.1 Y159.514 E.01496
G3 X175.711 Y158.621 I6.23 J-3.253 E.02995
G1 X175.671 Y158.301 E.0099
G1 X175.671 Y155.053 E.09981
G2 X174.15 Y155.16 I-.308 J6.467 E.04696
G1 X174.15 Y158.315 E.09695
G1 X174.113 Y158.626 E.00963
G2 X173.677 Y159.728 I5.729 J2.903 E.03646
G1 X173.7 Y160.222 E.01519
G2 X173.947 Y160.791 I2.402 J-.709 E.01911
G1 X174.405 Y161.054 E.01622
G1 X174.77 Y161.155 E.01163
G1 X175.151 Y161.137 E.01172
G1 X175.48 Y161.029 E.01063
G1 X175.873 Y160.793 E.01409
G1 X176.058 Y160.361 E.01443
M204 S10000
G1 X176.415 Y160.51 F60000
; LINE_WIDTH: 0.41999
G1 F2460
M204 S8000
G1 X176.536 Y160.023 E.01543
G1 X176.468 Y159.419 E.01865
G1 X176.164 Y158.756 E.02241
G1 X176.052 Y158.386 E.01187
G1 X176.048 Y154.676 E.11402
G2 X174.456 Y154.716 I-.504 J11.44 E.04898
G1 X173.773 Y154.849 E.02138
G1 X173.773 Y158.315 E.1065
G1 X173.747 Y158.538 E.00688
G2 X173.301 Y159.672 I5.474 J2.806 E.03753
G1 X173.296 Y160.143 E.01445
G1 X173.426 Y160.597 E.01451
G1 X173.659 Y161.057 E.01585
G1 X174.148 Y161.356 E.0176
G1 X174.63 Y161.521 E.01564
G1 X175.092 Y161.534 E.0142
G1 X175.53 Y161.415 E.01397
G1 X176.16 Y161.06 E.0222
G1 X176.39 Y160.564 E.01679
M204 S10000
G1 X176.231 Y161.897 F60000
; LINE_WIDTH: 0.41999
G1 F2460
M204 S8000
G1 X176.677 Y161.629 E.01599
G1 X176.802 Y161.574 E.0042
G1 X176.823 Y161.421 E.00476
G1 X177.086 Y160.903 E.01784
G1 X177.276 Y160.255 E.02075
G2 X177.202 Y159.231 I-3.859 J-.238 E.03164
G2 X176.802 Y158.301 I-18.964 J7.599 E.03111
G1 X176.802 Y153.921 E.13458
G1 X175.011 Y153.922 E.05505
G1 X174.357 Y153.967 E.02013
G1 X173.508 Y154.132 E.02659
G1 X173.019 Y154.293 E.01582
G1 X173.019 Y158.315 E.12357
G1 X172.736 Y158.918 E.02047
G1 X172.547 Y159.561 E.02057
G1 X172.541 Y160.221 E.02027
G1 X172.687 Y160.775 E.01761
G1 X172.999 Y161.421 E.02203
G1 X173.054 Y161.602 E.00583
G2 X174.184 Y162.188 I5.237 J-8.731 E.03914
G1 X174.69 Y162.283 E.01581
G1 X175.189 Y162.284 E.01534
G1 X175.789 Y162.124 E.0191
G1 X176.178 Y161.925 E.01342
M204 S10000
G1 X175.65 Y161.773 F60000
G1 F2460
M204 S8000
G2 X176.459 Y161.32 I-6.083 J-11.825 E.02851
G1 X176.734 Y160.764 E.01907
G1 X176.902 Y160.188 E.01842
G1 X176.912 Y160.048 E.00431
G2 X176.484 Y158.551 I-3.061 J.066 E.04837
G1 X176.425 Y158.301 E.0079
G1 X176.425 Y154.298 E.12299
G1 X175.024 Y154.299 E.04305
G1 X174.407 Y154.342 E.01902
G1 X173.603 Y154.498 E.02515
G1 X173.396 Y154.566 E.00671
G1 X173.396 Y158.315 E.11519
G1 X173.335 Y158.571 E.00809
G1 X173.088 Y159.058 E.01677
G1 X172.924 Y159.617 E.01789
G1 X172.919 Y160.182 E.01736
G1 X173.08 Y160.749 E.01814
G3 X173.362 Y161.317 I-3.336 J2.01 E.01949
G1 X173.976 Y161.693 E.02212
G1 X174.567 Y161.893 E.01918
G1 X175.14 Y161.909 E.01762
G1 X175.592 Y161.789 E.01436
; WIPE_START
G1 F9547.299
G1 X175.14 Y161.909 E-.1776
G1 X174.567 Y161.893 E-.21789
G1 X173.976 Y161.693 E-.2372
G1 X173.69 Y161.518 E-.12731
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X177.079 Y154.678 Z4.2 F60000
G1 X177.805 Y153.212 Z4.2
G1 Z3.8
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.629916
G1 F2460
M204 S8000
G1 X182.105 Y153.211 E.20568
; CHANGE_LAYER
; Z_HEIGHT: 4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F6132.924
G1 X180.105 Y153.212 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 20/58
; update layer progress
M73 L20
M991 S0 P19 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z4.2 I-.68 J-1.009 P1  F60000
G1 X174.861 Y156.743 Z4.2
G1 Z4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2760
M204 S8000
G3 X174.573 Y156.761 I.049 J3.166 E.65033
G1 X174.801 Y156.747 E.00756
; COOLING_NODE: 0
; WIPE_START
G1 F8843.478
G1 X175.172 Y156.753 E-.14087
G1 X175.466 Y156.792 E-.11295
G1 X175.783 Y156.865 E-.12333
G1 X176.083 Y156.968 E-.12079
G1 X176.354 Y157.09 E-.11281
G1 X176.636 Y157.254 E-.12404
G1 X176.69 Y157.293 E-.02521
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X173.508 Y153.738 Z4.4 F60000
G1 Z4
G1 E.8 F1800
G1 F2760
M204 S8000
G1 X173.858 Y153.652 E.01195
G3 X174.999 Y153.531 I1.264 J6.49 E.03811
G1 X177.195 Y153.53 E.07284
G1 X177.195 Y156.636 E.10301
G2 X172.627 Y156.644 I-2.277 J3.327 E.16108
G1 X172.627 Y154.018 E.08711
G3 X173.189 Y153.818 I2.495 J6.123 E.01978
G1 X173.449 Y153.753 E.00892
; COOLING_NODE: 0
M204 S10000
G1 X172.735 Y153.544 F60000
G1 F2760
M204 S8000
G1 X172.838 Y153.507 E.00364
G3 X174.991 Y153.124 I2.319 J6.79 E.07284
G1 X177.602 Y153.123 E.08659
G1 X177.602 Y157.522 E.14592
G2 X175.895 Y156.473 I-2.948 J2.883 E.06714
G2 X172.22 Y157.537 I-.968 J3.534 E.13352
G1 X172.22 Y153.75 E.12561
G1 X172.679 Y153.567 E.01641
; COOLING_NODE: 0
; WIPE_START
G1 F8843.478
G1 X172.838 Y153.507 E-.06454
G1 X173.541 Y153.302 E-.27828
G1 X174.261 Y153.175 E-.27792
G1 X174.627 Y153.149 E-.13927
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.813 Y154.325 Z4.4 F60000
G1 Z4
G1 E.8 F1800
G1 F2760
M204 S8000
G1 X170.603 Y155.449 E.05478
G2 X168.709 Y159.903 I4.321 J4.467 E.16492
G1 X168.709 Y167.309 E.24565
G1 X167.715 Y167.309 E.03295
G1 X167.717 Y159.985 E.24294
G3 X174.984 Y152.717 I7.408 J.14 E.37678
G1 X182.309 Y152.715 E.24297
G1 X182.309 Y153.709 E.03295
G1 X178.009 Y153.709 E.14264
M73 P58 R6
G1 X178.009 Y158.069 E.14465
G3 X178.009 Y161.752 I-3.146 J1.842 E.12808
G1 X178.009 Y162.809 E.03504
G1 X177.062 Y162.809 E.0314
G3 X172.765 Y162.809 I-2.149 J-2.959 E.15237
G1 X171.813 Y162.809 E.03158
G1 X171.813 Y161.758 E.03487
G3 X171.813 Y158.066 I3.183 J-1.846 E.12827
G1 X171.813 Y154.385 E.1221
; COOLING_NODE: 0
M204 S250
G1 X171.421 Y155.224 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2177
M204 S5000
G2 X169.983 Y156.833 I4.912 J5.838 E.06652
G2 X169.101 Y159.908 I4.95 J3.084 E.09958
G1 X169.101 Y167.701 E.23944
G1 X167.323 Y167.701 E.05461
G1 X167.325 Y159.977 E.23732
G3 X174.977 Y152.325 I7.801 J.148 E.36749
G1 X182.701 Y152.323 E.23732
G1 X182.701 Y154.101 E.05461
G1 X178.401 Y154.101 E.13213
G1 X178.401 Y157.974 E.11902
G3 X178.401 Y161.847 I-3.505 J1.937 E.12422
G1 X178.401 Y163.201 E.04159
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X177.173 Y163.201 E.03773
G3 X172.65 Y163.201 I-2.261 J-3.317 E.14762
G1 X171.421 Y163.201 E.03778
G1 X171.421 Y161.849 E.04153
G3 X171.421 Y157.973 I3.537 J-1.938 E.12424
G1 X171.421 Y155.284 E.08262
M204 S10000
G1 X170.739 Y154.712 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.553847
G1 F2760
M204 S8000
G2 X168.495 Y158.073 I4.372 J5.348 E.17074
; LINE_WIDTH: 0.601906
G2 X168.213 Y159.995 I6.569 J1.948 E.0888
; LINE_WIDTH: 0.628445
G1 X168.212 Y167.105 E.33926
; WIPE_START
G1 F6148.336
G1 X168.212 Y165.105 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.314 Y162.605 Z4.4 F60000
G1 Z4
G1 E.8 F1800
; LINE_WIDTH: 0.184323
G1 F2760
M204 S8000
G1 X172.032 Y161.703 E.01089
M204 S10000
G1 X172.016 Y161.712 F60000
; LINE_WIDTH: 0.408789
G1 F2760
M204 S8000
G1 X172.345 Y162.605 E.02838
M204 S10000
G1 X172.016 Y162.27 F60000
; LINE_WIDTH: 0.354563
G1 F2760
M204 S8000
G1 X172.847 Y162.605 E.02275
; WIPE_START
G1 F11551.701
G1 X172.016 Y162.27 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.728 Y162.739 Z4.4 F60000
G1 Z4
G1 E.8 F1800
; FEATURE: Top surface
; LINE_WIDTH: 0.42
G1 F2760
M204 S2000
G1 X177.741 Y160.725 E.08751
G1 X177.875 Y160.591
G1 X177.982 Y159.951
G1 X177.848 Y160.085
G1 X175.086 Y162.847 E.12005
G1 X174.952 Y162.981
G1 X174.433 Y162.967
G1 X174.567 Y162.833
G1 X177.835 Y159.564 E.14203
G1 X177.969 Y159.431
G1 X177.878 Y158.988
G1 X177.745 Y159.122
G1 X174.119 Y162.747 E.15754
G1 X173.986 Y162.881
G1 X173.594 Y162.739
G1 X173.728 Y162.605
G1 X177.606 Y158.727 E.16853
G1 X177.74 Y158.593
G1 X177.556 Y158.244
G1 X177.422 Y158.378
G1 X173.378 Y162.422 E.17575
G1 X173.244 Y162.556
G1 X172.93 Y162.336
G1 X173.064 Y162.203
G1 X177.202 Y158.064 E.17985
G1 X177.336 Y157.93
G1 X177.082 Y157.651
G1 X176.948 Y157.785
G1 X172.787 Y161.946 E.18084
G1 X172.653 Y162.08
G1 X172.409 Y161.791
G1 X172.543 Y161.658
G1 X176.657 Y157.543 E.17878
G1 X176.79 Y157.41
G1 X176.466 Y157.201
G1 X176.332 Y157.335
G1 X172.332 Y161.334 E.17381
G1 X172.199 Y161.468
G1 X172.032 Y161.102
G1 X172.165 Y160.968
G1 X175.97 Y157.164 E.16532
G1 X176.103 Y157.03
G1 X175.693 Y156.908
G1 X175.559 Y157.041
G1 X172.04 Y160.561 E.15292
G1 X171.906 Y160.694
G1 X171.841 Y160.226
G1 X171.974 Y160.093
G1 X175.094 Y156.973 E.13555
G1 X175.227 Y156.84
G1 X174.677 Y156.857
G1 X174.543 Y156.991
G1 X171.992 Y159.542 E.11086
G1 X171.858 Y159.676
G1 X172.039 Y158.962
G1 X172.172 Y158.828
G1 X173.825 Y157.175 E.07181
M204 S10000
G1 X173.138 Y157.566 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.105101
G1 F2760
M204 S8000
G2 X172.556 Y158.148 I7.136 J7.713 E.00417
; WIPE_START
G1 F15000
G1 X172.805 Y157.877 E-.33934
G1 X173.138 Y157.566 E-.42066
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X177.555 Y161.204 Z4.4 F60000
G1 Z4
G1 E.8 F1800
; LINE_WIDTH: 0.0935875
G1 F2760
M204 S8000
G1 X177.525 Y161.248 E.00022
; LINE_WIDTH: 0.118813
G1 X177.432 Y161.368 E.00094
; LINE_WIDTH: 0.158405
G1 X177.34 Y161.488 E.00143
; LINE_WIDTH: 0.201503
G1 X177.147 Y161.714 E.00383
; LINE_WIDTH: 0.234341
G3 X176.756 Y162.11 I-4.303 J-3.867 E.00868
; LINE_WIDTH: 0.20983
G1 X176.532 Y162.305 E.00404
; LINE_WIDTH: 0.173412
G1 X176.427 Y162.387 E.00142
; LINE_WIDTH: 0.142025
G1 X176.322 Y162.47 E.00108
; LINE_WIDTH: 0.107248
G1 X176.21 Y162.55 E.00072
M204 S10000
G1 X176.987 Y162.59 F60000
; LINE_WIDTH: 0.169097
G1 F2760
M204 S8000
G1 X177.805 Y162.293 E.00895
M204 S10000
G1 X177.805 Y162.262 F60000
; LINE_WIDTH: 0.45169
G1 F2760
M204 S8000
G1 X176.993 Y162.605 E.02936
M204 S10000
G1 X177.484 Y162.605 F60000
; LINE_WIDTH: 0.345109
G1 F2760
M204 S8000
G1 X177.798 Y161.711 E.02334
; WIPE_START
G1 F11913.082
G1 X177.484 Y162.605 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X177.805 Y158.062 Z4.4 F60000
G1 Z4
G1 E.8 F1800
; LINE_WIDTH: 0.148384
G1 F2760
M204 S8000
G1 X177.743 Y157.988 E.00083
; LINE_WIDTH: 0.121463
G1 X177.559 Y157.788 E.00174
; WIPE_START
G1 F15000
G1 X177.743 Y157.988 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X177.805 Y153.212 Z4.4 F60000
G1 Z4
G1 E.8 F1800
; LINE_WIDTH: 0.628686
G1 F2760
M204 S8000
G1 X182.105 Y153.212 E.20524
; WIPE_START
G1 F6145.803
G1 X180.105 Y153.212 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X173.801 Y154.874 Z4.4 F60000
G1 Z4
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.49869
G1 F2760
M204 S8000
G1 X174.464 Y154.768 E.02492
; LINE_WIDTH: 0.52915
G1 X175.041 Y154.736 E.02289
; LINE_WIDTH: 0.551065
G1 X175.385 Y154.749 E.01427
; LINE_WIDTH: 0.578835
G1 X175.729 Y154.763 E.01505
; LINE_WIDTH: 0.61233
G1 X175.883 Y154.777 E.00713
M204 S10000
G1 X176.425 Y155.423 F60000
; LINE_WIDTH: 0.41999
G1 F2760
M204 S8000
G1 X176.425 Y154.3 E.03452
G1 X175.025 Y154.3 E.04302
G1 X174.408 Y154.343 E.01902
G1 X173.605 Y154.499 E.02514
G1 X173.396 Y154.568 E.00675
G1 X173.396 Y155.426 E.02636
G1 X173.901 Y155.266 E.01627
G3 X175.692 Y155.225 I1.036 J6.072 E.05524
G1 X176.367 Y155.407 E.02149
M204 S10000
G1 X176.802 Y155.98 F60000
G1 F2760
M204 S8000
G1 X176.802 Y153.923 E.06322
G1 X175.012 Y153.923 E.05501
G1 X174.359 Y153.968 E.02013
G1 X173.509 Y154.134 E.02658
G1 X173.019 Y154.295 E.01586
G1 X173.019 Y155.971 E.05149
G1 X173.984 Y155.635 E.03138
G3 X175.662 Y155.601 I.952 J5.558 E.05177
G1 X176.511 Y155.84 E.0271
G1 X176.748 Y155.954 E.0081
; WIPE_START
G1 F9547.299
G1 X176.511 Y155.84 E-.10012
G1 X175.662 Y155.601 E-.33514
G1 X174.975 Y155.546 E-.26175
G1 X174.81 Y155.554 E-.06299
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.203 Y157.864 Z4.4 F60000
G1 Z4
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.114647
G1 F2760
M204 S8000
G1 X172.062 Y158.025 E.00125
G1 X172.036 Y158.115 E.00055
; WIPE_START
G1 F15000
G1 X172.062 Y158.025 E-.23079
G1 X172.203 Y157.864 E-.52921
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X170.739 Y154.712 Z4.4 F60000
G1 Z4
G1 E.8 F1800
; LINE_WIDTH: 0.5077
G1 F2760
M204 S8000
G3 X171.112 Y154.399 I9.134 J10.531 E.01843
; LINE_WIDTH: 0.46173
G1 X171.304 Y154.248 E.00834
; LINE_WIDTH: 0.419501
G1 X171.499 Y154.098 E.00756
; LINE_WIDTH: 0.382321
G1 X171.598 Y154.025 E.00341
; LINE_WIDTH: 0.354628
G1 X171.698 Y153.951 E.00314
; LINE_WIDTH: 0.324771
G1 X171.799 Y153.879 E.00284
; LINE_WIDTH: 0.292747
G1 X171.899 Y153.808 E.00252
; LINE_WIDTH: 0.276578
G1 X172.014 Y153.622 E.00416
; CHANGE_LAYER
; Z_HEIGHT: 4.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F15000
G1 X171.899 Y153.808 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 21/58
; update layer progress
M73 L21
M991 S0 P20 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 1
M204 S10000
G17
G3 Z4.4 I-1.212 J.109 P1  F60000
G1 X172.547 Y161.012 Z4.4
G1 Z4.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2385
M204 S8000
G1 X172.51 Y160.93 E.00299
G3 X174.634 Y157.315 I2.401 J-1.021 E.16155
G1 X174.869 Y157.301 E.00779
G3 X172.629 Y161.175 I.042 J2.608 E.36532
G1 X172.574 Y161.065 E.00406
; COOLING_NODE: 1
M204 S10000
G1 X172.913 Y160.833 F60000
G1 F2385
M204 S8000
G1 X172.885 Y160.771 E.00228
G3 X174.678 Y157.72 I2.026 J-.862 E.13636
G1 X174.874 Y157.708 E.00651
G3 X172.985 Y160.977 I.036 J2.201 E.30832
G1 X172.94 Y160.887 E.00335
; COOLING_NODE: 1
M204 S250
G1 X173.262 Y160.65 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2385
M204 S5000
G1 X173.246 Y160.618 E.00113
G3 X174.721 Y158.11 I1.665 J-.708 E.10383
G1 X174.88 Y158.101 E.00488
G3 X173.429 Y160.947 I.031 J1.809 E.22893
G1 X173.292 Y160.703 E.00862
; COOLING_NODE: 1
; WIPE_START
G1 F9547.055
M204 S8000
G1 X173.246 Y160.618 E-.03676
M73 P59 R6
G1 X173.14 Y160.286 E-.13229
G1 X173.101 Y159.942 E-.13153
G1 X173.128 Y159.595 E-.13217
G1 X173.232 Y159.233 E-.14336
G1 X173.393 Y158.925 E-.13194
G1 X173.478 Y158.818 E-.05194
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X173.508 Y153.739 Z4.6 F60000
G1 Z4.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2385
M204 S8000
G1 X173.859 Y153.653 E.01198
G3 X175 Y153.532 I1.264 J6.49 E.03811
G1 X177.195 Y153.532 E.07281
G1 X177.195 Y157.906 E.14511
G2 X175.44 Y156.94 I-2.457 J2.385 E.06744
G2 X172.627 Y157.919 I-.517 J3.042 E.10311
G1 X172.627 Y154.02 E.12935
G3 X173.19 Y153.82 I2.496 J6.123 E.01983
G1 X173.45 Y153.754 E.0089
; COOLING_NODE: 1
M204 S10000
G1 X172.735 Y153.546 F60000
G1 F2385
M204 S8000
G1 X172.839 Y153.508 E.00367
G3 X174.993 Y153.125 I2.318 J6.789 E.07283
G1 X177.602 Y153.124 E.08655
G1 X177.602 Y158.163 E.16714
G3 X177.602 Y161.658 I-2.845 J1.748 E.12201
G1 X177.602 Y162.402 E.02466
G1 X176.943 Y162.402 E.02186
G3 X174.641 Y163.09 I-2.093 J-2.806 E.08135
G3 X172.879 Y162.402 I.397 J-3.615 E.06347
G1 X172.22 Y162.402 E.02187
G1 X172.22 Y161.659 E.02465
G3 X172.22 Y158.168 I2.849 J-1.745 E.12184
G1 X172.22 Y153.752 E.14648
G1 X172.68 Y153.568 E.01643
; COOLING_NODE: 1
; WIPE_START
G1 F8843.478
G1 X172.839 Y153.508 E-.0648
G1 X173.542 Y153.303 E-.27817
G1 X174.262 Y153.176 E-.27783
G1 X174.628 Y153.15 E-.1392
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.813 Y154.325 Z4.6 F60000
G1 Z4.2
G1 E.8 F1800
G1 F2385
M204 S8000
G1 X170.602 Y155.449 E.05479
G2 X168.709 Y159.906 I4.323 J4.468 E.16499
G1 X168.709 Y167.309 E.24557
G1 X167.717 Y167.309 E.03291
G1 X167.718 Y159.988 E.24285
G3 X174.985 Y152.718 I7.408 J.138 E.37683
G1 X182.309 Y152.717 E.24293
G1 X182.309 Y153.709 E.03291
G1 X178.009 Y153.709 E.14264
G1 X178.009 Y158.066 E.14456
G3 X178.009 Y161.755 I-3.156 J1.844 E.12825
G1 X178.009 Y162.809 E.03495
G1 X177.06 Y162.809 E.03148
G3 X172.762 Y162.809 I-2.149 J-2.966 E.15234
G1 X171.813 Y162.809 E.03149
G1 X171.813 Y161.755 E.03494
G3 X171.813 Y158.069 I3.151 J-1.843 E.12817
G1 X171.813 Y154.385 E.1222
; COOLING_NODE: 0
M204 S250
G1 X171.421 Y155.224 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2200
M204 S5000
G2 X169.983 Y156.833 I4.913 J5.838 E.06652
G2 X169.101 Y159.909 I4.97 J3.09 E.0996
G1 X169.101 Y167.701 E.23941
G1 X167.325 Y167.701 E.05458
G1 X167.326 Y159.979 E.23726
M73 P59 R5
G3 X174.978 Y152.326 I7.801 J.147 E.3675
G1 X182.701 Y152.325 E.23729
G1 X182.701 Y154.101 E.05458
G1 X178.401 Y154.101 E.13213
G1 X178.401 Y157.973 E.11899
G3 X178.401 Y161.848 I-3.509 J1.938 E.12427
G1 X178.401 Y163.201 E.04156
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X177.172 Y163.201 E.03775
G3 X172.649 Y163.201 I-2.261 J-3.324 E.14759
G1 X171.421 Y163.201 E.03776
G1 X171.421 Y161.848 E.04156
G3 X171.421 Y157.974 I3.507 J-1.937 E.12425
G1 X171.421 Y155.284 E.08265
M204 S10000
G1 X170.74 Y154.712 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.505944
G1 F2385
M204 S8000
G3 X171.113 Y154.4 I9.128 J10.522 E.01836
; LINE_WIDTH: 0.459941
G1 X171.304 Y154.248 E.00831
; LINE_WIDTH: 0.41772
G1 X171.499 Y154.099 E.0075
; LINE_WIDTH: 0.380556
G1 X171.599 Y154.025 E.0034
; LINE_WIDTH: 0.352795
G1 X171.699 Y153.952 E.00312
; LINE_WIDTH: 0.322894
G1 X171.799 Y153.88 E.00282
; LINE_WIDTH: 0.290825
G1 X171.9 Y153.808 E.0025
; LINE_WIDTH: 0.274272
G1 X172.008 Y153.627 E.00398
M204 S10000
G1 X170.74 Y154.712 F60000
; LINE_WIDTH: 0.551663
G1 F2385
M204 S8000
G2 X168.519 Y157.997 I4.375 J5.35 E.1667
; LINE_WIDTH: 0.598447
G2 X168.215 Y159.904 I6.581 J2.027 E.08771
; LINE_WIDTH: 0.627171
G1 X168.213 Y167.105 E.34284
; WIPE_START
G1 F6161.743
G1 X168.213 Y165.105 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.282 Y158.647 Z4.6 F60000
G1 X172.393 Y158.471 Z4.6
G1 Z4.2
G1 E.8 F1800
; LINE_WIDTH: 0.224626
G1 F2385
M204 S8000
G1 X172.345 Y158.558 E.00146
G2 X172.522 Y161.584 I2.634 J1.364 E.04711
G1 X172.777 Y162.198 E.00985
M204 S10000
G1 X173.339 Y162.243 F60000
; LINE_WIDTH: 0.348292
G1 F2385
M204 S8000
G1 X172.423 Y161.873 E.02458
M204 S10000
G1 X172.423 Y161.802 F60000
; LINE_WIDTH: 0.268507
G1 F2385
M204 S8000
G1 X172.994 Y162.108 E.01191
; LINE_WIDTH: 0.219376
G2 X176.534 Y162.315 I1.907 J-2.25 E.0547
G1 X176.78 Y162.146 E.00429
; LINE_WIDTH: 0.266594
G1 X177.398 Y161.79 E.013
M204 S10000
G1 X177.398 Y161.866 F60000
; LINE_WIDTH: 0.430707
G1 F2385
M204 S8000
G1 X176.44 Y162.27 E.03286
M204 S10000
G1 X177.019 Y162.198 F60000
; LINE_WIDTH: 0.253099
G1 F2385
M204 S8000
G1 X177.348 Y161.499 E.01323
; LINE_WIDTH: 0.21743
G2 X177.579 Y158.777 I-2.478 J-1.582 E.04041
G1 X177.53 Y158.669 E.00169
G3 X177.421 Y158.417 I.403 J-.323 E.00395
; LINE_WIDTH: 0.16757
G1 X177.427 Y158.387 E.0003
; LINE_WIDTH: 0.13084
G1 X177.433 Y158.358 E.00021
; LINE_WIDTH: 0.104701
G1 X177.419 Y158.299 E.00031
; WIPE_START
G1 F15000
G1 X177.433 Y158.358 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X176.802 Y157.096 Z4.6 F60000
G1 Z4.2
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F2385
M204 S8000
G1 X176.802 Y153.924 E.09746
G1 X175.013 Y153.924 E.05497
G1 X174.359 Y153.97 E.02015
G1 X173.511 Y154.135 E.02656
G1 X173.019 Y154.297 E.01592
G1 X173.019 Y157.091 E.08587
G1 X173.279 Y156.917 E.00961
G1 X173.847 Y156.672 E.01903
G1 X174.528 Y156.523 E.02142
G1 X175.074 Y156.513 E.01677
G1 X175.831 Y156.628 E.02352
G1 X176.447 Y156.867 E.02031
G1 X176.752 Y157.063 E.01113
M204 S10000
G1 X176.425 Y156.453 F60000
G1 F2385
M204 S8000
G1 X176.425 Y154.301 E.06613
G1 X175.027 Y154.301 E.04298
G1 X174.409 Y154.344 E.01903
G1 X173.606 Y154.5 E.02511
G1 X173.396 Y154.57 E.0068
G1 X173.396 Y156.456 E.05795
G1 X173.805 Y156.291 E.01353
G1 X174.46 Y156.152 E.02058
G1 X175.07 Y156.136 E.01875
G1 X175.899 Y156.257 E.02574
G1 X176.369 Y156.432 E.01543
M204 S10000
G1 X176.048 Y155.909 F60000
G1 F2385
M204 S8000
G1 X176.048 Y154.678 E.03783
G2 X174.458 Y154.719 I-.502 J11.419 E.04892
G1 X173.773 Y154.852 E.02144
G1 X173.773 Y155.913 E.03258
G1 X174.372 Y155.785 E.0188
G1 X175.065 Y155.759 E.02132
G3 X175.991 Y155.893 I-.543 J7.011 E.02875
M204 S10000
G1 X175.676 Y155.455 F60000
; LINE_WIDTH: 0.389554
G1 F2385
M204 S8000
G1 X175.676 Y155.05 E.01141
G2 X174.538 Y155.071 I-.401 J9.222 E.03216
G1 X174.125 Y155.142 E.01184
G1 X174.125 Y155.478 E.00949
G3 X175.616 Y155.449 I.831 J4.295 E.04234
; WIPE_START
G1 F10385.615
G1 X175.061 Y155.394 E-.21208
G1 X174.552 Y155.408 E-.19343
G1 X174.125 Y155.478 E-.16444
G1 X174.125 Y155.142 E-.1277
G1 X174.287 Y155.114 E-.06235
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X177.805 Y153.213 Z4.6 F60000
G1 Z4.2
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.627446
G1 F2385
M204 S8000
G1 X182.105 Y153.213 E.20481
; CHANGE_LAYER
; Z_HEIGHT: 4.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F6158.842
G1 X180.105 Y153.213 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 22/58
; update layer progress
M73 L22
M991 S0 P21 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 1
M204 S10000
G17
G3 Z4.6 I-.875 J-.845 P1  F60000
G1 X172.556 Y161.031 Z4.6
G1 Z4.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2421
M204 S8000
G1 X172.508 Y160.929 E.00372
G3 X174.636 Y157.315 I2.401 J-1.02 E.16162
G1 X174.884 Y157.301 E.00826
G3 X172.619 Y161.159 I.024 J2.609 E.36534
G1 X172.583 Y161.084 E.00276
; COOLING_NODE: 1
M204 S10000
G1 X172.925 Y160.843 F60000
G1 F2421
M204 S8000
G1 X172.805 Y160.558 E.01027
G3 X174.679 Y157.72 I2.104 J-.648 E.12889
G1 X174.888 Y157.708 E.00694
G3 X172.977 Y160.964 I.021 J2.201 E.3083
G1 X172.949 Y160.898 E.00238
; COOLING_NODE: 1
M204 S250
G1 X173.285 Y160.692 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2421
M204 S5000
M73 P60 R5
G1 X173.18 Y160.441 E.00834
G3 X174.721 Y158.11 I1.729 J-.532 E.09809
G1 X174.892 Y158.101 E.00526
G3 X173.322 Y160.777 I.018 J1.809 E.2347
G1 X173.309 Y160.747 E.001
; COOLING_NODE: 1
; WIPE_START
G1 F9547.055
M204 S8000
G1 X173.18 Y160.441 E-.12597
G1 X173.11 Y160.101 E-.13205
G1 X173.106 Y159.772 E-.12508
G1 X173.166 Y159.43 E-.13187
G1 X173.289 Y159.106 E-.13185
G1 X173.448 Y158.854 E-.11318
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X173.508 Y153.741 Z4.8 F60000
G1 Z4.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2421
M204 S8000
G1 X173.859 Y153.654 E.01198
G3 X175.001 Y153.533 I1.265 J6.489 E.03813
G1 X177.195 Y153.533 E.07276
G1 X177.195 Y157.902 E.14494
G2 X175.484 Y156.948 I-2.471 J2.418 E.06589
G2 X172.627 Y157.919 I-.555 J3.055 E.10453
G1 X172.627 Y154.022 E.12929
G3 X173.192 Y153.821 I2.497 J6.121 E.01989
G1 X173.45 Y153.755 E.00885
; COOLING_NODE: 1
M204 S10000
G1 X172.736 Y153.547 F60000
G1 F2421
M204 S8000
G1 X172.84 Y153.509 E.00368
G3 X174.994 Y153.126 I2.319 J6.789 E.07284
G1 X177.602 Y153.126 E.08651
G1 X177.602 Y158.163 E.1671
G3 X177.602 Y161.658 I-2.844 J1.747 E.12201
G1 X177.602 Y162.402 E.02466
G1 X176.943 Y162.402 E.02183
G3 X174.641 Y163.09 I-2.095 J-2.812 E.08138
G3 X172.879 Y162.402 I.37 J-3.546 E.0635
G1 X172.22 Y162.402 E.02187
G1 X172.22 Y161.659 E.02462
G3 X172.22 Y158.168 I2.859 J-1.746 E.12183
G1 X172.22 Y153.754 E.14642
G1 X172.68 Y153.57 E.01646
; COOLING_NODE: 1
; WIPE_START
G1 F8843.478
G1 X172.84 Y153.509 E-.06492
G1 X173.543 Y153.304 E-.27821
G1 X174.264 Y153.177 E-.27823
G1 X174.628 Y153.152 E-.13864
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.813 Y154.325 Z4.8 F60000
G1 Z4.4
G1 E.8 F1800
G1 F2421
M204 S8000
G1 X170.602 Y155.449 E.05479
G2 X168.709 Y159.903 I4.324 J4.468 E.16491
G1 X168.709 Y167.309 E.24565
G1 X167.718 Y167.309 E.03286
G1 X167.719 Y159.988 E.24284
G3 X174.987 Y152.719 I7.408 J.139 E.3768
G1 X182.309 Y152.718 E.24289
G1 X182.309 Y153.709 E.03286
G1 X178.009 Y153.709 E.14264
G1 X178.009 Y158.066 E.14456
G3 X178.009 Y161.755 I-3.168 J1.844 E.12822
G1 X178.009 Y162.809 E.03495
G1 X177.06 Y162.809 E.03147
G3 X172.762 Y162.809 I-2.149 J-2.967 E.15235
G1 X171.813 Y162.809 E.03149
G1 X171.813 Y161.756 E.03493
G3 X171.813 Y158.069 I3.152 J-1.843 E.12819
G1 X171.813 Y154.385 E.1222
; COOLING_NODE: 0
M204 S250
G1 X171.421 Y155.224 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2218
M204 S5000
G2 X169.964 Y156.864 I4.881 J5.804 E.06762
G2 X169.101 Y159.908 I4.994 J3.061 E.09847
G1 X169.101 Y167.701 E.23944
G1 X167.326 Y167.701 E.05454
G1 X167.327 Y159.98 E.23724
G3 X174.98 Y152.327 I7.801 J.148 E.36749
G1 X182.701 Y152.326 E.23725
G1 X182.701 Y154.101 E.05454
G1 X178.401 Y154.101 E.13213
G1 X178.401 Y157.973 E.11899
G3 X178.401 Y161.848 I-3.523 J1.938 E.12424
G1 X178.401 Y163.201 E.04156
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X177.172 Y163.201 E.03775
G3 X172.649 Y163.201 I-2.261 J-3.324 E.14759
G1 X171.421 Y163.201 E.03776
G1 X171.421 Y161.848 E.04155
G3 X171.421 Y157.974 I3.508 J-1.937 E.12425
G1 X171.421 Y155.284 E.08265
M204 S10000
G1 X170.741 Y154.713 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.549795
G1 F2421
M204 S8000
G2 X168.528 Y157.971 I4.387 J5.36 E.16494
; LINE_WIDTH: 0.596663
G2 X168.216 Y159.9 I6.587 J2.057 E.08851
; LINE_WIDTH: 0.625941
G1 X168.213 Y167.105 E.34229
; WIPE_START
G1 F6174.736
G1 X168.214 Y165.105 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X170.612 Y157.859 Z4.8 F60000
G1 X172.013 Y153.626 Z4.8
G1 Z4.4
G1 E.8 F1800
; LINE_WIDTH: 0.272575
G1 F2421
M204 S8000
G1 X171.901 Y153.808 E.004
; LINE_WIDTH: 0.289048
G1 X171.8 Y153.88 E.00248
; LINE_WIDTH: 0.321103
G1 X171.699 Y153.952 E.00281
; LINE_WIDTH: 0.35104
G1 X171.6 Y154.026 E.00311
; LINE_WIDTH: 0.378811
G1 X171.5 Y154.099 E.00339
; LINE_WIDTH: 0.415966
G1 X171.305 Y154.248 E.00747
; LINE_WIDTH: 0.458191
G1 X171.114 Y154.4 E.00827
; LINE_WIDTH: 0.504164
G2 X170.741 Y154.713 I8.755 J10.836 E.01829
; WIPE_START
G1 F7804.983
G1 X171.114 Y154.4 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.393 Y158.472 Z4.8 F60000
G1 Z4.4
G1 E.8 F1800
; LINE_WIDTH: 0.218339
G1 F2421
M204 S8000
G1 X172.31 Y158.627 E.00252
G2 X172.513 Y161.566 I2.672 J1.292 E.04407
; LINE_WIDTH: 0.254221
G1 X172.808 Y162.198 E.01201
M204 S10000
G1 X173.34 Y162.243 F60000
; LINE_WIDTH: 0.349093
G1 F2421
M204 S8000
G1 X172.423 Y161.873 E.02466
M204 S10000
G1 X172.423 Y161.802 F60000
; LINE_WIDTH: 0.268498
G1 F2421
M204 S8000
G1 X172.994 Y162.108 E.01191
; LINE_WIDTH: 0.219558
G2 X176.57 Y162.291 I1.908 J-2.254 E.05537
G1 X176.804 Y162.129 E.0041
; LINE_WIDTH: 0.267418
G1 X177.398 Y161.789 E.01252
M204 S10000
G1 X177.398 Y161.864 F60000
; LINE_WIDTH: 0.438491
G1 F2421
M204 S8000
G1 X176.42 Y162.282 E.03429
M204 S10000
G1 X177.504 Y160.995 F60000
; LINE_WIDTH: 0.349171
G1 F2421
M204 S8000
G1 X177.087 Y162.198 E.03177
M204 S10000
G1 X177.022 Y162.198 F60000
; LINE_WIDTH: 0.252582
G1 F2421
M204 S8000
G1 X177.351 Y161.493 E.01329
; LINE_WIDTH: 0.217734
G2 X177.451 Y158.51 I-2.488 J-1.577 E.04459
G3 X177.418 Y158.409 I.134 J-.1 E.00154
; LINE_WIDTH: 0.165858
G1 X177.424 Y158.379 E.00031
; LINE_WIDTH: 0.127431
G1 X177.431 Y158.349 E.00021
; LINE_WIDTH: 0.102562
G1 X177.419 Y158.299 E.00025
; WIPE_START
G1 F15000
G1 X177.431 Y158.349 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X176.802 Y157.098 Z4.8 F60000
G1 Z4.4
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F2421
M204 S8000
G1 X176.802 Y153.925 E.09751
G1 X175.015 Y153.925 E.05493
G1 X174.361 Y153.971 E.02012
G1 X173.512 Y154.136 E.02658
G1 X173.019 Y154.299 E.01596
G1 X173.019 Y157.094 E.0859
G1 X173.319 Y156.896 E.01106
G1 X173.889 Y156.658 E.01897
G1 X174.532 Y156.522 E.0202
G1 X175.071 Y156.514 E.01656
G1 X175.857 Y156.636 E.02443
G1 X176.488 Y156.888 E.02087
G1 X176.753 Y157.065 E.00979
M204 S10000
G1 X176.425 Y156.456 F60000
G1 F2421
M204 S8000
G1 X176.425 Y154.302 E.06617
G1 X175.028 Y154.302 E.04294
G1 X174.411 Y154.345 E.01901
G1 X173.608 Y154.502 E.02514
G1 X173.396 Y154.571 E.00685
G1 X173.396 Y156.455 E.05788
G1 X173.848 Y156.278 E.01491
G1 X174.462 Y156.152 E.01928
G3 X175.928 Y156.265 I.415 J4.167 E.04539
G1 X176.369 Y156.434 E.01454
M204 S10000
G1 X176.048 Y155.91 F60000
G1 F2421
M204 S8000
G1 X176.048 Y154.679 E.0378
G2 X174.46 Y154.72 I-.502 J11.419 E.04886
G1 X173.773 Y154.854 E.0215
G1 X173.773 Y155.908 E.03241
G1 X174.39 Y155.782 E.01937
G3 X175.39 Y155.779 I.514 J5.471 E.03075
G1 X175.991 Y155.893 E.01879
M204 S10000
G1 X175.677 Y155.455 F60000
; LINE_WIDTH: 0.389712
G1 F2421
M204 S8000
G1 X175.677 Y155.051 E.01143
G2 X174.125 Y155.143 I-.386 J6.607 E.04404
G1 X174.125 Y155.477 E.00944
G3 X175.618 Y155.444 I.832 J3.789 E.04247
; WIPE_START
G1 F10380.88
G1 X175.459 Y155.414 E-.06126
G1 X175.061 Y155.395 E-.15138
G1 X174.559 Y155.408 E-.19107
G1 X174.125 Y155.477 E-.16709
G1 X174.125 Y155.143 E-.12698
G1 X174.286 Y155.116 E-.06222
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X177.805 Y153.214 Z4.8 F60000
G1 Z4.4
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.626216
G1 F2421
M204 S8000
G1 X182.105 Y153.213 E.20438
; CHANGE_LAYER
; Z_HEIGHT: 4.6
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F6171.83
G1 X180.105 Y153.213 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 23/58
; update layer progress
M73 L23
M991 S0 P22 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 1
M204 S10000
G17
G3 Z4.8 I-.878 J-.843 P1  F60000
G1 X172.569 Y161.057 Z4.8
G1 Z4.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2435
M204 S8000
G1 X172.526 Y160.972 E.00315
G3 X174.592 Y157.32 I2.382 J-1.063 E.16173
G1 X174.86 Y157.301 E.00892
G3 X172.648 Y161.212 I.048 J2.608 E.36412
G1 X172.596 Y161.111 E.00379
; COOLING_NODE: 1
M204 S10000
G1 X172.936 Y160.862 F60000
G1 F2435
M204 S8000
M73 P61 R5
G1 X172.817 Y160.594 E.00973
G3 X174.642 Y157.724 I2.092 J-.684 E.1289
G1 X174.869 Y157.708 E.00756
G3 X173.003 Y161.01 I.04 J2.201 E.30722
G1 X172.961 Y160.916 E.00339
; COOLING_NODE: 1
M204 S250
G1 X173.293 Y160.703 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2435
M204 S5000
G1 X173.19 Y160.471 E.0078
G3 X174.69 Y158.114 I1.72 J-.561 E.09806
G1 X174.878 Y158.101 E.00579
G3 X173.344 Y160.815 I.032 J1.809 E.23381
G1 X173.318 Y160.757 E.00193
; COOLING_NODE: 1
; WIPE_START
G1 F9547.055
M204 S8000
G1 X173.19 Y160.471 E-.11921
G1 X173.114 Y160.132 E-.13202
G1 X173.105 Y159.784 E-.13236
G1 X173.171 Y159.412 E-.14342
G1 X173.298 Y159.088 E-.13221
G1 X173.443 Y158.866 E-.10078
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X173.509 Y153.742 Z5 F60000
G1 Z4.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2435
M204 S8000
G1 X173.861 Y153.655 E.01204
G3 X175.002 Y153.534 I1.264 J6.49 E.03811
G1 X177.195 Y153.534 E.07272
G1 X177.195 Y157.902 E.1449
G2 X175.429 Y156.938 I-2.461 J2.407 E.06773
G2 X172.627 Y157.919 I-.505 J3.049 E.10273
G1 X172.627 Y154.023 E.12923
G3 X173.193 Y153.822 I2.498 J6.122 E.01993
G1 X173.45 Y153.757 E.00882
; COOLING_NODE: 1
M204 S10000
G1 X172.737 Y153.549 F60000
G1 F2435
M204 S8000
G1 X172.842 Y153.51 E.00371
G3 X174.995 Y153.127 I2.319 J6.79 E.07283
G1 X177.602 Y153.127 E.08647
G1 X177.602 Y158.168 E.16722
G3 X177.602 Y161.658 I-2.841 J1.745 E.12185
G1 X177.602 Y162.402 E.02466
G1 X176.942 Y162.402 E.02187
G3 X174.744 Y163.097 I-2.111 J-2.85 E.07791
G3 X172.879 Y162.402 I.256 J-3.533 E.06691
G1 X172.22 Y162.402 E.02187
G1 X172.22 Y161.66 E.0246
G3 X172.22 Y158.168 I2.863 J-1.746 E.12184
G1 X172.22 Y153.756 E.14636
G1 X172.681 Y153.571 E.01648
; COOLING_NODE: 1
; WIPE_START
G1 F8843.478
G1 X172.842 Y153.51 E-.06527
G1 X173.545 Y153.305 E-.2782
G1 X174.265 Y153.178 E-.27817
G1 X174.629 Y153.153 E-.13837
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.813 Y154.325 Z5 F60000
G1 Z4.6
G1 E.8 F1800
G1 F2435
M204 S8000
G1 X170.603 Y155.448 E.05476
G2 X168.709 Y159.906 I4.325 J4.469 E.16502
G1 X168.709 Y167.309 E.24557
G1 X167.719 Y167.309 E.03282
G1 X167.72 Y159.988 E.24285
G3 X174.988 Y152.72 I7.408 J.141 E.37675
G1 X182.309 Y152.719 E.24285
G1 X182.309 Y153.709 E.03282
G1 X178.009 Y153.709 E.14264
G1 X178.009 Y158.069 E.14465
G3 X178.009 Y161.755 I-3.151 J1.843 E.12816
G1 X178.009 Y162.809 E.03495
G1 X177.059 Y162.809 E.03149
G3 X172.762 Y162.809 I-2.149 J-2.969 E.15231
G1 X171.813 Y162.809 E.03149
G1 X171.813 Y161.756 E.03492
G3 X171.813 Y158.069 I3.174 J-1.843 E.12813
G1 X171.813 Y154.385 E.1222
; COOLING_NODE: 0
M204 S250
G1 X171.421 Y155.224 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2232
M204 S5000
G2 X169.959 Y156.872 I4.876 J5.798 E.06792
G2 X169.101 Y159.909 I4.999 J3.052 E.09819
G1 X169.101 Y167.701 E.23942
G1 X167.327 Y167.701 E.0545
G1 X167.328 Y159.981 E.23721
G3 X174.981 Y152.328 I7.801 J.148 E.36747
G1 X182.701 Y152.327 E.23721
G1 X182.701 Y154.101 E.0545
G1 X178.401 Y154.101 E.13213
G1 X178.401 Y157.974 E.11902
G3 X178.401 Y161.848 I-3.507 J1.937 E.12425
G1 X178.401 Y163.201 E.04156
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X177.172 Y163.201 E.03776
G3 X172.649 Y163.201 I-2.261 J-3.328 E.14757
G1 X171.421 Y163.201 E.03776
G1 X171.421 Y161.849 E.04155
G3 X171.421 Y157.974 I3.533 J-1.937 E.12419
G1 X171.421 Y155.284 E.08265
M204 S10000
G1 X170.741 Y154.713 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.548078
G1 F2435
M204 S8000
G2 X168.528 Y157.973 I4.392 J5.364 E.16445
; LINE_WIDTH: 0.595381
G2 X168.216 Y159.904 I6.605 J2.057 E.08836
; LINE_WIDTH: 0.624717
G1 X168.214 Y167.105 E.3414
; WIPE_START
G1 F6187.725
G1 X168.215 Y165.105 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X170.614 Y157.86 Z5 F60000
G1 X172.016 Y153.626 Z5
G1 Z4.6
G1 E.8 F1800
; LINE_WIDTH: 0.271174
G1 F2435
M204 S8000
G1 X171.902 Y153.809 E.00401
; LINE_WIDTH: 0.287311
G1 X171.801 Y153.881 E.00247
; LINE_WIDTH: 0.319378
G1 X171.7 Y153.952 E.00279
; LINE_WIDTH: 0.34929
G1 X171.601 Y154.026 E.00309
; LINE_WIDTH: 0.377025
G1 X171.501 Y154.099 E.00337
; LINE_WIDTH: 0.414221
G1 X171.306 Y154.249 E.00744
; LINE_WIDTH: 0.456457
G1 X171.114 Y154.401 E.00824
; LINE_WIDTH: 0.502458
G2 X170.741 Y154.713 I8.74 J10.817 E.01822
; WIPE_START
G1 F7833.968
G1 X171.114 Y154.401 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.956 Y157.323 Z5 F60000
G1 Z4.6
G1 E.8 F1800
; LINE_WIDTH: 0.104321
G1 F2435
M204 S8000
G1 X172.83 Y157.402 E.00074
; WIPE_START
G1 F15000
G1 X172.956 Y157.323 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.393 Y158.472 Z5 F60000
G1 Z4.6
G1 E.8 F1800
; LINE_WIDTH: 0.224826
G1 F2435
M204 S8000
G1 X172.31 Y158.627 E.00261
G2 X172.524 Y161.587 I2.69 J1.294 E.04604
G1 X172.773 Y162.198 E.00978
M204 S10000
G1 X173.342 Y162.245 F60000
; LINE_WIDTH: 0.353738
G1 F2435
M204 S8000
G1 X172.423 Y161.872 E.02512
M204 S10000
G1 X172.423 Y161.799 F60000
; LINE_WIDTH: 0.267969
G1 F2435
M204 S8000
G1 X172.994 Y162.109 E.0119
; LINE_WIDTH: 0.219616
G2 X176.576 Y162.287 I1.908 J-2.261 E.05549
G1 X176.816 Y162.119 E.00422
; LINE_WIDTH: 0.266204
G1 X177.398 Y161.788 E.01218
M204 S10000
G1 X177.398 Y161.864 F60000
; LINE_WIDTH: 0.441449
G1 F2435
M204 S8000
G1 X176.421 Y162.282 E.03452
M204 S10000
G1 X177.494 Y161.018 F60000
; LINE_WIDTH: 0.344935
G1 F2435
M204 S8000
G1 X177.088 Y162.198 E.0307
M204 S10000
G1 X177.025 Y162.198 F60000
; LINE_WIDTH: 0.252142
G1 F2435
M204 S8000
G1 X177.308 Y161.564 E.01183
G1 X177.373 Y161.455 E.00217
; LINE_WIDTH: 0.217618
G2 X177.562 Y158.735 I-2.491 J-1.54 E.04037
G1 X177.51 Y158.628 E.0017
G3 X177.417 Y158.408 I.323 J-.266 E.00345
; LINE_WIDTH: 0.164107
G1 X177.424 Y158.379 E.0003
; LINE_WIDTH: 0.125882
G1 X177.43 Y158.349 E.0002
; LINE_WIDTH: 0.101849
G1 X177.419 Y158.303 E.00023
; WIPE_START
G1 F15000
G1 X177.43 Y158.349 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X176.802 Y157.077 Z5 F60000
G1 Z4.6
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F2435
M204 S8000
G1 X176.802 Y153.926 E.09681
G1 X175.016 Y153.926 E.0549
G1 X174.363 Y153.972 E.02011
G1 X173.513 Y154.137 E.02661
G1 X173.019 Y154.3 E.01598
G1 X173.019 Y156.846 E.07822
G1 X173.11 Y156.851 E.0028
G1 X173.2 Y156.974 E.00469
G1 X173.541 Y156.788 E.01193
G1 X174.134 Y156.591 E.0192
G1 X174.687 Y156.519 E.01714
G1 X175.393 Y156.542 E.0217
G1 X176.116 Y156.721 E.0229
G1 X176.753 Y157.043 E.02192
M204 S10000
G1 X176.425 Y156.451 F60000
G1 F2435
M204 S8000
G1 X176.425 Y154.303 E.066
G1 X175.029 Y154.304 E.0429
G1 X174.412 Y154.347 E.019
G1 X173.608 Y154.503 E.02517
G1 X173.396 Y154.573 E.00686
G1 X173.396 Y156.442 E.05743
G1 X174.015 Y156.233 E.02006
G3 X175.507 Y156.173 I.927 J4.442 E.04609
G1 X176.216 Y156.358 E.02254
G1 X176.371 Y156.427 E.00519
M204 S10000
G1 X176.048 Y155.92 F60000
G1 F2435
M204 S8000
G1 X176.048 Y154.68 E.03809
G2 X174.462 Y154.721 I-.501 J11.406 E.04881
G1 X173.773 Y154.855 E.02155
G1 X173.773 Y155.916 E.03261
G3 X175.535 Y155.797 I1.185 J4.434 E.05461
G1 X175.99 Y155.906 E.01437
M204 S10000
G1 X175.676 Y155.446 F60000
; LINE_WIDTH: 0.391077
G1 F2435
M204 S8000
G1 X175.676 Y155.053 E.01115
G2 X174.128 Y155.147 I-.386 J6.414 E.04413
G1 X174.127 Y155.471 E.0092
G1 X174.689 Y155.4 E.01605
G1 X175.479 Y155.419 E.02242
G1 X175.617 Y155.438 E.00395
; WIPE_START
G1 F10340.177
G1 X175.479 Y155.419 E-.05294
G1 X174.689 Y155.4 E-.3003
G1 X174.127 Y155.471 E-.21491
G1 X174.128 Y155.147 E-.12318
G1 X174.305 Y155.115 E-.06866
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X177.805 Y153.214 Z5 F60000
G1 Z4.6
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.624986
G1 F2435
M204 S8000
G1 X182.105 Y153.214 E.20395
; CHANGE_LAYER
; Z_HEIGHT: 4.8
; LAYER_HEIGHT: 0.2
; WIPE_START
M73 P62 R5
G1 F6184.873
G1 X180.105 Y153.214 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 24/58
; update layer progress
M73 L24
M991 S0 P23 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 1
M204 S10000
G17
G3 Z5 I-.877 J-.844 P1  F60000
G1 X172.565 Y161.049 Z5
G1 Z4.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2392
M204 S8000
G1 X172.49 Y160.889 E.00586
G3 X174.636 Y157.315 I2.418 J-.979 E.16017
G1 X174.892 Y157.301 E.0085
G3 X172.605 Y161.134 I.017 J2.609 E.36613
G1 X172.59 Y161.103 E.00112
; COOLING_NODE: 1
M204 S10000
G1 X172.935 Y160.869 F60000
G1 F2392
M204 S8000
G1 X172.794 Y160.52 E.01246
G3 X174.679 Y157.72 I2.115 J-.611 E.1276
G1 X174.895 Y157.708 E.00717
G3 X172.965 Y160.943 I.014 J2.202 E.30895
G1 X172.957 Y160.924 E.00068
; COOLING_NODE: 1
M204 S250
G1 X173.297 Y160.722 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2392
M204 S5000
G1 X173.171 Y160.41 E.01033
G3 X174.721 Y158.11 I1.739 J-.501 E.0971
G1 X174.898 Y158.101 E.00545
G3 X173.322 Y160.777 I.012 J1.809 E.23458
; COOLING_NODE: 1
; WIPE_START
G1 F9547.055
M204 S8000
G1 X173.171 Y160.41 E-.1505
G1 X173.11 Y160.099 E-.12041
G1 X173.109 Y159.734 E-.13876
G1 X173.176 Y159.394 E-.13185
G1 X173.312 Y159.061 E-.13678
G1 X173.431 Y158.881 E-.08171
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X173.509 Y153.744 Z5.2 F60000
G1 Z4.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2392
M204 S8000
G1 X173.862 Y153.657 E.01206
G3 X175.003 Y153.536 I1.264 J6.489 E.03812
G1 X177.195 Y153.535 E.07268
G1 X177.195 Y157.911 E.14516
G2 X175.177 Y156.905 I-2.396 J2.277 E.07633
G2 X172.994 Y157.58 I-.265 J3.011 E.07773
G1 X172.627 Y157.913 E.01644
G1 X172.627 Y154.025 E.12895
G3 X173.193 Y153.823 I2.499 J6.121 E.01996
G1 X173.451 Y153.758 E.00881
; COOLING_NODE: 1
M204 S10000
G1 X172.737 Y153.55 F60000
G1 F2392
M204 S8000
G1 X172.843 Y153.512 E.00374
G3 X174.996 Y153.129 I2.318 J6.79 E.07282
G1 X177.602 Y153.128 E.08642
G1 X177.602 Y158.163 E.16702
G3 X177.602 Y161.654 I-2.835 J1.745 E.12188
G1 X177.602 Y162.402 E.02481
G1 X176.947 Y162.402 E.02171
G3 X175.287 Y163.079 I-2.25 J-3.14 E.06
G3 X173.29 Y162.659 I-.375 J-3.175 E.06891
G1 X172.879 Y162.402 E.01609
G1 X172.22 Y162.402 E.02187
G1 X172.22 Y161.658 E.02466
G3 X172.22 Y158.168 I2.854 J-1.745 E.1218
G1 X172.22 Y153.757 E.1463
G1 X172.682 Y153.573 E.0165
; COOLING_NODE: 1
; WIPE_START
G1 F8843.478
G1 X172.843 Y153.512 E-.06565
G1 X173.546 Y153.307 E-.2781
G1 X174.266 Y153.18 E-.27781
G1 X174.629 Y153.154 E-.13845
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.813 Y154.325 Z5.2 F60000
G1 Z4.8
G1 E.8 F1800
G1 F2392
M204 S8000
G1 X170.603 Y155.449 E.05478
G2 X168.709 Y159.906 I4.326 J4.469 E.16499
G1 X168.709 Y167.309 E.24557
G1 X167.72 Y167.309 E.03278
G1 X167.722 Y159.989 E.24281
G3 X174.989 Y152.722 I7.408 J.141 E.37675
G1 X182.309 Y152.72 E.24281
G1 X182.309 Y153.709 E.03278
G1 X178.009 Y153.709 E.14264
G1 X178.009 Y158.066 E.14456
G3 X178.009 Y161.752 I-3.179 J1.843 E.12808
G1 X178.009 Y162.809 E.03504
G1 X177.062 Y162.809 E.0314
G3 X172.762 Y162.809 I-2.15 J-2.971 E.15241
G1 X171.813 Y162.809 E.03149
G1 X171.813 Y161.755 E.03495
G3 X171.813 Y158.069 I3.172 J-1.843 E.1281
G1 X171.813 Y154.385 E.1222
; COOLING_NODE: 0
M204 S250
G1 X171.421 Y155.224 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2243
M204 S5000
G2 X169.931 Y156.917 I4.841 J5.761 E.06956
G2 X169.101 Y159.909 I5.032 J3.008 E.09655
G1 X169.101 Y167.701 E.23942
G1 X167.328 Y167.701 E.05446
G1 X167.329 Y159.982 E.23718
G3 X174.982 Y152.329 I7.801 J.148 E.36747
G1 X182.701 Y152.328 E.23717
G1 X182.701 Y154.101 E.05446
G1 X178.401 Y154.101 E.13213
G1 X178.401 Y157.973 E.11899
G3 X178.401 Y161.847 I-3.54 J1.937 E.12416
G1 X178.401 Y163.201 E.04159
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X177.173 Y163.201 E.03773
G3 X172.649 Y163.201 I-2.262 J-3.327 E.14761
G1 X171.421 Y163.201 E.03776
G1 X171.421 Y161.848 E.04156
G3 X171.421 Y157.974 I3.533 J-1.937 E.12418
G1 X171.421 Y155.284 E.08265
M204 S10000
G1 X170.741 Y154.714 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.500741
G1 F2392
M204 S8000
G3 X171.115 Y154.401 I9.164 J10.565 E.01819
; LINE_WIDTH: 0.454749
G1 X171.306 Y154.25 E.00819
; LINE_WIDTH: 0.412483
G1 X171.502 Y154.1 E.00743
; LINE_WIDTH: 0.375259
G1 X171.602 Y154.026 E.00334
; LINE_WIDTH: 0.347577
G1 X171.701 Y153.953 E.00306
; LINE_WIDTH: 0.317694
G1 X171.802 Y153.881 E.00278
; LINE_WIDTH: 0.285588
G1 X171.903 Y153.809 E.00245
; LINE_WIDTH: 0.269079
G1 X172.011 Y153.63 E.00385
M204 S10000
G1 X170.741 Y154.714 F60000
; LINE_WIDTH: 0.546444
G1 F2392
M204 S8000
G2 X168.53 Y157.971 I4.392 J5.361 E.16376
; LINE_WIDTH: 0.591857
G2 X168.22 Y159.762 I6.641 J2.072 E.08155
; LINE_WIDTH: 0.623389
G1 X168.215 Y167.105 E.34734
; WIPE_START
G1 F6201.884
G1 X168.216 Y165.105 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.282 Y158.646 Z5.2 F60000
G1 X172.4 Y158.458 Z5.2
G1 Z4.8
G1 E.8 F1800
; LINE_WIDTH: 0.224556
G1 F2392
M204 S8000
G1 X172.347 Y158.554 E.00162
G2 X172.513 Y161.564 I2.624 J1.365 E.04682
G1 X172.804 Y162.198 E.01032
M204 S10000
G1 X173.363 Y162.26 F60000
; LINE_WIDTH: 0.396918
G1 F2392
M204 S8000
G1 X172.423 Y161.868 E.02937
M204 S10000
G1 X172.423 Y161.793 F60000
; LINE_WIDTH: 0.267768
G1 F2392
M204 S8000
G1 X172.993 Y162.109 E.01194
; LINE_WIDTH: 0.219482
G2 X176.534 Y162.315 I1.907 J-2.259 E.05473
G1 X176.776 Y162.15 E.00421
; LINE_WIDTH: 0.269771
G1 X177.398 Y161.795 E.01323
M204 S10000
G1 X177.398 Y161.868 F60000
; LINE_WIDTH: 0.391954
G1 F2392
M204 S8000
G1 X176.466 Y162.255 E.0287
M204 S10000
G1 X177.011 Y162.198 F60000
; LINE_WIDTH: 0.249497
G1 F2392
M204 S8000
G1 X177.319 Y161.546 E.01215
; LINE_WIDTH: 0.217947
G2 X177.453 Y158.513 I-2.461 J-1.627 E.04547
G3 X177.426 Y158.426 I.111 J-.083 E.00132
; LINE_WIDTH: 0.169673
G1 X177.431 Y158.398 E.0003
; LINE_WIDTH: 0.134904
G1 X177.435 Y158.369 E.00022
; LINE_WIDTH: 0.107222
G1 X177.419 Y158.299 E.00037
; WIPE_START
G1 F15000
G1 X177.435 Y158.369 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X176.802 Y157.093 Z5.2 F60000
G1 Z4.8
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F2392
M204 S8000
G1 X176.802 Y153.927 E.09727
G1 X175.017 Y153.928 E.05486
G1 X174.363 Y153.973 E.02015
G1 X173.514 Y154.139 E.02656
G1 X173.019 Y154.302 E.01603
G1 X173.019 Y157.091 E.08569
G1 X173.282 Y156.916 E.00969
G1 X173.889 Y156.658 E.02026
G1 X174.533 Y156.522 E.02023
G1 X175.073 Y156.514 E.01661
G1 X175.882 Y156.643 E.02516
G1 X176.493 Y156.89 E.02024
G1 X176.752 Y157.06 E.00953
M204 S10000
G1 X176.425 Y156.455 F60000
G1 F2392
M204 S8000
G1 X176.425 Y154.305 E.06607
G1 X175.03 Y154.305 E.04287
G1 X174.412 Y154.348 E.01903
G1 X173.61 Y154.504 E.02512
G1 X173.396 Y154.575 E.00692
G1 X173.396 Y156.458 E.05786
G1 X173.848 Y156.278 E.01496
G1 X174.463 Y156.152 E.01927
G3 X175.954 Y156.273 I.414 J4.141 E.04623
G1 X176.369 Y156.433 E.01368
M204 S10000
G1 X176.026 Y155.903 F60000
G1 F2392
M204 S8000
G2 X176.048 Y154.682 I-18.169 J-.944 E.03753
G2 X174.462 Y154.723 I-.501 J11.392 E.04881
G1 X173.773 Y154.856 E.02155
G1 X173.773 Y155.908 E.03232
G1 X174.391 Y155.782 E.01937
G3 X175.389 Y155.779 I.514 J5.481 E.03072
G1 X175.967 Y155.891 E.01809
M204 S10000
G1 X175.677 Y155.457 F60000
; LINE_WIDTH: 0.388439
G1 F2392
M204 S8000
M73 P63 R5
G1 X175.677 Y155.053 E.01137
G2 X174.124 Y155.146 I-.385 J6.601 E.04391
G1 X174.124 Y155.478 E.00937
G3 X175.618 Y155.445 I.831 J3.777 E.04235
; WIPE_START
G1 F10419.115
G1 X175.46 Y155.415 E-.06133
G1 X175.064 Y155.396 E-.15065
G1 X174.56 Y155.408 E-.19166
G1 X174.124 Y155.478 E-.16771
G1 X174.124 Y155.146 E-.12641
G1 X174.285 Y155.118 E-.06224
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X177.805 Y153.215 Z5.2 F60000
G1 Z4.8
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.623756
G1 F2392
M204 S8000
G1 X182.105 Y153.215 E.20352
; CHANGE_LAYER
; Z_HEIGHT: 5
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F6197.971
G1 X180.105 Y153.215 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 25/58
; update layer progress
M73 L25
M991 S0 P24 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 1
M204 S10000
G17
G3 Z5.2 I-.879 J-.842 P1  F60000
G1 X172.577 Y161.073 Z5.2
G1 Z5
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2456
M204 S8000
G1 X172.527 Y160.972 E.00373
G3 X174.634 Y157.315 I2.383 J-1.063 E.16308
G1 X174.877 Y157.301 E.00807
G3 X172.649 Y161.212 I.033 J2.609 E.36369
G1 X172.605 Y161.126 E.0032
; COOLING_NODE: 1
M204 S10000
G1 X172.946 Y160.891 F60000
G1 F2456
M204 S8000
G1 X172.899 Y160.806 E.0032
G3 X174.678 Y157.72 I2.011 J-.897 E.13765
G1 X174.882 Y157.708 E.00676
G3 X173.108 Y161.175 I.028 J2.201 E.30037
G1 X172.976 Y160.943 E.00889
; COOLING_NODE: 1
M204 S250
G1 X173.286 Y160.698 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2456
M204 S5000
G1 X173.258 Y160.647 E.0018
G3 X174.72 Y158.11 I1.652 J-.737 E.10481
G1 X174.886 Y158.101 E.00509
G3 X173.429 Y160.949 I.024 J1.809 E.22872
G1 X173.316 Y160.75 E.00703
; COOLING_NODE: 1
; WIPE_START
G1 F9547.055
M204 S8000
G1 X173.258 Y160.647 E-.04509
G1 X173.189 Y160.47 E-.07217
G1 X173.111 Y160.101 E-.14315
G1 X173.107 Y159.754 E-.13208
G1 X173.17 Y159.412 E-.13196
G1 X173.312 Y159.062 E-.14344
G1 X173.444 Y158.859 E-.09211
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X173.509 Y153.745 Z5.4 F60000
G1 Z5
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2456
M204 S8000
G1 X173.864 Y153.658 E.01211
G3 X175.005 Y153.537 I1.264 J6.492 E.03811
G1 X177.195 Y153.537 E.07264
G1 X177.195 Y157.903 E.14483
G2 X175.481 Y156.947 I-2.468 J2.413 E.06598
G2 X172.627 Y157.919 I-.552 J3.056 E.10444
G1 X172.627 Y154.027 E.12912
G3 X173.195 Y153.825 I2.501 J6.123 E.02002
G1 X173.451 Y153.76 E.00876
; COOLING_NODE: 1
M204 S10000
G1 X172.738 Y153.552 F60000
G1 F2456
M204 S8000
G1 X172.844 Y153.513 E.00375
G3 X174.998 Y153.13 I2.319 J6.791 E.07283
G1 X177.602 Y153.129 E.08638
G1 X177.602 Y158.168 E.16713
G3 X177.602 Y161.654 I-2.809 J1.743 E.12179
G1 X177.602 Y162.402 E.02481
G1 X176.947 Y162.402 E.02172
G3 X175.286 Y163.079 I-2.249 J-3.138 E.06006
G3 X173.287 Y162.657 I-.371 J-3.189 E.06897
G1 X172.879 Y162.402 E.01596
G1 X172.22 Y162.402 E.02187
G1 X172.22 Y161.658 E.02466
G3 X172.22 Y158.168 I2.836 J-1.745 E.12187
G1 X172.22 Y153.759 E.14624
G1 X172.682 Y153.574 E.01653
; COOLING_NODE: 1
; WIPE_START
G1 F8843.478
G1 X172.844 Y153.513 E-.06576
G1 X173.547 Y153.308 E-.278
G1 X174.267 Y153.181 E-.2781
G1 X174.63 Y153.156 E-.13815
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.813 Y154.325 Z5.4 F60000
G1 Z5
G1 E.8 F1800
G1 F2456
M204 S8000
G1 X170.603 Y155.449 E.05478
G2 X168.709 Y159.903 I4.331 J4.472 E.16491
G1 X168.709 Y167.309 E.24566
G1 X167.722 Y167.309 E.03274
G1 X167.723 Y159.992 E.24271
G3 X174.99 Y152.723 I7.415 J.145 E.37672
G1 X182.309 Y152.722 E.24276
G1 X182.309 Y153.709 E.03274
G1 X178.009 Y153.709 E.14264
G1 X178.009 Y158.069 E.14465
G3 X178.009 Y161.752 I-3.167 J1.842 E.12801
G1 X178.009 Y162.809 E.03504
G1 X177.062 Y162.809 E.0314
G3 X172.762 Y162.809 I-2.15 J-2.97 E.15242
G1 X171.813 Y162.809 E.03149
G1 X171.813 Y161.755 E.03495
G3 X171.813 Y158.069 I3.157 J-1.843 E.12815
G1 X171.813 Y154.385 E.12221
; COOLING_NODE: 0
M204 S250
G1 X171.421 Y155.224 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2251
M204 S5000
G2 X169.983 Y156.833 I4.915 J5.841 E.06652
G2 X169.101 Y159.908 I4.95 J3.084 E.09958
G1 X169.101 Y167.701 E.23944
G1 X167.329 Y167.701 E.05443
G1 X167.331 Y159.984 E.23712
G3 X174.983 Y152.331 I7.807 J.154 E.36741
G1 X182.701 Y152.329 E.23713
G1 X182.701 Y154.101 E.05443
G1 X178.401 Y154.101 E.13213
G1 X178.401 Y157.974 E.11902
G3 X178.401 Y161.847 I-3.531 J1.937 E.12415
G1 X178.401 Y163.201 E.04159
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X177.173 Y163.201 E.03773
G3 X172.649 Y163.201 I-2.262 J-3.326 E.14762
G1 X171.421 Y163.201 E.03776
G1 X171.421 Y161.848 E.04156
G3 X171.421 Y157.974 I3.513 J-1.937 E.12423
G1 X171.421 Y155.284 E.08265
M204 S10000
G1 X170.928 Y154.556 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.486373
G1 F2456
M204 S8000
G1 X171.116 Y154.402 E.00881
; LINE_WIDTH: 0.452861
G1 X171.307 Y154.25 E.00814
; LINE_WIDTH: 0.410644
G1 X171.503 Y154.1 E.00738
; LINE_WIDTH: 0.373423
G1 X171.602 Y154.027 E.00333
; LINE_WIDTH: 0.345711
G1 X171.702 Y153.954 E.00305
; LINE_WIDTH: 0.315781
G1 X171.803 Y153.882 E.00276
; LINE_WIDTH: 0.283609
G1 X171.904 Y153.81 E.00244
; LINE_WIDTH: 0.267298
G1 X172.007 Y153.634 E.00372
M204 S10000
G1 X170.928 Y154.556 F60000
; LINE_WIDTH: 0.535622
G1 F2456
M204 S8000
G2 X169.084 Y156.689 I4.442 J5.703 E.11392
; LINE_WIDTH: 0.568525
G2 X168.278 Y159.101 I6.061 J3.367 E.10953
; LINE_WIDTH: 0.620762
G2 X168.216 Y160.002 I7.146 J.948 E.04258
G1 X168.215 Y167.105 E.33445
; WIPE_START
G1 F6230.086
G1 X168.215 Y165.105 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.762 Y162.198 Z5.4 F60000
G1 Z5
G1 E.8 F1800
; LINE_WIDTH: 0.224885
G1 F2456
M204 S8000
G1 X172.526 Y161.593 E.00963
G3 X172.345 Y158.558 I2.495 J-1.672 E.04727
G1 X172.393 Y158.471 E.00147
; WIPE_START
G1 F15000
G1 X172.345 Y158.558 E-.03765
G1 X172.195 Y158.897 E-.14088
G1 X172.057 Y159.393 E-.19548
G1 X172.019 Y159.686 E-.11255
G1 X172.02 Y160.131 E-.16886
G1 X172.058 Y160.403 E-.10457
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.423 Y161.802 Z5.4 F60000
G1 Z5
G1 E.8 F1800
; LINE_WIDTH: 0.268518
G1 F2456
M204 S8000
G1 X172.994 Y162.108 E.01191
; LINE_WIDTH: 0.219493
G2 X176.535 Y162.314 I1.908 J-2.258 E.05473
G1 X176.78 Y162.147 E.00427
; LINE_WIDTH: 0.270179
G1 X177.398 Y161.792 E.01319
M204 S10000
G1 X177.398 Y161.865 F60000
; LINE_WIDTH: 0.435079
G1 F2456
M204 S8000
G1 X176.432 Y162.275 E.03354
M204 S10000
G1 X177.02 Y162.198 F60000
; LINE_WIDTH: 0.249329
G1 F2456
M204 S8000
G1 X177.35 Y161.493 E.0131
; LINE_WIDTH: 0.217605
G2 X177.567 Y158.747 I-2.478 J-1.577 E.0408
G1 X177.511 Y158.628 E.00188
G3 X177.417 Y158.409 I.327 J-.269 E.00344
; LINE_WIDTH: 0.164897
G1 X177.424 Y158.379 E.0003
; LINE_WIDTH: 0.126296
G1 X177.43 Y158.35 E.00021
; LINE_WIDTH: 0.101959
G1 X177.419 Y158.303 E.00023
; WIPE_START
G1 F15000
G1 X177.43 Y158.35 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X177.502 Y161.001 Z5.4 F60000
G1 Z5
G1 E.8 F1800
; LINE_WIDTH: 0.349217
G1 F2456
M204 S8000
G1 X177.087 Y162.198 E.03161
; WIPE_START
G1 F11753.3
G1 X177.502 Y161.001 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X173.341 Y162.242 Z5.4 F60000
G1 Z5
G1 E.8 F1800
; LINE_WIDTH: 0.344224
G1 F2456
M204 S8000
G1 X172.423 Y161.874 E.02428
; WIPE_START
G1 F11948.094
G1 X173.341 Y162.242 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.475 Y155.423 Z5.4 F60000
G1 Z5
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.390167
G1 F2456
M204 S8000
G1 X175.676 Y155.445 E.0057
G1 X175.676 Y155.056 E.01101
G2 X174.126 Y155.149 I-.393 J6.392 E.04404
G1 X174.126 Y155.468 E.00903
G1 X174.728 Y155.398 E.01714
G1 X175.416 Y155.421 E.01947
M204 S10000
G1 X176.048 Y155.92 F60000
; LINE_WIDTH: 0.41999
G1 F2456
M204 S8000
G1 X176.048 Y154.683 E.03802
G2 X174.463 Y154.724 I-.5 J11.384 E.04875
G1 X173.773 Y154.858 E.02161
G1 X173.773 Y155.919 E.0326
G1 X174.145 Y155.821 E.01182
M73 P64 R5
G1 X174.767 Y155.752 E.01922
G3 X175.785 Y155.843 I-.052 J6.377 E.03145
G1 X175.991 Y155.903 E.00658
M204 S10000
G1 X176.425 Y156.447 F60000
G1 F2456
M204 S8000
G1 X176.425 Y154.306 E.06578
G1 X175.032 Y154.306 E.04283
G1 X174.414 Y154.349 E.01902
G1 X173.611 Y154.505 E.02514
G1 X173.396 Y154.576 E.00695
G1 X173.396 Y156.442 E.05733
G1 X174.08 Y156.218 E.0221
G3 X175.569 Y156.184 I.847 J4.412 E.046
G1 X176.272 Y156.379 E.02242
G1 X176.371 Y156.422 E.0033
M204 S10000
G1 X176.802 Y157.077 F60000
G1 F2456
M204 S8000
G1 X176.802 Y153.929 E.09673
G1 X175.018 Y153.929 E.05482
G1 X174.365 Y153.975 E.02013
G1 X173.515 Y154.14 E.02659
G1 X173.019 Y154.304 E.01607
G1 X173.019 Y157.073 E.08511
G1 X173.569 Y156.776 E.01921
G1 X174.192 Y156.578 E.02008
G1 X174.849 Y156.502 E.02033
G3 X176.166 Y156.741 I-.014 J3.827 E.04132
G1 X176.753 Y157.043 E.02029
; WIPE_START
G1 F9547.299
G1 X176.166 Y156.741 E-.25089
G1 X175.572 Y156.566 E-.23508
G1 X174.854 Y156.502 E-.27403
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X177.805 Y153.215 Z5.4 F60000
G1 Z5
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.622525
G1 F2456
M204 S8000
G1 X182.105 Y153.215 E.20309
; CHANGE_LAYER
; Z_HEIGHT: 5.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F6211.125
G1 X180.105 Y153.215 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 26/58
; update layer progress
M73 L26
M991 S0 P25 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 2
M204 S10000
G17
G3 Z5.4 I-.875 J-.846 P1  F60000
G1 X172.449 Y161.136 Z5.4
G1 Z5.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2288
M204 S8000
G1 X172.362 Y160.941 E.00709
G3 X174.767 Y157.162 I2.551 J-1.031 E.17359
G1 X174.91 Y157.158 E.00476
G3 X172.483 Y161.201 I.003 J2.752 E.38568
G1 X172.477 Y161.19 E.00043
; COOLING_NODE: 2
M204 S250
G1 X172.802 Y160.96 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2288
M204 S5000
G1 X172.655 Y160.602 E.01188
G3 X174.787 Y157.554 I2.256 J-.692 E.13166
G1 X174.907 Y157.551 E.00368
G3 X172.828 Y161.018 I.004 J2.36 E.30638
G1 X172.826 Y161.015 E.00011
; COOLING_NODE: 2
; WIPE_START
G1 F9547.055
M204 S8000
G1 X172.655 Y160.602 E-.1697
G1 X172.594 Y160.361 E-.09447
G1 X172.56 Y160.12 E-.09254
G1 X172.559 Y159.706 E-.15721
G1 X172.594 Y159.461 E-.09424
G1 X172.654 Y159.221 E-.09403
G1 X172.712 Y159.08 E-.05782
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.627 Y157.167 Z5.6 F60000
G1 Z5.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2288
M204 S8000
G1 X172.627 Y154.029 E.1041
G3 X175.006 Y153.538 I2.502 J6.121 E.08104
G1 X177.195 Y153.538 E.0726
G1 X177.195 Y157.167 E.12038
G2 X172.674 Y157.129 I-2.284 J2.794 E.16207
; COOLING_NODE: 2
; WIPE_START
G1 F8843.478
G1 X172.644 Y155.13 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.739 Y153.553 Z5.6 F60000
G1 Z5.2
G1 E.8 F1800
G1 F2288
M204 S8000
G1 X172.846 Y153.514 E.00378
G3 X174.999 Y153.131 I2.319 J6.791 E.07283
G1 X177.602 Y153.131 E.08634
G1 X177.602 Y157.958 E.16013
G1 X177.434 Y158.013 E.00585
G2 X172.384 Y158.014 I-2.525 J1.901 E.19409
G1 X172.22 Y157.957 E.00575
G1 X172.22 Y153.761 E.13919
G1 X172.683 Y153.576 E.01655
; COOLING_NODE: 2
; WIPE_START
G1 F8843.478
G1 X172.846 Y153.514 E-.06606
G1 X173.548 Y153.309 E-.27807
G1 X174.269 Y153.182 E-.278
G1 X174.63 Y153.157 E-.13787
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X176.983 Y160.418 Z5.6 F60000
G1 X177.434 Y161.809 Z5.6
G1 Z5.2
G1 E.8 F1800
G1 F2288
M204 S8000
G1 X177.602 Y161.864 E.00586
G1 X177.602 Y162.402 E.01784
G1 X176.874 Y162.402 E.02413
G2 X177.396 Y161.855 I-2.979 J-3.372 E.0251
; COOLING_NODE: 2
; WIPE_START
G1 F8843.478
G1 X177.602 Y161.864 E-.078
G1 X177.602 Y162.402 E-.20435
G1 X176.874 Y162.402 E-.27641
G1 X177.252 Y162.031 E-.20124
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.384 Y161.807 Z5.6 F60000
G1 Z5.2
G1 E.8 F1800
G1 F2288
M204 S8000
G1 X172.496 Y161.948 E.00597
G2 X172.947 Y162.402 I3.461 J-2.995 E.02125
G1 X172.22 Y162.402 E.02413
G1 X172.22 Y161.864 E.01782
G1 X172.327 Y161.827 E.00376
; COOLING_NODE: 2
; WIPE_START
G1 F8843.478
G1 X172.496 Y161.948 E-.07886
G1 X172.947 Y162.402 E-.24325
G1 X172.22 Y162.402 E-.27642
G1 X172.22 Y161.977 E-.16148
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.814 Y154.355 Z5.6 F60000
G1 X171.813 Y154.325 Z5.6
G1 Z5.2
G1 E.8 F1800
G1 F2288
M204 S8000
G1 X170.603 Y155.449 E.05477
G2 X168.709 Y159.906 I4.331 J4.472 E.16499
G1 X168.709 Y167.309 E.24557
G1 X167.723 Y167.309 E.0327
G1 X167.724 Y159.993 E.24266
G3 X174.992 Y152.724 I7.415 J.145 E.37672
G1 X182.309 Y152.723 E.24272
G1 X182.309 Y153.709 E.0327
G1 X178.009 Y153.709 E.14264
G1 X178.009 Y158.069 E.14465
G3 X178.009 Y161.752 I-3.157 J1.842 E.12804
G1 X178.009 Y162.809 E.03504
G1 X177.062 Y162.809 E.0314
G3 X172.762 Y162.809 I-2.15 J-2.976 E.15238
G1 X171.813 Y162.809 E.03149
G1 X171.813 Y161.758 E.03486
G3 X171.813 Y158.069 I3.177 J-1.844 E.12819
G1 X171.813 Y154.385 E.1222
; COOLING_NODE: 0
M204 S250
G1 X171.421 Y155.224 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2257
M204 S5000
G2 X169.983 Y156.833 I4.911 J5.837 E.06652
G2 X169.101 Y159.909 I4.977 J3.092 E.09959
G1 X169.101 Y167.701 E.23942
G1 X167.331 Y167.701 E.05439
G1 X167.332 Y159.985 E.23708
G3 X174.985 Y152.332 I7.807 J.154 E.36741
G1 X182.701 Y152.331 E.2371
G1 X182.701 Y154.101 E.05439
G1 X178.401 Y154.101 E.13213
G1 X178.401 Y157.974 E.11902
G3 X178.401 Y161.847 I-3.52 J1.937 E.12418
G1 X178.401 Y163.201 E.04159
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X177.173 Y163.201 E.03773
G3 X172.649 Y163.201 I-2.262 J-3.333 E.14759
G1 X171.421 Y163.201 E.03776
G1 X171.421 Y161.849 E.04153
G3 X171.421 Y157.974 I3.534 J-1.938 E.12421
G1 X171.421 Y155.284 E.08265
M204 S10000
G1 X170.743 Y154.715 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.543024
G1 F2288
M204 S8000
G2 X168.529 Y157.978 I4.382 J5.357 E.16297
; LINE_WIDTH: 0.591214
G2 X168.218 Y159.904 I6.684 J2.065 E.08745
; LINE_WIDTH: 0.621019
G1 X168.216 Y167.105 E.33923
; WIPE_START
G1 F6227.315
G1 X168.217 Y165.105 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.997 Y162.716 Z5.6 F60000
G1 Z5.2
G1 E.8 F1800
; LINE_WIDTH: 0.418471
G1 F2288
M204 S8000
G1 X173.53 Y162.791 E.01648
; LINE_WIDTH: 0.481048
G1 X173.574 Y162.79 E.00158
G2 X176.247 Y162.79 I1.336 J-2.876 E.0985
; LINE_WIDTH: 0.460496
G1 X176.3 Y162.787 E.00179
; LINE_WIDTH: 0.400266
G1 X176.935 Y162.648 E.01893
M204 S10000
G1 X176.537 Y162.407 F60000
; LINE_WIDTH: 0.104804
G1 F2288
M204 S8000
G1 X176.451 Y162.475 E.00055
; LINE_WIDTH: 0.13224
G1 X176.323 Y162.57 E.00116
; LINE_WIDTH: 0.176133
G1 X176.31 Y162.603 E.00038
; LINE_WIDTH: 0.224436
G1 X176.298 Y162.636 E.00052
; LINE_WIDTH: 0.272739
G1 X176.286 Y162.669 E.00066
; LINE_WIDTH: 0.321042
G1 X176.273 Y162.702 E.0008
; LINE_WIDTH: 0.369345
G1 X176.261 Y162.735 E.00094
; LINE_WIDTH: 0.417648
G1 X176.249 Y162.768 E.00108
; LINE_WIDTH: 0.460987
G1 X176.247 Y162.79 E.00075
M204 S10000
G1 X177.583 Y161.643 F60000
; LINE_WIDTH: 0.481342
G1 F2288
M204 S8000
G2 X177.722 Y158.435 I-2.71 J-1.724 E.12013
G1 X177.584 Y158.178 E.01043
; WIPE_START
G1 F8211.269
G1 X177.722 Y158.435 E-.11089
G1 X177.906 Y158.86 E-.1759
M73 P65 R5
G1 X178.026 Y159.3 E-.1733
G1 X178.08 Y159.717 E-.15964
G1 X178.081 Y160.082 E-.13885
G1 X178.08 Y160.086 E-.00142
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.995 Y155.279 Z5.6 F60000
G1 Z5.2
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.507377
G1 F2288
M204 S8000
G1 X175.995 Y154.737 E.02051
G2 X174.482 Y154.755 I-.642 J9.596 E.05734
; LINE_WIDTH: 0.470364
G2 X173.796 Y154.878 I2.814 J17.669 E.02428
G1 X173.796 Y155.325 E.01557
G3 X174.837 Y155.169 I1.103 J3.813 E.03676
; LINE_WIDTH: 0.507885
G1 X175.726 Y155.219 E.03376
G1 X175.937 Y155.266 E.00818
M204 S10000
G1 X176.425 Y155.854 F60000
; LINE_WIDTH: 0.41999
G1 F2288
M204 S8000
G1 X176.425 Y154.307 E.04753
G1 X175.033 Y154.307 E.04279
G1 X174.415 Y154.35 E.01902
G1 X173.612 Y154.507 E.02513
G1 X173.396 Y154.578 E.007
G1 X173.396 Y155.851 E.0391
G1 X174.16 Y155.645 E.02431
G1 X174.868 Y155.576 E.02187
G1 X175.685 Y155.647 E.02518
G1 X176.368 Y155.838 E.02179
M204 S10000
G1 X176.802 Y156.46 F60000
G1 F2288
M204 S8000
G1 X176.802 Y153.93 E.07773
G1 X175.02 Y153.93 E.05478
G1 X174.366 Y153.976 E.02013
G1 X173.517 Y154.141 E.02658
G1 X173.019 Y154.305 E.01611
G1 X173.019 Y156.446 E.06577
G1 X173.544 Y156.196 E.01786
G1 X174.254 Y156.01 E.02255
G1 X174.898 Y155.952 E.01987
G1 X175.648 Y156.022 E.02316
G1 X176.369 Y156.23 E.02303
G1 X176.749 Y156.432 E.01324
; WIPE_START
G1 F9547.299
G1 X176.369 Y156.23 E-.16372
G1 X175.648 Y156.022 E-.28488
G1 X174.898 Y155.952 E-.28643
G1 X174.832 Y155.958 E-.02498
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X177.805 Y153.216 Z5.6 F60000
G1 Z5.2
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.621295
G1 F2288
M204 S8000
G1 X182.105 Y153.216 E.20266
; WIPE_START
G1 F6224.335
G1 X180.105 Y153.216 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.483 Y153.609 Z5.6 F60000
G1 X172.014 Y153.633 Z5.6
G1 Z5.2
G1 E.8 F1800
; LINE_WIDTH: 0.265878
G1 F2288
M204 S8000
G1 X171.905 Y153.81 E.00378
; LINE_WIDTH: 0.282014
G1 X171.804 Y153.882 E.00242
; LINE_WIDTH: 0.314133
G1 X171.703 Y153.954 E.00274
; LINE_WIDTH: 0.344048
G1 X171.603 Y154.027 E.00303
; LINE_WIDTH: 0.371798
G1 X171.504 Y154.101 E.00331
; LINE_WIDTH: 0.408963
G1 X171.308 Y154.25 E.00734
; LINE_WIDTH: 0.451192
G1 X171.117 Y154.403 E.00814
; LINE_WIDTH: 0.497214
G2 X170.743 Y154.715 I8.77 J10.855 E.01802
; WIPE_START
G1 F7924.396
G1 X171.117 Y154.403 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.238 Y158.179 Z5.6 F60000
G1 Z5.2
G1 E.8 F1800
; LINE_WIDTH: 0.481178
G1 F2288
M204 S8000
G1 X172.099 Y158.435 E.0104
G2 X172.236 Y161.643 I2.863 J1.485 E.12002
; CHANGE_LAYER
; Z_HEIGHT: 5.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F8214.347
G1 X172.015 Y161.212 E-.18395
G1 X171.88 Y160.855 E-.14505
G1 X171.793 Y160.511 E-.13489
G1 X171.74 Y160.048 E-.17711
G1 X171.747 Y159.735 E-.11901
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 27/58
; update layer progress
M73 L27
M991 S0 P26 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 2
M204 S10000
G17
G3 Z5.6 I-1.088 J.545 P1  F60000
G1 X172.458 Y161.154 Z5.6
G1 Z5.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2279
M204 S8000
G1 X172.382 Y160.991 E.00599
G3 X174.766 Y157.162 I2.53 J-1.081 E.17536
G1 X174.898 Y157.158 E.00439
G3 X172.489 Y161.213 I.014 J2.751 E.38548
G1 X172.486 Y161.207 E.0002
; COOLING_NODE: 2
M204 S250
G1 X172.824 Y160.99 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2279
M204 S5000
G1 X172.74 Y160.834 E.00545
G3 X174.787 Y157.554 I2.17 J-.924 E.13927
G1 X174.896 Y157.551 E.00335
G3 X172.956 Y161.232 I.014 J2.359 E.29889
G1 X172.853 Y161.043 E.00661
; COOLING_NODE: 2
; WIPE_START
G1 F9547.055
M204 S8000
G1 X172.74 Y160.834 E-.09022
G1 X172.621 Y160.482 E-.1412
G1 X172.554 Y160.034 E-.17226
G1 X172.574 Y159.582 E-.17169
G1 X172.679 Y159.142 E-.17213
G1 X172.692 Y159.111 E-.0125
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.627 Y157.168 Z5.8 F60000
G1 Z5.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2279
M204 S8000
G1 X172.627 Y154.03 E.10409
G3 X175.007 Y153.539 I2.504 J6.122 E.08108
G1 X177.195 Y153.539 E.07256
G1 X177.195 Y157.154 E.11992
G2 X172.673 Y157.131 I-2.275 J2.794 E.16212
; COOLING_NODE: 2
; WIPE_START
G1 F8843.478
G1 X172.643 Y155.131 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.739 Y153.555 Z5.8 F60000
G1 Z5.4
G1 E.8 F1800
G1 F2279
M204 S8000
G1 X172.847 Y153.515 E.00379
G3 X175 Y153.132 I2.319 J6.791 E.07284
G1 X177.602 Y153.132 E.0863
G1 X177.602 Y157.959 E.16012
G1 X177.434 Y158.014 E.00585
G2 X172.386 Y158.013 I-2.525 J1.91 E.19385
G1 X172.22 Y157.957 E.0058
G1 X172.22 Y153.763 E.13913
G1 X172.684 Y153.577 E.01658
; COOLING_NODE: 2
; WIPE_START
G1 F8843.478
G1 X172.847 Y153.515 E-.06618
G1 X173.549 Y153.31 E-.2781
G1 X174.27 Y153.183 E-.27824
G1 X174.631 Y153.158 E-.13748
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X176.987 Y160.418 Z5.8 F60000
G1 X177.438 Y161.807 Z5.8
G1 Z5.4
G1 E.8 F1800
G1 F2279
M204 S8000
G1 X177.602 Y161.864 E.00575
G1 X177.602 Y162.402 E.01782
G1 X176.874 Y162.402 E.02413
G2 X177.401 Y161.854 I-2.91 J-3.324 E.02522
; COOLING_NODE: 2
; WIPE_START
G1 F8843.478
G1 X177.602 Y161.864 E-.07651
G1 X177.602 Y162.402 E-.20413
G1 X176.874 Y162.402 E-.27641
G1 X177.151 Y162.139 E-.14494
G1 X177.251 Y162.024 E-.05801
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.387 Y161.807 Z5.8 F60000
G1 Z5.4
G1 E.8 F1800
G1 F2279
M204 S8000
G1 X172.462 Y161.907 E.00414
G2 X172.956 Y162.402 I3.026 J-2.53 E.02323
G1 X172.22 Y162.402 E.02442
G1 X172.22 Y161.863 E.01788
G1 X172.33 Y161.826 E.00386
; COOLING_NODE: 2
; WIPE_START
G1 F8843.478
G1 X172.462 Y161.907 E-.0587
G1 X172.682 Y162.151 E-.12497
G1 X172.956 Y162.402 E-.14103
G1 X172.22 Y162.402 E-.27974
G1 X172.22 Y161.992 E-.15556
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.815 Y154.371 Z5.8 F60000
G1 X171.813 Y154.325 Z5.8
G1 Z5.4
G1 E.8 F1800
G1 F2279
M204 S8000
G1 X170.603 Y155.449 E.05478
G2 X168.709 Y159.906 I4.319 J4.466 E.165
G1 X168.709 Y167.309 E.24557
G1 X167.724 Y167.309 E.03266
G1 X167.725 Y159.995 E.24262
G3 X174.993 Y152.725 I7.415 J.145 E.37672
G1 X182.309 Y152.724 E.24268
G1 X182.309 Y153.709 E.03266
G1 X178.009 Y153.709 E.14264
G1 X178.009 Y158.064 E.14446
G3 X178.009 Y161.755 I-3.194 J1.846 E.12824
G1 X178.009 Y162.809 E.03495
G1 X177.062 Y162.809 E.03141
G3 X172.764 Y162.809 I-2.149 J-2.966 E.15234
G1 X171.813 Y162.809 E.03157
G1 X171.813 Y161.758 E.03486
G3 X171.813 Y158.069 I3.17 J-1.844 E.12821
G1 X171.813 Y154.385 E.1222
; COOLING_NODE: 0
M204 S250
G1 X171.421 Y155.224 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2260
M204 S5000
G2 X169.983 Y156.833 I4.915 J5.84 E.06651
G2 X169.101 Y159.909 I4.977 J3.092 E.09961
G1 X169.101 Y167.701 E.23942
G1 X167.332 Y167.701 E.05435
G1 X167.333 Y159.986 E.23705
G3 X174.986 Y152.333 I7.808 J.154 E.36741
G1 X182.701 Y152.332 E.23706
G1 X182.701 Y154.101 E.05435
G1 X178.401 Y154.101 E.13213
G1 X178.401 Y157.972 E.11896
G3 X178.401 Y161.848 I-3.55 J1.938 E.1242
G1 X178.401 Y163.201 E.04156
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X177.173 Y163.201 E.03773
G3 X172.65 Y163.201 I-2.261 J-3.325 E.14759
G1 X171.421 Y163.201 E.03778
G1 X171.421 Y161.849 E.04153
G3 X171.421 Y157.974 I3.524 J-1.938 E.12423
G1 X171.421 Y155.284 E.08265
M204 S10000
G1 X170.744 Y154.715 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.495427
G1 F2279
M204 S8000
G3 X171.118 Y154.403 I9.106 J10.497 E.01796
; LINE_WIDTH: 0.449361
G1 X171.309 Y154.251 E.0081
; LINE_WIDTH: 0.40713
G1 X171.504 Y154.101 E.00729
; LINE_WIDTH: 0.369956
G1 X171.604 Y154.028 E.0033
; LINE_WIDTH: 0.342219
G1 X171.703 Y153.954 E.00302
; LINE_WIDTH: 0.31227
G1 X171.804 Y153.882 E.00273
; LINE_WIDTH: 0.280111
G1 X171.906 Y153.81 E.0024
; LINE_WIDTH: 0.264014
G1 X172.016 Y153.741 E.00235
M204 S10000
G1 X170.744 Y154.715 F60000
; LINE_WIDTH: 0.541311
G1 F2279
M204 S8000
G2 X168.53 Y157.975 I4.382 J5.358 E.16229
; LINE_WIDTH: 0.589756
G1 X168.436 Y158.304 E.01522
G2 X168.219 Y159.904 I6.584 J1.709 E.07213
; LINE_WIDTH: 0.619788
G1 X168.216 Y167.105 E.3385
; WIPE_START
M73 P66 R5
G1 F6240.6
G1 X168.217 Y165.105 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.967 Y162.696 Z5.8 F60000
G1 Z5.4
G1 E.8 F1800
; LINE_WIDTH: 0.419584
G1 F2279
M204 S8000
G1 X173.527 Y162.795 E.01747
; LINE_WIDTH: 0.48074
G1 X173.589 Y162.796 E.00219
G2 X176.247 Y162.79 I1.323 J-2.885 E.09785
; LINE_WIDTH: 0.4586
G1 X176.249 Y162.765 E.00084
; LINE_WIDTH: 0.413311
G1 X176.261 Y162.733 E.00105
; LINE_WIDTH: 0.365798
G1 X176.273 Y162.7 E.00092
; LINE_WIDTH: 0.318285
G1 X176.286 Y162.668 E.00078
; LINE_WIDTH: 0.270772
G1 X176.298 Y162.635 E.00065
; LINE_WIDTH: 0.223259
G1 X176.31 Y162.602 E.00051
; LINE_WIDTH: 0.175746
G1 X176.322 Y162.57 E.00038
; LINE_WIDTH: 0.132315
G1 X176.45 Y162.475 E.00116
; LINE_WIDTH: 0.104877
G1 X176.537 Y162.407 E.00056
M204 S10000
G1 X176.299 Y162.787 F60000
; LINE_WIDTH: 0.460598
G1 F2279
M204 S8000
G1 X176.247 Y162.79 E.00179
M204 S10000
G1 X176.299 Y162.787 F60000
; LINE_WIDTH: 0.400412
G1 F2279
M204 S8000
G1 X176.934 Y162.648 E.01892
; WIPE_START
G1 F10070.167
G1 X176.299 Y162.787 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X177.585 Y161.643 Z5.8 F60000
G1 Z5.4
G1 E.8 F1800
; LINE_WIDTH: 0.481079
G1 F2279
M204 S8000
G2 X177.789 Y158.573 I-2.724 J-1.723 E.1145
G1 X177.586 Y158.179 E.01586
M204 S10000
G1 X177.398 Y157.59 F60000
; LINE_WIDTH: 0.106102
G1 F2279
M204 S8000
G1 X177.28 Y157.49 E.00079
; WIPE_START
G1 F15000
G1 X177.398 Y157.59 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X173.796 Y155.326 Z5.8 F60000
G1 Z5.4
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.47022
G1 F2279
M204 S8000
G3 X174.824 Y155.17 I1.102 J3.805 E.03631
; LINE_WIDTH: 0.507644
G1 X175.73 Y155.22 E.03438
G1 X175.995 Y155.275 E.01025
G1 X175.995 Y154.738 E.02033
G2 X174.484 Y154.756 I-.643 J9.662 E.05731
; LINE_WIDTH: 0.469145
G2 X173.796 Y154.879 I2.859 J17.909 E.02428
G1 X173.796 Y155.266 E.01342
M204 S10000
G1 X176.425 Y155.853 F60000
; LINE_WIDTH: 0.41999
G1 F2279
M204 S8000
G1 X176.425 Y154.308 E.04748
G1 X175.034 Y154.308 E.04275
G1 X174.417 Y154.352 E.01901
G1 X173.614 Y154.508 E.02515
G1 X173.396 Y154.58 E.00704
G1 X173.396 Y155.851 E.03905
G1 X174.159 Y155.645 E.02428
G1 X174.856 Y155.576 E.02153
G1 X175.689 Y155.648 E.02567
G1 X176.369 Y155.832 E.02167
M204 S10000
G1 X176.768 Y156.414 F60000
G1 F2279
M204 S8000
G1 X176.802 Y156.392 E.00126
G1 X176.802 Y153.931 E.0756
G1 X175.021 Y153.931 E.05474
G1 X174.368 Y153.977 E.02012
G1 X173.518 Y154.142 E.02659
G1 X173.019 Y154.307 E.01615
G1 X173.019 Y156.446 E.06572
G1 X173.542 Y156.197 E.01782
G1 X174.253 Y156.01 E.02258
G1 X174.887 Y155.952 E.01954
M73 P66 R4
G1 X175.652 Y156.024 E.02362
G3 X176.713 Y156.39 I-.662 J3.633 E.03463
; WIPE_START
G1 F9547.299
G1 X176.189 Y156.164 E-.21713
G1 X175.652 Y156.024 E-.21072
G1 X174.887 Y155.952 E-.29213
G1 X174.782 Y155.961 E-.04002
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X177.805 Y153.217 Z5.8 F60000
G1 Z5.4
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.620055
G1 F2279
M204 S8000
G1 X182.105 Y153.216 E.20222
; WIPE_START
G1 F6237.71
G1 X180.105 Y153.217 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X173.65 Y157.289 Z5.8 F60000
G1 X172.24 Y158.179 Z5.8
G1 Z5.4
G1 E.8 F1800
; LINE_WIDTH: 0.481227
G1 F2279
M204 S8000
G1 X172.035 Y158.565 E.01563
G1 X171.907 Y158.882 E.01219
G2 X172.236 Y161.643 I3.076 J1.034 E.10262
; CHANGE_LAYER
; Z_HEIGHT: 5.6
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F8213.433
G1 X172.016 Y161.212 E-.18391
G1 X171.926 Y160.99 E-.09078
G1 X171.83 Y160.675 E-.12532
G1 X171.756 Y160.261 E-.15979
G1 X171.736 Y159.909 E-.13387
G1 X171.746 Y159.735 E-.06633
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 28/58
; update layer progress
M73 L28
M991 S0 P27 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 2
M204 S10000
G17
G3 Z5.8 I-1.085 J.551 P1  F60000
G1 X172.502 Y161.224 Z5.8
G1 Z5.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2325
M204 S8000
G1 X172.436 Y161.117 E.00417
G3 X174.63 Y157.173 I2.473 J-1.207 E.17553
G1 X174.87 Y157.159 E.00799
G3 X172.712 Y161.567 I.039 J2.752 E.3725
G1 X172.534 Y161.275 E.01135
; COOLING_NODE: 2
M204 S250
G1 X172.835 Y161.02 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2291
M204 S5000
G1 X172.789 Y160.945 E.00269
G3 X174.667 Y157.563 I2.121 J-1.035 E.13932
G1 X174.879 Y157.551 E.00655
G3 X173.026 Y161.331 I.03 J2.359 E.29577
G1 X172.867 Y161.071 E.00936
; COOLING_NODE: 2
; WIPE_START
G1 F9547.055
M204 S8000
G1 X172.789 Y160.945 E-.05612
G1 X172.653 Y160.599 E-.14154
G1 X172.602 Y160.401 E-.07755
G1 X172.556 Y160.075 E-.1249
G1 X172.568 Y159.622 E-.1722
G1 X172.643 Y159.258 E-.14134
G1 X172.687 Y159.145 E-.04635
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.627 Y157.16 Z6 F60000
G1 Z5.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2325
M204 S8000
G1 X172.627 Y154.032 E.10376
G3 X175.008 Y153.541 I2.505 J6.121 E.08112
G1 X177.195 Y153.54 E.07252
G1 X177.195 Y157.154 E.11987
G2 X172.674 Y157.123 I-2.28 J2.809 E.16199
; COOLING_NODE: 2
; WIPE_START
G1 F8843.478
G1 X172.643 Y155.123 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.22 Y158.21 Z6 F60000
G1 Z5.6
G1 E.8 F1800
G1 F2325
M204 S8000
G1 X172.22 Y153.765 E.14745
G3 X175.001 Y153.134 I2.947 J6.544 E.09524
G1 X177.602 Y153.133 E.08626
G1 X177.602 Y158.21 E.1684
G2 X176.246 Y157.047 I-3.081 J2.221 E.05981
G2 X172.526 Y157.838 I-1.327 J2.899 E.13516
G1 X172.258 Y158.163 E.01397
; COOLING_NODE: 2
; WIPE_START
G1 F8843.478
G1 X172.241 Y156.163 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X177.594 Y161.604 Z6 F60000
G1 X177.602 Y161.612 Z6
G1 Z5.6
G1 E.8 F1800
G1 F2325
M204 S8000
G1 X177.602 Y162.402 E.0262
G1 X176.882 Y162.402 E.02387
G2 X177.565 Y161.659 I-4.087 J-4.446 E.0335
; COOLING_NODE: 2
; WIPE_START
G1 F8843.478
G1 X177.602 Y162.402 E-.28238
G1 X176.882 Y162.402 E-.27341
G1 X177.26 Y162.019 E-.20421
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.384 Y161.807 Z6 F60000
G1 Z5.6
G1 E.8 F1800
G1 F2325
M204 S8000
G1 X172.49 Y161.942 E.00569
G2 X172.954 Y162.402 I3.216 J-2.779 E.02169
G1 X172.22 Y162.402 E.02436
G1 X172.22 Y161.864 E.01782
G1 X172.327 Y161.827 E.00376
; COOLING_NODE: 2
; WIPE_START
G1 F8843.478
G1 X172.49 Y161.942 E-.07584
G1 X172.716 Y162.183 E-.12564
G1 X172.954 Y162.402 E-.12279
G1 X172.22 Y162.402 E-.27903
G1 X172.22 Y161.989 E-.1567
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.815 Y154.368 Z6 F60000
G1 X171.813 Y154.325 Z6
G1 Z5.6
G1 E.8 F1800
G1 F2325
M204 S8000
G1 X170.603 Y155.449 E.05478
G2 X168.709 Y159.906 I4.331 J4.471 E.16498
G1 X168.709 Y167.309 E.24557
G1 X167.725 Y167.309 E.03262
G1 X167.726 Y159.996 E.24258
G3 X174.994 Y152.726 I7.408 J.138 E.37682
G1 X182.309 Y152.725 E.24264
G1 X182.309 Y153.709 E.03262
G1 X178.009 Y153.709 E.14264
G1 X178.009 Y158.066 E.14456
G3 X178.009 Y161.758 I-3.173 J1.846 E.1283
G1 X178.009 Y162.809 E.03486
G1 X177.062 Y162.809 E.0314
G3 X172.765 Y162.809 I-2.149 J-2.965 E.15233
G1 X171.813 Y162.809 E.03158
G1 X171.813 Y161.752 E.03504
G3 X171.813 Y158.066 I3.157 J-1.843 E.12815
G1 X171.813 Y154.385 E.12211
; COOLING_NODE: 0
M204 S250
G1 X171.421 Y155.224 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2263
M204 S5000
G2 X169.931 Y156.917 I4.844 J5.764 E.06954
G2 X169.101 Y159.909 I5.031 J3.008 E.09656
G1 X169.101 Y167.701 E.23941
G1 X167.333 Y167.701 E.05431
G1 X167.334 Y159.988 E.237
G3 X174.987 Y152.334 I7.801 J.147 E.3675
G1 X182.701 Y152.333 E.23702
G1 X182.701 Y154.101 E.05431
G1 X178.401 Y154.101 E.13213
G1 X178.401 Y157.973 E.11899
G3 X178.401 Y161.849 I-3.525 J1.938 E.12427
G1 X178.401 Y163.201 E.04153
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X177.173 Y163.201 E.03773
G3 X172.65 Y163.201 I-2.261 J-3.324 E.14759
G1 X171.421 Y163.201 E.03779
G1 X171.421 Y161.847 E.04159
M73 P67 R4
G3 X171.421 Y157.973 I3.514 J-1.937 E.12423
G1 X171.421 Y155.284 E.08262
M204 S10000
G1 X170.929 Y154.559 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.53047
G1 F2325
M204 S8000
G2 X169.085 Y156.693 I4.456 J5.714 E.11278
; LINE_WIDTH: 0.561555
G2 X168.314 Y158.877 I5.968 J3.335 E.09836
; LINE_WIDTH: 0.616218
G2 X168.218 Y160.007 I7.044 J1.172 E.05302
G1 X168.217 Y167.105 E.33162
; WIPE_START
G1 F6279.46
G1 X168.217 Y165.105 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.909 Y162.659 Z6 F60000
G1 Z5.6
G1 E.8 F1800
; LINE_WIDTH: 0.404033
G1 F2325
M204 S8000
G1 X173.532 Y162.791 E.01874
; LINE_WIDTH: 0.461922
G1 X173.586 Y162.795 E.00186
; LINE_WIDTH: 0.481277
G2 X176.146 Y162.835 I1.325 J-2.883 E.09412
G1 X176.258 Y162.784 E.0044
M204 S10000
G1 X176.262 Y162.758 F60000
; LINE_WIDTH: 0.446034
G1 F2325
M204 S8000
G1 X176.258 Y162.784 E.00086
G1 X176.352 Y162.783 E.00307
; LINE_WIDTH: 0.394625
G1 X176.894 Y162.673 E.01586
M204 S10000
G1 X176.579 Y162.381 F60000
; LINE_WIDTH: 0.109813
G1 F2325
M204 S8000
G1 X176.478 Y162.459 E.0007
; LINE_WIDTH: 0.140431
G1 X176.343 Y162.563 E.00136
; LINE_WIDTH: 0.182026
G1 X176.325 Y162.596 E.00042
; LINE_WIDTH: 0.223885
G1 X176.308 Y162.629 E.00055
; LINE_WIDTH: 0.265743
G1 X176.29 Y162.661 E.00068
; LINE_WIDTH: 0.307602
G1 X176.272 Y162.694 E.0008
; LINE_WIDTH: 0.338463
G1 X176.27 Y162.706 E.0003
; LINE_WIDTH: 0.370471
G1 X176.266 Y162.732 E.0007
; LINE_WIDTH: 0.41462
G1 X176.262 Y162.758 E.0008
; WIPE_START
G1 F9685.24
G1 X176.266 Y162.732 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X177.853 Y161.614 Z6 F60000
G1 Z5.6
G1 E.8 F1800
; LINE_WIDTH: 0.328553
G1 F2325
M204 S8000
G1 X177.952 Y161.045 E.01344
; LINE_WIDTH: 0.361089
G1 X177.951 Y160.979 E.00171
; LINE_WIDTH: 0.409067
G1 X177.949 Y160.913 E.00197
; LINE_WIDTH: 0.478883
G3 X177.962 Y160.787 I.195 J-.043 E.00455
G2 X178.04 Y160.446 I-4.156 J-1.124 E.01244
; LINE_WIDTH: 0.481315
G2 X177.937 Y158.952 I-3.124 J-.535 E.05402
; LINE_WIDTH: 0.467694
G1 X177.943 Y158.929 E.00082
; LINE_WIDTH: 0.442679
G1 X177.949 Y158.906 E.00077
; LINE_WIDTH: 0.406931
G1 X177.951 Y158.842 E.00192
; LINE_WIDTH: 0.360426
G1 X177.952 Y158.777 E.00167
; LINE_WIDTH: 0.328086
G1 X177.853 Y158.211 E.01336
M204 S10000
G1 X177.398 Y157.59 F60000
; LINE_WIDTH: 0.105797
G1 F2325
M204 S8000
G1 X177.277 Y157.487 E.00081
; WIPE_START
G1 F15000
G1 X177.398 Y157.59 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.996 Y155.282 Z6 F60000
G1 Z5.6
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.506886
G1 F2325
M204 S8000
G1 X175.996 Y154.739 E.0205
G2 X174.485 Y154.756 I-.644 J9.917 E.05717
; LINE_WIDTH: 0.4729
G2 X173.795 Y154.88 I2.892 J18.091 E.02457
G1 X173.795 Y155.317 E.01531
G1 X174.519 Y155.192 E.02576
G1 X175.044 Y155.172 E.01838
; LINE_WIDTH: 0.511351
G1 X175.651 Y155.208 E.02323
G1 X175.937 Y155.269 E.01116
M204 S10000
G1 X176.425 Y155.863 F60000
; LINE_WIDTH: 0.41999
G1 F2325
M204 S8000
G1 X176.425 Y154.31 E.04773
G1 X175.035 Y154.31 E.04272
G1 X174.418 Y154.353 E.019
G1 X173.615 Y154.509 E.02515
G1 X173.396 Y154.581 E.00708
G1 X173.396 Y155.866 E.03949
G3 X174.799 Y155.577 I1.529 J3.865 E.04423
G1 X175.47 Y155.612 E.02066
G1 X176.145 Y155.755 E.02119
G1 X176.369 Y155.841 E.00739
M204 S10000
G1 X176.768 Y156.415 F60000
G1 F2325
M204 S8000
G1 X176.799 Y156.428 E.00104
G2 X176.802 Y153.932 I-445.316 J-1.801 E.07667
G1 X175.022 Y153.933 E.05471
G1 X174.369 Y153.978 E.02011
G1 X173.519 Y154.143 E.0266
G1 X173.019 Y154.309 E.01619
G1 X173.019 Y156.434 E.06531
G1 X173.752 Y156.126 E.02443
G3 X175.447 Y155.988 I1.196 J4.229 E.05259
G1 X176.063 Y156.123 E.01938
G1 X176.713 Y156.392 E.0216
; WIPE_START
G1 F9547.299
G1 X176.063 Y156.123 E-.2671
G1 X175.447 Y155.988 E-.23964
G1 X174.832 Y155.952 E-.23418
G1 X174.782 Y155.957 E-.01908
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X177.805 Y153.217 Z6 F60000
G1 Z5.6
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.618825
G1 F2325
M204 S8000
G1 X182.105 Y153.217 E.20179
; WIPE_START
G1 F6251.033
G1 X180.105 Y153.217 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.489 Y153.714 Z6 F60000
G1 X172.016 Y153.745 Z6
G1 Z5.6
G1 E.8 F1800
; LINE_WIDTH: 0.262181
G1 F2325
M204 S8000
G1 X171.907 Y153.811 E.00229
; LINE_WIDTH: 0.278283
G1 X171.805 Y153.883 E.00238
; LINE_WIDTH: 0.310455
G1 X171.704 Y153.955 E.00271
; LINE_WIDTH: 0.340431
G1 X171.605 Y154.028 E.003
; LINE_WIDTH: 0.368165
G1 X171.505 Y154.102 E.00328
; LINE_WIDTH: 0.405415
G1 X171.309 Y154.252 E.00728
; LINE_WIDTH: 0.447647
G1 X171.118 Y154.403 E.00804
; LINE_WIDTH: 0.481196
G1 X170.929 Y154.559 E.00875
; WIPE_START
G1 F8214.009
G1 X171.118 Y154.403 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.971 Y158.204 Z6 F60000
G1 Z5.6
G1 E.8 F1800
; LINE_WIDTH: 0.329135
G1 F2325
M204 S8000
G1 X171.869 Y158.777 E.01357
; LINE_WIDTH: 0.355526
G1 X171.864 Y158.841 E.00164
; LINE_WIDTH: 0.391336
G1 X171.871 Y158.878 E.00108
; LINE_WIDTH: 0.427287
G1 X171.878 Y158.916 E.00119
; LINE_WIDTH: 0.463238
G1 X171.886 Y158.953 E.0013
; LINE_WIDTH: 0.480601
G1 X171.86 Y159.034 E.00303
G2 X172.131 Y161.447 I3.067 J.877 E.08885
G1 X172.457 Y161.566 E.01235
; WIPE_START
G1 F8225.178
G1 X172.131 Y161.447 E-.13157
G1 X171.991 Y161.156 E-.12274
G1 X171.879 Y160.853 E-.12271
G1 X171.804 Y160.561 E-.11477
G1 X171.76 Y160.299 E-.10085
G1 X171.736 Y159.948 E-.13359
G1 X171.739 Y159.859 E-.03377
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.886 Y158.953 Z6 F60000
G1 Z5.6
G1 E.8 F1800
; LINE_WIDTH: 0.457946
G1 F2325
M204 S8000
G1 X171.917 Y158.933 E.00125
; LINE_WIDTH: 0.41144
G1 X171.948 Y158.913 E.00111
; LINE_WIDTH: 0.364935
G1 X171.979 Y158.893 E.00097
; LINE_WIDTH: 0.31843
G1 X172.011 Y158.873 E.00083
; LINE_WIDTH: 0.271924
G1 X172.042 Y158.853 E.00069
; LINE_WIDTH: 0.225419
G1 X172.073 Y158.833 E.00055
; LINE_WIDTH: 0.201103
G1 X172.076 Y158.828 E.00007
; LINE_WIDTH: 0.175906
G1 X172.16 Y158.688 E.00177
; LINE_WIDTH: 0.131279
G1 X172.25 Y158.546 E.00121
; LINE_WIDTH: 0.103764
G1 X172.311 Y158.458 E.00053
; CHANGE_LAYER
; Z_HEIGHT: 5.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F15000
G1 X172.25 Y158.546 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 29/58
; update layer progress
M73 L29
M991 S0 P28 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 2
M204 S10000
G17
G3 Z6 I-1.212 J.113 P1  F60000
G1 X172.502 Y161.238 Z6
G1 Z5.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2288
M204 S8000
G1 X172.48 Y161.196 E.00157
G3 X174.767 Y157.162 I2.433 J-1.286 E.18294
G1 X174.916 Y157.158 E.00493
G3 X172.634 Y161.453 I-.003 J2.752 E.37576
G1 X172.534 Y161.289 E.00637
; COOLING_NODE: 2
M204 S250
G1 X172.843 Y161.043 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2284
M204 S5000
G1 X172.827 Y161.016 E.00099
G3 X174.788 Y157.554 I2.085 J-1.106 E.14545
G1 X174.912 Y157.551 E.00383
G3 X173.076 Y161.394 I-.001 J2.36 E.29236
G1 X172.877 Y161.093 E.01108
; COOLING_NODE: 2
; WIPE_START
G1 F9547.055
M204 S8000
G1 X172.827 Y161.016 E-.03503
G1 X172.738 Y160.833 E-.07727
G1 X172.631 Y160.521 E-.1253
G1 X172.58 Y160.279 E-.09387
G1 X172.554 Y160.034 E-.09378
G1 X172.574 Y159.582 E-.17197
G1 X172.654 Y159.22 E-.14098
G1 X172.676 Y159.167 E-.0218
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.627 Y157.167 Z6.2 F60000
G1 Z5.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2288
M204 S8000
G1 X172.627 Y154.034 E.10393
G3 X175.009 Y153.542 I2.506 J6.122 E.08116
G1 X177.195 Y153.541 E.07248
G1 X177.195 Y157.154 E.11984
G2 X172.673 Y157.129 I-2.276 J2.797 E.16209
; COOLING_NODE: 2
; WIPE_START
G1 F8843.478
G1 X172.643 Y155.129 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.741 Y153.558 Z6.2 F60000
G1 Z5.8
G1 E.8 F1800
G1 F2288
M204 S8000
G1 X172.849 Y153.518 E.00383
G3 X175.002 Y153.135 I2.319 J6.791 E.07282
G1 X177.602 Y153.134 E.08622
G1 X177.602 Y157.957 E.15998
G1 X177.438 Y158.014 E.00575
G2 X172.384 Y158.014 I-2.527 J1.915 E.19402
G1 X172.22 Y157.957 E.00575
G1 X172.22 Y153.766 E.13901
G1 X172.685 Y153.58 E.01663
; COOLING_NODE: 2
; WIPE_START
G1 F8843.478
G1 X172.849 Y153.518 E-.06671
G1 X173.552 Y153.313 E-.278
G1 X174.273 Y153.186 E-.27832
G1 X174.632 Y153.161 E-.13697
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X176.986 Y160.421 Z6.2 F60000
G1 X177.436 Y161.808 Z6.2
G1 Z5.8
G1 E.8 F1800
G1 F2288
M204 S8000
G1 X177.602 Y161.864 E.00581
G1 X177.602 Y162.402 E.01782
G1 X176.866 Y162.402 E.02442
G2 X177.398 Y161.855 I-2.75 J-3.214 E.02536
; COOLING_NODE: 2
; WIPE_START
G1 F8843.478
G1 X177.602 Y161.864 E-.0773
G1 X177.602 Y162.402 E-.20415
G1 X176.866 Y162.402 E-.27971
G1 X177.139 Y162.151 E-.14099
G1 X177.239 Y162.036 E-.05784
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.388 Y161.809 Z6.2 F60000
G1 Z5.8
G1 E.8 F1800
G1 F2288
M204 S8000
G1 X172.45 Y161.892 E.00345
G2 X172.947 Y162.402 I3.493 J-2.915 E.02365
G1 X172.22 Y162.402 E.02413
G1 X172.22 Y161.864 E.01784
G1 X172.331 Y161.827 E.00387
; COOLING_NODE: 2
; WIPE_START
G1 F8843.478
G1 X172.45 Y161.892 E-.05147
G1 X172.676 Y162.145 E-.12893
G1 X172.947 Y162.402 E-.1419
G1 X172.22 Y162.402 E-.27639
G1 X172.22 Y161.977 E-.16131
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.814 Y154.355 Z6.2 F60000
G1 X171.813 Y154.325 Z6.2
G1 Z5.8
G1 E.8 F1800
G1 F2288
M204 S8000
G1 X170.603 Y155.449 E.05478
G2 X168.709 Y159.906 I4.319 J4.466 E.165
G1 X168.709 Y167.309 E.24557
G1 X167.727 Y167.309 E.03258
G1 X167.728 Y159.998 E.24252
G3 X174.995 Y152.728 I7.408 J.138 E.37683
G1 X182.309 Y152.727 E.2426
G1 X182.309 Y153.709 E.03258
G1 X178.009 Y153.709 E.14264
G1 X178.009 Y158.066 E.14456
G3 X178.009 Y161.757 I-3.166 J1.846 E.12831
G1 X178.009 Y162.809 E.03487
G1 X177.06 Y162.809 E.03148
G3 X172.762 Y162.809 I-2.149 J-2.966 E.15235
G1 X171.813 Y162.809 E.03149
G1 X171.813 Y161.755 E.03494
G3 X171.813 Y158.069 I3.152 J-1.843 E.12818
G1 X171.813 Y154.385 E.12221
; COOLING_NODE: 0
M204 S250
G1 X171.421 Y155.224 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2264
M204 S5000
G2 X169.983 Y156.833 I4.914 J5.84 E.06652
G2 X169.101 Y159.909 I4.976 J3.092 E.09959
G1 X169.101 Y167.701 E.23941
G1 X167.334 Y167.701 E.05427
G1 X167.336 Y159.989 E.23696
G3 X174.988 Y152.336 I7.801 J.147 E.3675
G1 X182.701 Y152.334 E.23699
G1 X182.701 Y154.101 E.05427
G1 X178.401 Y154.101 E.13213
M73 P68 R4
G1 X178.401 Y157.973 E.11899
G3 X178.401 Y161.849 I-3.517 J1.938 E.12428
G1 X178.401 Y163.201 E.04153
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X177.172 Y163.201 E.03775
G3 X172.649 Y163.201 I-2.261 J-3.323 E.1476
G1 X171.421 Y163.201 E.03776
G1 X171.421 Y161.848 E.04155
G3 X171.421 Y157.974 I3.507 J-1.937 E.12425
G1 X171.421 Y155.284 E.08265
M204 S10000
G1 X170.93 Y154.559 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.528714
G1 F2288
M204 S8000
G2 X169.088 Y156.69 I4.461 J5.719 E.11222
; LINE_WIDTH: 0.562354
G2 X168.28 Y159.108 I5.992 J3.346 E.10852
; LINE_WIDTH: 0.615809
G2 X168.218 Y160.008 I7.278 J.953 E.04217
G1 X168.218 Y167.105 E.33131
; WIPE_START
G1 F6283.941
G1 X168.218 Y165.105 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.999 Y162.717 Z6.2 F60000
G1 Z5.8
G1 E.8 F1800
; LINE_WIDTH: 0.41919
G1 F2288
M204 S8000
G1 X173.532 Y162.791 E.0165
; LINE_WIDTH: 0.48099
G1 X173.574 Y162.791 E.00152
G2 X176.152 Y162.833 I1.336 J-2.895 E.09473
G1 X176.233 Y162.796 E.00317
M204 S10000
G1 X176.244 Y162.763 F60000
; LINE_WIDTH: 0.408766
G1 F2288
M204 S8000
G1 X176.255 Y162.731 E.00102
; LINE_WIDTH: 0.359837
G1 X176.265 Y162.699 E.00088
; LINE_WIDTH: 0.310909
G1 X176.276 Y162.667 E.00074
; LINE_WIDTH: 0.26198
G1 X176.287 Y162.634 E.00061
; LINE_WIDTH: 0.213052
G1 X176.298 Y162.602 E.00047
; LINE_WIDTH: 0.164124
G1 X176.309 Y162.57 E.00034
; LINE_WIDTH: 0.118466
G1 X176.485 Y162.44 E.00134
M204 S10000
G1 X176.342 Y162.787 F60000
; LINE_WIDTH: 0.447239
G1 F2288
M204 S8000
G1 X176.233 Y162.796 E.00361
G1 X176.244 Y162.763 E.00112
M204 S10000
G1 X176.342 Y162.787 F60000
; LINE_WIDTH: 0.404162
G1 F2288
M204 S8000
G1 X176.914 Y162.66 E.01726
; WIPE_START
G1 F9965.64
G1 X176.342 Y162.787 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X177.583 Y161.643 Z6.2 F60000
G1 Z5.8
G1 E.8 F1800
; LINE_WIDTH: 0.48103
G1 F2288
M204 S8000
G2 X177.722 Y158.435 I-2.723 J-1.724 E.11999
G1 X177.585 Y158.179 E.01039
M204 S10000
G1 X177.398 Y157.591 F60000
; LINE_WIDTH: 0.106752
G1 F2288
M204 S8000
G1 X177.281 Y157.49 E.0008
; WIPE_START
G1 F15000
G1 X177.398 Y157.591 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.996 Y155.28 Z6.2 F60000
G1 Z5.8
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.505522
G1 F2288
M204 S8000
G1 X175.996 Y154.74 E.02037
G2 X174.486 Y154.758 I-.641 J9.547 E.05698
; LINE_WIDTH: 0.472515
G2 X173.795 Y154.882 I2.694 J17.083 E.02461
G1 X173.795 Y155.318 E.01527
G1 X174.519 Y155.195 E.02571
G1 X175.037 Y155.169 E.01816
; LINE_WIDTH: 0.510971
G1 X175.727 Y155.22 E.02641
G1 X175.938 Y155.267 E.00822
M204 S10000
G1 X176.425 Y155.854 F60000
; LINE_WIDTH: 0.41999
G1 F2288
M204 S8000
G1 X176.425 Y154.311 E.04742
G1 X175.036 Y154.311 E.04268
G1 X174.42 Y154.354 E.01899
G1 X173.616 Y154.51 E.02517
G1 X173.396 Y154.583 E.00711
G1 X173.396 Y155.864 E.03936
G3 X174.875 Y155.576 I1.535 J3.945 E.04656
G1 X175.686 Y155.647 E.02499
G1 X176.368 Y155.838 E.02176
M204 S10000
G1 X176.802 Y156.453 F60000
G1 F2288
M204 S8000
G1 X176.802 Y153.934 E.0774
G1 X175.023 Y153.934 E.05467
G1 X174.37 Y153.979 E.0201
G1 X173.52 Y154.145 E.02662
G1 X173.019 Y154.311 E.01622
G1 X173.019 Y156.436 E.06532
G1 X173.754 Y156.125 E.02451
G1 X174.28 Y156.002 E.01662
G1 X174.905 Y155.952 E.01924
G1 X175.649 Y156.022 E.02297
G1 X176.367 Y156.23 E.02297
G1 X176.749 Y156.425 E.01319
; WIPE_START
G1 F9547.299
G1 X176.367 Y156.23 E-.16311
G1 X175.649 Y156.022 E-.28409
G1 X174.905 Y155.952 E-.28407
G1 X174.829 Y155.958 E-.02873
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X177.805 Y153.218 Z6.2 F60000
G1 Z5.8
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.617595
G1 F2288
M204 S8000
G1 X182.105 Y153.218 E.20136
; WIPE_START
G1 F6264.413
G1 X180.105 Y153.218 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.484 Y153.633 Z6.2 F60000
G1 X172.016 Y153.659 Z6.2
G1 Z5.8
G1 E.8 F1800
; LINE_WIDTH: 0.26034
G1 F2288
M204 S8000
G1 X171.907 Y153.811 E.00331
; LINE_WIDTH: 0.276504
G1 X171.806 Y153.883 E.00237
; LINE_WIDTH: 0.308705
G1 X171.705 Y153.955 E.00269
; LINE_WIDTH: 0.338699
G1 X171.605 Y154.029 E.00298
; LINE_WIDTH: 0.366439
G1 X171.506 Y154.102 E.00326
; LINE_WIDTH: 0.403619
G1 X171.31 Y154.252 E.00723
; LINE_WIDTH: 0.445863
G1 X171.119 Y154.404 E.00802
; LINE_WIDTH: 0.479463
G1 X170.93 Y154.559 E.00871
; WIPE_START
G1 F8246.615
G1 X171.119 Y154.404 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.238 Y158.179 Z6.2 F60000
G1 Z5.8
G1 E.8 F1800
; LINE_WIDTH: 0.481189
G1 F2288
M204 S8000
G1 X172.105 Y158.425 E.00998
G2 X172.237 Y161.644 I2.847 J1.495 E.12051
; CHANGE_LAYER
; Z_HEIGHT: 6
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F8214.135
G1 X172.039 Y161.262 E-.16349
G1 X171.896 Y160.906 E-.14594
G1 X171.798 Y160.536 E-.14538
G1 X171.741 Y160.071 E-.17798
G1 X171.747 Y159.736 E-.12721
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 30/58
; update layer progress
M73 L30
M991 S0 P29 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 2
M204 S10000
G17
G3 Z6.2 I-1.086 J.549 P1  F60000
G1 X172.517 Y161.26 Z6.2
G1 Z6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2265
M204 S8000
G1 X172.481 Y161.196 E.00244
G3 X174.766 Y157.162 I2.432 J-1.287 E.1829
G1 X174.905 Y157.158 E.00459
G3 X172.715 Y161.564 I.008 J2.751 E.37139
G1 X172.55 Y161.31 E.01005
; COOLING_NODE: 2
M204 S250
G1 X172.848 Y161.035 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2265
M204 S5000
G1 X172.74 Y160.833 E.00702
G3 X174.787 Y157.554 I2.17 J-.924 E.13922
G1 X174.902 Y157.551 E.00354
G3 X172.956 Y161.229 I.009 J2.359 E.2988
G1 X172.877 Y161.088 E.00497
; COOLING_NODE: 2
; WIPE_START
G1 F9547.055
M204 S8000
G1 X172.74 Y160.833 E-.10962
G1 X172.621 Y160.482 E-.14101
G1 X172.554 Y160.034 E-.17225
G1 X172.554 Y159.788 E-.09348
G1 X172.594 Y159.462 E-.12472
G1 X172.677 Y159.16 E-.11892
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.627 Y157.16 Z6.4 F60000
G1 Z6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2265
M204 S8000
G1 X172.627 Y154.036 E.10365
G3 X175.011 Y153.543 I2.507 J6.119 E.08121
G1 X177.195 Y153.543 E.07244
G1 X177.195 Y157.166 E.12021
G2 X172.674 Y157.123 I-2.288 J2.806 E.16197
; COOLING_NODE: 2
; WIPE_START
G1 F8843.478
G1 X172.643 Y155.123 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.741 Y153.559 Z6.4 F60000
G1 Z6
G1 E.8 F1800
G1 F2265
M204 S8000
G1 X172.851 Y153.519 E.00387
G3 X175.004 Y153.136 I2.318 J6.791 E.07282
G1 X177.602 Y153.136 E.08618
G1 X177.602 Y157.957 E.15994
G1 X177.436 Y158.013 E.00581
G2 X172.388 Y158.013 I-2.524 J1.912 E.19381
G1 X172.22 Y157.958 E.00586
G1 X172.22 Y153.768 E.13897
G1 X172.686 Y153.581 E.01665
; COOLING_NODE: 2
; WIPE_START
G1 F8843.478
G1 X172.851 Y153.519 E-.06712
G1 X173.553 Y153.314 E-.27808
G1 X174.274 Y153.187 E-.278
G1 X174.633 Y153.162 E-.13679
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X176.988 Y160.422 Z6.4 F60000
G1 X177.438 Y161.807 Z6.4
G1 Z6
G1 E.8 F1800
G1 F2265
M204 S8000
G1 X177.602 Y161.864 E.00575
G1 X177.602 Y162.402 E.01782
G1 X176.874 Y162.402 E.02413
G2 X177.401 Y161.854 I-2.907 J-3.321 E.02522
; COOLING_NODE: 2
; WIPE_START
G1 F8843.478
G1 X177.602 Y161.864 E-.07651
G1 X177.602 Y162.402 E-.20413
G1 X176.874 Y162.402 E-.2764
G1 X177.151 Y162.139 E-.1451
G1 X177.252 Y162.024 E-.05785
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.384 Y161.807 Z6.4 F60000
G1 Z6
G1 E.8 F1800
G1 F2265
M204 S8000
G1 X172.496 Y161.949 E.006
G2 X172.947 Y162.402 I3.475 J-3.01 E.02122
G1 X172.22 Y162.402 E.02413
G1 X172.22 Y161.864 E.01782
G1 X172.327 Y161.827 E.00376
; COOLING_NODE: 2
; WIPE_START
G1 F8843.478
G1 X172.496 Y161.949 E-.07918
G1 X172.947 Y162.402 E-.24292
G1 X172.22 Y162.402 E-.27639
G1 X172.22 Y161.977 E-.16152
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.814 Y154.355 Z6.4 F60000
G1 X171.813 Y154.325 Z6.4
G1 Z6
G1 E.8 F1800
G1 F2265
M204 S8000
G1 X170.603 Y155.448 E.05476
G2 X168.709 Y159.906 I4.331 J4.472 E.16501
G1 X168.709 Y167.309 E.24557
G1 X167.728 Y167.309 E.03254
G1 X167.729 Y159.996 E.24257
G3 X174.996 Y152.729 I7.408 J.141 E.37674
G1 X182.309 Y152.728 E.24256
G1 X182.309 Y153.709 E.03254
G1 X178.009 Y153.709 E.14264
G1 X178.009 Y158.069 E.14465
G3 X178.009 Y161.755 I-3.172 J1.843 E.1281
G1 X178.009 Y162.809 E.03495
G1 X177.06 Y162.809 E.03146
G3 X172.762 Y162.809 I-2.149 J-2.967 E.15236
G1 X171.813 Y162.809 E.03149
G1 X171.813 Y161.756 E.03492
G3 X171.813 Y158.069 I3.174 J-1.843 E.12812
G1 X171.813 Y154.385 E.1222
; COOLING_NODE: 0
M204 S250
G1 X171.421 Y155.224 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2265
M204 S5000
G2 X169.975 Y156.846 I4.9 J5.824 E.067
M73 P69 R4
G2 X169.101 Y159.909 I4.98 J3.077 E.09912
G1 X169.101 Y167.701 E.23942
G1 X167.336 Y167.701 E.05424
G1 X167.337 Y159.989 E.23695
G3 X174.989 Y152.337 I7.801 J.148 E.36747
G1 X182.701 Y152.336 E.23695
G1 X182.701 Y154.101 E.05424
G1 X178.401 Y154.101 E.13213
G1 X178.401 Y157.974 E.11902
G3 X178.401 Y161.848 I-3.533 J1.937 E.12418
G1 X178.401 Y163.201 E.04156
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X177.172 Y163.201 E.03775
G3 X172.649 Y163.201 I-2.261 J-3.325 E.1476
G1 X171.421 Y163.201 E.03776
G1 X171.421 Y161.849 E.04155
G3 X171.421 Y157.974 I3.533 J-1.937 E.12419
G1 X171.421 Y155.284 E.08265
M204 S10000
G1 X170.931 Y154.56 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.477734
G1 F2265
M204 S8000
G1 X171.12 Y154.404 E.00867
; LINE_WIDTH: 0.444194
G1 X171.311 Y154.253 E.00797
; LINE_WIDTH: 0.401967
G1 X171.507 Y154.103 E.00722
; LINE_WIDTH: 0.364708
G1 X171.606 Y154.029 E.00324
; LINE_WIDTH: 0.336949
G1 X171.706 Y153.956 E.00296
; LINE_WIDTH: 0.307007
G1 X171.807 Y153.884 E.00267
; LINE_WIDTH: 0.274885
G1 X171.908 Y153.812 E.00234
; LINE_WIDTH: 0.258753
G1 X172.016 Y153.738 E.00231
M204 S10000
G1 X170.931 Y154.56 F60000
; LINE_WIDTH: 0.526993
G1 F2265
M204 S8000
G2 X169.088 Y156.692 I4.45 J5.709 E.11188
; LINE_WIDTH: 0.560645
G1 X168.824 Y157.212 E.02462
G2 X168.283 Y159.093 I6.278 J2.826 E.08283
; LINE_WIDTH: 0.614516
G1 X168.282 Y159.103 E.00047
G2 X168.219 Y160.005 I7.722 J.99 E.04216
G1 X168.218 Y167.105 E.33071
; WIPE_START
G1 F6298.158
G1 X168.218 Y165.105 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.886 Y162.646 Z6.4 F60000
G1 Z6
G1 E.8 F1800
; LINE_WIDTH: 0.385844
G1 F2265
M204 S8000
G1 X173.458 Y162.781 E.01642
; LINE_WIDTH: 0.415792
G1 X173.522 Y162.791 E.00198
; LINE_WIDTH: 0.480792
G1 X173.574 Y162.79 E.00186
G2 X176.247 Y162.79 I1.336 J-2.89 E.09842
; LINE_WIDTH: 0.460951
G1 X176.298 Y162.787 E.00174
; LINE_WIDTH: 0.400999
G1 X176.93 Y162.65 E.01888
M204 S10000
G1 X176.537 Y162.407 F60000
; LINE_WIDTH: 0.104919
G1 F2265
M204 S8000
G1 X176.45 Y162.475 E.00056
; LINE_WIDTH: 0.132389
G1 X176.323 Y162.57 E.00116
; LINE_WIDTH: 0.175937
G1 X176.31 Y162.602 E.00038
; LINE_WIDTH: 0.223688
G1 X176.298 Y162.635 E.00052
; LINE_WIDTH: 0.27144
G1 X176.286 Y162.668 E.00065
; LINE_WIDTH: 0.319192
G1 X176.274 Y162.701 E.00079
; LINE_WIDTH: 0.366943
G1 X176.261 Y162.734 E.00092
; LINE_WIDTH: 0.414695
G1 X176.249 Y162.766 E.00106
; LINE_WIDTH: 0.459354
G1 X176.247 Y162.79 E.00081
M204 S10000
G1 X177.585 Y161.643 F60000
; LINE_WIDTH: 0.481305
G1 F2265
M204 S8000
G1 X177.722 Y161.385 E.01044
G2 X177.581 Y158.179 I-2.851 J-1.481 E.12004
; WIPE_START
G1 F8211.97
G1 X177.79 Y158.574 E-.16971
G1 X177.94 Y158.96 E-.15734
G1 X178.026 Y159.299 E-.13293
G1 X178.079 Y159.717 E-.16004
G1 X178.075 Y160.085 E-.13998
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.997 Y155.281 Z6.4 F60000
G1 Z6
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.505133
G1 F2265
M204 S8000
G1 X175.997 Y154.741 E.02033
G2 X174.487 Y154.759 I-.64 J9.679 E.05692
; LINE_WIDTH: 0.47192
G2 X173.794 Y154.883 I2.758 J17.415 E.0246
G1 X173.794 Y155.322 E.01535
G1 X174.52 Y155.195 E.02574
G1 X175.038 Y155.17 E.01816
; LINE_WIDTH: 0.510638
G1 X175.726 Y155.22 E.02627
G1 X175.938 Y155.267 E.00828
M204 S10000
G1 X176.425 Y155.854 F60000
; LINE_WIDTH: 0.41999
G1 F2265
M204 S8000
G1 X176.425 Y154.312 E.04737
G1 X175.038 Y154.312 E.04264
G1 X174.42 Y154.355 E.01901
G1 X173.617 Y154.511 E.02513
G1 X173.396 Y154.585 E.00717
G1 X173.396 Y155.857 E.03911
G1 X174.147 Y155.647 E.02395
G1 X174.861 Y155.576 E.02208
G1 X175.685 Y155.647 E.0254
G1 X176.368 Y155.837 E.02178
M204 S10000
G1 X176.802 Y156.46 F60000
G1 F2265
M204 S8000
G1 X176.802 Y153.935 E.07758
G1 X175.024 Y153.935 E.05463
G1 X174.371 Y153.981 E.02012
G1 X173.522 Y154.146 E.02658
G1 X173.019 Y154.312 E.01628
G1 X173.019 Y156.435 E.06523
G1 X173.664 Y156.153 E.02162
G1 X174.235 Y156.013 E.01807
G1 X174.891 Y155.952 E.02025
G1 X175.649 Y156.022 E.02338
G1 X176.366 Y156.229 E.02294
G1 X176.749 Y156.432 E.01332
; WIPE_START
G1 F9547.299
G1 X176.366 Y156.229 E-.16474
G1 X175.649 Y156.022 E-.28369
G1 X174.891 Y155.952 E-.2891
G1 X174.832 Y155.957 E-.02246
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X177.805 Y153.219 Z6.4 F60000
G1 Z6
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.616365
G1 F2265
M204 S8000
G1 X182.105 Y153.218 E.20093
; WIPE_START
G1 F6277.852
G1 X180.105 Y153.218 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X173.649 Y157.289 Z6.4 F60000
G1 X172.238 Y158.178 Z6.4
G1 Z6
G1 E.8 F1800
; LINE_WIDTH: 0.481292
G1 F2265
M204 S8000
G1 X172.1 Y158.435 E.01042
G2 X172.236 Y161.643 I2.852 J1.485 E.1201
; CHANGE_LAYER
; Z_HEIGHT: 6.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F8212.205
G1 X171.995 Y161.165 E-.20326
G1 X171.877 Y160.845 E-.12988
G1 X171.794 Y160.512 E-.13043
G1 X171.739 Y160.048 E-.17744
G1 X171.749 Y159.735 E-.11899
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 31/58
; update layer progress
M73 L31
M991 S0 P30 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 2
M204 S10000
G17
G3 Z6.4 I-1.087 J.547 P1  F60000
G1 X172.51 Y161.249 Z6.4
G1 Z6.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2295
M204 S8000
G1 X172.436 Y161.117 E.00502
G3 X174.63 Y157.173 I2.473 J-1.207 E.17557
G1 X174.877 Y157.159 E.0082
G3 X172.576 Y161.37 I.032 J2.752 E.3802
G1 X172.539 Y161.302 E.00256
; COOLING_NODE: 2
M204 S250
G1 X172.853 Y161.059 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2283
M204 S5000
G1 X172.789 Y160.945 E.00402
G3 X174.667 Y157.563 I2.121 J-1.035 E.13933
G1 X174.886 Y157.551 E.00674
G3 X172.909 Y161.162 I.024 J2.36 E.30188
G1 X172.882 Y161.112 E.00175
; COOLING_NODE: 2
; WIPE_START
G1 F9547.055
M204 S8000
G1 X172.789 Y160.945 E-.0725
G1 X172.631 Y160.522 E-.17177
G1 X172.556 Y160.075 E-.17189
G1 X172.56 Y159.704 E-.14128
G1 X172.586 Y159.501 E-.07785
G1 X172.666 Y159.182 E-.12472
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.627 Y157.17 Z6.6 F60000
G1 Z6.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2295
M204 S8000
G1 X172.627 Y154.037 E.10393
G3 X175.012 Y153.544 I2.509 J6.12 E.08126
G1 X177.195 Y153.544 E.07239
G1 X177.195 Y157.164 E.12008
G2 X172.674 Y157.133 I-2.28 J2.795 E.16208
; COOLING_NODE: 2
; WIPE_START
G1 F8843.478
G1 X172.643 Y155.133 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.742 Y153.561 Z6.6 F60000
G1 Z6.2
G1 E.8 F1800
G1 F2295
M204 S8000
G1 X172.852 Y153.52 E.00388
G3 X175.005 Y153.137 I2.319 J6.792 E.07283
G1 X177.602 Y153.137 E.08614
G1 X177.602 Y158.209 E.16827
G2 X176.096 Y156.981 I-2.934 J2.059 E.06527
G2 X172.526 Y157.838 I-1.181 J2.944 E.12986
G1 X172.22 Y158.21 E.01599
G1 X172.22 Y153.77 E.14727
G1 X172.686 Y153.583 E.01667
; COOLING_NODE: 2
; WIPE_START
G1 F8843.478
G1 X172.852 Y153.52 E-.06727
G1 X173.554 Y153.315 E-.27798
G1 X174.276 Y153.188 E-.27837
G1 X174.634 Y153.163 E-.13638
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X176.987 Y160.424 Z6.6 F60000
G1 X177.436 Y161.808 Z6.6
G1 Z6.2
G1 E.8 F1800
G1 F2295
M204 S8000
G1 X177.602 Y161.864 E.00581
G1 X177.602 Y162.402 E.01782
G1 X176.872 Y162.402 E.02419
G2 X177.399 Y161.855 I-2.675 J-3.104 E.0252
; COOLING_NODE: 2
; WIPE_START
G1 F8843.478
G1 X177.602 Y161.864 E-.07716
G1 X177.602 Y162.402 E-.20414
G1 X176.872 Y162.402 E-.27712
G1 X177.184 Y162.106 E-.16322
G1 X177.25 Y162.029 E-.03837
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.225 Y161.618 Z6.6 F60000
G1 Z6.2
G1 E.8 F1800
G1 F2295
M204 S8000
G1 X172.532 Y161.991 E.01601
G2 X172.954 Y162.402 I3.16 J-2.821 E.01955
G1 X172.22 Y162.402 E.02435
G1 X172.22 Y161.664 E.02448
; COOLING_NODE: 2
; WIPE_START
G1 F8843.478
G1 X172.532 Y161.991 E-.17187
G1 X172.954 Y162.402 E-.22376
G1 X172.22 Y162.402 E-.27896
G1 X172.22 Y162.177 E-.08541
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.825 Y154.555 Z6.6 F60000
G1 X171.813 Y154.325 Z6.6
G1 Z6.2
G1 E.8 F1800
G1 F2295
M204 S8000
G1 X170.603 Y155.449 E.05477
G2 X168.709 Y159.906 I4.331 J4.472 E.16499
G1 X168.709 Y167.309 E.24557
G1 X167.729 Y167.309 E.0325
G1 X167.73 Y159.998 E.24252
G3 X174.998 Y152.73 I7.414 J.146 E.37668
G1 X182.309 Y152.729 E.24252
G1 X182.309 Y153.709 E.0325
G1 X178.009 Y153.709 E.14264
G1 X178.009 Y158.064 E.14447
G3 X178.009 Y161.752 I-3.167 J1.844 E.12821
G1 X178.009 Y162.809 E.03504
G1 X177.062 Y162.809 E.0314
G3 X172.762 Y162.809 I-2.15 J-2.97 E.15242
M73 P70 R4
G1 X171.813 Y162.809 E.03149
G1 X171.813 Y161.758 E.03486
G3 X171.813 Y158.069 I3.177 J-1.844 E.12818
G1 X171.813 Y154.385 E.1222
; COOLING_NODE: 0
M204 S250
G1 X171.421 Y155.224 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2267
M204 S5000
G2 X169.983 Y156.833 I4.913 J5.839 E.06652
G2 X169.101 Y159.909 I4.95 J3.084 E.09961
G1 X169.101 Y167.701 E.23941
G1 X167.337 Y167.701 E.0542
G1 X167.338 Y159.991 E.23691
G3 X174.991 Y152.338 I7.807 J.154 E.3674
G1 X182.701 Y152.337 E.23691
G1 X182.701 Y154.101 E.0542
G1 X178.401 Y154.101 E.13213
G1 X178.401 Y157.972 E.11896
G3 X178.401 Y161.847 I-3.523 J1.937 E.12424
G1 X178.401 Y163.201 E.04159
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X177.173 Y163.201 E.03773
G3 X172.649 Y163.201 I-2.262 J-3.326 E.14762
G1 X171.421 Y163.201 E.03776
G1 X171.421 Y161.849 E.04153
G3 X171.421 Y157.974 I3.534 J-1.938 E.12421
G1 X171.421 Y155.284 E.08265
M204 S10000
G1 X170.747 Y154.718 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.533164
G1 F2295
M204 S8000
G2 X168.609 Y157.752 I4.366 J5.346 E.1501
; LINE_WIDTH: 0.578055
G2 X168.229 Y159.682 I6.57 J2.298 E.08609
; LINE_WIDTH: 0.614655
G2 X168.219 Y160.007 I10.3 J.461 E.01513
G1 X168.219 Y167.105 E.33071
; WIPE_START
G1 F6296.624
G1 X168.219 Y165.105 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.965 Y162.696 Z6.6 F60000
G1 Z6.2
G1 E.8 F1800
; LINE_WIDTH: 0.417936
G1 F2295
M204 S8000
G1 X173.523 Y162.794 E.01731
; LINE_WIDTH: 0.443954
G1 X173.555 Y162.795 E.00105
; LINE_WIDTH: 0.469206
G1 X173.587 Y162.795 E.00112
; LINE_WIDTH: 0.481432
G2 X176.043 Y162.876 I1.325 J-2.904 E.09011
G1 X176.245 Y162.791 E.00785
M204 S10000
G1 X176.256 Y162.759 F60000
; LINE_WIDTH: 0.410334
G1 F2295
M204 S8000
G1 X176.268 Y162.726 E.00102
; LINE_WIDTH: 0.363124
G1 X176.279 Y162.694 E.00089
; LINE_WIDTH: 0.315913
G1 X176.291 Y162.662 E.00076
; LINE_WIDTH: 0.268703
G1 X176.302 Y162.63 E.00063
; LINE_WIDTH: 0.221493
G1 X176.313 Y162.598 E.0005
; LINE_WIDTH: 0.174283
G1 X176.325 Y162.566 E.00036
; LINE_WIDTH: 0.144492
G1 X176.359 Y162.542 E.00035
; LINE_WIDTH: 0.118035
G1 X176.529 Y162.412 E.00131
M204 S10000
G1 X176.352 Y162.784 F60000
; LINE_WIDTH: 0.398908
G1 F2295
M204 S8000
G1 X176.939 Y162.645 E.01749
M204 S10000
G1 X176.352 Y162.784 F60000
; LINE_WIDTH: 0.445232
G1 F2295
M204 S8000
G1 X176.245 Y162.791 E.00352
G1 X176.256 Y162.759 E.00112
M204 S10000
G1 X177.585 Y161.644 F60000
; LINE_WIDTH: 0.481387
G1 F2295
M204 S8000
G2 X178.034 Y160.482 I-3.008 J-1.829 E.04475
; LINE_WIDTH: 0.48025
G2 X178.02 Y159.27 I-3.118 J-.57 E.04347
G1 X178.016 Y159.254 E.00058
G3 X177.942 Y158.893 I1.48 J-.493 E.01315
; LINE_WIDTH: 0.408972
G1 X177.947 Y158.835 E.00175
; LINE_WIDTH: 0.360793
G1 X177.952 Y158.776 E.00152
; LINE_WIDTH: 0.328944
G1 X177.857 Y158.216 E.01325
; WIPE_START
G1 F12586.368
G1 X177.952 Y158.776 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.996 Y155.283 Z6.6 F60000
G1 Z6.2
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.505081
G1 F2295
M204 S8000
G1 X175.996 Y154.742 E.02035
G2 X174.488 Y154.759 I-.643 J9.86 E.05685
; LINE_WIDTH: 0.470909
G2 X173.794 Y154.884 I2.9 J18.16 E.02461
G1 X173.794 Y155.319 E.01516
G1 X174.522 Y155.193 E.02578
G1 X175.047 Y155.172 E.01832
; LINE_WIDTH: 0.509543
G1 X175.651 Y155.209 E.02301
G1 X175.938 Y155.27 E.01114
M204 S10000
G1 X176.425 Y155.85 F60000
; LINE_WIDTH: 0.41999
G1 F2295
M204 S8000
G1 X176.425 Y154.313 E.04722
G1 X175.039 Y154.313 E.0426
G1 X174.422 Y154.357 E.019
G1 X173.619 Y154.513 E.02514
G1 X173.396 Y154.586 E.00721
G1 X173.396 Y155.867 E.03934
G3 X174.808 Y155.577 I1.527 J3.853 E.0445
G1 X175.471 Y155.612 E.02042
G1 X176.144 Y155.755 E.02114
G1 X176.369 Y155.831 E.00728
M204 S10000
G1 X176.802 Y156.452 F60000
G1 F2295
M204 S8000
G1 X176.802 Y153.936 E.07732
G1 X175.026 Y153.936 E.05459
G1 X174.373 Y153.982 E.02012
G1 X173.523 Y154.147 E.02659
G1 X173.019 Y154.314 E.01632
G1 X173.019 Y156.435 E.06517
G1 X173.752 Y156.126 E.02444
G3 X175.447 Y155.988 I1.197 J4.245 E.0526
G1 X176.062 Y156.123 E.01934
G3 X176.749 Y156.424 I-.709 J2.55 E.02313
; WIPE_START
G1 F9547.299
G1 X176.414 Y156.248 E-.14398
G1 X176.062 Y156.123 E-.14186
G1 X175.447 Y155.988 E-.23916
G1 X174.84 Y155.952 E-.23122
G1 X174.83 Y155.953 E-.00378
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X177.805 Y153.219 Z6.6 F60000
G1 Z6.2
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.615135
G1 F2295
M204 S8000
G1 X182.105 Y153.219 E.2005
; WIPE_START
G1 F6291.347
G1 X180.105 Y153.219 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.488 Y153.707 Z6.6 F60000
G1 X172.016 Y153.737 Z6.6
G1 Z6.2
G1 E.8 F1800
; LINE_WIDTH: 0.256902
G1 F2295
M204 S8000
G1 X171.909 Y153.812 E.00228
; LINE_WIDTH: 0.273058
G1 X171.808 Y153.884 E.00234
; LINE_WIDTH: 0.305312
G1 X171.706 Y153.957 E.00266
; LINE_WIDTH: 0.335283
G1 X171.607 Y154.03 E.00294
; LINE_WIDTH: 0.362962
G1 X171.508 Y154.103 E.00322
; LINE_WIDTH: 0.400106
G1 X171.312 Y154.253 E.00716
; LINE_WIDTH: 0.442418
G1 X171.12 Y154.405 E.00798
; LINE_WIDTH: 0.488497
G2 X170.747 Y154.718 I8.766 J10.848 E.01769
; WIPE_START
G1 F8079.415
G1 X171.12 Y154.405 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.964 Y158.22 Z6.6 F60000
G1 Z6.2
G1 E.8 F1800
; LINE_WIDTH: 0.328996
G1 F2295
M204 S8000
G1 X171.869 Y158.777 E.01317
; LINE_WIDTH: 0.36094
G1 X171.874 Y158.835 E.00152
; LINE_WIDTH: 0.409099
G1 X171.879 Y158.894 E.00175
; LINE_WIDTH: 0.457258
G1 X171.884 Y158.952 E.00198
; LINE_WIDTH: 0.467623
G1 X171.9 Y158.946 E.00059
; LINE_WIDTH: 0.440164
G1 X171.916 Y158.941 E.00055
; LINE_WIDTH: 0.41523
G1 X171.93 Y158.935 E.00044
; LINE_WIDTH: 0.383605
G1 X171.959 Y158.914 E.00101
; LINE_WIDTH: 0.342749
G1 X171.989 Y158.892 E.00089
; LINE_WIDTH: 0.301893
G1 X172.018 Y158.87 E.00077
; LINE_WIDTH: 0.261038
G1 X172.047 Y158.848 E.00065
; LINE_WIDTH: 0.220182
G1 X172.077 Y158.827 E.00053
; LINE_WIDTH: 0.178503
G1 X172.154 Y158.7 E.00164
; LINE_WIDTH: 0.139977
G1 X172.224 Y158.587 E.00105
; LINE_WIDTH: 0.109268
G1 X172.305 Y158.464 E.0008
M204 S10000
G1 X171.884 Y158.952 F60000
; LINE_WIDTH: 0.481127
G1 F2295
M204 S8000
G1 X171.846 Y159.085 E.00493
G2 X171.885 Y160.87 I3.053 J.827 E.06464
M204 S10000
G1 X171.904 Y160.877 F60000
; LINE_WIDTH: 0.43238
G1 F2295
M204 S8000
G1 X171.922 Y160.883 E.00063
; LINE_WIDTH: 0.401463
G1 X171.94 Y160.891 E.00057
; LINE_WIDTH: 0.363525
G1 X171.975 Y160.917 E.00112
; LINE_WIDTH: 0.317404
G1 X172.009 Y160.942 E.00096
; LINE_WIDTH: 0.271283
G1 X172.043 Y160.968 E.0008
; LINE_WIDTH: 0.225161
G1 X172.078 Y160.994 E.00064
; LINE_WIDTH: 0.185409
G1 X172.128 Y161.082 E.00117
; LINE_WIDTH: 0.146816
G1 X172.216 Y161.223 E.00141
; LINE_WIDTH: 0.110924
G1 X172.305 Y161.358 E.00089
M204 S10000
G1 X171.969 Y161.613 F60000
; LINE_WIDTH: 0.328413
G1 F2295
M204 S8000
G1 X171.869 Y161.045 E.01343
; LINE_WIDTH: 0.360469
G1 X171.871 Y160.98 E.00168
; LINE_WIDTH: 0.407368
G1 X171.872 Y160.915 E.00193
; LINE_WIDTH: 0.458292
G1 X171.885 Y160.87 E.00158
G1 X171.904 Y160.877 E.00067
; CHANGE_LAYER
; Z_HEIGHT: 6.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F8666.942
G1 X171.885 Y160.87 E-.22691
G1 X171.872 Y160.915 E-.53309
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 32/58
; update layer progress
M73 L32
M991 S0 P31 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 2
M204 S10000
G17
G3 Z6.6 I-.603 J1.057 P1  F60000
G1 X172.533 Y161.292 Z6.6
G1 Z6.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2285
M204 S8000
G1 X172.501 Y161.24 E.00201
G3 X174.629 Y157.173 I2.409 J-1.33 E.1801
G1 X174.865 Y157.159 E.00784
G3 X172.659 Y161.493 I.045 J2.751 E.3757
G1 X172.565 Y161.342 E.00591
; COOLING_NODE: 2
M204 S250
G1 X172.87 Y161.089 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2281
M204 S5000
G1 X172.846 Y161.053 E.00133
G3 X174.666 Y157.563 I2.064 J-1.143 E.14305
G1 X174.875 Y157.551 E.00641
G3 X173.102 Y161.426 I.035 J2.359 E.29218
G1 X172.904 Y161.138 E.01073
; COOLING_NODE: 2
; WIPE_START
G1 F9547.055
M204 S8000
G1 X172.846 Y161.053 E-.03924
G1 X172.707 Y160.756 E-.12446
G1 X172.631 Y160.521 E-.09384
G1 X172.556 Y160.076 E-.17178
G1 X172.568 Y159.623 E-.1722
G1 X172.642 Y159.259 E-.14107
G1 X172.659 Y159.216 E-.01742
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.627 Y157.16 Z6.8 F60000
G1 Z6.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2285
M204 S8000
G1 X172.627 Y154.039 E.10354
G3 X175.013 Y153.546 I2.51 J6.122 E.0813
G1 X177.195 Y153.545 E.07235
G1 X177.195 Y157.163 E.12
G2 X172.674 Y157.123 I-2.285 J2.786 E.16212
; COOLING_NODE: 2
; WIPE_START
G1 F8843.478
G1 X172.643 Y155.123 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.743 Y153.562 Z6.8 F60000
G1 Z6.4
G1 E.8 F1800
G1 F2285
M204 S8000
G1 X172.853 Y153.522 E.0039
G3 X175.006 Y153.138 I2.319 J6.792 E.07284
G1 X177.602 Y153.138 E.0861
G1 X177.602 Y157.957 E.15985
G1 X177.438 Y158.014 E.00575
G2 X172.526 Y157.838 I-2.527 J1.908 E.18664
G1 X172.22 Y158.21 E.01596
G1 X172.22 Y153.772 E.14722
G1 X172.687 Y153.584 E.01669
; COOLING_NODE: 2
; WIPE_START
G1 F8843.478
G1 X172.853 Y153.522 E-.06742
G1 X173.555 Y153.317 E-.278
G1 X174.276 Y153.189 E-.27835
G1 X174.634 Y153.164 E-.13623
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X177.164 Y160.365 Z6.8 F60000
G1 X177.602 Y161.612 Z6.8
G1 Z6.4
G1 E.8 F1800
G1 F2285
M204 S8000
G1 X177.602 Y162.402 E.0262
G1 X176.872 Y162.402 E.02419
G2 X177.565 Y161.66 I-3.488 J-3.952 E.03373
; COOLING_NODE: 2
; WIPE_START
G1 F8843.478
G1 X177.602 Y162.402 E-.28231
G1 X176.872 Y162.402 E-.2771
G1 X177.178 Y162.112 E-.16007
G1 X177.247 Y162.031 E-.04052
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.386 Y161.806 Z6.8 F60000
G1 Z6.4
G1 E.8 F1800
G1 F2285
M204 S8000
G1 X172.485 Y161.935 E.0054
G2 X172.961 Y162.402 I2.853 J-2.438 E.02215
G1 X172.22 Y162.402 E.02459
G1 X172.22 Y161.862 E.01789
G1 X172.329 Y161.825 E.00382
; COOLING_NODE: 2
; WIPE_START
G1 F8843.478
G1 X172.485 Y161.935 E-.07248
G1 X172.722 Y162.19 E-.13231
G1 X172.961 Y162.402 E-.12136
G1 X172.22 Y162.402 E-.28169
G1 X172.22 Y162.001 E-.15215
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.816 Y154.379 Z6.8 F60000
G1 X171.813 Y154.325 Z6.8
G1 Z6.4
G1 E.8 F1800
G1 F2285
M204 S8000
G1 X170.603 Y155.448 E.05475
G2 X168.709 Y159.903 I4.331 J4.472 E.16493
G1 X168.709 Y167.309 E.24566
G1 X167.73 Y167.309 E.03246
G1 X167.731 Y160.001 E.24241
G3 X174.999 Y152.731 I7.415 J.145 E.37674
G1 X182.309 Y152.73 E.24248
G1 X182.309 Y153.709 E.03246
G1 X178.009 Y153.709 E.14264
M73 P71 R4
G1 X178.009 Y158.069 E.14465
G3 X178.009 Y161.752 I-3.146 J1.842 E.12808
G1 X178.009 Y162.809 E.03504
G1 X177.059 Y162.809 E.03149
G3 X172.765 Y162.809 I-2.147 J-2.962 E.15224
G1 X171.813 Y162.809 E.03159
G1 X171.813 Y161.755 E.03495
G3 X171.813 Y158.069 I3.156 J-1.843 E.12814
G1 X171.813 Y154.385 E.1222
; COOLING_NODE: 0
M204 S250
G1 X171.421 Y155.224 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2267
M204 S5000
G2 X169.983 Y156.833 I4.913 J5.839 E.06651
G2 X169.101 Y159.908 I4.968 J3.09 E.09958
G1 X169.101 Y167.701 E.23944
G1 X167.338 Y167.701 E.05416
G1 X167.339 Y159.993 E.23685
G3 X174.992 Y152.339 I7.807 J.154 E.36741
G1 X182.701 Y152.338 E.23687
G1 X182.701 Y154.101 E.05416
G1 X178.401 Y154.101 E.13213
G1 X178.401 Y157.974 E.11902
G3 X178.401 Y161.847 I-3.505 J1.937 E.12422
G1 X178.401 Y163.201 E.04159
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X177.172 Y163.201 E.03775
G3 X172.65 Y163.201 I-2.261 J-3.323 E.14756
G1 X171.421 Y163.201 E.03779
G1 X171.421 Y161.848 E.04156
G3 X171.421 Y157.974 I3.513 J-1.937 E.12423
G1 X171.421 Y155.284 E.08265
M204 S10000
G1 X170.747 Y154.719 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.486756
G1 F2285
M204 S8000
G3 X171.121 Y154.406 I9.172 J10.576 E.01763
; LINE_WIDTH: 0.440733
G1 X171.313 Y154.254 E.00793
; LINE_WIDTH: 0.398404
G1 X171.509 Y154.103 E.00715
; LINE_WIDTH: 0.36113
G1 X171.608 Y154.03 E.00321
; LINE_WIDTH: 0.333396
G1 X171.708 Y153.957 E.00293
; LINE_WIDTH: 0.303461
G1 X171.809 Y153.885 E.00263
; LINE_WIDTH: 0.271353
G1 X171.91 Y153.813 E.00231
; LINE_WIDTH: 0.255239
G1 X172.016 Y153.74 E.00223
M204 S10000
G1 X170.747 Y154.719 F60000
; LINE_WIDTH: 0.533122
G1 F2285
M204 S8000
G2 X168.524 Y158.009 I4.383 J5.357 E.16088
; LINE_WIDTH: 0.582937
G2 X168.222 Y159.9 I6.558 J2.017 E.08457
; LINE_WIDTH: 0.61362
G1 X168.219 Y167.105 E.33505
; WIPE_START
G1 F6308.048
G1 X168.22 Y165.105 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.938 Y162.678 Z6.8 F60000
G1 Z6.4
G1 E.8 F1800
; LINE_WIDTH: 0.423047
G1 F2285
M204 S8000
G1 X173.562 Y162.799 E.01969
; LINE_WIDTH: 0.468125
G1 X173.597 Y162.801 E.00123
; LINE_WIDTH: 0.481275
G2 X176.043 Y162.876 I1.314 J-2.891 E.08972
G1 X176.245 Y162.791 E.00785
M204 S10000
G1 X176.256 Y162.758 F60000
; LINE_WIDTH: 0.446241
G1 F2285
M204 S8000
G1 X176.245 Y162.791 E.00112
G1 X176.348 Y162.785 E.00341
; LINE_WIDTH: 0.399677
G1 X176.933 Y162.648 E.01745
M204 S10000
G1 X176.53 Y162.412 F60000
; LINE_WIDTH: 0.118223
G1 F2285
M204 S8000
G1 X176.358 Y162.543 E.00132
; LINE_WIDTH: 0.144709
G1 X176.325 Y162.566 E.00034
; LINE_WIDTH: 0.174356
G1 X176.314 Y162.598 E.00036
; LINE_WIDTH: 0.221598
G1 X176.302 Y162.63 E.0005
; LINE_WIDTH: 0.268841
G1 X176.291 Y162.662 E.00063
; LINE_WIDTH: 0.316083
G1 X176.279 Y162.694 E.00076
; LINE_WIDTH: 0.363326
G1 X176.268 Y162.726 E.00089
; LINE_WIDTH: 0.410569
G1 X176.256 Y162.758 E.00102
; WIPE_START
G1 F9791.967
G1 X176.268 Y162.726 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X177.857 Y161.601 Z6.8 F60000
G1 Z6.4
G1 E.8 F1800
; LINE_WIDTH: 0.329012
G1 F2285
M204 S8000
G1 X177.952 Y161.045 E.01316
; LINE_WIDTH: 0.361184
G1 X177.947 Y160.986 E.00153
; LINE_WIDTH: 0.409832
G1 X177.942 Y160.927 E.00176
; LINE_WIDTH: 0.480975
G3 X178.037 Y160.461 I2.222 J.213 E.01701
G1 X178.04 Y160.446 E.00054
G2 X177.584 Y158.179 I-3.217 J-.532 E.08438
; WIPE_START
G1 F8218.16
G1 X177.837 Y158.679 E-.21294
G1 X177.942 Y158.969 E-.11721
G1 X178.02 Y159.267 E-.11698
G1 X178.062 Y159.522 E-.09843
G1 X178.085 Y159.86 E-.12868
G1 X178.077 Y160.086 E-.08575
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.042 Y155.176 Z6.8 F60000
G1 Z6.4
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.507563
G1 F2285
M204 S8000
G1 X175.735 Y155.222 E.02629
G1 X175.997 Y155.277 E.01012
G1 X175.997 Y154.743 E.02022
G2 X174.49 Y154.762 I-.632 J9.948 E.05712
; LINE_WIDTH: 0.471419
G2 X173.794 Y154.885 I2.541 J16.32 E.02469
G1 X173.794 Y155.315 E.015
G1 X174.53 Y155.197 E.02604
G1 X174.982 Y155.178 E.0158
M204 S10000
G1 X176.425 Y155.853 F60000
; LINE_WIDTH: 0.41999
G1 F2285
M204 S8000
G1 X176.425 Y154.314 E.04726
G1 X175.04 Y154.315 E.04256
G1 X174.423 Y154.358 E.01901
G1 X173.62 Y154.514 E.02514
G1 X173.396 Y154.588 E.00725
G1 X173.396 Y155.849 E.03874
G1 X173.956 Y155.682 E.01795
G3 X176.287 Y155.8 I.927 J4.768 E.07243
G1 X176.369 Y155.831 E.00271
M204 S10000
G1 X176.802 Y156.441 F60000
G1 F2285
M204 S8000
G1 X176.802 Y153.937 E.07695
G1 X175.027 Y153.938 E.05455
G1 X174.374 Y153.983 E.02012
G1 X173.524 Y154.148 E.02659
G1 X173.019 Y154.316 E.01636
G1 X173.019 Y156.435 E.06512
G3 X174.62 Y155.977 I1.877 J3.53 E.05155
G1 X174.972 Y155.962 E.0108
G1 X175.665 Y156.025 E.02139
G3 X176.751 Y156.411 I-1.008 J4.556 E.0355
; WIPE_START
G1 F9547.299
G1 X176.188 Y156.164 E-.23346
G1 X175.665 Y156.025 E-.20577
G1 X174.972 Y155.962 E-.26458
G1 X174.824 Y155.968 E-.05619
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X177.805 Y153.22 Z6.8 F60000
G1 Z6.4
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.613905
G1 F2285
M204 S8000
G1 X182.105 Y153.219 E.20007
; WIPE_START
G1 F6304.901
G1 X180.105 Y153.22 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X173.771 Y157.477 Z6.8 F60000
G1 X172.31 Y158.459 Z6.8
G1 Z6.4
G1 E.8 F1800
; LINE_WIDTH: 0.10393
G1 F2285
M204 S8000
G1 X172.249 Y158.548 E.00054
; LINE_WIDTH: 0.131373
G1 X172.16 Y158.688 E.0012
; LINE_WIDTH: 0.175688
G1 X172.076 Y158.827 E.00176
; LINE_WIDTH: 0.200749
G1 X172.073 Y158.832 E.00007
; LINE_WIDTH: 0.225133
G1 X172.042 Y158.852 E.00055
; LINE_WIDTH: 0.271812
G1 X172.011 Y158.873 E.0007
; LINE_WIDTH: 0.318491
G1 X171.979 Y158.893 E.00084
; LINE_WIDTH: 0.36517
G1 X171.948 Y158.913 E.00098
; LINE_WIDTH: 0.411849
G1 X171.917 Y158.933 E.00112
; LINE_WIDTH: 0.458528
G1 X171.885 Y158.953 E.00126
; LINE_WIDTH: 0.457956
G1 X171.88 Y158.895 E.00199
; LINE_WIDTH: 0.410102
G1 X171.874 Y158.836 E.00176
; LINE_WIDTH: 0.362103
G1 X171.869 Y158.777 E.00154
; LINE_WIDTH: 0.318552
G1 X171.977 Y158.199 E.0132
M204 S10000
G1 X171.885 Y158.953 F60000
; LINE_WIDTH: 0.480842
G1 F2285
M204 S8000
G1 X171.819 Y159.191 E.0088
G1 X171.759 Y159.528 E.01224
G2 X172.131 Y161.446 I3.16 J.382 E.07083
G1 X172.455 Y161.567 E.01236
; CHANGE_LAYER
; Z_HEIGHT: 6.6
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F8220.64
G1 X172.131 Y161.446 E-.13167
G1 X171.945 Y161.042 E-.16874
G1 X171.799 Y160.542 E-.19787
G1 X171.742 Y160.105 E-.16765
G1 X171.74 Y159.857 E-.09407
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 33/58
; update layer progress
M73 L33
M991 S0 P32 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 2
M204 S10000
G17
G3 Z6.8 I-1.065 J.589 P1  F60000
G1 X172.539 Y161.299 Z6.8
G1 Z6.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2276
M204 S8000
G1 X172.481 Y161.196 E.00392
G3 X174.767 Y157.162 I2.432 J-1.287 E.18293
G1 X174.912 Y157.158 E.00481
G3 X172.635 Y161.452 I.001 J2.751 E.37576
G1 X172.571 Y161.35 E.00399
; COOLING_NODE: 2
M204 S250
G1 X172.877 Y161.089 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2276
M204 S5000
G1 X172.74 Y160.833 E.00892
G3 X174.788 Y157.554 I2.171 J-.924 E.13923
G1 X174.909 Y157.551 E.00372
G3 X172.957 Y161.231 I.002 J2.359 E.29855
G1 X172.907 Y161.141 E.00315
; COOLING_NODE: 2
; WIPE_START
G1 F9547.055
M204 S8000
G1 X172.74 Y160.833 E-.13306
G1 X172.654 Y160.601 E-.09441
G1 X172.594 Y160.359 E-.09467
G1 X172.551 Y159.911 E-.17103
G1 X172.564 Y159.664 E-.0937
G1 X172.602 Y159.419 E-.09458
G1 X172.665 Y159.222 E-.07856
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.627 Y157.16 Z7 F60000
G1 Z6.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2276
M204 S8000
G1 X172.627 Y154.041 E.10348
G3 X175.015 Y153.547 I2.511 J6.118 E.08135
G1 X177.195 Y153.546 E.07231
G1 X177.195 Y157.154 E.11967
G2 X172.674 Y157.123 I-2.28 J2.809 E.16199
; COOLING_NODE: 2
; WIPE_START
G1 F8843.478
G1 X172.643 Y155.123 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.743 Y153.564 Z7 F60000
G1 Z6.6
G1 E.8 F1800
G1 F2276
M204 S8000
G1 X172.854 Y153.523 E.00393
G3 X175.007 Y153.14 I2.319 J6.791 E.07283
G1 X177.602 Y153.139 E.08605
G1 X177.602 Y157.958 E.15984
G1 X177.434 Y158.013 E.00586
G2 X172.384 Y158.014 I-2.525 J1.901 E.19409
G1 X172.22 Y157.957 E.00575
G1 X172.22 Y153.774 E.13878
G1 X172.687 Y153.586 E.01671
; COOLING_NODE: 2
; WIPE_START
G1 F8843.478
G1 X172.854 Y153.523 E-.06778
G1 X173.557 Y153.318 E-.27815
G1 X174.277 Y153.191 E-.27802
G1 X174.635 Y153.166 E-.13604
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X176.986 Y160.427 Z7 F60000
G1 X177.434 Y161.809 Z7
G1 Z6.6
G1 E.8 F1800
G1 F2276
M204 S8000
G1 X177.602 Y161.864 E.00586
G1 X177.602 Y162.402 E.01784
G1 X176.874 Y162.402 E.02413
G2 X177.396 Y161.856 I-2.972 J-3.365 E.02509
; COOLING_NODE: 2
; WIPE_START
G1 F8843.478
G1 X177.602 Y161.864 E-.07806
G1 X177.602 Y162.402 E-.20435
G1 X176.874 Y162.402 E-.27641
G1 X177.252 Y162.031 E-.20118
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.388 Y161.809 Z7 F60000
G1 Z6.6
G1 E.8 F1800
G1 F2276
M204 S8000
G1 X172.45 Y161.892 E.00347
G2 X172.956 Y162.402 I3.009 J-2.488 E.02386
G1 X172.22 Y162.402 E.02443
G1 X172.22 Y161.864 E.01784
G1 X172.331 Y161.827 E.00387
; COOLING_NODE: 2
; WIPE_START
G1 F8843.478
G1 X172.45 Y161.892 E-.0516
G1 X172.683 Y162.152 E-.13245
G1 X172.956 Y162.402 E-.14082
G1 X172.22 Y162.402 E-.2799
G1 X172.22 Y161.993 E-.15523
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.815 Y154.371 Z7 F60000
G1 X171.813 Y154.326 Z7
G1 Z6.6
G1 E.8 F1800
G1 F2276
M204 S8000
G1 X170.602 Y155.449 E.05478
G2 X168.709 Y159.906 I4.331 J4.471 E.16498
G1 X168.709 Y167.309 E.24557
G1 X167.731 Y167.309 E.03242
G1 X167.733 Y160.001 E.24242
M73 P72 R4
G3 X175 Y152.733 I7.415 J.147 E.37668
G1 X182.309 Y152.731 E.24244
G1 X182.309 Y153.709 E.03242
G1 X178.009 Y153.709 E.14264
G1 X178.009 Y158.064 E.14447
G3 X178.009 Y161.752 I-3.167 J1.844 E.12822
G1 X178.009 Y162.809 E.03504
G1 X177.062 Y162.809 E.0314
G3 X172.762 Y162.809 I-2.15 J-2.968 E.15243
G1 X171.813 Y162.809 E.03149
G1 X171.813 Y161.755 E.03495
G3 X171.813 Y158.069 I3.172 J-1.843 E.1281
G1 X171.813 Y154.386 E.12219
; COOLING_NODE: 0
M204 S250
G1 X171.421 Y155.224 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2266
M204 S5000
G2 X169.983 Y156.833 I4.908 J5.835 E.0665
G2 X169.101 Y159.909 I4.976 J3.092 E.09961
G1 X169.101 Y167.701 E.23941
G1 X167.339 Y167.701 E.05412
G1 X167.341 Y159.993 E.23683
G3 X174.993 Y152.341 I7.808 J.155 E.3674
G1 X182.701 Y152.339 E.23683
G1 X182.701 Y154.101 E.05412
G1 X178.401 Y154.101 E.13213
G1 X178.401 Y157.972 E.11896
G3 X178.401 Y161.847 I-3.523 J1.938 E.12424
G1 X178.401 Y163.201 E.04159
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X177.173 Y163.201 E.03773
G3 X172.649 Y163.201 I-2.262 J-3.323 E.14763
G1 X171.421 Y163.201 E.03776
G1 X171.421 Y161.848 E.04156
G3 X171.421 Y157.974 I3.533 J-1.937 E.12418
G1 X171.421 Y155.284 E.08265
M204 S10000
G1 X170.748 Y154.719 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.53123
G1 F2276
M204 S8000
G2 X168.532 Y157.985 I4.38 J5.357 E.15926
; LINE_WIDTH: 0.58125
G2 X168.223 Y159.899 I6.64 J2.056 E.08534
; LINE_WIDTH: 0.612395
G1 X168.22 Y167.105 E.33439
; WIPE_START
G1 F6321.612
G1 X168.221 Y165.105 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.965 Y162.696 Z7 F60000
G1 Z6.6
G1 E.8 F1800
; LINE_WIDTH: 0.419925
G1 F2276
M204 S8000
G1 X173.528 Y162.795 E.01757
; LINE_WIDTH: 0.480705
G1 X173.59 Y162.796 E.00219
G2 X176.247 Y162.79 I1.322 J-2.89 E.0978
G1 X176.247 Y162.79 E.00001
M204 S10000
G1 X176.249 Y162.768 F60000
; LINE_WIDTH: 0.442991
G1 F2276
M204 S8000
G1 X176.247 Y162.79 E.00069
G1 X176.356 Y162.783 E.00354
; LINE_WIDTH: 0.397548
G1 X176.94 Y162.644 E.01737
M204 S10000
G1 X176.537 Y162.407 F60000
; LINE_WIDTH: 0.104744
G1 F2276
M204 S8000
G1 X176.451 Y162.474 E.00055
; LINE_WIDTH: 0.132193
G1 X176.322 Y162.57 E.00116
; LINE_WIDTH: 0.176213
G1 X176.31 Y162.603 E.00038
; LINE_WIDTH: 0.224575
G1 X176.298 Y162.636 E.00052
; LINE_WIDTH: 0.272936
G1 X176.286 Y162.669 E.00066
; LINE_WIDTH: 0.321298
G1 X176.273 Y162.702 E.0008
; LINE_WIDTH: 0.36966
G1 X176.261 Y162.735 E.00094
; LINE_WIDTH: 0.418021
G1 X176.249 Y162.768 E.00108
M204 S10000
G1 X177.583 Y161.643 F60000
; LINE_WIDTH: 0.481126
G1 F2276
M204 S8000
G2 X177.79 Y158.574 I-2.719 J-1.725 E.11452
G1 X177.585 Y158.178 E.01594
M204 S10000
G1 X177.398 Y157.59 F60000
; LINE_WIDTH: 0.106144
G1 F2276
M204 S8000
G1 X177.28 Y157.49 E.0008
; WIPE_START
G1 F15000
G1 X177.398 Y157.59 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.994 Y155.286 Z7 F60000
G1 Z6.6
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.508252
G1 F2276
M204 S8000
G1 X175.994 Y154.748 E.02042
G2 X174.491 Y154.764 I-.608 J13.023 E.05701
; LINE_WIDTH: 0.46955
G2 X173.794 Y154.887 I1.758 J12.054 E.02462
G1 X173.794 Y155.329 E.01536
G1 X174.292 Y155.221 E.01773
G1 X175.072 Y155.179 E.02715
; LINE_WIDTH: 0.516134
G1 X175.704 Y155.23 E.02445
G1 X175.935 Y155.275 E.00907
M204 S10000
G1 X176.425 Y155.863 F60000
; LINE_WIDTH: 0.41999
G1 F2276
M204 S8000
G1 X176.425 Y154.316 E.04754
G1 X175.041 Y154.316 E.04252
G1 X174.424 Y154.359 E.01901
G1 X173.621 Y154.515 E.02514
G1 X173.396 Y154.59 E.00728
G1 X173.396 Y155.849 E.03869
G1 X174.154 Y155.646 E.0241
G1 X175.087 Y155.592 E.02871
G1 X175.335 Y155.598 E.00762
G1 X176.132 Y155.753 E.02495
G1 X176.369 Y155.842 E.00779
M204 S10000
G1 X176.767 Y156.414 F60000
G1 F2276
M204 S8000
G1 X176.799 Y156.427 E.00105
G2 X176.802 Y153.939 I-379.965 J-1.794 E.07646
G1 X175.028 Y153.939 E.05451
G1 X174.375 Y153.984 E.02013
G1 X173.525 Y154.15 E.02659
G1 X173.019 Y154.317 E.01639
G1 X173.019 Y156.435 E.06507
G1 X173.544 Y156.195 E.01774
G1 X174.248 Y156.011 E.02235
G1 X175.1 Y155.969 E.02623
G3 X176.06 Y156.123 I-.606 J6.851 E.02988
G1 X176.712 Y156.391 E.02166
; WIPE_START
G1 F9547.299
G1 X176.06 Y156.123 E-.26788
G1 X175.55 Y156.024 E-.19755
G1 X175.1 Y155.969 E-.17192
G1 X174.778 Y155.985 E-.12265
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X177.805 Y153.22 Z7 F60000
G1 Z6.6
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.612675
G1 F2276
M204 S8000
G1 X182.105 Y153.22 E.19963
; WIPE_START
G1 F6318.512
G1 X180.105 Y153.22 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.483 Y153.623 Z7 F60000
G1 X172.008 Y153.648 Z7
G1 Z6.6
G1 E.8 F1800
; LINE_WIDTH: 0.25326
G1 F2276
M204 S8000
G1 X171.911 Y153.813 E.00328
; LINE_WIDTH: 0.269655
G1 X171.809 Y153.885 E.0023
; LINE_WIDTH: 0.30194
G1 X171.708 Y153.958 E.00263
; LINE_WIDTH: 0.331909
G1 X171.608 Y154.031 E.00291
; LINE_WIDTH: 0.359601
G1 X171.509 Y154.104 E.00319
; LINE_WIDTH: 0.39676
G1 X171.314 Y154.254 E.00709
; LINE_WIDTH: 0.438999
G1 X171.122 Y154.406 E.0079
; LINE_WIDTH: 0.485034
G2 X170.748 Y154.719 I8.785 J10.873 E.01756
; WIPE_START
G1 F8142.697
G1 X171.122 Y154.406 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.238 Y158.179 Z7 F60000
G1 Z6.6
G1 E.8 F1800
; LINE_WIDTH: 0.481258
G1 F2276
M204 S8000
G1 X172.1 Y158.435 E.0104
G2 X172.237 Y161.644 I2.857 J1.485 E.12009
; CHANGE_LAYER
; Z_HEIGHT: 6.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F8212.852
G1 X172.039 Y161.263 E-.163
G1 X171.886 Y160.873 E-.15931
G1 X171.794 Y160.514 E-.14064
G1 X171.739 Y160.048 E-.17845
G1 X171.748 Y159.736 E-.1186
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 34/58
; update layer progress
M73 L34
M991 S0 P33 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 2
M204 S10000
G17
G3 Z7 I-1.086 J.549 P1  F60000
G1 X172.543 Y161.308 Z7
G1 Z6.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2278
M204 S8000
G1 X172.466 Y161.168 E.00529
G3 X174.766 Y157.162 I2.446 J-1.259 E.18188
G1 X174.9 Y157.158 E.00443
G3 X172.605 Y161.408 I.012 J2.751 E.37789
G1 X172.575 Y161.359 E.00192
; COOLING_NODE: 2
M204 S250
G1 X172.884 Y161.104 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2278
M204 S5000
G1 X172.724 Y160.795 E.01071
G3 X174.787 Y157.554 I2.187 J-.885 E.13795
G1 X174.898 Y157.551 E.0034
G3 X172.933 Y161.196 I.013 J2.359 E.30017
G1 X172.912 Y161.157 E.00135
; COOLING_NODE: 2
; WIPE_START
G1 F9547.055
M204 S8000
G1 X172.724 Y160.795 E-.15521
G1 X172.594 Y160.361 E-.17198
G1 X172.551 Y159.911 E-.17189
G1 X172.594 Y159.461 E-.17175
G1 X172.66 Y159.236 E-.08916
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.627 Y157.16 Z7.2 F60000
G1 Z6.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2278
M204 S8000
G1 X172.627 Y154.042 E.10342
G3 X175.016 Y153.548 I2.512 J6.12 E.08139
G1 X177.195 Y153.548 E.07227
G1 X177.195 Y157.154 E.11963
G2 X172.674 Y157.123 I-2.28 J2.809 E.162
; COOLING_NODE: 2
; WIPE_START
G1 F8843.478
G1 X172.643 Y155.123 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.744 Y153.565 Z7.2 F60000
G1 Z6.8
G1 E.8 F1800
G1 F2278
M204 S8000
G1 X172.855 Y153.524 E.00394
G3 X175.009 Y153.141 I2.319 J6.792 E.07284
G1 X177.602 Y153.141 E.08601
G1 X177.602 Y157.958 E.15979
G1 X177.434 Y158.013 E.00586
G2 X172.384 Y158.014 I-2.525 J1.902 E.19405
G1 X172.22 Y157.957 E.00576
G1 X172.22 Y153.775 E.13871
G1 X172.688 Y153.587 E.01673
; COOLING_NODE: 2
; WIPE_START
M73 P72 R3
G1 F8843.478
G1 X172.855 Y153.524 E-.06795
G1 X173.558 Y153.319 E-.27815
G1 X174.278 Y153.192 E-.27792
G1 X174.635 Y153.167 E-.13598
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X176.987 Y160.428 Z7.2 F60000
G1 X177.434 Y161.809 Z7.2
G1 Z6.8
G1 E.8 F1800
G1 F2278
M204 S8000
G1 X177.602 Y161.864 E.00586
M73 P73 R3
G1 X177.602 Y162.402 E.01784
G1 X176.874 Y162.402 E.02412
G2 X177.396 Y161.855 I-2.989 J-3.38 E.02509
; COOLING_NODE: 2
; WIPE_START
G1 F8843.478
G1 X177.602 Y161.864 E-.07801
G1 X177.602 Y162.402 E-.20434
G1 X176.874 Y162.402 E-.27636
G1 X177.253 Y162.031 E-.20128
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.386 Y161.808 Z7.2 F60000
G1 Z6.8
G1 E.8 F1800
G1 F2278
M204 S8000
G1 X172.455 Y161.899 E.00378
G2 X172.956 Y162.402 I3.005 J-2.492 E.02358
G1 X172.22 Y162.402 E.02442
G1 X172.22 Y161.864 E.01782
G1 X172.329 Y161.827 E.00382
; COOLING_NODE: 2
; WIPE_START
G1 F8843.478
G1 X172.455 Y161.899 E-.05508
G1 X172.682 Y162.151 E-.12898
G1 X172.956 Y162.402 E-.14107
G1 X172.22 Y162.402 E-.27972
G1 X172.22 Y161.993 E-.15514
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.815 Y154.372 Z7.2 F60000
G1 X171.813 Y154.326 Z7.2
G1 Z6.8
G1 E.8 F1800
G1 F2278
M204 S8000
G1 X170.603 Y155.449 E.05477
G2 X168.709 Y159.906 I4.331 J4.472 E.16499
G1 X168.709 Y167.309 E.24557
G1 X167.733 Y167.309 E.03237
G1 X167.734 Y160.002 E.24237
G3 X175.001 Y152.734 I7.415 J.146 E.37669
G1 X182.309 Y152.733 E.2424
G1 X182.309 Y153.709 E.03237
G1 X178.009 Y153.709 E.14264
G1 X178.009 Y158.069 E.14465
G3 X178.009 Y161.752 I-3.179 J1.842 E.12797
G1 X178.009 Y162.809 E.03504
G1 X177.062 Y162.809 E.03141
G3 X172.762 Y162.809 I-2.15 J-2.964 E.15243
G1 X171.813 Y162.809 E.03149
G1 X171.813 Y161.752 E.03504
G3 X171.813 Y158.069 I3.167 J-1.842 E.12801
G1 X171.813 Y154.386 E.12219
; COOLING_NODE: 0
M204 S250
G1 X171.421 Y155.225 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2265
M204 S5000
G2 X169.983 Y156.833 I4.909 J5.836 E.0665
G2 X169.101 Y159.909 I4.963 J3.088 E.09961
G1 X169.101 Y167.701 E.23942
G1 X167.341 Y167.701 E.05408
G1 X167.342 Y159.995 E.23679
G3 X174.994 Y152.342 I7.808 J.155 E.3674
G1 X182.701 Y152.341 E.23679
G1 X182.701 Y154.101 E.05408
G1 X178.401 Y154.101 E.13213
G1 X178.401 Y157.974 E.11902
G3 X178.401 Y161.847 I-3.544 J1.937 E.12412
G1 X178.401 Y163.201 E.04159
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X177.173 Y163.201 E.03773
G3 X172.649 Y163.201 I-2.262 J-3.319 E.14764
G1 X171.421 Y163.201 E.03776
G1 X171.421 Y161.847 E.04159
G3 X171.421 Y157.974 I3.531 J-1.937 E.12415
G1 X171.421 Y155.285 E.08265
M204 S10000
G1 X170.749 Y154.719 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.528052
G1 F2278
M204 S8000
G2 X168.607 Y157.762 I4.376 J5.355 E.14891
; LINE_WIDTH: 0.574022
G2 X168.231 Y159.682 I6.551 J2.282 E.08498
; LINE_WIDTH: 0.610951
G2 X168.221 Y160.012 I12.981 J.532 E.01526
G1 X168.221 Y167.105 E.32834
; WIPE_START
G1 F6337.691
G1 X168.221 Y165.105 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.962 Y162.694 Z7.2 F60000
G1 Z6.8
G1 E.8 F1800
; LINE_WIDTH: 0.417663
G1 F2278
M204 S8000
G1 X173.521 Y162.794 E.01735
; LINE_WIDTH: 0.44278
G1 X173.555 Y162.795 E.00112
; LINE_WIDTH: 0.469324
G1 X173.589 Y162.796 E.00119
; LINE_WIDTH: 0.481223
G2 X176.247 Y162.79 I1.323 J-2.901 E.09792
; LINE_WIDTH: 0.460578
G1 X176.3 Y162.787 E.00178
; LINE_WIDTH: 0.400315
G1 X176.935 Y162.648 E.01893
M204 S10000
G1 X176.538 Y162.407 F60000
; LINE_WIDTH: 0.104884
G1 F2278
M204 S8000
G1 X176.451 Y162.475 E.00056
; LINE_WIDTH: 0.132413
G1 X176.323 Y162.57 E.00116
; LINE_WIDTH: 0.17594
G1 X176.31 Y162.602 E.00038
; LINE_WIDTH: 0.223497
G1 X176.298 Y162.635 E.00051
; LINE_WIDTH: 0.271055
G1 X176.286 Y162.668 E.00065
; LINE_WIDTH: 0.318612
G1 X176.274 Y162.7 E.00078
; LINE_WIDTH: 0.36617
G1 X176.261 Y162.733 E.00092
; LINE_WIDTH: 0.413727
G1 X176.249 Y162.766 E.00105
; LINE_WIDTH: 0.458809
G1 X176.247 Y162.79 E.00083
M204 S10000
G1 X177.583 Y161.643 F60000
; LINE_WIDTH: 0.481307
G1 F2278
M204 S8000
G1 X177.723 Y161.384 E.01053
G2 X177.583 Y158.178 I-2.863 J-1.481 E.11999
M204 S10000
G1 X177.398 Y157.59 F60000
; LINE_WIDTH: 0.1062
G1 F2278
M204 S8000
G1 X177.279 Y157.489 E.0008
; WIPE_START
G1 F15000
G1 X177.398 Y157.59 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.997 Y155.284 Z7.2 F60000
G1 Z6.8
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.502914
G1 F2278
M204 S8000
G1 X175.997 Y154.745 E.02019
G2 X174.491 Y154.762 I-.644 J9.513 E.05651
; LINE_WIDTH: 0.469057
G2 X173.793 Y154.887 I2.795 J17.641 E.02464
G1 X173.793 Y155.32 E.01502
G1 X174.524 Y155.196 E.02575
G1 X175.049 Y155.171 E.01828
; LINE_WIDTH: 0.507329
G1 X175.652 Y155.21 E.02285
G1 X175.939 Y155.271 E.01109
M204 S10000
G1 X176.425 Y155.863 F60000
; LINE_WIDTH: 0.41999
G1 F2278
M204 S8000
G1 X176.425 Y154.317 E.0475
G1 X175.043 Y154.317 E.04248
G1 X174.425 Y154.36 E.01903
G1 X173.623 Y154.516 E.0251
G1 X173.396 Y154.591 E.00734
G1 X173.396 Y155.867 E.03919
G3 X175.476 Y155.613 I1.527 J3.852 E.06508
G1 X176.145 Y155.755 E.02102
G1 X176.369 Y155.841 E.0074
M204 S10000
G1 X176.767 Y156.414 F60000
G1 F2278
M204 S8000
G1 X176.799 Y156.427 E.00105
G2 X176.802 Y153.94 I-369.898 J-1.795 E.07642
G1 X175.03 Y153.94 E.05448
G1 X174.376 Y153.986 E.02014
G1 X173.527 Y154.151 E.02655
G1 X173.019 Y154.319 E.01645
G1 X173.019 Y156.436 E.06505
G1 X173.751 Y156.126 E.02442
G3 X175.45 Y155.989 I1.206 J4.338 E.05269
G1 X176.063 Y156.123 E.01928
G1 X176.712 Y156.391 E.02158
; WIPE_START
G1 F9547.299
G1 X176.063 Y156.123 E-.26682
G1 X175.45 Y155.989 E-.23849
G1 X174.888 Y155.952 E-.21369
G1 X174.781 Y155.961 E-.04099
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X177.805 Y153.221 Z7.2 F60000
G1 Z6.8
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.611435
G1 F2278
M204 S8000
G1 X182.105 Y153.221 E.1992
; WIPE_START
G1 F6332.296
G1 X180.105 Y153.221 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.483 Y153.624 Z7.2 F60000
G1 X172.01 Y153.649 Z7.2
G1 Z6.8
G1 E.8 F1800
; LINE_WIDTH: 0.251763
G1 F2278
M204 S8000
G1 X171.912 Y153.813 E.00326
; LINE_WIDTH: 0.267893
G1 X171.81 Y153.886 E.00228
; LINE_WIDTH: 0.300081
G1 X171.709 Y153.958 E.00261
; LINE_WIDTH: 0.330086
G1 X171.609 Y154.031 E.0029
; LINE_WIDTH: 0.357905
G1 X171.51 Y154.105 E.00318
; LINE_WIDTH: 0.395064
G1 X171.315 Y154.254 E.00704
; LINE_WIDTH: 0.437329
G1 X171.122 Y154.407 E.0079
; LINE_WIDTH: 0.483382
G2 X170.749 Y154.719 I8.761 J10.843 E.01747
; WIPE_START
G1 F8173.24
G1 X171.122 Y154.407 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.238 Y158.179 Z7.2 F60000
G1 Z6.8
G1 E.8 F1800
; LINE_WIDTH: 0.481312
G1 F2278
M204 S8000
G1 X172.031 Y158.574 E.01592
G2 X172.236 Y161.644 I2.942 J1.345 E.11455
; CHANGE_LAYER
; Z_HEIGHT: 7
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F8211.835
G1 X172.019 Y161.219 E-.18111
G1 X171.879 Y160.853 E-.14906
G1 X171.79 Y160.492 E-.14119
G1 X171.745 Y160.155 E-.12943
G1 X171.74 Y159.771 E-.14586
G1 X171.744 Y159.736 E-.01334
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 35/58
; update layer progress
M73 L35
M991 S0 P34 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 2
M204 S10000
G17
G3 Z7.2 I-1.085 J.552 P1  F60000
G1 X172.547 Y161.316 Z7.2
G1 Z7
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2312
M204 S8000
G1 X172.436 Y161.117 E.00754
G3 X174.63 Y157.173 I2.473 J-1.207 E.17554
G1 X174.872 Y157.159 E.00805
G3 X172.576 Y161.369 I.037 J2.752 E.38039
G1 X172.576 Y161.368 E.00003
; COOLING_NODE: 2
M204 S250
G1 X172.89 Y161.126 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2283
M204 S5000
G1 X172.789 Y160.945 E.00636
G3 X174.667 Y157.563 I2.121 J-1.035 E.13932
G1 X174.881 Y157.551 E.0066
G3 X172.919 Y161.178 I.029 J2.359 E.30144
; COOLING_NODE: 2
; WIPE_START
G1 F9547.055
M204 S8000
G1 X172.789 Y160.945 E-.1014
G1 X172.653 Y160.599 E-.14118
G1 X172.602 Y160.401 E-.07763
G1 X172.556 Y160.075 E-.1251
G1 X172.56 Y159.704 E-.14127
G1 X172.587 Y159.5 E-.07802
G1 X172.647 Y159.257 E-.09541
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.627 Y157.17 Z7.4 F60000
G1 Z7
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2312
M204 S8000
G1 X172.627 Y154.044 E.1037
G3 X175.017 Y153.549 I2.513 J6.118 E.08143
G1 X177.195 Y153.549 E.07223
G1 X177.195 Y157.154 E.11959
G2 X172.674 Y157.133 I-2.274 J2.821 E.16194
; COOLING_NODE: 2
; WIPE_START
G1 F8843.478
G1 X172.643 Y155.133 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.745 Y153.567 Z7.4 F60000
G1 Z7
G1 E.8 F1800
G1 F2312
M204 S8000
G1 X172.856 Y153.525 E.00395
G3 X175.01 Y153.142 I2.319 J6.791 E.07284
G1 X177.602 Y153.142 E.08598
G1 X177.602 Y158.21 E.16811
G2 X176.337 Y157.091 I-2.927 J2.036 E.05652
G2 X172.527 Y157.838 I-1.422 J2.84 E.13859
M73 P74 R3
G1 X172.22 Y158.21 E.016
G1 X172.22 Y153.777 E.14703
G1 X172.689 Y153.589 E.01676
; COOLING_NODE: 2
; WIPE_START
G1 F8843.478
G1 X172.856 Y153.525 E-.06801
G1 X173.559 Y153.32 E-.27819
G1 X174.28 Y153.193 E-.27806
G1 X174.636 Y153.168 E-.13574
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X177.165 Y160.37 Z7.4 F60000
G1 X177.602 Y161.613 Z7.4
G1 Z7
G1 E.8 F1800
G1 F2312
M204 S8000
G1 X177.602 Y162.402 E.02614
G1 X176.872 Y162.402 E.02419
G2 X177.565 Y161.661 I-3.549 J-4.015 E.03369
; COOLING_NODE: 2
; WIPE_START
G1 F8843.478
G1 X177.602 Y162.402 E-.28172
G1 X176.872 Y162.402 E-.27713
G1 X177.177 Y162.112 E-.15975
G1 X177.248 Y162.03 E-.04139
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.265 Y161.666 Z7.4 F60000
G1 Z7
G1 E.8 F1800
G1 F2312
M204 S8000
G1 X172.532 Y161.99 E.01393
G2 X172.954 Y162.402 I3.152 J-2.814 E.01956
G1 X172.22 Y162.402 E.02435
G1 X172.22 Y161.612 E.0262
G1 X172.227 Y161.62 E.00036
; COOLING_NODE: 2
; WIPE_START
G1 F8843.478
G1 X172.532 Y161.99 E-.18236
G1 X172.954 Y162.402 E-.22393
G1 X172.22 Y162.402 E-.27899
G1 X172.22 Y162.205 E-.07473
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.826 Y154.583 Z7.4 F60000
G1 X171.813 Y154.325 Z7.4
G1 Z7
G1 E.8 F1800
G1 F2312
M204 S8000
G1 X170.602 Y155.449 E.0548
G2 X168.709 Y159.906 I4.332 J4.471 E.16497
G1 X168.709 Y167.309 E.24557
G1 X167.734 Y167.309 E.03233
G1 X167.735 Y160.003 E.24233
G3 X175.003 Y152.735 I7.408 J.14 E.37678
G1 X182.309 Y152.734 E.24236
G1 X182.309 Y153.709 E.03233
G1 X178.009 Y153.709 E.14264
G1 X178.009 Y158.069 E.14465
G3 X178.009 Y161.752 I-3.146 J1.842 E.12808
G1 X178.009 Y162.809 E.03504
G1 X177.062 Y162.809 E.0314
G3 X172.765 Y162.809 I-2.149 J-2.959 E.15237
G1 X171.813 Y162.809 E.03158
G1 X171.813 Y161.758 E.03487
G3 X171.813 Y158.066 I3.183 J-1.846 E.12827
G1 X171.813 Y154.385 E.1221
; COOLING_NODE: 0
M204 S250
G1 X171.421 Y155.224 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2262
M204 S5000
G2 X169.931 Y156.917 I4.839 J5.76 E.06956
G2 X169.101 Y159.909 I5.003 J3 E.09656
G1 X169.101 Y167.701 E.23941
G1 X167.342 Y167.701 E.05405
G1 X167.343 Y159.996 E.23675
G3 X174.996 Y152.343 I7.801 J.148 E.36748
G1 X182.701 Y152.342 E.23676
G1 X182.701 Y154.101 E.05405
G1 X178.401 Y154.101 E.13213
G1 X178.401 Y157.974 E.11902
G3 X178.401 Y161.847 I-3.505 J1.937 E.12422
G1 X178.401 Y163.201 E.04159
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X177.173 Y163.201 E.03773
G3 X172.65 Y163.201 I-2.261 J-3.317 E.14762
G1 X171.421 Y163.201 E.03778
G1 X171.421 Y161.849 E.04153
G3 X171.421 Y157.973 I3.537 J-1.938 E.12424
G1 X171.421 Y155.284 E.08262
M204 S10000
G1 X170.749 Y154.72 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.526355
G1 F2312
M204 S8000
G2 X168.608 Y157.762 I4.375 J5.355 E.14839
; LINE_WIDTH: 0.57259
G2 X168.231 Y159.682 I6.53 J2.278 E.08472
; LINE_WIDTH: 0.609705
G2 X168.222 Y160.013 I14.25 J.566 E.0153
G1 X168.221 Y167.105 E.32755
; WIPE_START
G1 F6351.621
G1 X168.221 Y165.105 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.972 Y162.699 Z7.4 F60000
G1 Z7
G1 E.8 F1800
; LINE_WIDTH: 0.419985
G1 F2312
M204 S8000
G1 X173.529 Y162.795 E.01737
; LINE_WIDTH: 0.480933
G1 X173.586 Y162.796 E.00204
G2 X176.134 Y162.84 I1.324 J-2.885 E.09357
G1 X176.245 Y162.791 E.00435
M204 S10000
G1 X176.249 Y162.764 F60000
; LINE_WIDTH: 0.444627
G1 F2312
M204 S8000
G1 X176.245 Y162.791 E.00087
G1 X176.352 Y162.784 E.00352
; LINE_WIDTH: 0.398848
G1 X176.939 Y162.645 E.01748
M204 S10000
G1 X176.529 Y162.413 F60000
; LINE_WIDTH: 0.117126
G1 F2312
M204 S8000
G1 X176.365 Y162.537 E.00124
; LINE_WIDTH: 0.143324
G1 X176.325 Y162.566 E.00041
; LINE_WIDTH: 0.172809
G1 X176.304 Y162.603 E.00044
; LINE_WIDTH: 0.217976
G1 X176.283 Y162.639 E.0006
; LINE_WIDTH: 0.263144
G1 X176.263 Y162.675 E.00075
; LINE_WIDTH: 0.293686
G1 X176.26 Y162.685 E.00021
; LINE_WIDTH: 0.324081
G1 X176.256 Y162.712 E.00061
; LINE_WIDTH: 0.368922
G1 X176.253 Y162.738 E.00071
; LINE_WIDTH: 0.413764
G1 X176.249 Y162.764 E.0008
; WIPE_START
G1 F9707.586
G1 X176.253 Y162.738 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X177.839 Y161.621 Z7.4 F60000
G1 Z7
G1 E.8 F1800
; LINE_WIDTH: 0.272605
G1 F2312
M204 S8000
G1 X177.896 Y161.335 E.00546
; LINE_WIDTH: 0.315215
G1 X177.952 Y161.048 E.00647
; LINE_WIDTH: 0.338084
G1 X177.953 Y161.041 E.00018
; LINE_WIDTH: 0.36321
G1 X177.948 Y160.985 E.00147
; LINE_WIDTH: 0.410314
G1 X177.942 Y160.929 E.00169
; LINE_WIDTH: 0.457418
G1 X177.936 Y160.873 E.0019
; LINE_WIDTH: 0.481137
G2 X178.019 Y159.266 I-3.065 J-.965 E.05806
; LINE_WIDTH: 0.477549
G1 X178.012 Y159.23 E.00132
G3 X177.942 Y158.893 I1.331 J-.452 E.01219
; LINE_WIDTH: 0.408691
G1 X177.947 Y158.835 E.00175
; LINE_WIDTH: 0.360526
G1 X177.952 Y158.777 E.00152
; LINE_WIDTH: 0.327516
G1 X177.857 Y158.219 E.01312
M204 S10000
G1 X177.398 Y157.591 F60000
; LINE_WIDTH: 0.10573
G1 F2312
M204 S8000
G1 X177.278 Y157.488 E.00081
; WIPE_START
G1 F15000
G1 X177.398 Y157.591 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.046 Y155.176 Z7.4 F60000
G1 Z7
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.505703
G1 F2312
M204 S8000
G1 X175.737 Y155.223 E.02612
G1 X175.998 Y155.278 E.01005
G1 X175.998 Y154.746 E.02007
G2 X174.493 Y154.764 I-.632 J9.878 E.05681
; LINE_WIDTH: 0.46907
G2 X173.792 Y154.889 I2.476 J16.01 E.0247
G1 X173.792 Y155.319 E.01496
G1 X174.532 Y155.198 E.02604
G1 X174.986 Y155.179 E.01576
M204 S10000
G1 X176.425 Y155.853 F60000
; LINE_WIDTH: 0.41999
G1 F2312
M204 S8000
G1 X176.425 Y154.318 E.04715
G1 X175.044 Y154.318 E.04245
G1 X174.426 Y154.362 E.01902
G1 X173.624 Y154.518 E.02512
G1 X173.396 Y154.593 E.00738
G1 X173.396 Y155.859 E.03889
G1 X173.958 Y155.683 E.0181
G3 X176.287 Y155.8 I.929 J4.734 E.07238
G1 X176.369 Y155.831 E.0027
M204 S10000
G1 X176.802 Y156.441 F60000
G1 F2312
M204 S8000
G1 X176.802 Y153.941 E.07681
G1 X175.031 Y153.941 E.05444
G1 X174.377 Y153.987 E.02013
G1 X173.528 Y154.152 E.02657
G1 X173.019 Y154.321 E.01648
G1 X173.019 Y156.445 E.06527
G1 X173.392 Y156.255 E.01285
G1 X174.071 Y156.043 E.02186
G3 X175.666 Y156.025 I.851 J4.81 E.04926
G3 X176.751 Y156.41 I-1.026 J4.607 E.03544
; WIPE_START
G1 F9547.299
G1 X176.189 Y156.164 E-.23325
G1 X175.666 Y156.025 E-.20528
G1 X174.974 Y155.962 E-.26414
G1 X174.823 Y155.968 E-.05733
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X177.805 Y153.222 Z7.4 F60000
G1 Z7
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.610205
G1 F2312
M204 S8000
G1 X182.105 Y153.221 E.19877
; WIPE_START
G1 F6346.026
G1 X180.105 Y153.221 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.488 Y153.703 Z7.4 F60000
G1 X172.016 Y153.733 Z7.4
G1 Z7
G1 E.8 F1800
; LINE_WIDTH: 0.249804
G1 F2312
M204 S8000
G1 X171.913 Y153.814 E.00221
; LINE_WIDTH: 0.265956
G1 X171.811 Y153.886 E.00227
; LINE_WIDTH: 0.298255
G1 X171.709 Y153.958 E.0026
; LINE_WIDTH: 0.328289
G1 X171.61 Y154.032 E.00288
; LINE_WIDTH: 0.356033
G1 X171.51 Y154.105 E.00316
; LINE_WIDTH: 0.393202
G1 X171.315 Y154.255 E.00702
; LINE_WIDTH: 0.435456
G1 X171.123 Y154.407 E.00784
; LINE_WIDTH: 0.481532
G2 X170.749 Y154.72 I8.761 J10.844 E.01742
; WIPE_START
G1 F8207.723
G1 X171.123 Y154.407 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.964 Y158.218 Z7.4 F60000
G1 Z7
G1 E.8 F1800
; LINE_WIDTH: 0.329616
G1 F2312
M204 S8000
G1 X171.869 Y158.777 E.01324
; LINE_WIDTH: 0.360895
G1 X171.874 Y158.835 E.00152
; LINE_WIDTH: 0.409044
G1 X171.879 Y158.893 E.00175
; LINE_WIDTH: 0.457192
G1 X171.884 Y158.952 E.00198
; LINE_WIDTH: 0.468731
G1 X171.899 Y158.947 E.00054
; LINE_WIDTH: 0.443648
G1 X171.914 Y158.941 E.00051
; LINE_WIDTH: 0.419366
G1 X171.928 Y158.936 E.00046
; LINE_WIDTH: 0.386841
G1 X171.958 Y158.914 E.00104
; LINE_WIDTH: 0.345289
G1 X171.987 Y158.892 E.00091
; LINE_WIDTH: 0.303737
G1 X172.017 Y158.87 E.00079
; LINE_WIDTH: 0.262185
G1 X172.047 Y158.848 E.00066
; LINE_WIDTH: 0.220633
G1 X172.077 Y158.827 E.00054
; LINE_WIDTH: 0.175744
G1 X172.16 Y158.688 E.00175
; LINE_WIDTH: 0.131325
G1 X172.25 Y158.546 E.00121
; LINE_WIDTH: 0.103806
G1 X172.311 Y158.457 E.00054
M204 S10000
G1 X171.884 Y158.952 F60000
; LINE_WIDTH: 0.481252
G1 F2312
M204 S8000
G1 X171.844 Y159.09 E.00514
G2 X171.885 Y160.869 I3.09 J.82 E.06443
; LINE_WIDTH: 0.456466
G1 X171.916 Y160.886 E.0012
; LINE_WIDTH: 0.407149
G1 X171.948 Y160.902 E.00106
; LINE_WIDTH: 0.357833
G1 X171.979 Y160.919 E.00091
; LINE_WIDTH: 0.308516
G1 X172.011 Y160.936 E.00077
; LINE_WIDTH: 0.2592
G1 X172.042 Y160.952 E.00063
; LINE_WIDTH: 0.216793
G1 X172.077 Y160.994 E.00077
; LINE_WIDTH: 0.18349
G1 X172.132 Y161.088 E.00125
; LINE_WIDTH: 0.145635
G1 X172.216 Y161.223 E.00133
; LINE_WIDTH: 0.110828
G1 X172.305 Y161.357 E.00089
M204 S10000
G1 X171.965 Y161.607 F60000
; LINE_WIDTH: 0.327513
G1 F2312
M204 S8000
G1 X171.869 Y161.044 E.01323
; LINE_WIDTH: 0.360617
G1 X171.874 Y160.986 E.00152
; LINE_WIDTH: 0.408817
G1 X171.88 Y160.928 E.00175
; LINE_WIDTH: 0.457017
G1 X171.885 Y160.869 E.00198
; CHANGE_LAYER
; Z_HEIGHT: 7.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F8693.627
G1 X171.88 Y160.928 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 36/58
; update layer progress
M73 L36
M991 S0 P35 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 2
M204 S10000
G17
G3 Z7.4 I-.624 J1.045 P1  F60000
G1 X172.556 Y161.332 Z7.4
G1 Z7.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2266
M204 S8000
G1 X172.437 Y161.117 E.00815
G3 X174.628 Y157.173 I2.473 J-1.207 E.17544
G1 X174.86 Y157.159 E.0077
G3 X172.586 Y161.384 I.051 J2.751 E.38027
; COOLING_NODE: 2
M204 S250
G1 X172.899 Y161.142 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2266
M204 S5000
G1 X172.79 Y160.945 E.00691
G3 X174.666 Y157.563 I2.121 J-1.035 E.13927
G1 X174.87 Y157.551 E.00629
G3 X172.93 Y161.193 I.041 J2.359 E.30125
; COOLING_NODE: 2
; WIPE_START
G1 F9547.055
M204 S8000
G1 X172.79 Y160.945 E-.10825
G1 X172.631 Y160.522 E-.17172
G1 X172.556 Y160.076 E-.17193
G1 X172.56 Y159.703 E-.14147
G1 X172.611 Y159.38 E-.12429
G1 X172.642 Y159.273 E-.04235
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.627 Y157.165 Z7.6 F60000
G1 Z7.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2266
M204 S8000
G1 X172.627 Y154.046 E.10347
M73 P75 R3
G3 X175.018 Y153.55 I2.515 J6.117 E.08148
G1 X177.195 Y153.55 E.07219
G1 X177.195 Y157.162 E.11981
G2 X172.674 Y157.128 I-2.282 J2.81 E.16197
; COOLING_NODE: 2
M204 S10000
G1 X172.386 Y158.013 F60000
G1 F2266
M204 S8000
G1 X172.22 Y157.957 E.00581
G1 X172.22 Y153.779 E.1386
G3 X175.011 Y153.143 I2.957 J6.54 E.0956
G1 X177.602 Y153.143 E.08593
G1 X177.602 Y158.21 E.16808
G2 X176.102 Y156.984 I-2.929 J2.053 E.06505
G2 X172.422 Y157.966 I-1.185 J2.945 E.13549
; COOLING_NODE: 2
; WIPE_START
G1 F8843.478
G1 X172.22 Y157.957 E-.07698
G1 X172.22 Y156.16 E-.68302
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X177.398 Y161.767 Z7.6 F60000
G1 X177.436 Y161.808 Z7.6
G1 Z7.2
G1 E.8 F1800
G1 F2266
M204 S8000
G1 X177.602 Y161.864 E.00581
G1 X177.602 Y162.402 E.01782
G1 X176.882 Y162.402 E.02387
G2 X177.399 Y161.855 I-3.092 J-3.44 E.02497
; COOLING_NODE: 2
; WIPE_START
G1 F8843.478
G1 X177.602 Y161.864 E-.0772
G1 X177.602 Y162.402 E-.20414
G1 X176.882 Y162.402 E-.27342
G1 X177.19 Y162.099 E-.16381
G1 X177.26 Y162.017 E-.04143
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.274 Y161.678 Z7.6 F60000
G1 Z7.2
G1 E.8 F1800
G1 F2266
M204 S8000
G1 X172.532 Y161.99 E.01343
G2 X172.954 Y162.402 I3.151 J-2.812 E.01957
G1 X172.22 Y162.402 E.02436
G1 X172.22 Y161.612 E.0262
G1 X172.236 Y161.632 E.00085
; COOLING_NODE: 2
; WIPE_START
G1 F8843.478
G1 X172.532 Y161.99 E-.17662
G1 X172.954 Y162.402 E-.22401
G1 X172.22 Y162.402 E-.27901
G1 X172.22 Y162.19 E-.08036
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.825 Y154.568 Z7.6 F60000
G1 X171.813 Y154.325 Z7.6
G1 Z7.2
G1 E.8 F1800
G1 F2266
M204 S8000
G1 X170.603 Y155.449 E.05477
G2 X168.709 Y159.906 I4.331 J4.472 E.16499
G1 X168.709 Y167.309 E.24557
G1 X167.735 Y167.309 E.03229
G1 X167.736 Y160.005 E.24228
G3 X175.004 Y152.736 I7.408 J.139 E.37679
G1 X182.309 Y152.735 E.24232
G1 X182.309 Y153.709 E.03229
G1 X178.009 Y153.709 E.14264
G1 X178.009 Y158.066 E.14456
G3 X178.009 Y161.755 I-3.156 J1.844 E.12825
G1 X178.009 Y162.809 E.03495
G1 X177.06 Y162.809 E.03148
G3 X172.762 Y162.809 I-2.149 J-2.966 E.15234
G1 X171.813 Y162.809 E.03149
G1 X171.813 Y161.755 E.03494
G3 X171.813 Y158.069 I3.151 J-1.843 E.12817
G1 X171.813 Y154.385 E.1222
; COOLING_NODE: 0
M204 S250
G1 X171.421 Y155.224 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2257
M204 S5000
G2 X169.983 Y156.833 I4.911 J5.837 E.06651
G2 X169.101 Y159.909 I4.976 J3.092 E.09961
G1 X169.101 Y167.701 E.23941
G1 X167.343 Y167.701 E.05401
G1 X167.344 Y159.997 E.23671
G3 X174.997 Y152.344 I7.801 J.148 E.36749
G1 X182.701 Y152.343 E.23672
G1 X182.701 Y154.101 E.05401
G1 X178.401 Y154.101 E.13213
G1 X178.401 Y157.973 E.11899
G3 X178.401 Y161.848 I-3.509 J1.938 E.12427
G1 X178.401 Y163.201 E.04156
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X177.172 Y163.201 E.03775
G3 X172.649 Y163.201 I-2.261 J-3.324 E.14759
G1 X171.421 Y163.201 E.03776
G1 X171.421 Y161.848 E.04156
G3 X171.421 Y157.974 I3.507 J-1.937 E.12425
G1 X171.421 Y155.284 E.08265
M204 S10000
G1 X170.75 Y154.721 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.526083
G1 F2266
M204 S8000
G2 X168.538 Y157.974 I4.379 J5.356 E.15703
; LINE_WIDTH: 0.574313
G1 X168.533 Y157.992 E.00081
G2 X168.23 Y159.718 I6.566 J2.041 E.0761
; LINE_WIDTH: 0.608518
G1 X168.222 Y167.105 E.34048
; WIPE_START
G1 F6364.953
G1 X168.224 Y165.105 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X173.042 Y162.744 Z7.6 F60000
G1 Z7.2
G1 E.8 F1800
; LINE_WIDTH: 0.422854
G1 F2266
M204 S8000
G1 X173.312 Y162.77 E.00842
; LINE_WIDTH: 0.460122
G1 X173.583 Y162.796 E.00925
; LINE_WIDTH: 0.48128
G2 X175.884 Y162.932 I1.325 J-2.89 E.08424
G1 X176.258 Y162.784 E.01438
M204 S10000
G1 X176.265 Y162.753 F60000
; LINE_WIDTH: 0.406111
G1 F2266
M204 S8000
G1 X176.272 Y162.722 E.00094
; LINE_WIDTH: 0.356191
G1 X176.279 Y162.691 E.00081
; LINE_WIDTH: 0.30627
G1 X176.286 Y162.661 E.00068
; LINE_WIDTH: 0.256349
G1 X176.293 Y162.63 E.00055
; LINE_WIDTH: 0.210841
G1 X176.319 Y162.593 E.00061
; LINE_WIDTH: 0.177
G1 X176.343 Y162.563 E.00042
; LINE_WIDTH: 0.148522
G1 X176.417 Y162.508 E.0008
; LINE_WIDTH: 0.11618
G1 X176.583 Y162.376 E.00127
M204 S10000
G1 X176.89 Y162.674 F60000
; LINE_WIDTH: 0.395626
G1 F2266
M204 S8000
G1 X176.348 Y162.783 E.0159
; LINE_WIDTH: 0.447007
G1 X176.258 Y162.784 E.00295
G1 X176.265 Y162.753 E.00105
M204 S10000
G1 X177.586 Y161.644 F60000
; LINE_WIDTH: 0.480917
G1 F2266
M204 S8000
G2 X177.937 Y158.952 I-2.742 J-1.726 E.09998
; LINE_WIDTH: 0.455397
G1 X177.95 Y158.907 E.00158
; LINE_WIDTH: 0.407185
G1 X177.951 Y158.842 E.00192
; LINE_WIDTH: 0.360595
G1 X177.952 Y158.777 E.00167
; LINE_WIDTH: 0.329291
G1 X177.854 Y158.211 E.01342
; WIPE_START
G1 F12571.124
G1 X177.952 Y158.777 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.048 Y155.178 Z7.6 F60000
G1 Z7.2
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.504986
G1 F2266
M204 S8000
G1 X175.735 Y155.223 E.02594
G1 X175.998 Y155.281 E.01014
G1 X175.998 Y154.747 E.02012
G2 X174.494 Y154.764 I-.636 J10.432 E.0567
; LINE_WIDTH: 0.467389
G2 X173.792 Y154.89 I3.076 J19.099 E.02465
G1 X173.792 Y155.325 E.01504
G1 X174.528 Y155.194 E.02584
G1 X174.988 Y155.18 E.01591
M204 S10000
G1 X176.425 Y155.856 F60000
; LINE_WIDTH: 0.41999
G1 F2266
M204 S8000
G1 X176.425 Y154.319 E.04722
G1 X175.045 Y154.32 E.04241
G1 X174.427 Y154.363 E.01902
G1 X173.625 Y154.519 E.02512
G1 X173.396 Y154.595 E.00741
G1 X173.396 Y155.859 E.03884
G1 X174.141 Y155.648 E.0238
G1 X174.786 Y155.577 E.01991
G1 X175.697 Y155.649 E.02809
G1 X176.368 Y155.84 E.02142
M204 S10000
G1 X176.802 Y156.46 F60000
G1 F2266
M204 S8000
G1 X176.802 Y153.942 E.07735
G1 X175.032 Y153.943 E.0544
G1 X174.378 Y153.988 E.02014
G1 X173.529 Y154.153 E.02657
G1 X173.019 Y154.322 E.01652
G1 X173.019 Y156.435 E.06491
G1 X173.661 Y156.154 E.02154
G3 X174.819 Y155.953 I1.31 J4.091 E.03622
G1 X175.664 Y156.025 E.02604
G1 X176.393 Y156.24 E.02338
G1 X176.75 Y156.431 E.01242
; WIPE_START
G1 F9547.299
G1 X176.393 Y156.24 E-.1536
G1 X175.664 Y156.025 E-.28913
G1 X174.832 Y155.954 E-.31727
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X177.805 Y153.222 Z7.6 F60000
G1 Z7.2
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.608974
G1 F2266
M204 S8000
G1 X182.105 Y153.222 E.19834
; WIPE_START
G1 F6359.817
G1 X180.105 Y153.222 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.488 Y153.713 Z7.6 F60000
G1 X172.016 Y153.743 Z7.6
G1 Z7.2
G1 E.8 F1800
; LINE_WIDTH: 0.248122
G1 F2266
M204 S8000
G1 X171.913 Y153.814 E.00209
; LINE_WIDTH: 0.264302
G1 X171.812 Y153.887 E.00224
; LINE_WIDTH: 0.296468
G1 X171.711 Y153.959 E.00257
; LINE_WIDTH: 0.326447
G1 X171.611 Y154.032 E.00286
; LINE_WIDTH: 0.354205
G1 X171.511 Y154.106 E.00314
; LINE_WIDTH: 0.391418
G1 X171.316 Y154.255 E.00699
; LINE_WIDTH: 0.433723
G1 X171.124 Y154.408 E.00781
; LINE_WIDTH: 0.479811
G2 X170.75 Y154.721 I8.778 J10.863 E.01736
; WIPE_START
G1 F8240.047
G1 X171.124 Y154.408 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.236 Y158.178 Z7.6 F60000
G1 Z7.2
G1 E.8 F1800
; LINE_WIDTH: 0.481411
G1 F2266
M204 S8000
G1 X172.064 Y158.506 E.01324
G2 X171.884 Y160.869 I2.859 J1.406 E.08678
; LINE_WIDTH: 0.464658
G1 X171.904 Y160.876 E.00071
; LINE_WIDTH: 0.431389
G1 X171.923 Y160.883 E.00065
; LINE_WIDTH: 0.400045
G1 X171.941 Y160.89 E.00056
; LINE_WIDTH: 0.36241
G1 X171.975 Y160.916 E.00111
; LINE_WIDTH: 0.316544
G1 X172.009 Y160.942 E.00095
; LINE_WIDTH: 0.270678
G1 X172.043 Y160.968 E.00079
; LINE_WIDTH: 0.224811
G1 X172.078 Y160.994 E.00063
; LINE_WIDTH: 0.185218
G1 X172.128 Y161.081 E.00117
; LINE_WIDTH: 0.146574
G1 X172.217 Y161.223 E.00141
; LINE_WIDTH: 0.110767
G1 X172.305 Y161.357 E.00088
M204 S10000
G1 X171.964 Y161.603 F60000
; LINE_WIDTH: 0.329728
G1 F2266
M204 S8000
G1 X171.869 Y161.044 E.01326
; LINE_WIDTH: 0.361057
G1 X171.874 Y160.986 E.00152
; LINE_WIDTH: 0.409148
G1 X171.879 Y160.928 E.00175
; LINE_WIDTH: 0.45724
G1 X171.884 Y160.869 E.00198
; CHANGE_LAYER
; Z_HEIGHT: 7.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F8688.946
G1 X171.879 Y160.928 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 37/58
; update layer progress
M73 L37
M991 S0 P36 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 2
M204 S10000
G17
G3 Z7.6 I-.644 J1.032 P1  F60000
G1 X172.577 Y161.363 Z7.6
G1 Z7.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2273
M204 S8000
G1 X172.485 Y161.205 E.00604
G3 X174.766 Y157.162 I2.428 J-1.295 E.18328
G1 X174.907 Y157.158 E.00465
G3 X172.631 Y161.449 I.006 J2.752 E.37619
G1 X172.609 Y161.413 E.00138
; COOLING_NODE: 2
M204 S250
G1 X172.912 Y161.161 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2273
M204 S5000
G1 X172.831 Y161.024 E.00488
G3 X174.787 Y157.554 I2.08 J-1.114 E.14575
M73 P76 R3
G1 X174.904 Y157.551 E.00359
G3 X172.955 Y161.23 I.007 J2.36 E.29884
G1 X172.943 Y161.212 E.00066
; COOLING_NODE: 2
; WIPE_START
G1 F9547.055
M204 S8000
G1 X172.831 Y161.024 E-.08312
G1 X172.654 Y160.6 E-.17464
G1 X172.595 Y160.368 E-.09112
G1 X172.554 Y160.034 E-.12786
G1 X172.574 Y159.582 E-.17179
G1 X172.621 Y159.34 E-.09374
G1 X172.634 Y159.295 E-.01773
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.627 Y157.16 Z7.8 F60000
G1 Z7.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2273
M204 S8000
G1 X172.627 Y154.048 E.10325
G3 X175.019 Y153.552 I2.516 J6.118 E.08152
G1 X177.195 Y153.551 E.07215
G1 X177.195 Y157.167 E.11993
G2 X172.674 Y157.123 I-2.288 J2.805 E.16197
; COOLING_NODE: 2
; WIPE_START
G1 F8843.478
G1 X172.643 Y155.123 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.746 Y153.569 Z7.8 F60000
G1 Z7.4
G1 E.8 F1800
G1 F2273
M204 S8000
G1 X172.859 Y153.528 E.004
G3 X175.012 Y153.145 I2.319 J6.793 E.07283
G1 X177.602 Y153.144 E.08589
G1 X177.602 Y157.957 E.15965
G1 X177.438 Y158.014 E.00575
G2 X172.384 Y158.014 I-2.527 J1.915 E.19402
G1 X172.22 Y157.957 E.00575
G1 X172.22 Y153.781 E.13854
G1 X172.69 Y153.592 E.01681
; COOLING_NODE: 2
; WIPE_START
G1 F8843.478
G1 X172.859 Y153.528 E-.06861
G1 X173.562 Y153.323 E-.27821
G1 X174.282 Y153.196 E-.27778
G1 X174.637 Y153.171 E-.1354
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X176.988 Y160.432 Z7.8 F60000
G1 X177.434 Y161.809 Z7.8
G1 Z7.4
G1 E.8 F1800
G1 F2273
M204 S8000
G1 X177.602 Y161.864 E.00587
G1 X177.602 Y162.402 E.01784
G1 X176.874 Y162.402 E.02413
G2 X177.396 Y161.856 I-2.966 J-3.358 E.02509
; COOLING_NODE: 2
; WIPE_START
G1 F8843.478
G1 X177.602 Y161.864 E-.07808
G1 X177.602 Y162.402 E-.20436
G1 X176.874 Y162.402 E-.27637
G1 X177.252 Y162.031 E-.20119
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.384 Y161.807 Z7.8 F60000
G1 Z7.4
G1 E.8 F1800
G1 F2273
M204 S8000
G1 X172.496 Y161.948 E.00597
G2 X172.957 Y162.402 I2.76 J-2.347 E.02148
G1 X172.22 Y162.402 E.02445
G1 X172.22 Y161.864 E.01782
G1 X172.327 Y161.827 E.00376
; COOLING_NODE: 2
; WIPE_START
G1 F8843.478
G1 X172.496 Y161.948 E-.07894
G1 X172.677 Y162.146 E-.1021
G1 X172.957 Y162.402 E-.14393
G1 X172.22 Y162.402 E-.28012
G1 X172.22 Y161.994 E-.15491
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.815 Y154.372 Z7.8 F60000
G1 X171.813 Y154.325 Z7.8
G1 Z7.4
G1 E.8 F1800
G1 F2273
M204 S8000
G1 X170.603 Y155.449 E.05478
G2 X168.709 Y159.906 I4.319 J4.466 E.165
G1 X168.709 Y167.309 E.24557
G1 X167.736 Y167.309 E.03225
G1 X167.738 Y160.006 E.24224
G3 X175.005 Y152.738 I7.408 J.139 E.37679
G1 X182.309 Y152.736 E.24227
G1 X182.309 Y153.709 E.03225
G1 X178.009 Y153.709 E.14264
G1 X178.009 Y158.066 E.14456
G3 X178.009 Y161.755 I-3.168 J1.844 E.12821
G1 X178.009 Y162.809 E.03495
G1 X177.06 Y162.809 E.03147
G3 X172.762 Y162.809 I-2.149 J-2.967 E.15235
G1 X171.813 Y162.809 E.03149
G1 X171.813 Y161.756 E.03493
G3 X171.813 Y158.069 I3.152 J-1.843 E.12819
G1 X171.813 Y154.385 E.1222
; COOLING_NODE: 0
M204 S250
G1 X171.421 Y155.224 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2249
M204 S5000
G2 X169.983 Y156.833 I4.912 J5.837 E.06652
G2 X169.101 Y159.909 I4.977 J3.092 E.09959
G1 X169.101 Y167.701 E.23942
G1 X167.344 Y167.701 E.05397
G1 X167.345 Y159.998 E.23667
G3 X174.998 Y152.345 I7.801 J.148 E.36748
G1 X182.701 Y152.344 E.23668
G1 X182.701 Y154.101 E.05397
G1 X178.401 Y154.101 E.13213
G1 X178.401 Y157.973 E.11899
G3 X178.401 Y161.848 I-3.523 J1.938 E.12424
G1 X178.401 Y163.201 E.04156
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X177.172 Y163.201 E.03775
G3 X172.649 Y163.201 I-2.261 J-3.325 E.1476
G1 X171.421 Y163.201 E.03776
G1 X171.421 Y161.848 E.04155
G3 X171.421 Y157.974 I3.508 J-1.937 E.12425
G1 X171.421 Y155.284 E.08265
M204 S10000
G1 X170.936 Y154.563 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.514891
G1 F2273
M204 S8000
G2 X169.093 Y156.694 I4.457 J5.718 E.10905
; LINE_WIDTH: 0.54739
G2 X168.321 Y158.877 I5.964 J3.339 E.09565
; LINE_WIDTH: 0.604991
G2 X168.223 Y160.016 I7.173 J1.189 E.05244
G1 X168.223 Y167.105 E.32468
; WIPE_START
G1 F6404.894
G1 X168.223 Y165.105 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.958 Y162.691 Z7.8 F60000
G1 Z7.4
G1 E.8 F1800
; LINE_WIDTH: 0.419763
G1 F2273
M204 S8000
G1 X173.556 Y162.795 E.01865
; LINE_WIDTH: 0.469007
G1 X173.59 Y162.796 E.00118
; LINE_WIDTH: 0.481086
G2 X176.152 Y162.833 I1.322 J-2.888 E.09416
G1 X176.245 Y162.79 E.00366
M204 S10000
G1 X176.255 Y162.759 F60000
; LINE_WIDTH: 0.412202
G1 F2273
M204 S8000
G1 X176.266 Y162.728 E.00097
; LINE_WIDTH: 0.36554
G1 X176.276 Y162.698 E.00085
; LINE_WIDTH: 0.318878
G1 X176.286 Y162.667 E.00073
; LINE_WIDTH: 0.272216
G1 X176.296 Y162.636 E.0006
; LINE_WIDTH: 0.225554
G1 X176.306 Y162.606 E.00048
; LINE_WIDTH: 0.178891
G1 X176.317 Y162.575 E.00036
; LINE_WIDTH: 0.13351
G1 X176.45 Y162.475 E.00123
; LINE_WIDTH: 0.104949
G1 X176.538 Y162.407 E.00056
M204 S10000
G1 X176.349 Y162.785 F60000
; LINE_WIDTH: 0.399084
G1 F2273
M204 S8000
G1 X176.93 Y162.65 E.0173
M204 S10000
G1 X176.349 Y162.785 F60000
; LINE_WIDTH: 0.446536
G1 F2273
M204 S8000
G1 X176.245 Y162.79 E.00342
G1 X176.255 Y162.759 E.00106
M204 S10000
G1 X177.584 Y161.644 F60000
; LINE_WIDTH: 0.481231
G1 F2273
M204 S8000
G2 X177.722 Y158.435 I-2.736 J-1.724 E.12005
G1 X177.585 Y158.179 E.01038
; WIPE_START
G1 F8213.352
G1 X177.722 Y158.435 E-.1104
G1 X177.895 Y158.83 E-.16403
G1 X178.025 Y159.297 E-.18404
G1 X178.076 Y159.672 E-.14397
G1 X178.079 Y160.087 E-.15757
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.998 Y155.279 Z7.8 F60000
G1 Z7.4
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.501124
G1 F2273
M204 S8000
G1 X175.998 Y154.748 E.01985
G2 X174.495 Y154.765 I-.639 J9.67 E.05621
; LINE_WIDTH: 0.467251
G2 X173.792 Y154.891 I2.841 J17.898 E.02469
G1 X173.792 Y155.325 E.015
G1 X174.527 Y155.197 E.0258
G1 X175.047 Y155.173 E.018
; LINE_WIDTH: 0.506872
G1 X175.737 Y155.224 E.02615
G1 X175.94 Y155.267 E.00785
M204 S10000
G1 X176.425 Y155.853 F60000
; LINE_WIDTH: 0.41999
G1 F2273
M204 S8000
G1 X176.425 Y154.321 E.0471
G1 X175.046 Y154.321 E.04237
G1 X174.428 Y154.364 E.01903
G1 X173.626 Y154.52 E.02512
G1 X173.396 Y154.596 E.00745
G1 X173.396 Y155.858 E.03876
G1 X174.14 Y155.648 E.02376
G1 X174.864 Y155.576 E.02234
G1 X175.695 Y155.648 E.02563
G1 X176.369 Y155.832 E.02147
M204 S10000
G1 X176.802 Y156.435 F60000
G1 F2273
M204 S8000
G1 X176.802 Y153.943 E.07655
G1 X175.033 Y153.944 E.05437
G1 X174.379 Y153.989 E.02014
G1 X173.53 Y154.155 E.02657
G1 X173.019 Y154.324 E.01655
G1 X173.019 Y156.434 E.06484
G1 X173.663 Y156.154 E.0216
G1 X174.229 Y156.014 E.01789
G1 X174.894 Y155.952 E.02052
G1 X175.659 Y156.024 E.0236
G3 X176.75 Y156.406 I-.729 J3.835 E.03566
; WIPE_START
G1 F9547.299
G1 X176.189 Y156.164 E-.2322
G1 X175.659 Y156.024 E-.20844
G1 X174.894 Y155.952 E-.29188
G1 X174.822 Y155.959 E-.02748
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X177.805 Y153.223 Z7.8 F60000
G1 Z7.4
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.607744
G1 F2273
M204 S8000
G1 X182.105 Y153.223 E.19791
; WIPE_START
G1 F6373.667
G1 X180.105 Y153.223 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.489 Y153.716 Z7.8 F60000
G1 X172.016 Y153.747 Z7.8
G1 Z7.4
G1 E.8 F1800
; LINE_WIDTH: 0.246232
G1 F2273
M204 S8000
G1 X171.914 Y153.815 E.00203
; LINE_WIDTH: 0.262418
G1 X171.813 Y153.887 E.00223
; LINE_WIDTH: 0.294623
G1 X171.711 Y153.959 E.00255
; LINE_WIDTH: 0.324621
G1 X171.612 Y154.033 E.00284
; LINE_WIDTH: 0.352394
G1 X171.512 Y154.106 E.00312
; LINE_WIDTH: 0.389701
G1 X171.316 Y154.256 E.00698
; LINE_WIDTH: 0.43199
G1 X171.125 Y154.408 E.00774
; LINE_WIDTH: 0.465513
G1 X170.936 Y154.563 E.00841
; WIPE_START
G1 F8518.838
G1 X171.125 Y154.408 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.238 Y158.179 Z7.8 F60000
G1 Z7.4
G1 E.8 F1800
; LINE_WIDTH: 0.481386
G1 F2273
M204 S8000
G1 X172.099 Y158.436 E.01045
G2 X172.237 Y161.643 I2.862 J1.483 E.12003
; CHANGE_LAYER
; Z_HEIGHT: 7.6
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F8210.449
G1 X171.996 Y161.167 E-.2027
G1 X171.876 Y160.844 E-.13092
G1 X171.789 Y160.488 E-.13906
G1 X171.739 Y160.05 E-.16765
M73 P77 R3
G1 X171.746 Y159.735 E-.11967
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 38/58
; update layer progress
M73 L38
M991 S0 P37 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 2
M204 S10000
G17
G3 Z7.8 I-1.084 J.554 P1  F60000
G1 X172.585 Y161.377 Z7.8
G1 Z7.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2291
M204 S8000
G1 X172.478 Y161.199 E.00691
G3 X174.63 Y157.173 I2.432 J-1.288 E.17859
G1 X174.879 Y157.159 E.00826
G3 X172.629 Y161.45 I.03 J2.752 E.37696
G1 X172.616 Y161.429 E.00082
; COOLING_NODE: 2
M204 S250
G1 X172.921 Y161.175 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2281
M204 S5000
G1 X172.826 Y161.017 E.00567
G3 X174.667 Y157.563 I2.084 J-1.107 E.14182
G1 X174.887 Y157.551 E.00679
G3 X172.954 Y161.231 I.022 J2.36 E.29931
G1 X172.952 Y161.227 E.00013
; COOLING_NODE: 2
; WIPE_START
G1 F9547.055
M204 S8000
G1 X172.826 Y161.017 E-.09296
G1 X172.653 Y160.599 E-.17214
G1 X172.58 Y160.279 E-.12442
G1 X172.554 Y160.034 E-.09386
G1 X172.574 Y159.582 E-.17172
G1 X172.638 Y159.314 E-.10488
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.627 Y157.16 Z8 F60000
G1 Z7.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2291
M204 S8000
G1 X172.627 Y154.049 E.10319
G3 X175.021 Y153.553 I2.517 J6.118 E.08157
G1 X177.195 Y153.553 E.07211
G1 X177.195 Y157.155 E.1195
G2 X172.674 Y157.123 I-2.281 J2.806 E.16201
; COOLING_NODE: 2
; WIPE_START
G1 F8843.478
G1 X172.643 Y155.123 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.746 Y153.571 Z8 F60000
G1 Z7.6
G1 E.8 F1800
G1 F2291
M204 S8000
G1 X172.86 Y153.529 E.00402
G3 X175.014 Y153.146 I2.319 J6.793 E.07284
G1 X177.602 Y153.145 E.08585
G1 X177.602 Y157.957 E.15961
G1 X177.438 Y158.014 E.00575
G2 X172.384 Y158.014 I-2.527 J1.907 E.19416
G1 X172.22 Y157.957 E.00575
G1 X172.22 Y153.782 E.13848
G1 X172.691 Y153.593 E.01684
; COOLING_NODE: 2
; WIPE_START
G1 F8843.478
G1 X172.86 Y153.529 E-.06882
G1 X173.563 Y153.324 E-.27829
G1 X174.283 Y153.197 E-.27789
G1 X174.638 Y153.172 E-.135
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X176.989 Y160.433 Z8 F60000
G1 X177.434 Y161.809 Z8
G1 Z7.6
G1 E.8 F1800
G1 F2291
M204 S8000
G1 X177.602 Y161.864 E.00586
G1 X177.602 Y162.402 E.01784
G1 X176.863 Y162.402 E.0245
G2 X177.397 Y161.856 I-2.554 J-3.029 E.02536
; COOLING_NODE: 2
; WIPE_START
G1 F8843.478
G1 X177.602 Y161.864 E-.07795
G1 X177.602 Y162.402 E-.20435
G1 X176.863 Y162.402 E-.28062
G1 X177.137 Y162.153 E-.14054
G1 X177.235 Y162.041 E-.05654
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.384 Y161.808 Z8 F60000
G1 Z7.6
G1 E.8 F1800
G1 F2291
M204 S8000
G1 X172.481 Y161.931 E.00521
G2 X172.956 Y162.402 I2.788 J-2.336 E.02221
G1 X172.22 Y162.402 E.02442
G1 X172.22 Y161.865 E.01781
G1 X172.327 Y161.827 E.00377
; COOLING_NODE: 2
; WIPE_START
G1 F8843.478
G1 X172.481 Y161.931 E-.07051
G1 X172.674 Y162.144 E-.10921
G1 X172.956 Y162.402 E-.14511
G1 X172.22 Y162.402 E-.27971
G1 X172.22 Y161.992 E-.15547
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.815 Y154.371 Z8 F60000
G1 X171.813 Y154.325 Z8
G1 Z7.6
G1 E.8 F1800
G1 F2291
M204 S8000
G1 X170.602 Y155.449 E.05479
G2 X168.709 Y159.906 I4.331 J4.471 E.16497
G1 X168.709 Y167.309 E.24557
G1 X167.738 Y167.309 E.03221
G1 X167.739 Y160.008 E.24218
G3 X175.006 Y152.739 I7.415 J.146 E.37671
G1 X182.309 Y152.738 E.24223
G1 X182.309 Y153.709 E.03221
G1 X178.009 Y153.709 E.14264
G1 X178.009 Y158.064 E.14447
G3 X178.009 Y161.755 I-3.161 J1.846 E.12834
G1 X178.009 Y162.809 E.03495
G1 X177.059 Y162.809 E.03149
G3 X172.762 Y162.809 I-2.149 J-2.969 E.15231
G1 X171.813 Y162.809 E.03149
G1 X171.813 Y161.756 E.03492
G3 X171.813 Y158.069 I3.174 J-1.843 E.12813
G1 X171.813 Y154.385 E.1222
; COOLING_NODE: 0
M204 S250
G1 X171.421 Y155.224 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2237
M204 S5000
G2 X169.933 Y156.914 I4.841 J5.762 E.06943
G2 X169.101 Y159.909 I5 J3.003 E.09669
G1 X169.101 Y167.701 E.23941
G1 X167.345 Y167.701 E.05393
G1 X167.347 Y160 E.23663
G3 X174.999 Y152.347 I7.808 J.154 E.36741
G1 X182.701 Y152.345 E.23664
G1 X182.701 Y154.101 E.05393
G1 X178.401 Y154.101 E.13213
G1 X178.401 Y157.972 E.11896
G3 X178.401 Y161.848 I-3.511 J1.938 E.1243
G1 X178.401 Y163.201 E.04156
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X177.172 Y163.201 E.03776
G3 X172.649 Y163.201 I-2.261 J-3.328 E.14757
G1 X171.421 Y163.201 E.03776
G1 X171.421 Y161.849 E.04155
G3 X171.421 Y157.974 I3.533 J-1.937 E.12419
G1 X171.421 Y155.284 E.08265
M204 S10000
G1 X170.751 Y154.722 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.523451
G1 F2291
M204 S8000
G2 X168.513 Y158.065 I4.38 J5.354 E.15987
; LINE_WIDTH: 0.572176
G1 X168.51 Y158.076 E.00048
G2 X168.232 Y159.702 I6.549 J1.955 E.07131
; LINE_WIDTH: 0.606024
G1 X168.223 Y167.105 E.33971
; WIPE_START
G1 F6393.138
G1 X168.226 Y165.105 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.965 Y162.695 Z8 F60000
G1 Z7.6
G1 E.8 F1800
; LINE_WIDTH: 0.419255
G1 F2291
M204 S8000
G1 X173.527 Y162.795 E.0175
; LINE_WIDTH: 0.457814
G1 X173.589 Y162.796 E.0021
; LINE_WIDTH: 0.481165
G2 X176.152 Y162.832 I1.323 J-2.876 E.09427
G1 X176.229 Y162.797 E.00302
M204 S10000
G1 X176.24 Y162.765 F60000
; LINE_WIDTH: 0.407605
G1 F2291
M204 S8000
G1 X176.251 Y162.732 E.00101
; LINE_WIDTH: 0.358379
G1 X176.261 Y162.7 E.00088
; LINE_WIDTH: 0.309153
G1 X176.272 Y162.668 E.00074
; LINE_WIDTH: 0.259928
G1 X176.283 Y162.635 E.0006
; LINE_WIDTH: 0.210702
G1 X176.293 Y162.603 E.00047
; LINE_WIDTH: 0.161476
G1 X176.304 Y162.57 E.00033
; LINE_WIDTH: 0.11695
G1 X176.469 Y162.451 E.00123
M204 S10000
G1 X176.24 Y162.765 F60000
; LINE_WIDTH: 0.444938
G1 F2291
M204 S8000
G1 X176.229 Y162.797 E.00112
G1 X176.774 Y162.747 E.01793
; WIPE_START
G1 F8954.829
G1 X176.229 Y162.797 E-.71544
G1 X176.24 Y162.765 E-.04456
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X177.367 Y161.572 Z8 F60000
G1 Z7.6
G1 E.8 F1800
; LINE_WIDTH: 0.479285
G1 F2291
M204 S8000
G1 X177.684 Y161.45 E.01207
G2 X177.79 Y158.574 I-2.765 J-1.542 E.1062
G1 X177.586 Y158.178 E.01585
M204 S10000
G1 X177.398 Y157.592 F60000
; LINE_WIDTH: 0.105857
G1 F2291
M204 S8000
G1 X177.289 Y157.498 E.00074
; WIPE_START
G1 F15000
G1 X177.398 Y157.592 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.998 Y155.284 Z8 F60000
G1 Z7.6
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.500948
G1 F2291
M204 S8000
G1 X175.998 Y154.749 E.01997
G2 X174.496 Y154.766 I-.642 J9.842 E.05613
; LINE_WIDTH: 0.466206
G2 X173.791 Y154.892 I2.959 J18.505 E.02469
G1 X173.791 Y155.322 E.01482
G1 X174.529 Y155.195 E.02583
G1 X175.056 Y155.175 E.01816
; LINE_WIDTH: 0.505289
G1 X175.647 Y155.21 E.02233
G1 X175.94 Y155.272 E.01126
M204 S10000
G1 X176.425 Y155.865 F60000
; LINE_WIDTH: 0.41999
G1 F2291
M204 S8000
G1 X176.425 Y154.322 E.04742
G1 X175.048 Y154.322 E.04233
G1 X174.43 Y154.365 E.01902
G1 X173.627 Y154.521 E.02512
G1 X173.396 Y154.598 E.00749
G1 X173.396 Y155.864 E.0389
G3 X174.81 Y155.577 I1.541 J3.959 E.04456
G1 X175.471 Y155.612 E.02033
G1 X176.119 Y155.748 E.02034
G1 X176.369 Y155.844 E.00824
M204 S10000
G1 X176.771 Y156.416 F60000
G1 F2291
M204 S8000
G1 X176.802 Y156.431 E.00106
G2 X176.802 Y153.945 I-1600.06 J-1.803 E.07641
G1 X175.034 Y153.945 E.05433
G1 X174.381 Y153.991 E.02014
G1 X173.532 Y154.156 E.02657
G1 X173.019 Y154.326 E.0166
G1 X173.019 Y156.435 E.06481
G1 X173.754 Y156.125 E.0245
G3 X176.715 Y156.393 I1.139 J3.908 E.09353
; WIPE_START
G1 F9547.299
G1 X176.038 Y156.116 E-.27804
G1 X175.447 Y155.988 E-.22972
G1 X174.843 Y155.952 E-.23016
G1 X174.785 Y155.957 E-.02208
; WIPE_END
M73 P78 R3
G1 E-.04 F1800
M204 S10000
G1 X177.805 Y153.223 Z8 F60000
G1 Z7.6
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.606514
G1 F2291
M204 S8000
G1 X182.105 Y153.223 E.19748
; WIPE_START
G1 F6387.579
G1 X180.105 Y153.223 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.489 Y153.716 Z8 F60000
G1 X172.016 Y153.746 Z8
G1 Z7.6
G1 E.8 F1800
; LINE_WIDTH: 0.244508
G1 F2291
M204 S8000
G1 X171.915 Y153.815 E.00202
; LINE_WIDTH: 0.260737
G1 X171.813 Y153.887 E.00221
; LINE_WIDTH: 0.292946
G1 X171.712 Y153.96 E.00253
; LINE_WIDTH: 0.322932
G1 X171.613 Y154.033 E.00282
; LINE_WIDTH: 0.350671
G1 X171.513 Y154.107 E.0031
; LINE_WIDTH: 0.387913
G1 X171.317 Y154.256 E.00693
; LINE_WIDTH: 0.430261
G1 X171.125 Y154.409 E.00774
; LINE_WIDTH: 0.476329
G2 X170.751 Y154.722 I8.806 J10.897 E.01721
; WIPE_START
G1 F8306.241
G1 X171.125 Y154.409 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.238 Y158.179 Z8 F60000
G1 Z7.6
G1 E.8 F1800
; LINE_WIDTH: 0.481116
G1 F2291
M204 S8000
G1 X171.966 Y158.727 E.02184
G2 X172.236 Y161.643 I2.99 J1.193 E.10857
; CHANGE_LAYER
; Z_HEIGHT: 7.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F8215.515
G1 X172.034 Y161.25 E-.16803
G1 X171.892 Y160.893 E-.14592
G1 X171.806 Y160.572 E-.12638
G1 X171.753 Y160.236 E-.12921
G1 X171.736 Y159.894 E-.13022
G1 X171.748 Y159.736 E-.06023
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 39/58
; update layer progress
M73 L39
M991 S0 P38 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 2
M204 S10000
G17
G3 Z8 I-1.083 J.555 P1  F60000
G1 X172.609 Y161.416 Z8
G1 Z7.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2282
M204 S8000
G1 X172.576 Y161.369 E.0019
G3 X174.629 Y157.173 I2.333 J-1.459 E.18505
G1 X174.867 Y157.159 E.00791
G3 X172.742 Y161.605 I.043 J2.752 E.37103
G1 X172.644 Y161.465 E.00567
; COOLING_NODE: 2
M204 S250
G1 X172.93 Y161.191 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2280
M204 S5000
G1 X172.909 Y161.161 E.00113
G3 X174.666 Y157.563 I2.001 J-1.251 E.14688
G1 X174.876 Y157.551 E.00647
G3 X173.051 Y161.363 I.034 J2.359 E.29461
G1 X172.965 Y161.24 E.00462
; COOLING_NODE: 2
; WIPE_START
G1 F9547.055
M204 S8000
G1 X172.909 Y161.161 E-.03675
G1 X172.789 Y160.945 E-.09391
G1 X172.653 Y160.599 E-.14123
G1 X172.602 Y160.401 E-.07774
G1 X172.556 Y160.076 E-.12484
G1 X172.568 Y159.622 E-.17225
G1 X172.633 Y159.331 E-.11328
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.627 Y157.165 Z8.2 F60000
G1 Z7.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2282
M204 S8000
G1 X172.627 Y154.051 E.1033
G3 X175.022 Y153.554 I2.519 J6.119 E.08161
G1 X177.195 Y153.554 E.07207
G1 X177.195 Y157.163 E.11972
G2 X172.674 Y157.128 I-2.282 J2.807 E.16198
; COOLING_NODE: 2
; WIPE_START
G1 F8843.478
G1 X172.643 Y155.128 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.747 Y153.572 Z8.2 F60000
G1 Z7.8
G1 E.8 F1800
G1 F2282
M204 S8000
G1 X172.862 Y153.53 E.00404
G3 X175.015 Y153.147 I2.319 J6.793 E.07283
G1 X177.602 Y153.147 E.08581
G1 X177.602 Y158.21 E.16795
G2 X176.094 Y156.981 I-2.931 J2.056 E.06534
G2 X172.526 Y157.838 I-1.18 J2.944 E.12981
G1 X172.22 Y158.21 E.01597
G1 X172.22 Y153.784 E.1468
G1 X172.692 Y153.595 E.01686
; COOLING_NODE: 2
; WIPE_START
G1 F8843.478
G1 X172.862 Y153.53 E-.06913
G1 X173.564 Y153.325 E-.27815
G1 X174.285 Y153.198 E-.27796
G1 X174.638 Y153.173 E-.13477
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X176.991 Y160.434 Z8.2 F60000
G1 X177.436 Y161.808 Z8.2
G1 Z7.8
G1 E.8 F1800
G1 F2282
M204 S8000
G1 X177.602 Y161.864 E.0058
G1 X177.602 Y162.402 E.01782
G1 X176.872 Y162.402 E.02419
G2 X177.399 Y161.855 I-2.67 J-3.1 E.02521
; COOLING_NODE: 2
; WIPE_START
G1 F8843.478
G1 X177.602 Y161.864 E-.07714
G1 X177.602 Y162.402 E-.20415
G1 X176.872 Y162.402 E-.27714
G1 X177.184 Y162.106 E-.16321
G1 X177.25 Y162.029 E-.03837
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.303 Y161.712 Z8.2 F60000
G1 Z7.8
G1 E.8 F1800
G1 F2282
M204 S8000
G1 X172.532 Y161.99 E.01195
G2 X172.954 Y162.402 I3.154 J-2.815 E.01957
G1 X172.22 Y162.402 E.02435
G1 X172.22 Y161.612 E.0262
G1 X172.265 Y161.666 E.00233
; COOLING_NODE: 2
; WIPE_START
G1 F8843.478
G1 X172.532 Y161.99 E-.15965
G1 X172.954 Y162.402 E-.22406
G1 X172.22 Y162.402 E-.27899
G1 X172.22 Y162.146 E-.09731
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.823 Y154.523 Z8.2 F60000
G1 X171.813 Y154.325 Z8.2
G1 Z7.8
G1 E.8 F1800
G1 F2282
M204 S8000
G1 X170.603 Y155.449 E.05478
G2 X168.709 Y159.906 I4.319 J4.466 E.165
G1 X168.709 Y167.309 E.24557
G1 X167.739 Y167.309 E.03217
G1 X167.74 Y160.009 E.24213
G3 X175.008 Y152.74 I7.408 J.139 E.37681
G1 X182.309 Y152.739 E.24219
G1 X182.309 Y153.709 E.03217
G1 X178.009 Y153.709 E.14264
G1 X178.009 Y158.066 E.14456
G3 X178.009 Y161.752 I-3.179 J1.843 E.12808
G1 X178.009 Y162.809 E.03504
G1 X177.062 Y162.809 E.0314
G3 X172.762 Y162.809 I-2.15 J-2.971 E.15241
G1 X171.813 Y162.809 E.03149
G1 X171.813 Y161.755 E.03495
G3 X171.813 Y158.069 I3.172 J-1.843 E.1281
G1 X171.813 Y154.385 E.1222
; COOLING_NODE: 0
M204 S250
G1 X171.421 Y155.224 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2218
M204 S5000
G2 X169.983 Y156.833 I4.912 J5.838 E.0665
G2 X169.101 Y159.909 I4.95 J3.084 E.09962
G1 X169.101 Y167.701 E.23941
G1 X167.347 Y167.701 E.0539
G1 X167.348 Y160.001 E.23659
G3 X175.001 Y152.348 I7.801 J.147 E.3675
G1 X182.701 Y152.347 E.23661
G1 X182.701 Y154.101 E.0539
G1 X178.401 Y154.101 E.13213
G1 X178.401 Y157.973 E.11899
G3 X178.401 Y161.847 I-3.54 J1.937 E.12416
G1 X178.401 Y163.201 E.04159
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X177.173 Y163.201 E.03773
G3 X172.649 Y163.201 I-2.262 J-3.327 E.14761
G1 X171.421 Y163.201 E.03776
G1 X171.421 Y161.848 E.04156
G3 X171.421 Y157.974 I3.533 J-1.937 E.12418
G1 X171.421 Y155.284 E.08265
M204 S10000
G1 X170.938 Y154.564 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.462025
G1 F2282
M204 S8000
G1 X171.126 Y154.409 E.00834
; LINE_WIDTH: 0.42845
G1 X171.318 Y154.257 E.00769
; LINE_WIDTH: 0.386157
G1 X171.514 Y154.107 E.0069
; LINE_WIDTH: 0.348915
G1 X171.613 Y154.034 E.00308
; LINE_WIDTH: 0.321181
G1 X171.713 Y153.96 E.0028
; LINE_WIDTH: 0.29113
G1 X171.814 Y153.888 E.00253
; LINE_WIDTH: 0.258778
G1 X171.916 Y153.815 E.0022
; LINE_WIDTH: 0.242586
G1 X172.016 Y153.744 E.002
M204 S10000
G1 X170.938 Y154.564 F60000
; LINE_WIDTH: 0.511426
G1 F2282
M204 S8000
G2 X169.095 Y156.694 I4.451 J5.711 E.10821
; LINE_WIDTH: 0.544156
G1 X168.837 Y157.202 E.02327
G1 X168.61 Y157.766 E.02482
G2 X168.323 Y158.869 I6.805 J2.357 E.04661
; LINE_WIDTH: 0.602466
G2 X168.224 Y160.02 I7.547 J1.23 E.05269
G1 X168.224 Y167.105 E.32307
; WIPE_START
G1 F6433.787
G1 X168.224 Y165.105 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.884 Y158.952 Z8.2 F60000
G1 Z7.8
G1 E.8 F1800
; LINE_WIDTH: 0.457625
G1 F2282
M204 S8000
G1 X171.879 Y158.895 E.00194
; LINE_WIDTH: 0.410425
G1 X171.873 Y158.838 E.00172
; LINE_WIDTH: 0.361626
G1 X171.869 Y158.777 E.00159
; LINE_WIDTH: 0.316363
G1 X171.925 Y158.489 E.00654
; LINE_WIDTH: 0.273055
G1 X171.982 Y158.201 E.00551
M204 S10000
G1 X172.311 Y158.458 F60000
; LINE_WIDTH: 0.103811
G1 F2282
M204 S8000
G1 X172.25 Y158.547 E.00053
; LINE_WIDTH: 0.131162
G1 X172.16 Y158.687 E.0012
; LINE_WIDTH: 0.17552
G1 X172.077 Y158.827 E.00176
; LINE_WIDTH: 0.220551
G1 X172.047 Y158.849 E.00054
; LINE_WIDTH: 0.26214
G1 X172.017 Y158.871 E.00066
; LINE_WIDTH: 0.303729
G1 X171.987 Y158.893 E.00079
; LINE_WIDTH: 0.345317
G1 X171.957 Y158.914 E.00091
; LINE_WIDTH: 0.386906
G1 X171.928 Y158.936 E.00104
; LINE_WIDTH: 0.419702
G1 X171.913 Y158.942 E.00047
; LINE_WIDTH: 0.456464
G1 X171.884 Y158.952 E.00103
; LINE_WIDTH: 0.481227
G1 X171.842 Y159.095 E.00533
G2 X171.885 Y160.869 I3.096 J.814 E.06422
M204 S10000
G1 X172.305 Y161.357 F60000
; LINE_WIDTH: 0.110829
G1 F2282
M204 S8000
G1 X172.216 Y161.223 E.00089
; LINE_WIDTH: 0.145645
G1 X172.132 Y161.088 E.00133
; LINE_WIDTH: 0.183503
G1 X172.077 Y160.994 E.00125
; LINE_WIDTH: 0.217094
G1 X172.042 Y160.952 E.00078
; LINE_WIDTH: 0.259764
G1 X172.01 Y160.935 E.00063
; LINE_WIDTH: 0.308923
G1 X171.979 Y160.919 E.00077
; LINE_WIDTH: 0.358082
G1 X171.947 Y160.902 E.00091
; LINE_WIDTH: 0.407242
G1 X171.916 Y160.886 E.00105
; LINE_WIDTH: 0.461271
G1 X171.885 Y160.869 E.00121
G1 X171.879 Y160.889 E.00069
; LINE_WIDTH: 0.438302
G1 X171.875 Y160.941 E.00168
; LINE_WIDTH: 0.397721
G1 X171.872 Y160.992 E.0015
; LINE_WIDTH: 0.35714
G1 X171.869 Y161.044 E.00133
; LINE_WIDTH: 0.327591
G1 X171.966 Y161.607 E.01325
; WIPE_START
G1 F12646.177
G1 X171.869 Y161.044 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.968 Y162.698 Z8.2 F60000
G1 Z7.8
G1 E.8 F1800
; LINE_WIDTH: 0.419272
G1 F2282
M204 S8000
G1 X173.527 Y162.795 E.0174
; LINE_WIDTH: 0.48076
G1 X173.586 Y162.796 E.00211
G2 X176.043 Y162.876 I1.325 J-2.884 E.09006
G1 X176.245 Y162.791 E.00783
M204 S10000
G1 X176.536 Y162.406 F60000
; LINE_WIDTH: 0.109154
G1 F2282
M204 S8000
G1 X176.414 Y162.502 E.00084
; LINE_WIDTH: 0.135921
G1 X176.325 Y162.566 E.00083
; LINE_WIDTH: 0.172028
G1 X176.286 Y162.613 E.00064
; LINE_WIDTH: 0.21929
G1 X176.279 Y162.643 E.00044
; LINE_WIDTH: 0.266858
G1 X176.272 Y162.672 E.00055
; LINE_WIDTH: 0.314425
G1 X176.266 Y162.702 E.00067
; LINE_WIDTH: 0.361993
G1 X176.259 Y162.731 E.00079
; LINE_WIDTH: 0.40956
G1 X176.252 Y162.761 E.00091
; LINE_WIDTH: 0.444678
G1 X176.245 Y162.791 E.00099
G1 X176.352 Y162.784 E.00351
; LINE_WIDTH: 0.398901
G1 X176.94 Y162.645 E.01752
; WIPE_START
G1 F10112.907
G1 X176.352 Y162.784 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X177.585 Y161.644 Z8.2 F60000
G1 Z7.8
G1 E.8 F1800
; LINE_WIDTH: 0.481353
G1 F2282
M204 S8000
M73 P79 R3
G2 X178.033 Y160.488 I-3.004 J-1.827 E.0445
; LINE_WIDTH: 0.480084
G2 X178.019 Y159.267 I-3.118 J-.576 E.04376
G1 X178.016 Y159.253 E.00054
G3 X177.942 Y158.894 I1.479 J-.491 E.01308
; LINE_WIDTH: 0.409076
G1 X177.947 Y158.835 E.00175
; LINE_WIDTH: 0.360944
G1 X177.952 Y158.777 E.00152
; LINE_WIDTH: 0.328484
G1 X177.857 Y158.218 E.0132
; WIPE_START
G1 F12606.658
G1 X177.952 Y158.777 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X176.802 Y156.453 Z8.2 F60000
G1 Z7.8
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F2282
M204 S8000
G1 X176.802 Y153.946 E.07702
G1 X175.036 Y153.946 E.05429
G1 X174.382 Y153.992 E.02014
G1 X173.533 Y154.157 E.02658
G1 X173.019 Y154.328 E.01663
G1 X173.019 Y156.434 E.06474
G3 X174.627 Y155.976 I1.882 J3.554 E.05175
G3 X176.749 Y156.425 I.332 J3.676 E.06765
M204 S10000
G1 X176.425 Y155.85 F60000
G1 F2282
M204 S8000
G1 X176.425 Y154.323 E.04692
G1 X175.049 Y154.323 E.0423
G1 X174.431 Y154.366 E.01902
G1 X173.628 Y154.523 E.02513
G1 X173.396 Y154.6 E.00752
G1 X173.396 Y155.849 E.03839
G1 X173.956 Y155.682 E.01796
G3 X175.559 Y155.625 I.997 J5.459 E.04945
G3 X176.369 Y155.831 I-.553 J3.863 E.02573
M204 S10000
G1 X175.999 Y155.285 F60000
; LINE_WIDTH: 0.500937
G1 F2282
M204 S8000
G1 X175.999 Y154.75 E.01998
G2 X174.497 Y154.768 I-.636 J9.591 E.05609
; LINE_WIDTH: 0.466708
G2 X173.791 Y154.893 I2.576 J16.551 E.02478
G1 X173.791 Y155.318 E.01467
G1 X174.537 Y155.199 E.0261
G1 X175.057 Y155.176 E.01798
; LINE_WIDTH: 0.504986
G1 X175.651 Y155.211 E.02238
G1 X175.94 Y155.273 E.01114
; WIPE_START
G1 F7791.102
G1 X175.651 Y155.211 E-.25253
G1 X175.057 Y155.176 E-.50747
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X177.805 Y153.224 Z8.2 F60000
G1 Z7.8
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.605284
G1 F2282
M204 S8000
G1 X182.105 Y153.224 E.19705
; CHANGE_LAYER
; Z_HEIGHT: 8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F6401.55
G1 X180.105 Y153.224 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 40/58
; update layer progress
M73 L40
M991 S0 P39 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 2
M204 S10000
G17
G3 Z8.2 I-.896 J-.823 P1  F60000
G1 X172.6 Y161.4 Z8.2
G1 Z8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2281
M204 S8000
G1 X172.439 Y161.116 E.0108
G3 X174.767 Y157.162 I2.473 J-1.206 E.17996
G1 X174.913 Y157.158 E.00486
G3 X172.632 Y161.45 I-.001 J2.752 E.37593
; COOLING_NODE: 2
M204 S250
G1 X172.939 Y161.204 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2281
M204 S5000
G1 X172.79 Y160.945 E.00918
G3 X174.788 Y157.554 I2.121 J-1.035 E.14301
G1 X174.91 Y157.551 E.00377
G3 X172.972 Y161.254 I.001 J2.36 E.29777
; COOLING_NODE: 2
; WIPE_START
G1 F9547.055
M204 S8000
G1 X172.79 Y160.945 E-.13627
G1 X172.693 Y160.717 E-.09414
G1 X172.603 Y160.403 E-.12418
G1 X172.554 Y160.034 E-.14161
G1 X172.574 Y159.582 E-.17179
G1 X172.62 Y159.345 E-.09201
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.627 Y157.16 Z8.4 F60000
G1 Z8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2281
M204 S8000
G1 X172.627 Y154.053 E.10308
G3 X175.023 Y153.555 I2.52 J6.118 E.08165
G1 X177.195 Y153.555 E.07203
G1 X177.195 Y157.154 E.11938
G2 X172.674 Y157.123 I-2.28 J2.809 E.16199
; COOLING_NODE: 2
; WIPE_START
G1 F8843.478
G1 X172.643 Y155.123 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.748 Y153.574 Z8.4 F60000
G1 Z8
G1 E.8 F1800
G1 F2281
M204 S8000
G1 X172.863 Y153.531 E.00406
G3 X175.016 Y153.148 I2.319 J6.794 E.07283
G1 X177.602 Y153.148 E.08577
G1 X177.602 Y157.958 E.15955
G1 X177.434 Y158.013 E.00586
G2 X172.388 Y158.013 I-2.523 J1.91 E.19375
G1 X172.22 Y157.958 E.00586
G1 X172.22 Y153.786 E.13838
G1 X172.692 Y153.596 E.01689
; COOLING_NODE: 2
; WIPE_START
G1 F8843.478
G1 X172.863 Y153.531 E-.06929
G1 X173.565 Y153.326 E-.27808
G1 X174.286 Y153.199 E-.27798
G1 X174.639 Y153.175 E-.13464
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X176.991 Y160.436 Z8.4 F60000
G1 X177.436 Y161.808 Z8.4
G1 Z8
G1 E.8 F1800
G1 F2281
M204 S8000
G1 X177.602 Y161.864 E.00581
G1 X177.602 Y162.402 E.01782
G1 X176.874 Y162.402 E.02413
G2 X177.398 Y161.855 I-3.14 J-3.534 E.02515
; COOLING_NODE: 2
; WIPE_START
G1 F8843.478
G1 X177.602 Y161.864 E-.07735
G1 X177.602 Y162.402 E-.20414
G1 X176.874 Y162.402 E-.27641
G1 X177.254 Y162.029 E-.20209
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.388 Y161.808 Z8.4 F60000
G1 Z8
G1 E.8 F1800
G1 F2281
M204 S8000
G1 X172.451 Y161.894 E.00355
G2 X172.956 Y162.402 I3.017 J-2.498 E.02378
G1 X172.22 Y162.402 E.02443
G1 X172.22 Y161.864 E.01785
G1 X172.331 Y161.827 E.00387
; COOLING_NODE: 2
; WIPE_START
G1 F8843.478
G1 X172.451 Y161.894 E-.0525
G1 X172.683 Y162.151 E-.13147
G1 X172.956 Y162.402 E-.14083
G1 X172.22 Y162.402 E-.27982
G1 X172.22 Y161.993 E-.15538
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.815 Y154.371 Z8.4 F60000
G1 X171.813 Y154.325 Z8.4
G1 Z8
G1 E.8 F1800
G1 F2281
M204 S8000
G1 X170.602 Y155.449 E.05479
G2 X168.709 Y159.906 I4.321 J4.467 E.16499
G1 X168.709 Y167.309 E.24557
G1 X167.74 Y167.309 E.03213
G1 X167.741 Y160.011 E.24209
G3 X175.009 Y152.741 I7.408 J.139 E.37681
G1 X182.309 Y152.74 E.24215
G1 X182.309 Y153.709 E.03213
G1 X178.009 Y153.709 E.14264
G1 X178.009 Y158.069 E.14465
G3 X178.009 Y161.752 I-3.167 J1.842 E.12801
G1 X178.009 Y162.809 E.03504
G1 X177.062 Y162.809 E.0314
G3 X172.762 Y162.809 I-2.15 J-2.97 E.15242
G1 X171.813 Y162.809 E.03149
G1 X171.813 Y161.755 E.03495
G3 X171.813 Y158.064 I3.182 J-1.846 E.12827
G1 X171.813 Y154.385 E.12202
; COOLING_NODE: 0
M204 S250
G1 X171.421 Y155.224 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2193
M204 S5000
G2 X169.983 Y156.833 I4.913 J5.838 E.06652
G2 X169.101 Y159.909 I4.973 J3.091 E.0996
G1 X169.101 Y167.701 E.23942
G1 X167.348 Y167.701 E.05386
G1 X167.349 Y160.002 E.23655
M73 P79 R2
G3 X175.002 Y152.349 I7.801 J.148 E.36749
G1 X182.701 Y152.348 E.23657
G1 X182.701 Y154.101 E.05386
G1 X178.401 Y154.101 E.13213
G1 X178.401 Y157.974 E.11902
G3 X178.401 Y161.847 I-3.531 J1.937 E.12415
G1 X178.401 Y163.201 E.04159
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X177.173 Y163.201 E.03773
G3 X172.649 Y163.201 I-2.262 J-3.326 E.14762
G1 X171.421 Y163.201 E.03776
G1 X171.421 Y161.848 E.04156
G3 X171.421 Y157.972 I3.536 J-1.938 E.12424
G1 X171.421 Y155.284 E.08259
M204 S10000
G1 X170.938 Y154.565 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.509684
G1 F2281
M204 S8000
G2 X169.098 Y156.69 I4.446 J5.708 E.10759
; LINE_WIDTH: 0.542521
G2 X168.324 Y158.869 I5.993 J3.355 E.09461
; LINE_WIDTH: 0.601215
G1 X168.288 Y159.104 E.01079
G2 X168.225 Y160.021 I7.43 J.976 E.04185
G1 X168.224 Y167.105 E.32229
; WIPE_START
G1 F6448.205
G1 X168.225 Y165.105 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X170.642 Y157.866 Z8.4 F60000
G1 X172.016 Y153.749 Z8.4
M73 P80 R2
G1 Z8
G1 E.8 F1800
; LINE_WIDTH: 0.240755
G1 F2281
M204 S8000
G1 X171.917 Y153.816 E.00193
; LINE_WIDTH: 0.257024
G1 X171.815 Y153.888 E.00217
; LINE_WIDTH: 0.289286
G1 X171.714 Y153.96 E.0025
; LINE_WIDTH: 0.319311
G1 X171.614 Y154.034 E.00279
; LINE_WIDTH: 0.347066
G1 X171.514 Y154.107 E.00307
; LINE_WIDTH: 0.384335
G1 X171.319 Y154.257 E.00686
; LINE_WIDTH: 0.426646
G1 X171.127 Y154.41 E.00765
; LINE_WIDTH: 0.460267
G1 X170.938 Y154.565 E.00832
; WIPE_START
G1 F8625.917
G1 X171.127 Y154.41 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.236 Y158.177 Z8.4 F60000
G1 Z8
G1 E.8 F1800
; LINE_WIDTH: 0.479341
G1 F2281
M204 S8000
G1 X172.031 Y158.575 E.0159
G2 X172.137 Y161.449 I2.862 J1.334 E.10621
G1 X172.454 Y161.572 E.01208
; WIPE_START
G1 F8248.921
G1 X172.137 Y161.449 E-.12907
G1 X171.991 Y161.156 E-.12469
G1 X171.87 Y160.823 E-.13443
G1 X171.777 Y160.413 E-.15985
G1 X171.739 Y160.048 E-.13941
G1 X171.743 Y159.857 E-.07254
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.959 Y162.692 Z8.4 F60000
G1 Z8
G1 E.8 F1800
; LINE_WIDTH: 0.418933
G1 F2281
M204 S8000
G1 X173.555 Y162.795 E.01851
; LINE_WIDTH: 0.46877
G1 X173.589 Y162.796 E.0012
; LINE_WIDTH: 0.481289
G2 X176.247 Y162.79 I1.323 J-2.885 E.09797
; LINE_WIDTH: 0.459971
G1 X176.249 Y162.767 E.00079
; LINE_WIDTH: 0.41582
G1 X176.261 Y162.734 E.00107
; LINE_WIDTH: 0.367833
G1 X176.273 Y162.701 E.00093
; LINE_WIDTH: 0.319845
G1 X176.286 Y162.668 E.00079
; LINE_WIDTH: 0.271858
G1 X176.298 Y162.635 E.00066
; LINE_WIDTH: 0.223871
G1 X176.31 Y162.602 E.00052
; LINE_WIDTH: 0.175883
G1 X176.323 Y162.569 E.00038
; LINE_WIDTH: 0.132253
G1 X176.45 Y162.475 E.00115
; LINE_WIDTH: 0.104863
G1 X176.537 Y162.407 E.00056
M204 S10000
G1 X176.936 Y162.647 F60000
; LINE_WIDTH: 0.400149
G1 F2281
M204 S8000
G1 X176.3 Y162.787 E.01895
; LINE_WIDTH: 0.460406
G1 X176.247 Y162.79 E.0018
M204 S10000
G1 X177.581 Y161.642 F60000
; LINE_WIDTH: 0.481255
G1 F2281
M204 S8000
G2 X177.716 Y158.425 I-2.71 J-1.725 E.12049
G1 X177.583 Y158.178 E.01001
M204 S10000
G1 X177.398 Y157.59 F60000
; LINE_WIDTH: 0.106173
G1 F2281
M204 S8000
G1 X177.28 Y157.49 E.0008
; WIPE_START
G1 F15000
G1 X177.398 Y157.59 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X176.802 Y156.458 Z8.4 F60000
G1 Z8
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F2281
M204 S8000
G1 X176.802 Y153.947 E.07716
G1 X175.037 Y153.947 E.05425
G1 X174.383 Y153.993 E.02014
G1 X173.534 Y154.158 E.02658
G1 X173.019 Y154.329 E.01667
G1 X173.019 Y156.435 E.0647
G1 X173.544 Y156.195 E.01775
G1 X174.242 Y156.013 E.02215
G1 X174.902 Y155.952 E.02036
G1 X175.649 Y156.022 E.02305
G1 X176.379 Y156.234 E.02337
G1 X176.749 Y156.43 E.01289
M204 S10000
G1 X176.425 Y155.854 F60000
G1 F2281
M204 S8000
G1 X176.425 Y154.324 E.04702
G1 X175.05 Y154.324 E.04226
G1 X174.432 Y154.368 E.01903
G1 X173.63 Y154.524 E.02512
G1 X173.396 Y154.601 E.00757
G1 X173.396 Y155.849 E.03833
G1 X174.148 Y155.648 E.02391
G1 X174.872 Y155.576 E.02238
G1 X175.685 Y155.647 E.02507
G1 X176.368 Y155.838 E.02178
M204 S10000
G1 X175.999 Y155.285 F60000
; LINE_WIDTH: 0.499055
G1 F2281
M204 S8000
G1 X175.999 Y154.75 E.01986
G2 X174.498 Y154.768 I-.637 J9.627 E.05586
; LINE_WIDTH: 0.460428
G2 X173.791 Y154.895 I2.241 J14.52 E.02445
G1 X173.791 Y155.332 E.01486
G3 X174.841 Y155.174 I1.116 J3.856 E.03623
; LINE_WIDTH: 0.499227
G1 X175.726 Y155.223 E.03297
G1 X175.941 Y155.271 E.00818
; WIPE_START
G1 F7889.437
G1 X175.726 Y155.223 E-.151
G1 X174.841 Y155.174 E-.609
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X177.805 Y153.225 Z8.4 F60000
G1 Z8
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.604044
G1 F2281
M204 S8000
G1 X182.105 Y153.224 E.19661
; CHANGE_LAYER
; Z_HEIGHT: 8.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F6415.698
G1 X180.105 Y153.225 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 41/58
; update layer progress
M73 L41
M991 S0 P40 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 2
M204 S10000
G17
G3 Z8.4 I-.901 J-.818 P1  F60000
G1 X172.631 Y161.45 Z8.4
G1 Z8.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2283
M204 S8000
G1 X172.61 Y161.416 E.00135
G3 X174.766 Y157.162 I2.302 J-1.506 E.19138
G1 X174.902 Y157.158 E.00449
G3 X172.774 Y161.641 I.01 J2.751 E.36827
G1 X172.667 Y161.498 E.00591
; COOLING_NODE: 2
M204 S250
G1 X172.948 Y161.22 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2283
M204 S5000
G1 X172.939 Y161.205 E.00053
G3 X174.787 Y157.554 I1.972 J-1.295 E.15221
G1 X174.899 Y157.551 E.00344
G3 X173.078 Y161.395 I.011 J2.359 E.29254
G1 X172.984 Y161.268 E.00487
; COOLING_NODE: 2
; WIPE_START
G1 F9547.055
M204 S8000
G1 X172.939 Y161.205 E-.02931
G1 X172.722 Y160.795 E-.17624
G1 X172.594 Y160.362 E-.17136
G1 X172.551 Y159.913 E-.17175
G1 X172.593 Y159.463 E-.1716
G1 X172.623 Y159.363 E-.03974
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.627 Y157.167 Z8.6 F60000
G1 Z8.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2283
M204 S8000
G1 X172.627 Y154.055 E.10324
G3 X175.024 Y153.557 I2.521 J6.118 E.08169
G1 X177.195 Y153.556 E.07199
G1 X177.195 Y157.166 E.11975
G2 X172.674 Y157.129 I-2.284 J2.795 E.16207
; COOLING_NODE: 2
; WIPE_START
G1 F8843.478
G1 X172.643 Y155.13 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.749 Y153.575 Z8.6 F60000
G1 Z8.2
G1 E.8 F1800
G1 F2283
M204 S8000
G1 X172.864 Y153.533 E.00407
G3 X175.017 Y153.15 I2.319 J6.793 E.07284
G1 X177.602 Y153.149 E.08573
G1 X177.602 Y157.957 E.15949
G1 X177.436 Y158.013 E.0058
G2 X172.384 Y158.014 I-2.526 J1.903 E.19413
G1 X172.22 Y157.957 E.00575
G1 X172.22 Y153.788 E.1383
G1 X172.693 Y153.598 E.01691
; COOLING_NODE: 2
; WIPE_START
G1 F8843.478
G1 X172.864 Y153.533 E-.06943
G1 X173.566 Y153.328 E-.27811
G1 X174.287 Y153.201 E-.27811
G1 X174.64 Y153.176 E-.13435
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X176.99 Y160.437 Z8.6 F60000
G1 X177.434 Y161.808 Z8.6
G1 Z8.2
G1 E.8 F1800
G1 F2283
M204 S8000
G1 X177.602 Y161.864 E.00586
G1 X177.602 Y162.402 E.01784
G1 X176.874 Y162.402 E.02413
G2 X177.396 Y161.855 I-2.975 J-3.367 E.0251
; COOLING_NODE: 2
; WIPE_START
G1 F8843.478
G1 X177.602 Y161.864 E-.07801
G1 X177.602 Y162.402 E-.20436
G1 X176.874 Y162.402 E-.27641
G1 X177.252 Y162.031 E-.20121
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.386 Y161.808 Z8.6 F60000
G1 Z8.2
G1 E.8 F1800
G1 F2283
M204 S8000
G1 X172.455 Y161.899 E.00381
G2 X172.947 Y162.402 I3.472 J-2.907 E.02334
G1 X172.22 Y162.402 E.02413
G1 X172.22 Y161.864 E.01782
G1 X172.329 Y161.827 E.00382
; COOLING_NODE: 2
; WIPE_START
G1 F8843.478
G1 X172.455 Y161.899 E-.05535
G1 X172.677 Y162.145 E-.12559
G1 X172.947 Y162.402 E-.14177
G1 X172.22 Y162.402 E-.27642
G1 X172.22 Y161.978 E-.16087
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.814 Y154.357 Z8.6 F60000
G1 X171.813 Y154.325 Z8.6
G1 Z8.2
G1 E.8 F1800
G1 F2283
M204 S8000
G1 X170.603 Y155.449 E.05477
G2 X168.709 Y159.906 I4.322 J4.468 E.165
G1 X168.709 Y167.309 E.24557
G1 X167.741 Y167.309 E.03209
G1 X167.742 Y160.012 E.24204
G3 X175.01 Y152.742 I7.408 J.138 E.37682
G1 X182.309 Y152.741 E.24211
G1 X182.309 Y153.709 E.03209
G1 X178.009 Y153.709 E.14264
G1 X178.009 Y158.069 E.14465
G3 X178.009 Y161.752 I-3.157 J1.841 E.12804
G1 X178.009 Y162.809 E.03504
G1 X177.062 Y162.809 E.0314
G3 X172.762 Y162.809 I-2.15 J-2.976 E.15238
G1 X171.813 Y162.809 E.03149
G1 X171.813 Y161.758 E.03486
G3 X171.813 Y158.069 I3.177 J-1.844 E.12818
G1 X171.813 Y154.385 E.1222
; COOLING_NODE: 0
M204 S250
G1 X171.421 Y155.224 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2159
M204 S5000
G2 X169.983 Y156.833 I4.913 J5.838 E.06651
G2 X169.101 Y159.909 I4.95 J3.084 E.09962
G1 X169.101 Y167.701 E.23942
G1 X167.349 Y167.701 E.05382
G1 X167.35 Y160.004 E.23651
G3 X175.003 Y152.35 I7.801 J.147 E.3675
G1 X182.701 Y152.349 E.23653
G1 X182.701 Y154.101 E.05382
G1 X178.401 Y154.101 E.13213
G1 X178.401 Y157.974 E.11902
G3 X178.401 Y161.847 I-3.52 J1.937 E.12418
G1 X178.401 Y163.201 E.04159
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X177.173 Y163.201 E.03773
G3 X172.649 Y163.201 I-2.262 J-3.333 E.14758
G1 X171.421 Y163.201 E.03776
G1 X171.421 Y161.849 E.04153
G3 X171.421 Y157.974 I3.534 J-1.938 E.12421
M73 P81 R2
G1 X171.421 Y155.284 E.08265
M204 S10000
G1 X170.939 Y154.565 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.507966
G1 F2283
M204 S8000
G2 X169.097 Y156.695 I4.444 J5.706 E.10737
; LINE_WIDTH: 0.541033
G1 X168.936 Y156.998 E.01392
G1 X168.73 Y157.454 E.02032
G2 X168.325 Y158.871 I6.338 J2.582 E.05997
; LINE_WIDTH: 0.599973
G2 X168.226 Y160.022 I7.103 J1.191 E.0525
G1 X168.225 Y167.105 E.3215
; WIPE_START
G1 F6462.586
G1 X168.225 Y165.105 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.997 Y162.716 Z8.6 F60000
G1 Z8.2
G1 E.8 F1800
; LINE_WIDTH: 0.418481
G1 F2283
M204 S8000
G1 X173.53 Y162.791 E.01648
; LINE_WIDTH: 0.481007
G1 X173.577 Y162.79 E.00168
G2 X176.247 Y162.79 I1.335 J-2.884 E.09837
; LINE_WIDTH: 0.460523
G1 X176.3 Y162.787 E.00179
; LINE_WIDTH: 0.400286
G1 X176.934 Y162.648 E.01891
M204 S10000
G1 X176.537 Y162.407 F60000
; LINE_WIDTH: 0.104877
G1 F2283
M204 S8000
G1 X176.45 Y162.475 E.00056
; LINE_WIDTH: 0.132273
G1 X176.323 Y162.569 E.00115
; LINE_WIDTH: 0.175672
G1 X176.31 Y162.602 E.00038
; LINE_WIDTH: 0.223249
G1 X176.298 Y162.635 E.00051
; LINE_WIDTH: 0.270826
G1 X176.286 Y162.667 E.00065
; LINE_WIDTH: 0.318403
G1 X176.274 Y162.7 E.00078
; LINE_WIDTH: 0.36598
G1 X176.261 Y162.733 E.00092
; LINE_WIDTH: 0.413557
G1 X176.249 Y162.766 E.00106
; LINE_WIDTH: 0.458734
G1 X176.247 Y162.79 E.00083
M204 S10000
G1 X177.583 Y161.643 F60000
; LINE_WIDTH: 0.481382
G1 F2283
M204 S8000
G2 X177.714 Y158.419 I-2.708 J-1.724 E.12079
G1 X177.581 Y158.179 E.0098
; WIPE_START
G1 F8210.517
G1 X177.714 Y158.419 E-.10423
G1 X177.907 Y158.86 E-.18277
G1 X178.023 Y159.287 E-.16814
G1 X178.074 Y159.651 E-.13964
G1 X178.081 Y160.082 E-.16399
G1 X178.08 Y160.085 E-.00123
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X173.791 Y155.332 Z8.6 F60000
G1 Z8.2
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.460487
G1 F2283
M204 S8000
G3 X174.828 Y155.174 I1.115 J3.846 E.03581
; LINE_WIDTH: 0.499201
G1 X175.739 Y155.225 E.03391
G1 X175.999 Y155.281 E.00991
G1 X175.999 Y154.752 E.01968
G2 X174.499 Y154.769 I-.639 J9.7 E.05584
; LINE_WIDTH: 0.459018
G2 X173.791 Y154.896 I2.28 J14.728 E.02441
G1 X173.791 Y155.272 E.01275
M204 S10000
G1 X176.425 Y155.853 F60000
; LINE_WIDTH: 0.41999
G1 F2283
M204 S8000
G1 X176.425 Y154.326 E.04695
G1 X175.051 Y154.326 E.04222
G1 X174.433 Y154.369 E.01903
G1 X173.632 Y154.525 E.0251
G1 X173.396 Y154.603 E.00762
G1 X173.396 Y155.851 E.03833
G1 X174.147 Y155.648 E.0239
G1 X174.86 Y155.576 E.02203
G1 X175.697 Y155.649 E.02581
G1 X176.369 Y155.832 E.0214
M204 S10000
G1 X176.802 Y156.435 F60000
G1 F2283
M204 S8000
G1 X176.802 Y153.948 E.07639
G1 X175.038 Y153.949 E.05421
G1 X174.384 Y153.994 E.02014
G1 X173.536 Y154.159 E.02656
G1 X173.019 Y154.331 E.01673
G1 X173.019 Y156.446 E.06499
G1 X173.542 Y156.197 E.01779
G1 X174.241 Y156.013 E.02222
G1 X174.89 Y155.952 E.02004
G1 X175.66 Y156.024 E.02377
G1 X176.188 Y156.164 E.01678
G1 X176.75 Y156.406 E.01879
; WIPE_START
G1 F9547.299
G1 X176.188 Y156.164 E-.23236
G1 X175.66 Y156.024 E-.2075
G1 X174.89 Y155.952 E-.29393
G1 X174.822 Y155.958 E-.02621
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X177.805 Y153.225 Z8.6 F60000
G1 Z8.2
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.602814
G1 F2283
M204 S8000
G1 X182.105 Y153.225 E.19618
; WIPE_START
G1 F6429.793
G1 X180.105 Y153.225 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.489 Y153.718 Z8.6 F60000
G1 X172.016 Y153.749 Z8.6
G1 Z8.2
G1 E.8 F1800
; LINE_WIDTH: 0.239014
G1 F2283
M204 S8000
G1 X171.918 Y153.816 E.00191
; LINE_WIDTH: 0.255272
G1 X171.816 Y153.889 E.00216
; LINE_WIDTH: 0.287526
G1 X171.715 Y153.961 E.00248
; LINE_WIDTH: 0.317557
G1 X171.615 Y154.034 E.00277
; LINE_WIDTH: 0.345334
G1 X171.515 Y154.108 E.00305
; LINE_WIDTH: 0.382616
G1 X171.319 Y154.258 E.00683
; LINE_WIDTH: 0.424929
G1 X171.128 Y154.41 E.00761
; LINE_WIDTH: 0.458539
G1 X170.939 Y154.565 E.00829
; WIPE_START
G1 F8661.779
G1 X171.128 Y154.41 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.238 Y158.179 Z8.6 F60000
G1 Z8.2
G1 E.8 F1800
; LINE_WIDTH: 0.481223
G1 F2283
M204 S8000
G1 X172.105 Y158.425 E.00999
G2 X172.238 Y161.643 I2.849 J1.493 E.12048
; CHANGE_LAYER
; Z_HEIGHT: 8.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F8213.5
G1 X172.015 Y161.212 E-.18445
G1 X171.884 Y160.869 E-.13957
G1 X171.794 Y160.517 E-.13784
G1 X171.74 Y160.048 E-.17954
G1 X171.748 Y159.736 E-.11859
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 42/58
; update layer progress
M73 L42
M991 S0 P41 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 2
M204 S10000
G17
G3 Z8.6 I-1.081 J.559 P1  F60000
G1 X172.636 Y161.454 Z8.6
G1 Z8.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2291
M204 S8000
G1 X172.576 Y161.369 E.00347
G3 X174.63 Y157.173 I2.333 J-1.459 E.1851
G1 X174.874 Y157.159 E.0081
G3 X172.741 Y161.605 I.036 J2.752 E.37078
G1 X172.671 Y161.504 E.0041
; COOLING_NODE: 2
M204 S250
G1 X172.957 Y161.23 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2284
M204 S5000
G1 X172.909 Y161.161 E.00258
G3 X174.667 Y157.563 I2.001 J-1.251 E.14692
G1 X174.883 Y157.551 E.00665
G3 X173.051 Y161.363 I.027 J2.359 E.2944
G1 X172.992 Y161.279 E.00317
; COOLING_NODE: 2
; WIPE_START
G1 F9547.055
M204 S8000
G1 X172.909 Y161.161 E-.05474
G1 X172.789 Y160.945 E-.09372
G1 X172.653 Y160.599 E-.14142
G1 X172.602 Y160.401 E-.07759
G1 X172.556 Y160.075 E-.12503
G1 X172.56 Y159.703 E-.14164
G1 X172.611 Y159.379 E-.12442
G1 X172.612 Y159.376 E-.00144
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.627 Y157.16 Z8.8 F60000
G1 Z8.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2291
M204 S8000
G1 X172.627 Y154.056 E.10296
G3 X175.026 Y153.558 I2.522 J6.117 E.08174
G1 X177.195 Y153.557 E.07195
G1 X177.195 Y157.154 E.1193
G2 X172.674 Y157.123 I-2.28 J2.809 E.16199
; COOLING_NODE: 2
; WIPE_START
G1 F8843.478
G1 X172.643 Y155.123 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.22 Y158.21 Z8.8 F60000
G1 Z8.4
G1 E.8 F1800
G1 F2291
M204 S8000
G1 X172.22 Y153.79 E.14662
G3 X175.018 Y153.151 I2.964 J6.538 E.09587
G1 X177.602 Y153.15 E.08569
G1 X177.602 Y158.211 E.16787
G2 X176.246 Y157.047 I-2.896 J2.001 E.05991
G2 X172.526 Y157.838 I-1.328 J2.899 E.13519
G1 X172.258 Y158.163 E.01397
; COOLING_NODE: 2
; WIPE_START
G1 F8843.478
G1 X172.241 Y156.163 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X177.409 Y161.779 Z8.8 F60000
G1 X177.436 Y161.808 Z8.8
G1 Z8.4
G1 E.8 F1800
G1 F2291
M204 S8000
G1 X177.602 Y161.864 E.00581
G1 X177.602 Y162.402 E.01782
G1 X176.872 Y162.402 E.02419
G2 X177.399 Y161.855 I-2.674 J-3.104 E.0252
; COOLING_NODE: 2
; WIPE_START
G1 F8843.478
G1 X177.602 Y161.864 E-.07715
G1 X177.602 Y162.402 E-.20414
G1 X176.872 Y162.402 E-.27714
G1 X177.184 Y162.106 E-.16304
G1 X177.25 Y162.029 E-.03853
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.33 Y161.745 Z8.8 F60000
G1 Z8.4
G1 E.8 F1800
G1 F2291
M204 S8000
G1 X172.531 Y161.99 E.01051
G2 X172.954 Y162.402 I3.146 J-2.806 E.01959
G1 X172.22 Y162.402 E.02435
G1 X172.22 Y161.612 E.0262
G1 X172.292 Y161.699 E.00376
; COOLING_NODE: 2
; WIPE_START
G1 F8843.478
G1 X172.531 Y161.99 E-.14317
G1 X172.954 Y162.402 E-.2242
G1 X172.22 Y162.402 E-.27899
G1 X172.22 Y162.103 E-.11364
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.821 Y154.481 Z8.8 F60000
G1 X171.813 Y154.325 Z8.8
G1 Z8.4
G1 E.8 F1800
G1 F2291
M204 S8000
G1 X170.603 Y155.449 E.05477
G2 X168.709 Y159.906 I4.331 J4.472 E.16499
G1 X168.709 Y167.309 E.24557
G1 X167.743 Y167.309 E.03205
G1 X167.744 Y160.013 E.242
G3 X175.011 Y152.744 I7.408 J.138 E.37682
G1 X182.309 Y152.743 E.24207
G1 X182.309 Y153.709 E.03205
G1 X178.009 Y153.709 E.14264
G1 X178.009 Y158.064 E.14446
G3 X178.009 Y161.755 I-3.194 J1.846 E.12824
G1 X178.009 Y162.809 E.03495
G1 X177.062 Y162.809 E.03141
G3 X172.764 Y162.809 I-2.149 J-2.966 E.15234
G1 X171.813 Y162.809 E.03157
G1 X171.813 Y161.758 E.03486
G3 X171.813 Y158.069 I3.17 J-1.844 E.12821
G1 X171.813 Y154.385 E.1222
; COOLING_NODE: 0
M204 S250
G1 X171.421 Y155.224 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2114
M204 S5000
G2 X169.931 Y156.917 I4.841 J5.762 E.06956
G2 X169.101 Y159.909 I5.003 J3 E.09656
G1 X169.101 Y167.701 E.23941
G1 X167.35 Y167.701 E.05378
G1 X167.352 Y160.005 E.23647
G3 X175.004 Y152.352 I7.801 J.147 E.36749
G1 X182.701 Y152.35 E.23649
G1 X182.701 Y154.101 E.05378
G1 X178.401 Y154.101 E.13213
G1 X178.401 Y157.972 E.11896
M73 P82 R2
G3 X178.401 Y161.848 I-3.55 J1.938 E.1242
G1 X178.401 Y163.201 E.04156
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X177.173 Y163.201 E.03773
G3 X172.65 Y163.201 I-2.261 J-3.325 E.14759
G1 X171.421 Y163.201 E.03778
G1 X171.421 Y161.849 E.04153
G3 X171.421 Y157.974 I3.524 J-1.938 E.12423
G1 X171.421 Y155.284 E.08265
M204 S10000
G1 X170.94 Y154.566 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.456795
G1 F2291
M204 S8000
G1 X171.128 Y154.411 E.00823
; LINE_WIDTH: 0.423223
G1 X171.32 Y154.259 E.00758
; LINE_WIDTH: 0.380863
G1 X171.516 Y154.108 E.0068
; LINE_WIDTH: 0.343546
G1 X171.616 Y154.035 E.00304
; LINE_WIDTH: 0.315748
G1 X171.715 Y153.961 E.00276
; LINE_WIDTH: 0.285748
G1 X171.817 Y153.889 E.00246
; LINE_WIDTH: 0.253498
G1 X171.918 Y153.817 E.00214
; LINE_WIDTH: 0.237232
G1 X172.016 Y153.75 E.00188
M204 S10000
G1 X170.94 Y154.566 F60000
; LINE_WIDTH: 0.506231
G1 F2291
M204 S8000
G2 X169.098 Y156.694 I4.45 J5.712 E.10692
; LINE_WIDTH: 0.539451
G1 X168.985 Y156.903 E.00962
G2 X168.325 Y158.873 I6.159 J3.16 E.08438
; LINE_WIDTH: 0.598734
G2 X168.226 Y160.024 I7.086 J1.188 E.05237
G1 X168.226 Y167.105 E.32073
; WIPE_START
G1 F6476.989
G1 X168.226 Y165.105 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.97 Y162.698 Z8.8 F60000
G1 Z8.4
G1 E.8 F1800
; LINE_WIDTH: 0.419381
G1 F2291
M204 S8000
G1 X173.528 Y162.795 E.01737
; LINE_WIDTH: 0.480729
G1 X173.586 Y162.795 E.0021
G2 X176.041 Y162.877 I1.324 J-2.875 E.09
G1 X176.244 Y162.791 E.00786
M204 S10000
G1 X176.256 Y162.758 F60000
; LINE_WIDTH: 0.410797
G1 F2291
M204 S8000
G1 X176.267 Y162.726 E.00102
; LINE_WIDTH: 0.363495
G1 X176.279 Y162.694 E.00089
; LINE_WIDTH: 0.316193
G1 X176.29 Y162.662 E.00076
; LINE_WIDTH: 0.268891
G1 X176.302 Y162.63 E.00063
; LINE_WIDTH: 0.221589
G1 X176.313 Y162.598 E.0005
; LINE_WIDTH: 0.174287
G1 X176.325 Y162.566 E.00036
; LINE_WIDTH: 0.144623
G1 X176.358 Y162.543 E.00033
; LINE_WIDTH: 0.118175
G1 X176.529 Y162.413 E.00132
M204 S10000
G1 X176.352 Y162.784 F60000
; LINE_WIDTH: 0.445628
G1 F2291
M204 S8000
G1 X176.244 Y162.791 E.00353
G1 X176.256 Y162.758 E.00112
M204 S10000
G1 X176.352 Y162.784 F60000
; LINE_WIDTH: 0.399002
G1 F2291
M204 S8000
G1 X176.94 Y162.645 E.01753
; WIPE_START
G1 F10110.03
G1 X176.352 Y162.784 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X177.586 Y161.644 Z8.8 F60000
G1 Z8.4
G1 E.8 F1800
; LINE_WIDTH: 0.480807
G1 F2291
M204 S8000
G2 X177.978 Y159.094 I-2.755 J-1.729 E.09466
G1 X177.937 Y158.955 E.00519
G1 X177.945 Y158.927 E.00103
; LINE_WIDTH: 0.435337
G1 X177.952 Y158.899 E.00092
; LINE_WIDTH: 0.399909
G1 X177.953 Y158.84 E.00172
; LINE_WIDTH: 0.358885
G1 X177.953 Y158.78 E.00153
; LINE_WIDTH: 0.329108
G1 X177.853 Y158.208 E.01355
M204 S10000
G1 X177.398 Y157.591 F60000
; LINE_WIDTH: 0.105991
G1 F2291
M204 S8000
G1 X177.277 Y157.487 E.00082
; WIPE_START
G1 F15000
G1 X177.398 Y157.591 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.999 Y155.286 Z8.8 F60000
G1 Z8.4
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.498694
G1 F2291
M204 S8000
G1 X175.999 Y154.753 E.01982
G2 X174.501 Y154.769 I-.642 J9.88 E.05572
; LINE_WIDTH: 0.463478
G2 X173.79 Y154.897 I3.036 J18.942 E.02475
G1 X173.79 Y155.324 E.01462
G1 X174.534 Y155.196 E.02587
G1 X175.061 Y155.177 E.01806
; LINE_WIDTH: 0.503153
G1 X175.65 Y155.212 E.02214
G1 X175.941 Y155.274 E.01115
M204 S10000
G1 X176.425 Y155.863 F60000
; LINE_WIDTH: 0.41999
G1 F2291
M204 S8000
G1 X176.425 Y154.327 E.0472
G1 X175.052 Y154.327 E.04219
G1 X174.435 Y154.37 E.01902
G1 X173.633 Y154.526 E.02511
G1 X173.396 Y154.605 E.00766
G1 X173.396 Y155.866 E.03876
G3 X174.804 Y155.577 I1.529 J3.867 E.04438
G1 X175.47 Y155.612 E.02051
G1 X176.145 Y155.755 E.02118
G1 X176.369 Y155.841 E.0074
M204 S10000
G1 X176.768 Y156.415 F60000
G1 F2291
M204 S8000
G1 X176.799 Y156.428 E.00104
G2 X176.802 Y153.95 I-419.921 J-1.79 E.07614
G1 X175.039 Y153.95 E.05418
G1 X174.386 Y153.996 E.02014
G1 X173.537 Y154.161 E.02656
G1 X173.019 Y154.333 E.01677
G1 X173.019 Y156.434 E.06456
G1 X173.752 Y156.126 E.02442
G3 X175.447 Y155.988 I1.197 J4.239 E.05258
G1 X176.063 Y156.123 E.01937
G1 X176.712 Y156.392 E.0216
; WIPE_START
G1 F9547.299
G1 X176.063 Y156.123 E-.26711
G1 X175.447 Y155.988 E-.23957
G1 X174.836 Y155.952 E-.23242
G1 X174.781 Y155.957 E-.0209
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X177.805 Y153.226 Z8.8 F60000
G1 Z8.4
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.601584
G1 F2291
M204 S8000
G1 X182.105 Y153.226 E.19575
; WIPE_START
G1 F6443.951
G1 X180.105 Y153.226 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X173.769 Y157.482 Z8.8 F60000
G1 X172.305 Y158.465 Z8.8
G1 Z8.4
G1 E.8 F1800
; LINE_WIDTH: 0.117852
G1 F2291
M204 S8000
G1 X172.189 Y158.642 E.00129
; LINE_WIDTH: 0.159743
G1 X172.105 Y158.779 E.00153
; LINE_WIDTH: 0.191345
G1 X172.077 Y158.827 E.00068
; LINE_WIDTH: 0.225244
G1 X172.036 Y158.865 E.00083
; LINE_WIDTH: 0.274594
G1 X171.996 Y158.904 E.00105
; LINE_WIDTH: 0.305186
G1 X171.988 Y158.908 E.00019
; LINE_WIDTH: 0.332454
G1 X171.962 Y158.919 E.00066
; LINE_WIDTH: 0.375139
G1 X171.936 Y158.93 E.00076
; LINE_WIDTH: 0.417824
G1 X171.91 Y158.941 E.00086
; LINE_WIDTH: 0.46051
G1 X171.884 Y158.953 E.00096
; LINE_WIDTH: 0.48102
G1 X171.858 Y159.041 E.00329
G2 X171.884 Y160.869 I3.048 J.87 E.06621
; LINE_WIDTH: 0.457143
G1 X171.879 Y160.928 E.00198
; LINE_WIDTH: 0.40894
G1 X171.874 Y160.986 E.00175
; LINE_WIDTH: 0.360736
G1 X171.869 Y161.044 E.00152
; LINE_WIDTH: 0.327672
G1 X171.965 Y161.607 E.01325
M204 S10000
G1 X172.305 Y161.357 F60000
; LINE_WIDTH: 0.11072
G1 F2291
M204 S8000
G1 X172.217 Y161.223 E.00088
; LINE_WIDTH: 0.145429
G1 X172.132 Y161.088 E.00133
; LINE_WIDTH: 0.183367
G1 X172.077 Y160.994 E.00125
; LINE_WIDTH: 0.2166
G1 X172.042 Y160.952 E.00077
; LINE_WIDTH: 0.258925
G1 X172.011 Y160.936 E.00063
; LINE_WIDTH: 0.308332
G1 X171.979 Y160.919 E.00077
; LINE_WIDTH: 0.357738
G1 X171.948 Y160.902 E.00092
; LINE_WIDTH: 0.407144
G1 X171.916 Y160.886 E.00106
; LINE_WIDTH: 0.45655
G1 X171.884 Y160.869 E.0012
M204 S10000
G1 X171.884 Y158.953 F60000
; LINE_WIDTH: 0.457695
G1 F2291
M204 S8000
G1 X171.879 Y158.894 E.00198
; LINE_WIDTH: 0.409393
G1 X171.874 Y158.836 E.00175
; LINE_WIDTH: 0.361091
G1 X171.869 Y158.777 E.00152
; LINE_WIDTH: 0.329139
G1 X171.964 Y158.22 E.01318
; CHANGE_LAYER
; Z_HEIGHT: 8.6
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F12577.78
G1 X171.869 Y158.777 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 43/58
; update layer progress
M73 L43
M991 S0 P42 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 2
M204 S10000
G17
G3 Z8.8 I-1.169 J.337 P1  F60000
G1 X172.645 Y161.467 Z8.8
G1 Z8.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2291
M204 S8000
G1 X172.577 Y161.369 E.00395
G3 X174.629 Y157.173 I2.333 J-1.459 E.18506
G1 X174.862 Y157.159 E.00773
G3 X172.742 Y161.605 I.048 J2.751 E.37122
G1 X172.68 Y161.516 E.0036
; COOLING_NODE: 2
M204 S250
G1 X172.966 Y161.242 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2283
M204 S5000
G1 X172.91 Y161.161 E.00302
G3 X174.666 Y157.563 I2.001 J-1.251 E.1469
G1 X174.872 Y157.551 E.00632
G3 X173.051 Y161.363 I.039 J2.359 E.29477
G1 X173 Y161.291 E.0027
; COOLING_NODE: 2
; WIPE_START
G1 F9547.055
M204 S8000
G1 X172.91 Y161.161 E-.0602
G1 X172.789 Y160.945 E-.09405
G1 X172.653 Y160.598 E-.14156
G1 X172.602 Y160.401 E-.07758
G1 X172.556 Y160.075 E-.12504
G1 X172.568 Y159.623 E-.17194
G1 X172.615 Y159.392 E-.08962
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.627 Y157.165 Z9 F60000
G1 Z8.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2291
M204 S8000
G1 X172.627 Y154.058 E.10307
G3 X175.027 Y153.559 I2.523 J6.116 E.08179
G1 X177.195 Y153.559 E.0719
G1 X177.195 Y157.162 E.11953
G2 X172.674 Y157.128 I-2.282 J2.809 E.16198
; COOLING_NODE: 2
; WIPE_START
G1 F8843.478
G1 X172.643 Y155.128 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.75 Y153.578 Z9 F60000
G1 Z8.6
G1 E.8 F1800
G1 F2291
M204 S8000
G1 X172.867 Y153.535 E.00413
G3 X175.02 Y153.152 I2.319 J6.794 E.07282
G1 X177.602 Y153.152 E.08565
G1 X177.602 Y157.959 E.15948
G1 X177.436 Y158.016 E.00581
G2 X172.526 Y157.838 I-2.527 J1.904 E.1866
G1 X172.22 Y158.21 E.01597
G1 X172.22 Y153.791 E.14656
G1 X172.694 Y153.601 E.01696
; COOLING_NODE: 2
; WIPE_START
G1 F8843.478
G1 X172.867 Y153.535 E-.07012
G1 X173.569 Y153.33 E-.27811
G1 X174.29 Y153.203 E-.27792
G1 X174.641 Y153.178 E-.13385
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X177.169 Y160.38 Z9 F60000
G1 X177.602 Y161.612 Z9
G1 Z8.6
G1 E.8 F1800
G1 F2291
M204 S8000
G1 X177.602 Y162.402 E.02618
G1 X176.882 Y162.402 E.02387
G2 X177.565 Y161.66 I-4.115 J-4.474 E.03348
; COOLING_NODE: 2
; WIPE_START
G1 F8843.478
G1 X177.602 Y162.402 E-.28222
G1 X176.882 Y162.402 E-.27339
G1 X177.26 Y162.019 E-.20439
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.339 Y161.756 Z9 F60000
G1 Z8.6
G1 E.8 F1800
G1 F2291
M204 S8000
G1 X172.532 Y161.99 E.01006
G2 X172.954 Y162.402 I3.149 J-2.811 E.01957
G1 X172.22 Y162.402 E.02436
G1 X172.22 Y161.612 E.0262
G1 X172.301 Y161.71 E.00422
; COOLING_NODE: 2
; WIPE_START
G1 F8843.478
G1 X172.532 Y161.99 E-.1381
G1 X172.954 Y162.402 E-.224
G1 X172.22 Y162.402 E-.279
G1 X172.22 Y162.089 E-.11891
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.82 Y154.467 Z9 F60000
G1 X171.813 Y154.325 Z9
G1 Z8.6
G1 E.8 F1800
G1 F2291
M204 S8000
G1 X170.603 Y155.449 E.05478
G2 X168.709 Y159.906 I4.331 J4.471 E.16498
G1 X168.709 Y167.309 E.24557
G1 X167.744 Y167.309 E.03201
G1 X167.745 Y160.012 E.24203
G3 X175.012 Y152.745 I7.408 J.141 E.37674
G1 X182.309 Y152.744 E.24203
G1 X182.309 Y153.709 E.03201
G1 X178.009 Y153.709 E.14264
G1 X178.009 Y158.066 E.14456
G3 X178.009 Y161.758 I-3.173 J1.846 E.1283
G1 X178.009 Y162.809 E.03486
G1 X177.062 Y162.809 E.0314
G3 X172.765 Y162.809 I-2.149 J-2.965 E.15233
G1 X171.813 Y162.809 E.03159
G1 X171.813 Y161.752 E.03504
G3 X171.813 Y158.066 I3.157 J-1.843 E.12815
G1 X171.813 Y154.385 E.12211
; COOLING_NODE: 0
M204 S250
G1 X171.421 Y155.224 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2059
M204 S5000
G2 X169.983 Y156.833 I4.916 J5.841 E.06652
G2 X169.101 Y159.909 I4.977 J3.092 E.09959
G1 X169.101 Y167.701 E.23942
G1 X167.352 Y167.701 E.05374
G1 X167.353 Y160.005 E.23646
G3 X175.005 Y152.353 I7.801 J.149 E.36747
M73 P83 R2
G1 X182.701 Y152.352 E.23645
G1 X182.701 Y154.101 E.05374
G1 X178.401 Y154.101 E.13213
G1 X178.401 Y157.973 E.11899
G3 X178.401 Y161.849 I-3.525 J1.938 E.12427
G1 X178.401 Y163.201 E.04153
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X177.173 Y163.201 E.03773
G3 X172.65 Y163.201 I-2.261 J-3.324 E.14759
G1 X171.421 Y163.201 E.03779
G1 X171.421 Y161.847 E.04159
G3 X171.421 Y157.973 I3.514 J-1.937 E.12423
G1 X171.421 Y155.284 E.08262
M204 S10000
G1 X170.94 Y154.567 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.455014
G1 F2291
M204 S8000
G1 X171.129 Y154.411 E.00822
; LINE_WIDTH: 0.421348
G1 X171.321 Y154.259 E.00756
; LINE_WIDTH: 0.378973
G1 X171.517 Y154.109 E.00676
; LINE_WIDTH: 0.341703
G1 X171.616 Y154.035 E.00301
; LINE_WIDTH: 0.313949
G1 X171.716 Y153.962 E.00273
; LINE_WIDTH: 0.283926
G1 X171.817 Y153.89 E.00245
; LINE_WIDTH: 0.251651
G1 X171.919 Y153.817 E.00212
; LINE_WIDTH: 0.235309
G1 X172.016 Y153.751 E.00184
M204 S10000
G1 X170.94 Y154.567 F60000
; LINE_WIDTH: 0.504497
G1 F2291
M204 S8000
G2 X169.101 Y156.691 I4.46 J5.72 E.10637
; LINE_WIDTH: 0.537804
G2 X168.326 Y158.87 I6.009 J3.361 E.0937
; LINE_WIDTH: 0.597478
G1 X168.29 Y159.108 E.01085
G2 X168.227 Y160.021 I7.494 J.978 E.04139
G1 X168.226 Y167.105 E.32014
; WIPE_START
G1 F6491.656
G1 X168.226 Y165.105 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.91 Y162.66 Z9 F60000
G1 Z8.6
G1 E.8 F1800
; LINE_WIDTH: 0.403959
G1 F2291
M204 S8000
G1 X173.532 Y162.791 E.01872
; LINE_WIDTH: 0.461895
G1 X173.586 Y162.795 E.00186
; LINE_WIDTH: 0.481257
G2 X176.135 Y162.84 I1.325 J-2.878 E.09371
G1 X176.258 Y162.784 E.00482
M204 S10000
G1 X176.262 Y162.759 F60000
; LINE_WIDTH: 0.446081
G1 F2291
M204 S8000
G1 X176.258 Y162.784 E.00085
G1 X176.352 Y162.783 E.00307
; LINE_WIDTH: 0.394627
G1 X176.894 Y162.673 E.01585
M204 S10000
G1 X176.58 Y162.378 F60000
; LINE_WIDTH: 0.104904
G1 F2291
M204 S8000
G1 X176.494 Y162.448 E.00056
; LINE_WIDTH: 0.136372
G1 X176.343 Y162.563 E.00145
; LINE_WIDTH: 0.182214
G1 X176.325 Y162.596 E.00042
; LINE_WIDTH: 0.224364
G1 X176.308 Y162.629 E.00055
; LINE_WIDTH: 0.266514
G1 X176.29 Y162.662 E.00068
; LINE_WIDTH: 0.308663
G1 X176.272 Y162.695 E.00081
; LINE_WIDTH: 0.339741
G1 X176.27 Y162.707 E.00031
; LINE_WIDTH: 0.371583
G1 X176.266 Y162.733 E.0007
; LINE_WIDTH: 0.415288
G1 X176.262 Y162.759 E.00079
; WIPE_START
G1 F9667.874
G1 X176.266 Y162.733 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X177.853 Y161.613 Z9 F60000
G1 Z8.6
G1 E.8 F1800
; LINE_WIDTH: 0.328376
G1 F2291
M204 S8000
G1 X177.952 Y161.046 E.0134
; LINE_WIDTH: 0.361046
G1 X177.95 Y160.979 E.00173
; LINE_WIDTH: 0.409697
G1 X177.948 Y160.913 E.00199
; LINE_WIDTH: 0.48065
G3 X177.967 Y160.77 I.26 J-.038 E.00518
G2 X177.691 Y158.376 I-3.075 J-.858 E.08816
G1 X177.367 Y158.254 E.01233
; WIPE_START
G1 F8224.251
G1 X177.691 Y158.376 E-.13136
G1 X177.812 Y158.623 E-.10441
G1 X177.928 Y158.925 E-.12299
G1 X178.012 Y159.23 E-.12026
G1 X178.062 Y159.527 E-.11454
G1 X178.085 Y159.885 E-.13622
G1 X178.082 Y159.964 E-.03023
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.056 Y155.18 Z9 F60000
G1 Z8.6
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.50108
G1 F2291
M204 S8000
G1 X175.736 Y155.226 E.02543
G1 X176 Y155.281 E.01008
G1 X176 Y154.753 E.01971
G2 X174.502 Y154.771 I-.628 J10.081 E.05597
; LINE_WIDTH: 0.463617
G2 X173.79 Y154.898 I2.647 J16.96 E.02482
G1 X173.79 Y155.32 E.01448
G1 X174.542 Y155.2 E.02613
G1 X174.996 Y155.182 E.01558
M204 S10000
G1 X176.425 Y155.853 F60000
; LINE_WIDTH: 0.41999
G1 F2291
M204 S8000
G1 X176.425 Y154.328 E.04687
G1 X175.054 Y154.328 E.04215
G1 X174.436 Y154.371 E.01902
G1 X173.634 Y154.527 E.02513
G1 X173.396 Y154.606 E.00769
G1 X173.396 Y155.849 E.03819
G1 X173.956 Y155.682 E.01796
G3 X176.288 Y155.8 I.929 J4.728 E.07246
G1 X176.369 Y155.832 E.00269
M204 S10000
G1 X176.764 Y156.413 F60000
G1 F2291
M204 S8000
G1 X176.802 Y156.413 E.00117
G1 X176.802 Y153.951 E.07565
G1 X175.041 Y153.951 E.05414
G1 X174.387 Y153.997 E.02013
G1 X173.538 Y154.162 E.02659
G1 X173.019 Y154.334 E.01679
G1 X173.019 Y156.434 E.06453
G3 X174.632 Y155.975 I1.889 J3.569 E.05191
G1 X174.986 Y155.964 E.01088
G1 X175.665 Y156.025 E.02095
G3 X176.709 Y156.389 I-.692 J3.666 E.0341
; WIPE_START
G1 F9547.299
G1 X176.189 Y156.164 E-.21523
G1 X175.665 Y156.025 E-.20606
G1 X174.986 Y155.964 E-.25915
G1 X174.777 Y155.971 E-.07955
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X177.805 Y153.227 Z9 F60000
G1 Z8.6
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.600354
G1 F2291
M204 S8000
G1 X182.105 Y153.226 E.19532
; WIPE_START
G1 F6458.171
G1 X180.105 Y153.226 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X173.769 Y157.481 Z9 F60000
G1 X172.307 Y158.463 Z9
G1 Z8.6
G1 E.8 F1800
; LINE_WIDTH: 0.104775
G1 F2291
M204 S8000
G1 X172.246 Y158.553 E.00055
; LINE_WIDTH: 0.132168
G1 X172.16 Y158.688 E.00116
; LINE_WIDTH: 0.175899
G1 X172.075 Y158.829 E.00178
; LINE_WIDTH: 0.223782
G1 X172.044 Y158.849 E.00056
; LINE_WIDTH: 0.270592
G1 X172.012 Y158.87 E.0007
; LINE_WIDTH: 0.317403
G1 X171.981 Y158.891 E.00085
; LINE_WIDTH: 0.364213
G1 X171.949 Y158.912 E.00099
; LINE_WIDTH: 0.411023
G1 X171.917 Y158.932 E.00113
; LINE_WIDTH: 0.457833
G1 X171.886 Y158.953 E.00128
; LINE_WIDTH: 0.463264
G1 X171.878 Y158.916 E.0013
; LINE_WIDTH: 0.427313
G1 X171.871 Y158.878 E.00119
; LINE_WIDTH: 0.391362
G1 X171.864 Y158.841 E.00108
; LINE_WIDTH: 0.355565
G1 X171.869 Y158.777 E.00164
; LINE_WIDTH: 0.329098
G1 X171.971 Y158.204 E.01358
M204 S10000
G1 X171.886 Y158.953 F60000
; LINE_WIDTH: 0.481127
G1 F2291
M204 S8000
G1 X171.86 Y159.034 E.00302
G2 X171.885 Y160.869 I3.043 J.877 E.06651
; LINE_WIDTH: 0.456943
G1 X171.88 Y160.928 E.00198
; LINE_WIDTH: 0.408765
G1 X171.874 Y160.986 E.00175
; LINE_WIDTH: 0.360586
G1 X171.869 Y161.044 E.00152
; LINE_WIDTH: 0.327502
G1 X171.964 Y161.602 E.01311
M204 S10000
G1 X172.305 Y161.357 F60000
; LINE_WIDTH: 0.110784
G1 F2291
M204 S8000
G1 X172.217 Y161.223 E.00088
; LINE_WIDTH: 0.145568
G1 X172.132 Y161.088 E.00133
; LINE_WIDTH: 0.183494
G1 X172.077 Y160.994 E.00125
; LINE_WIDTH: 0.21713
G1 X172.042 Y160.952 E.00078
; LINE_WIDTH: 0.259815
G1 X172.01 Y160.935 E.00063
; LINE_WIDTH: 0.308976
G1 X171.979 Y160.919 E.00077
; LINE_WIDTH: 0.358138
G1 X171.947 Y160.902 E.00091
; LINE_WIDTH: 0.4073
G1 X171.916 Y160.886 E.00105
; LINE_WIDTH: 0.456462
G1 X171.885 Y160.869 E.0012
; CHANGE_LAYER
; Z_HEIGHT: 8.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F8705.289
G1 X171.916 Y160.886 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 44/58
; update layer progress
M73 L44
M991 S0 P43 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 2
M204 S10000
G17
G3 Z9 I-.768 J.944 P1  F60000
G1 X172.659 Y161.49 Z9
G1 Z8.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2266
M204 S8000
G1 X172.635 Y161.453 E.00148
G3 X174.767 Y157.162 I2.278 J-1.543 E.19286
G1 X174.908 Y157.158 E.0047
G3 X172.776 Y161.643 I.004 J2.751 E.36799
G1 X172.695 Y161.538 E.00438
; COOLING_NODE: 2
M204 S250
G1 X172.973 Y161.254 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2266
M204 S5000
G1 X172.957 Y161.231 E.00087
G3 X174.787 Y157.554 I1.954 J-1.321 E.15316
G1 X174.905 Y157.551 E.00363
G3 X173.244 Y161.58 I.005 J2.359 E.28474
G1 X173.012 Y161.3 E.01118
; COOLING_NODE: 2
; WIPE_START
G1 F9547.055
M204 S8000
G1 X172.957 Y161.231 E-.03352
G1 X172.739 Y160.835 E-.17194
G1 X172.621 Y160.482 E-.14127
G1 X172.554 Y160.034 E-.1722
G1 X172.574 Y159.582 E-.17177
G1 X172.616 Y159.405 E-.0693
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.627 Y157.16 Z9.2 F60000
G1 Z8.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2266
M204 S8000
G1 X172.627 Y154.06 E.10285
G3 X175.028 Y153.56 I2.525 J6.116 E.08183
G1 X177.195 Y153.56 E.07186
G1 X177.195 Y157.154 E.11922
G2 X172.674 Y157.123 I-2.28 J2.809 E.16199
; COOLING_NODE: 2
; WIPE_START
G1 F8843.478
G1 X172.643 Y155.123 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.75 Y153.58 Z9.2 F60000
G1 Z8.8
G1 E.8 F1800
G1 F2266
M204 S8000
G1 X172.867 Y153.536 E.00415
G3 X175.021 Y153.153 I2.319 J6.794 E.07284
G1 X177.602 Y153.153 E.08561
G1 X177.602 Y157.958 E.1594
G1 X177.434 Y158.014 E.00585
G2 X172.384 Y158.014 I-2.525 J1.901 E.19409
G1 X172.22 Y157.957 E.00575
G1 X172.22 Y153.793 E.13812
G1 X172.694 Y153.602 E.01696
; COOLING_NODE: 2
; WIPE_START
G1 F8843.478
G1 X172.867 Y153.536 E-.07036
G1 X173.57 Y153.331 E-.2782
G1 X174.291 Y153.204 E-.27824
G1 X174.641 Y153.18 E-.1332
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X176.993 Y160.441 Z9.2 F60000
G1 X177.436 Y161.808 Z9.2
G1 Z8.8
G1 E.8 F1800
G1 F2266
M204 S8000
G1 X177.602 Y161.864 E.00581
G1 X177.602 Y162.402 E.01782
G1 X176.874 Y162.402 E.02413
G2 X177.398 Y161.855 I-3.139 J-3.533 E.02515
; COOLING_NODE: 2
; WIPE_START
G1 F8843.478
G1 X177.602 Y161.864 E-.07736
G1 X177.602 Y162.402 E-.20413
G1 X176.874 Y162.402 E-.27639
G1 X177.254 Y162.029 E-.20212
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.387 Y161.808 Z9.2 F60000
G1 Z8.8
G1 E.8 F1800
G1 F2266
M204 S8000
G1 X172.455 Y161.899 E.00376
G2 X172.956 Y162.402 I3.03 J-2.518 E.02358
G1 X172.22 Y162.402 E.02442
G1 X172.22 Y161.863 E.01786
G1 X172.33 Y161.827 E.00386
; COOLING_NODE: 2
; WIPE_START
G1 F8843.478
G1 X172.455 Y161.899 E-.05465
G1 X172.683 Y162.151 E-.12917
G1 X172.956 Y162.402 E-.14089
G1 X172.22 Y162.402 E-.27972
G1 X172.22 Y161.992 E-.15558
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.815 Y154.37 Z9.2 F60000
G1 X171.813 Y154.326 Z9.2
G1 Z8.8
G1 E.8 F1800
G1 F2266
M204 S8000
G1 X170.603 Y155.449 E.05476
G2 X168.709 Y159.903 I4.331 J4.472 E.16491
G1 X168.709 Y167.309 E.24565
G1 X167.745 Y167.309 E.03197
G1 X167.746 Y160.014 E.24199
G3 X175.014 Y152.746 I7.408 J.141 E.37675
G1 X182.309 Y152.745 E.24199
G1 X182.309 Y153.709 E.03197
G1 X178.009 Y153.709 E.14264
G1 X178.009 Y158.066 E.14456
G3 X178.009 Y161.757 I-3.166 J1.846 E.12831
G1 X178.009 Y162.809 E.03487
G1 X177.06 Y162.809 E.03148
M73 P84 R2
G3 X172.762 Y162.809 I-2.149 J-2.966 E.15235
G1 X171.813 Y162.809 E.03149
G1 X171.813 Y161.755 E.03494
G3 X171.813 Y158.069 I3.152 J-1.843 E.12818
G1 X171.813 Y154.386 E.12218
; COOLING_NODE: 0
M204 S250
G1 X171.421 Y155.225 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1992
M204 S5000
G2 X169.983 Y156.833 I4.901 J5.828 E.06652
G2 X169.101 Y159.908 I4.977 J3.092 E.09957
G1 X169.101 Y167.701 E.23944
G1 X167.353 Y167.701 E.05371
G1 X167.354 Y160.007 E.23642
G3 X175.007 Y152.354 I7.801 J.148 E.36747
G1 X182.701 Y152.353 E.23642
G1 X182.701 Y154.101 E.05371
G1 X178.401 Y154.101 E.13213
G1 X178.401 Y157.973 E.11899
G3 X178.401 Y161.849 I-3.517 J1.938 E.12428
G1 X178.401 Y163.201 E.04153
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X177.172 Y163.201 E.03775
G3 X172.649 Y163.201 I-2.261 J-3.323 E.1476
G1 X171.421 Y163.201 E.03776
G1 X171.421 Y161.848 E.04155
G3 X171.421 Y157.974 I3.507 J-1.937 E.12425
G1 X171.421 Y155.285 E.08264
M204 S10000
G1 X170.756 Y154.725 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.512639
G1 F2266
M204 S8000
G2 X168.545 Y157.975 I4.37 J5.35 E.15256
; LINE_WIDTH: 0.560366
G2 X168.244 Y159.572 I6.409 J2.035 E.06871
; LINE_WIDTH: 0.598437
G2 X168.227 Y160.022 I8.613 J.546 E.02038
G1 X168.227 Y167.105 E.32064
; WIPE_START
G1 F6480.459
G1 X168.227 Y165.105 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X170.644 Y157.865 Z9.2 F60000
G1 X172.016 Y153.753 Z9.2
G1 Z8.8
G1 E.8 F1800
; LINE_WIDTH: 0.234361
G1 F2266
M204 S8000
G1 X171.92 Y153.818 E.00181
; LINE_WIDTH: 0.250581
G1 X171.818 Y153.89 E.00211
; LINE_WIDTH: 0.282884
G1 X171.717 Y153.963 E.00244
; LINE_WIDTH: 0.312872
G1 X171.617 Y154.036 E.00272
; LINE_WIDTH: 0.340555
G1 X171.518 Y154.11 E.003
; LINE_WIDTH: 0.377766
G1 X171.322 Y154.26 E.00674
; LINE_WIDTH: 0.420027
G1 X171.13 Y154.412 E.00751
; LINE_WIDTH: 0.465988
G2 X170.756 Y154.725 I8.776 J10.865 E.01682
; WIPE_START
G1 F8509.285
G1 X171.13 Y154.412 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.238 Y158.179 Z9.2 F60000
G1 Z8.8
G1 E.8 F1800
; LINE_WIDTH: 0.481202
G1 F2266
M204 S8000
G1 X172.036 Y158.564 E.01552
G1 X171.907 Y158.883 E.0123
G2 X172.237 Y161.643 I3.069 J1.033 E.10261
; WIPE_START
G1 F8213.901
G1 X172.039 Y161.262 E-.16325
G1 X171.926 Y160.991 E-.11151
G1 X171.829 Y160.674 E-.12594
G1 X171.756 Y160.26 E-.15996
G1 X171.736 Y159.909 E-.13334
G1 X171.746 Y159.736 E-.066
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.97 Y162.699 Z9.2 F60000
G1 Z8.8
G1 E.8 F1800
; LINE_WIDTH: 0.420475
G1 F2266
M204 S8000
G1 X173.53 Y162.795 E.01749
; LINE_WIDTH: 0.48084
G1 X173.589 Y162.796 E.00211
G2 X176.247 Y162.79 I1.322 J-2.886 E.09787
; LINE_WIDTH: 0.460945
G1 X176.298 Y162.787 E.00174
; LINE_WIDTH: 0.400971
G1 X176.929 Y162.65 E.01885
M204 S10000
G1 X176.537 Y162.407 F60000
; LINE_WIDTH: 0.104821
G1 F2266
M204 S8000
G1 X176.451 Y162.475 E.00055
; LINE_WIDTH: 0.132287
G1 X176.323 Y162.569 E.00116
; LINE_WIDTH: 0.175955
G1 X176.31 Y162.602 E.00038
; LINE_WIDTH: 0.223738
G1 X176.298 Y162.635 E.00052
; LINE_WIDTH: 0.27152
G1 X176.286 Y162.668 E.00065
; LINE_WIDTH: 0.319302
G1 X176.274 Y162.701 E.00079
; LINE_WIDTH: 0.367085
G1 X176.261 Y162.734 E.00093
; LINE_WIDTH: 0.414867
G1 X176.249 Y162.766 E.00106
; LINE_WIDTH: 0.459451
G1 X176.247 Y162.79 E.00081
M204 S10000
G1 X177.583 Y161.643 F60000
; LINE_WIDTH: 0.481056
G1 F2266
M204 S8000
G2 X177.857 Y158.729 I-2.714 J-1.725 E.10848
G1 X177.585 Y158.178 E.02195
M204 S10000
G1 X177.398 Y157.59 F60000
; LINE_WIDTH: 0.106162
G1 F2266
M204 S8000
G1 X177.28 Y157.49 E.0008
; WIPE_START
G1 F15000
G1 X177.398 Y157.59 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X176.802 Y156.458 Z9.2 F60000
G1 Z8.8
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F2266
M204 S8000
G1 X176.802 Y153.952 E.07701
G1 X175.042 Y153.952 E.0541
G1 X174.389 Y153.998 E.02011
G1 X173.539 Y154.163 E.02659
G1 X173.019 Y154.336 E.01684
G1 X173.019 Y156.435 E.06448
G1 X173.663 Y156.154 E.0216
G1 X174.223 Y156.016 E.01771
G1 X174.896 Y155.952 E.02077
G1 X175.648 Y156.022 E.02322
G1 X176.379 Y156.234 E.0234
G1 X176.749 Y156.43 E.01287
M204 S10000
G1 X176.425 Y155.855 F60000
G1 F2266
M204 S8000
G1 X176.425 Y154.329 E.04687
G1 X175.055 Y154.329 E.04211
G1 X174.438 Y154.373 E.019
G1 X173.635 Y154.529 E.02514
G1 X173.396 Y154.608 E.00774
G1 X173.396 Y155.858 E.03839
G1 X174.134 Y155.649 E.02357
G1 X174.866 Y155.576 E.0226
G1 X175.684 Y155.646 E.02524
G1 X176.368 Y155.838 E.0218
M204 S10000
G1 X176.001 Y155.286 F60000
; LINE_WIDTH: 0.496797
G1 F2266
M204 S8000
G1 X176.001 Y154.754 E.01969
G2 X174.504 Y154.771 I-.635 J9.717 E.05542
; LINE_WIDTH: 0.462176
G2 X173.789 Y154.899 I2.135 J13.989 E.0248
G1 X173.789 Y155.328 E.01465
G1 X174.536 Y155.198 E.02588
G1 X175.056 Y155.176 E.01779
; LINE_WIDTH: 0.502429
G1 X175.725 Y155.224 E.02513
G1 X175.942 Y155.273 E.00832
; WIPE_START
G1 F7834.452
G1 X175.725 Y155.224 E-.18909
G1 X175.056 Y155.176 E-.57091
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X177.805 Y153.227 Z9.2 F60000
G1 Z8.8
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.599124
G1 F2266
M204 S8000
G1 X182.105 Y153.227 E.19489
; CHANGE_LAYER
; Z_HEIGHT: 9
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F6472.453
G1 X180.105 Y153.227 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 45/58
; update layer progress
M73 L45
M991 S0 P44 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 2
M204 S10000
G17
G3 Z9.2 I-.905 J-.813 P1  F60000
G1 X172.668 Y161.502 Z9.2
G1 Z9
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2280
M204 S8000
G1 X172.635 Y161.453 E.00195
G3 X174.766 Y157.162 I2.277 J-1.544 E.19287
G1 X174.896 Y157.158 E.00433
G3 X172.783 Y161.652 I.016 J2.751 E.36799
G1 X172.704 Y161.55 E.00427
; COOLING_NODE: 2
M204 S250
G1 X172.982 Y161.264 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2280
M204 S5000
G1 X172.956 Y161.232 E.00127
G3 X174.787 Y157.554 I1.954 J-1.322 E.15319
G1 X174.895 Y157.551 E.0033
G3 X173.243 Y161.579 I.016 J2.359 E.2851
G1 X173.02 Y161.31 E.01071
; COOLING_NODE: 2
; WIPE_START
G1 F9547.055
M204 S8000
G1 X172.956 Y161.232 E-.03849
G1 X172.739 Y160.834 E-.17219
G1 X172.654 Y160.601 E-.09431
G1 X172.594 Y160.361 E-.09412
G1 X172.551 Y159.911 E-.17176
G1 X172.594 Y159.46 E-.17188
G1 X172.605 Y159.416 E-.01726
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.627 Y157.168 Z9.4 F60000
G1 Z9
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2280
M204 S8000
G1 X172.627 Y154.061 E.10306
G3 X175.029 Y153.562 I2.526 J6.118 E.08187
G1 X177.195 Y153.561 E.07183
G1 X177.195 Y157.16 E.11939
G2 X172.674 Y157.131 I-2.279 J2.809 E.16199
; COOLING_NODE: 2
; WIPE_START
G1 F8843.478
G1 X172.643 Y155.131 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.751 Y153.581 Z9.4 F60000
G1 Z9
G1 E.8 F1800
G1 F2280
M204 S8000
G1 X172.869 Y153.538 E.00415
G3 X175.022 Y153.154 I2.32 J6.795 E.07284
G1 X177.602 Y153.154 E.08557
G1 X177.602 Y157.959 E.15939
G1 X177.434 Y158.014 E.00584
G2 X172.384 Y158.014 I-2.525 J1.9 E.19409
G1 X172.22 Y157.957 E.00576
G1 X172.22 Y153.795 E.13806
G1 X172.696 Y153.604 E.01701
; COOLING_NODE: 2
; WIPE_START
G1 F8843.478
G1 X172.869 Y153.538 E-.07037
G1 X173.572 Y153.333 E-.27828
G1 X174.292 Y153.206 E-.27787
G1 X174.642 Y153.181 E-.13348
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X176.992 Y160.443 Z9.4 F60000
G1 X177.434 Y161.809 Z9.4
G1 Z9
G1 E.8 F1800
G1 F2280
M204 S8000
G1 X177.602 Y161.864 E.00586
G1 X177.602 Y162.402 E.01784
G1 X176.874 Y162.402 E.02413
G2 X177.396 Y161.855 I-2.984 J-3.377 E.0251
; COOLING_NODE: 2
; WIPE_START
G1 F8843.478
G1 X177.602 Y161.864 E-.07801
G1 X177.602 Y162.402 E-.20434
G1 X176.874 Y162.402 E-.27642
G1 X177.252 Y162.031 E-.20123
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.387 Y161.807 Z9.4 F60000
G1 Z9
G1 E.8 F1800
G1 F2280
M204 S8000
G1 X172.463 Y161.909 E.00421
G2 X172.947 Y162.402 I3.522 J-2.976 E.02294
G1 X172.22 Y162.402 E.02413
G1 X172.22 Y161.863 E.01788
G1 X172.33 Y161.826 E.00386
; COOLING_NODE: 2
; WIPE_START
G1 F8843.478
G1 X172.463 Y161.909 E-.05945
G1 X172.677 Y162.145 E-.12103
G1 X172.947 Y162.402 E-.14176
G1 X172.22 Y162.402 E-.2764
G1 X172.22 Y161.977 E-.16136
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.814 Y154.355 Z9.4 F60000
G1 X171.813 Y154.325 Z9.4
G1 Z9
G1 E.8 F1800
G1 F2280
M204 S8000
G1 X170.603 Y155.449 E.05478
G2 X168.709 Y159.906 I4.331 J4.471 E.16498
G1 X168.709 Y167.309 E.24557
G1 X167.746 Y167.309 E.03192
G1 X167.747 Y160.015 E.24195
G3 X175.015 Y152.747 I7.415 J.147 E.37666
G1 X182.309 Y152.746 E.24195
M73 P85 R2
G1 X182.309 Y153.709 E.03192
G1 X178.009 Y153.709 E.14264
G1 X178.009 Y158.066 E.14456
G3 X178.009 Y161.755 I-3.177 J1.844 E.12818
G1 X178.009 Y162.809 E.03495
G1 X177.06 Y162.809 E.03146
G3 X172.762 Y162.809 I-2.149 J-2.967 E.15236
G1 X171.813 Y162.809 E.03149
G1 X171.813 Y161.756 E.03492
G3 X171.813 Y158.069 I3.174 J-1.843 E.12812
G1 X171.813 Y154.385 E.12221
; COOLING_NODE: 0
M204 S250
G1 X171.421 Y155.224 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1913
M204 S5000
G2 X169.949 Y156.888 I4.864 J5.785 E.06851
G2 X169.101 Y159.909 I5.01 J3.036 E.0976
G1 X169.101 Y167.701 E.23941
G1 X167.354 Y167.701 E.05367
G1 X167.355 Y160.008 E.23638
G3 X175.008 Y152.355 I7.808 J.155 E.36739
G1 X182.701 Y152.354 E.23638
G1 X182.701 Y154.101 E.05367
G1 X178.401 Y154.101 E.13213
G1 X178.401 Y157.973 E.11899
G3 X178.401 Y161.848 I-3.535 J1.938 E.12421
G1 X178.401 Y163.201 E.04156
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X177.172 Y163.201 E.03775
G3 X172.649 Y163.201 I-2.261 J-3.325 E.1476
G1 X171.421 Y163.201 E.03776
G1 X171.421 Y161.849 E.04155
G3 X171.421 Y157.974 I3.533 J-1.937 E.12419
G1 X171.421 Y155.284 E.08265
M204 S10000
G1 X170.942 Y154.567 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.502022
G1 F2280
M204 S8000
G2 X168.988 Y156.904 I4.419 J5.679 E.11481
; LINE_WIDTH: 0.537094
G2 X168.327 Y158.871 I6.077 J3.136 E.0839
; LINE_WIDTH: 0.594987
G2 X168.228 Y160.023 I7.34 J1.214 E.05207
G1 X168.227 Y167.105 E.31858
; WIPE_START
G1 F6520.956
G1 X168.228 Y165.105 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X170.644 Y157.865 Z9.4 F60000
G1 X172.016 Y153.753 Z9.4
G1 Z9
G1 E.8 F1800
; LINE_WIDTH: 0.231706
G1 F2280
M204 S8000
G1 X171.921 Y153.818 E.00178
; LINE_WIDTH: 0.248027
G1 X171.819 Y153.89 E.00208
; LINE_WIDTH: 0.280337
G1 X171.718 Y153.963 E.00241
; LINE_WIDTH: 0.310395
G1 X171.618 Y154.036 E.0027
; LINE_WIDTH: 0.338186
G1 X171.518 Y154.11 E.00298
; LINE_WIDTH: 0.3755
G1 X171.322 Y154.26 E.0067
; LINE_WIDTH: 0.417856
G1 X171.131 Y154.412 E.00746
; LINE_WIDTH: 0.451449
G1 X170.942 Y154.567 E.00815
; WIPE_START
G1 F8812.121
G1 X171.131 Y154.412 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.238 Y158.179 Z9.4 F60000
G1 Z9
G1 E.8 F1800
; LINE_WIDTH: 0.481283
G1 F2280
M204 S8000
G1 X172.099 Y158.437 E.01049
G2 X172.236 Y161.643 I2.852 J1.483 E.11999
; WIPE_START
G1 F8212.37
G1 X171.995 Y161.166 E-.20308
G1 X171.877 Y160.845 E-.12998
G1 X171.793 Y160.51 E-.13094
G1 X171.74 Y160.048 E-.17682
G1 X171.75 Y159.735 E-.11918
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.886 Y162.646 Z9.4 F60000
G1 Z9
G1 E.8 F1800
; LINE_WIDTH: 0.385871
G1 F2280
M204 S8000
G1 X173.458 Y162.781 E.01642
; LINE_WIDTH: 0.41579
G1 X173.522 Y162.791 E.00198
; LINE_WIDTH: 0.480806
G1 X173.577 Y162.79 E.00196
G2 X176.247 Y162.79 I1.335 J-2.883 E.09832
; LINE_WIDTH: 0.458485
G1 X176.249 Y162.765 E.00084
; LINE_WIDTH: 0.41309
G1 X176.261 Y162.733 E.00105
; LINE_WIDTH: 0.365564
G1 X176.274 Y162.7 E.00092
; LINE_WIDTH: 0.318037
G1 X176.286 Y162.667 E.00078
; LINE_WIDTH: 0.270511
G1 X176.298 Y162.635 E.00065
; LINE_WIDTH: 0.222985
G1 X176.311 Y162.602 E.00051
; LINE_WIDTH: 0.175458
G1 X176.323 Y162.569 E.00038
; LINE_WIDTH: 0.13214
G1 X176.45 Y162.475 E.00115
; LINE_WIDTH: 0.104816
G1 X176.537 Y162.407 E.00055
M204 S10000
G1 X176.931 Y162.649 F60000
; LINE_WIDTH: 0.400955
G1 F2280
M204 S8000
G1 X176.298 Y162.787 E.01889
; LINE_WIDTH: 0.460925
G1 X176.247 Y162.79 E.00174
M204 S10000
G1 X177.584 Y161.644 F60000
; LINE_WIDTH: 0.481198
G1 F2280
M204 S8000
G2 X177.852 Y158.717 I-2.73 J-1.725 E.10896
G1 X177.585 Y158.179 E.02146
; WIPE_START
G1 F8213.965
G1 X177.852 Y158.717 E-.22831
G1 X177.986 Y159.122 E-.16197
G1 X178.055 Y159.474 E-.13637
G1 X178.085 Y159.885 E-.15664
G1 X178.077 Y160.087 E-.0767
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X176.802 Y156.459 Z9.4 F60000
G1 Z9
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F2280
M204 S8000
G1 X176.802 Y153.953 E.07698
G1 X175.043 Y153.954 E.05406
G1 X174.389 Y153.999 E.02014
G1 X173.54 Y154.164 E.02657
G1 X173.019 Y154.338 E.01688
G1 X173.019 Y156.436 E.06448
G1 X173.542 Y156.196 E.0177
G1 X174.238 Y156.014 E.02209
G1 X174.881 Y155.952 E.01985
G1 X175.648 Y156.022 E.02366
G1 X176.368 Y156.23 E.02304
G1 X176.749 Y156.431 E.01323
M204 S10000
G1 X176.425 Y155.854 F60000
G1 F2280
M204 S8000
G1 X176.425 Y154.33 E.04681
G1 X175.056 Y154.331 E.04207
G1 X174.438 Y154.374 E.01903
G1 X173.636 Y154.53 E.02511
G1 X173.396 Y154.61 E.00777
G1 X173.396 Y155.849 E.03808
G1 X174.144 Y155.649 E.02378
G1 X174.851 Y155.576 E.02184
G1 X175.684 Y155.646 E.02568
G1 X176.368 Y155.838 E.02183
M204 S10000
G1 X176.001 Y155.287 F60000
; LINE_WIDTH: 0.496412
G1 F2280
M204 S8000
G1 X176.001 Y154.755 E.01964
G2 X174.504 Y154.772 I-.634 J9.871 E.05537
; LINE_WIDTH: 0.456766
G2 X173.789 Y154.901 I2.273 J14.691 E.02449
G1 X173.789 Y155.334 E.01461
G3 X174.819 Y155.176 I1.115 J3.839 E.03521
; LINE_WIDTH: 0.495733
G1 X175.724 Y155.224 E.03344
G1 X175.942 Y155.273 E.00828
; WIPE_START
G1 F7950.303
G1 X175.724 Y155.224 E-.15078
G1 X174.819 Y155.176 E-.60922
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X177.805 Y153.228 Z9.4 F60000
G1 Z9
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.597894
G1 F2280
M204 S8000
G1 X182.105 Y153.227 E.19446
; CHANGE_LAYER
; Z_HEIGHT: 9.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F6486.8
G1 X180.105 Y153.228 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 46/58
; update layer progress
M73 L46
M991 S0 P45 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 2
M204 S10000
G17
G3 Z9.4 I-.905 J-.814 P1  F60000
G1 X172.671 Y161.497 Z9.4
G1 Z9.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2313
M204 S8000
G1 X172.501 Y161.24 E.01023
G3 X174.63 Y157.173 I2.409 J-1.33 E.18012
G1 X174.869 Y157.159 E.00794
G3 X172.742 Y161.605 I.041 J2.752 E.37097
G1 X172.704 Y161.548 E.00228
; COOLING_NODE: 2
M204 S250
G1 X172.997 Y161.282 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2302
M204 S5000
G1 X172.846 Y161.053 E.00842
G3 X174.667 Y157.563 I2.064 J-1.143 E.14306
G1 X174.878 Y157.551 E.00651
G3 X173.051 Y161.363 I.032 J2.359 E.29456
G1 X173.03 Y161.332 E.00116
; COOLING_NODE: 2
; WIPE_START
G1 F9547.055
M204 S8000
G1 X172.846 Y161.053 E-.12694
G1 X172.707 Y160.756 E-.12467
G1 X172.631 Y160.521 E-.09381
G1 X172.556 Y160.076 E-.17167
G1 X172.568 Y159.622 E-.17221
G1 X172.609 Y159.441 E-.0707
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.627 Y157.165 Z9.6 F60000
G1 Z9.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2313
M204 S8000
G1 X172.627 Y154.063 E.1029
G3 X175.031 Y153.563 I2.527 J6.117 E.08192
G1 X177.195 Y153.562 E.07178
G1 X177.195 Y157.154 E.11914
G2 X172.674 Y157.128 I-2.277 J2.831 E.16186
; COOLING_NODE: 2
; WIPE_START
G1 F8843.478
G1 X172.643 Y155.128 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.22 Y158.21 Z9.6 F60000
G1 Z9.2
G1 E.8 F1800
G1 F2313
M204 S8000
G1 X172.22 Y153.797 E.14639
G3 X175.023 Y153.156 I2.969 J6.536 E.09605
G1 X177.602 Y153.155 E.08552
G1 X177.602 Y158.211 E.16769
G2 X176.246 Y157.047 I-2.899 J2.006 E.0599
G2 X172.526 Y157.838 I-1.331 J2.884 E.13525
G1 X172.258 Y158.163 E.01399
; COOLING_NODE: 2
; WIPE_START
G1 F8843.478
G1 X172.241 Y156.164 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X177.594 Y161.604 Z9.6 F60000
G1 X177.602 Y161.612 Z9.6
G1 Z9.2
G1 E.8 F1800
G1 F2313
M204 S8000
G1 X177.602 Y162.402 E.0262
M73 P86 R2
G1 X176.871 Y162.402 E.02424
G2 X177.565 Y161.66 I-3.411 J-3.888 E.03377
; COOLING_NODE: 2
; WIPE_START
G1 F8843.478
G1 X177.602 Y162.402 E-.28232
G1 X176.871 Y162.402 E-.27764
G1 X177.177 Y162.112 E-.16
G1 X177.246 Y162.033 E-.04004
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.367 Y161.79 Z9.6 F60000
G1 Z9.2
G1 E.8 F1800
G1 F2313
M204 S8000
G1 X172.532 Y161.99 E.0086
G2 X172.954 Y162.402 I3.165 J-2.826 E.01957
G1 X172.22 Y162.402 E.02435
G1 X172.22 Y161.612 E.0262
G1 X172.329 Y161.744 E.00568
; COOLING_NODE: 2
; WIPE_START
G1 F8843.478
G1 X172.532 Y161.99 E-.12133
G1 X172.954 Y162.402 E-.22397
G1 X172.22 Y162.402 E-.27896
G1 X172.22 Y162.044 E-.13574
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.818 Y154.423 Z9.6 F60000
G1 X171.813 Y154.325 Z9.6
G1 Z9.2
G1 E.8 F1800
G1 F2313
M204 S8000
G1 X170.603 Y155.449 E.05478
G2 X168.709 Y159.906 I4.331 J4.472 E.16499
G1 X168.709 Y167.309 E.24557
G1 X167.747 Y167.309 E.03188
G1 X167.749 Y160.018 E.24183
G3 X175.016 Y152.749 I7.409 J.139 E.37681
G1 X182.309 Y152.747 E.24191
G1 X182.309 Y153.709 E.03188
G1 X178.009 Y153.709 E.14264
G1 X178.009 Y158.069 E.14465
G3 X178.009 Y161.752 I-3.146 J1.841 E.12807
G1 X178.009 Y162.809 E.03505
G1 X177.062 Y162.809 E.0314
G3 X172.762 Y162.809 I-2.15 J-2.97 E.15241
G1 X171.813 Y162.809 E.03149
G1 X171.813 Y161.758 E.03486
G3 X171.813 Y158.069 I3.177 J-1.844 E.12819
G1 X171.813 Y154.385 E.1222
; COOLING_NODE: 0
M204 S250
G1 X171.421 Y155.224 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1824
M204 S5000
G2 X169.983 Y156.832 I4.916 J5.841 E.0665
G2 X169.101 Y159.909 I4.95 J3.084 E.09963
G1 X169.101 Y167.701 E.23942
G1 X167.355 Y167.701 E.05363
G1 X167.357 Y160.01 E.23632
G3 X175.009 Y152.357 I7.802 J.148 E.36748
G1 X182.701 Y152.355 E.23634
G1 X182.701 Y154.101 E.05363
G1 X178.401 Y154.101 E.13213
G1 X178.401 Y157.974 E.11902
G3 X178.401 Y161.847 I-3.505 J1.936 E.12421
G1 X178.401 Y163.201 E.04159
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X177.173 Y163.201 E.03773
G3 X172.649 Y163.201 I-2.262 J-3.326 E.14761
G1 X171.421 Y163.201 E.03776
G1 X171.421 Y161.849 E.04153
G3 X171.421 Y157.974 I3.535 J-1.938 E.12421
M73 P86 R1
G1 X171.421 Y155.284 E.08265
M204 S10000
G1 X170.942 Y154.568 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.499322
G1 F2313
M204 S8000
G2 X169.1 Y156.697 I4.42 J5.685 E.10539
; LINE_WIDTH: 0.533221
G1 X168.836 Y157.217 E.02329
G2 X168.328 Y158.877 I6.253 J2.826 E.06954
; LINE_WIDTH: 0.593764
G1 X168.255 Y159.439 E.02543
G1 X168.229 Y160.029 E.02651
G1 X168.228 Y167.105 E.31763
; WIPE_START
G1 F6535.433
G1 X168.228 Y165.105 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.965 Y162.695 Z9.6 F60000
G1 Z9.2
G1 E.8 F1800
; LINE_WIDTH: 0.417891
G1 F2313
M204 S8000
G1 X173.523 Y162.794 E.01732
; LINE_WIDTH: 0.443908
G1 X173.555 Y162.795 E.00105
; LINE_WIDTH: 0.469181
G1 X173.587 Y162.795 E.00112
; LINE_WIDTH: 0.48136
G2 X176.043 Y162.876 I1.325 J-2.902 E.0901
G1 X176.243 Y162.791 E.00777
M204 S10000
G1 X176.254 Y162.759 F60000
; LINE_WIDTH: 0.410327
G1 F2313
M204 S8000
G1 X176.266 Y162.727 E.00102
; LINE_WIDTH: 0.362855
G1 X176.277 Y162.695 E.00089
; LINE_WIDTH: 0.315382
G1 X176.288 Y162.663 E.00076
; LINE_WIDTH: 0.267909
G1 X176.3 Y162.631 E.00062
; LINE_WIDTH: 0.220436
G1 X176.311 Y162.599 E.00049
; LINE_WIDTH: 0.172964
G1 X176.322 Y162.567 E.00036
; LINE_WIDTH: 0.1428
G1 X176.358 Y162.542 E.00035
; LINE_WIDTH: 0.117091
G1 X176.521 Y162.418 E.00124
M204 S10000
G1 X176.352 Y162.784 F60000
; LINE_WIDTH: 0.445366
G1 F2313
M204 S8000
G1 X176.243 Y162.791 E.00359
G1 X176.254 Y162.759 E.00112
M204 S10000
G1 X176.352 Y162.784 F60000
; LINE_WIDTH: 0.399671
G1 F2313
M204 S8000
G1 X176.94 Y162.643 E.01758
; WIPE_START
G1 F10091.075
G1 X176.352 Y162.784 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X177.839 Y161.621 Z9.6 F60000
G1 Z9.2
G1 E.8 F1800
; LINE_WIDTH: 0.269811
G1 F2313
M204 S8000
G1 X177.894 Y161.34 E.00529
; LINE_WIDTH: 0.311591
G1 X177.95 Y161.059 E.00627
; LINE_WIDTH: 0.33497
G1 X177.952 Y161.044 E.00036
; LINE_WIDTH: 0.361377
G1 X177.947 Y160.986 E.00152
; LINE_WIDTH: 0.40925
G1 X177.942 Y160.928 E.00175
; LINE_WIDTH: 0.457123
G1 X177.937 Y160.869 E.00198
; LINE_WIDTH: 0.481215
G2 X178.019 Y159.267 I-3.027 J-.959 E.05792
G1 X178.016 Y159.253 E.00054
G3 X177.945 Y158.917 I1.408 J-.475 E.01229
; LINE_WIDTH: 0.427302
G1 X177.951 Y158.879 E.00119
; LINE_WIDTH: 0.391107
G1 X177.958 Y158.842 E.00108
; LINE_WIDTH: 0.355831
G1 X177.953 Y158.779 E.0016
; LINE_WIDTH: 0.330145
G1 X177.851 Y158.207 E.01362
M204 S10000
G1 X177.398 Y157.591 F60000
; LINE_WIDTH: 0.105916
G1 F2313
M204 S8000
G1 X177.277 Y157.487 E.00082
; WIPE_START
G1 F15000
G1 X177.398 Y157.591 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X176.001 Y155.288 Z9.6 F60000
G1 Z9.2
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.496391
G1 F2313
M204 S8000
G1 X176.001 Y154.757 E.01963
G2 X174.506 Y154.773 I-.641 J9.927 E.0553
; LINE_WIDTH: 0.460477
G2 X173.789 Y154.902 I2.275 J14.7 E.02479
G1 X173.789 Y155.329 E.01452
G1 X174.539 Y155.197 E.02592
G1 X175.066 Y155.178 E.01794
; LINE_WIDTH: 0.500897
G1 X175.651 Y155.213 E.02187
G1 X175.942 Y155.275 E.01111
M204 S10000
G1 X176.425 Y155.863 F60000
; LINE_WIDTH: 0.41999
G1 F2313
M204 S8000
G1 X176.425 Y154.332 E.04705
G1 X175.057 Y154.332 E.04203
G1 X174.44 Y154.375 E.01901
G1 X173.638 Y154.531 E.02511
G1 X173.396 Y154.611 E.00783
G1 X173.396 Y155.86 E.03837
G1 X174.132 Y155.65 E.02351
G1 X174.797 Y155.577 E.02056
G1 X175.471 Y155.612 E.02074
G1 X176.145 Y155.755 E.02119
G1 X176.369 Y155.841 E.00737
M204 S10000
G1 X176.767 Y156.414 F60000
G1 F2313
M204 S8000
G1 X176.799 Y156.427 E.00105
G2 X176.802 Y153.955 I-370.235 J-1.786 E.07596
G1 X175.044 Y153.955 E.05402
G1 X174.391 Y154 E.02013
G1 X173.542 Y154.166 E.02657
G1 X173.019 Y154.339 E.01693
G1 X173.019 Y156.435 E.06439
G1 X173.674 Y156.15 E.02196
G3 X176.712 Y156.391 I1.225 J3.822 E.09603
; WIPE_START
G1 F9547.299
G1 X176.063 Y156.123 E-.26657
G1 X175.448 Y155.988 E-.23955
G1 X174.83 Y155.952 E-.23516
G1 X174.781 Y155.958 E-.01872
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X177.805 Y153.228 Z9.6 F60000
G1 Z9.2
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.596663
G1 F2313
M204 S8000
G1 X182.105 Y153.228 E.19402
; WIPE_START
G1 F6501.209
G1 X180.105 Y153.228 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.489 Y153.723 Z9.6 F60000
G1 X172.016 Y153.754 Z9.6
G1 Z9.2
G1 E.8 F1800
; LINE_WIDTH: 0.22998
G1 F2313
M204 S8000
G1 X171.922 Y153.819 E.00175
; LINE_WIDTH: 0.246316
G1 X171.82 Y153.891 E.00206
; LINE_WIDTH: 0.278538
G1 X171.719 Y153.963 E.00239
; LINE_WIDTH: 0.308609
G1 X171.619 Y154.037 E.00269
; LINE_WIDTH: 0.336532
G1 X171.519 Y154.111 E.00298
; LINE_WIDTH: 0.373772
G1 X171.324 Y154.26 E.00662
; LINE_WIDTH: 0.416039
G1 X171.131 Y154.413 E.00745
; LINE_WIDTH: 0.449733
G1 X170.942 Y154.568 E.00812
; WIPE_START
G1 F8849.291
G1 X171.131 Y154.413 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.964 Y158.22 Z9.6 F60000
G1 Z9.2
G1 E.8 F1800
; LINE_WIDTH: 0.329035
G1 F2313
M204 S8000
G1 X171.869 Y158.777 E.01319
; LINE_WIDTH: 0.361021
G1 X171.874 Y158.835 E.00152
; LINE_WIDTH: 0.409143
G1 X171.879 Y158.894 E.00175
; LINE_WIDTH: 0.457264
G1 X171.884 Y158.952 E.00198
; LINE_WIDTH: 0.481122
G1 X171.841 Y159.105 E.00567
G2 X171.885 Y160.869 I3.056 J.806 E.06388
M204 S10000
G1 X171.913 Y160.879 F60000
; LINE_WIDTH: 0.455618
G1 F2313
M204 S8000
G1 X171.885 Y160.869 E.00102
G1 X171.872 Y160.915 E.00159
; LINE_WIDTH: 0.407078
G1 X171.87 Y160.98 E.00192
; LINE_WIDTH: 0.360512
G1 X171.869 Y161.044 E.00167
; LINE_WIDTH: 0.328523
G1 X171.969 Y161.613 E.01345
M204 S10000
G1 X172.304 Y161.356 F60000
; LINE_WIDTH: 0.110584
G1 F2313
M204 S8000
G1 X172.232 Y161.245 E.00073
; LINE_WIDTH: 0.138306
G1 X172.158 Y161.13 E.00106
; LINE_WIDTH: 0.176026
G1 X172.077 Y160.994 E.00171
; LINE_WIDTH: 0.220304
G1 X172.047 Y160.973 E.00053
; LINE_WIDTH: 0.261728
G1 X172.017 Y160.951 E.00066
; LINE_WIDTH: 0.303153
G1 X171.988 Y160.929 E.00078
; LINE_WIDTH: 0.344577
G1 X171.958 Y160.907 E.00091
; LINE_WIDTH: 0.386002
G1 X171.928 Y160.885 E.00103
; LINE_WIDTH: 0.418997
G1 X171.913 Y160.879 E.00048
M204 S10000
G1 X171.884 Y158.952 F60000
; LINE_WIDTH: 0.457202
G1 F2313
M204 S8000
G1 X171.912 Y158.942 E.00101
; LINE_WIDTH: 0.420725
G1 X171.927 Y158.937 E.00049
; LINE_WIDTH: 0.387498
G1 X171.957 Y158.915 E.00104
; LINE_WIDTH: 0.345759
G1 X171.987 Y158.893 E.00092
; LINE_WIDTH: 0.30402
G1 X172.017 Y158.871 E.00079
; LINE_WIDTH: 0.262281
G1 X172.047 Y158.849 E.00066
; LINE_WIDTH: 0.220542
G1 X172.077 Y158.827 E.00054
; LINE_WIDTH: 0.175459
G1 X172.16 Y158.688 E.00176
; LINE_WIDTH: 0.13111
G1 X172.25 Y158.547 E.0012
; LINE_WIDTH: 0.103769
G1 X172.311 Y158.458 E.00053
; CHANGE_LAYER
; Z_HEIGHT: 9.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F15000
G1 X172.25 Y158.547 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 47/58
; update layer progress
M73 L47
M991 S0 P46 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 2
M204 S10000
G17
G3 Z9.6 I-1.205 J.172 P1  F60000
G1 X172.673 Y161.505 Z9.6
G1 Z9.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2268
M204 S8000
G1 X172.48 Y161.196 E.01208
G3 X174.676 Y157.168 I2.433 J-1.286 E.17991
G1 X174.91 Y157.158 E.00778
G3 X172.714 Y161.565 I.003 J2.752 E.37137
G1 X172.707 Y161.555 E.00043
; COOLING_NODE: 2
M204 S250
G1 X173.003 Y161.295 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2268
M204 S5000
G1 X172.827 Y161.016 E.01015
G3 X174.707 Y157.559 I2.085 J-1.106 E.14295
G1 X174.91 Y157.551 E.00627
G3 X173.038 Y161.344 I.001 J2.36 E.29435
; COOLING_NODE: 2
; WIPE_START
G1 F9547.055
M204 S8000
G1 X172.827 Y161.016 E-.14825
G1 X172.693 Y160.718 E-.12406
G1 X172.621 Y160.481 E-.09412
G1 X172.554 Y160.035 E-.17154
G1 X172.564 Y159.663 E-.14141
G1 X172.606 Y159.455 E-.08062
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.627 Y157.16 Z9.8 F60000
G1 Z9.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2268
M204 S8000
G1 X172.627 Y154.065 E.10267
G3 X175.032 Y153.564 I2.529 J6.116 E.08196
G1 X177.195 Y153.564 E.07174
G1 X177.195 Y157.167 E.11952
M73 P87 R1
G2 X172.674 Y157.123 I-2.288 J2.779 E.16215
; COOLING_NODE: 2
; WIPE_START
G1 F8843.478
G1 X172.643 Y155.123 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.752 Y153.584 Z9.8 F60000
G1 Z9.4
G1 E.8 F1800
G1 F2268
M204 S8000
G1 X172.871 Y153.54 E.00419
G3 X175.025 Y153.157 I2.32 J6.794 E.07285
G1 X177.602 Y153.157 E.08548
G1 X177.602 Y157.958 E.15926
G1 X177.434 Y158.013 E.00586
G2 X172.388 Y158.013 I-2.523 J1.92 E.19359
G1 X172.22 Y157.958 E.00586
G1 X172.22 Y153.798 E.13797
G1 X172.697 Y153.607 E.01705
; COOLING_NODE: 2
; WIPE_START
G1 F8843.478
G1 X172.871 Y153.54 E-.07082
G1 X173.574 Y153.335 E-.27845
G1 X174.295 Y153.208 E-.278
G1 X174.643 Y153.184 E-.13272
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X176.994 Y160.445 Z9.8 F60000
G1 X177.436 Y161.808 Z9.8
G1 Z9.4
G1 E.8 F1800
G1 F2268
M204 S8000
G1 X177.602 Y161.864 E.00581
G1 X177.602 Y162.402 E.01782
G1 X176.874 Y162.402 E.02413
G2 X177.398 Y161.855 I-3.132 J-3.527 E.02515
; COOLING_NODE: 2
; WIPE_START
G1 F8843.478
G1 X177.602 Y161.864 E-.07736
G1 X177.602 Y162.402 E-.20414
G1 X176.874 Y162.402 E-.27645
G1 X177.254 Y162.029 E-.20205
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.384 Y161.807 Z9.8 F60000
G1 Z9.4
G1 E.8 F1800
G1 F2268
M204 S8000
G1 X172.496 Y161.948 E.00599
G2 X172.947 Y162.402 I3.462 J-2.997 E.02123
G1 X172.22 Y162.402 E.02413
G1 X172.22 Y161.864 E.01782
G1 X172.327 Y161.827 E.00376
; COOLING_NODE: 2
; WIPE_START
G1 F8843.478
G1 X172.496 Y161.948 E-.07906
G1 X172.947 Y162.402 E-.24305
G1 X172.22 Y162.402 E-.27642
G1 X172.22 Y161.977 E-.16147
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.814 Y154.355 Z9.8 F60000
G1 X171.813 Y154.325 Z9.8
G1 Z9.4
G1 E.8 F1800
G1 F2268
M204 S8000
G1 X170.603 Y155.449 E.05477
G2 X168.709 Y159.906 I4.329 J4.471 E.16499
G1 X168.709 Y167.309 E.24557
G1 X167.749 Y167.309 E.03184
G1 X167.75 Y160.018 E.24185
G3 X175.017 Y152.75 I7.409 J.141 E.37675
G1 X182.309 Y152.749 E.24186
G1 X182.309 Y153.709 E.03184
G1 X178.009 Y153.709 E.14264
G1 X178.009 Y158.064 E.14446
G3 X178.009 Y161.752 I-3.167 J1.844 E.12822
G1 X178.009 Y162.809 E.03504
G1 X177.059 Y162.809 E.03149
G3 X172.765 Y162.809 I-2.147 J-2.962 E.15224
G1 X171.813 Y162.809 E.03159
G1 X171.813 Y161.752 E.03504
G3 X171.813 Y158.069 I3.152 J-1.842 E.12806
G1 X171.813 Y154.385 E.1222
; COOLING_NODE: 0
M204 S250
G1 X171.421 Y155.224 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1725
M204 S5000
G2 X169.983 Y156.833 I4.91 J5.837 E.0665
G2 X169.101 Y159.909 I4.95 J3.084 E.09962
G1 X169.101 Y167.701 E.23942
G1 X167.357 Y167.701 E.05359
G1 X167.358 Y160.01 E.2363
G3 X175.01 Y152.358 I7.802 J.149 E.36746
G1 X182.701 Y152.357 E.2363
G1 X182.701 Y154.101 E.05359
G1 X178.401 Y154.101 E.13213
G1 X178.401 Y157.972 E.11896
G3 X178.401 Y161.847 I-3.523 J1.938 E.12424
G1 X178.401 Y163.201 E.04159
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X177.172 Y163.201 E.03776
G3 X172.65 Y163.201 I-2.261 J-3.323 E.14756
G1 X171.421 Y163.201 E.03779
G1 X171.421 Y161.847 E.04159
G3 X171.421 Y157.974 I3.512 J-1.937 E.1242
G1 X171.421 Y155.284 E.08265
M204 S10000
G1 X170.943 Y154.569 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.448091
G1 F2268
M204 S8000
G1 X171.132 Y154.413 E.0081
; LINE_WIDTH: 0.414462
G1 X171.324 Y154.261 E.0074
; LINE_WIDTH: 0.372171
G1 X171.52 Y154.111 E.00662
; LINE_WIDTH: 0.334872
G1 X171.62 Y154.037 E.00295
; LINE_WIDTH: 0.307036
G1 X171.72 Y153.964 E.00267
; LINE_WIDTH: 0.277021
G1 X171.821 Y153.891 E.00237
; LINE_WIDTH: 0.244791
G1 X171.922 Y153.819 E.00205
; LINE_WIDTH: 0.228464
G1 X172.016 Y153.755 E.00172
M204 S10000
G1 X170.943 Y154.569 F60000
; LINE_WIDTH: 0.497608
G1 F2268
M204 S8000
G2 X169.101 Y156.697 I4.416 J5.682 E.10496
; LINE_WIDTH: 0.53159
G2 X168.329 Y158.873 I6.056 J3.374 E.09234
; LINE_WIDTH: 0.592492
G1 X168.294 Y159.103 E.01042
G2 X168.229 Y160.027 I7.616 J.995 E.04152
G1 X168.229 Y167.105 E.31699
; WIPE_START
G1 F6550.554
G1 X168.229 Y165.105 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.052 Y158.499 Z9.8 F60000
G1 X172.238 Y158.178 Z9.8
G1 Z9.4
G1 E.8 F1800
; LINE_WIDTH: 0.48121
G1 F2268
M204 S8000
G1 X172.105 Y158.425 E.01002
G2 X172.238 Y161.643 I2.851 J1.494 E.12045
; WIPE_START
G1 F8213.756
G1 X172.019 Y161.22 E-.18085
G1 X171.888 Y160.881 E-.13799
G1 X171.794 Y160.516 E-.14327
G1 X171.74 Y160.072 E-.16993
G1 X171.749 Y159.735 E-.12795
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.996 Y162.715 Z9.8 F60000
G1 Z9.4
G1 E.8 F1800
; LINE_WIDTH: 0.418008
G1 F2268
M204 S8000
G1 X173.529 Y162.791 E.01646
; LINE_WIDTH: 0.481014
G1 X173.574 Y162.79 E.00162
G2 X176.247 Y162.79 I1.336 J-2.877 E.09848
M204 S10000
G1 X176.536 Y162.408 F60000
; LINE_WIDTH: 0.104642
G1 F2268
M204 S8000
G1 X176.451 Y162.474 E.00054
; LINE_WIDTH: 0.131946
G1 X176.323 Y162.569 E.00116
; LINE_WIDTH: 0.17568
G1 X176.31 Y162.602 E.00038
; LINE_WIDTH: 0.223633
G1 X176.298 Y162.635 E.00052
; LINE_WIDTH: 0.271586
G1 X176.286 Y162.668 E.00066
; LINE_WIDTH: 0.319538
G1 X176.273 Y162.701 E.00079
; LINE_WIDTH: 0.367491
G1 X176.261 Y162.734 E.00093
; LINE_WIDTH: 0.415444
G1 X176.249 Y162.767 E.00107
; LINE_WIDTH: 0.459775
G1 X176.247 Y162.79 E.00079
; LINE_WIDTH: 0.461024
G1 X176.298 Y162.788 E.00173
; LINE_WIDTH: 0.401242
G1 X176.929 Y162.65 E.01888
; WIPE_START
G1 F10046.835
G1 X176.298 Y162.788 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X177.581 Y161.643 Z9.8 F60000
G1 Z9.4
G1 E.8 F1800
; LINE_WIDTH: 0.481178
G1 F2268
M204 S8000
G2 X177.79 Y158.574 I-2.709 J-1.725 E.11454
G1 X177.585 Y158.178 E.01593
; WIPE_START
G1 F8214.343
G1 X177.79 Y158.574 E-.16954
G1 X177.943 Y158.969 E-.16081
G1 X178.033 Y159.335 E-.14328
G1 X178.079 Y159.717 E-.14615
G1 X178.075 Y160.086 E-.14022
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X176.802 Y156.46 Z9.8 F60000
G1 Z9.4
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F2268
M204 S8000
G1 X176.802 Y153.956 E.07694
G1 X175.046 Y153.956 E.05398
G1 X174.392 Y154.002 E.02012
G1 X173.543 Y154.167 E.02659
G1 X173.019 Y154.341 E.01696
G1 X173.019 Y156.435 E.06434
G1 X173.546 Y156.195 E.01779
G1 X174.138 Y156.028 E.0189
G1 X174.891 Y155.952 E.02327
G1 X175.649 Y156.022 E.02336
G1 X176.368 Y156.23 E.02302
G1 X176.749 Y156.432 E.01325
M204 S10000
G1 X176.425 Y155.854 F60000
G1 F2268
M204 S8000
G1 X176.425 Y154.333 E.04674
G1 X175.059 Y154.333 E.04199
G1 X174.442 Y154.376 E.01901
G1 X173.639 Y154.532 E.02513
G1 X173.396 Y154.613 E.00786
G1 X173.396 Y155.849 E.03797
G1 X174.037 Y155.665 E.02049
G3 X175.693 Y155.647 I.884 J5.263 E.05109
G1 X176.368 Y155.838 E.02154
M204 S10000
G1 X176.002 Y155.287 F60000
; LINE_WIDTH: 0.495314
G1 F2268
M204 S8000
G1 X176.002 Y154.757 E.01956
G2 X174.507 Y154.775 I-.63 J9.44 E.05515
; LINE_WIDTH: 0.460002
G2 X173.787 Y154.902 I2.27 J15.067 E.02486
G1 X173.787 Y155.329 E.01451
G1 X174.543 Y155.202 E.02605
G1 X175.059 Y155.177 E.01757
; LINE_WIDTH: 0.50064
G1 X175.726 Y155.225 E.02493
G1 X175.943 Y155.274 E.0083
; WIPE_START
G1 F7865.075
G1 X175.726 Y155.225 E-.18982
G1 X175.059 Y155.177 E-.57018
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X177.805 Y153.229 Z9.8 F60000
G1 Z9.4
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.595423
G1 F2268
M204 S8000
G1 X182.105 Y153.229 E.19359
; CHANGE_LAYER
; Z_HEIGHT: 9.6
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F6515.802
G1 X180.105 Y153.229 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 48/58
; update layer progress
M73 L48
M991 S0 P47 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 2
M204 S10000
G17
G3 Z9.8 I-.908 J-.811 P1  F60000
G1 X172.69 Y161.533 Z9.8
G1 Z9.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
M73 P88 R1
G1 F2276
M204 S8000
G1 X172.634 Y161.453 E.00324
G3 X174.766 Y157.162 I2.278 J-1.543 E.19286
G1 X174.903 Y157.158 E.00454
G3 X172.77 Y161.636 I.009 J2.751 E.36842
G1 X172.727 Y161.58 E.00236
; COOLING_NODE: 2
M204 S250
G1 X173.005 Y161.292 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2276
M204 S5000
G1 X172.956 Y161.231 E.0024
G3 X174.787 Y157.554 I1.954 J-1.322 E.15319
G1 X174.901 Y157.551 E.00349
G3 X173.244 Y161.58 I.009 J2.359 E.28486
G1 X173.043 Y161.339 E.00963
; COOLING_NODE: 2
; WIPE_START
G1 F9547.055
M204 S8000
G1 X172.956 Y161.231 E-.05254
G1 X172.827 Y161.019 E-.09453
G1 X172.726 Y160.804 E-.09016
G1 X172.594 Y160.361 E-.17563
G1 X172.551 Y159.911 E-.17194
G1 X172.594 Y159.461 E-.17174
G1 X172.597 Y159.452 E-.00346
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.627 Y157.16 Z10 F60000
G1 Z9.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2276
M204 S8000
G1 X172.627 Y154.067 E.10262
G3 X175.033 Y153.565 I2.53 J6.116 E.082
G1 X177.195 Y153.565 E.0717
G1 X177.195 Y157.166 E.11947
G2 X172.674 Y157.123 I-2.288 J2.806 E.16197
; COOLING_NODE: 2
; WIPE_START
G1 F8843.478
G1 X172.643 Y155.123 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.753 Y153.586 Z10 F60000
G1 Z9.6
G1 E.8 F1800
G1 F2276
M204 S8000
G1 X172.873 Y153.541 E.00423
G3 X175.026 Y153.158 I2.319 J6.795 E.07282
G1 X177.602 Y153.158 E.08545
G1 X177.602 Y157.957 E.1592
G1 X177.438 Y158.014 E.00575
G2 X172.384 Y158.014 I-2.527 J1.915 E.19401
G1 X172.22 Y157.957 E.00576
G1 X172.22 Y153.8 E.13789
G1 X172.698 Y153.608 E.01708
; COOLING_NODE: 2
; WIPE_START
G1 F8843.478
G1 X172.873 Y153.541 E-.0713
G1 X173.575 Y153.336 E-.27808
G1 X174.296 Y153.209 E-.27797
G1 X174.644 Y153.185 E-.13265
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X176.995 Y160.446 Z10 F60000
G1 X177.436 Y161.808 Z10
G1 Z9.6
G1 E.8 F1800
G1 F2276
M204 S8000
G1 X177.602 Y161.864 E.00581
G1 X177.602 Y162.402 E.01782
G1 X176.874 Y162.402 E.02412
G2 X177.398 Y161.855 I-3.151 J-3.543 E.02515
; COOLING_NODE: 2
; WIPE_START
G1 F8843.478
G1 X177.602 Y161.864 E-.07736
G1 X177.602 Y162.402 E-.20414
G1 X176.874 Y162.402 E-.27636
G1 X177.254 Y162.029 E-.20214
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.388 Y161.809 Z10 F60000
G1 Z9.6
G1 E.8 F1800
G1 F2276
M204 S8000
G1 X172.449 Y161.892 E.00344
G2 X172.956 Y162.402 I3.028 J-2.503 E.02388
G1 X172.22 Y162.402 E.02442
G1 X172.22 Y161.864 E.01784
G1 X172.331 Y161.827 E.00387
; COOLING_NODE: 2
; WIPE_START
G1 F8843.478
G1 X172.449 Y161.892 E-.0513
G1 X172.682 Y162.151 E-.13246
G1 X172.956 Y162.402 E-.14098
G1 X172.22 Y162.402 E-.27971
G1 X172.22 Y161.992 E-.15555
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.815 Y154.371 Z10 F60000
G1 X171.813 Y154.325 Z10
G1 Z9.6
G1 E.8 F1800
G1 F2276
M204 S8000
G1 X170.602 Y155.449 E.05479
G2 X168.709 Y159.906 I4.319 J4.466 E.16499
G1 X168.709 Y167.309 E.24557
G1 X167.75 Y167.309 E.0318
G1 X167.751 Y160.019 E.2418
G3 X175.019 Y152.751 I7.408 J.14 E.37677
G1 X182.309 Y152.75 E.24183
G1 X182.309 Y153.709 E.0318
G1 X178.009 Y153.709 E.14264
G1 X178.009 Y158.064 E.14446
G3 X178.009 Y161.752 I-3.167 J1.844 E.12822
G1 X178.009 Y162.809 E.03504
G1 X177.062 Y162.809 E.0314
G3 X172.762 Y162.809 I-2.15 J-2.968 E.15243
G1 X171.813 Y162.809 E.03149
G1 X171.813 Y161.752 E.03504
G3 X171.813 Y158.069 I3.168 J-1.842 E.12801
G1 X171.813 Y154.385 E.1222
; COOLING_NODE: 0
M204 S250
G1 X171.421 Y155.224 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1619
M204 S5000
G2 X169.931 Y156.917 I4.843 J5.763 E.06955
G2 X169.101 Y159.909 I5.032 J3.008 E.09656
G1 X169.101 Y167.701 E.23942
G1 X167.358 Y167.701 E.05355
G1 X167.359 Y160.012 E.23626
G3 X175.012 Y152.359 I7.801 J.148 E.36748
G1 X182.701 Y152.358 E.23627
G1 X182.701 Y154.101 E.05355
G1 X178.401 Y154.101 E.13213
G1 X178.401 Y157.972 E.11896
G3 X178.401 Y161.847 I-3.523 J1.938 E.12424
G1 X178.401 Y163.201 E.04159
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X177.173 Y163.201 E.03773
G3 X172.649 Y163.201 I-2.262 J-3.323 E.14763
G1 X171.421 Y163.201 E.03776
G1 X171.421 Y161.847 E.04159
G3 X171.421 Y157.974 I3.531 J-1.937 E.12415
G1 X171.421 Y155.284 E.08265
M204 S10000
G1 X170.943 Y154.57 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.446305
G1 F2276
M204 S8000
G1 X171.133 Y154.414 E.00806
; LINE_WIDTH: 0.412606
G1 X171.325 Y154.261 E.00739
; LINE_WIDTH: 0.370232
G1 X171.521 Y154.111 E.00658
; LINE_WIDTH: 0.332927
G1 X171.62 Y154.038 E.00293
; LINE_WIDTH: 0.30513
G1 X171.72 Y153.964 E.00265
; LINE_WIDTH: 0.275095
G1 X171.822 Y153.892 E.00236
; LINE_WIDTH: 0.242808
G1 X171.923 Y153.819 E.00203
; LINE_WIDTH: 0.226429
G1 X172.016 Y153.756 E.00168
M204 S10000
G1 X170.943 Y154.57 F60000
; LINE_WIDTH: 0.496861
G1 F2276
M204 S8000
G2 X168.991 Y156.905 I4.43 J5.687 E.11348
; LINE_WIDTH: 0.53251
G2 X168.328 Y158.879 I6.112 J3.149 E.08337
; LINE_WIDTH: 0.59127
G2 X168.23 Y160.029 I7.223 J1.198 E.05161
G1 X168.229 Y167.105 E.3162
; WIPE_START
G1 F6565.159
G1 X168.229 Y165.105 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.052 Y158.499 Z10 F60000
G1 X172.238 Y158.179 Z10
G1 Z9.6
G1 E.8 F1800
; LINE_WIDTH: 0.481355
G1 F2276
M204 S8000
G1 X172.031 Y158.575 E.01596
G2 X172.238 Y161.643 I2.93 J1.343 E.11455
; WIPE_START
G1 F8211.029
G1 X172.031 Y161.248 E-.16959
G1 X171.886 Y160.873 E-.15282
G1 X171.798 Y160.535 E-.13258
G1 X171.745 Y160.153 E-.14678
G1 X171.74 Y159.771 E-.14514
G1 X171.744 Y159.737 E-.01309
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.967 Y162.697 Z10 F60000
G1 Z9.6
G1 E.8 F1800
; LINE_WIDTH: 0.419723
G1 F2276
M204 S8000
G1 X173.528 Y162.795 E.0175
; LINE_WIDTH: 0.480723
G1 X173.589 Y162.796 E.00218
G2 X176.247 Y162.79 I1.322 J-2.889 E.09784
M204 S10000
G1 X176.538 Y162.407 F60000
; LINE_WIDTH: 0.104883
G1 F2276
M204 S8000
G1 X176.451 Y162.475 E.00056
; LINE_WIDTH: 0.132429
G1 X176.323 Y162.57 E.00116
; LINE_WIDTH: 0.176145
G1 X176.31 Y162.602 E.00038
; LINE_WIDTH: 0.223958
G1 X176.298 Y162.635 E.00052
; LINE_WIDTH: 0.271771
G1 X176.286 Y162.668 E.00065
; LINE_WIDTH: 0.319584
G1 X176.274 Y162.701 E.00079
; LINE_WIDTH: 0.367397
G1 X176.261 Y162.734 E.00093
; LINE_WIDTH: 0.41521
G1 X176.249 Y162.767 E.00106
; LINE_WIDTH: 0.459218
G1 X176.247 Y162.79 E.00078
; LINE_WIDTH: 0.459441
G1 X176.301 Y162.786 E.00184
; LINE_WIDTH: 0.399282
G1 X176.94 Y162.644 E.01901
; WIPE_START
G1 F10102.111
G1 X176.301 Y162.786 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X177.581 Y161.642 Z10 F60000
G1 Z9.6
G1 E.8 F1800
; LINE_WIDTH: 0.481138
G1 F2276
M204 S8000
G2 X177.79 Y158.574 I-2.708 J-1.725 E.11453
G1 X177.586 Y158.178 E.01589
; WIPE_START
G1 F8215.1
G1 X177.79 Y158.574 E-.16914
M73 P89 R1
G1 X177.942 Y158.968 E-.16068
G1 X178.03 Y159.321 E-.13815
G1 X178.079 Y159.717 E-.15145
G1 X178.075 Y160.087 E-.14057
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X176.802 Y156.46 Z10 F60000
G1 Z9.6
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F2276
M204 S8000
G1 X176.802 Y153.957 E.0769
G1 X175.047 Y153.957 E.05395
G1 X174.393 Y154.003 E.02012
G1 X173.544 Y154.168 E.02657
G1 X173.019 Y154.343 E.01701
G1 X173.019 Y156.435 E.06428
G1 X173.663 Y156.154 E.02161
G1 X174.219 Y156.017 E.01759
G1 X174.889 Y155.952 E.02068
G1 X175.648 Y156.022 E.02341
G1 X176.368 Y156.23 E.02304
G1 X176.749 Y156.432 E.01324
M204 S10000
G1 X176.425 Y155.854 F60000
G1 F2276
M204 S8000
G1 X176.425 Y154.334 E.0467
G1 X175.06 Y154.334 E.04196
G1 X174.443 Y154.377 E.01901
G1 X173.64 Y154.533 E.02512
G1 X173.396 Y154.615 E.00791
G1 X173.396 Y155.857 E.03818
G1 X174.131 Y155.65 E.02346
G1 X174.86 Y155.576 E.0225
G1 X175.684 Y155.646 E.02543
G1 X176.368 Y155.838 E.02181
M204 S10000
G1 X176.002 Y155.288 F60000
; LINE_WIDTH: 0.494525
G1 F2276
M204 S8000
G1 X176.002 Y154.758 E.0195
G2 X174.508 Y154.775 I-.634 J9.806 E.05502
; LINE_WIDTH: 0.459489
G2 X173.788 Y154.904 I2.145 J14.049 E.02484
G1 X173.788 Y155.33 E.01446
G1 X174.54 Y155.199 E.0259
G1 X175.061 Y155.178 E.0177
; LINE_WIDTH: 0.500209
G1 X175.724 Y155.225 E.02479
G1 X175.943 Y155.275 E.00836
; WIPE_START
G1 F7872.493
G1 X175.724 Y155.225 E-.19166
G1 X175.061 Y155.178 E-.56834
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X177.805 Y153.23 Z10 F60000
G1 Z9.6
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.594193
G1 F2276
M204 S8000
G1 X182.105 Y153.229 E.19316
; CHANGE_LAYER
; Z_HEIGHT: 9.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F6530.341
G1 X180.105 Y153.229 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 49/58
; update layer progress
M73 L49
M991 S0 P48 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 2
M204 S10000
G17
G3 Z10 I-.907 J-.811 P1  F60000
G1 X172.686 Y161.523 Z10
G1 Z9.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2292
M204 S8000
G1 X172.436 Y161.117 E.0158
G3 X174.63 Y157.173 I2.473 J-1.207 E.17556
G1 X174.875 Y157.159 E.00815
G3 X172.717 Y161.574 I.034 J2.752 E.37203
; COOLING_NODE: 2
M204 S250
G1 X173.018 Y161.319 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2292
M204 S5000
G1 X172.789 Y160.945 E.01346
G3 X174.667 Y157.563 I2.12 J-1.035 E.13934
G1 X174.884 Y157.551 E.00669
G3 X173.053 Y161.367 I.025 J2.36 E.29421
; COOLING_NODE: 2
; WIPE_START
G1 F9547.055
M204 S8000
G1 X172.789 Y160.945 E-.18917
G1 X172.631 Y160.522 E-.17179
G1 X172.556 Y160.076 E-.17198
G1 X172.568 Y159.622 E-.17227
G1 X172.597 Y159.481 E-.05478
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.627 Y157.165 Z10.2 F60000
G1 Z9.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2292
M204 S8000
G1 X172.627 Y154.068 E.10273
G3 X175.034 Y153.566 I2.531 J6.116 E.08205
G1 X177.195 Y153.566 E.07166
G1 X177.195 Y157.154 E.11901
G2 X172.674 Y157.128 I-2.277 J2.831 E.16186
; COOLING_NODE: 2
; WIPE_START
G1 F8843.478
G1 X172.643 Y155.128 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.754 Y153.587 Z10.2 F60000
G1 Z9.8
G1 E.8 F1800
G1 F2292
M204 S8000
G1 X172.874 Y153.542 E.00425
G3 X175.027 Y153.159 I2.319 J6.795 E.07283
G1 X177.602 Y153.159 E.0854
G1 X177.602 Y158.21 E.16754
G2 X176.337 Y157.091 I-2.926 J2.034 E.05653
G2 X172.526 Y157.838 I-1.422 J2.84 E.13861
G1 X172.22 Y158.21 E.01597
G1 X172.22 Y153.802 E.14621
G1 X172.698 Y153.61 E.0171
; COOLING_NODE: 2
; WIPE_START
G1 F8843.478
G1 X172.874 Y153.542 E-.07144
G1 X173.577 Y153.337 E-.27828
G1 X174.297 Y153.21 E-.27782
G1 X174.644 Y153.186 E-.13246
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X176.995 Y160.448 Z10.2 F60000
G1 X177.436 Y161.808 Z10.2
G1 Z9.8
G1 E.8 F1800
G1 F2292
M204 S8000
G1 X177.602 Y161.864 E.00581
G1 X177.602 Y162.402 E.01782
G1 X176.872 Y162.402 E.02419
G2 X177.399 Y161.855 I-2.675 J-3.104 E.0252
; COOLING_NODE: 2
; WIPE_START
G1 F8843.478
G1 X177.602 Y161.864 E-.07715
G1 X177.602 Y162.402 E-.20414
G1 X176.872 Y162.402 E-.27713
G1 X177.184 Y162.106 E-.16321
G1 X177.25 Y162.029 E-.03838
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.384 Y161.807 Z10.2 F60000
G1 Z9.8
G1 E.8 F1800
G1 F2292
M204 S8000
G1 X172.491 Y161.942 E.00571
G2 X172.954 Y162.402 I3.236 J-2.798 E.02167
G1 X172.22 Y162.402 E.02435
G1 X172.22 Y161.864 E.01782
G1 X172.327 Y161.827 E.00376
; COOLING_NODE: 2
; WIPE_START
G1 F8843.478
G1 X172.491 Y161.942 E-.07603
G1 X172.716 Y162.184 E-.12558
G1 X172.954 Y162.402 E-.12259
G1 X172.22 Y162.402 E-.27895
G1 X172.22 Y161.989 E-.15684
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.815 Y154.367 Z10.2 F60000
G1 X171.813 Y154.325 Z10.2
G1 Z9.8
G1 E.8 F1800
G1 F2292
M204 S8000
G1 X170.603 Y155.449 E.05477
G2 X168.709 Y159.903 I4.331 J4.472 E.16491
G1 X168.709 Y167.309 E.24565
G1 X167.751 Y167.309 E.03176
G1 X167.752 Y160.021 E.24176
G3 X175.02 Y152.752 I7.408 J.14 E.37678
G1 X182.309 Y152.751 E.24178
G1 X182.309 Y153.709 E.03176
G1 X178.009 Y153.709 E.14264
G1 X178.009 Y158.069 E.14465
G3 X178.009 Y161.752 I-3.179 J1.841 E.12797
G1 X178.009 Y162.809 E.03504
G1 X177.062 Y162.809 E.03142
G3 X172.762 Y162.809 I-2.15 J-2.964 E.15243
G1 X171.813 Y162.809 E.03149
G1 X171.813 Y161.755 E.03495
G3 X171.813 Y158.069 I3.151 J-1.843 E.12816
G1 X171.813 Y154.385 E.12221
; COOLING_NODE: 0
M204 S250
G1 X171.421 Y155.224 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1510
M204 S5000
G2 X169.931 Y156.918 I4.843 J5.763 E.06956
G2 X169.101 Y159.908 I5.032 J3.007 E.09652
G1 X169.101 Y167.701 E.23944
G1 X167.359 Y167.701 E.05352
G1 X167.36 Y160.013 E.23622
G3 X175.013 Y152.36 I7.801 J.148 E.36749
G1 X182.701 Y152.359 E.23623
G1 X182.701 Y154.101 E.05352
G1 X178.401 Y154.101 E.13213
G1 X178.401 Y157.974 E.11902
G3 X178.401 Y161.847 I-3.544 J1.937 E.12412
G1 X178.401 Y163.201 E.04159
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X177.173 Y163.201 E.03773
G3 X172.649 Y163.201 I-2.262 J-3.319 E.14764
G1 X171.421 Y163.201 E.03776
G1 X171.421 Y161.848 E.04156
G3 X171.421 Y157.974 I3.507 J-1.937 E.12424
G1 X171.421 Y155.284 E.08265
M204 S10000
M73 P90 R1
G1 X170.944 Y154.57 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.494175
G1 F2292
M204 S8000
G2 X169.101 Y156.702 I4.461 J5.721 E.10429
; LINE_WIDTH: 0.528442
G2 X168.331 Y158.87 I5.993 J3.349 E.09146
; LINE_WIDTH: 0.589983
G2 X168.23 Y160.03 I7.304 J1.215 E.05197
G1 X168.23 Y167.105 E.3154
; WIPE_START
G1 F6580.6
G1 X168.23 Y165.105 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.965 Y162.696 Z10.2 F60000
G1 Z9.8
G1 E.8 F1800
; LINE_WIDTH: 0.417419
G1 F2292
M204 S8000
G1 X173.521 Y162.794 E.01723
; LINE_WIDTH: 0.442956
G1 X173.554 Y162.795 E.00108
; LINE_WIDTH: 0.468858
G1 X173.587 Y162.795 E.00115
; LINE_WIDTH: 0.481266
G2 X176.042 Y162.876 I1.324 J-2.881 E.09009
G1 X176.244 Y162.791 E.00784
M204 S10000
G1 X176.256 Y162.758 F60000
; LINE_WIDTH: 0.445706
G1 F2292
M204 S8000
G1 X176.244 Y162.791 E.00112
G1 X176.352 Y162.784 E.00353
; LINE_WIDTH: 0.398995
G1 X176.939 Y162.645 E.01752
M204 S10000
G1 X176.529 Y162.413 F60000
; LINE_WIDTH: 0.118259
G1 F2292
M204 S8000
G1 X176.357 Y162.543 E.00132
; LINE_WIDTH: 0.14473
G1 X176.325 Y162.566 E.00033
; LINE_WIDTH: 0.174332
G1 X176.313 Y162.598 E.00036
; LINE_WIDTH: 0.221641
G1 X176.302 Y162.63 E.0005
; LINE_WIDTH: 0.268949
G1 X176.29 Y162.662 E.00063
; LINE_WIDTH: 0.316258
G1 X176.279 Y162.694 E.00076
; LINE_WIDTH: 0.363566
G1 X176.267 Y162.726 E.00089
; LINE_WIDTH: 0.410875
G1 X176.256 Y162.758 E.00102
M204 S10000
G1 X177.585 Y161.644 F60000
; LINE_WIDTH: 0.4812
G1 F2292
M204 S8000
G2 X177.979 Y159.095 I-2.777 J-1.733 E.09467
; LINE_WIDTH: 0.474549
G1 X177.937 Y158.952 E.00525
G1 X177.949 Y158.907 E.00164
; LINE_WIDTH: 0.407672
G1 X177.951 Y158.842 E.00193
; LINE_WIDTH: 0.360696
G1 X177.952 Y158.777 E.00168
; LINE_WIDTH: 0.3286
G1 X177.854 Y158.213 E.01333
M204 S10000
G1 X177.398 Y157.59 F60000
; LINE_WIDTH: 0.105862
G1 F2292
M204 S8000
G1 X177.277 Y157.487 E.00082
; WIPE_START
G1 F15000
G1 X177.398 Y157.59 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.063 Y155.182 Z10.2 F60000
G1 Z9.8
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.497106
G1 F2292
M204 S8000
G1 X175.74 Y155.228 E.02511
G1 X176.002 Y155.284 E.0099
G1 X176.002 Y154.759 E.01941
G2 X174.509 Y154.775 I-.633 J10.305 E.05531
; LINE_WIDTH: 0.45826
G2 X173.788 Y154.905 I2.248 J14.57 E.0248
G1 X173.788 Y155.33 E.01436
G1 X174.542 Y155.198 E.02591
G1 X175.003 Y155.183 E.01562
M204 S10000
G1 X176.425 Y155.853 F60000
; LINE_WIDTH: 0.41999
G1 F2292
M204 S8000
G1 X176.425 Y154.335 E.04662
G1 X175.061 Y154.336 E.04192
G1 X174.443 Y154.379 E.01903
G1 X173.641 Y154.535 E.02511
G1 X173.396 Y154.616 E.00794
G1 X173.396 Y155.861 E.03824
G1 X173.626 Y155.771 E.0076
G3 X174.806 Y155.577 I1.289 J4.16 E.03684
G1 X175.701 Y155.65 E.02762
G1 X176.369 Y155.831 E.02127
M204 S10000
G1 X176.802 Y156.441 F60000
G1 F2292
M204 S8000
G1 X176.802 Y153.958 E.07628
G1 X175.048 Y153.959 E.05391
G1 X174.394 Y154.004 E.02014
G1 X173.545 Y154.169 E.02657
G1 X173.019 Y154.345 E.01704
G1 X173.019 Y156.435 E.06423
G1 X173.682 Y156.148 E.02221
G3 X174.838 Y155.952 I1.298 J4.164 E.03613
G1 X175.667 Y156.025 E.02557
G3 X176.751 Y156.41 I-1.025 J4.601 E.03542
; WIPE_START
G1 F9547.299
G1 X176.19 Y156.164 E-.23281
G1 X175.667 Y156.025 E-.2055
G1 X174.838 Y155.952 E-.31619
G1 X174.824 Y155.954 E-.00551
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X177.805 Y153.23 Z10.2 F60000
G1 Z9.8
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.592963
G1 F2292
M204 S8000
G1 X182.105 Y153.23 E.19273
; WIPE_START
G1 F6544.945
G1 X180.105 Y153.23 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.489 Y153.726 Z10.2 F60000
G1 X172.016 Y153.757 Z10.2
G1 Z9.8
G1 E.8 F1800
; LINE_WIDTH: 0.224688
G1 F2292
M204 S8000
G1 X171.924 Y153.82 E.00166
; LINE_WIDTH: 0.24108
G1 X171.823 Y153.892 E.00201
; LINE_WIDTH: 0.273331
G1 X171.721 Y153.964 E.00234
; LINE_WIDTH: 0.30338
G1 X171.621 Y154.038 E.00263
; LINE_WIDTH: 0.331213
G1 X171.521 Y154.112 E.00292
; LINE_WIDTH: 0.368534
G1 X171.325 Y154.262 E.00655
; LINE_WIDTH: 0.410886
G1 X171.134 Y154.414 E.00733
; LINE_WIDTH: 0.444556
G1 X170.944 Y154.57 E.00804
; WIPE_START
G1 F8963.34
G1 X171.134 Y154.414 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.977 Y158.2 Z10.2 F60000
G1 Z9.8
G1 E.8 F1800
; LINE_WIDTH: 0.31856
G1 F2292
M204 S8000
G1 X171.869 Y158.777 E.0132
; LINE_WIDTH: 0.362092
G1 X171.874 Y158.837 E.00157
; LINE_WIDTH: 0.410701
G1 X171.879 Y158.895 E.00175
; LINE_WIDTH: 0.458553
G1 X171.885 Y158.953 E.00198
; LINE_WIDTH: 0.481107
G1 X171.783 Y159.365 E.01514
G2 X172.131 Y161.447 I3.162 J.541 E.0768
G1 X172.457 Y161.566 E.01237
M204 S10000
G1 X171.885 Y158.953 F60000
; LINE_WIDTH: 0.458962
G1 F2292
M204 S8000
G1 X171.917 Y158.932 E.0013
; LINE_WIDTH: 0.411896
G1 X171.949 Y158.911 E.00115
; LINE_WIDTH: 0.36483
G1 X171.981 Y158.89 E.001
; LINE_WIDTH: 0.317765
G1 X172.013 Y158.869 E.00086
; LINE_WIDTH: 0.270699
G1 X172.045 Y158.848 E.00071
; LINE_WIDTH: 0.223633
G1 X172.077 Y158.827 E.00056
; LINE_WIDTH: 0.175229
G1 X172.161 Y158.687 E.00176
; LINE_WIDTH: 0.131994
G1 X172.245 Y158.554 E.00114
; LINE_WIDTH: 0.104789
G1 X172.307 Y158.463 E.00055
; CHANGE_LAYER
; Z_HEIGHT: 10
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F15000
G1 X172.245 Y158.554 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 50/58
; update layer progress
M73 L50
M991 S0 P49 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 2
M204 S10000
G17
G3 Z10.2 I-1.171 J.33 P1  F60000
G1 X173.025 Y161.321 Z10.2
G1 Z10
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2587
M204 S5000
G1 X172.909 Y161.161 E.00607
G3 X174.666 Y157.563 I2.001 J-1.251 E.14688
G1 X174.873 Y157.551 E.00638
G3 X173.102 Y161.426 I.037 J2.359 E.29224
G1 X173.061 Y161.37 E.00215
; COOLING_NODE: 2
; WIPE_START
G1 F9547.055
M204 S8000
G1 X172.909 Y161.161 E-.09785
G1 X172.79 Y160.946 E-.09371
G1 X172.631 Y160.521 E-.17212
G1 X172.556 Y160.075 E-.17184
G1 X172.568 Y159.623 E-.17195
G1 X172.596 Y159.488 E-.05254
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X169.404 Y155.762 Z10.4 F60000
G1 Z10
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2788
M204 S8000
G1 X169.404 Y157.061 E.04309
G2 X168.709 Y159.906 I5.614 J2.881 E.09804
G1 X168.709 Y167.309 E.24557
G1 X167.752 Y167.309 E.03172
G1 X167.754 Y160.022 E.24171
G3 X169.236 Y155.707 I7.435 J.142 E.15383
G1 X169.347 Y155.743 E.0039
; COOLING_NODE: 2
; WIPE_START
G1 F8843.478
G1 X169.404 Y157.061 E-.50116
G1 X169.123 Y157.681 E-.25884
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X176.273 Y155.009 Z10.4 F60000
G1 X182.309 Y152.752 Z10.4
G1 Z10
G1 E.8 F1800
G1 F2788
M204 S8000
G1 X182.309 Y153.709 E.03172
G1 X180.417 Y153.709 E.06275
G1 X180.417 Y152.753 E.03171
G1 X182.249 Y152.752 E.06076
; COOLING_NODE: 0
; WIPE_START
G1 F8843.478
G1 X182.309 Y153.709 E-.36409
G1 X181.267 Y153.709 E-.39591
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X173.723 Y154.87 Z10.4 F60000
G1 X171.421 Y155.224 Z10.4
G1 Z10
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1407
M204 S5000
G2 X169.975 Y156.846 I4.899 J5.824 E.06697
G2 X169.101 Y159.909 I4.957 J3.071 E.09915
G1 X169.101 Y167.701 E.23942
G1 X167.36 Y167.701 E.05348
G1 X167.361 Y160.014 E.23618
G3 X175.014 Y152.361 I7.801 J.148 E.36748
G1 X182.701 Y152.36 E.23619
G1 X182.701 Y154.101 E.05348
G1 X178.401 Y154.101 E.13213
G1 X178.401 Y157.974 E.11902
G3 X178.401 Y161.847 I-3.56 J1.937 E.12408
G1 X178.401 Y163.201 E.04159
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X177.172 Y163.201 E.03776
G3 X172.65 Y163.201 I-2.261 J-3.305 E.14764
G1 X171.421 Y163.201 E.03778
G1 X171.421 Y161.849 E.04153
G3 X171.421 Y157.973 I3.537 J-1.938 E.12424
G1 X171.421 Y155.284 E.08262
; WIPE_START
G1 F9547.055
M204 S8000
G1 X170.875 Y155.731 E-.26787
G1 X170.527 Y156.098 E-.19234
G1 X170.211 Y156.495 E-.19282
G1 X170.054 Y156.729 E-.10696
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X170.878 Y154.049 Z10.4 F60000
G1 Z10
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.325157
G1 F2788
M204 S8000
G1 X170.492 Y154.336 E.01106
G2 X169.691 Y155.056 I6.176 J7.668 E.02478
; LINE_WIDTH: 0.28534
G1 X169.525 Y155.224 E.00466
G1 X169.329 Y155.531 E.0072
M204 S10000
G1 X169.201 Y156.516 F60000
; LINE_WIDTH: 0.525768
G1 F2788
M204 S8000
G1 X168.84 Y157.219 E.0311
G2 X168.331 Y158.87 I6.313 J2.847 E.06818
; LINE_WIDTH: 0.58874
G2 X168.231 Y160.032 I7.201 J1.206 E.0519
G1 X168.231 Y167.105 E.31461
; WIPE_START
G1 F6595.586
G1 X168.231 Y165.105 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X169.544 Y157.586 Z10.4 F60000
G1 X169.743 Y156.448 Z10.4
G1 Z10
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.38292
G1 F2788
M204 S8000
G1 X169.679 Y156.484 E.00204
G1 X169.727 Y156.512 E.00155
M204 S10000
G1 X170.878 Y154.049 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.353304
G1 F2788
M204 S8000
G3 X173.325 Y152.952 I4.151 J5.985 E.06823
G1 X173.481 Y152.916 E.00403
; LINE_WIDTH: 0.420946
G3 X174.888 Y152.751 I1.558 J7.209 E.04373
G1 X180.221 Y152.749 E.16427
M204 S10000
G1 X180.621 Y153.231 F60000
; LINE_WIDTH: 0.591947
G1 F2788
M204 S8000
G1 X182.105 Y153.231 E.06642
; WIPE_START
G1 F6557.064
G1 X180.621 Y153.231 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X178.669 Y160.609 Z10.4 F60000
G1 X178.193 Y162.406 Z10.4
G1 Z10
G1 E.8 F1800
; FEATURE: Top surface
; LINE_WIDTH: 0.42
G1 F2788
M204 S2000
G1 X177.606 Y162.993 E.02553
M73 P91 R1
G1 X177.472 Y163.127
G1 X176.872 Y163.194
G1 X177.006 Y163.06
G1 X178.193 Y161.873 E.05161
G1 X178.327 Y161.739
G1 X178.665 Y160.868
G1 X178.531 Y161.001
G1 X176.002 Y163.53 E.10991
G1 X175.869 Y163.664
G1 X175.196 Y163.803
G1 X175.33 Y163.67
G1 X178.67 Y160.33 E.14513
G1 X178.803 Y160.196
G1 X178.822 Y159.644
G1 X178.689 Y159.778
G1 X174.776 Y163.69 E.17003
G1 X174.642 Y163.824
G1 X174.157 Y163.775
G1 X174.291 Y163.642
G1 X175.532 Y162.401 E.05391
G1 X175.665 Y162.268
G1 X175.056 Y162.344
G1 X174.922 Y162.477
G1 X173.857 Y163.543 E.04631
G1 X173.723 Y163.677
G1 X173.329 Y163.537
G1 X173.463 Y163.404
G1 X174.433 Y162.433 E.04219
G1 X174.567 Y162.299
G1 X174.15 Y162.183
G1 X174.017 Y162.316
G1 X173.101 Y163.232 E.03979
G1 X172.967 Y163.366
G1 X172.636 Y163.164
G1 X172.769 Y163.031
G1 X173.652 Y162.148 E.03836
G1 X173.786 Y162.014
G1 X173.465 Y161.802
G1 X173.331 Y161.935
G1 X172.273 Y162.993 E.04598
G1 X172.14 Y163.127
G1 X171.606 Y163.127
G1 X171.74 Y162.993
G1 X173.052 Y161.681 E.05702
G1 X173.186 Y161.548
G1 X172.945 Y161.255
G1 X172.812 Y161.389
G1 X171.628 Y162.572 E.05142
G1 X171.494 Y162.706
G1 X171.494 Y162.172
G1 X171.628 Y162.039
G1 X172.612 Y161.054 E.04277
G1 X172.746 Y160.921
G1 X172.593 Y160.54
G1 X172.46 Y160.674
G1 X171.53 Y161.603 E.04038
G1 X171.397 Y161.737
G1 X171.235 Y161.366
G1 X171.368 Y161.232
G1 X172.364 Y160.236 E.04328
G1 X172.498 Y160.102
G1 X172.484 Y159.583
G1 X172.351 Y159.716
G1 X171.241 Y160.826 E.04821
G1 X171.108 Y160.959
G1 X171.024 Y160.51
G1 X171.158 Y160.376
G1 X172.499 Y159.035 E.05827
; WIPE_START
G1 F9547.055
M204 S8000
G1 X171.158 Y160.376 E-.72065
G1 X171.084 Y160.449 E-.03935
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X177.401 Y160.532 Z10.4 F60000
G1 Z10
G1 E.8 F1800
G1 F2788
M204 S2000
G1 X178.641 Y159.292 E.05388
G1 X178.775 Y159.158
G1 X178.676 Y158.724
G1 X178.542 Y158.857
G1 X177.477 Y159.922 E.04627
G1 X177.344 Y160.056
G1 X177.298 Y159.568
G1 X177.432 Y159.434
G1 X178.404 Y158.463 E.04222
G1 X178.537 Y158.329
G1 X178.366 Y157.967
G1 X178.233 Y158.101
G1 X177.317 Y159.016 E.03979
G1 X177.183 Y159.15
G1 X177.014 Y158.785
G1 X177.148 Y158.652
G1 X178.193 Y157.606 E.04543
G1 X178.327 Y157.473
G1 X178.327 Y156.94
G1 X178.193 Y157.073
G1 X176.935 Y158.332 E.05468
G1 X176.801 Y158.465
G1 X176.548 Y158.186
G1 X176.681 Y158.052
G1 X178.193 Y156.54 E.0657
G1 X178.327 Y156.406
G1 X178.327 Y155.873
G1 X178.193 Y156.007
G1 X176.387 Y157.813 E.07848
G1 X176.254 Y157.946
G1 X175.92 Y157.746
G1 X176.054 Y157.613
G1 X178.193 Y155.473 E.09297
G1 X178.327 Y155.34
G1 X178.327 Y154.807
G1 X178.193 Y154.94
G1 X175.674 Y157.46 E.10948
G1 X175.54 Y157.593
G1 X175.102 Y157.498
G1 X175.236 Y157.365
G1 X178.193 Y154.407 E.12852
; WIPE_START
G1 F9547.055
M204 S8000
G1 X176.779 Y155.821 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X179.773 Y153.893 Z10.4 F60000
G1 Z10
G1 E.8 F1800
G1 F2788
M204 S2000
G1 X180.195 Y153.472 E.0183
G1 X180.328 Y153.339
G1 X180.3 Y152.833
G1 X180.167 Y152.967
G1 X179.24 Y153.893 E.04026
G1 X179.107 Y154.027
G1 X178.573 Y154.027
G1 X178.707 Y153.893
G1 X179.633 Y152.967 E.04026
G1 X179.767 Y152.833
G1 X179.234 Y152.833
G1 X179.1 Y152.967
G1 X174.714 Y157.353 E.19058
G1 X174.581 Y157.486
G1 X173.904 Y157.63
G1 X174.037 Y157.496
G1 X178.567 Y152.967 E.19683
G1 X178.7 Y152.833
G1 X178.167 Y152.833
G1 X178.034 Y152.967
G1 X171.13 Y159.871 E.30001
G1 X170.996 Y160.005
G1 X171.047 Y159.42
G1 X171.181 Y159.287
G1 X177.5 Y152.967 E.27462
G1 X177.634 Y152.833
G1 X177.101 Y152.833
G1 X176.967 Y152.967
G1 X171.38 Y158.554 E.24277
G1 X171.247 Y158.687
G1 X171.494 Y157.906
G1 X171.628 Y157.773
G1 X176.434 Y152.967 E.20883
G1 X176.567 Y152.833
G1 X176.034 Y152.833
G1 X175.901 Y152.967
G1 X171.628 Y157.239 E.18566
G1 X171.494 Y157.373
G1 X171.494 Y156.84
G1 X171.628 Y156.706
G1 X175.367 Y152.967 E.16249
G1 X175.501 Y152.833
G1 X174.966 Y152.835
G1 X174.832 Y152.969
G1 X171.628 Y156.173 E.13924
G1 X171.494 Y156.307
G1 X171.494 Y155.773
G1 X171.628 Y155.64
G1 X174.271 Y152.997 E.11484
G1 X174.404 Y152.863
G1 X173.786 Y152.949
G1 X173.652 Y153.082
G1 X171.628 Y155.106 E.08795
; WIPE_START
G1 F9547.055
M204 S8000
G1 X173.042 Y153.692 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X169.813 Y156.388 Z10.4 F60000
G1 Z10
G1 E.8 F1800
G1 F2788
M204 S2000
G1 X172.952 Y153.249 E.13637
G1 X173.085 Y153.116
G1 X172.246 Y153.422
G1 X172.112 Y153.556
G1 X169.627 Y156.041 E.10799
M204 S10000
G1 X171.519 Y153.854 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.105388
G1 F2788
M204 S8000
G1 X171.402 Y153.942 E.00075
; LINE_WIDTH: 0.136972
G1 X171.307 Y154.018 E.00093
; LINE_WIDTH: 0.165693
G1 X171.211 Y154.093 E.00122
; LINE_WIDTH: 0.204099
G1 X171.026 Y154.245 E.00314
; LINE_WIDTH: 0.247904
G1 X170.845 Y154.397 E.00395
; LINE_WIDTH: 0.283326
G1 X170.667 Y154.553 E.00463
; LINE_WIDTH: 0.310968
G1 X170.485 Y154.718 E.00536
; LINE_WIDTH: 0.337002
G1 X170.047 Y155.132 E.01446
; LINE_WIDTH: 0.365081
G1 X169.608 Y155.546 E.01584
; WIPE_START
G1 F11174.553
G1 X170.047 Y155.132 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.716 Y158.579 Z10.4 F60000
G1 Z10
G1 E.8 F1800
; LINE_WIDTH: 0.110769
G1 F2788
M204 S8000
G1 X172.6 Y158.731 E.00106
; LINE_WIDTH: 0.169873
G2 X172.434 Y158.97 I8.751 J6.268 E.00302
; WIPE_START
G1 F15000
G1 X172.6 Y158.731 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X173.69 Y157.631 Z10.4 F60000
G1 Z10
G1 E.8 F1800
; LINE_WIDTH: 0.0986979
G1 F2788
M204 S8000
G1 X173.583 Y157.712 E.00061
; WIPE_START
G1 F15000
G1 X173.69 Y157.631 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X177.47 Y160.6 Z10.4 F60000
G1 Z10
G1 E.8 F1800
; LINE_WIDTH: 0.10339
G1 F2788
M204 S8000
G3 X177.282 Y160.892 I-7.152 J-4.408 E.00171
; WIPE_START
G1 F15000
G1 X177.47 Y160.6 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X176.671 Y163.212 Z10.4 F60000
G1 Z10
G1 E.8 F1800
; LINE_WIDTH: 0.128637
G1 F2788
M204 S8000
G1 X176.542 Y163.306 E.00112
; LINE_WIDTH: 0.0999755
G1 X176.468 Y163.357 E.00042
; CHANGE_LAYER
; Z_HEIGHT: 10.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F15000
G1 X176.542 Y163.306 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 51/58
; update layer progress
M73 L51
M991 S0 P50 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z10.4 I1.041 J-.631 P1  F60000
G1 X171.388 Y154.807 Z10.4
G1 Z10.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X170.89 Y155.19 E.02084
G2 X168.709 Y159.906 I4.024 J4.724 E.17782
G1 X168.709 Y167.309 E.24557
G1 X167.754 Y167.309 E.03168
G1 X167.755 Y160.024 E.24163
G3 X175.022 Y152.755 I7.408 J.138 E.37682
G1 X182.309 Y152.754 E.2417
G1 X182.309 Y153.709 E.03168
G1 X174.903 Y153.709 E.24565
G2 X171.438 Y154.774 I.011 J6.206 E.12204
; COOLING_NODE: 0
M204 S250
G1 X171.492 Y155.221 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X171.145 Y155.488 E.01347
M73 P92 R1
G2 X169.101 Y159.909 I3.769 J4.426 E.15442
G1 X169.101 Y167.701 E.23941
G1 X167.362 Y167.701 E.05344
G1 X167.363 Y160.016 E.23613
G3 X175.015 Y152.363 I7.801 J.147 E.3675
G1 X182.701 Y152.362 E.23615
G1 X182.701 Y154.101 E.05344
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X174.908 Y154.101 E.23944
G2 X171.626 Y155.12 I.006 J5.814 E.1072
G1 X171.54 Y155.185 E.00331
M204 S10000
G1 X171.155 Y154.444 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.50307
G1 F1200
M204 S8000
G1 X170.791 Y154.715 E.01702
G2 X168.455 Y158.307 I4.277 J5.337 E.1634
; LINE_WIDTH: 0.560189
G1 X168.393 Y158.563 E.0111
G2 X168.235 Y159.904 I6.908 J1.494 E.057
; LINE_WIDTH: 0.590206
G1 X168.231 Y167.105 E.32114
; WIPE_START
G1 F6577.922
G1 X168.232 Y165.105 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X170.25 Y157.744 Z10.6 F60000
G1 X171.155 Y154.444 Z10.6
G1 Z10.2
G1 E.8 F1800
; LINE_WIDTH: 0.516835
G1 F1200
M204 S8000
G3 X173.431 Y153.423 I3.874 J5.588 E.09689
G1 X173.59 Y153.387 E.00628
; LINE_WIDTH: 0.586287
G3 X174.894 Y153.234 I1.451 J6.75 E.05822
G1 X182.105 Y153.231 E.31931
; CHANGE_LAYER
; Z_HEIGHT: 10.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F6625.354
G1 X180.105 Y153.232 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 52/58
; update layer progress
M73 L52
M991 S0 P51 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z10.6 I-.216 J-1.198 P1  F60000
G1 X171.393 Y154.804 Z10.6
G1 Z10.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X170.884 Y155.195 E.02131
G2 X168.709 Y159.903 I4.03 J4.719 E.17748
G1 X168.709 Y167.309 E.24565
G1 X167.755 Y167.309 E.03164
G1 X167.756 Y160.025 E.24161
G3 X175.024 Y152.756 I7.415 J.146 E.37671
G1 X182.309 Y152.755 E.24166
G1 X182.309 Y153.709 E.03164
G1 X174.906 Y153.709 E.24557
G2 X171.443 Y154.77 I.008 J6.205 E.12191
; COOLING_NODE: 0
M204 S250
G1 X171.496 Y155.218 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X171.139 Y155.493 E.01384
G2 X169.101 Y159.908 I3.775 J4.421 E.15416
G1 X169.101 Y167.701 E.23944
G1 X167.363 Y167.701 E.0534
G1 X167.364 Y160.017 E.2361
G3 X175.017 Y152.364 I7.807 J.155 E.3674
G1 X182.701 Y152.363 E.23611
G1 X182.701 Y154.101 E.0534
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X174.909 Y154.101 E.23941
M73 P93 R1
G2 X171.631 Y155.116 I.005 J5.813 E.10704
G1 X171.544 Y155.182 E.00336
M204 S10000
G1 X171.156 Y154.445 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.501396
G1 F1200
M204 S8000
G1 X170.795 Y154.713 E.01679
G2 X168.455 Y158.308 I4.256 J5.33 E.16302
; LINE_WIDTH: 0.558722
G2 X168.235 Y159.9 I6.527 J1.714 E.06774
; LINE_WIDTH: 0.588977
G1 X168.232 Y167.105 E.32058
; WIPE_START
G1 F6592.729
G1 X168.233 Y165.105 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X170.251 Y157.744 Z10.8 F60000
G1 X171.156 Y154.445 Z10.8
G1 Z10.4
G1 E.8 F1800
; LINE_WIDTH: 0.515226
G1 F1200
M204 S8000
G3 X173.424 Y153.426 I3.872 J5.584 E.09624
G1 X173.591 Y153.387 E.00657
; LINE_WIDTH: 0.585045
G3 X174.899 Y153.235 I1.462 J6.853 E.0583
G1 X182.105 Y153.232 E.31832
; CHANGE_LAYER
; Z_HEIGHT: 10.6
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F6640.542
G1 X180.105 Y153.233 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 53/58
; update layer progress
M73 L53
M991 S0 P52 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
M73 P93 R0
G3 Z10.8 I-.216 J-1.198 P1  F60000
G1 X171.398 Y154.801 Z10.8
G1 Z10.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X170.878 Y155.201 E.02176
G2 X168.709 Y159.906 I4.036 J4.713 E.17729
G1 X168.709 Y167.309 E.24557
G1 X167.756 Y167.309 E.0316
G1 X167.757 Y160.027 E.24156
G3 X175.025 Y152.757 I7.412 J.143 E.37675
G1 X182.309 Y152.756 E.24162
G1 X182.309 Y153.709 E.0316
G1 X174.906 Y153.709 E.24557
G2 X171.448 Y154.767 I.008 J6.205 E.12173
; COOLING_NODE: 0
M204 S250
G1 X171.5 Y155.216 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X171.133 Y155.498 E.01421
G2 X169.101 Y159.909 I3.781 J4.416 E.15395
G1 X169.101 Y167.701 E.23942
G1 X167.364 Y167.701 E.05337
G1 X167.365 Y160.018 E.23606
G3 X175.018 Y152.365 I7.805 J.152 E.36744
G1 X182.701 Y152.364 E.23608
G1 X182.701 Y154.101 E.05337
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X174.909 Y154.101 E.23941
G2 X171.636 Y155.113 I.005 J5.813 E.10687
G1 X171.548 Y155.18 E.00339
M204 S10000
G1 X171.358 Y154.31 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.499449
G1 F1200
M204 S8000
G1 X170.984 Y154.569 E.01695
G2 X168.456 Y158.308 I4.045 J5.459 E.17115
; LINE_WIDTH: 0.557384
G2 X168.236 Y159.904 I6.548 J1.716 E.06769
; LINE_WIDTH: 0.587748
G1 X168.232 Y167.105 E.3197
; WIPE_START
G1 F6607.596
G1 X168.233 Y165.105 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
M73 P94 R0
G1 X170.356 Y157.774 Z11 F60000
G1 X171.358 Y154.31 Z11
G1 Z10.6
G1 E.8 F1800
; LINE_WIDTH: 0.515563
G1 F1200
M204 S8000
G3 X173.422 Y153.427 I3.693 J5.774 E.08683
G1 X173.592 Y153.388 E.00673
; LINE_WIDTH: 0.583796
G3 X174.899 Y153.235 I1.463 J6.869 E.0581
G1 X182.105 Y153.232 E.31759
; CHANGE_LAYER
; Z_HEIGHT: 10.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F6655.868
G1 X180.105 Y153.233 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 54/58
; update layer progress
M73 L54
M991 S0 P53 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z11 I-.215 J-1.198 P1  F60000
G1 X171.403 Y154.797 Z11
G1 Z10.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X170.874 Y155.209 E.02222
G2 X168.709 Y159.903 I4.049 J4.715 E.17687
G1 X168.709 Y167.309 E.24565
G1 X167.757 Y167.309 E.03156
G1 X167.758 Y160.028 E.2415
G3 X175.026 Y152.758 I7.415 J.145 E.37674
G1 X182.309 Y152.757 E.24158
G1 X182.309 Y153.709 E.03156
G1 X174.906 Y153.709 E.24557
G2 X171.455 Y154.767 I.018 J6.215 E.12149
; COOLING_NODE: 0
M204 S250
G1 X171.503 Y155.214 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X171.129 Y155.506 E.01459
G2 X169.101 Y159.908 I3.794 J4.417 E.15361
G1 X169.101 Y167.701 E.23944
G1 X167.365 Y167.701 E.05333
G1 X167.366 Y160.02 E.23601
G3 X175.019 Y152.366 I7.807 J.154 E.36742
G1 X182.701 Y152.365 E.23604
G1 X182.701 Y154.101 E.05333
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X174.909 Y154.101 E.23941
G2 X171.643 Y155.113 I.014 J5.822 E.10664
G1 X171.552 Y155.178 E.00345
M204 S10000
G1 X171.359 Y154.311 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.497702
G1 F1200
M204 S8000
G1 X170.988 Y154.567 E.01669
G2 X168.456 Y158.309 I4.045 J5.465 E.1707
; LINE_WIDTH: 0.5562
G2 X168.237 Y159.9 I6.501 J1.708 E.06734
; LINE_WIDTH: 0.586499
G1 X168.233 Y167.105 E.31913
; WIPE_START
G1 F6622.773
G1 X168.234 Y165.105 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X170.357 Y157.774 Z11.2 F60000
G1 X171.359 Y154.311 Z11.2
G1 Z10.8
G1 E.8 F1800
; LINE_WIDTH: 0.513969
G1 F1200
M204 S8000
G3 X173.42 Y153.428 I3.693 J5.772 E.08645
G1 X173.593 Y153.388 E.00682
; LINE_WIDTH: 0.582541
G3 X174.899 Y153.236 I1.45 J6.764 E.05791
G1 X182.105 Y153.233 E.31685
; CHANGE_LAYER
; Z_HEIGHT: 11
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F6671.355
G1 X180.105 Y153.234 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 55/58
; update layer progress
M73 L55
M991 S0 P54 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z11.2 I-.215 J-1.198 P1  F60000
G1 X171.407 Y154.794 Z11.2
G1 Z11
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X170.869 Y155.214 E.02266
G2 X168.709 Y159.906 I4.055 J4.71 E.17669
G1 X168.709 Y167.309 E.24557
G1 X167.759 Y167.309 E.03152
G1 X167.76 Y160.029 E.24148
G3 X175.027 Y152.76 I7.408 J.139 E.37681
G1 X182.309 Y152.759 E.24154
G1 X182.309 Y153.709 E.03152
M73 P95 R0
G1 X174.906 Y153.709 E.24557
G2 X171.459 Y154.764 I.018 J6.215 E.12131
; COOLING_NODE: 0
M204 S250
G1 X171.507 Y155.211 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X171.124 Y155.511 E.01494
G2 X169.101 Y159.909 I3.799 J4.412 E.15341
G1 X169.101 Y167.701 E.23941
G1 X167.366 Y167.701 E.05329
G1 X167.368 Y160.021 E.23598
G3 X175.02 Y152.368 I7.801 J.147 E.36749
G1 X182.701 Y152.366 E.236
G1 X182.701 Y154.101 E.05329
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X174.909 Y154.101 E.23941
G2 X171.647 Y155.11 I.014 J5.823 E.10647
G1 X171.555 Y155.176 E.00349
M204 S10000
G1 X171.36 Y154.311 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.496072
G1 F1200
M204 S8000
G1 X170.994 Y154.564 E.0164
G2 X168.458 Y158.307 I4.039 J5.468 E.1702
; LINE_WIDTH: 0.554571
G1 X168.386 Y158.605 E.0128
G2 X168.237 Y159.904 I6.993 J1.461 E.05459
; LINE_WIDTH: 0.585274
G1 X168.234 Y167.105 E.31825
; WIPE_START
G1 F6637.734
G1 X168.235 Y165.105 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X170.358 Y157.774 Z11.4 F60000
G1 X171.36 Y154.311 Z11.4
G1 Z11
G1 E.8 F1800
; LINE_WIDTH: 0.512364
G1 F1200
M204 S8000
G3 X173.418 Y153.429 I3.692 J5.772 E.08602
G1 X173.594 Y153.389 E.00693
; LINE_WIDTH: 0.581293
G3 X174.899 Y153.237 I1.45 J6.766 E.05774
G1 X182.105 Y153.234 E.31612
; CHANGE_LAYER
; Z_HEIGHT: 11.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F6686.824
G1 X180.105 Y153.234 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 56/58
; update layer progress
M73 L56
M991 S0 P55 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z11.4 I-.214 J-1.198 P1  F60000
G1 X171.412 Y154.791 Z11.4
G1 Z11.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X170.859 Y155.216 E.02314
G2 X168.709 Y159.906 I4.054 J4.697 E.1765
G1 X168.709 Y167.309 E.24557
G1 X167.76 Y167.309 E.03148
G1 X167.761 Y160.03 E.24144
G3 X175.028 Y152.761 I7.415 J.145 E.37672
G1 X182.309 Y152.76 E.2415
G1 X182.309 Y153.709 E.03148
G1 X174.902 Y153.709 E.24569
G2 X171.462 Y154.757 I.011 J6.205 E.12104
; COOLING_NODE: 0
M204 S250
G1 X171.51 Y155.209 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X171.115 Y155.513 E.01532
M73 P96 R0
G2 X169.101 Y159.909 I3.798 J4.4 E.15323
G1 X169.101 Y167.701 E.23942
G1 X167.368 Y167.701 E.05325
G1 X167.369 Y160.022 E.23595
G3 X175.021 Y152.369 I7.807 J.154 E.36741
G1 X182.701 Y152.368 E.23596
G1 X182.701 Y154.101 E.05325
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X174.908 Y154.101 E.23945
G2 X171.65 Y155.103 I.006 J5.813 E.1063
G1 X171.558 Y155.173 E.00355
M204 S10000
G1 X171.361 Y154.312 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.494401
G1 F1200
M204 S8000
G1 X171.187 Y154.427 E.00768
G2 X168.458 Y158.308 I3.859 J5.614 E.17824
; LINE_WIDTH: 0.553189
G1 X168.385 Y158.616 E.01317
G2 X168.238 Y159.904 I6.893 J1.439 E.054
; LINE_WIDTH: 0.584043
G1 X168.234 Y167.105 E.31753
; WIPE_START
G1 F6652.841
G1 X168.235 Y165.105 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X170.358 Y157.774 Z11.6 F60000
G1 X171.361 Y154.312 Z11.6
G1 Z11.2
G1 E.8 F1800
; LINE_WIDTH: 0.510759
G1 F1200
M204 S8000
G3 X173.416 Y153.431 I3.692 J5.771 E.08564
G1 X173.595 Y153.389 E.00701
; LINE_WIDTH: 0.580053
G3 X174.891 Y153.237 I1.45 J6.77 E.05721
G1 X182.105 Y153.234 E.31574
; CHANGE_LAYER
; Z_HEIGHT: 11.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F6702.251
G1 X180.105 Y153.235 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 57/58
; update layer progress
M73 L57
M991 S0 P56 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z11.6 I-.214 J-1.198 P1  F60000
G1 X171.417 Y154.787 Z11.6
G1 Z11.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X170.853 Y155.221 E.0236
G2 X168.709 Y159.9 I4.06 J4.692 E.17606
G1 X168.709 Y167.309 E.24575
G1 X167.761 Y167.309 E.03143
G1 X167.762 Y160.03 E.24146
G3 X175.03 Y152.762 I7.414 J.147 E.37667
G1 X182.309 Y152.761 E.24146
G1 X182.309 Y153.709 E.03143
G1 X174.902 Y153.709 E.24568
G2 X171.467 Y154.754 I.011 J6.204 E.12084
; COOLING_NODE: 0
M204 S250
G1 X171.513 Y155.207 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X171.109 Y155.518 E.01568
G2 X169.101 Y159.905 I3.804 J4.395 E.15287
G1 X169.101 Y167.701 E.23953
G1 X167.369 Y167.701 E.05321
G1 X167.37 Y160.023 E.23593
G3 X175.023 Y152.37 I7.807 J.154 E.3674
G1 X182.701 Y152.369 E.23592
G1 X182.701 Y154.101 E.05321
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X174.908 Y154.101 E.23945
M73 P97 R0
G2 X171.655 Y155.1 I.005 J5.812 E.10612
G1 X171.561 Y155.171 E.00361
M204 S10000
G1 X171.362 Y154.312 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.492714
G1 F1200
M204 S8000
G1 X171.193 Y154.424 E.00744
G2 X168.459 Y158.306 I3.854 J5.618 E.17774
; LINE_WIDTH: 0.551443
G2 X168.238 Y159.89 I6.638 J1.735 E.06645
; LINE_WIDTH: 0.582844
G1 X168.235 Y167.105 E.31742
; WIPE_START
G1 F6667.606
G1 X168.236 Y165.105 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X170.359 Y157.774 Z11.8 F60000
G1 X171.362 Y154.312 Z11.8
G1 Z11.4
G1 E.8 F1800
; LINE_WIDTH: 0.509163
G1 F1200
M204 S8000
G3 X173.414 Y153.432 I3.69 J5.77 E.08519
G1 X173.596 Y153.39 E.00709
; LINE_WIDTH: 0.578794
G3 X174.892 Y153.238 I1.451 J6.775 E.05708
G1 X182.105 Y153.235 E.31497
; CHANGE_LAYER
; Z_HEIGHT: 11.6
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F6717.997
G1 X180.105 Y153.236 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 58/58
; update layer progress
M73 L58
M991 S0 P57 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z11.8 I-.272 J-1.186 P1  F60000
G1 X171.517 Y155.206 Z11.8
G1 Z11.6
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1203
M204 S5000
G1 X171.103 Y155.523 E.01602
G2 X169.101 Y159.907 I3.809 J4.39 E.15269
G1 X169.101 Y167.701 E.23949
G1 X167.37 Y167.701 E.05318
G1 X167.371 Y160.025 E.23586
G3 X175.024 Y152.371 I7.808 J.154 E.36742
G1 X182.701 Y152.37 E.23589
G1 X182.701 Y154.101 E.05318
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X174.908 Y154.101 E.23944
G2 X171.665 Y155.093 I.005 J5.812 E.10575
G1 X171.564 Y155.169 E.00389
; WIPE_START
G1 F9547.055
M204 S8000
G1 X171.103 Y155.523 E-.22087
G1 X170.731 Y155.875 E-.19446
G1 X170.27 Y156.415 E-.26999
G1 X170.159 Y156.577 E-.07468
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X177.6 Y154.877 Z12 F60000
G1 X181.906 Y153.893 Z12
G1 Z11.6
G1 E.8 F1800
; FEATURE: Top surface
G1 F1507
M204 S2000
G1 X182.493 Y153.306 E.0255
G1 X182.627 Y153.173
G1 X182.627 Y152.64
G1 X182.493 Y152.773
G1 X181.373 Y153.893 E.04867
G1 X181.24 Y154.027
G1 X180.706 Y154.027
G1 X180.84 Y153.893
G1 X182.156 Y152.578 E.05718
G1 X182.289 Y152.444
G1 X181.756 Y152.444
G1 X181.622 Y152.578
G1 X180.307 Y153.893 E.05717
G1 X180.173 Y154.027
G1 X179.64 Y154.027
G1 X179.773 Y153.893
G1 X181.089 Y152.578 E.05717
G1 X181.223 Y152.444
G1 X180.689 Y152.444
G1 X180.556 Y152.578
G1 X179.24 Y153.893 E.05716
G1 X179.107 Y154.027
G1 X178.573 Y154.027
G1 X178.707 Y153.893
G1 X180.022 Y152.578 E.05716
G1 X180.156 Y152.444
G1 X179.623 Y152.444
G1 X179.489 Y152.578
G1 X178.174 Y153.893 E.05716
G1 X178.04 Y154.027
G1 X177.507 Y154.027
G1 X177.64 Y153.893
G1 X178.956 Y152.578 E.05715
G1 X179.089 Y152.444
G1 X178.556 Y152.445
G1 X178.422 Y152.578
G1 X177.107 Y153.893 E.05715
G1 X176.974 Y154.027
G1 X176.44 Y154.027
G1 X176.574 Y153.893
G1 X177.889 Y152.578 E.05715
G1 X178.023 Y152.445
G1 X177.489 Y152.445
G1 X177.356 Y152.578
G1 X176.041 Y153.893 E.05714
G1 X175.907 Y154.027
G1 X175.374 Y154.027
G1 X175.507 Y153.893
G1 X176.822 Y152.578 E.05714
G1 X176.956 Y152.445
G1 X176.423 Y152.445
G1 X176.289 Y152.579
G1 X174.974 Y153.893 E.05714
G1 X174.841 Y154.027
G1 X174.277 Y154.057
G1 X174.411 Y153.923
G1 X175.756 Y152.579 E.05844
G1 X175.889 Y152.445
G1 X175.356 Y152.445
G1 X175.222 Y152.579
G1 X173.804 Y153.997 E.06164
G1 X173.67 Y154.131
G1 X172.952 Y154.316
G1 X173.085 Y154.183
G1 X174.663 Y152.604 E.06858
G1 X174.797 Y152.471
G1 X174.208 Y152.526
G1 X174.075 Y152.66
G1 X172.186 Y154.549 E.08209
; WIPE_START
G1 F9547.055
M204 S8000
G1 X173.6 Y153.134 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.132 Y160.357 Z12 F60000
G1 X168.893 Y166.906 Z12
G1 Z11.6
G1 E.8 F1800
G1 F1507
M204 S2000
G1 X168.306 Y167.493 E.0255
G1 X168.173 Y167.627
G1 X167.64 Y167.627
G1 X167.773 Y167.493
G1 X168.893 Y166.373 E.04868
G1 X169.027 Y166.24
G1 X169.027 Y165.706
G1 X168.893 Y165.84
G1 X167.578 Y167.156 E.05718
G1 X167.444 Y167.289
G1 X167.444 Y166.756
G1 X167.578 Y166.622
G1 X168.893 Y165.307 E.05717
G1 X169.027 Y165.173
G1 X169.027 Y164.64
G1 X168.893 Y164.773
G1 X167.578 Y166.089 E.05717
G1 X167.444 Y166.223
G1 X167.444 Y165.689
G1 X167.578 Y165.556
G1 X168.893 Y164.24 E.05717
G1 X169.027 Y164.107
G1 X169.027 Y163.573
G1 X168.893 Y163.707
G1 X167.578 Y165.022 E.05716
G1 X167.444 Y165.156
G1 X167.444 Y164.623
G1 X167.578 Y164.489
G1 X168.893 Y163.174 E.05716
M73 P98 R0
G1 X169.027 Y163.04
G1 X169.027 Y162.507
G1 X168.893 Y162.64
G1 X167.578 Y163.956 E.05715
G1 X167.444 Y164.089
G1 X167.445 Y163.556
G1 X167.578 Y163.422
G1 X168.893 Y162.107 E.05715
G1 X169.027 Y161.974
G1 X169.027 Y161.44
G1 X168.893 Y161.574
G1 X167.578 Y162.889 E.05715
G1 X167.445 Y163.023
G1 X167.445 Y162.489
G1 X167.578 Y162.356
G1 X168.893 Y161.041 E.05714
G1 X169.027 Y160.907
G1 X169.027 Y160.374
G1 X168.893 Y160.507
G1 X167.578 Y161.822 E.05714
G1 X167.445 Y161.956
G1 X167.445 Y161.423
G1 X167.579 Y161.289
G1 X168.893 Y159.974 E.05714
G1 X169.027 Y159.84
G1 X169.048 Y159.286
G1 X168.915 Y159.42
G1 X167.579 Y160.756 E.05805
G1 X167.445 Y160.889
G1 X167.445 Y160.356
G1 X167.579 Y160.222
G1 X169.002 Y158.799 E.06184
G1 X169.135 Y158.666
G1 X169.315 Y157.953
G1 X169.181 Y158.087
G1 X167.601 Y159.667 E.06866
G1 X167.467 Y159.8
G1 X167.53 Y159.204
G1 X167.664 Y159.071
G1 X169.555 Y157.18 E.08217
; WIPE_START
G1 F9547.055
M204 S8000
G1 X168.14 Y158.594 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X167.789 Y158.412 Z12 F60000
G1 Z11.6
G1 E.8 F1800
G1 F1507
M204 S2000
G1 X173.408 Y152.793 E.24416
G1 X173.542 Y152.66
G1 X172.796 Y152.872
G1 X172.662 Y153.006
G1 X168.009 Y157.659 E.20222
G1 X167.875 Y157.793
G1 X168.273 Y156.862
G1 X168.406 Y156.728
G1 X171.723 Y153.412 E.1441
; WIPE_START
G1 F9547.055
M204 S8000
G1 X170.308 Y154.826 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.197 Y154.56 Z12 F60000
G1 Z11.6
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.210316
G1 F1507
M204 S8000
G1 X172.053 Y154.538 E.00199
; LINE_WIDTH: 0.198066
G1 X171.94 Y154.625 E.0018
; LINE_WIDTH: 0.160893
G1 X171.827 Y154.712 E.00137
; LINE_WIDTH: 0.123435
G1 X171.712 Y154.8 E.00095
; LINE_WIDTH: 0.096405
G1 X171.628 Y154.869 E.00047
; WIPE_START
G1 F15000
G1 X171.712 Y154.8 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.185 Y153.19 Z12 F60000
G1 Z11.6
G1 E.8 F1800
; LINE_WIDTH: 0.109918
G1 F1507
M204 S8000
G1 X172.082 Y153.26 E.00068
; LINE_WIDTH: 0.153404
G1 X171.978 Y153.33 E.00113
; LINE_WIDTH: 0.197542
G1 X171.784 Y153.473 E.00304
M204 S10000
G1 X171.033 Y153.806 F60000
; LINE_WIDTH: 0.100681
G1 F1507
M204 S8000
G1 X170.931 Y153.889 E.00062
; LINE_WIDTH: 0.125721
G1 X170.829 Y153.971 E.00088
; LINE_WIDTH: 0.162428
G1 X170.533 Y154.234 E.00386
; LINE_WIDTH: 0.210779
G1 X170.236 Y154.496 E.00542
; LINE_WIDTH: 0.241232
G2 X169.405 Y155.335 I10.18 J10.921 E.01908
; LINE_WIDTH: 0.203008
G1 X169.189 Y155.581 E.00427
; LINE_WIDTH: 0.160126
G1 X168.973 Y155.827 E.00313
; LINE_WIDTH: 0.126071
G1 X168.893 Y155.926 E.00086
; LINE_WIDTH: 0.100802
G1 X168.814 Y156.026 E.0006
; WIPE_START
G1 F15000
G1 X168.893 Y155.926 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X169.873 Y156.623 Z12 F60000
G1 Z11.6
G1 E.8 F1800
; LINE_WIDTH: 0.1124
G1 F1507
M204 S8000
G1 X169.739 Y156.794 E.00123
; LINE_WIDTH: 0.160858
G1 X169.604 Y156.965 E.00209
; LINE_WIDTH: 0.20155
G1 X169.493 Y157.118 E.00245
; WIPE_START
G1 F15000
G1 X169.604 Y156.965 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X167.845 Y158.467 Z12 F60000
G1 Z11.6
G1 E.8 F1800
; LINE_WIDTH: 0.0882724
G1 F1507
M204 S8000
G1 X167.71 Y158.735 E.00111
; close powerlost recovery
M1003 S0
; WIPE_START
G1 F15000
G1 X167.845 Y158.467 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z12 I1.217 J0 P1  F60000
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
G1 Z12 F900 ; lower z a little
M1002 judge_flag timelapse_record_flag
M622 J1
    G150.3
    M400 ; wait all motion done
    M991 S0 P-1 ;end smooth timelapse at safe pos
    M400 S5 ;wait for last picture to be taken
M623  ;end of "timelapse_record_flag"

G90
G1 Z21.6 F900 ; lower z a little

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

    
        G1 Z105.8 F600
        G1 Z103.8
    

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

