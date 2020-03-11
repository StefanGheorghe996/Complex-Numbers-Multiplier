    // Module:  complex_nr_mult_tb
    // Author:  Gheorghe Stefan
    // Date:    06.03.2020

    module complex_nr_mult_tb#(
        parameter DATA_WIDTH    = 8,
        parameter TEST_SCENARIO = 0
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
        output reg [DATA_WIDTH-1 : 0]    op_2_im               // input for the imaginary part of the second operand

    );
        // Internal signals and registers
        reg [DATA_WIDTH-1 : 0] op_1_re_reg;
        reg [DATA_WIDTH-1 : 0] op_1_im_reg;
        reg [DATA_WIDTH-1 : 0] op_2_re_reg;
        reg [DATA_WIDTH-1 : 0] op_2_im_reg;

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
                @(posedge clk);
                @(posedge clk);
                op_val <= 'b0;
                $display("%M %t - OPERAND VALID SIGNAL DEASSERTED", $time);
            end    
        endtask

        task write_result_ready;

            begin
                @(posedge clk);
                res_ready <= 'b1;
                $display("%M %t - RESULT READY SIGNAL ASSERTED", $time);
                @(posedge clk);
                res_ready <= 'b0;
                $display("%M %t - RESULT READY SIGNAL DEASSERTED", $time);
            end    
        endtask

        task test_scenario_selected_values;
            begin
                $display("%M %t - STARTED TEST SCENARIO WITH SELECTED VALUES", $time);
                write_operands(2,3,4,2);
                module_wait(2);
                write_valid;
                module_wait(20);
                write_result_ready;
                $stop;
            end
        endtask

        task test_scenario_random_values;
            begin
                op_1_re_reg = $random;
                op_1_im_reg = $random;
                op_2_re_reg = $random;
                op_2_im_reg = $random;
            
                $display("%M %t - STARTED TEST SCENARIO WITH RANDOM VALUES", $time);
                write_operands(op_1_re_reg,op_1_im_reg,op_2_re_reg,op_2_im_reg);
                module_wait(2);
                write_valid;
                module_wait(20);
                write_result_ready;
                $stop;
            end
        endtask

        task test_scenario_corner_case;          
            begin
                op_1_re_reg = {DATA_WIDTH{1'b1}};
                op_1_im_reg = {DATA_WIDTH{1'b1}};
                op_2_re_reg = {DATA_WIDTH{1'b1}};
                op_2_im_reg = {DATA_WIDTH{1'b1}};

                $display("%M %t - STARTED TEST SCENARIO WITH CORNER CASE VALUES", $time);
                write_operands(op_1_re_reg,op_1_im_reg,op_2_re_reg,op_2_im_reg);
                module_wait(2);
                write_valid;
                module_wait(20);
                write_result_ready;
                $stop;
            end
        endtask

        task test_scenario_multiple_transactions;
            input [9:0] transaction_number;
            integer i;
            begin
                $display("%M %t - STARTED FIRST TEST SCENARIO WITH MULTIPLE TRANSACTIONS VALUES", $time);
                for (i=0; i<transaction_number; i=i+1) 
                begin
                    op_1_re_reg = $random;
                    op_1_im_reg = $random;
                    op_2_re_reg = $random;
                    op_2_im_reg = $random;


                    write_operands(op_1_re_reg,op_1_im_reg,op_2_re_reg,op_2_im_reg);
                    module_wait(2);
                    write_valid;
                    module_wait(20);
                    write_result_ready;
                end
                $stop;
            end
        endtask

        initial 
        begin
            wait(~rstn);
            case (TEST_SCENARIO)
                0:  test_scenario_selected_values;
                1:  test_scenario_random_values;
                2:  test_scenario_corner_case; 
                3:  test_scenario_multiple_transactions(3);
                default:    test_scenario_selected_values;      
            endcase      
        end

    endmodule // complex_nr_mult_tb