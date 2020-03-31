library verilog;
use verilog.vl_types.all;
entity complex_nr_mult_1 is
    generic(
        DATA_WIDTH      : integer := 8
    );
    port(
        clk             : in     vl_logic;
        rstn            : in     vl_logic;
        sw_rst          : in     vl_logic;
        op_val          : in     vl_logic;
        op_ready        : out    vl_logic;
        op_data         : in     vl_logic_vector;
        res_ready       : in     vl_logic;
        res_val         : out    vl_logic;
        res_data        : out    vl_logic_vector
    );
end complex_nr_mult_1;
