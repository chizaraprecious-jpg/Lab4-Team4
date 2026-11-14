module top #(
    DATA_WIDTH = 32
) (
    input   logic clk,
    input   logic rst,
    output  logic [DATA_WIDTH-1:0] a0    
);
    assign a0 = 32'd5;

    logic [31:0] instr; // TEMPORARY UNTIL MEMORY IN PLACE

    // Immediate sign extension (B-type, I-type)
    logic [DATA_WIDTH-1:0] imm_op;
    logic imm_src;
    assign imm_op = (imm_src ? {{19{instr[31]}}, instr[31], instr[7], instr[30:25], instr[11:8], 1'b0} : {{20{instr[31]}}, instr[31:20]}); 

    // Program counter
    logic [DATA_WIDTH-1:0] pc;
    logic pc_src;

    program_counter program_counter (
        .clk(clk),
        .rst(rst),
        .pc_src(pc_src),
        .imm_op(imm_op),
        .pc(pc)
    );

    // Register file
    logic wen;
    logic [DATA_WIDTH-1:0] rd1, rd2, wd;

    logic [4:0] r_ad1, r_ad2, w_ad;
    assign r_ad1 = instr[19:15];
    assign r_ad2 = instr[24:20];
    assign w_ad = instr[11:7];

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

    // Control unit
    logic eq;
    logic [3:0] alu_opc;
    logic alu_src;

    control_unit control_unit (
        .opcode_i(instr[6:0]),
        .funct3_i(instr[14:12]),
        .funct7_i(instr[31:25]),
        .eq_i(eq),
        .alu_opc_o(alu_opc),
        .alu_src_o(alu_src),
        .pc_src_o(pc_src),
        .imm_src_o(imm_src),
        .rd_we_o(wen)
    );

    // Operand 2 MUX
    logic [DATA_WIDTH-1:0] op2;
    assign op2 = (alu_src ? imm_op : rd2);

    // ALU
    alu alu(
        .operand1(rd1),
        .operand2(op2),
        .alu_opc(alu_opc),
        .alu_out(wd),
        .eq(eq)
    );
endmodule
