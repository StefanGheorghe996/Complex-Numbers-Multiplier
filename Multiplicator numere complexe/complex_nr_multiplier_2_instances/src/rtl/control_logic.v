// Module:  control_logic
// Author:  Gheorghe Stefan
// Date:    06.03.2020

module control_logic(
    input                   clk           , // clock signal
    input                   rstn          , // asynchronous reset active 0
    input                   sw_rst        , // software reset active 1
    input                   op_val        , // data valid signal
    input                   res_ready     , // the consumer is ready to receive the result

    output wire             op_ready          , // module is ready to receive new operands
    output wire             res_val           , // result valid signal
    output wire             mult_1_op_1_sel   , // selection signal for operand 1 of the first multiply module
    output wire             mult_1_op_2_sel   , // selection signal for operand 2 of the first multiply module
    output wire             mult_2_op_1_sel   , // selection signal for operand 1 of the second multiply module
    output wire             mult_2_op_2_sel   , // selection signal for operand 2 of the second multiply module
    output wire             mult_1_res_sel    , // selection signal for result register for the first multiply module
    output wire             mult_2_res_sel    , // selection signal for result register for the second multiply module
    output wire             compute_enable      // enable for final result computation
);

    //State parameters
    parameter IDLE                  = 3'b000; // Idle state
    parameter LOAD_OPERANDS         = 3'b001; // Wait 1 clock cycle to load the operands in the registers when data valid is asserted
    parameter FIRST_STAGE_MULTIPLY  = 3'b010; // Compute first 2 multiplications
    parameter SCND_STAGE_MULTIPLY   = 3'b011; // Compute last 2 multiplications
    parameter COMPUTE_RESULT        = 3'b100; // Compute final result
    parameter WAIT_RESULT_RDY       = 3'b101; // Wait for result ready signal to be asserted

    // Internal signals and registers
    reg [2:0] state;
    reg [2:0] next_state;

    // State transition

    always @(posedge clk or negedge rstn)
    begin
        if(~rstn) state <= IDLE;
        else if (sw_rst) state <= IDLE;
        else state <= next_state;
    end 

    always @(posedge clk)
    begin
        case (state)
            IDLE:   if (~op_val) next_state <= IDLE;
                    else if(op_val) next_state <= LOAD_OPERANDS;
                    else next_state <= IDLE;
            
            LOAD_OPERANDS : next_state <= FIRST_STAGE_MULTIPLY;

            FIRST_STAGE_MULTIPLY : next_state <= SCND_STAGE_MULTIPLY;

            SCND_STAGE_MULTIPLY : next_state <= COMPUTE_RESULT;

            COMPUTE_RESULT : next_state <= WAIT_RESULT_RDY; 

            WAIT_RESULT_RDY :   if (~res_ready) next_state <= WAIT_RESULT_RDY;
                                else if(res_ready) next_state <= IDLE;
                                else next_state <= WAIT_RESULT_RDY;

            default: next_state <= IDLE;
        endcase       
    end

    // Output assignments
    
    assign op_ready         = (state == IDLE)? 'b1 : 'b0;                                   // The module is ready to receive new operands only in IDLE state
    assign res_val          = (state == WAIT_RESULT_RDY)? 'b1 : 'b0;                        // Result is computed and result valid signal is asserted  
    assign compute_enable   = (state == COMPUTE_RESULT)? 'b1 : 'b0;                         // Module is ready for final computation 
    assign mult_1_op_1_sel  = (state == FIRST_STAGE_MULTIPLY)? 'b0 : 'b1;
    assign mult_1_op_2_sel  = (state == FIRST_STAGE_MULTIPLY)? 'b0 : 'b1;
    assign mult_2_op_1_sel  = (state == FIRST_STAGE_MULTIPLY)? 'b0 : 'b1;
    assign mult_2_op_2_sel  = (state == FIRST_STAGE_MULTIPLY)? 'b1 : 'b0;
    assign mult_1_res_sel   = (state == FIRST_STAGE_MULTIPLY)? 'b0 : 'b1;
    assign mult_2_res_sel   = (state == FIRST_STAGE_MULTIPLY)? 'b0 : 'b1;


endmodule // control_logic
