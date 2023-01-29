onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /EdgeDetector_tb/clk_r
add wave -noupdate /EdgeDetector_tb/rst_r
add wave -noupdate /EdgeDetector_tb/start_r
add wave -noupdate -radix decimal /EdgeDetector_tb/GrayImage_r
add wave -noupdate /EdgeDetector_tb/valid_w
add wave -noupdate /EdgeDetector_tb/dataAvailable_w
add wave -noupdate -radix unsigned /EdgeDetector_tb/ProcessedImagePixel_w
add wave -noupdate -radix unsigned /EdgeDetector_tb/EdgeDetector_DUT/EdgeDetector_CU/ps_r
add wave -noupdate /EdgeDetector_tb/EdgeDetector_DUT/EdgeDetector_DP/MemGxyAdr_w
add wave -noupdate /EdgeDetector_tb/EdgeDetector_DUT/EdgeDetector_DP/CntrMemG/X_o
add wave -noupdate /EdgeDetector_tb/EdgeDetector_DUT/EdgeDetector_DP/CntrMemG/Y_o
add wave -noupdate -radix decimal -childformat {{{/EdgeDetector_tb/EdgeDetector_DUT/EdgeDetector_DP/MemGx/mem_m[0]} -radix decimal}} -expand -subitemconfig {{/EdgeDetector_tb/EdgeDetector_DUT/EdgeDetector_DP/MemGx/mem_m[0]} {-height 15 -radix decimal}} /EdgeDetector_tb/EdgeDetector_DUT/EdgeDetector_DP/MemGx/mem_m
add wave -noupdate -radix decimal -childformat {{{/EdgeDetector_tb/EdgeDetector_DUT/EdgeDetector_DP/MemGy/mem_m[0]} -radix decimal}} -expand -subitemconfig {{/EdgeDetector_tb/EdgeDetector_DUT/EdgeDetector_DP/MemGy/mem_m[0]} {-height 15 -radix decimal}} /EdgeDetector_tb/EdgeDetector_DUT/EdgeDetector_DP/MemGy/mem_m
add wave -noupdate -radix decimal -childformat {{{/EdgeDetector_tb/EdgeDetector_DUT/EdgeDetector_DP/MemImg/DataRd_o[7]} -radix decimal} {{/EdgeDetector_tb/EdgeDetector_DUT/EdgeDetector_DP/MemImg/DataRd_o[6]} -radix decimal} {{/EdgeDetector_tb/EdgeDetector_DUT/EdgeDetector_DP/MemImg/DataRd_o[5]} -radix decimal} {{/EdgeDetector_tb/EdgeDetector_DUT/EdgeDetector_DP/MemImg/DataRd_o[4]} -radix decimal} {{/EdgeDetector_tb/EdgeDetector_DUT/EdgeDetector_DP/MemImg/DataRd_o[3]} -radix decimal} {{/EdgeDetector_tb/EdgeDetector_DUT/EdgeDetector_DP/MemImg/DataRd_o[2]} -radix decimal} {{/EdgeDetector_tb/EdgeDetector_DUT/EdgeDetector_DP/MemImg/DataRd_o[1]} -radix decimal} {{/EdgeDetector_tb/EdgeDetector_DUT/EdgeDetector_DP/MemImg/DataRd_o[0]} -radix decimal}} -subitemconfig {{/EdgeDetector_tb/EdgeDetector_DUT/EdgeDetector_DP/MemImg/DataRd_o[7]} {-height 15 -radix decimal} {/EdgeDetector_tb/EdgeDetector_DUT/EdgeDetector_DP/MemImg/DataRd_o[6]} {-height 15 -radix decimal} {/EdgeDetector_tb/EdgeDetector_DUT/EdgeDetector_DP/MemImg/DataRd_o[5]} {-height 15 -radix decimal} {/EdgeDetector_tb/EdgeDetector_DUT/EdgeDetector_DP/MemImg/DataRd_o[4]} {-height 15 -radix decimal} {/EdgeDetector_tb/EdgeDetector_DUT/EdgeDetector_DP/MemImg/DataRd_o[3]} {-height 15 -radix decimal} {/EdgeDetector_tb/EdgeDetector_DUT/EdgeDetector_DP/MemImg/DataRd_o[2]} {-height 15 -radix decimal} {/EdgeDetector_tb/EdgeDetector_DUT/EdgeDetector_DP/MemImg/DataRd_o[1]} {-height 15 -radix decimal} {/EdgeDetector_tb/EdgeDetector_DUT/EdgeDetector_DP/MemImg/DataRd_o[0]} {-height 15 -radix decimal}} /EdgeDetector_tb/EdgeDetector_DUT/EdgeDetector_DP/MemImg/DataRd_o
add wave -noupdate -radix unsigned /EdgeDetector_tb/EdgeDetector_DUT/EdgeDetector_DP/MemImg/Adr_i
add wave -noupdate /EdgeDetector_tb/EdgeDetector_DUT/EdgeDetector_DP/CntrInput/X_o
add wave -noupdate /EdgeDetector_tb/EdgeDetector_DUT/EdgeDetector_DP/CntrInput/Y_o
add wave -noupdate /EdgeDetector_tb/EdgeDetector_DUT/EdgeDetector_DP/CntrMemG/X_o
add wave -noupdate /EdgeDetector_tb/EdgeDetector_DUT/EdgeDetector_DP/CntrMemG/Y_o
add wave -noupdate /EdgeDetector_tb/EdgeDetector_DUT/EdgeDetector_DP/CntrKernel/X_o
add wave -noupdate /EdgeDetector_tb/EdgeDetector_DUT/EdgeDetector_DP/CntrKernel/Y_o
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 415
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
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
WaveRestoreZoom {0 ps} {228 ps}
