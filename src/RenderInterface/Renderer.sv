import game_param::*;
import sram_param::*;

module Renderer (
        input i_clk,
        input i_rst_n,
        
        input signed [sram_param::MAP_H_WIDTH-1:0] i_player1_x,
        input signed [sram_param::MAP_V_WIDTH-1:0] i_player1_y,
        input [game_param::HP_WIDTH-1:0] i_player1_hp,
        input i_player1_shield,
        input i_player1_squat,

        input signed [sram_param::MAP_H_WIDTH-1:0] i_player2_x,
        input signed [sram_param::MAP_V_WIDTH-1:0] i_player2_y,
        input [game_param::HP_WIDTH-1:0] i_player2_hp,
        input i_player2_shield,
        input i_player2_squat,

        input signed [sram_param::MAP_H_WIDTH-1:0] i_bullet1_x,
        input signed [sram_param::MAP_H_WIDTH-1:0] i_bullet1_y,
        input i_bullet1_valid,

        input signed [sram_param::MAP_H_WIDTH-1:0] i_bullet2_x,
        input signed [sram_param::MAP_H_WIDTH-1:0] i_bullet2_y,
        input i_bullet2_valid,

        // opacity masks
        input i_player1_opacity_mask [0:sram_param::PLAYER_SIZE-1][0:sram_param::PLAYER_SIZE-1],
        input i_player2_opacity_mask [0:sram_param::PLAYER_SIZE-1][0:sram_param::PLAYER_SIZE-1],
        input i_bullet1_opacity_mask [0:sram_param::BULLET_SIZE-1][0:sram_param::BULLET_SIZE-1],
        input i_bullet2_opacity_mask [0:sram_param::BULLET_SIZE-1][0:sram_param::BULLET_SIZE-1],

        // Input from VGA:
        input [sram_param::MAP_H_WIDTH-1:0] i_VGA_H,
        input [sram_param::MAP_V_WIDTH-1:0] i_VGA_V,
        
        // Output for VGA:
        output [23:0] o_decompressed_color,
        
        // Input from SRAM:
        input [sram_param::SRAM_DATA_WIDTH-1:0] i_sram_data, // may be delayed 2 cycles?
        output [sram_param::SRAM_ADDR_COUNT-1:0] o_sram_addr, // i_sram_data isn't directly from o_sram_addr!?

        // game status
        input i_is_gaming,
        input [1:0] i_game_state // output state
);

    // pixel id with shifting register
    game_param::ObjectID object_id_before_sram;
    game_param::ObjectID object_id_during_sram;
    game_param::ObjectID object_id_after_sram;

    // pixel index with shifing registers
    wire [sram_param::MAP_H_WIDTH+sram_param::MAP_V_WIDTH-1:0] object_pixel_index_before_sram;
    reg [sram_param::MAP_H_WIDTH+sram_param::MAP_V_WIDTH-1:0] object_pixel_index_during_sram;
    reg [sram_param::MAP_H_WIDTH+sram_param::MAP_V_WIDTH-1:0] object_pixel_index_after_sram;
    wire [sram_param::COLOR_WIDTH-1:0] compressed_color;

    // position transformer
    CoordTransformer u_CoordTransformer (
        .i_player1_x (i_player1_x),
        .i_player1_y (i_player1_y),
        .i_player2_x (i_player2_x),
        .i_player2_y (i_player2_y),
        .i_bullet1_x (i_bullet1_x),
        .i_bullet1_y (i_bullet1_y),
        .i_bullet1_valid (i_bullet1_valid),
        .i_bullet2_x (i_bullet2_x),
        .i_bullet2_y (i_bullet2_y),
        .i_bullet2_valid (i_bullet2_valid),
        .i_player1_opacity_mask (i_player1_opacity_mask),
        .i_player2_opacity_mask (i_player2_opacity_mask),
        .i_bullet1_opacity_mask (i_bullet1_opacity_mask),
        .i_bullet2_opacity_mask (i_bullet2_opacity_mask),
        .i_VGA_H (i_VGA_H),
        .i_VGA_V (i_VGA_V),
        .i_player1_hp (i_player1_hp),
        .i_player1_shield (i_player1_shield),
        .i_player1_squat (i_player1_squat),
        .i_player2_hp (i_player2_hp),
        .i_player2_shield (i_player2_shield),
        .i_player2_squat (i_player2_squat),
        .i_is_gaming (i_is_gaming),
        .i_game_state (i_game_state),
        .o_object_id (object_id_before_sram),
        .o_object_pixel_index (object_pixel_index_before_sram)
    );
    // color data
    ColorMapping u_ColorMapping (
        .i_object_id        (object_id_after_sram),
        .i_compressed_color    (compressed_color),
        .o_decompressed_color    (o_decompressed_color)
    );

    // sram interface
    SramAddrGenerator u_SramAddrGenerator (
        .i_clk                   (i_clk),
        .i_rst_n                 (i_rst_n),
        .i_object_id             (object_id_before_sram),
        .i_object_pixel_index    (object_pixel_index_before_sram),
        .o_sram_addr             (o_sram_addr)
    );
    // pick correct data
    SramDataPicker u_SramDataPicker (
        .i_object_pixel_index    (object_pixel_index_after_sram),
        .i_sram_data             (i_sram_data),
        .o_compressed_color         (compressed_color)
    );

    // sequential logic for shift registers
    always @(posedge i_clk or negedge i_rst_n) begin
        if (!i_rst_n) begin
            object_id_during_sram <= game_param::OBJECT_MAP;
            object_id_after_sram <= game_param::OBJECT_MAP;

            object_pixel_index_during_sram <= 0;
            object_pixel_index_after_sram <= 0;
        end
        else begin
            object_id_during_sram <= object_id_before_sram;
            object_id_after_sram <= object_id_during_sram;

            object_pixel_index_during_sram <= object_pixel_index_before_sram;
            object_pixel_index_after_sram <= object_pixel_index_during_sram;
        end
    end

endmodule