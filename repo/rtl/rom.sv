parameter int ROM_ADDR_WIDTH = 8;
parameter int ROM_DATA_WIDTH = 32;
parameter int ROM_DEPTH = 1 << ROM_ADDR_WIDTH;


module rom #(
    parameter string HEX_FILE = "rom.txt"
) (
    input [ROM_ADDR_WIDTH-1:0] addr_i,
    
    output [ROM_DATA_WIDTH-1:0] data_o
);

    logic [ROM_DATA_WIDTH-1:0] mem [0:ROM_DEPTH-1];
    
    initial begin
        $readmemh(HEX_FILE, mem);
    end

    assign data_o = mem[addr_i[ROM_ADDR_WIDTH:2]]

endmodule