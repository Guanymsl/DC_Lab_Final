import game_pkg::*;
import sram_pkg::*;

module GameControl (
    input logic clk,
    input logic render_clk,
    input logic rst_n,

    input logic right,
    input logic left,
    input logic jump,
    input logic squat,
    input logic attack,
    input logic defend,
    input logic select,

    output logic [1:0]             o_state,
    output logic [POS_WIDTH-1:0]   o_player_x,
    output logic [POS_WIDTH-1:0]   o_player_y,
    output logic [1:0]             o_player_hp,
    output logic                   o_player_shield,
    output logic                   o_player_squat,
    output logic [POS_WIDTH-1:0]   o_enemy_x,
    output logic [POS_WIDTH-1:0]   o_enemy_y,
    output logic [1:0]             o_enemy_hp,
    output logic                   o_enemy_shield,
    output logic                   o_enemy_squat
    output logic [POS_WIDTH-1:0]   o_goodbullet_x,
    output logic [POS_WIDTH-1:0]   o_goodbullet_y,
    output logic                   o_goodbullet_isE,
    output logic [POS_WIDTH-1:0]   o_badbullet_x,
    output logic [POS_WIDTH-1:0]   o_badbullet_y,
    output logic                   o_badbullet_isE
);

    localparam S_START = 2'b00;
    localparam S_PLAY  = 2'b01;
    localparam S_WIN   = 2'b10;
    localparam S_LOSE  = 2'b11;

    logic [1:0] state_r, state_w;

    always_comb begin
        state_w = state_r;
        case (state_r)
            S_START:
                if (select) state_w = S_PLAY;
            S_PLAY: begin
                if (player_hp_r == 0) begin
                    state_w = S_LOSE;
                end else if (enemy_hp_r == 0) begin
                    state_w = S_WIN;
                end
            end
            S_WIN, S_LOSE:
                if (select) state_w = S_START;
        endcase
    end

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state_r <= S_START;
        end else begin
            state_r <= state_w;
        end
    end

    logic rightRd, leftRd, jumpRd, squatRd, attackRd, defendRd;

    .Player player (
        .clk(clk),
        .rst_n(rst_n),
        .right(right),
        .left(left),
        .jump(jump),
        .squat(squat),
        .attack(attack),
        .defend(defend),
        .x(o_player_x),
        .y(o_player_y),
        .hp(o_player_hp),
        .shield(o_player_shield),
        .squat(o_player_squat)
    );

    .Enemy enemy (
        .clk(clk),
        .rst_n(rst_n),
        .right(rightRd),
        .left(leftRd),
        .jump(jumpRd),
        .squat(squatRd),
        .attack(attackRd),
        .defend(defendRd),
        .x(o_enemy_x),
        .y(o_enemy_y),
        .hp(o_enemy_hp),
        .shield(o_enemy_shield),
        .squat(o_enemy_squat)
    );

    .GoodBullet goodbullet (
        .clk(clk),
        .rst_n(rst_n),
        .attack(attack),
        .defend(defend),
        .xPlayer(o_player_x),
        .yPlayer(o_player_y),
        .x(o_goodbullet_x),
        .y(o_goodbullet_y),
        .isE(o_goodbullet_isE)
    );

    .BadBullet badbullet (
        .clk(clk),
        .rst_n(rst_n),
        .attack(attackRd),
        .defend(defendRd),
        .xPlayer(o_enemy_x),
        .yPlayer(o_enemy_y),
        .x(o_badbullet_x),
        .y(o_badbullet_y),
        .isE(o_badbullet_isE)
    );

endmodule
