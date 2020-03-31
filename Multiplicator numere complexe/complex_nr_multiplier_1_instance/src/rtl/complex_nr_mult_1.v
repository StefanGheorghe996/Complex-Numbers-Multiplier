// Module:  complex_nr_mult_1
// Author:  Gheorghe Stefan
// Date:    06.03.2020

module complex_nr_mult_1#(
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

    wire        op_1_sel        ;
    wire        op_2_sel        ;
    wire        compute_enable  ;
    wire [1:0]  result_reg_sel  ;

    reg [DATA_WIDTH*2-1 : 0]   re_x_re      ; // Register for storing the result of the real parts multiplication
    reg [DATA_WIDTH*2-1 : 0]   im_x_im      ; // Register for storing the result of the imaginary parts multiplication
    reg [DATA_WIDTH*2-1 : 0]   re_x_im_1    ; // op 1 re * op 2 im
    reg [DATA_WIDTH*2-1 : 0]   re_x_im_2    ; // op 1 im * op 2 re
    reg [DATA_WIDTH*2-1 : 0]   result_re    ; // partial real results befor concatenation
    reg [DATA_WIDTH*2-1 : 0]   result_im    ; // partial imaginary results befor concatenation

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

    uint8_mult  #(DATA_WIDTH) MULTIPLIER(
        .op1    (multiplier_op_1  ),
        .op2    (multiplier_op_2  ),
        .result (multiplier_result)
    );

    // Modeling internal registers behaviour

    always @(posedge clk or negedge rstn)
    begin
         if(~rstn)                          re_x_re <= 'b0;
         else if (sw_rst)                   re_x_re <= 'b0;
         else if (result_reg_sel == 2'b00)  re_x_re <= multiplier_result;
         else if (op_ready == 'b1)          re_x_re <= 'b0;
         else                               re_x_re <= re_x_re;
    end

    always @(posedge clk or negedge rstn)
    begin
         if(~rstn)                          im_x_im <= 'b0;
         else if (sw_rst)                   im_x_im <= 'b0;
         else if (result_reg_sel == 2'b01)  im_x_im <= multiplier_result;
         else if (op_ready == 'b1)          im_x_im <= 'b0;
         else                               im_x_im <= im_x_im;
    end

    always @(posedge clk or negedge rstn)
    begin
         if(~rstn)                          re_x_im_1 <= 'b0;
         else if (sw_rst)                   re_x_im_1 <= 'b0;
         else if (result_reg_sel == 2'b10)  re_x_im_1 <= multiplier_result;
         else if (op_ready == 'b1)          re_x_im_1 <= 'b0;
         else                               re_x_im_1 <= re_x_im_1;
    end

    always @(posedge clk or negedge rstn)
    begin
         if(~rstn)                          re_x_im_2 <= 'b0;
         else if (sw_rst)                   re_x_im_2 <= 'b0;
         else if (result_reg_sel == 2'b11)  re_x_im_2 <= multiplier_result;
         else if (op_ready == 'b1)          re_x_im_2 <= 'b0;
         else                               re_x_im_2 <= re_x_im_2;
    end

    always @(posedge clk or negedge rstn)
    begin
        if(~rstn) 
        begin
            op_1_re_register    <= 'b0;    
            op_1_im_register    <= 'b0;    
            op_2_re_register    <= 'b0;    
            op_2_im_register    <= 'b0;    
        end

        else if(sw_rst) 
        begin
            op_1_re_register    <= 'b0;    
            op_1_im_register    <= 'b0;    
            op_2_re_register    <= 'b0;    
            op_2_im_register    <= 'b0;    
        end

        else if(op_val)
        begin
            op_1_re_register    <= op_data[4*DATA_WIDTH-1 : 3*DATA_WIDTH];    
            op_1_im_register    <= op_data[3*DATA_WIDTH-1: 2*DATA_WIDTH];    
            op_2_re_register    <= op_data[2*DATA_WIDTH-1 : DATA_WIDTH];    
            op_2_im_register    <= op_data[DATA_WIDTH-1 : 0];   
        end
    end

    always @(posedge clk or negedge rstn)
    begin
        if(~rstn)               result_re <= 'b0;
        else if(sw_rst)         result_re <= 'b0;
        else if(compute_enable) result_re <= re_x_re - im_x_im;
    end

    always @(posedge clk or negedge rstn)
    begin
        if(~rstn)               result_im <= 'b0;
        else if(sw_rst)         result_im <= 'b0;
        else if(compute_enable) result_im <= re_x_im_1 + re_x_im_2;
    end

    // Assigning the inputs for the multiplier module
    
    assign multiplier_op_1 = (op_1_sel == 'b0)? op_1_re_register : op_1_im_register;
    assign multiplier_op_2 = (op_2_sel == 'b0)? op_2_re_register : op_2_im_register;


    assign res_data = {result_re,result_im};


endmodule // complex_nr_mult_1
