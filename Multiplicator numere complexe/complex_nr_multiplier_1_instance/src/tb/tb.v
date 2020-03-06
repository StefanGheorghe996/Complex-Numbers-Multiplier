// Module:  complex_nr_mult_tb
// Author:  Gheorghe Stefan
// Date:    06.03.2020

module complex_nr_mult_tb#(
    parameter DATA_WIDTH    = 8,
    parameter OP_1_RE       = 'd2,
    parameter OP_1_IM       = 'd4,
    parameter OP_2_RE       = 'd3,
    parameter OP_2_IM       = 'd6,
)(
    input   clk     , // clock signal
    input   rstn    , // asynchronous reset active 0

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
        input op_1_re_value;
        input op_1_im_value;
        input op_2_re_value;
        input op_2_im_value;

        always @(posedge clk)
        begin
            op_1_re <= op_1_re_value;
            op_1_im <= op_1_im_value;
            op_2_re <= op_2_re_value;
            op_2_im <= op_2_im_value;
        end
    endtask

endmodule // complex_nr_mult_tb