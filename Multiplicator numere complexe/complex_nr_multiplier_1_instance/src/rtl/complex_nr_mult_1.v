//  Module: complex_nr_mult_1
//
module complex_nr_mult_1

    (   
        input               clk,
        input               rstn,
        input               sw_rst,
        input               op_val,
        input               res_rdy,
        input   [8 -1:0]    op_1_re,
        input   [8 -1:0]    op_1m,
        input   [8 -1:0]    op_2_re,
        input   [8 -1:0]    op_2m,
        output              op_rdy,
        output              res_val,
        output  [16-1:0]    res_re,
        output  [16-1:0]    resm
    );

    //Internal signals and registers declaration
    reg [8-1:0]    op_1_re;
    reg [8-1:0]    op_1m;
    reg [8-1:0]    op_2_re;
    reg [8-1:0]    op_2m;

    //Final results registers
    reg [15:0]    res_re_value;
    reg [15:0]    resm_value;
    
    //Intermediary results registers
    reg [15:0]    imm_value;
    reg [15:0]    re_re_value;
    reg [15:0]    rem_1_value;
    reg [15:0]    rem_2_value;    

    //Mult module connections
    wire [7: 0]  op_1_multn;
    wire [7: 0]  op_2_multn;
    wire [15:0]  res_multut;

    //Control singals
    wire        add_and_sub_en;
    wire        selp_1;
    wire        selp_2;
    wire [1:0]  sel_result_reg;


    //Module instantiation

    uint8_mult MULTIPLIER(
        .op1(op_1_multn),
        .op2(op_2_multn),
        .result(res_multut)
    );

    control_logic CONTROL(
        .clk              (clk),
        .rstn             (rstn),
        .sw_rst           (sw_rst),
        .op_val           (op_val),
        .res_rdy          (res_rdy),
        .op_rdy           (op_rdy),
        .res_val          (res_val),
        .add_and_sub_en   (add_and_sub_en),
        .selp_1         (selp_1),
        .selp_2         (selp_2),
        .sel_result_reg   (sel_result_reg)
    );

    //Operand registers
    always @(posedge clk or negedge rstn)
    begin
        if(~rstn)
        begin
            op_1_re <= 'b0;
            op_1m <= 'b0;
            op_2_re <= 'b0;
            op_2m <= 'b0;
        end

        else if(sw_rst)
        begin
            op_1_re <= 'b0;
            op_1m <= 'b0;
            op_2_re <= 'b0;
            op_2m <= 'b0;
        end

        else if(op_val)
        begin
            op_1_re <= op_1_re;
            op_1m <= op_1m;
            op_2_re <= op_2_re;
            op_2m <= op_2m;
        end
    end

    //Result registers
    always @(posedge clk or negedge rstn)
    begin
        if(~rstn)
        begin
            res_re_value <= 'b0;
            resm_value <= 'b0;
        end

        else if(sw_rst)
        begin
            res_re_value <= 'b0;
            resm_value <= 'b0;
        end

        else if(add_and_sub_en)
        begin
            res_re_value <= re_re_value - imm_value;
            resm_value <= rem_1_value + rem_2_value;
        end
    end

    //Partial results registers
    always @(posedge clk or negedge rstn)
    begin
        if(~rstn)
        begin
            imm_value <= 'b0;
            re_re_value <= 'b0;
            rem_1_value <= 'b0;
            rem_2_value <= 'b0;
        end

        else if(sw_rst)
        begin
            imm_value <= 'b0;
            re_re_value <= 'b0;
            rem_1_value <= 'b0;
            rem_2_value <= 'b0;
        end

        else if(sel_result_reg == 'b00)
        begin
            re_re_value <= res_multut;
        end

        else if(sel_result_reg == 'b01)
        begin
            imm_value <= res_multut;
        end

        else if(sel_result_reg == 'b10)
        begin
            rem_1_value <= res_multut;
        end

        else if(sel_result_reg == 'b11)
        begin
            rem_2_value <= res_multut;
        end
    end

    assign op_1_multn =   (selp_1 == 'b0)? op_1_re : op_1m;
    assign op_2_multn =   (selp_2 == 'b0)? op_2_re : op_2m;
    
endmodule
