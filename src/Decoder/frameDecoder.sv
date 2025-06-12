import game_pkg::*;
import sram_pkg::*;

module FrameDecoder (
        input i_clk,
        input i_rst_n,
        
        input signed [sram_pkg::MAP_H_WIDTH-1:0] i_player1_x,
        input signed [sram_pkg::MAP_V_WIDTH-1:0] i_player1_y,
        input [game_pkg::HP_WIDTH-1:0] i_player1_hp,
        input i_player1_shield,
        input i_player1_squat,

        input signed [sram_pkg::MAP_H_WIDTH-1:0] i_player2_x,
        input signed [sram_pkg::MAP_V_WIDTH-1:0] i_player2_y,
        input [game_pkg::HP_WIDTH-1:0] i_player2_hp,
        input i_player2_shield,
        input i_player2_squat,

        input signed [sram_pkg::MAP_H_WIDTH-1:0] i_bullet1_x,
        input signed [sram_pkg::MAP_H_WIDTH-1:0] i_bullet1_y,
        input i_bullet1_valid,

        input signed [sram_pkg::MAP_H_WIDTH-1:0] i_bullet2_x,
        input signed [sram_pkg::MAP_H_WIDTH-1:0] i_bullet2_y,
        input i_bullet2_valid,

        input i_player1_opacity_mask [0:sram_pkg::PLAYER_SIZE-1][0:sram_pkg::PLAYER_SIZE-1],
        input i_player2_opacity_mask [0:sram_pkg::PLAYER_SIZE-1][0:sram_pkg::PLAYER_SIZE-1],
        input i_bullet1_opacity_mask [0:sram_pkg::BULLET_SIZE-1][0:sram_pkg::BULLET_SIZE-1],
        input i_bullet2_opacity_mask [0:sram_pkg::BULLET_SIZE-1][0:sram_pkg::BULLET_SIZE-1],

        // Input from VGA:
        input [sram_pkg::MAP_H_WIDTH-1:0] i_VGA_H,
        input [sram_pkg::MAP_V_WIDTH-1:0] i_VGA_V,
        
        // Output for VGA:
        output [23:0] o_decoded_color,
        
        // Input from SRAM:
        input [sram_pkg::SRAM_DATA_WIDTH-1:0] i_sram_data, // may be delayed 2 cycles?
        output [sram_pkg::SRAM_ADDR_COUNT-1:0] o_sram_addr, // i_sram_data isn't directly from o_sram_addr!?

        // game status
        input i_is_gaming,
        input [1:0] i_game_state // output state
);

    // pixel id and flip-flop
    game_pkg::ObjectID object_id_before_sram;
    game_pkg::ObjectID object_id_during_sram;
    game_pkg::ObjectID object_id_after_sram;

    // pixel index and flip-flop
    wire [sram_pkg::MAP_H_WIDTH+sram_pkg::MAP_V_WIDTH-1:0] object_pixel_index_before_sram;
    reg [sram_pkg::MAP_H_WIDTH+sram_pkg::MAP_V_WIDTH-1:0] object_pixel_index_during_sram;
    reg [sram_pkg::MAP_H_WIDTH+sram_pkg::MAP_V_WIDTH-1:0] object_pixel_index_after_sram;

    PixelDecoder u_PixelDecoder (
        .i_car1_x                (i_car1_x),
        .i_car1_y                (i_car1_y),
        .i_car2_x                (i_car2_x),
        .i_car2_y                (i_car2_y),
        .i_car1_opacity_mask     (i_car1_opacity_mask),
        .i_car2_opacity_mask     (i_car2_opacity_mask),
        .i_car1_v_m              (i_car1_v_m),
        .i_car2_v_m              (i_car2_v_m),
        .i_car1_hp_m             (i_car1_hp_m),
        .i_car2_hp_m             (i_car2_hp_m),
        .i_VGA_H                 (i_VGA_H),
        .i_VGA_V                 (i_VGA_V),
        .i_is_gaming             (i_is_gaming),
        .i_game_result           (i_game_result),
        .o_object_id             (object_id_before_sram),
        .o_object_pixel_index    (object_pixel_index_before_sram)
    );

    SramAddrEncoder u_SramAddrEncoder (
        .i_clk                   (i_clk),
        .i_rst_n                 (i_rst_n),
        .i_object_id             (object_id_before_sram),
        .i_object_pixel_index    (object_pixel_index_before_sram),
        .o_sram_addr             (o_sram_addr)
    );

    wire [sram_pkg::COLOR_WIDTH-1:0] encoded_color;

    SramDataDecoder u_SramDataDecoder (
        .i_object_pixel_index    (object_pixel_index_after_sram),
        .i_sram_data             (i_sram_data),
        .o_encoded_color         (encoded_color)
    );

    ColorDecoder u_ColorDecoder (
        .i_object_id        (object_id_after_sram),
        .i_encoded_color    (encoded_color),
        .o_decoded_color    (o_decoded_color)
    );

    always @(posedge i_clk or negedge i_rst_n) begin
        if (!i_rst_n) begin
            object_id_during_sram <= game_pkg::OBJECT_MAP;
            object_id_after_sram <= game_pkg::OBJECT_MAP;

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