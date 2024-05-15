module input_sync
  (
    	input logic in_sync_in_signal,
    	input logic in_sync_rstn,
	 	input logic in_sync_internal_clk,
	 	output logic in_sync_out_signal
  );
  
  logic[2:0] synic_register = 3'b0;
	
 
  always_ff @(posedge in_sync_internal_clk or negedge in_sync_rstn) begin
    if (!in_sync_rstn) synic_register <= 3'd0;
    	else         synic_register <= {synic_register[1:0], in_sync_in_signal};
	end
  	always_comb in_sync_out_signal = synic_register[2];
endmodule 