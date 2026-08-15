module baud_rate_generator (
    input clk,
    output reg tx_enb,rx_enb,
);
    reg [7:0] tx_counter,rx_counter;

always @(posedge clk) begin
    if(tx_counter == 5208)
    begin
        tx_counter <= 0;
    end
    else begin 
        tx_counter <= tx_counter + 1'b1;
    end
end
    
always @(posedge clk) begin
    if(rx_counter == 325)
    begin
        rx_counter <= 0;
    end
    else begin
        rx_counter <= rx_counter + 1'b1;
    end
end

assign tx_enb = (tx_counter == 5208) ? 1'b1 : 1'b0;
assign rx_enb = (rx_counter == 325) ? 1'b1 : 1'b0;
endmodule