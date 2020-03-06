// Module:  complex_nr_mult_tb
// Author:  Gheorghe Stefan
// Date:    06.03.2020

module complex_nr_mult_tb#(
    parameter DATA_WIDTH    = 8
)(
    input   clk         , // clock signal
    input   rstn        , // asynchronous reset active 0
    input   op_ready    , // module is ready to receive new operands
    input   res_val     , // result valid signal

    output reg                       sw_rst              , // software reset active 1
    output reg                       op_val              , // data valid signal
    output reg                       res_ready           , // the consumer is ready to receive the result
    output reg [DATA_WIDTH-1 : 0]    op_1_re             , // input for the real part of the first operand
    output reg [DATA_WIDTH-1 : 0]    op_1_im             , // input for the imaginary part of the first operand
    output reg [DATA_WIDTH-1 : 0]    op_2_re             , // input for the real part of the second operand
    output reg [DATA_WIDTH-1 : 0]    op_2_im             , // input for the imaginary part of the second operand

);

    // Task for driving operands on bus
    task write_operands;
        input [DATA_WIDTH-1 : 0] op_1_re_value;
        input [DATA_WIDTH-1 : 0] op_1_im_value;
        input [DATA_WIDTH-1 : 0] op_2_re_value;
        input [DATA_WIDTH-1 : 0] op_2_im_value;

        begin
            op_1_re <= op_1_re_value;
            op_1_im <= op_1_im_value;
            op_2_re <= op_2_re_value;
            op_2_im <= op_2_im_value;
            $display("%M %t - OPERANDS VALUES ON THE BUS", $time);
        end
    endtask

    task module_wait; 
        input [9:0]  wait_cycles;   // how many cycles to wait
        integer i;
        begin
            for (i=0; i<wait_cycles; i=i+1) begin
            @(posedge clk);
            end
            $display("%M %t - WAIT  -> %d clock cycles", $time, wait_cycles);
        end
    endtask 

    task write_valid;
        begin
            op_val <= 'b1;
            $display("%M %t - OPERAND VALID SIGNAL ASSERTED", $time);
            @(posedge op_ready);
            op_val <= 'b0;
            $display("%M %t - OPERAND VALID SIGNAL DEASSERTED", $time);
        end    
    endtask

    task write_result_ready;
        input  [9:0] wait_cycles;
        begin
            @(posedge res_val);
            wait(wait_cycles);
            res_ready <= 'b1;
            $display("%M %t - RESULT READY SIGNAL ASSERTED", $time);
            #(posedge clk);
            res_ready <= 'b0;
            $display("%M %t - OPERAND VALID SIGNAL DEASSERTED", $time);
        end    
    endtask

    task test_scenario_1;
        begin
            $display("%M %t - STARTED FIRST TEST SCENARIO", $time);
            write_operands(2,4,3,4);
            module_wait(2);
            write_valid;
            module_wait(10);
            write_result_ready;
            $stop;
        end
    endtask



endmodule // complex_nr_mult_tb