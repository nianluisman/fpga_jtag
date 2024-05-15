library verilog;
use verilog.vl_types.all;
entity input_sync is
    port(
        in_sync_in_signal: in     vl_logic;
        in_sync_rstn    : in     vl_logic;
        in_sync_internal_clk: in     vl_logic;
        in_sync_out_signal: out    vl_logic
    );
end input_sync;
