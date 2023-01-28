set_global_assignment -entity "vga_controller_ip" -library "lib_vga_controller_ip" -name IP_TOOL_NAME "altera_up_avalon_video_vga_controller"
set_global_assignment -entity "vga_controller_ip" -library "lib_vga_controller_ip" -name IP_TOOL_VERSION "13.0sp1"
set_global_assignment -entity "vga_controller_ip" -library "lib_vga_controller_ip" -name IP_TOOL_ENV "mwpim"
set_global_assignment -library "lib_vga_controller_ip" -name SPD_FILE [file join $::quartus(sip_path) "vga_controller_ip.spd"]

set_global_assignment -library "lib_vga_controller_ip" -name MISC_FILE [file join $::quartus(sip_path) "vga_controller_ip_sim/altera_up_avalon_video_vga_timing.v"]
set_global_assignment -library "lib_vga_controller_ip" -name MISC_FILE [file join $::quartus(sip_path) "vga_controller_ip_sim/vga_controller_ip.v"]
