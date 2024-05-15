module digital_core(
 	input logic internal_clk,
    input logic dc_clk_enable,
  	input logic dc_rstn,
    input logic dc_digital_input,
    output logic dc_digital_output
);
  
  
  logic [2:0] dc_register = 3'b0;
  
  always_ff @(posedge internal_clk or negedge dc_rstn) begin
    if (!dc_rstn)  dc_register <= 3'b0;
    else if(dc_clk_enable == 1)         dc_register <= {dc_register[1:0], dc_digital_input};
  end
  
	always_comb begin
		dc_digital_output <= dc_register[2];
	end
  
endmodule 