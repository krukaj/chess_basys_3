## Constraints for CLK
# set_property PACKAGE_PIN W5 [get_ports clk]
# set_property IOSTANDARD LVCMOS33 [get_ports clk]
# ## create_clock -name external_clock -period 10.00 [get_ports clk]
# create_clock -period 10.000 [get_ports clk]
# set_input_jitter [get_clocks -of_objects [get_ports clk]] 0.1
# set_false_path -to [get_cells  -hier {*seq_reg*[0]} -filter {is_sequential}]
# set_property PHASESHIFT_MODE WAVEFORM [get_cells -hierarchical *adv*]

set_property PACKAGE_PIN W5 [get_ports clk]							
	set_property IOSTANDARD LVCMOS33 [get_ports clk]
	create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports clk]

# Buttons
set_property PACKAGE_PIN U18 [get_ports {BtnC}]						
	set_property IOSTANDARD LVCMOS33 [get_ports {BtnC}]
set_property PACKAGE_PIN T18 [get_ports {BtnU}]						
	set_property IOSTANDARD LVCMOS33 [get_ports {BtnU}]
set_property PACKAGE_PIN W19 [get_ports {BtnL}]						
	set_property IOSTANDARD LVCMOS33 [get_ports {BtnL}]
set_property PACKAGE_PIN T17 [get_ports {BtnR}]						
	set_property IOSTANDARD LVCMOS33 [get_ports {BtnR}]
set_property PACKAGE_PIN U17 [get_ports {BtnD}]						
	set_property IOSTANDARD LVCMOS33 [get_ports {BtnD}]

## Switches
set_property PACKAGE_PIN V17 [get_ports {rst}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {rst}]

## Constraints for VS and HS
set_property PACKAGE_PIN R19 [get_ports {vga_vsync}]
set_property IOSTANDARD LVCMOS33 [get_ports {vga_vsync}]
set_property PACKAGE_PIN P19 [get_ports {vga_hsync}]
set_property IOSTANDARD LVCMOS33 [get_ports {vga_hsync}]

## Constraints for RED
# set_property PACKAGE_PIN G19 [get_ports {vga_r0}]
# set_property IOSTANDARD LVCMOS33 [get_ports {vga_r0}]
set_property PACKAGE_PIN N19 [get_ports {vga_r[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {vga_r[0]}]
set_property PACKAGE_PIN J19 [get_ports {vga_r[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {vga_r[1]}]
set_property PACKAGE_PIN H19 [get_ports {vga_r[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {vga_r[2]}]

## Constraints for GRN
# set_property PACKAGE_PIN J17 [get_ports {g[0]}]
# set_property IOSTANDARD LVCMOS33 [get_ports {g[0]}]
set_property PACKAGE_PIN D17 [get_ports {vga_g[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {vga_g[0]}]
set_property PACKAGE_PIN G17 [get_ports {vga_g[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {vga_g[1]}]
set_property PACKAGE_PIN H17 [get_ports {vga_g[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {vga_g[2]}]

## Constraints for BLU
# set_property PACKAGE_PIN N18 [get_ports {b[0]}]
# set_property IOSTANDARD LVCMOS33 [get_ports {b[0]}]
# set_property PACKAGE_PIN L18 [get_ports {b[1]}]
# set_property IOSTANDARD LVCMOS33 [get_ports {b[1]}]
set_property PACKAGE_PIN J18 [get_ports {vga_b[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {vga_b[0]}]
set_property PACKAGE_PIN K18 [get_ports {vga_b[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {vga_b[1]}]

## Constraints for CFGBVS
set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]


