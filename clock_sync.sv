// Code your design here
module clock_sync
  # ( int   counter_threshold = 6
) ( input  logic internal_clk,
    input  logic reset_n,
    input  logic data_clk,
    output logic clk_enable,
	 output logic [7:0] leds
  );
  logic       clk_stable;
  logic       clk_stable_reg;
  logic [7:0] counter_high;
  logic [4:0] counter_low;
  
  always_ff @ (posedge internal_clk or negedge reset_n)
    if      (!reset_n)  counter_low <= 5'b0;
    else if (!data_clk) counter_low <= counter_low + (counter_low < 5'd15);
    else                counter_low <= 5'b0;
	 
  always_ff @ (posedge internal_clk or negedge reset_n)
    if      (!reset_n)             counter_high <= 8'b0;
    else if (data_clk)             counter_high <= counter_high + (counter_high < counter_threshold);
    else if (counter_low >= 5'd15)  counter_high <= 8'b0;
	 
	 
  assign clk_stable = counter_high == counter_threshold;
  always_ff @ (posedge internal_clk or negedge reset_n)
    if (!reset_n) clk_stable_reg <= 1'b0;
    else          clk_stable_reg <= clk_stable;
  
  assign clk_enable = clk_stable & !clk_stable_reg;
 
 
  always_ff @ (posedge internal_clk or negedge reset_n)
    if      (!reset_n) leds <= 8'b0;
    else if (clk_enable) leds <= leds + 1'b1;
endmodule

