module receiver (
    input clk,rst,rx,clk_enb,rdy_clr,
    output reg [7:0] data_out,
    output reg rdy
);

parameter START = 2'b00, DATA = 2'b01, STOP = 2'b10;

reg [2:0] index;
reg [3:0] sample;
reg [1:0] state;
reg [7:0] temp_reg;

always @(posedge clk) begin
    if(rst) begin
        rdy <= 1'b0;
        state <= START;
        data_out <= 8'b0;
        index <= 2'b0;
        sample <= 3'b0;
        temp_reg <= 8'b0;
    end
end
    always @(posedge clk) begin
        if(rdy_clr) begin
            rdy <= 1'b0;
        end
        if (clk_enb) begin
        case(state)
            START: begin
                if(rx == 1'b0 && sample != 4'b0) begin // Start bit detected
                    sample = sample +1'b1;
                    if(sample == 4'hf) begin
                        sample <= 4'b0;
                        index <= 3'b0;
                        temp_reg <= 8'b0;
                        state <= DATA;
                    end
                end
            end
            DATA: begin
                sample = sample + 1'b1;
                if(sample == 4'h8) begin
                    temp_reg[index] <= rx; // Sample the data bit
                    index <= index + 1'b1;
                    
                end
                if (index == 3'd7 && sample == 4'hf) begin
                    state <= STOP;
                    
                end
            end
            STOP: begin
                sample = sample +1'b1;
                if(sample == 4'hf) begin
                    sate <= START;
                    data_out <= temp_reg;
                    rdy <= 1'b1; 
                    sample <= 4'b0;
                end
            end
            default: begin
                state <= START;
            end
        endcase
    end
end

endmodule