import game_pkg::*;
import sram_pkg::*;

module SramAddrEncoder (
    input i_clk,
    input i_rst_n,
    input game_pkg::ObjectID i_object_id,
    input [sram_pkg::MAP_H_WIDTH+sram_pkg::MAP_V_WIDTH-1:0] i_object_pixel_index,
    output [sram_pkg::SRAM_ADDR_COUNT-1:0] o_sram_addr
);
    reg [sram_pkg::SRAM_ADDR_COUNT-1:0] sram_addr_r, sram_addr_w;
    assign o_sram_addr = sram_addr_r;

    always @(*) begin
        case (i_object_id)
            game_pkg::OBJECT_MAP            : sram_addr_w = sram_pkg::MAP_ADDR_START + (i_object_pixel_index >> 2);
            game_pkg::OBJECT_PLAYER1        : sram_addr_w = sram_pkg::PLAYER1_ADDR_START + (i_object_pixel_index >> 2);
            game_pkg::OBJECT_PLAYER1_SHIELD : sram_addr_w = sram_pkg::PLAYER1_SHIELD_ADDR_START + (i_object_pixel_index >> 2);
            game_pkg::OBJECT_PLAYER1_SQUAT  : sram_addr_w = sram_pkg::PLAYER1_SQUAT_ADDR_START + (i_object_pixel_index >> 2);
            game_pkg::OBJECT_PLAYER2        : sram_addr_w = sram_pkg::PLAYER2_ADDR_START + (i_object_pixel_index >> 2);
            game_pkg::OBJECT_PLAYER2_SHIELD : sram_addr_w = sram_pkg::PLAYER2_SHIELD_ADDR_START + (i_object_pixel_index >> 2);
            game_pkg::OBJECT_PLAYER2_SQUAT  : sram_addr_w = sram_pkg::PLAYER2_SQUAT_ADDR_START + (i_object_pixel_index >> 2);
            game_pkg::OBJECT_BULLET1        : sram_addr_w = sram_pkg::BULLET1_ADDR_START + (i_object_pixel_index >> 2);
            game_pkg::OBJECT_BULLET2        : sram_addr_w = sram_pkg::BULLET2_ADDR_START + (i_object_pixel_index >> 2);
            game_pkg::OBJECT_WIN_CAPTION    : sram_addr_w = sram_pkg::WIN_CAPTION_ADDR_START + (i_object_pixel_index >> 2);
            game_pkg::OBJECT_LOSE_CAPTION   : sram_addr_w = sram_pkg::LOSE_CAPTION_ADDR_START + (i_object_pixel_index >> 2);
            game_pkg::OBJECT_IDLE_BG        : sram_addr_w = sram_pkg::IDLE_BG_ADDR_START + (i_object_pixel_index >> 2);
            game_pkg::OBJECT_START_CAPTION  : sram_addr_w = sram_pkg::START_CAPTION_ADDR_START + (i_object_pixel_index >> 2);
            game_pkg::OBJECT_START_BG       : sram_addr_w = sram_pkg::START_BG_ADDR_START + (i_object_pixel_index >> 2);
        endcase
    end

    always @(posedge i_clk or negedge i_rst_n) begin
        if (!i_rst_n) begin
            sram_addr_r <= 0;
        end
        else begin
            sram_addr_r <= sram_addr_w;
        end
    end
endmodule