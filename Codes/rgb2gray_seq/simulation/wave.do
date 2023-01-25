onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /Rgb2Gray_tb/clk_r
add wave -noupdate /Rgb2Gray_tb/rst_r
add wave -noupdate /Rgb2Gray_tb/start_r
add wave -noupdate -radix unsigned /Rgb2Gray_tb/RgbColor_r
add wave -noupdate /Rgb2Gray_tb/valid_w
add wave -noupdate -radix unsigned /Rgb2Gray_tb/GrayColor_w
add wave -noupdate /Rgb2Gray_tb/Rgb2Gray_DUT/Rgb2Gray_CU/clear_o
add wave -noupdate /Rgb2Gray_tb/Rgb2Gray_DUT/Rgb2Gray_CU/ld_o
add wave -noupdate -radix unsigned /Rgb2Gray_tb/Rgb2Gray_DUT/Rgb2Gray_CU/ps_r
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {53 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 109
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {130 ps}
