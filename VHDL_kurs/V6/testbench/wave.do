onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix binary /tb_snr_est/rst
add wave -noupdate -radix binary /tb_snr_est/clk
add wave -noupdate -radix binary /tb_snr_est/rfd
add wave -noupdate -divider INTERFACE
add wave -noupdate -radix binary /tb_snr_est/start
add wave -noupdate -radix binary /tb_snr_est/out_reverse
add wave -noupdate -divider {DATA IN}
add wave -noupdate -radix binary /tb_snr_est/data_last_in
add wave -noupdate -radix binary /tb_snr_est/data_valid_in
add wave -noupdate -radix decimal -childformat {{/tb_snr_est/data_i_in(7) -radix decimal} {/tb_snr_est/data_i_in(6) -radix decimal} {/tb_snr_est/data_i_in(5) -radix decimal} {/tb_snr_est/data_i_in(4) -radix decimal} {/tb_snr_est/data_i_in(3) -radix decimal} {/tb_snr_est/data_i_in(2) -radix decimal} {/tb_snr_est/data_i_in(1) -radix decimal} {/tb_snr_est/data_i_in(0) -radix decimal}} -subitemconfig {/tb_snr_est/data_i_in(7) {-radix decimal} /tb_snr_est/data_i_in(6) {-radix decimal} /tb_snr_est/data_i_in(5) {-radix decimal} /tb_snr_est/data_i_in(4) {-radix decimal} /tb_snr_est/data_i_in(3) {-radix decimal} /tb_snr_est/data_i_in(2) {-radix decimal} /tb_snr_est/data_i_in(1) {-radix decimal} /tb_snr_est/data_i_in(0) {-radix decimal}} /tb_snr_est/data_i_in
add wave -noupdate -radix decimal /tb_snr_est/data_q_in
add wave -noupdate -divider RESULT
add wave -noupdate -radix binary /tb_snr_est/result_valid
add wave -noupdate -radix unsigned /tb_snr_est/num_symbols
add wave -noupdate -radix unsigned /tb_snr_est/psf
add wave -noupdate -radix unsigned /tb_snr_est/prf
add wave -noupdate -divider {DATA OUT}
add wave -noupdate /tb_snr_est/data_valid_out
add wave -noupdate -radix decimal /tb_snr_est/data_i_out
add wave -noupdate -radix decimal /tb_snr_est/data_q_out
add wave -noupdate -divider INTERNAL
add wave -noupdate /tb_snr_est/dut/state
add wave -noupdate -radix binary /tb_snr_est/dut/i_out_reverse
add wave -noupdate -radix unsigned /tb_snr_est/dut/i_num_symbols
add wave -noupdate -radix unsigned /tb_snr_est/dut/max_num_symbols
add wave -noupdate -divider {RAM IN}
add wave -noupdate -radix binary /tb_snr_est/dut/ram_component/clka
add wave -noupdate /tb_snr_est/dut/ena
add wave -noupdate -radix unsigned /tb_snr_est/dut/ram_component/addra
add wave -noupdate -radix unsigned /tb_snr_est/dut/ram_component/dina
add wave -noupdate -divider {RAM OUT}
add wave -noupdate -radix binary /tb_snr_est/dut/enb
add wave -noupdate -radix unsigned /tb_snr_est/dut/addrb
add wave -noupdate -radix unsigned /tb_snr_est/dut/doutb
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {167907 ns} 0}
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
WaveRestoreZoom {167420 ns} {169858 ns}
