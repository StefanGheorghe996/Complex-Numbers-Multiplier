// Module:  control_logic
// Author:  Gheorghe Stefan
// Date:    06.03.2020

module control_logic(
    input                   clk           , // clock signal
    input                   rstn          , // asynchronous reset active 0
    input                   sw_rst        , // software reset active 1
    input                   op_val        , // data valid signal
    input                   res_ready     , // the consumer is ready to receive the result

    output             op_ready          , // module is ready to receive new operands
    output             res_val           , // result valid signal
    output             op_1_sel          , // Selection signal for the first operand of the uint8_mult module
    output             op_2_sel          , // Selection signal for the second operand of the uint8_mult module
    output             compute_enable    , // enable for final result computation
    output reg [1:0]   result_reg_sel      // Selection signal for destination register of the results
);

    //State parameters
    localparam IDLE              = 3'b000; // Idle state
    localparam LOAD_OPERANDS     = 3'b010; // Wait 1 clock cycle to load the operands in the registers when data valid is asserted
    localparam MULT_RE_X_RE      = 3'b001; // Multiply the real part of the operands
    localparam MULT_IM_X_IM      = 3'b111; // Multiply the imaginary part of the operands
    localparam MULT_RE_X_IM_1    = 3'b101; // Multiply the real part of the first operand with the imaginary part of the second operand
    localparam MULT_RE_X_IM_2    = 3'b011; // Multiply the real part of the second operand with the imaginary part of the firs operand
    localparam COMPUTE_RESULT    = 3'b100; // Compute final result
    localparam WAIT_RESULT_RDY   = 3'b110; // Wait for result ready signal to be asserted

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

    always @(*)
    begin
        case (state)
            IDLE:   if (~op_val) next_state <= IDLE;
                    else         next_state <= LOAD_OPERANDS;
                    
            
            LOAD_OPERANDS : next_state <= MULT_RE_X_RE;

            MULT_RE_X_RE : next_state <= MULT_IM_X_IM;

            MULT_IM_X_IM : next_state <= MULT_RE_X_IM_1;

            MULT_RE_X_IM_1 : next_state <= MULT_RE_X_IM_2;

            MULT_RE_X_IM_2 : next_state <= COMPUTE_RESULT;

            COMPUTE_RESULT : next_state <= WAIT_RESULT_RDY; 

            WAIT_RESULT_RDY :   if (~res_ready) next_state <= WAIT_RESULT_RDY;
                                else if(res_ready) next_state <= IDLE;
                                else next_state <= WAIT_RESULT_RDY;

            default: next_state <= IDLE;
        endcase       
    end

    // Output assignments
    
    assign op_ready         = state == IDLE;                                                // The module is ready to receive new operands only in IDLE state
    assign res_val          = state == WAIT_RESULT_RDY;                                     // Result is computed and result valid signal is asserted  
    assign op_1_sel         = state == MULT_IM_X_IM | state == MULT_RE_X_IM_2;              // 0 = op 1 re, 1 = op 1 im 
    assign op_2_sel         = state == MULT_IM_X_IM | state == MULT_RE_X_IM_1;              // 0 = op 2 re, 1 = op 2 im
    assign compute_enable   = state == COMPUTE_RESULT;                                      // Module is ready for final computation 

    always @(*)                                                                             // Select where the multiply partial result is stored            
    case (state)
        MULT_RE_X_RE  :     result_reg_sel <= 2'b00;   
        MULT_IM_X_IM  :     result_reg_sel <= 2'b01; 
        MULT_RE_X_IM_1:     result_reg_sel <= 2'b10; 
        MULT_RE_X_IM_2:     result_reg_sel <= 2'b11;  
        default:            result_reg_sel <= 2'b00;  
    endcase

endmodule // control_logic
