library verilog;
use verilog.vl_types.all;
entity jtag is
    port(
        internal_clk    : in     vl_logic;
        jtag_clk        : in     vl_logic;
        jtag_rstn       : in     vl_logic;
        jtag_mode       : in     vl_logic;
        jtag_digital_input: in     vl_logic;
        jtag_digital_output: out    vl_logic;
        jtag_GPIO_0_in  : in     vl_logic;
        jtag_GPIO_0_out : out    vl_logic;
        jtag_digital_core_clk: in     vl_logic
    );
end jtag;
