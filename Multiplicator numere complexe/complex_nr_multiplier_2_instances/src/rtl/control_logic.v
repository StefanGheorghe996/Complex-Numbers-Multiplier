// Module:  control_logic
// Author:  Gheorghe Stefan
// Date:    06.03.2020

module control_logic(
    input                   clk                 , // clock signal
    input                   rstn                , // asynchronous reset active 0
    input                   sw_rst              , // software reset active 1
    input                   op_val              , // data valid signal
    input                   res_ready           , // the consumer is ready to receive the result

    output wire             op_ready            , // module is ready to receive new operands
    output wire             res_val             , // result valid signal
    output wire             mux_selection       , // selection signal for result registers and operands
    output wire             compute_enable        // enable for final result computation
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

    always @(*)
    begin
        case (state)
            IDLE:   if (~op_val)  next_state <= IDLE;
                    else          next_state <= LOAD_OPERANDS;
                
            LOAD_OPERANDS : next_state <= FIRST_STAGE_MULTIPLY;

            FIRST_STAGE_MULTIPLY : next_state <= SCND_STAGE_MULTIPLY;

            SCND_STAGE_MULTIPLY : next_state <= COMPUTE_RESULT;

            COMPUTE_RESULT : next_state <= WAIT_RESULT_RDY; 

            WAIT_RESULT_RDY :   if (res_ready)  next_state <= IDLE;
                                else            next_state <= WAIT_RESULT_RDY;
        
        endcase       
    end

    // Output assignments
    
    assign op_ready         = state == IDLE                 ;                  // The module is ready to receive new operands only in IDLE state
    assign res_val          = state == WAIT_RESULT_RDY      ;                  // Result is computed and result valid signal is asserted  
    assign compute_enable   = state == COMPUTE_RESULT       ;                  // Module is ready for final computation 
    assign mux_selection    = state == FIRST_STAGE_MULTIPLY ;

endmodule // control_logic
