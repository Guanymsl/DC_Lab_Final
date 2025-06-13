import game_pkg::*;
import sram_pkg::*;

module GameControl (
    input logic clk,
    input logic rst_n,

    input logic right,
    input logic left,
    input logic jump,
    input logic squat,
    input logic attack,
    input logic defend,
    input logic select,

    output logic        [ 1:0] o_state,
    output logic               o_is_gaming,

    output logic signed [10:0] o_player_x,
    output logic signed [ 9:0] o_player_y,
    output logic        [ 1:0] o_player_hp,
    output logic               o_player_shield,
    output logic               o_player_squat,

    output logic signed [10:0] o_enemy_x,
    output logic signed [ 9:0] o_enemy_y,
    output logic        [ 1:0] o_enemy_hp,
    output logic               o_enemy_shield,
    output logic               o_enemy_squat,

    output logic signed [10:0] o_goodbullet_x,
    output logic signed [ 9:0] o_goodbullet_y,
    output logic               o_goodbullet_isE,

    output logic signed [10:0] o_badbullet_x,
    output logic signed [ 9:0] o_badbullet_y,
    output logic               o_badbullet_isE
);

    localparam S_START = 2'b00;
    localparam S_PLAY  = 2'b01;
    localparam S_WIN   = 2'b10;
    localparam S_LOSE  = 2'b11;

    logic [1:0] state_r, state_w;

    assign o_is_gaming = (state_r == S_PLAY);

    always_comb begin
        state_w = state_r;
        case (state_r)
            //S_START:
                // if (select) state_w = S_PLAY;
            S_PLAY: begin
                if (player_hp_r == 0) begin
                    state_w = S_LOSE;
                end else if (enemy_hp_r == 0) begin
                    state_w = S_WIN;
                end
            end
            //S_WIN, S_LOSE:
                // if (select) state_w = S_START;
        endcase
    end

    always_ff @(posedge clk or negedge rst_n, posedge select) begin
        if (!rst_n) begin
            state_r <= S_START;
        end else if (select) begin
            state_r <= S_PLAY;
        end else begin
            state_r <= state_w;
        end
    end

    logic rightRd, leftRd, jumpRd, squatRd, attackRd, defendRd;

    logic playerIsJ, playerIsHit;
    logic enemyIsJ, enemyIsHit;

    logic [1:0] player_hp_r, player_hp_w;
    logic [1:0] enemy_hp_r, enemy_hp_w;

    assign o_state = state_r;

    assign o_player_hp = player_hp_r;
    assign o_enemy_hp = enemy_hp_r;

    logic dummy1, dummy2, dummy3, dummy4;

    Random random1 (
        .enable(cntRd[6]),
        .i_rst_n(rst_n),
        .o_random_out({rightRd, dummy3, jumpRd, dummy1})
    );

    Random random2 (
        .enable(cntRd[6]),
        .i_rst_n(rst_n),
        .o_random_out({squatRd, leftRd, dummy4, dummy2})
    );

    assign attackRd = 1;
    assign defendRd = 0;

    logic [6:0] cntRd;
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cntRd <= 0;
        end else begin
            if (state_r == S_PLAY) begin
                if (cntRd == 7'b1111111) begin
                    cntRd <= 0;
                end else begin
                    cntRd <= cntRd + 1;
                end
            end else begin
                cntRd <= 0;
            end
        end
    end

    Player player (
        .clk(clk),
        .rst_n(rst_n),
        .right(right),
        .left(left),
        .jump(jump),
        .squat(squat),
        .defend(defend),
        .x(o_player_x),
        .y(o_player_y),
        .isD(o_player_shield),
        .isQ(o_player_squat),
        .isJ(playerIsJ)
    );

    Enemy enemy (
        .clk(clk),
        .rst_n(rst_n),
        .right(rightRd),
        .left(leftRd),
        .jump(jumpRd),
        .squat(squatRd),
        .defend(defendRd),
        .x(o_enemy_x),
        .y(o_enemy_y),
        .isD(o_enemy_shield),
        .isQ(o_enemy_squat),
        .isJ(enemyIsJ)
    );

    GoodBullet goodbullet (
        .clk(clk),
        .rst_n(rst_n),
        .attack(attack),
        .defend(defend),
        .xPlayer(o_player_x),
        .yPlayer(o_player_y),
        .xEnemy(o_enemy_x),
        .yEnemy(o_enemy_y),
        .isQ(o_player_squat),
        .x(o_goodbullet_x),
        .y(o_goodbullet_y),
        .isE(o_goodbullet_isE),
        .isHit(enemyIsHit)
    );

    BadBullet badbullet (
        .clk(clk),
        .rst_n(rst_n),
        .attack(attackRd),
        .defend(defendRd),
        .xEnemy(o_enemy_x),
        .yEnemy(o_enemy_y),
        .xPlayer(o_player_x),
        .yPlayer(o_player_y),
        .isQ(o_player_squat),
        .x(o_badbullet_x),
        .y(o_badbullet_y),
        .isE(o_badbullet_isE),
        .isHit(playerIsHit)
    );

    always_comb begin
        player_hp_w = player_hp_r;
        enemy_hp_w  = enemy_hp_r;

        if (state_r == S_PLAY) begin
            if (playerIsHit && !o_player_shield && player_hp_r != 0) begin
                player_hp_w = player_hp_r - 1;
            end
            if (enemyIsHit && !o_enemy_shield && enemy_hp_r != 0) begin
                enemy_hp_w = enemy_hp_r - 1;
            end
        end
    end

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            player_hp_r <= 2'b11;
            enemy_hp_r  <= 2'b11;
        end else begin
            player_hp_r <= player_hp_w;
            enemy_hp_r  <= enemy_hp_w;
        end
    end

endmodule