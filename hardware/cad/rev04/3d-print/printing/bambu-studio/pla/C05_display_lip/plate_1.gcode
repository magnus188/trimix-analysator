; HEADER_BLOCK_START
; BambuStudio 02.08.02.61
; model printing time: 14m 34s; total estimated time: 20m 1s
; total layer number: 100
; total filament length [mm] : 840.03
; total filament volume [cm^3] : 2020.50
; total filament weight [g] : 2.51
; filament_density: 1.24
; filament_diameter: 1.75
; max_z_height: 20.00
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
M73 P0 R20
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
M73 P2 R19
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
M73 P4 R19
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

    M190 S55; ensure bed temp

    G383 O0 M2 T140

;===== z ofst cali end =====

G39.1 ; cali nozzle wrapped detection pos

G90
M73 P25 R14
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
M73 P26 R14
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
; layer num/total_layer_count: 1/100
; update layer progress
M73 L1
M991 S0 P0 ;notify layer change

M106 S0
M106 P2 S0
; OBJECT_ID: 15
G1 X168.647 Y147.574 F60000
M204 S6000
M73 P27 R14
G1 Z.4
G1 Z.2
G1 E.8 F1800
; FEATURE: Brim
; LINE_WIDTH: 0.5
G1 F3000
M204 S500
G1 X169.063 Y147.19 E.02109
G1 X169.539 Y146.878 E.02118
G1 X169.919 Y146.7 E.01565
G1 X170.564 Y146.498 E.02516
G1 X171.288 Y146.422 E.0271
G1 X178.716 Y146.422 E.27667
G1 X179.285 Y146.469 E.02127
G1 X180.196 Y146.752 E.03555
G1 X180.703 Y147.025 E.02144
G1 X181.151 Y147.372 E.02109
G1 X181.535 Y147.788 E.02109
G1 X181.847 Y148.262 E.02113
G1 X182.064 Y148.743 E.01967
G1 X182.227 Y149.287 E.02114
G1 X182.303 Y150.012 E.02716
G1 X182.303 Y169.991 E.74412
G1 X182.256 Y170.56 E.02127
G1 X182.014 Y171.375 E.03169
G1 X181.699 Y171.98 E.02537
G1 X181.353 Y172.426 E.02104
G1 X180.937 Y172.81 E.02109
G1 X180.462 Y173.122 E.02118
G1 X180.081 Y173.3 E.01565
G1 X179.437 Y173.502 E.02516
G1 X178.713 Y173.578 E.0271
G1 X171.285 Y173.578 E.27666
G1 X170.716 Y173.531 E.02127
G1 X169.9 Y173.289 E.03169
G1 X169.296 Y172.974 E.02537
G1 X168.85 Y172.628 E.02104
G1 X168.465 Y172.212 E.02109
G1 X168.154 Y171.738 E.02113
G1 X167.937 Y171.257 E.01967
G1 X167.774 Y170.713 E.02114
G1 X167.698 Y169.988 E.02715
G1 X167.698 Y150.009 E.74413
G1 X167.745 Y149.44 E.02127
G1 X167.987 Y148.625 E.03169
G1 X168.301 Y148.02 E.02537
G1 X168.611 Y147.621 E.0188
M204 S6000
G1 X168.972 Y147.904 F60000
G1 F3000
M204 S500
G1 X168.994 Y147.876 E.00131
G1 X169.337 Y147.559 E.01742
G1 X169.753 Y147.283 E.01859
G1 X170.077 Y147.131 E.01332
G1 X170.671 Y146.946 E.02317
G1 X171.319 Y146.879 E.02425
G1 X178.702 Y146.88 E.27502
G1 X179.211 Y146.925 E.01904
G1 X180.006 Y147.171 E.03099
G1 X180.443 Y147.404 E.01844
G1 X180.832 Y147.703 E.01827
G1 X181.166 Y148.062 E.01826
G1 X181.439 Y148.474 E.0184
G1 X181.637 Y148.912 E.01794
G1 X181.778 Y149.39 E.01855
G1 X181.846 Y150.043 E.02445
G1 X181.846 Y169.966 E.74205
G1 X181.8 Y170.489 E.01954
G1 X181.592 Y171.191 E.02728
G1 X181.305 Y171.742 E.02314
G1 X181.007 Y172.124 E.01805
G1 X180.663 Y172.441 E.01742
G1 X180.247 Y172.717 E.01859
G1 X179.924 Y172.869 E.01332
G1 X179.33 Y173.054 E.02317
G1 X178.682 Y173.121 E.02426
G1 X171.31 Y173.121 E.27459
G1 X170.787 Y173.075 E.01954
G1 X170.085 Y172.867 E.02728
G1 X169.534 Y172.58 E.02314
G1 X169.152 Y172.282 E.01805
G1 X168.82 Y171.921 E.01826
G1 X168.551 Y171.508 E.01836
G1 X168.363 Y171.088 E.01714
G1 X168.222 Y170.61 E.01855
G1 X168.155 Y169.971 E.02392
G1 X168.155 Y150.034 E.74259
G1 X168.2 Y149.511 E.01953
G1 X168.409 Y148.809 E.02728
G1 X168.695 Y148.258 E.02314
G1 X168.935 Y147.951 E.01451
M204 S6000
G1 X169.295 Y148.233 F60000
G1 F3000
M204 S500
G1 X169.324 Y148.196 E.00175
G1 X169.612 Y147.927 E.01466
G1 X169.97 Y147.688 E.01602
G1 X170.234 Y147.562 E.01092
G1 X170.777 Y147.395 E.02114
G1 X171.349 Y147.336 E.02143
G1 X178.676 Y147.337 E.27289
G1 X179.136 Y147.38 E.01723
G1 X179.817 Y147.591 E.02655
G1 X180.185 Y147.784 E.01546
G1 X180.514 Y148.035 E.01543
G1 X180.798 Y148.337 E.01543
G1 X181.031 Y148.686 E.01564
G1 X181.211 Y149.081 E.01615
G1 X181.329 Y149.492 E.01592
G1 X181.389 Y150.074 E.0218
G1 X181.389 Y169.94 E.73994
G1 X181.345 Y170.416 E.01781
G1 X181.17 Y171.006 E.02292
G1 X180.911 Y171.503 E.02088
G1 X180.676 Y171.804 E.01423
G1 X180.389 Y172.073 E.01466
G1 X180.031 Y172.312 E.01602
G1 X179.766 Y172.438 E.01092
G1 X179.224 Y172.605 E.02114
G1 X178.651 Y172.664 E.02143
G1 X171.336 Y172.664 E.27248
G1 X170.86 Y172.62 E.01781
G1 X170.27 Y172.445 E.02292
G1 X169.772 Y172.186 E.02088
G1 X169.455 Y171.937 E.01502
G1 X169.177 Y171.63 E.01544
G1 X168.95 Y171.278 E.0156
G1 X168.79 Y170.92 E.0146
G1 X168.671 Y170.508 E.01596
G1 X168.613 Y169.955 E.02073
G1 X168.612 Y150.06 E.741
G1 X168.656 Y149.584 E.0178
G1 X168.831 Y148.994 E.02292
G1 X169.089 Y148.497 E.02088
G1 X169.258 Y148.28 E.01024
M204 S6000
G1 X169.618 Y148.564 F60000
G1 F3000
M204 S500
G1 X169.67 Y148.498 E.00314
G1 X169.889 Y148.294 E.01112
G1 X170.188 Y148.092 E.01346
G1 X170.392 Y147.993 E.00844
G1 X170.882 Y147.843 E.01908
G1 X171.38 Y147.793 E.01863
G1 X178.648 Y147.794 E.27071
G1 X179.06 Y147.835 E.01542
G1 X179.63 Y148.012 E.02224
G1 X179.928 Y148.166 E.0125
G1 X180.215 Y148.384 E.01343
G1 X180.446 Y148.632 E.0126
G1 X180.624 Y148.9 E.012
G1 X180.777 Y149.231 E.01357
G1 X180.88 Y149.591 E.01397
G1 X180.931 Y150.09 E.01868
G1 X180.932 Y169.913 E.73831
G1 X180.89 Y170.342 E.01608
G1 X180.748 Y170.822 E.01862
G1 X180.518 Y171.265 E.01862
G1 X180.33 Y171.502 E.01124
G1 X180.112 Y171.706 E.01112
G1 X179.813 Y171.908 E.01346
G1 X179.609 Y172.007 E.00844
G1 X179.119 Y172.157 E.01908
G1 X178.621 Y172.207 E.01863
G1 X171.363 Y172.207 E.27033
G1 X170.933 Y172.165 E.01608
G1 X170.454 Y172.023 E.01862
G1 X170.011 Y171.793 E.0186
G1 X169.761 Y171.593 E.01194
G1 X169.534 Y171.341 E.01262
G1 X169.348 Y171.05 E.01284
G1 X169.218 Y170.754 E.01206
G1 X169.12 Y170.408 E.01338
G1 X169.071 Y169.938 E.01761
G1 X169.069 Y150.087 E.73936
G1 X169.111 Y149.658 E.01607
G1 X169.253 Y149.179 E.01862
G1 X169.483 Y148.735 E.01862
G1 X169.581 Y148.611 E.00587
M204 S6000
G1 X169.964 Y148.877 F60000
G1 F3000
M204 S500
G1 X169.968 Y148.87 E.00031
G1 X170.057 Y148.771 E.00494
G1 X170.317 Y148.56 E.01248
G1 X170.572 Y148.419 E.01084
G1 X170.805 Y148.337 E.00919
G1 X171.199 Y148.261 E.01498
G1 X178.894 Y148.269 E.28658
G1 X179.183 Y148.329 E.01102
G1 X179.391 Y148.402 E.00819
G1 X179.571 Y148.495 E.00754
G1 X179.855 Y148.693 E.01288
G1 X179.955 Y148.783 E.00503
G1 X180.175 Y149.059 E.01314
G1 X180.294 Y149.27 E.00903
G1 X180.384 Y149.495 E.00901
G1 X180.475 Y150.035 E.02042
G1 X180.475 Y169.972 E.74256
G1 X180.44 Y170.272 E.01127
G1 X180.353 Y170.584 E.01204
G1 X180.133 Y170.999 E.0175
G1 X180.064 Y171.093 E.00432
G1 X179.791 Y171.361 E.01428
G1 X179.473 Y171.559 E.01394
G1 X179.229 Y171.659 E.0098
G1 X178.689 Y171.75 E.0204
G1 X171.107 Y171.731 E.28241
G1 X170.819 Y171.671 E.01097
G1 X170.578 Y171.58 E.00957
G1 X170.276 Y171.407 E.01298
G1 X170.122 Y171.291 E.00717
G1 X169.825 Y170.94 E.01716
G1 X169.706 Y170.73 E.00896
G1 X169.616 Y170.505 E.00901
G1 X169.526 Y169.965 E.02042
G1 X169.531 Y149.953 E.74536
G1 X169.58 Y149.639 E.01184
G1 X169.68 Y149.331 E.01205
G1 X169.771 Y149.155 E.0074
G1 X169.93 Y148.926 E.01036
M204 S6000
G1 X170.305 Y149.186 F60000
G1 F3000
M204 S500
G1 X170.349 Y149.123 E.00287
G1 X170.541 Y148.959 E.00939
G1 X170.734 Y148.846 E.00833
G1 X170.881 Y148.788 E.0059
G1 X171.299 Y148.707 E.01584
G1 X178.796 Y148.715 E.27924
G1 X179.033 Y148.76 E.00898
G1 X179.191 Y148.813 E.00623
G1 X179.303 Y148.866 E.0046
G1 X179.602 Y149.073 E.01354
G1 X179.772 Y149.274 E.0098
G1 X179.901 Y149.503 E.00979
G1 X179.959 Y149.662 E.00629
G1 X180.018 Y150.024 E.01368
G1 X180.018 Y169.98 E.74328
G1 X179.986 Y170.221 E.00906
G1 X179.913 Y170.463 E.00942
G1 X179.733 Y170.777 E.01348
G1 X179.558 Y170.968 E.00964
G1 X179.222 Y171.176 E.0147
G1 X179.063 Y171.234 E.00629
G1 X178.701 Y171.293 E.01367
G1 X171.205 Y171.285 E.27921
G1 X170.968 Y171.24 E.00899
G1 X170.814 Y171.188 E.00602
G1 X170.495 Y171.006 E.01371
G1 X170.402 Y170.931 E.00444
G1 X170.229 Y170.726 E.01
G1 X170.1 Y170.497 E.00979
G1 X170.042 Y170.338 E.0063
G1 X169.983 Y169.976 E.01367
G1 X169.983 Y150.02 E.74328
G1 X170.015 Y149.779 E.00905
G1 X170.09 Y149.532 E.00962
G1 X170.142 Y149.422 E.00453
G1 X170.271 Y149.236 E.00845
M204 S6000
G1 X170.649 Y149.474 F60000
G1 F3000
M204 S500
G1 X170.659 Y149.458 E.00069
G1 X170.761 Y149.36 E.00529
M73 P28 R14
G1 X170.974 Y149.235 E.00918
G1 X171.286 Y149.164 E.01191
G1 X178.714 Y149.164 E.27667
G1 X178.88 Y149.191 E.00626
G1 X179.055 Y149.25 E.00687
G1 X179.267 Y149.383 E.00934
G1 X179.367 Y149.487 E.00539
G1 X179.508 Y149.737 E.01069
G1 X179.561 Y150.013 E.01045
G1 X179.561 Y169.989 E.74403
G1 X179.534 Y170.155 E.00626
G1 X179.476 Y170.33 E.00687
G1 X179.342 Y170.542 E.00934
G1 X179.238 Y170.642 E.00539
G1 X178.988 Y170.783 E.01069
G1 X178.712 Y170.836 E.01045
G1 X171.287 Y170.836 E.27657
G1 X171.121 Y170.809 E.00626
G1 X170.946 Y170.751 E.00687
G1 X170.734 Y170.617 E.00934
G1 X170.633 Y170.513 E.00539
G1 X170.492 Y170.263 E.01069
G1 X170.44 Y169.987 E.01045
G1 X170.44 Y150.011 E.74403
G1 X170.467 Y149.845 E.00626
G1 X170.525 Y149.67 E.00687
G1 X170.617 Y149.525 E.00641
M204 S6000
G1 X170.964 Y149.799 F60000
G1 F3000
M204 S500
G1 X171.09 Y149.677 E.00651
G1 X171.276 Y149.621 E.00722
G1 X178.725 Y149.621 E.27746
G1 X178.926 Y149.688 E.0079
G1 X179.048 Y149.814 E.00651
G1 X179.088 Y149.916 E.00408
G1 X179.104 Y150 E.00317
G1 X179.104 Y170 E.74492
G1 X179.037 Y170.201 E.0079
G1 X178.911 Y170.323 E.00651
G1 X178.809 Y170.363 E.00408
G1 X178.725 Y170.379 E.00317
G1 X171.276 Y170.379 E.27746
G1 X171.074 Y170.312 E.0079
G1 X170.953 Y170.186 E.00651
G1 X170.913 Y170.084 E.00408
G1 X170.897 Y170 E.00317
G1 X170.897 Y150 E.74492
G1 X170.945 Y149.856 E.00566
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
G1 X171.676 Y169.6 E.24766
G1 X171.676 Y150.4 E.71513
G1 X178.325 Y150.4 E.24766
G1 X178.325 Y169.54 E.71289
;======== H2D 20260731========
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
G1 X172.133 Y169.143 E.21362
G1 X172.133 Y150.857 E.68108
G1 X177.868 Y150.857 E.21362
G1 X177.868 Y169.083 E.67884
M204 S6000
G1 X177.411 Y168.686 F60000
G1 F3000
M204 S500
G1 X172.59 Y168.686 E.17957
G1 X172.59 Y151.314 E.64703
G1 X177.411 Y151.314 E.17957
G1 X177.411 Y168.626 E.6448
M204 S6000
G1 X176.954 Y168.229 F60000
G1 F3000
M204 S500
G1 X173.047 Y168.229 E.14552
G1 X173.047 Y151.771 E.61298
G1 X176.954 Y151.771 E.14552
G1 X176.954 Y168.169 E.61075
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
G1 X176.036 Y152.16 E.03937
G1 X175.379 Y152.16 E.02491
G1 X176.565 Y153.346 E.06358
G1 X176.565 Y154.004 E.02491
G1 X174.721 Y152.16 E.0988
G1 X174.064 Y152.16 E.02491
G1 X176.565 Y154.661 E.13403
G1 X176.565 Y155.319 E.02491
G1 X173.435 Y152.189 E.16769
G1 X173.435 Y152.846 E.02491
G1 X176.565 Y155.976 E.16769
G1 X176.565 Y156.634 E.02491
G1 X173.435 Y153.504 E.16769
G1 X173.435 Y154.161 E.02491
G1 X176.565 Y157.291 E.16769
G1 X176.565 Y157.949 E.02491
G1 X173.435 Y154.819 E.16769
G1 X173.435 Y155.476 E.02491
G1 X176.565 Y158.606 E.16769
G1 X176.565 Y159.264 E.02491
G1 X173.435 Y156.134 E.16769
G1 X173.435 Y156.791 E.02491
G1 X176.565 Y159.921 E.16769
G1 X176.565 Y160.579 E.02491
G1 X173.435 Y157.449 E.16769
G1 X173.435 Y158.106 E.02491
G1 X176.565 Y161.236 E.16769
G1 X176.565 Y161.894 E.02491
G1 X173.435 Y158.764 E.16769
G1 X173.435 Y159.421 E.02491
G1 X176.565 Y162.551 E.16769
G1 X176.565 Y163.209 E.02491
G1 X173.435 Y160.079 E.16769
G1 X173.435 Y160.736 E.02491
G1 X176.565 Y163.866 E.16769
G1 X176.565 Y164.524 E.02491
G1 X173.435 Y161.394 E.16769
G1 X173.435 Y162.051 E.02491
G1 X176.565 Y165.181 E.16769
G1 X176.565 Y165.839 E.02491
G1 X173.435 Y162.709 E.16769
G1 X173.435 Y163.366 E.02491
G1 X176.565 Y166.496 E.16769
G1 X176.565 Y167.154 E.02491
M73 P29 R14
G1 X173.435 Y164.024 E.16769
G1 X173.435 Y164.681 E.02491
G1 X176.565 Y167.811 E.16769
G1 X176.565 Y167.84 E.00111
G1 X175.937 Y167.84 E.0238
G1 X173.435 Y165.339 E.13403
G1 X173.435 Y165.996 E.02491
G1 X175.28 Y167.84 E.09881
G1 X174.622 Y167.84 E.02491
G1 X173.435 Y166.654 E.06358
G1 X173.435 Y167.311 E.02491
G1 X174.17 Y168.046 E.03938
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

M106 S255
M106 P2 S178
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
G1 F2911
M204 S8000
G1 X172.693 Y168.584 E.15311
G1 X172.693 Y151.416 E.56948
G1 X177.309 Y151.416 E.15311
G1 X177.309 Y168.524 E.56749
M204 S10000
G1 X177.716 Y168.991 F60000
G1 F2911
M204 S8000
G1 X172.286 Y168.991 E.18012
G1 X172.286 Y151.009 E.59649
G1 X177.716 Y151.009 E.18012
G1 X177.716 Y168.931 E.5945
M204 S10000
G1 X178.123 Y169.398 F60000
G1 F2911
M204 S8000
G1 X171.879 Y169.398 E.20713
G1 X171.879 Y150.602 E.62349
G1 X178.123 Y150.602 E.20713
G1 X178.123 Y169.338 E.6215
M204 S250
G1 X178.515 Y169.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2911
M204 S5000
G1 X171.487 Y169.79 E.21596
G1 X171.487 Y150.21 E.60164
G1 X178.515 Y150.21 E.21596
G1 X178.515 Y169.73 E.5998
;======== H2D 20260731========
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
G1 F2911
M204 S8000
G1 X175.001 Y153.784 E.44583
M204 S10000
G1 X175.408 Y153.724 F60000
; LINE_WIDTH: 0.41999
G1 F2911
M204 S8000
G1 X175.408 Y153.317 E.01252
G1 X174.593 Y153.317 E.02504
G1 X174.593 Y166.683 E.41072
G1 X175.408 Y166.683 E.02504
G1 X175.408 Y153.784 E.39635
M204 S10000
G1 X175.786 Y153.724 F60000
G1 F2911
M204 S8000
G1 X175.786 Y152.939 E.02411
G1 X174.216 Y152.939 E.04822
G1 X174.216 Y167.061 E.43389
G1 X175.786 Y167.061 E.04822
G1 X175.786 Y153.784 E.40794
M204 S10000
G1 X176.163 Y153.724 F60000
G1 F2911
M204 S8000
G1 X176.163 Y152.562 E.03569
G1 X173.839 Y152.562 E.07139
G1 X173.839 Y167.438 E.45706
G1 X176.163 Y167.438 E.07139
G1 X176.163 Y153.784 E.41952
M204 S10000
G1 X176.54 Y153.724 F60000
G1 F2911
M204 S8000
G1 X176.54 Y152.185 E.04728
G1 X173.462 Y152.185 E.09456
G1 X173.462 Y167.815 E.48023
G1 X176.54 Y167.815 E.09456
G1 X176.54 Y153.784 E.43111
M204 S10000
G1 X176.917 Y153.724 F60000
G1 F2911
M204 S8000
G1 X176.917 Y151.808 E.05887
G1 X173.085 Y151.808 E.11773
G1 X173.085 Y168.192 E.50341
G1 X176.917 Y168.192 E.11773
G1 X176.917 Y153.784 E.4427
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
G1 F2913
M204 S8000
G1 X172.694 Y168.584 E.15307
G1 X172.694 Y151.416 E.56948
G1 X177.309 Y151.416 E.15307
G1 X177.309 Y168.524 E.56749
; COOLING_NODE: 0
M204 S10000
G1 X177.716 Y168.991 F60000
G1 F2913
M204 S8000
G1 X172.287 Y168.991 E.18008
G1 X172.287 Y151.009 E.59649
G1 X177.716 Y151.009 E.18008
G1 X177.716 Y168.931 E.5945
; COOLING_NODE: 0
M204 S10000
G1 X178.123 Y169.398 F60000
G1 F2913
M204 S8000
G1 X171.88 Y169.398 E.20709
G1 X171.88 Y150.602 E.62349
G1 X178.123 Y150.602 E.20709
G1 X178.123 Y169.338 E.6215
; COOLING_NODE: 0
M204 S250
M73 P30 R14
G1 X178.515 Y169.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2457
M204 S5000
G1 X171.488 Y169.79 E.21592
G1 X171.488 Y150.21 E.60164
G1 X178.515 Y150.21 E.21592
G1 X178.515 Y169.73 E.5998
;======== H2D 20260731========
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
M73 P30 R13
G1 X176.515 Y169.747 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X175.002 Y166.277 Z1 F60000
G1 Z.6
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.47968
G1 F2913
M204 S8000
G1 X175.002 Y153.783 E.44463
M204 S10000
G1 X175.408 Y153.723 F60000
; LINE_WIDTH: 0.41999
G1 F2913
M204 S8000
G1 X175.408 Y153.317 E.0125
G1 X174.595 Y153.317 E.02501
G1 X174.595 Y166.683 E.41072
G1 X175.408 Y166.683 E.02501
G1 X175.408 Y153.783 E.39637
M204 S10000
G1 X175.786 Y153.723 F60000
G1 F2913
M204 S8000
G1 X175.786 Y152.939 E.02409
G1 X174.218 Y152.939 E.04818
G1 X174.218 Y167.061 E.43389
G1 X175.786 Y167.061 E.04818
G1 X175.786 Y153.783 E.40796
M204 S10000
G1 X176.163 Y153.723 F60000
G1 F2913
M204 S8000
G1 X176.163 Y152.562 E.03568
G1 X173.84 Y152.562 E.07135
G1 X173.84 Y167.438 E.45706
G1 X176.163 Y167.438 E.07135
G1 X176.163 Y153.783 E.41954
M204 S10000
G1 X176.54 Y153.723 F60000
G1 F2913
M204 S8000
G1 X176.54 Y152.185 E.04726
G1 X173.463 Y152.185 E.09452
G1 X173.463 Y167.815 E.48023
G1 X176.54 Y167.815 E.09452
G1 X176.54 Y153.783 E.43113
M204 S10000
G1 X176.917 Y153.723 F60000
G1 F2913
M204 S8000
G1 X176.917 Y151.808 E.05885
G1 X173.086 Y151.808 E.11769
G1 X173.086 Y168.192 E.50341
G1 X176.917 Y168.192 E.11769
G1 X176.917 Y153.783 E.44271
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
G1 F2912
M204 S8000
G1 X172.696 Y168.584 E.15303
G1 X172.696 Y151.416 E.56948
G1 X177.309 Y151.416 E.15303
G1 X177.309 Y168.524 E.56749
; COOLING_NODE: 0
M204 S10000
G1 X177.716 Y168.991 F60000
G1 F2912
M204 S8000
G1 X172.288 Y168.991 E.18004
G1 X172.288 Y151.009 E.59649
G1 X177.716 Y151.009 E.18004
G1 X177.716 Y168.931 E.5945
; COOLING_NODE: 0
M204 S10000
G1 X178.123 Y169.398 F60000
G1 F2912
M204 S8000
G1 X171.881 Y169.398 E.20704
G1 X171.881 Y150.602 E.62349
G1 X178.123 Y150.602 E.20704
G1 X178.123 Y169.338 E.6215
; COOLING_NODE: 0
M204 S250
G1 X178.515 Y169.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2266
M204 S5000
G1 X171.489 Y169.79 E.21588
G1 X171.489 Y150.21 E.60164
G1 X178.515 Y150.21 E.21588
G1 X178.515 Y169.73 E.5998
;======== H2D 20260731========
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
G1 F2912
M204 S8000
G1 X175.002 Y153.783 E.44342
M204 S10000
G1 X175.408 Y153.723 F60000
; LINE_WIDTH: 0.41999
G1 F2912
M204 S8000
G1 X175.408 Y153.317 E.01248
G1 X174.596 Y153.317 E.02497
G1 X174.596 Y166.683 E.41072
G1 X175.408 Y166.683 E.02497
G1 X175.408 Y153.783 E.39639
M204 S10000
G1 X175.786 Y153.723 F60000
G1 F2912
M204 S8000
G1 X175.786 Y152.939 E.02407
M73 P31 R13
G1 X174.219 Y152.939 E.04814
G1 X174.219 Y167.061 E.43389
G1 X175.786 Y167.061 E.04814
G1 X175.786 Y153.783 E.40798
M204 S10000
G1 X176.163 Y153.723 F60000
G1 F2912
M204 S8000
G1 X176.163 Y152.562 E.03566
G1 X173.842 Y152.562 E.07131
G1 X173.842 Y167.438 E.45706
G1 X176.163 Y167.438 E.07131
G1 X176.163 Y153.783 E.41956
M204 S10000
G1 X176.54 Y153.723 F60000
G1 F2912
M204 S8000
G1 X176.54 Y152.185 E.04724
G1 X173.465 Y152.185 E.09448
G1 X173.465 Y167.815 E.48023
G1 X176.54 Y167.815 E.09448
G1 X176.54 Y153.783 E.43115
M204 S10000
G1 X176.917 Y153.723 F60000
G1 F2912
M204 S8000
G1 X176.917 Y151.808 E.05883
G1 X173.088 Y151.808 E.11766
G1 X173.088 Y168.192 E.50341
G1 X176.917 Y168.192 E.11766
G1 X176.917 Y153.783 E.44273
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
G1 F2912
M204 S8000
G1 X172.697 Y168.584 E.15299
G1 X172.697 Y151.416 E.56948
G1 X177.309 Y151.416 E.15299
G1 X177.309 Y168.524 E.56749
; COOLING_NODE: 0
M204 S10000
G1 X177.716 Y168.991 F60000
G1 F2912
M204 S8000
G1 X172.29 Y168.991 E.18
G1 X172.29 Y151.009 E.59649
G1 X177.716 Y151.009 E.18
G1 X177.716 Y168.931 E.5945
; COOLING_NODE: 0
M204 S10000
G1 X178.123 Y169.398 F60000
G1 F2912
M204 S8000
G1 X171.883 Y169.398 E.207
G1 X171.883 Y150.602 E.62349
G1 X178.123 Y150.602 E.207
G1 X178.123 Y169.338 E.6215
; COOLING_NODE: 0
M204 S250
G1 X178.515 Y169.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2125
M204 S5000
G1 X171.491 Y169.79 E.21584
G1 X171.491 Y150.21 E.60164
G1 X178.515 Y150.21 E.21584
G1 X178.515 Y169.73 E.5998
;======== H2D 20260731========
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
G1 F2912
M204 S8000
G1 X175.003 Y153.782 E.44222
M204 S10000
G1 X175.408 Y153.722 F60000
; LINE_WIDTH: 0.41999
G1 F2912
M204 S8000
G1 X175.408 Y153.317 E.01247
G1 X174.597 Y153.317 E.02493
G1 X174.597 Y166.683 E.41072
G1 X175.408 Y166.683 E.02493
G1 X175.408 Y153.782 E.39641
M204 S10000
G1 X175.786 Y153.722 F60000
G1 F2912
M204 S8000
G1 X175.786 Y152.939 E.02405
G1 X174.22 Y152.939 E.0481
G1 X174.22 Y167.061 E.43389
G1 X175.786 Y167.061 E.0481
G1 X175.786 Y153.782 E.40799
M204 S10000
G1 X176.163 Y153.722 F60000
G1 F2912
M204 S8000
G1 X176.163 Y152.562 E.03564
G1 X173.843 Y152.562 E.07127
G1 X173.843 Y167.438 E.45706
G1 X176.163 Y167.438 E.07127
G1 X176.163 Y153.782 E.41958
M204 S10000
G1 X176.54 Y153.722 F60000
G1 F2912
M204 S8000
G1 X176.54 Y152.185 E.04722
G1 X173.466 Y152.185 E.09445
G1 X173.466 Y167.815 E.48023
G1 X176.54 Y167.815 E.09445
G1 X176.54 Y153.782 E.43117
M204 S10000
G1 X176.917 Y153.722 F60000
G1 F2912
M204 S8000
G1 X176.917 Y151.808 E.05881
G1 X173.089 Y151.808 E.11762
G1 X173.089 Y168.192 E.50341
G1 X176.917 Y168.192 E.11762
G1 X176.917 Y153.782 E.44275
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

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
M73 P32 R13
G3 Z1.4 I-1.216 J.037 P1  F60000
G1 X177.309 Y168.584 Z1.4
G1 Z1.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1827
M204 S8000
G1 X172.698 Y168.584 E.15295
G1 X172.698 Y151.416 E.56948
G1 X177.309 Y151.416 E.15295
G1 X177.309 Y168.524 E.56749
; COOLING_NODE: 0
M204 S10000
G1 X177.716 Y168.991 F60000
G1 F1827
M204 S8000
G1 X172.291 Y168.991 E.17996
G1 X172.291 Y151.009 E.59649
G1 X177.716 Y151.009 E.17996
G1 X177.716 Y168.931 E.5945
; COOLING_NODE: 0
M204 S10000
G1 X178.123 Y169.398 F60000
G1 F1827
M204 S8000
G1 X171.884 Y169.398 E.20696
G1 X171.884 Y150.602 E.62349
G1 X178.123 Y150.602 E.20696
G1 X178.123 Y169.338 E.6215
; COOLING_NODE: 0
M204 S250
G1 X178.515 Y169.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1827
M204 S5000
G1 X171.492 Y169.79 E.2158
G1 X171.492 Y150.21 E.60164
G1 X178.515 Y150.21 E.2158
G1 X178.515 Y169.73 E.5998
;======== H2D 20260731========
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
G1 F1827
M204 S8000
G1 X176.961 Y166.103 E.05401
G1 X176.31 Y166.663 E.02846
G3 X174.345 Y167.005 I-1.209 J-1.133 E.07101
G2 X173.046 Y165.979 I-6.385 J6.752 E.05496
G1 X173.046 Y163.488 E.08263
G1 X173.69 Y164.042 E.02817
G2 X175.655 Y164.384 I1.209 J-1.133 E.07101
G3 X176.961 Y163.354 I6.415 J6.787 E.05523
G1 X176.961 Y160.862 E.08267
G1 X176.31 Y161.422 E.02846
G3 X174.345 Y161.763 I-1.209 J-1.133 E.07101
G2 X173.046 Y160.738 I-6.385 J6.752 E.05496
G1 X173.046 Y158.247 E.08263
G1 X173.69 Y158.801 E.02817
G2 X175.655 Y159.143 I1.209 J-1.133 E.07101
G3 X176.961 Y158.113 I6.414 J6.785 E.05523
G1 X176.961 Y155.621 E.08267
G1 X176.31 Y156.18 E.02846
G3 X174.345 Y156.522 I-1.209 J-1.133 E.07101
G2 X173.046 Y155.497 I-6.384 J6.75 E.05496
G1 X173.046 Y153.006 E.08263
G1 X173.69 Y153.56 E.02817
G2 X175.655 Y153.901 I1.209 J-1.133 E.07101
G3 X176.961 Y152.871 I6.415 J6.787 E.05523
G1 X176.961 Y151.764 E.03671
G1 X176.439 Y151.764 E.0173
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
G1 F1828
M204 S8000
G1 X172.699 Y168.584 E.15291
G1 X172.699 Y151.416 E.56948
G1 X177.309 Y151.416 E.15291
G1 X177.309 Y168.524 E.56749
; COOLING_NODE: 0
M204 S10000
G1 X177.716 Y168.991 F60000
G1 F1828
M204 S8000
G1 X172.292 Y168.991 E.17992
G1 X172.292 Y151.009 E.59649
G1 X177.716 Y151.009 E.17992
G1 X177.716 Y168.931 E.5945
; COOLING_NODE: 0
M204 S10000
G1 X178.123 Y169.398 F60000
G1 F1828
M204 S8000
G1 X171.885 Y169.398 E.20692
G1 X171.885 Y150.602 E.62349
G1 X178.123 Y150.602 E.20692
G1 X178.123 Y169.338 E.6215
; COOLING_NODE: 0
M204 S250
G1 X178.515 Y169.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
M73 P33 R13
G1 F1828
M204 S5000
G1 X171.493 Y169.79 E.21577
G1 X171.493 Y150.21 E.60164
G1 X178.515 Y150.21 E.21577
G1 X178.515 Y169.73 E.5998
;======== H2D 20260731========
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
G1 F1828
M204 S8000
G1 X173.047 Y166.099 E.05401
G1 X173.69 Y166.642 E.0279
G2 X175.655 Y167.016 I1.234 J-1.136 E.0711
G3 X176.961 Y165.988 I7.759 J8.511 E.05516
G1 X176.961 Y163.472 E.08347
G1 X176.31 Y164.021 E.02824
G3 X174.345 Y164.395 I-1.234 J-1.136 E.0711
G2 X173.047 Y163.373 I-7.715 J8.459 E.05483
G1 X173.047 Y160.858 E.08344
G1 X173.69 Y161.401 E.0279
G2 X175.655 Y161.774 I1.234 J-1.136 E.0711
G3 X176.961 Y160.746 I7.759 J8.511 E.05516
G1 X176.961 Y158.23 E.08347
G1 X176.31 Y158.78 E.02824
G3 X174.345 Y159.154 I-1.234 J-1.136 E.07111
G2 X173.047 Y158.132 I-7.715 J8.459 E.05483
G1 X173.047 Y155.616 E.08344
G1 X173.69 Y156.159 E.0279
G2 X175.655 Y156.533 I1.234 J-1.136 E.07111
G3 X176.961 Y155.505 I7.759 J8.511 E.05516
G1 X176.961 Y152.989 E.08347
G1 X176.31 Y153.539 E.02824
G3 X174.345 Y153.912 I-1.234 J-1.136 E.07111
G2 X173.047 Y152.89 I-7.715 J8.459 E.05483
G1 X173.047 Y151.764 E.03735
G1 X173.55 Y151.764 E.01667
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
G1 F1826
M204 S8000
G1 X172.7 Y168.584 E.15287
G1 X172.7 Y151.416 E.56948
G1 X177.309 Y151.416 E.15287
G1 X177.309 Y168.524 E.56749
; COOLING_NODE: 0
M204 S10000
G1 X177.716 Y168.991 F60000
G1 F1826
M204 S8000
G1 X172.293 Y168.991 E.17987
G1 X172.293 Y151.009 E.59649
G1 X177.716 Y151.009 E.17987
G1 X177.716 Y168.931 E.5945
; COOLING_NODE: 0
M204 S10000
G1 X178.123 Y169.398 F60000
G1 F1826
M204 S8000
G1 X171.886 Y169.398 E.20688
G1 X171.886 Y150.602 E.62349
G1 X178.123 Y150.602 E.20688
G1 X178.123 Y169.338 E.6215
; COOLING_NODE: 0
M204 S250
G1 X178.515 Y169.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1826
M204 S5000
G1 X171.494 Y169.79 E.21573
G1 X171.494 Y150.21 E.60164
G1 X178.515 Y150.21 E.21573
G1 X178.515 Y169.73 E.5998
;======== H2D 20260731========
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
G1 F1826
M204 S8000
G1 X173.049 Y166.2 E.05401
G2 X174.017 Y167.137 I5.159 J-4.366 E.04477
G2 X175.655 Y166.918 I.614 J-1.645 E.05707
G1 X176.31 Y166.243 E.0312
G3 X176.961 Y165.844 I.894 J.729 E.02579
G1 X176.961 Y163.57 E.07542
G3 X175.983 Y164.516 I-5.211 J-4.408 E.0452
G3 X174.345 Y164.297 I-.614 J-1.646 E.05707
G1 X173.69 Y163.622 E.0312
G2 X173.049 Y163.227 I-.885 J.717 E.02546
G1 X173.049 Y160.959 E.07523
G2 X174.017 Y161.896 I5.159 J-4.367 E.04477
G2 X175.655 Y161.676 I.614 J-1.645 E.05707
G1 X176.31 Y161.002 E.0312
M73 P34 R13
G3 X176.961 Y160.603 I.894 J.729 E.02579
G1 X176.961 Y158.329 E.07542
G3 X175.983 Y159.275 I-5.21 J-4.406 E.0452
G3 X174.345 Y159.056 I-.614 J-1.645 E.05707
G1 X173.69 Y158.381 E.0312
G2 X173.049 Y157.985 I-.885 J.717 E.02546
G1 X173.049 Y155.718 E.07523
G2 X174.017 Y156.654 I5.159 J-4.366 E.04477
G2 X175.655 Y156.435 I.614 J-1.645 E.05707
G1 X176.31 Y155.76 E.0312
G3 X176.961 Y155.361 I.894 J.729 E.02579
G1 X176.961 Y153.088 E.07542
G3 X175.983 Y154.034 I-5.211 J-4.408 E.0452
G3 X174.345 Y153.815 I-.614 J-1.645 E.05707
G1 X173.69 Y153.14 E.0312
G2 X173.049 Y152.744 I-.885 J.717 E.02546
G1 X173.049 Y151.764 E.0325
G1 X173.697 Y151.764 E.02152
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
G1 F1831
M204 S8000
G1 X172.702 Y168.584 E.15283
G1 X172.702 Y151.416 E.56948
G1 X177.309 Y151.416 E.15283
G1 X177.309 Y168.524 E.56749
; COOLING_NODE: 0
M204 S10000
G1 X177.716 Y168.991 F60000
G1 F1831
M204 S8000
G1 X172.295 Y168.991 E.17983
G1 X172.295 Y151.009 E.59649
G1 X177.716 Y151.009 E.17983
G1 X177.716 Y168.931 E.5945
; COOLING_NODE: 0
M204 S10000
G1 X178.123 Y169.398 F60000
G1 F1831
M204 S8000
G1 X171.888 Y169.398 E.20684
G1 X171.888 Y150.602 E.62349
G1 X178.123 Y150.602 E.20684
G1 X178.123 Y169.338 E.6215
; COOLING_NODE: 0
M204 S250
G1 X178.515 Y169.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1820
M204 S5000
G1 X171.495 Y169.79 E.21569
G1 X171.495 Y150.21 E.60164
G1 X178.515 Y150.21 E.21569
G1 X178.515 Y169.73 E.5998
;======== H2D 20260731========
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
G1 F1831
M204 S8000
G1 X173.05 Y166.291 E.05401
G1 X173.69 Y167.159 E.03576
G1 X174.017 Y167.405 E.0136
G2 X175.655 Y166.833 I.198 J-2.062 E.05938
G1 X176.31 Y165.945 E.03662
G3 X176.961 Y165.659 I.572 J.419 E.02467
G1 X176.961 Y163.656 E.06643
G1 X176.31 Y164.538 E.03634
G1 X175.983 Y164.785 E.0136
G3 X174.345 Y164.213 I-.198 J-2.062 E.05938
G1 X173.69 Y163.324 E.03662
G2 X173.05 Y163.04 I-.565 J.41 E.02432
G1 X173.05 Y161.05 E.06601
G1 X173.69 Y161.918 E.03576
G1 X174.017 Y162.164 E.0136
G2 X175.655 Y161.592 I.198 J-2.062 E.05938
G1 X176.31 Y160.703 E.03662
G3 X176.961 Y160.418 I.572 J.419 E.02467
G1 X176.961 Y158.415 E.06643
G1 X176.31 Y159.297 E.03634
G1 X175.983 Y159.543 E.0136
G3 X174.345 Y158.971 I-.198 J-2.062 E.05938
G1 X173.69 Y158.083 E.03662
G2 X173.05 Y157.798 I-.565 J.41 E.02432
G1 X173.05 Y155.809 E.06601
G1 X173.69 Y156.676 E.03576
G1 X174.017 Y156.923 E.0136
G2 X175.655 Y156.351 I.198 J-2.062 E.05938
G1 X176.31 Y155.462 E.03662
G3 X176.961 Y155.177 I.572 J.419 E.02467
G1 X176.961 Y153.174 E.06643
G1 X176.31 Y154.056 E.03634
G1 X175.983 Y154.302 E.0136
G3 X174.345 Y153.73 I-.198 J-2.062 E.05938
G1 X173.69 Y152.841 E.03662
G2 X173.05 Y152.557 I-.565 J.41 E.02432
G1 X173.05 Y151.764 E.02629
G1 X173.886 Y151.764 E.02772
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
G1 F1942
M204 S8000
G1 X172.703 Y168.584 E.15279
G1 X172.703 Y151.416 E.56948
G1 X177.309 Y151.416 E.15279
G1 X177.309 Y168.524 E.56749
; COOLING_NODE: 0
M204 S10000
G1 X177.716 Y168.991 F60000
G1 F1942
M204 S8000
G1 X172.296 Y168.991 E.17979
G1 X172.296 Y151.009 E.59649
G1 X177.716 Y151.009 E.17979
G1 X177.716 Y168.931 E.5945
; COOLING_NODE: 0
M204 S10000
G1 X178.123 Y169.398 F60000
G1 F1942
M204 S8000
G1 X171.889 Y169.398 E.2068
M73 P35 R13
G1 X171.889 Y150.602 E.62349
G1 X178.123 Y150.602 E.2068
G1 X178.123 Y169.338 E.6215
; COOLING_NODE: 0
M204 S250
G1 X178.515 Y169.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1792
M204 S5000
G1 X171.497 Y169.79 E.21565
M73 P35 R12
G1 X171.497 Y150.21 E.60164
G1 X178.515 Y150.21 E.21565
G1 X178.515 Y169.73 E.5998
;======== H2D 20260731========
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
G1 F1942
M204 S8000
G1 X176.961 Y165.574 E.05401
G3 X176.508 Y164.914 I.648 J-.931 E.02714
G3 X176.961 Y163.745 I3.779 J.793 E.04176
G1 X176.961 Y160.333 E.1132
G3 X176.508 Y159.673 I.648 J-.931 E.02714
G3 X176.961 Y158.504 I3.779 J.793 E.04176
G1 X176.961 Y155.091 E.1132
G3 X176.508 Y154.431 I.648 J-.931 E.02714
G3 X176.961 Y153.263 I3.779 J.793 E.04176
G1 X176.961 Y151.764 E.0497
G1 X176.83 Y151.764 E.00431
M204 S10000
G1 X173.051 Y153.931 F60000
G1 F1942
M204 S8000
G1 X173.051 Y152.303 E.05401
G2 X173.483 Y151.764 I-.202 J-.605 E.0242
G1 X174.713 Y151.764 E.04079
G1 X174.025 Y152.138 E.02598
G2 X173.954 Y152.793 I.443 J.379 E.02323
G2 X174.769 Y154.104 I2.424 J-.599 E.05204
G1 X175.976 Y154.759 E.04554
G3 X176.046 Y155.414 I-.443 J.379 E.02323
G3 X175.231 Y156.724 I-2.424 J-.599 E.05204
G1 X174.025 Y157.379 E.04554
G2 X173.954 Y158.035 I.443 J.379 E.02323
G2 X174.769 Y159.345 I2.424 J-.599 E.05204
G1 X175.976 Y160 E.04554
G3 X176.046 Y160.655 I-.444 J.379 E.02323
G3 X175.231 Y161.966 I-2.424 J-.599 E.05204
G1 X174.025 Y162.621 E.04554
G2 X173.954 Y163.276 I.443 J.379 E.02323
G2 X174.769 Y164.586 I2.424 J-.599 E.05204
G1 X175.976 Y165.241 E.04554
G3 X176.046 Y165.897 I-.443 J.379 E.02323
G3 X175.231 Y167.207 I-2.424 J-.599 E.05204
G1 X174.025 Y167.862 E.04554
G1 X173.896 Y168.236 E.0131
G1 X173.051 Y168.236 E.02803
G1 X173.051 Y168.027 E.00692
G2 X173.426 Y167.207 I-.177 J-.576 E.03377
G1 X173.161 Y166.552 E.02344
G1 X173.051 Y166.421 E.00564
G1 X173.051 Y162.786 E.1206
G2 X173.426 Y161.966 I-.177 J-.576 E.03378
G1 X173.161 Y161.31 E.02344
G1 X173.051 Y161.18 E.00564
G1 X173.051 Y157.544 E.1206
G2 X173.426 Y156.724 I-.177 J-.576 E.03377
G1 X173.161 Y156.069 E.02344
G1 X173.051 Y155.939 E.00564
G1 X173.051 Y154.311 E.05401
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
G1 F1896
M204 S8000
G1 X172.704 Y168.584 E.15275
G1 X172.704 Y151.416 E.56948
G1 X177.309 Y151.416 E.15275
G1 X177.309 Y168.524 E.56749
; COOLING_NODE: 0
M204 S10000
G1 X177.716 Y168.991 F60000
G1 F1896
M204 S8000
G1 X172.297 Y168.991 E.17975
G1 X172.297 Y151.009 E.59649
G1 X177.716 Y151.009 E.17975
G1 X177.716 Y168.931 E.5945
; COOLING_NODE: 0
M204 S10000
G1 X178.123 Y169.398 F60000
G1 F1896
M204 S8000
G1 X171.89 Y169.398 E.20676
G1 X171.89 Y150.602 E.62349
G1 X178.123 Y150.602 E.20676
G1 X178.123 Y169.338 E.6215
; COOLING_NODE: 0
M204 S250
G1 X178.515 Y169.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1765
M204 S5000
G1 X171.498 Y169.79 E.21562
G1 X171.498 Y150.21 E.60164
G1 X178.515 Y150.21 E.21562
G1 X178.515 Y169.73 E.5998
;======== H2D 20260731========
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
M73 P36 R12
G1 X176.961 Y166.654 Z2.6 F60000
G1 Z2.2
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F1896
M204 S8000
G1 X176.961 Y165.025 E.05401
G3 X176.797 Y164.586 I.373 J-.389 E.01608
G1 X176.961 Y163.839 E.02539
G1 X176.961 Y159.784 E.1345
G3 X176.797 Y159.345 I.373 J-.389 E.01608
G1 X176.961 Y158.597 E.02539
G1 X176.961 Y154.543 E.1345
G3 X176.797 Y154.104 I.373 J-.389 E.01608
G1 X176.961 Y153.356 E.02539
G1 X176.961 Y151.764 E.05279
G1 X174.967 Y151.764 E.06613
G2 X174.176 Y152.793 I.721 J1.373 E.04442
G2 X174.691 Y154.104 I1.909 J.006 E.04783
G3 X175.749 Y155.086 I-1.787 J2.987 E.04827
G1 X175.824 Y155.414 E.01115
G3 X175.309 Y156.724 I-1.909 J.006 E.04783
G2 X174.251 Y157.707 I1.787 J2.987 E.04827
G1 X174.176 Y158.035 E.01115
G2 X174.691 Y159.345 I1.909 J.006 E.04783
G3 X175.749 Y160.328 I-1.787 J2.987 E.04827
G1 X175.824 Y160.655 E.01115
G3 X175.309 Y161.966 I-1.909 J.006 E.04783
G2 X174.251 Y162.948 I1.788 J2.987 E.04827
G1 X174.176 Y163.276 E.01115
G2 X174.691 Y164.586 I1.909 J.006 E.04783
G3 X175.749 Y165.569 I-1.787 J2.987 E.04827
G1 X175.824 Y165.897 E.01115
G3 X175.309 Y167.207 I-1.909 J.006 E.04783
G2 X174.251 Y168.19 I1.787 J2.987 E.04827
G1 X174.24 Y168.236 E.00156
G1 X173.052 Y168.236 E.03941
G1 X173.052 Y167.63 E.02009
G2 X173.203 Y167.207 I-.363 J-.368 E.01541
G1 X173.052 Y166.491 E.02428
G1 X173.052 Y162.389 E.13607
G2 X173.203 Y161.966 I-.363 J-.368 E.01541
G1 X173.052 Y161.249 E.02428
G1 X173.052 Y157.147 E.13607
G2 X173.203 Y156.724 I-.363 J-.368 E.01541
G1 X173.052 Y156.008 E.02428
G1 X173.052 Y154.38 E.05401
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

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z2.6 I-1.151 J.394 P1  F60000
G1 X177.309 Y168.584 Z2.6
G1 Z2.4
G1 E.8 F1800
; FEATURE: Inner wall
G1 F1777
M204 S8000
G1 X172.705 Y168.584 E.1527
G1 X172.705 Y151.416 E.56948
G1 X177.309 Y151.416 E.1527
G1 X177.309 Y168.524 E.56749
; COOLING_NODE: 0
M204 S10000
G1 X177.716 Y168.991 F60000
G1 F1777
M204 S8000
G1 X172.298 Y168.991 E.17971
G1 X172.298 Y151.009 E.59649
G1 X177.716 Y151.009 E.17971
G1 X177.716 Y168.931 E.5945
; COOLING_NODE: 0
M204 S10000
G1 X178.123 Y169.398 F60000
G1 F1777
M204 S8000
G1 X171.891 Y169.398 E.20672
G1 X171.891 Y150.602 E.62349
G1 X178.123 Y150.602 E.20672
G1 X178.123 Y169.338 E.6215
; COOLING_NODE: 0
M204 S250
G1 X178.515 Y169.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1742
M204 S5000
G1 X171.499 Y169.79 E.21558
G1 X171.499 Y150.21 E.60164
G1 X178.515 Y150.21 E.21558
G1 X178.515 Y169.73 E.5998
;======== H2D 20260731========
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
G1 X176.961 Y166.047 Z2.8 F60000
G1 Z2.4
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F1777
M204 S8000
G2 X176.951 Y163.931 I-52.917 J-.814 E.0702
G1 X176.961 Y159.177 E.15769
G2 X176.951 Y153.448 I-143.266 J-2.621 E.19005
G1 X176.961 Y151.764 E.05586
G1 X175.129 Y151.764 E.06076
G2 X174.489 Y152.466 I6.328 J6.412 E.0315
G2 X174.602 Y154.104 I1.582 J.714 E.05673
G3 X175.511 Y155.086 I-8.866 J9.11 E.04442
G3 X175.398 Y156.724 I-1.582 J.714 E.05673
G2 X174.489 Y157.707 I8.861 J9.106 E.04442
G2 X174.602 Y159.345 I1.582 J.714 E.05673
G3 X175.511 Y160.328 I-8.863 J9.107 E.04442
G3 X175.398 Y161.966 I-1.582 J.714 E.05673
G2 X174.489 Y162.948 I8.863 J9.107 E.04442
G2 X174.602 Y164.586 I1.582 J.714 E.05673
G3 X175.511 Y165.569 I-8.866 J9.11 E.04442
G3 X175.398 Y167.207 I-1.582 J.714 E.05673
G2 X174.469 Y168.236 I4.818 J5.286 E.04605
G1 X173.054 Y168.236 E.04695
G1 X173.054 Y168.022 E.00707
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
G1 F1661
M204 S8000
G1 X172.707 Y168.584 E.15266
G1 X172.707 Y151.416 E.56948
G1 X177.309 Y151.416 E.15266
G1 X177.309 Y168.524 E.56749
; COOLING_NODE: 0
M204 S10000
G1 X177.716 Y168.991 F60000
G1 F1661
M204 S8000
G1 X172.3 Y168.991 E.17967
M73 P37 R12
G1 X172.3 Y151.009 E.59649
G1 X177.716 Y151.009 E.17967
G1 X177.716 Y168.931 E.5945
; COOLING_NODE: 0
M204 S10000
G1 X178.123 Y169.398 F60000
G1 F1661
M204 S8000
G1 X171.892 Y169.398 E.20668
G1 X171.892 Y150.602 E.62349
G1 X178.123 Y150.602 E.20668
G1 X178.123 Y169.338 E.6215
; COOLING_NODE: 0
M204 S250
G1 X178.515 Y169.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1661
M204 S5000
G1 X171.5 Y169.79 E.21554
G1 X171.5 Y150.21 E.60164
G1 X178.515 Y150.21 E.21554
G1 X178.515 Y169.73 E.5998
;======== H2D 20260731========
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
G1 F1661
M204 S8000
G1 X174.692 Y168.236 E.05401
G1 X174.979 Y167.862 E.01564
G2 X175.526 Y165.897 I-1.159 J-1.381 E.07193
G1 X175.021 Y165.241 E.02744
G3 X174.475 Y163.276 I1.159 J-1.381 E.07193
G1 X174.979 Y162.621 E.02744
G2 X175.526 Y160.655 I-1.159 J-1.381 E.07193
G1 X175.021 Y160 E.02744
G3 X174.475 Y158.035 I1.159 J-1.381 E.07193
G1 X174.979 Y157.379 E.02744
G2 X175.526 Y155.414 I-1.159 J-1.381 E.07193
G1 X175.021 Y154.759 E.02744
G3 X174.475 Y152.793 I1.159 J-1.381 E.07193
G3 X175.277 Y151.764 I31.568 J23.801 E.04329
G1 X176.906 Y151.764 E.05401
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
G1 F1666
M204 S8000
G1 X172.708 Y168.584 E.15262
G1 X172.708 Y151.416 E.56948
G1 X177.309 Y151.416 E.15262
G1 X177.309 Y168.524 E.56749
; COOLING_NODE: 0
M204 S10000
G1 X177.716 Y168.991 F60000
G1 F1666
M204 S8000
G1 X172.301 Y168.991 E.17963
G1 X172.301 Y151.009 E.59649
G1 X177.716 Y151.009 E.17963
G1 X177.716 Y168.931 E.5945
; COOLING_NODE: 0
M204 S10000
G1 X178.123 Y169.398 F60000
G1 F1666
M204 S8000
G1 X171.894 Y169.398 E.20664
G1 X171.894 Y150.602 E.62349
G1 X178.123 Y150.602 E.20664
G1 X178.123 Y169.338 E.6215
; COOLING_NODE: 0
M204 S250
G1 X178.515 Y169.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1666
M204 S5000
G1 X171.502 Y169.79 E.2155
M73 P38 R12
G1 X171.502 Y150.21 E.60164
G1 X178.515 Y150.21 E.2155
G1 X178.515 Y169.73 E.5998
;======== H2D 20260731========
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
G1 F1666
M204 S8000
G1 X174.841 Y168.236 E.05401
G2 X175.469 Y167.535 I-13.118 J-12.391 E.03123
G2 X175.418 Y165.897 I-1.554 J-.771 E.05661
G3 X174.531 Y164.914 I18.39 J-17.491 E.04392
G3 X174.582 Y163.276 I1.554 J-.771 E.05661
G2 X175.469 Y162.293 I-18.373 J-17.476 E.04392
G2 X175.418 Y160.655 I-1.554 J-.771 E.05661
G3 X174.531 Y159.673 I18.396 J-17.496 E.04392
G3 X174.582 Y158.035 I1.554 J-.771 E.05661
G2 X175.469 Y157.052 I-18.384 J-17.486 E.04392
G2 X175.418 Y155.414 I-1.554 J-.771 E.05661
G3 X174.531 Y154.431 I18.39 J-17.491 E.04392
G3 X174.582 Y152.793 I1.554 J-.771 E.05661
G2 X175.491 Y151.764 I-6.72 J-6.856 E.04559
G1 X173.863 Y151.764 E.05401
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

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z3.2 I-1.208 J.151 P1  F60000
G1 X177.309 Y168.584 Z3.2
G1 Z3
G1 E.8 F1800
; FEATURE: Inner wall
G1 F1892
M204 S8000
G1 X172.709 Y168.584 E.15258
G1 X172.709 Y151.416 E.56948
G1 X177.309 Y151.416 E.15258
G1 X177.309 Y168.524 E.56749
; COOLING_NODE: 0
M204 S10000
G1 X177.716 Y168.991 F60000
G1 F1892
M204 S8000
G1 X172.302 Y168.991 E.17959
G1 X172.302 Y151.009 E.59649
G1 X177.716 Y151.009 E.17959
G1 X177.716 Y168.931 E.5945
; COOLING_NODE: 0
M204 S10000
G1 X178.123 Y169.398 F60000
G1 F1892
M204 S8000
G1 X171.895 Y169.398 E.20659
G1 X171.895 Y150.602 E.62349
G1 X178.123 Y150.602 E.20659
G1 X178.123 Y169.338 E.6215
; COOLING_NODE: 0
M204 S250
G1 X178.515 Y169.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1741
M204 S5000
G1 X171.503 Y169.79 E.21546
G1 X171.503 Y150.21 E.60164
G1 X178.515 Y150.21 E.21546
G1 X178.515 Y169.73 E.5998
;======== H2D 20260731========
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
G1 F1892
M204 S8000
G1 X176.961 Y164.006 E.05401
G1 X176.835 Y163.276 E.02458
G3 X176.961 Y162.908 I.487 J-.04 E.01328
G1 X176.961 Y158.765 E.13742
G1 X176.835 Y158.035 E.02458
G3 X176.961 Y157.666 I.487 J-.04 E.01328
G1 X176.961 Y153.524 E.13742
G1 X176.835 Y152.793 E.02458
G2 X176.961 Y151.764 I-1.733 J-.734 E.03483
G1 X175.706 Y151.764 E.0416
G3 X174.673 Y152.793 I-2.87 J-1.849 E.04874
G2 X174.307 Y154.431 I1.407 J1.175 E.05783
G2 X175.327 Y155.414 I3.367 J-2.474 E.04722
G3 X175.694 Y157.052 I-1.407 J1.175 E.05783
G3 X174.673 Y158.035 I-3.367 J-2.475 E.04722
G2 X174.307 Y159.673 I1.407 J1.175 E.05783
G2 X175.327 Y160.655 I3.367 J-2.474 E.04722
G3 X175.694 Y162.293 I-1.407 J1.175 E.05783
G3 X174.673 Y163.276 I-3.367 J-2.474 E.04722
G2 X174.307 Y164.914 I1.407 J1.175 E.05783
G2 X175.327 Y165.897 I3.367 J-2.474 E.04722
G3 X175.694 Y167.535 I-1.407 J1.175 E.05783
G3 X174.997 Y168.236 I-2.387 J-1.674 E.03294
G1 X173.057 Y168.236 E.06434
G1 X173.057 Y166.59 E.05458
G1 X173.165 Y165.897 E.02328
G2 X173.057 Y165.55 I-.453 J-.049 E.01238
G1 X173.057 Y161.349 E.13936
G1 X173.165 Y160.655 E.02328
G2 X173.057 Y160.309 I-.453 J-.049 E.01238
G1 X173.057 Y156.108 E.13936
G1 X173.165 Y155.414 E.02328
G2 X173.057 Y155.067 I-.453 J-.049 E.01238
G1 X173.057 Y153.439 E.05401
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
G1 F1932
M204 S8000
G1 X172.71 Y168.584 E.15254
G1 X172.71 Y151.416 E.56948
G1 X177.309 Y151.416 E.15254
G1 X177.309 Y168.524 E.56749
; COOLING_NODE: 0
M204 S10000
G1 X177.716 Y168.991 F60000
M73 P39 R12
G1 F1932
M204 S8000
G1 X172.303 Y168.991 E.17955
G1 X172.303 Y151.009 E.59649
G1 X177.716 Y151.009 E.17955
G1 X177.716 Y168.931 E.5945
; COOLING_NODE: 0
M204 S10000
G1 X178.123 Y169.398 F60000
G1 F1932
M204 S8000
G1 X171.896 Y169.398 E.20655
G1 X171.896 Y150.602 E.62349
G1 X178.123 Y150.602 E.20655
G1 X178.123 Y169.338 E.6215
; COOLING_NODE: 0
M204 S250
G1 X178.515 Y169.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1756
M204 S5000
G1 X171.504 Y169.79 E.21543
G1 X171.504 Y150.21 E.60164
G1 X178.515 Y150.21 E.21543
G1 X178.515 Y169.73 E.5998
;======== H2D 20260731========
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
G1 X173.11 Y168.236 Z3.6 F60000
G1 Z3.2
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F1932
M204 S8000
G1 X173.059 Y168.236 E.00172
G1 X173.059 Y166.659 E.0523
G1 X173.143 Y166.552 E.00453
G2 X173.399 Y165.569 I-1.699 J-.966 E.03407
G2 X173.059 Y165.154 I-.572 J.122 E.01848
G1 X173.059 Y161.418 E.12395
G1 X173.143 Y161.31 E.00453
G2 X173.399 Y160.328 I-1.699 J-.966 E.03407
G2 X173.059 Y159.913 I-.572 J.122 E.01848
G1 X173.059 Y156.176 E.12395
G1 X173.143 Y156.069 E.00453
G2 X173.399 Y155.086 I-1.699 J-.966 E.03407
G2 X173.059 Y154.672 I-.572 J.122 E.01848
G1 X173.059 Y153.043 E.05401
M204 S10000
G1 X176.961 Y155.243 F60000
G1 F1932
M204 S8000
G1 X176.961 Y153.614 E.05401
G3 X176.601 Y152.466 I2.557 J-1.43 E.04021
G2 X176.961 Y151.764 I-1.115 J-1.014 E.02644
G1 X176.016 Y151.764 E.03134
G1 X175.821 Y152.138 E.01398
G1 X174.753 Y152.793 E.04156
G2 X174.006 Y154.104 I1.541 J1.748 E.05097
G2 X174.179 Y154.759 I.546 J.206 E.02399
G1 X175.247 Y155.414 E.04156
G3 X175.995 Y156.724 I-1.541 J1.748 E.05097
G3 X175.821 Y157.379 I-.546 J.206 E.02399
G1 X174.753 Y158.035 E.04156
G2 X174.006 Y159.345 I1.541 J1.748 E.05097
G2 X174.179 Y160 I.546 J.206 E.02399
G1 X175.247 Y160.655 E.04156
G3 X175.995 Y161.966 I-1.54 J1.748 E.05097
G3 X175.821 Y162.621 I-.546 J.206 E.02399
G1 X174.753 Y163.276 E.04156
G2 X174.006 Y164.586 I1.541 J1.748 E.05097
G2 X174.179 Y165.241 I.546 J.206 E.02399
G1 X175.247 Y165.897 E.04156
G3 X175.995 Y167.207 I-1.54 J1.748 E.05097
G3 X175.821 Y167.862 I-.546 J.206 E.02399
G1 X175.213 Y168.236 E.02369
G1 X176.605 Y168.236 E.04618
G3 X176.961 Y167.636 I2.027 J.798 E.02322
G1 X176.961 Y164.097 E.1174
G3 X176.601 Y162.948 I2.557 J-1.43 E.04021
G3 X176.961 Y162.395 I3.859 J2.111 E.02191
G1 X176.961 Y158.856 E.1174
G3 X176.601 Y157.707 I2.557 J-1.43 E.04021
G3 X176.961 Y157.154 I3.859 J2.111 E.02191
G1 X176.961 Y155.525 E.05401
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
G1 F1832
M204 S8000
G1 X172.712 Y168.584 E.1525
G1 X172.712 Y151.416 E.56948
G1 X177.309 Y151.416 E.1525
G1 X177.309 Y168.524 E.56749
; COOLING_NODE: 0
M204 S10000
G1 X177.716 Y168.991 F60000
G1 F1832
M204 S8000
G1 X172.304 Y168.991 E.17951
G1 X172.304 Y151.009 E.59649
G1 X177.716 Y151.009 E.17951
G1 X177.716 Y168.931 E.5945
; COOLING_NODE: 0
M204 S10000
G1 X178.123 Y169.398 F60000
G1 F1832
M204 S8000
G1 X171.897 Y169.398 E.20651
G1 X171.897 Y150.602 E.62349
G1 X178.123 Y150.602 E.20651
G1 X178.123 Y169.338 E.6215
; COOLING_NODE: 0
M204 S250
G1 X178.515 Y169.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1773
M204 S5000
M73 P40 R12
G1 X171.505 Y169.79 E.21539
G1 X171.505 Y150.21 E.60164
G1 X178.515 Y150.21 E.21539
G1 X178.515 Y169.73 E.5998
;======== H2D 20260731========
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
M73 P40 R11
G1 X176.515 Y169.747 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X176.078 Y168.236 Z3.8 F60000
G1 Z3.4
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F1832
M204 S8000
G1 X176.961 Y168.236 E.02927
G1 X176.961 Y167.49 E.02474
G3 X176.31 Y167.246 I-.136 J-.626 E.02435
G1 X175.655 Y166.287 E.03853
G2 X174.345 Y165.614 I-1.588 J1.479 E.04985
G2 X173.69 Y165.858 I-.138 J.63 E.02452
G1 X173.06 Y166.78 E.03705
G1 X173.06 Y164.868 E.06342
G2 X173.69 Y164.625 I.127 J-.609 E.02368
G1 X174.345 Y163.666 E.03853
G3 X175.655 Y162.993 I1.588 J1.479 E.04985
G3 X176.31 Y163.237 I.138 J.63 E.02451
G1 X176.961 Y164.189 E.03823
G1 X176.961 Y162.248 E.06437
G3 X176.31 Y162.004 I-.136 J-.626 E.02435
G1 X175.655 Y161.045 E.03853
G2 X174.345 Y160.372 I-1.588 J1.479 E.04985
G2 X173.69 Y160.617 I-.138 J.63 E.02452
G1 X173.06 Y161.539 E.03705
G1 X173.06 Y159.627 E.06342
G2 X173.69 Y159.384 I.127 J-.609 E.02368
G1 X174.345 Y158.425 E.03853
G3 X175.655 Y157.752 I1.588 J1.479 E.04985
G3 X176.31 Y157.996 I.138 J.63 E.02451
G1 X176.961 Y158.948 E.03823
G1 X176.961 Y157.007 E.06437
G3 X176.31 Y156.763 I-.136 J-.626 E.02435
G1 X175.655 Y155.804 E.03853
G2 X174.345 Y155.131 I-1.588 J1.479 E.04985
G2 X173.69 Y155.375 I-.138 J.63 E.02452
G1 X173.06 Y156.297 E.03705
G1 X173.06 Y154.386 E.06342
G2 X173.69 Y154.142 I.127 J-.609 E.02368
G1 X174.345 Y153.183 E.03853
G3 X175.655 Y152.51 I1.588 J1.479 E.04985
G3 X176.31 Y152.755 I.138 J.63 E.02451
G1 X176.961 Y153.706 E.03823
G1 X176.961 Y152.078 E.05401
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
G1 F1824
M204 S8000
G1 X172.713 Y168.584 E.15246
G1 X172.713 Y151.416 E.56948
G1 X177.309 Y151.416 E.15246
G1 X177.309 Y168.524 E.56749
; COOLING_NODE: 0
M204 S10000
G1 X177.716 Y168.991 F60000
G1 F1824
M204 S8000
G1 X172.306 Y168.991 E.17947
G1 X172.306 Y151.009 E.59649
G1 X177.716 Y151.009 E.17947
G1 X177.716 Y168.931 E.5945
; COOLING_NODE: 0
M204 S10000
G1 X178.123 Y169.398 F60000
G1 F1824
M204 S8000
G1 X171.899 Y169.398 E.20647
G1 X171.899 Y150.602 E.62349
G1 X178.123 Y150.602 E.20647
G1 X178.123 Y169.338 E.6215
; COOLING_NODE: 0
M204 S250
G1 X178.515 Y169.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1787
M204 S5000
G1 X171.507 Y169.79 E.21535
G1 X171.507 Y150.21 E.60164
G1 X178.515 Y150.21 E.21535
G1 X178.515 Y169.73 E.5998
;======== H2D 20260731========
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
G1 F1824
M204 S8000
G1 X176.961 Y168.236 E.02277
G1 X176.961 Y167.294 E.03124
G1 X176.638 Y167.185 E.01129
G3 X175.655 Y166.204 I3.243 J-4.232 E.04619
G2 X174.345 Y165.808 I-1.128 J1.366 E.04662
G1 X174.017 Y165.919 E.01147
G2 X173.061 Y166.871 I3.147 J4.117 E.04489
G1 X173.061 Y164.666 E.07314
G1 X173.362 Y164.564 E.01054
G2 X174.345 Y163.583 I-3.243 J-4.232 E.04619
G3 X175.655 Y163.187 I1.128 J1.366 E.04662
G1 X175.983 Y163.298 E.01147
G3 X176.961 Y164.273 I-3.225 J4.21 E.04594
G1 X176.961 Y162.052 E.07367
G1 X176.638 Y161.944 E.01129
G3 X175.655 Y160.963 I3.243 J-4.232 E.04619
G2 X174.345 Y160.567 I-1.128 J1.366 E.04662
G1 X174.017 Y160.677 E.01147
G2 X173.061 Y161.629 I3.147 J4.117 E.04489
G1 X173.061 Y159.424 E.07314
G1 X173.362 Y159.323 E.01054
G2 X174.345 Y158.342 I-3.243 J-4.233 E.04619
G3 X175.655 Y157.946 I1.128 J1.366 E.04662
G1 X175.983 Y158.057 E.01147
G3 X176.961 Y159.032 I-3.224 J4.21 E.04594
G1 X176.961 Y156.811 E.07367
M73 P41 R11
G1 X176.638 Y156.702 E.01129
G3 X175.655 Y155.722 I3.243 J-4.232 E.04619
G2 X174.345 Y155.326 I-1.128 J1.366 E.04662
G1 X174.017 Y155.436 E.01147
G2 X173.061 Y156.388 I3.147 J4.117 E.04489
G1 X173.061 Y154.183 E.07314
G1 X173.362 Y154.082 E.01054
G2 X174.345 Y153.101 I-3.243 J-4.232 E.04619
G3 X175.655 Y152.705 I1.128 J1.366 E.04662
G1 X175.983 Y152.815 E.01147
G3 X176.961 Y153.791 I-3.224 J4.21 E.04594
G1 X176.961 Y152.162 E.05401
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
G1 F1825
M204 S8000
G1 X172.714 Y168.584 E.15242
G1 X172.714 Y151.416 E.56948
G1 X177.309 Y151.416 E.15242
G1 X177.309 Y168.524 E.56749
; COOLING_NODE: 0
M204 S10000
G1 X177.716 Y168.991 F60000
G1 F1825
M204 S8000
G1 X172.307 Y168.991 E.17943
G1 X172.307 Y151.009 E.59649
G1 X177.716 Y151.009 E.17943
G1 X177.716 Y168.931 E.5945
; COOLING_NODE: 0
M204 S10000
G1 X178.123 Y169.398 F60000
G1 F1825
M204 S8000
G1 X171.9 Y169.398 E.20643
G1 X171.9 Y150.602 E.62349
G1 X178.123 Y150.602 E.20643
G1 X178.123 Y169.338 E.6215
; COOLING_NODE: 0
M204 S250
G1 X178.515 Y169.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1796
M204 S5000
G1 X171.508 Y169.79 E.21531
G1 X171.508 Y150.21 E.60164
G1 X178.515 Y150.21 E.21531
G1 X178.515 Y169.73 E.5998
;======== H2D 20260731========
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
G1 F1825
M204 S8000
G1 X176.961 Y168.236 E.01776
G1 X176.961 Y167.143 E.03626
G1 X176.31 Y166.684 E.02638
G2 X174.345 Y165.957 I-1.557 J1.189 E.07335
G2 X173.062 Y166.97 I4.1 J6.514 E.0543
G1 X173.062 Y164.506 E.08173
G1 X173.69 Y164.064 E.02546
G3 X175.655 Y163.337 I1.557 J1.189 E.07335
G3 X176.961 Y164.369 I-4.182 J6.631 E.05531
G1 X176.961 Y161.901 E.08186
G1 X176.31 Y161.443 E.02638
G2 X174.345 Y160.716 I-1.557 J1.189 E.07335
G2 X173.062 Y161.728 I4.101 J6.514 E.0543
G1 X173.062 Y159.265 E.08173
G1 X173.69 Y158.822 E.02546
G3 X175.655 Y158.095 I1.557 J1.189 E.07335
G3 X176.961 Y159.128 I-4.182 J6.63 E.05531
G1 X176.961 Y156.66 E.08186
G1 X176.31 Y156.202 E.02638
G2 X174.345 Y155.475 I-1.557 J1.189 E.07335
G2 X173.062 Y156.487 I4.1 J6.514 E.0543
G1 X173.062 Y154.023 E.08173
G1 X173.69 Y153.581 E.02546
G3 X175.655 Y152.854 I1.557 J1.189 E.07335
G3 X176.961 Y153.886 I-4.182 J6.631 E.05531
G1 X176.961 Y152.258 E.05401
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
G1 F1827
M204 S8000
G1 X172.715 Y168.584 E.15238
G1 X172.715 Y151.416 E.56948
G1 X177.309 Y151.416 E.15238
G1 X177.309 Y168.524 E.56749
; COOLING_NODE: 0
M204 S10000
G1 X177.716 Y168.991 F60000
G1 F1827
M204 S8000
G1 X172.308 Y168.991 E.17938
G1 X172.308 Y151.009 E.59649
G1 X177.716 Y151.009 E.17938
G1 X177.716 Y168.931 E.5945
; COOLING_NODE: 0
M204 S10000
G1 X178.123 Y169.398 F60000
G1 F1827
M204 S8000
G1 X171.901 Y169.398 E.20639
M73 P42 R11
G1 X171.901 Y150.602 E.62349
G1 X178.123 Y150.602 E.20639
G1 X178.123 Y169.338 E.6215
; COOLING_NODE: 0
M204 S250
G1 X178.515 Y169.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1801
M204 S5000
G1 X171.509 Y169.79 E.21528
G1 X171.509 Y150.21 E.60164
G1 X178.515 Y150.21 E.21528
G1 X178.515 Y169.73 E.5998
;======== H2D 20260731========
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
G1 F1827
M204 S8000
G1 X173.063 Y168.236 E.01585
G1 X173.063 Y167.085 E.03817
G1 X173.69 Y166.621 E.02585
G3 X175.655 Y165.997 I1.454 J1.172 E.07247
G3 X176.961 Y167.022 I-8.591 J12.28 E.05509
G1 X176.961 Y164.482 E.08427
G1 X176.31 Y164 E.02684
G2 X174.345 Y163.376 I-1.454 J1.172 E.07247
G2 X173.063 Y164.382 I8.423 J12.053 E.05406
G1 X173.063 Y161.844 E.0842
G1 X173.69 Y161.38 E.02585
G3 X175.655 Y160.756 I1.454 J1.172 E.07247
G3 X176.961 Y161.781 I-8.589 J12.278 E.05509
G1 X176.961 Y159.241 E.08427
G1 X176.31 Y158.759 E.02684
G2 X174.345 Y158.135 I-1.454 J1.172 E.07247
G2 X173.063 Y159.141 I8.423 J12.053 E.05406
G1 X173.063 Y156.602 E.0842
G1 X173.69 Y156.138 E.02585
G3 X175.655 Y155.514 I1.454 J1.172 E.07247
G3 X176.961 Y156.54 I-8.591 J12.28 E.05509
G1 X176.961 Y153.999 E.08427
G1 X176.31 Y153.518 E.02684
G2 X174.345 Y152.894 I-1.454 J1.172 E.07247
G2 X173.063 Y153.899 I8.423 J12.053 E.05406
G1 X173.063 Y152.271 E.05401
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
G1 F1824
M204 S8000
G1 X172.716 Y168.584 E.15234
G1 X172.716 Y151.416 E.56948
G1 X177.309 Y151.416 E.15234
G1 X177.309 Y168.524 E.56749
; COOLING_NODE: 0
M204 S10000
G1 X177.716 Y168.991 F60000
G1 F1824
M204 S8000
G1 X172.309 Y168.991 E.17934
G1 X172.309 Y151.009 E.59649
G1 X177.716 Y151.009 E.17934
G1 X177.716 Y168.931 E.5945
; COOLING_NODE: 0
M204 S10000
G1 X178.123 Y169.398 F60000
G1 F1824
M204 S8000
G1 X171.902 Y169.398 E.20635
G1 X171.902 Y150.602 E.62349
G1 X178.123 Y150.602 E.20635
G1 X178.123 Y169.338 E.6215
; COOLING_NODE: 0
M204 S250
G1 X178.515 Y169.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1800
M204 S5000
G1 X171.51 Y169.79 E.21524
G1 X171.51 Y150.21 E.60164
G1 X178.515 Y150.21 E.21524
G1 X178.515 Y169.73 E.5998
;======== H2D 20260731========
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
G1 X173.691 Y168.236 Z4.6 F60000
G1 Z4.2
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F1824
M204 S8000
M73 P43 R11
G1 X173.065 Y168.236 E.02076
G1 X173.065 Y167.233 E.03325
G1 X173.362 Y167.114 E.01063
G2 X174.345 Y166.176 I-4.993 J-6.217 E.04511
G3 X175.655 Y165.858 I1.024 J1.361 E.04599
G1 X175.983 Y165.99 E.01171
G3 X176.961 Y166.922 I-4.964 J6.184 E.04487
G1 X176.961 Y164.622 E.07628
G1 X176.638 Y164.493 E.01153
G3 X175.655 Y163.556 I4.994 J-6.219 E.04511
G2 X174.345 Y163.238 I-1.024 J1.361 E.04599
G1 X174.017 Y163.369 E.01171
G2 X173.065 Y164.276 I4.831 J6.026 E.04369
G1 X173.065 Y161.992 E.07578
G1 X173.362 Y161.873 E.01063
G2 X174.345 Y160.935 I-4.994 J-6.218 E.04511
G3 X175.655 Y160.617 I1.024 J1.361 E.04599
G1 X175.983 Y160.748 E.01171
G3 X176.961 Y161.681 I-4.965 J6.185 E.04487
G1 X176.961 Y159.381 E.07628
G1 X176.638 Y159.252 E.01153
G3 X175.655 Y158.314 I4.994 J-6.218 E.04511
G2 X174.345 Y157.996 I-1.024 J1.361 E.04599
G1 X174.017 Y158.128 E.01171
G2 X173.065 Y159.035 I4.831 J6.027 E.04369
G1 X173.065 Y156.75 E.07578
G1 X173.362 Y156.631 E.01063
G2 X174.345 Y155.694 I-4.993 J-6.217 E.04511
G3 X175.655 Y155.376 I1.024 J1.361 E.04599
G1 X175.983 Y155.507 E.01171
G3 X176.961 Y156.44 I-4.964 J6.183 E.04487
G1 X176.961 Y154.14 E.07628
G1 X176.638 Y154.011 E.01153
G3 X175.655 Y153.073 I4.994 J-6.219 E.04511
G2 X174.345 Y152.755 I-1.024 J1.361 E.04599
G1 X174.017 Y152.886 E.01171
G2 X173.065 Y153.794 I4.831 J6.026 E.04369
G1 X173.065 Y152.165 E.05401
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
G1 F1828
M204 S8000
G1 X172.718 Y168.584 E.1523
G1 X172.718 Y151.416 E.56948
G1 X177.309 Y151.416 E.1523
G1 X177.309 Y168.524 E.56749
; COOLING_NODE: 0
M204 S10000
G1 X177.716 Y168.991 F60000
G1 F1828
M204 S8000
G1 X172.311 Y168.991 E.1793
G1 X172.311 Y151.009 E.59649
G1 X177.716 Y151.009 E.1793
G1 X177.716 Y168.931 E.5945
; COOLING_NODE: 0
M204 S10000
G1 X178.123 Y169.398 F60000
G1 F1828
M204 S8000
G1 X171.904 Y169.398 E.20631
G1 X171.904 Y150.602 E.62349
G1 X178.123 Y150.602 E.20631
G1 X178.123 Y169.338 E.6215
; COOLING_NODE: 0
M204 S250
G1 X178.515 Y169.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1791
M204 S5000
G1 X171.511 Y169.79 E.2152
G1 X171.511 Y150.21 E.60164
G1 X178.515 Y150.21 E.2152
G1 X178.515 Y169.73 E.5998
;======== H2D 20260731========
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
G1 F1828
M204 S8000
G1 X173.066 Y168.236 E.02692
G1 X173.066 Y167.419 E.0271
G2 X173.69 Y167.12 I.04 J-.718 E.02392
G1 X174.345 Y166.262 E.03582
G3 X175.655 Y165.68 I1.417 J1.424 E.04863
G3 X176.31 Y165.983 I.051 J.75 E.02498
G1 X176.961 Y166.835 E.03555
G1 X176.961 Y164.802 E.06743
G3 X176.31 Y164.5 I-.049 J-.745 E.02481
G1 X175.655 Y163.641 E.03582
G2 X174.345 Y163.059 I-1.417 J1.424 E.04863
G2 X173.69 Y163.362 I-.051 J.75 E.02498
G1 X173.066 Y164.18 E.0341
G1 X173.066 Y162.177 E.06642
G2 X173.69 Y161.879 I.04 J-.718 E.02392
G1 X174.345 Y161.021 E.03582
G3 X175.655 Y160.439 I1.417 J1.424 E.04863
G3 X176.31 Y160.742 I.051 J.75 E.02498
G1 X176.961 Y161.594 E.03555
G1 X176.961 Y159.561 E.06743
G3 X176.31 Y159.258 I-.049 J-.745 E.02481
G1 X175.655 Y158.4 E.03582
G2 X174.345 Y157.818 I-1.417 J1.424 E.04863
G2 X173.69 Y158.121 I-.051 J.749 E.02498
G1 X173.066 Y158.938 E.0341
G1 X173.066 Y156.936 E.06642
G2 X173.69 Y156.638 I.04 J-.718 E.02392
G1 X174.345 Y155.779 E.03582
G3 X175.655 Y155.197 I1.417 J1.424 E.04863
G3 X176.31 Y155.501 I.051 J.75 E.02498
G1 X176.961 Y156.352 E.03554
G1 X176.961 Y154.32 E.06743
G3 X176.31 Y154.017 I-.049 J-.745 E.02481
G1 X175.655 Y153.159 E.03582
G2 X174.345 Y152.577 I-1.417 J1.424 E.04863
G2 X173.69 Y152.88 I-.051 J.75 E.02498
G1 X173.066 Y153.697 E.0341
G1 X173.066 Y152.069 E.05401
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
G1 F1966
M204 S8000
G1 X172.719 Y168.584 E.15226
G1 X172.719 Y151.416 E.56948
G1 X177.309 Y151.416 E.15226
G1 X177.309 Y168.524 E.56749
; COOLING_NODE: 0
M204 S10000
G1 X177.716 Y168.991 F60000
G1 F1966
M204 S8000
G1 X172.312 Y168.991 E.17926
G1 X172.312 Y151.009 E.59649
G1 X177.716 Y151.009 E.17926
G1 X177.716 Y168.931 E.5945
; COOLING_NODE: 0
M204 S10000
G1 X178.123 Y169.398 F60000
M73 P44 R11
G1 F1966
M204 S8000
G1 X171.905 Y169.398 E.20627
G1 X171.905 Y150.602 E.62349
G1 X178.123 Y150.602 E.20627
G1 X178.123 Y169.338 E.6215
; COOLING_NODE: 0
M204 S250
G1 X178.515 Y169.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1776
M204 S5000
G1 X171.513 Y169.79 E.21516
G1 X171.513 Y150.21 E.60164
G1 X178.515 Y150.21 E.21516
G1 X178.515 Y169.73 E.5998
;======== H2D 20260731========
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
G1 F1966
M204 S8000
G1 X173.067 Y168.236 E.01159
G1 X173.533 Y168.236 E.01544
G2 X173.476 Y167.862 I-.381 J-.133 E.01304
G1 X173.067 Y167.683 E.0148
G1 X173.067 Y164.05 E.12051
G1 X173.453 Y163.276 E.02868
G2 X173.476 Y162.621 I-.607 J-.35 E.02263
G1 X173.067 Y162.441 E.0148
G1 X173.067 Y158.808 E.12051
G1 X173.453 Y158.035 E.02868
G2 X173.476 Y157.379 I-.607 J-.35 E.02263
G1 X173.067 Y157.2 E.0148
G1 X173.067 Y153.567 E.12051
G1 X173.453 Y152.793 E.02868
G2 X173.476 Y152.138 I-.607 J-.35 E.02263
G1 X173.067 Y151.959 E.0148
G1 X173.067 Y151.764 E.00645
G1 X173.847 Y151.764 E.02586
G2 X173.904 Y152.138 I.381 J.133 E.01305
G1 X174.65 Y152.466 E.02704
G3 X176.073 Y154.104 I-1.251 J2.524 E.07389
G3 X176.097 Y154.759 I-.607 J.35 E.02263
G1 X175.35 Y155.086 E.02704
G2 X173.927 Y156.724 I1.251 J2.524 E.07389
G2 X173.904 Y157.379 I.607 J.35 E.02263
G1 X174.65 Y157.707 E.02704
G3 X176.073 Y159.345 I-1.251 J2.524 E.07389
G3 X176.097 Y160 I-.607 J.35 E.02263
G1 X175.35 Y160.328 E.02704
G2 X173.927 Y161.966 I1.251 J2.524 E.07389
G2 X173.904 Y162.621 I.607 J.35 E.02263
G1 X174.65 Y162.948 E.02704
G3 X176.073 Y164.586 I-1.251 J2.524 E.07389
G3 X176.097 Y165.241 I-.607 J.35 E.02263
G1 X175.35 Y165.569 E.02704
G2 X173.927 Y167.207 I1.251 J2.524 E.07389
G2 X173.904 Y167.862 I.607 J.35 E.02263
G3 X174.73 Y168.236 I-1.352 J4.096 E.03015
G1 X176.961 Y168.236 E.07398
G1 X176.961 Y166.747 E.04936
G3 X176.547 Y165.897 I2.133 J-1.561 E.03155
G3 X176.524 Y165.241 I.607 J-.35 E.02263
G1 X176.961 Y165.049 E.01582
G1 X176.961 Y161.506 E.11752
G3 X176.547 Y160.655 I2.133 J-1.561 E.03155
G3 X176.524 Y160 I.607 J-.35 E.02263
G1 X176.961 Y159.808 E.01582
G1 X176.961 Y156.265 E.11752
G3 X176.547 Y155.414 I2.133 J-1.561 E.03155
G3 X176.524 Y154.759 I.607 J-.35 E.02263
G1 X176.961 Y154.566 E.01582
G1 X176.961 Y152.938 E.05401
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
G1 F1896
M204 S8000
G1 X172.72 Y168.584 E.15221
G1 X172.72 Y151.416 E.56948
G1 X177.309 Y151.416 E.15221
G1 X177.309 Y168.524 E.56749
; COOLING_NODE: 0
M204 S10000
G1 X177.716 Y168.991 F60000
G1 F1896
M204 S8000
G1 X172.313 Y168.991 E.17922
G1 X172.313 Y151.009 E.59649
G1 X177.716 Y151.009 E.17922
G1 X177.716 Y168.931 E.5945
; COOLING_NODE: 0
M204 S10000
G1 X178.123 Y169.398 F60000
G1 F1896
M204 S8000
G1 X171.906 Y169.398 E.20623
G1 X171.906 Y150.602 E.62349
G1 X178.123 Y150.602 E.20623
G1 X178.123 Y169.338 E.6215
; COOLING_NODE: 0
M204 S250
G1 X178.515 Y169.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1755
M204 S5000
G1 X171.514 Y169.79 E.21512
G1 X171.514 Y150.21 E.60164
G1 X178.515 Y150.21 E.21512
G1 X178.515 Y169.73 E.5998
;======== H2D 20260731========
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
M73 P45 R11
G1 X176.515 Y169.747 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X173.068 Y165.602 Z5.2 F60000
G1 Z4.8
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F1896
M204 S8000
G1 X173.068 Y163.974 E.05401
G1 X173.223 Y163.276 E.02372
G2 X173.068 Y162.834 I-.511 J-.069 E.01612
G1 X173.068 Y158.733 E.13605
G1 X173.223 Y158.035 E.02372
G2 X173.068 Y157.593 I-.511 J-.069 E.01612
G1 X173.068 Y153.491 E.13605
M73 P45 R10
G1 X173.223 Y152.793 E.02372
G3 X173.068 Y151.764 I2.346 J-.88 E.03477
G1 X174.212 Y151.764 E.03794
G1 X174.479 Y152.138 E.01524
G1 X175.301 Y152.793 E.03486
G3 X175.779 Y154.431 I-1.432 J1.307 E.0586
G1 X175.521 Y154.759 E.01383
G1 X174.699 Y155.414 E.03486
G2 X174.221 Y157.052 I1.432 J1.307 E.0586
G1 X174.479 Y157.379 E.01383
G1 X175.301 Y158.035 E.03486
G3 X175.779 Y159.673 I-1.432 J1.307 E.0586
G1 X175.521 Y160 E.01383
G1 X174.699 Y160.655 E.03486
G2 X174.221 Y162.293 I1.432 J1.307 E.0586
G1 X174.479 Y162.621 E.01383
G1 X175.301 Y163.276 E.03486
G3 X175.779 Y164.914 I-1.432 J1.307 E.05861
G1 X175.521 Y165.241 E.01383
G1 X174.699 Y165.897 E.03486
G2 X174.221 Y167.535 I1.432 J1.307 E.05861
G2 X174.948 Y168.236 I1.856 J-1.196 E.03379
G1 X176.961 Y168.236 E.06677
G1 X176.961 Y166.653 E.05249
G1 X176.777 Y165.897 E.02583
G3 X176.961 Y165.418 I.562 J-.059 E.01764
G1 X176.961 Y161.412 E.1329
G1 X176.777 Y160.655 E.02583
G3 X176.961 Y160.177 I.562 J-.059 E.01764
G1 X176.961 Y156.171 E.1329
G1 X176.777 Y155.414 E.02583
G3 X176.961 Y154.936 I.562 J-.059 E.01764
G1 X176.961 Y153.307 E.05401
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

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z5.2 I-1.216 J.046 P1  F60000
G1 X177.309 Y168.584 Z5.2
G1 Z5
G1 E.8 F1800
; FEATURE: Inner wall
G1 F1782
M204 S8000
G1 X172.721 Y168.584 E.15217
G1 X172.721 Y151.416 E.56948
G1 X177.309 Y151.416 E.15217
G1 X177.309 Y168.524 E.56749
; COOLING_NODE: 0
M204 S10000
G1 X177.716 Y168.991 F60000
G1 F1782
M204 S8000
G1 X172.314 Y168.991 E.17918
G1 X172.314 Y151.009 E.59649
G1 X177.716 Y151.009 E.17918
G1 X177.716 Y168.931 E.5945
; COOLING_NODE: 0
M204 S10000
G1 X178.123 Y169.398 F60000
G1 F1782
M204 S8000
G1 X171.907 Y169.398 E.20619
G1 X171.907 Y150.602 E.62349
G1 X178.123 Y150.602 E.20619
G1 X178.123 Y169.338 E.6215
; COOLING_NODE: 0
M204 S250
G1 X178.515 Y169.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1735
M204 S5000
G1 X171.515 Y169.79 E.21509
G1 X171.515 Y150.21 E.60164
G1 X178.515 Y150.21 E.21509
G1 X178.515 Y169.73 E.5998
;======== H2D 20260731========
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
G1 F1782
M204 S8000
G1 X176.961 Y168.236 E.48026
G1 X175.113 Y168.236 E.06129
G3 X174.328 Y167.207 I1.74 J-2.142 E.04333
G3 X174.612 Y165.897 I1.646 J-.329 E.04575
G2 X175.672 Y164.586 I-2.108 J-2.79 E.05647
G2 X175.388 Y163.276 I-1.646 J-.329 E.04575
G3 X174.328 Y161.966 I2.108 J-2.79 E.05647
G3 X174.612 Y160.655 I1.646 J-.329 E.04575
G2 X175.672 Y159.345 I-2.108 J-2.79 E.05647
G2 X175.388 Y158.035 I-1.646 J-.329 E.04575
G3 X174.328 Y156.724 I2.108 J-2.79 E.05647
G3 X174.612 Y155.414 I1.646 J-.329 E.04575
G2 X175.672 Y154.104 I-2.108 J-2.79 E.05647
G2 X175.388 Y152.793 I-1.646 J-.329 E.04575
G3 X174.448 Y151.764 I4.159 J-4.745 E.04633
G1 X173.07 Y151.764 E.04573
G1 X173.07 Y152.014 E.00829
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
G1 F1663
M204 S8000
G1 X172.723 Y168.584 E.15213
G1 X172.723 Y151.416 E.56948
G1 X177.309 Y151.416 E.15213
G1 X177.309 Y168.524 E.56749
; COOLING_NODE: 0
M204 S10000
G1 X177.716 Y168.991 F60000
M73 P46 R10
G1 F1663
M204 S8000
G1 X172.316 Y168.991 E.17914
G1 X172.316 Y151.009 E.59649
G1 X177.716 Y151.009 E.17914
G1 X177.716 Y168.931 E.5945
; COOLING_NODE: 0
M204 S10000
G1 X178.123 Y169.398 F60000
G1 F1663
M204 S8000
G1 X171.908 Y169.398 E.20615
G1 X171.908 Y150.602 E.62349
G1 X178.123 Y150.602 E.20615
G1 X178.123 Y169.338 E.6215
; COOLING_NODE: 0
M204 S250
G1 X178.515 Y169.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1663
M204 S5000
G1 X171.516 Y169.79 E.21505
G1 X171.516 Y150.21 E.60164
G1 X178.515 Y150.21 E.21505
G1 X178.515 Y169.73 E.5998
;======== H2D 20260731========
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
G1 X176.89 Y168.236 Z5.6 F60000
G1 Z5.2
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F1663
M204 S8000
G1 X175.262 Y168.236 E.05401
G3 X174.462 Y167.207 I15.147 J-12.595 E.04322
G3 X175.041 Y165.241 I1.744 J-.554 E.07214
G1 X175.538 Y164.586 E.02727
G2 X174.959 Y162.621 I-1.744 J-.554 E.07214
G1 X174.462 Y161.966 E.02727
G3 X175.041 Y160 I1.744 J-.554 E.07214
G1 X175.538 Y159.345 E.02727
G2 X174.959 Y157.379 I-1.744 J-.554 E.07214
G1 X174.462 Y156.724 E.02727
G3 X175.041 Y154.759 I1.744 J-.554 E.07214
G1 X175.538 Y154.104 E.02727
G2 X174.959 Y152.138 I-1.744 J-.554 E.07214
G1 X174.676 Y151.764 E.01555
G1 X173.071 Y151.788 E.05324
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
G1 F1665
M204 S8000
G1 X172.724 Y168.584 E.15209
G1 X172.724 Y151.416 E.56948
G1 X177.309 Y151.416 E.15209
G1 X177.309 Y168.524 E.56749
; COOLING_NODE: 0
M204 S10000
G1 X177.716 Y168.991 F60000
G1 F1665
M204 S8000
G1 X172.317 Y168.991 E.1791
G1 X172.317 Y151.009 E.59649
G1 X177.716 Y151.009 E.1791
G1 X177.716 Y168.931 E.5945
; COOLING_NODE: 0
M204 S10000
G1 X178.123 Y169.398 F60000
G1 F1665
M204 S8000
G1 X171.91 Y169.398 E.2061
G1 X171.91 Y150.602 E.62349
G1 X178.123 Y150.602 E.2061
G1 X178.123 Y169.338 E.6215
; COOLING_NODE: 0
M204 S250
G1 X178.515 Y169.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1665
M204 S5000
M73 P47 R10
G1 X171.518 Y169.79 E.21501
G1 X171.518 Y150.21 E.60164
G1 X178.515 Y150.21 E.21501
G1 X178.515 Y169.73 E.5998
;======== H2D 20260731========
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
G1 F1665
M204 S8000
G1 X176.961 Y168.236 E.00464
G1 X175.472 Y168.236 E.04938
G2 X174.572 Y167.207 I-9.162 J7.109 E.04537
G1 X174.337 Y166.552 E.02308
G3 X174.838 Y165.241 I1.494 J-.18 E.04841
G2 X175.613 Y163.276 I-1.197 J-1.607 E.07381
G2 X174.572 Y161.966 I-4.315 J2.36 E.05579
G1 X174.337 Y161.31 E.02308
G3 X174.838 Y160 I1.494 J-.18 E.04841
G2 X175.613 Y158.035 I-1.197 J-1.607 E.07381
G2 X174.572 Y156.724 I-4.315 J2.36 E.05579
G1 X174.337 Y156.069 E.02308
G3 X174.838 Y154.759 I1.494 J-.18 E.04841
G2 X175.613 Y152.793 I-1.197 J-1.607 E.07381
G2 X174.825 Y151.764 I-3.398 J1.786 E.04319
G1 X173.197 Y151.764 E.05401
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

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z5.8 I-1.206 J.163 P1  F60000
G1 X177.309 Y168.584 Z5.8
G1 Z5.6
G1 E.8 F1800
; FEATURE: Inner wall
G1 F1889
M204 S8000
G1 X172.725 Y168.584 E.15205
G1 X172.725 Y151.416 E.56948
G1 X177.309 Y151.416 E.15205
G1 X177.309 Y168.524 E.56749
; COOLING_NODE: 0
M204 S10000
G1 X177.716 Y168.991 F60000
G1 F1889
M204 S8000
G1 X172.318 Y168.991 E.17906
G1 X172.318 Y151.009 E.59649
G1 X177.716 Y151.009 E.17906
G1 X177.716 Y168.931 E.5945
; COOLING_NODE: 0
M204 S10000
G1 X178.123 Y169.398 F60000
G1 F1889
M204 S8000
G1 X171.911 Y169.398 E.20606
G1 X171.911 Y150.602 E.62349
G1 X178.123 Y150.602 E.20606
G1 X178.123 Y169.338 E.6215
; COOLING_NODE: 0
M204 S250
G1 X178.515 Y169.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1741
M204 S5000
G1 X171.519 Y169.79 E.21497
G1 X171.519 Y150.21 E.60164
G1 X178.515 Y150.21 E.21497
G1 X178.515 Y169.73 E.5998
;======== H2D 20260731========
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
G1 F1889
M204 S8000
G1 X173.073 Y164.826 E.05401
G1 X173.147 Y164.586 E.00832
G1 X173.073 Y163.929 E.02193
G1 X173.073 Y159.585 E.14412
G1 X173.147 Y159.345 E.00832
G1 X173.073 Y158.688 E.02193
G1 X173.073 Y154.344 E.14412
G1 X173.147 Y154.104 E.00832
G1 X173.073 Y153.447 E.02193
G1 X173.073 Y151.764 E.0558
G1 X174.979 Y151.764 E.06323
G3 X175.767 Y152.793 I-1.002 J1.583 E.0439
G3 X175.336 Y154.104 I-1.803 J.132 E.04696
G2 X174.333 Y155.086 I2.69 J3.748 E.04675
G1 X174.233 Y155.414 E.01136
G2 X174.664 Y156.724 I1.803 J.132 E.04696
G3 X175.667 Y157.707 I-2.69 J3.748 E.04675
G1 X175.767 Y158.035 E.01136
G3 X175.336 Y159.345 I-1.803 J.132 E.04696
G2 X174.333 Y160.328 I2.69 J3.747 E.04675
G1 X174.233 Y160.655 E.01136
G2 X174.664 Y161.966 I1.803 J.132 E.04696
G3 X175.667 Y162.948 I-2.69 J3.748 E.04675
G1 X175.767 Y163.276 E.01136
G3 X175.336 Y164.586 I-1.803 J.132 E.04696
G2 X174.333 Y165.569 I2.69 J3.748 E.04675
G1 X174.233 Y165.897 E.01136
G2 X174.664 Y167.207 I1.803 J.132 E.04696
G3 X175.681 Y168.236 I-2.07 J3.062 E.04829
G1 X176.961 Y168.236 E.04244
G1 X176.961 Y167.543 E.02298
G3 X176.926 Y166.552 I1.351 J-.544 E.03357
G1 X176.961 Y162.302 E.14099
G3 X176.926 Y161.31 I1.351 J-.544 E.03357
G1 X176.961 Y157.06 E.14099
G3 X176.926 Y156.069 I1.351 J-.544 E.03357
G1 X176.961 Y154.374 E.05624
; CHANGE_LAYER
; Z_HEIGHT: 5.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F8843.478
M73 P48 R10
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
G1 F1925
M204 S8000
G1 X172.726 Y168.584 E.15201
G1 X172.726 Y151.416 E.56948
G1 X177.309 Y151.416 E.15201
G1 X177.309 Y168.524 E.56749
; COOLING_NODE: 0
M204 S10000
G1 X177.716 Y168.991 F60000
G1 F1925
M204 S8000
G1 X172.319 Y168.991 E.17902
G1 X172.319 Y151.009 E.59649
G1 X177.716 Y151.009 E.17902
G1 X177.716 Y168.931 E.5945
; COOLING_NODE: 0
M204 S10000
G1 X178.123 Y169.398 F60000
G1 F1925
M204 S8000
G1 X171.912 Y169.398 E.20602
G1 X171.912 Y150.602 E.62349
G1 X178.123 Y150.602 E.20602
G1 X178.123 Y169.338 E.6215
; COOLING_NODE: 0
M204 S250
G1 X178.515 Y169.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1757
M204 S5000
G1 X171.52 Y169.79 E.21493
G1 X171.52 Y150.21 E.60164
G1 X178.515 Y150.21 E.21493
G1 X178.515 Y169.73 E.5998
;======== H2D 20260731========
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
G1 F1925
M204 S8000
G1 X173.075 Y165.285 E.05401
G2 X173.349 Y164.586 I-.502 J-.601 E.02596
G1 X173.075 Y163.852 E.02601
G1 X173.075 Y160.043 E.12634
G2 X173.349 Y159.345 I-.502 J-.601 E.02596
G1 X173.075 Y158.611 E.02601
G1 X173.075 Y154.802 E.12634
G2 X173.349 Y154.104 I-.502 J-.601 E.02596
G1 X173.075 Y153.369 E.02601
G1 X173.098 Y151.764 E.05324
M204 S10000
G1 X176.961 Y159.172 F60000
G1 F1925
M204 S8000
G1 X176.961 Y157.544 E.05401
G2 X176.643 Y157.052 I-10.508 J6.429 E.01941
G3 X176.961 Y155.913 I2.659 J.127 E.03954
G1 X176.961 Y152.302 E.11978
G2 X176.643 Y151.811 I-10.508 J6.429 E.01941
G1 X176.644 Y151.764 E.00153
G1 X175.182 Y151.764 E.0485
G1 X175.762 Y152.138 E.02289
G1 X175.977 Y152.466 E.013
G3 X175.255 Y154.104 I-2.404 J-.082 E.06085
G1 X174.238 Y154.759 E.04012
G1 X174.023 Y155.086 E.013
G2 X174.746 Y156.724 I2.404 J-.082 E.06085
G1 X175.762 Y157.379 E.04012
G1 X175.977 Y157.707 E.013
G3 X175.255 Y159.345 I-2.404 J-.082 E.06085
G1 X174.238 Y160 E.04012
G1 X174.023 Y160.328 E.013
G2 X174.746 Y161.966 I2.404 J-.082 E.06085
G1 X175.762 Y162.621 E.04012
G1 X175.977 Y162.948 E.013
G3 X175.255 Y164.586 I-2.404 J-.082 E.06085
G1 X174.238 Y165.241 E.04012
G1 X174.023 Y165.569 E.013
G2 X174.746 Y167.207 I2.404 J-.082 E.06085
G1 X175.762 Y167.862 E.04012
G1 X175.976 Y168.236 E.01428
G1 X176.961 Y168.236 E.03265
G2 X176.643 Y167.535 I-.982 J.022 E.02623
G3 X176.961 Y166.396 I2.659 J.127 E.03954
G1 X176.961 Y162.785 E.11978
G2 X176.643 Y162.293 I-10.514 J6.433 E.01941
G3 X176.961 Y161.155 I2.659 J.127 E.03954
G1 X176.961 Y159.526 E.05401
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
G1 F1862
M204 S8000
G1 X172.728 Y168.584 E.15197
G1 X172.728 Y151.416 E.56948
G1 X177.309 Y151.416 E.15197
G1 X177.309 Y168.524 E.56749
; COOLING_NODE: 0
M204 S10000
G1 X177.716 Y168.991 F60000
G1 F1862
M204 S8000
G1 X172.32 Y168.991 E.17898
G1 X172.32 Y151.009 E.59649
G1 X177.716 Y151.009 E.17898
G1 X177.716 Y168.931 E.5945
; COOLING_NODE: 0
M204 S10000
G1 X178.123 Y169.398 F60000
G1 F1862
M204 S8000
G1 X171.913 Y169.398 E.20598
G1 X171.913 Y150.602 E.62349
G1 X178.123 Y150.602 E.20598
G1 X178.123 Y169.338 E.6215
; COOLING_NODE: 0
M204 S250
G1 X178.515 Y169.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
M73 P49 R10
G1 F1772
M204 S5000
G1 X171.521 Y169.79 E.2149
G1 X171.521 Y150.21 E.60164
G1 X178.515 Y150.21 E.2149
G1 X178.515 Y169.73 E.5998
;======== H2D 20260731========
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
G1 X174.97 Y168.236 Z6.4 F60000
G1 Z6
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F1862
M204 S8000
G1 X176.961 Y168.211 E.06604
G1 X176.961 Y166.302 E.06331
G1 X176.31 Y167.296 E.03938
G1 X175.983 Y167.515 E.01308
G3 X174.345 Y166.809 I.046 J-2.359 E.06068
G1 X173.69 Y165.808 E.03969
G2 X173.076 Y165.59 I-.468 J.343 E.02295
G1 X173.076 Y163.737 E.06147
G1 X173.69 Y164.675 E.03719
G1 X174.017 Y164.895 E.01308
G2 X175.655 Y164.188 I-.046 J-2.359 E.06068
G1 X176.31 Y163.187 E.03969
G3 X176.961 Y162.969 I.486 J.37 E.02415
G1 X176.961 Y161.061 E.06331
G1 X176.31 Y162.054 E.03938
G1 X175.983 Y162.274 E.01308
G3 X174.345 Y161.568 I.046 J-2.359 E.06068
G1 X173.69 Y160.567 E.03969
G2 X173.076 Y160.349 I-.468 J.344 E.02295
G1 X173.076 Y158.496 E.06147
G1 X173.69 Y159.434 E.03719
G1 X174.017 Y159.653 E.01308
G2 X175.655 Y158.947 I-.046 J-2.359 E.06068
G1 X176.31 Y157.946 E.03969
G3 X176.961 Y157.728 I.486 J.37 E.02415
G1 X176.961 Y155.82 E.06331
G1 X176.31 Y156.813 E.03938
G1 X175.983 Y157.033 E.01308
G3 X174.345 Y156.326 I.046 J-2.359 E.06068
G1 X173.69 Y155.325 E.03969
G2 X173.076 Y155.107 I-.468 J.344 E.02295
G1 X173.076 Y153.254 E.06147
G1 X173.69 Y154.192 E.03719
G1 X174.017 Y154.412 E.01308
G2 X175.655 Y153.706 I-.046 J-2.359 E.06068
G1 X176.31 Y152.705 E.03969
G3 X176.961 Y152.487 I.486 J.37 E.02415
G1 X176.961 Y151.764 E.02396
G3 X175.577 Y151.764 I-.692 J-11.746 E.04593
G1 X173.948 Y151.764 E.05401
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
G1 F1822
M204 S8000
G1 X172.729 Y168.584 E.15193
G1 X172.729 Y151.416 E.56948
G1 X177.309 Y151.416 E.15193
G1 X177.309 Y168.524 E.56749
; COOLING_NODE: 0
M204 S10000
G1 X177.716 Y168.991 F60000
G1 F1822
M204 S8000
G1 X172.322 Y168.991 E.17893
G1 X172.322 Y151.009 E.59649
G1 X177.716 Y151.009 E.17893
G1 X177.716 Y168.931 E.5945
; COOLING_NODE: 0
M204 S10000
G1 X178.123 Y169.398 F60000
G1 F1822
M204 S8000
G1 X171.915 Y169.398 E.20594
G1 X171.915 Y150.602 E.62349
G1 X178.123 Y150.602 E.20594
G1 X178.123 Y169.338 E.6215
; COOLING_NODE: 0
M204 S250
G1 X178.515 Y169.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1786
M204 S5000
G1 X171.523 Y169.79 E.21486
G1 X171.523 Y150.21 E.60164
G1 X178.515 Y150.21 E.21486
G1 X178.515 Y169.73 E.5998
;======== H2D 20260731========
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
G1 X176.961 Y167.847 Z6.6 F60000
G1 Z6.2
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F1822
M204 S8000
G1 X176.961 Y166.219 E.05401
G3 X175.983 Y167.21 I-3.837 J-2.807 E.04635
G3 X174.345 Y166.89 I-.513 J-1.727 E.05756
G1 X173.69 Y166.164 E.03245
G2 X173.077 Y165.804 I-.75 J.575 E.02417
G1 X173.077 Y163.64 E.07179
M73 P50 R10
G2 X174.017 Y164.589 I3.678 J-2.701 E.04449
G2 X175.655 Y164.27 I.513 J-1.727 E.05756
G1 X176.31 Y163.543 E.03245
G3 X176.961 Y163.171 I.783 J.615 E.02547
G1 X176.961 Y160.977 E.07278
G3 X175.983 Y161.969 I-3.837 J-2.807 E.04635
G3 X174.345 Y161.649 I-.513 J-1.727 E.05756
G1 X173.69 Y160.923 E.03245
G2 X173.077 Y160.563 I-.75 J.575 E.02417
G1 X173.077 Y158.398 E.07179
G2 X174.017 Y159.348 I3.678 J-2.701 E.04449
G2 X175.655 Y159.028 I.513 J-1.727 E.05756
G1 X176.31 Y158.302 E.03245
G3 X176.961 Y157.93 I.783 J.615 E.02547
G1 X176.961 Y155.736 E.07278
G3 X175.983 Y156.727 I-3.837 J-2.807 E.04635
G3 X174.345 Y156.408 I-.513 J-1.727 E.05756
G1 X173.69 Y155.681 E.03245
G2 X173.077 Y155.321 I-.75 J.575 E.02417
G1 X173.077 Y153.157 E.07179
G2 X174.017 Y154.107 I3.678 J-2.701 E.04449
G2 X175.655 Y153.787 I.513 J-1.727 E.05756
G1 X176.31 Y153.061 E.03245
G3 X176.961 Y152.689 I.783 J.615 E.02547
G1 X176.961 Y151.764 E.03066
M73 P50 R9
G1 X176.257 Y151.764 E.02335
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
G1 F1824
M204 S8000
G1 X172.73 Y168.584 E.15189
G1 X172.73 Y151.416 E.56948
G1 X177.309 Y151.416 E.15189
G1 X177.309 Y168.524 E.56749
; COOLING_NODE: 0
M204 S10000
G1 X177.716 Y168.991 F60000
G1 F1824
M204 S8000
G1 X172.323 Y168.991 E.17889
G1 X172.323 Y151.009 E.59649
G1 X177.716 Y151.009 E.17889
G1 X177.716 Y168.931 E.5945
; COOLING_NODE: 0
M204 S10000
G1 X178.123 Y169.398 F60000
G1 F1824
M204 S8000
G1 X171.916 Y169.398 E.2059
G1 X171.916 Y150.602 E.62349
G1 X178.123 Y150.602 E.2059
G1 X178.123 Y169.338 E.6215
; COOLING_NODE: 0
M204 S250
G1 X178.515 Y169.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1795
M204 S5000
G1 X171.524 Y169.79 E.21482
G1 X171.524 Y150.21 E.60164
G1 X178.515 Y150.21 E.21482
G1 X178.515 Y169.73 E.5998
;======== H2D 20260731========
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
G1 F1824
M204 S8000
G1 X176.961 Y166.124 E.05401
G3 X175.655 Y167.16 I-4.814 J-4.728 E.05541
G3 X174.345 Y166.984 I-.458 J-1.555 E.04518
G2 X173.078 Y165.974 I-4.691 J4.586 E.05387
G1 X173.078 Y163.538 E.08079
G2 X174.345 Y164.539 I4.656 J-4.59 E.05369
G2 X175.655 Y164.363 I.458 J-1.555 E.04518
G3 X176.961 Y163.326 I4.819 J4.728 E.05543
G1 X176.961 Y160.883 E.08105
G3 X175.655 Y161.919 I-4.814 J-4.728 E.05541
G3 X174.345 Y161.742 I-.458 J-1.555 E.04518
G2 X173.078 Y160.733 I-4.691 J4.586 E.05387
G1 X173.078 Y158.297 E.08079
G2 X174.345 Y159.298 I4.656 J-4.59 E.05369
G2 X175.655 Y159.122 I.458 J-1.555 E.04518
G3 X176.961 Y158.085 I4.819 J4.728 E.05543
G1 X176.961 Y155.642 E.08105
G3 X175.655 Y156.677 I-4.814 J-4.728 E.05541
G3 X174.345 Y156.501 I-.458 J-1.555 E.04518
G2 X173.078 Y155.491 I-4.692 J4.587 E.05387
G1 X173.078 Y153.056 E.08079
G2 X174.345 Y154.057 I4.656 J-4.59 E.05369
G2 X175.655 Y153.88 I.458 J-1.555 E.04518
G3 X176.961 Y152.844 I4.819 J4.728 E.05543
G1 X176.961 Y151.764 E.0358
G1 X176.412 Y151.764 E.01821
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
G1 F1826
M204 S8000
G1 X172.731 Y168.584 E.15185
G1 X172.731 Y151.416 E.56948
G1 X177.309 Y151.416 E.15185
G1 X177.309 Y168.524 E.56749
; COOLING_NODE: 0
M204 S10000
G1 X177.716 Y168.991 F60000
G1 F1826
M204 S8000
G1 X172.324 Y168.991 E.17885
G1 X172.324 Y151.009 E.59649
G1 X177.716 Y151.009 E.17885
G1 X177.716 Y168.931 E.5945
; COOLING_NODE: 0
M204 S10000
G1 X178.123 Y169.398 F60000
M73 P51 R9
G1 F1826
M204 S8000
G1 X171.917 Y169.398 E.20586
G1 X171.917 Y150.602 E.62349
G1 X178.123 Y150.602 E.20586
G1 X178.123 Y169.338 E.6215
; COOLING_NODE: 0
M204 S250
G1 X178.515 Y169.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1799
M204 S5000
G1 X171.525 Y169.79 E.21478
G1 X171.525 Y150.21 E.60164
G1 X178.515 Y150.21 E.21478
G1 X178.515 Y169.73 E.5998
;======== H2D 20260731========
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
G1 F1826
M204 S8000
G1 X173.08 Y166.102 E.05401
G1 X173.69 Y166.6 E.02613
G2 X175.655 Y167.038 I1.286 J-1.144 E.07135
G3 X176.961 Y166.014 I13.866 J16.325 E.05506
G1 X176.961 Y163.449 E.08507
G1 X176.31 Y163.98 E.02783
G3 X174.345 Y164.417 I-1.286 J-1.144 E.07135
G2 X173.08 Y163.423 I-13.46 J15.827 E.0534
G1 X173.08 Y160.861 E.08498
G1 X173.69 Y161.359 E.02613
G2 X175.655 Y161.797 I1.286 J-1.144 E.07135
G3 X176.961 Y160.772 I13.87 J16.329 E.05506
G1 X176.961 Y158.208 E.08507
G1 X176.31 Y158.738 E.02784
G3 X174.345 Y159.176 I-1.286 J-1.144 E.07135
G2 X173.08 Y158.182 I-13.463 J15.831 E.0534
G1 X173.08 Y155.62 E.08498
G1 X173.69 Y156.118 E.02613
G2 X175.655 Y156.555 I1.286 J-1.144 E.07135
G3 X176.961 Y155.531 I13.866 J16.325 E.05506
G1 X176.961 Y152.966 E.08507
G1 X176.31 Y153.497 E.02783
G3 X174.345 Y153.935 I-1.286 J-1.144 E.07135
G2 X173.08 Y152.94 I-13.46 J15.827 E.0534
G1 X173.08 Y151.764 E.039
G1 X173.532 Y151.764 E.01501
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
G1 F1822
M204 S8000
G1 X172.732 Y168.584 E.15181
G1 X172.732 Y151.416 E.56948
G1 X177.309 Y151.416 E.15181
G1 X177.309 Y168.524 E.56749
; COOLING_NODE: 0
M204 S10000
G1 X177.716 Y168.991 F60000
G1 F1822
M204 S8000
G1 X172.325 Y168.991 E.17881
G1 X172.325 Y151.009 E.59649
G1 X177.716 Y151.009 E.17881
G1 X177.716 Y168.931 E.5945
; COOLING_NODE: 0
M204 S10000
G1 X178.123 Y169.398 F60000
G1 F1822
M204 S8000
G1 X171.918 Y169.398 E.20582
G1 X171.918 Y150.602 E.62349
G1 X178.123 Y150.602 E.20582
G1 X178.123 Y169.338 E.6215
; COOLING_NODE: 0
M204 S250
G1 X178.515 Y169.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1797
M204 S5000
G1 X171.526 Y169.79 E.21475
G1 X171.526 Y150.21 E.60164
G1 X178.515 Y150.21 E.21475
G1 X178.515 Y169.73 E.5998
;======== H2D 20260731========
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
M73 P52 R9
G1 E-.04 F1800
M204 S10000
G1 X173.081 Y167.841 Z7.2 F60000
G1 Z6.8
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F1822
M204 S8000
G1 X173.081 Y166.212 E.05401
G2 X174.017 Y167.092 I6.639 J-6.133 E.04265
G2 X175.655 Y166.937 I.675 J-1.605 E.05684
G1 X176.31 Y166.292 E.0305
G3 X176.961 Y165.876 I.976 J.812 E.026
G1 X176.961 Y163.551 E.07713
G3 X175.983 Y164.471 I-6.943 J-6.4 E.04457
G3 X174.345 Y164.316 I-.675 J-1.605 E.05684
G2 X173.081 Y163.273 I-2.775 J2.075 E.05489
G1 X173.081 Y160.971 E.07636
G2 X174.017 Y161.85 I6.639 J-6.133 E.04265
G2 X175.655 Y161.695 I.675 J-1.605 E.05684
G1 X176.31 Y161.05 E.0305
G3 X176.961 Y160.635 I.976 J.812 E.026
G1 X176.961 Y158.31 E.07713
G3 X175.983 Y159.23 I-6.943 J-6.401 E.04457
G3 X174.345 Y159.075 I-.675 J-1.605 E.05684
G2 X173.081 Y158.032 I-2.775 J2.075 E.05489
G1 X173.081 Y155.73 E.07636
G2 X174.017 Y156.609 I6.639 J-6.133 E.04265
G2 X175.655 Y156.454 I.675 J-1.605 E.05684
G1 X176.31 Y155.809 E.0305
G3 X176.961 Y155.394 I.976 J.812 E.026
G1 X176.961 Y153.068 E.07713
G3 X175.983 Y153.988 I-6.943 J-6.4 E.04457
G3 X174.345 Y153.833 I-.675 J-1.605 E.05684
G2 X173.081 Y152.79 I-2.775 J2.075 E.05489
G1 X173.081 Y151.764 E.03403
G1 X173.683 Y151.764 E.01998
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
G1 F1824
M204 S8000
G1 X172.734 Y168.584 E.15176
G1 X172.734 Y151.416 E.56948
G1 X177.309 Y151.416 E.15176
G1 X177.309 Y168.524 E.56749
; COOLING_NODE: 0
M204 S10000
G1 X177.716 Y168.991 F60000
G1 F1824
M204 S8000
G1 X172.327 Y168.991 E.17877
G1 X172.327 Y151.009 E.59649
G1 X177.716 Y151.009 E.17877
G1 X177.716 Y168.931 E.5945
; COOLING_NODE: 0
M204 S10000
G1 X178.123 Y169.398 F60000
G1 F1824
M204 S8000
G1 X171.92 Y169.398 E.20578
G1 X171.92 Y150.602 E.62349
G1 X178.123 Y150.602 E.20578
G1 X178.123 Y169.338 E.6215
; COOLING_NODE: 0
M204 S250
G1 X178.515 Y169.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1788
M204 S5000
G1 X171.527 Y169.79 E.21471
G1 X171.527 Y150.21 E.60164
G1 X178.515 Y150.21 E.21471
G1 X178.515 Y169.73 E.5998
;======== H2D 20260731========
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
G1 X173.082 Y167.942 Z7.4 F60000
G1 Z7
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F1824
M204 S8000
G1 X173.082 Y166.314 E.05401
G1 X173.69 Y167.084 E.03256
G1 X174.017 Y167.341 E.0138
G2 X175.655 Y166.85 I.314 J-1.929 E.05871
G1 X176.31 Y166.019 E.0351
G3 X176.961 Y165.702 I.631 J.468 E.02494
G1 X176.961 Y163.639 E.06841
G1 X176.31 Y164.464 E.03483
G1 X175.983 Y164.72 E.0138
G3 X174.345 Y164.229 I-.314 J-1.929 E.05871
G1 X173.69 Y163.398 E.0351
G2 X173.082 Y163.089 I-.602 J.431 E.02351
G1 X173.082 Y161.073 E.06689
G1 X173.69 Y161.843 E.03256
G1 X174.017 Y162.1 E.0138
G2 X175.655 Y161.608 I.314 J-1.929 E.05871
G1 X176.31 Y160.778 E.0351
G3 X176.961 Y160.46 I.631 J.468 E.02494
G1 X176.961 Y158.398 E.06841
G1 X176.31 Y159.222 E.03483
G1 X175.983 Y159.479 E.0138
G3 X174.345 Y158.988 I-.314 J-1.929 E.05871
G1 X173.69 Y158.157 E.0351
G2 X173.082 Y157.848 I-.602 J.431 E.02351
G1 X173.082 Y155.831 E.06689
G1 X173.69 Y156.602 E.03256
G1 X174.017 Y156.858 E.0138
G2 X175.655 Y156.367 I.314 J-1.929 E.05871
G1 X176.31 Y155.536 E.0351
G3 X176.961 Y155.219 I.631 J.468 E.02494
G1 X176.961 Y153.157 E.06841
G1 X176.31 Y153.981 E.03483
G1 X175.983 Y154.238 E.0138
G3 X174.345 Y153.747 I-.314 J-1.929 E.05871
G1 X173.69 Y152.916 E.0351
G2 X173.082 Y152.606 I-.602 J.431 E.02351
G1 X173.082 Y151.764 E.02793
G1 X173.868 Y151.764 E.02609
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
G1 F1926
M204 S8000
G1 X172.735 Y168.584 E.15172
G1 X172.735 Y151.416 E.56948
G1 X177.309 Y151.416 E.15172
G1 X177.309 Y168.524 E.56749
; COOLING_NODE: 0
M204 S10000
G1 X177.716 Y168.991 F60000
G1 F1926
M204 S8000
G1 X172.328 Y168.991 E.17873
M73 P53 R9
G1 X172.328 Y151.009 E.59649
G1 X177.716 Y151.009 E.17873
G1 X177.716 Y168.931 E.5945
; COOLING_NODE: 0
M204 S10000
G1 X178.123 Y169.398 F60000
G1 F1926
M204 S8000
G1 X171.921 Y169.398 E.20574
G1 X171.921 Y150.602 E.62349
G1 X178.123 Y150.602 E.20574
G1 X178.123 Y169.338 E.6215
; COOLING_NODE: 0
M204 S250
G1 X178.515 Y169.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1772
M204 S5000
G1 X171.529 Y169.79 E.21467
G1 X171.529 Y150.21 E.60164
G1 X178.515 Y150.21 E.21467
G1 X178.515 Y169.73 E.5998
;======== H2D 20260731========
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
G1 X175.424 Y168.236 Z7.6 F60000
G1 Z7.2
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F1926
M204 S8000
G1 X173.796 Y168.236 E.05401
G1 X173.69 Y168.012 E.0082
G2 X173.083 Y168.074 I-.226 J.785 E.02073
G1 X173.083 Y167.046 E.0341
M204 S10000
G1 X173.083 Y164.789 F60000
G1 F1926
M204 S8000
G1 X173.083 Y166.418 E.05401
G3 X173.69 Y167.712 I-5.039 J3.151 E.04753
G1 X174.017 Y167.737 E.0109
G2 X175.328 Y167.12 I-1.352 J-4.57 E.04823
G2 X176.31 Y165.392 I-3.186 J-2.955 E.06655
G3 X176.961 Y165.467 I.231 J.846 E.02225
G1 X176.961 Y163.719 E.05799
G2 X176.31 Y165.091 I5.339 J3.37 E.05049
G1 X175.983 Y165.117 E.0109
G3 X174.672 Y164.5 I1.352 J-4.57 E.04823
G3 X173.69 Y162.771 I3.186 J-2.955 E.06655
G2 X173.083 Y162.833 I-.226 J.785 E.02073
G1 X173.083 Y164.461 E.05401
M204 S10000
G1 X173.083 Y159.548 F60000
G1 F1926
M204 S8000
G1 X173.083 Y161.176 E.05401
G3 X173.69 Y162.471 I-5.039 J3.151 E.04753
G1 X174.017 Y162.496 E.0109
G2 X175.328 Y161.879 I-1.352 J-4.57 E.04823
G2 X176.31 Y160.15 I-3.186 J-2.955 E.06655
G3 X176.961 Y160.226 I.231 J.846 E.02225
G1 X176.961 Y158.478 E.05799
G2 X176.31 Y159.85 I5.339 J3.37 E.05049
G1 X175.983 Y159.876 E.0109
G3 X174.672 Y159.258 I1.352 J-4.57 E.04823
G3 X173.69 Y157.53 I3.186 J-2.955 E.06655
G2 X173.083 Y157.592 I-.226 J.785 E.02073
G1 X173.083 Y159.22 E.05401
M204 S10000
G1 X173.083 Y154.307 F60000
G1 F1926
M204 S8000
G1 X173.083 Y155.935 E.05401
G3 X173.69 Y157.229 I-5.039 J3.151 E.04753
G1 X174.017 Y157.255 E.0109
G2 X175.328 Y156.638 I-1.352 J-4.569 E.04823
G2 X176.31 Y154.909 I-3.186 J-2.955 E.06655
G3 X176.961 Y154.985 I.231 J.846 E.02225
G1 X176.961 Y153.237 E.05799
G2 X176.31 Y154.609 I5.339 J3.37 E.05049
G1 X175.983 Y154.634 E.0109
G3 X174.672 Y154.017 I1.352 J-4.57 E.04823
G3 X173.69 Y152.288 I3.186 J-2.955 E.06655
G2 X173.083 Y152.35 I-.226 J.785 E.02073
G1 X173.083 Y151.764 E.01944
G1 X173.598 Y151.764 E.01707
G1 X173.69 Y151.988 E.00802
G2 X174.676 Y151.764 I.164 J-1.566 E.03415
G1 X176.304 Y151.764 E.05401
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
G1 F1898
M204 S8000
G1 X172.736 Y168.584 E.15168
G1 X172.736 Y151.416 E.56948
G1 X177.309 Y151.416 E.15168
G1 X177.309 Y168.524 E.56749
; COOLING_NODE: 0
M204 S10000
G1 X177.716 Y168.991 F60000
G1 F1898
M204 S8000
G1 X172.329 Y168.991 E.17869
G1 X172.329 Y151.009 E.59649
G1 X177.716 Y151.009 E.17869
G1 X177.716 Y168.931 E.5945
; COOLING_NODE: 0
M204 S10000
G1 X178.123 Y169.398 F60000
G1 F1898
M204 S8000
G1 X171.922 Y169.398 E.2057
G1 X171.922 Y150.602 E.62349
G1 X178.123 Y150.602 E.2057
G1 X178.123 Y169.338 E.6215
; COOLING_NODE: 0
M204 S250
G1 X178.515 Y169.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1752
M204 S5000
G1 X171.53 Y169.79 E.21463
G1 X171.53 Y150.21 E.60164
G1 X178.515 Y150.21 E.21463
G1 X178.515 Y169.73 E.5998
;======== H2D 20260731========
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
M73 P54 R9
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
G1 F1898
M204 S8000
G1 X176.961 Y165.107 E.05401
G3 X176.756 Y164.586 I.382 J-.451 E.01933
G1 X176.961 Y163.82 E.0263
G1 X176.961 Y159.866 E.13118
G3 X176.756 Y159.345 I.382 J-.451 E.01933
G1 X176.961 Y158.579 E.0263
G1 X176.961 Y154.624 E.13118
G3 X176.756 Y154.104 I.382 J-.451 E.01933
G1 X176.961 Y153.338 E.0263
G1 X176.961 Y151.764 E.05219
G1 X174.928 Y151.764 E.06742
G2 X174.135 Y152.793 I.556 J1.248 E.04489
G2 X174.708 Y154.104 I1.991 J-.089 E.04851
G1 X175.556 Y154.759 E.03556
G3 X175.865 Y155.414 I-.455 J.615 E.02502
G3 X175.293 Y156.724 I-1.991 J-.089 E.04851
G1 X174.444 Y157.379 E.03556
G2 X174.135 Y158.035 I.455 J.615 E.02502
G2 X174.708 Y159.345 I1.991 J-.089 E.04851
G1 X175.556 Y160 E.03556
G3 X175.865 Y160.655 I-.455 J.615 E.02502
G3 X175.293 Y161.966 I-1.991 J-.089 E.04851
G1 X174.444 Y162.621 E.03556
G2 X174.135 Y163.276 I.455 J.615 E.02502
G2 X174.708 Y164.586 I1.991 J-.089 E.04851
G1 X175.556 Y165.241 E.03556
G3 X175.865 Y165.897 I-.455 J.615 E.02502
G3 X175.293 Y167.207 I-1.991 J-.089 E.04851
G1 X174.444 Y167.862 E.03556
G1 X174.183 Y168.236 E.01512
G1 X173.084 Y168.236 E.03643
G1 X173.084 Y167.67 E.01877
G2 X173.244 Y167.207 I-.351 J-.38 E.01692
G1 X173.084 Y166.525 E.02322
G1 X173.084 Y162.428 E.1359
G2 X173.244 Y161.966 I-.351 J-.38 E.01692
G1 X173.084 Y161.284 E.02322
G1 X173.084 Y157.187 E.1359
G2 X173.244 Y156.724 I-.351 J-.38 E.01692
G1 X173.084 Y156.043 E.02322
G1 X173.084 Y154.414 E.05401
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

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z7.8 I-1.152 J.392 P1  F60000
G1 X177.309 Y168.584 Z7.8
G1 Z7.6
G1 E.8 F1800
; FEATURE: Inner wall
G1 F1778
M204 S8000
G1 X172.737 Y168.584 E.15164
G1 X172.737 Y151.416 E.56948
G1 X177.309 Y151.416 E.15164
G1 X177.309 Y168.524 E.56749
; COOLING_NODE: 0
M204 S10000
G1 X177.716 Y168.991 F60000
G1 F1778
M204 S8000
G1 X172.33 Y168.991 E.17865
G1 X172.33 Y151.009 E.59649
G1 X177.716 Y151.009 E.17865
G1 X177.716 Y168.931 E.5945
; COOLING_NODE: 0
M204 S10000
G1 X178.123 Y169.398 F60000
G1 F1778
M204 S8000
G1 X171.923 Y169.398 E.20566
G1 X171.923 Y150.602 E.62349
G1 X178.123 Y150.602 E.20566
G1 X178.123 Y169.338 E.6215
; COOLING_NODE: 0
M204 S250
G1 X178.515 Y169.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1732
M204 S5000
G1 X171.531 Y169.79 E.21459
G1 X171.531 Y150.21 E.60164
G1 X178.515 Y150.21 E.21459
G1 X178.515 Y169.73 E.5998
;======== H2D 20260731========
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
G1 F1778
M204 S8000
G1 X176.961 Y151.764 E.48159
G1 X175.097 Y151.764 E.0618
G2 X174.446 Y152.466 I4.027 J4.397 E.03179
G2 X174.621 Y154.104 I1.617 J.655 E.05691
G3 X175.554 Y155.086 I-5.634 J6.284 E.045
G3 X175.379 Y156.724 I-1.617 J.655 E.05691
G2 X174.446 Y157.707 I5.632 J6.282 E.045
G2 X174.621 Y159.345 I1.617 J.655 E.05691
G3 X175.554 Y160.328 I-5.633 J6.283 E.045
G3 X175.379 Y161.966 I-1.617 J.655 E.05691
G2 X174.446 Y162.948 I5.633 J6.283 E.045
G2 X174.621 Y164.586 I1.617 J.655 E.05691
G3 X175.554 Y165.569 I-5.634 J6.284 E.045
G3 X175.379 Y167.207 I-1.617 J.655 E.05691
G2 X174.427 Y168.236 I3.644 J4.326 E.04661
G1 X173.086 Y168.236 E.04449
G1 X173.086 Y167.949 E.00952
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
M73 P55 R9
G3 Z8 I-.28 J1.184 P1  F60000
G1 X177.309 Y168.584 Z8
G1 Z7.8
G1 E.8 F1800
; FEATURE: Inner wall
G1 F1659
M204 S8000
G1 X172.739 Y168.584 E.1516
G1 X172.739 Y151.416 E.56948
G1 X177.309 Y151.416 E.1516
G1 X177.309 Y168.524 E.56749
; COOLING_NODE: 0
M204 S10000
G1 X177.716 Y168.991 F60000
G1 F1659
M204 S8000
M73 P55 R8
G1 X172.332 Y168.991 E.17861
G1 X172.332 Y151.009 E.59649
G1 X177.716 Y151.009 E.17861
G1 X177.716 Y168.931 E.5945
; COOLING_NODE: 0
M204 S10000
G1 X178.123 Y169.398 F60000
G1 F1659
M204 S8000
G1 X171.924 Y169.398 E.20561
G1 X171.924 Y150.602 E.62349
G1 X178.123 Y150.602 E.20561
G1 X178.123 Y169.338 E.6215
; COOLING_NODE: 0
M204 S250
G1 X178.515 Y169.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1659
M204 S5000
G1 X171.532 Y169.79 E.21456
G1 X171.532 Y150.21 E.60164
G1 X178.515 Y150.21 E.21456
G1 X178.515 Y169.73 E.5998
;======== H2D 20260731========
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
G1 F1659
M204 S8000
G1 X174.66 Y168.236 E.05401
G3 X175.479 Y167.207 I10.749 J7.719 E.04364
G2 X175.062 Y165.241 I-1.558 J-.697 E.07126
G1 X174.521 Y164.586 E.02818
G3 X174.938 Y162.621 I1.558 J-.697 E.07126
G1 X175.479 Y161.966 E.02818
G2 X175.062 Y160 I-1.558 J-.697 E.07126
G1 X174.521 Y159.345 E.02818
G3 X174.938 Y157.379 I1.558 J-.697 E.07126
G1 X175.479 Y156.724 E.02818
G2 X175.062 Y154.759 I-1.558 J-.697 E.07126
G1 X174.521 Y154.104 E.02818
G3 X174.938 Y152.138 I1.558 J-.697 E.07126
G1 X175.246 Y151.764 E.01607
G1 X173.618 Y151.764 E.05401
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
G1 F1664
M204 S8000
G1 X172.74 Y168.584 E.15156
G1 X172.74 Y151.416 E.56948
G1 X177.309 Y151.416 E.15156
G1 X177.309 Y168.524 E.56749
; COOLING_NODE: 0
M204 S10000
G1 X177.716 Y168.991 F60000
G1 F1664
M204 S8000
G1 X172.333 Y168.991 E.17857
G1 X172.333 Y151.009 E.59649
G1 X177.716 Y151.009 E.17857
G1 X177.716 Y168.931 E.5945
; COOLING_NODE: 0
M204 S10000
G1 X178.123 Y169.398 F60000
G1 F1664
M204 S8000
G1 X171.926 Y169.398 E.20557
G1 X171.926 Y150.602 E.62349
G1 X178.123 Y150.602 E.20557
G1 X178.123 Y169.338 E.6215
; COOLING_NODE: 0
M204 S250
G1 X178.515 Y169.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
M73 P56 R8
G1 F1664
M204 S5000
G1 X171.534 Y169.79 E.21452
G1 X171.534 Y150.21 E.60164
G1 X178.515 Y150.21 E.21452
G1 X178.515 Y169.73 E.5998
;======== H2D 20260731========
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
G1 F1664
M204 S8000
G1 X174.81 Y168.236 E.05401
G2 X175.599 Y167.207 I-4.167 J-4.013 E.04309
G2 X175.439 Y165.897 I-1.543 J-.476 E.04511
G3 X174.401 Y164.586 I5.293 J-5.258 E.05556
G3 X174.561 Y163.276 I1.543 J-.476 E.04511
G2 X175.599 Y161.966 I-5.292 J-5.257 E.05556
G2 X175.439 Y160.655 I-1.543 J-.476 E.04511
G3 X174.401 Y159.345 I5.293 J-5.258 E.05556
G3 X174.561 Y158.035 I1.543 J-.476 E.04511
G2 X175.599 Y156.724 I-5.292 J-5.257 E.05556
G2 X175.439 Y155.414 I-1.543 J-.476 E.04511
G3 X174.401 Y154.104 I5.293 J-5.258 E.05556
G3 X174.561 Y152.793 I1.543 J-.476 E.04511
G2 X175.402 Y151.764 I-4.142 J-4.241 E.04416
G1 X173.774 Y151.764 E.05401
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

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z8.4 I-1.207 J.156 P1  F60000
G1 X177.309 Y168.584 Z8.4
G1 Z8.2
G1 E.8 F1800
; FEATURE: Inner wall
G1 F1885
M204 S8000
G1 X172.741 Y168.584 E.15152
G1 X172.741 Y151.416 E.56948
G1 X177.309 Y151.416 E.15152
G1 X177.309 Y168.524 E.56749
; COOLING_NODE: 0
M204 S10000
G1 X177.716 Y168.991 F60000
G1 F1885
M204 S8000
G1 X172.334 Y168.991 E.17853
G1 X172.334 Y151.009 E.59649
G1 X177.716 Y151.009 E.17853
G1 X177.716 Y168.931 E.5945
; COOLING_NODE: 0
M204 S10000
G1 X178.123 Y169.398 F60000
G1 F1885
M204 S8000
G1 X171.927 Y169.398 E.20553
G1 X171.927 Y150.602 E.62349
G1 X178.123 Y150.602 E.20553
G1 X178.123 Y169.338 E.6215
; COOLING_NODE: 0
M204 S250
G1 X178.515 Y169.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1739
M204 S5000
G1 X171.535 Y169.79 E.21448
G1 X171.535 Y150.21 E.60164
G1 X178.515 Y150.21 E.21448
G1 X178.515 Y169.73 E.5998
;======== H2D 20260731========
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
G1 X176.961 Y165.618 Z8.6 F60000
G1 Z8.2
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F1885
M204 S8000
G1 X176.961 Y163.99 E.05401
G1 X176.871 Y163.276 E.02387
G1 X176.961 Y163.005 E.00947
G1 X176.961 Y158.749 E.14118
G1 X176.871 Y158.035 E.02387
G1 X176.961 Y157.763 E.00947
G1 X176.961 Y153.507 E.14118
G1 X176.871 Y152.793 E.02387
G1 X176.961 Y152.522 E.00947
G1 X176.961 Y151.764 E.02513
G1 X175.657 Y151.764 E.04325
G3 X174.656 Y152.793 I-3.323 J-2.233 E.04788
G2 X174.358 Y154.431 I1.409 J1.102 E.05743
G2 X175.345 Y155.414 I4.081 J-3.109 E.04633
G3 X175.642 Y157.052 I-1.409 J1.102 E.05743
G3 X174.656 Y158.035 I-4.081 J-3.109 E.04633
G2 X174.358 Y159.673 I1.409 J1.102 E.05743
G2 X175.345 Y160.655 I4.082 J-3.11 E.04633
G3 X175.642 Y162.293 I-1.409 J1.102 E.05743
M73 P57 R8
G3 X174.656 Y163.276 I-4.081 J-3.109 E.04633
G2 X174.358 Y164.914 I1.409 J1.102 E.05743
G2 X175.345 Y165.897 I4.081 J-3.109 E.04633
G3 X175.642 Y167.535 I-1.409 J1.102 E.05743
G3 X174.963 Y168.236 I-2.899 J-2.129 E.03247
G1 X173.089 Y168.236 E.06214
G3 X173.129 Y165.897 I12.951 J-.95 E.0777
G1 X173.089 Y161.094 E.15933
G2 X173.089 Y160.535 I-.645 J-.279 E.01906
G1 X173.089 Y155.852 E.15533
G2 X173.089 Y153.665 I-21.216 J-1.094 E.07258
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
G1 F1922
M204 S8000
G1 X172.742 Y168.584 E.15148
G1 X172.742 Y151.416 E.56948
G1 X177.309 Y151.416 E.15148
G1 X177.309 Y168.524 E.56749
; COOLING_NODE: 0
M204 S10000
G1 X177.716 Y168.991 F60000
G1 F1922
M204 S8000
G1 X172.335 Y168.991 E.17849
G1 X172.335 Y151.009 E.59649
G1 X177.716 Y151.009 E.17849
G1 X177.716 Y168.931 E.5945
; COOLING_NODE: 0
M204 S10000
G1 X178.123 Y169.398 F60000
G1 F1922
M204 S8000
G1 X171.928 Y169.398 E.20549
G1 X171.928 Y150.602 E.62349
G1 X178.123 Y150.602 E.20549
G1 X178.123 Y169.338 E.6215
; COOLING_NODE: 0
M204 S250
G1 X178.515 Y169.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1754
M204 S5000
G1 X171.536 Y169.79 E.21444
G1 X171.536 Y150.21 E.60164
G1 X178.515 Y150.21 E.21444
G1 X178.515 Y169.73 E.5998
;======== H2D 20260731========
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
G1 F1922
M204 S8000
G1 X173.127 Y166.552 E.05567
G2 X173.317 Y165.569 I-1.392 J-.779 E.03377
G1 X173.091 Y165.243 E.01318
G1 X173.127 Y161.31 E.13044
G2 X173.317 Y160.328 I-1.392 J-.779 E.03377
G1 X173.091 Y160.001 E.01318
G1 X173.127 Y156.069 E.13044
G2 X173.317 Y155.086 I-1.392 J-.779 E.03377
G1 X173.091 Y154.76 E.01318
G1 X173.091 Y153.132 E.05401
M204 S10000
G1 X176.961 Y160.464 F60000
G1 F1922
M204 S8000
G1 X176.961 Y158.836 E.05401
G3 X176.683 Y157.707 I2.187 J-1.136 E.03893
G2 X176.961 Y157.287 I-1.781 J-1.479 E.01673
G1 X176.961 Y153.595 E.12249
G3 X176.683 Y152.466 I2.187 J-1.136 E.03893
G2 X176.961 Y151.764 I-.477 J-.594 E.02617
G1 X175.939 Y151.764 E.03389
G1 X175.71 Y152.138 E.01453
G1 X174.738 Y152.793 E.03891
G2 X174.054 Y154.104 I1.487 J1.609 E.05001
G2 X174.29 Y154.759 I.616 J.148 E.02445
G1 X175.263 Y155.414 E.03891
G3 X175.946 Y156.724 I-1.487 J1.609 E.05001
G3 X175.71 Y157.379 I-.616 J.148 E.02445
G1 X174.738 Y158.035 E.03891
G2 X174.054 Y159.345 I1.487 J1.609 E.05001
G2 X174.29 Y160 I.616 J.148 E.02445
G1 X175.263 Y160.655 E.03891
G3 X175.946 Y161.966 I-1.487 J1.609 E.05001
G3 X175.71 Y162.621 I-.616 J.148 E.02445
G1 X174.738 Y163.276 E.03891
G2 X174.054 Y164.586 I1.487 J1.609 E.05001
G2 X174.29 Y165.241 I.616 J.148 E.02445
G1 X175.263 Y165.897 E.03891
G3 X175.938 Y167.535 I-1.605 J1.62 E.06036
G3 X175.156 Y168.236 I-1.291 J-.653 E.03565
G1 X176.682 Y168.236 E.05062
G3 X176.961 Y167.77 I3.56 J1.814 E.01802
G1 X176.961 Y164.077 E.12249
G3 X176.683 Y162.948 I2.187 J-1.136 E.03893
G2 X176.961 Y162.528 I-1.781 J-1.479 E.01673
G1 X176.961 Y160.9 E.05401
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
G1 F1864
M204 S8000
G1 X172.744 Y168.584 E.15144
G1 X172.744 Y151.416 E.56948
G1 X177.309 Y151.416 E.15144
G1 X177.309 Y168.524 E.56749
; COOLING_NODE: 0
M204 S10000
G1 X177.716 Y168.991 F60000
G1 F1864
M204 S8000
G1 X172.336 Y168.991 E.17844
G1 X172.336 Y151.009 E.59649
G1 X177.716 Y151.009 E.17844
G1 X177.716 Y168.931 E.5945
; COOLING_NODE: 0
M204 S10000
G1 X178.123 Y169.398 F60000
G1 F1864
M204 S8000
G1 X171.929 Y169.398 E.20545
M73 P58 R8
G1 X171.929 Y150.602 E.62349
G1 X178.123 Y150.602 E.20545
G1 X178.123 Y169.338 E.6215
; COOLING_NODE: 0
M204 S250
G1 X178.515 Y169.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1770
M204 S5000
G1 X171.537 Y169.79 E.2144
G1 X171.537 Y150.21 E.60164
G1 X178.515 Y150.21 E.2144
G1 X178.515 Y169.73 E.5998
;======== H2D 20260731========
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
G1 F1864
M204 S8000
G1 X175.512 Y168.236 E.05401
G3 X176.091 Y168.236 I.29 J.686 E.01973
G1 X176.961 Y168.236 E.02883
G1 X176.961 Y167.538 E.02314
G3 X176.31 Y167.352 I-.193 J-.553 E.02391
G1 X175.655 Y166.302 E.04104
G2 X174.345 Y165.566 I-1.723 J1.53 E.05079
G2 X173.69 Y165.752 I-.196 J.557 E.02408
G1 X173.092 Y166.709 E.03745
G1 X173.092 Y164.92 E.05935
G2 X173.69 Y164.731 I.165 J-.518 E.02217
G1 X174.345 Y163.682 E.04104
G3 X175.655 Y162.945 I1.723 J1.53 E.05079
G3 X176.31 Y163.131 I.196 J.557 E.02408
G1 X176.961 Y164.172 E.04072
G1 X176.961 Y162.297 E.06222
G3 X176.31 Y162.111 I-.193 J-.553 E.02391
G1 X175.655 Y161.061 E.04104
G2 X174.345 Y160.324 I-1.723 J1.53 E.05079
G2 X173.69 Y160.51 I-.196 J.557 E.02408
G1 X173.092 Y161.468 E.03745
G1 X173.092 Y159.679 E.05935
G2 X173.69 Y159.49 I.165 J-.518 E.02217
G1 X174.345 Y158.44 E.04104
G3 X175.655 Y157.704 I1.723 J1.53 E.05079
G3 X176.31 Y157.89 I.196 J.557 E.02408
G1 X176.961 Y158.931 E.04072
G1 X176.961 Y157.055 E.06222
G3 X176.31 Y156.869 I-.193 J-.553 E.02391
G1 X175.655 Y155.82 E.04104
G2 X174.345 Y155.083 I-1.723 J1.53 E.05079
G2 X173.69 Y155.269 I-.196 J.557 E.02408
G1 X173.092 Y156.227 E.03745
G1 X173.092 Y154.438 E.05935
G2 X173.69 Y154.249 I.165 J-.518 E.02217
G1 X174.345 Y153.199 E.04104
G3 X175.655 Y152.463 I1.723 J1.53 E.05079
G3 X176.31 Y152.648 I.196 J.557 E.02408
G1 X176.961 Y153.69 E.04072
G1 X176.961 Y151.814 E.06222
G3 X176.529 Y151.764 I-.181 J-.33 E.01536
G1 X174.901 Y151.764 E.05401
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
G1 F1821
M204 S8000
G1 X172.745 Y168.584 E.1514
G1 X172.745 Y151.416 E.56948
G1 X177.309 Y151.416 E.1514
G1 X177.309 Y168.524 E.56749
; COOLING_NODE: 0
M204 S10000
G1 X177.716 Y168.991 F60000
G1 F1821
M204 S8000
G1 X172.338 Y168.991 E.1784
G1 X172.338 Y151.009 E.59649
G1 X177.716 Y151.009 E.1784
G1 X177.716 Y168.931 E.5945
; COOLING_NODE: 0
M204 S10000
G1 X178.123 Y169.398 F60000
G1 F1821
M204 S8000
G1 X171.931 Y169.398 E.20541
G1 X171.931 Y150.602 E.62349
G1 X178.123 Y150.602 E.20541
G1 X178.123 Y169.338 E.6215
; COOLING_NODE: 0
M204 S250
G1 X178.515 Y169.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1783
M204 S5000
G1 X171.539 Y169.79 E.21437
G1 X171.539 Y150.21 E.60164
G1 X178.515 Y150.21 E.21437
G1 X178.515 Y169.73 E.5998
;======== H2D 20260731========
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
M73 P59 R8
G1 X176.238 Y168.236 Z9.2 F60000
G1 Z8.8
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F1821
M204 S8000
G1 X176.961 Y168.236 E.02397
G1 X176.961 Y167.33 E.03005
G1 X176.638 Y167.236 E.01114
G3 X175.655 Y166.222 I2.569 J-3.473 E.04705
G2 X174.345 Y165.772 I-1.204 J1.375 E.04713
G1 X174.017 Y165.867 E.01132
G2 X173.093 Y166.815 I2.397 J3.263 E.04411
G1 X173.093 Y164.694 E.07037
G1 X173.362 Y164.615 E.0093
G2 X174.345 Y163.601 I-2.569 J-3.473 E.04705
G3 X175.655 Y163.152 I1.204 J1.375 E.04713
G1 X175.983 Y163.247 E.01132
G3 X176.961 Y164.255 I-2.554 J3.454 E.0468
G1 X176.961 Y162.088 E.07187
G1 X176.638 Y161.995 E.01114
G3 X175.655 Y160.981 I2.569 J-3.473 E.04705
G2 X174.345 Y160.531 I-1.204 J1.375 E.04713
G1 X174.017 Y160.626 E.01132
G2 X173.093 Y161.574 I2.397 J3.263 E.04411
G1 X173.093 Y159.452 E.07037
G1 X173.362 Y159.374 E.0093
G2 X174.345 Y158.36 I-2.569 J-3.473 E.04705
G3 X175.655 Y157.91 I1.204 J1.375 E.04713
G1 X175.983 Y158.005 E.01132
G3 X176.961 Y159.014 I-2.553 J3.454 E.0468
G1 X176.961 Y156.847 E.07187
G1 X176.638 Y156.753 E.01114
G3 X175.655 Y155.739 I2.569 J-3.473 E.04705
G2 X174.345 Y155.29 I-1.204 J1.375 E.04713
G1 X174.017 Y155.385 E.01132
G2 X173.093 Y156.332 I2.397 J3.263 E.0441
G1 X173.093 Y154.211 E.07037
G1 X173.362 Y154.133 E.0093
G2 X174.345 Y153.119 I-2.569 J-3.473 E.04705
G3 X175.655 Y152.669 I1.204 J1.375 E.04713
G1 X175.983 Y152.764 E.01132
G3 X176.961 Y153.773 I-2.554 J3.454 E.0468
G1 X176.961 Y152.144 E.05401
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
G1 F1820
M204 S8000
G1 X172.746 Y168.584 E.15136
G1 X172.746 Y151.416 E.56948
G1 X177.309 Y151.416 E.15136
G1 X177.309 Y168.524 E.56749
; COOLING_NODE: 0
M204 S10000
G1 X177.716 Y168.991 F60000
G1 F1820
M204 S8000
G1 X172.339 Y168.991 E.17836
G1 X172.339 Y151.009 E.59649
G1 X177.716 Y151.009 E.17836
G1 X177.716 Y168.931 E.5945
; COOLING_NODE: 0
M204 S10000
G1 X178.123 Y169.398 F60000
G1 F1820
M204 S8000
G1 X171.932 Y169.398 E.20537
G1 X171.932 Y150.602 E.62349
G1 X178.123 Y150.602 E.20537
G1 X178.123 Y169.338 E.6215
; COOLING_NODE: 0
M204 S250
G1 X178.515 Y169.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1792
M204 S5000
G1 X171.54 Y169.79 E.21433
G1 X171.54 Y150.21 E.60164
G1 X178.515 Y150.21 E.21433
G1 X178.515 Y169.73 E.5998
;======== H2D 20260731========
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
G1 F1820
M204 S8000
G1 X176.961 Y168.236 E.01872
G1 X176.961 Y167.172 E.03529
G3 X176.31 Y166.728 I.499 J-1.429 E.02642
G2 X174.345 Y165.929 I-1.633 J1.201 E.07406
G2 X173.094 Y166.919 I2.063 J3.893 E.05319
G1 X173.094 Y164.524 E.07943
G2 X173.69 Y164.107 I-.477 J-1.314 E.0244
G3 X175.655 Y163.309 I1.633 J1.201 E.07406
G3 X176.961 Y164.348 I-2.166 J4.06 E.05565
G1 X176.961 Y161.93 E.0802
G3 X176.31 Y161.487 I.499 J-1.429 E.02642
G2 X174.345 Y160.688 I-1.633 J1.201 E.07406
G2 X173.094 Y161.677 I2.063 J3.893 E.05319
G1 X173.094 Y159.283 E.07943
G2 X173.69 Y158.866 I-.477 J-1.314 E.02439
G3 X175.655 Y158.067 I1.633 J1.201 E.07406
G3 X176.961 Y159.107 I-2.167 J4.061 E.05565
G1 X176.961 Y156.689 E.0802
G3 X176.31 Y156.245 I.499 J-1.429 E.02642
G2 X174.345 Y155.447 I-1.633 J1.201 E.07406
G2 X173.094 Y156.436 I2.063 J3.893 E.05319
G1 X173.094 Y154.042 E.07943
G2 X173.69 Y153.625 I-.477 J-1.314 E.0244
G3 X175.655 Y152.826 I1.633 J1.201 E.07406
G3 X176.961 Y153.865 I-2.166 J4.06 E.05565
G1 X176.961 Y152.237 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 9.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F8843.478
G1 X176.961 Y153.865 E-.61876
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
G1 F1825
M204 S8000
G1 X172.747 Y168.584 E.15132
G1 X172.747 Y151.416 E.56948
G1 X177.309 Y151.416 E.15132
G1 X177.309 Y168.524 E.56749
; COOLING_NODE: 0
M204 S10000
G1 X177.716 Y168.991 F60000
G1 F1825
M204 S8000
G1 X172.34 Y168.991 E.17832
M73 P60 R8
G1 X172.34 Y151.009 E.59649
G1 X177.716 Y151.009 E.17832
G1 X177.716 Y168.931 E.5945
; COOLING_NODE: 0
M204 S10000
G1 X178.123 Y169.398 F60000
G1 F1825
M204 S8000
M73 P60 R7
G1 X171.933 Y169.398 E.20533
G1 X171.933 Y150.602 E.62349
G1 X178.123 Y150.602 E.20533
G1 X178.123 Y169.338 E.6215
; COOLING_NODE: 0
M204 S250
G1 X178.515 Y169.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1796
M204 S5000
G1 X171.541 Y169.79 E.21429
G1 X171.541 Y150.21 E.60164
G1 X178.515 Y150.21 E.21429
G1 X178.515 Y169.73 E.5998
;======== H2D 20260731========
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
G1 X173.523 Y168.236 Z9.6 F60000
G1 Z9.2
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F1825
M204 S8000
G1 X173.096 Y168.236 E.01418
G1 X173.096 Y167.035 E.03983
G1 X173.69 Y166.579 E.02483
G3 X175.655 Y166.022 I1.391 J1.161 E.072
G3 X176.961 Y167.045 I-22.408 J29.929 E.05502
G1 X176.961 Y164.457 E.08586
G1 X176.31 Y163.959 E.02717
G2 X174.345 Y163.401 I-1.391 J1.161 E.072
G2 X173.096 Y164.38 I21.435 J28.659 E.05264
G1 X173.096 Y161.793 E.0858
G1 X173.69 Y161.338 E.02483
G3 X175.655 Y160.781 I1.391 J1.161 E.072
G3 X176.961 Y161.804 I-22.417 J29.941 E.05502
G1 X176.961 Y159.216 E.08586
G1 X176.31 Y158.718 E.02717
G2 X174.345 Y158.16 I-1.391 J1.161 E.072
G2 X173.096 Y159.139 I21.445 J28.671 E.05264
G1 X173.096 Y156.552 E.0858
G1 X173.69 Y156.097 E.02483
G3 X175.655 Y155.54 I1.391 J1.161 E.072
G3 X176.961 Y156.563 I-22.408 J29.929 E.05502
G1 X176.961 Y153.974 E.08586
G1 X176.31 Y153.476 E.02717
G2 X174.345 Y152.919 I-1.391 J1.161 E.072
G2 X173.096 Y153.897 I21.435 J28.659 E.05264
G1 X173.096 Y152.269 E.05401
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
G1 F1820
M204 S8000
G1 X172.748 Y168.584 E.15127
G1 X172.748 Y151.416 E.56948
G1 X177.309 Y151.416 E.15127
G1 X177.309 Y168.524 E.56749
; COOLING_NODE: 0
M204 S10000
G1 X177.716 Y168.991 F60000
G1 F1820
M204 S8000
G1 X172.341 Y168.991 E.17828
G1 X172.341 Y151.009 E.59649
G1 X177.716 Y151.009 E.17828
G1 X177.716 Y168.931 E.5945
; COOLING_NODE: 0
M204 S10000
G1 X178.123 Y169.398 F60000
G1 F1820
M204 S8000
G1 X171.934 Y169.398 E.20529
G1 X171.934 Y150.602 E.62349
G1 X178.123 Y150.602 E.20529
G1 X178.123 Y169.338 E.6215
; COOLING_NODE: 0
M204 S250
G1 X178.515 Y169.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1793
M204 S5000
G1 X171.542 Y169.79 E.21425
G1 X171.542 Y150.21 E.60164
G1 X178.515 Y150.21 E.21425
G1 X178.515 Y169.73 E.5998
;======== H2D 20260731========
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
M73 P61 R7
G1 X176.515 Y169.747 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X173.676 Y168.236 Z9.8 F60000
G1 Z9.4
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F1820
M204 S8000
G1 X173.097 Y168.236 E.01921
G1 X173.097 Y167.186 E.0348
G2 X174.345 Y166.157 I-1.724 J-3.361 E.05409
G3 X175.655 Y165.89 I.961 J1.363 E.04565
G3 X176.961 Y166.942 I-1.586 J3.304 E.05611
G1 X176.961 Y164.591 E.07798
G3 X175.655 Y163.536 I1.602 J-3.318 E.05616
G2 X174.345 Y163.269 I-.961 J1.363 E.04565
G2 X173.097 Y164.266 I1.505 J3.164 E.05346
G1 X173.097 Y161.945 E.07698
G2 X174.345 Y160.916 I-1.724 J-3.361 E.05409
G3 X175.655 Y160.648 I.961 J1.363 E.04565
G3 X176.961 Y161.7 I-1.586 J3.303 E.05611
G1 X176.961 Y159.35 E.07798
G3 X175.655 Y158.295 I1.601 J-3.317 E.05616
G2 X174.345 Y158.028 I-.961 J1.363 E.04565
G2 X173.097 Y159.025 I1.505 J3.164 E.05346
G1 X173.097 Y156.704 E.07698
G2 X174.345 Y155.674 I-1.724 J-3.361 E.05409
G3 X175.655 Y155.407 I.961 J1.363 E.04565
G3 X176.961 Y156.459 I-1.586 J3.304 E.05611
G1 X176.961 Y154.108 E.07798
G3 X175.655 Y153.054 I1.601 J-3.317 E.05616
G2 X174.345 Y152.786 I-.961 J1.363 E.04565
G2 X173.097 Y153.783 I1.505 J3.164 E.05346
G1 X173.097 Y152.155 E.05401
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
G1 F1822
M204 S8000
G1 X172.75 Y168.584 E.15123
G1 X172.75 Y151.416 E.56948
G1 X177.309 Y151.416 E.15123
G1 X177.309 Y168.524 E.56749
; COOLING_NODE: 0
M204 S10000
G1 X177.716 Y168.991 F60000
G1 F1822
M204 S8000
G1 X172.343 Y168.991 E.17824
G1 X172.343 Y151.009 E.59649
G1 X177.716 Y151.009 E.17824
G1 X177.716 Y168.931 E.5945
; COOLING_NODE: 0
M204 S10000
G1 X178.123 Y169.398 F60000
G1 F1822
M204 S8000
G1 X171.936 Y169.398 E.20525
G1 X171.936 Y150.602 E.62349
G1 X178.123 Y150.602 E.20525
G1 X178.123 Y169.338 E.6215
; COOLING_NODE: 0
M204 S250
G1 X178.515 Y169.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1784
M204 S5000
G1 X171.544 Y169.79 E.21422
G1 X171.544 Y150.21 E.60164
G1 X178.515 Y150.21 E.21422
G1 X178.515 Y169.73 E.5998
;======== H2D 20260731========
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
G1 F1822
M204 S8000
G1 X173.098 Y168.236 E.02526
G1 X173.098 Y167.369 E.02875
G2 X173.69 Y167.051 I-.028 J-.761 E.02308
G1 X174.345 Y166.245 E.03444
G3 X175.655 Y165.721 I1.319 J1.398 E.04794
G1 X175.983 Y165.793 E.01112
G3 X176.961 Y166.852 I-1.923 J2.756 E.0482
G1 X176.961 Y164.761 E.06937
G3 X176.31 Y164.43 I.012 J-.827 E.02506
G1 X175.655 Y163.625 E.03444
G2 X174.345 Y163.1 I-1.319 J1.398 E.04794
G1 X174.017 Y163.172 E.01112
G2 X173.098 Y164.16 I1.789 J2.587 E.04511
G1 X173.098 Y162.127 E.06741
G2 X173.69 Y161.809 I-.028 J-.761 E.02308
G1 X174.345 Y161.004 E.03444
G3 X175.655 Y160.48 I1.319 J1.398 E.04794
G1 X175.983 Y160.551 E.01112
G3 X176.961 Y161.611 I-1.923 J2.756 E.0482
G1 X176.961 Y159.52 E.06937
G3 X176.31 Y159.189 I.012 J-.827 E.02506
G1 X175.655 Y158.383 E.03444
G2 X174.345 Y157.859 I-1.319 J1.398 E.04794
G1 X174.017 Y157.931 E.01112
G2 X173.098 Y158.918 I1.789 J2.587 E.04511
G1 X173.098 Y156.886 E.06741
G2 X173.69 Y156.568 I-.028 J-.761 E.02308
G1 X174.345 Y155.763 E.03444
G3 X175.655 Y155.238 I1.319 J1.398 E.04794
G1 X175.983 Y155.31 E.01112
G3 X176.961 Y156.369 I-1.923 J2.756 E.0482
G1 X176.961 Y154.278 E.06937
G3 X176.31 Y153.947 I.012 J-.827 E.02506
G1 X175.655 Y153.142 E.03444
G2 X174.345 Y152.618 I-1.319 J1.398 E.04794
G1 X174.017 Y152.689 E.01112
G2 X173.098 Y153.677 I1.789 J2.587 E.04511
G1 X173.098 Y152.049 E.05401
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
G1 F1876
M204 S8000
G1 X172.751 Y168.584 E.15119
G1 X172.751 Y151.416 E.56948
G1 X177.309 Y151.416 E.15119
G1 X177.309 Y168.524 E.56749
; COOLING_NODE: 0
M204 S10000
G1 X177.716 Y168.991 F60000
M73 P62 R7
G1 F1876
M204 S8000
G1 X172.344 Y168.991 E.1782
G1 X172.344 Y151.009 E.59649
G1 X177.716 Y151.009 E.1782
G1 X177.716 Y168.931 E.5945
; COOLING_NODE: 0
M204 S10000
G1 X178.123 Y169.398 F60000
G1 F1876
M204 S8000
G1 X171.937 Y169.398 E.20521
G1 X171.937 Y150.602 E.62349
G1 X178.123 Y150.602 E.20521
G1 X178.123 Y169.338 E.6215
; COOLING_NODE: 0
M204 S250
G1 X178.515 Y169.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1768
M204 S5000
G1 X171.545 Y169.79 E.21418
G1 X171.545 Y150.21 E.60164
G1 X178.515 Y150.21 E.21418
G1 X178.515 Y169.73 E.5998
;======== H2D 20260731========
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
G1 F1876
M204 S8000
G1 X174.631 Y168.236 E.05401
G2 X173.69 Y168.162 I-.539 J.825 E.03267
G1 X173.645 Y168.236 E.00287
G1 X173.099 Y168.236 E.0181
G1 X173.099 Y167.622 E.02035
G2 X173.69 Y167.563 I.25 J-.483 E.02083
G1 X174.017 Y166.877 E.02521
G3 X175.655 Y165.496 I2.478 J1.279 E.07293
G3 X176.31 Y165.541 I.294 J.525 E.02304
G2 X176.961 Y166.772 I7.263 J-3.049 E.04624
G1 X176.961 Y164.988 E.05919
G3 X176.31 Y164.942 I-.29 J-.522 E.02287
G1 X175.983 Y164.256 E.02521
G2 X174.345 Y162.876 I-2.478 J1.278 E.07293
G2 X173.69 Y162.92 I-.294 J.525 E.02304
G3 X173.099 Y164.05 I-6.665 J-2.763 E.04235
G1 X173.099 Y162.381 E.05539
G2 X173.69 Y162.321 I.25 J-.483 E.02083
G1 X174.017 Y161.636 E.02521
G3 X175.655 Y160.255 I2.478 J1.278 E.07293
G3 X176.31 Y160.3 I.294 J.525 E.02304
G2 X176.961 Y161.53 I7.262 J-3.049 E.04624
G1 X176.961 Y159.746 E.05919
G3 X176.31 Y159.701 I-.29 J-.522 E.02287
G1 X175.983 Y159.015 E.02521
G2 X174.345 Y157.635 I-2.478 J1.278 E.07293
G2 X173.69 Y157.679 I-.294 J.525 E.02304
G3 X173.099 Y158.809 I-6.665 J-2.763 E.04235
G1 X173.099 Y157.139 E.05539
G2 X173.69 Y157.08 I.25 J-.483 E.02083
G1 X174.017 Y156.394 E.02521
G3 X175.655 Y155.014 I2.478 J1.279 E.07293
G3 X176.31 Y155.058 I.294 J.525 E.02304
G2 X176.961 Y156.289 I7.263 J-3.049 E.04624
G1 X176.961 Y154.505 E.05919
G3 X176.31 Y154.459 I-.29 J-.522 E.02287
G1 X175.983 Y153.774 E.02521
G2 X174.345 Y152.393 I-2.478 J1.278 E.07293
G2 X173.69 Y152.438 I-.294 J.525 E.02304
G3 X173.099 Y153.568 I-6.665 J-2.763 E.04235
G1 X173.099 Y151.898 E.05539
G2 X173.69 Y151.839 I.25 J-.483 E.02083
G1 X173.725 Y151.764 E.00273
G1 X175.354 Y151.764 E.05401
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
G1 F1898
M204 S8000
G1 X172.752 Y168.584 E.15115
G1 X172.752 Y151.416 E.56948
G1 X177.309 Y151.416 E.15115
G1 X177.309 Y168.524 E.56749
; COOLING_NODE: 0
M204 S10000
G1 X177.716 Y168.991 F60000
G1 F1898
M204 S8000
G1 X172.345 Y168.991 E.17816
G1 X172.345 Y151.009 E.59649
G1 X177.716 Y151.009 E.17816
G1 X177.716 Y168.931 E.5945
; COOLING_NODE: 0
M204 S10000
G1 X178.123 Y169.398 F60000
G1 F1898
M204 S8000
G1 X171.938 Y169.398 E.20517
G1 X171.938 Y150.602 E.62349
G1 X178.123 Y150.602 E.20517
G1 X178.123 Y169.338 E.6215
; COOLING_NODE: 0
M204 S250
G1 X178.515 Y169.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1748
M204 S5000
G1 X171.546 Y169.79 E.21414
M73 P63 R7
G1 X171.546 Y150.21 E.60164
G1 X178.515 Y150.21 E.21414
G1 X178.515 Y169.73 E.5998
;======== H2D 20260731========
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
G1 F1898
M204 S8000
G1 X173.1 Y163.943 E.05401
G1 X173.265 Y163.276 E.02278
G2 X173.1 Y162.789 I-.511 J-.099 E.01785
G1 X173.1 Y158.701 E.13558
G1 X173.265 Y158.035 E.02278
G2 X173.1 Y157.547 I-.511 J-.099 E.01785
G1 X173.1 Y153.46 E.13558
G1 X173.265 Y152.793 E.02278
G2 X173.1 Y152.306 I-.511 J-.099 E.01785
G1 X173.1 Y151.764 E.01797
G1 X174.152 Y151.764 E.03487
G1 X174.406 Y152.138 E.015
G1 X175.284 Y152.793 E.03634
G3 X175.842 Y154.431 I-1.479 J1.418 E.05926
G1 X175.594 Y154.759 E.01364
G1 X174.716 Y155.414 E.03634
G2 X174.158 Y157.052 I1.479 J1.418 E.05926
G1 X174.406 Y157.379 E.01364
G1 X175.284 Y158.035 E.03634
G3 X175.842 Y159.673 I-1.479 J1.418 E.05926
G1 X175.594 Y160 E.01364
G1 X174.716 Y160.655 E.03634
G2 X174.158 Y162.293 I1.479 J1.418 E.05926
G1 X174.406 Y162.621 E.01364
G1 X175.284 Y163.276 E.03634
G3 X175.842 Y164.914 I-1.479 J1.418 E.05926
G1 X175.594 Y165.241 E.01364
G1 X174.716 Y165.897 E.03634
G2 X174.158 Y167.535 I1.479 J1.418 E.05926
G2 X174.907 Y168.236 I1.591 J-.949 E.03448
G1 X176.961 Y168.236 E.06813
G1 X176.961 Y166.672 E.05187
G3 X176.779 Y165.569 I1.946 J-.888 E.03752
G1 X176.961 Y165.329 E.00999
G1 X176.961 Y161.431 E.12932
G3 X176.779 Y160.328 I1.946 J-.888 E.03752
G1 X176.961 Y160.088 E.00999
G1 X176.961 Y156.189 E.12932
G3 X176.779 Y155.086 I1.946 J-.888 E.03752
G1 X176.961 Y154.846 E.00999
G1 X176.961 Y153.218 E.05401
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

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z10.4 I-1.216 J.049 P1  F60000
G1 X177.309 Y168.584 Z10.4
G1 Z10.2
G1 E.8 F1800
; FEATURE: Inner wall
G1 F1782
M204 S8000
G1 X172.753 Y168.584 E.15111
G1 X172.753 Y151.416 E.56948
G1 X177.309 Y151.416 E.15111
G1 X177.309 Y168.524 E.56749
; COOLING_NODE: 0
M204 S10000
G1 X177.716 Y168.991 F60000
G1 F1782
M204 S8000
G1 X172.346 Y168.991 E.17812
G1 X172.346 Y151.009 E.59649
G1 X177.716 Y151.009 E.17812
G1 X177.716 Y168.931 E.5945
; COOLING_NODE: 0
M204 S10000
G1 X178.123 Y169.398 F60000
G1 F1782
M204 S8000
G1 X171.939 Y169.398 E.20512
G1 X171.939 Y150.602 E.62349
G1 X178.123 Y150.602 E.20512
G1 X178.123 Y169.338 E.6215
; COOLING_NODE: 0
M204 S250
G1 X178.515 Y169.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1729
M204 S5000
G1 X171.547 Y169.79 E.2141
G1 X171.547 Y150.21 E.60164
G1 X178.515 Y150.21 E.2141
G1 X178.515 Y169.73 E.5998
;======== H2D 20260731========
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
G1 F1782
M204 S8000
G1 X176.961 Y155.301 E.05401
G1 X176.917 Y155.414 E.00403
G1 X176.961 Y156.11 E.02314
G1 X176.961 Y160.542 E.14701
G1 X176.917 Y160.655 E.00403
G1 X176.961 Y168.236 E.25146
G1 X175.081 Y168.236 E.06234
G3 X174.296 Y167.207 I1.437 J-1.911 E.04347
G3 X174.631 Y165.897 I1.696 J-.265 E.04611
G2 X175.577 Y164.914 I-4.695 J-5.468 E.04533
G1 X175.704 Y164.586 E.01165
G2 X175.369 Y163.276 I-1.696 J-.265 E.04611
M73 P64 R7
G3 X174.423 Y162.293 I4.695 J-5.468 E.04533
G1 X174.296 Y161.966 E.01165
G3 X174.631 Y160.655 I1.696 J-.265 E.04611
G2 X175.577 Y159.673 I-4.695 J-5.469 E.04533
G1 X175.704 Y159.345 E.01165
G2 X175.369 Y158.035 I-1.696 J-.265 E.04611
G3 X174.423 Y157.052 I4.695 J-5.469 E.04533
G1 X174.296 Y156.724 E.01165
G3 X174.631 Y155.414 I1.696 J-.265 E.04611
G2 X175.577 Y154.431 I-4.695 J-5.468 E.04533
G1 X175.704 Y154.104 E.01165
G2 X175.369 Y152.793 I-1.696 J-.265 E.04611
G3 X174.405 Y151.764 I3.202 J-3.967 E.04692
G1 X173.102 Y151.764 E.04324
G1 X173.102 Y152.089 E.01078
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
G1 F1661
M204 S8000
G1 X172.755 Y168.584 E.15107
G1 X172.755 Y151.416 E.56948
G1 X177.309 Y151.416 E.15107
G1 X177.309 Y168.524 E.56749
; COOLING_NODE: 0
M204 S10000
G1 X177.716 Y168.991 F60000
G1 F1661
M204 S8000
G1 X172.348 Y168.991 E.17808
G1 X172.348 Y151.009 E.59649
G1 X177.716 Y151.009 E.17808
G1 X177.716 Y168.931 E.5945
; COOLING_NODE: 0
M204 S10000
G1 X178.123 Y169.398 F60000
G1 F1661
M204 S8000
G1 X171.94 Y169.398 E.20508
G1 X171.94 Y150.602 E.62349
G1 X178.123 Y150.602 E.20508
G1 X178.123 Y169.338 E.6215
; COOLING_NODE: 0
M204 S250
G1 X178.515 Y169.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1661
M204 S5000
G1 X171.548 Y169.79 E.21406
G1 X171.548 Y150.21 E.60164
G1 X178.515 Y150.21 E.21406
G1 X178.515 Y169.73 E.5998
;======== H2D 20260731========
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
G1 F1661
M204 S8000
G1 X175.231 Y168.236 E.05401
G3 X174.437 Y167.207 I7.333 J-6.481 E.04314
G3 X175.083 Y165.241 I1.822 J-.49 E.07264
G1 X175.563 Y164.586 E.02694
G2 X174.917 Y162.621 I-1.822 J-.49 E.07264
G1 X174.437 Y161.966 E.02694
G3 X175.083 Y160 I1.822 J-.49 E.07264
G1 X175.563 Y159.345 E.02694
G2 X174.917 Y157.379 I-1.822 J-.49 E.07264
G1 X174.437 Y156.724 E.02694
G3 X175.083 Y154.759 I1.822 J-.49 E.07264
G1 X175.563 Y154.104 E.02694
G2 X174.917 Y152.138 I-1.822 J-.49 E.07264
G1 X174.643 Y151.764 E.01537
G1 X173.103 Y151.764 E.05109
G1 X173.103 Y151.853 E.00292
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
G1 F1662
M204 S8000
G1 X172.756 Y168.584 E.15103
G1 X172.756 Y151.416 E.56948
G1 X177.309 Y151.416 E.15103
G1 X177.309 Y168.524 E.56749
; COOLING_NODE: 0
M204 S10000
G1 X177.716 Y168.991 F60000
G1 F1662
M204 S8000
G1 X172.349 Y168.991 E.17804
G1 X172.349 Y151.009 E.59649
G1 X177.716 Y151.009 E.17804
G1 X177.716 Y168.931 E.5945
; COOLING_NODE: 0
M204 S10000
G1 X178.123 Y169.398 F60000
G1 F1662
M204 S8000
G1 X171.942 Y169.398 E.20504
M73 P65 R7
G1 X171.942 Y150.602 E.62349
G1 X178.123 Y150.602 E.20504
G1 X178.123 Y169.338 E.6215
; COOLING_NODE: 0
M204 S250
G1 X178.515 Y169.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
M73 P65 R6
G1 F1662
M204 S5000
G1 X171.55 Y169.79 E.21403
G1 X171.55 Y150.21 E.60164
G1 X178.515 Y150.21 E.21403
G1 X178.515 Y169.73 E.5998
;======== H2D 20260731========
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
G1 X176.961 Y168.183 Z11 F60000
G1 Z10.6
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F1662
M204 S8000
G1 X176.961 Y168.236 E.00174
G1 X175.385 Y168.236 E.05227
G1 X175.119 Y167.862 E.01521
G3 X174.415 Y165.897 I1.186 J-1.533 E.07313
G1 X174.881 Y165.241 E.02669
G2 X175.585 Y163.276 I-1.186 J-1.533 E.07313
G1 X175.119 Y162.621 E.02669
G3 X174.415 Y160.655 I1.186 J-1.533 E.07313
G1 X174.881 Y160 E.02669
G2 X175.585 Y158.035 I-1.186 J-1.533 E.07313
G1 X175.119 Y157.379 E.02669
G3 X174.415 Y155.414 I1.186 J-1.533 E.07313
G1 X174.881 Y154.759 E.02669
G2 X175.585 Y152.793 I-1.186 J-1.533 E.07313
G2 X174.795 Y151.764 I-5.794 J3.635 E.04311
G1 X173.166 Y151.764 E.05401
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
G1 F1773
M204 S8000
G1 X172.757 Y168.584 E.15099
G1 X172.757 Y151.416 E.56948
G1 X177.309 Y151.416 E.15099
G1 X177.309 Y168.524 E.56749
; COOLING_NODE: 0
M204 S10000
G1 X177.716 Y168.991 F60000
G1 F1773
M204 S8000
G1 X172.35 Y168.991 E.178
G1 X172.35 Y151.009 E.59649
G1 X177.716 Y151.009 E.178
G1 X177.716 Y168.931 E.5945
; COOLING_NODE: 0
M204 S10000
G1 X178.123 Y169.398 F60000
G1 F1773
M204 S8000
G1 X171.943 Y169.398 E.205
G1 X171.943 Y150.602 E.62349
G1 X178.123 Y150.602 E.205
G1 X178.123 Y169.338 E.6215
; COOLING_NODE: 0
M204 S250
G1 X178.515 Y169.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1734
M204 S5000
G1 X171.551 Y169.79 E.21399
G1 X171.551 Y150.21 E.60164
G1 X178.515 Y150.21 E.21399
G1 X178.515 Y169.73 E.5998
;======== H2D 20260731========
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
M73 P66 R6
G1 X176.736 Y162.118 Z11.2 F60000
G1 X176.961 Y154.39 Z11.2
G1 Z10.8
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F1773
M204 S8000
G1 X176.961 Y156.018 E.05401
G1 X176.888 Y156.724 E.02355
G1 X176.961 Y156.929 E.0072
G1 X176.961 Y161.259 E.14364
G1 X176.888 Y161.966 E.02355
G1 X176.961 Y162.17 E.0072
G1 X176.961 Y166.501 E.14364
G1 X176.888 Y167.207 E.02355
G1 X176.961 Y167.412 E.0072
G1 X176.961 Y168.236 E.02733
G1 X175.633 Y168.236 E.04403
G2 X174.646 Y167.207 I-3.603 J2.469 E.04749
G3 X174.383 Y165.569 I1.415 J-1.068 E.05727
G3 X175.354 Y164.586 I4.554 J3.527 E.04593
G2 X175.617 Y162.948 I-1.415 J-1.068 E.05727
G2 X174.646 Y161.966 I-4.555 J3.528 E.04593
G3 X174.383 Y160.328 I1.415 J-1.068 E.05727
G3 X175.354 Y159.345 I4.554 J3.527 E.04593
G2 X175.617 Y157.707 I-1.415 J-1.068 E.05727
G2 X174.646 Y156.724 I-4.554 J3.527 E.04593
G3 X174.383 Y155.086 I1.415 J-1.068 E.05727
G3 X175.354 Y154.104 I4.554 J3.527 E.04593
G2 X175.617 Y152.466 I-1.415 J-1.068 E.05727
G2 X174.946 Y151.764 I-3.24 J2.429 E.03228
G1 X173.318 Y151.764 E.05401
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

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z11.2 I-1.207 J.154 P1  F60000
G1 X177.309 Y168.584 Z11.2
G1 Z11
G1 E.8 F1800
; FEATURE: Inner wall
G1 F1916
M204 S8000
G1 X172.758 Y168.584 E.15095
G1 X172.758 Y151.416 E.56948
G1 X177.309 Y151.416 E.15095
G1 X177.309 Y168.524 E.56749
; COOLING_NODE: 0
M204 S10000
G1 X177.716 Y168.991 F60000
G1 F1916
M204 S8000
G1 X172.351 Y168.991 E.17795
G1 X172.351 Y151.009 E.59649
G1 X177.716 Y151.009 E.17795
G1 X177.716 Y168.931 E.5945
; COOLING_NODE: 0
M204 S10000
G1 X178.123 Y169.398 F60000
G1 F1916
M204 S8000
G1 X171.944 Y169.398 E.20496
G1 X171.944 Y150.602 E.62349
G1 X178.123 Y150.602 E.20496
G1 X178.123 Y169.338 E.6215
; COOLING_NODE: 0
M204 S250
G1 X178.515 Y169.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1750
M204 S5000
G1 X171.552 Y169.79 E.21395
G1 X171.552 Y150.21 E.60164
G1 X178.515 Y150.21 E.21395
G1 X178.515 Y169.73 E.5998
;======== H2D 20260731========
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
G1 F1916
M204 S8000
G1 X173.107 Y165.154 E.05401
G2 X173.302 Y164.586 I-.357 J-.441 E.02098
G1 X173.107 Y163.913 E.02328
G1 X173.107 Y159.912 E.1327
G2 X173.302 Y159.345 I-.357 J-.441 E.02098
G1 X173.107 Y158.671 E.02327
G1 X173.107 Y154.671 E.1327
G2 X173.302 Y154.104 I-.357 J-.441 E.02098
G1 X173.107 Y153.43 E.02328
G1 X173.107 Y151.802 E.05401
M204 S10000
G1 X176.961 Y153.774 F60000
G1 F1916
M204 S8000
G1 X176.961 Y152.146 E.05401
G2 X176.72 Y151.811 I-1.016 J.475 E.01375
G1 X176.717 Y151.764 E.00153
G1 X175.131 Y151.764 E.05261
G3 X175.901 Y152.466 I-.629 J1.463 E.03519
G3 X175.271 Y154.104 I-2.177 J.103 E.05991
G1 X174.336 Y154.759 E.03785
G1 X174.1 Y155.086 E.01341
G2 X174.73 Y156.724 I2.177 J.103 E.05991
G1 X175.664 Y157.379 E.03785
G1 X175.901 Y157.707 E.01341
G3 X175.271 Y159.345 I-2.177 J.103 E.05991
G1 X174.336 Y160 E.03785
G1 X174.1 Y160.328 E.01341
G2 X174.73 Y161.966 I2.177 J.103 E.05991
G1 X175.664 Y162.621 E.03785
G1 X175.901 Y162.948 E.01341
G3 X175.271 Y164.586 I-2.177 J.103 E.05991
G1 X174.336 Y165.241 E.03785
G1 X174.1 Y165.569 E.01341
G2 X174.73 Y167.207 I2.177 J.103 E.05991
G1 X175.664 Y167.862 E.03785
G1 X175.904 Y168.236 E.01473
G1 X176.961 Y168.236 E.03506
G2 X176.72 Y167.535 I-.612 J-.182 E.02623
G3 X176.961 Y166.415 I2.313 J-.088 E.03837
G1 X176.961 Y162.628 E.12563
G2 X176.72 Y162.293 I-1.016 J.475 E.01375
G3 X176.961 Y161.174 I2.313 J-.088 E.03837
G1 X176.961 Y157.387 E.12563
G2 X176.72 Y157.052 I-1.016 J.475 E.01375
G3 X176.961 Y155.933 I2.313 J-.088 E.03837
G1 X176.961 Y154.305 E.05401
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
G1 F1865
M204 S8000
G1 X172.76 Y168.584 E.15091
G1 X172.76 Y151.416 E.56948
G1 X177.309 Y151.416 E.15091
G1 X177.309 Y168.524 E.56749
; COOLING_NODE: 0
M204 S10000
G1 X177.716 Y168.991 F60000
G1 F1865
M204 S8000
G1 X172.352 Y168.991 E.17791
G1 X172.352 Y151.009 E.59649
G1 X177.716 Y151.009 E.17791
G1 X177.716 Y168.931 E.5945
; COOLING_NODE: 0
M204 S10000
G1 X178.123 Y169.398 F60000
M73 P67 R6
G1 F1865
M204 S8000
G1 X171.945 Y169.398 E.20492
G1 X171.945 Y150.602 E.62349
G1 X178.123 Y150.602 E.20492
G1 X178.123 Y169.338 E.6215
; COOLING_NODE: 0
M204 S250
G1 X178.515 Y169.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1766
M204 S5000
G1 X171.553 Y169.79 E.21391
G1 X171.553 Y150.21 E.60164
G1 X178.515 Y150.21 E.21391
G1 X178.515 Y169.73 E.5998
;======== H2D 20260731========
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
G1 X174.81 Y168.236 Z11.6 F60000
G1 Z11.2
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F1865
M204 S8000
G1 X176.438 Y168.236 E.05401
G3 X176.961 Y168.161 I.313 J.324 E.01869
G1 X176.961 Y166.319 E.0611
G1 X176.31 Y167.417 E.04233
G1 X175.983 Y167.6 E.01246
G3 X174.345 Y166.793 I.3 J-2.674 E.0618
G1 X173.69 Y165.687 E.04266
G2 X173.108 Y165.532 I-.398 J.326 E.02133
G1 X173.108 Y163.813 E.05702
G1 X173.69 Y164.796 E.03789
G1 X174.017 Y164.98 E.01246
G2 X175.655 Y164.173 I-.3 J-2.674 E.0618
G1 X176.31 Y163.066 E.04266
G3 X176.961 Y162.919 I.427 J.377 E.02361
G1 X176.961 Y161.077 E.0611
G1 X176.31 Y162.176 E.04233
G1 X175.983 Y162.359 E.01246
G3 X174.345 Y161.552 I.3 J-2.674 E.0618
G1 X173.69 Y160.445 E.04266
G2 X173.108 Y160.291 I-.398 J.326 E.02133
G1 X173.108 Y158.572 E.05702
G1 X173.69 Y159.555 E.03789
G1 X174.017 Y159.738 E.01246
G2 X175.655 Y158.931 I-.3 J-2.674 E.0618
G1 X176.31 Y157.825 E.04266
G3 X176.961 Y157.678 I.427 J.377 E.02362
G1 X176.961 Y155.836 E.0611
G1 X176.31 Y156.934 E.04233
G1 X175.983 Y157.118 E.01246
G3 X174.345 Y156.311 I.3 J-2.674 E.0618
G1 X173.69 Y155.204 E.04266
G2 X173.108 Y155.05 I-.398 J.326 E.02133
G1 X173.108 Y153.331 E.05702
G1 X173.69 Y154.314 E.03789
G1 X174.017 Y154.497 E.01246
G2 X175.655 Y153.69 I-.3 J-2.674 E.0618
G1 X176.31 Y152.583 E.04266
G3 X176.961 Y152.437 I.427 J.377 E.02361
G1 X176.961 Y151.764 E.0223
G1 X176.183 Y151.764 E.0258
G3 X175.453 Y151.764 I-.365 J-.666 E.02523
G1 X173.825 Y151.764 E.05401
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
G1 F1818
M204 S8000
G1 X172.761 Y168.584 E.15087
G1 X172.761 Y151.416 E.56948
G1 X177.309 Y151.416 E.15087
G1 X177.309 Y168.524 E.56749
; COOLING_NODE: 0
M204 S10000
G1 X177.716 Y168.991 F60000
G1 F1818
M204 S8000
G1 X172.354 Y168.991 E.17787
G1 X172.354 Y151.009 E.59649
G1 X177.716 Y151.009 E.17787
G1 X177.716 Y168.931 E.5945
; COOLING_NODE: 0
M204 S10000
G1 X178.123 Y169.398 F60000
G1 F1818
M204 S8000
G1 X171.947 Y169.398 E.20488
G1 X171.947 Y150.602 E.62349
G1 X178.123 Y150.602 E.20488
G1 X178.123 Y169.338 E.6215
; COOLING_NODE: 0
M204 S250
G1 X178.515 Y169.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1779
M204 S5000
G1 X171.555 Y169.79 E.21387
G1 X171.555 Y150.21 E.60164
G1 X178.515 Y150.21 E.21387
G1 X178.515 Y169.73 E.5998
;======== H2D 20260731========
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
M73 P68 R6
G1 X176.515 Y169.747 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X176.961 Y167.865 Z11.8 F60000
G1 Z11.4
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F1818
M204 S8000
G1 X176.961 Y166.237 E.05401
G3 X175.983 Y167.263 I-3.27 J-2.136 E.04729
G3 X174.345 Y166.873 I-.437 J-1.799 E.05798
G1 X173.69 Y166.106 E.03345
G2 X173.109 Y165.773 I-.66 J.48 E.02287
G1 X173.109 Y163.697 E.06887
G2 X174.017 Y164.642 I3.015 J-1.989 E.04372
G2 X175.655 Y164.252 I.437 J-1.799 E.05798
G1 X176.31 Y163.485 E.03345
G3 X176.961 Y163.134 I.716 J.548 E.02525
G1 X176.961 Y160.995 E.07096
G3 X175.983 Y162.022 I-3.27 J-2.136 E.04729
G3 X174.345 Y161.631 I-.437 J-1.799 E.05798
G1 X173.69 Y160.865 E.03345
G2 X173.109 Y160.532 I-.66 J.48 E.02287
G1 X173.109 Y158.456 E.06887
G2 X174.017 Y159.401 I3.015 J-1.988 E.04372
G2 X175.655 Y159.011 I.437 J-1.799 E.05798
G1 X176.31 Y158.244 E.03345
G3 X176.961 Y157.893 I.716 J.548 E.02525
G1 X176.961 Y155.754 E.07095
G3 X175.983 Y156.78 I-3.27 J-2.136 E.04729
G3 X174.345 Y156.39 I-.437 J-1.799 E.05798
G1 X173.69 Y155.623 E.03345
G2 X173.109 Y155.291 I-.66 J.48 E.02287
G1 X173.109 Y153.215 E.06887
G2 X174.017 Y154.16 I3.015 J-1.988 E.04372
G2 X175.655 Y153.769 I.437 J-1.799 E.05798
G1 X176.31 Y153.003 E.03345
G3 X176.961 Y152.652 I.716 J.548 E.02525
G1 X176.961 Y151.764 E.02943
G1 X176.219 Y151.764 E.02458
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
G1 F1818
M204 S8000
G1 X172.762 Y168.584 E.15083
G1 X172.762 Y151.416 E.56948
G1 X177.309 Y151.416 E.15083
G1 X177.309 Y168.524 E.56749
; COOLING_NODE: 0
M204 S10000
G1 X177.716 Y168.991 F60000
G1 F1818
M204 S8000
G1 X172.355 Y168.991 E.17783
G1 X172.355 Y151.009 E.59649
G1 X177.716 Y151.009 E.17783
G1 X177.716 Y168.931 E.5945
; COOLING_NODE: 0
M204 S10000
G1 X178.123 Y169.398 F60000
G1 F1818
M204 S8000
G1 X171.948 Y169.398 E.20484
G1 X171.948 Y150.602 E.62349
G1 X178.123 Y150.602 E.20484
G1 X178.123 Y169.338 E.6215
; COOLING_NODE: 0
M204 S250
G1 X178.515 Y169.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1788
M204 S5000
G1 X171.556 Y169.79 E.21384
G1 X171.556 Y150.21 E.60164
G1 X178.515 Y150.21 E.21384
G1 X178.515 Y169.73 E.5998
;======== H2D 20260731========
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
G1 F1818
M204 S8000
G1 X176.961 Y166.145 E.05401
G3 X175.983 Y167.034 I-13.272 J-13.61 E.04385
G3 X174.345 Y166.963 I-.753 J-1.563 E.05664
G2 X173.11 Y165.951 I-3.361 J2.84 E.05326
G1 X173.11 Y163.59 E.0783
G2 X174.017 Y164.414 I12.289 J-12.625 E.04065
G2 X175.655 Y164.342 I.753 J-1.563 E.05664
G3 X176.961 Y163.297 I3.246 J2.715 E.05585
G1 X176.961 Y160.904 E.07938
G3 X175.983 Y161.793 I-13.275 J-13.613 E.04385
G3 X174.345 Y161.722 I-.753 J-1.563 E.05664
G2 X173.11 Y160.709 I-3.361 J2.84 E.05326
G1 X173.11 Y158.349 E.0783
G2 X174.017 Y159.172 I12.298 J-12.635 E.04065
G2 X175.655 Y159.101 I.753 J-1.562 E.05664
G3 X176.961 Y158.055 I3.246 J2.715 E.05585
G1 X176.961 Y155.662 E.07938
G3 X175.983 Y156.552 I-13.272 J-13.61 E.04385
G3 X174.345 Y156.481 I-.753 J-1.563 E.05664
G2 X173.11 Y155.468 I-3.361 J2.84 E.05326
G1 X173.11 Y153.108 E.0783
G2 X174.017 Y153.931 I12.295 J-12.632 E.04065
G2 X175.655 Y153.86 I.753 J-1.563 E.05664
G3 X176.961 Y152.814 I3.247 J2.715 E.05585
G1 X176.961 Y151.764 E.03482
G1 X176.382 Y151.764 E.0192
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
G1 F1824
M204 S8000
G1 X172.763 Y168.584 E.15078
G1 X172.763 Y151.416 E.56948
G1 X177.309 Y151.416 E.15078
G1 X177.309 Y168.524 E.56749
; COOLING_NODE: 0
M204 S10000
G1 X177.716 Y168.991 F60000
M73 P69 R6
G1 F1824
M204 S8000
G1 X172.356 Y168.991 E.17779
G1 X172.356 Y151.009 E.59649
G1 X177.716 Y151.009 E.17779
G1 X177.716 Y168.931 E.5945
; COOLING_NODE: 0
M204 S10000
G1 X178.123 Y169.398 F60000
G1 F1824
M204 S8000
G1 X171.949 Y169.398 E.2048
G1 X171.949 Y150.602 E.62349
G1 X178.123 Y150.602 E.2048
G1 X178.123 Y169.338 E.6215
; COOLING_NODE: 0
M204 S250
G1 X178.515 Y169.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1792
M204 S5000
G1 X171.557 Y169.79 E.2138
G1 X171.557 Y150.21 E.60164
G1 X178.515 Y150.21 E.2138
G1 X178.515 Y169.73 E.5998
;======== H2D 20260731========
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
G1 F1824
M204 S8000
G1 X173.112 Y166.103 E.05401
G1 X173.69 Y166.559 E.02442
G2 X175.655 Y167.061 I1.341 J-1.153 E.07167
G3 X176.961 Y166.038 I91.428 J115.319 E.05501
G1 X176.961 Y163.426 E.08666
G1 X176.31 Y163.938 E.02746
G3 X174.345 Y164.44 I-1.341 J-1.153 E.07167
G2 X173.112 Y163.474 I-86.426 J108.973 E.05199
G1 X173.112 Y160.862 E.08664
G1 X173.69 Y161.318 E.02442
G2 X175.655 Y161.82 I1.341 J-1.153 E.07167
G3 X176.961 Y160.797 I91.123 J114.93 E.05501
G1 X176.961 Y158.184 E.08666
G1 X176.31 Y158.697 E.02746
G3 X174.345 Y159.199 I-1.341 J-1.152 E.07167
G2 X173.112 Y158.232 I-86.426 J108.973 E.05199
G1 X173.112 Y155.62 E.08664
G1 X173.69 Y156.076 E.02442
G2 X175.655 Y156.579 I1.341 J-1.153 E.07167
G3 X176.961 Y155.556 I91.428 J115.319 E.05501
G1 X176.961 Y152.943 E.08666
G1 X176.31 Y153.456 E.02746
G3 X174.345 Y153.958 I-1.341 J-1.153 E.07167
G2 X173.112 Y152.991 I-86.426 J108.973 E.05199
G1 X173.112 Y151.764 E.04068
G1 X173.513 Y151.764 E.01333
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
G1 F1818
M204 S8000
G1 X172.764 Y168.584 E.15074
G1 X172.764 Y151.416 E.56948
G1 X177.309 Y151.416 E.15074
G1 X177.309 Y168.524 E.56749
; COOLING_NODE: 0
M204 S10000
G1 X177.716 Y168.991 F60000
G1 F1818
M204 S8000
G1 X172.357 Y168.991 E.17775
G1 X172.357 Y151.009 E.59649
G1 X177.716 Y151.009 E.17775
G1 X177.716 Y168.931 E.5945
; COOLING_NODE: 0
M204 S10000
G1 X178.123 Y169.398 F60000
G1 F1818
M204 S8000
G1 X171.95 Y169.398 E.20476
G1 X171.95 Y150.602 E.62349
G1 X178.123 Y150.602 E.20476
G1 X178.123 Y169.338 E.6215
; COOLING_NODE: 0
M204 S250
G1 X178.515 Y169.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1790
M204 S5000
G1 X171.558 Y169.79 E.21376
M73 P70 R6
G1 X171.558 Y150.21 E.60164
G1 X178.515 Y150.21 E.21376
G1 X178.515 Y169.73 E.5998
;======== H2D 20260731========
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
M73 P70 R5
G1 X176.515 Y169.747 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X173.113 Y167.849 Z12.4 F60000
G1 Z12
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F1818
M204 S8000
G1 X173.113 Y166.221 E.05401
G2 X174.017 Y167.049 I9.886 J-9.898 E.04068
G2 X175.655 Y166.956 I.733 J-1.572 E.05668
G3 X176.961 Y165.907 I3.099 J2.519 E.05597
G1 X176.961 Y163.531 E.07881
G3 X175.983 Y164.428 I-10.704 J-10.692 E.04402
G3 X174.345 Y164.336 I-.733 J-1.572 E.05668
G2 X173.113 Y163.32 I-3.207 J2.635 E.0533
G1 X173.113 Y160.98 E.07763
G2 X174.017 Y161.807 I9.884 J-9.896 E.04068
G2 X175.655 Y161.715 I.733 J-1.572 E.05668
G3 X176.961 Y160.666 I3.098 J2.518 E.05597
G1 X176.961 Y158.29 E.07881
G3 X175.983 Y159.187 I-10.706 J-10.694 E.04402
G3 X174.345 Y159.094 I-.733 J-1.572 E.05668
G2 X173.113 Y158.079 I-3.207 J2.635 E.0533
G1 X173.113 Y155.738 E.07763
G2 X174.017 Y156.566 I9.886 J-9.898 E.04068
G2 X175.655 Y156.474 I.733 J-1.572 E.05668
G3 X176.961 Y155.425 I3.099 J2.519 E.05597
G1 X176.961 Y153.049 E.07881
G3 X175.983 Y153.945 I-10.706 J-10.694 E.04402
G3 X174.345 Y153.853 I-.733 J-1.572 E.05668
G2 X173.113 Y152.837 I-3.207 J2.636 E.0533
G1 X173.113 Y151.764 E.03559
G1 X173.668 Y151.764 E.01842
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
G1 F1819
M204 S8000
G1 X172.766 Y168.584 E.1507
G1 X172.766 Y151.416 E.56948
G1 X177.309 Y151.416 E.1507
G1 X177.309 Y168.524 E.56749
; COOLING_NODE: 0
M204 S10000
G1 X177.716 Y168.991 F60000
G1 F1819
M204 S8000
G1 X172.359 Y168.991 E.17771
G1 X172.359 Y151.009 E.59649
G1 X177.716 Y151.009 E.17771
G1 X177.716 Y168.931 E.5945
; COOLING_NODE: 0
M204 S10000
G1 X178.123 Y169.398 F60000
G1 F1819
M204 S8000
G1 X171.952 Y169.398 E.20472
G1 X171.952 Y150.602 E.62349
G1 X178.123 Y150.602 E.20472
G1 X178.123 Y169.338 E.6215
; COOLING_NODE: 0
M204 S250
G1 X178.515 Y169.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1781
M204 S5000
G1 X171.56 Y169.79 E.21372
G1 X171.56 Y150.21 E.60164
G1 X178.515 Y150.21 E.21372
G1 X178.515 Y169.73 E.5998
;======== H2D 20260731========
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
G1 F1819
M204 S8000
G1 X173.114 Y166.331 E.05401
G2 X174.017 Y167.282 I2.85 J-1.804 E.04378
G2 X175.655 Y166.867 I.408 J-1.828 E.05815
G1 X176.31 Y166.085 E.03384
G3 X176.961 Y165.742 I.694 J.526 E.02518
G1 X176.961 Y163.622 E.07032
G3 X175.983 Y164.661 I-3.111 J-1.947 E.04764
G3 X174.345 Y164.246 I-.408 J-1.828 E.05815
G1 X173.69 Y163.464 E.03384
G2 X173.114 Y163.14 I-.637 J.456 E.02264
G1 X173.114 Y161.09 E.06798
G2 X174.017 Y162.041 I2.85 J-1.803 E.04378
G2 X175.655 Y161.626 I.408 J-1.828 E.05815
G1 X176.31 Y160.844 E.03384
G3 X176.961 Y160.501 I.694 J.526 E.02518
G1 X176.961 Y158.381 E.07032
G3 X175.983 Y159.42 I-3.111 J-1.947 E.04764
G3 X174.345 Y159.005 I-.408 J-1.828 E.05815
G1 X173.69 Y158.223 E.03384
G2 X173.114 Y157.898 I-.637 J.456 E.02264
G1 X173.114 Y155.849 E.06798
G2 X174.017 Y156.8 I2.85 J-1.803 E.04378
G2 X175.655 Y156.384 I.408 J-1.828 E.05815
G1 X176.31 Y155.602 E.03384
G3 X176.961 Y155.259 I.694 J.526 E.02518
G1 X176.961 Y153.139 E.07032
G3 X175.983 Y154.179 I-3.111 J-1.947 E.04764
G3 X174.345 Y153.764 I-.408 J-1.828 E.05815
G1 X173.69 Y152.982 E.03384
G2 X173.114 Y152.657 I-.637 J.456 E.02264
G1 X173.114 Y151.764 E.0296
G1 X173.85 Y151.764 E.02441
; CHANGE_LAYER
; Z_HEIGHT: 12.4
; LAYER_HEIGHT: 0.2
; WIPE_START
M73 P71 R5
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
G1 F1866
M204 S8000
G1 X172.767 Y168.584 E.15066
G1 X172.767 Y151.416 E.56948
G1 X177.309 Y151.416 E.15066
G1 X177.309 Y168.524 E.56749
; COOLING_NODE: 0
M204 S10000
G1 X177.716 Y168.991 F60000
G1 F1866
M204 S8000
G1 X172.36 Y168.991 E.17767
G1 X172.36 Y151.009 E.59649
G1 X177.716 Y151.009 E.17767
G1 X177.716 Y168.931 E.5945
; COOLING_NODE: 0
M204 S10000
G1 X178.123 Y169.398 F60000
G1 F1866
M204 S8000
G1 X171.953 Y169.398 E.20467
G1 X171.953 Y150.602 E.62349
G1 X178.123 Y150.602 E.20467
G1 X178.123 Y169.338 E.6215
; COOLING_NODE: 0
M204 S250
G1 X178.515 Y169.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1766
M204 S5000
G1 X171.561 Y169.79 E.21369
G1 X171.561 Y150.21 E.60164
G1 X178.515 Y150.21 E.21369
G1 X178.515 Y169.73 E.5998
;======== H2D 20260731========
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
G1 X175.278 Y168.236 Z12.8 F60000
G1 Z12.4
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F1866
M204 S8000
G1 X173.65 Y168.236 E.05401
G2 X173.115 Y168.131 I-.34 J.321 E.01929
G1 X173.115 Y166.458 E.05551
G1 X173.69 Y167.469 E.03858
G1 X174.017 Y167.632 E.01215
G2 X175.655 Y166.788 I-.417 J-2.819 E.06225
G1 X176.31 Y165.635 E.04399
G3 X176.961 Y165.522 I.404 J.398 E.02336
G1 X176.961 Y163.704 E.06032
G1 X176.31 Y164.848 E.04366
G1 X175.983 Y165.012 E.01215
G3 X174.345 Y164.167 I.417 J-2.819 E.06225
G1 X173.69 Y163.014 E.04399
G2 X173.115 Y162.89 I-.374 J.339 E.02081
G1 X173.115 Y161.216 E.05551
G1 X173.69 Y162.227 E.03858
G1 X174.017 Y162.391 E.01215
G2 X175.655 Y161.547 I-.417 J-2.819 E.06225
G1 X176.31 Y160.394 E.04399
G3 X176.961 Y160.281 I.404 J.398 E.02336
G1 X176.961 Y158.462 E.06032
G1 X176.31 Y159.607 E.04366
G1 X175.983 Y159.77 E.01215
G3 X174.345 Y158.926 I.417 J-2.819 E.06225
G1 X173.69 Y157.773 E.04399
G2 X173.115 Y157.648 I-.374 J.339 E.02081
G1 X173.115 Y155.975 E.05551
G1 X173.69 Y156.986 E.03858
G1 X174.017 Y157.15 E.01215
G2 X175.655 Y156.305 I-.417 J-2.819 E.06225
G1 X176.31 Y155.152 E.04399
G3 X176.961 Y155.04 I.404 J.398 E.02336
G1 X176.961 Y153.221 E.06032
G1 X176.31 Y154.365 E.04366
G1 X175.983 Y154.529 E.01215
G3 X174.345 Y153.685 I.417 J-2.819 E.06225
G1 X173.69 Y152.532 E.04399
G2 X173.115 Y152.407 I-.374 J.339 E.02081
G1 X173.115 Y151.764 E.02131
G1 X173.729 Y151.764 E.02036
G2 X174.583 Y151.764 I.427 J-.71 E.02976
G1 X176.211 Y151.764 E.05401
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
G1 F1901
M204 S8000
G1 X172.768 Y168.584 E.15062
G1 X172.768 Y151.416 E.56948
G1 X177.309 Y151.416 E.15062
G1 X177.309 Y168.524 E.56749
; COOLING_NODE: 0
M204 S10000
G1 X177.716 Y168.991 F60000
G1 F1901
M204 S8000
G1 X172.361 Y168.991 E.17763
G1 X172.361 Y151.009 E.59649
G1 X177.716 Y151.009 E.17763
G1 X177.716 Y168.931 E.5945
; COOLING_NODE: 0
M204 S10000
G1 X178.123 Y169.398 F60000
G1 F1901
M204 S8000
G1 X171.954 Y169.398 E.20463
G1 X171.954 Y150.602 E.62349
G1 X178.123 Y150.602 E.20463
G1 X178.123 Y169.338 E.6215
; COOLING_NODE: 0
M204 S250
G1 X178.515 Y169.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
M73 P72 R5
G1 F1748
M204 S5000
G1 X171.562 Y169.79 E.21365
G1 X171.562 Y150.21 E.60164
G1 X178.515 Y150.21 E.21365
G1 X178.515 Y169.73 E.5998
;======== H2D 20260731========
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
G1 F1901
M204 S8000
G1 X176.961 Y165.206 E.05401
G3 X176.713 Y164.586 I.392 J-.516 E.02326
G3 X176.961 Y163.801 I1.54 J.054 E.02764
G1 X176.961 Y159.965 E.12727
G3 X176.713 Y159.345 I.392 J-.516 E.02326
G3 X176.961 Y158.56 I1.54 J.054 E.02764
G1 X176.961 Y154.724 E.12727
G3 X176.713 Y154.104 I.392 J-.516 E.02326
G3 X176.961 Y153.319 I1.54 J.054 E.02764
G1 X176.961 Y151.764 E.05156
G1 X174.885 Y151.764 E.06885
G2 X174.124 Y152.466 I.713 J1.538 E.03489
G1 X174.092 Y152.793 E.01092
G2 X174.724 Y154.104 I2.083 J-.197 E.04928
G1 X175.634 Y154.759 E.0372
G3 X175.908 Y155.414 I-.409 J.555 E.02474
G3 X175.276 Y156.724 I-2.083 J-.197 E.04928
G1 X174.366 Y157.379 E.0372
G2 X174.092 Y158.035 I.409 J.555 E.02474
G2 X174.724 Y159.345 I2.083 J-.197 E.04928
G1 X175.634 Y160 E.0372
G3 X175.908 Y160.655 I-.409 J.555 E.02474
G3 X175.276 Y161.966 I-2.083 J-.197 E.04928
G1 X174.366 Y162.621 E.0372
G2 X174.092 Y163.276 I.409 J.555 E.02474
G2 X174.724 Y164.586 I2.083 J-.197 E.04928
G1 X175.634 Y165.241 E.0372
G3 X175.908 Y165.897 I-.409 J.555 E.02474
G3 X175.276 Y167.207 I-2.083 J-.197 E.04928
G1 X174.366 Y167.862 E.0372
G1 X174.119 Y168.236 E.01484
G1 X173.116 Y168.236 E.03327
G1 X173.116 Y167.723 E.01701
G2 X173.287 Y167.207 I-.344 J-.4 E.01893
G1 X173.116 Y166.557 E.02229
G1 X173.116 Y162.481 E.13519
G2 X173.287 Y161.966 I-.344 J-.4 E.01893
G1 X173.116 Y161.316 E.02229
G1 X173.116 Y157.24 E.13519
G2 X173.287 Y156.724 I-.344 J-.4 E.01893
G1 X173.116 Y156.074 E.02229
G1 X173.116 Y154.446 E.05401
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

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z13 I-1.153 J.389 P1  F60000
G1 X177.309 Y168.584 Z13
G1 Z12.8
G1 E.8 F1800
; FEATURE: Inner wall
G1 F1778
M204 S8000
G1 X172.769 Y168.584 E.15058
G1 X172.769 Y151.416 E.56948
G1 X177.309 Y151.416 E.15058
G1 X177.309 Y168.524 E.56749
; COOLING_NODE: 0
M204 S10000
G1 X177.716 Y168.991 F60000
G1 F1778
M204 S8000
G1 X172.362 Y168.991 E.17759
G1 X172.362 Y151.009 E.59649
G1 X177.716 Y151.009 E.17759
G1 X177.716 Y168.931 E.5945
; COOLING_NODE: 0
M204 S10000
G1 X178.123 Y169.398 F60000
G1 F1778
M204 S8000
G1 X171.955 Y169.398 E.20459
G1 X171.955 Y150.602 E.62349
G1 X178.123 Y150.602 E.20459
G1 X178.123 Y169.338 E.6215
; COOLING_NODE: 0
M204 S250
G1 X178.515 Y169.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1736
M204 S5000
G1 X171.563 Y169.79 E.21361
G1 X171.563 Y150.21 E.60164
G1 X178.515 Y150.21 E.21361
G1 X178.515 Y169.73 E.5998
;======== H2D 20260731========
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
G1 F1778
M204 S8000
G1 X176.961 Y164.751 E.05401
G1 X176.9 Y164.586 E.00583
M73 P73 R5
G1 X176.961 Y163.884 E.02338
G1 X176.961 Y159.51 E.1451
G1 X176.9 Y159.345 E.00583
G1 X176.961 Y158.643 E.02338
G1 X176.961 Y154.269 E.1451
G1 X176.9 Y154.104 E.00583
G1 X176.961 Y153.402 E.02338
G1 X176.961 Y151.764 E.05431
G1 X175.065 Y151.764 E.06286
G2 X174.4 Y152.466 I2.851 J3.374 E.03214
G2 X174.64 Y154.104 I1.661 J.593 E.05716
G3 X175.601 Y155.086 I-3.981 J4.852 E.04567
G3 X175.36 Y156.724 I-1.661 J.593 E.05716
G2 X174.4 Y157.707 I3.982 J4.852 E.04567
G2 X174.64 Y159.345 I1.661 J.593 E.05716
G3 X175.601 Y160.328 I-3.981 J4.851 E.04567
G3 X175.36 Y161.966 I-1.661 J.593 E.05716
G2 X174.4 Y162.948 I3.982 J4.852 E.04567
G2 X174.64 Y164.586 I1.661 J.593 E.05716
G3 X175.601 Y165.569 I-3.981 J4.852 E.04567
G3 X175.36 Y167.207 I-1.661 J.593 E.05716
G2 X174.383 Y168.236 I2.838 J3.675 E.04725
G1 X173.118 Y168.236 E.04196
G1 X173.118 Y167.872 E.01205
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
G1 F1658
M204 S8000
G1 X172.771 Y168.584 E.15054
G1 X172.771 Y151.416 E.56948
G1 X177.309 Y151.416 E.15054
G1 X177.309 Y168.524 E.56749
; COOLING_NODE: 0
M204 S10000
G1 X177.716 Y168.991 F60000
G1 F1658
M204 S8000
G1 X172.364 Y168.991 E.17755
G1 X172.364 Y151.009 E.59649
G1 X177.716 Y151.009 E.17755
G1 X177.716 Y168.931 E.5945
; COOLING_NODE: 0
M204 S10000
G1 X178.123 Y169.398 F60000
G1 F1658
M204 S8000
G1 X171.957 Y169.398 E.20455
G1 X171.957 Y150.602 E.62349
G1 X178.123 Y150.602 E.20455
G1 X178.123 Y169.338 E.6215
; COOLING_NODE: 0
M204 S250
G1 X178.515 Y169.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1658
M204 S5000
G1 X171.564 Y169.79 E.21357
G1 X171.564 Y150.21 E.60164
G1 X178.515 Y150.21 E.21357
G1 X178.515 Y169.73 E.5998
;======== H2D 20260731========
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
G1 F1658
M204 S8000
G1 X174.627 Y168.236 E.05401
G3 X175.457 Y167.207 I6.572 J4.453 E.04389
G2 X175.104 Y165.241 I-1.487 J-.748 E.07104
G1 X174.543 Y164.586 E.0286
G3 X174.896 Y162.621 I1.487 J-.748 E.07104
G1 X175.457 Y161.966 E.02861
G2 X175.104 Y160 I-1.487 J-.748 E.07104
G1 X174.543 Y159.345 E.0286
G3 X174.896 Y157.379 I1.487 J-.748 E.07104
G1 X175.457 Y156.724 E.0286
G2 X175.104 Y154.759 I-1.487 J-.748 E.07104
G1 X174.543 Y154.104 E.0286
G3 X174.896 Y152.138 I1.487 J-.748 E.07104
G1 X175.216 Y151.764 E.01632
G1 X173.587 Y151.764 E.05401
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
G1 F1660
M204 S8000
G1 X172.772 Y168.584 E.1505
G1 X172.772 Y151.416 E.56948
G1 X177.309 Y151.416 E.1505
G1 X177.309 Y168.524 E.56749
; COOLING_NODE: 0
M204 S10000
G1 X177.716 Y168.991 F60000
G1 F1660
M204 S8000
G1 X172.365 Y168.991 E.1775
G1 X172.365 Y151.009 E.59649
G1 X177.716 Y151.009 E.1775
G1 X177.716 Y168.931 E.5945
; COOLING_NODE: 0
M204 S10000
G1 X178.123 Y169.398 F60000
M73 P74 R5
G1 F1660
M204 S8000
G1 X171.958 Y169.398 E.20451
G1 X171.958 Y150.602 E.62349
G1 X178.123 Y150.602 E.20451
G1 X178.123 Y169.338 E.6215
; COOLING_NODE: 0
M204 S250
G1 X178.515 Y169.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1660
M204 S5000
G1 X171.566 Y169.79 E.21353
G1 X171.566 Y150.21 E.60164
G1 X178.515 Y150.21 E.21353
G1 X178.515 Y169.73 E.5998
;======== H2D 20260731========
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
G1 F1660
M204 S8000
G1 X174.78 Y168.236 E.05401
G1 X175.097 Y167.862 E.01627
G2 X175.46 Y165.897 I-1.135 J-1.226 E.07107
G1 X174.903 Y165.241 E.02854
G3 X174.54 Y163.276 I1.135 J-1.226 E.07107
G1 X175.097 Y162.621 E.02854
G2 X175.46 Y160.655 I-1.135 J-1.226 E.07107
G1 X174.903 Y160 E.02854
G3 X174.54 Y158.035 I1.135 J-1.226 E.07107
G1 X175.097 Y157.379 E.02854
G2 X175.46 Y155.414 I-1.135 J-1.226 E.07107
G1 X174.903 Y154.759 E.02854
G3 X174.54 Y152.793 I1.135 J-1.226 E.07107
G2 X175.368 Y151.764 I-6.168 J-5.813 E.04386
G1 X173.74 Y151.764 E.05401
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
G1 F1770
M204 S8000
G1 X172.773 Y168.584 E.15046
G1 X172.773 Y151.416 E.56948
G1 X177.309 Y151.416 E.15046
G1 X177.309 Y168.524 E.56749
; COOLING_NODE: 0
M204 S10000
G1 X177.716 Y168.991 F60000
G1 F1770
M204 S8000
G1 X172.366 Y168.991 E.17746
G1 X172.366 Y151.009 E.59649
G1 X177.716 Y151.009 E.17746
G1 X177.716 Y168.931 E.5945
; COOLING_NODE: 0
M204 S10000
G1 X178.123 Y169.398 F60000
G1 F1770
M204 S8000
G1 X171.959 Y169.398 E.20447
G1 X171.959 Y150.602 E.62349
G1 X178.123 Y150.602 E.20447
G1 X178.123 Y169.338 E.6215
; COOLING_NODE: 0
M204 S250
G1 X178.515 Y169.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1770
M204 S5000
G1 X171.567 Y169.79 E.2135
G1 X171.567 Y150.21 E.60164
G1 X178.515 Y150.21 E.2135
G1 X178.515 Y169.73 E.5998
;======== H2D 20260731========
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
M73 P75 R5
G1 X176.961 Y165.604 Z13.8 F60000
G1 Z13.4
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F1770
M204 S8000
G1 X176.905 Y163.276 E.07726
G1 X176.961 Y163.128 E.00524
G1 X176.961 Y158.735 E.14573
G1 X176.905 Y158.035 E.0233
M73 P75 R4
G1 X176.961 Y157.887 E.00524
G1 X176.961 Y153.494 E.14573
G1 X176.905 Y152.793 E.0233
G1 X176.961 Y152.645 E.00524
G1 X176.961 Y151.764 E.02922
G1 X175.61 Y151.764 E.04479
G3 X174.637 Y152.793 I-3.916 J-2.73 E.04715
G2 X174.285 Y154.104 I1.362 J1.069 E.04625
G1 X174.407 Y154.431 E.0116
G2 X175.363 Y155.414 I5.143 J-4.047 E.04556
G3 X175.715 Y156.724 I-1.362 J1.069 E.04625
G1 X175.593 Y157.052 E.0116
G3 X174.637 Y158.035 I-5.143 J-4.047 E.04556
G2 X174.285 Y159.345 I1.362 J1.069 E.04625
G1 X174.407 Y159.673 E.0116
G2 X175.363 Y160.655 I5.144 J-4.047 E.04556
G3 X175.715 Y161.966 I-1.362 J1.069 E.04625
G1 X175.593 Y162.293 E.0116
G3 X174.637 Y163.276 I-5.143 J-4.046 E.04556
G2 X174.285 Y164.586 I1.362 J1.069 E.04625
G1 X174.407 Y164.914 E.0116
G2 X175.363 Y165.897 I5.143 J-4.047 E.04556
G3 X175.715 Y167.207 I-1.362 J1.069 E.04625
G3 X174.93 Y168.236 I-2.131 J-.813 E.04353
G1 X173.301 Y168.236 E.05401
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

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z13.8 I-.34 J1.168 P1  F60000
G1 X177.309 Y168.584 Z13.8
G1 Z13.6
G1 E.8 F1800
; FEATURE: Inner wall
G1 F1910
M204 S8000
G1 X172.774 Y168.584 E.15042
G1 X172.774 Y151.416 E.56948
G1 X177.309 Y151.416 E.15042
G1 X177.309 Y168.524 E.56749
; COOLING_NODE: 0
M204 S10000
G1 X177.716 Y168.991 F60000
G1 F1910
M204 S8000
G1 X172.367 Y168.991 E.17742
G1 X172.367 Y151.009 E.59649
G1 X177.716 Y151.009 E.17742
G1 X177.716 Y168.931 E.5945
; COOLING_NODE: 0
M204 S10000
G1 X178.123 Y169.398 F60000
G1 F1910
M204 S8000
G1 X171.96 Y169.398 E.20443
G1 X171.96 Y150.602 E.62349
G1 X178.123 Y150.602 E.20443
G1 X178.123 Y169.338 E.6215
; COOLING_NODE: 0
M204 S250
G1 X178.515 Y169.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1910
M204 S5000
G1 X171.568 Y169.79 E.21346
G1 X171.568 Y150.21 E.60164
G1 X178.515 Y150.21 E.21346
G1 X178.515 Y169.73 E.5998
;======== H2D 20260731========
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
G1 F1910
M204 S8000
G1 X173.123 Y166.514 E.05401
G2 X173.245 Y165.569 I-1.203 J-.636 E.03228
G1 X173.123 Y165.405 E.00677
G1 X173.123 Y161.272 E.1371
G2 X173.245 Y160.328 I-1.203 J-.636 E.03228
G1 X173.123 Y160.164 E.00677
G1 X173.123 Y156.031 E.1371
G2 X173.245 Y155.086 I-1.203 J-.636 E.03228
G1 X173.123 Y154.923 E.00677
G1 X173.123 Y153.294 E.05401
M204 S10000
G1 X176.961 Y155.203 F60000
G1 F1910
M204 S8000
G1 X176.961 Y153.575 E.05401
G3 X176.72 Y152.793 I1.267 J-.818 E.02748
G1 X176.755 Y152.466 E.01093
G2 X176.961 Y151.764 I-.368 J-.488 E.02598
G1 X175.87 Y151.764 E.03616
G1 X175.621 Y152.138 E.0149
G1 X174.721 Y152.793 E.03692
G2 X174.099 Y154.104 I1.446 J1.489 E.04915
G2 X174.379 Y154.759 I.695 J.091 E.02479
G1 X175.279 Y155.414 E.03692
G3 X175.901 Y156.724 I-1.446 J1.489 E.04915
G3 X175.621 Y157.379 I-.695 J.091 E.02479
G1 X174.721 Y158.035 E.03692
G2 X174.099 Y159.345 I1.446 J1.489 E.04915
G2 X174.379 Y160 I.695 J.091 E.02479
G1 X175.279 Y160.655 E.03692
G3 X175.901 Y161.966 I-1.446 J1.489 E.04915
G3 X175.621 Y162.621 I-.695 J.091 E.02479
G1 X174.721 Y163.276 E.03692
G2 X174.099 Y164.586 I1.446 J1.489 E.04915
G2 X174.379 Y165.241 I.695 J.091 E.02479
G1 X175.279 Y165.897 E.03692
G3 X175.901 Y167.207 I-1.446 J1.489 E.04915
G1 X175.865 Y167.535 E.01093
G3 X175.108 Y168.236 I-1.51 J-.871 E.03475
G1 X176.75 Y168.236 E.05448
G1 X176.961 Y167.915 E.01272
G1 X176.961 Y164.058 E.12794
G3 X176.72 Y163.276 I1.267 J-.818 E.02748
G3 X176.961 Y162.673 I.631 J-.097 E.02258
G1 X176.961 Y158.816 E.12794
G3 X176.72 Y158.035 I1.267 J-.818 E.02748
G3 X176.961 Y157.432 I.631 J-.097 E.02258
G1 X176.961 Y155.804 E.05401
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
G1 F2101
M204 S8000
G1 X172.776 Y168.584 E.15038
G1 X172.776 Y151.416 E.56948
G1 X177.309 Y151.416 E.15038
G1 X177.309 Y168.524 E.56749
; COOLING_NODE: 0
M204 S10000
G1 X177.716 Y168.991 F60000
G1 F2101
M204 S8000
G1 X172.369 Y168.991 E.17738
G1 X172.369 Y151.009 E.59649
G1 X177.716 Y151.009 E.17738
G1 X177.716 Y168.931 E.5945
; COOLING_NODE: 0
M204 S10000
M73 P76 R4
G1 X178.123 Y169.398 F60000
G1 F2101
M204 S8000
G1 X171.961 Y169.398 E.20439
G1 X171.961 Y150.602 E.62349
G1 X178.123 Y150.602 E.20439
G1 X178.123 Y169.338 E.6215
; COOLING_NODE: 0
M204 S250
G1 X178.515 Y169.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2044
M204 S5000
G1 X171.569 Y169.79 E.21342
G1 X171.569 Y150.21 E.60164
G1 X178.515 Y150.21 E.21342
G1 X178.515 Y169.73 E.5998
;======== H2D 20260731========
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
G1 F2101
M204 S8000
G1 X175.873 Y167.858 E.01592
G1 X175.873 Y166.71 E.03809
G2 X174.345 Y165.515 I-2.021 J1.009 E.06653
G2 X173.501 Y165.947 I-.225 J.6 E.0354
G1 X173.501 Y164.963 E.03266
G1 X173.69 Y164.875 E.0069
G1 X174.345 Y163.697 E.0447
G3 X175.873 Y162.855 I2.121 J2.04 E.05878
G1 X175.873 Y161.469 E.04598
G2 X174.345 Y160.273 I-2.021 J1.009 E.06653
G2 X173.501 Y160.706 I-.225 J.6 E.0354
G1 X173.501 Y159.721 E.03266
G1 X173.69 Y159.634 E.0069
G1 X174.345 Y158.456 E.0447
G3 X175.873 Y157.613 I2.121 J2.04 E.05878
G1 X175.873 Y156.227 E.04598
G2 X174.345 Y155.032 I-2.021 J1.009 E.06653
G2 X173.501 Y155.465 I-.225 J.6 E.0354
G1 X173.501 Y154.48 E.03266
G1 X173.69 Y154.392 E.0069
G1 X174.345 Y153.215 E.0447
G3 X175.873 Y152.372 I2.121 J2.04 E.05878
G1 X175.873 Y152.142 E.00765
G1 X174.476 Y152.142 E.04637
M204 S10000
G1 X173.138 Y153.443 F60000
; FEATURE: Floating vertical shell
; LINE_WIDTH: 0.383912
G1 F2101
M204 S8000
G1 X173.138 Y151.938 E.04182
G1 X173.166 Y151.806 E.00374
G1 X173.298 Y151.779 E.00374
G1 X176.017 Y151.779 E.07556
M204 S10000
G1 X176.317 Y168.062 F60000
; LINE_WIDTH: 0.503045
G1 F2101
M204 S8000
G1 X176.246 Y168.114 E.00331
; LINE_WIDTH: 0.454995
G1 X176.175 Y168.167 E.00297
; LINE_WIDTH: 0.406945
G1 X176.105 Y168.22 E.00262
; LINE_WIDTH: 0.404702
G1 X176.226 Y168.196 E.00366
; LINE_WIDTH: 0.448264
G1 X176.348 Y168.172 E.0041
; LINE_WIDTH: 0.491827
G1 X176.469 Y168.147 E.00454
; LINE_WIDTH: 0.556758
G3 X176.848 Y168.123 I.25 J.941 E.01599
G1 X176.848 Y151.877 E.68025
G1 X176.395 Y151.866 E.01897
; LINE_WIDTH: 0.518633
G1 X176.316 Y151.844 E.0032
; LINE_WIDTH: 0.479858
G1 X176.236 Y151.823 E.00294
; LINE_WIDTH: 0.441083
G1 X176.156 Y151.801 E.00268
; LINE_WIDTH: 0.402308
G1 X176.077 Y151.779 E.00242
G1 X176.138 Y151.819 E.00215
; LINE_WIDTH: 0.441083
G1 X176.2 Y151.859 E.00238
; LINE_WIDTH: 0.479858
G1 X176.262 Y151.898 E.00261
; LINE_WIDTH: 0.518633
G1 X176.323 Y151.938 E.00284
; LINE_WIDTH: 0.556926
G1 X176.322 Y168.002 E.67283
M204 S10000
G1 X173.138 Y166.128 F60000
; LINE_WIDTH: 0.383821
G1 F2101
M204 S8000
G1 X173.138 Y168.062 E.05373
G1 X173.166 Y168.194 E.00374
G1 X173.298 Y168.221 E.00374
G1 X176.045 Y168.221 E.07631
M204 S10000
G1 X173.138 Y165.17 F60000
; Slow Down Start
; LINE_WIDTH: 0.38292
G1 F3000;_EXTRUDE_SET_SPEED
M204 S8000
G1 X173.138 Y159.968 E.14414
; Slow Down End
M204 S10000
G1 X173.138 Y154.896 F60000
G1 F2101
M204 S8000
G1 X173.138 Y154.621 E.00763
M204 S10000
G1 X173.138 Y158.863 F60000
; Slow Down Start
G1 F3000;_EXTRUDE_SET_SPEED
M204 S8000
G1 X173.138 Y155.751 E.08623
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
G1 F2508
M204 S8000
G1 X172.777 Y168.584 E.15034
G1 X172.777 Y151.416 E.56948
G1 X177.309 Y151.416 E.15034
G1 X177.309 Y168.524 E.56749
; COOLING_NODE: 0
M204 S10000
G1 X177.716 Y168.991 F60000
G1 F2508
M204 S8000
G1 X172.37 Y168.991 E.17734
G1 X172.37 Y151.009 E.59649
G1 X177.716 Y151.009 E.17734
G1 X177.716 Y168.931 E.5945
; COOLING_NODE: 0
M204 S10000
G1 X178.123 Y169.398 F60000
G1 F2508
M204 S8000
G1 X171.963 Y169.398 E.20435
G1 X171.963 Y150.602 E.62349
G1 X178.123 Y150.602 E.20435
G1 X178.123 Y169.338 E.6215
; COOLING_NODE: 0
M204 S250
G1 X178.515 Y169.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2131
M204 S5000
G1 X171.571 Y169.79 E.21338
G1 X171.571 Y150.21 E.60164
G1 X178.515 Y150.21 E.21338
G1 X178.515 Y169.73 E.5998
;======== H2D 20260731========
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
M73 P77 R4
G1 X176.929 Y168.204 Z14.4 F60000
G1 Z14
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.39612
G1 F2508
M204 S8000
G1 X176.929 Y151.856 E.4705
M204 S10000
G1 X176.73 Y151.789 F60000
; FEATURE: Bridge
; LINE_WIDTH: 0.40616
; LAYER_HEIGHT: 0.4
G1 F3000
M204 S8000
G1 X173.147 Y151.789 E.18915
G1 X173.147 Y152.245 E.02408
G1 X176.527 Y152.245 E.17846
G1 X176.527 Y152.702 E.02408
G1 X173.147 Y152.702 E.17846
G1 X173.147 Y153.158 E.02408
G1 X176.527 Y153.158 E.17846
G1 X176.527 Y153.614 E.02408
G1 X173.725 Y153.614 E.14791
G1 X174.473 Y153.922 E.0427
G1 X174.197 Y154.07 E.01655
G1 X176.527 Y154.07 E.12303
G1 X176.527 Y154.526 E.02408
G1 X173.344 Y154.526 E.16804
G1 X173.147 Y154.632 E.01181
G1 X173.147 Y154.824 E.01017
G1 X173.409 Y154.982 E.01619
G1 X176.527 Y154.982 E.16459
G1 X176.527 Y155.438 E.02408
G1 X173.373 Y155.438 E.16651
G1 X173.198 Y155.753 E.01899
G2 X173.147 Y155.895 I.038 J.094 E.00897
G1 X176.527 Y155.895 E.17846
G1 X176.527 Y156.351 E.02408
G1 X173.147 Y156.351 E.17846
G1 X173.147 Y156.807 E.02408
G1 X176.527 Y156.807 E.17846
G1 X176.527 Y157.263 E.02408
G1 X173.147 Y157.263 E.17846
G1 X173.147 Y157.719 E.02408
G1 X176.527 Y157.719 E.17846
G1 X176.527 Y158.175 E.02408
G1 X173.147 Y158.175 E.17846
G1 X173.147 Y158.632 E.02408
G1 X176.527 Y158.632 E.17846
G1 X176.527 Y159.088 E.02408
G1 X173.8 Y159.088 E.14397
G1 X174.242 Y159.286 E.02556
G1 X173.835 Y159.544 E.02542
G1 X176.527 Y159.544 E.14211
G1 X176.527 Y160 E.02408
G1 X173.147 Y160 E.17846
G1 X173.147 Y160.456 E.02408
G1 X176.527 Y160.456 E.17846
G1 X176.527 Y160.912 E.02408
G1 X173.147 Y160.912 E.17846
G1 X173.147 Y161.369 E.02408
G1 X176.527 Y161.369 E.17846
G1 X176.527 Y161.825 E.02408
G1 X173.147 Y161.825 E.17846
G1 X173.147 Y162.281 E.02408
G1 X176.527 Y162.281 E.17846
G1 X176.527 Y162.737 E.02408
G1 X173.147 Y162.737 E.17846
G1 X173.147 Y163.193 E.02408
G1 X176.527 Y163.193 E.17846
G1 X176.527 Y163.649 E.02408
G1 X173.147 Y163.649 E.17846
G1 X173.147 Y164.106 E.02408
G1 X176.527 Y164.106 E.17846
G1 X176.527 Y164.562 E.02408
G1 X173.147 Y164.562 E.17846
G1 X173.147 Y165.018 E.02408
G1 X176.527 Y165.018 E.17846
G1 X176.527 Y165.474 E.02408
G1 X173.956 Y165.474 E.13573
G1 X174.032 Y165.509 E.00439
G1 X173.496 Y165.93 E.03597
G1 X176.527 Y165.93 E.16
G1 X176.527 Y166.386 E.02408
G1 X173.147 Y166.386 E.17846
G1 X173.147 Y166.842 E.02408
G1 X176.527 Y166.842 E.17846
G1 X176.527 Y167.299 E.02408
G1 X173.147 Y167.299 E.17846
G1 X173.147 Y167.755 E.02408
G1 X176.527 Y167.755 E.17846
G1 X176.527 Y168.211 E.02408
G1 X172.944 Y168.211 E.18915
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
G1 F2588
M204 S8000
G1 X172.778 Y168.584 E.15029
G1 X172.778 Y151.416 E.56948
G1 X177.309 Y151.416 E.15029
G1 X177.309 Y168.524 E.56749
; COOLING_NODE: 0
M204 S10000
G1 X177.716 Y168.991 F60000
G1 F2588
M204 S8000
G1 X172.371 Y168.991 E.1773
G1 X172.371 Y151.009 E.59649
G1 X177.716 Y151.009 E.1773
G1 X177.716 Y168.931 E.5945
; COOLING_NODE: 0
M204 S10000
G1 X178.123 Y169.398 F60000
G1 F2588
M204 S8000
G1 X171.964 Y169.398 E.20431
G1 X171.964 Y150.602 E.62349
G1 X178.123 Y150.602 E.20431
G1 X178.123 Y169.338 E.6215
; COOLING_NODE: 0
M204 S250
G1 X178.515 Y169.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2194
M204 S5000
G1 X171.572 Y169.79 E.21335
G1 X171.572 Y150.21 E.60164
G1 X178.515 Y150.21 E.21335
G1 X178.515 Y169.73 E.5998
;======== H2D 20260731========
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
G1 X175.82 Y167.095 Z14.6 F60000
G1 Z14.2
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.35098
G1 F2588
M204 S8000
G1 X175.82 Y152.965 E.35471
M204 S10000
G1 X176.163 Y152.905 F60000
; LINE_WIDTH: 0.41999
G1 F2588
M204 S8000
G1 X176.163 Y152.562 E.01053
G1 X175.477 Y152.562 E.02105
G1 X175.477 Y167.438 E.45706
G1 X176.163 Y167.438 E.02105
G1 X176.163 Y152.965 E.44469
M204 S10000
G1 X176.54 Y152.905 F60000
G1 F2588
M204 S8000
G1 X176.54 Y152.185 E.02211
G1 X175.1 Y152.185 E.04422
G1 X175.1 Y167.815 E.48023
G1 X176.54 Y167.815 E.04422
G1 X176.54 Y152.965 E.45628
M204 S10000
G1 X176.917 Y152.905 F60000
G1 F2588
M204 S8000
G1 X176.917 Y151.808 E.0337
G1 X174.723 Y151.808 E.0674
G1 X174.723 Y168.192 E.50341
G1 X176.917 Y168.192 E.0674
G1 X176.917 Y152.965 E.46786
M204 S10000
G1 X174.016 Y151.764 F60000
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F2588
M204 S8000
G1 X174.331 Y151.764 E.01047
G1 X174.331 Y153.077 E.04354
G1 X174.227 Y153.134 E.00395
G3 X173.126 Y154.059 I-2.695 J-2.091 E.04803
G1 X173.126 Y156.383 E.07712
G3 X174.331 Y155.441 I2.878 J2.437 E.05111
G1 X174.331 Y158.318 E.09546
G1 X174.227 Y158.376 E.00395
G3 X173.126 Y159.3 I-2.695 J-2.091 E.04803
G1 X173.126 Y161.625 E.07712
M73 P78 R4
G3 X174.331 Y160.682 I2.878 J2.437 E.05111
G1 X174.331 Y163.56 E.09546
G1 X174.227 Y163.617 E.00395
G3 X173.126 Y164.541 I-2.695 J-2.091 E.04803
G1 X173.126 Y166.866 E.07712
G3 X174.331 Y165.923 I2.878 J2.437 E.05111
G1 X174.331 Y167.551 E.05401
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
G1 F2582
M204 S8000
G1 X172.779 Y168.584 E.15025
G1 X172.779 Y151.416 E.56948
G1 X177.309 Y151.416 E.15025
G1 X177.309 Y168.524 E.56749
; COOLING_NODE: 0
M204 S10000
G1 X177.716 Y168.991 F60000
G1 F2582
M204 S8000
G1 X172.372 Y168.991 E.17726
G1 X172.372 Y151.009 E.59649
G1 X177.716 Y151.009 E.17726
G1 X177.716 Y168.931 E.5945
; COOLING_NODE: 0
M204 S10000
G1 X178.123 Y169.398 F60000
G1 F2582
M204 S8000
G1 X171.965 Y169.398 E.20427
G1 X171.965 Y150.602 E.62349
G1 X178.123 Y150.602 E.20427
G1 X178.123 Y169.338 E.6215
; COOLING_NODE: 0
M204 S250
G1 X178.515 Y169.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2232
M204 S5000
G1 X171.573 Y169.79 E.21331
G1 X171.573 Y150.21 E.60164
G1 X178.515 Y150.21 E.21331
G1 X178.515 Y169.73 E.5998
;======== H2D 20260731========
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
G1 F2582
M204 S8000
G1 X174.331 Y166.056 E.05401
G2 X173.128 Y166.984 I5.842 J8.827 E.05045
G1 X173.128 Y164.38 E.08636
G2 X174.227 Y163.489 I-9.597 J-12.964 E.04695
G1 X174.331 Y163.452 E.00368
G1 X174.331 Y160.815 E.08747
G2 X173.128 Y161.742 I5.84 J8.824 E.05045
G1 X173.128 Y159.139 E.08636
G2 X174.227 Y158.248 I-9.594 J-12.961 E.04695
G1 X174.331 Y158.21 E.00368
G1 X174.331 Y155.574 E.08747
G2 X173.128 Y156.501 I5.842 J8.827 E.05045
G1 X173.128 Y153.898 E.08636
G2 X174.227 Y153.007 I-9.597 J-12.964 E.04695
G1 X174.331 Y152.969 E.00368
G1 X174.331 Y151.764 E.03996
G1 X173.908 Y151.764 E.01405
M204 S10000
G1 X176.917 Y152.905 F60000
; FEATURE: Floating vertical shell
; LINE_WIDTH: 0.41999
G1 F2582
M204 S8000
G1 X176.917 Y151.808 E.0337
G1 X174.723 Y151.808 E.0674
G1 X174.723 Y168.192 E.50341
G1 X176.917 Y168.192 E.0674
G1 X176.917 Y152.965 E.46786
M204 S10000
G1 X176.54 Y152.905 F60000
G1 F2582
M204 S8000
G1 X176.54 Y152.185 E.02211
G1 X175.1 Y152.185 E.04422
G1 X175.1 Y167.815 E.48023
G1 X176.54 Y167.815 E.04422
G1 X176.54 Y152.965 E.45628
M204 S10000
G1 X176.163 Y152.905 F60000
G1 F2582
M204 S8000
G1 X176.163 Y152.562 E.01053
G1 X175.477 Y152.562 E.02105
G1 X175.477 Y167.438 E.45706
G1 X176.163 Y167.438 E.02105
G1 X176.163 Y152.965 E.44469
M204 S10000
G1 X175.82 Y167.095 F60000
; LINE_WIDTH: 0.35098
G1 F2582
M204 S8000
G1 X175.82 Y152.965 E.35471
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
G1 F2846
M204 S8000
G1 X172.781 Y168.584 E.15021
G1 X172.781 Y151.416 E.56948
G1 X177.309 Y151.416 E.15021
G1 X177.309 Y168.524 E.56749
; COOLING_NODE: 0
M204 S10000
G1 X177.716 Y168.991 F60000
G1 F2846
M204 S8000
G1 X172.373 Y168.991 E.17722
G1 X172.373 Y151.009 E.59649
G1 X177.716 Y151.009 E.17722
G1 X177.716 Y168.931 E.5945
; COOLING_NODE: 0
M204 S10000
G1 X178.123 Y169.398 F60000
G1 F2846
M204 S8000
G1 X171.966 Y169.398 E.20423
G1 X171.966 Y150.602 E.62349
G1 X178.123 Y150.602 E.20423
G1 X178.123 Y169.338 E.6215
; COOLING_NODE: 0
M204 S250
G1 X178.515 Y169.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2249
M204 S5000
G1 X171.574 Y169.79 E.21327
M73 P79 R4
G1 X171.574 Y150.21 E.60164
G1 X178.515 Y150.21 E.21327
G1 X178.515 Y169.73 E.5998
;======== H2D 20260731========
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
G1 F2846
M204 S8000
G1 X173.129 Y168.236 E.01764
G1 X173.129 Y167.139 E.03637
G2 X174.227 Y166.221 I-1.834 J-3.309 E.04776
G1 X174.331 Y166.167 E.00391
G1 X174.331 Y163.322 E.09435
G2 X173.129 Y164.259 I1.908 J3.691 E.05084
G1 X173.129 Y161.898 E.07831
G2 X174.227 Y160.98 I-1.834 J-3.309 E.04776
G1 X174.331 Y160.925 E.00391
G1 X174.331 Y158.081 E.09435
G2 X173.129 Y159.017 I1.908 J3.691 E.05084
G1 X173.129 Y156.656 E.07831
G2 X174.227 Y155.739 I-1.833 J-3.309 E.04776
G1 X174.331 Y155.684 E.00391
G1 X174.331 Y152.84 E.09435
G2 X173.129 Y153.776 I1.908 J3.692 E.05084
G1 X173.129 Y152.148 E.05401
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
G1 F2846
M204 S2000
G1 X177.086 Y152.221 E.02532
G1 X177.22 Y152.355
G1 X177.22 Y152.888
G1 X177.086 Y152.754
G1 X175.971 Y151.639 E.04849
G1 X175.837 Y151.505
G1 X175.304 Y151.505
G1 X175.437 Y151.639
G1 X177.086 Y153.288 E.07166
G1 X177.22 Y153.421
G1 X177.22 Y153.955
G1 X177.086 Y153.821
G1 X174.904 Y151.639 E.09484
G1 X174.77 Y151.505
G1 X174.42 Y151.688
G1 X174.554 Y151.822
G1 X177.086 Y154.354 E.11006
G1 X177.22 Y154.488
G1 X177.22 Y155.021
G1 X177.086 Y154.888
G1 X174.554 Y152.355 E.11006
G1 X174.42 Y152.221
G1 X174.42 Y152.754
G1 X174.554 Y152.888
G1 X177.086 Y155.421 E.11006
G1 X177.22 Y155.554
G1 X177.22 Y156.088
G1 X177.086 Y155.954
G1 X174.554 Y153.421 E.11006
G1 X174.42 Y153.288
G1 X174.42 Y153.821
G1 X174.554 Y153.955
G1 X177.086 Y156.487 E.11006
G1 X177.22 Y156.621
G1 X177.22 Y157.154
G1 X177.086 Y157.021
G1 X174.554 Y154.488 E.11006
G1 X174.42 Y154.354
G1 X174.42 Y154.887
G1 X174.554 Y155.021
G1 X177.086 Y157.554 E.11006
G1 X177.22 Y157.687
G1 X177.22 Y158.221
G1 X177.086 Y158.087
G1 X174.554 Y155.554 E.11006
G1 X174.42 Y155.421
G1 X174.42 Y155.954
G1 X174.554 Y156.088
G1 X177.086 Y158.62 E.11006
G1 X177.22 Y158.754
G1 X177.22 Y159.287
G1 X177.086 Y159.154
G1 X174.554 Y156.621 E.11006
G1 X174.42 Y156.487
G1 X174.42 Y157.021
G1 X174.554 Y157.154
G1 X177.086 Y159.687 E.11006
G1 X177.22 Y159.82
G1 X177.22 Y160.354
G1 X177.086 Y160.22
G1 X174.554 Y157.687 E.11006
G1 X174.42 Y157.554
G1 X174.42 Y158.087
G1 X174.554 Y158.221
G1 X177.086 Y160.753 E.11006
G1 X177.22 Y160.887
G1 X177.22 Y161.42
G1 X177.086 Y161.287
G1 X174.554 Y158.754 E.11006
G1 X174.42 Y158.62
G1 X174.42 Y159.154
G1 X174.554 Y159.287
G1 X177.086 Y161.82 E.11006
G1 X177.22 Y161.954
G1 X177.22 Y162.487
G1 X177.086 Y162.353
G1 X174.554 Y159.82 E.11006
G1 X174.42 Y159.687
G1 X174.42 Y160.22
G1 X174.554 Y160.354
G1 X177.086 Y162.886 E.11006
G1 X177.22 Y163.02
G1 X177.22 Y163.553
G1 X177.086 Y163.42
G1 X174.554 Y160.887 E.11006
G1 X174.42 Y160.753
G1 X174.42 Y161.287
G1 X174.554 Y161.42
G1 X177.086 Y163.953 E.11006
G1 X177.22 Y164.087
G1 X177.22 Y164.62
G1 X177.086 Y164.486
G1 X174.554 Y161.953 E.11006
G1 X174.42 Y161.82
G1 X174.42 Y162.353
G1 X174.554 Y162.487
G1 X177.086 Y165.019 E.11006
G1 X177.22 Y165.153
G1 X177.22 Y165.686
G1 X177.086 Y165.553
G1 X174.554 Y163.02 E.11006
G1 X174.42 Y162.886
G1 X174.42 Y163.42
G1 X174.554 Y163.553
G1 X177.086 Y166.086 E.11006
G1 X177.22 Y166.22
G1 X177.22 Y166.753
G1 X177.086 Y166.619
G1 X174.554 Y164.087 E.11006
G1 X174.42 Y163.953
G1 X174.42 Y164.486
G1 X174.554 Y164.62
G1 X177.086 Y167.152 E.11006
G1 X177.22 Y167.286
G1 X177.22 Y167.819
G1 X177.086 Y167.686
G1 X174.554 Y165.153 E.11006
G1 X174.42 Y165.019
G1 X174.42 Y165.553
G1 X174.554 Y165.686
G1 X177.086 Y168.219 E.11006
G1 X177.22 Y168.353
G1 X176.829 Y168.495
G1 X176.696 Y168.361
G1 X174.554 Y166.22 E.09308
G1 X174.42 Y166.086
G1 X174.42 Y166.619
G1 X174.554 Y166.753
G1 X176.162 Y168.361 E.0699
G1 X176.296 Y168.495
G1 X175.763 Y168.495
G1 X175.629 Y168.361
G1 X174.554 Y167.286 E.04673
G1 X174.42 Y167.152
G1 X174.42 Y167.686
G1 X174.554 Y167.819
G1 X175.096 Y168.361 E.02356
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

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z15 I-.733 J.971 P1  F60000
G1 X177.277 Y169.398 Z15
G1 Z14.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2303
M204 S8000
G1 X177.277 Y150.602 E.62349
G1 X178.073 Y150.602 E.0264
G1 X178.073 Y169.398 E.62349
G1 X177.337 Y169.398 E.02441
; COOLING_NODE: 0
M204 S250
G1 X176.885 Y169.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2253
M204 S5000
G1 X176.885 Y150.21 E.60164
G1 X178.465 Y150.21 E.04855
G1 X178.465 Y169.79 E.60164
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X176.945 Y169.79 E.04671
M204 S10000
G1 X177.675 Y169.194 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F2303
M204 S8000
G1 X177.675 Y150.806 E.5826
; COOLING_NODE: 0
; WIPE_START
G1 F9259.259
G1 X177.675 Y152.806 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X174.759 Y151.416 Z15.2 F60000
G1 Z14.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2303
M204 S8000
G1 X174.759 Y168.584 E.56948
G1 X172.782 Y168.584 E.06558
G1 X172.782 Y151.416 E.56948
G1 X174.699 Y151.416 E.06359
; COOLING_NODE: 0
M204 S10000
G1 X175.166 Y151.009 F60000
G1 F2303
M204 S8000
G1 X175.166 Y168.991 E.59649
G1 X172.375 Y168.991 E.09259
G1 X172.375 Y151.009 E.59649
G1 X175.106 Y151.009 E.0906
; COOLING_NODE: 0
M204 S10000
G1 X175.573 Y150.602 F60000
G1 F2303
M204 S8000
G1 X175.573 Y169.398 E.62349
G1 X171.968 Y169.398 E.1196
G1 X171.968 Y150.602 E.62349
G1 X175.513 Y150.602 E.11761
; COOLING_NODE: 0
M204 S250
M73 P80 R4
G1 X175.965 Y150.21 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2253
M204 S5000
M73 P80 R3
G1 X175.965 Y169.79 E.60164
G1 X171.576 Y169.79 E.13488
G1 X171.576 Y150.21 E.60164
G1 X175.905 Y150.21 E.13303
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
G1 F2303
M204 S8000
G1 X173.13 Y153.662 E.05401
G3 X174.227 Y152.673 I2.165 J1.3 E.04969
G1 X174.411 Y152.677 E.0061
G1 X174.411 Y155.723 E.10105
G1 X174.227 Y155.858 E.00756
G3 X173.362 Y156.772 I-2.741 J-1.728 E.04199
G1 X173.13 Y156.835 E.00798
G1 X173.13 Y158.903 E.06859
G3 X174.227 Y157.915 I2.165 J1.3 E.04969
G1 X174.411 Y157.919 E.0061
G1 X174.411 Y160.965 E.10105
G1 X174.227 Y161.1 E.00756
G3 X173.362 Y162.013 I-2.741 J-1.728 E.04199
G1 X173.13 Y162.077 E.00798
G1 X173.13 Y164.144 E.06859
G3 X174.227 Y163.156 I2.165 J1.3 E.04969
G1 X174.411 Y163.16 E.0061
G1 X174.411 Y166.206 E.10105
G1 X174.227 Y166.341 E.00756
G3 X173.362 Y167.254 I-2.741 J-1.728 E.04199
G1 X173.13 Y167.318 E.00798
G1 X173.13 Y168.236 E.03044
G1 X173.841 Y168.236 E.02357
; CHANGE_LAYER
; Z_HEIGHT: 15
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F8843.478
G1 X173.13 Y168.236 E-.27004
G1 X173.13 Y167.318 E-.34873
G1 X173.362 Y167.254 E-.09145
G1 X173.464 Y167.172 E-.04979
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
G3 Z15.2 I-.614 J1.051 P1  F60000
G1 X177.277 Y169.398 Z15.2
G1 Z15
G1 E.8 F1800
; FEATURE: Inner wall
G1 F2343
M204 S8000
G1 X177.277 Y150.602 E.62349
G1 X178.073 Y150.602 E.0264
G1 X178.073 Y169.398 E.62349
G1 X177.337 Y169.398 E.02441
; COOLING_NODE: 0
M204 S250
G1 X176.885 Y169.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2247
M204 S5000
G1 X176.885 Y150.21 E.60164
G1 X178.465 Y150.21 E.04855
G1 X178.465 Y169.79 E.60164
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X176.945 Y169.79 E.04671
M204 S10000
G1 X177.675 Y169.194 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F2343
M204 S8000
G1 X177.675 Y150.806 E.5826
; COOLING_NODE: 0
; WIPE_START
G1 F9259.259
G1 X177.675 Y152.806 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X174.759 Y151.416 Z15.4 F60000
G1 Z15
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2343
M204 S8000
G1 X174.759 Y168.584 E.56948
G1 X172.783 Y168.584 E.06554
G1 X172.783 Y151.416 E.56948
G1 X174.699 Y151.416 E.06355
; COOLING_NODE: 0
M204 S10000
G1 X175.166 Y151.009 F60000
G1 F2343
M204 S8000
G1 X175.166 Y168.991 E.59649
G1 X172.376 Y168.991 E.09255
G1 X172.376 Y151.009 E.59649
G1 X175.106 Y151.009 E.09056
; COOLING_NODE: 0
M204 S10000
G1 X175.573 Y150.602 F60000
G1 F2343
M204 S8000
G1 X175.573 Y169.398 E.62349
G1 X171.969 Y169.398 E.11956
G1 X171.969 Y150.602 E.62349
G1 X175.513 Y150.602 E.11757
; COOLING_NODE: 0
M204 S250
G1 X175.965 Y150.21 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2247
M204 S5000
G1 X175.965 Y169.79 E.60164
G1 X171.577 Y169.79 E.13484
G1 X171.577 Y150.21 E.60164
G1 X175.905 Y150.21 E.133
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
G1 F2343
M204 S8000
G1 X173.131 Y151.84 E.04937
G2 X173.53 Y151.764 I.147 J-.315 E.01437
G1 X174.411 Y151.764 E.02921
G1 X174.411 Y152.476 E.02359
G2 X173.69 Y152.605 I-.263 J.606 E.02575
G1 X173.131 Y153.532 E.0359
G1 X173.131 Y155.16 E.05401
M204 S10000
G1 X174.411 Y154.169 F60000
G1 F2343
M204 S8000
G1 X174.411 Y155.797 E.05401
G1 X174.227 Y155.982 E.00864
G1 X173.69 Y156.913 E.03565
G3 X173.131 Y157.081 I-.397 J-.304 E.02067
G1 X173.131 Y158.773 E.05612
G1 X173.69 Y157.846 E.0359
G3 X174.411 Y157.717 I.458 J.476 E.02575
G1 X174.411 Y161.038 E.11018
G1 X174.227 Y161.223 E.00864
G1 X173.69 Y162.154 E.03565
G3 X173.131 Y162.323 I-.397 J-.304 E.02067
G1 X173.131 Y164.015 E.05612
G1 X173.69 Y163.088 E.0359
G3 X174.411 Y162.958 I.458 J.476 E.02575
G1 X174.411 Y166.28 E.11018
G1 X174.227 Y166.464 E.00864
G1 X173.69 Y167.395 E.03565
G3 X173.131 Y167.564 I-.397 J-.304 E.02067
G1 X173.131 Y168.236 E.02227
G1 X173.827 Y168.236 E.02309
G3 X174.411 Y168.199 I.326 J.535 E.02017
G1 X174.411 Y166.571 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 15.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F8843.478
G1 X174.411 Y168.199 E-.61876
G1 X174.041 Y168.156 E-.14124
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
G3 Z15.4 I-.436 J1.136 P1  F60000
G1 X177.277 Y169.398 Z15.4
G1 Z15.2
G1 E.8 F1800
; FEATURE: Inner wall
M73 P81 R3
G1 F2357
M204 S8000
G1 X177.277 Y150.602 E.62349
G1 X178.073 Y150.602 E.0264
G1 X178.073 Y169.398 E.62349
G1 X177.337 Y169.398 E.02441
; COOLING_NODE: 0
M204 S250
G1 X176.885 Y169.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2234
M204 S5000
G1 X176.885 Y150.21 E.60164
G1 X178.465 Y150.21 E.04855
G1 X178.465 Y169.79 E.60164
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X176.945 Y169.79 E.04671
M204 S10000
G1 X177.675 Y169.194 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F2357
M204 S8000
G1 X177.675 Y150.806 E.5826
; COOLING_NODE: 0
; WIPE_START
G1 F9259.259
G1 X177.675 Y152.806 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X174.759 Y151.416 Z15.6 F60000
G1 Z15.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2357
M204 S8000
G1 X174.759 Y168.584 E.56948
G1 X172.784 Y168.584 E.0655
G1 X172.784 Y151.416 E.56948
G1 X174.699 Y151.416 E.06351
; COOLING_NODE: 0
M204 S10000
G1 X175.166 Y151.009 F60000
G1 F2357
M204 S8000
G1 X175.166 Y168.991 E.59649
G1 X172.377 Y168.991 E.09251
G1 X172.377 Y151.009 E.59649
G1 X175.106 Y151.009 E.09052
; COOLING_NODE: 0
M204 S10000
G1 X175.573 Y150.602 F60000
G1 F2357
M204 S8000
G1 X175.573 Y169.398 E.62349
G1 X171.97 Y169.398 E.11951
G1 X171.97 Y150.602 E.62349
G1 X175.513 Y150.602 E.11752
; COOLING_NODE: 0
M204 S250
G1 X175.965 Y150.21 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2234
M204 S5000
G1 X175.965 Y169.79 E.60164
G1 X171.578 Y169.79 E.1348
G1 X171.578 Y150.21 E.60164
G1 X175.905 Y150.21 E.13296
; WIPE_START
G1 F9547.055
M204 S8000
G1 X175.911 Y152.21 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X174.352 Y159.681 Z15.6 F60000
G1 X173.132 Y165.524 Z15.6
G1 Z15.2
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F2357
M204 S8000
G1 X173.132 Y163.895 E.05401
G2 X173.291 Y162.948 I-1.285 J-.703 E.03245
G1 X173.132 Y162.726 E.00907
G1 X173.132 Y158.654 E.13507
G2 X173.291 Y157.707 I-1.285 J-.703 E.03245
G1 X173.132 Y157.485 E.00907
G1 X173.132 Y153.413 E.13507
G2 X173.291 Y152.466 I-1.285 J-.703 E.03245
G1 X173.132 Y152.243 E.00907
G1 X173.132 Y151.764 E.01588
G1 X174.085 Y151.764 E.03161
G1 X174.088 Y151.811 E.00153
G3 X174.411 Y152.269 I-8.223 J6.125 E.0186
G1 X174.411 Y155.858 E.11903
G1 X174.257 Y156.069 E.00867
G2 X174.088 Y157.052 I1.331 J.735 E.0337
G3 X174.411 Y157.511 I-8.223 J6.125 E.0186
G1 X174.411 Y161.099 E.11903
G1 X174.257 Y161.31 E.00867
G2 X174.088 Y162.293 I1.331 J.735 E.0337
G3 X174.411 Y162.752 I-8.228 J6.128 E.0186
G1 X174.411 Y166.34 E.11903
G1 X174.257 Y166.552 E.00867
G2 X174.088 Y167.535 I1.331 J.735 E.0337
G3 X174.411 Y168.236 I-.523 J.665 E.02658
G1 X173.132 Y168.236 E.0424
G1 X173.132 Y168.128 E.00358
; CHANGE_LAYER
; Z_HEIGHT: 15.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F8843.478
G1 X173.132 Y168.236 E-.04101
G1 X174.411 Y168.236 E-.48567
G1 X174.411 Y167.993 E-.09208
G1 X174.197 Y167.689 E-.14124
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
G3 Z15.6 I-.59 J1.064 P1  F60000
G1 X177.277 Y169.398 Z15.6
G1 Z15.4
G1 E.8 F1800
; FEATURE: Inner wall
G1 F2214
M204 S8000
G1 X177.277 Y150.602 E.62349
G1 X178.073 Y150.602 E.0264
G1 X178.073 Y169.398 E.62349
G1 X177.337 Y169.398 E.02441
; COOLING_NODE: 0
M204 S250
G1 X176.885 Y169.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2214
M204 S5000
G1 X176.885 Y150.21 E.60164
G1 X178.465 Y150.21 E.04855
G1 X178.465 Y169.79 E.60164
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X176.945 Y169.79 E.04671
M204 S10000
G1 X177.675 Y169.194 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F2214
M204 S8000
G1 X177.675 Y150.806 E.5826
; COOLING_NODE: 0
; WIPE_START
G1 F9259.259
G1 X177.675 Y152.806 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X174.759 Y151.416 Z15.8 F60000
G1 Z15.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2214
M204 S8000
G1 X174.759 Y168.584 E.56948
G1 X172.785 Y168.584 E.06546
G1 X172.785 Y151.416 E.56948
G1 X174.699 Y151.416 E.06347
; COOLING_NODE: 0
M204 S10000
M73 P82 R3
G1 X175.166 Y151.009 F60000
G1 F2214
M204 S8000
G1 X175.166 Y168.991 E.59649
G1 X172.378 Y168.991 E.09247
G1 X172.378 Y151.009 E.59649
G1 X175.106 Y151.009 E.09048
; COOLING_NODE: 0
M204 S10000
G1 X175.573 Y150.602 F60000
G1 F2214
M204 S8000
G1 X175.573 Y169.398 E.62349
G1 X171.971 Y169.398 E.11947
G1 X171.971 Y150.602 E.62349
G1 X175.513 Y150.602 E.11748
; COOLING_NODE: 0
M204 S250
G1 X175.965 Y150.21 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2214
M204 S5000
G1 X175.965 Y169.79 E.60164
G1 X171.579 Y169.79 E.13476
G1 X171.579 Y150.21 E.60164
G1 X175.905 Y150.21 E.13292
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
G1 F2214
M204 S8000
G1 X174.411 Y155.879 E.05401
G1 X174.313 Y156.069 E.0071
G1 X174.262 Y156.724 E.0218
G2 X174.411 Y157.094 I.561 J-.01 E.01351
G1 X174.411 Y161.12 E.13355
G1 X174.313 Y161.31 E.0071
G1 X174.262 Y161.966 E.0218
G2 X174.411 Y162.335 I.561 J-.01 E.01351
G1 X174.411 Y166.361 E.13355
G1 X174.313 Y166.552 E.0071
G1 X174.262 Y167.207 E.0218
G3 X174.411 Y168.236 I-1.415 J.729 E.03512
G1 X173.441 Y168.236 E.03216
; CHANGE_LAYER
; Z_HEIGHT: 15.6
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F8843.478
G1 X174.411 Y168.236 E-.36838
G1 X174.411 Y167.577 E-.25038
G1 X174.272 Y167.232 E-.14124
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
G3 Z15.8 I-.712 J.987 P1  F60000
G1 X177.277 Y169.398 Z15.8
G1 Z15.6
G1 E.8 F1800
; FEATURE: Inner wall
G1 F2210
M204 S8000
G1 X177.277 Y150.602 E.62349
G1 X178.073 Y150.602 E.0264
G1 X178.073 Y169.398 E.62349
G1 X177.337 Y169.398 E.02441
; COOLING_NODE: 0
M204 S250
G1 X176.885 Y169.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2195
M204 S5000
G1 X176.885 Y150.21 E.60164
G1 X178.465 Y150.21 E.04855
G1 X178.465 Y169.79 E.60164
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X176.945 Y169.79 E.04671
M204 S10000
G1 X177.675 Y169.194 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F2210
M204 S8000
G1 X177.675 Y150.806 E.5826
; COOLING_NODE: 0
; WIPE_START
G1 F9259.259
G1 X177.675 Y152.806 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X174.759 Y151.416 Z16 F60000
G1 Z15.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2210
M204 S8000
G1 X174.759 Y168.584 E.56948
G1 X172.787 Y168.584 E.06542
G1 X172.787 Y151.416 E.56948
G1 X174.699 Y151.416 E.06343
; COOLING_NODE: 0
M204 S10000
G1 X175.166 Y151.009 F60000
G1 F2210
M204 S8000
G1 X175.166 Y168.991 E.59649
G1 X172.38 Y168.991 E.09243
G1 X172.38 Y151.009 E.59649
G1 X175.106 Y151.009 E.09044
; COOLING_NODE: 0
M204 S10000
G1 X175.573 Y150.602 F60000
G1 F2210
M204 S8000
G1 X175.573 Y169.398 E.62349
G1 X171.973 Y169.398 E.11943
G1 X171.973 Y150.602 E.62349
G1 X175.513 Y150.602 E.11744
; COOLING_NODE: 0
M204 S250
G1 X175.965 Y150.21 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2195
M204 S5000
G1 X175.965 Y169.79 E.60164
G1 X171.58 Y169.79 E.13473
G1 X171.58 Y150.21 E.60164
G1 X175.905 Y150.21 E.13288
; WIPE_START
M73 P83 R3
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
G1 F2210
M204 S8000
G1 X174.411 Y155.854 E.05401
G1 X174.34 Y156.069 E.00751
G1 X174.411 Y156.725 E.02187
G1 X174.411 Y161.095 E.14498
G1 X174.34 Y161.31 E.00751
G1 X174.411 Y161.966 E.02187
G1 X174.411 Y166.337 E.14498
G1 X174.34 Y166.552 E.00751
G1 X174.411 Y167.207 E.02187
G1 X174.411 Y168.236 E.03411
G1 X173.811 Y168.236 E.0199
; CHANGE_LAYER
; Z_HEIGHT: 15.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F8843.478
G1 X174.411 Y168.236 E-.228
G1 X174.411 Y167.207 E-.39076
G1 X174.371 Y166.838 E-.14124
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
G3 Z16 I-.804 J.913 P1  F60000
G1 X177.277 Y169.398 Z16
G1 Z15.8
G1 E.8 F1800
; FEATURE: Inner wall
G1 F2209
M204 S8000
G1 X177.277 Y150.602 E.62349
G1 X178.073 Y150.602 E.0264
G1 X178.073 Y169.398 E.62349
G1 X177.337 Y169.398 E.02441
; COOLING_NODE: 0
M204 S250
G1 X176.885 Y169.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2158
M204 S5000
G1 X176.885 Y150.21 E.60164
G1 X178.465 Y150.21 E.04855
G1 X178.465 Y169.79 E.60164
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X176.945 Y169.79 E.04671
M204 S10000
G1 X177.675 Y169.194 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F2209
M204 S8000
G1 X177.675 Y150.806 E.5826
; COOLING_NODE: 0
; WIPE_START
G1 F9259.259
G1 X177.675 Y152.806 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X174.759 Y151.416 Z16.2 F60000
G1 Z15.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2209
M204 S8000
G1 X174.759 Y168.584 E.56948
G1 X172.788 Y168.584 E.06538
G1 X172.788 Y151.416 E.56948
G1 X174.699 Y151.416 E.06339
; COOLING_NODE: 0
M204 S10000
G1 X175.166 Y151.009 F60000
G1 F2209
M204 S8000
G1 X175.166 Y168.991 E.59649
G1 X172.381 Y168.991 E.09239
G1 X172.381 Y151.009 E.59649
G1 X175.106 Y151.009 E.0904
; COOLING_NODE: 0
M204 S10000
G1 X175.573 Y150.602 F60000
G1 F2209
M204 S8000
G1 X175.573 Y169.398 E.62349
G1 X171.974 Y169.398 E.11939
G1 X171.974 Y150.602 E.62349
G1 X175.513 Y150.602 E.1174
; COOLING_NODE: 0
M204 S250
G1 X175.965 Y150.21 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2158
M204 S5000
G1 X175.965 Y169.79 E.60164
G1 X171.582 Y169.79 E.13469
G1 X171.582 Y150.21 E.60164
G1 X175.905 Y150.21 E.13284
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
G1 F2209
M204 S8000
G1 X174.411 Y155.618 E.05401
G2 X174.411 Y156.307 I.762 J.344 E.02355
G1 X174.411 Y160.859 E.15102
G2 X174.411 Y161.548 I.762 J.344 E.02355
G1 X174.411 Y166.101 E.15102
G2 X174.411 Y166.789 I.762 J.344 E.02355
G1 X174.411 Y168.236 E.04798
G1 X174.228 Y168.236 E.00604
; CHANGE_LAYER
; Z_HEIGHT: 16
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F8843.478
G1 X174.411 Y168.236 E-.06918
G1 X174.411 Y166.789 E-.54958
G1 X174.343 Y166.552 E-.09382
G1 X174.362 Y166.428 E-.04742
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
G3 Z16.2 I-.868 J.853 P1  F60000
G1 X177.277 Y169.398 Z16.2
G1 Z16
G1 E.8 F1800
; FEATURE: Inner wall
G1 F2212
M204 S8000
G1 X177.277 Y150.602 E.62349
G1 X178.073 Y150.602 E.0264
G1 X178.073 Y169.398 E.62349
G1 X177.337 Y169.398 E.02441
; COOLING_NODE: 0
M204 S250
G1 X176.885 Y169.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2096
M204 S5000
G1 X176.885 Y150.21 E.60164
G1 X178.465 Y150.21 E.04855
G1 X178.465 Y169.79 E.60164
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X176.945 Y169.79 E.04671
M204 S10000
M73 P84 R3
G1 X177.675 Y169.194 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F2212
M204 S8000
G1 X177.675 Y150.806 E.5826
; COOLING_NODE: 0
; WIPE_START
G1 F9259.259
G1 X177.675 Y152.806 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X174.759 Y151.416 Z16.4 F60000
G1 Z16
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2212
M204 S8000
G1 X174.759 Y168.584 E.56948
G1 X172.789 Y168.584 E.06534
G1 X172.789 Y151.416 E.56948
G1 X174.699 Y151.416 E.06335
; COOLING_NODE: 0
M204 S10000
G1 X175.166 Y151.009 F60000
G1 F2212
M204 S8000
G1 X175.166 Y168.991 E.59649
G1 X172.382 Y168.991 E.09234
G1 X172.382 Y151.009 E.59649
G1 X175.106 Y151.009 E.09035
; COOLING_NODE: 0
M204 S10000
G1 X175.573 Y150.602 F60000
G1 F2212
M204 S8000
G1 X175.573 Y169.398 E.62349
G1 X171.975 Y169.398 E.11935
G1 X171.975 Y150.602 E.62349
G1 X175.513 Y150.602 E.11736
; COOLING_NODE: 0
M204 S250
G1 X175.965 Y150.21 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2096
M204 S5000
G1 X175.965 Y169.79 E.60164
G1 X171.583 Y169.79 E.13465
G1 X171.583 Y150.21 E.60164
G1 X175.905 Y150.21 E.13281
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
G1 F2212
M204 S8000
G1 X174.411 Y155.136 E.05401
G1 X174.301 Y155.414 E.0099
G1 X174.322 Y156.069 E.02174
G1 X174.411 Y156.259 E.00696
G1 X174.411 Y160.378 E.13661
G1 X174.301 Y160.655 E.0099
G1 X174.322 Y161.31 E.02174
G1 X174.411 Y161.501 E.00696
G1 X174.411 Y165.619 E.13661
G1 X174.301 Y165.897 E.0099
G1 X174.322 Y166.552 E.02174
G1 X174.411 Y166.742 E.00696
G1 X174.411 Y168.236 E.04954
G1 X174.276 Y168.236 E.00447
; CHANGE_LAYER
; Z_HEIGHT: 16.2
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F8843.478
G1 X174.411 Y168.236 E-.0512
G1 X174.411 Y166.742 E-.56756
G1 X174.322 Y166.552 E-.07979
G1 X174.317 Y166.39 E-.06146
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
G3 Z16.4 I-.867 J.854 P1  F60000
G1 X177.277 Y169.398 Z16.4
G1 Z16.2
G1 E.8 F1800
; FEATURE: Inner wall
G1 F2352
M204 S8000
G1 X177.277 Y150.602 E.62349
G1 X178.073 Y150.602 E.0264
G1 X178.073 Y169.398 E.62349
G1 X177.337 Y169.398 E.02441
; COOLING_NODE: 0
M204 S250
G1 X176.885 Y169.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2006
M204 S5000
G1 X176.885 Y150.21 E.60164
G1 X178.465 Y150.21 E.04855
G1 X178.465 Y169.79 E.60164
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X176.945 Y169.79 E.04671
M204 S10000
G1 X177.675 Y169.194 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F2352
M204 S8000
G1 X177.675 Y150.806 E.5826
; COOLING_NODE: 0
; WIPE_START
G1 F9259.259
G1 X177.675 Y152.806 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X174.759 Y151.416 Z16.6 F60000
G1 Z16.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2352
M204 S8000
G1 X174.759 Y168.584 E.56948
G1 X172.79 Y168.584 E.0653
G1 X172.79 Y151.416 E.56948
G1 X174.699 Y151.416 E.06331
; COOLING_NODE: 0
M204 S10000
G1 X175.166 Y151.009 F60000
G1 F2352
M204 S8000
G1 X175.166 Y168.991 E.59649
G1 X172.383 Y168.991 E.0923
G1 X172.383 Y151.009 E.59649
G1 X175.106 Y151.009 E.09031
; COOLING_NODE: 0
M204 S10000
G1 X175.573 Y150.602 F60000
G1 F2352
M204 S8000
M73 P85 R3
G1 X175.573 Y169.398 E.62349
G1 X171.976 Y169.398 E.11931
G1 X171.976 Y150.602 E.62349
G1 X175.513 Y150.602 E.11732
; COOLING_NODE: 0
M204 S250
M73 P85 R2
G1 X175.965 Y150.21 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2006
M204 S5000
G1 X175.965 Y169.79 E.60164
G1 X171.584 Y169.79 E.13461
G1 X171.584 Y150.21 E.60164
G1 X175.905 Y150.21 E.13277
; WIPE_START
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
G1 F2352
M204 S8000
G1 X173.139 Y153.588 E.05401
G3 X173.139 Y154.526 I-.866 J.469 E.03244
G1 X173.139 Y158.829 E.14274
G3 X173.139 Y159.768 I-.866 J.469 E.03244
G1 X173.139 Y164.071 E.14274
G3 X173.139 Y165.009 I-.866 J.469 E.03244
G1 X173.139 Y168.236 E.10704
G1 X174.411 Y168.236 E.04219
G1 X174.411 Y166.756 E.04907
G1 X174.273 Y166.552 E.00817
G1 X174.121 Y165.897 E.02231
G3 X174.411 Y165.252 I.722 J-.063 E.02449
G1 X174.411 Y161.515 E.12397
G1 X174.273 Y161.31 E.00817
G1 X174.121 Y160.655 E.02231
G3 X174.411 Y160.011 I.722 J-.063 E.02449
G1 X174.411 Y156.274 E.12397
G1 X174.273 Y156.069 E.00817
G1 X174.121 Y155.414 E.02231
G3 X174.411 Y154.769 I.722 J-.063 E.02449
G1 X174.411 Y153.141 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 16.4
; LAYER_HEIGHT: 0.199999
; WIPE_START
G1 F8843.478
G1 X174.411 Y154.769 E-.61876
G1 X174.185 Y155.065 E-.14124
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
G3 Z16.6 I-1.19 J.257 P1  F60000
G1 X177.277 Y169.398 Z16.6
G1 Z16.4
G1 E.8 F1800
; FEATURE: Inner wall
G1 F2307
M204 S8000
G1 X177.277 Y150.602 E.62349
G1 X178.073 Y150.602 E.0264
G1 X178.073 Y169.398 E.62349
G1 X177.337 Y169.398 E.02441
; COOLING_NODE: 0
M204 S250
G1 X176.885 Y169.79 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1891
M204 S5000
G1 X176.885 Y150.21 E.60164
G1 X178.465 Y150.21 E.04855
G1 X178.465 Y169.79 E.60164
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X176.945 Y169.79 E.04671
M204 S10000
G1 X177.675 Y169.194 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F2307
M204 S8000
G1 X177.675 Y150.806 E.5826
; COOLING_NODE: 0
; WIPE_START
G1 F9259.259
G1 X177.675 Y152.806 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X174.759 Y151.416 Z16.8 F60000
G1 Z16.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2307
M204 S8000
G1 X174.759 Y168.584 E.56948
G1 X172.792 Y168.584 E.06526
G1 X172.792 Y151.416 E.56948
G1 X174.699 Y151.416 E.06327
; COOLING_NODE: 0
M204 S10000
G1 X175.166 Y151.009 F60000
G1 F2307
M204 S8000
G1 X175.166 Y168.991 E.59649
G1 X172.385 Y168.991 E.09226
G1 X172.385 Y151.009 E.59649
G1 X175.106 Y151.009 E.09027
; COOLING_NODE: 0
M204 S10000
G1 X175.573 Y150.602 F60000
G1 F2307
M204 S8000
G1 X175.573 Y169.398 E.62349
G1 X171.977 Y169.398 E.11927
G1 X171.977 Y150.602 E.62349
G1 X175.513 Y150.602 E.11728
; COOLING_NODE: 0
M204 S250
G1 X175.965 Y150.21 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1891
M204 S5000
G1 X175.965 Y169.79 E.60164
G1 X171.585 Y169.79 E.13457
G1 X171.585 Y150.21 E.60164
G1 X175.905 Y150.21 E.13273
; WIPE_START
G1 F9547.055
M204 S8000
G1 X175.911 Y152.21 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
M73 P86 R2
G1 X174.411 Y152.853 Z16.8 F60000
G1 Z16.4
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F2307
M204 S8000
G1 X174.411 Y154.481 E.05401
G3 X173.69 Y154.497 I-.375 J-.68 E.02487
G2 X173.14 Y153.403 I-5.992 J2.328 E.04066
G1 X173.14 Y154.978 E.05225
G3 X173.69 Y155.021 I.24 J.475 E.01923
G1 X174.227 Y156.124 E.0407
G1 X174.411 Y156.323 E.00899
G1 X174.411 Y159.723 E.11276
G3 X173.69 Y159.738 I-.375 J-.68 E.02487
G2 X173.14 Y158.645 I-5.992 J2.328 E.04066
G1 X173.14 Y160.22 E.05225
G3 X173.69 Y160.262 I.24 J.475 E.01923
G1 X174.227 Y161.365 E.0407
G1 X174.411 Y161.565 E.00899
G1 X174.411 Y164.964 E.11276
G3 X173.69 Y164.979 I-.375 J-.68 E.02487
G2 X173.14 Y163.886 I-5.992 J2.328 E.04066
G1 X173.14 Y165.461 E.05225
G3 X173.69 Y165.504 I.24 J.475 E.01923
G1 X174.227 Y166.607 E.0407
G1 X174.411 Y166.806 E.00899
G1 X174.411 Y168.236 E.04742
G1 X174.212 Y168.236 E.00659
; CHANGE_LAYER
; Z_HEIGHT: 16.6
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F8843.478
G1 X174.411 Y168.236 E-.07548
G1 X174.411 Y166.806 E-.54327
G1 X174.227 Y166.607 E-.10296
G1 X174.183 Y166.516 E-.03828
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 83/100
; update layer progress
M73 L83
M991 S0 P82 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z16.8 I-.939 J.775 P1  F60000
G1 X176.885 Y169.79 Z16.8
G1 Z16.6
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1768
M204 S5000
G1 X176.885 Y150.21 E.60164
G1 X178.465 Y150.21 E.04855
G1 X178.465 Y169.79 E.60164
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X176.945 Y169.79 E.04671
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
G1 F2597
M204 S2000
G1 X177.416 Y150.417 E.03659
G1 X177.282 Y150.284
G1 X176.959 Y150.494
G1 X177.092 Y150.627
G1 X178.258 Y151.793 E.05063
G1 X178.391 Y151.926
G1 X178.391 Y152.46
G1 X178.258 Y152.326
G1 X177.092 Y151.161 E.05063
G1 X176.959 Y151.027
G1 X176.959 Y151.56
G1 X177.092 Y151.694
G1 X178.258 Y152.859 E.05063
G1 X178.391 Y152.993
G1 X178.391 Y153.526
G1 X178.258 Y153.392
G1 X177.092 Y152.227 E.05063
G1 X176.959 Y152.094
G1 X176.959 Y152.627
G1 X177.092 Y152.76
G1 X178.258 Y153.926 E.05063
G1 X178.391 Y154.059
G1 X178.391 Y154.593
G1 X178.258 Y154.459
G1 X177.092 Y153.294 E.05063
G1 X176.959 Y153.16
G1 X176.959 Y153.693
G1 X177.092 Y153.827
G1 X178.258 Y154.992 E.05063
G1 X178.391 Y155.126
G1 X178.391 Y155.659
G1 X178.258 Y155.525
G1 X177.092 Y154.36 E.05063
G1 X176.959 Y154.227
G1 X176.959 Y154.76
G1 X177.092 Y154.893
G1 X178.258 Y156.059 E.05063
G1 X178.391 Y156.192
G1 X178.391 Y156.726
G1 X178.258 Y156.592
G1 X177.092 Y155.427 E.05063
G1 X176.959 Y155.293
G1 X176.959 Y155.826
G1 X177.092 Y155.96
G1 X178.258 Y157.125 E.05063
G1 X178.391 Y157.259
G1 X178.391 Y157.792
G1 X178.258 Y157.658
G1 X177.092 Y156.493 E.05063
G1 X176.959 Y156.36
G1 X176.959 Y156.893
G1 X177.092 Y157.027
G1 X178.258 Y158.192 E.05063
G1 X178.391 Y158.325
G1 X178.391 Y158.859
G1 X178.258 Y158.725
G1 X177.092 Y157.56 E.05063
G1 X176.959 Y157.426
G1 X176.959 Y157.959
G1 X177.092 Y158.093
G1 X178.258 Y159.258 E.05063
G1 X178.391 Y159.392
G1 X178.391 Y159.925
G1 X178.258 Y159.792
G1 X177.092 Y158.626 E.05063
G1 X176.959 Y158.493
G1 X176.959 Y159.026
G1 X177.092 Y159.16
G1 X178.258 Y160.325 E.05063
G1 X178.391 Y160.458
G1 X178.391 Y160.992
G1 X178.258 Y160.858
G1 X177.092 Y159.693 E.05063
G1 X176.959 Y159.559
G1 X176.959 Y160.092
G1 X177.092 Y160.226
G1 X178.258 Y161.391 E.05063
G1 X178.391 Y161.525
G1 X178.391 Y162.058
G1 X178.258 Y161.925
G1 X177.092 Y160.759 E.05063
G1 X176.959 Y160.626
G1 X176.959 Y161.159
G1 X177.092 Y161.293
G1 X178.258 Y162.458 E.05063
G1 X178.391 Y162.591
G1 X178.391 Y163.125
G1 X178.258 Y162.991
G1 X177.092 Y161.826 E.05063
G1 X176.959 Y161.692
G1 X176.959 Y162.225
G1 X177.092 Y162.359
G1 X178.258 Y163.524 E.05063
G1 X178.391 Y163.658
G1 X178.391 Y164.191
G1 X178.258 Y164.058
G1 X177.092 Y162.892 E.05063
G1 X176.959 Y162.759
G1 X176.959 Y163.292
G1 X177.092 Y163.426
G1 X178.258 Y164.591 E.05063
G1 X178.391 Y164.724
G1 X178.391 Y165.258
G1 X178.258 Y165.124
G1 X177.092 Y163.959 E.05063
G1 X176.959 Y163.825
G1 X176.959 Y164.358
G1 X177.092 Y164.492
G1 X178.258 Y165.657 E.05063
G1 X178.391 Y165.791
G1 X178.391 Y166.324
G1 X178.258 Y166.191
G1 X177.092 Y165.025 E.05063
G1 X176.959 Y164.892
G1 X176.959 Y165.425
G1 X177.092 Y165.559
G1 X178.258 Y166.724 E.05063
G1 X178.391 Y166.858
G1 X178.391 Y167.391
G1 X178.258 Y167.257
G1 X177.092 Y166.092 E.05063
G1 X176.959 Y165.958
G1 X176.959 Y166.492
G1 X177.092 Y166.625
G1 X178.258 Y167.79 E.05063
G1 X178.391 Y167.924
G1 X178.391 Y168.457
G1 X178.258 Y168.324
G1 X177.092 Y167.158 E.05063
G1 X176.959 Y167.025
G1 X176.959 Y167.558
G1 X177.092 Y167.692
G1 X178.258 Y168.857 E.05063
G1 X178.391 Y168.991
G1 X178.391 Y169.524
G1 X178.258 Y169.39
G1 X177.092 Y168.225 E.05063
G1 X176.959 Y168.091
G1 X176.959 Y168.625
G1 X177.092 Y168.758
G1 X177.917 Y169.583 E.03583
; COOLING_NODE: 0
; WIPE_START
G1 F9547.055
M204 S8000
G1 X177.092 Y168.758 E-.44306
G1 X176.959 Y168.625 E-.07182
G1 X176.959 Y168.091 E-.20264
G1 X177.038 Y168.17 E-.04248
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X176.009 Y160.608 Z17 F60000
G1 X174.759 Y151.416 Z17
G1 Z16.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2597
M204 S8000
G1 X174.759 Y168.584 E.56948
G1 X172.793 Y168.584 E.06522
G1 X172.793 Y151.416 E.56948
G1 X174.699 Y151.416 E.06323
; COOLING_NODE: 0
M204 S10000
G1 X175.166 Y151.009 F60000
G1 F2597
M204 S8000
G1 X175.166 Y168.991 E.59649
G1 X172.386 Y168.991 E.09222
G1 X172.386 Y151.009 E.59649
G1 X175.106 Y151.009 E.09023
; COOLING_NODE: 0
M204 S10000
G1 X175.573 Y150.602 F60000
G1 F2597
M204 S8000
G1 X175.573 Y169.398 E.62349
G1 X171.979 Y169.398 E.11923
G1 X171.979 Y150.602 E.62349
G1 X175.513 Y150.602 E.11724
; COOLING_NODE: 0
M204 S250
G1 X175.965 Y150.21 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1768
M204 S5000
G1 X175.965 Y169.79 E.60164
G1 X171.587 Y169.79 E.13454
G1 X171.587 Y150.21 E.60164
G1 X175.905 Y150.21 E.13269
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
G1 F2597
M204 S8000
G1 X174.411 Y154.262 E.05401
G1 X174.227 Y154.276 E.00611
G1 X173.69 Y153.958 E.02071
G1 X173.141 Y153.277 E.02901
G1 X173.141 Y155.254 E.0656
G3 X173.69 Y155.56 I-.031 J.702 E.0216
G1 X174.227 Y156.252 E.02905
G1 X174.411 Y156.397 E.00778
G1 X174.411 Y159.503 E.10305
G1 X174.227 Y159.517 E.00611
G1 X173.69 Y159.199 E.02071
G1 X173.141 Y158.518 E.02901
G1 X173.141 Y160.496 E.0656
G3 X173.69 Y160.801 I-.031 J.702 E.0216
G1 X174.227 Y161.493 E.02905
G1 X174.411 Y161.638 E.00778
G1 X174.411 Y164.745 E.10305
G1 X174.227 Y164.759 E.00611
G1 X173.69 Y164.44 E.02071
G1 X173.141 Y163.759 E.02901
G1 X173.141 Y165.737 E.0656
G3 X173.69 Y166.042 I-.031 J.702 E.0216
G1 X174.227 Y166.734 E.02905
G1 X174.411 Y166.88 E.00778
G1 X174.411 Y168.236 E.04498
G1 X174.138 Y168.236 E.00904
; CHANGE_LAYER
; Z_HEIGHT: 16.8
; LAYER_HEIGHT: 0.199999
; WIPE_START
G1 F8843.478
G1 X174.411 Y168.236 E-.10352
G1 X174.411 Y166.88 E-.51524
G1 X174.227 Y166.734 E-.08907
G1 X174.143 Y166.626 E-.05217
; WIPE_END
G1 E-.04 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 84/100
; update layer progress
M73 L84
M991 S0 P83 ;notify layer change

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z17 I1.216 J.049 P1  F60000
G1 X174.759 Y151.416 Z17
G1 Z16.8
G1 E.8 F1800
; FEATURE: Inner wall
G1 F1517
M204 S8000
G1 X174.759 Y168.584 E.56948
G1 X172.794 Y168.584 E.06518
G1 X172.794 Y151.416 E.56948
G1 X174.699 Y151.416 E.06318
; COOLING_NODE: 0
M204 S10000
M73 P87 R2
G1 X175.166 Y151.009 F60000
G1 F1517
M204 S8000
G1 X175.166 Y168.991 E.59649
G1 X172.387 Y168.991 E.09218
G1 X172.387 Y151.009 E.59649
G1 X175.106 Y151.009 E.09019
; COOLING_NODE: 0
M204 S10000
G1 X175.573 Y150.602 F60000
G1 F1517
M204 S8000
G1 X175.573 Y169.398 E.62349
G1 X171.98 Y169.398 E.11919
G1 X171.98 Y150.602 E.62349
G1 X175.513 Y150.602 E.1172
; COOLING_NODE: 0
M204 S250
G1 X175.965 Y150.21 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1517
M204 S5000
G1 X175.965 Y169.79 E.60164
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X171.588 Y169.79 E.1345
G1 X171.588 Y150.21 E.60164
G1 X175.905 Y150.21 E.13266
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
G1 F1517
M204 S8000
G1 X174.411 Y154.103 E.05401
G1 X174.227 Y154.079 E.00615
G3 X173.142 Y153.161 I2.553 J-4.118 E.04728
G1 X173.142 Y155.449 E.07588
G3 X174.227 Y156.371 I-1.483 J2.844 E.04761
G1 X174.411 Y156.475 E.00701
G1 X174.411 Y159.345 E.09518
G1 X174.227 Y159.32 E.00615
G3 X173.142 Y158.403 I2.553 J-4.118 E.04728
G1 X173.142 Y160.69 E.07588
G3 X174.227 Y161.612 I-1.483 J2.844 E.04761
G1 X174.411 Y161.717 E.00701
G1 X174.411 Y164.586 E.09518
G1 X174.227 Y164.561 E.00615
G3 X173.142 Y163.644 I2.552 J-4.118 E.04728
G1 X173.142 Y165.932 E.07588
G3 X174.227 Y166.853 I-1.483 J2.844 E.04761
G1 X174.411 Y166.958 E.00701
G1 X174.411 Y168.236 E.04238
G1 X174.06 Y168.236 E.01163
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
G1 F1519
M204 S8000
G1 X174.759 Y168.584 E.56948
G1 X172.795 Y168.584 E.06513
G1 X172.795 Y151.416 E.56948
G1 X174.699 Y151.416 E.06314
; COOLING_NODE: 0
M204 S10000
G1 X175.166 Y151.009 F60000
G1 F1519
M204 S8000
G1 X175.166 Y168.991 E.59649
G1 X172.388 Y168.991 E.09214
G1 X172.388 Y151.009 E.59649
G1 X175.106 Y151.009 E.09015
; COOLING_NODE: 0
M204 S10000
G1 X175.573 Y150.602 F60000
G1 F1519
M204 S8000
G1 X175.573 Y169.398 E.62349
G1 X171.981 Y169.398 E.11915
G1 X171.981 Y150.602 E.62349
G1 X175.513 Y150.602 E.11716
; COOLING_NODE: 0
M204 S250
G1 X175.965 Y150.21 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
M73 P88 R2
G1 F1519
M204 S5000
G1 X175.965 Y169.79 E.60164
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X171.589 Y169.79 E.13446
G1 X171.589 Y150.21 E.60164
G1 X175.905 Y150.21 E.13262
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
G1 F1519
M204 S8000
G1 X174.411 Y153.982 E.05401
G1 X174.227 Y153.923 E.0064
G2 X173.144 Y153.042 I-53.081 J64.169 E.04631
G1 X173.144 Y155.619 E.08546
G3 X174.227 Y156.497 I-6.855 J9.563 E.04629
G1 X174.411 Y156.567 E.00652
G1 X174.411 Y159.223 E.08811
G1 X174.227 Y159.165 E.0064
G2 X173.144 Y158.284 I-53.151 J64.255 E.04631
G1 X173.144 Y160.86 E.08546
G3 X174.227 Y161.738 I-6.854 J9.561 E.04629
G1 X174.411 Y161.808 E.00652
G1 X174.411 Y164.464 E.08811
G1 X174.227 Y164.406 E.0064
G2 X173.144 Y163.525 I-53.081 J64.169 E.04631
G1 X173.144 Y166.101 E.08546
G3 X174.227 Y166.98 I-6.855 J9.563 E.04629
G1 X174.411 Y167.049 E.00652
G1 X174.411 Y168.236 E.03935
G1 X173.968 Y168.236 E.01466
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
G1 F1521
M204 S8000
G1 X174.759 Y168.584 E.56948
G1 X172.797 Y168.584 E.06509
G1 X172.797 Y151.416 E.56948
G1 X174.699 Y151.416 E.0631
; COOLING_NODE: 0
M204 S10000
G1 X175.166 Y151.009 F60000
G1 F1521
M204 S8000
G1 X175.166 Y168.991 E.59649
G1 X172.389 Y168.991 E.0921
G1 X172.389 Y151.009 E.59649
G1 X175.106 Y151.009 E.09011
; COOLING_NODE: 0
M204 S10000
G1 X175.573 Y150.602 F60000
G1 F1521
M204 S8000
G1 X175.573 Y169.398 E.62349
G1 X171.982 Y169.398 E.11911
G1 X171.982 Y150.602 E.62349
G1 X175.513 Y150.602 E.11712
; COOLING_NODE: 0
M204 S250
G1 X175.965 Y150.21 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1521
M204 S5000
G1 X175.965 Y169.79 E.60164
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X171.59 Y169.79 E.13442
G1 X171.59 Y150.21 E.60164
G1 X175.905 Y150.21 E.13258
; WIPE_START
G1 F9547.055
M204 S8000
G1 X175.911 Y152.21 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X173.652 Y151.764 Z17.6 F60000
G1 Z17.2
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F1521
M204 S8000
G1 X173.145 Y151.764 E.01684
G1 X173.145 Y152.885 E.03718
G3 X174.227 Y153.792 I-2.097 J3.602 E.04705
G1 X174.411 Y153.884 E.00682
G1 X174.411 Y156.679 E.09271
G1 X174.227 Y156.642 E.00621
G3 X173.145 Y155.744 I4.365 J-6.36 E.04671
G1 X173.145 Y158.127 E.07902
G3 X174.227 Y159.033 I-2.097 J3.602 E.04705
G1 X174.411 Y159.125 E.00682
G1 X174.411 Y161.92 E.09271
G1 X174.227 Y161.884 E.00621
G3 X173.145 Y160.986 I4.366 J-6.361 E.04671
G1 X173.145 Y163.368 E.07902
G3 X174.227 Y164.274 I-2.097 J3.602 E.04705
G1 X174.411 Y164.367 E.00682
G1 X174.411 Y167.162 E.09271
M73 P89 R2
G1 X174.227 Y167.125 E.00621
G3 X173.145 Y166.227 I4.365 J-6.36 E.04671
G1 X173.145 Y167.855 E.05401
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
G1 F1524
M204 S8000
G1 X174.759 Y168.584 E.56948
G1 X172.798 Y168.584 E.06505
G1 X172.798 Y151.416 E.56948
G1 X174.699 Y151.416 E.06306
; COOLING_NODE: 0
M204 S10000
G1 X175.166 Y151.009 F60000
G1 F1524
M204 S8000
G1 X175.166 Y168.991 E.59649
G1 X172.391 Y168.991 E.09206
G1 X172.391 Y151.009 E.59649
G1 X175.106 Y151.009 E.09007
; COOLING_NODE: 0
M204 S10000
G1 X175.573 Y150.602 F60000
G1 F1524
M204 S8000
G1 X175.573 Y169.398 E.62349
G1 X171.984 Y169.398 E.11907
G1 X171.984 Y150.602 E.62349
G1 X175.513 Y150.602 E.11708
; COOLING_NODE: 0
M204 S250
G1 X175.965 Y150.21 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1514
M204 S5000
G1 X175.965 Y169.79 E.60164
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X171.592 Y169.79 E.13439
G1 X171.592 Y150.21 E.60164
G1 X175.905 Y150.21 E.13254
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
G1 F1524
M204 S8000
G1 X173.146 Y151.764 E.02271
G1 X173.146 Y152.708 E.0313
G3 X173.69 Y153.041 I-.125 J.814 E.02172
G1 X174.227 Y153.672 E.02747
G1 X174.411 Y153.802 E.00748
G1 X174.411 Y156.823 E.10021
G1 X174.227 Y156.823 E.0061
G3 X173.146 Y155.862 I1.174 J-2.41 E.04856
G1 X173.146 Y157.949 E.06923
G3 X173.69 Y158.283 I-.125 J.814 E.02172
G1 X174.227 Y158.913 E.02747
G1 X174.411 Y159.043 E.00748
G1 X174.411 Y162.064 E.10021
G1 X174.227 Y162.064 E.0061
G3 X173.146 Y161.104 I1.174 J-2.41 E.04856
G1 X173.146 Y163.191 E.06923
G3 X173.69 Y163.524 I-.125 J.814 E.02172
G1 X174.227 Y164.154 E.02747
G1 X174.411 Y164.285 E.00748
G1 X174.411 Y167.306 E.10021
G1 X174.227 Y167.305 E.0061
G3 X173.146 Y166.345 I1.174 J-2.41 E.04856
G1 X173.146 Y167.973 E.05401
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
G1 F1548
M204 S8000
G1 X174.759 Y168.584 E.56948
G1 X172.799 Y168.584 E.06501
G1 X172.799 Y151.416 E.56948
G1 X174.699 Y151.416 E.06302
; COOLING_NODE: 0
M204 S10000
G1 X175.166 Y151.009 F60000
G1 F1548
M204 S8000
G1 X175.166 Y168.991 E.59649
G1 X172.392 Y168.991 E.09202
G1 X172.392 Y151.009 E.59649
G1 X175.106 Y151.009 E.09003
; COOLING_NODE: 0
M204 S10000
G1 X175.573 Y150.602 F60000
G1 F1548
M204 S8000
G1 X175.573 Y169.398 E.62349
M73 P90 R2
G1 X171.985 Y169.398 E.11902
G1 X171.985 Y150.602 E.62349
G1 X175.513 Y150.602 E.11703
; COOLING_NODE: 0
M204 S250
M73 P90 R1
G1 X175.965 Y150.21 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1491
M204 S5000
G1 X175.965 Y169.79 E.60164
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X171.593 Y169.79 E.13435
G1 X171.593 Y150.21 E.60164
G1 X175.905 Y150.21 E.1325
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
G1 F1548
M204 S8000
G1 X174.411 Y151.777 E.05401
G3 X173.147 Y151.764 I-.556 J-7.86 E.04195
G1 X173.147 Y152.466 E.02326
G3 X173.69 Y152.667 I.127 J.489 E.02044
G1 X174.227 Y153.549 E.03427
G1 X174.411 Y153.728 E.0085
G1 X174.411 Y157.018 E.10913
G3 X173.69 Y156.851 I-.235 J-.624 E.02602
G1 X173.147 Y155.995 E.03361
G1 X173.147 Y157.707 E.05679
G3 X173.69 Y157.908 I.127 J.489 E.02044
G1 X174.227 Y158.791 E.03427
G1 X174.411 Y158.969 E.0085
G1 X174.411 Y162.259 E.10913
G3 X173.69 Y162.092 I-.235 J-.624 E.02602
G1 X173.147 Y161.236 E.03361
G1 X173.147 Y162.948 E.05679
G3 X173.69 Y163.15 I.127 J.489 E.02044
G1 X174.227 Y164.032 E.03427
G1 X174.411 Y164.211 E.0085
G1 X174.411 Y167.501 E.10913
G3 X173.69 Y167.333 I-.235 J-.624 E.02602
G1 X173.147 Y166.478 E.03361
G1 X173.147 Y168.106 E.05401
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
G1 F1590
M204 S8000
G1 X174.759 Y168.584 E.56948
G1 X172.8 Y168.584 E.06497
G1 X172.8 Y151.416 E.56948
G1 X174.699 Y151.416 E.06298
; COOLING_NODE: 0
M204 S10000
G1 X175.166 Y151.009 F60000
G1 F1590
M204 S8000
G1 X175.166 Y168.991 E.59649
G1 X172.393 Y168.991 E.09198
G1 X172.393 Y151.009 E.59649
G1 X175.106 Y151.009 E.08999
; COOLING_NODE: 0
M204 S10000
G1 X175.573 Y150.602 F60000
G1 F1590
M204 S8000
G1 X175.573 Y169.398 E.62349
G1 X171.986 Y169.398 E.11898
G1 X171.986 Y150.602 E.62349
G1 X175.513 Y150.602 E.11699
; COOLING_NODE: 0
M204 S250
G1 X175.965 Y150.21 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1473
M204 S5000
G1 X175.965 Y169.79 E.60164
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X171.594 Y169.79 E.13431
G1 X171.594 Y150.21 E.60164
G1 X175.905 Y150.21 E.13247
; WIPE_START
G1 F9547.055
M204 S8000
G1 X175.911 Y152.21 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
M73 P91 R1
G1 X173.148 Y153.704 Z18.2 F60000
G1 Z17.8
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F1590
M204 S8000
G1 X173.148 Y152.075 E.05401
G1 X173.33 Y151.764 E.01194
G1 X174.411 Y151.764 E.03585
G3 X174.05 Y152.466 I-1.08 J-.112 E.02677
G2 X174.411 Y153.663 I2.102 J.02 E.04212
G1 X174.411 Y157.197 E.11721
G2 X174.05 Y157.707 I5.791 J4.473 E.02073
G2 X174.411 Y158.905 I2.102 J.02 E.04212
G1 X174.411 Y162.438 E.11721
G2 X174.05 Y162.948 I5.791 J4.473 E.02073
G2 X174.411 Y164.146 I2.102 J.02 E.04212
G1 X174.411 Y167.679 E.11721
G2 X174.05 Y168.236 I1.945 J1.657 E.02206
G1 X173.148 Y168.236 E.02989
G3 X173.329 Y167.535 I.603 J-.218 E.02552
G2 X173.148 Y166.612 I-1.523 J-.18 E.03169
G1 X173.148 Y162.558 E.13448
G2 X173.333 Y161.966 I-.352 J-.434 E.02182
G1 X173.148 Y161.371 E.02066
G1 X173.148 Y157.317 E.13448
G2 X173.333 Y156.724 I-.352 J-.434 E.02182
G1 X173.148 Y156.13 E.02066
G1 X173.148 Y154.501 E.05401
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
G1 F1436
M204 S8000
G1 X174.759 Y168.584 E.56948
G1 X172.801 Y168.584 E.06493
G1 X172.801 Y151.416 E.56948
G1 X174.699 Y151.416 E.06294
; COOLING_NODE: 0
M204 S10000
G1 X175.166 Y151.009 F60000
G1 F1436
M204 S8000
G1 X175.166 Y168.991 E.59649
G1 X172.394 Y168.991 E.09194
G1 X172.394 Y151.009 E.59649
G1 X175.106 Y151.009 E.08995
; COOLING_NODE: 0
M204 S10000
G1 X175.573 Y150.602 F60000
G1 F1436
M204 S8000
G1 X175.573 Y169.398 E.62349
G1 X171.987 Y169.398 E.11894
G1 X171.987 Y150.602 E.62349
G1 X175.513 Y150.602 E.11695
; COOLING_NODE: 0
M204 S250
G1 X175.965 Y150.21 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1436
M204 S5000
G1 X175.965 Y169.79 E.60164
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X171.595 Y169.79 E.13427
G1 X171.595 Y150.21 E.60164
G1 X175.905 Y150.21 E.13243
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
G1 F1436
M204 S8000
G1 X174.411 Y151.764 E.03316
G1 X174.411 Y152.393 E.02086
G2 X174.245 Y152.793 I.419 J.408 E.01472
G1 X174.308 Y153.448 E.02183
G1 X174.411 Y153.64 E.0072
G1 X174.411 Y157.635 E.13251
G2 X174.245 Y158.035 I.419 J.408 E.01472
G1 X174.308 Y158.69 E.02183
G1 X174.411 Y158.881 E.0072
G1 X174.411 Y162.876 E.13251
G2 X174.245 Y163.276 I.419 J.408 E.01472
G1 X174.308 Y163.931 E.02183
G1 X174.411 Y164.122 E.0072
G1 X174.411 Y165.751 E.05401
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
G1 F1433
M204 S8000
G1 X174.759 Y168.584 E.56948
G1 X172.803 Y168.584 E.06489
G1 X172.803 Y151.416 E.56948
G1 X174.699 Y151.416 E.0629
; COOLING_NODE: 0
M204 S10000
G1 X175.166 Y151.009 F60000
G1 F1433
M204 S8000
G1 X175.166 Y168.991 E.59649
G1 X172.396 Y168.991 E.0919
G1 X172.396 Y151.009 E.59649
G1 X175.106 Y151.009 E.08991
; COOLING_NODE: 0
M204 S10000
M73 P92 R1
G1 X175.573 Y150.602 F60000
G1 F1433
M204 S8000
G1 X175.573 Y169.398 E.62349
G1 X171.989 Y169.398 E.1189
G1 X171.989 Y150.602 E.62349
G1 X175.513 Y150.602 E.11691
; COOLING_NODE: 0
M204 S250
G1 X175.965 Y150.21 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1433
M204 S5000
G1 X175.965 Y169.79 E.60164
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X171.596 Y169.79 E.13423
G1 X171.596 Y150.21 E.60164
G1 X175.905 Y150.21 E.13239
; WIPE_START
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
G1 F1433
M204 S8000
G1 X174.411 Y151.764 E.02071
G1 X174.411 Y152.769 E.03331
G1 X174.339 Y153.448 E.02268
G1 X174.411 Y153.657 E.00731
G1 X174.411 Y158.01 E.14439
G1 X174.339 Y158.69 E.02268
G1 X174.411 Y158.898 E.00731
G1 X174.411 Y163.251 E.14439
G1 X174.339 Y163.931 E.02268
G1 X174.411 Y164.14 E.00731
G1 X174.411 Y165.768 E.05401
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
G1 F1431
M204 S8000
G1 X174.759 Y168.584 E.56948
G1 X172.804 Y168.584 E.06485
G1 X172.804 Y151.416 E.56948
G1 X174.699 Y151.416 E.06286
; COOLING_NODE: 0
M204 S10000
G1 X175.166 Y151.009 F60000
G1 F1431
M204 S8000
G1 X175.166 Y168.991 E.59649
G1 X172.397 Y168.991 E.09185
G1 X172.397 Y151.009 E.59649
G1 X175.106 Y151.009 E.08986
; COOLING_NODE: 0
M204 S10000
G1 X175.573 Y150.602 F60000
G1 F1431
M204 S8000
G1 X175.573 Y169.398 E.62349
G1 X171.99 Y169.398 E.11886
G1 X171.99 Y150.602 E.62349
G1 X175.513 Y150.602 E.11687
; COOLING_NODE: 0
M204 S250
G1 X175.965 Y150.21 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1431
M204 S5000
G1 X175.965 Y169.79 E.60164
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X171.598 Y169.79 E.1342
G1 X171.598 Y150.21 E.60164
G1 X175.905 Y150.21 E.13235
; WIPE_START
M73 P93 R1
G1 F9547.055
M204 S8000
G1 X175.911 Y152.21 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X174.215 Y151.764 Z18.8 F60000
G1 Z18.4
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F1431
M204 S8000
G1 X174.411 Y151.764 E.00647
G1 X174.411 Y153.198 E.04754
G2 X174.411 Y153.846 I.715 J.324 E.02217
G1 X174.411 Y158.439 E.15236
G2 X174.411 Y159.087 I.715 J.324 E.02217
G1 X174.411 Y163.68 E.15236
G2 X174.411 Y164.328 I.715 J.324 E.02217
G1 X174.411 Y165.957 E.05401
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
G1 F1435
M204 S8000
G1 X174.759 Y168.584 E.56948
G1 X172.805 Y168.584 E.06481
G1 X172.805 Y151.416 E.56948
G1 X174.699 Y151.416 E.06282
; COOLING_NODE: 0
M204 S10000
G1 X175.166 Y151.009 F60000
G1 F1435
M204 S8000
G1 X175.166 Y168.991 E.59649
G1 X172.398 Y168.991 E.09181
G1 X172.398 Y151.009 E.59649
G1 X175.106 Y151.009 E.08982
; COOLING_NODE: 0
M204 S10000
G1 X175.573 Y150.602 F60000
G1 F1435
M204 S8000
G1 X175.573 Y169.398 E.62349
G1 X171.991 Y169.398 E.11882
G1 X171.991 Y150.602 E.62349
G1 X175.513 Y150.602 E.11683
; COOLING_NODE: 0
M204 S250
G1 X175.965 Y150.21 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1435
M204 S5000
G1 X175.965 Y169.79 E.60164
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X171.599 Y169.79 E.13416
G1 X171.599 Y150.21 E.60164
G1 X175.905 Y150.21 E.13231
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
G1 F1435
M204 S8000
G1 X174.411 Y151.764 E.00449
G1 X174.411 Y153.258 E.04953
G1 X174.325 Y153.448 E.00694
G1 X174.317 Y154.104 E.02173
G1 X174.411 Y154.329 E.0081
G1 X174.411 Y158.499 E.13831
G1 X174.325 Y158.69 E.00694
G1 X174.317 Y159.345 E.02173
G1 X174.411 Y159.571 E.0081
G1 X174.411 Y163.74 E.13831
G1 X174.325 Y163.931 E.00694
G1 X174.317 Y164.586 E.02173
G1 X174.411 Y164.812 E.0081
G1 X174.411 Y166.44 E.05401
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
G1 F1574
M204 S8000
G1 X174.759 Y168.584 E.56948
G1 X172.806 Y168.584 E.06477
G1 X172.806 Y151.416 E.56948
G1 X174.699 Y151.416 E.06278
; COOLING_NODE: 0
M204 S10000
G1 X175.166 Y151.009 F60000
G1 F1574
M204 S8000
M73 P94 R1
G1 X175.166 Y168.991 E.59649
G1 X172.399 Y168.991 E.09177
G1 X172.399 Y151.009 E.59649
G1 X175.106 Y151.009 E.08978
; COOLING_NODE: 0
M204 S10000
G1 X175.573 Y150.602 F60000
G1 F1574
M204 S8000
G1 X175.573 Y169.398 E.62349
G1 X171.992 Y169.398 E.11878
G1 X171.992 Y150.602 E.62349
G1 X175.513 Y150.602 E.11679
; COOLING_NODE: 0
M204 S250
G1 X175.965 Y150.21 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1544
M204 S5000
G1 X175.965 Y169.79 E.60164
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X171.6 Y169.79 E.13412
G1 X171.6 Y150.21 E.60164
G1 X175.905 Y150.21 E.13228
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
G1 F1574
M204 S8000
G1 X174.411 Y165.184 E.05401
G3 X174.142 Y164.586 I.431 J-.553 E.02261
G1 X174.28 Y163.931 E.02221
G1 X174.411 Y163.729 E.00798
G1 X174.411 Y159.943 E.12562
G3 X174.142 Y159.345 I.431 J-.553 E.02261
G1 X174.28 Y158.69 E.02221
G1 X174.411 Y158.488 E.00798
G1 X174.411 Y154.701 E.12562
G3 X174.142 Y154.104 I.431 J-.553 E.02261
G1 X174.28 Y153.448 E.02221
G1 X174.411 Y153.247 E.00798
G1 X174.411 Y151.764 E.04917
G1 X173.155 Y151.764 E.04166
G1 X173.155 Y155.055 E.10914
G3 X173.155 Y155.808 I-.988 J.377 E.02556
G1 X173.155 Y160.296 E.14887
G3 X173.155 Y161.05 I-.988 J.377 E.02556
G1 X173.155 Y165.537 E.14887
G3 X173.155 Y166.291 I-.988 J.377 E.02556
G1 X173.155 Y167.919 E.05401
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
G1 F1546
M204 S8000
G1 X174.759 Y168.584 E.56948
G1 X172.808 Y168.584 E.06473
G1 X172.808 Y151.416 E.56948
G1 X174.699 Y151.416 E.06274
; COOLING_NODE: 0
M204 S10000
G1 X175.166 Y151.009 F60000
G1 F1546
M204 S8000
G1 X175.166 Y168.991 E.59649
G1 X172.401 Y168.991 E.09173
G1 X172.401 Y151.009 E.59649
G1 X175.106 Y151.009 E.08974
; COOLING_NODE: 0
M204 S10000
G1 X175.573 Y150.602 F60000
G1 F1546
M204 S8000
G1 X175.573 Y169.398 E.62349
G1 X171.993 Y169.398 E.11874
G1 X171.993 Y150.602 E.62349
G1 X175.513 Y150.602 E.11675
; COOLING_NODE: 0
M204 S250
G1 X175.965 Y150.21 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1546
M204 S5000
M73 P95 R1
G1 X175.965 Y169.79 E.60164
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X171.601 Y169.79 E.13408
G1 X171.601 Y150.21 E.60164
G1 X175.905 Y150.21 E.13224
; WIPE_START
M73 P95 R0
G1 F9547.055
M204 S8000
G1 X175.911 Y152.21 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X173.156 Y152.947 Z19.4 F60000
G1 Z19
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F1546
M204 S8000
G1 X173.156 Y154.575 E.05401
G1 X173.69 Y154.729 E.01843
G3 X174.411 Y153.202 I3.959 J.936 E.0564
G1 X174.411 Y155.031 E.06066
G1 X173.69 Y154.789 E.02522
G3 X173.156 Y156.067 I-4.352 J-1.067 E.04614
G1 X173.156 Y159.816 E.12436
G1 X173.69 Y159.97 E.01843
G3 X174.411 Y158.444 I3.959 J.936 E.0564
G1 X174.411 Y160.272 E.06066
G1 X173.69 Y160.03 E.02522
G3 X173.156 Y161.309 I-4.353 J-1.067 E.04614
G1 X173.156 Y165.058 E.12436
G1 X173.69 Y165.211 E.01843
G3 X174.411 Y163.685 I3.959 J.936 E.0564
G1 X174.411 Y165.514 E.06066
G1 X173.69 Y165.272 E.02522
G3 X173.156 Y166.55 I-4.352 J-1.067 E.04614
G1 X173.156 Y168.178 E.05401
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

; OBJECT_ID: 15
; COOLING_NODE: 0
M204 S10000
G17
G3 Z19.4 I1.211 J.116 P1  F60000
G1 X174.759 Y151.416 Z19.4
G1 Z19.2
G1 E.8 F1800
; FEATURE: Inner wall
G1 F1835
M204 S8000
G1 X174.759 Y168.584 E.56948
G1 X172.809 Y168.584 E.06468
G1 X172.809 Y151.416 E.56948
G1 X174.699 Y151.416 E.06269
; COOLING_NODE: 0
M204 S10000
G1 X175.166 Y151.009 F60000
G1 F1835
M204 S8000
G1 X175.166 Y168.991 E.59649
G1 X172.402 Y168.991 E.09169
G1 X172.402 Y151.009 E.59649
G1 X175.106 Y151.009 E.0897
; COOLING_NODE: 0
M204 S10000
G1 X175.573 Y150.602 F60000
G1 F1835
M204 S8000
G1 X175.573 Y169.398 E.62349
G1 X171.995 Y169.398 E.1187
G1 X171.995 Y150.602 E.62349
G1 X175.513 Y150.602 E.11671
; COOLING_NODE: 0
M204 S250
G1 X175.965 Y150.21 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1669
M204 S5000
G1 X175.965 Y169.79 E.60164
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X171.603 Y169.79 E.13404
G1 X171.603 Y150.21 E.60164
G1 X175.905 Y150.21 E.1322
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
G1 F1835
M204 S8000
G1 X173.201 Y151.808 E.03582
G1 X173.201 Y168.192 E.50341
G1 X174.367 Y168.192 E.03582
G1 X174.367 Y151.868 E.50156
M204 S10000
G1 X173.981 Y152.391 F60000
; LINE_WIDTH: 0.43732
G1 F1835
M204 S8000
G1 X173.981 Y152.194 E.00634
G1 X173.587 Y152.194 E.01268
G1 X173.587 Y167.806 E.50175
G1 X173.981 Y167.806 E.01268
G1 X173.981 Y152.451 E.49348
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
M73 P96 R0
G1 F1832
M204 S8000
G1 X174.759 Y168.584 E.56948
G1 X172.81 Y168.584 E.06464
G1 X172.81 Y151.416 E.56948
G1 X174.699 Y151.416 E.06265
; COOLING_NODE: 0
M204 S10000
G1 X175.166 Y151.009 F60000
G1 F1832
M204 S8000
G1 X175.166 Y168.991 E.59649
G1 X172.403 Y168.991 E.09165
G1 X172.403 Y151.009 E.59649
G1 X175.106 Y151.009 E.08966
; COOLING_NODE: 0
M204 S10000
G1 X175.573 Y150.602 F60000
G1 F1832
M204 S8000
G1 X175.573 Y169.398 E.62349
G1 X171.996 Y169.398 E.11866
G1 X171.996 Y150.602 E.62349
G1 X175.513 Y150.602 E.11667
; COOLING_NODE: 0
M204 S250
G1 X175.965 Y150.21 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1734
M204 S5000
G1 X175.965 Y169.79 E.60164
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X171.604 Y169.79 E.13401
G1 X171.604 Y150.21 E.60164
G1 X175.905 Y150.21 E.13216
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
G1 F1832
M204 S8000
G1 X174.367 Y151.808 E.01789
G1 X173.202 Y151.808 E.03579
G1 X173.202 Y168.192 E.50341
G1 X174.367 Y168.192 E.03579
G1 X174.367 Y152.451 E.48367
M204 S10000
G1 X173.981 Y152.391 F60000
; LINE_WIDTH: 0.4367
G1 F1832
M204 S8000
G1 X173.981 Y152.194 E.00632
G1 X173.588 Y152.194 E.01264
G1 X173.588 Y167.806 E.50098
G1 X173.981 Y167.806 E.01264
G1 X173.981 Y152.451 E.49274
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
G1 F1832
M204 S8000
G1 X174.759 Y168.584 E.56948
G1 X172.811 Y168.584 E.0646
G1 X172.811 Y151.416 E.56948
G1 X174.699 Y151.416 E.06261
; COOLING_NODE: 0
M204 S10000
G1 X175.166 Y151.009 F60000
G1 F1832
M204 S8000
G1 X175.166 Y168.991 E.59649
G1 X172.404 Y168.991 E.09161
G1 X172.404 Y151.009 E.59649
G1 X175.106 Y151.009 E.08962
; COOLING_NODE: 0
M204 S10000
G1 X175.573 Y150.602 F60000
G1 F1832
M204 S8000
G1 X175.573 Y169.398 E.62349
G1 X171.997 Y169.398 E.11862
G1 X171.997 Y150.602 E.62349
G1 X175.513 Y150.602 E.11663
; COOLING_NODE: 0
M204 S250
G1 X175.965 Y150.21 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1796
M204 S5000
M73 P97 R0
G1 X175.965 Y169.79 E.60164
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X171.605 Y169.79 E.13397
G1 X171.605 Y150.21 E.60164
G1 X175.905 Y150.21 E.13213
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
G1 F1832
M204 S8000
G1 X174.367 Y151.808 E.01787
G1 X173.203 Y151.808 E.03575
G1 X173.203 Y168.192 E.50341
G1 X174.367 Y168.192 E.03575
G1 X174.367 Y152.45 E.48369
M204 S10000
G1 X173.982 Y152.39 F60000
; LINE_WIDTH: 0.43609
G1 F1832
M204 S8000
G1 X173.982 Y152.193 E.0063
G1 X173.588 Y152.193 E.0126
G1 X173.588 Y167.807 E.50022
G1 X173.982 Y167.807 E.0126
G1 X173.982 Y152.45 E.492
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
G1 F1832
M204 S8000
G1 X174.759 Y168.584 E.56948
G1 X172.813 Y168.584 E.06456
G1 X172.813 Y151.416 E.56948
G1 X174.699 Y151.416 E.06257
; COOLING_NODE: 0
M204 S10000
G1 X175.166 Y151.009 F60000
G1 F1832
M204 S8000
G1 X175.166 Y168.991 E.59649
G1 X172.405 Y168.991 E.09157
G1 X172.405 Y151.009 E.59649
G1 X175.106 Y151.009 E.08958
; COOLING_NODE: 0
M204 S10000
G1 X175.573 Y150.602 F60000
G1 F1832
M204 S8000
G1 X175.573 Y169.398 E.62349
G1 X171.998 Y169.398 E.11858
G1 X171.998 Y150.602 E.62349
G1 X175.513 Y150.602 E.11658
; COOLING_NODE: 0
M204 S250
G1 X175.965 Y150.21 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1832
M204 S5000
G1 X175.965 Y169.79 E.60164
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X171.606 Y169.79 E.13393
G1 X171.606 Y150.21 E.60164
G1 X175.905 Y150.21 E.13209
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
G1 F1832
M204 S8000
G1 X174.367 Y151.808 E.01785
G1 X173.205 Y151.808 E.03571
G1 X173.205 Y168.192 E.50341
G1 X174.367 Y168.192 E.03571
G1 X174.367 Y152.449 E.48371
M204 S10000
G1 X173.982 Y152.389 F60000
; LINE_WIDTH: 0.43547
G1 F1832
M204 S8000
G1 X173.982 Y152.193 E.00628
G1 X173.589 Y152.193 E.01256
G1 X173.589 Y167.807 E.49945
G1 X173.982 Y167.807 E.01256
G1 X173.982 Y152.449 E.49126
; CHANGE_LAYER
; Z_HEIGHT: 20
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F9170.806
M73 P98 R0
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
G1 F1900
M204 S5000
G1 X175.965 Y169.79 E.60164
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

G1 X171.608 Y169.79 E.13389
G1 X171.608 Y150.21 E.60164
G1 X175.905 Y150.21 E.13205
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
G1 F2272
M204 S2000
G1 X175.283 Y169.583 E.02064
G1 X175.149 Y169.716
G1 X174.616 Y169.716
G1 X174.749 Y169.583
G1 X175.758 Y168.574 E.04382
G1 X175.891 Y168.441
G1 X175.891 Y167.907
G1 X175.758 Y168.041
G1 X174.216 Y169.583 E.06699
G1 X174.082 Y169.716
G1 X173.549 Y169.716
G1 X173.683 Y169.583
G1 X175.758 Y167.508 E.09016
G1 X175.891 Y167.374
G1 X175.891 Y166.841
G1 X175.758 Y166.975
G1 X173.15 Y169.583 E.11334
G1 X173.016 Y169.716
G1 X172.483 Y169.716
G1 X172.616 Y169.583
G1 X175.758 Y166.441 E.13651
G1 X175.891 Y166.308
G1 X175.891 Y165.774
G1 X175.758 Y165.908
G1 X172.083 Y169.583 E.15968
G1 X171.949 Y169.716
G1 X171.681 Y169.451
G1 X171.815 Y169.317
G1 X175.758 Y165.375 E.17133
G1 X175.891 Y165.241
G1 X175.891 Y164.708
G1 X175.758 Y164.842
G1 X171.815 Y168.784 E.17133
G1 X171.681 Y168.918
G1 X171.681 Y168.385
G1 X171.815 Y168.251
G1 X175.758 Y164.308 E.17133
G1 X175.891 Y164.175
G1 X175.891 Y163.641
G1 X175.758 Y163.775
G1 X171.815 Y167.718 E.17133
G1 X171.681 Y167.851
G1 X171.681 Y167.318
G1 X171.815 Y167.184
G1 X175.758 Y163.242 E.17133
G1 X175.891 Y163.108
G1 X175.891 Y162.575
G1 X175.758 Y162.708
G1 X171.815 Y166.651 E.17133
G1 X171.681 Y166.785
G1 X171.681 Y166.252
G1 X171.815 Y166.118
G1 X175.758 Y162.175 E.17133
G1 X175.891 Y162.042
G1 X175.891 Y161.508
G1 X175.758 Y161.642
G1 X171.815 Y165.585 E.17133
G1 X171.681 Y165.718
G1 X171.681 Y165.185
G1 X171.815 Y165.051
G1 X175.758 Y161.109 E.17133
G1 X175.891 Y160.975
G1 X175.891 Y160.442
G1 X175.758 Y160.575
G1 X171.815 Y164.518 E.17133
G1 X171.681 Y164.652
G1 X171.681 Y164.119
G1 X171.815 Y163.985
G1 X175.758 Y160.042 E.17133
G1 X175.891 Y159.909
G1 X175.891 Y159.375
G1 X175.758 Y159.509
G1 X171.815 Y163.452 E.17133
G1 X171.681 Y163.585
G1 X171.681 Y163.052
G1 X171.815 Y162.918
G1 X175.758 Y158.976 E.17133
G1 X175.891 Y158.842
G1 X175.891 Y158.309
G1 X175.758 Y158.442
G1 X171.815 Y162.385 E.17133
G1 X171.681 Y162.519
G1 X171.681 Y161.986
G1 X171.815 Y161.852
G1 X175.758 Y157.909 E.17133
G1 X175.891 Y157.776
G1 X175.891 Y157.242
G1 X175.758 Y157.376
G1 X171.815 Y161.319 E.17133
G1 X171.681 Y161.452
G1 X171.681 Y160.919
G1 X171.815 Y160.785
G1 X175.758 Y156.843 E.17133
G1 X175.891 Y156.709
G1 X175.891 Y156.176
G1 X175.758 Y156.309
G1 X171.815 Y160.252 E.17133
G1 X171.681 Y160.386
G1 X171.681 Y159.852
G1 X171.815 Y159.719
M73 P99 R0
G1 X175.758 Y155.776 E.17133
G1 X175.891 Y155.642
G1 X175.891 Y155.109
G1 X175.758 Y155.243
G1 X171.815 Y159.186 E.17133
G1 X171.681 Y159.319
G1 X171.681 Y158.786
G1 X171.815 Y158.652
G1 X175.758 Y154.71 E.17133
G1 X175.891 Y154.576
G1 X175.891 Y154.043
G1 X175.758 Y154.176
G1 X171.815 Y158.119 E.17133
G1 X171.681 Y158.253
G1 X171.681 Y157.719
G1 X171.815 Y157.586
G1 X175.758 Y153.643 E.17133
G1 X175.891 Y153.509
G1 X175.891 Y152.976
G1 X175.758 Y153.11
G1 X171.815 Y157.053 E.17133
G1 X171.681 Y157.186
G1 X171.681 Y156.653
G1 X171.815 Y156.519
G1 X175.758 Y152.577 E.17133
G1 X175.891 Y152.443
G1 X175.891 Y151.91
G1 X175.758 Y152.043
G1 X171.815 Y155.986 E.17133
G1 X171.681 Y156.12
G1 X171.681 Y155.586
G1 X171.815 Y155.453
G1 X175.758 Y151.51 E.17133
G1 X175.891 Y151.376
G1 X175.891 Y150.843
G1 X175.758 Y150.977
G1 X171.815 Y154.92 E.17133
G1 X171.681 Y155.053
G1 X171.681 Y154.52
G1 X171.815 Y154.386
G1 X175.758 Y150.444 E.17133
G1 X175.891 Y150.31
G1 X175.384 Y150.284
G1 X175.251 Y150.417
G1 X171.815 Y153.853 E.14929
G1 X171.681 Y153.987
G1 X171.681 Y153.453
G1 X171.815 Y153.32
G1 X174.717 Y150.417 E.12612
G1 X174.851 Y150.284
G1 X174.318 Y150.284
G1 X174.184 Y150.417
G1 X171.815 Y152.787 E.10295
G1 X171.681 Y152.92
G1 X171.681 Y152.387
G1 X171.815 Y152.253
G1 X173.651 Y150.417 E.07978
G1 X173.784 Y150.284
G1 X173.251 Y150.284
G1 X173.118 Y150.417
G1 X171.815 Y151.72 E.0566
G1 X171.681 Y151.854
G1 X171.681 Y151.32
G1 X171.815 Y151.187
G1 X172.584 Y150.417 E.03343
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

