module rx #(
    parameter integer PULSES_BIT = 28
)(
    clk,
    rst_n,
    data_rx,
    data_out,
    valid
);
    input  logic       clk;
    input  logic       rst_n;
    input  logic       data_Rx;
    output logic [7:0] data_out;
    output logic       valid;

    logic sig_C_Rx, sig_Rx;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sig_C_Rx <= 1'b1;
            sig_Rx   <= 1'b1;
        end else begin
            sig_C_Rx <= data_Rx;
            sig_Rx   <= sig_C_Rx;
        end
    end

    localparam IDLE   = 3'd0;
    localparam START  = 3'd1;
    localparam RCV    = 3'd2;
    localparam PARITY = 3'd3;
    localparam STOP   = 3'd4;

    reg [ 2:0] state_r, state_w;
    reg [15:0] cnt_r, cnt_w;
    reg [ 2:0] bit_dta_r, bit_dta_w;
    reg [ 7:0] data_rcv;
    reg        data_fin;

    assign valid = data_fin;
    assign data_out = (data_fin) ? data_rcv : 0;

    always_comb begin
        state_w = state_r;
        case (state_r)
            IDLE: begin
                state_w = (sig_Rx == 1'b0) ? START : IDLE;
                cnt_w   = 0;
            end

            START: begin
                if (cnt_r < (PULSES_BIT/2 - 1)) begin
                    cnt_w = cnt_r + 1;
                end else begin
                    if (sig_Rx == 1'b0) begin
                        cnt_w = 0;
                        state_w = RCV;
                    end else begin
                        state_w = IDLE;
                    end
                end
            end

            RCV: begin
                if (cnt_r < (PULSES_BIT - 1)) begin
                    cnt_w = cnt_r + 1;
                end else begin
                    cnt_w = 0;
                    dta_rcv[bit_dta_r] = sig_Rx;
                    if (bit_dta_r < 7) begin
                        bit_dta_w = bit_dta_r+ 1;
                    end else begin
                        bit_dta_w = 0;
                        state_w = PARITY;
                    end
                end
            end

            PARITY: begin
                state_w = STOP;
            end

            STOP: begin
                dat_fin = 1'b1;
                state_w = IDLE;
            end
        endcase
    end

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state_r <= IDLE;
            cnt_r   <= 0;
            bit_dta <= 0;
            dat_fin <= 1'b0;
        end else begin
            state_r <= state_w;
            cnt_r   <= cnt_w;
            bit_dta <= bit_dta_w;
        end
    end

endmodule
