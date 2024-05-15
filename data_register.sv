`include "./tab_defines.sv"

`timescale 1 ns / 1 ns

    //***********************************************************************************
    /// <<<<<<<<<<<<<<<<<<           instrutions      >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 
    //***********************************************************************************

    //	SAMPLE:  select the boundary scan cells get SCAN OUT data to TDO.
    // 	IDEL_SCAN:  the default state. Do nothing. 
    // 	BYPASS: conntect Digital input to the TDO.
    //	INTEST: Send the DUT data to the BSC and connect the ouput to de TDO.
    //	EXTEST: select the boundary scan cells get Data out to digital output. 
  


  

  
module data_registers(
  	  input logic 	internal_clk,
  	  input logic   reg_tck_enable, 
      input logic   reg_trstn,
  	  input logic	reg_test_logic_reset,
      
     
      input logic 	reg_digital_input,
  	  output logic 	reg_digital_output,
      

      input reg 	reg_capture_dr,
      input reg 	reg_shift_dr,
      input reg 	reg_update_dr,

      output reg 	reg_capture_bsc,
      output reg 	reg_shift_bsc,
      output reg	reg_update_bsc,

      input reg 	reg_capture_ir,
      input reg 	reg_shift_ir,
      input reg 	reg_update_ir,
  
  
   	  input logic	reg_mode,
  	  output logic  reg_mode_bsc,
  
  	  output reg 	reg_scan_to_bsc,
  	  input reg 	reg_scan_from_bsc

);
  
   
  typedef enum logic[3:0] { 			SAMPLE = 	4'h8, 
                                		BYPASS = 	4'hf,
                               		IDCODE =  	4'h0,
                                		EXTEST = 	4'h3} 
      	data_opcode_dr;
			
  	/////////////////////////////////////////////////////////////////
  	//
  	// 	 internal variables data register
  	//
  	//////////////////////////////////////////////////////////////////
  	
  
   logic 			reg_bypassed_tdo = 0; // This is a 1-bit register
  
  	logic [`IR_LENGTH-1:0]  	reg_jtag_shift_ir = `IR_LENGTH'b0;          	// Instruction register    
  	logic [`IR_LENGTH-1:0] 		reg_jtag_hold_ir = `IR_LENGTH'b0;				//hold instudtion after update
  
    

   logic 				reg_idcode_tdo = 0;
  	logic [31:0] 		reg_idcode_ir = 32'd0; 
	
	logic  				reg_instruction_tdo = 0;
  
  /////////////////////////////////////////////////////////////////
  //
  //  logic data registers 
  // 
  /////////////////////////////////////////////////////////////////

  
		
  
  
    /**********************************************************************************
    *                                                                                 *
    *   jtag_ir:  JTAG Instruction Register                                           *
    *                                                                                 *
    **********************************************************************************/
 
    always_ff @ (posedge internal_clk or negedge reg_trstn)
        begin
          if(!reg_trstn)
            reg_jtag_shift_ir[`IR_LENGTH-1:0] <= 1;
          else if(reg_tck_enable == 1) begin
            if (reg_test_logic_reset == 1)
              reg_jtag_shift_ir[`IR_LENGTH-1:0] <=  1;
            else if(reg_capture_ir)
              reg_jtag_shift_ir <=  4'b0101;
            else if(reg_shift_ir)
              reg_jtag_shift_ir[`IR_LENGTH-1:0] <=  {reg_digital_input, reg_jtag_shift_ir[`IR_LENGTH-1:1]};
          end        
         end

        always_comb begin
				reg_instruction_tdo <= reg_jtag_shift_ir[0];
		  end  

        // Updating jtag_ir (Instruction Register)
    always_ff @ (posedge internal_clk or negedge reg_trstn)
        begin
          if(!reg_trstn)
            reg_jtag_hold_ir <= 1;   // IDCODE selected after reset
          else if(reg_tck_enable == 1) begin
            if (reg_test_logic_reset)
              reg_jtag_hold_ir <= 1;   // IDCODE selected after reset
            else if(reg_update_ir)
              reg_jtag_hold_ir <= reg_jtag_shift_ir;
          end
         end

  
  
  
    /**********************************************************************************
    *                                                                                 *
    *   idcode logic                                                                  *
    *                                                                                 *
    **********************************************************************************/

    always_ff @ (posedge internal_clk or negedge reg_trstn) 
      begin
          if(!reg_trstn)
            reg_idcode_ir <= 32'b0;   // IDCODE selected after reset
        else if(reg_tck_enable == 1) begin
            if (reg_test_logic_reset)
              reg_idcode_ir <= 32'b0;   // IDCODE selected after reset
            else if(reg_jtag_hold_ir == IDCODE  & reg_capture_dr)
              reg_idcode_ir <= `IDCODE_VALUE;
            else if(reg_jtag_hold_ir == IDCODE & reg_shift_dr)
              reg_idcode_ir <= {reg_digital_input, reg_idcode_ir[31:1]};
        end
       end

      always_comb begin
				reg_idcode_tdo <= reg_idcode_ir[0];
		end
    /****************************************************************************************
    *																						*
    *							<<<< by pass >>>>											*
    *																						*
    *****************************************************************************************/

    always_ff @ (posedge internal_clk or negedge reg_trstn)
        begin
          if (!reg_trstn)
             reg_bypassed_tdo <= 1'b0;
          else if(reg_tck_enable == 1) begin
              if (reg_test_logic_reset == 1)
                 reg_bypassed_tdo <=  1'b0;
              else if (reg_jtag_hold_ir == BYPASS & reg_capture_dr)
                reg_bypassed_tdo	<= 1'b0;
              else if(reg_jtag_hold_ir == BYPASS & reg_shift_dr)
                reg_bypassed_tdo	<= reg_digital_input;
        	end
        end


  
  	/***********************************************************************************
     *                                                                                  *
     *        control signals boundary scan                                             * 
     *                                                                                  *                  
     ***********************************************************************************/

     	always_comb
      begin
        if(reg_jtag_hold_ir == EXTEST)
          	reg_mode_bsc = 1;
			else 
				reg_mode_bsc = 0; //moet de bsc van transparent mode fallen tijdens een reset in EXTEST?  
        if(reg_jtag_hold_ir == SAMPLE || reg_jtag_hold_ir == EXTEST )begin 
          	reg_scan_to_bsc = reg_digital_input;        
           	reg_capture_bsc = reg_capture_dr;
          	reg_shift_bsc = reg_shift_dr;
            reg_update_bsc = reg_update_dr; 
          end else begin
            reg_shift_bsc = 1'b0;
            reg_capture_bsc = 1'b0;
            reg_update_bsc = 1'b0; 
            reg_scan_to_bsc = 1'b0;
            reg_mode_bsc = 1'b0;
          end 
      end 




    /********************************************************
    *														*
    *			  multiplexer to output						*
    *														*
    ********************************************************/

     always_comb
        begin

          if(reg_shift_ir)
                reg_digital_output = reg_instruction_tdo;
          // bypass_select = 1'b0; 
          else begin 
          case(reg_jtag_hold_ir)
            	SAMPLE:  reg_digital_output <= reg_scan_from_bsc;

               BYPASS: reg_digital_output <= reg_bypassed_tdo;       
				
            		
            
            	EXTEST: reg_digital_output <= reg_scan_from_bsc;
            	
            	IDCODE: reg_digital_output <= reg_idcode_tdo;
            
            

            default:   	reg_digital_output <= 1'b0;
            endcase
          end 
        end 

endmodule 