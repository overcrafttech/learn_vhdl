onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /pcu_tb/clk_tb
add wave -noupdate /pcu_tb/rst_tb
add wave -noupdate /pcu_tb/load_tb
add wave -noupdate /pcu_tb/jump_tb
add wave -noupdate /pcu_tb/stop_tb
add wave -noupdate /pcu_tb/loadvalue_tb
add wave -noupdate /pcu_tb/pc_tb
add wave -noupdate /pcu_tb/count_tb
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {30 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
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
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ns} {138 ns}
run 150 ns