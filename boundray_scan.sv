module boundary_scan_cell #( bit bsc_res_val = 1'b0)
  ( 
    // Clock
    input logic bsc_tck_enable,
    input logic internal_clk,
    // Reset signals
    input logic bsc_reset_n,
    input logic bsc_test_logic_reset,
   
    // Control signals
    input logic bsc_capture,
    input logic bsc_shift_data,
    input logic bsc_update,
    // Select signals
    input logic bsc_mode,
    // Data signals
    input logic bsc_scan_in,
    output logic bsc_scan_out,

    input logic bsc_ex_digital_input,
   	output logic bsc_ex_digital_output
  );
  logic bsc_hold_data = 0;
  
  always_ff @ ( posedge internal_clk or negedge bsc_reset_n) begin
    if (!bsc_reset_n)   //moet de bsc niet gereset naar 0 geschreven worden tijdens een logic reset? 
		begin 	 
			bsc_scan_out <= bsc_res_val;
		end 
    else if(bsc_tck_enable == 1)
	 begin
		if(bsc_test_logic_reset) 				bsc_scan_out <= bsc_res_val;
      else if(bsc_shift_data)          	bsc_scan_out <= bsc_scan_in;
      else if(bsc_capture)             	bsc_scan_out <= bsc_ex_digital_input;
      else 											bsc_scan_out <= bsc_scan_out;
    end  
  end

  
  always_ff @ ( posedge internal_clk or negedge bsc_reset_n) begin
    if (!bsc_reset_n) 
     		 bsc_hold_data <= bsc_res_val;
    else if(bsc_tck_enable == 1) 
		 if( bsc_test_logic_reset) bsc_hold_data <= bsc_res_val;
		 else if (bsc_update)      bsc_hold_data <= bsc_scan_out;
		 else                      bsc_hold_data <= bsc_hold_data;
	end
  
  
  
  always_comb begin
    if(!bsc_mode) 
       bsc_ex_digital_output <= bsc_ex_digital_input;
     else 
       bsc_ex_digital_output <= bsc_hold_data;
  end
endmodule