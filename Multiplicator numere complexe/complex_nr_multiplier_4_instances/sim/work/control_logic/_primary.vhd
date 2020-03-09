library verilog;
use verilog.vl_types.all;
entity control_logic is
    generic(
        IDLE            : integer := 0;
        COMPUTE_RESULT  : integer := 1;
        WAIT_RESULT_RDY : integer := 2
    );
    port(
        clk             : in     vl_logic;
        rstn            : in     vl_logic;
        sw_rst          : in     vl_logic;
        op_val          : in     vl_logic;
        res_ready       : in     vl_logic;
        op_ready        : out    vl_logic;
        res_val         : out    vl_logic;
        compute_enable  : out    vl_logic
    );
end control_logic;
