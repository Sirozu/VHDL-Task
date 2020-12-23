set_property PACKAGE_PIN N11 [get_ports clk_tx]
set_property PACKAGE_PIN N16 [get_ports mdc]
set_property PACKAGE_PIN P15 [get_ports mdio]
set_property PACKAGE_PIN L14 [get_ports rmii_txen]
set_property PACKAGE_PIN N4 [get_ports rst_hw]

set_property PACKAGE_PIN R13 [get_ports {rmii_tx[0]}]
set_property PACKAGE_PIN T12 [get_ports {rmii_tx[1]}]

set_property IOSTANDARD LVCMOS33 [get_ports {rmii_tx[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {rmii_tx[0]}]

set_property IOSTANDARD LVCMOS33 [get_ports clk_tx]
set_property IOSTANDARD LVCMOS33 [get_ports mdc]
set_property IOSTANDARD LVCMOS33 [get_ports mdio]
set_property IOSTANDARD LVCMOS33 [get_ports rst_hw]
set_property IOSTANDARD LVCMOS33 [get_ports rmii_txen]

