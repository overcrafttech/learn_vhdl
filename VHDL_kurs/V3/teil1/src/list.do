onerror {resume}
add list -width 20 /simdemo_tb/clk_tb
add list /simdemo_tb/rst_tb
add list /simdemo_tb/testobjekt/reg1
add list /simdemo_tb/testobjekt/reg2
add list /simdemo_tb/testobjekt/nreg1
add list /simdemo_tb/out1_tb
add list /simdemo_tb/out2_tb
configure list -usestrobe 0
configure list -strobestart {0 ns} -strobeperiod {0 ns}
configure list -usesignaltrigger 1
configure list -delta all
configure list -signalnamewidth 0
configure list -datasetprefix 0
configure list -namelimit 10
