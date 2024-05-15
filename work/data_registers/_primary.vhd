library verilog;
use verilog.vl_types.all;
entity data_registers is
    port(
        reg_tck         : in     vl_logic;
        reg_trstn       : in     vl_logic;
        reg_test_logic_reset: in     vl_logic;
        reg_digital_input: in     vl_logic;
        reg_digital_output: out    vl_logic;
        reg_capture_dr  : in     vl_logic;
        reg_shift_dr    : in     vl_logic;
        reg_update_dr   : in     vl_logic;
        reg_capture_bsc : out    vl_logic;
        reg_shift_bsc   : out    vl_logic;
        reg_update_bsc  : out    vl_logic;
        reg_capture_ir  : in     vl_logic;
        reg_shift_ir    : in     vl_logic;
        reg_update_ir   : in     vl_logic;
        reg_mode        : in     vl_logic;
        reg_mode_bsc    : out    vl_logic;
        reg_scan_to_bsc : out    vl_logic;
        reg_scan_from_bsc: in     vl_logic
    );
end data_registers;
