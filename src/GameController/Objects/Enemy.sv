import game_param::*;
import sram_param::*;

module Enemy (
    input  logic               clk,
    input  logic               rst_n,
    input  logic               right,
    input  logic               left,
    input  logic               jump,
    input  logic               squat,
    input  logic               defend,
    output logic signed [10:0] x,
    output logic signed [ 9:0] y,
    output logic               isD,
    output logic               isQ,
    output logic               isJ
);

    logic signed [10:0] x_r, x_w;
    logic signed [ 9:0] y_r, y_w;
    logic               isJ_r, isJ_w;
    logic        [ 7:0] Jcnt_r, Jcnt_w;

    assign x   = x_r;
    assign y   = y_r;
    assign isD = defend;
    assign isQ = (isJ_r) ? 0 : squat;
    assign isJ = isJ_r;

    always_comb begin
        x_w = x_r;
        if (right) begin
            x_w = x_r + STEP_X;
        end else if (left) begin
            x_w = x_r - STEP_X;
        end

        if (x_w > MAP_X - PLAYER_X) begin
            x_w = MAP_X - PLAYER_X;
        end else if (x_w < MAP_X - LIMIT_X) begin
            x_w = MAP_X - LIMIT_X;
        end
    end

    always_comb begin
        y_w    = y_r;
        isJ_w  = isJ_r;
        Jcnt_w = Jcnt_r;

        if (isJ_r) begin
            y_w = -MAP_Y + PLAYER_Y + V * Jcnt_r - (Jcnt_r * Jcnt_r) >>> 2;
            if (y_w < -MAP_Y + PLAYER_Y) begin
                y_w = -MAP_Y + PLAYER_Y;
                isJ_w  = 0;
                Jcnt_w = 0;
            end else begin
                Jcnt_w = Jcnt_r + 1;
            end
        end else begin
            if (jump) begin
                isJ_w   = 1;
                Jcnt_w  = 0;
            end
            y_w = -MAP_Y + PLAYER_Y;
        end
    end

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            x_r     <= MAP_X - PLAYER_X;
            y_r     <= -MAP_Y + PLAYER_Y;
            isJ_r   <= 0;
            Jcnt_r  <= 0;
        end else begin
            x_r     <= x_w;
            y_r     <= y_w;
            isJ_r   <= isJ_w;
            Jcnt_r  <= Jcnt_w;
        end
    end

endmodule
