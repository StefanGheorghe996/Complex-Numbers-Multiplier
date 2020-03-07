library verilog;
use verilog.vl_types.all;
entity test_environment is
    generic(
        DATA_WIDTH      : integer := 8;
        CLOCK_PERIOD    : integer := 5;
        RST_DELAY       : integer := 30;
        RST_DURATION    : integer := 2;
        TEST_SCENARIO   : integer := 1
    );
end test_environment;
