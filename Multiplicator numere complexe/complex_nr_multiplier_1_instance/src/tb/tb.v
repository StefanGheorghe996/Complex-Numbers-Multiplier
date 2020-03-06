//  Module: tb
//
module tb();

    reg             clk        ;    
    reg             rstn       ;
    reg             sw_rst     ;
    reg             op_val     ;
    reg             res_rdy    ;
    reg [7:0]       op_1_re    ;
    reg [7:0]       op_1_im    ;
    reg [7:0]       op_2_re    ;
    reg [7:0]       op_2_im    ;
    wire            op_rdy     ;
    wire            res_val    ;
    wire [15:0]     res_re     ;
    wire [15:0]     res_im     ;

    complex_nr_mult_1 DUT (
        .clk_i      (clk    ),
        .rstn_i     (rstn   ),
        .sw_rst_i   (sw_rst ),
        .op_val_i   (op_val ),
        .res_rdy_i  (res_rdy),
        .op_1_re_i  (op_1_re),
        .op_1_im_i  (op_1_im),
        .op_2_re_i  (op_2_re),
        .op_2_im_i  (op_2_im),
        .op_rdy_o   (op_rdy ),
        .res_val_o  (res_val),
        .res_re_o   (res_re ),
        .res_im_o   (res_im )
    );

    //Clock and asynchronous reset modeling
    initial 
    begin
        clk = 1'b0;
        rstn = 1'b1;
        forever #50 clk = !clk;
    end

    initial 
    begin
        rstn = 1'b1;
        #20 rstn = 1'b0;
        #30 rstn = 1'b1;
    end

    initial
    begin
        op_1_re = 'd2;
        op_1_im = 'd3;
        op_2_re = 'd4;
        op_2_im = 'd2;
        op_val = 'b1;
        #200
        op_val = 'b0;
        res_rdy = 'b1;
    end
    
endmodule
