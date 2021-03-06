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
    input                       op_ready        ,
    input [4*DATA_WIDTH-1 : 0]  op_data         ,

    input                       res_val         ,
    input                       res_ready       ,
    input [4*DATA_WIDTH+2 : 0]  res_data
);

    //Internal registers for checking the functionality
    reg  [DATA_WIDTH*2-1 : 0] predicted_result_re;
    reg  [DATA_WIDTH*2-1 : 0] predicted_result_im;
    wire [DATA_WIDTH*2-1 : 0] result_re;
    wire [DATA_WIDTH*2-1 : 0] result_im;

    assign result_re = res_data [4*DATA_WIDTH-1 : 2*DATA_WIDTH];
    assign result_im = res_data [2*DATA_WIDTH-1 : 0];

    always @(posedge clk or negedge rstn)
    begin
        if(~rstn) predicted_result_re <= 'b0;
        else if(sw_rst) predicted_result_re <= 'b0;
        else if(op_val) predicted_result_re <= (op_data[4*DATA_WIDTH-1 : 3*DATA_WIDTH] * op_data[2*DATA_WIDTH-1 : DATA_WIDTH]) - (op_data[3*DATA_WIDTH-1 : 2*DATA_WIDTH] * op_data[DATA_WIDTH-1 : 0]);
    end

    always @(posedge clk or negedge rstn)
    begin
        if(~rstn) predicted_result_im <= 'b0;
        else if(sw_rst) predicted_result_im <= 'b0;
        else if(op_val) predicted_result_im <= (op_data[4*DATA_WIDTH-1 : 3*DATA_WIDTH] * op_data[DATA_WIDTH-1 : 0]) + (op_data[3*DATA_WIDTH-1 : 2*DATA_WIDTH] * op_data[2*DATA_WIDTH-1 : DATA_WIDTH]);
    end

    always @(posedge clk)
    begin
        if (res_ready && res_val) begin
            if(result_re == predicted_result_re)
                $display(" %t - REAL PART OF THE RESULT IS COMPUTED CORRECTLY - EXPECTED VALUE = %d, DUT GENERATED VALUE = %d", $time,predicted_result_re,result_re);
            else
            begin
                $display(" %t - REAL PART OF THE RESULT WAS NOT COMPUTED CORRECTLY- EXPECTED VALUE = %d, DUT GENERATED VALUE = %d", $time,predicted_result_re,result_re);
                $stop;
            end
        end
    end
    
    always @(posedge clk)
    begin
        if (res_ready && res_val) begin
            if(result_im == predicted_result_im)
                $display(" %t - IMAGINARY PART OF THE RESULT IS COMPUTED CORRECTLY - EXPECTED VALUE = %d, DUT GENERATED VALUE = %d", $time,predicted_result_im,result_im);
            else
            begin
                $display(" %t - IMAGINARY PART OF THE RESULT WAS NOT COMPUTED CORRECTLY - EXPECTED VALUE = %d, DUT GENERATED VALUE = %d", $time,predicted_result_im,result_im);
                $stop;
            end
        end
    end

endmodule // monitor_complex_multiplier