source .synopsys_dc.setup

analyze -format verilog {header.v alu.v shifter.v fu.v}
elaborate fu -architecture verilog -library DEFAULT

source fu.dc

check_design
compile -exact_map
write -format verilog -hierarchy -output fu_syn.v
write_sdf -version 1.0 -context verilog fu.sdf

#clock report
read_sdf fu.sdf
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
