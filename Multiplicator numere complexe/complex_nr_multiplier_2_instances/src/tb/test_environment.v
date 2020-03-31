// Module:  test_environment
// Author:  Gheorghe Stefan
// Date:    06.03.2020

module test_environment();

    parameter DATA_WIDTH = 8;
    parameter CLOCK_PERIOD = 5;
    parameter RST_DELAY = 30;
    parameter RST_DURATION = 2;
    parameter TEST_SCENARIO = 0; // 0 = test scenario with values specified in the testbench, 1 = test scenario with random values, 2 =  test scenario with corner case values 3 = test scenario with multiple transactions

    //Internal signals
    wire                        clk      ;
    wire                        rstn     ;
    wire                        sw_rst   ;
    wire                        op_val   ;
    wire                        res_ready;
    wire [4*DATA_WIDTH-1 : 0]   op_data  ;
    wire                        op_ready ;
    wire                        res_val  ;
    wire [4*DATA_WIDTH-1 : 0]   res_data ;
    
    // Modules instantiation
    complex_nr_mult_2 #(DATA_WIDTH) DUT(
        .clk        (clk      ),
        .rstn       (rstn     ),
        .sw_rst     (sw_rst   ),
        .op_val     (op_val   ),
        .res_ready  (res_ready),
        .op_data    (op_data  ),
        .op_ready   (op_ready ),
        .res_val    (res_val  ),
        .res_data   (res_data )
    );

    complex_nr_mult_tb #(DATA_WIDTH,TEST_SCENARIO) TESTBENCH(
        .clk        (clk      ),
        .rstn       (rstn     ),
        .op_ready   (op_ready ),
        .res_val    (res_val  ),
        .sw_rst     (sw_rst   ),
        .op_val     (op_val   ),
        .res_ready  (res_ready),
        .op_data    (op_data  )
    );

    clock_rst_gen #(CLOCK_PERIOD,RST_DELAY,RST_DURATION) CLK_AND_RST_GEN(
        .clk    (clk),
        .rstn   (rstn)
    );

    monitor_complex_multiplier #(DATA_WIDTH) MONITOR(
        .clk        (clk      ),       
        .rstn       (rstn     ),       
        .sw_rst     (sw_rst   ),       
        .op_val     (op_val   ),       
        .res_ready  (res_ready),       
        .op_data    (op_data  ),      
        .op_ready   (op_ready ),       
        .res_val    (res_val  ),       
        .res_data   (res_data )       
    );

endmodule // test_environment