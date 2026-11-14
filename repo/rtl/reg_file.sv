module reg_file #(
    parameter   DATA_WIDTH = 32,
                ADDRESS_WIDTH = 5
)(
    input logic                         clk,
    input logic                         wen,
    input logic     [ADDRESS_WIDTH-1:0] r_ad1, 
    input logic     [ADDRESS_WIDTH-1:0] r_ad2,
    input logic     [ADDRESS_WIDTH-1:0] w_ad,
    input logic     [DATA_WIDTH-1:0]    wd,
    output logic    [DATA_WIDTH-1:0]    rd1,
    output logic    [DATA_WIDTH-1:0]    rd2
);

logic [DATA_WIDTH-1:0] registers[2**ADDRESS_WIDTH-1:0];

assign registers[{ADDRESS_WIDTH{1'b0}}] = {DATA_WIDTH{1'b0}}; //sets zero reg to 0

always_comb //asynchronous read
    assign rd1 = registers[r_ad1];
    assign rd2 = registers[r_ad2];

always_ff @(posedge clk) begin //synchronous write
    if (wen && w_ad != {ADDRESS_WIDTH{1'b0}}) 
        registers[w_ad] <= wd;
end

endmodule
