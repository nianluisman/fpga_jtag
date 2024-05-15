library verilog;
use verilog.vl_types.all;
entity boundary_scan_cell is
    generic(
        bsc_res_val     : vl_logic := Hi0
    );
    port(
        bsc_tck         : in     vl_logic;
        bsc_reset_n     : in     vl_logic;
        bsc_test_logic_reset: in     vl_logic;
        bsc_capture     : in     vl_logic;
        bsc_shift_data  : in     vl_logic;
        bsc_update      : in     vl_logic;
        bsc_mode        : in     vl_logic;
        bsc_scan_in     : in     vl_logic;
        bsc_scan_out    : out    vl_logic;
        bsc_ex_digital_input: in     vl_logic;
        bsc_ex_digital_output: out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of bsc_res_val : constant is 2;
end boundary_scan_cell;
