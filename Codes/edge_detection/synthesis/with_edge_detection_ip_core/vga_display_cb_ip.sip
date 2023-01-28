set_global_assignment -entity "vga_display_cb_ip" -library "lib_vga_display_cb_ip" -name IP_TOOL_NAME "altera_up_avalon_video_character_buffer_with_dma"
set_global_assignment -entity "vga_display_cb_ip" -library "lib_vga_display_cb_ip" -name IP_TOOL_VERSION "13.0sp1"
set_global_assignment -entity "vga_display_cb_ip" -library "lib_vga_display_cb_ip" -name IP_TOOL_ENV "mwpim"
set_global_assignment -library "lib_vga_display_cb_ip" -name SPD_FILE [file join $::quartus(sip_path) "vga_display_cb_ip.spd"]

set_global_assignment -library "lib_vga_display_cb_ip" -name MISC_FILE [file join $::quartus(sip_path) "vga_display_cb_ip_sim/altera_up_video_128_character_rom.v"]
set_global_assignment -library "lib_vga_display_cb_ip" -name MISC_FILE [file join $::quartus(sip_path) "vga_display_cb_ip_sim/altera_up_video_fb_color_rom.v"]
set_global_assignment -library "lib_vga_display_cb_ip" -name MISC_FILE [file join $::quartus(sip_path) "vga_display_cb_ip_sim/altera_up_video_char_mode_rom_128.mif"]
set_global_assignment -library "lib_vga_display_cb_ip" -name MISC_FILE [file join $::quartus(sip_path) "vga_display_cb_ip_sim/altera_up_video_fb_color_rom.mif"]
set_global_assignment -library "lib_vga_display_cb_ip" -name MISC_FILE [file join $::quartus(sip_path) "vga_display_cb_ip_sim/vga_display_cb_ip.v"]
