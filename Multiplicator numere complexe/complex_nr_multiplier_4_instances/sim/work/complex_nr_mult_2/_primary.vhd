library verilog;
use verilog.vl_types.all;
entity complex_nr_mult_2 is
    generic(
        DATA_WIDTH      : integer := 8
    );
    port(
        clk             : in     vl_logic;
        rstn            : in     vl_logic;
        sw_rst          : in     vl_logic;
        op_val          : in     vl_logic;
        res_ready       : in     vl_logic;
        op_1_re         : in     vl_logic_vector;
        op_1_im         : in     vl_logic_vector;
        op_2_re         : in     vl_logic_vector;
        op_2_im         : in     vl_logic_vector;
        op_ready        : out    vl_logic;
        res_val         : out    vl_logic;
        result_re       : out    vl_logic_vector;
        result_im       : out    vl_logic_vector
    );
end complex_nr_mult_2;
