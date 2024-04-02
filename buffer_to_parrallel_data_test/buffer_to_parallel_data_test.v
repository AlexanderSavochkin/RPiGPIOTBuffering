`include "../parallel_io_fsm/parallel_exchange_fsm.v"
`include "../ram/ram512x8.v"

module buffer_to_parallel_data_test
(
    input ref_clk,  //ICEStick 12MHz clock
    input rst,
    input data_req,
    output data_rdy,
    output [23:0] data_out
);
    wire [8:0] r_addr;
    wire r_en;

    wire [23:0] memory_read_value;
    reg [8:0] w_addr;
    reg [7:0] w_data;
    reg [4:0] counter;
    reg [7:0] counter2;
    reg w_en;


    ram512x8 ram512X8_inst_0 ( 
        .RDATA(memory_read_value[7:0]), 
        .RADDR(r_addr),
        .RCLK(ref_clk),

        .RE(r_en), 
        .WADDR(w_addr),
        .WCLK(ref_clk),

        .WDATA(w_data),
        .WE(w_en)
    );

    ram512x8 ram512X8_inst_1 ( 
        .RDATA(memory_read_value[15:8]),
        .RADDR(r_addr),
        .RCLK(ref_clk),

        .RE(r_en), 
        .WADDR(w_addr),
        .WCLK(ref_clk),

        .WDATA(w_data),
        .WE(w_en) 
    );

    ram512x8 ram512X8_inst_2 ( 
        .RDATA(memory_read_value[23:16]), 
        .RADDR(r_addr),
        .RCLK(ref_clk),

        .RE(r_en), 
        .WADDR(w_addr),
        .WCLK(ref_clk), 

        .WDATA(w_data),
        .WE(w_en) 
    );


    parallel_exchange_fsm parallel_exchange_fsm_inst
    (
        .rst(rst),                  //Reset
        .clk(ref_clk),                  //12 MHz iCEstick clock
        .w_addr,         //Current writing position so we know how much data is available

    //Interaction with memory 
        .r_addr(r_addr),    //Reading address in buffer
        .r_en(r_en),            //Read enable
        .memory_read_value(memory_read_value), //

    //Interaction with downstream device
        .data_req(data_req),             //Data request signal 
        .data_out(data_out), //Output data
        .data_ready(data_rdy)       //Data ready signal
    );


    always @(posedge ref_clk) begin
        if (rst) begin
            w_addr <= 9'b0;
            counter <= 0;
            counter2 <= 0;
            w_en <= 0;
        end
        else begin
            if (counter == 3) begin
                counter <= 0;
                w_data <= ~counter2;
            end else if (counter == 4) begin
                w_en <= 1;
            end else if (counter == 5) begin
                w_en <= 0;
            end else if (counter == 6) begin
                counter2 <= counter2 + 1;
                w_addr <= w_addr + 1;
            end

            counter <= counter + 1;
        end
    end


endmodule

