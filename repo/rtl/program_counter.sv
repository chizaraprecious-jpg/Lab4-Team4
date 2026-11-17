module program_counter #(
    parameter DATA_WIDTH = 32
)(
    input logic clk,
    input logic rst,
    input logic pc_src,
    input logic[DATA_WIDTH-1:0] imm_op,
    output logic[DATA_WIDTH-1:0] pc
);

logic [DATA_WIDTH-1:0] inc_pc;
logic [DATA_WIDTH-1:0] branch_pc;
logic [DATA_WIDTH-1:0] next_pc;


assign branch_pc = imm_op + pc;
assign inc_pc = pc + 32'd4;
assign next_pc = pc_src ? branch_pc : inc_pc;

always_ff @(posedge clk) begin 
    if (rst)
        pc <= 32'b0;
    else 
        pc <= next_pc;
end 

endmodule




