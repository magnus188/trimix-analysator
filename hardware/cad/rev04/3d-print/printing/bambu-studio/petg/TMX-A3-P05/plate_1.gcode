; HEADER_BLOCK_START
; BambuStudio 02.08.02.61
; model printing time: 2m 25s; total estimated time: 7m 52s
; total layer number: 32
; total filament length [mm] : 80.90
; total filament volume [cm^3] : 194.58
; total filament weight [g] : 0.25
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
M73 P0 R7
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
M73 P10 R7
G1 Z5 F1200
G90
G1 X175 Y160 F30000

M622 J1
    M1002 gcode_claim_action : 1
    G29.20 A3
    G29 A1 O X167.693 Y151.343 I14.6131 J17.3131 R
    M400
M623

M622 J2
    M1002 gcode_claim_action : 1
    
        G29.20 A4
        G29 A2 O X167.693 Y151.343 I14.6131 J17.3131 R
    
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
M73 P65 R2
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
M73 P66 R2
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
M73 P67 R2
G1 X168.872 Y152.724 F60000
M204 S6000
M73 P69 R2
G1 Z.4
G1 Z.2
G1 E.8 F1800
; FEATURE: Brim
; LINE_WIDTH: 0.5
G1 F2567
M204 S500
G1 X169.288 Y152.34 E.02045
G1 X169.763 Y152.028 E.02053
G1 X170.144 Y151.85 E.01517
G1 X170.788 Y151.648 E.02439
G1 X171.512 Y151.572 E.02627
G1 X178.491 Y151.572 E.25197
G1 X179.06 Y151.619 E.02062
G1 X179.971 Y151.902 E.03446
G1 X180.478 Y152.175 E.02079
G1 X180.926 Y152.522 E.02045
G1 X181.31 Y152.938 E.02045
G1 X181.622 Y153.412 E.02048
G1 X181.839 Y153.893 E.01907
G1 X182.002 Y154.437 E.0205
G1 X182.078 Y155.162 E.02632
G1 X182.078 Y163.141 E.28807
G1 X182.031 Y163.71 E.02062
G1 X181.748 Y164.621 E.03446
G1 X181.475 Y165.128 E.02079
G1 X181.128 Y165.576 E.02045
G1 X180.712 Y165.96 E.02045
G1 X180.34 Y166.205 E.0161
G1 X180.263 Y166.288 E.00408
G1 X179.975 Y166.829 E.02211
G1 X179.628 Y167.276 E.02043
G1 X179.212 Y167.66 E.02045
G1 X178.738 Y167.972 E.02048
G1 X178.257 Y168.189 E.01907
G1 X177.713 Y168.352 E.0205
G1 X176.988 Y168.428 E.02632
G1 X173.009 Y168.428 E.14365
G1 X172.44 Y168.381 E.02062
G1 X171.529 Y168.098 E.03446
G1 X171.022 Y167.825 E.02079
G1 X170.574 Y167.478 E.02045
G1 X170.19 Y167.062 E.02045
G1 X169.878 Y166.587 E.02053
G1 X169.742 Y166.295 E.01162
G1 X169.643 Y166.191 E.0052
G1 X169.522 Y166.125 E.00497
G1 X169.074 Y165.778 E.02045
G1 X168.69 Y165.362 E.02045
G1 X168.378 Y164.887 E.02053
G1 X168.2 Y164.506 E.01517
G1 X167.998 Y163.862 E.02439
G1 X167.922 Y163.138 E.02627
G1 X167.922 Y155.159 E.28808
G1 X167.969 Y154.59 E.02062
G1 X168.252 Y153.679 E.03446
G1 X168.525 Y153.172 E.02079
G1 X168.835 Y152.771 E.01828
M204 S6000
G1 X169.196 Y153.051 F60000
G1 F2567
M204 S500
G1 X169.203 Y153.043 E.00039
G1 X169.562 Y152.709 E.0177
G1 X169.978 Y152.433 E.01802
G1 X170.301 Y152.281 E.01291
G1 X170.895 Y152.096 E.02246
G1 X171.543 Y152.029 E.02351
G1 X178.477 Y152.03 E.25037
G1 X178.986 Y152.075 E.01845
G1 X179.781 Y152.321 E.03004
G1 X180.218 Y152.554 E.01788
G1 X180.607 Y152.853 E.01771
G1 X180.941 Y153.212 E.0177
G1 X181.214 Y153.624 E.01784
G1 X181.406 Y154.045 E.01673
G1 X181.548 Y154.515 E.01771
G1 X181.621 Y155.193 E.02462
G1 X181.621 Y163.116 E.28606
G1 X181.575 Y163.636 E.01887
G1 X181.318 Y164.455 E.03099
G1 X181.084 Y164.887 E.01774
G1 X180.797 Y165.257 E.0169
G1 X180.438 Y165.591 E.0177
G1 X180.099 Y165.816 E.0147
G1 X179.929 Y165.978 E.00848
G1 X179.856 Y166.081 E.00455
G1 X179.583 Y166.588 E.02081
G1 X179.282 Y166.974 E.01766
G1 X178.921 Y167.305 E.0177
G1 X178.508 Y167.574 E.0178
G1 X178.088 Y167.762 E.01661
G1 X177.61 Y167.903 E.01798
G1 X176.957 Y167.971 E.0237
G1 X173.034 Y167.971 E.14164
G1 X172.514 Y167.925 E.01887
G1 X171.695 Y167.668 E.03099
G1 X171.263 Y167.434 E.01774
G1 X170.876 Y167.132 E.01771
G1 X170.545 Y166.771 E.0177
G1 X170.283 Y166.372 E.0172
G1 X170.161 Y166.112 E.01039
G1 X170.067 Y165.973 E.00605
G1 X169.984 Y165.886 E.00437
G1 X169.395 Y165.449 E.02645
G1 X169.059 Y165.088 E.01781
G1 X168.783 Y164.672 E.01802
G1 X168.631 Y164.349 E.01291
G1 X168.452 Y163.782 E.02148
G1 X168.379 Y163.107 E.02449
G1 X168.379 Y155.184 E.28607
G1 X168.425 Y154.664 E.01886
G1 X168.682 Y153.845 E.03099
G1 X168.916 Y153.413 E.01774
G1 X169.159 Y153.099 E.01434
M204 S6000
G1 X169.522 Y153.377 F60000
G1 F2567
M204 S500
G1 X169.535 Y153.361 E.00074
G1 X169.855 Y153.063 E.0158
G1 X170.194 Y152.838 E.01469
G1 X170.459 Y152.712 E.01059
G1 X171.001 Y152.545 E.02049
G1 X171.574 Y152.486 E.02077
G1 X178.451 Y152.487 E.24831
G1 X178.911 Y152.53 E.0167
G1 X179.592 Y152.741 E.02574
G1 X179.96 Y152.934 E.01499
G1 X180.289 Y153.185 E.01496
G1 X180.573 Y153.487 E.01496
G1 X180.807 Y153.837 E.01519
G1 X180.974 Y154.199 E.01438
G1 X181.095 Y154.594 E.01493
G1 X181.164 Y155.225 E.02291
G1 X181.164 Y163.09 E.28397
G1 X181.12 Y163.561 E.01709
G1 X180.889 Y164.288 E.02753
G1 X180.693 Y164.645 E.01472
G1 X180.45 Y164.955 E.01422
G1 X180.147 Y165.236 E.01491
G1 X179.778 Y165.491 E.01619
G1 X179.55 Y165.722 E.01174
G1 X179.45 Y165.87 E.00644
G1 X179.204 Y166.327 E.01875
G1 X178.937 Y166.67 E.01571
G1 X178.63 Y166.949 E.01496
G1 X178.278 Y167.176 E.01512
G1 X177.92 Y167.335 E.01415
G1 X177.508 Y167.454 E.01547
G1 X176.926 Y167.514 E.02113
G1 X173.06 Y167.514 E.13959
G1 X172.589 Y167.47 E.01709
G1 X171.862 Y167.239 E.02753
G1 X171.505 Y167.043 E.01469
G1 X171.18 Y166.787 E.01497
G1 X170.901 Y166.48 E.01498
G1 X170.688 Y166.156 E.01397
G1 X170.535 Y165.85 E.01238
G1 X170.394 Y165.655 E.00865
G1 X170.249 Y165.513 E.00736
G1 X169.711 Y165.114 E.02417
G1 X169.427 Y164.813 E.01496
G1 X169.188 Y164.456 E.0155
G1 X169.062 Y164.19 E.01063
G1 X168.9 Y163.674 E.01954
G1 X168.836 Y163.075 E.02173
G1 X168.836 Y155.21 E.28397
G1 X168.88 Y154.739 E.01709
G1 X169.111 Y154.012 E.02753
G1 X169.295 Y153.673 E.01392
M73 P70 R2
G1 X169.486 Y153.425 E.01131
M204 S6000
G1 X169.848 Y153.703 F60000
G1 F2567
M204 S500
G1 X169.867 Y153.679 E.00112
G1 X170.148 Y153.417 E.01386
G1 X170.412 Y153.242 E.01142
G1 X170.616 Y153.143 E.00821
G1 X171.106 Y152.993 E.0185
G1 X171.604 Y152.943 E.01806
G1 X178.423 Y152.944 E.2462
G1 X178.835 Y152.985 E.01495
G1 X179.405 Y153.162 E.02156
G1 X179.703 Y153.316 E.01212
G1 X179.973 Y153.519 E.0122
G1 X180.206 Y153.764 E.01222
G1 X180.401 Y154.052 E.01254
G1 X180.548 Y154.371 E.01269
G1 X180.646 Y154.7 E.01238
G1 X180.707 Y155.257 E.02026
G1 X180.707 Y163.062 E.28179
G1 X180.665 Y163.484 E.0153
G1 X180.461 Y164.119 E.02409
G1 X180.303 Y164.402 E.01168
G1 X180.105 Y164.652 E.01154
G1 X179.855 Y164.882 E.01227
G1 X179.445 Y165.178 E.01825
G1 X179.232 Y165.394 E.01096
G1 X179.074 Y165.611 E.00971
G1 X178.813 Y166.086 E.01954
G1 X178.592 Y166.366 E.0129
G1 X178.341 Y166.592 E.01218
G1 X178.05 Y166.777 E.01245
G1 X177.754 Y166.908 E.01169
G1 X177.409 Y167.005 E.01295
G1 X176.896 Y167.057 E.01861
G1 X173.088 Y167.057 E.13749
G1 X172.666 Y167.015 E.0153
G1 X172.031 Y166.811 E.02409
G1 X171.75 Y166.654 E.01163
G1 X171.485 Y166.443 E.01223
G1 X171.257 Y166.19 E.01229
G1 X171.083 Y165.923 E.01152
G1 X170.9 Y165.576 E.01415
G1 X170.707 Y165.323 E.0115
G1 X170.514 Y165.141 E.00956
G1 X170.026 Y164.778 E.02198
G1 X169.793 Y164.535 E.01213
G1 X169.592 Y164.238 E.01298
G1 X169.492 Y164.031 E.00828
G1 X169.348 Y163.567 E.01756
G1 X169.293 Y163.044 E.01899
G1 X169.293 Y155.238 E.28183
G1 X169.335 Y154.816 E.0153
G1 X169.54 Y154.18 E.02412
G1 X169.686 Y153.914 E.01096
G1 X169.812 Y153.751 E.00745
M204 S6000
G1 X170.167 Y154.06 F60000
G1 F2567
M204 S500
G1 X170.321 Y153.884 E.00847
G1 X170.42 Y153.8 E.0047
G1 X170.802 Y153.567 E.01613
G1 X171.029 Y153.487 E.0087
G1 X171.424 Y153.411 E.01452
G1 X178.67 Y153.419 E.26162
G1 X179.096 Y153.525 E.01585
G1 X179.494 Y153.74 E.01635
G1 X179.767 Y153.972 E.01293
G1 X179.85 Y154.07 E.00466
G1 X180.083 Y154.452 E.01613
G1 X180.163 Y154.678 E.00865
G1 X180.25 Y155.185 E.01859
G1 X180.25 Y163.122 E.28657
G1 X180.215 Y163.419 E.01081
G1 X180.065 Y163.878 E.01744
G1 X179.841 Y164.24 E.01537
G1 X179.585 Y164.499 E.01314
G1 X179.367 Y164.65 E.00958
G1 X179.162 Y164.753 E.00827
G1 X178.832 Y164.854 E.01248
G1 X178.737 Y164.961 E.00517
G1 X178.688 Y165.235 E.01003
G1 X178.568 Y165.572 E.01294
G1 X178.504 Y165.696 E.00501
G1 X178.31 Y165.976 E.0123
G1 X178.038 Y166.232 E.0135
G1 X177.702 Y166.432 E.01412
G1 X177.472 Y166.513 E.00879
G1 X176.965 Y166.6 E.01858
G1 X173.027 Y166.6 E.14218
G1 X172.439 Y166.488 E.02161
G1 X172.316 Y166.445 E.00471
G1 X172.08 Y166.316 E.00971
G1 X171.863 Y166.154 E.00978
G1 X171.617 Y165.888 E.01307
G1 X171.455 Y165.629 E.01105
G1 X171.365 Y165.419 E.00824
G1 X171.262 Y164.953 E.01723
G1 X171.173 Y164.853 E.00483
G1 X170.762 Y164.71 E.01573
G1 X170.373 Y164.459 E.01673
G1 X170.118 Y164.188 E.01342
G1 X169.918 Y163.852 E.01412
G1 X169.837 Y163.622 E.00879
G1 X169.75 Y163.115 E.01859
G1 X169.769 Y154.982 E.29363
G1 X169.838 Y154.669 E.01159
G1 X169.94 Y154.408 E.0101
G1 X170.099 Y154.138 E.01131
G1 X170.128 Y154.106 E.00157
M204 S6000
G1 X170.49 Y154.375 F60000
G1 F2567
M204 S500
G1 X170.662 Y154.188 E.00919
G1 X170.961 Y153.995 E.01284
G1 X171.105 Y153.938 E.00561
G1 X171.523 Y153.857 E.01536
G1 X178.571 Y153.865 E.25447
G1 X178.808 Y153.91 E.00871
G1 X178.961 Y153.962 E.00585
G1 X179.277 Y154.142 E.01314
G1 X179.462 Y154.312 E.00908
G1 X179.655 Y154.611 E.01284
G1 X179.712 Y154.755 E.00561
G1 X179.793 Y155.173 E.01536
G1 X179.793 Y163.13 E.28728
G1 X179.761 Y163.371 E.00878
G1 X179.633 Y163.731 E.01378
G1 X179.51 Y163.925 E.0083
G1 X179.334 Y164.116 E.00938
G1 X179.098 Y164.28 E.01038
G1 X178.966 Y164.341 E.00525
G1 X178.733 Y164.41 E.00877
G1 X178.418 Y164.436 E.0114
G1 X178.319 Y164.492 E.00413
G1 X178.293 Y164.572 E.00306
G1 X178.293 Y164.83 E.00929
G1 X178.261 Y165.071 E.00878
G1 X178.134 Y165.428 E.01368
G1 X177.927 Y165.727 E.01314
G1 X177.735 Y165.891 E.00911
G1 X177.542 Y166.004 E.00807
G1 X177.395 Y166.062 E.00572
G1 X176.977 Y166.143 E.01536
G1 X173.014 Y166.143 E.14307
G1 X172.527 Y166.039 E.01799
G1 X172.362 Y165.957 E.00667
G1 X172.127 Y165.781 E.0106
G1 X171.959 Y165.585 E.00931
G1 X171.846 Y165.392 E.00808
G1 X171.787 Y165.243 E.0058
G1 X171.721 Y164.953 E.01071
G1 X171.707 Y164.575 E.01368
G1 X171.656 Y164.473 E.00413
G1 X171.577 Y164.443 E.00304
G1 X171.432 Y164.436 E.00523
G1 X171.196 Y164.39 E.0087
G1 X170.918 Y164.281 E.01076
G1 X170.623 Y164.077 E.01297
G1 X170.459 Y163.885 E.00911
G1 X170.346 Y163.692 E.00808
G1 X170.288 Y163.545 E.00572
G1 X170.207 Y163.127 E.01536
G1 X170.215 Y155.079 E.29057
G1 X170.26 Y154.846 E.00858
G1 X170.37 Y154.565 E.01088
G1 X170.458 Y154.426 E.00597
M204 S6000
G1 X170.845 Y154.669 F60000
G1 F2567
M204 S500
G1 X170.883 Y154.608 E.00261
G1 X170.985 Y154.51 E.00513
G1 X171.198 Y154.385 E.0089
G1 X171.51 Y154.314 E.01155
G1 X178.489 Y154.314 E.25198
G1 X178.655 Y154.341 E.00607
G1 X178.83 Y154.4 E.00666
G1 X179.042 Y154.533 E.00905
G1 X179.14 Y154.635 E.00513
G1 X179.265 Y154.848 E.0089
G1 X179.336 Y155.16 E.01155
G1 X179.336 Y163.139 E.28808
G1 X179.309 Y163.305 E.00607
G1 X179.25 Y163.48 E.00666
G1 X179.117 Y163.692 E.00905
G1 X179.013 Y163.792 E.00523
G1 X178.845 Y163.9 E.00718
G1 X178.59 Y163.976 E.00963
G1 X177.971 Y163.986 E.02236
G1 X177.867 Y164.035 E.00413
G1 X177.836 Y164.123 E.00337
G1 X177.836 Y164.839 E.02586
G1 X177.809 Y165.005 E.00607
G1 X177.75 Y165.18 E.00666
G1 X177.617 Y165.392 E.00905
G1 X177.515 Y165.49 E.00513
G1 X177.302 Y165.615 E.0089
G1 X176.99 Y165.686 E.01155
G1 X173.007 Y165.686 E.1438
G1 X172.717 Y165.624 E.01072
G1 X172.628 Y165.586 E.00348
G1 X172.46 Y165.469 E.00739
G1 X172.36 Y165.365 E.00524
G1 X172.235 Y165.152 E.0089
G1 X172.164 Y164.84 E.01155
G1 X172.164 Y164.123 E.0259
G1 X172.117 Y164.019 E.00413
G1 X172.027 Y163.986 E.00344
G1 X171.511 Y163.986 E.01864
G1 X171.345 Y163.959 E.00607
G1 X171.17 Y163.901 E.00666
G1 X170.958 Y163.767 E.00905
G1 X170.86 Y163.665 E.00513
G1 X170.735 Y163.452 E.0089
G1 X170.664 Y163.14 E.01155
G1 X170.664 Y155.161 E.28809
G1 X170.691 Y154.995 E.00607
G1 X170.75 Y154.82 E.00666
G1 X170.813 Y154.72 E.00427
M204 S6000
M73 P71 R2
G1 X171.188 Y154.949 F60000
G1 F2567
M204 S500
G1 X171.314 Y154.827 E.00631
G1 X171.5 Y154.771 E.007
G1 X178.5 Y154.771 E.25274
G1 X178.701 Y154.838 E.00766
G1 X178.823 Y154.964 E.00631
G1 X178.879 Y155.15 E.007
G1 X178.879 Y163.15 E.28885
G1 X178.812 Y163.351 E.00766
G1 X178.686 Y163.473 E.00631
G1 X178.584 Y163.513 E.00396
G1 X178.5 Y163.529 E.00307
G1 X177.379 Y163.529 E.04049
G1 X177.379 Y164.85 E.04771
G1 X177.312 Y165.051 E.00766
G1 X177.186 Y165.173 E.00631
G1 X177 Y165.229 E.007
G1 X173 Y165.229 E.14442
G1 X172.909 Y165.209 E.00337
G1 X172.799 Y165.162 E.00433
G1 X172.677 Y165.036 E.00631
G1 X172.621 Y164.85 E.007
G1 X172.621 Y163.529 E.04771
G1 X171.5 Y163.529 E.04049
G1 X171.299 Y163.462 E.00766
G1 X171.177 Y163.336 E.00631
G1 X171.121 Y163.15 E.007
G1 X171.121 Y155.15 E.28885
G1 X171.169 Y155.006 E.00549
; WIPE_START
G1 F3000
G1 X171.314 Y154.827 E-.08729
G1 X171.5 Y154.771 E-.07367
G1 X173.076 Y154.771 E-.59903
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X176.16 Y161.753 Z.6 F60000
G1 X176.6 Y162.75 Z.6
G1 Z.2
G1 E.8 F1800
; FEATURE: Outer wall
G1 F2567
M204 S500
G1 X176.6 Y164.45 E.06138
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X173.4 Y164.45 E.11554
G1 X173.4 Y162.75 E.06138
G1 X171.9 Y162.75 E.05416
G1 X171.9 Y155.55 E.25996
G1 X178.1 Y155.55 E.22386
G1 X178.1 Y162.75 E.25996
G1 X176.66 Y162.75 E.05199
M204 S6000
G1 X176.143 Y162.293 F60000
; FEATURE: Inner wall
G1 F2567
M204 S500
G1 X176.143 Y163.993 E.06138
G1 X173.857 Y163.993 E.08253
G1 X173.857 Y162.293 E.06138
G1 X172.357 Y162.293 E.05416
G1 X172.357 Y156.007 E.22696
G1 X177.643 Y156.007 E.19085
G1 X177.643 Y162.293 E.22696
G1 X176.203 Y162.293 E.05199
; WIPE_START
G1 F3000
G1 X176.143 Y163.993 E-.6464
G1 X175.844 Y163.993 E-.1136
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X176.997 Y157.208 Z.6 F60000
G1 Z.2
G1 E.8 F1800
G1 F2567
M204 S500
G2 X176.442 Y156.654 I-1.734 J1.179 E.0285
G1 X176.503 Y156.464 E.00719
G1 X177.186 Y156.464 E.02465
G1 X177.186 Y157.147 E.02464
G1 X177.054 Y157.19 E.00502
; WIPE_START
G1 F3000
G1 X176.744 Y156.906 E-.15963
G1 X176.442 Y156.654 E-.1496
G1 X176.503 Y156.464 E-.07571
G1 X177.186 Y156.464 E-.25938
G1 X177.186 Y156.769 E-.11568
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X175.687 Y160.036 Z.6 F60000
G1 Z.2
G1 E.8 F1800
; FEATURE: Outer wall
G1 F2567
M204 S500
G1 X175.452 Y160.131 E.00918
G3 X174.837 Y157.108 I-.453 J-1.482 E.1865
G1 X174.992 Y157.1 E.00562
G3 X175.741 Y160.01 I.007 J1.55 E.14808
M204 S6000
G1 X175.861 Y160.457 F60000
; FEATURE: Inner wall
G1 F2567
M204 S500
G1 X175.584 Y160.569 E.0108
G3 X174.789 Y156.653 I-.586 J-1.92 E.24152
G1 X174.989 Y156.642 E.00726
G3 X175.942 Y160.42 I.009 J2.007 E.1925
G1 X175.916 Y160.432 E.00103
; WIPE_START
M73 P72 R2
G1 F3000
G1 X175.584 Y160.569 E-.13645
G1 X175.186 Y160.649 E-.1544
G1 X174.801 Y160.648 E-.14624
G1 X174.414 Y160.571 E-.14977
G1 X174.055 Y160.422 E-.14781
G1 X174 Y160.385 E-.02532
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X173.002 Y157.209 Z.6 F60000
G1 Z.2
G1 E.8 F1800
G1 F2567
M204 S500
G1 X172.814 Y157.147 E.00716
G1 X172.814 Y156.464 E.02464
G1 X173.498 Y156.464 E.02468
G1 X173.56 Y156.651 E.00713
G2 X173.04 Y157.162 I2.116 J2.677 E.02637
; WIPE_START
G1 F3000
G1 X172.814 Y157.147 E-.08607
G1 X172.814 Y156.464 E-.25935
G1 X173.498 Y156.464 E-.25978
G1 X173.56 Y156.651 E-.07503
G1 X173.4 Y156.787 E-.07977
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X176.035 Y160.878 Z.6 F60000
G1 Z.2
G1 E.8 F1800
G1 F2567
M204 S500
G1 X176.157 Y160.824 E.00481
G2 X176.998 Y160.091 I-1.159 J-2.178 E.04061
G1 X177.186 Y160.153 E.00716
G1 X177.186 Y161.836 E.06075
G1 X175.686 Y161.836 E.05416
G1 X175.686 Y163.536 E.06138
G1 X174.314 Y163.536 E.04953
G1 X174.314 Y161.836 E.06138
G1 X172.814 Y161.836 E.05416
G1 X172.814 Y160.152 E.06079
G1 X173.001 Y160.09 E.00713
G1 X173.107 Y160.23 E.00637
G2 X175.716 Y161.006 I1.891 J-1.584 E.10408
G1 X175.979 Y160.9 E.01025
; WIPE_START
G1 F3000
G1 X176.157 Y160.824 E-.07346
G1 X176.379 Y160.694 E-.0976
G1 X176.58 Y160.543 E-.09581
G1 X176.747 Y160.39 E-.0861
G1 X176.998 Y160.091 E-.14798
G1 X177.186 Y160.153 E-.07536
G1 X177.186 Y160.637 E-.18369
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X175.229 Y161.563 Z.6 F60000
G1 Z.2
G1 E.8 F1800
G1 F2567
M204 S500
G1 X175.229 Y163.079 E.05475
G1 X174.771 Y163.079 E.01652
G1 X174.771 Y161.562 E.05477
G1 X174.996 Y161.573 E.00813
G1 X175.169 Y161.565 E.00624
M204 S6000
G1 X175.457 Y161.461 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.390003
G1 F2567
M204 S500
G1 X175.644 Y161.438 E.00514
; LINE_WIDTH: 0.415161
G1 X175.83 Y161.415 E.00551
; LINE_WIDTH: 0.452262
G1 X175.976 Y161.39 E.00481
; LINE_WIDTH: 0.499701
G1 X176.104 Y161.368 E.00467
; LINE_WIDTH: 0.526346
G1 X176.957 Y161.199 E.03322
; WIPE_START
G1 F3000
G1 X176.104 Y161.368 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X177.167 Y159.906 Z.6 F60000
G1 Z.2
G1 E.8 F1800
; LINE_WIDTH: 0.407872
G1 F2567
M204 S500
G1 X177.234 Y159.574 E.00977
; LINE_WIDTH: 0.384817
G1 X177.253 Y159.463 E.00306
; LINE_WIDTH: 0.343176
G1 X177.275 Y159.336 E.00304
; LINE_WIDTH: 0.307661
G1 X177.289 Y159.221 E.00242
; LINE_WIDTH: 0.278139
G1 X177.304 Y159.096 E.00236
; LINE_WIDTH: 0.23656
G1 X177.326 Y158.648 E.00685
G1 X177.304 Y158.2 E.00686
; LINE_WIDTH: 0.276601
G1 X177.291 Y158.095 E.00195
; LINE_WIDTH: 0.303325
G1 X177.277 Y157.977 E.00245
; LINE_WIDTH: 0.336794
G1 X177.258 Y157.866 E.00262
; LINE_WIDTH: 0.391354
G2 X177.169 Y157.393 I-9.109 J1.475 E.01325
M204 S6000
G1 X176.957 Y156.8 F60000
; LINE_WIDTH: 0.103056
G1 F2567
M204 S500
G2 X176.851 Y156.693 I-.104 J-.004 E.0008
M204 S6000
G1 X176.258 Y156.48 F60000
; LINE_WIDTH: 0.394334
G1 F2567
M204 S500
G1 X175.89 Y156.41 E.01039
; LINE_WIDTH: 0.372324
G1 X175.778 Y156.391 E.00296
; LINE_WIDTH: 0.332664
G1 X175.653 Y156.37 E.0029
; LINE_WIDTH: 0.288008
G1 X175.448 Y156.346 E.004
; LINE_WIDTH: 0.237688
G1 X174.991 Y156.324 E.00703
G1 X174.521 Y156.349 E.00724
; LINE_WIDTH: 0.271035
G1 X174.51 Y156.35 E.0002
; LINE_WIDTH: 0.285138
G1 X174.408 Y156.363 E.00197
; LINE_WIDTH: 0.312902
G1 X174.293 Y156.378 E.00249
; LINE_WIDTH: 0.348009
G1 X174.181 Y156.398 E.00274
; LINE_WIDTH: 0.40486
G2 X173.745 Y156.483 I1.51 J8.892 E.01268
; WIPE_START
G1 F3000
G1 X174.181 Y156.398 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X172.833 Y157.394 Z.6 F60000
G1 Z.2
G1 E.8 F1800
; LINE_WIDTH: 0.407817
G1 F2567
M204 S500
G1 X172.766 Y157.726 E.00977
; LINE_WIDTH: 0.384784
G1 X172.747 Y157.837 E.00306
; LINE_WIDTH: 0.343182
G1 X172.725 Y157.964 E.00303
; LINE_WIDTH: 0.30768
G1 X172.711 Y158.079 E.00242
; LINE_WIDTH: 0.278144
G1 X172.696 Y158.204 E.00236
; LINE_WIDTH: 0.236658
G1 X172.674 Y158.65 E.00683
G1 X172.696 Y159.103 E.00694
; LINE_WIDTH: 0.278722
G1 X172.711 Y159.219 E.00218
; LINE_WIDTH: 0.308915
G1 X172.727 Y159.349 E.00275
; LINE_WIDTH: 0.343722
G1 X172.745 Y159.454 E.00254
; LINE_WIDTH: 0.396754
G2 X172.832 Y159.905 I9.509 J-1.592 E.01285
; WIPE_START
G1 F3000
G1 X172.745 Y159.454 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X173.043 Y161.197 Z.6 F60000
G1 Z.2
G1 E.8 F1800
; LINE_WIDTH: 0.533305
G1 F2567
M204 S500
G1 X173.879 Y161.365 E.03303
; LINE_WIDTH: 0.505053
G1 X174.013 Y161.388 E.00499
; LINE_WIDTH: 0.457885
G1 X174.148 Y161.412 E.00448
; LINE_WIDTH: 0.417131
G1 X174.355 Y161.438 E.00618
; LINE_WIDTH: 0.390139
G1 X174.543 Y161.461 E.00518
; CHANGE_LAYER
; Z_HEIGHT: 0.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F3000
G1 X174.355 Y161.438 E-.76
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
G3 Z.6 I-.285 J1.183 P1  F60000
G1 X175.584 Y161.734 Z.6
G1 Z.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X175.584 Y163.434 E.05467
G1 X174.416 Y163.434 E.03755
G1 X174.416 Y161.734 E.05467
G1 X172.916 Y161.734 E.04823
G1 X172.916 Y160.181 E.04995
G2 X174.807 Y161.211 I2.141 J-1.679 E.07118
G2 X177.084 Y160.162 I.181 J-2.603 E.08409
G1 X177.084 Y161.734 E.05055
G1 X175.644 Y161.734 E.04631
; WIPE_START
G1 F8843.478
G1 X175.584 Y163.434 E-.6464
G1 X175.285 Y163.434 E-.1136
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X177.084 Y157.12 Z.8 F60000
G1 Z.4
G1 E.8 F1800
G1 F1200
M204 S8000
G2 X176.513 Y156.566 I-3.21 J2.741 E.0256
G1 X177.084 Y156.566 E.01836
G1 X177.084 Y157.06 E.01586
; WIPE_START
G1 F8843.478
G1 X176.78 Y156.8 E-.16691
G1 X176.513 Y156.566 E-.14838
G1 X177.084 Y156.566 E-.23857
G1 X177.084 Y157.06 E-.20613
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.992 Y160.56 Z.8 F60000
G1 Z.4
G1 E.8 F1800
G1 F1200
M204 S8000
G1 X175.881 Y160.619 E.00405
G3 X174.771 Y156.502 I-.882 J-1.97 E.23998
G1 X174.974 Y156.49 E.00655
G3 X176.238 Y160.417 I.025 J2.159 E.17647
G1 X176.044 Y160.53 E.00721
M204 S10000
M73 P73 R2
G1 X175.791 Y160.207 F60000
G1 F1200
M204 S8000
G1 X175.714 Y160.248 E.00281
G3 X174.815 Y156.907 I-.715 J-1.599 E.1947
G1 X174.978 Y156.897 E.00528
G3 X176.004 Y160.084 I.021 J1.752 E.1432
G1 X175.843 Y160.177 E.00598
M204 S250
G1 X175.599 Y159.867 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X175.554 Y159.89 E.00151
G3 X174.857 Y157.297 I-.554 J-1.241 E.13995
G1 X174.983 Y157.29 E.00375
G3 X175.779 Y159.763 I.017 J1.359 E.10297
G1 X175.651 Y159.837 E.00443
; WIPE_START
G1 F9547.055
M204 S8000
G1 X175.554 Y159.89 E-.04207
G1 X175.306 Y159.975 E-.09948
G1 X175.025 Y160.01 E-.10769
G1 X174.765 Y159.99 E-.0991
G1 X174.513 Y159.92 E-.09912
G1 X174.279 Y159.804 E-.09941
G1 X174.056 Y159.629 E-.1077
G1 X173.886 Y159.43 E-.09938
G1 X173.878 Y159.416 E-.00604
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.916 Y157.138 Z.8 F60000
G1 Z.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X172.916 Y156.566 E.01839
G1 X173.474 Y156.566 E.01794
G1 X173.153 Y156.866 E.01414
G1 X172.956 Y157.093 E.00966
; WIPE_START
G1 F8843.478
G1 X172.916 Y156.566 E-.21978
G1 X173.474 Y156.566 E-.23222
G1 X173.153 Y156.866 E-.18302
G1 X172.956 Y157.093 E-.12499
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.991 Y162.141 Z.8 F60000
G1 Z.4
G1 E.8 F1800
G1 F1200
M204 S8000
G1 X175.991 Y163.841 E.05467
G1 X174.009 Y163.841 E.06373
G1 X174.009 Y162.141 E.05467
G1 X172.509 Y162.141 E.04823
G1 X172.509 Y156.159 E.19235
G1 X177.491 Y156.159 E.16019
G1 X177.491 Y162.141 E.19235
G1 X176.051 Y162.141 E.04631
M204 S10000
G1 X176.398 Y162.548 F60000
G1 F1200
M204 S8000
G1 X176.398 Y164.248 E.05467
G1 X173.602 Y164.248 E.08991
G1 X173.602 Y162.548 E.05467
G1 X172.102 Y162.548 E.04823
G1 X172.102 Y155.752 E.21853
G1 X177.898 Y155.752 E.18637
G1 X177.898 Y162.548 E.21853
G1 X176.458 Y162.548 E.04631
M204 S250
G1 X176.79 Y162.94 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X176.79 Y164.64 E.05064
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

M73 P74 R2
G1 X173.21 Y164.64 E.10664
G1 X173.21 Y162.94 E.05064
G1 X171.71 Y162.94 E.04468
G1 X171.71 Y155.36 E.22578
G1 X178.29 Y155.36 E.196
G1 X178.29 Y162.94 E.22578
G1 X176.85 Y162.94 E.04289
; WIPE_START
G1 F9547.055
M204 S8000
G1 X176.79 Y164.64 E-.6464
G1 X176.491 Y164.64 E-.1136
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X176.199 Y161.349 Z.8 F60000
G1 Z.4
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.409814
G1 F1200
M204 S8000
G1 X176.88 Y161.203 E.0202
M204 S10000
G1 X176.199 Y161.349 F60000
; LINE_WIDTH: 0.381156
G1 F1200
M204 S8000
G1 X176.067 Y161.374 E.00357
; LINE_WIDTH: 0.331586
G1 X175.936 Y161.398 E.00305
; LINE_WIDTH: 0.304754
G1 X175.924 Y161.4 E.00026
; LINE_WIDTH: 0.283423
G1 X175.785 Y161.42 E.00265
; LINE_WIDTH: 0.24354
G1 X175.638 Y161.44 E.00236
; LINE_WIDTH: 0.207375
G1 X175.38 Y161.463 E.00336
; WIPE_START
G1 F15000
G1 X175.638 Y161.44 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X173.401 Y161.249 Z.8 F60000
G1 Z.4
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.58236
G1 F1200
M204 S8000
G1 X173.568 Y161.285 E.00729
; LINE_WIDTH: 0.53804
G1 X173.735 Y161.32 E.00669
; LINE_WIDTH: 0.49372
G1 X173.903 Y161.355 E.00609
; LINE_WIDTH: 0.4494
G1 X174.07 Y161.39 E.00549
; LINE_WIDTH: 0.38961
G2 X174.632 Y161.46 I.577 J-2.338 E.01553
; LINE_WIDTH: 0.406532
G1 X174.678 Y161.5 E.00176
; LINE_WIDTH: 0.453756
G1 X174.724 Y161.541 E.00199
; LINE_WIDTH: 0.50098
G1 X174.77 Y161.581 E.00222
; LINE_WIDTH: 0.548204
G1 X174.817 Y161.621 E.00245
; LINE_WIDTH: 0.595428
G1 X174.863 Y161.662 E.00268
M204 S10000
G1 X174.908 Y161.701 F60000
; LINE_WIDTH: 0.594559
G1 F1200
M204 S8000
G1 X174.883 Y161.803 E.00455
; LINE_WIDTH: 0.545597
G1 X174.859 Y161.904 E.00414
; LINE_WIDTH: 0.496634
G1 X174.834 Y162.006 E.00374
; LINE_WIDTH: 0.42418
G1 X174.81 Y162.107 E.00314
G1 X174.81 Y163.04 E.0281
G1 X175.19 Y163.04 E.01145
G1 X175.19 Y161.968 E.03228
G1 X175.102 Y161.947 E.00273
; LINE_WIDTH: 0.44626
G1 X175.05 Y161.901 E.00221
; LINE_WIDTH: 0.4924
G1 X174.998 Y161.855 E.00246
; LINE_WIDTH: 0.53854
G1 X174.946 Y161.809 E.00272
; LINE_WIDTH: 0.575968
G1 X174.937 Y161.783 E.00114
; LINE_WIDTH: 0.604683
G1 X174.928 Y161.758 E.0012
; WIPE_START
G1 F6408.402
G1 X174.937 Y161.783 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.976 Y159.913 Z.8 F60000
G1 Z.4
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.106481
G1 F1200
M204 S8000
G1 X172.901 Y159.815 E.00062
; LINE_WIDTH: 0.132023
G1 X172.841 Y159.729 E.00074
; LINE_WIDTH: 0.165157
G3 X172.776 Y159.622 I.108 J-.138 E.00124
; LINE_WIDTH: 0.151328
G1 X172.755 Y159.51 E.00097
; LINE_WIDTH: 0.115063
G1 X172.735 Y159.399 E.00065
; WIPE_START
G1 F15000
G1 X172.755 Y159.51 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.735 Y157.904 Z.8 F60000
G1 Z.4
G1 E.8 F1800
; LINE_WIDTH: 0.12179
G1 F1200
M204 S8000
G3 X172.791 Y157.592 I6.089 J.93 E.00197
M204 S10000
G1 X172.86 Y157.566 F60000
; LINE_WIDTH: 0.13663
G1 F1200
M204 S8000
G1 X172.713 Y157.797 E.00203
M204 S10000
G1 X172.86 Y157.566 F60000
; LINE_WIDTH: 0.104424
G1 F1200
M204 S8000
G1 X172.92 Y157.481 E.0005
; WIPE_START
G1 F15000
G1 X172.86 Y157.566 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X173.759 Y156.613 Z.8 F60000
G1 Z.4
G1 E.8 F1800
; LINE_WIDTH: 0.116122
G1 F1200
M204 S8000
G1 X173.928 Y156.49 E.00121
; LINE_WIDTH: 0.159357
G1 X174.017 Y156.429 E.00099
; LINE_WIDTH: 0.15005
G1 X174.151 Y156.403 E.00116
; LINE_WIDTH: 0.112638
G1 X174.252 Y156.385 E.00056
; WIPE_START
G1 F15000
G1 X174.151 Y156.403 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.744 Y156.385 Z.8 F60000
G1 Z.4
G1 E.8 F1800
; LINE_WIDTH: 0.118037
G1 F1200
M204 S8000
G1 X175.897 Y156.411 E.00092
; LINE_WIDTH: 0.139418
G1 X175.948 Y156.422 E.0004
G1 X176.092 Y156.515 E.00131
; LINE_WIDTH: 0.103977
G1 X176.174 Y156.574 E.00049
; WIPE_START
G1 F15000
G1 X176.092 Y156.515 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X177.024 Y157.388 Z.8 F60000
G1 Z.4
G1 E.8 F1800
; LINE_WIDTH: 0.106074
G1 F1200
M204 S8000
G1 X177.097 Y157.481 E.00059
; LINE_WIDTH: 0.131293
G1 X177.159 Y157.571 E.00076
; LINE_WIDTH: 0.163218
G1 X177.219 Y157.657 E.001
; LINE_WIDTH: 0.15495
G1 X177.245 Y157.79 E.00119
; LINE_WIDTH: 0.115078
G1 X177.265 Y157.901 E.00065
; WIPE_START
G1 F15000
G1 X177.245 Y157.79 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X177.265 Y159.395 Z.8 F60000
G1 Z.4
G1 E.8 F1800
; LINE_WIDTH: 0.12015
G1 F1200
M204 S8000
G3 X177.21 Y159.706 I-5.988 J-.889 E.00193
M204 S10000
G1 X177.139 Y159.736 F60000
; LINE_WIDTH: 0.104408
G1 F1200
M204 S8000
G1 X177.08 Y159.819 E.00049
M204 S10000
G1 X177.139 Y159.736 F60000
; LINE_WIDTH: 0.136566
G1 F1200
M204 S8000
G1 X177.287 Y159.503 E.00205
; CHANGE_LAYER
; Z_HEIGHT: 0.6
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F15000
G1 X177.139 Y159.736 E-.76
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
M73 P74 R1
G3 Z.8 I-.96 J-.747 P1  F60000
G1 X175.584 Y161.734 Z.8
G1 Z.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X175.584 Y163.434 E.05467
G1 X174.416 Y163.434 E.03755
G1 X174.416 Y161.734 E.05467
G1 X172.916 Y161.734 E.04823
G1 X172.916 Y160.173 E.0502
G2 X177.084 Y160.169 I2.082 J-1.582 E.15508
G1 X177.084 Y161.734 E.05033
G1 X175.644 Y161.734 E.04631
; COOLING_NODE: 0
; WIPE_START
G1 F8843.478
G1 X175.584 Y163.434 E-.6464
G1 X175.285 Y163.434 E-.1136
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X177.084 Y157.132 Z1 F60000
G1 Z.6
G1 E.8 F1800
G1 F1200
M204 S8000
G2 X176.518 Y156.566 I-2.971 J2.406 E.02576
G1 X177.084 Y156.566 E.01818
G1 X177.084 Y157.072 E.01625
; COOLING_NODE: 0
; WIPE_START
G1 F8843.478
G1 X176.816 Y156.834 E-.14884
G1 X176.518 Y156.566 E-.16626
G1 X177.084 Y156.566 E-.23492
G1 X177.084 Y157.072 E-.20999
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.912 Y160.6 Z1 F60000
G1 Z.6
G1 E.8 F1800
G1 F1200
M204 S8000
M73 P75 R1
G1 X175.628 Y160.714 E.00985
G3 X174.772 Y156.502 I-.63 J-2.065 E.23141
G1 X174.988 Y156.49 E.00695
G3 X176.014 Y160.554 I.01 J2.159 E.18443
G1 X175.967 Y160.575 E.00165
; COOLING_NODE: 0
M204 S10000
G1 X175.757 Y160.225 F60000
G1 F1200
M204 S8000
G1 X175.51 Y160.325 E.00857
G3 X174.816 Y156.907 I-.511 J-1.675 E.18776
G1 X174.991 Y156.897 E.00565
G3 X175.822 Y160.195 I.008 J1.752 E.14965
G1 X175.812 Y160.2 E.00037
; COOLING_NODE: 0
M204 S250
G1 X175.608 Y159.864 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X175.397 Y159.949 E.00679
G3 X174.857 Y157.297 I-.397 J-1.3 E.13498
G1 X174.994 Y157.29 E.00407
G3 X175.661 Y159.837 I.006 J1.359 E.1068
; COOLING_NODE: 0
; WIPE_START
G1 F9547.055
M204 S8000
G1 X175.397 Y159.949 E-.10927
G1 X175.125 Y160.004 E-.10539
G1 X174.864 Y160.003 E-.09909
G1 X174.603 Y159.951 E-.10125
G1 X174.361 Y159.851 E-.09952
G1 X174.126 Y159.692 E-.10772
G1 X173.957 Y159.524 E-.09061
G1 X173.888 Y159.421 E-.04717
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.916 Y157.131 Z1 F60000
G1 Z.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X172.916 Y156.566 E.01818
G1 X173.477 Y156.566 E.01804
G1 X173.18 Y156.839 E.01296
G1 X172.956 Y157.087 E.01075
; COOLING_NODE: 0
; WIPE_START
G1 F8843.478
G1 X172.916 Y156.566 E-.21797
G1 X173.477 Y156.566 E-.23423
G1 X173.18 Y156.839 E-.16828
G1 X172.956 Y157.087 E-.13952
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.991 Y162.141 Z1 F60000
G1 Z.6
G1 E.8 F1800
G1 F1200
M204 S8000
G1 X175.991 Y163.841 E.05467
G1 X174.009 Y163.841 E.06373
G1 X174.009 Y162.141 E.05467
G1 X172.509 Y162.141 E.04823
G1 X172.509 Y156.159 E.19235
G1 X177.491 Y156.159 E.16019
G1 X177.491 Y162.141 E.19235
G1 X176.051 Y162.141 E.04631
; COOLING_NODE: 0
M204 S10000
G1 X176.398 Y162.548 F60000
G1 F1200
M204 S8000
G1 X176.398 Y164.248 E.05467
G1 X173.602 Y164.248 E.08991
G1 X173.602 Y162.548 E.05467
G1 X172.102 Y162.548 E.04823
G1 X172.102 Y155.752 E.21853
G1 X177.898 Y155.752 E.18637
G1 X177.898 Y162.548 E.21853
G1 X176.458 Y162.548 E.04631
; COOLING_NODE: 1
M204 S250
G1 X176.79 Y162.94 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
M73 P76 R1
G1 X176.79 Y164.64 E.05064
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X173.21 Y164.64 E.10664
G1 X173.21 Y162.94 E.05064
G1 X171.71 Y162.94 E.04468
G1 X171.71 Y155.36 E.22578
G1 X178.29 Y155.36 E.196
G1 X178.29 Y162.94 E.22578
G1 X176.85 Y162.94 E.04289
; WIPE_START
G1 F9547.055
M204 S8000
G1 X176.79 Y164.64 E-.6464
G1 X176.491 Y164.64 E-.1136
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X176.88 Y161.214 Z1 F60000
G1 Z.6
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.372048
G1 F1200
M204 S8000
G1 X176.108 Y161.367 E.02048
; LINE_WIDTH: 0.346204
G1 X175.976 Y161.39 E.00319
; LINE_WIDTH: 0.298763
G1 X175.834 Y161.414 E.00293
; LINE_WIDTH: 0.257141
G1 X175.691 Y161.432 E.00242
; LINE_WIDTH: 0.208798
G1 X175.38 Y161.462 E.0041
M204 S10000
G1 X175 Y161.591 F60000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.43287
G1 F1200
M204 S8000
G1 X174.999 Y161.77 E.00552
M204 S10000
G1 X174.999 Y161.83 F60000
; LINE_WIDTH: 0.474058
G1 F1200
M204 S8000
G1 X174.964 Y161.91 E.00299
; LINE_WIDTH: 0.530061
G1 X174.928 Y161.991 E.00338
G1 X174.867 Y162.005 E.0024
G1 X174.865 Y162.112 E.0041
; LINE_WIDTH: 0.515115
G1 X174.847 Y162.151 E.0016
; LINE_WIDTH: 0.478345
G1 X174.828 Y162.189 E.00147
; LINE_WIDTH: 0.423575
G1 X174.81 Y162.228 E.00129
G1 X174.81 Y163.04 E.02442
G1 X175.19 Y163.04 E.01143
G1 X175.19 Y162.228 E.02442
; LINE_WIDTH: 0.441575
G1 X175.172 Y162.156 E.00234
; LINE_WIDTH: 0.478345
G1 X175.153 Y162.084 E.00256
; LINE_WIDTH: 0.525608
G1 X175.135 Y162.012 E.00283
G1 X175.062 Y161.994 E.00287
; LINE_WIDTH: 0.516973
G1 X175.041 Y161.94 E.00217
; LINE_WIDTH: 0.474058
G1 X175.02 Y161.886 E.00197
M204 S10000
G1 X174.62 Y161.462 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.197889
G1 F1200
M204 S8000
G1 X174.447 Y161.449 E.00212
; LINE_WIDTH: 0.223118
G1 X174.305 Y161.431 E.00203
; LINE_WIDTH: 0.259379
G1 X174.152 Y161.412 E.00265
; LINE_WIDTH: 0.303058
G1 X174.013 Y161.388 E.00288
; LINE_WIDTH: 0.351493
G1 X173.875 Y161.364 E.00342
; LINE_WIDTH: 0.378914
G1 X173.12 Y161.213 E.02045
; WIPE_START
G1 F10714.493
G1 X173.875 Y161.364 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.955 Y159.877 Z1 F60000
G1 Z.6
G1 E.8 F1800
; LINE_WIDTH: 0.106749
G1 F1200
M204 S8000
G1 X172.879 Y159.777 E.00063
; LINE_WIDTH: 0.130805
G1 X172.796 Y159.652 E.00104
; LINE_WIDTH: 0.158533
G1 X172.713 Y159.527 E.00137
M204 S10000
G1 X172.764 Y159.565 F60000
; LINE_WIDTH: 0.121648
G1 F1200
M204 S8000
G1 X172.735 Y159.396 E.00107
M204 S10000
G1 X172.764 Y159.565 F60000
; LINE_WIDTH: 0.147374
G1 F1200
M204 S8000
G1 X172.8 Y159.745 E.00151
; WIPE_START
G1 F15000
G1 X172.764 Y159.565 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.735 Y157.904 Z1 F60000
G1 Z.6
G1 E.8 F1800
; LINE_WIDTH: 0.110754
G1 F1200
M204 S8000
G1 X172.751 Y157.812 E.0005
; LINE_WIDTH: 0.138422
G1 X172.767 Y157.72 E.00071
; LINE_WIDTH: 0.154987
G3 X172.829 Y157.604 I.203 J.034 E.00118
; LINE_WIDTH: 0.124895
G1 X172.884 Y157.523 E.00063
; LINE_WIDTH: 0.103646
G1 X172.942 Y157.444 E.00047
; WIPE_START
G1 F15000
G1 X172.884 Y157.523 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X173.773 Y156.604 Z1 F60000
G1 Z.6
G1 E.8 F1800
; LINE_WIDTH: 0.116521
G1 F1200
M204 S8000
G1 X173.948 Y156.48 E.00125
; LINE_WIDTH: 0.157553
G1 X174.026 Y156.427 E.00085
; LINE_WIDTH: 0.146937
G1 X174.158 Y156.402 E.00111
; LINE_WIDTH: 0.111507
G1 X174.254 Y156.385 E.00053
; WIPE_START
G1 F15000
G1 X174.158 Y156.402 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.744 Y156.385 Z1 F60000
G1 Z.6
G1 E.8 F1800
; LINE_WIDTH: 0.129979
G1 F1200
M204 S8000
G3 X176.081 Y156.446 I-1.112 J7.113 E.00235
M204 S10000
G1 X176.094 Y156.511 F60000
; LINE_WIDTH: 0.144462
G1 F1200
M204 S8000
G1 X175.869 Y156.363 E.00216
M204 S10000
G1 X176.094 Y156.511 F60000
; LINE_WIDTH: 0.10869
G1 F1200
M204 S8000
G1 X176.208 Y156.593 E.00073
; WIPE_START
G1 F15000
G1 X176.094 Y156.511 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X177.059 Y157.445 Z1 F60000
G1 Z.6
G1 E.8 F1800
; LINE_WIDTH: 0.11743
G1 F1200
M204 S8000
G1 X177.204 Y157.655 E.0015
; LINE_WIDTH: 0.154236
G1 X177.287 Y157.781 E.00133
M204 S10000
G1 X177.265 Y157.906 F60000
; LINE_WIDTH: 0.131261
G1 F1200
M204 S8000
G2 X177.203 Y157.569 I-6.566 J1.024 E.00239
; WIPE_START
G1 F15000
G1 X177.265 Y157.906 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X177.265 Y159.396 Z1 F60000
G1 Z.6
G1 E.8 F1800
; LINE_WIDTH: 0.11077
G1 F1200
M204 S8000
G1 X177.249 Y159.488 E.0005
; LINE_WIDTH: 0.144308
G1 X177.225 Y159.615 E.00103
; LINE_WIDTH: 0.153344
G1 X177.171 Y159.696 E.00086
; LINE_WIDTH: 0.114297
G1 X177.058 Y159.857 E.00111
; CHANGE_LAYER
; Z_HEIGHT: 0.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F15000
G1 X177.171 Y159.696 E-.76
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
G3 Z1 I-.96 J-.748 P1  F60000
G1 X175.584 Y161.734 Z1
G1 Z.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X175.584 Y163.434 E.05467
G1 X174.416 Y163.434 E.03755
G1 X174.416 Y161.734 E.05467
G1 X172.916 Y161.734 E.04823
G1 X172.916 Y160.181 E.04995
G2 X174.807 Y161.211 I2.141 J-1.679 E.07118
G2 X177.084 Y160.162 I.181 J-2.603 E.08409
G1 X177.084 Y161.734 E.05055
G1 X175.644 Y161.734 E.04631
; COOLING_NODE: 0
; WIPE_START
G1 F8843.478
G1 X175.584 Y163.434 E-.6464
G1 X175.285 Y163.434 E-.1136
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X177.084 Y157.12 Z1.2 F60000
G1 Z.8
G1 E.8 F1800
G1 F1200
M204 S8000
G2 X176.513 Y156.566 I-3.21 J2.741 E.0256
G1 X177.084 Y156.566 E.01836
G1 X177.084 Y157.06 E.01586
; COOLING_NODE: 0
; WIPE_START
G1 F8843.478
G1 X176.78 Y156.8 E-.16691
G1 X176.513 Y156.566 E-.14838
G1 X177.084 Y156.566 E-.23857
G1 X177.084 Y157.06 E-.20613
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.988 Y160.562 Z1.2 F60000
G1 Z.8
G1 E.8 F1800
G1 F1200
M204 S8000
M73 P77 R1
G1 X175.881 Y160.619 E.0039
G3 X174.771 Y156.502 I-.882 J-1.97 E.23998
G1 X174.974 Y156.49 E.00655
G3 X176.238 Y160.417 I.025 J2.159 E.17647
G1 X176.04 Y160.532 E.00736
; COOLING_NODE: 0
M204 S10000
G1 X175.787 Y160.209 F60000
G1 F1200
M204 S8000
G1 X175.714 Y160.248 E.00266
G3 X174.815 Y156.907 I-.715 J-1.599 E.1947
G1 X174.978 Y156.897 E.00528
G3 X176.004 Y160.084 I.021 J1.752 E.1432
G1 X175.839 Y160.179 E.00613
; COOLING_NODE: 0
M204 S250
G1 X175.594 Y159.87 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X175.554 Y159.89 E.00137
G3 X174.857 Y157.297 I-.554 J-1.241 E.13995
G1 X174.983 Y157.29 E.00375
G3 X175.779 Y159.763 I.017 J1.359 E.10297
G1 X175.646 Y159.839 E.00457
; COOLING_NODE: 0
; WIPE_START
G1 F9547.055
M204 S8000
G1 X175.554 Y159.89 E-.04022
G1 X175.306 Y159.975 E-.09948
G1 X175.025 Y160.01 E-.10769
G1 X174.765 Y159.99 E-.0991
G1 X174.513 Y159.92 E-.09912
G1 X174.279 Y159.804 E-.09941
G1 X174.056 Y159.629 E-.1077
G1 X173.886 Y159.43 E-.09938
G1 X173.876 Y159.412 E-.00789
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.916 Y157.138 Z1.2 F60000
G1 Z.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X172.916 Y156.566 E.01839
G1 X173.474 Y156.566 E.01794
G1 X173.153 Y156.866 E.01414
G1 X172.956 Y157.093 E.00966
; COOLING_NODE: 0
; WIPE_START
G1 F8843.478
G1 X172.916 Y156.566 E-.21978
G1 X173.474 Y156.566 E-.23222
G1 X173.153 Y156.866 E-.18302
G1 X172.956 Y157.093 E-.12499
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.991 Y162.141 Z1.2 F60000
G1 Z.8
G1 E.8 F1800
G1 F1200
M204 S8000
G1 X175.991 Y163.841 E.05467
G1 X174.009 Y163.841 E.06373
G1 X174.009 Y162.141 E.05467
G1 X172.509 Y162.141 E.04823
G1 X172.509 Y156.159 E.19235
G1 X177.491 Y156.159 E.16019
G1 X177.491 Y162.141 E.19235
G1 X176.051 Y162.141 E.04631
; COOLING_NODE: 0
M204 S10000
G1 X176.398 Y162.548 F60000
G1 F1200
M204 S8000
G1 X176.398 Y164.248 E.05467
G1 X173.602 Y164.248 E.08991
G1 X173.602 Y162.548 E.05467
G1 X172.102 Y162.548 E.04823
G1 X172.102 Y155.752 E.21853
G1 X177.898 Y155.752 E.18637
G1 X177.898 Y162.548 E.21853
G1 X176.458 Y162.548 E.04631
; COOLING_NODE: 1
M204 S250
G1 X176.79 Y162.94 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
M73 P78 R1
G1 X176.79 Y164.64 E.05064
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X173.21 Y164.64 E.10664
G1 X173.21 Y162.94 E.05064
G1 X171.71 Y162.94 E.04468
G1 X171.71 Y155.36 E.22578
G1 X178.29 Y155.36 E.196
G1 X178.29 Y162.94 E.22578
G1 X176.85 Y162.94 E.04289
; WIPE_START
G1 F9547.055
M204 S8000
G1 X176.79 Y164.64 E-.6464
G1 X176.491 Y164.64 E-.1136
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X176.199 Y161.349 Z1.2 F60000
G1 Z.8
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.409814
G1 F1200
M204 S8000
G1 X176.88 Y161.203 E.0202
M204 S10000
G1 X176.199 Y161.349 F60000
; LINE_WIDTH: 0.381156
G1 F1200
M204 S8000
G1 X176.067 Y161.374 E.00357
; LINE_WIDTH: 0.331586
G1 X175.936 Y161.398 E.00305
; LINE_WIDTH: 0.304754
G1 X175.924 Y161.4 E.00026
; LINE_WIDTH: 0.283423
G1 X175.785 Y161.42 E.00265
; LINE_WIDTH: 0.24354
G1 X175.638 Y161.44 E.00236
; LINE_WIDTH: 0.207375
G1 X175.38 Y161.463 E.00336
; WIPE_START
G1 F15000
G1 X175.638 Y161.44 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X173.401 Y161.249 Z1.2 F60000
G1 Z.8
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.58236
G1 F1200
M204 S8000
G1 X173.568 Y161.285 E.00729
; LINE_WIDTH: 0.53804
G1 X173.735 Y161.32 E.00669
; LINE_WIDTH: 0.49372
G1 X173.903 Y161.355 E.00609
; LINE_WIDTH: 0.4494
G1 X174.07 Y161.39 E.00549
; LINE_WIDTH: 0.38961
G2 X174.632 Y161.46 I.577 J-2.338 E.01553
; LINE_WIDTH: 0.406532
G1 X174.678 Y161.5 E.00176
; LINE_WIDTH: 0.453756
G1 X174.724 Y161.541 E.00199
; LINE_WIDTH: 0.50098
G1 X174.77 Y161.581 E.00222
; LINE_WIDTH: 0.548204
G1 X174.817 Y161.621 E.00245
; LINE_WIDTH: 0.595428
G1 X174.863 Y161.662 E.00268
M204 S10000
G1 X174.908 Y161.701 F60000
; LINE_WIDTH: 0.594559
G1 F1200
M204 S8000
G1 X174.883 Y161.803 E.00455
; LINE_WIDTH: 0.545597
G1 X174.859 Y161.904 E.00414
; LINE_WIDTH: 0.496634
G1 X174.834 Y162.006 E.00374
; LINE_WIDTH: 0.42418
G1 X174.81 Y162.107 E.00314
G1 X174.81 Y163.04 E.0281
G1 X175.19 Y163.04 E.01145
G1 X175.19 Y161.968 E.03228
G1 X175.102 Y161.947 E.00273
; LINE_WIDTH: 0.44626
G1 X175.05 Y161.901 E.00221
; LINE_WIDTH: 0.4924
G1 X174.998 Y161.855 E.00246
; LINE_WIDTH: 0.53854
G1 X174.946 Y161.809 E.00272
; LINE_WIDTH: 0.575968
G1 X174.937 Y161.783 E.00114
; LINE_WIDTH: 0.604683
G1 X174.928 Y161.758 E.0012
; WIPE_START
G1 F6408.402
G1 X174.937 Y161.783 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.976 Y159.913 Z1.2 F60000
G1 Z.8
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.106481
G1 F1200
M204 S8000
G1 X172.901 Y159.815 E.00062
; LINE_WIDTH: 0.132023
G1 X172.841 Y159.729 E.00074
; LINE_WIDTH: 0.165157
G3 X172.776 Y159.622 I.108 J-.138 E.00124
; LINE_WIDTH: 0.151328
G1 X172.755 Y159.51 E.00097
; LINE_WIDTH: 0.115063
G1 X172.735 Y159.399 E.00065
; WIPE_START
G1 F15000
G1 X172.755 Y159.51 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.735 Y157.904 Z1.2 F60000
G1 Z.8
G1 E.8 F1800
; LINE_WIDTH: 0.12179
G1 F1200
M204 S8000
G3 X172.791 Y157.592 I6.089 J.93 E.00197
M204 S10000
G1 X172.86 Y157.566 F60000
; LINE_WIDTH: 0.13663
G1 F1200
M204 S8000
G1 X172.713 Y157.797 E.00203
M204 S10000
G1 X172.86 Y157.566 F60000
; LINE_WIDTH: 0.104424
G1 F1200
M204 S8000
G1 X172.92 Y157.481 E.0005
; WIPE_START
G1 F15000
G1 X172.86 Y157.566 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X173.759 Y156.613 Z1.2 F60000
G1 Z.8
G1 E.8 F1800
; LINE_WIDTH: 0.116122
G1 F1200
M204 S8000
G1 X173.928 Y156.49 E.00121
; LINE_WIDTH: 0.159357
G1 X174.017 Y156.429 E.00099
; LINE_WIDTH: 0.15005
G1 X174.151 Y156.403 E.00116
; LINE_WIDTH: 0.112638
G1 X174.252 Y156.385 E.00056
; WIPE_START
G1 F15000
G1 X174.151 Y156.403 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.744 Y156.385 Z1.2 F60000
G1 Z.8
G1 E.8 F1800
; LINE_WIDTH: 0.118037
G1 F1200
M204 S8000
G1 X175.897 Y156.411 E.00092
; LINE_WIDTH: 0.139418
G1 X175.948 Y156.422 E.0004
G1 X176.092 Y156.515 E.00131
; LINE_WIDTH: 0.103977
G1 X176.174 Y156.574 E.00049
; WIPE_START
G1 F15000
G1 X176.092 Y156.515 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X177.024 Y157.388 Z1.2 F60000
G1 Z.8
G1 E.8 F1800
; LINE_WIDTH: 0.106074
G1 F1200
M204 S8000
G1 X177.097 Y157.481 E.00059
; LINE_WIDTH: 0.131293
G1 X177.159 Y157.571 E.00076
; LINE_WIDTH: 0.163218
G1 X177.219 Y157.657 E.001
; LINE_WIDTH: 0.15495
G1 X177.245 Y157.79 E.00119
; LINE_WIDTH: 0.115078
G1 X177.265 Y157.901 E.00065
; WIPE_START
G1 F15000
G1 X177.245 Y157.79 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X177.265 Y159.395 Z1.2 F60000
G1 Z.8
G1 E.8 F1800
; LINE_WIDTH: 0.12015
G1 F1200
M204 S8000
G3 X177.21 Y159.706 I-5.988 J-.889 E.00193
M204 S10000
G1 X177.139 Y159.736 F60000
; LINE_WIDTH: 0.104408
G1 F1200
M204 S8000
G1 X177.08 Y159.819 E.00049
M204 S10000
G1 X177.139 Y159.736 F60000
; LINE_WIDTH: 0.136566
G1 F1200
M204 S8000
G1 X177.287 Y159.503 E.00205
; CHANGE_LAYER
; Z_HEIGHT: 1
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F15000
G1 X177.139 Y159.736 E-.76
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
G3 Z1.2 I-.96 J-.747 P1  F60000
G1 X175.584 Y161.734 Z1.2
G1 Z1
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X175.584 Y163.434 E.05467
G1 X174.416 Y163.434 E.03755
G1 X174.416 Y161.734 E.05467
G1 X172.916 Y161.734 E.04823
G1 X172.916 Y160.173 E.0502
G2 X177.084 Y160.169 I2.082 J-1.582 E.15508
G1 X177.084 Y161.734 E.05033
G1 X175.644 Y161.734 E.04631
; COOLING_NODE: 0
; WIPE_START
G1 F8843.478
G1 X175.584 Y163.434 E-.6464
G1 X175.285 Y163.434 E-.1136
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X177.084 Y157.132 Z1.4 F60000
G1 Z1
G1 E.8 F1800
G1 F1200
M204 S8000
G2 X176.518 Y156.566 I-2.971 J2.406 E.02576
G1 X177.084 Y156.566 E.01818
M73 P79 R1
G1 X177.084 Y157.072 E.01625
; COOLING_NODE: 0
; WIPE_START
G1 F8843.478
G1 X176.816 Y156.834 E-.14884
G1 X176.518 Y156.566 E-.16626
G1 X177.084 Y156.566 E-.23492
G1 X177.084 Y157.072 E-.20999
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.905 Y160.603 Z1.4 F60000
G1 Z1
G1 E.8 F1800
G1 F1200
M204 S8000
G1 X175.628 Y160.714 E.00961
G3 X174.772 Y156.502 I-.63 J-2.065 E.23141
G1 X174.988 Y156.49 E.00695
G3 X176.014 Y160.554 I.01 J2.159 E.18443
G1 X175.96 Y160.578 E.00189
; COOLING_NODE: 0
M204 S10000
G1 X175.75 Y160.228 F60000
G1 F1200
M204 S8000
G1 X175.51 Y160.325 E.00832
G3 X174.816 Y156.907 I-.511 J-1.675 E.18776
G1 X174.991 Y156.897 E.00565
G3 X175.822 Y160.195 I.008 J1.752 E.14965
G1 X175.805 Y160.203 E.00061
; COOLING_NODE: 0
M204 S250
G1 X175.601 Y159.867 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X175.397 Y159.949 E.00656
G3 X174.857 Y157.297 I-.397 J-1.3 E.13498
G1 X174.994 Y157.29 E.00407
G3 X175.655 Y159.84 I.006 J1.359 E.10702
; COOLING_NODE: 0
; WIPE_START
G1 F9547.055
M204 S8000
G1 X175.397 Y159.949 E-.1064
G1 X175.125 Y160.004 E-.10539
G1 X174.864 Y160.003 E-.09909
G1 X174.603 Y159.951 E-.10125
G1 X174.361 Y159.851 E-.09952
G1 X174.126 Y159.692 E-.10772
G1 X173.957 Y159.524 E-.09061
G1 X173.884 Y159.414 E-.05004
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.916 Y157.131 Z1.4 F60000
G1 Z1
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X172.916 Y156.566 E.01818
G1 X173.477 Y156.566 E.01804
G1 X173.18 Y156.839 E.01296
G1 X172.956 Y157.087 E.01075
; COOLING_NODE: 0
; WIPE_START
G1 F8843.478
G1 X172.916 Y156.566 E-.21797
G1 X173.477 Y156.566 E-.23423
G1 X173.18 Y156.839 E-.16828
G1 X172.956 Y157.087 E-.13952
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.991 Y162.141 Z1.4 F60000
G1 Z1
G1 E.8 F1800
G1 F1200
M204 S8000
G1 X175.991 Y163.841 E.05467
G1 X174.009 Y163.841 E.06373
G1 X174.009 Y162.141 E.05467
G1 X172.509 Y162.141 E.04823
G1 X172.509 Y156.159 E.19235
G1 X177.491 Y156.159 E.16019
G1 X177.491 Y162.141 E.19235
G1 X176.051 Y162.141 E.04631
; COOLING_NODE: 0
M204 S10000
G1 X176.398 Y162.548 F60000
G1 F1200
M204 S8000
G1 X176.398 Y164.248 E.05467
G1 X173.602 Y164.248 E.08991
G1 X173.602 Y162.548 E.05467
G1 X172.102 Y162.548 E.04823
G1 X172.102 Y155.752 E.21853
G1 X177.898 Y155.752 E.18637
G1 X177.898 Y162.548 E.21853
G1 X176.458 Y162.548 E.04631
; COOLING_NODE: 1
M204 S250
G1 X176.79 Y162.94 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
M73 P80 R1
G1 F1200
M204 S5000
G1 X176.79 Y164.64 E.05064
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X173.21 Y164.64 E.10664
G1 X173.21 Y162.94 E.05064
G1 X171.71 Y162.94 E.04468
G1 X171.71 Y155.36 E.22578
G1 X178.29 Y155.36 E.196
G1 X178.29 Y162.94 E.22578
G1 X176.85 Y162.94 E.04289
; WIPE_START
G1 F9547.055
M204 S8000
G1 X176.79 Y164.64 E-.6464
G1 X176.491 Y164.64 E-.1136
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X176.88 Y161.214 Z1.4 F60000
G1 Z1
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.372048
G1 F1200
M204 S8000
G1 X176.108 Y161.367 E.02048
; LINE_WIDTH: 0.346204
G1 X175.976 Y161.39 E.00319
; LINE_WIDTH: 0.298763
G1 X175.834 Y161.414 E.00293
; LINE_WIDTH: 0.257141
G1 X175.691 Y161.432 E.00242
; LINE_WIDTH: 0.208798
G1 X175.38 Y161.462 E.0041
M204 S10000
G1 X175 Y161.591 F60000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.43287
G1 F1200
M204 S8000
G1 X174.999 Y161.77 E.00552
M204 S10000
G1 X174.999 Y161.83 F60000
; LINE_WIDTH: 0.474058
G1 F1200
M204 S8000
G1 X174.964 Y161.91 E.00299
; LINE_WIDTH: 0.530061
G1 X174.928 Y161.991 E.00338
G1 X174.867 Y162.005 E.0024
G1 X174.865 Y162.112 E.0041
; LINE_WIDTH: 0.515115
G1 X174.847 Y162.151 E.0016
; LINE_WIDTH: 0.478345
G1 X174.828 Y162.189 E.00147
; LINE_WIDTH: 0.423575
G1 X174.81 Y162.228 E.00129
G1 X174.81 Y163.04 E.02442
G1 X175.19 Y163.04 E.01143
G1 X175.19 Y162.228 E.02442
; LINE_WIDTH: 0.441575
G1 X175.172 Y162.156 E.00234
; LINE_WIDTH: 0.478345
G1 X175.153 Y162.084 E.00256
; LINE_WIDTH: 0.525608
G1 X175.135 Y162.012 E.00283
G1 X175.062 Y161.994 E.00287
; LINE_WIDTH: 0.516973
G1 X175.041 Y161.94 E.00217
; LINE_WIDTH: 0.474058
G1 X175.02 Y161.886 E.00197
M204 S10000
G1 X174.62 Y161.462 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.197889
G1 F1200
M204 S8000
G1 X174.447 Y161.449 E.00212
; LINE_WIDTH: 0.223118
G1 X174.305 Y161.431 E.00203
; LINE_WIDTH: 0.259379
G1 X174.152 Y161.412 E.00265
; LINE_WIDTH: 0.303058
G1 X174.013 Y161.388 E.00288
; LINE_WIDTH: 0.351493
G1 X173.875 Y161.364 E.00342
; LINE_WIDTH: 0.378914
G1 X173.12 Y161.213 E.02045
; WIPE_START
G1 F10714.493
G1 X173.875 Y161.364 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.955 Y159.877 Z1.4 F60000
G1 Z1
G1 E.8 F1800
; LINE_WIDTH: 0.106749
G1 F1200
M204 S8000
G1 X172.879 Y159.777 E.00063
; LINE_WIDTH: 0.130805
G1 X172.796 Y159.652 E.00104
; LINE_WIDTH: 0.158533
G1 X172.713 Y159.527 E.00137
M204 S10000
G1 X172.764 Y159.565 F60000
; LINE_WIDTH: 0.121648
G1 F1200
M204 S8000
G1 X172.735 Y159.396 E.00107
M204 S10000
G1 X172.764 Y159.565 F60000
; LINE_WIDTH: 0.147374
G1 F1200
M204 S8000
G1 X172.8 Y159.745 E.00151
; WIPE_START
G1 F15000
G1 X172.764 Y159.565 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.735 Y157.904 Z1.4 F60000
G1 Z1
G1 E.8 F1800
; LINE_WIDTH: 0.110754
G1 F1200
M204 S8000
G1 X172.751 Y157.812 E.0005
; LINE_WIDTH: 0.138422
G1 X172.767 Y157.72 E.00071
; LINE_WIDTH: 0.154987
G3 X172.829 Y157.604 I.203 J.034 E.00118
; LINE_WIDTH: 0.124895
G1 X172.884 Y157.523 E.00063
; LINE_WIDTH: 0.103646
G1 X172.942 Y157.444 E.00047
; WIPE_START
G1 F15000
G1 X172.884 Y157.523 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X173.773 Y156.604 Z1.4 F60000
G1 Z1
G1 E.8 F1800
; LINE_WIDTH: 0.116521
G1 F1200
M204 S8000
G1 X173.948 Y156.48 E.00125
; LINE_WIDTH: 0.157553
G1 X174.026 Y156.427 E.00085
; LINE_WIDTH: 0.146937
G1 X174.158 Y156.402 E.00111
; LINE_WIDTH: 0.111507
G1 X174.254 Y156.385 E.00053
; WIPE_START
G1 F15000
G1 X174.158 Y156.402 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.744 Y156.385 Z1.4 F60000
G1 Z1
G1 E.8 F1800
; LINE_WIDTH: 0.129979
G1 F1200
M204 S8000
G3 X176.081 Y156.446 I-1.112 J7.113 E.00235
M204 S10000
G1 X176.094 Y156.511 F60000
; LINE_WIDTH: 0.144462
G1 F1200
M204 S8000
G1 X175.869 Y156.363 E.00216
M204 S10000
G1 X176.094 Y156.511 F60000
; LINE_WIDTH: 0.10869
G1 F1200
M204 S8000
G1 X176.208 Y156.593 E.00073
; WIPE_START
G1 F15000
G1 X176.094 Y156.511 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X177.059 Y157.445 Z1.4 F60000
G1 Z1
G1 E.8 F1800
; LINE_WIDTH: 0.11743
G1 F1200
M204 S8000
G1 X177.204 Y157.655 E.0015
; LINE_WIDTH: 0.154236
G1 X177.287 Y157.781 E.00133
M204 S10000
G1 X177.265 Y157.906 F60000
; LINE_WIDTH: 0.131261
G1 F1200
M204 S8000
G2 X177.203 Y157.569 I-6.566 J1.024 E.00239
; WIPE_START
G1 F15000
G1 X177.265 Y157.906 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X177.265 Y159.396 Z1.4 F60000
G1 Z1
G1 E.8 F1800
; LINE_WIDTH: 0.11077
G1 F1200
M204 S8000
G1 X177.249 Y159.488 E.0005
; LINE_WIDTH: 0.144308
G1 X177.225 Y159.615 E.00103
; LINE_WIDTH: 0.153344
G1 X177.171 Y159.696 E.00086
; LINE_WIDTH: 0.114297
G1 X177.058 Y159.857 E.00111
; CHANGE_LAYER
; Z_HEIGHT: 1.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F15000
G1 X177.171 Y159.696 E-.76
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
G3 Z1.4 I-.96 J-.748 P1  F60000
G1 X175.584 Y161.734 Z1.4
G1 Z1.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X175.584 Y163.434 E.05467
G1 X174.416 Y163.434 E.03755
G1 X174.416 Y161.734 E.05467
G1 X172.916 Y161.734 E.04823
G1 X172.916 Y160.181 E.04995
G2 X174.807 Y161.211 I2.141 J-1.679 E.07118
G2 X177.084 Y160.162 I.182 J-2.601 E.08409
G1 X177.084 Y161.734 E.05054
G1 X175.644 Y161.734 E.04631
; COOLING_NODE: 0
; WIPE_START
G1 F8843.478
G1 X175.584 Y163.434 E-.6464
G1 X175.285 Y163.434 E-.1136
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X177.084 Y157.12 Z1.6 F60000
G1 Z1.2
G1 E.8 F1800
G1 F1200
M204 S8000
G2 X176.513 Y156.566 I-3.21 J2.741 E.0256
M73 P81 R1
G1 X177.084 Y156.566 E.01836
G1 X177.084 Y157.06 E.01586
; COOLING_NODE: 0
; WIPE_START
G1 F8843.478
G1 X176.78 Y156.8 E-.16691
G1 X176.513 Y156.566 E-.14838
G1 X177.084 Y156.566 E-.23857
G1 X177.084 Y157.06 E-.20613
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.978 Y160.566 Z1.6 F60000
G1 Z1.2
G1 E.8 F1800
G1 F1200
M204 S8000
G1 X175.867 Y160.625 E.00406
G3 X174.771 Y156.502 I-.868 J-1.977 E.23948
G1 X174.974 Y156.49 E.00655
G3 X176.234 Y160.419 I.025 J2.159 E.17661
G1 X176.03 Y160.536 E.00755
; COOLING_NODE: 0
M204 S10000
G1 X175.78 Y160.212 F60000
G1 F1200
M204 S8000
G1 X175.704 Y160.253 E.00277
G3 X174.815 Y156.907 I-.705 J-1.604 E.19433
G1 X174.978 Y156.897 E.00528
G3 X176.002 Y160.085 I.021 J1.752 E.14329
G1 X175.832 Y160.183 E.00629
; COOLING_NODE: 0
M204 S250
G1 X175.589 Y159.872 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X175.547 Y159.893 E.00141
G3 X174.857 Y157.297 I-.547 J-1.244 E.13972
G1 X174.983 Y157.29 E.00375
G3 X175.778 Y159.763 I.017 J1.359 E.10299
G1 X175.641 Y159.842 E.00472
; COOLING_NODE: 0
; WIPE_START
G1 F9547.055
M204 S8000
G1 X175.547 Y159.893 E-.04084
G1 X175.284 Y159.98 E-.1053
G1 X175.025 Y160.01 E-.09902
G1 X174.765 Y159.99 E-.0991
G1 X174.513 Y159.92 E-.09912
G1 X174.279 Y159.804 E-.09941
G1 X174.056 Y159.629 E-.1077
G1 X173.886 Y159.43 E-.09938
G1 X173.873 Y159.407 E-.01013
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.916 Y157.138 Z1.6 F60000
G1 Z1.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X172.916 Y156.566 E.01839
G1 X173.474 Y156.566 E.01794
G1 X173.153 Y156.866 E.01414
G1 X172.956 Y157.093 E.00966
; COOLING_NODE: 0
; WIPE_START
G1 F8843.478
G1 X172.916 Y156.566 E-.21979
G1 X173.474 Y156.566 E-.23221
G1 X173.153 Y156.866 E-.18302
G1 X172.956 Y157.093 E-.12499
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.991 Y162.141 Z1.6 F60000
G1 Z1.2
G1 E.8 F1800
G1 F1200
M204 S8000
G1 X175.991 Y163.841 E.05467
G1 X174.009 Y163.841 E.06373
G1 X174.009 Y162.141 E.05467
G1 X172.509 Y162.141 E.04823
G1 X172.509 Y156.159 E.19235
G1 X177.491 Y156.159 E.16019
G1 X177.491 Y162.141 E.19235
G1 X176.051 Y162.141 E.04631
; COOLING_NODE: 0
M204 S10000
G1 X176.398 Y162.548 F60000
G1 F1200
M204 S8000
G1 X176.398 Y164.248 E.05467
G1 X173.602 Y164.248 E.08991
G1 X173.602 Y162.548 E.05467
G1 X172.102 Y162.548 E.04823
G1 X172.102 Y155.752 E.21853
G1 X177.898 Y155.752 E.18637
G1 X177.898 Y162.548 E.21853
G1 X176.458 Y162.548 E.04631
; COOLING_NODE: 1
M204 S250
G1 X176.79 Y162.94 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
M73 P82 R1
G1 F1200
M204 S5000
G1 X176.79 Y164.64 E.05064
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X173.21 Y164.64 E.10664
G1 X173.21 Y162.94 E.05064
G1 X171.71 Y162.94 E.04468
G1 X171.71 Y155.36 E.22578
G1 X178.29 Y155.36 E.196
G1 X178.29 Y162.94 E.22578
G1 X176.85 Y162.94 E.04289
; WIPE_START
G1 F9547.055
M204 S8000
G1 X176.79 Y164.64 E-.6464
G1 X176.491 Y164.64 E-.1136
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X176.176 Y161.353 Z1.6 F60000
G1 Z1.2
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.400191
G1 F1200
M204 S8000
G1 X176.88 Y161.206 E.0203
M204 S10000
G1 X176.176 Y161.353 F60000
; LINE_WIDTH: 0.379631
G1 F1200
M204 S8000
G1 X176.084 Y161.37 E.00249
; LINE_WIDTH: 0.345693
G1 X175.992 Y161.387 E.00224
; LINE_WIDTH: 0.309445
G1 X175.887 Y161.406 E.00224
; LINE_WIDTH: 0.27217
G1 X175.746 Y161.425 E.00257
; LINE_WIDTH: 0.233948
G1 X175.597 Y161.444 E.00227
; LINE_WIDTH: 0.202865
G1 X175.38 Y161.462 E.00274
; WIPE_START
G1 F15000
G1 X175.597 Y161.444 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X173.401 Y161.249 Z1.6 F60000
G1 Z1.2
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.58236
G1 F1200
M204 S8000
G1 X173.568 Y161.285 E.00729
; LINE_WIDTH: 0.53804
G1 X173.735 Y161.32 E.00669
; LINE_WIDTH: 0.49372
G1 X173.903 Y161.355 E.00609
; LINE_WIDTH: 0.4494
G1 X174.07 Y161.39 E.00549
; LINE_WIDTH: 0.38961
G2 X174.632 Y161.46 I.577 J-2.338 E.01553
; LINE_WIDTH: 0.406426
G1 X174.681 Y161.502 E.00187
; LINE_WIDTH: 0.453438
G1 X174.73 Y161.545 E.00211
; LINE_WIDTH: 0.50045
G1 X174.779 Y161.588 E.00235
; LINE_WIDTH: 0.547462
G1 X174.828 Y161.631 E.00259
; LINE_WIDTH: 0.594474
G1 X174.877 Y161.673 E.00284
M204 S10000
G1 X174.908 Y161.72 F60000
; LINE_WIDTH: 0.595084
G1 F1200
M204 S8000
G1 X174.884 Y161.816 E.00435
; LINE_WIDTH: 0.545972
G1 X174.859 Y161.913 E.00396
; LINE_WIDTH: 0.496859
G1 X174.834 Y162.009 E.00357
; LINE_WIDTH: 0.424202
G1 X174.81 Y162.106 E.003
G1 X174.81 Y163.04 E.02814
G1 X175.19 Y163.04 E.01145
G2 X175.19 Y161.966 I-150.211 J-.467 E.03235
G1 X175.101 Y161.944 E.00275
; LINE_WIDTH: 0.447304
G1 X175.049 Y161.898 E.00224
; LINE_WIDTH: 0.49351
G1 X174.996 Y161.851 E.0025
; LINE_WIDTH: 0.539717
G1 X174.944 Y161.805 E.00275
; LINE_WIDTH: 0.577025
G1 X174.937 Y161.79 E.00068
; LINE_WIDTH: 0.605435
G1 X174.931 Y161.775 E.00072
; WIPE_START
G1 F6399.83
G1 X174.937 Y161.79 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.976 Y159.913 Z1.6 F60000
G1 Z1.2
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.106481
G1 F1200
M204 S8000
G1 X172.901 Y159.815 E.00062
; LINE_WIDTH: 0.132023
G1 X172.841 Y159.729 E.00074
; LINE_WIDTH: 0.165157
G3 X172.776 Y159.622 I.108 J-.138 E.00124
; LINE_WIDTH: 0.151328
G1 X172.755 Y159.51 E.00097
; LINE_WIDTH: 0.115063
G1 X172.735 Y159.399 E.00065
; WIPE_START
G1 F15000
G1 X172.755 Y159.51 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.735 Y157.904 Z1.6 F60000
G1 Z1.2
G1 E.8 F1800
; LINE_WIDTH: 0.121788
G1 F1200
M204 S8000
G3 X172.791 Y157.592 I6.093 J.93 E.00197
M204 S10000
G1 X172.86 Y157.566 F60000
; LINE_WIDTH: 0.136594
G1 F1200
M204 S8000
G1 X172.713 Y157.798 E.00203
M204 S10000
G1 X172.86 Y157.566 F60000
; LINE_WIDTH: 0.104407
G1 F1200
M204 S8000
G1 X172.92 Y157.481 E.0005
; WIPE_START
G1 F15000
G1 X172.86 Y157.566 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X173.758 Y156.613 Z1.6 F60000
G1 Z1.2
G1 E.8 F1800
; LINE_WIDTH: 0.116139
G1 F1200
M204 S8000
G1 X173.928 Y156.49 E.00121
; LINE_WIDTH: 0.15939
G1 X174.017 Y156.429 E.00099
; LINE_WIDTH: 0.150184
G1 X174.151 Y156.403 E.00116
; LINE_WIDTH: 0.11272
G1 X174.252 Y156.385 E.00056
; WIPE_START
G1 F15000
G1 X174.151 Y156.403 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.744 Y156.385 Z1.6 F60000
G1 Z1.2
G1 E.8 F1800
; LINE_WIDTH: 0.118037
G1 F1200
M204 S8000
G1 X175.897 Y156.411 E.00092
; LINE_WIDTH: 0.139418
G1 X175.948 Y156.422 E.0004
G1 X176.092 Y156.515 E.00131
; LINE_WIDTH: 0.103977
G1 X176.174 Y156.574 E.00049
; WIPE_START
G1 F15000
G1 X176.092 Y156.515 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X177.024 Y157.388 Z1.6 F60000
G1 Z1.2
G1 E.8 F1800
; LINE_WIDTH: 0.106074
G1 F1200
M204 S8000
G1 X177.097 Y157.481 E.00059
; LINE_WIDTH: 0.131293
G1 X177.159 Y157.571 E.00076
; LINE_WIDTH: 0.163218
G1 X177.219 Y157.657 E.001
; LINE_WIDTH: 0.15495
G1 X177.245 Y157.79 E.00119
; LINE_WIDTH: 0.115078
G1 X177.265 Y157.901 E.00065
; WIPE_START
G1 F15000
G1 X177.245 Y157.79 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X177.265 Y159.395 Z1.6 F60000
G1 Z1.2
G1 E.8 F1800
; LINE_WIDTH: 0.120151
G1 F1200
M204 S8000
G3 X177.21 Y159.706 I-5.99 J-.89 E.00193
M204 S10000
G1 X177.139 Y159.736 F60000
; LINE_WIDTH: 0.104421
G1 F1200
M204 S8000
G1 X177.08 Y159.819 E.0005
M204 S10000
G1 X177.139 Y159.736 F60000
; LINE_WIDTH: 0.136595
G1 F1200
M204 S8000
G1 X177.287 Y159.503 E.00205
; CHANGE_LAYER
; Z_HEIGHT: 1.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F15000
G1 X177.139 Y159.736 E-.76
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
G3 Z1.6 I-.72 J-.981 P1  F60000
G1 X174.416 Y161.734 Z1.6
G1 Z1.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X172.916 Y161.734 E.04823
G1 X172.916 Y160.173 E.0502
G2 X177.084 Y160.169 I2.082 J-1.582 E.15508
G1 X177.084 Y161.734 E.05033
G1 X175.584 Y161.734 E.04823
G1 X175.584 Y163.434 E.05467
G1 X174.416 Y163.434 E.03755
G1 X174.416 Y161.794 E.05274
; COOLING_NODE: 0
; WIPE_START
G1 F8843.478
G1 X172.916 Y161.734 E-.57046
G1 X172.916 Y161.235 E-.18955
; WIPE_END
M73 P83 R1
G1 E-.04 F1800
M204 S10000
G1 X177.084 Y157.132 Z1.8 F60000
G1 Z1.4
G1 E.8 F1800
G1 F1200
M204 S8000
G2 X176.518 Y156.566 I-2.971 J2.406 E.02576
G1 X177.084 Y156.566 E.01818
G1 X177.084 Y157.072 E.01625
; COOLING_NODE: 0
; WIPE_START
G1 F8843.478
G1 X176.816 Y156.834 E-.14884
G1 X176.518 Y156.566 E-.16626
G1 X177.084 Y156.566 E-.23492
G1 X177.084 Y157.072 E-.20999
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.898 Y160.606 Z1.8 F60000
G1 Z1.4
G1 E.8 F1800
G1 F1200
M204 S8000
G1 X175.628 Y160.714 E.00935
G3 X174.772 Y156.502 I-.63 J-2.065 E.23141
G1 X174.988 Y156.49 E.00695
G3 X176.014 Y160.554 I.01 J2.159 E.18443
G1 X175.953 Y160.581 E.00214
; COOLING_NODE: 0
M204 S10000
G1 X175.743 Y160.231 F60000
G1 F1200
M204 S8000
G1 X175.51 Y160.325 E.00807
G3 X174.816 Y156.907 I-.511 J-1.675 E.18776
G1 X174.991 Y156.897 E.00565
G3 X175.822 Y160.195 I.008 J1.752 E.14965
G1 X175.798 Y160.206 E.00086
; COOLING_NODE: 0
M204 S250
G1 X175.594 Y159.87 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X175.397 Y159.949 E.00632
G3 X174.857 Y157.297 I-.397 J-1.3 E.13498
G1 X174.994 Y157.29 E.00407
G3 X175.648 Y159.844 I.006 J1.359 E.10726
; COOLING_NODE: 0
; WIPE_START
G1 F9547.055
M204 S8000
G1 X175.397 Y159.949 E-.10343
G1 X175.125 Y160.004 E-.10539
G1 X174.864 Y160.003 E-.09909
G1 X174.603 Y159.951 E-.10125
G1 X174.361 Y159.851 E-.09952
G1 X174.126 Y159.692 E-.10771
G1 X173.957 Y159.524 E-.09061
G1 X173.879 Y159.408 E-.05301
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.916 Y157.131 Z1.8 F60000
G1 Z1.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X172.916 Y156.566 E.01818
G1 X173.477 Y156.566 E.01804
G1 X173.18 Y156.839 E.01296
G1 X172.956 Y157.087 E.01075
; COOLING_NODE: 0
; WIPE_START
G1 F8843.478
G1 X172.916 Y156.566 E-.21797
G1 X173.477 Y156.566 E-.23423
G1 X173.18 Y156.839 E-.16828
G1 X172.956 Y157.087 E-.13952
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X174.009 Y162.141 Z1.8 F60000
G1 Z1.4
G1 E.8 F1800
G1 F1200
M204 S8000
G1 X172.509 Y162.141 E.04823
G1 X172.509 Y156.159 E.19235
G1 X177.491 Y156.159 E.16019
G1 X177.491 Y162.141 E.19235
G1 X175.991 Y162.141 E.04823
G1 X175.991 Y163.841 E.05467
G1 X174.009 Y163.841 E.06373
G1 X174.009 Y162.201 E.05274
; COOLING_NODE: 0
M204 S10000
G1 X173.602 Y162.548 F60000
G1 F1200
M204 S8000
G1 X172.102 Y162.548 E.04823
G1 X172.102 Y155.752 E.21853
G1 X177.898 Y155.752 E.18637
G1 X177.898 Y162.548 E.21853
G1 X176.398 Y162.548 E.04823
G1 X176.398 Y164.248 E.05467
G1 X173.602 Y164.248 E.08991
M73 P84 R1
G1 X173.602 Y162.608 E.05274
; COOLING_NODE: 1
M204 S250
G1 X173.21 Y162.94 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X171.71 Y162.94 E.04468
G1 X171.71 Y155.36 E.22578
G1 X178.29 Y155.36 E.196
G1 X178.29 Y162.94 E.22578
G1 X176.79 Y162.94 E.04468
G1 X176.79 Y164.64 E.05064
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X173.21 Y164.64 E.10664
G1 X173.21 Y163 E.04885
; WIPE_START
G1 F9547.055
M204 S8000
G1 X171.71 Y162.94 E-.57046
G1 X171.71 Y162.441 E-.18955
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X173.875 Y161.364 Z1.8 F60000
G1 Z1.4
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.378863
G1 F1200
M204 S8000
G1 X173.12 Y161.213 E.02045
M204 S10000
G1 X173.875 Y161.364 F60000
; LINE_WIDTH: 0.351445
G1 F1200
M204 S8000
G1 X174.013 Y161.388 E.00342
; LINE_WIDTH: 0.303042
G1 X174.151 Y161.412 E.00288
; LINE_WIDTH: 0.259388
G1 X174.305 Y161.431 E.00265
; LINE_WIDTH: 0.223108
G1 X174.447 Y161.449 E.00203
; LINE_WIDTH: 0.197887
G1 X174.62 Y161.462 E.00212
M204 S10000
G1 X175 Y161.591 F60000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.43287
G1 F1200
M204 S8000
G1 X174.999 Y161.77 E.00552
M204 S10000
G1 X174.999 Y161.83 F60000
; LINE_WIDTH: 0.47406
G1 F1200
M204 S8000
G1 X174.964 Y161.91 E.00299
; LINE_WIDTH: 0.530071
G1 X174.928 Y161.991 E.00338
G1 X174.868 Y162.005 E.0024
G1 X174.865 Y162.112 E.0041
; LINE_WIDTH: 0.515124
G1 X174.847 Y162.151 E.0016
; LINE_WIDTH: 0.47835
G1 X174.828 Y162.189 E.00147
; LINE_WIDTH: 0.423575
G1 X174.81 Y162.228 E.00129
G1 X174.81 Y163.04 E.02442
G1 X175.19 Y163.04 E.01143
G1 X175.19 Y162.228 E.02442
; LINE_WIDTH: 0.441577
G1 X175.172 Y162.156 E.00234
; LINE_WIDTH: 0.47835
G1 X175.153 Y162.084 E.00256
; LINE_WIDTH: 0.525618
G1 X175.135 Y162.012 E.00283
G1 X175.062 Y161.994 E.00287
; LINE_WIDTH: 0.51698
G1 X175.041 Y161.94 E.00217
; LINE_WIDTH: 0.47406
G1 X175.02 Y161.886 E.00197
M204 S10000
G1 X175.38 Y161.462 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.208798
G1 F1200
M204 S8000
G1 X175.691 Y161.432 E.0041
; LINE_WIDTH: 0.257141
G1 X175.834 Y161.414 E.00242
; LINE_WIDTH: 0.298763
G1 X175.976 Y161.39 E.00293
; LINE_WIDTH: 0.346204
G1 X176.108 Y161.367 E.00319
; LINE_WIDTH: 0.372048
G1 X176.88 Y161.214 E.02048
; WIPE_START
G1 F10938.009
G1 X176.108 Y161.367 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X177.058 Y159.857 Z1.8 F60000
G1 Z1.4
G1 E.8 F1800
; LINE_WIDTH: 0.114297
G1 F1200
M204 S8000
G1 X177.171 Y159.696 E.00111
; LINE_WIDTH: 0.153344
G1 X177.225 Y159.615 E.00086
; LINE_WIDTH: 0.144308
G1 X177.249 Y159.488 E.00103
; LINE_WIDTH: 0.11077
G1 X177.265 Y159.396 E.0005
; WIPE_START
G1 F15000
G1 X177.249 Y159.488 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X177.203 Y157.569 Z1.8 F60000
G1 Z1.4
G1 E.8 F1800
; LINE_WIDTH: 0.131261
G1 F1200
M204 S8000
G3 X177.265 Y157.906 I-6.505 J1.361 E.00239
M204 S10000
G1 X177.287 Y157.781 F60000
; LINE_WIDTH: 0.154236
G1 F1200
M204 S8000
G1 X177.204 Y157.655 E.00133
; LINE_WIDTH: 0.11743
G1 X177.059 Y157.445 E.0015
; WIPE_START
G1 F15000
G1 X177.204 Y157.655 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X176.208 Y156.593 Z1.8 F60000
G1 Z1.4
G1 E.8 F1800
; LINE_WIDTH: 0.108689
G1 F1200
M204 S8000
G1 X176.094 Y156.511 E.00073
; LINE_WIDTH: 0.144466
G1 X175.868 Y156.363 E.00217
M204 S10000
G1 X175.744 Y156.385 F60000
; LINE_WIDTH: 0.130034
G1 F1200
M204 S8000
G3 X176.081 Y156.446 I-1.117 J7.14 E.00235
; WIPE_START
G1 F15000
G1 X175.744 Y156.385 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X174.254 Y156.385 Z1.8 F60000
G1 Z1.4
G1 E.8 F1800
; LINE_WIDTH: 0.111507
G1 F1200
M204 S8000
G1 X174.158 Y156.402 E.00053
; LINE_WIDTH: 0.146937
G1 X174.026 Y156.427 E.00111
; LINE_WIDTH: 0.157553
G1 X173.948 Y156.48 E.00085
; LINE_WIDTH: 0.116521
G1 X173.773 Y156.604 E.00125
; WIPE_START
G1 F15000
G1 X173.948 Y156.48 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.942 Y157.444 Z1.8 F60000
G1 Z1.4
G1 E.8 F1800
; LINE_WIDTH: 0.103646
G1 F1200
M204 S8000
G1 X172.884 Y157.523 E.00047
; LINE_WIDTH: 0.124895
G1 X172.829 Y157.604 E.00063
; LINE_WIDTH: 0.154987
G2 X172.767 Y157.72 I.141 J.15 E.00118
; LINE_WIDTH: 0.138422
G1 X172.751 Y157.812 E.00071
; LINE_WIDTH: 0.110754
G1 X172.735 Y157.904 E.0005
; WIPE_START
G1 F15000
G1 X172.751 Y157.812 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.8 Y159.745 Z1.8 F60000
G1 Z1.4
G1 E.8 F1800
; LINE_WIDTH: 0.147374
G1 F1200
M204 S8000
G1 X172.764 Y159.565 E.00151
; LINE_WIDTH: 0.121648
G1 X172.735 Y159.396 E.00107
M204 S10000
G1 X172.713 Y159.527 F60000
; LINE_WIDTH: 0.158533
G1 F1200
M204 S8000
G1 X172.796 Y159.652 E.00137
; LINE_WIDTH: 0.130806
G1 X172.879 Y159.777 E.00104
; LINE_WIDTH: 0.106749
G1 X172.955 Y159.877 E.00063
; CHANGE_LAYER
; Z_HEIGHT: 1.6
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F15000
G1 X172.879 Y159.777 E-.76
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
G3 Z1.8 I-.714 J.986 P1  F60000
G1 X175.584 Y161.734 Z1.8
G1 Z1.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X175.584 Y163.434 E.05467
G1 X174.416 Y163.434 E.03755
G1 X174.416 Y161.734 E.05467
G1 X172.916 Y161.734 E.04823
G1 X172.916 Y160.181 E.04995
G2 X174.807 Y161.211 I2.141 J-1.679 E.07118
G2 X177.084 Y160.162 I.182 J-2.601 E.08409
G1 X177.084 Y161.734 E.05054
G1 X175.644 Y161.734 E.04631
; COOLING_NODE: 0
; WIPE_START
G1 F8843.478
G1 X175.584 Y163.434 E-.6464
M73 P85 R1
G1 X175.285 Y163.434 E-.1136
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X177.084 Y157.12 Z2 F60000
G1 Z1.6
G1 E.8 F1800
G1 F1200
M204 S8000
G2 X176.513 Y156.566 I-3.21 J2.741 E.0256
G1 X177.084 Y156.566 E.01836
G1 X177.084 Y157.06 E.01586
; COOLING_NODE: 0
; WIPE_START
G1 F8843.478
G1 X176.78 Y156.8 E-.16691
G1 X176.513 Y156.566 E-.14838
G1 X177.084 Y156.566 E-.23857
G1 X177.084 Y157.06 E-.20613
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.974 Y160.569 Z2 F60000
G1 Z1.6
G1 E.8 F1800
G1 F1200
M204 S8000
G1 X175.867 Y160.625 E.00389
G3 X174.771 Y156.502 I-.868 J-1.977 E.23948
G1 X174.974 Y156.49 E.00655
G3 X176.234 Y160.419 I.025 J2.159 E.17661
G1 X176.026 Y160.539 E.00772
; COOLING_NODE: 0
M204 S10000
G1 X175.776 Y160.215 F60000
G1 F1200
M204 S8000
G1 X175.704 Y160.253 E.0026
G3 X174.815 Y156.907 I-.705 J-1.604 E.19433
G1 X174.978 Y156.897 E.00528
G3 X176.002 Y160.085 I.021 J1.752 E.14329
G1 X175.828 Y160.185 E.00646
; COOLING_NODE: 0
M204 S250
G1 X175.584 Y159.874 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X175.547 Y159.893 E.00126
G3 X174.857 Y157.297 I-.547 J-1.244 E.13972
G1 X174.983 Y157.29 E.00375
G3 X175.778 Y159.763 I.017 J1.359 E.10299
G1 X175.636 Y159.845 E.00488
; COOLING_NODE: 0
; WIPE_START
G1 F9547.055
M204 S8000
G1 X175.547 Y159.893 E-.03882
G1 X175.284 Y159.98 E-.1053
G1 X175.025 Y160.01 E-.09902
G1 X174.765 Y159.99 E-.0991
G1 X174.513 Y159.92 E-.09912
G1 X174.279 Y159.804 E-.09941
G1 X174.056 Y159.629 E-.1077
G1 X173.886 Y159.43 E-.09938
G1 X173.87 Y159.402 E-.01215
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.916 Y157.138 Z2 F60000
G1 Z1.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X172.916 Y156.566 E.01839
G1 X173.474 Y156.566 E.01794
G1 X173.153 Y156.866 E.01414
G1 X172.956 Y157.093 E.00966
; COOLING_NODE: 0
; WIPE_START
G1 F8843.478
G1 X172.916 Y156.566 E-.21979
G1 X173.474 Y156.566 E-.23221
G1 X173.153 Y156.866 E-.18302
G1 X172.956 Y157.093 E-.12499
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.991 Y162.141 Z2 F60000
G1 Z1.6
G1 E.8 F1800
G1 F1200
M204 S8000
G1 X175.991 Y163.841 E.05467
G1 X174.009 Y163.841 E.06373
G1 X174.009 Y162.141 E.05467
G1 X172.509 Y162.141 E.04823
G1 X172.509 Y156.159 E.19235
G1 X177.491 Y156.159 E.16019
G1 X177.491 Y162.141 E.19235
G1 X176.051 Y162.141 E.04631
; COOLING_NODE: 0
M204 S10000
G1 X176.398 Y162.548 F60000
G1 F1200
M204 S8000
G1 X176.398 Y164.248 E.05467
G1 X173.602 Y164.248 E.08991
G1 X173.602 Y162.548 E.05467
G1 X172.102 Y162.548 E.04823
G1 X172.102 Y155.752 E.21853
G1 X177.898 Y155.752 E.18637
G1 X177.898 Y162.548 E.21853
G1 X176.458 Y162.548 E.04631
; COOLING_NODE: 1
M204 S250
G1 X176.79 Y162.94 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
M73 P86 R1
G1 F1200
M204 S5000
G1 X176.79 Y164.64 E.05064
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X173.21 Y164.64 E.10664
G1 X173.21 Y162.94 E.05064
G1 X171.71 Y162.94 E.04468
G1 X171.71 Y155.36 E.22578
G1 X178.29 Y155.36 E.196
G1 X178.29 Y162.94 E.22578
G1 X176.85 Y162.94 E.04289
; WIPE_START
G1 F9547.055
M204 S8000
G1 X176.79 Y164.64 E-.6464
G1 X176.491 Y164.64 E-.1136
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X176.176 Y161.353 Z2 F60000
G1 Z1.6
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.400191
G1 F1200
M204 S8000
G1 X176.88 Y161.206 E.0203
M204 S10000
G1 X176.176 Y161.353 F60000
; LINE_WIDTH: 0.379631
G1 F1200
M204 S8000
G1 X176.084 Y161.37 E.00249
; LINE_WIDTH: 0.345693
G1 X175.992 Y161.387 E.00224
; LINE_WIDTH: 0.309445
G1 X175.887 Y161.406 E.00224
; LINE_WIDTH: 0.27217
G1 X175.746 Y161.425 E.00257
; LINE_WIDTH: 0.233948
G1 X175.597 Y161.444 E.00227
; LINE_WIDTH: 0.202865
G1 X175.38 Y161.462 E.00274
; WIPE_START
G1 F15000
G1 X175.597 Y161.444 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X173.401 Y161.249 Z2 F60000
G1 Z1.6
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.58236
G1 F1200
M204 S8000
G1 X173.568 Y161.285 E.00729
; LINE_WIDTH: 0.53804
G1 X173.735 Y161.32 E.00669
; LINE_WIDTH: 0.49372
G1 X173.903 Y161.355 E.00609
; LINE_WIDTH: 0.4494
G1 X174.07 Y161.39 E.00549
; LINE_WIDTH: 0.38961
G2 X174.632 Y161.46 I.577 J-2.338 E.01553
; LINE_WIDTH: 0.406426
G1 X174.681 Y161.502 E.00187
; LINE_WIDTH: 0.453438
G1 X174.73 Y161.545 E.00211
; LINE_WIDTH: 0.50045
G1 X174.779 Y161.588 E.00235
; LINE_WIDTH: 0.547462
G1 X174.828 Y161.631 E.00259
; LINE_WIDTH: 0.594474
G1 X174.877 Y161.673 E.00284
M204 S10000
G1 X174.908 Y161.72 F60000
; LINE_WIDTH: 0.595084
G1 F1200
M204 S8000
G1 X174.884 Y161.816 E.00435
; LINE_WIDTH: 0.545972
G1 X174.859 Y161.913 E.00396
; LINE_WIDTH: 0.496859
G1 X174.834 Y162.009 E.00357
; LINE_WIDTH: 0.424202
G1 X174.81 Y162.106 E.003
G1 X174.81 Y163.04 E.02814
G1 X175.19 Y163.04 E.01145
G2 X175.19 Y161.966 I-150.211 J-.467 E.03235
G1 X175.101 Y161.944 E.00275
; LINE_WIDTH: 0.447304
G1 X175.049 Y161.898 E.00224
; LINE_WIDTH: 0.49351
G1 X174.996 Y161.851 E.0025
; LINE_WIDTH: 0.539717
G1 X174.944 Y161.805 E.00275
; LINE_WIDTH: 0.577025
G1 X174.937 Y161.79 E.00068
; LINE_WIDTH: 0.605435
G1 X174.931 Y161.775 E.00072
; WIPE_START
G1 F6399.83
G1 X174.937 Y161.79 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.976 Y159.913 Z2 F60000
G1 Z1.6
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.106481
G1 F1200
M204 S8000
G1 X172.901 Y159.815 E.00062
; LINE_WIDTH: 0.132023
G1 X172.841 Y159.729 E.00074
; LINE_WIDTH: 0.165157
G3 X172.776 Y159.622 I.108 J-.138 E.00124
; LINE_WIDTH: 0.151328
G1 X172.755 Y159.51 E.00097
; LINE_WIDTH: 0.115063
G1 X172.735 Y159.399 E.00065
; WIPE_START
G1 F15000
G1 X172.755 Y159.51 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.735 Y157.904 Z2 F60000
G1 Z1.6
G1 E.8 F1800
; LINE_WIDTH: 0.121788
G1 F1200
M204 S8000
G3 X172.791 Y157.592 I6.093 J.93 E.00197
M204 S10000
G1 X172.86 Y157.566 F60000
; LINE_WIDTH: 0.136594
G1 F1200
M204 S8000
G1 X172.713 Y157.798 E.00203
M204 S10000
G1 X172.86 Y157.566 F60000
; LINE_WIDTH: 0.104407
G1 F1200
M204 S8000
G1 X172.92 Y157.481 E.0005
; WIPE_START
G1 F15000
G1 X172.86 Y157.566 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X173.758 Y156.613 Z2 F60000
G1 Z1.6
G1 E.8 F1800
; LINE_WIDTH: 0.116139
G1 F1200
M204 S8000
G1 X173.928 Y156.49 E.00121
; LINE_WIDTH: 0.15939
G1 X174.017 Y156.429 E.00099
; LINE_WIDTH: 0.150184
G1 X174.151 Y156.403 E.00116
; LINE_WIDTH: 0.11272
G1 X174.252 Y156.385 E.00056
; WIPE_START
G1 F15000
G1 X174.151 Y156.403 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.744 Y156.385 Z2 F60000
G1 Z1.6
G1 E.8 F1800
; LINE_WIDTH: 0.118037
G1 F1200
M204 S8000
G1 X175.897 Y156.411 E.00092
; LINE_WIDTH: 0.139418
G1 X175.948 Y156.422 E.0004
G1 X176.092 Y156.515 E.00131
; LINE_WIDTH: 0.103977
G1 X176.174 Y156.574 E.00049
; WIPE_START
G1 F15000
G1 X176.092 Y156.515 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X177.024 Y157.388 Z2 F60000
G1 Z1.6
G1 E.8 F1800
; LINE_WIDTH: 0.106074
G1 F1200
M204 S8000
G1 X177.097 Y157.481 E.00059
; LINE_WIDTH: 0.131293
G1 X177.159 Y157.571 E.00076
; LINE_WIDTH: 0.163218
G1 X177.219 Y157.657 E.001
; LINE_WIDTH: 0.15495
G1 X177.245 Y157.79 E.00119
; LINE_WIDTH: 0.115078
G1 X177.265 Y157.901 E.00065
; WIPE_START
G1 F15000
G1 X177.245 Y157.79 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X177.265 Y159.395 Z2 F60000
G1 Z1.6
G1 E.8 F1800
; LINE_WIDTH: 0.120151
G1 F1200
M204 S8000
G3 X177.21 Y159.706 I-5.99 J-.89 E.00193
M204 S10000
G1 X177.139 Y159.736 F60000
; LINE_WIDTH: 0.104421
G1 F1200
M204 S8000
G1 X177.08 Y159.819 E.0005
M204 S10000
G1 X177.139 Y159.736 F60000
; LINE_WIDTH: 0.136595
G1 F1200
M204 S8000
G1 X177.287 Y159.503 E.00205
; CHANGE_LAYER
; Z_HEIGHT: 1.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F15000
G1 X177.139 Y159.736 E-.76
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
G3 Z2 I-.96 J-.747 P1  F60000
G1 X175.584 Y161.734 Z2
G1 Z1.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X175.584 Y163.434 E.05467
G1 X174.416 Y163.434 E.03755
G1 X174.416 Y161.734 E.05467
G1 X172.916 Y161.734 E.04823
G1 X172.916 Y160.173 E.0502
G2 X177.084 Y160.169 I2.082 J-1.582 E.15508
G1 X177.084 Y161.734 E.05033
G1 X175.644 Y161.734 E.04631
; COOLING_NODE: 0
; WIPE_START
G1 F8843.478
M73 P87 R1
G1 X175.584 Y163.434 E-.6464
G1 X175.285 Y163.434 E-.1136
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X177.084 Y157.132 Z2.2 F60000
G1 Z1.8
G1 E.8 F1800
G1 F1200
M204 S8000
G2 X176.518 Y156.566 I-2.971 J2.406 E.02576
G1 X177.084 Y156.566 E.01818
G1 X177.084 Y157.072 E.01625
; COOLING_NODE: 0
; WIPE_START
G1 F8843.478
G1 X176.816 Y156.834 E-.14884
G1 X176.518 Y156.566 E-.16626
G1 X177.084 Y156.566 E-.23492
G1 X177.084 Y157.072 E-.20999
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.891 Y160.608 Z2.2 F60000
G1 Z1.8
G1 E.8 F1800
G1 F1200
M204 S8000
G1 X175.628 Y160.714 E.00912
G3 X174.772 Y156.502 I-.63 J-2.065 E.23141
G1 X174.988 Y156.49 E.00695
G3 X176.014 Y160.554 I.01 J2.159 E.18443
G1 X175.946 Y160.584 E.00237
; COOLING_NODE: 0
M204 S10000
G1 X175.736 Y160.233 F60000
G1 F1200
M204 S8000
G1 X175.51 Y160.325 E.00784
G3 X174.816 Y156.907 I-.511 J-1.675 E.18776
G1 X174.991 Y156.897 E.00565
G3 X175.822 Y160.195 I.008 J1.752 E.14965
G1 X175.791 Y160.209 E.00109
; COOLING_NODE: 0
M204 S250
G1 X175.587 Y159.872 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
M73 P87 R0
G1 X175.397 Y159.949 E.00611
G3 X174.857 Y157.297 I-.397 J-1.3 E.13498
G1 X174.994 Y157.29 E.00407
G3 X175.642 Y159.848 I.006 J1.359 E.10747
; COOLING_NODE: 0
; WIPE_START
G1 F9547.055
M204 S8000
G1 X175.397 Y159.949 E-.10076
G1 X175.125 Y160.004 E-.10539
G1 X174.864 Y160.003 E-.09909
G1 X174.603 Y159.951 E-.10125
G1 X174.361 Y159.851 E-.09952
G1 X174.126 Y159.692 E-.10771
G1 X173.957 Y159.524 E-.09061
G1 X173.876 Y159.402 E-.05567
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.916 Y157.131 Z2.2 F60000
G1 Z1.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X172.916 Y156.566 E.01818
G1 X173.477 Y156.566 E.01804
G1 X173.18 Y156.839 E.01296
G1 X172.956 Y157.087 E.01075
; COOLING_NODE: 0
; WIPE_START
G1 F8843.478
G1 X172.916 Y156.566 E-.21797
G1 X173.477 Y156.566 E-.23423
G1 X173.18 Y156.839 E-.16828
G1 X172.956 Y157.087 E-.13952
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.991 Y162.141 Z2.2 F60000
G1 Z1.8
G1 E.8 F1800
G1 F1200
M204 S8000
G1 X175.991 Y163.841 E.05467
G1 X174.009 Y163.841 E.06373
G1 X174.009 Y162.141 E.05467
G1 X172.509 Y162.141 E.04823
G1 X172.509 Y156.159 E.19235
G1 X177.491 Y156.159 E.16019
G1 X177.491 Y162.141 E.19235
G1 X176.051 Y162.141 E.04631
; COOLING_NODE: 0
M204 S10000
G1 X176.398 Y162.548 F60000
G1 F1200
M204 S8000
G1 X176.398 Y164.248 E.05467
G1 X173.602 Y164.248 E.08991
G1 X173.602 Y162.548 E.05467
G1 X172.102 Y162.548 E.04823
G1 X172.102 Y155.752 E.21853
G1 X177.898 Y155.752 E.18637
G1 X177.898 Y162.548 E.21853
G1 X176.458 Y162.548 E.04631
; COOLING_NODE: 1
M204 S250
M73 P88 R0
G1 X176.79 Y162.94 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X176.79 Y164.64 E.05064
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X173.21 Y164.64 E.10664
G1 X173.21 Y162.94 E.05064
G1 X171.71 Y162.94 E.04468
G1 X171.71 Y155.36 E.22578
G1 X178.29 Y155.36 E.196
G1 X178.29 Y162.94 E.22578
G1 X176.85 Y162.94 E.04289
; WIPE_START
G1 F9547.055
M204 S8000
G1 X176.79 Y164.64 E-.6464
G1 X176.491 Y164.64 E-.1136
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X176.88 Y161.214 Z2.2 F60000
G1 Z1.8
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.372048
G1 F1200
M204 S8000
G1 X176.108 Y161.367 E.02048
; LINE_WIDTH: 0.346204
G1 X175.976 Y161.39 E.00319
; LINE_WIDTH: 0.298763
G1 X175.834 Y161.414 E.00293
; LINE_WIDTH: 0.257141
G1 X175.691 Y161.432 E.00242
; LINE_WIDTH: 0.208798
G1 X175.38 Y161.462 E.0041
M204 S10000
G1 X175 Y161.591 F60000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.43287
G1 F1200
M204 S8000
G1 X174.999 Y161.77 E.00552
M204 S10000
G1 X174.999 Y161.83 F60000
; LINE_WIDTH: 0.47406
G1 F1200
M204 S8000
G1 X174.964 Y161.91 E.00299
; LINE_WIDTH: 0.530071
G1 X174.928 Y161.991 E.00338
G1 X174.868 Y162.005 E.0024
G1 X174.865 Y162.112 E.0041
; LINE_WIDTH: 0.515124
G1 X174.847 Y162.151 E.0016
; LINE_WIDTH: 0.47835
G1 X174.828 Y162.189 E.00147
; LINE_WIDTH: 0.423575
G1 X174.81 Y162.228 E.00129
G1 X174.81 Y163.04 E.02442
G1 X175.19 Y163.04 E.01143
G1 X175.19 Y162.228 E.02442
; LINE_WIDTH: 0.441577
G1 X175.172 Y162.156 E.00234
; LINE_WIDTH: 0.47835
G1 X175.153 Y162.084 E.00256
; LINE_WIDTH: 0.525618
G1 X175.135 Y162.012 E.00283
G1 X175.062 Y161.994 E.00287
; LINE_WIDTH: 0.51698
G1 X175.041 Y161.94 E.00217
; LINE_WIDTH: 0.47406
G1 X175.02 Y161.886 E.00197
M204 S10000
G1 X174.62 Y161.462 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.197887
G1 F1200
M204 S8000
G1 X174.447 Y161.449 E.00212
; LINE_WIDTH: 0.223108
G1 X174.305 Y161.431 E.00203
; LINE_WIDTH: 0.259388
G1 X174.151 Y161.412 E.00265
; LINE_WIDTH: 0.303042
G1 X174.013 Y161.388 E.00288
; LINE_WIDTH: 0.351445
G1 X173.875 Y161.364 E.00342
; LINE_WIDTH: 0.378863
G1 X173.12 Y161.213 E.02045
; WIPE_START
G1 F10716.13
G1 X173.875 Y161.364 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.955 Y159.877 Z2.2 F60000
G1 Z1.8
G1 E.8 F1800
; LINE_WIDTH: 0.106749
G1 F1200
M204 S8000
G1 X172.879 Y159.777 E.00063
; LINE_WIDTH: 0.130806
G1 X172.796 Y159.652 E.00104
; LINE_WIDTH: 0.158533
G1 X172.713 Y159.527 E.00137
M204 S10000
G1 X172.764 Y159.565 F60000
; LINE_WIDTH: 0.121648
G1 F1200
M204 S8000
G1 X172.735 Y159.396 E.00107
M204 S10000
G1 X172.764 Y159.565 F60000
; LINE_WIDTH: 0.147374
G1 F1200
M204 S8000
G1 X172.8 Y159.745 E.00151
; WIPE_START
G1 F15000
G1 X172.764 Y159.565 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.735 Y157.904 Z2.2 F60000
G1 Z1.8
G1 E.8 F1800
; LINE_WIDTH: 0.110754
G1 F1200
M204 S8000
G1 X172.751 Y157.812 E.0005
; LINE_WIDTH: 0.138422
G1 X172.767 Y157.72 E.00071
; LINE_WIDTH: 0.154987
G3 X172.829 Y157.604 I.203 J.034 E.00118
; LINE_WIDTH: 0.124895
G1 X172.884 Y157.523 E.00063
; LINE_WIDTH: 0.103646
G1 X172.942 Y157.444 E.00047
; WIPE_START
G1 F15000
G1 X172.884 Y157.523 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X173.773 Y156.604 Z2.2 F60000
G1 Z1.8
G1 E.8 F1800
; LINE_WIDTH: 0.116521
G1 F1200
M204 S8000
G1 X173.948 Y156.48 E.00125
; LINE_WIDTH: 0.157553
G1 X174.026 Y156.427 E.00085
; LINE_WIDTH: 0.146937
G1 X174.158 Y156.402 E.00111
; LINE_WIDTH: 0.111507
G1 X174.254 Y156.385 E.00053
; WIPE_START
G1 F15000
G1 X174.158 Y156.402 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.744 Y156.385 Z2.2 F60000
G1 Z1.8
G1 E.8 F1800
; LINE_WIDTH: 0.130034
G1 F1200
M204 S8000
G3 X176.081 Y156.446 I-1.117 J7.14 E.00235
M204 S10000
G1 X176.094 Y156.511 F60000
; LINE_WIDTH: 0.144466
G1 F1200
M204 S8000
G1 X175.868 Y156.363 E.00217
M204 S10000
G1 X176.094 Y156.511 F60000
; LINE_WIDTH: 0.108689
G1 F1200
M204 S8000
G1 X176.208 Y156.593 E.00073
; WIPE_START
G1 F15000
G1 X176.094 Y156.511 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X177.059 Y157.445 Z2.2 F60000
G1 Z1.8
G1 E.8 F1800
; LINE_WIDTH: 0.11743
G1 F1200
M204 S8000
G1 X177.204 Y157.655 E.0015
; LINE_WIDTH: 0.154236
G1 X177.287 Y157.781 E.00133
M204 S10000
G1 X177.265 Y157.906 F60000
; LINE_WIDTH: 0.131261
G1 F1200
M204 S8000
G2 X177.203 Y157.569 I-6.566 J1.024 E.00239
; WIPE_START
G1 F15000
G1 X177.265 Y157.906 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X177.265 Y159.396 Z2.2 F60000
G1 Z1.8
G1 E.8 F1800
; LINE_WIDTH: 0.11077
G1 F1200
M204 S8000
G1 X177.249 Y159.488 E.0005
; LINE_WIDTH: 0.144308
G1 X177.225 Y159.615 E.00103
; LINE_WIDTH: 0.153344
G1 X177.171 Y159.696 E.00086
; LINE_WIDTH: 0.114297
G1 X177.058 Y159.857 E.00111
; CHANGE_LAYER
; Z_HEIGHT: 2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F15000
G1 X177.171 Y159.696 E-.76
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
G3 Z2.2 I-.138 J-1.209 P1  F60000
G1 X175.581 Y159.877 Z2.2
G1 Z2
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X175.554 Y159.89 E.00092
G3 X174.857 Y157.297 I-.554 J-1.241 E.13995
G1 X174.983 Y157.29 E.00375
G3 X175.779 Y159.763 I.017 J1.359 E.10297
G1 X175.633 Y159.847 E.00502
; COOLING_NODE: 1
; WIPE_START
G1 F9547.055
M204 S8000
G1 X175.554 Y159.89 E-.03453
G1 X175.306 Y159.975 E-.09948
G1 X175.025 Y160.01 E-.10769
G1 X174.765 Y159.99 E-.0991
G1 X174.513 Y159.92 E-.09912
G1 X174.279 Y159.804 E-.09941
G1 X174.056 Y159.629 E-.1077
G1 X173.886 Y159.43 E-.09938
G1 X173.868 Y159.399 E-.01359
; WIPE_END
G1 E-.04 F1800
M204 S10000
M73 P89 R0
G1 X176.79 Y162.94 Z2.4 F60000
G1 Z2
G1 E.8 F1800
G1 F1200
M204 S5000
G1 X176.79 Y164.64 E.05064
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X173.21 Y164.64 E.10664
G1 X173.21 Y162.94 E.05064
G1 X171.71 Y162.94 E.04468
G1 X171.71 Y155.36 E.22578
G1 X178.29 Y155.36 E.196
G1 X178.29 Y162.94 E.22578
G1 X176.85 Y162.94 E.04289
M204 S10000
G1 X177.333 Y162.733 F60000
; FEATURE: Top surface
G1 F1200
M204 S2000
G1 X178.083 Y161.983 E.03157
G1 X178.216 Y161.85
G1 X178.216 Y161.316
G1 X178.083 Y161.45
G1 X176.8 Y162.733 E.05403
; WIPE_START
G1 F9547.055
M204 S8000
G1 X178.083 Y161.45 E-.68928
G1 X178.214 Y161.318 E-.07072
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X176.583 Y164.017 Z2.4 F60000
G1 Z2
G1 E.8 F1800
G1 F1200
M204 S2000
G1 X176.167 Y164.433 E.01753
G1 X176.033 Y164.566
G1 X175.523 Y164.543
G1 X175.656 Y164.41
G1 X176.583 Y163.483 E.03902
G1 X176.716 Y163.35
G1 X176.716 Y162.816
G1 X176.583 Y162.95
G1 X175.339 Y164.194 E.05239
G1 X175.205 Y164.327
G1 X174.672 Y164.327
G1 X174.806 Y164.194
G1 X178.083 Y160.917 E.13804
G1 X178.216 Y160.783
G1 X178.216 Y160.25
G1 X178.083 Y160.383
G1 X174.033 Y164.433 E.17057
G1 X173.9 Y164.566
G1 X173.367 Y164.566
G1 X173.5 Y164.433
G1 X178.083 Y159.85 E.19303
G1 X178.216 Y159.717
G1 X178.216 Y159.183
G1 X178.083 Y159.317
G1 X173.417 Y163.982 E.19652
G1 X173.284 Y164.116
G1 X173.284 Y163.583
G1 X173.417 Y163.449
G1 X178.083 Y158.784 E.19652
G1 X178.216 Y158.65
G1 X178.216 Y158.117
G1 X178.083 Y158.25
G1 X173.417 Y162.916 E.19652
G1 X173.284 Y163.049
G1 X172.934 Y162.866
G1 X173.067 Y162.733
G1 X175.806 Y159.993 E.11539
G1 X175.94 Y159.86
G1 X175.184 Y160.082
G1 X175.05 Y160.216
M73 P90 R0
G1 X172.534 Y162.733 E.10601
G1 X172.4 Y162.866
G1 X171.867 Y162.866
G1 X172.001 Y162.733
G1 X174.575 Y160.158 E.10844
G1 X174.709 Y160.025
G1 X174.336 Y159.864
G1 X174.202 Y159.998
G1 X171.917 Y162.283 E.09624
G1 X171.784 Y162.416
G1 X171.784 Y161.883
G1 X171.917 Y161.749
G1 X173.9 Y159.767 E.08353
G1 X174.034 Y159.633
G1 X173.799 Y159.335
G1 X173.665 Y159.468
G1 X171.917 Y161.216 E.07362
G1 X171.784 Y161.35
G1 X171.784 Y160.817
G1 X171.917 Y160.683
G1 X173.5 Y159.101 E.06665
G1 X173.633 Y158.967
G1 X173.567 Y158.5
G1 X173.434 Y158.633
G1 X171.917 Y160.15 E.06387
G1 X171.784 Y160.283
G1 X171.784 Y159.75
G1 X171.917 Y159.616
G1 X173.613 Y157.921 E.07142
; WIPE_START
G1 F9547.055
M204 S8000
G1 X172.199 Y159.335 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X176.343 Y159.457 Z2.4 F60000
G1 Z2
G1 E.8 F1800
G1 F1200
M204 S2000
G1 X178.083 Y157.717 E.07327
G1 X178.216 Y157.584
G1 X178.216 Y157.05
G1 X178.083 Y157.184
G1 X176.565 Y158.701 E.06391
G1 X176.432 Y158.835
G1 X176.374 Y158.36
G1 X176.507 Y158.226
G1 X178.083 Y156.651 E.06636
G1 X178.216 Y156.517
G1 X178.216 Y155.984
G1 X178.083 Y156.117
G1 X176.348 Y157.852 E.07308
G1 X176.214 Y157.986
G1 X175.982 Y157.684
G1 X176.116 Y157.551
G1 X178.083 Y155.584 E.08284
G1 X178.216 Y155.451
G1 X177.7 Y155.434
G1 X177.566 Y155.567
G1 X175.819 Y157.315 E.07361
G1 X175.685 Y157.448
G1 X175.317 Y157.283
G1 X175.451 Y157.149
G1 X177.033 Y155.567 E.06663
G1 X177.167 Y155.434
G1 X176.633 Y155.434
G1 X176.5 Y155.567
G1 X174.985 Y157.082 E.06382
G1 X174.851 Y157.216
G1 X174.136 Y157.398
G1 X174.27 Y157.264
G1 X175.966 Y155.567 E.07147
G1 X176.1 Y155.434
G1 X175.567 Y155.434
G1 X175.433 Y155.567
G1 X171.917 Y159.083 E.1481
G1 X171.784 Y159.217
G1 X171.784 Y158.684
G1 X171.917 Y158.55
G1 X174.9 Y155.567 E.12564
G1 X175.034 Y155.434
G1 X174.5 Y155.434
G1 X174.367 Y155.567
G1 X171.917 Y158.017 E.10317
G1 X171.784 Y158.15
G1 X171.784 Y157.617
G1 X171.917 Y157.483
G1 X173.833 Y155.567 E.08071
G1 X173.967 Y155.434
G1 X173.434 Y155.434
G1 X173.3 Y155.567
G1 X171.917 Y156.95 E.05825
G1 X171.784 Y157.084
G1 X171.784 Y156.55
G1 X171.917 Y156.417
G1 X172.767 Y155.567 E.03578
; WIPE_START
G1 F9547.055
M204 S8000
G1 X171.917 Y156.417 E-.45649
G1 X171.784 Y156.55 E-.07182
G1 X171.784 Y157.084 E-.20264
G1 X171.838 Y157.03 E-.02905
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X176.405 Y159.518 Z2.4 F60000
G1 Z2
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.215261
G1 F1200
M204 S8000
G1 X176.136 Y159.82 E.00551
; WIPE_START
G1 F15000
G1 X176.405 Y159.518 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X173.937 Y157.43 Z2.4 F60000
G1 Z2
G1 E.8 F1800
; LINE_WIDTH: 0.195971
G1 F1200
M204 S8000
G1 X173.724 Y157.648 E.00369
G1 X173.552 Y157.86 E.0033
; WIPE_START
M73 P91 R0
G1 F15000
G1 X173.724 Y157.648 E-.35843
G1 X173.937 Y157.43 E-.40157
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X174.37 Y164.332 Z2.4 F60000
G1 Z2
G1 E.8 F1800
; LINE_WIDTH: 0.26667
G1 F1200
M204 S8000
G1 X175.63 Y164.332 E.02226
; CHANGE_LAYER
; Z_HEIGHT: 2.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F15000
G1 X174.37 Y164.332 E-.76
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
G3 Z2.4 I.485 J1.116 P1  F60000
G1 X176.398 Y163.452 Z2.4
G1 Z2.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X176.398 Y164.248 E.02559
G1 X173.602 Y164.248 E.08991
G1 X173.602 Y163.452 E.02559
G1 X176.338 Y163.452 E.08798
; COOLING_NODE: 1
M204 S250
G1 X176.79 Y163.06 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X176.79 Y164.64 E.04706
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X173.21 Y164.64 E.10664
G1 X173.21 Y163.06 E.04706
G1 X176.73 Y163.06 E.10485
M204 S10000
G1 X176.194 Y163.85 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1200
M204 S8000
G1 X173.806 Y163.85 E.07337
; CHANGE_LAYER
; Z_HEIGHT: 2.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.259
G1 X175.806 Y163.85 E-.76
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
G3 Z2.6 I.679 J1.01 P1  F60000
G1 X176.398 Y163.452 Z2.6
G1 Z2.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X176.398 Y164.248 E.02559
G1 X173.602 Y164.248 E.08991
G1 X173.602 Y163.452 E.02559
G1 X176.338 Y163.452 E.08798
; COOLING_NODE: 1
M204 S250
G1 X176.79 Y163.06 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X176.79 Y164.64 E.04706
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X173.21 Y164.64 E.10664
G1 X173.21 Y163.06 E.04706
G1 X176.73 Y163.06 E.10485
M204 S10000
G1 X176.194 Y163.85 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1200
M204 S8000
G1 X173.806 Y163.85 E.07337
; CHANGE_LAYER
; Z_HEIGHT: 2.6
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.259
G1 X175.806 Y163.85 E-.76
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
G3 Z2.8 I.679 J1.01 P1  F60000
G1 X176.398 Y163.452 Z2.8
G1 Z2.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X176.398 Y164.248 E.02559
G1 X173.602 Y164.248 E.08991
G1 X173.602 Y163.452 E.02559
G1 X176.338 Y163.452 E.08798
; COOLING_NODE: 1
M204 S250
G1 X176.79 Y163.06 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X176.79 Y164.64 E.04706
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X173.21 Y164.64 E.10664
G1 X173.21 Y163.06 E.04706
G1 X176.73 Y163.06 E.10485
M204 S10000
G1 X176.194 Y163.85 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1200
M204 S8000
G1 X173.806 Y163.85 E.07337
; CHANGE_LAYER
; Z_HEIGHT: 2.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.259
G1 X175.806 Y163.85 E-.76
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
G3 Z3 I.679 J1.01 P1  F60000
G1 X176.398 Y163.452 Z3
G1 Z2.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X176.398 Y164.248 E.02559
G1 X173.602 Y164.248 E.08991
G1 X173.602 Y163.452 E.02559
G1 X176.338 Y163.452 E.08798
; COOLING_NODE: 1
M204 S250
G1 X176.79 Y163.06 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X176.79 Y164.64 E.04706
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X173.21 Y164.64 E.10664
G1 X173.21 Y163.06 E.04706
G1 X176.73 Y163.06 E.10485
M204 S10000
G1 X176.194 Y163.85 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
M73 P92 R0
G1 F1200
M204 S8000
G1 X173.806 Y163.85 E.07337
; CHANGE_LAYER
; Z_HEIGHT: 3
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.259
G1 X175.806 Y163.85 E-.76
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
G3 Z3.2 I.679 J1.01 P1  F60000
G1 X176.398 Y163.452 Z3.2
G1 Z3
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X176.398 Y164.248 E.02559
G1 X173.602 Y164.248 E.08991
G1 X173.602 Y163.452 E.02559
G1 X176.338 Y163.452 E.08798
; COOLING_NODE: 1
M204 S250
G1 X176.79 Y163.06 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X176.79 Y164.64 E.04706
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X173.21 Y164.64 E.10664
G1 X173.21 Y163.06 E.04706
G1 X176.73 Y163.06 E.10485
M204 S10000
G1 X176.194 Y163.85 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1200
M204 S8000
G1 X173.806 Y163.85 E.07337
; CHANGE_LAYER
; Z_HEIGHT: 3.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.259
G1 X175.806 Y163.85 E-.76
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
G3 Z3.4 I.679 J1.01 P1  F60000
G1 X176.398 Y163.452 Z3.4
G1 Z3.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X176.398 Y164.248 E.02559
G1 X173.602 Y164.248 E.08991
G1 X173.602 Y163.452 E.02559
G1 X176.338 Y163.452 E.08798
; COOLING_NODE: 1
M204 S250
G1 X176.79 Y163.06 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X176.79 Y164.64 E.04706
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X173.21 Y164.64 E.10664
G1 X173.21 Y163.06 E.04706
G1 X176.73 Y163.06 E.10485
M204 S10000
G1 X176.194 Y163.85 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1200
M204 S8000
G1 X173.806 Y163.85 E.07337
; CHANGE_LAYER
; Z_HEIGHT: 3.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.259
G1 X175.806 Y163.85 E-.76
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
G3 Z3.6 I.679 J1.01 P1  F60000
G1 X176.398 Y163.452 Z3.6
G1 Z3.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X176.398 Y164.248 E.02559
G1 X173.602 Y164.248 E.08991
G1 X173.602 Y163.452 E.02559
G1 X176.338 Y163.452 E.08798
; COOLING_NODE: 1
M204 S250
G1 X176.79 Y163.06 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X176.79 Y164.64 E.04706
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X173.21 Y164.64 E.10664
G1 X173.21 Y163.06 E.04706
G1 X176.73 Y163.06 E.10485
M204 S10000
G1 X176.194 Y163.85 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1200
M204 S8000
G1 X173.806 Y163.85 E.07337
; CHANGE_LAYER
; Z_HEIGHT: 3.6
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.259
G1 X175.806 Y163.85 E-.76
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
G3 Z3.8 I.679 J1.01 P1  F60000
G1 X176.398 Y163.452 Z3.8
G1 Z3.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X176.398 Y164.248 E.02559
G1 X173.602 Y164.248 E.08991
G1 X173.602 Y163.452 E.02559
G1 X176.338 Y163.452 E.08798
; COOLING_NODE: 1
M204 S250
G1 X176.79 Y163.06 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X176.79 Y164.64 E.04706
;======== H2D 20260731========
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
G1 X173.21 Y164.64 E.10664
G1 X173.21 Y163.06 E.04706
G1 X176.73 Y163.06 E.10485
M204 S10000
G1 X176.194 Y163.85 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1200
M204 S8000
G1 X173.806 Y163.85 E.07337
; CHANGE_LAYER
; Z_HEIGHT: 3.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.259
G1 X175.806 Y163.85 E-.76
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
G3 Z4 I.679 J1.01 P1  F60000
G1 X176.398 Y163.452 Z4
G1 Z3.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X176.398 Y164.248 E.02559
G1 X173.602 Y164.248 E.08991
G1 X173.602 Y163.452 E.02559
G1 X176.338 Y163.452 E.08798
; COOLING_NODE: 1
M204 S250
G1 X176.79 Y163.06 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X176.79 Y164.64 E.04706
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X173.21 Y164.64 E.10664
G1 X173.21 Y163.06 E.04706
G1 X176.73 Y163.06 E.10485
M204 S10000
G1 X176.194 Y163.85 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1200
M204 S8000
G1 X173.806 Y163.85 E.07337
; CHANGE_LAYER
; Z_HEIGHT: 4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.259
G1 X175.806 Y163.85 E-.76
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
G3 Z4.2 I.679 J1.01 P1  F60000
G1 X176.398 Y163.452 Z4.2
G1 Z4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X176.398 Y164.248 E.02559
G1 X173.602 Y164.248 E.08991
M73 P94 R0
G1 X173.602 Y163.452 E.02559
G1 X176.338 Y163.452 E.08798
; COOLING_NODE: 1
M204 S250
G1 X176.79 Y163.06 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X176.79 Y164.64 E.04706
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X173.21 Y164.64 E.10664
G1 X173.21 Y163.06 E.04706
G1 X176.73 Y163.06 E.10485
M204 S10000
G1 X176.194 Y163.85 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1200
M204 S8000
G1 X173.806 Y163.85 E.07337
; CHANGE_LAYER
; Z_HEIGHT: 4.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.259
G1 X175.806 Y163.85 E-.76
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
G3 Z4.4 I.679 J1.01 P1  F60000
G1 X176.398 Y163.452 Z4.4
G1 Z4.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X176.398 Y164.248 E.02559
G1 X173.602 Y164.248 E.08991
G1 X173.602 Y163.452 E.02559
G1 X176.338 Y163.452 E.08798
; COOLING_NODE: 1
M204 S250
G1 X176.79 Y163.06 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X176.79 Y164.64 E.04706
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X173.21 Y164.64 E.10664
G1 X173.21 Y163.06 E.04706
G1 X176.73 Y163.06 E.10485
M204 S10000
G1 X176.194 Y163.85 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1200
M204 S8000
G1 X173.806 Y163.85 E.07337
; CHANGE_LAYER
; Z_HEIGHT: 4.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.259
G1 X175.806 Y163.85 E-.76
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
G3 Z4.6 I.679 J1.01 P1  F60000
G1 X176.398 Y163.452 Z4.6
M73 P95 R0
G1 Z4.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X176.398 Y164.248 E.02559
G1 X173.602 Y164.248 E.08991
G1 X173.602 Y163.452 E.02559
G1 X176.338 Y163.452 E.08798
; COOLING_NODE: 1
M204 S250
G1 X176.79 Y163.06 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X176.79 Y164.64 E.04706
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X173.21 Y164.64 E.10664
G1 X173.21 Y163.06 E.04706
G1 X176.73 Y163.06 E.10485
M204 S10000
G1 X176.194 Y163.85 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1200
M204 S8000
G1 X173.806 Y163.85 E.07337
; CHANGE_LAYER
; Z_HEIGHT: 4.6
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.259
G1 X175.806 Y163.85 E-.76
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
G3 Z4.8 I.679 J1.01 P1  F60000
G1 X176.398 Y163.452 Z4.8
G1 Z4.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X176.398 Y164.248 E.02559
G1 X173.602 Y164.248 E.08991
G1 X173.602 Y163.452 E.02559
G1 X176.338 Y163.452 E.08798
; COOLING_NODE: 1
M204 S250
G1 X176.79 Y163.06 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X176.79 Y164.64 E.04706
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X173.21 Y164.64 E.10664
G1 X173.21 Y163.06 E.04706
G1 X176.73 Y163.06 E.10485
M204 S10000
G1 X176.194 Y163.85 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1200
M204 S8000
G1 X173.806 Y163.85 E.07337
; CHANGE_LAYER
; Z_HEIGHT: 4.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.259
G1 X175.806 Y163.85 E-.76
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
G3 Z5 I.679 J1.01 P1  F60000
G1 X176.398 Y163.452 Z5
G1 Z4.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X176.398 Y164.248 E.02559
G1 X173.602 Y164.248 E.08991
G1 X173.602 Y163.452 E.02559
G1 X176.338 Y163.452 E.08798
; COOLING_NODE: 1
M204 S250
G1 X176.79 Y163.06 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X176.79 Y164.64 E.04706
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X173.21 Y164.64 E.10664
G1 X173.21 Y163.06 E.04706
G1 X176.73 Y163.06 E.10485
M204 S10000
G1 X176.194 Y163.85 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1200
M204 S8000
G1 X173.806 Y163.85 E.07337
; CHANGE_LAYER
; Z_HEIGHT: 5
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.259
G1 X175.806 Y163.85 E-.76
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
G3 Z5.2 I.679 J1.01 P1  F60000
G1 X176.398 Y163.452 Z5.2
G1 Z5
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X176.398 Y164.248 E.02559
G1 X173.602 Y164.248 E.08991
G1 X173.602 Y163.452 E.02559
G1 X176.338 Y163.452 E.08798
; COOLING_NODE: 1
M204 S250
G1 X176.79 Y163.06 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X176.79 Y164.64 E.04706
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X173.21 Y164.64 E.10664
G1 X173.21 Y163.06 E.04706
G1 X176.73 Y163.06 E.10485
M204 S10000
G1 X176.194 Y163.85 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1200
M204 S8000
G1 X173.806 Y163.85 E.07337
; CHANGE_LAYER
; Z_HEIGHT: 5.2
; LAYER_HEIGHT: 0.2
; WIPE_START
M73 P96 R0
G1 F9259.259
G1 X175.806 Y163.85 E-.76
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
G3 Z5.4 I.679 J1.01 P1  F60000
G1 X176.398 Y163.452 Z5.4
G1 Z5.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X176.398 Y164.248 E.02559
G1 X173.602 Y164.248 E.08991
G1 X173.602 Y163.452 E.02559
G1 X176.338 Y163.452 E.08798
; COOLING_NODE: 1
M204 S250
G1 X176.79 Y163.06 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X176.79 Y164.64 E.04706
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X173.21 Y164.64 E.10664
G1 X173.21 Y163.06 E.04706
G1 X176.73 Y163.06 E.10485
M204 S10000
G1 X176.194 Y163.85 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1200
M204 S8000
G1 X173.806 Y163.85 E.07337
; CHANGE_LAYER
; Z_HEIGHT: 5.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.259
G1 X175.806 Y163.85 E-.76
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
G3 Z5.6 I.679 J1.01 P1  F60000
G1 X176.398 Y163.452 Z5.6
G1 Z5.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X176.398 Y164.248 E.02559
G1 X173.602 Y164.248 E.08991
G1 X173.602 Y163.452 E.02559
G1 X176.338 Y163.452 E.08798
; COOLING_NODE: 1
M204 S250
G1 X176.79 Y163.06 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X176.79 Y164.64 E.04706
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X173.21 Y164.64 E.10664
G1 X173.21 Y163.06 E.04706
G1 X176.73 Y163.06 E.10485
M204 S10000
G1 X176.194 Y163.85 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1200
M204 S8000
G1 X173.806 Y163.85 E.07337
; CHANGE_LAYER
; Z_HEIGHT: 5.6
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.259
G1 X175.806 Y163.85 E-.76
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
G3 Z5.8 I.679 J1.01 P1  F60000
G1 X176.398 Y163.452 Z5.8
G1 Z5.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X176.398 Y164.248 E.02559
G1 X173.602 Y164.248 E.08991
G1 X173.602 Y163.452 E.02559
G1 X176.338 Y163.452 E.08798
; COOLING_NODE: 1
M204 S250
G1 X176.79 Y163.06 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X176.79 Y164.64 E.04706
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X173.21 Y164.64 E.10664
G1 X173.21 Y163.06 E.04706
G1 X176.73 Y163.06 E.10485
M204 S10000
G1 X176.194 Y163.85 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1200
M204 S8000
G1 X173.806 Y163.85 E.07337
; CHANGE_LAYER
; Z_HEIGHT: 5.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.259
G1 X175.806 Y163.85 E-.76
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
G3 Z6 I.679 J1.01 P1  F60000
G1 X176.398 Y163.452 Z6
G1 Z5.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X176.398 Y164.248 E.02559
G1 X173.602 Y164.248 E.08991
G1 X173.602 Y163.452 E.02559
G1 X176.338 Y163.452 E.08798
; COOLING_NODE: 1
M204 S250
G1 X176.79 Y163.06 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X176.79 Y164.64 E.04706
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X173.21 Y164.64 E.10664
G1 X173.21 Y163.06 E.04706
G1 X176.73 Y163.06 E.10485
M204 S10000
G1 X176.194 Y163.85 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
M73 P97 R0
G1 F1200
M204 S8000
G1 X173.806 Y163.85 E.07337
; CHANGE_LAYER
; Z_HEIGHT: 6
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.259
G1 X175.806 Y163.85 E-.76
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
G3 Z6.2 I.679 J1.01 P1  F60000
G1 X176.398 Y163.452 Z6.2
G1 Z6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X176.398 Y164.248 E.02559
G1 X173.602 Y164.248 E.08991
G1 X173.602 Y163.452 E.02559
G1 X176.338 Y163.452 E.08798
; COOLING_NODE: 1
M204 S250
G1 X176.79 Y163.06 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X176.79 Y164.64 E.04706
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X173.21 Y164.64 E.10664
G1 X173.21 Y163.06 E.04706
G1 X176.73 Y163.06 E.10485
M204 S10000
G1 X176.194 Y163.85 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1200
M204 S8000
G1 X173.806 Y163.85 E.07337
; CHANGE_LAYER
; Z_HEIGHT: 6.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.259
G1 X175.806 Y163.85 E-.76
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
G3 Z6.4 I.679 J1.01 P1  F60000
G1 X176.398 Y163.452 Z6.4
G1 Z6.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X176.398 Y164.248 E.02559
G1 X173.602 Y164.248 E.08991
G1 X173.602 Y163.452 E.02559
G1 X176.338 Y163.452 E.08798
; COOLING_NODE: 1
M204 S250
G1 X176.79 Y163.06 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X176.79 Y164.64 E.04706
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X173.21 Y164.64 E.10664
G1 X173.21 Y163.06 E.04706
G1 X176.73 Y163.06 E.10485
M204 S10000
G1 X176.194 Y163.85 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1200
M204 S8000
G1 X173.806 Y163.85 E.07337
; CHANGE_LAYER
; Z_HEIGHT: 6.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.259
G1 X175.806 Y163.85 E-.76
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
G3 Z6.6 I.762 J.949 P1  F60000
G1 X176.79 Y163.06 Z6.6
G1 Z6.4
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X176.79 Y164.64 E.04706
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X173.21 Y164.64 E.10664
G1 X173.21 Y163.06 E.04706
G1 X176.73 Y163.06 E.10485
M204 S10000
G1 X176.583 Y164.017 F60000
; FEATURE: Top surface
G1 F1200
M204 S2000
G1 X176.167 Y164.433 E.01753
G1 X176.033 Y164.566
G1 X175.5 Y164.566
G1 X175.633 Y164.433
G1 X176.583 Y163.483 E.03999
G1 X176.716 Y163.35
G1 X176.399 Y163.134
G1 X176.265 Y163.267
G1 X175.1 Y164.433 E.04909
G1 X174.966 Y164.566
G1 X174.433 Y164.566
G1 X174.567 Y164.433
G1 X175.732 Y163.267 E.04909
G1 X175.866 Y163.134
G1 X175.332 Y163.134
G1 X175.199 Y163.267
G1 X174.033 Y164.433 E.04909
G1 X173.9 Y164.566
G1 X173.367 Y164.566
G1 X173.5 Y164.433
G1 X174.665 Y163.267 E.04909
G1 X174.799 Y163.134
G1 X174.266 Y163.134
G1 X174.132 Y163.267
G1 X173.417 Y163.982 E.03011
; close powerlost recovery
M1003 S0
; WIPE_START
G1 F9547.055
M204 S8000
G1 X174.132 Y163.267 E-.38416
G1 X174.266 Y163.134 E-.07182
G1 X174.799 Y163.134 E-.20264
G1 X174.665 Y163.267 E-.07182
G1 X174.61 Y163.322 E-.02957
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

