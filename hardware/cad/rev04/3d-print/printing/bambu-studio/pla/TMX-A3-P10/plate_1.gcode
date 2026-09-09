; HEADER_BLOCK_START
; BambuStudio 02.08.02.61
; model printing time: 6m 24s; total estimated time: 11m 51s
; total layer number: 47
; total filament length [mm] : 517.67
; total filament volume [cm^3] : 1245.14
; total filament weight [g] : 1.54
; filament_density: 1.24
; filament_diameter: 1.75
; max_z_height: 8.20
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
M73 P0 R11
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
M73 P3 R11
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
M73 P6 R11
G1 Z5 F1200
G90
G1 X175 Y160 F30000

M622 J1
    M1002 gcode_claim_action : 1
    G29.20 A3
    G29 A1 O X161.193 Y150.85 I27.6131 J22.1067 R
    M400
M623

M622 J2
    M1002 gcode_claim_action : 1
    
        G29.20 A4
        G29 A2 O X161.193 Y150.85 I27.6131 J22.1067 R
    
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
M73 P43 R6
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
M73 P44 R6
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
; layer num/total_layer_count: 1/47
; update layer progress
M73 L1
M991 S0 P0 ;notify layer change

M106 S0
M106 P2 S0
; OBJECT_ID: 15
G1 X162.119 Y151.795 F60000
M204 S6000
M73 P45 R6
G1 Z.4
G1 Z.2
G1 E.8 F1800
; FEATURE: Support interface
; LINE_WIDTH: 0.42
G1 F3000
M204 S500
G1 X162.875 Y151.038 E.03289
G1 X164.116 Y151.038 E.03811
G1 X162.288 Y152.866 E.07941
G1 X162.288 Y154.106 E.03811
G1 X165.356 Y151.038 E.13331
G1 X166.597 Y151.038 E.03811
M73 P46 R6
G1 X162.288 Y155.347 E.18721
G1 X162.288 Y156.587 E.03811
G1 X167.837 Y151.038 E.24111
G1 X169.077 Y151.038 E.03811
G1 X162.288 Y157.827 E.29501
G1 X162.288 Y159.068 E.03811
G1 X170.318 Y151.038 E.34891
G1 X171.558 Y151.038 E.03811
G1 X162.288 Y160.308 E.40281
G1 X162.288 Y161.548 E.03811
G1 X172.798 Y151.038 E.45671
G1 X174.039 Y151.038 E.03811
G1 X162.288 Y162.789 E.51061
G1 X162.288 Y164.029 E.03811
G1 X175.279 Y151.038 E.56451
G1 X176.519 Y151.038 E.03811
G1 X162.288 Y165.269 E.61841
G1 X162.288 Y166.51 E.03811
G1 X177.76 Y151.038 E.67231
G1 X179 Y151.038 E.03811
G1 X162.477 Y167.562 E.71802
G1 X163.717 Y167.562 E.03811
G1 X164.462 Y166.817 E.03235
G1 X164.462 Y166.127 E.02121
G1 X164.777 Y165.812 E.01371
G1 X165.467 Y165.812 E.02121
G1 X180.241 Y151.038 E.64197
G1 X181.481 Y151.038 E.03811
G1 X166.708 Y165.812 E.64197
G1 X167.948 Y165.812 E.03811
G1 X182.721 Y151.038 E.64197
G1 X183.962 Y151.038 E.03811
G1 X169.188 Y165.812 E.64197
G1 X170.429 Y165.812 E.03811
G1 X185.202 Y151.038 E.64197
G1 X186.442 Y151.038 E.03811
M73 P47 R6
G1 X171.669 Y165.812 E.64197
G1 X172.91 Y165.812 E.03811
G1 X187.712 Y151.038 E.6426
G1 X187.712 Y152.25 E.03722
G1 X174.15 Y165.812 E.58933
G1 X175.39 Y165.812 E.03811
G1 X187.712 Y153.49 E.53543
G1 X187.712 Y154.731 E.03811
G1 X176.631 Y165.812 E.48153
G1 X177.871 Y165.812 E.03811
G1 X187.712 Y155.971 E.42763
G1 X187.712 Y157.211 E.03811
G1 X179.111 Y165.812 E.37373
G1 X180.352 Y165.812 E.03811
G1 X187.712 Y158.452 E.31983
G1 X187.712 Y159.692 E.03811
G1 X181.592 Y165.812 E.26593
G1 X182.832 Y165.812 E.03811
G1 X187.712 Y160.932 E.21203
G1 X187.712 Y162.173 E.03811
G1 X184.073 Y165.812 E.15813
G1 X185.223 Y165.812 E.03534
G1 X185.268 Y165.857 E.00196
G1 X187.712 Y163.413 E.10619
G1 X187.712 Y164.653 E.03811
G1 X185.538 Y166.827 E.09444
G1 X185.538 Y167.562 E.02258
G1 X186.044 Y167.562 E.01553
G1 X187.712 Y165.894 E.07248
G1 X187.712 Y167.134 E.03811
G1 X187.114 Y167.731 E.02595
M204 S6000
G1 X187.114 Y167.979 F60000
; FEATURE: Brim
; LINE_WIDTH: 0.5
G1 F3000
M204 S500
G1 X187.9 Y167.979 E.02926
G1 X188.041 Y167.93 E.00555
G1 X188.129 Y167.75 E.00745
G1 X188.129 Y164.627 E.11634
G1 X188.3 Y164.994 E.01509
G1 X188.502 Y165.638 E.02516
G1 X188.578 Y166.362 E.0271
G1 X188.578 Y169.141 E.10349
G1 X188.531 Y169.71 E.02127
G1 X188.287 Y170.533 E.03198
G1 X187.975 Y171.128 E.02502
G1 X187.628 Y171.576 E.02109
G1 X187.212 Y171.96 E.02109
G1 X186.738 Y172.272 E.02113
G1 X186.257 Y172.489 E.01967
G1 X185.713 Y172.652 E.02114
G1 X184.988 Y172.728 E.02716
G1 X165.009 Y172.728 E.74412
G1 X164.44 Y172.681 E.02127
G1 X163.529 Y172.398 E.03555
G1 X163.022 Y172.125 E.02144
G1 X162.574 Y171.778 E.02109
G1 X162.19 Y171.362 E.02109
G1 X161.878 Y170.888 E.02113
G1 X161.661 Y170.407 E.01967
G1 X161.498 Y169.863 E.02114
G1 X161.422 Y169.138 E.02715
G1 X161.422 Y166.359 E.1035
G1 X161.469 Y165.79 E.02127
G1 X161.713 Y164.967 E.03198
G1 X161.871 Y164.657 E.01297
G1 X161.871 Y167.75 E.11522
G1 X161.92 Y167.891 E.00555
G1 X162.1 Y167.979 E.00745
G1 X164.621 Y167.979 E.09392
G1 X164.621 Y169.15 E.04363
G1 X164.637 Y169.234 E.00317
G1 X164.677 Y169.336 E.00408
M73 P48 R6
G1 X164.799 Y169.462 E.00651
G1 X165 Y169.529 E.0079
G1 X185 Y169.529 E.74492
G1 X185.084 Y169.513 E.00317
G1 X185.186 Y169.473 E.00408
G1 X185.312 Y169.351 E.00651
G1 X185.379 Y169.15 E.0079
G1 X185.379 Y167.979 E.04363
G1 X187.054 Y167.979 E.06242
M204 S6000
G1 X187.057 Y168.429 F60000
G1 F3000
M204 S500
G1 X187.961 Y168.424 E.03367
G1 X188.072 Y168.453 E.00426
G1 X188.121 Y168.559 E.00433
G1 X188.121 Y169.116 E.02075
G1 X188.075 Y169.639 E.01954
G1 X187.865 Y170.348 E.02755
G1 X187.595 Y170.87 E.02189
G1 X187.297 Y171.257 E.0182
G1 X186.938 Y171.591 E.01826
G1 X186.526 Y171.864 E.0184
G1 X186.088 Y172.062 E.01794
G1 X185.61 Y172.203 E.01855
G1 X184.957 Y172.271 E.02445
G1 X165.034 Y172.271 E.74205
G1 X164.514 Y172.225 E.01946
G1 X163.695 Y171.968 E.03197
G1 X163.263 Y171.734 E.0183
G1 X162.893 Y171.447 E.01743
G1 X162.545 Y171.071 E.0191
G1 X162.276 Y170.658 E.01836
G1 X162.088 Y170.238 E.01714
G1 X161.947 Y169.76 E.01855
G1 X161.88 Y169.121 E.02392
G1 X161.879 Y168.554 E.02115
G1 X161.927 Y168.45 E.00426
G1 X162.047 Y168.42 E.00461
G1 X162.116 Y168.436 E.00262
G1 X164.027 Y168.436 E.07121
G1 X164.131 Y168.483 E.00426
G1 X164.164 Y168.571 E.00348
G1 X164.174 Y169.24 E.02492
G1 X164.25 Y169.495 E.00993
G1 X164.358 Y169.663 E.00741
G1 X164.458 Y169.767 E.00539
G1 X164.67 Y169.901 E.00934
G1 X164.845 Y169.959 E.00687
G1 X165.011 Y169.986 E.00626
G1 X184.987 Y169.986 E.74403
G1 X185.34 Y169.903 E.01351
G1 X185.513 Y169.792 E.00763
G1 X185.617 Y169.692 E.00539
G1 X185.75 Y169.48 E.00934
G1 X185.809 Y169.305 E.00687
G1 X185.836 Y169.139 E.00626
G1 X185.836 Y168.573 E.02109
G1 X185.883 Y168.469 E.00426
G1 X185.973 Y168.436 E.00355
G1 X186.997 Y168.429 E.03816
M204 S6000
G1 X187 Y168.887 F60000
G1 F3000
M204 S500
G1 X187.526 Y168.883 E.01959
G1 X187.63 Y168.93 E.00426
G1 X187.664 Y169.02 E.00358
G1 X187.664 Y169.09 E.00259
G1 X187.625 Y169.539 E.01679
G1 X187.443 Y170.164 E.02424
G1 X187.213 Y170.613 E.01878
G1 X186.95 Y170.956 E.01613
G1 X186.645 Y171.237 E.01543
G1 X186.314 Y171.456 E.0148
G1 X185.937 Y171.629 E.01544
G1 X185.508 Y171.754 E.01662
G1 X184.926 Y171.814 E.0218
G1 X165.06 Y171.814 E.73993
G1 X164.618 Y171.775 E.01654
G1 X163.886 Y171.55 E.02851
G1 X163.523 Y171.355 E.01534
G1 X163.212 Y171.116 E.01462
G1 X162.915 Y170.797 E.01623
G1 X162.684 Y170.447 E.01562
G1 X162.515 Y170.07 E.01539
G1 X162.396 Y169.657 E.01601
G1 X162.337 Y169.043 E.02297
G1 X162.375 Y168.935 E.00426
G1 X162.474 Y168.893 E.004
G1 X163.577 Y168.893 E.04109
G1 X163.681 Y168.941 E.00426
G1 X163.714 Y169.028 E.00348
G1 X163.739 Y169.379 E.0131
G1 X163.809 Y169.616 E.00921
G1 X163.87 Y169.748 E.00542
G1 X164.034 Y169.984 E.01071
G1 X164.223 Y170.158 E.00956
G1 X164.537 Y170.338 E.01348
G1 X164.779 Y170.411 E.00942
G1 X165.02 Y170.443 E.00906
G1 X184.973 Y170.443 E.74318
G1 X185.435 Y170.35 E.01754
G1 X185.597 Y170.281 E.00655
G1 X185.751 Y170.183 E.0068
G1 X185.93 Y170.024 E.00891
G1 X186.006 Y169.931 E.00449
G1 X186.188 Y169.613 E.01364
G1 X186.26 Y169.374 E.00932
G1 X186.293 Y169.014 E.01343
G1 X186.35 Y168.915 E.00426
G1 X186.429 Y168.89 E.00308
G1 X186.94 Y168.887 E.01904
M204 S6000
G1 X186.967 Y169.347 F60000
G1 F3000
M204 S500
G1 X187.022 Y169.343 E.00207
G1 X187.127 Y169.391 E.00426
G1 X187.155 Y169.519 E.0049
G1 X187.02 Y169.982 E.01795
G1 X186.831 Y170.356 E.01563
G1 X186.618 Y170.638 E.01314
G1 X186.37 Y170.869 E.01261
G1 X186.082 Y171.06 E.0129
G1 X185.767 Y171.202 E.01286
G1 X185.408 Y171.305 E.01392
G1 X184.896 Y171.357 E.01916
G1 X165.074 Y171.356 E.73829
G1 X164.692 Y171.32 E.01429
G1 X164.076 Y171.13 E.02402
G1 X163.782 Y170.975 E.01238
G1 X163.529 Y170.784 E.0118
G1 X163.283 Y170.522 E.01337
G1 X163.082 Y170.216 E.01365
G1 X162.941 Y169.899 E.01292
G1 X162.844 Y169.521 E.01453
G1 X162.864 Y169.409 E.00426
G1 X162.976 Y169.35 E.00473
G1 X163.158 Y169.35 E.00678
G1 X163.262 Y169.398 E.00426
G1 X163.369 Y169.737 E.01325
G1 X163.501 Y170.018 E.01157
G1 X163.651 Y170.235 E.00981
G1 X163.91 Y170.491 E.01355
G1 X164.001 Y170.558 E.00422
G1 X164.416 Y170.778 E.0175
G1 X164.728 Y170.865 E.01204
G1 X165.028 Y170.9 E.01127
G1 X184.96 Y170.9 E.74238
G1 X185.624 Y170.766 E.02523
G1 X185.85 Y170.662 E.00929
G1 X186.058 Y170.52 E.00936
G1 X186.289 Y170.307 E.01169
G1 X186.406 Y170.152 E.00726
G1 X186.628 Y169.734 E.01762
G1 X186.709 Y169.445 E.01118
G1 X186.783 Y169.357 E.00426
G1 X186.907 Y169.35 E.00462
; WIPE_START
G1 X187.022 Y169.343 E-.04389
G1 X187.127 Y169.391 E-.04347
G1 X187.155 Y169.519 E-.04998
G1 X187.02 Y169.982 E-.18311
G1 X186.831 Y170.356 E-.1595
G1 X186.618 Y170.638 E-.13407
G1 X186.37 Y170.869 E-.12868
G1 X186.332 Y170.894 E-.0173
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X178.845 Y169.412 Z.6 F60000
G1 X165.4 Y166.75 Z.6
G1 Z.2
G1 E.8 F1800
; FEATURE: Outer wall
G1 F3000
M204 S500
G1 X184.6 Y166.75 E.71513
G1 X184.6 Y168.75 E.07449
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X165.4 Y168.75 E.71513
G1 X165.4 Y166.81 E.07226
M204 S6000
G1 X165.857 Y167.207 F60000
; FEATURE: Inner wall
G1 F3000
M204 S500
G1 X184.143 Y167.207 E.68108
G1 X184.143 Y168.293 E.04044
G1 X165.857 Y168.293 E.68108
G1 X165.857 Y167.267 E.03821
M204 S6000
G1 X166.086 Y167.75 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.67172
G1 F3000
M204 S500
M73 P49 R6
G1 X183.914 Y167.75 E.91353
; CHANGE_LAYER
; Z_HEIGHT: 0.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F3000
G1 X181.914 Y167.75 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 2/47
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
G3 Z.6 I1.14 J.426 P1  F60000
G1 X187.881 Y151.795 Z.6
G1 Z.4
G1 E.8 F1800
; FEATURE: Support interface
; LINE_WIDTH: 0.42
G1 F4797
M204 S8000
G1 X187.125 Y151.038 E.03289
G1 X185.884 Y151.038 E.03811
G1 X187.712 Y152.866 E.07941
G1 X187.712 Y154.106 E.03811
G1 X184.644 Y151.038 E.13331
G1 X183.403 Y151.038 E.03811
G1 X187.712 Y155.347 E.18721
G1 X187.712 Y156.587 E.03811
G1 X182.163 Y151.038 E.24111
G1 X180.923 Y151.038 E.03811
G1 X187.712 Y157.827 E.29501
G1 X187.712 Y159.068 E.03811
G1 X179.682 Y151.038 E.34891
G1 X178.442 Y151.038 E.03811
G1 X187.712 Y160.308 E.40281
G1 X187.712 Y161.548 E.03811
G1 X177.202 Y151.038 E.45671
G1 X175.961 Y151.038 E.03811
G1 X187.712 Y162.789 E.51061
G1 X187.712 Y164.029 E.03811
G1 X174.721 Y151.038 E.56451
G1 X173.481 Y151.038 E.03811
G1 X187.712 Y165.269 E.61841
G1 X187.712 Y166.51 E.03811
G1 X172.24 Y151.038 E.67231
G1 X171 Y151.038 E.03811
G1 X187.523 Y167.562 E.71802
G1 X186.283 Y167.562 E.03811
G1 X185.538 Y166.817 E.03235
G1 X185.538 Y166.127 E.02121
M73 P49 R5
G1 X185.223 Y165.812 E.01371
G1 X184.533 Y165.812 E.02121
G1 X169.759 Y151.038 E.64197
G1 X168.519 Y151.038 E.03811
G1 X183.292 Y165.812 E.64197
G1 X182.052 Y165.812 E.03811
G1 X167.279 Y151.038 E.64197
G1 X166.038 Y151.038 E.03811
G1 X180.812 Y165.812 E.64197
G1 X179.571 Y165.812 E.03811
G1 X164.798 Y151.038 E.64197
G1 X163.558 Y151.038 E.03811
G1 X178.331 Y165.812 E.64197
G1 X177.09 Y165.812 E.03811
G1 X162.288 Y151.038 E.6426
G1 X162.288 Y152.25 E.03722
G1 X175.85 Y165.812 E.58933
G1 X174.61 Y165.812 E.03811
G1 X162.288 Y153.49 E.53543
G1 X162.288 Y154.731 E.03811
G1 X173.369 Y165.812 E.48153
G1 X172.129 Y165.812 E.03811
G1 X162.288 Y155.971 E.42763
G1 X162.288 Y157.211 E.03811
G1 X170.889 Y165.812 E.37373
G1 X169.648 Y165.812 E.03811
G1 X162.288 Y158.452 E.31983
G1 X162.288 Y159.692 E.03811
G1 X168.408 Y165.812 E.26593
G1 X167.168 Y165.812 E.03811
G1 X162.288 Y160.932 E.21203
G1 X162.288 Y162.173 E.03811
G1 X165.927 Y165.812 E.15813
G1 X164.777 Y165.812 E.03534
G1 X164.732 Y165.857 E.00196
M73 P50 R5
G1 X162.288 Y163.413 E.10619
G1 X162.288 Y164.653 E.03811
G1 X164.462 Y166.827 E.09444
G1 X164.462 Y167.562 E.02258
G1 X163.956 Y167.562 E.01553
G1 X162.288 Y165.894 E.07248
G1 X162.288 Y167.134 E.03811
G1 X162.886 Y167.731 E.02595
; WIPE_START
G1 F4800
G1 X162.288 Y167.134 E-.32094
G1 X162.288 Y165.979 E-.43907
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z.8 I-.423 J1.141 P1  F60000
G1 X166.009 Y167.359 Z.8
G1 Z.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F4797
M204 S8000
G1 X183.991 Y167.359 E.59649
G1 X183.991 Y168.141 E.02593
G1 X166.009 Y168.141 E.59649
G1 X166.009 Y167.419 E.02394
M204 S10000
G1 X165.602 Y166.952 F60000
G1 F4797
M204 S8000
G1 X184.398 Y166.952 E.62349
G1 X184.398 Y168.548 E.05294
G1 X165.602 Y168.548 E.62349
G1 X165.602 Y167.012 E.05095
M204 S250
G1 X165.21 Y166.56 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4797
M204 S5000
G1 X184.79 Y166.56 E.60164
G1 X184.79 Y168.94 E.07313
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X165.21 Y168.94 E.60164
G1 X165.21 Y166.62 E.07129
; WIPE_START
G1 F9547.055
M204 S8000
G1 X167.21 Y166.614 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X166.213 Y167.75 Z.8 F60000
G1 Z.4
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.41758
G1 F4797
M204 S8000
G1 X183.787 Y167.75 E.53656
; CHANGE_LAYER
; Z_HEIGHT: 0.6
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9608.712
G1 X181.787 Y167.75 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 3/47
; update layer progress
M73 L3
M991 S0 P2 ;notify layer change

; OBJECT_ID: 15
M204 S10000
G17
G3 Z.8 I.004 J1.217 P1  F60000
G1 X187.115 Y167.731 Z.8
G1 Z.6
G1 E.8 F1800
; FEATURE: Support interface
; LINE_WIDTH: 0.42
G1 F4771
M204 S8000
G1 X187.712 Y167.134 E.02594
G1 X187.712 Y165.894 E.03811
G1 X186.044 Y167.562 E.07247
G1 X185.538 Y167.562 E.01553
G1 X185.538 Y166.827 E.02258
G1 X187.712 Y164.654 E.09443
G1 X187.712 Y163.413 E.03811
G1 X185.268 Y165.857 E.10618
G1 X185.223 Y165.812 E.00196
G1 X184.073 Y165.812 E.03534
G1 X187.712 Y162.173 E.15812
G1 X187.712 Y160.932 E.03811
G1 X182.832 Y165.812 E.21202
G1 X181.592 Y165.812 E.03811
G1 X187.712 Y159.692 E.26592
G1 X187.712 Y158.452 E.03811
G1 X180.352 Y165.812 E.31982
G1 X179.111 Y165.812 E.03811
G1 X187.712 Y157.211 E.37372
G1 X187.712 Y155.971 E.03811
G1 X177.871 Y165.812 E.42762
G1 X176.631 Y165.812 E.03811
G1 X187.712 Y154.731 E.48152
G1 X187.712 Y153.49 E.03811
G1 X175.39 Y165.812 E.53542
G1 X174.15 Y165.812 E.03811
G1 X187.712 Y152.25 E.58932
G1 X187.712 Y151.038 E.03722
G1 X172.91 Y165.812 E.64259
G1 X171.669 Y165.812 E.03811
G1 X186.442 Y151.038 E.64197
G1 X185.202 Y151.038 E.03811
G1 X170.429 Y165.812 E.64196
G1 X169.188 Y165.812 E.03811
G1 X183.962 Y151.038 E.64196
G1 X182.721 Y151.038 E.03811
G1 X167.948 Y165.812 E.64196
G1 X166.708 Y165.812 E.03811
G1 X181.481 Y151.038 E.64196
G1 X180.24 Y151.038 E.03811
G1 X165.467 Y165.812 E.64197
G1 X164.777 Y165.812 E.02121
G1 X164.462 Y166.127 E.01371
G1 X164.462 Y166.817 E.02121
G1 X163.717 Y167.562 E.03234
G1 X162.477 Y167.562 E.03811
G1 X179 Y151.038 E.71801
G1 X177.76 Y151.038 E.03811
G1 X162.288 Y166.51 E.6723
G1 X162.288 Y165.269 E.03811
M73 P51 R5
G1 X176.519 Y151.038 E.6184
G1 X175.279 Y151.038 E.03811
G1 X162.288 Y164.029 E.5645
G1 X162.288 Y162.789 E.03811
G1 X174.039 Y151.038 E.5106
G1 X172.798 Y151.038 E.03811
G1 X162.288 Y161.548 E.4567
G1 X162.288 Y160.308 E.03811
G1 X171.558 Y151.038 E.4028
G1 X170.318 Y151.038 E.03811
G1 X162.288 Y159.068 E.3489
G1 X162.288 Y157.827 E.03811
G1 X169.077 Y151.038 E.295
G1 X167.837 Y151.038 E.03811
G1 X162.288 Y156.587 E.2411
G1 X162.288 Y155.346 E.03811
G1 X166.596 Y151.038 E.1872
G1 X165.356 Y151.038 E.03811
G1 X162.288 Y154.106 E.13331
G1 X162.288 Y152.866 E.03811
G1 X164.116 Y151.038 E.07941
G1 X162.875 Y151.038 E.03811
G1 X162.119 Y151.795 E.03288
; COOLING_NODE: 0
; WIPE_START
G1 F4800
G1 X162.875 Y151.038 E-.40661
G1 X163.805 Y151.038 E-.35339
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z1 I-1.206 J.163 P1  F60000
G1 X166.009 Y167.359 Z1
G1 Z.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F4771
M204 S8000
G1 X183.991 Y167.359 E.59649
G1 X183.991 Y168.141 E.02593
G1 X166.009 Y168.141 E.59649
G1 X166.009 Y167.419 E.02394
; COOLING_NODE: 0
M204 S10000
G1 X165.602 Y166.952 F60000
G1 F4771
M204 S8000
G1 X184.398 Y166.952 E.62349
G1 X184.398 Y168.548 E.05294
G1 X165.602 Y168.548 E.62349
G1 X165.602 Y167.012 E.05095
; COOLING_NODE: 0
M204 S250
G1 X165.21 Y166.56 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1413
M204 S5000
G1 X184.79 Y166.56 E.60164
G1 X184.79 Y168.94 E.07313
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X165.21 Y168.94 E.60164
G1 X165.21 Y166.62 E.07129
; WIPE_START
G1 F9547.055
M204 S8000
G1 X167.21 Y166.614 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X166.213 Y167.75 Z1 F60000
G1 Z.6
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.41758
G1 F4771
M204 S8000
G1 X183.787 Y167.75 E.53656
; CHANGE_LAYER
; Z_HEIGHT: 0.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9608.712
G1 X181.787 Y167.75 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 4/47
; update layer progress
M73 L4
M991 S0 P3 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z1 I.03 J-1.217 P1  F60000
G1 X166.009 Y167.359 Z1
G1 Z.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X183.991 Y167.359 E.59649
G1 X183.991 Y168.141 E.02593
G1 X166.009 Y168.141 E.59649
G1 X166.009 Y167.419 E.02394
; COOLING_NODE: 0
M204 S10000
G1 X165.602 Y166.952 F60000
G1 F1200
M204 S8000
M73 P52 R5
G1 X184.398 Y166.952 E.62349
G1 X184.398 Y168.548 E.05294
G1 X165.602 Y168.548 E.62349
G1 X165.602 Y167.012 E.05095
; COOLING_NODE: 0
M204 S250
G1 X165.21 Y166.56 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X184.79 Y166.56 E.60164
G1 X184.79 Y168.94 E.07313
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X165.21 Y168.94 E.60164
G1 X165.21 Y166.62 E.07129
; WIPE_START
G1 F9547.055
M204 S8000
G1 X167.21 Y166.614 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X166.213 Y167.75 Z1.2 F60000
G1 Z.8
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.41758
G1 F1200
M204 S8000
G1 X183.787 Y167.75 E.53656
; CHANGE_LAYER
; Z_HEIGHT: 1
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9608.712
G1 X181.787 Y167.75 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 5/47
; update layer progress
M73 L5
M991 S0 P4 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 1
M204 S10000
G17
G3 Z1.2 I.112 J-1.212 P1  F60000
G1 X166.416 Y166.334 Z1.2
G1 Z1
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
M204 S8000
G1 X165.816 Y166.334 E.0199
G1 F1680
G1 X165.4 Y166.334 E.01381
G1 F1141.768
G1 X165.2 Y166.334 E.00663
G1 F941.979
G1 X164.8 Y166.334 E.01327
; FEATURE: Overhang wall
G1 F600
M204 S5000
G1 X163.516 Y166.334 E.04259
G1 X163.516 Y155.991 E.34308
G1 X163.683 Y155.935 E.00583
G2 X167.186 Y152.434 I2.068 J-1.434 E.29208
G1 X167.241 Y152.266 E.00587
M73 P53 R5
G1 X182.759 Y152.266 E.51473
G1 X182.814 Y152.434 E.00585

G2 X186.315 Y155.936 I1.44 J2.061 E.29128
G1 X186.484 Y155.991 E.00589
G1 X186.484 Y166.334 E.3431
G1 X185.2 Y166.334 E.04259
; FEATURE: Inner wall
G1 F941.979
M204 S8000
G1 X184.8 Y166.334 E.01327
G1 F1141.768
G1 X184.6 Y166.334 E.00663
G1 F1680
G1 X184.184 Y166.334 E.01381
G1 F1800
G1 X183.584 Y166.334 E.0199
G1 F2070.674
G1 X183.584 Y166.533 E.00659
G1 F2673.038
G1 X183.584 Y166.933 E.01327
G1 F3352.202
G1 X183.584 Y167.333 E.01327
G1 F4110.748
G1 X183.584 Y167.734 E.01331
G1 F4943.761
G1 X183.184 Y167.734 E.01327
G1 F5853.575
G1 X182.784 Y167.734 E.01327
G1 F6840.189
G1 X182.384 Y167.734 E.01327
G1 F7903.602
G1 X181.984 Y167.734 E.01327
G1 F8843.478
G1 X181.584 Y167.734 E.01327
G1 X168.016 Y167.734 E.45006
G1 X167.616 Y167.734 E.01327
G1 F8459.039
G1 X167.216 Y167.734 E.01327
G1 F7357.567
G1 X166.816 Y167.734 E.01327
G1 F6332.895
G1 X166.416 Y167.734 E.01327
G1 F5385.023
G1 X166.416 Y167.333 E.01331
G1 F4511.245
G1 X166.416 Y166.933 E.01327
G1 F3717.223
G1 X166.416 Y166.533 E.01327
G1 F3000
G1 X166.416 Y166.394 E.0046
; COOLING_NODE: 1
; WIPE_START
G1 X165.816 Y166.334 E-.22914
G1 X165.4 Y166.334 E-.15816
G1 X165.2 Y166.334 E-.076
G1 X164.8 Y166.334 E-.152
G1 X164.419 Y166.334 E-.1447
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z1.4 I.666 J1.019 P1  F60000
G1 X185.686 Y152.434 Z1.4
G1 Z1
G1 E.8 F1800
; FEATURE: Overhang wall
G1 F600
M204 S5000
G1 X185.741 Y152.266 E.00587
G1 X186.484 Y152.266 E.02463
G1 X186.484 Y153.009 E.02463
G1 X186.317 Y153.065 E.00583
G2 X185.734 Y152.471 I-2.668 J2.039 E.02768
; COOLING_NODE: 1
; WIPE_START
M204 S8000
G1 X185.741 Y152.266 E-.0779
G1 X186.484 Y152.266 E-.28213
G1 X186.484 Y153.009 E-.28219
G1 X186.317 Y153.065 E-.06681
G1 X186.231 Y152.962 E-.05098
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z1.4 I-.754 J-.956 P1  F60000
G1 X182.608 Y155.819 Z1.4
G1 Z1
G1 E.8 F1800
G1 F600
M204 S5000
G1 X182.387 Y155.491 E.01311
G3 X184.029 Y152.401 I1.861 J-.992 E.13689
G1 X184.239 Y152.39 E.00697
G3 X182.643 Y155.867 I.009 J2.109 E.28061
; COOLING_NODE: 1
M204 S250
G1 X182.943 Y155.591 F60000
G1 F600
M204 S5000
G1 X182.747 Y155.299 E.01166
M73 P54 R5
G3 X184.072 Y152.807 I1.502 J-.8 E.11044
G1 X184.241 Y152.797 E.00563
G3 X182.982 Y155.636 I.007 J1.702 E.22497
; COOLING_NODE: 1
M204 S250
G1 X183.246 Y155.341 F60000
G1 F600
M204 S5000
G3 X184.113 Y153.197 I1.003 J-.842 E.09403
G1 X184.244 Y153.19 E.00434
G3 X183.286 Y155.386 I.005 J1.31 E.17257
; COOLING_NODE: 1
; WIPE_START
M204 S8000
G1 X183.093 Y155.115 E-.12642
G1 X182.997 Y154.882 E-.09578
G1 X182.947 Y154.636 E-.09536
G1 X182.946 Y154.369 E-.1014
G1 X182.997 Y154.117 E-.0977
G1 X183.093 Y153.885 E-.0956
G1 X183.246 Y153.658 E-.10372
G1 X183.328 Y153.577 E-.04402
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z1.4 I-.204 J-1.2 P1  F60000
G1 X165.53 Y156.597 Z1.4
G1 Z1
G1 E.8 F1800
G1 F600
M204 S5000
G3 X165.529 Y152.401 I.218 J-2.098 E.20529
G1 X165.739 Y152.39 E.00697
G3 X165.59 Y156.602 I.009 J2.109 E.22535
; COOLING_NODE: 1
M204 S250
G1 X165.573 Y156.192 F60000
G1 F600
M204 S5000
G3 X165.572 Y152.807 I.176 J-1.693 E.16563
G1 X165.741 Y152.797 E.00563
G3 X165.632 Y156.197 I.007 J1.702 E.18145
; COOLING_NODE: 2
M204 S250
G1 X165.614 Y155.802 F60000
G1 F600
M204 S5000
G3 X165.613 Y153.197 I.136 J-1.302 E.12743
G1 X165.744 Y153.19 E.00434
G3 X165.673 Y155.807 I.005 J1.31 E.13917
; COOLING_NODE: 2
; WIPE_START
M204 S8000
G1 X165.346 Y155.747 E-.12633
G1 X165.12 Y155.649 E-.09361
G1 X164.908 Y155.504 E-.09749
G1 X164.746 Y155.341 E-.08747
G1 X164.593 Y155.115 E-.1038
G1 X164.497 Y154.882 E-.09578
G1 X164.447 Y154.636 E-.09536
G1 X164.447 Y154.478 E-.06016
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z1.4 I1.071 J-.579 P1  F60000
G1 X163.683 Y153.065 Z1.4
G1 Z1
G1 E.8 F1800
G1 F600
M204 S5000
G1 X163.516 Y153.009 E.00583
G1 X163.516 Y152.266 E.02463
G1 X164.259 Y152.266 E.02462
G1 X164.314 Y152.434 E.00585
G2 X163.72 Y153.017 I2.02 J2.651 E.0277
; COOLING_NODE: 2
; WIPE_START
M204 S8000
G1 X163.516 Y153.009 E-.0774
G1 X163.516 Y152.266 E-.28218
G1 X164.259 Y152.266 E-.28208
G1 X164.314 Y152.434 E-.06703
G1 X164.21 Y152.52 E-.05131
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z1.4 I-1.207 J.153 P1  F60000
G1 X166.009 Y166.741 Z1.4
G1 Z1
G1 E.8 F1800
; FEATURE: Inner wall
G1 F1868.544
M204 S8000
G1 X165.583 Y166.741 E.01415
M73 P55 R5
G1 F1340.829
G1 X165.183 Y166.741 E.01327
G1 F925.411
G1 X164.8 Y166.741 E.01269
; FEATURE: Overhang wall
G1 F600
M204 S5000
G1 X163.109 Y166.741 E.05609
G1 X163.109 Y151.859 E.49365
G1 X186.891 Y151.859 E.78888
G1 X186.891 Y166.741 E.49365
G1 F3000
G1 X185.2 Y166.741 E.05609
; FEATURE: Inner wall
G1 F1800
M204 S8000
G1 X184.818 Y166.741 E.01269
G1 F2364.214
G1 X184.418 Y166.741 E.01327
G1 F3050.629
G1 X183.991 Y166.741 E.01415
G1 F3773.556
G1 X183.991 Y167.141 E.01327
G1 F4573.283
G1 X183.991 Y167.541 E.01327
G1 F5449.809
G1 X183.991 Y167.941 E.01327
G1 F5916.873
G1 X183.991 Y168.141 E.00663
G1 F6908.599
G1 X183.591 Y168.141 E.01327
G1 F7977.126
G1 X183.191 Y168.141 E.01327
G1 F8843.478
G1 X182.791 Y168.141 E.01327
G1 X166.009 Y168.141 E.55668
G1 X166.009 Y166.801 E.04445
; COOLING_NODE: 2
M204 S10000
G1 X165.602 Y167.148 F60000
G1 F1363.113
M204 S8000
G1 X165.183 Y167.148 E.01392
G1 F925.411
G1 X164.8 Y167.148 E.01269
; FEATURE: Overhang wall
G1 F600
M204 S5000
G1 X162.702 Y167.148 E.06959
G1 X162.702 Y151.452 E.52066
G1 X187.298 Y151.452 E.81589
G1 X187.298 Y167.148 E.52066
G1 F3000
M73 P56 R5
G1 X185.2 Y167.148 E.06959
; FEATURE: Inner wall
G1 F1800
M204 S8000
G1 X184.818 Y167.148 E.01269
G1 F2393.773
G1 X184.398 Y167.148 E.01392
G1 F3038.542
G1 X184.398 Y167.548 E.01327
G1 F3760.112
G1 X184.398 Y167.948 E.01327
G1 F4558.481
G1 X184.398 Y168.348 E.01327
G1 F4986.465
G1 X184.398 Y168.548 E.00663
G1 F5900.035
G1 X183.998 Y168.548 E.01327
G1 F6890.404
G1 X183.598 Y168.548 E.01327
G1 F7957.573
G1 X183.198 Y168.548 E.01327
G1 F8843.478
G1 X182.798 Y168.548 E.01327
G1 X165.602 Y168.548 E.57042
G1 X165.602 Y167.208 E.04445
; COOLING_NODE: 0
M204 S250
G1 X165.21 Y167.54 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F951.503
M204 S5000
G1 X165.169 Y167.54 E.00126
G1 F912.73
G1 X164.8 Y167.54 E.01134
; FEATURE: Overhang wall
; LINE_WIDTH: 0.45
G1 F600
G1 X162.31 Y167.54 E.0826
G1 X162.31 Y151.06 E.54667
G1 X187.69 Y151.06 E.8419
G1 X187.69 Y167.54 E.54667
G1 F3000
G1 X185.2 Y167.54 E.0826
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
M73 P57 R5
G1 F1492
G1 X184.831 Y167.54 E.01134
G1 X184.79 Y167.54 E.00126
G1 X184.79 Y167.94 E.01229
G1 X184.79 Y168.34 E.01229
G1 X184.79 Y168.74 E.01229
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X184.79 Y168.94 E.00615
G1 X184.39 Y168.94 E.01229
G1 X183.99 Y168.94 E.01229
G1 X183.59 Y168.94 E.01229
G1 X183.19 Y168.94 E.01229
G1 X182.79 Y168.94 E.01229
G1 X182.39 Y168.94 E.01229
G1 X165.21 Y168.94 E.52789
G1 X165.21 Y167.6 E.04117
; WIPE_START
G1 F9547.055
M204 S8000
G1 X165.169 Y167.54 E-.02761
G1 X164.8 Y167.54 E-.14022
G1 X163.242 Y167.54 E-.59217
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X166.58 Y167.399 Z1.4 F60000
G1 Z1
G1 E.8 F1800
; FEATURE: Bridge
; LINE_WIDTH: 0.42237
G1 F3000
M204 S8000
G1 X183.251 Y167.399 E.51547
G1 X183.251 Y167.02 E.01173
G1 X166.749 Y167.02 E.51022
G1 X166.749 Y166.64 E.01173
G1 X183.251 Y166.64 E.51022
G1 X183.251 Y166.261 E.01173
G1 X166.749 Y166.261 E.51022
G1 X166.749 Y166.001 E.00805
G1 X163.849 Y166.001 E.08967
G1 X163.849 Y165.882 E.00368
M73 P57 R4
G1 X186.151 Y165.882 E.68956
G1 X186.151 Y165.502 E.01173
G1 X163.849 Y165.502 E.68956
G1 X163.849 Y165.123 E.01173
G1 X186.151 Y165.123 E.68956
G1 X186.151 Y164.743 E.01173
M73 P58 R4
G1 X163.849 Y164.743 E.68956
G1 X163.849 Y164.364 E.01173
G1 X186.151 Y164.364 E.68956
G1 X186.151 Y163.984 E.01173
G1 X163.849 Y163.984 E.68956
G1 X163.849 Y163.605 E.01173
G1 X186.151 Y163.605 E.68956
G1 X186.151 Y163.225 E.01173
G1 X163.849 Y163.225 E.68956
G1 X163.849 Y162.846 E.01173
G1 X186.151 Y162.846 E.68956
G1 X186.151 Y162.466 E.01173
G1 X163.849 Y162.466 E.68956
G1 X163.849 Y162.087 E.01173
G1 X186.151 Y162.087 E.68956
G1 X186.151 Y161.708 E.01173
G1 X163.849 Y161.708 E.68956
G1 X163.849 Y161.328 E.01173
G1 X186.151 Y161.328 E.68956
G1 X186.151 Y160.949 E.01173
G1 X163.849 Y160.949 E.68956
G1 X163.849 Y160.569 E.01173
G1 X186.151 Y160.569 E.68956
G1 X186.151 Y160.19 E.01173
G1 X163.849 Y160.19 E.68956
G1 X163.849 Y159.81 E.01173
G1 X186.151 Y159.81 E.68956
G1 X186.151 Y159.431 E.01173
G1 X163.849 Y159.431 E.68956
G1 X163.849 Y159.051 E.01173
M73 P59 R4
G1 X186.151 Y159.051 E.68956
G1 X186.151 Y158.672 E.01173
G1 X163.849 Y158.672 E.68956
G1 X163.849 Y158.293 E.01173
G1 X186.151 Y158.293 E.68956
G1 X186.151 Y157.913 E.01173
G1 X163.849 Y157.913 E.68956
G1 X163.849 Y157.534 E.01173
G1 X186.151 Y157.534 E.68956
G1 X186.151 Y157.154 E.01173
G1 X185.285 Y157.154 E.02677
G3 X183.234 Y157.154 I-1.026 J-2.574 E.06497
G1 X166.785 Y157.154 E.5086
G2 X167.454 Y156.775 I-.982 J-2.512 E.02387
G1 X182.545 Y156.775 E.46662
G1 X182.233 Y156.517 E.01251
G1 X182.133 Y156.395 E.00488
G1 X167.876 Y156.395 E.44082
G2 X168.162 Y156.016 I-2.205 J-1.959 E.01471
G1 X181.838 Y156.016 E.42288
G3 X181.637 Y155.636 I1.736 J-1.163 E.0133
G1 X168.36 Y155.636 E.41055
G2 X168.497 Y155.257 I-2.641 J-1.17 E.01249
G1 X181.506 Y155.257 E.40224
G1 X181.43 Y154.877 E.01197
G1 X168.571 Y154.877 E.3976
G2 X168.602 Y154.498 I-3.725 J-.495 E.01178
G1 X181.398 Y154.498 E.39568
G3 X181.427 Y154.119 I1.993 J-.04 E.01178
G1 X168.57 Y154.119 E.39756
G1 X168.493 Y153.739 E.01197
G1 X181.505 Y153.739 E.40231
G3 X181.649 Y153.36 I1.334 J.291 E.0126
G1 X168.351 Y153.36 E.41118
G2 X168.159 Y152.98 I-1.359 J.448 E.01319
G1 X181.841 Y152.98 E.42303
G3 X181.915 Y152.867 I.576 J.295 E.0042
G1 X181.694 Y152.702 E.00853
G1 X181.769 Y152.601 E.00389
G1 X167.643 Y152.601 E.43678
M204 S10000
G1 X167.022 Y152.282 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.345545
G1 F11895.92
M204 S8000
G1 X166.665 Y152.212 E.00896
; LINE_WIDTH: 0.322739
G1 F12865.49
G1 X166.547 Y152.193 E.00273
; LINE_WIDTH: 0.2815
G1 F15000
G1 X166.419 Y152.171 E.00253
; LINE_WIDTH: 0.24784
G1 X166.312 Y152.159 E.00179
; LINE_WIDTH: 0.221669
G1 X166.198 Y152.145 E.00168
; LINE_WIDTH: 0.178615
G1 X165.497 Y152.131 E.00775
; LINE_WIDTH: 0.198828
G1 X165.252 Y152.15 E.00312
; LINE_WIDTH: 0.231963
G1 X165.146 Y152.164 E.00165
; LINE_WIDTH: 0.260402
G1 X165.029 Y152.179 E.0021
; LINE_WIDTH: 0.296704
G1 F14185.303
G1 X164.91 Y152.2 E.00249
; LINE_WIDTH: 0.356073
G1 F11495.996
G2 X164.479 Y152.285 I1.394 J8.256 E.01121
; WIPE_START
G1 X164.91 Y152.2 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z1.4 I-.729 J-.975 P1  F60000
G1 X163.534 Y153.229 Z1.4
G1 Z1
G1 E.8 F1800
; LINE_WIDTH: 0.357475
G1 F11444.762
M204 S8000
G1 X163.468 Y153.555 E.00851
; LINE_WIDTH: 0.334285
G1 F12355.653
G1 X163.448 Y153.67 E.00278
; LINE_WIDTH: 0.291825
G1 F14463.379
G1 X163.426 Y153.797 E.00261
; LINE_WIDTH: 0.255547
G1 F15000
G1 X163.412 Y153.916 E.00207
; LINE_WIDTH: 0.225398
G1 X163.396 Y154.043 E.0019
; LINE_WIDTH: 0.182951
G1 X163.374 Y154.498 E.0052
G1 X163.397 Y154.967 E.00536
; LINE_WIDTH: 0.226509
G1 X163.412 Y155.083 E.00175
; LINE_WIDTH: 0.256417
G1 X163.427 Y155.211 E.00223
; LINE_WIDTH: 0.291533
G1 F14480.341
G1 X163.446 Y155.32 E.00225
; LINE_WIDTH: 0.346001
G1 F11878.028
G2 X163.533 Y155.771 I9.648 J-1.613 E.01133
M204 S10000
G1 X163.72 Y156.385 F60000
; LINE_WIDTH: 0.114755
G1 F15000
M204 S8000
G1 X163.907 Y156.532 E.00139
M204 S10000
G1 X163.68 Y157.154 F60000
; FEATURE: Bridge
; LINE_WIDTH: 0.42237
G1 F3000
M204 S8000
G1 X165.387 Y157.154 E.05279
; WIPE_START
G1 X163.68 Y157.154 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z1.4 I.286 J1.183 P1  F60000
M73 P60 R4
G1 X182.207 Y152.669 Z1.4
G1 Z1
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.116965
G1 F15000
M204 S8000
G1 X182.362 Y152.47 E.00152
M204 S10000
G1 X182.979 Y152.285 F60000
; LINE_WIDTH: 0.356073
G1 F11495.976
M204 S8000
G3 X183.41 Y152.2 I1.827 J8.178 E.01121
; LINE_WIDTH: 0.296704
G1 F14185.303
G1 X183.529 Y152.179 E.00249
; LINE_WIDTH: 0.260402
G1 F15000
G1 X183.646 Y152.164 E.0021
; LINE_WIDTH: 0.231963
G1 X183.752 Y152.15 E.00165
; LINE_WIDTH: 0.198828
G1 X183.997 Y152.131 E.00312
; LINE_WIDTH: 0.178615
G1 X184.698 Y152.145 E.00775
; LINE_WIDTH: 0.221669
G1 X184.812 Y152.159 E.00168
; LINE_WIDTH: 0.24784
G1 X184.919 Y152.171 E.00179
; LINE_WIDTH: 0.2815
G1 X185.047 Y152.193 E.00253
; LINE_WIDTH: 0.322739
G1 F12865.49
G1 X185.165 Y152.212 E.00273
; LINE_WIDTH: 0.345545
G1 F11895.92
G1 X185.522 Y152.282 E.00896
; WIPE_START
G1 X185.165 Y152.212 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z1.4 I-.749 J.959 P1  F60000
G1 X186.467 Y153.229 Z1.4
G1 Z1
G1 E.8 F1800
; LINE_WIDTH: 0.346114
G1 F11873.606
M204 S8000
G3 X186.553 Y153.679 I-9.187 J2 E.01132
; LINE_WIDTH: 0.291711
G1 F14470.017
G1 X186.572 Y153.788 E.00225
; LINE_WIDTH: 0.256557
G1 F15000
G1 X186.588 Y153.916 E.00225
; LINE_WIDTH: 0.226516
G1 X186.603 Y154.033 E.00176
; LINE_WIDTH: 0.183045
G1 X186.626 Y154.497 E.0053
G1 X186.603 Y154.961 E.00531
; LINE_WIDTH: 0.235749
G1 X186.579 Y155.168 E.00328
; LINE_WIDTH: 0.281264
G1 X186.557 Y155.297 E.00253
; LINE_WIDTH: 0.32247
G1 F12877.856
G1 X186.538 Y155.415 E.00272
; LINE_WIDTH: 0.345229
G1 F11908.345
G1 X186.468 Y155.772 E.00896
M204 S10000
G1 X186.28 Y156.384 F60000
; LINE_WIDTH: 0.114004
G1 F15000
M204 S8000
G1 X186.098 Y156.527 E.00134
; CHANGE_LAYER
; Z_HEIGHT: 1.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F15000
G1 X186.28 Y156.384 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 6/47
; update layer progress
M73 L6
M991 S0 P5 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 1
M204 S10000
G17
G3 Z1.4 I.537 J-1.092 P1  F60000
G1 X181.764 Y154.163 Z1.4
G1 Z1.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X181.742 Y154.286 E.00413
G2 X186.314 Y155.937 I2.508 J.213 E.21856
G1 X186.484 Y155.992 E.00591
G1 X186.484 Y166.334 E.34307
G1 X183.584 Y166.334 E.0962
G1 X183.584 Y167.734 E.04644
G1 X166.416 Y167.734 E.56948
G1 X166.416 Y166.334 E.04644
G1 X163.516 Y166.334 E.0962
G1 X163.516 Y155.993 E.34303
G1 X163.682 Y155.936 E.00581
G2 X167.186 Y152.435 I2.067 J-1.436 E.29196
G1 X167.241 Y152.266 E.00589
G1 X182.757 Y152.266 E.51471
G1 X182.814 Y152.432 E.0058
G2 X181.828 Y153.811 I1.436 J2.067 E.05734
G1 X181.775 Y154.104 E.0099
; COOLING_NODE: 1
M204 S10000
G1 X182.163 Y154.236 F60000
G1 F8843.478
M204 S8000
G1 X182.221 Y153.922 E.0106
G3 X184.027 Y152.402 I2.029 J.577 E.08312
G1 X184.225 Y152.39 E.00657
G3 X182.148 Y154.32 I.024 J2.109 E.33643
G1 X182.152 Y154.295 E.00083
; COOLING_NODE: 1
M204 S10000
G1 X182.562 Y154.309 F60000
G1 F8843.478
M204 S8000
G1 X182.613 Y154.033 E.00931
G3 X184.071 Y152.807 I1.637 J.466 E.06707
G1 X184.229 Y152.797 E.00527
G3 X182.553 Y154.368 I.02 J1.702 E.27101
; COOLING_NODE: 1
M204 S250
G1 X182.946 Y154.38 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9506
M204 S5000
G1 X182.99 Y154.14 E.00749
G3 X184.113 Y153.197 I1.259 J.359 E.04781
G1 X184.233 Y153.19 E.00371
G3 X182.942 Y154.439 I.016 J1.309 E.19193
; COOLING_NODE: 1
; WIPE_START
G1 F9547.055
M204 S8000
G1 X182.99 Y154.14 E-.11531
G1 X183.083 Y153.904 E-.09614
G1 X183.231 Y153.677 E-.10329
G1 X183.407 Y153.497 E-.09555
G1 X183.615 Y153.354 E-.09588
G1 X183.866 Y153.247 E-.1037
G1 X184.113 Y153.197 E-.09571
G1 X184.233 Y153.19 E-.04589
G1 X184.256 Y153.192 E-.00852
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z1.6 I.569 J1.076 P1  F60000
G1 X185.686 Y152.435 Z1.6
G1 Z1.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X185.741 Y152.266 E.00589
G1 X186.484 Y152.266 E.02465
G1 X186.484 Y153.007 E.02458
G1 X186.318 Y153.064 E.00581
G2 X185.733 Y152.472 I-2.682 J2.064 E.02767
; COOLING_NODE: 1
; WIPE_START
G1 X185.741 Y152.266 E-.07814
G1 X186.484 Y152.266 E-.28234
G1 X186.484 Y153.007 E-.28163
G1 X186.318 Y153.064 E-.06651
G1 X186.231 Y152.961 E-.05138
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z1.6 I-.113 J-1.212 P1  F60000
G1 X163.724 Y155.059 Z1.6
G1 Z1.2
G1 E.8 F1800
G1 F8843.478
M204 S8000
G1 X163.687 Y154.939 E.00417
G3 X165.527 Y152.402 I2.062 J-.44 E.11722
G1 X165.725 Y152.39 E.00657
G3 X163.818 Y155.347 I.024 J2.109 E.30151
G1 X163.743 Y155.116 E.00807
; COOLING_NODE: 1
M204 S10000
G1 X164.11 Y154.934 F60000
G1 F8843.478
M204 S8000
G1 X164.085 Y154.854 E.00278
G3 X165.571 Y152.807 I1.664 J-.355 E.0946
G1 X165.729 Y152.797 E.00527
G3 X164.192 Y155.184 I.02 J1.702 E.24328
G1 X164.129 Y154.991 E.00672
; COOLING_NODE: 2
M204 S250
G1 X164.482 Y154.815 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9506
M204 S5000
G1 X164.469 Y154.773 E.00134
G3 X165.613 Y153.197 I1.28 J-.273 E.06745
G1 X165.733 Y153.19 E.00371
G3 X164.551 Y155.027 I.016 J1.309 E.1734
G1 X164.501 Y154.872 E.00502
; COOLING_NODE: 2
; WIPE_START
G1 F9547.055
M204 S8000
G1 X164.469 Y154.773 E-.03943
G1 X164.447 Y154.637 E-.0521
G1 X164.445 Y154.386 E-.09544
G1 X164.49 Y154.14 E-.09517
G1 X164.583 Y153.904 E-.09615
G1 X164.731 Y153.677 E-.10329
G1 X164.907 Y153.497 E-.09555
G1 X165.115 Y153.354 E-.09588
G1 X165.326 Y153.264 E-.08699
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z1.6 I.148 J-1.208 P1  F60000
G1 X163.685 Y153.064 Z1.6
G1 Z1.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X163.516 Y153.009 E.00589
G1 X163.516 Y152.266 E.02465
G1 X164.257 Y152.266 E.02458
G1 X164.314 Y152.432 E.0058
G2 X163.722 Y153.017 I2.071 J2.689 E.02767
; COOLING_NODE: 2
; WIPE_START
G1 X163.516 Y153.009 E-.07816
G1 X163.516 Y152.266 E-.28232
G1 X164.257 Y152.266 E-.28161
G1 X164.314 Y152.432 E-.0665
G1 X164.21 Y152.52 E-.05142
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z1.6 I-1.207 J.153 P1  F60000
G1 X166.009 Y166.741 Z1.6
G1 Z1.2
G1 E.8 F1800
G1 F8843.478
M204 S8000
G1 X163.109 Y166.741 E.0962
G1 X163.109 Y151.859 E.49365
G1 X186.891 Y151.859 E.78888
G1 X186.891 Y166.741 E.49365
G1 X183.991 Y166.741 E.0962
G1 X183.991 Y168.141 E.04644
G1 X166.009 Y168.141 E.59649
G1 X166.009 Y166.801 E.04445
; COOLING_NODE: 2
M204 S10000
G1 X165.602 Y167.148 F60000
G1 F8843.478
M204 S8000
G1 X162.702 Y167.148 E.0962
G1 X162.702 Y151.452 E.52066
G1 X187.298 Y151.452 E.81589
G1 X187.298 Y167.148 E.52066
G1 X184.398 Y167.148 E.0962
G1 X184.398 Y168.548 E.04644
G1 X165.602 Y168.548 E.62349
G1 X165.602 Y167.208 E.04445
; COOLING_NODE: 0
M204 S250
G1 X165.21 Y167.54 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1566
M204 S5000
G1 X162.31 Y167.54 E.08911
G1 X162.31 Y151.06 E.50639
G1 X187.69 Y151.06 E.77986
G1 X187.69 Y167.54 E.50639
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X184.79 Y167.54 E.08911
G1 X184.79 Y168.94 E.04302
G1 X165.21 Y168.94 E.60164
M73 P61 R4
G1 X165.21 Y167.6 E.04117
; WIPE_START
G1 F9547.055
M204 S8000
G1 X163.21 Y167.559 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z1.6 I1.214 J.091 P1  F60000
G1 X164.04 Y156.562 Z1.6
G1 Z1.2
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42234
G1 F9488.165
M204 S8000
G1 X163.849 Y156.752 E.00831
G1 X163.849 Y157.289 E.01659
G1 X164.236 Y156.902 E.0169
G2 X164.579 Y157.096 I.811 J-1.035 E.01222
G1 X163.849 Y157.825 E.03188
G1 X163.849 Y158.362 E.01659
G1 X164.97 Y157.241 E.04899
G1 X165.423 Y157.325 E.01424
G1 X163.849 Y158.898 E.06879
G1 X163.849 Y159.435 E.01659
G1 X165.943 Y157.341 E.09154
G1 X166.098 Y157.331 E.00482
G1 X166.6 Y157.221 E.01589
G1 X163.849 Y159.972 E.12028
G1 X163.849 Y160.508 E.01659
G1 X171.758 Y152.599 E.3458
G1 X172.295 Y152.599 E.01659
G1 X163.849 Y161.045 E.36926
G1 X163.849 Y161.581 E.01659
G1 X172.831 Y152.599 E.39273
G1 X173.368 Y152.599 E.01659
G1 X163.849 Y162.118 E.41619
G1 X163.849 Y162.654 E.01659
G1 X173.904 Y152.599 E.43965
G1 X174.441 Y152.599 E.01659
G1 X163.849 Y163.191 E.46311
G1 X163.849 Y163.728 E.01659
G1 X174.978 Y152.599 E.48657
G1 X175.514 Y152.599 E.01659
G1 X163.849 Y164.264 E.51003
G1 X163.849 Y164.801 E.01659
G1 X176.051 Y152.599 E.5335
G1 X176.587 Y152.599 E.01659
G1 X163.849 Y165.337 E.55696
G1 X163.849 Y165.874 E.01659
G1 X177.124 Y152.599 E.58042
G1 X177.661 Y152.599 E.01659
G1 X164.259 Y166.001 E.58596
G1 X164.796 Y166.001 E.01659
G1 X178.197 Y152.599 E.58596
G1 X178.734 Y152.599 E.01659
G1 X165.333 Y166.001 E.58596
G1 X165.869 Y166.001 E.01659
G1 X179.27 Y152.599 E.58596
G1 X179.807 Y152.599 E.01659
G1 X166.406 Y166.001 E.58596
G1 X166.749 Y166.001 E.01063
G1 X166.749 Y166.193 E.00596
G1 X180.343 Y152.599 E.59439
G1 X180.88 Y152.599 E.01659
G1 X166.749 Y166.73 E.61785
G1 X166.749 Y167.267 E.01659
G1 X181.417 Y152.599 E.64131
G1 X181.953 Y152.599 E.01659
G1 X167.152 Y167.401 E.64717
G1 X167.689 Y167.401 E.01659
G1 X181.577 Y153.512 E.60728
G1 X181.505 Y153.727 E.00702
G1 X181.417 Y154.209 E.01515
G1 X168.225 Y167.401 E.57678
G1 X168.762 Y167.401 E.01659
G1 X181.413 Y154.749 E.55317
G2 X181.491 Y155.208 I2.865 J-.253 E.01439
G1 X169.298 Y167.401 E.53313
G1 X169.835 Y167.401 E.01659
G1 X181.633 Y155.602 E.51587
G2 X181.809 Y155.963 I1.009 J-.27 E.01248
G1 X170.372 Y167.401 E.50011
G1 X170.908 Y167.401 E.01659
G1 X182.029 Y156.28 E.48624
G2 X182.282 Y156.563 I2.823 J-2.272 E.01175
G1 X171.445 Y167.401 E.47386
G1 X171.981 Y167.401 E.01659
G1 X182.581 Y156.8 E.46348
G2 X182.906 Y157.013 I.882 J-.995 E.01203
G1 X172.518 Y167.401 E.45421
G1 X173.054 Y167.401 E.01659
G1 X183.277 Y157.178 E.44697
G2 X183.704 Y157.287 I.587 J-1.409 E.01369
G1 X173.591 Y167.401 E.4422
G1 X174.128 Y167.401 E.01659
G1 X184.181 Y157.347 E.43957
G2 X184.772 Y157.292 I.077 J-2.378 E.01842
G1 X174.664 Y167.401 E.44197
G1 X175.201 Y167.401 E.01659
G1 X185.585 Y157.016 E.45406
G1 X185.916 Y156.8 E.01222
G1 X186.09 Y157.027 E.00885
G1 X186.151 Y156.987 E.00223
G1 X175.737 Y167.401 E.45531
G1 X176.274 Y167.401 E.01659
G1 X186.151 Y157.524 E.43185
G1 X186.151 Y158.061 E.01659
G1 X176.811 Y167.401 E.40839
G1 X177.347 Y167.401 E.01659
G1 X186.151 Y158.597 E.38493
G1 X186.151 Y159.134 E.01659
G1 X177.884 Y167.401 E.36146
G1 X178.42 Y167.401 E.01659
G1 X186.151 Y159.67 E.338
G1 X186.151 Y160.207 E.01659
G1 X178.957 Y167.401 E.31454
G1 X179.493 Y167.401 E.01659
G1 X186.151 Y160.743 E.29108
G1 X186.151 Y161.28 E.01659
G1 X180.03 Y167.401 E.26762
G1 X180.567 Y167.401 E.01659
M73 P62 R4
G1 X186.151 Y161.817 E.24416
G1 X186.151 Y162.353 E.01659
G1 X181.103 Y167.401 E.22069
G1 X181.64 Y167.401 E.01659
G1 X186.151 Y162.89 E.19723
G1 X186.151 Y163.426 E.01659
G1 X182.176 Y167.401 E.17377
G1 X182.713 Y167.401 E.01659
G1 X183.251 Y166.863 E.02351
G1 X183.251 Y167.4 E.01659
G1 X183.08 Y167.57 E.00746
; WIPE_START
G1 X183.251 Y167.4 E-.09175
G1 X183.251 Y166.863 E-.2039
G1 X182.713 Y167.401 E-.28892
G1 X182.251 Y167.401 E-.17543
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z1.6 I.716 J.984 P1  F60000
G1 X183.943 Y166.17 Z1.6
G1 Z1.2
G1 E.8 F1800
G1 F9488.165
M204 S8000
G1 X186.151 Y163.963 E.09651
G1 X186.151 Y164.5 E.01659
G1 X184.649 Y166.001 E.06563
G1 X185.186 Y166.001 E.01659
G1 X186.151 Y165.036 E.04217
G1 X186.151 Y165.573 E.01659
G1 X185.553 Y166.17 E.02613
M204 S10000
G1 X186.115 Y156.511 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.112566
G1 F15000
M204 S8000
G1 X186.28 Y156.38 E.0012
M204 S10000
G1 X186.47 Y155.773 F60000
; LINE_WIDTH: 0.332008
G1 F12452.98
M204 S8000
G1 X186.544 Y155.38 E.00942
; LINE_WIDTH: 0.311998
G1 F13379.021
G1 X186.562 Y155.273 E.00237
; LINE_WIDTH: 0.275535
G1 F15000
G1 X186.58 Y155.156 E.00225
; LINE_WIDTH: 0.243505
G1 X186.594 Y155.038 E.00194
; LINE_WIDTH: 0.215746
G1 X186.608 Y154.912 E.00179
; LINE_WIDTH: 0.177046
G1 X186.619 Y154.242 E.00732
; LINE_WIDTH: 0.199702
G1 X186.599 Y153.996 E.00316
; LINE_WIDTH: 0.235413
G1 X186.583 Y153.876 E.0019
; LINE_WIDTH: 0.268673
G1 X186.565 Y153.743 E.00246
; LINE_WIDTH: 0.308019
G1 F13579.855
G1 X186.544 Y153.627 E.00254
; LINE_WIDTH: 0.368126
G1 F11069.923
G2 X186.464 Y153.229 I-8.312 J1.471 E.01077
M204 S10000
G1 X185.522 Y152.282 F60000
; LINE_WIDTH: 0.346019
G1 F11877.337
M204 S8000
G1 X185.167 Y152.213 E.00893
; LINE_WIDTH: 0.325675
G1 F12731.903
G1 X185.063 Y152.195 E.00242
; LINE_WIDTH: 0.288293
G1 F14671.572
G1 X184.949 Y152.176 E.00232
; LINE_WIDTH: 0.254591
G1 F15000
G1 X184.83 Y152.161 E.00206
; LINE_WIDTH: 0.224425
G1 X184.703 Y152.146 E.0019
; LINE_WIDTH: 0.178841
G1 X184.456 Y152.129 E.00274
G1 X183.994 Y152.131 E.00511
; LINE_WIDTH: 0.199091
G1 X183.752 Y152.151 E.0031
; LINE_WIDTH: 0.232063
G1 X183.646 Y152.164 E.00165
; LINE_WIDTH: 0.26049
G1 X183.528 Y152.179 E.00209
; LINE_WIDTH: 0.296792
G1 F14180.403
G1 X183.41 Y152.2 E.00249
; LINE_WIDTH: 0.356196
G1 F11491.476
G2 X182.979 Y152.285 I1.368 J8.101 E.01122
; WIPE_START
G1 X183.41 Y152.2 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z1.6 I-.269 J-1.187 P1  F60000
G1 X168.169 Y155.652 Z1.6
G1 Z1.2
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42234
G1 F9488.165
M204 S8000
G1 X171.222 Y152.599 E.13348
G1 X170.685 Y152.599 E.01659
G1 X168.594 Y154.69 E.09143
G1 X168.581 Y154.167 E.01619
G1 X170.148 Y152.599 E.06854
G1 X169.612 Y152.599 E.01659
G1 X168.49 Y153.721 E.04906
G2 X168.34 Y153.335 I-1.361 J.307 E.01286
G1 X169.075 Y152.599 E.03216
G1 X168.539 Y152.599 E.01659
G1 X168.032 Y153.106 E.02215
M204 S10000
G1 X167.761 Y152.635 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.112445
G1 F15000
M204 S8000
G1 X167.63 Y152.47 E.0012
M204 S10000
G1 X167.022 Y152.282 F60000
; LINE_WIDTH: 0.346019
G1 F11877.337
M204 S8000
G1 X166.667 Y152.213 E.00893
; LINE_WIDTH: 0.325675
G1 F12731.903
G1 X166.563 Y152.195 E.00242
; LINE_WIDTH: 0.288293
G1 F14671.572
G1 X166.449 Y152.176 E.00232
; LINE_WIDTH: 0.254591
G1 F15000
G1 X166.33 Y152.161 E.00206
; LINE_WIDTH: 0.224425
G1 X166.203 Y152.146 E.0019
; LINE_WIDTH: 0.178841
G1 X165.956 Y152.129 E.00274
G1 X165.494 Y152.131 E.00511
; LINE_WIDTH: 0.199091
G1 X165.252 Y152.151 E.0031
; LINE_WIDTH: 0.232063
G1 X165.146 Y152.164 E.00165
; LINE_WIDTH: 0.26049
G1 X165.028 Y152.179 E.00209
; LINE_WIDTH: 0.296792
G1 F14180.403
G1 X164.91 Y152.2 E.00249
; LINE_WIDTH: 0.356195
G1 F11491.497
G2 X164.479 Y152.285 I1.366 J8.094 E.01122
M204 S10000
G1 X163.53 Y153.228 F60000
; LINE_WIDTH: 0.334662
G1 F12339.702
M204 S8000
G1 X163.457 Y153.613 E.00932
; LINE_WIDTH: 0.314093
G1 F13275.69
G1 X163.439 Y153.722 E.00245
; LINE_WIDTH: 0.276506
G1 F15000
G1 X163.42 Y153.842 E.00231
; LINE_WIDTH: 0.244125
G1 X163.407 Y153.958 E.00191
; LINE_WIDTH: 0.216847
G1 X163.393 Y154.082 E.00176
; LINE_WIDTH: 0.177292
G1 X163.381 Y154.757 E.0074
; LINE_WIDTH: 0.199681
G1 X163.401 Y155.005 E.00317
; LINE_WIDTH: 0.235427
G1 X163.417 Y155.125 E.0019
; LINE_WIDTH: 0.268704
G1 X163.435 Y155.257 E.00246
; LINE_WIDTH: 0.308008
G1 F13580.4
G1 X163.456 Y155.372 E.00254
; LINE_WIDTH: 0.368029
G1 F11073.217
G2 X163.536 Y155.771 I8.27 J-1.463 E.01077
; CHANGE_LAYER
; Z_HEIGHT: 1.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F11073.217
G1 X163.456 Y155.372 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 7/47
; update layer progress
M73 L7
M991 S0 P6 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 1
M204 S10000
G17
G3 Z1.6 I.07 J1.215 P1  F60000
G1 X181.741 Y154.318 Z1.6
G1 Z1.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X181.74 Y154.502 E.0061
G2 X186.315 Y155.936 I2.515 J-.007 E.21092
G1 X186.484 Y155.991 E.00589
G1 X186.484 Y166.334 E.3431
G1 X183.584 Y166.334 E.0962
G1 X183.584 Y167.734 E.04644
G1 X166.416 Y167.734 E.56948
G1 X166.416 Y166.334 E.04644
G1 X163.516 Y166.334 E.0962
G1 X163.516 Y155.991 E.34308
G1 X163.683 Y155.935 E.00583
G2 X167.186 Y152.434 I2.068 J-1.434 E.29208
G1 X167.241 Y152.266 E.00587
G1 X182.759 Y152.266 E.51473
G1 X182.814 Y152.434 E.00585
G2 X181.752 Y154.251 I1.44 J2.061 E.07206
G1 X181.751 Y154.258 E.00023
; COOLING_NODE: 1
M204 S10000
G1 X182.15 Y154.379 F60000
G1 F8843.478
M204 S8000
G1 X182.149 Y154.291 E.00295
G3 X184.029 Y152.401 I2.099 J.208 E.0957
G1 X184.239 Y152.39 E.00697
G3 X182.15 Y154.716 I.009 J2.109 E.32278
G1 X182.15 Y154.439 E.00918
; COOLING_NODE: 1
M204 S10000
G1 X182.556 Y154.379 F60000
G1 F8843.478
M204 S8000
G1 X182.555 Y154.331 E.0016
G3 X184.072 Y152.807 I1.693 J.169 E.0772
G1 X184.241 Y152.797 E.00563
G3 X182.556 Y154.675 I.007 J1.702 E.26042
G1 X182.556 Y154.439 E.00784
; COOLING_NODE: 1
M204 S250
G1 X182.946 Y154.378 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9450
M204 S5000
G1 X182.946 Y154.369 E.00028
G3 X184.113 Y153.197 I1.303 J.13 E.05501
G1 X184.244 Y153.19 E.00402
G3 X182.947 Y154.636 I.005 J1.31 E.18558
G1 X182.946 Y154.438 E.00608
; COOLING_NODE: 1
; WIPE_START
G1 F9547.055
M204 S8000
G1 X182.946 Y154.369 E-.02623
G1 X182.997 Y154.117 E-.0977
G1 X183.093 Y153.885 E-.0956
G1 X183.246 Y153.658 E-.10372
G1 X183.421 Y153.486 E-.09338
G1 X183.615 Y153.354 E-.08943
G1 X183.866 Y153.247 E-.10345
G1 X184.113 Y153.197 E-.09582
G1 X184.244 Y153.19 E-.04976
G1 X184.257 Y153.191 E-.00491
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z1.8 I.569 J1.076 P1  F60000
G1 X185.686 Y152.434 Z1.8
G1 Z1.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X185.741 Y152.266 E.00587
G1 X186.484 Y152.266 E.02463
G1 X186.484 Y153.009 E.02463
G1 X186.317 Y153.065 E.00583
G2 X185.734 Y152.471 I-2.668 J2.039 E.02768
; COOLING_NODE: 1
; WIPE_START
G1 X185.741 Y152.266 E-.0779
G1 X186.484 Y152.266 E-.28213
G1 X186.484 Y153.009 E-.28219
G1 X186.317 Y153.065 E-.06681
G1 X186.231 Y152.962 E-.05098
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z1.8 I-.109 J-1.212 P1  F60000
G1 X163.704 Y154.981 Z1.8
G1 Z1.4
G1 E.8 F1800
G1 F8843.478
M204 S8000
G1 X163.65 Y154.716 E.00896
G3 X165.529 Y152.401 I2.098 J-.217 E.10984
G1 X165.739 Y152.39 E.00697
G3 X163.73 Y155.114 I.009 J2.109 E.30932
G1 X163.716 Y155.04 E.00249
; COOLING_NODE: 1
M204 S10000
G1 X164.102 Y154.901 F60000
G1 F8843.478
M204 S8000
G1 X164.056 Y154.675 E.00764
G3 X165.572 Y152.807 I1.693 J-.176 E.08865
G1 X165.741 Y152.797 E.00563
G3 X164.121 Y154.996 I.007 J1.702 E.24956
G1 X164.114 Y154.96 E.0012
; COOLING_NODE: 2
M204 S250
G1 X164.485 Y154.824 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9450
M204 S5000
G1 X164.447 Y154.636 E.00589
G3 X165.613 Y153.197 I1.302 J-.137 E.06322
G1 X165.744 Y153.19 E.00402
G3 X164.497 Y154.883 I.005 J1.31 E.17783
; COOLING_NODE: 2
; WIPE_START
G1 F9547.055
M204 S8000
G1 X164.447 Y154.636 E-.09561
G1 X164.446 Y154.369 E-.1014
G1 X164.497 Y154.117 E-.0977
G1 X164.593 Y153.885 E-.0956
G1 X164.746 Y153.658 E-.10372
G1 X164.921 Y153.486 E-.09338
G1 X165.115 Y153.354 E-.08943
G1 X165.317 Y153.268 E-.08317
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z1.8 I.15 J-1.208 P1  F60000
G1 X163.683 Y153.065 Z1.8
G1 Z1.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X163.516 Y153.009 E.00583
G1 X163.516 Y152.266 E.02463
G1 X164.259 Y152.266 E.02462
G1 X164.314 Y152.434 E.00585
G2 X163.72 Y153.017 I2.019 J2.651 E.0277
; COOLING_NODE: 2
; WIPE_START
G1 X163.516 Y153.009 E-.0774
G1 X163.516 Y152.266 E-.28218
G1 X164.259 Y152.266 E-.28208
G1 X164.314 Y152.434 E-.06703
G1 X164.21 Y152.52 E-.05131
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z1.8 I-1.207 J.153 P1  F60000
G1 X166.009 Y166.741 Z1.8
G1 Z1.4
G1 E.8 F1800
G1 F8843.478
M204 S8000
G1 X163.109 Y166.741 E.0962
G1 X163.109 Y151.859 E.49365
G1 X186.891 Y151.859 E.78888
G1 X186.891 Y166.741 E.49365
G1 X183.991 Y166.741 E.0962
G1 X183.991 Y168.141 E.04644
G1 X166.009 Y168.141 E.59649
G1 X166.009 Y166.801 E.04445
; COOLING_NODE: 2
M204 S10000
G1 X165.602 Y167.148 F60000
G1 F8843.478
M204 S8000
G1 X162.702 Y167.148 E.0962
G1 X162.702 Y151.452 E.52066
G1 X187.298 Y151.452 E.81589
G1 X187.298 Y167.148 E.52066
G1 X184.398 Y167.148 E.0962
G1 X184.398 Y168.548 E.04644
G1 X165.602 Y168.548 E.62349
G1 X165.602 Y167.208 E.04445
; COOLING_NODE: 0
M204 S250
G1 X165.21 Y167.54 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1648
M204 S5000
G1 X162.31 Y167.54 E.08911
G1 X162.31 Y151.06 E.50639
G1 X187.69 Y151.06 E.77986
G1 X187.69 Y167.54 E.50639
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X184.79 Y167.54 E.08911
G1 X184.79 Y168.94 E.04302
M73 P63 R4
G1 X165.21 Y168.94 E.60164
G1 X165.21 Y167.6 E.04117
; WIPE_START
G1 F9547.055
M204 S8000
G1 X163.21 Y167.559 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X166.925 Y167.57 Z1.8 F60000
G1 Z1.4
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42325
G1 F9465.464
M204 S8000
G1 X166.749 Y167.394 E.00771
G1 X166.749 Y166.857 E.01667
G1 X167.463 Y167.57 E.03128
; WIPE_START
G1 X166.749 Y166.857 E-.42714
G1 X166.749 Y167.394 E-.22764
G1 X166.925 Y167.57 E-.10522
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z1.8 I.676 J-1.012 P1  F60000
G1 X163.68 Y165.4 Z1.8
G1 Z1.4
G1 E.8 F1800
G1 F9465.464
M204 S8000
G1 X164.28 Y166.001 E.0263
G1 X164.818 Y166.001 E.01667
G1 X163.849 Y165.032 E.04244
G1 X163.849 Y164.494 E.01667
G1 X165.356 Y166.001 E.06601
G1 X165.893 Y166.001 E.01667
G1 X163.849 Y163.957 E.08959
G1 X163.849 Y163.419 E.01667
G1 X167.831 Y167.401 E.17452
G1 X168.369 Y167.401 E.01667
G1 X163.849 Y162.881 E.1981
G1 X163.849 Y162.343 E.01667
G1 X168.907 Y167.401 E.22167
G1 X169.445 Y167.401 E.01667
G1 X163.849 Y161.805 E.24525
G1 X163.849 Y161.267 E.01667
G1 X169.983 Y167.401 E.26882
G1 X170.521 Y167.401 E.01667
G1 X163.849 Y160.729 E.29239
G1 X163.849 Y160.191 E.01667
G1 X171.059 Y167.401 E.31597
G1 X171.596 Y167.401 E.01667
G1 X163.849 Y159.654 E.33954
G1 X163.849 Y159.116 E.01667
G1 X172.134 Y167.401 E.36312
G1 X172.672 Y167.401 E.01667
G1 X163.849 Y158.578 E.38669
G1 X163.849 Y158.04 E.01667
G1 X173.21 Y167.401 E.41027
G1 X173.748 Y167.401 E.01667
G1 X163.849 Y157.502 E.43384
G1 X163.849 Y156.983 E.0161
G1 X163.934 Y157.049 E.00332
G1 X174.286 Y167.401 E.45371
G1 X174.824 Y167.401 E.01667
G1 X164.459 Y157.036 E.45426
G2 X165.268 Y157.307 I1.28 J-2.479 E.02654
G1 X175.361 Y167.401 E.44239
G1 X175.899 Y167.401 E.01667
G1 X165.846 Y157.347 E.44065
G2 X166.328 Y157.291 I-.149 J-3.395 E.01505
G1 X176.437 Y167.401 E.44309
G1 X176.975 Y167.401 E.01667
G1 X166.744 Y157.169 E.44844
G2 X167.115 Y157.003 I-.607 J-1.854 E.01264
G1 X177.513 Y167.401 E.45573
G1 X178.051 Y167.401 E.01667
G1 X167.439 Y156.788 E.46512
G1 X167.733 Y156.545 E.01184
G1 X178.589 Y167.401 E.47581
G1 X179.127 Y167.401 E.01667
G1 X167.989 Y156.263 E.48814
G2 X168.202 Y155.938 I-.987 J-.879 E.01208
G1 X179.664 Y167.401 E.50238
G1 X180.202 Y167.401 E.01667
G1 X168.387 Y155.585 E.51788
G2 X168.513 Y155.174 I-2.8 J-1.088 E.01335
G1 X180.74 Y167.401 E.5359
G1 X181.278 Y167.401 E.01667
G1 X168.591 Y154.713 E.55608
G2 X168.579 Y154.163 I-2.998 J-.209 E.01707
G1 X181.816 Y167.401 E.58018
G1 X182.354 Y167.401 E.01667
G1 X168.378 Y153.425 E.61255
G2 X167.872 Y152.599 I-2.157 J.755 E.03023
G1 X168.091 Y152.599 E.00678
G1 X182.892 Y167.401 E.64872
G1 X183.251 Y167.401 E.01112
G1 X183.251 Y167.222 E.00555
G1 X168.628 Y152.599 E.64088
G1 X169.166 Y152.599 E.01667
G1 X183.251 Y166.684 E.6173
G1 X183.251 Y166.146 E.01667
G1 X169.704 Y152.599 E.59373
G1 X170.242 Y152.599 E.01667
G1 X183.643 Y166.001 E.58736
G1 X184.181 Y166.001 E.01667
G1 X170.78 Y152.599 E.58736
G1 X171.318 Y152.599 E.01667
G1 X184.719 Y166.001 E.58736
G1 X185.257 Y166.001 E.01667
G1 X171.856 Y152.599 E.58736
G1 X172.393 Y152.599 E.01667
G1 X185.795 Y166.001 E.58736
G1 X186.151 Y166.001 E.01103
G1 X186.151 Y165.819 E.00564
G1 X172.931 Y152.599 E.57939
G1 X173.469 Y152.599 E.01667
G1 X186.151 Y165.281 E.55581
G1 X186.151 Y164.743 E.01667
M73 P64 R4
G1 X174.007 Y152.599 E.53224
G1 X174.545 Y152.599 E.01667
G1 X186.151 Y164.205 E.50867
G1 X186.151 Y163.667 E.01667
G1 X175.083 Y152.599 E.48509
G1 X175.621 Y152.599 E.01667
G1 X186.151 Y163.129 E.46152
G1 X186.151 Y162.591 E.01667
G1 X176.159 Y152.599 E.43794
G1 X176.696 Y152.599 E.01667
G1 X186.151 Y162.054 E.41437
G1 X186.151 Y161.516 E.01667
G1 X177.234 Y152.599 E.39079
G1 X177.772 Y152.599 E.01667
G1 X186.32 Y161.148 E.37466
; WIPE_START
G1 X184.906 Y159.733 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z1.8 I1.183 J.284 P1  F60000
G1 X186.467 Y153.229 Z1.8
G1 Z1.4
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.346114
G1 F11873.606
M204 S8000
G3 X186.553 Y153.679 I-9.187 J2 E.01132
; LINE_WIDTH: 0.291711
G1 F14470.017
G1 X186.572 Y153.788 E.00225
; LINE_WIDTH: 0.256557
G1 F15000
G1 X186.588 Y153.916 E.00225
; LINE_WIDTH: 0.226516
G1 X186.603 Y154.033 E.00176
; LINE_WIDTH: 0.183045
G1 X186.626 Y154.497 E.0053
G1 X186.603 Y154.961 E.00531
; LINE_WIDTH: 0.235746
G1 X186.579 Y155.168 E.00328
; LINE_WIDTH: 0.281201
G1 X186.557 Y155.296 E.00252
; LINE_WIDTH: 0.322313
G1 F12885.093
G1 X186.538 Y155.414 E.00272
; LINE_WIDTH: 0.345012
G1 F11916.895
G1 X186.468 Y155.772 E.00897
M204 S10000
G1 X186.28 Y156.384 F60000
; LINE_WIDTH: 0.114025
G1 F15000
M204 S8000
G1 X186.098 Y156.527 E.00134
M204 S10000
G1 X186.32 Y157.382 F60000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42325
G1 F9465.464
M204 S8000
G1 X185.811 Y156.873 E.02234
G3 X185.472 Y157.072 I-.847 J-1.048 E.01222
G1 X186.151 Y157.751 E.02972
G1 X186.151 Y158.289 E.01667
G1 X185.088 Y157.226 E.04658
G3 X184.645 Y157.321 I-1.083 J-3.979 E.01405
G1 X186.151 Y158.826 E.066
G1 X186.151 Y159.364 E.01667
G1 X184.132 Y157.346 E.08847
G3 X183.494 Y157.246 I.123 J-2.874 E.02004
G1 X186.151 Y159.902 E.11642
G1 X186.151 Y160.44 E.01667
G1 X178.31 Y152.599 E.34364
G1 X178.848 Y152.599 E.01667
G1 X181.506 Y155.258 E.1165
G1 X181.414 Y154.799 E.01451
G1 X181.404 Y154.618 E.0056
G1 X179.386 Y152.599 E.08847
G1 X179.924 Y152.599 E.01667
G1 X181.429 Y154.105 E.06599
G3 X181.524 Y153.662 I2.295 J.259 E.01407
G1 X180.462 Y152.599 E.04656
G1 X180.999 Y152.599 E.01667
G1 X181.681 Y153.282 E.0299
G3 X181.87 Y152.932 I1.273 J.46 E.01235
G1 X181.368 Y152.43 E.02201
M204 S10000
G1 X182.207 Y152.669 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.116973
G1 F15000
M204 S8000
G1 X182.362 Y152.47 E.00152
M204 S10000
G1 X182.979 Y152.285 F60000
; LINE_WIDTH: 0.356016
G1 F11498.091
M204 S8000
G3 X183.41 Y152.2 I1.827 J8.177 E.01121
; LINE_WIDTH: 0.296703
G1 F14185.353
G1 X183.529 Y152.179 E.00248
; LINE_WIDTH: 0.260417
G1 F15000
G1 X183.646 Y152.164 E.0021
; LINE_WIDTH: 0.231968
G1 X183.752 Y152.15 E.00165
; LINE_WIDTH: 0.198828
G1 X183.997 Y152.131 E.00312
; LINE_WIDTH: 0.178609
G1 X184.698 Y152.145 E.00775
; LINE_WIDTH: 0.221608
G1 X184.812 Y152.159 E.00168
; LINE_WIDTH: 0.247686
G1 X184.918 Y152.171 E.00179
; LINE_WIDTH: 0.281371
G1 X185.047 Y152.193 E.00254
; LINE_WIDTH: 0.32275
G1 F12864.955
G1 X185.166 Y152.213 E.00274
; LINE_WIDTH: 0.345644
G1 F11892.032
G1 X185.522 Y152.282 E.00895
; WIPE_START
G1 X185.166 Y152.213 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z1.8 I-.005 J-1.217 P1  F60000
G1 X167.022 Y152.282 Z1.8
G1 Z1.4
G1 E.8 F1800
G1 F11892.032
M204 S8000
G1 X166.666 Y152.213 E.00895
; LINE_WIDTH: 0.32275
G1 F12864.955
G1 X166.547 Y152.193 E.00274
; LINE_WIDTH: 0.281371
G1 F15000
G1 X166.418 Y152.171 E.00254
; LINE_WIDTH: 0.247686
G1 X166.312 Y152.159 E.00179
; LINE_WIDTH: 0.221608
G1 X166.198 Y152.145 E.00168
; LINE_WIDTH: 0.178609
G1 X165.497 Y152.131 E.00775
; LINE_WIDTH: 0.198828
G1 X165.252 Y152.15 E.00312
; LINE_WIDTH: 0.231968
G1 X165.146 Y152.164 E.00165
; LINE_WIDTH: 0.260417
G1 X165.029 Y152.179 E.0021
; LINE_WIDTH: 0.296703
G1 F14185.353
G1 X164.91 Y152.2 E.00248
; LINE_WIDTH: 0.356016
G1 F11498.097
G2 X164.479 Y152.285 I1.395 J8.259 E.01121
M204 S10000
G1 X163.534 Y153.229 F60000
; LINE_WIDTH: 0.357475
G1 F11444.762
M204 S8000
G1 X163.468 Y153.555 E.00851
; LINE_WIDTH: 0.334285
G1 F12355.653
G1 X163.448 Y153.67 E.00278
; LINE_WIDTH: 0.291825
G1 F14463.379
G1 X163.426 Y153.797 E.00261
; LINE_WIDTH: 0.255547
G1 F15000
G1 X163.412 Y153.916 E.00207
; LINE_WIDTH: 0.225398
G1 X163.396 Y154.043 E.0019
; LINE_WIDTH: 0.182951
G1 X163.374 Y154.498 E.0052
G1 X163.397 Y154.967 E.00536
; LINE_WIDTH: 0.226524
G1 X163.412 Y155.083 E.00175
; LINE_WIDTH: 0.256421
G1 X163.427 Y155.211 E.00223
; LINE_WIDTH: 0.291508
G1 F14481.801
G1 X163.446 Y155.32 E.00225
; LINE_WIDTH: 0.345948
G1 F11880.1
G2 X163.533 Y155.771 I9.36 J-1.563 E.01133
M204 S10000
G1 X163.72 Y156.385 F60000
; LINE_WIDTH: 0.114772
G1 F15000
M204 S8000
G1 X163.907 Y156.532 E.00139
; CHANGE_LAYER
; Z_HEIGHT: 1.6
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F15000
G1 X163.72 Y156.385 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 8/47
; update layer progress
M73 L8
M991 S0 P7 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 1
M204 S10000
G17
G3 Z1.8 I.149 J1.208 P1  F60000
G1 X181.764 Y154.163 Z1.8
G1 Z1.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X181.742 Y154.286 E.00413
G2 X186.314 Y155.937 I2.508 J.213 E.21855
G1 X186.484 Y155.992 E.00591
G1 X186.484 Y166.334 E.34307
G1 X183.584 Y166.334 E.0962
G1 X183.584 Y167.734 E.04644
G1 X166.416 Y167.734 E.56948
G1 X166.416 Y166.334 E.04644
G1 X163.516 Y166.334 E.0962
G1 X163.516 Y155.993 E.34303
G1 X163.682 Y155.936 E.00581
G2 X167.186 Y152.435 I2.067 J-1.436 E.29196
G1 X167.241 Y152.266 E.00589
G1 X182.757 Y152.266 E.51471
G1 X182.814 Y152.432 E.0058
G2 X181.828 Y153.811 I1.436 J2.067 E.05734
G1 X181.775 Y154.104 E.0099
; COOLING_NODE: 1
M204 S10000
G1 X182.163 Y154.236 F60000
G1 F8843.478
M204 S8000
G1 X182.221 Y153.922 E.0106
G3 X184.027 Y152.402 I2.029 J.577 E.08313
G1 X184.225 Y152.39 E.00657
G3 X182.148 Y154.32 I.024 J2.109 E.33643
G1 X182.152 Y154.295 E.00083
; COOLING_NODE: 1
M204 S10000
G1 X182.562 Y154.309 F60000
G1 F8843.478
M204 S8000
G1 X182.613 Y154.033 E.00931
G3 X184.071 Y152.807 I1.637 J.466 E.06707
G1 X184.229 Y152.797 E.00527
G3 X182.553 Y154.368 I.02 J1.702 E.27101
; COOLING_NODE: 1
M204 S250
G1 X182.946 Y154.38 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9375
M204 S5000
G1 X182.99 Y154.14 E.00749
G3 X184.113 Y153.197 I1.259 J.359 E.04781
G1 X184.233 Y153.19 E.00371
G3 X182.942 Y154.439 I.016 J1.309 E.19193
; COOLING_NODE: 1
; WIPE_START
G1 F9547.055
M204 S8000
G1 X182.99 Y154.14 E-.11531
G1 X183.083 Y153.904 E-.09614
G1 X183.231 Y153.677 E-.10329
G1 X183.407 Y153.497 E-.09555
G1 X183.615 Y153.354 E-.09588
G1 X183.866 Y153.247 E-.1037
G1 X184.113 Y153.197 E-.09571
G1 X184.233 Y153.19 E-.04589
G1 X184.256 Y153.192 E-.00852
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X185.686 Y152.435 Z2 F60000
G1 Z1.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X185.741 Y152.266 E.00589
G1 X186.484 Y152.266 E.02465
G1 X186.484 Y153.007 E.02458
G1 X186.318 Y153.064 E.00581
G2 X185.733 Y152.472 I-2.682 J2.064 E.02767
; COOLING_NODE: 1
; WIPE_START
G1 X185.741 Y152.266 E-.07814
G1 X186.484 Y152.266 E-.28234
G1 X186.484 Y153.007 E-.28163
G1 X186.318 Y153.064 E-.06651
G1 X186.231 Y152.961 E-.05138
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X178.631 Y153.669 Z2 F60000
G1 X163.724 Y155.059 Z2
G1 Z1.6
G1 E.8 F1800
G1 F8843.478
M204 S8000
G1 X163.687 Y154.939 E.00417
G3 X165.527 Y152.402 I2.062 J-.44 E.11722
G1 X165.725 Y152.39 E.00657
G3 X163.818 Y155.347 I.024 J2.109 E.30151
G1 X163.743 Y155.116 E.00807
; COOLING_NODE: 1
M204 S10000
G1 X164.11 Y154.934 F60000
G1 F8843.478
M204 S8000
G1 X164.085 Y154.854 E.00278
G3 X165.571 Y152.807 I1.664 J-.355 E.0946
G1 X165.729 Y152.797 E.00527
G3 X164.192 Y155.184 I.02 J1.702 E.24328
G1 X164.129 Y154.991 E.00672
; COOLING_NODE: 2
M204 S250
G1 X164.482 Y154.815 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9375
M204 S5000
G1 X164.469 Y154.773 E.00134
G3 X165.613 Y153.197 I1.28 J-.273 E.06745
G1 X165.733 Y153.19 E.00371
G3 X164.551 Y155.027 I.016 J1.309 E.1734
G1 X164.501 Y154.872 E.00502
; COOLING_NODE: 2
; WIPE_START
G1 F9547.055
M204 S8000
G1 X164.469 Y154.773 E-.03943
G1 X164.447 Y154.637 E-.0521
G1 X164.445 Y154.386 E-.09544
G1 X164.49 Y154.14 E-.09517
G1 X164.583 Y153.904 E-.09615
G1 X164.731 Y153.677 E-.10329
G1 X164.907 Y153.497 E-.09555
G1 X165.115 Y153.354 E-.09588
G1 X165.326 Y153.264 E-.08699
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X163.685 Y153.064 Z2 F60000
G1 Z1.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X163.516 Y153.009 E.00589
G1 X163.516 Y152.266 E.02465
G1 X164.257 Y152.266 E.02458
G1 X164.314 Y152.432 E.0058
G2 X163.722 Y153.017 I2.071 J2.688 E.02767
; COOLING_NODE: 2
; WIPE_START
G1 X163.516 Y153.009 E-.07816
G1 X163.516 Y152.266 E-.28233
G1 X164.257 Y152.266 E-.28161
G1 X164.314 Y152.432 E-.0665
G1 X164.21 Y152.519 E-.05141
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X165.168 Y160.092 Z2 F60000
G1 X166.009 Y166.741 Z2
G1 Z1.6
G1 E.8 F1800
G1 F8843.478
M204 S8000
G1 X163.109 Y166.741 E.0962
G1 X163.109 Y151.859 E.49365
G1 X186.891 Y151.859 E.78888
G1 X186.891 Y166.741 E.49365
G1 X183.991 Y166.741 E.0962
G1 X183.991 Y168.141 E.04644
G1 X166.009 Y168.141 E.59649
G1 X166.009 Y166.801 E.04445
; COOLING_NODE: 2
M204 S10000
G1 X165.602 Y167.148 F60000
G1 F8843.478
M204 S8000
G1 X162.702 Y167.148 E.0962
G1 X162.702 Y151.452 E.52066
G1 X187.298 Y151.452 E.81589
G1 X187.298 Y167.148 E.52066
G1 X184.398 Y167.148 E.0962
G1 X184.398 Y168.548 E.04644
G1 X165.602 Y168.548 E.62349
G1 X165.602 Y167.208 E.04445
; COOLING_NODE: 0
M204 S250
G1 X165.21 Y167.54 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1728
M204 S5000
G1 X162.31 Y167.54 E.08911
G1 X162.31 Y151.06 E.50639
G1 X187.69 Y151.06 E.77986
G1 X187.69 Y167.54 E.50639
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X184.79 Y167.54 E.08911
M73 P65 R4
G1 X184.79 Y168.94 E.04302
G1 X165.21 Y168.94 E.60164
G1 X165.21 Y167.6 E.04117
; WIPE_START
G1 F9547.055
M204 S8000
G1 X163.21 Y167.559 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X163.788 Y159.948 Z2 F60000
G1 X164.046 Y156.556 Z2
G1 Z1.6
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42234
G1 F9488.165
M204 S8000
G1 X163.849 Y156.752 E.00858
G1 X163.849 Y157.289 E.01659
G1 X164.228 Y156.91 E.01656
G2 X164.579 Y157.096 I1.06 J-1.573 E.01229
G1 X163.849 Y157.825 E.03189
G1 X163.849 Y158.362 E.01659
G1 X164.97 Y157.241 E.04899
G1 X165.423 Y157.325 E.01424
G1 X163.849 Y158.898 E.06879
G1 X163.849 Y159.435 E.01659
G1 X165.943 Y157.341 E.09154
G1 X166.098 Y157.331 E.00482
G1 X166.6 Y157.221 E.01589
G1 X163.849 Y159.972 E.12028
G1 X163.849 Y160.508 E.01659
G1 X171.758 Y152.599 E.3458
G1 X172.295 Y152.599 E.01659
G1 X163.849 Y161.045 E.36926
G1 X163.849 Y161.581 E.01659
G1 X172.831 Y152.599 E.39273
G1 X173.368 Y152.599 E.01659
G1 X163.849 Y162.118 E.41619
G1 X163.849 Y162.654 E.01659
G1 X173.904 Y152.599 E.43965
G1 X174.441 Y152.599 E.01659
G1 X163.849 Y163.191 E.46311
G1 X163.849 Y163.728 E.01659
G1 X174.978 Y152.599 E.48657
G1 X175.514 Y152.599 E.01659
G1 X163.849 Y164.264 E.51003
G1 X163.849 Y164.801 E.01659
G1 X176.051 Y152.599 E.5335
G1 X176.587 Y152.599 E.01659
G1 X163.849 Y165.337 E.55696
G1 X163.849 Y165.874 E.01659
G1 X177.124 Y152.599 E.58042
G1 X177.661 Y152.599 E.01659
G1 X164.259 Y166.001 E.58596
G1 X164.796 Y166.001 E.01659
G1 X178.197 Y152.599 E.58596
G1 X178.734 Y152.599 E.01659
G1 X165.333 Y166.001 E.58596
G1 X165.869 Y166.001 E.01659
G1 X179.27 Y152.599 E.58596
G1 X179.807 Y152.599 E.01659
G1 X166.406 Y166.001 E.58596
G1 X166.749 Y166.001 E.01063
G1 X166.749 Y166.193 E.00596
G1 X180.343 Y152.599 E.59439
G1 X180.88 Y152.599 E.01659
G1 X166.749 Y166.73 E.61785
G1 X166.749 Y167.267 E.01659
G1 X181.417 Y152.599 E.64131
G1 X181.953 Y152.599 E.01659
G1 X167.152 Y167.401 E.64717
G1 X167.689 Y167.401 E.01659
G1 X181.577 Y153.512 E.60728
G1 X181.505 Y153.727 E.00703
G1 X181.417 Y154.209 E.01515
G1 X168.225 Y167.401 E.57678
G1 X168.762 Y167.401 E.01659
G1 X181.413 Y154.749 E.55317
G2 X181.491 Y155.208 I2.865 J-.253 E.01439
G1 X169.298 Y167.401 E.53313
G1 X169.835 Y167.401 E.01659
G1 X181.633 Y155.602 E.51587
G2 X181.809 Y155.963 I1.009 J-.27 E.01248
G1 X170.372 Y167.401 E.50011
G1 X170.908 Y167.401 E.01659
G1 X182.029 Y156.28 E.48624
G2 X182.282 Y156.563 I2.829 J-2.278 E.01175
G1 X171.445 Y167.401 E.47386
G1 X171.981 Y167.401 E.01659
G1 X182.581 Y156.801 E.46348
G2 X182.906 Y157.013 I.881 J-.994 E.01203
G1 X172.518 Y167.401 E.45421
G1 X173.054 Y167.401 E.01659
G1 X183.277 Y157.178 E.44697
G2 X183.704 Y157.287 I.587 J-1.409 E.01369
M73 P66 R4
G1 X173.591 Y167.401 E.4422
G1 X174.128 Y167.401 E.01659
G1 X184.181 Y157.347 E.43957
G2 X184.772 Y157.292 I.077 J-2.378 E.01842
G1 X174.664 Y167.401 E.44197
G1 X175.201 Y167.401 E.01659
G1 X185.585 Y157.016 E.45406
G1 X185.916 Y156.8 E.01222
G1 X186.09 Y157.027 E.00885
G1 X186.151 Y156.987 E.00223
G1 X175.737 Y167.401 E.45531
G1 X176.274 Y167.401 E.01659
G1 X186.151 Y157.524 E.43185
G1 X186.151 Y158.061 E.01659
G1 X176.811 Y167.401 E.40839
G1 X177.347 Y167.401 E.01659
G1 X186.151 Y158.597 E.38493
G1 X186.151 Y159.134 E.01659
G1 X177.884 Y167.401 E.36146
G1 X178.42 Y167.401 E.01659
G1 X186.151 Y159.67 E.338
G1 X186.151 Y160.207 E.01659
G1 X178.957 Y167.401 E.31454
G1 X179.493 Y167.401 E.01659
G1 X186.151 Y160.743 E.29108
G1 X186.151 Y161.28 E.01659
G1 X180.03 Y167.401 E.26762
G1 X180.567 Y167.401 E.01659
G1 X186.151 Y161.817 E.24416
G1 X186.151 Y162.353 E.01659
G1 X181.103 Y167.401 E.22069
G1 X181.64 Y167.401 E.01659
G1 X186.151 Y162.89 E.19723
G1 X186.151 Y163.426 E.01659
G1 X182.176 Y167.401 E.17377
G1 X182.713 Y167.401 E.01659
G1 X183.251 Y166.863 E.02351
G1 X183.251 Y167.4 E.01659
G1 X183.08 Y167.57 E.00746
; WIPE_START
G1 X183.251 Y167.4 E-.09175
G1 X183.251 Y166.863 E-.2039
G1 X182.713 Y167.401 E-.28892
G1 X182.251 Y167.401 E-.17543
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X183.943 Y166.17 Z2 F60000
G1 Z1.6
G1 E.8 F1800
G1 F9488.165
M204 S8000
G1 X186.151 Y163.963 E.09651
G1 X186.151 Y164.5 E.01659
G1 X184.649 Y166.001 E.06563
G1 X185.186 Y166.001 E.01659
G1 X186.151 Y165.036 E.04217
G1 X186.151 Y165.573 E.01659
G1 X185.553 Y166.17 E.02613
M204 S10000
G1 X186.115 Y156.511 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.112566
G1 F15000
M204 S8000
G1 X186.28 Y156.38 E.0012
M204 S10000
G1 X186.47 Y155.773 F60000
; LINE_WIDTH: 0.332008
M73 P66 R3
G1 F12452.98
M204 S8000
G1 X186.544 Y155.38 E.00942
; LINE_WIDTH: 0.311998
G1 F13379.021
G1 X186.562 Y155.273 E.00237
; LINE_WIDTH: 0.275535
G1 F15000
G1 X186.58 Y155.156 E.00225
; LINE_WIDTH: 0.243505
G1 X186.594 Y155.038 E.00194
; LINE_WIDTH: 0.215746
G1 X186.608 Y154.912 E.00179
; LINE_WIDTH: 0.177046
G1 X186.619 Y154.242 E.00732
; LINE_WIDTH: 0.199702
G1 X186.599 Y153.996 E.00316
; LINE_WIDTH: 0.235413
G1 X186.583 Y153.876 E.0019
; LINE_WIDTH: 0.268673
G1 X186.565 Y153.743 E.00246
; LINE_WIDTH: 0.308019
G1 F13579.855
G1 X186.544 Y153.627 E.00254
; LINE_WIDTH: 0.368126
G1 F11069.923
G2 X186.464 Y153.229 I-8.312 J1.471 E.01077
M204 S10000
G1 X185.522 Y152.282 F60000
; LINE_WIDTH: 0.346019
G1 F11877.337
M204 S8000
G1 X185.167 Y152.213 E.00893
; LINE_WIDTH: 0.325675
G1 F12731.903
G1 X185.063 Y152.195 E.00242
; LINE_WIDTH: 0.288293
G1 F14671.572
G1 X184.949 Y152.176 E.00232
; LINE_WIDTH: 0.254591
G1 F15000
G1 X184.83 Y152.161 E.00206
; LINE_WIDTH: 0.224425
G1 X184.703 Y152.146 E.0019
; LINE_WIDTH: 0.178841
G1 X184.456 Y152.129 E.00274
G1 X183.994 Y152.131 E.00511
; LINE_WIDTH: 0.199091
G1 X183.752 Y152.151 E.0031
; LINE_WIDTH: 0.232063
G1 X183.646 Y152.164 E.00165
; LINE_WIDTH: 0.26049
G1 X183.528 Y152.179 E.00209
; LINE_WIDTH: 0.296792
G1 F14180.403
G1 X183.41 Y152.2 E.00249
; LINE_WIDTH: 0.356196
G1 F11491.476
G2 X182.979 Y152.285 I1.368 J8.101 E.01122
; WIPE_START
G1 X183.41 Y152.2 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.966 Y153.886 Z2 F60000
G1 X168.169 Y155.652 Z2
G1 Z1.6
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42234
G1 F9488.165
M204 S8000
G1 X171.222 Y152.599 E.13348
G1 X170.685 Y152.599 E.01659
G1 X168.594 Y154.69 E.09143
G1 X168.581 Y154.167 E.01619
G1 X170.148 Y152.599 E.06854
G1 X169.612 Y152.599 E.01659
G1 X168.49 Y153.721 E.04906
G2 X168.34 Y153.335 I-1.361 J.307 E.01286
G1 X169.075 Y152.599 E.03216
G1 X168.539 Y152.599 E.01659
G1 X168.032 Y153.106 E.02215
M204 S10000
G1 X167.761 Y152.635 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.112445
G1 F15000
M204 S8000
G1 X167.63 Y152.47 E.0012
M204 S10000
G1 X167.022 Y152.282 F60000
; LINE_WIDTH: 0.346019
G1 F11877.337
M204 S8000
G1 X166.667 Y152.213 E.00893
; LINE_WIDTH: 0.325675
G1 F12731.903
G1 X166.563 Y152.195 E.00242
; LINE_WIDTH: 0.288293
G1 F14671.572
G1 X166.449 Y152.176 E.00232
; LINE_WIDTH: 0.254591
G1 F15000
G1 X166.33 Y152.161 E.00206
; LINE_WIDTH: 0.224425
G1 X166.203 Y152.146 E.0019
; LINE_WIDTH: 0.178841
G1 X165.956 Y152.129 E.00274
G1 X165.494 Y152.131 E.00511
; LINE_WIDTH: 0.199091
G1 X165.252 Y152.151 E.0031
; LINE_WIDTH: 0.232063
G1 X165.146 Y152.164 E.00165
; LINE_WIDTH: 0.26049
G1 X165.028 Y152.179 E.00209
; LINE_WIDTH: 0.296792
G1 F14180.403
G1 X164.91 Y152.2 E.00249
; LINE_WIDTH: 0.356195
G1 F11491.497
G2 X164.479 Y152.285 I1.366 J8.094 E.01122
M204 S10000
G1 X163.53 Y153.228 F60000
; LINE_WIDTH: 0.334752
G1 F12335.871
M204 S8000
G1 X163.457 Y153.613 E.00931
; LINE_WIDTH: 0.314159
G1 F13272.449
G1 X163.439 Y153.722 E.00245
; LINE_WIDTH: 0.276513
G1 F15000
G1 X163.42 Y153.842 E.00232
; LINE_WIDTH: 0.244105
G1 X163.407 Y153.958 E.00191
; LINE_WIDTH: 0.216826
G1 X163.393 Y154.082 E.00176
; LINE_WIDTH: 0.177288
G1 X163.381 Y154.757 E.0074
; LINE_WIDTH: 0.199681
G1 X163.401 Y155.005 E.00317
; LINE_WIDTH: 0.235427
G1 X163.417 Y155.125 E.0019
; LINE_WIDTH: 0.268704
G1 X163.435 Y155.257 E.00246
; LINE_WIDTH: 0.308008
G1 F13580.4
G1 X163.456 Y155.372 E.00254
; LINE_WIDTH: 0.368029
G1 F11073.212
G2 X163.536 Y155.771 I8.272 J-1.464 E.01077
; CHANGE_LAYER
; Z_HEIGHT: 1.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F11073.212
G1 X163.456 Y155.372 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 9/47
; update layer progress
M73 L9
M991 S0 P8 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 1
M204 S10000
G17
G3 Z2 I.07 J1.215 P1  F60000
G1 X181.741 Y154.318 Z2
G1 Z1.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X181.74 Y154.502 E.0061
G2 X186.315 Y155.936 I2.515 J-.007 E.21092
G1 X186.484 Y155.991 E.00589
G1 X186.484 Y166.334 E.3431
G1 X183.584 Y166.334 E.0962
G1 X183.584 Y167.734 E.04644
G1 X166.416 Y167.734 E.56948
G1 X166.416 Y166.334 E.04644
G1 X163.516 Y166.334 E.0962
G1 X163.516 Y155.991 E.34308
G1 X163.683 Y155.935 E.00583
G2 X167.186 Y152.434 I2.068 J-1.434 E.29208
G1 X167.241 Y152.266 E.00587
G1 X182.759 Y152.266 E.51473
G1 X182.814 Y152.434 E.00585
G2 X181.752 Y154.251 I1.44 J2.061 E.07206
G1 X181.751 Y154.258 E.00023
; COOLING_NODE: 1
M204 S10000
G1 X182.15 Y154.379 F60000
G1 F8843.478
M204 S8000
G1 X182.149 Y154.291 E.00295
G3 X184.029 Y152.401 I2.099 J.208 E.0957
G1 X184.239 Y152.39 E.00697
G3 X182.15 Y154.716 I.009 J2.109 E.32278
G1 X182.15 Y154.439 E.00918
; COOLING_NODE: 1
M204 S10000
G1 X182.556 Y154.379 F60000
G1 F8843.478
M204 S8000
G1 X182.555 Y154.331 E.0016
G3 X184.072 Y152.807 I1.693 J.169 E.0772
G1 X184.241 Y152.797 E.00563
G3 X182.556 Y154.675 I.007 J1.702 E.26042
G1 X182.556 Y154.439 E.00784
; COOLING_NODE: 1
M204 S250
G1 X182.946 Y154.378 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9271
M204 S5000
G1 X182.946 Y154.369 E.00028
G3 X184.113 Y153.197 I1.303 J.13 E.05501
G1 X184.244 Y153.19 E.00402
G3 X182.947 Y154.636 I.005 J1.31 E.18558
G1 X182.946 Y154.438 E.00608
; COOLING_NODE: 1
; WIPE_START
G1 F9547.055
M204 S8000
G1 X182.946 Y154.369 E-.02623
G1 X182.997 Y154.117 E-.0977
G1 X183.093 Y153.885 E-.0956
G1 X183.246 Y153.658 E-.10372
G1 X183.421 Y153.486 E-.09339
G1 X183.615 Y153.354 E-.08943
G1 X183.866 Y153.247 E-.10344
G1 X184.113 Y153.197 E-.09582
G1 X184.244 Y153.19 E-.04976
G1 X184.257 Y153.191 E-.00491
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X185.686 Y152.434 Z2.2 F60000
G1 Z1.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X185.741 Y152.266 E.00587
G1 X186.484 Y152.266 E.02463
G1 X186.484 Y153.009 E.02463
G1 X186.317 Y153.065 E.00583
G2 X185.734 Y152.471 I-2.668 J2.039 E.02768
; COOLING_NODE: 1
; WIPE_START
G1 X185.741 Y152.266 E-.0779
G1 X186.484 Y152.266 E-.28213
G1 X186.484 Y153.009 E-.28219
G1 X186.317 Y153.065 E-.06681
G1 X186.231 Y152.962 E-.05098
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X178.629 Y153.643 Z2.2 F60000
G1 X163.704 Y154.981 Z2.2
G1 Z1.8
G1 E.8 F1800
G1 F8843.478
M204 S8000
G1 X163.65 Y154.716 E.00896
G3 X165.529 Y152.401 I2.098 J-.217 E.10984
G1 X165.739 Y152.39 E.00697
G3 X163.73 Y155.114 I.009 J2.109 E.30932
G1 X163.716 Y155.04 E.00249
; COOLING_NODE: 1
M204 S10000
G1 X164.102 Y154.901 F60000
G1 F8843.478
M204 S8000
G1 X164.056 Y154.675 E.00764
G3 X165.572 Y152.807 I1.693 J-.176 E.08865
G1 X165.741 Y152.797 E.00563
G3 X164.121 Y154.996 I.007 J1.702 E.24956
G1 X164.114 Y154.96 E.00121
; COOLING_NODE: 2
M204 S250
G1 X164.485 Y154.824 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9271
M204 S5000
G1 X164.447 Y154.636 E.00589
G3 X165.613 Y153.197 I1.302 J-.137 E.06322
G1 X165.744 Y153.19 E.00402
G3 X164.497 Y154.883 I.005 J1.31 E.17784
; COOLING_NODE: 2
; WIPE_START
G1 F9547.055
M204 S8000
G1 X164.447 Y154.636 E-.0956
G1 X164.446 Y154.369 E-.1014
G1 X164.497 Y154.117 E-.0977
G1 X164.593 Y153.885 E-.0956
G1 X164.746 Y153.658 E-.10372
G1 X164.921 Y153.486 E-.09339
G1 X165.115 Y153.354 E-.08943
G1 X165.317 Y153.268 E-.08317
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X163.683 Y153.065 Z2.2 F60000
G1 Z1.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X163.516 Y153.009 E.00583
G1 X163.516 Y152.266 E.02463
G1 X164.259 Y152.266 E.02462
G1 X164.314 Y152.434 E.00585
G2 X163.72 Y153.017 I2.02 J2.651 E.0277
; COOLING_NODE: 2
; WIPE_START
G1 X163.516 Y153.009 E-.0774
G1 X163.516 Y152.266 E-.28218
G1 X164.259 Y152.266 E-.28208
G1 X164.314 Y152.434 E-.06703
G1 X164.21 Y152.52 E-.05131
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X165.168 Y160.092 Z2.2 F60000
G1 X166.009 Y166.741 Z2.2
G1 Z1.8
G1 E.8 F1800
G1 F8843.478
M204 S8000
G1 X163.109 Y166.741 E.0962
G1 X163.109 Y151.859 E.49365
G1 X186.891 Y151.859 E.78888
G1 X186.891 Y166.741 E.49365
G1 X183.991 Y166.741 E.0962
G1 X183.991 Y168.141 E.04644
G1 X166.009 Y168.141 E.59649
G1 X166.009 Y166.801 E.04445
; COOLING_NODE: 2
M204 S10000
G1 X165.602 Y167.148 F60000
G1 F8843.478
M204 S8000
G1 X162.702 Y167.148 E.0962
G1 X162.702 Y151.452 E.52066
G1 X187.298 Y151.452 E.81589
G1 X187.298 Y167.148 E.52066
G1 X184.398 Y167.148 E.0962
G1 X184.398 Y168.548 E.04644
G1 X165.602 Y168.548 E.62349
G1 X165.602 Y167.208 E.04445
; COOLING_NODE: 0
M204 S250
G1 X165.21 Y167.54 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1800
M204 S5000
G1 X162.31 Y167.54 E.08911
G1 X162.31 Y151.06 E.50639
G1 X187.69 Y151.06 E.77986
G1 X187.69 Y167.54 E.50639
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

M73 P67 R3
G1 X184.79 Y167.54 E.08911
G1 X184.79 Y168.94 E.04302
G1 X165.21 Y168.94 E.60164
G1 X165.21 Y167.6 E.04117
; WIPE_START
G1 F9547.055
M204 S8000
G1 X163.21 Y167.559 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X166.925 Y167.57 Z2.2 F60000
G1 Z1.8
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42325
G1 F9465.464
M204 S8000
G1 X166.749 Y167.394 E.00771
G1 X166.749 Y166.857 E.01667
G1 X167.463 Y167.57 E.03128
; WIPE_START
G1 X166.749 Y166.857 E-.42714
G1 X166.749 Y167.394 E-.22764
G1 X166.925 Y167.57 E-.10522
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X163.68 Y165.4 Z2.2 F60000
G1 Z1.8
G1 E.8 F1800
G1 F9465.464
M204 S8000
G1 X164.28 Y166.001 E.0263
G1 X164.818 Y166.001 E.01667
G1 X163.849 Y165.032 E.04244
G1 X163.849 Y164.494 E.01667
G1 X165.356 Y166.001 E.06601
G1 X165.893 Y166.001 E.01667
G1 X163.849 Y163.957 E.08959
G1 X163.849 Y163.419 E.01667
G1 X167.831 Y167.401 E.17452
G1 X168.369 Y167.401 E.01667
G1 X163.849 Y162.881 E.1981
G1 X163.849 Y162.343 E.01667
G1 X168.907 Y167.401 E.22167
G1 X169.445 Y167.401 E.01667
G1 X163.849 Y161.805 E.24525
G1 X163.849 Y161.267 E.01667
G1 X169.983 Y167.401 E.26882
G1 X170.521 Y167.401 E.01667
G1 X163.849 Y160.729 E.29239
G1 X163.849 Y160.191 E.01667
G1 X171.059 Y167.401 E.31597
G1 X171.596 Y167.401 E.01667
G1 X163.849 Y159.654 E.33954
G1 X163.849 Y159.116 E.01667
G1 X172.134 Y167.401 E.36312
G1 X172.672 Y167.401 E.01667
G1 X163.849 Y158.578 E.38669
G1 X163.849 Y158.04 E.01667
G1 X173.21 Y167.401 E.41027
G1 X173.748 Y167.401 E.01667
G1 X163.849 Y157.502 E.43384
G1 X163.849 Y156.983 E.0161
G1 X163.934 Y157.049 E.00333
G1 X174.286 Y167.401 E.45371
G1 X174.824 Y167.401 E.01667
G1 X164.459 Y157.036 E.45426
G2 X165.268 Y157.307 I1.28 J-2.479 E.02654
G1 X175.361 Y167.401 E.44239
G1 X175.899 Y167.401 E.01667
G1 X165.846 Y157.347 E.44065
G2 X166.328 Y157.291 I-.149 J-3.395 E.01505
G1 X176.437 Y167.401 E.44309
G1 X176.975 Y167.401 E.01667
G1 X166.744 Y157.169 E.44844
G2 X167.115 Y157.003 I-.606 J-1.853 E.01264
G1 X177.513 Y167.401 E.45573
G1 X178.051 Y167.401 E.01667
G1 X167.437 Y156.786 E.46521
G2 X167.734 Y156.546 I-.694 J-1.159 E.01189
G1 X178.589 Y167.401 E.47576
G1 X179.127 Y167.401 E.01667
G1 X167.989 Y156.263 E.48814
G2 X168.202 Y155.938 I-.987 J-.879 E.01208
G1 X179.664 Y167.401 E.50238
G1 X180.202 Y167.401 E.01667
G1 X168.387 Y155.585 E.51787
G2 X168.513 Y155.174 I-2.821 J-1.094 E.01335
G1 X180.74 Y167.401 E.5359
G1 X181.278 Y167.401 E.01667
G1 X168.591 Y154.713 E.55608
G2 X168.579 Y154.163 I-2.999 J-.209 E.01707
G1 X181.816 Y167.401 E.58018
G1 X182.354 Y167.401 E.01667
G1 X168.378 Y153.425 E.61255
G2 X167.872 Y152.599 I-2.157 J.755 E.03023
G1 X168.091 Y152.599 E.00678
G1 X182.892 Y167.401 E.64872
G1 X183.251 Y167.401 E.01112
G1 X183.251 Y167.222 E.00555
G1 X168.628 Y152.599 E.64088
G1 X169.166 Y152.599 E.01667
G1 X183.251 Y166.684 E.6173
G1 X183.251 Y166.146 E.01667
G1 X169.704 Y152.599 E.59373
G1 X170.242 Y152.599 E.01667
M73 P68 R3
G1 X183.643 Y166.001 E.58736
G1 X184.181 Y166.001 E.01667
G1 X170.78 Y152.599 E.58736
G1 X171.318 Y152.599 E.01667
G1 X184.719 Y166.001 E.58736
G1 X185.257 Y166.001 E.01667
G1 X171.856 Y152.599 E.58736
G1 X172.393 Y152.599 E.01667
G1 X185.795 Y166.001 E.58736
G1 X186.151 Y166.001 E.01103
G1 X186.151 Y165.819 E.00564
G1 X172.931 Y152.599 E.57939
G1 X173.469 Y152.599 E.01667
G1 X186.151 Y165.281 E.55581
G1 X186.151 Y164.743 E.01667
G1 X174.007 Y152.599 E.53224
G1 X174.545 Y152.599 E.01667
G1 X186.151 Y164.205 E.50867
G1 X186.151 Y163.667 E.01667
G1 X175.083 Y152.599 E.48509
G1 X175.621 Y152.599 E.01667
G1 X186.151 Y163.129 E.46152
G1 X186.151 Y162.591 E.01667
G1 X176.159 Y152.599 E.43794
G1 X176.696 Y152.599 E.01667
G1 X186.151 Y162.054 E.41437
G1 X186.151 Y161.516 E.01667
G1 X177.234 Y152.599 E.39079
G1 X177.772 Y152.599 E.01667
G1 X186.32 Y161.148 E.37466
; WIPE_START
G1 X184.906 Y159.733 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X186.467 Y153.229 Z2.2 F60000
G1 Z1.8
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.346114
G1 F11873.606
M204 S8000
G3 X186.553 Y153.679 I-9.187 J2 E.01132
; LINE_WIDTH: 0.291711
G1 F14470.017
G1 X186.572 Y153.788 E.00225
; LINE_WIDTH: 0.256557
G1 F15000
G1 X186.588 Y153.916 E.00225
; LINE_WIDTH: 0.226516
G1 X186.603 Y154.033 E.00176
; LINE_WIDTH: 0.183045
G1 X186.626 Y154.497 E.0053
G1 X186.603 Y154.961 E.00531
; LINE_WIDTH: 0.235749
G1 X186.579 Y155.168 E.00328
; LINE_WIDTH: 0.281264
G1 X186.557 Y155.297 E.00253
; LINE_WIDTH: 0.32247
G1 F12877.856
G1 X186.538 Y155.415 E.00272
; LINE_WIDTH: 0.345229
G1 F11908.345
G1 X186.468 Y155.772 E.00896
M204 S10000
G1 X186.28 Y156.384 F60000
; LINE_WIDTH: 0.114004
G1 F15000
M204 S8000
G1 X186.098 Y156.527 E.00134
M204 S10000
G1 X186.32 Y157.382 F60000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42325
G1 F9465.464
M204 S8000
G1 X185.811 Y156.873 E.02234
G3 X185.472 Y157.072 I-.846 J-1.048 E.01222
G1 X186.151 Y157.751 E.02973
G1 X186.151 Y158.289 E.01667
G1 X185.088 Y157.226 E.04658
G3 X184.645 Y157.321 I-1.083 J-3.979 E.01405
G1 X186.151 Y158.826 E.066
G1 X186.151 Y159.364 E.01667
G1 X184.132 Y157.346 E.08847
G3 X183.494 Y157.246 I.123 J-2.874 E.02004
G1 X186.151 Y159.902 E.11642
G1 X186.151 Y160.44 E.01667
G1 X178.31 Y152.599 E.34365
G1 X178.848 Y152.599 E.01667
G1 X181.506 Y155.258 E.1165
G1 X181.414 Y154.799 E.01451
G1 X181.404 Y154.618 E.0056
G1 X179.386 Y152.599 E.08847
G1 X179.924 Y152.599 E.01667
G1 X181.429 Y154.105 E.06599
G3 X181.524 Y153.662 I2.295 J.259 E.01407
G1 X180.461 Y152.599 E.04656
G1 X180.999 Y152.599 E.01667
G1 X181.681 Y153.282 E.0299
G3 X181.87 Y152.932 I1.273 J.46 E.01235
G1 X181.368 Y152.43 E.02201
M204 S10000
G1 X182.207 Y152.669 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.116965
G1 F15000
M204 S8000
G1 X182.362 Y152.47 E.00152
M204 S10000
G1 X182.979 Y152.285 F60000
; LINE_WIDTH: 0.356073
G1 F11495.976
M204 S8000
G3 X183.41 Y152.2 I1.827 J8.178 E.01121
; LINE_WIDTH: 0.296704
G1 F14185.303
G1 X183.529 Y152.179 E.00249
; LINE_WIDTH: 0.260402
G1 F15000
G1 X183.646 Y152.164 E.0021
; LINE_WIDTH: 0.231963
G1 X183.752 Y152.15 E.00165
; LINE_WIDTH: 0.198828
G1 X183.997 Y152.131 E.00312
; LINE_WIDTH: 0.178615
G1 X184.698 Y152.145 E.00775
; LINE_WIDTH: 0.221669
G1 X184.812 Y152.159 E.00168
; LINE_WIDTH: 0.24784
G1 X184.919 Y152.171 E.00179
; LINE_WIDTH: 0.2815
G1 X185.047 Y152.193 E.00253
; LINE_WIDTH: 0.322739
G1 F12865.49
G1 X185.165 Y152.212 E.00273
; LINE_WIDTH: 0.345545
G1 F11895.92
G1 X185.522 Y152.282 E.00896
; WIPE_START
G1 X185.165 Y152.212 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X177.533 Y152.242 Z2.2 F60000
G1 X167.022 Y152.282 Z2.2
G1 Z1.8
G1 E.8 F1800
G1 F11895.92
M204 S8000
G1 X166.665 Y152.212 E.00896
; LINE_WIDTH: 0.322739
G1 F12865.49
G1 X166.547 Y152.193 E.00273
; LINE_WIDTH: 0.2815
G1 F15000
G1 X166.419 Y152.171 E.00253
; LINE_WIDTH: 0.24784
G1 X166.312 Y152.159 E.00179
; LINE_WIDTH: 0.221669
G1 X166.198 Y152.145 E.00168
; LINE_WIDTH: 0.178615
G1 X165.497 Y152.131 E.00775
; LINE_WIDTH: 0.198828
G1 X165.252 Y152.15 E.00312
; LINE_WIDTH: 0.231963
G1 X165.146 Y152.164 E.00165
; LINE_WIDTH: 0.260402
G1 X165.029 Y152.179 E.0021
; LINE_WIDTH: 0.296704
G1 F14185.303
G1 X164.91 Y152.2 E.00249
; LINE_WIDTH: 0.356073
G1 F11495.996
G2 X164.479 Y152.285 I1.394 J8.256 E.01121
M204 S10000
G1 X163.534 Y153.229 F60000
; LINE_WIDTH: 0.357475
G1 F11444.762
M204 S8000
G1 X163.468 Y153.555 E.00851
; LINE_WIDTH: 0.334285
G1 F12355.653
G1 X163.448 Y153.67 E.00278
; LINE_WIDTH: 0.291825
G1 F14463.379
G1 X163.426 Y153.797 E.00261
; LINE_WIDTH: 0.255547
G1 F15000
G1 X163.412 Y153.916 E.00207
; LINE_WIDTH: 0.225398
G1 X163.396 Y154.043 E.0019
; LINE_WIDTH: 0.182951
G1 X163.374 Y154.498 E.0052
G1 X163.397 Y154.967 E.00536
; LINE_WIDTH: 0.226509
G1 X163.412 Y155.083 E.00175
; LINE_WIDTH: 0.256417
G1 X163.427 Y155.211 E.00223
; LINE_WIDTH: 0.291533
G1 F14480.341
G1 X163.446 Y155.32 E.00225
; LINE_WIDTH: 0.346001
G1 F11878.028
G2 X163.533 Y155.771 I9.648 J-1.613 E.01133
M204 S10000
G1 X163.72 Y156.385 F60000
; LINE_WIDTH: 0.114755
G1 F15000
M204 S8000
G1 X163.907 Y156.532 E.00139
; CHANGE_LAYER
; Z_HEIGHT: 2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F15000
G1 X163.72 Y156.385 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 10/47
; update layer progress
M73 L10
M991 S0 P9 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 1
M204 S10000
G17
G3 Z2.2 I.149 J1.208 P1  F60000
G1 X181.764 Y154.163 Z2.2
G1 Z2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X181.742 Y154.286 E.00413
G2 X186.314 Y155.937 I2.508 J.213 E.21855
G1 X186.484 Y155.992 E.00591
G1 X186.484 Y165.37 E.31109
G1 X163.516 Y165.37 E.76188
G1 X163.516 Y155.993 E.31105
G1 X163.682 Y155.936 E.00581
G2 X167.186 Y152.435 I2.067 J-1.436 E.29196
G1 X167.241 Y152.266 E.00589
G1 X182.757 Y152.266 E.51471
G1 X182.814 Y152.432 E.0058
G2 X181.828 Y153.811 I1.436 J2.067 E.05734
G1 X181.775 Y154.104 E.0099
; COOLING_NODE: 1
M204 S10000
G1 X182.163 Y154.236 F60000
G1 F8843.478
M204 S8000
G1 X182.221 Y153.922 E.0106
G3 X184.027 Y152.402 I2.029 J.577 E.08313
G1 X184.225 Y152.39 E.00657
G3 X182.148 Y154.32 I.024 J2.109 E.33643
G1 X182.152 Y154.295 E.00083
; COOLING_NODE: 1
M204 S10000
G1 X182.562 Y154.309 F60000
G1 F8843.478
M204 S8000
G1 X182.613 Y154.033 E.00931
G3 X184.071 Y152.807 I1.637 J.466 E.06707
G1 X184.229 Y152.797 E.00527
G3 X182.553 Y154.368 I.02 J1.702 E.27101
; COOLING_NODE: 1
M204 S250
G1 X182.946 Y154.38 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9157
M204 S5000
G1 X182.99 Y154.14 E.00749
G3 X184.113 Y153.197 I1.259 J.359 E.04781
G1 X184.233 Y153.19 E.00371
G3 X182.942 Y154.439 I.016 J1.309 E.19193
; COOLING_NODE: 1
; WIPE_START
G1 F9547.055
M204 S8000
G1 X182.99 Y154.14 E-.11531
G1 X183.083 Y153.904 E-.09614
G1 X183.231 Y153.677 E-.10329
G1 X183.407 Y153.497 E-.09555
G1 X183.615 Y153.354 E-.09588
G1 X183.866 Y153.247 E-.1037
G1 X184.113 Y153.197 E-.09571
G1 X184.233 Y153.19 E-.04589
G1 X184.256 Y153.192 E-.00852
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X185.686 Y152.435 Z2.4 F60000
G1 Z2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X185.741 Y152.266 E.00589
G1 X186.484 Y152.266 E.02465
G1 X186.484 Y153.007 E.02458
G1 X186.318 Y153.064 E.00581
G2 X185.733 Y152.472 I-2.682 J2.064 E.02767
; COOLING_NODE: 1
; WIPE_START
G1 X185.741 Y152.266 E-.07814
G1 X186.484 Y152.266 E-.28234
G1 X186.484 Y153.007 E-.28163
G1 X186.318 Y153.064 E-.06651
G1 X186.231 Y152.961 E-.05138
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X178.631 Y153.669 Z2.4 F60000
G1 X163.724 Y155.059 Z2.4
G1 Z2
G1 E.8 F1800
G1 F8843.478
M204 S8000
G1 X163.687 Y154.939 E.00417
G3 X165.527 Y152.402 I2.062 J-.44 E.11722
G1 X165.725 Y152.39 E.00657
G3 X163.818 Y155.347 I.024 J2.109 E.30151
G1 X163.743 Y155.116 E.00807
; COOLING_NODE: 1
M204 S10000
G1 X164.11 Y154.934 F60000
G1 F8843.478
M204 S8000
G1 X164.085 Y154.854 E.00278
G3 X165.571 Y152.807 I1.664 J-.355 E.0946
G1 X165.729 Y152.797 E.00527
G3 X164.192 Y155.184 I.02 J1.702 E.24328
G1 X164.129 Y154.991 E.00672
; COOLING_NODE: 2
M204 S250
G1 X164.482 Y154.815 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9157
M204 S5000
G1 X164.469 Y154.773 E.00134
G3 X165.613 Y153.197 I1.28 J-.273 E.06745
G1 X165.733 Y153.19 E.00371
G3 X164.551 Y155.027 I.016 J1.309 E.1734
G1 X164.501 Y154.872 E.00502
; COOLING_NODE: 2
; WIPE_START
G1 F9547.055
M204 S8000
G1 X164.469 Y154.773 E-.03943
G1 X164.447 Y154.637 E-.0521
G1 X164.445 Y154.386 E-.09544
G1 X164.49 Y154.14 E-.09517
G1 X164.583 Y153.904 E-.09615
G1 X164.731 Y153.677 E-.10329
G1 X164.907 Y153.497 E-.09555
G1 X165.115 Y153.354 E-.09588
G1 X165.326 Y153.264 E-.08699
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X163.685 Y153.064 Z2.4 F60000
G1 Z2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X163.516 Y153.009 E.00589
G1 X163.516 Y152.266 E.02465
G1 X164.257 Y152.266 E.02458
G1 X164.314 Y152.432 E.0058
G2 X163.722 Y153.017 I2.071 J2.688 E.02767
; COOLING_NODE: 2
; WIPE_START
G1 X163.516 Y153.009 E-.07816
G1 X163.516 Y152.266 E-.28233
G1 X164.257 Y152.266 E-.28161
G1 X164.314 Y152.432 E-.0665
G1 X164.21 Y152.519 E-.05141
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X165.768 Y159.991 Z2.4 F60000
G1 X166.973 Y165.777 Z2.4
G1 Z2
G1 E.8 F1800
G1 F8843.478
M204 S8000
G1 X163.109 Y165.777 E.12818
G1 X163.109 Y151.859 E.46167
G1 X186.891 Y151.859 E.78888
G1 X186.891 Y165.777 E.46167
G1 X167.033 Y165.777 E.65871
; COOLING_NODE: 2
M204 S10000
G1 X166.566 Y166.184 F60000
G1 F8843.478
M204 S8000
G1 X163.194 Y166.184 E.11188
G1 X163.194 Y167.148 E.03198
G1 X162.702 Y167.148 E.01631
G1 X162.702 Y151.452 E.52066
G1 X187.298 Y151.452 E.81589
G1 X187.298 Y167.148 E.52066
G1 X186.806 Y167.148 E.01631
G1 X186.806 Y166.184 E.03198
G1 X166.626 Y166.184 E.66941
; COOLING_NODE: 0
; WIPE_START
M73 P69 R3
G1 X164.626 Y166.184 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X165.21 Y167.54 Z2.4 F60000
G1 Z2
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1863
M204 S5000
G1 X162.31 Y167.54 E.08911
G1 X162.31 Y151.06 E.50639
G1 X187.69 Y151.06 E.77986
G1 X187.69 Y167.54 E.50639
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X184.79 Y167.54 E.08911
G1 X184.79 Y168.94 E.04302
G1 X165.21 Y168.94 E.60164
G1 X165.21 Y167.6 E.04117
; WIPE_START
G1 F9547.055
M204 S8000
G1 X163.21 Y167.559 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X162.948 Y166.944 Z2.4 F60000
G1 Z2
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.12743
G1 F15000
M204 S8000
G1 X162.948 Y165.98 E.00664
; WIPE_START
G1 X162.948 Y166.944 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X163.68 Y164.463 Z2.4 F60000
G1 Z2
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42365
G1 F9455.519
M204 S8000
G1 X171.302 Y156.841 E.33442
G1 X170.763 Y156.841 E.0167
G1 X163.849 Y163.754 E.30335
G1 X163.849 Y163.216 E.0167
G1 X170.225 Y156.841 E.27973
G1 X170.013 Y156.841 E.00658
G1 X169.85 Y156.677 E.00716
G1 X163.849 Y162.678 E.26326
G1 X163.849 Y162.139 E.0167
G1 X169.81 Y156.179 E.2615
G1 X169.81 Y155.641 E.0167
G1 X163.849 Y161.601 E.2615
G1 X163.849 Y161.062 E.0167
G1 X169.81 Y155.102 E.2615
G1 X169.81 Y154.564 E.0167
G1 X163.849 Y160.524 E.2615
G1 X163.849 Y159.985 E.0167
G1 X166.619 Y157.216 E.12151
G1 X166.098 Y157.33 E.01653
G1 X165.956 Y157.34 E.00443
G1 X163.849 Y159.447 E.09242
G1 X163.849 Y158.909 E.0167
G1 X165.431 Y157.326 E.06941
G1 X164.976 Y157.243 E.01436
G1 X163.849 Y158.37 E.04944
G1 X163.849 Y157.832 E.0167
G1 X164.583 Y157.098 E.0322
G3 X164.231 Y156.911 I.711 J-1.768 E.01238
G1 X163.849 Y157.293 E.01675
G1 X163.849 Y156.755 E.0167
G1 X164.047 Y156.557 E.00868
M204 S10000
G1 X163.536 Y155.771 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.368029
G1 F11073.212
M204 S8000
G3 X163.456 Y155.372 I8.192 J-1.862 E.01077
; LINE_WIDTH: 0.308008
G1 F13580.4
G1 X163.435 Y155.257 E.00254
; LINE_WIDTH: 0.268704
G1 F15000
G1 X163.417 Y155.125 E.00246
; LINE_WIDTH: 0.235427
G1 X163.401 Y155.005 E.0019
; LINE_WIDTH: 0.199681
G1 X163.381 Y154.757 E.00317
; LINE_WIDTH: 0.177288
G1 X163.393 Y154.082 E.0074
; LINE_WIDTH: 0.216826
G1 X163.407 Y153.958 E.00176
; LINE_WIDTH: 0.244105
G1 X163.42 Y153.842 E.00191
; LINE_WIDTH: 0.276513
G1 X163.439 Y153.722 E.00232
; LINE_WIDTH: 0.314159
G1 F13272.449
G1 X163.457 Y153.613 E.00245
; LINE_WIDTH: 0.334752
G1 F12335.871
G1 X163.53 Y153.228 E.00931
M204 S10000
G1 X164.479 Y152.285 F60000
; LINE_WIDTH: 0.356195
G1 F11491.497
M204 S8000
G3 X164.91 Y152.2 I1.798 J8.01 E.01122
; LINE_WIDTH: 0.296792
G1 F14180.403
G1 X165.028 Y152.179 E.00249
; LINE_WIDTH: 0.26049
G1 F15000
G1 X165.146 Y152.164 E.00209
; LINE_WIDTH: 0.232063
G1 X165.252 Y152.151 E.00165
; LINE_WIDTH: 0.199091
G1 X165.494 Y152.131 E.0031
; LINE_WIDTH: 0.178841
G1 X165.956 Y152.129 E.00511
G1 X166.203 Y152.146 E.00274
; LINE_WIDTH: 0.224425
G1 X166.33 Y152.161 E.0019
; LINE_WIDTH: 0.254591
G1 X166.449 Y152.176 E.00206
; LINE_WIDTH: 0.288293
G1 F14671.572
G1 X166.563 Y152.195 E.00232
; LINE_WIDTH: 0.325675
G1 F12731.903
G1 X166.667 Y152.213 E.00242
; LINE_WIDTH: 0.346019
G1 F11877.337
G1 X167.022 Y152.282 E.00893
M204 S10000
G1 X167.63 Y152.47 F60000
; LINE_WIDTH: 0.112445
G1 F15000
M204 S8000
G1 X167.761 Y152.635 E.0012
M204 S10000
G1 X168.034 Y153.109 F60000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42365
G1 F9455.519
M204 S8000
G1 X168.543 Y152.599 E.02236
G1 X169.082 Y152.599 E.0167
G1 X168.341 Y153.34 E.03248
G3 X168.491 Y153.728 I-1.217 J.693 E.01297
G1 X169.62 Y152.599 E.04952
G1 X170.159 Y152.599 E.0167
G1 X168.582 Y154.176 E.06917
G1 X168.594 Y154.702 E.01634
G1 X169.81 Y153.487 E.05333
G1 X169.81 Y154.025 E.0167
G1 X168.157 Y155.677 E.07249
M204 S10000
G1 X170.48 Y153.052 F60000
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X170.202 Y153.052 E.00925
G1 X170.202 Y154.401 E.04477
G1 X170.734 Y154.759 E.02128
G3 X170.805 Y155.414 I-.443 J.379 E.02323
G3 X170.221 Y156.448 I-1.883 J-.38 E.04005
G1 X171.598 Y156.448 E.04568
G1 X171.598 Y154.864 E.05254
G3 X171.333 Y154.104 I.259 J-.517 E.02956
G3 X171.931 Y153.052 I1.918 J.394 E.04081
G1 X174.058 Y153.052 E.07055
G1 X174.219 Y153.448 E.0142
G1 X174.769 Y154.104 E.02838
G1 X175.404 Y154.448 E.02397
G1 X176.508 Y154.431 E.03661
G3 X177.173 Y153.052 I2.772 J.486 E.05146
G1 X179.3 Y153.052 E.07055
G2 X179.798 Y153.851 I1.48 J-.367 E.03179
G1 X179.798 Y156.448 E.08615
G1 X178.555 Y156.448 E.04124
G1 X178.402 Y156.069 E.01359
G1 X178.402 Y154.689 E.04575
G1 X178.225 Y154.513 E.00826
; WIPE_START
G1 X178.402 Y154.689 E-.09463
G1 X178.402 Y156.069 E-.52413
G1 X178.541 Y156.413 E-.14124
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X182.979 Y152.285 Z2.4 F60000
G1 Z2
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.356196
G1 F11491.476
M204 S8000
G3 X183.41 Y152.2 I1.799 J8.016 E.01122
; LINE_WIDTH: 0.296792
G1 F14180.403
G1 X183.528 Y152.179 E.00249
; LINE_WIDTH: 0.26049
G1 F15000
G1 X183.646 Y152.164 E.00209
; LINE_WIDTH: 0.232063
G1 X183.752 Y152.151 E.00165
; LINE_WIDTH: 0.199091
G1 X183.994 Y152.131 E.0031
; LINE_WIDTH: 0.178841
G1 X184.456 Y152.129 E.00511
G1 X184.703 Y152.146 E.00274
; LINE_WIDTH: 0.224425
G1 X184.83 Y152.161 E.0019
; LINE_WIDTH: 0.254591
G1 X184.949 Y152.176 E.00206
; LINE_WIDTH: 0.288293
G1 F14671.572
G1 X185.063 Y152.195 E.00232
; LINE_WIDTH: 0.325675
G1 F12731.903
G1 X185.167 Y152.213 E.00242
; LINE_WIDTH: 0.346019
G1 F11877.337
G1 X185.522 Y152.282 E.00893
M204 S10000
G1 X186.464 Y153.229 F60000
; LINE_WIDTH: 0.368126
G1 F11069.923
M204 S8000
G3 X186.544 Y153.627 I-8.232 J1.869 E.01077
; LINE_WIDTH: 0.308019
G1 F13579.855
G1 X186.565 Y153.743 E.00254
; LINE_WIDTH: 0.268673
G1 F15000
G1 X186.583 Y153.876 E.00246
; LINE_WIDTH: 0.235413
G1 X186.599 Y153.996 E.0019
; LINE_WIDTH: 0.199702
G1 X186.619 Y154.242 E.00316
; LINE_WIDTH: 0.177046
G1 X186.608 Y154.912 E.00732
; LINE_WIDTH: 0.215746
G1 X186.594 Y155.038 E.00179
; LINE_WIDTH: 0.243505
G1 X186.58 Y155.156 E.00194
; LINE_WIDTH: 0.275535
G1 X186.562 Y155.273 E.00225
; LINE_WIDTH: 0.311998
G1 F13379.021
G1 X186.544 Y155.38 E.00237
; LINE_WIDTH: 0.332008
G1 F12452.98
G1 X186.47 Y155.773 E.00942
M204 S10000
G1 X186.28 Y156.38 F60000
; LINE_WIDTH: 0.112566
G1 F15000
M204 S8000
G1 X186.115 Y156.511 E.0012
M204 S10000
G1 X185.55 Y165.206 F60000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42365
G1 F9455.519
M204 S8000
G1 X186.151 Y164.606 E.02634
G1 X186.151 Y164.067 E.0167
G1 X185.182 Y165.036 E.04252
G1 X184.643 Y165.036 E.0167
G1 X186.151 Y163.529 E.06614
G1 X186.151 Y162.99 E.0167
G1 X184.105 Y165.036 E.08977
G1 X183.566 Y165.036 E.0167
G1 X186.151 Y162.452 E.11339
G1 X186.151 Y161.914 E.0167
G1 X183.028 Y165.036 E.13702
G1 X182.489 Y165.036 E.0167
G1 X186.151 Y161.375 E.16064
G1 X186.151 Y160.837 E.0167
G1 X181.951 Y165.036 E.18426
G1 X181.413 Y165.036 E.0167
G1 X186.151 Y160.298 E.20789
G1 X186.151 Y159.76 E.0167
G1 X180.874 Y165.036 E.23151
G1 X180.336 Y165.036 E.0167
G1 X186.151 Y159.221 E.25514
G1 X186.151 Y158.683 E.0167
G1 X179.797 Y165.036 E.27876
G1 X179.259 Y165.036 E.0167
G1 X186.151 Y158.145 E.30238
G1 X186.151 Y157.606 E.0167
G1 X178.72 Y165.036 E.32601
G1 X178.182 Y165.036 E.0167
G1 X186.151 Y157.068 E.34963
G1 X186.151 Y156.979 E.00274
G1 X186.09 Y157.027 E.00238
G1 X185.916 Y156.8 E.00888
G1 X185.8 Y156.88 E.0044
G1 X177.643 Y165.036 E.35785
G1 X177.105 Y165.036 E.0167
G1 X184.871 Y157.271 E.34072
G3 X184.254 Y157.349 I-.631 J-2.491 E.01935
G1 X176.567 Y165.036 E.33727
G1 X176.028 Y165.036 E.0167
G1 X183.767 Y157.298 E.33953
G3 X183.331 Y157.196 I.132 J-1.543 E.01395
G1 X175.49 Y165.036 E.34402
G1 X174.951 Y165.036 E.0167
G1 X182.95 Y157.038 E.35094
G3 X182.619 Y156.83 I.538 J-1.225 E.01216
M73 P70 R3
G1 X174.413 Y165.036 E.36005
G1 X173.874 Y165.036 E.0167
G1 X182.319 Y156.592 E.3705
G3 X182.055 Y156.318 I2.324 J-2.501 E.01182
G1 X173.336 Y165.036 E.38254
G1 X172.798 Y165.036 E.0167
G1 X181.835 Y155.999 E.39651
G3 X181.651 Y155.644 I.816 J-.646 E.01248
G1 X172.259 Y165.036 E.41209
G1 X171.721 Y165.036 E.0167
G1 X181.504 Y155.254 E.42923
G3 X181.415 Y154.804 I2.099 J-.648 E.01425
G1 X180.191 Y156.028 E.05372
G1 X180.191 Y155.49 E.0167
G1 X181.408 Y154.272 E.05342
G1 X181.505 Y153.727 E.01718
G1 X181.551 Y153.591 E.00446
G1 X180.191 Y154.951 E.05968
G1 X180.191 Y154.413 E.0167
G1 X182.004 Y152.599 E.07957
G1 X181.466 Y152.599 E.0167
G1 X180.191 Y153.875 E.05595
G1 X180.191 Y153.336 E.0167
G1 X180.927 Y152.599 E.03232
G1 X180.389 Y152.599 E.0167
G1 X180.158 Y152.83 E.01013
G1 X179.987 Y152.66 E.00749
G1 X179.79 Y152.66 E.00612
G1 X179.85 Y152.599 E.00264
G1 X179.312 Y152.599 E.0167
G1 X179.252 Y152.66 E.00264
G1 X178.713 Y152.66 E.0167
G1 X178.773 Y152.599 E.00264
G1 X178.235 Y152.599 E.0167
G1 X178.175 Y152.66 E.00264
G1 X177.636 Y152.66 E.0167
G1 X177.697 Y152.599 E.00264
G1 X177.158 Y152.599 E.0167
G1 X177.098 Y152.66 E.00264
G1 X176.56 Y152.66 E.0167
G1 X176.62 Y152.599 E.00264
G1 X176.081 Y152.599 E.0167
G1 X176.021 Y152.66 E.00264
G1 X175.483 Y152.66 E.0167
G1 X175.543 Y152.599 E.00264
G1 X175.004 Y152.599 E.0167
G1 X174.944 Y152.66 E.00264
G1 X174.406 Y152.66 E.0167
G1 X174.466 Y152.599 E.00264
G1 X173.928 Y152.599 E.0167
G1 X173.867 Y152.66 E.00264
G1 X173.329 Y152.66 E.0167
G1 X173.389 Y152.599 E.00264
G1 X172.851 Y152.599 E.0167
G1 X172.791 Y152.66 E.00264
G1 X172.252 Y152.66 E.0167
G1 X172.312 Y152.599 E.00264
G1 X171.774 Y152.599 E.0167
G1 X171.714 Y152.66 E.00264
G1 X171.175 Y152.66 E.0167
G1 X171.235 Y152.599 E.00264
G1 X170.697 Y152.599 E.0167
G1 X170.467 Y152.829 E.01008
M204 S10000
G1 X171.821 Y155.245 F60000
G1 F9455.519
M204 S8000
G1 X172.225 Y154.841 E.01773
G1 X172.763 Y154.841 E.0167
G1 X171.991 Y155.613 E.03391
G1 X171.991 Y156.152 E.0167
G1 X173.302 Y154.841 E.05753
G1 X173.84 Y154.841 E.0167
G1 X163.849 Y164.831 E.43835
G1 X163.849 Y165.036 E.00637
G1 X164.183 Y165.036 E.01034
G1 X174.379 Y154.841 E.44735
G1 X174.917 Y154.841 E.0167
G1 X164.721 Y165.036 E.44735
G1 X165.26 Y165.036 E.0167
G1 X175.455 Y154.841 E.44735
G1 X175.994 Y154.841 E.0167
G1 X165.798 Y165.036 E.44735
G1 X166.336 Y165.036 E.0167
G1 X176.532 Y154.841 E.44735
G1 X177.071 Y154.841 E.0167
G1 X166.875 Y165.036 E.44735
G1 X167.413 Y165.036 E.0167
G1 X177.609 Y154.841 E.44735
G1 X177.998 Y154.841 E.01207
G1 X178.01 Y154.979 E.0043
G1 X167.952 Y165.036 E.44129
G1 X168.49 Y165.036 E.0167
G1 X178.01 Y155.517 E.41767
G1 X178.01 Y156.056 E.0167
G1 X169.029 Y165.036 E.39404
G1 X169.567 Y165.036 E.0167
G1 X178.01 Y156.594 E.37042
G1 X178.01 Y156.637 E.00135
G1 X178.213 Y156.841 E.00891
G1 X178.301 Y156.841 E.00275
G1 X170.105 Y165.036 E.3596
G1 X170.644 Y165.036 E.0167
G1 X178.84 Y156.841 E.3596
G1 X179.378 Y156.841 E.0167
G1 X171.013 Y165.206 E.36705
; WIPE_START
G1 X172.427 Y163.792 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X179.587 Y166.436 Z2.4 F60000
G1 X184.583 Y168.281 Z2.4
G1 Z2
G1 E.8 F1800
; FEATURE: Top surface
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S2000
G1 X184.131 Y168.733 E.01961
G1 X183.998 Y168.866
G1 X183.465 Y168.866
G1 X183.598 Y168.733
G1 X184.583 Y167.748 E.04278
; WIPE_START
M204 S8000
G1 X183.598 Y168.733 E-.52904
G1 X183.465 Y168.866 E-.07182
G1 X183.883 Y168.866 E-.15914
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X186.065 Y167.333 Z2.4 F60000
G1 Z2
G1 E.8 F1800
G1 F9547.055
M204 S2000
G1 X186.584 Y166.813 E.02256
G1 X186.718 Y166.68
G1 X186.591 Y166.273
G1 X186.458 Y166.406
G1 X185.531 Y167.333 E.04026
G1 X185.398 Y167.466
G1 X184.865 Y167.466
G1 X184.998 Y167.333
G1 X185.925 Y166.406 E.04026
G1 X186.058 Y166.273
G1 X185.525 Y166.273
G1 X185.391 Y166.406
G1 X183.065 Y168.733 E.10109
G1 X182.931 Y168.866
G1 X182.398 Y168.866
G1 X182.532 Y168.733
G1 X184.858 Y166.406 E.10109
G1 X184.992 Y166.273
G1 X184.458 Y166.273
G1 X184.325 Y166.406
G1 X181.998 Y168.733 E.10109
G1 X181.865 Y168.866
G1 X181.332 Y168.866
G1 X181.465 Y168.733
G1 X183.792 Y166.406 E.10109
G1 X183.925 Y166.273
G1 X183.392 Y166.273
G1 X183.258 Y166.406
G1 X180.932 Y168.733 E.10109
G1 X180.798 Y168.866
G1 X180.265 Y168.866
G1 X180.399 Y168.733
G1 X182.725 Y166.406 E.10109
G1 X182.859 Y166.273
G1 X182.325 Y166.273
G1 X182.192 Y166.406
G1 X179.865 Y168.733 E.10109
G1 X179.732 Y168.866
G1 X179.198 Y168.866
G1 X179.332 Y168.733
G1 X181.659 Y166.406 E.10109
G1 X181.792 Y166.273
G1 X181.259 Y166.273
G1 X181.125 Y166.406
G1 X178.799 Y168.733 E.10109
G1 X178.665 Y168.866
G1 X178.132 Y168.866
G1 X178.266 Y168.733
G1 X180.592 Y166.406 E.10109
G1 X180.726 Y166.273
G1 X180.192 Y166.273
G1 X180.059 Y166.406
G1 X177.732 Y168.733 E.10109
G1 X177.599 Y168.866
G1 X177.065 Y168.866
G1 X177.199 Y168.733
G1 X179.525 Y166.406 E.10109
G1 X179.659 Y166.273
G1 X179.126 Y166.273
G1 X178.992 Y166.406
G1 X176.666 Y168.733 E.10109
G1 X176.532 Y168.866
G1 X175.999 Y168.866
G1 X176.133 Y168.733
G1 X178.459 Y166.406 E.10109
G1 X178.593 Y166.273
G1 X178.059 Y166.273
G1 X177.926 Y166.406
G1 X175.599 Y168.733 E.10109
G1 X175.466 Y168.866
G1 X174.932 Y168.866
G1 X175.066 Y168.733
G1 X177.392 Y166.406 E.10109
G1 X177.526 Y166.273
G1 X176.993 Y166.273
G1 X176.859 Y166.406
G1 X174.533 Y168.733 E.10109
G1 X174.399 Y168.866
G1 X173.866 Y168.866
G1 X174 Y168.733
G1 X176.326 Y166.406 E.10109
G1 X176.46 Y166.273
G1 X175.926 Y166.273
G1 X175.793 Y166.406
G1 X173.466 Y168.733 E.10109
G1 X173.333 Y168.866
G1 X172.799 Y168.866
G1 X172.933 Y168.733
G1 X175.259 Y166.406 E.10109
G1 X175.393 Y166.273
G1 X174.86 Y166.273
G1 X174.726 Y166.406
G1 X172.4 Y168.733 E.10109
G1 X172.266 Y168.866
G1 X171.733 Y168.866
G1 X171.867 Y168.733
G1 X174.193 Y166.406 E.10109
G1 X174.327 Y166.273
G1 X173.793 Y166.273
G1 X173.66 Y166.406
G1 X171.333 Y168.733 E.10109
G1 X171.2 Y168.866
G1 X170.666 Y168.866
G1 X170.8 Y168.733
G1 X173.126 Y166.406 E.10109
G1 X173.26 Y166.273
G1 X172.727 Y166.273
G1 X172.593 Y166.406
G1 X170.267 Y168.733 E.10109
G1 X170.133 Y168.866
G1 X169.6 Y168.866
G1 X169.733 Y168.733
G1 X172.06 Y166.406 E.10109
G1 X172.194 Y166.273
G1 X171.66 Y166.273
G1 X171.527 Y166.406
G1 X169.2 Y168.733 E.10109
G1 X169.067 Y168.866
G1 X168.533 Y168.866
G1 X168.667 Y168.733
G1 X170.993 Y166.406 E.10109
G1 X171.127 Y166.273
G1 X170.594 Y166.273
G1 X170.46 Y166.406
G1 X168.134 Y168.733 E.10109
G1 X168 Y168.866
G1 X167.467 Y168.866
G1 X167.6 Y168.733
G1 X169.927 Y166.406 E.10109
G1 X170.06 Y166.273
G1 X169.527 Y166.273
G1 X169.394 Y166.406
G1 X167.067 Y168.733 E.10109
G1 X166.934 Y168.866
G1 X166.4 Y168.866
G1 X166.534 Y168.733
G1 X168.86 Y166.406 E.10109
G1 X168.994 Y166.273
G1 X168.461 Y166.273
G1 X168.327 Y166.406
G1 X166.001 Y168.733 E.10109
G1 X165.867 Y168.866
G1 X165.334 Y168.866
G1 X165.467 Y168.733
G1 X167.794 Y166.406 E.10109
G1 X167.927 Y166.273
G1 X167.394 Y166.273
G1 X167.261 Y166.406
G1 X165.417 Y168.249 E.08009
G1 X165.284 Y168.383
G1 X165.284 Y167.85
G1 X165.417 Y167.716
G1 X166.727 Y166.406 E.05692
G1 X166.861 Y166.273
G1 X166.328 Y166.273
G1 X166.194 Y166.406
G1 X165.268 Y167.333 E.04026
G1 X165.134 Y167.466
G1 X164.601 Y167.466
G1 X164.734 Y167.333
M73 P71 R3
G1 X165.661 Y166.406 E.04026
G1 X165.794 Y166.273
G1 X165.261 Y166.273
G1 X165.128 Y166.406
G1 X164.201 Y167.333 E.04026
G1 X164.067 Y167.466
G1 X163.534 Y167.466
G1 X163.668 Y167.333
G1 X164.594 Y166.406 E.04026
G1 X164.728 Y166.273
G1 X164.195 Y166.273
G1 X164.061 Y166.406
G1 X163.416 Y167.051 E.02802
; WIPE_START
M204 S8000
G1 X164.061 Y166.406 E-.34656
G1 X164.195 Y166.273 E-.07182
G1 X164.728 Y166.273 E-.20264
G1 X164.594 Y166.406 E-.07182
G1 X164.469 Y166.531 E-.06716
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.1 Y166.671 Z2.4 F60000
G1 X187.052 Y166.944 Z2.4
G1 Z2
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.12743
G1 F15000
M204 S8000
G1 X187.052 Y165.98 E.00664
; CHANGE_LAYER
; Z_HEIGHT: 2.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F15000
G1 X187.052 Y166.944 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 11/47
; update layer progress
M73 L11
M991 S0 P10 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 1
M204 S10000
G17
G3 Z2.4 I1.122 J-.472 P1  F60000
G1 X181.741 Y154.318 Z2.4
G1 Z2.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X181.74 Y154.502 E.0061
G2 X186.315 Y155.936 I2.515 J-.007 E.21092
G1 X186.484 Y155.991 E.00589
G1 X186.484 Y166.334 E.3431
G1 X163.516 Y166.334 E.76188
G1 X163.516 Y155.991 E.34308
G1 X163.683 Y155.935 E.00583
G2 X167.186 Y152.434 I2.068 J-1.434 E.29208
G1 X167.241 Y152.266 E.00587
G1 X182.759 Y152.266 E.51473
G1 X182.814 Y152.434 E.00585
G2 X181.752 Y154.251 I1.44 J2.061 E.07206
G1 X181.751 Y154.258 E.00023
; COOLING_NODE: 1
M204 S10000
G1 X182.15 Y154.379 F60000
G1 F8843.478
M204 S8000
G1 X182.149 Y154.291 E.00295
G3 X184.029 Y152.401 I2.099 J.208 E.0957
G1 X184.239 Y152.39 E.00697
G3 X182.15 Y154.716 I.009 J2.109 E.32278
G1 X182.15 Y154.439 E.00918
; COOLING_NODE: 1
M204 S10000
G1 X182.556 Y154.379 F60000
G1 F8843.478
M204 S8000
G1 X182.555 Y154.331 E.0016
G3 X184.072 Y152.807 I1.693 J.169 E.0772
G1 X184.241 Y152.797 E.00563
G3 X182.556 Y154.675 I.007 J1.702 E.26042
G1 X182.556 Y154.439 E.00784
; COOLING_NODE: 1
M204 S250
G1 X182.946 Y154.378 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F8886
M204 S5000
G1 X182.946 Y154.369 E.00028
G3 X184.113 Y153.197 I1.303 J.13 E.05501
G1 X184.244 Y153.19 E.00402
G3 X182.947 Y154.636 I.005 J1.31 E.18558
G1 X182.946 Y154.438 E.00608
; COOLING_NODE: 1
; WIPE_START
G1 F9547.055
M204 S8000
G1 X182.946 Y154.369 E-.02623
G1 X182.997 Y154.117 E-.0977
G1 X183.093 Y153.885 E-.0956
G1 X183.246 Y153.658 E-.10372
G1 X183.421 Y153.486 E-.09338
G1 X183.615 Y153.354 E-.08943
G1 X183.866 Y153.247 E-.10345
G1 X184.113 Y153.197 E-.09582
G1 X184.244 Y153.19 E-.04976
G1 X184.257 Y153.191 E-.00491
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X185.686 Y152.434 Z2.6 F60000
G1 Z2.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X185.741 Y152.266 E.00587
G1 X186.484 Y152.266 E.02463
G1 X186.484 Y153.009 E.02463
G1 X186.317 Y153.065 E.00583
G2 X185.734 Y152.471 I-2.668 J2.039 E.02768
; COOLING_NODE: 1
; WIPE_START
G1 X185.741 Y152.266 E-.0779
G1 X186.484 Y152.266 E-.28213
G1 X186.484 Y153.009 E-.28219
G1 X186.317 Y153.065 E-.06681
G1 X186.231 Y152.962 E-.05098
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X178.629 Y153.643 Z2.6 F60000
G1 X163.704 Y154.981 Z2.6
G1 Z2.2
G1 E.8 F1800
G1 F8843.478
M204 S8000
G1 X163.65 Y154.716 E.00896
G3 X165.529 Y152.401 I2.098 J-.217 E.10984
G1 X165.739 Y152.39 E.00697
G3 X163.73 Y155.114 I.009 J2.109 E.30932
G1 X163.716 Y155.04 E.00249
; COOLING_NODE: 1
M204 S10000
G1 X164.102 Y154.901 F60000
G1 F8843.478
M204 S8000
G1 X164.056 Y154.675 E.00764
G3 X165.572 Y152.807 I1.693 J-.176 E.08865
G1 X165.741 Y152.797 E.00563
G3 X164.121 Y154.996 I.007 J1.702 E.24956
G1 X164.114 Y154.96 E.00121
; COOLING_NODE: 2
M204 S250
G1 X164.485 Y154.824 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F8886
M204 S5000
G1 X164.447 Y154.636 E.00589
G3 X165.613 Y153.197 I1.302 J-.137 E.06322
G1 X165.744 Y153.19 E.00402
G3 X164.497 Y154.883 I.005 J1.31 E.17784
; COOLING_NODE: 2
; WIPE_START
G1 F9547.055
M204 S8000
G1 X164.447 Y154.636 E-.0956
G1 X164.446 Y154.369 E-.1014
G1 X164.497 Y154.117 E-.0977
G1 X164.593 Y153.885 E-.0956
G1 X164.746 Y153.658 E-.10372
G1 X164.921 Y153.486 E-.09338
G1 X165.115 Y153.354 E-.08943
G1 X165.317 Y153.268 E-.08317
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X163.683 Y153.065 Z2.6 F60000
G1 Z2.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X163.516 Y153.009 E.00583
G1 X163.516 Y152.266 E.02463
G1 X164.259 Y152.266 E.02462
G1 X164.314 Y152.434 E.00585
G2 X163.72 Y153.017 I2.019 J2.651 E.0277
; COOLING_NODE: 2
; WIPE_START
G1 X163.516 Y153.009 E-.0774
G1 X163.516 Y152.266 E-.28218
G1 X164.259 Y152.266 E-.28208
G1 X164.314 Y152.434 E-.06703
G1 X164.21 Y152.52 E-.05131
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X163.621 Y160.13 Z2.6 F60000
G1 X163.109 Y166.741 Z2.6
G1 Z2.2
G1 E.8 F1800
G1 F8843.478
M204 S8000
G1 X163.109 Y151.859 E.49365
G1 X186.891 Y151.859 E.78888
G1 X186.891 Y166.741 E.49365
G1 X163.169 Y166.741 E.78689
; COOLING_NODE: 2
M204 S10000
G1 X162.702 Y167.148 F60000
G1 F8843.478
M204 S8000
G1 X162.702 Y151.452 E.52066
G1 X187.298 Y151.452 E.81589
G1 X187.298 Y167.148 E.52066
G1 X162.762 Y167.148 E.8139
; COOLING_NODE: 0
M204 S250
G1 X162.31 Y167.54 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1915
M204 S5000
G1 X162.31 Y151.06 E.50639
G1 X187.69 Y151.06 E.77986
G1 X187.69 Y167.54 E.50639
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X162.37 Y167.54 E.77801
; WIPE_START
G1 F9547.055
M204 S8000
G1 X162.363 Y165.54 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X163.68 Y165.4 Z2.6 F60000
G1 Z2.2
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42325
G1 F8886
M204 S8000
G1 X164.28 Y166.001 E.0263
M73 P72 R3
G1 X164.818 Y166.001 E.01667
G1 X163.849 Y165.032 E.04244
G1 X163.849 Y164.494 E.01667
G1 X165.356 Y166.001 E.06601
G1 X165.893 Y166.001 E.01667
G1 X163.849 Y163.957 E.08959
G1 X163.849 Y163.419 E.01667
G1 X166.431 Y166.001 E.11316
G1 X166.969 Y166.001 E.01667
G1 X163.849 Y162.881 E.13674
G1 X163.849 Y162.343 E.01667
G1 X167.507 Y166.001 E.16031
G1 X168.045 Y166.001 E.01667
G1 X163.849 Y161.805 E.18388
G1 X163.849 Y161.267 E.01667
G1 X168.583 Y166.001 E.20746
G1 X169.121 Y166.001 E.01667
G1 X163.849 Y160.729 E.23103
G1 X163.849 Y160.191 E.01667
G1 X169.659 Y166.001 E.25461
G1 X170.196 Y166.001 E.01667
G1 X163.849 Y159.654 E.27818
G1 X163.849 Y159.116 E.01667
G1 X170.734 Y166.001 E.30176
G1 X171.272 Y166.001 E.01667
G1 X163.849 Y158.578 E.32533
G1 X163.849 Y158.04 E.01667
G1 X171.81 Y166.001 E.34891
G1 X172.348 Y166.001 E.01667
G1 X163.849 Y157.502 E.37248
G1 X163.849 Y156.983 E.0161
G1 X163.934 Y157.049 E.00333
G1 X172.886 Y166.001 E.39235
G1 X173.424 Y166.001 E.01667
G1 X164.459 Y157.036 E.3929
G2 X165.268 Y157.307 I1.28 J-2.479 E.02654
G1 X173.961 Y166.001 E.38103
G1 X174.499 Y166.001 E.01667
G1 X165.846 Y157.347 E.37928
G2 X166.328 Y157.291 I-.149 J-3.395 E.01505
G1 X175.037 Y166.001 E.38173
G1 X175.575 Y166.001 E.01667
G1 X166.744 Y157.169 E.38708
G2 X167.115 Y157.003 I-.606 J-1.853 E.01264
G1 X176.113 Y166.001 E.39437
G1 X176.651 Y166.001 E.01667
G1 X167.437 Y156.786 E.40385
G2 X167.734 Y156.546 I-.694 J-1.159 E.01189
G1 X177.189 Y166.001 E.4144
G1 X177.727 Y166.001 E.01667
G1 X167.989 Y156.263 E.42678
G2 X168.202 Y155.938 I-.987 J-.879 E.01208
G1 X178.264 Y166.001 E.44102
G1 X178.802 Y166.001 E.01667
G1 X168.387 Y155.585 E.45651
G2 X168.513 Y155.174 I-2.821 J-1.094 E.01335
G1 X179.34 Y166.001 E.47454
G1 X179.878 Y166.001 E.01667
G1 X168.591 Y154.713 E.49472
G2 X168.579 Y154.163 I-2.999 J-.209 E.01707
G1 X180.416 Y166.001 E.51882
G1 X180.954 Y166.001 E.01667
G1 X168.378 Y153.425 E.55119
G2 X167.872 Y152.599 I-2.157 J.755 E.03023
G1 X168.091 Y152.599 E.00678
G1 X181.492 Y166.001 E.58736
G1 X182.029 Y166.001 E.01667
G1 X168.628 Y152.599 E.58736
G1 X169.166 Y152.599 E.01667
G1 X182.567 Y166.001 E.58736
G1 X183.105 Y166.001 E.01667
G1 X169.704 Y152.599 E.58736
G1 X170.242 Y152.599 E.01667
G1 X183.643 Y166.001 E.58736
G1 X184.181 Y166.001 E.01667
G1 X170.78 Y152.599 E.58736
G1 X171.318 Y152.599 E.01667
G1 X184.719 Y166.001 E.58736
G1 X185.257 Y166.001 E.01667
G1 X171.856 Y152.599 E.58736
G1 X172.393 Y152.599 E.01667
G1 X185.795 Y166.001 E.58736
G1 X186.151 Y166.001 E.01103
G1 X186.151 Y165.819 E.00564
G1 X172.931 Y152.599 E.57939
G1 X173.469 Y152.599 E.01667
G1 X186.151 Y165.281 E.55581
G1 X186.151 Y164.743 E.01667
G1 X174.007 Y152.599 E.53224
G1 X174.545 Y152.599 E.01667
G1 X186.151 Y164.205 E.50867
G1 X186.151 Y163.667 E.01667
G1 X175.083 Y152.599 E.48509
G1 X175.621 Y152.599 E.01667
G1 X186.151 Y163.129 E.46152
G1 X186.151 Y162.591 E.01667
G1 X176.159 Y152.599 E.43794
G1 X176.696 Y152.599 E.01667
G1 X186.151 Y162.054 E.41437
G1 X186.151 Y161.516 E.01667
G1 X177.234 Y152.599 E.39079
G1 X177.772 Y152.599 E.01667
G1 X186.32 Y161.148 E.37466
; WIPE_START
G1 F9465.464
G1 X184.906 Y159.733 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X186.467 Y153.229 Z2.6 F60000
G1 Z2.2
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.346114
G1 F8886
M204 S8000
G3 X186.553 Y153.679 I-9.187 J2 E.01132
; LINE_WIDTH: 0.291711
G1 X186.572 Y153.788 E.00225
; LINE_WIDTH: 0.256557
G1 X186.588 Y153.916 E.00225
; LINE_WIDTH: 0.226516
G1 X186.603 Y154.033 E.00176
; LINE_WIDTH: 0.183045
G1 X186.626 Y154.497 E.0053
G1 X186.603 Y154.961 E.00531
; LINE_WIDTH: 0.235749
G1 X186.579 Y155.168 E.00328
; LINE_WIDTH: 0.281264
G1 X186.557 Y155.297 E.00253
; LINE_WIDTH: 0.32247
G1 X186.538 Y155.415 E.00272
; LINE_WIDTH: 0.345229
G1 X186.468 Y155.772 E.00896
M204 S10000
G1 X186.28 Y156.384 F60000
; LINE_WIDTH: 0.114004
G1 F8886
M204 S8000
G1 X186.098 Y156.527 E.00134
M204 S10000
G1 X186.32 Y157.382 F60000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42325
G1 F8886
M204 S8000
G1 X185.811 Y156.873 E.02234
G3 X185.472 Y157.072 I-.846 J-1.048 E.01222
G1 X186.151 Y157.751 E.02973
G1 X186.151 Y158.289 E.01667
G1 X185.088 Y157.226 E.04658
G3 X184.645 Y157.321 I-1.083 J-3.979 E.01405
G1 X186.151 Y158.826 E.066
G1 X186.151 Y159.364 E.01667
G1 X184.132 Y157.346 E.08847
G3 X183.494 Y157.246 I.123 J-2.874 E.02004
G1 X186.151 Y159.902 E.11642
G1 X186.151 Y160.44 E.01667
G1 X178.31 Y152.599 E.34364
G1 X178.848 Y152.599 E.01667
G1 X181.506 Y155.258 E.1165
G1 X181.414 Y154.799 E.01451
G1 X181.404 Y154.618 E.0056
G1 X179.386 Y152.599 E.08847
G1 X179.924 Y152.599 E.01667
G1 X181.429 Y154.105 E.06599
G3 X181.524 Y153.662 I2.295 J.259 E.01407
G1 X180.462 Y152.599 E.04656
G1 X180.999 Y152.599 E.01667
G1 X181.681 Y153.282 E.0299
G3 X181.87 Y152.932 I1.273 J.46 E.01235
G1 X181.368 Y152.43 E.02201
M204 S10000
G1 X182.207 Y152.669 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.116973
G1 F8886
M204 S8000
G1 X182.362 Y152.47 E.00152
M204 S10000
G1 X182.979 Y152.285 F60000
; LINE_WIDTH: 0.356016
G1 F8886
M204 S8000
G3 X183.41 Y152.2 I1.827 J8.177 E.01121
; LINE_WIDTH: 0.296703
G1 X183.529 Y152.179 E.00248
; LINE_WIDTH: 0.260417
G1 X183.646 Y152.164 E.0021
; LINE_WIDTH: 0.231968
G1 X183.752 Y152.15 E.00165
; LINE_WIDTH: 0.198828
G1 X183.997 Y152.131 E.00312
; LINE_WIDTH: 0.178609
G1 X184.698 Y152.145 E.00775
; LINE_WIDTH: 0.221608
G1 X184.812 Y152.159 E.00168
; LINE_WIDTH: 0.247686
G1 X184.918 Y152.171 E.00179
; LINE_WIDTH: 0.281371
G1 X185.047 Y152.193 E.00254
; LINE_WIDTH: 0.32275
G1 X185.166 Y152.213 E.00274
; LINE_WIDTH: 0.345644
G1 X185.522 Y152.282 E.00895
; WIPE_START
G1 F11892.032
G1 X185.166 Y152.213 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X177.533 Y152.242 Z2.6 F60000
G1 X167.022 Y152.282 Z2.6
G1 Z2.2
G1 E.8 F1800
G1 F8886
M204 S8000
G1 X166.666 Y152.213 E.00895
; LINE_WIDTH: 0.32275
G1 X166.547 Y152.193 E.00274
; LINE_WIDTH: 0.281371
G1 X166.418 Y152.171 E.00254
; LINE_WIDTH: 0.247686
G1 X166.312 Y152.159 E.00179
; LINE_WIDTH: 0.221608
G1 X166.198 Y152.145 E.00168
; LINE_WIDTH: 0.178609
G1 X165.497 Y152.131 E.00775
; LINE_WIDTH: 0.198828
G1 X165.252 Y152.15 E.00312
; LINE_WIDTH: 0.231968
G1 X165.146 Y152.164 E.00165
; LINE_WIDTH: 0.260417
G1 X165.029 Y152.179 E.0021
; LINE_WIDTH: 0.296703
G1 X164.91 Y152.2 E.00248
; LINE_WIDTH: 0.356016
G2 X164.479 Y152.285 I1.395 J8.259 E.01121
M204 S10000
G1 X163.534 Y153.229 F60000
; LINE_WIDTH: 0.357475
M73 P73 R3
G1 F8886
M204 S8000
G1 X163.468 Y153.555 E.00851
; LINE_WIDTH: 0.334285
G1 X163.448 Y153.67 E.00278
; LINE_WIDTH: 0.291825
G1 X163.426 Y153.797 E.00261
; LINE_WIDTH: 0.255547
G1 X163.412 Y153.916 E.00207
; LINE_WIDTH: 0.225398
G1 X163.396 Y154.043 E.0019
; LINE_WIDTH: 0.182951
G1 X163.374 Y154.498 E.0052
G1 X163.397 Y154.967 E.00536
; LINE_WIDTH: 0.226509
G1 X163.412 Y155.083 E.00175
; LINE_WIDTH: 0.256417
G1 X163.427 Y155.211 E.00223
; LINE_WIDTH: 0.291533
G1 X163.446 Y155.32 E.00225
; LINE_WIDTH: 0.346001
G2 X163.533 Y155.771 I9.648 J-1.613 E.01133
M204 S10000
G1 X163.72 Y156.385 F60000
; LINE_WIDTH: 0.114755
G1 F8886
M204 S8000
G1 X163.907 Y156.532 E.00139
; CHANGE_LAYER
; Z_HEIGHT: 2.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F15000
G1 X163.72 Y156.385 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 12/47
; update layer progress
M73 L12
M991 S0 P11 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 1
M204 S10000
G17
G3 Z2.6 I.149 J1.208 P1  F60000
G1 X181.764 Y154.163 Z2.6
G1 Z2.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8841
M204 S8000
G1 X181.742 Y154.286 E.00413
G2 X186.314 Y155.937 I2.508 J.213 E.21855
G1 X186.484 Y155.992 E.00591
G1 X186.484 Y166.334 E.34307
G1 X163.516 Y166.334 E.76188
G1 X163.516 Y155.993 E.34303
G1 X163.682 Y155.936 E.00581
G2 X167.186 Y152.435 I2.067 J-1.436 E.29196
G1 X167.241 Y152.266 E.00589
G1 X182.757 Y152.266 E.51471
G1 X182.814 Y152.432 E.0058
G2 X181.828 Y153.811 I1.436 J2.067 E.05734
G1 X181.775 Y154.104 E.0099
; COOLING_NODE: 1
M204 S10000
G1 X182.163 Y154.236 F60000
G1 F8841
M204 S8000
G1 X182.221 Y153.922 E.0106
G3 X184.027 Y152.402 I2.029 J.577 E.08313
G1 X184.225 Y152.39 E.00657
G3 X182.148 Y154.32 I.024 J2.109 E.33643
G1 X182.152 Y154.295 E.00083
; COOLING_NODE: 1
M204 S10000
G1 X182.562 Y154.309 F60000
G1 F8841
M204 S8000
G1 X182.613 Y154.033 E.00931
G3 X184.071 Y152.807 I1.637 J.466 E.06707
G1 X184.229 Y152.797 E.00527
G3 X182.553 Y154.368 I.02 J1.702 E.27101
; COOLING_NODE: 1
M204 S250
G1 X182.946 Y154.38 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F8841
M204 S5000
G1 X182.99 Y154.14 E.00749
G3 X184.113 Y153.197 I1.259 J.359 E.04781
G1 X184.233 Y153.19 E.00371
G3 X182.942 Y154.439 I.016 J1.309 E.19193
; COOLING_NODE: 1
; WIPE_START
G1 F9547.055
M204 S8000
G1 X182.99 Y154.14 E-.11531
G1 X183.083 Y153.904 E-.09614
G1 X183.231 Y153.677 E-.10329
G1 X183.407 Y153.497 E-.09555
G1 X183.615 Y153.354 E-.09588
G1 X183.866 Y153.247 E-.1037
G1 X184.113 Y153.197 E-.09571
G1 X184.233 Y153.19 E-.04589
G1 X184.256 Y153.192 E-.00852
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X185.686 Y152.435 Z2.8 F60000
G1 Z2.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8841
M204 S8000
G1 X185.741 Y152.266 E.00589
G1 X186.484 Y152.266 E.02465
G1 X186.484 Y153.007 E.02458
G1 X186.318 Y153.064 E.00581
G2 X185.733 Y152.472 I-2.682 J2.064 E.02767
; COOLING_NODE: 1
; WIPE_START
G1 F8843.478
G1 X185.741 Y152.266 E-.07814
G1 X186.484 Y152.266 E-.28234
G1 X186.484 Y153.007 E-.28163
G1 X186.318 Y153.064 E-.06651
G1 X186.231 Y152.961 E-.05138
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X178.631 Y153.669 Z2.8 F60000
G1 X163.724 Y155.059 Z2.8
G1 Z2.4
G1 E.8 F1800
G1 F8841
M204 S8000
G1 X163.687 Y154.939 E.00417
G3 X165.527 Y152.402 I2.062 J-.44 E.11722
G1 X165.725 Y152.39 E.00657
G3 X163.818 Y155.347 I.024 J2.109 E.30151
G1 X163.743 Y155.116 E.00807
; COOLING_NODE: 1
M204 S10000
G1 X164.11 Y154.934 F60000
G1 F8841
M204 S8000
G1 X164.085 Y154.854 E.00278
G3 X165.571 Y152.807 I1.664 J-.355 E.0946
G1 X165.729 Y152.797 E.00527
G3 X164.192 Y155.184 I.02 J1.702 E.24328
G1 X164.129 Y154.991 E.00672
; COOLING_NODE: 2
M204 S250
G1 X164.482 Y154.815 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F8841
M204 S5000
G1 X164.469 Y154.773 E.00134
G3 X165.613 Y153.197 I1.28 J-.273 E.06745
G1 X165.733 Y153.19 E.00371
G3 X164.551 Y155.027 I.016 J1.309 E.1734
G1 X164.501 Y154.872 E.00502
; COOLING_NODE: 2
; WIPE_START
G1 F9547.055
M204 S8000
G1 X164.469 Y154.773 E-.03943
G1 X164.447 Y154.637 E-.0521
G1 X164.445 Y154.386 E-.09544
G1 X164.49 Y154.14 E-.09517
G1 X164.583 Y153.904 E-.09615
G1 X164.731 Y153.677 E-.10329
G1 X164.907 Y153.497 E-.09555
G1 X165.115 Y153.354 E-.09588
G1 X165.326 Y153.264 E-.08699
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X163.685 Y153.064 Z2.8 F60000
G1 Z2.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8841
M204 S8000
G1 X163.516 Y153.009 E.00589
G1 X163.516 Y152.266 E.02465
G1 X164.257 Y152.266 E.02458
G1 X164.314 Y152.432 E.0058
G2 X163.722 Y153.017 I2.071 J2.688 E.02767
; COOLING_NODE: 2
; WIPE_START
G1 F8843.478
G1 X163.516 Y153.009 E-.07816
G1 X163.516 Y152.266 E-.28233
G1 X164.257 Y152.266 E-.28161
G1 X164.314 Y152.432 E-.0665
G1 X164.21 Y152.519 E-.05141
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X163.621 Y160.129 Z2.8 F60000
G1 X163.109 Y166.741 Z2.8
G1 Z2.4
G1 E.8 F1800
G1 F8841
M204 S8000
G1 X163.109 Y151.859 E.49365
G1 X186.891 Y151.859 E.78888
G1 X186.891 Y166.741 E.49365
G1 X163.169 Y166.741 E.78689
; COOLING_NODE: 2
M204 S10000
G1 X162.702 Y167.148 F60000
G1 F8841
M204 S8000
G1 X162.702 Y151.452 E.52066
G1 X187.298 Y151.452 E.81589
G1 X187.298 Y167.148 E.52066
G1 X162.762 Y167.148 E.8139
; COOLING_NODE: 0
M204 S250
G1 X162.31 Y167.54 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1956
M204 S5000
G1 X162.31 Y151.06 E.50639
G1 X187.69 Y151.06 E.77986
G1 X187.69 Y167.54 E.50639
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X162.37 Y167.54 E.77801
; WIPE_START
G1 F9547.055
M204 S8000
G1 X162.363 Y165.54 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X163.768 Y158.038 Z2.8 F60000
G1 X164.046 Y156.556 Z2.8
G1 Z2.4
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42234
G1 F8841
M204 S8000
G1 X163.849 Y156.752 E.00858
G1 X163.849 Y157.289 E.01659
G1 X164.228 Y156.91 E.01656
G2 X164.579 Y157.096 I1.06 J-1.573 E.01229
G1 X163.849 Y157.825 E.03189
G1 X163.849 Y158.362 E.01659
G1 X164.97 Y157.241 E.04899
G1 X165.423 Y157.325 E.01424
G1 X163.849 Y158.898 E.06879
G1 X163.849 Y159.435 E.01659
G1 X165.943 Y157.341 E.09154
G1 X166.098 Y157.331 E.00482
G1 X166.6 Y157.221 E.01589
G1 X163.849 Y159.972 E.12028
G1 X163.849 Y160.508 E.01659
G1 X171.758 Y152.599 E.3458
G1 X172.295 Y152.599 E.01659
G1 X163.849 Y161.045 E.36926
G1 X163.849 Y161.581 E.01659
G1 X172.831 Y152.599 E.39273
G1 X173.368 Y152.599 E.01659
M73 P74 R3
G1 X163.849 Y162.118 E.41619
G1 X163.849 Y162.654 E.01659
G1 X173.904 Y152.599 E.43965
G1 X174.441 Y152.599 E.01659
G1 X163.849 Y163.191 E.46311
G1 X163.849 Y163.728 E.01659
G1 X174.978 Y152.599 E.48657
G1 X175.514 Y152.599 E.01659
G1 X163.849 Y164.264 E.51003
G1 X163.849 Y164.801 E.01659
G1 X176.051 Y152.599 E.5335
G1 X176.587 Y152.599 E.01659
G1 X163.849 Y165.337 E.55696
G1 X163.849 Y165.874 E.01659
G1 X177.124 Y152.599 E.58042
G1 X177.661 Y152.599 E.01659
G1 X164.259 Y166.001 E.58596
G1 X164.796 Y166.001 E.01659
G1 X178.197 Y152.599 E.58596
G1 X178.734 Y152.599 E.01659
G1 X165.333 Y166.001 E.58596
G1 X165.869 Y166.001 E.01659
G1 X179.27 Y152.599 E.58596
G1 X179.807 Y152.599 E.01659
G1 X166.406 Y166.001 E.58596
G1 X166.942 Y166.001 E.01659
G1 X180.343 Y152.599 E.58596
G1 X180.88 Y152.599 E.01659
G1 X167.479 Y166.001 E.58596
G1 X168.015 Y166.001 E.01659
G1 X181.417 Y152.599 E.58596
G1 X181.953 Y152.599 E.01659
G1 X168.552 Y166.001 E.58596
G1 X169.089 Y166.001 E.01659
G1 X181.577 Y153.512 E.54606
G1 X181.505 Y153.727 E.00703
G1 X181.417 Y154.209 E.01515
G1 X169.625 Y166.001 E.51557
G1 X170.162 Y166.001 E.01659
G1 X181.413 Y154.749 E.49195
G2 X181.491 Y155.208 I2.865 J-.253 E.01439
G1 X170.698 Y166.001 E.47191
G1 X171.235 Y166.001 E.01659
G1 X181.633 Y155.602 E.45466
G2 X181.809 Y155.963 I1.009 J-.27 E.01248
G1 X171.772 Y166.001 E.4389
G1 X172.308 Y166.001 E.01659
G1 X182.029 Y156.28 E.42502
G2 X182.282 Y156.563 I2.829 J-2.278 E.01175
G1 X172.845 Y166.001 E.41264
G1 X173.381 Y166.001 E.01659
G1 X182.581 Y156.801 E.40227
G2 X182.906 Y157.013 I.881 J-.994 E.01203
G1 X173.918 Y166.001 E.393
G1 X174.454 Y166.001 E.01659
G1 X183.277 Y157.178 E.38575
G2 X183.704 Y157.287 I.587 J-1.409 E.01369
G1 X174.991 Y166.001 E.38098
G1 X175.528 Y166.001 E.01659
G1 X184.181 Y157.347 E.37835
G2 X184.772 Y157.292 I.077 J-2.378 E.01842
G1 X176.064 Y166.001 E.38076
G1 X176.601 Y166.001 E.01659
G1 X185.585 Y157.016 E.39284
G1 X185.916 Y156.8 E.01222
G1 X186.09 Y157.027 E.00885
G1 X186.151 Y156.987 E.00223
G1 X177.137 Y166.001 E.3941
G1 X177.674 Y166.001 E.01659
G1 X186.151 Y157.524 E.37064
G1 X186.151 Y158.061 E.01659
G1 X178.211 Y166.001 E.34717
G1 X178.747 Y166.001 E.01659
G1 X186.151 Y158.597 E.32371
G1 X186.151 Y159.134 E.01659
G1 X179.284 Y166.001 E.30025
G1 X179.82 Y166.001 E.01659
G1 X186.151 Y159.67 E.27679
G1 X186.151 Y160.207 E.01659
G1 X180.357 Y166.001 E.25333
G1 X180.893 Y166.001 E.01659
G1 X186.151 Y160.743 E.22987
G1 X186.151 Y161.28 E.01659
G1 X181.43 Y166.001 E.2064
G1 X181.967 Y166.001 E.01659
G1 X186.151 Y161.817 E.18294
G1 X186.151 Y162.353 E.01659
M73 P74 R2
G1 X182.503 Y166.001 E.15948
G1 X183.04 Y166.001 E.01659
G1 X186.151 Y162.89 E.13602
G1 X186.151 Y163.426 E.01659
G1 X183.576 Y166.001 E.11256
G1 X184.113 Y166.001 E.01659
G1 X186.151 Y163.963 E.08909
G1 X186.151 Y164.5 E.01659
G1 X184.649 Y166.001 E.06563
G1 X185.186 Y166.001 E.01659
G1 X186.151 Y165.036 E.04217
G1 X186.151 Y165.573 E.01659
G1 X185.553 Y166.17 E.02613
M204 S10000
G1 X186.115 Y156.511 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.112566
G1 F8841
M204 S8000
G1 X186.28 Y156.38 E.0012
M204 S10000
G1 X186.47 Y155.773 F60000
; LINE_WIDTH: 0.332008
G1 F8841
M204 S8000
G1 X186.544 Y155.38 E.00942
; LINE_WIDTH: 0.311998
G1 X186.562 Y155.273 E.00237
; LINE_WIDTH: 0.275535
G1 X186.58 Y155.156 E.00225
; LINE_WIDTH: 0.243505
G1 X186.594 Y155.038 E.00194
; LINE_WIDTH: 0.215746
G1 X186.608 Y154.912 E.00179
; LINE_WIDTH: 0.177046
G1 X186.619 Y154.242 E.00732
; LINE_WIDTH: 0.199702
G1 X186.599 Y153.996 E.00316
; LINE_WIDTH: 0.235413
G1 X186.583 Y153.876 E.0019
; LINE_WIDTH: 0.268673
G1 X186.565 Y153.743 E.00246
; LINE_WIDTH: 0.308019
G1 X186.544 Y153.627 E.00254
; LINE_WIDTH: 0.368126
G2 X186.464 Y153.229 I-8.312 J1.471 E.01077
M204 S10000
G1 X185.522 Y152.282 F60000
; LINE_WIDTH: 0.346019
G1 F8841
M204 S8000
G1 X185.167 Y152.213 E.00893
; LINE_WIDTH: 0.325675
G1 X185.063 Y152.195 E.00242
; LINE_WIDTH: 0.288293
G1 X184.949 Y152.176 E.00232
; LINE_WIDTH: 0.254591
G1 X184.83 Y152.161 E.00206
; LINE_WIDTH: 0.224425
G1 X184.703 Y152.146 E.0019
; LINE_WIDTH: 0.178841
G1 X184.456 Y152.129 E.00274
G1 X183.994 Y152.131 E.00511
; LINE_WIDTH: 0.199091
G1 X183.752 Y152.151 E.0031
; LINE_WIDTH: 0.232063
G1 X183.646 Y152.164 E.00165
; LINE_WIDTH: 0.26049
G1 X183.528 Y152.179 E.00209
; LINE_WIDTH: 0.296792
G1 X183.41 Y152.2 E.00249
; LINE_WIDTH: 0.356196
G2 X182.979 Y152.285 I1.368 J8.101 E.01122
; WIPE_START
G1 F11491.476
G1 X183.41 Y152.2 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.966 Y153.886 Z2.8 F60000
G1 X168.169 Y155.652 Z2.8
G1 Z2.4
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42234
G1 F8841
M204 S8000
G1 X171.222 Y152.599 E.13348
G1 X170.685 Y152.599 E.01659
G1 X168.594 Y154.69 E.09143
G1 X168.581 Y154.167 E.01619
G1 X170.148 Y152.599 E.06854
G1 X169.612 Y152.599 E.01659
G1 X168.49 Y153.721 E.04906
G2 X168.34 Y153.335 I-1.361 J.307 E.01286
G1 X169.075 Y152.599 E.03216
G1 X168.539 Y152.599 E.01659
G1 X168.032 Y153.106 E.02215
M204 S10000
G1 X167.761 Y152.635 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.112445
G1 F8841
M204 S8000
G1 X167.63 Y152.47 E.0012
M204 S10000
G1 X167.022 Y152.282 F60000
; LINE_WIDTH: 0.346019
G1 F8841
M204 S8000
G1 X166.667 Y152.213 E.00893
; LINE_WIDTH: 0.325675
G1 X166.563 Y152.195 E.00242
; LINE_WIDTH: 0.288293
G1 X166.449 Y152.176 E.00232
; LINE_WIDTH: 0.254591
G1 X166.33 Y152.161 E.00206
; LINE_WIDTH: 0.224425
G1 X166.203 Y152.146 E.0019
; LINE_WIDTH: 0.178841
G1 X165.956 Y152.129 E.00274
G1 X165.494 Y152.131 E.00511
; LINE_WIDTH: 0.199091
G1 X165.252 Y152.151 E.0031
; LINE_WIDTH: 0.232063
G1 X165.146 Y152.164 E.00165
; LINE_WIDTH: 0.26049
G1 X165.028 Y152.179 E.00209
; LINE_WIDTH: 0.296792
G1 X164.91 Y152.2 E.00249
; LINE_WIDTH: 0.356195
G2 X164.479 Y152.285 I1.366 J8.094 E.01122
M204 S10000
G1 X163.53 Y153.228 F60000
; LINE_WIDTH: 0.334752
G1 F8841
M204 S8000
G1 X163.457 Y153.613 E.00931
; LINE_WIDTH: 0.314159
G1 X163.439 Y153.722 E.00245
; LINE_WIDTH: 0.276513
G1 X163.42 Y153.842 E.00232
; LINE_WIDTH: 0.244105
G1 X163.407 Y153.958 E.00191
; LINE_WIDTH: 0.216826
G1 X163.393 Y154.082 E.00176
; LINE_WIDTH: 0.177288
G1 X163.381 Y154.757 E.0074
; LINE_WIDTH: 0.199681
G1 X163.401 Y155.005 E.00317
; LINE_WIDTH: 0.235427
G1 X163.417 Y155.125 E.0019
; LINE_WIDTH: 0.268704
G1 X163.435 Y155.257 E.00246
; LINE_WIDTH: 0.308008
G1 X163.456 Y155.372 E.00254
; LINE_WIDTH: 0.368029
G2 X163.536 Y155.771 I8.272 J-1.464 E.01077
; CHANGE_LAYER
; Z_HEIGHT: 2.6
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F11073.212
G1 X163.456 Y155.372 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 13/47
; update layer progress
M73 L13
M991 S0 P12 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 1
M204 S10000
G17
G3 Z2.8 I.07 J1.215 P1  F60000
G1 X181.741 Y154.318 Z2.8
G1 Z2.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X181.74 Y154.502 E.0061
G2 X186.315 Y155.936 I2.515 J-.007 E.21092
G1 X186.484 Y155.991 E.00589
G1 X186.484 Y166.334 E.3431
G1 X163.516 Y166.334 E.76188
G1 X163.516 Y155.991 E.34308
G1 X163.683 Y155.935 E.00583
G2 X167.186 Y152.434 I2.068 J-1.434 E.29208
M73 P75 R2
G1 X167.241 Y152.266 E.00587
G1 X182.759 Y152.266 E.51473
G1 X182.814 Y152.434 E.00585
G2 X181.752 Y154.251 I1.44 J2.061 E.07206
G1 X181.751 Y154.258 E.00023
; COOLING_NODE: 1
M204 S10000
G1 X182.15 Y154.379 F60000
G1 F8843.478
M204 S8000
G1 X182.149 Y154.291 E.00295
G3 X184.029 Y152.401 I2.099 J.208 E.0957
G1 X184.239 Y152.39 E.00697
G3 X182.15 Y154.716 I.009 J2.109 E.32278
G1 X182.15 Y154.439 E.00918
; COOLING_NODE: 1
M204 S10000
G1 X182.556 Y154.379 F60000
G1 F8843.478
M204 S8000
G1 X182.555 Y154.331 E.0016
G3 X184.072 Y152.807 I1.693 J.169 E.0772
G1 X184.241 Y152.797 E.00563
G3 X182.556 Y154.675 I.007 J1.702 E.26042
G1 X182.556 Y154.439 E.00784
; COOLING_NODE: 1
M204 S250
G1 X182.946 Y154.378 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F8891
M204 S5000
G1 X182.946 Y154.369 E.00028
G3 X184.113 Y153.197 I1.303 J.13 E.05501
G1 X184.244 Y153.19 E.00402
G3 X182.947 Y154.636 I.005 J1.31 E.18558
G1 X182.946 Y154.438 E.00608
; COOLING_NODE: 1
; WIPE_START
G1 F9547.055
M204 S8000
G1 X182.946 Y154.369 E-.02623
G1 X182.997 Y154.117 E-.0977
G1 X183.093 Y153.885 E-.0956
G1 X183.246 Y153.658 E-.10372
G1 X183.421 Y153.486 E-.09339
G1 X183.615 Y153.354 E-.08943
G1 X183.866 Y153.247 E-.10344
G1 X184.113 Y153.197 E-.09582
G1 X184.244 Y153.19 E-.04976
G1 X184.257 Y153.191 E-.00491
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X185.686 Y152.434 Z3 F60000
G1 Z2.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X185.741 Y152.266 E.00587
G1 X186.484 Y152.266 E.02463
G1 X186.484 Y153.009 E.02463
G1 X186.317 Y153.065 E.00583
G2 X185.734 Y152.471 I-2.668 J2.039 E.02768
; COOLING_NODE: 1
; WIPE_START
G1 X185.741 Y152.266 E-.0779
G1 X186.484 Y152.266 E-.28213
G1 X186.484 Y153.009 E-.28219
G1 X186.317 Y153.065 E-.06681
G1 X186.231 Y152.962 E-.05098
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X178.629 Y153.643 Z3 F60000
G1 X163.704 Y154.981 Z3
G1 Z2.6
G1 E.8 F1800
G1 F8843.478
M204 S8000
G1 X163.65 Y154.716 E.00896
G3 X165.529 Y152.401 I2.098 J-.217 E.10984
G1 X165.739 Y152.39 E.00697
G3 X163.73 Y155.114 I.009 J2.109 E.30932
G1 X163.716 Y155.04 E.00249
; COOLING_NODE: 1
M204 S10000
G1 X164.102 Y154.901 F60000
G1 F8843.478
M204 S8000
G1 X164.056 Y154.675 E.00764
G3 X165.572 Y152.807 I1.693 J-.176 E.08865
G1 X165.741 Y152.797 E.00563
G3 X164.121 Y154.996 I.007 J1.702 E.24956
G1 X164.114 Y154.96 E.00121
; COOLING_NODE: 2
M204 S250
G1 X164.485 Y154.824 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F8891
M204 S5000
G1 X164.447 Y154.636 E.00589
G3 X165.613 Y153.197 I1.302 J-.137 E.06322
G1 X165.744 Y153.19 E.00402
G3 X164.497 Y154.883 I.005 J1.31 E.17784
; COOLING_NODE: 2
; WIPE_START
G1 F9547.055
M204 S8000
G1 X164.447 Y154.636 E-.0956
G1 X164.446 Y154.369 E-.1014
G1 X164.497 Y154.117 E-.0977
G1 X164.593 Y153.885 E-.0956
G1 X164.746 Y153.658 E-.10372
G1 X164.921 Y153.486 E-.09339
G1 X165.115 Y153.354 E-.08943
G1 X165.317 Y153.268 E-.08317
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X163.683 Y153.065 Z3 F60000
G1 Z2.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X163.516 Y153.009 E.00583
G1 X163.516 Y152.266 E.02463
G1 X164.259 Y152.266 E.02462
G1 X164.314 Y152.434 E.00585
G2 X163.72 Y153.017 I2.02 J2.651 E.0277
; COOLING_NODE: 2
; WIPE_START
G1 X163.516 Y153.009 E-.0774
G1 X163.516 Y152.266 E-.28218
G1 X164.259 Y152.266 E-.28208
G1 X164.314 Y152.434 E-.06703
G1 X164.21 Y152.52 E-.05131
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X163.621 Y160.13 Z3 F60000
G1 X163.109 Y166.741 Z3
G1 Z2.6
G1 E.8 F1800
G1 F8843.478
M204 S8000
G1 X163.109 Y151.859 E.49365
G1 X186.891 Y151.859 E.78888
G1 X186.891 Y166.741 E.49365
G1 X163.169 Y166.741 E.78689
; COOLING_NODE: 2
M204 S10000
G1 X162.702 Y167.148 F60000
G1 F8843.478
M204 S8000
G1 X162.702 Y151.452 E.52066
G1 X187.298 Y151.452 E.81589
G1 X187.298 Y167.148 E.52066
G1 X162.762 Y167.148 E.8139
; COOLING_NODE: 0
M204 S250
G1 X162.31 Y167.54 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1986
M204 S5000
G1 X162.31 Y151.06 E.50639
G1 X187.69 Y151.06 E.77986
G1 X187.69 Y167.54 E.50639
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X162.37 Y167.54 E.77801
; WIPE_START
G1 F9547.055
M204 S8000
G1 X162.363 Y165.54 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X163.68 Y165.4 Z3 F60000
G1 Z2.6
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42325
G1 F8891
M204 S8000
G1 X164.28 Y166.001 E.0263
G1 X164.818 Y166.001 E.01667
G1 X163.849 Y165.032 E.04244
G1 X163.849 Y164.494 E.01667
G1 X165.356 Y166.001 E.06601
G1 X165.893 Y166.001 E.01667
G1 X163.849 Y163.957 E.08959
G1 X163.849 Y163.419 E.01667
G1 X166.431 Y166.001 E.11316
G1 X166.969 Y166.001 E.01667
G1 X163.849 Y162.881 E.13674
G1 X163.849 Y162.343 E.01667
G1 X167.507 Y166.001 E.16031
G1 X168.045 Y166.001 E.01667
G1 X163.849 Y161.805 E.18388
G1 X163.849 Y161.267 E.01667
G1 X168.583 Y166.001 E.20746
G1 X169.121 Y166.001 E.01667
G1 X163.849 Y160.729 E.23103
G1 X163.849 Y160.191 E.01667
G1 X169.659 Y166.001 E.25461
G1 X170.196 Y166.001 E.01667
G1 X163.849 Y159.654 E.27818
G1 X163.849 Y159.116 E.01667
G1 X170.734 Y166.001 E.30176
G1 X171.272 Y166.001 E.01667
G1 X163.849 Y158.578 E.32533
G1 X163.849 Y158.04 E.01667
G1 X171.81 Y166.001 E.34891
G1 X172.348 Y166.001 E.01667
G1 X163.849 Y157.502 E.37248
G1 X163.849 Y156.983 E.0161
G1 X163.934 Y157.049 E.00333
G1 X172.886 Y166.001 E.39235
M73 P76 R2
G1 X173.424 Y166.001 E.01667
G1 X164.459 Y157.036 E.3929
G2 X165.268 Y157.307 I1.28 J-2.479 E.02654
G1 X173.961 Y166.001 E.38103
G1 X174.499 Y166.001 E.01667
G1 X165.846 Y157.347 E.37928
G2 X166.328 Y157.291 I-.149 J-3.395 E.01505
G1 X175.037 Y166.001 E.38173
G1 X175.575 Y166.001 E.01667
G1 X166.744 Y157.169 E.38708
G2 X167.115 Y157.003 I-.606 J-1.853 E.01264
G1 X176.113 Y166.001 E.39437
G1 X176.651 Y166.001 E.01667
G1 X167.437 Y156.786 E.40385
G2 X167.734 Y156.546 I-.694 J-1.159 E.01189
G1 X177.189 Y166.001 E.4144
G1 X177.727 Y166.001 E.01667
G1 X167.989 Y156.263 E.42678
G2 X168.202 Y155.938 I-.987 J-.879 E.01208
G1 X178.264 Y166.001 E.44102
G1 X178.802 Y166.001 E.01667
G1 X168.387 Y155.585 E.45651
G2 X168.513 Y155.174 I-2.821 J-1.094 E.01335
G1 X179.34 Y166.001 E.47454
G1 X179.878 Y166.001 E.01667
G1 X168.591 Y154.713 E.49472
G2 X168.579 Y154.163 I-2.999 J-.209 E.01707
G1 X180.416 Y166.001 E.51882
G1 X180.954 Y166.001 E.01667
G1 X168.378 Y153.425 E.55119
G2 X167.872 Y152.599 I-2.157 J.755 E.03023
G1 X168.091 Y152.599 E.00678
G1 X181.492 Y166.001 E.58736
G1 X182.029 Y166.001 E.01667
G1 X168.628 Y152.599 E.58736
G1 X169.166 Y152.599 E.01667
G1 X182.567 Y166.001 E.58736
G1 X183.105 Y166.001 E.01667
G1 X169.704 Y152.599 E.58736
G1 X170.242 Y152.599 E.01667
G1 X183.643 Y166.001 E.58736
G1 X184.181 Y166.001 E.01667
G1 X170.78 Y152.599 E.58736
G1 X171.318 Y152.599 E.01667
G1 X184.719 Y166.001 E.58736
G1 X185.257 Y166.001 E.01667
G1 X171.856 Y152.599 E.58736
G1 X172.393 Y152.599 E.01667
G1 X185.795 Y166.001 E.58736
G1 X186.151 Y166.001 E.01103
G1 X186.151 Y165.819 E.00564
G1 X172.931 Y152.599 E.57939
G1 X173.469 Y152.599 E.01667
G1 X186.151 Y165.281 E.55581
G1 X186.151 Y164.743 E.01667
G1 X174.007 Y152.599 E.53224
G1 X174.545 Y152.599 E.01667
G1 X186.151 Y164.205 E.50867
G1 X186.151 Y163.667 E.01667
G1 X175.083 Y152.599 E.48509
G1 X175.621 Y152.599 E.01667
G1 X186.151 Y163.129 E.46152
G1 X186.151 Y162.591 E.01667
G1 X176.159 Y152.599 E.43794
G1 X176.696 Y152.599 E.01667
G1 X186.151 Y162.054 E.41437
G1 X186.151 Y161.516 E.01667
G1 X177.234 Y152.599 E.39079
G1 X177.772 Y152.599 E.01667
G1 X186.32 Y161.148 E.37466
; WIPE_START
G1 F9465.464
G1 X184.906 Y159.733 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X186.467 Y153.229 Z3 F60000
G1 Z2.6
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.346114
G1 F8891
M204 S8000
G3 X186.553 Y153.679 I-9.187 J2 E.01132
; LINE_WIDTH: 0.291711
G1 X186.572 Y153.788 E.00225
; LINE_WIDTH: 0.256557
G1 X186.588 Y153.916 E.00225
; LINE_WIDTH: 0.226516
G1 X186.603 Y154.033 E.00176
; LINE_WIDTH: 0.183045
G1 X186.626 Y154.497 E.0053
G1 X186.603 Y154.961 E.00531
; LINE_WIDTH: 0.235749
G1 X186.579 Y155.168 E.00328
; LINE_WIDTH: 0.281264
G1 X186.557 Y155.297 E.00253
; LINE_WIDTH: 0.32247
G1 X186.538 Y155.415 E.00272
; LINE_WIDTH: 0.345229
G1 X186.468 Y155.772 E.00896
M204 S10000
G1 X186.28 Y156.384 F60000
; LINE_WIDTH: 0.114004
G1 F8891
M204 S8000
G1 X186.098 Y156.527 E.00134
M204 S10000
G1 X186.32 Y157.382 F60000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42325
G1 F8891
M204 S8000
G1 X185.811 Y156.873 E.02234
G3 X185.472 Y157.072 I-.846 J-1.048 E.01222
G1 X186.151 Y157.751 E.02973
G1 X186.151 Y158.289 E.01667
G1 X185.088 Y157.226 E.04658
G3 X184.645 Y157.321 I-1.083 J-3.979 E.01405
G1 X186.151 Y158.826 E.066
G1 X186.151 Y159.364 E.01667
G1 X184.132 Y157.346 E.08847
G3 X183.494 Y157.246 I.123 J-2.874 E.02004
G1 X186.151 Y159.902 E.11642
G1 X186.151 Y160.44 E.01667
G1 X178.31 Y152.599 E.34365
G1 X178.848 Y152.599 E.01667
G1 X181.506 Y155.258 E.1165
G1 X181.414 Y154.799 E.01451
G1 X181.404 Y154.618 E.0056
G1 X179.386 Y152.599 E.08847
G1 X179.924 Y152.599 E.01667
G1 X181.429 Y154.105 E.06599
G3 X181.524 Y153.662 I2.295 J.259 E.01407
G1 X180.461 Y152.599 E.04656
G1 X180.999 Y152.599 E.01667
G1 X181.681 Y153.282 E.0299
G3 X181.87 Y152.932 I1.273 J.46 E.01235
G1 X181.368 Y152.43 E.02201
M204 S10000
G1 X182.207 Y152.669 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.116965
G1 F8891
M204 S8000
G1 X182.362 Y152.47 E.00152
M204 S10000
G1 X182.979 Y152.285 F60000
; LINE_WIDTH: 0.356073
G1 F8891
M204 S8000
G3 X183.41 Y152.2 I1.827 J8.178 E.01121
; LINE_WIDTH: 0.296704
G1 X183.529 Y152.179 E.00249
; LINE_WIDTH: 0.260402
G1 X183.646 Y152.164 E.0021
; LINE_WIDTH: 0.231963
G1 X183.752 Y152.15 E.00165
; LINE_WIDTH: 0.198828
G1 X183.997 Y152.131 E.00312
; LINE_WIDTH: 0.178615
G1 X184.698 Y152.145 E.00775
; LINE_WIDTH: 0.221669
G1 X184.812 Y152.159 E.00168
; LINE_WIDTH: 0.24784
G1 X184.919 Y152.171 E.00179
; LINE_WIDTH: 0.2815
G1 X185.047 Y152.193 E.00253
; LINE_WIDTH: 0.322739
G1 X185.165 Y152.212 E.00273
; LINE_WIDTH: 0.345545
G1 X185.522 Y152.282 E.00896
; WIPE_START
G1 F11895.92
G1 X185.165 Y152.212 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X177.533 Y152.242 Z3 F60000
G1 X167.022 Y152.282 Z3
G1 Z2.6
G1 E.8 F1800
G1 F8891
M204 S8000
G1 X166.665 Y152.212 E.00896
; LINE_WIDTH: 0.322739
G1 X166.547 Y152.193 E.00273
; LINE_WIDTH: 0.2815
G1 X166.419 Y152.171 E.00253
; LINE_WIDTH: 0.24784
G1 X166.312 Y152.159 E.00179
; LINE_WIDTH: 0.221669
G1 X166.198 Y152.145 E.00168
; LINE_WIDTH: 0.178615
G1 X165.497 Y152.131 E.00775
; LINE_WIDTH: 0.198828
G1 X165.252 Y152.15 E.00312
; LINE_WIDTH: 0.231963
G1 X165.146 Y152.164 E.00165
; LINE_WIDTH: 0.260402
G1 X165.029 Y152.179 E.0021
; LINE_WIDTH: 0.296704
G1 X164.91 Y152.2 E.00249
; LINE_WIDTH: 0.356073
G2 X164.479 Y152.285 I1.394 J8.256 E.01121
M204 S10000
G1 X163.534 Y153.229 F60000
; LINE_WIDTH: 0.357475
G1 F8891
M204 S8000
G1 X163.468 Y153.555 E.00851
; LINE_WIDTH: 0.334285
G1 X163.448 Y153.67 E.00278
; LINE_WIDTH: 0.291825
G1 X163.426 Y153.797 E.00261
; LINE_WIDTH: 0.255547
G1 X163.412 Y153.916 E.00207
; LINE_WIDTH: 0.225398
G1 X163.396 Y154.043 E.0019
; LINE_WIDTH: 0.182951
G1 X163.374 Y154.498 E.0052
G1 X163.397 Y154.967 E.00536
; LINE_WIDTH: 0.226509
G1 X163.412 Y155.083 E.00175
; LINE_WIDTH: 0.256417
G1 X163.427 Y155.211 E.00223
; LINE_WIDTH: 0.291533
G1 X163.446 Y155.32 E.00225
; LINE_WIDTH: 0.346001
G2 X163.533 Y155.771 I9.648 J-1.613 E.01133
M204 S10000
G1 X163.72 Y156.385 F60000
; LINE_WIDTH: 0.114755
G1 F8891
M204 S8000
G1 X163.907 Y156.532 E.00139
; CHANGE_LAYER
; Z_HEIGHT: 2.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F15000
G1 X163.72 Y156.385 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 14/47
; update layer progress
M73 L14
M991 S0 P13 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 1
M204 S10000
G17
G3 Z3 I.126 J1.21 P1  F60000
G1 X182.946 Y154.38 Z3
G1 Z2.8
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9136
M204 S5000
G1 X182.99 Y154.14 E.00749
G3 X184.113 Y153.197 I1.259 J.359 E.04781
G1 X184.233 Y153.19 E.00371
G3 X182.942 Y154.439 I.016 J1.309 E.19193
; COOLING_NODE: 2
; WIPE_START
G1 F9547.055
M204 S8000
G1 X182.99 Y154.14 E-.11531
G1 X183.083 Y153.904 E-.09614
G1 X183.231 Y153.677 E-.10329
G1 X183.407 Y153.497 E-.09555
G1 X183.615 Y153.354 E-.09588
G1 X183.866 Y153.247 E-.1037
G1 X184.113 Y153.197 E-.09571
G1 X184.233 Y153.19 E-.04589
G1 X184.256 Y153.192 E-.00852
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X176.649 Y153.816 Z3.2 F60000
G1 X164.482 Y154.815 Z3.2
G1 Z2.8
G1 E.8 F1800
G1 F9136
M204 S5000
G1 X164.469 Y154.773 E.00134
G3 X165.613 Y153.197 I1.28 J-.273 E.06745
G1 X165.733 Y153.19 E.00371
G3 X164.551 Y155.027 I.016 J1.309 E.1734
G1 X164.501 Y154.872 E.00502
; COOLING_NODE: 0
; WIPE_START
G1 F9547.055
M204 S8000
G1 X164.469 Y154.773 E-.03943
G1 X164.447 Y154.637 E-.0521
G1 X164.445 Y154.386 E-.09544
G1 X164.49 Y154.14 E-.09517
G1 X164.583 Y153.904 E-.09615
G1 X164.731 Y153.677 E-.10329
G1 X164.907 Y153.497 E-.09555
G1 X165.115 Y153.354 E-.09588
G1 X165.326 Y153.264 E-.08699
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X163.748 Y160.732 Z3.2 F60000
G1 X162.31 Y167.54 Z3.2
G1 Z2.8
G1 E.8 F1800
G1 F2007
M204 S5000
G1 X162.31 Y151.06 E.50639
G1 X187.69 Y151.06 E.77986
G1 X187.69 Y167.54 E.50639
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X162.37 Y167.54 E.77801
; WIPE_START
M73 P77 R2
G1 F9547.055
M204 S8000
G1 X162.363 Y165.54 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X169.983 Y165.977 Z3.2 F60000
G1 X187.483 Y166.981 Z3.2
G1 Z2.8
G1 E.8 F1800
; FEATURE: Top surface
G1 F9547.055
M204 S2000
G1 X187.131 Y167.333 E.01527
G1 X186.998 Y167.466
G1 X186.464 Y167.466
G1 X186.598 Y167.333
G1 X187.483 Y166.448 E.03844
G1 X187.616 Y166.314
G1 X187.616 Y165.781
G1 X187.483 Y165.915
G1 X186.065 Y167.333 E.06162
G1 X185.931 Y167.466
G1 X185.398 Y167.466
G1 X185.531 Y167.333
G1 X187.483 Y165.381 E.08479
G1 X187.616 Y165.248
G1 X187.616 Y164.715
G1 X187.483 Y164.848
G1 X184.998 Y167.333 E.10796
G1 X184.865 Y167.466
G1 X184.331 Y167.466
G1 X184.465 Y167.333
G1 X187.483 Y164.315 E.13113
G1 X187.616 Y164.181
G1 X187.616 Y163.648
G1 X187.483 Y163.782
G1 X183.932 Y167.333 E.15431
G1 X183.798 Y167.466
G1 X183.265 Y167.466
G1 X183.398 Y167.333
G1 X187.483 Y163.248 E.17748
G1 X187.616 Y163.115
G1 X187.616 Y162.582
G1 X187.483 Y162.715
G1 X182.865 Y167.333 E.20065
G1 X182.732 Y167.466
G1 X182.198 Y167.466
G1 X182.332 Y167.333
G1 X187.483 Y162.182 E.22382
G1 X187.616 Y162.048
G1 X187.616 Y161.515
G1 X187.483 Y161.649
G1 X181.799 Y167.333 E.247
G1 X181.665 Y167.466
G1 X181.132 Y167.466
G1 X181.265 Y167.333
G1 X187.483 Y161.115 E.27017
G1 X187.616 Y160.982
G1 X187.616 Y160.448
G1 X187.483 Y160.582
G1 X180.732 Y167.333 E.29334
G1 X180.598 Y167.466
G1 X180.065 Y167.466
G1 X180.199 Y167.333
G1 X187.483 Y160.049 E.31651
G1 X187.616 Y159.915
G1 X187.616 Y159.382
G1 X187.483 Y159.516
G1 X179.666 Y167.333 E.33969
G1 X179.532 Y167.466
G1 X178.999 Y167.466
G1 X179.132 Y167.333
G1 X187.483 Y158.982 E.36286
G1 X187.616 Y158.849
G1 X187.616 Y158.315
G1 X187.483 Y158.449
G1 X178.599 Y167.333 E.38603
G1 X178.465 Y167.466
G1 X177.932 Y167.466
G1 X178.066 Y167.333
G1 X187.483 Y157.916 E.4092
G1 X187.616 Y157.782
G1 X187.616 Y157.249
G1 X187.483 Y157.383
G1 X177.533 Y167.333 E.43238
G1 X177.399 Y167.466
G1 X176.866 Y167.466
G1 X176.999 Y167.333
G1 X187.483 Y156.849 E.45555
G1 X187.616 Y156.716
G1 X187.616 Y156.182
G1 X187.483 Y156.316
G1 X176.466 Y167.333 E.47872
G1 X176.332 Y167.466
G1 X175.799 Y167.466
G1 X175.933 Y167.333
G1 X187.483 Y155.783 E.5019
G1 X187.616 Y155.649
G1 X187.616 Y155.116
G1 X187.483 Y155.25
G1 X175.4 Y167.333 E.52507
G1 X175.266 Y167.466
G1 X174.733 Y167.466
G1 X174.866 Y167.333
G1 X187.483 Y154.716 E.54824
G1 X187.616 Y154.583
G1 X187.616 Y154.049
G1 X187.483 Y154.183
G1 X174.333 Y167.333 E.57141
G1 X174.199 Y167.466
G1 X173.666 Y167.466
G1 X173.8 Y167.333
G1 X187.483 Y153.65 E.59459
; WIPE_START
M204 S8000
G1 X186.068 Y155.064 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X185.718 Y154.881 Z3.2 F60000
G1 Z2.8
G1 E.8 F1800
G1 F9547.055
M204 S2000
G1 X187.483 Y153.117 E.07669
G1 X187.616 Y152.983
G1 X187.616 Y152.45
G1 X187.483 Y152.583
G1 X185.755 Y154.311 E.07508
G1 X185.621 Y154.445
G1 X185.507 Y154.026
G1 X185.641 Y153.892
G1 X187.483 Y152.05 E.08004
G1 X187.616 Y151.916
G1 X187.616 Y151.383
G1 X187.483 Y151.517
G1 X185.44 Y153.56 E.08877
G1 X185.306 Y153.693
G1 X185.037 Y153.429
G1 X185.171 Y153.295
G1 X187.199 Y151.267 E.08812
G1 X187.332 Y151.134
G1 X186.799 Y151.134
G1 X186.665 Y151.267
G1 X184.833 Y153.1 E.07961
G1 X184.7 Y153.233
G1 X184.275 Y153.125
G1 X184.408 Y152.991
G1 X186.132 Y151.267 E.07492
G1 X186.266 Y151.134
G1 X185.733 Y151.134
G1 X185.599 Y151.267
G1 X183.822 Y153.045 E.07722
; WIPE_START
M204 S8000
G1 X185.236 Y151.63 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X184.632 Y155.967 Z3.2 F60000
G1 Z2.8
G1 E.8 F1800
G1 F9547.055
M204 S2000
G1 X173.267 Y167.333 E.49389
G1 X173.133 Y167.466
G1 X172.6 Y167.466
G1 X172.733 Y167.333
G1 X184.062 Y156.004 E.49227
G1 X184.195 Y155.871
G1 X183.777 Y155.756
G1 X183.643 Y155.889
M73 P78 R2
G1 X172.2 Y167.333 E.49727
G1 X172.066 Y167.466
G1 X171.533 Y167.466
G1 X171.667 Y167.333
G1 X183.309 Y155.69 E.50591
G1 X183.443 Y155.557
G1 X183.179 Y155.287
G1 X183.045 Y155.421
G1 X171.133 Y167.333 E.51762
G1 X171 Y167.466
G1 X170.467 Y167.466
G1 X170.6 Y167.333
G1 X182.85 Y155.083 E.53231
G1 X182.983 Y154.949
G1 X182.874 Y154.525
G1 X182.741 Y154.659
G1 X170.067 Y167.333 E.55073
G1 X169.933 Y167.466
G1 X169.4 Y167.466
G1 X169.534 Y167.333
G1 X182.794 Y154.072 E.57623
; WIPE_START
M204 S8000
G1 X181.38 Y155.486 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X185.066 Y151.267 Z3.2 F60000
G1 Z2.8
G1 E.8 F1800
G1 F9547.055
M204 S2000
G1 X169 Y167.333 E.69811
G1 X168.867 Y167.466
G1 X168.334 Y167.466
G1 X168.467 Y167.333
G1 X184.532 Y151.267 E.69811
G1 X184.666 Y151.134
G1 X184.133 Y151.134
G1 X183.999 Y151.267
G1 X167.934 Y167.333 E.69811
G1 X167.8 Y167.466
G1 X167.267 Y167.466
G1 X167.401 Y167.333
G1 X183.466 Y151.267 E.69811
G1 X183.6 Y151.134
G1 X183.066 Y151.134
G1 X182.933 Y151.267
G1 X166.867 Y167.333 E.69811
G1 X166.734 Y167.466
G1 X166.201 Y167.466
G1 X166.334 Y167.333
G1 X182.399 Y151.267 E.69811
G1 X182.533 Y151.134
G1 X182 Y151.134
G1 X181.866 Y151.267
G1 X165.801 Y167.333 E.69811
G1 X165.667 Y167.466
G1 X165.134 Y167.466
G1 X165.268 Y167.333
G1 X181.333 Y151.267 E.69811
G1 X181.467 Y151.134
G1 X180.933 Y151.134
G1 X180.8 Y151.267
G1 X164.734 Y167.333 E.69811
G1 X164.601 Y167.466
G1 X164.067 Y167.466
G1 X164.201 Y167.333
G1 X180.266 Y151.267 E.69811
G1 X180.4 Y151.134
G1 X179.867 Y151.134
G1 X179.733 Y151.267
G1 X163.668 Y167.333 E.69811
G1 X163.534 Y167.466
G1 X163.001 Y167.466
G1 X163.135 Y167.333
G1 X179.2 Y151.267 E.69811
G1 X179.334 Y151.134
G1 X178.8 Y151.134
G1 X178.667 Y151.267
G1 X162.601 Y167.333 E.69811
G1 X162.468 Y167.466
G1 X162.384 Y167.017
G1 X162.517 Y166.883
G1 X178.133 Y151.267 E.67859
G1 X178.267 Y151.134
G1 X177.734 Y151.134
G1 X177.6 Y151.267
G1 X162.517 Y166.35 E.65542
G1 X162.384 Y166.484
G1 X162.384 Y165.95
G1 X162.517 Y165.817
G1 X177.067 Y151.267 E.63224
G1 X177.2 Y151.134
G1 X176.667 Y151.134
G1 X176.534 Y151.267
G1 X162.517 Y165.284 E.60907
G1 X162.384 Y165.417
G1 X162.384 Y164.884
G1 X162.517 Y164.75
G1 X176 Y151.267 E.5859
G1 X176.134 Y151.134
G1 X175.601 Y151.134
G1 X175.467 Y151.267
G1 X162.517 Y164.217 E.56273
G1 X162.384 Y164.351
G1 X162.384 Y163.817
G1 X162.517 Y163.684
G1 X174.934 Y151.267 E.53955
G1 X175.067 Y151.134
G1 X174.534 Y151.134
G1 X174.401 Y151.267
G1 X162.517 Y163.151 E.51638
G1 X162.384 Y163.284
G1 X162.384 Y162.751
G1 X162.517 Y162.617
G1 X173.867 Y151.267 E.49321
G1 X174.001 Y151.134
G1 X173.468 Y151.134
G1 X173.334 Y151.267
G1 X162.517 Y162.084 E.47004
G1 X162.384 Y162.218
G1 X162.384 Y161.684
G1 X162.517 Y161.551
G1 X172.801 Y151.267 E.44686
G1 X172.934 Y151.134
G1 X172.401 Y151.134
G1 X172.268 Y151.267
G1 X162.517 Y161.018 E.42369
G1 X162.384 Y161.151
G1 X162.384 Y160.618
G1 X162.517 Y160.484
G1 X171.734 Y151.267 E.40052
G1 X171.868 Y151.134
G1 X171.335 Y151.134
G1 X171.201 Y151.267
G1 X162.517 Y159.951 E.37734
G1 X162.384 Y160.085
G1 X162.384 Y159.551
G1 X162.517 Y159.418
G1 X165.928 Y156.007 E.14821
G1 X166.062 Y155.873
G1 X165.555 Y155.847
G1 X165.422 Y155.98
G1 X162.517 Y158.884 E.1262
G1 X162.384 Y159.018
G1 X162.384 Y158.485
G1 X162.517 Y158.351
G1 X165.032 Y155.836 E.10929
G1 X165.166 Y155.703
G1 X164.855 Y155.481
G1 X164.721 Y155.614
G1 X162.517 Y157.818 E.09576
G1 X162.384 Y157.952
G1 X162.384 Y157.418
G1 X162.517 Y157.285
G1 X164.478 Y155.324 E.08518
G1 X164.611 Y155.191
G1 X164.439 Y154.83
G1 X164.305 Y154.964
G1 X162.517 Y156.751 E.07768
G1 X162.384 Y156.885
G1 X162.384 Y156.352
G1 X162.517 Y156.218
G1 X164.233 Y154.502 E.07456
G1 X164.367 Y154.369
G1 X164.539 Y153.663
G1 X164.406 Y153.797
G1 X162.517 Y155.685 E.08205
; WIPE_START
M204 S8000
G1 X163.932 Y154.271 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
M73 P79 R2
G1 X167.255 Y154.68 Z3.2 F60000
G1 Z2.8
G1 E.8 F1800
G1 F9547.055
M204 S2000
G1 X170.668 Y151.267 E.14829
G1 X170.801 Y151.134
G1 X170.268 Y151.134
G1 X170.134 Y151.267
G1 X167.231 Y154.171 E.12616
G1 X167.097 Y154.304
G1 X166.953 Y153.916
G1 X167.086 Y153.782
G1 X169.601 Y151.267 E.10928
G1 X169.735 Y151.134
G1 X169.202 Y151.134
G1 X169.068 Y151.267
G1 X166.864 Y153.472 E.09578
G1 X166.73 Y153.605
G1 X166.442 Y153.36
G1 X166.576 Y153.226
G1 X168.535 Y151.267 E.08513
G1 X168.668 Y151.134
G1 X168.135 Y151.134
G1 X168.001 Y151.267
G1 X166.213 Y153.055 E.0777
G1 X166.08 Y153.189
G1 X165.619 Y153.117
G1 X165.752 Y152.983
G1 X167.468 Y151.267 E.07456
G1 X167.602 Y151.134
G1 X167.069 Y151.134
G1 X166.935 Y151.267
G1 X165.045 Y153.157 E.08212
; WIPE_START
M204 S8000
G1 X166.459 Y151.743 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X166.402 Y151.267 Z3.2 F60000
G1 Z2.8
G1 E.8 F1800
G1 F9547.055
M204 S2000
G1 X162.517 Y155.152 E.16879
G1 X162.384 Y155.285
G1 X162.384 Y154.752
G1 X162.517 Y154.618
G1 X165.868 Y151.267 E.14562
G1 X166.002 Y151.134
G1 X165.469 Y151.134
G1 X165.335 Y151.267
G1 X162.517 Y154.085 E.12245
G1 X162.384 Y154.219
G1 X162.384 Y153.686
G1 X162.517 Y153.552
G1 X164.802 Y151.267 E.09927
G1 X164.936 Y151.134
G1 X164.402 Y151.134
G1 X164.269 Y151.267
G1 X162.517 Y153.019 E.0761
G1 X162.384 Y153.152
G1 X162.384 Y152.619
G1 X162.517 Y152.485
G1 X163.735 Y151.267 E.05293
G1 X163.869 Y151.134
G1 X163.336 Y151.134
G1 X163.202 Y151.267
G1 X162.517 Y151.952 E.02976
; WIPE_START
M204 S8000
G1 X163.202 Y151.267 E-.36799
G1 X163.336 Y151.134 E-.07182
G1 X163.869 Y151.134 E-.20264
G1 X163.735 Y151.267 E-.07182
G1 X163.65 Y151.353 E-.04574
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X164.983 Y153.095 Z3.2 F60000
G1 Z2.8
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.195839
G1 F15000
M204 S8000
G1 X164.741 Y153.296 E.00392
G1 X164.571 Y153.465 E.00298
; WIPE_START
G1 X164.741 Y153.296 E-.32858
G1 X164.983 Y153.095 E-.43142
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X172.615 Y153.048 Z3.2 F60000
G1 X183.756 Y152.978 Z3.2
G1 Z2.8
G1 E.8 F1800
; LINE_WIDTH: 0.17843
G1 F15000
M204 S8000
G1 X183.635 Y153.06 E.00161
; LINE_WIDTH: 0.163932
G1 X183.57 Y153.106 E.00078
; LINE_WIDTH: 0.136984
G1 X183.502 Y153.155 E.00064
; LINE_WIDTH: 0.105767
G1 X183.363 Y153.266 E.00091
M204 S10000
G1 X183.023 Y153.606 F60000
; LINE_WIDTH: 0.0929185
G1 F15000
M204 S8000
G1 X182.969 Y153.67 E.00034
; LINE_WIDTH: 0.119106
G1 X182.87 Y153.799 E.00101
; LINE_WIDTH: 0.154391
G1 X182.827 Y153.862 E.0007
; LINE_WIDTH: 0.192748
G1 X182.731 Y154.009 E.00215
; WIPE_START
G1 X182.827 Y153.862 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X185.045 Y155.792 Z3.2 F60000
G1 Z2.8
G1 E.8 F1800
; LINE_WIDTH: 0.0936415
G1 F15000
M204 S8000
G1 X184.989 Y155.837 E.0003
; LINE_WIDTH: 0.112439
G1 X184.925 Y155.882 E.00045
; LINE_WIDTH: 0.148341
G3 X184.701 Y156.036 I-3.344 J-4.62 E.00233
; WIPE_START
G1 X184.925 Y155.882 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X185.785 Y154.948 Z3.2 F60000
G1 Z2.8
G1 E.8 F1800
; LINE_WIDTH: 0.17427
G1 F15000
M204 S8000
G1 X185.708 Y155.066 E.0015
; LINE_WIDTH: 0.158567
G1 X185.663 Y155.131 E.00074
; LINE_WIDTH: 0.129127
G1 X185.616 Y155.199 E.00058
; LINE_WIDTH: 0.101212
G1 X185.542 Y155.296 E.00058
; CHANGE_LAYER
; Z_HEIGHT: 3
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F15000
G1 X185.616 Y155.199 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 15/47
; update layer progress
M73 L15
M991 S0 P14 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 3
M204 S10000
G17
G3 Z3.2 I.089 J-1.214 P1  F60000
G1 X171.298 Y154.148 Z3.2
G1 Z3
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X171.298 Y156.148 E.06634
G1 X170.502 Y156.148 E.0264
G1 X170.502 Y153.352 E.09274
G1 X179.498 Y153.352 E.29841
G1 X179.498 Y156.148 E.09274
G1 X178.702 Y156.148 E.0264
G1 X178.702 Y154.148 E.06634
G1 X171.358 Y154.148 E.24362
; COOLING_NODE: 3
M204 S250
G1 X171.69 Y154.54 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X171.69 Y156.54 E.06145
G1 X170.11 Y156.54 E.04855
G1 X170.11 Y152.96 E.11
G1 X179.89 Y152.96 E.30051
G1 X179.89 Y156.54 E.11
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X178.31 Y156.54 E.04855
G1 X178.31 Y154.54 E.06145
G1 X171.75 Y154.54 E.20157
; WIPE_START
G1 F9547.055
M204 S8000
G1 X171.69 Y156.539 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.094 Y153.75 Z3.4 F60000
G1 Z3
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1200
M204 S8000
G1 X178.906 Y153.75 E.24748
; LINE_WIDTH: 0.470635
G1 X179.067 Y153.783 E.00573
G1 X179.083 Y153.864 E.00287
; LINE_WIDTH: 0.448395
G1 X179.1 Y153.944 E.00272
; LINE_WIDTH: 0.43172
G1 X179.1 Y155.944 E.06336
; WIPE_START
G1 F9259.259
G1 X179.1 Y153.944 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z3.4 I-.288 J-1.182 P1  F60000
G1 X170.9 Y155.944 Z3.4
G1 Z3
G1 E.8 F1800
G1 F1200
M204 S8000
G1 X170.9 Y153.944 E.06336
; LINE_WIDTH: 0.470635
G1 X170.933 Y153.783 E.00573
G1 X171.014 Y153.767 E.00287
; LINE_WIDTH: 0.448395
G1 X171.094 Y153.75 E.00272
; CHANGE_LAYER
; Z_HEIGHT: 3.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F8878.476
G1 X171.014 Y153.767 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 16/47
; update layer progress
M73 L16
M991 S0 P15 ;notify layer change

; OBJECT_ID: 15
M204 S10000
G17
G3 Z3.4 I-.551 J1.085 P1  F60000
G1 X173.679 Y155.119 Z3.4
G1 Z3.2
G1 E.8 F1800
; FEATURE: Support interface
; LINE_WIDTH: 0.42
G1 F1200
M204 S8000
G1 X172.438 Y156.36 E.05393
G1 X172.43 Y156.982 E.01911
G1 X173.057 Y156.982 E.01927
G1 X174.75 Y155.288 E.07358
G1 X175.99 Y155.288 E.03811
G1 X174.297 Y156.982 E.07358
G1 X175.538 Y156.982 E.03811
G1 X177.231 Y155.288 E.07358
G1 X177.562 Y155.288 E.01016
M73 P80 R2
G1 X177.562 Y156.198 E.02795
G1 X176.608 Y157.151 E.04142
; COOLING_NODE: 3
; WIPE_START
G1 F4800
G1 X177.562 Y156.198 E-.5123
G1 X177.562 Y155.546 E-.2477
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.298 Y154.148 Z3.6 F60000
G1 Z3.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X171.298 Y156.148 E.06634
G1 X170.502 Y156.148 E.0264
G1 X170.502 Y153.352 E.09274
G1 X179.498 Y153.352 E.29841
G1 X179.498 Y156.148 E.09274
G1 X178.702 Y156.148 E.0264
G1 X178.702 Y154.148 E.06634
G1 X171.358 Y154.148 E.24362
; COOLING_NODE: 3
M204 S250
G1 X171.69 Y154.54 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X171.69 Y156.54 E.06145
G1 X170.11 Y156.54 E.04855
G1 X170.11 Y152.96 E.11
G1 X179.89 Y152.96 E.30051
G1 X179.89 Y156.54 E.11
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X178.31 Y156.54 E.04855
G1 X178.31 Y154.54 E.06145
G1 X171.75 Y154.54 E.20157
; WIPE_START
G1 F9547.055
M204 S8000
G1 X171.69 Y156.539 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.094 Y153.75 Z3.6 F60000
G1 Z3.2
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1200
M204 S8000
G1 X178.906 Y153.75 E.24748
; LINE_WIDTH: 0.470635
G1 X179.067 Y153.783 E.00573
G1 X179.083 Y153.864 E.00287
; LINE_WIDTH: 0.448395
G1 X179.1 Y153.944 E.00272
; LINE_WIDTH: 0.43172
G1 X179.1 Y155.944 E.06336
; WIPE_START
G1 F9259.259
G1 X179.1 Y153.944 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.685 Y155.753 Z3.6 F60000
G1 X170.9 Y155.944 Z3.6
G1 Z3.2
G1 E.8 F1800
G1 F1200
M204 S8000
G1 X170.9 Y153.944 E.06336
; LINE_WIDTH: 0.470635
G1 X170.933 Y153.783 E.00573
G1 X171.014 Y153.767 E.00287
; LINE_WIDTH: 0.448395
G1 X171.094 Y153.75 E.00272
; CHANGE_LAYER
; Z_HEIGHT: 3.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F8878.476
G1 X171.014 Y153.767 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 17/47
; update layer progress
M73 L17
M991 S0 P16 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 3
M204 S10000
G17
G3 Z3.6 I-.976 J.727 P1  F60000
G1 X171.298 Y154.148 Z3.6
G1 Z3.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X171.298 Y156.148 E.06634
G1 X170.502 Y156.148 E.0264
G1 X170.502 Y153.352 E.09274
G1 X179.498 Y153.352 E.29841
G1 X179.498 Y156.148 E.09274
G1 X178.702 Y156.148 E.0264
G1 X178.702 Y154.148 E.06634
G1 X171.358 Y154.148 E.24362
; COOLING_NODE: 3
M204 S250
G1 X171.69 Y154.54 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X171.69 Y156.54 E.06145
G1 X170.11 Y156.54 E.04855
G1 X170.11 Y152.96 E.11
G1 X179.89 Y152.96 E.30051
G1 X179.89 Y156.54 E.11
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X178.31 Y156.54 E.04855
G1 X178.31 Y154.54 E.06145
G1 X171.75 Y154.54 E.20157
; WIPE_START
G1 F9547.055
M204 S8000
M73 P81 R2
G1 X171.69 Y156.539 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.094 Y153.75 Z3.8 F60000
G1 Z3.4
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1200
M204 S8000
G1 X178.906 Y153.75 E.24748
; LINE_WIDTH: 0.470635
G1 X179.067 Y153.783 E.00573
G1 X179.083 Y153.864 E.00287
; LINE_WIDTH: 0.448395
G1 X179.1 Y153.944 E.00272
; LINE_WIDTH: 0.43172
G1 X179.1 Y155.944 E.06336
; WIPE_START
G1 F9259.259
G1 X179.1 Y153.944 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.685 Y155.753 Z3.8 F60000
G1 X170.9 Y155.944 Z3.8
G1 Z3.4
G1 E.8 F1800
G1 F1200
M204 S8000
G1 X170.9 Y153.944 E.06336
; LINE_WIDTH: 0.470635
G1 X170.933 Y153.783 E.00573
G1 X171.014 Y153.767 E.00287
; LINE_WIDTH: 0.448395
G1 X171.094 Y153.75 E.00272
; CHANGE_LAYER
; Z_HEIGHT: 3.46667
; LAYER_HEIGHT: 0.0666666
; WIPE_START
G1 F8878.476
G1 X171.014 Y153.767 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 18/47
; update layer progress
M73 L18
M991 S0 P17 ;notify layer change

; OBJECT_ID: 15
M204 S10000
G17
G3 Z3.8 I-1.064 J.59 P1  F60000
G1 X172.269 Y156.028 Z3.8
G1 Z3.467
G1 E.8 F1800
; FEATURE: Support interface
; LINE_WIDTH: 0.42
; LAYER_HEIGHT: 0.266667
G1 F1200
M204 S8000
G1 X172.802 Y156.562 E.02973
G1 X174.042 Y156.562 E.04889
G1 X172.769 Y155.288 E.07097
G1 X174.01 Y155.288 E.04889
G1 X175.283 Y156.562 E.07097
G1 X176.523 Y156.562 E.04889
G1 X175.25 Y155.288 E.07097
G1 X176.49 Y155.288 E.04889
G1 X177.731 Y156.529 E.06917
;======== H2D 20260731========
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
; Z_HEIGHT: 3.6
; LAYER_HEIGHT: 0.133333
; WIPE_START
G1 F4800
G1 X176.49 Y155.288 E-.66691
G1 X176.245 Y155.288 E-.09309
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 19/47
; update layer progress
M73 L19
M991 S0 P18 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 3
M204 S10000
G17
G3 Z3.867 I.273 J-1.186 P1  F60000
G1 X171.298 Y154.148 Z3.867
G1 Z3.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
; LAYER_HEIGHT: 0.2
G1 F1200
M204 S8000
G1 X171.298 Y156.148 E.06634
G1 X170.502 Y156.148 E.0264
G1 X170.502 Y153.352 E.09274
G1 X179.498 Y153.352 E.29841
G1 X179.498 Y156.148 E.09274
G1 X178.702 Y156.148 E.0264
G1 X178.702 Y154.148 E.06634
G1 X171.358 Y154.148 E.24362
; COOLING_NODE: 3
M204 S250
G1 X171.69 Y154.54 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X171.69 Y156.54 E.06145
G1 X170.11 Y156.54 E.04855
G1 X170.11 Y152.96 E.11
G1 X179.89 Y152.96 E.30051
G1 X179.89 Y156.54 E.11
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X178.31 Y156.54 E.04855
G1 X178.31 Y154.54 E.06145
G1 X171.75 Y154.54 E.20157
; WIPE_START
G1 F9547.055
M204 S8000
G1 X171.69 Y156.539 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.094 Y153.75 Z4 F60000
G1 Z3.6
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1200
M204 S8000
G1 X178.906 Y153.75 E.24748
; LINE_WIDTH: 0.470635
G1 X179.067 Y153.783 E.00573
G1 X179.083 Y153.864 E.00287
; LINE_WIDTH: 0.448395
G1 X179.1 Y153.944 E.00272
; LINE_WIDTH: 0.43172
G1 X179.1 Y155.944 E.06336
; WIPE_START
G1 F9259.259
G1 X179.1 Y153.944 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.685 Y155.753 Z4 F60000
G1 X170.9 Y155.944 Z4
G1 Z3.6
G1 E.8 F1800
G1 F1200
M204 S8000
G1 X170.9 Y153.944 E.06336
; LINE_WIDTH: 0.470635
G1 X170.933 Y153.783 E.00573
G1 X171.014 Y153.767 E.00287
; LINE_WIDTH: 0.448395
G1 X171.094 Y153.75 E.00272
; CHANGE_LAYER
; Z_HEIGHT: 3.73333
; LAYER_HEIGHT: 0.133333
; WIPE_START
G1 F8878.476
G1 X171.014 Y153.767 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 20/47
; update layer progress
M73 L20
M991 S0 P19 ;notify layer change

; OBJECT_ID: 15
M204 S10000
G17
G3 Z4 I-.551 J1.085 P1  F60000
G1 X173.679 Y155.119 Z4
G1 Z3.733
G1 E.8 F1800
; FEATURE: Support interface
; LINE_WIDTH: 0.42
; LAYER_HEIGHT: 0.266667
G1 F1200
M204 S8000
G1 X172.438 Y156.36 E.06917
G1 X172.438 Y156.562 E.00796
G1 X173.477 Y156.562 E.04093
G1 X174.75 Y155.288 E.07097
G1 X175.99 Y155.288 E.04889
G1 X174.717 Y156.562 E.07097
G1 X175.958 Y156.562 E.04889
G1 X177.231 Y155.288 E.07097
G1 X177.562 Y155.288 E.01304
G1 X177.562 Y156.198 E.03585
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X177.028 Y156.731 E.02973
; CHANGE_LAYER
; Z_HEIGHT: 3.8
; LAYER_HEIGHT: 0.0666666
; WIPE_START
M73 P82 R2
G1 F4800
G1 X177.562 Y156.198 E-.2866
G1 X177.562 Y155.288 E-.34566
G1 X177.231 Y155.288 E-.12568
G1 X177.227 Y155.292 E-.00207
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 21/47
; update layer progress
M73 L21
M991 S0 P20 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 3
M204 S10000
G17
G3 Z4.133 I.231 J-1.195 P1  F60000
G1 X171.298 Y154.148 Z4.133
G1 Z3.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
; LAYER_HEIGHT: 0.2
G1 F1200
M204 S8000
G1 X171.298 Y156.148 E.06634
G1 X170.502 Y156.148 E.0264
G1 X170.502 Y153.352 E.09274
G1 X179.498 Y153.352 E.29841
G1 X179.498 Y156.148 E.09274
G1 X178.702 Y156.148 E.0264
G1 X178.702 Y154.148 E.06634
G1 X171.358 Y154.148 E.24362
; COOLING_NODE: 3
M204 S250
G1 X171.69 Y154.54 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X171.69 Y156.54 E.06145
G1 X170.11 Y156.54 E.04855
G1 X170.11 Y152.96 E.11
G1 X179.89 Y152.96 E.30051
G1 X179.89 Y156.54 E.11
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X178.31 Y156.54 E.04855
G1 X178.31 Y154.54 E.06145
G1 X171.75 Y154.54 E.20157
; WIPE_START
G1 F9547.055
M204 S8000
G1 X171.69 Y156.539 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.094 Y153.75 Z4.2 F60000
G1 Z3.8
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1200
M204 S8000
G1 X178.906 Y153.75 E.24748
; LINE_WIDTH: 0.470635
G1 X179.067 Y153.783 E.00573
G1 X179.083 Y153.864 E.00287
; LINE_WIDTH: 0.448395
G1 X179.1 Y153.944 E.00272
; LINE_WIDTH: 0.43172
G1 X179.1 Y155.944 E.06336
; WIPE_START
G1 F9259.259
G1 X179.1 Y153.944 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.685 Y155.753 Z4.2 F60000
G1 X170.9 Y155.944 Z4.2
G1 Z3.8
G1 E.8 F1800
G1 F1200
M204 S8000
G1 X170.9 Y153.944 E.06336
; LINE_WIDTH: 0.470635
G1 X170.933 Y153.783 E.00573
G1 X171.014 Y153.767 E.00287
; LINE_WIDTH: 0.448395
G1 X171.094 Y153.75 E.00272
; CHANGE_LAYER
; Z_HEIGHT: 4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F8878.476
G1 X171.014 Y153.767 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 22/47
; update layer progress
M73 L22
M991 S0 P21 ;notify layer change

; OBJECT_ID: 15
M204 S10000
G17
G3 Z4.2 I-1.084 J.553 P1  F60000
G1 X172.439 Y156.562 Z4.2
G1 Z4
G1 E.8 F1800
; FEATURE: Support
; LINE_WIDTH: 0.42
; LAYER_HEIGHT: 0.266667
G1 F1200
M204 S8000
G1 X172.439 Y155.289 E.05018
G1 X177.561 Y155.289 E.20192
G1 X177.561 Y156.562 E.05018
G1 X172.495 Y156.562 E.19969
; COOLING_NODE: 3
; WIPE_START
G1 F7442.674
G1 X174.495 Y156.562 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.298 Y154.148 Z4.4 F60000
G1 Z4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
; LAYER_HEIGHT: 0.2
G1 F1200
M204 S8000
G1 X171.298 Y156.148 E.06634
G1 X170.502 Y156.148 E.0264
G1 X170.502 Y153.352 E.09274
G1 X179.498 Y153.352 E.29841
G1 X179.498 Y156.148 E.09274
G1 X178.702 Y156.148 E.0264
G1 X178.702 Y154.148 E.06634
G1 X171.358 Y154.148 E.24362
; COOLING_NODE: 3
M204 S250
G1 X171.69 Y154.54 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X171.69 Y156.54 E.06145
G1 X170.11 Y156.54 E.04855
G1 X170.11 Y152.96 E.11
G1 X179.89 Y152.96 E.30051
G1 X179.89 Y156.54 E.11
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X178.31 Y156.54 E.04855
G1 X178.31 Y154.54 E.06145
M73 P83 R2
G1 X171.75 Y154.54 E.20157
; WIPE_START
G1 F9547.055
M204 S8000
G1 X171.69 Y156.539 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.094 Y153.75 Z4.4 F60000
G1 Z4
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1200
M204 S8000
G1 X178.906 Y153.75 E.24748
; LINE_WIDTH: 0.470635
G1 X179.067 Y153.783 E.00573
G1 X179.083 Y153.864 E.00287
; LINE_WIDTH: 0.448395
G1 X179.1 Y153.944 E.00272
; LINE_WIDTH: 0.43172
M73 P83 R1
G1 X179.1 Y155.944 E.06336
; WIPE_START
G1 F9259.259
G1 X179.1 Y153.944 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.685 Y155.753 Z4.4 F60000
G1 X170.9 Y155.944 Z4.4
G1 Z4
G1 E.8 F1800
G1 F1200
M204 S8000
G1 X170.9 Y153.944 E.06336
; LINE_WIDTH: 0.470635
G1 X170.933 Y153.783 E.00573
G1 X171.014 Y153.767 E.00287
; LINE_WIDTH: 0.448395
G1 X171.094 Y153.75 E.00272
; CHANGE_LAYER
; Z_HEIGHT: 4.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F8878.476
G1 X171.014 Y153.767 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 23/47
; update layer progress
M73 L23
M991 S0 P22 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 3
M204 S10000
G17
G3 Z4.4 I-.976 J.727 P1  F60000
G1 X171.298 Y154.148 Z4.4
G1 Z4.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X171.298 Y156.148 E.06634
G1 X170.502 Y156.148 E.0264
G1 X170.502 Y153.352 E.09274
G1 X179.498 Y153.352 E.29841
G1 X179.498 Y156.148 E.09274
G1 X178.702 Y156.148 E.0264
G1 X178.702 Y154.148 E.06634
G1 X171.358 Y154.148 E.24362
; COOLING_NODE: 3
M204 S250
G1 X171.69 Y154.54 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X171.69 Y156.54 E.06145
G1 X170.11 Y156.54 E.04855
G1 X170.11 Y152.96 E.11
G1 X179.89 Y152.96 E.30051
G1 X179.89 Y156.54 E.11
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X178.31 Y156.54 E.04855
G1 X178.31 Y154.54 E.06145
G1 X171.75 Y154.54 E.20157
; WIPE_START
G1 F9547.055
M204 S8000
G1 X171.69 Y156.539 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.094 Y153.75 Z4.6 F60000
G1 Z4.2
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1200
M204 S8000
G1 X178.906 Y153.75 E.24748
; LINE_WIDTH: 0.470635
G1 X179.067 Y153.783 E.00573
G1 X179.083 Y153.864 E.00287
; LINE_WIDTH: 0.448395
G1 X179.1 Y153.944 E.00272
; LINE_WIDTH: 0.43172
G1 X179.1 Y155.944 E.06336
; WIPE_START
G1 F9259.259
G1 X179.1 Y153.944 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.685 Y155.753 Z4.6 F60000
G1 X170.9 Y155.944 Z4.6
G1 Z4.2
G1 E.8 F1800
G1 F1200
M204 S8000
G1 X170.9 Y153.944 E.06336
; LINE_WIDTH: 0.470635
G1 X170.933 Y153.783 E.00573
G1 X171.014 Y153.767 E.00287
; LINE_WIDTH: 0.448395
G1 X171.094 Y153.75 E.00272
; CHANGE_LAYER
; Z_HEIGHT: 4.26667
; LAYER_HEIGHT: 0.0666671
; WIPE_START
G1 F8878.476
G1 X171.014 Y153.767 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 24/47
; update layer progress
M73 L24
M991 S0 P23 ;notify layer change

; OBJECT_ID: 15
M204 S10000
G17
G3 Z4.6 I-1.084 J.553 P1  F60000
G1 X172.439 Y156.562 Z4.6
G1 Z4.267
G1 E.8 F1800
; FEATURE: Support
; LINE_WIDTH: 0.42
; LAYER_HEIGHT: 0.266667
G1 F1200
M204 S8000
G1 X172.439 Y155.289 E.05018
G1 X177.561 Y155.289 E.20192
G1 X177.561 Y156.562 E.05018
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X172.495 Y156.562 E.19969
; CHANGE_LAYER
; Z_HEIGHT: 4.4
; LAYER_HEIGHT: 0.133333
; WIPE_START
G1 F7442.674
G1 X174.495 Y156.562 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 25/47
; update layer progress
M73 L25
M991 S0 P24 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 3
M204 S10000
G17
G3 Z4.667 I.733 J-.971 P1  F60000
G1 X171.298 Y154.148 Z4.667
G1 Z4.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
; LAYER_HEIGHT: 0.2
M73 P84 R1
G1 F1200
M204 S8000
G1 X171.298 Y156.148 E.06634
G1 X170.502 Y156.148 E.0264
G1 X170.502 Y153.352 E.09274
G1 X179.498 Y153.352 E.29841
G1 X179.498 Y156.148 E.09274
G1 X178.702 Y156.148 E.0264
G1 X178.702 Y154.148 E.06634
G1 X171.358 Y154.148 E.24362
; COOLING_NODE: 3
M204 S250
G1 X171.69 Y154.54 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X171.69 Y156.54 E.06145
G1 X170.11 Y156.54 E.04855
G1 X170.11 Y152.96 E.11
G1 X179.89 Y152.96 E.30051
G1 X179.89 Y156.54 E.11
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X178.31 Y156.54 E.04855
G1 X178.31 Y154.54 E.06145
G1 X171.75 Y154.54 E.20157
; WIPE_START
G1 F9547.055
M204 S8000
G1 X171.69 Y156.539 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.094 Y153.75 Z4.8 F60000
G1 Z4.4
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1200
M204 S8000
G1 X178.906 Y153.75 E.24748
; LINE_WIDTH: 0.470635
G1 X179.067 Y153.783 E.00573
G1 X179.083 Y153.864 E.00287
; LINE_WIDTH: 0.448395
G1 X179.1 Y153.944 E.00272
; LINE_WIDTH: 0.43172
G1 X179.1 Y155.944 E.06336
; WIPE_START
G1 F9259.259
G1 X179.1 Y153.944 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.685 Y155.753 Z4.8 F60000
G1 X170.9 Y155.944 Z4.8
G1 Z4.4
G1 E.8 F1800
G1 F1200
M204 S8000
G1 X170.9 Y153.944 E.06336
; LINE_WIDTH: 0.470635
G1 X170.933 Y153.783 E.00573
G1 X171.014 Y153.767 E.00287
; LINE_WIDTH: 0.448395
G1 X171.094 Y153.75 E.00272
; CHANGE_LAYER
; Z_HEIGHT: 4.53333
; LAYER_HEIGHT: 0.133333
; WIPE_START
G1 F8878.476
G1 X171.014 Y153.767 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 26/47
; update layer progress
M73 L26
M991 S0 P25 ;notify layer change

; OBJECT_ID: 15
M204 S10000
G17
G3 Z4.8 I-1.084 J.553 P1  F60000
G1 X172.439 Y156.562 Z4.8
G1 Z4.533
G1 E.8 F1800
; FEATURE: Support
; LINE_WIDTH: 0.42
; LAYER_HEIGHT: 0.266667
G1 F1200
M204 S8000
G1 X172.439 Y155.289 E.05018
G1 X177.561 Y155.289 E.20192
G1 X177.561 Y156.562 E.05018
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X172.495 Y156.562 E.19969
; CHANGE_LAYER
; Z_HEIGHT: 4.6
; LAYER_HEIGHT: 0.0666666
; WIPE_START
G1 F7442.674
G1 X174.495 Y156.562 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 27/47
; update layer progress
M73 L27
M991 S0 P26 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 3
M204 S10000
G17
G3 Z4.933 I.733 J-.971 P1  F60000
G1 X171.298 Y154.148 Z4.933
G1 Z4.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
; LAYER_HEIGHT: 0.2
G1 F1200
M204 S8000
G1 X171.298 Y156.148 E.06634
G1 X170.502 Y156.148 E.0264
G1 X170.502 Y153.352 E.09274
G1 X179.498 Y153.352 E.29841
G1 X179.498 Y156.148 E.09274
G1 X178.702 Y156.148 E.0264
G1 X178.702 Y154.148 E.06634
G1 X171.358 Y154.148 E.24362
; COOLING_NODE: 3
M204 S250
G1 X171.69 Y154.54 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X171.69 Y156.54 E.06145
G1 X170.11 Y156.54 E.04855
G1 X170.11 Y152.96 E.11
G1 X179.89 Y152.96 E.30051
G1 X179.89 Y156.54 E.11
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X178.31 Y156.54 E.04855
G1 X178.31 Y154.54 E.06145
M73 P85 R1
G1 X171.75 Y154.54 E.20157
; WIPE_START
G1 F9547.055
M204 S8000
G1 X171.69 Y156.539 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.094 Y153.75 Z5 F60000
G1 Z4.6
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1200
M204 S8000
G1 X178.906 Y153.75 E.24748
; LINE_WIDTH: 0.470635
G1 X179.067 Y153.783 E.00573
G1 X179.083 Y153.864 E.00287
; LINE_WIDTH: 0.448395
G1 X179.1 Y153.944 E.00272
; LINE_WIDTH: 0.43172
G1 X179.1 Y155.944 E.06336
; WIPE_START
G1 F9259.259
G1 X179.1 Y153.944 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.685 Y155.753 Z5 F60000
G1 X170.9 Y155.944 Z5
G1 Z4.6
G1 E.8 F1800
G1 F1200
M204 S8000
G1 X170.9 Y153.944 E.06336
; LINE_WIDTH: 0.470635
G1 X170.933 Y153.783 E.00573
G1 X171.014 Y153.767 E.00287
; LINE_WIDTH: 0.448395
G1 X171.094 Y153.75 E.00272
; CHANGE_LAYER
; Z_HEIGHT: 4.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F8878.476
G1 X171.014 Y153.767 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 28/47
; update layer progress
M73 L28
M991 S0 P27 ;notify layer change

; OBJECT_ID: 15
M204 S10000
G17
G3 Z5 I-1.069 J.581 P1  F60000
G1 X172.438 Y156.387 Z5
G1 Z4.8
G1 E.8 F1800
; FEATURE: Support transition
; LINE_WIDTH: 0.42
; LAYER_HEIGHT: 0.266667
G1 F1200
M204 S8000
G1 X172.438 Y156.562 E.0069
G1 X172.802 Y156.562 E.01433
G1 X172.438 Y156.198 E.02027
G1 X172.438 Y155.288 E.03585
G1 X172.769 Y155.288 E.01304
G1 X174.042 Y156.562 E.07097
G1 X175.283 Y156.562 E.04889
G1 X174.01 Y155.288 E.07097
G1 X175.25 Y155.288 E.04889
G1 X176.523 Y156.562 E.07097
G1 X177.562 Y156.562 E.04093
G1 X177.562 Y156.36 E.00796
G1 X176.49 Y155.288 E.05972
G1 X177.562 Y155.288 E.04223
G1 X177.562 Y156.171 E.03479
; COOLING_NODE: 3
; WIPE_START
G1 F3000
G1 X177.562 Y155.288 E-.33546
G1 X176.49 Y155.288 E-.4071
G1 X176.523 Y155.321 E-.01745
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.298 Y154.148 Z5.2 F60000
G1 Z4.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
; LAYER_HEIGHT: 0.2
G1 F1200
M204 S8000
G1 X171.298 Y156.148 E.06634
G1 X170.502 Y156.148 E.0264
G1 X170.502 Y153.352 E.09274
G1 X179.498 Y153.352 E.29841
G1 X179.498 Y156.148 E.09274
G1 X178.702 Y156.148 E.0264
G1 X178.702 Y154.148 E.06634
G1 X171.358 Y154.148 E.24362
; COOLING_NODE: 3
M204 S250
G1 X171.69 Y154.54 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X171.69 Y156.54 E.06145
G1 X170.11 Y156.54 E.04855
G1 X170.11 Y152.96 E.11
G1 X179.89 Y152.96 E.30051
G1 X179.89 Y156.54 E.11
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X178.31 Y156.54 E.04855
G1 X178.31 Y154.54 E.06145
G1 X171.75 Y154.54 E.20157
; WIPE_START
G1 F9547.055
M204 S8000
G1 X171.69 Y156.539 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.094 Y153.75 Z5.2 F60000
G1 Z4.8
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1200
M204 S8000
G1 X178.906 Y153.75 E.24748
; LINE_WIDTH: 0.470635
G1 X179.067 Y153.783 E.00573
G1 X179.083 Y153.864 E.00287
; LINE_WIDTH: 0.448395
G1 X179.1 Y153.944 E.00272
; LINE_WIDTH: 0.43172
G1 X179.1 Y155.944 E.06336
; WIPE_START
G1 F9259.259
G1 X179.1 Y153.944 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.685 Y155.753 Z5.2 F60000
G1 X170.9 Y155.944 Z5.2
G1 Z4.8
G1 E.8 F1800
G1 F1200
M204 S8000
G1 X170.9 Y153.944 E.06336
; LINE_WIDTH: 0.470635
G1 X170.933 Y153.783 E.00573
G1 X171.014 Y153.767 E.00287
; LINE_WIDTH: 0.448395
G1 X171.094 Y153.75 E.00272
; CHANGE_LAYER
; Z_HEIGHT: 5
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F8878.476
G1 X171.014 Y153.767 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 29/47
; update layer progress
M73 L29
M991 S0 P28 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 3
M204 S10000
G17
G3 Z5.2 I-.976 J.727 P1  F60000
G1 X171.298 Y154.148 Z5.2
G1 Z5
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X171.298 Y156.148 E.06634
G1 X170.502 Y156.148 E.0264
G1 X170.502 Y153.352 E.09274
G1 X179.498 Y153.352 E.29841
M73 P86 R1
G1 X179.498 Y156.148 E.09274
G1 X178.702 Y156.148 E.0264
G1 X178.702 Y154.148 E.06634
G1 X171.358 Y154.148 E.24362
; COOLING_NODE: 3
M204 S250
G1 X171.69 Y154.54 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X171.69 Y156.54 E.06145
G1 X170.11 Y156.54 E.04855
G1 X170.11 Y152.96 E.11
G1 X179.89 Y152.96 E.30051
G1 X179.89 Y156.54 E.11
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X178.31 Y156.54 E.04855
G1 X178.31 Y154.54 E.06145
G1 X171.75 Y154.54 E.20157
; WIPE_START
G1 F9547.055
M204 S8000
G1 X171.69 Y156.539 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.094 Y153.75 Z5.4 F60000
G1 Z5
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1200
M204 S8000
G1 X178.906 Y153.75 E.24748
; LINE_WIDTH: 0.470635
G1 X179.067 Y153.783 E.00573
G1 X179.083 Y153.864 E.00287
; LINE_WIDTH: 0.448395
G1 X179.1 Y153.944 E.00272
; LINE_WIDTH: 0.43172
G1 X179.1 Y155.944 E.06336
; WIPE_START
G1 F9259.259
G1 X179.1 Y153.944 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.685 Y155.753 Z5.4 F60000
G1 X170.9 Y155.944 Z5.4
G1 Z5
G1 E.8 F1800
G1 F1200
M204 S8000
G1 X170.9 Y153.944 E.06336
; LINE_WIDTH: 0.470635
G1 X170.933 Y153.783 E.00573
G1 X171.014 Y153.767 E.00287
; LINE_WIDTH: 0.448395
G1 X171.094 Y153.75 E.00272
; CHANGE_LAYER
; Z_HEIGHT: 5.06667
; LAYER_HEIGHT: 0.0666666
; WIPE_START
G1 F8878.476
G1 X171.014 Y153.767 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 30/47
; update layer progress
M73 L30
M991 S0 P29 ;notify layer change

; OBJECT_ID: 15
M204 S10000
G17
G3 Z5.4 I-1.064 J.59 P1  F60000
G1 X172.269 Y156.028 Z5.4
G1 Z5.067
G1 E.8 F1800
; FEATURE: Support interface
; LINE_WIDTH: 0.42
; LAYER_HEIGHT: 0.266667
G1 F1200
M204 S8000
G1 X172.802 Y156.562 E.02973
G1 X174.042 Y156.562 E.04889
G1 X172.769 Y155.288 E.07097
G1 X174.01 Y155.288 E.04889
G1 X175.283 Y156.562 E.07097
G1 X176.523 Y156.562 E.04889
G1 X175.25 Y155.288 E.07097
G1 X176.49 Y155.288 E.04889
G1 X177.731 Y156.529 E.06917
;======== H2D 20260731========
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
; Z_HEIGHT: 5.2
; LAYER_HEIGHT: 0.133333
; WIPE_START
G1 F4800
G1 X176.49 Y155.288 E-.66691
G1 X176.245 Y155.288 E-.09309
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 31/47
; update layer progress
M73 L31
M991 S0 P30 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 3
M204 S10000
G17
G3 Z5.467 I.273 J-1.186 P1  F60000
G1 X171.298 Y154.148 Z5.467
G1 Z5.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
; LAYER_HEIGHT: 0.2
G1 F1200
M204 S8000
G1 X171.298 Y156.148 E.06634
G1 X170.502 Y156.148 E.0264
G1 X170.502 Y153.352 E.09274
G1 X179.498 Y153.352 E.29841
G1 X179.498 Y156.148 E.09274
G1 X178.702 Y156.148 E.0264
G1 X178.702 Y154.148 E.06634
G1 X171.358 Y154.148 E.24362
; COOLING_NODE: 3
M204 S250
G1 X171.69 Y154.54 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X171.69 Y156.54 E.06145
G1 X170.11 Y156.54 E.04855
G1 X170.11 Y152.96 E.11
G1 X179.89 Y152.96 E.30051
G1 X179.89 Y156.54 E.11
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X178.31 Y156.54 E.04855
G1 X178.31 Y154.54 E.06145
M73 P87 R1
G1 X171.75 Y154.54 E.20157
; WIPE_START
G1 F9547.055
M204 S8000
G1 X171.69 Y156.539 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.094 Y153.75 Z5.6 F60000
G1 Z5.2
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1200
M204 S8000
G1 X178.906 Y153.75 E.24748
; LINE_WIDTH: 0.470635
G1 X179.067 Y153.783 E.00573
G1 X179.083 Y153.864 E.00287
; LINE_WIDTH: 0.448395
G1 X179.1 Y153.944 E.00272
; LINE_WIDTH: 0.43172
G1 X179.1 Y155.944 E.06336
; WIPE_START
G1 F9259.259
G1 X179.1 Y153.944 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.685 Y155.753 Z5.6 F60000
G1 X170.9 Y155.944 Z5.6
G1 Z5.2
G1 E.8 F1800
G1 F1200
M204 S8000
G1 X170.9 Y153.944 E.06336
; LINE_WIDTH: 0.470635
G1 X170.933 Y153.783 E.00573
G1 X171.014 Y153.767 E.00287
; LINE_WIDTH: 0.448395
G1 X171.094 Y153.75 E.00272
; CHANGE_LAYER
; Z_HEIGHT: 5.33333
; LAYER_HEIGHT: 0.133334
; WIPE_START
G1 F8878.476
G1 X171.014 Y153.767 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 32/47
; update layer progress
M73 L32
M991 S0 P31 ;notify layer change

; OBJECT_ID: 15
M204 S10000
G17
G3 Z5.6 I-.551 J1.085 P1  F60000
G1 X173.679 Y155.119 Z5.6
G1 Z5.333
G1 E.8 F1800
; FEATURE: Support interface
; LINE_WIDTH: 0.42
; LAYER_HEIGHT: 0.266667
G1 F1200
M204 S8000
G1 X172.438 Y156.36 E.06917
G1 X172.438 Y156.562 E.00796
G1 X173.477 Y156.562 E.04093
G1 X174.75 Y155.288 E.07097
G1 X175.99 Y155.288 E.04889
G1 X174.717 Y156.562 E.07097
G1 X175.958 Y156.562 E.04889
G1 X177.231 Y155.288 E.07097
G1 X177.562 Y155.288 E.01304
G1 X177.562 Y156.198 E.03585
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X177.028 Y156.731 E.02973
; CHANGE_LAYER
; Z_HEIGHT: 5.4
; LAYER_HEIGHT: 0.0666666
; WIPE_START
G1 F4800
G1 X177.562 Y156.198 E-.2866
G1 X177.562 Y155.288 E-.34566
G1 X177.231 Y155.288 E-.12568
G1 X177.227 Y155.292 E-.00207
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 33/47
; update layer progress
M73 L33
M991 S0 P32 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 3
M204 S10000
G17
G3 Z5.733 I.231 J-1.195 P1  F60000
G1 X171.298 Y154.148 Z5.733
G1 Z5.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
; LAYER_HEIGHT: 0.2
G1 F1200
M204 S8000
G1 X171.298 Y156.148 E.06634
G1 X170.502 Y156.148 E.0264
G1 X170.502 Y153.352 E.09274
G1 X179.498 Y153.352 E.29841
G1 X179.498 Y156.148 E.09274
G1 X178.702 Y156.148 E.0264
G1 X178.702 Y154.148 E.06634
G1 X171.358 Y154.148 E.24362
; COOLING_NODE: 3
M204 S250
G1 X171.69 Y154.54 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X171.69 Y156.54 E.06145
G1 X170.11 Y156.54 E.04855
G1 X170.11 Y152.96 E.11
G1 X179.89 Y152.96 E.30051
G1 X179.89 Y156.54 E.11
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X178.31 Y156.54 E.04855
G1 X178.31 Y154.54 E.06145
G1 X171.75 Y154.54 E.20157
; WIPE_START
G1 F9547.055
M204 S8000
G1 X171.69 Y156.539 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.094 Y153.75 Z5.8 F60000
G1 Z5.4
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1200
M204 S8000
G1 X178.906 Y153.75 E.24748
; LINE_WIDTH: 0.470635
G1 X179.067 Y153.783 E.00573
G1 X179.083 Y153.864 E.00287
; LINE_WIDTH: 0.448395
G1 X179.1 Y153.944 E.00272
; LINE_WIDTH: 0.43172
G1 X179.1 Y155.944 E.06336
; WIPE_START
G1 F9259.259
G1 X179.1 Y153.944 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.685 Y155.753 Z5.8 F60000
G1 X170.9 Y155.944 Z5.8
G1 Z5.4
G1 E.8 F1800
G1 F1200
M204 S8000
G1 X170.9 Y153.944 E.06336
; LINE_WIDTH: 0.470635
G1 X170.933 Y153.783 E.00573
G1 X171.014 Y153.767 E.00287
; LINE_WIDTH: 0.448395
G1 X171.094 Y153.75 E.00272
; CHANGE_LAYER
; Z_HEIGHT: 5.6
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F8878.476
G1 X171.014 Y153.767 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 34/47
; update layer progress
M73 L34
M991 S0 P33 ;notify layer change

; OBJECT_ID: 15
M204 S10000
G17
G3 Z5.8 I-1.064 J.59 P1  F60000
G1 X172.269 Y156.028 Z5.8
G1 Z5.6
G1 E.8 F1800
; FEATURE: Support interface
; LINE_WIDTH: 0.42
; LAYER_HEIGHT: 0.266667
G1 F1200
M204 S8000
G1 X172.802 Y156.562 E.02972
G1 X174.042 Y156.562 E.04889
G1 X172.769 Y155.288 E.07097
G1 X174.01 Y155.288 E.04889
G1 X175.283 Y156.562 E.07097
G1 X176.523 Y156.562 E.04889
G1 X175.25 Y155.288 E.07097
M73 P88 R1
G1 X176.49 Y155.288 E.04889
G1 X177.731 Y156.529 E.06917
; COOLING_NODE: 3
; WIPE_START
G1 F4800
G1 X176.49 Y155.288 E-.66691
G1 X176.245 Y155.288 E-.09309
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.298 Y154.148 Z6 F60000
G1 Z5.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
; LAYER_HEIGHT: 0.2
G1 F1200
M204 S8000
G1 X171.298 Y156.148 E.06634
G1 X170.502 Y156.148 E.0264
G1 X170.502 Y153.352 E.09274
G1 X179.498 Y153.352 E.29841
G1 X179.498 Y156.148 E.09274
G1 X178.702 Y156.148 E.0264
G1 X178.702 Y154.148 E.06634
G1 X171.358 Y154.148 E.24362
; COOLING_NODE: 3
M204 S250
G1 X171.69 Y154.54 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X171.69 Y156.54 E.06145
G1 X170.11 Y156.54 E.04855
G1 X170.11 Y152.96 E.11
G1 X179.89 Y152.96 E.30051
G1 X179.89 Y156.54 E.11
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X178.31 Y156.54 E.04855
G1 X178.31 Y154.54 E.06145
G1 X171.75 Y154.54 E.20157
; WIPE_START
G1 F9547.055
M204 S8000
G1 X171.69 Y156.539 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.094 Y153.75 Z6 F60000
G1 Z5.6
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1200
M204 S8000
G1 X178.906 Y153.75 E.24748
; LINE_WIDTH: 0.470635
G1 X179.067 Y153.783 E.00573
G1 X179.083 Y153.864 E.00287
; LINE_WIDTH: 0.448395
G1 X179.1 Y153.944 E.00272
; LINE_WIDTH: 0.43172
G1 X179.1 Y155.944 E.06336
; WIPE_START
G1 F9259.259
G1 X179.1 Y153.944 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.685 Y155.753 Z6 F60000
G1 X170.9 Y155.944 Z6
G1 Z5.6
G1 E.8 F1800
G1 F1200
M204 S8000
G1 X170.9 Y153.944 E.06336
; LINE_WIDTH: 0.470635
G1 X170.933 Y153.783 E.00573
G1 X171.014 Y153.767 E.00287
; LINE_WIDTH: 0.448395
G1 X171.094 Y153.75 E.00272
; CHANGE_LAYER
; Z_HEIGHT: 5.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F8878.476
G1 X171.014 Y153.767 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 35/47
; update layer progress
M73 L35
M991 S0 P34 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 3
M204 S10000
G17
G3 Z6 I-.976 J.727 P1  F60000
G1 X171.298 Y154.148 Z6
G1 Z5.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X171.298 Y156.148 E.06634
G1 X170.502 Y156.148 E.0264
G1 X170.502 Y153.352 E.09274
G1 X179.498 Y153.352 E.29841
G1 X179.498 Y156.148 E.09274
G1 X178.702 Y156.148 E.0264
G1 X178.702 Y154.148 E.06634
G1 X171.358 Y154.148 E.24362
; COOLING_NODE: 3
M204 S250
G1 X171.69 Y154.54 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X171.69 Y156.54 E.06145
G1 X170.11 Y156.54 E.04855
G1 X170.11 Y152.96 E.11
G1 X179.89 Y152.96 E.30051
G1 X179.89 Y156.54 E.11
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X178.31 Y156.54 E.04855
G1 X178.31 Y154.54 E.06145
G1 X171.75 Y154.54 E.20157
; WIPE_START
M73 P89 R1
G1 F9547.055
M204 S8000
G1 X171.69 Y156.539 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.094 Y153.75 Z6.2 F60000
G1 Z5.8
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1200
M204 S8000
G1 X178.906 Y153.75 E.24748
; LINE_WIDTH: 0.470635
G1 X179.067 Y153.783 E.00573
G1 X179.083 Y153.864 E.00287
; LINE_WIDTH: 0.448395
G1 X179.1 Y153.944 E.00272
; LINE_WIDTH: 0.43172
G1 X179.1 Y155.944 E.06336
; WIPE_START
G1 F9259.259
G1 X179.1 Y153.944 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X171.685 Y155.753 Z6.2 F60000
G1 X170.9 Y155.944 Z6.2
G1 Z5.8
G1 E.8 F1800
G1 F1200
M204 S8000
G1 X170.9 Y153.944 E.06336
; LINE_WIDTH: 0.470635
G1 X170.933 Y153.783 E.00573
G1 X171.014 Y153.767 E.00287
; LINE_WIDTH: 0.448395
G1 X171.094 Y153.75 E.00272
; CHANGE_LAYER
; Z_HEIGHT: 6
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F8878.476
G1 X171.014 Y153.767 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 36/47
; update layer progress
M73 L36
M991 S0 P35 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 3
M204 S10000
G17
G3 Z6.2 I-.244 J1.192 P1  F60000
G1 X178.684 Y155.334 Z6.2
G1 Z6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X178.283 Y155.334 E.01331
G1 X177.9 Y155.334 E.01269
; FEATURE: Overhang wall
G1 F3000
M204 S5000
G1 X172.1 Y155.334 E.1924
; FEATURE: Inner wall
G1 F1200
M204 S8000
G1 X171.718 Y155.334 E.01269
G1 X171.316 Y155.334 E.01331
G1 X171.316 Y154.934 E.01327
G1 X171.316 Y154.534 E.01327
G1 X171.316 Y154.166 E.01219
G1 X171.716 Y154.166 E.01327
G1 X172.116 Y154.166 E.01327
G1 X172.516 Y154.166 E.01327
G1 X172.916 Y154.166 E.01327
G1 X173.316 Y154.166 E.01327
G1 X178.684 Y154.166 E.17805
G1 X178.684 Y155.274 E.03674
; COOLING_NODE: 3
M204 S10000
G1 X179.091 Y155.741 F60000
G1 F1200
M204 S8000
G1 X178.683 Y155.741 E.01355
G1 X178.283 Y155.741 E.01327
G1 X177.9 Y155.741 E.01269
; FEATURE: Overhang wall
G1 F3000
M204 S5000
G1 X172.1 Y155.741 E.1924
; FEATURE: Inner wall
G1 F1200
M204 S8000
G1 X171.718 Y155.741 E.01269
G1 X171.318 Y155.741 E.01327
G1 X170.909 Y155.741 E.01355
G1 X170.909 Y155.341 E.01327
G1 X170.909 Y154.941 E.01327
G1 X170.909 Y154.541 E.01327
G1 X170.909 Y154.141 E.01327
G1 X170.909 Y153.759 E.01266
G1 X171.309 Y153.759 E.01327
G1 X171.709 Y153.759 E.01327
G1 X179.091 Y153.759 E.24487
G1 X179.091 Y155.681 E.06375
; COOLING_NODE: 3
M204 S10000
G1 X179.498 Y156.148 F60000
G1 F1200
M204 S8000
G1 X179.083 Y156.148 E.01378
G1 X178.683 Y156.148 E.01327
G1 X178.283 Y156.148 E.01327
G1 X177.9 Y156.148 E.01269
; FEATURE: Overhang wall
G1 F3000
M204 S5000
G1 X172.1 Y156.148 E.1924
; FEATURE: Inner wall
G1 F1200
M204 S8000
G1 X171.718 Y156.148 E.01269
G1 X171.318 Y156.148 E.01327
G1 X170.918 Y156.148 E.01327
G1 X170.502 Y156.148 E.01378
G1 X170.502 Y155.748 E.01327
G1 X170.502 Y155.348 E.01327
G1 X170.502 Y154.948 E.01327
G1 X170.502 Y154.548 E.01327
G1 X170.502 Y154.148 E.01327
G1 X170.502 Y153.748 E.01327
G1 X170.502 Y153.352 E.01313
G1 X179.498 Y153.352 E.29841
G1 X179.498 Y156.088 E.09075
; COOLING_NODE: 3
M204 S250
G1 X179.89 Y156.54 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X179.469 Y156.54 E.01294
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X179.069 Y156.54 E.01229
G1 X178.669 Y156.54 E.01229
G1 X178.269 Y156.54 E.01229
G1 X177.9 Y156.54 E.01134
; FEATURE: Overhang wall
; LINE_WIDTH: 0.45
G1 F3000
G1 X172.1 Y156.54 E.1924
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
G1 X171.731 Y156.54 E.01134
G1 X171.331 Y156.54 E.01229
G1 X170.931 Y156.54 E.01229
G1 X170.531 Y156.54 E.01229
G1 X170.11 Y156.54 E.01294
G1 X170.11 Y156.14 E.01229
G1 X170.11 Y155.74 E.01229
G1 X170.11 Y155.34 E.01229
G1 X170.11 Y154.94 E.01229
G1 X170.11 Y154.54 E.01229
G1 X170.11 Y152.96 E.04855
G1 X179.89 Y152.96 E.30051
G1 X179.89 Y156.48 E.10816
; WIPE_START
G1 F9547.055
M204 S8000
G1 X179.469 Y156.54 E-.1616
G1 X179.069 Y156.54 E-.152
G1 X178.669 Y156.54 E-.152
G1 X178.269 Y156.54 E-.152
G1 X177.9 Y156.54 E-.14022
G1 X177.894 Y156.54 E-.00218
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z6.4 I.289 J-1.182 P1  F60000
G1 X171.48 Y154.969 Z6.4
G1 Z6
G1 E.8 F1800
; FEATURE: Bridge
; LINE_WIDTH: 0.48198
G1 F3000
M204 S8000
G1 X178.351 Y154.969 E.24582
G1 X178.351 Y154.53 E.01571
G1 X171.48 Y154.53 E.24582
; CHANGE_LAYER
; Z_HEIGHT: 6.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F3000
G1 X173.48 Y154.53 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 37/47
; update layer progress
M73 L37
M991 S0 P36 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 3
M204 S10000
G17
G3 Z6.4 I-.186 J1.203 P1  F60000
G1 X178.684 Y155.334 Z6.4
G1 Z6.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X171.316 Y155.334 E.2444
G1 X171.316 Y154.166 E.03873
G1 X178.684 Y154.166 E.2444
G1 X178.684 Y155.274 E.03674
; COOLING_NODE: 3
M204 S10000
G1 X179.091 Y155.741 F60000
G1 F1200
M204 S8000
G1 X170.909 Y155.741 E.2714
G1 X170.909 Y153.759 E.06574
G1 X179.091 Y153.759 E.2714
G1 X179.091 Y155.681 E.06375
; COOLING_NODE: 3
M204 S10000
M73 P90 R1
G1 X179.498 Y156.148 F60000
G1 F1200
M204 S8000
G1 X170.502 Y156.148 E.29841
G1 X170.502 Y153.352 E.09274
G1 X179.498 Y153.352 E.29841
G1 X179.498 Y156.088 E.09075
; COOLING_NODE: 3
M204 S250
G1 X179.89 Y156.54 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X170.11 Y156.54 E.30051
G1 X170.11 Y152.96 E.11
G1 X179.89 Y152.96 E.30051
G1 X179.89 Y156.48 E.10816
;======== H2D 20260731========
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
G1 X177.89 Y156.492 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X178.29 Y154.94 Z6.6 F60000
G1 Z6.2
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42319
G1 F1200
M204 S8000
G1 X178.29 Y154.56 E.01178
G1 X171.71 Y154.56 E.2039
G1 X171.71 Y154.94 E.01178
G1 X178.23 Y154.94 E.20205
; CHANGE_LAYER
; Z_HEIGHT: 6.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9466.957
G1 X176.23 Y154.94 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 38/47
; update layer progress
M73 L38
M991 S0 P37 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 3
M204 S10000
G17
G3 Z6.6 I-.193 J1.202 P1  F60000
G1 X178.684 Y155.334 Z6.6
G1 Z6.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X171.316 Y155.334 E.2444
G1 X171.316 Y154.166 E.03873
G1 X178.684 Y154.166 E.2444
G1 X178.684 Y155.274 E.03674
; COOLING_NODE: 3
M204 S10000
G1 X179.091 Y155.741 F60000
G1 F1200
M204 S8000
G1 X170.909 Y155.741 E.2714
G1 X170.909 Y153.759 E.06574
G1 X179.091 Y153.759 E.2714
G1 X179.091 Y155.681 E.06375
; COOLING_NODE: 3
M204 S10000
G1 X179.498 Y156.148 F60000
G1 F1200
M204 S8000
G1 X170.502 Y156.148 E.29841
G1 X170.502 Y153.352 E.09274
G1 X179.498 Y153.352 E.29841
G1 X179.498 Y156.088 E.09075
; COOLING_NODE: 3
M204 S250
G1 X179.89 Y156.54 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
M73 P91 R1
G1 X170.11 Y156.54 E.30051
G1 X170.11 Y152.96 E.11
G1 X179.89 Y152.96 E.30051
G1 X179.89 Y156.48 E.10816
;======== H2D 20260731========
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
G1 X177.89 Y156.492 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X178.29 Y154.94 Z6.8 F60000
G1 Z6.4
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42319
G1 F1200
M204 S8000
G1 X178.29 Y154.56 E.01178
G1 X171.71 Y154.56 E.2039
G1 X171.71 Y154.94 E.01178
G1 X178.23 Y154.94 E.20205
; CHANGE_LAYER
; Z_HEIGHT: 6.6
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9466.957
G1 X176.23 Y154.94 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 39/47
; update layer progress
M73 L39
M991 S0 P38 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 3
M204 S10000
G17
G3 Z6.8 I-.193 J1.202 P1  F60000
G1 X178.684 Y155.334 Z6.8
G1 Z6.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X171.316 Y155.334 E.2444
G1 X171.316 Y154.166 E.03873
G1 X178.684 Y154.166 E.2444
G1 X178.684 Y155.274 E.03674
; COOLING_NODE: 3
M204 S10000
G1 X179.091 Y155.741 F60000
G1 F1200
M204 S8000
G1 X170.909 Y155.741 E.2714
G1 X170.909 Y153.759 E.06574
G1 X179.091 Y153.759 E.2714
G1 X179.091 Y155.681 E.06375
; COOLING_NODE: 3
M204 S10000
G1 X179.498 Y156.148 F60000
G1 F1200
M204 S8000
M73 P91 R0
G1 X170.502 Y156.148 E.29841
G1 X170.502 Y153.352 E.09274
G1 X179.498 Y153.352 E.29841
G1 X179.498 Y156.088 E.09075
; COOLING_NODE: 3
M204 S250
G1 X179.89 Y156.54 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X170.11 Y156.54 E.30051
G1 X170.11 Y152.96 E.11
G1 X179.89 Y152.96 E.30051
G1 X179.89 Y156.48 E.10816
;======== H2D 20260731========
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
G1 X177.89 Y156.492 E-.76
; WIPE_END
M73 P92 R0
G1 E-.04 F1800
M204 S10000
G1 X178.29 Y154.94 Z7 F60000
G1 Z6.6
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42319
G1 F1200
M204 S8000
G1 X178.29 Y154.56 E.01178
G1 X171.71 Y154.56 E.2039
G1 X171.71 Y154.94 E.01178
G1 X178.23 Y154.94 E.20205
; CHANGE_LAYER
; Z_HEIGHT: 6.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9466.957
G1 X176.23 Y154.94 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 40/47
; update layer progress
M73 L40
M991 S0 P39 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 3
M204 S10000
G17
G3 Z7 I-.193 J1.202 P1  F60000
G1 X178.684 Y155.334 Z7
G1 Z6.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X171.316 Y155.334 E.2444
G1 X171.316 Y154.166 E.03873
G1 X178.684 Y154.166 E.2444
G1 X178.684 Y155.274 E.03674
; COOLING_NODE: 3
M204 S10000
G1 X179.091 Y155.741 F60000
G1 F1200
M204 S8000
G1 X170.909 Y155.741 E.2714
G1 X170.909 Y153.759 E.06574
G1 X179.091 Y153.759 E.2714
G1 X179.091 Y155.681 E.06375
; COOLING_NODE: 3
M204 S10000
G1 X179.498 Y156.148 F60000
G1 F1200
M204 S8000
G1 X170.502 Y156.148 E.29841
G1 X170.502 Y153.352 E.09274
G1 X179.498 Y153.352 E.29841
G1 X179.498 Y156.088 E.09075
; COOLING_NODE: 3
M204 S250
G1 X179.89 Y156.54 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X170.11 Y156.54 E.30051
G1 X170.11 Y152.96 E.11
G1 X179.89 Y152.96 E.30051
G1 X179.89 Y156.48 E.10816
;======== H2D 20260731========
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
G1 X177.89 Y156.492 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X178.29 Y154.94 Z7.2 F60000
G1 Z6.8
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42319
G1 F1200
M204 S8000
G1 X178.29 Y154.56 E.01178
G1 X171.71 Y154.56 E.2039
G1 X171.71 Y154.94 E.01178
G1 X178.23 Y154.94 E.20205
; CHANGE_LAYER
; Z_HEIGHT: 7
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9466.957
G1 X176.23 Y154.94 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 41/47
; update layer progress
M73 L41
M991 S0 P40 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 3
M204 S10000
G17
G3 Z7.2 I-.193 J1.202 P1  F60000
G1 X178.684 Y155.334 Z7.2
G1 Z7
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X171.316 Y155.334 E.2444
G1 X171.316 Y154.166 E.03873
G1 X178.684 Y154.166 E.2444
G1 X178.684 Y155.274 E.03674
; COOLING_NODE: 3
M204 S10000
M73 P93 R0
G1 X179.091 Y155.741 F60000
G1 F1200
M204 S8000
G1 X170.909 Y155.741 E.2714
G1 X170.909 Y153.759 E.06574
G1 X179.091 Y153.759 E.2714
G1 X179.091 Y155.681 E.06375
; COOLING_NODE: 3
M204 S10000
G1 X179.498 Y156.148 F60000
G1 F1200
M204 S8000
G1 X170.502 Y156.148 E.29841
G1 X170.502 Y153.352 E.09274
G1 X179.498 Y153.352 E.29841
G1 X179.498 Y156.088 E.09075
; COOLING_NODE: 3
M204 S250
G1 X179.89 Y156.54 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X170.11 Y156.54 E.30051
G1 X170.11 Y152.96 E.11
G1 X179.89 Y152.96 E.30051
G1 X179.89 Y156.48 E.10816
;======== H2D 20260731========
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
G1 X177.89 Y156.492 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X178.29 Y154.94 Z7.4 F60000
G1 Z7
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42319
G1 F1200
M204 S8000
G1 X178.29 Y154.56 E.01178
G1 X171.71 Y154.56 E.2039
G1 X171.71 Y154.94 E.01178
G1 X178.23 Y154.94 E.20205
; CHANGE_LAYER
; Z_HEIGHT: 7.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9466.957
G1 X176.23 Y154.94 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 42/47
; update layer progress
M73 L42
M991 S0 P41 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 3
M204 S10000
G17
G3 Z7.4 I-.193 J1.202 P1  F60000
G1 X178.684 Y155.334 Z7.4
G1 Z7.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X171.316 Y155.334 E.2444
G1 X171.316 Y154.166 E.03873
G1 X178.684 Y154.166 E.2444
G1 X178.684 Y155.274 E.03674
; COOLING_NODE: 3
M204 S10000
G1 X179.091 Y155.741 F60000
G1 F1200
M204 S8000
G1 X170.909 Y155.741 E.2714
G1 X170.909 Y153.759 E.06574
G1 X179.091 Y153.759 E.2714
G1 X179.091 Y155.681 E.06375
; COOLING_NODE: 3
M204 S10000
G1 X179.498 Y156.148 F60000
G1 F1200
M204 S8000
G1 X170.502 Y156.148 E.29841
M73 P94 R0
G1 X170.502 Y153.352 E.09274
G1 X179.498 Y153.352 E.29841
G1 X179.498 Y156.088 E.09075
; COOLING_NODE: 3
M204 S250
G1 X179.89 Y156.54 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X170.11 Y156.54 E.30051
G1 X170.11 Y152.96 E.11
G1 X179.89 Y152.96 E.30051
G1 X179.89 Y156.48 E.10816
;======== H2D 20260731========
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
G1 X177.89 Y156.492 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X178.29 Y154.94 Z7.6 F60000
G1 Z7.2
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42319
G1 F1200
M204 S8000
G1 X178.29 Y154.56 E.01178
G1 X171.71 Y154.56 E.2039
G1 X171.71 Y154.94 E.01178
G1 X178.23 Y154.94 E.20205
; CHANGE_LAYER
; Z_HEIGHT: 7.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9466.957
G1 X176.23 Y154.94 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 43/47
; update layer progress
M73 L43
M991 S0 P42 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 3
M204 S10000
G17
G3 Z7.6 I-.193 J1.202 P1  F60000
G1 X178.684 Y155.334 Z7.6
G1 Z7.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X171.316 Y155.334 E.2444
G1 X171.316 Y154.166 E.03873
G1 X178.684 Y154.166 E.2444
G1 X178.684 Y155.274 E.03674
; COOLING_NODE: 3
M204 S10000
G1 X179.091 Y155.741 F60000
G1 F1200
M204 S8000
G1 X170.909 Y155.741 E.2714
G1 X170.909 Y153.759 E.06574
G1 X179.091 Y153.759 E.2714
G1 X179.091 Y155.681 E.06375
; COOLING_NODE: 3
M204 S10000
G1 X179.498 Y156.148 F60000
G1 F1200
M204 S8000
G1 X170.502 Y156.148 E.29841
G1 X170.502 Y153.352 E.09274
G1 X179.498 Y153.352 E.29841
G1 X179.498 Y156.088 E.09075
; COOLING_NODE: 3
M204 S250
G1 X179.89 Y156.54 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X170.11 Y156.54 E.30051
G1 X170.11 Y152.96 E.11
G1 X179.89 Y152.96 E.30051
G1 X179.89 Y156.48 E.10816
;======== H2D 20260731========
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
M73 P95 R0
G1 F9547.055
M204 S8000
G1 X177.89 Y156.492 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X178.29 Y154.94 Z7.8 F60000
G1 Z7.4
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42319
G1 F1200
M204 S8000
G1 X178.29 Y154.56 E.01178
G1 X171.71 Y154.56 E.2039
G1 X171.71 Y154.94 E.01178
G1 X178.23 Y154.94 E.20205
; CHANGE_LAYER
; Z_HEIGHT: 7.6
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9466.957
G1 X176.23 Y154.94 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 44/47
; update layer progress
M73 L44
M991 S0 P43 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 3
M204 S10000
G17
G3 Z7.8 I-.193 J1.202 P1  F60000
G1 X178.684 Y155.334 Z7.8
G1 Z7.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X171.316 Y155.334 E.2444
G1 X171.316 Y154.166 E.03873
G1 X178.684 Y154.166 E.2444
G1 X178.684 Y155.274 E.03674
; COOLING_NODE: 3
M204 S10000
G1 X179.091 Y155.741 F60000
G1 F1200
M204 S8000
G1 X170.909 Y155.741 E.2714
G1 X170.909 Y153.759 E.06574
G1 X179.091 Y153.759 E.2714
G1 X179.091 Y155.681 E.06375
; COOLING_NODE: 3
M204 S10000
G1 X179.498 Y156.148 F60000
G1 F1200
M204 S8000
G1 X170.502 Y156.148 E.29841
G1 X170.502 Y153.352 E.09274
G1 X179.498 Y153.352 E.29841
G1 X179.498 Y156.088 E.09075
; COOLING_NODE: 3
M204 S250
G1 X179.89 Y156.54 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X170.11 Y156.54 E.30051
G1 X170.11 Y152.96 E.11
G1 X179.89 Y152.96 E.30051
G1 X179.89 Y156.48 E.10816
;======== H2D 20260731========
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
G1 X177.89 Y156.492 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X178.29 Y154.94 Z8 F60000
G1 Z7.6
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42319
G1 F1200
M204 S8000
G1 X178.29 Y154.56 E.01178
G1 X171.71 Y154.56 E.2039
G1 X171.71 Y154.94 E.01178
G1 X178.23 Y154.94 E.20205
; CHANGE_LAYER
; Z_HEIGHT: 7.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9466.957
G1 X176.23 Y154.94 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 45/47
; update layer progress
M73 L45
M991 S0 P44 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 3
M204 S10000
G17
M73 P96 R0
G3 Z8 I-.487 J1.115 P1  F60000
G1 X179.89 Y156.54 Z8
G1 Z7.8
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X170.11 Y156.54 E.30051
G1 X170.11 Y152.96 E.11
G1 X179.89 Y152.96 E.30051
G1 X179.89 Y156.48 E.10816
;======== H2D 20260731========
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
G1 X177.89 Y156.492 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X179.338 Y153.406 Z8.2 F60000
G1 Z7.8
G1 E.8 F1800
; FEATURE: Top surface
G1 F1200
M204 S2000
G1 X179.683 Y153.751 E.01498
G1 X179.816 Y153.885
G1 X179.816 Y154.418
G1 X179.683 Y154.284
G1 X178.805 Y153.406 E.03815
G1 X178.671 Y153.273
G1 X178.138 Y153.273
G1 X178.271 Y153.406
G1 X179.683 Y154.817 E.06132
G1 X179.816 Y154.951
G1 X179.816 Y155.484
G1 X179.683 Y155.351
G1 X177.738 Y153.406 E.08449
G1 X177.605 Y153.273
G1 X177.071 Y153.273
G1 X177.205 Y153.406
G1 X179.683 Y155.884 E.10767
G1 X179.816 Y156.018
G1 X179.732 Y156.466
G1 X179.598 Y156.333
G1 X176.672 Y153.406 E.12717
G1 X176.538 Y153.273
G1 X176.005 Y153.273
G1 X176.138 Y153.406
G1 X179.065 Y156.333 E.12717
G1 X179.198 Y156.466
G1 X178.665 Y156.466
G1 X178.532 Y156.333
G1 X175.605 Y153.406 E.12717
G1 X175.472 Y153.273
G1 X174.938 Y153.273
G1 X175.072 Y153.406
G1 X177.998 Y156.333 E.12717
G1 X178.132 Y156.466
G1 X177.599 Y156.466
G1 X177.465 Y156.333
G1 X174.539 Y153.406 E.12717
G1 X174.405 Y153.273
G1 X173.872 Y153.273
G1 X174.005 Y153.406
G1 X176.932 Y156.333 E.12717
G1 X177.065 Y156.466
G1 X176.532 Y156.466
G1 X176.399 Y156.333
G1 X173.472 Y153.406 E.12717
G1 X173.338 Y153.273
G1 X172.805 Y153.273
G1 X172.939 Y153.406
G1 X175.865 Y156.333 E.12717
G1 X175.999 Y156.466
G1 X175.466 Y156.466
G1 X175.332 Y156.333
G1 X172.406 Y153.406 E.12717
G1 X172.272 Y153.273
G1 X171.739 Y153.273
G1 X171.872 Y153.406
G1 X174.799 Y156.333 E.12717
G1 X174.932 Y156.466
G1 X174.399 Y156.466
G1 X174.265 Y156.333
G1 X171.339 Y153.406 E.12717
G1 X171.205 Y153.273
G1 X170.672 Y153.273
G1 X170.806 Y153.406
G1 X173.732 Y156.333 E.12717
G1 X173.866 Y156.466
G1 X173.333 Y156.466
G1 X173.199 Y156.333
G1 X170.317 Y153.451 E.12522
G1 X170.184 Y153.317
G1 X170.184 Y153.851
G1 X170.317 Y153.984
G1 X172.666 Y156.333 E.10205
G1 X172.799 Y156.466
G1 X172.266 Y156.466
G1 X172.132 Y156.333
M73 P97 R0
G1 X170.317 Y154.518 E.07887
G1 X170.184 Y154.384
G1 X170.184 Y154.917
G1 X170.317 Y155.051
G1 X171.599 Y156.333 E.0557
G1 X171.733 Y156.466
G1 X171.2 Y156.466
G1 X171.066 Y156.333
G1 X170.317 Y155.584 E.03253
; WIPE_START
G1 F9547.055
M204 S8000
G1 X171.066 Y156.333 E-.40227
G1 X171.2 Y156.466 E-.07182
G1 X171.733 Y156.466 E-.20264
G1 X171.599 Y156.333 E-.07182
G1 X171.578 Y156.311 E-.01146
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X170.306 Y153.268 Z8.2 F60000
G1 Z7.8
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.26667
G1 F1200
M204 S8000
G1 X179.694 Y153.268 E.17117
; CHANGE_LAYER
; Z_HEIGHT: 8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F15000
G1 X177.694 Y153.268 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 46/47
; update layer progress
M73 L46
M991 S0 P45 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 3
M204 S10000
G17
G3 Z8.2 I-.534 J1.094 P1  F60000
G1 X179.498 Y154.148 Z8.2
G1 Z8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X170.502 Y154.148 E.29841
G1 X170.502 Y153.352 E.0264
G1 X179.498 Y153.352 E.29841
G1 X179.498 Y154.088 E.02441
; COOLING_NODE: 3
M204 S250
G1 X179.89 Y154.54 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X170.11 Y154.54 E.30051
G1 X170.11 Y152.96 E.04855
G1 X179.89 Y152.96 E.30051
G1 X179.89 Y154.48 E.04671
;======== H2D 20260731========
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
G1 X179.294 Y153.75 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1200
M204 S8000
M73 P98 R0
G1 X170.706 Y153.75 E.27211
; CHANGE_LAYER
; Z_HEIGHT: 8.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.259
G1 X172.706 Y153.75 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 47/47
; update layer progress
M73 L47
M991 S0 P46 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 3
M204 S10000
G17
G3 Z8.4 I-.133 J1.21 P1  F60000
G1 X179.89 Y154.54 Z8.4
G1 Z8.2
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X170.11 Y154.54 E.30051
G1 X170.11 Y152.96 E.04855
G1 X179.89 Y152.96 E.30051
G1 X179.89 Y154.48 E.04671
;======== H2D 20260731========
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
G1 X179.683 Y153.751 F60000
; FEATURE: Top surface
G1 F1200
M204 S2000
G1 X179.099 Y153.167 E.02536
G1 X178.965 Y153.034
G1 X178.432 Y153.034
G1 X178.566 Y153.167
G1 X179.683 Y154.284 E.04853
G1 X179.816 Y154.418
G1 X179.331 Y154.466
G1 X179.198 Y154.333
G1 X178.033 Y153.167 E.05064
G1 X177.899 Y153.034
G1 X177.366 Y153.034
G1 X177.499 Y153.167
G1 X178.665 Y154.333 E.05064
G1 X178.798 Y154.466
G1 X178.265 Y154.466
G1 X178.131 Y154.333
G1 X176.966 Y153.167 E.05064
G1 X176.832 Y153.034
G1 X176.299 Y153.034
G1 X176.433 Y153.167
G1 X177.598 Y154.333 E.05064
G1 X177.732 Y154.466
G1 X177.198 Y154.466
G1 X177.065 Y154.333
G1 X175.9 Y153.167 E.05064
G1 X175.766 Y153.034
G1 X175.233 Y153.034
G1 X175.366 Y153.167
G1 X176.532 Y154.333 E.05064
G1 X176.665 Y154.466
G1 X176.132 Y154.466
G1 X175.998 Y154.333
G1 X174.833 Y153.167 E.05064
G1 X174.699 Y153.034
G1 X174.166 Y153.034
G1 X174.3 Y153.167
G1 X175.465 Y154.333 E.05064
G1 X175.599 Y154.466
G1 X175.065 Y154.466
G1 X174.932 Y154.333
G1 X173.767 Y153.167 E.05064
G1 X173.633 Y153.034
G1 X173.1 Y153.034
G1 X173.233 Y153.167
G1 X174.399 Y154.333 E.05064
G1 X174.532 Y154.466
G1 X173.999 Y154.466
G1 X173.865 Y154.333
G1 X172.7 Y153.167 E.05064
G1 X172.566 Y153.034
G1 X172.033 Y153.034
G1 X172.167 Y153.167
G1 X173.332 Y154.333 E.05064
G1 X173.466 Y154.466
G1 X172.932 Y154.466
G1 X172.799 Y154.333
G1 X171.633 Y153.167 E.05064
G1 X171.5 Y153.034
G1 X170.967 Y153.034
G1 X171.1 Y153.167
G1 X172.265 Y154.333 E.05064
G1 X172.399 Y154.466
G1 X171.866 Y154.466
G1 X171.732 Y154.333
G1 X170.567 Y153.167 E.05064
G1 X170.433 Y153.034
G1 X170.184 Y153.317
G1 X170.317 Y153.451
G1 X171.199 Y154.333 E.03831
G1 X171.333 Y154.466
G1 X170.799 Y154.466
G1 X170.666 Y154.333
G1 X170.317 Y153.984 E.01514
; close powerlost recovery
M1003 S0
; WIPE_START
G1 F9547.055
M204 S8000
G1 X170.666 Y154.333 E-.18719
G1 X170.799 Y154.466 E-.07182
G1 X171.333 Y154.466 E-.20264
G1 X171.199 Y154.333 E-.07182
G1 X170.777 Y153.911 E-.22653
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z8.6 I1.217 J0 P1  F60000
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
G1 Z8.6 F900 ; lower z a little
M1002 judge_flag timelapse_record_flag
M622 J1
    G150.3
    M400 ; wait all motion done
    M991 S0 P-1 ;end smooth timelapse at safe pos
    M400 S5 ;wait for last picture to be taken
M623  ;end of "timelapse_record_flag"

G90
G1 Z18.2 F900 ; lower z a little

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

    
        G1 Z104.1 F600
        G1 Z102.1
    

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

