// Module:  complex_nr_mult_1
// Author:  Gheorghe Stefan
// Date:    06.03.2020

module complex_nr_mult_1#(
    parameter DATA_WIDTH = 8
)(

    input                       clk                 , // clock signal
    input                       rstn                , // asynchronous reset active 0
    input                       sw_rst              , // software reset active 1
    input                       op_val              , // data valid signal
    input                       res_ready           , // the consumer is ready to receive the result
    input [DATA_WIDTH-1 : 0]    op_1_re             , // input for the real part of the first operand
    input [DATA_WIDTH-1 : 0]    op_1_im             , // input for the imaginary part of the first operand
    input [DATA_WIDTH-1 : 0]    op_2_re             , // input for the real part of the second operand
    input [DATA_WIDTH-1 : 0]    op_2_im             , // input for the imaginary part of the second operand

    output wire                         op_ready    , // module is ready to receive new operands
    output wire                         res_val     , // result valid signal
    output wire     [DATA_WIDTH*2-1:0]  result_re   , // real part of the final result
    output wire     [DATA_WIDTH*2-1:0]  result_im   , // imaginary part of the real result
);

    // Internal signals and registers declaration

    wire        op_1_sel        ;
    wire        op_2_sel        ;
    wire        compute_enable  ;
    wire [2:0]  result_reg_sel  ;

    reg [DATA_WIDTH*2-1 : 0]   re_x_re      ; // Register for storing the result of the real parts multiplication
    reg [DATA_WIDTH*2-1 : 0]   im_x_im      ; // Register for storing the result of the imaginary parts multiplication
    reg [DATA_WIDTH*2-1 : 0]   re_x_im_1    ; // op 1 re * op 2 im
    reg [DATA_WIDTH*2-1 : 0]   re_x_im_2    ; // op 1 im * op 2 re

    reg [DATA_WIDTH-1 : 0]  op_1_re_register ; // Register for storing real part of the first operand
    reg [DATA_WIDTH-1 : 0]  op_1_im_register ; // Register for storing imaginary part of the first operand
    reg [DATA_WIDTH-1 : 0]  op_2_re_register ; // Register for storing real part of the second operand
    reg [DATA_WIDTH-1 : 0]  op_2_im_register ; // Register for storing imaginary part of the second operand

    wire [DATA_WIDTH-1 : 0]     multiplier_op_1     ; // Connection for the multiplier module operand 1
    wire [DATA_WIDTH-1 : 0]     multiplier_op_2     ; // Connection for the multiplier module operand 2
    wire [DATA_WIDTH*2-1 : 0]   multiplier_result   ; // Connection for the multiplier module result

    // Module instantiation
    control_logic CONTROL_LOGIC(
        .clk            (clk           ) ,
        .rstn           (rstn          ) ,
        .sw_rst         (sw_rst        ) ,
        .op_val         (op_val        ) ,
        .res_ready      (res_ready     ) ,
        .op_ready       (op_ready      ) ,
        .res_val        (res_val       ) ,
        .op_1_sel       (op_1_sel      ) ,
        .op_2_sel       (op_2_sel      ) ,
        .compute_enable (compute_enable) ,
        .result_reg_sel (result_reg_sel) 
    );

    uint8_mult MULTIPLIER #(DATA_WIDTH)(
        .op1    (multiplier_op_1  ),
        .op2    (multiplier_op_2  ),
        .result (multiplier_result)
    );

    


endmodule // complex_nr_mult_1