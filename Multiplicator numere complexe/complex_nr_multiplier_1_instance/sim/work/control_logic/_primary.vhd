library verilog;
use verilog.vl_types.all;
entity control_logic is
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
