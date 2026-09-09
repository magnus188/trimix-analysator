; HEADER_BLOCK_START
; BambuStudio 02.08.02.61
; model printing time: 10m 53s; total estimated time: 16m 20s
; total layer number: 85
; total filament length [mm] : 953.06
; total filament volume [cm^3] : 2292.37
; total filament weight [g] : 2.84
; filament_density: 1.24
; filament_diameter: 1.75
; max_z_height: 12.20
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
M73 P0 R16
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
M73 P2 R15
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
M73 P5 R15
G1 Z5 F1200
G90
G1 X175 Y160 F30000

M622 J1
    M1002 gcode_claim_action : 1
    G29.20 A3
    G29 A1 O X158.293 Y146.443 I33.4131 J27.1131 R
    M400
M623

M622 J2
    M1002 gcode_claim_action : 1
    
        G29.20 A4
        G29 A2 O X158.293 Y146.443 I33.4131 J27.1131 R
    
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
M73 P31 R11
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
    G1 Z5 F1200
    G1 X270 Y-0.5 F60000
    G28.14 R0
    G29.2 S0
    G91
M73 P32 R11
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
; layer num/total_layer_count: 1/85
; update layer progress
M73 L1
M991 S0 P0 ;notify layer change

M106 S0
M106 P2 S0
; OBJECT_ID: 15
G1 X159.472 Y147.824 F60000
M204 S6000
M73 P33 R10
G1 Z.4
G1 Z.2
G1 E.8 F1800
; FEATURE: Brim
; LINE_WIDTH: 0.5
G1 F3000
M204 S500
G1 X159.888 Y147.44 E.02109
G1 X160.362 Y147.128 E.02113
G1 X160.843 Y146.911 E.01967
G1 X161.387 Y146.748 E.02114
G1 X162.112 Y146.672 E.02715
G1 X187.891 Y146.672 E.96016
G1 X188.46 Y146.719 E.02127
G1 X189.275 Y146.961 E.03169
G1 X189.88 Y147.276 E.02537
G1 X190.326 Y147.622 E.02104
G1 X190.71 Y148.038 E.02109
G1 X191.022 Y148.512 E.02113
G1 X191.239 Y148.993 E.01967
G1 X191.402 Y149.537 E.02114
G1 X191.478 Y150.262 E.02716
G1 X191.478 Y169.741 E.7255
G1 X191.431 Y170.31 E.02127
G1 X191.148 Y171.221 E.03555
G1 X190.875 Y171.728 E.02144
G1 X190.528 Y172.176 E.02109
G1 X190.112 Y172.56 E.02109
G1 X189.638 Y172.872 E.02113
G1 X189.157 Y173.089 E.01967
G1 X188.613 Y173.252 E.02114
G1 X187.888 Y173.328 E.02716
G1 X162.109 Y173.328 E.96015
G1 X161.54 Y173.281 E.02127
G1 X160.629 Y172.998 E.03555
G1 X160.122 Y172.725 E.02144
G1 X159.674 Y172.378 E.02109
G1 X159.29 Y171.962 E.02109
G1 X158.978 Y171.488 E.02113
G1 X158.761 Y171.007 E.01967
G1 X158.598 Y170.463 E.02114
G1 X158.522 Y169.738 E.02715
G1 X158.522 Y150.259 E.72551
G1 X158.569 Y149.69 E.02127
G1 X158.852 Y148.779 E.03555
G1 X159.125 Y148.272 E.02144
G1 X159.435 Y147.871 E.01886
M204 S6000
G1 X159.796 Y148.151 F60000
G1 F3000
M204 S500
G1 X159.803 Y148.143 E.0004
G1 X160.162 Y147.809 E.01826
G1 X160.574 Y147.536 E.0184
G1 X161.012 Y147.338 E.01794
G1 X161.49 Y147.197 E.01855
G1 X162.143 Y147.129 E.02445
G1 X187.877 Y147.13 E.95851
G1 X188.389 Y147.175 E.01911
G1 X189.091 Y147.383 E.02728
G1 X189.621 Y147.656 E.02223
G1 X190.024 Y147.968 E.01896
G1 X190.355 Y148.329 E.01826
G1 X190.614 Y148.724 E.01756
G1 X190.806 Y149.145 E.01726
G1 X190.953 Y149.64 E.01922
G1 X191.02 Y150.279 E.02392
G1 X191.02 Y169.727 E.72438
G1 X190.975 Y170.236 E.01904
G1 X190.718 Y171.055 E.03197
G1 X190.484 Y171.487 E.0183
G1 X190.197 Y171.857 E.01743
G1 X189.838 Y172.191 E.01826
G1 X189.426 Y172.464 E.0184
G1 X188.988 Y172.662 E.01794
G1 X188.51 Y172.803 E.01855
G1 X187.857 Y172.871 E.02445
G1 X162.134 Y172.871 E.95808
G1 X161.614 Y172.825 E.01946
G1 X160.795 Y172.568 E.03197
G1 X160.363 Y172.334 E.0183
G1 X159.993 Y172.047 E.01743
G1 X159.659 Y171.688 E.01826
G1 X159.386 Y171.276 E.0184
G1 X159.188 Y170.838 E.01794
G1 X159.047 Y170.36 E.01855
G1 X158.979 Y169.707 E.02445
G1 X158.979 Y150.284 E.72344
G1 X159.025 Y149.764 E.01946
G1 X159.282 Y148.945 E.03197
G1 X159.516 Y148.513 E.0183
G1 X159.759 Y148.199 E.01479
M204 S6000
G1 X160.122 Y148.477 F60000
G1 F3000
M204 S500
G1 X160.135 Y148.461 E.00077
G1 X160.437 Y148.177 E.01545
G1 X160.786 Y147.944 E.01564
G1 X161.181 Y147.764 E.01615
G1 X161.592 Y147.646 E.01592
G1 X162.174 Y147.586 E.02179
G1 X187.851 Y147.587 E.95639
G1 X188.316 Y147.63 E.01738
G1 X188.907 Y147.805 E.02297
G1 X189.363 Y148.038 E.01907
G1 X189.721 Y148.314 E.01685
G1 X189.999 Y148.62 E.01541
G1 X190.207 Y148.936 E.01407
G1 X190.373 Y149.297 E.01481
G1 X190.504 Y149.742 E.01728
G1 X190.562 Y150.295 E.02071
G1 X190.563 Y169.713 E.72323
G1 X190.52 Y170.161 E.01676
G1 X190.289 Y170.888 E.02841
G1 X190.105 Y171.227 E.01436
G1 X189.865 Y171.539 E.01467
G1 X189.563 Y171.823 E.01545
G1 X189.214 Y172.056 E.01564
G1 X188.819 Y172.236 E.01615
G1 X188.408 Y172.354 E.01592
G1 X187.826 Y172.414 E.0218
G1 X162.16 Y172.414 E.95596
G1 X161.689 Y172.37 E.01763
G1 X160.962 Y172.139 E.0284
G1 X160.623 Y171.955 E.01436
M73 P34 R10
G1 X160.311 Y171.715 E.01467
G1 X160.027 Y171.413 E.01545
G1 X159.794 Y171.064 E.01564
G1 X159.614 Y170.669 E.01615
G1 X159.496 Y170.258 E.01592
G1 X159.436 Y169.676 E.02179
G1 X159.436 Y150.31 E.72132
G1 X159.48 Y149.839 E.01763
G1 X159.711 Y149.112 E.0284
G1 X159.895 Y148.773 E.01436
G1 X160.086 Y148.525 E.01166
M204 S6000
G1 X160.448 Y148.803 F60000
G1 F3000
M204 S500
G1 X160.468 Y148.778 E.00121
G1 X160.714 Y148.544 E.01265
G1 X161.019 Y148.34 E.01367
G1 X161.349 Y148.192 E.01348
G1 X161.691 Y148.095 E.01323
G1 X162.204 Y148.043 E.01919
G1 X187.823 Y148.044 E.95423
G1 X188.242 Y148.085 E.01565
G1 X188.725 Y148.228 E.01878
G1 X189.106 Y148.42 E.0159
G1 X189.418 Y148.66 E.01467
G1 X189.643 Y148.91 E.01252
G1 X189.81 Y149.168 E.01144
G1 X189.94 Y149.45 E.01155
G1 X190.056 Y149.844 E.01532
G1 X190.105 Y150.312 E.01753
G1 X190.106 Y169.684 E.72154
G1 X190.065 Y170.083 E.01491
G1 X189.86 Y170.72 E.02492
G1 X189.714 Y170.986 E.0113
G1 X189.532 Y171.222 E.01113
G1 X189.286 Y171.456 E.01265
G1 X188.981 Y171.66 E.01367
G1 X188.651 Y171.808 E.01348
G1 X188.309 Y171.905 E.01323
G1 X187.796 Y171.957 E.0192
G1 X162.188 Y171.957 E.9538
G1 X161.766 Y171.915 E.01579
G1 X161.13 Y171.71 E.02488
G1 X160.864 Y171.564 E.0113
G1 X160.628 Y171.382 E.01113
G1 X160.394 Y171.136 E.01265
G1 X160.19 Y170.831 E.01367
G1 X160.042 Y170.501 E.01348
G1 X159.945 Y170.159 E.01323
G1 X159.893 Y169.646 E.01919
G1 X159.893 Y150.338 E.71915
G1 X159.935 Y149.916 E.01578
G1 X160.14 Y149.28 E.02488
G1 X160.286 Y149.014 E.0113
G1 X160.412 Y148.851 E.00769
M204 S6000
G1 X160.795 Y149.137 F60000
G1 F3000
M204 S500
G1 X160.882 Y149.021 E.00539
G1 X161.142 Y148.81 E.01248
G1 X161.396 Y148.669 E.01084
G1 X161.628 Y148.587 E.00914
G1 X162.135 Y148.5 E.01917
G1 X187.872 Y148.5 E.95861
G1 X188.172 Y148.535 E.01126
G1 X188.489 Y148.623 E.01226
G1 X188.594 Y148.669 E.00426
G1 X188.994 Y148.913 E.01743
G1 X189.253 Y149.175 E.01374
G1 X189.483 Y149.552 E.01644
G1 X189.563 Y149.778 E.00892
G1 X189.65 Y150.285 E.01917
G1 X189.65 Y169.722 E.72395
G1 X189.615 Y170.022 E.01127
G1 X189.527 Y170.339 E.01225
G1 X189.481 Y170.444 E.00426
G1 X189.237 Y170.844 E.01743
G1 X188.975 Y171.103 E.01375
G1 X188.598 Y171.333 E.01643
G1 X188.372 Y171.413 E.00892
G1 X187.865 Y171.5 E.01917
G1 X162.128 Y171.5 E.95861
G1 X161.828 Y171.465 E.01127
G1 X161.511 Y171.377 E.01225
G1 X161.406 Y171.331 E.00426
G1 X161.006 Y171.087 E.01743
G1 X160.747 Y170.825 E.01375
G1 X160.517 Y170.448 E.01643
G1 X160.437 Y170.222 E.00892
G1 X160.35 Y169.715 E.01917
G1 X160.35 Y150.28 E.7239
G1 X160.405 Y149.888 E.01473
G1 X160.504 Y149.581 E.01201
G1 X160.595 Y149.405 E.0074
G1 X160.759 Y149.185 E.01019
M204 S6000
G1 X161.127 Y149.44 F60000
G1 F3000
M204 S500
G1 X161.173 Y149.373 E.00305
G1 X161.365 Y149.209 E.00939
G1 X161.558 Y149.096 E.00833
G1 X161.705 Y149.038 E.0059
G1 X162.123 Y148.957 E.01585
G1 X187.88 Y148.957 E.95934
G1 X188.121 Y148.989 E.00905
G1 X188.363 Y149.063 E.00942
G1 X188.677 Y149.242 E.01349
G1 X188.862 Y149.412 E.00936
G1 X189.055 Y149.711 E.01324
G1 X189.112 Y149.855 E.00579
G1 X189.193 Y150.273 E.01585
G1 X189.193 Y169.73 E.72469
G1 X189.161 Y169.971 E.00906
G1 X189.088 Y170.213 E.00942
G1 X188.908 Y170.527 E.01348
G1 X188.738 Y170.713 E.00937
G1 X188.439 Y170.905 E.01324
G1 X188.295 Y170.962 E.00579
G1 X187.877 Y171.043 E.01585
G1 X162.12 Y171.043 E.95934
G1 X161.879 Y171.011 E.00906
G1 X161.637 Y170.938 E.00942
G1 X161.323 Y170.758 E.01348
G1 X161.138 Y170.588 E.00937
G1 X160.945 Y170.289 E.01324
G1 X160.888 Y170.145 E.00579
G1 X160.807 Y169.727 E.01585
G1 X160.807 Y150.27 E.72469
G1 X160.839 Y150.029 E.00905
G1 X160.914 Y149.782 E.00962
G1 X160.966 Y149.672 E.00453
G1 X161.093 Y149.49 E.00827
M204 S6000
G1 X161.471 Y149.728 F60000
G1 F3000
M204 S500
G1 X161.483 Y149.708 E.00088
G1 X161.585 Y149.61 E.00529
G1 X161.798 Y149.485 E.00918
G1 X162.11 Y149.414 E.01191
G1 X187.889 Y149.414 E.96016
G1 X188.055 Y149.441 E.00626
G1 X188.23 Y149.5 E.00687
G1 X188.442 Y149.633 E.00934
G1 X188.54 Y149.735 E.00529
G1 X188.665 Y149.948 E.00918
G1 X188.736 Y150.26 E.01191
G1 X188.736 Y169.739 E.72551
G1 X188.709 Y169.905 E.00626
G1 X188.65 Y170.08 E.00687
G1 X188.517 Y170.292 E.00934
G1 X188.415 Y170.39 E.00529
G1 X188.202 Y170.515 E.00918
G1 X187.89 Y170.586 E.01191
G1 X162.111 Y170.586 E.96016
G1 X161.945 Y170.559 E.00626
G1 X161.77 Y170.501 E.00687
G1 X161.558 Y170.367 E.00934
G1 X161.46 Y170.265 E.00529
G1 X161.335 Y170.052 E.00918
G1 X161.264 Y169.74 E.01191
G1 X161.264 Y150.261 E.72551
G1 X161.291 Y150.095 E.00626
G1 X161.35 Y149.92 E.00687
G1 X161.439 Y149.779 E.00622
M204 S6000
G1 X161.788 Y150.049 F60000
G1 F3000
M204 S500
G1 X161.914 Y149.927 E.00651
G1 X162.1 Y149.871 E.00722
G1 X187.9 Y149.871 E.96095
G1 X188.101 Y149.938 E.0079
G1 X188.223 Y150.064 E.00651
G1 X188.279 Y150.25 E.00722
M73 P35 R10
G1 X188.279 Y169.75 E.7263
G1 X188.212 Y169.951 E.0079
G1 X188.086 Y170.073 E.00651
G1 X187.9 Y170.129 E.00722
G1 X162.1 Y170.129 E.96095
G1 X161.899 Y170.062 E.0079
G1 X161.777 Y169.936 E.00651
G1 X161.721 Y169.75 E.00722
G1 X161.721 Y150.25 E.7263
G1 X161.769 Y150.106 E.00566
; WIPE_START
G1 X161.914 Y149.927 E-.08729
G1 X162.1 Y149.871 E-.07367
G1 X163.676 Y149.871 E-.59903
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X169.585 Y154.703 Z.6 F60000
G1 X187.5 Y169.35 Z.6
G1 Z.2
G1 E.8 F1800
; FEATURE: Outer wall
G1 F3000
M204 S500
G1 X162.5 Y169.35 E.93116
G1 X162.5 Y150.65 E.6965
G1 X187.5 Y150.65 E.93116
G1 X187.5 Y169.29 E.69427
;======== H2D 20260731========
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
G1 X187.043 Y168.893 F60000
; FEATURE: Inner wall
G1 F3000
M204 S500
G1 X162.957 Y168.893 E.89711
G1 X162.957 Y151.107 E.66246
G1 X187.043 Y151.107 E.89711
G1 X187.043 Y168.833 E.66022
M204 S6000
G1 X186.586 Y168.436 F60000
G1 F3000
M204 S500
G1 X163.414 Y168.436 E.86306
G1 X163.414 Y151.564 E.62841
G1 X186.586 Y151.564 E.86306
G1 X186.586 Y168.376 E.62617
M204 S6000
G1 X186.129 Y167.979 F60000
G1 F3000
M204 S500
G1 X163.871 Y167.979 E.82901
G1 X163.871 Y152.021 E.59436
G1 X186.129 Y152.021 E.82901
G1 X186.129 Y167.919 E.59213
; WIPE_START
G1 X184.129 Y167.924 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X184.561 Y160.304 Z.6 F60000
G1 X185.02 Y152.204 Z.6
M73 P36 R10
G1 Z.2
G1 E.8 F1800
; FEATURE: Bottom surface
; LINE_WIDTH: 0.50101
G1 F6300
M204 S500
G1 X185.74 Y152.924 E.03803
G1 X185.74 Y153.572 E.02418
G1 X184.578 Y152.41 E.06137
G1 X183.93 Y152.41 E.02418
G1 X185.74 Y154.22 E.09557
G1 X185.74 Y154.868 E.02418
G1 X183.282 Y152.41 E.12977
G1 X182.634 Y152.41 E.02418
G1 X185.74 Y155.516 E.16397
G1 X185.74 Y156.164 E.02418
G1 X181.986 Y152.41 E.19817
G1 X181.339 Y152.41 E.02418
G1 X185.74 Y156.811 E.23237
G1 X185.74 Y157.459 E.02418
G1 X180.691 Y152.41 E.26657
G1 X180.043 Y152.41 E.02418
G1 X185.74 Y158.107 E.30077
G1 X185.74 Y158.755 E.02418
G1 X179.395 Y152.41 E.33497
G1 X178.747 Y152.41 E.02418
G1 X185.74 Y159.403 E.36917
G1 X185.74 Y160.051 E.02418
G1 X178.099 Y152.41 E.40337
G1 X177.451 Y152.41 E.02418
G1 X185.74 Y160.699 E.43757
G1 X185.74 Y161.346 E.02418
G1 X176.804 Y152.41 E.47177
G1 X176.156 Y152.41 E.02418
G1 X185.74 Y161.994 E.50597
G1 X185.74 Y162.642 E.02418
G1 X175.508 Y152.41 E.54017
G1 X174.86 Y152.41 E.02418
G1 X185.74 Y163.29 E.57437
G1 X185.74 Y163.938 E.02418
G1 X174.212 Y152.41 E.60857
G1 X173.564 Y152.41 E.02418
G1 X185.74 Y164.586 E.64277
G1 X185.74 Y165.233 E.02418
G1 X172.917 Y152.41 E.67697
G1 X172.269 Y152.41 E.02418
G1 X185.74 Y165.881 E.71117
G1 X185.74 Y166.529 E.02418
G1 X171.621 Y152.41 E.74537
G1 X170.973 Y152.41 E.02418
G1 X185.74 Y167.177 E.77957
G1 X185.74 Y167.59 E.01543
G1 X185.506 Y167.59 E.00875
G1 X170.325 Y152.41 E.80139
G1 X169.677 Y152.41 E.02418
G1 X184.858 Y167.59 E.80139
G1 X184.21 Y167.59 E.02418
G1 X169.03 Y152.41 E.80139
G1 X168.382 Y152.41 E.02418
G1 X183.562 Y167.59 E.80139
G1 X182.915 Y167.59 E.02418
G1 X167.734 Y152.41 E.80139
G1 X167.086 Y152.41 E.02418
G1 X182.267 Y167.59 E.80139
G1 X181.619 Y167.59 E.02418
G1 X166.438 Y152.41 E.80139
G1 X165.79 Y152.41 E.02418
G1 X180.971 Y167.59 E.80139
G1 X180.323 Y167.59 E.02418
M73 P37 R10
G1 X165.143 Y152.41 E.80139
G1 X164.495 Y152.41 E.02418
G1 X179.675 Y167.59 E.80139
G1 X179.027 Y167.59 E.02418
G1 X164.26 Y152.823 E.7796
G1 X164.26 Y153.47 E.02418
G1 X178.38 Y167.59 E.7454
G1 X177.732 Y167.59 E.02418
G1 X164.26 Y154.118 E.7112
G1 X164.26 Y154.766 E.02418
G1 X177.084 Y167.59 E.677
G1 X176.436 Y167.59 E.02418
G1 X164.26 Y155.414 E.6428
G1 X164.26 Y156.062 E.02418
G1 X175.788 Y167.59 E.6086
G1 X175.14 Y167.59 E.02418
G1 X164.26 Y156.71 E.5744
G1 X164.26 Y157.357 E.02418
G1 X174.493 Y167.59 E.5402
G1 X173.845 Y167.59 E.02418
G1 X164.26 Y158.005 E.506
G1 X164.26 Y158.653 E.02418
G1 X173.197 Y167.59 E.4718
G1 X172.549 Y167.59 E.02418
G1 X164.26 Y159.301 E.4376
G1 X164.26 Y159.949 E.02418
G1 X171.901 Y167.59 E.4034
G1 X171.253 Y167.59 E.02418
G1 X164.26 Y160.597 E.3692
G1 X164.26 Y161.244 E.02418
G1 X170.606 Y167.59 E.335
G1 X169.958 Y167.59 E.02418
G1 X164.26 Y161.892 E.3008
G1 X164.26 Y162.54 E.02418
G1 X169.31 Y167.59 E.2666
G1 X168.662 Y167.59 E.02418
G1 X164.26 Y163.188 E.2324
G1 X164.26 Y163.836 E.02418
G1 X168.014 Y167.59 E.1982
G1 X167.366 Y167.59 E.02418
G1 X164.26 Y164.484 E.164
G1 X164.26 Y165.131 E.02418
G1 X166.719 Y167.59 E.1298
G1 X166.071 Y167.59 E.02418
G1 X164.26 Y165.779 E.0956
G1 X164.26 Y166.427 E.02418
G1 X165.423 Y167.59 E.0614
G1 X164.775 Y167.59 E.02418
G1 X164.054 Y166.869 E.03806
; CHANGE_LAYER
; Z_HEIGHT: 0.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F6300
G1 X164.775 Y167.59 E-.38748
G1 X165.423 Y167.59 E-.24618
G1 X165.188 Y167.355 E-.12635
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 2/85
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
G3 Z.6 I-.056 J1.216 P1  F60000
G1 X186.484 Y168.334 Z.6
G1 Z.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X163.516 Y168.334 E.76188
G1 X163.516 Y151.666 E.55289
G1 X186.484 Y151.666 E.76188
G1 X186.484 Y168.274 E.5509
M204 S10000
G1 X186.891 Y168.741 F60000
G1 F8843.478
M204 S8000
G1 X163.109 Y168.741 E.78888
G1 X163.109 Y151.259 E.5799
G1 X186.891 Y151.259 E.78888
G1 X186.891 Y168.681 E.57791
M204 S10000
G1 X187.298 Y169.148 F60000
G1 F8843.478
M204 S8000
G1 X162.702 Y169.148 E.81589
G1 X162.702 Y150.852 E.60691
G1 X187.298 Y150.852 E.81589
G1 X187.298 Y169.088 E.60492
M204 S250
M73 P38 R10
G1 X187.69 Y169.54 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X162.31 Y169.54 E.77986
G1 X162.31 Y150.46 E.58628
G1 X187.69 Y150.46 E.77986
G1 X187.69 Y169.48 E.58443
;======== H2D 20260731========
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
M204 S8000
G1 X185.69 Y169.485 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X185.555 Y168.17 Z.8 F60000
G1 Z.4
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42123
G1 F9516.005
M204 S8000
G1 X186.151 Y167.575 E.02595
G1 X186.151 Y167.04 E.01649
G1 X185.19 Y168.001 E.04188
G1 X184.655 Y168.001 E.01649
G1 X186.151 Y166.505 E.0652
G1 X186.151 Y165.97 E.01649
G1 X184.12 Y168.001 E.08853
G1 X183.585 Y168.001 E.01649
G1 X186.151 Y165.435 E.11185
G1 X186.151 Y164.9 E.01649
G1 X183.05 Y168.001 E.13517
G1 X182.515 Y168.001 E.01649
G1 X186.151 Y164.365 E.1585
G1 X186.151 Y163.83 E.01649
G1 X181.98 Y168.001 E.18182
G1 X181.445 Y168.001 E.01649
G1 X186.151 Y163.295 E.20515
G1 X186.151 Y162.76 E.01649
G1 X180.91 Y168.001 E.22847
G1 X180.375 Y168.001 E.01649
G1 X186.151 Y162.225 E.2518
G1 X186.151 Y161.69 E.01649
G1 X179.84 Y168.001 E.27512
G1 X179.305 Y168.001 E.01649
G1 X186.151 Y161.155 E.29845
G1 X186.151 Y160.62 E.01649
G1 X178.77 Y168.001 E.32177
G1 X178.235 Y168.001 E.01649
G1 X186.151 Y160.085 E.3451
G1 X186.151 Y159.55 E.01649
G1 X177.7 Y168.001 E.36842
G1 X177.165 Y168.001 E.01649
G1 X186.151 Y159.015 E.39175
G1 X186.151 Y158.48 E.01649
G1 X176.63 Y168.001 E.41507
G1 X176.095 Y168.001 E.01649
G1 X186.151 Y157.945 E.4384
G1 X186.151 Y157.41 E.01649
G1 X175.56 Y168.001 E.46172
G1 X175.025 Y168.001 E.01649
G1 X186.151 Y156.875 E.48504
G1 X186.151 Y156.34 E.01649
G1 X174.49 Y168.001 E.50837
G1 X173.955 Y168.001 E.01649
G1 X186.151 Y155.805 E.53169
G1 X186.151 Y155.27 E.01649
G1 X173.42 Y168.001 E.55502
G1 X172.885 Y168.001 E.01649
G1 X186.151 Y154.735 E.57834
G1 X186.151 Y154.2 E.01649
G1 X172.35 Y168.001 E.60167
G1 X171.815 Y168.001 E.01649
G1 X186.151 Y153.665 E.62499
G1 X186.151 Y153.13 E.01649
G1 X171.28 Y168.001 E.64832
G1 X170.745 Y168.001 E.01649
G1 X186.151 Y152.595 E.67164
G1 X186.151 Y152.06 E.01649
G1 X170.21 Y168.001 E.69497
G1 X169.675 Y168.001 E.01649
G1 X185.676 Y151.999 E.69759
G1 X185.141 Y151.999 E.01649
G1 X169.14 Y168.001 E.69759
G1 X168.605 Y168.001 E.01649
G1 X184.606 Y151.999 E.69759
G1 X184.071 Y151.999 E.01649
G1 X168.07 Y168.001 E.69759
G1 X167.535 Y168.001 E.01649
G1 X183.536 Y151.999 E.69759
G1 X183.001 Y151.999 E.01649
G1 X167 Y168.001 E.69759
G1 X166.465 Y168.001 E.01649
G1 X182.466 Y151.999 E.69759
G1 X181.931 Y151.999 E.01649
G1 X165.93 Y168.001 E.69759
G1 X165.395 Y168.001 E.01649
G1 X181.396 Y151.999 E.69759
G1 X180.861 Y151.999 E.01649
G1 X164.86 Y168.001 E.69759
G1 X164.325 Y168.001 E.01649
G1 X180.326 Y151.999 E.69759
G1 X179.791 Y151.999 E.01649
G1 X163.849 Y167.941 E.69498
G1 X163.849 Y167.406 E.01649
G1 X179.256 Y151.999 E.67166
G1 X178.721 Y151.999 E.01649
G1 X163.849 Y166.871 E.64833
G1 X163.849 Y166.336 E.01649
G1 X178.186 Y151.999 E.62501
G1 X177.651 Y151.999 E.01649
G1 X163.849 Y165.801 E.60168
G1 X163.849 Y165.266 E.01649
G1 X177.116 Y151.999 E.57836
G1 X176.581 Y151.999 E.01649
G1 X163.849 Y164.731 E.55503
G1 X163.849 Y164.196 E.01649
G1 X176.046 Y151.999 E.53171
G1 X175.511 Y151.999 E.01649
G1 X163.849 Y163.661 E.50838
G1 X163.849 Y163.126 E.01649
G1 X174.976 Y151.999 E.48506
G1 X174.441 Y151.999 E.01649
G1 X163.849 Y162.591 E.46173
G1 X163.849 Y162.056 E.01649
G1 X173.906 Y151.999 E.43841
G1 X173.371 Y151.999 E.01649
G1 X163.849 Y161.521 E.41509
G1 X163.849 Y160.986 E.01649
G1 X172.836 Y151.999 E.39176
G1 X172.3 Y151.999 E.01649
M73 P38 R9
G1 X163.849 Y160.451 E.36844
G1 X163.849 Y159.915 E.01649
G1 X171.765 Y151.999 E.34511
G1 X171.23 Y151.999 E.01649
G1 X163.849 Y159.38 E.32179
G1 X163.849 Y158.845 E.01649
G1 X170.695 Y151.999 E.29846
G1 X170.16 Y151.999 E.01649
G1 X163.849 Y158.31 E.27514
G1 X163.849 Y157.775 E.01649
G1 X169.625 Y151.999 E.25181
G1 X169.09 Y151.999 E.01649
G1 X163.849 Y157.24 E.22849
G1 X163.849 Y156.705 E.01649
G1 X168.555 Y151.999 E.20516
G1 X168.02 Y151.999 E.01649
G1 X163.849 Y156.17 E.18184
G1 X163.849 Y155.635 E.01649
G1 X167.485 Y151.999 E.15851
G1 X166.95 Y151.999 E.01649
G1 X163.849 Y155.1 E.13519
G1 X163.849 Y154.565 E.01649
G1 X166.415 Y151.999 E.11186
G1 X165.88 Y151.999 E.01649
G1 X163.849 Y154.03 E.08854
G1 X163.849 Y153.495 E.01649
G1 X165.345 Y151.999 E.06522
G1 X164.81 Y151.999 E.01649
G1 X163.849 Y152.96 E.04189
G1 X163.849 Y152.425 E.01649
G1 X164.445 Y151.83 E.02596
; CHANGE_LAYER
; Z_HEIGHT: 0.6
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9516.005
G1 X163.849 Y152.425 E-.32004
G1 X163.849 Y152.96 E-.2033
G1 X164.29 Y152.52 E-.23665
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 3/85
; update layer progress
M73 L3
M991 S0 P2 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z.8 I-.706 J.991 P1  F60000
G1 X186.484 Y168.334 Z.8
G1 Z.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X163.516 Y168.334 E.76188
G1 X163.516 Y151.666 E.55289
M73 P39 R9
G1 X186.484 Y151.666 E.76188
G1 X186.484 Y168.274 E.5509
; COOLING_NODE: 0
M204 S10000
G1 X186.891 Y168.741 F60000
G1 F8843.478
M204 S8000
G1 X163.109 Y168.741 E.78888
G1 X163.109 Y151.259 E.5799
G1 X186.891 Y151.259 E.78888
G1 X186.891 Y168.681 E.57791
; COOLING_NODE: 0
M204 S10000
G1 X187.298 Y169.148 F60000
G1 F8843.478
M204 S8000
G1 X162.702 Y169.148 E.81589
G1 X162.702 Y150.852 E.60691
G1 X187.298 Y150.852 E.81589
G1 X187.298 Y169.088 E.60492
; COOLING_NODE: 0
M204 S250
G1 X187.69 Y169.54 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X162.31 Y169.54 E.77986
G1 X162.31 Y150.46 E.58628
G1 X187.69 Y150.46 E.77986
G1 X187.69 Y169.48 E.58443
;======== H2D 20260731========
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
M204 S8000
G1 X185.69 Y169.485 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X185.975 Y161.858 Z1 F60000
G1 X186.32 Y152.595 Z1
G1 Z.6
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42123
G1 F9516.005
M204 S8000
G1 X185.725 Y151.999 E.02595
G1 X185.19 Y151.999 E.01649
G1 X186.151 Y152.96 E.04188
G1 X186.151 Y153.495 E.01649
G1 X184.655 Y151.999 E.0652
G1 X184.12 Y151.999 E.01649
G1 X186.151 Y154.03 E.08853
G1 X186.151 Y154.565 E.01649
G1 X183.585 Y151.999 E.11185
G1 X183.05 Y151.999 E.01649
G1 X186.151 Y155.1 E.13517
G1 X186.151 Y155.635 E.01649
G1 X182.515 Y151.999 E.1585
G1 X181.98 Y151.999 E.01649
G1 X186.151 Y156.17 E.18182
G1 X186.151 Y156.705 E.01649
G1 X181.445 Y151.999 E.20515
G1 X180.91 Y151.999 E.01649
G1 X186.151 Y157.24 E.22847
G1 X186.151 Y157.775 E.01649
G1 X180.375 Y151.999 E.2518
G1 X179.84 Y151.999 E.01649
G1 X186.151 Y158.31 E.27512
G1 X186.151 Y158.845 E.01649
G1 X179.305 Y151.999 E.29845
G1 X178.77 Y151.999 E.01649
G1 X186.151 Y159.38 E.32177
G1 X186.151 Y159.915 E.01649
G1 X178.235 Y151.999 E.3451
G1 X177.7 Y151.999 E.01649
G1 X186.151 Y160.45 E.36842
G1 X186.151 Y160.985 E.01649
G1 X177.165 Y151.999 E.39175
G1 X176.63 Y151.999 E.01649
G1 X186.151 Y161.52 E.41507
G1 X186.151 Y162.055 E.01649
G1 X176.095 Y151.999 E.4384
G1 X175.56 Y151.999 E.01649
G1 X186.151 Y162.59 E.46172
G1 X186.151 Y163.125 E.01649
G1 X175.025 Y151.999 E.48505
G1 X174.49 Y151.999 E.01649
G1 X186.151 Y163.66 E.50837
G1 X186.151 Y164.195 E.01649
G1 X173.955 Y151.999 E.53169
G1 X173.42 Y151.999 E.01649
G1 X186.151 Y164.73 E.55502
G1 X186.151 Y165.265 E.01649
G1 X172.885 Y151.999 E.57834
G1 X172.35 Y151.999 E.01649
G1 X186.151 Y165.8 E.60167
G1 X186.151 Y166.335 E.01649
G1 X171.815 Y151.999 E.62499
G1 X171.28 Y151.999 E.01649
G1 X186.151 Y166.87 E.64832
G1 X186.151 Y167.405 E.01649
G1 X170.745 Y151.999 E.67164
G1 X170.21 Y151.999 E.01649
G1 X186.151 Y167.94 E.69497
G1 X186.151 Y168.001 E.00186
G1 X185.676 Y168.001 E.01464
G1 X169.675 Y151.999 E.69759
G1 X169.14 Y151.999 E.01649
G1 X185.141 Y168.001 E.69759
G1 X184.606 Y168.001 E.01649
G1 X168.605 Y151.999 E.69759
G1 X168.07 Y151.999 E.01649
G1 X184.071 Y168.001 E.69759
G1 X183.536 Y168.001 E.01649
G1 X167.535 Y151.999 E.69759
G1 X167 Y151.999 E.01649
G1 X183.001 Y168.001 E.69759
G1 X182.466 Y168.001 E.01649
G1 X166.465 Y151.999 E.69759
G1 X165.93 Y151.999 E.01649
G1 X181.931 Y168.001 E.69759
G1 X181.396 Y168.001 E.01649
G1 X165.395 Y151.999 E.69759
G1 X164.86 Y151.999 E.01649
G1 X180.861 Y168.001 E.69759
G1 X180.326 Y168.001 E.01649
G1 X164.325 Y151.999 E.69759
G1 X163.849 Y151.999 E.01465
G1 X163.849 Y152.059 E.00185
G1 X179.791 Y168.001 E.69498
G1 X179.256 Y168.001 E.01649
G1 X163.849 Y152.594 E.67166
G1 X163.849 Y153.129 E.01649
G1 X178.721 Y168.001 E.64833
G1 X178.186 Y168.001 E.01649
G1 X163.849 Y153.664 E.62501
G1 X163.849 Y154.199 E.01649
G1 X177.651 Y168.001 E.60168
G1 X177.116 Y168.001 E.01649
G1 X163.849 Y154.734 E.57836
G1 X163.849 Y155.269 E.01649
G1 X176.581 Y168.001 E.55503
G1 X176.046 Y168.001 E.01649
G1 X163.849 Y155.804 E.53171
G1 X163.849 Y156.339 E.01649
G1 X175.511 Y168.001 E.50838
G1 X174.976 Y168.001 E.01649
G1 X163.849 Y156.874 E.48506
G1 X163.849 Y157.409 E.01649
G1 X174.441 Y168.001 E.46173
G1 X173.906 Y168.001 E.01649
G1 X163.849 Y157.945 E.43841
G1 X163.849 Y158.48 E.01649
G1 X173.371 Y168.001 E.41509
G1 X172.836 Y168.001 E.01649
G1 X163.849 Y159.015 E.39176
G1 X163.849 Y159.55 E.01649
M73 P40 R9
G1 X172.3 Y168.001 E.36844
G1 X171.765 Y168.001 E.01649
G1 X163.849 Y160.085 E.34511
G1 X163.849 Y160.62 E.01649
G1 X171.23 Y168.001 E.32179
G1 X170.695 Y168.001 E.01649
G1 X163.849 Y161.155 E.29846
G1 X163.849 Y161.69 E.01649
G1 X170.16 Y168.001 E.27514
G1 X169.625 Y168.001 E.01649
G1 X163.849 Y162.225 E.25181
G1 X163.849 Y162.76 E.01649
G1 X169.09 Y168.001 E.22849
G1 X168.555 Y168.001 E.01649
G1 X163.849 Y163.295 E.20516
G1 X163.849 Y163.83 E.01649
G1 X168.02 Y168.001 E.18184
G1 X167.485 Y168.001 E.01649
G1 X163.849 Y164.365 E.15851
G1 X163.849 Y164.9 E.01649
G1 X166.95 Y168.001 E.13519
G1 X166.415 Y168.001 E.01649
G1 X163.849 Y165.435 E.11186
G1 X163.849 Y165.97 E.01649
G1 X165.88 Y168.001 E.08854
G1 X165.345 Y168.001 E.01649
G1 X163.849 Y166.505 E.06522
G1 X163.849 Y167.04 E.01649
G1 X164.81 Y168.001 E.04189
G1 X164.275 Y168.001 E.01649
G1 X163.68 Y167.405 E.02596
; CHANGE_LAYER
; Z_HEIGHT: 0.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9516.005
G1 X164.275 Y168.001 E-.32004
G1 X164.81 Y168.001 E-.2033
G1 X164.37 Y167.56 E-.23665
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 4/85
; update layer progress
M73 L4
M991 S0 P3 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z1 I-.043 J1.216 P1  F60000
G1 X186.484 Y168.334 Z1
G1 Z.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X163.516 Y168.334 E.76188
G1 X163.516 Y151.666 E.55289
G1 X186.484 Y151.666 E.76188
G1 X186.484 Y168.274 E.5509
; COOLING_NODE: 0
M204 S10000
G1 X186.891 Y168.741 F60000
G1 F8843.478
M204 S8000
G1 X163.109 Y168.741 E.78888
G1 X163.109 Y151.259 E.5799
G1 X186.891 Y151.259 E.78888
G1 X186.891 Y168.681 E.57791
; COOLING_NODE: 0
M204 S10000
G1 X187.298 Y169.148 F60000
G1 F8843.478
M204 S8000
G1 X162.702 Y169.148 E.81589
G1 X162.702 Y150.852 E.60691
G1 X187.298 Y150.852 E.81589
G1 X187.298 Y169.088 E.60492
; COOLING_NODE: 0
M204 S250
G1 X187.69 Y169.54 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X162.31 Y169.54 E.77986
G1 X162.31 Y150.46 E.58628
G1 X187.69 Y150.46 E.77986
G1 X187.69 Y169.48 E.58443
;======== H2D 20260731========
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
M204 S8000
G1 X185.69 Y169.485 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X185.555 Y168.17 Z1.2 F60000
G1 Z.8
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42123
G1 F9516.005
M204 S8000
G1 X186.151 Y167.575 E.02595
G1 X186.151 Y167.04 E.01649
G1 X185.19 Y168.001 E.04188
G1 X184.655 Y168.001 E.01649
G1 X186.151 Y166.505 E.0652
G1 X186.151 Y165.97 E.01649
G1 X184.12 Y168.001 E.08853
G1 X183.585 Y168.001 E.01649
G1 X186.151 Y165.435 E.11185
G1 X186.151 Y164.9 E.01649
G1 X183.05 Y168.001 E.13517
G1 X182.515 Y168.001 E.01649
G1 X186.151 Y164.365 E.1585
G1 X186.151 Y163.83 E.01649
G1 X181.98 Y168.001 E.18182
G1 X181.445 Y168.001 E.01649
G1 X186.151 Y163.295 E.20515
G1 X186.151 Y162.76 E.01649
G1 X180.91 Y168.001 E.22847
G1 X180.375 Y168.001 E.01649
G1 X186.151 Y162.225 E.2518
G1 X186.151 Y161.69 E.01649
G1 X179.84 Y168.001 E.27512
G1 X179.305 Y168.001 E.01649
G1 X186.151 Y161.155 E.29845
G1 X186.151 Y160.62 E.01649
G1 X178.77 Y168.001 E.32177
G1 X178.235 Y168.001 E.01649
G1 X186.151 Y160.085 E.3451
G1 X186.151 Y159.55 E.01649
G1 X177.7 Y168.001 E.36842
G1 X177.165 Y168.001 E.01649
G1 X186.151 Y159.015 E.39175
G1 X186.151 Y158.48 E.01649
G1 X176.63 Y168.001 E.41507
G1 X176.095 Y168.001 E.01649
G1 X186.151 Y157.945 E.4384
G1 X186.151 Y157.41 E.01649
G1 X175.56 Y168.001 E.46172
G1 X175.025 Y168.001 E.01649
G1 X186.151 Y156.875 E.48504
G1 X186.151 Y156.34 E.01649
G1 X174.49 Y168.001 E.50837
G1 X173.955 Y168.001 E.01649
G1 X186.151 Y155.805 E.53169
G1 X186.151 Y155.27 E.01649
G1 X173.42 Y168.001 E.55502
G1 X172.885 Y168.001 E.01649
G1 X186.151 Y154.735 E.57834
G1 X186.151 Y154.2 E.01649
G1 X172.35 Y168.001 E.60167
G1 X171.815 Y168.001 E.01649
G1 X186.151 Y153.665 E.62499
G1 X186.151 Y153.13 E.01649
G1 X171.28 Y168.001 E.64832
G1 X170.745 Y168.001 E.01649
G1 X186.151 Y152.595 E.67164
G1 X186.151 Y152.06 E.01649
G1 X170.21 Y168.001 E.69497
G1 X169.675 Y168.001 E.01649
G1 X185.676 Y151.999 E.69759
G1 X185.141 Y151.999 E.01649
G1 X169.14 Y168.001 E.69759
G1 X168.605 Y168.001 E.01649
G1 X184.606 Y151.999 E.69759
G1 X184.071 Y151.999 E.01649
G1 X168.07 Y168.001 E.69759
G1 X167.535 Y168.001 E.01649
G1 X183.536 Y151.999 E.69759
G1 X183.001 Y151.999 E.01649
G1 X167 Y168.001 E.69759
G1 X166.465 Y168.001 E.01649
G1 X182.466 Y151.999 E.69759
G1 X181.931 Y151.999 E.01649
G1 X165.93 Y168.001 E.69759
G1 X165.395 Y168.001 E.01649
G1 X181.396 Y151.999 E.69759
G1 X180.861 Y151.999 E.01649
G1 X164.86 Y168.001 E.69759
G1 X164.325 Y168.001 E.01649
G1 X180.326 Y151.999 E.69759
G1 X179.791 Y151.999 E.01649
G1 X163.849 Y167.941 E.69498
G1 X163.849 Y167.406 E.01649
G1 X179.256 Y151.999 E.67166
G1 X178.721 Y151.999 E.01649
G1 X163.849 Y166.871 E.64833
G1 X163.849 Y166.336 E.01649
G1 X178.186 Y151.999 E.62501
G1 X177.651 Y151.999 E.01649
M73 P41 R9
G1 X163.849 Y165.801 E.60168
G1 X163.849 Y165.266 E.01649
G1 X177.116 Y151.999 E.57836
G1 X176.581 Y151.999 E.01649
G1 X163.849 Y164.731 E.55503
G1 X163.849 Y164.196 E.01649
G1 X176.046 Y151.999 E.53171
G1 X175.511 Y151.999 E.01649
G1 X163.849 Y163.661 E.50838
G1 X163.849 Y163.126 E.01649
G1 X174.976 Y151.999 E.48506
G1 X174.441 Y151.999 E.01649
G1 X163.849 Y162.591 E.46173
G1 X163.849 Y162.056 E.01649
G1 X173.906 Y151.999 E.43841
G1 X173.371 Y151.999 E.01649
G1 X163.849 Y161.521 E.41509
G1 X163.849 Y160.986 E.01649
G1 X172.836 Y151.999 E.39176
G1 X172.3 Y151.999 E.01649
G1 X163.849 Y160.451 E.36844
G1 X163.849 Y159.915 E.01649
G1 X171.765 Y151.999 E.34511
G1 X171.23 Y151.999 E.01649
G1 X163.849 Y159.38 E.32179
G1 X163.849 Y158.845 E.01649
G1 X170.695 Y151.999 E.29846
G1 X170.16 Y151.999 E.01649
G1 X163.849 Y158.31 E.27514
G1 X163.849 Y157.775 E.01649
G1 X169.625 Y151.999 E.25181
G1 X169.09 Y151.999 E.01649
G1 X163.849 Y157.24 E.22849
G1 X163.849 Y156.705 E.01649
G1 X168.555 Y151.999 E.20516
G1 X168.02 Y151.999 E.01649
G1 X163.849 Y156.17 E.18184
G1 X163.849 Y155.635 E.01649
G1 X167.485 Y151.999 E.15851
G1 X166.95 Y151.999 E.01649
G1 X163.849 Y155.1 E.13519
G1 X163.849 Y154.565 E.01649
G1 X166.415 Y151.999 E.11186
G1 X165.88 Y151.999 E.01649
G1 X163.849 Y154.03 E.08854
G1 X163.849 Y153.495 E.01649
G1 X165.345 Y151.999 E.06522
G1 X164.81 Y151.999 E.01649
G1 X163.849 Y152.96 E.04189
G1 X163.849 Y152.425 E.01649
G1 X164.445 Y151.83 E.02596
; CHANGE_LAYER
; Z_HEIGHT: 1
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9516.005
G1 X163.849 Y152.425 E-.32004
G1 X163.849 Y152.96 E-.2033
G1 X164.29 Y152.52 E-.23665
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 5/85
; update layer progress
M73 L5
M991 S0 P4 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z1.2 I-.706 J.991 P1  F60000
G1 X186.484 Y168.334 Z1.2
G1 Z1
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X163.516 Y168.334 E.76188
G1 X163.516 Y151.666 E.55289
G1 X186.484 Y151.666 E.76188
G1 X186.484 Y168.274 E.5509
; COOLING_NODE: 0
M204 S10000
G1 X186.891 Y168.741 F60000
G1 F8843.478
M204 S8000
G1 X163.109 Y168.741 E.78888
G1 X163.109 Y151.259 E.5799
G1 X186.891 Y151.259 E.78888
G1 X186.891 Y168.681 E.57791
; COOLING_NODE: 0
M204 S10000
G1 X187.298 Y169.148 F60000
G1 F8843.478
M204 S8000
G1 X162.702 Y169.148 E.81589
G1 X162.702 Y150.852 E.60691
G1 X187.298 Y150.852 E.81589
G1 X187.298 Y169.088 E.60492
; COOLING_NODE: 0
M204 S250
G1 X187.69 Y169.54 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X162.31 Y169.54 E.77986
G1 X162.31 Y150.46 E.58628
G1 X187.69 Y150.46 E.77986
G1 X187.69 Y169.48 E.58443
;======== H2D 20260731========
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
M204 S8000
G1 X185.69 Y169.485 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X185.975 Y161.858 Z1.4 F60000
G1 X186.32 Y152.595 Z1.4
G1 Z1
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42123
G1 F9516.005
M204 S8000
G1 X185.725 Y151.999 E.02595
G1 X185.19 Y151.999 E.01649
G1 X186.151 Y152.96 E.04188
G1 X186.151 Y153.495 E.01649
G1 X184.655 Y151.999 E.0652
G1 X184.12 Y151.999 E.01649
G1 X186.151 Y154.03 E.08853
G1 X186.151 Y154.565 E.01649
G1 X183.585 Y151.999 E.11185
G1 X183.05 Y151.999 E.01649
G1 X186.151 Y155.1 E.13517
G1 X186.151 Y155.635 E.01649
G1 X182.515 Y151.999 E.1585
G1 X181.98 Y151.999 E.01649
G1 X186.151 Y156.17 E.18182
G1 X186.151 Y156.705 E.01649
G1 X181.445 Y151.999 E.20515
G1 X180.91 Y151.999 E.01649
G1 X186.151 Y157.24 E.22847
G1 X186.151 Y157.775 E.01649
G1 X180.375 Y151.999 E.2518
G1 X179.84 Y151.999 E.01649
G1 X186.151 Y158.31 E.27512
G1 X186.151 Y158.845 E.01649
G1 X179.305 Y151.999 E.29845
G1 X178.77 Y151.999 E.01649
G1 X186.151 Y159.38 E.32177
G1 X186.151 Y159.915 E.01649
G1 X178.235 Y151.999 E.3451
G1 X177.7 Y151.999 E.01649
G1 X186.151 Y160.45 E.36842
G1 X186.151 Y160.985 E.01649
G1 X177.165 Y151.999 E.39175
G1 X176.63 Y151.999 E.01649
G1 X186.151 Y161.52 E.41507
G1 X186.151 Y162.055 E.01649
G1 X176.095 Y151.999 E.4384
G1 X175.56 Y151.999 E.01649
G1 X186.151 Y162.59 E.46172
G1 X186.151 Y163.125 E.01649
G1 X175.025 Y151.999 E.48505
G1 X174.49 Y151.999 E.01649
G1 X186.151 Y163.66 E.50837
G1 X186.151 Y164.195 E.01649
G1 X173.955 Y151.999 E.53169
G1 X173.42 Y151.999 E.01649
G1 X186.151 Y164.73 E.55502
G1 X186.151 Y165.265 E.01649
G1 X172.885 Y151.999 E.57834
G1 X172.35 Y151.999 E.01649
G1 X186.151 Y165.8 E.60167
G1 X186.151 Y166.335 E.01649
G1 X171.815 Y151.999 E.62499
G1 X171.28 Y151.999 E.01649
G1 X186.151 Y166.87 E.64832
G1 X186.151 Y167.405 E.01649
G1 X170.745 Y151.999 E.67164
G1 X170.21 Y151.999 E.01649
G1 X186.151 Y167.94 E.69497
G1 X186.151 Y168.001 E.00186
G1 X185.676 Y168.001 E.01464
G1 X169.675 Y151.999 E.69759
G1 X169.14 Y151.999 E.01649
G1 X185.141 Y168.001 E.69759
G1 X184.606 Y168.001 E.01649
G1 X168.605 Y151.999 E.69759
G1 X168.07 Y151.999 E.01649
G1 X184.071 Y168.001 E.69759
G1 X183.536 Y168.001 E.01649
G1 X167.535 Y151.999 E.69759
G1 X167 Y151.999 E.01649
G1 X183.001 Y168.001 E.69759
G1 X182.466 Y168.001 E.01649
G1 X166.465 Y151.999 E.69759
G1 X165.93 Y151.999 E.01649
M73 P42 R9
G1 X181.931 Y168.001 E.69759
G1 X181.396 Y168.001 E.01649
G1 X165.395 Y151.999 E.69759
G1 X164.86 Y151.999 E.01649
G1 X180.861 Y168.001 E.69759
G1 X180.326 Y168.001 E.01649
G1 X164.325 Y151.999 E.69759
G1 X163.849 Y151.999 E.01465
G1 X163.849 Y152.059 E.00185
G1 X179.791 Y168.001 E.69498
G1 X179.256 Y168.001 E.01649
G1 X163.849 Y152.594 E.67166
G1 X163.849 Y153.129 E.01649
G1 X178.721 Y168.001 E.64833
G1 X178.186 Y168.001 E.01649
G1 X163.849 Y153.664 E.62501
G1 X163.849 Y154.199 E.01649
G1 X177.651 Y168.001 E.60168
G1 X177.116 Y168.001 E.01649
G1 X163.849 Y154.734 E.57836
G1 X163.849 Y155.269 E.01649
G1 X176.581 Y168.001 E.55503
G1 X176.046 Y168.001 E.01649
G1 X163.849 Y155.804 E.53171
G1 X163.849 Y156.339 E.01649
G1 X175.511 Y168.001 E.50838
G1 X174.976 Y168.001 E.01649
G1 X163.849 Y156.874 E.48506
G1 X163.849 Y157.409 E.01649
G1 X174.441 Y168.001 E.46173
G1 X173.906 Y168.001 E.01649
G1 X163.849 Y157.945 E.43841
G1 X163.849 Y158.48 E.01649
G1 X173.371 Y168.001 E.41509
G1 X172.836 Y168.001 E.01649
G1 X163.849 Y159.015 E.39176
G1 X163.849 Y159.55 E.01649
G1 X172.3 Y168.001 E.36844
G1 X171.765 Y168.001 E.01649
G1 X163.849 Y160.085 E.34511
G1 X163.849 Y160.62 E.01649
G1 X171.23 Y168.001 E.32179
G1 X170.695 Y168.001 E.01649
G1 X163.849 Y161.155 E.29846
G1 X163.849 Y161.69 E.01649
G1 X170.16 Y168.001 E.27514
G1 X169.625 Y168.001 E.01649
G1 X163.849 Y162.225 E.25181
G1 X163.849 Y162.76 E.01649
G1 X169.09 Y168.001 E.22849
G1 X168.555 Y168.001 E.01649
G1 X163.849 Y163.295 E.20516
G1 X163.849 Y163.83 E.01649
G1 X168.02 Y168.001 E.18184
G1 X167.485 Y168.001 E.01649
G1 X163.849 Y164.365 E.15851
G1 X163.849 Y164.9 E.01649
G1 X166.95 Y168.001 E.13519
G1 X166.415 Y168.001 E.01649
G1 X163.849 Y165.435 E.11186
G1 X163.849 Y165.97 E.01649
G1 X165.88 Y168.001 E.08854
G1 X165.345 Y168.001 E.01649
G1 X163.849 Y166.505 E.06522
G1 X163.849 Y167.04 E.01649
G1 X164.81 Y168.001 E.04189
G1 X164.275 Y168.001 E.01649
G1 X163.68 Y167.405 E.02596
; CHANGE_LAYER
; Z_HEIGHT: 1.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9516.005
G1 X164.275 Y168.001 E-.32004
G1 X164.81 Y168.001 E-.2033
G1 X164.37 Y167.56 E-.23665
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 6/85
; update layer progress
M73 L6
M991 S0 P5 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z1.4 I-.043 J1.216 P1  F60000
G1 X186.484 Y168.334 Z1.4
G1 Z1.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X163.516 Y168.334 E.76188
G1 X163.516 Y151.666 E.55289
G1 X186.484 Y151.666 E.76188
G1 X186.484 Y168.274 E.5509
; COOLING_NODE: 0
M204 S10000
G1 X186.891 Y168.741 F60000
G1 F8843.478
M204 S8000
G1 X163.109 Y168.741 E.78888
G1 X163.109 Y151.259 E.5799
G1 X186.891 Y151.259 E.78888
G1 X186.891 Y168.681 E.57791
; COOLING_NODE: 0
M204 S10000
G1 X187.298 Y169.148 F60000
G1 F8843.478
M204 S8000
G1 X162.702 Y169.148 E.81589
G1 X162.702 Y150.852 E.60691
G1 X187.298 Y150.852 E.81589
G1 X187.298 Y169.088 E.60492
; COOLING_NODE: 0
M204 S250
G1 X187.69 Y169.54 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X162.31 Y169.54 E.77986
G1 X162.31 Y150.46 E.58628
G1 X187.69 Y150.46 E.77986
G1 X187.69 Y169.48 E.58443
;======== H2D 20260731========
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
M204 S8000
G1 X185.69 Y169.485 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X185.549 Y168.17 Z1.6 F60000
G1 Z1.2
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42427
G1 F9440.146
M204 S8000
G1 X186.151 Y167.569 E.02644
G1 X186.151 Y167.029 E.01676
G1 X185.179 Y168.001 E.04268
G1 X184.64 Y168.001 E.01676
G1 X186.151 Y166.49 E.06639
G1 X186.151 Y165.951 E.01676
G1 X184.101 Y168.001 E.09009
G1 X183.562 Y168.001 E.01676
G1 X186.151 Y165.412 E.11379
G1 X186.151 Y164.872 E.01676
G1 X183.022 Y168.001 E.13749
G1 X182.483 Y168.001 E.01676
G1 X186.151 Y164.333 E.16119
G1 X186.151 Y163.794 E.01676
G1 X181.944 Y168.001 E.18489
G1 X181.404 Y168.001 E.01676
G1 X186.151 Y163.254 E.20859
G1 X186.151 Y162.715 E.01676
G1 X180.865 Y168.001 E.23229
G1 X180.326 Y168.001 E.01676
G1 X186.151 Y162.176 E.25599
G1 X186.151 Y161.636 E.01676
G1 X179.786 Y168.001 E.2797
G1 X179.247 Y168.001 E.01676
G1 X186.151 Y161.097 E.3034
G1 X186.151 Y160.558 E.01676
G1 X178.708 Y168.001 E.3271
G1 X178.168 Y168.001 E.01676
G1 X186.151 Y160.018 E.3508
G1 X186.151 Y159.479 E.01676
G1 X177.629 Y168.001 E.3745
G1 X177.09 Y168.001 E.01676
G1 X186.151 Y158.94 E.3982
G1 X186.151 Y158.401 E.01676
G1 X176.55 Y168.001 E.4219
G1 X176.011 Y168.001 E.01676
G1 X186.151 Y157.861 E.4456
G1 X186.151 Y157.322 E.01676
G1 X175.472 Y168.001 E.4693
G1 X174.933 Y168.001 E.01676
G1 X186.151 Y156.783 E.493
G1 X186.151 Y156.243 E.01676
G1 X174.393 Y168.001 E.51671
G1 X173.854 Y168.001 E.01676
G1 X186.151 Y155.704 E.54041
G1 X186.151 Y155.165 E.01676
G1 X173.315 Y168.001 E.56411
G1 X172.775 Y168.001 E.01676
G1 X186.151 Y154.625 E.58781
G1 X186.151 Y154.34 E.00885
G1 X185.896 Y154.34 E.00791
G1 X172.236 Y168.001 E.60033
G1 X171.697 Y168.001 E.01676
G1 X185.357 Y154.34 E.60033
G1 X184.818 Y154.34 E.01676
G1 X171.157 Y168.001 E.60033
G1 X170.618 Y168.001 E.01676
M73 P43 R9
G1 X184.278 Y154.34 E.60033
G1 X183.739 Y154.34 E.01676
G1 X170.079 Y168.001 E.60033
G1 X169.539 Y168.001 E.01676
G1 X183.2 Y154.34 E.60033
G1 X182.66 Y154.34 E.01676
G1 X169 Y168.001 E.60033
G1 X168.461 Y168.001 E.01676
G1 X182.121 Y154.34 E.60033
G1 X181.582 Y154.34 E.01676
G1 X167.922 Y168.001 E.60033
G1 X167.382 Y168.001 E.01676
G1 X181.043 Y154.34 E.60033
G1 X180.503 Y154.34 E.01676
G1 X166.843 Y168.001 E.60033
G1 X166.304 Y168.001 E.01676
G1 X179.964 Y154.34 E.60033
G1 X179.425 Y154.34 E.01676
G1 X165.764 Y168.001 E.60033
G1 X165.225 Y168.001 E.01676
G1 X178.885 Y154.34 E.60033
G1 X178.346 Y154.34 E.01676
G1 X164.686 Y168.001 E.60033
G1 X164.146 Y168.001 E.01676
G1 X177.807 Y154.34 E.60033
G1 X177.267 Y154.34 E.01676
G1 X163.849 Y167.759 E.58969
G1 X163.849 Y167.219 E.01676
G1 X176.728 Y154.34 E.56599
G1 X176.189 Y154.34 E.01676
G1 X163.849 Y166.68 E.54228
G1 X163.849 Y166.141 E.01676
G1 X175.649 Y154.34 E.51858
G1 X175.11 Y154.34 E.01676
G1 X163.849 Y165.601 E.49488
G1 X163.849 Y165.062 E.01676
G1 X174.571 Y154.34 E.47118
G1 X174.032 Y154.34 E.01676
G1 X163.849 Y164.523 E.44748
G1 X163.849 Y163.983 E.01676
G1 X173.492 Y154.34 E.42378
G1 X172.953 Y154.34 E.01676
G1 X163.849 Y163.444 E.40008
G1 X163.849 Y162.905 E.01676
G1 X172.414 Y154.34 E.37638
G1 X171.874 Y154.34 E.01676
G1 X163.849 Y162.365 E.35268
G1 X163.849 Y161.826 E.01676
G1 X171.335 Y154.34 E.32897
G1 X170.796 Y154.34 E.01676
G1 X163.849 Y161.287 E.30527
G1 X163.849 Y160.748 E.01676
G1 X170.256 Y154.34 E.28157
G1 X169.717 Y154.34 E.01676
G1 X163.849 Y160.208 E.25787
G1 X163.849 Y159.669 E.01676
G1 X169.178 Y154.34 E.23417
G1 X168.638 Y154.34 E.01676
G1 X163.849 Y159.13 E.21047
G1 X163.849 Y158.59 E.01676
G1 X168.099 Y154.34 E.18677
G1 X167.56 Y154.34 E.01676
G1 X163.849 Y158.051 E.16307
G1 X163.849 Y157.512 E.01676
G1 X167.02 Y154.34 E.13937
G1 X166.481 Y154.34 E.01676
G1 X163.849 Y156.972 E.11566
G1 X163.849 Y156.433 E.01676
G1 X165.942 Y154.34 E.09196
G1 X165.403 Y154.34 E.01676
G1 X163.849 Y155.894 E.06826
G1 X163.849 Y155.354 E.01676
G1 X164.863 Y154.34 E.04456
G1 X164.324 Y154.34 E.01676
G1 X163.68 Y154.985 E.02832
M204 S10000
G1 X163.864 Y153.479 F60000
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X163.864 Y153.948 E.01557
G1 X165.023 Y153.948 E.03845
G1 X165.173 Y153.901 E.00519
G1 X165.828 Y153.337 E.02868
G3 X167.793 Y152.996 I1.209 J1.133 E.07101
G2 X168.991 Y153.948 I5.928 J-6.22 E.05083
G1 X170.265 Y153.948 E.04226
G1 X170.414 Y153.901 E.00519
G1 X171.069 Y153.337 E.02868
G3 X173.035 Y152.996 I1.209 J1.133 E.07101
G2 X174.232 Y153.948 I5.927 J-6.219 E.05083
G1 X175.506 Y153.948 E.04226
G1 X175.655 Y153.901 E.00519
G1 X176.311 Y153.337 E.02868
G3 X178.276 Y152.996 I1.209 J1.133 E.07101
G2 X179.473 Y153.948 I5.928 J-6.22 E.05083
G1 X180.747 Y153.948 E.04226
G1 X180.897 Y153.901 E.00519
G1 X181.552 Y153.337 E.02868
G3 X183.517 Y152.996 I1.209 J1.133 E.07101
G2 X184.715 Y153.948 I5.927 J-6.22 E.05083
G1 X186.136 Y153.948 E.04713
G1 X186.136 Y153.741 E.00688
M204 S10000
G1 X163.959 Y152.109 F60000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.52142
G1 F7523.511
M204 S8000
G1 X185.981 Y152.109 E.85868
; CHANGE_LAYER
; Z_HEIGHT: 1.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F7523.511
G1 X183.981 Y152.109 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 7/85
; update layer progress
M73 L7
M991 S0 P6 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z1.6 I-1.203 J.186 P1  F60000
G1 X186.484 Y168.334 Z1.6
G1 Z1.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X163.516 Y168.334 E.76188
G1 X163.516 Y151.666 E.55289
G1 X186.484 Y151.666 E.76188
G1 X186.484 Y168.274 E.5509
; COOLING_NODE: 0
M204 S10000
G1 X186.891 Y168.741 F60000
G1 F8843.478
M204 S8000
G1 X163.109 Y168.741 E.78888
G1 X163.109 Y151.259 E.5799
G1 X186.891 Y151.259 E.78888
G1 X186.891 Y168.681 E.57791
; COOLING_NODE: 0
M204 S10000
G1 X187.298 Y169.148 F60000
G1 F8843.478
M204 S8000
G1 X162.702 Y169.148 E.81589
G1 X162.702 Y150.852 E.60691
G1 X187.298 Y150.852 E.81589
G1 X187.298 Y169.088 E.60492
; COOLING_NODE: 0
M204 S250
G1 X187.69 Y169.54 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X162.31 Y169.54 E.77986
G1 X162.31 Y150.46 E.58628
G1 X187.69 Y150.46 E.77986
G1 X187.69 Y169.48 E.58443
;======== H2D 20260731========
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
M204 S8000
G1 X185.69 Y169.485 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X185.975 Y161.858 Z1.8 F60000
G1 X186.32 Y152.595 Z1.8
G1 Z1.4
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42123
G1 F9516.005
M204 S8000
G1 X185.725 Y151.999 E.02595
G1 X185.19 Y151.999 E.01649
G1 X186.151 Y152.96 E.04188
G1 X186.151 Y153.495 E.01649
G1 X184.655 Y151.999 E.0652
G1 X184.12 Y151.999 E.01649
G1 X186.151 Y154.03 E.08853
G1 X186.151 Y154.565 E.01649
G1 X183.585 Y151.999 E.11185
G1 X183.05 Y151.999 E.01649
G1 X186.151 Y155.1 E.13517
G1 X186.151 Y155.635 E.01649
G1 X182.515 Y151.999 E.1585
G1 X181.98 Y151.999 E.01649
G1 X186.151 Y156.17 E.18182
G1 X186.151 Y156.705 E.01649
G1 X181.445 Y151.999 E.20515
G1 X180.91 Y151.999 E.01649
G1 X186.151 Y157.24 E.22847
G1 X186.151 Y157.775 E.01649
G1 X180.375 Y151.999 E.2518
G1 X179.84 Y151.999 E.01649
G1 X186.151 Y158.31 E.27512
G1 X186.151 Y158.845 E.01649
G1 X179.305 Y151.999 E.29845
G1 X178.77 Y151.999 E.01649
G1 X186.151 Y159.38 E.32177
G1 X186.151 Y159.915 E.01649
G1 X178.235 Y151.999 E.3451
G1 X177.7 Y151.999 E.01649
G1 X186.151 Y160.45 E.36842
G1 X186.151 Y160.985 E.01649
G1 X177.165 Y151.999 E.39175
G1 X176.63 Y151.999 E.01649
G1 X186.151 Y161.52 E.41507
G1 X186.151 Y162.055 E.01649
G1 X176.095 Y151.999 E.4384
G1 X175.56 Y151.999 E.01649
G1 X186.151 Y162.59 E.46172
G1 X186.151 Y163.125 E.01649
G1 X175.025 Y151.999 E.48505
G1 X174.49 Y151.999 E.01649
M73 P44 R9
G1 X186.151 Y163.66 E.50837
G1 X186.151 Y164.195 E.01649
G1 X173.955 Y151.999 E.53169
G1 X173.42 Y151.999 E.01649
G1 X186.151 Y164.73 E.55502
G1 X186.151 Y165.265 E.01649
G1 X172.885 Y151.999 E.57834
G1 X172.35 Y151.999 E.01649
G1 X186.151 Y165.8 E.60167
G1 X186.151 Y166.335 E.01649
G1 X171.815 Y151.999 E.62499
G1 X171.28 Y151.999 E.01649
G1 X186.151 Y166.87 E.64832
G1 X186.151 Y167.405 E.01649
G1 X170.745 Y151.999 E.67164
G1 X170.21 Y151.999 E.01649
G1 X186.151 Y167.94 E.69497
G1 X186.151 Y168.001 E.00186
G1 X185.676 Y168.001 E.01463
G1 X169.675 Y151.999 E.6976
G1 X169.14 Y151.999 E.01649
G1 X185.141 Y168.001 E.6976
G1 X184.606 Y168.001 E.01649
G1 X168.605 Y151.999 E.6976
G1 X168.07 Y151.999 E.01649
G1 X184.071 Y168.001 E.6976
G1 X183.536 Y168.001 E.01649
G1 X167.535 Y151.999 E.6976
G1 X167 Y151.999 E.01649
G1 X183.001 Y168.001 E.6976
G1 X182.466 Y168.001 E.01649
G1 X166.465 Y151.999 E.6976
G1 X165.93 Y151.999 E.01649
G1 X181.931 Y168.001 E.6976
G1 X181.396 Y168.001 E.01649
G1 X165.395 Y151.999 E.6976
G1 X164.86 Y151.999 E.01649
G1 X180.861 Y168.001 E.6976
G1 X180.326 Y168.001 E.01649
G1 X164.325 Y151.999 E.6976
G1 X163.849 Y151.999 E.01465
G1 X163.849 Y152.059 E.00184
G1 X179.791 Y168.001 E.695
G1 X179.256 Y168.001 E.01649
G1 X163.849 Y152.594 E.67167
G1 X163.849 Y153.129 E.01649
G1 X178.721 Y168.001 E.64835
G1 X178.186 Y168.001 E.01649
G1 X163.849 Y153.664 E.62502
G1 X163.849 Y154.199 E.01649
G1 X177.651 Y168.001 E.6017
G1 X177.116 Y168.001 E.01649
G1 X163.849 Y154.734 E.57838
G1 X163.849 Y155.269 E.01649
G1 X176.581 Y168.001 E.55505
G1 X176.046 Y168.001 E.01649
G1 X163.849 Y155.804 E.53173
G1 X163.849 Y156.339 E.01649
G1 X175.511 Y168.001 E.5084
G1 X174.976 Y168.001 E.01649
G1 X163.849 Y156.874 E.48508
G1 X163.849 Y157.409 E.01649
G1 X174.441 Y168.001 E.46175
G1 X173.906 Y168.001 E.01649
G1 X163.849 Y157.944 E.43843
G1 X163.849 Y158.479 E.01649
G1 X173.371 Y168.001 E.4151
G1 X172.836 Y168.001 E.01649
G1 X163.849 Y159.014 E.39178
G1 X163.849 Y159.549 E.01649
G1 X172.301 Y168.001 E.36845
G1 X171.766 Y168.001 E.01649
G1 X163.849 Y160.084 E.34513
G1 X163.849 Y160.619 E.01649
G1 X171.231 Y168.001 E.3218
G1 X170.696 Y168.001 E.01649
G1 X163.849 Y161.154 E.29848
G1 X163.849 Y161.689 E.01649
G1 X170.161 Y168.001 E.27515
G1 X169.626 Y168.001 E.01649
G1 X163.849 Y162.224 E.25183
G1 X163.849 Y162.759 E.01649
G1 X169.091 Y168.001 E.22851
G1 X168.556 Y168.001 E.01649
G1 X163.849 Y163.294 E.20518
G1 X163.849 Y163.829 E.01649
G1 X168.021 Y168.001 E.18186
G1 X167.486 Y168.001 E.01649
G1 X163.849 Y164.364 E.15853
G1 X163.849 Y164.899 E.01649
G1 X166.951 Y168.001 E.13521
G1 X166.416 Y168.001 E.01649
G1 X163.849 Y165.434 E.11188
G1 X163.849 Y165.969 E.01649
G1 X165.881 Y168.001 E.08856
G1 X165.346 Y168.001 E.01649
G1 X163.849 Y166.504 E.06523
G1 X163.849 Y167.039 E.01649
G1 X164.811 Y168.001 E.04191
G1 X164.276 Y168.001 E.01649
G1 X163.68 Y167.405 E.02598
; CHANGE_LAYER
; Z_HEIGHT: 1.6
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9516.005
G1 X164.276 Y168.001 E-.32026
G1 X164.811 Y168.001 E-.2033
G1 X164.371 Y167.561 E-.23644
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 8/85
; update layer progress
M73 L8
M991 S0 P7 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z1.8 I-.043 J1.216 P1  F60000
G1 X186.484 Y168.334 Z1.8
G1 Z1.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X163.516 Y168.334 E.76188
G1 X163.516 Y151.666 E.55289
G1 X186.484 Y151.666 E.76188
G1 X186.484 Y168.274 E.5509
; COOLING_NODE: 0
M204 S10000
G1 X186.891 Y168.741 F60000
G1 F8843.478
M204 S8000
G1 X163.109 Y168.741 E.78888
G1 X163.109 Y151.259 E.5799
G1 X186.891 Y151.259 E.78888
G1 X186.891 Y168.681 E.57791
; COOLING_NODE: 0
M204 S10000
G1 X187.298 Y169.148 F60000
G1 F8843.478
M204 S8000
G1 X162.702 Y169.148 E.81589
G1 X162.702 Y150.852 E.60691
G1 X187.298 Y150.852 E.81589
G1 X187.298 Y169.088 E.60492
; COOLING_NODE: 0
M204 S250
G1 X187.69 Y169.54 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X162.31 Y169.54 E.77986
G1 X162.31 Y150.46 E.58628
G1 X187.69 Y150.46 E.77986
G1 X187.69 Y169.48 E.58443
;======== H2D 20260731========
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
M204 S8000
G1 X185.69 Y169.485 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X185.555 Y168.17 Z2 F60000
M73 P44 R8
G1 Z1.6
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42123
G1 F9516.005
M204 S8000
G1 X186.151 Y167.575 E.02595
G1 X186.151 Y167.04 E.01649
G1 X185.19 Y168.001 E.04188
G1 X184.655 Y168.001 E.01649
G1 X186.151 Y166.505 E.0652
G1 X186.151 Y165.97 E.01649
G1 X184.12 Y168.001 E.08853
G1 X183.585 Y168.001 E.01649
M73 P45 R8
G1 X186.151 Y165.435 E.11185
G1 X186.151 Y164.9 E.01649
G1 X183.05 Y168.001 E.13517
G1 X182.515 Y168.001 E.01649
G1 X186.151 Y164.365 E.1585
G1 X186.151 Y163.83 E.01649
G1 X181.98 Y168.001 E.18182
G1 X181.445 Y168.001 E.01649
G1 X186.151 Y163.295 E.20515
G1 X186.151 Y162.76 E.01649
G1 X180.91 Y168.001 E.22847
G1 X180.375 Y168.001 E.01649
G1 X186.151 Y162.225 E.2518
G1 X186.151 Y161.69 E.01649
G1 X179.84 Y168.001 E.27512
G1 X179.305 Y168.001 E.01649
G1 X186.151 Y161.155 E.29845
G1 X186.151 Y160.62 E.01649
G1 X178.77 Y168.001 E.32177
G1 X178.235 Y168.001 E.01649
G1 X186.151 Y160.085 E.3451
G1 X186.151 Y159.55 E.01649
G1 X177.7 Y168.001 E.36842
G1 X177.165 Y168.001 E.01649
G1 X186.151 Y159.015 E.39175
G1 X186.151 Y158.48 E.01649
G1 X176.63 Y168.001 E.41507
G1 X176.095 Y168.001 E.01649
G1 X186.151 Y157.945 E.4384
G1 X186.151 Y157.41 E.01649
G1 X175.56 Y168.001 E.46172
G1 X175.025 Y168.001 E.01649
G1 X186.151 Y156.875 E.48504
G1 X186.151 Y156.34 E.01649
G1 X174.49 Y168.001 E.50837
G1 X173.955 Y168.001 E.01649
G1 X186.151 Y155.805 E.53169
G1 X186.151 Y155.27 E.01649
G1 X173.42 Y168.001 E.55502
G1 X172.885 Y168.001 E.01649
G1 X186.151 Y154.735 E.57834
G1 X186.151 Y154.2 E.01649
G1 X172.35 Y168.001 E.60167
G1 X171.815 Y168.001 E.01649
G1 X186.151 Y153.665 E.62499
G1 X186.151 Y153.13 E.01649
G1 X171.28 Y168.001 E.64832
G1 X170.745 Y168.001 E.01649
G1 X186.151 Y152.595 E.67164
G1 X186.151 Y152.06 E.01649
G1 X170.21 Y168.001 E.69497
G1 X169.675 Y168.001 E.01649
G1 X185.676 Y151.999 E.69759
G1 X185.141 Y151.999 E.01649
G1 X169.14 Y168.001 E.69759
G1 X168.605 Y168.001 E.01649
G1 X184.606 Y151.999 E.69759
G1 X184.071 Y151.999 E.01649
G1 X168.07 Y168.001 E.69759
G1 X167.535 Y168.001 E.01649
G1 X183.536 Y151.999 E.69759
G1 X183.001 Y151.999 E.01649
G1 X167 Y168.001 E.69759
G1 X166.465 Y168.001 E.01649
G1 X182.466 Y151.999 E.69759
G1 X181.931 Y151.999 E.01649
G1 X165.93 Y168.001 E.69759
G1 X165.395 Y168.001 E.01649
G1 X181.396 Y151.999 E.69759
G1 X180.861 Y151.999 E.01649
G1 X164.86 Y168.001 E.69759
G1 X164.325 Y168.001 E.01649
G1 X180.326 Y151.999 E.69759
G1 X179.791 Y151.999 E.01649
G1 X163.849 Y167.941 E.69498
G1 X163.849 Y167.406 E.01649
G1 X179.256 Y151.999 E.67166
G1 X178.721 Y151.999 E.01649
G1 X163.849 Y166.871 E.64833
G1 X163.849 Y166.336 E.01649
G1 X178.186 Y151.999 E.62501
G1 X177.651 Y151.999 E.01649
G1 X163.849 Y165.801 E.60168
G1 X163.849 Y165.266 E.01649
G1 X177.116 Y151.999 E.57836
G1 X176.581 Y151.999 E.01649
G1 X163.849 Y164.731 E.55503
G1 X163.849 Y164.196 E.01649
G1 X176.046 Y151.999 E.53171
G1 X175.511 Y151.999 E.01649
G1 X163.849 Y163.661 E.50838
G1 X163.849 Y163.126 E.01649
G1 X174.976 Y151.999 E.48506
G1 X174.441 Y151.999 E.01649
G1 X163.849 Y162.591 E.46173
G1 X163.849 Y162.056 E.01649
G1 X173.906 Y151.999 E.43841
G1 X173.371 Y151.999 E.01649
G1 X163.849 Y161.521 E.41509
G1 X163.849 Y160.986 E.01649
G1 X172.836 Y151.999 E.39176
G1 X172.3 Y151.999 E.01649
G1 X163.849 Y160.451 E.36844
G1 X163.849 Y159.915 E.01649
G1 X171.765 Y151.999 E.34511
G1 X171.23 Y151.999 E.01649
G1 X163.849 Y159.38 E.32179
G1 X163.849 Y158.845 E.01649
G1 X170.695 Y151.999 E.29846
G1 X170.16 Y151.999 E.01649
G1 X163.849 Y158.31 E.27514
G1 X163.849 Y157.775 E.01649
G1 X169.625 Y151.999 E.25181
G1 X169.09 Y151.999 E.01649
G1 X163.849 Y157.24 E.22849
G1 X163.849 Y156.705 E.01649
G1 X168.555 Y151.999 E.20516
G1 X168.02 Y151.999 E.01649
G1 X163.849 Y156.17 E.18184
G1 X163.849 Y155.635 E.01649
G1 X167.485 Y151.999 E.15851
G1 X166.95 Y151.999 E.01649
G1 X163.849 Y155.1 E.13519
G1 X163.849 Y154.565 E.01649
G1 X166.415 Y151.999 E.11186
G1 X165.88 Y151.999 E.01649
G1 X163.849 Y154.03 E.08854
G1 X163.849 Y153.495 E.01649
G1 X165.345 Y151.999 E.06522
G1 X164.81 Y151.999 E.01649
G1 X163.849 Y152.96 E.04189
G1 X163.849 Y152.425 E.01649
G1 X164.445 Y151.83 E.02596
; CHANGE_LAYER
; Z_HEIGHT: 1.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9516.005
G1 X163.849 Y152.425 E-.32004
G1 X163.849 Y152.96 E-.2033
G1 X164.29 Y152.52 E-.23665
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 9/85
; update layer progress
M73 L9
M991 S0 P8 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z2 I-.706 J.991 P1  F60000
G1 X186.484 Y168.334 Z2
G1 Z1.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X163.516 Y168.334 E.76188
G1 X163.516 Y151.666 E.55289
G1 X186.484 Y151.666 E.76188
G1 X186.484 Y168.274 E.5509
; COOLING_NODE: 0
M204 S10000
G1 X186.891 Y168.741 F60000
G1 F8843.478
M204 S8000
G1 X163.109 Y168.741 E.78888
G1 X163.109 Y151.259 E.5799
G1 X186.891 Y151.259 E.78888
G1 X186.891 Y168.681 E.57791
; COOLING_NODE: 0
M204 S10000
G1 X187.298 Y169.148 F60000
G1 F8843.478
M204 S8000
G1 X162.702 Y169.148 E.81589
G1 X162.702 Y150.852 E.60691
G1 X187.298 Y150.852 E.81589
G1 X187.298 Y169.088 E.60492
; COOLING_NODE: 0
M204 S250
G1 X187.69 Y169.54 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
M73 P46 R8
G1 F9547.055
M204 S5000
G1 X162.31 Y169.54 E.77986
G1 X162.31 Y150.46 E.58628
G1 X187.69 Y150.46 E.77986
G1 X187.69 Y169.48 E.58443
;======== H2D 20260731========
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
M204 S8000
G1 X185.69 Y169.485 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X185.975 Y161.858 Z2.2 F60000
G1 X186.32 Y152.595 Z2.2
G1 Z1.8
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42123
G1 F9516.005
M204 S8000
G1 X185.725 Y151.999 E.02595
G1 X185.19 Y151.999 E.01649
G1 X186.151 Y152.96 E.04188
G1 X186.151 Y153.495 E.01649
G1 X184.655 Y151.999 E.0652
G1 X184.12 Y151.999 E.01649
G1 X186.151 Y154.03 E.08853
G1 X186.151 Y154.565 E.01649
G1 X183.585 Y151.999 E.11185
G1 X183.05 Y151.999 E.01649
G1 X186.151 Y155.1 E.13517
G1 X186.151 Y155.635 E.01649
G1 X182.515 Y151.999 E.1585
G1 X181.98 Y151.999 E.01649
G1 X186.151 Y156.17 E.18182
G1 X186.151 Y156.705 E.01649
G1 X181.445 Y151.999 E.20515
G1 X180.91 Y151.999 E.01649
G1 X186.151 Y157.24 E.22847
G1 X186.151 Y157.775 E.01649
G1 X180.375 Y151.999 E.2518
G1 X179.84 Y151.999 E.01649
G1 X186.151 Y158.31 E.27512
G1 X186.151 Y158.845 E.01649
G1 X179.305 Y151.999 E.29845
G1 X178.77 Y151.999 E.01649
G1 X186.151 Y159.38 E.32177
G1 X186.151 Y159.915 E.01649
G1 X178.235 Y151.999 E.3451
G1 X177.7 Y151.999 E.01649
G1 X186.151 Y160.45 E.36842
G1 X186.151 Y160.985 E.01649
G1 X177.165 Y151.999 E.39175
G1 X176.63 Y151.999 E.01649
G1 X186.151 Y161.52 E.41507
G1 X186.151 Y162.055 E.01649
G1 X176.095 Y151.999 E.4384
G1 X175.56 Y151.999 E.01649
G1 X186.151 Y162.59 E.46172
G1 X186.151 Y163.125 E.01649
G1 X175.025 Y151.999 E.48505
G1 X174.49 Y151.999 E.01649
G1 X186.151 Y163.66 E.50837
G1 X186.151 Y164.195 E.01649
G1 X173.955 Y151.999 E.53169
G1 X173.42 Y151.999 E.01649
G1 X186.151 Y164.73 E.55502
G1 X186.151 Y165.265 E.01649
G1 X172.885 Y151.999 E.57834
G1 X172.35 Y151.999 E.01649
G1 X186.151 Y165.8 E.60167
G1 X186.151 Y166.335 E.01649
G1 X171.815 Y151.999 E.62499
G1 X171.28 Y151.999 E.01649
G1 X186.151 Y166.87 E.64832
G1 X186.151 Y167.405 E.01649
G1 X170.745 Y151.999 E.67164
G1 X170.21 Y151.999 E.01649
G1 X186.151 Y167.94 E.69497
G1 X186.151 Y168.001 E.00186
G1 X185.676 Y168.001 E.01464
G1 X169.675 Y151.999 E.69759
G1 X169.14 Y151.999 E.01649
G1 X185.141 Y168.001 E.69759
G1 X184.606 Y168.001 E.01649
G1 X168.605 Y151.999 E.69759
G1 X168.07 Y151.999 E.01649
G1 X184.071 Y168.001 E.69759
G1 X183.536 Y168.001 E.01649
G1 X167.535 Y151.999 E.69759
G1 X167 Y151.999 E.01649
G1 X183.001 Y168.001 E.69759
G1 X182.466 Y168.001 E.01649
G1 X166.465 Y151.999 E.69759
G1 X165.93 Y151.999 E.01649
G1 X181.931 Y168.001 E.69759
G1 X181.396 Y168.001 E.01649
G1 X165.395 Y151.999 E.69759
G1 X164.86 Y151.999 E.01649
G1 X180.861 Y168.001 E.69759
G1 X180.326 Y168.001 E.01649
G1 X164.325 Y151.999 E.69759
G1 X163.849 Y151.999 E.01465
G1 X163.849 Y152.059 E.00185
G1 X179.791 Y168.001 E.69498
G1 X179.256 Y168.001 E.01649
G1 X163.849 Y152.594 E.67166
G1 X163.849 Y153.129 E.01649
G1 X178.721 Y168.001 E.64833
G1 X178.186 Y168.001 E.01649
G1 X163.849 Y153.664 E.62501
G1 X163.849 Y154.199 E.01649
G1 X177.651 Y168.001 E.60168
G1 X177.116 Y168.001 E.01649
G1 X163.849 Y154.734 E.57836
G1 X163.849 Y155.269 E.01649
G1 X176.581 Y168.001 E.55503
G1 X176.046 Y168.001 E.01649
G1 X163.849 Y155.804 E.53171
G1 X163.849 Y156.339 E.01649
G1 X175.511 Y168.001 E.50838
G1 X174.976 Y168.001 E.01649
G1 X163.849 Y156.874 E.48506
G1 X163.849 Y157.409 E.01649
G1 X174.441 Y168.001 E.46173
G1 X173.906 Y168.001 E.01649
G1 X163.849 Y157.945 E.43841
G1 X163.849 Y158.48 E.01649
G1 X173.371 Y168.001 E.41509
G1 X172.836 Y168.001 E.01649
G1 X163.849 Y159.015 E.39176
G1 X163.849 Y159.55 E.01649
G1 X172.3 Y168.001 E.36844
G1 X171.765 Y168.001 E.01649
G1 X163.849 Y160.085 E.34511
G1 X163.849 Y160.62 E.01649
G1 X171.23 Y168.001 E.32179
G1 X170.695 Y168.001 E.01649
G1 X163.849 Y161.155 E.29846
G1 X163.849 Y161.69 E.01649
G1 X170.16 Y168.001 E.27514
G1 X169.625 Y168.001 E.01649
G1 X163.849 Y162.225 E.25181
G1 X163.849 Y162.76 E.01649
G1 X169.09 Y168.001 E.22849
G1 X168.555 Y168.001 E.01649
G1 X163.849 Y163.295 E.20516
G1 X163.849 Y163.83 E.01649
G1 X168.02 Y168.001 E.18184
G1 X167.485 Y168.001 E.01649
G1 X163.849 Y164.365 E.15851
G1 X163.849 Y164.9 E.01649
G1 X166.95 Y168.001 E.13519
G1 X166.415 Y168.001 E.01649
G1 X163.849 Y165.435 E.11186
G1 X163.849 Y165.97 E.01649
G1 X165.88 Y168.001 E.08854
G1 X165.345 Y168.001 E.01649
G1 X163.849 Y166.505 E.06522
G1 X163.849 Y167.04 E.01649
G1 X164.81 Y168.001 E.04189
G1 X164.275 Y168.001 E.01649
G1 X163.68 Y167.405 E.02596
; CHANGE_LAYER
; Z_HEIGHT: 2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9516.005
G1 X164.275 Y168.001 E-.32004
G1 X164.81 Y168.001 E-.2033
G1 X164.37 Y167.56 E-.23665
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 10/85
; update layer progress
M73 L10
M991 S0 P9 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z2.2 I.513 J1.103 P1  F60000
G1 X166.992 Y166.341 Z2.2
G1 Z2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G3 X166.837 Y166.754 I-1.62 J-.37 E.01467
G1 X166.783 Y166.837 E.0033
G3 X166.459 Y167.152 I-1.059 J-.765 E.01506
G1 X165.75 Y167.604 E.0279
M73 P47 R8
G3 X164.979 Y167.108 I4.353 J-7.615 E.03042
G1 X164.957 Y167.091 E.00092
G3 X164.698 Y166.809 I.861 J-1.053 E.01274
G1 X164.246 Y166.1 E.0279
G3 X164.742 Y165.329 I7.601 J4.344 E.03043
G1 X164.76 Y165.307 E.00093
G3 X165.815 Y164.833 I.992 J.798 E.03985
G3 X166.87 Y165.504 I-.067 J1.27 E.04336
G1 X167.026 Y165.817 E.01159
G3 X167.004 Y166.282 I-1.655 J.154 E.0155
; COOLING_NODE: 0
M204 S10000
G1 X167.403 Y166.327 F60000
G1 F8843.478
M204 S8000
G3 X167.269 Y166.808 I-2.495 J-.436 E.01659
G3 X166.687 Y167.49 I-1.531 J-.718 E.0301
G1 X165.75 Y168.087 E.03685
G1 X164.813 Y167.489 E.03686
G3 X164.36 Y167.037 I.993 J-1.446 E.02134
G1 X163.764 Y166.1 E.03686
G1 X164.36 Y165.163 E.03685
G3 X165.837 Y164.426 I1.392 J.941 E.05722
G3 X167.23 Y165.313 I-.089 J1.677 E.05726
G1 X167.436 Y165.726 E.01532
G3 X167.413 Y166.268 I-2.528 J.164 E.01801
; COOLING_NODE: 0
M204 S10000
G1 X167.817 Y166.323 F60000
G1 F8843.478
M204 S8000
G3 X167.742 Y166.709 I-3.621 J-.497 E.01305
G3 X166.915 Y167.827 I-2.017 J-.628 E.04701
G1 X165.75 Y168.569 E.04581
G1 X164.585 Y167.827 E.04581
G3 X164.023 Y167.265 I1.24 J-1.802 E.02653
G1 X163.281 Y166.1 E.04581
G1 X164.023 Y164.935 E.0458
G3 X165.858 Y164.02 I1.73 J1.17 E.07113
G3 X167.589 Y165.122 I-.111 J2.085 E.07116
G1 X167.845 Y165.636 E.01904
G3 X167.824 Y166.264 I-3.649 J.191 E.02087
; COOLING_NODE: 0
; WIPE_START
G1 X167.742 Y166.709 E-.17218
G1 X167.638 Y166.98 E-.11021
G1 X167.44 Y167.319 E-.14921
G1 X167.223 Y167.573 E-.12684
G1 X166.915 Y167.827 E-.15195
G1 X166.805 Y167.897 E-.04962
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X174.428 Y167.523 Z2.4 F60000
G1 X185.147 Y166.997 Z2.4
G1 Z2
G1 E.8 F1800
G1 F8843.478
M204 S8000
G3 X184.959 Y167.152 I-.922 J-.924 E.00809
G1 X184.25 Y167.604 E.0279
G3 X183.486 Y167.113 I4.305 J-7.539 E.03012
G1 X183.408 Y167.05 E.00333
G3 X182.983 Y166.177 I.856 J-.957 E.03303
G1 X182.974 Y165.817 E.01194
G3 X183.713 Y164.95 I1.498 J.529 E.03865
G3 X184.315 Y164.833 I.549 J1.21 E.02054
G3 X185.297 Y165.382 I-.068 J1.272 E.03863
G1 X185.754 Y166.1 E.02823
G3 X185.283 Y166.837 I-8.694 J-5.034 E.02903
G3 X185.189 Y166.953 I-1.058 J-.765 E.00496
; COOLING_NODE: 0
M204 S10000
G1 X185.435 Y167.284 F60000
G1 F8843.478
M204 S8000
G3 X185.187 Y167.49 I-1.216 J-1.218 E.01069
G1 X184.25 Y168.087 E.03686
G1 X183.313 Y167.49 E.03686
G3 X182.577 Y166.196 I.943 J-1.393 E.05114
G1 X182.564 Y165.726 E.0156
G3 X183.169 Y164.819 I2.366 J.921 E.03643
G3 X184.337 Y164.426 I1.081 J1.282 E.04187
G3 X185.635 Y165.156 I-.09 J1.68 E.05117
G1 X186.236 Y166.1 E.03713
G3 X185.611 Y167.078 I-11.581 J-6.714 E.03851
G3 X185.477 Y167.241 I-1.393 J-1.011 E.00703
; COOLING_NODE: 0
M204 S10000
G1 X185.721 Y167.571 F60000
G1 F8843.478
M204 S8000
G3 X185.415 Y167.827 I-1.599 J-1.6 E.01327
G1 X184.25 Y168.569 E.04582
G1 X183.085 Y167.827 E.04581
G3 X182.17 Y166.216 I1.172 J-1.731 E.06369
G1 X182.155 Y165.635 E.01927
G3 X182.697 Y164.711 I3.405 J1.377 E.03569
G3 X184.358 Y164.02 I1.564 J1.419 E.06164
G3 X185.974 Y164.93 I-.112 J2.087 E.06372
G1 X186.719 Y166.1 E.04603
G1 X185.974 Y167.271 E.04603
G3 X185.763 Y167.528 I-1.852 J-1.3 E.01104
; COOLING_NODE: 0
; WIPE_START
G1 X185.415 Y167.827 E-.17449
G1 X184.25 Y168.569 E-.52484
G1 X184.115 Y168.483 E-.06067
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X187.69 Y169.54 Z2.4 F60000
G1 Z2
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X162.31 Y169.54 E.77986
G1 X162.31 Y150.46 E.58628
G1 X187.69 Y150.46 E.77986
G1 X187.69 Y169.48 E.58443
;======== H2D 20260731========
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
M204 S8000
G1 X185.69 Y169.485 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X184.289 Y166.034 Z2.4 F60000
G1 Z2
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.62514
G1 F6183.23
M204 S8000
G2 X184.295 Y166.149 I-.033 J.059 E.01373
M204 S10000
G1 X183.837 Y165.857 F60000
; LINE_WIDTH: 0.41999
G1 F9547.299
M204 S8000
G1 X183.756 Y165.996 E.00496
G1 X183.807 Y166.279 E.00882
G1 X183.97 Y166.51 E.0087
G1 X184.252 Y166.691 E.01027
G1 X184.606 Y166.423 E.01365
G1 X184.842 Y166.1 E.01228
G2 X184.515 Y165.693 I-1.053 J.511 E.01617
G1 X184.254 Y165.605 E.00845
G1 X184.02 Y165.667 E.00743
G1 X183.879 Y165.814 E.00626
M204 S10000
G1 X183.596 Y165.522 F60000
G1 F9547.299
M204 S8000
G1 X183.371 Y165.908 E.01374
G1 X183.402 Y166.307 E.01227
G1 X183.558 Y166.632 E.0111
G2 X184.251 Y167.138 I2.207 J-2.293 E.02644
G1 X184.721 Y166.839 E.01713
G2 X185.289 Y166.1 I-1.727 J-1.915 E.02879
G2 X184.83 Y165.446 I-2.866 J1.524 E.02461
G1 X184.594 Y165.297 E.00856
G1 X184.212 Y165.23 E.01194
G1 X183.839 Y165.33 E.01184
G1 X183.643 Y165.485 E.00769
; WIPE_START
G1 X183.839 Y165.33 E-.09514
G1 X184.212 Y165.23 E-.1464
G1 X184.594 Y165.297 E-.14771
G1 X184.83 Y165.446 E-.10591
G1 X185.016 Y165.671 E-.11079
G1 X185.234 Y166.013 E-.15404
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X177.604 Y165.814 Z2.4 F60000
G1 X166.396 Y165.523 Z2.4
G1 Z2
G1 E.8 F1800
G1 F9547.299
M204 S8000
G1 X166.095 Y165.298 E.01153
G1 X165.712 Y165.23 E.01197
G1 X165.345 Y165.327 E.01166
G1 X165.046 Y165.582 E.01208
G1 X164.712 Y166.101 E.01897
G1 X165.011 Y166.571 E.01712
G2 X165.749 Y167.138 I1.932 J-1.749 E.02876
G1 X166.272 Y166.803 E.01909
G1 X166.458 Y166.611 E.00822
G1 X166.597 Y166.309 E.0102
G1 X166.629 Y165.905 E.01247
G1 X166.427 Y165.574 E.01192
M204 S10000
G1 X166.245 Y165.984 F60000
G1 F9547.299
M204 S8000
G1 X166.071 Y165.726 E.00957
G1 X165.846 Y165.627 E.00756
G1 X165.679 Y165.616 E.00514
G2 X165.286 Y165.905 I.218 J.707 E.01527
G1 X165.159 Y166.102 E.0072
G1 X165.429 Y166.456 E.01367
G1 X165.748 Y166.691 E.01218
G1 X166.143 Y166.394 E.01517
G1 X166.235 Y166.109 E.0092
G1 X166.24 Y166.044 E.00201
M204 S10000
G1 X165.788 Y166.041 F60000
; LINE_WIDTH: 0.62062
G1 F6231.609
M204 S8000
G2 X165.794 Y166.155 I-.032 J.059 E.0135
; WIPE_START
G1 X165.716 Y166.166 E-.20315
G1 X165.679 Y166.103 E-.18562
G1 X165.716 Y166.041 E-.18563
G1 X165.788 Y166.041 E-.18559
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X165.516 Y168.684 Z2.4 F60000
G1 Z2
G1 E.8 F1800
; FEATURE: Top surface
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S2000
G1 X164.867 Y169.333 E.02818
G1 X164.734 Y169.466
G1 X164.201 Y169.466
G1 X164.334 Y169.333
G1 X165.19 Y168.477 E.0372
G1 X165.324 Y168.343
G1 X164.998 Y168.135
G1 X164.865 Y168.269
G1 X163.801 Y169.333 E.04622
G1 X163.667 Y169.466
G1 X163.134 Y169.466
G1 X163.268 Y169.333
G1 X164.539 Y168.061 E.05524
G1 X164.673 Y167.928
G1 X164.366 Y167.701
G1 X164.232 Y167.835
G1 X162.734 Y169.333 E.06508
G1 X162.601 Y169.466
G1 X162.384 Y169.15
G1 X162.517 Y169.016
G1 X163.969 Y167.564 E.0631
G1 X164.103 Y167.431
G1 X163.884 Y167.117
G1 X163.75 Y167.251
G1 X162.517 Y168.483 E.05356
G1 X162.384 Y168.617
G1 X162.384 Y168.084
G1 X162.517 Y167.95
G1 X163.542 Y166.925 E.04455
G1 X163.676 Y166.791
G1 X163.469 Y166.465
G1 X163.335 Y166.599
G1 X162.517 Y167.417 E.03553
G1 X162.384 Y167.55
G1 X162.384 Y167.017
G1 X162.517 Y166.883
G1 X163.128 Y166.273 E.02651
; WIPE_START
M204 S8000
G1 X162.517 Y166.883 E-.3279
G1 X162.384 Y167.017 E-.07182
G1 X162.384 Y167.55 E-.20264
G1 X162.517 Y167.417 E-.07182
G1 X162.677 Y167.257 E-.08583
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X170.288 Y166.681 Z2.4 F60000
G1 X187.483 Y165.381 Z2.4
G1 Z2
G1 E.8 F1800
G1 F9547.055
M204 S2000
G1 X186.898 Y165.966 E.02542
G1 X186.764 Y166.1
G1 X186.557 Y165.774
G1 X186.69 Y165.641
G1 X187.483 Y164.848 E.03443
G1 X187.616 Y164.715
G1 X187.616 Y164.181
G1 X187.483 Y164.315
G1 X186.483 Y165.315 E.04345
G1 X186.349 Y165.448
G1 X186.142 Y165.123
G1 X186.275 Y164.989
G1 X187.483 Y163.782 E.05247
G1 X187.616 Y163.648
G1 X187.616 Y163.115
G1 X187.483 Y163.248
G1 X186.059 Y164.672 E.06185
G1 X185.926 Y164.805
G1 X185.669 Y164.529
G1 X185.802 Y164.395
G1 X187.483 Y162.715 E.07302
G1 X187.616 Y162.582
G1 X187.616 Y162.048
G1 X187.483 Y162.182
G1 X185.501 Y164.164 E.08612
G1 X185.367 Y164.297
G1 X185.019 Y164.112
G1 X185.153 Y163.978
G1 X187.483 Y161.649 E.10124
G1 X187.616 Y161.515
G1 X187.616 Y160.982
G1 X187.483 Y161.115
G1 X184.749 Y163.849 E.1188
G1 X184.615 Y163.983
G1 X184.136 Y163.928
G1 X184.27 Y163.795
G1 X187.483 Y160.582 E.1396
G1 X187.616 Y160.448
G1 X187.616 Y159.915
G1 X187.483 Y160.049
G1 X183.66 Y163.872 E.16612
; WIPE_START
M204 S8000
G1 X185.074 Y162.457 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X184.116 Y168.748 Z2.4 F60000
G1 Z2
G1 E.8 F1800
G1 F9547.055
M204 S2000
G1 X183.531 Y169.333 E.02541
G1 X183.398 Y169.466
G1 X182.865 Y169.466
G1 X182.998 Y169.333
G1 X183.791 Y168.54 E.03443
G1 X183.924 Y168.407
G1 X183.598 Y168.199
G1 X183.465 Y168.333
G1 X182.465 Y169.333 E.04345
G1 X182.331 Y169.466
G1 X181.798 Y169.466
G1 X181.932 Y169.333
G1 X183.139 Y168.125 E.05247
G1 X183.273 Y167.992
G1 X182.955 Y167.776
G1 X182.822 Y167.909
G1 X181.398 Y169.333 E.06185
G1 X181.265 Y169.466
G1 X180.732 Y169.466
G1 X180.865 Y169.333
G1 X182.545 Y167.652 E.07302
G1 X182.679 Y167.519
G1 X182.447 Y167.217
G1 X182.314 Y167.351
G1 X180.332 Y169.333 E.08612
G1 X180.198 Y169.466
G1 X179.665 Y169.466
G1 X179.799 Y169.333
G1 X182.128 Y167.003 E.10123
G1 X182.262 Y166.869
G1 X182.133 Y166.465
G1 X182 Y166.598
G1 X179.265 Y169.333 E.11881
G1 X179.132 Y169.466
G1 X178.598 Y169.466
G1 X178.732 Y169.333
G1 X181.945 Y166.12 E.13961
G1 X182.078 Y165.986
G1 X182.065 Y165.467
G1 X181.931 Y165.6
G1 X178.199 Y169.333 E.16219
G1 X178.065 Y169.466
G1 X177.532 Y169.466
G1 X177.666 Y169.333
G1 X187.483 Y159.516 E.4266
G1 X187.616 Y159.382
G1 X187.616 Y158.849
G1 X187.483 Y158.982
G1 X177.132 Y169.333 E.44977
G1 X176.999 Y169.466
G1 X176.465 Y169.466
G1 X176.599 Y169.333
G1 X187.483 Y158.449 E.47294
G1 X187.616 Y158.315
G1 X187.616 Y157.782
G1 X187.483 Y157.916
G1 X176.066 Y169.333 E.49611
G1 X175.932 Y169.466
G1 X175.399 Y169.466
G1 X175.533 Y169.333
G1 X187.483 Y157.383 E.51929
G1 X187.616 Y157.249
G1 X187.616 Y156.716
G1 X187.483 Y156.849
G1 X174.999 Y169.333 E.54246
G1 X174.866 Y169.466
G1 X174.332 Y169.466
G1 X174.466 Y169.333
G1 X187.483 Y156.316 E.56563
G1 X187.616 Y156.182
G1 X187.616 Y155.649
G1 X187.483 Y155.783
G1 X173.933 Y169.333 E.58881
G1 X173.799 Y169.466
G1 X173.266 Y169.466
G1 X173.4 Y169.333
G1 X187.483 Y155.25 E.61198
G1 X187.616 Y155.116
G1 X187.616 Y154.583
G1 X187.483 Y154.716
G1 X172.866 Y169.333 E.63515
G1 X172.733 Y169.466
G1 X172.199 Y169.466
G1 X172.333 Y169.333
G1 X187.483 Y154.183 E.65832
G1 X187.616 Y154.049
G1 X187.616 Y153.516
G1 X187.483 Y153.65
G1 X171.8 Y169.333 E.6815
G1 X171.666 Y169.466
G1 X171.133 Y169.466
G1 X171.267 Y169.333
G1 X187.483 Y153.117 E.70467
G1 X187.616 Y152.983
G1 X187.616 Y152.45
G1 X187.483 Y152.583
G1 X170.733 Y169.333 E.72784
G1 X170.6 Y169.466
G1 X170.066 Y169.466
G1 X170.2 Y169.333
G1 X187.483 Y152.05 E.75101
G1 X187.616 Y151.916
G1 X187.616 Y151.383
G1 X187.483 Y151.517
G1 X169.667 Y169.333 E.77419
G1 X169.533 Y169.466
G1 X169 Y169.466
G1 X169.133 Y169.333
G1 X187.483 Y150.983 E.79736
G1 X187.616 Y150.85
G1 X187.399 Y150.534
G1 X187.265 Y150.667
G1 X168.6 Y169.333 E.8111
G1 X168.467 Y169.466
G1 X167.933 Y169.466
G1 X168.067 Y169.333
G1 X186.732 Y150.667 E.8111
G1 X186.866 Y150.534
G1 X186.333 Y150.534
G1 X186.199 Y150.667
G1 X167.534 Y169.333 E.8111
G1 X167.4 Y169.466
G1 X166.867 Y169.466
G1 X167 Y169.333
G1 X185.666 Y150.667 E.8111
G1 X185.799 Y150.534
G1 X185.266 Y150.534
G1 X185.132 Y150.667
M73 P48 R8
G1 X166.467 Y169.333 E.8111
G1 X166.334 Y169.466
G1 X165.89 Y169.376
G1 X166.024 Y169.243
G1 X184.599 Y150.667 E.80719
G1 X184.733 Y150.534
G1 X184.2 Y150.534
G1 X184.066 Y150.667
G1 X167.953 Y166.78 E.70019
G1 X167.819 Y166.914
G1 X167.921 Y166.279
G1 X168.055 Y166.145
G1 X183.533 Y150.667 E.6726
G1 X183.666 Y150.534
G1 X183.133 Y150.534
G1 X182.999 Y150.667
G1 X168.069 Y165.598 E.6488
G1 X167.935 Y165.731
G1 X167.762 Y165.371
G1 X167.896 Y165.238
G1 X182.466 Y150.667 E.63316
G1 X182.6 Y150.534
G1 X182.067 Y150.534
G1 X181.933 Y150.667
G1 X167.711 Y164.889 E.61799
G1 X167.578 Y165.023
G1 X167.351 Y164.716
G1 X167.485 Y164.582
G1 X181.4 Y150.667 E.60466
G1 X181.533 Y150.534
G1 X181 Y150.534
G1 X180.866 Y150.667
G1 X167.214 Y164.319 E.59325
G1 X167.081 Y164.453
G1 X166.765 Y164.235
G1 X166.899 Y164.102
G1 X180.333 Y150.667 E.58378
G1 X180.467 Y150.534
G1 X179.934 Y150.534
G1 X179.8 Y150.667
G1 X166.535 Y163.932 E.57641
G1 X166.402 Y164.066
G1 X165.978 Y163.956
G1 X166.111 Y163.823
G1 X179.267 Y150.667 E.57166
G1 X179.4 Y150.534
G1 X178.867 Y150.534
G1 X178.733 Y150.667
G1 X165.601 Y163.8 E.57067
G1 X165.467 Y163.933
G1 X164.783 Y164.084
G1 X164.917 Y163.951
G1 X178.2 Y150.667 E.57723
G1 X178.334 Y150.534
G1 X177.8 Y150.534
G1 X177.667 Y150.667
G1 X162.53 Y165.804 E.65775
G1 X162.397 Y165.938
G1 X162.384 Y165.417
G1 X162.517 Y165.284
G1 X177.134 Y150.667 E.63514
G1 X177.267 Y150.534
G1 X176.734 Y150.534
G1 X176.6 Y150.667
G1 X162.517 Y164.75 E.61197
G1 X162.384 Y164.884
G1 X162.384 Y164.351
G1 X162.517 Y164.217
G1 X176.067 Y150.667 E.5888
G1 X176.201 Y150.534
G1 X175.667 Y150.534
G1 X175.534 Y150.667
G1 X162.517 Y163.684 E.56563
G1 X162.384 Y163.817
G1 X162.384 Y163.284
G1 X162.517 Y163.151
G1 X175.001 Y150.667 E.54245
G1 X175.134 Y150.534
G1 X174.601 Y150.534
G1 X174.467 Y150.667
G1 X162.517 Y162.617 E.51928
G1 X162.384 Y162.751
G1 X162.384 Y162.218
G1 X162.517 Y162.084
G1 X173.934 Y150.667 E.49611
G1 X174.068 Y150.534
G1 X173.534 Y150.534
G1 X173.401 Y150.667
G1 X162.517 Y161.551 E.47294
G1 X162.384 Y161.684
G1 X162.384 Y161.151
G1 X162.517 Y161.018
G1 X172.868 Y150.667 E.44976
G1 X173.001 Y150.534
G1 X172.468 Y150.534
G1 X172.334 Y150.667
G1 X162.517 Y160.484 E.42659
G1 X162.384 Y160.618
G1 X162.384 Y160.085
G1 X162.517 Y159.951
G1 X171.801 Y150.667 E.40342
G1 X171.935 Y150.534
G1 X171.401 Y150.534
G1 X171.268 Y150.667
G1 X162.517 Y159.418 E.38025
G1 X162.384 Y159.551
G1 X162.384 Y159.018
G1 X162.517 Y158.884
G1 X170.734 Y150.667 E.35707
G1 X170.868 Y150.534
G1 X170.335 Y150.534
G1 X170.201 Y150.667
G1 X162.517 Y158.351 E.3339
G1 X162.384 Y158.485
G1 X162.384 Y157.952
G1 X162.517 Y157.818
G1 X169.668 Y150.667 E.31073
G1 X169.802 Y150.534
G1 X169.268 Y150.534
G1 X169.135 Y150.667
G1 X162.517 Y157.285 E.28755
G1 X162.384 Y157.418
G1 X162.384 Y156.885
G1 X162.517 Y156.751
G1 X168.601 Y150.667 E.26438
G1 X168.735 Y150.534
G1 X168.202 Y150.534
G1 X168.068 Y150.667
G1 X162.517 Y156.218 E.24121
G1 X162.384 Y156.352
G1 X162.384 Y155.819
G1 X162.517 Y155.685
G1 X167.535 Y150.667 E.21804
G1 X167.669 Y150.534
G1 X167.135 Y150.534
G1 X167.002 Y150.667
G1 X162.517 Y155.152 E.19486
G1 X162.384 Y155.285
G1 X162.384 Y154.752
G1 X162.517 Y154.618
G1 X166.468 Y150.667 E.17169
G1 X166.602 Y150.534
G1 X166.069 Y150.534
G1 X165.935 Y150.667
G1 X162.517 Y154.085 E.14852
G1 X162.384 Y154.219
G1 X162.384 Y153.686
G1 X162.517 Y153.552
G1 X165.402 Y150.667 E.12535
G1 X165.536 Y150.534
G1 X165.002 Y150.534
G1 X164.869 Y150.667
G1 X162.517 Y153.019 E.10217
G1 X162.384 Y153.152
G1 X162.384 Y152.619
G1 X162.517 Y152.485
G1 X164.335 Y150.667 E.079
G1 X164.469 Y150.534
G1 X163.936 Y150.534
G1 X163.802 Y150.667
G1 X162.517 Y151.952 E.05583
G1 X162.384 Y152.086
G1 X162.384 Y151.553
G1 X162.517 Y151.419
G1 X163.269 Y150.667 E.03266
; WIPE_START
M204 S8000
G1 X162.517 Y151.419 E-.40385
G1 X162.384 Y151.553 E-.07182
G1 X162.384 Y152.086 E-.20264
G1 X162.517 Y151.952 E-.07182
G1 X162.536 Y151.934 E-.00987
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X168.884 Y156.17 Z2.4 F60000
G1 X187.483 Y168.581 Z2.4
G1 Z2
G1 E.8 F1800
G1 F9547.055
M204 S2000
G1 X186.731 Y169.333 E.03266
G1 X186.597 Y169.466
G1 X186.064 Y169.466
G1 X186.198 Y169.333
G1 X187.483 Y168.048 E.05584
G1 X187.616 Y167.914
G1 X187.616 Y167.381
G1 X187.483 Y167.514
G1 X185.664 Y169.333 E.07901
G1 X185.531 Y169.466
G1 X184.998 Y169.466
G1 X185.131 Y169.333
G1 X187.483 Y166.981 E.10218
G1 X187.616 Y166.848
G1 X187.616 Y166.314
G1 X187.483 Y166.448
G1 X184.598 Y169.333 E.12535
M204 S10000
G1 X186.9 Y166.231 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.37286
G1 F10911.075
M204 S8000
G1 X186.937 Y166.328 E.00281
; LINE_WIDTH: 0.401489
G1 F10039.909
G1 X186.974 Y166.426 E.00305
; LINE_WIDTH: 0.392918
G1 F10285.794
G1 X186.842 Y166.59 E.006
; LINE_WIDTH: 0.347141
G1 F11833.519
G1 X186.711 Y166.754 E.00521
; LINE_WIDTH: 0.301364
G1 F13929.525
G1 X186.579 Y166.918 E.00443
; LINE_WIDTH: 0.255587
G1 F15000
G1 X186.448 Y167.082 E.00364
; LINE_WIDTH: 0.209811
G1 X186.316 Y167.246 E.00286
; LINE_WIDTH: 0.163801
G1 X186.183 Y167.412 E.00209
; LINE_WIDTH: 0.113791
G1 X185.887 Y167.737 E.00254
G1 X185.555 Y168.038 E.00258
; LINE_WIDTH: 0.165195
G1 X185.366 Y168.19 E.00242
; LINE_WIDTH: 0.210765
G1 X185.177 Y168.342 E.00332
; LINE_WIDTH: 0.256334
G1 X184.987 Y168.494 E.00422
; LINE_WIDTH: 0.301904
G1 F13900.492
G1 X184.798 Y168.646 E.00513
; LINE_WIDTH: 0.347474
G1 F11820.592
G1 X184.608 Y168.798 E.00603
; LINE_WIDTH: 0.393043
G1 F10282.104
G1 X184.419 Y168.95 E.00693
; WIPE_START
G1 X184.608 Y168.798 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X183.59 Y163.802 Z2.4 F60000
G1 Z2
G1 E.8 F1800
; LINE_WIDTH: 0.117084
G1 F15000
M204 S8000
G2 X183.284 Y164.007 I10.537 J16.035 E.00223
M204 S10000
G1 X183.674 Y163.885 F60000
; LINE_WIDTH: 0.174448
G1 F15000
M204 S8000
G1 X183.561 Y163.857 E.00124
G2 X183.49 Y163.871 I-.029 J.043 E.00087
G1 X183.281 Y164.002 E.00264
M204 S10000
G1 X182.154 Y165.138 F60000
; LINE_WIDTH: 0.103092
G1 F15000
M204 S8000
G1 X182.064 Y165.263 E.00076
; WIPE_START
G1 X182.154 Y165.138 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X174.665 Y166.611 Z2.4 F60000
G1 X166.816 Y168.156 Z2.4
G1 Z2
G1 E.8 F1800
; LINE_WIDTH: 0.110095
G1 F15000
M204 S8000
G1 X166.633 Y168.303 E.00128
; LINE_WIDTH: 0.153936
G1 X166.45 Y168.449 E.00212
; LINE_WIDTH: 0.197777
G1 X166.267 Y168.596 E.00296
; LINE_WIDTH: 0.241617
G1 X166.084 Y168.743 E.0038
; LINE_WIDTH: 0.285458
G1 F14843.055
G1 X165.901 Y168.89 E.00463
; WIPE_START
G1 X166.084 Y168.743 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X163.877 Y164.753 Z2.4 F60000
G1 Z2
G1 E.8 F1800
; LINE_WIDTH: 0.0920907
G1 F15000
M204 S8000
G1 X163.831 Y164.807 E.00028
; LINE_WIDTH: 0.119181
G1 X163.68 Y164.996 E.0015
; LINE_WIDTH: 0.165322
G1 X163.529 Y165.184 E.00241
; LINE_WIDTH: 0.211463
G1 X163.378 Y165.373 E.00332
; LINE_WIDTH: 0.257604
G1 X163.226 Y165.561 E.00423
; LINE_WIDTH: 0.303744
G1 F13802.415
G1 X163.075 Y165.75 E.00514
; LINE_WIDTH: 0.349885
G1 F11727.735
G1 X162.924 Y165.938 E.00605
M204 S10000
G1 X164.571 Y164.091 F60000
; LINE_WIDTH: 0.10302
G1 F15000
M204 S8000
G1 X164.406 Y164.224 E.00104
; CHANGE_LAYER
; Z_HEIGHT: 2.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F15000
G1 X164.571 Y164.091 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 11/85
; update layer progress
M73 L11
M991 S0 P10 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 5
M204 S10000
G17
G3 Z2.4 I.508 J1.106 P1  F60000
G1 X187.298 Y153.648 Z2.4
G1 Z2.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2840
M204 S8000
G1 X162.702 Y153.648 E.81589
G1 X162.702 Y152.852 E.0264
G1 X187.298 Y152.852 E.81589
G1 X187.298 Y153.588 E.02441
; COOLING_NODE: 5
M204 S250
G1 X187.69 Y154.04 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2840
M204 S5000
G1 X162.31 Y154.04 E.77986
G1 X162.31 Y152.46 E.04855
G1 X187.69 Y152.46 E.77986
G1 X187.69 Y153.98 E.04671
M204 S10000
M73 P49 R8
G1 X187.094 Y153.25 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F2840
M204 S8000
G1 X162.906 Y153.25 E.76636
; COOLING_NODE: 1
; WIPE_START
G1 F9259.259
G1 X164.906 Y153.25 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.159 Y157.626 Z2.6 F60000
G1 X182.16 Y165.326 Z2.6
G1 Z2.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2840
M204 S8000
G1 X182.177 Y165.265 E.00211
G3 X184.248 Y163.867 I2.07 J.833 E.08798
G1 X184.366 Y163.87 E.00392
G3 X182.057 Y165.674 I-.119 J2.229 E.3591
G1 X182.143 Y165.384 E.01003
; COOLING_NODE: 1
M204 S10000
G1 X181.752 Y165.25 F60000
G1 F2840
M204 S8000
G1 X181.801 Y165.111 E.0049
G3 X184.25 Y163.459 I2.447 J.987 E.10398
G1 X184.388 Y163.463 E.00457
G3 X181.725 Y165.328 I-.139 J2.635 E.43379
G1 X181.732 Y165.307 E.00074
; COOLING_NODE: 1
M204 S10000
G1 X181.374 Y165.098 F60000
G1 F2840
M204 S8000
G1 X181.388 Y165.056 E.00149
G3 X184.252 Y163.052 I2.862 J1.042 E.1235
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X184.409 Y163.056 E.00521
G3 X181.294 Y165.363 I-.16 J3.041 E.49542
G1 X181.356 Y165.156 E.00717
; COOLING_NODE: 1
M204 S250
G1 X180.999 Y164.984 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2840
M204 S5000
G1 X181.02 Y164.923 E.00195
G3 X184.254 Y162.66 I3.231 J1.174 E.1292
G1 X184.43 Y162.665 E.0054
G3 X180.914 Y165.268 I-.179 J3.433 E.51799
G1 X180.982 Y165.041 E.00728
; WIPE_START
G1 F9547.055
M204 S8000
G1 X181.02 Y164.923 E-.04695
G1 X181.132 Y164.647 E-.11349
G1 X181.302 Y164.328 E-.13718
G1 X181.503 Y164.03 E-.13663
G1 X181.693 Y163.799 E-.11393
G1 X181.949 Y163.543 E-.13732
G1 X182.1 Y163.418 E-.07451
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X183.995 Y166.062 Z2.6 F60000
G1 Z2.2
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.54046
G1 F2840
M204 S8000
G1 X184.043 Y166.253 E.00798
G1 X184.226 Y166.349 E.00837
G1 X184.361 Y166.332 E.00551
G1 X184.493 Y166.186 E.00798
G1 X184.498 Y166.129 E.00234
G1 X184.446 Y165.924 E.00857
G1 X184.302 Y165.843 E.0067
G1 X184.112 Y165.891 E.00792
G1 X184.029 Y166.013 E.00597
M204 S10000
G1 X183.654 Y165.742 F60000
; LINE_WIDTH: 0.41999
G1 F2840
M204 S8000
G1 X183.556 Y166.063 E.0103
G1 X183.616 Y166.364 E.00943
G1 X183.733 Y166.564 E.00713
G1 X183.988 Y166.735 E.00943
G1 X184.286 Y166.794 E.00935
G1 X184.607 Y166.696 E.0103
G1 X184.826 Y166.475 E.00955
G1 X184.924 Y166.27 E.00698
G1 X184.933 Y166.171 E.00306
G1 X184.889 Y165.811 E.01114
G1 X184.717 Y165.579 E.00888
G1 X184.433 Y165.421 E.00999
G1 X184.187 Y165.402 E.00759
G1 X183.871 Y165.526 E.01041
G1 X183.697 Y165.7 E.00757
M204 S10000
G1 X183.328 Y165.546 F60000
G1 F2840
M204 S8000
G1 X183.185 Y165.941 E.01291
G1 X183.206 Y166.36 E.0129
G1 X183.384 Y166.741 E.01291
G1 X183.696 Y167.022 E.0129
G2 X184.306 Y167.175 I.556 J-.93 E.01962
G1 X184.714 Y167.072 E.01291
G1 X185.05 Y166.82 E.01289
G1 X185.265 Y166.459 E.01292
G2 X185.179 Y165.546 I-1.432 J-.327 E.02869
G1 X184.9 Y165.235 E.01283
G1 X184.529 Y165.055 E.01266
G1 X184.124 Y165.028 E.01249
G1 X183.794 Y165.125 E.01056
G1 X183.533 Y165.298 E.00962
G1 X183.366 Y165.5 E.00806
M204 S10000
G1 X183.001 Y165.349 F60000
G1 F2840
M204 S8000
G1 X182.812 Y165.885 E.01747
G1 X182.836 Y166.453 E.01745
G1 X183.081 Y166.965 E.01746
G1 X183.499 Y167.349 E.01744
G1 X183.897 Y167.514 E.01324
G1 X184.326 Y167.556 E.01324
G1 X184.876 Y167.412 E.01746
G1 X185.333 Y167.076 E.01744
G1 X185.621 Y166.585 E.01746
G2 X185.608 Y165.565 I-1.575 J-.49 E.03187
G1 X185.336 Y165.123 E.01596
G1 X185.011 Y164.861 E.01282
G1 X184.626 Y164.688 E.01295
G1 X184.207 Y164.647 E.01293
G2 X183.633 Y164.779 I.419 J3.12 E.01813
G1 X183.279 Y165.014 E.01307
G1 X183.039 Y165.303 E.01153
M204 S10000
G1 X182.674 Y165.152 F60000
G1 F2840
M204 S8000
G1 X182.465 Y165.66 E.01687
G1 X182.414 Y165.999 E.01055
G1 X182.466 Y166.545 E.01684
G1 X182.676 Y167.051 E.01685
G1 X182.88 Y167.327 E.01054
G1 X183.303 Y167.676 E.01684
G1 X183.805 Y167.884 E.0167
G1 X184.346 Y167.936 E.0167
G1 X184.883 Y167.826 E.01685
G1 X185.193 Y167.679 E.01054
G1 X185.616 Y167.331 E.01684
G1 X185.919 Y166.872 E.01687
G2 X186.059 Y166.281 I-1.123 J-.579 E.01887
G1 X186.086 Y166.004 E.00853
G1 X185.967 Y165.442 E.01766
G1 X185.715 Y165.002 E.01557
G1 X185.356 Y164.631 E.01588
G1 X184.9 Y164.388 E.01588
G1 X184.506 Y164.288 E.0125
G1 X183.999 Y164.278 E.01558
G1 X183.473 Y164.434 E.01686
G1 X183.024 Y164.73 E.01653
G1 X182.712 Y165.106 E.015
; COOLING_NODE: 2
; WIPE_START
G1 F9547.299
G1 X183.024 Y164.73 E-.18549
G1 X183.473 Y164.434 E-.20441
G1 X183.999 Y164.278 E-.20855
G1 X184.424 Y164.286 E-.16155
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X179.498 Y165.248 Z2.6 F60000
G1 Z2.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2840
M204 S8000
G1 X178.702 Y165.248 E.0264
G1 X178.702 Y164.452 E.0264
G1 X179.498 Y164.452 E.0264
G1 X179.498 Y165.188 E.02441
; COOLING_NODE: 2
M204 S250
G1 X179.89 Y165.64 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2840
M204 S5000
G1 X178.31 Y165.64 E.04855
G1 X178.31 Y164.06 E.04855
G1 X179.89 Y164.06 E.04855
G1 X179.89 Y165.58 E.04671
; COOLING_NODE: 2
; WIPE_START
G1 F9547.055
M204 S8000
G1 X178.31 Y165.64 E-.60084
G1 X178.31 Y165.221 E-.15917
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X170.678 Y165.247 Z2.6 F60000
G1 X170.502 Y165.248 Z2.6
G1 Z2.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2840
M204 S8000
G1 X170.502 Y164.452 E.0264
G1 X171.298 Y164.452 E.0264
G1 X171.298 Y165.248 E.0264
G1 X170.562 Y165.248 E.02441
; COOLING_NODE: 2
M204 S250
G1 X170.11 Y165.64 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2840
M204 S5000
G1 X170.11 Y164.06 E.04855
G1 X171.69 Y164.06 E.04855
G1 X171.69 Y165.64 E.04855
G1 X170.17 Y165.64 E.04671
; COOLING_NODE: 4
; WIPE_START
G1 F9547.055
M204 S8000
G1 X170.11 Y164.06 E-.60084
G1 X170.529 Y164.06 E-.15917
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X167.836 Y165.311 Z2.6 F60000
G1 Z2.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2840
M204 S8000
G3 X165.748 Y163.867 I-2.088 J.788 E.37559
G1 X165.866 Y163.87 E.00392
G3 X167.814 Y165.255 I-.119 J2.229 E.08366
; COOLING_NODE: 4
M204 S10000
G1 X168.216 Y165.163 F60000
G1 F2840
M204 S8000
G3 X165.75 Y163.459 I-2.467 J.935 E.44424
G1 X165.888 Y163.463 E.00457
G3 X168.194 Y165.107 I-.139 J2.635 E.09918
; COOLING_NODE: 4
M204 S10000
G1 X168.596 Y165.015 F60000
G1 F2840
M204 S8000
G3 X165.752 Y163.052 I-2.847 J1.083 E.51289
G1 X165.909 Y163.056 E.00521
G3 X168.574 Y164.96 I-.16 J3.041 E.1147
; COOLING_NODE: 4
M204 S250
G1 X168.962 Y164.873 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2840
M204 S5000
G3 X165.754 Y162.66 I-3.212 J1.225 E.53634
G1 X165.93 Y162.665 E.0054
G3 X168.941 Y164.817 I-.179 J3.433 E.12009
; WIPE_START
G1 F9547.055
M204 S8000
G1 X169.073 Y165.21 E-.15757
G1 X169.148 Y165.562 E-.13659
G1 X169.185 Y165.92 E-.13686
G1 X169.185 Y166.28 E-.13665
G1 X169.156 Y166.583 E-.11572
G1 X169.117 Y166.781 E-.07661
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X165.946 Y165.924 Z2.6 F60000
G1 Z2.2
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.54043
G1 F2840
M204 S8000
G1 X165.802 Y165.843 E.0067
G1 X165.611 Y165.892 E.00797
G1 X165.495 Y166.062 E.00834
G1 X165.546 Y166.26 E.00828
G1 X165.726 Y166.349 E.00814
G1 X165.861 Y166.332 E.00551
G1 X165.993 Y166.186 E.00798
G2 X165.961 Y165.982 I-.298 J-.058 E.00854
M204 S10000
G1 X166.389 Y165.811 F60000
; LINE_WIDTH: 0.41999
G1 F2840
M204 S8000
G1 X166.217 Y165.579 E.00888
G1 X165.933 Y165.421 E.00999
G1 X165.686 Y165.402 E.00759
G1 X165.37 Y165.528 E.01048
G1 X165.155 Y165.742 E.00932
G1 X165.056 Y166.063 E.01032
G1 X165.122 Y166.378 E.0099
G1 X165.256 Y166.587 E.00764
G1 X165.488 Y166.735 E.00845
G1 X165.786 Y166.794 E.00936
G1 X166.107 Y166.696 E.0103
G1 X166.326 Y166.475 E.00955
G1 X166.424 Y166.27 E.00698
G1 X166.433 Y166.171 E.00307
G1 X166.396 Y165.871 E.00929
M204 S10000
G1 X166.679 Y165.546 F60000
G1 F2840
M204 S8000
G1 X166.4 Y165.235 E.01283
G1 X166.029 Y165.055 E.01266
G1 X165.624 Y165.028 E.01249
G1 X165.295 Y165.125 E.01053
G2 X164.828 Y165.545 I.46 J.981 E.01961
G1 X164.685 Y165.941 E.01292
G1 X164.706 Y166.36 E.0129
G1 X164.894 Y166.751 E.01333
G1 X165.191 Y167.021 E.01233
G2 X165.806 Y167.175 I.561 J-.936 E.01976
G1 X166.214 Y167.072 E.01291
G1 X166.549 Y166.82 E.01289
G1 X166.765 Y166.46 E.01292
G2 X166.698 Y165.603 I-1.384 J-.323 E.02683
M204 S10000
G1 X166.836 Y165.123 F60000
G1 F2840
M204 S8000
G1 X166.511 Y164.861 E.01282
G1 X166.126 Y164.688 E.01295
G1 X165.707 Y164.647 E.01293
G2 X165.134 Y164.779 I.411 J3.085 E.01811
G1 X164.775 Y165.018 E.01325
G1 X164.501 Y165.349 E.01321
G1 X164.312 Y165.885 E.01747
G1 X164.336 Y166.453 E.01745
G1 X164.508 Y166.866 E.01375
G2 X164.997 Y167.348 I1.707 J-1.241 E.0212
G1 X165.397 Y167.514 E.01331
G1 X165.826 Y167.556 E.01325
G1 X166.376 Y167.412 E.01746
G1 X166.833 Y167.076 E.01744
G1 X167.121 Y166.585 E.01747
G2 X167.108 Y165.565 I-1.575 J-.49 E.03187
G1 X166.867 Y165.174 E.01412
M204 S10000
G1 X167.215 Y165.002 F60000
G1 F2840
M204 S8000
G1 X166.856 Y164.63 E.01588
G1 X166.4 Y164.388 E.01587
G1 X166.006 Y164.288 E.0125
G1 X165.499 Y164.278 E.01558
G1 X164.973 Y164.433 E.01685
G1 X164.52 Y164.734 E.01671
G1 X164.174 Y165.152 E.01667
G1 X163.965 Y165.66 E.01686
G1 X163.914 Y165.999 E.01055
G1 X163.966 Y166.545 E.01685
G1 X164.178 Y167.055 E.01696
G1 X164.402 Y167.351 E.01141
G1 X164.802 Y167.676 E.01583
G1 X165.305 Y167.884 E.01672
G1 X165.846 Y167.936 E.01671
G1 X166.383 Y167.826 E.01685
G1 X166.693 Y167.679 E.01054
G1 X167.116 Y167.331 E.01683
G1 X167.419 Y166.873 E.01688
G2 X167.559 Y166.281 I-1.122 J-.579 E.01887
G1 X167.586 Y166.004 E.00853
G1 X167.467 Y165.442 E.01766
G1 X167.245 Y165.054 E.01373
; CHANGE_LAYER
; Z_HEIGHT: 2.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9547.299
G1 X167.467 Y165.442 E-.16984
G1 X167.586 Y166.004 E-.21843
G1 X167.559 Y166.281 E-.10549
G1 X167.533 Y166.55 E-.10286
G1 X167.419 Y166.873 E-.12996
G1 X167.37 Y166.946 E-.03343
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 12/85
; update layer progress
M73 L12
M991 S0 P11 ;notify layer change

; OBJECT_ID: 15
M204 S10000
G17
G3 Z2.6 I.632 J1.04 P1  F60000
G1 X172.269 Y163.972 Z2.6
G1 Z2.4
G1 E.8 F1800
; FEATURE: Support interface
; LINE_WIDTH: 0.42
G1 F3044
M204 S8000
G1 X172.622 Y163.618 E.01535
G1 X173.862 Y163.618 E.03811
G1 X172.438 Y165.042 E.06188
G1 X172.43 Y166.082 E.03194
G1 X172.639 Y166.082 E.00644
G1 X175.103 Y163.618 E.10704
G1 X176.343 Y163.618 E.03811
G1 X173.88 Y166.082 E.10704
G1 X175.12 Y166.082 E.03811
G1 X177.562 Y163.64 E.10609
G1 X177.562 Y164.881 E.03811
G1 X176.191 Y166.251 E.05957
; COOLING_NODE: 5
; WIPE_START
G1 F4800
G1 X177.562 Y164.881 E-.73664
G1 X177.562 Y164.819 E-.02337
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X182.576 Y159.065 Z2.8 F60000
G1 X187.298 Y153.648 Z2.8
G1 Z2.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F3044
M204 S8000
G1 X162.702 Y153.648 E.81589
G1 X162.702 Y152.852 E.0264
G1 X187.298 Y152.852 E.81589
G1 X187.298 Y153.588 E.02441
; COOLING_NODE: 5
M204 S250
G1 X187.69 Y154.04 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2867
M204 S5000
G1 X162.31 Y154.04 E.77986
G1 X162.31 Y152.46 E.04855
G1 X187.69 Y152.46 E.77986
G1 X187.69 Y153.98 E.04671
M204 S10000
M73 P50 R8
G1 X187.094 Y153.25 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F3044
M204 S8000
G1 X162.906 Y153.25 E.76636
; COOLING_NODE: 1
; WIPE_START
G1 F9259.259
G1 X164.906 Y153.25 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.148 Y157.641 Z2.8 F60000
G1 X182.138 Y165.373 Z2.8
G1 Z2.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F3044
M204 S8000
G3 X184.256 Y163.867 I2.111 J.726 E.092
G1 X184.365 Y163.87 E.00364
G3 X182.12 Y165.43 I-.116 J2.229 E.36753
; COOLING_NODE: 1
M204 S10000
G1 X181.756 Y165.242 F60000
G1 F3044
M204 S8000
G1 X181.802 Y165.112 E.0046
G3 X184.387 Y163.463 I2.449 J.988 E.1085
G3 X184.526 Y168.726 I-.141 J2.637 E.26124
G3 X181.713 Y165.373 I-.275 J-2.626 E.17118
G1 X181.737 Y165.299 E.00256
; COOLING_NODE: 1
M204 S10000
G1 X181.37 Y165.108 F60000
G1 F3044
M204 S8000
G3 X184.261 Y163.052 I2.88 J.99 E.12561
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X184.409 Y163.056 E.00489
G3 X181.351 Y165.165 I-.158 J3.042 E.5023
; COOLING_NODE: 1
M204 S250
G1 X181 Y164.981 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2867
M204 S5000
G3 X184.264 Y162.66 I3.251 J1.117 E.13134
G1 X184.43 Y162.665 E.0051
G3 X180.981 Y165.038 I-.178 J3.433 E.52539
; WIPE_START
G1 F9547.055
M204 S8000
G1 X181.133 Y164.645 E-.15986
G1 X181.271 Y164.38 E-.11358
G1 X181.467 Y164.078 E-.13691
G1 X181.694 Y163.798 E-.13683
G1 X181.948 Y163.544 E-.13672
G1 X182.104 Y163.418 E-.0761
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X184.059 Y165.928 Z2.8 F60000
G1 Z2.4
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.541325
G1 F3044
M204 S8000
G1 X183.991 Y166.142 E.00912
G1 X184.086 Y166.305 E.00768
G1 X184.249 Y166.361 E.007
G1 X184.425 Y166.278 E.00788
G2 X184.511 Y166.068 I-.458 J-.31 E.00929
G1 X184.374 Y165.871 E.00975
G1 X184.221 Y165.848 E.00628
G1 X184.113 Y165.901 E.00491
M204 S10000
G1 X183.684 Y165.699 F60000
; LINE_WIDTH: 0.41999
G1 F3044
M204 S8000
G1 X183.565 Y166.008 E.01019
G1 X183.57 Y166.265 E.00789
G1 X183.691 Y166.521 E.00869
G1 X183.899 Y166.704 E.00852
G1 X184.144 Y166.792 E.008
G1 X184.441 Y166.775 E.00913
G1 X184.732 Y166.591 E.01058
G1 X184.903 Y166.337 E.0094
G1 X184.949 Y166.05 E.00894
G1 X184.862 Y165.781 E.00867
G1 X184.647 Y165.524 E.01028
G1 X184.367 Y165.411 E.00929
G1 X184.135 Y165.418 E.00714
G1 X183.87 Y165.528 E.00882
G1 X183.729 Y165.658 E.00591
M204 S10000
G1 X183.45 Y165.38 F60000
G1 F3044
M204 S8000
G1 X183.23 Y165.755 E.01335
G1 X183.175 Y166.163 E.01266
G1 X183.226 Y166.448 E.00891
G1 X183.447 Y166.824 E.01339
G1 X183.794 Y167.08 E.01325
G1 X184.189 Y167.18 E.01253
G1 X184.575 Y167.13 E.01195
G1 X184.883 Y166.97 E.01067
G2 X185.261 Y166.468 I-.638 J-.874 E.01961
G1 X185.325 Y166.034 E.01348
G2 X185.124 Y165.471 I-1.01 J.044 E.01864
G1 X184.779 Y165.163 E.01423
G1 X184.534 Y165.056 E.00821
G1 X184.124 Y165.028 E.01263
G1 X183.795 Y165.125 E.01053
G1 X183.499 Y165.344 E.01134
M204 S10000
G1 X183.016 Y165.35 F60000
G1 F3044
M204 S8000
G1 X182.87 Y165.628 E.00967
G1 X182.792 Y166.031 E.01259
G1 X182.837 Y166.44 E.01267
G1 X182.997 Y166.851 E.01354
G1 X183.265 Y167.17 E.0128
G1 X183.632 Y167.423 E.01368
G1 X184.033 Y167.538 E.01283
G1 X184.48 Y167.542 E.01374
G2 X185.107 Y167.279 I-.545 J-2.175 E.02098
G1 X185.412 Y166.98 E.01313
G1 X185.62 Y166.598 E.01334
G1 X185.708 Y166.161 E.0137
G2 X185.431 Y165.246 I-1.648 J-.002 E.02982
G1 X185.118 Y164.928 E.01371
G1 X184.748 Y164.732 E.01287
G1 X184.327 Y164.641 E.01322
G2 X183.634 Y164.779 I.088 J2.257 E.02181
G1 X183.261 Y165.027 E.01375
G1 X183.052 Y165.302 E.01062
M204 S10000
G1 X182.767 Y165.012 F60000
G1 F3044
M204 S8000
G1 X182.511 Y165.502 E.017
G1 X182.413 Y166.002 E.01563
G1 X182.465 Y166.507 E.0156
G1 X182.595 Y166.88 E.01214
G1 X182.883 Y167.331 E.01645
G1 X183.294 Y167.66 E.01616
G1 X183.644 Y167.827 E.01192
G1 X184.153 Y167.937 E.01599
G1 X184.673 Y167.883 E.01607
G2 X185.331 Y167.588 I-1.235 J-3.633 E.0222
G1 X185.716 Y167.209 E.01659
G1 X185.978 Y166.729 E.01681
G1 X186.087 Y166.191 E.01686
G1 X186.079 Y166.002 E.00582
G1 X185.979 Y165.472 E.01657
G1 X185.738 Y165.02 E.01573
G1 X185.353 Y164.629 E.01686
G1 X184.877 Y164.378 E.01655
G1 X184.349 Y164.263 E.01661
G1 X183.999 Y164.278 E.01076
G1 X183.473 Y164.433 E.01685
G1 X183.013 Y164.739 E.01696
G1 X182.807 Y164.968 E.00945
; COOLING_NODE: 2
; WIPE_START
G1 F9547.299
G1 X183.013 Y164.739 E-.11692
G1 X183.473 Y164.433 E-.20978
G1 X183.999 Y164.278 E-.20838
G1 X184.349 Y164.263 E-.13307
G1 X184.585 Y164.314 E-.09186
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X179.498 Y165.248 Z2.8 F60000
G1 Z2.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F3044
M204 S8000
G1 X178.702 Y165.248 E.0264
G1 X178.702 Y164.452 E.0264
G1 X179.498 Y164.452 E.0264
G1 X179.498 Y165.188 E.02441
; COOLING_NODE: 2
M204 S250
G1 X179.89 Y165.64 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2882
M204 S5000
G1 X178.31 Y165.64 E.04855
G1 X178.31 Y164.06 E.04855
G1 X179.89 Y164.06 E.04855
G1 X179.89 Y165.58 E.04671
; COOLING_NODE: 2
; WIPE_START
G1 F9547.055
M204 S8000
G1 X178.31 Y165.64 E-.60084
G1 X178.31 Y165.221 E-.15917
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X170.678 Y165.247 Z2.8 F60000
G1 X170.502 Y165.248 Z2.8
G1 Z2.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F3044
M204 S8000
G1 X170.502 Y164.452 E.0264
G1 X171.298 Y164.452 E.0264
G1 X171.298 Y165.248 E.0264
G1 X170.562 Y165.248 E.02441
; COOLING_NODE: 2
M204 S250
G1 X170.11 Y165.64 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2882
M204 S5000
G1 X170.11 Y164.06 E.04855
G1 X171.69 Y164.06 E.04855
G1 X171.69 Y165.64 E.04855
G1 X170.17 Y165.64 E.04671
; COOLING_NODE: 4
; WIPE_START
G1 F9547.055
M204 S8000
G1 X170.11 Y164.06 E-.60084
G1 X170.529 Y164.06 E-.15917
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X167.845 Y165.331 Z2.8 F60000
G1 Z2.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F3044
M204 S8000
G3 X165.756 Y163.867 I-2.096 J.767 E.37506
G1 X165.865 Y163.87 E.00364
G3 X167.823 Y165.275 I-.116 J2.229 E.08446
; COOLING_NODE: 4
M204 S10000
G1 X168.229 Y165.193 F60000
G1 F3044
M204 S8000
G3 X165.758 Y163.459 I-2.479 J.905 E.44339
G1 X165.887 Y163.463 E.00427
G3 X168.207 Y165.137 I-.137 J2.635 E.10032
; COOLING_NODE: 4
M204 S10000
G1 X168.608 Y165.044 F60000
G1 F3044
M204 S8000
G1 X168.612 Y165.056 E.00041
G3 X165.761 Y163.052 I-2.862 J1.042 E.51172
G1 X165.909 Y163.056 E.00489
G3 X168.512 Y164.812 I-.158 J3.042 E.10943
G1 X168.585 Y164.989 E.00634
; COOLING_NODE: 4
M204 S250
G1 X168.97 Y164.894 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2867
M204 S5000
G1 X168.982 Y164.923 E.00096
G3 X165.764 Y162.66 I-3.231 J1.175 E.53497
G1 X165.93 Y162.665 E.0051
G3 X168.868 Y164.647 I-.178 J3.433 E.11441
G1 X168.947 Y164.839 E.00639
; WIPE_START
G1 F9547.055
M204 S8000
G1 X168.982 Y164.923 E-.03472
G1 X169.088 Y165.267 E-.13688
G1 X169.156 Y165.621 E-.13704
G1 X169.185 Y165.92 E-.1141
G1 X169.185 Y166.28 E-.13654
G1 X169.147 Y166.639 E-.13726
G1 X169.114 Y166.802 E-.06347
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X165.913 Y165.894 Z2.8 F60000
G1 Z2.4
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.54135
G1 F3044
M204 S8000
G1 X165.76 Y165.84 E.00663
G1 X165.539 Y165.943 E.00991
G1 X165.489 Y166.111 E.00709
G1 X165.576 Y166.289 E.00803
G1 X165.767 Y166.358 E.00824
G1 X165.942 Y166.259 E.00819
G1 X166.004 Y166.138 E.00552
G2 X165.939 Y165.949 I-.299 J-.003 E.00828
M204 S10000
G1 X166.332 Y165.71 F60000
; LINE_WIDTH: 0.41999
G1 F3044
M204 S8000
G1 X166.107 Y165.5 E.00947
G1 X165.828 Y165.405 E.00904
G1 X165.556 Y165.441 E.00845
G1 X165.256 Y165.603 E.01046
G1 X165.094 Y165.856 E.00923
G1 X165.052 Y166.12 E.00823
G1 X165.116 Y166.388 E.00846
G1 X165.325 Y166.65 E.0103
G1 X165.626 Y166.776 E.01001
G1 X165.835 Y166.795 E.00645
G1 X166.13 Y166.672 E.00983
G1 X166.346 Y166.458 E.00934
G1 X166.444 Y166.138 E.01029
G2 X166.35 Y165.767 I-.919 J.036 E.01183
M204 S10000
G1 X166.554 Y165.376 F60000
G1 F3044
M204 S8000
G1 X166.202 Y165.117 E.01343
G1 X165.806 Y165.02 E.01254
G1 X165.449 Y165.079 E.01112
G1 X165.151 Y165.22 E.01012
G1 X164.886 Y165.449 E.01077
G1 X164.705 Y165.82 E.01268
G1 X164.681 Y166.254 E.01335
G1 X164.772 Y166.551 E.00954
G1 X165.021 Y166.893 E.013
G1 X165.383 Y167.112 E.013
G1 X165.808 Y167.174 E.01321
G1 X166.202 Y167.077 E.01244
G2 X166.672 Y166.654 I-.461 J-.987 E.01974
G1 X166.815 Y166.259 E.01292
G2 X166.584 Y165.429 I-1.384 J-.062 E.02693
M204 S10000
G1 X166.993 Y165.335 F60000
G1 F3044
M204 S8000
G1 X166.729 Y165.025 E.01251
G1 X166.366 Y164.775 E.01356
G1 X165.946 Y164.66 E.01336
G1 X165.561 Y164.653 E.01183
G1 X165.134 Y164.779 E.01369
G1 X164.763 Y165.026 E.0137
G1 X164.506 Y165.348 E.01267
G1 X164.339 Y165.723 E.01263
G1 X164.298 Y166.16 E.01348
G2 X164.427 Y166.714 I2.634 J-.322 E.01749
G1 X164.765 Y167.17 E.01746
G1 X165.252 Y167.47 E.01756
G1 X165.686 Y167.557 E.01359
G2 X166.364 Y167.422 I-.072 J-2.131 E.02134
G1 X166.725 Y167.183 E.01332
G1 X166.999 Y166.851 E.01323
G1 X167.188 Y166.314 E.01747
G2 X167.164 Y165.747 I-3.308 J-.145 E.01746
G1 X167.016 Y165.391 E.01186
M204 S10000
G1 X167.323 Y165.148 F60000
G1 F3044
M204 S8000
G1 X166.984 Y164.747 E.01614
G1 X166.529 Y164.434 E.01698
G1 X166.048 Y164.294 E.0154
G2 X165.315 Y164.333 I-.286 J1.556 E.02275
G1 X164.973 Y164.433 E.01095
G1 X164.516 Y164.737 E.01686
G1 X164.184 Y165.151 E.0163
G1 X163.972 Y165.627 E.01602
G2 X164.083 Y166.876 I1.955 J.456 E.03919
G1 X164.387 Y167.335 E.01691
G1 X164.635 Y167.562 E.01033
G1 X165.122 Y167.828 E.01705
G1 X165.658 Y167.936 E.0168
G1 X166.03 Y167.917 E.01147
G1 X166.526 Y167.767 E.01591
G1 X166.98 Y167.466 E.01674
G1 X167.326 Y167.047 E.01669
G1 X167.536 Y166.539 E.01687
G2 X167.56 Y165.927 I-1.222 J-.355 E.01901
G1 X167.534 Y165.655 E.00841
G1 X167.346 Y165.203 E.01502
; CHANGE_LAYER
; Z_HEIGHT: 2.6
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9547.299
G1 X167.534 Y165.655 E-.18578
G1 X167.56 Y165.927 E-.10398
G1 X167.586 Y166.201 E-.10435
G1 X167.536 Y166.539 E-.13014
G1 X167.326 Y167.047 E-.2087
G1 X167.281 Y167.102 E-.02705
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 13/85
; update layer progress
M73 L13
M991 S0 P12 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 5
M204 S10000
G17
G3 Z2.8 I.679 J1.01 P1  F60000
G1 X187.298 Y153.648 Z2.8
G1 Z2.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2845
M204 S8000
G1 X162.702 Y153.648 E.81589
G1 X162.702 Y152.852 E.0264
G1 X187.298 Y152.852 E.81589
G1 X187.298 Y153.588 E.02441
; COOLING_NODE: 5
M204 S250
G1 X187.69 Y154.04 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2845
M204 S5000
G1 X162.31 Y154.04 E.77986
G1 X162.31 Y152.46 E.04855
G1 X187.69 Y152.46 E.77986
G1 X187.69 Y153.98 E.04671
M204 S10000
G1 X187.094 Y153.25 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F2845
M204 S8000
M73 P51 R8
G1 X162.906 Y153.25 E.76636
; COOLING_NODE: 1
; WIPE_START
G1 F9259.259
G1 X164.906 Y153.25 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
M73 P51 R7
G1 X171.156 Y157.63 Z3 F60000
G1 X182.152 Y165.337 Z3
G1 Z2.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2845
M204 S8000
G3 X184.365 Y163.87 I2.099 J.763 E.09431
G3 X184.484 Y168.321 I-.116 J2.23 E.22112
G3 X182.132 Y165.393 I-.233 J-2.221 E.14796
; COOLING_NODE: 1
M204 S10000
G1 X181.769 Y165.197 F60000
G1 F2845
M204 S8000
G3 X184.387 Y163.463 I2.481 J.903 E.11154
G3 X184.526 Y168.726 I-.138 J2.637 E.26141
G3 X181.75 Y165.254 I-.275 J-2.626 E.1753
; COOLING_NODE: 1
M204 S10000
G1 X181.375 Y165.093 F60000
G1 F2845
M204 S8000
G1 X181.388 Y165.059 E.00122
G3 X184.27 Y163.052 I2.864 J1.041 E.12415
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X184.408 Y163.056 E.00458
G3 X181.295 Y165.364 I-.157 J3.043 E.4958
G1 X181.358 Y165.151 E.00736
; COOLING_NODE: 1
M204 S250
G1 X181.001 Y164.979 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2845
M204 S5000
G1 X181.02 Y164.925 E.00176
G3 X184.273 Y162.66 I3.232 J1.175 E.1298
G1 X184.43 Y162.665 E.0048
G3 X180.915 Y165.268 I-.177 J3.435 E.51837
G1 X180.984 Y165.036 E.00743
; WIPE_START
G1 F9547.055
M204 S8000
G1 X181.02 Y164.925 E-.04459
G1 X181.132 Y164.647 E-.11399
G1 X181.301 Y164.329 E-.13686
G1 X181.503 Y164.029 E-.1371
G1 X181.709 Y163.781 E-.12269
G1 X181.948 Y163.543 E-.12809
G1 X182.105 Y163.417 E-.07668
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X184.005 Y166.04 Z3 F60000
G1 Z2.6
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.54148
G1 F2845
M204 S8000
G1 X184.034 Y166.249 E.00859
G1 X184.152 Y166.341 E.00606
G1 X184.381 Y166.328 E.00932
G1 X184.492 Y166.193 E.0071
G2 X184.457 Y165.939 I-.406 J-.074 E.01059
G1 X184.302 Y165.844 E.00738
G1 X184.112 Y165.892 E.00795
G1 X184.04 Y165.991 E.00496
M204 S10000
G1 X183.654 Y165.742 F60000
; LINE_WIDTH: 0.41999
G1 F2845
M204 S8000
G1 X183.566 Y166.034 E.00936
G1 X183.603 Y166.367 E.0103
G1 X183.777 Y166.617 E.00937
G1 X184.051 Y166.771 E.00966
G1 X184.388 Y166.773 E.01035
G1 X184.643 Y166.679 E.00835
G1 X184.84 Y166.476 E.00871
G1 X184.927 Y166.235 E.00787
G1 X184.934 Y166.167 E.00211
G1 X184.896 Y165.829 E.01045
G1 X184.718 Y165.58 E.00941
G1 X184.493 Y165.444 E.00808
G1 X184.187 Y165.402 E.00948
G1 X183.87 Y165.527 E.01047
G1 X183.697 Y165.7 E.00751
M204 S10000
G1 X183.328 Y165.546 F60000
G1 F2845
M204 S8000
G2 X183.175 Y166.156 I.929 J.556 E.01961
G1 X183.292 Y166.59 E.01381
G1 X183.456 Y166.835 E.00907
G1 X183.788 Y167.078 E.01263
G1 X184.147 Y167.159 E.0113
G1 X184.463 Y167.143 E.00974
G1 X184.804 Y167.029 E.01104
G1 X185.109 Y166.758 E.01255
G1 X185.292 Y166.383 E.01279
G2 X185.177 Y165.542 I-1.583 J-.212 E.02642
G1 X184.9 Y165.235 E.01271
G1 X184.53 Y165.055 E.01264
G1 X184.124 Y165.028 E.01249
G1 X183.795 Y165.125 E.01055
G1 X183.53 Y165.3 E.00975
G1 X183.366 Y165.499 E.00794
M204 S10000
G1 X183.001 Y165.349 F60000
G1 F2845
M204 S8000
G1 X182.836 Y165.748 E.01327
G1 X182.794 Y166.176 E.01319
G1 X182.883 Y166.61 E.01363
G1 X183.1 Y166.99 E.01344
G1 X183.367 Y167.264 E.01175
G1 X183.742 Y167.462 E.01302
G2 X184.326 Y167.556 I.765 J-2.894 E.0182
G1 X184.763 Y167.466 E.0137
G1 X185.142 Y167.247 E.01346
G1 X185.412 Y166.985 E.01156
G1 X185.608 Y166.618 E.01279
G2 X185.706 Y166.024 I-2.808 J-.768 E.01852
G1 X185.616 Y165.587 E.01369
G1 X185.416 Y165.231 E.01255
G1 X185.128 Y164.933 E.01276
G1 X184.757 Y164.738 E.01286
G1 X184.327 Y164.641 E.01356
G2 X183.634 Y164.779 I.089 J2.257 E.0218
G1 X183.275 Y165.017 E.01322
G1 X183.039 Y165.303 E.0114
M204 S10000
G1 X182.674 Y165.153 F60000
G1 F2845
M204 S8000
G1 X182.466 Y165.656 E.01673
G1 X182.414 Y166.196 E.01665
G1 X182.523 Y166.732 E.01682
G1 X182.784 Y167.197 E.01636
G1 X183.141 Y167.568 E.01583
G1 X183.615 Y167.817 E.01646
G2 X184.346 Y167.936 I.848 J-2.89 E.0228
G1 X184.883 Y167.827 E.01685
G1 X185.356 Y167.557 E.01672
G1 X185.715 Y167.213 E.01529
G1 X185.962 Y166.747 E.01621
G2 X186.06 Y166.276 I-.865 J-.425 E.01492
G1 X186.086 Y166.004 E.0084
G1 X185.977 Y165.467 E.01685
G1 X185.72 Y165.008 E.01617
G1 X185.356 Y164.63 E.0161
G1 X184.9 Y164.388 E.01588
G1 X184.504 Y164.287 E.01254
G1 X183.999 Y164.278 E.01552
G1 X183.472 Y164.434 E.01687
G1 X183.02 Y164.734 E.01668
G1 X182.712 Y165.107 E.01487
; COOLING_NODE: 2
; WIPE_START
G1 F9547.299
G1 X183.02 Y164.734 E-.18386
G1 X183.472 Y164.434 E-.20627
G1 X183.999 Y164.278 E-.20859
G1 X184.423 Y164.286 E-.16128
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X179.498 Y165.248 Z3 F60000
G1 Z2.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2845
M204 S8000
G1 X178.702 Y165.248 E.0264
G1 X178.702 Y164.452 E.0264
G1 X179.498 Y164.452 E.0264
G1 X179.498 Y165.188 E.02441
; COOLING_NODE: 2
M204 S250
G1 X179.89 Y165.64 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2845
M204 S5000
G1 X178.31 Y165.64 E.04855
G1 X178.31 Y164.06 E.04855
G1 X179.89 Y164.06 E.04855
G1 X179.89 Y165.58 E.04671
; COOLING_NODE: 2
; WIPE_START
G1 F9547.055
M204 S8000
G1 X178.31 Y165.64 E-.60084
G1 X178.31 Y165.221 E-.15917
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X170.678 Y165.247 Z3 F60000
G1 X170.502 Y165.248 Z3
G1 Z2.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2845
M204 S8000
G1 X170.502 Y164.452 E.0264
G1 X171.298 Y164.452 E.0264
G1 X171.298 Y165.248 E.0264
G1 X170.562 Y165.248 E.02441
; COOLING_NODE: 2
M204 S250
G1 X170.11 Y165.64 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2845
M204 S5000
G1 X170.11 Y164.06 E.04855
G1 X171.69 Y164.06 E.04855
G1 X171.69 Y165.64 E.04855
G1 X170.17 Y165.64 E.04671
; COOLING_NODE: 4
; WIPE_START
G1 F9547.055
M204 S8000
G1 X170.11 Y164.06 E-.60084
G1 X170.529 Y164.06 E-.15917
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X167.824 Y165.296 Z3 F60000
G1 Z2.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2845
M204 S8000
G1 X167.917 Y165.562 E.00935
G3 X165.984 Y168.321 I-2.168 J.538 E.1266
G3 X165.865 Y163.87 I-.233 J-2.221 E.24426
G3 X167.776 Y165.162 I-.116 J2.23 E.08042
G1 X167.804 Y165.24 E.00275
; COOLING_NODE: 4
M204 S10000
G1 X168.207 Y165.162 F60000
G1 F2845
M204 S8000
G1 X168.312 Y165.463 E.01056
G3 X166.026 Y168.726 I-2.563 J.637 E.14972
G3 X165.887 Y163.463 I-.275 J-2.626 E.28883
G3 X168.144 Y164.988 I-.138 J2.637 E.09495
G1 X168.186 Y165.106 E.00416
; COOLING_NODE: 4
M204 S10000
G1 X168.608 Y165.043 F60000
G1 F2845
M204 S8000
G1 X168.615 Y165.057 E.00054
G3 X165.77 Y163.052 I-2.863 J1.042 E.51223
G1 X165.908 Y163.056 E.00458
G3 X168.514 Y164.813 I-.157 J3.043 E.10954
G1 X168.585 Y164.987 E.00623
; COOLING_NODE: 4
M204 S250
G1 X168.97 Y164.893 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2845
M204 S5000
G1 X168.984 Y164.923 E.00102
G3 X165.773 Y162.66 I-3.232 J1.176 E.53554
G1 X165.93 Y162.665 E.0048
G3 X168.87 Y164.646 I-.177 J3.435 E.11445
G1 X168.947 Y164.838 E.00636
; WIPE_START
G1 F9547.055
M204 S8000
G1 X168.984 Y164.923 E-.0354
G1 X169.088 Y165.268 E-.13673
G1 X169.148 Y165.562 E-.11408
G1 X169.185 Y165.92 E-.13698
G1 X169.185 Y166.28 E-.13645
G1 X169.148 Y166.638 E-.13714
G1 X169.114 Y166.801 E-.06321
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X165.957 Y165.938 Z3 F60000
G1 Z2.6
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.54073
G1 F2845
M204 S8000
G1 X165.803 Y165.844 E.00734
G1 X165.617 Y165.891 E.00779
G1 X165.519 Y166.006 E.00615
G1 X165.515 Y166.196 E.00769
G1 X165.605 Y166.317 E.00613
G1 X165.801 Y166.345 E.00802
G1 X165.955 Y166.266 E.00704
G2 X165.97 Y165.997 I-.231 J-.148 E.01144
M204 S10000
G1 X166.396 Y165.829 F60000
; LINE_WIDTH: 0.41999
G1 F2845
M204 S8000
G1 X166.222 Y165.584 E.00923
G1 X165.938 Y165.422 E.01004
G1 X165.687 Y165.402 E.00774
G1 X165.364 Y165.533 E.0107
G1 X165.156 Y165.738 E.00898
G1 X165.066 Y166.034 E.00949
G1 X165.104 Y166.371 E.01044
G1 X165.275 Y166.614 E.00911
G1 X165.551 Y166.771 E.00978
G1 X165.888 Y166.773 E.01036
G1 X166.142 Y166.679 E.00833
G1 X166.34 Y166.476 E.00871
G1 X166.427 Y166.235 E.00787
G2 X166.403 Y165.889 I-.829 J-.115 E.01075
M204 S10000
G1 X166.677 Y165.542 F60000
G1 F2845
M204 S8000
G1 X166.403 Y165.238 E.01256
G1 X166.033 Y165.056 E.01265
G1 X165.624 Y165.028 E.0126
G1 X165.298 Y165.124 E.01046
G1 X165.017 Y165.313 E.01041
G1 X164.829 Y165.543 E.00913
G2 X164.675 Y166.156 I.933 J.559 E.01969
G1 X164.788 Y166.584 E.01362
G1 X164.947 Y166.825 E.00884
G1 X165.289 Y167.078 E.01308
G1 X165.647 Y167.159 E.01129
G1 X165.964 Y167.143 E.00975
G1 X166.304 Y167.029 E.01102
G1 X166.61 Y166.758 E.01255
G1 X166.792 Y166.383 E.01279
G2 X166.696 Y165.598 I-1.401 J-.227 E.02462
M204 S10000
G1 X166.916 Y165.231 F60000
G1 F2845
M204 S8000
G1 X166.63 Y164.935 E.01267
G1 X166.251 Y164.734 E.01318
G1 X165.827 Y164.641 E.01335
G2 X165.135 Y164.779 I.089 J2.251 E.02174
G1 X164.76 Y165.031 E.0139
G1 X164.501 Y165.348 E.01256
G1 X164.336 Y165.749 E.01332
G1 X164.294 Y166.176 E.01319
G1 X164.384 Y166.613 E.0137
G1 X164.587 Y166.973 E.01272
G1 X164.865 Y167.262 E.01231
G1 X165.243 Y167.462 E.01313
G2 X165.826 Y167.556 I.764 J-2.895 E.01818
G1 X166.263 Y167.466 E.0137
G1 X166.642 Y167.247 E.01345
G1 X166.912 Y166.985 E.01158
G1 X167.108 Y166.618 E.01279
G2 X167.206 Y166.024 I-2.809 J-.768 E.01852
G1 X167.116 Y165.588 E.01369
G1 X166.946 Y165.284 E.01071
M204 S10000
G1 X167.22 Y165.008 F60000
G1 F2845
M204 S8000
G1 X166.858 Y164.632 E.01605
G1 X166.381 Y164.38 E.01655
G1 X165.848 Y164.263 E.01677
G1 X165.499 Y164.278 E.01073
G1 X164.973 Y164.433 E.01685
G1 X164.503 Y164.749 E.0174
G1 X164.174 Y165.153 E.01599
G1 X163.966 Y165.656 E.01675
G1 X163.914 Y166.196 E.01665
G1 X164.023 Y166.733 E.01686
G1 X164.284 Y167.197 E.01635
G1 X164.637 Y167.565 E.01566
G1 X165.116 Y167.817 E.01662
G2 X165.846 Y167.936 I.847 J-2.888 E.02279
G1 X166.383 Y167.826 E.01686
G1 X166.856 Y167.558 E.01671
G1 X167.215 Y167.213 E.01529
G1 X167.462 Y166.747 E.01621
G2 X167.56 Y166.276 I-.866 J-.425 E.01492
G1 X167.586 Y166.004 E.0084
G1 X167.477 Y165.467 E.01685
G1 X167.249 Y165.06 E.01432
; CHANGE_LAYER
; Z_HEIGHT: 2.64
; LAYER_HEIGHT: 0.0400002
; WIPE_START
G1 F9547.299
G1 X167.477 Y165.467 E-.17712
G1 X167.586 Y166.004 E-.20841
G1 X167.56 Y166.276 E-.10384
G1 X167.533 Y166.551 E-.10507
G1 X167.462 Y166.747 E-.07896
G1 X167.355 Y166.948 E-.0866
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 14/85
; update layer progress
M73 L14
M991 S0 P13 ;notify layer change

; OBJECT_ID: 15
M204 S10000
G17
G3 Z3 I.504 J1.108 P1  F60000
G1 X172.269 Y164.711 Z3
G1 Z2.64
G1 E.8 F1800
; FEATURE: Support interface
; LINE_WIDTH: 0.42
; LAYER_HEIGHT: 0.24
G1 F2999
M204 S8000
G1 X173.22 Y165.662 E.04845
G1 X174.46 Y165.662 E.04469
G1 X172.837 Y164.038 E.08272
G1 X174.077 Y164.038 E.04469
G1 X175.7 Y165.662 E.08272
G1 X176.941 Y165.662 E.04469
G1 X175.317 Y164.038 E.08272
G1 X176.558 Y164.038 E.04469
G1 X177.731 Y165.212 E.05981
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

; CHANGE_LAYER
; Z_HEIGHT: 2.8
; LAYER_HEIGHT: 0.16
; WIPE_START
G1 F4800
G1 X176.558 Y164.038 E-.63072
G1 X176.217 Y164.038 E-.12929
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 15/85
; update layer progress
M73 L15
M991 S0 P14 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 5
M204 S10000
G17
G3 Z3.04 I.832 J.888 P1  F60000
G1 X187.298 Y153.648 Z3.04
G1 Z2.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
; LAYER_HEIGHT: 0.2
G1 F2999
M204 S8000
G1 X162.702 Y153.648 E.81589
G1 X162.702 Y152.852 E.0264
G1 X187.298 Y152.852 E.81589
G1 X187.298 Y153.588 E.02441
; COOLING_NODE: 5
M204 S250
G1 X187.69 Y154.04 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2888
M204 S5000
G1 X162.31 Y154.04 E.77986
G1 X162.31 Y152.46 E.04855
G1 X187.69 Y152.46 E.77986
G1 X187.69 Y153.98 E.04671
M204 S10000
M73 P52 R7
G1 X187.094 Y153.25 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F2999
M204 S8000
G1 X162.906 Y153.25 E.76636
; COOLING_NODE: 1
; WIPE_START
G1 F9259.259
G1 X164.906 Y153.25 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.155 Y157.632 Z3.2 F60000
G1 X182.158 Y165.347 Z3.2
G1 Z2.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2999
M204 S8000
G1 X182.204 Y165.208 E.00485
G3 X184.272 Y163.867 I2.047 J.892 E.0866
G1 X184.364 Y163.87 E.00306
G3 X182.065 Y165.642 I-.113 J2.23 E.3606
G1 X182.14 Y165.404 E.00828
; COOLING_NODE: 1
M204 S10000
G1 X181.748 Y165.26 F60000
G1 F2999
M204 S8000
G1 X181.831 Y165.046 E.00764
G3 X184.276 Y163.46 I2.421 J1.054 E.10239
G1 X184.386 Y163.463 E.00367
G3 X181.73 Y165.318 I-.135 J2.637 E.43457
; COOLING_NODE: 1
M204 S10000
G1 X181.367 Y165.116 F60000
G1 F2999
M204 S8000
G1 X181.458 Y164.883 E.00829
G3 X184.279 Y163.052 I2.794 J1.216 E.11818
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X184.408 Y163.056 E.00427
G3 X181.349 Y165.173 I-.156 J3.043 E.50239
; COOLING_NODE: 1
M204 S250
G1 X181.001 Y164.977 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2888
M204 S5000
G1 X181.099 Y164.727 E.00825
G3 X184.283 Y162.66 I3.154 J1.373 E.12355
G1 X184.429 Y162.665 E.0045
G3 X180.981 Y165.038 I-.177 J3.435 E.52573
G1 X180.983 Y165.034 E.00014
; WIPE_START
G1 F9547.055
M204 S8000
G1 X181.099 Y164.727 E-.12483
G1 X181.241 Y164.433 E-.12421
G1 X181.432 Y164.127 E-.13705
G1 X181.614 Y163.889 E-.11369
G1 X181.86 Y163.626 E-.13703
G1 X182.105 Y163.413 E-.1232
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X184.08 Y165.9 Z3.2 F60000
G1 Z2.8
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.541752
G1 F2999
M204 S8000
G1 X183.992 Y166.059 E.00741
G1 X184.021 Y166.228 E.00698
G1 X184.151 Y166.329 E.00668
G1 X184.356 Y166.338 E.00836
G1 X184.479 Y166.199 E.00753
G1 X184.512 Y166.087 E.00476
G1 X184.444 Y165.938 E.00666
G1 X184.25 Y165.838 E.00887
G1 X184.137 Y165.879 E.00489
M204 S10000
G1 X183.65 Y165.741 F60000
; LINE_WIDTH: 0.41999
G1 F2999
M204 S8000
G1 X183.559 Y165.987 E.00804
G1 X183.567 Y166.25 E.00808
G1 X183.689 Y166.517 E.00902
G1 X183.901 Y166.707 E.00876
G1 X184.233 Y166.787 E.01051
G1 X184.471 Y166.767 E.00735
G1 X184.683 Y166.651 E.00742
G1 X184.88 Y166.373 E.01045
G1 X184.95 Y166.105 E.00852
G1 X184.873 Y165.782 E.01019
G1 X184.697 Y165.578 E.0083
G1 X184.401 Y165.417 E.01034
G1 X184.097 Y165.417 E.00937
G1 X183.845 Y165.53 E.00847
G1 X183.691 Y165.697 E.00699
M204 S10000
G1 X183.394 Y165.44 F60000
G1 F2999
M204 S8000
G1 X183.205 Y165.82 E.01303
G1 X183.176 Y166.23 E.01264
G1 X183.308 Y166.631 E.01297
G1 X183.584 Y166.953 E.01302
G1 X183.912 Y167.109 E.01118
G1 X184.224 Y167.164 E.00971
G1 X184.591 Y167.126 E.01136
G1 X184.94 Y166.931 E.01227
G1 X185.163 Y166.67 E.01054
G1 X185.316 Y166.255 E.0136
G2 X185.276 Y165.759 I-1.145 J-.158 E.01542
G1 X185.081 Y165.41 E.01227
G1 X184.82 Y165.187 E.01054
G1 X184.395 Y165.034 E.0139
G1 X184.1 Y165.029 E.00904
G1 X183.71 Y165.162 E.01268
G1 X183.439 Y165.4 E.01109
M204 S10000
G1 X183.093 Y165.209 F60000
G1 F2999
M204 S8000
G1 X182.887 Y165.595 E.01344
G1 X182.793 Y165.998 E.01272
G1 X182.83 Y166.412 E.01278
G1 X182.978 Y166.818 E.01325
G1 X183.267 Y167.171 E.01402
G1 X183.573 Y167.393 E.01161
G1 X183.997 Y167.535 E.01376
G1 X184.439 Y167.547 E.01358
G1 X184.874 Y167.412 E.014
G1 X185.196 Y167.211 E.01166
G1 X185.486 Y166.872 E.0137
G1 X185.663 Y166.464 E.01368
G1 X185.703 Y166.055 E.0126
G1 X185.635 Y165.639 E.01297
G1 X185.445 Y165.271 E.01273
G2 X185.022 Y164.864 I-2.382 J2.049 E.01805
G1 X184.614 Y164.687 E.01368
G1 X184.178 Y164.648 E.01345
G1 X183.774 Y164.719 E.0126
G1 X183.407 Y164.916 E.0128
G1 X183.137 Y165.168 E.01137
M204 S10000
G1 X182.792 Y164.978 F60000
G1 F2999
M204 S8000
G1 X182.533 Y165.463 E.01689
G1 X182.415 Y165.972 E.01604
G1 X182.462 Y166.492 E.01607
G1 X182.648 Y167.004 E.01673
G1 X182.986 Y167.424 E.01656
G1 X183.409 Y167.735 E.01615
G1 X183.931 Y167.911 E.01692
G1 X184.476 Y167.925 E.01676
G1 X184.98 Y167.778 E.01612
G2 X185.577 Y167.345 I-.607 J-1.466 E.02287
G1 X185.809 Y167.074 E.01096
G1 X186.028 Y166.571 E.01685
G1 X186.08 Y166.046 E.01624
G1 X185.995 Y165.518 E.0164
G1 X185.752 Y165.052 E.01617
G2 X185.224 Y164.541 I-2.361 J1.907 E.02262
G1 X184.72 Y164.322 E.0169
G1 X184.18 Y164.27 E.01667
G1 X183.651 Y164.361 E.01649
G1 X183.19 Y164.607 E.01604
G1 X182.836 Y164.937 E.01489
; COOLING_NODE: 2
; WIPE_START
G1 F9547.299
G1 X183.19 Y164.607 E-.18409
G1 X183.651 Y164.361 E-.19843
G1 X184.18 Y164.27 E-.20397
G1 X184.635 Y164.314 E-.17352
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X179.498 Y165.248 Z3.2 F60000
G1 Z2.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2999
M204 S8000
G1 X178.702 Y165.248 E.0264
G1 X178.702 Y164.452 E.0264
G1 X179.498 Y164.452 E.0264
G1 X179.498 Y165.188 E.02441
; COOLING_NODE: 2
M204 S250
G1 X179.89 Y165.64 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2915
M204 S5000
G1 X178.31 Y165.64 E.04855
G1 X178.31 Y164.06 E.04855
G1 X179.89 Y164.06 E.04855
G1 X179.89 Y165.58 E.04671
; COOLING_NODE: 2
; WIPE_START
G1 F9547.055
M204 S8000
G1 X178.31 Y165.64 E-.60084
G1 X178.31 Y165.221 E-.15917
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X170.678 Y165.247 Z3.2 F60000
G1 X170.502 Y165.248 Z3.2
G1 Z2.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2999
M204 S8000
G1 X170.502 Y164.452 E.0264
G1 X171.298 Y164.452 E.0264
G1 X171.298 Y165.248 E.0264
G1 X170.562 Y165.248 E.02441
; COOLING_NODE: 2
M204 S250
G1 X170.11 Y165.64 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2915
M204 S5000
G1 X170.11 Y164.06 E.04855
G1 X171.69 Y164.06 E.04855
G1 X171.69 Y165.64 E.04855
G1 X170.17 Y165.64 E.04671
; COOLING_NODE: 4
; WIPE_START
G1 F9547.055
M204 S8000
G1 X170.11 Y164.06 E-.60084
G1 X170.529 Y164.06 E-.15917
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X167.836 Y165.302 Z3.2 F60000
G1 Z2.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2999
M204 S8000
G3 X165.772 Y163.867 I-2.085 J.797 E.37658
G1 X165.864 Y163.87 E.00306
G3 X167.814 Y165.246 I-.113 J2.229 E.08354
; COOLING_NODE: 4
M204 S10000
G1 X168.216 Y165.155 F60000
G1 F2999
M204 S8000
G3 X165.776 Y163.46 I-2.464 J.943 E.44526
G1 X165.886 Y163.463 E.00367
G3 X168.194 Y165.099 I-.134 J2.635 E.09905
; COOLING_NODE: 4
M204 S10000
G1 X168.598 Y165.016 F60000
G1 F2999
M204 S8000
G1 X168.68 Y165.259 E.00849
G3 X165.779 Y163.052 I-2.928 J.839 E.50519
G1 X165.908 Y163.056 E.00427
G3 X168.577 Y164.96 I-.156 J3.042 E.11484
; COOLING_NODE: 4
M204 S250
G1 X168.97 Y164.892 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2888
M204 S5000
G1 X169.057 Y165.151 E.00841
G3 X165.783 Y162.66 I-3.305 J.946 E.52814
G1 X165.929 Y162.665 E.0045
G3 X168.95 Y164.835 I-.176 J3.433 E.12077
; WIPE_START
G1 F9547.055
M204 S8000
G1 X169.057 Y165.151 E-.12681
G1 X169.138 Y165.503 E-.13698
G1 X169.179 Y165.833 E-.12655
G1 X169.189 Y166.161 E-.12447
G1 X169.164 Y166.519 E-.13671
G1 X169.117 Y166.801 E-.10847
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X165.956 Y165.948 Z3.2 F60000
G1 Z2.8
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.541405
G1 F2999
M204 S8000
G1 X165.758 Y165.837 E.0092
G1 X165.578 Y165.902 E.00781
G1 X165.502 Y166.057 E.007
G1 X165.528 Y166.238 E.00743
G1 X165.735 Y166.363 E.00982
G1 X165.885 Y166.324 E.00628
G1 X166.013 Y166.116 E.00993
G2 X165.978 Y166.004 I-.167 J-.01 E.00485
M204 S10000
G1 X166.368 Y165.764 F60000
; LINE_WIDTH: 0.41999
G1 F2999
M204 S8000
G1 X166.118 Y165.51 E.01094
G1 X165.783 Y165.398 E.01085
G1 X165.469 Y165.461 E.00983
G1 X165.249 Y165.612 E.0082
G1 X165.128 Y165.793 E.00669
G1 X165.063 Y166.083 E.00913
G1 X165.099 Y166.359 E.00855
G1 X165.25 Y166.576 E.00812
G1 X165.524 Y166.751 E.01
G1 X165.774 Y166.799 E.00781
G1 X166.065 Y166.725 E.00924
G1 X166.272 Y166.547 E.00839
G1 X166.435 Y166.248 E.01045
G1 X166.449 Y166.076 E.0053
G1 X166.383 Y165.822 E.00807
M204 S10000
G1 X166.581 Y165.41 F60000
G1 F2999
M204 S8000
G1 X166.32 Y165.187 E.01055
G1 X165.895 Y165.034 E.0139
G1 X165.6 Y165.029 E.00904
G1 X165.188 Y165.176 E.01344
G1 X164.89 Y165.444 E.01234
G1 X164.741 Y165.762 E.01077
G1 X164.686 Y166.073 E.00972
G1 X164.721 Y166.434 E.01115
G1 X164.919 Y166.79 E.0125
G1 X165.18 Y167.013 E.01053
G1 X165.595 Y167.166 E.01361
G1 X165.878 Y167.174 E.0087
G1 X166.293 Y167.035 E.01344
G1 X166.559 Y166.792 E.01106
G1 X166.726 Y166.523 E.00973
G1 X166.829 Y166.175 E.01115
G2 X166.775 Y165.753 I-1.549 J-.015 E.01312
G1 X166.61 Y165.463 E.01025
M204 S10000
G1 X166.956 Y165.289 F60000
G1 F2999
M204 S8000
G2 X166.522 Y164.864 I-2.249 J1.861 E.01868
G1 X166.114 Y164.687 E.01368
G1 X165.678 Y164.648 E.01345
G1 X165.277 Y164.718 E.01249
G1 X164.895 Y164.922 E.01332
G1 X164.59 Y165.212 E.01292
G2 X164.315 Y165.847 I1.907 J1.205 E.02135
G1 X164.303 Y166.291 E.01363
G1 X164.423 Y166.693 E.01291
G1 X164.638 Y167.045 E.01267
G1 X164.978 Y167.336 E.01375
G1 X165.386 Y167.513 E.01368
G1 X165.793 Y167.553 E.01256
G1 X166.211 Y167.486 E.01302
G1 X166.578 Y167.295 E.01268
G2 X166.986 Y166.872 I-2.023 J-2.361 E.01809
G1 X167.163 Y166.464 E.01369
G1 X167.203 Y166.057 E.01255
G1 X167.135 Y165.635 E.01315
G1 X166.983 Y165.342 E.01013
M204 S10000
G1 X167.265 Y165.073 F60000
G1 F2999
M204 S8000
G1 X167.144 Y164.9 E.00647
G1 X166.724 Y164.541 E.01697
G1 X166.22 Y164.322 E.0169
G1 X165.68 Y164.27 E.01667
G1 X165.153 Y164.36 E.01644
G1 X164.674 Y164.617 E.01669
G1 X164.291 Y164.98 E.01621
G1 X164.115 Y165.259 E.01013
G1 X163.939 Y165.781 E.01692
G1 X163.925 Y166.327 E.01679
G1 X164.062 Y166.81 E.01542
G2 X164.356 Y167.3 I2.358 J-1.081 E.01762
G1 X164.775 Y167.659 E.01696
G1 X165.278 Y167.877 E.01684
G1 X165.803 Y167.93 E.01619
G1 X166.331 Y167.845 E.01646
G1 X166.797 Y167.602 E.01612
G2 X167.309 Y167.074 I-1.903 J-2.361 E.02267
G1 X167.528 Y166.571 E.01685
G1 X167.58 Y166.047 E.01618
G1 X167.494 Y165.516 E.01653
G1 X167.292 Y165.126 E.01352
; CHANGE_LAYER
; Z_HEIGHT: 2.88
; LAYER_HEIGHT: 0.0800002
; WIPE_START
G1 F9547.299
G1 X167.494 Y165.516 E-.16716
G1 X167.58 Y166.047 E-.20443
G1 X167.528 Y166.571 E-.20005
G1 X167.33 Y167.026 E-.18836
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 16/85
; update layer progress
M73 L16
M991 S0 P15 ;notify layer change

; OBJECT_ID: 15
M204 S10000
G17
G3 Z3.2 I.547 J1.087 P1  F60000
G1 X173.612 Y163.869 Z3.2
G1 Z2.88
G1 E.8 F1800
; FEATURE: Support interface
; LINE_WIDTH: 0.42
; LAYER_HEIGHT: 0.24
G1 F2999
M204 S8000
G1 X172.438 Y165.042 E.05981
G1 X172.438 Y165.662 E.02232
G1 X173.059 Y165.662 E.02238
G1 X174.683 Y164.038 E.08272
G1 X175.923 Y164.038 E.04469
G1 X174.3 Y165.662 E.08272
G1 X175.54 Y165.662 E.04469
G1 X177.163 Y164.038 E.08272
G1 X177.562 Y164.038 E.01434
G1 X177.562 Y164.881 E.03035
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X176.611 Y165.831 E.04845
; CHANGE_LAYER
; Z_HEIGHT: 3
; LAYER_HEIGHT: 0.12
; WIPE_START
G1 F4800
G1 X177.562 Y164.881 E-.51093
G1 X177.562 Y164.225 E-.24907
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 17/85
; update layer progress
M73 L17
M991 S0 P16 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 5
M204 S10000
G17
G3 Z3.28 I.895 J.824 P1  F60000
G1 X187.298 Y153.648 Z3.28
G1 Z3
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
; LAYER_HEIGHT: 0.2
G1 F2999
M204 S8000
G1 X162.702 Y153.648 E.81589
G1 X162.702 Y152.852 E.0264
G1 X187.298 Y152.852 E.81589
G1 X187.298 Y153.588 E.02441
; COOLING_NODE: 5
M204 S250
G1 X187.69 Y154.04 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2887
M204 S5000
G1 X162.31 Y154.04 E.77986
G1 X162.31 Y152.46 E.04855
G1 X187.69 Y152.46 E.77986
G1 X187.69 Y153.98 E.04671
M204 S10000
M73 P53 R7
G1 X187.094 Y153.25 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F2999
M204 S8000
G1 X162.906 Y153.25 E.76636
; COOLING_NODE: 1
; WIPE_START
G1 F9259.259
G1 X164.906 Y153.25 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.155 Y157.632 Z3.4 F60000
G1 X182.159 Y165.347 Z3.4
G1 Z3
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2999
M204 S8000
G1 X182.208 Y165.2 E.00514
G3 X184.28 Y163.867 I2.044 J.9 E.08659
G1 X184.363 Y163.869 E.00276
G3 X182.067 Y165.636 I-.112 J2.23 E.36083
G1 X182.141 Y165.404 E.00808
; COOLING_NODE: 1
M204 S10000
G1 X181.748 Y165.259 F60000
G1 F2999
M204 S8000
G1 X181.835 Y165.037 E.00788
G3 X184.284 Y163.46 I2.417 J1.062 E.10237
G1 X184.385 Y163.463 E.00336
G3 X181.731 Y165.316 I-.134 J2.637 E.43466
; COOLING_NODE: 1
M204 S10000
G1 X181.368 Y165.114 F60000
G1 F2999
M204 S8000
G1 X181.462 Y164.875 E.00852
G3 X184.288 Y163.053 I2.79 J1.225 E.11816
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X184.408 Y163.056 E.00396
G3 X181.35 Y165.171 I-.155 J3.043 E.50249
; COOLING_NODE: 1
M204 S250
G1 X181.002 Y164.974 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2887
M204 S5000
G1 X181.103 Y164.718 E.00846
G3 X184.293 Y162.66 I3.15 J1.382 E.12354
G1 X184.429 Y162.665 E.0042
G3 X180.981 Y165.038 I-.177 J3.435 E.52574
G1 X180.984 Y165.031 E.00022
; WIPE_START
G1 F9547.055
M204 S8000
G1 X181.103 Y164.718 E-.12739
G1 X181.241 Y164.433 E-.12044
G1 X181.432 Y164.127 E-.13686
G1 X181.643 Y163.856 E-.13038
G1 X181.86 Y163.625 E-.12062
G1 X182.107 Y163.41 E-.12432
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X184.114 Y165.876 Z3.4 F60000
G1 Z3
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.54143
G1 F2999
M204 S8000
G1 X183.988 Y166.083 E.00985
G1 X184.026 Y166.236 E.00642
G1 X184.234 Y166.362 E.00988
G1 X184.386 Y166.324 E.00639
G1 X184.512 Y166.116 E.00987
G2 X184.474 Y165.964 I-.294 J-.008 E.00646
G1 X184.258 Y165.837 E.01018
G1 X184.172 Y165.86 E.00364
M204 S10000
G1 X183.62 Y165.827 F60000
; LINE_WIDTH: 0.41999
G1 F2999
M204 S8000
G1 X183.55 Y166.094 E.00849
G1 X183.608 Y166.375 E.00881
G1 X183.737 Y166.566 E.00708
G1 X184.011 Y166.745 E.01006
G1 X184.245 Y166.8 E.0074
G1 X184.525 Y166.742 E.00877
G1 X184.715 Y166.613 E.00707
G1 X184.895 Y166.339 E.01006
G1 X184.949 Y166.074 E.00832
G1 X184.873 Y165.784 E.00922
G1 X184.697 Y165.578 E.00832
G1 X184.4 Y165.416 E.0104
G1 X184.087 Y165.419 E.00961
G1 X183.817 Y165.549 E.0092
G1 X183.654 Y165.778 E.00864
M204 S10000
G1 X183.442 Y165.408 F60000
G1 F2999
M204 S8000
G1 X183.274 Y165.677 E.00974
G1 X183.171 Y166.024 E.01111
G1 X183.222 Y166.435 E.01275
G1 X183.419 Y166.789 E.01244
G1 X183.68 Y167.013 E.01056
G1 X184.095 Y167.166 E.01359
G1 X184.381 Y167.174 E.0088
G1 X184.797 Y167.033 E.01348
G1 X185.058 Y166.792 E.01092
G1 X185.227 Y166.523 E.00976
G1 X185.329 Y166.176 E.01113
G2 X185.081 Y165.41 I-1.23 J-.024 E.0252
G1 X184.821 Y165.188 E.01051
G1 X184.394 Y165.034 E.01395
G1 X184.1 Y165.029 E.00902
G1 X183.709 Y165.163 E.01272
G1 X183.486 Y165.367 E.00928
M204 S10000
G1 X183.014 Y165.328 F60000
G1 F2999
M204 S8000
G1 X182.837 Y165.737 E.01369
G1 X182.797 Y166.145 E.0126
G1 X182.862 Y166.555 E.01276
G1 X183.056 Y166.93 E.01297
G2 X183.478 Y167.336 I2.398 J-2.069 E.01802
G1 X183.886 Y167.513 E.01367
G1 X184.296 Y167.553 E.01266
G1 X184.705 Y167.488 E.01272
G1 X185.08 Y167.294 E.01298
G2 X185.486 Y166.873 I-2.07 J-2.398 E.01799
G1 X185.663 Y166.464 E.0137
G1 X185.703 Y166.054 E.01264
G1 X185.638 Y165.645 E.01274
G1 X185.445 Y165.271 E.01291
G2 X185.023 Y164.864 I-2.361 J2.025 E.01805
G1 X184.612 Y164.686 E.01375
G1 X184.177 Y164.648 E.01341
G1 X183.775 Y164.719 E.01256
G1 X183.425 Y164.903 E.01214
G2 X183.053 Y165.282 I1.803 J2.139 E.01634
M204 S10000
G1 X182.691 Y165.125 F60000
G1 F2999
M204 S8000
G1 X182.472 Y165.629 E.01685
G1 X182.42 Y166.154 E.01623
G1 X182.503 Y166.674 E.01618
G1 X182.749 Y167.149 E.01644
G2 X183.276 Y167.66 I2.359 J-1.908 E.02258
G1 X183.778 Y167.877 E.01683
G1 X184.306 Y167.93 E.01629
G1 X184.824 Y167.847 E.01613
G1 X185.3 Y167.601 E.01645
G2 X185.809 Y167.075 I-1.91 J-2.36 E.02255
G1 X186.028 Y166.571 E.01686
G1 X186.08 Y166.045 E.01627
G1 X185.997 Y165.526 E.01615
G1 X185.752 Y165.052 E.01638
G2 X185.225 Y164.541 I-2.358 J1.902 E.02263
G1 X184.718 Y164.321 E.01697
G1 X184.18 Y164.27 E.01661
G1 X183.651 Y164.361 E.01647
G1 X183.206 Y164.596 E.01547
G2 X182.73 Y165.08 I1.742 J2.19 E.02092
; COOLING_NODE: 2
; WIPE_START
G1 F9547.299
G1 X182.922 Y164.855 E-.1124
G1 X183.206 Y164.596 E-.14616
G1 X183.651 Y164.361 E-.19136
G1 X184.18 Y164.27 E-.20372
G1 X184.458 Y164.297 E-.10635
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X179.498 Y165.248 Z3.4 F60000
G1 Z3
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2999
M204 S8000
G1 X178.702 Y165.248 E.0264
G1 X178.702 Y164.452 E.0264
G1 X179.498 Y164.452 E.0264
G1 X179.498 Y165.188 E.02441
; COOLING_NODE: 2
M204 S250
G1 X179.89 Y165.64 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2924
M204 S5000
G1 X178.31 Y165.64 E.04855
G1 X178.31 Y164.06 E.04855
G1 X179.89 Y164.06 E.04855
G1 X179.89 Y165.58 E.04671
; COOLING_NODE: 2
; WIPE_START
G1 F9547.055
M204 S8000
G1 X178.31 Y165.64 E-.60084
G1 X178.31 Y165.221 E-.15917
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X170.678 Y165.247 Z3.4 F60000
G1 X170.502 Y165.248 Z3.4
G1 Z3
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2999
M204 S8000
G1 X170.502 Y164.452 E.0264
G1 X171.298 Y164.452 E.0264
G1 X171.298 Y165.248 E.0264
G1 X170.562 Y165.248 E.02441
; COOLING_NODE: 2
M204 S250
G1 X170.11 Y165.64 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2924
M204 S5000
G1 X170.11 Y164.06 E.04855
G1 X171.69 Y164.06 E.04855
G1 X171.69 Y165.64 E.04855
G1 X170.17 Y165.64 E.04671
; COOLING_NODE: 4
; WIPE_START
G1 F9547.055
M204 S8000
G1 X170.11 Y164.06 E-.60084
G1 X170.529 Y164.06 E-.15917
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X167.836 Y165.3 Z3.4 F60000
G1 Z3
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2999
M204 S8000
G3 X165.78 Y163.867 I-2.085 J.799 E.37712
G1 X165.863 Y163.869 E.00276
G3 X167.814 Y165.245 I-.112 J2.23 E.08355
; COOLING_NODE: 4
M204 S10000
G1 X168.217 Y165.154 F60000
G1 F2999
M204 S8000
G3 X165.784 Y163.46 I-2.465 J.946 E.44585
G1 X165.885 Y163.463 E.00336
G3 X168.195 Y165.098 I-.134 J2.637 E.09906
; COOLING_NODE: 4
M204 S10000
G1 X168.598 Y165.015 F60000
G1 F2999
M204 S8000
G1 X168.681 Y165.258 E.0085
G3 X165.788 Y163.053 I-2.929 J.842 E.50582
G1 X165.908 Y163.056 E.00396
G3 X168.578 Y164.959 I-.155 J3.043 E.11485
; COOLING_NODE: 4
M204 S250
G1 X168.969 Y164.891 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2887
M204 S5000
G1 X169.059 Y165.151 E.00843
G3 X165.793 Y162.66 I-3.306 J.949 E.52878
G1 X165.929 Y162.665 E.0042
G3 X168.951 Y164.834 I-.177 J3.435 E.12076
; WIPE_START
G1 F9547.055
M204 S8000
G1 X169.059 Y165.151 E-.12705
G1 X169.138 Y165.503 E-.13724
G1 X169.18 Y165.843 E-.13013
G1 X169.189 Y166.161 E-.12077
G1 X169.164 Y166.519 E-.13672
G1 X169.117 Y166.8 E-.1081
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X165.974 Y165.964 Z3.4 F60000
G1 Z3
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.54145
G1 F2999
M204 S8000
G1 X165.759 Y165.837 E.01012
G1 X165.574 Y165.923 E.0083
G1 X165.488 Y166.081 E.00731
G1 X165.526 Y166.236 E.0065
G1 X165.734 Y166.362 E.00988
G1 X165.886 Y166.324 E.00639
G1 X166.012 Y166.116 E.00989
G2 X165.992 Y166.021 I-.18 J-.01 E.004
M204 S10000
G1 X166.372 Y165.781 F60000
; LINE_WIDTH: 0.41999
G1 F2999
M204 S8000
G1 X166.197 Y165.578 E.00821
G1 X165.9 Y165.416 E.0104
G1 X165.637 Y165.417 E.00808
G1 X165.374 Y165.521 E.00869
G1 X165.161 Y165.732 E.00922
G1 X165.049 Y166.049 E.01034
G1 X165.081 Y166.314 E.0082
G1 X165.238 Y166.566 E.0091
G1 X165.511 Y166.745 E.01005
G1 X165.745 Y166.8 E.00739
G1 X166.025 Y166.742 E.00878
G1 X166.215 Y166.613 E.00707
G1 X166.395 Y166.339 E.01006
G1 X166.45 Y166.105 E.00741
G1 X166.387 Y165.839 E.0084
M204 S10000
G1 X166.581 Y165.41 F60000
G1 F2999
M204 S8000
G1 X166.321 Y165.188 E.01052
G1 X165.885 Y165.032 E.01422
G1 X165.625 Y165.027 E.00799
G1 X165.291 Y165.126 E.0107
G1 X165.048 Y165.283 E.00888
G1 X164.837 Y165.53 E.00997
G1 X164.684 Y165.944 E.01356
G1 X164.677 Y166.237 E.00902
G1 X164.817 Y166.646 E.01328
G1 X165.058 Y166.908 E.01094
G1 X165.327 Y167.076 E.00974
G1 X165.674 Y167.179 E.01115
G1 X166.085 Y167.128 E.01272
G1 X166.439 Y166.931 E.01244
G1 X166.663 Y166.67 E.01055
G1 X166.816 Y166.255 E.01361
G2 X166.61 Y165.463 I-1.04 J-.152 E.02583
M204 S10000
G1 X166.944 Y165.27 F60000
G1 F2999
M204 S8000
G2 X166.523 Y164.864 I-2.381 J2.052 E.01799
G1 X166.112 Y164.686 E.01375
G1 X165.706 Y164.646 E.01254
G2 X165.131 Y164.78 I.463 J3.298 E.01814
G1 X164.797 Y164.997 E.01224
G1 X164.514 Y165.328 E.01338
G1 X164.337 Y165.736 E.01369
G1 X164.297 Y166.151 E.01281
G1 X164.362 Y166.554 E.01253
G1 X164.556 Y166.93 E.013
G2 X164.977 Y167.336 I2.392 J-2.063 E.018
G1 X165.386 Y167.513 E.01369
G1 X165.796 Y167.553 E.01265
G1 X166.205 Y167.488 E.01272
G1 X166.58 Y167.294 E.01298
G2 X166.986 Y166.873 I-2.07 J-2.398 E.018
G1 X167.163 Y166.464 E.01369
G1 X167.203 Y166.055 E.01262
G1 X167.138 Y165.645 E.01275
G1 X166.971 Y165.323 E.01114
M204 S10000
G1 X167.251 Y165.05 F60000
G1 F2999
M204 S8000
G2 X166.725 Y164.541 I-2.356 J1.905 E.02256
G1 X166.218 Y164.321 E.01696
G1 X165.689 Y164.27 E.01633
G2 X164.972 Y164.434 I.34 J3.133 E.02265
G1 X164.546 Y164.71 E.0156
G1 X164.191 Y165.126 E.0168
G1 X163.972 Y165.629 E.01685
G1 X163.92 Y166.162 E.01646
G1 X164.002 Y166.674 E.01593
G1 X164.249 Y167.149 E.01646
G2 X164.775 Y167.659 I2.359 J-1.908 E.02256
G1 X165.279 Y167.878 E.01685
G1 X165.806 Y167.93 E.01629
G1 X166.324 Y167.847 E.01613
G1 X166.8 Y167.601 E.01645
G2 X167.309 Y167.075 I-1.908 J-2.358 E.02256
G1 X167.528 Y166.571 E.01686
G1 X167.58 Y166.045 E.01625
G1 X167.497 Y165.526 E.01616
G1 X167.278 Y165.104 E.01461
; CHANGE_LAYER
; Z_HEIGHT: 3.12
; LAYER_HEIGHT: 0.12
; WIPE_START
G1 F9547.299
G1 X167.497 Y165.526 E-.1807
G1 X167.58 Y166.045 E-.19991
G1 X167.528 Y166.571 E-.20098
G1 X167.341 Y167.002 E-.17841
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 18/85
; update layer progress
M73 L18
M991 S0 P17 ;notify layer change

; OBJECT_ID: 15
M204 S10000
G17
G3 Z3.4 I.513 J1.104 P1  F60000
G1 X172.269 Y164.711 Z3.4
G1 Z3.12
G1 E.8 F1800
; FEATURE: Support interface
; LINE_WIDTH: 0.42
; LAYER_HEIGHT: 0.24
G1 F2997
M204 S8000
G1 X173.22 Y165.662 E.04845
G1 X174.46 Y165.662 E.04469
G1 X172.837 Y164.038 E.08272
G1 X174.077 Y164.038 E.04469
G1 X175.7 Y165.662 E.08272
G1 X176.941 Y165.662 E.04469
G1 X175.317 Y164.038 E.08272
G1 X176.558 Y164.038 E.04469
G1 X177.731 Y165.212 E.05981
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

; CHANGE_LAYER
; Z_HEIGHT: 3.2
; LAYER_HEIGHT: 0.0800002
; WIPE_START
G1 F4800
G1 X176.558 Y164.038 E-.63072
G1 X176.217 Y164.038 E-.12929
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 19/85
; update layer progress
M73 L19
M991 S0 P18 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 5
M204 S10000
G17
G3 Z3.52 I.832 J.888 P1  F60000
G1 X187.298 Y153.648 Z3.52
G1 Z3.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
; LAYER_HEIGHT: 0.2
G1 F2997
M204 S8000
G1 X162.702 Y153.648 E.81589
G1 X162.702 Y152.852 E.0264
G1 X187.298 Y152.852 E.81589
G1 X187.298 Y153.588 E.02441
; COOLING_NODE: 5
M204 S250
G1 X187.69 Y154.04 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2874
M204 S5000
G1 X162.31 Y154.04 E.77986
G1 X162.31 Y152.46 E.04855
G1 X187.69 Y152.46 E.77986
G1 X187.69 Y153.98 E.04671
M204 S10000
M73 P54 R7
G1 X187.094 Y153.25 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F2997
M204 S8000
G1 X162.906 Y153.25 E.76636
; COOLING_NODE: 1
; WIPE_START
G1 F9259.259
G1 X164.906 Y153.25 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.153 Y157.634 Z3.6 F60000
G1 X182.155 Y165.354 Z3.6
G1 Z3.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2997
M204 S8000
G1 X182.209 Y165.196 E.00552
G3 X184.288 Y163.867 I2.042 J.903 E.08675
G1 X184.362 Y163.869 E.00243
G3 X182.075 Y165.599 I-.111 J2.23 E.36215
G1 X182.136 Y165.411 E.00655
; COOLING_NODE: 1
M204 S10000
G1 X181.77 Y165.226 F60000
G1 F2997
M204 S8000
G1 X181.838 Y165.03 E.0069
G3 X184.293 Y163.46 I2.414 J1.07 E.10241
G1 X184.384 Y163.463 E.00303
G3 X181.679 Y165.507 I-.133 J2.637 E.42811
G1 X181.752 Y165.283 E.0078
; COOLING_NODE: 1
M204 S10000
G1 X181.37 Y165.108 F60000
G1 F2997
M204 S8000
G3 X184.298 Y163.053 I2.881 J.992 E.12681
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X184.407 Y163.056 E.00363
G3 X181.351 Y165.165 I-.156 J3.043 E.50269
; COOLING_NODE: 1
M204 S250
G1 X181.001 Y164.97 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2874
M204 S5000
G1 X181.109 Y164.702 E.00887
G3 X184.303 Y162.661 I3.143 J1.398 E.12334
G1 X184.429 Y162.665 E.00389
G3 X180.984 Y165.027 I-.177 J3.435 E.52607
; WIPE_START
G1 F9547.055
M204 S8000
G1 X181.109 Y164.702 E-.13243
G1 X181.267 Y164.387 E-.13401
G1 X181.432 Y164.127 E-.11693
G1 X181.649 Y163.849 E-.13395
G1 X181.861 Y163.625 E-.11725
G1 X182.085 Y163.427 E-.11362
G1 X182.11 Y163.409 E-.01182
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X184.07 Y165.923 Z3.6 F60000
G1 Z3.2
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.54142
G1 F2997
M204 S8000
G1 X183.996 Y166.05 E.00595
G1 X184.052 Y166.274 E.00938
G1 X184.207 Y166.348 E.00696
G1 X184.384 Y166.31 E.00739
G1 X184.497 Y166.188 E.00676
G1 X184.498 Y166.08 E.00436
G1 X184.422 Y165.916 E.00737
G1 X184.242 Y165.838 E.00796
G1 X184.124 Y165.897 E.00537
M204 S10000
G1 X183.624 Y165.781 F60000
; LINE_WIDTH: 0.41999
G1 F2997
M204 S8000
G1 X183.555 Y166.019 E.00762
G1 X183.611 Y166.353 E.0104
G1 X183.751 Y166.591 E.00849
G1 X183.955 Y166.726 E.0075
G1 X184.233 Y166.787 E.00874
G1 X184.533 Y166.735 E.00937
G1 X184.804 Y166.533 E.01039
G1 X184.934 Y166.246 E.00965
G1 X184.935 Y166.047 E.00614
G1 X184.852 Y165.753 E.00939
G1 X184.639 Y165.533 E.00939
G1 X184.396 Y165.416 E.00828
G1 X184.11 Y165.414 E.00879
G1 X183.836 Y165.541 E.00927
G1 X183.663 Y165.736 E.008
M204 S10000
G1 X183.286 Y165.609 F60000
G1 F2997
M204 S8000
G1 X183.175 Y166 E.01251
G1 X183.201 Y166.342 E.01054
G1 X183.386 Y166.744 E.01358
G1 X183.652 Y166.996 E.01125
G1 X184.063 Y167.16 E.01361
G2 X184.688 Y167.083 I.185 J-1.068 E.01962
G1 X185.047 Y166.824 E.0136
G1 X185.214 Y166.59 E.00884
G1 X185.325 Y166.199 E.0125
G2 X185.084 Y165.438 I-1.364 J.014 E.02488
G1 X184.852 Y165.222 E.00974
G1 X184.535 Y165.056 E.011
G1 X184.1 Y165.029 E.01337
G1 X183.749 Y165.161 E.01154
G1 X183.474 Y165.366 E.01053
G1 X183.323 Y165.561 E.00759
M204 S10000
G1 X183.093 Y165.21 F60000
G1 F2997
M204 S8000
G1 X182.892 Y165.58 E.01295
G1 X182.795 Y165.982 E.01269
G1 X182.83 Y166.428 E.01375
G1 X182.994 Y166.842 E.01369
G1 X183.266 Y167.171 E.01312
G1 X183.574 Y167.393 E.01167
G1 X183.997 Y167.535 E.01371
G1 X184.427 Y167.546 E.0132
G1 X184.843 Y167.431 E.01327
G1 X185.218 Y167.192 E.01368
G1 X185.482 Y166.872 E.01274
G1 X185.653 Y166.506 E.01241
G2 X185.687 Y165.989 I-.985 J-.323 E.0161
G1 X185.67 Y165.772 E.00667
G1 X185.512 Y165.371 E.01324
G1 X185.244 Y165.034 E.01323
G1 X184.876 Y164.782 E.01372
G1 X184.458 Y164.662 E.01336
G1 X184.047 Y164.653 E.01261
G2 X183.391 Y164.922 I.526 J2.221 E.02188
G1 X183.136 Y165.168 E.01088
M204 S10000
G1 X182.799 Y164.97 F60000
G1 F2997
M204 S8000
G1 X182.554 Y165.411 E.01551
G2 X182.416 Y165.963 I2.439 J.902 E.01753
G1 X182.458 Y166.514 E.01696
G1 X182.66 Y167.024 E.01685
G1 X182.99 Y167.428 E.01603
G1 X183.411 Y167.736 E.01603
G1 X183.931 Y167.911 E.01687
G1 X184.473 Y167.925 E.01666
G1 X184.998 Y167.78 E.01674
G1 X185.46 Y167.485 E.01684
G1 X185.799 Y167.076 E.01633
G1 X186.018 Y166.609 E.01583
G1 X186.084 Y166.236 E.01164
G1 X186.042 Y165.686 E.01695
G1 X185.842 Y165.181 E.0167
G1 X185.504 Y164.755 E.01669
G1 X185.051 Y164.445 E.01687
G1 X184.573 Y164.299 E.01537
G1 X184.147 Y164.272 E.01312
G1 X183.656 Y164.36 E.01533
G1 X183.168 Y164.613 E.01687
G1 X182.842 Y164.928 E.01394
; COOLING_NODE: 2
; WIPE_START
G1 F9547.299
G1 X183.168 Y164.613 E-.17239
G1 X183.656 Y164.36 E-.20869
G1 X184.147 Y164.272 E-.18961
G1 X184.573 Y164.299 E-.16227
G1 X184.641 Y164.32 E-.02705
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X179.498 Y165.248 Z3.6 F60000
G1 Z3.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2997
M204 S8000
G1 X178.702 Y165.248 E.0264
G1 X178.702 Y164.452 E.0264
G1 X179.498 Y164.452 E.0264
G1 X179.498 Y165.188 E.02441
; COOLING_NODE: 2
M204 S250
G1 X179.89 Y165.64 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2922
M204 S5000
G1 X178.31 Y165.64 E.04855
G1 X178.31 Y164.06 E.04855
G1 X179.89 Y164.06 E.04855
G1 X179.89 Y165.58 E.04671
; COOLING_NODE: 2
; WIPE_START
G1 F9547.055
M204 S8000
G1 X178.31 Y165.64 E-.60084
G1 X178.31 Y165.221 E-.15917
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X170.678 Y165.247 Z3.6 F60000
G1 X170.502 Y165.248 Z3.6
G1 Z3.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2997
M204 S8000
G1 X170.502 Y164.452 E.0264
G1 X171.298 Y164.452 E.0264
G1 X171.298 Y165.248 E.0264
G1 X170.562 Y165.248 E.02441
; COOLING_NODE: 2
M204 S250
G1 X170.11 Y165.64 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2922
M204 S5000
G1 X170.11 Y164.06 E.04855
G1 X171.69 Y164.06 E.04855
G1 X171.69 Y165.64 E.04855
G1 X170.17 Y165.64 E.04671
; COOLING_NODE: 4
; WIPE_START
G1 F9547.055
M204 S8000
G1 X170.11 Y164.06 E-.60084
G1 X170.529 Y164.06 E-.15917
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X167.835 Y165.299 Z3.6 F60000
G1 Z3.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2997
M204 S8000
G3 X165.788 Y163.867 I-2.084 J.801 E.37747
G1 X165.862 Y163.869 E.00243
G3 X167.813 Y165.243 I-.111 J2.23 E.08351
; COOLING_NODE: 4
M204 S10000
G1 X168.215 Y165.15 F60000
G1 F2997
M204 S8000
G3 X165.793 Y163.46 I-2.464 J.949 E.44629
G1 X165.884 Y163.463 E.00303
G3 X168.193 Y165.095 I-.133 J2.637 E.09895
; COOLING_NODE: 4
M204 S10000
G1 X168.597 Y165.015 F60000
G1 F2997
M204 S8000
G1 X168.681 Y165.26 E.00857
G3 X165.798 Y163.053 I-2.929 J.84 E.50611
G1 X165.907 Y163.056 E.00363
G3 X168.577 Y164.959 I-.156 J3.043 E.11482
; COOLING_NODE: 4
M204 S250
G1 X168.969 Y164.89 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2874
M204 S5000
G1 X169.058 Y165.151 E.00848
G3 X165.803 Y162.661 I-3.306 J.948 E.52909
G1 X165.929 Y162.665 E.00389
G3 X168.95 Y164.833 I-.177 J3.435 E.12071
; WIPE_START
G1 F9547.055
M204 S8000
G1 X169.058 Y165.151 E-.12762
G1 X169.138 Y165.502 E-.1368
G1 X169.182 Y165.86 E-.13696
G1 X169.189 Y166.16 E-.11384
G1 X169.164 Y166.519 E-.13702
G1 X169.115 Y166.799 E-.10776
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X165.922 Y165.916 Z3.6 F60000
G1 Z3.2
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.54142
G1 F2997
M204 S8000
G1 X165.757 Y165.837 E.00744
G1 X165.624 Y165.881 E.00566
G1 X165.513 Y166.021 E.00727
G1 X165.52 Y166.203 E.00737
G1 X165.595 Y166.311 E.00534
G1 X165.78 Y166.35 E.0077
G1 X165.959 Y166.26 E.00813
G2 X165.947 Y165.97 I-.202 J-.137 E.01262
M204 S10000
G1 X166.352 Y165.753 F60000
; LINE_WIDTH: 0.41999
G1 F2997
M204 S8000
G1 X166.107 Y165.512 E.01054
G1 X165.896 Y165.416 E.00713
G1 X165.596 Y165.417 E.0092
G1 X165.385 Y165.512 E.00712
G1 X165.185 Y165.704 E.00852
G1 X165.066 Y165.98 E.00922
G1 X165.088 Y166.283 E.00935
G1 X165.244 Y166.585 E.01044
G1 X165.455 Y166.726 E.00781
G1 X165.733 Y166.787 E.00872
G1 X166.033 Y166.735 E.00937
G1 X166.304 Y166.533 E.01038
G1 X166.434 Y166.245 E.00972
G2 X166.368 Y165.81 I-.787 J-.102 E.01367
M204 S10000
G1 X166.584 Y165.438 F60000
G1 F2997
M204 S8000
G1 X166.352 Y165.222 E.00975
G1 X166.035 Y165.056 E.01099
G1 X165.6 Y165.029 E.01337
G1 X165.231 Y165.153 E.01198
G1 X164.96 Y165.369 E.01064
G1 X164.793 Y165.606 E.00892
G1 X164.69 Y165.913 E.00995
G2 X164.767 Y166.538 I1.068 J.186 E.01961
G1 X165.026 Y166.897 E.01361
G1 X165.238 Y167.051 E.00805
G1 X165.563 Y167.16 E.01055
G2 X166.188 Y167.083 I.186 J-1.068 E.01962
G1 X166.547 Y166.824 E.01359
G1 X166.714 Y166.591 E.00881
G1 X166.825 Y166.2 E.01251
G2 X166.614 Y165.49 I-1.334 J.011 E.02304
M204 S10000
G1 X167.012 Y165.372 F60000
G1 F2997
M204 S8000
G1 X166.744 Y165.034 E.01323
G1 X166.376 Y164.782 E.01372
G1 X165.963 Y164.663 E.01321
G1 X165.547 Y164.653 E.01277
G1 X165.168 Y164.768 E.01218
G2 X164.682 Y165.107 I1.61 J2.818 E.01824
G1 X164.453 Y165.435 E.01228
G1 X164.315 Y165.847 E.01336
G1 X164.304 Y166.277 E.01321
G1 X164.418 Y166.693 E.01326
G1 X164.658 Y167.068 E.01368
G1 X164.949 Y167.314 E.01171
G2 X165.497 Y167.535 I1.433 J-2.754 E.01819
G1 X165.927 Y167.546 E.0132
G1 X166.343 Y167.431 E.01328
G1 X166.718 Y167.192 E.01367
G1 X166.981 Y166.874 E.01267
G1 X167.155 Y166.501 E.01264
G2 X167.187 Y165.988 I-.981 J-.319 E.01595
G1 X167.17 Y165.772 E.00667
G1 X167.034 Y165.427 E.01138
M204 S10000
G1 X167.342 Y165.181 F60000
G1 F2997
M204 S8000
G1 X167.004 Y164.755 E.01669
G1 X166.551 Y164.445 E.01687
G1 X166.073 Y164.299 E.01537
G1 X165.661 Y164.271 E.0127
G1 X165.151 Y164.361 E.01591
G1 X164.834 Y164.505 E.01069
G1 X164.405 Y164.846 E.01685
G1 X164.113 Y165.263 E.01563
G1 X163.939 Y165.781 E.01677
G1 X163.925 Y166.323 E.01667
G1 X164.07 Y166.848 E.01672
G1 X164.365 Y167.31 E.01684
G1 X164.747 Y167.632 E.01534
G2 X165.431 Y167.911 I1.486 J-2.662 E.02276
G1 X165.973 Y167.925 E.01667
G1 X166.498 Y167.78 E.01674
G1 X166.96 Y167.485 E.01684
G1 X167.299 Y167.077 E.0163
G1 X167.519 Y166.604 E.01603
G1 X167.584 Y166.237 E.01145
G1 X167.542 Y165.686 E.01697
G1 X167.364 Y165.237 E.01485
; CHANGE_LAYER
; Z_HEIGHT: 3.36
; LAYER_HEIGHT: 0.16
; WIPE_START
G1 F9547.299
G1 X167.542 Y165.686 E-.18364
G1 X167.584 Y166.237 E-.20984
G1 X167.519 Y166.604 E-.14161
G1 X167.299 Y167.077 E-.19822
G1 X167.254 Y167.131 E-.02669
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 20/85
; update layer progress
M73 L20
M991 S0 P19 ;notify layer change

; OBJECT_ID: 15
M204 S10000
G17
G3 Z3.6 I.556 J1.083 P1  F60000
G1 X173.612 Y163.869 Z3.6
G1 Z3.36
G1 E.8 F1800
; FEATURE: Support interface
; LINE_WIDTH: 0.42
; LAYER_HEIGHT: 0.24
G1 F2990
M204 S8000
G1 X172.438 Y165.042 E.05981
G1 X172.438 Y165.662 E.02232
G1 X173.059 Y165.662 E.02238
G1 X174.683 Y164.038 E.08272
G1 X175.923 Y164.038 E.04469
G1 X174.3 Y165.662 E.08272
G1 X175.54 Y165.662 E.04469
G1 X177.163 Y164.038 E.08272
G1 X177.562 Y164.038 E.01434
G1 X177.562 Y164.881 E.03035
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X176.611 Y165.831 E.04845
; CHANGE_LAYER
; Z_HEIGHT: 3.4
; LAYER_HEIGHT: 0.0400002
; WIPE_START
G1 F4800
G1 X177.562 Y164.881 E-.51093
G1 X177.562 Y164.225 E-.24907
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 21/85
; update layer progress
M73 L21
M991 S0 P20 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 5
M204 S10000
G17
G3 Z3.76 I.895 J.824 P1  F60000
G1 X187.298 Y153.648 Z3.76
G1 Z3.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
; LAYER_HEIGHT: 0.2
G1 F2990
M204 S8000
G1 X162.702 Y153.648 E.81589
G1 X162.702 Y152.852 E.0264
G1 X187.298 Y152.852 E.81589
G1 X187.298 Y153.588 E.02441
; COOLING_NODE: 5
M204 S250
G1 X187.69 Y154.04 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2844
M204 S5000
G1 X162.31 Y154.04 E.77986
G1 X162.31 Y152.46 E.04855
G1 X187.69 Y152.46 E.77986
G1 X187.69 Y153.98 E.04671
M204 S10000
M73 P55 R7
G1 X187.094 Y153.25 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F2990
M204 S8000
G1 X162.906 Y153.25 E.76636
; COOLING_NODE: 1
; WIPE_START
G1 F9259.259
G1 X164.906 Y153.25 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.147 Y157.644 Z3.8 F60000
G1 X182.138 Y165.381 Z3.8
G1 Z3.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2990
M204 S8000
G1 X182.191 Y165.227 E.00543
G3 X184.245 Y163.867 I2.055 J.873 E.08653
G1 X184.366 Y163.87 E.00404
G3 X182.111 Y165.447 I-.12 J2.23 E.36706
G1 X182.115 Y165.437 E.00035
; COOLING_NODE: 1
M204 S10000
G1 X181.756 Y165.242 F60000
G1 F2990
M204 S8000
G1 X181.818 Y165.068 E.00614
G3 X184.247 Y163.459 I2.43 J1.032 E.10237
G1 X184.388 Y163.463 E.00468
G3 X181.723 Y165.328 I-.14 J2.636 E.43403
G1 X181.734 Y165.298 E.00105
; COOLING_NODE: 1
M204 S10000
G1 X181.374 Y165.103 F60000
G1 F2990
M204 S8000
G1 X181.444 Y164.909 E.00684
G3 X184.248 Y163.052 I2.805 J1.19 E.1182
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X184.409 Y163.056 E.00532
G3 X181.335 Y165.209 I-.16 J3.043 E.501
G1 X181.353 Y165.159 E.00176
; COOLING_NODE: 1
M204 S250
G1 X181.006 Y164.969 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2844
M204 S5000
G1 X181.084 Y164.756 E.00697
G3 X184.25 Y162.66 I3.166 J1.343 E.12361
G1 X184.43 Y162.665 E.00551
G3 X180.961 Y165.095 I-.18 J3.435 E.52382
G1 X180.985 Y165.026 E.00225
; WIPE_START
G1 F9547.055
M204 S8000
G1 X181.084 Y164.756 E-.10903
G1 X181.213 Y164.485 E-.11426
G1 X181.398 Y164.177 E-.13658
G1 X181.615 Y163.888 E-.13724
G1 X181.818 Y163.667 E-.11388
G1 X182.085 Y163.427 E-.13646
G1 X182.111 Y163.407 E-.01256
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X184.069 Y165.91 Z3.8 F60000
G1 Z3.4
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.54122
G1 F2990
M204 S8000
G1 X183.998 Y166.087 E.00773
G1 X184.044 Y166.254 E.00702
G1 X184.226 Y166.348 E.00833
G1 X184.391 Y166.321 E.00679
G1 X184.504 Y166.138 E.00873
G2 X184.457 Y165.948 I-.455 J.012 E.00802
G1 X184.295 Y165.845 E.0078
G1 X184.127 Y165.894 E.00709
M204 S10000
G1 X183.75 Y165.61 F60000
; LINE_WIDTH: 0.41999
G1 F2990
M204 S8000
G1 X183.597 Y165.863 E.00906
G1 X183.566 Y166.165 E.00933
G1 X183.67 Y166.493 E.01057
G1 X183.892 Y166.696 E.00925
G1 X184.183 Y166.784 E.00936
G1 X184.521 Y166.746 E.01044
G1 X184.728 Y166.6 E.00779
G1 X184.885 Y166.362 E.00875
G1 X184.944 Y166.137 E.00713
G1 X184.934 Y166.034 E.00318
G1 X184.832 Y165.709 E.01046
G1 X184.603 Y165.5 E.00953
G1 X184.319 Y165.403 E.00922
G1 X183.986 Y165.466 E.01039
G1 X183.801 Y165.579 E.00668
M204 S10000
G1 X183.403 Y165.431 F60000
G1 F2990
M204 S8000
G1 X183.239 Y165.732 E.01055
G2 X183.206 Y166.36 I1.019 J.368 E.0196
G1 X183.385 Y166.742 E.01299
G1 X183.696 Y167.022 E.01284
G2 X184.306 Y167.175 I.556 J-.93 E.01962
G1 X184.735 Y167.062 E.01363
G1 X184.954 Y166.919 E.00801
G1 X185.173 Y166.654 E.01057
G1 X185.315 Y166.259 E.01289
G2 X185.071 Y165.399 I-1.441 J-.057 E.02794
G1 X184.801 Y165.175 E.0108
G1 X184.422 Y165.038 E.01236
G1 X183.99 Y165.056 E.0133
G1 X183.59 Y165.249 E.01363
G1 X183.446 Y165.389 E.00619
M204 S10000
G1 X182.984 Y165.411 F60000
G1 F2990
M204 S8000
G1 X182.88 Y165.602 E.00667
G1 X182.795 Y166.024 E.01324
G1 X182.836 Y166.452 E.01323
G1 X183.083 Y166.967 E.01755
G1 X183.499 Y167.349 E.01737
G1 X183.897 Y167.514 E.01323
G1 X184.326 Y167.556 E.01324
G1 X184.763 Y167.466 E.01369
G1 X185.096 Y167.283 E.0117
G2 X185.5 Y166.85 I-2.067 J-2.334 E.0182
G1 X185.688 Y166.315 E.01744
G2 X185.664 Y165.747 I-3.308 J-.146 E.01749
G1 X185.421 Y165.237 E.01736
G1 X184.998 Y164.849 E.01762
G1 X184.481 Y164.666 E.01687
G2 X183.898 Y164.686 I-.186 J3.063 E.01797
G1 X183.486 Y164.857 E.0137
G1 X183.194 Y165.101 E.0117
G1 X183.018 Y165.361 E.00966
M204 S10000
G1 X182.691 Y165.16 F60000
G1 F2990
M204 S8000
G1 X182.522 Y165.471 E.01089
G1 X182.414 Y166.004 E.0167
G1 X182.466 Y166.545 E.0167
G1 X182.679 Y167.056 E.01701
G1 X182.88 Y167.327 E.01037
G1 X183.303 Y167.676 E.01685
G1 X183.805 Y167.884 E.01669
G1 X184.346 Y167.936 E.0167
G1 X184.883 Y167.827 E.01685
G1 X185.32 Y167.586 E.01533
G2 X185.826 Y167.047 I-1.959 J-2.346 E.02278
G1 X186.035 Y166.541 E.01683
G2 X186.06 Y165.927 I-1.223 J-.356 E.01905
G1 X186.034 Y165.655 E.0084
G1 X185.824 Y165.149 E.01685
G1 X185.624 Y164.877 E.01037
G1 X185.196 Y164.523 E.01704
G1 X184.72 Y164.322 E.0159
G1 X184.354 Y164.264 E.01136
G1 X183.805 Y164.316 E.01694
G1 X183.299 Y164.526 E.01686
G1 X182.916 Y164.846 E.01533
G1 X182.726 Y165.111 E.01001
; COOLING_NODE: 2
; WIPE_START
G1 F9547.299
G1 X182.916 Y164.846 E-.12384
G1 X183.299 Y164.526 E-.18959
G1 X183.805 Y164.316 E-.20853
G1 X184.354 Y164.264 E-.20956
G1 X184.428 Y164.275 E-.02848
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X179.498 Y165.248 Z3.8 F60000
G1 Z3.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2990
M204 S8000
G1 X178.702 Y165.248 E.0264
G1 X178.702 Y164.452 E.0264
G1 X179.498 Y164.452 E.0264
G1 X179.498 Y165.188 E.02441
; COOLING_NODE: 2
M204 S250
G1 X179.89 Y165.64 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2900
M204 S5000
G1 X178.31 Y165.64 E.04855
G1 X178.31 Y164.06 E.04855
G1 X179.89 Y164.06 E.04855
G1 X179.89 Y165.58 E.04671
; COOLING_NODE: 2
; WIPE_START
G1 F9547.055
M204 S8000
G1 X178.31 Y165.64 E-.60084
G1 X178.31 Y165.221 E-.15917
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X170.678 Y165.247 Z3.8 F60000
G1 X170.502 Y165.248 Z3.8
G1 Z3.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2990
M204 S8000
G1 X170.502 Y164.452 E.0264
G1 X171.298 Y164.452 E.0264
G1 X171.298 Y165.248 E.0264
G1 X170.562 Y165.248 E.02441
; COOLING_NODE: 2
M204 S250
G1 X170.11 Y165.64 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2900
M204 S5000
G1 X170.11 Y164.06 E.04855
G1 X171.69 Y164.06 E.04855
G1 X171.69 Y165.64 E.04855
G1 X170.17 Y165.64 E.04671
; COOLING_NODE: 4
; WIPE_START
G1 F9547.055
M204 S8000
G1 X170.11 Y164.06 E-.60084
G1 X170.529 Y164.06 E-.15917
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X167.846 Y165.338 Z3.8 F60000
G1 Z3.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2990
M204 S8000
G3 X165.745 Y163.867 I-2.099 J.762 E.37477
G1 X165.866 Y163.87 E.00404
G3 X167.825 Y165.282 I-.12 J2.23 E.0846
; COOLING_NODE: 4
M204 S10000
G1 X168.229 Y165.198 F60000
G1 F2990
M204 S8000
G3 X165.747 Y163.459 I-2.481 J.901 E.44317
G1 X165.888 Y163.463 E.00468
G3 X168.208 Y165.142 I-.14 J2.636 E.10042
; COOLING_NODE: 4
M204 S10000
G1 X168.608 Y165.043 F60000
G1 F2990
M204 S8000
G1 X168.613 Y165.058 E.00054
G3 X165.748 Y163.052 I-2.864 J1.041 E.51157
G1 X165.909 Y163.056 E.00532
G3 X168.487 Y164.763 I-.16 J3.043 E.10758
G1 X168.584 Y164.988 E.00811
; COOLING_NODE: 4
M204 S250
G1 X168.968 Y164.89 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2844
M204 S5000
G1 X168.982 Y164.924 E.00113
G3 X165.75 Y162.66 I-3.232 J1.175 E.53489
G1 X165.93 Y162.665 E.00551
G3 X168.841 Y164.592 I-.18 J3.435 E.11255
G1 X168.945 Y164.835 E.0081
; WIPE_START
G1 F9547.055
M204 S8000
G1 X168.982 Y164.924 E-.03672
G1 X169.088 Y165.268 E-.13656
G1 X169.156 Y165.621 E-.13693
G1 X169.185 Y165.919 E-.11374
G1 X169.185 Y166.28 E-.13709
G1 X169.148 Y166.639 E-.13708
G1 X169.115 Y166.798 E-.06189
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X165.957 Y165.948 Z3.8 F60000
G1 Z3.4
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.54126
G1 F2990
M204 S8000
G1 X165.795 Y165.845 E.0078
G1 X165.57 Y165.91 E.00951
G1 X165.498 Y166.087 E.00775
G1 X165.555 Y166.274 E.00793
G1 X165.678 Y166.343 E.00576
G1 X165.891 Y166.321 E.0087
G1 X166.004 Y166.138 E.00871
G2 X165.975 Y166.005 I-.316 J-.001 E.00558
M204 S10000
G1 X166.332 Y165.709 F60000
; LINE_WIDTH: 0.41999
G1 F2990
M204 S8000
G1 X166.103 Y165.501 E.00952
G1 X165.819 Y165.403 E.00923
G1 X165.485 Y165.466 E.01043
G1 X165.249 Y165.61 E.00849
G1 X165.097 Y165.862 E.00905
G1 X165.066 Y166.165 E.00934
G1 X165.17 Y166.493 E.01057
G1 X165.397 Y166.704 E.00955
G1 X165.636 Y166.779 E.00769
G1 X165.966 Y166.757 E.01017
G1 X166.193 Y166.643 E.00781
G1 X166.385 Y166.362 E.01045
G1 X166.444 Y166.137 E.00714
G2 X166.35 Y165.767 I-.919 J.036 E.01184
M204 S10000
G1 X166.571 Y165.399 F60000
G1 F2990
M204 S8000
G1 X166.301 Y165.175 E.01079
G1 X165.922 Y165.038 E.01237
G1 X165.49 Y165.056 E.01329
G1 X165.089 Y165.249 E.01367
G1 X164.903 Y165.431 E.008
G1 X164.739 Y165.732 E.01053
G2 X164.706 Y166.36 I1.018 J.368 E.01961
G1 X164.899 Y166.761 E.01368
G1 X165.099 Y166.964 E.00875
G1 X165.465 Y167.141 E.0125
G1 X165.806 Y167.175 E.01054
G1 X166.234 Y167.062 E.0136
G1 X166.454 Y166.918 E.00807
G1 X166.673 Y166.654 E.01054
G1 X166.815 Y166.259 E.01289
G2 X166.6 Y165.451 I-1.396 J-.061 E.02609
M204 S10000
G1 X166.921 Y165.237 F60000
G1 F2990
M204 S8000
G1 X166.499 Y164.849 E.01761
G1 X165.981 Y164.666 E.01687
G2 X165.398 Y164.686 I-.186 J3.058 E.01797
G1 X164.982 Y164.859 E.01384
G1 X164.594 Y165.21 E.01608
G1 X164.38 Y165.602 E.01369
G1 X164.295 Y166.024 E.01324
G1 X164.336 Y166.452 E.01323
G1 X164.509 Y166.868 E.01384
G1 X164.775 Y167.178 E.01254
G1 X165.111 Y167.414 E.01263
G1 X165.381 Y167.512 E.00881
G1 X165.826 Y167.556 E.01375
G1 X166.263 Y167.466 E.01368
G1 X166.596 Y167.282 E.01172
G2 X167 Y166.85 I-2.05 J-2.317 E.01818
G1 X167.188 Y166.315 E.01743
G2 X167.164 Y165.747 I-3.306 J-.146 E.01749
G1 X166.946 Y165.291 E.01552
M204 S10000
G1 X167.324 Y165.149 F60000
G1 F2990
M204 S8000
G1 X167.123 Y164.877 E.01037
G1 X166.697 Y164.523 E.01703
G1 X166.22 Y164.322 E.01591
G1 X165.854 Y164.264 E.01136
G1 X165.305 Y164.316 E.01695
G1 X164.794 Y164.529 E.01702
G1 X164.415 Y164.846 E.01518
G2 X164.022 Y165.471 I2.36 J1.922 E.02274
G1 X163.914 Y166.004 E.01671
G1 X163.966 Y166.545 E.0167
G1 X164.179 Y167.056 E.01701
G1 X164.52 Y167.456 E.01615
G1 X164.947 Y167.755 E.01601
G1 X165.297 Y167.883 E.01144
G1 X165.846 Y167.936 E.01696
G1 X166.383 Y167.827 E.01685
G1 X166.821 Y167.585 E.01535
G2 X167.326 Y167.047 I-1.95 J-2.337 E.02276
G1 X167.535 Y166.541 E.01682
G2 X167.56 Y165.927 I-1.223 J-.356 E.01905
G1 X167.534 Y165.655 E.0084
G1 X167.347 Y165.204 E.015
; CHANGE_LAYER
; Z_HEIGHT: 3.6
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9547.299
G1 X167.534 Y165.655 E-.18556
G1 X167.56 Y165.927 E-.1039
G1 X167.586 Y166.201 E-.10457
G1 X167.535 Y166.541 E-.13046
G1 X167.326 Y167.047 E-.20806
G1 X167.28 Y167.102 E-.02744
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 22/85
; update layer progress
M73 L22
M991 S0 P21 ;notify layer change

; OBJECT_ID: 15
M204 S10000
G17
G3 Z3.8 I.526 J1.097 P1  F60000
G1 X172.269 Y164.711 Z3.8
G1 Z3.6
G1 E.8 F1800
; FEATURE: Support interface
; LINE_WIDTH: 0.42
; LAYER_HEIGHT: 0.24
G1 F2995
M204 S8000
G1 X173.219 Y165.662 E.04844
G1 X174.46 Y165.662 E.04469
G1 X172.837 Y164.038 E.08271
G1 X174.077 Y164.038 E.04469
G1 X175.7 Y165.662 E.08271
G1 X176.94 Y165.662 E.04469
G1 X175.317 Y164.038 E.08271
G1 X176.558 Y164.038 E.04469
G1 X177.731 Y165.212 E.0598
; COOLING_NODE: 5
; WIPE_START
G1 F4800
G1 X176.558 Y164.038 E-.63066
G1 X176.217 Y164.038 E-.12934
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X181.785 Y158.818 Z4 F60000
G1 X187.298 Y153.648 Z4
G1 Z3.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
; LAYER_HEIGHT: 0.2
G1 F2995
M204 S8000
G1 X162.702 Y153.648 E.81589
G1 X162.702 Y152.852 E.0264
G1 X187.298 Y152.852 E.81589
G1 X187.298 Y153.588 E.02441
; COOLING_NODE: 5
M204 S250
G1 X187.69 Y154.04 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2799
M204 S5000
G1 X162.31 Y154.04 E.77986
G1 X162.31 Y152.46 E.04855
G1 X187.69 Y152.46 E.77986
G1 X187.69 Y153.98 E.04671
M204 S10000
M73 P56 R7
G1 X187.094 Y153.25 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F2995
M204 S8000
G1 X162.906 Y153.25 E.76636
; COOLING_NODE: 1
; WIPE_START
G1 F9259.259
G1 X164.906 Y153.25 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.15 Y157.639 Z4 F60000
G1 X182.15 Y165.371 Z4
G1 Z3.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2995
M204 S8000
G1 X182.225 Y165.155 E.00757
G3 X184.253 Y163.867 I2.023 J.944 E.08416
G1 X184.366 Y163.87 E.00373
G3 X182.082 Y165.559 I-.117 J2.23 E.36326
G1 X182.13 Y165.427 E.00466
; COOLING_NODE: 1
M204 S10000
G1 X181.755 Y165.235 F60000
G1 F2995
M204 S8000
G3 X184.255 Y163.459 I2.495 J.865 E.10855
G1 X184.387 Y163.463 E.00438
G3 X181.736 Y165.292 I-.138 J2.636 E.43534
; COOLING_NODE: 1
M204 S10000
G1 X181.372 Y165.101 F60000
G1 F2995
M204 S8000
G3 X184.258 Y163.052 I2.879 J.999 E.12526
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X184.409 Y163.056 E.00502
G3 X181.352 Y165.157 I-.159 J3.043 E.50284
; COOLING_NODE: 1
M204 S250
G1 X181.003 Y164.964 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2799
M204 S5000
G1 X181.134 Y164.646 E.01056
G3 X184.26 Y162.66 I3.117 J1.453 E.12017
G1 X184.43 Y162.665 E.00522
G3 X180.985 Y165.021 I-.178 J3.435 E.52622
; WIPE_START
G1 F9547.055
M204 S8000
G1 X181.134 Y164.646 E-.15329
G1 X181.302 Y164.327 E-.13706
G1 X181.467 Y164.078 E-.11357
G1 X181.693 Y163.799 E-.1367
G1 X181.903 Y163.585 E-.11387
G1 X182.121 Y163.412 E-.10551
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X183.994 Y166.044 Z4 F60000
G1 Z3.6
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.54133
G1 F2995
M204 S8000
G1 X184.034 Y166.23 E.00772
G1 X184.17 Y166.346 E.00724
G1 X184.36 Y166.332 E.00775
G1 X184.506 Y166.158 E.00923
G1 X184.498 Y166.075 E.00338
G1 X184.412 Y165.905 E.00772
G1 X184.26 Y165.842 E.00671
G1 X184.117 Y165.879 E.00597
G1 X184.03 Y165.996 E.00593
M204 S10000
G1 X183.613 Y165.803 F60000
; LINE_WIDTH: 0.41999
G1 F2995
M204 S8000
G1 X183.558 Y166.086 E.00887
G1 X183.616 Y166.364 E.00873
G1 X183.785 Y166.616 E.00932
G1 X184.066 Y166.776 E.00993
G1 X184.387 Y166.773 E.00989
G1 X184.603 Y166.699 E.00701
G1 X184.824 Y166.478 E.00959
G1 X184.939 Y166.227 E.00848
G1 X184.934 Y166.034 E.00595
G1 X184.845 Y165.742 E.00935
G1 X184.602 Y165.505 E.01045
G1 X184.362 Y165.41 E.00791
G1 X184.134 Y165.418 E.00701
G1 X183.853 Y165.523 E.00924
G1 X183.652 Y165.757 E.00947
M204 S10000
G1 X183.362 Y165.486 F60000
G1 F2995
M204 S8000
G1 X183.2 Y165.838 E.01192
G1 X183.191 Y166.201 E.01116
G2 X183.675 Y166.996 I1.167 J-.167 E.02939
G1 X183.986 Y167.147 E.01063
G1 X184.302 Y167.176 E.00975
G1 X184.712 Y167.073 E.01298
G1 X185.05 Y166.82 E.01297
G1 X185.274 Y166.434 E.0137
G2 X185.309 Y165.998 I-.682 J-.274 E.01364
G1 X185.233 Y165.691 E.00973
G1 X185.063 Y165.413 E.01002
G1 X184.796 Y165.181 E.01084
G1 X184.529 Y165.055 E.00907
G1 X184.124 Y165.028 E.01249
G1 X183.696 Y165.178 E.01392
G1 X183.406 Y165.445 E.01211
M204 S10000
G1 X182.985 Y165.382 F60000
G1 F2995
M204 S8000
G1 X182.833 Y165.747 E.01214
G2 X182.836 Y166.453 I2.243 J.344 E.02179
G1 X183.001 Y166.851 E.01324
G1 X183.274 Y167.183 E.01322
G1 X183.648 Y167.43 E.01377
G2 X184.324 Y167.556 I.721 J-1.987 E.02121
G1 X184.874 Y167.413 E.01747
G1 X185.333 Y167.075 E.01753
G1 X185.579 Y166.704 E.01367
G1 X185.706 Y166.196 E.0161
G1 X185.664 Y165.747 E.01385
G1 X185.499 Y165.35 E.01322
G1 X185.223 Y165.014 E.01335
G1 X184.884 Y164.785 E.01256
G1 X184.447 Y164.66 E.01399
G1 X184.061 Y164.653 E.01185
G1 X183.622 Y164.783 E.01408
G1 X183.284 Y165.026 E.01279
G1 X183.024 Y165.336 E.01242
M204 S10000
G1 X182.759 Y165.023 F60000
G1 F2995
M204 S8000
G1 X182.524 Y165.489 E.01601
G1 X182.414 Y165.999 E.01606
G1 X182.466 Y166.545 E.01684
G1 X182.674 Y167.047 E.0167
G1 X183.019 Y167.466 E.01668
G1 X183.48 Y167.771 E.01698
G1 X183.827 Y167.89 E.01127
G1 X184.345 Y167.936 E.01598
G1 X184.884 Y167.826 E.01688
G1 X185.189 Y167.681 E.01041
G1 X185.617 Y167.33 E.01698
G1 X185.919 Y166.873 E.01684
G1 X186.057 Y166.397 E.01525
G2 X186.034 Y165.655 I-3.402 J-.265 E.02285
G1 X185.826 Y165.153 E.01669
G1 X185.479 Y164.732 E.01675
G1 X185.059 Y164.448 E.01561
G1 X184.559 Y164.296 E.01604
G2 X183.814 Y164.333 I-.297 J1.562 E.02313
G1 X183.469 Y164.435 E.01107
G1 X183.147 Y164.628 E.01155
G1 X182.801 Y164.981 E.01516
; COOLING_NODE: 2
; WIPE_START
G1 F9547.299
G1 X183.147 Y164.628 E-.18752
G1 X183.469 Y164.435 E-.14285
G1 X183.814 Y164.333 E-.13689
G1 X184.19 Y164.27 E-.14489
G1 X184.559 Y164.296 E-.14053
G1 X184.578 Y164.302 E-.00732
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X179.498 Y165.248 Z4 F60000
G1 Z3.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2995
M204 S8000
G1 X178.702 Y165.248 E.0264
G1 X178.702 Y164.452 E.0264
G1 X179.498 Y164.452 E.0264
G1 X179.498 Y165.188 E.02441
; COOLING_NODE: 2
M204 S250
G1 X179.89 Y165.64 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2858
M204 S5000
G1 X178.31 Y165.64 E.04855
G1 X178.31 Y164.06 E.04855
G1 X179.89 Y164.06 E.04855
G1 X179.89 Y165.58 E.04671
; COOLING_NODE: 2
; WIPE_START
G1 F9547.055
M204 S8000
G1 X178.31 Y165.64 E-.60084
G1 X178.31 Y165.221 E-.15917
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X170.678 Y165.247 Z4 F60000
G1 X170.502 Y165.248 Z4
G1 Z3.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2995
M204 S8000
G1 X170.502 Y164.452 E.0264
G1 X171.298 Y164.452 E.0264
G1 X171.298 Y165.248 E.0264
G1 X170.562 Y165.248 E.02441
; COOLING_NODE: 2
M204 S250
G1 X170.11 Y165.64 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2858
M204 S5000
G1 X170.11 Y164.06 E.04855
G1 X171.69 Y164.06 E.04855
G1 X171.69 Y165.64 E.04855
G1 X170.17 Y165.64 E.04671
; COOLING_NODE: 4
; WIPE_START
G1 F9547.055
M204 S8000
G1 X170.11 Y164.06 E-.60084
G1 X170.529 Y164.06 E-.15917
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X167.847 Y165.337 Z4 F60000
G1 Z3.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2995
M204 S8000
G3 X165.753 Y163.867 I-2.099 J.763 E.37504
G1 X165.866 Y163.87 E.00373
G3 X167.826 Y165.281 I-.117 J2.23 E.08464
; COOLING_NODE: 4
M204 S10000
G1 X168.23 Y165.194 F60000
G1 F2995
M204 S8000
G1 X168.23 Y165.197 E.00011
G3 X165.755 Y163.459 I-2.481 J.902 E.44344
G1 X165.887 Y163.463 E.00438
G3 X168.144 Y164.988 I-.138 J2.636 E.09492
G1 X168.207 Y165.139 E.00542
; COOLING_NODE: 4
M204 S10000
G1 X168.606 Y165.039 F60000
G1 F2995
M204 S8000
G1 X168.614 Y165.058 E.00068
G3 X165.758 Y163.052 I-2.864 J1.042 E.51184
G1 X165.909 Y163.056 E.00502
G3 X168.513 Y164.814 I-.159 J3.043 E.10949
G1 X168.583 Y164.983 E.00608
; COOLING_NODE: 4
M204 S250
G1 X168.968 Y164.889 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2799
M204 S5000
G1 X168.983 Y164.924 E.00116
G3 X165.76 Y162.66 I-3.232 J1.176 E.53515
G1 X165.93 Y162.665 E.00522
G3 X168.869 Y164.647 I-.178 J3.435 E.11443
G1 X168.945 Y164.834 E.00621
; WIPE_START
G1 F9547.055
M204 S8000
G1 X168.983 Y164.924 E-.03712
G1 X169.088 Y165.267 E-.13653
G1 X169.156 Y165.621 E-.13689
G1 X169.185 Y165.919 E-.11395
G1 X169.185 Y166.281 E-.13722
G1 X169.156 Y166.579 E-.11394
G1 X169.114 Y166.797 E-.08436
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X165.913 Y165.905 Z4 F60000
G1 Z3.6
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.54132
G1 F2995
M204 S8000
G1 X165.74 Y165.838 E.00753
G2 X165.494 Y166.044 I.06 J.321 E.01361
G1 X165.534 Y166.23 E.00771
G1 X165.67 Y166.346 E.00724
G1 X165.869 Y166.319 E.00816
G1 X165.997 Y166.188 E.00745
G2 X165.94 Y165.959 I-.252 J-.059 E.00997
M204 S10000
G1 X166.345 Y165.742 F60000
; LINE_WIDTH: 0.41999
G1 F2995
M204 S8000
G1 X166.112 Y165.511 E.0101
G1 X165.883 Y165.413 E.00765
G1 X165.576 Y165.422 E.00941
G1 X165.34 Y165.547 E.00822
G1 X165.132 Y165.788 E.00978
G1 X165.053 Y166.03 E.00781
G1 X165.116 Y166.364 E.01045
G1 X165.285 Y166.616 E.00934
G1 X165.566 Y166.776 E.00992
G1 X165.888 Y166.773 E.00989
G1 X166.168 Y166.655 E.00935
G1 X166.387 Y166.397 E.01039
G1 X166.442 Y166.121 E.00866
G2 X166.363 Y165.8 I-.832 J.034 E.01023
M204 S10000
G1 X166.564 Y165.414 F60000
G1 F2995
M204 S8000
G2 X166.029 Y165.055 I-.909 J.775 E.02003
G1 X165.599 Y165.029 E.01326
G1 X165.215 Y165.162 E.01249
G1 X164.95 Y165.38 E.01054
G1 X164.727 Y165.762 E.01358
G1 X164.673 Y166.02 E.00808
G1 X164.706 Y166.36 E.01052
G2 X165.03 Y166.9 I1.05 J-.264 E.01962
G1 X165.402 Y167.118 E.01327
G1 X165.802 Y167.176 E.01241
G2 X166.398 Y166.96 I-.058 J-1.089 E.01974
G1 X166.69 Y166.627 E.0136
G1 X166.812 Y166.284 E.01118
G2 X166.595 Y165.465 I-1.155 J-.132 E.02664
M204 S10000
G1 X166.999 Y165.35 F60000
G1 F2995
M204 S8000
G1 X166.723 Y165.014 E.01333
G1 X166.384 Y164.785 E.01257
G1 X165.966 Y164.663 E.01338
G1 X165.546 Y164.654 E.01291
G1 X165.159 Y164.772 E.01243
G2 X164.667 Y165.125 I1.44 J2.533 E.01865
G1 X164.421 Y165.497 E.01368
G1 X164.316 Y165.863 E.01171
G2 X164.336 Y166.453 I3.082 J.19 E.01817
G1 X164.501 Y166.851 E.01324
G1 X164.775 Y167.183 E.01323
G1 X165.148 Y167.43 E.01374
G2 X165.824 Y167.556 I.722 J-1.987 E.02121
G1 X166.248 Y167.469 E.01331
G1 X166.627 Y167.264 E.01324
G1 X166.939 Y166.946 E.01369
G1 X167.129 Y166.56 E.01321
G1 X167.206 Y166.196 E.01145
G1 X167.164 Y165.747 E.01385
G1 X167.022 Y165.405 E.01138
M204 S10000
G1 X167.326 Y165.153 F60000
G1 F2995
M204 S8000
G1 X166.98 Y164.733 E.01673
G1 X166.559 Y164.448 E.01562
G1 X166.059 Y164.296 E.01603
G1 X165.659 Y164.271 E.01232
G1 X165.152 Y164.36 E.01584
G1 X164.81 Y164.519 E.01158
G1 X164.383 Y164.87 E.01697
G1 X164.081 Y165.327 E.01684
G1 X163.943 Y165.807 E.01534
G2 X163.966 Y166.545 I3.031 J.274 E.02275
G1 X164.174 Y167.047 E.01671
G1 X164.52 Y167.467 E.0167
G1 X164.98 Y167.77 E.01695
G1 X165.327 Y167.89 E.01128
G1 X165.845 Y167.936 E.01598
G1 X166.379 Y167.827 E.01673
G1 X166.857 Y167.569 E.0167
G1 X167.241 Y167.177 E.01685
G1 X167.476 Y166.712 E.01602
G1 X167.586 Y166.206 E.0159
G1 X167.534 Y165.655 E.01702
G1 X167.349 Y165.209 E.01485
; CHANGE_LAYER
; Z_HEIGHT: 3.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9547.299
G1 X167.534 Y165.655 E-.1836
G1 X167.586 Y166.206 E-.21053
G1 X167.476 Y166.712 E-.1966
G1 X167.275 Y167.109 E-.16927
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 23/85
; update layer progress
M73 L23
M991 S0 P22 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 5
M204 S10000
G17
G3 Z4 I1.217 J-.031 P1  F60000
G1 X166.934 Y153.648 Z4
G1 Z3.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F3130
M204 S8000
G1 X162.702 Y153.648 E.14037
G1 X162.702 Y152.852 E.0264
G1 X166.934 Y152.852 E.14037
G1 X166.934 Y153.588 E.02441
; COOLING_NODE: 5
; WIPE_START
G1 F8843.478
G1 X164.934 Y153.616 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z4.2 I-.002 J1.217 P1  F60000
G1 X187.298 Y153.648 Z4.2
G1 Z3.8
G1 E.8 F1800
G1 F3130
M204 S8000
G1 X183.066 Y153.648 E.14037
G1 X183.066 Y152.852 E.0264
G1 X187.298 Y152.852 E.14037
G1 X187.298 Y153.588 E.02441
; COOLING_NODE: 5
M204 S250
G1 X187.69 Y154.04 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2748
M204 S5000
G1 X162.31 Y154.04 E.77986
G1 X162.31 Y152.46 E.04855
G1 X187.69 Y152.46 E.77986
G1 X187.69 Y153.98 E.04671
M204 S10000
G1 X187.094 Y153.25 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F3130
M204 S8000
G1 X183.27 Y153.25 E.12117
M204 S10000
G1 X182.844 Y153.179 F60000
; FEATURE: Top surface
; LINE_WIDTH: 0.42
G1 F3130
M204 S2000
G1 X182.332 Y152.667 E.02224
G1 X182.198 Y152.534
G1 X181.665 Y152.534
G1 X181.799 Y152.667
G1 X182.844 Y153.713 E.04542
G1 X182.977 Y153.846
G1 X182.564 Y153.966
G1 X182.431 Y153.833
G1 X181.265 Y152.667 E.05063
G1 X181.132 Y152.534
M73 P57 R7
G1 X180.598 Y152.534
G1 X180.732 Y152.667
G1 X181.897 Y153.833 E.05063
G1 X182.031 Y153.966
G1 X181.498 Y153.966
G1 X181.364 Y153.833
G1 X180.199 Y152.667 E.05063
G1 X180.065 Y152.534
G1 X179.532 Y152.534
G1 X179.666 Y152.667
G1 X180.831 Y153.833 E.05063
G1 X180.964 Y153.966
G1 X180.431 Y153.966
G1 X180.298 Y153.833
G1 X179.132 Y152.667 E.05063
G1 X178.999 Y152.534
G1 X178.465 Y152.534
G1 X178.599 Y152.667
G1 X179.764 Y153.833 E.05063
G1 X179.898 Y153.966
G1 X179.365 Y153.966
G1 X179.231 Y153.833
G1 X178.066 Y152.667 E.05063
G1 X177.932 Y152.534
G1 X177.399 Y152.534
G1 X177.533 Y152.667
G1 X178.698 Y153.833 E.05063
G1 X178.831 Y153.966
G1 X178.298 Y153.966
G1 X178.165 Y153.833
G1 X176.999 Y152.667 E.05063
G1 X176.866 Y152.534
G1 X176.332 Y152.534
G1 X176.466 Y152.667
G1 X177.631 Y153.833 E.05063
G1 X177.765 Y153.966
G1 X177.232 Y153.966
G1 X177.098 Y153.833
G1 X175.933 Y152.667 E.05063
G1 X175.799 Y152.534
G1 X175.266 Y152.534
G1 X175.4 Y152.667
G1 X176.565 Y153.833 E.05063
G1 X176.698 Y153.966
G1 X176.165 Y153.966
G1 X176.032 Y153.833
G1 X174.866 Y152.667 E.05063
G1 X174.733 Y152.534
G1 X174.199 Y152.534
G1 X174.333 Y152.667
G1 X175.498 Y153.833 E.05063
G1 X175.632 Y153.966
G1 X175.099 Y153.966
G1 X174.965 Y153.833
G1 X173.8 Y152.667 E.05063
G1 X173.666 Y152.534
G1 X173.133 Y152.534
G1 X173.267 Y152.667
G1 X174.432 Y153.833 E.05063
G1 X174.565 Y153.966
G1 X174.032 Y153.966
G1 X173.899 Y153.833
G1 X172.733 Y152.667 E.05063
G1 X172.6 Y152.534
G1 X172.066 Y152.534
G1 X172.2 Y152.667
G1 X173.365 Y153.833 E.05063
G1 X173.499 Y153.966
G1 X172.966 Y153.966
G1 X172.832 Y153.833
G1 X171.667 Y152.667 E.05063
G1 X171.533 Y152.534
G1 X171 Y152.534
G1 X171.134 Y152.667
G1 X172.299 Y153.833 E.05063
G1 X172.432 Y153.966
G1 X171.899 Y153.966
G1 X171.765 Y153.833
G1 X170.6 Y152.667 E.05063
G1 X170.467 Y152.534
G1 X169.933 Y152.534
G1 X170.067 Y152.667
G1 X171.232 Y153.833 E.05063
G1 X171.366 Y153.966
G1 X170.833 Y153.966
G1 X170.699 Y153.833
G1 X169.534 Y152.667 E.05063
G1 X169.4 Y152.534
G1 X168.867 Y152.534
G1 X169 Y152.667
G1 X170.166 Y153.833 E.05063
G1 X170.299 Y153.966
G1 X169.766 Y153.966
G1 X169.632 Y153.833
G1 X168.467 Y152.667 E.05063
G1 X168.334 Y152.534
G1 X167.8 Y152.534
G1 X167.934 Y152.667
G1 X169.099 Y153.833 E.05063
G1 X169.233 Y153.966
G1 X168.7 Y153.966
G1 X168.566 Y153.833
G1 X167.401 Y152.667 E.05063
G1 X167.267 Y152.534
G1 X167.023 Y152.823
G1 X167.156 Y152.956
M73 P57 R6
G1 X168.033 Y153.833 E.03809
G1 X168.166 Y153.966
G1 X167.633 Y153.966
G1 X167.499 Y153.833
G1 X167.156 Y153.489 E.01491
M204 S10000
G1 X166.73 Y153.25 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F3130
M204 S8000
G1 X162.906 Y153.25 E.12117
; COOLING_NODE: 1
; WIPE_START
G1 F9259.259
G1 X164.906 Y153.25 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.148 Y157.642 Z4.2 F60000
G1 X182.138 Y165.373 Z4.2
G1 Z3.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F3130
M204 S8000
G3 X184.261 Y163.867 I2.111 J.726 E.09217
G1 X184.365 Y163.87 E.00345
G3 X182.12 Y165.43 I-.115 J2.23 E.36779
; COOLING_NODE: 1
M204 S10000
G1 X181.754 Y165.241 F60000
G1 F3130
M204 S8000
G3 X184.264 Y163.46 I2.497 J.859 E.10899
G1 X184.387 Y163.463 E.00407
G3 X181.735 Y165.298 I-.136 J2.637 E.4352
; COOLING_NODE: 1
M204 S10000
G1 X181.368 Y165.108 F60000
G1 F3130
M204 S8000
G1 X181.489 Y164.813 E.01056
G3 X184.267 Y163.052 I2.762 J1.286 E.11524
G1 X184.408 Y163.056 E.00469
G3 X181.352 Y165.164 I-.157 J3.043 E.50268
; COOLING_NODE: 1
M204 S250
G1 X181.009 Y164.962 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2748
M204 S5000
G1 X181.062 Y164.811 E.00491
G3 X184.43 Y162.665 I3.189 J1.288 E.13093
G3 X184.609 Y169.521 I-.181 J3.435 E.31542
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G3 X180.944 Y165.152 I-.358 J-3.421 E.20656
G1 X180.989 Y165.019 E.00432
; WIPE_START
G1 F9547.055
M204 S8000
G1 X181.062 Y164.811 E-.08355
G1 X181.213 Y164.484 E-.13707
G1 X181.365 Y164.226 E-.11379
G1 X181.577 Y163.935 E-.13681
G1 X181.818 Y163.668 E-.13669
G1 X182.085 Y163.427 E-.13669
G1 X182.118 Y163.403 E-.0154
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X182.579 Y165.331 Z4.2 F60000
G1 Z3.8
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F3130
M204 S8000
G1 X182.458 Y165.685 E.01151
G1 X182.413 Y166.195 E.01573
G1 X182.524 Y166.734 E.0169
G1 X182.671 Y167.043 E.01054
G1 X183.02 Y167.467 E.01685
G1 X183.466 Y167.763 E.01645
G1 X183.966 Y167.918 E.0161
G1 X184.342 Y167.937 E.01155
G1 X184.883 Y167.826 E.017
G1 X185.345 Y167.568 E.01627
G1 X185.716 Y167.211 E.01579
G1 X185.962 Y166.747 E.01616
G2 X186.06 Y166.276 I-.865 J-.425 E.01491
G1 X186.086 Y166.004 E.0084
G1 X185.976 Y165.466 E.01687
G1 X185.829 Y165.157 E.01052
G1 X185.48 Y164.733 E.01689
G1 X185.058 Y164.448 E.01562
G1 X184.563 Y164.297 E.01591
G1 X184.162 Y164.271 E.01237
G1 X183.647 Y164.362 E.01605
G1 X183.309 Y164.52 E.01148
G1 X182.884 Y164.869 E.01691
G1 X182.612 Y165.281 E.01513
M204 S10000
G1 X183.167 Y165.125 F60000
G1 F3130
M204 S8000
G1 X182.921 Y165.498 E.01376
G2 X182.794 Y166.173 I1.981 J.721 E.02119
G1 X182.938 Y166.726 E.01756
G1 X183.275 Y167.184 E.01747
G1 X183.629 Y167.419 E.01305
G1 X184.033 Y167.543 E.01299
G1 X184.453 Y167.53 E.01291
G1 X184.897 Y167.402 E.01421
G1 X185.226 Y167.187 E.01206
G1 X185.497 Y166.848 E.01334
G1 X185.662 Y166.467 E.01275
G1 X185.706 Y166.024 E.01368
G1 X185.562 Y165.474 E.01747
G1 X185.223 Y165.014 E.01755
G1 X184.884 Y164.785 E.01258
G1 X184.466 Y164.663 E.0134
G1 X184.047 Y164.654 E.01287
G1 X183.657 Y164.774 E.01255
G2 X183.213 Y165.086 I1.286 J2.292 E.0167
M204 S10000
G1 X183.362 Y165.514 F60000
G1 F3130
M204 S8000
G1 X183.201 Y165.842 E.01122
G1 X183.174 Y166.151 E.00953
G1 X183.278 Y166.564 E.01307
G1 X183.531 Y166.901 E.01294
G1 X183.792 Y167.074 E.00965
G1 X184.191 Y167.174 E.01262
G1 X184.642 Y167.106 E.01402
G1 X184.973 Y166.905 E.01189
G1 X185.223 Y166.574 E.01275
G1 X185.309 Y166.203 E.01168
G2 X184.967 Y165.296 I-1.107 J-.101 E.03083
G1 X184.614 Y165.087 E.0126
G1 X184.305 Y165.02 E.00972
G1 X183.897 Y165.077 E.01266
G1 X183.574 Y165.278 E.01168
G1 X183.402 Y165.47 E.00793
M204 S10000
G1 X183.667 Y165.736 F60000
G1 F3130
M204 S8000
G1 X183.569 Y165.966 E.00769
G2 X183.654 Y166.457 I.813 J.112 E.01555
G1 X183.875 Y166.677 E.00959
G1 X184.166 Y166.795 E.00964
G1 X184.521 Y166.746 E.01103
G1 X184.769 Y166.57 E.00932
G1 X184.921 Y166.299 E.00955
G1 X184.934 Y166.167 E.00409
G1 X184.896 Y165.829 E.01046
G1 X184.71 Y165.578 E.00958
G1 X184.435 Y165.422 E.00972
G1 X184.153 Y165.404 E.0087
G1 X183.917 Y165.484 E.00765
G1 X183.709 Y165.693 E.00905
M204 S10000
G1 X184.004 Y166.021 F60000
; LINE_WIDTH: 0.54143
G1 F3130
M204 S8000
G1 X184.018 Y166.211 E.00772
G1 X184.177 Y166.34 E.00833
G1 X184.388 Y166.324 E.00861
G1 X184.492 Y166.193 E.00678
G2 X184.482 Y165.989 I-.464 J-.08 E.00833
G1 X184.317 Y165.847 E.00885
G1 X184.145 Y165.864 E.00704
G1 X184.044 Y165.976 E.00616
; COOLING_NODE: 2
; WIPE_START
G1 F7221.52
G1 X184.145 Y165.864 E-.07581
G1 X184.317 Y165.847 E-.08662
G1 X184.482 Y165.989 E-.10891
G1 X184.492 Y166.193 E-.10164
G1 X184.388 Y166.324 E-.08344
G1 X184.177 Y166.34 E-.10599
G1 X184.018 Y166.211 E-.10251
G1 X184.004 Y166.021 E-.09506
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X179.498 Y165.248 Z4.2 F60000
G1 Z3.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F3130
M204 S8000
G1 X178.702 Y165.248 E.0264
G1 X178.702 Y164.452 E.0264
G1 X179.498 Y164.452 E.0264
G1 X179.498 Y165.188 E.02441
; COOLING_NODE: 2
M204 S250
G1 X179.89 Y165.64 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2802
M204 S5000
G1 X178.31 Y165.64 E.04855
G1 X178.31 Y164.06 E.04855
G1 X179.89 Y164.06 E.04855
G1 X179.89 Y165.58 E.04671
; COOLING_NODE: 2
; WIPE_START
G1 F9547.055
M204 S8000
G1 X178.31 Y165.64 E-.60084
G1 X178.31 Y165.221 E-.15917
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X170.678 Y165.247 Z4.2 F60000
G1 X170.502 Y165.248 Z4.2
G1 Z3.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F3130
M204 S8000
G1 X170.502 Y164.452 E.0264
G1 X171.298 Y164.452 E.0264
G1 X171.298 Y165.248 E.0264
G1 X170.562 Y165.248 E.02441
; COOLING_NODE: 2
M204 S250
G1 X170.11 Y165.64 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2802
M204 S5000
G1 X170.11 Y164.06 E.04855
G1 X171.69 Y164.06 E.04855
G1 X171.69 Y165.64 E.04855
G1 X170.17 Y165.64 E.04671
; COOLING_NODE: 4
; WIPE_START
G1 F9547.055
M204 S8000
G1 X170.11 Y164.06 E-.60084
G1 X170.529 Y164.06 E-.15917
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X167.848 Y165.336 Z4.2 F60000
G1 Z3.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F3130
M204 S8000
G3 X165.761 Y163.867 I-2.098 J.763 E.37526
G1 X165.865 Y163.87 E.00345
G3 X167.827 Y165.28 I-.115 J2.23 E.0847
; COOLING_NODE: 4
M204 S10000
G1 X168.232 Y165.197 F60000
G1 F3130
M204 S8000
G3 X165.764 Y163.46 I-2.481 J.903 E.44369
G1 X165.887 Y163.463 E.00407
G3 X168.21 Y165.141 I-.136 J2.637 E.1005
; COOLING_NODE: 4
M204 S10000
G1 X168.607 Y165.04 F60000
G1 F3130
M204 S8000
G1 X168.615 Y165.057 E.00063
G3 X165.767 Y163.052 I-2.863 J1.042 E.51213
G1 X165.908 Y163.056 E.00469
G3 X168.498 Y164.779 I-.157 J3.043 E.10825
G1 X168.584 Y164.985 E.00741
; COOLING_NODE: 4
M204 S250
G1 X168.968 Y164.888 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2748
M204 S5000
G1 X168.984 Y164.923 E.00119
G3 X165.77 Y162.66 I-3.232 J1.177 E.53544
G1 X165.93 Y162.665 E.00491
G3 X168.852 Y164.609 I-.177 J3.435 E.11319
G1 X168.945 Y164.833 E.00744
; WIPE_START
G1 F9547.055
M204 S8000
G1 X168.984 Y164.923 E-.03745
G1 X169.088 Y165.269 E-.13723
G1 X169.148 Y165.562 E-.1137
G1 X169.185 Y165.921 E-.13695
G1 X169.185 Y166.28 E-.13644
G1 X169.148 Y166.638 E-.13706
G1 X169.116 Y166.796 E-.06117
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X165.982 Y165.989 Z4.2 F60000
G1 Z3.8
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.54133
G1 F3130
M204 S8000
G1 X165.817 Y165.847 E.00885
G1 X165.645 Y165.864 E.00706
G1 X165.504 Y166.021 E.00858
G1 X165.524 Y166.235 E.00872
G1 X165.628 Y166.323 E.00554
G1 X165.801 Y166.344 E.00705
G1 X165.947 Y166.273 E.00663
G1 X165.998 Y166.124 E.00637
G1 X165.989 Y166.049 E.00309
M204 S10000
G1 X166.396 Y165.829 F60000
; LINE_WIDTH: 0.41999
G1 F3130
M204 S8000
G1 X166.21 Y165.578 E.00959
G1 X165.935 Y165.422 E.00972
G1 X165.653 Y165.404 E.0087
G1 X165.417 Y165.484 E.00766
G1 X165.167 Y165.736 E.01088
G1 X165.069 Y165.966 E.00768
G1 X165.086 Y166.285 E.00981
G1 X165.193 Y166.523 E.00802
G1 X165.409 Y166.712 E.00885
G1 X165.757 Y166.8 E.011
G1 X166.112 Y166.703 E.01133
G1 X166.341 Y166.474 E.00994
G1 X166.427 Y166.235 E.00781
G2 X166.403 Y165.888 I-.829 J-.115 E.01075
M204 S10000
G1 X166.688 Y165.565 F60000
G1 F3130
M204 S8000
G1 X166.467 Y165.296 E.0107
G1 X166.114 Y165.087 E.0126
G1 X165.805 Y165.02 E.00971
G1 X165.397 Y165.077 E.01266
G1 X165.074 Y165.278 E.01168
G1 X164.862 Y165.515 E.00978
G1 X164.701 Y165.842 E.01121
G1 X164.674 Y166.151 E.00954
G1 X164.787 Y166.583 E.01372
G1 X164.947 Y166.825 E.00888
G1 X165.251 Y167.058 E.01179
G1 X165.694 Y167.174 E.01408
G1 X166.142 Y167.106 E.01392
G1 X166.474 Y166.904 E.01195
G1 X166.722 Y166.574 E.01269
G1 X166.809 Y166.203 E.01169
G2 X166.706 Y165.622 I-1.135 J-.099 E.01835
M204 S10000
G1 X167.062 Y165.474 F60000
G1 F3130
M204 S8000
G1 X166.723 Y165.014 E.01756
G1 X166.384 Y164.785 E.01257
G1 X165.966 Y164.663 E.01339
G1 X165.547 Y164.654 E.01287
G1 X165.156 Y164.774 E.01255
G2 X164.667 Y165.125 I1.441 J2.526 E.01854
G1 X164.42 Y165.498 E.01376
G2 X164.294 Y166.173 I1.981 J.721 E.02119
G1 X164.384 Y166.613 E.0138
G1 X164.588 Y166.973 E.01272
G1 X164.869 Y167.265 E.01246
G1 X165.234 Y167.448 E.01252
G1 X165.674 Y167.551 E.01391
G1 X166.117 Y167.496 E.01371
G1 X166.502 Y167.352 E.01263
G1 X166.825 Y167.079 E.01299
G1 X167.064 Y166.739 E.01277
G2 X167.185 Y166.24 I-.909 J-.484 E.01593
G1 X167.206 Y166.024 E.00666
G1 X167.077 Y165.532 E.01562
M204 S10000
G1 X167.329 Y165.157 F60000
G1 F3130
M204 S8000
G1 X166.98 Y164.732 E.0169
G1 X166.558 Y164.448 E.01562
G1 X166.063 Y164.297 E.0159
G1 X165.662 Y164.271 E.01237
G1 X165.147 Y164.362 E.01605
G1 X164.808 Y164.52 E.01149
G1 X164.384 Y164.869 E.0169
G1 X164.079 Y165.331 E.01698
G1 X163.958 Y165.685 E.0115
G1 X163.913 Y166.195 E.01574
G1 X164.024 Y166.734 E.01689
G1 X164.283 Y167.195 E.01627
G1 X164.641 Y167.567 E.01586
G1 X164.934 Y167.748 E.0106
G1 X165.467 Y167.918 E.01717
G1 X165.842 Y167.937 E.01153
G1 X166.384 Y167.826 E.017
G1 X166.847 Y167.566 E.01633
G1 X167.217 Y167.21 E.0158
G1 X167.462 Y166.747 E.01608
G2 X167.56 Y166.277 I-.866 J-.426 E.01492
G1 X167.586 Y166.004 E.00841
G1 X167.476 Y165.466 E.01686
G1 X167.355 Y165.211 E.00869
; CHANGE_LAYER
; Z_HEIGHT: 4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9547.299
G1 X167.476 Y165.466 E-.10744
G1 X167.586 Y166.004 E-.20857
G1 X167.56 Y166.277 E-.10396
G1 X167.533 Y166.551 E-.10496
G1 X167.462 Y166.747 E-.07905
G1 X167.27 Y167.11 E-.15601
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 24/85
; update layer progress
M73 L24
M991 S0 P23 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 5
M204 S10000
G17
G3 Z4.2 I1.216 J.057 P1  F60000
G1 X167.898 Y153.648 Z4.2
G1 Z4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2580
M204 S8000
G1 X162.702 Y153.648 E.17236
G1 X162.702 Y152.852 E.0264
G1 X167.898 Y152.852 E.17236
G1 X167.898 Y153.588 E.02441
; COOLING_NODE: 5
M204 S250
G1 X168.29 Y154.04 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2580
M204 S5000
G1 X162.31 Y154.04 E.18375
G1 X162.31 Y152.46 E.04855
G1 X168.29 Y152.46 E.18375
G1 X168.29 Y153.98 E.04671
M204 S10000
G1 X167.694 Y153.25 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F2580
M204 S8000
G1 X162.906 Y153.25 E.15172
; COOLING_NODE: 4
; WIPE_START
G1 F9259.259
G1 X164.906 Y153.25 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X166.704 Y160.668 Z4.4 F60000
G1 X167.82 Y165.27 Z4.4
G1 Z4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2580
M204 S8000
G1 X167.916 Y165.56 E.01013
G3 X165.984 Y168.321 I-2.167 J.54 E.12669
G3 X165.864 Y163.87 I-.233 J-2.221 E.24424
G3 X167.799 Y165.214 I-.115 J2.23 E.08232
; COOLING_NODE: 4
M204 S10000
G1 X168.232 Y165.197 F60000
M73 P58 R6
G1 F2580
M204 S8000
G3 X165.773 Y163.46 I-2.481 J.903 E.44396
G1 X165.886 Y163.463 E.00376
G3 X168.211 Y165.141 I-.135 J2.637 E.10055
; COOLING_NODE: 4
M204 S10000
G1 X168.606 Y165.039 F60000
G1 F2580
M204 S8000
G1 X168.616 Y165.058 E.00068
G3 X165.776 Y163.052 I-2.863 J1.042 E.51241
G1 X165.908 Y163.056 E.00438
G3 X168.491 Y164.764 I-.156 J3.043 E.10773
G1 X168.583 Y164.984 E.00792
; COOLING_NODE: 4
M204 S250
G1 X168.961 Y164.888 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2580
M204 S5000
G1 X169.087 Y165.268 E.01229
G3 X166.11 Y169.521 I-3.338 J.832 E.18076
G3 X165.929 Y162.665 I-.359 J-3.421 E.34857
G3 X168.916 Y164.757 I-.181 J3.435 E.11808
G1 X168.941 Y164.831 E.00242
; WIPE_START
G1 F9547.055
M204 S8000
G1 X169.087 Y165.268 E-.17478
G1 X169.156 Y165.621 E-.13679
G1 X169.185 Y165.919 E-.11401
G1 X169.171 Y166.459 E-.20521
G1 X169.118 Y166.795 E-.12921
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X165.957 Y165.956 Z4.4 F60000
G1 Z4
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.54089
G1 F2580
M204 S8000
G1 X165.84 Y165.854 E.00629
G1 X165.677 Y165.861 E.00663
G1 X165.534 Y165.97 E.00729
G1 X165.505 Y166.157 E.00768
G1 X165.599 Y166.314 E.00745
G1 X165.79 Y166.347 E.00786
G1 X165.958 Y166.249 E.00787
G1 X166.006 Y166.159 E.00416
G1 X165.971 Y166.014 E.00603
M204 S10000
G1 X166.405 Y165.857 F60000
; LINE_WIDTH: 0.41999
G1 F2580
M204 S8000
G1 X166.209 Y165.571 E.01065
G1 X165.934 Y165.422 E.00961
G1 X165.687 Y165.402 E.00761
G1 X165.371 Y165.527 E.01046
G1 X165.155 Y165.742 E.00937
G1 X165.056 Y166.059 E.01021
G1 X165.122 Y166.377 E.00997
G1 X165.25 Y166.591 E.00767
G1 X165.435 Y166.725 E.00701
G1 X165.757 Y166.8 E.01016
G1 X166.089 Y166.698 E.01067
G1 X166.322 Y166.503 E.00935
G1 X166.44 Y166.222 E.00937
G1 X166.411 Y165.917 E.00942
M204 S10000
G1 X166.612 Y165.47 F60000
G1 F2580
M204 S8000
G1 X166.402 Y165.236 E.00966
G1 X166.031 Y165.055 E.01267
G1 X165.625 Y165.028 E.01252
G1 X165.295 Y165.125 E.01057
G2 X164.828 Y165.546 I.46 J.979 E.01959
G1 X164.684 Y165.943 E.01297
G1 X164.706 Y166.358 E.01278
G1 X164.9 Y166.764 E.01383
G1 X165.098 Y166.963 E.00862
G1 X165.437 Y167.12 E.01148
G1 X165.785 Y167.179 E.01086
G1 X166.118 Y167.111 E.01044
G1 X166.402 Y166.957 E.00992
G1 X166.678 Y166.645 E.01282
G1 X166.801 Y166.355 E.00967
G1 X166.813 Y166.277 E.00242
G1 X166.792 Y165.818 E.01412
G1 X166.64 Y165.523 E.01019
M204 S10000
G1 X167.066 Y165.469 F60000
G1 F2580
M204 S8000
G1 X166.828 Y165.116 E.01308
G1 X166.507 Y164.859 E.01266
G1 X166.128 Y164.689 E.01277
G1 X165.706 Y164.646 E.01301
G2 X165.134 Y164.779 I.425 J3.133 E.01809
G1 X164.777 Y165.016 E.01315
G1 X164.501 Y165.349 E.01331
G1 X164.311 Y165.888 E.01754
G1 X164.336 Y166.451 E.01733
G1 X164.515 Y166.878 E.01424
G1 X164.871 Y167.267 E.01617
G1 X165.126 Y167.42 E.00914
G1 X165.532 Y167.543 E.01303
G2 X166.248 Y167.469 I.14 J-2.147 E.02224
G1 X166.63 Y167.263 E.01333
G1 X166.92 Y166.973 E.01261
G1 X167.13 Y166.556 E.01433
G1 X167.186 Y166.332 E.00709
G1 X167.177 Y165.877 E.01398
G1 X167.082 Y165.527 E.01114
M204 S10000
G1 X167.405 Y165.297 F60000
G1 F2580
M204 S8000
G1 X167.116 Y164.869 E.01586
G1 X166.725 Y164.55 E.01551
G1 X166.225 Y164.322 E.01689
G1 X165.69 Y164.27 E.01651
G2 X164.973 Y164.434 I.314 J3.024 E.02266
G1 X164.522 Y164.732 E.01661
G1 X164.174 Y165.153 E.01678
G1 X163.963 Y165.665 E.017
G1 X163.914 Y165.999 E.01039
G1 X163.966 Y166.544 E.01683
G1 X164.186 Y167.067 E.01742
G1 X164.516 Y167.453 E.0156
G1 X164.972 Y167.767 E.01701
G1 X165.466 Y167.918 E.01587
G1 X165.842 Y167.937 E.01157
G1 X166.379 Y167.827 E.01684
G1 X166.858 Y167.568 E.01673
G1 X167.219 Y167.207 E.01569
G1 X167.467 Y166.733 E.01645
G1 X167.559 Y166.387 E.01099
G2 X167.534 Y165.65 I-3.366 J-.254 E.02269
G1 X167.425 Y165.353 E.00972
; COOLING_NODE: 2
; WIPE_START
G1 F9547.299
G1 X167.534 Y165.65 E-.12021
G1 X167.565 Y165.975 E-.12391
G1 X167.559 Y166.387 E-.15658
G1 X167.467 Y166.733 E-.13594
G1 X167.219 Y167.207 E-.20347
G1 X167.182 Y167.244 E-.01989
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X170.502 Y165.248 Z4.4 F60000
G1 Z4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2580
M204 S8000
G1 X170.502 Y164.852 E.01313
G1 X170.502 Y164.452 E.01327
G1 X170.918 Y164.452 E.01378
G1 X171.318 Y164.452 E.01327
G1 F2364.214
G1 X171.718 Y164.452 E.01327
G1 F1800
G1 X172.1 Y164.452 E.01269
; FEATURE: Overhang wall
G1 F3000
M204 S5000
G1 X177.9 Y164.452 E.1924
; FEATURE: Inner wall
G1 F1800
M204 S8000
G1 X178.283 Y164.452 E.01269
G1 F2364.214
G1 X178.683 Y164.452 E.01327
G1 F2580
G1 X179.083 Y164.452 E.01327
G1 X179.498 Y164.452 E.01378
G1 X179.498 Y164.852 E.01327
G1 X179.498 Y165.248 E.01313
G1 X179.083 Y165.248 E.01378
G1 X178.683 Y165.248 E.01327
G1 F2364.214
G1 X178.283 Y165.248 E.01327
G1 F1800
G1 X177.9 Y165.248 E.01269
; FEATURE: Overhang wall
G1 F3000
M204 S5000
G1 X172.1 Y165.248 E.1924
; FEATURE: Inner wall
G1 F1800
M204 S8000
G1 X171.718 Y165.248 E.01269
G1 F2364.214
G1 X171.318 Y165.248 E.01327
G1 F2580
G1 X170.918 Y165.248 E.01327
G1 X170.562 Y165.248 E.01179
; COOLING_NODE: 2
M204 S250
G1 X170.11 Y165.64 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2580
M204 S5000
G1 X170.11 Y165.26 E.01168
G1 X170.11 Y164.86 E.01229
G1 X170.11 Y164.46 E.01229
G1 X170.11 Y164.06 E.01229
G1 X170.531 Y164.06 E.01294
G1 X170.931 Y164.06 E.01229
G1 X171.331 Y164.06 E.01229
G1 F2364.214
G1 X171.731 Y164.06 E.01229
G1 F1800
G1 X172.1 Y164.06 E.01134
; FEATURE: Overhang wall
; LINE_WIDTH: 0.45
G1 F3000
G1 X177.9 Y164.06 E.1924
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1800
G1 X178.269 Y164.06 E.01134
G1 F2364.214
G1 X178.669 Y164.06 E.01229
G1 F2580
G1 X179.069 Y164.06 E.01229
G1 X179.469 Y164.06 E.01229
G1 X179.89 Y164.06 E.01294
G1 X179.89 Y164.46 E.01229
G1 X179.89 Y164.86 E.01229
G1 X179.89 Y165.24 E.01168
G1 X179.89 Y165.64 E.01229
G1 X179.469 Y165.64 E.01294
G1 X179.069 Y165.64 E.01229
G1 X178.669 Y165.64 E.01229
G1 F2364.214
G1 X178.269 Y165.64 E.01229
G1 F1800
G1 X177.9 Y165.64 E.01134
; FEATURE: Overhang wall
; LINE_WIDTH: 0.45
G1 F3000
G1 X172.1 Y165.64 E.1924
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1800
G1 X171.731 Y165.64 E.01134
G1 F2364.214
G1 X171.331 Y165.64 E.01229
G1 F2580
G1 X170.931 Y165.64 E.01229
G1 X170.531 Y165.64 E.01229
G1 X170.17 Y165.64 E.01109
M204 S10000
G1 X170.706 Y164.85 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F2580
M204 S8000
G1 X179.294 Y164.85 E.27211
; COOLING_NODE: 1
; WIPE_START
G1 F9259.259
G1 X177.294 Y164.85 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X182.042 Y165.832 Z4.4 F60000
G1 Z4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2580
M204 S8000
G1 X182.083 Y165.566 E.00894
G3 X184.269 Y163.867 I2.168 J.534 E.09907
G1 X184.364 Y163.87 E.00315
G3 X182.021 Y165.984 I-.113 J2.23 E.34914
G1 X182.034 Y165.892 E.00308
; COOLING_NODE: 1
M204 S10000
G1 X181.641 Y165.774 F60000
G1 F2580
M204 S8000
G1 X181.689 Y165.465 E.01035
G3 X184.273 Y163.46 I2.563 J.634 E.11703
G1 X184.386 Y163.463 E.00376
G3 X181.615 Y165.962 I-.135 J2.637 E.41278
G1 X181.633 Y165.833 E.00432
; COOLING_NODE: 1
M204 S10000
G1 X181.235 Y165.672 F60000
G1 F2580
M204 S8000
G1 X181.242 Y165.624 E.00163
G3 X184.276 Y163.052 I3.01 J.476 E.14374
G1 X184.408 Y163.056 E.00438
G3 X181.209 Y165.941 I-.156 J3.043 E.47641
G1 X181.229 Y165.732 E.00697
; COOLING_NODE: 1
M204 S250
G1 X180.845 Y165.632 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2580
M204 S5000
G1 X180.853 Y165.562 E.00214
G3 X184.429 Y162.665 I3.398 J.538 E.15492
G3 X184.61 Y169.521 I-.181 J3.435 E.31541
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G3 X180.816 Y165.921 I-.359 J-3.421 E.18258
G1 X180.839 Y165.691 E.00708
; WIPE_START
G1 F9547.055
M204 S8000
G1 X180.853 Y165.562 E-.04926
G1 X180.912 Y165.268 E-.11401
G1 X181.017 Y164.924 E-.13692
G1 X181.213 Y164.485 E-.18259
G1 X181.398 Y164.177 E-.13652
G1 X181.595 Y163.912 E-.12537
G1 X181.623 Y163.883 E-.01533
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X184.034 Y165.97 Z4.4 F60000
G1 Z4
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.54127
G1 F2580
M204 S8000
G1 X183.99 Y166.106 E.00581
G1 X184.093 Y166.312 E.00932
G1 X184.3 Y166.344 E.00852
G1 X184.443 Y166.277 E.00642
G2 X184.492 Y166.007 I-.224 J-.179 E.0116
G1 X184.352 Y165.858 E.00828
G1 X184.18 Y165.861 E.007
G1 X184.082 Y165.934 E.00495
M204 S10000
G1 X183.655 Y165.742 F60000
; LINE_WIDTH: 0.41999
G1 F2580
M204 S8000
G1 X183.548 Y166.061 E.01032
G1 X183.627 Y166.411 E.01103
G1 X183.828 Y166.663 E.0099
G1 X184.171 Y166.795 E.01129
G1 X184.521 Y166.746 E.01087
G1 X184.766 Y166.573 E.0092
G1 X184.928 Y166.289 E.01005
G1 X184.926 Y165.949 E.01044
G1 X184.864 Y165.776 E.00562
G1 X184.672 Y165.538 E.00942
G1 X184.434 Y165.422 E.00812
G1 X184.187 Y165.402 E.00761
G1 X183.871 Y165.527 E.01046
G1 X183.697 Y165.7 E.00752
M204 S10000
G1 X183.43 Y165.422 F60000
G1 F2580
M204 S8000
G1 X183.266 Y165.696 E.00982
G1 X183.17 Y166.043 E.01107
G1 X183.235 Y166.419 E.01174
G1 X183.368 Y166.701 E.00958
G1 X183.6 Y166.965 E.01079
G2 X184.285 Y167.179 I.768 J-1.255 E.02227
G1 X184.735 Y167.062 E.01428
G1 X184.973 Y166.905 E.00876
G1 X185.229 Y166.56 E.0132
G1 X185.327 Y166.18 E.01205
G2 X185.228 Y165.642 I-1.631 J.02 E.01691
G1 X184.963 Y165.293 E.01345
G1 X184.728 Y165.129 E.00881
G1 X184.305 Y165.02 E.01344
G1 X183.947 Y165.08 E.01116
G1 X183.662 Y165.212 E.00963
G1 X183.475 Y165.381 E.00775
M204 S10000
G1 X183.001 Y165.349 F60000
G1 F2580
M204 S8000
G1 X182.829 Y165.765 E.01383
G1 X182.798 Y166.157 E.01207
G2 X182.941 Y166.742 I3.022 J-.428 E.01852
G1 X183.171 Y167.083 E.01266
G1 X183.469 Y167.327 E.01181
G1 X183.902 Y167.501 E.01435
G1 X184.313 Y167.558 E.01277
G1 X184.763 Y167.466 E.01409
G1 X185.121 Y167.264 E.01264
G1 X185.414 Y166.982 E.0125
G1 X185.616 Y166.6 E.01329
G1 X185.706 Y166.192 E.01282
G2 X185.566 Y165.469 I-2.194 J.05 E.02274
G1 X185.329 Y165.117 E.01307
G1 X185.007 Y164.858 E.01268
G1 X184.628 Y164.689 E.01276
G1 X184.206 Y164.646 E.01301
G2 X183.633 Y164.779 I.425 J3.137 E.0181
G1 X183.277 Y165.016 E.01314
G1 X183.039 Y165.303 E.01147
M204 S10000
G1 X182.674 Y165.153 F60000
G1 F2580
M204 S8000
G1 X182.463 Y165.665 E.017
G1 X182.421 Y166.177 E.01579
G1 X182.432 Y166.381 E.0063
G1 X182.598 Y166.907 E.01693
G1 X182.883 Y167.331 E.01571
G1 X183.271 Y167.648 E.01538
G2 X183.967 Y167.918 I1.482 J-2.791 E.02299
G1 X184.342 Y167.937 E.01154
G1 X184.883 Y167.826 E.01699
G1 X185.345 Y167.567 E.01627
G1 X185.717 Y167.21 E.01586
G1 X185.968 Y166.736 E.01646
G1 X186.086 Y166.204 E.01675
G2 X185.968 Y165.47 I-2.931 J.095 E.02292
G2 X185.616 Y164.869 I-2.625 J1.132 E.02145
G1 X185.223 Y164.548 E.01561
G1 X184.725 Y164.322 E.0168
G1 X184.19 Y164.27 E.01652
G2 X183.472 Y164.434 I.314 J3.024 E.02266
G1 X183.022 Y164.732 E.0166
G1 X182.712 Y165.107 E.01494
; COOLING_NODE: 5
; WIPE_START
G1 F9547.299
G1 X183.022 Y164.732 E-.18477
G1 X183.472 Y164.434 E-.20531
G1 X183.817 Y164.332 E-.13636
G1 X184.19 Y164.27 E-.14372
G1 X184.425 Y164.293 E-.08984
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X182.798 Y156.836 Z4.4 F60000
G1 X182.102 Y153.648 Z4.4
G1 Z4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2580
M204 S8000
G1 X182.102 Y152.852 E.0264
G1 X187.298 Y152.852 E.17236
G1 X187.298 Y153.648 E.0264
G1 X182.162 Y153.648 E.17037
; COOLING_NODE: 5
M204 S250
G1 X181.71 Y154.04 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2580
M204 S5000
G1 X181.71 Y152.46 E.04855
G1 X187.69 Y152.46 E.18375
G1 X187.69 Y154.04 E.04855
G1 X181.77 Y154.04 E.18191
M204 S10000
G1 X182.306 Y153.25 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F2580
M204 S8000
G1 X187.094 Y153.25 E.15172
; CHANGE_LAYER
; Z_HEIGHT: 4.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.259
G1 X185.094 Y153.25 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 25/85
; update layer progress
M73 L25
M991 S0 P24 ;notify layer change

; OBJECT_ID: 15
M204 S10000
G17
G3 Z4.4 I.23 J-1.195 P1  F60000
G1 X181.131 Y152.487 Z4.4
G1 Z4.2
G1 E.8 F1800
; FEATURE: Support interface
; LINE_WIDTH: 0.42
G1 F2992
M204 S8000
G1 X180.662 Y152.018 E.02037
G1 X179.422 Y152.018 E.03811
G1 X180.962 Y153.558 E.0669
G1 X180.97 Y154.482 E.02838
G1 X180.645 Y154.482 E.00999
G1 X178.182 Y152.018 E.10703
G1 X176.941 Y152.018 E.03811
G1 X179.404 Y154.482 E.10703
G1 X178.164 Y154.482 E.03811
G1 X175.701 Y152.018 E.10703
G1 X174.461 Y152.018 E.03811
G1 X176.924 Y154.482 E.10703
G1 X175.683 Y154.482 E.03811
G1 X173.22 Y152.018 E.10703
G1 X171.98 Y152.018 E.03811
G1 X174.443 Y154.482 E.10703
G1 X173.203 Y154.482 E.03811
G1 X170.74 Y152.018 E.10703
G1 X169.499 Y152.018 E.03811
G1 X171.962 Y154.482 E.10703
G1 X170.722 Y154.482 E.03811
G1 X169.038 Y152.798 E.07316
G1 X169.038 Y154.038 E.03811
G1 X169.651 Y154.651 E.02663
; COOLING_NODE: 5
; WIPE_START
G1 F4800
G1 X169.038 Y154.038 E-.32933
G1 X169.038 Y152.905 E-.43067
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z4.6 I-.664 J-1.02 P1  F60000
G1 X167.898 Y153.648 Z4.6
G1 Z4.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2992
M204 S8000
G1 X162.702 Y153.648 E.17236
G1 X162.702 Y152.852 E.0264
G1 X167.898 Y152.852 E.17236
G1 X167.898 Y153.588 E.02441
; COOLING_NODE: 5
M204 S250
G1 X168.29 Y154.04 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2677
M204 S5000
G1 X162.31 Y154.04 E.18375
G1 X162.31 Y152.46 E.04855
G1 X168.29 Y152.46 E.18375
G1 X168.29 Y153.98 E.04671
M204 S10000
M73 P59 R6
G1 X167.694 Y153.25 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F2992
M204 S8000
G1 X162.906 Y153.25 E.15172
; COOLING_NODE: 4
; WIPE_START
G1 F9259.259
G1 X164.906 Y153.25 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X166.709 Y160.666 Z4.6 F60000
G1 X167.835 Y165.299 Z4.6
G1 Z4.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2992
M204 S8000
G3 X165.777 Y163.867 I-2.085 J.8 E.37708
G1 X165.863 Y163.87 E.00286
G3 X167.813 Y165.244 I-.112 J2.23 E.08348
; COOLING_NODE: 4
M204 S10000
G1 X168.216 Y165.153 F60000
G1 F2992
M204 S8000
G3 X165.781 Y163.46 I-2.465 J.946 E.44579
G1 X165.885 Y163.463 E.00346
G3 X168.194 Y165.098 I-.134 J2.637 E.09903
; COOLING_NODE: 4
M204 S10000
G1 X168.597 Y165.007 F60000
G1 F2992
M204 S8000
G3 X165.785 Y163.053 I-2.845 J1.092 E.5145
G1 X165.908 Y163.056 E.00405
G3 X168.575 Y164.951 I-.155 J3.043 E.11457
; COOLING_NODE: 4
M204 S250
G1 X168.967 Y164.885 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2677
M204 S5000
G1 X169.075 Y165.21 E.0105
G3 X165.789 Y162.66 I-3.322 J.89 E.52679
G1 X165.929 Y162.665 E.0043
G3 X168.949 Y164.829 I-.176 J3.435 E.12058
; WIPE_START
G1 F9547.055
M204 S8000
G1 X169.075 Y165.21 E-.15252
G1 X169.138 Y165.503 E-.11385
G1 X169.18 Y165.839 E-.12895
G1 X169.189 Y166.16 E-.12212
G1 X169.164 Y166.519 E-.13668
G1 X169.118 Y166.794 E-.10588
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X165.944 Y165.931 Z4.6 F60000
G1 Z4.2
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.54128
G1 F2992
M204 S8000
G1 X165.758 Y165.837 E.00846
G1 X165.626 Y165.88 E.00564
G1 X165.497 Y166.029 E.00801
G1 X165.519 Y166.225 E.00801
G1 X165.732 Y166.363 E.01032
G1 X165.915 Y166.29 E.00801
G1 X166.013 Y166.116 E.00811
G2 X165.97 Y165.985 I-.167 J-.018 E.00575
M204 S10000
G1 X166.249 Y165.609 F60000
; LINE_WIDTH: 0.41999
G1 F2992
M204 S8000
G1 X165.934 Y165.422 E.01125
G1 X165.653 Y165.404 E.00864
G1 X165.392 Y165.508 E.00865
G1 X165.159 Y165.747 E.01023
G1 X165.065 Y165.957 E.00708
G1 X165.067 Y166.255 E.00918
G1 X165.201 Y166.534 E.0095
G1 X165.477 Y166.731 E.01041
G1 X165.745 Y166.8 E.00851
G1 X166.032 Y166.735 E.00905
G1 X166.272 Y166.547 E.00936
G1 X166.435 Y166.248 E.01044
G1 X166.449 Y166.06 E.00582
G2 X166.281 Y165.659 I-.849 J.122 E.01348
M204 S10000
G1 X166.562 Y165.394 F60000
G1 F2992
M204 S8000
G1 X166.202 Y165.119 E.01392
G1 X165.804 Y165.019 E.01259
G1 X165.397 Y165.077 E.01265
G1 X165.089 Y165.267 E.0111
G1 X164.872 Y165.5 E.00979
G1 X164.706 Y165.818 E.01103
G1 X164.676 Y166.23 E.01272
G1 X164.804 Y166.624 E.01272
G1 X165.058 Y166.908 E.01172
G1 X165.327 Y167.076 E.00974
G1 X165.675 Y167.179 E.01115
G1 X166.033 Y167.126 E.01112
G2 X166.726 Y166.523 I-.369 J-1.126 E.02899
G1 X166.829 Y166.175 E.01115
G2 X166.784 Y165.79 I-1.457 J-.025 E.01196
G1 X166.591 Y165.447 E.0121
M204 S10000
G1 X166.938 Y165.253 F60000
G1 F2992
M204 S8000
G1 X166.639 Y164.962 E.01281
G1 X166.24 Y164.731 E.01418
G1 X165.825 Y164.641 E.01303
G1 X165.384 Y164.693 E.01366
G1 X165.038 Y164.826 E.01139
G1 X164.684 Y165.106 E.01387
G1 X164.431 Y165.476 E.01377
G1 X164.314 Y165.877 E.01282
G1 X164.3 Y166.277 E.0123
G1 X164.422 Y166.692 E.0133
G1 X164.638 Y167.045 E.01271
G1 X164.978 Y167.336 E.01375
G1 X165.386 Y167.513 E.01369
G1 X165.765 Y167.554 E.01169
G2 X166.342 Y167.432 I-.35 J-3.08 E.01818
G1 X166.706 Y167.2 E.01325
G1 X166.986 Y166.872 E.01324
G1 X167.163 Y166.464 E.01369
G1 X167.203 Y166.04 E.01307
G1 X167.142 Y165.663 E.01173
G1 X166.965 Y165.306 E.01225
M204 S10000
G1 X167.254 Y165.042 F60000
G1 F2992
M204 S8000
G1 X167.008 Y164.758 E.01156
G1 X166.552 Y164.445 E.01697
G1 X166.066 Y164.297 E.01561
G1 X165.661 Y164.271 E.01248
G1 X165.151 Y164.361 E.01592
G1 X164.84 Y164.502 E.01048
G1 X164.405 Y164.846 E.01705
G1 X164.093 Y165.301 E.01694
G1 X163.942 Y165.815 E.01647
G1 X163.924 Y166.323 E.0156
G1 X164.066 Y166.818 E.01583
G2 X164.356 Y167.3 I2.366 J-1.096 E.01732
G1 X164.775 Y167.659 E.01697
G1 X165.279 Y167.878 E.01686
G1 X165.774 Y167.931 E.01531
G2 X166.497 Y167.78 I-.257 J-3.04 E.02276
G1 X166.956 Y167.487 E.01672
G1 X167.309 Y167.074 E.0167
G1 X167.528 Y166.571 E.01685
G1 X167.58 Y166.031 E.01669
G1 X167.501 Y165.537 E.01537
G1 X167.281 Y165.095 E.01515
; COOLING_NODE: 2
; WIPE_START
G1 F9547.299
G1 X167.501 Y165.537 E-.18734
G1 X167.58 Y166.031 E-.19003
G1 X167.528 Y166.571 E-.20646
G1 X167.343 Y166.997 E-.17616
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X170.502 Y165.248 Z4.6 F60000
G1 Z4.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2992
M204 S8000
G1 X170.502 Y164.452 E.0264
G1 X179.498 Y164.452 E.29841
G1 X179.498 Y165.248 E.0264
G1 X170.562 Y165.248 E.29642
; COOLING_NODE: 2
M204 S250
G1 X170.11 Y165.64 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2720
M204 S5000
G1 X170.11 Y164.06 E.04855
G1 X179.89 Y164.06 E.30051
G1 X179.89 Y165.64 E.04855
G1 X170.17 Y165.64 E.29867
M204 S10000
G1 X170.706 Y164.85 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F2992
M204 S8000
G1 X179.294 Y164.85 E.27211
; COOLING_NODE: 1
; WIPE_START
G1 F9259.259
G1 X177.294 Y164.85 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X182.051 Y165.76 Z4.6 F60000
G1 Z4.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2992
M204 S8000
G1 X182.065 Y165.642 E.00394
G3 X184.277 Y163.867 I2.185 J.458 E.10193
G1 X184.363 Y163.87 E.00286
G3 X182.018 Y166.061 I-.112 J2.23 E.34661
G1 X182.044 Y165.819 E.00806
; COOLING_NODE: 1
M204 S10000
G1 X181.648 Y165.715 F60000
G1 F2992
M204 S8000
G1 X181.668 Y165.556 E.00534
G3 X184.281 Y163.46 I2.583 J.544 E.12037
G1 X184.385 Y163.463 E.00346
G3 X181.612 Y166.054 I-.134 J2.637 E.40978
G1 X181.642 Y165.775 E.00929
; COOLING_NODE: 1
M204 S10000
G1 X181.227 Y165.717 F60000
G1 F2992
M204 S8000
G1 X181.271 Y165.469 E.00835
G3 X184.285 Y163.053 I2.981 J.63 E.13882
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X184.408 Y163.056 E.00405
G3 X181.222 Y165.777 I-.155 J3.043 E.48191
; COOLING_NODE: 1
M204 S250
G1 X180.84 Y165.653 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2677
M204 S5000
G1 X180.888 Y165.386 E.00833
G3 X184.289 Y162.66 I3.365 J.713 E.14504
G1 X184.429 Y162.665 E.0043
G3 X180.835 Y165.713 I-.176 J3.435 E.5045
; WIPE_START
G1 F9547.055
M204 S8000
G1 X180.888 Y165.386 E-.12575
G1 X180.978 Y165.037 E-.13683
G1 X181.099 Y164.72 E-.12906
G1 X181.241 Y164.432 E-.12205
G1 X181.433 Y164.126 E-.13713
G1 X181.608 Y163.898 E-.10919
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X182.593 Y165.301 Z4.6 F60000
G1 Z4.2
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F2992
M204 S8000
G1 X182.448 Y165.775 E.01522
G2 X182.458 Y166.514 I3.027 J.327 E.02276
G1 X182.657 Y167.019 E.01667
G1 X182.975 Y167.414 E.01558
G1 X183.299 Y167.663 E.01255
G1 X183.774 Y167.877 E.01599
G1 X184.274 Y167.931 E.01548
G2 X184.997 Y167.78 I-.256 J-3.033 E.02275
G1 X185.456 Y167.488 E.0167
G1 X185.809 Y167.075 E.01671
G1 X186.028 Y166.571 E.01685
G1 X186.079 Y166.039 E.01644
G1 X185.999 Y165.529 E.01586
G1 X185.847 Y165.188 E.01147
G1 X185.504 Y164.755 E.01696
G1 X185.052 Y164.445 E.01684
G1 X184.566 Y164.297 E.01561
G1 X184.162 Y164.271 E.01244
G1 X183.652 Y164.361 E.01592
G1 X183.325 Y164.51 E.01104
G1 X182.905 Y164.846 E.01652
G1 X182.627 Y165.252 E.01512
M204 S10000
G1 X182.931 Y165.476 F60000
G1 F2992
M204 S8000
G1 X182.82 Y165.837 E.0116
G2 X182.83 Y166.428 I3.106 J.243 E.01819
G1 X182.991 Y166.838 E.01352
G1 X183.256 Y167.16 E.01283
G1 X183.615 Y167.415 E.01351
G1 X184.034 Y167.538 E.01342
G1 X184.412 Y167.55 E.01164
G1 X184.842 Y167.432 E.01371
G1 X185.206 Y167.2 E.01324
G1 X185.486 Y166.872 E.01325
G1 X185.663 Y166.464 E.01369
G1 X185.702 Y166.042 E.01301
G1 X185.639 Y165.648 E.01227
G1 X185.522 Y165.385 E.00886
G1 X185.244 Y165.034 E.01375
G1 X184.877 Y164.782 E.01368
G1 X184.464 Y164.663 E.01321
G1 X184.047 Y164.653 E.0128
G1 X183.664 Y164.77 E.01231
G2 X183.184 Y165.105 I1.43 J2.555 E.01802
G1 X182.964 Y165.427 E.01197
M204 S10000
G1 X183.464 Y165.365 F60000
G1 F2992
M204 S8000
G1 X183.233 Y165.745 E.01368
G1 X183.175 Y166 E.00803
G1 X183.201 Y166.343 E.01056
G1 X183.385 Y166.741 E.01347
G1 X183.587 Y166.954 E.00903
G1 X183.969 Y167.145 E.01312
G1 X184.357 Y167.175 E.01194
G1 X184.687 Y167.083 E.01054
G2 X185.163 Y166.67 I-.443 J-.989 E.01963
G1 X185.316 Y166.256 E.01357
G2 X185.279 Y165.767 I-1.181 J-.159 E.01518
G1 X185.083 Y165.438 E.01176
G1 X184.849 Y165.22 E.00985
G1 X184.53 Y165.055 E.01102
G1 X184.1 Y165.029 E.01324
G1 X183.724 Y165.157 E.01223
G1 X183.511 Y165.327 E.00837
M204 S10000
G1 X183.636 Y165.781 F60000
G1 F2992
M204 S8000
G1 X183.554 Y166.017 E.00766
G1 X183.62 Y166.378 E.01128
G1 X183.752 Y166.591 E.00769
G1 X184.012 Y166.758 E.00951
G1 X184.301 Y166.799 E.00895
G1 X184.62 Y166.679 E.01046
G1 X184.839 Y166.468 E.00936
G1 X184.951 Y166.151 E.01034
G1 X184.948 Y166.064 E.00268
G1 X184.872 Y165.778 E.00907
G1 X184.635 Y165.531 E.01051
G1 X184.39 Y165.415 E.00836
G1 X184.096 Y165.417 E.00903
G1 X183.855 Y165.535 E.00824
G1 X183.676 Y165.737 E.00828
M204 S10000
G1 X184.067 Y165.926 F60000
; LINE_WIDTH: 0.5414
G1 F2992
M204 S8000
G1 X183.995 Y166.039 E.00547
G1 X184.053 Y166.273 E.00978
G1 X184.232 Y166.363 E.00815
G1 X184.415 Y166.29 E.008
G1 X184.512 Y166.119 E.00798
G1 X184.511 Y166.076 E.00176
G1 X184.422 Y165.915 E.00747
G1 X184.238 Y165.838 E.00809
G1 X184.121 Y165.898 E.00536
; COOLING_NODE: 5
; WIPE_START
G1 F7221.955
G1 X184.238 Y165.838 E-.0656
G1 X184.422 Y165.915 E-.09908
G1 X184.511 Y166.076 E-.09147
G1 X184.512 Y166.119 E-.02151
G1 X184.415 Y166.29 E-.09776
G1 X184.232 Y166.363 E-.09794
G1 X184.053 Y166.273 E-.09987
G1 X183.995 Y166.039 E-.11983
G1 X184.067 Y165.926 E-.06695
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X182.861 Y158.389 Z4.6 F60000
G1 X182.102 Y153.648 Z4.6
G1 Z4.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2992
M204 S8000
G1 X182.102 Y152.852 E.0264
G1 X187.298 Y152.852 E.17236
G1 X187.298 Y153.648 E.0264
G1 X182.162 Y153.648 E.17037
; COOLING_NODE: 5
M204 S250
G1 X181.71 Y154.04 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2677
M204 S5000
G1 X181.71 Y152.46 E.04855
G1 X187.69 Y152.46 E.18375
G1 X187.69 Y154.04 E.04855
G1 X181.77 Y154.04 E.18191
M204 S10000
G1 X182.306 Y153.25 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F2992
M204 S8000
G1 X187.094 Y153.25 E.15172
; CHANGE_LAYER
; Z_HEIGHT: 4.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.259
G1 X185.094 Y153.25 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 26/85
; update layer progress
M73 L26
M991 S0 P25 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 5
M204 S10000
G17
G3 Z4.6 I-.028 J-1.217 P1  F60000
G1 X167.898 Y153.648 Z4.6
G1 Z4.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2598
M204 S8000
G1 X162.702 Y153.648 E.17236
G1 X162.702 Y152.852 E.0264
G1 X167.898 Y152.852 E.17236
G1 X167.898 Y153.588 E.02441
; COOLING_NODE: 5
M204 S250
G1 X168.29 Y154.04 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2598
M204 S5000
G1 X162.31 Y154.04 E.18375
G1 X162.31 Y152.46 E.04855
G1 X168.29 Y152.46 E.18375
G1 X168.29 Y153.98 E.04671
M204 S10000
G1 X167.694 Y153.25 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F2598
M204 S8000
G1 X162.906 Y153.25 E.15172
; COOLING_NODE: 4
; WIPE_START
G1 F9259.259
G1 X164.906 Y153.25 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X166.708 Y160.667 Z4.8 F60000
G1 X167.833 Y165.294 Z4.8
G1 Z4.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2598
M204 S8000
G3 X165.785 Y163.867 I-2.083 J.806 E.37753
G1 X165.862 Y163.869 E.00258
G3 X167.811 Y165.238 I-.112 J2.23 E.08331
; COOLING_NODE: 4
M204 S10000
G1 X168.214 Y165.149 F60000
G1 F2598
M204 S8000
G3 X165.789 Y163.46 I-2.463 J.95 E.44622
G1 X165.885 Y163.463 E.00318
G3 X168.192 Y165.094 I-.134 J2.637 E.09889
; COOLING_NODE: 4
M204 S10000
G1 X168.596 Y165.009 F60000
M73 P60 R6
G1 F2598
M204 S8000
G1 X168.68 Y165.257 E.00869
G3 X165.794 Y163.053 I-2.928 J.843 E.50607
G1 X165.908 Y163.056 E.00377
G3 X168.575 Y164.953 I-.156 J3.043 E.1146
; COOLING_NODE: 4
M204 S250
G1 X168.967 Y164.884 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2598
M204 S5000
G1 X169.058 Y165.15 E.00864
G3 X165.799 Y162.66 I-3.306 J.949 E.529
G1 X165.929 Y162.665 E.00401
G3 X168.948 Y164.828 I-.177 J3.435 E.12052
; WIPE_START
G1 F9547.055
M204 S8000
G1 X169.058 Y165.15 E-.12955
G1 X169.138 Y165.503 E-.13744
G1 X169.182 Y165.86 E-.13659
G1 X169.189 Y166.16 E-.11395
G1 X169.164 Y166.519 E-.13703
G1 X169.116 Y166.793 E-.10544
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X166.001 Y166.022 Z4.8 F60000
G1 Z4.4
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.541345
G1 F2598
M204 S8000
G1 X165.883 Y165.886 E.0073
G1 X165.748 Y165.841 E.00581
G1 X165.544 Y165.942 E.00926
G1 X165.5 Y166.131 E.00786
G2 X165.712 Y166.359 I.287 J-.054 E.01333
G1 X165.869 Y166.324 E.00657
G1 X165.987 Y166.18 E.00753
G1 X165.996 Y166.081 E.00401
M204 S10000
G1 X166.365 Y165.76 F60000
; LINE_WIDTH: 0.41999
G1 F2598
M204 S8000
G1 X166.118 Y165.511 E.01078
G1 X165.782 Y165.398 E.01087
G1 X165.457 Y165.47 E.01024
G1 X165.182 Y165.684 E.01069
G1 X165.066 Y165.979 E.00976
G1 X165.088 Y166.283 E.00937
G1 X165.167 Y166.487 E.00672
G1 X165.442 Y166.732 E.01132
G1 X165.701 Y166.801 E.00824
G1 X166.013 Y166.747 E.00972
G1 X166.263 Y166.57 E.00941
G1 X166.402 Y166.319 E.00883
G1 X166.439 Y166.032 E.00889
G1 X166.381 Y165.818 E.00682
M204 S10000
G1 X166.581 Y165.411 F60000
G1 F2598
M204 S8000
G1 X166.32 Y165.187 E.01055
G1 X165.884 Y165.032 E.01422
G1 X165.625 Y165.027 E.00797
G1 X165.296 Y165.125 E.01054
G1 X164.925 Y165.407 E.01432
G2 X164.682 Y166.231 I.99 J.739 E.02698
G1 X164.818 Y166.638 E.01317
G1 X165.12 Y166.977 E.01392
G1 X165.47 Y167.145 E.01194
G1 X165.882 Y167.174 E.01269
G1 X166.272 Y167.044 E.01264
G1 X166.54 Y166.831 E.01053
G2 X166.816 Y166.041 I-.757 J-.707 E.02647
G1 X166.78 Y165.77 E.0084
G1 X166.61 Y165.463 E.0108
M204 S10000
G1 X166.953 Y165.286 F60000
G1 F2598
M204 S8000
G2 X166.522 Y164.864 I-2.263 J1.883 E.01857
G1 X166.113 Y164.686 E.01371
G1 X165.706 Y164.646 E.01257
G2 X165.134 Y164.779 I.423 J3.116 E.01805
G1 X164.759 Y165.029 E.01384
G1 X164.458 Y165.42 E.01518
G1 X164.315 Y165.847 E.01382
G1 X164.304 Y166.278 E.01326
G1 X164.422 Y166.705 E.01363
G1 X164.66 Y167.047 E.01279
G1 X165.01 Y167.352 E.01426
G1 X165.372 Y167.511 E.01214
G1 X165.796 Y167.553 E.01311
G1 X166.201 Y167.489 E.01259
G1 X166.469 Y167.369 E.00903
G1 X166.818 Y167.092 E.01368
G1 X167.049 Y166.762 E.01239
G1 X167.185 Y166.353 E.01324
G2 X167.141 Y165.654 I-2.258 J-.208 E.02163
G1 X166.981 Y165.339 E.01085
M204 S10000
G1 X167.357 Y165.205 F60000
G1 F2598
M204 S8000
G1 X167.144 Y164.9 E.01144
G1 X166.724 Y164.54 E.01697
G1 X166.219 Y164.321 E.01693
G1 X165.689 Y164.27 E.01637
G2 X164.973 Y164.433 I.341 J3.137 E.02261
G1 X164.512 Y164.74 E.01702
G1 X164.206 Y165.112 E.0148
G2 X163.939 Y165.78 I3.606 J1.825 E.02213
G1 X163.926 Y166.324 E.01673
G1 X164.071 Y166.852 E.01683
G1 X164.259 Y167.178 E.01155
G1 X164.647 Y167.571 E.01697
G1 X165.117 Y167.818 E.0163
G1 X165.622 Y167.935 E.01593
G1 X166.139 Y167.889 E.01595
G1 X166.666 Y167.694 E.01728
G1 X167.096 Y167.353 E.01684
G1 X167.389 Y166.933 E.01575
G1 X167.561 Y166.419 E.01665
G2 X167.534 Y165.685 I-3.042 J-.255 E.02264
G1 X167.378 Y165.261 E.01387
; COOLING_NODE: 2
; WIPE_START
G1 F9547.299
G1 X167.534 Y165.685 E-.17152
G1 X167.57 Y166.06 E-.14324
G1 X167.561 Y166.419 E-.1366
G1 X167.389 Y166.933 E-.20587
G1 X167.234 Y167.155 E-.10276
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X170.502 Y165.248 Z4.8 F60000
G1 Z4.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2598
M204 S8000
G1 X170.502 Y164.452 E.0264
G1 X179.498 Y164.452 E.29841
G1 X179.498 Y165.248 E.0264
G1 X170.562 Y165.248 E.29642
; COOLING_NODE: 2
M204 S250
G1 X170.11 Y165.64 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2598
M204 S5000
G1 X170.11 Y164.06 E.04855
G1 X179.89 Y164.06 E.30051
G1 X179.89 Y165.64 E.04855
G1 X170.17 Y165.64 E.29867
M204 S10000
G1 X170.706 Y164.85 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F2598
M204 S8000
G1 X179.294 Y164.85 E.27211
; COOLING_NODE: 1
; WIPE_START
G1 F9259.259
G1 X177.294 Y164.85 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X182.034 Y165.828 Z4.8 F60000
G1 Z4.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2598
M204 S8000
G3 X184.285 Y163.867 I2.216 J.272 E.10845
G1 X184.362 Y163.869 E.00258
G3 X182.028 Y165.887 I-.112 J2.23 E.35239
; COOLING_NODE: 1
M204 S10000
G1 X181.63 Y165.778 F60000
G1 F2598
M204 S8000
G3 X184.289 Y163.46 I2.62 J.322 E.12815
G1 X184.385 Y163.463 E.00318
G3 X181.624 Y165.838 I-.134 J2.637 E.41695
; COOLING_NODE: 1
M204 S10000
G1 X181.228 Y165.712 F60000
G1 F2598
M204 S8000
G1 X181.282 Y165.415 E.01001
G3 X184.294 Y163.053 I2.969 J.684 E.1373
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X184.408 Y163.056 E.00377
G3 X181.222 Y165.772 I-.156 J3.043 E.48205
; COOLING_NODE: 1
M204 S250
G1 X180.842 Y165.644 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2598
M204 S5000
G1 X180.9 Y165.327 E.0099
G3 X184.299 Y162.66 I3.352 J.772 E.14351
G1 X184.429 Y162.665 E.00401
G3 X180.835 Y165.704 I-.177 J3.435 E.50475
; WIPE_START
G1 F9547.055
M204 S8000
G1 X180.9 Y165.327 E-.14516
G1 X180.978 Y165.038 E-.11379
G1 X181.108 Y164.7 E-.13752
G1 X181.241 Y164.433 E-.11353
G1 X181.432 Y164.127 E-.13721
G1 X181.613 Y163.891 E-.11278
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X182.594 Y165.3 Z4.8 F60000
G1 Z4.4
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F2598
M204 S8000
G1 X182.439 Y165.78 E.01548
G1 X182.425 Y166.329 E.01687
G1 X182.571 Y166.829 E.01601
G1 X182.856 Y167.3 E.01693
G1 X183.276 Y167.66 E.01697
G1 X183.778 Y167.877 E.01681
G1 X184.275 Y167.931 E.01537
G2 X185.002 Y167.779 I-.261 J-3.056 E.02288
G1 X185.329 Y167.59 E.01158
G1 X185.701 Y167.23 E.01592
G1 X185.888 Y166.936 E.0107
G1 X186.061 Y166.419 E.01676
G2 X186.034 Y165.685 I-3.041 J-.255 E.02262
G1 X185.857 Y165.205 E.01572
G1 X185.644 Y164.9 E.01144
G1 X185.225 Y164.541 E.01696
G1 X184.719 Y164.321 E.01694
G1 X184.179 Y164.27 E.01667
G1 X183.651 Y164.361 E.01645
G1 X183.335 Y164.505 E.01065
G1 X182.905 Y164.846 E.01688
G1 X182.628 Y165.251 E.01507
M204 S10000
G1 X182.936 Y165.468 F60000
G1 F2598
M204 S8000
G1 X182.815 Y165.844 E.01213
G1 X182.803 Y166.292 E.01379
G1 X182.923 Y166.693 E.01284
G1 X183.138 Y167.045 E.01268
G1 X183.478 Y167.336 E.01375
G1 X183.886 Y167.513 E.01365
G1 X184.265 Y167.554 E.01173
G1 X184.717 Y167.466 E.01413
G1 X185.1 Y167.287 E.01299
G1 X185.475 Y166.883 E.01693
G1 X185.685 Y166.353 E.01753
G2 X185.641 Y165.653 I-2.259 J-.207 E.02163
G1 X185.453 Y165.285 E.01269
G2 X185.022 Y164.864 I-2.259 J1.879 E.01856
G1 X184.613 Y164.686 E.01372
G1 X184.177 Y164.648 E.01343
G1 X183.774 Y164.719 E.01258
G2 X183.184 Y165.106 I.933 J2.066 E.02177
G1 X182.97 Y165.419 E.01164
M204 S10000
G1 X183.278 Y165.636 F60000
G1 F2598
M204 S8000
G1 X183.19 Y165.908 E.00878
G1 X183.203 Y166.353 E.01367
G1 X183.304 Y166.625 E.00892
G1 X183.559 Y166.909 E.01171
G1 X183.827 Y167.077 E.00972
G1 X184.175 Y167.179 E.01114
G1 X184.543 Y167.123 E.01146
G1 X184.871 Y166.984 E.01094
G1 X185.157 Y166.681 E.01279
G1 X185.31 Y166.287 E.01298
G2 X185.28 Y165.77 I-1.668 J-.164 E.01598
G1 X185.081 Y165.41 E.01264
G1 X184.82 Y165.187 E.01054
G1 X184.394 Y165.034 E.01393
G1 X184.1 Y165.029 E.00901
G1 X183.732 Y165.153 E.01194
G1 X183.463 Y165.366 E.01054
G1 X183.312 Y165.587 E.00822
M204 S10000
G1 X183.742 Y165.626 F60000
G1 F2598
M204 S8000
G1 X183.593 Y165.888 E.00927
G1 X183.56 Y166.22 E.01025
G1 X183.664 Y166.482 E.00867
G1 X183.882 Y166.69 E.00925
G1 X184.201 Y166.801 E.01038
G1 X184.562 Y166.727 E.01131
G1 X184.838 Y166.478 E.01143
G1 X184.934 Y166.221 E.00844
G1 X184.939 Y166.033 E.00579
G1 X184.865 Y165.76 E.00869
G1 X184.618 Y165.511 E.01078
G1 X184.282 Y165.398 E.01088
G1 X183.981 Y165.454 E.00942
G1 X183.791 Y165.591 E.0072
M204 S10000
G1 X184.044 Y165.96 F60000
; LINE_WIDTH: 0.54135
G1 F2598
M204 S8000
G1 X183.999 Y166.149 E.00786
G1 X184.046 Y166.253 E.00465
G1 X184.24 Y166.362 E.00902
G1 X184.425 Y166.281 E.00822
G2 X184.501 Y166.022 I-.219 J-.205 E.01138
G1 X184.383 Y165.886 E.0073
G1 X184.198 Y165.843 E.00772
G1 X184.092 Y165.924 E.00544
; COOLING_NODE: 5
; WIPE_START
G1 F7222.679
G1 X184.198 Y165.843 E-.0672
G1 X184.383 Y165.886 E-.09545
G1 X184.501 Y166.022 E-.09027
G1 X184.498 Y166.145 E-.0616
G1 X184.425 Y166.281 E-.07777
G1 X184.24 Y166.362 E-.10154
G1 X184.046 Y166.253 E-.11148
G1 X183.999 Y166.149 E-.05749
G1 X184.044 Y165.96 E-.0972
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X182.855 Y158.421 Z4.8 F60000
G1 X182.102 Y153.648 Z4.8
G1 Z4.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2598
M204 S8000
G1 X182.102 Y152.852 E.0264
G1 X187.298 Y152.852 E.17236
G1 X187.298 Y153.648 E.0264
G1 X182.162 Y153.648 E.17037
; COOLING_NODE: 5
M204 S250
G1 X181.71 Y154.04 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2598
M204 S5000
G1 X181.71 Y152.46 E.04855
G1 X187.69 Y152.46 E.18375
G1 X187.69 Y154.04 E.04855
G1 X181.77 Y154.04 E.18191
M204 S10000
G1 X182.306 Y153.25 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F2598
M204 S8000
G1 X187.094 Y153.25 E.15172
; CHANGE_LAYER
; Z_HEIGHT: 4.47619
; LAYER_HEIGHT: 0.0761905
; WIPE_START
G1 F9259.259
G1 X185.094 Y153.25 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 27/85
; update layer progress
M73 L27
M991 S0 P26 ;notify layer change

; OBJECT_ID: 15
M204 S10000
G17
G3 Z4.8 I-.269 J-1.187 P1  F60000
G1 X180.769 Y154.231 Z4.8
G1 Z4.476
G1 E.8 F1800
; FEATURE: Support interface
; LINE_WIDTH: 0.42
; LAYER_HEIGHT: 0.27619
G1 F2890
M204 S8000
G1 X180.962 Y154.038 E.01108
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X180.962 Y152.798 E.05035
G1 X179.698 Y154.062 E.07254
G1 X178.458 Y154.062 E.05035
G1 X180.081 Y152.438 E.09319
G1 X178.841 Y152.438 E.05035
G1 X177.217 Y154.062 E.09319
G1 X175.977 Y154.062 E.05035
G1 X177.6 Y152.438 E.09319
G1 X176.36 Y152.438 E.05035
G1 X174.737 Y154.062 E.09319
G1 X173.496 Y154.062 E.05035
G1 X175.119 Y152.438 E.09319
G1 X173.879 Y152.438 E.05035
G1 X172.256 Y154.062 E.09319
G1 X171.015 Y154.062 E.05035
G1 X172.639 Y152.438 E.09319
G1 X171.398 Y152.438 E.05035
G1 X169.775 Y154.062 E.09319
G1 X169.038 Y154.062 E.0299
G1 X169.038 Y153.558 E.02045
G1 X170.328 Y152.269 E.07401
; CHANGE_LAYER
; Z_HEIGHT: 4.6
; LAYER_HEIGHT: 0.123809
; WIPE_START
G1 F4800
G1 X169.038 Y153.558 E-.69285
G1 X169.038 Y153.735 E-.06715
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 28/85
; update layer progress
M73 L28
M991 S0 P27 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 5
M204 S10000
G17
G3 Z4.876 I.092 J-1.213 P1  F60000
G1 X167.898 Y153.648 Z4.876
G1 Z4.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
; LAYER_HEIGHT: 0.2
G1 F2890
M204 S8000
G1 X162.702 Y153.648 E.17236
G1 X162.702 Y152.852 E.0264
G1 X167.898 Y152.852 E.17236
G1 X167.898 Y153.588 E.02441
; COOLING_NODE: 5
M204 S250
G1 X168.29 Y154.04 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2650
M204 S5000
G1 X162.31 Y154.04 E.18375
G1 X162.31 Y152.46 E.04855
G1 X168.29 Y152.46 E.18375
G1 X168.29 Y153.98 E.04671
M204 S10000
G1 X167.694 Y153.25 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F2890
M204 S8000
G1 X162.906 Y153.25 E.15172
; COOLING_NODE: 4
; WIPE_START
G1 F9259.259
G1 X164.906 Y153.25 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X166.709 Y160.666 Z5 F60000
G1 X167.837 Y165.305 Z5
M73 P61 R6
G1 Z4.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2890
M204 S8000
G3 X165.793 Y163.867 I-2.087 J.795 E.37744
G1 X165.861 Y163.869 E.00225
G3 X167.815 Y165.249 I-.111 J2.23 E.08374
; COOLING_NODE: 4
M204 S10000
G1 X168.217 Y165.157 F60000
G1 F2890
M204 S8000
G3 X165.798 Y163.46 I-2.466 J.942 E.44625
G1 X165.884 Y163.463 E.00284
G3 X168.195 Y165.101 I-.133 J2.637 E.09918
; COOLING_NODE: 4
M204 S10000
G1 X168.596 Y165.01 F60000
G1 F2890
M204 S8000
G3 X165.803 Y163.053 I-2.846 J1.09 E.51507
G1 X165.907 Y163.056 E.00343
G3 X168.574 Y164.954 I-.156 J3.043 E.11463
; COOLING_NODE: 4
M204 S250
G1 X168.967 Y164.883 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2650
M204 S5000
G1 X169.057 Y165.152 E.0087
G3 X165.808 Y162.661 I-3.306 J.948 E.52929
G1 X165.929 Y162.665 E.0037
G3 X168.946 Y164.827 I-.178 J3.435 E.12048
; WIPE_START
G1 F9547.055
M204 S8000
G1 X169.057 Y165.152 E-.13037
G1 X169.138 Y165.503 E-.13681
G1 X169.177 Y165.799 E-.11371
G1 X169.189 Y166.16 E-.13729
G1 X169.164 Y166.519 E-.13649
G1 X169.119 Y166.792 E-.10533
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X165.964 Y165.955 Z5 F60000
G1 Z4.6
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.54127
G1 F2890
M204 S8000
G1 X165.756 Y165.837 E.00972
G1 X165.633 Y165.875 E.00525
G1 X165.495 Y166.039 E.00869
G1 X165.557 Y166.277 E.01002
G1 X165.732 Y166.352 E.00771
G1 X165.932 Y166.287 E.00852
G1 X166.002 Y166.118 E.00744
G2 X165.982 Y166.013 I-.253 J-.006 E.00437
M204 S10000
G1 X166.35 Y165.738 F60000
; LINE_WIDTH: 0.41999
G1 F2890
M204 S8000
G1 X166.117 Y165.51 E.01001
G1 X165.781 Y165.398 E.0109
G1 X165.482 Y165.453 E.00935
G1 X165.242 Y165.626 E.00909
G1 X165.071 Y165.917 E.01035
G1 X165.073 Y166.257 E.01044
G1 X165.219 Y166.561 E.01038
G1 X165.501 Y166.749 E.01039
G1 X165.803 Y166.785 E.00934
G1 X166.132 Y166.687 E.01057
G1 X166.327 Y166.484 E.00865
G1 X166.443 Y166.149 E.01089
G2 X166.366 Y165.796 I-.904 J.012 E.01116
M204 S10000
G1 X166.58 Y165.41 F60000
G1 F2890
M204 S8000
G1 X166.32 Y165.187 E.01054
G1 X165.895 Y165.034 E.01388
G1 X165.601 Y165.028 E.00903
G1 X165.234 Y165.151 E.01188
G1 X164.963 Y165.366 E.01064
G1 X164.733 Y165.746 E.01364
G1 X164.675 Y166 E.00801
G1 X164.701 Y166.342 E.01055
G1 X164.887 Y166.744 E.01358
G1 X165.066 Y166.936 E.00807
G1 X165.364 Y167.105 E.01052
G2 X165.992 Y167.149 I.386 J-1.012 E.01962
G1 X166.394 Y166.964 E.0136
G2 X166.823 Y166.175 I-.744 J-.916 E.0283
G2 X166.609 Y165.463 I-1.353 J.019 E.02316
M204 S10000
G1 X166.943 Y165.27 F60000
G1 F2890
M204 S8000
G2 X166.522 Y164.864 I-2.341 J2.001 E.018
G1 X166.117 Y164.687 E.01357
G1 X165.677 Y164.648 E.01356
G1 X165.274 Y164.719 E.01258
G2 X164.684 Y165.106 I.933 J2.065 E.02178
G1 X164.43 Y165.477 E.0138
G1 X164.295 Y165.983 E.01609
G1 X164.33 Y166.428 E.01371
G1 X164.493 Y166.842 E.01367
G1 X164.732 Y167.139 E.0117
G2 X165.227 Y167.461 I1.926 J-2.42 E.01817
G1 X165.648 Y167.553 E.01324
G1 X166.078 Y167.52 E.01324
G1 X166.496 Y167.354 E.01383
G1 X166.805 Y167.099 E.0123
G2 X167.203 Y166.202 I-1.176 J-1.06 E.03068
G1 X167.17 Y165.769 E.01333
G1 X166.967 Y165.325 E.015
M204 S10000
G1 X167.356 Y165.203 F60000
G1 F2890
M204 S8000
G1 X167.143 Y164.899 E.01138
G1 X166.724 Y164.54 E.01695
G1 X166.223 Y164.323 E.01679
G1 X165.674 Y164.27 E.01694
G1 X165.151 Y164.361 E.01632
G1 X164.838 Y164.503 E.01056
G1 X164.405 Y164.846 E.01699
G1 X164.093 Y165.302 E.01697
G1 X163.948 Y165.775 E.01519
G2 X163.958 Y166.514 I3.028 J.327 E.02277
G1 X164.16 Y167.024 E.01683
G1 X164.473 Y167.412 E.01534
G2 X165.091 Y167.817 I1.964 J-2.326 E.02275
G1 X165.622 Y167.934 E.0167
G1 X166.164 Y167.892 E.01671
G1 X166.678 Y167.688 E.017
G1 X167.081 Y167.356 E.01603
G2 X167.466 Y166.76 I-2.241 J-1.873 E.02186
G1 X167.584 Y166.228 E.01674
G1 X167.542 Y165.685 E.01675
G1 X167.377 Y165.259 E.01403
; COOLING_NODE: 2
; WIPE_START
G1 F9547.299
G1 X167.542 Y165.685 E-.17352
G1 X167.584 Y166.228 E-.20711
G1 X167.466 Y166.76 E-.20698
G1 X167.316 Y167.032 E-.11783
G1 X167.232 Y167.148 E-.05456
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X170.502 Y165.248 Z5 F60000
G1 Z4.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2890
M204 S8000
G1 X170.502 Y164.452 E.0264
G1 X179.498 Y164.452 E.29841
G1 X179.498 Y165.248 E.0264
G1 X170.562 Y165.248 E.29642
; COOLING_NODE: 2
M204 S250
G1 X170.11 Y165.64 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2695
M204 S5000
G1 X170.11 Y164.06 E.04855
G1 X179.89 Y164.06 E.30051
G1 X179.89 Y165.64 E.04855
G1 X170.17 Y165.64 E.29867
M204 S10000
G1 X170.706 Y164.85 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F2890
M204 S8000
G1 X179.294 Y164.85 E.27211
; COOLING_NODE: 1
; WIPE_START
G1 F9259.259
G1 X177.294 Y164.85 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X182.054 Y165.734 Z5 F60000
G1 Z4.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2890
M204 S8000
G1 X182.065 Y165.641 E.00311
G3 X184.293 Y163.867 I2.185 J.458 E.10246
G1 X184.361 Y163.869 E.00225
G3 X182.018 Y166.061 I-.111 J2.23 E.34667
G1 X182.047 Y165.794 E.00891
; COOLING_NODE: 1
M204 S10000
G1 X181.651 Y165.69 F60000
G1 F2890
M204 S8000
G1 X181.667 Y165.555 E.00451
G3 X184.298 Y163.46 I2.583 J.544 E.12096
G1 X184.384 Y163.463 E.00284
G3 X181.611 Y166.054 I-.133 J2.637 E.40979
G1 X181.644 Y165.75 E.01015
; COOLING_NODE: 1
M204 S10000
G1 X181.231 Y165.69 F60000
G1 F2890
M204 S8000
G1 X181.269 Y165.469 E.00744
G3 X184.303 Y163.053 I2.981 J.631 E.13946
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X184.407 Y163.056 E.00343
G3 X181.224 Y165.749 I-.156 J3.043 E.48279
; COOLING_NODE: 1
M204 S250
G1 X180.845 Y165.626 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2650
M204 S5000
G1 X180.886 Y165.386 E.00748
G3 X184.308 Y162.661 I3.365 J.714 E.1457
G1 X184.429 Y162.665 E.0037
G3 X180.836 Y165.685 I-.178 J3.435 E.50529
; WIPE_START
G1 F9547.055
M204 S8000
G1 X180.886 Y165.386 E-.11529
G1 X180.978 Y165.037 E-.13697
G1 X181.107 Y164.702 E-.1364
G1 X181.242 Y164.432 E-.11479
G1 X181.433 Y164.126 E-.1369
G1 X181.615 Y163.889 E-.11393
G1 X181.625 Y163.878 E-.00572
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X183.998 Y166.031 Z5 F60000
G1 Z4.6
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.54121
G1 F2890
M204 S8000
G1 X184.005 Y166.168 E.00556
G1 X184.127 Y166.317 E.00783
G1 X184.306 Y166.346 E.00736
G1 X184.457 Y166.239 E.00748
G1 X184.498 Y166.129 E.00479
G1 X184.473 Y165.963 E.00683
G1 X184.256 Y165.837 E.01017
G2 X184.038 Y165.985 I.009 J.248 E.01132
M204 S10000
G1 X183.683 Y165.713 F60000
; LINE_WIDTH: 0.41999
G1 F2890
M204 S8000
G1 X183.564 Y165.958 E.00838
G1 X183.562 Y166.227 E.00826
G1 X183.681 Y166.499 E.00911
G1 X183.911 Y166.698 E.00936
G1 X184.201 Y166.793 E.00938
G1 X184.508 Y166.737 E.00958
G1 X184.757 Y166.575 E.00912
G1 X184.92 Y166.285 E.01023
G1 X184.933 Y166.179 E.00328
G1 X184.899 Y165.836 E.01058
G1 X184.758 Y165.63 E.00769
G1 X184.481 Y165.451 E.01014
G1 X184.226 Y165.4 E.00799
G1 X183.932 Y165.476 E.00932
G1 X183.726 Y165.671 E.00872
M204 S10000
G1 X183.372 Y165.5 F60000
G1 F2890
M204 S8000
G1 X183.205 Y165.819 E.01106
G1 X183.176 Y166.227 E.01258
G1 X183.297 Y166.574 E.01128
G2 X185.129 Y166.699 I.954 J-.497 E.06759
G1 X185.286 Y166.404 E.01028
G2 X185.187 Y165.56 I-1.593 J-.241 E.02642
G1 X184.941 Y165.29 E.01122
G1 X184.674 Y165.124 E.00967
G1 X184.302 Y165.019 E.01187
G1 X183.897 Y165.077 E.01257
G1 X183.589 Y165.266 E.0111
G1 X183.412 Y165.456 E.00796
M204 S10000
G1 X182.93 Y165.477 F60000
G1 F2890
M204 S8000
G1 X182.814 Y165.871 E.01262
G1 X182.8 Y166.273 E.01235
G2 X183.056 Y166.936 I2.224 J-.48 E.02193
G1 X183.353 Y167.248 E.01324
G1 X183.728 Y167.461 E.01324
G1 X184.148 Y167.553 E.01323
G1 X184.578 Y167.52 E.01324
G1 X184.983 Y167.36 E.01338
G1 X185.316 Y167.094 E.01308
G1 X185.613 Y166.607 E.01755
G2 X185.623 Y165.606 I-1.577 J-.517 E.03123
G1 X185.361 Y165.153 E.01609
G1 X185.022 Y164.864 E.01369
G1 X184.617 Y164.687 E.01358
G1 X184.177 Y164.648 E.01356
G1 X183.774 Y164.719 E.01258
G2 X183.184 Y165.106 I.932 J2.065 E.02178
G1 X182.964 Y165.428 E.01197
M204 S10000
G1 X182.593 Y165.303 F60000
G1 F2890
M204 S8000
G1 X182.443 Y165.807 E.01617
G1 X182.423 Y166.319 E.01573
G1 X182.5 Y166.664 E.01086
G1 X182.744 Y167.155 E.01684
G1 X183.118 Y167.548 E.0167
G1 X183.591 Y167.817 E.0167
G1 X184.122 Y167.934 E.0167
G1 X184.664 Y167.892 E.01671
G1 X185.174 Y167.689 E.01686
G1 X185.595 Y167.354 E.01654
G1 X185.907 Y166.897 E.01701
G2 X186.056 Y166.308 I-1.121 J-.597 E.01885
G1 X186.088 Y166.036 E.00843
G1 X185.986 Y165.492 E.01701
G1 X185.754 Y165.055 E.01518
G2 X185.224 Y164.541 I-2.369 J1.907 E.02274
G1 X184.723 Y164.323 E.01679
G1 X184.174 Y164.27 E.01694
G1 X183.651 Y164.361 E.01632
G1 X183.338 Y164.503 E.01057
G1 X182.905 Y164.846 E.01698
G1 X182.627 Y165.253 E.01515
; COOLING_NODE: 5
; WIPE_START
G1 F9547.299
G1 X182.905 Y164.846 E-.18731
G1 X183.338 Y164.503 E-.21002
G1 X183.651 Y164.361 E-.1307
G1 X184.174 Y164.27 E-.20182
G1 X184.253 Y164.278 E-.03015
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X182.739 Y156.797 Z5 F60000
G1 X182.102 Y153.648 Z5
G1 Z4.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2890
M204 S8000
G1 X182.102 Y152.852 E.0264
G1 X187.298 Y152.852 E.17236
G1 X187.298 Y153.648 E.0264
G1 X182.162 Y153.648 E.17037
; COOLING_NODE: 5
M204 S250
G1 X181.71 Y154.04 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2650
M204 S5000
G1 X181.71 Y152.46 E.04855
G1 X187.69 Y152.46 E.18375
G1 X187.69 Y154.04 E.04855
G1 X181.77 Y154.04 E.18191
M204 S10000
G1 X182.306 Y153.25 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F2890
M204 S8000
G1 X187.094 Y153.25 E.15172
; CHANGE_LAYER
; Z_HEIGHT: 4.75238
; LAYER_HEIGHT: 0.152381
; WIPE_START
G1 F9259.259
G1 X185.094 Y153.25 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 29/85
; update layer progress
M73 L29
M991 S0 P28 ;notify layer change

; OBJECT_ID: 15
M204 S10000
G17
G3 Z5 I-.146 J-1.208 P1  F60000
G1 X181.131 Y153.728 Z5
G1 Z4.752
G1 E.8 F1800
; FEATURE: Support interface
; LINE_WIDTH: 0.42
; LAYER_HEIGHT: 0.27619
G1 F2886
M204 S8000
G1 X179.842 Y152.438 E.07401
G1 X178.602 Y152.438 E.05035
G1 X180.225 Y154.062 E.09319
G1 X178.985 Y154.062 E.05035
G1 X177.361 Y152.438 E.09319
G1 X176.121 Y152.438 E.05035
G1 X177.744 Y154.062 E.09319
G1 X176.504 Y154.062 E.05035
G1 X174.881 Y152.438 E.09319
G1 X173.64 Y152.438 E.05035
G1 X175.264 Y154.062 E.09319
G1 X174.023 Y154.062 E.05035
G1 X172.4 Y152.438 E.09319
G1 X171.159 Y152.438 E.05035
G1 X172.783 Y154.062 E.09319
G1 X171.542 Y154.062 E.05035
G1 X169.919 Y152.438 E.09319
G1 X169.038 Y152.438 E.03575
G1 X169.038 Y152.798 E.0146
G1 X170.302 Y154.062 E.07254
G1 X169.062 Y154.062 E.05035
G1 X168.869 Y153.869 E.01108
; WIPE_START
G1 F4800
G1 X169.062 Y154.062 E-.10368
G1 X170.302 Y154.062 E-.47134
G1 X169.958 Y153.717 E-.18497
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z5.152 I1.217 J0 P1  F60000
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
            

            
                M9711 M0 E1 X256 Y153 Z4.75238 S11 C10 O0 T3000
            

            
        M623

        M622 J1
            

            
                M9711 M0 E1 U256 V153 Z4.75238 S11 C10 O0 T3000
            

            
        M623
    
    
    
        M993 A3 B3 C3
    
M623
; SKIPPABLE_END

G1 Z5.152
; CHANGE_LAYER
; Z_HEIGHT: 4.8
; LAYER_HEIGHT: 0.0476193
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 30/85
; update layer progress
M73 L30
M991 S0 P29 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 5
G1 X167.898 Y153.648
G1 Z4.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
; LAYER_HEIGHT: 0.2
G1 F2886
M204 S8000
G1 X162.702 Y153.648 E.17236
G1 X162.702 Y152.852 E.0264
G1 X167.898 Y152.852 E.17236
G1 X167.898 Y153.588 E.02441
; COOLING_NODE: 5
M204 S250
G1 X168.29 Y154.04 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2637
M204 S5000
G1 X162.31 Y154.04 E.18375
G1 X162.31 Y152.46 E.04855
G1 X168.29 Y152.46 E.18375
G1 X168.29 Y153.98 E.04671
M204 S10000
G1 X167.694 Y153.25 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F2886
M204 S8000
G1 X162.906 Y153.25 E.15172
; COOLING_NODE: 4
; WIPE_START
G1 F9259.259
G1 X164.906 Y153.25 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
M73 P62 R6
G1 X166.71 Y160.666 Z5.2 F60000
G1 X167.847 Y165.337 Z5.2
G1 Z4.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2886
M204 S8000
G3 X165.75 Y163.867 I-2.099 J.762 E.37492
G1 X165.866 Y163.87 E.00387
G3 X167.825 Y165.281 I-.118 J2.23 E.08463
; COOLING_NODE: 4
M204 S10000
G1 X168.228 Y165.188 F60000
G1 F2886
M204 S8000
G1 X168.23 Y165.198 E.00033
G3 X165.752 Y163.459 I-2.481 J.902 E.44333
G1 X165.888 Y163.463 E.0045
G3 X168.144 Y164.989 I-.139 J2.636 E.09492
G1 X168.204 Y165.133 E.00518
; COOLING_NODE: 4
M204 S10000
G1 X168.604 Y165.033 F60000
G1 F2886
M204 S8000
G1 X168.614 Y165.058 E.00089
G3 X165.754 Y163.052 I-2.864 J1.041 E.51174
G1 X165.909 Y163.056 E.00514
G3 X168.513 Y164.815 I-.159 J3.043 E.10949
G1 X168.581 Y164.978 E.00586
; COOLING_NODE: 4
M204 S250
G1 X168.966 Y164.883 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2637
M204 S5000
G1 X168.983 Y164.924 E.00135
G3 X165.756 Y162.66 I-3.232 J1.176 E.53505
G1 X165.93 Y162.665 E.00533
G3 X168.868 Y164.647 I-.179 J3.435 E.11442
G1 X168.943 Y164.828 E.00602
; WIPE_START
G1 F9547.055
M204 S8000
G1 X168.983 Y164.924 E-.03946
G1 X169.088 Y165.268 E-.13672
G1 X169.157 Y165.622 E-.13695
G1 X169.185 Y165.92 E-.11372
G1 X169.185 Y166.28 E-.13681
G1 X169.148 Y166.638 E-.13711
G1 X169.116 Y166.791 E-.05922
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X165.921 Y165.901 Z5.2 F60000
G1 Z4.8
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.54135
G1 F2886
M204 S8000
G1 X165.77 Y165.848 E.00647
G1 X165.565 Y165.916 E.00881
G1 X165.493 Y166.115 E.00858
G1 X165.589 Y166.29 E.00814
G1 X165.764 Y166.352 E.00751
G1 X165.932 Y166.288 E.0073
G1 X166.002 Y166.113 E.00764
G2 X165.945 Y165.956 I-.264 J.007 E.00691
M204 S10000
G1 X166.332 Y165.709 F60000
; LINE_WIDTH: 0.41999
G1 F2886
M204 S8000
G1 X166.112 Y165.501 E.00929
G1 X165.819 Y165.403 E.00951
G1 X165.472 Y165.471 E.01084
G1 X165.255 Y165.606 E.00784
G1 X165.099 Y165.855 E.00905
G1 X165.055 Y166.181 E.0101
G1 X165.177 Y166.485 E.01005
G1 X165.394 Y166.697 E.00932
G1 X165.684 Y166.784 E.00931
G1 X166.021 Y166.746 E.01043
G1 X166.249 Y166.591 E.00847
G1 X166.403 Y166.338 E.00909
G1 X166.434 Y166.035 E.00936
G1 X166.35 Y165.767 E.00864
M204 S10000
G1 X166.556 Y165.378 F60000
G1 F2886
M204 S8000
G1 X166.228 Y165.129 E.01266
G1 X165.83 Y165.023 E.01264
G1 X165.49 Y165.056 E.01052
G1 X165.094 Y165.245 E.01346
G2 X164.74 Y165.727 I.602 J.814 E.01865
G1 X164.676 Y166.158 E.01341
G1 X164.784 Y166.576 E.01327
G1 X164.944 Y166.814 E.00879
G1 X165.197 Y167.023 E.01009
G1 X165.486 Y167.143 E.00962
G1 X165.807 Y167.175 E.0099
G1 X166.235 Y167.062 E.01362
G1 X166.527 Y166.846 E.01115
G1 X166.761 Y166.468 E.01365
G1 X166.824 Y166.156 E.00979
G2 X166.586 Y165.431 I-1.38 J.052 E.02377
M204 S10000
G1 X166.993 Y165.335 F60000
G1 F2886
M204 S8000
G1 X166.728 Y165.024 E.01257
G1 X166.395 Y164.789 E.01253
G1 X166 Y164.669 E.01268
G2 X165.397 Y164.686 I-.218 J2.92 E.01856
G1 X164.985 Y164.857 E.01371
G1 X164.679 Y165.119 E.01238
G2 X164.292 Y166.04 I1.204 J1.048 E.03123
G2 X164.441 Y166.742 I2.138 J-.087 E.02215
G1 X164.662 Y167.07 E.01214
G1 X165 Y167.35 E.01351
G1 X165.393 Y167.513 E.01308
G1 X165.826 Y167.555 E.01337
G1 X166.263 Y167.466 E.01368
G1 X166.629 Y167.258 E.01295
G1 X166.907 Y166.99 E.01186
G1 X167.12 Y166.599 E.01368
G1 X167.205 Y166.176 E.01326
G1 X167.164 Y165.747 E.01322
G1 X167.016 Y165.391 E.01187
M204 S10000
G1 X167.324 Y165.148 F60000
G1 F2886
M204 S8000
G1 X166.983 Y164.747 E.01618
G1 X166.561 Y164.449 E.01587
G1 X166.059 Y164.296 E.01613
G1 X165.854 Y164.264 E.00637
G1 X165.305 Y164.316 E.01695
G1 X164.798 Y164.526 E.01686
G1 X164.415 Y164.849 E.0154
G1 X164.262 Y165.018 E.007
G1 X164.022 Y165.47 E.01572
G1 X163.913 Y166.013 E.01701
G1 X163.933 Y166.385 E.01145
G1 X164.098 Y166.907 E.01684
G1 X164.379 Y167.325 E.01548
G1 X164.803 Y167.676 E.01692
G1 X165.301 Y167.883 E.01654
G1 X165.846 Y167.936 E.01684
G1 X166.383 Y167.826 E.01685
G1 X166.838 Y167.573 E.01598
G1 X167.216 Y167.211 E.0161
G1 X167.478 Y166.729 E.01685
G1 X167.586 Y166.196 E.01672
G1 X167.534 Y165.655 E.01668
G1 X167.347 Y165.204 E.01502
; COOLING_NODE: 2
; WIPE_START
G1 F9547.299
G1 X167.534 Y165.655 E-.18573
G1 X167.586 Y166.196 E-.2063
G1 X167.478 Y166.729 E-.20681
G1 X167.275 Y167.102 E-.16115
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X170.502 Y165.248 Z5.2 F60000
G1 Z4.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2886
M204 S8000
G1 X170.502 Y164.452 E.0264
G1 X179.498 Y164.452 E.29841
G1 X179.498 Y165.248 E.0264
G1 X170.562 Y165.248 E.29642
; COOLING_NODE: 2
M204 S250
G1 X170.11 Y165.64 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2689
M204 S5000
G1 X170.11 Y164.06 E.04855
G1 X179.89 Y164.06 E.30051
G1 X179.89 Y165.64 E.04855
G1 X170.17 Y165.64 E.29867
M204 S10000
G1 X170.706 Y164.85 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F2886
M204 S8000
G1 X179.294 Y164.85 E.27211
; COOLING_NODE: 1
; WIPE_START
G1 F9259.259
G1 X177.294 Y164.85 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X182.056 Y165.693 Z5.2 F60000
G1 Z4.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2886
M204 S8000
G1 X182.056 Y165.674 E.00064
G3 X184.25 Y163.867 I2.192 J.426 E.10221
G1 X184.366 Y163.87 E.00387
G3 X182.015 Y166.1 I-.118 J2.23 E.34511
G1 X182.05 Y165.753 E.01157
; COOLING_NODE: 1
M204 S10000
G1 X181.642 Y165.684 F60000
G1 F2886
M204 S8000
G3 X184.252 Y163.459 I2.607 J.416 E.12381
G1 X184.388 Y163.463 E.0045
G3 X181.633 Y165.743 I-.139 J2.636 E.41995
; COOLING_NODE: 1
M204 S10000
G1 X181.24 Y165.623 F60000
G1 F2886
M204 S8000
G1 X181.24 Y165.622 E.00005
G3 X184.254 Y163.052 I3.009 J.478 E.14301
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X184.409 Y163.056 E.00514
G3 X181.207 Y165.941 I-.159 J3.043 E.47631
G1 X181.234 Y165.682 E.00862
; COOLING_NODE: 1
M204 S250
G1 X180.85 Y165.582 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2637
M204 S5000
G1 X180.854 Y165.562 E.00063
G3 X184.256 Y162.66 I3.397 J.538 E.14959
G1 X184.43 Y162.665 E.00533
G3 X180.816 Y165.92 I-.179 J3.435 E.49801
G1 X180.844 Y165.642 E.00862
; WIPE_START
G1 F9547.055
M204 S8000
G1 X180.854 Y165.562 E-.03052
G1 X180.912 Y165.268 E-.11372
G1 X181.018 Y164.923 E-.13709
G1 X181.158 Y164.592 E-.13674
G1 X181.305 Y164.323 E-.11645
G1 X181.503 Y164.029 E-.13485
G1 X181.655 Y163.845 E-.09063
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X184.071 Y165.908 Z5.2 F60000
G1 Z4.8
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.54131
G1 F2886
M204 S8000
G1 X183.998 Y166.087 E.00786
G1 X184.057 Y166.259 E.00737
G1 X184.164 Y166.342 E.00548
G1 X184.389 Y166.323 E.00919
G1 X184.487 Y166.186 E.00684
G1 X184.498 Y166.076 E.0045
G1 X184.421 Y165.901 E.00779
G1 X184.271 Y165.848 E.00647
G1 X184.129 Y165.891 E.00603
M204 S10000
G1 X183.751 Y165.608 F60000
; LINE_WIDTH: 0.41999
G1 F2886
M204 S8000
G1 X183.597 Y165.863 E.00914
G1 X183.566 Y166.165 E.00934
G1 X183.655 Y166.458 E.0094
G1 X183.871 Y166.673 E.00938
G1 X184.075 Y166.773 E.00699
G1 X184.388 Y166.773 E.00961
G1 X184.649 Y166.676 E.00855
G2 X184.934 Y166.035 I-.547 J-.627 E.02225
G1 X184.832 Y165.709 E.01048
G1 X184.612 Y165.501 E.0093
G1 X184.319 Y165.403 E.00951
G1 X183.986 Y165.466 E.01039
G1 X183.802 Y165.577 E.00661
M204 S10000
G1 X183.405 Y165.428 F60000
G1 F2886
M204 S8000
G1 X183.239 Y165.732 E.01065
G2 X183.53 Y166.9 I1.014 J.367 E.03922
G1 X183.889 Y167.115 E.01285
G1 X184.307 Y167.175 E.01297
G1 X184.735 Y167.062 E.01362
G1 X185.027 Y166.846 E.01115
G1 X185.261 Y166.468 E.01365
G1 X185.324 Y166.156 E.00979
G2 X185.056 Y165.378 I-1.587 J.113 E.02557
G1 X184.728 Y165.129 E.01265
G1 X184.33 Y165.023 E.01264
G1 X183.99 Y165.056 E.01052
G1 X183.592 Y165.247 E.01357
G1 X183.448 Y165.386 E.00614
M204 S10000
G1 X182.985 Y165.411 F60000
G1 F2886
M204 S8000
G1 X182.88 Y165.602 E.00668
G1 X182.795 Y166.024 E.01324
G1 X182.836 Y166.453 E.01322
G1 X183.001 Y166.851 E.01325
G1 X183.275 Y167.183 E.01323
G1 X183.762 Y167.47 E.01738
G1 X184.326 Y167.555 E.01753
G1 X184.763 Y167.466 E.01369
G1 X185.129 Y167.258 E.01294
G1 X185.407 Y166.99 E.01186
G1 X185.62 Y166.599 E.01368
G1 X185.705 Y166.176 E.01326
G1 X185.664 Y165.748 E.01322
G1 X185.493 Y165.335 E.01371
G1 X185.228 Y165.024 E.01257
G1 X184.895 Y164.789 E.01253
G1 X184.5 Y164.669 E.01268
G2 X183.897 Y164.686 I-.218 J2.921 E.01856
G1 X183.485 Y164.857 E.01371
G1 X183.196 Y165.098 E.01155
G1 X183.018 Y165.361 E.00977
M204 S10000
G1 X182.694 Y165.156 F60000
G1 F2886
M204 S8000
G1 X182.522 Y165.471 E.01102
G1 X182.414 Y166.004 E.01671
G1 X182.466 Y166.545 E.01669
G1 X182.674 Y167.047 E.01671
G1 X183.02 Y167.467 E.01669
G1 X183.477 Y167.769 E.01686
G1 X183.796 Y167.882 E.01038
G1 X184.346 Y167.936 E.01699
G1 X184.884 Y167.826 E.01686
G1 X185.338 Y167.573 E.01597
G1 X185.716 Y167.211 E.0161
G1 X185.978 Y166.729 E.01685
G1 X186.086 Y166.196 E.01672
G1 X186.034 Y165.655 E.01668
G1 X185.824 Y165.148 E.01686
G1 X185.483 Y164.747 E.01618
G1 X185.061 Y164.449 E.01587
G1 X184.559 Y164.296 E.01613
G1 X184.354 Y164.264 E.00637
G1 X183.805 Y164.316 E.01695
G1 X183.298 Y164.527 E.01687
G1 X182.919 Y164.842 E.01516
G1 X182.729 Y165.107 E.01003
; COOLING_NODE: 5
; WIPE_START
G1 F9547.299
G1 X182.919 Y164.842 E-.12399
G1 X183.298 Y164.527 E-.18748
G1 X183.805 Y164.316 E-.20863
G1 X184.354 Y164.264 E-.20959
G1 X184.433 Y164.276 E-.03031
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X182.798 Y156.821 Z5.2 F60000
G1 X182.102 Y153.648 Z5.2
G1 Z4.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2886
M204 S8000
G1 X182.102 Y152.852 E.0264
G1 X187.298 Y152.852 E.17236
G1 X187.298 Y153.648 E.0264
G1 X182.162 Y153.648 E.17037
; COOLING_NODE: 5
M204 S250
G1 X181.71 Y154.04 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2637
M204 S5000
G1 X181.71 Y152.46 E.04855
G1 X187.69 Y152.46 E.18375
G1 X187.69 Y154.04 E.04855
G1 X181.77 Y154.04 E.18191
M204 S10000
G1 X182.306 Y153.25 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F2886
M204 S8000
G1 X187.094 Y153.25 E.15172
; CHANGE_LAYER
; Z_HEIGHT: 5
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.259
G1 X185.094 Y153.25 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 31/85
; update layer progress
M73 L31
M991 S0 P30 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 5
M204 S10000
G17
G3 Z5.2 I-.028 J-1.217 P1  F60000
G1 X167.898 Y153.648 Z5.2
G1 Z5
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2590
M204 S8000
G1 X162.702 Y153.648 E.17236
G1 X162.702 Y152.852 E.0264
G1 X167.898 Y152.852 E.17236
G1 X167.898 Y153.588 E.02441
; COOLING_NODE: 5
M204 S250
G1 X168.29 Y154.04 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2590
M204 S5000
G1 X162.31 Y154.04 E.18375
G1 X162.31 Y152.46 E.04855
G1 X168.29 Y152.46 E.18375
G1 X168.29 Y153.98 E.04671
M204 S10000
G1 X167.694 Y153.25 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F2590
M204 S8000
G1 X162.906 Y153.25 E.15172
; COOLING_NODE: 4
; WIPE_START
G1 F9259.259
G1 X164.906 Y153.25 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X166.711 Y160.666 Z5.4 F60000
G1 X167.848 Y165.335 Z5.4
G1 Z5
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2590
M204 S8000
G3 X165.758 Y163.867 I-2.098 J.765 E.37521
G1 X165.865 Y163.87 E.00355
G3 X167.827 Y165.279 I-.115 J2.23 E.08465
; COOLING_NODE: 4
M204 S10000
G1 X168.228 Y165.188 F60000
G1 F2590
M204 S8000
G1 X168.231 Y165.196 E.0003
G3 X165.761 Y163.46 I-2.481 J.904 E.44363
G1 X165.887 Y163.463 E.00419
G3 X168.144 Y164.986 I-.137 J2.637 E.0949
G1 X168.205 Y165.132 E.00524
; COOLING_NODE: 4
M204 S10000
M73 P63 R6
G1 X168.595 Y165.016 F60000
G1 F2590
M204 S8000
G1 X168.664 Y165.209 E.0068
G3 X166.016 Y169.136 I-2.915 J.891 E.17992
G3 X165.909 Y163.056 I-.265 J-3.036 E.33164
G3 X168.56 Y164.922 I-.16 J3.044 E.11338
G1 X168.574 Y164.96 E.00135
; COOLING_NODE: 4
M204 S250
G1 X168.966 Y164.882 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2590
M204 S5000
G1 X168.984 Y164.923 E.00136
G3 X165.766 Y162.66 I-3.232 J1.177 E.53535
G1 X165.93 Y162.665 E.00502
G3 X168.869 Y164.646 I-.178 J3.435 E.11442
G1 X168.943 Y164.827 E.00601
; WIPE_START
G1 F9547.055
M204 S8000
G1 X168.984 Y164.923 E-.03964
G1 X169.088 Y165.268 E-.13695
G1 X169.157 Y165.622 E-.1369
G1 X169.185 Y165.919 E-.11373
G1 X169.185 Y166.281 E-.13723
G1 X169.156 Y166.579 E-.11388
G1 X169.115 Y166.79 E-.08167
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X165.919 Y165.9 Z5.4 F60000
G1 Z5
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.541256
G1 F2590
M204 S8000
G1 X165.76 Y165.839 E.00693
G1 X165.581 Y165.912 E.00782
G1 X165.496 Y166.061 E.00698
G1 X165.543 Y166.252 E.00799
G1 X165.743 Y166.362 E.00927
G1 X165.919 Y166.287 E.00774
G1 X166.004 Y166.139 E.00695
G2 X165.944 Y165.954 I-.301 J-.004 E.00802
M204 S10000
G1 X166.332 Y165.71 F60000
; LINE_WIDTH: 0.41999
G1 F2590
M204 S8000
G1 X166.114 Y165.502 E.00924
G1 X165.828 Y165.405 E.00929
G1 X165.556 Y165.441 E.00845
G1 X165.285 Y165.584 E.00939
G1 X165.115 Y165.838 E.0094
G1 X165.056 Y166.059 E.00703
G1 X165.116 Y166.364 E.00955
G1 X165.23 Y166.561 E.00701
G1 X165.488 Y166.735 E.00956
G1 X165.757 Y166.8 E.00851
G1 X166.044 Y166.73 E.00906
G1 X166.28 Y166.538 E.00935
G1 X166.438 Y166.235 E.01049
G2 X166.35 Y165.767 I-.846 J-.083 E.01483
M204 S10000
G1 X166.556 Y165.378 F60000
G1 F2590
M204 S8000
G1 X166.228 Y165.13 E.01263
G1 X165.806 Y165.02 E.01341
G1 X165.449 Y165.079 E.01112
G2 X164.766 Y165.694 I.39 J1.119 E.02897
G1 X164.673 Y166.017 E.01033
G1 X164.706 Y166.361 E.01062
G1 X164.883 Y166.74 E.01286
G1 X165.196 Y167.023 E.01296
G1 X165.614 Y167.168 E.01361
G1 X165.876 Y167.172 E.00804
G1 X166.205 Y167.075 E.01054
G2 X166.672 Y166.655 I-.46 J-.981 E.01961
G1 X166.815 Y166.261 E.01286
G2 X166.585 Y165.43 I-1.392 J-.062 E.02693
M204 S10000
G1 X166.993 Y165.336 F60000
G1 F2590
M204 S8000
G1 X166.725 Y165.021 E.0127
G1 X166.395 Y164.789 E.01239
G1 X165.946 Y164.66 E.01435
G1 X165.561 Y164.653 E.01182
G1 X165.134 Y164.779 E.01369
G1 X164.775 Y165.017 E.01323
G1 X164.501 Y165.349 E.01325
G1 X164.312 Y165.883 E.0174
G1 X164.336 Y166.453 E.01751
G1 X164.58 Y166.964 E.01739
G1 X165 Y167.349 E.01751
G1 X165.411 Y167.519 E.01369
G1 X165.79 Y167.554 E.01169
G2 X166.366 Y167.421 I-.405 J-3.073 E.01818
G1 X166.725 Y167.183 E.01324
G1 X166.999 Y166.851 E.01322
G1 X167.188 Y166.318 E.01738
G2 X167.164 Y165.747 I-3.387 J-.145 E.01756
G1 X167.016 Y165.391 E.01185
M204 S10000
G1 X167.324 Y165.149 F60000
G1 F2590
M204 S8000
G1 X166.98 Y164.744 E.01634
G1 X166.561 Y164.449 E.01572
G1 X166.047 Y164.294 E.01651
G2 X165.315 Y164.332 I-.285 J1.555 E.02272
G1 X164.973 Y164.433 E.01096
G1 X164.52 Y164.734 E.01669
G1 X164.174 Y165.153 E.01671
G1 X163.964 Y165.66 E.01685
G1 X163.914 Y165.996 E.01044
G1 X163.966 Y166.545 E.01695
G1 X164.176 Y167.051 E.01685
G1 X164.378 Y167.325 E.01043
G1 X164.803 Y167.676 E.01696
G1 X165.31 Y167.886 E.01686
G1 X165.807 Y167.93 E.01532
G2 X166.527 Y167.767 I-.31 J-3.032 E.02275
G1 X166.98 Y167.466 E.01671
G1 X167.326 Y167.047 E.01669
G1 X167.536 Y166.54 E.01687
G2 X167.56 Y165.929 I-1.216 J-.354 E.01898
G1 X167.534 Y165.655 E.00844
G1 X167.347 Y165.204 E.01501
; COOLING_NODE: 2
; WIPE_START
G1 F9547.299
G1 X167.534 Y165.655 E-.18564
G1 X167.56 Y165.929 E-.10436
G1 X167.586 Y166.206 E-.10602
G1 X167.536 Y166.54 E-.12812
G1 X167.326 Y167.047 E-.20865
G1 X167.28 Y167.103 E-.02722
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X170.502 Y165.248 Z5.4 F60000
G1 Z5
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2590
M204 S8000
G1 X170.502 Y164.452 E.0264
G1 X179.498 Y164.452 E.29841
G1 X179.498 Y165.248 E.0264
G1 X170.562 Y165.248 E.29642
; COOLING_NODE: 2
M204 S250
G1 X170.11 Y165.64 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2590
M204 S5000
G1 X170.11 Y164.06 E.04855
G1 X179.89 Y164.06 E.30051
G1 X179.89 Y165.64 E.04855
G1 X170.17 Y165.64 E.29867
M204 S10000
G1 X170.706 Y164.85 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F2590
M204 S8000
G1 X179.294 Y164.85 E.27211
; COOLING_NODE: 1
; WIPE_START
M73 P63 R5
G1 F9259.259
G1 X177.294 Y164.85 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X182.051 Y165.772 Z5.4 F60000
G1 Z5
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2590
M204 S8000
G1 X182.084 Y165.559 E.00714
G3 X184.258 Y163.867 I2.166 J.539 E.0985
G1 X184.365 Y163.87 E.00355
G3 X182.021 Y165.977 I-.115 J2.229 E.34905
G1 X182.042 Y165.831 E.0049
; COOLING_NODE: 1
M204 S10000
G1 X181.65 Y165.71 F60000
G1 F2590
M204 S8000
G1 X181.69 Y165.461 E.00837
G3 X184.261 Y163.46 I2.561 J.637 E.1165
G1 X184.387 Y163.463 E.00419
G3 X181.615 Y165.958 I-.137 J2.635 E.41259
G1 X181.642 Y165.77 E.00631
; COOLING_NODE: 1
M204 S10000
G1 X181.235 Y165.676 F60000
G1 F2590
M204 S8000
G3 X184.263 Y163.052 I3.016 J.422 E.14507
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X184.409 Y163.056 E.00482
G3 X181.227 Y165.736 I-.158 J3.042 E.4829
; COOLING_NODE: 1
M204 S250
G1 X180.846 Y165.609 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2590
M204 S5000
G1 X180.916 Y165.268 E.01068
G3 X184.266 Y162.66 I3.336 J.829 E.14062
G1 X184.43 Y162.665 E.00502
G3 X180.841 Y165.668 I-.178 J3.433 E.50552
; WIPE_START
G1 F9547.055
M204 S8000
G1 X180.916 Y165.268 E-.15457
G1 X181.018 Y164.923 E-.13685
G1 X181.132 Y164.646 E-.11388
G1 X181.301 Y164.328 E-.13682
G1 X181.503 Y164.03 E-.13673
G1 X181.638 Y163.865 E-.08115
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X184.081 Y165.913 Z5.4 F60000
G1 Z5
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.54132
G1 F2590
M204 S8000
G1 X183.996 Y166.061 E.00695
G1 X184.043 Y166.252 E.008
G1 X184.244 Y166.362 E.00928
G1 X184.419 Y166.287 E.00774
G1 X184.513 Y166.112 E.00809
G1 X184.412 Y165.894 E.00975
G1 X184.259 Y165.839 E.00659
G1 X184.137 Y165.89 E.0054
M204 S10000
G1 X183.654 Y165.742 F60000
; LINE_WIDTH: 0.41999
G1 F2590
M204 S8000
G1 X183.556 Y166.057 E.01013
G1 X183.616 Y166.364 E.00962
G1 X183.73 Y166.561 E.007
G1 X183.988 Y166.735 E.00957
G1 X184.257 Y166.8 E.00851
G1 X184.544 Y166.73 E.00906
G1 X184.78 Y166.538 E.00935
G1 X184.937 Y166.236 E.01046
G1 X184.95 Y166.093 E.00443
G1 X184.879 Y165.805 E.0091
G1 X184.677 Y165.542 E.01021
G1 X184.386 Y165.414 E.00977
G1 X184.135 Y165.417 E.00769
G1 X183.87 Y165.527 E.00882
G1 X183.697 Y165.7 E.00751
M204 S10000
G1 X183.429 Y165.422 F60000
G1 F2590
M204 S8000
G2 X183.206 Y166.361 I.858 J.7 E.03067
G1 X183.383 Y166.74 E.01284
G1 X183.696 Y167.023 E.01296
G1 X184.114 Y167.168 E.01361
G1 X184.376 Y167.172 E.00804
G1 X184.705 Y167.075 E.01054
G2 X185.172 Y166.655 I-.46 J-.981 E.01961
G1 X185.318 Y166.236 E.01363
G1 X185.327 Y166.076 E.00491
G1 X185.225 Y165.644 E.01363
G1 X184.965 Y165.295 E.01339
G1 X184.703 Y165.117 E.00973
G1 X184.306 Y165.02 E.01256
G1 X183.949 Y165.079 E.01112
G1 X183.662 Y165.213 E.00974
G1 X183.474 Y165.382 E.00776
M204 S10000
G1 X183.001 Y165.349 F60000
G1 F2590
M204 S8000
G1 X182.812 Y165.882 E.01737
G1 X182.836 Y166.453 E.01756
G1 X183.08 Y166.963 E.01738
G1 X183.499 Y167.349 E.01751
G1 X183.911 Y167.519 E.01369
G1 X184.29 Y167.554 E.01169
G2 X184.866 Y167.421 I-.405 J-3.076 E.01818
G1 X185.225 Y167.183 E.01324
G1 X185.499 Y166.851 E.01322
G1 X185.669 Y166.439 E.01371
G1 X185.704 Y166.06 E.01169
G2 X185.571 Y165.483 I-3.099 J.411 E.0182
G1 X185.328 Y165.117 E.01351
G1 X184.973 Y164.84 E.01382
G1 X184.629 Y164.689 E.01156
G1 X184.207 Y164.647 E.01304
G2 X183.634 Y164.779 I.414 J3.093 E.01809
G1 X183.275 Y165.017 E.01323
G1 X183.039 Y165.303 E.01139
M204 S10000
G1 X182.674 Y165.153 F60000
G1 F2590
M204 S8000
G1 X182.465 Y165.659 E.01685
G1 X182.414 Y165.994 E.01039
G1 X182.466 Y166.545 E.01702
G1 X182.676 Y167.051 E.01684
G1 X182.878 Y167.324 E.01042
G1 X183.303 Y167.676 E.01696
G1 X183.81 Y167.886 E.01686
G1 X184.307 Y167.93 E.01532
G2 X185.027 Y167.767 I-.31 J-3.033 E.02275
G1 X185.48 Y167.466 E.01671
G1 X185.826 Y167.047 E.01669
G1 X186.036 Y166.54 E.01687
G1 X186.08 Y166.043 E.01533
G2 X185.916 Y165.323 I-3.035 J.311 E.02276
G1 X185.617 Y164.87 E.01666
G1 X185.222 Y164.55 E.01565
G1 X184.878 Y164.379 E.01179
G1 X184.348 Y164.263 E.01666
G1 X183.999 Y164.278 E.01075
G1 X183.473 Y164.433 E.01685
G1 X183.02 Y164.734 E.0167
G1 X182.712 Y165.107 E.01486
; COOLING_NODE: 5
; WIPE_START
G1 F9547.299
G1 X183.02 Y164.734 E-.18372
G1 X183.473 Y164.433 E-.20648
G1 X183.999 Y164.278 E-.20835
G1 X184.348 Y164.263 E-.133
G1 X184.422 Y164.279 E-.02844
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X182.795 Y156.822 Z5.4 F60000
G1 X182.102 Y153.648 Z5.4
G1 Z5
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2590
M204 S8000
G1 X182.102 Y152.852 E.0264
G1 X187.298 Y152.852 E.17236
G1 X187.298 Y153.648 E.0264
G1 X182.162 Y153.648 E.17037
; COOLING_NODE: 5
M204 S250
G1 X181.71 Y154.04 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2590
M204 S5000
G1 X181.71 Y152.46 E.04855
G1 X187.69 Y152.46 E.18375
G1 X187.69 Y154.04 E.04855
G1 X181.77 Y154.04 E.18191
M204 S10000
G1 X182.306 Y153.25 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F2590
M204 S8000
G1 X187.094 Y153.25 E.15172
; CHANGE_LAYER
; Z_HEIGHT: 5.02857
; LAYER_HEIGHT: 0.0285716
; WIPE_START
G1 F9259.259
G1 X185.094 Y153.25 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 32/85
; update layer progress
M73 L32
M991 S0 P31 ;notify layer change

; OBJECT_ID: 15
M204 S10000
G17
G3 Z5.4 I-.062 J-1.215 P1  F60000
G1 X169.095 Y154.062 Z5.4
G1 Z5.029
G1 E.8 F1800
; FEATURE: Support
; LINE_WIDTH: 0.42
; LAYER_HEIGHT: 0.27619
G1 F2830
M204 S8000
G1 X180.961 Y154.062 E.48169
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X180.961 Y152.438 E.06589
G1 X169.039 Y152.438 E.48399
G1 X169.039 Y154.062 E.06589
; CHANGE_LAYER
; Z_HEIGHT: 5.2
; LAYER_HEIGHT: 0.171428
; WIPE_START
G1 F7226.745
G1 X169.039 Y152.438 E-.61679
G1 X169.415 Y152.438 E-.14321
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 33/85
; update layer progress
M73 L33
M991 S0 P32 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 5
M204 S10000
G17
G3 Z5.429 I-.759 J-.952 P1  F60000
G1 X167.898 Y153.648 Z5.429
G1 Z5.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
; LAYER_HEIGHT: 0.2
G1 F2830
M204 S8000
G1 X162.702 Y153.648 E.17236
G1 X162.702 Y152.852 E.0264
G1 X167.898 Y152.852 E.17236
G1 X167.898 Y153.588 E.02441
; COOLING_NODE: 5
M204 S250
G1 X168.29 Y154.04 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2608
M204 S5000
G1 X162.31 Y154.04 E.18375
G1 X162.31 Y152.46 E.04855
G1 X168.29 Y152.46 E.18375
G1 X168.29 Y153.98 E.04671
M204 S10000
G1 X167.694 Y153.25 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F2830
M204 S8000
G1 X162.906 Y153.25 E.15172
; COOLING_NODE: 4
; WIPE_START
G1 F9259.259
G1 X164.906 Y153.25 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X166.711 Y160.666 Z5.6 F60000
G1 X167.848 Y165.334 Z5.6
G1 Z5.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2830
M204 S8000
G3 X165.766 Y163.867 I-2.098 J.766 E.37549
G1 X165.865 Y163.87 E.00327
G3 X167.827 Y165.278 I-.114 J2.23 E.08465
; COOLING_NODE: 4
M204 S10000
G1 X168.232 Y165.195 F60000
G1 F2830
M204 S8000
G3 X165.769 Y163.46 I-2.48 J.904 E.44391
M73 P64 R5
G1 X165.887 Y163.463 E.00389
G3 X168.211 Y165.139 I-.135 J2.637 E.10047
; COOLING_NODE: 4
M204 S10000
G1 X168.603 Y165.032 F60000
G1 F2830
M204 S8000
G1 X168.611 Y165.058 E.00091
G3 X166.173 Y169.118 I-2.864 J1.042 E.17992
G3 X165.908 Y163.056 I-.42 J-3.018 E.3367
G3 X168.51 Y164.814 I-.161 J3.044 E.10942
G1 X168.58 Y164.976 E.00586
; COOLING_NODE: 4
M204 S250
G1 X168.965 Y164.882 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2608
M204 S5000
G1 X168.984 Y164.922 E.00139
G3 X165.776 Y162.66 I-3.232 J1.177 E.53563
G1 X165.93 Y162.665 E.00473
G3 X168.87 Y164.645 I-.177 J3.435 E.11444
G1 X168.943 Y164.826 E.00598
; WIPE_START
G1 F9547.055
M204 S8000
G1 X168.984 Y164.922 E-.03996
G1 X169.088 Y165.268 E-.13696
G1 X169.156 Y165.621 E-.1368
G1 X169.185 Y165.919 E-.11389
G1 X169.185 Y166.281 E-.13724
G1 X169.156 Y166.579 E-.11393
G1 X169.116 Y166.789 E-.08123
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X165.914 Y165.895 Z5.6 F60000
G1 Z5.2
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.54129
G1 F2830
M204 S8000
G1 X165.759 Y165.837 E.00668
G1 X165.581 Y165.913 E.00785
G1 X165.496 Y166.062 E.00698
G1 X165.551 Y166.272 E.00884
G1 X165.692 Y166.356 E.00664
G1 X165.922 Y166.299 E.00962
G1 X166.003 Y166.162 E.00646
G2 X165.939 Y165.949 I-.298 J-.027 E.00924
M204 S10000
G1 X166.334 Y165.714 F60000
; LINE_WIDTH: 0.41999
G1 F2830
M204 S8000
G1 X166.115 Y165.501 E.00938
G1 X165.828 Y165.405 E.00931
G1 X165.555 Y165.441 E.00844
G1 X165.285 Y165.584 E.00938
G1 X165.115 Y165.838 E.00939
G1 X165.056 Y166.06 E.00708
G1 X165.129 Y166.397 E.01058
G1 X165.257 Y166.596 E.00728
G1 X165.511 Y166.758 E.00924
G1 X165.763 Y166.789 E.00779
G1 X166.051 Y166.719 E.00912
G1 X166.242 Y166.597 E.00696
G1 X166.408 Y166.339 E.00943
G2 X166.434 Y166.034 I-.679 J-.211 E.00946
G1 X166.352 Y165.771 E.00847
M204 S10000
G1 X166.544 Y165.366 F60000
G1 F2830
M204 S8000
G1 X166.231 Y165.131 E.01202
G1 X165.805 Y165.02 E.01352
G1 X165.449 Y165.079 E.01112
G2 X164.766 Y165.694 I.39 J1.118 E.02896
G1 X164.673 Y166.018 E.01036
G1 X164.706 Y166.361 E.01058
G1 X164.896 Y166.757 E.01351
G1 X165.109 Y166.971 E.00926
G1 X165.488 Y167.15 E.01289
G1 X165.851 Y167.159 E.01114
G1 X166.159 Y167.083 E.00974
G1 X166.468 Y166.909 E.01092
G1 X166.732 Y166.554 E.01359
G1 X166.827 Y166.185 E.0117
G2 X166.574 Y165.418 I-1.411 J.039 E.02518
M204 S10000
G1 X166.994 Y165.338 F60000
G1 F2830
M204 S8000
G1 X166.71 Y165.008 E.01338
G1 X166.397 Y164.79 E.01171
G1 X165.945 Y164.66 E.01444
G1 X165.562 Y164.653 E.01179
G1 X165.134 Y164.779 E.0137
G1 X164.775 Y165.017 E.01322
G1 X164.501 Y165.349 E.01324
G1 X164.312 Y165.884 E.01742
G1 X164.336 Y166.453 E.0175
G1 X164.507 Y166.864 E.01368
G1 X164.781 Y167.182 E.01291
G1 X165.135 Y167.425 E.0132
G1 X165.511 Y167.534 E.01201
G2 X166.103 Y167.514 I.19 J-3.113 E.01822
G1 X166.515 Y167.343 E.01371
G1 X166.832 Y167.07 E.01287
G1 X167.075 Y166.714 E.01323
G1 X167.184 Y166.341 E.01197
G2 X167.164 Y165.747 I-3.157 J-.189 E.01827
G1 X167.017 Y165.393 E.01178
M204 S10000
G1 X167.324 Y165.15 F60000
G1 F2830
M204 S8000
G1 X166.982 Y164.745 E.01627
G1 X166.562 Y164.449 E.01578
G1 X166.047 Y164.294 E.01655
G2 X165.316 Y164.332 I-.285 J1.553 E.02269
G1 X164.973 Y164.434 E.01099
G1 X164.52 Y164.734 E.01668
G1 X164.174 Y165.153 E.0167
G1 X163.965 Y165.659 E.01685
G1 X163.914 Y165.997 E.01049
G1 X163.966 Y166.545 E.01692
G1 X164.176 Y167.051 E.01685
G1 X164.528 Y167.462 E.0166
G1 X164.975 Y167.768 E.01666
G1 X165.455 Y167.907 E.01535
G2 X166.195 Y167.884 I.276 J-3.035 E.0228
G1 X166.702 Y167.674 E.01686
G1 X167.111 Y167.323 E.01656
G1 X167.418 Y166.875 E.01671
G1 X167.557 Y166.397 E.01529
G2 X167.534 Y165.655 I-3.383 J-.266 E.02285
G1 X167.347 Y165.205 E.01498
; COOLING_NODE: 2
; WIPE_START
G1 F9547.299
G1 X167.534 Y165.655 E-.18522
G1 X167.568 Y166.015 E-.13724
G1 X167.557 Y166.397 E-.14533
G1 X167.418 Y166.875 E-.18912
G1 X167.265 Y167.099 E-.10309
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X170.502 Y165.248 Z5.6 F60000
G1 Z5.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2830
M204 S8000
G1 X170.502 Y164.452 E.0264
G1 X179.498 Y164.452 E.29841
G1 X179.498 Y165.248 E.0264
G1 X170.562 Y165.248 E.29642
; COOLING_NODE: 2
M204 S250
G1 X170.11 Y165.64 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2709
M204 S5000
G1 X170.11 Y164.06 E.04855
G1 X179.89 Y164.06 E.30051
G1 X179.89 Y165.64 E.04855
G1 X170.17 Y165.64 E.29867
M204 S10000
G1 X170.706 Y164.85 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F2830
M204 S8000
G1 X179.294 Y164.85 E.27211
; COOLING_NODE: 1
; WIPE_START
G1 F9259.259
G1 X177.294 Y164.85 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X182.053 Y165.756 Z5.6 F60000
G1 Z5.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2830
M204 S8000
G1 X182.084 Y165.559 E.00661
G3 X184.266 Y163.867 I2.167 J.54 E.09876
G1 X184.365 Y163.87 E.00327
G3 X182.021 Y165.977 I-.114 J2.23 E.34933
G1 X182.045 Y165.816 E.00542
; COOLING_NODE: 1
M204 S10000
G1 X181.638 Y165.732 F60000
G1 F2830
M204 S8000
G3 X184.387 Y163.463 I2.615 J.368 E.1298
G3 X184.616 Y168.715 I-.139 J2.637 E.25833
G3 X181.63 Y165.792 I-.363 J-2.615 E.15992
; COOLING_NODE: 1
M204 S10000
G1 X181.234 Y165.667 F60000
G1 F2830
M204 S8000
G1 X181.295 Y165.363 E.01031
G3 X184.273 Y163.052 I2.957 J.737 E.13478
G1 X184.408 Y163.056 E.0045
G3 X181.228 Y165.727 I-.156 J3.043 E.48355
; COOLING_NODE: 1
M204 S250
G1 X180.855 Y165.57 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2608
M204 S5000
G1 X180.874 Y165.444 E.00393
G3 X184.43 Y162.665 I3.377 J.656 E.15123
G3 X184.584 Y169.524 I-.181 J3.435 E.31619
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G3 X180.824 Y165.801 I-.333 J-3.424 E.18548
G1 X180.847 Y165.63 E.0053
; WIPE_START
G1 F9547.055
M204 S8000
G1 X180.874 Y165.444 E-.07135
G1 X180.96 Y165.094 E-.13685
G1 X181.07 Y164.787 E-.12385
G1 X181.213 Y164.485 E-.12688
G1 X181.398 Y164.176 E-.137
G1 X181.576 Y163.935 E-.11384
G1 X181.665 Y163.837 E-.05022
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X184.037 Y165.946 Z5.6 F60000
G1 Z5.2
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.54119
G1 F2830
M204 S8000
G1 X183.998 Y166.08 E.00565
G1 X184.052 Y166.272 E.00812
G1 X184.192 Y166.356 E.00664
G1 X184.402 Y166.307 E.00876
G1 X184.504 Y166.139 E.00798
G1 X184.498 Y166.075 E.00258
G1 X184.412 Y165.891 E.00826
G1 X184.259 Y165.837 E.00656
G1 X184.091 Y165.92 E.0076
M204 S10000
G1 X183.763 Y165.598 F60000
; LINE_WIDTH: 0.41999
G1 F2830
M204 S8000
G1 X183.592 Y165.861 E.00962
G1 X183.562 Y166.121 E.00804
G1 X183.647 Y166.44 E.01016
G1 X183.788 Y166.624 E.0071
G1 X184.039 Y166.768 E.0089
G1 X184.315 Y166.784 E.00851
G1 X184.641 Y166.682 E.01048
G1 X184.846 Y166.457 E.00934
G1 X184.944 Y166.143 E.0101
G1 X184.934 Y166.034 E.00336
G1 X184.834 Y165.714 E.01031
G1 X184.614 Y165.502 E.00937
G1 X184.328 Y165.405 E.00931
G1 X184.053 Y165.442 E.0085
G1 X183.815 Y165.57 E.0083
M204 S10000
G1 X183.379 Y165.459 F60000
G1 F2830
M204 S8000
G1 X183.2 Y165.839 E.01288
G1 X183.191 Y166.201 E.01113
G1 X183.268 Y166.509 E.00976
G1 X183.444 Y166.822 E.01104
G1 X183.796 Y167.082 E.01344
G1 X184.167 Y167.177 E.01178
G1 X184.51 Y167.144 E.01059
G1 X184.889 Y166.967 E.01284
G1 X185.173 Y166.654 E.01299
G1 X185.315 Y166.261 E.01283
G2 X185.042 Y165.363 I-1.418 J-.06 E.02938
G1 X184.728 Y165.13 E.01203
G1 X184.305 Y165.02 E.01343
G1 X183.947 Y165.08 E.01117
G2 X183.424 Y165.42 I.325 J1.072 E.01941
M204 S10000
G1 X182.992 Y165.372 F60000
G1 F2830
M204 S8000
G1 X182.833 Y165.747 E.01251
G2 X182.836 Y166.453 I2.242 J.343 E.02178
G1 X183.007 Y166.864 E.01368
G1 X183.281 Y167.182 E.01291
G1 X183.635 Y167.425 E.0132
G1 X184.011 Y167.534 E.01201
G2 X184.603 Y167.514 I.19 J-3.115 E.01822
G1 X185.113 Y167.271 E.01737
G1 X185.499 Y166.85 E.01755
G1 X185.688 Y166.318 E.01736
G2 X185.494 Y165.338 I-1.649 J-.183 E.03117
G1 X185.222 Y165.018 E.0129
G1 X184.895 Y164.789 E.01227
G1 X184.445 Y164.66 E.01437
G1 X184.062 Y164.653 E.01179
G1 X183.634 Y164.779 E.01371
G1 X183.268 Y165.021 E.01347
G1 X183.029 Y165.325 E.01187
M204 S10000
G1 X182.684 Y165.153 F60000
G1 F2830
M204 S8000
G1 X182.465 Y165.655 E.01683
G1 X182.414 Y165.994 E.01053
G1 X182.466 Y166.545 E.01701
G1 X182.676 Y167.051 E.01685
G1 X182.998 Y167.434 E.01537
G1 X183.33 Y167.682 E.01273
G1 X183.805 Y167.885 E.01587
G1 X184.147 Y167.936 E.01062
G1 X184.695 Y167.884 E.01692
G1 X185.202 Y167.674 E.01687
G1 X185.473 Y167.474 E.01035
G1 X185.826 Y167.047 E.01703
G1 X186.036 Y166.54 E.01685
G2 X186.06 Y165.929 I-1.216 J-.355 E.019
G1 X186.034 Y165.655 E.00843
G1 X185.824 Y165.15 E.01682
G1 X185.483 Y164.745 E.01625
G1 X185.061 Y164.449 E.01585
G1 X184.547 Y164.294 E.01652
G2 X183.816 Y164.332 I-.285 J1.553 E.0227
G1 X183.473 Y164.433 E.01098
G1 X183.021 Y164.732 E.01665
G1 X182.722 Y165.106 E.0147
; COOLING_NODE: 5
; WIPE_START
G1 F9547.299
G1 X183.021 Y164.732 E-.18182
G1 X183.473 Y164.433 E-.20594
G1 X183.816 Y164.332 E-.13583
G1 X184.19 Y164.27 E-.14421
G1 X184.432 Y164.286 E-.09219
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X182.799 Y156.831 Z5.6 F60000
G1 X182.102 Y153.648 Z5.6
G1 Z5.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2830
M204 S8000
G1 X182.102 Y152.852 E.0264
G1 X187.298 Y152.852 E.17236
G1 X187.298 Y153.648 E.0264
G1 X182.162 Y153.648 E.17037
; COOLING_NODE: 5
M204 S250
G1 X181.71 Y154.04 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2608
M204 S5000
G1 X181.71 Y152.46 E.04855
G1 X187.69 Y152.46 E.18375
G1 X187.69 Y154.04 E.04855
G1 X181.77 Y154.04 E.18191
M204 S10000
G1 X182.306 Y153.25 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F2830
M204 S8000
G1 X187.094 Y153.25 E.15172
; CHANGE_LAYER
; Z_HEIGHT: 5.30476
; LAYER_HEIGHT: 0.104762
; WIPE_START
G1 F9259.259
G1 X185.094 Y153.25 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 34/85
; update layer progress
M73 L34
M991 S0 P33 ;notify layer change

; OBJECT_ID: 15
M204 S10000
G17
G3 Z5.6 I-.062 J-1.215 P1  F60000
G1 X169.095 Y154.062 Z5.6
G1 Z5.305
G1 E.8 F1800
; FEATURE: Support
; LINE_WIDTH: 0.42
; LAYER_HEIGHT: 0.27619
G1 F2826
M204 S8000
G1 X180.961 Y154.062 E.48169
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X180.961 Y152.438 E.06589
G1 X169.039 Y152.438 E.48399
G1 X169.039 Y154.062 E.06589
; CHANGE_LAYER
; Z_HEIGHT: 5.4
; LAYER_HEIGHT: 0.0952382
; WIPE_START
G1 F7226.745
G1 X169.039 Y152.438 E-.61679
G1 X169.415 Y152.438 E-.14321
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 35/85
; update layer progress
M73 L35
M991 S0 P34 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 5
M204 S10000
G17
G3 Z5.705 I-.759 J-.952 P1  F60000
G1 X167.898 Y153.648 Z5.705
G1 Z5.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
; LAYER_HEIGHT: 0.2
G1 F2826
M204 S8000
G1 X162.702 Y153.648 E.17236
G1 X162.702 Y152.852 E.0264
G1 X167.898 Y152.852 E.17236
G1 X167.898 Y153.588 E.02441
; COOLING_NODE: 5
M204 S250
G1 X168.29 Y154.04 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2572
M204 S5000
G1 X162.31 Y154.04 E.18375
G1 X162.31 Y152.46 E.04855
G1 X168.29 Y152.46 E.18375
G1 X168.29 Y153.98 E.04671
M204 S10000
G1 X167.694 Y153.25 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F2826
M204 S8000
G1 X162.906 Y153.25 E.15172
; COOLING_NODE: 4
; WIPE_START
G1 F9259.259
G1 X164.906 Y153.25 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X166.709 Y160.666 Z5.8 F60000
G1 X167.836 Y165.301 Z5.8
G1 Z5.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2826
M204 S8000
G3 X165.775 Y163.867 I-2.085 J.799 E.37695
G1 X165.864 Y163.87 E.00295
G3 X167.814 Y165.245 I-.113 J2.23 E.08354
; COOLING_NODE: 4
M204 S10000
G1 X168.217 Y165.155 F60000
G1 F2826
M204 S8000
G3 X165.778 Y163.46 I-2.465 J.945 E.44566
M73 P65 R5
G1 X165.886 Y163.463 E.00357
G3 X168.195 Y165.099 I-.134 J2.637 E.09906
; COOLING_NODE: 4
M204 S10000
G1 X168.597 Y165.008 F60000
G1 F2826
M204 S8000
G3 X165.782 Y163.053 I-2.845 J1.092 E.51438
G1 X165.908 Y163.056 E.00418
G3 X168.575 Y164.952 I-.156 J3.043 E.11458
; COOLING_NODE: 4
M204 S250
G1 X168.966 Y164.88 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2572
M204 S5000
G1 X169.059 Y165.15 E.00879
G3 X165.785 Y162.66 I-3.306 J.949 E.52859
G1 X165.929 Y162.665 E.00442
G3 X168.947 Y164.823 I-.177 J3.435 E.1204
; WIPE_START
G1 F9547.055
M204 S8000
G1 X169.059 Y165.15 E-.13139
G1 X169.138 Y165.503 E-.1372
G1 X169.177 Y165.799 E-.11356
G1 X169.189 Y166.16 E-.1375
G1 X169.164 Y166.519 E-.13671
G1 X169.119 Y166.788 E-.10366
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X166.012 Y166.08 Z5.8 F60000
G1 Z5.4
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.540546
G1 F2826
M204 S8000
G1 X165.869 Y165.865 E.01049
G1 X165.691 Y165.844 E.00727
G1 X165.543 Y165.937 E.00706
G2 X165.544 Y166.257 I.256 J.16 E.01364
G1 X165.734 Y166.362 E.00881
G1 X165.902 Y166.313 E.0071
G1 X166 Y166.136 E.00819
M204 S10000
G1 X166.389 Y165.844 F60000
; LINE_WIDTH: 0.41999
G1 F2826
M204 S8000
G1 X166.203 Y165.581 E.0099
G1 X165.989 Y165.442 E.00781
G1 X165.716 Y165.401 E.00849
G1 X165.459 Y165.464 E.00814
G1 X165.199 Y165.663 E.01005
G1 X165.064 Y165.965 E.01016
G1 X165.072 Y166.254 E.00889
G1 X165.215 Y166.552 E.01016
G1 X165.51 Y166.745 E.01085
G1 X165.751 Y166.799 E.00757
G1 X166.027 Y166.741 E.00868
G1 X166.246 Y166.583 E.00829
G1 X166.412 Y166.301 E.01004
G1 X166.45 Y166.069 E.00722
G1 X166.405 Y165.902 E.00532
M204 S10000
G1 X166.619 Y165.466 F60000
G1 F2826
M204 S8000
G1 X166.292 Y165.169 E.01356
G1 X166.03 Y165.055 E.00879
G1 X165.6 Y165.029 E.01324
G1 X165.204 Y165.167 E.01287
G1 X164.898 Y165.434 E.0125
G1 X164.706 Y165.817 E.01318
G1 X164.688 Y166.182 E.01123
G1 X164.767 Y166.507 E.01025
G1 X164.937 Y166.811 E.01073
G1 X165.175 Y167.011 E.00954
G1 X165.596 Y167.165 E.01376
G1 X165.913 Y167.17 E.00977
G1 X166.29 Y167.037 E.01228
G1 X166.563 Y166.792 E.01126
G1 X166.726 Y166.525 E.00962
G1 X166.829 Y166.174 E.01122
G2 X166.646 Y165.519 I-1.161 J-.029 E.02121
M204 S10000
G1 X166.928 Y165.242 F60000
G1 F2826
M204 S8000
G1 X166.615 Y164.924 E.01372
G1 X166.254 Y164.736 E.01251
G1 X165.826 Y164.641 E.01347
G1 X165.413 Y164.686 E.01275
G1 X165.012 Y164.84 E.0132
G1 X164.681 Y165.113 E.0132
G1 X164.435 Y165.464 E.01317
G1 X164.32 Y165.843 E.01215
G2 X164.329 Y166.427 I2.872 J.244 E.01798
G1 X164.494 Y166.844 E.01378
G2 X164.975 Y167.335 I1.729 J-1.211 E.02121
G1 X165.385 Y167.513 E.01373
G1 X165.844 Y167.55 E.01417
G1 X166.198 Y167.491 E.01101
G1 X166.591 Y167.284 E.01365
G2 X167.163 Y166.464 I-.959 J-1.278 E.03126
G1 X167.203 Y166.051 E.01275
G1 X167.139 Y165.654 E.01235
G1 X166.956 Y165.296 E.01237
M204 S10000
G1 X167.237 Y165.019 F60000
G1 F2826
M204 S8000
G1 X166.851 Y164.627 E.01692
G1 X166.386 Y164.383 E.01614
G1 X165.847 Y164.263 E.01696
G1 X165.328 Y164.318 E.01605
G1 X164.82 Y164.513 E.0167
G1 X164.403 Y164.857 E.0166
G1 X164.095 Y165.297 E.01652
G1 X163.948 Y165.781 E.01555
G2 X163.958 Y166.513 I2.995 J.323 E.02254
G1 X164.161 Y167.027 E.01697
G1 X164.382 Y167.33 E.01152
G1 X164.775 Y167.659 E.01575
G1 X165.278 Y167.877 E.01685
G1 X165.795 Y167.929 E.01598
G1 X166.318 Y167.85 E.01625
G2 X167.309 Y167.075 I-.681 J-1.892 E.03931
G1 X167.528 Y166.571 E.01687
G1 X167.581 Y166.056 E.01591
G1 X167.497 Y165.525 E.01653
G1 X167.265 Y165.072 E.01562
; COOLING_NODE: 2
; WIPE_START
G1 F9547.299
G1 X167.497 Y165.525 E-.19316
G1 X167.581 Y166.056 E-.20448
G1 X167.528 Y166.571 E-.19682
G1 X167.354 Y166.971 E-.16555
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X170.502 Y165.248 Z5.8 F60000
G1 Z5.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2826
M204 S8000
G1 X170.502 Y164.452 E.0264
G1 X179.498 Y164.452 E.29841
G1 X179.498 Y165.248 E.0264
G1 X170.562 Y165.248 E.29642
; COOLING_NODE: 2
M204 S250
G1 X170.11 Y165.64 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2718
M204 S5000
G1 X170.11 Y164.06 E.04855
G1 X179.89 Y164.06 E.30051
G1 X179.89 Y165.64 E.04855
G1 X170.17 Y165.64 E.29867
M204 S10000
G1 X170.706 Y164.85 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F2826
M204 S8000
G1 X179.294 Y164.85 E.27211
; COOLING_NODE: 1
; WIPE_START
G1 F9259.259
G1 X177.294 Y164.85 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X182.06 Y165.679 Z5.8 F60000
G1 Z5.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2826
M204 S8000
G1 X182.065 Y165.642 E.00124
G3 X184.275 Y163.867 I2.186 J.458 E.10185
G1 X184.364 Y163.87 E.00295
G3 X182.018 Y166.061 I-.113 J2.23 E.34663
G1 X182.053 Y165.739 E.01074
; COOLING_NODE: 1
M204 S10000
G1 X181.657 Y165.635 F60000
G1 F2826
M204 S8000
G1 X181.668 Y165.556 E.00264
G3 X184.278 Y163.46 I2.584 J.544 E.12029
G1 X184.386 Y163.463 E.00357
G3 X181.612 Y166.053 I-.134 J2.637 E.40979
G1 X181.651 Y165.694 E.01198
; COOLING_NODE: 1
M204 S10000
G1 X181.241 Y165.631 F60000
G1 F2826
M204 S8000
G1 X181.271 Y165.47 E.00542
G3 X184.282 Y163.053 I2.981 J.63 E.13872
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X184.408 Y163.056 E.00418
G3 X181.227 Y165.729 I-.156 J3.043 E.48352
G1 X181.233 Y165.69 E.0013
; COOLING_NODE: 1
M204 S250
G1 X180.855 Y165.566 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2572
M204 S5000
G1 X180.888 Y165.387 E.00561
G3 X184.285 Y162.66 I3.365 J.713 E.14494
G1 X184.429 Y162.665 E.00442
G3 X180.839 Y165.681 I-.177 J3.435 E.5055
G1 X180.847 Y165.626 E.00171
; WIPE_START
G1 F9547.055
M204 S8000
G1 X180.888 Y165.387 E-.09219
G1 X180.978 Y165.037 E-.13723
G1 X181.098 Y164.723 E-.12755
G1 X181.241 Y164.432 E-.12332
G1 X181.432 Y164.127 E-.13692
G1 X181.614 Y163.889 E-.11369
G1 X181.667 Y163.833 E-.0291
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X183.997 Y166.028 Z5.8 F60000
G1 Z5.4
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.54131
G1 F2826
M204 S8000
G1 X184.044 Y166.257 E.00947
G1 X184.234 Y166.361 E.00881
G1 X184.401 Y166.312 E.0071
G1 X184.498 Y166.129 E.0084
G1 X184.455 Y165.953 E.00734
G1 X184.307 Y165.845 E.00748
G1 X184.12 Y165.872 E.00768
G1 X184.034 Y165.981 E.00561
M204 S10000
G1 X183.699 Y165.663 F60000
; LINE_WIDTH: 0.41999
G1 F2826
M204 S8000
G1 X183.564 Y165.961 E.01007
G1 X183.573 Y166.256 E.00905
G1 X183.715 Y166.552 E.0101
G1 X184.01 Y166.745 E.01084
G1 X184.251 Y166.799 E.00757
G1 X184.528 Y166.741 E.00868
G1 X184.746 Y166.583 E.00829
G1 X184.921 Y166.28 E.01075
G2 X184.906 Y165.87 I-1.011 J-.167 E.01268
G1 X184.721 Y165.599 E.0101
G1 X184.519 Y165.453 E.00765
G1 X184.216 Y165.401 E.00943
G1 X183.959 Y165.464 E.00814
G1 X183.747 Y165.626 E.00821
M204 S10000
G1 X183.275 Y165.631 F60000
G1 F2826
M204 S8000
G1 X183.175 Y166.001 E.01178
G1 X183.201 Y166.342 E.0105
G1 X183.383 Y166.737 E.01338
G1 X183.675 Y167.011 E.01228
G1 X184.096 Y167.165 E.01377
G1 X184.413 Y167.17 E.00976
G1 X184.79 Y167.037 E.01228
G1 X185.063 Y166.792 E.01126
G2 X184.995 Y165.34 I-.827 J-.689 E.04902
G1 X184.725 Y165.128 E.01056
G1 X184.304 Y165.019 E.01334
G1 X183.901 Y165.076 E.01253
G1 X183.518 Y165.303 E.01367
G1 X183.311 Y165.583 E.01069
M204 S10000
G1 X182.935 Y165.464 F60000
G1 F2826
M204 S8000
G1 X182.82 Y165.837 E.01199
G2 X182.83 Y166.428 I3.065 J.244 E.01818
G1 X182.994 Y166.843 E.01374
G2 X183.475 Y167.335 I1.728 J-1.209 E.02121
G1 X183.885 Y167.513 E.01374
G1 X184.344 Y167.55 E.01417
G1 X184.698 Y167.491 E.01101
G1 X185.091 Y167.284 E.01365
G2 X185.485 Y166.875 I-1.696 J-2.025 E.01748
G1 X185.657 Y166.477 E.01333
G1 X185.707 Y166.049 E.01324
G1 X185.626 Y165.621 E.01339
G1 X185.43 Y165.244 E.01307
G1 X185.115 Y164.924 E.01379
G1 X184.754 Y164.736 E.01251
G1 X184.326 Y164.641 E.01347
G1 X183.913 Y164.686 E.01276
G1 X183.512 Y164.84 E.01318
G1 X183.181 Y165.113 E.0132
G1 X182.97 Y165.415 E.01132
M204 S10000
G1 X182.595 Y165.297 F60000
G1 F2826
M204 S8000
G1 X182.448 Y165.775 E.01535
G2 X182.458 Y166.513 I3.027 J.328 E.02275
G1 X182.661 Y167.027 E.01696
G1 X182.882 Y167.33 E.01153
G1 X183.274 Y167.659 E.01573
G1 X183.778 Y167.877 E.01686
G1 X184.295 Y167.929 E.01598
G1 X184.818 Y167.85 E.01625
G2 X185.809 Y167.075 I-.681 J-1.892 E.0393
G1 X186.026 Y166.576 E.01673
G1 X186.088 Y166.036 E.01671
G1 X185.987 Y165.496 E.01686
G1 X185.738 Y165.02 E.01653
G1 X185.351 Y164.627 E.01695
G1 X184.886 Y164.383 E.01613
G1 X184.347 Y164.263 E.01696
G1 X183.828 Y164.318 E.01605
G1 X183.32 Y164.513 E.0167
G1 X182.903 Y164.857 E.0166
G1 X182.629 Y165.248 E.01468
; COOLING_NODE: 5
; WIPE_START
G1 F9547.299
G1 X182.903 Y164.857 E-.18152
G1 X183.32 Y164.513 E-.20534
G1 X183.828 Y164.318 E-.2065
G1 X184.264 Y164.272 E-.16663
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X182.742 Y156.792 Z5.8 F60000
G1 X182.102 Y153.648 Z5.8
G1 Z5.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2826
M204 S8000
G1 X182.102 Y152.852 E.0264
G1 X187.298 Y152.852 E.17236
G1 X187.298 Y153.648 E.0264
G1 X182.162 Y153.648 E.17037
; COOLING_NODE: 5
M204 S250
G1 X181.71 Y154.04 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2572
M204 S5000
G1 X181.71 Y152.46 E.04855
G1 X187.69 Y152.46 E.18375
G1 X187.69 Y154.04 E.04855
G1 X181.77 Y154.04 E.18191
M204 S10000
G1 X182.306 Y153.25 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F2826
M204 S8000
G1 X187.094 Y153.25 E.15172
; CHANGE_LAYER
; Z_HEIGHT: 5.58095
; LAYER_HEIGHT: 0.180952
; WIPE_START
G1 F9259.259
G1 X185.094 Y153.25 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 36/85
; update layer progress
M73 L36
M991 S0 P35 ;notify layer change

; OBJECT_ID: 15
M204 S10000
G17
G3 Z5.8 I-.062 J-1.215 P1  F60000
G1 X169.095 Y154.062 Z5.8
G1 Z5.581
G1 E.8 F1800
; FEATURE: Support
; LINE_WIDTH: 0.42
; LAYER_HEIGHT: 0.27619
G1 F2826
M204 S8000
G1 X180.961 Y154.062 E.48169
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X180.961 Y152.438 E.06589
G1 X169.039 Y152.438 E.48399
G1 X169.039 Y154.062 E.06589
; CHANGE_LAYER
; Z_HEIGHT: 5.6
; LAYER_HEIGHT: 0.0190477
; WIPE_START
G1 F7226.745
G1 X169.039 Y152.438 E-.61679
G1 X169.415 Y152.438 E-.14321
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 37/85
; update layer progress
M73 L37
M991 S0 P36 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 5
M204 S10000
G17
G3 Z5.981 I-.759 J-.952 P1  F60000
G1 X167.898 Y153.648 Z5.981
G1 Z5.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
; LAYER_HEIGHT: 0.2
G1 F2826
M204 S8000
G1 X162.702 Y153.648 E.17236
G1 X162.702 Y152.852 E.0264
G1 X167.898 Y152.852 E.17236
G1 X167.898 Y153.588 E.02441
; COOLING_NODE: 5
M204 S250
G1 X168.29 Y154.04 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2524
M204 S5000
G1 X162.31 Y154.04 E.18375
G1 X162.31 Y152.46 E.04855
G1 X168.29 Y152.46 E.18375
G1 X168.29 Y153.98 E.04671
M204 S10000
G1 X167.694 Y153.25 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F2826
M204 S8000
G1 X162.906 Y153.25 E.15172
; COOLING_NODE: 4
; WIPE_START
G1 F9259.259
G1 X164.906 Y153.25 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X166.709 Y160.666 Z6 F60000
G1 X167.835 Y165.299 Z6
G1 Z5.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2826
M204 S8000
G3 X165.782 Y163.867 I-2.085 J.8 E.37724
G1 X165.863 Y163.869 E.00268
G3 X167.813 Y165.244 I-.112 J2.23 E.08351
; COOLING_NODE: 4
M204 S10000
G1 X168.216 Y165.153 F60000
G1 F2826
M204 S8000
G3 X165.786 Y163.46 I-2.465 J.946 E.44596
M73 P66 R5
G1 X165.885 Y163.463 E.00328
G3 X168.194 Y165.097 I-.134 J2.637 E.09903
; COOLING_NODE: 4
M204 S10000
G1 X168.597 Y165.007 F60000
G1 F2826
M204 S8000
G3 X165.791 Y163.053 I-2.845 J1.092 E.51469
G1 X165.908 Y163.056 E.00388
G3 X168.575 Y164.951 I-.156 J3.043 E.11456
; COOLING_NODE: 4
M204 S250
G1 X168.965 Y164.879 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2524
M204 S5000
G1 X169.058 Y165.15 E.0088
G3 X165.795 Y162.66 I-3.306 J.949 E.52888
G1 X165.929 Y162.665 E.00412
G3 X168.946 Y164.823 I-.177 J3.435 E.12037
; WIPE_START
G1 F9547.055
M204 S8000
G1 X169.058 Y165.15 E-.13158
G1 X169.138 Y165.503 E-.1373
G1 X169.18 Y165.845 E-.13123
G1 X169.189 Y166.161 E-.11985
G1 X169.164 Y166.519 E-.13672
G1 X169.117 Y166.787 E-.10333
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X165.94 Y165.935 Z6 F60000
G1 Z5.6
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.54126
G1 F2826
M204 S8000
G1 X165.749 Y165.837 E.0087
G1 X165.596 Y165.904 E.00682
G1 X165.491 Y166.057 E.00752
G2 X165.59 Y166.309 I.434 J-.025 E.01117
G1 X165.827 Y166.351 E.00978
G1 X165.969 Y166.228 E.00759
G1 X166.012 Y166.113 E.00502
G1 X165.963 Y165.99 E.00535
M204 S10000
G1 X166.385 Y165.817 F60000
; LINE_WIDTH: 0.41999
G1 F2826
M204 S8000
G1 X166.197 Y165.578 E.00935
G1 X165.9 Y165.416 E.01038
G1 X165.596 Y165.417 E.00934
G1 X165.36 Y165.532 E.00806
G1 X165.136 Y165.781 E.01028
G1 X165.049 Y166.05 E.00871
G1 X165.115 Y166.382 E.01038
G1 X165.317 Y166.654 E.01043
G1 X165.63 Y166.784 E.01041
G1 X165.965 Y166.769 E.0103
G1 X166.183 Y166.651 E.00763
G1 X166.382 Y166.375 E.01045
G1 X166.45 Y166.101 E.00867
G1 X166.398 Y165.876 E.0071
M204 S10000
G1 X166.562 Y165.394 F60000
G1 F2826
M204 S8000
G1 X166.32 Y165.187 E.00979
G1 X165.894 Y165.034 E.01394
G1 X165.6 Y165.029 E.00901
G1 X165.232 Y165.152 E.01194
G1 X164.963 Y165.366 E.01055
G1 X164.732 Y165.748 E.01371
G1 X164.673 Y166.104 E.0111
G1 X164.767 Y166.537 E.01361
G1 X165.028 Y166.899 E.01373
G1 X165.234 Y167.049 E.00784
G1 X165.564 Y167.16 E.01067
G1 X166.003 Y167.147 E.01351
G1 X166.294 Y167.034 E.00959
G1 X166.566 Y166.784 E.01136
G1 X166.727 Y166.527 E.0093
G1 X166.829 Y166.171 E.01138
G1 X166.827 Y166.091 E.00246
G1 X166.733 Y165.662 E.01349
G1 X166.594 Y165.445 E.00793
M204 S10000
G1 X166.85 Y165.144 F60000
G1 F2826
M204 S8000
G1 X166.522 Y164.864 E.01325
G1 X166.112 Y164.686 E.01373
G1 X165.677 Y164.648 E.01341
G1 X165.274 Y164.719 E.01257
G2 X164.684 Y165.106 I.933 J2.067 E.02177
G1 X164.43 Y165.477 E.01383
G1 X164.312 Y165.883 E.01299
G1 X164.3 Y166.263 E.01166
G1 X164.418 Y166.692 E.01369
G1 X164.662 Y167.073 E.01388
G1 X165.07 Y167.391 E.01591
G1 X165.497 Y167.535 E.01384
G1 X165.941 Y167.547 E.01365
G1 X166.375 Y167.411 E.01397
G1 X166.696 Y167.211 E.01163
G1 X166.988 Y166.871 E.01377
G1 X167.156 Y166.49 E.0128
G1 X167.204 Y166.082 E.01262
G2 X167.082 Y165.507 I-3.109 J.362 E.01807
G1 X166.882 Y165.195 E.01139
M204 S10000
G1 X167.138 Y164.894 F60000
G1 F2826
M204 S8000
G1 X166.724 Y164.54 E.01672
G1 X166.218 Y164.321 E.01695
G1 X165.679 Y164.27 E.01664
G1 X165.151 Y164.361 E.01646
G1 X164.836 Y164.504 E.01064
G1 X164.405 Y164.846 E.01689
G1 X164.093 Y165.303 E.017
G1 X163.944 Y165.8 E.01597
G1 X163.924 Y166.318 E.01593
G1 X164.07 Y166.848 E.01687
G1 X164.369 Y167.315 E.01706
G1 X164.743 Y167.63 E.01503
G2 X165.431 Y167.911 I1.491 J-2.666 E.02287
G1 X165.978 Y167.925 E.01682
G1 X166.468 Y167.783 E.01567
G2 X167.076 Y167.347 I-.592 J-1.468 E.02323
G1 X167.31 Y167.074 E.01103
G1 X167.52 Y166.6 E.01592
G1 X167.581 Y166.072 E.01633
G2 X167.43 Y165.352 I-3.181 J.292 E.02264
G1 X167.17 Y164.945 E.01485
; COOLING_NODE: 2
; WIPE_START
G1 F9547.299
G1 X167.43 Y165.352 E-.18371
G1 X167.52 Y165.678 E-.12821
G1 X167.581 Y166.072 E-.15162
G1 X167.52 Y166.6 E-.20196
G1 X167.419 Y166.827 E-.09449
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X170.502 Y165.248 Z6 F60000
G1 Z5.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2826
M204 S8000
G1 X170.502 Y164.452 E.0264
G1 X179.498 Y164.452 E.29841
G1 X179.498 Y165.248 E.0264
G1 X170.562 Y165.248 E.29642
; COOLING_NODE: 2
M204 S250
G1 X170.11 Y165.64 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2726
M204 S5000
G1 X170.11 Y164.06 E.04855
G1 X179.89 Y164.06 E.30051
G1 X179.89 Y165.64 E.04855
G1 X170.17 Y165.64 E.29867
M204 S10000
G1 X170.706 Y164.85 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F2826
M204 S8000
G1 X179.294 Y164.85 E.27211
; COOLING_NODE: 1
; WIPE_START
G1 F9259.259
G1 X177.294 Y164.85 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X182.063 Y165.679 Z6 F60000
G1 Z5.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2826
M204 S8000
G1 X182.073 Y165.604 E.00251
G3 X184.282 Y163.867 I2.177 J.495 E.10082
G1 X184.363 Y163.869 E.00268
G3 X182.018 Y166.061 I-.112 J2.23 E.34664
G1 X182.056 Y165.739 E.01075
; COOLING_NODE: 1
M204 S10000
G1 X181.644 Y165.691 F60000
G1 F2826
M204 S8000
G1 X181.677 Y165.516 E.00593
G3 X184.286 Y163.46 I2.575 J.584 E.11918
G1 X184.385 Y163.463 E.00328
G3 X181.631 Y165.778 I-.134 J2.637 E.41895
G1 X181.635 Y165.751 E.00092
; COOLING_NODE: 1
M204 S10000
G1 X181.244 Y165.621 F60000
G1 F2826
M204 S8000
G1 X181.28 Y165.427 E.00657
G3 X184.291 Y163.053 I2.972 J.673 E.13756
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X184.408 Y163.056 E.00388
G3 X181.227 Y165.728 I-.156 J3.043 E.48351
G1 X181.235 Y165.681 E.0016
; COOLING_NODE: 1
M204 S250
G1 X180.858 Y165.554 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2524
M204 S5000
G1 X180.898 Y165.341 E.00666
G3 X184.295 Y162.66 I3.355 J.758 E.14382
G1 X184.429 Y162.665 E.00412
G3 X180.839 Y165.681 I-.177 J3.435 E.50548
G1 X180.849 Y165.613 E.00209
; WIPE_START
G1 F9547.055
M204 S8000
G1 X180.898 Y165.341 E-.10509
G1 X180.978 Y165.037 E-.11966
G1 X181.108 Y164.7 E-.1371
G1 X181.241 Y164.433 E-.11358
G1 X181.433 Y164.126 E-.13732
G1 X181.615 Y163.889 E-.11349
G1 X181.675 Y163.824 E-.03376
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X182.593 Y165.303 Z6 F60000
G1 Z5.6
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F2826
M204 S8000
G1 X182.442 Y165.808 E.01621
G1 X182.424 Y166.323 E.01583
G1 X182.567 Y166.82 E.01587
G1 X182.653 Y167.012 E.00646
G1 X182.996 Y167.445 E.017
G1 X183.413 Y167.737 E.01562
G1 X183.93 Y167.911 E.01678
G1 X184.478 Y167.925 E.01683
G1 X184.968 Y167.783 E.01567
G2 X185.576 Y167.347 I-.592 J-1.468 E.02323
G1 X185.81 Y167.074 E.01105
G1 X186.018 Y166.607 E.01571
G1 X186.085 Y166.228 E.01181
G1 X186.072 Y165.845 E.01178
G1 X185.931 Y165.353 E.01573
G1 X185.637 Y164.894 E.01675
G1 X185.224 Y164.541 E.0167
G1 X184.718 Y164.321 E.01695
G1 X184.179 Y164.27 E.01663
G1 X183.651 Y164.361 E.01647
G1 X183.336 Y164.504 E.01064
G1 X182.905 Y164.846 E.01688
G1 X182.627 Y165.253 E.01517
M204 S10000
G1 X182.93 Y165.477 F60000
G1 F2826
M204 S8000
G1 X182.814 Y165.87 E.01259
G1 X182.8 Y166.278 E.01252
G1 X182.912 Y166.667 E.01244
G2 X183.258 Y167.168 I2.684 J-1.481 E.01874
G1 X183.584 Y167.397 E.01225
G1 X183.997 Y167.535 E.01337
G1 X184.441 Y167.547 E.01366
G1 X184.875 Y167.411 E.01397
G1 X185.196 Y167.211 E.01163
G1 X185.488 Y166.87 E.0138
G1 X185.655 Y166.495 E.0126
G1 X185.702 Y166.064 E.01332
G2 X185.583 Y165.51 I-2.635 J.276 E.01746
G1 X185.35 Y165.144 E.01334
G1 X185.022 Y164.864 E.01324
G1 X184.612 Y164.686 E.01374
G1 X184.177 Y164.648 E.01341
G1 X183.774 Y164.719 E.01258
G2 X183.184 Y165.106 I.933 J2.066 E.02176
G1 X182.964 Y165.428 E.01199
M204 S10000
G1 X183.463 Y165.366 F60000
G1 F2826
M204 S8000
G1 X183.232 Y165.748 E.01372
G1 X183.171 Y166.024 E.0087
G1 X183.22 Y166.43 E.01258
G1 X183.416 Y166.761 E.01182
G2 X184.223 Y167.164 I.884 J-.761 E.02846
G1 X184.584 Y167.128 E.01114
G1 X184.94 Y166.931 E.0125
G1 X185.166 Y166.666 E.0107
G1 X185.312 Y166.272 E.01293
G1 X185.325 Y166.078 E.00597
G1 X185.236 Y165.667 E.01292
G1 X185.062 Y165.394 E.00994
G1 X184.82 Y165.187 E.00977
G1 X184.393 Y165.034 E.01394
G1 X184.1 Y165.029 E.009
G1 X183.732 Y165.153 E.01194
G1 X183.51 Y165.328 E.0087
M204 S10000
G1 X183.636 Y165.781 F60000
G1 F2826
M204 S8000
G1 X183.549 Y166.05 E.0087
G1 X183.601 Y166.361 E.00968
G1 X183.78 Y166.613 E.00951
G1 X184.032 Y166.751 E.00881
G1 X184.368 Y166.79 E.01039
G1 X184.641 Y166.681 E.00905
G1 X184.844 Y166.463 E.00916
G1 X184.951 Y166.149 E.01018
G2 X184.697 Y165.578 I-.765 J-.002 E.01977
G1 X184.4 Y165.416 E.01038
G1 X184.096 Y165.417 E.00934
G1 X183.86 Y165.532 E.00806
G1 X183.676 Y165.736 E.00844
M204 S10000
G1 X184.096 Y165.904 F60000
; LINE_WIDTH: 0.54134
G1 F2826
M204 S8000
G1 X183.99 Y166.066 E.00784
G1 X184.024 Y166.216 E.00628
G1 X184.171 Y166.337 E.00771
G1 X184.356 Y166.338 E.00751
G1 X184.484 Y166.196 E.00776
G1 X184.511 Y166.107 E.00379
G1 X184.44 Y165.935 E.00756
G1 X184.25 Y165.837 E.00869
G1 X184.151 Y165.88 E.00438
; COOLING_NODE: 5
; WIPE_START
G1 F7222.824
G1 X184.25 Y165.837 E-.05413
G1 X184.44 Y165.935 E-.10733
G1 X184.511 Y166.107 E-.09339
G1 X184.484 Y166.196 E-.04679
G1 X184.356 Y166.338 E-.09591
G1 X184.171 Y166.337 E-.09281
G1 X184.024 Y166.216 E-.09522
G1 X183.99 Y166.066 E-.07758
G1 X184.096 Y165.904 E-.09684
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X182.87 Y158.371 Z6 F60000
G1 X182.102 Y153.648 Z6
G1 Z5.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2826
M204 S8000
G1 X182.102 Y152.852 E.0264
G1 X187.298 Y152.852 E.17236
G1 X187.298 Y153.648 E.0264
G1 X182.162 Y153.648 E.17037
; COOLING_NODE: 5
M204 S250
G1 X181.71 Y154.04 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2524
M204 S5000
G1 X181.71 Y152.46 E.04855
G1 X187.69 Y152.46 E.18375
G1 X187.69 Y154.04 E.04855
G1 X181.77 Y154.04 E.18191
M204 S10000
G1 X182.306 Y153.25 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F2826
M204 S8000
G1 X187.094 Y153.25 E.15172
; CHANGE_LAYER
; Z_HEIGHT: 5.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.259
G1 X185.094 Y153.25 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 38/85
; update layer progress
M73 L38
M991 S0 P37 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 5
M204 S10000
G17
G3 Z6 I-.028 J-1.217 P1  F60000
G1 X167.898 Y153.648 Z6
G1 Z5.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2745
M204 S8000
G1 X162.702 Y153.648 E.17236
G1 X162.702 Y152.852 E.0264
G1 X167.898 Y152.852 E.17236
G1 X167.898 Y153.588 E.02441
; COOLING_NODE: 5
M204 S250
G1 X168.29 Y154.04 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2467
M204 S5000
G1 X162.31 Y154.04 E.18375
G1 X162.31 Y152.46 E.04855
G1 X168.29 Y152.46 E.18375
G1 X168.29 Y153.98 E.04671
M204 S10000
G1 X167.694 Y153.25 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F2745
M204 S8000
G1 X162.906 Y153.25 E.15172
; COOLING_NODE: 4
; WIPE_START
G1 F9259.259
G1 X164.906 Y153.25 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X166.709 Y160.666 Z6.2 F60000
G1 X167.835 Y165.299 Z6.2
G1 Z5.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2745
M204 S8000
G3 X165.79 Y163.867 I-2.085 J.801 E.3776
G1 X165.862 Y163.869 E.00237
G3 X167.813 Y165.243 I-.111 J2.231 E.08352
; COOLING_NODE: 4
M204 S10000
G1 X168.216 Y165.153 F60000
G1 F2745
M204 S8000
G3 X165.795 Y163.46 I-2.465 J.947 E.44635
G1 X165.885 Y163.463 E.00297
G3 X168.194 Y165.097 I-.134 J2.637 E.09903
; COOLING_NODE: 4
M204 S10000
G1 X168.596 Y165.007 F60000
G1 F2745
M204 S8000
G3 X165.8 Y163.053 I-2.845 J1.093 E.5151
G1 X165.907 Y163.056 E.00356
G3 X168.574 Y164.951 I-.156 J3.044 E.11454
; COOLING_NODE: 4
M204 S250
G1 X168.965 Y164.878 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
M73 P67 R5
G1 F2467
M204 S5000
G1 X169.058 Y165.151 E.00884
G3 X165.805 Y162.661 I-3.306 J.949 E.52924
G1 X165.929 Y162.665 E.00383
G3 X168.945 Y164.822 I-.178 J3.435 E.12032
; WIPE_START
G1 F9547.055
M204 S8000
G1 X169.058 Y165.151 E-.13212
G1 X169.138 Y165.502 E-.13693
G1 X169.181 Y165.855 E-.13508
G1 X169.189 Y166.161 E-.11612
G1 X169.164 Y166.519 E-.13667
G1 X169.12 Y166.787 E-.10308
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X165.952 Y165.94 Z6.2 F60000
G1 Z5.8
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.54162
G1 F2745
M204 S8000
G1 X165.746 Y165.838 E.00934
G1 X165.578 Y165.901 E.00731
G1 X165.499 Y166.068 E.00748
G1 X165.54 Y166.234 E.00698
G1 X165.706 Y166.352 E.00828
G1 X165.879 Y166.32 E.00715
G1 X165.997 Y166.156 E.0082
G2 X165.975 Y165.995 I-.132 J-.064 E.00699
M204 S10000
G1 X166.382 Y165.802 F60000
; LINE_WIDTH: 0.41999
G1 F2745
M204 S8000
G1 X166.215 Y165.59 E.00828
G1 X165.904 Y165.417 E.01093
G1 X165.597 Y165.417 E.00944
G1 X165.337 Y165.535 E.00876
G1 X165.134 Y165.767 E.00948
G1 X165.06 Y166.088 E.01011
G1 X165.115 Y166.383 E.00922
G1 X165.303 Y166.622 E.00934
G1 X165.599 Y166.783 E.01038
G1 X165.844 Y166.793 E.00753
G1 X166.147 Y166.667 E.01008
G1 X166.336 Y166.475 E.00828
G1 X166.451 Y166.149 E.01061
G2 X166.396 Y165.86 I-.678 J-.021 E.00912
M204 S10000
G1 X166.562 Y165.388 F60000
G1 F2745
M204 S8000
G1 X166.324 Y165.189 E.00954
G1 X165.895 Y165.034 E.01402
G1 X165.6 Y165.029 E.00905
G1 X165.209 Y165.163 E.01272
G1 X164.898 Y165.434 E.01267
G1 X164.735 Y165.779 E.01174
G2 X165.327 Y167.076 I1.059 J.3 E.04766
G1 X165.693 Y167.18 E.01168
G1 X166.029 Y167.129 E.01045
G1 X166.361 Y166.977 E.01122
G1 X166.661 Y166.675 E.01306
G1 X166.816 Y166.255 E.01376
G2 X166.78 Y165.77 I-1.16 J-.159 E.01505
G1 X166.592 Y165.44 E.01167
M204 S10000
G1 X166.934 Y165.258 F60000
G1 F2745
M204 S8000
G2 X166.117 Y164.687 I-1.28 J.962 E.03114
G1 X165.677 Y164.648 E.01356
G1 X165.275 Y164.719 E.01257
G1 X164.899 Y164.921 E.01309
G1 X164.598 Y165.202 E.01265
G1 X164.444 Y165.449 E.00896
G1 X164.31 Y165.874 E.0137
G1 X164.303 Y166.274 E.0123
G1 X164.419 Y166.693 E.01335
G1 X164.65 Y167.056 E.01323
G1 X164.977 Y167.336 E.01323
G1 X165.388 Y167.514 E.01374
G1 X165.822 Y167.55 E.01339
G2 X166.416 Y167.397 I-.394 J-2.769 E.01889
G1 X166.727 Y167.183 E.0116
G1 X166.985 Y166.875 E.01232
G1 X167.163 Y166.464 E.01379
G1 X167.203 Y166.052 E.01271
G1 X167.14 Y165.652 E.01245
G1 X166.962 Y165.311 E.01181
M204 S10000
G1 X167.343 Y165.18 F60000
G1 F2745
M204 S8000
G1 X167.118 Y164.87 E.01179
G1 X166.725 Y164.541 E.01574
G1 X166.223 Y164.323 E.01681
G1 X165.675 Y164.27 E.01692
G1 X165.151 Y164.361 E.01634
G1 X164.691 Y164.607 E.01605
G1 X164.298 Y164.97 E.01642
G1 X164.099 Y165.29 E.0116
G1 X163.934 Y165.813 E.01685
G1 X163.925 Y166.322 E.01565
G1 X164.07 Y166.848 E.01676
G1 X164.363 Y167.306 E.01669
G1 X164.775 Y167.659 E.0167
G1 X165.282 Y167.879 E.01696
G2 X166.062 Y167.913 I.467 J-1.747 E.02417
G1 X166.586 Y167.738 E.01699
G1 X166.983 Y167.464 E.01482
G1 X167.309 Y167.075 E.01558
G1 X167.528 Y166.571 E.01689
G1 X167.58 Y166.042 E.01634
G1 X167.501 Y165.533 E.01582
G1 X167.368 Y165.235 E.01005
; COOLING_NODE: 2
; WIPE_START
G1 F9547.299
G1 X167.501 Y165.533 E-.12428
G1 X167.58 Y166.042 E-.19565
G1 X167.528 Y166.571 E-.20204
G1 X167.309 Y167.075 E-.20883
G1 X167.26 Y167.134 E-.02921
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X170.11 Y165.64 Z6.2 F60000
G1 Z5.8
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2732
M204 S5000
G1 X170.11 Y164.06 E.04855
G1 X179.89 Y164.06 E.30051
G1 X179.89 Y165.64 E.04855
G1 X170.17 Y165.64 E.29867
; WIPE_START
G1 F9547.055
M204 S8000
G1 X170.11 Y164.06 E-.60084
G1 X170.529 Y164.06 E-.15917
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X178.126 Y164.798 Z6.2 F60000
G1 X179.683 Y164.949 Z6.2
G1 Z5.8
G1 E.8 F1800
; FEATURE: Top surface
G1 F2745
M204 S2000
G1 X179.001 Y164.267 E.02963
G1 X178.867 Y164.134
G1 X178.334 Y164.134
G1 X178.467 Y164.267
G1 X179.633 Y165.433 E.05063
G1 X179.766 Y165.566
G1 X179.233 Y165.566
G1 X179.099 Y165.433
G1 X177.934 Y164.267 E.05063
G1 X177.801 Y164.134
G1 X177.267 Y164.134
G1 X177.401 Y164.267
G1 X178.566 Y165.433 E.05063
G1 X178.7 Y165.566
G1 X178.167 Y165.566
G1 X178.033 Y165.433
G1 X176.868 Y164.267 E.05063
G1 X176.734 Y164.134
G1 X176.201 Y164.134
G1 X176.334 Y164.267
G1 X177.5 Y165.433 E.05063
G1 X177.633 Y165.566
G1 X177.1 Y165.566
G1 X176.966 Y165.433
G1 X175.801 Y164.267 E.05063
G1 X175.668 Y164.134
G1 X175.134 Y164.134
G1 X175.268 Y164.267
G1 X176.433 Y165.433 E.05063
G1 X176.567 Y165.566
G1 X176.034 Y165.566
G1 X175.9 Y165.433
G1 X174.735 Y164.267 E.05063
G1 X174.601 Y164.134
G1 X174.068 Y164.134
G1 X174.201 Y164.267
G1 X175.367 Y165.433 E.05063
G1 X175.5 Y165.566
G1 X174.967 Y165.566
G1 X174.833 Y165.433
G1 X173.668 Y164.267 E.05063
G1 X173.535 Y164.134
G1 X173.001 Y164.134
G1 X173.135 Y164.267
G1 X174.3 Y165.433 E.05063
G1 X174.434 Y165.566
G1 X173.9 Y165.566
G1 X173.767 Y165.433
G1 X172.602 Y164.267 E.05063
G1 X172.468 Y164.134
G1 X171.935 Y164.134
G1 X172.068 Y164.267
G1 X173.234 Y165.433 E.05063
G1 X173.367 Y165.566
G1 X172.834 Y165.566
G1 X172.7 Y165.433
G1 X171.535 Y164.267 E.05063
G1 X171.401 Y164.134
G1 X170.868 Y164.134
G1 X171.002 Y164.267
G1 X172.167 Y165.433 E.05063
G1 X172.301 Y165.566
G1 X171.767 Y165.566
G1 X171.634 Y165.433
G1 X170.469 Y164.267 E.05063
G1 X170.335 Y164.134
G1 X170.184 Y164.516
G1 X170.317 Y164.649
G1 X171.101 Y165.433 E.03403
; COOLING_NODE: 1
; WIPE_START
G1 F9547.055
M204 S8000
G1 X170.317 Y164.649 E-.42088
G1 X170.184 Y164.516 E-.07182
G1 X170.335 Y164.134 E-.15614
G1 X170.469 Y164.267 E-.07182
G1 X170.542 Y164.341 E-.03935
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X178.125 Y165.204 Z6.2 F60000
G1 X182.063 Y165.652 Z6.2
G1 Z5.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2745
M204 S8000
G1 X182.065 Y165.642 E.00034
G3 X184.29 Y163.867 I2.186 J.458 E.10238
G1 X184.362 Y163.869 E.00237
G3 X182.018 Y166.061 I-.111 J2.231 E.34672
G1 X182.056 Y165.711 E.01166
; COOLING_NODE: 1
M204 S10000
G1 X181.66 Y165.608 F60000
G1 F2745
M204 S8000
G1 X181.667 Y165.555 E.00175
G3 X184.295 Y163.46 I2.584 J.545 E.12086
G1 X184.385 Y163.463 E.00297
G3 X181.611 Y166.054 I-.134 J2.637 E.40985
G1 X181.654 Y165.667 E.0129
; COOLING_NODE: 1
M204 S10000
G1 X181.246 Y165.601 F60000
G1 F2745
M204 S8000
G1 X181.27 Y165.469 E.00445
G3 X184.3 Y163.053 I2.982 J.631 E.13934
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X184.407 Y163.056 E.00356
G3 X181.226 Y165.728 I-.156 J3.044 E.48355
G1 X181.237 Y165.66 E.00228
; COOLING_NODE: 1
M204 S250
G1 X180.86 Y165.537 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2467
M204 S5000
G1 X180.887 Y165.386 E.00471
G3 X184.305 Y162.661 I3.365 J.714 E.14557
G1 X184.429 Y162.665 E.00383
G3 X180.837 Y165.681 I-.178 J3.435 E.50551
G1 X180.85 Y165.596 E.00262
; WIPE_START
G1 F9547.055
M204 S8000
G1 X180.887 Y165.386 E-.08108
G1 X180.978 Y165.037 E-.13695
G1 X181.105 Y164.706 E-.13503
G1 X181.241 Y164.433 E-.11582
G1 X181.432 Y164.127 E-.13707
G1 X181.65 Y163.847 E-.13472
G1 X181.685 Y163.81 E-.01934
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X184.089 Y165.9 Z6.2 F60000
G1 Z5.8
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.5415
G1 F2745
M204 S8000
G1 X183.988 Y166.089 E.00871
G1 X184.06 Y166.265 E.00772
G1 X184.248 Y166.36 E.00858
G1 X184.432 Y166.276 E.0082
G1 X184.512 Y166.083 E.00848
G1 X184.452 Y165.94 E.00629
G1 X184.246 Y165.838 E.00934
G1 X184.144 Y165.878 E.00443
M204 S10000
G1 X183.664 Y165.725 F60000
; LINE_WIDTH: 0.41999
G1 F2745
M204 S8000
G1 X183.549 Y166.051 E.0106
G1 X183.615 Y166.383 E.01041
G1 X183.803 Y166.622 E.00934
G1 X184.099 Y166.783 E.01037
G1 X184.344 Y166.793 E.00754
G1 X184.647 Y166.667 E.01008
G1 X184.836 Y166.475 E.00828
G1 X184.951 Y166.149 E.0106
G2 X184.715 Y165.59 I-.735 J-.02 E.01924
G1 X184.404 Y165.417 E.01093
G1 X184.097 Y165.417 E.00944
G1 X183.854 Y165.524 E.00815
G1 X183.705 Y165.682 E.00668
M204 S10000
G1 X183.438 Y165.408 F60000
G1 F2745
M204 S8000
G1 X183.274 Y165.677 E.00967
G1 X183.171 Y166.024 E.01114
G1 X183.224 Y166.384 E.01117
G2 X183.827 Y167.076 I1.124 J-.37 E.02898
G1 X184.193 Y167.18 E.01168
G1 X184.529 Y167.129 E.01045
G1 X184.861 Y166.977 E.01122
G1 X185.161 Y166.675 E.01306
G1 X185.316 Y166.255 E.01376
G2 X185.28 Y165.77 I-1.161 J-.159 E.01506
G1 X185.062 Y165.388 E.01351
G1 X184.824 Y165.189 E.00954
G1 X184.395 Y165.034 E.01403
G1 X184.1 Y165.029 E.00905
G1 X183.71 Y165.163 E.01269
G1 X183.482 Y165.368 E.00942
M204 S10000
G1 X183.015 Y165.325 F60000
G1 F2745
M204 S8000
G1 X182.837 Y165.737 E.01379
G1 X182.796 Y166.115 E.01168
G2 X182.919 Y166.693 I3.074 J-.349 E.0182
G1 X183.15 Y167.056 E.01322
G1 X183.478 Y167.336 E.01325
G1 X183.888 Y167.514 E.01373
G1 X184.322 Y167.55 E.01339
G2 X184.916 Y167.397 I-.394 J-2.77 E.01889
G1 X185.227 Y167.183 E.0116
G1 X185.485 Y166.875 E.01233
G1 X185.663 Y166.463 E.01379
G1 X185.703 Y166.052 E.0127
G1 X185.64 Y165.652 E.01245
G1 X185.434 Y165.258 E.01365
G2 X184.617 Y164.687 I-1.279 J.961 E.03114
G1 X184.177 Y164.648 E.01356
G1 X183.774 Y164.719 E.01258
G1 X183.41 Y164.914 E.0127
G2 X183.054 Y165.279 I1.504 J1.828 E.01569
M204 S10000
G1 X182.691 Y165.125 F60000
G1 F2745
M204 S8000
G1 X182.472 Y165.629 E.01689
G1 X182.419 Y166.124 E.01531
G2 X182.57 Y166.848 I3.031 J-.255 E.02278
G1 X182.862 Y167.306 E.01668
G1 X183.276 Y167.659 E.01671
G1 X183.782 Y167.879 E.01695
G2 X184.562 Y167.913 I.467 J-1.747 E.02417
G1 X185.086 Y167.738 E.01699
G1 X185.483 Y167.464 E.01482
G1 X185.809 Y167.075 E.01558
G1 X186.028 Y166.571 E.01689
G1 X186.08 Y166.042 E.01633
G1 X186.001 Y165.533 E.01582
G2 X185.225 Y164.541 I-1.891 J.678 E.03937
G1 X184.723 Y164.323 E.01681
G1 X184.175 Y164.27 E.01692
G1 X183.651 Y164.361 E.01634
G1 X183.188 Y164.61 E.01615
G1 X183.02 Y164.732 E.0064
G1 X182.73 Y165.079 E.01388
; COOLING_NODE: 5
; WIPE_START
G1 F9547.299
G1 X183.02 Y164.732 E-.17172
G1 X183.188 Y164.61 E-.07909
G1 X183.651 Y164.361 E-.19974
G1 X184.175 Y164.27 E-.20211
G1 X184.456 Y164.297 E-.10734
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X182.809 Y156.845 Z6.2 F60000
G1 X182.102 Y153.648 Z6.2
G1 Z5.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2745
M204 S8000
G1 X182.102 Y152.852 E.0264
G1 X187.298 Y152.852 E.17236
G1 X187.298 Y153.648 E.0264
G1 X182.162 Y153.648 E.17037
; COOLING_NODE: 5
M204 S250
G1 X181.71 Y154.04 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2467
M204 S5000
G1 X181.71 Y152.46 E.04855
G1 X187.69 Y152.46 E.18375
G1 X187.69 Y154.04 E.04855
G1 X181.77 Y154.04 E.18191
M204 S10000
G1 X182.306 Y153.25 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F2745
M204 S8000
G1 X187.094 Y153.25 E.15172
; CHANGE_LAYER
; Z_HEIGHT: 5.85714
; LAYER_HEIGHT: 0.0571427
; WIPE_START
G1 F9259.259
G1 X185.094 Y153.25 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 39/85
; update layer progress
M73 L39
M991 S0 P38 ;notify layer change

; OBJECT_ID: 15
M204 S10000
G17
G3 Z6.2 I-.062 J-1.215 P1  F60000
G1 X169.095 Y154.062 Z6.2
G1 Z5.857
G1 E.8 F1800
; FEATURE: Support
; LINE_WIDTH: 0.42
; LAYER_HEIGHT: 0.27619
G1 F2411
M204 S8000
G1 X180.961 Y154.062 E.48169
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X180.961 Y152.438 E.06589
G1 X169.039 Y152.438 E.48399
G1 X169.039 Y154.062 E.06589
; CHANGE_LAYER
; Z_HEIGHT: 6
; LAYER_HEIGHT: 0.142857
; WIPE_START
G1 F7226.745
G1 X169.039 Y152.438 E-.61679
G1 X169.415 Y152.438 E-.14321
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 40/85
; update layer progress
M73 L40
M991 S0 P39 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 4
M204 S10000
G17
G3 Z6.257 I-1.21 J-.132 P1  F60000
G1 X167.959 Y165.79 Z6.257
G1 Z6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
; LAYER_HEIGHT: 0.2
G1 F2411
M204 S8000
G3 X165.747 Y163.867 I-2.211 J.31 E.35936
G1 X165.866 Y163.87 E.00395
G3 X167.95 Y165.73 I-.119 J2.23 E.10011
; COOLING_NODE: 4
M204 S10000
G1 X168.367 Y165.753 F60000
G1 F2411
M204 S8000
G1 X168.385 Y165.961 E.00691
G3 X165.749 Y163.459 I-2.636 J.139 E.41733
G1 X165.888 Y163.463 E.00461
G3 X168.357 Y165.694 I-.14 J2.636 E.11942
; COOLING_NODE: 4
M204 S10000
G1 X168.772 Y165.713 F60000
G1 F2411
M204 S8000
G1 X168.792 Y165.941 E.0076
G3 X165.751 Y163.052 I-3.043 J.158 E.48165
M73 P68 R5
G1 X165.909 Y163.056 E.00526
G3 X168.764 Y165.654 I-.16 J3.043 E.13862
; COOLING_NODE: 4
M204 S250
G1 X169.162 Y165.675 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2408
M204 S5000
G1 X169.185 Y165.923 E.00763
G3 X165.753 Y162.66 I-3.435 J.177 E.50353
G1 X165.93 Y162.665 E.00544
G3 X169.155 Y165.616 I-.18 J3.435 E.14556
; WIPE_START
G1 F9547.055
M204 S8000
G1 X169.185 Y165.923 E-.11718
G1 X169.185 Y166.28 E-.13579
G1 X169.147 Y166.639 E-.13715
G1 X169.088 Y166.932 E-.11358
G1 X168.982 Y167.278 E-.13743
G1 X168.868 Y167.553 E-.11343
G1 X168.861 Y167.566 E-.00543
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X165.922 Y165.902 Z6.4 F60000
G1 Z6
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.541273
G1 F2411
M204 S8000
G1 X165.74 Y165.838 E.00782
G2 X165.508 Y166.014 I.058 J.318 E.01228
G1 X165.528 Y166.24 E.0092
G1 X165.689 Y166.345 E.00779
G1 X165.89 Y166.322 E.00821
G1 X166.004 Y166.138 E.00879
G2 X165.946 Y165.957 I-.304 J-.002 E.00788
M204 S10000
G1 X166.332 Y165.709 F60000
; LINE_WIDTH: 0.41999
G1 F2411
M204 S8000
G1 X166.111 Y165.501 E.00932
G1 X165.849 Y165.408 E.00855
G1 X165.572 Y165.423 E.00851
G1 X165.342 Y165.546 E.00801
G1 X165.12 Y165.808 E.01056
G1 X165.056 Y166.136 E.01028
G1 X165.148 Y166.463 E.01045
G1 X165.393 Y166.696 E.01038
G1 X165.683 Y166.784 E.00933
G1 X166.022 Y166.746 E.01046
G1 X166.227 Y166.601 E.00772
G1 X166.385 Y166.362 E.00882
G1 X166.444 Y166.138 E.0071
G2 X166.35 Y165.766 I-.921 J.036 E.01186
M204 S10000
G1 X166.557 Y165.379 F60000
G1 F2411
M204 S8000
G1 X166.224 Y165.127 E.01282
G1 X165.807 Y165.02 E.01324
G1 X165.398 Y165.077 E.01269
G1 X165.074 Y165.278 E.01171
G2 X164.675 Y166.156 I.708 J.851 E.03065
G1 X164.79 Y166.588 E.01373
G1 X164.929 Y166.801 E.00783
G1 X165.196 Y167.023 E.01067
G2 X165.806 Y167.175 I.556 J-.93 E.01959
G1 X166.238 Y167.06 E.01374
G1 X166.451 Y166.922 E.0078
G1 X166.673 Y166.654 E.01068
G1 X166.815 Y166.259 E.01289
G2 X166.586 Y165.431 I-1.389 J-.062 E.02683
M204 S10000
G1 X166.993 Y165.335 F60000
G1 F2411
M204 S8000
G1 X166.729 Y165.025 E.01252
G1 X166.39 Y164.787 E.01273
G1 X165.967 Y164.663 E.01355
G1 X165.547 Y164.654 E.01292
G1 X165.157 Y164.773 E.01251
G2 X164.667 Y165.125 I1.458 J2.551 E.01858
G1 X164.379 Y165.615 E.01746
G1 X164.294 Y166.176 E.01743
G1 X164.384 Y166.613 E.01372
G1 X164.653 Y167.062 E.01608
G1 X165 Y167.35 E.01384
G1 X165.397 Y167.514 E.01321
G1 X165.826 Y167.556 E.01324
G1 X166.263 Y167.466 E.01371
G1 X166.712 Y167.198 E.01606
G1 X166.999 Y166.85 E.01385
G1 X167.188 Y166.315 E.01745
G2 X167.164 Y165.747 I-3.316 J-.145 E.01748
G1 X167.016 Y165.391 E.01185
M204 S10000
G1 X167.324 Y165.148 F60000
G1 F2411
M204 S8000
G1 X166.985 Y164.748 E.01613
G1 X166.556 Y164.447 E.01609
G1 X166.045 Y164.294 E.01639
G1 X165.661 Y164.271 E.01181
G1 X165.148 Y164.362 E.01603
G1 X164.81 Y164.519 E.01145
G1 X164.383 Y164.87 E.01696
G1 X164.081 Y165.327 E.01686
G1 X163.967 Y165.651 E.01053
G1 X163.914 Y166.196 E.01684
G1 X164.024 Y166.734 E.01688
G1 X164.263 Y167.168 E.01522
G2 X164.803 Y167.676 I2.362 J-1.973 E.02285
G1 X165.305 Y167.884 E.01668
G1 X165.846 Y167.936 E.0167
G1 X166.384 Y167.826 E.01687
G1 X166.818 Y167.588 E.01522
G2 X167.326 Y167.047 I-1.977 J-2.366 E.02285
G1 X167.536 Y166.54 E.01686
G2 X167.56 Y165.927 I-1.222 J-.356 E.01903
G1 X167.534 Y165.655 E.00841
G1 X167.347 Y165.204 E.015
; COOLING_NODE: 5
; WIPE_START
G1 F9547.299
G1 X167.534 Y165.655 E-.18556
G1 X167.56 Y165.927 E-.10401
G1 X167.586 Y166.201 E-.10454
G1 X167.536 Y166.54 E-.13016
G1 X167.326 Y167.047 E-.20851
G1 X167.281 Y167.102 E-.02722
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X167.63 Y159.478 Z6.4 F60000
G1 X167.898 Y153.648 Z6.4
G1 Z6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2411
M204 S8000
G1 X162.702 Y153.648 E.17236
G1 X162.702 Y152.852 E.0264
G1 X167.898 Y152.852 E.17236
G1 X167.898 Y153.588 E.02441
; COOLING_NODE: 5
M204 S250
G1 X168.29 Y154.04 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2408
M204 S5000
G1 X162.31 Y154.04 E.18375
G1 X162.31 Y152.46 E.04855
G1 X168.29 Y152.46 E.18375
G1 X168.29 Y153.98 E.04671
M204 S10000
G1 X167.694 Y153.25 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F2411
M204 S8000
G1 X162.906 Y153.25 E.15172
; COOLING_NODE: 1
; WIPE_START
G1 F9259.259
G1 X164.906 Y153.25 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.087 Y157.728 Z6.4 F60000
G1 X182.055 Y165.674 Z6.4
G1 Z6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2411
M204 S8000
G3 X184.247 Y163.867 I2.192 J.426 E.10214
G1 X184.366 Y163.87 E.00395
G3 X182.045 Y165.733 I-.119 J2.23 E.35733
; COOLING_NODE: 1
M204 S10000
G1 X181.652 Y165.635 F60000
G1 F2411
M204 S8000
G1 X181.657 Y165.596 E.00128
G3 X184.249 Y163.459 I2.592 J.503 E.12079
G1 X184.388 Y163.463 E.00461
G3 X181.623 Y165.82 I-.14 J2.636 E.41737
G1 X181.643 Y165.694 E.00422
; COOLING_NODE: 1
M204 S10000
G1 X181.246 Y165.605 F60000
G1 F2411
M204 S8000
G1 X181.292 Y165.363 E.00819
G3 X184.251 Y163.052 I2.957 J.737 E.13416
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X184.409 Y163.056 E.00526
G3 X181.232 Y165.675 I-.16 J3.043 E.48514
G1 X181.234 Y165.664 E.00038
; COOLING_NODE: 1
M204 S250
G1 X180.861 Y165.53 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2408
M204 S5000
G1 X180.913 Y165.268 E.00821
G3 X184.253 Y162.66 I3.337 J.831 E.14029
G1 X184.43 Y162.665 E.00544
G3 X180.845 Y165.619 I-.18 J3.435 E.50731
G1 X180.85 Y165.589 E.00091
; WIPE_START
G1 F9547.055
M204 S8000
G1 X180.913 Y165.268 E-.12437
G1 X181.018 Y164.922 E-.13734
G1 X181.132 Y164.646 E-.1136
G1 X181.301 Y164.328 E-.13685
G1 X181.503 Y164.03 E-.13695
G1 X181.689 Y163.804 E-.11089
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X183.996 Y166.062 Z6.4 F60000
G1 Z6
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.54139
G1 F2411
M204 S8000
G1 X184.043 Y166.252 E.00796
G1 X184.226 Y166.348 E.00838
G1 X184.413 Y166.306 E.00777
G1 X184.506 Y166.152 E.00733
G1 X184.447 Y165.925 E.00954
G1 X184.302 Y165.844 E.00674
G1 X184.112 Y165.892 E.00796
G1 X184.03 Y166.012 E.00591
M204 S10000
G1 X183.72 Y165.662 F60000
; LINE_WIDTH: 0.41999
G1 F2411
M204 S8000
G1 X183.563 Y165.964 E.01044
G1 X183.576 Y166.268 E.00936
G1 X183.729 Y166.56 E.01013
G1 X183.988 Y166.735 E.00963
G1 X184.286 Y166.794 E.00933
G1 X184.613 Y166.702 E.01045
G1 X184.843 Y166.471 E.01001
G1 X184.94 Y166.213 E.00848
G1 X184.927 Y165.938 E.00844
G1 X184.775 Y165.632 E.01052
G1 X184.561 Y165.47 E.00823
G1 X184.241 Y165.4 E.01008
G1 X183.956 Y165.47 E.009
G1 X183.767 Y165.625 E.00751
M204 S10000
G1 X183.327 Y165.546 F60000
G1 F2411
M204 S8000
G1 X183.185 Y165.941 E.0129
G1 X183.206 Y166.36 E.0129
G1 X183.383 Y166.739 E.01286
G1 X183.696 Y167.023 E.01298
G2 X184.306 Y167.175 I.556 J-.93 E.01959
G1 X184.736 Y167.061 E.01365
G1 X184.971 Y166.907 E.00867
G1 X185.221 Y166.578 E.01268
G1 X185.313 Y166.265 E.01002
G1 X185.296 Y165.844 E.01294
G1 X185.103 Y165.442 E.0137
G1 X184.903 Y165.237 E.0088
G1 X184.53 Y165.055 E.01277
G1 X184.124 Y165.028 E.01249
G1 X183.795 Y165.125 E.01053
G1 X183.53 Y165.301 E.00978
G1 X183.366 Y165.5 E.00793
M204 S10000
G1 X183.001 Y165.349 F60000
G1 F2411
M204 S8000
G1 X182.812 Y165.885 E.01745
G1 X182.836 Y166.452 E.01745
G1 X183.08 Y166.963 E.01739
G1 X183.5 Y167.35 E.01754
G1 X183.897 Y167.514 E.01322
G1 X184.326 Y167.556 E.01323
G1 X184.763 Y167.466 E.01371
G1 X185.12 Y167.266 E.01257
G1 X185.415 Y166.982 E.01257
G1 X185.62 Y166.582 E.01381
G1 X185.686 Y166.317 E.0084
G2 X185.493 Y165.335 I-1.588 J-.197 E.03127
G1 X185.228 Y165.024 E.01256
G1 X184.894 Y164.789 E.01253
G1 X184.447 Y164.66 E.0143
G1 X184.061 Y164.653 E.01186
G1 X183.634 Y164.779 E.01369
G1 X183.275 Y165.017 E.01324
G1 X183.039 Y165.303 E.01139
M204 S10000
G1 X182.674 Y165.153 F60000
G1 F2411
M204 S8000
G1 X182.464 Y165.66 E.01685
G1 X182.414 Y165.999 E.01053
G1 X182.466 Y166.545 E.01685
G1 X182.676 Y167.052 E.01687
G1 X182.877 Y167.323 E.01037
G1 X183.303 Y167.676 E.01701
G1 X183.805 Y167.884 E.01669
G1 X184.346 Y167.936 E.01669
G1 X184.884 Y167.826 E.01688
G1 X185.344 Y167.569 E.01618
G1 X185.717 Y167.211 E.0159
G1 X185.965 Y166.737 E.01643
G2 X186.088 Y166.165 I-2.463 J-.83 E.01802
G1 X186.035 Y165.656 E.01574
G1 X185.824 Y165.148 E.01688
G1 X185.483 Y164.747 E.01618
G1 X185.061 Y164.449 E.01587
G1 X184.547 Y164.294 E.01649
G2 X183.814 Y164.333 I-.285 J1.559 E.02276
G1 X183.473 Y164.434 E.01094
G1 X183.02 Y164.734 E.01671
G1 X182.712 Y165.107 E.01485
; COOLING_NODE: 5
; WIPE_START
G1 F9547.299
G1 X183.02 Y164.734 E-.18367
G1 X183.473 Y164.434 E-.20662
G1 X183.814 Y164.333 E-.13532
G1 X184.191 Y164.27 E-.14514
G1 X184.425 Y164.286 E-.08925
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X182.797 Y156.829 Z6.4 F60000
G1 X182.102 Y153.648 Z6.4
G1 Z6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2411
M204 S8000
G1 X182.102 Y152.852 E.0264
G1 X187.298 Y152.852 E.17236
G1 X187.298 Y153.648 E.0264
G1 X182.162 Y153.648 E.17037
; COOLING_NODE: 5
M204 S250
G1 X181.71 Y154.04 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2408
M204 S5000
G1 X181.71 Y152.46 E.04855
G1 X187.69 Y152.46 E.18375
G1 X187.69 Y154.04 E.04855
G1 X181.77 Y154.04 E.18191
M204 S10000
G1 X182.306 Y153.25 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F2411
M204 S8000
G1 X187.094 Y153.25 E.15172
; CHANGE_LAYER
; Z_HEIGHT: 6.13333
; LAYER_HEIGHT: 0.133333
; WIPE_START
G1 F9259.259
G1 X185.094 Y153.25 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 41/85
; update layer progress
M73 L41
M991 S0 P40 ;notify layer change

; OBJECT_ID: 15
M204 S10000
G17
G3 Z6.4 I-.062 J-1.215 P1  F60000
G1 X169.095 Y154.062 Z6.4
G1 Z6.133
G1 E.8 F1800
; FEATURE: Support
; LINE_WIDTH: 0.42
; LAYER_HEIGHT: 0.27619
G1 F2405
M204 S8000
G1 X180.961 Y154.062 E.48169
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X180.961 Y152.438 E.06589
G1 X169.039 Y152.438 E.48399
G1 X169.039 Y154.062 E.06589
; CHANGE_LAYER
; Z_HEIGHT: 6.2
; LAYER_HEIGHT: 0.0666666
; WIPE_START
G1 F7226.745
G1 X169.039 Y152.438 E-.61679
G1 X169.415 Y152.438 E-.14321
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 42/85
; update layer progress
M73 L42
M991 S0 P41 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 4
M204 S10000
G17
G3 Z6.533 I-1.21 J-.132 P1  F60000
G1 X167.961 Y165.803 Z6.533
G1 Z6.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
; LAYER_HEIGHT: 0.2
G1 F2405
M204 S8000
G1 X167.978 Y165.984 E.00603
G3 X165.755 Y163.867 I-2.23 J.116 E.3531
G1 X165.866 Y163.87 E.00369
G3 X167.953 Y165.743 I-.117 J2.23 E.10059
; COOLING_NODE: 4
M204 S10000
G1 X168.366 Y165.76 F60000
G1 F2405
M204 S8000
G1 X168.386 Y165.962 E.00674
G3 X165.757 Y163.459 I-2.637 J.137 E.4175
G1 X165.887 Y163.463 E.00432
G3 X168.357 Y165.687 I-.138 J2.636 E.11924
G1 X168.359 Y165.7 E.00046
; COOLING_NODE: 4
M204 S10000
G1 X168.766 Y165.694 F60000
G1 F2405
M204 S8000
G1 X168.797 Y166.1 E.01352
G3 X166.014 Y169.136 I-3.048 J0 E.15
G3 X165.909 Y163.056 I-.263 J-3.036 E.33159
G3 X168.759 Y165.623 I-.16 J3.044 E.13762
G1 X168.76 Y165.634 E.00035
; COOLING_NODE: 4
M204 S250
G1 X169.16 Y165.677 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2360
M204 S5000
M73 P69 R5
G1 X169.186 Y165.92 E.00754
G3 X165.762 Y162.66 I-3.435 J.179 E.50384
G1 X165.93 Y162.665 E.00515
G3 X169.149 Y165.562 I-.178 J3.435 E.14394
G1 X169.154 Y165.617 E.0017
; WIPE_START
G1 F9547.055
M204 S8000
G1 X169.186 Y165.92 E-.11599
G1 X169.185 Y166.28 E-.13648
G1 X169.148 Y166.638 E-.13711
G1 X169.088 Y166.932 E-.11393
G1 X168.982 Y167.277 E-.13688
G1 X168.862 Y167.565 E-.11874
G1 X168.861 Y167.567 E-.00087
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X165.954 Y165.932 Z6.6 F60000
G1 Z6.2
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.54131
G1 F2405
M204 S8000
G1 X165.802 Y165.844 E.00711
G1 X165.612 Y165.892 E.00797
G1 X165.509 Y166.006 E.00625
G1 X165.528 Y166.24 E.00952
G1 X165.712 Y166.354 E.0088
G1 X165.902 Y166.307 E.00794
G1 X165.998 Y166.124 E.0084
G1 X165.967 Y165.99 E.00558
M204 S10000
G1 X166.397 Y165.834 F60000
; LINE_WIDTH: 0.41999
G1 F2405
M204 S8000
G1 X166.238 Y165.599 E.00874
G1 X165.993 Y165.444 E.00891
G1 X165.686 Y165.402 E.0095
G1 X165.37 Y165.528 E.01045
G1 X165.166 Y165.714 E.00851
G1 X165.073 Y165.963 E.00817
G2 X165.173 Y166.497 I.803 J.126 E.017
G1 X165.393 Y166.696 E.00912
G1 X165.713 Y166.794 E.01028
G1 X166.013 Y166.735 E.00941
G1 X166.21 Y166.622 E.00697
G1 X166.385 Y166.361 E.00965
G1 X166.434 Y166.166 E.00617
G1 X166.404 Y165.894 E.00842
M204 S10000
G1 X166.664 Y165.52 F60000
G1 F2405
M204 S8000
G1 X166.4 Y165.236 E.01191
G1 X166.03 Y165.055 E.01266
G1 X165.624 Y165.028 E.01251
G1 X165.295 Y165.125 E.01053
G1 X164.941 Y165.389 E.0136
G1 X164.778 Y165.626 E.00883
G1 X164.691 Y165.997 E.01169
G1 X164.707 Y166.313 E.00974
G1 X164.823 Y166.658 E.01118
G1 X165.073 Y166.92 E.01112
G2 X166.01 Y167.144 I.7 J-.856 E.03064
G1 X166.389 Y166.967 E.01285
G1 X166.673 Y166.654 E.013
G1 X166.794 Y166.36 E.00977
G2 X166.684 Y165.577 I-1.343 J-.21 E.02465
M204 S10000
G1 X166.913 Y165.224 F60000
G1 F2405
M204 S8000
G1 X166.629 Y164.933 E.0125
G1 X166.257 Y164.737 E.0129
G1 X165.828 Y164.641 E.01353
G2 X165.134 Y164.779 I.088 J2.257 E.02181
G1 X164.763 Y165.025 E.01369
G1 X164.503 Y165.353 E.01285
G1 X164.338 Y165.731 E.01267
G1 X164.294 Y166.176 E.01374
G1 X164.384 Y166.613 E.01371
G1 X164.653 Y167.062 E.01608
G1 X165 Y167.35 E.01385
G1 X165.535 Y167.538 E.01745
G1 X166.102 Y167.514 E.01744
G1 X166.613 Y167.271 E.01738
G1 X167 Y166.85 E.01756
G1 X167.164 Y166.452 E.01324
G1 X167.206 Y166.024 E.01321
G1 X167.117 Y165.59 E.0136
G1 X166.942 Y165.277 E.01103
M204 S10000
G1 X167.215 Y164.998 F60000
G1 F2405
M204 S8000
G1 X166.857 Y164.631 E.01576
G1 X166.396 Y164.387 E.01602
G1 X165.849 Y164.263 E.01723
G1 X165.499 Y164.278 E.01077
G1 X164.973 Y164.433 E.01685
G1 X164.516 Y164.737 E.01685
G1 X164.188 Y165.144 E.01606
G1 X163.967 Y165.647 E.01687
G1 X163.914 Y166.196 E.01695
G1 X164.024 Y166.734 E.01687
G1 X164.262 Y167.168 E.01523
G2 X164.803 Y167.676 I2.365 J-1.976 E.02286
G1 X165.31 Y167.886 E.01685
G1 X165.649 Y167.936 E.01054
G1 X166.194 Y167.884 E.01683
G1 X166.701 Y167.674 E.01686
G1 X166.973 Y167.474 E.01037
G1 X167.326 Y167.047 E.01703
G1 X167.534 Y166.544 E.01671
G1 X167.586 Y166.004 E.01667
G1 X167.477 Y165.468 E.01681
G1 X167.244 Y165.05 E.01469
; COOLING_NODE: 5
; WIPE_START
G1 F9547.299
G1 X167.477 Y165.468 E-.18173
G1 X167.586 Y166.004 E-.20786
G1 X167.534 Y166.544 E-.20614
G1 X167.369 Y166.944 E-.16427
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X167.672 Y159.317 Z6.6 F60000
G1 X167.898 Y153.648 Z6.6
G1 Z6.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2405
M204 S8000
G1 X162.702 Y153.648 E.17236
G1 X162.702 Y152.852 E.0264
G1 X167.898 Y152.852 E.17236
G1 X167.898 Y153.588 E.02441
; COOLING_NODE: 5
M204 S250
G1 X168.29 Y154.04 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2360
M204 S5000
G1 X162.31 Y154.04 E.18375
G1 X162.31 Y152.46 E.04855
G1 X168.29 Y152.46 E.18375
G1 X168.29 Y153.98 E.04671
M204 S10000
G1 X167.694 Y153.25 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F2405
M204 S8000
G1 X162.906 Y153.25 E.15172
; COOLING_NODE: 1
; WIPE_START
G1 F9259.259
G1 X164.906 Y153.25 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.086 Y157.728 Z6.6 F60000
G1 X182.065 Y165.682 Z6.6
G1 Z6.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2405
M204 S8000
G1 X182.082 Y165.559 E.0041
G3 X184.255 Y163.867 I2.167 J.54 E.09845
G1 X184.366 Y163.87 E.00369
G3 X182.019 Y165.979 I-.117 J2.23 E.34916
G1 X182.055 Y165.741 E.00798
; COOLING_NODE: 1
M204 S10000
G1 X181.664 Y165.621 F60000
G1 F2405
M204 S8000
G1 X181.688 Y165.461 E.00536
G3 X184.257 Y163.459 I2.562 J.638 E.11643
G1 X184.387 Y163.463 E.00432
G3 X181.613 Y165.959 I-.138 J2.636 E.41278
G1 X181.655 Y165.68 E.00936
; COOLING_NODE: 1
M204 S10000
G1 X181.249 Y165.59 F60000
G1 F2405
M204 S8000
G1 X181.294 Y165.363 E.00767
G3 X184.26 Y163.052 I2.957 J.737 E.1344
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X184.409 Y163.056 E.00496
G3 X181.233 Y165.677 I-.158 J3.043 E.48515
G1 X181.238 Y165.649 E.00094
; COOLING_NODE: 1
M204 S250
G1 X180.864 Y165.515 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2360
M204 S5000
G1 X180.914 Y165.268 E.00773
G3 X184.262 Y162.66 I3.337 J.831 E.14054
M73 P69 R4
G1 X184.43 Y162.665 E.00515
G3 X180.846 Y165.622 I-.178 J3.435 E.50726
G1 X180.854 Y165.574 E.00149
; WIPE_START
G1 F9547.055
M204 S8000
G1 X180.914 Y165.268 E-.11839
G1 X180.997 Y164.981 E-.11384
G1 X181.132 Y164.646 E-.13696
G1 X181.301 Y164.329 E-.13668
G1 X181.503 Y164.03 E-.13713
G1 X181.699 Y163.792 E-.117
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X184.081 Y165.913 Z6.6 F60000
G1 Z6.2
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.54131
G1 F2405
M204 S8000
G1 X184.002 Y166.076 E.00737
G1 X184.043 Y166.262 E.00773
G1 X184.194 Y166.356 E.00723
G1 X184.402 Y166.307 E.00868
G1 X184.512 Y166.107 E.00928
G1 X184.403 Y165.887 E.00997
G1 X184.26 Y165.841 E.00612
G1 X184.137 Y165.89 E.00537
M204 S10000
G1 X183.654 Y165.742 F60000
; LINE_WIDTH: 0.41999
G1 F2405
M204 S8000
G1 X183.566 Y166.033 E.00935
G1 X183.604 Y166.371 E.01044
G1 X183.777 Y166.615 E.00918
G1 X184.039 Y166.767 E.00932
G1 X184.315 Y166.784 E.00851
G1 X184.641 Y166.682 E.01048
G1 X184.846 Y166.457 E.00936
G1 X184.952 Y166.138 E.01032
G1 X184.949 Y166.084 E.00167
G1 X184.873 Y165.789 E.00934
G1 X184.673 Y165.539 E.00985
G1 X184.433 Y165.422 E.00819
G1 X184.186 Y165.402 E.00761
G1 X183.87 Y165.527 E.01045
G1 X183.697 Y165.7 E.00752
M204 S10000
G1 X183.429 Y165.422 F60000
G1 F2405
M204 S8000
G2 X183.207 Y166.314 I.948 J.709 E.02898
G1 X183.323 Y166.658 E.01117
G1 X183.596 Y166.961 E.01254
G1 X183.989 Y167.15 E.01337
G1 X184.351 Y167.159 E.01113
G2 X185.173 Y166.654 I-.112 J-1.102 E.03069
G1 X185.318 Y166.238 E.01353
G1 X185.326 Y166.064 E.00535
G1 X185.216 Y165.624 E.01393
G1 X184.963 Y165.293 E.01279
G1 X184.724 Y165.128 E.00892
G1 X184.306 Y165.02 E.01328
G1 X183.949 Y165.079 E.01113
G1 X183.662 Y165.213 E.00973
G1 X183.474 Y165.382 E.00776
M204 S10000
G1 X183.001 Y165.35 F60000
G1 F2405
M204 S8000
G1 X182.836 Y165.748 E.01323
G1 X182.794 Y166.176 E.01323
G1 X182.884 Y166.613 E.01369
G1 X183.084 Y166.969 E.01255
G1 X183.369 Y167.265 E.01264
G1 X183.786 Y167.478 E.01439
G1 X184.159 Y167.556 E.01171
G1 X184.602 Y167.514 E.01367
G1 X185.113 Y167.271 E.01737
G1 X185.5 Y166.85 E.01757
G1 X185.67 Y166.438 E.01369
G1 X185.702 Y166.044 E.01214
G2 X185.559 Y165.459 I-3.015 J.425 E.01855
G1 X185.327 Y165.115 E.01273
G1 X185.003 Y164.857 E.01273
G1 X184.626 Y164.689 E.01268
G1 X184.207 Y164.647 E.01295
G2 X183.634 Y164.779 I.412 J3.088 E.0181
G1 X183.275 Y165.017 E.01323
G1 X183.039 Y165.303 E.0114
M204 S10000
G1 X182.674 Y165.153 F60000
G1 F2405
M204 S8000
G1 X182.466 Y165.655 E.01669
G1 X182.414 Y166.196 E.01669
G1 X182.523 Y166.733 E.01685
G1 X182.78 Y167.193 E.01617
G1 X183.142 Y167.568 E.01603
G1 X183.634 Y167.824 E.01702
G1 X184.149 Y167.936 E.01622
G1 X184.694 Y167.884 E.01683
G1 X185.201 Y167.674 E.01686
G1 X185.473 Y167.474 E.01037
G1 X185.826 Y167.047 E.01704
G1 X186.036 Y166.539 E.01686
G1 X186.079 Y166.034 E.01557
G1 X186.068 Y165.82 E.00659
G1 X185.902 Y165.293 E.01697
G1 X185.615 Y164.867 E.01579
G1 X185.223 Y164.549 E.01551
G1 X184.723 Y164.322 E.01687
G1 X184.191 Y164.27 E.01644
G2 X183.473 Y164.433 I.311 J3.021 E.02267
G1 X183.02 Y164.734 E.0167
G1 X182.712 Y165.107 E.01487
; COOLING_NODE: 5
; WIPE_START
G1 F9547.299
G1 X183.02 Y164.734 E-.18385
G1 X183.473 Y164.433 E-.2065
G1 X183.815 Y164.333 E-.13541
G1 X184.191 Y164.27 E-.14482
G1 X184.425 Y164.293 E-.08942
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X182.798 Y156.836 Z6.6 F60000
G1 X182.102 Y153.648 Z6.6
G1 Z6.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2405
M204 S8000
G1 X182.102 Y152.852 E.0264
G1 X187.298 Y152.852 E.17236
G1 X187.298 Y153.648 E.0264
G1 X182.162 Y153.648 E.17037
; COOLING_NODE: 5
M204 S250
G1 X181.71 Y154.04 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2360
M204 S5000
G1 X181.71 Y152.46 E.04855
G1 X187.69 Y152.46 E.18375
G1 X187.69 Y154.04 E.04855
G1 X181.77 Y154.04 E.18191
M204 S10000
G1 X182.306 Y153.25 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F2405
M204 S8000
G1 X187.094 Y153.25 E.15172
; CHANGE_LAYER
; Z_HEIGHT: 6.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.259
G1 X185.094 Y153.25 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 43/85
; update layer progress
M73 L43
M991 S0 P42 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 4
M204 S10000
G17
G3 Z6.6 I-.719 J-.982 P1  F60000
G1 X167.961 Y165.789 Z6.6
G1 Z6.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2175
M204 S8000
G3 X165.763 Y163.867 I-2.21 J.309 E.35959
G1 X165.865 Y163.87 E.00339
G3 X167.951 Y165.73 I-.115 J2.229 E.1002
; COOLING_NODE: 4
M204 S10000
G1 X168.366 Y165.747 F60000
G1 F2175
M204 S8000
G1 X168.386 Y165.958 E.00701
G3 X165.766 Y163.46 I-2.635 J.14 E.41763
G1 X165.887 Y163.463 E.00401
G3 X168.358 Y165.688 I-.136 J2.635 E.11933
; COOLING_NODE: 4
M204 S10000
G1 X168.771 Y165.707 F60000
G1 F2175
M204 S8000
G1 X168.793 Y165.938 E.0077
G3 X165.769 Y163.052 I-3.041 J.16 E.48196
G1 X165.909 Y163.056 E.00463
G3 X168.764 Y165.648 I-.157 J3.042 E.1385
; COOLING_NODE: 4
M204 S250
G1 X169.161 Y165.669 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2175
M204 S5000
G1 X169.186 Y165.919 E.00772
G3 X165.772 Y162.66 I-3.433 J.178 E.50384
G1 X165.93 Y162.665 E.00484
G3 X169.155 Y165.61 I-.177 J3.433 E.14543
; WIPE_START
G1 F9547.055
M204 S8000
G1 X169.186 Y165.919 E-.11831
G1 X169.185 Y166.28 E-.13684
G1 X169.148 Y166.638 E-.13699
G1 X169.088 Y166.932 E-.11402
G1 X168.983 Y167.276 E-.13671
G1 X168.862 Y167.56 E-.11712
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X167.324 Y165.15 Z6.8 F60000
G1 Z6.4
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F2175
M204 S8000
G1 X166.975 Y164.738 E.01659
G1 X166.562 Y164.449 E.01551
G1 X166.047 Y164.294 E.01653
G2 X165.315 Y164.332 I-.285 J1.555 E.02271
G1 X164.973 Y164.434 E.01096
G1 X164.516 Y164.736 E.01684
G1 X164.284 Y164.989 E.01053
G1 X164.022 Y165.471 E.01687
G1 X163.914 Y166.004 E.01671
G1 X163.966 Y166.545 E.01668
G1 X164.176 Y167.051 E.01685
G1 X164.514 Y167.451 E.01607
G1 X164.964 Y167.763 E.01683
G1 X165.46 Y167.908 E.01587
G2 X166.195 Y167.884 I.27 J-3.027 E.02265
G1 X166.702 Y167.674 E.01687
G1 X167.082 Y167.357 E.01522
G2 X167.478 Y166.729 I-2.356 J-1.925 E.02286
G1 X167.586 Y166.196 E.01671
G1 X167.534 Y165.656 E.01668
G1 X167.347 Y165.205 E.01498
M204 S10000
G1 X166.994 Y165.339 F60000
M73 P70 R4
G1 F2175
M204 S8000
G1 X166.721 Y165.016 E.01297
G1 X166.395 Y164.789 E.01222
G1 X165.946 Y164.66 E.01437
G1 X165.561 Y164.653 E.01181
G1 X165.134 Y164.779 E.01369
G1 X164.678 Y165.118 E.01744
G1 X164.38 Y165.602 E.01747
G1 X164.295 Y166.024 E.01324
G1 X164.336 Y166.453 E.01322
G1 X164.507 Y166.864 E.0137
G1 X164.769 Y167.173 E.01245
G1 X165.126 Y167.42 E.01336
G1 X165.515 Y167.535 E.01245
G2 X166.102 Y167.514 I.184 J-3.112 E.01809
G1 X166.515 Y167.343 E.01372
G1 X166.804 Y167.101 E.0116
G2 X167.12 Y166.598 I-2.457 J-1.89 E.01827
G1 X167.205 Y166.176 E.01324
G1 X167.164 Y165.748 E.01322
G1 X167.017 Y165.394 E.01177
M204 S10000
G1 X166.538 Y165.358 F60000
G1 F2175
M204 S8000
G1 X166.228 Y165.13 E.01182
G1 X165.806 Y165.02 E.01343
G1 X165.449 Y165.079 E.01112
G2 X164.739 Y165.732 I.32 J1.06 E.03066
G2 X164.706 Y166.36 I1.019 J.368 E.01961
G1 X164.897 Y166.758 E.01358
G1 X165.094 Y166.96 E.00867
G1 X165.491 Y167.15 E.01352
G1 X165.851 Y167.159 E.01105
G1 X166.158 Y167.083 E.00973
G1 X166.471 Y166.907 E.01103
G1 X166.685 Y166.609 E.01127
G2 X166.733 Y165.692 I-1.064 J-.516 E.02898
G1 X166.568 Y165.41 E.01002
M204 S10000
G1 X166.334 Y165.716 F60000
G1 F2175
M204 S8000
G1 X166.115 Y165.502 E.00941
G1 X165.828 Y165.405 E.0093
G1 X165.555 Y165.441 E.00845
G1 X165.257 Y165.603 E.01043
G1 X165.097 Y165.862 E.00937
G1 X165.066 Y166.165 E.00935
G1 X165.168 Y166.49 E.01047
G1 X165.388 Y166.697 E.00929
G1 X165.679 Y166.797 E.00945
G1 X166.013 Y166.735 E.01044
G1 X166.249 Y166.591 E.00849
G1 X166.403 Y166.337 E.00911
G1 X166.434 Y166.035 E.00934
G1 X166.352 Y165.773 E.00843
M204 S10000
G1 X165.913 Y165.892 F60000
; LINE_WIDTH: 0.54141
G1 F2175
M204 S8000
G1 X165.759 Y165.838 E.0066
G1 X165.561 Y165.926 E.00883
G1 X165.502 Y166.124 E.00837
G1 X165.586 Y166.305 E.00814
G1 X165.74 Y166.352 E.00652
G1 X165.93 Y166.29 E.00811
G1 X166.002 Y166.113 E.00777
G2 X165.938 Y165.947 I-.267 J.007 E.00738
; COOLING_NODE: 5
; WIPE_START
G1 F7221.81
G1 X166.002 Y166.113 E-.08935
G1 X165.93 Y166.29 E-.09594
G1 X165.74 Y166.352 E-.10015
G1 X165.586 Y166.305 E-.08046
G1 X165.502 Y166.124 E-.10044
G1 X165.561 Y165.926 E-.10328
G1 X165.759 Y165.838 E-.10895
G1 X165.913 Y165.892 E-.08144
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X167.134 Y158.358 Z6.8 F60000
G1 X167.898 Y153.648 Z6.8
G1 Z6.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2175
M204 S8000
G1 X162.702 Y153.648 E.17236
G1 X162.702 Y152.852 E.0264
G1 X167.898 Y152.852 E.17236
G1 X167.898 Y153.588 E.02441
; COOLING_NODE: 5
M204 S250
G1 X168.29 Y154.04 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2175
M204 S5000
G1 X162.31 Y154.04 E.18375
G1 X162.31 Y152.46 E.04855
G1 X168.29 Y152.46 E.18375
G1 X168.29 Y153.98 E.04671
M204 S10000
G1 X167.694 Y153.25 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F2175
M204 S8000
G1 X162.906 Y153.25 E.15172
; COOLING_NODE: 1
; WIPE_START
G1 F9259.259
G1 X164.906 Y153.25 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.09 Y157.723 Z6.8 F60000
G1 X182.067 Y165.664 Z6.8
G1 Z6.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2175
M204 S8000
G1 X182.083 Y165.561 E.00346
G3 X184.263 Y163.867 I2.167 J.538 E.09873
G1 X184.365 Y163.87 E.00339
G3 X182.02 Y165.984 I-.115 J2.23 E.3491
G1 X182.059 Y165.724 E.00871
; COOLING_NODE: 1
M204 S10000
G1 X181.647 Y165.661 F60000
G1 F2175
M204 S8000
G1 X181.689 Y165.462 E.00673
G3 X184.266 Y163.46 I2.562 J.637 E.11671
G1 X184.387 Y163.463 E.00401
G3 X181.638 Y165.72 I-.136 J2.637 E.42081
; COOLING_NODE: 1
M204 S10000
G1 X181.249 Y165.58 F60000
G1 F2175
M204 S8000
G1 X181.295 Y165.364 E.00733
G3 X184.409 Y163.056 I2.957 J.736 E.13931
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G3 X184.673 Y169.118 I-.162 J3.044 E.29809
G3 X181.24 Y165.639 I-.421 J-3.018 E.18814
; COOLING_NODE: 1
M204 S250
G1 X180.865 Y165.501 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2175
M204 S5000
G1 X180.915 Y165.268 E.00733
G3 X184.272 Y162.66 I3.337 J.831 E.14081
G1 X184.43 Y162.665 E.00484
G3 X180.855 Y165.562 I-.177 J3.435 E.50914
G1 X180.856 Y165.561 E.00005
; WIPE_START
G1 F9547.055
M204 S8000
G1 X180.915 Y165.268 E-.11337
G1 X181.017 Y164.924 E-.13657
G1 X181.142 Y164.626 E-.12258
G1 X181.301 Y164.328 E-.12842
G1 X181.503 Y164.03 E-.13691
G1 X181.708 Y163.782 E-.12215
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X184.042 Y165.94 Z6.8 F60000
G1 Z6.4
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.54143
G1 F2175
M204 S8000
G1 X183.998 Y166.082 E.00606
G1 X184.056 Y166.277 E.00827
G1 X184.191 Y166.352 E.00627
G1 X184.42 Y166.299 E.00954
G1 X184.511 Y166.065 E.0102
G1 X184.423 Y165.903 E.00751
G1 X184.259 Y165.839 E.00713
G1 X184.097 Y165.915 E.0073
M204 S10000
G1 X183.668 Y165.713 F60000
; LINE_WIDTH: 0.41999
G1 F2175
M204 S8000
G1 X183.561 Y165.976 E.0087
G1 X183.576 Y166.268 E.009
G1 X183.727 Y166.57 E.01039
G1 X183.951 Y166.736 E.00855
G1 X184.233 Y166.792 E.00882
G1 X184.513 Y166.735 E.00879
G1 X184.749 Y166.591 E.00849
G1 X184.903 Y166.337 E.00911
G1 X184.948 Y166.046 E.00905
G1 X184.853 Y165.74 E.00986
G1 X184.672 Y165.537 E.00834
G1 X184.433 Y165.421 E.00816
G1 X184.187 Y165.402 E.00759
G1 X183.87 Y165.527 E.01046
G1 X183.712 Y165.673 E.0066
M204 S10000
G1 X183.388 Y165.447 F60000
G1 F2175
M204 S8000
G1 X183.2 Y165.841 E.01341
G1 X183.191 Y166.201 E.01108
G1 X183.267 Y166.509 E.00974
G1 X183.446 Y166.824 E.01113
G1 X183.789 Y167.078 E.01311
G1 X184.169 Y167.177 E.01208
G1 X184.51 Y167.144 E.01052
G1 X184.908 Y166.953 E.01355
G1 X185.096 Y166.771 E.00808
G1 X185.261 Y166.468 E.0106
G1 X185.325 Y166.03 E.0136
G1 X185.274 Y165.751 E.0087
G1 X185.053 Y165.375 E.01339
G1 X184.729 Y165.13 E.01251
G1 X184.306 Y165.02 E.01343
G1 X183.947 Y165.08 E.01118
G2 X183.434 Y165.408 I.33 J1.081 E.01895
M204 S10000
G1 X183 Y165.359 F60000
G1 F2175
M204 S8000
G1 X182.832 Y165.749 E.01304
G2 X182.836 Y166.453 I2.234 J.341 E.02172
G1 X183.007 Y166.864 E.01369
G1 X183.271 Y167.175 E.01254
G1 X183.626 Y167.42 E.01326
G1 X184.015 Y167.535 E.01246
G2 X184.602 Y167.514 I.184 J-3.111 E.01809
G1 X185.014 Y167.343 E.01371
G1 X185.304 Y167.101 E.0116
G2 X185.62 Y166.598 I-2.459 J-1.892 E.01828
G1 X185.708 Y166.162 E.01369
G2 X185.632 Y165.627 I-2.007 J.014 E.01665
G1 X185.418 Y165.235 E.01373
G1 X185.128 Y164.933 E.01285
G1 X184.757 Y164.738 E.01288
G1 X184.327 Y164.641 E.01355
G2 X183.634 Y164.779 I.089 J2.259 E.02181
G1 X183.267 Y165.022 E.01351
G1 X183.038 Y165.312 E.01136
M204 S10000
G1 X182.7 Y165.128 F60000
G1 F2175
M204 S8000
G1 X182.517 Y165.512 E.01307
G1 X182.414 Y165.999 E.01531
G1 X182.466 Y166.545 E.01685
G1 X182.676 Y167.051 E.01685
G1 X183.016 Y167.453 E.01617
G1 X183.464 Y167.763 E.01671
G1 X183.959 Y167.908 E.01588
G2 X184.695 Y167.884 I.27 J-3.028 E.02266
G1 X185.201 Y167.674 E.01686
G1 X185.582 Y167.357 E.01522
G2 X185.978 Y166.729 I-2.357 J-1.926 E.02287
G1 X186.087 Y166.191 E.01685
G1 X186.078 Y165.997 E.00598
G1 X185.99 Y165.502 E.01543
G1 X185.725 Y165.016 E.01703
G1 X185.356 Y164.63 E.01637
G1 X184.9 Y164.388 E.01589
G1 X184.505 Y164.288 E.01253
G1 X183.999 Y164.278 E.01555
G1 X183.473 Y164.433 E.01685
G1 X183.02 Y164.732 E.01666
G1 X182.738 Y165.081 E.01379
; COOLING_NODE: 5
; WIPE_START
G1 F9547.299
G1 X183.02 Y164.732 E-.17051
G1 X183.473 Y164.433 E-.20609
G1 X183.999 Y164.278 E-.20837
G1 X184.459 Y164.287 E-.17503
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X182.808 Y156.835 Z6.8 F60000
G1 X182.102 Y153.648 Z6.8
G1 Z6.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2175
M204 S8000
G1 X182.102 Y152.852 E.0264
G1 X187.298 Y152.852 E.17236
G1 X187.298 Y153.648 E.0264
G1 X182.162 Y153.648 E.17037
; COOLING_NODE: 5
M204 S250
G1 X181.71 Y154.04 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2175
M204 S5000
G1 X181.71 Y152.46 E.04855
G1 X187.69 Y152.46 E.18375
G1 X187.69 Y154.04 E.04855
G1 X181.77 Y154.04 E.18191
M204 S10000
G1 X182.306 Y153.25 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F2175
M204 S8000
G1 X187.094 Y153.25 E.15172
; CHANGE_LAYER
; Z_HEIGHT: 6.40952
; LAYER_HEIGHT: 0.00952387
; WIPE_START
G1 F9259.259
G1 X185.094 Y153.25 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 44/85
; update layer progress
M73 L44
M991 S0 P43 ;notify layer change

; OBJECT_ID: 15
M204 S10000
G17
G3 Z6.8 I-.062 J-1.215 P1  F60000
G1 X169.095 Y154.062 Z6.8
G1 Z6.41
G1 E.8 F1800
; FEATURE: Support
; LINE_WIDTH: 0.42
; LAYER_HEIGHT: 0.27619
G1 F2412
M204 S8000
G1 X180.961 Y154.062 E.48169
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X180.961 Y152.438 E.06589
G1 X169.039 Y152.438 E.48399
G1 X169.039 Y154.062 E.06589
; CHANGE_LAYER
; Z_HEIGHT: 6.6
; LAYER_HEIGHT: 0.190476
; WIPE_START
G1 F7226.745
G1 X169.039 Y152.438 E-.61679
G1 X169.415 Y152.438 E-.14321
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 45/85
; update layer progress
M73 L45
M991 S0 P44 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 4
M204 S10000
G17
G3 Z6.81 I-1.21 J-.133 P1  F60000
G1 X167.952 Y165.752 Z6.81
G1 Z6.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
; LAYER_HEIGHT: 0.2
G1 F2412
M204 S8000
G1 X167.983 Y166.139 E.01289
G3 X165.771 Y163.867 I-2.233 J-.039 E.34841
G1 X165.864 Y163.87 E.00309
G3 X167.946 Y165.692 I-.113 J2.23 E.099
; COOLING_NODE: 4
M204 S10000
G1 X168.368 Y165.78 F60000
G1 F2412
M204 S8000
G1 X168.383 Y165.894 E.00382
G3 X165.775 Y163.46 I-2.632 J.205 E.42029
G1 X165.886 Y163.463 E.0037
G3 X168.351 Y165.641 I-.135 J2.637 E.11781
G1 X168.361 Y165.721 E.00265
; COOLING_NODE: 4
M204 S10000
G1 X168.771 Y165.729 F60000
G1 F2412
M204 S8000
G1 X168.79 Y165.862 E.00447
G3 X165.778 Y163.052 I-3.038 J.237 E.48508
G1 X165.908 Y163.056 E.00431
G3 X168.753 Y165.571 I-.156 J3.043 E.13596
G1 X168.764 Y165.669 E.0033
; COOLING_NODE: 4
M204 S250
G1 X169.16 Y165.68 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2294
M204 S5000
G1 X169.182 Y165.832 E.00472
G3 X165.782 Y162.66 I-3.429 J.268 E.50715
G1 X165.929 Y162.665 E.00453
G3 X169.14 Y165.502 I-.177 J3.435 E.14213
G1 X169.153 Y165.62 E.00364
; WIPE_START
G1 F9547.055
M204 S8000
G1 X169.182 Y165.832 E-.08118
G1 X169.189 Y166.16 E-.12496
G1 X169.164 Y166.519 E-.13671
G1 X169.115 Y166.814 E-.11349
G1 X169.022 Y167.163 E-.13735
G1 X168.904 Y167.473 E-.1261
G1 X168.857 Y167.568 E-.04021
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X165.947 Y165.94 Z7 F60000
G1 Z6.6
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.54138
G1 F2412
M204 S8000
G1 X165.751 Y165.838 E.00899
G1 X165.58 Y165.899 E.00737
G1 X165.49 Y166.067 E.00772
G1 X165.544 Y166.246 E.00759
G1 X165.707 Y166.349 E.00783
G1 X165.884 Y166.31 E.00737
G1 X165.998 Y166.155 E.00782
G2 X165.971 Y165.995 I-.126 J-.061 E.00701
M204 S10000
G1 X166.365 Y165.76 F60000
; LINE_WIDTH: 0.41999
G1 F2412
M204 S8000
G1 X166.118 Y165.511 E.01077
G1 X165.783 Y165.398 E.01086
G1 X165.465 Y165.461 E.00998
G1 X165.241 Y165.621 E.00847
G1 X165.093 Y165.859 E.00859
G1 X165.052 Y166.185 E.01011
G1 X165.181 Y166.499 E.01044
G1 X165.432 Y166.718 E.01023
G1 X165.732 Y166.787 E.00946
G1 X166.033 Y166.735 E.00938
G1 X166.272 Y166.547 E.00934
G1 X166.435 Y166.248 E.01044
G1 X166.449 Y166.073 E.0054
M73 P71 R4
G1 X166.381 Y165.818 E.00813
M204 S10000
G1 X166.581 Y165.41 F60000
G1 F2412
M204 S8000
G1 X166.32 Y165.187 E.01053
G1 X165.894 Y165.034 E.01392
G1 X165.6 Y165.029 E.00905
G1 X165.211 Y165.162 E.01264
G1 X164.893 Y165.441 E.01297
G1 X164.705 Y165.819 E.01298
G1 X164.676 Y166.231 E.01269
G1 X164.798 Y166.575 E.01122
G2 X165.564 Y167.16 I.986 J-.497 E.03064
G2 X166.663 Y166.67 I.185 J-1.062 E.03921
G1 X166.816 Y166.255 E.01361
G2 X166.61 Y165.463 I-1.038 J-.153 E.02583
M204 S10000
G1 X166.953 Y165.285 F60000
G1 F2412
M204 S8000
G2 X166.522 Y164.864 I-2.257 J1.877 E.01856
G1 X166.112 Y164.686 E.01374
G1 X165.677 Y164.648 E.01343
G1 X165.276 Y164.719 E.01252
G1 X164.907 Y164.915 E.01283
G1 X164.592 Y165.21 E.01325
G1 X164.386 Y165.595 E.01342
G1 X164.293 Y165.998 E.01272
G1 X164.325 Y166.39 E.01208
G2 X164.556 Y166.936 I2.981 J-.94 E.01825
G1 X164.967 Y167.325 E.01739
G1 X165.497 Y167.535 E.01751
G1 X165.926 Y167.546 E.01318
G1 X166.343 Y167.431 E.0133
G1 X166.706 Y167.2 E.01322
G1 X166.986 Y166.873 E.01323
G1 X167.163 Y166.464 E.01369
G1 X167.203 Y166.054 E.01265
G1 X167.14 Y165.651 E.01255
G1 X166.981 Y165.339 E.01075
M204 S10000
G1 X167.262 Y165.069 F60000
G1 F2412
M204 S8000
G1 X167.144 Y164.9 E.00636
G1 X166.724 Y164.541 E.01696
G1 X166.218 Y164.321 E.01695
G1 X165.681 Y164.27 E.01659
G1 X165.153 Y164.36 E.01647
G1 X164.691 Y164.607 E.01608
G1 X164.292 Y164.979 E.01678
G1 X164.034 Y165.462 E.01683
G1 X163.915 Y165.972 E.01607
G1 X163.957 Y166.471 E.01541
G2 X164.244 Y167.155 I2.934 J-.83 E.02284
G1 X164.62 Y167.551 E.01679
G1 X164.909 Y167.736 E.01052
G1 X165.431 Y167.911 E.01691
G1 X165.972 Y167.925 E.01664
G1 X166.498 Y167.78 E.01676
G1 X166.956 Y167.487 E.01669
G1 X167.309 Y167.075 E.0167
G1 X167.528 Y166.571 E.01685
G1 X167.58 Y166.044 E.01627
G1 X167.5 Y165.534 E.01588
G1 X167.29 Y165.123 E.01419
; COOLING_NODE: 5
; WIPE_START
G1 F9547.299
G1 X167.5 Y165.534 E-.17554
G1 X167.58 Y166.044 E-.19643
G1 X167.528 Y166.571 E-.20125
G1 X167.332 Y167.022 E-.18678
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X167.655 Y159.397 Z7 F60000
G1 X167.898 Y153.648 Z7
G1 Z6.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2412
M204 S8000
G1 X162.702 Y153.648 E.17236
G1 X162.702 Y152.852 E.0264
G1 X167.898 Y152.852 E.17236
G1 X167.898 Y153.588 E.02441
; COOLING_NODE: 5
M204 S250
G1 X168.29 Y154.04 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2294
M204 S5000
G1 X162.31 Y154.04 E.18375
G1 X162.31 Y152.46 E.04855
G1 X168.29 Y152.46 E.18375
G1 X168.29 Y153.98 E.04671
M204 S10000
G1 X167.694 Y153.25 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F2412
M204 S8000
G1 X162.906 Y153.25 E.15172
; COOLING_NODE: 1
; WIPE_START
G1 F9259.259
G1 X164.906 Y153.25 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.093 Y157.719 Z7 F60000
G1 X182.065 Y165.642 Z7
G1 Z6.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2412
M204 S8000
G3 X184.271 Y163.867 I2.186 J.457 E.10174
G1 X184.364 Y163.87 E.00309
G3 X182.054 Y165.701 I-.113 J2.23 E.35859
; COOLING_NODE: 1
M204 S10000
G1 X181.668 Y165.556 F60000
G1 F2412
M204 S8000
G3 X184.275 Y163.46 I2.583 J.544 E.12018
G1 X184.386 Y163.463 E.0037
G3 X181.656 Y165.615 I-.135 J2.637 E.4244
; COOLING_NODE: 1
M204 S10000
G1 X181.256 Y165.541 F60000
G1 F2412
M204 S8000
G1 X181.271 Y165.47 E.00242
G3 X184.278 Y163.052 I2.981 J.63 E.13861
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X184.408 Y163.056 E.00431
G3 X181.227 Y165.728 I-.156 J3.043 E.48349
G1 X181.247 Y165.601 E.00429
; COOLING_NODE: 1
M204 S250
G1 X180.87 Y165.477 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2294
M204 S5000
G1 X180.888 Y165.387 E.00283
G3 X184.282 Y162.66 I3.365 J.713 E.14484
G1 X184.429 Y162.665 E.00453
G3 X180.839 Y165.681 I-.177 J3.435 E.50548
G1 X180.861 Y165.536 E.00449
; WIPE_START
G1 F9547.055
M204 S8000
G1 X180.888 Y165.387 E-.05779
G1 X180.979 Y165.037 E-.13739
G1 X181.096 Y164.727 E-.12595
G1 X181.241 Y164.432 E-.1248
G1 X181.432 Y164.127 E-.13692
G1 X181.615 Y163.889 E-.11397
G1 X181.728 Y163.767 E-.06319
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X184.072 Y165.908 Z7 F60000
G1 Z6.6
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.54136
G1 F2412
M204 S8000
G1 X183.987 Y166.082 E.00786
G1 X184.044 Y166.245 E.00702
G1 X184.207 Y166.349 E.00785
G1 X184.384 Y166.31 E.00737
G2 X184.513 Y166.117 I-.23 J-.291 E.00958
G1 X184.44 Y165.935 E.00796
G1 X184.251 Y165.838 E.00865
G1 X184.128 Y165.886 E.00535
M204 S10000
G1 X183.65 Y165.742 F60000
; LINE_WIDTH: 0.41999
G1 F2412
M204 S8000
G1 X183.558 Y165.994 E.00823
G1 X183.573 Y166.282 E.00888
G1 X183.752 Y166.574 E.01051
G1 X183.931 Y166.718 E.00706
G1 X184.232 Y166.787 E.0095
G1 X184.533 Y166.735 E.00938
G1 X184.772 Y166.547 E.00935
G1 X184.935 Y166.248 E.01045
G1 X184.95 Y166.106 E.0044
G1 X184.885 Y165.817 E.00909
G1 X184.697 Y165.578 E.00934
G1 X184.4 Y165.416 E.01039
G1 X184.096 Y165.417 E.00935
G1 X183.841 Y165.531 E.00858
G1 X183.69 Y165.697 E.00688
M204 S10000
G1 X183.393 Y165.441 F60000
G1 F2412
M204 S8000
G1 X183.205 Y165.82 E.01299
G1 X183.176 Y166.232 E.01272
G1 X183.297 Y166.574 E.01114
G2 X184.064 Y167.16 I.988 J-.498 E.03067
G2 X185.163 Y166.67 I.185 J-1.062 E.03922
G1 X185.316 Y166.256 E.01357
G1 X185.327 Y166.096 E.00492
G1 X185.233 Y165.662 E.01365
G2 X184.82 Y165.187 I-.988 J.443 E.01961
G1 X184.394 Y165.034 E.01393
G1 X184.099 Y165.029 E.00905
G1 X183.697 Y165.17 E.01309
G1 X183.438 Y165.401 E.01068
M204 S10000
G1 X183.092 Y165.21 F60000
G1 F2412
M204 S8000
G1 X182.886 Y165.596 E.01343
G1 X182.793 Y165.998 E.01269
G1 X182.825 Y166.391 E.01212
G2 X183.056 Y166.936 I2.984 J-.943 E.01822
G1 X183.468 Y167.326 E.01742
G1 X183.997 Y167.535 E.01749
G1 X184.426 Y167.546 E.01318
G1 X184.843 Y167.431 E.0133
G1 X185.206 Y167.2 E.01322
G1 X185.486 Y166.872 E.01325
G1 X185.663 Y166.464 E.01368
G1 X185.704 Y166.087 E.01165
G2 X185.581 Y165.507 I-3.081 J.349 E.01823
G1 X185.35 Y165.144 E.01323
G1 X185.022 Y164.864 E.01323
G1 X184.612 Y164.686 E.01374
G1 X184.177 Y164.648 E.01342
G1 X183.777 Y164.718 E.01247
G1 X183.4 Y164.919 E.01312
G1 X183.136 Y165.169 E.01118
M204 S10000
G1 X182.792 Y164.979 F60000
G1 F2412
M204 S8000
G1 X182.534 Y165.462 E.01681
G1 X182.415 Y165.972 E.01608
G1 X182.457 Y166.472 E.01544
G2 X182.744 Y167.155 I2.931 J-.831 E.0228
G1 X183.122 Y167.552 E.01686
G1 X183.409 Y167.735 E.01046
G1 X183.931 Y167.911 E.01692
G1 X184.472 Y167.925 E.01664
G1 X184.998 Y167.78 E.01676
G1 X185.456 Y167.488 E.01669
G1 X185.81 Y167.074 E.01671
G1 X186.028 Y166.571 E.01684
G1 X186.081 Y166.077 E.01528
G2 X185.93 Y165.352 I-3.034 J.254 E.02282
G1 X185.637 Y164.894 E.0167
G1 X185.224 Y164.541 E.0167
G1 X184.718 Y164.321 E.01696
G1 X184.181 Y164.27 E.01658
G1 X183.653 Y164.36 E.01644
G1 X183.18 Y164.613 E.01649
G1 X182.835 Y164.938 E.01457
; COOLING_NODE: 5
; WIPE_START
G1 F9547.299
G1 X183.18 Y164.613 E-.18018
G1 X183.653 Y164.36 E-.20389
G1 X184.181 Y164.27 E-.20338
G1 X184.633 Y164.313 E-.17256
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X182.871 Y156.887 Z7 F60000
G1 X182.102 Y153.648 Z7
G1 Z6.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2412
M204 S8000
G1 X182.102 Y152.852 E.0264
G1 X187.298 Y152.852 E.17236
G1 X187.298 Y153.648 E.0264
G1 X182.162 Y153.648 E.17037
; COOLING_NODE: 5
M204 S250
G1 X181.71 Y154.04 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2294
M204 S5000
G1 X181.71 Y152.46 E.04855
G1 X187.69 Y152.46 E.18375
G1 X187.69 Y154.04 E.04855
G1 X181.77 Y154.04 E.18191
M204 S10000
G1 X182.306 Y153.25 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F2412
M204 S8000
G1 X187.094 Y153.25 E.15172
; CHANGE_LAYER
; Z_HEIGHT: 6.68571
; LAYER_HEIGHT: 0.0857143
; WIPE_START
G1 F9259.259
G1 X185.094 Y153.25 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 46/85
; update layer progress
M73 L46
M991 S0 P45 ;notify layer change

; OBJECT_ID: 15
M204 S10000
G17
G3 Z7 I-.062 J-1.215 P1  F60000
G1 X169.095 Y154.062 Z7
G1 Z6.686
G1 E.8 F1800
; FEATURE: Support
; LINE_WIDTH: 0.42
; LAYER_HEIGHT: 0.27619
G1 F2411
M204 S8000
G1 X180.961 Y154.062 E.48169
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X180.961 Y152.438 E.06589
G1 X169.039 Y152.438 E.48399
G1 X169.039 Y154.062 E.06589
; CHANGE_LAYER
; Z_HEIGHT: 6.8
; LAYER_HEIGHT: 0.114286
; WIPE_START
G1 F7226.745
G1 X169.039 Y152.438 E-.61679
G1 X169.415 Y152.438 E-.14321
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 47/85
; update layer progress
M73 L47
M991 S0 P46 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 4
M204 S10000
G17
G3 Z7.086 I-1.21 J-.133 P1  F60000
G1 X167.952 Y165.749 Z7.086
G1 Z6.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
; LAYER_HEIGHT: 0.2
G1 F2411
M204 S8000
G1 X167.984 Y166.139 E.01298
G3 X165.779 Y163.867 I-2.233 J-.04 E.34867
G1 X165.863 Y163.869 E.00278
G3 X167.946 Y165.69 I-.112 J2.23 E.09897
; COOLING_NODE: 4
M204 S10000
G1 X168.369 Y165.784 F60000
G1 F2411
M204 S8000
G1 X168.381 Y165.865 E.00272
G3 X165.783 Y163.46 I-2.63 J.235 E.42153
G1 X165.885 Y163.463 E.00338
G3 X168.352 Y165.641 I-.134 J2.637 E.11786
G1 X168.362 Y165.724 E.00277
; COOLING_NODE: 4
M204 S10000
G1 X168.772 Y165.73 F60000
G1 F2411
M204 S8000
G1 X168.788 Y165.831 E.0034
G3 X165.787 Y163.053 I-3.035 J.268 E.48642
G1 X165.908 Y163.056 E.00399
G3 X168.753 Y165.571 I-.155 J3.043 E.13599
G1 X168.765 Y165.67 E.00333
; COOLING_NODE: 4
M204 S250
G1 X169.161 Y165.678 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2274
M204 S5000
G1 X169.179 Y165.799 E.00375
G3 X165.792 Y162.66 I-3.426 J.301 E.50846
G1 X165.929 Y162.665 E.00423
G3 X169.14 Y165.502 I-.176 J3.435 E.14213
G1 X169.154 Y165.619 E.0036
; WIPE_START
G1 F9547.055
M204 S8000
G1 X169.179 Y165.799 E-.06914
G1 X169.189 Y166.16 E-.13754
G1 X169.166 Y166.501 E-.12959
G1 X169.115 Y166.815 E-.12119
G1 X169.021 Y167.164 E-.13695
G1 X168.916 Y167.444 E-.11387
G1 X168.857 Y167.567 E-.05172
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X165.89 Y165.887 Z7.2 F60000
G1 Z6.8
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.541146
G1 F2411
M204 S8000
G1 X165.743 Y165.838 E.0063
G1 X165.563 Y165.934 E.0083
G1 X165.488 Y166.079 E.00665
G1 X165.549 Y166.267 E.008
G1 X165.708 Y166.359 E.00747
G1 X165.841 Y166.347 E.0054
G1 X166.005 Y166.166 E.00992
G1 X166.012 Y166.083 E.00335
G1 X165.922 Y165.938 E.00692
M204 S10000
G1 X166.382 Y165.826 F60000
; LINE_WIDTH: 0.41999
G1 F2411
M204 S8000
G1 X166.202 Y165.58 E.00936
G1 X165.99 Y165.443 E.00776
G1 X165.698 Y165.402 E.00907
G1 X165.433 Y165.49 E.00857
G1 X165.171 Y165.706 E.01045
G1 X165.059 Y165.987 E.00929
G1 X165.072 Y166.268 E.00864
G1 X165.196 Y166.525 E.00876
G1 X165.386 Y166.698 E.00789
G1 X165.636 Y166.79 E.00819
G1 X165.942 Y166.772 E.00941
G1 X166.178 Y166.638 E.00834
G1 X166.394 Y166.376 E.01043
G1 X166.45 Y166.073 E.00949
G1 X166.398 Y165.884 E.00601
M204 S10000
G1 X166.621 Y165.468 F60000
G1 F2411
M204 S8000
G1 X166.292 Y165.169 E.01365
G1 X166.031 Y165.055 E.00875
G1 X165.6 Y165.029 E.01326
G1 X165.26 Y165.156 E.01117
G1 X164.995 Y165.35 E.01008
G1 X164.778 Y165.625 E.01076
G1 X164.671 Y166.023 E.01267
G1 X164.728 Y166.454 E.01336
G1 X164.952 Y166.83 E.01342
G1 X165.276 Y167.072 E.01244
G1 X165.673 Y167.179 E.01264
G1 X166.106 Y167.121 E.0134
G1 X166.412 Y166.933 E.01105
G1 X166.628 Y166.702 E.00973
G1 X166.795 Y166.38 E.01114
G2 X166.648 Y165.521 I-1.043 J-.264 E.02757
M204 S10000
G1 X166.929 Y165.243 F60000
G1 F2411
M204 S8000
G1 X166.614 Y164.924 E.01378
G1 X166.254 Y164.736 E.01247
G1 X165.825 Y164.641 E.01351
G1 X165.434 Y164.681 E.01209
G2 X164.893 Y164.921 I.978 J2.929 E.0182
G1 X164.576 Y165.233 E.01369
G1 X164.385 Y165.599 E.01267
G1 X164.293 Y165.997 E.01256
G1 X164.338 Y166.44 E.01367
G1 X164.488 Y166.834 E.01296
M73 P72 R4
G1 X164.772 Y167.176 E.01368
G1 X165.11 Y167.413 E.01266
G1 X165.512 Y167.534 E.0129
G1 X165.933 Y167.549 E.01296
G1 X166.335 Y167.431 E.01287
G2 X166.816 Y167.094 I-1.545 J-2.716 E.01809
G1 X167.068 Y166.727 E.01367
G1 X167.186 Y166.33 E.01271
G1 X167.204 Y166.054 E.00849
G1 X167.135 Y165.64 E.01291
G1 X166.957 Y165.297 E.01188
M204 S10000
G1 X167.238 Y165.019 F60000
G1 F2411
M204 S8000
G1 X166.85 Y164.626 E.01695
G1 X166.387 Y164.383 E.01609
G1 X165.846 Y164.263 E.01701
G1 X165.346 Y164.314 E.01546
G2 X164.669 Y164.612 I.882 J2.916 E.02277
G1 X164.278 Y164.997 E.01685
G1 X164.032 Y165.467 E.0163
G1 X163.915 Y165.971 E.0159
G1 X163.966 Y166.508 E.01656
G1 X164.086 Y166.862 E.01149
G1 X164.387 Y167.336 E.01726
G1 X164.787 Y167.657 E.01575
G1 X165.274 Y167.877 E.01642
G1 X165.795 Y167.93 E.0161
G1 X166.199 Y167.874 E.01252
G1 X166.665 Y167.695 E.01535
G1 X167.095 Y167.354 E.01687
G1 X167.405 Y166.902 E.01683
G1 X167.557 Y166.393 E.01632
G1 X167.581 Y166.045 E.01072
G1 X167.492 Y165.509 E.01671
G1 X167.265 Y165.073 E.0151
; COOLING_NODE: 5
; WIPE_START
G1 F9547.299
G1 X167.492 Y165.509 E-.18679
G1 X167.581 Y166.045 E-.20661
G1 X167.557 Y166.393 E-.13257
G1 X167.405 Y166.902 E-.20177
G1 X167.357 Y166.972 E-.03225
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X167.667 Y159.346 Z7.2 F60000
G1 X167.898 Y153.648 Z7.2
G1 Z6.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2411
M204 S8000
G1 X162.702 Y153.648 E.17236
G1 X162.702 Y152.852 E.0264
G1 X167.898 Y152.852 E.17236
G1 X167.898 Y153.588 E.02441
; COOLING_NODE: 5
M204 S250
G1 X168.29 Y154.04 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2274
M204 S5000
G1 X162.31 Y154.04 E.18375
G1 X162.31 Y152.46 E.04855
G1 X168.29 Y152.46 E.18375
G1 X168.29 Y153.98 E.04671
M204 S10000
G1 X167.694 Y153.25 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F2411
M204 S8000
G1 X162.906 Y153.25 E.15172
; COOLING_NODE: 1
; WIPE_START
G1 F9259.259
G1 X164.906 Y153.25 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.093 Y157.718 Z7.2 F60000
G1 X182.066 Y165.642 Z7.2
G1 Z6.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2411
M204 S8000
G3 X184.279 Y163.867 I2.186 J.458 E.10198
G1 X184.363 Y163.869 E.00278
G3 X182.054 Y165.701 I-.112 J2.23 E.35865
; COOLING_NODE: 1
M204 S10000
G1 X181.668 Y165.555 F60000
G1 F2411
M204 S8000
G3 X184.283 Y163.46 I2.583 J.544 E.12043
G1 X184.385 Y163.463 E.00338
G3 X181.657 Y165.614 I-.134 J2.637 E.42446
; COOLING_NODE: 1
M204 S10000
G1 X181.259 Y165.526 F60000
G1 F2411
M204 S8000
G1 X181.271 Y165.469 E.00193
G3 X184.287 Y163.053 I2.981 J.63 E.13888
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X184.408 Y163.056 E.00399
G3 X181.228 Y165.729 I-.155 J3.043 E.48352
G1 X181.25 Y165.586 E.0048
; COOLING_NODE: 1
M204 S250
G1 X180.872 Y165.462 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2274
M204 S5000
G1 X180.888 Y165.386 E.00238
G3 X184.292 Y162.66 I3.365 J.713 E.14511
G1 X184.429 Y162.665 E.00423
G3 X180.839 Y165.681 I-.176 J3.435 E.50549
G1 X180.863 Y165.521 E.00496
; WIPE_START
G1 F9547.055
M204 S8000
G1 X180.888 Y165.386 E-.05222
G1 X180.978 Y165.037 E-.13689
G1 X181.083 Y164.756 E-.11398
G1 X181.241 Y164.432 E-.137
G1 X181.398 Y164.177 E-.11386
G1 X181.615 Y163.889 E-.13684
G1 X181.739 Y163.756 E-.06921
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X183.995 Y166.04 Z7.2 F60000
G1 Z6.8
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.54113
G1 F2411
M204 S8000
G1 X184.045 Y166.258 E.00909
G1 X184.231 Y166.362 E.00865
G1 X184.386 Y166.324 E.00651
G1 X184.493 Y166.166 E.00775
G1 X184.454 Y165.952 E.00883
G1 X184.307 Y165.845 E.00742
G1 X184.159 Y165.854 E.00602
G1 X184.035 Y165.995 E.00761
M204 S10000
G1 X183.682 Y165.713 F60000
; LINE_WIDTH: 0.41999
G1 F2411
M204 S8000
G1 X183.564 Y165.962 E.00848
G1 X183.573 Y166.255 E.00901
G1 X183.717 Y166.554 E.01021
G1 X184.008 Y166.744 E.01066
G1 X184.243 Y166.8 E.00742
G1 X184.536 Y166.739 E.0092
G2 X184.933 Y166.178 I-.422 J-.719 E.02174
G1 X184.907 Y165.874 E.00938
G1 X184.717 Y165.595 E.01035
G1 X184.519 Y165.453 E.0075
G1 X184.211 Y165.401 E.00959
G1 X183.93 Y165.477 E.00894
G1 X183.726 Y165.671 E.00868
M204 S10000
G1 X183.371 Y165.5 F60000
G1 F2411
M204 S8000
G1 X183.205 Y165.82 E.01108
G1 X183.189 Y166.181 E.01111
G1 X183.262 Y166.494 E.00987
G1 X183.44 Y166.814 E.01126
G1 X183.675 Y167.01 E.0094
G1 X184.094 Y167.166 E.01373
G1 X184.384 Y167.173 E.00893
G1 X184.791 Y167.037 E.01318
G1 X185.059 Y166.791 E.01118
G2 X185.007 Y165.353 I-.855 J-.689 E.04822
G1 X184.725 Y165.128 E.01109
G1 X184.304 Y165.019 E.01335
G1 X183.898 Y165.077 E.01261
G1 X183.588 Y165.267 E.01115
G1 X183.412 Y165.456 E.00793
M204 S10000
G1 X182.932 Y165.474 F60000
G1 F2411
M204 S8000
G1 X182.82 Y165.837 E.01169
G2 X182.83 Y166.427 I3.065 J.243 E.01816
G1 X182.996 Y166.846 E.01383
G2 X183.474 Y167.335 I1.729 J-1.213 E.02111
G1 X183.886 Y167.513 E.01379
G1 X184.297 Y167.553 E.01267
G1 X184.728 Y167.48 E.01343
G1 X185.075 Y167.297 E.01205
G2 X185.486 Y166.872 I-2.027 J-2.371 E.0182
G1 X185.657 Y166.478 E.01319
G1 X185.707 Y166.049 E.01328
G1 X185.628 Y165.626 E.01323
G1 X185.429 Y165.243 E.01323
G1 X185.114 Y164.924 E.01378
G1 X184.754 Y164.736 E.0125
G1 X184.325 Y164.641 E.01349
G1 X183.888 Y164.692 E.01354
G1 X183.534 Y164.828 E.01165
G1 X183.184 Y165.106 E.01373
G1 X182.966 Y165.424 E.01185
M204 S10000
G1 X182.595 Y165.299 F60000
G1 F2411
M204 S8000
G1 X182.448 Y165.775 E.01532
G2 X182.458 Y166.514 I3.023 J.327 E.02275
G1 X182.663 Y167.03 E.01706
G1 X182.886 Y167.333 E.01156
G1 X183.274 Y167.659 E.01558
G1 X183.779 Y167.878 E.01689
G1 X184.308 Y167.93 E.01633
G1 X184.85 Y167.839 E.0169
G1 X185.294 Y167.605 E.01542
G2 X185.809 Y167.074 I-1.91 J-2.373 E.02278
G1 X186.025 Y166.577 E.01665
G1 X186.088 Y166.036 E.01675
G1 X185.988 Y165.502 E.01669
G1 X185.738 Y165.019 E.0167
G1 X185.35 Y164.627 E.01694
G1 X184.886 Y164.383 E.01612
G1 X184.346 Y164.263 E.01698
G1 X183.833 Y164.317 E.01587
G1 X183.336 Y164.504 E.01631
G1 X182.905 Y164.846 E.0169
G1 X182.629 Y165.249 E.01501
; COOLING_NODE: 5
; WIPE_START
G1 F9547.299
G1 X182.905 Y164.846 E-.1856
G1 X183.336 Y164.504 E-.20897
G1 X183.833 Y164.317 E-.20175
G1 X184.261 Y164.272 E-.16368
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X182.741 Y156.792 Z7.2 F60000
G1 X182.102 Y153.648 Z7.2
G1 Z6.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2411
M204 S8000
G1 X182.102 Y152.852 E.0264
G1 X187.298 Y152.852 E.17236
G1 X187.298 Y153.648 E.0264
G1 X182.162 Y153.648 E.17037
; COOLING_NODE: 5
M204 S250
G1 X181.71 Y154.04 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2274
M204 S5000
G1 X181.71 Y152.46 E.04855
G1 X187.69 Y152.46 E.18375
G1 X187.69 Y154.04 E.04855
G1 X181.77 Y154.04 E.18191
M204 S10000
G1 X182.306 Y153.25 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F2411
M204 S8000
G1 X187.094 Y153.25 E.15172
; CHANGE_LAYER
; Z_HEIGHT: 6.9619
; LAYER_HEIGHT: 0.161904
; WIPE_START
G1 F9259.259
G1 X185.094 Y153.25 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 48/85
; update layer progress
M73 L48
M991 S0 P47 ;notify layer change

; OBJECT_ID: 15
M204 S10000
G17
G3 Z7.2 I-.062 J-1.215 P1  F60000
G1 X169.095 Y154.062 Z7.2
G1 Z6.962
G1 E.8 F1800
; FEATURE: Support
; LINE_WIDTH: 0.42
; LAYER_HEIGHT: 0.27619
G1 F2405
M204 S8000
G1 X180.961 Y154.062 E.48169
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X180.961 Y152.438 E.06589
G1 X169.039 Y152.438 E.48399
G1 X169.039 Y154.062 E.06589
; CHANGE_LAYER
; Z_HEIGHT: 7
; LAYER_HEIGHT: 0.0380955
; WIPE_START
G1 F7226.745
G1 X169.039 Y152.438 E-.61679
G1 X169.415 Y152.438 E-.14321
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 49/85
; update layer progress
M73 L49
M991 S0 P48 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 4
M204 S10000
G17
G3 Z7.362 I-1.21 J-.133 P1  F60000
G1 X167.952 Y165.746 Z7.362
G1 Z7
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
; LAYER_HEIGHT: 0.2
G1 F2405
M204 S8000
G1 X167.983 Y166.139 E.01308
G3 X165.788 Y163.867 I-2.232 J-.04 E.34885
G1 X165.862 Y163.869 E.00246
G3 X167.945 Y165.687 I-.111 J2.23 E.09889
; COOLING_NODE: 4
M204 S10000
G1 X168.366 Y165.768 F60000
G1 F2405
M204 S8000
G1 X168.384 Y165.912 E.00479
G3 X165.792 Y163.46 I-2.633 J.187 E.42016
G1 X165.885 Y163.463 E.00307
G3 X168.351 Y165.641 I-.133 J2.636 E.11785
G1 X168.359 Y165.709 E.00226
; COOLING_NODE: 4
M204 S10000
G1 X168.77 Y165.719 F60000
G1 F2405
M204 S8000
G1 X168.79 Y165.881 E.00543
G3 X165.797 Y163.053 I-3.039 J.218 E.48493
G1 X165.908 Y163.056 E.00367
G3 X168.752 Y165.571 I-.156 J3.042 E.13596
G1 X168.763 Y165.659 E.00295
; COOLING_NODE: 4
M204 S250
G1 X169.158 Y165.67 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2259
M204 S5000
G1 X169.182 Y165.851 E.0056
G3 X165.801 Y162.661 I-3.429 J.247 E.50699
G1 X165.929 Y162.665 E.00393
G3 X169.138 Y165.503 I-.177 J3.434 E.1421
G1 X169.151 Y165.611 E.00335
; WIPE_START
G1 F9547.055
M204 S8000
G1 X169.182 Y165.851 E-.09206
G1 X169.189 Y166.161 E-.11758
G1 X169.164 Y166.519 E-.13673
G1 X169.102 Y166.873 E-.1366
G1 X169.005 Y167.212 E-.13365
G1 X168.892 Y167.499 E-.11746
G1 X168.861 Y167.56 E-.02592
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X166.002 Y166.037 Z7.4 F60000
G1 Z7
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.540317
G1 F2405
M204 S8000
G1 X165.891 Y165.893 E.00732
G1 X165.731 Y165.838 E.00687
G1 X165.559 Y165.933 E.00799
G1 X165.5 Y166.094 E.00694
G2 X165.608 Y166.318 I.306 J-.01 E.01038
G1 X165.811 Y166.342 E.0083
G1 X165.96 Y166.258 E.00693
G1 X165.991 Y166.095 E.00671
M204 S10000
G1 X166.248 Y165.608 F60000
; LINE_WIDTH: 0.41999
G1 F2405
M204 S8000
G1 X165.933 Y165.422 E.01124
G1 X165.653 Y165.404 E.00861
G1 X165.386 Y165.512 E.00886
G1 X165.185 Y165.704 E.00856
G1 X165.066 Y165.98 E.00921
G1 X165.088 Y166.283 E.00936
G1 X165.244 Y166.585 E.01043
G1 X165.417 Y166.716 E.00667
G1 X165.738 Y166.79 E.01011
G1 X166.028 Y166.736 E.00907
G1 X166.318 Y166.51 E.0113
G1 X166.434 Y166.221 E.00958
G2 X166.279 Y165.659 I-.739 J-.099 E.0184
M204 S10000
G1 X166.564 Y165.397 F60000
G1 F2405
M204 S8000
G1 X166.205 Y165.121 E.01391
G1 X165.803 Y165.019 E.01274
G1 X165.398 Y165.077 E.01259
G1 X165.074 Y165.278 E.01173
G2 X164.854 Y166.674 I.725 J.829 E.04714
G1 X165.084 Y166.953 E.01109
G1 X165.434 Y167.116 E.01187
G2 X166.32 Y166.996 I.3 J-1.111 E.02824
G1 X166.6 Y166.769 E.01106
G1 X166.759 Y166.438 E.01129
G2 X166.776 Y165.763 I-1.178 J-.367 E.02102
G1 X166.594 Y165.449 E.01114
M204 S10000
G1 X166.94 Y165.255 F60000
G1 F2405
M204 S8000
G1 X166.636 Y164.959 E.01303
G1 X166.242 Y164.732 E.01398
G1 X165.824 Y164.641 E.01312
G1 X165.388 Y164.692 E.0135
G1 X165.033 Y164.829 E.01168
G1 X164.682 Y165.108 E.01379
G1 X164.453 Y165.435 E.01226
G1 X164.315 Y165.847 E.01337
G1 X164.304 Y166.277 E.01322
G1 X164.419 Y166.693 E.01325
G1 X164.658 Y167.068 E.01368
G1 X164.965 Y167.323 E.01224
G2 X165.524 Y167.54 I1.38 J-2.718 E.01848
G1 X165.924 Y167.547 E.01228
G1 X166.341 Y167.432 E.0133
G1 X166.739 Y167.174 E.01457
G1 X167.043 Y166.776 E.0154
G1 X167.185 Y166.353 E.01369
G2 X167.133 Y165.632 I-2.154 J-.205 E.02231
G1 X166.967 Y165.308 E.01119
M204 S10000
G1 X167.255 Y165.042 F60000
G1 F2405
M204 S8000
G1 X167.008 Y164.757 E.01159
G1 X166.557 Y164.447 E.01681
G1 X166.063 Y164.297 E.01586
G1 X165.661 Y164.271 E.01239
G1 X165.151 Y164.361 E.01589
G1 X164.835 Y164.505 E.01068
G1 X164.404 Y164.847 E.01689
G1 X164.113 Y165.263 E.01562
G1 X163.939 Y165.781 E.01678
G1 X163.925 Y166.324 E.01669
G1 X164.07 Y166.848 E.01672
G1 X164.365 Y167.31 E.01684
G1 X164.755 Y167.636 E.01563
G1 X164.94 Y167.751 E.00669
M73 P73 R4
G1 X165.463 Y167.916 E.01686
G1 X165.972 Y167.925 E.01563
G1 X166.498 Y167.78 E.01676
G1 X166.983 Y167.465 E.01777
G1 X167.283 Y167.101 E.0145
G2 X167.561 Y166.419 I-2.651 J-1.477 E.02267
G2 X167.531 Y165.682 I-2.916 J-.253 E.02274
G2 X167.282 Y165.095 I-2.516 J.723 E.01963
; COOLING_NODE: 5
; WIPE_START
G1 F9547.299
G1 X167.406 Y165.338 E-.1034
G1 X167.531 Y165.682 E-.13925
G1 X167.57 Y166.06 E-.1442
G1 X167.561 Y166.419 E-.13679
G1 X167.447 Y166.758 E-.13564
G1 X167.333 Y166.997 E-.10072
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X167.656 Y159.371 Z7.4 F60000
G1 X167.898 Y153.648 Z7.4
G1 Z7
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2405
M204 S8000
G1 X162.702 Y153.648 E.17236
G1 X162.702 Y152.852 E.0264
G1 X167.898 Y152.852 E.17236
G1 X167.898 Y153.588 E.02441
; COOLING_NODE: 5
M204 S250
G1 X168.29 Y154.04 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2259
M204 S5000
G1 X162.31 Y154.04 E.18375
G1 X162.31 Y152.46 E.04855
G1 X168.29 Y152.46 E.18375
G1 X168.29 Y153.98 E.04671
M204 S10000
G1 X167.694 Y153.25 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F2405
M204 S8000
G1 X162.906 Y153.25 E.15172
; COOLING_NODE: 1
; WIPE_START
G1 F9259.259
G1 X164.906 Y153.25 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.09 Y157.723 Z7.4 F60000
G1 X182.063 Y165.658 Z7.4
G1 Z7
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2405
M204 S8000
G1 X182.075 Y165.598 E.00201
G3 X184.288 Y163.867 I2.176 J.502 E.1008
G1 X184.362 Y163.869 E.00246
G3 X182.035 Y165.828 I-.111 J2.231 E.35448
G1 X182.053 Y165.717 E.00373
; COOLING_NODE: 1
M204 S10000
G1 X181.663 Y165.587 F60000
G1 F2405
M204 S8000
G1 X181.679 Y165.507 E.00272
G3 X184.292 Y163.46 I2.573 J.593 E.11909
G1 X184.385 Y163.463 E.00307
G3 X181.631 Y165.778 I-.133 J2.637 E.41903
G1 X181.653 Y165.646 E.00443
; COOLING_NODE: 1
M204 S10000
G1 X181.262 Y165.517 F60000
G1 F2405
M204 S8000
G1 X181.282 Y165.415 E.00342
G3 X184.297 Y163.053 I2.97 J.685 E.13739
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X184.408 Y163.056 E.00367
G3 X181.227 Y165.729 I-.156 J3.044 E.48357
G1 X181.252 Y165.576 E.00514
; COOLING_NODE: 1
M204 S250
G1 X180.877 Y165.449 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2259
M204 S5000
G1 X180.9 Y165.327 E.0038
G3 X184.301 Y162.661 I3.352 J.773 E.14359
G1 X184.429 Y162.665 E.00393
G3 X180.838 Y165.681 I-.177 J3.435 E.50552
G1 X180.867 Y165.508 E.00539
; WIPE_START
G1 F9547.055
M204 S8000
G1 X180.9 Y165.327 E-.06981
G1 X180.995 Y164.988 E-.13366
G1 X181.108 Y164.7 E-.11749
G1 X181.271 Y164.379 E-.13703
G1 X181.432 Y164.127 E-.11382
G1 X181.614 Y163.89 E-.11339
G1 X181.748 Y163.746 E-.07479
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X184.069 Y165.923 Z7.4 F60000
G1 Z7
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.541301
G1 F2405
M204 S8000
G1 X183.996 Y166.049 E.00593
G1 X184.053 Y166.269 E.00922
G1 X184.218 Y166.352 E.00748
G1 X184.385 Y166.309 E.00703
G1 X184.499 Y166.152 E.0079
G1 X184.512 Y166.086 E.00271
G1 X184.421 Y165.914 E.00791
G1 X184.243 Y165.838 E.00785
G1 X184.123 Y165.897 E.00543
M204 S10000
G1 X183.623 Y165.781 F60000
; LINE_WIDTH: 0.41999
G1 F2405
M204 S8000
G1 X183.555 Y166.019 E.0076
G1 X183.612 Y166.354 E.01045
G1 X183.749 Y166.589 E.00837
G1 X183.98 Y166.736 E.0084
G1 X184.238 Y166.79 E.00809
G1 X184.533 Y166.735 E.00923
G1 X184.772 Y166.547 E.00936
G1 X184.935 Y166.248 E.01044
G1 X184.95 Y166.076 E.00532
G1 X184.872 Y165.779 E.00942
G1 X184.639 Y165.533 E.01043
G1 X184.387 Y165.414 E.00854
G1 X184.11 Y165.414 E.00851
G1 X183.835 Y165.541 E.0093
G1 X183.663 Y165.736 E.008
M204 S10000
G1 X183.286 Y165.609 F60000
G1 F2405
M204 S8000
G1 X183.175 Y166 E.01249
G1 X183.201 Y166.342 E.01052
G1 X183.387 Y166.745 E.01366
G1 X183.584 Y166.953 E.00878
G1 X183.93 Y167.115 E.01173
G2 X185.226 Y166.523 I.3 J-1.06 E.04763
G1 X185.329 Y166.175 E.01117
G2 X185.278 Y165.763 I-1.549 J-.016 E.01277
G1 X185.082 Y165.437 E.01171
G1 X184.852 Y165.222 E.00966
G1 X184.53 Y165.055 E.01116
G1 X184.1 Y165.029 E.01322
G1 X183.747 Y165.162 E.01159
G1 X183.466 Y165.373 E.01081
G1 X183.322 Y165.562 E.00727
M204 S10000
G1 X183.096 Y165.206 F60000
G1 F2405
M204 S8000
G1 X182.892 Y165.58 E.01309
G1 X182.795 Y165.982 E.01268
G1 X182.83 Y166.428 E.01374
G1 X182.995 Y166.846 E.01382
G1 X183.259 Y167.164 E.01268
G1 X183.599 Y167.406 E.01285
G1 X184.024 Y167.54 E.0137
G1 X184.424 Y167.547 E.01228
G1 X184.843 Y167.431 E.01336
G1 X185.207 Y167.199 E.01327
G1 X185.486 Y166.873 E.01319
G1 X185.663 Y166.463 E.0137
G1 X185.704 Y166.057 E.01254
G1 X185.638 Y165.645 E.01283
G1 X185.522 Y165.385 E.00875
G1 X185.244 Y165.034 E.01377
G1 X184.881 Y164.784 E.01352
G1 X184.458 Y164.662 E.01354
G1 X184.047 Y164.653 E.01262
G2 X183.391 Y164.922 I.526 J2.222 E.02189
G1 X183.139 Y165.165 E.01074
M204 S10000
G1 X182.802 Y164.966 F60000
G1 F2405
M204 S8000
G1 X182.553 Y165.413 E.01574
G2 X182.416 Y165.963 I2.441 J.899 E.01745
G1 X182.458 Y166.513 E.01696
G1 X182.662 Y167.028 E.01699
G1 X182.991 Y167.43 E.01597
G1 X183.44 Y167.752 E.01698
G1 X183.963 Y167.916 E.01685
G1 X184.472 Y167.925 E.01563
G1 X184.998 Y167.78 E.01678
G1 X185.457 Y167.486 E.01673
G1 X185.809 Y167.075 E.01665
G1 X186.028 Y166.571 E.01686
G1 X186.081 Y166.048 E.01615
G1 X185.998 Y165.526 E.01624
G1 X185.847 Y165.188 E.01139
G1 X185.504 Y164.755 E.01697
G1 X185.057 Y164.447 E.01668
G1 X184.563 Y164.297 E.01586
G1 X184.147 Y164.272 E.01281
G1 X183.656 Y164.36 E.01532
G1 X183.168 Y164.613 E.01688
G1 X182.845 Y164.924 E.01379
; COOLING_NODE: 5
; WIPE_START
G1 F9547.299
G1 X183.168 Y164.613 E-.17057
G1 X183.656 Y164.36 E-.20875
G1 X184.147 Y164.272 E-.18946
G1 X184.563 Y164.297 E-.15842
G1 X184.645 Y164.322 E-.0328
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X182.876 Y156.897 Z7.4 F60000
G1 X182.102 Y153.648 Z7.4
G1 Z7
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2405
M204 S8000
G1 X182.102 Y152.852 E.0264
G1 X187.298 Y152.852 E.17236
G1 X187.298 Y153.648 E.0264
G1 X182.162 Y153.648 E.17037
; COOLING_NODE: 5
M204 S250
G1 X181.71 Y154.04 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2259
M204 S5000
G1 X181.71 Y152.46 E.04855
G1 X187.69 Y152.46 E.18375
G1 X187.69 Y154.04 E.04855
G1 X181.77 Y154.04 E.18191
M204 S10000
G1 X182.306 Y153.25 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F2405
M204 S8000
G1 X187.094 Y153.25 E.15172
; CHANGE_LAYER
; Z_HEIGHT: 7.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.259
G1 X185.094 Y153.25 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 50/85
; update layer progress
M73 L50
M991 S0 P49 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 4
M204 S10000
G17
G3 Z7.4 I-.718 J-.982 P1  F60000
G1 X167.96 Y165.783 Z7.4
G1 Z7.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2170
M204 S8000
G3 X165.789 Y163.867 I-2.209 J.315 E.36064
G1 X165.906 Y163.872 E.00387
G3 X167.95 Y165.724 I-.156 J2.226 E.09865
; COOLING_NODE: 4
M204 S10000
G1 X168.363 Y165.729 F60000
G1 F2170
M204 S8000
G3 X165.796 Y163.46 I-2.613 J.37 E.42631
G1 X165.934 Y163.466 E.00457
G3 X168.354 Y165.669 I-.184 J2.632 E.1171
; COOLING_NODE: 4
M204 S10000
G1 X168.769 Y165.687 F60000
G1 F2170
M204 S8000
G1 X168.794 Y165.994 E.0102
G3 X165.804 Y163.053 I-3.044 J.104 E.48132
G1 X165.963 Y163.06 E.00528
G3 X168.76 Y165.628 I-.212 J3.038 E.13601
; COOLING_NODE: 4
M204 S250
G1 X169.159 Y165.653 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2170
M204 S5000
G1 X169.186 Y165.98 E.01008
G3 X165.81 Y162.661 I-3.436 J.118 E.50322
G1 X165.99 Y162.668 E.00552
G3 X169.151 Y165.594 I-.24 J3.429 E.14301
; WIPE_START
G1 F9547.055
M204 S8000
G1 X169.186 Y165.98 E-.1474
G1 X169.182 Y166.34 E-.13681
G1 X169.138 Y166.697 E-.13687
G1 X169.056 Y167.049 E-.13716
G1 X168.961 Y167.333 E-.11372
G1 X168.867 Y167.545 E-.08803
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X165.931 Y165.929 Z7.6 F60000
G1 Z7.2
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.54115
G1 F2170
M204 S8000
G1 X165.858 Y165.861 E.00403
G1 X165.661 Y165.866 E.00801
G1 X165.522 Y165.987 E.00749
G1 X165.493 Y166.12 E.00552
G1 X165.586 Y166.305 E.00843
G1 X165.752 Y166.353 E.007
G1 X165.922 Y166.28 E.00753
G1 X166.007 Y166.119 E.00742
G1 X165.954 Y165.985 E.00585
M204 S10000
G1 X166.238 Y165.617 F60000
; LINE_WIDTH: 0.41999
G1 F2170
M204 S8000
G1 X166.016 Y165.453 E.00848
G1 X165.718 Y165.405 E.00928
G2 X165.254 Y165.606 I.119 J.913 E.01574
G1 X165.076 Y165.901 E.01059
G1 X165.054 Y166.176 E.00849
G1 X165.176 Y166.478 E.01002
G1 X165.354 Y166.677 E.00819
G1 X165.552 Y166.772 E.00674
G1 X165.9 Y166.771 E.01069
G1 X166.143 Y166.674 E.00804
G1 X166.369 Y166.416 E.01053
G1 X166.447 Y166.149 E.00854
G1 X166.406 Y165.87 E.00867
G1 X166.271 Y165.667 E.00749
M204 S10000
G1 X166.621 Y165.469 F60000
G1 F2170
M204 S8000
G1 X166.292 Y165.169 E.0137
G1 X166.053 Y165.064 E.00802
G1 X165.707 Y165.024 E.0107
G1 X165.427 Y165.073 E.00875
G1 X165.041 Y165.291 E.01361
G1 X164.778 Y165.628 E.01312
G1 X164.671 Y166.025 E.01263
G1 X164.722 Y166.387 E.01125
G2 X165.084 Y166.953 I1.245 J-.399 E.02086
G1 X165.466 Y167.142 E.01309
G1 X165.784 Y167.176 E.00983
G1 X166.109 Y167.115 E.01018
G1 X166.364 Y166.985 E.00877
G1 X166.658 Y166.678 E.01307
G1 X166.817 Y166.267 E.01355
G1 X166.823 Y166.176 E.00281
G1 X166.766 Y165.746 E.01333
G1 X166.649 Y165.522 E.00776
M204 S10000
G1 X166.93 Y165.244 F60000
G1 F2170
M204 S8000
G1 X166.613 Y164.923 E.01386
G1 X166.142 Y164.694 E.01609
G1 X165.696 Y164.643 E.01379
G1 X165.308 Y164.711 E.0121
G1 X164.902 Y164.912 E.01391
G1 X164.61 Y165.211 E.01285
G1 X164.392 Y165.58 E.01318
G1 X164.293 Y165.998 E.0132
G1 X164.303 Y166.295 E.00914
G1 X164.417 Y166.691 E.01263
G1 X164.658 Y167.068 E.01376
G1 X164.997 Y167.343 E.01342
G1 X165.379 Y167.512 E.01284
G1 X165.799 Y167.557 E.01296
G1 X166.232 Y167.475 E.01356
G1 X166.584 Y167.296 E.01212
G1 X166.976 Y166.881 E.01755
G1 X167.189 Y166.341 E.01784
G2 X167.126 Y165.621 I-3.049 J-.095 E.02227
G1 X166.957 Y165.297 E.01122
M204 S10000
G1 X167.238 Y165.019 F60000
G1 F2170
M204 S8000
G1 X166.849 Y164.625 E.01702
G1 X166.413 Y164.393 E.01519
G2 X165.685 Y164.262 I-.899 J2.911 E.02278
G1 X165.189 Y164.349 E.01545
G1 X164.692 Y164.596 E.01707
G1 X164.407 Y164.843 E.0116
G1 X164.11 Y165.268 E.01593
G1 X163.954 Y165.749 E.01554
G2 X163.928 Y166.355 I2.543 J.411 E.01867
G1 X164.07 Y166.847 E.01574
G1 X164.365 Y167.31 E.01686
G1 X164.755 Y167.636 E.01563
G1 X165.104 Y167.813 E.01201
G2 X165.814 Y167.938 I.868 J-2.841 E.02219
G1 X166.356 Y167.836 E.01694
G1 X166.804 Y167.607 E.01547
G1 X167.202 Y167.228 E.01688
G1 X167.387 Y166.939 E.01055
G1 X167.562 Y166.415 E.01696
G2 X167.486 Y165.496 I-3.113 J-.206 E.02844
G1 X167.266 Y165.073 E.01468
; COOLING_NODE: 5
; WIPE_START
G1 F9547.299
G1 X167.486 Y165.496 E-.18153
G1 X167.554 Y165.855 E-.13851
G1 X167.575 Y166.228 E-.14224
G1 X167.562 Y166.415 E-.07133
G1 X167.387 Y166.939 E-.20979
G1 X167.363 Y166.976 E-.0166
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X167.669 Y159.349 Z7.6 F60000
G1 X167.898 Y153.648 Z7.6
G1 Z7.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2170
M204 S8000
G1 X162.702 Y153.648 E.17236
G1 X162.702 Y152.852 E.0264
G1 X167.898 Y152.852 E.17236
G1 X167.898 Y153.588 E.02441
; COOLING_NODE: 5
M204 S250
G1 X168.29 Y154.04 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2170
M204 S5000
G1 X162.31 Y154.04 E.18375
G1 X162.31 Y152.46 E.04855
G1 X168.29 Y152.46 E.18375
G1 X168.29 Y153.98 E.04671
M204 S10000
G1 X167.694 Y153.25 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F2170
M204 S8000
M73 P74 R4
G1 X162.906 Y153.25 E.15172
; COOLING_NODE: 1
; WIPE_START
G1 F9259.259
G1 X164.906 Y153.25 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.093 Y157.719 Z7.6 F60000
G1 X182.066 Y165.643 Z7.6
G1 Z7.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2170
M204 S8000
G1 X182.077 Y165.592 E.00172
G3 X184.289 Y163.867 I2.174 J.506 E.10064
G1 X184.406 Y163.872 E.00387
G3 X182.035 Y165.828 I-.156 J2.226 E.35271
G1 X182.056 Y165.702 E.00421
; COOLING_NODE: 1
M204 S10000
G1 X181.666 Y165.572 F60000
G1 F2170
M204 S8000
G1 X181.68 Y165.503 E.00235
G3 X184.296 Y163.46 I2.571 J.596 E.11909
G1 X184.434 Y163.466 E.00457
G3 X181.631 Y165.778 I-.184 J2.632 E.41702
G1 X181.656 Y165.631 E.00494
; COOLING_NODE: 1
M204 S10000
G1 X181.265 Y165.501 F60000
G1 F2170
M204 S8000
G1 X181.283 Y165.413 E.00299
G3 X184.304 Y163.053 I2.968 J.685 E.13754
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X184.463 Y163.06 E.00528
G3 X181.227 Y165.729 I-.212 J3.038 E.48133
G1 X181.255 Y165.56 E.00565
; COOLING_NODE: 1
M204 S250
G1 X180.879 Y165.433 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2170
M204 S5000
G1 X180.9 Y165.326 E.00335
G3 X184.31 Y162.661 I3.35 J.771 E.14386
G1 X184.49 Y162.668 E.00552
G3 X180.838 Y165.681 I-.24 J3.429 E.50323
G1 X180.869 Y165.492 E.00587
; WIPE_START
G1 F9547.055
M204 S8000
G1 X180.9 Y165.326 E-.0642
G1 X180.978 Y165.037 E-.11367
G1 X181.108 Y164.701 E-.13703
G1 X181.272 Y164.379 E-.13723
G1 X181.433 Y164.126 E-.11397
G1 X181.615 Y163.889 E-.1135
G1 X181.759 Y163.734 E-.0804
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X184.016 Y166 Z7.6 F60000
G1 Z7.2
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.539749
G1 F2170
M204 S8000
G1 X184.01 Y166.169 E.00686
G1 X184.085 Y166.301 E.00613
G1 X184.237 Y166.357 E.00655
G1 X184.392 Y166.319 E.00643
G1 X184.512 Y166.118 E.00949
G1 X184.435 Y165.931 E.0082
G1 X184.358 Y165.861 E.00421
G1 X184.155 Y165.864 E.00824
G1 X184.059 Y165.958 E.00545
M204 S10000
G1 X183.768 Y165.593 F60000
; LINE_WIDTH: 0.41999
G1 F2170
M204 S8000
G1 X183.603 Y165.844 E.00923
G1 X183.559 Y166.177 E.01033
G1 X183.67 Y166.469 E.00961
G1 X183.839 Y166.666 E.00796
G1 X184.206 Y166.798 E.01199
G1 X184.583 Y166.72 E.01182
G1 X184.844 Y166.463 E.01126
G1 X184.951 Y166.149 E.01018
G1 X184.858 Y165.755 E.01244
G1 X184.595 Y165.49 E.01145
G1 X184.311 Y165.415 E.00904
G1 X184.062 Y165.436 E.00766
G1 X183.821 Y165.565 E.00841
M204 S10000
G1 X183.459 Y165.371 F60000
G1 F2170
M204 S8000
G1 X183.246 Y165.709 E.01228
G1 X183.173 Y166.126 E.01301
G1 X183.267 Y166.538 E.01299
G1 X183.547 Y166.923 E.01462
G2 X184.181 Y167.174 I.844 J-1.208 E.02113
G1 X184.634 Y167.11 E.01406
G1 X184.94 Y166.93 E.01091
G1 X185.166 Y166.666 E.01069
G1 X185.312 Y166.272 E.01293
G1 X185.325 Y166.078 E.00596
G1 X185.23 Y165.646 E.01361
G2 X184.726 Y165.128 I-1.274 J.738 E.02243
G2 X184.126 Y165.025 I-.611 J1.763 E.01878
G1 X183.816 Y165.114 E.00989
G1 X183.508 Y165.336 E.01167
M204 S10000
G1 X183.022 Y165.336 F60000
G1 F2170
M204 S8000
G1 X182.89 Y165.575 E.00838
G1 X182.796 Y166.135 E.01747
G1 X182.919 Y166.693 E.01755
G1 X183.242 Y167.153 E.01726
G1 X183.548 Y167.379 E.0117
G1 X184.018 Y167.541 E.01525
G1 X184.419 Y167.534 E.01232
G1 X184.863 Y167.421 E.01409
G1 X185.195 Y167.212 E.01206
G1 X185.488 Y166.87 E.01384
G1 X185.655 Y166.495 E.01261
G1 X185.702 Y166.065 E.01331
G1 X185.617 Y165.629 E.01363
G1 X185.439 Y165.253 E.01279
G1 X185.113 Y164.923 E.01426
G1 X184.642 Y164.694 E.01608
G1 X184.119 Y164.645 E.01613
G1 X183.659 Y164.767 E.01461
G1 X183.281 Y165.009 E.01381
G1 X183.059 Y165.289 E.01097
M204 S10000
G1 X182.782 Y164.992 F60000
G1 F2170
M204 S8000
G1 X182.534 Y165.44 E.01572
G1 X182.415 Y165.977 E.0169
G1 X182.423 Y166.314 E.01035
G1 X182.57 Y166.848 E.01703
G1 X182.867 Y167.313 E.01694
G2 X183.378 Y167.72 I2.02 J-2.014 E.02012
G1 X183.942 Y167.913 E.01831
G1 X184.31 Y167.939 E.01133
G1 X184.86 Y167.835 E.01721
G2 X185.45 Y167.494 I-1.092 J-2.567 E.021
G1 X185.81 Y167.074 E.01699
G1 X186.018 Y166.606 E.01572
G1 X186.085 Y166.228 E.0118
G1 X186.072 Y165.845 E.01178
G1 X185.929 Y165.349 E.01589
G1 X185.741 Y165.023 E.01156
G1 X185.349 Y164.625 E.01717
G1 X184.913 Y164.393 E.01518
G1 X184.538 Y164.303 E.01185
G1 X184 Y164.277 E.01653
G1 X183.503 Y164.42 E.0159
G1 X183.037 Y164.717 E.01697
G1 X182.822 Y164.948 E.0097
; COOLING_NODE: 5
; WIPE_START
G1 F9547.299
G1 X183.037 Y164.717 E-.11992
G1 X183.503 Y164.42 E-.20982
G1 X184 Y164.277 E-.1967
G1 X184.538 Y164.303 E-.20447
G1 X184.612 Y164.321 E-.02909
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X182.865 Y156.891 Z7.6 F60000
G1 X182.102 Y153.648 Z7.6
G1 Z7.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2170
M204 S8000
G1 X182.102 Y152.852 E.0264
G1 X187.298 Y152.852 E.17236
G1 X187.298 Y153.648 E.0264
G1 X182.162 Y153.648 E.17037
; COOLING_NODE: 5
M204 S250
G1 X181.71 Y154.04 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2170
M204 S5000
G1 X181.71 Y152.46 E.04855
G1 X187.69 Y152.46 E.18375
G1 X187.69 Y154.04 E.04855
G1 X181.77 Y154.04 E.18191
M204 S10000
G1 X182.306 Y153.25 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F2170
M204 S8000
G1 X187.094 Y153.25 E.15172
; CHANGE_LAYER
; Z_HEIGHT: 7.2381
; LAYER_HEIGHT: 0.0380955
; WIPE_START
G1 F9259.259
G1 X185.094 Y153.25 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 51/85
; update layer progress
M73 L51
M991 S0 P50 ;notify layer change

; OBJECT_ID: 15
M204 S10000
G17
G3 Z7.6 I-.062 J-1.215 P1  F60000
G1 X169.095 Y154.062 Z7.6
G1 Z7.238
G1 E.8 F1800
; FEATURE: Support
; LINE_WIDTH: 0.42
; LAYER_HEIGHT: 0.27619
G1 F2407
M204 S8000
G1 X180.961 Y154.062 E.48169
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X180.961 Y152.438 E.06589
G1 X169.039 Y152.438 E.48399
G1 X169.039 Y154.062 E.06589
; CHANGE_LAYER
; Z_HEIGHT: 7.4
; LAYER_HEIGHT: 0.161905
; WIPE_START
G1 F7226.745
G1 X169.039 Y152.438 E-.61679
G1 X169.415 Y152.438 E-.14321
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 52/85
; update layer progress
M73 L52
M991 S0 P51 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 4
M204 S10000
G17
G3 Z7.638 I-1.21 J-.132 P1  F60000
G1 X167.96 Y165.789 Z7.638
G1 Z7.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
; LAYER_HEIGHT: 0.2
G1 F2407
M204 S8000
G3 X165.752 Y163.867 I-2.211 J.31 E.35949
G1 X165.866 Y163.87 E.00379
G3 X167.951 Y165.73 I-.118 J2.23 E.10013
; COOLING_NODE: 4
M204 S10000
G1 X168.364 Y165.732 F60000
G1 F2407
M204 S8000
G3 X165.754 Y163.459 I-2.614 J.367 E.42507
G1 X165.888 Y163.463 E.00443
G3 X168.355 Y165.673 I-.138 J2.636 E.11877
; COOLING_NODE: 4
M204 S10000
G1 X168.769 Y165.684 F60000
G1 F2407
M204 S8000
G1 X168.796 Y165.996 E.0104
G3 X165.757 Y163.052 I-3.045 J.103 E.47997
G1 X165.909 Y163.056 E.00506
G3 X168.76 Y165.625 I-.159 J3.043 E.13769
; COOLING_NODE: 4
M204 S250
G1 X169.159 Y165.65 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2238
M204 S5000
G1 X169.188 Y165.981 E.01021
G3 X165.759 Y162.66 I-3.437 J.119 E.50189
G1 X165.93 Y162.665 E.00526
G3 X169.152 Y165.59 I-.179 J3.435 E.14481
; WIPE_START
G1 F9547.055
M204 S8000
G1 X169.188 Y165.981 E-.14899
G1 X169.185 Y166.28 E-.11351
G1 X169.148 Y166.639 E-.13721
G1 X169.088 Y166.932 E-.11382
G1 X168.982 Y167.277 E-.13693
G1 X168.872 Y167.543 E-.10953
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X165.957 Y165.948 Z7.8 F60000
G1 Z7.4
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.54134
G1 F2407
M204 S8000
G1 X165.758 Y165.838 E.00923
G1 X165.581 Y165.913 E.00781
G1 X165.502 Y166.076 E.00736
G1 X165.518 Y166.211 E.00554
G1 X165.664 Y166.342 E.00798
G1 X165.891 Y166.321 E.00926
G1 X166.004 Y166.138 E.00871
G2 X165.975 Y166.005 I-.316 J-.001 E.00557
M204 S10000
G1 X166.332 Y165.709 F60000
; LINE_WIDTH: 0.41999
G1 F2407
M204 S8000
G1 X166.103 Y165.5 E.00951
G1 X165.785 Y165.398 E.01026
G1 X165.456 Y165.47 E.01033
G1 X165.22 Y165.663 E.00937
G1 X165.076 Y165.932 E.00938
G1 X165.077 Y166.238 E.00942
G1 X165.154 Y166.457 E.00712
G1 X165.371 Y166.673 E.00944
G1 X165.58 Y166.774 E.00712
G1 X165.888 Y166.773 E.00946
G1 X166.148 Y166.676 E.00852
G1 X166.346 Y166.458 E.00904
G1 X166.444 Y166.138 E.0103
G2 X166.35 Y165.766 I-.92 J.036 E.01186
M204 S10000
G1 X166.572 Y165.399 F60000
G1 F2407
M204 S8000
G1 X166.301 Y165.175 E.01081
G1 X165.888 Y165.033 E.0134
G1 X165.624 Y165.028 E.00813
G1 X165.295 Y165.125 E.01052
G2 X164.675 Y166.156 I.457 J.977 E.03922
G1 X164.778 Y166.564 E.01293
G1 X165.03 Y166.9 E.01288
G1 X165.391 Y167.115 E.01292
G1 X165.806 Y167.175 E.0129
G1 X166.235 Y167.062 E.01361
G1 X166.454 Y166.918 E.00806
G1 X166.672 Y166.654 E.01052
G1 X166.815 Y166.259 E.01291
G2 X166.601 Y165.452 I-1.398 J-.061 E.02607
M204 S10000
G1 X166.921 Y165.237 F60000
G1 F2407
M204 S8000
G1 X166.499 Y164.849 E.01762
G1 X166.115 Y164.687 E.01279
G1 X165.707 Y164.647 E.0126
G2 X165.134 Y164.779 I.41 J3.08 E.0181
G1 X164.775 Y165.017 E.01325
G1 X164.501 Y165.349 E.01324
G1 X164.336 Y165.747 E.01323
G1 X164.294 Y166.176 E.01323
G1 X164.438 Y166.726 E.01748
G1 X164.774 Y167.183 E.01743
G1 X165.265 Y167.471 E.01747
G1 X165.826 Y167.556 E.01745
G1 X166.263 Y167.466 E.0137
G1 X166.596 Y167.282 E.01169
G2 X166.999 Y166.851 I-2.046 J-2.314 E.01816
G1 X167.188 Y166.315 E.01746
G2 X167.164 Y165.747 I-3.302 J-.146 E.01748
G1 X166.946 Y165.291 E.01552
M204 S10000
G1 X167.323 Y165.148 F60000
G1 F2407
M204 S8000
G1 X167.124 Y164.877 E.01034
G1 X166.696 Y164.523 E.01705
G1 X166.22 Y164.322 E.0159
G1 X165.691 Y164.27 E.01634
G2 X164.973 Y164.433 I.338 J3.139 E.02267
G1 X164.52 Y164.734 E.01671
G1 X164.174 Y165.153 E.0167
G1 X163.966 Y165.655 E.01669
G1 X163.914 Y166.196 E.01669
G1 X164.024 Y166.734 E.01688
G1 X164.171 Y167.043 E.01053
G1 X164.519 Y167.466 E.01683
G1 X164.977 Y167.769 E.01687
G1 X165.301 Y167.883 E.01053
G1 X165.847 Y167.936 E.01685
G1 X166.384 Y167.826 E.01687
G1 X166.821 Y167.585 E.01532
G2 X167.326 Y167.047 I-1.95 J-2.338 E.02274
G1 X167.536 Y166.54 E.01686
G2 X167.56 Y165.927 I-1.222 J-.356 E.01904
G1 X167.534 Y165.655 E.0084
G1 X167.347 Y165.204 E.01502
; COOLING_NODE: 5
; WIPE_START
G1 F9547.299
G1 X167.534 Y165.655 E-.18575
G1 X167.56 Y165.927 E-.10394
G1 X167.586 Y166.201 E-.10447
G1 X167.536 Y166.54 E-.13038
G1 X167.326 Y167.047 E-.20849
G1 X167.281 Y167.102 E-.02698
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X167.631 Y159.478 Z7.8 F60000
G1 X167.898 Y153.648 Z7.8
G1 Z7.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2407
M204 S8000
G1 X162.702 Y153.648 E.17236
G1 X162.702 Y152.852 E.0264
G1 X167.898 Y152.852 E.17236
G1 X167.898 Y153.588 E.02441
; COOLING_NODE: 5
M204 S250
G1 X168.29 Y154.04 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2238
M204 S5000
G1 X162.31 Y154.04 E.18375
G1 X162.31 Y152.46 E.04855
G1 X168.29 Y152.46 E.18375
G1 X168.29 Y153.98 E.04671
M204 S10000
G1 X167.694 Y153.25 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
M73 P75 R4
G1 F2407
M204 S8000
G1 X162.906 Y153.25 E.15172
; COOLING_NODE: 1
; WIPE_START
G1 F9259.259
G1 X164.906 Y153.25 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.104 Y157.704 Z7.8 F60000
G1 X182.078 Y165.591 Z7.8
G1 Z7.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2407
M204 S8000
G1 X182.082 Y165.559 E.00106
G3 X184.252 Y163.867 I2.167 J.54 E.09836
G1 X184.366 Y163.87 E.00379
G3 X182.019 Y165.983 I-.118 J2.23 E.349
G1 X182.069 Y165.65 E.01117
; COOLING_NODE: 1
M204 S10000
G1 X181.663 Y165.583 F60000
G1 F2407
M204 S8000
G1 X181.688 Y165.461 E.00412
G3 X184.254 Y163.459 I2.562 J.639 E.11633
G1 X184.388 Y163.463 E.00443
G3 X181.642 Y165.683 I-.138 J2.636 E.42199
G1 X181.651 Y165.642 E.00139
; COOLING_NODE: 1
M204 S10000
G1 X181.265 Y165.501 F60000
G1 F2407
M204 S8000
G1 X181.293 Y165.363 E.00468
G3 X184.257 Y163.052 I2.957 J.737 E.1343
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X184.409 Y163.056 E.00506
G3 X181.241 Y165.621 I-.159 J3.043 E.487
G1 X181.253 Y165.56 E.00207
; COOLING_NODE: 1
M204 S250
G1 X180.881 Y165.422 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2238
M204 S5000
G1 X180.914 Y165.268 E.00485
G3 X184.259 Y162.66 I3.337 J.832 E.14043
G1 X184.43 Y162.665 E.00526
G3 X180.854 Y165.562 I-.179 J3.435 E.50911
G1 X180.869 Y165.481 E.00251
; WIPE_START
G1 F9547.055
M204 S8000
G1 X180.914 Y165.268 E-.08279
G1 X181.018 Y164.923 E-.1368
G1 X181.133 Y164.646 E-.11408
G1 X181.301 Y164.328 E-.13668
G1 X181.503 Y164.03 E-.13693
G1 X181.694 Y163.798 E-.11392
G1 X181.766 Y163.726 E-.03879
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X184.103 Y165.887 Z7.8 F60000
G1 Z7.4
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.54131
G1 F2407
M204 S8000
G1 X183.996 Y166.062 E.00832
G1 X184.044 Y166.253 E.00799
G1 X184.226 Y166.348 E.00835
G1 X184.391 Y166.321 E.00681
G1 X184.504 Y166.139 E.00868
G2 X184.457 Y165.948 I-.454 J.01 E.00804
G1 X184.26 Y165.837 E.00917
G1 X184.16 Y165.869 E.00427
M204 S10000
G1 X183.765 Y165.608 F60000
; LINE_WIDTH: 0.41999
G1 F2407
M204 S8000
G1 X183.615 Y165.838 E.00844
G1 X183.556 Y166.063 E.00714
G1 X183.616 Y166.364 E.00944
G1 X183.733 Y166.564 E.00712
G1 X183.988 Y166.735 E.00943
G1 X184.286 Y166.794 E.00935
G1 X184.612 Y166.703 E.01039
G1 X184.845 Y166.458 E.01039
G1 X184.944 Y166.144 E.01011
G1 X184.934 Y166.034 E.00341
G1 X184.831 Y165.709 E.01047
G1 X184.603 Y165.5 E.00951
G1 X184.285 Y165.398 E.01026
G1 X183.968 Y165.46 E.00993
G1 X183.814 Y165.573 E.00587
M204 S10000
G1 X183.429 Y165.423 F60000
G1 F2407
M204 S8000
G2 X183.206 Y166.36 I.857 J.7 E.03064
G1 X183.385 Y166.741 E.01293
G1 X183.695 Y167.022 E.01288
G2 X184.306 Y167.175 I.557 J-.93 E.01964
G1 X184.735 Y167.062 E.01361
G1 X184.954 Y166.918 E.00806
G1 X185.172 Y166.655 E.01052
G1 X185.315 Y166.261 E.01286
G2 X185.072 Y165.399 I-1.449 J-.056 E.02798
G1 X184.801 Y165.175 E.01081
G1 X184.399 Y165.034 E.01307
G1 X184.099 Y165.029 E.00921
G1 X183.709 Y165.163 E.01268
G1 X183.473 Y165.382 E.00987
M204 S10000
G1 X183.001 Y165.35 F60000
G1 F2407
M204 S8000
G1 X182.812 Y165.885 E.01745
G1 X182.836 Y166.452 E.01744
G1 X183.082 Y166.965 E.01747
G1 X183.499 Y167.349 E.01742
G1 X183.897 Y167.514 E.01325
G1 X184.327 Y167.556 E.01324
G1 X184.763 Y167.466 E.0137
G1 X185.096 Y167.282 E.01169
G2 X185.499 Y166.851 I-2.047 J-2.315 E.01816
G1 X185.688 Y166.317 E.01739
G2 X185.664 Y165.747 I-3.402 J-.143 E.01757
G1 X185.421 Y165.237 E.01736
G1 X184.998 Y164.849 E.01762
G1 X184.615 Y164.687 E.01278
G1 X184.179 Y164.648 E.01346
G1 X183.774 Y164.719 E.01262
G1 X183.415 Y164.911 E.01252
G2 X183.039 Y165.303 I1.713 J2.018 E.01674
M204 S10000
G1 X182.674 Y165.153 F60000
G1 F2407
M204 S8000
G1 X182.465 Y165.66 E.01684
G1 X182.414 Y165.999 E.01055
G1 X182.466 Y166.545 E.01683
G1 X182.676 Y167.052 E.01687
G1 X182.88 Y167.327 E.01053
G1 X183.302 Y167.676 E.01682
G1 X183.805 Y167.884 E.01672
G1 X184.347 Y167.936 E.01671
G1 X184.884 Y167.826 E.01687
G1 X185.321 Y167.585 E.01532
G2 X185.826 Y167.047 I-1.951 J-2.338 E.02274
G1 X186.036 Y166.539 E.01688
G2 X186.06 Y165.928 I-1.217 J-.354 E.019
G1 X186.034 Y165.655 E.00842
G1 X185.823 Y165.148 E.01687
G1 X185.624 Y164.877 E.01033
G1 X185.196 Y164.523 E.01705
G1 X184.72 Y164.322 E.0159
G1 X184.18 Y164.27 E.01667
G1 X183.651 Y164.361 E.01648
G1 X183.193 Y164.606 E.01595
G1 X183.026 Y164.728 E.00638
G1 X182.712 Y165.107 E.01512
; COOLING_NODE: 5
; WIPE_START
G1 F9547.299
G1 X183.026 Y164.728 E-.18703
G1 X183.193 Y164.606 E-.07885
G1 X183.651 Y164.361 E-.19722
G1 X184.18 Y164.27 E-.2038
G1 X184.424 Y164.293 E-.09309
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X182.797 Y156.836 Z7.8 F60000
G1 X182.102 Y153.648 Z7.8
G1 Z7.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2407
M204 S8000
G1 X182.102 Y152.852 E.0264
G1 X187.298 Y152.852 E.17236
G1 X187.298 Y153.648 E.0264
G1 X182.162 Y153.648 E.17037
; COOLING_NODE: 5
M204 S250
G1 X181.71 Y154.04 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2238
M204 S5000
G1 X181.71 Y152.46 E.04855
G1 X187.69 Y152.46 E.18375
G1 X187.69 Y154.04 E.04855
G1 X181.77 Y154.04 E.18191
M204 S10000
G1 X182.306 Y153.25 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F2407
M204 S8000
G1 X187.094 Y153.25 E.15172
; CHANGE_LAYER
; Z_HEIGHT: 7.51429
; LAYER_HEIGHT: 0.114285
; WIPE_START
G1 F9259.259
G1 X185.094 Y153.25 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 53/85
; update layer progress
M73 L53
M991 S0 P52 ;notify layer change

; OBJECT_ID: 15
M204 S10000
G17
G3 Z7.8 I-.062 J-1.215 P1  F60000
G1 X169.095 Y154.062 Z7.8
G1 Z7.514
G1 E.8 F1800
; FEATURE: Support
; LINE_WIDTH: 0.42
; LAYER_HEIGHT: 0.27619
G1 F2408
M204 S8000
G1 X180.961 Y154.062 E.48169
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X180.961 Y152.438 E.06589
G1 X169.039 Y152.438 E.48399
G1 X169.039 Y154.062 E.06589
; CHANGE_LAYER
; Z_HEIGHT: 7.6
; LAYER_HEIGHT: 0.0857143
; WIPE_START
G1 F7226.745
G1 X169.039 Y152.438 E-.61679
G1 X169.415 Y152.438 E-.14321
; WIPE_END
M73 P75 R3
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 54/85
; update layer progress
M73 L54
M991 S0 P53 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 4
M204 S10000
G17
G3 Z7.914 I-1.21 J-.132 P1  F60000
G1 X167.96 Y165.789 Z7.914
G1 Z7.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
; LAYER_HEIGHT: 0.2
G1 F2408
M204 S8000
G3 X165.76 Y163.867 I-2.21 J.309 E.3595
G1 X165.865 Y163.87 E.0035
G3 X167.95 Y165.73 I-.116 J2.229 E.10017
; COOLING_NODE: 4
M204 S10000
G1 X168.363 Y165.733 F60000
G1 F2408
M204 S8000
G3 X165.763 Y163.46 I-2.613 J.366 E.42505
G1 X165.887 Y163.463 E.00412
G3 X168.354 Y165.673 I-.137 J2.635 E.1188
; COOLING_NODE: 4
M204 S10000
G1 X168.769 Y165.688 F60000
G1 F2408
M204 S8000
G1 X168.793 Y165.938 E.00835
G3 X165.765 Y163.052 I-3.041 J.159 E.48185
G1 X165.909 Y163.056 E.00475
G3 X168.76 Y165.629 I-.157 J3.042 E.13784
; COOLING_NODE: 4
M204 S250
G1 X169.159 Y165.65 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2212
M204 S5000
G1 X169.185 Y165.919 E.00832
G3 X165.768 Y162.66 I-3.433 J.178 E.50373
G1 X165.93 Y162.665 E.00495
G3 X169.152 Y165.59 I-.178 J3.433 E.14481
; WIPE_START
G1 F9547.055
M204 S8000
G1 X169.185 Y165.919 E-.12566
G1 X169.185 Y166.28 E-.13706
G1 X169.156 Y166.579 E-.11395
G1 X169.088 Y166.932 E-.13685
G1 X168.983 Y167.276 E-.1367
G1 X168.871 Y167.543 E-.10978
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X165.922 Y165.901 Z8 F60000
G1 Z7.6
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.54138
G1 F2408
M204 S8000
G1 X165.759 Y165.839 E.00707
G1 X165.556 Y165.929 E.00905
G1 X165.502 Y166.124 E.00819
G1 X165.585 Y166.305 E.00809
G1 X165.74 Y166.351 E.00656
G1 X165.929 Y166.293 E.00805
G1 X166.005 Y166.161 E.00621
G2 X165.946 Y165.956 I-.334 J-.013 E.00879
M204 S10000
G1 X166.332 Y165.711 F60000
; LINE_WIDTH: 0.41999
G1 F2408
M204 S8000
G1 X166.113 Y165.502 E.00929
G1 X165.828 Y165.405 E.00926
G1 X165.555 Y165.441 E.00846
G1 X165.261 Y165.6 E.01026
G1 X165.098 Y165.857 E.00938
G1 X165.066 Y166.165 E.00951
G1 X165.168 Y166.49 E.01045
G1 X165.389 Y166.697 E.00931
G1 X165.677 Y166.797 E.00937
G1 X166.014 Y166.734 E.01054
G1 X166.251 Y166.589 E.00854
G1 X166.407 Y166.34 E.00903
G2 X166.434 Y166.034 I-.675 J-.213 E.0095
G1 X166.35 Y165.768 E.00858
M204 S10000
G1 X166.553 Y165.375 F60000
G1 F2408
M204 S8000
G1 X166.227 Y165.129 E.01256
G1 X165.806 Y165.02 E.01336
G1 X165.448 Y165.079 E.01113
G1 X165.152 Y165.22 E.01008
G1 X164.888 Y165.45 E.01077
G2 X164.706 Y166.36 I1.019 J.677 E.02925
G1 X164.899 Y166.76 E.01363
G1 X165.094 Y166.96 E.00858
G1 X165.49 Y167.15 E.01352
G1 X165.851 Y167.159 E.01109
G1 X166.159 Y167.083 E.00975
G1 X166.474 Y166.904 E.01115
G1 X166.729 Y166.559 E.01318
G1 X166.827 Y166.183 E.01192
G2 X166.583 Y165.427 I-1.422 J.042 E.02474
M204 S10000
G1 X166.993 Y165.336 F60000
G1 F2408
M204 S8000
G1 X166.729 Y165.024 E.01257
G1 X166.393 Y164.789 E.01259
G1 X165.946 Y164.66 E.0143
G1 X165.561 Y164.653 E.01181
G1 X165.134 Y164.779 E.0137
G1 X164.765 Y165.024 E.01359
G2 X164.381 Y165.599 I1.558 J1.456 E.02136
G1 X164.295 Y166.024 E.01332
G1 X164.336 Y166.453 E.01322
G1 X164.507 Y166.864 E.0137
G1 X164.769 Y167.173 E.01245
G1 X165.129 Y167.422 E.01344
G1 X165.512 Y167.535 E.01228
G2 X166.103 Y167.514 I.186 J-3.147 E.01819
G1 X166.514 Y167.343 E.01368
G1 X166.823 Y167.081 E.01246
G1 X167.072 Y166.721 E.01344
G1 X167.185 Y166.338 E.01227
G2 X167.164 Y165.747 I-3.136 J-.187 E.0182
G1 X167.016 Y165.391 E.01183
M204 S10000
G1 X167.324 Y165.149 F60000
G1 F2408
M204 S8000
G1 X166.984 Y164.747 E.01618
G1 X166.56 Y164.448 E.01593
G1 X166.047 Y164.294 E.01646
G2 X165.315 Y164.333 I-.286 J1.555 E.02272
G1 X164.972 Y164.434 E.01097
G1 X164.517 Y164.736 E.0168
G1 X164.266 Y165.014 E.01149
G1 X164.022 Y165.47 E.01592
G1 X163.914 Y166.004 E.01674
G1 X163.966 Y166.545 E.01668
G1 X164.176 Y167.051 E.01686
G1 X164.514 Y167.451 E.01607
G1 X164.966 Y167.764 E.0169
G1 X165.456 Y167.908 E.01568
G2 X166.195 Y167.884 I.274 J-3.031 E.02278
G1 X166.701 Y167.674 E.01684
G1 X167.101 Y167.336 E.01608
G1 X167.414 Y166.884 E.01691
G1 X167.558 Y166.394 E.01567
G2 X167.534 Y165.655 I-3.368 J-.263 E.02278
G1 X167.347 Y165.204 E.01499
; COOLING_NODE: 5
; WIPE_START
G1 F9547.299
G1 X167.534 Y165.655 E-.18542
G1 X167.568 Y166.013 E-.13663
G1 X167.558 Y166.394 E-.14506
G1 X167.414 Y166.884 E-.19382
G1 X167.266 Y167.098 E-.09906
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X167.624 Y159.474 Z8 F60000
G1 X167.898 Y153.648 Z8
G1 Z7.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2408
M204 S8000
G1 X162.702 Y153.648 E.17236
G1 X162.702 Y152.852 E.0264
G1 X167.898 Y152.852 E.17236
G1 X167.898 Y153.588 E.02441
; COOLING_NODE: 5
M204 S250
G1 X168.29 Y154.04 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2212
M204 S5000
G1 X162.31 Y154.04 E.18375
G1 X162.31 Y152.46 E.04855
G1 X168.29 Y152.46 E.18375
G1 X168.29 Y153.98 E.04671
M204 S10000
G1 X167.694 Y153.25 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F2408
M204 S8000
G1 X162.906 Y153.25 E.15172
; COOLING_NODE: 1
; WIPE_START
G1 F9259.259
M73 P76 R3
G1 X164.906 Y153.25 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.107 Y157.7 Z8 F60000
G1 X182.08 Y165.575 Z8
G1 Z7.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2408
M204 S8000
G1 X182.082 Y165.561 E.00046
G3 X184.26 Y163.867 I2.167 J.538 E.09867
G1 X184.365 Y163.87 E.0035
G3 X182.019 Y165.983 I-.116 J2.23 E.34906
G1 X182.072 Y165.635 E.0117
; COOLING_NODE: 1
M204 S10000
G1 X181.667 Y165.566 F60000
G1 F2408
M204 S8000
G1 X181.688 Y165.463 E.00349
G3 X184.263 Y163.46 I2.562 J.637 E.11664
G1 X184.387 Y163.463 E.00412
G3 X181.643 Y165.685 I-.137 J2.637 E.42197
G1 X181.655 Y165.625 E.00203
; COOLING_NODE: 1
M204 S10000
G1 X181.268 Y165.484 F60000
G1 F2408
M204 S8000
G1 X181.294 Y165.364 E.00408
G3 X184.265 Y163.052 I2.957 J.735 E.13462
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X184.409 Y163.056 E.00475
G3 X181.241 Y165.622 I-.158 J3.043 E.487
G1 X181.257 Y165.543 E.00267
; COOLING_NODE: 1
M204 S250
G1 X180.884 Y165.406 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2212
M204 S5000
G1 X180.914 Y165.269 E.00432
G3 X184.268 Y162.66 I3.338 J.831 E.14074
G1 X184.43 Y162.665 E.00495
G3 X180.855 Y165.562 I-.178 J3.435 E.50913
G1 X180.873 Y165.465 E.00303
; WIPE_START
G1 F9547.055
M204 S8000
G1 X180.914 Y165.269 E-.07622
G1 X181.017 Y164.924 E-.13688
G1 X181.158 Y164.592 E-.13684
G1 X181.333 Y164.277 E-.13715
G1 X181.504 Y164.029 E-.11433
G1 X181.693 Y163.798 E-.11345
G1 X181.777 Y163.714 E-.04514
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X184.061 Y165.926 Z8 F60000
G1 Z7.6
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.54128
G1 F2408
M204 S8000
G1 X184.002 Y166.124 E.0084
G1 X184.085 Y166.304 E.00806
G1 X184.24 Y166.351 E.00658
G1 X184.429 Y166.293 E.00803
G1 X184.513 Y166.116 E.00797
G1 X184.511 Y166.065 E.00207
G1 X184.364 Y165.863 E.01013
G2 X184.115 Y165.9 I-.095 J.22 E.01074
M204 S10000
G1 X183.7 Y165.675 F60000
; LINE_WIDTH: 0.41999
G1 F2408
M204 S8000
G1 X183.576 Y165.964 E.00967
G1 X183.576 Y166.268 E.00933
G1 X183.726 Y166.569 E.01032
G1 X183.954 Y166.737 E.00871
G1 X184.23 Y166.792 E.00864
G1 X184.538 Y166.724 E.0097
G1 X184.751 Y166.589 E.00775
G1 X184.912 Y166.326 E.00946
G1 X184.948 Y166.046 E.00869
G1 X184.859 Y165.781 E.00858
G1 X184.647 Y165.523 E.01026
G1 X184.368 Y165.411 E.00924
G1 X184.135 Y165.417 E.00714
G1 X183.87 Y165.527 E.00881
G1 X183.745 Y165.636 E.00509
M204 S10000
G1 X183.457 Y165.371 F60000
G1 F2408
M204 S8000
G1 X183.239 Y165.733 E.013
G2 X183.206 Y166.36 I1.018 J.368 E.0196
G1 X183.397 Y166.758 E.01355
G1 X183.593 Y166.959 E.00862
G1 X183.99 Y167.15 E.01356
G1 X184.351 Y167.159 E.01108
G1 X184.659 Y167.082 E.00975
G1 X184.974 Y166.904 E.01114
G1 X185.229 Y166.559 E.01317
G1 X185.33 Y166.159 E.01267
G2 X185.12 Y165.466 I-1.284 J.011 E.02255
G1 X184.796 Y165.172 E.01345
G1 X184.53 Y165.055 E.00894
G1 X184.124 Y165.028 E.01249
G1 X183.795 Y165.125 E.01053
G1 X183.506 Y165.335 E.011
M204 S10000
G1 X183.18 Y165.115 F60000
G1 F2408
M204 S8000
G1 X182.88 Y165.602 E.01756
G1 X182.795 Y166.024 E.01323
G1 X182.836 Y166.453 E.01323
G1 X183.007 Y166.864 E.0137
G1 X183.267 Y167.171 E.01236
G1 X183.629 Y167.422 E.01352
G1 X184.012 Y167.535 E.01228
G2 X184.603 Y167.514 I.186 J-3.146 E.01819
G1 X185.014 Y167.343 E.01368
G1 X185.323 Y167.081 E.01246
G1 X185.572 Y166.721 E.01343
G1 X185.689 Y166.31 E.01316
G2 X185.635 Y165.639 I-1.535 J-.213 E.02084
G1 X185.429 Y165.243 E.01373
G1 X185.121 Y164.929 E.01351
G1 X184.755 Y164.737 E.01271
G1 X184.327 Y164.641 E.01346
G2 X183.634 Y164.779 I.089 J2.258 E.0218
G1 X183.228 Y165.08 E.01552
M204 S10000
G1 X182.788 Y164.984 F60000
G1 F2408
M204 S8000
G1 X182.522 Y165.471 E.01705
G1 X182.414 Y166.004 E.0167
G1 X182.466 Y166.545 E.0167
G1 X182.676 Y167.051 E.01685
G1 X183.011 Y167.449 E.01597
G1 X183.466 Y167.764 E.01701
G1 X183.956 Y167.908 E.01568
G2 X184.695 Y167.884 I.274 J-3.032 E.02278
G1 X185.201 Y167.674 E.01684
G1 X185.601 Y167.336 E.01608
G1 X185.914 Y166.884 E.01689
G1 X186.06 Y166.375 E.01627
G1 X186.078 Y165.997 E.01163
G1 X185.99 Y165.506 E.01532
G1 X185.737 Y165.019 E.01688
G1 X185.358 Y164.632 E.01666
G1 X184.915 Y164.394 E.01545
G1 X184.505 Y164.288 E.01301
G1 X183.999 Y164.278 E.01555
G1 X183.473 Y164.433 E.01685
G1 X183.015 Y164.737 E.01687
G1 X182.828 Y164.94 E.00849
; COOLING_NODE: 5
; WIPE_START
G1 F9547.299
G1 X183.015 Y164.737 E-.10502
G1 X183.473 Y164.433 E-.20861
G1 X183.999 Y164.278 E-.20836
G1 X184.505 Y164.288 E-.19225
G1 X184.621 Y164.318 E-.04576
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X182.867 Y156.89 Z8 F60000
G1 X182.102 Y153.648 Z8
G1 Z7.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2408
M204 S8000
G1 X182.102 Y152.852 E.0264
G1 X187.298 Y152.852 E.17236
G1 X187.298 Y153.648 E.0264
G1 X182.162 Y153.648 E.17037
; COOLING_NODE: 5
M204 S250
G1 X181.71 Y154.04 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2212
M204 S5000
G1 X181.71 Y152.46 E.04855
G1 X187.69 Y152.46 E.18375
G1 X187.69 Y154.04 E.04855
G1 X181.77 Y154.04 E.18191
M204 S10000
G1 X182.306 Y153.25 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F2408
M204 S8000
G1 X187.094 Y153.25 E.15172
; CHANGE_LAYER
; Z_HEIGHT: 7.79048
; LAYER_HEIGHT: 0.190476
; WIPE_START
G1 F9259.259
G1 X185.094 Y153.25 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 55/85
; update layer progress
M73 L55
M991 S0 P54 ;notify layer change

; OBJECT_ID: 15
M204 S10000
G17
G3 Z8 I-.062 J-1.215 P1  F60000
G1 X169.095 Y154.062 Z8
G1 Z7.79
G1 E.8 F1800
; FEATURE: Support
; LINE_WIDTH: 0.42
; LAYER_HEIGHT: 0.27619
G1 F2416
M204 S8000
G1 X180.961 Y154.062 E.48169
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X180.961 Y152.438 E.06589
G1 X169.039 Y152.438 E.48399
G1 X169.039 Y154.062 E.06589
; CHANGE_LAYER
; Z_HEIGHT: 7.8
; LAYER_HEIGHT: 0.00952387
; WIPE_START
G1 F7226.745
G1 X169.039 Y152.438 E-.61679
G1 X169.415 Y152.438 E-.14321
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 56/85
; update layer progress
M73 L56
M991 S0 P55 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 4
M204 S10000
G17
G3 Z8.19 I-1.21 J-.132 P1  F60000
G1 X167.958 Y165.775 Z8.19
G1 Z7.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
; LAYER_HEIGHT: 0.2
G1 F2416
M204 S8000
G1 X167.981 Y165.983 E.00695
G3 X165.768 Y163.867 I-2.23 J.117 E.35355
G1 X165.864 Y163.87 E.00319
G3 X167.951 Y165.716 I-.113 J2.23 E.0998
; COOLING_NODE: 4
M204 S10000
G1 X168.363 Y165.732 F60000
G1 F2416
M204 S8000
G1 X168.389 Y165.962 E.00767
G3 X165.772 Y163.46 I-2.637 J.138 E.41797
G1 X165.886 Y163.463 E.00381
G3 X168.357 Y165.673 I-.134 J2.637 E.11889
; COOLING_NODE: 4
M204 S10000
G1 X168.767 Y165.69 F60000
G1 F2416
M204 S8000
G1 X168.796 Y165.941 E.00838
G3 X165.775 Y163.052 I-3.043 J.159 E.48241
G1 X165.908 Y163.056 E.00443
G3 X168.762 Y165.623 I-.156 J3.044 E.13772
G1 X168.763 Y165.63 E.00025
; COOLING_NODE: 4
M204 S250
G1 X169.157 Y165.649 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2171
M204 S5000
G1 X169.188 Y165.92 E.00839
G3 X165.778 Y162.66 I-3.435 J.18 E.50436
G1 X165.929 Y162.665 E.00464
G3 X169.15 Y165.562 I-.177 J3.435 E.14399
G1 X169.152 Y165.589 E.00085
; WIPE_START
G1 F9547.055
M204 S8000
G1 X169.188 Y165.92 E-.12659
G1 X169.185 Y166.281 E-.1369
G1 X169.156 Y166.579 E-.11382
G1 X169.088 Y166.932 E-.13684
G1 X168.982 Y167.277 E-.13684
G1 X168.873 Y167.542 E-.10902
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X165.927 Y165.923 Z8.2 F60000
G1 Z7.8
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.54119
G1 F2416
M204 S8000
G1 X165.746 Y165.838 E.00814
G1 X165.605 Y165.884 E.00602
G1 X165.496 Y166.061 E.00844
G1 X165.552 Y166.274 E.00891
G1 X165.714 Y166.35 E.00727
G1 X165.888 Y166.324 E.00713
G1 X166.012 Y166.106 E.01016
G1 X165.952 Y165.978 E.00574
M204 S10000
G1 X166.372 Y165.789 F60000
; LINE_WIDTH: 0.41999
G1 F2416
M204 S8000
G1 X166.178 Y165.563 E.00914
G1 X165.908 Y165.418 E.00943
G1 X165.594 Y165.418 E.00965
G1 X165.353 Y165.524 E.00809
G1 X165.154 Y165.742 E.00907
G1 X165.056 Y166.056 E.01012
G1 X165.116 Y166.364 E.00964
G1 X165.256 Y166.596 E.00833
G1 X165.488 Y166.739 E.00837
G1 X165.816 Y166.786 E.01017
G1 X166.073 Y166.721 E.00815
G1 X166.28 Y166.537 E.00851
G1 X166.438 Y166.235 E.01048
G1 X166.449 Y166.083 E.00467
G1 X166.387 Y165.847 E.00751
M204 S10000
G1 X166.716 Y165.623 F60000
G1 F2416
M204 S8000
G1 X166.556 Y165.387 E.00877
G1 X166.3 Y165.175 E.01021
G1 X165.899 Y165.034 E.01307
G1 X165.6 Y165.029 E.00919
G1 X165.2 Y165.169 E.01301
G1 X164.93 Y165.422 E.01138
G2 X164.706 Y166.361 I.858 J.701 E.03067
G1 X164.896 Y166.757 E.01352
G1 X165.1 Y166.964 E.00892
G1 X165.447 Y167.12 E.01168
G1 X165.761 Y167.164 E.00975
G1 X166.121 Y167.116 E.01116
G1 X166.451 Y166.921 E.01179
G1 X166.673 Y166.654 E.01067
G1 X166.818 Y166.241 E.01347
G1 X166.825 Y166.064 E.00544
G1 X166.73 Y165.682 E.0121
M204 S10000
G1 X167.059 Y165.458 F60000
G1 F2416
M204 S8000
G1 X166.839 Y165.131 E.01212
G1 X166.498 Y164.849 E.01358
G1 X166.118 Y164.687 E.01271
G1 X165.679 Y164.648 E.01354
G1 X165.278 Y164.718 E.0125
G1 X164.907 Y164.916 E.01292
G2 X164.501 Y165.349 I1.963 J2.25 E.01828
G1 X164.312 Y165.883 E.01739
G1 X164.336 Y166.453 E.01753
G1 X164.507 Y166.864 E.0137
G1 X164.778 Y167.181 E.01282
G1 X165.12 Y167.416 E.01274
G1 X165.547 Y167.543 E.01369
G1 X165.994 Y167.539 E.01373
G1 X166.397 Y167.402 E.01307
G1 X166.712 Y167.198 E.01154
G1 X166.999 Y166.851 E.01384
G1 X167.17 Y166.438 E.01371
G1 X167.202 Y166.044 E.01214
G2 X167.077 Y165.515 I-2.76 J.371 E.01673
M204 S10000
G1 X167.402 Y165.293 F60000
G1 F2416
M204 S8000
G1 X167.121 Y164.875 E.01547
G1 X166.697 Y164.523 E.01695
G1 X166.222 Y164.322 E.01583
G1 X165.676 Y164.27 E.01686
G1 X165.154 Y164.36 E.01627
G1 X164.684 Y164.612 E.01639
G2 X164.174 Y165.153 I1.919 J2.323 E.02291
G1 X163.964 Y165.661 E.01688
G1 X163.914 Y165.994 E.01035
G1 X163.966 Y166.545 E.017
G1 X164.176 Y167.051 E.01686
G1 X164.513 Y167.45 E.01603
G1 X164.967 Y167.764 E.01697
G1 X165.494 Y167.921 E.0169
G1 X166.044 Y167.915 E.0169
G1 X166.537 Y167.754 E.01594
G1 X166.973 Y167.474 E.01591
G1 X167.326 Y167.047 E.01702
G1 X167.536 Y166.54 E.01687
G1 X167.579 Y166.041 E.01539
G1 X167.568 Y165.819 E.00684
G1 X167.42 Y165.35 E.01509
; COOLING_NODE: 5
; WIPE_START
G1 F9547.299
G1 X167.568 Y165.819 E-.18663
G1 X167.579 Y166.041 E-.08457
G1 X167.536 Y166.54 E-.1903
G1 X167.326 Y167.047 E-.20863
G1 X167.175 Y167.229 E-.08987
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X167.581 Y159.608 Z8.2 F60000
G1 X167.898 Y153.648 Z8.2
G1 Z7.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2416
M204 S8000
G1 X162.702 Y153.648 E.17236
G1 X162.702 Y152.852 E.0264
G1 X167.898 Y152.852 E.17236
G1 X167.898 Y153.588 E.02441
; COOLING_NODE: 5
M204 S250
G1 X168.29 Y154.04 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2171
M204 S5000
G1 X162.31 Y154.04 E.18375
G1 X162.31 Y152.46 E.04855
G1 X168.29 Y152.46 E.18375
G1 X168.29 Y153.98 E.04671
M204 S10000
G1 X167.694 Y153.25 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F2416
M204 S8000
G1 X162.906 Y153.25 E.15172
; COOLING_NODE: 1
; WIPE_START
G1 F9259.259
G1 X164.906 Y153.25 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.087 Y157.727 Z8.2 F60000
G1 X182.059 Y165.674 Z8.2
G1 Z7.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2416
M204 S8000
M73 P77 R3
G3 X184.268 Y163.867 I2.192 J.426 E.10273
G1 X184.364 Y163.87 E.00319
G3 X182.048 Y165.733 I-.113 J2.23 E.35757
; COOLING_NODE: 1
M204 S10000
G1 X181.66 Y165.59 F60000
G1 F2416
M204 S8000
G1 X181.727 Y165.328 E.00896
G3 X184.272 Y163.46 I2.525 J.772 E.11226
G1 X184.386 Y163.463 E.00381
G3 X181.65 Y165.649 I-.134 J2.637 E.42332
; COOLING_NODE: 1
M204 S10000
G1 X181.265 Y165.491 F60000
G1 F2416
M204 S8000
G1 X181.338 Y165.209 E.00967
G3 X184.275 Y163.052 I2.915 J.891 E.12957
G1 X184.408 Y163.056 E.00443
G3 X181.255 Y165.551 I-.156 J3.044 E.48953
; COOLING_NODE: 1
M204 S250
G1 X180.889 Y165.39 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2171
M204 S5000
G1 X180.913 Y165.269 E.00379
G3 X184.429 Y162.665 I3.338 J.831 E.14571
G3 X184.61 Y169.521 I-.181 J3.435 E.31541
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G3 X180.844 Y165.621 I-.359 J-3.421 E.19183
G1 X180.877 Y165.448 E.00541
; WIPE_START
G1 F9547.055
M204 S8000
G1 X180.913 Y165.269 E-.06972
G1 X181.018 Y164.923 E-.13702
G1 X181.132 Y164.646 E-.11392
G1 X181.301 Y164.328 E-.13695
G1 X181.502 Y164.03 E-.13661
G1 X181.789 Y163.701 E-.1658
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X184.081 Y165.913 Z8.2 F60000
G1 Z7.8
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.54119
G1 F2416
M204 S8000
G1 X183.996 Y166.061 E.00696
G1 X184.056 Y166.277 E.0091
G1 X184.215 Y166.35 E.00708
G1 X184.388 Y166.324 E.00712
G1 X184.512 Y166.106 E.01017
G1 X184.427 Y165.923 E.00819
G1 X184.259 Y165.837 E.00765
G1 X184.137 Y165.889 E.00541
M204 S10000
G1 X183.654 Y165.742 F60000
; LINE_WIDTH: 0.41999
G1 F2416
M204 S8000
G1 X183.556 Y166.056 E.01011
G1 X183.616 Y166.364 E.00964
G1 X183.76 Y166.6 E.00849
G1 X183.989 Y166.739 E.00824
G1 X184.316 Y166.786 E.01014
G1 X184.551 Y166.732 E.00741
G2 X184.949 Y166.084 I-.373 J-.675 E.02445
G1 X184.872 Y165.789 E.00936
G1 X184.677 Y165.562 E.0092
G1 X184.408 Y165.418 E.00937
G1 X184.137 Y165.417 E.00834
G1 X183.87 Y165.527 E.00886
G1 X183.697 Y165.7 E.00751
M204 S10000
G1 X183.328 Y165.546 F60000
G1 F2416
M204 S8000
G1 X183.185 Y165.939 E.01286
G1 X183.206 Y166.361 E.01297
G1 X183.398 Y166.759 E.01359
G1 X183.599 Y166.964 E.00882
G1 X183.947 Y167.12 E.01171
G1 X184.261 Y167.164 E.00974
G1 X184.62 Y167.117 E.01114
G1 X184.951 Y166.921 E.01181
G1 X185.173 Y166.654 E.01067
G1 X185.318 Y166.241 E.01346
G1 X185.325 Y166.064 E.00543
G1 X185.216 Y165.623 E.01395
G1 X185.056 Y165.387 E.00877
G1 X184.8 Y165.175 E.01021
G1 X184.386 Y165.032 E.01348
G1 X184.124 Y165.028 E.00803
G1 X183.795 Y165.125 E.01054
G1 X183.53 Y165.3 E.00978
G1 X183.366 Y165.499 E.00793
M204 S10000
G1 X183.001 Y165.349 F60000
G1 F2416
M204 S8000
G1 X182.812 Y165.883 E.01738
G1 X182.836 Y166.453 E.01752
G1 X183.007 Y166.864 E.01369
G1 X183.278 Y167.181 E.01281
G1 X183.62 Y167.416 E.01277
G1 X184.047 Y167.543 E.01369
G1 X184.494 Y167.539 E.01374
G1 X184.897 Y167.402 E.01308
G1 X185.212 Y167.198 E.01153
G1 X185.499 Y166.851 E.01385
G1 X185.67 Y166.438 E.0137
G1 X185.702 Y166.045 E.01214
G2 X185.559 Y165.458 I-3.062 J.435 E.01857
G1 X185.339 Y165.131 E.01212
G1 X184.999 Y164.849 E.01358
G1 X184.617 Y164.687 E.01272
G1 X184.206 Y164.646 E.01269
G2 X183.634 Y164.779 I.419 J3.108 E.01806
G1 X183.275 Y165.017 E.01324
G1 X183.039 Y165.303 E.0114
M204 S10000
G1 X182.674 Y165.153 F60000
G1 F2416
M204 S8000
G1 X182.464 Y165.661 E.01688
G1 X182.414 Y165.994 E.01035
G1 X182.466 Y166.545 E.017
G1 X182.676 Y167.051 E.01686
G1 X183.014 Y167.451 E.01607
G1 X183.467 Y167.764 E.01694
G1 X183.994 Y167.921 E.0169
G1 X184.544 Y167.915 E.0169
G1 X185.037 Y167.754 E.01593
G1 X185.473 Y167.474 E.01592
G1 X185.826 Y167.047 E.01702
G1 X186.036 Y166.54 E.01686
G1 X186.079 Y166.041 E.0154
G1 X186.068 Y165.819 E.00682
G1 X185.902 Y165.293 E.01694
G1 X185.621 Y164.875 E.01547
G1 X185.197 Y164.523 E.01695
G1 X184.722 Y164.322 E.01584
G1 X184.189 Y164.27 E.01644
G2 X183.473 Y164.433 I.348 J3.172 E.02262
G1 X183.02 Y164.734 E.01671
G1 X182.712 Y165.107 E.01486
; COOLING_NODE: 5
; WIPE_START
G1 F9547.299
G1 X183.02 Y164.734 E-.1838
G1 X183.473 Y164.433 E-.20662
G1 X183.798 Y164.337 E-.12877
G1 X184.189 Y164.27 E-.15086
G1 X184.425 Y164.293 E-.08996
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X182.798 Y156.836 Z8.2 F60000
G1 X182.102 Y153.648 Z8.2
G1 Z7.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2416
M204 S8000
G1 X182.102 Y152.852 E.0264
G1 X187.298 Y152.852 E.17236
G1 X187.298 Y153.648 E.0264
G1 X182.162 Y153.648 E.17037
; COOLING_NODE: 5
M204 S250
G1 X181.71 Y154.04 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2171
M204 S5000
G1 X181.71 Y152.46 E.04855
G1 X187.69 Y152.46 E.18375
G1 X187.69 Y154.04 E.04855
G1 X181.77 Y154.04 E.18191
M204 S10000
G1 X182.306 Y153.25 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F2416
M204 S8000
G1 X187.094 Y153.25 E.15172
; CHANGE_LAYER
; Z_HEIGHT: 8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.259
G1 X185.094 Y153.25 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 57/85
; update layer progress
M73 L57
M991 S0 P56 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 4
M204 S10000
G17
G3 Z8.2 I-.747 J-.96 P1  F60000
G1 X169.156 Y165.651 Z8.2
G1 Z8
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2120
M204 S5000
G1 X169.182 Y165.838 E.0058
G3 X165.788 Y162.66 I-3.429 J.262 E.50713
G1 X165.929 Y162.665 E.00435
G3 X169.14 Y165.502 I-.176 J3.435 E.14214
G1 X169.15 Y165.591 E.00275
; WIPE_START
G1 F9547.055
M204 S8000
G1 X169.182 Y165.838 E-.09458
G1 X169.189 Y166.16 E-.12263
G1 X169.164 Y166.519 E-.13673
G1 X169.115 Y166.814 E-.11366
G1 X169.022 Y167.163 E-.13698
G1 X168.901 Y167.479 E-.12862
G1 X168.87 Y167.542 E-.02681
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X168.487 Y167.313 Z8.4 F60000
G1 Z8
G1 E.8 F1800
; FEATURE: Top surface
G1 F2670
M204 S2000
G1 X166.963 Y168.836 E.06619
G1 X166.83 Y168.97
G1 X166.076 Y169.19
G1 X166.21 Y169.056
G1 X168.706 Y166.561 E.10846
G1 X168.84 Y166.427
G1 X168.874 Y165.86
G1 X168.74 Y165.993
G1 X165.643 Y169.09 E.13457
G1 X165.51 Y169.224
G1 X165.03 Y169.17
G1 X165.164 Y169.036
G1 X168.687 Y165.513 E.15311
G1 X168.821 Y165.379
G1 X168.702 Y164.964
G1 X168.569 Y165.098
G1 X164.748 Y168.919 E.16603
G1 X164.614 Y169.052
G1 X164.242 Y168.892
G1 X164.376 Y168.758
G1 X168.409 Y164.725 E.17526
G1 X168.542 Y164.591
G1 X168.342 Y164.258
G1 X168.208 Y164.392
G1 X164.042 Y168.558 E.18106
G1 X163.908 Y168.692
G1 X163.612 Y168.455
G1 X163.746 Y168.321
G1 X167.971 Y164.096 E.1836
G1 X168.105 Y163.962
G1 X167.835 Y163.698
G1 X167.702 Y163.832
G1 X163.482 Y168.052 E.18338
G1 X163.348 Y168.186
G1 X163.118 Y167.883
G1 X163.251 Y167.749
G1 X167.4 Y163.601 E.18028
G1 X167.533 Y163.467
G1 X167.192 Y163.276
G1 X167.058 Y163.409
G1 X163.059 Y167.408 E.17378
G1 X162.925 Y167.542
G1 X162.771 Y167.163
G1 X162.905 Y167.029
G1 X166.678 Y163.256 E.16398
G1 X166.812 Y163.122
G1 X166.385 Y163.016
G1 X166.251 Y163.15
G1 X162.8 Y166.601 E.14998
G1 X162.666 Y166.735
G1 X162.621 Y166.246
G1 X162.755 Y166.112
G1 X165.762 Y163.106 E.13065
G1 X165.895 Y162.972
G1 X165.305 Y163.029
G1 X165.171 Y163.163
G1 X162.812 Y165.522 E.10251
; WIPE_START
G1 F9547.055
M204 S8000
G1 X164.227 Y164.108 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X168.629 Y166.928 Z8.4 F60000
G1 Z8
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.0968553
G1 F2670
M204 S8000
G1 X168.437 Y167.264 E.0017
; WIPE_START
G1 F15000
G1 X168.629 Y166.928 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X164.766 Y163.263 Z8.4 F60000
G1 Z8
G1 E.8 F1800
; LINE_WIDTH: 0.188386
G1 F2670
M204 S8000
G1 X164.573 Y163.4 E.0028
; LINE_WIDTH: 0.234009
G1 X164.38 Y163.536 E.00367
; LINE_WIDTH: 0.274853
G1 X164.264 Y163.627 E.00279
; LINE_WIDTH: 0.310891
G1 X164.147 Y163.718 E.00323
; LINE_WIDTH: 0.348481
G1 X163.944 Y163.893 E.00669
; LINE_WIDTH: 0.375635
G2 X163.557 Y164.279 I3.796 J4.197 E.01483
; LINE_WIDTH: 0.350157
G1 X163.373 Y164.491 E.00703
; LINE_WIDTH: 0.314867
G1 X163.292 Y164.595 E.00291
; LINE_WIDTH: 0.283996
G1 X163.21 Y164.698 E.00258
; LINE_WIDTH: 0.251784
G1 X163.111 Y164.837 E.00291
; LINE_WIDTH: 0.218179
G1 X163.012 Y164.976 E.00244
; LINE_WIDTH: 0.184574
G1 X162.913 Y165.115 E.00197
M204 S10000
G1 X162.795 Y165.072 F60000
; LINE_WIDTH: 0.266595
G1 F2670
M204 S8000
G1 X162.869 Y164.871 E.0039
G3 X162.618 Y166.106 I2.88 J1.23 E.33546
G1 X162.618 Y166.094 E.00021
G3 X162.634 Y165.78 I6.461 J.182 E.00573
G3 X162.758 Y165.175 I3.115 J.32 E.01128
G1 X162.775 Y165.128 E.0009
; COOLING_NODE: 5
; WIPE_START
G1 F15000
G1 X162.869 Y164.871 E-.10419
G1 X163.01 Y164.582 E-.12211
G1 X163.159 Y164.34 E-.10804
G1 X163.343 Y164.095 E-.11625
G1 X163.541 Y163.879 E-.1115
G1 X163.77 Y163.673 E-.11694
G1 X163.941 Y163.546 E-.08097
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X166.774 Y156.459 Z8.4 F60000
G1 X167.898 Y153.648 Z8.4
G1 Z8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2670
M204 S8000
G1 X162.702 Y153.648 E.17236
G1 X162.702 Y152.852 E.0264
G1 X167.898 Y152.852 E.17236
G1 X167.898 Y153.588 E.02441
; COOLING_NODE: 5
M204 S250
G1 X168.29 Y154.04 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2120
M204 S5000
G1 X162.31 Y154.04 E.18375
G1 X162.31 Y152.46 E.04855
G1 X168.29 Y152.46 E.18375
G1 X168.29 Y153.98 E.04671
M204 S10000
G1 X167.694 Y153.25 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F2670
M204 S8000
G1 X162.906 Y153.25 E.15172
; COOLING_NODE: 1
; WIPE_START
G1 F9259.259
G1 X164.906 Y153.25 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X170.985 Y157.865 Z8.4 F60000
G1 X180.886 Y165.383 Z8.4
G1 Z8
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2120
M204 S5000
G1 X180.981 Y165.038 E.01098
G3 X184.288 Y162.66 I3.272 J1.061 E.13393
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X184.429 Y162.665 E.00435
G3 X180.877 Y165.441 I-.176 J3.435 E.51296
M204 S10000
G1 X181.178 Y165.492 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.266595
G1 F2670
M204 S8000
G3 X181.118 Y166.107 I3.071 J.61 E.3473
M73 P78 R3
G1 X181.118 Y166.096 E.00021
G3 X181.133 Y165.794 I6.379 J.17 E.0055
G3 X181.167 Y165.551 I3.116 J.307 E.00448
M204 S10000
G1 X184.912 Y169.018 F60000
; FEATURE: Top surface
; LINE_WIDTH: 0.42
G1 F2670
M204 S2000
G1 X187.169 Y166.761 E.09807
G1 X187.303 Y166.628
G1 X187.376 Y166.021
G1 X187.243 Y166.155
G1 X184.305 Y169.093 E.12768
G1 X184.171 Y169.226
G1 X183.672 Y169.192
G1 X183.806 Y169.059
G1 X187.209 Y165.655 E.14789
G1 X187.343 Y165.521
G1 X187.246 Y165.085
G1 X187.113 Y165.218
G1 X183.368 Y168.963 E.16271
G1 X183.235 Y169.096
G1 X182.852 Y168.945
G1 X182.986 Y168.812
G1 X186.962 Y164.836 E.17278
G1 X187.096 Y164.702
G1 X186.907 Y164.357
G1 X186.773 Y164.491
G1 X182.641 Y168.623 E.17957
G1 X182.507 Y168.757
G1 X182.199 Y168.532
G1 X182.332 Y168.399
G1 X186.55 Y164.181 E.18327
G1 X186.683 Y164.048
G1 X186.422 Y163.776
G1 X186.288 Y163.91
G1 X182.06 Y168.138 E.18375
G1 X181.926 Y168.272
G1 X181.686 Y167.979
G1 X181.819 Y167.845
G1 X185.995 Y163.669 E.18146
G1 X186.129 Y163.536
G1 X185.802 Y163.329
G1 X185.669 Y163.463
G1 X181.612 Y167.519 E.17627
G1 X181.479 Y167.653
G1 X181.315 Y167.283
G1 X181.448 Y167.15
G1 X185.3 Y163.298 E.16738
G1 X185.434 Y163.164
G1 X185.022 Y163.042
G1 X184.889 Y163.176
G1 X181.326 Y166.739 E.15481
G1 X181.192 Y166.872
G1 X181.13 Y166.402
G1 X181.263 Y166.268
G1 X184.419 Y163.112 E.13714
G1 X184.553 Y162.979
G1 X184 Y162.998
G1 X183.866 Y163.132
G1 X181.282 Y165.716 E.11228
G1 X181.149 Y165.85
G1 X181.334 Y165.131
G1 X181.468 Y164.997
G1 X183.147 Y163.318 E.07296
M204 S10000
G1 X182.473 Y163.695 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.108522
G1 F2670
M204 S8000
G2 X181.847 Y164.321 I5.83 J6.457 E.00474
; WIPE_START
G1 F15000
G1 X182.148 Y163.994 E-.38133
G1 X182.473 Y163.695 E-.37867
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X187.045 Y167.184 Z8.4 F60000
G1 Z8
G1 E.8 F1800
; LINE_WIDTH: 0.137174
G1 F2670
M204 S8000
G1 X186.967 Y167.294 E.00104
; LINE_WIDTH: 0.171021
G1 X186.889 Y167.404 E.00141
; LINE_WIDTH: 0.204867
G1 X186.81 Y167.513 E.00178
; LINE_WIDTH: 0.237433
G1 X186.728 Y167.618 E.00211
; LINE_WIDTH: 0.268714
G1 X186.646 Y167.722 E.00245
; LINE_WIDTH: 0.304706
G1 X186.454 Y167.943 E.00623
; LINE_WIDTH: 0.329988
G3 X186.071 Y168.324 I-4.242 J-3.88 E.01266
; LINE_WIDTH: 0.302441
G1 X185.865 Y168.501 E.00573
; LINE_WIDTH: 0.26454
G1 X185.748 Y168.593 E.00269
; LINE_WIDTH: 0.228234
G1 X185.631 Y168.685 E.00225
; LINE_WIDTH: 0.186962
G1 X185.482 Y168.79 E.00213
; LINE_WIDTH: 0.140733
G1 X185.334 Y168.895 E.00145
; COOLING_NODE: 5
; WIPE_START
G1 F15000
G1 X185.482 Y168.79 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X183.819 Y161.341 Z8.4 F60000
G1 X182.102 Y153.648 Z8.4
G1 Z8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2670
M204 S8000
G1 X182.102 Y152.852 E.0264
G1 X187.298 Y152.852 E.17236
G1 X187.298 Y153.648 E.0264
G1 X182.162 Y153.648 E.17037
; COOLING_NODE: 5
M204 S250
G1 X181.71 Y154.04 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2120
M204 S5000
G1 X181.71 Y152.46 E.04855
G1 X187.69 Y152.46 E.18375
G1 X187.69 Y154.04 E.04855
G1 X181.77 Y154.04 E.18191
M204 S10000
G1 X182.306 Y153.25 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F2670
M204 S8000
G1 X187.094 Y153.25 E.15172
; CHANGE_LAYER
; Z_HEIGHT: 8.06667
; LAYER_HEIGHT: 0.0666666
; WIPE_START
G1 F9259.259
G1 X185.094 Y153.25 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 58/85
; update layer progress
M73 L58
M991 S0 P57 ;notify layer change

; OBJECT_ID: 15
M204 S10000
G17
G3 Z8.4 I-.062 J-1.215 P1  F60000
G1 X169.095 Y154.062 Z8.4
G1 Z8.067
G1 E.8 F1800
; FEATURE: Support
; LINE_WIDTH: 0.42
; LAYER_HEIGHT: 0.27619
G1 F2069
M204 S8000
G1 X180.961 Y154.062 E.48169
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X180.961 Y152.438 E.06589
G1 X169.039 Y152.438 E.48399
G1 X169.039 Y154.062 E.06589
; CHANGE_LAYER
; Z_HEIGHT: 8.2
; LAYER_HEIGHT: 0.133333
; WIPE_START
G1 F7226.745
G1 X169.039 Y152.438 E-.61679
G1 X169.415 Y152.438 E-.14321
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 59/85
; update layer progress
M73 L59
M991 S0 P58 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 7
M204 S10000
G17
G3 Z8.467 I-1.21 J-.13 P1  F60000
G1 X167.872 Y166.849 Z8.467
G1 Z8.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
; LAYER_HEIGHT: 0.2
G1 F2069
M204 S8000
G1 X167.82 Y166.979 E.00463
G3 X165.514 Y163.86 I-2.072 J-.88 E.31413
G1 X165.739 Y163.847 E.00747
G3 X167.901 Y166.76 I.01 J2.251 E.13988
G1 X167.89 Y166.792 E.00113
; COOLING_NODE: 7
M204 S250
G1 X167.5 Y166.713 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1981
M204 S5000
G1 X167.375 Y167 E.00961
G3 X165.556 Y164.25 I-1.626 J-.901 E.23431
G1 X165.742 Y164.24 E.00572
G3 X167.526 Y166.644 I.008 J1.859 E.10696
G1 X167.521 Y166.657 E.00044
; COOLING_NODE: 7
; WIPE_START
G1 F9547.055
M204 S8000
G1 X167.375 Y167 E-.14159
G1 X167.176 Y167.295 E-.13532
G1 X166.927 Y167.54 E-.13261
G1 X166.624 Y167.742 E-.13842
G1 X166.294 Y167.879 E-.13569
G1 X166.097 Y167.919 E-.07638
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X168.767 Y165.695 Z8.6 F60000
G1 Z8.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2069
M204 S8000
G1 X168.79 Y165.878 E.00611
G3 X165.793 Y163.053 I-3.038 J.22 E.48476
G1 X165.907 Y163.056 E.0038
G3 X168.752 Y165.571 I-.155 J3.042 E.13598
G1 X168.76 Y165.635 E.00214
; COOLING_NODE: 4
M204 S250
G1 X169.156 Y165.646 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2066
M204 S5000
G1 X169.181 Y165.848 E.00623
G3 X165.797 Y162.66 I-3.428 J.25 E.50683
G1 X165.929 Y162.665 E.00405
G3 X169.138 Y165.503 I-.177 J3.433 E.14212
G1 X169.148 Y165.587 E.00259
M204 S10000
G1 X168.368 Y165.708 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43179
G1 F2069
M204 S8000
G1 X168.383 Y165.817 E.00349
G3 X163.1 Y166.11 I-2.634 J.283 E.27238
G1 X163.1 Y166.09 E.00064
G3 X163.114 Y165.834 I5.495 J.161 E.00812
G3 X168.345 Y165.572 I2.636 J.266 E.23842
G1 X168.358 Y165.649 E.00248
; COOLING_NODE: 5
; WIPE_START
G1 F9257.593
G1 X168.383 Y165.817 E-.06463
G1 X168.392 Y166.285 E-.17755
G1 X168.332 Y166.696 E-.15786
G1 X168.28 Y166.887 E-.07534
G1 X168.17 Y167.178 E-.11832
G1 X167.957 Y167.561 E-.1663
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X167.925 Y159.928 Z8.6 F60000
G1 X167.898 Y153.648 Z8.6
G1 Z8.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2069
M204 S8000
G1 X162.702 Y153.648 E.17236
G1 X162.702 Y152.852 E.0264
G1 X167.898 Y152.852 E.17236
G1 X167.898 Y153.588 E.02441
; COOLING_NODE: 5
M204 S250
G1 X168.29 Y154.04 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2066
M204 S5000
G1 X162.31 Y154.04 E.18375
G1 X162.31 Y152.46 E.04855
G1 X168.29 Y152.46 E.18375
G1 X168.29 Y153.98 E.04671
M204 S10000
G1 X167.694 Y153.25 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F2069
M204 S8000
G1 X162.906 Y153.25 E.15172
; COOLING_NODE: 6
; WIPE_START
G1 F9259.259
G1 X164.906 Y153.25 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X170.929 Y157.938 Z8.6 F60000
G1 X182.065 Y166.606 Z8.6
G1 Z8.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2069
M204 S8000
M73 P79 R3
G1 X182.009 Y166.332 E.00928
G3 X184.014 Y163.86 I2.239 J-.234 E.11729
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X184.239 Y163.847 E.00747
G3 X182.096 Y166.759 I.01 J2.251 E.33001
G1 X182.077 Y166.665 E.00317
; COOLING_NODE: 6
M204 S250
G1 X182.448 Y166.529 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1981
M204 S5000
G1 X182.4 Y166.293 E.00739
G3 X184.056 Y164.25 I1.849 J-.194 E.08975
G1 X184.242 Y164.24 E.00572
G3 X182.472 Y166.644 I.008 J1.859 E.25242
G1 X182.46 Y166.588 E.00176
; COOLING_NODE: 6
; WIPE_START
G1 F9547.055
M204 S8000
G1 X182.4 Y166.293 E-.11424
G1 X182.399 Y165.914 E-.14404
G1 X182.471 Y165.556 E-.13876
G1 X182.623 Y165.199 E-.14755
G1 X182.82 Y164.911 E-.13246
G1 X182.975 Y164.757 E-.08296
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X181.279 Y165.425 Z8.6 F60000
G1 Z8.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2069
M204 S8000
G1 X181.283 Y165.415 E.00034
G3 X184.293 Y163.053 I2.969 J.684 E.13725
G1 X184.407 Y163.056 E.0038
G3 X181.227 Y165.729 I-.155 J3.043 E.48352
G1 X181.269 Y165.484 E.00823
; COOLING_NODE: 1
M204 S250
G1 X180.893 Y165.357 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2066
M204 S5000
G1 X180.901 Y165.327 E.00093
G3 X184.297 Y162.66 I3.352 J.772 E.14346
G1 X184.429 Y162.665 E.00405
G3 X180.838 Y165.681 I-.177 J3.435 E.50547
G1 X180.883 Y165.416 E.00825
M204 S10000
G1 X181.648 Y165.6 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.431806
G1 F2069
M204 S8000
G1 X181.706 Y165.369 E.00753
G3 X181.6 Y166.111 I2.544 J.741 E.50376
G1 X181.6 Y166.091 E.00063
G3 X181.607 Y165.915 I3.368 J.051 E.00557
G3 X181.639 Y165.657 I2.642 J.195 E.00824
; COOLING_NODE: 5
; WIPE_START
G1 F9257.218
G1 X181.706 Y165.369 E-.11235
G1 X181.887 Y164.904 E-.18972
G1 X182.003 Y164.696 E-.0905
G1 X182.165 Y164.465 E-.10719
G1 X182.371 Y164.231 E-.1185
G1 X182.513 Y164.1 E-.07347
G1 X182.655 Y163.99 E-.06827
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X182.248 Y156.368 Z8.6 F60000
G1 X182.102 Y153.648 Z8.6
G1 Z8.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2069
M204 S8000
G1 X182.102 Y152.852 E.0264
G1 X187.298 Y152.852 E.17236
G1 X187.298 Y153.648 E.0264
G1 X182.162 Y153.648 E.17037
; COOLING_NODE: 5
M204 S250
G1 X181.71 Y154.04 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2066
M204 S5000
G1 X181.71 Y152.46 E.04855
G1 X187.69 Y152.46 E.18375
G1 X187.69 Y154.04 E.04855
G1 X181.77 Y154.04 E.18191
M204 S10000
G1 X182.306 Y153.25 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F2069
M204 S8000
G1 X187.094 Y153.25 E.15172
; CHANGE_LAYER
; Z_HEIGHT: 8.34286
; LAYER_HEIGHT: 0.142858
; WIPE_START
G1 F9259.259
G1 X185.094 Y153.25 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 60/85
; update layer progress
M73 L60
M991 S0 P59 ;notify layer change

; OBJECT_ID: 15
M204 S10000
G17
G3 Z8.6 I-.062 J-1.215 P1  F60000
G1 X169.095 Y154.062 Z8.6
G1 Z8.343
G1 E.8 F1800
; FEATURE: Support
; LINE_WIDTH: 0.42
; LAYER_HEIGHT: 0.27619
G1 F2078
M204 S8000
G1 X180.961 Y154.062 E.48169
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X180.961 Y152.438 E.06589
G1 X169.039 Y152.438 E.48399
G1 X169.039 Y154.062 E.06589
; CHANGE_LAYER
; Z_HEIGHT: 8.4
; LAYER_HEIGHT: 0.0571423
; WIPE_START
G1 F7226.745
G1 X169.039 Y152.438 E-.61679
G1 X169.415 Y152.438 E-.14321
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 61/85
; update layer progress
M73 L61
M991 S0 P60 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 7
M204 S10000
G17
G3 Z8.743 I-1.21 J-.13 P1  F60000
G1 X167.873 Y166.831 Z8.743
G1 Z8.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
; LAYER_HEIGHT: 0.2
G1 F2078
M204 S8000
G1 X167.844 Y166.922 E.00317
G3 X165.513 Y163.86 I-2.095 J-.823 E.31613
G1 X165.728 Y163.847 E.00713
G3 X167.965 Y166.493 I.021 J2.251 E.13116
G1 X167.889 Y166.773 E.00962
; COOLING_NODE: 7
M204 S250
G1 X167.497 Y166.725 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1952
M204 S5000
G1 X167.479 Y166.779 E.00174
G3 X165.555 Y164.25 I-1.73 J-.68 E.24182
G1 X165.731 Y164.24 E.00543
G3 X167.579 Y166.424 I.018 J1.859 E.1003
G1 X167.513 Y166.667 E.00775
; COOLING_NODE: 7
; WIPE_START
G1 F9547.055
M204 S8000
G1 X167.479 Y166.779 E-.04425
G1 X167.311 Y167.113 E-.14214
G1 X167.089 Y167.392 E-.13546
G1 X166.817 Y167.624 E-.13584
G1 X166.506 Y167.8 E-.13563
G1 X166.168 Y167.913 E-.13542
G1 X166.087 Y167.923 E-.03126
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X168.766 Y165.69 Z8.8 F60000
G1 Z8.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2078
M204 S8000
G1 X168.791 Y165.887 E.00657
G3 X165.802 Y163.053 I-3.04 J.213 E.48511
G1 X165.907 Y163.056 E.00347
G3 X168.752 Y165.571 I-.156 J3.043 E.13597
G1 X168.759 Y165.63 E.00199
; COOLING_NODE: 4
M204 S250
G1 X169.155 Y165.642 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2023
M204 S5000
G1 X169.182 Y165.857 E.00666
G3 X165.807 Y162.661 I-3.431 J.242 E.5072
G1 X165.929 Y162.665 E.00374
G3 X169.138 Y165.503 I-.178 J3.435 E.1421
G1 X169.148 Y165.583 E.00247
M204 S10000
G1 X168.359 Y165.645 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.431804
G1 F2078
M204 S8000
G1 X168.398 Y166.147 E.01596
G3 X163.102 Y166.196 I-2.649 J-.047 E.25917
G1 X163.1 Y166.136 E.0019
G3 X163.107 Y165.914 I4.301 J.015 E.00705
G3 X168.349 Y165.586 I2.643 J.185 E.24148
; COOLING_NODE: 5
; WIPE_START
G1 F9257.262
G1 X168.398 Y166.147 E-.21404
G1 X168.357 Y166.574 E-.1631
G1 X168.3 Y166.819 E-.09561
G1 X168.213 Y167.077 E-.10354
G1 X168.115 Y167.296 E-.09119
G1 X167.994 Y167.507 E-.09251
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X167.941 Y159.875 Z8.8 F60000
G1 X167.898 Y153.648 Z8.8
G1 Z8.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2078
M204 S8000
G1 X162.702 Y153.648 E.17236
G1 X162.702 Y152.852 E.0264
G1 X167.898 Y152.852 E.17236
G1 X167.898 Y153.588 E.02441
; COOLING_NODE: 5
M204 S250
G1 X168.29 Y154.04 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2023
M204 S5000
G1 X162.31 Y154.04 E.18375
G1 X162.31 Y152.46 E.04855
G1 X168.29 Y152.46 E.18375
G1 X168.29 Y153.98 E.04671
M204 S10000
G1 X167.694 Y153.25 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F2078
M204 S8000
G1 X162.906 Y153.25 E.15172
; COOLING_NODE: 6
; WIPE_START
G1 F9259.259
G1 X164.906 Y153.25 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X170.925 Y157.943 Z8.8 F60000
G1 X182.062 Y166.625 Z8.8
G1 Z8.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2078
M204 S8000
G1 X182.047 Y166.571 E.00185
G3 X184.013 Y163.86 I2.201 J-.473 E.12528
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X184.228 Y163.847 E.00713
G3 X182.108 Y166.796 I.021 J2.251 E.32907
G1 X182.077 Y166.683 E.0039
; COOLING_NODE: 6
M204 S250
G1 X182.442 Y166.523 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1952
M204 S5000
G1 X182.431 Y166.488 E.00113
G3 X184.055 Y164.25 I1.818 J-.389 E.0958
M73 P80 R3
G1 X184.231 Y164.24 E.00543
G3 X182.551 Y166.856 I.018 J1.859 E.24577
G1 X182.461 Y166.58 E.00891
; COOLING_NODE: 6
; WIPE_START
G1 F9547.055
M204 S8000
G1 X182.431 Y166.488 E-.03671
G1 X182.39 Y166.133 E-.13589
G1 X182.418 Y165.777 E-.13578
G1 X182.513 Y165.434 E-.13515
G1 X182.673 Y165.113 E-.13621
G1 X182.911 Y164.808 E-.14709
G1 X182.975 Y164.749 E-.03318
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X181.273 Y165.451 Z8.8 F60000
G1 Z8.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2078
M204 S8000
G1 X181.353 Y165.159 E.01003
G3 X184.302 Y163.053 I2.898 J.941 E.12876
G1 X184.407 Y163.056 E.00347
G3 X181.261 Y165.509 I-.156 J3.043 E.49086
; COOLING_NODE: 1
M204 S250
G1 X180.895 Y165.349 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2023
M204 S5000
G1 X180.98 Y165.037 E.00993
G3 X184.307 Y162.661 I3.271 J1.062 E.13457
G1 X184.429 Y162.665 E.00374
G3 X180.882 Y165.408 I-.178 J3.435 E.51393
M204 S10000
G1 X181.653 Y165.579 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.431804
G1 F2078
M204 S8000
G1 X181.691 Y165.415 E.00535
G3 X181.602 Y166.196 I2.559 J.685 E.50245
G1 X181.6 Y166.136 E.0019
G3 X181.607 Y165.916 I4.227 J.014 E.007
G3 X181.641 Y165.638 I2.643 J.184 E.00887
; COOLING_NODE: 5
; WIPE_START
G1 F9257.26
G1 X181.691 Y165.415 E-.08696
G1 X181.776 Y165.15 E-.10564
G1 X181.883 Y164.91 E-.09995
G1 X182.002 Y164.696 E-.09314
G1 X182.156 Y164.477 E-.1016
G1 X182.336 Y164.267 E-.10525
G1 X182.512 Y164.1 E-.09205
G1 X182.669 Y163.979 E-.07541
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X182.251 Y156.358 Z8.8 F60000
G1 X182.102 Y153.648 Z8.8
G1 Z8.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2078
M204 S8000
G1 X182.102 Y152.852 E.0264
G1 X187.298 Y152.852 E.17236
G1 X187.298 Y153.648 E.0264
G1 X182.162 Y153.648 E.17037
; COOLING_NODE: 5
M204 S250
G1 X181.71 Y154.04 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2023
M204 S5000
G1 X181.71 Y152.46 E.04855
G1 X187.69 Y152.46 E.18375
G1 X187.69 Y154.04 E.04855
G1 X181.77 Y154.04 E.18191
M204 S10000
G1 X182.306 Y153.25 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F2078
M204 S8000
G1 X187.094 Y153.25 E.15172
; CHANGE_LAYER
; Z_HEIGHT: 8.6
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F9259.259
G1 X185.094 Y153.25 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 62/85
; update layer progress
M73 L62
M991 S0 P61 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 7
M204 S10000
G17
G3 Z8.8 I-.754 J-.956 P1  F60000
G1 X167.874 Y166.831 Z8.8
G1 Z8.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1838
M204 S8000
G1 X167.849 Y166.912 E.00281
G3 X165.513 Y163.86 I-2.099 J-.813 E.31645
G1 X165.717 Y163.848 E.00677
G3 X167.966 Y166.491 I.033 J2.251 E.13148
G1 X167.89 Y166.773 E.00969
; COOLING_NODE: 7
M204 S250
G1 X167.498 Y166.726 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1838
M204 S5000
G1 X167.483 Y166.769 E.00141
G3 X165.555 Y164.25 I-1.734 J-.671 E.24211
G1 X165.721 Y164.24 E.00511
G3 X167.58 Y166.423 I.028 J1.859 E.1006
G1 X167.513 Y166.668 E.00781
; COOLING_NODE: 7
; WIPE_START
G1 F9547.055
M204 S8000
G1 X167.483 Y166.769 E-.04021
G1 X167.311 Y167.112 E-.14592
G1 X167.089 Y167.391 E-.13537
G1 X166.817 Y167.624 E-.13602
G1 X166.506 Y167.8 E-.13583
G1 X166.165 Y167.913 E-.13661
G1 X166.086 Y167.923 E-.03004
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X168.767 Y165.676 Z9 F60000
G1 Z8.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1838
M204 S8000
G3 X165.753 Y163.052 I-3.018 J.424 E.49055
G1 X165.909 Y163.056 E.00517
G3 X168.758 Y165.616 I-.159 J3.043 E.1374
; COOLING_NODE: 4
M204 S250
G1 X169.158 Y165.634 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1838
M204 S5000
G1 X169.185 Y165.919 E.00879
G3 X165.755 Y162.66 I-3.435 J.181 E.50371
G1 X165.93 Y162.665 E.00536
G3 X169.15 Y165.575 I-.179 J3.435 E.14432
M204 S10000
G1 X168.369 Y165.712 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.431807
G1 F1838
M204 S8000
G1 X168.377 Y165.767 E.00177
G3 X163.101 Y166.16 I-2.627 J.343 E.2731
G1 X163.101 Y166.142 E.00059
G1 X163.101 Y166.1 E.00132
G3 X168.333 Y165.521 I2.65 J.01 E.24462
G1 X168.358 Y165.653 E.00424
; COOLING_NODE: 5
; WIPE_START
G1 F9257.199
G1 X168.377 Y165.767 E-.04405
G1 X168.4 Y166.058 E-.11103
G1 X168.392 Y166.302 E-.09256
G1 X168.358 Y166.57 E-.10285
G1 X168.296 Y166.836 E-.10359
G1 X168.218 Y167.066 E-.09218
G1 X168.107 Y167.312 E-.10267
G1 X167.97 Y167.548 E-.10361
G1 X167.958 Y167.563 E-.00745
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X167.925 Y159.931 Z9 F60000
G1 X167.898 Y153.648 Z9
G1 Z8.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1838
M204 S8000
G1 X162.702 Y153.648 E.17236
G1 X162.702 Y152.852 E.0264
G1 X167.898 Y152.852 E.17236
G1 X167.898 Y153.588 E.02441
; COOLING_NODE: 5
M204 S250
G1 X168.29 Y154.04 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1838
M204 S5000
G1 X162.31 Y154.04 E.18375
G1 X162.31 Y152.46 E.04855
G1 X168.29 Y152.46 E.18375
G1 X168.29 Y153.98 E.04671
M204 S10000
G1 X167.694 Y153.25 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1838
M204 S8000
G1 X162.906 Y153.25 E.15172
; COOLING_NODE: 6
; WIPE_START
G1 F9259.259
G1 X164.906 Y153.25 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X170.921 Y157.948 Z9 F60000
G1 X182.071 Y166.655 Z9
G1 Z8.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1838
M204 S8000
G1 X182.056 Y166.606 E.00169
G3 X184.013 Y163.86 I2.193 J-.507 E.12641
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X184.217 Y163.848 E.00677
G3 X182.194 Y167.018 I.033 J2.251 E.3216
G1 X182.09 Y166.711 E.01073
; COOLING_NODE: 6
M204 S250
G1 X182.441 Y166.53 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1838
M204 S5000
G1 X182.438 Y166.518 E.0004
G3 X184.055 Y164.25 I1.811 J-.419 E.09672
G1 X184.221 Y164.24 E.00511
G3 X182.552 Y166.857 I.028 J1.859 E.24606
G1 X182.461 Y166.587 E.00875
; COOLING_NODE: 6
; WIPE_START
G1 F9547.055
M204 S8000
G1 X182.438 Y166.518 E-.02776
G1 X182.39 Y166.134 E-.14707
G1 X182.418 Y165.777 E-.13604
G1 X182.515 Y165.43 E-.13685
G1 X182.689 Y165.088 E-.14579
G1 X182.911 Y164.809 E-.13554
G1 X182.973 Y164.756 E-.03094
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X181.284 Y165.406 Z9 F60000
G1 Z8.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1838
M204 S8000
G1 X181.293 Y165.362 E.00148
G3 X184.253 Y163.052 I2.957 J.737 E.1342
G1 X184.409 Y163.056 E.00517
G3 X181.24 Y165.621 I-.159 J3.043 E.48698
G1 X181.272 Y165.465 E.00529
; COOLING_NODE: 1
M204 S250
G1 X180.9 Y165.328 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1838
M204 S5000
M73 P81 R3
G1 X180.914 Y165.268 E.00189
G3 X184.255 Y162.66 I3.337 J.832 E.14033
G1 X184.43 Y162.665 E.00536
G3 X180.854 Y165.562 I-.179 J3.435 E.50911
G1 X180.888 Y165.387 E.00548
M204 S10000
G1 X181.657 Y165.567 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.431805
G1 F1838
M204 S8000
G1 X181.708 Y165.365 E.00662
G3 X181.601 Y166.16 I2.542 J.746 E.50202
G1 X181.601 Y166.142 E.00059
G1 X181.601 Y166.1 E.00133
G3 X181.644 Y165.63 I2.65 J.01 E.01498
G1 X181.645 Y165.626 E.00011
; COOLING_NODE: 5
; WIPE_START
G1 F9257.232
G1 X181.708 Y165.365 E-.1022
G1 X181.782 Y165.134 E-.09204
G1 X181.893 Y164.888 E-.10278
G1 X182.03 Y164.653 E-.10308
G1 X182.17 Y164.458 E-.09127
G1 X182.347 Y164.256 E-.10208
G1 X182.522 Y164.091 E-.09149
G1 X182.678 Y163.97 E-.07506
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X182.253 Y156.35 Z9 F60000
G1 X182.102 Y153.648 Z9
G1 Z8.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1838
M204 S8000
G1 X182.102 Y152.852 E.0264
G1 X187.298 Y152.852 E.17236
G1 X187.298 Y153.648 E.0264
G1 X182.162 Y153.648 E.17037
; COOLING_NODE: 5
M204 S250
G1 X181.71 Y154.04 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1838
M204 S5000
G1 X181.71 Y152.46 E.04855
G1 X187.69 Y152.46 E.18375
G1 X187.69 Y154.04 E.04855
G1 X181.77 Y154.04 E.18191
M204 S10000
G1 X182.306 Y153.25 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1838
M204 S8000
G1 X187.094 Y153.25 E.15172
; CHANGE_LAYER
; Z_HEIGHT: 8.61905
; LAYER_HEIGHT: 0.0190468
; WIPE_START
G1 F9259.259
G1 X185.094 Y153.25 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 63/85
; update layer progress
M73 L63
M991 S0 P62 ;notify layer change

; OBJECT_ID: 15
M204 S10000
G17
G3 Z9 I-.062 J-1.215 P1  F60000
G1 X169.095 Y154.062 Z9
G1 Z8.619
G1 E.8 F1800
; FEATURE: Support
; LINE_WIDTH: 0.42
; LAYER_HEIGHT: 0.27619
G1 F2072
M204 S8000
G1 X180.961 Y154.062 E.48169
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X180.961 Y152.438 E.06589
G1 X169.039 Y152.438 E.48399
G1 X169.039 Y154.062 E.06589
; CHANGE_LAYER
; Z_HEIGHT: 8.8
; LAYER_HEIGHT: 0.180953
; WIPE_START
G1 F7226.745
G1 X169.039 Y152.438 E-.61679
G1 X169.415 Y152.438 E-.14321
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 64/85
; update layer progress
M73 L64
M991 S0 P63 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 7
M204 S10000
G17
G3 Z9.019 I-1.21 J-.13 P1  F60000
G1 X167.859 Y166.867 Z9.019
G1 Z8.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
; LAYER_HEIGHT: 0.2
G1 F2072
M204 S8000
G1 X167.735 Y167.157 E.01046
G3 X165.514 Y163.86 I-1.987 J-1.059 E.30758
G1 X165.739 Y163.847 E.00748
G3 X167.901 Y166.758 I.009 J2.251 E.13979
G1 X167.881 Y166.811 E.00191
; COOLING_NODE: 7
M204 S250
G1 X167.498 Y166.718 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1937
M204 S5000
G1 X167.39 Y166.972 E.0085
G3 X165.556 Y164.25 I-1.641 J-.873 E.23528
G1 X165.742 Y164.24 E.00573
G3 X167.526 Y166.643 I.007 J1.859 E.10693
G1 X167.52 Y166.662 E.0006
; COOLING_NODE: 7
; WIPE_START
G1 F9547.055
M204 S8000
G1 X167.39 Y166.972 E-.12792
G1 X167.195 Y167.272 E-.13572
G1 X166.945 Y167.526 E-.13553
G1 X166.625 Y167.742 E-.14684
G1 X166.294 Y167.879 E-.13586
G1 X166.093 Y167.92 E-.07814
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X168.768 Y165.677 Z9.2 F60000
G1 Z8.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2072
M204 S8000
G3 X165.762 Y163.052 I-3.017 J.421 E.4906
G1 X165.909 Y163.056 E.00486
G3 X168.759 Y165.618 I-.158 J3.042 E.13749
; COOLING_NODE: 4
M204 S250
G1 X169.157 Y165.631 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1965
M204 S5000
G1 X169.185 Y165.92 E.00893
G3 X165.765 Y162.66 I-3.434 J.178 E.50375
G1 X165.93 Y162.665 E.00506
G3 X169.149 Y165.571 I-.178 J3.434 E.14423
M204 S10000
G1 X168.365 Y165.686 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.431788
G1 F2072
M204 S8000
G1 X168.385 Y165.833 E.00471
G3 X163.1 Y166.114 I-2.636 J.266 E.27174
G1 X163.1 Y166.1 E.00043
G3 X163.11 Y165.874 I8.433 J.254 E.00718
G3 X168.35 Y165.594 I2.64 J.226 E.2405
G1 X168.355 Y165.626 E.00103
; COOLING_NODE: 5
; WIPE_START
G1 F9257.643
G1 X168.385 Y165.833 E-.07929
G1 X168.395 Y166.243 E-.15578
G1 X168.349 Y166.616 E-.14282
G1 X168.285 Y166.875 E-.10157
G1 X168.191 Y167.132 E-.10388
G1 X168.09 Y167.344 E-.08913
G1 X167.972 Y167.541 E-.08753
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X167.931 Y159.909 Z9.2 F60000
G1 X167.898 Y153.648 Z9.2
G1 Z8.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
M73 P81 R2
G1 F2072
M204 S8000
G1 X162.702 Y153.648 E.17236
G1 X162.702 Y152.852 E.0264
G1 X167.898 Y152.852 E.17236
G1 X167.898 Y153.588 E.02441
; COOLING_NODE: 5
M204 S250
G1 X168.29 Y154.04 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1965
M204 S5000
G1 X162.31 Y154.04 E.18375
G1 X162.31 Y152.46 E.04855
G1 X168.29 Y152.46 E.18375
G1 X168.29 Y153.98 E.04671
M204 S10000
G1 X167.694 Y153.25 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F2072
M204 S8000
G1 X162.906 Y153.25 E.15172
; COOLING_NODE: 6
; WIPE_START
G1 F9259.259
G1 X164.906 Y153.25 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X170.926 Y157.941 Z9.2 F60000
G1 X182.068 Y166.621 Z9.2
G1 Z8.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2072
M204 S8000
G1 X182.009 Y166.333 E.00972
G3 X184.014 Y163.86 I2.239 J-.235 E.11732
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X184.239 Y163.847 E.00748
G3 X182.096 Y166.759 I.009 J2.251 E.32997
G1 X182.08 Y166.679 E.00271
; COOLING_NODE: 6
M204 S250
G1 X182.451 Y166.543 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1937
M204 S5000
G1 X182.4 Y166.294 E.00781
G3 X184.056 Y164.25 I1.849 J-.195 E.08976
G1 X184.242 Y164.24 E.00573
G3 X182.472 Y166.644 I.007 J1.859 E.25239
G1 X182.463 Y166.602 E.00134
; COOLING_NODE: 6
; WIPE_START
G1 F9547.055
M204 S8000
G1 X182.4 Y166.294 E-.11942
G1 X182.397 Y165.936 E-.1357
G1 X182.471 Y165.556 E-.14735
G1 X182.608 Y165.226 E-.13549
G1 X182.805 Y164.928 E-.13594
G1 X182.964 Y164.767 E-.0861
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X181.288 Y165.387 Z9.2 F60000
G1 Z8.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2072
M204 S8000
G1 X181.295 Y165.363 E.00083
G3 X184.262 Y163.052 I2.956 J.736 E.13446
G1 X184.409 Y163.056 E.00486
G3 X181.234 Y165.676 I-.158 J3.042 E.48504
G1 X181.277 Y165.446 E.00775
; COOLING_NODE: 1
M204 S250
G1 X180.904 Y165.312 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1965
M204 S5000
G1 X180.915 Y165.268 E.0014
G3 X184.265 Y162.66 I3.337 J.83 E.14059
G1 X184.43 Y162.665 E.00506
G3 X180.847 Y165.621 I-.178 J3.434 E.5071
G1 X180.893 Y165.371 E.00781
M204 S10000
M73 P82 R2
G1 X181.656 Y165.562 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.431787
G1 F2072
M204 S8000
G1 X181.715 Y165.325 E.00775
G3 X181.6 Y166.114 I2.534 J.773 E.50214
G1 X181.6 Y166.1 E.00043
G3 X181.609 Y165.873 I9.035 J.274 E.00718
G3 X181.643 Y165.62 I2.64 J.224 E.00809
; COOLING_NODE: 5
; WIPE_START
G1 F9257.678
G1 X181.715 Y165.325 E-.11569
G1 X181.91 Y164.856 E-.19275
G1 X182.053 Y164.618 E-.10565
G1 X182.2 Y164.421 E-.09313
G1 X182.376 Y164.226 E-.09991
G1 X182.558 Y164.061 E-.09345
G1 X182.683 Y163.967 E-.05943
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X182.254 Y156.346 Z9.2 F60000
G1 X182.102 Y153.648 Z9.2
G1 Z8.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2072
M204 S8000
G1 X182.102 Y152.852 E.0264
G1 X187.298 Y152.852 E.17236
G1 X187.298 Y153.648 E.0264
G1 X182.162 Y153.648 E.17037
; COOLING_NODE: 5
M204 S250
G1 X181.71 Y154.04 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1965
M204 S5000
G1 X181.71 Y152.46 E.04855
G1 X187.69 Y152.46 E.18375
G1 X187.69 Y154.04 E.04855
G1 X181.77 Y154.04 E.18191
M204 S10000
G1 X182.306 Y153.25 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F2072
M204 S8000
G1 X187.094 Y153.25 E.15172
; CHANGE_LAYER
; Z_HEIGHT: 8.89524
; LAYER_HEIGHT: 0.0952377
; WIPE_START
G1 F9259.259
G1 X185.094 Y153.25 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 65/85
; update layer progress
M73 L65
M991 S0 P64 ;notify layer change

; OBJECT_ID: 15
M204 S10000
G17
G3 Z9.2 I-.062 J-1.215 P1  F60000
G1 X169.095 Y154.062 Z9.2
G1 Z8.895
G1 E.8 F1800
; FEATURE: Support
; LINE_WIDTH: 0.42
; LAYER_HEIGHT: 0.27619
G1 F2071
M204 S8000
G1 X180.961 Y154.062 E.48169
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X180.961 Y152.438 E.06589
G1 X169.039 Y152.438 E.48399
G1 X169.039 Y154.062 E.06589
; CHANGE_LAYER
; Z_HEIGHT: 9
; LAYER_HEIGHT: 0.104762
; WIPE_START
G1 F7226.745
G1 X169.039 Y152.438 E-.61679
G1 X169.415 Y152.438 E-.14321
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 66/85
; update layer progress
M73 L66
M991 S0 P65 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 7
M204 S10000
G17
G3 Z9.295 I-1.21 J-.13 P1  F60000
G1 X167.874 Y166.833 Z9.295
G1 Z9
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
; LAYER_HEIGHT: 0.2
G1 F2071
M204 S8000
G1 X167.85 Y166.907 E.00257
G3 X165.513 Y163.86 I-2.101 J-.808 E.31665
G1 X165.728 Y163.847 E.00716
G3 X167.966 Y166.491 I.021 J2.251 E.13107
G1 X167.889 Y166.775 E.00975
; COOLING_NODE: 7
M204 S250
G1 X167.497 Y166.728 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1932
M204 S5000
G1 X167.484 Y166.766 E.00121
G3 X165.555 Y164.25 I-1.735 J-.667 E.24223
G1 X165.732 Y164.24 E.00545
G3 X167.58 Y166.423 I.017 J1.859 E.10027
G1 X167.513 Y166.671 E.00788
; COOLING_NODE: 7
; WIPE_START
G1 F9547.055
M204 S8000
G1 X167.484 Y166.766 E-.03775
G1 X167.311 Y167.113 E-.14744
G1 X167.088 Y167.392 E-.13582
G1 X166.816 Y167.625 E-.13599
G1 X166.494 Y167.805 E-.14038
G1 X166.138 Y167.919 E-.14201
G1 X166.084 Y167.926 E-.02061
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X168.765 Y165.67 Z9.4 F60000
G1 Z9
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2071
M204 S8000
G1 X168.794 Y165.941 E.00905
G3 X165.771 Y163.052 I-3.042 J.157 E.48194
G1 X165.908 Y163.056 E.00455
G3 X168.758 Y165.61 I-.156 J3.042 E.13724
; COOLING_NODE: 4
M204 S250
G1 X169.155 Y165.629 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1950
M204 S5000
G1 X169.186 Y165.92 E.00902
G3 X165.775 Y162.66 I-3.433 J.177 E.50387
G1 X165.93 Y162.665 E.00476
G3 X169.148 Y165.562 I-.177 J3.433 E.14395
G1 X169.149 Y165.569 E.00021
M204 S10000
G1 X168.366 Y165.696 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.431781
G1 F2071
M204 S8000
G1 X168.381 Y165.791 E.00305
G3 X163.101 Y166.159 I-2.631 J.316 E.2722
G1 X163.1 Y166.139 E.00061
G3 X163.104 Y165.962 I3.437 J-.012 E.00562
G3 X168.341 Y165.555 I2.646 J.146 E.24152
G1 X168.356 Y165.637 E.00263
; COOLING_NODE: 5
; WIPE_START
G1 F9257.825
G1 X168.381 Y165.791 E-.05938
G1 X168.399 Y166.1 E-.1176
G1 X168.358 Y166.569 E-.17904
G1 X168.302 Y166.815 E-.09556
G1 X168.22 Y167.06 E-.09826
G1 X168.116 Y167.294 E-.09745
G1 X167.98 Y167.532 E-.10406
G1 X167.966 Y167.55 E-.00865
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X167.929 Y159.918 Z9.4 F60000
G1 X167.898 Y153.648 Z9.4
G1 Z9
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2071
M204 S8000
G1 X162.702 Y153.648 E.17236
G1 X162.702 Y152.852 E.0264
G1 X167.898 Y152.852 E.17236
G1 X167.898 Y153.588 E.02441
; COOLING_NODE: 5
M204 S250
G1 X168.29 Y154.04 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1950
M204 S5000
G1 X162.31 Y154.04 E.18375
G1 X162.31 Y152.46 E.04855
G1 X168.29 Y152.46 E.18375
G1 X168.29 Y153.98 E.04671
M204 S10000
G1 X167.694 Y153.25 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F2071
M204 S8000
G1 X162.906 Y153.25 E.15172
; COOLING_NODE: 6
; WIPE_START
G1 F9259.259
G1 X164.906 Y153.25 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X170.92 Y157.948 Z9.4 F60000
G1 X182.075 Y166.662 Z9.4
G1 Z9
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2071
M204 S8000
G1 X182.052 Y166.59 E.00251
G3 X184.013 Y163.86 I2.197 J-.491 E.12588
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X184.228 Y163.847 E.00716
G3 X182.192 Y167.015 I.021 J2.251 E.32129
G1 X182.094 Y166.719 E.01037
; COOLING_NODE: 6
M204 S250
G1 X182.446 Y166.539 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1932
M204 S5000
G1 X182.435 Y166.504 E.00113
G3 X184.055 Y164.25 I1.814 J-.406 E.0963
G1 X184.232 Y164.24 E.00545
G3 X182.551 Y166.856 I.017 J1.859 E.24575
G1 X182.465 Y166.596 E.00841
; COOLING_NODE: 6
; WIPE_START
G1 F9547.055
M204 S8000
G1 X182.435 Y166.504 E-.03671
G1 X182.39 Y166.133 E-.14206
G1 X182.418 Y165.777 E-.13592
G1 X182.513 Y165.434 E-.13529
G1 X182.673 Y165.114 E-.13574
G1 X182.912 Y164.808 E-.14766
G1 X182.963 Y164.76 E-.02661
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X181.29 Y165.375 Z9.4 F60000
G1 Z9
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2071
M204 S8000
G1 X181.295 Y165.364 E.00042
G3 X184.271 Y163.052 I2.957 J.736 E.13477
G1 X184.408 Y163.056 E.00455
G3 X181.242 Y165.623 I-.157 J3.043 E.48702
G1 X181.279 Y165.434 E.00636
; COOLING_NODE: 1
M204 S250
G1 X180.906 Y165.297 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1950
M204 S5000
G1 X180.915 Y165.268 E.00093
G3 X184.275 Y162.66 I3.337 J.831 E.14088
G1 X184.43 Y162.665 E.00476
G3 X180.856 Y165.562 I-.177 J3.435 E.50915
G1 X180.895 Y165.356 E.00645
M204 S10000
G1 X181.668 Y165.515 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.431783
G1 F2071
M204 S8000
M73 P83 R2
G1 X181.681 Y165.461 E.00176
G3 X181.601 Y166.159 I2.569 J.647 E.50521
G1 X181.6 Y166.139 E.00061
G3 X181.604 Y165.962 I3.432 J-.012 E.00562
G3 X181.635 Y165.684 I2.646 J.146 E.00886
G1 X181.656 Y165.574 E.00357
; COOLING_NODE: 5
; WIPE_START
G1 F9257.76
G1 X181.681 Y165.461 E-.04393
G1 X181.812 Y165.065 E-.15842
G1 X182.009 Y164.686 E-.16226
G1 X182.168 Y164.46 E-.10492
G1 X182.377 Y164.226 E-.11909
G1 X182.554 Y164.064 E-.09166
G1 X182.722 Y163.938 E-.07972
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X182.263 Y156.319 Z9.4 F60000
G1 X182.102 Y153.648 Z9.4
G1 Z9
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2071
M204 S8000
G1 X182.102 Y152.852 E.0264
G1 X187.298 Y152.852 E.17236
G1 X187.298 Y153.648 E.0264
G1 X182.162 Y153.648 E.17037
; COOLING_NODE: 5
M204 S250
G1 X181.71 Y154.04 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1950
M204 S5000
G1 X181.71 Y152.46 E.04855
G1 X187.69 Y152.46 E.18375
G1 X187.69 Y154.04 E.04855
G1 X181.77 Y154.04 E.18191
M204 S10000
G1 X182.306 Y153.25 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F2071
M204 S8000
G1 X187.094 Y153.25 E.15172
; CHANGE_LAYER
; Z_HEIGHT: 9.17143
; LAYER_HEIGHT: 0.171429
; WIPE_START
G1 F9259.259
G1 X185.094 Y153.25 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 67/85
; update layer progress
M73 L67
M991 S0 P66 ;notify layer change

; OBJECT_ID: 15
M204 S10000
G17
G3 Z9.4 I-.228 J-1.195 P1  F60000
G1 X180.962 Y154.038 Z9.4
G1 Z9.171
G1 E.8 F1800
; FEATURE: Support transition
; LINE_WIDTH: 0.42
; LAYER_HEIGHT: 0.27619
G1 F2145
M204 S8000
G1 X179.698 Y154.062 E.0513
G1 X180.962 Y152.798 E.07254
G1 X180.962 Y152.438 E.0146
G1 X180.081 Y152.438 E.03575
G1 X178.458 Y154.062 E.09319
G1 X177.217 Y154.062 E.05035
G1 X178.841 Y152.438 E.09319
G1 X177.6 Y152.438 E.05035
G1 X175.977 Y154.062 E.09319
G1 X174.737 Y154.062 E.05035
G1 X176.36 Y152.438 E.09319
G1 X175.119 Y152.438 E.05035
G1 X173.496 Y154.062 E.09319
G1 X172.256 Y154.062 E.05035
G1 X173.879 Y152.438 E.09319
G1 X172.639 Y152.438 E.05035
G1 X171.015 Y154.062 E.09319
G1 X169.775 Y154.062 E.05035
G1 X171.398 Y152.438 E.09319
G1 X170.158 Y152.438 E.05035
G1 X169.038 Y153.558 E.06427
G1 X169.038 Y152.438 E.04545
G1 X169.969 Y152.438 E.03779
; WIPE_START
G1 F3000
G1 X169.038 Y152.438 E-.3538
G1 X169.038 Y153.507 E-.4062
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z9.571 I1.217 J0 P1  F60000
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
            

            
                M9711 M0 E1 X256 Y153 Z9.17143 S11 C10 O0 T3000
            

            
        M623

        M622 J1
            

            
                M9711 M0 E1 U256 V153 Z9.17143 S11 C10 O0 T3000
            

            
        M623
    
    
    
        M993 A3 B3 C3
    
M623
; SKIPPABLE_END

G1 Z9.571
; CHANGE_LAYER
; Z_HEIGHT: 9.2
; LAYER_HEIGHT: 0.0285711
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 68/85
; update layer progress
M73 L68
M991 S0 P67 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 7
G1 X167.873 Y166.835
G1 Z9.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
; LAYER_HEIGHT: 0.2
G1 F2145
M204 S8000
G1 X167.85 Y166.909 E.00258
G3 X165.512 Y163.86 I-2.101 J-.81 E.31661
G1 X165.717 Y163.848 E.0068
G3 X167.967 Y166.49 I.032 J2.251 E.13146
G1 X167.889 Y166.777 E.00984
; COOLING_NODE: 7
M204 S250
G1 X167.497 Y166.73 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1929
M204 S5000
G1 X167.485 Y166.767 E.0012
G3 X165.555 Y164.25 I-1.735 J-.668 E.24225
G1 X165.722 Y164.24 E.00513
G3 X167.581 Y166.422 I.028 J1.859 E.10058
G1 X167.513 Y166.672 E.00795
; COOLING_NODE: 7
; WIPE_START
G1 F9547.055
M204 S8000
G1 X167.485 Y166.767 E-.03757
G1 X167.311 Y167.112 E-.14688
G1 X167.089 Y167.392 E-.1357
G1 X166.817 Y167.624 E-.13565
G1 X166.503 Y167.801 E-.1372
G1 X166.137 Y167.92 E-.14629
G1 X166.082 Y167.926 E-.02071
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X168.766 Y165.679 Z9.6 F60000
G1 Z9.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2145
M204 S8000
G1 X168.788 Y165.831 E.0051
G3 X165.781 Y163.053 I-3.035 J.269 E.48622
G1 X165.908 Y163.056 E.00422
G3 X168.753 Y165.57 I-.156 J3.043 E.13598
G1 X168.759 Y165.619 E.00163
; COOLING_NODE: 4
M204 S250
G1 X169.154 Y165.628 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1941
M204 S5000
G1 X169.179 Y165.799 E.00532
G3 X165.784 Y162.66 I-3.426 J.301 E.50826
G1 X165.929 Y162.665 E.00446
G3 X169.14 Y165.502 I-.177 J3.435 E.14213
G1 X169.147 Y165.568 E.00203
M204 S10000
G1 X168.363 Y165.673 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.431807
G1 F2145
M204 S8000
G1 X168.389 Y165.864 E.00613
G3 X163.101 Y166.16 I-2.639 J.232 E.26913
G1 X163.101 Y166.142 E.00059
G3 X163.106 Y165.92 I4.251 J-.007 E.00704
G3 X168.355 Y165.614 I2.644 J.177 E.24275
; COOLING_NODE: 5
; WIPE_START
G1 F9257.199
G1 X168.389 Y165.864 E-.09624
G1 X168.399 Y166.147 E-.10736
G1 X168.359 Y166.565 E-.15946
G1 X168.301 Y166.817 E-.09833
G1 X168.219 Y167.063 E-.09847
G1 X168.116 Y167.294 E-.09637
G1 X167.98 Y167.531 E-.10377
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X167.935 Y159.899 Z9.6 F60000
G1 X167.898 Y153.648 Z9.6
G1 Z9.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2145
M204 S8000
G1 X162.702 Y153.648 E.17236
G1 X162.702 Y152.852 E.0264
G1 X167.898 Y152.852 E.17236
G1 X167.898 Y153.588 E.02441
; COOLING_NODE: 5
M204 S250
G1 X168.29 Y154.04 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1941
M204 S5000
G1 X162.31 Y154.04 E.18375
G1 X162.31 Y152.46 E.04855
G1 X168.29 Y152.46 E.18375
G1 X168.29 Y153.98 E.04671
M204 S10000
G1 X167.694 Y153.25 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F2145
M204 S8000
G1 X162.906 Y153.25 E.15172
; COOLING_NODE: 6
; WIPE_START
G1 F9259.259
G1 X164.906 Y153.25 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X170.919 Y157.95 Z9.6 F60000
G1 X182.076 Y166.67 Z9.6
G1 Z9.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2145
M204 S8000
G1 X182.056 Y166.606 E.00223
G3 X184.012 Y163.86 I2.194 J-.508 E.12643
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X184.217 Y163.848 E.0068
G3 X182.194 Y167.018 I.032 J2.251 E.32165
G1 X182.095 Y166.727 E.01017
; COOLING_NODE: 6
M204 S250
G1 X182.447 Y166.546 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1929
M204 S5000
G1 X182.438 Y166.518 E.0009
G3 X184.055 Y164.25 I1.811 J-.419 E.09674
G1 X184.222 Y164.24 E.00513
G3 X182.552 Y166.857 I.028 J1.859 E.24611
G1 X182.466 Y166.603 E.00823
; COOLING_NODE: 6
; WIPE_START
G1 F9547.055
M204 S8000
G1 X182.438 Y166.518 E-.03392
G1 X182.39 Y166.134 E-.14722
G1 X182.418 Y165.778 E-.13548
G1 X182.513 Y165.433 E-.13604
G1 X182.689 Y165.087 E-.14749
G1 X182.912 Y164.808 E-.13582
G1 X182.958 Y164.765 E-.02403
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X181.291 Y165.385 Z9.6 F60000
G1 Z9.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2145
M204 S8000
G1 X181.354 Y165.159 E.0078
G3 X184.281 Y163.053 I2.898 J.941 E.128
G1 X184.408 Y163.056 E.00422
G3 X181.271 Y165.467 I-.156 J3.043 E.49233
G1 X181.277 Y165.444 E.00081
; COOLING_NODE: 1
M204 S250
G1 X180.912 Y165.284 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1941
M204 S5000
G1 X180.981 Y165.038 E.00786
G3 X184.284 Y162.66 I3.271 J1.062 E.1338
G1 X184.429 Y162.665 E.00446
G3 X180.888 Y165.386 I-.177 J3.435 E.5147
G1 X180.899 Y165.342 E.00138
M204 S10000
G1 X181.669 Y165.51 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43181
G1 F2145
M204 S8000
G1 X181.69 Y165.414 E.00309
G3 X181.601 Y166.16 I2.56 J.683 E.50365
G1 X181.601 Y166.142 E.00059
G3 X181.606 Y165.92 I4.249 J-.007 E.00704
G3 X181.637 Y165.654 I2.644 J.177 E.00849
M73 P84 R2
G1 X181.656 Y165.568 E.00277
; COOLING_NODE: 5
; WIPE_START
G1 F9257.127
G1 X181.69 Y165.414 E-.05985
G1 X181.776 Y165.149 E-.10609
G1 X181.884 Y164.906 E-.10096
G1 X182.02 Y164.668 E-.10426
G1 X182.161 Y164.469 E-.09252
G1 X182.337 Y164.266 E-.10212
G1 X182.512 Y164.1 E-.09144
G1 X182.724 Y163.934 E-.10275
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X182.263 Y156.315 Z9.6 F60000
G1 X182.102 Y153.648 Z9.6
G1 Z9.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2145
M204 S8000
G1 X182.102 Y152.852 E.0264
G1 X187.298 Y152.852 E.17236
G1 X187.298 Y153.648 E.0264
G1 X182.162 Y153.648 E.17037
; COOLING_NODE: 5
M204 S250
G1 X181.71 Y154.04 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1941
M204 S5000
G1 X181.71 Y152.46 E.04855
G1 X187.69 Y152.46 E.18375
G1 X187.69 Y154.04 E.04855
G1 X181.77 Y154.04 E.18191
M204 S10000
G1 X182.306 Y153.25 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F2145
M204 S8000
G1 X187.094 Y153.25 E.15172
; CHANGE_LAYER
; Z_HEIGHT: 9.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.259
G1 X185.094 Y153.25 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 69/85
; update layer progress
M73 L69
M991 S0 P68 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 7
M204 S10000
G17
G3 Z9.6 I-.754 J-.955 P1  F60000
G1 X167.86 Y166.863 Z9.6
G1 Z9.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1839
M204 S8000
G1 X167.754 Y167.123 E.00931
G3 X165.514 Y163.86 I-2.005 J-1.024 E.3089
G1 X165.74 Y163.847 E.0075
G3 X167.912 Y166.723 I.009 J2.252 E.1386
G1 X167.881 Y166.807 E.00298
; COOLING_NODE: 7
M204 S250
G1 X167.496 Y166.72 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1839
M204 S5000
G1 X167.406 Y166.944 E.00743
G3 X165.555 Y164.25 I-1.656 J-.845 E.23631
G1 X165.742 Y164.24 E.00575
G3 X167.536 Y166.613 I.007 J1.859 E.10597
G1 X167.517 Y166.664 E.00165
; COOLING_NODE: 7
; WIPE_START
G1 F9547.055
M204 S8000
G1 X167.406 Y166.944 E-.11471
G1 X167.196 Y167.271 E-.14751
G1 X166.927 Y167.541 E-.14489
G1 X166.624 Y167.742 E-.1382
G1 X166.293 Y167.879 E-.13612
G1 X166.09 Y167.919 E-.07857
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X168.764 Y165.672 Z9.8 F60000
G1 Z9.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1839
M204 S8000
G1 X168.791 Y165.874 E.00677
G3 X165.79 Y163.053 I-3.039 J.226 E.48509
G1 X165.907 Y163.056 E.00391
G3 X168.753 Y165.57 I-.155 J3.043 E.13597
G1 X168.758 Y165.612 E.0014
; COOLING_NODE: 4
M204 S250
G1 X169.153 Y165.623 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1839
M204 S5000
G1 X169.182 Y165.844 E.00684
G3 X165.794 Y162.66 I-3.43 J.256 E.50716
G1 X165.929 Y162.665 E.00416
G3 X169.14 Y165.502 I-.177 J3.435 E.14212
G1 X169.146 Y165.563 E.0019
M204 S10000
G1 X168.363 Y165.673 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.431796
G1 F1839
M204 S8000
G1 X168.388 Y165.866 E.00617
G3 X163.1 Y166.107 I-2.638 J.245 E.27164
G1 X163.1 Y166.088 E.00059
G3 X163.107 Y165.915 I3.322 J.052 E.00548
G3 X168.351 Y165.604 I2.642 J.195 E.24146
G1 X168.352 Y165.614 E.0003
; COOLING_NODE: 5
; WIPE_START
G1 F9257.454
G1 X168.388 Y165.866 E-.09675
G1 X168.399 Y166.147 E-.10697
G1 X168.35 Y166.61 E-.17696
G1 X168.293 Y166.844 E-.09142
G1 X168.205 Y167.097 E-.10175
G1 X168.111 Y167.303 E-.08621
G1 X167.979 Y167.53 E-.09993
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X167.935 Y159.898 Z9.8 F60000
G1 X167.898 Y153.648 Z9.8
G1 Z9.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1839
M204 S8000
G1 X162.702 Y153.648 E.17236
G1 X162.702 Y152.852 E.0264
G1 X167.898 Y152.852 E.17236
G1 X167.898 Y153.588 E.02441
; COOLING_NODE: 5
M204 S250
G1 X168.29 Y154.04 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1839
M204 S5000
G1 X162.31 Y154.04 E.18375
G1 X162.31 Y152.46 E.04855
G1 X168.29 Y152.46 E.18375
G1 X168.29 Y153.98 E.04671
M204 S10000
G1 X167.694 Y153.25 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1839
M204 S8000
G1 X162.906 Y153.25 E.15172
; COOLING_NODE: 6
; WIPE_START
G1 F9259.259
G1 X164.906 Y153.25 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X170.925 Y157.943 Z9.8 F60000
G1 X182.071 Y166.635 Z9.8
G1 Z9.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1839
M204 S8000
G1 X182.007 Y166.307 E.0111
G3 X184.014 Y163.86 I2.242 J-.208 E.11642
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X184.24 Y163.847 E.0075
G3 X182.095 Y166.756 I.009 J2.252 E.33014
G1 X182.083 Y166.694 E.00212
; COOLING_NODE: 6
M204 S250
G1 X182.454 Y166.56 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1839
M204 S5000
G1 X182.398 Y166.27 E.00907
G3 X184.055 Y164.25 I1.851 J-.171 E.08903
G1 X184.242 Y164.24 E.00575
G3 X182.471 Y166.643 I.007 J1.859 E.25249
G1 X182.466 Y166.618 E.00076
; COOLING_NODE: 6
; WIPE_START
G1 F9547.055
M204 S8000
G1 X182.398 Y166.27 E-.13501
G1 X182.397 Y165.937 E-.12664
G1 X182.471 Y165.556 E-.14717
G1 X182.608 Y165.226 E-.13591
G1 X182.82 Y164.91 E-.14454
G1 X182.952 Y164.779 E-.07074
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X181.293 Y165.371 Z9.8 F60000
G1 Z9.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1839
M204 S8000
G1 X181.354 Y165.159 E.0073
G3 X184.29 Y163.053 I2.899 J.94 E.12832
G1 X184.407 Y163.056 E.00391
G3 X181.279 Y165.429 I-.155 J3.043 E.49361
; COOLING_NODE: 1
M204 S250
G1 X180.915 Y165.267 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1839
M204 S5000
G1 X180.981 Y165.038 E.00732
G3 X184.294 Y162.66 I3.272 J1.061 E.13412
G1 X184.429 Y162.665 E.00416
G3 X180.898 Y165.343 I-.177 J3.435 E.51605
G1 X180.902 Y165.325 E.00054
M204 S10000
G1 X181.667 Y165.519 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.431806
G1 F1839
M204 S8000
G1 X181.722 Y165.318 E.00662
G3 X181.6 Y166.11 I2.528 J.792 E.50206
G1 X181.6 Y166.092 E.00055
G1 X181.601 Y166.053 E.00124
G3 X181.653 Y165.585 I2.649 J.057 E.01493
G1 X181.654 Y165.578 E.00025
; COOLING_NODE: 5
; WIPE_START
G1 F9257.213
G1 X181.722 Y165.318 E-.10212
G1 X181.81 Y165.068 E-.10061
G1 X181.916 Y164.845 E-.09407
G1 X182.058 Y164.611 E-.10393
G1 X182.218 Y164.399 E-.10063
G1 X182.385 Y164.218 E-.09364
G1 X182.721 Y163.943 E-.165
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X182.263 Y156.324 Z9.8 F60000
G1 X182.102 Y153.648 Z9.8
G1 Z9.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1839
M204 S8000
G1 X182.102 Y152.852 E.0264
G1 X187.298 Y152.852 E.17236
G1 X187.298 Y153.648 E.0264
G1 X182.162 Y153.648 E.17037
; COOLING_NODE: 5
M204 S250
G1 X181.71 Y154.04 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1839
M204 S5000
G1 X181.71 Y152.46 E.04855
M73 P85 R2
G1 X187.69 Y152.46 E.18375
G1 X187.69 Y154.04 E.04855
G1 X181.77 Y154.04 E.18191
M204 S10000
G1 X182.306 Y153.25 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1839
M204 S8000
G1 X187.094 Y153.25 E.15172
; CHANGE_LAYER
; Z_HEIGHT: 9.44762
; LAYER_HEIGHT: 0.0476198
; WIPE_START
G1 F9259.259
G1 X185.094 Y153.25 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 70/85
; update layer progress
M73 L70
M991 S0 P69 ;notify layer change

; OBJECT_ID: 15
M204 S10000
G17
G3 Z9.8 I-.269 J-1.187 P1  F60000
G1 X180.769 Y154.231 Z9.8
G1 Z9.448
G1 E.8 F1800
; FEATURE: Support interface
; LINE_WIDTH: 0.42
; LAYER_HEIGHT: 0.27619
G1 F2132
M204 S8000
G1 X180.962 Y154.038 E.01108
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X180.962 Y152.798 E.05035
G1 X179.698 Y154.062 E.07254
G1 X178.458 Y154.062 E.05035
G1 X180.081 Y152.438 E.09319
G1 X178.841 Y152.438 E.05035
G1 X177.217 Y154.062 E.09319
G1 X175.977 Y154.062 E.05035
G1 X177.6 Y152.438 E.09319
G1 X176.36 Y152.438 E.05035
G1 X174.737 Y154.062 E.09319
G1 X173.496 Y154.062 E.05035
G1 X175.119 Y152.438 E.09319
G1 X173.879 Y152.438 E.05035
G1 X172.256 Y154.062 E.09319
G1 X171.015 Y154.062 E.05035
G1 X172.639 Y152.438 E.09319
G1 X171.398 Y152.438 E.05035
G1 X169.775 Y154.062 E.09319
G1 X169.038 Y154.062 E.0299
G1 X169.038 Y153.558 E.02045
G1 X170.328 Y152.269 E.07401
; CHANGE_LAYER
; Z_HEIGHT: 9.6
; LAYER_HEIGHT: 0.152381
; WIPE_START
G1 F4800
G1 X169.038 Y153.558 E-.69285
G1 X169.038 Y153.735 E-.06715
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 71/85
; update layer progress
M73 L71
M991 S0 P70 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 7
M204 S10000
G17
G3 Z9.848 I-1.212 J-.108 P1  F60000
G1 X167.872 Y166.838 Z9.848
G1 Z9.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
; LAYER_HEIGHT: 0.2
G1 F2132
M204 S8000
G1 X167.849 Y166.909 E.00248
G3 X165.513 Y163.86 I-2.1 J-.81 E.3166
G1 X165.728 Y163.847 E.00715
G3 X167.965 Y166.494 I.02 J2.251 E.13115
G1 X167.888 Y166.78 E.00984
; COOLING_NODE: 7
M204 S250
G1 X167.496 Y166.733 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1946
M204 S5000
G1 X167.484 Y166.767 E.0011
G3 X165.555 Y164.25 I-1.735 J-.668 E.24221
G1 X165.732 Y164.24 E.00545
G3 X167.579 Y166.424 I.017 J1.859 E.10029
G1 X167.512 Y166.675 E.008
; COOLING_NODE: 7
; WIPE_START
G1 F9547.055
M204 S8000
G1 X167.484 Y166.767 E-.0364
G1 X167.311 Y167.112 E-.1467
G1 X167.088 Y167.392 E-.13589
G1 X166.817 Y167.624 E-.13562
G1 X166.506 Y167.8 E-.1358
G1 X166.154 Y167.916 E-.14077
G1 X166.079 Y167.925 E-.02882
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X168.763 Y165.667 Z10 F60000
G1 Z9.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2132
M204 S8000
G1 X168.791 Y165.887 E.00736
G3 X165.799 Y163.053 I-3.04 J.212 E.48498
G1 X165.907 Y163.056 E.00359
G3 X168.752 Y165.571 I-.156 J3.043 E.13597
G1 X168.756 Y165.607 E.00123
; COOLING_NODE: 4
M204 S250
G1 X169.152 Y165.619 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1951
M204 S5000
G1 X169.182 Y165.86 E.00745
G3 X165.804 Y162.661 I-3.431 J.24 E.50699
G1 X165.929 Y162.665 E.00386
G3 X169.139 Y165.503 I-.178 J3.435 E.1421
G1 X169.145 Y165.56 E.00177
M204 S10000
G1 X168.366 Y165.693 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.431803
G1 F2132
M204 S8000
G1 X168.38 Y165.777 E.00269
G3 X163.102 Y166.196 I-2.63 J.323 E.27095
G1 X163.1 Y166.137 E.00189
G3 X163.107 Y165.915 I4.258 J.014 E.00702
G3 X168.339 Y165.537 I2.643 J.185 E.23995
G1 X168.356 Y165.634 E.00312
; COOLING_NODE: 5
; WIPE_START
G1 F9257.294
G1 X168.38 Y165.777 E-.055
G1 X168.4 Y166.063 E-.10903
G1 X168.36 Y166.56 E-.18937
G1 X168.298 Y166.831 E-.10556
G1 X168.219 Y167.063 E-.0931
G1 X168.111 Y167.304 E-.10026
G1 X167.98 Y167.531 E-.09985
G1 X167.968 Y167.548 E-.00783
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X167.93 Y159.916 Z10 F60000
G1 X167.898 Y153.648 Z10
G1 Z9.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2132
M204 S8000
G1 X162.702 Y153.648 E.17236
G1 X162.702 Y152.852 E.0264
G1 X167.898 Y152.852 E.17236
G1 X167.898 Y153.588 E.02441
; COOLING_NODE: 5
M204 S250
G1 X168.29 Y154.04 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1951
M204 S5000
G1 X162.31 Y154.04 E.18375
G1 X162.31 Y152.46 E.04855
G1 X168.29 Y152.46 E.18375
G1 X168.29 Y153.98 E.04671
M204 S10000
G1 X167.694 Y153.25 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F2132
M204 S8000
G1 X162.906 Y153.25 E.15172
; COOLING_NODE: 6
; WIPE_START
G1 F9259.259
G1 X164.906 Y153.25 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X170.919 Y157.95 Z10 F60000
G1 X182.079 Y166.673 Z10
G1 Z9.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2132
M204 S8000
G1 X182.047 Y166.569 E.0036
G3 X184.013 Y163.86 I2.202 J-.471 E.12521
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X184.228 Y163.847 E.00715
G3 X182.178 Y166.981 I.02 J2.251 E.32249
G1 X182.098 Y166.73 E.00876
; COOLING_NODE: 6
M204 S250
G1 X182.452 Y166.555 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1946
M204 S5000
G1 X182.431 Y166.487 E.0022
G3 X184.055 Y164.25 I1.818 J-.388 E.09576
G1 X184.232 Y164.24 E.00545
G3 X182.539 Y166.827 I.017 J1.859 E.2467
G1 X182.47 Y166.612 E.00693
; COOLING_NODE: 6
; WIPE_START
G1 F9547.055
M204 S8000
G1 X182.431 Y166.487 E-.05
G1 X182.39 Y166.133 E-.13538
G1 X182.418 Y165.776 E-.13613
G1 X182.514 Y165.432 E-.13554
G1 X182.689 Y165.088 E-.14672
G1 X182.912 Y164.808 E-.13606
G1 X182.951 Y164.771 E-.02017
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X181.297 Y165.356 Z10 F60000
G1 Z9.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2132
M204 S8000
G1 X181.353 Y165.159 E.0068
G3 X184.299 Y163.053 I2.898 J.941 E.12865
G1 X184.407 Y163.056 E.00359
G3 X181.282 Y165.414 I-.156 J3.043 E.4941
; COOLING_NODE: 1
M204 S250
G1 X180.919 Y165.251 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1951
M204 S5000
G1 X180.98 Y165.038 E.00681
G3 X184.304 Y162.661 I3.271 J1.062 E.13444
G1 X184.429 Y162.665 E.00386
G3 X180.9 Y165.326 I-.178 J3.435 E.51652
G1 X180.904 Y165.309 E.00054
M204 S10000
G1 X181.675 Y165.486 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.431802
G1 F2132
M204 S8000
G1 X181.7 Y165.383 E.00335
G3 X181.601 Y166.157 I2.55 J.721 E.50275
G1 X181.6 Y166.137 E.00064
G3 X181.607 Y165.915 I4.281 J.015 E.00702
G3 X181.641 Y165.64 I2.643 J.189 E.00879
G1 X181.662 Y165.545 E.00309
; COOLING_NODE: 5
; WIPE_START
G1 F9257.309
G1 X181.7 Y165.383 E-.06298
G1 X181.776 Y165.15 E-.0933
G1 X181.888 Y164.897 E-.10525
G1 X182.162 Y164.468 E-.19307
G1 X182.337 Y164.266 E-.10162
G1 X182.539 Y164.077 E-.1053
G1 X182.745 Y163.92 E-.09848
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X182.268 Y156.302 Z10 F60000
G1 X182.102 Y153.648 Z10
G1 Z9.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2132
M204 S8000
G1 X182.102 Y152.852 E.0264
G1 X187.298 Y152.852 E.17236
G1 X187.298 Y153.648 E.0264
G1 X182.162 Y153.648 E.17037
; COOLING_NODE: 5
M204 S250
G1 X181.71 Y154.04 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1951
M204 S5000
G1 X181.71 Y152.46 E.04855
G1 X187.69 Y152.46 E.18375
G1 X187.69 Y154.04 E.04855
G1 X181.77 Y154.04 E.18191
M204 S10000
G1 X182.306 Y153.25 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
M73 P86 R2
G1 F2132
M204 S8000
G1 X187.094 Y153.25 E.15172
; CHANGE_LAYER
; Z_HEIGHT: 9.72381
; LAYER_HEIGHT: 0.123809
; WIPE_START
G1 F9259.259
G1 X185.094 Y153.25 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 72/85
; update layer progress
M73 L72
M991 S0 P71 ;notify layer change

; OBJECT_ID: 15
M204 S10000
G17
G3 Z10 I-.146 J-1.208 P1  F60000
G1 X181.131 Y153.728 Z10
G1 Z9.724
G1 E.8 F1800
; FEATURE: Support interface
; LINE_WIDTH: 0.42
; LAYER_HEIGHT: 0.27619
G1 F2138
M204 S8000
G1 X179.842 Y152.438 E.07401
G1 X178.602 Y152.438 E.05035
G1 X180.225 Y154.062 E.09319
G1 X178.985 Y154.062 E.05035
G1 X177.361 Y152.438 E.09319
G1 X176.121 Y152.438 E.05035
G1 X177.744 Y154.062 E.09319
G1 X176.504 Y154.062 E.05035
G1 X174.881 Y152.438 E.09319
G1 X173.64 Y152.438 E.05035
G1 X175.264 Y154.062 E.09319
G1 X174.023 Y154.062 E.05035
G1 X172.4 Y152.438 E.09319
G1 X171.159 Y152.438 E.05035
G1 X172.783 Y154.062 E.09319
G1 X171.542 Y154.062 E.05035
G1 X169.919 Y152.438 E.09319
G1 X169.038 Y152.438 E.03575
G1 X169.038 Y152.798 E.0146
G1 X170.302 Y154.062 E.07254
G1 X169.062 Y154.062 E.05035
G1 X168.869 Y153.869 E.01108
; WIPE_START
G1 F4800
G1 X169.062 Y154.062 E-.10368
G1 X170.302 Y154.062 E-.47134
G1 X169.958 Y153.717 E-.18497
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z10.124 I1.217 J0 P1  F60000
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
            

            
                M9711 M0 E1 X256 Y153 Z9.72381 S11 C10 O0 T3000
            

            
        M623

        M622 J1
            

            
                M9711 M0 E1 U256 V153 Z9.72381 S11 C10 O0 T3000
            

            
        M623
    
    
    
        M993 A3 B3 C3
    
M623
; SKIPPABLE_END

G1 Z10.124
; CHANGE_LAYER
; Z_HEIGHT: 9.8
; LAYER_HEIGHT: 0.0761909
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 73/85
; update layer progress
M73 L73
M991 S0 P72 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 7
G1 X167.872 Y166.839
G1 Z9.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
; LAYER_HEIGHT: 0.2
G1 F2138
M204 S8000
G1 X167.851 Y166.907 E.00238
G3 X165.512 Y163.86 I-2.101 J-.808 E.31665
G1 X165.717 Y163.848 E.00683
G3 X167.967 Y166.489 I.032 J2.251 E.1314
G1 X167.888 Y166.781 E.01003
; COOLING_NODE: 7
M204 S250
G1 X167.496 Y166.735 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1957
M204 S5000
G1 X167.485 Y166.767 E.00103
G3 X165.554 Y164.25 I-1.735 J-.667 E.24224
G1 X165.722 Y164.24 E.00516
G3 X167.581 Y166.422 I.028 J1.859 E.10057
G1 X167.511 Y166.677 E.0081
; COOLING_NODE: 7
; WIPE_START
G1 F9547.055
M204 S8000
G1 X167.485 Y166.767 E-.03557
G1 X167.311 Y167.112 E-.14708
G1 X167.089 Y167.392 E-.13575
G1 X166.817 Y167.624 E-.13584
G1 X166.503 Y167.801 E-.13704
G1 X166.136 Y167.92 E-.14626
G1 X166.078 Y167.926 E-.02245
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X168.764 Y165.657 Z10.2 F60000
G1 Z9.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2138
M204 S8000
G1 X168.791 Y165.941 E.00948
G3 X165.75 Y163.052 I-3.042 J.158 E.48145
G1 X165.909 Y163.056 E.00528
G3 X168.754 Y165.598 I-.16 J3.042 E.13673
; COOLING_NODE: 4
M204 S250
G1 X169.153 Y165.616 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1960
M204 S5000
G1 X169.184 Y165.92 E.00941
G3 X165.751 Y162.66 I-3.434 J.178 E.50338
G1 X165.93 Y162.665 E.00548
G3 X169.145 Y165.556 I-.18 J3.434 E.14371
M204 S10000
G1 X168.37 Y165.729 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.431789
G1 F2138
M204 S8000
G1 X168.378 Y165.768 E.00126
G3 X163.101 Y166.157 I-2.628 J.333 E.27254
G1 X163.1 Y166.136 E.00064
G3 X163.109 Y165.882 I5.473 J.064 E.00806
G3 X168.269 Y165.282 I2.64 J.219 E.23041
G1 X168.357 Y165.67 E.01262
; COOLING_NODE: 5
; WIPE_START
G1 F9257.614
G1 X168.378 Y165.768 E-.03791
G1 X168.396 Y166.238 E-.17883
G1 X168.366 Y166.519 E-.1072
G1 X168.321 Y166.741 E-.08625
G1 X168.188 Y167.135 E-.15784
G1 X167.97 Y167.547 E-.17739
G1 X167.947 Y167.578 E-.01458
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X167.92 Y159.946 Z10.2 F60000
G1 X167.898 Y153.648 Z10.2
G1 Z9.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2138
M204 S8000
G1 X162.702 Y153.648 E.17236
G1 X162.702 Y152.852 E.0264
G1 X167.898 Y152.852 E.17236
G1 X167.898 Y153.588 E.02441
; COOLING_NODE: 5
M204 S250
G1 X168.29 Y154.04 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1960
M204 S5000
G1 X162.31 Y154.04 E.18375
G1 X162.31 Y152.46 E.04855
G1 X168.29 Y152.46 E.18375
G1 X168.29 Y153.98 E.04671
M204 S10000
G1 X167.694 Y153.25 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F2138
M204 S8000
G1 X162.906 Y153.25 E.15172
; COOLING_NODE: 6
; WIPE_START
G1 F9259.259
G1 X164.906 Y153.25 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X170.92 Y157.949 Z10.2 F60000
G1 X182.072 Y166.664 Z10.2
G1 Z9.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2138
M204 S8000
G1 X182.048 Y166.57 E.00319
G3 X184.012 Y163.86 I2.202 J-.472 E.12519
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X184.217 Y163.848 E.00683
G3 X182.109 Y166.796 I.032 J2.251 E.32951
G1 X182.088 Y166.721 E.00258
; COOLING_NODE: 6
M204 S250
G1 X182.454 Y166.561 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1957
M204 S5000
G1 X182.431 Y166.487 E.00237
G3 X184.054 Y164.25 I1.818 J-.388 E.09575
G1 X184.222 Y164.24 E.00516
G3 X182.551 Y166.856 I.028 J1.859 E.24613
G1 X182.473 Y166.618 E.0077
; COOLING_NODE: 6
; WIPE_START
G1 F9547.055
M204 S8000
G1 X182.431 Y166.487 E-.05209
G1 X182.39 Y166.133 E-.13563
G1 X182.418 Y165.776 E-.13586
G1 X182.514 Y165.433 E-.1355
G1 X182.675 Y165.11 E-.13696
G1 X182.912 Y164.808 E-.14591
G1 X182.946 Y164.776 E-.01805
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X181.295 Y165.356 Z10.2 F60000
G1 Z9.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2138
M204 S8000
G1 X181.444 Y164.909 E.01561
G3 X184.25 Y163.052 I2.805 J1.189 E.11823
G1 X184.409 Y163.056 E.00528
G3 X181.281 Y165.414 I-.16 J3.042 E.4938
; COOLING_NODE: 1
M204 S250
G1 X180.923 Y165.233 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1960
M204 S5000
G1 X181.019 Y164.924 E.00994
G3 X184.251 Y162.66 I3.232 J1.174 E.12917
G1 X184.43 Y162.665 E.00548
G3 X180.908 Y165.291 I-.18 J3.434 E.51739
M204 S10000
G1 X181.689 Y165.43 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.431789
G1 F2138
M204 S8000
G1 X181.695 Y165.397 E.00106
G3 X181.601 Y166.157 I2.554 J.704 E.5031
G1 X181.6 Y166.136 E.00064
G3 X181.609 Y165.882 I5.477 J.064 E.00806
G1 X181.679 Y165.489 E.01266
; COOLING_NODE: 5
; WIPE_START
G1 F9257.634
G1 X181.695 Y165.397 E-.03546
G1 X181.773 Y165.159 E-.09512
G1 X181.892 Y164.891 E-.11115
G1 X182.013 Y164.681 E-.09236
G1 X182.168 Y164.46 E-.10247
G1 X182.35 Y164.252 E-.10504
G1 X182.551 Y164.067 E-.10386
G1 X182.745 Y163.919 E-.0926
G1 X182.794 Y163.889 E-.02193
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X182.279 Y156.274 Z10.2 F60000
G1 X182.102 Y153.648 Z10.2
G1 Z9.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2138
M204 S8000
G1 X182.102 Y152.852 E.0264
G1 X187.298 Y152.852 E.17236
G1 X187.298 Y153.648 E.0264
G1 X182.162 Y153.648 E.17037
; COOLING_NODE: 5
M204 S250
G1 X181.71 Y154.04 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1960
M204 S5000
G1 X181.71 Y152.46 E.04855
G1 X187.69 Y152.46 E.18375
G1 X187.69 Y154.04 E.04855
G1 X181.77 Y154.04 E.18191
M204 S10000
G1 X182.306 Y153.25 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F2138
M204 S8000
G1 X187.094 Y153.25 E.15172
; CHANGE_LAYER
; Z_HEIGHT: 10
; LAYER_HEIGHT: 0.2
; WIPE_START
M73 P87 R2
G1 F9259.259
G1 X185.094 Y153.25 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 74/85
; update layer progress
M73 L74
M991 S0 P73 ;notify layer change

; OBJECT_ID: 15
M204 S10000
G17
G3 Z10.2 I-.269 J-1.187 P1  F60000
G1 X180.769 Y154.231 Z10.2
G1 Z10
G1 E.8 F1800
; FEATURE: Support interface
; LINE_WIDTH: 0.42
; LAYER_HEIGHT: 0.27619
G1 F2127
M204 S8000
G1 X180.962 Y154.038 E.01107
G1 X180.962 Y152.798 E.05035
G1 X179.698 Y154.062 E.07253
G1 X178.458 Y154.062 E.05035
G1 X180.081 Y152.438 E.09318
G1 X178.84 Y152.438 E.05035
G1 X177.217 Y154.062 E.09318
G1 X175.977 Y154.062 E.05035
G1 X177.6 Y152.438 E.09318
G1 X176.36 Y152.438 E.05035
G1 X174.737 Y154.062 E.09318
G1 X173.496 Y154.062 E.05035
G1 X175.119 Y152.438 E.09318
G1 X173.879 Y152.438 E.05035
G1 X172.256 Y154.062 E.09318
G1 X171.016 Y154.062 E.05035
G1 X172.639 Y152.438 E.09318
G1 X171.398 Y152.438 E.05035
G1 X169.775 Y154.062 E.09318
G1 X169.038 Y154.062 E.02991
G1 X169.038 Y153.558 E.02045
G1 X170.328 Y152.269 E.07401
; COOLING_NODE: 7
; WIPE_START
G1 F4800
G1 X169.038 Y153.558 E-.6928
G1 X169.038 Y153.735 E-.0672
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X168.353 Y161.336 Z10.4 F60000
G1 X167.854 Y166.878 Z10.4
G1 Z10
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
; LAYER_HEIGHT: 0.2
G1 F2127
M204 S8000
G1 X167.722 Y167.182 E.011
G3 X165.514 Y163.86 I-1.973 J-1.083 E.30663
G1 X165.74 Y163.847 E.00751
G3 X167.901 Y166.757 I.008 J2.251 E.13976
G1 X167.876 Y166.822 E.00231
; COOLING_NODE: 7
M204 S250
G1 X167.494 Y166.726 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1975
M204 S5000
G1 X167.378 Y166.994 E.00898
G3 X165.555 Y164.25 I-1.629 J-.895 E.2345
G1 X165.743 Y164.24 E.00576
G3 X167.527 Y166.643 I.007 J1.859 E.10689
G1 X167.516 Y166.67 E.0009
; COOLING_NODE: 7
; WIPE_START
G1 F9547.055
M204 S8000
G1 X167.378 Y166.994 E-.13385
G1 X167.175 Y167.295 E-.13796
G1 X166.921 Y167.545 E-.13538
G1 X166.624 Y167.742 E-.13551
G1 X166.324 Y167.87 E-.124
G1 X166.084 Y167.921 E-.0933
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X168.768 Y165.675 Z10.4 F60000
G1 Z10
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2127
M204 S8000
G3 X165.759 Y163.052 I-3.018 J.424 E.49072
G1 X165.909 Y163.056 E.00498
G3 X168.759 Y165.616 I-.158 J3.043 E.13742
; COOLING_NODE: 4
M204 S250
G1 X169.155 Y165.612 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1976
M204 S5000
G1 X169.157 Y165.621 E.00029
G3 X165.761 Y162.66 I-3.406 J.479 E.51306
G1 X165.93 Y162.665 E.00518
G3 X169.089 Y165.268 I-.178 J3.435 E.13471
G1 X169.143 Y165.553 E.00892
M204 S10000
G1 X168.362 Y165.665 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.431795
G1 F2127
M204 S8000
G1 X168.386 Y165.848 E.00585
G3 X163.1 Y166.106 I-2.637 J.26 E.27203
G1 X163.1 Y166.087 E.0006
G3 X163.11 Y165.873 I4.871 J.127 E.00679
G3 X168.348 Y165.595 I2.639 J.234 E.23997
G1 X168.35 Y165.606 E.00033
; COOLING_NODE: 5
; WIPE_START
G1 F9257.489
G1 X168.386 Y165.848 E-.09298
G1 X168.395 Y166.243 E-.15009
G1 X168.349 Y166.618 E-.14389
G1 X168.285 Y166.875 E-.10049
G1 X168.19 Y167.135 E-.10521
G1 X167.98 Y167.522 E-.16734
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X167.935 Y159.89 Z10.4 F60000
G1 X167.898 Y153.648 Z10.4
G1 Z10
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2127
M204 S8000
G1 X162.702 Y153.648 E.17236
G1 X162.702 Y152.852 E.0264
G1 X167.898 Y152.852 E.17236
G1 X167.898 Y153.588 E.02441
; COOLING_NODE: 5
M204 S250
G1 X168.29 Y154.04 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1976
M204 S5000
G1 X162.31 Y154.04 E.18375
G1 X162.31 Y152.46 E.04855
G1 X168.29 Y152.46 E.18375
G1 X168.29 Y153.98 E.04671
M204 S10000
G1 X167.694 Y153.25 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F2127
M204 S8000
G1 X162.906 Y153.25 E.15172
; COOLING_NODE: 6
; WIPE_START
G1 F9259.259
G1 X164.906 Y153.25 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X170.922 Y157.947 Z10.4 F60000
G1 X182.075 Y166.654 Z10.4
G1 Z10
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2127
M204 S8000
G1 X182.007 Y166.306 E.01174
G3 X184.014 Y163.86 I2.242 J-.207 E.1164
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X184.24 Y163.847 E.00751
G3 X182.096 Y166.757 I.008 J2.251 E.33004
G1 X182.087 Y166.712 E.00151
; COOLING_NODE: 6
M204 S250
G1 X182.458 Y166.578 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1975
M204 S5000
G1 X182.398 Y166.269 E.00967
G3 X184.055 Y164.25 I1.851 J-.171 E.08901
G1 X184.243 Y164.24 E.00576
G3 X182.472 Y166.643 I.007 J1.859 E.2524
G1 X182.47 Y166.637 E.00019
; COOLING_NODE: 6
; WIPE_START
G1 F9547.055
M204 S8000
G1 X182.398 Y166.269 E-.14236
G1 X182.4 Y165.905 E-.13845
G1 X182.479 Y165.532 E-.1448
G1 X182.619 Y165.205 E-.13554
G1 X182.805 Y164.929 E-.12638
G1 X182.94 Y164.794 E-.07247
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X181.305 Y165.327 Z10.4 F60000
G1 Z10
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2127
M204 S8000
G1 X181.369 Y165.108 E.00759
G3 X184.259 Y163.052 I2.881 J.992 E.12553
G1 X184.409 Y163.056 E.00498
G3 X181.281 Y165.417 I-.158 J3.043 E.49392
G1 X181.29 Y165.385 E.00109
; COOLING_NODE: 1
M204 S250
G1 X180.929 Y165.219 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1976
M204 S5000
G1 X180.999 Y164.98 E.00766
G3 X184.261 Y162.66 I3.252 J1.119 E.13127
G1 X184.43 Y162.665 E.00518
G3 X180.9 Y165.327 I-.178 J3.435 E.51647
G1 X180.913 Y165.277 E.00159
M204 S10000
G1 X181.677 Y165.478 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.431794
G1 F2127
M204 S8000
M73 P87 R1
G1 X181.725 Y165.302 E.00578
G3 X181.6 Y166.106 I2.524 J.805 E.5016
G1 X181.6 Y166.087 E.0006
G3 X181.61 Y165.873 I4.896 J.128 E.00679
G3 X181.657 Y165.56 I2.639 J.234 E.01003
G1 X181.663 Y165.537 E.00078
; COOLING_NODE: 5
; WIPE_START
G1 F9257.499
G1 X181.725 Y165.302 E-.09207
G1 X181.808 Y165.07 E-.09366
G1 X181.922 Y164.834 E-.09965
G1 X182.194 Y164.427 E-.18594
G1 X182.376 Y164.226 E-.10311
G1 X182.582 Y164.041 E-.1053
G1 X182.758 Y163.924 E-.08027
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X182.272 Y156.307 Z10.4 F60000
G1 X182.102 Y153.648 Z10.4
G1 Z10
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2127
M204 S8000
G1 X182.102 Y152.852 E.0264
G1 X187.298 Y152.852 E.17236
G1 X187.298 Y153.648 E.0264
G1 X182.162 Y153.648 E.17037
; COOLING_NODE: 5
M204 S250
G1 X181.71 Y154.04 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1976
M204 S5000
G1 X181.71 Y152.46 E.04855
G1 X187.69 Y152.46 E.18375
G1 X187.69 Y154.04 E.04855
G1 X181.77 Y154.04 E.18191
M204 S10000
G1 X182.306 Y153.25 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F2127
M204 S8000
G1 X187.094 Y153.25 E.15172
; CHANGE_LAYER
; Z_HEIGHT: 10.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.259
G1 X185.094 Y153.25 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 75/85
; update layer progress
M73 L75
M991 S0 P74 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 7
M204 S10000
G17
G3 Z10.4 I-.754 J-.955 P1  F60000
G1 X167.871 Y166.842 Z10.4
G1 Z10.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1835
M204 S8000
M73 P88 R1
G1 X167.85 Y166.905 E.00219
G3 X165.514 Y163.86 I-2.102 J-.806 E.31676
G1 X165.729 Y163.847 E.00715
G3 X167.965 Y166.492 I.02 J2.251 E.13107
G1 X167.887 Y166.784 E.01004
; COOLING_NODE: 7
M204 S250
G1 X167.495 Y166.738 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1835
M204 S5000
G1 X167.484 Y166.766 E.00091
G3 X165.556 Y164.25 I-1.735 J-.667 E.24226
G1 X165.732 Y164.24 E.00545
G3 X167.58 Y166.423 I.017 J1.859 E.10025
G1 X167.51 Y166.68 E.00818
; COOLING_NODE: 7
; WIPE_START
G1 F9547.055
M204 S8000
G1 X167.484 Y166.766 E-.03399
G1 X167.328 Y167.086 E-.1355
G1 X167.088 Y167.392 E-.14776
G1 X166.818 Y167.623 E-.13523
G1 X166.507 Y167.799 E-.13562
G1 X166.154 Y167.916 E-.14133
G1 X166.074 Y167.925 E-.03057
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X168.763 Y165.665 Z10.6 F60000
G1 Z10.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1835
M204 S8000
G1 X168.782 Y165.799 E.00449
G3 X166.016 Y169.136 I-3.033 J.301 E.15993
G3 X165.909 Y163.056 I-.265 J-3.036 E.33164
G3 X168.741 Y165.518 I-.16 J3.044 E.13407
G1 X168.754 Y165.606 E.00297
; COOLING_NODE: 4
M204 S250
G1 X169.154 Y165.606 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1835
M204 S5000
G1 X169.159 Y165.622 E.0005
G3 X165.771 Y162.66 I-3.406 J.477 E.5133
G1 X165.93 Y162.665 E.00487
G3 X169.095 Y165.288 I-.177 J3.435 E.13538
G1 X169.143 Y165.547 E.00812
M204 S10000
G1 X168.362 Y165.672 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.431811
G1 F1835
M204 S8000
G1 X168.382 Y165.808 E.00434
G3 X163.101 Y166.158 I-2.632 J.303 E.27188
G1 X163.101 Y166.14 E.00057
G1 X163.101 Y166.1 E.00127
G3 X168.341 Y165.558 I2.65 J.01 E.24582
G1 X168.351 Y165.613 E.00178
; COOLING_NODE: 5
; WIPE_START
G1 F9257.1
G1 X168.382 Y165.808 E-.07484
G1 X168.4 Y166.065 E-.09787
G1 X168.391 Y166.327 E-.09969
G1 X168.358 Y166.571 E-.09363
G1 X168.302 Y166.816 E-.09532
G1 X168.221 Y167.056 E-.09635
G1 X168.126 Y167.273 E-.09019
G1 X167.992 Y167.513 E-.10429
G1 X167.98 Y167.53 E-.00783
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X167.935 Y159.897 Z10.6 F60000
G1 X167.898 Y153.648 Z10.6
G1 Z10.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1835
M204 S8000
G1 X162.702 Y153.648 E.17236
G1 X162.702 Y152.852 E.0264
G1 X167.898 Y152.852 E.17236
G1 X167.898 Y153.588 E.02441
; COOLING_NODE: 5
M204 S250
G1 X168.29 Y154.04 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1835
M204 S5000
G1 X162.31 Y154.04 E.18375
G1 X162.31 Y152.46 E.04855
G1 X168.29 Y152.46 E.18375
G1 X168.29 Y153.98 E.04671
M204 S10000
G1 X167.694 Y153.25 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1835
M204 S8000
G1 X162.906 Y153.25 E.15172
; COOLING_NODE: 6
; WIPE_START
G1 F9259.259
G1 X164.906 Y153.25 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X170.918 Y157.952 Z10.6 F60000
G1 X182.075 Y166.676 Z10.6
G1 Z10.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1835
M204 S8000
G1 X182.047 Y166.57 E.00364
G3 X184.014 Y163.86 I2.201 J-.471 E.12526
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X184.229 Y163.847 E.00715
G3 X182.108 Y166.796 I.02 J2.251 E.32905
G1 X182.091 Y166.734 E.00214
; COOLING_NODE: 6
M204 S250
G1 X182.458 Y166.573 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1835
M204 S5000
G1 X182.431 Y166.487 E.00276
G3 X184.056 Y164.25 I1.818 J-.389 E.0958
G1 X184.232 Y164.24 E.00545
G3 X182.552 Y166.857 I.017 J1.859 E.2457
G1 X182.477 Y166.63 E.00733
; COOLING_NODE: 6
; WIPE_START
G1 F9547.055
M204 S8000
G1 X182.431 Y166.487 E-.05691
G1 X182.39 Y166.133 E-.13566
G1 X182.418 Y165.777 E-.13579
G1 X182.514 Y165.433 E-.13569
G1 X182.68 Y165.102 E-.14084
G1 X182.912 Y164.808 E-.14212
G1 X182.938 Y164.786 E-.01299
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X181.311 Y165.298 Z10.6 F60000
G1 Z10.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1835
M204 S8000
G1 X181.321 Y165.262 E.00124
G3 X184.409 Y163.056 I2.93 J.838 E.13589
G3 X184.516 Y169.136 I-.16 J3.044 E.30345
G3 X181.259 Y165.519 I-.265 J-3.036 E.187
G1 X181.297 Y165.357 E.00552
; COOLING_NODE: 1
M204 S250
G1 X180.932 Y165.202 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1835
M204 S5000
G1 X181 Y164.981 E.0071
G3 X184.271 Y162.66 I3.252 J1.118 E.13158
G1 X184.43 Y162.665 E.00487
G3 X180.915 Y165.268 I-.177 J3.435 E.51838
G1 X180.917 Y165.26 E.00023
M204 S10000
G1 X181.687 Y165.431 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43181
G1 F1835
M204 S8000
G1 X181.695 Y165.403 E.00092
G3 X181.601 Y166.156 I2.555 J.703 E.50342
G1 X181.6 Y166.138 E.00059
G3 X181.605 Y165.957 I3.481 J-.011 E.00572
G3 X181.64 Y165.649 I2.645 J.149 E.00984
G1 X181.675 Y165.489 E.00518
; COOLING_NODE: 5
; WIPE_START
G1 F9257.119
G1 X181.695 Y165.403 E-.03384
G1 X181.781 Y165.139 E-.10529
G1 X181.884 Y164.908 E-.09625
G1 X182.019 Y164.67 E-.10407
G1 X182.157 Y164.475 E-.09066
G1 X182.477 Y164.131 E-.17854
G1 X182.695 Y163.955 E-.10638
G1 X182.794 Y163.89 E-.04497
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X182.279 Y156.275 Z10.6 F60000
G1 X182.102 Y153.648 Z10.6
G1 Z10.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1835
M204 S8000
G1 X182.102 Y152.852 E.0264
G1 X187.298 Y152.852 E.17236
G1 X187.298 Y153.648 E.0264
G1 X182.162 Y153.648 E.17037
; COOLING_NODE: 5
M204 S250
G1 X181.71 Y154.04 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1835
M204 S5000
G1 X181.71 Y152.46 E.04855
G1 X187.69 Y152.46 E.18375
G1 X187.69 Y154.04 E.04855
G1 X181.77 Y154.04 E.18191
M204 S10000
G1 X182.306 Y153.25 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1835
M204 S8000
G1 X187.094 Y153.25 E.15172
; CHANGE_LAYER
; Z_HEIGHT: 10.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.259
G1 X185.094 Y153.25 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 76/85
; update layer progress
M73 L76
M991 S0 P75 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 7
M204 S10000
G17
G3 Z10.6 I-.754 J-.955 P1  F60000
G1 X167.871 Y166.844 Z10.6
G1 Z10.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2294
M204 S8000
G1 X167.851 Y166.907 E.00219
G3 X165.512 Y163.86 I-2.102 J-.808 E.31668
G1 X165.718 Y163.848 E.00683
G3 X167.967 Y166.488 I.032 J2.251 E.13136
G1 X167.887 Y166.786 E.01022
; COOLING_NODE: 7
M204 S250
G1 X167.494 Y166.74 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2055
M204 S5000
G1 X167.485 Y166.766 E.00086
G3 X165.555 Y164.25 I-1.736 J-.667 E.24226
G1 X165.722 Y164.24 E.00517
G3 X167.581 Y166.422 I.027 J1.859 E.10054
G1 X167.51 Y166.682 E.00827
; COOLING_NODE: 7
; WIPE_START
G1 F9547.055
M204 S8000
G1 X167.485 Y166.766 E-.03346
M73 P89 R1
G1 X167.311 Y167.113 E-.14739
G1 X167.089 Y167.391 E-.13533
G1 X166.817 Y167.624 E-.13613
G1 X166.502 Y167.801 E-.13717
G1 X166.137 Y167.92 E-.14599
G1 X166.073 Y167.927 E-.02452
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X168.762 Y165.654 Z10.8 F60000
G1 Z10.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2294
M204 S8000
G1 X168.79 Y165.861 E.00694
G3 X165.777 Y163.052 I-3.038 J.238 E.48508
G1 X165.908 Y163.056 E.00434
G3 X168.753 Y165.57 I-.156 J3.043 E.13596
G1 X168.756 Y165.594 E.0008
; COOLING_NODE: 4
M204 S250
G1 X169.151 Y165.605 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2056
M204 S5000
G1 X169.181 Y165.831 E.007
G3 X165.781 Y162.66 I-3.429 J.269 E.50715
G1 X165.929 Y162.665 E.00457
G3 X169.14 Y165.502 I-.177 J3.435 E.14213
G1 X169.144 Y165.545 E.00132
M204 S10000
G1 X168.359 Y165.646 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.431806
G1 F2294
M204 S8000
G1 X168.391 Y165.893 E.00789
G3 X163.101 Y166.16 I-2.642 J.204 E.26822
G1 X163.101 Y166.142 E.00059
G3 X163.106 Y165.92 I4.256 J-.007 E.00704
G3 X168.349 Y165.587 I2.644 J.177 E.24189
; COOLING_NODE: 6
; WIPE_START
G1 F9257.222
G1 X168.391 Y165.893 E-.11739
G1 X168.399 Y166.147 E-.09653
G1 X168.359 Y166.565 E-.15951
G1 X168.31 Y166.786 E-.08611
G1 X168.22 Y167.059 E-.10939
G1 X168.116 Y167.294 E-.09767
G1 X167.994 Y167.508 E-.09341
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.614 Y167.074 Z10.8 F60000
G1 X182.088 Y166.706 Z10.8
G1 Z10.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2294
M204 S8000
G1 X182.056 Y166.606 E.00349
G3 X184.012 Y163.86 I2.194 J-.507 E.1264
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X184.218 Y163.848 E.00683
G3 X182.193 Y167.016 I.032 J2.251 E.32171
G1 X182.107 Y166.763 E.00885
; COOLING_NODE: 6
M204 S250
G1 X182.459 Y166.582 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2055
M204 S5000
G1 X182.438 Y166.518 E.00207
G3 X184.055 Y164.25 I1.812 J-.419 E.09672
G1 X184.222 Y164.24 E.00517
G3 X182.551 Y166.856 I.027 J1.859 E.2461
G1 X182.478 Y166.639 E.00705
; COOLING_NODE: 6
; WIPE_START
G1 F9547.055
M204 S8000
G1 X182.438 Y166.518 E-.04841
G1 X182.39 Y166.134 E-.14709
G1 X182.418 Y165.778 E-.13559
G1 X182.513 Y165.433 E-.13592
G1 X182.675 Y165.11 E-.13731
G1 X182.912 Y164.808 E-.14596
G1 X182.931 Y164.79 E-.00972
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X181.315 Y165.293 Z10.8 F60000
G1 Z10.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2294
M204 S8000
G1 X181.354 Y165.159 E.00461
G3 X184.277 Y163.052 I2.899 J.94 E.12791
G1 X184.408 Y163.056 E.00434
G3 X181.271 Y165.47 I-.156 J3.043 E.4922
G1 X181.301 Y165.351 E.00407
; COOLING_NODE: 1
M204 S250
G1 X180.937 Y165.192 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2056
M204 S5000
G1 X180.981 Y165.038 E.0049
G3 X184.281 Y162.66 I3.272 J1.061 E.13372
G1 X184.429 Y162.665 E.00457
G3 X180.888 Y165.387 I-.177 J3.435 E.51464
G1 X180.922 Y165.25 E.00434
M204 S10000
G1 X181.689 Y165.42 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.431807
G1 F2294
M204 S8000
G1 X181.69 Y165.414 E.0002
G3 X181.601 Y166.16 I2.56 J.683 E.50364
G1 X181.601 Y166.142 E.00059
G3 X181.606 Y165.92 I4.265 J-.007 E.00704
G3 X181.641 Y165.635 I2.644 J.177 E.00908
G1 X181.676 Y165.479 E.00507
; COOLING_NODE: 5
; WIPE_START
G1 F9257.205
G1 X181.69 Y165.414 E-.02522
G1 X181.776 Y165.149 E-.10602
G1 X181.883 Y164.908 E-.10009
G1 X182.003 Y164.695 E-.09272
G1 X182.162 Y164.467 E-.10592
G1 X182.337 Y164.266 E-.10098
G1 X182.512 Y164.1 E-.0918
G1 X182.734 Y163.926 E-.10707
G1 X182.801 Y163.884 E-.03017
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X176.565 Y159.484 Z10.8 F60000
G1 X168.292 Y153.648 Z10.8
G1 Z10.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2294
M204 S8000
G1 X162.702 Y153.648 E.18544
G1 X162.702 Y152.852 E.0264
G1 X164.718 Y152.852 E.06686
G1 X165.118 Y152.852 E.01327
G1 X165.518 Y152.852 E.01327
G1 X165.918 Y152.852 E.01327
G1 X166.318 Y152.852 E.01327
G1 X166.718 Y152.852 E.01327
G1 X167.118 Y152.852 E.01327
G1 X167.518 Y152.852 E.01327
G1 X167.918 Y152.852 E.01327
G1 X168.318 Y152.852 E.01327
G1 F1800
G1 X168.7 Y152.852 E.01269
; FEATURE: Overhang wall
G1 F3000
M204 S5000
G1 X181.3 Y152.852 E.41797
; FEATURE: Inner wall
G1 F1800
M204 S8000
G1 X181.683 Y152.852 E.01269
G1 F2294
G1 X182.083 Y152.852 E.01327
G1 X182.483 Y152.852 E.01327
G1 X182.883 Y152.852 E.01327
G1 X183.283 Y152.852 E.01327
G1 X183.683 Y152.852 E.01327
G1 X184.083 Y152.852 E.01327
G1 X184.483 Y152.852 E.01327
G1 X184.883 Y152.852 E.01327
G1 X185.283 Y152.852 E.01327
G1 X187.298 Y152.852 E.06686
G1 X187.298 Y153.648 E.0264
G1 X185.283 Y153.648 E.06686
G1 X184.883 Y153.648 E.01327
G1 X184.483 Y153.648 E.01327
G1 X184.083 Y153.648 E.01327
G1 X183.683 Y153.648 E.01327
G1 X183.283 Y153.648 E.01327
G1 X182.883 Y153.648 E.01327
G1 X182.483 Y153.648 E.01327
G1 X182.083 Y153.648 E.01327
G1 X181.683 Y153.648 E.01327
G1 F1800
G1 X181.3 Y153.648 E.01269
; FEATURE: Overhang wall
G1 F3000
M204 S5000
G1 X168.7 Y153.648 E.41797
; FEATURE: Inner wall
G1 F1800
M204 S8000
G1 X168.352 Y153.648 E.01153
; COOLING_NODE: 5
M204 S250
G1 X168.292 Y154.04 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2056
M204 S5000
G1 X162.31 Y154.04 E.18382
G1 X162.31 Y152.46 E.04855
G1 X164.731 Y152.46 E.07439
G1 X165.131 Y152.46 E.01229
G1 X165.531 Y152.46 E.01229
G1 X165.931 Y152.46 E.01229
G1 X166.331 Y152.46 E.01229
G1 X166.731 Y152.46 E.01229
G1 X167.131 Y152.46 E.01229
G1 X167.531 Y152.46 E.01229
G1 X167.931 Y152.46 E.01229
G1 X168.331 Y152.46 E.01229
G1 F1800
G1 X168.7 Y152.46 E.01134
; FEATURE: Overhang wall
; LINE_WIDTH: 0.45
G1 F3000
G1 X181.3 Y152.46 E.41797
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1800
G1 X181.669 Y152.46 E.01134
G1 F2056
G1 X182.069 Y152.46 E.01229
G1 X182.469 Y152.46 E.01229
G1 X182.869 Y152.46 E.01229
G1 X183.269 Y152.46 E.01229
G1 X183.669 Y152.46 E.01229
G1 X184.069 Y152.46 E.01229
G1 X184.469 Y152.46 E.01229
G1 X184.869 Y152.46 E.01229
G1 X185.269 Y152.46 E.01229
G1 X187.69 Y152.46 E.07439
G1 X187.69 Y154.04 E.04855
G1 X185.269 Y154.04 E.07439
G1 X184.869 Y154.04 E.01229
G1 X184.469 Y154.04 E.01229
G1 X184.069 Y154.04 E.01229
G1 X183.669 Y154.04 E.01229
G1 X183.269 Y154.04 E.01229
G1 X182.869 Y154.04 E.01229
G1 X182.469 Y154.04 E.01229
G1 X182.069 Y154.04 E.01229
G1 X181.669 Y154.04 E.01229
G1 F1800
G1 X181.3 Y154.04 E.01134
; FEATURE: Overhang wall
; LINE_WIDTH: 0.45
G1 F3000
G1 X168.7 Y154.04 E.41797
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1800
G1 X168.352 Y154.04 E.01068
; WIPE_START
M204 S8000
G1 X166.352 Y154.04 E-.76
; WIPE_END
G1 E-.04
M204 S10000
G1 X162.906 Y153.25 Z10.8 F60000
G1 Z10.4
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F2294
M204 S8000
G1 X187.094 Y153.25 E.76636
; CHANGE_LAYER
; Z_HEIGHT: 10.6
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F9259.259
G1 X185.094 Y153.25 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 77/85
; update layer progress
M73 L77
M991 S0 P76 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 7
M204 S10000
G17
G3 Z10.8 I-.754 J-.955 P1  F60000
G1 X167.871 Y166.845 Z10.8
G1 Z10.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2318
M204 S8000
G1 X167.852 Y166.907 E.00215
G3 X165.477 Y163.864 I-2.101 J-.809 E.3154
G1 X165.71 Y163.847 E.00774
G3 X167.968 Y166.491 I.041 J2.251 E.13174
G1 X167.886 Y166.787 E.01018
; COOLING_NODE: 7
M204 S250
G1 X167.494 Y166.741 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2105
M204 S5000
G1 X167.485 Y166.766 E.00083
G3 X165.524 Y164.254 I-1.735 J-.668 E.24123
G1 X165.717 Y164.24 E.00595
G3 X167.581 Y166.423 I.033 J1.859 E.10075
G1 X167.51 Y166.683 E.00828
; COOLING_NODE: 7
; WIPE_START
G1 F9547.055
M204 S8000
G1 X167.485 Y166.766 E-.03307
G1 X167.407 Y166.945 E-.07396
G1 X167.2 Y167.265 E-.14506
G1 X166.97 Y167.504 E-.12618
G1 X166.658 Y167.724 E-.14483
G1 X166.325 Y167.869 E-.13826
G1 X166.071 Y167.925 E-.09864
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X168.762 Y165.652 Z11 F60000
G1 Z10.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2318
M204 S8000
G1 X168.788 Y165.831 E.00601
G3 X165.786 Y163.053 I-3.035 J.268 E.48637
G1 X165.908 Y163.056 E.00402
G3 X168.754 Y165.57 I-.155 J3.043 E.13599
G1 X168.756 Y165.592 E.00073
; COOLING_NODE: 4
M204 S250
G1 X169.151 Y165.601 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2105
M204 S5000
M73 P90 R1
G1 X169.179 Y165.799 E.00615
G3 X165.79 Y162.66 I-3.426 J.301 E.50842
G1 X165.929 Y162.665 E.00427
G3 X169.14 Y165.502 I-.176 J3.435 E.14214
G1 X169.144 Y165.541 E.0012
M204 S10000
G1 X168.363 Y165.677 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.431803
G1 F2318
M204 S8000
G1 X168.378 Y165.771 E.00304
G3 X163.101 Y166.157 I-2.628 J.333 E.2727
G1 X163.1 Y166.137 E.00064
G3 X163.107 Y165.915 I4.242 J.014 E.00701
G3 X168.336 Y165.529 I2.643 J.189 E.23936
G1 X168.352 Y165.618 E.00286
; COOLING_NODE: 6
; WIPE_START
G1 F9257.285
G1 X168.378 Y165.771 E-.05925
G1 X168.398 Y166.147 E-.14283
G1 X168.359 Y166.565 E-.15955
G1 X168.31 Y166.786 E-.08608
G1 X168.22 Y167.059 E-.10937
G1 X168.116 Y167.294 E-.09769
G1 X167.978 Y167.534 E-.10505
G1 X167.978 Y167.534 E-.00018
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.598 Y167.096 Z11 F60000
G1 X182.094 Y166.723 Z11
G1 Z10.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2318
M204 S8000
G1 X182.057 Y166.605 E.00411
G3 X183.977 Y163.864 I2.194 J-.506 E.12515
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X184.21 Y163.847 E.00774
G3 X182.194 Y167.013 I.041 J2.251 E.32202
G1 X182.113 Y166.78 E.00819
; COOLING_NODE: 6
M204 S250
G1 X182.465 Y166.6 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2105
M204 S5000
G1 X182.405 Y166.326 E.00859
G3 X184.024 Y164.254 I1.845 J-.228 E.08977
G1 X184.217 Y164.24 E.00595
G3 X182.485 Y166.681 I.033 J1.859 E.252
G1 X182.479 Y166.658 E.00073
; COOLING_NODE: 6
; WIPE_START
G1 F9547.055
M204 S8000
G1 X182.405 Y166.326 E-.12905
G1 X182.397 Y165.938 E-.14751
G1 X182.453 Y165.618 E-.12369
G1 X182.592 Y165.256 E-.14737
G1 X182.784 Y164.954 E-.13581
G1 X182.923 Y164.808 E-.07657
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X181.319 Y165.279 Z11 F60000
G1 Z10.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2318
M204 S8000
G1 X181.354 Y165.159 E.00413
G3 X184.286 Y163.053 I2.898 J.94 E.12819
G1 X184.408 Y163.056 E.00402
G3 X181.271 Y165.469 I-.155 J3.043 E.49225
G1 X181.305 Y165.337 E.00453
; COOLING_NODE: 1
M204 S250
G1 X180.941 Y165.177 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2105
M204 S5000
G1 X180.982 Y165.038 E.00446
G3 X184.29 Y162.66 I3.271 J1.062 E.13399
G1 X184.429 Y162.665 E.00427
G3 X180.888 Y165.386 I-.176 J3.435 E.51468
G1 X180.926 Y165.235 E.00477
M204 S10000
G1 X181.692 Y165.414 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.431803
G1 F2318
M204 S8000
G3 X181.601 Y166.157 I2.558 J.69 E.50374
G1 X181.6 Y166.137 E.00064
G3 X181.607 Y165.915 I4.251 J.014 E.00701
G3 X181.677 Y165.472 I2.643 J.189 E.01423
; COOLING_NODE: 5
; WIPE_START
G1 F9257.29
G1 X181.776 Y165.149 E-.12852
G1 X181.884 Y164.907 E-.10084
G1 X182.016 Y164.675 E-.10151
G1 X182.158 Y164.474 E-.09349
G1 X182.334 Y164.269 E-.10259
G1 X182.511 Y164.1 E-.09297
G1 X182.733 Y163.926 E-.10721
G1 X182.807 Y163.881 E-.03287
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X185.874 Y156.892 Z11 F60000
G1 X187.298 Y153.648 Z11
G1 Z10.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2318
M204 S8000
G1 X162.702 Y153.648 E.81589
G1 X162.702 Y152.852 E.0264
G1 X187.298 Y152.852 E.81589
G1 X187.298 Y153.588 E.02441
; COOLING_NODE: 5
M204 S250
G1 X187.69 Y154.04 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2105
M204 S5000
G1 X162.31 Y154.04 E.77986
G1 X162.31 Y152.46 E.04855
G1 X187.69 Y152.46 E.77986
G1 X187.69 Y153.98 E.04671
M204 S10000
G1 X187.094 Y153.25 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F2318
M204 S8000
G1 X162.906 Y153.25 E.76636
; CHANGE_LAYER
; Z_HEIGHT: 10.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.259
G1 X164.906 Y153.25 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 78/85
; update layer progress
M73 L78
M991 S0 P77 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 7
M204 S10000
G17
G3 Z11 I-1.189 J.259 P1  F60000
G1 X167.87 Y166.847 Z11
G1 Z10.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2316
M204 S8000
G1 X167.85 Y166.907 E.0021
G3 X165.513 Y163.86 I-2.101 J-.809 E.31669
G1 X165.729 Y163.847 E.00717
G3 X167.966 Y166.491 I.019 J2.251 E.13103
G1 X167.885 Y166.789 E.01026
; COOLING_NODE: 7
M204 S250
G1 X167.493 Y166.743 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2155
M204 S5000
G1 X167.484 Y166.766 E.00077
G3 X165.555 Y164.25 I-1.735 J-.667 E.24226
G1 X165.733 Y164.24 E.00547
G3 X167.58 Y166.423 I.016 J1.859 E.10023
G1 X167.509 Y166.685 E.00834
; COOLING_NODE: 7
; WIPE_START
G1 F9547.055
M204 S8000
G1 X167.484 Y166.766 E-.03225
G1 X167.311 Y167.112 E-.14714
G1 X167.089 Y167.392 E-.1356
G1 X166.817 Y167.624 E-.13572
G1 X166.478 Y167.812 E-.14759
G1 X166.137 Y167.92 E-.13571
G1 X166.069 Y167.927 E-.026
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X168.761 Y165.646 Z11.2 F60000
G1 Z10.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2316
M204 S8000
G1 X168.792 Y165.89 E.00815
G3 X165.796 Y163.053 I-3.04 J.21 E.48478
G1 X165.907 Y163.056 E.0037
G3 X168.753 Y165.571 I-.155 J3.043 E.13598
G1 X168.754 Y165.586 E.00052
; COOLING_NODE: 4
M204 S250
G1 X169.149 Y165.598 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2156
M204 S5000
G1 X169.183 Y165.86 E.00812
G3 X165.8 Y162.66 I-3.431 J.239 E.50685
G1 X165.929 Y162.665 E.00397
G3 X169.139 Y165.503 I-.177 J3.435 E.14212
G1 X169.143 Y165.539 E.00112
M204 S10000
G1 X168.363 Y165.676 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.431807
G1 F2316
M204 S8000
M73 P91 R1
G1 X168.379 Y165.777 E.00323
G3 X163.102 Y166.196 I-2.629 J.333 E.27162
G1 X163.101 Y166.138 E.00185
G1 X163.101 Y166.053 E.00268
G3 X168.33 Y165.504 I2.649 J.057 E.24263
G1 X168.352 Y165.617 E.00365
; COOLING_NODE: 6
; WIPE_START
G1 F9257.197
G1 X168.379 Y165.777 E-.06148
G1 X168.4 Y166.061 E-.10816
G1 X168.359 Y166.565 E-.1921
G1 X168.224 Y167.05 E-.19149
G1 X168.116 Y167.294 E-.10147
G1 X167.98 Y167.531 E-.10391
G1 X167.978 Y167.534 E-.00139
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.597 Y167.092 Z11.2 F60000
G1 X182.092 Y166.715 Z11.2
G1 Z10.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2316
M204 S8000
G1 X182.051 Y166.589 E.00441
G3 X184.013 Y163.86 I2.198 J-.49 E.12587
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X184.229 Y163.847 E.00717
G3 X182.192 Y167.015 I.019 J2.251 E.3213
G1 X182.111 Y166.772 E.00849
; COOLING_NODE: 6
M204 S250
G1 X182.463 Y166.593 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2155
M204 S5000
G1 X182.434 Y166.503 E.00288
G3 X184.055 Y164.25 I1.815 J-.404 E.09629
G1 X184.233 Y164.24 E.00547
G3 X182.551 Y166.856 I.016 J1.859 E.24576
G1 X182.482 Y166.65 E.00667
; COOLING_NODE: 6
; WIPE_START
G1 F9547.055
M204 S8000
G1 X182.434 Y166.503 E-.05845
G1 X182.39 Y166.133 E-.14168
G1 X182.418 Y165.777 E-.13594
G1 X182.513 Y165.433 E-.13549
G1 X182.593 Y165.255 E-.07403
G1 X182.804 Y164.93 E-.14746
G1 X182.926 Y164.803 E-.06696
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X181.322 Y165.266 Z11.2 F60000
G1 Z10.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2316
M204 S8000
G1 X181.352 Y165.161 E.0036
G3 X184.296 Y163.053 I2.899 J.938 E.12861
G1 X184.407 Y163.056 E.0037
G3 X181.282 Y165.415 I-.155 J3.043 E.49408
G1 X181.306 Y165.324 E.00314
; COOLING_NODE: 1
M204 S250
G1 X180.944 Y165.161 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2156
M204 S5000
G1 X180.98 Y165.039 E.00392
G3 X184.3 Y162.66 I3.272 J1.061 E.13435
G1 X184.429 Y162.665 E.00397
G3 X180.9 Y165.327 I-.177 J3.435 E.51651
G1 X180.929 Y165.219 E.00343
M204 S10000
G1 X181.696 Y165.395 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.431807
G1 F2316
M204 S8000
G1 X181.702 Y165.385 E.00036
G3 X181.602 Y166.196 I2.548 J.725 E.50145
G1 X181.601 Y166.139 E.00181
G1 X181.601 Y166.053 E.00272
G3 X181.643 Y165.64 I2.648 J.057 E.01316
G1 X181.683 Y165.454 E.00606
; COOLING_NODE: 5
; WIPE_START
G1 F9257.203
G1 X181.702 Y165.385 E-.02697
G1 X181.78 Y165.139 E-.09798
G1 X181.889 Y164.897 E-.10099
G1 X182.022 Y164.665 E-.10162
G1 X182.183 Y164.443 E-.10423
G1 X182.35 Y164.253 E-.09599
G1 X182.511 Y164.1 E-.08462
G1 X182.734 Y163.926 E-.10721
G1 X182.824 Y163.87 E-.04038
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X185.884 Y156.878 Z11.2 F60000
G1 X187.298 Y153.648 Z11.2
G1 Z10.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2316
M204 S8000
G1 X162.702 Y153.648 E.81589
G1 X162.702 Y152.852 E.0264
G1 X187.298 Y152.852 E.81589
G1 X187.298 Y153.588 E.02441
; COOLING_NODE: 5
M204 S250
G1 X187.69 Y154.04 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2156
M204 S5000
G1 X162.31 Y154.04 E.77986
G1 X162.31 Y152.46 E.04855
G1 X187.69 Y152.46 E.77986
G1 X187.69 Y153.98 E.04671
M204 S10000
G1 X187.094 Y153.25 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F2316
M204 S8000
G1 X162.906 Y153.25 E.76636
; CHANGE_LAYER
; Z_HEIGHT: 11
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.259
G1 X164.906 Y153.25 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 79/85
; update layer progress
M73 L79
M991 S0 P78 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 7
M204 S10000
G17
G3 Z11.2 I-1.189 J.259 P1  F60000
G1 X167.868 Y166.85 Z11.2
G1 Z11
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2316
M204 S8000
G1 X167.848 Y166.913 E.00221
G3 X165.513 Y163.86 I-2.099 J-.815 E.31641
G1 X165.718 Y163.848 E.00682
G3 X167.966 Y166.491 I.031 J2.251 E.13143
G1 X167.884 Y166.792 E.01033
; COOLING_NODE: 7
M204 S250
G1 X167.492 Y166.745 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2201
M204 S5000
G1 X167.483 Y166.771 E.00086
G3 X165.555 Y164.25 I-1.733 J-.672 E.24207
G1 X165.723 Y164.24 E.00516
G3 X167.58 Y166.423 I.027 J1.859 E.10056
G1 X167.508 Y166.687 E.0084
; COOLING_NODE: 7
; WIPE_START
G1 F9547.055
M204 S8000
G1 X167.483 Y166.771 E-.03337
G1 X167.311 Y167.112 E-.14536
G1 X167.089 Y167.391 E-.13533
G1 X166.818 Y167.623 E-.1357
G1 X166.507 Y167.799 E-.13585
G1 X166.168 Y167.913 E-.13587
G1 X166.067 Y167.925 E-.03853
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X168.762 Y165.657 Z11.4 F60000
G1 Z11
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2316
M204 S8000
G1 X168.775 Y165.728 E.00239
G3 X165.802 Y163.053 I-3.025 J.371 E.4904
G1 X165.963 Y163.06 E.00533
G3 X168.72 Y165.414 I-.212 J3.04 E.1288
G1 X168.752 Y165.598 E.0062
; COOLING_NODE: 4
M204 S250
G1 X169.148 Y165.589 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2201
M204 S5000
G1 X169.164 Y165.681 E.00285
G3 X165.809 Y162.661 I-3.414 J.419 E.51272
G1 X165.99 Y162.668 E.00557
G3 X169.101 Y165.326 I-.24 J3.431 E.13465
G1 X169.138 Y165.53 E.00638
M204 S10000
G1 X168.362 Y165.668 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.431801
G1 F2316
M204 S8000
G1 X168.378 Y165.766 E.00317
G3 X163.101 Y166.16 I-2.629 J.33 E.27227
G1 X163.101 Y166.141 E.0006
G3 X163.106 Y165.915 I4.344 J-.002 E.00715
G3 X168.332 Y165.504 I2.643 J.181 E.23906
G1 X168.351 Y165.609 E.00339
; COOLING_NODE: 6
; WIPE_START
G1 F9257.348
G1 X168.378 Y165.766 E-.06076
G1 X168.399 Y166.146 E-.14449
G1 X168.36 Y166.56 E-.158
G1 X168.301 Y166.818 E-.10059
G1 X168.217 Y167.067 E-.0999
G1 X168.115 Y167.295 E-.09474
G1 X167.983 Y167.527 E-.10151
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.602 Y167.08 Z11.4 F60000
G1 X182.082 Y166.7 Z11.4
G1 Z11
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2316
M204 S8000
G1 X182.048 Y166.571 E.00445
G3 X184.013 Y163.86 I2.201 J-.472 E.12522
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X184.218 Y163.848 E.00682
G3 X182.109 Y166.796 I.031 J2.251 E.32943
G1 X182.098 Y166.758 E.0013
; COOLING_NODE: 6
M204 S250
M73 P92 R1
G1 X182.466 Y166.597 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2201
M204 S5000
G1 X182.432 Y166.487 E.00353
G3 X184.055 Y164.25 I1.818 J-.389 E.09577
G1 X184.223 Y164.24 E.00516
G3 X182.552 Y166.856 I.027 J1.859 E.24604
G1 X182.485 Y166.654 E.00653
; COOLING_NODE: 6
; WIPE_START
G1 F9547.055
M204 S8000
G1 X182.432 Y166.487 E-.0665
G1 X182.39 Y166.134 E-.13536
G1 X182.418 Y165.776 E-.13616
G1 X182.515 Y165.428 E-.13727
G1 X182.69 Y165.087 E-.1457
G1 X182.804 Y164.93 E-.07365
G1 X182.924 Y164.807 E-.06537
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X181.325 Y165.252 Z11.4 F60000
G1 Z11
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2316
M204 S8000
G1 X181.352 Y165.159 E.00322
G3 X184.302 Y163.053 I2.898 J.941 E.12877
G1 X184.463 Y163.06 E.00533
G3 X181.282 Y165.413 I-.212 J3.04 E.49225
G1 X181.31 Y165.31 E.00355
; COOLING_NODE: 1
M204 S250
G1 X180.948 Y165.147 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2201
M204 S5000
G1 X180.979 Y165.037 E.00351
G3 X184.309 Y162.661 I3.271 J1.062 E.13463
G1 X184.49 Y162.668 E.00557
G3 X180.899 Y165.327 I-.24 J3.431 E.51459
G1 X180.932 Y165.205 E.00387
M204 S10000
G1 X181.699 Y165.382 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.431804
G1 F2316
M204 S8000
G1 X181.698 Y165.382 E.00003
G3 X181.601 Y166.16 I2.551 J.715 E.50259
G1 X181.601 Y166.141 E.0006
G3 X181.606 Y165.915 I4.335 J-.002 E.00715
G3 X181.64 Y165.64 I2.643 J.182 E.0088
G1 X181.686 Y165.44 E.00649
; COOLING_NODE: 5
; WIPE_START
G1 F9257.274
G1 X181.698 Y165.382 E-.02282
G1 X181.776 Y165.15 E-.09285
G1 X181.885 Y164.905 E-.10169
G1 X182.022 Y164.666 E-.10498
G1 X182.182 Y164.443 E-.10405
G1 X182.346 Y164.256 E-.09447
G1 X182.539 Y164.076 E-.10045
G1 X182.757 Y163.911 E-.10376
G1 X182.835 Y163.863 E-.03492
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X185.891 Y156.869 Z11.4 F60000
G1 X187.298 Y153.648 Z11.4
G1 Z11
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2316
M204 S8000
G1 X162.702 Y153.648 E.81589
G1 X162.702 Y152.852 E.0264
G1 X187.298 Y152.852 E.81589
G1 X187.298 Y153.588 E.02441
; COOLING_NODE: 5
M204 S250
G1 X187.69 Y154.04 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2201
M204 S5000
G1 X162.31 Y154.04 E.77986
G1 X162.31 Y152.46 E.04855
G1 X187.69 Y152.46 E.77986
G1 X187.69 Y153.98 E.04671
M204 S10000
G1 X187.094 Y153.25 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F2316
M204 S8000
G1 X162.906 Y153.25 E.76636
; CHANGE_LAYER
; Z_HEIGHT: 11.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.259
G1 X164.906 Y153.25 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 80/85
; update layer progress
M73 L80
M991 S0 P79 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 7
M204 S10000
G17
G3 Z11.4 I-1.189 J.258 P1  F60000
G1 X167.861 Y166.862 Z11.4
G1 Z11.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2316
M204 S8000
G1 X167.824 Y166.971 E.0038
G3 X165.514 Y163.859 I-2.076 J-.872 E.31449
G1 X165.741 Y163.847 E.00752
G3 X167.959 Y166.529 I.008 J2.252 E.13192
G1 X167.878 Y166.804 E.00953
; COOLING_NODE: 7
M204 S250
G1 X167.487 Y166.748 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2243
M204 S5000
G1 X167.463 Y166.82 E.00232
G3 X165.556 Y164.25 I-1.714 J-.721 E.24052
G1 X165.743 Y164.24 E.00577
G3 X167.574 Y166.454 I.006 J1.859 E.10089
G1 X167.504 Y166.691 E.00759
; COOLING_NODE: 7
; WIPE_START
G1 F9547.055
M204 S8000
G1 X167.463 Y166.82 E-.05145
G1 X167.293 Y167.139 E-.13757
G1 X167.065 Y167.415 E-.13589
G1 X166.79 Y167.642 E-.13568
G1 X166.623 Y167.743 E-.07381
G1 X166.293 Y167.879 E-.13573
G1 X166.061 Y167.925 E-.08988
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X168.764 Y165.656 Z11.6 F60000
G1 Z11.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2316
M204 S8000
G1 X168.768 Y165.678 E.00075
G3 X165.756 Y163.052 I-3.018 J.421 E.49054
G1 X165.909 Y163.056 E.00509
G3 X168.707 Y165.362 I-.159 J3.043 E.12881
G1 X168.753 Y165.597 E.00794
; COOLING_NODE: 4
M204 S250
G1 X169.149 Y165.581 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2243
M204 S5000
G1 X169.157 Y165.622 E.00127
G3 X165.758 Y162.66 I-3.406 J.478 E.51293
G1 X165.93 Y162.665 E.00529
G3 X169.088 Y165.267 I-.179 J3.435 E.13468
G1 X169.137 Y165.522 E.00799
M204 S10000
G1 X168.357 Y165.682 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.431801
G1 F2316
M204 S8000
G1 X168.383 Y165.819 E.00442
G3 X163.1 Y166.11 I-2.634 J.288 E.27281
G1 X163.1 Y166.1 E.00032
G3 X163.11 Y165.873 I8.222 J.271 E.0072
G3 X168.281 Y165.326 I2.639 J.234 E.2312
G1 X168.345 Y165.623 E.00963
; COOLING_NODE: 6
; WIPE_START
G1 F9257.344
G1 X168.383 Y165.819 E-.07574
G1 X168.395 Y166.242 E-.1608
G1 X168.35 Y166.615 E-.14293
G1 X168.287 Y166.865 E-.09788
G1 X168.19 Y167.133 E-.10844
G1 X167.973 Y167.537 E-.1742
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.591 Y167.081 Z11.6 F60000
G1 X182.082 Y166.693 Z11.6
G1 Z11.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2316
M204 S8000
G1 X182.009 Y166.332 E.0122
G3 X184.014 Y163.859 I2.239 J-.233 E.1173
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X184.241 Y163.847 E.00752
G3 X182.095 Y166.757 I.008 J2.252 E.33007
G1 X182.094 Y166.751 E.00018
; COOLING_NODE: 6
M204 S250
G1 X182.465 Y166.615 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2243
M204 S5000
G1 X182.4 Y166.293 E.0101
G3 X184.056 Y164.25 I1.849 J-.194 E.08976
G1 X184.243 Y164.24 E.00577
G3 X182.481 Y166.673 I.006 J1.859 E.25147
; COOLING_NODE: 6
; WIPE_START
G1 F9547.055
M204 S8000
G1 X182.4 Y166.293 E-.14759
G1 X182.4 Y165.906 E-.14701
G1 X182.471 Y165.555 E-.13617
G1 X182.62 Y165.204 E-.14481
G1 X182.805 Y164.929 E-.12609
G1 X182.913 Y164.82 E-.05833
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X181.329 Y165.243 Z11.6 F60000
G1 Z11.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2316
M204 S8000
M73 P93 R1
G1 X181.386 Y165.058 E.00642
G3 X184.256 Y163.052 I2.864 J1.041 E.12371
G1 X184.409 Y163.056 E.00509
G3 X181.293 Y165.363 I-.159 J3.043 E.49575
G1 X181.312 Y165.301 E.00214
; COOLING_NODE: 1
M204 S250
G1 X180.955 Y165.129 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2243
M204 S5000
G1 X181.019 Y164.924 E.00658
G3 X184.258 Y162.66 I3.232 J1.175 E.12936
G1 X184.43 Y162.665 E.00529
G3 X180.914 Y165.268 I-.179 J3.435 E.51833
G1 X180.938 Y165.186 E.00261
M204 S10000
G1 X181.702 Y165.38 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.431802
G1 F2316
M204 S8000
G1 X181.716 Y165.326 E.00176
G3 X181.6 Y166.11 I2.533 J.776 E.50231
G1 X181.6 Y166.09 E.00064
G3 X181.613 Y165.834 I4.899 J.128 E.00811
G3 X181.654 Y165.569 I2.636 J.268 E.0085
G1 X181.687 Y165.438 E.0043
; COOLING_NODE: 5
; WIPE_START
G1 F9257.313
G1 X181.716 Y165.326 E-.04395
G1 X181.81 Y165.065 E-.10551
G1 X181.922 Y164.833 E-.0976
G1 X182.192 Y164.43 E-.18451
G1 X182.376 Y164.226 E-.10418
G1 X182.583 Y164.04 E-.10573
G1 X182.843 Y163.868 E-.11851
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X185.893 Y156.871 Z11.6 F60000
G1 X187.298 Y153.648 Z11.6
G1 Z11.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2316
M204 S8000
G1 X162.702 Y153.648 E.81589
G1 X162.702 Y152.852 E.0264
G1 X187.298 Y152.852 E.81589
G1 X187.298 Y153.588 E.02441
; COOLING_NODE: 5
M204 S250
G1 X187.69 Y154.04 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2243
M204 S5000
G1 X162.31 Y154.04 E.77986
G1 X162.31 Y152.46 E.04855
G1 X187.69 Y152.46 E.77986
G1 X187.69 Y153.98 E.04671
M204 S10000
G1 X187.094 Y153.25 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F2316
M204 S8000
G1 X162.906 Y153.25 E.76636
; CHANGE_LAYER
; Z_HEIGHT: 11.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.259
G1 X164.906 Y153.25 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 81/85
; update layer progress
M73 L81
M991 S0 P80 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 7
M204 S10000
G17
G3 Z11.6 I-1.19 J.256 P1  F60000
G1 X167.847 Y166.898 Z11.6
G1 Z11.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2319
M204 S8000
G1 X167.736 Y167.157 E.00935
G3 X165.513 Y163.86 I-1.987 J-1.058 E.30761
G1 X165.73 Y163.847 E.00719
G3 X167.902 Y166.757 I.019 J2.252 E.14009
G1 X167.869 Y166.842 E.00303
; COOLING_NODE: 7
M204 S250
G1 X167.487 Y166.749 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2283
M204 S5000
G1 X167.467 Y166.811 E.00198
G3 X165.555 Y164.25 I-1.718 J-.711 E.24082
G1 X165.733 Y164.24 E.00548
G3 X167.574 Y166.454 I.016 J1.859 E.1012
G1 X167.504 Y166.692 E.00761
; COOLING_NODE: 7
; WIPE_START
G1 F9547.055
M204 S8000
G1 X167.467 Y166.811 E-.0473
G1 X167.293 Y167.139 E-.14139
G1 X167.065 Y167.415 E-.13588
G1 X166.921 Y167.545 E-.07367
G1 X166.623 Y167.743 E-.13615
G1 X166.264 Y167.888 E-.14717
G1 X166.061 Y167.926 E-.07844
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X168.763 Y165.652 Z11.8 F60000
G1 Z11.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2319
M204 S8000
G1 X168.769 Y165.676 E.00083
G3 X165.764 Y163.052 I-3.018 J.424 E.49087
G1 X165.909 Y163.056 E.00478
G3 X168.708 Y165.362 I-.157 J3.043 E.12885
G1 X168.752 Y165.593 E.00779
; COOLING_NODE: 4
M204 S250
G1 X169.148 Y165.577 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2283
M204 S5000
G1 X169.158 Y165.621 E.0014
G3 X165.767 Y162.66 I-3.406 J.478 E.51322
G1 X165.93 Y162.665 E.00499
G3 X169.089 Y165.267 I-.178 J3.435 E.13471
G1 X169.137 Y165.518 E.00784
M204 S10000
G1 X168.357 Y165.631 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.431807
G1 F2319
M204 S8000
G1 X168.385 Y165.836 E.00657
G3 X163.1 Y166.108 I-2.636 J.267 E.27206
G1 X163.1 Y166.092 E.00054
G3 X163.11 Y165.874 I4.141 J.08 E.00692
G3 X168.345 Y165.572 I2.639 J.23 E.23952
; COOLING_NODE: 6
; WIPE_START
G1 F9257.208
G1 X168.385 Y165.836 E-.10158
G1 X168.395 Y166.238 E-.15274
G1 X168.342 Y166.651 E-.15825
G1 X168.282 Y166.883 E-.09083
G1 X168.188 Y167.137 E-.10315
G1 X168.09 Y167.344 E-.08676
G1 X168 Y167.494 E-.06668
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.621 Y167.073 Z11.8 F60000
G1 X182.085 Y166.716 Z11.8
G1 Z11.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2319
M204 S8000
G1 X182.038 Y166.529 E.00638
G3 X184.013 Y163.86 I2.21 J-.431 E.12387
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X184.23 Y163.847 E.00719
G3 X182.1 Y166.774 I.019 J2.252 E.32986
; COOLING_NODE: 6
M204 S250
G1 X182.466 Y166.621 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2283
M204 S5000
G1 X182.397 Y166.263 E.01119
G3 X184.055 Y164.25 I1.852 J-.164 E.08883
G1 X184.233 Y164.24 E.00548
G3 X182.482 Y166.678 I.016 J1.859 E.25161
; COOLING_NODE: 6
; WIPE_START
G1 F9547.055
M204 S8000
G1 X182.397 Y166.263 E-.16101
G1 X182.397 Y165.937 E-.1242
G1 X182.471 Y165.556 E-.14726
G1 X182.607 Y165.227 E-.1355
G1 X182.814 Y164.917 E-.14145
G1 X182.909 Y164.823 E-.05058
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X181.332 Y165.23 Z11.8 F60000
G1 Z11.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2319
M204 S8000
G1 X181.387 Y165.059 E.00599
G3 X184.264 Y163.052 I2.864 J1.041 E.12398
G1 X184.409 Y163.056 E.00478
G3 X181.308 Y165.31 I-.157 J3.043 E.49762
G1 X181.315 Y165.288 E.00075
; COOLING_NODE: 1
M204 S250
M73 P93 R0
G1 X180.958 Y165.112 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2283
M204 S5000
G1 X181.019 Y164.924 E.00608
G3 X184.267 Y162.66 I3.232 J1.175 E.12963
G1 X184.43 Y162.665 E.00499
G3 X180.93 Y165.209 I-.178 J3.435 E.52021
G1 X180.941 Y165.17 E.00126
M204 S10000
G1 X181.706 Y165.36 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.431807
G1 F2319
M204 S8000
M73 P94 R0
G1 X181.714 Y165.336 E.00078
G3 X181.6 Y166.108 I2.536 J.768 E.5027
G1 X181.6 Y166.092 E.00054
G3 X181.61 Y165.874 I4.177 J.081 E.00692
G3 X181.651 Y165.585 I2.639 J.231 E.00924
G1 X181.692 Y165.418 E.00544
; COOLING_NODE: 5
; WIPE_START
G1 F9257.197
G1 X181.714 Y165.336 E-.0322
G1 X181.805 Y165.078 E-.10411
G1 X181.909 Y164.857 E-.093
G1 X182.053 Y164.618 E-.10594
G1 X182.211 Y164.408 E-.09973
G1 X182.376 Y164.226 E-.09348
G1 X182.582 Y164.041 E-.10529
G1 X182.858 Y163.856 E-.12625
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X185.902 Y156.857 Z11.8 F60000
G1 X187.298 Y153.648 Z11.8
G1 Z11.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2319
M204 S8000
G1 X162.702 Y153.648 E.81589
G1 X162.702 Y152.852 E.0264
G1 X187.298 Y152.852 E.81589
G1 X187.298 Y153.588 E.02441
; COOLING_NODE: 5
M204 S250
G1 X187.69 Y154.04 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2283
M204 S5000
G1 X162.31 Y154.04 E.77986
G1 X162.31 Y152.46 E.04855
G1 X187.69 Y152.46 E.77986
G1 X187.69 Y153.98 E.04671
M204 S10000
G1 X187.094 Y153.25 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F2319
M204 S8000
G1 X162.906 Y153.25 E.76636
; CHANGE_LAYER
; Z_HEIGHT: 11.6
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F9259.259
G1 X164.906 Y153.25 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 82/85
; update layer progress
M73 L82
M991 S0 P81 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 7
M204 S10000
G17
G3 Z11.8 I-1.189 J.259 P1  F60000
G1 X167.868 Y166.853 Z11.8
G1 Z11.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2316
M204 S8000
G1 X167.851 Y166.906 E.00184
G3 X165.512 Y163.86 I-2.101 J-.808 E.31664
G1 X165.718 Y163.848 E.00685
G3 X167.966 Y166.492 I.031 J2.251 E.13144
G1 X167.884 Y166.796 E.01045
; COOLING_NODE: 7
M204 S250
G1 X167.492 Y166.749 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2316
M204 S5000
G1 X167.485 Y166.766 E.00056
G3 X165.555 Y164.25 I-1.735 J-.667 E.24222
G1 X165.723 Y164.24 E.00518
G3 X167.58 Y166.423 I.027 J1.859 E.10056
G1 X167.507 Y166.691 E.00852
; COOLING_NODE: 7
; WIPE_START
G1 F9547.055
M204 S8000
G1 X167.485 Y166.766 E-.02972
G1 X167.328 Y167.085 E-.13532
G1 X167.089 Y167.391 E-.14748
G1 X166.817 Y167.624 E-.13609
G1 X166.502 Y167.802 E-.13751
G1 X166.137 Y167.92 E-.14556
G1 X166.063 Y167.928 E-.02832
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X168.763 Y165.647 Z12 F60000
G1 Z11.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2316
M204 S8000
G1 X168.765 Y165.676 E.00096
G3 X166.173 Y169.118 I-3.018 J.424 E.15874
G3 X165.908 Y163.056 I-.42 J-3.018 E.3367
G3 X168.71 Y165.386 I-.161 J3.044 E.12956
G1 X168.751 Y165.589 E.00684
; COOLING_NODE: 4
M204 S250
G1 X169.147 Y165.584 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2316
M204 S5000
G1 X169.176 Y165.801 E.00671
G3 X166.083 Y169.524 I-3.427 J.299 E.16496
G3 X165.93 Y162.665 I-.332 J-3.424 E.34775
G3 X169.126 Y165.444 I-.181 J3.435 E.14018
G1 X169.138 Y165.525 E.00253
M204 S10000
G1 X168.359 Y165.651 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43181
G1 F2316
M204 S8000
G1 X168.381 Y165.797 E.00466
G3 X163.101 Y166.159 I-2.631 J.315 E.27223
G1 X163.1 Y166.14 E.00059
G1 X163.101 Y166.1 E.00128
G3 X168.34 Y165.555 I2.649 J.011 E.24567
G1 X168.347 Y165.592 E.00118
; COOLING_NODE: 6
; WIPE_START
G1 F9257.134
G1 X168.381 Y165.797 E-.07872
G1 X168.4 Y166.06 E-.10022
G1 X168.392 Y166.304 E-.093
G1 X168.358 Y166.571 E-.10222
G1 X168.221 Y167.057 E-.19202
G1 X168.125 Y167.274 E-.08993
G1 X167.992 Y167.512 E-.10378
G1 X167.992 Y167.513 E-.00011
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.613 Y167.092 Z12 F60000
G1 X182.1 Y166.734 Z12
G1 Z11.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2316
M204 S8000
G1 X182.048 Y166.57 E.00571
G3 X184.012 Y163.86 I2.201 J-.471 E.12517
G1 X184.218 Y163.848 E.00685
G3 X182.19 Y167.009 I.031 J2.251 E.32188
G1 X182.119 Y166.791 E.0076
; COOLING_NODE: 6
M204 S250
G1 X182.471 Y166.614 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2316
M204 S5000
G1 X182.432 Y166.487 E.00408
G3 X184.055 Y164.25 I1.818 J-.388 E.09574
G1 X184.223 Y164.24 E.00518
G3 X182.55 Y166.851 I.027 J1.859 E.24621
G1 X182.49 Y166.671 E.00584
; COOLING_NODE: 6
; WIPE_START
G1 F9547.055
M204 S8000
G1 X182.432 Y166.487 E-.0733
G1 X182.39 Y166.133 E-.1352
G1 X182.418 Y165.776 E-.13609
G1 X182.515 Y165.428 E-.13741
G1 X182.69 Y165.087 E-.14564
G1 X182.804 Y164.93 E-.0737
G1 X182.912 Y164.82 E-.05868
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X181.338 Y165.215 Z12 F60000
G1 Z11.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2316
M204 S8000
G1 X181.389 Y165.058 E.00548
G3 X184.274 Y163.052 I2.864 J1.042 E.12423
G1 X184.408 Y163.056 E.00447
G3 X181.295 Y165.363 I-.156 J3.043 E.49583
G1 X181.321 Y165.273 E.00311
; COOLING_NODE: 1
M204 S250
G1 X180.956 Y165.11 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2316
M204 S5000
G1 X180.961 Y165.095 E.0005
G3 X184.43 Y162.665 I3.29 J1.005 E.14018
G3 X184.583 Y169.524 I-.181 J3.435 E.31624
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G3 X180.874 Y165.444 I-.332 J-3.424 E.19651
G1 X180.942 Y165.169 E.00871
M204 S10000
G1 X181.7 Y165.382 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.431808
G1 F2316
M204 S8000
G3 X181.601 Y166.159 I2.55 J.721 E.50268
G1 X181.6 Y166.14 E.00059
G3 X181.604 Y165.957 I3.507 J-.018 E.0058
G3 X181.685 Y165.44 I2.646 J.146 E.01661
; COOLING_NODE: 5
; WIPE_START
G1 F9257.166
G1 X181.776 Y165.15 E-.1158
G1 X181.885 Y164.905 E-.10177
G1 X182.022 Y164.665 E-.10491
G1 X182.182 Y164.443 E-.10407
G1 X182.48 Y164.129 E-.16464
G1 X182.777 Y163.897 E-.14288
G1 X182.835 Y163.862 E-.02593
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X185.891 Y156.868 Z12 F60000
G1 X187.298 Y153.648 Z12
G1 Z11.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2316
M204 S8000
G1 X162.702 Y153.648 E.81589
M73 P95 R0
G1 X162.702 Y152.852 E.0264
G1 X187.298 Y152.852 E.81589
G1 X187.298 Y153.588 E.02441
; COOLING_NODE: 5
M204 S250
G1 X187.69 Y154.04 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2316
M204 S5000
G1 X162.31 Y154.04 E.77986
G1 X162.31 Y152.46 E.04855
G1 X187.69 Y152.46 E.77986
G1 X187.69 Y153.98 E.04671
M204 S10000
G1 X187.094 Y153.25 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F2316
M204 S8000
G1 X162.906 Y153.25 E.76636
; CHANGE_LAYER
; Z_HEIGHT: 11.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.259
G1 X164.906 Y153.25 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 83/85
; update layer progress
M73 L83
M991 S0 P82 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 7
M204 S10000
G17
G3 Z12 I-1.19 J.257 P1  F60000
G1 X167.85 Y166.889 Z12
G1 Z11.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2319
M204 S8000
G1 X167.735 Y167.157 E.00967
G3 X165.515 Y163.859 I-1.987 J-1.059 E.30758
G1 X165.741 Y163.847 E.00754
G3 X167.901 Y166.757 I.007 J2.251 E.1397
G1 X167.872 Y166.833 E.00272
; COOLING_NODE: 7
M204 S250
G1 X167.489 Y166.74 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2319
M204 S5000
G1 X167.39 Y166.972 E.00777
G3 X165.556 Y164.25 I-1.641 J-.874 E.23528
G1 X165.744 Y164.24 E.00578
G3 X167.527 Y166.643 I.005 J1.859 E.10686
G1 X167.511 Y166.684 E.00135
; COOLING_NODE: 7
; WIPE_START
G1 F9547.055
M204 S8000
G1 X167.39 Y166.972 E-.11894
G1 X167.195 Y167.271 E-.13567
G1 X166.945 Y167.526 E-.1355
G1 X166.624 Y167.742 E-.14702
G1 X166.294 Y167.879 E-.13583
G1 X166.07 Y167.925 E-.08704
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X168.759 Y165.634 Z12.2 F60000
G1 Z11.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2319
M204 S8000
G1 X168.79 Y165.867 E.00779
G3 X165.783 Y163.053 I-3.038 J.233 E.48509
G1 X165.908 Y163.056 E.00415
G3 X168.753 Y165.571 I-.156 J3.043 E.13598
G1 X168.753 Y165.574 E.00011
; COOLING_NODE: 4
M204 S250
G1 X169.148 Y165.585 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2319
M204 S5000
G1 X169.182 Y165.836 E.00779
G3 X165.787 Y162.66 I-3.429 J.263 E.50714
G1 X165.929 Y162.665 E.00439
G3 X169.14 Y165.503 I-.177 J3.435 E.14214
G1 X169.142 Y165.525 E.0007
M204 S10000
G1 X168.358 Y165.64 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.431791
G1 F2319
M204 S8000
G1 X168.384 Y165.837 E.00632
G3 X163.1 Y166.111 I-2.635 J.273 E.2724
G1 X163.1 Y166.091 E.00063
G3 X163.107 Y165.915 I3.375 J.053 E.00556
G3 X168.345 Y165.581 I2.642 J.195 E.24062
; COOLING_NODE: 6
; WIPE_START
G1 F9257.566
G1 X168.384 Y165.837 E-.09846
G1 X168.399 Y166.147 E-.1177
G1 X168.349 Y166.618 E-.18027
G1 X168.287 Y166.864 E-.09625
G1 X168.19 Y167.134 E-.1089
G1 X168.084 Y167.355 E-.09319
G1 X167.995 Y167.502 E-.06522
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.615 Y167.071 Z12.2 F60000
G1 X182.085 Y166.706 Z12.2
G1 Z11.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2319
M204 S8000
G1 X182.007 Y166.305 E.01357
G3 X184.015 Y163.859 I2.242 J-.206 E.11638
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X184.241 Y163.847 E.00754
G3 X182.098 Y166.765 I.007 J2.251 E.32972
; COOLING_NODE: 6
M204 S250
G1 X182.468 Y166.631 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2319
M204 S5000
G1 X182.398 Y166.268 E.01136
G3 X184.056 Y164.25 I1.851 J-.17 E.08899
G1 X184.244 Y164.24 E.00578
G3 X182.486 Y166.688 I.005 J1.859 E.25091
; COOLING_NODE: 6
; WIPE_START
G1 F9547.055
M204 S8000
G1 X182.398 Y166.268 E-.16314
G1 X182.397 Y165.937 E-.12608
G1 X182.471 Y165.556 E-.14722
G1 X182.608 Y165.226 E-.13567
G1 X182.821 Y164.909 E-.14525
G1 X182.9 Y164.83 E-.04264
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X181.342 Y165.198 Z12.2 F60000
G1 Z11.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2319
M204 S8000
G1 X181.364 Y165.128 E.00245
G3 X184.283 Y163.053 I2.888 J.972 E.12698
G1 X184.408 Y163.056 E.00415
G3 X181.283 Y165.416 I-.156 J3.043 E.49407
G1 X181.326 Y165.256 E.00549
; COOLING_NODE: 1
M204 S250
G1 X180.965 Y165.091 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2319
M204 S5000
G1 X180.993 Y165.003 E.00284
G3 X184.287 Y162.66 I3.26 J1.097 E.13275
G1 X184.429 Y162.665 E.00439
G3 X180.901 Y165.327 I-.177 J3.435 E.51653
G1 X180.949 Y165.149 E.00567
M204 S10000
G1 X181.712 Y165.339 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.431793
G1 F2319
M204 S8000
G1 X181.716 Y165.336 E.00014
G3 X181.6 Y166.109 I2.534 J.774 E.50268
G1 X181.6 Y166.092 E.00055
G1 X181.601 Y166.053 E.00124
G3 X181.653 Y165.585 I2.649 J.057 E.01493
G1 X181.698 Y165.397 E.00614
; COOLING_NODE: 5
; WIPE_START
G1 F9257.534
G1 X181.716 Y165.336 E-.02406
G1 X181.81 Y165.066 E-.10868
G1 X181.916 Y164.845 E-.09322
G1 X182.058 Y164.61 E-.10426
G1 X182.218 Y164.398 E-.1009
G1 X182.381 Y164.221 E-.09148
G1 X182.759 Y163.909 E-.18628
G1 X182.874 Y163.84 E-.05113
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X185.913 Y156.838 Z12.2 F60000
G1 X187.298 Y153.648 Z12.2
G1 Z11.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2319
M204 S8000
G1 X162.702 Y153.648 E.81589
G1 X162.702 Y152.852 E.0264
G1 X187.298 Y152.852 E.81589
G1 X187.298 Y153.588 E.02441
; COOLING_NODE: 5
M204 S250
G1 X187.69 Y154.04 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2319
M204 S5000
M73 P96 R0
G1 X162.31 Y154.04 E.77986
G1 X162.31 Y152.46 E.04855
G1 X187.69 Y152.46 E.77986
G1 X187.69 Y153.98 E.04671
M204 S10000
G1 X187.094 Y153.25 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F2319
M204 S8000
G1 X162.906 Y153.25 E.76636
; CHANGE_LAYER
; Z_HEIGHT: 12
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.259
G1 X164.906 Y153.25 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 84/85
; update layer progress
M73 L84
M991 S0 P83 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 7
M204 S10000
G17
G3 Z12.2 I-1.19 J.257 P1  F60000
G1 X167.85 Y166.891 Z12.2
G1 Z12
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2319
M204 S8000
G1 X167.735 Y167.158 E.00966
G3 X165.513 Y163.86 I-1.986 J-1.06 E.30748
G1 X165.73 Y163.847 E.00722
G3 X167.901 Y166.758 I.019 J2.251 E.14012
G1 X167.871 Y166.835 E.00273
; COOLING_NODE: 7
M204 S250
G1 X167.489 Y166.741 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2319
M204 S5000
G1 X167.39 Y166.973 E.00775
G3 X165.555 Y164.25 I-1.641 J-.874 E.23523
G1 X165.734 Y164.24 E.00551
G3 X167.526 Y166.643 I.016 J1.859 E.10719
G1 X167.51 Y166.685 E.00137
; COOLING_NODE: 7
; WIPE_START
G1 F9547.055
M204 S8000
G1 X167.39 Y166.973 E-.11867
G1 X167.195 Y167.271 E-.13521
G1 X166.933 Y167.535 E-.14141
G1 X166.624 Y167.742 E-.14145
G1 X166.294 Y167.879 E-.13557
G1 X166.068 Y167.925 E-.08768
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X168.76 Y165.632 Z12.4 F60000
G1 Z12
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2319
M204 S8000
G1 X168.787 Y165.831 E.00668
G3 X165.792 Y163.053 I-3.035 J.268 E.48659
G1 X165.908 Y163.056 E.00385
G3 X168.753 Y165.57 I-.156 J3.043 E.13597
G1 X168.753 Y165.572 E.00005
; COOLING_NODE: 4
M204 S250
G1 X169.148 Y165.58 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2319
M204 S5000
G1 X169.179 Y165.799 E.00678
G3 X165.796 Y162.66 I-3.426 J.301 E.50863
G1 X165.929 Y162.665 E.00409
G3 X169.139 Y165.502 I-.177 J3.435 E.14212
G1 X169.141 Y165.521 E.00057
M204 S10000
G1 X168.358 Y165.645 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.431792
G1 F2319
M204 S8000
G1 X168.384 Y165.815 E.00544
G3 X163.1 Y166.11 I-2.635 J.283 E.27236
G1 X163.1 Y166.09 E.00064
G3 X163.113 Y165.835 I4.664 J.112 E.00808
G3 X168.345 Y165.562 I2.637 J.262 E.23838
G1 X168.349 Y165.586 E.00076
; COOLING_NODE: 6
; WIPE_START
G1 F9257.55
G1 X168.384 Y165.815 E-.08798
G1 X168.393 Y166.284 E-.17849
G1 X168.359 Y166.565 E-.10727
G1 X168.309 Y166.786 E-.08606
G1 X168.174 Y167.17 E-.15485
G1 X167.989 Y167.505 E-.14534
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.61 Y167.091 Z12.4 F60000
G1 X182.092 Y166.74 Z12.4
G1 Z12
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2319
M204 S8000
G1 X182.047 Y166.569 E.00587
G3 X184.013 Y163.86 I2.202 J-.47 E.12518
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X184.23 Y163.847 E.00722
G3 X182.108 Y166.797 I.019 J2.251 E.32896
; COOLING_NODE: 6
M204 S250
G1 X182.473 Y166.638 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2319
M204 S5000
G1 X182.4 Y166.295 E.01078
G3 X184.055 Y164.25 I1.849 J-.196 E.08977
G1 X184.234 Y164.24 E.00551
G3 X182.488 Y166.695 I.016 J1.859 E.25099
; COOLING_NODE: 6
; WIPE_START
G1 F9547.055
M204 S8000
G1 X182.4 Y166.295 E-.15598
G1 X182.4 Y165.906 E-.14749
G1 X182.471 Y165.556 E-.13602
G1 X182.608 Y165.226 E-.13568
G1 X182.815 Y164.917 E-.14119
G1 X182.895 Y164.835 E-.04364
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X181.345 Y165.184 Z12.4 F60000
G1 Z12
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2319
M204 S8000
G1 X181.353 Y165.159 E.00088
G3 X184.292 Y163.053 I2.898 J.941 E.12838
G1 X184.408 Y163.056 E.00385
G3 X181.27 Y165.47 I-.156 J3.043 E.49223
G1 X181.329 Y165.242 E.00781
; COOLING_NODE: 1
M204 S250
G1 X180.966 Y165.083 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2319
M204 S5000
G1 X180.981 Y165.038 E.00144
G3 X184.296 Y162.66 I3.271 J1.062 E.13419
G1 X184.429 Y162.665 E.00409
G3 X180.888 Y165.387 I-.177 J3.435 E.51465
G1 X180.951 Y165.141 E.0078
M204 S10000
G1 X181.713 Y165.338 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.431792
G1 F2319
M204 S8000
G1 X181.72 Y165.314 E.00079
G3 X181.6 Y166.11 I2.53 J.786 E.50195
G1 X181.6 Y166.09 E.00064
G3 X181.613 Y165.835 I5.516 J.162 E.00808
G3 X181.655 Y165.563 I2.636 J.265 E.00873
G1 X181.698 Y165.396 E.00546
; COOLING_NODE: 5
; WIPE_START
G1 F9257.565
G1 X181.72 Y165.314 E-.03228
G1 X181.812 Y165.061 E-.10257
G1 X181.917 Y164.844 E-.09136
G1 X182.057 Y164.612 E-.10294
G1 X182.199 Y164.422 E-.09027
G1 X182.381 Y164.222 E-.10253
G1 X182.557 Y164.062 E-.09068
G1 X182.777 Y163.897 E-.10434
G1 X182.874 Y163.839 E-.04304
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X185.913 Y156.838 Z12.4 F60000
G1 X187.298 Y153.648 Z12.4
G1 Z12
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2319
M204 S8000
G1 X162.702 Y153.648 E.81589
G1 X162.702 Y152.852 E.0264
G1 X187.298 Y152.852 E.81589
G1 X187.298 Y153.588 E.02441
; COOLING_NODE: 5
M204 S250
G1 X187.69 Y154.04 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2319
M204 S5000
G1 X162.31 Y154.04 E.77986
G1 X162.31 Y152.46 E.04855
G1 X187.69 Y152.46 E.77986
G1 X187.69 Y153.98 E.04671
M204 S10000
M73 P97 R0
G1 X187.094 Y153.25 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F2319
M204 S8000
G1 X162.906 Y153.25 E.76636
; CHANGE_LAYER
; Z_HEIGHT: 12.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.259
G1 X164.906 Y153.25 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 85/85
; update layer progress
M73 L85
M991 S0 P84 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 7
M204 S10000
G17
G3 Z12.4 I-1.195 J.229 P1  F60000
G1 X167.49 Y166.753 Z12.4
G1 Z12.2
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2550
M204 S5000
G1 X167.482 Y166.771 E.00062
G3 X165.555 Y164.25 I-1.733 J-.673 E.24205
G1 X165.724 Y164.24 E.00519
G3 X167.58 Y166.423 I.026 J1.859 E.10053
G1 X167.506 Y166.695 E.00867
; COOLING_NODE: 4
; WIPE_START
G1 F9547.055
M204 S8000
G1 X167.482 Y166.771 E-.03037
G1 X167.31 Y167.113 E-.14556
G1 X167.088 Y167.393 E-.13559
G1 X166.816 Y167.624 E-.13574
G1 X166.501 Y167.802 E-.13734
G1 X166.138 Y167.919 E-.14513
G1 X166.059 Y167.928 E-.03027
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X169.147 Y165.58 Z12.6 F60000
G1 Z12.2
G1 E.8 F1800
G1 F2550
M204 S5000
G1 X169.182 Y165.856 E.00854
G3 X165.806 Y162.661 I-3.431 J.243 E.5072
G1 X165.929 Y162.665 E.00377
G3 X169.138 Y165.503 I-.178 J3.435 E.14212
G1 X169.14 Y165.521 E.00055
M204 S10000
G1 X168.896 Y165.361 F60000
; FEATURE: Top surface
G1 F3401
M204 S2000
G1 X166.493 Y162.958 E.10444
G1 X166.359 Y162.824
G1 X165.74 Y162.738
G1 X165.873 Y162.872
G1 X168.98 Y165.978 E.13499
G1 X169.113 Y166.112
G1 X169.088 Y166.62
G1 X168.955 Y166.486
G1 X167.548 Y165.079 E.06113
G1 X167.414 Y164.946
G1 X167.67 Y165.735
G1 X167.804 Y165.869
G1 X168.87 Y166.935 E.04633
G1 X169.004 Y167.069
G1 X168.868 Y167.466
G1 X168.735 Y167.333
G1 X167.789 Y166.387 E.04109
G1 X167.655 Y166.253
G1 X167.548 Y166.68
G1 X167.682 Y166.813
G1 X168.56 Y167.691 E.03815
G1 X168.694 Y167.825
G1 X168.484 Y168.148
G1 X168.35 Y168.015
G1 X167.507 Y167.172 E.03662
G1 X167.374 Y167.038
G1 X167.148 Y167.346
G1 X167.281 Y167.479
G1 X168.11 Y168.308 E.03602
G1 X168.244 Y168.442
G1 X167.968 Y168.699
G1 X167.834 Y168.566
G1 X167.005 Y167.736 E.03605
G1 X166.871 Y167.602
G1 X166.544 Y167.808
G1 X166.678 Y167.942
G1 X167.529 Y168.793 E.037
G1 X167.663 Y168.927
G1 X167.325 Y169.122
G1 X167.191 Y168.989
G1 X166.291 Y168.089 E.03909
G1 X166.158 Y167.955
G1 X165.693 Y168.024
G1 X165.827 Y168.158
G1 X166.817 Y169.148 E.04304
G1 X166.951 Y169.282
G1 X166.533 Y169.397
G1 X166.399 Y169.263
G1 X165.234 Y168.098 E.05062
; WIPE_START
G1 F9547.055
M204 S8000
G1 X166.399 Y169.263 E-.62602
G1 X166.533 Y169.397 E-.07182
G1 X166.69 Y169.353 E-.06216
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X166.788 Y164.32 Z12.6 F60000
G1 Z12.2
G1 E.8 F1800
G1 F3401
M204 S2000
G1 X165.362 Y162.894 E.06196
G1 X165.229 Y162.76
G1 X164.783 Y162.847
G1 X164.916 Y162.981
G1 X165.984 Y164.049 E.04642
G1 X166.118 Y164.183
G1 X165.594 Y164.192
G1 X165.46 Y164.058
G1 X164.518 Y163.116 E.04092
G1 X164.385 Y162.983
G1 X164.024 Y163.155
G1 X164.157 Y163.289
G1 X165.035 Y164.166 E.03814
G1 X165.168 Y164.3
G1 X164.809 Y164.474
G1 X164.675 Y164.34
G1 X163.833 Y163.498 E.03659
G1 X163.7 Y163.364
G1 X163.411 Y163.609
G1 X163.545 Y163.743
G1 X164.37 Y164.567 E.03585
G1 X164.503 Y164.701
G1 X164.244 Y164.976
G1 X164.111 Y164.842
G1 X163.284 Y164.015 E.03593
G1 X163.15 Y163.881
G1 X162.922 Y164.187
G1 X163.056 Y164.32
G1 X163.904 Y165.168 E.03686
G1 X164.038 Y165.302
G1 X163.891 Y165.688
G1 X163.757 Y165.555
G1 X162.859 Y164.657 E.03901
G1 X162.726 Y164.523
G1 X162.569 Y164.9
G1 X162.703 Y165.033
G1 X163.688 Y166.019 E.04283
G1 X163.822 Y166.153
G1 X163.89 Y166.754
G1 X163.756 Y166.621
G1 X162.588 Y165.452 E.05078
G1 X162.454 Y165.318
G1 X162.391 Y165.788
G1 X162.525 Y165.922
G1 X165.928 Y169.325 E.14789
G1 X166.062 Y169.459
G1 X165.511 Y169.441
G1 X165.377 Y169.308
G1 X162.54 Y166.471 E.12329
G1 X162.406 Y166.337
G1 X162.568 Y167.032
G1 X162.701 Y167.165
G1 X164.683 Y169.147 E.08613
; WIPE_START
G1 F9547.055
M204 S8000
G1 X163.269 Y167.733 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X168.768 Y164.929 Z12.6 F60000
G1 Z12.2
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.163556
G1 F3401
M204 S8000
G1 X168.67 Y164.795 E.00164
; LINE_WIDTH: 0.198749
G1 X168.572 Y164.66 E.00211
; LINE_WIDTH: 0.233942
G1 X168.474 Y164.525 E.00259
; LINE_WIDTH: 0.266312
G1 X168.389 Y164.419 E.00247
; LINE_WIDTH: 0.295874
G1 X168.304 Y164.313 E.0028
; LINE_WIDTH: 0.343133
G2 X167.663 Y163.655 I-5.396 J4.612 E.02251
; LINE_WIDTH: 0.320988
G1 X167.537 Y163.549 E.00373
; LINE_WIDTH: 0.292291
G1 X167.411 Y163.443 E.00335
; LINE_WIDTH: 0.254752
G1 X167.278 Y163.342 E.00288
; LINE_WIDTH: 0.208358
G1 X167.144 Y163.242 E.00225
; LINE_WIDTH: 0.160924
G1 X167.03 Y163.165 E.00133
; LINE_WIDTH: 0.11242
G1 X166.915 Y163.087 E.00078
; WIPE_START
G1 F15000
G1 X167.03 Y163.165 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X167.381 Y164.745 Z12.6 F60000
G1 Z12.2
G1 E.8 F1800
; LINE_WIDTH: 0.194828
G1 F3401
M204 S8000
G2 X166.849 Y164.259 I-2.758 J2.49 E.00894
; WIPE_START
G1 F15000
G1 X167.068 Y164.437 E-.29768
G1 X167.381 Y164.745 E-.46232
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X165.245 Y168.087 Z12.6 F60000
G1 Z12.2
G1 E.8 F1800
; LINE_WIDTH: 0.115274
G1 F3401
M204 S8000
G1 X165.016 Y168.147 E.0014
; WIPE_START
G1 F15000
G1 X165.245 Y168.087 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X164.138 Y168.896 Z12.6 F60000
G1 Z12.2
G1 E.8 F1800
; LINE_WIDTH: 0.101206
G1 F3401
M204 S8000
G1 X164.045 Y168.826 E.00055
; LINE_WIDTH: 0.126965
G1 X163.939 Y168.738 E.00095
; LINE_WIDTH: 0.152368
G1 X163.832 Y168.649 E.00124
; LINE_WIDTH: 0.179716
G3 X163.129 Y167.934 I4.745 J-5.366 E.01119
; LINE_WIDTH: 0.132719
G1 X163.036 Y167.818 E.00108
; LINE_WIDTH: 0.103023
G1 X162.944 Y167.703 E.00072
; COOLING_NODE: 6
; WIPE_START
G1 F15000
G1 X163.036 Y167.818 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X170.655 Y167.362 Z12.6 F60000
G1 X182.484 Y166.652 Z12.6
G1 Z12.2
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2550
M204 S5000
G1 X182.431 Y166.487 E.00533
G3 X184.055 Y164.25 I1.818 J-.388 E.09576
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X184.224 Y164.24 E.00519
G3 X182.549 Y166.851 I.026 J1.859 E.24619
G1 X182.503 Y166.709 E.00457
; COOLING_NODE: 1
; WIPE_START
G1 F9547.055
M204 S8000
G1 X182.431 Y166.487 E-.08875
G1 X182.39 Y166.134 E-.13516
G1 X182.418 Y165.777 E-.13595
G1 X182.516 Y165.428 E-.13778
G1 X182.69 Y165.087 E-.1455
G1 X182.804 Y164.93 E-.07372
G1 X182.883 Y164.849 E-.04314
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X180.97 Y165.069 Z12.6 F60000
G1 Z12.2
G1 E.8 F1800
G1 F2550
M204 S5000
G1 X180.98 Y165.038 E.001
G3 X184.306 Y162.661 I3.271 J1.062 E.13454
G1 X184.429 Y162.665 E.00377
G3 X180.899 Y165.33 I-.178 J3.435 E.51638
G1 X180.954 Y165.127 E.00648
; WIPE_START
G1 F9547.055
M204 S8000
G1 X180.98 Y165.038 E-.03519
G1 X181.108 Y164.7 E-.13725
G1 X181.241 Y164.433 E-.11361
G1 X181.432 Y164.127 E-.13715
G1 X181.615 Y163.889 E-.11386
G1 X181.86 Y163.626 E-.13677
G1 X182.031 Y163.477 E-.08617
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X187.333 Y165.134 Z12.6 F60000
G1 Z12.2
G1 E.8 F1800
; FEATURE: Top surface
G1 F3401
M204 S2000
G1 X185.218 Y163.019 E.0919
G1 X185.085 Y162.886
G1 X184.418 Y162.752
G1 X184.552 Y162.886
G1 X187.466 Y165.8 E.12662
G1 X187.599 Y165.934
G1 X187.606 Y166.474
G1 X187.473 Y166.34
G1 X184.013 Y162.881 E.15034
G1 X183.879 Y162.747
G1 X183.412 Y162.813
G1 X183.546 Y162.946
G1 X184.686 Y164.087 E.04957
G1 X184.82 Y164.221
G1 X184.242 Y164.176
G1 X184.108 Y164.042
G1 X183.135 Y163.069 E.04228
G1 X183.001 Y162.936
G1 X182.631 Y163.099
G1 X182.765 Y163.232
G1 X183.655 Y164.123 E.03868
G1 X183.789 Y164.256
G1 X183.411 Y164.411
G1 X183.277 Y164.278
G1 X182.432 Y163.432 E.03674
G1 X182.298 Y163.299
G1 X181.994 Y163.528
G1 X182.128 Y163.662
G1 X182.957 Y164.491 E.03601
G1 X183.09 Y164.624
G1 X182.82 Y164.887
G1 X182.686 Y164.754
G1 X181.86 Y163.927 E.03592
G1 X181.726 Y163.793
G1 X181.488 Y164.089
G1 X181.622 Y164.222
G1 X182.467 Y165.068 E.03673
G1 X182.601 Y165.201
G1 X182.433 Y165.567
G1 X182.3 Y165.433
G1 X181.418 Y164.551 E.03832
G1 X181.284 Y164.418
G1 X181.112 Y164.778
G1 X181.245 Y164.912
G1 X182.202 Y165.868 E.04156
G1 X182.335 Y166.002
G1 X182.343 Y166.544
G1 X182.21 Y166.41
G1 X181.116 Y165.316 E.04753
G1 X180.982 Y165.183
G1 X180.905 Y165.638
G1 X181.038 Y165.772
G1 X182.606 Y167.34 E.06814
; WIPE_START
G1 F9547.055
M204 S8000
G1 X181.192 Y165.925 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X186.262 Y165.663 Z12.6 F60000
G1 Z12.2
G1 E.8 F1800
G1 F3401
M204 S2000
G1 X187.401 Y166.802 E.04948
G1 X187.534 Y166.935
G1 X187.416 Y167.35
G1 X187.282 Y167.216
G1 X186.313 Y166.247 E.0421
G1 X186.179 Y166.113
G1 X186.095 Y166.562
G1 X186.228 Y166.696
G1 X187.119 Y167.587 E.03871
G1 X187.253 Y167.72
G1 X187.051 Y168.052
G1 X186.917 Y167.918
G1 X186.072 Y167.073 E.03674
G1 X185.938 Y166.939
G1 X185.727 Y167.261
G1 X185.86 Y167.394
G1 X186.686 Y168.22 E.03588
G1 X186.82 Y168.354
G1 X186.556 Y168.623
G1 X186.422 Y168.49
G1 X185.598 Y167.666 E.03581
G1 X185.465 Y167.532
G1 X185.152 Y167.753
G1 X185.286 Y167.886
G1 X186.128 Y168.729 E.03661
G1 X186.262 Y168.863
G1 X185.933 Y169.067
G1 X185.8 Y168.933
G1 X184.92 Y168.054 E.03821
G1 X184.787 Y167.92
G1 X184.353 Y168.02
G1 X184.487 Y168.154
G1 X185.436 Y169.102 E.04123
G1 X185.569 Y169.236
G1 X185.167 Y169.367
G1 X185.034 Y169.234
G1 X183.934 Y168.134 E.0478
G1 X183.8 Y168
G1 X182.897 Y167.63
G1 X183.03 Y167.764
G1 X184.58 Y169.313 E.06734
G1 X184.714 Y169.447
G1 X184.192 Y169.459
G1 X184.058 Y169.325
G1 X181.026 Y166.293 E.13177
G1 X180.892 Y166.159
G1 X180.995 Y166.795
G1 X181.129 Y166.929
G1 X183.425 Y169.225 E.09977
; WIPE_START
G1 F9547.055
M204 S8000
G1 X182.01 Y167.81 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X187.124 Y164.632 Z12.6 F60000
G1 Z12.2
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.11056
G1 F3401
M204 S8000
G1 X187.027 Y164.497 E.00091
; LINE_WIDTH: 0.150609
G1 X186.921 Y164.366 E.00148
; LINE_WIDTH: 0.185845
G1 X186.815 Y164.235 E.00196
; LINE_WIDTH: 0.229321
G2 X186.199 Y163.609 I-5.539 J4.826 E.01335
; LINE_WIDTH: 0.20443
G1 X186.07 Y163.501 E.00221
; LINE_WIDTH: 0.175169
G1 X185.942 Y163.393 E.00181
; LINE_WIDTH: 0.142458
G1 X185.829 Y163.308 E.00115
; LINE_WIDTH: 0.106264
G1 X185.716 Y163.223 E.00073
; WIPE_START
G1 F15000
G1 X185.829 Y163.308 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X186.333 Y165.592 Z12.6 F60000
G1 Z12.2
G1 E.8 F1800
; LINE_WIDTH: 0.141429
G1 F3401
M204 S8000
G1 X186.243 Y165.445 E.00139
; LINE_WIDTH: 0.126349
G1 X186.197 Y165.378 E.00055
; LINE_WIDTH: 0.100891
G1 X186.151 Y165.311 E.00038
; WIPE_START
G1 F15000
G1 X186.197 Y165.378 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X187.421 Y165.466 Z12.6 F60000
G1 Z12.2
G1 E.8 F1800
; LINE_WIDTH: 0.0947028
G1 F3401
M204 S8000
G1 X187.278 Y165.189 E.00132
; WIPE_START
G1 F15000
G1 X187.421 Y165.466 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X182.975 Y169.067 Z12.6 F60000
G1 Z12.2
G1 E.8 F1800
; LINE_WIDTH: 0.112762
G1 F3401
M204 S8000
G1 X182.847 Y168.98 E.00088
; LINE_WIDTH: 0.160823
M73 P98 R0
G1 X182.712 Y168.879 E.00162
; LINE_WIDTH: 0.207796
G1 X182.577 Y168.777 E.00227
; LINE_WIDTH: 0.245755
G1 X182.45 Y168.671 E.00275
; LINE_WIDTH: 0.274716
G1 X182.323 Y168.564 E.00314
; LINE_WIDTH: 0.297056
G3 X181.677 Y167.9 I4.798 J-5.317 E.0192
; LINE_WIDTH: 0.249469
G1 X181.591 Y167.793 E.0023
; LINE_WIDTH: 0.219739
G1 X181.506 Y167.687 E.00197
; LINE_WIDTH: 0.187133
G1 X181.439 Y167.595 E.00133
; LINE_WIDTH: 0.151611
G1 X181.372 Y167.503 E.00101
; LINE_WIDTH: 0.109393
G3 X181.28 Y167.372 I1.216 J-.954 E.00087
; COOLING_NODE: 5
; WIPE_START
G1 F15000
G1 X181.372 Y167.503 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X184.615 Y160.594 Z12.6 F60000
G1 X187.69 Y154.04 Z12.6
G1 Z12.2
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2550
M204 S5000
G1 X162.31 Y154.04 E.77986
G1 X162.31 Y152.46 E.04855
G1 X187.69 Y152.46 E.77986
G1 X187.69 Y153.98 E.04671
M204 S10000
G1 X187.483 Y153.019 F60000
; FEATURE: Top surface
G1 F3401
M204 S2000
G1 X187.131 Y152.667 E.01527
G1 X186.998 Y152.534
G1 X186.464 Y152.534
G1 X186.598 Y152.667
G1 X187.483 Y153.552 E.03844
G1 X187.616 Y153.686
G1 X187.364 Y153.966
G1 X187.23 Y153.833
G1 X186.065 Y152.667 E.05064
G1 X185.931 Y152.534
G1 X185.398 Y152.534
G1 X185.531 Y152.667
G1 X186.697 Y153.833 E.05064
G1 X186.83 Y153.966
G1 X186.297 Y153.966
G1 X186.163 Y153.833
G1 X184.998 Y152.667 E.05064
G1 X184.865 Y152.534
G1 X184.331 Y152.534
G1 X184.465 Y152.667
G1 X185.63 Y153.833 E.05064
G1 X185.764 Y153.966
G1 X185.231 Y153.966
G1 X185.097 Y153.833
G1 X183.932 Y152.667 E.05064
G1 X183.798 Y152.534
G1 X183.265 Y152.534
G1 X183.398 Y152.667
G1 X184.564 Y153.833 E.05064
G1 X184.697 Y153.966
G1 X184.164 Y153.966
G1 X184.03 Y153.833
G1 X182.865 Y152.667 E.05064
G1 X182.732 Y152.534
G1 X182.198 Y152.534
G1 X182.332 Y152.667
G1 X183.497 Y153.833 E.05064
G1 X183.631 Y153.966
G1 X183.098 Y153.966
G1 X182.964 Y153.833
G1 X181.799 Y152.667 E.05064
G1 X181.665 Y152.534
G1 X181.132 Y152.534
G1 X181.265 Y152.667
G1 X182.431 Y153.833 E.05064
G1 X182.564 Y153.966
G1 X182.031 Y153.966
G1 X181.897 Y153.833
G1 X180.732 Y152.667 E.05064
G1 X180.598 Y152.534
G1 X180.065 Y152.534
G1 X180.199 Y152.667
G1 X181.364 Y153.833 E.05064
G1 X181.498 Y153.966
G1 X180.965 Y153.966
G1 X180.831 Y153.833
G1 X179.666 Y152.667 E.05064
G1 X179.532 Y152.534
G1 X178.999 Y152.534
G1 X179.132 Y152.667
G1 X180.298 Y153.833 E.05064
G1 X180.431 Y153.966
G1 X179.898 Y153.966
G1 X179.764 Y153.833
G1 X178.599 Y152.667 E.05064
G1 X178.465 Y152.534
G1 X177.932 Y152.534
G1 X178.066 Y152.667
G1 X179.231 Y153.833 E.05064
G1 X179.365 Y153.966
G1 X178.831 Y153.966
G1 X178.698 Y153.833
G1 X177.533 Y152.667 E.05064
G1 X177.399 Y152.534
G1 X176.866 Y152.534
G1 X176.999 Y152.667
G1 X178.165 Y153.833 E.05064
G1 X178.298 Y153.966
G1 X177.765 Y153.966
G1 X177.631 Y153.833
G1 X176.466 Y152.667 E.05064
G1 X176.332 Y152.534
G1 X175.799 Y152.534
G1 X175.933 Y152.667
G1 X177.098 Y153.833 E.05064
G1 X177.232 Y153.966
G1 X176.698 Y153.966
G1 X176.565 Y153.833
G1 X175.4 Y152.667 E.05064
G1 X175.266 Y152.534
G1 X174.733 Y152.534
G1 X174.866 Y152.667
G1 X176.032 Y153.833 E.05064
G1 X176.165 Y153.966
G1 X175.632 Y153.966
G1 X175.498 Y153.833
G1 X174.333 Y152.667 E.05064
G1 X174.199 Y152.534
G1 X173.666 Y152.534
G1 X173.8 Y152.667
G1 X174.965 Y153.833 E.05064
G1 X175.099 Y153.966
G1 X174.565 Y153.966
G1 X174.432 Y153.833
G1 X173.267 Y152.667 E.05064
G1 X173.133 Y152.534
G1 X172.6 Y152.534
G1 X172.733 Y152.667
G1 X173.899 Y153.833 E.05064
G1 X174.032 Y153.966
G1 X173.499 Y153.966
G1 X173.365 Y153.833
G1 X172.2 Y152.667 E.05064
G1 X172.066 Y152.534
G1 X171.533 Y152.534
G1 X171.667 Y152.667
G1 X172.832 Y153.833 E.05064
G1 X172.966 Y153.966
G1 X172.432 Y153.966
G1 X172.299 Y153.833
G1 X171.133 Y152.667 E.05064
G1 X171 Y152.534
G1 X170.467 Y152.534
G1 X170.6 Y152.667
G1 X171.765 Y153.833 E.05064
G1 X171.899 Y153.966
G1 X171.366 Y153.966
G1 X171.232 Y153.833
G1 X170.067 Y152.667 E.05064
G1 X169.933 Y152.534
G1 X169.4 Y152.534
G1 X169.534 Y152.667
G1 X170.699 Y153.833 E.05064
G1 X170.833 Y153.966
G1 X170.299 Y153.966
G1 X170.166 Y153.833
G1 X169 Y152.667 E.05064
G1 X168.867 Y152.534
G1 X168.334 Y152.534
G1 X168.467 Y152.667
G1 X169.632 Y153.833 E.05064
G1 X169.766 Y153.966
G1 X169.233 Y153.966
G1 X169.099 Y153.833
G1 X167.934 Y152.667 E.05064
G1 X167.8 Y152.534
G1 X167.267 Y152.534
G1 X167.401 Y152.667
G1 X168.566 Y153.833 E.05064
G1 X168.7 Y153.966
G1 X168.166 Y153.966
G1 X168.033 Y153.833
G1 X166.867 Y152.667 E.05064
G1 X166.734 Y152.534
G1 X166.201 Y152.534
G1 X166.334 Y152.667
G1 X167.499 Y153.833 E.05064
G1 X167.633 Y153.966
G1 X167.1 Y153.966
G1 X166.966 Y153.833
G1 X165.801 Y152.667 E.05064
G1 X165.667 Y152.534
G1 X165.134 Y152.534
G1 X165.268 Y152.667
G1 X166.433 Y153.833 E.05064
G1 X166.567 Y153.966
G1 X166.033 Y153.966
G1 X165.9 Y153.833
G1 X164.734 Y152.667 E.05064
G1 X164.601 Y152.534
G1 X164.068 Y152.534
G1 X164.201 Y152.667
G1 X165.366 Y153.833 E.05064
G1 X165.5 Y153.966
G1 X164.967 Y153.966
G1 X164.833 Y153.833
M73 P99 R0
G1 X163.668 Y152.667 E.05064
G1 X163.534 Y152.534
G1 X163.001 Y152.534
G1 X163.135 Y152.667
G1 X164.3 Y153.833 E.05064
G1 X164.434 Y153.966
G1 X163.9 Y153.966
G1 X163.767 Y153.833
G1 X162.601 Y152.667 E.05064
G1 X162.468 Y152.534
G1 X162.384 Y152.983
G1 X162.517 Y153.117
G1 X163.233 Y153.833 E.03111
; close powerlost recovery
M1003 S0
; WIPE_START
G1 F9547.055
M204 S8000
G1 X162.517 Y153.117 E-.38478
G1 X162.384 Y152.983 E-.07182
G1 X162.468 Y152.534 E-.17367
G1 X162.601 Y152.667 E-.07182
G1 X162.709 Y152.775 E-.05792
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z12.6 I1.217 J0 P1  F60000
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
G1 Z12.6 F900 ; lower z a little
M1002 judge_flag timelapse_record_flag
M622 J1
    G150.3
    M400 ; wait all motion done
    M991 S0 P-1 ;end smooth timelapse at safe pos
    M400 S5 ;wait for last picture to be taken
M623  ;end of "timelapse_record_flag"

G90
G1 Z22.2 F900 ; lower z a little

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

    
        G1 Z106.1 F600
        G1 Z104.1
    

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

