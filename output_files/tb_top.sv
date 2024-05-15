
`timescale 1ps/1ps


/////////////////////////////////////////////////////////////////////////////
// 
// Execute test logic reset
// 
/////////////////////////////////////////////////////////////////////////////
task automatic test_logic_reset(ref logic tck, tms, tdi);
  @ (negedge tck) tms = 1;
  @ (negedge tck) tms = 1;
  @ (negedge tck) tms = 1;
  @ (negedge tck) tms = 1;
  @ (negedge tck) tms = 1;
  @ (negedge tck) tms = 0; tdi = 0; // Enter idle
endtask




/////////////////////////////////////////////////////////////////////////////
// 
// Set instructions
// 
/////////////////////////////////////////////////////////////////////////////
task automatic set_ir_reg_instr(ref logic tck, tms, tdi, ref logic [3:0] instr);
  @ (negedge tck) tms = 1; // Enter select_dr_scan
  @ (negedge tck) tms = 1; // Enter select_ir_scan
  @ (negedge tck) tms = 0; // Enter capture_ir
  @ (negedge tck) tms = 0; tdi = instr[0]; // shift_ir
  @ (negedge tck) tms = 0; tdi = instr[1]; // shift_ir
  @ (negedge tck) tms = 0; tdi = instr[2]; // shift_ir
  @ (negedge tck) tms = 0; tdi = instr[3]; // shift_ir
  @ (negedge tck) tms = 1; // Enter exit1_ir
  @ (negedge tck) tms = 1; // Enter update_ir
  @ (negedge tck) tms = 0; tdi = 0; // Enter idle
endtask




/////////////////////////////////////////////////////////////////////////////
// 
// Shift data
// 
/////////////////////////////////////////////////////////////////////////////
task automatic shift_normal_data(ref logic tck, tms, tdi, int nmbr);
  @ (negedge tck) tms = 1; // Enter select_dr_scan
  @ (negedge tck) tms = 0; // Enter capture_dr
  //if (nmbr > 0)
    for (int i = 0; i < nmbr; i++)
      @ (negedge tck) tms = 0; tdi = 0; // shift_dr
  @ (negedge tck) tms = 1; // Enter exit1_dr
  @ (negedge tck) tms = 1; // Enter update_dr
  @ (negedge tck) tms = 0; tdi = 0; // Enter idle
endtask


task automatic shift_toggle_data(ref logic tck, tms, tdi, int nmbr);
  @ (negedge tck) tms = 1; // Enter select_dr_scan
  @ (negedge tck) tms = 0; // Enter capture_dr
  for (int i = 0; i < nmbr; i++) begin
    @ (negedge tck) tms = 0; tdi = 0; // shift_dr
    @ (negedge tck) tms = 0; tdi = 1; // shift_dr
  end
  @ (negedge tck) tms = 1; // Enter exit1_dr
  @ (negedge tck) tms = 1; // Enter update_dr
  @ (negedge tck) tms = 0; tdi = 0; // Enter idle
endtask


module tb_top();
  	logic internal_clk = 0;
  
    const time half_time = 150ns;
  
///////////////////////////////////////////////////////////////////////
///// 
////// 	inputs
////
//////////////////////////////////////////////////////////////////////
  
    logic tck = 0;
  	logic digital_core_clk  = 0;

    logic trst_n = 0;
  
    logic tdi = 0;
  
  	logic mode = 1;
  
   	logic ex_data_in = 0;

  
  
  ///////////////////////////////////////////////////////////////////////
///// 
//////// 	outputs
////
//////////////////////////////////////////////////////////////////////

    logic digital_output;
	logic ex_data_out;

  
/////////////////////////////////////////////////////////////////////
///
///  internal  signal variables
//
//////////////////////////////////////////////////////////////////////
   logic [3:0] instr = 0;
   int         iter = 0;

////////////////////////////////////////////////////////////////////////
///
///		signals/process 
///
////////////////////////////////////////////////////////////////////////
  
    
  	/********************************
    *
    * clock 
    *
    *********************************/
		always #400ns tck =  ~tck;
		always #335ns digital_core_clk =  ~digital_core_clk;
		always #10ns internal_clk = ~internal_clk;
  
  
  
     initial begin
           	trst_n = 0;
    		#145ns trst_n = 1;
 	 end
  
 
  
  
  always begin
    wait (trst_n);
    @ (negedge digital_core_clk); ex_data_in = 1;
    @ (negedge digital_core_clk); ex_data_in = 0;
    @ (negedge digital_core_clk); ex_data_in = 0;
    @ (negedge digital_core_clk); ex_data_in = 1;
    @ (negedge digital_core_clk); ex_data_in = 1;
    @ (negedge digital_core_clk); ex_data_in = 0;
    @ (negedge digital_core_clk); ex_data_in = 0;
    @ (negedge digital_core_clk); ex_data_in = 0;
    @ (negedge digital_core_clk); ex_data_in = 1;
    @ (negedge digital_core_clk); ex_data_in = 1;
    @ (negedge digital_core_clk); ex_data_in = 1;
    @ (negedge digital_core_clk); ex_data_in = 0;
  end


 
    

  initial begin 
//     /**********************
//     *
//     * test id code. 
//     *
//     **********************/
    instr = 4'h0; iter = 32;
    test_logic_reset  (tck, mode, tdi);
    set_ir_reg_instr  (tck, mode, tdi, instr);
    shift_normal_data (tck, mode, tdi, iter);

    /************************
    *						*
    * test bypass register	*
    *************************/
 //   instr = 4'hF; iter = 4;
  //  test_logic_reset  (tck, mode, tdi);
  //  set_ir_reg_instr  (tck, mode, tdi, instr);
   // shift_toggle_data (tck, mode, tdi, iter);
  
//     /********************
//     *					*
//     *	test sample		*
//     *					*
//     *******************/
    
 //   instr = 4'h8; iter = 2;
 //   test_logic_reset  (tck, mode, tdi);
 //   set_ir_reg_instr  (tck, mode, tdi, instr);
 //   shift_normal_data (tck, mode, tdi, iter); // Sample #1
  //  shift_normal_data (tck, mode, tdi, iter); // Sample #2
  //  shift_normal_data (tck, mode, tdi, iter); // Sample #3
  //  shift_normal_data (tck, mode, tdi, iter); // Sample #4
    
//     /**********************
//     *
//     * test id code. 
//     *
//     **********************/
  //  instr = 4'h0; iter = 32;
  //  test_logic_reset  (tck, mode, tdi);
   // set_ir_reg_instr  (tck, mode, tdi, instr);
   // shift_normal_data (tck, mode, tdi, iter);
    
    
//     /********************
//     *					*
//     *	test extest 0	*
//     *					*
//     *******************/
 //   instr = 4'h3; iter = 0;
  //  test_logic_reset  (tck, mode, tdi);
  //  set_ir_reg_instr  (tck, mode, tdi, instr);
  //  shift_normal_data (tck, mode, tdi, iter); // Extest #1
   // shift_normal_data (tck, mode, tdi, iter); // Extest #2
   // shift_normal_data (tck, mode, tdi, iter); // Extest #3
   // shift_normal_data (tck, mode, tdi, iter); // Extest #4
    
//         /********************
//     *					*
//     *	test extest	1	*
//     *					*
//     *******************/
  //  instr = 4'h3; iter = 1;
  //  test_logic_reset  (tck, mode, tdi);
   // set_ir_reg_instr  (tck, mode, tdi, instr);
   // shift_normal_data (tck, mode, tdi, iter); // Extest #1
   // shift_normal_data (tck, mode, tdi, iter); // Extest #2
   // shift_normal_data (tck, mode, tdi, iter); // Extest #3
   // shift_normal_data (tck, mode, tdi, iter); // Extest #4
    
    
//     /********************
//     *					*
//     *	test extest	2	*
//     *					*
//     *******************/
   // instr = 4'h3; iter = 2;
   // test_logic_reset  (tck, mode, tdi);
   // set_ir_reg_instr  (tck, mode, tdi, instr);
   // shift_normal_data (tck, mode, tdi, iter); // Extest #1
   // shift_normal_data (tck, mode, tdi, iter); // Extest #2
   // shift_normal_data (tck, mode, tdi, iter); // Extest #3
    //shift_normal_data (tck, mode, tdi, iter); // Extest #4
    
  end 
  
  jtag
  jtag_0(
    .internal_clk(internal_clk),
    .jtag_clk(tck),
    .jtag_rstn(trst_n),
    .jtag_mode(mode),
    .jtag_digital_input(tdi),
    .jtag_digital_output(digital_output),
    .jtag_GPIO_0_in(ex_data_in),
    .jtag_GPIO_0_out(ex_data_out),
    .jtag_digital_core_clk(digital_core_clk)
  );

  /////////////////////////////////////////////////////
  ////
  ///// 	test assertions 
  ////
  /////////////////////////////////////////////////////
  

  	//bind tb_top.jtag_0.bsc_in_0 assertion_bsc#(.bsc_res_val(1'b0))	tb_bsc_in_assetions(.*);
 	//bind tb_top.jtag_0.bsc_out_0_1 		  	assertion_bsc#()	tb_bsc_out_assetions(.*);
 	//bind tb_top.jtag_0.tap1 		  			assertion_tap#()	tb_tap_assetions(.*);
	//bind tb_top.jtag_0.data_reg2 	assertions_data_reg#()	   tb_data_reg_assetions(.*);


  //some deviders for the wave files.
  //logic dev_jtag_top = 1'bx; 
  //logic dev_bsc = 1'bx;
  //logic dev_data_reg = 1'bx;
  //logic dev_core = 1'bx;

 
  
  //dump the signals in to wave file. 

   // Dump waves
    initial begin
      //$asserton;
      //$dumpfile("dump.vcd");
     // $dumpvars(1);
      #40000ns;
      $stop;  
    end
	//initial #20000ns $finish
  
  
endmodule