library verilog;
use verilog.vl_types.all;
entity control_logic is
    generic(
        IDLE            : integer := 0;
        LOAD_OPERANDS   : integer := 1;
        MULT_RE_X_RE    : integer := 2;
        MULT_IM_X_IM    : integer := 3;
        MULT_RE_X_IM_1  : integer := 4;
        MULT_RE_X_IM_2  : integer := 5;
        COMPUTE_RESULT  : integer := 6;
        WAIT_RESULT_RDY : integer := 7
    );
    port(
        clk             : in     vl_logic;
        rstn            : in     vl_logic;
        sw_rst          : in     vl_logic;
        op_val          : in     vl_logic;
        res_ready       : in     vl_logic;
        op_ready        : out    vl_logic;
        res_val         : out    vl_logic;
        op_1_sel        : out    vl_logic;
        op_2_sel        : out    vl_logic;
        compute_enable  : out    vl_logic;
        result_reg_sel  : out    vl_logic_vector(1 downto 0)
    );
end control_logic;
