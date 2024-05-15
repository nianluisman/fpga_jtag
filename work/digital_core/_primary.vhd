library verilog;
use verilog.vl_types.all;
entity digital_core is
    port(
        dc_clk          : in     vl_logic;
        dc_rstn         : in     vl_logic;
        dc_digital_input: in     vl_logic;
        dc_digital_output: out    vl_logic
    );
end digital_core;
