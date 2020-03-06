//  Module: tb
//
module tb();

    reg             clk        ;    
    reg             rstn       ;
    reg             sw_rst     ;
    reg             op_val     ;
    reg             res_rdy    ;
    reg [7:0]       op_1_re    ;
    reg [7:0]       op_1m    ;
    reg [7:0]       op_2_re    ;
    reg [7:0]       op_2m    ;
    wire            op_rdy     ;
    wire            res_val    ;
    wire [15:0]     res_re     ;
    wire [15:0]     resm     ;

    complex_nr_mult_1 DUT (
        .clk      (clk    ),
        .rstn     (rstn   ),
        .sw_rst   (sw_rst ),
        .op_val   (op_val ),
        .res_rdy  (res_rdy),
        .op_1_re  (op_1_re),
        .op_1m  (op_1m),
        .op_2_re  (op_2_re),
        .op_2m  (op_2m),
        .op_rdy   (op_rdy ),
        .res_val  (res_val),
        .res_re   (res_re ),
        .resm   (resm )
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
        op_1m = 'd3;
        op_2_re = 'd4;
        op_2m = 'd2;
        op_val = 'b1;
        #200
        op_val = 'b0;
        res_rdy = 'b1;
    end
    
endmodule
