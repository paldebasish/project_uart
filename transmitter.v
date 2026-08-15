module transmitter (
    input clk,rst,wr_enb,enb,
    input [7:0] data_in,
    output reg tx,
    output busy
);

parameter IDLE = 2'b00, START = 2'b01, DATA = 2'b10, STOP = 2'b11;

reg [1:0] state;
reg [2:0] index;
reg [7:0] data_out;
assign busy = (state != IDLE) ? 1'b1 : 1'b0;
always @(posedge clk or posedge rst) begin
    if(rst) begin
        state <= IDLE;
        index <= 0;
        data_out <= 8'b0;
        tx <= 1'b1; // Idle state of TX is high
    end else begin
        case(state)
            IDLE: begin
                tx <= 1'b1; // Idle state of TX is high
                if(wr_enb) begin
                    state<= START;
                    data_out <= data_in;
                    index <= 3'b0;
                end
                else begin
                    state <= IDLE;
                    tx <= 1'b1; 
                end
            end
            START: begin
                if(enb) begin
                    state <= DATA;
                tx <= 1'b0; // Start bit
                end
                else begin
                    state <= START;
                end
            end
            DATA: begin
                if(enb) begin
                    if (index <= 3'd7) begin
                        state <= STOP;
                        else begin
                            tx <= data_out[index]; // Transmit data bit
                            index <= index + 1'b1;
                        end
                    end
                end
            end
            STOP: begin
                if(enb) begin
                    tx <= 1'b1; // Stop bit
                    state <= IDLE;
                end
            end
            default : begin
                state <= IDLE;
            tx <= 1'b1; 
            end
        endcase
    end
end

    
endmodule