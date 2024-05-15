library verilog;
use verilog.vl_types.all;
entity clock_sync is
    port(
        dig_clk         : in     vl_logic;
        rstn            : in     vl_logic;
        internal_clk    : in     vl_logic;
        clk_enable      : out    vl_logic
    );
end clock_sync;
