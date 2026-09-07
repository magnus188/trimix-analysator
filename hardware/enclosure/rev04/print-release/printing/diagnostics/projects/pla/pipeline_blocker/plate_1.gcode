; HEADER_BLOCK_START
; BambuStudio 02.08.02.61
; model printing time: 7m 44s; total estimated time: 13m 12s
; total layer number: 70
; total filament length [mm] : 341.67
; total filament volume [cm^3] : 821.82
; total filament weight [g] : 1.02
; filament_density: 1.24
; filament_diameter: 1.75
; max_z_height: 14.00
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
; different_settings_to_system = enable_prime_tower;;
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
; extruder_nozzle_stats_new = Standard#1;Standard#1
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
; wipe_tower_x = 165
; wipe_tower_y = 250
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
M73 P3 R12
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
M73 P6 R12
G1 Z5 F1200
G90
G1 X175 Y160 F30000

M622 J1
    M1002 gcode_claim_action : 1
    G29.20 A3
    G29 A1 O X165.193 Y151.193 I15.8066 J17.6131 R
    M400
M623

M622 J2
    M1002 gcode_claim_action : 1
    
        G29.20 A4
        G29 A2 O X165.193 Y151.193 I15.8066 J17.6131 R
    
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
M73 P39 R8
G1 Z5 F1200
G1 X270 Y-0.5 F60000
G28.140 S0 ; cali pre-extrude z pos

M141 S0
M104 S220 A

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
M73 P39 R7
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
; layer num/total_layer_count: 1/70
; update layer progress
M73 L1
M991 S0 P0 ;notify layer change

M106 S0
M106 P2 S0
; OBJECT_ID: 15
M73 P40 R7
G1 X166.372 Y152.574 F60000
M204 S6000
M73 P41 R7
G1 Z.4
G1 Z.2
G1 E.8 F1800
; FEATURE: Brim
; LINE_WIDTH: 0.5
G1 F3000
M204 S500
G1 X166.788 Y152.19 E.02109
G1 X167.263 Y151.878 E.02118
G1 X167.644 Y151.7 E.01565
G1 X168.288 Y151.498 E.02516
G1 X169.012 Y151.422 E.0271
G1 X172.991 Y151.422 E.14819
G1 X173.56 Y151.469 E.02127
G1 X174.471 Y151.752 E.03555
G1 X174.978 Y152.025 E.02144
G1 X175.426 Y152.372 E.02109
G1 X175.81 Y152.788 E.02109
G1 X176.122 Y153.262 E.02113
G1 X176.339 Y153.743 E.01967
G1 X176.502 Y154.287 E.02114
G1 X176.578 Y155.012 E.02716
G1 X176.578 Y164.991 E.37166
G1 X176.531 Y165.56 E.02127
G1 X176.289 Y166.375 E.03169
G1 X175.974 Y166.98 E.02537
G1 X175.628 Y167.426 E.02104
G1 X175.212 Y167.81 E.02109
G1 X174.737 Y168.122 E.02118
G1 X174.356 Y168.3 E.01565
G1 X173.712 Y168.502 E.02516
G1 X172.988 Y168.578 E.0271
G1 X169.009 Y168.578 E.14819
G1 X168.44 Y168.531 E.02127
G1 X167.625 Y168.289 E.03169
G1 X167.02 Y167.974 E.02537
G1 X166.574 Y167.628 E.02104
G1 X166.19 Y167.212 E.02109
G1 X165.878 Y166.737 E.02118
G1 X165.7 Y166.356 E.01565
G1 X165.498 Y165.712 E.02516
G1 X165.422 Y164.988 E.0271
G1 X165.422 Y155.009 E.37167
G1 X165.469 Y154.44 E.02127
G1 X165.711 Y153.625 E.03169
G1 X166.026 Y153.02 E.02537
G1 X166.335 Y152.621 E.0188
M204 S6000
G1 X166.697 Y152.904 F60000
G1 F3000
M204 S500
G1 X166.718 Y152.876 E.00131
G1 X167.062 Y152.559 E.01742
G1 X167.478 Y152.283 E.01859
G1 X167.801 Y152.131 E.01332
G1 X168.368 Y151.952 E.02215
G1 X169.043 Y151.879 E.02527
G1 X172.977 Y151.88 E.14654
G1 X173.486 Y151.925 E.01904
G1 X174.281 Y152.171 E.03099
G1 X174.718 Y152.404 E.01844
G1 X175.107 Y152.703 E.01827
G1 X175.441 Y153.062 E.01826
G1 X175.714 Y153.474 E.0184
G1 X175.906 Y153.895 E.01726
G1 X176.048 Y154.365 E.01827
G1 X176.121 Y155.043 E.0254
G1 X176.121 Y164.966 E.36959
G1 X176.075 Y165.489 E.01954
G1 X175.867 Y166.191 E.02728
G1 X175.58 Y166.742 E.02314
G1 X175.282 Y167.124 E.01805
G1 X174.938 Y167.441 E.01742
G1 X174.522 Y167.717 E.01859
G1 X174.199 Y167.869 E.01332
G1 X173.632 Y168.048 E.02215
G1 X172.957 Y168.121 E.02527
G1 X169.034 Y168.121 E.14611
G1 X168.511 Y168.075 E.01954
G1 X167.809 Y167.867 E.02728
G1 X167.258 Y167.58 E.02314
G1 X166.876 Y167.282 E.01805
G1 X166.559 Y166.938 E.01742
G1 X166.283 Y166.522 E.01859
G1 X166.131 Y166.199 E.01332
G1 X165.946 Y165.605 E.02317
G1 X165.879 Y164.957 E.02425
G1 X165.879 Y155.034 E.3696
G1 X165.925 Y154.511 E.01953
G1 X166.133 Y153.809 E.02728
G1 X166.42 Y153.258 E.02314
G1 X166.66 Y152.951 E.01451
M204 S6000
G1 X167.02 Y153.233 F60000
G1 F3000
M204 S500
G1 X167.049 Y153.196 E.00175
G1 X167.336 Y152.927 E.01466
G1 X167.694 Y152.688 E.01602
G1 X167.96 Y152.562 E.01097
G1 X168.45 Y152.405 E.01914
G1 X169.075 Y152.336 E.02343
G1 X172.951 Y152.337 E.14437
G1 X173.411 Y152.38 E.01723
G1 X174.092 Y152.591 E.02655
G1 X174.46 Y152.784 E.01546
G1 X174.789 Y153.035 E.01543
G1 X175.073 Y153.337 E.01543
G1 X175.307 Y153.687 E.01567
G1 X175.48 Y154.066 E.01552
G1 X175.6 Y154.469 E.01567
G1 X175.664 Y155.075 E.02268
G1 X175.664 Y164.94 E.36744
G1 X175.62 Y165.416 E.01781
G1 X175.445 Y166.006 E.02292
G1 X175.186 Y166.503 E.02088
G1 X174.951 Y166.804 E.01423
G1 X174.664 Y167.073 E.01466
G1 X174.306 Y167.312 E.01602
G1 X174.04 Y167.438 E.01097
G1 X173.524 Y167.6 E.02015
G1 X172.925 Y167.664 E.02242
G1 X169.06 Y167.664 E.14395
G1 X168.584 Y167.62 E.01781
G1 X167.994 Y167.445 E.02292
G1 X167.497 Y167.186 E.02088
G1 X167.196 Y166.951 E.01423
G1 X166.927 Y166.664 E.01466
G1 X166.688 Y166.306 E.01602
G1 X166.562 Y166.041 E.01092
G1 X166.395 Y165.499 E.02114
G1 X166.336 Y164.926 E.02143
G1 X166.336 Y155.06 E.36749
G1 X166.38 Y154.584 E.0178
G1 X166.555 Y153.994 E.02292
G1 X166.814 Y153.497 E.02088
G1 X166.983 Y153.28 E.01024
M204 S6000
G1 X167.342 Y153.564 F60000
G1 F3000
M204 S500
G1 X167.395 Y153.498 E.00314
G1 X167.613 Y153.294 E.01112
G1 X167.912 Y153.092 E.01346
G1 X168.12 Y152.992 E.0086
G1 X168.532 Y152.859 E.01613
G1 X169.108 Y152.793 E.02157
G1 X172.923 Y152.794 E.1421
G1 X173.335 Y152.835 E.01542
G1 X173.905 Y153.012 E.02224
G1 X174.203 Y153.166 E.0125
G1 X174.473 Y153.369 E.01259
G1 X174.706 Y153.614 E.0126
G1 X174.9 Y153.901 E.0129
G1 X175.054 Y154.236 E.01371
G1 X175.151 Y154.571 E.01302
G1 X175.207 Y155.106 E.02002
G1 X175.207 Y164.913 E.36525
G1 X175.165 Y165.342 E.01608
G1 X175.023 Y165.822 E.01862
G1 X174.793 Y166.265 E.01862
G1 X174.605 Y166.502 E.01124
G1 X174.387 Y166.706 E.01112
G1 X174.088 Y166.908 E.01346
G1 X173.881 Y167.008 E.00854
G1 X173.417 Y167.152 E.01812
G1 X172.893 Y167.207 E.01959
G1 X169.087 Y167.207 E.14176
G1 X168.658 Y167.165 E.01608
G1 X168.178 Y167.023 E.01862
G1 X167.756 Y166.806 E.01769
G1 X167.514 Y166.62 E.01138
G1 X167.294 Y166.387 E.01192
G1 X167.092 Y166.088 E.01346
G1 X166.986 Y165.865 E.00918
G1 X166.849 Y165.42 E.01734
G1 X166.794 Y164.91 E.01911
G1 X166.793 Y155.087 E.36586
G1 X166.835 Y154.658 E.01607
G1 X166.977 Y154.178 E.01862
G1 X167.207 Y153.735 E.01862
G1 X167.305 Y153.611 E.00587
M204 S6000
G1 X167.659 Y153.919 F60000
G1 F3000
M204 S500
G1 X167.821 Y153.734 E.00918
G1 X167.92 Y153.65 E.00484
G1 X168.302 Y153.417 E.01664
G1 X168.528 Y153.337 E.00892
G1 X169.035 Y153.25 E.01917
G1 X172.972 Y153.25 E.14664
G1 X173.269 Y153.285 E.01115
G1 X173.724 Y153.433 E.01781
G1 X173.846 Y153.496 E.00511
G1 X174.13 Y153.693 E.01287
G1 X174.23 Y153.783 E.00503
G1 X174.45 Y154.059 E.01314
G1 X174.569 Y154.27 E.00903
G1 X174.659 Y154.495 E.00901
G1 X174.75 Y155.036 E.02043
G1 X174.731 Y165.169 E.37742
G1 X174.671 Y165.457 E.01097
G1 X174.58 Y165.697 E.00957
G1 X174.407 Y166 E.01298
G1 X174.291 Y166.154 E.00717
G1 X173.939 Y166.451 E.01716
G1 X173.73 Y166.569 E.00896
G1 X173.505 Y166.659 E.00901
G1 X172.965 Y166.75 E.02042
G1 X169.028 Y166.75 E.14662
G1 X168.731 Y166.715 E.01116
G1 X168.276 Y166.567 E.0178
G1 X168.154 Y166.504 E.00511
G1 X167.87 Y166.307 E.01287
G1 X167.77 Y166.217 E.00503
G1 X167.55 Y165.941 E.01314
G1 X167.431 Y165.73 E.00903
G1 X167.341 Y165.505 E.00901
G1 X167.25 Y164.964 E.02043
G1 X167.269 Y154.832 E.37738
G1 X167.338 Y154.519 E.01195
G1 X167.44 Y154.258 E.01042
G1 X167.599 Y153.988 E.01166
G1 X167.62 Y153.965 E.00118
M204 S6000
G1 X167.99 Y154.225 F60000
G1 F3000
M204 S500
G1 X168.162 Y154.038 E.00948
G1 X168.461 Y153.845 E.01324
G1 X168.605 Y153.788 E.00579
G1 X169.023 Y153.707 E.01585
G1 X172.98 Y153.707 E.14737
G1 X173.221 Y153.739 E.00905
G1 X173.578 Y153.866 E.01411
G1 X173.877 Y154.073 E.01354
G1 X174.047 Y154.274 E.0098
G1 X174.176 Y154.503 E.00979
G1 X174.234 Y154.662 E.00629
G1 X174.293 Y155.024 E.01367
G1 X174.285 Y165.071 E.37421
G1 X174.24 Y165.308 E.00899
G1 X174.188 Y165.461 E.00602
G1 X174.006 Y165.781 E.01371
M73 P42 R7
G1 X173.931 Y165.873 E.00444
G1 X173.726 Y166.047 E.01
G1 X173.497 Y166.176 E.00979
G1 X173.338 Y166.234 E.00629
G1 X172.976 Y166.293 E.01368
G1 X169.02 Y166.293 E.14734
G1 X168.779 Y166.261 E.00906
G1 X168.422 Y166.134 E.01411
G1 X168.123 Y165.927 E.01355
G1 X167.953 Y165.726 E.0098
G1 X167.824 Y165.497 E.00979
G1 X167.766 Y165.338 E.0063
G1 X167.707 Y164.976 E.01367
G1 X167.715 Y154.929 E.37421
G1 X167.76 Y154.696 E.00885
G1 X167.87 Y154.415 E.01122
G1 X167.958 Y154.276 E.00615
M204 S6000
G1 X168.345 Y154.519 F60000
G1 F3000
M204 S500
G1 X168.383 Y154.458 E.0027
G1 X168.485 Y154.36 E.00529
G1 X168.698 Y154.235 E.00918
G1 X169.01 Y154.164 E.01191
G1 X172.989 Y154.164 E.1482
G1 X173.155 Y154.191 E.00626
G1 X173.33 Y154.25 E.00687
G1 X173.542 Y154.383 E.00934
G1 X173.642 Y154.487 E.00539
G1 X173.783 Y154.737 E.01069
G1 X173.836 Y155.013 E.01045
G1 X173.836 Y164.989 E.37157
G1 X173.809 Y165.155 E.00626
G1 X173.75 Y165.33 E.00687
G1 X173.617 Y165.542 E.00934
G1 X173.513 Y165.642 E.00539
G1 X173.263 Y165.783 E.01069
G1 X172.987 Y165.836 E.01045
G1 X169.011 Y165.836 E.14809
G1 X168.845 Y165.809 E.00626
G1 X168.67 Y165.75 E.00687
G1 X168.458 Y165.617 E.00934
G1 X168.358 Y165.513 E.00539
G1 X168.217 Y165.263 E.01069
G1 X168.164 Y164.987 E.01045
G1 X168.164 Y155.011 E.37157
G1 X168.191 Y154.845 E.00626
G1 X168.25 Y154.67 E.00687
G1 X168.313 Y154.57 E.0044
M204 S6000
G1 X168.688 Y154.799 F60000
G1 F3000
M204 S500
G1 X168.814 Y154.677 E.00651
G1 X169 Y154.621 E.00722
G1 X173 Y154.621 E.14899
G1 X173.201 Y154.688 E.0079
G1 X173.323 Y154.814 E.00651
G1 X173.363 Y154.916 E.00408
G1 X173.379 Y155 E.00317
G1 X173.379 Y165 E.37246
G1 X173.312 Y165.201 E.0079
G1 X173.186 Y165.323 E.00651
G1 X173.084 Y165.363 E.00408
G1 X173 Y165.379 E.00317
G1 X169 Y165.379 E.14899
G1 X168.799 Y165.312 E.0079
G1 X168.677 Y165.186 E.00651
G1 X168.637 Y165.084 E.00408
G1 X168.621 Y165 E.00317
G1 X168.621 Y155 E.37246
G1 X168.669 Y154.856 E.00566
; WIPE_START
G1 X168.814 Y154.677 E-.08729
G1 X169 Y154.621 E-.07367
G1 X170.576 Y154.621 E-.59903
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X172.093 Y162.102 Z.6 F60000
G1 X172.6 Y164.6 Z.6
G1 Z.2
G1 E.8 F1800
; FEATURE: Outer wall
G1 F3000
M204 S500
G1 X169.4 Y164.6 E.11919
G1 X169.4 Y155.4 E.34267
G1 X172.6 Y155.4 E.11919
G1 X172.6 Y164.54 E.34043
;======== H2D 20260731========
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
G1 X172.143 Y164.143 F60000
; FEATURE: Inner wall
G1 F3000
M204 S500
G1 X169.857 Y164.143 E.08514
G1 X169.857 Y155.857 E.30862
G1 X172.143 Y155.857 E.08514
G1 X172.143 Y164.083 E.30638
M204 S6000
G1 X171.686 Y163.686 F60000
G1 F3000
M204 S500
G1 X170.314 Y163.686 E.05109
G1 X170.314 Y156.314 E.27457
G1 X171.686 Y156.314 E.05109
G1 X171.686 Y163.626 E.27233
M204 S6000
G1 X171.229 Y163.229 F60000
G1 F3000
M204 S500
G1 X170.771 Y163.229 E.01704
G1 X170.771 Y156.771 E.24052
G1 X171.229 Y156.771 E.01704
G1 X171.229 Y163.169 E.23829
; CHANGE_LAYER
; Z_HEIGHT: 0.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F3000
G1 X170.771 Y163.229 E-.17537
G1 X170.771 Y161.69 E-.58463
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 2/70
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
G3 Z.6 I-1.118 J.48 P1  F60000
G1 X171.584 Y163.584 Z.6
G1 Z.4
G1 E.8 F1800
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X170.416 Y163.584 E.03873
G1 X170.416 Y156.416 E.23776
G1 X171.584 Y156.416 E.03873
G1 X171.584 Y163.524 E.23577
M204 S10000
G1 X171.991 Y163.991 F60000
G1 F1200
M204 S8000
G1 X170.009 Y163.991 E.06574
G1 X170.009 Y156.009 E.26477
G1 X171.991 Y156.009 E.06574
G1 X171.991 Y163.931 E.26278
M204 S10000
G1 X172.398 Y164.398 F60000
G1 F1200
M204 S8000
G1 X169.602 Y164.398 E.09274
G1 X169.602 Y155.602 E.29178
G1 X172.398 Y155.602 E.09274
G1 X172.398 Y164.338 E.28979
M204 S250
G1 X172.79 Y164.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X169.21 Y164.79 E.11
M73 P43 R7
G1 X169.21 Y155.21 E.29437
G1 X172.79 Y155.21 E.11
G1 X172.79 Y164.73 E.29252
;======== H2D 20260731========
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
G1 X170.79 Y164.764 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.183 Y157.141 Z.8 F60000
G1 X171.19 Y157 Z.8
G1 Z.4
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42318
G1 F1200
M204 S8000
G1 X171.19 Y156.81 E.00589
G1 X170.81 Y156.81 E.01178
G1 X170.81 Y163.19 E.1977
G1 X171.19 Y163.19 E.01178
G1 X171.19 Y157.06 E.18995
; CHANGE_LAYER
; Z_HEIGHT: 0.6
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9467.206
G1 X171.19 Y159.06 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 3/70
; update layer progress
M73 L3
M991 S0 P2 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z.8 I-1.212 J.106 P1  F60000
G1 X171.584 Y163.584 Z.8
G1 Z.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X170.416 Y163.584 E.03873
G1 X170.416 Y156.416 E.23776
G1 X171.584 Y156.416 E.03873
G1 X171.584 Y163.524 E.23577
; COOLING_NODE: 0
M204 S10000
G1 X171.991 Y163.991 F60000
G1 F1200
M204 S8000
G1 X170.009 Y163.991 E.06574
G1 X170.009 Y156.009 E.26477
G1 X171.991 Y156.009 E.06574
G1 X171.991 Y163.931 E.26278
; COOLING_NODE: 0
M204 S10000
G1 X172.398 Y164.398 F60000
G1 F1200
M204 S8000
G1 X169.602 Y164.398 E.09274
G1 X169.602 Y155.602 E.29178
G1 X172.398 Y155.602 E.09274
G1 X172.398 Y164.338 E.28979
; COOLING_NODE: 0
M204 S250
G1 X172.79 Y164.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X169.21 Y164.79 E.11
G1 X169.21 Y155.21 E.29437
G1 X172.79 Y155.21 E.11
G1 X172.79 Y164.73 E.29252
;======== H2D 20260731========
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
G1 X170.79 Y164.764 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.183 Y157.141 Z1 F60000
G1 X171.19 Y157 Z1
G1 Z.6
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42318
G1 F1200
M204 S8000
G1 X171.19 Y156.81 E.00589
G1 X170.81 Y156.81 E.01178
G1 X170.81 Y163.19 E.1977
G1 X171.19 Y163.19 E.01178
G1 X171.19 Y157.06 E.18995
; CHANGE_LAYER
; Z_HEIGHT: 0.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9467.206
G1 X171.19 Y159.06 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 4/70
; update layer progress
M73 L4
M991 S0 P3 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z1 I-1.212 J.106 P1  F60000
G1 X171.584 Y163.584 Z1
G1 Z.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
M73 P44 R7
G1 F1200
M204 S8000
G1 X170.416 Y163.584 E.03873
G1 X170.416 Y156.416 E.23776
G1 X171.584 Y156.416 E.03873
G1 X171.584 Y163.524 E.23577
; COOLING_NODE: 0
M204 S10000
G1 X171.991 Y163.991 F60000
G1 F1200
M204 S8000
G1 X170.009 Y163.991 E.06574
G1 X170.009 Y156.009 E.26477
G1 X171.991 Y156.009 E.06574
G1 X171.991 Y163.931 E.26278
; COOLING_NODE: 0
M204 S10000
G1 X172.398 Y164.398 F60000
G1 F1200
M204 S8000
G1 X169.602 Y164.398 E.09274
G1 X169.602 Y155.602 E.29178
G1 X172.398 Y155.602 E.09274
G1 X172.398 Y164.338 E.28979
; COOLING_NODE: 0
M204 S250
G1 X172.79 Y164.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X169.21 Y164.79 E.11
G1 X169.21 Y155.21 E.29437
G1 X172.79 Y155.21 E.11
G1 X172.79 Y164.73 E.29252
;======== H2D 20260731========
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
G1 X170.79 Y164.764 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.183 Y157.141 Z1.2 F60000
G1 X171.19 Y157 Z1.2
G1 Z.8
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42318
G1 F1200
M204 S8000
G1 X171.19 Y156.81 E.00589
G1 X170.81 Y156.81 E.01178
G1 X170.81 Y163.19 E.1977
G1 X171.19 Y163.19 E.01178
G1 X171.19 Y157.06 E.18995
; CHANGE_LAYER
; Z_HEIGHT: 1
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9467.206
G1 X171.19 Y159.06 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 5/70
; update layer progress
M73 L5
M991 S0 P4 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z1.2 I-1.212 J.106 P1  F60000
G1 X171.584 Y163.584 Z1.2
G1 Z1
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X170.416 Y163.584 E.03873
G1 X170.416 Y156.416 E.23776
G1 X171.584 Y156.416 E.03873
G1 X171.584 Y163.524 E.23577
; COOLING_NODE: 0
M204 S10000
G1 X171.991 Y163.991 F60000
G1 F1200
M204 S8000
G1 X170.009 Y163.991 E.06574
G1 X170.009 Y156.009 E.26477
G1 X171.991 Y156.009 E.06574
G1 X171.991 Y163.931 E.26278
; COOLING_NODE: 0
M204 S10000
G1 X172.398 Y164.398 F60000
G1 F1200
M204 S8000
G1 X169.602 Y164.398 E.09274
G1 X169.602 Y155.602 E.29178
G1 X172.398 Y155.602 E.09274
G1 X172.398 Y164.338 E.28979
; COOLING_NODE: 0
M204 S250
G1 X172.79 Y164.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
M73 P45 R7
G1 F1200
M204 S5000
G1 X169.21 Y164.79 E.11
G1 X169.21 Y155.21 E.29437
G1 X172.79 Y155.21 E.11
G1 X172.79 Y164.73 E.29252
;======== H2D 20260731========
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
G1 X170.79 Y164.764 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.183 Y157.141 Z1.4 F60000
G1 X171.19 Y157 Z1.4
G1 Z1
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42318
G1 F1200
M204 S8000
G1 X171.19 Y156.81 E.00589
G1 X170.81 Y156.81 E.01178
G1 X170.81 Y163.19 E.1977
G1 X171.19 Y163.19 E.01178
G1 X171.19 Y157.06 E.18995
; CHANGE_LAYER
; Z_HEIGHT: 1.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9467.206
G1 X171.19 Y159.06 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 6/70
; update layer progress
M73 L6
M991 S0 P5 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z1.4 I-1.212 J.106 P1  F60000
G1 X171.584 Y163.584 Z1.4
G1 Z1.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X170.416 Y163.584 E.03873
G1 X170.416 Y156.416 E.23776
G1 X171.584 Y156.416 E.03873
G1 X171.584 Y163.524 E.23577
; COOLING_NODE: 0
M204 S10000
G1 X171.991 Y163.991 F60000
G1 F1200
M204 S8000
G1 X170.009 Y163.991 E.06574
G1 X170.009 Y156.009 E.26477
G1 X171.991 Y156.009 E.06574
G1 X171.991 Y163.931 E.26278
; COOLING_NODE: 0
M204 S10000
G1 X172.398 Y164.398 F60000
G1 F1200
M204 S8000
G1 X169.602 Y164.398 E.09274
G1 X169.602 Y155.602 E.29178
G1 X172.398 Y155.602 E.09274
G1 X172.398 Y164.338 E.28979
; COOLING_NODE: 0
M204 S250
G1 X172.79 Y164.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X169.21 Y164.79 E.11
G1 X169.21 Y155.21 E.29437
G1 X172.79 Y155.21 E.11
G1 X172.79 Y164.73 E.29252
;======== H2D 20260731========
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
G1 X170.79 Y164.764 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.183 Y157.141 Z1.6 F60000
G1 X171.19 Y157 Z1.6
G1 Z1.2
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42318
G1 F1200
M204 S8000
G1 X171.19 Y156.81 E.00589
G1 X170.81 Y156.81 E.01178
G1 X170.81 Y163.19 E.1977
G1 X171.19 Y163.19 E.01178
G1 X171.19 Y157.06 E.18995
; CHANGE_LAYER
; Z_HEIGHT: 1.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9467.206
M73 P46 R7
G1 X171.19 Y159.06 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 7/70
; update layer progress
M73 L7
M991 S0 P6 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z1.6 I-1.212 J.106 P1  F60000
G1 X171.584 Y163.584 Z1.6
G1 Z1.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X170.416 Y163.584 E.03873
G1 X170.416 Y156.416 E.23776
G1 X171.584 Y156.416 E.03873
G1 X171.584 Y163.524 E.23577
; COOLING_NODE: 0
M204 S10000
G1 X171.991 Y163.991 F60000
G1 F1200
M204 S8000
G1 X170.009 Y163.991 E.06574
G1 X170.009 Y156.009 E.26477
G1 X171.991 Y156.009 E.06574
G1 X171.991 Y163.931 E.26278
; COOLING_NODE: 0
M204 S10000
G1 X172.398 Y164.398 F60000
G1 F1200
M204 S8000
G1 X169.602 Y164.398 E.09274
G1 X169.602 Y155.602 E.29178
G1 X172.398 Y155.602 E.09274
G1 X172.398 Y164.338 E.28979
; COOLING_NODE: 0
M204 S250
G1 X172.79 Y164.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X169.21 Y164.79 E.11
G1 X169.21 Y155.21 E.29437
G1 X172.79 Y155.21 E.11
G1 X172.79 Y164.73 E.29252
;======== H2D 20260731========
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
G1 X170.79 Y164.764 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.183 Y157.141 Z1.8 F60000
G1 X171.19 Y157 Z1.8
G1 Z1.4
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42318
G1 F1200
M204 S8000
G1 X171.19 Y156.81 E.00589
G1 X170.81 Y156.81 E.01178
G1 X170.81 Y163.19 E.1977
G1 X171.19 Y163.19 E.01178
G1 X171.19 Y157.06 E.18995
; CHANGE_LAYER
; Z_HEIGHT: 1.6
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9467.206
G1 X171.19 Y159.06 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 8/70
; update layer progress
M73 L8
M991 S0 P7 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z1.8 I-1.212 J.106 P1  F60000
G1 X171.584 Y163.584 Z1.8
G1 Z1.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X170.416 Y163.584 E.03873
G1 X170.416 Y156.416 E.23776
G1 X171.584 Y156.416 E.03873
G1 X171.584 Y163.524 E.23577
; COOLING_NODE: 0
M204 S10000
G1 X171.991 Y163.991 F60000
G1 F1200
M204 S8000
G1 X170.009 Y163.991 E.06574
G1 X170.009 Y156.009 E.26477
G1 X171.991 Y156.009 E.06574
G1 X171.991 Y163.931 E.26278
; COOLING_NODE: 0
M204 S10000
G1 X172.398 Y164.398 F60000
G1 F1200
M204 S8000
G1 X169.602 Y164.398 E.09274
G1 X169.602 Y155.602 E.29178
G1 X172.398 Y155.602 E.09274
G1 X172.398 Y164.338 E.28979
; COOLING_NODE: 0
M204 S250
M73 P47 R7
G1 X172.79 Y164.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
M73 P47 R6
G1 F1200
M204 S5000
G1 X169.21 Y164.79 E.11
G1 X169.21 Y155.21 E.29437
G1 X172.79 Y155.21 E.11
G1 X172.79 Y164.73 E.29252
;======== H2D 20260731========
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
G1 X170.79 Y164.764 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.183 Y157.141 Z2 F60000
G1 X171.19 Y157 Z2
G1 Z1.6
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42318
G1 F1200
M204 S8000
G1 X171.19 Y156.81 E.00589
G1 X170.81 Y156.81 E.01178
G1 X170.81 Y163.19 E.1977
G1 X171.19 Y163.19 E.01178
G1 X171.19 Y157.06 E.18995
; CHANGE_LAYER
; Z_HEIGHT: 1.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9467.206
G1 X171.19 Y159.06 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 9/70
; update layer progress
M73 L9
M991 S0 P8 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z2 I-1.212 J.106 P1  F60000
G1 X171.584 Y163.584 Z2
G1 Z1.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X170.416 Y163.584 E.03873
G1 X170.416 Y156.416 E.23776
G1 X171.584 Y156.416 E.03873
G1 X171.584 Y163.524 E.23577
; COOLING_NODE: 0
M204 S10000
G1 X171.991 Y163.991 F60000
G1 F1200
M204 S8000
G1 X170.009 Y163.991 E.06574
G1 X170.009 Y156.009 E.26477
G1 X171.991 Y156.009 E.06574
G1 X171.991 Y163.931 E.26278
; COOLING_NODE: 0
M204 S10000
G1 X172.398 Y164.398 F60000
G1 F1200
M204 S8000
G1 X169.602 Y164.398 E.09274
G1 X169.602 Y155.602 E.29178
G1 X172.398 Y155.602 E.09274
G1 X172.398 Y164.338 E.28979
; COOLING_NODE: 0
M204 S250
G1 X172.79 Y164.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X169.21 Y164.79 E.11
G1 X169.21 Y155.21 E.29437
G1 X172.79 Y155.21 E.11
G1 X172.79 Y164.73 E.29252
;======== H2D 20260731========
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
G1 X170.79 Y164.764 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.183 Y157.141 Z2.2 F60000
G1 X171.19 Y157 Z2.2
G1 Z1.8
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42318
M73 P48 R6
G1 F1200
M204 S8000
G1 X171.19 Y156.81 E.00589
G1 X170.81 Y156.81 E.01178
G1 X170.81 Y163.19 E.1977
G1 X171.19 Y163.19 E.01178
G1 X171.19 Y157.06 E.18995
; CHANGE_LAYER
; Z_HEIGHT: 2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9467.206
G1 X171.19 Y159.06 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 10/70
; update layer progress
M73 L10
M991 S0 P9 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z2.2 I-1.212 J.106 P1  F60000
G1 X171.584 Y163.584 Z2.2
G1 Z2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X170.416 Y163.584 E.03873
G1 X170.416 Y156.416 E.23776
G1 X171.584 Y156.416 E.03873
G1 X171.584 Y163.524 E.23577
; COOLING_NODE: 0
M204 S10000
G1 X171.991 Y163.991 F60000
G1 F1200
M204 S8000
G1 X170.009 Y163.991 E.06574
G1 X170.009 Y156.009 E.26477
G1 X171.991 Y156.009 E.06574
G1 X171.991 Y163.931 E.26278
; COOLING_NODE: 0
M204 S10000
G1 X172.398 Y164.398 F60000
G1 F1200
M204 S8000
G1 X169.602 Y164.398 E.09274
G1 X169.602 Y155.602 E.29178
G1 X172.398 Y155.602 E.09274
G1 X172.398 Y164.338 E.28979
; COOLING_NODE: 0
M204 S250
G1 X172.79 Y164.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X169.21 Y164.79 E.11
G1 X169.21 Y155.21 E.29437
G1 X172.79 Y155.21 E.11
G1 X172.79 Y164.73 E.29252
;======== H2D 20260731========
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
G1 X170.79 Y164.764 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.183 Y157.141 Z2.4 F60000
G1 X171.19 Y157 Z2.4
G1 Z2
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42318
G1 F1200
M204 S8000
G1 X171.19 Y156.81 E.00589
G1 X170.81 Y156.81 E.01178
G1 X170.81 Y163.19 E.1977
G1 X171.19 Y163.19 E.01178
G1 X171.19 Y157.06 E.18995
; CHANGE_LAYER
; Z_HEIGHT: 2.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9467.206
G1 X171.19 Y159.06 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 11/70
; update layer progress
M73 L11
M991 S0 P10 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z2.4 I-1.212 J.106 P1  F60000
G1 X171.584 Y163.584 Z2.4
G1 Z2.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X170.416 Y163.584 E.03873
G1 X170.416 Y156.416 E.23776
G1 X171.584 Y156.416 E.03873
G1 X171.584 Y163.524 E.23577
; COOLING_NODE: 0
M204 S10000
G1 X171.991 Y163.991 F60000
G1 F1200
M204 S8000
G1 X170.009 Y163.991 E.06574
G1 X170.009 Y156.009 E.26477
G1 X171.991 Y156.009 E.06574
G1 X171.991 Y163.931 E.26278
; COOLING_NODE: 0
M204 S10000
G1 X172.398 Y164.398 F60000
G1 F1200
M204 S8000
G1 X169.602 Y164.398 E.09274
M73 P49 R6
G1 X169.602 Y155.602 E.29178
G1 X172.398 Y155.602 E.09274
G1 X172.398 Y164.338 E.28979
; COOLING_NODE: 0
M204 S250
G1 X172.79 Y164.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X169.21 Y164.79 E.11
G1 X169.21 Y155.21 E.29437
G1 X172.79 Y155.21 E.11
G1 X172.79 Y164.73 E.29252
;======== H2D 20260731========
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
G1 X170.79 Y164.764 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.183 Y157.141 Z2.6 F60000
G1 X171.19 Y157 Z2.6
G1 Z2.2
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42318
G1 F1200
M204 S8000
G1 X171.19 Y156.81 E.00589
G1 X170.81 Y156.81 E.01178
G1 X170.81 Y163.19 E.1977
G1 X171.19 Y163.19 E.01178
G1 X171.19 Y157.06 E.18995
; CHANGE_LAYER
; Z_HEIGHT: 2.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9467.206
G1 X171.19 Y159.06 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 12/70
; update layer progress
M73 L12
M991 S0 P11 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z2.6 I-1.212 J.106 P1  F60000
G1 X171.584 Y163.584 Z2.6
G1 Z2.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X170.416 Y163.584 E.03873
G1 X170.416 Y156.416 E.23776
G1 X171.584 Y156.416 E.03873
G1 X171.584 Y163.524 E.23577
; COOLING_NODE: 0
M204 S10000
G1 X171.991 Y163.991 F60000
G1 F1200
M204 S8000
G1 X170.009 Y163.991 E.06574
G1 X170.009 Y156.009 E.26477
G1 X171.991 Y156.009 E.06574
G1 X171.991 Y163.931 E.26278
; COOLING_NODE: 0
M204 S10000
G1 X172.398 Y164.398 F60000
G1 F1200
M204 S8000
G1 X169.602 Y164.398 E.09274
G1 X169.602 Y155.602 E.29178
G1 X172.398 Y155.602 E.09274
G1 X172.398 Y164.338 E.28979
; COOLING_NODE: 0
M204 S250
G1 X172.79 Y164.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X169.21 Y164.79 E.11
G1 X169.21 Y155.21 E.29437
G1 X172.79 Y155.21 E.11
G1 X172.79 Y164.73 E.29252
;======== H2D 20260731========
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
G1 X170.79 Y164.764 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
M73 P50 R6
G1 X171.183 Y157.141 Z2.8 F60000
G1 X171.19 Y157 Z2.8
G1 Z2.4
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42318
G1 F1200
M204 S8000
G1 X171.19 Y156.81 E.00589
G1 X170.81 Y156.81 E.01178
G1 X170.81 Y163.19 E.1977
G1 X171.19 Y163.19 E.01178
G1 X171.19 Y157.06 E.18995
; CHANGE_LAYER
; Z_HEIGHT: 2.6
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9467.206
G1 X171.19 Y159.06 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 13/70
; update layer progress
M73 L13
M991 S0 P12 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z2.8 I-1.212 J.106 P1  F60000
G1 X171.584 Y163.584 Z2.8
G1 Z2.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X170.416 Y163.584 E.03873
G1 X170.416 Y156.416 E.23776
G1 X171.584 Y156.416 E.03873
G1 X171.584 Y163.524 E.23577
; COOLING_NODE: 0
M204 S10000
G1 X171.991 Y163.991 F60000
G1 F1200
M204 S8000
G1 X170.009 Y163.991 E.06574
G1 X170.009 Y156.009 E.26477
G1 X171.991 Y156.009 E.06574
G1 X171.991 Y163.931 E.26278
; COOLING_NODE: 0
M204 S10000
G1 X172.398 Y164.398 F60000
G1 F1200
M204 S8000
G1 X169.602 Y164.398 E.09274
G1 X169.602 Y155.602 E.29178
G1 X172.398 Y155.602 E.09274
G1 X172.398 Y164.338 E.28979
; COOLING_NODE: 0
M204 S250
G1 X172.79 Y164.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X169.21 Y164.79 E.11
G1 X169.21 Y155.21 E.29437
G1 X172.79 Y155.21 E.11
G1 X172.79 Y164.73 E.29252
;======== H2D 20260731========
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
G1 X170.79 Y164.764 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.183 Y157.141 Z3 F60000
G1 X171.19 Y157 Z3
G1 Z2.6
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42318
G1 F1200
M204 S8000
G1 X171.19 Y156.81 E.00589
G1 X170.81 Y156.81 E.01178
G1 X170.81 Y163.19 E.1977
G1 X171.19 Y163.19 E.01178
G1 X171.19 Y157.06 E.18995
; CHANGE_LAYER
; Z_HEIGHT: 2.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9467.206
G1 X171.19 Y159.06 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 14/70
; update layer progress
M73 L14
M991 S0 P13 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z3 I-1.212 J.106 P1  F60000
G1 X171.584 Y163.584 Z3
G1 Z2.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X170.416 Y163.584 E.03873
G1 X170.416 Y156.416 E.23776
G1 X171.584 Y156.416 E.03873
G1 X171.584 Y163.524 E.23577
; COOLING_NODE: 0
M204 S10000
G1 X171.991 Y163.991 F60000
G1 F1200
M204 S8000
G1 X170.009 Y163.991 E.06574
G1 X170.009 Y156.009 E.26477
G1 X171.991 Y156.009 E.06574
G1 X171.991 Y163.931 E.26278
; COOLING_NODE: 0
M204 S10000
G1 X172.398 Y164.398 F60000
M73 P51 R6
G1 F1200
M204 S8000
G1 X169.602 Y164.398 E.09274
G1 X169.602 Y155.602 E.29178
G1 X172.398 Y155.602 E.09274
G1 X172.398 Y164.338 E.28979
; COOLING_NODE: 0
M204 S250
G1 X172.79 Y164.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X169.21 Y164.79 E.11
G1 X169.21 Y155.21 E.29437
G1 X172.79 Y155.21 E.11
G1 X172.79 Y164.73 E.29252
;======== H2D 20260731========
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
G1 X170.79 Y164.764 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.183 Y157.141 Z3.2 F60000
G1 X171.19 Y157 Z3.2
G1 Z2.8
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42318
G1 F1200
M204 S8000
G1 X171.19 Y156.81 E.00589
G1 X170.81 Y156.81 E.01178
G1 X170.81 Y163.19 E.1977
G1 X171.19 Y163.19 E.01178
G1 X171.19 Y157.06 E.18995
; CHANGE_LAYER
; Z_HEIGHT: 3
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9467.206
G1 X171.19 Y159.06 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 15/70
; update layer progress
M73 L15
M991 S0 P14 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z3.2 I-1.212 J.106 P1  F60000
G1 X171.584 Y163.584 Z3.2
G1 Z3
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X170.416 Y163.584 E.03873
G1 X170.416 Y156.416 E.23776
G1 X171.584 Y156.416 E.03873
G1 X171.584 Y163.524 E.23577
; COOLING_NODE: 0
M204 S10000
G1 X171.991 Y163.991 F60000
G1 F1200
M204 S8000
G1 X170.009 Y163.991 E.06574
G1 X170.009 Y156.009 E.26477
G1 X171.991 Y156.009 E.06574
G1 X171.991 Y163.931 E.26278
; COOLING_NODE: 0
M204 S10000
G1 X172.398 Y164.398 F60000
G1 F1200
M204 S8000
G1 X169.602 Y164.398 E.09274
G1 X169.602 Y155.602 E.29178
G1 X172.398 Y155.602 E.09274
G1 X172.398 Y164.338 E.28979
; COOLING_NODE: 0
M204 S250
G1 X172.79 Y164.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X169.21 Y164.79 E.11
G1 X169.21 Y155.21 E.29437
G1 X172.79 Y155.21 E.11
G1 X172.79 Y164.73 E.29252
;======== H2D 20260731========
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
M73 P52 R6
G1 X170.79 Y164.764 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.183 Y157.141 Z3.4 F60000
G1 X171.19 Y157 Z3.4
G1 Z3
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42318
G1 F1200
M204 S8000
G1 X171.19 Y156.81 E.00589
G1 X170.81 Y156.81 E.01178
G1 X170.81 Y163.19 E.1977
G1 X171.19 Y163.19 E.01178
G1 X171.19 Y157.06 E.18995
; CHANGE_LAYER
; Z_HEIGHT: 3.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9467.206
G1 X171.19 Y159.06 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 16/70
; update layer progress
M73 L16
M991 S0 P15 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z3.4 I-1.212 J.106 P1  F60000
G1 X171.584 Y163.584 Z3.4
G1 Z3.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X170.416 Y163.584 E.03873
G1 X170.416 Y156.416 E.23776
G1 X171.584 Y156.416 E.03873
G1 X171.584 Y163.524 E.23577
; COOLING_NODE: 0
M204 S10000
G1 X171.991 Y163.991 F60000
G1 F1200
M204 S8000
G1 X170.009 Y163.991 E.06574
G1 X170.009 Y156.009 E.26477
G1 X171.991 Y156.009 E.06574
G1 X171.991 Y163.931 E.26278
; COOLING_NODE: 0
M204 S10000
G1 X172.398 Y164.398 F60000
G1 F1200
M204 S8000
G1 X169.602 Y164.398 E.09274
G1 X169.602 Y155.602 E.29178
G1 X172.398 Y155.602 E.09274
G1 X172.398 Y164.338 E.28979
; COOLING_NODE: 0
M204 S250
G1 X172.79 Y164.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X169.21 Y164.79 E.11
G1 X169.21 Y155.21 E.29437
G1 X172.79 Y155.21 E.11
G1 X172.79 Y164.73 E.29252
;======== H2D 20260731========
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
G1 X170.79 Y164.764 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.183 Y157.141 Z3.6 F60000
G1 X171.19 Y157 Z3.6
G1 Z3.2
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42318
G1 F1200
M204 S8000
G1 X171.19 Y156.81 E.00589
G1 X170.81 Y156.81 E.01178
G1 X170.81 Y163.19 E.1977
G1 X171.19 Y163.19 E.01178
G1 X171.19 Y157.06 E.18995
; CHANGE_LAYER
; Z_HEIGHT: 3.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9467.206
G1 X171.19 Y159.06 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 17/70
; update layer progress
M73 L17
M991 S0 P16 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z3.6 I-1.212 J.106 P1  F60000
G1 X171.584 Y163.584 Z3.6
G1 Z3.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X170.416 Y163.584 E.03873
G1 X170.416 Y156.416 E.23776
G1 X171.584 Y156.416 E.03873
G1 X171.584 Y163.524 E.23577
; COOLING_NODE: 0
M204 S10000
G1 X171.991 Y163.991 F60000
G1 F1200
M204 S8000
G1 X170.009 Y163.991 E.06574
M73 P53 R6
G1 X170.009 Y156.009 E.26477
G1 X171.991 Y156.009 E.06574
G1 X171.991 Y163.931 E.26278
; COOLING_NODE: 0
M204 S10000
G1 X172.398 Y164.398 F60000
G1 F1200
M204 S8000
G1 X169.602 Y164.398 E.09274
G1 X169.602 Y155.602 E.29178
G1 X172.398 Y155.602 E.09274
G1 X172.398 Y164.338 E.28979
; COOLING_NODE: 0
M204 S250
G1 X172.79 Y164.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X169.21 Y164.79 E.11
G1 X169.21 Y155.21 E.29437
G1 X172.79 Y155.21 E.11
G1 X172.79 Y164.73 E.29252
;======== H2D 20260731========
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
G1 X170.79 Y164.764 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.183 Y157.141 Z3.8 F60000
G1 X171.19 Y157 Z3.8
G1 Z3.4
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42318
G1 F1200
M204 S8000
G1 X171.19 Y156.81 E.00589
G1 X170.81 Y156.81 E.01178
G1 X170.81 Y163.19 E.1977
G1 X171.19 Y163.19 E.01178
G1 X171.19 Y157.06 E.18995
; CHANGE_LAYER
; Z_HEIGHT: 3.6
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9467.206
G1 X171.19 Y159.06 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 18/70
; update layer progress
M73 L18
M991 S0 P17 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z3.8 I-1.212 J.106 P1  F60000
G1 X171.584 Y163.584 Z3.8
G1 Z3.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X170.416 Y163.584 E.03873
G1 X170.416 Y156.416 E.23776
G1 X171.584 Y156.416 E.03873
G1 X171.584 Y163.524 E.23577
; COOLING_NODE: 0
M204 S10000
G1 X171.991 Y163.991 F60000
G1 F1200
M204 S8000
G1 X170.009 Y163.991 E.06574
G1 X170.009 Y156.009 E.26477
G1 X171.991 Y156.009 E.06574
G1 X171.991 Y163.931 E.26278
; COOLING_NODE: 0
M204 S10000
G1 X172.398 Y164.398 F60000
G1 F1200
M204 S8000
G1 X169.602 Y164.398 E.09274
G1 X169.602 Y155.602 E.29178
G1 X172.398 Y155.602 E.09274
G1 X172.398 Y164.338 E.28979
; COOLING_NODE: 0
M204 S250
G1 X172.79 Y164.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X169.21 Y164.79 E.11
G1 X169.21 Y155.21 E.29437
G1 X172.79 Y155.21 E.11
G1 X172.79 Y164.73 E.29252
;======== H2D 20260731========
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
M73 P54 R6
G1 F9547.055
M204 S8000
G1 X170.79 Y164.764 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.183 Y157.141 Z4 F60000
G1 X171.19 Y157 Z4
G1 Z3.6
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42318
G1 F1200
M204 S8000
G1 X171.19 Y156.81 E.00589
G1 X170.81 Y156.81 E.01178
G1 X170.81 Y163.19 E.1977
G1 X171.19 Y163.19 E.01178
G1 X171.19 Y157.06 E.18995
; CHANGE_LAYER
; Z_HEIGHT: 3.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9467.206
G1 X171.19 Y159.06 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 19/70
; update layer progress
M73 L19
M991 S0 P18 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z4 I-1.212 J.106 P1  F60000
G1 X171.584 Y163.584 Z4
G1 Z3.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X170.416 Y163.584 E.03873
G1 X170.416 Y156.416 E.23776
G1 X171.584 Y156.416 E.03873
G1 X171.584 Y163.524 E.23577
; COOLING_NODE: 0
M204 S10000
G1 X171.991 Y163.991 F60000
G1 F1200
M204 S8000
G1 X170.009 Y163.991 E.06574
G1 X170.009 Y156.009 E.26477
G1 X171.991 Y156.009 E.06574
G1 X171.991 Y163.931 E.26278
; COOLING_NODE: 0
M204 S10000
G1 X172.398 Y164.398 F60000
G1 F1200
M204 S8000
G1 X169.602 Y164.398 E.09274
G1 X169.602 Y155.602 E.29178
G1 X172.398 Y155.602 E.09274
G1 X172.398 Y164.338 E.28979
; COOLING_NODE: 0
M204 S250
G1 X172.79 Y164.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X169.21 Y164.79 E.11
M73 P54 R5
G1 X169.21 Y155.21 E.29437
G1 X172.79 Y155.21 E.11
G1 X172.79 Y164.73 E.29252
;======== H2D 20260731========
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
G1 X170.79 Y164.764 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.183 Y157.141 Z4.2 F60000
G1 X171.19 Y157 Z4.2
G1 Z3.8
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42318
G1 F1200
M204 S8000
G1 X171.19 Y156.81 E.00589
G1 X170.81 Y156.81 E.01178
G1 X170.81 Y163.19 E.1977
G1 X171.19 Y163.19 E.01178
G1 X171.19 Y157.06 E.18995
; CHANGE_LAYER
; Z_HEIGHT: 4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9467.206
G1 X171.19 Y159.06 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 20/70
; update layer progress
M73 L20
M991 S0 P19 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z4.2 I-1.212 J.106 P1  F60000
G1 X171.584 Y163.584 Z4.2
G1 Z4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X170.416 Y163.584 E.03873
G1 X170.416 Y156.416 E.23776
G1 X171.584 Y156.416 E.03873
G1 X171.584 Y163.524 E.23577
; COOLING_NODE: 0
M204 S10000
G1 X171.991 Y163.991 F60000
M73 P55 R5
G1 F1200
M204 S8000
G1 X170.009 Y163.991 E.06574
G1 X170.009 Y156.009 E.26477
G1 X171.991 Y156.009 E.06574
G1 X171.991 Y163.931 E.26278
; COOLING_NODE: 0
M204 S10000
G1 X172.398 Y164.398 F60000
G1 F1200
M204 S8000
G1 X169.602 Y164.398 E.09274
G1 X169.602 Y155.602 E.29178
G1 X172.398 Y155.602 E.09274
G1 X172.398 Y164.338 E.28979
; COOLING_NODE: 0
M204 S250
G1 X172.79 Y164.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X169.21 Y164.79 E.11
G1 X169.21 Y155.21 E.29437
G1 X172.79 Y155.21 E.11
G1 X172.79 Y164.73 E.29252
;======== H2D 20260731========
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
G1 X170.79 Y164.764 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.183 Y157.141 Z4.4 F60000
G1 X171.19 Y157 Z4.4
G1 Z4
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42318
G1 F1200
M204 S8000
G1 X171.19 Y156.81 E.00589
G1 X170.81 Y156.81 E.01178
G1 X170.81 Y163.19 E.1977
G1 X171.19 Y163.19 E.01178
G1 X171.19 Y157.06 E.18995
; CHANGE_LAYER
; Z_HEIGHT: 4.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9467.206
G1 X171.19 Y159.06 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 21/70
; update layer progress
M73 L21
M991 S0 P20 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z4.4 I-1.212 J.106 P1  F60000
G1 X171.584 Y163.584 Z4.4
G1 Z4.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X170.416 Y163.584 E.03873
G1 X170.416 Y156.416 E.23776
G1 X171.584 Y156.416 E.03873
G1 X171.584 Y163.524 E.23577
; COOLING_NODE: 0
M204 S10000
G1 X171.991 Y163.991 F60000
G1 F1200
M204 S8000
G1 X170.009 Y163.991 E.06574
G1 X170.009 Y156.009 E.26477
G1 X171.991 Y156.009 E.06574
G1 X171.991 Y163.931 E.26278
; COOLING_NODE: 0
M204 S10000
G1 X172.398 Y164.398 F60000
G1 F1200
M204 S8000
G1 X169.602 Y164.398 E.09274
G1 X169.602 Y155.602 E.29178
G1 X172.398 Y155.602 E.09274
G1 X172.398 Y164.338 E.28979
; COOLING_NODE: 0
M204 S250
G1 X172.79 Y164.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X169.21 Y164.79 E.11
M73 P56 R5
G1 X169.21 Y155.21 E.29437
G1 X172.79 Y155.21 E.11
G1 X172.79 Y164.73 E.29252
;======== H2D 20260731========
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
G1 X170.79 Y164.764 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.183 Y157.141 Z4.6 F60000
G1 X171.19 Y157 Z4.6
G1 Z4.2
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42318
G1 F1200
M204 S8000
G1 X171.19 Y156.81 E.00589
G1 X170.81 Y156.81 E.01178
G1 X170.81 Y163.19 E.1977
G1 X171.19 Y163.19 E.01178
G1 X171.19 Y157.06 E.18995
; CHANGE_LAYER
; Z_HEIGHT: 4.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9467.206
G1 X171.19 Y159.06 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 22/70
; update layer progress
M73 L22
M991 S0 P21 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z4.6 I-1.212 J.106 P1  F60000
G1 X171.584 Y163.584 Z4.6
G1 Z4.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X170.416 Y163.584 E.03873
G1 X170.416 Y156.416 E.23776
G1 X171.584 Y156.416 E.03873
G1 X171.584 Y163.524 E.23577
; COOLING_NODE: 0
M204 S10000
G1 X171.991 Y163.991 F60000
G1 F1200
M204 S8000
G1 X170.009 Y163.991 E.06574
G1 X170.009 Y156.009 E.26477
G1 X171.991 Y156.009 E.06574
G1 X171.991 Y163.931 E.26278
; COOLING_NODE: 0
M204 S10000
G1 X172.398 Y164.398 F60000
G1 F1200
M204 S8000
G1 X169.602 Y164.398 E.09274
G1 X169.602 Y155.602 E.29178
G1 X172.398 Y155.602 E.09274
G1 X172.398 Y164.338 E.28979
; COOLING_NODE: 0
M204 S250
G1 X172.79 Y164.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X169.21 Y164.79 E.11
G1 X169.21 Y155.21 E.29437
G1 X172.79 Y155.21 E.11
G1 X172.79 Y164.73 E.29252
;======== H2D 20260731========
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
G1 X170.79 Y164.764 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.183 Y157.141 Z4.8 F60000
G1 X171.19 Y157 Z4.8
G1 Z4.4
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42318
G1 F1200
M204 S8000
G1 X171.19 Y156.81 E.00589
G1 X170.81 Y156.81 E.01178
G1 X170.81 Y163.19 E.1977
G1 X171.19 Y163.19 E.01178
G1 X171.19 Y157.06 E.18995
; CHANGE_LAYER
; Z_HEIGHT: 4.6
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9467.206
G1 X171.19 Y159.06 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 23/70
; update layer progress
M73 L23
M991 S0 P22 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z4.8 I-1.212 J.106 P1  F60000
G1 X171.584 Y163.584 Z4.8
G1 Z4.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
M73 P57 R5
G1 F1200
M204 S8000
G1 X170.416 Y163.584 E.03873
G1 X170.416 Y156.416 E.23776
G1 X171.584 Y156.416 E.03873
G1 X171.584 Y163.524 E.23577
; COOLING_NODE: 0
M204 S10000
G1 X171.991 Y163.991 F60000
G1 F1200
M204 S8000
G1 X170.009 Y163.991 E.06574
G1 X170.009 Y156.009 E.26477
G1 X171.991 Y156.009 E.06574
G1 X171.991 Y163.931 E.26278
; COOLING_NODE: 0
M204 S10000
G1 X172.398 Y164.398 F60000
G1 F1200
M204 S8000
G1 X169.602 Y164.398 E.09274
G1 X169.602 Y155.602 E.29178
G1 X172.398 Y155.602 E.09274
G1 X172.398 Y164.338 E.28979
; COOLING_NODE: 0
M204 S250
G1 X172.79 Y164.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X169.21 Y164.79 E.11
G1 X169.21 Y155.21 E.29437
G1 X172.79 Y155.21 E.11
G1 X172.79 Y164.73 E.29252
;======== H2D 20260731========
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
G1 X170.79 Y164.764 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.183 Y157.141 Z5 F60000
G1 X171.19 Y157 Z5
G1 Z4.6
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42318
G1 F1200
M204 S8000
G1 X171.19 Y156.81 E.00589
G1 X170.81 Y156.81 E.01178
G1 X170.81 Y163.19 E.1977
G1 X171.19 Y163.19 E.01178
G1 X171.19 Y157.06 E.18995
; CHANGE_LAYER
; Z_HEIGHT: 4.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9467.206
G1 X171.19 Y159.06 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 24/70
; update layer progress
M73 L24
M991 S0 P23 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z5 I-1.212 J.106 P1  F60000
G1 X171.584 Y163.584 Z5
G1 Z4.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X170.416 Y163.584 E.03873
G1 X170.416 Y156.416 E.23776
G1 X171.584 Y156.416 E.03873
G1 X171.584 Y163.524 E.23577
; COOLING_NODE: 0
M204 S10000
G1 X171.991 Y163.991 F60000
G1 F1200
M204 S8000
G1 X170.009 Y163.991 E.06574
G1 X170.009 Y156.009 E.26477
G1 X171.991 Y156.009 E.06574
G1 X171.991 Y163.931 E.26278
; COOLING_NODE: 0
M204 S10000
G1 X172.398 Y164.398 F60000
G1 F1200
M204 S8000
G1 X169.602 Y164.398 E.09274
G1 X169.602 Y155.602 E.29178
G1 X172.398 Y155.602 E.09274
G1 X172.398 Y164.338 E.28979
; COOLING_NODE: 0
M204 S250
G1 X172.79 Y164.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
M73 P58 R5
G1 F1200
M204 S5000
G1 X169.21 Y164.79 E.11
G1 X169.21 Y155.21 E.29437
G1 X172.79 Y155.21 E.11
G1 X172.79 Y164.73 E.29252
;======== H2D 20260731========
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
G1 X170.79 Y164.764 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.183 Y157.141 Z5.2 F60000
G1 X171.19 Y157 Z5.2
G1 Z4.8
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42318
G1 F1200
M204 S8000
G1 X171.19 Y156.81 E.00589
G1 X170.81 Y156.81 E.01178
G1 X170.81 Y163.19 E.1977
G1 X171.19 Y163.19 E.01178
G1 X171.19 Y157.06 E.18995
; CHANGE_LAYER
; Z_HEIGHT: 5
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9467.206
G1 X171.19 Y159.06 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 25/70
; update layer progress
M73 L25
M991 S0 P24 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z5.2 I-1.212 J.106 P1  F60000
G1 X171.584 Y163.584 Z5.2
G1 Z5
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X170.416 Y163.584 E.03873
G1 X170.416 Y156.416 E.23776
G1 X171.584 Y156.416 E.03873
G1 X171.584 Y163.524 E.23577
; COOLING_NODE: 0
M204 S10000
G1 X171.991 Y163.991 F60000
G1 F1200
M204 S8000
G1 X170.009 Y163.991 E.06574
G1 X170.009 Y156.009 E.26477
G1 X171.991 Y156.009 E.06574
G1 X171.991 Y163.931 E.26278
; COOLING_NODE: 0
M204 S10000
G1 X172.398 Y164.398 F60000
G1 F1200
M204 S8000
G1 X169.602 Y164.398 E.09274
G1 X169.602 Y155.602 E.29178
G1 X172.398 Y155.602 E.09274
G1 X172.398 Y164.338 E.28979
; COOLING_NODE: 0
M204 S250
G1 X172.79 Y164.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X169.21 Y164.79 E.11
G1 X169.21 Y155.21 E.29437
G1 X172.79 Y155.21 E.11
G1 X172.79 Y164.73 E.29252
;======== H2D 20260731========
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
G1 X170.79 Y164.764 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.183 Y157.141 Z5.4 F60000
G1 X171.19 Y157 Z5.4
G1 Z5
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42318
G1 F1200
M204 S8000
G1 X171.19 Y156.81 E.00589
G1 X170.81 Y156.81 E.01178
G1 X170.81 Y163.19 E.1977
G1 X171.19 Y163.19 E.01178
G1 X171.19 Y157.06 E.18995
; CHANGE_LAYER
; Z_HEIGHT: 5.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9467.206
G1 X171.19 Y159.06 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 26/70
; update layer progress
M73 L26
M991 S0 P25 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
M73 P59 R5
G3 Z5.4 I-1.212 J.106 P1  F60000
G1 X171.584 Y163.584 Z5.4
G1 Z5.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X170.416 Y163.584 E.03873
G1 X170.416 Y156.416 E.23776
G1 X171.584 Y156.416 E.03873
G1 X171.584 Y163.524 E.23577
; COOLING_NODE: 0
M204 S10000
G1 X171.991 Y163.991 F60000
G1 F1200
M204 S8000
G1 X170.009 Y163.991 E.06574
G1 X170.009 Y156.009 E.26477
G1 X171.991 Y156.009 E.06574
G1 X171.991 Y163.931 E.26278
; COOLING_NODE: 0
M204 S10000
G1 X172.398 Y164.398 F60000
G1 F1200
M204 S8000
G1 X169.602 Y164.398 E.09274
G1 X169.602 Y155.602 E.29178
G1 X172.398 Y155.602 E.09274
G1 X172.398 Y164.338 E.28979
; COOLING_NODE: 0
M204 S250
G1 X172.79 Y164.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X169.21 Y164.79 E.11
G1 X169.21 Y155.21 E.29437
G1 X172.79 Y155.21 E.11
G1 X172.79 Y164.73 E.29252
;======== H2D 20260731========
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
G1 X170.79 Y164.764 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.183 Y157.141 Z5.6 F60000
G1 X171.19 Y157 Z5.6
G1 Z5.2
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42318
G1 F1200
M204 S8000
G1 X171.19 Y156.81 E.00589
G1 X170.81 Y156.81 E.01178
G1 X170.81 Y163.19 E.1977
G1 X171.19 Y163.19 E.01178
G1 X171.19 Y157.06 E.18995
; CHANGE_LAYER
; Z_HEIGHT: 5.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9467.206
G1 X171.19 Y159.06 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 27/70
; update layer progress
M73 L27
M991 S0 P26 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z5.6 I-1.212 J.106 P1  F60000
G1 X171.584 Y163.584 Z5.6
G1 Z5.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X170.416 Y163.584 E.03873
G1 X170.416 Y156.416 E.23776
G1 X171.584 Y156.416 E.03873
G1 X171.584 Y163.524 E.23577
; COOLING_NODE: 0
M204 S10000
G1 X171.991 Y163.991 F60000
G1 F1200
M204 S8000
G1 X170.009 Y163.991 E.06574
G1 X170.009 Y156.009 E.26477
G1 X171.991 Y156.009 E.06574
G1 X171.991 Y163.931 E.26278
; COOLING_NODE: 0
M204 S10000
G1 X172.398 Y164.398 F60000
G1 F1200
M204 S8000
G1 X169.602 Y164.398 E.09274
G1 X169.602 Y155.602 E.29178
G1 X172.398 Y155.602 E.09274
G1 X172.398 Y164.338 E.28979
; COOLING_NODE: 0
M204 S250
G1 X172.79 Y164.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
M73 P60 R5
G1 F1200
M204 S5000
G1 X169.21 Y164.79 E.11
G1 X169.21 Y155.21 E.29437
G1 X172.79 Y155.21 E.11
G1 X172.79 Y164.73 E.29252
;======== H2D 20260731========
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
G1 X170.79 Y164.764 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.183 Y157.141 Z5.8 F60000
G1 X171.19 Y157 Z5.8
G1 Z5.4
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42318
G1 F1200
M204 S8000
G1 X171.19 Y156.81 E.00589
G1 X170.81 Y156.81 E.01178
G1 X170.81 Y163.19 E.1977
G1 X171.19 Y163.19 E.01178
G1 X171.19 Y157.06 E.18995
; CHANGE_LAYER
; Z_HEIGHT: 5.6
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9467.206
G1 X171.19 Y159.06 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 28/70
; update layer progress
M73 L28
M991 S0 P27 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z5.8 I-1.212 J.106 P1  F60000
G1 X171.584 Y163.584 Z5.8
G1 Z5.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X170.416 Y163.584 E.03873
G1 X170.416 Y156.416 E.23776
G1 X171.584 Y156.416 E.03873
G1 X171.584 Y163.524 E.23577
; COOLING_NODE: 0
M204 S10000
G1 X171.991 Y163.991 F60000
G1 F1200
M204 S8000
G1 X170.009 Y163.991 E.06574
G1 X170.009 Y156.009 E.26477
G1 X171.991 Y156.009 E.06574
G1 X171.991 Y163.931 E.26278
; COOLING_NODE: 0
M204 S10000
G1 X172.398 Y164.398 F60000
G1 F1200
M204 S8000
G1 X169.602 Y164.398 E.09274
G1 X169.602 Y155.602 E.29178
G1 X172.398 Y155.602 E.09274
G1 X172.398 Y164.338 E.28979
; COOLING_NODE: 0
M204 S250
G1 X172.79 Y164.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X169.21 Y164.79 E.11
G1 X169.21 Y155.21 E.29437
G1 X172.79 Y155.21 E.11
G1 X172.79 Y164.73 E.29252
;======== H2D 20260731========
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
G1 X170.79 Y164.764 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.183 Y157.141 Z6 F60000
G1 X171.19 Y157 Z6
G1 Z5.6
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42318
G1 F1200
M204 S8000
G1 X171.19 Y156.81 E.00589
M73 P61 R5
G1 X170.81 Y156.81 E.01178
G1 X170.81 Y163.19 E.1977
G1 X171.19 Y163.19 E.01178
G1 X171.19 Y157.06 E.18995
; CHANGE_LAYER
; Z_HEIGHT: 5.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9467.206
G1 X171.19 Y159.06 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 29/70
; update layer progress
M73 L29
M991 S0 P28 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z6 I-1.212 J.106 P1  F60000
G1 X171.584 Y163.584 Z6
G1 Z5.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X170.416 Y163.584 E.03873
G1 X170.416 Y156.416 E.23776
G1 X171.584 Y156.416 E.03873
G1 X171.584 Y163.524 E.23577
; COOLING_NODE: 0
M204 S10000
G1 X171.991 Y163.991 F60000
G1 F1200
M204 S8000
G1 X170.009 Y163.991 E.06574
G1 X170.009 Y156.009 E.26477
G1 X171.991 Y156.009 E.06574
G1 X171.991 Y163.931 E.26278
; COOLING_NODE: 0
M204 S10000
G1 X172.398 Y164.398 F60000
G1 F1200
M204 S8000
G1 X169.602 Y164.398 E.09274
G1 X169.602 Y155.602 E.29178
G1 X172.398 Y155.602 E.09274
G1 X172.398 Y164.338 E.28979
; COOLING_NODE: 0
M204 S250
G1 X172.79 Y164.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X169.21 Y164.79 E.11
G1 X169.21 Y155.21 E.29437
G1 X172.79 Y155.21 E.11
G1 X172.79 Y164.73 E.29252
;======== H2D 20260731========
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
G1 X170.79 Y164.764 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.183 Y157.141 Z6.2 F60000
G1 X171.19 Y157 Z6.2
G1 Z5.8
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42318
G1 F1200
M204 S8000
G1 X171.19 Y156.81 E.00589
G1 X170.81 Y156.81 E.01178
G1 X170.81 Y163.19 E.1977
G1 X171.19 Y163.19 E.01178
G1 X171.19 Y157.06 E.18995
; CHANGE_LAYER
; Z_HEIGHT: 6
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9467.206
G1 X171.19 Y159.06 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 30/70
; update layer progress
M73 L30
M991 S0 P29 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z6.2 I-1.212 J.106 P1  F60000
G1 X171.584 Y163.584 Z6.2
G1 Z6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X170.416 Y163.584 E.03873
G1 X170.416 Y156.416 E.23776
G1 X171.584 Y156.416 E.03873
G1 X171.584 Y163.524 E.23577
; COOLING_NODE: 0
M204 S10000
G1 X171.991 Y163.991 F60000
G1 F1200
M204 S8000
G1 X170.009 Y163.991 E.06574
G1 X170.009 Y156.009 E.26477
G1 X171.991 Y156.009 E.06574
G1 X171.991 Y163.931 E.26278
; COOLING_NODE: 0
M204 S10000
G1 X172.398 Y164.398 F60000
G1 F1200
M204 S8000
G1 X169.602 Y164.398 E.09274
M73 P62 R5
G1 X169.602 Y155.602 E.29178
G1 X172.398 Y155.602 E.09274
G1 X172.398 Y164.338 E.28979
; COOLING_NODE: 0
M204 S250
G1 X172.79 Y164.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X169.21 Y164.79 E.11
G1 X169.21 Y155.21 E.29437
G1 X172.79 Y155.21 E.11
G1 X172.79 Y164.73 E.29252
;======== H2D 20260731========
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
M73 P62 R4
G1 F9547.055
M204 S8000
G1 X170.79 Y164.764 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.183 Y157.141 Z6.4 F60000
G1 X171.19 Y157 Z6.4
G1 Z6
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42318
G1 F1200
M204 S8000
G1 X171.19 Y156.81 E.00589
G1 X170.81 Y156.81 E.01178
G1 X170.81 Y163.19 E.1977
G1 X171.19 Y163.19 E.01178
G1 X171.19 Y157.06 E.18995
; CHANGE_LAYER
; Z_HEIGHT: 6.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9467.206
G1 X171.19 Y159.06 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 31/70
; update layer progress
M73 L31
M991 S0 P30 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z6.4 I-1.212 J.106 P1  F60000
G1 X171.584 Y163.584 Z6.4
G1 Z6.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X170.416 Y163.584 E.03873
G1 X170.416 Y156.416 E.23776
G1 X171.584 Y156.416 E.03873
G1 X171.584 Y163.524 E.23577
; COOLING_NODE: 0
M204 S10000
G1 X171.991 Y163.991 F60000
G1 F1200
M204 S8000
G1 X170.009 Y163.991 E.06574
G1 X170.009 Y156.009 E.26477
G1 X171.991 Y156.009 E.06574
G1 X171.991 Y163.931 E.26278
; COOLING_NODE: 0
M204 S10000
G1 X172.398 Y164.398 F60000
G1 F1200
M204 S8000
G1 X169.602 Y164.398 E.09274
G1 X169.602 Y155.602 E.29178
G1 X172.398 Y155.602 E.09274
G1 X172.398 Y164.338 E.28979
; COOLING_NODE: 0
M204 S250
G1 X172.79 Y164.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X169.21 Y164.79 E.11
G1 X169.21 Y155.21 E.29437
G1 X172.79 Y155.21 E.11
G1 X172.79 Y164.73 E.29252
;======== H2D 20260731========
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
G1 X170.79 Y164.764 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
M73 P63 R4
G1 X171.183 Y157.141 Z6.6 F60000
G1 X171.19 Y157 Z6.6
G1 Z6.2
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42318
G1 F1200
M204 S8000
G1 X171.19 Y156.81 E.00589
G1 X170.81 Y156.81 E.01178
G1 X170.81 Y163.19 E.1977
G1 X171.19 Y163.19 E.01178
G1 X171.19 Y157.06 E.18995
; CHANGE_LAYER
; Z_HEIGHT: 6.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9467.206
G1 X171.19 Y159.06 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 32/70
; update layer progress
M73 L32
M991 S0 P31 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z6.6 I-1.212 J.106 P1  F60000
G1 X171.584 Y163.584 Z6.6
G1 Z6.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X170.416 Y163.584 E.03873
G1 X170.416 Y156.416 E.23776
G1 X171.584 Y156.416 E.03873
G1 X171.584 Y163.524 E.23577
; COOLING_NODE: 0
M204 S10000
G1 X171.991 Y163.991 F60000
G1 F1200
M204 S8000
G1 X170.009 Y163.991 E.06574
G1 X170.009 Y156.009 E.26477
G1 X171.991 Y156.009 E.06574
G1 X171.991 Y163.931 E.26278
; COOLING_NODE: 0
M204 S10000
G1 X172.398 Y164.398 F60000
G1 F1200
M204 S8000
G1 X169.602 Y164.398 E.09274
G1 X169.602 Y155.602 E.29178
G1 X172.398 Y155.602 E.09274
G1 X172.398 Y164.338 E.28979
; COOLING_NODE: 0
M204 S250
G1 X172.79 Y164.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X169.21 Y164.79 E.11
G1 X169.21 Y155.21 E.29437
G1 X172.79 Y155.21 E.11
G1 X172.79 Y164.73 E.29252
;======== H2D 20260731========
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
G1 X170.79 Y164.764 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.183 Y157.141 Z6.8 F60000
G1 X171.19 Y157 Z6.8
G1 Z6.4
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42318
G1 F1200
M204 S8000
G1 X171.19 Y156.81 E.00589
G1 X170.81 Y156.81 E.01178
G1 X170.81 Y163.19 E.1977
G1 X171.19 Y163.19 E.01178
G1 X171.19 Y157.06 E.18995
; CHANGE_LAYER
; Z_HEIGHT: 6.6
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9467.206
G1 X171.19 Y159.06 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 33/70
; update layer progress
M73 L33
M991 S0 P32 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z6.8 I-1.212 J.106 P1  F60000
G1 X171.584 Y163.584 Z6.8
G1 Z6.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X170.416 Y163.584 E.03873
G1 X170.416 Y156.416 E.23776
G1 X171.584 Y156.416 E.03873
G1 X171.584 Y163.524 E.23577
; COOLING_NODE: 0
M204 S10000
G1 X171.991 Y163.991 F60000
G1 F1200
M204 S8000
G1 X170.009 Y163.991 E.06574
G1 X170.009 Y156.009 E.26477
G1 X171.991 Y156.009 E.06574
G1 X171.991 Y163.931 E.26278
; COOLING_NODE: 0
M204 S10000
G1 X172.398 Y164.398 F60000
M73 P64 R4
G1 F1200
M204 S8000
G1 X169.602 Y164.398 E.09274
G1 X169.602 Y155.602 E.29178
G1 X172.398 Y155.602 E.09274
G1 X172.398 Y164.338 E.28979
; COOLING_NODE: 0
M204 S250
G1 X172.79 Y164.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X169.21 Y164.79 E.11
G1 X169.21 Y155.21 E.29437
G1 X172.79 Y155.21 E.11
G1 X172.79 Y164.73 E.29252
;======== H2D 20260731========
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
G1 X170.79 Y164.764 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.183 Y157.141 Z7 F60000
G1 X171.19 Y157 Z7
G1 Z6.6
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42318
G1 F1200
M204 S8000
G1 X171.19 Y156.81 E.00589
G1 X170.81 Y156.81 E.01178
G1 X170.81 Y163.19 E.1977
G1 X171.19 Y163.19 E.01178
G1 X171.19 Y157.06 E.18995
; CHANGE_LAYER
; Z_HEIGHT: 6.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9467.206
G1 X171.19 Y159.06 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 34/70
; update layer progress
M73 L34
M991 S0 P33 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z7 I-1.212 J.106 P1  F60000
G1 X171.584 Y163.584 Z7
G1 Z6.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X170.416 Y163.584 E.03873
G1 X170.416 Y156.416 E.23776
G1 X171.584 Y156.416 E.03873
G1 X171.584 Y163.524 E.23577
; COOLING_NODE: 0
M204 S10000
G1 X171.991 Y163.991 F60000
G1 F1200
M204 S8000
G1 X170.009 Y163.991 E.06574
G1 X170.009 Y156.009 E.26477
G1 X171.991 Y156.009 E.06574
G1 X171.991 Y163.931 E.26278
; COOLING_NODE: 0
M204 S10000
G1 X172.398 Y164.398 F60000
G1 F1200
M204 S8000
G1 X169.602 Y164.398 E.09274
G1 X169.602 Y155.602 E.29178
G1 X172.398 Y155.602 E.09274
G1 X172.398 Y164.338 E.28979
; COOLING_NODE: 0
M204 S250
G1 X172.79 Y164.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X169.21 Y164.79 E.11
G1 X169.21 Y155.21 E.29437
G1 X172.79 Y155.21 E.11
G1 X172.79 Y164.73 E.29252
;======== H2D 20260731========
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
M73 P65 R4
G1 X170.79 Y164.764 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.183 Y157.141 Z7.2 F60000
G1 X171.19 Y157 Z7.2
G1 Z6.8
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42318
G1 F1200
M204 S8000
G1 X171.19 Y156.81 E.00589
G1 X170.81 Y156.81 E.01178
G1 X170.81 Y163.19 E.1977
G1 X171.19 Y163.19 E.01178
G1 X171.19 Y157.06 E.18995
; CHANGE_LAYER
; Z_HEIGHT: 7
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9467.206
G1 X171.19 Y159.06 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 35/70
; update layer progress
M73 L35
M991 S0 P34 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z7.2 I-1.212 J.106 P1  F60000
G1 X171.584 Y163.584 Z7.2
G1 Z7
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X170.416 Y163.584 E.03873
G1 X170.416 Y156.416 E.23776
G1 X171.584 Y156.416 E.03873
G1 X171.584 Y163.524 E.23577
; COOLING_NODE: 0
M204 S10000
G1 X171.991 Y163.991 F60000
G1 F1200
M204 S8000
G1 X170.009 Y163.991 E.06574
G1 X170.009 Y156.009 E.26477
G1 X171.991 Y156.009 E.06574
G1 X171.991 Y163.931 E.26278
; COOLING_NODE: 0
M204 S10000
G1 X172.398 Y164.398 F60000
G1 F1200
M204 S8000
G1 X169.602 Y164.398 E.09274
G1 X169.602 Y155.602 E.29178
G1 X172.398 Y155.602 E.09274
G1 X172.398 Y164.338 E.28979
; COOLING_NODE: 0
M204 S250
G1 X172.79 Y164.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X169.21 Y164.79 E.11
G1 X169.21 Y155.21 E.29437
G1 X172.79 Y155.21 E.11
G1 X172.79 Y164.73 E.29252
;======== H2D 20260731========
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
G1 X170.79 Y164.764 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.183 Y157.141 Z7.4 F60000
G1 X171.19 Y157 Z7.4
G1 Z7
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42318
G1 F1200
M204 S8000
G1 X171.19 Y156.81 E.00589
G1 X170.81 Y156.81 E.01178
G1 X170.81 Y163.19 E.1977
G1 X171.19 Y163.19 E.01178
G1 X171.19 Y157.06 E.18995
; CHANGE_LAYER
; Z_HEIGHT: 7.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9467.206
G1 X171.19 Y159.06 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 36/70
; update layer progress
M73 L36
M991 S0 P35 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z7.4 I-1.212 J.106 P1  F60000
G1 X171.584 Y163.584 Z7.4
G1 Z7.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X170.416 Y163.584 E.03873
G1 X170.416 Y156.416 E.23776
G1 X171.584 Y156.416 E.03873
G1 X171.584 Y163.524 E.23577
; COOLING_NODE: 0
M204 S10000
G1 X171.991 Y163.991 F60000
G1 F1200
M204 S8000
G1 X170.009 Y163.991 E.06574
M73 P66 R4
G1 X170.009 Y156.009 E.26477
G1 X171.991 Y156.009 E.06574
G1 X171.991 Y163.931 E.26278
; COOLING_NODE: 0
M204 S10000
G1 X172.398 Y164.398 F60000
G1 F1200
M204 S8000
G1 X169.602 Y164.398 E.09274
G1 X169.602 Y155.602 E.29178
G1 X172.398 Y155.602 E.09274
G1 X172.398 Y164.338 E.28979
; COOLING_NODE: 0
M204 S250
G1 X172.79 Y164.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X169.21 Y164.79 E.11
G1 X169.21 Y155.21 E.29437
G1 X172.79 Y155.21 E.11
G1 X172.79 Y164.73 E.29252
;======== H2D 20260731========
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
G1 X170.79 Y164.764 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.183 Y157.141 Z7.6 F60000
G1 X171.19 Y157 Z7.6
G1 Z7.2
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42318
G1 F1200
M204 S8000
G1 X171.19 Y156.81 E.00589
G1 X170.81 Y156.81 E.01178
G1 X170.81 Y163.19 E.1977
G1 X171.19 Y163.19 E.01178
G1 X171.19 Y157.06 E.18995
; CHANGE_LAYER
; Z_HEIGHT: 7.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9467.206
G1 X171.19 Y159.06 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 37/70
; update layer progress
M73 L37
M991 S0 P36 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z7.6 I-1.212 J.106 P1  F60000
G1 X171.584 Y163.584 Z7.6
G1 Z7.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X170.416 Y163.584 E.03873
G1 X170.416 Y156.416 E.23776
G1 X171.584 Y156.416 E.03873
G1 X171.584 Y163.524 E.23577
; COOLING_NODE: 0
M204 S10000
G1 X171.991 Y163.991 F60000
G1 F1200
M204 S8000
G1 X170.009 Y163.991 E.06574
G1 X170.009 Y156.009 E.26477
G1 X171.991 Y156.009 E.06574
G1 X171.991 Y163.931 E.26278
; COOLING_NODE: 0
M204 S10000
G1 X172.398 Y164.398 F60000
G1 F1200
M204 S8000
G1 X169.602 Y164.398 E.09274
G1 X169.602 Y155.602 E.29178
G1 X172.398 Y155.602 E.09274
G1 X172.398 Y164.338 E.28979
; COOLING_NODE: 0
M204 S250
G1 X172.79 Y164.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X169.21 Y164.79 E.11
G1 X169.21 Y155.21 E.29437
G1 X172.79 Y155.21 E.11
G1 X172.79 Y164.73 E.29252
;======== H2D 20260731========
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
G1 X170.79 Y164.764 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.183 Y157.141 Z7.8 F60000
G1 X171.19 Y157 Z7.8
G1 Z7.4
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42318
G1 F1200
M204 S8000
G1 X171.19 Y156.81 E.00589
G1 X170.81 Y156.81 E.01178
G1 X170.81 Y163.19 E.1977
G1 X171.19 Y163.19 E.01178
G1 X171.19 Y157.06 E.18995
; CHANGE_LAYER
; Z_HEIGHT: 7.6
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9467.206
G1 X171.19 Y159.06 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 38/70
; update layer progress
M73 L38
M991 S0 P37 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z7.8 I-1.212 J.106 P1  F60000
G1 X171.584 Y163.584 Z7.8
G1 Z7.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X170.416 Y163.584 E.03873
G1 X170.416 Y156.416 E.23776
G1 X171.584 Y156.416 E.03873
G1 X171.584 Y163.524 E.23577
; COOLING_NODE: 0
M204 S10000
G1 X171.991 Y163.991 F60000
G1 F1200
M204 S8000
G1 X170.009 Y163.991 E.06574
G1 X170.009 Y156.009 E.26477
G1 X171.991 Y156.009 E.06574
G1 X171.991 Y163.931 E.26278
; COOLING_NODE: 0
M204 S10000
G1 X172.398 Y164.398 F60000
G1 F1200
M204 S8000
G1 X169.602 Y164.398 E.09274
G1 X169.602 Y155.602 E.29178
G1 X172.398 Y155.602 E.09274
G1 X172.398 Y164.338 E.28979
; COOLING_NODE: 0
M204 S250
G1 X172.79 Y164.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X169.21 Y164.79 E.11
G1 X169.21 Y155.21 E.29437
G1 X172.79 Y155.21 E.11
G1 X172.79 Y164.73 E.29252
;======== H2D 20260731========
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
G1 X170.79 Y164.764 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.183 Y157.141 Z8 F60000
G1 X171.19 Y157 Z8
G1 Z7.6
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42318
G1 F1200
M204 S8000
G1 X171.19 Y156.81 E.00589
G1 X170.81 Y156.81 E.01178
G1 X170.81 Y163.19 E.1977
G1 X171.19 Y163.19 E.01178
G1 X171.19 Y157.06 E.18995
; CHANGE_LAYER
; Z_HEIGHT: 7.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9467.206
G1 X171.19 Y159.06 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 39/70
; update layer progress
M73 L39
M991 S0 P38 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z8 I-1.212 J.106 P1  F60000
G1 X171.584 Y163.584 Z8
G1 Z7.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X170.416 Y163.584 E.03873
G1 X170.416 Y156.416 E.23776
G1 X171.584 Y156.416 E.03873
G1 X171.584 Y163.524 E.23577
; COOLING_NODE: 0
M204 S10000
G1 X171.991 Y163.991 F60000
M73 P68 R4
G1 F1200
M204 S8000
G1 X170.009 Y163.991 E.06574
G1 X170.009 Y156.009 E.26477
G1 X171.991 Y156.009 E.06574
G1 X171.991 Y163.931 E.26278
; COOLING_NODE: 0
M204 S10000
G1 X172.398 Y164.398 F60000
G1 F1200
M204 S8000
G1 X169.602 Y164.398 E.09274
G1 X169.602 Y155.602 E.29178
G1 X172.398 Y155.602 E.09274
G1 X172.398 Y164.338 E.28979
; COOLING_NODE: 0
M204 S250
G1 X172.79 Y164.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X169.21 Y164.79 E.11
G1 X169.21 Y155.21 E.29437
G1 X172.79 Y155.21 E.11
G1 X172.79 Y164.73 E.29252
;======== H2D 20260731========
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
G1 X170.79 Y164.764 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.183 Y157.141 Z8.2 F60000
G1 X171.19 Y157 Z8.2
G1 Z7.8
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42318
G1 F1200
M204 S8000
G1 X171.19 Y156.81 E.00589
G1 X170.81 Y156.81 E.01178
G1 X170.81 Y163.19 E.1977
G1 X171.19 Y163.19 E.01178
G1 X171.19 Y157.06 E.18995
; CHANGE_LAYER
; Z_HEIGHT: 8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9467.206
G1 X171.19 Y159.06 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 40/70
; update layer progress
M73 L40
M991 S0 P39 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z8.2 I-1.212 J.106 P1  F60000
G1 X171.584 Y163.584 Z8.2
G1 Z8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X170.416 Y163.584 E.03873
G1 X170.416 Y156.416 E.23776
G1 X171.584 Y156.416 E.03873
G1 X171.584 Y163.524 E.23577
; COOLING_NODE: 0
M204 S10000
G1 X171.991 Y163.991 F60000
G1 F1200
M204 S8000
G1 X170.009 Y163.991 E.06574
G1 X170.009 Y156.009 E.26477
G1 X171.991 Y156.009 E.06574
G1 X171.991 Y163.931 E.26278
; COOLING_NODE: 0
M204 S10000
G1 X172.398 Y164.398 F60000
G1 F1200
M204 S8000
G1 X169.602 Y164.398 E.09274
G1 X169.602 Y155.602 E.29178
G1 X172.398 Y155.602 E.09274
G1 X172.398 Y164.338 E.28979
; COOLING_NODE: 0
M204 S250
G1 X172.79 Y164.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X169.21 Y164.79 E.11
M73 P69 R4
G1 X169.21 Y155.21 E.29437
G1 X172.79 Y155.21 E.11
G1 X172.79 Y164.73 E.29252
;======== H2D 20260731========
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
G1 X170.79 Y164.764 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.183 Y157.141 Z8.4 F60000
G1 X171.19 Y157 Z8.4
G1 Z8
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42318
G1 F1200
M204 S8000
G1 X171.19 Y156.81 E.00589
G1 X170.81 Y156.81 E.01178
G1 X170.81 Y163.19 E.1977
G1 X171.19 Y163.19 E.01178
G1 X171.19 Y157.06 E.18995
; CHANGE_LAYER
; Z_HEIGHT: 8.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9467.206
G1 X171.19 Y159.06 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 41/70
; update layer progress
M73 L41
M991 S0 P40 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z8.4 I-1.212 J.106 P1  F60000
G1 X171.584 Y163.584 Z8.4
G1 Z8.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X170.416 Y163.584 E.03873
G1 X170.416 Y156.416 E.23776
G1 X171.584 Y156.416 E.03873
G1 X171.584 Y163.524 E.23577
; COOLING_NODE: 0
M204 S10000
G1 X171.991 Y163.991 F60000
G1 F1200
M204 S8000
G1 X170.009 Y163.991 E.06574
G1 X170.009 Y156.009 E.26477
G1 X171.991 Y156.009 E.06574
G1 X171.991 Y163.931 E.26278
; COOLING_NODE: 0
M204 S10000
G1 X172.398 Y164.398 F60000
G1 F1200
M204 S8000
G1 X169.602 Y164.398 E.09274
G1 X169.602 Y155.602 E.29178
G1 X172.398 Y155.602 E.09274
G1 X172.398 Y164.338 E.28979
; COOLING_NODE: 0
M204 S250
G1 X172.79 Y164.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X169.21 Y164.79 E.11
G1 X169.21 Y155.21 E.29437
G1 X172.79 Y155.21 E.11
G1 X172.79 Y164.73 E.29252
;======== H2D 20260731========
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
M73 P69 R3
G1 X170.79 Y164.764 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.183 Y157.141 Z8.6 F60000
G1 X171.19 Y157 Z8.6
G1 Z8.2
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42318
G1 F1200
M204 S8000
G1 X171.19 Y156.81 E.00589
G1 X170.81 Y156.81 E.01178
G1 X170.81 Y163.19 E.1977
G1 X171.19 Y163.19 E.01178
G1 X171.19 Y157.06 E.18995
; CHANGE_LAYER
; Z_HEIGHT: 8.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9467.206
G1 X171.19 Y159.06 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 42/70
; update layer progress
M73 L42
M991 S0 P41 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z8.6 I-1.212 J.106 P1  F60000
G1 X171.584 Y163.584 Z8.6
G1 Z8.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X170.416 Y163.584 E.03873
M73 P70 R3
G1 X170.416 Y156.416 E.23776
G1 X171.584 Y156.416 E.03873
G1 X171.584 Y163.524 E.23577
; COOLING_NODE: 0
M204 S10000
G1 X171.991 Y163.991 F60000
G1 F1200
M204 S8000
G1 X170.009 Y163.991 E.06574
G1 X170.009 Y156.009 E.26477
G1 X171.991 Y156.009 E.06574
G1 X171.991 Y163.931 E.26278
; COOLING_NODE: 0
M204 S10000
G1 X172.398 Y164.398 F60000
G1 F1200
M204 S8000
G1 X169.602 Y164.398 E.09274
G1 X169.602 Y155.602 E.29178
G1 X172.398 Y155.602 E.09274
G1 X172.398 Y164.338 E.28979
; COOLING_NODE: 0
M204 S250
G1 X172.79 Y164.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X169.21 Y164.79 E.11
G1 X169.21 Y155.21 E.29437
G1 X172.79 Y155.21 E.11
G1 X172.79 Y164.73 E.29252
;======== H2D 20260731========
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
G1 X170.79 Y164.764 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.183 Y157.141 Z8.8 F60000
G1 X171.19 Y157 Z8.8
G1 Z8.4
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42318
G1 F1200
M204 S8000
G1 X171.19 Y156.81 E.00589
G1 X170.81 Y156.81 E.01178
G1 X170.81 Y163.19 E.1977
G1 X171.19 Y163.19 E.01178
G1 X171.19 Y157.06 E.18995
; CHANGE_LAYER
; Z_HEIGHT: 8.6
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F9467.206
G1 X171.19 Y159.06 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 43/70
; update layer progress
M73 L43
M991 S0 P42 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z8.8 I-1.212 J.106 P1  F60000
G1 X171.584 Y163.584 Z8.8
G1 Z8.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X170.416 Y163.584 E.03873
G1 X170.416 Y156.416 E.23776
G1 X171.584 Y156.416 E.03873
G1 X171.584 Y163.524 E.23577
; COOLING_NODE: 0
M204 S10000
G1 X171.991 Y163.991 F60000
G1 F1200
M204 S8000
G1 X170.009 Y163.991 E.06574
G1 X170.009 Y156.009 E.26477
G1 X171.991 Y156.009 E.06574
G1 X171.991 Y163.931 E.26278
; COOLING_NODE: 0
M204 S10000
G1 X172.398 Y164.398 F60000
G1 F1200
M204 S8000
G1 X169.602 Y164.398 E.09274
G1 X169.602 Y155.602 E.29178
G1 X172.398 Y155.602 E.09274
G1 X172.398 Y164.338 E.28979
; COOLING_NODE: 0
M204 S250
G1 X172.79 Y164.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
M73 P71 R3
G1 X169.21 Y164.79 E.11
G1 X169.21 Y155.21 E.29437
G1 X172.79 Y155.21 E.11
G1 X172.79 Y164.73 E.29252
;======== H2D 20260731========
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
G1 X170.79 Y164.764 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.183 Y157.141 Z9 F60000
G1 X171.19 Y157 Z9
G1 Z8.6
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42318
G1 F1200
M204 S8000
G1 X171.19 Y156.81 E.00589
G1 X170.81 Y156.81 E.01178
G1 X170.81 Y163.19 E.1977
G1 X171.19 Y163.19 E.01178
G1 X171.19 Y157.06 E.18995
; CHANGE_LAYER
; Z_HEIGHT: 8.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9467.206
G1 X171.19 Y159.06 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 44/70
; update layer progress
M73 L44
M991 S0 P43 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z9 I-1.212 J.106 P1  F60000
G1 X171.584 Y163.584 Z9
G1 Z8.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X170.416 Y163.584 E.03873
G1 X170.416 Y156.416 E.23776
G1 X171.584 Y156.416 E.03873
G1 X171.584 Y163.524 E.23577
; COOLING_NODE: 0
M204 S10000
G1 X171.991 Y163.991 F60000
G1 F1200
M204 S8000
G1 X170.009 Y163.991 E.06574
G1 X170.009 Y156.009 E.26477
G1 X171.991 Y156.009 E.06574
G1 X171.991 Y163.931 E.26278
; COOLING_NODE: 0
M204 S10000
G1 X172.398 Y164.398 F60000
G1 F1200
M204 S8000
G1 X169.602 Y164.398 E.09274
G1 X169.602 Y155.602 E.29178
G1 X172.398 Y155.602 E.09274
G1 X172.398 Y164.338 E.28979
; COOLING_NODE: 0
M204 S250
G1 X172.79 Y164.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X169.21 Y164.79 E.11
G1 X169.21 Y155.21 E.29437
G1 X172.79 Y155.21 E.11
G1 X172.79 Y164.73 E.29252
;======== H2D 20260731========
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
G1 X170.79 Y164.764 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.183 Y157.141 Z9.2 F60000
G1 X171.19 Y157 Z9.2
G1 Z8.8
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42318
G1 F1200
M204 S8000
G1 X171.19 Y156.81 E.00589
G1 X170.81 Y156.81 E.01178
G1 X170.81 Y163.19 E.1977
G1 X171.19 Y163.19 E.01178
G1 X171.19 Y157.06 E.18995
; CHANGE_LAYER
; Z_HEIGHT: 9
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9467.206
G1 X171.19 Y159.06 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 45/70
; update layer progress
M73 L45
M991 S0 P44 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
M73 P72 R3
G3 Z9.2 I-1.212 J.106 P1  F60000
G1 X171.584 Y163.584 Z9.2
G1 Z9
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X170.416 Y163.584 E.03873
G1 X170.416 Y156.416 E.23776
G1 X171.584 Y156.416 E.03873
G1 X171.584 Y163.524 E.23577
; COOLING_NODE: 0
M204 S10000
G1 X171.991 Y163.991 F60000
G1 F1200
M204 S8000
G1 X170.009 Y163.991 E.06574
G1 X170.009 Y156.009 E.26477
G1 X171.991 Y156.009 E.06574
G1 X171.991 Y163.931 E.26278
; COOLING_NODE: 0
M204 S10000
G1 X172.398 Y164.398 F60000
G1 F1200
M204 S8000
G1 X169.602 Y164.398 E.09274
G1 X169.602 Y155.602 E.29178
G1 X172.398 Y155.602 E.09274
G1 X172.398 Y164.338 E.28979
; COOLING_NODE: 0
M204 S250
G1 X172.79 Y164.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X169.21 Y164.79 E.11
G1 X169.21 Y155.21 E.29437
G1 X172.79 Y155.21 E.11
G1 X172.79 Y164.73 E.29252
;======== H2D 20260731========
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
G1 X170.79 Y164.764 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.183 Y157.141 Z9.4 F60000
G1 X171.19 Y157 Z9.4
G1 Z9
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42318
G1 F1200
M204 S8000
G1 X171.19 Y156.81 E.00589
G1 X170.81 Y156.81 E.01178
G1 X170.81 Y163.19 E.1977
G1 X171.19 Y163.19 E.01178
G1 X171.19 Y157.06 E.18995
; CHANGE_LAYER
; Z_HEIGHT: 9.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9467.206
G1 X171.19 Y159.06 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 46/70
; update layer progress
M73 L46
M991 S0 P45 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z9.4 I-1.212 J.106 P1  F60000
G1 X171.584 Y163.584 Z9.4
G1 Z9.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X170.416 Y163.584 E.03873
G1 X170.416 Y156.416 E.23776
G1 X171.584 Y156.416 E.03873
G1 X171.584 Y163.524 E.23577
; COOLING_NODE: 0
M204 S10000
G1 X171.991 Y163.991 F60000
G1 F1200
M204 S8000
G1 X170.009 Y163.991 E.06574
G1 X170.009 Y156.009 E.26477
G1 X171.991 Y156.009 E.06574
G1 X171.991 Y163.931 E.26278
; COOLING_NODE: 0
M204 S10000
G1 X172.398 Y164.398 F60000
G1 F1200
M204 S8000
G1 X169.602 Y164.398 E.09274
G1 X169.602 Y155.602 E.29178
G1 X172.398 Y155.602 E.09274
G1 X172.398 Y164.338 E.28979
; COOLING_NODE: 0
M204 S250
G1 X172.79 Y164.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
M73 P73 R3
G1 F1200
M204 S5000
G1 X169.21 Y164.79 E.11
G1 X169.21 Y155.21 E.29437
G1 X172.79 Y155.21 E.11
G1 X172.79 Y164.73 E.29252
;======== H2D 20260731========
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
G1 X170.79 Y164.764 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.183 Y157.141 Z9.6 F60000
G1 X171.19 Y157 Z9.6
G1 Z9.2
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42318
G1 F1200
M204 S8000
G1 X171.19 Y156.81 E.00589
G1 X170.81 Y156.81 E.01178
G1 X170.81 Y163.19 E.1977
G1 X171.19 Y163.19 E.01178
G1 X171.19 Y157.06 E.18995
; CHANGE_LAYER
; Z_HEIGHT: 9.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9467.206
G1 X171.19 Y159.06 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 47/70
; update layer progress
M73 L47
M991 S0 P46 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z9.6 I-1.212 J.106 P1  F60000
G1 X171.584 Y163.584 Z9.6
G1 Z9.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X170.416 Y163.584 E.03873
G1 X170.416 Y156.416 E.23776
G1 X171.584 Y156.416 E.03873
G1 X171.584 Y163.524 E.23577
; COOLING_NODE: 0
M204 S10000
G1 X171.991 Y163.991 F60000
G1 F1200
M204 S8000
G1 X170.009 Y163.991 E.06574
G1 X170.009 Y156.009 E.26477
G1 X171.991 Y156.009 E.06574
G1 X171.991 Y163.931 E.26278
; COOLING_NODE: 0
M204 S10000
G1 X172.398 Y164.398 F60000
G1 F1200
M204 S8000
G1 X169.602 Y164.398 E.09274
G1 X169.602 Y155.602 E.29178
G1 X172.398 Y155.602 E.09274
G1 X172.398 Y164.338 E.28979
; COOLING_NODE: 0
M204 S250
G1 X172.79 Y164.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X169.21 Y164.79 E.11
G1 X169.21 Y155.21 E.29437
G1 X172.79 Y155.21 E.11
G1 X172.79 Y164.73 E.29252
;======== H2D 20260731========
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
G1 X170.79 Y164.764 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.183 Y157.141 Z9.8 F60000
G1 X171.19 Y157 Z9.8
G1 Z9.4
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42318
G1 F1200
M204 S8000
G1 X171.19 Y156.81 E.00589
G1 X170.81 Y156.81 E.01178
G1 X170.81 Y163.19 E.1977
G1 X171.19 Y163.19 E.01178
G1 X171.19 Y157.06 E.18995
; CHANGE_LAYER
; Z_HEIGHT: 9.6
; LAYER_HEIGHT: 0.200001
; WIPE_START
M73 P74 R3
G1 F9467.206
G1 X171.19 Y159.06 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 48/70
; update layer progress
M73 L48
M991 S0 P47 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z9.8 I-1.212 J.106 P1  F60000
G1 X171.584 Y163.584 Z9.8
G1 Z9.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X170.416 Y163.584 E.03873
G1 X170.416 Y156.416 E.23776
G1 X171.584 Y156.416 E.03873
G1 X171.584 Y163.524 E.23577
; COOLING_NODE: 0
M204 S10000
G1 X171.991 Y163.991 F60000
G1 F1200
M204 S8000
G1 X170.009 Y163.991 E.06574
G1 X170.009 Y156.009 E.26477
G1 X171.991 Y156.009 E.06574
G1 X171.991 Y163.931 E.26278
; COOLING_NODE: 0
M204 S10000
G1 X172.398 Y164.398 F60000
G1 F1200
M204 S8000
G1 X169.602 Y164.398 E.09274
G1 X169.602 Y155.602 E.29178
G1 X172.398 Y155.602 E.09274
G1 X172.398 Y164.338 E.28979
; COOLING_NODE: 0
M204 S250
G1 X172.79 Y164.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X169.21 Y164.79 E.11
G1 X169.21 Y155.21 E.29437
G1 X172.79 Y155.21 E.11
G1 X172.79 Y164.73 E.29252
;======== H2D 20260731========
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
G1 X170.79 Y164.764 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.183 Y157.141 Z10 F60000
G1 X171.19 Y157 Z10
G1 Z9.6
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42318
G1 F1200
M204 S8000
G1 X171.19 Y156.81 E.00589
G1 X170.81 Y156.81 E.01178
G1 X170.81 Y163.19 E.1977
G1 X171.19 Y163.19 E.01178
G1 X171.19 Y157.06 E.18995
; CHANGE_LAYER
; Z_HEIGHT: 9.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9467.206
G1 X171.19 Y159.06 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 49/70
; update layer progress
M73 L49
M991 S0 P48 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z10 I1.204 J.179 P1  F60000
G1 X171.584 Y156.416 Z10
G1 Z9.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X171.584 Y163.584 E.23776
G1 X170.416 Y163.584 E.03873
G1 X170.416 Y156.416 E.23776
G1 X171.524 Y156.416 E.03674
; COOLING_NODE: 0
M204 S10000
G1 X171.991 Y156.009 F60000
G1 F1200
M204 S8000
G1 X171.991 Y163.991 E.26477
G1 X170.009 Y163.991 E.06574
G1 X170.009 Y156.009 E.26477
G1 X171.931 Y156.009 E.06375
; COOLING_NODE: 0
M204 S10000
G1 X172.398 Y155.602 F60000
G1 F1200
M204 S8000
M73 P75 R3
G1 X172.398 Y164.398 E.29178
G1 X169.602 Y164.398 E.09274
G1 X169.602 Y155.602 E.29178
G1 X172.338 Y155.602 E.09075
; COOLING_NODE: 0
M204 S250
G1 X172.79 Y155.21 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X172.79 Y164.79 E.29437
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X169.21 Y164.79 E.11
G1 X169.21 Y155.21 E.29437
G1 X172.73 Y155.21 E.10816
; WIPE_START
G1 F9547.055
M204 S8000
G1 X172.743 Y157.21 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.19 Y157 Z10.2 F60000
G1 Z9.8
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42318
G1 F1200
M204 S8000
G1 X171.19 Y156.81 E.00589
G1 X170.81 Y156.81 E.01178
G1 X170.81 Y163.19 E.1977
G1 X171.19 Y163.19 E.01178
G1 X171.19 Y157.06 E.18995
; CHANGE_LAYER
; Z_HEIGHT: 10
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9467.206
G1 X171.19 Y159.06 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 50/70
; update layer progress
M73 L50
M991 S0 P49 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z10.2 I-1.212 J.106 P1  F60000
G1 X171.584 Y163.584 Z10.2
G1 Z10
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X170.416 Y163.584 E.03873
G1 X170.416 Y156.416 E.23776
G1 X171.584 Y156.416 E.03873
G1 X171.584 Y163.524 E.23577
; COOLING_NODE: 0
M204 S10000
G1 X171.991 Y163.991 F60000
G1 F1200
M204 S8000
G1 X170.009 Y163.991 E.06574
G1 X170.009 Y156.009 E.26477
G1 X171.991 Y156.009 E.06574
G1 X171.991 Y163.931 E.26278
; COOLING_NODE: 0
M204 S10000
G1 X172.398 Y164.398 F60000
G1 F1200
M204 S8000
G1 X169.602 Y164.398 E.09274
G1 X169.602 Y155.602 E.29178
G1 X172.398 Y155.602 E.09274
G1 X172.398 Y164.338 E.28979
; COOLING_NODE: 0
M204 S250
G1 X172.79 Y164.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X169.21 Y164.79 E.11
G1 X169.21 Y155.21 E.29437
G1 X172.79 Y155.21 E.11
G1 X172.79 Y164.73 E.29252
;======== H2D 20260731========
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
G1 X170.79 Y164.764 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
M73 P76 R3
G1 X171.183 Y157.141 Z10.4 F60000
G1 X171.19 Y157 Z10.4
G1 Z10
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42318
G1 F1200
M204 S8000
G1 X171.19 Y156.81 E.00589
G1 X170.81 Y156.81 E.01178
G1 X170.81 Y163.19 E.1977
G1 X171.19 Y163.19 E.01178
G1 X171.19 Y157.06 E.18995
; CHANGE_LAYER
; Z_HEIGHT: 10.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9467.206
G1 X171.19 Y159.06 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 51/70
; update layer progress
M73 L51
M991 S0 P50 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z10.4 I-1.148 J.405 P1  F60000
G1 X172.786 Y163.584 Z10.4
G1 Z10.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X170.416 Y163.584 E.0786
G1 X170.416 Y158.416 E.17142
G1 X170.416 Y158.016 E.01327
G1 F8539.319
G1 X170.416 Y157.616 E.01327
G1 F7432.451
G1 X170.416 Y157.216 E.01327
G1 F6402.382
G1 X170.416 Y156.816 E.01327
G1 F5449.114
G1 X170.416 Y156.416 E.01327
G1 F4572.646
G1 X170.818 Y156.416 E.01331
G1 F3770.504
G1 X171.218 Y156.416 E.01327
G1 F3047.885
G1 X171.618 Y156.416 E.01327
G1 F2402.067
G1 X172.018 Y156.416 E.01327
G1 F1833.048
G1 X172.418 Y156.416 E.01327
G1 F1340.829
G1 X172.818 Y156.416 E.01327
G1 F925.411
G1 X173.2 Y156.416 E.01269
; FEATURE: Overhang wall
G1 F600
M204 S5000
G1 X179.584 Y156.416 E.21176
G1 X179.584 Y163.584 E.23776
G1 F3000
G1 X173.2 Y163.584 E.21176
; FEATURE: Inner wall
G1 F1800
M204 S8000
G1 X172.846 Y163.584 E.01175
; COOLING_NODE: 0
M204 S10000
G1 X172.786 Y163.991 F60000
G1 F8843.478
M204 S8000
G1 X170.009 Y163.991 E.09211
G1 X170.009 Y157.609 E.21169
G1 X170.009 Y157.209 E.01327
G1 F8559.573
G1 X170.009 Y156.809 E.01327
G1 F7451.348
G1 X170.009 Y156.409 E.01327
G1 F6419.922
G1 X170.009 Y156.009 E.01327
G1 F5465.296
G1 X170.418 Y156.009 E.01355
G1 F4569.923
G1 X170.818 Y156.009 E.01327
G1 F3770.504
G1 X171.218 Y156.009 E.01327
G1 F3047.885
G1 X171.618 Y156.009 E.01327
G1 F2402.067
G1 X172.018 Y156.009 E.01327
G1 F1833.048
G1 X172.418 Y156.009 E.01327
G1 F1340.829
G1 X172.818 Y156.009 E.01327
G1 F925.411
G1 X173.2 Y156.009 E.01269
; FEATURE: Overhang wall
G1 F600
M204 S5000
G1 X179.991 Y156.009 E.22527
G1 X179.991 Y163.991 E.26477
G1 F3000
G1 X173.2 Y163.991 E.22527
; FEATURE: Inner wall
G1 F1800
M204 S8000
G1 X172.846 Y163.991 E.01175
; COOLING_NODE: 0
M204 S10000
G1 X172.786 Y164.398 F60000
G1 F8843.478
M204 S8000
G1 X169.602 Y164.398 E.10561
G1 X169.602 Y156.802 E.25197
G1 X169.602 Y156.402 E.01327
G1 F8579.852
G1 X169.602 Y156.002 E.01327
G1 F7470.269
G1 X169.602 Y155.602 E.01327
G1 F6437.486
G1 X170.018 Y155.602 E.01378
G1 F5446.141
G1 X170.418 Y155.602 E.01327
G1 F4569.923
G1 X170.818 Y155.602 E.01327
G1 F3770.504
G1 X171.218 Y155.602 E.01327
G1 F3047.885
G1 X171.618 Y155.602 E.01327
G1 F2402.067
G1 X172.018 Y155.602 E.01327
G1 F1833.048
G1 X172.418 Y155.602 E.01327
G1 F1340.829
G1 X172.818 Y155.602 E.01327
G1 F925.411
G1 X173.2 Y155.602 E.01269
; FEATURE: Overhang wall
G1 F600
M204 S5000
G1 X180.398 Y155.602 E.23877
G1 X180.398 Y164.398 E.29178
G1 F3000
G1 X173.2 Y164.398 E.23877
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

; FEATURE: Inner wall
G1 F1800
M204 S8000
G1 X172.846 Y164.398 E.01175
; COOLING_NODE: 0
M204 S250
G1 X172.786 Y164.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1465
M204 S5000
G1 X169.21 Y164.79 E.10988
G1 X169.21 Y156.01 E.26979
G1 X169.21 Y155.61 E.01229
G1 X169.21 Y155.21 E.01229
G1 X169.631 Y155.21 E.01294
G1 X170.031 Y155.21 E.01229
G1 X170.431 Y155.21 E.01229
G1 X170.831 Y155.21 E.01229
G1 X171.231 Y155.21 E.01229
G1 X171.631 Y155.21 E.01229
G1 X172.031 Y155.21 E.01229
G1 X172.431 Y155.21 E.01229
G1 F1325.557
G1 X172.831 Y155.21 E.01229
G1 F912.73
G1 X173.2 Y155.21 E.01134
; FEATURE: Overhang wall
; LINE_WIDTH: 0.45
G1 F600
G1 X180.79 Y155.21 E.25177
G1 X180.79 Y164.79 E.31779
G1 F3000
G1 X173.2 Y164.79 E.25177
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
M73 P77 R3
G1 F1465
G1 X172.846 Y164.79 E.01088
; WIPE_START
G1 F1800
M204 S8000
G1 X170.846 Y164.79 E-.76
; WIPE_END
G1 E-.04
M204 S10000
G1 X171.379 Y163.248 Z10.6 F60000
G1 Z10.2
G1 E.8 F1800
; FEATURE: Bridge
; LINE_WIDTH: 0.42503
G1 F3000
M204 S8000
G1 X179.251 Y163.248 E.24511
G1 X179.251 Y162.866 E.0119
G1 X171.548 Y162.866 E.23982
G1 X171.548 Y162.484 E.0119
G1 X179.251 Y162.484 E.23982
G1 X179.251 Y162.102 E.0119
G1 X171.548 Y162.102 E.23982
G1 X171.548 Y161.72 E.0119
G1 X179.251 Y161.72 E.23982
G1 X179.251 Y161.337 E.0119
G1 X171.548 Y161.337 E.23982
G1 X171.548 Y160.955 E.0119
G1 X179.251 Y160.955 E.23982
G1 X179.251 Y160.573 E.0119
M73 P77 R2
G1 X171.548 Y160.573 E.23982
G1 X171.548 Y160.191 E.0119
G1 X179.251 Y160.191 E.23982
G1 X179.251 Y159.809 E.0119
G1 X171.548 Y159.809 E.23982
G1 X171.548 Y159.427 E.0119
G1 X179.251 Y159.427 E.23982
G1 X179.251 Y159.045 E.0119
G1 X171.548 Y159.045 E.23982
G1 X171.548 Y158.663 E.0119
G1 X179.251 Y158.663 E.23982
G1 X179.251 Y158.281 E.0119
G1 X171.548 Y158.281 E.23982
G1 X171.548 Y157.898 E.0119
G1 X179.251 Y157.898 E.23982
G1 X179.251 Y157.516 E.0119
G1 X171.548 Y157.516 E.23982
G1 X171.548 Y157.134 E.0119
G1 X179.251 Y157.134 E.23982
G1 X179.251 Y156.752 E.0119
G1 X171.379 Y156.752 E.24511
M204 S10000
G1 X171.175 Y156.99 F60000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.413
G1 F9727.626
M204 S8000
G1 X171.175 Y156.805 E.00558
G1 X170.805 Y156.805 E.01116
G1 X170.805 Y163.195 E.19272
G1 X171.175 Y163.195 E.01116
G1 X171.175 Y157.05 E.18533
; CHANGE_LAYER
; Z_HEIGHT: 10.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9727.626
G1 X171.175 Y159.05 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 52/70
; update layer progress
M73 L52
M991 S0 P51 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z10.6 I-.578 J1.071 P1  F60000
G1 X179.584 Y163.584 Z10.6
G1 Z10.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2361
M204 S8000
G1 X170.416 Y163.584 E.30411
G1 X170.416 Y156.416 E.23776
G1 X179.584 Y156.416 E.30411
G1 X179.584 Y163.524 E.23577
; COOLING_NODE: 0
M204 S10000
G1 X179.991 Y163.991 F60000
G1 F2361
M204 S8000
G1 X170.009 Y163.991 E.33111
G1 X170.009 Y156.009 E.26477
G1 X179.991 Y156.009 E.33111
G1 X179.991 Y163.931 E.26278
; COOLING_NODE: 0
M204 S10000
G1 X180.398 Y164.398 F60000
G1 F2361
M204 S8000
G1 X169.602 Y164.398 E.35812
G1 X169.602 Y155.602 E.29178
G1 X180.398 Y155.602 E.35812
G1 X180.398 Y164.338 E.28979
; COOLING_NODE: 0
M204 S250
G1 X180.79 Y164.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1509
M204 S5000
G1 X169.21 Y164.79 E.35582
G1 X169.21 Y155.21 E.29437
M73 P78 R2
G1 X180.79 Y155.21 E.35582
G1 X180.79 Y164.73 E.29252
;======== H2D 20260731========
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
G1 X178.79 Y164.74 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z10.8 I1.209 J-.135 P1  F60000
G1 X178.643 Y163.42 Z10.8
G1 Z10.4
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.4271
G1 F2361
M204 S8000
G1 X179.251 Y162.813 E.0269
G1 X179.251 Y162.269 E.01701
G1 X178.269 Y163.251 E.04345
G1 X177.726 Y163.251 E.01701
G1 X179.251 Y161.726 E.0675
G1 X179.251 Y161.183 E.01701
G1 X177.183 Y163.251 E.09155
G1 X176.639 Y163.251 E.01701
G1 X179.251 Y160.639 E.11561
G1 X179.251 Y160.096 E.01701
G1 X176.096 Y163.251 E.13966
G1 X175.553 Y163.251 E.01701
G1 X179.251 Y159.553 E.16372
G1 X179.251 Y159.009 E.01701
G1 X175.009 Y163.251 E.18777
G1 X174.466 Y163.251 E.01701
G1 X179.251 Y158.466 E.21182
G1 X179.251 Y157.923 E.01701
G1 X173.923 Y163.251 E.23588
G1 X173.379 Y163.251 E.01701
G1 X179.251 Y157.379 E.25993
G1 X179.251 Y156.836 E.01701
G1 X172.836 Y163.251 E.28399
G1 X172.293 Y163.251 E.01701
G1 X178.794 Y156.749 E.28782
G1 X178.251 Y156.749 E.01701
G1 X171.749 Y163.251 E.28782
G1 X171.206 Y163.251 E.01701
G1 X177.707 Y156.749 E.28782
G1 X177.164 Y156.749 E.01701
G1 X170.749 Y163.164 E.28399
G1 X170.749 Y162.621 E.01701
G1 X176.621 Y156.749 E.25994
G1 X176.077 Y156.749 E.01701
G1 X170.749 Y162.077 E.23588
G1 X170.749 Y161.534 E.01701
G1 X175.534 Y156.749 E.21183
G1 X174.991 Y156.749 E.01701
G1 X170.749 Y160.991 E.18777
G1 X170.749 Y160.447 E.01701
G1 X174.447 Y156.749 E.16372
G1 X173.904 Y156.749 E.01701
G1 X170.749 Y159.904 E.13966
G1 X170.749 Y159.361 E.01701
G1 X173.361 Y156.749 E.11561
G1 X172.817 Y156.749 E.01701
G1 X170.749 Y158.817 E.09156
G1 X170.749 Y158.274 E.01701
G1 X172.274 Y156.749 E.0675
G1 X171.731 Y156.749 E.01701
G1 X170.749 Y157.731 E.04345
G1 X170.749 Y157.188 E.01701
G1 X171.357 Y156.58 E.02691
; CHANGE_LAYER
; Z_HEIGHT: 10.6
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F9370.607
G1 X170.749 Y157.188 E-.32659
G1 X170.749 Y157.731 E-.20646
G1 X171.172 Y157.309 E-.22695
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 53/70
; update layer progress
M73 L53
M991 S0 P52 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z10.8 I-.728 J.975 P1  F60000
G1 X179.584 Y163.584 Z10.8
G1 Z10.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2361
M204 S8000
G1 X170.416 Y163.584 E.30411
G1 X170.416 Y156.416 E.23776
G1 X179.584 Y156.416 E.30411
G1 X179.584 Y163.524 E.23577
; COOLING_NODE: 0
M204 S10000
G1 X179.991 Y163.991 F60000
G1 F2361
M204 S8000
G1 X170.009 Y163.991 E.33111
G1 X170.009 Y156.009 E.26477
G1 X179.991 Y156.009 E.33111
G1 X179.991 Y163.931 E.26278
; COOLING_NODE: 0
M204 S10000
G1 X180.398 Y164.398 F60000
G1 F2361
M204 S8000
G1 X169.602 Y164.398 E.35812
M73 P79 R2
G1 X169.602 Y155.602 E.29178
G1 X180.398 Y155.602 E.35812
G1 X180.398 Y164.338 E.28979
; COOLING_NODE: 0
M204 S250
G1 X180.79 Y164.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1531
M204 S5000
G1 X169.21 Y164.79 E.35582
G1 X169.21 Y155.21 E.29437
G1 X180.79 Y155.21 E.35582
G1 X180.79 Y164.73 E.29252
;======== H2D 20260731========
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
G1 X178.79 Y164.74 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X179.42 Y157.357 Z11 F60000
G1 Z10.6
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.4271
G1 F2361
M204 S8000
G1 X178.813 Y156.749 E.0269
G1 X178.269 Y156.749 E.01701
G1 X179.251 Y157.731 E.04344
G1 X179.251 Y158.274 E.01701
G1 X177.726 Y156.749 E.0675
G1 X177.183 Y156.749 E.01701
G1 X179.251 Y158.817 E.09155
G1 X179.251 Y159.361 E.01701
G1 X176.639 Y156.749 E.11561
G1 X176.096 Y156.749 E.01701
G1 X179.251 Y159.904 E.13966
G1 X179.251 Y160.447 E.01701
G1 X175.553 Y156.749 E.16372
G1 X175.009 Y156.749 E.01701
G1 X179.251 Y160.991 E.18777
G1 X179.251 Y161.534 E.01701
G1 X174.466 Y156.749 E.21182
G1 X173.923 Y156.749 E.01701
G1 X179.251 Y162.077 E.23588
G1 X179.251 Y162.621 E.01701
G1 X173.379 Y156.749 E.25993
G1 X172.836 Y156.749 E.01701
G1 X179.251 Y163.164 E.28399
G1 X179.251 Y163.251 E.00271
G1 X178.794 Y163.251 E.0143
G1 X172.293 Y156.749 E.28782
G1 X171.749 Y156.749 E.01701
G1 X178.251 Y163.251 E.28782
G1 X177.707 Y163.251 E.01701
G1 X171.206 Y156.749 E.28782
G1 X170.749 Y156.749 E.0143
G1 X170.749 Y156.836 E.00271
G1 X177.164 Y163.251 E.28399
G1 X176.621 Y163.251 E.01701
G1 X170.749 Y157.379 E.25994
G1 X170.749 Y157.923 E.01701
G1 X176.077 Y163.251 E.23588
G1 X175.534 Y163.251 E.01701
G1 X170.749 Y158.466 E.21183
G1 X170.749 Y159.009 E.01701
G1 X174.991 Y163.251 E.18777
G1 X174.447 Y163.251 E.01701
G1 X170.749 Y159.553 E.16372
G1 X170.749 Y160.096 E.01701
G1 X173.904 Y163.251 E.13966
G1 X173.361 Y163.251 E.01701
G1 X170.749 Y160.639 E.11561
G1 X170.749 Y161.183 E.01701
G1 X172.817 Y163.251 E.09156
G1 X172.274 Y163.251 E.01701
G1 X170.749 Y161.726 E.0675
G1 X170.749 Y162.269 E.01701
G1 X171.731 Y163.251 E.04345
G1 X171.188 Y163.251 E.01701
G1 X170.58 Y162.643 E.02691
; CHANGE_LAYER
; Z_HEIGHT: 10.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9370.607
G1 X171.188 Y163.251 E-.3266
G1 X171.731 Y163.251 E-.20646
G1 X171.309 Y162.828 E-.22694
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 54/70
; update layer progress
M73 L54
M991 S0 P53 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z11 I-.111 J1.212 P1  F60000
G1 X179.584 Y163.584 Z11
G1 Z10.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2359
M204 S8000
G1 X170.416 Y163.584 E.30411
G1 X170.416 Y156.416 E.23776
G1 X179.584 Y156.416 E.30411
G1 X179.584 Y163.524 E.23577
; COOLING_NODE: 0
M204 S10000
G1 X179.991 Y163.991 F60000
G1 F2359
M204 S8000
M73 P80 R2
G1 X170.009 Y163.991 E.33111
G1 X170.009 Y156.009 E.26477
G1 X179.991 Y156.009 E.33111
G1 X179.991 Y163.931 E.26278
; COOLING_NODE: 0
M204 S10000
G1 X180.398 Y164.398 F60000
G1 F2359
M204 S8000
G1 X169.602 Y164.398 E.35812
G1 X169.602 Y155.602 E.29178
G1 X180.398 Y155.602 E.35812
G1 X180.398 Y164.338 E.28979
; COOLING_NODE: 0
M204 S250
G1 X180.79 Y164.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1524
M204 S5000
G1 X169.21 Y164.79 E.35582
G1 X169.21 Y155.21 E.29437
G1 X180.79 Y155.21 E.35582
G1 X180.79 Y164.73 E.29252
;======== H2D 20260731========
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
G1 X178.79 Y164.74 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X178.643 Y163.42 Z11.2 F60000
G1 Z10.8
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.4271
G1 F2359
M204 S8000
G1 X179.251 Y162.813 E.0269
G1 X179.251 Y162.269 E.01701
G1 X178.269 Y163.251 E.04345
G1 X177.726 Y163.251 E.01701
G1 X179.251 Y161.726 E.0675
G1 X179.251 Y161.183 E.01701
G1 X177.183 Y163.251 E.09155
G1 X176.639 Y163.251 E.01701
G1 X179.251 Y160.639 E.11561
G1 X179.251 Y160.096 E.01701
G1 X176.096 Y163.251 E.13966
G1 X175.553 Y163.251 E.01701
G1 X179.251 Y159.553 E.16372
G1 X179.251 Y159.009 E.01701
G1 X175.009 Y163.251 E.18777
G1 X174.466 Y163.251 E.01701
G1 X179.251 Y158.466 E.21182
G1 X179.251 Y157.923 E.01701
G1 X173.923 Y163.251 E.23588
G1 X173.379 Y163.251 E.01701
G1 X179.251 Y157.379 E.25993
G1 X179.251 Y156.836 E.01701
G1 X172.836 Y163.251 E.28399
G1 X172.293 Y163.251 E.01701
G1 X178.794 Y156.749 E.28782
G1 X178.251 Y156.749 E.01701
G1 X171.749 Y163.251 E.28782
G1 X171.206 Y163.251 E.01701
G1 X177.707 Y156.749 E.28782
G1 X177.164 Y156.749 E.01701
G1 X170.749 Y163.164 E.28399
G1 X170.749 Y162.621 E.01701
G1 X176.621 Y156.749 E.25994
G1 X176.077 Y156.749 E.01701
G1 X170.749 Y162.077 E.23588
G1 X170.749 Y161.534 E.01701
G1 X175.534 Y156.749 E.21183
G1 X174.991 Y156.749 E.01701
G1 X170.749 Y160.991 E.18777
G1 X170.749 Y160.447 E.01701
G1 X174.447 Y156.749 E.16372
G1 X173.904 Y156.749 E.01701
G1 X170.749 Y159.904 E.13966
G1 X170.749 Y159.361 E.01701
G1 X173.361 Y156.749 E.11561
G1 X172.817 Y156.749 E.01701
M73 P81 R2
G1 X170.749 Y158.817 E.09156
G1 X170.749 Y158.274 E.01701
G1 X172.274 Y156.749 E.0675
G1 X171.731 Y156.749 E.01701
G1 X170.749 Y157.731 E.04345
G1 X170.749 Y157.188 E.01701
G1 X171.357 Y156.58 E.02691
; CHANGE_LAYER
; Z_HEIGHT: 11
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9370.607
G1 X170.749 Y157.188 E-.32659
G1 X170.749 Y157.731 E-.20646
G1 X171.172 Y157.309 E-.22695
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 55/70
; update layer progress
M73 L55
M991 S0 P54 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z11.2 I-.728 J.975 P1  F60000
G1 X179.584 Y163.584 Z11.2
G1 Z11
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2141
M204 S8000
G1 X170.416 Y163.584 E.30411
G1 X170.416 Y156.416 E.23776
G1 X179.584 Y156.416 E.30411
G1 X179.584 Y163.524 E.23577
; COOLING_NODE: 0
M204 S10000
G1 X179.991 Y163.991 F60000
G1 F2141
M204 S8000
G1 X170.009 Y163.991 E.33111
G1 X170.009 Y156.009 E.26477
G1 X179.991 Y156.009 E.33111
G1 X179.991 Y163.931 E.26278
; COOLING_NODE: 0
M204 S10000
G1 X180.398 Y164.398 F60000
G1 F2141
M204 S8000
G1 X169.602 Y164.398 E.35812
G1 X169.602 Y155.602 E.29178
G1 X180.398 Y155.602 E.35812
G1 X180.398 Y164.338 E.28979
; COOLING_NODE: 0
M204 S250
G1 X180.79 Y164.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1496
M204 S5000
G1 X169.21 Y164.79 E.35582
G1 X169.21 Y155.21 E.29437
G1 X180.79 Y155.21 E.35582
G1 X180.79 Y164.73 E.29252
;======== H2D 20260731========
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
G1 X178.79 Y164.74 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X179.42 Y157.344 Z11.4 F60000
G1 Z11
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42115
G1 F2141
M204 S8000
G1 X178.825 Y156.749 E.02594
G1 X178.29 Y156.749 E.01649
G1 X179.251 Y157.71 E.04185
G1 X179.251 Y158.245 E.01649
G1 X177.755 Y156.749 E.06517
G1 X177.22 Y156.749 E.01649
G1 X179.251 Y158.78 E.08848
G1 X179.251 Y159.314 E.01649
G1 X176.686 Y156.749 E.1118
G1 X176.151 Y156.749 E.01649
G1 X179.251 Y159.849 E.13511
G1 X179.251 Y160.384 E.01649
G1 X175.616 Y156.749 E.15843
G1 X175.081 Y156.749 E.01649
G1 X179.251 Y160.919 E.18174
G1 X179.251 Y161.454 E.01649
G1 X174.546 Y156.749 E.20506
G1 X174.011 Y156.749 E.01649
G1 X179.251 Y161.989 E.22837
G1 X179.251 Y162.524 E.01649
G1 X173.476 Y156.749 E.25169
G1 X173.091 Y156.749 E.01188
G1 X173.091 Y156.899 E.0046
G1 X179.251 Y163.059 E.2685
G1 X179.251 Y163.251 E.00591
G1 X178.907 Y163.251 E.01057
G1 X173.091 Y157.434 E.25354
G1 X173.091 Y157.969 E.01649
G1 X178.373 Y163.251 E.23023
G1 X177.838 Y163.251 E.01649
G1 X173.091 Y158.503 E.20691
G1 X173.091 Y159.038 E.01649
M73 P82 R2
G1 X177.303 Y163.251 E.1836
G1 X176.768 Y163.251 E.01649
G1 X173.091 Y159.573 E.16028
G1 X173.091 Y160.108 E.01649
G1 X176.233 Y163.251 E.13697
G1 X175.698 Y163.251 E.01649
G1 X173.091 Y160.643 E.11365
G1 X173.091 Y161.178 E.01649
G1 X175.163 Y163.251 E.09034
G1 X174.628 Y163.251 E.01649
G1 X173.091 Y161.713 E.06703
G1 X173.091 Y162.248 E.01649
G1 X174.093 Y163.251 E.04371
G1 X173.559 Y163.251 E.01649
G1 X172.921 Y162.613 E.02779
M204 S10000
G1 X170.964 Y163.236 F60000
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F2141
M204 S8000
G1 X172.592 Y163.236 E.05401
G1 X171.716 Y162.621 E.03552
G1 X171.479 Y162.293 E.01341
G3 X172.698 Y160.242 I2.135 J-.119 E.08398
G1 X172.698 Y158.106 E.07085
G1 X171.716 Y157.379 E.04054
G3 X171.459 Y156.764 I.365 J-.513 E.02329
G1 X170.764 Y156.764 E.02304
G1 X170.764 Y157.698 E.03097
; CHANGE_LAYER
; Z_HEIGHT: 11.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F8843.478
G1 X170.764 Y156.764 E-.35479
G1 X171.459 Y156.764 E-.26397
G1 X171.479 Y157.052 E-.10945
G1 X171.528 Y157.12 E-.03179
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 56/70
; update layer progress
M73 L56
M991 S0 P55 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z11.4 I-.762 J.949 P1  F60000
G1 X179.584 Y163.584 Z11.4
G1 Z11.2
G1 E.8 F1800
; FEATURE: Inner wall
G1 F1483
M204 S8000
G1 X170.416 Y163.584 E.30411
G1 X170.416 Y156.416 E.23776
G1 X179.584 Y156.416 E.30411
G1 X179.584 Y163.524 E.23577
; COOLING_NODE: 0
M204 S10000
G1 X179.991 Y163.991 F60000
G1 F1483
M204 S8000
G1 X170.009 Y163.991 E.33111
G1 X170.009 Y156.009 E.26477
G1 X179.991 Y156.009 E.33111
G1 X179.991 Y163.931 E.26278
; COOLING_NODE: 0
M204 S10000
G1 X180.398 Y164.398 F60000
G1 F1483
M204 S8000
G1 X169.602 Y164.398 E.35812
G1 X169.602 Y155.602 E.29178
G1 X180.398 Y155.602 E.35812
G1 X180.398 Y164.338 E.28979
; COOLING_NODE: 0
M204 S250
G1 X180.79 Y164.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1460
M204 S5000
G1 X169.21 Y164.79 E.35582
G1 X169.21 Y155.21 E.29437
G1 X180.79 Y155.21 E.35582
G1 X180.79 Y164.73 E.29252
;======== H2D 20260731========
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
G1 X178.79 Y164.74 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
M73 P83 R2
G1 X179.236 Y163.13 Z11.6 F60000
G1 Z11.2
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F1483
M204 S8000
G1 X179.236 Y163.236 E.00349
G1 X177.712 Y163.236 E.05053
G1 X177.621 Y163.162 E.00391
G2 X176.638 Y162.882 I-1.064 J1.875 E.03422
G2 X176.182 Y163.236 I.174 J.695 E.01968
G1 X172.471 Y163.236 E.12311
G1 X172.379 Y163.162 E.00391
G2 X171.397 Y162.882 I-1.064 J1.875 E.03422
G2 X170.941 Y163.236 I.174 J.695 E.01968
G1 X170.764 Y163.236 E.00586
G1 X170.764 Y162.346 E.0295
G1 X171.069 Y162.175 E.01158
G1 X171.724 Y161.069 E.04266
G3 X173.362 Y160.262 I1.938 J1.867 E.0618
G1 X173.69 Y160.445 E.01246
G1 X174.345 Y161.552 E.04266
G2 X175.983 Y162.359 I1.938 J-1.867 E.0618
G1 X176.31 Y162.175 E.01246
G1 X176.966 Y161.069 E.04266
G3 X178.603 Y160.262 I1.938 J1.867 E.0618
G1 X178.931 Y160.445 E.01246
G1 X179.236 Y160.96 E.01983
G1 X179.236 Y159.725 E.04094
G1 X178.931 Y159.555 E.01158
G1 X178.276 Y158.448 E.04266
G2 X176.638 Y157.641 I-1.938 J1.867 E.0618
G1 X176.31 Y157.825 E.01246
G1 X175.655 Y158.931 E.04266
G3 X174.017 Y159.738 I-1.938 J-1.867 E.0618
G1 X173.69 Y159.555 E.01246
G1 X173.035 Y158.448 E.04266
G2 X171.397 Y157.641 I-1.938 J1.867 E.0618
G1 X171.069 Y157.825 E.01246
G1 X170.764 Y158.339 E.01983
G1 X170.764 Y157.105 E.04094
G2 X171.17 Y156.764 I-.091 J-.519 E.01839
G1 X174.908 Y156.764 E.12402
G1 X175 Y156.838 E.00391
G2 X175.983 Y157.118 I1.064 J-1.875 E.03422
G2 X176.411 Y156.764 I-.091 J-.546 E.01929
G1 X178.039 Y156.764 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 11.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F8843.478
G1 X176.411 Y156.764 E-.61876
G1 X176.31 Y156.934 E-.07495
G1 X176.158 Y157.019 E-.0663
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 57/70
; update layer progress
M73 L57
M991 S0 P56 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z11.6 I-1.079 J.563 P1  F60000
G1 X179.584 Y163.584 Z11.6
G1 Z11.4
G1 E.8 F1800
; FEATURE: Inner wall
G1 F1468
M204 S8000
G1 X170.416 Y163.584 E.30411
G1 X170.416 Y156.416 E.23776
G1 X179.584 Y156.416 E.30411
G1 X179.584 Y163.524 E.23577
; COOLING_NODE: 0
M204 S10000
G1 X179.991 Y163.991 F60000
G1 F1468
M204 S8000
G1 X170.009 Y163.991 E.33111
G1 X170.009 Y156.009 E.26477
G1 X179.991 Y156.009 E.33111
G1 X179.991 Y163.931 E.26278
; COOLING_NODE: 0
M204 S10000
G1 X180.398 Y164.398 F60000
G1 F1468
M204 S8000
G1 X169.602 Y164.398 E.35812
G1 X169.602 Y155.602 E.29178
G1 X180.398 Y155.602 E.35812
G1 X180.398 Y164.338 E.28979
; COOLING_NODE: 0
M204 S250
G1 X180.79 Y164.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1428
M204 S5000
G1 X169.21 Y164.79 E.35582
G1 X169.21 Y155.21 E.29437
G1 X180.79 Y155.21 E.35582
G1 X180.79 Y164.73 E.29252
;======== H2D 20260731========
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
G1 X178.79 Y164.74 E-.76
; WIPE_END
M73 P84 R2
G1 E-.04 F1800
M204 S10000
G1 X179.236 Y163.209 Z11.8 F60000
G1 Z11.4
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F1468
M204 S8000
G1 X177.634 Y163.236 E.05314
G1 X176.966 Y163.133 E.02243
G2 X176.618 Y163.236 I-.059 J.437 E.01237
G1 X172.393 Y163.236 E.14018
G1 X171.724 Y163.133 E.02243
G3 X170.764 Y163.236 I-.672 J-1.746 E.03239
G1 X170.764 Y162.003 E.04088
G2 X171.724 Y160.989 I-2.267 J-3.107 E.04656
G3 X173.362 Y160.599 I1.201 J1.409 E.05798
G3 X174.345 Y161.631 I-2.306 J3.179 E.04754
G2 X175.983 Y162.022 I1.201 J-1.409 E.05798
G2 X176.966 Y160.989 I-2.306 J-3.179 E.04754
G3 X178.603 Y160.599 I1.201 J1.409 E.05798
G3 X179.236 Y161.221 I-1.369 J2.024 E.02958
G1 X179.236 Y159.382 E.06099
G3 X178.276 Y158.369 I2.267 J-3.107 E.04656
G2 X176.638 Y157.978 I-1.201 J1.409 E.05798
G2 X175.655 Y159.011 I2.306 J3.179 E.04754
G3 X174.017 Y159.401 I-1.201 J-1.409 E.05798
G3 X173.035 Y158.369 I2.306 J-3.179 E.04754
G2 X171.397 Y157.978 I-1.201 J1.409 E.05798
G2 X170.764 Y158.6 I1.369 J2.024 E.02958
G1 X170.764 Y156.764 E.0609
G1 X174.987 Y156.764 E.14006
G1 X175.655 Y156.867 E.02243
G2 X176.002 Y156.764 I.059 J-.438 E.01238
G1 X177.631 Y156.764 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 11.6
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F8843.478
G1 X176.002 Y156.764 E-.61876
G1 X175.655 Y156.867 E-.1376
G1 X175.646 Y156.866 E-.00365
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 58/70
; update layer progress
M73 L58
M991 S0 P57 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z11.8 I-1.05 J.615 P1  F60000
G1 X179.584 Y163.584 Z11.8
G1 Z11.6
G1 E.8 F1800
; FEATURE: Inner wall
G1 F1350
M204 S8000
G1 X170.416 Y163.584 E.30411
G1 X170.416 Y156.416 E.23776
G1 X179.584 Y156.416 E.30411
G1 X179.584 Y163.524 E.23577
; COOLING_NODE: 0
M204 S10000
G1 X179.991 Y163.991 F60000
G1 F1350
M204 S8000
G1 X170.009 Y163.991 E.33111
G1 X170.009 Y156.009 E.26477
G1 X179.991 Y156.009 E.33111
G1 X179.991 Y163.931 E.26278
; COOLING_NODE: 0
M204 S10000
G1 X180.398 Y164.398 F60000
G1 F1350
M204 S8000
G1 X169.602 Y164.398 E.35812
G1 X169.602 Y155.602 E.29178
G1 X180.398 Y155.602 E.35812
G1 X180.398 Y164.338 E.28979
; COOLING_NODE: 0
M204 S250
G1 X180.79 Y164.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1350
M204 S5000
G1 X169.21 Y164.79 E.35582
M73 P84 R1
G1 X169.21 Y155.21 E.29437
G1 X180.79 Y155.21 E.35582
G1 X180.79 Y164.73 E.29252
;======== H2D 20260731========
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
M73 P85 R1
G1 F9547.055
M204 S8000
G1 X178.79 Y164.74 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.294 Y163.305 Z12 F60000
G1 X170.93 Y163.236 Z12
G1 Z11.6
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F1350
M204 S8000
G1 X170.764 Y163.236 E.0055
G1 X170.764 Y161.773 E.04851
G2 X171.724 Y160.899 I-12.091 J-14.241 E.04307
G3 X173.035 Y160.674 I.91 J1.369 E.04541
G3 X174.345 Y161.722 I-1.931 J3.757 E.05603
G2 X175.655 Y161.947 I.91 J-1.369 E.04541
G2 X176.966 Y160.899 I-1.931 J-3.758 E.05603
G3 X178.276 Y160.674 I.91 J1.369 E.04541
G3 X179.236 Y161.395 I-1.349 J2.792 E.04009
G1 X179.236 Y159.152 E.07441
G3 X178.276 Y158.278 I12.088 J-14.238 E.04306
G2 X176.966 Y158.053 I-.91 J1.369 E.04541
G2 X175.655 Y159.101 I1.931 J3.758 E.05603
G3 X174.345 Y159.327 I-.91 J-1.369 E.04541
G3 X173.035 Y158.278 I1.931 J-3.757 E.05603
G2 X171.724 Y158.053 I-.91 J1.369 E.04541
G2 X170.764 Y158.775 I1.35 J2.793 E.04009
G1 X170.764 Y157.147 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 11.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F8843.478
G1 X170.764 Y158.775 E-.61876
G1 X171.041 Y158.527 E-.14124
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 59/70
; update layer progress
M73 L59
M991 S0 P58 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z12 I-.62 J1.047 P1  F60000
G1 X179.584 Y163.584 Z12
G1 Z11.8
G1 E.8 F1800
; FEATURE: Inner wall
G1 F1349
M204 S8000
G1 X170.416 Y163.584 E.30411
G1 X170.416 Y156.416 E.23776
G1 X179.584 Y156.416 E.30411
G1 X179.584 Y163.524 E.23577
; COOLING_NODE: 0
M204 S10000
G1 X179.991 Y163.991 F60000
G1 F1349
M204 S8000
G1 X170.009 Y163.991 E.33111
G1 X170.009 Y156.009 E.26477
G1 X179.991 Y156.009 E.33111
G1 X179.991 Y163.931 E.26278
; COOLING_NODE: 0
M204 S10000
G1 X180.398 Y164.398 F60000
G1 F1349
M204 S8000
G1 X169.602 Y164.398 E.35812
G1 X169.602 Y155.602 E.29178
G1 X180.398 Y155.602 E.35812
G1 X180.398 Y164.338 E.28979
; COOLING_NODE: 0
M204 S250
G1 X180.79 Y164.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1349
M204 S5000
G1 X169.21 Y164.79 E.35582
G1 X169.21 Y155.21 E.29437
G1 X180.79 Y155.21 E.35582
G1 X180.79 Y164.73 E.29252
;======== H2D 20260731========
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
M73 P86 R1
G1 F9547.055
M204 S8000
G1 X178.79 Y164.74 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X179.236 Y163.183 Z12.2 F60000
G1 Z11.8
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F1349
M204 S8000
G1 X179.236 Y161.555 E.05401
G3 X178.276 Y160.801 I66.479 J-85.638 E.04048
G2 X176.31 Y161.303 I-.624 J1.655 E.07167
G1 X175.655 Y161.82 E.02767
G3 X173.69 Y161.317 I-.624 J-1.655 E.07167
G1 X173.035 Y160.801 E.02767
G2 X171.069 Y161.303 I-.624 J1.655 E.07167
G1 X170.764 Y161.543 E.01287
G1 X170.764 Y158.934 E.08655
G2 X171.724 Y158.18 I-66.314 J-85.427 E.04048
G3 X173.69 Y158.683 I.624 J1.655 E.07167
G1 X174.345 Y159.199 E.02767
G2 X176.31 Y158.697 I.624 J-1.655 E.07167
G1 X176.966 Y158.18 E.02767
G3 X178.931 Y158.683 I.624 J1.655 E.07167
G1 X179.236 Y158.923 E.01286
G1 X179.236 Y157.294 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 12
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F8843.478
G1 X179.236 Y158.923 E-.61876
G1 X178.944 Y158.693 E-.14124
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 60/70
; update layer progress
M73 L60
M991 S0 P59 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z12.2 I-1.207 J.158 P1  F60000
G1 X179.584 Y163.584 Z12.2
G1 Z12
G1 E.8 F1800
; FEATURE: Inner wall
G1 F1348
M204 S8000
G1 X170.416 Y163.584 E.30411
G1 X170.416 Y156.416 E.23776
G1 X179.584 Y156.416 E.30411
G1 X179.584 Y163.524 E.23577
; COOLING_NODE: 0
M204 S10000
G1 X179.991 Y163.991 F60000
G1 F1348
M204 S8000
G1 X170.009 Y163.991 E.33111
G1 X170.009 Y156.009 E.26477
G1 X179.991 Y156.009 E.33111
G1 X179.991 Y163.931 E.26278
; COOLING_NODE: 0
M204 S10000
G1 X180.398 Y164.398 F60000
G1 F1348
M204 S8000
G1 X169.602 Y164.398 E.35812
G1 X169.602 Y155.602 E.29178
G1 X180.398 Y155.602 E.35812
G1 X180.398 Y164.338 E.28979
; COOLING_NODE: 0
M204 S250
G1 X180.79 Y164.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1348
M204 S5000
G1 X169.21 Y164.79 E.35582
M73 P87 R1
G1 X169.21 Y155.21 E.29437
G1 X180.79 Y155.21 E.35582
G1 X180.79 Y164.73 E.29252
;======== H2D 20260731========
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
G1 X178.79 Y164.74 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X179.056 Y163.236 Z12.4 F60000
G1 Z12
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F1348
M204 S8000
G1 X179.236 Y163.236 E.00597
G1 X179.236 Y161.787 E.04804
G3 X178.276 Y160.906 I9.569 J-11.382 E.04324
G2 X176.638 Y160.814 I-.905 J1.48 E.05668
G2 X175.655 Y161.715 I9.785 J11.655 E.04425
G3 X174.017 Y161.807 I-.905 J-1.48 E.05668
G3 X173.035 Y160.906 I9.783 J-11.653 E.04425
G2 X171.397 Y160.814 I-.905 J1.48 E.05668
G2 X170.764 Y161.384 I6.187 J7.491 E.02826
G1 X170.764 Y159.167 E.07356
G2 X171.724 Y158.285 I-9.567 J-11.38 E.04324
G3 X173.362 Y158.193 I.905 J1.48 E.05668
G3 X174.345 Y159.094 I-9.785 J11.655 E.04425
G2 X175.983 Y159.187 I.905 J-1.48 E.05668
G2 X176.966 Y158.285 I-9.779 J-11.649 E.04425
G3 X178.603 Y158.193 I.905 J1.48 E.05668
G3 X179.236 Y158.763 I-6.185 J7.489 E.02825
G1 X179.236 Y157.135 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 12.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F8843.478
G1 X179.236 Y158.763 E-.61876
G1 X178.96 Y158.514 E-.14124
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 61/70
; update layer progress
M73 L61
M991 S0 P60 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z12.4 I-1.208 J.149 P1  F60000
G1 X179.584 Y163.584 Z12.4
G1 Z12.2
G1 E.8 F1800
; FEATURE: Inner wall
G1 F1470
M204 S8000
G1 X170.416 Y163.584 E.30411
G1 X170.416 Y156.416 E.23776
G1 X179.584 Y156.416 E.30411
G1 X179.584 Y163.524 E.23577
; COOLING_NODE: 0
M204 S10000
G1 X179.991 Y163.991 F60000
G1 F1470
M204 S8000
G1 X170.009 Y163.991 E.33111
G1 X170.009 Y156.009 E.26477
G1 X179.991 Y156.009 E.33111
G1 X179.991 Y163.931 E.26278
; COOLING_NODE: 0
M204 S10000
G1 X180.398 Y164.398 F60000
G1 F1470
M204 S8000
G1 X169.602 Y164.398 E.35812
G1 X169.602 Y155.602 E.29178
G1 X180.398 Y155.602 E.35812
G1 X180.398 Y164.338 E.28979
; COOLING_NODE: 0
M204 S250
G1 X180.79 Y164.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1397
M204 S5000
G1 X169.21 Y164.79 E.35582
M73 P88 R1
G1 X169.21 Y155.21 E.29437
G1 X180.79 Y155.21 E.35582
G1 X180.79 Y164.73 E.29252
;======== H2D 20260731========
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
G1 X178.79 Y164.74 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.294 Y163.305 Z12.6 F60000
G1 X170.764 Y163.203 Z12.6
G1 Z12.2
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F1470
M204 S8000
G1 X172.361 Y163.236 E.05295
G1 X173.035 Y163.12 E.02269
G3 X173.406 Y163.236 I.061 J.456 E.01331
G1 X177.602 Y163.236 E.1392
G1 X178.276 Y163.12 E.02269
G3 X178.647 Y163.236 I.061 J.456 E.01331
G1 X179.236 Y163.236 E.01953
G1 X179.236 Y162.022 E.04025
G3 X178.276 Y160.995 I2.111 J-2.934 E.04692
G2 X176.966 Y160.499 I-1.275 J1.388 E.04762
G1 X176.638 Y160.58 E.01119
G2 X175.655 Y161.625 I2.146 J3.002 E.0479
G3 X174.345 Y162.122 I-1.275 J-1.388 E.04762
G1 X174.017 Y162.041 E.01119
G3 X173.035 Y160.995 I2.146 J-3.002 E.0479
G2 X171.724 Y160.499 I-1.275 J1.388 E.04762
G2 X170.764 Y161.207 I.346 J1.474 E.04066
G1 X170.764 Y159.402 E.05989
G2 X171.724 Y158.375 I-2.111 J-2.935 E.04693
G3 X173.035 Y157.879 I1.275 J1.388 E.04762
G1 X173.362 Y157.959 E.01119
G3 X174.345 Y159.005 I-2.146 J3.002 E.0479
G2 X175.655 Y159.501 I1.275 J-1.388 E.04762
G1 X175.983 Y159.42 E.01119
G2 X176.966 Y158.375 I-2.146 J-3.002 E.0479
G3 X178.276 Y157.879 I1.275 J1.388 E.04762
G3 X179.236 Y158.586 I-.346 J1.473 E.04066
G1 X179.236 Y156.764 E.06043
G1 X175.019 Y156.764 E.13987
G1 X174.345 Y156.88 E.02269
G3 X173.974 Y156.764 I-.061 J-.456 E.01331
G1 X172.346 Y156.764 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 12.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F8843.478
G1 X173.974 Y156.764 E-.61876
G1 X174.329 Y156.875 E-.14124
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 62/70
; update layer progress
M73 L62
M991 S0 P61 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z12.6 I-.958 J.75 P1  F60000
G1 X179.584 Y163.584 Z12.6
G1 Z12.4
G1 E.8 F1800
; FEATURE: Inner wall
G1 F1486
M204 S8000
G1 X170.416 Y163.584 E.30411
G1 X170.416 Y156.416 E.23776
G1 X179.584 Y156.416 E.30411
G1 X179.584 Y163.524 E.23577
; COOLING_NODE: 0
M204 S10000
G1 X179.991 Y163.991 F60000
G1 F1486
M204 S8000
G1 X170.009 Y163.991 E.33111
G1 X170.009 Y156.009 E.26477
G1 X179.991 Y156.009 E.33111
G1 X179.991 Y163.931 E.26278
; COOLING_NODE: 0
M204 S10000
G1 X180.398 Y164.398 F60000
G1 F1486
M204 S8000
G1 X169.602 Y164.398 E.35812
G1 X169.602 Y155.602 E.29178
G1 X180.398 Y155.602 E.35812
G1 X180.398 Y164.338 E.28979
; COOLING_NODE: 0
M204 S250
G1 X180.79 Y164.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1422
M204 S5000
M73 P89 R1
G1 X169.21 Y164.79 E.35582
G1 X169.21 Y155.21 E.29437
G1 X180.79 Y155.21 E.35582
G1 X180.79 Y164.73 E.29252
;======== H2D 20260731========
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
G1 X178.79 Y164.74 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.308 Y163.234 Z12.8 F60000
G1 X170.764 Y163.125 Z12.8
G1 Z12.4
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F1486
M204 S8000
G1 X170.764 Y163.236 E.00366
G1 X172.282 Y163.236 E.05035
G1 X173.035 Y162.902 E.02729
G3 X173.847 Y163.236 I.207 J.653 E.03163
G1 X177.524 Y163.236 E.12195
G1 X178.276 Y162.902 E.02729
G3 X179.089 Y163.236 I.207 J.653 E.03163
G1 X179.236 Y163.236 E.00487
G1 X179.236 Y162.38 E.0284
G1 X178.931 Y162.227 E.01129
G1 X178.276 Y161.074 E.04399
G2 X176.966 Y160.282 I-1.853 J1.584 E.05167
G2 X176.31 Y160.393 I-.249 J.514 E.02353
G1 X175.655 Y161.547 E.04399
G3 X174.345 Y162.339 I-1.853 J-1.584 E.05167
G3 X173.69 Y162.227 I-.249 J-.514 E.02353
G1 X173.035 Y161.074 E.04399
G2 X171.724 Y160.282 I-1.853 J1.584 E.05167
G2 X171.069 Y160.393 I-.249 J.514 E.02353
G1 X170.764 Y160.93 E.02045
G1 X170.764 Y159.759 E.03883
G1 X171.069 Y159.607 E.0113
G1 X171.724 Y158.454 E.04399
G3 X173.035 Y157.661 I1.853 J1.584 E.05167
G3 X173.69 Y157.773 I.249 J.514 E.02353
G1 X174.345 Y158.926 E.04399
G2 X175.655 Y159.718 I1.853 J-1.584 E.05167
G2 X176.31 Y159.607 I.249 J-.514 E.02353
G1 X176.966 Y158.454 E.04399
G3 X178.276 Y157.661 I1.853 J1.584 E.05167
G3 X178.931 Y157.773 I.249 J.514 E.02353
G1 X179.236 Y158.309 E.02045
G1 X179.236 Y157.138 E.03883
G3 X178.805 Y156.764 I.064 J-.508 E.02005
G1 X175.097 Y156.764 E.123
G1 X174.345 Y157.098 E.02729
G3 X173.564 Y156.764 I-.211 J-.588 E.03098
G1 X171.936 Y156.764 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 12.6
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F8843.478
G1 X173.564 Y156.764 E-.61876
G1 X173.69 Y156.986 E-.09683
G1 X173.794 Y157.038 E-.04442
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 63/70
; update layer progress
M73 L63
M991 S0 P62 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z12.8 I-.912 J.806 P1  F60000
G1 X179.584 Y163.584 Z12.8
G1 Z12.6
G1 E.8 F1800
; FEATURE: Inner wall
G1 F1412
M204 S8000
G1 X170.416 Y163.584 E.30411
G1 X170.416 Y156.416 E.23776
G1 X179.584 Y156.416 E.30411
G1 X179.584 Y163.524 E.23577
; COOLING_NODE: 0
M204 S10000
G1 X179.991 Y163.991 F60000
G1 F1412
M204 S8000
G1 X170.009 Y163.991 E.33111
G1 X170.009 Y156.009 E.26477
G1 X179.991 Y156.009 E.33111
G1 X179.991 Y163.931 E.26278
; COOLING_NODE: 0
M204 S10000
G1 X180.398 Y164.398 F60000
G1 F1412
M204 S8000
G1 X169.602 Y164.398 E.35812
G1 X169.602 Y155.602 E.29178
G1 X180.398 Y155.602 E.35812
G1 X180.398 Y164.338 E.28979
; COOLING_NODE: 0
M204 S250
G1 X180.79 Y164.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
M73 P90 R1
G1 F1412
M204 S5000
G1 X169.21 Y164.79 E.35582
G1 X169.21 Y155.21 E.29437
G1 X180.79 Y155.21 E.35582
G1 X180.79 Y164.73 E.29252
;======== H2D 20260731========
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
G1 X178.79 Y164.74 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X179.029 Y163.236 Z13 F60000
G1 Z12.6
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F1412
M204 S8000
G1 X177.401 Y163.236 E.05401
G1 X178.255 Y162.621 E.03491
G1 X178.497 Y162.293 E.01351
G2 X177.897 Y160.655 I-2.115 J-.154 E.05963
G1 X176.987 Y160 E.0372
G1 X176.744 Y159.672 E.01351
G3 X177.345 Y158.035 I2.115 J-.154 E.05963
G1 X178.255 Y157.379 E.0372
G2 X178.525 Y156.764 I-.377 J-.532 E.0234
G1 X175.22 Y156.764 E.10961
G1 X174.366 Y157.379 E.03491
G1 X174.124 Y157.707 E.01351
G2 X174.724 Y159.345 I2.115 J.154 E.05963
G1 X175.634 Y160 E.0372
G1 X175.876 Y160.328 E.01351
G3 X175.276 Y161.966 I-2.115 J.154 E.05963
G1 X174.366 Y162.621 E.0372
G2 X174.096 Y163.236 I.377 J.532 E.0234
G1 X172.159 Y163.236 E.06425
G1 X173.013 Y162.621 E.03491
G1 X173.256 Y162.293 E.01351
G2 X172.655 Y160.655 I-2.115 J-.154 E.05963
G1 X171.745 Y160 E.0372
G1 X171.503 Y159.672 E.01351
G3 X172.103 Y158.035 I2.115 J-.154 E.05963
G1 X173.013 Y157.379 E.0372
G2 X173.283 Y156.764 I-.377 J-.532 E.0234
G1 X171.655 Y156.764 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 12.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F8843.478
G1 X173.283 Y156.764 E-.61876
G1 X173.256 Y157.052 E-.1097
G1 X173.206 Y157.119 E-.03155
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 64/70
; update layer progress
M73 L64
M991 S0 P63 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z13 I-.866 J.855 P1  F60000
G1 X179.584 Y163.584 Z13
G1 Z12.8
G1 E.8 F1800
; FEATURE: Inner wall
G1 F1399
M204 S8000
G1 X170.416 Y163.584 E.30411
G1 X170.416 Y156.416 E.23776
G1 X179.584 Y156.416 E.30411
G1 X179.584 Y163.524 E.23577
; COOLING_NODE: 0
M204 S10000
G1 X179.991 Y163.991 F60000
G1 F1399
M204 S8000
G1 X170.009 Y163.991 E.33111
G1 X170.009 Y156.009 E.26477
G1 X179.991 Y156.009 E.33111
G1 X179.991 Y163.931 E.26278
; COOLING_NODE: 0
M204 S10000
G1 X180.398 Y164.398 F60000
G1 F1399
M204 S8000
G1 X169.602 Y164.398 E.35812
G1 X169.602 Y155.602 E.29178
G1 X180.398 Y155.602 E.35812
G1 X180.398 Y164.338 E.28979
; COOLING_NODE: 0
M204 S250
M73 P91 R1
G1 X180.79 Y164.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1399
M204 S5000
G1 X169.21 Y164.79 E.35582
G1 X169.21 Y155.21 E.29437
G1 X180.79 Y155.21 E.35582
G1 X180.79 Y164.73 E.29252
;======== H2D 20260731========
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
G1 X178.79 Y164.74 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X178.931 Y163.236 Z13.2 F60000
G1 Z12.8
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F1399
M204 S8000
G1 X177.303 Y163.236 E.05401
G2 X178.221 Y162.293 I-3.82 J-4.641 E.04374
G2 X177.981 Y160.655 I-1.661 J-.593 E.05716
G3 X177.02 Y159.672 I3.981 J-4.852 E.04567
G3 X177.261 Y158.035 I1.661 J-.593 E.05716
G1 X177.946 Y157.379 E.03145
G2 X178.327 Y156.764 I-.66 J-.833 E.02447
G1 X175.318 Y156.764 E.09981
G2 X174.4 Y157.707 I3.82 J4.641 E.04374
G2 X174.64 Y159.345 I1.661 J.593 E.05716
G3 X175.601 Y160.328 I-3.981 J4.852 E.04567
G3 X175.36 Y161.966 I-1.661 J.593 E.05716
G1 X174.674 Y162.621 E.03145
G2 X174.294 Y163.236 I.66 J.833 E.02447
G1 X172.062 Y163.236 E.07406
G2 X172.98 Y162.293 I-3.819 J-4.64 E.04374
G2 X172.739 Y160.655 I-1.661 J-.593 E.05716
G3 X171.779 Y159.672 I3.982 J-4.853 E.04567
G3 X172.019 Y158.035 I1.661 J-.593 E.05716
G1 X172.705 Y157.379 E.03145
G2 X173.085 Y156.764 I-.66 J-.833 E.02447
G1 X171.457 Y156.764 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 13
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F8843.478
G1 X173.085 Y156.764 E-.61876
G1 X172.98 Y157.052 E-.1163
G1 X172.938 Y157.102 E-.02494
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 65/70
; update layer progress
M73 L65
M991 S0 P64 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z13.2 I-.85 J.871 P1  F60000
G1 X179.584 Y163.584 Z13.2
G1 Z13
G1 E.8 F1800
; FEATURE: Inner wall
G1 F1597
M204 S8000
G1 X170.416 Y163.584 E.30411
G1 X170.416 Y156.416 E.23776
G1 X179.584 Y156.416 E.30411
G1 X179.584 Y163.524 E.23577
; COOLING_NODE: 0
M204 S10000
G1 X179.991 Y163.991 F60000
G1 F1597
M204 S8000
G1 X170.009 Y163.991 E.33111
G1 X170.009 Y156.009 E.26477
G1 X179.991 Y156.009 E.33111
G1 X179.991 Y163.931 E.26278
; COOLING_NODE: 0
M204 S10000
G1 X180.398 Y164.398 F60000
G1 F1597
M204 S8000
G1 X169.602 Y164.398 E.35812
G1 X169.602 Y155.602 E.29178
G1 X180.398 Y155.602 E.35812
G1 X180.398 Y164.338 E.28979
; COOLING_NODE: 0
M204 S250
M73 P92 R1
G1 X180.79 Y164.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1597
M204 S5000
G1 X169.21 Y164.79 E.35582
G1 X169.21 Y155.21 E.29437
G1 X180.79 Y155.21 E.35582
G1 X180.79 Y164.73 E.29252
;======== H2D 20260731========
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
G1 X178.79 Y164.74 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X178.858 Y162.567 Z13.4 F60000
G1 Z13
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F1597
M204 S8000
G1 X178.858 Y162.858 E.00966
G1 X177.521 Y162.858 E.04435
G1 X177.725 Y162.621 E.01038
G2 X178.077 Y160.655 I-1.134 J-1.218 E.07104
G1 X177.517 Y160 E.0286
G3 X177.164 Y158.035 I1.134 J-1.218 E.07104
G2 X177.896 Y157.142 I-4.978 J-4.828 E.03835
G1 X175.099 Y157.142 E.09277
G1 X174.896 Y157.379 E.01038
G2 X174.543 Y159.345 I1.134 J1.218 E.07104
G1 X175.104 Y160 E.0286
G3 X175.457 Y161.966 I-1.134 J1.218 E.07104
G2 X174.725 Y162.858 I4.978 J4.828 E.03834
G1 X172.28 Y162.858 E.08109
G1 X172.483 Y162.621 E.01038
G2 X172.836 Y160.655 I-1.134 J-1.218 E.07104
G1 X172.275 Y160 E.0286
M73 P92 R0
G3 X171.923 Y158.035 I1.134 J-1.218 E.07104
G2 X172.655 Y157.142 I-4.978 J-4.828 E.03835
G1 X171.142 Y157.142 E.0502
G1 X171.142 Y157.257 E.00382
M204 S10000
G1 X179.062 Y156.779 F60000
; FEATURE: Floating vertical shell
; LINE_WIDTH: 0.383489
G1 F1597
M204 S8000
G1 X170.938 Y156.779 E.22545
G1 X170.806 Y156.806 E.00374
G1 X170.779 Y156.938 E.00374
G1 X170.779 Y163.062 E.16995
G1 X170.806 Y163.194 E.00374
G1 X170.938 Y163.221 E.00374
G1 X179.062 Y163.221 E.22545
G1 X179.194 Y163.194 E.00374
G1 X179.221 Y163.062 E.00374
G1 X179.221 Y156.938 E.16995
G1 X179.194 Y156.806 E.00374
G1 X179.121 Y156.791 E.00207
; CHANGE_LAYER
; Z_HEIGHT: 13.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F10570.558
G1 X179.194 Y156.806 E-.02837
G1 X179.221 Y156.938 E-.05117
G1 X179.221 Y158.729 E-.68045
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 66/70
; update layer progress
M73 L66
M991 S0 P65 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z13.4 I-1.214 J.091 P1  F60000
G1 X179.584 Y163.584 Z13.4
G1 Z13.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1742
M204 S8000
G1 X170.416 Y163.584 E.30411
G1 X170.416 Y156.416 E.23776
G1 X179.584 Y156.416 E.30411
G1 X179.584 Y163.524 E.23577
; COOLING_NODE: 0
M204 S10000
G1 X179.991 Y163.991 F60000
G1 F1742
M204 S8000
G1 X170.009 Y163.991 E.33111
G1 X170.009 Y156.009 E.26477
G1 X179.991 Y156.009 E.33111
G1 X179.991 Y163.931 E.26278
; COOLING_NODE: 0
M204 S10000
G1 X180.398 Y164.398 F60000
G1 F1742
M204 S8000
G1 X169.602 Y164.398 E.35812
M73 P93 R0
G1 X169.602 Y155.602 E.29178
G1 X180.398 Y155.602 E.35812
G1 X180.398 Y164.338 E.28979
; COOLING_NODE: 0
M204 S250
G1 X180.79 Y164.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1742
M204 S5000
G1 X169.21 Y164.79 E.35582
G1 X169.21 Y155.21 E.29437
G1 X180.79 Y155.21 E.35582
G1 X180.79 Y164.73 E.29252
;======== H2D 20260731========
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
G1 X178.79 Y164.74 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X178.4 Y157.118 Z13.6 F60000
G1 X178.373 Y156.583 Z13.6
G1 Z13.2
G1 E.8 F1800
; FEATURE: Bridge
; LINE_WIDTH: 0.40469
; LAYER_HEIGHT: 0.4
G1 F3000
M204 S8000
G1 X179.214 Y157.254 E.05638
G1 X179.214 Y157.836 E.03048
G1 X177.898 Y156.786 E.08824
G1 X177.168 Y156.786 E.03822
G1 X179.214 Y158.417 E.13712
G1 X179.214 Y158.999 E.03048
G1 X176.439 Y156.786 E.18601
G1 X175.71 Y156.786 E.03822
G1 X179.214 Y159.58 E.2349
G1 X179.214 Y160.162 E.03048
G1 X174.98 Y156.786 E.28378
G1 X174.251 Y156.786 E.03822
G1 X179.214 Y160.743 E.33267
G1 X179.214 Y161.325 E.03048
G1 X173.522 Y156.786 E.38155
G1 X172.792 Y156.786 E.03822
G1 X179.214 Y161.906 E.43044
G1 X179.214 Y162.488 E.03048
G1 X172.063 Y156.786 E.47932
G1 X171.334 Y156.786 E.03822
G1 X179.214 Y163.069 E.52821
G1 X179.214 Y163.214 E.00758
G1 X178.666 Y163.214 E.02872
G1 X170.786 Y156.931 E.52819
G1 X170.786 Y157.512 E.03048
G1 X177.937 Y163.214 E.47931
G1 X177.207 Y163.214 E.03822
G1 X170.786 Y158.094 E.43042
G1 X170.786 Y158.675 E.03048
G1 X176.478 Y163.214 E.38154
G1 X175.749 Y163.214 E.03822
G1 X170.786 Y159.257 E.33265
G1 X170.786 Y159.838 E.03048
G1 X175.019 Y163.214 E.28377
G1 X174.29 Y163.214 E.03822
G1 X170.786 Y160.42 E.23488
G1 X170.786 Y161.001 E.03048
G1 X173.561 Y163.214 E.186
G1 X172.831 Y163.214 E.03822
G1 X170.786 Y161.583 E.13711
G1 X170.786 Y162.165 E.03048
G1 X172.102 Y163.214 E.08822
G1 X171.373 Y163.214 E.03822
G1 X170.583 Y162.585 E.05291
; CHANGE_LAYER
; Z_HEIGHT: 13.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F3000
G1 X171.373 Y163.214 E-.38365
G1 X172.102 Y163.214 E-.27715
G1 X171.898 Y163.051 E-.09921
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 67/70
; update layer progress
M73 L67
M991 S0 P66 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z13.6 I-.084 J1.214 P1  F60000
G1 X179.584 Y163.584 Z13.6
G1 Z13.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2369
M204 S8000
G1 X170.416 Y163.584 E.30411
G1 X170.416 Y156.416 E.23776
G1 X179.584 Y156.416 E.30411
G1 X179.584 Y163.524 E.23577
; COOLING_NODE: 0
M204 S10000
G1 X179.991 Y163.991 F60000
G1 F2369
M204 S8000
G1 X170.009 Y163.991 E.33111
G1 X170.009 Y156.009 E.26477
G1 X179.991 Y156.009 E.33111
G1 X179.991 Y163.931 E.26278
; COOLING_NODE: 0
M204 S10000
G1 X180.398 Y164.398 F60000
G1 F2369
M204 S8000
G1 X169.602 Y164.398 E.35812
M73 P94 R0
G1 X169.602 Y155.602 E.29178
G1 X180.398 Y155.602 E.35812
G1 X180.398 Y164.338 E.28979
; COOLING_NODE: 0
M204 S250
G1 X180.79 Y164.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1897
M204 S5000
G1 X169.21 Y164.79 E.35582
G1 X169.21 Y155.21 E.29437
G1 X180.79 Y155.21 E.35582
G1 X180.79 Y164.73 E.29252
;======== H2D 20260731========
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
G1 X178.79 Y164.74 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X179.42 Y157.357 Z13.8 F60000
G1 Z13.4
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.4271
G1 F2369
M204 S8000
G1 X178.813 Y156.749 E.0269
G1 X178.269 Y156.749 E.01701
G1 X179.251 Y157.731 E.04344
G1 X179.251 Y158.274 E.01701
G1 X177.726 Y156.749 E.0675
G1 X177.183 Y156.749 E.01701
G1 X179.251 Y158.817 E.09155
G1 X179.251 Y159.361 E.01701
G1 X176.639 Y156.749 E.11561
G1 X176.096 Y156.749 E.01701
G1 X179.251 Y159.904 E.13966
G1 X179.251 Y160.447 E.01701
G1 X175.553 Y156.749 E.16372
G1 X175.009 Y156.749 E.01701
G1 X179.251 Y160.991 E.18777
G1 X179.251 Y161.534 E.01701
G1 X174.466 Y156.749 E.21182
G1 X173.923 Y156.749 E.01701
G1 X179.251 Y162.077 E.23588
G1 X179.251 Y162.621 E.01701
G1 X173.379 Y156.749 E.25993
G1 X172.836 Y156.749 E.01701
G1 X179.251 Y163.164 E.28399
G1 X179.251 Y163.251 E.00271
G1 X178.794 Y163.251 E.0143
G1 X172.293 Y156.749 E.28782
G1 X171.749 Y156.749 E.01701
G1 X178.251 Y163.251 E.28782
G1 X177.707 Y163.251 E.01701
G1 X171.206 Y156.749 E.28782
G1 X170.749 Y156.749 E.0143
G1 X170.749 Y156.836 E.00271
G1 X177.164 Y163.251 E.28399
G1 X176.621 Y163.251 E.01701
G1 X170.749 Y157.379 E.25994
G1 X170.749 Y157.923 E.01701
G1 X176.077 Y163.251 E.23588
G1 X175.534 Y163.251 E.01701
G1 X170.749 Y158.466 E.21183
G1 X170.749 Y159.009 E.01701
G1 X174.991 Y163.251 E.18777
G1 X174.447 Y163.251 E.01701
G1 X170.749 Y159.553 E.16372
G1 X170.749 Y160.096 E.01701
G1 X173.904 Y163.251 E.13966
G1 X173.361 Y163.251 E.01701
G1 X170.749 Y160.639 E.11561
G1 X170.749 Y161.183 E.01701
G1 X172.817 Y163.251 E.09156
G1 X172.274 Y163.251 E.01701
G1 X170.749 Y161.726 E.0675
G1 X170.749 Y162.269 E.01701
G1 X171.731 Y163.251 E.04345
G1 X171.188 Y163.251 E.01701
G1 X170.58 Y162.643 E.02691
; CHANGE_LAYER
; Z_HEIGHT: 13.6
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F9370.607
G1 X171.188 Y163.251 E-.3266
G1 X171.731 Y163.251 E-.20646
G1 X171.309 Y162.828 E-.22694
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 68/70
; update layer progress
M73 L68
M991 S0 P67 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z13.8 I-.111 J1.212 P1  F60000
G1 X179.584 Y163.584 Z13.8
G1 Z13.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2359
M204 S8000
G1 X170.416 Y163.584 E.30411
G1 X170.416 Y156.416 E.23776
G1 X179.584 Y156.416 E.30411
G1 X179.584 Y163.524 E.23577
; COOLING_NODE: 0
M204 S10000
G1 X179.991 Y163.991 F60000
G1 F2359
M204 S8000
G1 X170.009 Y163.991 E.33111
G1 X170.009 Y156.009 E.26477
G1 X179.991 Y156.009 E.33111
G1 X179.991 Y163.931 E.26278
; COOLING_NODE: 0
M204 S10000
M73 P95 R0
G1 X180.398 Y164.398 F60000
G1 F2359
M204 S8000
G1 X169.602 Y164.398 E.35812
G1 X169.602 Y155.602 E.29178
G1 X180.398 Y155.602 E.35812
G1 X180.398 Y164.338 E.28979
; COOLING_NODE: 0
M204 S250
G1 X180.79 Y164.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2009
M204 S5000
G1 X169.21 Y164.79 E.35582
G1 X169.21 Y155.21 E.29437
G1 X180.79 Y155.21 E.35582
G1 X180.79 Y164.73 E.29252
;======== H2D 20260731========
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
G1 X178.79 Y164.74 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X178.643 Y163.42 Z14 F60000
G1 Z13.6
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.4271
G1 F2359
M204 S8000
G1 X179.251 Y162.813 E.0269
G1 X179.251 Y162.269 E.01701
G1 X178.269 Y163.251 E.04345
G1 X177.726 Y163.251 E.01701
G1 X179.251 Y161.726 E.0675
G1 X179.251 Y161.183 E.01701
G1 X177.183 Y163.251 E.09155
G1 X176.639 Y163.251 E.01701
G1 X179.251 Y160.639 E.11561
G1 X179.251 Y160.096 E.01701
G1 X176.096 Y163.251 E.13966
G1 X175.553 Y163.251 E.01701
G1 X179.251 Y159.553 E.16372
G1 X179.251 Y159.009 E.01701
G1 X175.009 Y163.251 E.18777
G1 X174.466 Y163.251 E.01701
G1 X179.251 Y158.466 E.21182
G1 X179.251 Y157.923 E.01701
G1 X173.923 Y163.251 E.23588
G1 X173.379 Y163.251 E.01701
G1 X179.251 Y157.379 E.25993
G1 X179.251 Y156.836 E.01701
G1 X172.836 Y163.251 E.28399
G1 X172.293 Y163.251 E.01701
G1 X178.794 Y156.749 E.28782
G1 X178.251 Y156.749 E.01701
G1 X171.749 Y163.251 E.28782
G1 X171.206 Y163.251 E.01701
G1 X177.707 Y156.749 E.28782
G1 X177.164 Y156.749 E.01701
G1 X170.749 Y163.164 E.28399
G1 X170.749 Y162.621 E.01701
G1 X176.621 Y156.749 E.25994
G1 X176.077 Y156.749 E.01701
G1 X170.749 Y162.077 E.23588
G1 X170.749 Y161.534 E.01701
G1 X175.534 Y156.749 E.21183
G1 X174.991 Y156.749 E.01701
G1 X170.749 Y160.991 E.18777
G1 X170.749 Y160.447 E.01701
G1 X174.447 Y156.749 E.16372
G1 X173.904 Y156.749 E.01701
G1 X170.749 Y159.904 E.13966
G1 X170.749 Y159.361 E.01701
G1 X173.361 Y156.749 E.11561
G1 X172.817 Y156.749 E.01701
G1 X170.749 Y158.817 E.09156
G1 X170.749 Y158.274 E.01701
G1 X172.274 Y156.749 E.0675
G1 X171.731 Y156.749 E.01701
G1 X170.749 Y157.731 E.04345
G1 X170.749 Y157.188 E.01701
G1 X171.357 Y156.58 E.02691
; CHANGE_LAYER
; Z_HEIGHT: 13.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9370.607
G1 X170.749 Y157.188 E-.32659
G1 X170.749 Y157.731 E-.20646
G1 X171.172 Y157.309 E-.22695
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 69/70
; update layer progress
M73 L69
M991 S0 P68 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z14 I-.728 J.975 P1  F60000
G1 X179.584 Y163.584 Z14
G1 Z13.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2361
M204 S8000
G1 X170.416 Y163.584 E.30411
G1 X170.416 Y156.416 E.23776
G1 X179.584 Y156.416 E.30411
G1 X179.584 Y163.524 E.23577
; COOLING_NODE: 0
M204 S10000
M73 P96 R0
G1 X179.991 Y163.991 F60000
G1 F2361
M204 S8000
G1 X170.009 Y163.991 E.33111
G1 X170.009 Y156.009 E.26477
G1 X179.991 Y156.009 E.33111
G1 X179.991 Y163.931 E.26278
; COOLING_NODE: 0
M204 S10000
G1 X180.398 Y164.398 F60000
G1 F2361
M204 S8000
G1 X169.602 Y164.398 E.35812
G1 X169.602 Y155.602 E.29178
G1 X180.398 Y155.602 E.35812
G1 X180.398 Y164.338 E.28979
; COOLING_NODE: 0
M204 S250
G1 X180.79 Y164.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2097
M204 S5000
G1 X169.21 Y164.79 E.35582
G1 X169.21 Y155.21 E.29437
G1 X180.79 Y155.21 E.35582
G1 X180.79 Y164.73 E.29252
;======== H2D 20260731========
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
G1 X178.79 Y164.74 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X179.42 Y157.357 Z14.2 F60000
G1 Z13.8
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.4271
G1 F2361
M204 S8000
G1 X178.813 Y156.749 E.0269
G1 X178.269 Y156.749 E.01701
G1 X179.251 Y157.731 E.04344
G1 X179.251 Y158.274 E.01701
G1 X177.726 Y156.749 E.0675
G1 X177.183 Y156.749 E.01701
G1 X179.251 Y158.817 E.09155
G1 X179.251 Y159.361 E.01701
G1 X176.639 Y156.749 E.11561
G1 X176.096 Y156.749 E.01701
G1 X179.251 Y159.904 E.13966
G1 X179.251 Y160.447 E.01701
G1 X175.553 Y156.749 E.16372
G1 X175.009 Y156.749 E.01701
G1 X179.251 Y160.991 E.18777
G1 X179.251 Y161.534 E.01701
G1 X174.466 Y156.749 E.21182
G1 X173.923 Y156.749 E.01701
G1 X179.251 Y162.077 E.23588
G1 X179.251 Y162.621 E.01701
G1 X173.379 Y156.749 E.25993
G1 X172.836 Y156.749 E.01701
G1 X179.251 Y163.164 E.28399
G1 X179.251 Y163.251 E.00271
G1 X178.794 Y163.251 E.0143
G1 X172.293 Y156.749 E.28782
G1 X171.749 Y156.749 E.01701
G1 X178.251 Y163.251 E.28782
G1 X177.707 Y163.251 E.01701
G1 X171.206 Y156.749 E.28782
G1 X170.749 Y156.749 E.0143
G1 X170.749 Y156.836 E.00271
G1 X177.164 Y163.251 E.28399
G1 X176.621 Y163.251 E.01701
G1 X170.749 Y157.379 E.25994
G1 X170.749 Y157.923 E.01701
G1 X176.077 Y163.251 E.23588
G1 X175.534 Y163.251 E.01701
G1 X170.749 Y158.466 E.21183
G1 X170.749 Y159.009 E.01701
G1 X174.991 Y163.251 E.18777
M73 P97 R0
G1 X174.447 Y163.251 E.01701
G1 X170.749 Y159.553 E.16372
G1 X170.749 Y160.096 E.01701
G1 X173.904 Y163.251 E.13966
G1 X173.361 Y163.251 E.01701
G1 X170.749 Y160.639 E.11561
G1 X170.749 Y161.183 E.01701
G1 X172.817 Y163.251 E.09156
G1 X172.274 Y163.251 E.01701
G1 X170.749 Y161.726 E.0675
G1 X170.749 Y162.269 E.01701
G1 X171.731 Y163.251 E.04345
G1 X171.188 Y163.251 E.01701
G1 X170.58 Y162.643 E.02691
; CHANGE_LAYER
; Z_HEIGHT: 14
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9370.607
G1 X171.188 Y163.251 E-.3266
G1 X171.731 Y163.251 E-.20646
G1 X171.309 Y162.828 E-.22694
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 70/70
; update layer progress
M73 L70
M991 S0 P69 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z14.2 I-.247 J1.192 P1  F60000
G1 X180.79 Y164.79 Z14.2
G1 Z14
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2156
M204 S5000
G1 X169.21 Y164.79 E.35582
G1 X169.21 Y155.21 E.29437
G1 X180.79 Y155.21 E.35582
G1 X180.79 Y164.73 E.29252
;======== H2D 20260731========
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
G1 X178.79 Y164.74 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X180.583 Y163.749 Z14.4 F60000
G1 Z14
G1 E.8 F1800
; FEATURE: Top surface
G1 F2753
M204 S2000
G1 X179.749 Y164.583 E.03621
G1 X179.616 Y164.716
G1 X179.082 Y164.716
G1 X179.216 Y164.583
G1 X180.583 Y163.216 E.05938
G1 X180.716 Y163.082
G1 X180.716 Y162.549
G1 X180.583 Y162.683
G1 X178.683 Y164.583 E.08256
G1 X178.549 Y164.716
G1 X178.016 Y164.716
G1 X178.15 Y164.583
G1 X180.583 Y162.15 E.10573
G1 X180.716 Y162.016
G1 X180.716 Y161.483
G1 X180.583 Y161.616
G1 X177.616 Y164.583 E.1289
G1 X177.483 Y164.716
G1 X176.949 Y164.716
G1 X177.083 Y164.583
G1 X180.583 Y161.083 E.15207
G1 X180.716 Y160.949
G1 X180.716 Y160.416
G1 X180.583 Y160.55
G1 X176.55 Y164.583 E.17525
G1 X176.416 Y164.716
G1 X175.883 Y164.716
G1 X176.017 Y164.583
G1 X180.583 Y160.017 E.19842
G1 X180.716 Y159.883
G1 X180.716 Y159.35
G1 X180.583 Y159.483
G1 X175.483 Y164.583 E.22159
G1 X175.35 Y164.716
M73 P98 R0
G1 X174.816 Y164.716
G1 X174.95 Y164.583
G1 X180.583 Y158.95 E.24477
G1 X180.716 Y158.816
G1 X180.716 Y158.283
G1 X180.583 Y158.417
G1 X174.417 Y164.583 E.26794
G1 X174.283 Y164.716
G1 X173.75 Y164.716
G1 X173.883 Y164.583
G1 X180.583 Y157.883 E.29111
G1 X180.716 Y157.75
G1 X180.716 Y157.217
G1 X180.583 Y157.35
G1 X173.35 Y164.583 E.31428
G1 X173.217 Y164.716
G1 X172.683 Y164.716
G1 X172.817 Y164.583
G1 X180.583 Y156.817 E.33746
G1 X180.716 Y156.683
G1 X180.716 Y156.15
G1 X180.583 Y156.284
G1 X172.284 Y164.583 E.36063
G1 X172.15 Y164.716
G1 X171.617 Y164.716
G1 X171.75 Y164.583
G1 X180.583 Y155.75 E.3838
G1 X180.716 Y155.617
G1 X180.516 Y155.284
G1 X180.382 Y155.417
G1 X171.217 Y164.583 E.39828
G1 X171.084 Y164.716
G1 X170.55 Y164.716
G1 X170.684 Y164.583
G1 X179.849 Y155.417 E.39827
G1 X179.983 Y155.284
G1 X179.45 Y155.284
G1 X179.316 Y155.417
G1 X170.151 Y164.583 E.39827
G1 X170.017 Y164.716
G1 X169.484 Y164.716
G1 X169.617 Y164.583
G1 X178.783 Y155.417 E.39828
G1 X178.916 Y155.284
G1 X178.383 Y155.284
G1 X178.249 Y155.417
G1 X169.417 Y164.249 E.3838
G1 X169.284 Y164.383
G1 X169.284 Y163.85
G1 X169.417 Y163.716
G1 X177.716 Y155.417 E.36062
G1 X177.85 Y155.284
G1 X177.317 Y155.284
G1 X177.183 Y155.417
G1 X169.417 Y163.183 E.33745
G1 X169.284 Y163.317
G1 X169.284 Y162.783
G1 X169.417 Y162.65
G1 X176.65 Y155.417 E.31428
G1 X176.783 Y155.284
G1 X176.25 Y155.284
G1 X176.116 Y155.417
G1 X169.417 Y162.116 E.2911
G1 X169.284 Y162.25
G1 X169.284 Y161.717
G1 X169.417 Y161.583
G1 X175.583 Y155.417 E.26793
G1 X175.717 Y155.284
G1 X175.184 Y155.284
G1 X175.05 Y155.417
G1 X169.417 Y161.05 E.24476
G1 X169.284 Y161.184
G1 X169.284 Y160.65
G1 X169.417 Y160.517
G1 X174.517 Y155.417 E.22159
G1 X174.65 Y155.284
G1 X174.117 Y155.284
G1 X173.983 Y155.417
G1 X169.417 Y159.983 E.19841
G1 X169.284 Y160.117
G1 X169.284 Y159.584
G1 X169.417 Y159.45
G1 X173.45 Y155.417 E.17524
G1 X173.584 Y155.284
G1 X173.05 Y155.284
G1 X172.917 Y155.417
G1 X169.417 Y158.917 E.15207
G1 X169.284 Y159.05
G1 X169.284 Y158.517
G1 X169.417 Y158.384
G1 X172.384 Y155.417 E.1289
G1 X172.517 Y155.284
G1 X171.984 Y155.284
G1 X171.85 Y155.417
G1 X169.417 Y157.85 E.10572
G1 X169.284 Y157.984
G1 X169.284 Y157.451
G1 X169.417 Y157.317
G1 X171.317 Y155.417 E.08255
G1 X171.451 Y155.284
G1 X170.917 Y155.284
G1 X170.784 Y155.417
G1 X169.417 Y156.784 E.05938
G1 X169.284 Y156.917
G1 X169.284 Y156.384
G1 X169.417 Y156.251
G1 X170.251 Y155.417 E.03621
; close powerlost recovery
M1003 S0
; WIPE_START
G1 F9547.055
M204 S8000
G1 X169.417 Y156.251 E-.44776
G1 X169.284 Y156.384 E-.07182
G1 X169.284 Y156.917 E-.20264
G1 X169.354 Y156.847 E-.03779
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z14.4 I1.217 J0 P1  F60000
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
G1 Z14.4 F900 ; lower z a little
M1002 judge_flag timelapse_record_flag
M622 J1
    G150.3
    M400 ; wait all motion done
    M991 S0 P-1 ;end smooth timelapse at safe pos
    M400 S5 ;wait for last picture to be taken
M623  ;end of "timelapse_record_flag"

G90
G1 Z24 F900 ; lower z a little

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

    
        G1 Z107 F600
        G1 Z105
    

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

