import game_pkg::*;
import sram_pkg::*;

module top (
    input i_clk,
    input i_rst_n,
    input i_start,
    input i_restart,

    // reserved for our GPIO inputs //
    input i_right,
    input i_left,
    input i_jump,
    input i_squat,
    input i_attack,
    input i_defend,
    input i_select,

    // SRAM interface
    output [sram_pkg::SRAM_ADDR_COUNT-1:0] o_SRAM_ADDR,
	inout  [sram_pkg::SRAM_DATA_WIDTH-1:0] io_SRAM_DQ,
	output o_SRAM_WE_N,

    // VGA interface
    output o_H_sync,
    output o_V_sync,
    output [23:0] o_RGB,
    output o_RGB_valid
);
    logic [31:0] o_frame_counter;
    wire render_clk;

    //// SRAM part, maybe don't have to change
    wire sram_writing;
    wire [23:0] decoded_color; // send to VGA cell

    reg [sram_pkg::SRAM_ADDR_COUNT-1:0] addr_encode, addr_decode;
    reg [sram_pkg::SRAM_DATA_WIDTH-1:0] data_encode, data_decode;

    assign o_SRAM_WE_N = !sram_writing;
    assign o_SRAM_ADDR = sram_writing ? addr_encode : addr_decode;
    assign io_SRAM_DQ  = sram_writing ? data_encode : 16'dz;
    assign data_decode = sram_writing ? 16'd0 : io_SRAM_DQ;
    
    wire signed [sram_pkg::MAP_H_WIDTH-1:0] player1_x;
    wire signed [sram_pkg::MAP_V_WIDTH-1:0] player1_y;
    wire signed [sram_pkg::MAP_H_WIDTH-1:0] player2_x;
    wire signed [sram_pkg::MAP_V_WIDTH-1:0] player2_y;
    wire signed [sram_pkg::MAP_H_WIDTH-1:0] bullet1_x;
    wire signed [sram_pkg::MAP_V_WIDTH-1:0] bullet1_y;
    wire signed [sram_pkg::MAP_H_WIDTH-1:0] bullet2_x;
    wire signed [sram_pkg::MAP_V_WIDTH-1:0] bullet2_y;

    wire [sram_pkg::MAP_H_WIDTH-1:0] H_to_be_rendered;
    wire [sram_pkg::MAP_V_WIDTH-1:0] V_to_be_rendered;

    game_pkg::ObjectID pixel_object_id;

    reg player1_opacity_mask_w [0:sram_pkg::PLAYER_SIZE-1][0:sram_pkg::PLAYER_SIZE-1];
    reg player1_opacity_mask_r [0:sram_pkg::PLAYER_SIZE-1][0:sram_pkg::PLAYER_SIZE-1];
    reg player2_opacity_mask_w [0:sram_pkg::PLAYER_SIZE-1][0:sram_pkg::PLAYER_SIZE-1];
    reg player2_opacity_mask_r [0:sram_pkg::PLAYER_SIZE-1][0:sram_pkg::PLAYER_SIZE-1];
    reg bullet1_opacity_mask_w [0:sram_pkg::BULLET_SIZE-1][0:sram_pkg::BULLET_SIZE-1];
    reg bullet1_opacity_mask_r [0:sram_pkg::BULLET_SIZE-1][0:sram_pkg::BULLET_SIZE-1];
    reg bullet2_opacity_mask_w [0:sram_pkg::BULLET_SIZE-1][0:sram_pkg::BULLET_SIZE-1];
    reg bullet2_opacity_mask_r [0:sram_pkg::BULLET_SIZE-1][0:sram_pkg::BULLET_SIZE-1];
    
    wire [game_pkg::HP_WIDTH-1:0] player1_hp;
    wire player1_shield;
    wire player1_sqat;
    wire [game_pkg::HP_WIDTH-1:0] player2_hp;
    wire player2_shield;
    wire player2_sqat;
    wire bullet1_valid;
    wire bullet2_valid;

    // status of game, output of GameControl
    wire is_gaming;
    wire game_state;

    GameControl u_GameControl (
        .clk(render_clk),
        .rst_n(i_rst_n),
        .right(i_right),
        .left(i_left),
        .jump(i_jump),
        .squat(i_squat),
        .attack(i_attack),
        .defend(i_defend),
        .select(i_select),
        // the player's current status
        .o_player_x(player1_x),
        .o_player_y(player1_y),
        .o_player_hp(player1_hp),
        .o_player_shield(player1_shield),
        .o_player_squat(player1_squat),

        .o_enemy_x(player2_x),
        .o_enemy_y(player2_y),
        .o_enemy_hp(player2_hp),
        .o_enemy_shield(player2_shield),
        .o_enemy_squat(player2_squat),

        .o_goodbullet_x(bullet1_x),
        .o_goodbullet_y(bullet1_y),
        .o_goodbullet_isE(bullet1_valid),

        .o_badbullet_x(bullet2_x),
        .o_badbullet_y(bullet2_y),
        .o_badbullet_isE(bullet2_valid),

        // Gaming status
        .o_state            (game_state),
        .o_is_gaming        (is_gaming) 
    );

    // FrameDecoder usage: get game and player's status and to be rendered place from VGA, output decoded color to VGA, output address to SRAM, receive data from SRAM
    FrameDecoder u_FrameDecoder (
        .i_clk(i_clk),
        .i_rst_n(i_rst_n),

        .i_player1_x(player1_x),
        .i_player1_y(player1_y),
        .i_player1_hp(player1_hp),
        .i_player1_shield(player1_shield),
        .i_player1_squat(player1_sqat),

        .i_player2_x(player2_x),
        .i_player2_y(player2_y),
        .i_player2_hp(player2_hp),
        .i_player2_shield(player2_shield),
        .i_player2_squat(player2_sqat),

        .i_bullet1_x(bullet1_x),
        .i_bullet1_y(bullet1_y),
        .i_bullet1_valid(bullet1_valid),

        .i_bullet2_x(bullet2_x),
        .i_bullet2_y(bullet2_y),
        .i_bullet2_valid(bullet2_valid),

        .i_player1_opacity_mask(player1_opacity_mask_r),
        .i_player2_opacity_mask(player2_opacity_mask_r),
        .i_bullet1_opacity_mask(bullet1_opacity_mask_r),
        .i_bullet2_opacity_mask(bullet2_opacity_mask_r),

        // Input from VGA:
        .i_VGA_H(H_to_be_rendered),
        .i_VGA_V(V_to_be_rendered),
        
        // Output for VGA:
        .o_decoded_color(decoded_color),
        
        // Input from SRAM:
        .i_sram_data(data_decode), // may be delayed 2 cycles?
        .o_sram_addr(addr_decode), // i_sram_data isn't directly from o_sram_addr!?

        // game status
        .i_is_gaming(is_gaming),
        .i_game_state(game_state) // output state
    );

    // VGA is very nice, but notice the 2 cycles delay
    VGA u_VGA (
        .i_clk                     (i_clk),
        .i_rst_n                   (i_rst_n),
        .i_color                   (decoded_color),
        .o_H_sync                  (o_H_sync),
        .o_V_sync                  (o_V_sync),
        .o_RGB                     (o_RGB),
        .o_RGB_valid               (o_RGB_valid),
        .o_frame_counter           (o_frame_counter),
        .o_H_to_be_rendered        (H_to_be_rendered),
        .o_V_to_be_rendered        (V_to_be_rendered),
        .o_render_clk              (render_clk)
    );

    // opacity map combinatorial logic

    // need to be modified

    wire [sram_pkg::COLOR_WIDTH-1:0] player1_lut_data [0:sram_pkg::PLAYER_SIZE-1][0:sram_pkg::PLAYER_SIZE-1];
    player1_lut u_player1_lut (
        .pixel_data    (player1_lut_data)
    );

    wire [sram_pkg::COLOR_WIDTH-1:0] player2_lut_data [0:sram_pkg::PLAYER_SIZE-1][0:sram_pkg::PLAYER_SIZE-1];
    player2_lut u_player2_lut (
        .pixel_data    (player2_lut_data)
    );

    wire [sram_pkg::COLOR_WIDTH-1:0] bullet1_lut_data [0:sram_pkg::BULLET_SIZE-1][0:sram_pkg::BULLET_SIZE-1];
    bullet1_lut u_bullet1_lut (
        .pixel_data    (bullet1_lut_data)
    );

    wire [sram_pkg::COLOR_WIDTH-1:0] bullet2_lut_data [0:sram_pkg::BULLET_SIZE-1][0:sram_pkg::BULLET_SIZE-1];
    bullet2_lut u_bullet2_lut (
        .pixel_data    (bullet2_lut_data)
    );

    genvar i, j;
    generate
        for (i = 0; i < sram_pkg::PLAYER_SIZE; i = i + 1) begin: opacity_mask_generate_i
            for (j = 0; j < sram_pkg::PLAYER_SIZE; j = j + 1) begin: opacity_mask_generate_j
                assign player1_opacity_mask_w[i][j] = (player1_lut_data[i][j] != 0)?1'b1:1'b0;
                assign player2_opacity_mask_w[i][j] = (player2_lut_data[i][j] != 0)?1'b1:1'b0;
            end
        end
    endgenerate

    genvar p, q;
    generate
        for (p = 0; p < sram_pkg::BULLET_SIZE; p = p + 1) begin: opacity_mask_generate_p
            for (q = 0; q < sram_pkg::BULLET_SIZE; q = q + 1) begin: opacity_mask_generate_q
                assign bullet1_opacity_mask_w[p][q] = (bullet1_lut_data[p][q] != 0)?1'b1:1'b0;
                assign bullet2_opacity_mask_w[p][q] = (bullet2_lut_data[p][q] != 0)?1'b1:1'b0;
            end
        end
    endgenerate

    // opacity map sequential logic
    always @(posedge i_clk or negedge i_rst_n) begin
        if (!i_rst_n) begin
            for (integer i = 0; i < sram_pkg::PLAYER_SIZE; i = i + 1) begin
                for (integer j = 0; j < sram_pkg::PLAYER_SIZE; j = j + 1) begin
                        player1_opacity_mask_r[i][j] <= 0;
                        player2_opacity_mask_r[i][j] <= 0;
                end
            end
            for (integer i = 0; i < sram_pkg::BULLET_SIZE; i = i + 1) begin
                for (integer j = 0; j < sram_pkg::BULLET_SIZE; j = j + 1) begin
                        bullet1_opacity_mask_r[i][j] <= 0;
                        bullet1_opacity_mask_r[i][j] <= 0;
                end
            end
        end

        else begin
            for (integer i = 0; i < sram_pkg::PLAYER_SIZE; i = i + 1) begin
                for (integer j = 0; j < sram_pkg::PLAYER_SIZE; j = j + 1) begin
                        player1_opacity_mask_r[i][j] <= player1_opacity_mask_w[i][j];
                        player2_opacity_mask_r[i][j] <= player2_opacity_mask_w[i][j];
                end
            end
            for (integer i = 0; i < sram_pkg::BULLET_SIZE; i = i + 1) begin
                for (integer j = 0; j < sram_pkg::BULLET_SIZE; j = j + 1) begin
                        bullet1_opacity_mask_r[i][j] <= bullet1_opacity_mask_w[i][j];
                        bullet1_opacity_mask_r[i][j] <= bullet2_opacity_mask_w[i][j];
                end
            end
        end
    end
endmodule