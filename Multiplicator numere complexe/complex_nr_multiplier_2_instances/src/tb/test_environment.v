// Module:  test_environment
// Author:  Gheorghe Stefan
// Date:    06.03.2020

module test_environment();
    
    parameter DATA_WIDTH = 8;
    parameter CLOCK_PERIOD = 5;  
    parameter TRANSACTION_NR = 30;      // Number of transactions for the forth test scenario
    parameter RST_DELAY = 30;           // Initial waiting period before reset
    parameter RST_DURATION = 2;         // Duration of the reset pulse
    parameter TEST_SCENARIO = 3;        // 0 = test scenario with values specified in the testbench, 1 = test scenario with random values, 2 =  test scenario with corner case values 3 = test scenario with multiple transactions
    parameter WAIT_BEFORE_READY = 20;   // Number of clock cycles before the module drives the res_ready signal in 1

    //Internal signals
    wire                        clk      ;
    wire                        rstn     ;
    wire                        sw_rst   ;
    wire                        op_val   ;
    wire                        res_ready;
    wire [4*DATA_WIDTH-1 : 0]   op_data  ;
    wire                        op_ready ;
    wire                        res_val  ;
    wire [4*DATA_WIDTH+2 : 0]   res_data ;
    
    // Modules instantiation

    complex_nr_mult_4 #(DATA_WIDTH) DUT(
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

    // Signal generation for op interface and result valid

    complex_nr_mult_tb #(DATA_WIDTH,TEST_SCENARIO) TESTBENCH(
        .clk        (clk      ),
        .rstn       (rstn     ),
        .op_ready   (op_ready ),
        .sw_rst     (sw_rst   ),
        .op_val     (op_val   ),
        .op_data    (op_data  )
    );

    // Clock and reset generator

    clock_rst_gen #(CLOCK_PERIOD,RST_DELAY,RST_DURATION) CLK_AND_RST_GEN(
        .clk    (clk),
        .rstn   (rstn)
    );

    // Generator for result reaady signal

    result_if_drv #(WAIT_BEFORE_READY) RESULT_IF_DRV(
        .clk            (clk        ),
        .rstn           (rstn       ),
        .sw_rst         (sw_rst     ),
        .res_val        (res_val    ),
        .res_ready      (res_ready  )
    );

    // Monitor module => compares the expected results with the results generated by the DUT

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