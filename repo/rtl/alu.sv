module alu #(
    parameter   DATA_WIDTH = 32,
                OPC_WIDTH = 4
)(
    input   logic   [DATA_WIDTH-1:0]    operand1,
    input   logic   [DATA_WIDTH-1:0]    operand2,
    input   logic   [OPC_WIDTH-1:0]     alu_opc,
    output  logic   [DATA_WIDTH-1:0]    alu_out,
    output  logic                       eq
);

assign eq = operand1 == operand2;

always_comb
    case (alu_opc)
        OPC_WIDTH'(0): alu_out = operand1 + operand2;                           //ADD
        OPC_WIDTH'(1): alu_out = operand1 - operand2;                           //SUB
        OPC_WIDTH'(2): alu_out = operand1 & operand2;                           //AND
        OPC_WIDTH'(3): alu_out = operand1 | operand2;                           //OR
        OPC_WIDTH'(4): alu_out = operand1 ^ operand2;                           //XOR
        OPC_WIDTH'(5): alu_out = operand1 << operand2[DATA_WIDTH-1:0];          //logical shift left (max by 32 bits)
        OPC_WIDTH'(6): alu_out = operand1 >> operand2[DATA_WIDTH-1:0];          //logical shift right
        OPC_WIDTH'(7): alu_out = $signed(operand1) >>> operand2;                //arithmetic shift right
        OPC_WIDTH'(8): alu_out = $signed(operand1) < $signed(operand2) ? 1 : 0; //SLT
        OPC_WIDTH'(9): alu_out = operand1 < operand2 ? 1 : 0;                   //SLTU
        default: alu_out = DATA_WIDTH'(0);
    endcase

endmodule
