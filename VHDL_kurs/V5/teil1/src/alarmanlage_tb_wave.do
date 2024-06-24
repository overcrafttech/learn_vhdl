onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider Testbench
add wave -noupdate /alarmanlage_tb/clk_tb
add wave -noupdate /alarmanlage_tb/rst_tb
add wave -noupdate /alarmanlage_tb/go_tb
add wave -noupdate /alarmanlage_tb/door_open_tb
add wave -noupdate /alarmanlage_tb/validate_tb
add wave -noupdate -divider single_process
add wave -noupdate /alarmanlage_tb/alarm_tb_1p
add wave -noupdate /alarmanlage_tb/single_process/state
add wave -noupdate /alarmanlage_tb/single_process/pc_pcu
add wave -noupdate /alarmanlage_tb/single_process/load_pcu
add wave -noupdate /alarmanlage_tb/single_process/stop_pcu
add wave -noupdate -divider multi_process
add wave -noupdate /alarmanlage_tb/alarm_tb_mp
add wave -noupdate /alarmanlage_tb/multi_process/state
add wave -noupdate /alarmanlage_tb/multi_process/pc_pcu
add wave -noupdate /alarmanlage_tb/multi_process/load_pcu
add wave -noupdate /alarmanlage_tb/multi_process/stop_pcu
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1023509174 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1000000
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits sec
update
WaveRestoreZoom {0 ns} {6562500 us}
