// Module:  complex_nr_mult_1
// Author:  Gheorghe Stefan
// Date:    08.03.2020

module complex_nr_mult_4#(
    parameter DATA_WIDTH = 8
)(

    input                       clk         , // clock signal
    input                       rstn        , // asynchronous reset active 0
    input                       sw_rst      , // software reset active 1

    input                       op_val      , // data valid signal
    output                      op_ready    , // module is ready to receive new operands
    input [4*DATA_WIDTH-1 : 0]  op_data     , // input data


    input                           res_ready   , // the consumer is ready to receive the result
    output                          res_val     , // result valid signal
    output    [4*DATA_WIDTH-1:0]    res_data      // result data
);

    // Internal signals and registers declaration

    
    wire compute_enable;

    wire [DATA_WIDTH-1 : 0]     multiplier_1_op_1     ; // Connection for the multiplier module 1 operand 1
    wire [DATA_WIDTH-1 : 0]     multiplier_1_op_2     ; // Connection for the multiplier module 1 operand 2
    wire [DATA_WIDTH*2-1 : 0]   multiplier_1_result   ; // Connection for the multiplier module 1 result

    wire [DATA_WIDTH-1 : 0]     multiplier_2_op_1     ; // Connection for the multiplier module 2 operand 1
    wire [DATA_WIDTH-1 : 0]     multiplier_2_op_2     ; // Connection for the multiplier module 2 operand 2
    wire [DATA_WIDTH*2-1 : 0]   multiplier_2_result   ; // Connection for the multiplier module 2 result

    wire [DATA_WIDTH-1 : 0]     multiplier_3_op_1     ; // Connection for the multiplier module 3 operand 1
    wire [DATA_WIDTH-1 : 0]     multiplier_3_op_2     ; // Connection for the multiplier module 3 operand 2
    wire [DATA_WIDTH*2-1 : 0]   multiplier_3_result   ; // Connection for the multiplier module 3 result

    wire [DATA_WIDTH-1 : 0]     multiplier_4_op_1     ; // Connection for the multiplier module 4 operand 1
    wire [DATA_WIDTH-1 : 0]     multiplier_4_op_2     ; // Connection for the multiplier module 4 operand 2
    wire [DATA_WIDTH*2-1 : 0]   multiplier_4_result   ; // Connection for the multiplier module 4 result

    reg  [2*DATA_WIDTH-1 : 0]   result_re;
    reg  [2*DATA_WIDTH-1 : 0]   result_im;

    // Module instantiation

    control_logic CONTROL_LOGIC(
        .clk               (clk            ),  
        .rstn              (rstn           ),  
        .sw_rst            (sw_rst         ),  
        .op_val            (op_val         ),  
        .res_ready         (res_ready      ),  
        .op_ready          (op_ready       ),  
        .res_val           (res_val        ),  
        .compute_enable    (compute_enable )  
    );

    uint8_mult  #(DATA_WIDTH) MULTIPLIER_1(
        .op1    (multiplier_1_op_1  ),
        .op2    (multiplier_1_op_2  ),
        .result (multiplier_1_result)
    );

    uint8_mult  #(DATA_WIDTH) MULTIPLIER_2(
        .op1    (multiplier_2_op_1  ),
        .op2    (multiplier_2_op_2  ),
        .result (multiplier_2_result)
    );

    uint8_mult  #(DATA_WIDTH) MULTIPLIER_3(
        .op1    (multiplier_3_op_1  ),
        .op2    (multiplier_3_op_2  ),
        .result (multiplier_3_result)
    );

    uint8_mult  #(DATA_WIDTH) MULTIPLIER_4(
        .op1    (multiplier_4_op_1  ),
        .op2    (multiplier_4_op_2  ),
        .result (multiplier_4_result)
    );

    // Modeling internal registers behaviour

    always @(posedge clk or negedge rstn)
    begin
        if(~rstn)               result_re <= 'b0;
        else if(sw_rst)         result_re <= 'b0;
        else if(compute_enable) result_re <= multiplier_1_result - multiplier_2_result;
    end

    always @(posedge clk or negedge rstn)
    begin
        if(~rstn)               result_im <= 'b0;
        else if(sw_rst)         result_im <= 'b0;
        else if(compute_enable) result_im <= multiplier_3_result + multiplier_4_result;
    end

    assign multiplier_1_op_1 = op_data[4*DATA_WIDTH-1 : 3*DATA_WIDTH];
    assign multiplier_1_op_2 = op_data[2*DATA_WIDTH-1 : DATA_WIDTH]  ;
    assign multiplier_2_op_1 = op_data[3*DATA_WIDTH-1 : 2*DATA_WIDTH];
    assign multiplier_2_op_2 = op_data[DATA_WIDTH-1 : 0 ]            ;
    assign multiplier_3_op_1 = op_data[4*DATA_WIDTH-1 : 3*DATA_WIDTH];
    assign multiplier_3_op_2 = op_data[DATA_WIDTH-1 : 0 ]            ;
    assign multiplier_4_op_1 = op_data[3*DATA_WIDTH-1 : 2*DATA_WIDTH];
    assign multiplier_4_op_2 = op_data[2*DATA_WIDTH-1 : DATA_WIDTH]  ;

    assign res_data = {result_re,result_im};

endmodule // complex_nr_mult_1
