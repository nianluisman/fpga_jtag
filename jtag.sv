module jtag(
  	input logic internal_clk,
	input logic jtag_clk,
  	input logic jtag_rstn,
  	input logic jtag_mode,
  
  	input logic jtag_digital_input,
  	output logic jtag_digital_output,
  
  	input logic jtag_GPIO_0_in,
  	output logic jtag_GPIO_0_out,
	
  	input logic jtag_digital_core_clk,
	
	output logic [7:0] leds
);
  
///////////////////////////////////////////////////////////////////////
///
/////	interial veriables
///
///////////////////////////////////////////////////////////////////////
  
  /******************************
  		internal inputs signals
  ******************************/
 
    logic jtag_test_logic_reset;
  
  
    logic jtag_capture_dr;
    logic jtag_shift_dr; 
    logic jtag_update_dr;
  
    logic jtag_capture_ir;
    logic jtag_shift_ir;
    logic jtag_update_ir;
  
  
    logic jtag_scan_to_bsc_GPIO_0_in; 
    logic jtag_scan_GPIO_0_chain; 
  
  /*****************************
  		internal output singals
  *****************************/
  
    logic jtag_capture_bsc;
    logic jtag_shift_bsc;
    logic jtag_update_bsc;
    
    logic jtag_mode_bsc;

  	logic jtag_scan_from_bsc_GPIO_0_out;

  
  	logic jtag_digital_core_output; 
  	logic jtag_digital_core_input;
  


//////////////////////////////////////////////////////////////////////
///
// 		modules
//
/////////////////////////////////////////////////////////////////////
  
  
    /**********************************
  *									*
  * clock and signal sync 			*
  *									*					
  ***********************************/
  
    logic jtag_sync_test_clk;
  	logic jtag_sync_test_dig_clk;
  
  clock_sync#(.counter_threshold(127))
  synic_tclk
  (
    .internal_clk(internal_clk),
    .reset_n(jtag_rstn),
    .data_clk(jtag_clk),
    .clk_enable(jtag_sync_test_clk),
	 .leds()
  );
  
  clock_sync#(.counter_threshold(127))
  synic_dig_core_clk
  (
    	.internal_clk(internal_clk),
    	.reset_n(jtag_rstn),
    	.data_clk(jtag_digital_core_clk),
    	.clk_enable(jtag_sync_test_dig_clk),
		.leds(leds)
  );
 
  
   /**********************************
  *									*
  * tap controller					*
  *									*					
  ***********************************/
  
  tap_controller
  tap1(
    	.internal_clk  			(internal_clk),
    	.tap_clk_enable			(jtag_sync_test_clk),
    	.tap_rstn					(jtag_rstn),
    
    	.tap_test_logic_reset	(jtag_test_logic_reset),
    
    	.tap_mode					(jtag_mode),
    
    	.tap_capture_ir			(jtag_capture_ir),
    	.tap_shift_ir				(jtag_shift_ir),
    	.tap_update_ir				(jtag_update_ir),
    
    	.tap_capture_dr			(jtag_capture_dr),
    	.tap_shift_dr				(jtag_shift_dr),
    	.tap_update_dr				(jtag_update_dr)
	 );
  /**********************************
  *									*
  * Data registers 					*
  *									*					
  ***********************************/
  
    data_registers 
    data_reg2(
      	.internal_clk  				(internal_clk),
			.reg_tck_enable					(jtag_sync_test_clk),
			.reg_trstn						(jtag_rstn),
      
      	.reg_test_logic_reset		(jtag_test_logic_reset),
      
      	.reg_digital_input			(jtag_digital_input),
      	.reg_digital_output			(jtag_digital_output),

      	.reg_capture_dr				(jtag_capture_dr),
      	.reg_shift_dr				(jtag_shift_dr),
      	.reg_update_dr				(jtag_update_dr),

      	.reg_capture_bsc			(jtag_capture_bsc),
      	.reg_shift_bsc				(jtag_shift_bsc),
      	.reg_update_bsc				(jtag_update_bsc),

      	.reg_capture_ir				(jtag_capture_ir),
      	.reg_shift_ir				(jtag_shift_ir),
      	.reg_update_ir				(jtag_update_ir),

      	.reg_mode					(jtag_mode),
      	.reg_mode_bsc				(jtag_mode_bsc),

      	.reg_scan_from_bsc			(jtag_scan_from_bsc_GPIO_0_out),
      	.reg_scan_to_bsc			(jtag_scan_to_bsc_GPIO_0_in)
      	
    );
  /**********************************
  *									*
  * BSC GPIO 0 in 					*
  *									*					
  ***********************************/
  
  
    boundary_scan_cell#(.bsc_res_val (1'b0))
    bsc_in_0(
      .internal_clk  			(internal_clk),
      .bsc_tck_enable			(jtag_sync_test_clk),
      .bsc_reset_n 				(jtag_rstn),
      .bsc_test_logic_reset 	(jtag_test_logic_reset),

      .bsc_capture				(jtag_capture_bsc),
      .bsc_shift_data			(jtag_shift_bsc),
      .bsc_update				(jtag_update_bsc),

      .bsc_mode					(jtag_mode_bsc),

      .bsc_scan_in				(jtag_scan_to_bsc_GPIO_0_in),
      .bsc_scan_out				(jtag_scan_GPIO_0_chain),

      .bsc_ex_digital_input		(jtag_GPIO_0_in),
      .bsc_ex_digital_output	(jtag_digital_core_input)
    );
  
  /**********************************
  *									*
  * BSC GPIO 0 out 					*
  *									*					
  ***********************************/
      boundary_scan_cell#(.bsc_res_val (1'b0))
    	bsc_out_0_1(
          	.internal_clk  			(internal_clk),
      		.bsc_tck_enable			(jtag_sync_test_clk),
      		.bsc_reset_n 			(jtag_rstn),
      		.bsc_test_logic_reset 	(jtag_test_logic_reset),

      		.bsc_capture			(jtag_capture_bsc),
      		.bsc_shift_data			(jtag_shift_bsc),
      		.bsc_update				(jtag_update_bsc),

      		.bsc_mode				(jtag_mode_bsc),

          	.bsc_scan_in			(jtag_scan_GPIO_0_chain),
          	.bsc_scan_out			(jtag_scan_from_bsc_GPIO_0_out),

      		.bsc_ex_digital_input	(jtag_digital_core_output),
          	.bsc_ex_digital_output	(jtag_GPIO_0_out)
    );
  //////////////////////////////////////////////////////////////
  ///
  ///	internal logic core (just a simple 4 bit shift reg)
  //
  /////////////////////////////////////////////////////////////
  
    digital_core
    digital_core_1(
      .internal_clk  			(internal_clk),
      .dc_clk_enable			(jtag_sync_test_dig_clk),
      .dc_rstn					(jtag_rstn),
      .dc_digital_input			(jtag_digital_core_input),
      .dc_digital_output		(jtag_digital_core_output)
    );
	 
  
endmodule