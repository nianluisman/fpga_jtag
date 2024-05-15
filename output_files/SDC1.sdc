# Set the time format
set_time_format -unit ns -decimal_places 3

# Create clocks
create_clock -period 20 [get_ports internal_clk]

## Constrain the input I/O paths for each clock
set_input_delay -clock internal_clk -max 3 [all_inputs] 	-add_delay
set_input_delay -clock internal_clk -min 2 [all_inputs]	-add_delay

# Constrain the output I/O paths for each clock
set_output_delay -clock internal_clk -max 3 [all_outputs]	-add_delay
set_output_delay -clock internal_clk -min 2 [all_outputs]	-add_delay

set_clock_uncertainty -from internal_clk -to internal_clk 1ns