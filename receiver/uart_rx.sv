`timescale 1ns/1ps

module uart_rx #(
    parameter int CLK_FREQ = 50_000_000,
    parameter int BAUD     = 115200
)(
    input  logic       clk,
    input  logic       rst_n,
    input  logic       rx,
    output logic [7:0] data_out,
    output logic       valid
);

    localparam int BAUD_CNT = CLK_FREQ / BAUD;
    logic [15:0] cnt;
    logic [3:0]  bit_idx;
    logic        rx_d, sampling, busy;
    logic [1:0]  rx_sync;

    // Synchronize rx
    always_ff @(posedge clk) begin
        rx_sync <= {rx_sync[0], rx};
        rx_d    <= rx_sync[1];
    end

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            busy     <= 0;
            sampling <= 0;
            cnt      <= 0;
            bit_idx  <= 0;
            data_out <= 0;
            valid    <= 0;
        end else begin
            valid <= 0;
            if (!busy) begin
                if (!rx_d) begin // start bit detected
                    busy     <= 1;
                    sampling <= 1;
                    cnt      <= BAUD_CNT/2;
                    bit_idx  <= 0;
                end
            end else begin
                if (cnt == 0) begin
                    cnt <= BAUD_CNT - 1;
                    if (sampling) begin
                        if (bit_idx < 8) begin
                            data_out[bit_idx] <= rx_d;
                            bit_idx <= bit_idx + 1;
                        end else begin
                            busy     <= 0;
                            sampling <= 0;
                            valid    <= 1;
                        end
                    end
                end else begin
                    cnt <= cnt - 1;
                end
            end
        end
    end
endmodule
