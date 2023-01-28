set_global_assignment -entity "edge_detector_ip" -library "lib_edge_detector_ip" -name IP_TOOL_NAME "altera_up_avalon_video_edge_detection"
set_global_assignment -entity "edge_detector_ip" -library "lib_edge_detector_ip" -name IP_TOOL_VERSION "13.0sp1"
set_global_assignment -entity "edge_detector_ip" -library "lib_edge_detector_ip" -name IP_TOOL_ENV "mwpim"
set_global_assignment -library "lib_edge_detector_ip" -name SPD_FILE [file join $::quartus(sip_path) "edge_detector_ip.spd"]

set_global_assignment -library "lib_edge_detector_ip" -name MISC_FILE [file join $::quartus(sip_path) "edge_detector_ip_sim/altera_up_edge_detection_gaussian_smoothing_filter.v"]
set_global_assignment -library "lib_edge_detector_ip" -name MISC_FILE [file join $::quartus(sip_path) "edge_detector_ip_sim/altera_up_edge_detection_sobel_operator.v"]
set_global_assignment -library "lib_edge_detector_ip" -name MISC_FILE [file join $::quartus(sip_path) "edge_detector_ip_sim/altera_up_edge_detection_nonmaximum_suppression.v"]
set_global_assignment -library "lib_edge_detector_ip" -name MISC_FILE [file join $::quartus(sip_path) "edge_detector_ip_sim/altera_up_edge_detection_hysteresis.v"]
set_global_assignment -library "lib_edge_detector_ip" -name MISC_FILE [file join $::quartus(sip_path) "edge_detector_ip_sim/altera_up_edge_detection_pixel_info_shift_register.v"]
set_global_assignment -library "lib_edge_detector_ip" -name MISC_FILE [file join $::quartus(sip_path) "edge_detector_ip_sim/altera_up_edge_detection_data_shift_register.v"]
set_global_assignment -library "lib_edge_detector_ip" -name MISC_FILE [file join $::quartus(sip_path) "edge_detector_ip_sim/edge_detector_ip.v"]
