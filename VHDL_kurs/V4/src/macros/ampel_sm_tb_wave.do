onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand /ampel_sm_tb/testobjekt/haupt1
add wave -noupdate /ampel_sm_tb/testobjekt/haupt2
add wave -noupdate -expand /ampel_sm_tb/testobjekt/neben3
add wave -noupdate /ampel_sm_tb/testobjekt/neben4
add wave -noupdate /ampel_sm_tb/testobjekt/state
add wave -noupdate /ampel_sm_tb/testobjekt/timer
add wave -noupdate /ampel_sm_tb/clk_tb
add wave -noupdate /ampel_sm_tb/rst_tb
add wave -noupdate /ampel_sm_tb/rst_tb
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1094972067 ns} 0}
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
WaveRestoreZoom {0 ns} {22050 ms}
