set_property PACKAGE_PIN N11 [get_ports clk]
set_property PACKAGE_PIN L5 [get_ports led]



set_property IOSTANDARD LVCMOS33 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports led]

create_clock -period 5.000 -name myclk -waveform {0.000 2.500} -add [get_ports clk]

set_property CONFIG_VOLTAGE 3.3 [current_design]
set_property CFGBVS VCCO [current_design]

# Set the bank voltage for IO Bank 14 to 3.3V by default.
#set_property IOSTANDARD LVCMOS33 [get_ports -of_objects [get_iobanks 14]];
# Set the bank voltage for IO Bank 34 to 3.3V by default.
#set_property IOSTANDARD LVCMOS33 [get_ports -of_objects [get_iobanks 34]];
# Set the bank voltage for IO Bank 35 to 3.3V by default.
#set_property IOSTANDARD LVCMOS33 [get_ports -of_objects [get_iobanks 35]];