// Module:  control_logic
// Author:  Gheorghe Stefan
// Date:    08.03.2020

module control_logic(
    input                   clk                 , // clock signal
    input                   rstn                , // asynchronous reset active 0
    input                   sw_rst              , // software reset active 1
    input                   op_val              , // data valid signal
    input                   res_ready           , // the consumer is ready to receive the result

    output wire             op_ready            , // module is ready to receive new operands
    output wire             res_val             , // result valid signal
    output wire             compute_enable        // enable for final result computation
);

    //State parameters
    parameter IDLE                  = 2'b00; // Idle state
    parameter COMPUTE_RESULT        = 2'b01; // Compute final result
    parameter WAIT_RESULT_RDY       = 2'b10; // Wait for result ready signal to be asserted

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
                    else         next_state <= COMPUTE_RESULT;

            COMPUTE_RESULT : next_state <= WAIT_RESULT_RDY; 

            WAIT_RESULT_RDY :   if (res_ready)  next_state <= IDLE;
                                else            next_state <= WAIT_RESULT_RDY;
        
        endcase       
    end

    // Output assignments
    
    assign op_ready         = (state == IDLE)?                 'b1 : 'b0;                  // The module is ready to receive new operands only in IDLE state
    assign res_val          = (state == WAIT_RESULT_RDY)?      'b1 : 'b0;                  // Result is computed and result valid signal is asserted  
    assign compute_enable   = (state == COMPUTE_RESULT)?       'b1 : 'b0;                  // Module is ready for final computation 

endmodule // control_logic
