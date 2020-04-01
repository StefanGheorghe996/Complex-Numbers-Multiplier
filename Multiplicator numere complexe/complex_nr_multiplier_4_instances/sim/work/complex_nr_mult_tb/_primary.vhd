library verilog;
use verilog.vl_types.all;
entity complex_nr_mult_tb is
    generic(
        DATA_WIDTH      : integer := 8;
        TEST_SCENARIO   : integer := 0;
        TRANSACTION_NR  : integer := 20
    );
    port(
        clk             : in     vl_logic;
        rstn            : in     vl_logic;
        op_ready        : in     vl_logic;
        sw_rst          : out    vl_logic;
        op_val          : out    vl_logic;
        op_data         : out    vl_logic_vector
    );
end complex_nr_mult_tb;
