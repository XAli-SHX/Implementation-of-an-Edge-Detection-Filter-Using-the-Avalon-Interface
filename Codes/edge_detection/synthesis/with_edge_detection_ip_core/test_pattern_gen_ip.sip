set_global_assignment -entity "test_pattern_gen_ip" -library "lib_test_pattern_gen_ip" -name IP_TOOL_NAME "altera_up_avalon_video_test_pattern"
set_global_assignment -entity "test_pattern_gen_ip" -library "lib_test_pattern_gen_ip" -name IP_TOOL_VERSION "13.0sp1"
set_global_assignment -entity "test_pattern_gen_ip" -library "lib_test_pattern_gen_ip" -name IP_TOOL_ENV "mwpim"
set_global_assignment -library "lib_test_pattern_gen_ip" -name SPD_FILE [file join $::quartus(sip_path) "test_pattern_gen_ip.spd"]

set_global_assignment -library "lib_test_pattern_gen_ip" -name MISC_FILE [file join $::quartus(sip_path) "test_pattern_gen_ip_sim/test_pattern_gen_ip.v"]
