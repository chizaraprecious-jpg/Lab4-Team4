module reg_file_alu #(
    parameter   DATA_WIDTH = 32,
                ADDRESS_WIDTH = 5,
                OPC_WIDTH = 4
)(
    input   logic                       clk,
    input   logic                       wen,
    input   logic                       alu_src,
    input   logic [ADDRESS_WIDTH-1:0]   r_ad1,
    input   logic [ADDRESS_WIDTH-1:0]   r_ad2,
    input   logic [ADDRESS_WIDTH-1:0]   w_ad,
    input   logic [DATA_WIDTH-1:0]      imm_op,
    input   logic [OPC_WIDTH-1:0]       alu_opc,
    output  logic                       eq    
);

logic [DATA_WIDTH-1:0]  wd;
logic [DATA_WIDTH-1:0]  rd1;
logic [DATA_WIDTH-1:0]  rd2;
logic [DATA_WIDTH-1:0]  op2;

reg_file reg_file(
    .clk(clk),
    .wen(wen),
    .r_ad1(r_ad1),
    .r_ad2(r_ad2),
    .w_ad(w_ad),
    .wd(wd),
    .rd1(rd1),
    .rd2(rd2)
);

mux operand_mux(
    .in0(rd2),
    .in1(imm_op),
    .sel(alu_src),
    .out(op2)
);

alu alu(
    .operand1(rd1),
    .operand2(op2),
    .alu_opc(alu_opc),
    .alu_out(wd),
    .eq(eq)
);

endmodule
