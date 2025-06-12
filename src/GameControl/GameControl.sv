module GameControl #(
    parameter int N_ENEMY          = 4,
    parameter int POS_WIDTH        = 10,
    parameter int HP_WIDTH         = 2,   // 0–3
    parameter int TIMER_WIDTH      = 7,   // up to 99 s
    parameter int SCORE_WIDTH      = 16
)(
    input  logic                   clk,
    input  logic                   render_clk,
    input  logic                   rst_n,

    // --- User inputs ---
    input  logic                   i_start,      // Start 按鈕
    input  logic [1:0]             i_dir,        // 00=↑,01=→,10=↓,11=←
    input  logic                   i_attack,     // 攻擊 pulse
    input  logic                   i_defend,     // 防禦 hold

    // --- Render outputs (to VGA/monitor) ---
    output logic [1:0]             o_state,      // 00=Start,01=Play,10=Win,11=Lose
    output logic [POS_WIDTH-1:0]   o_player_x,
    output logic [POS_WIDTH-1:0]   o_player_y,
    output logic [HP_WIDTH-1:0]    o_player_hp,
    output logic                   o_player_shield,
    output logic [N_ENEMY-1:0][POS_WIDTH-1:0] o_enemy_x,
    output logic [N_ENEMY-1:0][POS_WIDTH-1:0] o_enemy_y,
    output logic [N_ENEMY-1:0][HP_WIDTH-1:0]  o_enemy_hp,
    output logic [TIMER_WIDTH-1:0] o_timer,
    output logic [SCORE_WIDTH-1:0] o_score
);

    localparam S_START = 2'b00;
    localparam S_PLAY  = 2'b01;
    localparam S_WIN   = 2'b10;
    localparam S_LOSE  = 2'b11;

    state_e state_r, state_w;

    always_comb begin
        state_w = state_r;
        case (state_r)
            S_START:
                if (i_start) state_w = S_PLAY;
            S_PLAY: begin
                if (player_hp_r == 0)
                    state_w = S_LOSE;
                else if (enemy_hp_sum_r == 0)
                    state_w = S_WIN;
                else if (timer_r == 0)
                    state_w = S_LOSE;
            end
            S_WIN, S_LOSE:
                if (i_start) state_w = S_START;
        endcase
    end

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            state_r <= S_START;
        else
            state_r <= state_w;
    end

    assign o_state = state_r;

    logic isJ_r, isJ_w;

    

    // Render outputs registered on render_clk
    always_ff @(posedge render_clk or negedge rst_n) begin
        if (!rst_n) begin
        o_player_hp     <= {HP_WIDTH{1'b0}};
        o_player_shield <= 1'b0;
        o_player_x      <= '0;
        o_player_y      <= '0;
        for (i = 0; i < N_ENEMY; i++) begin
            o_enemy_hp[i] <= '0;
            o_enemy_x[i]  <= '0;
            o_enemy_y[i]  <= '0;
        end
        o_timer         <= '0;
        o_score         <= '0;
        end else begin
        o_player_hp     <= player_hp_r;
        o_player_shield <= player_shield_r;
        o_player_x      <= player_x_r;
        o_player_y      <= player_y_r;
        for (i = 0; i < N_ENEMY; i++) begin
            o_enemy_hp[i] <= enemy_hp_r[i];
            o_enemy_x[i]  <= enemy_x_r[i];
            o_enemy_y[i]  <= enemy_y_r[i];
        end
        o_timer         <= timer_r;
        o_score         <= score_r;
        end
    end
endmodule
