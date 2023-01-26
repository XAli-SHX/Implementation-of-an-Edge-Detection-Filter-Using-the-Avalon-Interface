onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /CounterDualPort_tb/clk_r
add wave -noupdate /CounterDualPort_tb/rst_r
add wave -noupdate /CounterDualPort_tb/inc_r
add wave -noupdate /CounterDualPort_tb/clear_r
add wave -noupdate -radix unsigned /CounterDualPort_tb/X_w
add wave -noupdate -radix unsigned /CounterDualPort_tb/Y_w
add wave -noupdate /CounterDualPort_tb/finished_w
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {166 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 218
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
WaveRestoreZoom {47 ps} {166 ps}
