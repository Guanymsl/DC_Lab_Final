`timescale 1ns/1ps

module csv_parser (
    input  logic        clk,
    input  logic        rst_n,
    input  logic [ 7:0] char_in,
    input  logic        char_val,
    output logic [15:0] ax1, ay1, az1,
    output logic [15:0] ax2, ay2, az2,
    output logic [11:0] jx, jy,
    output logic        btn,
    output logic        frame_done
);

    typedef enum logic [3:0] {S0,S1,S2,S3,S4,S5,S6,S7} state_t;
    state_t      state;
    logic [31:0] acc;

    localparam byte SEP_COMMA = 8'h2C; // ','
    localparam byte SEP_SEMIC = 8'h3B; // ';'
    localparam byte SEP_NL    = 8'h0A; // '\n'

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state      <= S0;
            acc        <= 0;
            ax1 <= 0; ay1 <= 0; az1 <= 0;
            ax2 <= 0; ay2 <= 0; az2 <= 0;
            jx  <= 0; jy  <= 0;
            btn <= 0;
            frame_done <= 0;
        end else begin
            frame_done <= 0;
            if (char_val) begin
                if (char_in >= "0" && char_in <= "9") begin
                    acc <= acc * 10 + (char_in - "0");
                end else begin
                    case (state)
                        S0: ax1 <= acc;
                        S1: ay1 <= acc;
                        S2: az1 <= acc;
                        S3: ax2 <= acc;
                        S4: ay2 <= acc;
                        S5: az2 <= acc;
                        S6: jx  <= acc;
                        S7: jy  <= acc;
                    endcase

                    if      (char_in == SEP_COMMA) state <= state + 1;
                    else if (char_in == SEP_SEMIC) state <= S3;
                    else if (char_in == SEP_NL) begin
                        btn         <= acc;
                        frame_done  <= 1;
                        state       <= S0;
                    end
                    acc <= 0;
                end
            end
        end
    end
endmodule
