library verilog;
use verilog.vl_types.all;
entity control_logic is
    generic(
        IDLE            : integer := 0;
        LOAD_OPERANDS   : integer := 1;
        FIRST_STAGE_MULTIPLY: integer := 2;
        SCND_STAGE_MULTIPLY: integer := 3;
        COMPUTE_RESULT  : integer := 4;
        WAIT_RESULT_RDY : integer := 5
    );
    port(
        clk             : in     vl_logic;
        rstn            : in     vl_logic;
        sw_rst          : in     vl_logic;
        op_val          : in     vl_logic;
        res_ready       : in     vl_logic;
        op_ready        : out    vl_logic;
        res_val         : out    vl_logic;
        mult_1_op_1_sel : out    vl_logic;
        mult_1_op_2_sel : out    vl_logic;
        mult_2_op_1_sel : out    vl_logic;
        mult_2_op_2_sel : out    vl_logic;
        mult_1_res_sel  : out    vl_logic;
        mult_2_res_sel  : out    vl_logic;
        compute_enable  : out    vl_logic
    );
end control_logic;
