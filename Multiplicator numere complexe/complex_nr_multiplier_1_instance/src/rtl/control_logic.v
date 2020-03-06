//  Module: control_logic
//
module control_logic
    (
        input           clk_i,
        input           rstn_i,
        input           sw_rst_i,
        input           op_val_i,
        input           res_rdy_i,
        output          op_rdy_o,
        output          res_val_o,
        output          add_and_sub_en_o,
        output          sel_op_1_o,
        output          sel_op_2_o,
        output  [1:0]   sel_result_reg_o
    );

    //Internal registers and parameters
    parameter IDLE                  = 'd0;
    parameter LOAD_OPERANDS         = 'd1;
    parameter COMPUTE_RE_X_RE       = 'd2;
    parameter COMPUTE_IM_X_IM       = 'd3;
    parameter COMPUTE_RE_X_IM_1     = 'd4;
    parameter COMPUTE_RE_X_IM_2     = 'd5;
    parameter COMPUTE_ADD_AND_SUB   = 'd6;
    parameter WAIT_RESULT_READY     = 'd7;

    reg [2:0] state;
    reg [2:0] next_state;
    reg       sel_op_1;
    reg       sel_op_2;
    reg [1:0] sel_result_reg;

    always @(posedge clk_i or negedge rstn_i)
    begin
        if(~rstn_i) state <= IDLE;
        else if (sw_rst_i) state <= IDLE;
        else state <= next_state;
    end

    //State transitions
    always @(posedge clk_i or negedge rstn_i)
    begin
        case(state)
            IDLE: 
            begin
                if (op_val_i)   next_state <= LOAD_OPERANDS;
                else            next_state <= IDLE;
            end

            LOAD_OPERANDS : next_state <= COMPUTE_RE_X_RE;

            COMPUTE_RE_X_RE : next_state <= COMPUTE_IM_X_IM;

            COMPUTE_IM_X_IM : next_state <= COMPUTE_RE_X_IM_1;

            COMPUTE_RE_X_IM_1 : next_state <= COMPUTE_RE_X_IM_2;

            COMPUTE_RE_X_IM_2 : next_state <=  COMPUTE_ADD_AND_SUB;

            COMPUTE_ADD_AND_SUB: next_state <=  WAIT_RESULT_READY;

            WAIT_RESULT_READY:
            begin
                if(res_rdy_i) next_state <= IDLE;
                else next_state <= WAIT_RESULT_READY;
            end
        endcase
    end

    

    //Sel_op_1 reg
    always @(posedge clk_i or negedge rstn_i)
    begin
        if(~rstn_i) sel_op_1 <=  1'b0;
        else if(sw_rst_i) sel_op_1 <=  1'b0;
        else if (state == COMPUTE_RE_X_RE) sel_op_1 <=  1'b0;
        else if (state == COMPUTE_IM_X_IM) sel_op_1 <= 1'b1;
        else if (state == COMPUTE_RE_X_IM_1) sel_op_1 <= 1'b0;
        else if (state == COMPUTE_RE_X_IM_2) sel_op_1 <= 1'b1;
        else sel_op_1 <= 'bz;
    end

    //Sel_op_2 reg
    always @(posedge clk_i or negedge rstn_i)
    begin
        if(~rstn_i) sel_op_2 <=  1'b0;
        else if(sw_rst_i) sel_op_2 <=  1'b0;
        else if (state == COMPUTE_RE_X_RE) sel_op_2 <=  1'b0;
        else if (state == COMPUTE_IM_X_IM) sel_op_2 <= 1'b1;
        else if (state == COMPUTE_RE_X_IM_1) sel_op_2 <= 1'b1;
        else if (state == COMPUTE_RE_X_IM_2) sel_op_2 <= 1'b0;
        else sel_op_2 <= 'bz;
    end

    //Sel_op_2 reg
    always @(posedge clk_i or negedge rstn_i)
    begin
        if(~rstn_i) sel_result_reg <=  2'b00;
        else if(sw_rst_i) sel_result_reg <=  2'b00;
        else if (state == COMPUTE_RE_X_RE) sel_result_reg <=  2'b00;
        else if (state == COMPUTE_IM_X_IM) sel_result_reg <= 2'b01;
        else if (state == COMPUTE_RE_X_IM_1) sel_result_reg <= 2'b10;
        else if (state == COMPUTE_RE_X_IM_2) sel_op_2 <= 2'b11;
        else sel_result_reg <= 'bz;
    end

    // Output assignments
    assign op_rdy_o = (state == IDLE)? 'b1:'b0;
    assign res_val_o = (state == WAIT_RESULT_READY)? 'b1:'b0;
    assign add_and_sub_en_o = (state == COMPUTE_ADD_AND_SUB)? 'b1:'b0;
    assign sel_op_1_o       = sel_op_1;
    assign sel_op_2_o       = sel_op_2;
    assign sel_result_reg_o = sel_result_reg;

endmodule
