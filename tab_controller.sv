  typedef enum reg[3:0] {RESET,			IDEL, 
                         SELECT_DR, 	CAPTURE_DR, 
              			 SHIFT_DR, 		EXTIT1_DR, 
                         PAUSE_DR,		EXIT2_DR, 
                         UPDATE_DR,		SELECT_IR,   
                         CAPTURE_IR,	SHIFT_IR,
                         EXIT1_IR, 		PAUSE_IR,
                         EXIT2_IR, 		UPDATE_IR} states;


module tap_controller
(
  		input logic internal_clk,
		input logic tap_clk_enable,
  		input logic tap_rstn,
  
  		input logic tap_mode,
  		
  		output logic tap_test_logic_reset,
  		
  		output logic tap_capture_ir,
  		output logic tap_shift_ir,
 		output logic tap_update_ir,
  
  		output logic tap_capture_dr,
  		output logic tap_shift_dr,
  		output logic tap_update_dr
);
  
    /*******************************
  	internal state machine variables 
  **********************************/
  	states 	tap_cur_state = RESET; 
  	states tap_next_state; 
  
  //////////////////////////////////////////////////////////////////////
///
// 		tap controller state machine 
//
/////////////////////////////////////////////////////////////////////
  
  always_ff @ (posedge internal_clk or negedge tap_rstn)
begin
  if(tap_rstn == 0)
		tap_cur_state = RESET;
  else if(tap_clk_enable == 1)
		tap_cur_state = tap_next_state;
end
  
  always_comb
    begin
      //BYPASS: reg_digital_output = (reg_shift_dr) ? reg_bypassed_tdo  : 1'b0;
      case(tap_cur_state)
        RESET: 			tap_next_state = (tap_mode) ? RESET : IDEL;
        IDEL: 			tap_next_state = (tap_mode) ? SELECT_DR : IDEL;
        SELECT_DR: 		tap_next_state = (tap_mode) ? SELECT_IR : CAPTURE_DR;
        CAPTURE_DR: 	tap_next_state = (tap_mode) ? EXTIT1_DR : SHIFT_DR;
        SHIFT_DR: 		tap_next_state = (tap_mode) ? EXTIT1_DR : SHIFT_DR;
        EXTIT1_DR:		tap_next_state = (tap_mode) ? UPDATE_DR : PAUSE_DR;
        PAUSE_DR:		tap_next_state = (tap_mode) ? EXIT2_DR : PAUSE_DR;
        EXIT2_DR:		tap_next_state = (tap_mode) ? UPDATE_DR : SHIFT_DR;
        UPDATE_DR:		tap_next_state = (tap_mode) ? SELECT_DR : IDEL;
        SELECT_IR:		tap_next_state = (tap_mode) ? RESET : CAPTURE_IR;
        CAPTURE_IR:		tap_next_state = (tap_mode) ? EXIT1_IR : SHIFT_IR;
        SHIFT_IR:		tap_next_state = (tap_mode) ? EXIT1_IR : SHIFT_IR;
        EXIT1_IR:		tap_next_state = (tap_mode) ? UPDATE_IR : PAUSE_IR;
        PAUSE_IR:		tap_next_state = (tap_mode) ? EXIT2_IR : PAUSE_IR;
        EXIT2_IR:		tap_next_state = (tap_mode) ? UPDATE_IR : SHIFT_IR;
        UPDATE_IR:		tap_next_state = (tap_mode) ? SELECT_DR : IDEL;
		default: 		tap_next_state = RESET;
	endcase
    end 
  
    always_comb
        begin
                                tap_test_logic_reset = 1'b0;
          
                                tap_capture_dr = 1'b0;
                                tap_shift_dr = 1'b0;
                                tap_update_dr = 1'b0;
          
                                tap_capture_ir = 1'b0;
                                tap_shift_ir = 1'b0;
                                tap_update_ir = 1'b0;

          case(tap_next_state)
            RESET: 				tap_test_logic_reset = 1'b1;
          
            CAPTURE_DR:       	tap_capture_dr = 	1'b1;
            SHIFT_DR:         	tap_shift_dr = 1'b1;
            UPDATE_DR:        	tap_update_dr = 1'b1;
          
            CAPTURE_IR:       	tap_capture_ir = 1'b1;
            SHIFT_IR:         	tap_shift_ir = 1'b1;
            UPDATE_IR:        	tap_update_ir = 1'b1;
            default: 			tap_test_logic_reset = 1'b0;
        endcase
    end
endmodule 