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
    output reg      [DATA_WIDTH*2-1:0]  result_re   , // real part of the final result
    output reg      [DATA_WIDTH*2-1:0]  result_im   , // imaginary part of the real result
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

    // Modeling internal registers behaviour

    always @(posedge clk or negedge rstn)
    begin
         if(~rstn)                          re_x_re <= 'b0;
         else if (sw_rst)                   re_x_re <= 'b0;
         else if (result_reg_sel == 2'b00)  re_x_re <= multiplier_result;
         else if (op_ready == 'b1)          re_x_re <= 'b0;
    end

    always @(posedge clk or negedge rstn)
    begin
         if(~rstn)                          im_x_im <= 'b0;
         else if (sw_rst)                   im_x_im <= 'b0;
         else if (result_reg_sel == 2'b01)  im_x_im <= multiplier_result;
         else if (op_ready == 'b1)          im_x_im <= 'b0;
    end

    always @(posedge clk or negedge rstn)
    begin
         if(~rstn)                          re_x_im_1 <= 'b0;
         else if (sw_rst)                   re_x_im_1 <= 'b0;
         else if (result_reg_sel == 2'b10)  re_x_im_1 <= multiplier_result;
         else if (op_ready == 'b1)          re_x_im_1 <= 'b0;
    end

    always @(posedge clk or negedge rstn)
    begin
         if(~rstn)                          re_x_im_2 <= 'b0;
         else if (sw_rst)                   re_x_im_2 <= 'b0;
         else if (result_reg_sel == 2'b11)  re_x_im_2 <= multiplier_result;
         else if (op_ready == 'b1)          re_x_im_2 <= 'b0;
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
            op_1_re_register    <= op_1_re;    
            op_1_im_register    <= op_1_im;    
            op_2_re_register    <= op_2_re;    
            op_2_im_register    <= op_2_im;   
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
    
    assign multiplier_op_1 = (op_1_sel == 'b0)? op_1_re : op_1_im;
    assign multiplier_op_2 = (op_1_sel == 'b0)? op_2_re : op_2_im;


endmodule // complex_nr_mult_1
