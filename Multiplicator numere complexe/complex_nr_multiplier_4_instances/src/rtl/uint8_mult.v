//  Module: uint8_mult
//
module uint8_mult
#(
    parameter DATA_WIDTH = 8
)
    (
        input   [DATA_WIDTH -1:0]   op1,
        input   [DATA_WIDTH -1:0]   op2,
        output  [2*DATA_WIDTH-1:0]  result
    );

    assign result =  op1 * op2;

    
endmodule
