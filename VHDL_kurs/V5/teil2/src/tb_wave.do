onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider Testbench
add wave -noupdate /dsp_tb/clk_tb
add wave -noupdate /dsp_tb/rst_tb
add wave -noupdate /dsp_tb/data_re_tb
add wave -noupdate /dsp_tb/data_im_tb
add wave -noupdate /dsp_tb/data_valid_tb
add wave -noupdate /dsp_tb/start_tb
add wave -noupdate -divider dsp_1
add wave -noupdate /dsp_tb/result_dsp_1
add wave -noupdate -divider dsp_2
add wave -noupdate /dsp_tb/result_dsp_2
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {550 ns} 0}
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
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ns} {1785 ns}
