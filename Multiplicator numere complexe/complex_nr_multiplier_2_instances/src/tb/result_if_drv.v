// Module:  result_if_drv
// Author:  Gheorghe Stefan
// Date:    01.04.2020

module result_if_drv#(
    parameter WAIT_BEFORE_READY = 20,       // Number of clock cycles before the module drives the res_ready signal in 1
    parameter TRANSACTION_NR = 20,          // Parameter used for the test scenario with multiple transactions
    parameter TEST_SCENARIO = 3             // Number of the test scenario, as described in complex_nr_mult_tb.v
)(
    input       clk,
    input       rstn,
    input       sw_rst,
    input       res_val,
    output reg  res_ready 
);

task module_wait; 
    input [9:0]  wait_cycles;   // how many cycles to wait
    integer i;
    begin
        for (i=0; i<wait_cycles; i=i+1) begin
        @(posedge clk);
        end
        $display(" %t - WAIT  -> %d clock cycles", $time, wait_cycles);
    end
endtask 

task write_result_ready;
    begin
        res_ready <= 'b1;
        $display(" %t - RESULT READY SIGNAL ASSERTED", $time);
        @(negedge res_val);
        res_ready <= 'b0;
        $display(" %t - RESULT READY SIGNAL DEASSERTED", $time);
    end    
endtask

initial 
    begin
        wait(~rstn);
        res_ready = 'b0;
        case(TEST_SCENARIO)
            3 : 
            begin
                repeat(TRANSACTION_NR)
                begin
                    module_wait(WAIT_BEFORE_READY);
                    write_result_ready;
                end
                $stop;
            end

            default : 
            begin
                module_wait(WAIT_BEFORE_READY);
                write_result_ready;
                $stop;
            end       
                
        endcase
    end

endmodule // result_if_drv

