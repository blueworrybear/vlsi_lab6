source .synopsys_dc.setup

analyze -format verilog {alu.v shifter.v datapath.v barrel_shifter.v fu2.v}
elaborate fu2 -architecture verilog -library DEFAULT

source fu2.dc

check_design
compile -exact_map
write -format verilog -hierarchy -output fu2_syn.v
write_sdf -version 1.0 -context verilog fu2.sdf

#clock report
read_sdf fu2.sdf
report_clock > clock.rpt
#report_port -input_delay >> clock.rpt
#report_port -output_delay >> clock.rpt
#check_timing >> clock.rpt

#timing report
report_timing > timing.rpt
report_timing -nets -transition_time -capacitance >> timing.rpt
#remove_design -all
#remove_lib -all
exit
