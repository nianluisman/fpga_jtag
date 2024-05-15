library verilog;
use verilog.vl_types.all;
entity tap_controller is
    port(
        tap_clk         : in     vl_logic;
        tap_rstn        : in     vl_logic;
        tap_mode        : in     vl_logic;
        tap_test_logic_reset: out    vl_logic;
        tap_capture_ir  : out    vl_logic;
        tap_shift_ir    : out    vl_logic;
        tap_update_ir   : out    vl_logic;
        tap_capture_dr  : out    vl_logic;
        tap_shift_dr    : out    vl_logic;
        tap_update_dr   : out    vl_logic
    );
end tap_controller;
