import game_param::*;
import sram_param::*;

module BadBullet (
    input  logic               clk,
    input  logic               rst_n,

    input  logic               attack,
    input  logic               defend,
    input  logic signed [10:0] xEnemy,
    input  logic signed [ 9:0] yEnemy,

    input  logic signed [10:0] xPlayer,
    input  logic signed [ 9:0] yPlayer,
    input  logic               isQ,

    output logic signed [10:0] x,
    output logic signed [ 9:0] y,
    output logic               isE,
    output logic               isHit
);

    logic signed [10:0] x_r, x_w;
    logic signed [ 9:0] y_r, y_w;
    logic               isE_r, isE_w;

    assign x    = x_r;
    assign y    = y_r;
    assign isE  = isE_r;

    always_comb begin
        x_w    = x_r;
        y_w    = y_r;
        isE_w  = isE_r;
        isHit  = 0;

        if (isE_r) begin
            x_w = x_r - BULLET_STEP_X;
            if (isQ) begin
                if ((x_w - BULLET_X < xPlayer + PLAYER_X) && !((y_w - BULLET_Y > yEnemy + SQUAT_PLAYER_Y) || (y_w + BULLET_Y < yEnemy - SQUAT_PLAYER_Y))) begin
                    isHit = 1;
                    isE_w = 0;
                end
            end else begin
                if ((x_w + BULLET_X > xEnemy - PLAYER_X) && !((y_w - BULLET_Y > yEnemy + PLAYER_Y) || (y_w + BULLET_Y < yEnemy - PLAYER_Y))) begin
                    isHit = 1;
                    isE_w = 0;
                end
            end

            if (x_w < -MAP_X + BULLET_X) begin
                isE_w = 0;
            end
        end else begin
            if (!defend && attack) begin
                isE_w  = 1;
                x_w    = xEnemy - PLAYER_X - BULLET_X;
                y_w    = yEnemy;
            end
        end
    end

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            x_r    <= xEnemy - PLAYER_X - BULLET_X;
            y_r    <= yEnemy;
            isE_r  <= 0;
        end else begin
            x_r    <= x_w;
            y_r    <= y_w;
            isE_r  <= isE_w;
        end
    end

endmodule