// Module:  complex_nr_mult_1
// Author:  Gheorghe Stefan
// Date:    06.03.2020

module complex_nr_mult_2#(
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

    reg [DATA_WIDTH*2-1:0]    result_re;    // real part of the final result
    reg [DATA_WIDTH*2-1:0]    result_im;    // imaginary part of the real result

    wire compute_enable     ;
    wire mux_selection      ;
    wire mult_2_res_sel     ;
    

    reg [DATA_WIDTH*2-1 : 0]   re_x_re      ; // Register for storing the result of the real parts multiplication
    reg [DATA_WIDTH*2-1 : 0]   im_x_im      ; // Register for storing the result of the imaginary parts multiplication
    reg [DATA_WIDTH*2-1 : 0]   re_x_im_1    ; // op 1 re * op 2 im
    reg [DATA_WIDTH*2-1 : 0]   re_x_im_2    ; // op 1 im * op 2 re

    reg [DATA_WIDTH-1 : 0]  op_1_re_register ; // Register for storing real part of the first operand
    reg [DATA_WIDTH-1 : 0]  op_1_im_register ; // Register for storing imaginary part of the first operand
    reg [DATA_WIDTH-1 : 0]  op_2_re_register ; // Register for storing real part of the second operand
    reg [DATA_WIDTH-1 : 0]  op_2_im_register ; // Register for storing imaginary part of the second operand

    wire [DATA_WIDTH-1 : 0]     multiplier_1_op_1     ; // Connection for the multiplier module 1 operand 1
    wire [DATA_WIDTH-1 : 0]     multiplier_1_op_2     ; // Connection for the multiplier module 1 operand 2
    wire [DATA_WIDTH*2-1 : 0]   multiplier_1_result   ; // Connection for the multiplier module 1 result

    wire [DATA_WIDTH-1 : 0]     multiplier_2_op_1     ; // Connection for the multiplier module 2 operand 1
    wire [DATA_WIDTH-1 : 0]     multiplier_2_op_2     ; // Connection for the multiplier module 2 operand 2
    wire [DATA_WIDTH*2-1 : 0]   multiplier_2_result   ; // Connection for the multiplier module 2 result

    // Module instantiation

    control_logic CONTROL_LOGIC(
        .clk               (clk            ),  
        .rstn              (rstn           ),  
        .sw_rst            (sw_rst         ),  
        .op_val            (op_val         ),  
        .res_ready         (res_ready      ),  
        .op_ready          (op_ready       ),  
        .res_val           (res_val        ),  
        .mux_selection     (mux_selection  ),    
        .compute_enable    (compute_enable )  
    );

    uint8_mult  #(DATA_WIDTH) MULTIPLIER_1(
        .op1    (op_1_re_register   ),
        .op2    (multiplier_1_op_2  ),
        .result (multiplier_1_result)
    );

    uint8_mult  #(DATA_WIDTH) MULTIPLIER_2(
        .op1    (op_1_im_register   ),
        .op2    (multiplier_2_op_2  ),
        .result (multiplier_2_result)
    );

    // Modeling internal registers behaviour

    always @(posedge clk or negedge rstn)
    begin
         if(~rstn)                          re_x_re <= 'b0;
         else if (sw_rst)                   re_x_re <= 'b0;
         else if (mux_selection == 'b1)     re_x_re <= multiplier_1_result;
         else if (op_ready == 'b1)          re_x_re <= 'b0;
         else                               re_x_re <= re_x_re;
    end

    always @(posedge clk or negedge rstn)
    begin
         if(~rstn)                          im_x_im <= 'b0;
         else if (sw_rst)                   im_x_im <= 'b0;
         else if (mux_selection == 'b0)     im_x_im <= multiplier_2_result;
         else if (op_ready == 'b1)          im_x_im <= 'b0;
         else                               im_x_im <= im_x_im;
    end

    always @(posedge clk or negedge rstn)
    begin
         if(~rstn)                          re_x_im_1 <= 'b0;
         else if (sw_rst)                   re_x_im_1 <= 'b0;
         else if (mux_selection == 'b1)     re_x_im_1 <= multiplier_2_result;
         else if (op_ready == 'b1)          re_x_im_1 <= 'b0;
         else                               re_x_im_1 <= re_x_im_1;
    end

    always @(posedge clk or negedge rstn)
    begin
         if(~rstn)                          re_x_im_2 <= 'b0;
         else if (sw_rst)                   re_x_im_2 <= 'b0;
         else if (mux_selection == 'b0)     re_x_im_2 <= multiplier_1_result;
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
    
    assign multiplier_1_op_2 = (mux_selection == 'b1)? op_2_re_register : op_2_im_register;
    assign multiplier_2_op_2 = (mux_selection == 'b1)? op_2_re_register : op_2_im_register;

    assign res_data = {result_re,result_im};


endmodule // complex_nr_mult_1
