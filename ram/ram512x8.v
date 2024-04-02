module ram512x8
(
    input [8:0] RADDR,
    input RCLK,
    input RE,
    output reg [7:0] RDATA,
    input [7:0] WDATA,
    input [8:0] WADDR,
    input WCLK,
    input WE
);
    reg [7:0] memory [0:511];

    integer i;

    initial begin
        for(i = 0; i < 512; i++)// start with blank memory with 0 instead of x so that we can infer Yosys for BRAM.
            memory[i] <= 8'd0;
    end

    always @(posedge RCLK)
    begin
        if (RE)
        begin
            RDATA <= memory[RADDR];
        end
    end

    always @(posedge WCLK)
    begin
        if (WE)
        begin
            memory[WADDR] <= WDATA;
        end
    end
endmodule
