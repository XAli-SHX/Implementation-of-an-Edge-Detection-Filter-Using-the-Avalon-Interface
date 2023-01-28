set_global_assignment -entity "pixel_buffer_ip" -library "lib_pixel_buffer_ip" -name IP_TOOL_NAME "altera_up_avalon_video_pixel_buffer_dma"
set_global_assignment -entity "pixel_buffer_ip" -library "lib_pixel_buffer_ip" -name IP_TOOL_VERSION "13.0sp1"
set_global_assignment -entity "pixel_buffer_ip" -library "lib_pixel_buffer_ip" -name IP_TOOL_ENV "mwpim"
set_global_assignment -library "lib_pixel_buffer_ip" -name SPD_FILE [file join $::quartus(sip_path) "pixel_buffer_ip.spd"]

set_global_assignment -library "lib_pixel_buffer_ip" -name MISC_FILE [file join $::quartus(sip_path) "pixel_buffer_ip_sim/pixel_buffer_ip.v"]
