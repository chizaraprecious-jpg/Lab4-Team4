module control_unit (
    input logic [6:0] opcode_i,
    input logic [2:0] funct3_i,
    input logic [6:0] funct7_i,
    input logic eq_i,

    output logic [3:0] alu_opc_o,
    output logic alu_src_o,
    output logic pc_src_o,
    output logic imm_src_o,
    output logic rd_we_o
);

    function automatic logic [3:0] decode_alu_op_imm (
        input logic [2:0] funct3,
        input logic [6:0] funct7
    );
        case (funct3)
            3'b000: return 4'd0;
            3'b001: return 4'd5;
            3'b010: return 4'd8;
            3'b011: return 4'd9;
            3'b100: return 4'd4;
            3'b101: return (funct7[5]? 4'd7 : 4'd6);
            3'b110: return 4'd3;
            3'b111: return 4'd2;
            default: return 4'd0;
        endcase
    endfunction

    always_comb begin
        case (opcode_i)
            // OP_ALU_IMM
            7'b0010011: begin
                alu_opc_o = decode_alu_op_imm(funct3_i, funct7_i);
                alu_src_o = 1'b1;
                pc_src_o = 1'b0;
                imm_src_o = 1'b0;
                rd_we_o = 1'b1;
            end
            
            // OP_BRANCH
            7'b1100011: begin
                alu_opc_o = 4'd0;
                alu_src_o = 1'b0;
                pc_src_o = ((funct3_i == 3'b001) && !eq_i);
                imm_src_o = 1'b1;
                rd_we_o = 1'b0;
            end
            
            // Default to NOP
            default: begin
                alu_opc_o = 4'd0;
                alu_src_o = 1'b0;
                pc_src_o = 1'b0;
                imm_src_o = 1'b0;
                rd_we_o = 1'b0;
            end
        endcase
    end

endmodule