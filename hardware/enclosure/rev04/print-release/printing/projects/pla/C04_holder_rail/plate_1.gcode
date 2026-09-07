; HEADER_BLOCK_START
; BambuStudio 02.08.02.61
; model printing time: 10m 37s; total estimated time: 16m 4s
; total layer number: 109
; total filament length [mm] : 423.02
; total filament volume [cm^3] : 1017.49
; total filament weight [g] : 1.26
; filament_density: 1.24
; filament_diameter: 1.75
; max_z_height: 21.80
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
    G29 A1 O X168.793 Y146.193 I12.4131 J27.6131 R
    M400
M623

M622 J2
    M1002 gcode_claim_action : 1
    
        G29.20 A4
        G29 A2 O X168.793 Y146.193 I12.4131 J27.6131 R
    
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
M73 P32 R10
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
; layer num/total_layer_count: 1/109
; update layer progress
M73 L1
M991 S0 P0 ;notify layer change

M106 S0
M106 P2 S0
; OBJECT_ID: 15
M73 P33 R10
G1 X169.972 Y147.574 F60000
M204 S6000
G1 Z.4
G1 Z.2
G1 E.8 F1800
; FEATURE: Brim
; LINE_WIDTH: 0.5
G1 F3000
M204 S500
G1 X170.388 Y147.19 E.02109
G1 X170.862 Y146.878 E.02113
G1 X171.343 Y146.661 E.01967
G1 X171.887 Y146.498 E.02114
G1 X172.612 Y146.422 E.02715
G1 X177.391 Y146.422 E.17799
G1 X177.96 Y146.469 E.02127
G1 X178.871 Y146.752 E.03555
G1 X179.378 Y147.025 E.02144
G1 X179.826 Y147.372 E.02109
G1 X180.21 Y147.788 E.02109
G1 X180.522 Y148.262 E.02113
G1 X180.739 Y148.743 E.01967
G1 X180.902 Y149.287 E.02114
G1 X180.978 Y150.012 E.02716
G1 X180.978 Y169.991 E.74412
G1 X180.931 Y170.56 E.02127
G1 X180.648 Y171.471 E.03555
G1 X180.375 Y171.978 E.02144
G1 X180.028 Y172.426 E.02109
G1 X179.612 Y172.81 E.02109
G1 X179.138 Y173.122 E.02113
M73 P34 R10
G1 X178.657 Y173.339 E.01967
G1 X178.113 Y173.502 E.02114
G1 X177.388 Y173.578 E.02716
G1 X172.609 Y173.578 E.17798
G1 X172.04 Y173.531 E.02127
G1 X171.129 Y173.248 E.03555
G1 X170.622 Y172.975 E.02144
G1 X170.174 Y172.628 E.02109
G1 X169.79 Y172.212 E.02109
G1 X169.478 Y171.738 E.02113
G1 X169.261 Y171.257 E.01967
G1 X169.098 Y170.713 E.02114
G1 X169.022 Y169.988 E.02715
G1 X169.022 Y150.009 E.74413
G1 X169.069 Y149.44 E.02127
G1 X169.352 Y148.529 E.03555
G1 X169.625 Y148.022 E.02144
G1 X169.935 Y147.621 E.01886
M204 S6000
G1 X170.296 Y147.901 F60000
G1 F3000
M204 S500
G1 X170.303 Y147.893 E.0004
G1 X170.679 Y147.545 E.0191
G1 X171.092 Y147.276 E.01836
G1 X171.512 Y147.088 E.01714
G1 X171.99 Y146.947 E.01855
G1 X172.643 Y146.879 E.02445
G1 X177.377 Y146.88 E.17634
G1 X177.886 Y146.925 E.01904
G1 X178.681 Y147.171 E.03099
G1 X179.118 Y147.404 E.01844
G1 X179.507 Y147.703 E.01827
G1 X179.841 Y148.062 E.01826
G1 X180.114 Y148.474 E.0184
G1 X180.312 Y148.912 E.01794
G1 X180.453 Y149.39 E.01855
G1 X180.521 Y150.043 E.02445
G1 X180.521 Y169.966 E.74205
G1 X180.475 Y170.486 E.01946
G1 X180.218 Y171.305 E.03197
G1 X179.984 Y171.737 E.0183
G1 X179.697 Y172.107 E.01743
G1 X179.321 Y172.455 E.0191
G1 X178.908 Y172.724 E.01836
G1 X178.488 Y172.912 E.01714
G1 X178.01 Y173.053 E.01855
G1 X177.357 Y173.121 E.02445
G1 X172.634 Y173.121 E.17591
G1 X172.114 Y173.075 E.01946
G1 X171.295 Y172.818 E.03197
G1 X170.863 Y172.584 E.0183
G1 X170.476 Y172.282 E.01827
G1 X170.145 Y171.921 E.01826
G1 X169.886 Y171.526 E.01756
G1 X169.688 Y171.088 E.01794
G1 X169.547 Y170.61 E.01855
G1 X169.479 Y169.957 E.02445
G1 X169.479 Y150.034 E.74206
G1 X169.525 Y149.514 E.01946
G1 X169.782 Y148.695 E.03197
G1 X170.016 Y148.263 E.0183
G1 X170.259 Y147.949 E.01479
M204 S6000
G1 X170.622 Y148.227 F60000
G1 F3000
M204 S500
G1 X170.634 Y148.212 E.00072
G1 X170.971 Y147.9 E.01709
G1 X171.322 Y147.674 E.01555
G1 X171.68 Y147.515 E.0146
G1 X172.092 Y147.396 E.01596
G1 X172.674 Y147.336 E.02179
G1 X177.351 Y147.337 E.17421
G1 X177.811 Y147.38 E.01723
G1 X178.492 Y147.591 E.02655
G1 X178.86 Y147.784 E.01546
G1 X179.189 Y148.035 E.01543
G1 X179.473 Y148.337 E.01543
G1 X179.706 Y148.686 E.01564
G1 X179.886 Y149.081 E.01615
G1 X180.004 Y149.492 E.01592
G1 X180.064 Y150.074 E.0218
G1 X180.064 Y169.94 E.73993
G1 X180.02 Y170.411 E.01763
G1 X179.789 Y171.138 E.0284
G1 X179.593 Y171.495 E.01518
G1 X179.351 Y171.805 E.01464
G1 X179.047 Y172.085 E.01539
G1 X178.697 Y172.316 E.01562
G1 X178.337 Y172.479 E.01471
G1 X177.933 Y172.599 E.01571
G1 X177.326 Y172.664 E.02273
G1 X172.66 Y172.664 E.17379
G1 X172.189 Y172.62 E.01763
G1 X171.486 Y172.4 E.02742
G1 X171.124 Y172.206 E.0153
G1 X170.796 Y171.952 E.01544
G1 X170.514 Y171.647 E.01547
G1 X170.283 Y171.296 E.01566
G1 X170.114 Y170.919 E.01538
G1 X169.996 Y170.508 E.01592
G1 X169.937 Y169.941 E.02127
G1 X169.936 Y150.06 E.74047
G1 X169.98 Y149.589 E.01763
G1 X170.211 Y148.862 E.0284
G1 X170.395 Y148.523 E.01436
G1 X170.586 Y148.275 E.01166
M204 S6000
G1 X170.948 Y148.556 F60000
G1 F3000
M204 S500
G1 X170.981 Y148.513 E.00204
G1 X171.243 Y148.271 E.01329
G1 X171.531 Y148.083 E.0128
G1 X171.829 Y147.949 E.01216
G1 X172.167 Y147.85 E.01314
G1 X172.704 Y147.793 E.0201
G1 X177.323 Y147.794 E.17203
G1 X177.735 Y147.835 E.01542
G1 X178.305 Y148.012 E.02224
G1 X178.603 Y148.166 E.0125
G1 X178.89 Y148.384 E.01343
G1 X179.121 Y148.632 E.0126
G1 X179.299 Y148.9 E.012
G1 X179.452 Y149.231 E.01357
G1 X179.555 Y149.591 E.01397
G1 X179.606 Y150.09 E.01868
G1 X179.607 Y169.912 E.73829
G1 X179.565 Y170.334 E.01579
G1 X179.361 Y170.969 E.02485
G1 X179.203 Y171.252 E.01205
G1 X179.005 Y171.502 E.01188
G1 X178.755 Y171.73 E.01262
G1 X178.485 Y171.908 E.01207
G1 X178.185 Y172.046 E.01227
G1 X177.855 Y172.146 E.01285
G1 X177.295 Y172.207 E.02099
G1 X172.688 Y172.207 E.17158
G1 X172.266 Y172.165 E.01581
G1 X171.677 Y171.98 E.023
G1 X171.384 Y171.826 E.01232
G1 X171.115 Y171.621 E.0126
G1 X170.883 Y171.373 E.01264
G1 X170.692 Y171.084 E.0129
G1 X170.542 Y170.752 E.01358
G1 X170.445 Y170.409 E.01329
G1 X170.395 Y169.924 E.01815
G1 X170.393 Y150.088 E.73882
G1 X170.435 Y149.666 E.01578
G1 X170.64 Y149.03 E.02488
G1 X170.786 Y148.764 E.0113
G1 X170.911 Y148.604 E.00758
M204 S6000
G1 X171.293 Y148.89 F60000
G1 F3000
M204 S500
G1 X171.382 Y148.771 E.0055
G1 X171.642 Y148.56 E.01248
G1 X171.896 Y148.419 E.01084
G1 X172.128 Y148.337 E.00914
G1 X172.635 Y148.25 E.01917
G1 X177.372 Y148.25 E.17644
G1 X177.669 Y148.285 E.01115
G1 X178.124 Y148.433 E.01781
G1 X178.244 Y148.495 E.00502
G1 X178.629 Y148.781 E.01788
G1 X178.821 Y149.009 E.01111
G1 X178.945 Y149.209 E.00877
G1 X179.026 Y149.393 E.00747
G1 X179.101 Y149.643 E.00974
G1 X179.15 Y150.026 E.01436
G1 X179.15 Y169.972 E.74292
G1 X179.115 Y170.272 E.01127
G1 X179.027 Y170.589 E.01225
G1 X178.755 Y171.075 E.02072
G1 X178.626 Y171.223 E.00731
G1 X178.46 Y171.37 E.00826
G1 X178.25 Y171.512 E.00945
G1 X178.006 Y171.626 E.01004
G1 X177.757 Y171.701 E.00968
G1 X177.374 Y171.75 E.01436
G1 X172.628 Y171.75 E.17677
G1 X172.331 Y171.715 E.01116
G1 X171.876 Y171.567 E.0178
G1 X171.756 Y171.505 E.00502
G1 X171.371 Y171.219 E.01788
G1 X171.179 Y170.991 E.01111
G1 X171.055 Y170.791 E.00876
G1 X170.974 Y170.607 E.00747
G1 X170.899 Y170.356 E.00975
G1 X170.85 Y169.974 E.01435
G1 X170.855 Y149.953 E.74572
G1 X170.904 Y149.639 E.01184
G1 X171.004 Y149.331 E.01205
G1 X171.095 Y149.155 E.0074
G1 X171.257 Y148.938 E.01008
M204 S6000
G1 X171.625 Y149.193 F60000
G1 F3000
M204 S500
G1 X171.673 Y149.123 E.00316
G1 X171.865 Y148.959 E.00939
G1 X172.058 Y148.846 E.00833
G1 X172.205 Y148.788 E.0059
G1 X172.623 Y148.707 E.01585
G1 X177.38 Y148.707 E.17717
G1 X177.621 Y148.739 E.00905
G1 X177.978 Y148.866 E.01411
G1 X178.278 Y149.074 E.0136
G1 X178.433 Y149.249 E.00871
G1 X178.531 Y149.403 E.00681
G1 X178.586 Y149.516 E.00465
G1 X178.666 Y149.785 E.01048
G1 X178.693 Y150.017 E.00868
G1 X178.693 Y169.98 E.74354
G1 X178.661 Y170.221 E.00906
G1 X178.588 Y170.463 E.00942
G1 X178.406 Y170.781 E.01364
G1 X178.33 Y170.874 E.00449
G1 X178.151 Y171.033 E.00891
G1 X177.997 Y171.131 E.00681
G1 X177.884 Y171.186 E.00465
G1 X177.615 Y171.266 E.01048
G1 X177.383 Y171.293 E.00868
G1 X172.62 Y171.293 E.1774
G1 X172.379 Y171.261 E.00906
G1 X172.022 Y171.134 E.01411
G1 X171.722 Y170.926 E.0136
G1 X171.567 Y170.751 E.00871
G1 X171.469 Y170.597 E.00681
G1 X171.414 Y170.484 E.00465
G1 X171.334 Y170.215 E.01049
G1 X171.307 Y169.983 E.00868
G1 X171.307 Y150.02 E.74354
G1 X171.339 Y149.779 E.00905
G1 X171.414 Y149.532 E.00962
G1 X171.466 Y149.422 E.00453
G1 X171.591 Y149.242 E.00816
M204 S6000
G1 X171.969 Y149.48 F60000
G1 F3000
M204 S500
G1 X171.983 Y149.458 E.00098
G1 X172.085 Y149.36 E.00529
G1 X172.298 Y149.235 E.00918
G1 X172.61 Y149.164 E.01191
G1 X177.389 Y149.164 E.17799
G1 X177.555 Y149.191 E.00626
G1 X177.73 Y149.25 E.00687
G1 X177.942 Y149.383 E.00934
G1 X178.042 Y149.487 E.00539
G1 X178.151 Y149.657 E.00751
G1 X178.212 Y149.837 E.00709
G1 X178.236 Y150.009 E.00646
G1 X178.236 Y169.989 E.74417
G1 X178.209 Y170.155 E.00626
G1 X178.151 Y170.33 E.00687
G1 X178.017 Y170.542 E.00934
G1 X177.913 Y170.642 E.00539
G1 X177.743 Y170.751 E.00751
G1 X177.563 Y170.812 E.00709
G1 X177.391 Y170.836 E.00646
G1 X172.611 Y170.836 E.17803
G1 X172.445 Y170.809 E.00626
G1 X172.27 Y170.751 E.00687
G1 X172.058 Y170.617 E.00934
G1 X171.958 Y170.513 E.00539
G1 X171.849 Y170.343 E.00751
G1 X171.788 Y170.163 E.00709
G1 X171.764 Y169.991 E.00646
G1 X171.764 Y150.011 E.74417
G1 X171.791 Y149.845 E.00626
G1 X171.85 Y149.67 E.00687
G1 X171.937 Y149.531 E.00612
M204 S6000
G1 X172.288 Y149.799 F60000
G1 F3000
M204 S500
G1 X172.414 Y149.677 E.00651
G1 X172.6 Y149.621 E.00722
G1 X177.4 Y149.621 E.17878
G1 X177.601 Y149.688 E.0079
G1 X177.723 Y149.814 E.00651
G1 X177.763 Y149.916 E.00408
G1 X177.779 Y150 E.00317
G1 X177.779 Y170 E.74492
G1 X177.712 Y170.201 E.0079
G1 X177.586 Y170.323 E.00651
G1 X177.484 Y170.363 E.00408
M73 P35 R10
G1 X177.4 Y170.379 E.00317
G1 X172.6 Y170.379 E.17878
G1 X172.399 Y170.312 E.0079
G1 X172.277 Y170.186 E.00651
G1 X172.237 Y170.084 E.00408
G1 X172.221 Y170 E.00317
G1 X172.221 Y150 E.74492
G1 X172.27 Y149.856 E.00566
; WIPE_START
G1 X172.414 Y149.677 E-.08729
G1 X172.6 Y149.621 E-.07367
G1 X174.176 Y149.621 E-.59903
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X177 Y150.4 Z.6 F60000
G1 Z.2
G1 E.8 F1800
; FEATURE: Outer wall
G1 F3000
M204 S500
G1 X177 Y169.6 E.71513
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X173 Y169.6 E.14899
G1 X173 Y150.4 E.71513
G1 X176.94 Y150.4 E.14675
M204 S6000
G1 X176.543 Y150.857 F60000
; FEATURE: Inner wall
G1 F3000
M204 S500
G1 X176.543 Y169.143 E.68108
G1 X173.457 Y169.143 E.11494
G1 X173.457 Y150.857 E.68108
G1 X176.483 Y150.857 E.1127
M204 S6000
G1 X176.086 Y151.314 F60000
G1 F3000
M204 S500
G1 X176.086 Y168.686 E.64703
G1 X173.914 Y168.686 E.08089
G1 X173.914 Y151.314 E.64703
G1 X176.026 Y151.314 E.07865
M204 S6000
G1 X175.629 Y151.771 F60000
G1 F3000
M204 S500
G1 X175.629 Y168.229 E.61298
G1 X174.371 Y168.229 E.04684
G1 X174.371 Y151.771 E.61298
G1 X175.569 Y151.771 E.04461
; WIPE_START
G1 X175.576 Y153.771 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X174.554 Y152.002 Z.6 F60000
G1 Z.2
G1 E.8 F1800
; FEATURE: Bottom surface
; LINE_WIDTH: 0.5073
G1 F6300
M204 S500
G1 X175.24 Y152.688 E.03672
G1 X175.24 Y153.345 E.02485
G1 X174.76 Y152.864 E.02572
G1 X174.76 Y153.521 E.02485
G1 X175.24 Y154.001 E.02572
G1 X175.24 Y154.658 E.02485
G1 X174.76 Y154.177 E.02572
G1 X174.76 Y154.834 E.02485
G1 X175.24 Y155.315 E.02572
G1 X175.24 Y155.971 E.02485
G1 X174.76 Y155.491 E.02572
G1 X174.76 Y156.148 E.02485
G1 X175.24 Y156.628 E.02572
G1 X175.24 Y157.285 E.02485
G1 X174.76 Y156.804 E.02572
G1 X174.76 Y157.461 E.02485
G1 X175.24 Y157.942 E.02572
G1 X175.24 Y158.598 E.02485
G1 X174.76 Y158.118 E.02572
G1 X174.76 Y158.775 E.02485
G1 X175.24 Y159.255 E.02572
G1 X175.24 Y159.912 E.02485
G1 X174.76 Y159.431 E.02572
G1 X174.76 Y160.088 E.02485
G1 X175.24 Y160.569 E.02572
G1 X175.24 Y161.225 E.02485
G1 X174.76 Y160.745 E.02572
G1 X174.76 Y161.402 E.02485
G1 X175.24 Y161.882 E.02572
G1 X175.24 Y162.539 E.02485
G1 X174.76 Y162.058 E.02572
G1 X174.76 Y162.715 E.02485
G1 X175.24 Y163.196 E.02572
G1 X175.24 Y163.852 E.02485
G1 X174.76 Y163.372 E.02572
G1 X174.76 Y164.028 E.02485
G1 X175.24 Y164.509 E.02572
G1 X175.24 Y165.166 E.02485
G1 X174.76 Y164.685 E.02572
G1 X174.76 Y165.342 E.02485
G1 X175.24 Y165.822 E.02572
G1 X175.24 Y166.479 E.02485
G1 X174.76 Y165.999 E.02572
G1 X174.76 Y166.655 E.02485
G1 X175.24 Y167.136 E.02572
G1 X175.24 Y167.793 E.02485
G1 X174.554 Y167.106 E.03672
; CHANGE_LAYER
; Z_HEIGHT: 0.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F6300
G1 X175.24 Y167.793 E-.36879
G1 X175.24 Y167.136 E-.24956
G1 X174.977 Y166.872 E-.14165
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 2/109
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
G3 Z.6 I1.214 J.079 P1  F60000
G1 X175.984 Y151.416 Z.6
G1 Z.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1837
M204 S8000
G1 X175.984 Y168.584 E.56948
G1 X174.016 Y168.584 E.06527
G1 X174.016 Y151.416 E.56948
G1 X175.924 Y151.416 E.06328
M204 S10000
G1 X176.391 Y151.009 F60000
G1 F1837
M204 S8000
G1 X176.391 Y168.991 E.59649
G1 X173.609 Y168.991 E.09228
G1 X173.609 Y151.009 E.59649
G1 X176.331 Y151.009 E.09029
M204 S10000
M73 P36 R10
G1 X176.798 Y150.602 F60000
G1 F1837
M204 S8000
G1 X176.798 Y169.398 E.62349
G1 X173.202 Y169.398 E.11928
G1 X173.202 Y150.602 E.62349
G1 X176.738 Y150.602 E.11729
M204 S250
G1 X177.19 Y150.21 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1837
M204 S5000
G1 X177.19 Y169.79 E.60164
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X172.81 Y169.79 E.13459
G1 X172.81 Y150.21 E.60164
G1 X177.13 Y150.21 E.13274
; WIPE_START
G1 F9547.055
M204 S8000
G1 X177.136 Y152.21 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.592 Y152.4 Z.8 F60000
G1 Z.4
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F1837
M204 S8000
G1 X175.592 Y151.808 E.01818
G1 X174.408 Y151.808 E.03636
G1 X174.408 Y168.192 E.50341
G1 X175.592 Y168.192 E.03636
G1 X175.592 Y152.46 E.48338
M204 S10000
G1 X175.202 Y152.4 F60000
; LINE_WIDTH: 0.44612
G1 F1837
M204 S8000
G1 X175.202 Y152.198 E.00662
G1 X174.798 Y152.198 E.01325
G1 X174.798 Y167.802 E.51265
G1 X175.202 Y167.802 E.01325
G1 X175.202 Y152.46 E.50406
; CHANGE_LAYER
; Z_HEIGHT: 0.6
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F8928.571
G1 X175.202 Y154.46 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 3/109
; update layer progress
M73 L3
M991 S0 P2 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z.8 I1.179 J.303 P1  F60000
G1 X175.984 Y151.416 Z.8
G1 Z.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1834
M204 S8000
G1 X175.984 Y168.584 E.56948
G1 X174.016 Y168.584 E.06527
G1 X174.016 Y151.416 E.56948
G1 X175.924 Y151.416 E.06328
; COOLING_NODE: 0
M204 S10000
G1 X176.391 Y151.009 F60000
G1 F1834
M204 S8000
G1 X176.391 Y168.991 E.59649
G1 X173.609 Y168.991 E.09228
G1 X173.609 Y151.009 E.59649
G1 X176.331 Y151.009 E.09029
; COOLING_NODE: 0
M204 S10000
G1 X176.798 Y150.602 F60000
G1 F1834
M204 S8000
G1 X176.798 Y169.398 E.62349
G1 X173.202 Y169.398 E.11928
G1 X173.202 Y150.602 E.62349
G1 X176.738 Y150.602 E.11729
; COOLING_NODE: 0
M204 S250
M73 P37 R10
G1 X177.19 Y150.21 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1780
M204 S5000
G1 X177.19 Y169.79 E.60164
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X172.81 Y169.79 E.13459
G1 X172.81 Y150.21 E.60164
G1 X177.13 Y150.21 E.13274
; WIPE_START
G1 F9547.055
M204 S8000
G1 X177.136 Y152.21 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.592 Y152.4 Z1 F60000
G1 Z.6
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F1834
M204 S8000
G1 X175.592 Y151.808 E.01818
G1 X174.408 Y151.808 E.03636
G1 X174.408 Y168.192 E.50341
G1 X175.592 Y168.192 E.03636
G1 X175.592 Y152.46 E.48338
M204 S10000
G1 X175.202 Y152.4 F60000
; LINE_WIDTH: 0.44612
G1 F1834
M204 S8000
G1 X175.202 Y152.198 E.00662
G1 X174.798 Y152.198 E.01325
G1 X174.798 Y167.802 E.51265
G1 X175.202 Y167.802 E.01325
G1 X175.202 Y152.46 E.50406
; CHANGE_LAYER
; Z_HEIGHT: 0.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F8928.571
G1 X175.202 Y154.46 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 4/109
; update layer progress
M73 L4
M991 S0 P3 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z1 I1.179 J.303 P1  F60000
G1 X175.984 Y151.416 Z1
G1 Z.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1834
M204 S8000
G1 X175.984 Y168.584 E.56948
G1 X174.016 Y168.584 E.06527
G1 X174.016 Y151.416 E.56948
G1 X175.924 Y151.416 E.06328
; COOLING_NODE: 0
M204 S10000
G1 X176.391 Y151.009 F60000
G1 F1834
M204 S8000
G1 X176.391 Y168.991 E.59649
G1 X173.609 Y168.991 E.09228
G1 X173.609 Y151.009 E.59649
G1 X176.331 Y151.009 E.09029
; COOLING_NODE: 0
M204 S10000
G1 X176.798 Y150.602 F60000
G1 F1834
M204 S8000
M73 P37 R9
G1 X176.798 Y169.398 E.62349
G1 X173.202 Y169.398 E.11928
G1 X173.202 Y150.602 E.62349
G1 X176.738 Y150.602 E.11729
; COOLING_NODE: 0
M204 S250
G1 X177.19 Y150.21 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1743
M204 S5000
G1 X177.19 Y169.79 E.60164
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X172.81 Y169.79 E.13459
G1 X172.81 Y150.21 E.60164
G1 X177.13 Y150.21 E.13274
; WIPE_START
M73 P38 R9
G1 F9547.055
M204 S8000
G1 X177.136 Y152.21 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.592 Y152.4 Z1.2 F60000
G1 Z.8
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F1834
M204 S8000
G1 X175.592 Y151.808 E.01818
G1 X174.408 Y151.808 E.03636
G1 X174.408 Y168.192 E.50341
G1 X175.592 Y168.192 E.03636
G1 X175.592 Y152.46 E.48338
M204 S10000
G1 X175.202 Y152.4 F60000
; LINE_WIDTH: 0.44612
G1 F1834
M204 S8000
G1 X175.202 Y152.198 E.00662
G1 X174.798 Y152.198 E.01325
G1 X174.798 Y167.802 E.51265
G1 X175.202 Y167.802 E.01325
G1 X175.202 Y152.46 E.50406
; CHANGE_LAYER
; Z_HEIGHT: 1
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F8928.571
G1 X175.202 Y154.46 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 5/109
; update layer progress
M73 L5
M991 S0 P4 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z1.2 I1.179 J.303 P1  F60000
G1 X175.984 Y151.416 Z1.2
G1 Z1
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1834
M204 S8000
G1 X175.984 Y168.584 E.56948
G1 X174.016 Y168.584 E.06527
G1 X174.016 Y151.416 E.56948
G1 X175.924 Y151.416 E.06328
; COOLING_NODE: 0
M204 S10000
G1 X176.391 Y151.009 F60000
G1 F1834
M204 S8000
G1 X176.391 Y168.991 E.59649
G1 X173.609 Y168.991 E.09228
G1 X173.609 Y151.009 E.59649
G1 X176.331 Y151.009 E.09029
; COOLING_NODE: 0
M204 S10000
G1 X176.798 Y150.602 F60000
G1 F1834
M204 S8000
G1 X176.798 Y169.398 E.62349
G1 X173.202 Y169.398 E.11928
G1 X173.202 Y150.602 E.62349
G1 X176.738 Y150.602 E.11729
; COOLING_NODE: 0
M204 S250
G1 X177.19 Y150.21 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1720
M204 S5000
G1 X177.19 Y169.79 E.60164
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X172.81 Y169.79 E.13459
G1 X172.81 Y150.21 E.60164
G1 X177.13 Y150.21 E.13274
; WIPE_START
G1 F9547.055
M204 S8000
G1 X177.136 Y152.21 E-.76
; WIPE_END
M73 P39 R9
G1 E-.04 F1800
M204 S10000
G1 X175.592 Y152.4 Z1.4 F60000
G1 Z1
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F1834
M204 S8000
G1 X175.592 Y151.808 E.01818
G1 X174.408 Y151.808 E.03636
G1 X174.408 Y168.192 E.50341
G1 X175.592 Y168.192 E.03636
G1 X175.592 Y152.46 E.48338
M204 S10000
G1 X175.202 Y152.4 F60000
; LINE_WIDTH: 0.44612
G1 F1834
M204 S8000
G1 X175.202 Y152.198 E.00662
G1 X174.798 Y152.198 E.01325
G1 X174.798 Y167.802 E.51265
G1 X175.202 Y167.802 E.01325
G1 X175.202 Y152.46 E.50406
; CHANGE_LAYER
; Z_HEIGHT: 1.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F8928.571
G1 X175.202 Y154.46 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 6/109
; update layer progress
M73 L6
M991 S0 P5 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z1.4 I1.179 J.303 P1  F60000
G1 X175.984 Y151.416 Z1.4
G1 Z1.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1501
M204 S8000
G1 X175.984 Y168.584 E.56948
G1 X174.016 Y168.584 E.06527
G1 X174.016 Y151.416 E.56948
G1 X175.924 Y151.416 E.06328
; COOLING_NODE: 0
M204 S10000
G1 X176.391 Y151.009 F60000
G1 F1501
M204 S8000
G1 X176.391 Y168.991 E.59649
G1 X173.609 Y168.991 E.09228
G1 X173.609 Y151.009 E.59649
G1 X176.331 Y151.009 E.09029
; COOLING_NODE: 0
M204 S10000
G1 X176.798 Y150.602 F60000
G1 F1501
M204 S8000
G1 X176.798 Y169.398 E.62349
G1 X173.202 Y169.398 E.11928
G1 X173.202 Y150.602 E.62349
G1 X176.738 Y150.602 E.11729
; COOLING_NODE: 0
M204 S250
G1 X177.19 Y150.21 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1501
M204 S5000
G1 X177.19 Y169.79 E.60164
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X172.81 Y169.79 E.13459
G1 X172.81 Y150.21 E.60164
G1 X177.13 Y150.21 E.13274
; WIPE_START
G1 F9547.055
M204 S8000
G1 X177.136 Y152.21 E-.76
; WIPE_END
M73 P40 R9
G1 E-.04 F1800
M204 S10000
G1 X175.636 Y152.279 Z1.6 F60000
G1 Z1.2
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F1501
M204 S8000
G1 X175.636 Y153.908 E.05401
G3 X174.364 Y154.032 I-.773 J-1.35 E.04365
G1 X174.364 Y156.528 E.08282
G2 X175.636 Y156.652 I.773 J-1.35 E.04365
G1 X175.636 Y159.149 E.08282
G3 X174.364 Y159.273 I-.773 J-1.35 E.04365
G1 X174.364 Y161.77 E.08282
G2 X175.636 Y161.894 I.773 J-1.35 E.04365
G1 X175.636 Y164.39 E.08282
G3 X174.364 Y164.514 I-.773 J-1.35 E.04365
G1 X174.364 Y167.011 E.08282
G2 X175.636 Y167.135 I.773 J-1.35 E.04365
G1 X175.636 Y168.236 E.03651
G1 X175.108 Y168.236 E.0175
; CHANGE_LAYER
; Z_HEIGHT: 1.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F8843.478
G1 X175.636 Y168.236 E-.20052
G1 X175.636 Y167.135 E-.41824
G1 X175.266 Y167.179 E-.14124
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 7/109
; update layer progress
M73 L7
M991 S0 P6 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z1.6 I1.216 J.055 P1  F60000
G1 X175.984 Y151.416 Z1.6
G1 Z1.4
G1 E.8 F1800
; FEATURE: Inner wall
G1 F1840
M204 S8000
G1 X175.984 Y168.584 E.56948
G1 X174.016 Y168.584 E.06527
G1 X174.016 Y151.416 E.56948
G1 X175.924 Y151.416 E.06328
; COOLING_NODE: 0
M204 S10000
G1 X176.391 Y151.009 F60000
G1 F1840
M204 S8000
G1 X176.391 Y168.991 E.59649
G1 X173.609 Y168.991 E.09228
G1 X173.609 Y151.009 E.59649
G1 X176.331 Y151.009 E.09029
; COOLING_NODE: 0
M204 S10000
G1 X176.798 Y150.602 F60000
G1 F1840
M204 S8000
G1 X176.798 Y169.398 E.62349
G1 X173.202 Y169.398 E.11928
G1 X173.202 Y150.602 E.62349
G1 X176.738 Y150.602 E.11729
; COOLING_NODE: 0
M204 S250
G1 X177.19 Y150.21 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1710
M204 S5000
G1 X177.19 Y169.79 E.60164
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X172.81 Y169.79 E.13459
G1 X172.81 Y150.21 E.60164
G1 X177.13 Y150.21 E.13274
; WIPE_START
G1 F9547.055
M204 S8000
G1 X177.136 Y152.21 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X176.402 Y159.807 Z1.8 F60000
G1 X175.592 Y168.192 Z1.8
G1 Z1.4
G1 E.8 F1800
; FEATURE: Floating vertical shell
; LINE_WIDTH: 0.41999
G1 F1840
M204 S8000
G1 X175.592 Y151.808 E.50341
G1 X174.408 Y151.808 E.03636
G1 X174.408 Y168.192 E.50341
G1 X175.532 Y168.192 E.03452
M204 S10000
G1 X175.202 Y152.4 F60000
; LINE_WIDTH: 0.44612
G1 F1840
M204 S8000
G1 X175.202 Y152.198 E.00662
G1 X174.798 Y152.198 E.01325
G1 X174.798 Y167.802 E.51265
G1 X175.202 Y167.802 E.01325
G1 X175.202 Y152.46 E.50406
; CHANGE_LAYER
; Z_HEIGHT: 1.6
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F8928.571
G1 X175.202 Y154.46 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 8/109
; update layer progress
M73 L8
M991 S0 P7 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
M73 P41 R9
G3 Z1.8 I1.179 J.303 P1  F60000
G1 X175.984 Y151.416 Z1.8
G1 Z1.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1834
M204 S8000
G1 X175.984 Y168.584 E.56948
G1 X174.016 Y168.584 E.06527
G1 X174.016 Y151.416 E.56948
G1 X175.924 Y151.416 E.06328
; COOLING_NODE: 0
M204 S10000
G1 X176.391 Y151.009 F60000
G1 F1834
M204 S8000
G1 X176.391 Y168.991 E.59649
G1 X173.609 Y168.991 E.09228
G1 X173.609 Y151.009 E.59649
G1 X176.331 Y151.009 E.09029
; COOLING_NODE: 0
M204 S10000
G1 X176.798 Y150.602 F60000
G1 F1834
M204 S8000
G1 X176.798 Y169.398 E.62349
G1 X173.202 Y169.398 E.11928
G1 X173.202 Y150.602 E.62349
G1 X176.738 Y150.602 E.11729
; COOLING_NODE: 0
M204 S250
G1 X177.19 Y150.21 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1698
M204 S5000
G1 X177.19 Y169.79 E.60164
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X172.81 Y169.79 E.13459
G1 X172.81 Y150.21 E.60164
G1 X177.13 Y150.21 E.13274
; WIPE_START
G1 F9547.055
M204 S8000
G1 X177.136 Y152.21 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.592 Y152.4 Z2 F60000
G1 Z1.6
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F1834
M204 S8000
G1 X175.592 Y151.808 E.01818
G1 X174.408 Y151.808 E.03636
G1 X174.408 Y168.192 E.50341
G1 X175.592 Y168.192 E.03636
G1 X175.592 Y152.46 E.48338
M204 S10000
G1 X175.202 Y152.4 F60000
; LINE_WIDTH: 0.44612
G1 F1834
M204 S8000
G1 X175.202 Y152.198 E.00662
G1 X174.798 Y152.198 E.01325
G1 X174.798 Y167.802 E.51265
G1 X175.202 Y167.802 E.01325
G1 X175.202 Y152.46 E.50406
; CHANGE_LAYER
; Z_HEIGHT: 1.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F8928.571
G1 X175.202 Y154.46 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 9/109
; update layer progress
M73 L9
M991 S0 P8 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z2 I1.179 J.303 P1  F60000
G1 X175.984 Y151.416 Z2
G1 Z1.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1834
M204 S8000
G1 X175.984 Y168.584 E.56948
G1 X174.016 Y168.584 E.06527
G1 X174.016 Y151.416 E.56948
G1 X175.924 Y151.416 E.06328
; COOLING_NODE: 0
M204 S10000
G1 X176.391 Y151.009 F60000
G1 F1834
M204 S8000
M73 P42 R9
G1 X176.391 Y168.991 E.59649
G1 X173.609 Y168.991 E.09228
G1 X173.609 Y151.009 E.59649
G1 X176.331 Y151.009 E.09029
; COOLING_NODE: 0
M204 S10000
G1 X176.798 Y150.602 F60000
G1 F1834
M204 S8000
G1 X176.798 Y169.398 E.62349
G1 X173.202 Y169.398 E.11928
G1 X173.202 Y150.602 E.62349
G1 X176.738 Y150.602 E.11729
; COOLING_NODE: 0
M204 S250
G1 X177.19 Y150.21 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1659
M204 S5000
G1 X177.19 Y169.79 E.60164
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X172.81 Y169.79 E.13459
G1 X172.81 Y150.21 E.60164
G1 X177.13 Y150.21 E.13274
; WIPE_START
G1 F9547.055
M204 S8000
G1 X177.136 Y152.21 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.592 Y152.4 Z2.2 F60000
G1 Z1.8
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F1834
M204 S8000
G1 X175.592 Y151.808 E.01818
G1 X174.408 Y151.808 E.03636
G1 X174.408 Y168.192 E.50341
G1 X175.592 Y168.192 E.03636
G1 X175.592 Y152.46 E.48338
M204 S10000
G1 X175.202 Y152.4 F60000
; LINE_WIDTH: 0.44612
G1 F1834
M204 S8000
G1 X175.202 Y152.198 E.00662
G1 X174.798 Y152.198 E.01325
G1 X174.798 Y167.802 E.51265
G1 X175.202 Y167.802 E.01325
G1 X175.202 Y152.46 E.50406
; CHANGE_LAYER
; Z_HEIGHT: 2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F8928.571
G1 X175.202 Y154.46 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 10/109
; update layer progress
M73 L10
M991 S0 P9 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z2.2 I1.179 J.303 P1  F60000
G1 X175.984 Y151.416 Z2.2
G1 Z2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1834
M204 S8000
G1 X175.984 Y168.584 E.56948
G1 X174.016 Y168.584 E.06527
G1 X174.016 Y151.416 E.56948
G1 X175.924 Y151.416 E.06328
; COOLING_NODE: 0
M204 S10000
G1 X176.391 Y151.009 F60000
G1 F1834
M204 S8000
G1 X176.391 Y168.991 E.59649
G1 X173.609 Y168.991 E.09228
G1 X173.609 Y151.009 E.59649
G1 X176.331 Y151.009 E.09029
; COOLING_NODE: 0
M204 S10000
M73 P43 R9
G1 X176.798 Y150.602 F60000
G1 F1834
M204 S8000
G1 X176.798 Y169.398 E.62349
G1 X173.202 Y169.398 E.11928
G1 X173.202 Y150.602 E.62349
G1 X176.738 Y150.602 E.11729
; COOLING_NODE: 0
M204 S250
G1 X177.19 Y150.21 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1578
M204 S5000
G1 X177.19 Y169.79 E.60164
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X172.81 Y169.79 E.13459
G1 X172.81 Y150.21 E.60164
G1 X177.13 Y150.21 E.13274
; WIPE_START
G1 F9547.055
M204 S8000
G1 X177.136 Y152.21 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.592 Y152.4 Z2.4 F60000
G1 Z2
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F1834
M204 S8000
G1 X175.592 Y151.808 E.01818
G1 X174.408 Y151.808 E.03636
G1 X174.408 Y168.192 E.50341
G1 X175.592 Y168.192 E.03636
G1 X175.592 Y152.46 E.48338
M204 S10000
G1 X175.202 Y152.4 F60000
; LINE_WIDTH: 0.44612
G1 F1834
M204 S8000
G1 X175.202 Y152.198 E.00662
G1 X174.798 Y152.198 E.01325
G1 X174.798 Y167.802 E.51265
G1 X175.202 Y167.802 E.01325
G1 X175.202 Y152.46 E.50406
; CHANGE_LAYER
; Z_HEIGHT: 2.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F8928.571
G1 X175.202 Y154.46 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 11/109
; update layer progress
M73 L11
M991 S0 P10 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z2.4 I1.102 J.516 P1  F60000
G1 X177.19 Y150.21 Z2.4
G1 Z2.2
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1462
M204 S5000
G1 X177.19 Y169.79 E.60164
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X172.81 Y169.79 E.13459
G1 X172.81 Y150.21 E.60164
G1 X177.13 Y150.21 E.13274
M204 S10000
G1 X176.882 Y150.406 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.26667
G1 F2317
M204 S8000
G1 X176.882 Y169.594 E.34985
M204 S10000
G1 X176.744 Y150.812 F60000
; FEATURE: Top surface
; LINE_WIDTH: 0.42
G1 F2317
M204 S2000
G1 X176.349 Y150.417 E.01715
G1 X176.215 Y150.284
G1 X175.682 Y150.284
G1 X175.816 Y150.417
G1 X176.744 Y151.345 E.04032
G1 X176.877 Y151.479
G1 X176.877 Y152.012
G1 X176.744 Y151.879
G1 X175.283 Y150.417 E.0635
G1 X175.149 Y150.284
G1 X174.616 Y150.284
G1 X174.749 Y150.417
G1 X176.744 Y152.412 E.08667
G1 X176.877 Y152.545
G1 X176.877 Y153.079
G1 X176.744 Y152.945
G1 X174.216 Y150.417 E.10984
G1 X174.082 Y150.284
G1 X173.549 Y150.284
M73 P44 R9
G1 X173.683 Y150.417
G1 X176.744 Y153.478 E.13301
G1 X176.877 Y153.612
G1 X176.877 Y154.145
G1 X176.744 Y154.012
G1 X173.15 Y150.417 E.15619
G1 X173.016 Y150.284
G1 X172.884 Y150.685
G1 X173.017 Y150.818
G1 X176.744 Y154.545 E.16193
G1 X176.877 Y154.679
G1 X176.877 Y155.212
G1 X176.744 Y155.078
M73 P44 R8
G1 X173.017 Y151.352 E.16193
G1 X172.884 Y151.218
G1 X172.884 Y151.751
G1 X173.017 Y151.885
G1 X176.744 Y155.611 E.16193
G1 X176.877 Y155.745
G1 X176.877 Y156.278
G1 X176.744 Y156.145
G1 X173.017 Y152.418 E.16193
G1 X172.884 Y152.285
G1 X172.884 Y152.818
G1 X173.017 Y152.952
G1 X176.744 Y156.678 E.16193
G1 X176.877 Y156.812
G1 X176.877 Y157.345
G1 X176.744 Y157.211
G1 X173.017 Y153.485 E.16193
G1 X172.884 Y153.351
G1 X172.884 Y153.884
G1 X173.017 Y154.018
G1 X176.744 Y157.744 E.16193
G1 X176.877 Y157.878
G1 X176.877 Y158.411
G1 X176.744 Y158.278
G1 X173.017 Y154.551 E.16193
G1 X172.884 Y154.418
G1 X172.884 Y154.951
G1 X173.017 Y155.085
G1 X176.744 Y158.811 E.16193
G1 X176.877 Y158.945
G1 X176.877 Y159.478
G1 X176.744 Y159.344
G1 X173.017 Y155.618 E.16193
G1 X172.884 Y155.484
G1 X172.884 Y156.017
G1 X173.017 Y156.151
G1 X176.744 Y159.877 E.16193
G1 X176.877 Y160.011
G1 X176.877 Y160.544
G1 X176.744 Y160.411
G1 X173.017 Y156.684 E.16193
G1 X172.884 Y156.551
G1 X172.884 Y157.084
G1 X173.017 Y157.218
G1 X176.744 Y160.944 E.16193
G1 X176.877 Y161.078
G1 X176.877 Y161.611
G1 X176.744 Y161.477
G1 X173.017 Y157.751 E.16193
G1 X172.884 Y157.617
G1 X172.884 Y158.15
G1 X173.017 Y158.284
G1 X176.744 Y162.01 E.16193
G1 X176.877 Y162.144
G1 X176.877 Y162.677
G1 X176.744 Y162.544
G1 X173.017 Y158.817 E.16193
G1 X172.884 Y158.684
G1 X172.884 Y159.217
G1 X173.017 Y159.351
G1 X176.744 Y163.077 E.16193
G1 X176.877 Y163.211
G1 X176.877 Y163.744
G1 X176.744 Y163.61
G1 X173.017 Y159.884 E.16193
G1 X172.884 Y159.75
G1 X172.884 Y160.283
G1 X173.017 Y160.417
G1 X176.744 Y164.144 E.16193
G1 X176.877 Y164.277
G1 X176.877 Y164.81
G1 X176.744 Y164.677
G1 X173.017 Y160.95 E.16193
G1 X172.884 Y160.817
G1 X172.884 Y161.35
G1 X173.017 Y161.484
G1 X176.744 Y165.21 E.16193
G1 X176.877 Y165.344
G1 X176.877 Y165.877
G1 X176.744 Y165.743
G1 X173.017 Y162.017 E.16193
G1 X172.884 Y161.883
G1 X172.884 Y162.417
G1 X173.017 Y162.55
G1 X176.744 Y166.277 E.16193
G1 X176.877 Y166.41
G1 X176.877 Y166.943
G1 X176.744 Y166.81
G1 X173.017 Y163.083 E.16193
G1 X172.884 Y162.95
G1 X172.884 Y163.483
G1 X173.017 Y163.617
G1 X176.744 Y167.343 E.16193
G1 X176.877 Y167.477
G1 X176.877 Y168.01
G1 X176.744 Y167.876
G1 X173.017 Y164.15 E.16193
G1 X172.884 Y164.016
G1 X172.884 Y164.55
G1 X173.017 Y164.683
G1 X176.744 Y168.41 E.16193
G1 X176.877 Y168.543
G1 X176.877 Y169.076
G1 X176.744 Y168.943
G1 X173.017 Y165.216 E.16193
G1 X172.884 Y165.083
G1 X172.884 Y165.616
G1 X173.017 Y165.75
G1 X176.744 Y169.476 E.16193
G1 X176.877 Y169.61
G1 X176.451 Y169.716
G1 X176.317 Y169.583
G1 X173.017 Y166.283 E.14339
G1 X172.884 Y166.149
G1 X172.884 Y166.683
G1 X173.017 Y166.816
G1 X175.784 Y169.583 E.12021
G1 X175.917 Y169.716
G1 X175.384 Y169.716
G1 X175.251 Y169.583
G1 X173.017 Y167.349 E.09704
G1 X172.884 Y167.216
G1 X172.884 Y167.749
G1 X173.017 Y167.883
G1 X174.717 Y169.583 E.07387
G1 X174.851 Y169.716
G1 X174.318 Y169.716
G1 X174.184 Y169.583
G1 X173.017 Y168.416 E.0507
G1 X172.884 Y168.282
G1 X172.884 Y168.816
G1 X173.017 Y168.949
G1 X173.651 Y169.583 E.02752
; CHANGE_LAYER
; Z_HEIGHT: 2.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9547.055
M204 S8000
G1 X173.017 Y168.949 E-.34039
G1 X172.884 Y168.816 E-.07182
G1 X172.884 Y168.282 E-.20264
G1 X173.017 Y168.416 E-.07182
G1 X173.154 Y168.552 E-.07334
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 12/109
; update layer progress
M73 L12
M991 S0 P11 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z2.6 I1.202 J.191 P1  F60000
G1 X176.002 Y150.602 Z2.6
G1 Z2.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X176.798 Y150.602 E.0264
G1 X176.798 Y169.398 E.62349
G1 X176.002 Y169.398 E.0264
G1 X176.002 Y150.662 E.6215
; COOLING_NODE: 0
M204 S250
G1 X175.61 Y150.21 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X177.19 Y150.21 E.04855
G1 X177.19 Y169.79 E.60164
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X175.61 Y169.79 E.04855
G1 X175.61 Y150.27 E.5998
M204 S10000
G1 X176.4 Y150.806 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1200
M204 S8000
M73 P45 R8
G1 X176.4 Y169.194 E.5826
; CHANGE_LAYER
; Z_HEIGHT: 2.6
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.259
G1 X176.4 Y167.194 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 13/109
; update layer progress
M73 L13
M991 S0 P12 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z2.8 I1.217 J-.029 P1  F60000
G1 X176.002 Y150.602 Z2.8
G1 Z2.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X176.798 Y150.602 E.0264
G1 X176.798 Y169.398 E.62349
G1 X176.002 Y169.398 E.0264
G1 X176.002 Y150.662 E.6215
; COOLING_NODE: 0
M204 S250
G1 X175.61 Y150.21 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X177.19 Y150.21 E.04855
G1 X177.19 Y169.79 E.60164
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X175.61 Y169.79 E.04855
G1 X175.61 Y150.27 E.5998
M204 S10000
G1 X176.4 Y150.806 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1200
M204 S8000
G1 X176.4 Y169.194 E.5826
; CHANGE_LAYER
; Z_HEIGHT: 2.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.259
G1 X176.4 Y167.194 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 14/109
; update layer progress
M73 L14
M991 S0 P13 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z3 I1.217 J-.029 P1  F60000
G1 X176.002 Y150.602 Z3
G1 Z2.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X176.798 Y150.602 E.0264
G1 X176.798 Y169.398 E.62349
G1 X176.002 Y169.398 E.0264
G1 X176.002 Y150.662 E.6215
; COOLING_NODE: 0
M204 S250
G1 X175.61 Y150.21 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X177.19 Y150.21 E.04855
G1 X177.19 Y169.79 E.60164
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X175.61 Y169.79 E.04855
G1 X175.61 Y150.27 E.5998
M204 S10000
G1 X176.4 Y150.806 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
M73 P46 R8
G1 F1200
M204 S8000
G1 X176.4 Y169.194 E.5826
; CHANGE_LAYER
; Z_HEIGHT: 3
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.259
G1 X176.4 Y167.194 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 15/109
; update layer progress
M73 L15
M991 S0 P14 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z3.2 I1.217 J-.029 P1  F60000
G1 X176.002 Y150.602 Z3.2
G1 Z3
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X176.798 Y150.602 E.0264
G1 X176.798 Y169.398 E.62349
G1 X176.002 Y169.398 E.0264
G1 X176.002 Y150.662 E.6215
; COOLING_NODE: 0
M204 S250
G1 X175.61 Y150.21 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X177.19 Y150.21 E.04855
G1 X177.19 Y169.79 E.60164
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X175.61 Y169.79 E.04855
G1 X175.61 Y150.27 E.5998
M204 S10000
G1 X176.4 Y150.806 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1200
M204 S8000
G1 X176.4 Y169.194 E.5826
; CHANGE_LAYER
; Z_HEIGHT: 3.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.259
G1 X176.4 Y167.194 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 16/109
; update layer progress
M73 L16
M991 S0 P15 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z3.4 I1.217 J-.029 P1  F60000
G1 X176.002 Y150.602 Z3.4
G1 Z3.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X176.798 Y150.602 E.0264
G1 X176.798 Y169.398 E.62349
G1 X176.002 Y169.398 E.0264
G1 X176.002 Y150.662 E.6215
; COOLING_NODE: 0
M204 S250
G1 X175.61 Y150.21 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X177.19 Y150.21 E.04855
M73 P47 R8
G1 X177.19 Y169.79 E.60164
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X175.61 Y169.79 E.04855
G1 X175.61 Y150.27 E.5998
M204 S10000
G1 X176.4 Y150.806 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1200
M204 S8000
G1 X176.4 Y169.194 E.5826
; CHANGE_LAYER
; Z_HEIGHT: 3.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.259
G1 X176.4 Y167.194 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 17/109
; update layer progress
M73 L17
M991 S0 P16 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z3.6 I1.217 J-.029 P1  F60000
G1 X176.002 Y150.602 Z3.6
G1 Z3.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X176.798 Y150.602 E.0264
G1 X176.798 Y169.398 E.62349
G1 X176.002 Y169.398 E.0264
G1 X176.002 Y150.662 E.6215
; COOLING_NODE: 0
M204 S250
G1 X175.61 Y150.21 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X177.19 Y150.21 E.04855
G1 X177.19 Y169.79 E.60164
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X175.61 Y169.79 E.04855
G1 X175.61 Y150.27 E.5998
M204 S10000
G1 X176.4 Y150.806 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1200
M204 S8000
G1 X176.4 Y169.194 E.5826
; CHANGE_LAYER
; Z_HEIGHT: 3.6
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.259
G1 X176.4 Y167.194 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 18/109
; update layer progress
M73 L18
M991 S0 P17 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z3.8 I1.217 J-.029 P1  F60000
G1 X176.002 Y150.602 Z3.8
G1 Z3.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X176.798 Y150.602 E.0264
G1 X176.798 Y169.398 E.62349
G1 X176.002 Y169.398 E.0264
G1 X176.002 Y150.662 E.6215
; COOLING_NODE: 0
M204 S250
G1 X175.61 Y150.21 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
M73 P48 R8
G1 F1200
M204 S5000
G1 X177.19 Y150.21 E.04855
G1 X177.19 Y169.79 E.60164
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X175.61 Y169.79 E.04855
G1 X175.61 Y150.27 E.5998
M204 S10000
G1 X176.4 Y150.806 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1200
M204 S8000
G1 X176.4 Y169.194 E.5826
; CHANGE_LAYER
; Z_HEIGHT: 3.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.259
G1 X176.4 Y167.194 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 19/109
; update layer progress
M73 L19
M991 S0 P18 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z4 I1.217 J-.029 P1  F60000
G1 X176.002 Y150.602 Z4
G1 Z3.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X176.798 Y150.602 E.0264
G1 X176.798 Y169.398 E.62349
G1 X176.002 Y169.398 E.0264
G1 X176.002 Y150.662 E.6215
; COOLING_NODE: 0
M204 S250
G1 X175.61 Y150.21 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X177.19 Y150.21 E.04855
G1 X177.19 Y169.79 E.60164
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X175.61 Y169.79 E.04855
G1 X175.61 Y150.27 E.5998
M204 S10000
G1 X176.4 Y150.806 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1200
M204 S8000
G1 X176.4 Y169.194 E.5826
; CHANGE_LAYER
; Z_HEIGHT: 4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.259
G1 X176.4 Y167.194 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 20/109
; update layer progress
M73 L20
M991 S0 P19 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
M73 P49 R8
G3 Z4.2 I1.217 J-.029 P1  F60000
G1 X176.002 Y150.602 Z4.2
G1 Z4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X176.798 Y150.602 E.0264
G1 X176.798 Y169.398 E.62349
G1 X176.002 Y169.398 E.0264
G1 X176.002 Y150.662 E.6215
; COOLING_NODE: 0
M204 S250
G1 X175.61 Y150.21 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X177.19 Y150.21 E.04855
G1 X177.19 Y169.79 E.60164
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X175.61 Y169.79 E.04855
G1 X175.61 Y150.27 E.5998
M204 S10000
G1 X176.4 Y150.806 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1200
M204 S8000
G1 X176.4 Y169.194 E.5826
; CHANGE_LAYER
; Z_HEIGHT: 4.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.259
G1 X176.4 Y167.194 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 21/109
; update layer progress
M73 L21
M991 S0 P20 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z4.4 I1.217 J-.029 P1  F60000
G1 X176.002 Y150.602 Z4.4
G1 Z4.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X176.798 Y150.602 E.0264
G1 X176.798 Y169.398 E.62349
G1 X176.002 Y169.398 E.0264
G1 X176.002 Y150.662 E.6215
; COOLING_NODE: 0
M204 S250
G1 X175.61 Y150.21 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X177.19 Y150.21 E.04855
G1 X177.19 Y169.79 E.60164
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X175.61 Y169.79 E.04855
G1 X175.61 Y150.27 E.5998
M204 S10000
G1 X176.4 Y150.806 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1200
M204 S8000
G1 X176.4 Y169.194 E.5826
; CHANGE_LAYER
; Z_HEIGHT: 4.4
; LAYER_HEIGHT: 0.2
; WIPE_START
M73 P50 R8
G1 F9259.259
G1 X176.4 Y167.194 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 22/109
; update layer progress
M73 L22
M991 S0 P21 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z4.6 I1.217 J-.029 P1  F60000
G1 X176.002 Y150.602 Z4.6
G1 Z4.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X176.798 Y150.602 E.0264
G1 X176.798 Y169.398 E.62349
G1 X176.002 Y169.398 E.0264
G1 X176.002 Y150.662 E.6215
; COOLING_NODE: 0
M204 S250
G1 X175.61 Y150.21 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X177.19 Y150.21 E.04855
M73 P50 R7
G1 X177.19 Y169.79 E.60164
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X175.61 Y169.79 E.04855
G1 X175.61 Y150.27 E.5998
M204 S10000
G1 X176.4 Y150.806 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1200
M204 S8000
G1 X176.4 Y169.194 E.5826
; CHANGE_LAYER
; Z_HEIGHT: 4.6
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.259
G1 X176.4 Y167.194 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 23/109
; update layer progress
M73 L23
M991 S0 P22 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z4.8 I1.217 J-.029 P1  F60000
G1 X176.002 Y150.602 Z4.8
G1 Z4.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X176.798 Y150.602 E.0264
G1 X176.798 Y169.398 E.62349
G1 X176.002 Y169.398 E.0264
G1 X176.002 Y150.662 E.6215
; COOLING_NODE: 0
M204 S250
G1 X175.61 Y150.21 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X177.19 Y150.21 E.04855
G1 X177.19 Y169.79 E.60164
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X175.61 Y169.79 E.04855
G1 X175.61 Y150.27 E.5998
M204 S10000
G1 X176.4 Y150.806 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
M73 P51 R7
G1 F1200
M204 S8000
G1 X176.4 Y169.194 E.5826
; CHANGE_LAYER
; Z_HEIGHT: 4.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.259
G1 X176.4 Y167.194 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 24/109
; update layer progress
M73 L24
M991 S0 P23 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z5 I1.217 J-.029 P1  F60000
G1 X176.002 Y150.602 Z5
G1 Z4.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X176.798 Y150.602 E.0264
G1 X176.798 Y169.398 E.62349
G1 X176.002 Y169.398 E.0264
G1 X176.002 Y150.662 E.6215
; COOLING_NODE: 0
M204 S250
G1 X175.61 Y150.21 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X177.19 Y150.21 E.04855
G1 X177.19 Y169.79 E.60164
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X175.61 Y169.79 E.04855
G1 X175.61 Y150.27 E.5998
M204 S10000
G1 X176.4 Y150.806 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1200
M204 S8000
G1 X176.4 Y169.194 E.5826
; CHANGE_LAYER
; Z_HEIGHT: 5
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.259
G1 X176.4 Y167.194 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 25/109
; update layer progress
M73 L25
M991 S0 P24 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z5.2 I1.217 J-.029 P1  F60000
G1 X176.002 Y150.602 Z5.2
G1 Z5
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X176.798 Y150.602 E.0264
G1 X176.798 Y169.398 E.62349
G1 X176.002 Y169.398 E.0264
G1 X176.002 Y150.662 E.6215
; COOLING_NODE: 0
M204 S250
G1 X175.61 Y150.21 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X177.19 Y150.21 E.04855
M73 P52 R7
G1 X177.19 Y169.79 E.60164
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X175.61 Y169.79 E.04855
G1 X175.61 Y150.27 E.5998
M204 S10000
G1 X176.4 Y150.806 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1200
M204 S8000
G1 X176.4 Y169.194 E.5826
; CHANGE_LAYER
; Z_HEIGHT: 5.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.259
G1 X176.4 Y167.194 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 26/109
; update layer progress
M73 L26
M991 S0 P25 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z5.4 I1.217 J-.029 P1  F60000
G1 X176.002 Y150.602 Z5.4
G1 Z5.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X176.798 Y150.602 E.0264
G1 X176.798 Y169.398 E.62349
G1 X176.002 Y169.398 E.0264
G1 X176.002 Y150.662 E.6215
; COOLING_NODE: 0
M204 S250
G1 X175.61 Y150.21 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X177.19 Y150.21 E.04855
G1 X177.19 Y169.79 E.60164
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X175.61 Y169.79 E.04855
G1 X175.61 Y150.27 E.5998
M204 S10000
G1 X176.4 Y150.806 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1200
M204 S8000
G1 X176.4 Y169.194 E.5826
; CHANGE_LAYER
; Z_HEIGHT: 5.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.259
G1 X176.4 Y167.194 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 27/109
; update layer progress
M73 L27
M991 S0 P26 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z5.6 I1.217 J-.029 P1  F60000
G1 X176.002 Y150.602 Z5.6
G1 Z5.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X176.798 Y150.602 E.0264
G1 X176.798 Y169.398 E.62349
G1 X176.002 Y169.398 E.0264
G1 X176.002 Y150.662 E.6215
; COOLING_NODE: 0
M204 S250
G1 X175.61 Y150.21 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
M73 P53 R7
G1 F1200
M204 S5000
G1 X177.19 Y150.21 E.04855
G1 X177.19 Y169.79 E.60164
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X175.61 Y169.79 E.04855
G1 X175.61 Y150.27 E.5998
M204 S10000
G1 X176.4 Y150.806 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1200
M204 S8000
G1 X176.4 Y169.194 E.5826
; CHANGE_LAYER
; Z_HEIGHT: 5.6
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.259
G1 X176.4 Y167.194 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 28/109
; update layer progress
M73 L28
M991 S0 P27 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z5.8 I1.217 J-.029 P1  F60000
G1 X176.002 Y150.602 Z5.8
G1 Z5.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X176.798 Y150.602 E.0264
G1 X176.798 Y169.398 E.62349
G1 X176.002 Y169.398 E.0264
G1 X176.002 Y150.662 E.6215
; COOLING_NODE: 0
M204 S250
G1 X175.61 Y150.21 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X177.19 Y150.21 E.04855
G1 X177.19 Y169.79 E.60164
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X175.61 Y169.79 E.04855
G1 X175.61 Y150.27 E.5998
M204 S10000
G1 X176.4 Y150.806 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1200
M204 S8000
G1 X176.4 Y169.194 E.5826
; CHANGE_LAYER
; Z_HEIGHT: 5.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.259
G1 X176.4 Y167.194 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 29/109
; update layer progress
M73 L29
M991 S0 P28 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z6 I1.217 J-.029 P1  F60000
G1 X176.002 Y150.602 Z6
G1 Z5.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X176.798 Y150.602 E.0264
G1 X176.798 Y169.398 E.62349
G1 X176.002 Y169.398 E.0264
G1 X176.002 Y150.662 E.6215
; COOLING_NODE: 0
M204 S250
M73 P54 R7
G1 X175.61 Y150.21 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X177.19 Y150.21 E.04855
G1 X177.19 Y169.79 E.60164
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X175.61 Y169.79 E.04855
G1 X175.61 Y150.27 E.5998
M204 S10000
G1 X176.4 Y150.806 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1200
M204 S8000
G1 X176.4 Y169.194 E.5826
; CHANGE_LAYER
; Z_HEIGHT: 6
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.259
G1 X176.4 Y167.194 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 30/109
; update layer progress
M73 L30
M991 S0 P29 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z6.2 I1.217 J-.029 P1  F60000
G1 X176.002 Y150.602 Z6.2
G1 Z6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X176.798 Y150.602 E.0264
G1 X176.798 Y169.398 E.62349
G1 X176.002 Y169.398 E.0264
G1 X176.002 Y150.662 E.6215
; COOLING_NODE: 0
M204 S250
G1 X175.61 Y150.21 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X177.19 Y150.21 E.04855
G1 X177.19 Y169.79 E.60164
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X175.61 Y169.79 E.04855
G1 X175.61 Y150.27 E.5998
M204 S10000
G1 X176.4 Y150.806 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1200
M204 S8000
G1 X176.4 Y169.194 E.5826
; CHANGE_LAYER
; Z_HEIGHT: 6.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.259
G1 X176.4 Y167.194 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 31/109
; update layer progress
M73 L31
M991 S0 P30 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
M73 P55 R7
G3 Z6.4 I1.217 J-.029 P1  F60000
G1 X176.002 Y150.602 Z6.4
G1 Z6.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X176.798 Y150.602 E.0264
G1 X176.798 Y169.398 E.62349
G1 X176.002 Y169.398 E.0264
G1 X176.002 Y150.662 E.6215
; COOLING_NODE: 0
M204 S250
G1 X175.61 Y150.21 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X177.19 Y150.21 E.04855
G1 X177.19 Y169.79 E.60164
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X175.61 Y169.79 E.04855
G1 X175.61 Y150.27 E.5998
M204 S10000
G1 X176.4 Y150.806 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1200
M204 S8000
G1 X176.4 Y169.194 E.5826
; CHANGE_LAYER
; Z_HEIGHT: 6.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.259
G1 X176.4 Y167.194 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 32/109
; update layer progress
M73 L32
M991 S0 P31 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z6.6 I1.217 J-.029 P1  F60000
G1 X176.002 Y150.602 Z6.6
G1 Z6.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X176.798 Y150.602 E.0264
G1 X176.798 Y169.398 E.62349
G1 X176.002 Y169.398 E.0264
G1 X176.002 Y150.662 E.6215
; COOLING_NODE: 0
M204 S250
G1 X175.61 Y150.21 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X177.19 Y150.21 E.04855
G1 X177.19 Y169.79 E.60164
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X175.61 Y169.79 E.04855
G1 X175.61 Y150.27 E.5998
M204 S10000
G1 X176.4 Y150.806 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1200
M204 S8000
G1 X176.4 Y169.194 E.5826
; CHANGE_LAYER
; Z_HEIGHT: 6.6
; LAYER_HEIGHT: 0.2
; WIPE_START
M73 P56 R7
G1 F9259.259
G1 X176.4 Y167.194 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 33/109
; update layer progress
M73 L33
M991 S0 P32 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z6.8 I1.217 J-.029 P1  F60000
G1 X176.002 Y150.602 Z6.8
G1 Z6.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X176.798 Y150.602 E.0264
G1 X176.798 Y169.398 E.62349
G1 X176.002 Y169.398 E.0264
G1 X176.002 Y150.662 E.6215
; COOLING_NODE: 0
M204 S250
G1 X175.61 Y150.21 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X177.19 Y150.21 E.04855
G1 X177.19 Y169.79 E.60164
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X175.61 Y169.79 E.04855
G1 X175.61 Y150.27 E.5998
M204 S10000
G1 X176.4 Y150.806 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
M73 P56 R6
G1 F1200
M204 S8000
G1 X176.4 Y169.194 E.5826
; CHANGE_LAYER
; Z_HEIGHT: 6.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.259
G1 X176.4 Y167.194 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 34/109
; update layer progress
M73 L34
M991 S0 P33 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z7 I1.217 J-.029 P1  F60000
G1 X176.002 Y150.602 Z7
G1 Z6.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X176.798 Y150.602 E.0264
G1 X176.798 Y169.398 E.62349
G1 X176.002 Y169.398 E.0264
G1 X176.002 Y150.662 E.6215
; COOLING_NODE: 0
M204 S250
G1 X175.61 Y150.21 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X177.19 Y150.21 E.04855
G1 X177.19 Y169.79 E.60164
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X175.61 Y169.79 E.04855
G1 X175.61 Y150.27 E.5998
M204 S10000
G1 X176.4 Y150.806 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
M73 P57 R6
G1 F1200
M204 S8000
G1 X176.4 Y169.194 E.5826
; CHANGE_LAYER
; Z_HEIGHT: 7
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.259
G1 X176.4 Y167.194 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 35/109
; update layer progress
M73 L35
M991 S0 P34 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z7.2 I1.217 J-.029 P1  F60000
G1 X176.002 Y150.602 Z7.2
G1 Z7
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X176.798 Y150.602 E.0264
G1 X176.798 Y169.398 E.62349
G1 X176.002 Y169.398 E.0264
G1 X176.002 Y150.662 E.6215
; COOLING_NODE: 0
M204 S250
G1 X175.61 Y150.21 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X177.19 Y150.21 E.04855
G1 X177.19 Y169.79 E.60164
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X175.61 Y169.79 E.04855
G1 X175.61 Y150.27 E.5998
M204 S10000
G1 X176.4 Y150.806 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1200
M204 S8000
G1 X176.4 Y169.194 E.5826
; CHANGE_LAYER
; Z_HEIGHT: 7.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.259
G1 X176.4 Y167.194 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 36/109
; update layer progress
M73 L36
M991 S0 P35 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z7.4 I1.217 J-.029 P1  F60000
G1 X176.002 Y150.602 Z7.4
G1 Z7.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X176.798 Y150.602 E.0264
G1 X176.798 Y169.398 E.62349
G1 X176.002 Y169.398 E.0264
G1 X176.002 Y150.662 E.6215
; COOLING_NODE: 0
M204 S250
G1 X175.61 Y150.21 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X177.19 Y150.21 E.04855
M73 P58 R6
G1 X177.19 Y169.79 E.60164
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X175.61 Y169.79 E.04855
G1 X175.61 Y150.27 E.5998
M204 S10000
G1 X176.4 Y150.806 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1200
M204 S8000
G1 X176.4 Y169.194 E.5826
; CHANGE_LAYER
; Z_HEIGHT: 7.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.259
G1 X176.4 Y167.194 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 37/109
; update layer progress
M73 L37
M991 S0 P36 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z7.6 I1.217 J-.029 P1  F60000
G1 X176.002 Y150.602 Z7.6
G1 Z7.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X176.798 Y150.602 E.0264
G1 X176.798 Y169.398 E.62349
G1 X176.002 Y169.398 E.0264
G1 X176.002 Y150.662 E.6215
; COOLING_NODE: 0
M204 S250
G1 X175.61 Y150.21 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X177.19 Y150.21 E.04855
G1 X177.19 Y169.79 E.60164
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X175.61 Y169.79 E.04855
G1 X175.61 Y150.27 E.5998
M204 S10000
G1 X176.4 Y150.806 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1200
M204 S8000
G1 X176.4 Y169.194 E.5826
; CHANGE_LAYER
; Z_HEIGHT: 7.6
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.259
G1 X176.4 Y167.194 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 38/109
; update layer progress
M73 L38
M991 S0 P37 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z7.8 I1.217 J-.029 P1  F60000
G1 X176.002 Y150.602 Z7.8
G1 Z7.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X176.798 Y150.602 E.0264
G1 X176.798 Y169.398 E.62349
G1 X176.002 Y169.398 E.0264
G1 X176.002 Y150.662 E.6215
; COOLING_NODE: 0
M204 S250
G1 X175.61 Y150.21 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
M73 P59 R6
G1 F1200
M204 S5000
G1 X177.19 Y150.21 E.04855
G1 X177.19 Y169.79 E.60164
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X175.61 Y169.79 E.04855
G1 X175.61 Y150.27 E.5998
M204 S10000
G1 X176.4 Y150.806 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1200
M204 S8000
G1 X176.4 Y169.194 E.5826
; CHANGE_LAYER
; Z_HEIGHT: 7.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.259
G1 X176.4 Y167.194 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 39/109
; update layer progress
M73 L39
M991 S0 P38 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z8 I1.217 J-.029 P1  F60000
G1 X176.002 Y150.602 Z8
G1 Z7.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X176.798 Y150.602 E.0264
G1 X176.798 Y169.398 E.62349
G1 X176.002 Y169.398 E.0264
G1 X176.002 Y150.662 E.6215
; COOLING_NODE: 0
M204 S250
G1 X175.61 Y150.21 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X177.19 Y150.21 E.04855
G1 X177.19 Y169.79 E.60164
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X175.61 Y169.79 E.04855
G1 X175.61 Y150.27 E.5998
M204 S10000
G1 X176.4 Y150.806 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1200
M204 S8000
G1 X176.4 Y169.194 E.5826
; CHANGE_LAYER
; Z_HEIGHT: 8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.259
G1 X176.4 Y167.194 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 40/109
; update layer progress
M73 L40
M991 S0 P39 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
M73 P60 R6
G3 Z8.2 I1.217 J-.029 P1  F60000
G1 X176.002 Y150.602 Z8.2
G1 Z8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X176.798 Y150.602 E.0264
G1 X176.798 Y169.398 E.62349
G1 X176.002 Y169.398 E.0264
G1 X176.002 Y150.662 E.6215
; COOLING_NODE: 0
M204 S250
G1 X175.61 Y150.21 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X177.19 Y150.21 E.04855
G1 X177.19 Y169.79 E.60164
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X175.61 Y169.79 E.04855
G1 X175.61 Y150.27 E.5998
M204 S10000
G1 X176.4 Y150.806 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1200
M204 S8000
G1 X176.4 Y169.194 E.5826
; CHANGE_LAYER
; Z_HEIGHT: 8.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.259
G1 X176.4 Y167.194 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 41/109
; update layer progress
M73 L41
M991 S0 P40 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z8.4 I1.217 J-.029 P1  F60000
G1 X176.002 Y150.602 Z8.4
G1 Z8.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X176.798 Y150.602 E.0264
G1 X176.798 Y169.398 E.62349
G1 X176.002 Y169.398 E.0264
G1 X176.002 Y150.662 E.6215
; COOLING_NODE: 0
M204 S250
G1 X175.61 Y150.21 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X177.19 Y150.21 E.04855
G1 X177.19 Y169.79 E.60164
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X175.61 Y169.79 E.04855
G1 X175.61 Y150.27 E.5998
M204 S10000
G1 X176.4 Y150.806 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1200
M204 S8000
G1 X176.4 Y169.194 E.5826
; CHANGE_LAYER
; Z_HEIGHT: 8.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.259
M73 P61 R6
G1 X176.4 Y167.194 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 42/109
; update layer progress
M73 L42
M991 S0 P41 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z8.6 I1.217 J-.029 P1  F60000
G1 X176.002 Y150.602 Z8.6
G1 Z8.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X176.798 Y150.602 E.0264
G1 X176.798 Y169.398 E.62349
G1 X176.002 Y169.398 E.0264
G1 X176.002 Y150.662 E.6215
; COOLING_NODE: 0
M204 S250
G1 X175.61 Y150.21 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X177.19 Y150.21 E.04855
G1 X177.19 Y169.79 E.60164
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X175.61 Y169.79 E.04855
G1 X175.61 Y150.27 E.5998
M204 S10000
G1 X176.4 Y150.806 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1200
M204 S8000
G1 X176.4 Y169.194 E.5826
; CHANGE_LAYER
; Z_HEIGHT: 8.6
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F9259.259
G1 X176.4 Y167.194 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 43/109
; update layer progress
M73 L43
M991 S0 P42 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z8.8 I1.217 J-.029 P1  F60000
G1 X176.002 Y150.602 Z8.8
G1 Z8.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X176.798 Y150.602 E.0264
G1 X176.798 Y169.398 E.62349
G1 X176.002 Y169.398 E.0264
G1 X176.002 Y150.662 E.6215
; COOLING_NODE: 0
M204 S250
G1 X175.61 Y150.21 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X177.19 Y150.21 E.04855
G1 X177.19 Y169.79 E.60164
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X175.61 Y169.79 E.04855
G1 X175.61 Y150.27 E.5998
M204 S10000
G1 X176.4 Y150.806 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1200
M204 S8000
G1 X176.4 Y169.194 E.5826
; CHANGE_LAYER
; Z_HEIGHT: 8.8
; LAYER_HEIGHT: 0.2
; WIPE_START
M73 P62 R6
G1 F9259.259
G1 X176.4 Y167.194 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 44/109
; update layer progress
M73 L44
M991 S0 P43 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z9 I1.217 J-.029 P1  F60000
G1 X176.002 Y150.602 Z9
G1 Z8.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X176.798 Y150.602 E.0264
G1 X176.798 Y169.398 E.62349
G1 X176.002 Y169.398 E.0264
G1 X176.002 Y150.662 E.6215
; COOLING_NODE: 0
M204 S250
G1 X175.61 Y150.21 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X177.19 Y150.21 E.04855
G1 X177.19 Y169.79 E.60164
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X175.61 Y169.79 E.04855
G1 X175.61 Y150.27 E.5998
M204 S10000
G1 X176.4 Y150.806 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1200
M204 S8000
G1 X176.4 Y169.194 E.5826
; CHANGE_LAYER
; Z_HEIGHT: 9
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.259
G1 X176.4 Y167.194 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 45/109
; update layer progress
M73 L45
M991 S0 P44 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
M73 P62 R5
G3 Z9.2 I1.217 J-.029 P1  F60000
G1 X176.002 Y150.602 Z9.2
G1 Z9
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X176.798 Y150.602 E.0264
G1 X176.798 Y169.398 E.62349
G1 X176.002 Y169.398 E.0264
G1 X176.002 Y150.662 E.6215
; COOLING_NODE: 0
M204 S250
G1 X175.61 Y150.21 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X177.19 Y150.21 E.04855
G1 X177.19 Y169.79 E.60164
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X175.61 Y169.79 E.04855
G1 X175.61 Y150.27 E.5998
M204 S10000
G1 X176.4 Y150.806 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
M73 P63 R5
G1 F1200
M204 S8000
G1 X176.4 Y169.194 E.5826
; CHANGE_LAYER
; Z_HEIGHT: 9.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.259
G1 X176.4 Y167.194 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 46/109
; update layer progress
M73 L46
M991 S0 P45 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z9.4 I1.217 J-.029 P1  F60000
G1 X176.002 Y150.602 Z9.4
G1 Z9.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X176.798 Y150.602 E.0264
G1 X176.798 Y169.398 E.62349
G1 X176.002 Y169.398 E.0264
G1 X176.002 Y150.662 E.6215
; COOLING_NODE: 0
M204 S250
G1 X175.61 Y150.21 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X177.19 Y150.21 E.04855
G1 X177.19 Y169.79 E.60164
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X175.61 Y169.79 E.04855
G1 X175.61 Y150.27 E.5998
M204 S10000
G1 X176.4 Y150.806 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1200
M204 S8000
G1 X176.4 Y169.194 E.5826
; CHANGE_LAYER
; Z_HEIGHT: 9.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.259
G1 X176.4 Y167.194 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 47/109
; update layer progress
M73 L47
M991 S0 P46 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z9.6 I1.217 J-.029 P1  F60000
G1 X176.002 Y150.602 Z9.6
G1 Z9.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X176.798 Y150.602 E.0264
G1 X176.798 Y169.398 E.62349
G1 X176.002 Y169.398 E.0264
G1 X176.002 Y150.662 E.6215
; COOLING_NODE: 0
M204 S250
G1 X175.61 Y150.21 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X177.19 Y150.21 E.04855
M73 P64 R5
G1 X177.19 Y169.79 E.60164
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X175.61 Y169.79 E.04855
G1 X175.61 Y150.27 E.5998
M204 S10000
G1 X176.4 Y150.806 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1200
M204 S8000
G1 X176.4 Y169.194 E.5826
; CHANGE_LAYER
; Z_HEIGHT: 9.6
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F9259.259
G1 X176.4 Y167.194 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 48/109
; update layer progress
M73 L48
M991 S0 P47 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z9.8 I1.217 J-.029 P1  F60000
G1 X176.002 Y150.602 Z9.8
G1 Z9.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X176.798 Y150.602 E.0264
G1 X176.798 Y169.398 E.62349
G1 X176.002 Y169.398 E.0264
G1 X176.002 Y150.662 E.6215
; COOLING_NODE: 0
M204 S250
G1 X175.61 Y150.21 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X177.19 Y150.21 E.04855
G1 X177.19 Y169.79 E.60164
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X175.61 Y169.79 E.04855
G1 X175.61 Y150.27 E.5998
M204 S10000
G1 X176.4 Y150.806 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1200
M204 S8000
G1 X176.4 Y169.194 E.5826
; CHANGE_LAYER
; Z_HEIGHT: 9.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.259
G1 X176.4 Y167.194 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 49/109
; update layer progress
M73 L49
M991 S0 P48 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z10 I1.217 J-.029 P1  F60000
G1 X176.002 Y150.602 Z10
G1 Z9.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X176.798 Y150.602 E.0264
G1 X176.798 Y169.398 E.62349
G1 X176.002 Y169.398 E.0264
G1 X176.002 Y150.662 E.6215
; COOLING_NODE: 0
M204 S250
G1 X175.61 Y150.21 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
M73 P65 R5
G1 F1200
M204 S5000
G1 X177.19 Y150.21 E.04855
G1 X177.19 Y169.79 E.60164
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X175.61 Y169.79 E.04855
G1 X175.61 Y150.27 E.5998
M204 S10000
G1 X176.4 Y150.806 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1200
M204 S8000
G1 X176.4 Y169.194 E.5826
; CHANGE_LAYER
; Z_HEIGHT: 10
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.259
G1 X176.4 Y167.194 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 50/109
; update layer progress
M73 L50
M991 S0 P49 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z10.2 I1.217 J-.029 P1  F60000
G1 X176.002 Y150.602 Z10.2
G1 Z10
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X176.798 Y150.602 E.0264
G1 X176.798 Y169.398 E.62349
G1 X176.002 Y169.398 E.0264
G1 X176.002 Y150.662 E.6215
; COOLING_NODE: 0
M204 S250
G1 X175.61 Y150.21 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X177.19 Y150.21 E.04855
G1 X177.19 Y169.79 E.60164
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X175.61 Y169.79 E.04855
G1 X175.61 Y150.27 E.5998
M204 S10000
G1 X176.4 Y150.806 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1200
M204 S8000
G1 X176.4 Y169.194 E.5826
; CHANGE_LAYER
; Z_HEIGHT: 10.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.259
G1 X176.4 Y167.194 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 51/109
; update layer progress
M73 L51
M991 S0 P50 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
M73 P66 R5
G3 Z10.4 I1.217 J-.029 P1  F60000
G1 X176.002 Y150.602 Z10.4
G1 Z10.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X176.798 Y150.602 E.0264
G1 X176.798 Y169.398 E.62349
G1 X176.002 Y169.398 E.0264
G1 X176.002 Y150.662 E.6215
; COOLING_NODE: 0
M204 S250
G1 X175.61 Y150.21 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X177.19 Y150.21 E.04855
G1 X177.19 Y169.79 E.60164
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X175.61 Y169.79 E.04855
G1 X175.61 Y150.27 E.5998
M204 S10000
G1 X176.4 Y150.806 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1200
M204 S8000
G1 X176.4 Y169.194 E.5826
; CHANGE_LAYER
; Z_HEIGHT: 10.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.259
G1 X176.4 Y167.194 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 52/109
; update layer progress
M73 L52
M991 S0 P51 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z10.6 I1.217 J-.029 P1  F60000
G1 X176.002 Y150.602 Z10.6
G1 Z10.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X176.798 Y150.602 E.0264
G1 X176.798 Y169.398 E.62349
G1 X176.002 Y169.398 E.0264
G1 X176.002 Y150.662 E.6215
; COOLING_NODE: 0
M204 S250
G1 X175.61 Y150.21 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X177.19 Y150.21 E.04855
G1 X177.19 Y169.79 E.60164
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X175.61 Y169.79 E.04855
G1 X175.61 Y150.27 E.5998
M204 S10000
G1 X176.4 Y150.806 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1200
M204 S8000
G1 X176.4 Y169.194 E.5826
; CHANGE_LAYER
; Z_HEIGHT: 10.6
; LAYER_HEIGHT: 0.200001
; WIPE_START
M73 P67 R5
G1 F9259.259
G1 X176.4 Y167.194 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 53/109
; update layer progress
M73 L53
M991 S0 P52 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z10.8 I1.217 J-.029 P1  F60000
G1 X176.002 Y150.602 Z10.8
G1 Z10.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X176.798 Y150.602 E.0264
G1 X176.798 Y169.398 E.62349
G1 X176.002 Y169.398 E.0264
G1 X176.002 Y150.662 E.6215
; COOLING_NODE: 0
M204 S250
G1 X175.61 Y150.21 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X177.19 Y150.21 E.04855
G1 X177.19 Y169.79 E.60164
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X175.61 Y169.79 E.04855
G1 X175.61 Y150.27 E.5998
M204 S10000
G1 X176.4 Y150.806 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1200
M204 S8000
G1 X176.4 Y169.194 E.5826
; CHANGE_LAYER
; Z_HEIGHT: 10.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.259
G1 X176.4 Y167.194 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 54/109
; update layer progress
M73 L54
M991 S0 P53 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z11 I1.217 J-.029 P1  F60000
G1 X176.002 Y150.602 Z11
G1 Z10.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X176.798 Y150.602 E.0264
G1 X176.798 Y169.398 E.62349
G1 X176.002 Y169.398 E.0264
G1 X176.002 Y150.662 E.6215
; COOLING_NODE: 0
M204 S250
G1 X175.61 Y150.21 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X177.19 Y150.21 E.04855
G1 X177.19 Y169.79 E.60164
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X175.61 Y169.79 E.04855
G1 X175.61 Y150.27 E.5998
M204 S10000
G1 X176.4 Y150.806 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
M73 P68 R5
G1 F1200
M204 S8000
G1 X176.4 Y169.194 E.5826
; CHANGE_LAYER
; Z_HEIGHT: 11
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.259
G1 X176.4 Y167.194 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 55/109
; update layer progress
M73 L55
M991 S0 P54 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z11.2 I1.217 J-.029 P1  F60000
G1 X176.002 Y150.602 Z11.2
G1 Z11
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X176.798 Y150.602 E.0264
G1 X176.798 Y169.398 E.62349
G1 X176.002 Y169.398 E.0264
G1 X176.002 Y150.662 E.6215
; COOLING_NODE: 0
M204 S250
G1 X175.61 Y150.21 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X177.19 Y150.21 E.04855
G1 X177.19 Y169.79 E.60164
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X175.61 Y169.79 E.04855
G1 X175.61 Y150.27 E.5998
M204 S10000
G1 X176.4 Y150.806 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1200
M204 S8000
G1 X176.4 Y169.194 E.5826
; CHANGE_LAYER
; Z_HEIGHT: 11.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.259
G1 X176.4 Y167.194 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 56/109
; update layer progress
M73 L56
M991 S0 P55 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z11.4 I1.217 J-.029 P1  F60000
G1 X176.002 Y150.602 Z11.4
G1 Z11.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X176.798 Y150.602 E.0264
G1 X176.798 Y169.398 E.62349
G1 X176.002 Y169.398 E.0264
G1 X176.002 Y150.662 E.6215
; COOLING_NODE: 0
M204 S250
G1 X175.61 Y150.21 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X177.19 Y150.21 E.04855
M73 P68 R4
G1 X177.19 Y169.79 E.60164
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X175.61 Y169.79 E.04855
G1 X175.61 Y150.27 E.5998
M204 S10000
M73 P69 R4
G1 X176.4 Y150.806 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1200
M204 S8000
G1 X176.4 Y169.194 E.5826
; CHANGE_LAYER
; Z_HEIGHT: 11.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.259
G1 X176.4 Y167.194 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 57/109
; update layer progress
M73 L57
M991 S0 P56 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z11.6 I1.217 J-.029 P1  F60000
G1 X176.002 Y150.602 Z11.6
G1 Z11.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X176.798 Y150.602 E.0264
G1 X176.798 Y169.398 E.62349
G1 X176.002 Y169.398 E.0264
G1 X176.002 Y150.662 E.6215
; COOLING_NODE: 0
M204 S250
G1 X175.61 Y150.21 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X177.19 Y150.21 E.04855
G1 X177.19 Y169.79 E.60164
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X175.61 Y169.79 E.04855
G1 X175.61 Y150.27 E.5998
M204 S10000
G1 X176.4 Y150.806 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1200
M204 S8000
G1 X176.4 Y169.194 E.5826
; CHANGE_LAYER
; Z_HEIGHT: 11.6
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F9259.259
G1 X176.4 Y167.194 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 58/109
; update layer progress
M73 L58
M991 S0 P57 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z11.8 I1.217 J-.029 P1  F60000
G1 X176.002 Y150.602 Z11.8
G1 Z11.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X176.798 Y150.602 E.0264
G1 X176.798 Y169.398 E.62349
G1 X176.002 Y169.398 E.0264
G1 X176.002 Y150.662 E.6215
; COOLING_NODE: 0
M204 S250
G1 X175.61 Y150.21 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X177.19 Y150.21 E.04855
M73 P70 R4
G1 X177.19 Y169.79 E.60164
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X175.61 Y169.79 E.04855
G1 X175.61 Y150.27 E.5998
M204 S10000
G1 X176.4 Y150.806 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1200
M204 S8000
G1 X176.4 Y169.194 E.5826
; CHANGE_LAYER
; Z_HEIGHT: 11.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.259
G1 X176.4 Y167.194 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 59/109
; update layer progress
M73 L59
M991 S0 P58 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z12 I1.217 J-.029 P1  F60000
G1 X176.002 Y150.602 Z12
G1 Z11.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X176.798 Y150.602 E.0264
G1 X176.798 Y169.398 E.62349
G1 X176.002 Y169.398 E.0264
G1 X176.002 Y150.662 E.6215
; COOLING_NODE: 0
M204 S250
G1 X175.61 Y150.21 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X177.19 Y150.21 E.04855
G1 X177.19 Y169.79 E.60164
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X175.61 Y169.79 E.04855
G1 X175.61 Y150.27 E.5998
M204 S10000
G1 X176.4 Y150.806 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1200
M204 S8000
G1 X176.4 Y169.194 E.5826
; CHANGE_LAYER
; Z_HEIGHT: 12
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.259
G1 X176.4 Y167.194 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 60/109
; update layer progress
M73 L60
M991 S0 P59 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z12.2 I1.217 J-.029 P1  F60000
G1 X176.002 Y150.602 Z12.2
G1 Z12
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X176.798 Y150.602 E.0264
G1 X176.798 Y169.398 E.62349
G1 X176.002 Y169.398 E.0264
G1 X176.002 Y150.662 E.6215
; COOLING_NODE: 0
M204 S250
G1 X175.61 Y150.21 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
M73 P71 R4
G1 F1200
M204 S5000
G1 X177.19 Y150.21 E.04855
G1 X177.19 Y169.79 E.60164
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X175.61 Y169.79 E.04855
G1 X175.61 Y150.27 E.5998
M204 S10000
G1 X176.4 Y150.806 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1200
M204 S8000
G1 X176.4 Y169.194 E.5826
; CHANGE_LAYER
; Z_HEIGHT: 12.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.259
G1 X176.4 Y167.194 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 61/109
; update layer progress
M73 L61
M991 S0 P60 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z12.4 I1.217 J-.029 P1  F60000
G1 X176.002 Y150.602 Z12.4
G1 Z12.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X176.798 Y150.602 E.0264
G1 X176.798 Y169.398 E.62349
G1 X176.002 Y169.398 E.0264
G1 X176.002 Y150.662 E.6215
; COOLING_NODE: 0
M204 S250
G1 X175.61 Y150.21 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X177.19 Y150.21 E.04855
G1 X177.19 Y169.79 E.60164
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X175.61 Y169.79 E.04855
G1 X175.61 Y150.27 E.5998
M204 S10000
G1 X176.4 Y150.806 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1200
M204 S8000
G1 X176.4 Y169.194 E.5826
; CHANGE_LAYER
; Z_HEIGHT: 12.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.259
G1 X176.4 Y167.194 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 62/109
; update layer progress
M73 L62
M991 S0 P61 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
M73 P72 R4
G3 Z12.6 I1.217 J-.029 P1  F60000
G1 X176.002 Y150.602 Z12.6
G1 Z12.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X176.798 Y150.602 E.0264
G1 X176.798 Y169.398 E.62349
G1 X176.002 Y169.398 E.0264
G1 X176.002 Y150.662 E.6215
; COOLING_NODE: 0
M204 S250
G1 X175.61 Y150.21 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X177.19 Y150.21 E.04855
G1 X177.19 Y169.79 E.60164
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X175.61 Y169.79 E.04855
G1 X175.61 Y150.27 E.5998
M204 S10000
G1 X176.4 Y150.806 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1200
M204 S8000
G1 X176.4 Y169.194 E.5826
; CHANGE_LAYER
; Z_HEIGHT: 12.6
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F9259.259
G1 X176.4 Y167.194 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 63/109
; update layer progress
M73 L63
M991 S0 P62 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z12.8 I1.217 J-.029 P1  F60000
G1 X176.002 Y150.602 Z12.8
G1 Z12.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X176.798 Y150.602 E.0264
G1 X176.798 Y169.398 E.62349
G1 X176.002 Y169.398 E.0264
G1 X176.002 Y150.662 E.6215
; COOLING_NODE: 0
M204 S250
G1 X175.61 Y150.21 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X177.19 Y150.21 E.04855
G1 X177.19 Y169.79 E.60164
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X175.61 Y169.79 E.04855
G1 X175.61 Y150.27 E.5998
M204 S10000
G1 X176.4 Y150.806 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1200
M204 S8000
G1 X176.4 Y169.194 E.5826
; CHANGE_LAYER
; Z_HEIGHT: 12.8
; LAYER_HEIGHT: 0.2
; WIPE_START
M73 P73 R4
G1 F9259.259
G1 X176.4 Y167.194 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 64/109
; update layer progress
M73 L64
M991 S0 P63 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z13 I1.217 J-.029 P1  F60000
G1 X176.002 Y150.602 Z13
G1 Z12.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X176.798 Y150.602 E.0264
G1 X176.798 Y169.398 E.62349
G1 X176.002 Y169.398 E.0264
G1 X176.002 Y150.662 E.6215
; COOLING_NODE: 0
M204 S250
G1 X175.61 Y150.21 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X177.19 Y150.21 E.04855
G1 X177.19 Y169.79 E.60164
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X175.61 Y169.79 E.04855
G1 X175.61 Y150.27 E.5998
M204 S10000
G1 X176.4 Y150.806 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1200
M204 S8000
G1 X176.4 Y169.194 E.5826
; CHANGE_LAYER
; Z_HEIGHT: 13
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.259
G1 X176.4 Y167.194 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 65/109
; update layer progress
M73 L65
M991 S0 P64 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z13.2 I1.217 J-.029 P1  F60000
G1 X176.002 Y150.602 Z13.2
G1 Z13
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X176.798 Y150.602 E.0264
G1 X176.798 Y169.398 E.62349
G1 X176.002 Y169.398 E.0264
G1 X176.002 Y150.662 E.6215
; COOLING_NODE: 0
M204 S250
G1 X175.61 Y150.21 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X177.19 Y150.21 E.04855
G1 X177.19 Y169.79 E.60164
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X175.61 Y169.79 E.04855
G1 X175.61 Y150.27 E.5998
M204 S10000
G1 X176.4 Y150.806 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
M73 P74 R4
G1 F1200
M204 S8000
G1 X176.4 Y169.194 E.5826
; CHANGE_LAYER
; Z_HEIGHT: 13.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.259
G1 X176.4 Y167.194 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 66/109
; update layer progress
M73 L66
M991 S0 P65 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z13.4 I1.217 J-.029 P1  F60000
G1 X176.002 Y150.602 Z13.4
G1 Z13.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X176.798 Y150.602 E.0264
G1 X176.798 Y169.398 E.62349
G1 X176.002 Y169.398 E.0264
G1 X176.002 Y150.662 E.6215
; COOLING_NODE: 0
M204 S250
G1 X175.61 Y150.21 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X177.19 Y150.21 E.04855
G1 X177.19 Y169.79 E.60164
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X175.61 Y169.79 E.04855
G1 X175.61 Y150.27 E.5998
M204 S10000
G1 X176.4 Y150.806 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1200
M204 S8000
G1 X176.4 Y169.194 E.5826
; CHANGE_LAYER
; Z_HEIGHT: 13.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.259
G1 X176.4 Y167.194 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 67/109
; update layer progress
M73 L67
M991 S0 P66 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z13.6 I1.217 J-.029 P1  F60000
G1 X176.002 Y150.602 Z13.6
G1 Z13.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X176.798 Y150.602 E.0264
G1 X176.798 Y169.398 E.62349
G1 X176.002 Y169.398 E.0264
G1 X176.002 Y150.662 E.6215
; COOLING_NODE: 0
M204 S250
G1 X175.61 Y150.21 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X177.19 Y150.21 E.04855
M73 P75 R4
G1 X177.19 Y169.79 E.60164
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X175.61 Y169.79 E.04855
G1 X175.61 Y150.27 E.5998
M204 S10000
G1 X176.4 Y150.806 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1200
M204 S8000
G1 X176.4 Y169.194 E.5826
; CHANGE_LAYER
; Z_HEIGHT: 13.6
; LAYER_HEIGHT: 0.200001
; WIPE_START
M73 P75 R3
G1 F9259.259
G1 X176.4 Y167.194 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 68/109
; update layer progress
M73 L68
M991 S0 P67 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z13.8 I1.217 J-.029 P1  F60000
G1 X176.002 Y150.602 Z13.8
G1 Z13.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X176.798 Y150.602 E.0264
G1 X176.798 Y169.398 E.62349
G1 X176.002 Y169.398 E.0264
G1 X176.002 Y150.662 E.6215
; COOLING_NODE: 0
M204 S250
G1 X175.61 Y150.21 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X177.19 Y150.21 E.04855
G1 X177.19 Y169.79 E.60164
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X175.61 Y169.79 E.04855
G1 X175.61 Y150.27 E.5998
M204 S10000
G1 X176.4 Y150.806 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1200
M204 S8000
G1 X176.4 Y169.194 E.5826
; CHANGE_LAYER
; Z_HEIGHT: 13.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.259
G1 X176.4 Y167.194 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 69/109
; update layer progress
M73 L69
M991 S0 P68 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z14 I1.217 J-.029 P1  F60000
G1 X176.002 Y150.602 Z14
G1 Z13.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X176.798 Y150.602 E.0264
G1 X176.798 Y169.398 E.62349
G1 X176.002 Y169.398 E.0264
G1 X176.002 Y150.662 E.6215
; COOLING_NODE: 0
M204 S250
G1 X175.61 Y150.21 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
M73 P76 R3
G1 F1200
M204 S5000
G1 X177.19 Y150.21 E.04855
G1 X177.19 Y169.79 E.60164
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X175.61 Y169.79 E.04855
G1 X175.61 Y150.27 E.5998
M204 S10000
G1 X176.4 Y150.806 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1200
M204 S8000
G1 X176.4 Y169.194 E.5826
; CHANGE_LAYER
; Z_HEIGHT: 14
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.259
G1 X176.4 Y167.194 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 70/109
; update layer progress
M73 L70
M991 S0 P69 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z14.2 I1.217 J-.029 P1  F60000
G1 X176.002 Y150.602 Z14.2
G1 Z14
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X176.798 Y150.602 E.0264
G1 X176.798 Y169.398 E.62349
G1 X176.002 Y169.398 E.0264
G1 X176.002 Y150.662 E.6215
; COOLING_NODE: 0
M204 S250
G1 X175.61 Y150.21 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X177.19 Y150.21 E.04855
G1 X177.19 Y169.79 E.60164
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X175.61 Y169.79 E.04855
G1 X175.61 Y150.27 E.5998
M204 S10000
G1 X176.4 Y150.806 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1200
M204 S8000
G1 X176.4 Y169.194 E.5826
; CHANGE_LAYER
; Z_HEIGHT: 14.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.259
G1 X176.4 Y167.194 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 71/109
; update layer progress
M73 L71
M991 S0 P70 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z14.4 I1.217 J-.029 P1  F60000
G1 X176.002 Y150.602 Z14.4
G1 Z14.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
M73 P77 R3
G1 X176.798 Y150.602 E.0264
G1 X176.798 Y169.398 E.62349
G1 X176.002 Y169.398 E.0264
G1 X176.002 Y150.662 E.6215
; COOLING_NODE: 0
M204 S250
G1 X175.61 Y150.21 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X177.19 Y150.21 E.04855
G1 X177.19 Y169.79 E.60164
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X175.61 Y169.79 E.04855
G1 X175.61 Y150.27 E.5998
M204 S10000
G1 X176.4 Y150.806 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1200
M204 S8000
G1 X176.4 Y169.194 E.5826
; CHANGE_LAYER
; Z_HEIGHT: 14.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.259
G1 X176.4 Y167.194 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 72/109
; update layer progress
M73 L72
M991 S0 P71 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z14.6 I1.217 J-.029 P1  F60000
G1 X176.002 Y150.602 Z14.6
G1 Z14.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X176.798 Y150.602 E.0264
G1 X176.798 Y169.398 E.62349
G1 X176.002 Y169.398 E.0264
G1 X176.002 Y150.662 E.6215
; COOLING_NODE: 0
M204 S250
G1 X175.61 Y150.21 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X177.19 Y150.21 E.04855
G1 X177.19 Y169.79 E.60164
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X175.61 Y169.79 E.04855
G1 X175.61 Y150.27 E.5998
M204 S10000
G1 X176.4 Y150.806 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1200
M204 S8000
G1 X176.4 Y169.194 E.5826
; CHANGE_LAYER
; Z_HEIGHT: 14.6
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F9259.259
G1 X176.4 Y167.194 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 73/109
; update layer progress
M73 L73
M991 S0 P72 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
M73 P78 R3
G3 Z14.8 I1.217 J-.029 P1  F60000
G1 X176.002 Y150.602 Z14.8
G1 Z14.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X176.798 Y150.602 E.0264
G1 X176.798 Y169.398 E.62349
G1 X176.002 Y169.398 E.0264
G1 X176.002 Y150.662 E.6215
; COOLING_NODE: 0
M204 S250
G1 X175.61 Y150.21 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X177.19 Y150.21 E.04855
G1 X177.19 Y169.79 E.60164
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X175.61 Y169.79 E.04855
G1 X175.61 Y150.27 E.5998
M204 S10000
G1 X176.4 Y150.806 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1200
M204 S8000
G1 X176.4 Y169.194 E.5826
; CHANGE_LAYER
; Z_HEIGHT: 14.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.259
G1 X176.4 Y167.194 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 74/109
; update layer progress
M73 L74
M991 S0 P73 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z15 I1.217 J-.029 P1  F60000
G1 X176.002 Y150.602 Z15
G1 Z14.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X176.798 Y150.602 E.0264
G1 X176.798 Y169.398 E.62349
G1 X176.002 Y169.398 E.0264
G1 X176.002 Y150.662 E.6215
; COOLING_NODE: 0
M204 S250
G1 X175.61 Y150.21 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X177.19 Y150.21 E.04855
G1 X177.19 Y169.79 E.60164
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X175.61 Y169.79 E.04855
G1 X175.61 Y150.27 E.5998
M204 S10000
G1 X176.4 Y150.806 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1200
M204 S8000
G1 X176.4 Y169.194 E.5826
; CHANGE_LAYER
; Z_HEIGHT: 15
; LAYER_HEIGHT: 0.2
; WIPE_START
M73 P79 R3
G1 F9259.259
G1 X176.4 Y167.194 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 75/109
; update layer progress
M73 L75
M991 S0 P74 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z15.2 I1.217 J-.029 P1  F60000
G1 X176.002 Y150.602 Z15.2
G1 Z15
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X176.798 Y150.602 E.0264
G1 X176.798 Y169.398 E.62349
G1 X176.002 Y169.398 E.0264
G1 X176.002 Y150.662 E.6215
; COOLING_NODE: 0
M204 S250
G1 X175.61 Y150.21 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X177.19 Y150.21 E.04855
G1 X177.19 Y169.79 E.60164
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X175.61 Y169.79 E.04855
G1 X175.61 Y150.27 E.5998
M204 S10000
G1 X176.4 Y150.806 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1200
M204 S8000
G1 X176.4 Y169.194 E.5826
; CHANGE_LAYER
; Z_HEIGHT: 15.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.259
G1 X176.4 Y167.194 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 76/109
; update layer progress
M73 L76
M991 S0 P75 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z15.4 I1.217 J-.029 P1  F60000
G1 X176.002 Y150.602 Z15.4
G1 Z15.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X176.798 Y150.602 E.0264
G1 X176.798 Y169.398 E.62349
G1 X176.002 Y169.398 E.0264
G1 X176.002 Y150.662 E.6215
; COOLING_NODE: 0
M204 S250
G1 X175.61 Y150.21 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X177.19 Y150.21 E.04855
G1 X177.19 Y169.79 E.60164
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X175.61 Y169.79 E.04855
G1 X175.61 Y150.27 E.5998
M204 S10000
G1 X176.4 Y150.806 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
M73 P80 R3
G1 F1200
M204 S8000
G1 X176.4 Y169.194 E.5826
; CHANGE_LAYER
; Z_HEIGHT: 15.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.259
G1 X176.4 Y167.194 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 77/109
; update layer progress
M73 L77
M991 S0 P76 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z15.6 I1.217 J-.029 P1  F60000
G1 X176.002 Y150.602 Z15.6
G1 Z15.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X176.798 Y150.602 E.0264
G1 X176.798 Y169.398 E.62349
G1 X176.002 Y169.398 E.0264
G1 X176.002 Y150.662 E.6215
; COOLING_NODE: 0
M204 S250
G1 X175.61 Y150.21 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X177.19 Y150.21 E.04855
G1 X177.19 Y169.79 E.60164
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X175.61 Y169.79 E.04855
G1 X175.61 Y150.27 E.5998
M204 S10000
G1 X176.4 Y150.806 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1200
M204 S8000
G1 X176.4 Y169.194 E.5826
; CHANGE_LAYER
; Z_HEIGHT: 15.6
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F9259.259
G1 X176.4 Y167.194 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 78/109
; update layer progress
M73 L78
M991 S0 P77 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z15.8 I1.217 J-.029 P1  F60000
G1 X176.002 Y150.602 Z15.8
G1 Z15.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X176.798 Y150.602 E.0264
G1 X176.798 Y169.398 E.62349
G1 X176.002 Y169.398 E.0264
G1 X176.002 Y150.662 E.6215
; COOLING_NODE: 0
M204 S250
G1 X175.61 Y150.21 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X177.19 Y150.21 E.04855
M73 P81 R3
G1 X177.19 Y169.79 E.60164
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X175.61 Y169.79 E.04855
G1 X175.61 Y150.27 E.5998
M204 S10000
G1 X176.4 Y150.806 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1200
M204 S8000
G1 X176.4 Y169.194 E.5826
; CHANGE_LAYER
; Z_HEIGHT: 15.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.259
G1 X176.4 Y167.194 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 79/109
; update layer progress
M73 L79
M991 S0 P78 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z16 I1.217 J-.029 P1  F60000
G1 X176.002 Y150.602 Z16
G1 Z15.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
M73 P81 R2
G1 X176.798 Y150.602 E.0264
G1 X176.798 Y169.398 E.62349
G1 X176.002 Y169.398 E.0264
G1 X176.002 Y150.662 E.6215
; COOLING_NODE: 0
M204 S250
G1 X175.61 Y150.21 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X177.19 Y150.21 E.04855
G1 X177.19 Y169.79 E.60164
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X175.61 Y169.79 E.04855
G1 X175.61 Y150.27 E.5998
M204 S10000
G1 X176.4 Y150.806 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1200
M204 S8000
G1 X176.4 Y169.194 E.5826
; CHANGE_LAYER
; Z_HEIGHT: 16
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F9259.259
G1 X176.4 Y167.194 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 80/109
; update layer progress
M73 L80
M991 S0 P79 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z16.2 I1.217 J-.029 P1  F60000
G1 X176.002 Y150.602 Z16.2
G1 Z16
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X176.798 Y150.602 E.0264
G1 X176.798 Y169.398 E.62349
G1 X176.002 Y169.398 E.0264
G1 X176.002 Y150.662 E.6215
; COOLING_NODE: 0
M204 S250
G1 X175.61 Y150.21 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
M73 P82 R2
G1 F1200
M204 S5000
G1 X177.19 Y150.21 E.04855
G1 X177.19 Y169.79 E.60164
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X175.61 Y169.79 E.04855
G1 X175.61 Y150.27 E.5998
M204 S10000
G1 X176.4 Y150.806 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1200
M204 S8000
G1 X176.4 Y169.194 E.5826
; CHANGE_LAYER
; Z_HEIGHT: 16.2
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F9259.259
G1 X176.4 Y167.194 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 81/109
; update layer progress
M73 L81
M991 S0 P80 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z16.4 I1.217 J-.029 P1  F60000
G1 X176.002 Y150.602 Z16.4
G1 Z16.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X176.798 Y150.602 E.0264
G1 X176.798 Y169.398 E.62349
G1 X176.002 Y169.398 E.0264
G1 X176.002 Y150.662 E.6215
; COOLING_NODE: 0
M204 S250
G1 X175.61 Y150.21 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X177.19 Y150.21 E.04855
G1 X177.19 Y169.79 E.60164
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X175.61 Y169.79 E.04855
G1 X175.61 Y150.27 E.5998
M204 S10000
G1 X176.4 Y150.806 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1200
M204 S8000
G1 X176.4 Y169.194 E.5826
; CHANGE_LAYER
; Z_HEIGHT: 16.4
; LAYER_HEIGHT: 0.199999
; WIPE_START
G1 F9259.259
G1 X176.4 Y167.194 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 82/109
; update layer progress
M73 L82
M991 S0 P81 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
M73 P83 R2
G3 Z16.6 I1.217 J-.029 P1  F60000
G1 X176.002 Y150.602 Z16.6
G1 Z16.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X176.798 Y150.602 E.0264
G1 X176.798 Y169.398 E.62349
G1 X176.002 Y169.398 E.0264
G1 X176.002 Y150.662 E.6215
; COOLING_NODE: 0
M204 S250
G1 X175.61 Y150.21 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X177.19 Y150.21 E.04855
G1 X177.19 Y169.79 E.60164
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X175.61 Y169.79 E.04855
G1 X175.61 Y150.27 E.5998
M204 S10000
G1 X176.4 Y150.806 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1200
M204 S8000
G1 X176.4 Y169.194 E.5826
; CHANGE_LAYER
; Z_HEIGHT: 16.6
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F9259.259
G1 X176.4 Y167.194 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 83/109
; update layer progress
M73 L83
M991 S0 P82 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z16.8 I1.217 J-.029 P1  F60000
G1 X176.002 Y150.602 Z16.8
G1 Z16.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X176.798 Y150.602 E.0264
G1 X176.798 Y169.398 E.62349
G1 X176.002 Y169.398 E.0264
G1 X176.002 Y150.662 E.6215
; COOLING_NODE: 0
M204 S250
G1 X175.61 Y150.21 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X177.19 Y150.21 E.04855
G1 X177.19 Y169.79 E.60164
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X175.61 Y169.79 E.04855
G1 X175.61 Y150.27 E.5998
M204 S10000
G1 X176.4 Y150.806 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1200
M204 S8000
G1 X176.4 Y169.194 E.5826
; CHANGE_LAYER
; Z_HEIGHT: 16.8
; LAYER_HEIGHT: 0.199999
; WIPE_START
M73 P84 R2
G1 F9259.259
G1 X176.4 Y167.194 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 84/109
; update layer progress
M73 L84
M991 S0 P83 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z17 I1.217 J-.029 P1  F60000
G1 X176.002 Y150.602 Z17
G1 Z16.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X176.798 Y150.602 E.0264
G1 X176.798 Y169.398 E.62349
G1 X176.002 Y169.398 E.0264
G1 X176.002 Y150.662 E.6215
; COOLING_NODE: 0
M204 S250
G1 X175.61 Y150.21 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X177.19 Y150.21 E.04855
G1 X177.19 Y169.79 E.60164
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X175.61 Y169.79 E.04855
G1 X175.61 Y150.27 E.5998
M204 S10000
G1 X176.4 Y150.806 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1200
M204 S8000
G1 X176.4 Y169.194 E.5826
; CHANGE_LAYER
; Z_HEIGHT: 17
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F9259.259
G1 X176.4 Y167.194 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 85/109
; update layer progress
M73 L85
M991 S0 P84 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z17.2 I1.217 J-.029 P1  F60000
G1 X176.002 Y150.602 Z17.2
G1 Z17
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X176.798 Y150.602 E.0264
G1 X176.798 Y169.398 E.62349
G1 X176.002 Y169.398 E.0264
G1 X176.002 Y150.662 E.6215
; COOLING_NODE: 0
M204 S250
G1 X175.61 Y150.21 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X177.19 Y150.21 E.04855
G1 X177.19 Y169.79 E.60164
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X175.61 Y169.79 E.04855
G1 X175.61 Y150.27 E.5998
M204 S10000
G1 X176.4 Y150.806 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
M73 P85 R2
G1 F1200
M204 S8000
G1 X176.4 Y169.194 E.5826
; CHANGE_LAYER
; Z_HEIGHT: 17.2
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F9259.259
G1 X176.4 Y167.194 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 86/109
; update layer progress
M73 L86
M991 S0 P85 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z17.4 I1.217 J-.029 P1  F60000
G1 X176.002 Y150.602 Z17.4
G1 Z17.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X176.798 Y150.602 E.0264
G1 X176.798 Y169.398 E.62349
G1 X176.002 Y169.398 E.0264
G1 X176.002 Y150.662 E.6215
; COOLING_NODE: 0
M204 S250
G1 X175.61 Y150.21 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X177.19 Y150.21 E.04855
G1 X177.19 Y169.79 E.60164
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X175.61 Y169.79 E.04855
G1 X175.61 Y150.27 E.5998
M204 S10000
G1 X176.4 Y150.806 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1200
M204 S8000
G1 X176.4 Y169.194 E.5826
; CHANGE_LAYER
; Z_HEIGHT: 17.4
; LAYER_HEIGHT: 0.199999
; WIPE_START
G1 F9259.259
G1 X176.4 Y167.194 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 87/109
; update layer progress
M73 L87
M991 S0 P86 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z17.6 I1.217 J-.029 P1  F60000
G1 X176.002 Y150.602 Z17.6
G1 Z17.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X176.798 Y150.602 E.0264
G1 X176.798 Y169.398 E.62349
G1 X176.002 Y169.398 E.0264
G1 X176.002 Y150.662 E.6215
; COOLING_NODE: 0
M204 S250
G1 X175.61 Y150.21 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X177.19 Y150.21 E.04855
G1 X177.19 Y169.79 E.60164
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X175.61 Y169.79 E.04855
G1 X175.61 Y150.27 E.5998
M204 S10000
G1 X176.4 Y150.806 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
M73 P86 R2
G1 F1200
M204 S8000
G1 X176.4 Y169.194 E.5826
; CHANGE_LAYER
; Z_HEIGHT: 17.6
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F9259.259
G1 X176.4 Y167.194 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 88/109
; update layer progress
M73 L88
M991 S0 P87 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z17.8 I1.217 J-.029 P1  F60000
G1 X176.002 Y150.602 Z17.8
G1 Z17.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X176.798 Y150.602 E.0264
G1 X176.798 Y169.398 E.62349
G1 X176.002 Y169.398 E.0264
G1 X176.002 Y150.662 E.6215
; COOLING_NODE: 0
M204 S250
G1 X175.61 Y150.21 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X177.19 Y150.21 E.04855
G1 X177.19 Y169.79 E.60164
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X175.61 Y169.79 E.04855
G1 X175.61 Y150.27 E.5998
M204 S10000
G1 X176.4 Y150.806 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1200
M204 S8000
G1 X176.4 Y169.194 E.5826
; CHANGE_LAYER
; Z_HEIGHT: 17.8
; LAYER_HEIGHT: 0.199999
; WIPE_START
G1 F9259.259
G1 X176.4 Y167.194 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 89/109
; update layer progress
M73 L89
M991 S0 P88 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z18 I1.217 J-.029 P1  F60000
G1 X176.002 Y150.602 Z18
G1 Z17.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X176.798 Y150.602 E.0264
G1 X176.798 Y169.398 E.62349
G1 X176.002 Y169.398 E.0264
G1 X176.002 Y150.662 E.6215
; COOLING_NODE: 0
M204 S250
G1 X175.61 Y150.21 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X177.19 Y150.21 E.04855
M73 P87 R2
G1 X177.19 Y169.79 E.60164
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X175.61 Y169.79 E.04855
G1 X175.61 Y150.27 E.5998
M204 S10000
G1 X176.4 Y150.806 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1200
M204 S8000
G1 X176.4 Y169.194 E.5826
; CHANGE_LAYER
; Z_HEIGHT: 18
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F9259.259
G1 X176.4 Y167.194 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 90/109
; update layer progress
M73 L90
M991 S0 P89 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z18.2 I1.217 J-.029 P1  F60000
G1 X176.002 Y150.602 Z18.2
G1 Z18
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X176.798 Y150.602 E.0264
G1 X176.798 Y169.398 E.62349
G1 X176.002 Y169.398 E.0264
G1 X176.002 Y150.662 E.6215
; COOLING_NODE: 0
M204 S250
G1 X175.61 Y150.21 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X177.19 Y150.21 E.04855
M73 P87 R1
G1 X177.19 Y169.79 E.60164
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X175.61 Y169.79 E.04855
G1 X175.61 Y150.27 E.5998
M204 S10000
G1 X176.4 Y150.806 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1200
M204 S8000
G1 X176.4 Y169.194 E.5826
; CHANGE_LAYER
; Z_HEIGHT: 18.2
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F9259.259
G1 X176.4 Y167.194 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 91/109
; update layer progress
M73 L91
M991 S0 P90 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z18.4 I1.217 J-.029 P1  F60000
G1 X176.002 Y150.602 Z18.4
G1 Z18.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X176.798 Y150.602 E.0264
G1 X176.798 Y169.398 E.62349
G1 X176.002 Y169.398 E.0264
G1 X176.002 Y150.662 E.6215
; COOLING_NODE: 0
M204 S250
G1 X175.61 Y150.21 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
M73 P88 R1
G1 F1200
M204 S5000
G1 X177.19 Y150.21 E.04855
G1 X177.19 Y169.79 E.60164
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X175.61 Y169.79 E.04855
G1 X175.61 Y150.27 E.5998
M204 S10000
G1 X176.4 Y150.806 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1200
M204 S8000
G1 X176.4 Y169.194 E.5826
; CHANGE_LAYER
; Z_HEIGHT: 18.4
; LAYER_HEIGHT: 0.199999
; WIPE_START
G1 F9259.259
G1 X176.4 Y167.194 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 92/109
; update layer progress
M73 L92
M991 S0 P91 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z18.6 I1.217 J-.029 P1  F60000
G1 X176.002 Y150.602 Z18.6
G1 Z18.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X176.798 Y150.602 E.0264
G1 X176.798 Y169.398 E.62349
G1 X176.002 Y169.398 E.0264
G1 X176.002 Y150.662 E.6215
; COOLING_NODE: 0
M204 S250
G1 X175.61 Y150.21 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X177.19 Y150.21 E.04855
G1 X177.19 Y169.79 E.60164
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X175.61 Y169.79 E.04855
G1 X175.61 Y150.27 E.5998
M204 S10000
G1 X176.4 Y150.806 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1200
M204 S8000
G1 X176.4 Y169.194 E.5826
; CHANGE_LAYER
; Z_HEIGHT: 18.6
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F9259.259
G1 X176.4 Y167.194 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 93/109
; update layer progress
M73 L93
M991 S0 P92 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
M73 P89 R1
G3 Z18.8 I1.217 J-.029 P1  F60000
G1 X176.002 Y150.602 Z18.8
G1 Z18.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X176.798 Y150.602 E.0264
G1 X176.798 Y169.398 E.62349
G1 X176.002 Y169.398 E.0264
G1 X176.002 Y150.662 E.6215
; COOLING_NODE: 0
M204 S250
G1 X175.61 Y150.21 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X177.19 Y150.21 E.04855
G1 X177.19 Y169.79 E.60164
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X175.61 Y169.79 E.04855
G1 X175.61 Y150.27 E.5998
M204 S10000
G1 X176.4 Y150.806 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1200
M204 S8000
G1 X176.4 Y169.194 E.5826
; CHANGE_LAYER
; Z_HEIGHT: 18.8
; LAYER_HEIGHT: 0.199999
; WIPE_START
G1 F9259.259
G1 X176.4 Y167.194 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 94/109
; update layer progress
M73 L94
M991 S0 P93 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z19 I1.217 J-.029 P1  F60000
G1 X176.002 Y150.602 Z19
G1 Z18.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X176.798 Y150.602 E.0264
G1 X176.798 Y169.398 E.62349
G1 X176.002 Y169.398 E.0264
G1 X176.002 Y150.662 E.6215
; COOLING_NODE: 0
M204 S250
G1 X175.61 Y150.21 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X177.19 Y150.21 E.04855
G1 X177.19 Y169.79 E.60164
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X175.61 Y169.79 E.04855
G1 X175.61 Y150.27 E.5998
M204 S10000
G1 X176.4 Y150.806 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1200
M204 S8000
G1 X176.4 Y169.194 E.5826
; CHANGE_LAYER
; Z_HEIGHT: 19
; LAYER_HEIGHT: 0.200001
; WIPE_START
M73 P90 R1
G1 F9259.259
G1 X176.4 Y167.194 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 95/109
; update layer progress
M73 L95
M991 S0 P94 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z19.2 I1.217 J-.029 P1  F60000
G1 X176.002 Y150.602 Z19.2
G1 Z19
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X176.798 Y150.602 E.0264
G1 X176.798 Y169.398 E.62349
G1 X176.002 Y169.398 E.0264
G1 X176.002 Y150.662 E.6215
; COOLING_NODE: 0
M204 S250
G1 X175.61 Y150.21 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X177.19 Y150.21 E.04855
G1 X177.19 Y169.79 E.60164
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X175.61 Y169.79 E.04855
G1 X175.61 Y150.27 E.5998
M204 S10000
G1 X176.4 Y150.806 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1200
M204 S8000
G1 X176.4 Y169.194 E.5826
; CHANGE_LAYER
; Z_HEIGHT: 19.2
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F9259.259
G1 X176.4 Y167.194 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 96/109
; update layer progress
M73 L96
M991 S0 P95 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z19.4 I1.217 J-.029 P1  F60000
G1 X176.002 Y150.602 Z19.4
G1 Z19.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X176.798 Y150.602 E.0264
G1 X176.798 Y169.398 E.62349
G1 X176.002 Y169.398 E.0264
G1 X176.002 Y150.662 E.6215
; COOLING_NODE: 0
M204 S250
G1 X175.61 Y150.21 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X177.19 Y150.21 E.04855
G1 X177.19 Y169.79 E.60164
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X175.61 Y169.79 E.04855
G1 X175.61 Y150.27 E.5998
M204 S10000
G1 X176.4 Y150.806 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
M73 P91 R1
G1 F1200
M204 S8000
G1 X176.4 Y169.194 E.5826
; CHANGE_LAYER
; Z_HEIGHT: 19.4
; LAYER_HEIGHT: 0.199999
; WIPE_START
G1 F9259.259
G1 X176.4 Y167.194 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 97/109
; update layer progress
M73 L97
M991 S0 P96 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z19.6 I1.217 J-.029 P1  F60000
G1 X176.002 Y150.602 Z19.6
G1 Z19.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X176.798 Y150.602 E.0264
G1 X176.798 Y169.398 E.62349
G1 X176.002 Y169.398 E.0264
G1 X176.002 Y150.662 E.6215
; COOLING_NODE: 0
M204 S250
G1 X175.61 Y150.21 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X177.19 Y150.21 E.04855
G1 X177.19 Y169.79 E.60164
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X175.61 Y169.79 E.04855
G1 X175.61 Y150.27 E.5998
M204 S10000
G1 X176.4 Y150.806 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1200
M204 S8000
G1 X176.4 Y169.194 E.5826
; CHANGE_LAYER
; Z_HEIGHT: 19.6
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F9259.259
G1 X176.4 Y167.194 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 98/109
; update layer progress
M73 L98
M991 S0 P97 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z19.8 I1.217 J-.029 P1  F60000
G1 X176.002 Y150.602 Z19.8
G1 Z19.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X176.798 Y150.602 E.0264
G1 X176.798 Y169.398 E.62349
G1 X176.002 Y169.398 E.0264
G1 X176.002 Y150.662 E.6215
; COOLING_NODE: 0
M204 S250
G1 X175.61 Y150.21 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X177.19 Y150.21 E.04855
M73 P92 R1
G1 X177.19 Y169.79 E.60164
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X175.61 Y169.79 E.04855
G1 X175.61 Y150.27 E.5998
M204 S10000
G1 X176.4 Y150.806 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1200
M204 S8000
G1 X176.4 Y169.194 E.5826
; CHANGE_LAYER
; Z_HEIGHT: 19.8
; LAYER_HEIGHT: 0.199999
; WIPE_START
G1 F9259.259
G1 X176.4 Y167.194 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 99/109
; update layer progress
M73 L99
M991 S0 P98 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z20 I1.217 J-.029 P1  F60000
G1 X176.002 Y150.602 Z20
G1 Z19.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X176.798 Y150.602 E.0264
G1 X176.798 Y169.398 E.62349
G1 X176.002 Y169.398 E.0264
G1 X176.002 Y150.662 E.6215
; COOLING_NODE: 0
M204 S250
G1 X175.61 Y150.21 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X177.19 Y150.21 E.04855
G1 X177.19 Y169.79 E.60164
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X175.61 Y169.79 E.04855
G1 X175.61 Y150.27 E.5998
M204 S10000
G1 X176.4 Y150.806 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1200
M204 S8000
G1 X176.4 Y169.194 E.5826
; CHANGE_LAYER
; Z_HEIGHT: 20
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F9259.259
G1 X176.4 Y167.194 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 100/109
; update layer progress
M73 L100
M991 S0 P99 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z20.2 I1.217 J-.029 P1  F60000
G1 X176.002 Y150.602 Z20.2
G1 Z20
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X176.798 Y150.602 E.0264
G1 X176.798 Y169.398 E.62349
G1 X176.002 Y169.398 E.0264
G1 X176.002 Y150.662 E.6215
; COOLING_NODE: 0
M204 S250
G1 X175.61 Y150.21 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
M73 P93 R1
G1 F1200
M204 S5000
G1 X177.19 Y150.21 E.04855
G1 X177.19 Y169.79 E.60164
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X175.61 Y169.79 E.04855
G1 X175.61 Y150.27 E.5998
M204 S10000
G1 X176.4 Y150.806 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1200
M204 S8000
G1 X176.4 Y169.194 E.5826
; CHANGE_LAYER
; Z_HEIGHT: 20.2
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F9259.259
G1 X176.4 Y167.194 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 101/109
; update layer progress
M73 L101
M991 S0 P100 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z20.4 I1.217 J-.029 P1  F60000
G1 X176.002 Y150.602 Z20.4
G1 Z20.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X176.798 Y150.602 E.0264
G1 X176.798 Y169.398 E.62349
G1 X176.002 Y169.398 E.0264
G1 X176.002 Y150.662 E.6215
; COOLING_NODE: 0
M204 S250
G1 X175.61 Y150.21 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X177.19 Y150.21 E.04855
G1 X177.19 Y169.79 E.60164
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X175.61 Y169.79 E.04855
G1 X175.61 Y150.27 E.5998
M204 S10000
G1 X176.4 Y150.806 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1200
M204 S8000
G1 X176.4 Y169.194 E.5826
; CHANGE_LAYER
; Z_HEIGHT: 20.4
; LAYER_HEIGHT: 0.199999
; WIPE_START
M73 P93 R0
G1 F9259.259
G1 X176.4 Y167.194 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 102/109
; update layer progress
M73 L102
M991 S0 P101 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z20.6 I1.217 J-.029 P1  F60000
G1 X176.002 Y150.602 Z20.6
G1 Z20.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X176.798 Y150.602 E.0264
G1 X176.798 Y169.398 E.62349
G1 X176.002 Y169.398 E.0264
G1 X176.002 Y150.662 E.6215
; COOLING_NODE: 0
M204 S250
M73 P94 R0
G1 X175.61 Y150.21 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X177.19 Y150.21 E.04855
G1 X177.19 Y169.79 E.60164
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X175.61 Y169.79 E.04855
G1 X175.61 Y150.27 E.5998
M204 S10000
G1 X176.4 Y150.806 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1200
M204 S8000
G1 X176.4 Y169.194 E.5826
; CHANGE_LAYER
; Z_HEIGHT: 20.6
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F9259.259
G1 X176.4 Y167.194 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 103/109
; update layer progress
M73 L103
M991 S0 P102 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z20.8 I1.217 J-.029 P1  F60000
G1 X176.002 Y150.602 Z20.8
G1 Z20.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X176.798 Y150.602 E.0264
G1 X176.798 Y169.398 E.62349
G1 X176.002 Y169.398 E.0264
G1 X176.002 Y150.662 E.6215
; COOLING_NODE: 0
M204 S250
G1 X175.61 Y150.21 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X177.19 Y150.21 E.04855
G1 X177.19 Y169.79 E.60164
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X175.61 Y169.79 E.04855
G1 X175.61 Y150.27 E.5998
M204 S10000
G1 X176.4 Y150.806 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1200
M204 S8000
G1 X176.4 Y169.194 E.5826
; CHANGE_LAYER
; Z_HEIGHT: 20.8
; LAYER_HEIGHT: 0.199999
; WIPE_START
G1 F9259.259
G1 X176.4 Y167.194 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 104/109
; update layer progress
M73 L104
M991 S0 P103 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
M73 P95 R0
G3 Z21 I1.217 J-.029 P1  F60000
G1 X176.002 Y150.602 Z21
G1 Z20.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X176.798 Y150.602 E.0264
G1 X176.798 Y169.398 E.62349
G1 X176.002 Y169.398 E.0264
G1 X176.002 Y150.662 E.6215
; COOLING_NODE: 0
M204 S250
G1 X175.61 Y150.21 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X177.19 Y150.21 E.04855
G1 X177.19 Y169.79 E.60164
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X175.61 Y169.79 E.04855
G1 X175.61 Y150.27 E.5998
M204 S10000
G1 X176.4 Y150.806 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1200
M204 S8000
G1 X176.4 Y169.194 E.5826
; CHANGE_LAYER
; Z_HEIGHT: 21
; LAYER_HEIGHT: 0.200001
; WIPE_START
M73 P96 R0
G1 F9259.259
G1 X176.4 Y167.194 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 105/109
; update layer progress
M73 L105
M991 S0 P104 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z21.2 I1.217 J-.029 P1  F60000
G1 X176.002 Y150.602 Z21.2
G1 Z21
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X176.798 Y150.602 E.0264
G1 X176.798 Y169.398 E.62349
G1 X176.002 Y169.398 E.0264
G1 X176.002 Y150.662 E.6215
; COOLING_NODE: 0
M204 S250
G1 X175.61 Y150.21 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X177.19 Y150.21 E.04855
G1 X177.19 Y169.79 E.60164
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X175.61 Y169.79 E.04855
G1 X175.61 Y150.27 E.5998
M204 S10000
G1 X176.4 Y150.806 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1200
M204 S8000
G1 X176.4 Y169.194 E.5826
; CHANGE_LAYER
; Z_HEIGHT: 21.2
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F9259.259
G1 X176.4 Y167.194 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 106/109
; update layer progress
M73 L106
M991 S0 P105 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z21.4 I1.217 J-.029 P1  F60000
G1 X176.002 Y150.602 Z21.4
G1 Z21.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X176.798 Y150.602 E.0264
G1 X176.798 Y169.398 E.62349
G1 X176.002 Y169.398 E.0264
G1 X176.002 Y150.662 E.6215
; COOLING_NODE: 0
M204 S250
G1 X175.61 Y150.21 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X177.19 Y150.21 E.04855
G1 X177.19 Y169.79 E.60164
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X175.61 Y169.79 E.04855
G1 X175.61 Y150.27 E.5998
M204 S10000
G1 X176.4 Y150.806 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
M73 P97 R0
G1 F1200
M204 S8000
G1 X176.4 Y169.194 E.5826
; CHANGE_LAYER
; Z_HEIGHT: 21.4
; LAYER_HEIGHT: 0.199999
; WIPE_START
G1 F9259.259
G1 X176.4 Y167.194 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 107/109
; update layer progress
M73 L107
M991 S0 P106 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z21.6 I1.217 J-.029 P1  F60000
G1 X176.002 Y150.602 Z21.6
G1 Z21.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X176.798 Y150.602 E.0264
G1 X176.798 Y169.398 E.62349
G1 X176.002 Y169.398 E.0264
G1 X176.002 Y150.662 E.6215
; COOLING_NODE: 0
M204 S250
G1 X175.61 Y150.21 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X177.19 Y150.21 E.04855
G1 X177.19 Y169.79 E.60164
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X175.61 Y169.79 E.04855
G1 X175.61 Y150.27 E.5998
M204 S10000
G1 X176.4 Y150.806 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1200
M204 S8000
G1 X176.4 Y169.194 E.5826
; CHANGE_LAYER
; Z_HEIGHT: 21.6
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F9259.259
G1 X176.4 Y167.194 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 108/109
; update layer progress
M73 L108
M991 S0 P107 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z21.8 I1.217 J-.029 P1  F60000
G1 X176.002 Y150.602 Z21.8
G1 Z21.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M204 S8000
G1 X176.798 Y150.602 E.0264
G1 X176.798 Y169.398 E.62349
G1 X176.002 Y169.398 E.0264
G1 X176.002 Y150.662 E.6215
; COOLING_NODE: 0
M204 S250
G1 X175.61 Y150.21 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X177.19 Y150.21 E.04855
M73 P98 R0
G1 X177.19 Y169.79 E.60164
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X175.61 Y169.79 E.04855
G1 X175.61 Y150.27 E.5998
M204 S10000
G1 X176.4 Y150.806 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F1200
M204 S8000
G1 X176.4 Y169.194 E.5826
; CHANGE_LAYER
; Z_HEIGHT: 21.8
; LAYER_HEIGHT: 0.199999
; WIPE_START
G1 F9259.259
G1 X176.4 Y167.194 E-.76
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 109/109
; update layer progress
M73 L109
M991 S0 P108 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z22 I1.216 J-.057 P1  F60000
G1 X175.61 Y150.21 Z22
G1 Z21.8
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X177.19 Y150.21 E.04855
G1 X177.19 Y169.79 E.60164
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X175.61 Y169.79 E.04855
G1 X175.61 Y150.27 E.5998
M204 S10000
G1 X176.349 Y150.417 F60000
; FEATURE: Top surface
G1 F1200
M204 S2000
G1 X176.983 Y151.051 E.02753
G1 X177.116 Y151.185
G1 X177.116 Y151.718
G1 X176.983 Y151.584
G1 X175.817 Y150.419 E.05064
G1 X175.684 Y150.285
G1 X175.684 Y150.819
G1 X175.817 Y150.952
G1 X176.983 Y152.117 E.05064
G1 X177.116 Y152.251
G1 X177.116 Y152.784
G1 X176.983 Y152.651
G1 X175.817 Y151.485 E.05064
G1 X175.684 Y151.352
G1 X175.684 Y151.885
G1 X175.817 Y152.019
G1 X176.983 Y153.184 E.05064
G1 X177.116 Y153.318
G1 X177.116 Y153.851
G1 X176.983 Y153.717
G1 X175.817 Y152.552 E.05064
G1 X175.684 Y152.418
G1 X175.684 Y152.952
G1 X175.817 Y153.085
G1 X176.983 Y154.25 E.05064
G1 X177.116 Y154.384
G1 X177.116 Y154.917
G1 X176.983 Y154.784
G1 X175.817 Y153.618 E.05064
G1 X175.684 Y153.485
G1 X175.684 Y154.018
G1 X175.817 Y154.152
G1 X176.983 Y155.317 E.05064
G1 X177.116 Y155.451
G1 X177.116 Y155.984
G1 X176.983 Y155.85
G1 X175.817 Y154.685 E.05064
G1 X175.684 Y154.551
G1 X175.684 Y155.085
G1 X175.817 Y155.218
G1 X176.983 Y156.383 E.05064
G1 X177.116 Y156.517
G1 X177.116 Y157.05
G1 X176.983 Y156.917
G1 X175.817 Y155.752 E.05064
G1 X175.684 Y155.618
G1 X175.684 Y156.151
G1 X175.817 Y156.285
G1 X176.983 Y157.45 E.05064
G1 X177.116 Y157.584
G1 X177.116 Y158.117
G1 X176.983 Y157.983
G1 X175.817 Y156.818 E.05064
G1 X175.684 Y156.684
G1 X175.684 Y157.218
G1 X175.817 Y157.351
G1 X176.983 Y158.517 E.05064
G1 X177.116 Y158.65
G1 X177.116 Y159.183
G1 X176.983 Y159.05
G1 X175.817 Y157.885 E.05064
G1 X175.684 Y157.751
G1 X175.684 Y158.284
G1 X175.817 Y158.418
G1 X176.983 Y159.583 E.05064
G1 X177.116 Y159.717
G1 X177.116 Y160.25
G1 X176.983 Y160.116
G1 X175.817 Y158.951 E.05064
G1 X175.684 Y158.817
G1 X175.684 Y159.351
G1 X175.817 Y159.484
G1 X176.983 Y160.65 E.05064
G1 X177.116 Y160.783
G1 X177.116 Y161.316
G1 X176.983 Y161.183
G1 X175.817 Y160.018 E.05064
G1 X175.684 Y159.884
G1 X175.684 Y160.417
G1 X175.817 Y160.551
G1 X176.983 Y161.716 E.05064
G1 X177.116 Y161.85
G1 X177.116 Y162.383
G1 X176.983 Y162.249
G1 X175.817 Y161.084 E.05064
G1 X175.684 Y160.95
G1 X175.684 Y161.484
G1 X175.817 Y161.617
G1 X176.983 Y162.783 E.05064
G1 X177.116 Y162.916
G1 X177.116 Y163.449
G1 X176.983 Y163.316
G1 X175.817 Y162.151 E.05064
G1 X175.684 Y162.017
G1 X175.684 Y162.55
G1 X175.817 Y162.684
G1 X176.983 Y163.849 E.05064
G1 X177.116 Y163.983
G1 X177.116 Y164.516
G1 X176.983 Y164.382
G1 X175.817 Y163.217 E.05064
G1 X175.684 Y163.083
G1 X175.684 Y163.617
G1 X175.817 Y163.75
G1 X176.983 Y164.916 E.05064
G1 X177.116 Y165.049
G1 X177.116 Y165.583
G1 X176.983 Y165.449
G1 X175.817 Y164.284 E.05064
G1 X175.684 Y164.15
G1 X175.684 Y164.683
G1 X175.817 Y164.817
G1 X176.983 Y165.982 E.05064
G1 X177.116 Y166.116
G1 X177.116 Y166.649
G1 X176.983 Y166.515
G1 X175.817 Y165.35 E.05064
G1 X175.684 Y165.216
G1 X175.684 Y165.75
G1 X175.817 Y165.883
G1 X176.983 Y167.049 E.05064
G1 X177.116 Y167.182
G1 X177.116 Y167.716
G1 X176.983 Y167.582
G1 X175.817 Y166.417 E.05064
G1 X175.684 Y166.283
G1 X175.684 Y166.816
G1 X175.817 Y166.95
M73 P99 R0
G1 X176.983 Y168.115 E.05064
G1 X177.116 Y168.249
G1 X177.116 Y168.782
G1 X176.983 Y168.648
G1 X175.817 Y167.483 E.05064
G1 X175.684 Y167.35
G1 X175.684 Y167.883
G1 X175.817 Y168.016
G1 X176.983 Y169.182 E.05064
G1 X177.116 Y169.315
G1 X176.984 Y169.716
G1 X176.85 Y169.583
G1 X175.817 Y168.55 E.04489
G1 X175.684 Y168.416
G1 X175.684 Y168.949
G1 X175.817 Y169.083
G1 X176.317 Y169.583 E.02171
; close powerlost recovery
M1003 S0
; WIPE_START
G1 F9547.055
M204 S8000
G1 X175.817 Y169.083 E-.26854
G1 X175.684 Y168.949 E-.07182
G1 X175.684 Y168.416 E-.20264
G1 X175.817 Y168.55 E-.07182
G1 X176.088 Y168.82 E-.14518
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z22.2 I1.217 J0 P1  F60000
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
G1 Z22.2 F900 ; lower z a little
M1002 judge_flag timelapse_record_flag
M622 J1
    G150.3
    M400 ; wait all motion done
    M991 S0 P-1 ;end smooth timelapse at safe pos
    M400 S5 ;wait for last picture to be taken
M623  ;end of "timelapse_record_flag"

G90
G1 Z31.8 F900 ; lower z a little

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

    
        G1 Z110.9 F600
        G1 Z108.9
    

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

