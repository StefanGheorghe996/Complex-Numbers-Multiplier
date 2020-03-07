// Module:  monitor_complex_multiplier
// Author:  Gheorghe Stefan
// Date:    06.03.2020

module monitor_complex_multiplier#(
    parameter DATA_WIDTH = 8
)(
    input                       clk             ,
    input                       rstn            ,

    input                       sw_rst          ,
    input                       op_val          ,
    input                       res_ready       ,
    input [DATA_WIDTH-1 : 0]    op_1_re         ,
    input [DATA_WIDTH-1 : 0]    op_1_im         ,
    input [DATA_WIDTH-1 : 0]    op_2_re         ,
    input [DATA_WIDTH-1 : 0]    op_2_im         ,
    input                       op_ready        ,
    input                       res_val         ,
    input [DATA_WIDTH*2-1 : 0]  result_re       ,
    input [DATA_WIDTH*2-1 : 0]  result_im       
);

    //Internal registers for checking the functionality
    reg [DATA_WIDTH*2-1 : 0] predicted_result_re;
    reg [DATA_WIDTH*2-1 : 0] predicted_result_im;

    always @(posedge clk or negedge rstn)
    begin
        if(~rstn) predicted_result_re <= 'b0;
        else if(sw_rst) predicted_result_re <= 'b0;
        else if(op_val) predicted_result_re <= (op_1_re * op_2_re) - (op_1_im * op_2_im);
    end

    always @(posedge clk or negedge rstn)
    begin
        if(~rstn) predicted_result_im <= 'b0;
        else if(sw_rst) predicted_result_im <= 'b0;
        else if(op_val) predicted_result_im <= (op_1_re * op_2_im) + (op_1_im * op_2_re);
    end

    always @(posedge clk)
    begin
        if (res_ready && res_val) begin
            if(result_re == predicted_result_re)
                $display("%M %t - REAL PART OF THE RESULT IS COMPUTED CORRECTLY", $time);
            else
                $display("%M %t - REAL PART OF THE RESULT WAS NOT COMPUTED CORRECTLY", $time);
        end
    end

    always @(posedge clk)
    begin
        if (res_ready  && res_val) begin
            if(result_im == predicted_result_im)
                $display("%M %t - IMAGINARY PART OF THE RESULT IS COMPUTED CORRECTLY", $time);
            else
                $display("%M %t - IMAGINARY PART OF THE RESULT WAS NOT COMPUTED CORRECTLY", $time);
        end
    end

endmodule // monitor_complex_multiplier