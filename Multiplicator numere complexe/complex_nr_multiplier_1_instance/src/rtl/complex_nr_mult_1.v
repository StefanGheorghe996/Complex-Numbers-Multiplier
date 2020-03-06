//  Module: complex_nr_mult_1
//
module complex_nr_mult_1

    (   
        input               clk_i,
        input               rstn_i,
        input               sw_rst_i,
        input               op_val_i,
        input               res_rdy_i,
        input   [8 -1:0]    op_1_re_i,
        input   [8 -1:0]    op_1_im_i,
        input   [8 -1:0]    op_2_re_i,
        input   [8 -1:0]    op_2_im_i,
        output              op_rdy_o,
        output              res_val_o,
        output  [16-1:0]    res_re_o,
        output  [16-1:0]    res_im_o
    );

    //Internal signals and registers declaration
    reg [8-1:0]    op_1_re;
    reg [8-1:0]    op_1_im;
    reg [8-1:0]    op_2_re;
    reg [8-1:0]    op_2_im;

    //Final results registers
    reg [15:0]    res_re_value;
    reg [15:0]    res_im_value;
    
    //Intermediary results registers
    reg [15:0]    im_im_value;
    reg [15:0]    re_re_value;
    reg [15:0]    re_im_1_value;
    reg [15:0]    re_im_2_value;    

    //Mult module connections
    wire [7: 0]  op_1_mult_in;
    wire [7: 0]  op_2_mult_in;
    wire [15:0]  res_mult_out;

    //Control singals
    wire        add_and_sub_en;
    wire        sel_op_1;
    wire        sel_op_2;
    wire [1:0]  sel_result_reg;


    //Module instantiation

    uint8_mult MULTIPLIER(
        .op1(op_1_mult_in),
        .op2(op_2_mult_in),
        .result(res_mult_out)
    );

    control_logic CONTROL(
        .clk_i              (clk_i),
        .rstn_i             (rstn_i),
        .sw_rst_i           (sw_rst_i),
        .op_val_i           (op_val_i),
        .res_rdy_i          (res_rdy_i),
        .op_rdy_o           (op_rdy_o),
        .res_val_o          (res_val_o),
        .add_and_sub_en_o   (add_and_sub_en),
        .sel_op_1_o         (sel_op_1),
        .sel_op_2_o         (sel_op_2),
        .sel_result_reg_o   (sel_result_reg)
    );

    //Operand registers
    always @(posedge clk_i or negedge rstn_i)
    begin
        if(~rstn_i)
        begin
            op_1_re <= 'b0;
            op_1_im <= 'b0;
            op_2_re <= 'b0;
            op_2_im <= 'b0;
        end

        else if(sw_rst_i)
        begin
            op_1_re <= 'b0;
            op_1_im <= 'b0;
            op_2_re <= 'b0;
            op_2_im <= 'b0;
        end

        else if(op_val_i)
        begin
            op_1_re <= op_1_re_i;
            op_1_im <= op_1_im_i;
            op_2_re <= op_2_re_i;
            op_2_im <= op_2_im_i;
        end
    end

    //Result registers
    always @(posedge clk_i or negedge rstn_i)
    begin
        if(~rstn_i)
        begin
            res_re_value <= 'b0;
            res_im_value <= 'b0;
        end

        else if(sw_rst_i)
        begin
            res_re_value <= 'b0;
            res_im_value <= 'b0;
        end

        else if(add_and_sub_en)
        begin
            res_re_value <= re_re_value - im_im_value;
            res_im_value <= re_im_1_value + re_im_2_value;
        end
    end

    //Partial results registers
    always @(posedge clk_i or negedge rstn_i)
    begin
        if(~rstn_i)
        begin
            im_im_value <= 'b0;
            re_re_value <= 'b0;
            re_im_1_value <= 'b0;
            re_im_2_value <= 'b0;
        end

        else if(sw_rst_i)
        begin
            im_im_value <= 'b0;
            re_re_value <= 'b0;
            re_im_1_value <= 'b0;
            re_im_2_value <= 'b0;
        end

        else if(sel_result_reg == 'b00)
        begin
            re_re_value <= res_mult_out;
        end

        else if(sel_result_reg == 'b01)
        begin
            im_im_value <= res_mult_out;
        end

        else if(sel_result_reg == 'b10)
        begin
            re_im_1_value <= res_mult_out;
        end

        else if(sel_result_reg == 'b11)
        begin
            re_im_2_value <= res_mult_out;
        end
    end

    assign op_1_mult_in =   (sel_op_1 == 'b0)? op_1_re_i : op_1_im_i;
    assign op_2_mult_in =   (sel_op_2 == 'b0)? op_2_re_i : op_2_im_i;
    
endmodule
