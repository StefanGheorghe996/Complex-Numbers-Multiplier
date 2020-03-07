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
    output wire             op_1_sel          , // Selection signal for the first operand of the uint8_mult module
    output wire             op_2_sel          , // Selection signal for the second operand of the uint8_mult module
    output wire             compute_enable    , // enable for final result computation
    output wire [1:0]       result_reg_sel      // Selection signal for destination register of the results
);

    //State parameters
    parameter IDLE              = 3'b000; // Idle state
    parameter LOAD_OPERANDS     = 3'b001; // Wait 1 clock cycle to load the operands in the registers when data valid is asserted
    parameter MULT_RE_X_RE      = 3'b010; // Multiply the real part of the operands
    parameter MULT_IM_X_IM      = 3'b011; // Multiply the imaginary part of the operands
    parameter MULT_RE_X_IM_1    = 3'b100; // Multiply the real part of the first operand with the imaginary part of the second operand
    parameter MULT_RE_X_IM_2    = 3'b101; // Multiply the real part of the second operand with the imaginary part of the firs operand
    parameter COMPUTE_RESULT    = 3'b110; // Compute final result
    parameter WAIT_RESULT_RDY   = 3'b111; // Wait for result ready signal to be asserted

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
            
            LOAD_OPERANDS : next_state <= MULT_RE_X_RE;

            MULT_RE_X_RE : next_state <= MULT_IM_X_IM;

            MULT_IM_X_IM : next_state <= MULT_RE_X_IM_1;

            MULT_RE_X_IM_1 : next_state <= MULT_RE_X_IM_2;

            MULT_RE_X_IM_2 : next_state <= COMPUTE_RESULT;

            COMPUTE_RESULT : next_state <= WAIT_RESULT_RDY; 

            WAIT_RESULT_RDY :   if (~res_ready) next_state <= WAIT_RESULT_RDY;
                                else if(res_ready) next_state <= IDLE;

            default: next_state <= IDLE;
        endcase       
    end

    // Output assignments
    
    assign op_ready         = (state == IDLE)? 'b1 : 'b0;                                   // The module is ready to receive new operands only in IDLE state
    assign res_val          = (state == WAIT_RESULT_RDY)? 'b1 : 'b0;                        // Result is computed and result valid signal is asserted
    assign op_1_sel         = (state == MULT_RE_X_RE | state == MULT_RE_X_IM_1)? 'b0 : 'b1; // 0 = op 1 re, 1 = op 1 im 
    assign op_2_sel         = (state == MULT_RE_X_RE | state == MULT_RE_X_IM_2)? 'b0 : 'b1; // 0 = op 2 re, 1 = op 2 im
    assign compute_enable   = (state == COMPUTE_RESULT)? 'b1 : 'b0;                         // Module is ready for final computation 

    assign result_reg_sel   = (state == MULT_RE_X_RE)?      'b00 :
                              (state == MULT_IM_X_IM)?      'b01 :
                              (state == MULT_RE_X_IM_1)?    'b10 :
                              (state == MULT_RE_X_IM_2)?    'b11 : 'bz;                     // Select where the multiply partial result is stored            


endmodule // control_logic
