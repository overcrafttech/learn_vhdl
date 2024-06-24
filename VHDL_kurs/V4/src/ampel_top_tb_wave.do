onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand /testbench_ampel_top/ampel_top_component/haupt1
add wave -noupdate /testbench_ampel_top/ampel_top_component/haupt2
add wave -noupdate -expand /testbench_ampel_top/ampel_top_component/neben3
add wave -noupdate /testbench_ampel_top/ampel_top_component/neben4
add wave -noupdate /testbench_ampel_top/ampel_top_component/reset
add wave -noupdate /testbench_ampel_top/ampel_top_component/sec_puls
add wave -noupdate /testbench_ampel_top/clk_tb
add wave -noupdate /testbench_ampel_top/rst_n_tb
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {9293763676 ns} 0}
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
WaveRestoreZoom {0 ns} {15750 ms}
