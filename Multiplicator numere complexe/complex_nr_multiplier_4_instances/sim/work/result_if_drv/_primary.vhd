library verilog;
use verilog.vl_types.all;
entity result_if_drv is
    generic(
        WAIT_BEFORE_READY: integer := 20;
        TRANSACTION_NR  : integer := 20;
        TEST_SCENARIO   : integer := 3
    );
    port(
        clk             : in     vl_logic;
        rstn            : in     vl_logic;
        sw_rst          : in     vl_logic;
        res_val         : in     vl_logic;
        res_ready       : out    vl_logic
    );
end result_if_drv;
