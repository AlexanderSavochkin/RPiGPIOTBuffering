`timescale 10ns/1ns

module buffer_to_parallel_data_test_tb;

    reg clk = 0;
    reg rst = 0;
    reg data_req = 0;
    wire data_rdy;
    wire [23:0] data_out;

    always begin
        clk = ~clk;
        #1;
    end

    buffer_to_parallel_data_test buffer_to_parallel_data_test_uut (
        .ref_clk(clk),
        .rst(rst),
        .data_req(data_req),
        .data_rdy(data_rdy),
        .data_out(data_out)
    );

    initial begin
        #6
        rst = 1;
        #6
        rst = 0;
        #6
        data_req = 1;
        #40
        data_req = 0;
        #60
        data_req = 1;
        #40
        data_req = 0;
        #60
        data_req = 1;
        #40
        data_req = 0;
        #60
        data_req = 1;
        #40;
        data_req = 0;
        #60
        data_req = 1;
        #40
        data_req = 0;
        #60
        data_req = 1;
        #40;
        data_req = 0;
        #60
        data_req = 1;
        #40;
        data_req = 0;
        #60
        data_req = 1;
        #40;
        data_req = 0;
        #60
        data_req = 1;
        #40;
    end


    initial begin
        $dumpfile("buffer_to_parallel_data_test_tb.vcd");
        $dumpvars(0, buffer_to_parallel_data_test_tb);
        #2500 
        $display("Simulation finished");
        $finish;
    end

endmodule
