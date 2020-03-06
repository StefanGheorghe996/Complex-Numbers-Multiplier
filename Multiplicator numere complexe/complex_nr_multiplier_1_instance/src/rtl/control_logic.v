//  Module: control_logic
//
module control_logic
    (
        input           clk,
        input           rstn,
        input           sw_rst,
        input           op_val,
        input           res_rdy,
        output          op_rdy,
        output          res_val,
        output          add_and_sub_en,
        output          selp_1,
        output          selp_2,
        output  [1:0]   sel_result_reg
    );

    //Internal registers and parameters
    parameter IDLE                  = 'd0;
    parameter LOADPERANDS         = 'd1;
    parameter COMPUTE_RE_X_RE       = 'd2;
    parameter COMPUTEM_XM       = 'd3;
    parameter COMPUTE_RE_XM_1     = 'd4;
    parameter COMPUTE_RE_XM_2     = 'd5;
    parameter COMPUTE_ADD_AND_SUB   = 'd6;
    parameter WAIT_RESULT_READY     = 'd7;

    reg [2:0] state;
    reg [2:0] next_state;
    reg       selp_1;
    reg       selp_2;
    reg [1:0] sel_result_reg;

    always @(posedge clk or negedge rstn)
    begin
        if(~rstn) state <= IDLE;
        else if (sw_rst) state <= IDLE;
        else state <= next_state;
    end

    //State transitions
    always @(posedge clk or negedge rstn)
    begin
        case(state)
            IDLE: 
            begin
                if (op_val)   next_state <= LOADPERANDS;
                else            next_state <= IDLE;
            end

            LOADPERANDS : next_state <= COMPUTE_RE_X_RE;

            COMPUTE_RE_X_RE : next_state <= COMPUTEM_XM;

            COMPUTEM_XM : next_state <= COMPUTE_RE_XM_1;

            COMPUTE_RE_XM_1 : next_state <= COMPUTE_RE_XM_2;

            COMPUTE_RE_XM_2 : next_state <=  COMPUTE_ADD_AND_SUB;

            COMPUTE_ADD_AND_SUB: next_state <=  WAIT_RESULT_READY;

            WAIT_RESULT_READY:
            begin
                if(res_rdy) next_state <= IDLE;
                else next_state <= WAIT_RESULT_READY;
            end
        endcase
    end

    

    //Selp_1 reg
    always @(posedge clk or negedge rstn)
    begin
        if(~rstn) selp_1 <=  1'b0;
        else if(sw_rst) selp_1 <=  1'b0;
        else if (state == COMPUTE_RE_X_RE) selp_1 <=  1'b0;
        else if (state == COMPUTEM_XM) selp_1 <= 1'b1;
        else if (state == COMPUTE_RE_XM_1) selp_1 <= 1'b0;
        else if (state == COMPUTE_RE_XM_2) selp_1 <= 1'b1;
        else selp_1 <= 'bz;
    end

    //Selp_2 reg
    always @(posedge clk or negedge rstn)
    begin
        if(~rstn) selp_2 <=  1'b0;
        else if(sw_rst) selp_2 <=  1'b0;
        else if (state == COMPUTE_RE_X_RE) selp_2 <=  1'b0;
        else if (state == COMPUTEM_XM) selp_2 <= 1'b1;
        else if (state == COMPUTE_RE_XM_1) selp_2 <= 1'b1;
        else if (state == COMPUTE_RE_XM_2) selp_2 <= 1'b0;
        else selp_2 <= 'bz;
    end

    //Selp_2 reg
    always @(posedge clk or negedge rstn)
    begin
        if(~rstn) sel_result_reg <=  2'b00;
        else if(sw_rst) sel_result_reg <=  2'b00;
        else if (state == COMPUTE_RE_X_RE) sel_result_reg <=  2'b00;
        else if (state == COMPUTEM_XM) sel_result_reg <= 2'b01;
        else if (state == COMPUTE_RE_XM_1) sel_result_reg <= 2'b10;
        else if (state == COMPUTE_RE_XM_2) selp_2 <= 2'b11;
        else sel_result_reg <= 'bz;
    end

    // Output assignments
    assign op_rdy = (state == IDLE)? 'b1:'b0;
    assign res_val = (state == WAIT_RESULT_READY)? 'b1:'b0;
    assign add_and_sub_en = (state == COMPUTE_ADD_AND_SUB)? 'b1:'b0;
    assign selp_1       = selp_1;
    assign selp_2       = selp_2;
    assign sel_result_reg = sel_result_reg;

endmodule
