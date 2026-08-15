module uart_main (
    input clk,rst, wr_enb,rdy_clr,
    input [7:0] data_in,
    output rdy,busy,
    output [7:0] data_out
);

wire tx_clk_enb,rx_clk_enb;

wire tx_temp;

baud_rate_generator bg (clk,rst,tx_clk_enb,rx_clk_enb);
transmitter ut (clk,rst,wr_enb,tx_clk_enb,data_in,tx_temp,busy);
receiver ur (clk,rst,tx_temp,rx_clk_enb,rdy_clr,data_out,rdy);
    
endmodule


module uart_main_tb;
 reg clk,rst ;
 reg [7:0] data_in;
 reg wr_enb,rdy_clr;
 wire rdy,busy;
wire [7:0] data_out;

uart_main uut(clk,rst,wr_enb,rdy_clr,data_in,rdy,busy,data_out);

initial begin
    { clk,rst,rdy_clr,data_in} = 0;
end

always #5 clk = ~clk;

task send_data(input [7:0] data);
    begin
        @(posedge clk);
        wr_enb = 1'b1;
        data_in = data;
        @(posedge clk);
        wr_enb = 1'b0;
    end
endtask

task clr_ready;
    begin
        @(posedge clk);
        rdy_clr = 1'b1;
        @(posedge clk);
        rdy_clr = 1'b0;
    end
endtask

initial begin
    @(posedge clk);
    rst = 1'b1;
    @(posedge clk);
    rst = 1'b0;

    send_data(8'h38);
    wait(busy == 1'b0);
    wait(rdy == 1'b10);
    $display ("Data received: %h", data_out);
    clr_ready;

    send_data(8'hA5);
    wait(busy == 1'b0);
    wait(rdy == 1'b1);
    $display ("Data received: %h", data_out);
    clr_ready;

 #400 $finish;
end
endmodule