module rx #(
    parameter integer PULSES_BIT = 28
)(
    clk,
    rst_n,
    data_Rx,
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

    logic [ 2:0] state_r, state_w;
    logic [15:0] cnt_r, cnt_w;
    logic [ 2:0] bit_cnt_r, bit_cnt_w;
    logic [7 :0] data_rcv_r, data_rcv_w;
    logic        data_fin_r, data_fin_w;

    always_comb begin
        state_w    = state_r;
        cnt_w      = cnt_r;
        bit_cnt_w  = bit_cnt_r;
        data_rcv_w = data_rcv_r;
        data_fin_w = 1'b0;

        case (state_r)
            IDLE: begin
                cnt_w   = 0;
                if (sig_Rx == 1'b0)
                    state_w = START;
            end

            START: begin
                if (cnt_r < (PULSES_BIT/2 - 1)) begin
                    cnt_w = cnt_r + 1;
                end else begin
                    cnt_w = 0;
                    if (sig_Rx == 1'b0) begin
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
                    data_rcv_w[bit_cnt_r] = sig_Rx;
                    if (bit_cnt_r < 7) begin
                        bit_cnt_w = bit_cnt_r + 1;
                    end else begin
                        bit_cnt_w = 0;
                        state_w   = PARITY;
                    end
                end
            end

            PARITY: begin
                state_w = STOP;
            end

            STOP: begin
                data_fin_w = 1'b1;
                state_w    = IDLE;
            end
        endcase
    end

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state_r     <= IDLE;
            cnt_r       <= 0;
            bit_cnt_r   <= 0;
            data_rcv_r  <= 8'h00;
            data_fin_r  <= 1'b0;
            data_out    <= 8'h00;
            valid       <= 1'b0;
        end else begin
            state_r     <= state_w;
            cnt_r       <= cnt_w;
            bit_cnt_r   <= bit_cnt_w;
            data_rcv_r  <= data_rcv_w;
            data_fin_r  <= data_fin_w;
            if (data_fin_w) begin
                data_out <= data_rcv_w;
                valid    <= 1'b1;
            end else begin
                valid    <= 1'b0;
            end
        end
    end
endmodule
