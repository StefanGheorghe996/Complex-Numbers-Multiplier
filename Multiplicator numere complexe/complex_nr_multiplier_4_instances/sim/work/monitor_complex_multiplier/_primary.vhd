library verilog;
use verilog.vl_types.all;
entity monitor_complex_multiplier is
    generic(
        DATA_WIDTH      : integer := 8
    );
    port(
        clk             : in     vl_logic;
        rstn            : in     vl_logic;
        sw_rst          : in     vl_logic;
        op_val          : in     vl_logic;
        op_ready        : in     vl_logic;
        op_data         : in     vl_logic_vector;
        res_val         : in     vl_logic;
        res_ready       : in     vl_logic;
        res_data        : in     vl_logic_vector
    );
end monitor_complex_multiplier;
